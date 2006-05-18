unit About;

interface

uses
  Windows,aspr_api, Messages, ShellAPI,SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, JvImage, JvFormWallpaper, JvComponent, gnugettext,
  JvImageWindow, JvLinkLabel, JvComputerInfo, JvStarfield, StdCtrls;

type                                
  TFAbout = class(TForm)
    cInfo: TJvComputerInfo;
    leSite: TJvLinkLabel;
    bkImage: TJvImage;
    leMail: TJvLinkLabel;
    leOS: TLabel;
    leCompName: TLabel;
    leTimeRunning: TLabel;
    leCurrentUser: TLabel;
    btClose: TButton;
    leLicenseUsername: TLabel;
    leLicanseKey: TLabel;
    procedure leSiteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure leMailClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAbout: TFAbout;
  UserKey        : PChar  = nil;
  UserName       : PChar  = nil;

  ModeName       : PChar  = nil;

  TrialDaysTotal : DWORD  = DWORD(-1);
  TrialDaysLeft  : DWORD  = DWORD(-1);

  
implementation

{$R *.dfm}

procedure TFAbout.leSiteClick(Sender: TObject);
begin
 ShellExecute(Handle, nil, 'http://www.nevilon.com', nil, nil, SW_SHOW);
end;



procedure TFAbout.FormShow(Sender: TObject);
Var
  ModeStatus     : TModeStatus;
begin
 leOS.Caption:=_('Операционная система : ')+cInfo.ProductName;
 leCompName.Caption:=_('Имя компьютера : ')+cInfo.ComputerName;
 leCurrentUser.Caption:=_('Имя текущего пользователя : ')+cInfo.Username;
 leTimeRunning.Caption:= _('Время работы : ')+TimeToStr(cInfo.TimeRunning);

 GetRegistrationInformation(UserKey,UserName);
 if (UserKey <> nil) AND (StrLen(UserKey) > 0) then
  begin

   GetModeInformation( ModeName, ModeStatus, True );
   leLicenseUsername.Font.Color:=clNavy;
   leLicanseKey.Font.Color:=clNavy;
   leLicenseUsername.Caption:='Зарегистрирована на: '+StrPas(UserName);
   leLicanseKey.Caption:='Ключ: '+StrPas(UserKey);
 end
  else
   begin
     GetTrialDays( TrialDaysTotal, TrialDaysLeft );
    leLicenseUsername.Font.Color:=clRed;
    leLicanseKey.Font.Color:=clRed;
    leLicenseUsername.Caption:='trial';
    leLicanseKey.Caption:='Осталось дней: '+IntToStr(TrialDaysLeft);
   end;

end;

procedure TFAbout.leMailClick(Sender: TObject);
begin
 ShellExecute(Handle, nil, 'mailto:support@nevilon.com', nil, nil, SW_SHOW);
end;

procedure TFAbout.btCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TFAbout.FormCreate(Sender: TObject);
begin
 TranslateComponent(self);
end;

end.
