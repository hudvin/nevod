unit AccountEditor;

interface

uses  ADOdb,DB,  Shared,gnugettext,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, cxControls, cxPC, AccountManager,
  cxContainer, cxEdit, cxGroupBox, JvComponent, JvBalloonHint;

type
  TFAccountEditor = class(TForm)
    cxTab: TcxTabControl;
    cxGroupBox1: TcxGroupBox;
    leAccountName: TLabeledEdit;
    leUsername: TLabeledEdit;
    lePassword: TLabeledEdit;
    leHost: TLabeledEdit;
    lePort: TLabeledEdit;
    leTimeout: TLabeledEdit;
    cxGroupBox2: TcxGroupBox;
    btOK: TButton;
    btCancel: TButton;
    btTest: TButton;
    btHelp: TButton;
    JVHelp: TJvBalloonHint;
    procedure btCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btOKClick(Sender: TObject);
    procedure lePortKeyPress(Sender: TObject; var Key: Char);
    procedure leTimeoutKeyPress(Sender: TObject; var Key: Char);
    procedure leAccountNameKeyPress(Sender: TObject; var Key: Char);
    procedure leUsernameKeyPress(Sender: TObject; var Key: Char);
    procedure lePasswordKeyPress(Sender: TObject; var Key: Char);
    procedure leHostKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure btTestClick(Sender: TObject);
  private
    FAccountManager: TAccountManager;
    FadAccounts: TADOQuery;
    FEditorMode:TEditorMode;
    FAccountParams:TAccountParams;
    FAccountId:integer;
    FPOPTester: TPOP3Tester;
    { Private declarations }
  public
    constructor Create(adAccounts:TADOQuery;AccountManager:TAccountManager);
        reintroduce; overload;
    procedure BuildParams;
    procedure CleanFields;
    procedure FilterKey(var Key:Char;Control:TWinControl);
    procedure SetCaptions;
    procedure ShowModal; reintroduce; overload; virtual;
    procedure ShowModal(AccountId:integer); reintroduce; overload; virtual;
    { Public declarations }
  end;

var
  FAccountEditor: TFAccountEditor;
  
implementation
uses main;
{$R *.dfm}

constructor TFAccountEditor.Create(adAccounts:TADOQuery;
    AccountManager:TAccountManager);
begin
  inherited Create(nil);
  FadAccounts:=adAccounts;
  FAccountManager:=AccountManager;
  TranslateComponent(self);
end;

procedure TFAccountEditor.CleanFields;
begin
 leAccountName.Text:='';
 leUsername.Text:='';
 lePassword.Text:='';
 leHost.Text:='';
 lePort.Text:='110';
 leTimeout.Text:='60';
end;

procedure TFAccountEditor.ShowModal; // ��� ���������� ��������
begin
 FEditorMode:=emAdd;
 SetCaptions;
 inherited ShowModal;
end;

procedure TFAccountEditor.ShowModal(AccountId:integer);
var
 Params:TAccountParams;
begin
 FEditorMode:=emEdit;
 Params:=FAccountManager.AccountById[AccountId];
 with Params do
  begin
   FAccountId:=Id;
   leAccountName.Text:=AccountName;
   leUsername.Text:=Username;
   lePassword.Text:=Password;
   leHost.Text:=Host;
   lePort.Text:=IntToStr(Port);
   leTimeout.Text:=FloatToStr(TimeOut/(1000));
  end;
 SetCaptions;
 inherited ShowModal;
end;

procedure TFAccountEditor.btCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TFAccountEditor.SetCaptions;
begin
 if FEditorMode=emEdit then
  begin
   Caption:=_('��������� ���������� ��������');
   btOK.Caption:=_('��������');
  end
   else
    begin
     Caption:=_('���������� ������ ��������');
     btOK.Caption:=_('��������');
    end;   
end;

procedure TFAccountEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 CleanFields;
 btTest.Enabled:=True;
 JVHelp.CancelHint;
 PostMessage(main.FMain.Handle,WM_DestroyAccountEditor,0,0);
end;

procedure TFAccountEditor.btOKClick(Sender: TObject);
begin
 BuildParams;
 try
  if FEditorMode=emAdd then
   begin
    FAccountManager.AddAccount(FAccountParams);
    Close;
   end
  else
   begin
    FAccountManager.ModifyAccount(FAccountParams);
    FAdAccounts.Requery;
    Close;
   end;

 except                                       //  or MB_SETFOREGROUND
  on e: Exception do
    ShowMessageBox(Application.Handle,e.Message,String(_('������')),MB_ICONWARNING );
  end;

end;

procedure TFAccountEditor.FilterKey(var Key:Char;Control:TWinControl);
begin
 if Ord(key)>127 then
  begin
   Key := #0;
   if (Control=lePort) or (Control=leTimeout) then
    jvHelp.ActivateHint(Control,_('� ������ ���� ����� �������'+ chr(13) +  '������  �����'),_('�������� !'),1500)
   else
     jvHelp.ActivateHint(Control,_('� ������ ���� ����� ������� ������ ���������� ������� � �����'),_('�������� !'),1500);
   Beep;
  end;

end;

procedure TFAccountEditor.lePortKeyPress(Sender: TObject; var Key: Char);
begin
 FilterKey(Key,lePort);
end;

procedure TFAccountEditor.leTimeoutKeyPress(Sender: TObject;
  var Key: Char);
begin
 FilterKey(Key,leTimeout);
end;

procedure TFAccountEditor.leAccountNameKeyPress(Sender: TObject;
  var Key: Char);
begin
 FilterKey(Key,leaccountName);
end;

procedure TFAccountEditor.leUsernameKeyPress(Sender: TObject;
  var Key: Char);
begin
 FilterKey(Key,leUsername);
end;

procedure TFAccountEditor.lePasswordKeyPress(Sender: TObject;
  var Key: Char);
begin
 FilterKey(Key,lePassword);
end;

procedure TFAccountEditor.leHostKeyPress(Sender: TObject; var Key: Char);
begin
 FilterKey(Key,leHost);
end;

procedure TFAccountEditor.FormCreate(Sender: TObject);
begin
 TranslateComponent(self);
 lePassword.Font.Name := 'Wingdings';
 lePassword.PasswordChar := 'l';
end;

procedure TFAccountEditor.btTestClick(Sender: TObject);
begin
 BuildParams;
 TPOP3Tester.Create(btTest,FAccountParams,Application.Handle,Handle);
end;

procedure TFAccountEditor.BuildParams;
var
  buf:integer;
begin
 with FAccountParams do
  begin
   buf:=-1;
   Val(lePort.Text,Port,buf);
   if buf<>0 then Port:=-1;
   buf:=-1;
   Val(leTimeout.Text,Timeout,buf);
   if buf<>0 then Timeout:=-1
    else Timeout:=Timeout*1000;

   Id:=FAccountId;
   AccountName:=leAccountName.Text;
   Username:=leUsername.Text;
   Password:=lePassword.Text;
   Host:=leHost.Text;
  end;
end;


end.
