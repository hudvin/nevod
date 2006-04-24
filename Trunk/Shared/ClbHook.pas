unit ClbHook;

interface
uses Clipbrd,Messages,Windows,Controls,Dialogs;

type
  TClbHook = class
  public
    constructor Create(Handle:THandle);
    destructor Destroy; override;
    procedure WMChangeCBChain(var Msg: TWMChangeCBChain);
    message WM_CHANGECBCHAIN;
    procedure WMDrawClipboard(var Msg: TWMDrawClipboard);
    message WM_DRAWCLIPBOARD;
  private
    FHandle: THandle;
    PrevHwnd: Hwnd;
  end;

implementation

constructor TClbHook.Create(Handle:THandle);
begin
 FHandle:=Handle;
end;

destructor TClbHook.Destroy;
begin
end;

procedure TClbHook.WMChangeCBChain(var Msg: TWMChangeCBChain);
begin
  if PrevHWnd = Msg.Remove then
    PrevHWnd := Msg.Next;
  if Msg.Remove <> FHandle then
    SendMessage(PrevHWnd, WM_CHANGECBCHAIN, Msg.Remove, Msg.Next);
end;

procedure TClbHook.WMDrawClipboard(var Msg: TWMDrawClipboard);
var
  P: PChar;
  H: THandle;
  Len:integer;
begin
  SendMessage(PrevHWnd, WM_DRAWCLIPBOARD, 0, 0);
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    H := Clipboard.GetAsHandle(CF_TEXT);
    Len := GlobalSize(H) + 1;
    P := GlobalLock(H);
    ShowMessage(p);
    GlobalUnlock(H);
  end;
  Msg.Result := 0;
end;

end.
