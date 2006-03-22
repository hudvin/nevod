unit main;

interface

uses
  Forms, PostManager,ASFilter, DB, ADODB, Classes, Controls, dbtables,
  StrUtils,PostReceiver, Dialogs, Shared,IniFiles,AccountManager,
  Windows,ThreadManager, Messages, SysUtils, Variants, StdCtrls,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  IdCmdTCPServer, IdExplicitTLSClientServerBase, IdPOP3Server, IdMessage;

type
  TFMain = class(TForm)
    acon: TADOConnection;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
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

uses RegExpr;



{$R *.dfm}
{$R ..\Resources\WinXP.res}

procedure TFMain.Button1Click(Sender: TObject);
var
 st:TNevodStamp;
 dt:TFilterResult;
 mess:TFMessage;
begin
 mess:=TFMessage.Create;
 mess.Sender.Address:='neiroman@gmail.com';
 mess.Body.LoadFromFile('c:\mess.html');
 st:=TNevodStamp.Create(ACon,ftStamp);
 dt:=st.AnalyzeMessage(mess);
 if dt.FilterType=ftStamp then ShowMessage('!');
   
 st.Free;
end;

procedure TFMain.Button2Click(Sender: TObject);
var
 exp:TRegExpr;
 str,res:string;
 inp:TStringList;
begin
 inp:=TStringList.Create;
 inp.LoadFromFile('c:\mess.html');
 exp:=TRegExpr.Create;
 str:='(?s)(?i)(&lt;|<)\s*(&nbsp;\s*)*Nevod\s*(&nbsp;\s*)*AntiSpam\s*(&nbsp;\s*)*:(\s*)(&nbsp;\s*)*';
 str:=str+'(".*"|'+''''+'.*'+''''+')\s*(&nbsp;\s*)*(&gt;|>)';
// ShowMessage(str);
 exp.ModifierG:=False;
 exp.Expression:=str;
 exp.Exec(inp.Text);
// Res := exp.Substitute ('$7');


 if exp.Exec (inp.Text) then
      REPEAT
  //     Res := Res + exp.Match [0] + ',';
         Res := Res + exp.Match [7] + ',';
      UNTIL not exp.ExecNext; 
 ShowMessage(res);
end;

procedure TFMain.Button3Click(Sender: TObject);
begin
 ShowMessage(copy('"f  adsfadafa"',2,length('"f  adsfadafa"')-2));
end;

end.

{

добавить методы для почтового менеджера
}
