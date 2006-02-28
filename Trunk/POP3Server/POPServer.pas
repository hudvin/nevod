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
   procedure CheckAccount(AThread: TIdContext;LThread: TIdPOP3ServerContext);
   procedure Connect(AContext: TIdContext);
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

uses IdCustomTCPServer;

constructor TPOPServer.Create(ADOCon:TADOConnection;
    AccountManager:TAccountManager;ServerPort:integer);
begin
 Mutex:=CreateMutex(nil,False,MutexName);
 FADOCon:=ADOCon;
 ContextProcs:=TAccountContextList.Create(FADOCon);
 FDefaultPort:=ServerPort;
 FAccountManager:=AccountManager;
 pop:=TIdPOP3Server.Create(nil);

 pop.DefaultPort:=DefaultPort;
 with pop do
  begin
    CheckUser:=CheckAccount;
    OnDisconnect:=Disconnect;
    OnConnect:=Connect;
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
       asFree:                // ���� ��������
        begin
          FAccountManager.SetStatus(AParams.Id,asServer);
          ContextProcs.AddContext(AParams.Id);
          Proc:=ContextProcs.GetContext(AParams.Id).MessProc;
          Proc.SQL.Text:='UPDATE Messages SET Deleted=False WHERE mid=:AccountId AND Deleted=TRUE';
           {
           ���������� ������� ���������, ���� ���������� ���� ���������
           }
          Proc.Parameters.ParamByName('AccountId').Value:=AParams.Id;
          Proc.ExecSQL;                                                      
          LThread.Connection.Tag:=AParams.Id;
          LThread.State:=Trans;
        end;
       asClient:  // ����������� ��������� ����� �����
        begin
         // LThread.Connection.Tag:=AParams.Id;
          LThread.Connection.Tag:=0;
          LThread.State:=Trans;
        end;
     else
       LThread.Connection.Tag:=-1;  // ������ ��������
     end;    // case
  end;
 ReleaseMutex(Mutex);
end;

procedure TPOPServer.Connect(AContext: TIdContext);
begin
 AContext.Connection.Tag:=-1;
end;


procedure TPOPServer.Disconnect(AContext: TIdContext);
var
    AccountId:integer;
begin
 // ���� -1 - ������ �� ������ - ������ ������ ���������� ��� ������ ��������
 AccountId:=AContext.Connection.Tag;
 if AccountId>0 then
  begin
   WaitForSingleObject(Mutex,INFINITE);
     ContextProcs.DeleteContext(AccountId);
     FAccountManager.SetStatus(AccountId,asFree);
   ReleaseMutex(Mutex);
  end //
  else // ���� -1 ��� 0
   begin

   end;
end;

procedure TPOPServer.QUIT(ASender: TIdCommand);
var
    AccountId:integer;
    Proc:TADOQuery;
begin
 {
 ���� id  ����� 0 - ������ �� ������
 }
  AccountId:=ASender.Context.Connection.Tag;
  if AccountId>0 then
   begin
    Proc:=ContextProcs.GetContext(AccountId).MessProc;
    Proc.SQL.Text:='DELETE FROM Messages WHERE mid=:AccountId AND Deleted=TRUE';
    Proc.Parameters.ParamByName('AccountId').Value:=AccountId;
    Proc.ExecSQL;
    Proc:=nil;
   end; 
end;

procedure TPOPServer.STAT(ASender: TIdCommand);
var
 AccountId:integer;
 Proc:TADOQuery;
begin
  AccountId:=ASender.Context.Connection.Tag;
  Proc:=ContextProcs.GetContext(AccountId).MessProc;

 // �������� ���������� ��������� � �� ����� �����
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
 ������� ��������� ��� ��������������
 ��� ����������� ���������� ��� � -1
 ������� ��� - ������ � ���������
 � ������� ������� �������� ������ ���������
 ��� ������ �������� ������� � ����� ���������� !!!
 ������� Disconnect ���������� � ����� ������
 ��������� ������� ����� � ������� Quit,  ���� ID ������ �� ����� 0
  � ���������� ����� � 0
 � Disconnect ������� ��������� ���� ID  ������ �� �� ����� 0 ��� -1
}


end.
