unit PostManager;

interface
uses
   Windows,Shared,POPServer, ADODB,DB,Settings, ThreadManager, AccountManager;

type
  TPostManager = class
  private
    AccountManager: TAccountManager;
    FADOCommand: TADOCommand;
    Mutex: THandle;
    FADOCon: TADOConnection;
    POP3Server: TPOPserver;
    ThreadManager: TThreadManager;
    procedure UpdateAccounts;
  protected
  public
    PostSettings: TPostSettings;
    constructor Create(ADOCon:TADOConnection);
    destructor Destroy; override;
    procedure StartAllThreads;
    procedure StartThread(AccountId:Integer);
    procedure StopAllThreads(Soft:boolean=False);
    procedure StopThread(AccountId:Integer);
  end;

implementation

constructor TPostManager.Create(ADOCon:TADOConnection);
begin
 Mutex:=CreateMutex(nil, False,MutexName);
 FADOCon:=ADOCon;
 PostSettings:=TPostSettings.Create(FADOCon);
 AccountManager:=TAccountManager.Create(FADOCon);
 ThreadManager:=TThreadManager.Create(FADOCon,PostSettings,AccountManager,False); // запуск в пассивном состоянии
 FADOCommand:=TADOCommand.Create(nil);
 FADOCommand.Connection:=FADOCon;
 POP3Server:=TPOPServer.Create(FADOCon,PostSettings,AccountManager);
 UpdateAccounts;
end;

destructor TPostManager.Destroy;
begin
  StopAllThreads();
  FADOCommand.Free;
  ThreadManager.Free;
  AccountManager.Free;
  PostSettings.Free;
  FADOCon:=nil;
  CloseHandle(Mutex);
end;

procedure TPostManager.StartAllThreads;
begin
  Threadmanager.StartAllThreads(False);
end;

procedure TPostManager.StartThread(AccountId:Integer);
begin
  ThreadManager.StartThread(AccountId,True);
end;

procedure TPostManager.StopAllThreads(Soft:boolean=False);
begin
  ThreadManager.StopAllThreads(Soft);
end;

procedure TPostManager.StopThread(AccountId:Integer);
begin
 ThreadManager.StopThread(AccountId);
end;

procedure TPostManager.UpdateAccounts;
begin
 FADOCommand.CommandText:=' UPDATE Accounts SET Status='+''''+'asFree'+'''';
 FADOCommand.Execute;
end;

end.
