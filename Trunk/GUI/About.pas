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
    leVersion: TJvLinkLabel;
    procedure leSiteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure leMailClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function FileVersion(AFileName: string): string;
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
 leOS.Caption:=_('������������ ������� : ')+cInfo.ProductName;
 leCompName.Caption:=_('��� ���������� : ')+cInfo.ComputerName;
 leCurrentUser.Caption:=_('��� �������� ������������ : ')+cInfo.Username;
 leTimeRunning.Caption:= _('����� ������ : ')+TimeToStr(cInfo.TimeRunning);
 leVersion.Caption:=_('������: ')+FileVersion(Application.ExeName);
 GetRegistrationInformation(UserKey,UserName);
 if (UserKey <> nil) AND (StrLen(UserKey) > 0) then
  begin
   GetModeInformation( ModeName, ModeStatus, True );
   leLicenseUsername.Caption:=_('���������������� ��: ')+StrPas(UserName);
  end
  else
   begin
     GetTrialDays( TrialDaysTotal, TrialDaysLeft );
    leLicenseUsername.Font.Color:=clRed;
    leLicenseUsername.Caption:=_('�������������������� ������');
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

function TFAbout.FileVersion(AFileName: string): string;
var
  szName: array[0..255] of Char;
  P: Pointer;
  Value: Pointer;
  Len: UINT;
  GetTranslationString: string;
  FFileName: PChar;
  FValid: boolean;
  FSize: DWORD;
  FHandle: DWORD;
  FBuffer: PChar;
begin
 try
  FFileName := StrPCopy(StrAlloc(Length(AFileName) + 1), AFileName);
  FValid := False;
  FSize := GetFileVersionInfoSize(FFileName, FHandle);
  if FSize > 0 then
   try
    GetMem(FBuffer, FSize);
    FValid := GetFileVersionInfo(FFileName, FHandle, FSize, FBuffer);
   except
    FValid := False;
      raise;
   end;
   Result := '';
   if FValid then
    VerQueryValue(FBuffer, '\VarFileInfo\Translation', p, Len)
   else
    p := nil;
   if P <> nil then
    GetTranslationString := IntToHex(MakeLong(HiWord(Longint(P^)),
     LoWord(Longint(P^))), 8);
   if FValid then
    begin
     StrPCopy(szName, '\StringFileInfo\' + GetTranslationString + '\FileVersion');
     if VerQueryValue(FBuffer, szName, Value, Len) then
        Result := StrPas(PChar(Value));
    end;
   finally
    try
      if FBuffer <> nil then
        FreeMem(FBuffer, FSize);
    except
    end;
    try
      StrDispose(FFileName);
    except
    end;
  end;
end;

procedure TFAbout.FormCreate(Sender: TObject);
begin
 TranslateComponent(self);
end;

end.
