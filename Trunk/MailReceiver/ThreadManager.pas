unit ThreadManager;

interface

uses
   Shared,PostReceiver,SysUtils, Windows,Classes,DateUtils,
   ActiveX,Dialogs, ADODB;


type
  TThreadManager = class(TThread)
  private
    StepForCheck:integer;
    CanExecute: Boolean;
    ClientTimeout: Integer;
    FADOCon: TADOConnection;
    PostReceivers: TThreadList;
    Settings: TSettings;
    procedure UpdateSettings;
  protected
  public
    constructor Create(ADOCon: TADOConnection);
    procedure StartAllThreads;
    procedure StartThread(AccountId: Integer);
  end;


implementation

{
******************************** TThreadManager ********************************
}
constructor TThreadManager.Create(ADOCon: TADOConnection);
begin
  inherited Create(False);
  PostReceivers:=TThreadList.Create;
  FADOCon:=ADOCon;
  CanExecute:=True;
  StepForCheck:=5000; // шаг для проверки удаленных потоков 
  {
  загрузить настройки и установить все аккаунты в свойство asFree
  }
end;

procedure TThreadManager.StartAllThreads;
begin
end;

procedure TThreadManager.StartThread(AccountId: Integer);
begin
end;

procedure TThreadManager.UpdateSettings;
begin
  ClientTimeout:=StrToInt(Settings.GetValue('ClientTimeout'));
end;



end.
