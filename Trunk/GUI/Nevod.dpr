program Nevod;

uses
  Forms,
  Dialogs,
  ADODB,
  DB,
  SysUtils,
  WinSock,
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
  CustomEditor in 'CustomEditor.pas' {FCustomEditor},
  AccountManager in '..\Shared\AccountManager.pas',
  AddAccount in 'AddAccount.pas' {FAddAccount},
  AccountEditor in 'AccountEditor.pas' {FAccountEditor},
  AddHooked in 'AddHooked.pas' {FAddHooked},
  PostReceiver in '..\MailReceiver\PostReceiver.pas',
  ThreadManager in '..\MailReceiver\ThreadManager.pas',
  POPServer in '..\POP3Server\POPServer.pas',
  PortEditor in 'PortEditor.pas' {FPortEditor},
  ASFilter in '..\MessagesFilter\ASFilter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFAddHooked, FAddHooked);
  Application.Run;
end.
