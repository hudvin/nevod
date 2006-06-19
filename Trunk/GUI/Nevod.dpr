program Nevod;

uses
  FastShareMem in '..\Shared\FastShareMem.pas',
  Forms,
  ComObj,
  ActiveX,
  Messages,
  Windows,
  Dialogs,
  ADODB,
  DB,
  SysUtils,
  WinSock,
  Registry,
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
 RegForm:TFRegister;
 tag:tagWINDOWINFO;
 reg:TRegistry;
 dbTest:TDBTesting;
begin
 AddDomainForResourceString ('ru');
 UseLanguage ('ru');
 SetLastError(0);
 Mutex:=0;
 Mutex:=CreateMutex(nil, False,MutexName);
 if GetLastError = ERROR_ALREADY_EXISTS then // уже есть запущенная копия
  begin
   PostMessage(GetAppHandle,WM_ActivateWindow,0,0);
   SetForegroundWindow(GetAppHandle);
   SetActiveWindow(GetAppHandle);
   SetFocus(GetAppHandle);

   KillProgram(Application.Handle) ;
  end;

   
   Application.Initialize;
   GetRegistrationInformation(UserKey,UserName );
   if not((UserKey <> nil) AND (StrLen(UserKey) > 0)) then
    begin
     SetActiveWindow(Application.Handle);
     RegForm:=TFRegister.Create(nil);
     WriteAppHandle(RegForm.Handle);
     RegForm.ShowModal;
     if  RegForm.Result=0 then
      begin
       FreeAndNil(RegForm);
       KillProgram(Application.Handle);
      end;
     FreeAndNil(RegForm);
    end;
   try
    DatabaseCompact;
   except;
   end;
//  end;

 dbTest:=TestDBConnnection;
 if not (dbTest=dtOK) then
  begin
   if IsFirst(True) then RestoreDB
    else
     if ShowMessageBox(Application.Handle,_('База данных не найдена или повреждена. Заменить ?'),_('Ошибка загрузки'),MB_OKCANCEL or MB_ICONWARNING)=ID_OK then
       RestoreDB else canExit:=True;
  end;
   
 if CanExit  then  Application.Terminate
  else
   begin
    Application.HelpFile := 'help.chm';
    Application.CreateForm(TFMain, FMain);
    WriteAppHandle(Application.MainForm.Handle);
  if (ParamCount>0) and (ParamStr(1)='-h') then Application.MainForm.WindowState:=wsMinimized;
    Application.Run;
   end;
end.

