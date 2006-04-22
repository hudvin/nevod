unit AddAccount;

interface

uses   AccountManager,
  Windows, Messages,Exceptions, StdCtrls, ExtCtrls, Classes, Controls,
  cxControls, cxPC ,SysUtils, Variants,  Graphics,  Forms,
  Dialogs,  IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdPOP3, IdThread, Shared;

type
  TFAddAccount = class(TForm)
    cxTabControl1: TcxTabControl;
    leAccountName: TLabeledEdit;
    leUsername: TLabeledEdit;
    lePassword: TLabeledEdit;
    leHost: TLabeledEdit;
    lePort: TLabeledEdit;
    leTimeout: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure lePortKeyPress(Sender: TObject; var Key: Char);
    procedure leTimeoutKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FAccountManager: TAccountManager;
  public
    procedure Create(AccountManager:TAccountManager); reintroduce; overload;
    { Public declarations }
  end;

var
  FAddAccount: TFAddAccount;

implementation

uses main;

{$R *.dfm}

procedure TFAddAccount.Button3Click(Sender: TObject);
var
   Params:TAccountParams;
begin
 try
 Params.Username:=leUsername.Text;
 Params.Password:=lePassword.Text;
 if Length(lePort.Text)>0
  then Params.Port:=StrToInt(lePort.Text)
   else Raise EInvalidAccountParams.Create('Invalid Port');
 Params.Host:=leHost.Text;
 if Length(leTimeout.Text)>0
  then Params.Timeout:=StrToInt(leTimeout.Text)
   else  Raise EInvalidAccountParams.Create('Invalid Timeout value');

 Params.Port:=StrToInt(lePort.Text);
 params.Host:=leHost.Text;
 Params.Timeout:=StrToInt(leTimeout.Text);

 leAccountName.Enabled:=False;
 leUsername.Enabled:=False;
 lePassword.Enabled:=False;
 leHost.Enabled:=False;
 lePort.Enabled:=False;
 leTimeout.Enabled:=False;


 except
  on e: Exception do
    ShowMessage(E.Message);
 end;
end;

procedure TFAddAccount.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 CanClose:=True;
end;

procedure TFAddAccount.Button2Click(Sender: TObject);
begin
 Close;
end;

procedure TFAddAccount.lePortKeyPress(Sender: TObject; var Key: Char);
begin
 if not (Key  in ['0'..'9',#8]) then
  begin
   Key := #0;
   Beep;
  end;
end;

procedure TFAddAccount.leTimeoutKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key  in ['0'..'9',#8]) then
  begin
   Key := #0;
   Beep;
  end;
end;

procedure TFAddAccount.Button1Click(Sender: TObject);
var
 Params:TAccountParams;
begin
 Params.AccountName:=leAccountName.Text;
 Params.Username:=leUsername.Text;
 Params.Password:=lePassword.Text;
 if Length(lePort.Text)>0
  then Params.Port:=StrToInt(lePort.Text)
   else Params.Port:=-1;
 params.Host:=leHost.Text;
 if Length(leTimeout.Text)>0
  then Params.Timeout:=StrToInt(leTimeout.Text)
   else  Params.Timeout:=-2;
 try
 // main.FMain.PSManager.AccountManager.AddAccount(Params);
  Close;
 except
  on e: Exception do
    ShowMessage(E.Message);
 end;
end;

procedure TFAddAccount.Create(AccountManager:TAccountManager);
begin
 FAccountManager:=AccountManager;
 inherited Create(nil);

end;

procedure TFAddAccount.FormShow(Sender: TObject);
begin
 leAccountName.Text:='';
 leUsername.Text:='';
 lePassword.Text:='';
 leHost.Text:='';
 lePort.Text:='';
 leTimeout.Text:='';
end;

end.
