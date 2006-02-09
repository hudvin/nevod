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
    Button3: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation
uses ThreadManager,Shared,ASFilter;
{$R *.dfm}
{$R ..\Resources\WinXP.res}


procedure TFMain.Button1Click(Sender: TObject);
var inp,outp:TMemoryStream;
    prt:TCompressor;
    mif:TFMessage;
begin
inp:=TMemoryStream.Create;
outp:=TMemoryStream.Create;
prt:=TCompressor.Create;

outp.LoadFromFile('c:\fff.txt');
//inp.LoadFromFile('c:\mess.txt');
//prt.CompressStream(inp,outp);
//outp.SaveToFile('c:\pack.txt');
mif:=TFMessage.Create;
mif.LoadFromZStream(outp);
outp.Free;
mif.Update;
ShowMessage(mif.Extensions.GetText);
Showmessage(IntToStr(mif.MessageParts.Count));
outp:= TMemoryStream.Create;
mif.SaveToZStream(outp);
outp.SaveToFile('c:\fff.txt');

end;



procedure TFMain.Button3Click(Sender: TObject);
var
    mn:TASFilter;
    st:TStringList;
    buff,res:string;
begin
buff:=Trim(Edit1.Text);
//if CheckEmailAddr(buff) then ShowMessage('Normal') else ShowMessage('Error');
res:=Copy(buff,Pos('@',buff),Length(buff)-Pos('@',buff)+1);
Showmessage(res);

{
проветять, является ли адресом
взять адрес отправителя
выделить все после собаки (включительно)



}

//mn:=TASFilter.Create(ACon,1);

end;


end.
