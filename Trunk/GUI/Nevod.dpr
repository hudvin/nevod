program Nevod;

uses
  FastShareMem in '..\Shared\FastShareMem.pas',
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
  About in 'About.pas' {FAbout},
  ADODB_TLB in '..\Shared\ADODB_TLB.pas',
  JRO_TLB in '..\Shared\JRO_TLB.pas',
  Register in 'Register.pas' {FRegister},
  RegistrationKey in 'RegistrationKey.pas' {FRegistrationKey},
  aspr_api in '..\ASProtect\aspr_api.pas',
  gnugettext in '..\Libs\gnugettext.pas';

{$R *.res}

var
 Con,CanExit:boolean;
 aCon:TADOConnection;
 RegistrationForm:TFRegister;
begin
 AddDomainForResourceString ('ru');
 UseLanguage ('ru');
 if InitInstance then
  begin
   Application.Initialize;
   try
    DatabaseCompact;
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
   if MessageBoxW(Application.Handle,PWideChar(_('База данных не найдена или повреждена. Заменить ?')),PWideChar(_('Ошибка загрузки')),MB_OKCANCEL)=ID_OK then
     RestoreDB else canExit:=True;
  end;
 if CanExit  then  Application.Terminate
  else
   begin
     GetRegistrationInformation(UserKey,UserName );
     if not((UserKey <> nil) AND (StrLen(UserKey) > 0)) then
      begin
       RegistrationForm:=TFRegister.Create(nil);
       RegistrationForm.ShowModal;
       if RegistrationForm.Result=1 then
        begin
         Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFAbout, FAbout);
  if (ParamCount>0) and (ParamStr(1)='-h') then
          Application.MainForm.WindowState:=wsMinimized;
         Application.Run;
        end;
       RegistrationForm.Free;
      end
       else
        begin
         Application.CreateForm(TFMain, FMain);
         Application.CreateForm(TFAbout, FAbout);
         if (ParamCount>0) and (ParamStr(1)='-h') then
         Application.MainForm.WindowState:=wsMinimized;
         Application.Run;
        end;
   end;
  end;
end.
