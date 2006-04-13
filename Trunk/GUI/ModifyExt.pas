unit ModifyExt;

interface

uses
  Windows,main, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxContainer, cxEdit, cxCheckBox, ExtCtrls, cxControls,
  cxPC;

type
  TFModifyExt = class(TForm)
    cxTabControl1: TcxTabControl;
    leWord: TLabeledEdit;
    leDescription: TLabeledEdit;
    chbActive: TcxCheckBox;
    btOK: TButton;
    btCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    AttachExtId :Integer;
  end;

var
  FModifyExt: TFModifyExt;

implementation

{$R *.dfm}

procedure TFModifyExt.FormShow(Sender: TObject);
begin
 leDescription.Text:='';
 leWord.Text:='';
 chbActive.Checked:=True;
 with main.FMain do
 begin
  AttachExtId:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsId.Index];
  leWord.Text:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsFValue.Index];
  leDescription.Text:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsTypesDescription.Index];
  chbActive.Checked:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsActive.Index];
 end
end;

procedure TFModifyExt.btCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TFModifyExt.btOKClick(Sender: TObject);
var
 Flag:boolean;
begin
 try
  if chbActive.Checked then Flag:=True
   else Flag:=False;
  main.FMain.FManager.ModifyAttachExt(AttachExtId,leWord.Text,leDescription.Text,main.FMain.WordsTable,Flag);
  Close;
 except
  on e: Exception do
    ShowMessage(E.Message);
 end;

end;

end.
