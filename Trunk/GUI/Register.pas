{$J+}
{$REALCOMPATIBILITY ON}
unit Register;

interface

uses
  Windows,RegistrationKey, Messages,ShellAPI, StdCtrls, cxContainer, cxEdit, cxProgressBar,
  Classes,aspr_api, Controls, cxControls, cxPC ,SysUtils, Variants,  Graphics,  Forms,
  Dialogs, jpeg, ExtCtrls, JvImage;

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
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btLaterClick(Sender: TObject);
  private
    FResult: Integer;
    { Private declarations }
  public
    property Result: Integer read FResult write FResult;
    { Public declarations }
  end;

var
  FRegister: TFRegister;
  RegistrationKeyForm:TFRegistrationKey;
  

const
  UserKey        : PChar  = nil;
  UserName       : PChar  = nil;

  ModeName       : PChar  = nil;

  TrialDaysTotal : DWORD  = DWORD(-1);
  TrialDaysLeft  : DWORD  = DWORD(-1);

implementation

{$R *.dfm}
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
begin
 RegistrationKeyForm:=TFRegistrationKey.Create(nil);
 Result:=1;
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

procedure TFRegister.FormShow(Sender: TObject);
var
  ModeStatus : TModeStatus;
begin
 Caption := 'Ознакомительный период истек';
 GetRegistrationInformation(UserKey,UserName );
 if (UserKey <> nil) AND (StrLen(UserKey) > 0) then
  begin
   {$I ..\ASProtect\include\aspr_crypt_begin1.inc}
    GetModeInformation( ModeName, ModeStatus, True );
    ShowMessage('Зарегано');
    {$I ..\ASProtect\include\aspr_crypt_end1.inc}
  end
 else
  if GetTrialDays( TrialDaysTotal, TrialDaysLeft ) then
   begin
    if TrialDaysLeft = 0 then
     begin
        Caption := 'Ознакомительынй период истек';
     end
    else
     begin
      Caption:=  'Незарегистрированная версия';
      cxProgressBar.Position:=TrialDaysLeft;
      leNag.Caption:='Осталось дней :'+ IntToStr(TrialDaysLeft);
      btLater.Caption:= IntToStr(15-TrialDaysLeft);
      Timer.Enabled:=True;
     end;
    end;
end;

procedure TFRegister.TimerTimer(Sender: TObject);
begin
 if StrToInt(btLater.Caption)=0 then
  begin
   Timer.Enabled:=False;
   btLater.Caption:='Позже';
   btLater.Enabled:=True;
  end
 else
  btLater.Caption:= IntToStr(StrToInt(btLater.Caption)-1);   
end;

procedure TFRegister.btLaterClick(Sender: TObject);
begin
 Result:=1;
 Close;
end;

end.
