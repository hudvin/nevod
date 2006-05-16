program NevodAntiSpamKeyMaker;

uses
  Forms,
  kmMain in 'kmMain.pas' {FMain},
  Shared in '..\Shared\Shared.pas',
  PerlRegEx in '..\Libs\RegExp\PerlRegEx.pas',
  gnugettext in '..\..\..\Program Files\dxgettext\gnugettext.pas',
  Base64 in '..\Crypt\Base64.pas',
  Blowfish in '..\Crypt\Blowfish.pas',
  DCPcrypt in '..\Crypt\DCPcrypt.pas',
  SHA1 in '..\Crypt\SHA1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
