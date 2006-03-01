unit main;

interface

uses
      Forms, PostManager, DB, ADODB, Classes, Controls, dbtables,
      StrUtils,PostReceiver, Dialogs, Shared,IniFiles,AccountManager,
      Windows,ThreadManager, Messages, SysUtils, Variants, StdCtrls,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  IdCmdTCPServer, IdExplicitTLSClientServerBase, IdPOP3Server;

type
  TFMain = class(TForm)
    acon: TADOConnection;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    IdPOP3Server1: TIdPOP3Server;
    tab: TADOTable;
    tabid: TAutoIncField;
    tabmid: TIntegerField;
    tabdeleted: TBooleanField;
    tabmessage: TMemoField;
    tabmessId: TWideStringField;
    tabAddress: TWideStringField;
    tabCompressionLevel: TFloatField;
    tabMessSize: TIntegerField;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  FMain: TFMain;
  post:TPostManager;
implementation



{$R *.dfm}
{$R ..\Resources\WinXP.res}

procedure TFMain.FormCreate(Sender: TObject);
begin
 post:=TPostManager.Create(ACon);
end;

procedure TFMain.Button3Click(Sender: TObject);
begin
 post.StopAllThreads(False);
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 post.Free;
end;

procedure TFMain.Button2Click(Sender: TObject);
begin
 post.StartAllThreads;
end;

procedure TFMain.Button4Click(Sender: TObject);
var
 st:TAccountManager;
 ap:TAccountParams;
 mess:TFMessage;
 inp,outp:TMemoryStream;
 comp:TCompressor;
 bs:TADOBlobStream;
begin
 { tab.Open;
  tab.RecNo:=1;
  bs:=tADOBlobStream.Create(TBLobField(tab.FieldByName('Message')),bmRead);
 // bs.Position:=0;
 // bs.SaveToFile('c:\blob.txt');
  Showmessage(IntToStr(bs.Size));

  comp:=TCompressor.Create;



  inp:=TMemoryStream.Create;
  inp.LoadFromStream(bs);

  outp:=TMemoryStream.Create;

  comp.DecompressStream(inp,outp);
  outp.SaveToFile('c:\unzipped.txt');  }


{ st:=TAccountManager.Create(ACon);
  ap.AccountName:='test';
  ap.Username:='test';
  ap.Host:='localhost';
  ap.Password:='qaz';
  ap.Port:=110;
  ap.Timeout:=60000;

 st.AddAccount(ap);  }
end;

end.
