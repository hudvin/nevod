program Nevod;

uses
  Forms,
  main in 'main.pas' {FMain},
  PostReceiver in '..\Threads\PostReceiver.pas',
  ThreadManager in '..\Threads\ThreadManager.pas',
  Shared in '..\Shared\Shared.pas',
  Blowfish in '..\Shared\Blowfish.pas',
  DCPcrypt in '..\Shared\DCPcrypt.pas',
  SHA1 in '..\Shared\SHA1.pas',
  Base64 in '..\Shared\Base64.pas',
  ASFilter in '..\Filter\ASFilter.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
