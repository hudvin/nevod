program Nevod;

uses
  Forms,
  main in 'main.pas' {FMain},
  PostReceiver in '..\MailReceiver\PostReceiver.pas',
  Shared in '..\Shared\Shared.pas',
  Base64 in '..\Crypt\Base64.pas',
  Blowfish in '..\Crypt\Blowfish.pas',
  DCPcrypt in '..\Crypt\DCPcrypt.pas',
  ThreadManager in '..\MailReceiver\ThreadManager.pas',
  Exceptions in '..\Shared\Exceptions.pas',
  AccountManager in '..\Shared\AccountManager.pas',
  SHA1 in '..\Crypt\SHA1.pas',
  Settings in '..\Shared\Settings.pas',
  PostManager in '..\Shared\PostManager.pas',
  POPServer in '..\POP3Server\POPServer.pas',
  ASFilter in '..\MessagesFilter\ASFilter.pas',
  RegExpr in '..\Libs\RegExpr.pas',
  PerlRegEx in '..\Libs\RegExp\PerlRegEx.pas',
  AddAccount in 'AddAccount.pas' {FAddAccount},
  ModifyAccount in 'ModifyAccount.pas' {FModifyAccount},
  AddStamp in 'AddStamp.pas' {FAddStamp},
  ModifyWord in 'ModifyWord.pas' {FModifyWord};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFAddAccount, FAddAccount);
  Application.CreateForm(TFModifyAccount, FModifyAccount);
  Application.CreateForm(TFAddStamp, FAddStamp);
  Application.CreateForm(TFModifyWord, FModifyWord);
  Application.Run;
end.
