unit POPServer;

interface
uses
    Shared,Windows,Dialogs, Messages, SysUtils,IdContext, StdCtrls,
     ADODB, IdBaseComponent, IdComponent, Math, IdCommandHandlers,
     IdTCPServer, IdPOP3Server, Settings, AccountManager;

type
 TPOPServer=class
  private
   ContextProcs: TAccountContextList;
   FAccountManager: TAccountManager;
   FADOCon: TADOConnection;
   FDefaultPort: Integer;
   Mutex: THandle;
   pop:TIdPOP3Server;
   ProcsRepositary: TSQLProcs;
   procedure CheckAccount(AThread: TIdContext;LThread: TIdPOP3ServerContext);
   procedure QUIT(ASender: TIdCommand);
   procedure STAT(ASender: TIdCommand);
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
 ContextProcs:=TAccountContextList.Create(FADOCon);
 FDefaultPort:=ServerPort;
 FAccountManager:=AccountManager;
 pop:=TIdPOP3Server.Create(nil);
 ProcsRepositary:=TSQLProcs.Create;
 { добавления запросов в хранилище }
 ProcsRepositary.AddQuery('DELETE FROM Messages WHERE mid=:AccountId','QuitCommand');
 ProcsRepositary.AddQuery('UPDATE Messages SET Deleted=False WHERE mid=:AccountId','UnCheckDeleted');


 pop.DefaultPort:=DefaultPort;
 with pop do
  begin
    CheckUser:=CheckAccount;
    OnDisconnect:=Disconnect;
    OnQUIT:=QUIT;
  { OnLIST:=LIST;
   OnSTAT:=STAT;
   OnRETR:=RETR;
   OnDELE:=DELE;

    }
   Active:=true;
 end;
end;

destructor TPOPServer.Destroy();
begin
 pop.Active:=False;
 pop.Free;
 ContextProcs.Free;
 ProcsRepositary.Free;
 FADOCon:=nil;
 CloseHandle(Mutex);
end;

procedure TPOPServer.CheckAccount(AThread: TIdContext;LThread:
    TIdPOP3ServerContext);
var
    Password,Username:string;
    AParams:TAccountParams;
    id:integer;
    Proc:TADOQuery;
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
          ContextProcs.AddContext(AParams.Id);
          Proc:=ContextProcs.GetContext(AParams.Id).MessProc;
          ProcsRepositary.Fill(Proc,'UnCheckDeleted',[Id]);
          Proc.ExecSQL;
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
    AccountId:integer;
begin
 AccountId:=AContext.Connection.Tag;
 if AccountId>0 then
  begin
   WaitForSingleObject(Mutex,INFINITE);
     ContextProcs.DeleteContext(AccountId);
     FAccountManager.SetStatus(AccountId,asFree);
   ReleaseMutex(Mutex);
  end //
  else // если -1 или 0
   begin

   end;
end;

procedure TPOPServer.QUIT(ASender: TIdCommand);
var
    AccountId:integer;
    Proc:TADOQuery;
begin
  AccountId:=ASender.Context.Connection.Tag;
  Proc:=ContextProcs.GetContext(AccountId).MessProc;
  ProcsRepositary.Fill(Proc,'QuitCommand',[AccountId]);
  Proc.ExecSQL;
  Proc:=nil;
end;

procedure TPOPServer.STAT(ASender: TIdCommand);
var
 AccountId:integer;
 Proc:TADOQuery;
begin
  AccountId:=ASender.Context.Connection.Tag;
  Proc:=ContextProcs.GetContext(AccountId).MessProc;

 // получить количество сообщений и их общий объем
// ASender.Reply.SetReply(OK, '1 40');
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


{
 создать хеш - массив с запросами
}


end.
