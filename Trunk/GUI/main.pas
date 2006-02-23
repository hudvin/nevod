unit main;

interface

uses  idGlobal,WinSock, PostManager, DB, ADODB, Classes, Controls, 
  StrUtils,PostReceiver, Dialogs, ShellAPI, IdMessage, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  Forms,  IniFiles, IdContext, POPServer,
  Windows,ThreadManager, Messages, SysUtils, Variants, StdCtrls,
  IdCustomTCPServer, IdTCPServer, IdCmdTCPServer, IdPOP3Server;

type
  TFMain = class(TForm)
    acon: TADOConnection;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    pop: TIdPOP3Server;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure popCheckUser(AThread: TIdContext;
      LThread: TIdPOP3ServerContext);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  FMain: TFMain;
  Receiver:TPOP3Receiver;
  trod:TThreadManager;
  post:TPostManager;
  pop:TPOPServer;
implementation

uses  Shared, AccountManager, Exceptions, Settings , IdIOHandler,
  IdIOHandlerSocket, Math;

{$R *.dfm}
{$R ..\Resources\WinXP.res}

procedure TFMain.Button1Click(Sender: TObject);
var
  nmb:TAccountManager;
  Account:TAccountParams;
begin
  nmb:=TAccountManager.Create(ACon);
  Account.AccountName:='Nevilon';
  Account.Username:='nevilon';
  Account.Host:='pop3.nevilon.com';
  Account.Port:=110;
  Account.Password:='vdsgdgfdhgdhgd45';
 // nmb.AddAccount(Account);
  //nmb.DeleteAccount(6);
  nmb.SetStatus(7,asServer);
 // Showmessage(nmb.Items[0].Username);
  nmb.Free;
end;

procedure TFMain.Button2Click(Sender: TObject);
var
  am:TAccountManager;
  Params:TAccountParams;

begin

  post.StartAllThreads;
 {Params.AccountName:='qax';
 Params.Username:='qax';
 Params.Host:='localhost';
 Params.Password:='qax';
 Params.Port:=110;

 am:=TAccountManager.Create(ACon);
 am.AddAccount(Params);
}
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
 post:=TPostManager.Create(ACon);
end;

procedure TFMain.Button3Click(Sender: TObject);
begin
 post.StopAllThreads;
end;

procedure TFMain.Button4Click(Sender: TObject);
begin
// ShowMessage(GetLocalIP);
//Caption:= IntToStr(IfThen(True,10,20)));
end;

procedure TFMain.popCheckUser(AThread: TIdContext;
  LThread: TIdPOP3ServerContext);
begin
 //Caption:=LThread.Connection.Socket.Binding.IP;
  Caption:=AThread.Connection.Socket.Host;
end;

end.
