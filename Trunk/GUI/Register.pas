{$J+}
{$REALCOMPATIBILITY ON}
unit Register;

interface

uses
  Windows,gnugettext,RegistrationKey, Messages,ShellAPI, StdCtrls, cxContainer, cxEdit, cxProgressBar,
  Classes,aspr_api, Controls, cxControls, cxPC ,SysUtils, Variants,  Graphics,  Forms,  Shared,
  Dialogs, jpeg, ExtCtrls, JvImage, JvExExtCtrls;

type
  TFRegister = class(TForm)
    btExit: TButton;
    btEnterCode: TButton;
    btBuy: TButton;
    jvBack: TJvImage;
    cxProgressBar: TcxProgressBar;
    leNag: TLabel;
    btLater: TButton;
    Timer: TTimer;
    procedure btBuyClick(Sender: TObject);
    procedure btEnterCodeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btExitClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btLaterClick(Sender: TObject);
  private
    FResult: Integer;
    procedure ActivateWindow(var Msg:TMessage); message WM_ActivateWindow;
    { Private declarations }
  public
    property Result: Integer read FResult write FResult;
    { Public declarations }
  end;

 
var
  FRegister: TFRegister;
  RegistrationKeyForm:TFRegistrationKey;
  Days:integer;

const
  UserKey        : PChar  = nil;
  UserName       : PChar  = nil;

  ModeName       : PChar  = nil;

  TrialDaysTotal : DWORD  = DWORD(-1);
  TrialDaysLeft  : DWORD  = DWORD(-1);

implementation
uses main;
{$R *.dfm}

//{$R ..\Resources\Version.res}

procedure TFRegister.ActivateWindow(var Msg:TMessage);
begin
 SetForegroundWindow(Handle);
 SetActiveWindow(Handle);
 
end;

procedure TFRegister.btBuyClick(Sender: TObject);
begin
 ShellExecute(Handle, nil, 'http://www.emetrix.com', nil, nil, SW_SHOW);
end;

procedure TFRegister.btEnterCodeClick(Sender: TObject);
begin
 RegistrationKeyForm.ShowModal;
 if RegistrationKeyForm.Result=1 then
  begin
   Timer.Enabled:=False;
   Result:=1;
   Close;
  end;
end;

procedure TFRegister.FormCreate(Sender: TObject);
var
  ModeStatus : TModeStatus;
begin
 SetForegroundWindow(Handle);
 RegistrationKeyForm:=TFRegistrationKey.Create(nil);
 Result:=0;
 TranslateComponent(self);
 Caption := _('Nevod AntiSpam - Ознакомительный период истек');
 leNag.Caption:=_('Осталось дней : ')+ IntToStr(0);
 GetRegistrationInformation(UserKey,UserName );
 if (UserKey <> nil) AND (StrLen(UserKey) > 0) then
  begin 
   {$I ..\ASProtect\include\aspr_crypt_begin1.inc}
    GetModeInformation( ModeName, ModeStatus, True );
   {$I ..\ASProtect\include\aspr_crypt_end1.inc}
  end
 else
  if GetTrialDays( TrialDaysTotal, TrialDaysLeft ) then
    if TrialDaysLeft = 0 then
     begin
        Caption := _(' Nevod AntiSpam - Ознакомительынй период истек');
     end
    else
     begin
      Caption:=  _('Nevod AntiSpam - Незарегистрированная версия');
      cxProgressBar.Position:=TrialDaysLeft;
      leNag.Caption:=_('Осталось дней :')+ IntToStr(TrialDaysLeft);
      Days:=15-TrialDaysLeft+1;
      btLater.Caption:= IntToStr(TrialDaysLeft);
      Timer.Enabled:=True;
     end;
end;

procedure TFRegister.FormDestroy(Sender: TObject);
begin
 RegistrationKeyForm.Free;
end;

procedure TFRegister.btExitClick(Sender: TObject);
begin
 Result:=0;
 Close;
end;

procedure TFRegister.TimerTimer(Sender: TObject);
begin
  if Days=1 then
  begin
   Timer.Enabled:=False;
   btLater.Caption:=_('Позже');
   btLater.Enabled:=True;
  end
 else
  begin
  dec(Days);
  btLater.Caption:= IntToStr(Days);
  end; 
end;

procedure TFRegister.btLaterClick(Sender: TObject);
begin
 Result:=1;
 Close;
end;



end.
