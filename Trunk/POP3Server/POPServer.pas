unit POPServer;

interface
uses Shared,Windows,Dialogs, Messages, SysUtils,IdContext, StdCtrls, ADODB, IdBaseComponent, IdComponent,
     IdTCPServer, IdPOP3Server, Settings, AccountManager;

type
 TPOPServer=class
  public
   constructor Create(ADOCon:TADOConnection;Settings:TPostSettings;
       AccountManager:TAccountManager);
   destructor  Destroy(); override;
  private
   FAccountManager: TAccountManager;
   FADOCon: TADOConnection;
   FSettings: TPostSettings;
   Mutex: THandle;
   pop:TIdPOP3Server;
   procedure CheckAccount(AThread: TIdContext;LThread: TIdPOP3ServerContext);
end;

implementation

constructor TPOPServer.Create(ADOCon:TADOConnection;Settings:TPostSettings;
    AccountManager:TAccountManager);
begin
 Mutex:=CreateMutex(nil,False,MutexName);
 FADOCon:=ADOCon;
 FAccountManager:=AccountManager;
 FSettings:=Settings;
 pop:=TIdPOP3Server.Create(nil);

with pop do
 begin
 // WaitForSingleObject(Mutex,INFINITE);
 //  DefaultPort:=StrToInt(FSettings.Setting['ServerPort']);
   CheckUser:=CheckAccount;
//  ReleaseMutex(Mutex); 
  { OnLIST:=LIST;
   OnSTAT:=STAT;
   OnRETR:=RETR;
   OnDELE:=DELE;
   OnQUIT:=QUIT;
   OnDisconnect:=Disconnect;
   Active:=true; }
 end;
   pop.Active:=True;
end;

destructor TPOPServer.Destroy();
begin
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
  ShowMessage('dd');
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
     end;    // case
  end;
 ReleaseMutex(Mutex);
end;

{

хранить спискок хостов, с которыми разрешено соединения
разрешать только localhost

жестко задавать интервал поиска удаленных потоков
                 порт сервера (использовать совй !!! )

для хранения настроек использовать наследников от базового класса

хранить количество активных потоков сервера
 увеличивать с помошью внутреннего мьютекса


  класс для хранения настроек
    или хранить в реестре !


  создавать ключи инсталлятором в реестре !!!  
  ставить мьютекс на подключение, разрыв и отключение

}


end.
