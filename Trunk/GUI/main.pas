unit main;

interface

uses
  StrUtils,PostReceiver, Dialogs, ShellAPI, IdMessage, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdPOP3, DB, ADODB, Classes, Controls, StdCtrls, Forms,
  Windows,ThreadManager, Messages, SysUtils, Variants;

type
  TFMain = class(TForm)
    ACon: TADOConnection;
    Button2: TButton;
    pop: TIdPOP3;
    mess: TIdMessage;
    Button1: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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

uses  Shared, AccountManager, Exceptions;

{$R *.dfm}
{$R ..\Resources\WinXP.res}


procedure TFMain.FormDestroy(Sender: TObject);
begin
//Receiver.Free;
end;


procedure TFMain.Button3Click(Sender: TObject);
var pt,pz:PAccountParams;
    ls:TList;
begin
ls:=TList.Create;
New(pt);
//GetMem(pt,SizeOf(PAccountParams));
pt.AccountName:='qqqqfdsafasfffffffffffffffffffffffffffffffqqqqqqqqqqqq';
ls.Add(pt);
//(PAccountParams(ls.Items[0])).AccountName:='dsfds';
//PAccountParams(ls.Items[0]).AccountName:='qwerty';
pz:=ls.Items[0];
pz.AccountName:='dgsgsds';
//ShowMessage(pt.AccountName);
//FreeMem(pt,SizeOf(PAccountParams));
Dispose(pt);
ls.Free;
{
базовый класс от TList для работы с указателями на
структуры
передавать параметры в  деструктор -
 освобождать ли память под указателями

таблица на основе TList с методами перемещения


}

end;
{
var
  params:AccountParams;
begin
params.AccountName:='Cryon';
params.Username:='cryon@fromru.com';
params.Password:='f301wn18z';
params.Host:='imap.fromru.com';
params.Id:=5;
params.Port:=110;

Receiver:=TPOP3Receiver.Create(params,ACon,30000,True);

}
procedure TFMain.Button1Click(Sender: TObject);
var
  manager:TAccountManager;
  params:AccountParams;
begin
 manager:=TAccountManager.Create(ACon);
 params.AccountName:='qwerty';
 params.Host:='localhost';
 params.Port:=1;
 params.Password:='qwerty';
 params.Username:='qwerty';
 manager.ModifyAccount(params);
end;

end.
