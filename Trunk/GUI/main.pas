unit main;

interface

uses  PerlRegEx,Forms,  AsFilter, masks,
  StrUtils,PostReceiver, Dialogs, Shared,IniFiles,AccountManager,
  Windows,ThreadManager, Messages, SysUtils, Variants, StdCtrls,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  IdCmdTCPServer, IdExplicitTLSClientServerBase, IdPOP3Server, IdMessage,
  ADODB, DB, Classes, Controls, Grids, DBGrids;

type
  TFMain = class(TForm)
    acon: TADOConnection;
    Button1: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  FMain: TFMain;
implementation

uses RegExpr, StrMask;



{$R *.dfm}
{$R ..\Resources\WinXP.res}

procedure TFMain.Button1Click(Sender: TObject);
var
 st:TSenderFilter;
 mess:TFMessage;
 dt:TFilterType;

begin
 mess:=TFMessage.Create;
 mess.Sender.Address:='neiroman@gmail.com';
 dt:=ftWhiteEmail;
 st:=TSenderFilter.Create(ACon,dt);
 ShowMessage(st.AnalyzeMessage(mess).Reason) ;

end;

procedure TFMain.Button4Click(Sender: TObject);
var
 st:TSignalFilter;
 mess:TFMessage;
 dt:TFilterType;

begin
 mess:=TFMessage.Create;
 mess.LoadFromFile('c:\mess.txt');
 //mess.Sender.Address:='neiroman@gmail.com';
 dt:=ftBlackWord;
 st:=TSignalFilter.Create(Acon,dt,slBody);
 ShowMessage(st.AnalyzeMessage(mess).Reason) ;



end;



end.
