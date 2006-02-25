unit POPServer;

interface
uses Shared,Windows,Dialogs, Messages, SysUtils,IdContext, StdCtrls, ADODB, IdBaseComponent, IdComponent,
     IdTCPServer, IdPOP3Server, Settings, AccountManager;

type
 TPOPServer=class
  private
   FAccountManager: TAccountManager;
   FADOCon: TADOConnection;
   FServerPort: Integer;
   Mutex: THandle;
   pop:TIdPOP3Server;
   procedure CheckAccount(AThread: TIdContext;LThread: TIdPOP3ServerContext);
   procedure SetServerPort(const Value: Integer);
 public
   constructor Create(ADOCon:TADOConnection; AccountManager:TAccountManager);
   destructor  Destroy(); override;
   property ServerPort: Integer read FServerPort write SetServerPort;
end;

implementation

constructor TPOPServer.Create(ADOCon:TADOConnection;
    AccountManager:TAccountManager);
begin
 Mutex:=CreateMutex(nil,False,MutexName);
 FADOCon:=ADOCon;
 FAccountManager:=AccountManager;
 pop:=TIdPOP3Server.Create(nil);
 with pop do
  begin
   // defaultPort:=210;
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

procedure TPOPServer.SetServerPort(const Value: Integer);
begin
  if FServerPort <> Value then
   try
    POP.Active:=False;
    FServerPort := Value;
    POP.DefaultPort:=FServerPort;
    pop.Active:=True;
   except
    on e: Exception do
      ShowMessage(E.Message);
   end;
end;



end.
