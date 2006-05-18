unit Register;

interface

uses
  Windows,RegistrationKey, Messages,ShellAPI, StdCtrls, cxContainer, cxEdit, cxProgressBar,
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
    procedure btBuyClick(Sender: TObject);
    procedure btEnterCodeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btExitClick(Sender: TObject);
  private
    FResult: Integer;
    { Private declarations }
  public
    property Result: Integer read FResult write FResult;
    { Public declarations }
  end;

var
  FRegister: TFRegister;
  RegistrationKeyForm:TFRegistrationKey;
implementation

{$R *.dfm}
procedure TFRegister.btBuyClick(Sender: TObject);
begin
 ShellExecute(Handle, nil, 'http://www.emetrix.com', nil, nil, SW_SHOW);
end;

procedure TFRegister.btEnterCodeClick(Sender: TObject);
begin
 RegistrationKeyForm.ShowModal;
end;

procedure TFRegister.FormCreate(Sender: TObject);
begin
 RegistrationKeyForm:=TFRegistrationKey.Create(nil);
 Result:=1;
end;

procedure TFRegister.FormDestroy(Sender: TObject);
begin
 RegistrationKeyForm.Free;
end;

procedure TFRegister.btExitClick(Sender: TObject);
begin
 Result:=0;
 Close;
end;

end.
