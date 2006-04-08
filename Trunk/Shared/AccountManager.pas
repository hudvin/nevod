unit AccountManager;

interface

uses
  TypInfo, SysUtils, cxGridCustomTableView, cxGridTableView,
   ADODB,DB,Exceptions,Shared;

type
  TAccountManager = class(TBFCoder)
  private
    AccountTable: TADOTable;
    cxAccountAccountName: TcxGridColumn;
    cxAccountPassword: TcxGridColumn;
    cxAccountPort: TcxGridColumn;
    cxAccountServer: TcxGridColumn;
    cxAccountStatus: TcxGridColumn;
    cxAccountTimeout: TcxGridColumn;
    cxAccountUsername: TcxGridColumn;
    FADOCon: TADOConnection;
    DBProc: TADOQuery;
    FAccountsGrid: TcxGridTableView;
    function GetAccountById(AccountId:integer): TAccountParams;
    function GetItems(Index: Integer): TAccountParams;
    function GetCount: Integer;
    procedure LoadAccount2Grid;
    procedure ModifyAccounstGrid(Params:TAccountParams);
    procedure SetAccountById(AccountId:integer; Value: TAccountParams);
  protected
    function AccountIdExists(AccountId:integer): Boolean;
    function AccountNameExists(AccountName:String): Boolean;
    procedure AddAccountToGrid(Account:TAccountParams);
  public
    constructor Create(ADOCon:TADOConnection;AccountsGrid:TcxGridTableView);
        virtual;
    destructor Destroy; override;
    function AccountName2Id(AccountName:String): Integer;
    procedure AddAccount(NewAccount:TAccountParams);
    function CheckParams(Account:TAccountParams;NewAccount:boolean=False): Boolean;
    function CheckStatus(Status:TAccountStatus;AccountId:Integer): Boolean;
    procedure DeleteAccount(AccountId:Integer);
    function Id2AccountName(AccountId:integer): string;
    procedure ModifyAccount(Params:TAccountParams);
    procedure SetStatus(AccountId:integer;AccountStatus:TAccountStatus);
    procedure UpdateAccountTable;
    property AccountById[AccountId:integer]: TAccountParams read GetAccountById
        write SetAccountById;
    property Items[Index: Integer]: TAccountParams read GetItems;
    property Count: Integer read GetCount;
  end;

implementation
uses main;
constructor TAccountManager.Create(ADOCon:TADOConnection;
    AccountsGrid:TcxGridTableView);
begin
  inherited Create;
  FADOCon:=ADOCon;
  FAccountsGrid:=AccountsGrid;
  AccountTable:=TADOTable.Create(nil);
  AccountTable.Connection:=FADOCon;
  AccountTable.TableName:='Accounts';
  UpdateAccountTable;
  DBProc:=TADOQuery.Create(nil);
  DBProc.Connection:=FADOCon;
  SetKey(Shared.CriptKey);
  with main.FMain do
   begin
    cxAccountAccountName:=cxAccountsAccountName;
    cxAccountUsername:=cxAccountsUsername;
    cxAccountPassword:=cxAccountsPassword;
    cxAccountServer:=cxAccountsServer;
    cxAccountPort:=cxAccountsPort;
    cxAccountStatus:=cxAccountsStatus;
    cxAccountTimeout:=cxAccountsTimeout;
   end;
 LoadAccount2Grid;
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
    if Fields[0].AsInteger>0 then Result:=True
     else Result:=False;
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
     AddAccountToGrid(NewAccount);
    end;

end;

procedure TAccountManager.AddAccountToGrid(Account:TAccountParams);
var
 Count:Integer;
 Status:String;
begin
 FAccountsGrid.DataController.RecordCount:=FAccountsGrid.DataController.RecordCount+1;
 Count:=FAccountsGrid.DataController.RecordCount-1;
 with FAccountsGrid.DataController do
  begin
   SetValue(Count,cxAccountAccountName.Index,Account.AccountName);
   SetValue(Count,cxAccountUsername.Index,Account.Username);
   SetValue(Count,cxAccountServer.Index,Account.Host);
   SetValue(Count,cxAccountPort.Index,Account.Port);
   SetValue(Count,cxAccountTimeout.Index,Account.Timeout);
   SetValue(Count,cxAccountPassword.Index,Account.Password);
   case Account.Status of
     asFree: Status:='Free' ;
     asClient: Status:='Client Loading mail' ;
     asServer: Status:='Loading mail from server' ;
   end;
   SetValue(Count,cxAccountStatus.Index,Status);
  end;
end;

function TAccountManager.CheckParams(Account:TAccountParams;
    NewAccount:boolean=False): Boolean;
begin
  Result:=False;
  if Trim(Account.AccountName)='' then
    Raise EInvalidAccountParams.Create('Incorrect AccountName');
  with DBProc  do
   begin
    if NewAccount then   // ���� ����� ������� ������
     begin       // ������ ������� � ������ ������ - � ���� ����������
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
    else  // ����  �������������� ������ ������
     begin
       // ��������� ���� �� ������ � ����� ������ �� ������ id
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

  if Trim(Account.Username)='' then
    Raise EInvalidAccountParams.Create('Incorrect Username ');
  if Trim(Account.Host)='' then
    Raise EInvalidAccountParams.Create('Incorrect Host');
  if (Account.Port<1) or (Account.Port>65536) then
    Raise EInvalidAccountParams.Create('Incorrect Port');
  if (Account.Timeout<-1) then
    Raise EInvalidAccountParams.Create(' Incorrect Timeout ');

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
    if Fields[0].AsInteger=0  then    // ���� ��� ������ id � �������
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
    First;
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

procedure TAccountManager.LoadAccount2Grid;
var
 i:integer;
begin
 for i := 0 to Count-1 do  // ������ �� �������
  AddAccountToGrid(Items[i+1]);
end;

procedure TAccountManager.ModifyAccounstGrid(Params:TAccountParams);
var
  AName:String;
  i:integer;
  Flag:boolean;
begin
 {
  �������� ��� ������ (������ - �� ����)
   ����� � ����� � �������� ������
 }   // if cxAccounts.Controller.SelectedRecords[0].Values[cxAccountsAccountName.VisibleIndex]; then
 AName:=AccountById[Params.Id].AccountName;
 i:=0;
 Flag:=false;
 while (not Flag) or (i<FAccountsGrid.DataController.RecordCount)  do
    with FAccountsGrid.DataController do
       if GetValue(i,cxAccountAccountName.VisibleIndex)=Params.AccountName then
        begin
         Flag:=True;
         SetValue(i,cxAccountAccountName.Index,Params.AccountName);
         SetValue(i,cxAccountAccountName.Index,Params.AccountName);
         SetValue(i,cxAccountUsername.Index,Params.Username);
         SetValue(i,cxAccountServer.Index,Params.Host);
         SetValue(i,cxAccountPort.Index,Params.Port);
         SetValue(i,cxAccountTimeout.Index,Params.Timeout);
         SetValue(i,cxAccountPassword.Index,params.Password);
        end else inc(i);
end;

procedure TAccountManager.ModifyAccount(Params:TAccountParams);
begin
 CheckParams(Params);
 ModifyAccounstGrid(Params);
 AccountById[Params.Id]:=Params;
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

end.

