unit ModifySender;

interface

uses
  Windows,main, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxContainer, cxEdit, cxCheckBox, ExtCtrls, cxControls,
  cxPC;

type
  TFModifySender = class(TForm)
    cxTabControl1: TcxTabControl;
    leWord: TLabeledEdit;
    leDescription: TLabeledEdit;
    chbActive: TcxCheckBox;
    btOK: TButton;
    btCancel: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    SenderId:Integer;
  end;

var
  FModifySender: TFModifySender;

implementation

{$R *.dfm}

procedure TFModifySender.FormShow(Sender: TObject);
begin
 leDescription.Text:='';
 leWord.Text:='';
 chbActive.Checked:=True;
 with main.FMain do
 begin
  SenderId:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsId.Index];
  leWord.Text:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsFValue.Index];
  leDescription.Text:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsTypesDescription.Index];
  chbActive.Checked:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsActive.Index];
 end

end;

end.
