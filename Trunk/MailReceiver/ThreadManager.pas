unit ThreadManager;

interface

uses  gnugettext,
      Exceptions, DB, StrUtils, Shared,PostReceiver,WinSock, Messages,  CoolTrayIcon,
     SysUtils,TypInfo, Windows,Classes,DateUtils,Dialogs, ADODB, AccountManager;


type
  TThreadManager = class(TThread)
  private
    aCopyData: TCopyDataStruct;
    FAccountManager: TAccountManager;
    FADOCon: TADOConnection;
    Logger: TLogger;
    Mutex: THandle;
    PostReceivers: TList;
    SProvider: TSettings;
    Mess:TWMMessanger;
    procedure Clean;
    function GetActiveThreads: Integer;
    function GetCanExecute: Boolean;
    function GetCheckIfNotConnected: Boolean;
    function GetCheckInterval: Integer;
    function GetShowHint: Boolean;
    procedure SetCanExecute(const Value: Boolean);
  public
    constructor Create(ADOCon: TADOConnection; AccountManager:TAccountManager);
    destructor Destroy; override;
    procedure Execute; override;
    function IsConnected: Boolean;
    procedure SendHintMessage(AccountName:String;Caption:String;Message:String;
        BaloonType:TBalloonHintIcon;MessagesCount:integer);
    procedure StartAllThreads(Intro:boolean=True);
    procedure StartThread(AccountId: Integer;Single:Boolean=False);
    procedure StopAllThreads(Soft:boolean=False);
    procedure StopThread(AccountId: Integer); overload;
    property ActiveThreads: Integer read GetActiveThreads;
    property CanExecute: Boolean read GetCanExecute write SetCanExecute;
    property CheckIfNotConnected: Boolean read GetCheckIfNotConnected;
    property CheckInterval: Integer read GetCheckInterval;
    property ShowHint: Boolean read GetShowHint;
  end;


implementation
uses main;

{
******************************** TThreadManager ********************************
}
constructor TThreadManager.Create(ADOCon: TADOConnection;
    AccountManager:TAccountManager);
var
 i:integer;
begin
  inherited Create(False);
  FADOCon:=ADOCon;
  SProvider:=TSettings.Create(ADOCon);
  Mutex:=CreateMutex(nil,False,MutexName);
  FAccountManager:=AccountManager;
  PostReceivers:=TList.Create;
  Logger:=TLogger.Create(ADOCon);
  Mess:=TWMMessanger.Create;
  for I :=1 to FAccountManager.Count do    // Iterate
   FAccountManager.SetStatus(FAccountManager.Items[i].Id,asFree);

end;

destructor TThreadManager.Destroy;
begin
  Terminate;
  StopAllThreads();
  FADOCon:=nil;
  FAccountManager:=nil;
  CloseHandle(Mutex);
  SProvider.Free;
  Logger.Free;
  Mess.Free;
  PostReceivers.Free;
  inherited;
end;

procedure TThreadManager.Clean;
var
  i: Integer;
begin
  i:=0;
  while i<PostReceivers.Count do
    begin
     if TBaseReceiver(PostReceivers[i]).Terminated then
      with TBaseReceiver(PostReceivers[i]) do
        begin
         SendMessage(main.FMain.Handle, WM_UpdateLog,0,0);
    //     SendMessage(main.FMain.Handle,WM_UpdateAccountStatus,0,0);
         if SuccessFul=False then
          begin
           Logger.Add(LogMessage,AccountId,ltPostReceiver);
          
           SendHintMessage(AccountParams.AccountName,
               _(' Ошибка при получении почты для  ')+ '"'+AccountParams.AccountName +'"',
               LogMessage,
               bitError,
               MessagesCount);
          end
           else
            if MessagesCount>0 then
            begin

             Mess.Caption:=_(' Получена новая почта  для  ')+ '"'+AccountParams.AccountName +'"';
             Mess.LogMessage:=_(' Загружено ')+  ' '+IntToStr(MessagesCount)+ _(' новых писем');
             Mess.MessagesCount:=MessagesCount;
             Mess.BallonType:=bitInfo;
             SendHintMessage(
                AccountParams.AccountName,
                _(' Получена новая почта  для  ')+ '"'+AccountParams.AccountName +'"',
                _(' Загружено ')+  ' '+IntToStr(MessagesCount)+ _(' новых писем'),
                bitInfo,
                MessagesCount
             );
            end;
         FAccountManager.SetStatus(AccountId,asFree);
         Free;
         PostReceivers[i]:=nil;
        end;

     inc(i);
    end;
  PostReceivers.Pack;
end;

procedure TThreadManager.Execute;
var
  Counter: Integer;
begin
  sleep(WaitTime);
  Counter:=CheckInterval;
  while not Terminated do
   begin
    Counter:=Counter+WaitTime;
    Clean;
    // проверить можно ли проверять сообщения, если нет подключений
    if (CanExecute) and ( (IsConnected) or (CheckIfNotConnected) ) then
     begin
      WaitForSingleObject(Mutex,WaitTime) ;
   //   Clean();     // очищать нужно в любом случае
      if Counter>=CheckInterval  then
       begin
        StartAllThreads; // запуск потоков для получения
        Counter:=0;
       end;
      ReleaseMutex(Mutex);
     end;
    sleep(WaitTime);
   end;
  Terminate;
end;

function TThreadManager.GetActiveThreads: Integer;
begin
  WaitForSingleObject(Mutex,INFINITE);
    Clean();
    Result:=PostReceivers.Count;
  ReleaseMutex(Mutex);
end;

function TThreadManager.GetCanExecute: Boolean;
begin
 Result:= StrToBool(SProvider.GetValue('CanCheckAccounts'));
end;

function TThreadManager.GetCheckIfNotConnected: Boolean;
begin
 Result:=StrToBool(SProvider.GetValue('CheckIfNotConnected'));
end;

function TThreadManager.GetCheckInterval: Integer;
begin
 Result:=StrToInt(SProvider.GetValue('CheckInterval'));
end;

function TThreadManager.GetShowHint: Boolean;
begin
  Result:= StrToBool(SProvider.GetValue('ShowMessInfo'));
end;

function TThreadManager.IsConnected: boolean;
var
  s: TSocket;
  wsaD: WSADATA;
  NumInterfaces: Integer;
  BytesReturned, SetFlags: u_long;
  PtrA: pointer;
  Buffer: array[0..20] of INTERFACE_INFO;
  i: Integer;
begin
 WSAStartup($0101, wsaD);
 S := Socket(AF_INET, SOCK_STREAM, 0); // Открываем сокет
 if (s = INVALID_SOCKET) then
  exit;
 try // Вызываем WSAIoCtl
  PtrA := @bytesReturned;
  if (WSAIoCtl(s, SIO_GET_INTERFACE_LIST, nil, 0, @Buffer,1024, PtrA, nil, nil) <> SOCKET_ERROR) then
    begin
     NumInterfaces := BytesReturned div SizeOf(INTERFACE_INFO);
     i:=0;
     Result:=false;
     while (i<NumInterfaces) and (not Result) do
      begin
       SetFlags := Buffer[i].iiFlags;
       if  ((SetFlags and IFF_UP) = IFF_UP) then
        if (SetFlags and IFF_LOOPBACK) <>IFF_LOOPBACK then
        Result:=True
       else inc(i);
      end;

 end;
 except
  CloseSocket(s);
  WSACleanUp;
 end;
end;

procedure TThreadManager.SendHintMessage(AccountName:String;Caption:String;
    Message:String; BaloonType:TBalloonHintIcon;MessagesCount:integer);
begin

 Mess.Caption:=Caption;
 Mess.LogMessage:=Message;
 Mess.MessagesCount:=MessagesCount;
 Mess.BallonType:=BaloonType;
 with aCopyData do
  begin
   dwData := 1;
   cbData := SizeOf(TWMMessanger);
   lpData:=@Mess
  end;
 SendMessage(main.FMain.Handle, WM_COPYDATA, Longint(main.FMain.Handle), Longint(@aCopyData));
end;

procedure TThreadManager.SetCanExecute(const Value: Boolean);
begin
 SProvider.SetValue('CanCheckAccounts',BoolToStr(Value,True));
end;

procedure TThreadManager.StartAllThreads(Intro:boolean=True);
var
  i:integer;
begin
// FCanExecute:=True;
 if Intro then   // если запуск из класса
  begin

   for i :=1  to FAccountManager.Count  do
    if FAccountManager.Items[i].Status=asFree
     then StartThread(FAccountManager.Items[i].Id);
  end
 else  // если запуск из надкласса или интерфейса
  begin
   WaitForSingleObject(Mutex,INFINITE);
 //   FCanExecute:=True;
    for i :=1  to FAccountManager.Count  do
     if FAccountManager.Items[i].Status=asFree
      then StartThread(FAccountManager.Items[i].Id);
   ReleaseMutex(Mutex);
  end;
end;

procedure TThreadManager.StartThread(AccountId: Integer;Single:Boolean=False);
var
 AParams:TAccountParams;
begin
 AParams:=FAccountManager.AccountById[AccountId];
 if Single then  // если запуск одиночного потока
  begin
   WaitForSingleObject(Mutex,INFINITE);
    FAccountManager.SetStatus(AccountId,asClient);
    PostReceivers.Add(TPOP3Receiver.Create(AParams,FADOCon,False));
   ReleaseMutex(Mutex);
  end
 else // если запуск происходит из процедуры StartAllThreads - мьютекс захвачен
  begin
   FAccountManager.SetStatus(AccountId,asClient);
   PostReceivers.Add(TPOP3Receiver.Create(AParams,FADOCon,false));
  end;
end;

procedure TThreadManager.StopAllThreads(Soft:boolean=False);
var
 i:integer;
begin
// if NOT Soft then CanExecute:=False;
 WaitForSingleObject(Mutex,INFINITE);
 // Clean;
  for i :=0  to PostReceivers.Count-1  do
    if not TBaseReceiver(PostReceivers[i]).Terminated then
     begin
      FAccountManager.SetStatus(TBaseReceiver(PostReceivers[i]).AccountId,asFree);
      TBaseReceiver(PostReceivers[i]).Free;
      PostReceivers[i]:=nil;
     end;
 PostReceivers.Pack;   
 ReleaseMutex(Mutex);

  {
  если мягкая остановка - просто остановить все потоки
  если нет - выставить CanExecute:=False
  }
end;

procedure TThreadManager.StopThread(AccountId: Integer);
var
 i:integer;
begin
 WaitForSingleObject(Mutex,500);
  for i :=0  to PostReceivers.Count-1 do
   if TBaseReceiver(PostReceivers[i]).AccountId=AccountId then
  {  if not TBaseReceiver(PostReceivers[i]).Terminated then
     begin
      TBaseReceiver(PostReceivers[i]).Free;   INFINITE
      PostReceivers[i]:=nil;
      FAccountManager.SetStatus(AccountId);
     end
    else
     begin
      PostReceivers[i]:=nil;     }
     begin
      TBaseReceiver(PostReceivers[i]).Free;
      PostReceivers[i]:=nil;
      FAccountManager.SetStatus(AccountId,asFree);
     end;
   //  end;
  PostReceivers.Pack;
  //Clean;
 ReleaseMutex(Mutex);
 end;


end.
