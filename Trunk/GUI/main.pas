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

uses PostReceiver, Shared;

{$R *.dfm}
{$R ..\Resources\WinXP.res}


procedure TFMain.Button1Click(Sender: TObject);
var
 a:TOBject;
 ms:TFMessage;
begin
a:=TIdPop3.Create;
ms:=TFMessage.Create;
ms.LoadFromZFile('c:\zet.txt');
//TIdPOP3(a).
end;

end.
