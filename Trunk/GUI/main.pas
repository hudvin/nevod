unit main;

interface

uses
      Forms, PostManager, DB, ADODB, Classes, Controls,
      StrUtils,PostReceiver, Dialogs, Shared,IniFiles,
      Windows,ThreadManager, Messages, SysUtils, Variants, StdCtrls;

type
  TFMain = class(TForm)
    acon: TADOConnection;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
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
 st:THashedStringList;
begin
 st:=THashedStringList.Create;
 st.Add('qwerty');
 st.Values['qwerty']:='nevod';
 ShowMessage(st.Values['qwerty']);
end;

end.
