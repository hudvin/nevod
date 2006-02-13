unit ThreadManager;

interface

uses
   Shared,PostReceiver,SysUtils,TypInfo, Windows,Classes,DateUtils,
   ActiveX,Dialogs, ADODB;


type
  TThreadManager = class(TThread)
  private
    RunStep:integer;
    SleepTime:integer;
    CanExecute: Boolean;
    ClientTimeout: Integer;
    FADOCon: TADOConnection;
    PostReceivers: TList;
    Settings: TSettings;
    Accounts:TADOStoredProc;
    Commands:TADOStoredProc;
    procedure UpdateSettings;
    procedure SetStatus(Status:TAccountStatus;Id:integer);
    procedure Clean();
  protected
  public
    constructor Create(ADOCon: TADOConnection);
    procedure StartAllThreads;
    procedure StartThread(AccountId: Integer);
    procedure Execute();override;
  end;


implementation

{
******************************** TThreadManager ********************************
}
constructor TThreadManager.Create(ADOCon: TADOConnection);
begin
  inherited Create(False);
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

procedure TThreadManager.Execute();
var Counter:integer;
begin
  Counter:=RunStep;
  while not Terminated do
   begin
    UpdateSettings;
    Counter:=Counter+SleepTime; // время, через которое ищутся остановленные потоки
    Clean(); // удаление остановленных потоков
    if Counter>=RunStep  then
     begin
      StartAllThreads; // запуск потоков для получения
      Counter:=0;
     end;
    sleep(SleepTime);
  end;
  Terminate;
end;

procedure TThreadManager.StartAllThreads;
var
    AParams:AccountParams;
begin
  CoInitialize(nil);
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
        SetStatus(asClient,AParams.Id);   // создать объект для служебных целей
        Next;
       end;
     end;
    Close;
   end;
CoUninitialize;
end;

procedure TThreadManager.StartThread(AccountId: Integer);
begin
end;

procedure TThreadManager.UpdateSettings;
var
 tmp_ClientTimeout,tmp_RunStep,tmp_SleepTime:integer;
begin
  try
   tmp_ClientTimeout:=StrToInt(Settings.GetValue('ClientTimeout'));// время ожидания сервера
   tmp_RunStep:=StrToInt(Settings.GetValue('RunStep')); // промежуток проверки почты
   tmp_SleepTime:=StrToInt(Settings.GetValue('SleepTime'));   // шаг удаления потоков
   ClientTimeout:=tmp_ClientTimeout;
   RunStep:=tmp_RunStep;
   SleepTime:=tmp_SleepTime;
  except
  end;
end;

procedure TThreadManager.SetStatus(Status:TAccountStatus;Id:integer);
begin
  // использовать приведние типов к текстовому виду
  CoInitialize(nil);
  with Commands do
   begin
    Parameters.Clear;
    ProcedureName:='SetStatusById';
    with Parameters do
     begin
      Clear;
      AddParameter.Name:='status';
      ParamByName('status').Value:=GetEnumName(TypeInfo(TAccountStatus), Ord(Status));

      AddParameter.Name:='id';
      ParamByName('id').Value:=Id;
     end;
    ExecProc;
   end;
  CoUninitialize;
end;

procedure TThreadManager.Clean();
var
   i:integer;
begin
i:=0;
while i<PostReceivers.Count do
  begin
   if TBaseReceiver(PostReceivers[i]).Terminated then
       begin
         SetStatus(asFree,TBaseReceiver(PostReceivers[i]).AccountId);
     //    FreeAndNil(); проверить можно ли использовать
         TBaseReceiver(PostReceivers[i]).Free; // вызов деструктора получателя
         PostReceivers[i]:=nil; // обнуление массива  элементов
        end;
   inc(i);
  end;
PostReceivers.Pack;
end;



end.
