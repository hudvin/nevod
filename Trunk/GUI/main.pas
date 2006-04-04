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
    Button2: TButton;
    Button3: TButton;
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
var
 st:TSenderFilter;
 mess:TFMessage;
 dt:TFilterType;

begin
 mess:=TFMessage.Create;
 mess.Sender.Address:='neiroman@gmail.com';
 dt:=ftWhiteEmail;
// st:=TSenderFilter.Create(ACon,dt);
 //ShowMessage(st.AnalyzeMessage(mess).Reason) ;
 if st.AnalyzeMessage(Mess)
  then ShowMessage(st.Reason);
end;

procedure TFMain.Button4Click(Sender: TObject);
var bs:TBaseFilterContainer;
begin
// bs:=TBaseFilterContainer.Create;
// bs.LoadActiveFilters([ftBlackEmail,ftBlackAttachExtFilter]);
end;


procedure TFMain.Button2Click(Sender: TObject);
var it:TImageFilter;
    mess:TFMessage;
begin
// it:=TImageFilter.Create(ACon,ftImagefilter);
 Mess:=TFMessage.Create;
 it.AnalyzeMessage(Mess);
 ShowMessage(it.Reason);
end;

procedure TFMain.Button3Click(Sender: TObject);
var
 ext:TAttachmentExtFilter;
begin
// ext:=TAttachmentExtFilter.Create(ACon,ftBlackAttachExtFilter);

end;

end.
