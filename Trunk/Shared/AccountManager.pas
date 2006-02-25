unit AccountManager;

interface

uses
  TypInfo, SysUtils,  ADODB,DB,Exceptions,Shared;

type
  TAccountManager = class(TBFCoder)
  private
    AccountTable: TADOTable;
    FADOCon: TADOConnection;
    DBProc: TADOQuery;
    function GetAccountById(AccountId:integer): TAccountParams;
    function GetItems(Index: Integer): TAccountParams;
    function GetCount: Integer;
    procedure SetAccountById(AccountId:integer; Value: TAccountParams);
  protected
    function AccountIdExists(AccountId:integer): Boolean;
    function AccountNameExists(AccountName:String): Boolean;
  public
    constructor Create(ADOCon:TADOConnection); virtual;
    destructor Destroy; override;
    function AccountName2Id(AccountName:String): Integer;
    procedure AddAccount(NewAccount:TAccountParams);
    function CheckParams(Account:TAccountParams;NewAccount:boolean=False): Boolean;
    function CheckStatus(Status:TAccountStatus;AccountId:Integer): Boolean;
    procedure DeleteAccount(AccountId:Integer);
    function Id2AccountName(AccountId:integer): string;
    procedure SetStatus(AccountId:integer;AccountStatus:TAccountStatus);
    procedure UpdateAccountTable;
    property AccountById[AccountId:integer]: TAccountParams read GetAccountById
        write SetAccountById;
    property Items[Index: Integer]: TAccountParams read GetItems;
    property Count: Integer read GetCount;
  end;

implementation

constructor TAccountManager.Create(ADOCon:TADOConnection);
begin
  inherited Create;
  FADOCon:=ADOCon;
  AccountTable:=TADOTable.Create(nil);
  AccountTable.Connection:=FADOCon;
  AccountTable.TableName:='Accounts';
  UpdateAccountTable;
  DBProc:=TADOQuery.Create(nil);
  DBProc.Connection:=FADOCon;
  SetKey(Shared.CriptKey);
end;

destructor TAccountManager.Destroy;
begin
  inherited Destroy ;
  AccountTable.Free;
  DBProc.Free;
  FADOCon:=nil;
end;

function TAccountManager.AccountIdExists(AccountId:integer): Boolean;
begin
  with DBProc do
   begin
    SQL.Text:='SELECT COUNT(Id) FROM Accounts WHEHE Id=:AccountId';
    Parameters.ParamByName('AccountId').Value:=AccountId;
    ExecSQL;
    Open;
    if Fields[0].AsInteger>0 then Result:=True else Result:=False;
    Close;
   end;
end;

function TAccountManager.AccountName2Id(AccountName:String): Integer;
begin
 if AccountNameExists(AccountName) then
  with DBProc  do
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
  with DBProc do
   begin
    SQL.Text:='SELECT COUNT(Id) FROM Accounts WHERE AccountName=:AccountName';
    Parameters.ParamByName('AccountName').Value:=AccountName;
    ExecSQL;
    Open;
    if Fields[0].AsInteger>0 then Result:=True else Result:=False;
    Close;
   end;
end;

procedure TAccountManager.AddAccount(NewAccount:TAccountParams);
begin
  if CheckParams(NewAccount,True) then
   with DBProc.Parameters do
    begin
     DBProc.SQL.Text:=' INSERT INTO Accounts (AccountName,Username,Pass,Host,Port,Timeout) '+
                      'VALUES(:AccountName,:Username,:Pass,:Host,:Port,:Timeout)';
     ParamByName('AccountName').Value:=NewAccount.AccountName;
     ParamByName('Username').Value:=NewAccount.Username;
     ParamByName('Pass').Value:=Crypt(NewAccount.Password);
     ParamByName('Host').Value:=NewAccount.Host;
     ParamByName('Port').Value:=NewAccount.Port;
     ParamByName('Timeout').Value:=NewAccount.Timeout;
     DBProc.ExecSQL;
     UpdateAccountTable;
    end;
end;

function TAccountManager.CheckParams(Account:TAccountParams;
    NewAccount:boolean=False): Boolean;
begin
  Result:=False;
  if Trim(Account.AccountName)='' then
    Raise EInvalidAccountParams.Create('Incorrect AccountName');
  if Trim(Account.Username)='' then
    Raise EInvalidAccountParams.Create('Incorrect Username ');
  if Trim(Account.Host)='' then
    Raise EInvalidAccountParams.Create('Incorrect Host');
  if (Account.Port<1) or (Account.Port>65536) then
    Raise EInvalidAccountParams.Create('Incorrect Port');
  if (Account.Timeout<0) then
    Raise EInvalidAccountParams.Create(' Incorrect Timeout ');


  with DBProc  do
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
        raise EInvalidAccountParams.Create('Account Exists');
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
        raise EInvalidAccountParams.Create('Account with this name Already Exists');
       end;
     end;
   end;
  Result:=True;
end;

function TAccountManager.CheckStatus(Status:TAccountStatus;AccountId:Integer):
    Boolean;
begin
 with DBProc do
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

procedure TAccountManager.DeleteAccount(AccountId:Integer);
begin
  with DBProc do
   begin
    SQL.Text:='SELECT COUNT(Id) FROM Accounts WHERE Id=:AccountId ';
    Parameters.ParamByName('AccountId').Value:=AccountId;
    ExecSQL;
    Open;
    if Fields[0].AsInteger=0  then    // если нет такого id в таблице
     begin
      Close;
      Raise EInvalidAccount.Create(' No such Account ');
     end
    else
     begin
      Close;
      SQL.Text:='DELETE FROM Accounts WHERE Id=:AccountId';
      Parameters.ParamByName('AccountId').Value:=AccountId;
      ExecSQL;
      UpdateAccountTable;
     end;
   end;
end;

function TAccountManager.GetAccountById(AccountId:integer): TAccountParams;
begin
 with DBProc  do
   begin
      SQL.Text :=' SELECT * FROM Accounts WHERE Id=:AccountId' ;
      Parameters.ParamByName('AccountId').Value:=AccountId;
      ExecSQL;
      Open;
      if  RecordCount=0 then
       begin
        Close;
        raise EInvalidAccount.Create('No Such Account !');
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
          Raise ECorreptedAccount.Create('Account Corrupted');
         end;
       end;
   end;
end;



function TAccountManager.GetItems(Index: Integer): TAccountParams;
begin
 with AccountTable do
  begin
    Open;
    Requery();
    if (Index>RecordCount) or (Index<1) then
     begin
      Close;
      Raise EInvalidAccount.Create(' No Such Account ');
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
       Raise ECorreptedAccount.Create('Account Corrupted');
      end;
    end;
  end;
end;

function TAccountManager.GetCount: Integer;
begin
 with DBProc do
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
   with DBProc  do
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

procedure TAccountManager.SetAccountById(AccountId:integer; Value:
    TAccountParams);
begin
 if CheckParams(Value) then
  with DBProc.Parameters  do
   begin
      DBProc.SQL.Text :='UPDATE Accounts SET  AccountName=:AccountName, Username=:Username,'+
                    'Pass=:Pass,Host=:Host,Port=:Port,Timeout=:Timeout WHERE Id=:AccountId ';
      ParamByName('AccountName').Value:=Value.AccountName;
      ParamByName('Username').Value:=Value.Username;
      ParamByName('Pass').Value:=Crypt(Value.Password);
      ParamByName('Host').Value:=Value.Host;
      ParamByName('Port').Value:=value.Port;
      ParamByName('Timeout').Value:=value.Timeout;
      ParamByName('AccountId').Value:=Value.Id;
      DBProc.ExecSQL;
   end;
end;

procedure TAccountManager.SetStatus(AccountId:integer;
    AccountStatus:TAccountStatus);
begin
  with DBProc do
   begin
    SQL.Text:='UPDATE Accounts SET Status=:AccountStatus WHERE Id=:AccountId';
    Parameters.ParamByName('AccountStatus').Value:=GetEnumName(TypeInfo(TAccountStatus), Ord(AccountStatus));
    Parameters.ParamByName('AccountId').Value:=AccountId;
    ExecSQL;
   end;
end;

procedure TAccountManager.UpdateAccountTable;
begin
  if NOT  AccountTable.Active then   AccountTable.Open;
  AccountTable.Requery();
end;

{

функция для проверки доступа
 если нет аккаунта - asNone
 если свободен - вернуть
 получение параметров по имени пользователя

}

end.

