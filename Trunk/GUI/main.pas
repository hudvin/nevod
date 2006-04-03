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
    Button2: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Button6: TButton;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
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

procedure TFMain.Button2Click(Sender: TObject);
var
 exp:TRegExpr;
 str,res:string;
 inp:TStringList;
begin
 inp:=TStringList.Create;
 inp.LoadFromFile('c:\sys_hotkey.html');
 exp:=TRegExpr.Create;
 str:='<.*>';
 exp.ModifierG:=False;
 exp.Expression:=str;
 res:=exp.Replace(Inp.Text,'',True);
//ShowMessage (exp.Replace(Inp.Text,'',True));
 exp.Expression:='\s{2,}';
ShowMessage (exp.Replace(res,' ',True));
 {

 удалять все теги из текста

 }
{ exp.Exec(inp.Text);
 if exp.Exec (Inp.Text) then
      REPEAT
       Res := Res + exp.Match [0];
      UNTIL not exp.ExecNext;   }
 ShowMessage(res);
 Inp.Text:=res;
 Inp.SaveToFile('c:\inp.txt');
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



procedure TFMain.Button6Click(Sender: TObject);
var reg:TRegExp;
begin
 reg:=TRegExp.Create(nil);
 reg.ShieldingExp:='q*ty';
 ShowMessage(reg.RegEx);
 Edit1.Text:=reg.RegEx;;
end;

end.
