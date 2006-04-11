unit AddStamp;

interface

uses
  Windows,DB, ADODB, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,main, cxContainer, cxEdit, cxCheckBox, StdCtrls, ExtCtrls, cxControls,
  cxPC;

type
  TFAddStamp = class(TForm)
    cxTabControl1: TcxTabControl;
    leStamp: TLabeledEdit;
    leDescription: TLabeledEdit;
    cxActive: TcxCheckBox;
    btAdd: TButton;
    btCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
  private
    adTest:TADOQuery;
  public
    { Public declarations }
  end;

var
  FAddStamp: TFAddStamp;

implementation

uses Math;

{$R *.dfm}

procedure TFAddStamp.FormShow(Sender: TObject);
begin
 leDescription.Text:='';
 leStamp.Text:='';
end;

procedure TFAddStamp.btAddClick(Sender: TObject);
var
 Flag:boolean;
begin
 try
  if cxActive.Checked  then
  Flag:=True
   else Flag:=False;
  main.FMain.FManager.AddStamp(leStamp.Text,leDescription.Text,Flag);
  Close;
 except
  on E: Exception  do
    ShowMessage(E.Message);
 end;
end;

procedure TFAddStamp.FormCreate(Sender: TObject);
begin
 adTest:=main.FMain.adTest; // создание ссылки на компонент для проверки данных
end;

procedure TFAddStamp.btCancelClick(Sender: TObject);
begin
 Close;
end;

end.
