unit multinst;


interface

uses Forms,main, Windows, Dialogs,Shared, SysUtils;

const

  MI_NO_ERROR = 0;
  MI_FAIL_SUBCLASS = 1;
  MI_FAIL_CREATE_MUTEX = 2;


function GetMIError: Integer;
function InitInstance: Boolean;

implementation

var

  MessageId: Integer;
  WProc: TFNWndProc = nil;
  MutHandle: THandle = 0;
  MIError: Integer = 0;

function GetMIError: Integer;
begin

  Result := MIError;
end;

function NewWndProc(Handle: HWND; Msg: Integer; wParam,

  lParam: Longint): Longint; stdcall;
begin

  { Если это - сообщение о регистрации... }

  if Msg = MessageID then
  begin
    { если основная форма минимизирована, восстанавливаем ее }

{ передаем фокус приложению }
    if IsIconic(Application.Handle) then
    begin
      main.FMain.tray.ShowMainForm;
      Application.MainForm.WindowState := wsNormal;
      ShowWindow(Application.Mainform.Handle, SW_SHOWNORMAL);
    end;
    SetForegroundWindow(Application.MainForm.Handle);
  end
    { В противном случае посылаем сообщение предыдущему окну }
  else
    Result := CallWindowProc(WProc, Handle, Msg, wParam, lParam);
end;

procedure SubClassApplication;
begin

  { Обязательная процедура. Необходима, чтобы обработчик }
  { Application.OnMessage был доступен для использования. }
  WProc := TFNWndProc(SetWindowLong(Application.Handle, GWL_WNDPROC,
    Longint(@NewWndProc)));
  { Если происходит ошибка, устанавливаем подходящий флаг }
  if WProc = nil then
    MIError := MIError or MI_FAIL_SUBCLASS;
end;

procedure DoFirstInstance;
begin

  SubClassApplication;
  MutHandle := CreateMutex(nil, False,PChar(GetCurrentUserSid));
  if MutHandle = 0 then
    MIError := MIError or MI_FAIL_CREATE_MUTEX;
end;

procedure BroadcastFocusMessage;
{ Процедура вызывается, если уже имеется запущенная копия Вашей программы. }
var

  BSMRecipients: DWORD;
begin
  { Не показываем основную форму }

  Application.ShowMainForm := False;
  { Посылаем другому приложению сообщение и информируем о необходимости }
  { перевести фокус на себя }
  BSMRecipients := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE,
    @BSMRecipients, MessageID, 0, 0);
end;

function InitInstance: Boolean;
begin

  MutHandle := OpenMutex(MUTEX_ALL_ACCESS, False, PChar(GetCurrentUserSid));
  if MutHandle = 0 then
  begin
    { Объект Mutex еще не создан, означая, что еще не создано }

{ другое приложение. }
    ShowWindow(Application.Handle, SW_ShowNormal);
    Application.ShowMainForm := True;
    DoFirstInstance;
    result := True;
  end
  else
  begin
    BroadcastFocusMessage;
    result := False;
  end;
end;

initialization
  begin

    //UniqueAppStr := Application.Exexname;
    MessageID := RegisterWindowMessage(PChar(GetCurrentUserSid));
   // ShowWindow(Application.Handle, SW_Hide);
    Application.ShowMainForm := FALSE;
  end;

finalization
  begin

    if WProc <> nil then
      { Приводим приложение в исходное состояние }

      SetWindowLong(Application.Handle, GWL_WNDPROC, LongInt(WProc));
  end;
end.
