unit main;

interface

uses
  StrUtils,PostReceiver, Dialogs, ShellAPI, IdMessage, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdPOP3, DB, ADODB, Classes, Controls, StdCtrls, Forms,  IniFiles,
  Windows,ThreadManager, Messages, SysUtils, Variants;

type
  TFMain = class(TForm)
    acon: TADOConnection;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

uses  Shared, AccountManager, Exceptions, Settings;

{$R *.dfm}
{$R ..\Resources\WinXP.res}


procedure TFMain.Button1Click(Sender: TObject);
var
  nmb:TAccountManager;
  Account:TAccountParams;
begin
  nmb:=TAccountManager.Create(ACon);
  Account.AccountName:='Nevilon';
  Account.Username:='nevilon';
  Account.Host:='pop3.nevilon.com';
  Account.Port:=110;
  Account.Password:='vdsgdgfdhgdhgd45';
 // nmb.AddAccount(Account);
  //nmb.DeleteAccount(6);
  nmb.SetStatus(7,asServer);
 // Showmessage(nmb.Items[0].Username);
  nmb.Free;
end;

procedure TFMain.Button2Click(Sender: TObject);
var sList:THashedStringList;
    ps:TPostSettings;
begin
 ps:=TPostSettings.Create(acon);
 ps.Setting['RunStep']:='500000';
 ShowMessage(ps.Setting['RunStep']);
{
 sList:=THashedStringList.Create;
 sList.Add('qwertry');
 sList.Values['qwerty']:='zzz';
 Showmessage(sList.Values['qwerty']);

}

end;

end.
