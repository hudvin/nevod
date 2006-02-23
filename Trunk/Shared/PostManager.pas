unit PostManager;

interface
uses
   Windows,Shared, ADODB,DB,Settings, ThreadManager, AccountManager;

type
  TPostManager = class
  private
    AccountManager: TAccountManager;
    FADOCommand: TADOCommand;
    Mutex: THandle;
    FADOCon: TADOConnection;
    PostSettings: TPostSettings;
    ThreadManager: TThreadManager;
    procedure UpdateAccounts;
  protected
  public
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
 UpdateAccounts;
end;

destructor TPostManager.Destroy;
begin
  FADOCon:=nil;
  PostSettings.Free;
  ThreadManager.Free;
  AccountManager.Free;
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

{
 обнуление всех аккаунтов перед запуском
 методы для
  запуска сервера
  останова сервера
  запуска потоков
  остановки потоков
  остановки фильтрации
  запуска потока
  останова потока
  полный останов получения или только текущего прохода
}

end.
