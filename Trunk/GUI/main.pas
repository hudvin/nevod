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
    tab: TADOTable;
    RDSConnection1: TRDSConnection;
    Button4: TButton;
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
 st:TStampFilter;
 dt:TFilterResult;
 mess:TFMessage;
begin
 mess:=TFMessage.Create;
// mess.Sender.Address:='neiroman@gmail.com';
 mess.LoadFromFile('c:\mess.txt');
// if mess.BodyType=btText then ShowMessage('Text')
//  else Showmessage('html');
 ShowMessage(Mess.MessageText);
 st:=TStampFilter.Create(ACon,ftStamp);
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

procedure TFMain.Button3Click(Sender: TObject);
var
 blob:TADOBlobStream;
 ms:TFMessage;
begin
 ShowMessage(IntToStr(pos(' @ ','fff@fg')));
 ms:=TFMessage.Create;
 tab.Open;
 while not tab.Eof do
 begin
  blob:=TADOBlobStream.Create(TBlobField(tab.FieldByName('message')),bmRead);
  ms.LoadFromZStream(blob);
  if ms.BodyType=btText then ShowMessage('Text')
   else Showmessage('html');
  blob.Free;
  tab.Next;
 end;    // while
 //tab.RecNo:=1;

// ms.SaveToFile('c:\mess.txt');
end;
end.

 {
 создать свойство с типом содержимого
  если верхний не равен mixed - обработать и присвоить нужный тип
   иначе
    обойти все части пока не попадется тип text или html


 }
