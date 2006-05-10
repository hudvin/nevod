unit About;

interface

uses
  Windows, Messages, ShellAPI,SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, JvImage, JvFormWallpaper, JvComponent,
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
    procedure leSiteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAbout: TFAbout;

implementation

{$R *.dfm}

procedure TFAbout.leSiteClick(Sender: TObject);
begin
 ShellExecute(Handle, nil, 'http://www.nevilon.com', nil, nil, SW_SHOW);
end;

procedure TFAbout.FormShow(Sender: TObject);
begin
 leOS.Caption:='������������ ������� : '+cInfo.ProductName;
 leCompName.Caption:='��� ���������� : '+cInfo.ComputerName;
 leCurrentUser.Caption:='��� �������� ������������ : '+cInfo.Username;
 leTimeRunning.Caption:= '����� ������ : '+TimeToStr(cInfo.TimeRunning);
end;

end.
