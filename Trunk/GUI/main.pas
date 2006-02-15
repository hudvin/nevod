unit main;

interface

uses
  StrUtils,PostReceiver, Dialogs, ShellAPI, IdMessage, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdPOP3, DB, ADODB, Classes, Controls, StdCtrls, Forms,
  Windows,ThreadManager, Messages, SysUtils, Variants;

type
  TFMain = class(TForm)
    ACon: TADOConnection;    
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    pop: TIdPOP3;
    mess: TIdMessage;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;
  Receiver:TPOP3Receiver;
  trod:TThreadManager;
implementation

uses  Shared;

{$R *.dfm}
{$R ..\Resources\WinXP.res}


procedure TFMain.FormDestroy(Sender: TObject);
begin
//Receiver.Free;
end;

procedure TFMain.Button2Click(Sender: TObject);
var
  params:AccountParams;
begin
params.AccountName:='Cryon';
params.Username:='cryon@fromru.com';
params.Password:='f301wn18z';
params.Host:='imap.fromru.com';
params.Id:=5;
params.Port:=110;

Receiver:=TPOP3Receiver.Create(params,ACon,30000,True);

{params.AccountName:='indy';
params.Username:='indy';
params.Password:='qwerty';
params.Host:='localhost';
params.Id:=8;
params.Port:=110;  }
//Receiver.TerminateAndWaitFor;
//ShowMessage('!!!');
//Receiver.Show;
//Receiver.FreeOnTerminate:=True;
//Receiver.Terminate;


end;

procedure TFMain.Button3Click(Sender: TObject);
var
  i:integer;
begin
pop.Connect;
for i:=1 to pop.CheckMessages do
   begin
     mess.Clear;
     pop.Retrieve(i,mess);
     mess.SaveToFile(IntToStr(i)+'.txt');
   end;
end;

end.
