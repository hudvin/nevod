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
implementation

uses  Shared, AccountManager, Exceptions;

{$R *.dfm}
{$R ..\Resources\WinXP.res}


procedure TFMain.Button1Click(Sender: TObject);
var
  nmb:TAccounter;
  Account:TAccount;
  manager:TAccountManager;
begin
  Showmessage('');
  manager:=TAccountManager.Create(ACon);
  manager.ClassName;
  manager.Free;

 // nmb:=TAccounter.Create(ACon);
 // nmb.Free;

end;

end.
