unit main;

interface

uses  idGlobal, PostManager, DB, ADODB, Classes, Controls, 
  StrUtils,PostReceiver, Dialogs, ShellAPI, IdMessage, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  Forms,  IniFiles,
  Windows,ThreadManager, Messages, SysUtils, Variants, StdCtrls;

type
  TFMain = class(TForm)
    acon: TADOConnection;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
implementation

uses  Shared, AccountManager, Exceptions, Settings ;

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

end.
