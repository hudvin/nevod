unit ModifyExt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FModifyExt: TFModifyExt;

implementation

{$R *.dfm}

end.
