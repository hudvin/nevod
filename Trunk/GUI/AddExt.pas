unit AddExt;

interface

uses
  Windows,main, StdCtrls, cxContainer, cxEdit, cxCheckBox,
  Classes,    SysUtils, Variants,  Graphics, Controls, Forms,
  Dialogs,    ExtCtrls, cxControls,  cxPC;

type
  TFAddExt = class(TForm)
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
  FAddExt: TFAddExt;

implementation

{$R *.dfm}

procedure TFAddExt.btCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TFAddExt.FormShow(Sender: TObject);
var
  Flag:boolean;
begin
 leWord.Text:='';
 leDescription.Text:='';
 chbActive.Checked:=True;
end;

procedure TFAddExt.btOKClick(Sender: TObject);
var
  Flag:boolean;
begin
 try
  if chbActive.Checked then Flag:=True
   else Flag:=False;
  main.FMain.FManager.AddAttachExt(leWord.Text,leDescription.Text,main.FMain.WordsTable,Flag);
  Close;
 except
  on e: Exception do
   ShowMessage(e.Message);
 end;

end;

end.
