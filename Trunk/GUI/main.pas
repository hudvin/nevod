unit main;

interface

uses   StrUtils, 
  Windows,TypInfo,ThreadManager, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB,IdMessage,IdAttachment, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdPOP3, IdCommandHandlers,IdContext, IdTCPServer, IdCmdTCPServer,
  IdPOP3Server, IdUserAccounts, IdZLibCompressorBase, IdCompressorZLibEx,
  OleServer, Grids, DBGrids;

type
  TFMain = class(TForm)
    ACon: TADOConnection;
    aTab: TADOTable;
    Button1: TButton;
    IdPOP31: TIdPOP3;
    Button2: TButton;
    Button3: TButton;
    tab: TADOTable;
    tabid: TAutoIncField;
    tabmid: TIntegerField;
    tabdeleted: TBooleanField;
    tabmessage: TMemoField;
    tabmessId: TWideStringField;
    tabAddress: TWideStringField;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;
  trad:TThreadManager;
implementation

uses PostReceiver, Shared;

{$R *.dfm}
{$R ..\Resources\WinXP.res}


procedure TFMain.Button1Click(Sender: TObject);
var
 ms:TPOP3Receiver;
 acc:AccountParams;
 lis:TThreadList;
// trad:TThreadManager;
begin
{acc.AccountName:='qaz';
acc.Username:='qaz';
acc.Host:='localhost';
acc.Password:='qaz';
acc.Port:=110;
acc.Id:=1;
ms:=TPOP3Receiver.Create(acc,ACon,2000,true);
sleep(7000);
ms.Free;   }
//lis:=TThreadList.Create;


// пароль на на ящик f301wn18z
// пользователь  cryon@fromru.com
// imap.fromru.com
// порт 110

trad:=TThreadManager.Create(ACon);
//TerminateThread()
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
trad.Free;
end;

procedure TFMain.Button2Click(Sender: TObject);
var
  Receiver:TPOP3Receiver;
  params:AccountParams;
begin
params.AccountName:='Cryon';
params.Username:='cryon@fromru.com';
params.Password:='f301wn18z';
params.Host:='imap.fromru.com';
params.Id:=5;
params.Port:=110;
Receiver:=TPOP3Receiver.Create(params,ACon,30000,True); 
end;

procedure TFMain.Button3Click(Sender: TObject);
var blob:TADOBlobStream;
    mess:TFMessage;
    I:integer;
begin
tab.Open;
tab.RecNo:=5;
mess:=TFMessage.Create;
blob:=TADOBlobStream.Create(TBlobField(tab.Fields[3]),bmRead);
mess.LoadFromZStream(blob);
mess.SaveToFile('c:\unpacked.txt');
mess.SaveToZFile('c:\packed.txt');
Showmessage(FloatToStr(mess.Compression));
mess.Free;
blob.Free;
end;

end.
