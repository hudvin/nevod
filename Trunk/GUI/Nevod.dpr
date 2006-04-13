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
  ModifyWord in 'ModifyWord.pas' {FModifyWord},
  FilterManager in '..\Shared\FilterManager.PAS',
  ModifyStamp in 'ModifyStamp.pas' {FModifyStamp},
  AddWord in 'AddWord.PAS' {FAddWord},
  AddSender in 'AddSender.pas' {FAddSender},
  ModifySender in 'ModifySender.pas' {FModifySender},
  AddExt in 'AddExt.pas' {FAddExt},
  ModifyExt in 'ModifyExt.pas' {FModifyExt};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFAddAccount, FAddAccount);
  Application.CreateForm(TFModifyAccount, FModifyAccount);
  Application.CreateForm(TFAddStamp, FAddStamp);
  Application.CreateForm(TFModifyWord, FModifyWord);
  Application.CreateForm(TFModifyStamp, FModifyStamp);
  Application.CreateForm(TFAddWord, FAddWord);
  Application.CreateForm(TFAddSender, FAddSender);
  Application.CreateForm(TFModifySender, FModifySender);
  Application.CreateForm(TFAddExt, FAddExt);
  Application.CreateForm(TFModifyExt, FModifyExt);
  Application.Run;
end.
