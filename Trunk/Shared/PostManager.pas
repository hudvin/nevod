unit PostManager;

interface
uses
   Windows,Shared, ADODB,DB,Settings, ThreadManager;

type
  TPostManager = class
  private
    Mutex: THandle;
    FADOCon: TADOConnection;
    PostSettings: TPostSettings;
    ThreadManager: TThreadManager;
  protected
  public
    constructor Create(ADOCon:TADOConnection);
    destructor Destroy;
  end;

implementation

constructor TPostManager.Create(ADOCon:TADOConnection);
begin
 Mutex:=CreateMutex(nil, False,MutexName);
 FADOCon:=ADOCon;
 PostSettings:=TPostSettings.Create(FADOCon);
 ThreadManager:=TThreadManager.Create(FADOCon,PostSettings);
end;

destructor TPostManager.Destroy;
begin
  FADOCon:=nil;
  PostSettings.Free;
  ThreadManager.Free;
  CloseHandle(Mutex);
end;

end.
