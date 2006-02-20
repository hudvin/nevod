unit AccountManager;

interface

uses   Classes,  TypInfo,
  SysUtils, Windows, Messages,  Graphics, Controls, Forms, Dialogs,
  ADODB,DB,Exceptions,Shared;

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
    procedure SetItems(Index: Integer; const Value: TAccountParams);
  protected
  public
    constructor Create(ADOCon:TADOConnection); virtual;
    destructor Destroy; override;
    procedure AddAccount(NewAccount:TAccountParams);
    function CheckParams(Account:TAccountParams;NewAccount:boolean=False): Boolean;
    procedure DeleteAccount(AccountId:Integer);
    property AccountById[AccountId:integer]: TAccountParams read GetAccountById
        write SetAccountById;
    property Items[Index: Integer]: TAccountParams read GetItems write SetItems;
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

procedure TAccountManager.AddAccount(NewAccount:TAccountParams);
begin
  if CheckParams(NewAccount,True) then
   with DBProc.Parameters do
    try
     DBProc.SQL.Text:=' INSERT INTO Accounts (AccountName,Username,Pass,Host,Port) '+
                      'VALUES(:AccountName,:Username,:Pass,:Host,:Port)';
     ParamByName('AccountName').Value:=NewAccount.AccountName;
     ParamByName('Username').Value:=NewAccount.Username;
     ParamByName('Pass').Value:=Crypt(NewAccount.Password);
     ParamByName('Host').Value:=NewAccount.Host;
     ParamByName('Port').Value:=NewAccount.Port;
     DBProc.ExecSQL;
    except
     on e: Exception
      do Raise EDBerror.Create(' Cannot Add new Account ');
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

procedure TAccountManager.SetAccountById(AccountId:integer; Value:
    TAccountParams);
begin
 if CheckParams(Value) then
  with DBProc.Parameters  do
   begin
      DBProc.SQL.Text :='UPDATE Accounts SET  AccountName=:AccountName, Username=:Username,'+
                    'Pass=:Pass,Host=:Host,Port=:Port WHERE Id=:AccountId ';
      ParamByName('AccountName').Value:=Value.AccountName;
      ParamByName('Username').Value:=Value.Username;
      ParamByName('Pass').Value:=Crypt(Value.Password);
      ParamByName('Host').Value:=Value.Host;
      ParamByName('Port').Value:=value.Port;
      ParamByName('AccountId').Value:=Value.Id;
      DBProc.ExecSQL;
   end;
end;

procedure TAccountManager.SetItems(Index: Integer; const Value: TAccountParams);
begin
end;

{

модификация по порядковому номеру

}

end.

 {


 

 функции для изменения статуса
   преобразования id  в имя учетной записи
   аутентификации сервера
   написать функции для блокирования доступа через критические секции
   обновлять таблицу при  каждом запросе 
 }

