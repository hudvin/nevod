unit main;

interface

uses  Forms, PostManager, DB, ADODB, Classes, Controls, 
  StrUtils,PostReceiver, Dialogs, 
  Windows,ThreadManager, Messages, SysUtils, Variants, StdCtrls,
   IdTCPServer, IdCmdTCPServer, IdPOP3Server;

type
  TFMain = class(TForm)
    acon: TADOConnection;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
 post.StopAllThreads;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
post.Free;
end;

procedure TFMain.Button2Click(Sender: TObject);
begin
 post.StartAllThreads;
end;

end.
