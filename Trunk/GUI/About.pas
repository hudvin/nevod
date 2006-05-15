unit About;

interface

uses
  Windows, Messages, ShellAPI,SysUtils, Variants, Classes, Graphics, Controls, Forms,
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

implementation

{$R *.dfm}

procedure TFAbout.leSiteClick(Sender: TObject);
begin
 ShellExecute(Handle, nil, 'http://www.nevilon.com', nil, nil, SW_SHOW);
end;

procedure TFAbout.FormShow(Sender: TObject);
begin
 leOS.Caption:=_('Операционная система : ')+cInfo.ProductName;
 leCompName.Caption:=_('Имя компьютера : ')+cInfo.ComputerName;
 leCurrentUser.Caption:=_('Имя текущего пользователя : ')+cInfo.Username;
 leTimeRunning.Caption:= _('Время работы : ')+TimeToStr(cInfo.TimeRunning);
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
