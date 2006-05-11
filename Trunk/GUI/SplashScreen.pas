unit SplashScreen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, JvImage, StdCtrls, cxControls, cxContainer,
  cxEdit, cxProgressBar;

type
  TFSplashScreen = class(TForm)
    Timer1: TTimer;
    bkImage: TJvImage;
    Timer2: TTimer;
    pBar: TcxProgressBar;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSplashScreen: TFSplashScreen;

implementation

{$R *.dfm}

procedure TFSplashScreen.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled := false;
end;

procedure TFSplashScreen.FormShow(Sender: TObject);
begin
 { while Timer1.Enabled do                         
  begin
   sleep(50);
   
  // Update;
 //  UpdateControlState;
  end; }
end;

procedure TFSplashScreen.Timer2Timer(Sender: TObject);
begin
 pBar.Position:=pBar.Position+2;
end;

end.
