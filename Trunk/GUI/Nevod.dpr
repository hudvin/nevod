program Nevod;

uses
  Forms,
  main in 'main.pas' {FMain},
  PostReceiver in '..\MailReceiver\PostReceiver.pas',
  Shared in '..\Shared\Shared.pas',
  Base64 in '..\Crypt\Base64.pas',
  Blowfish in '..\Crypt\Blowfish.pas',
  DCPcrypt in '..\Crypt\DCPcrypt.pas',
  SHA1 in '..\Crypt\SHA1.pas',
  ThreadManager in '..\MailReceiver\ThreadManager.pas',
  Exceptions in '..\Shared\Exceptions.pas',
  AccountManager in '..\Shared\AccountManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
