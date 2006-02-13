unit main;

interface

uses
  StrUtils,PostReceiver,
  Windows,ThreadManager, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ADODB, DB;

type
  TFMain = class(TForm)
    ACon: TADOConnection;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;
  Receiver:TPOP3Receiver;
  trod:TThreadManager;
implementation

uses  Shared;

{$R *.dfm}
{$R ..\Resources\WinXP.res}


procedure TFMain.FormDestroy(Sender: TObject);
begin
//Receiver.Free;
end;

procedure TFMain.Button2Click(Sender: TObject);
var
  params:AccountParams;
begin
params.AccountName:='Cryon';
params.Username:='cryon@fromru.com';
params.Password:='f301wn18z';
params.Host:='imap.fromru.com';
params.Id:=5;
params.Port:=110;
//Receiver:=TPOP3Receiver.Create(params,ACon,30000,True); 

{params.AccountName:='qax';
params.Username:='qax';
params.Password:='qax';
params.Host:='localhost';
params.Id:=7;
params.Port:=110;   }
Receiver:=TPOP3Receiver.Create(params,ACon,30000,True);



end;

procedure TFMain.Button3Click(Sender: TObject);
begin
trod:=TThreadManager.Create(ACon);
end;

end.
