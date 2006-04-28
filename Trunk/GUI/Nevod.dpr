program Nevod;

uses
  Forms, Dialogs, ADODB,DB,SysUtils, WinSock,
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
  USock in 'USock.pas',
  POPServer in '..\POP3Server\POPServer.pas',
  PortEditor in 'PortEditor.pas' {FPortEditor};

function CheckPortForFree(Port:Integer):boolean; External 'Shared.dll';

var
 SProvider:TSettings;
 adCon:TADOConnection;
 FAddr: TSockAddrIn;
 FSocket:TSocket;
 wsaD: WSADATA;
{$R *.res}

begin
  Application.Initialize;    
 { adCon:=TADOConnection.Create(nil);
  adCon.ConnectionString:=ConnectionString;
  adCon.LoginPrompt:=False;
  SProvider:=TSettings.Create(adCon);
 }
 { FSocket := socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
  FAddr.sin_family := AF_INET;
  FAddr.sin_addr.s_addr := INADDR_ANY;
  FAddr.sin_port := htons(16545);
  SetLastError(0);
  if WSAStartup($101, WsaD) = 0 then
   begin
    if bind(FSocket, FAddr, SizeOf(FAddr))=SOCKET_ERROR then
     ShowMessage('da');
    ShowMessage(SysErrorMessage(GetLastError));
    WSACleanUp;
    closesocket(FSocket);
   end;   }




  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFAddHooked, FAddHooked);
  Application.Run;
end.
