unit main;

interface

uses  PerlRegEx,Forms,  AsFilter, masks,
  StrUtils,PostReceiver, Dialogs, Shared,IniFiles,AccountManager,
  Windows,ThreadManager, Messages, SysUtils, Variants, StdCtrls,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  IdCmdTCPServer, IdExplicitTLSClientServerBase, IdPOP3Server, IdMessage,
  ADODB, DB, Classes, Controls, Grids, DBGrids, IdTCPConnection,
  IdTCPClient, IdMessageClient, IdPOP3;

type
  TFMain = class(TForm)
    acon: TADOConnection;
    Button1: TButton;
    Button3: TButton;
    pop: TIdPOP3;
    mess: TIdMessage;
    Memo1: TMemo;
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

uses RegExpr, StrMask;



{$R *.dfm}
{$R ..\Resources\WinXP.res}

procedure TFMain.Button1Click(Sender: TObject);
var fit:TAllowFilterGroup;
    ms:TFMessage;
    I:integer;
begin
 fit:=TAllowFilterGroup.Create(ACon);
 ms:=TFMessage.Create;
 for I := 1 to 31 do    // Iterate
   begin
    //I:=7;
     ms.LoadFromFile('c:\mail\'+IntToStr(i)+'.htm');
    fit.AnalyzeMessage(ms);
    ms.Clear;
    Memo1.Lines.Add(fit.Reason+'  '+IntToStr(i));
   end;    // for

end;

procedure TFMain.Button3Click(Sender: TObject);
var i:integer;
count:integer;
begin
 pop.Connect;
 count:=pop.CheckMessages;
 for I := 1 to Count do    // Iterate
   begin
     mess.Clear;
     pop.Retrieve(i,Mess);
     mess.SaveToFile('c:\mail\'+IntToStr(i)+'.htm');
   end;    // for
 pop.Disconnect;


end;

end.
