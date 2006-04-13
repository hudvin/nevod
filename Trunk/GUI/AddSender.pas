unit AddSender;

interface

uses 
  Windows,main, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxContainer, cxEdit, cxCheckBox, ExtCtrls, cxControls,
  cxPC;

type
  TFAddSender = class(TForm)
    cxTabControl1: TcxTabControl;
    leWord: TLabeledEdit;
    leDescription: TLabeledEdit;
    chbActive: TcxCheckBox;
    btOK: TButton;
    btCancel: TButton;
    procedure btCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAddSender: TFAddSender;

implementation

{$R *.dfm}

procedure TFAddSender.btCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TFAddSender.FormShow(Sender: TObject);
begin
  leDescription.Text:='';
  leWord.Text:='';
end;

procedure TFAddSender.btOKClick(Sender: TObject);
var
 Flag:boolean;
begin
 try
  if chbActive.Checked then Flag:=True;
  main.FMain.FManager.AddSender(leWord.Text,leDescription.Text,main.FMain.WordsTable,Flag);
  Close;
 except
  on e: Exception do
   ShowMessage(E.Message);
 end;
end;

end.
