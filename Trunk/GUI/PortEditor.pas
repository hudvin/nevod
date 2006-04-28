unit PortEditor;

interface

uses
  Windows, Messages, SysUtils, Variants,ADOdb,DB, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Shared;

type
  TFPortEditor = class(TForm)
    leServerPort: TLabeledEdit;
    btOK: TButton;
    btCancel: TButton;
    procedure btOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
  private
    SProvider: TSettings;
    function GetServerPort: string;
    procedure SetServerPort(const Value: string);
    { Private declarations }
  public
    CanExit:boolean;
    constructor Create(adCon:TADOConnection); reintroduce; overload;
    property ServerPort: string read GetServerPort write SetServerPort;
    { Public declarations }
  end;

var
  FPortEditor: TFPortEditor;
implementation
uses main;
{$R *.dfm}

constructor TFPortEditor.Create(adCon:TADOConnection);
begin
  SProvider:=TSettings.Create(adCon);
  inherited Create(nil);
end;

function TFPortEditor.GetServerPort: string;
begin
// ShowMessage(SProvider.GetValue('ServerPort'));
 Result:=SProvider.GetValue('ServerPort');
end;

procedure TFPortEditor.SetServerPort(const Value: string);
begin
  SProvider.SetValue('ServerPort',Value);
end;

procedure TFPortEditor.btOKClick(Sender: TObject);
begin
 if Trim(leServerPort.Text)<>'' then
 ServerPort:=leServerPort.Text;
 CanExit:=False;
 Close;
end;

procedure TFPortEditor.FormShow(Sender: TObject);
begin
 leServerPort.Text:=ServerPort;
end;

procedure TFPortEditor.btCancelClick(Sender: TObject);
begin
 CanExit:=true;
 Close;
end;

end.
