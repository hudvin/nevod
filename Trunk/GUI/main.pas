unit main;

interface

uses   StrUtils, 
  Windows,TypInfo, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB,IdMessage,IdAttachment, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdPOP3, IdCommandHandlers,IdContext, IdTCPServer, IdCmdTCPServer,
  IdPOP3Server, IdUserAccounts, IdZLibCompressorBase, IdCompressorZLibEx,
  OleServer;

type
  TFMain = class(TForm)
    ACon: TADOConnection;
    aTab: TADOTable;
    Button1: TButton;
    IdPOP31: TIdPOP3;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

uses PostReceiver, Shared, ThreadManager;

{$R *.dfm}
{$R ..\Resources\WinXP.res}


procedure TFMain.Button1Click(Sender: TObject);
var
 ms:TPOP3Receiver;
 acc:AccountParams;
 trad:TThreadManager;
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
trad:=TThreadManager.Create(ACon);
end;

end.
