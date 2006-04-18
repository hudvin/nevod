program Nevod;

uses
  Forms,
  main in 'main.pas' {FMain},
  Shared in '..\Shared\Shared.pas',
  Base64 in '..\Crypt\Base64.pas',
  Blowfish in '..\Crypt\Blowfish.pas',
  DCPcrypt in '..\Crypt\DCPcrypt.pas',
  Exceptions in '..\Shared\Exceptions.pas',
  SHA1 in '..\Crypt\SHA1.pas',
  RegExpr in '..\Libs\RegExpr.pas',
  PerlRegEx in '..\Libs\RegExp\PerlRegEx.pas',
  FilterManager in '..\Shared\FilterManager.pas',
  test in 'test.pas' {Form1},
  CustomEditor in 'CustomEditor.pas' {FCustomEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.HelpFile := 'C:\Program Files\Borland\BDS\3.0\Help\Win32\DBEXPLR3.HLP';
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFCustomEditor, FCustomEditor);
  Application.Run;
end.
