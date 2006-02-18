 unit AccountManager;

interface

uses   Classes,
  SysUtils, Windows, Messages,  Graphics, Controls, Forms, Dialogs,
  ADODB,DB,Exceptions,Shared;

type
  EListError = class(Exception)
  end;

  TAccountManager = class(TBFCoder)
  private
    FADOCon: TADOConnection;
    StoredProc: TADOStoredProc;
    function AccountNameExists(AccountName: string): Boolean;
    function GetAccounts(Index: Integer): AccountParams;
    function GetIdByAccountName(AccountName: string): Integer;
    procedure SetAccounts(Index: Integer; const Value: AccountParams);
  public
    constructor Create(ADOCon: TADOConnection);
    destructor Destroy; override;
    procedure AddAccount(Account: AccountParams); overload;
    procedure DeleteAccount(AccountId: Integer); overload;
    procedure DeleteAccount(AccountName: string); overload;
    procedure ModifyAccount(Account: AccountParams); overload;
    property Accounts[Index: Integer]: AccountParams read GetAccounts write
        SetAccounts;
  end;

  TAccount = class(TObject)
  private
    FAccountId: Integer;
    FAccountName: string;
    FHost: string;
    FPassword: string;
    FPort: Integer;
    FStatus: TAccountStatus;
    FUsername: string;
  public
    property AccountId: Integer read FAccountId;
    property AccountName: string read FAccountName write FAccountName;
    property Host: string read FHost write FHost;
    property Password: string read FPassword write FPassword;
    property Port: Integer read FPort write FPort;
    property Status: TAccountStatus read FStatus write FStatus;
    property Username: string read FUsername write FUsername;
  end;

  TAccounter = class(TBFCoder)
  private
    AccountTable: TADOStoredProc;
    FAccount: TAccount;
    FADOCon: TADOConnection;
    function GetAccountById(AccountId: Integer): TAccount;
    function GetAccountByName(AccountName:String): TAccount;
    function GetAccounts(Index: Integer): TAccount;
    function GetCount: Integer;
    procedure SetAccountById(AccountId: Integer; const Value: TAccount);
    procedure SetAccountByName(AccountName:String; const Value: TAccount);
    procedure SetAccounts(Index: Integer; const Value: TAccount);
  public
    constructor Create(ADOCon:TADOConnection);
    destructor Destroy; override;
    property AccountById[AccountId: Integer]: TAccount read GetAccountById write
        SetAccountById;
    property AccountByName[AccountName:String]: TAccount read GetAccountByName
        write SetAccountByName;
    property Accounts[Index: Integer]: TAccount read GetAccounts write SetAccounts;
    property Count: Integer read GetCount;
  end;

  TDBProvider = class(TObject)
  private
    FADOCon: TADOConnection;
    StoredProc: TADOStoredProc;
  public
    constructor Create(ADOCon:TADOConnection);
    destructor Destroy; override;
    function AccountName2Id(AccountName:String): Integer;
    procedure AddAccount(NewAccount:AccountParams);
    function Id2AccountName(AccountId:Integer): string;
  end;

implementation

{
******************************* TAccountManager ********************************
}
constructor TAccountManager.Create(ADOCon: TADOConnection);
begin
  inherited Create;
  Showmessage('!!!');
  FADOCon:=ADOCon;
  StoredProc:=TADOStoredProc.Create(nil);
  StoredProc.Connection:=FADOCon;
  SetKey(Shared.CriptKey); // - какой ключ использовать для шифрования ???
end;

destructor TAccountManager.Destroy;
begin
//  inherited Destroy;
  Showmessage('???');
  StoredProc.Free;
  FADOCon:=nil;
end;

function TAccountManager.AccountNameExists(AccountName: string): Boolean;
begin
  with StoredProc do
   begin
    Close;
    Parameters.Clear;
    ProcedureName:='CheckForAccountCopy';
    Parameters.AddParameter.Name:='AccountName';
    Parameters.ParamByName('AccountName').Value:=AccountName;
    ExecProc;
    Open;
    if Fields[0].AsInteger=0 then Result:=False
      else Result:=True;
    Close;
   end;
end;

procedure TAccountManager.AddAccount(Account: AccountParams);
begin
  if Trim(Account.AccountName)='' then
      raise EInvalidAccountParams.Create('Пустое имя акаунта');
  if Trim(Account.Username)='' then
      raise EInvalidAccountParams.Create('Пустое имя пользователя');
  if  AccountNameExists(Trim(Account.AccountName))  then
      raise EInvalidAccountParams.Create('Аккаунт с данным именем уже существует');
  if Trim(Account.Host)='' then
      raise EInvalidAccountParams.Create('Пустое имя почтового сервера');
  if (Account.Port<1) OR (Account.Port>65536) then
      raise EInvalidAccountParams.Create('Недопустимое значение номера порта');
    with StoredProc do
     begin
      Close;
      Parameters.Clear;
      ProcedureName:='AddAccount';

      Parameters.AddParameter.Name:='AccountName';
      Parameters.ParamByName('AccountName').Value:=Account.AccountName;

      Parameters.AddParameter.Name:='UserName';
      Parameters.ParamByName('UserName').Value:=Account.Username;

      Parameters.AddParameter.Name:='Password';
      Parameters.ParamByName('Password').Value:=Crypt(Account.Password);

      Parameters.AddParameter.Name:='Host';
      Parameters.ParamByName('Host').Value:=Account.Host;

      Parameters.AddParameter.Name:='Port';
      Parameters.ParamByName('Port').Value:=Account.Port;

      ExecProc;
      Close;
     end;
end;

procedure TAccountManager.DeleteAccount(AccountId: Integer);
begin
  with StoredProc do
    begin
     Close;
     Parameters.Clear;
     ProcedureName:='CheckForAccountCopyById'; // делать полную выборку и смотреть количество
     Parameters.AddParameter.Name:='AccountId';
     Parameters.ParamByName('AccountId').Value:=AccountId;
     ExecProc;
     Open;
     if Fields[0].AsInteger=0 then
        raise EInvalidAccount.Create(' Данного аккаунта не существует ')
       else
        Close;
        Parameters.Clear;
        ProcedureName:='DeleteAccount';
        Parameters.AddParameter.Name:='AccountId';
        Parameters.ParamByName('AccountId').Value:=AccountId;
        ExecProc;
    end;
end;

procedure TAccountManager.DeleteAccount(AccountName: string);
begin
  DeleteAccount(GetIdByAccountName(AccountName));
end;

function TAccountManager.GetAccounts(Index: Integer): AccountParams;
begin
  // TODO -cMM: TAccountManager.GetAccounts default body inserted
 // Result := ;
 
end;

function TAccountManager.GetIdByAccountName(AccountName: string): Integer;
var
  LStoredProc: TADOStoredProc;
begin
  LStoredProc:=TADOStoredProc.Create(nil);
  with LStoredProc do
   begin
    Connection:=FADOCon;
    ProcedureName:='GetIdByAccountName';

    Parameters.AddParameter.Name:='AccountName';
    Parameters.ParamByName('AccountName').Value:=AccountName;

    ExecProc;
    Open;
    if RecordCount=0
     then Result:=-1
      else  Result:=Fields[0].AsInteger;
    Close;
   end;
  Free;
end;

procedure TAccountManager.ModifyAccount(Account: AccountParams);
begin
  {

  проверка на копию аккаунта -
    если id копии не совпадает с id редактируемой записи
     (выборка по одинаковому имени) аккаунта - значит дубликат

  }

  if Trim(Account.AccountName)='' then
      raise EInvalidAccountParams.Create('Пустое имя акаунта');
  if Trim(Account.Username)='' then
      raise EInvalidAccountParams.Create('Пустое имя пользователя');
  if  AccountNameExists(Trim(Account.AccountName))  then
      raise EInvalidAccountParams.Create('Аккаунт с данным именем уже существует');
  if Trim(Account.Host)='' then
      raise EInvalidAccountParams.Create('Пустое имя почтового сервера');
  if (Account.Port<1) OR (Account.Port>65536) then
      raise EInvalidAccountParams.Create('Недопустимое значение номера порта');
     with StoredProc do
      begin
       Close;
       Parameters.Clear;
       ProcedureName:='ModifyAccount';

       Parameters.AddParameter.Name:='AccountName';
       Parameters.ParamByName('AccountName').Value:=Account.AccountName;

       Parameters.AddParameter.Name:='UserName';
       Parameters.ParamByName('UserName').Value:=Account.Username;

       Parameters.AddParameter.Name:='Password';
       Parameters.ParamByName('Password').Value:=Crypt(Account.Password);

       Parameters.AddParameter.Name:='Host';
       Parameters.ParamByName('Host').Value:=Account.Host;

       Parameters.AddParameter.Name:='Port';
       Parameters.ParamByName('Port').Value:=Account.Port;

       ExecProc;
       Close;
      end;
end;

procedure TAccountManager.SetAccounts(Index: Integer; const Value:
    AccountParams);
begin
  // TODO -cMM: TAccountManager.SetAccounts default body inserted
end;

{
********************************* TDBProvider **********************************
}
constructor TDBProvider.Create(ADOCon:TADOConnection);
begin
  inherited Create;
  FADOCon:=ADOCon;
  StoredProc:=TADOStoredProc.Create(nil);
  StoredProc.Connection:=FADOCon;

end;

destructor TDBProvider.Destroy;
begin
  inherited Destroy;
  StoredProc.Free;
  FADOCon:=nil;
end;

function TDBProvider.AccountName2Id(AccountName:String): Integer;
begin
  {
    если нет данной записи - возбуждать исключение
  }
  with StoredProc  do
   try
    Close;
    Parameters.Clear;
    ProcedureName:='AccountName2Id';
    Parameters.AddParameter.Name:='AccountName';
    Parameters.ParamByName('AccountName').Value:=AccountName;
    ExecProc;
    Open;
    First;
    if RecordCount=0 then
      raise EInvalidAccount.Create(' Такого аккаунта не существует ! ')
     else Result:=Fields[0].AsInteger;
  finally
    Close;
  end;
end;

procedure TDBProvider.AddAccount(NewAccount:AccountParams);
begin
  {
  проверка на существование аккаунта
  функция с параметром по умолчанию
    - если параметр есть - второй тип проверки
    - если параметра нету - первый тип проверки
   исключение вызвать в процедуре, в которой будет использоваться проверка

  }
end;

function TDBProvider.Id2AccountName(AccountId:Integer): string;
begin
  with StoredProc  do
   try
    Close;
    Parameters.Clear;
    ProcedureName:='Id2AccountName';
    Parameters.AddParameter.Name:='AccountId';
    Parameters.ParamByName('AccountId').Value:=AccountId;
    ExecProc;
    Open;
    First;
    if RecordCount=0 then
      raise EInvalidAccount.Create(' Такого аккаунта не существует ! ')
     else Result:=Fields[0].AsString;
  finally
    Close;
  end;
end;

constructor TAccounter.Create(ADOCon:TADOConnection);
begin
  inherited Create;
  FADOCon:=ADOCon;
  FAccount:=TAccount.Create;
  AccountTable:=TADOStoredProc.Create(nil);
  AccountTable.Connection:=FADOCon;
  AccountTable.ProcedureName:='GetAccountList';
//  AccountTable.ExecProc;
 // SetKey(Shared.CriptKey);
 

end;

destructor TAccounter.Destroy;
begin
  inherited Destroy;
//  ShowMessage('destroy');
  AccountTable.Free;
  FAccount.Free;
  FADOCon:=nil;
  
  
end;

function TAccounter.GetAccountById(AccountId: Integer): TAccount;
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
    begin
      if FieldByName('Id').AsInteger=AccountId  then
       begin
         Flag:=False;

         FAccount.FAccountId:=AccountId;
         FAccount.AccountName:=FieldByName('AccountName').AsString;
         Result:=FAccount;
       end;
      Next;

    end;
   if  Flag then raise EInvalidAccount.Create('No Such Account !');

   Close;

  end;

  {
  найти в таблице нужный элемент
   если нету - вызвать исключение
   если есть
    получить все нужные параметры и присвоить полю в класс
    рузультат вернуть как ссылку на него

  }
end;

function TAccounter.GetAccountByName(AccountName:String): TAccount;
begin
  // TODO -cMM: TAccounter.GetAccountByName default body inserted
//  Result := ;
end;

function TAccounter.GetAccounts(Index: Integer): TAccount;
begin
  // TODO -cMM: TAccounter.GetAccounts default body inserted
  {

  проверять, существует ли данный акаунт
  если все нормально - расшифровывать пароль

  }
 // Result := ;
end;

function TAccounter.GetCount: Integer;
begin
  // TODO -cMM: TAccounter.GetCount default body inserted
 // Result := ;
end;

procedure TAccounter.SetAccountById(AccountId: Integer; const Value: TAccount);
begin
  // TODO -cMM: TAccounter.SetAccountById default body inserted
end;

procedure TAccounter.SetAccountByName(AccountName:String; const Value:
    TAccount);
begin
  // TODO -cMM: TAccounter.SetAccountByName default body inserted
end;

procedure TAccounter.SetAccounts(Index: Integer; const Value: TAccount);
begin
  Showmessage('bvcbc');
end;


end.
