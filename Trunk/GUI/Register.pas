unit Register;

interface

uses
  Windows, Messages,ShellAPI, StdCtrls, cxContainer, cxEdit, cxProgressBar,
  Classes, Controls, cxControls, cxPC ,SysUtils, Variants,  Graphics,  Forms,
  Dialogs;

type
  TFRegister = class(TForm)
    cxTab: TcxTabControl;
    cxProgressBar: TcxProgressBar;
    btBuy: TButton;
    btEnterCode: TButton;
    btLater: TButton;
    btExit: TButton;
    procedure FormDeactivate(Sender: TObject);
    procedure btBuyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRegister: TFRegister;

implementation

{$R *.dfm}
procedure TFRegister.FormDeactivate(Sender: TObject);
begin
 //Free;
end;
 { initialization
  begin
    FRegister := TFRegister.Create(nil);
    FRegister.Show;
    FRegister.Update;
  end; }
procedure TFRegister.btBuyClick(Sender: TObject);
begin
 ShellExecute(Handle, nil, 'http://www.emetrix.com', nil, nil, SW_SHOW);
end;

end.
