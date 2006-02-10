unit ThreadManager;

interface
uses  Shared,
    PostReceiver,SysUtils, Windows,Classes,DateUtils,ActiveX,Dialogs, ADODB;

type
  TThreadManager=class(TThread)
    public
     constructor Create(ADOCon:TADOConnection);
     destructor  Destroy();
     procedure Execute();override;
    private
     ACon:TADOConnection;
     PostRecThreads:TList;
     CanExecute:boolean;
     Step:integer;  // время между запусками потоков
     TimeOut:integer;
     function GetSettingValue(SettingName:string):integer;
     procedure Clean();  // поиск и удаление остановленных потоков
     procedure SetStatus(status:string;Id:integer);
     procedure StartAllThreads();
     procedure UpdateSettings();
     procedure StopAllThreads();
     procedure SetToFree();
end;

implementation

constructor TThreadManager.Create(ADOCon:TADOConnection);
begin
inherited Create(False);
ACon:=ADOCon;
PostRecThreads:=TList.Create;
CanExecute:=True;
UpdateSettings();
SetToFree;
end;

destructor TThreadManager.Destroy();
begin
StopAllThreads;
PostRecThreads.Free;
end;


procedure TThreadManager.SetToFree();
var Adc:TADOCommand;
begin
Adc:=TADOCommand.Create(nil);
Adc.Connection:=ACon;
Adc.CommandText:='UPDATE Accounts SET Status='+ ''''+'asFree'+'''';
Adc.Execute;
Adc.Free;
end;

procedure TThreadManager.Execute();
var Counter:integer;
begin
Counter:=0;
while not Terminated do
  begin
    Counter:=Counter+1000; // время, через которое ищутся остановленные потоки
    Clean(); // удаление остановленных потоков
    if Counter>=Step  then
      begin
        StartAllThreads; // запуск потоков для получения
        Counter:=0;
      end;
    sleep(1000);
  end;
end;


procedure TThreadManager.Clean();
var
   i:integer;
begin
i:=0;
while i<PostRecThreads.Count do
  begin
   if TBaseReceiver(PostRecThreads[i]).Terminated then
       begin
         SetStatus('asFree',TBaseReceiver(PostRecThreads[i]).AccountId);
         TBaseReceiver(PostRecThreads[i]).Free; // вызов деструктора получателя
         PostRecThreads[i]:=nil; // обнуление массива  элементов
        end;
   inc(i);
  end;
PostRecThreads.Pack;
end;


procedure TThreadManager.SetStatus(status:string;Id:integer);
var
    Ast:TADOStoredProc;
begin
CoInitialize(nil);
Ast:=TADOStoredProc.Create(nil);
Ast.Connection:=ACon;
Ast.ProcedureName:='SetStatusById';
with   Ast.Parameters do
  begin
    Clear;
    AddParameter.Name:='status';
    ParamByName('status').Value:=status;

    AddParameter.Name:='id';
    ParamByName('id').Value:=Id;
  end;
Ast.ExecProc;
Ast.Free;
CoUninitialize;
end;


procedure TThreadManager.StartAllThreads();
var
    Ast:TADOStoredProc;
    AParams:AccountParams;
begin
CanExecute:=True;
CoInitialize(nil);
Ast:=TADOStoredProc.Create(nil);
Ast.Connection:=ACon;
Ast.ProcedureName:='GetFreeAccountList';
Ast.ExecProc;
Ast.Open;
Ast.First;
while not ast.Eof do
 begin
   with ast do
     begin
      AParams.AccountName:=FieldByName('AccountName').AsString;
      AParams.Username:=FieldByName('Username').AsString;
      AParams.Host:=FieldByName('Host').AsString;
      AParams.Password:=FieldByName('Password').AsString;
      AParams.Port:=FieldByName('Port').AsInteger;
      AParams.Id:=FieldByName('Id').AsInteger;
      PostRecThreads.Add(TPOP3Receiver.Create(AParams,ACon,TimeOut,True));   // создавать в зависимости от типа протокола
      SetStatus('asClient',AParams.Id);
      Next;
    end;
   end;
Ast.Free;
CoUninitialize;
end;


procedure TThreadManager.UpdateSettings();
begin
TimeOut:=GetSettingValue('ClientTimeOut');
Step:=GetSettingValue('Step');
end;

function TThreadManager.GetSettingValue(SettingName:string):integer;
var
    Ast:TADOStoredProc;
    Res:integer;
begin
Ast:=TADOStoredProc.Create(nil);
with Ast do
  begin
    Connection:=ACon;
    ProcedureName:='GetSettingValue';
    with Parameters  do
      begin
        Clear;
        AddParameter.Name:='SettingName';
        ParamByName('SettingName').Value:=SettingName;
      end;
    ExecProc;
    Open;
    Res:=StrToInt(Fields[0].AsString);
    Close;
    Free;
end;
Result:=Res;
end;

procedure TThreadManager.StopAllThreads();
var
    i:integer;
begin
CanExecute:=False;
i:=0;
Clean;
while i<PostRecThreads.Count do
  begin
   try
   if not TBaseReceiver(PostRecThreads[i]).Terminated then
     PostRecThreads[i]:=nil
       else
        begin
         TBaseReceiver(PostRecThreads[i]).Free;
         PostRecThreads[i]:=nil;
        end;
   except;
   end;
   inc(i);
  end;
PostRecThreads.Pack;
end;

{ использовать приведение типов для использования нескольких
  различных классов для получения сообщений
  приводить через базовый класс
  создать общий класс процедуры для SetStatus и прочее
}

end.
