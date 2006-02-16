 unit AccountManager;

interface

uses   Classes,
  SysUtils, Windows, Messages,  Graphics, Controls, Forms, Dialogs,
  ADODB,DB,Exceptions,Shared;

type
  TAccountList = class;
  EListError = class(Exception)
  end;

  TAccountManager = class(TBFCoder)
  private
    FADOCon: TADOConnection;
    StoredProc: TADOStoredProc;
    function AccountNameExists(AccountName: string): Boolean;
    function GetIdByAccountName(AccountName: string): Integer;
  public
    constructor Create(ADOCon: TADOConnection);
    destructor Destroy; override;
    procedure AddAccount(Account: AccountParams); overload;
    procedure DeleteAccount(AccountId: Integer); overload;
    procedure DeleteAccount(AccountName: string); overload;
    procedure ModifyAccount(Account: AccountParams); overload;
  end;

  TAccountList = class(TList)
  private
    function GetParams(Index: Integer): AccountParams;
  public
    constructor Create;
    destructor Destroy; override;
    property Account[Index: Integer]: AccountParams read GetParams;
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

{

�������� � ���������� ��������� � ������
��� ������ ����������� ����������� ��� ��������
����� �� ������ ����������� ���������� ��������� ?
��� ������ ����� ��������� ������� ������� �������

}

implementation

{
******************************* TAccountManager ********************************
}
constructor TAccountManager.Create(ADOCon: TADOConnection);
begin
  inherited Create;
  FADOCon:=ADOCon;
  StoredProc:=TADOStoredProc.Create(nil);
  StoredProc.Connection:=FADOCon;
  SetKey(Shared.CriptKey); // - ����� ���� ������������ ��� ���������� ???
end;

destructor TAccountManager.Destroy;
begin
  inherited Destroy;
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
      raise EInvalidAccountParams.Create('������ ��� �������');
  if Trim(Account.Username)='' then
      raise EInvalidAccountParams.Create('������ ��� ������������');
  if  AccountNameExists(Trim(Account.AccountName))  then
      raise EInvalidAccountParams.Create('������� � ������ ������ ��� ����������');
  if Trim(Account.Host)='' then
      raise EInvalidAccountParams.Create('������ ��� ��������� �������');
  if (Account.Port<1) OR (Account.Port>65536) then
      raise EInvalidAccountParams.Create('������������ �������� ������ �����');
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
     ProcedureName:='CheckForAccountCopyById'; // ������ ������ ������� � �������� ����������
     Parameters.AddParameter.Name:='AccountId';
     Parameters.ParamByName('AccountId').Value:=AccountId;
     ExecProc;
     Open;
     if Fields[0].AsInteger=0 then
        raise EInvalidAccount.Create(' ������� �������� �� ���������� ')
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

  �������� �� ����� �������� -
    ���� id ����� �� ��������� � id ������������� ������
     (������� �� ����������� �����) �������� - ������ ��������

  }

  if Trim(Account.AccountName)='' then
      raise EInvalidAccountParams.Create('������ ��� �������');
  if Trim(Account.Username)='' then
      raise EInvalidAccountParams.Create('������ ��� ������������');
  if  AccountNameExists(Trim(Account.AccountName))  then
      raise EInvalidAccountParams.Create('������� � ������ ������ ��� ����������');
  if Trim(Account.Host)='' then
      raise EInvalidAccountParams.Create('������ ��� ��������� �������');
  if (Account.Port<1) OR (Account.Port>65536) then
      raise EInvalidAccountParams.Create('������������ �������� ������ �����');
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

{
********************************* TAccountList *********************************
}
constructor TAccountList.Create;
begin
  // TODO -cMM: TAccountList.Create default body inserted

  inherited;
end;

destructor TAccountList.Destroy;
begin
  // TODO -cMM: TAccountList.Destroy default body inserted
  inherited;
end;

function TAccountList.GetParams(Index: Integer): AccountParams;
begin

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
    ���� ��� ������ ������ - ���������� ����������
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
      raise EInvalidAccount.Create(' ������ �������� �� ���������� ! ')
     else Result:=Fields[0].AsInteger;
  finally
    Close;
  end;
end;

procedure TDBProvider.AddAccount(NewAccount:AccountParams);
begin

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
      raise EInvalidAccount.Create(' ������ �������� �� ���������� ! ')
     else Result:=Fields[0].AsString;
  finally
    Close;
  end;
end;



{
������������� �������
 - �������� ������
 - �������������� ������
 - ��������� ������

- ����� ��������� - ���� �� ������ id, �������� ��
������� �� �����

�������� ������ ��� �������� ������� �������� � �������
�������� ���������� ������ � ����� �����

 ������� ��� �������������� id2AccountName
                             AccountName2Id

 ������� ��� ����������� � ���������� ������� ������� ���������� � ���� ����
    (� ����������� �� ���� �������� �������� �������� � ��� ���������)

��� �������� ������� ������ ����� ������� �����
��� ���������� ���� ��������� �������� ��������



}

end.
