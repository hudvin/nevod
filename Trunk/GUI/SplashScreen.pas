unit SplashScreen;

interface

uses PBThreadedSplashscreenU, gnugettext,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, JvImage, StdCtrls, cxControls, cxContainer,
  cxEdit, cxProgressBar, JvGIF;

type
  TFSplashScreen = class(TForm)
    bkImage: TJvImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


Procedure ShowSplashscreen;
Procedure HideSplashScreen;
Procedure ShowSplashScreenMessage( const S: String );
implementation

{$R *.dfm}

var
 // FSplashScreen: TFSplashScreen;
  ThreadedSplashForm: TPBThreadedSplashscreen;

Procedure ShowSplashscreen;
  Var
    SplashForm: TFSplashScreen;
    bmp: TBitmap;
  Begin
    If Assigned( ThreadedSplashForm ) Then Exit;

    Splashform := TFSplashScreen.Create( Application );
    TranslateComponent(SplashForm);
    try
      ThreadedSplashForm:= TPBThreadedSplashscreen.Create( nil );
      Try
        ThreadedSplashform.Left  := Splashform.Left;

        ThreadedSplashform.Top   := Splashform.Top;
        ThreadedSplashform.Center:=
           Splashform.Position in [ poScreenCenter, poMainFormCenter,
                                  poDesktopCenter ];
        bmp:= Splashform.GetFormImage;
        ThreadedSplashForm.UseStatusbar:=False;
        try
          ThreadedSplashform.Image := bmp;
        finally
          bmp.Free;
        end;
      //  ThreadedSplashForm.UseStatusbar  := True;
         ThreadedSplashForm.TopMost := true;

        ThreadedSplashForm.Show;
      Except
        FreeAndNil(ThreadedSplashForm);
        raise;
      End; { Except }
    finally
      Splashform.Free;
    end;
  End;

Procedure HideSplashScreen;
  Begin
    FreeAndNil(ThreadedSplashForm);
  End;

Procedure ShowSplashScreenMessage( const S: String );
  Begin
    If Assigned( ThreadedSplashForm ) Then
      ThreadedSplashForm.ShowStatusMessage( S );
  End;


end.
