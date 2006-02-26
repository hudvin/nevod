unit PostManager;

interface
uses
   Windows,SysUtils,Classes, ActiveX, Shared,POPServer, ADODB,DB,Settings, ThreadManager, AccountManager;

type
  TPostManager = class
  private
    AccountManager: TAccountManager;
    FADOCommand: TADOCommand;
    Mutex: THandle;
    FADOCon: TADOConnection;
    FServerPort: Integer;
    POP3Server: TPOPserver;
    ThreadManager: TThreadManager;
    function GetSetting(SettingName:String): string;
    procedure SetServerPort(const Value: Integer);
    procedure SetSetting(SettingName:String; const Value: string);
    procedure UpdateAccounts;
    property Setting[SettingName:String]: string read GetSetting write SetSetting;
  protected
    SettingsProc: TADOQuery;
  public
    constructor Create(ADOCon:TADOConnection);
    destructor Destroy; override;
    procedure StartAllThreads;
    procedure StartThread(AccountId:Integer);
    procedure StopAllThreads(Soft:boolean=False);
    procedure StopThread(AccountId:Integer);
    property ServerPort: Integer read FServerPort write SetServerPort;
  end;

implementation

uses Exceptions;

constructor TPostManager.Create(ADOCon:TADOConnection);
begin
 Mutex:=CreateMutex(nil, False,MutexName);
 FADOCon:=ADOCon;
 FADOCommand:=TADOCommand.Create(nil);
 FADOCommand.Connection:=FADOCon;
 SettingsProc:=TADOQuery.Create(nil);
 SettingsProc.Connection:=FADOCon;
 AccountManager:=TAccountManager.Create(FADOCon);
 ThreadManager:=TThreadManager.Create(FADOCon,AccountManager,False); // запуск в пассивном состоянии
 ThreadManager.CheckInterval:=StrToInt(Setting['CheckInterval']);
 POP3Server:=TPOPServer.Create(FADOCon,AccountManager,StrToInt(Setting['ServerPort']));
 UpdateAccounts;
end;

destructor TPostManager.Destroy;
begin
  POP3Server.Free;
  StopAllThreads();
  ThreadManager.Free;
  AccountManager.Free;
  SettingsProc.Free;
  FADOCommand.Free;
  FADOCon:=nil;
  CloseHandle(Mutex);
end;

function TPostManager.GetSetting(SettingName:String): string;
begin
 with SettingsProc  do
  begin
   Close;
   SQL.Text:='SELECT Var FROM Settings WHERE Name=:SettingName';
   Parameters.ParamByName('Settingname').Value:=SettingName;
   ExecSQL;
   Open;
   if RecordCount=0 then    // если выборка не вернула записей
    begin
     Close;
     Result:='';
     Raise EInvalidSettingName.Create(' Invalid Setting Name ');
    end
   else
    begin
     Result:=Fields[0].AsString;
     Close;
    end;
  end;
end;

procedure TPostManager.SetServerPort(const Value: Integer);
begin
 if Value<>FServerPort then
  begin
    Setting['ServerPort']:=IntToStr(Value);
    POP3Server.DefaultPort:=Value;
  end;
end;

procedure TPostManager.SetSetting(SettingName:String; const Value: string);
begin
 with SettingsProc do
  begin
   Close;
   SQL.Text:='SELECT COUNT (Id) FROM Settings WHERE Name=:SettingName';
   Parameters.ParamByName('SettingName').Value:=SettingName;
   ExecSQL;
   Open;
   if Fields[0].AsInteger=0 then
    begin
     Close;
     Raise EInvalidSettingName.Create(' Invalid Setting Name ');
    end
   else
    begin
     Close;
     SQL.Text:='UPDATE Settings SET Var=:Value WHERE Name=:SettingName';
     Parameters.ParamByName('Value').Value:=Value;
     Parameters.ParamByName('SettingName').Value:=SettingName;
     ExecSQL;
    end;
  end;
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
 в базе хранить uid сообшений !

 }
end.

