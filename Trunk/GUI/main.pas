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
    Button4: TButton;
    Button2: TButton;
    Button3: TButton;
    pop: TIdPOP3;
    mess: TIdMessage;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
begin
 fit:=TAllowFilterGroup.Create(ACon);
 ms:=TFMessage.Create;

 ms.LoadFromFile('c:\mail\31.htm');
// ShowMessage(ms.Recipients.EMailAddresses);
// ShowMessage(ms.Headers.Values['To']);
 fit.AnalyzeMessage(ms);
 ShowMessage(fit.Reason);  
end;

procedure TFMain.Button4Click(Sender: TObject);
var bs:TBaseFilterContainer;
begin
 bs:=TBaseFilterContainer.Create(ACon);
// bs.LoadActiveFilters([ftBlackEmail,ftBlackAttachExtFilter]);
end;


procedure TFMain.Button2Click(Sender: TObject);
var it:TImageFilter;
    ms:TFMessage;
begin
// it:=TImageFilter.Create(ACon,ftImagefilter);
 Ms:=TFMessage.Create;
 it.AnalyzeMessage(Ms);
 ShowMessage(it.Reason);
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
