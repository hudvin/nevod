unit AccountManager;

interface

uses
  TypInfo, SysUtils, cxGridCustomTableView, cxGridTableView, Messages,Windows,
   ADODB,DB,Exceptions,Shared,gnugettext;

type
  TAccountManager = class(TBFCoder)
  private
    AccountTable: TADOTable;
    adProc: TADOQuery;
    FadAccounts: TADOQuery;
    function GetAccountById(AccountId:integer): TAccountParams;
    function GetItems(Index: Integer): TAccountParams;
    function GetCount: Integer;
    procedure SetAccountById(AccountId:integer; Value: TAccountParams);
  protected
    function AccountIdExists(AccountId:integer): Boolean;
    function AccountNameExists(AccountName:String): Boolean;
  public
    constructor Create(adAccounts:TADOQuery); virtual;
    destructor Destroy; override;
    function AccountName2Id(AccountName:String): Integer;
    procedure AddAccount(NewAccount:TAccountParams);
    function CheckParams(Account:TAccountParams;NewAccount:boolean=False): Boolean;
    function CheckStatus(Status:TAccountStatus;AccountId:Integer): Boolean;
    procedure DeleteAccount(AccountsId:array of Integer);
    function Id2AccountName(AccountId:integer): string;
    procedure ModifyAccount(Params:TAccountParams);
    procedure SetStatus(AccountId:integer;AccountStatus:TAccountStatus);
    property AccountById[AccountId:integer]: TAccountParams read GetAccountById
        write SetAccountById;
    property Items[Index: Integer]: TAccountParams read GetItems;
    property Count: Integer read GetCount;
  end;

implementation
uses main;

constructor TAccountManager.Create(adAccounts:TADOQuery);
begin
  inherited Create;
  FadAccounts:=adAccounts;
  AccountTable:=TADOTable.Create(nil);
  AccountTable.Connection:=FadAccounts.Connection;
  AccountTable.TableName:='Accounts';
  adProc:=TADOQuery.Create(nil);
  adProc.Connection:=FadAccounts.Connection;


  SetKey(Shared.CriptKey);
end;

destructor TAccountManager.Destroy;
begin
  inherited Destroy ;
  AccountTable.Free;
  adProc.Free;
  FadAccounts:=nil;
end;

function TAccountManager.AccountIdExists(AccountId:integer): Boolean;
begin
  with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT COUNT(Id) FROM Accounts WHERE Id=:AccountId';
    Parameters.ParamByName('AccountId').Value:=AccountId;
    Active:=True;
    if Fields[0].AsInteger>0 then Result:=True else Result:=False;
    Active:=False;
   end;
end;

function TAccountManager.AccountName2Id(AccountName:String): Integer;
begin
 if AccountNameExists(AccountName) then
  with adProc  do
   begin
    SQl.Text:='SELECT Id FROM Accounts WHERE AccountName=:AccountName';
    Parameters.ParamByName('AccountName').Value:=AccountName;
    ExecSQL;
    Open;
    Result:=Fields[0].AsInteger;
    Close;
   end
 else Result:=-1;
end;

function TAccountManager.AccountNameExists(AccountName:String): Boolean;
begin
  with adProc do
   begin
    SQL.Text:='SELECT COUNT(Id) FROM Accounts WHERE AccountName=:AccountName';
    Parameters.ParamByName('AccountName').Value:=AccountName;
    ExecSQL;
    Open;
    if Fields[0].AsInteger>0 then Result:=True
     else Result:=False;
    Close;
   end;
end;

procedure TAccountManager.AddAccount(NewAccount:TAccountParams);
begin
  if CheckParams(NewAccount,True) then
   with adProc.Parameters do
    begin
     adProc.SQL.Text:=' INSERT INTO Accounts (AccountName,Username,Pass,Host,Port,Timeout) '+
                      'VALUES(:AccountName,:Username,:Pass,:Host,:Port,:Timeout)';
     ParamByName('AccountName').Value:=NewAccount.AccountName;
     ParamByName('Username').Value:=NewAccount.Username;
     ParamByName('Pass').Value:=Crypt(NewAccount.Password);
     ParamByName('Host').Value:=NewAccount.Host;
     ParamByName('Port').Value:=NewAccount.Port;
     ParamByName('Timeout').Value:=NewAccount.Timeout;
     adProc.ExecSQL;
     FadAccounts.Requery;
    end;

end;

function TAccountManager.CheckParams(Account:TAccountParams;
    NewAccount:boolean=False): Boolean;
begin
  Result:=False;
  if Trim(Account.AccountName)='' then
    Raise EInvalidAccountParams.Create(_('Incorrect AccountName'));
  if Account.Timeout<1 then
    Raise EInvalidAccountParams.Create(_('Значение таймаута должно быть больше 1'));
  with adProc  do
   begin
    if NewAccount then   // если новая учетная запись
     begin       // искать аккаунт с данным именем - в виде подзапроса
      SQL.Text :='SELECT COUNT(Id) FROM Accounts ' +
                    ' WHERE AccountName=:AccountName';
      Parameters.ParamByName('AccountName').Value:=Account.AccountName;
      Open;
      if Fields[0].AsInteger>0 then
       begin
        Close;
        raise EInvalidAccountParams.Create(_('Account Exists'));
       end;
     end
    else  // если  модифицируется старая запись
     begin
       // проверить есть ли записи с таким именем но другим id
      SQL.Text :='SELECT COUNT(Id) FROM Accounts ' +
                    ' WHERE AccountName=:AccountName AND Id<>:AccountId ';
      Parameters.ParamByName('AccountName').Value:=Account.AccountName;
      Parameters.ParamByName('AccountId').Value:=Account.Id;
      Open;
      if Fields[0].AsInteger>1 then
       begin
        Close;
        raise EInvalidAccountParams.Create(_('Account with this name Already Exists'));
       end;
     end;
   end;

  if Trim(Account.Username)='' then
    Raise EInvalidAccountParams.Create(_(' Неправильное имя пользователя '));
  if Trim(Account.Host)='' then
    Raise EInvalidAccountParams.Create(_('Incorrect Host'));
  if (Account.Port<1) or (Account.Port>65536) then
    Raise EInvalidAccountParams.Create(_('Incorrect Port'));
  if (Account.Timeout<-1) then
    Raise EInvalidAccountParams.Create((' Incorrect Timeout '));

  Result:=True;
end;

function TAccountManager.CheckStatus(Status:TAccountStatus;AccountId:Integer):
    Boolean;
begin
 with adProc do
  begin
    SQL.Text:='SELECT COUNT(Id) FROM Accounts WHERE Id=:AccountId AND Status=:Status ';
    Parameters.ParamByName('AccountId').Value:=AccountId;
    Parameters.ParamByName('Status').Value:=GetEnumName(TypeInfo(TAccountStatus), Ord(Status));
    ExecSQL;
    Open;
    if Fields[0].AsInteger>0 then Result:=true
     else Result:=False;
    Close;
  end;
end;

procedure TAccountManager.DeleteAccount(AccountsId:array of Integer);
var
 i:integer;
 RowSQL:String;
begin
 for i:=Low(AccountsId) to High(AccountsId) do
   if not AccountIdExists(AccountsId[i]) then
    Raise EInvalidAccount.Create(_(' Аккаунт не существует '));

 RowSQL:='';
 for i:=Low(AccountsId) to High(AccountsId) do
  begin
   RowSQL:=RowSQL+ ' id='+IntToStr(AccountsId[i]);
   if i<>High(AccountsId) then RowSQL:=RowSQl+' OR ';
  end;

 with adProc do
  begin
   Active:=False;
   SQL.Text:='DELETE FROM Accounts WHERE ' + RowSQL;
   ExecSQL;
  end;
 FadAccounts.Requery;
end;


function TAccountManager.GetAccountById(AccountId:integer): TAccountParams;
begin
 with adProc  do
   begin
      SQL.Text :=' SELECT * FROM Accounts WHERE Id=:AccountId' ;
      Parameters.ParamByName('AccountId').Value:=AccountId;
      ExecSQL;
      Open;
      if  RecordCount=0 then
       begin
        Close;
        raise EInvalidAccount.Create(_('No Such Account !'));
       end
      else
       try
        Result.Id:=AccountId;
        Result.AccountName:=FieldByName('AccountName').AsString;
        Result.Username:=FieldByName('Username').AsString;
        Result.Password:=DeCrypt(FieldByName('Pass').AsString);
        Result.Host:=FieldByName('Host').AsString;
        Result.Port:=FieldByName('Port').AsInteger;
        Result.Timeout:=FieldByName('Timeout').AsInteger;
        Result.Status:=TAccountStatus(GetEnumValue(TypeInfo(TAccountStatus),FieldByName('Status').AsString));
       except
        on e: Exception do
         begin
          Close;
          Raise ECorreptedAccount.Create(_('Account Corrupted'));
         end;
       end;
   end;
end;



function TAccountManager.GetItems(Index: Integer): TAccountParams;
begin
 with AccountTable do
  begin
    Open;
    First;
    Requery();
    if (Index>RecordCount) or (Index<1) then
     begin
      Close;
      Raise EInvalidAccount.Create(_(' No Such Account '));
     end;
    try
     RecNo:=Index;
     Result.Id:=FieldByName('Id').AsInteger;
     Result.AccountName:=FieldByName('AccountName').AsString;
     Result.Username:=FieldByName('Username').AsString;
     Result.Password:=DeCrypt(FieldByName('Pass').AsString);
     Result.Host:=FieldByName('Host').AsString;
     Result.Port:=FieldByName('Port').AsInteger;
     Result.Timeout:=FieldByName('Timeout').AsInteger;
     Result.Status:=TAccountStatus(GetEnumValue(TypeInfo(TAccountStatus),FieldByName('Status').AsString));
    except
     on e: Exception do
      begin
       Close;
       Raise ECorreptedAccount.Create(_('Account Corrupted'));
      end;
    end;
  end;
end;

function TAccountManager.GetCount: Integer;
begin
 with adProc do
  begin
    SQL.Text:='SELECT COUNT (Id) FROM Accounts ';
    ExecSQL;
    Open;
    Result:=Fields[0].AsInteger;
    Close;
  end;
end;

function TAccountManager.Id2AccountName(AccountId:integer): string;
begin
  if AccountIdExists(AccountId) then
   with adProc  do
    begin
      SQl.Text:='SELECT AccountName FROM Accounts WHERE Id=:AccountId';
      Parameters.ParamByName('AccountId').Value:=AccountId;
      ExecSQL;
      Open;
      Result:=Fields[0].AsString;
      Close;
    end
   else Result:='';
end;

procedure TAccountManager.ModifyAccount(Params:TAccountParams);
begin
 CheckParams(Params);
 AccountById[Params.Id]:=Params;
end;

procedure TAccountManager.SetAccountById(AccountId:integer; Value:
    TAccountParams);
begin
 if CheckParams(Value) then
  with adProc.Parameters  do
   begin
      adProc.SQL.Text :='UPDATE Accounts SET  AccountName=:AccountName, Username=:Username,'+
                    'Pass=:Pass,Host=:Host,Port=:Port,Timeout=:Timeout WHERE Id=:AccountId ';
      ParamByName('AccountName').Value:=Value.AccountName;
      ParamByName('Username').Value:=Value.Username;
      ParamByName('Pass').Value:=Crypt(Value.Password);
      ParamByName('Host').Value:=Value.Host;
      ParamByName('Port').Value:=value.Port;
      ParamByName('Timeout').Value:=value.Timeout;
      ParamByName('AccountId').Value:=Value.Id;
      adProc.ExecSQL;
   end;
end;

procedure TAccountManager.SetStatus(AccountId:integer;
    AccountStatus:TAccountStatus);
begin
  with adProc do
   begin
    SQL.Text:='UPDATE Accounts SET Status=:AccountStatus WHERE Id=:AccountId';
    Parameters.ParamByName('AccountStatus').Value:=GetEnumName(TypeInfo(TAccountStatus), Ord(AccountStatus));
    Parameters.ParamByName('AccountId').Value:=AccountId;
    ExecSQL;
   end;
  SendMessage(main.FMain.Handle, WM_UpdateAccountStatus,0,0);
end;

end.

