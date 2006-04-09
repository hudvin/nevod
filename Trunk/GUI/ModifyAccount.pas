unit ModifyAccount;

interface

uses
  Windows,main, Messages,Shared, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AddAccount, StdCtrls, ExtCtrls, cxControls, cxPC;

type
  TFModifyAccount = class(TFAddAccount)
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    AccountId:integer;
  public
    { Public declarations }
  end;

var
  FModifyAccount: TFModifyAccount;

implementation

uses DB, PostManager;

{$R *.dfm}

procedure TFModifyAccount.Button3Click(Sender: TObject);
begin
  {
  перед показом получить id учетной записи
  }
  inherited;

end;

procedure TFModifyAccount.Button1Click(Sender: TObject);
 var
 Params:TAccountParams;
begin
 Params.AccountName:=leAccountName.Text;
 Params.Id:=AccountId;
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
  main.FMain.PSManager.AccountManager.ModifyAccount(Params);
 Close;
 except
  on e: Exception do
    ShowMessage(E.Message);
 end;

end;

procedure TFModifyAccount.FormShow(Sender: TObject);
var
 AName:String;
 Params:TAccountParams;
begin
inherited;
  with  main.FMain do
   begin
    AName:=cxAccounts.Controller.SelectedRecords[0].Values[cxAccountsAccountName.VisibleIndex];
    leAccountName.Text:=AName ;
    Params:=PSManager.AccountManager.AccountById[PSManager.AccountManager.AccountName2Id(AName)];
    leAccountName.Text:=AName; // грузить данные из таблицы
    AccountId:=Params.Id;
    leUsername.Text:=Params.Username;
    lePassword.Text:=Params.Password;
    leHost.Text:=Params.Host;
    lePort.Text:=IntToStr(Params.Port);
    leTimeout.Text:=IntToStr(Params.Timeout);
   end;
end;

end.

