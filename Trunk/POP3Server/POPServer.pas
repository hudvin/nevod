unit POPServer;

interface
uses Shared,Windows,Dialogs, Messages, SysUtils,IdContext, StdCtrls, ADODB, IdBaseComponent, IdComponent,
     IdTCPServer, IdPOP3Server, Settings, AccountManager;

type
 TPOPServer=class
  private
   FAccountManager: TAccountManager;
   FADOCon: TADOConnection;
   FDefaultPort: Integer;
   Mutex: THandle;
   pop:TIdPOP3Server;
   procedure CheckAccount(AThread: TIdContext;LThread: TIdPOP3ServerContext);
   procedure Disconnect(AContext: TIdContext);
   procedure SetDefaultPort(const Value: Integer);
 public
   constructor Create(ADOCon:TADOConnection; AccountManager:TAccountManager;
       ServerPort:integer);
   destructor  Destroy(); override;
   property DefaultPort: Integer read FDefaultPort write SetDefaultPort;
end;

implementation

constructor TPOPServer.Create(ADOCon:TADOConnection;
    AccountManager:TAccountManager;ServerPort:integer);
begin
 Mutex:=CreateMutex(nil,False,MutexName);
 FADOCon:=ADOCon;
 FDefaultPort:=ServerPort;
 FAccountManager:=AccountManager;
 pop:=TIdPOP3Server.Create(nil);
 pop.DefaultPort:=DefaultPort;
 with pop do
  begin
    CheckUser:=CheckAccount;

  { OnLIST:=LIST;
   OnSTAT:=STAT;
   OnRETR:=RETR;
   OnDELE:=DELE;
   OnQUIT:=QUIT;
   OnDisconnect:=Disconnect; }
   Active:=true;
 end;
end;

destructor TPOPServer.Destroy();
begin
 pop.Active:=False;
 pop.Free;
 FADOCon:=nil;
 CloseHandle(Mutex);
end;

procedure TPOPServer.CheckAccount(AThread: TIdContext;LThread:
    TIdPOP3ServerContext);
var
    Password,Username:string;
    AParams:TAccountParams;
    id:integer;
begin
 WaitForSingleObject(Mutex,INFINITE);
  Password:=LThread.Password;
  Username:=LThread.Username;
  Id:=FAccountManager.AccountName2Id(Username);
  if Id<>-1 then
  begin
   AParams:=FAccountManager.AccountById[Id];
   if AParams.Password=Password then
     case AParams.Status of    //
       asFree:
        begin
          FAccountManager.SetStatus(AParams.Id,asServer);
          LThread.Connection.Tag:=AParams.Id;
          LThread.State:=Trans;
        end;
       asClient:
        begin
          LThread.Connection.Tag:=AParams.Id;
          LThread.State:=Trans;
        end;
     else
       LThread.Connection.Tag:=-1;
     end;    // case
  end;
 ReleaseMutex(Mutex);
end;

procedure TPOPServer.Disconnect(AContext: TIdContext);
var
    id:integer;
    ast:TADOStoredProc;
begin
//id:=AThread.Connection.Tag;

{

как лучше модифицировать данные ?
если tag равен 0 или  -1
 ничего не делать

если не равно 0
 разотметить сообщения на удаление
 изменить статус учетной записи

 снимать отметку Удаленные в процедуру проверки пароля

 создать динамический массив с классом для работы с сообшениями
 создать массив с указателями на tadoquery и id аккаунта
 при аутентификации добавлять при разрыве удалять !
  класс с tadoquery и id  аккаунта
  TList c возможностью поиска
  использовать защищенный список     TThreadList

}

{ if id<>0 then
  begin
   ast:=TADOStoredProc.Create(nil);
   ast.Connection:=ACon;
   ast.ProcedureName:='UnDeleteCheckedMessages';
   ast.Parameters.AddParameter.Name:='id';
   ast.Parameters.ParamByName('id').Value:=id;
   ast.ExecProc;
   ast.Close;

  ast.Parameters.Clear;
  ast.ProcedureName:='setStatusById';
  ast.Parameters.AddParameter.Name:='status';
  ast.Parameters.ParamByName('status').Value:='fmFree';
  ast.Parameters.AddParameter.Name:='id';
  ast.Parameters.ParamByName('id').Value:=id;
  ast.ExecProc;
  ast.Close;

  ast.Free;
 end; }
end;

procedure TPOPServer.SetDefaultPort(const Value: Integer);
begin
  if FDefaultPort <> Value then
   try
    POP.Active:=False;
    FDefaultPort := Value;
    POP.DefaultPort:=FDefaultPort;
    pop.Active:=True;
   except
    on e: Exception do
      ShowMessage(E.Message);
   end;
end;



end.
