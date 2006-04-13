unit ModifyStamp;

interface

uses
  Windows, Messages,main, StdCtrls, cxContainer, cxEdit, cxCheckBox,
  ExtCtrls,  Classes, Graphics, Controls, Forms,Extdlgs,  SysUtils,
  Dialogs, cxControls,  cxPC;

type
  TFModifyStamp = class(TForm)
    cxTabControl1: TcxTabControl;
    leStamp: TLabeledEdit;
    leDescription: TLabeledEdit;
    cxActive: TcxCheckBox;
    btAdd: TButton;
    btCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
  private
   StampId:integer;
  public
    { Public declarations }
  end;

var
  FModifyStamp: TFModifyStamp;

implementation

{$R *.dfm}

procedure TFModifyStamp.FormShow(Sender: TObject);
begin
 with main.FMain do
 begin
  StampId:=cxStamps.Controller.SelectedRecords[0].Values[cxStampsId.Index];
  leStamp.Text:=cxStamps.Controller.SelectedRecords[0].Values[cxStampsFValue.Index];
  leDescription.Text:=cxStamps.Controller.SelectedRecords[0].Values[cxStampsDescription.Index];
  cxActive.Checked:=cxStamps.Controller.SelectedRecords[0].Values[cxStampsActive.Index];
 end;
end;

procedure TFModifyStamp.btCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TFModifyStamp.btAddClick(Sender: TObject);
var
 Flag:boolean;
begin
 try
  if CxActive.Checked then Flag:=True
   else Flag:=False;
  main.FMain.FManager.ModifyStamp(StampId,leStamp.Text,leDescription.Text,Flag);
  Close;
 except
  on E: Exception  do
    ShowMessage(E.Message);
 end;

end;

end.
