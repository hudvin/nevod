 unit AccountManager;

interface

uses   Classes,
  SysUtils, Windows, Messages,  Graphics, Controls, Forms, Dialogs,
  ADODB,DB,Exceptions,Shared;

type
  TAccount = class(TPersistent)
  private
    FAccountId: Integer;
    FAccountName: string;
    FHost: string;
    FPassword: string;
    FPort: Integer;
    FStatus: TAccountStatus;
    FUsername: string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property AccountId: Integer read FAccountId;
    property AccountName: string read FAccountName write FAccountName;
    property Host: string read FHost write FHost;
    property Password: string read FPassword write FPassword;
    property Port: Integer read FPort write FPort;
    property Status: TAccountStatus read FStatus write FStatus;
    property Username: string read FUsername write FUsername;
  end;

  TAccountManager = class
  private
    AccountTable: TADOStoredProc;
    FAccount: TAccount;
    FADOCon: TADOConnection;
    DBProc: TADODataSet;
    function GetAccountById(AccountId: Integer): AccountParams;
    function GetAccountByName(AccountName:String): TAccount;
    function GetAccounts(Index: Integer): TAccount;
    function GetCount: Integer;
    procedure SetAccountById(AccountId: Integer; const Value: AccountParams);
    procedure SetAccountByName(AccountName:String; const Value: TAccount);
    procedure SetAccounts(Index: Integer; const Value: TAccount);
  protected
  public
    constructor Create(ADOCon:TADOConnection); virtual;
    destructor Destroy; virtual;
    function CheckParams(Account:AccountParams;NewAccount:boolean=False): Boolean;
    property AccountById[Index: Integer]: AccountParams read GetAccountById write
        SetAccountById;
    property AccountByName[AccountName:String]: TAccount read GetAccountByName
        write SetAccountByName;
    property Accounts[Index: Integer]: TAccount read GetAccounts write SetAccounts;
    property Count: Integer read GetCount;
  end;

implementation

constructor TAccountManager.Create(ADOCon:TADOConnection);
begin

  FADOCon:=ADOCon;
  FAccount:=TAccount.Create;
  AccountTable:=TADOStoredProc.Create(nil);
  AccountTable.Connection:=FADOCon;
  AccountTable.ProcedureName:='GetAccountList';
  DBProc:=TADODataSet.Create(nil);
  DBProc.Connection:=FADOCon;
//  AccountTable.ExecProc;
 // SetKey(Shared.CriptKey);


end;

destructor TAccountManager.Destroy;
begin
  inherited Destroy ;
  AccountTable.Free;
  DBProc.Free;
  FAccount.Free;
  FADOCon:=nil;
end;

function TAccountManager.CheckParams(Account:AccountParams;
    NewAccount:boolean=False): Boolean;
begin
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
     begin
      CommandType:=cmdText;
      CommandText :='SELECT COUNT(Id) FROM Accounts ' +
                    ' WHERE AccountName=:AccountName';
      Parameters.ParamByName('AccountName').Value:=Account.AccountName;
      Open;
      if Fields[0].AsInteger>0 then
       raise EInvalidAccountParams.Create('Account Exists');
      Close;
   end
    else  // если  модифицируется старая запись
     begin
       // проверить есть ли записи с таким именем но другим id
      CommandType:=cmdText;
      CommandText :='SELECT COUNT(Id) FROM Accounts ' +
                    ' WHERE AccountName=:AccountName AND Id<>:AccountId ';
      Parameters.ParamByName('AccountName').Value:=Account.AccountName;
      Open;
      if Fields[0].AsInteger>0 then
       raise EInvalidAccountParams.Create('Account Exists');
      Close;
     end;
   end;

end;

function TAccountManager.GetAccountById(AccountId: Integer): AccountParams;
var
  Flag:boolean;
begin
 Flag:=False;
 with AccountTable  do
  begin
   Close;
   ExecProc;
   Open;
   while (NOT Eof) AND (NOT Flag) do
      if FieldByName('Id').AsInteger=AccountId  then
       begin
         Flag:=True;

         Result.Id:=AccountId;
         result.AccountName:=FieldByName('AccountName').AsString;
       end else Next;
   if not Flag then raise EInvalidAccount.Create('No Such Account !');
   Close;
  end;
end;

function TAccountManager.GetAccountByName(AccountName:String): TAccount;
begin
  // TODO -cMM: TAccounter.GetAccountByName default body inserted
//  Result := ;
end;

function TAccountManager.GetAccounts(Index: Integer): TAccount;
begin
  // TODO -cMM: TAccounter.GetAccounts default body inserted
  {

  проверять, существует ли данный акаунт
  если все нормально - расшифровывать пароль

  }
 // Result := ;
end;

function TAccountManager.GetCount: Integer;
begin
  // TODO -cMM: TAccounter.GetCount default body inserted
 // Result := ;
end;

procedure TAccountManager.SetAccountById(AccountId: Integer; const Value:
    AccountParams);
begin
  {
  если учетной записи не существует - выдать исключение
  если есть учетная запись
    проверить нет ли другой записи с таким же именем, но с другим идентфикатором

  проверить подходят ли данные по значениям
    идентифицировать по идентфикатору
    написать отдельную функцию  для проверки на копии и на допустимость данных


  }
end;

procedure TAccountManager.SetAccountByName(AccountName:String; const Value:
    TAccount);
begin
  // TODO -cMM: TAccounter.SetAccountByName default body inserted
end;

procedure TAccountManager.SetAccounts(Index: Integer; const Value: TAccount);
begin
  Showmessage('bvcbc');
end;

constructor TAccount.Create;
begin
 inherited Create;
end;

destructor TAccount.Destroy;
begin
 inherited Destroy;
end;


end.
