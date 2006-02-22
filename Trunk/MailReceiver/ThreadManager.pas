unit ThreadManager;

interface

uses  Exceptions, Settings,   Shared,PostReceiver,
SysUtils,TypInfo, Windows,Classes,DateUtils,Dialogs, ADODB, AccountManager;


type
  TThreadManager = class(TThread)
  private
    Accounts: TADOStoredProc;
    FCanExecute: Boolean;
    ClientTimeout: Integer;
    FAccountManager: TAccountManager;
    FADOCon: TADOConnection;
    Mutex: THandle;
    FSettings: TPostSettings;
    PostReceivers: TList;
    RunStep: Integer;
    Settings: TSettings;
    SleepTime: Integer;
    procedure Clean;
    function GetActiveThreads: Integer;
    procedure UpdateSettings;
  public
    constructor Create(ADOCon: TADOConnection;PostSettings:TPostSettings;
        AccountManager:TAccountManager;CanExecute:Boolean=True);
    destructor Destroy; override;
    procedure Execute; override;
    procedure StartAllThreads(Intro:boolean=True);
    procedure StartThread(AccountId: Integer;Single:Boolean=False);
    procedure StopAllThreads(Soft:boolean=False);
    procedure StopThread(Item: Integer);
    property ActiveThreads: Integer read GetActiveThreads;
  end;


implementation

uses DB, StrUtils;

{
******************************** TThreadManager ********************************
}
constructor TThreadManager.Create(ADOCon: TADOConnection;
    PostSettings:TPostSettings; AccountManager:TAccountManager;
    CanExecute:Boolean=True);
begin
  inherited Create(False);
  FSettings:=PostSettings;
  Mutex:=CreateMutex(nil,False,MutexName);
  FAccountManager:=AccountManager;
  PostReceivers:=TList.Create;
  FADOCon:=ADOCon;
  FCanExecute:=CanExecute;
  UpdateSettings;
end;

destructor TThreadManager.Destroy;
begin
  inherited Destroy;
  CloseHandle(Mutex);
  FADOCon:=nil;
  FSettings := nil;
  FAccountManager:=nil;
end;

procedure TThreadManager.Clean;
var
  i: Integer;
begin
  i:=0;
  while i<PostReceivers.Count do
    begin
     if TBaseReceiver(PostReceivers[i]).Terminated then
         begin
           FAccountManager.SetStatus(TBaseReceiver(PostReceivers[i]).AccountId,asFree);
           TBaseReceiver(PostReceivers[i]).Free; // вызов деструктора получателя
           PostReceivers[i]:=nil; // обнуление массива  элементов
         end;
     inc(i);
    end;
  PostReceivers.Pack;
end;

procedure TThreadManager.Execute;
var
  Counter: Integer;
begin
  Counter:=RunStep;
  while not Terminated do
   begin
    Counter:=Counter+SleepTime;
    WaitForSingleObject(Mutex,SleepTime) ;
    UpdateSettings;
    Clean();
    if (Counter>=RunStep) and (FCanExecute) then
     begin
      StartAllThreads; // запуск потоков для получения
      Counter:=0;
     end;
    sleep(SleepTime);
    ReleaseMutex(Mutex);
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

procedure TThreadManager.StartAllThreads(Intro:boolean=True);
var
  AParams: TAccountParams;
  i:integer;
begin
 {

 если запускаются из класса - запускать сразу
  если снаружи - ждать мьютекс

 }
 if Intro then   // если запуск из класса
  begin
   FCanExecute:=True;
   for i :=1  to FAccountManager.Count  do
    if FAccountManager.Items[i].Status=asFree
     then StartThread(FAccountManager.Items[i].Id);
  end
 else  // если запуск из надкласса или интерфейса
  begin
   WaitForSingleObject(Mutex,INFINITE);
    FCanExecute:=True;
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
    PostReceivers.Add(TPOP3Receiver.Create(AParams,FADOCon,ClientTimeout,True));
   ReleaseMutex(Mutex);
  end
 else // если запуск происходит из процедуры StartAllThreads - мьютекс захвачен
  begin
   FAccountManager.SetStatus(AccountId,asClient);
   PostReceivers.Add(TPOP3Receiver.Create(AParams,FADOCon,ClientTimeout,True));
  end;
end;

procedure TThreadManager.StopAllThreads(Soft:boolean=False);
var
 i:integer;
begin
 if NOT Soft then
   FCanExecute:=False;
 WaitForSingleObject(Mutex,INFINITE);
  Clean;
  for i :=0  to PostReceivers.Count-1  do
   begin

   end;

  {
  очистить потоки
  удалить все активные - вызват функцию
  }
 ReleaseMutex(Mutex);

  {
  если мягкая остановка - просто остановить все потоки
  если нет - выставить CanExecute:=False
  }
end;

procedure TThreadManager.StopThread(Item: Integer);  // удаление по индексу
begin
 if not TBaseReceiver(PostReceivers[Item]).Terminated then
  PostReceivers[Item]:=nil
   else
    begin
     TBaseReceiver(PostReceivers[Item]).Free;
     PostReceivers[Item]:=nil;
    end;
end;

procedure TThreadManager.UpdateSettings;
begin
 ClientTimeout:=StrToInt(FSettings.Setting['ClientTimeout']);
 RunStep:=StrToInt(FSettings.Setting['RunStep']);
 SleepTime:=StrToInt(FSettings.Setting['SleepTime']);
end;

{

все действия в отдельный функциях

функции для остановки всех потоков
для остановки одного потока
 в каждой процедуре захватывать мьютекс
 поток получения останавливать сразу - в UI сделать запрос
 свойство с количеством активных потоков
 возможность остановки потоков полностью или только в текущем цикле
  в любом случае захватывать мьютекс
 передавать в констркукторе - запускать ли потоки сразу
}

end.
