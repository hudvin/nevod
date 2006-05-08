program Nevod;

uses
  Forms,
  Messages,
  Windows,
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
  FilterEditor in 'FilterEditor.pas' {FCustomEditor},
  AccountManager in '..\Shared\AccountManager.pas',
  AccountEditor in 'AccountEditor.pas' {FAccountEditor},
  PostReceiver in '..\MailReceiver\PostReceiver.pas',
  ThreadManager in '..\MailReceiver\ThreadManager.pas',
  POPServer in '..\POP3Server\POPServer.pas',
  PortEditor in 'PortEditor.pas' {FPortEditor},
  ASFilter in '..\MessagesFilter\ASFilter.pas',
  MultInst in 'MultInst.pas',
  Crc32 in '..\Shared\Crc32.pas';

{$R *.res}
var
 Con,CanExit:boolean;
 aCon:TADOConnection;


begin
  if InitInstance then
  begin
  Application.Initialize;

  try
 //  PackDB(GetAppDataPath+'\Nevilon Software\Nevod AntiSpam\messages.ndb','',DBPassword);
  except;
  end;
  aCon:=TADOConnection.Create(nil);
  aCon.LoginPrompt:=False;
  aCon.ConnectionString:=GetConnectionString;
  Con:=False;
  CanExit:=False;
  while (not Con) and (not canExit) do
   try
    aCon.Connected:=True;
    Con:=True;
   except
    if MessageBox(Application.Handle,'Ошибка загрузки','База данных не найдена или повреждена. Заменить ?',MB_OKCANCEL)=ID_OK then
     RestoreDB
   else canExit:=True;
  end;
  if CanExit  then  Application.Terminate
   else
    begin
     Application.CreateForm(TFMain, FMain);
  if (ParamCount>0) and (ParamStr(1)='-h') then
     Application.MainForm.WindowState:=wsMinimized;
     Application.Run;
    end;


  
  end;
end.
