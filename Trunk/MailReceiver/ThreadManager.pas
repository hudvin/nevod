unit ThreadManager;

interface

uses  Exceptions, Settings,   Shared,PostReceiver,
SysUtils,TypInfo, Windows,Classes,DateUtils,Dialogs, ADODB;


type
  TThreadManager = class(TThread)
  private
    Accounts: TADOStoredProc;
    CanExecute: Boolean;
    ClientTimeout: Integer;
    Commands: TADOStoredProc;
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
    constructor Create(ADOCon: TADOConnection;PostSettings:TPostSettings);
    destructor Destroy; override;
    procedure Execute; override;
    procedure StartAllThreads;
    procedure StartThread(AccountId: Integer);
    property ActiveThreads: Integer read GetActiveThreads;
  end;


implementation

uses DB;

{
******************************** TThreadManager ********************************
}
constructor TThreadManager.Create(ADOCon: TADOConnection;
    PostSettings:TPostSettings);
begin
  inherited Create(False);
  FSettings:=PostSettings;
  Mutex:=CreateMutex(nil,False,MutexName);
  PostReceivers:=TList.Create;
  FADOCon:=ADOCon;
  Settings:=TSettings.Create(FADOCon);
  Commands:=TADOStoredProc.Create(nil);
  Commands.Connection:=FADOCon;
  Accounts:=TADOStoredProc.Create(nil);
  Accounts.Connection:=FADOCon;
  Accounts.ProcedureName:='SetStatusToFree';
  Accounts.ExecProc;
  CanExecute:=True;
  UpdateSettings;
end;

destructor TThreadManager.Destroy;
begin
  inherited Destroy;
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
         //  SetStatus(asFree,TBaseReceiver(PostReceivers[i]).AccountId);
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
    UpdateSettings; // обновлять параметры менеджера
    Counter:=Counter+SleepTime; // время, через которое ищутся остановленные потоки
    // захват мьютекса добавлять время после захвата мьютекса
    Clean(); // удаление остановленных потоков
    if Counter>=RunStep  then
     begin
      StartAllThreads; // запуск потоков для получения
      Counter:=0;
     end;
    sleep(SleepTime);
    // освобождение мьютекса
   end;
  Terminate;
end;

function TThreadManager.GetActiveThreads: Integer;
begin
  //  Result := FActiveThreads;
end;

procedure TThreadManager.StartAllThreads;
var
  AParams: TAccountParams;
begin
    CanExecute:=True;
    with Accounts do
     begin
      ProcedureName:='GetFreeAccountList';
      ExecProc;
      Open;
      First;
      while not Eof do
       begin
        with AParams do
         begin
          AccountName:=FieldByName('AccountName').AsString;
          Username:=FieldByName('Username').AsString;
          Host:=FieldByName('Host').AsString;
          Password:=FieldByName('Password').AsString;
          Port:=FieldByName('Port').AsInteger;
          Id:=FieldByName('Id').AsInteger;
          PostReceivers.Add(TPOP3Receiver.Create(AParams,FADOCon,ClientTimeout,True));   // создавать в зависимости от типа протокола
       //   SetStatus(asClient,AParams.Id);   // создать объект для служебных целей
          Next;
         end;
       end;
      Close;
     end;
end;

procedure TThreadManager.StartThread(AccountId: Integer);
begin
end;

procedure TThreadManager.UpdateSettings;
begin
 ClientTimeout:=StrToInt(FSettings.Setting['ClientTimeout']);
 RunStep:=StrToInt(FSettings.Setting['RunStep']);
 SleepTime:=StrToInt(FSettings.Setting['SleepTime']);
end;

end.
