unit main;

interface

uses  Forms, PostManager, DB, ADODB, Classes, Controls, 
  StrUtils,PostReceiver, Dialogs, Shared,
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
  ls:TAccountContextList;
implementation



{$R *.dfm}
{$R ..\Resources\WinXP.res}

procedure TFMain.FormCreate(Sender: TObject);
begin
 post:=TPostManager.Create(ACon);
 ls:=TAccountContextList.Create(ACon);
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
 var ts:TAccountContext;
begin
 ls.AddContext(10);
// ShowMessage (IntToStr(ls.GetContext(10).AccountId));
 ts:=ls.GetContext(10);
 ls.Free;
 Showmessage(IntToStr(ts.AccountId));
end;

end.
