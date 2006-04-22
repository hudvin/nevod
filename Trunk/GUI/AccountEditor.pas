unit AccountEditor;
{

 интервал проверки отображать в минутах

}
interface

uses  ADOdb,DB,  Shared,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, cxControls, cxPC, AccountManager;

type
  TFAccountEditor = class(TForm)
    cxTab: TcxTabControl;
    leAccountName: TLabeledEdit;
    leUsername: TLabeledEdit;
    lePassword: TLabeledEdit;
    leHost: TLabeledEdit;
    lePort: TLabeledEdit;
    leTimeout: TLabeledEdit;
    btOK: TButton;
    btCancel: TButton;
    procedure btCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btOKClick(Sender: TObject);
  private
    FAccountManager: TAccountManager;
    FadAccounts: TADOQuery;
    FEditorMode:TEditorMode;
    FAccountParams:TAccountParams;
    { Private declarations }
  public
    constructor Create(adAccounts:TADOQuery;AccountManager:TAccountManager);
        reintroduce; overload;
    procedure CleanFields;
    procedure SetCaptions;
    procedure ShowModal; reintroduce; overload; virtual;
    procedure ShowModal(AccountId:integer); reintroduce; overload; virtual;
    { Public declarations }
  end;

var
  FAccountEditor: TFAccountEditor;
  
implementation

{$R *.dfm}

constructor TFAccountEditor.Create(adAccounts:TADOQuery;
    AccountManager:TAccountManager);
begin
  inherited Create(nil);
  FadAccounts:=adAccounts;
  FAccountManager:=AccountManager;
end;

procedure TFAccountEditor.CleanFields;
begin
 leAccountName.Text:='';
 leUsername.Text:='';
 lePassword.Text:='';
 leHost.Text:='';
 lePort.Text:='';
 leTimeout.Text:='2'
end;

procedure TFAccountEditor.ShowModal; // для добавления аккаунта
begin
 FEditorMode:=emAdd;
 SetCaptions;
 inherited ShowModal;
end;

procedure TFAccountEditor.ShowModal(AccountId:integer); // для редактирования параметров аккаунтов
begin
 FEditorMode:=emEdit;
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
   Caption:='Изменение параметров аккаунта';
   btCancel.Caption:='Изменить';
  end
   else
    begin
     Caption:='Добавление нового аккаунта';
     btOK.Caption:='Добавить';
    end;   
end;

procedure TFAccountEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 CleanFields;
end;

procedure TFAccountEditor.btOKClick(Sender: TObject);
begin
 try
  if FEditorMode=emAdd then
   begin
    with FAccountParams do
      begin
       AccountName:=leAccountName.Text;
       Username:=leUsername.Text;
       Password:=lePassword.Text;
       Host:=leHost.Text;
       Port:=StrToInt(lePort.Text);
       Timeout:=StrToInt(leTimeout.Text)*1000*60;
      end;
    FAccountManager.AddAccount(FAccountParams);
    FAdAccounts.Requery;
   end;
    

 except
  on e: Exception do
    Showmessage(E.Message);
 end;

end;

end.
