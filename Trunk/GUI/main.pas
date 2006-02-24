unit main;

interface

uses  idGlobal,WinSock, PostManager, DB, ADODB, Classes, Controls, 
  StrUtils,PostReceiver, Dialogs, ShellAPI, IdMessage, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  Forms,  IniFiles, IdContext, POPServer, IdCommandHandlers,
  Windows,ThreadManager, Messages, SysUtils, Variants, StdCtrls,
  IdCustomTCPServer, IdTCPServer, IdCmdTCPServer, IdPOP3Server;

type
  TFMain = class(TForm)
    acon: TADOConnection;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    pop: TIdPOP3Server;
    Memo1: TMemo;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure popCheckUser(AThread: TIdContext;
      LThread: TIdPOP3ServerContext);
    procedure popQUIT(ASender: TIdCommand);
    procedure popDisconnect(AContext: TIdContext);
    procedure Button1Click(Sender: TObject);
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
// post:=TPostManager.Create(ACon);

  
end;

procedure TFMain.Button3Click(Sender: TObject);
begin
 post.StopAllThreads;
 
end;

procedure TFMain.popCheckUser(AThread: TIdContext;
  LThread: TIdPOP3ServerContext);
begin
 //Caption:=LThread.Connection.Socket.Binding.IP;
  Caption:=AThread.Connection.Socket.Host;
  LThread.State:=Trans;
end;

procedure TFMain.popQUIT(ASender: TIdCommand);
begin
  ASender.Context.Connection.Socket.WriteLn('+OK');
 Memo1.Lines.Add('quit');
end;

procedure TFMain.popDisconnect(AContext: TIdContext);
begin
//Memo1.Lines.Add('Disconnect');
 // срабатывает при любом отключении
end;

procedure TFMain.Button1Click(Sender: TObject);
var
 Rset:TRegSettings;
begin
 Rset:=TRegSettings.Create;
end;

end.
