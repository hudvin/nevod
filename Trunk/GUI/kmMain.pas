unit kmMain;

interface

uses
  Windows,Shared, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, XPMan;

type
  TFMain = class(TForm)
    XPManifest1: TXPManifest;
    btGenerate: TButton;
    leUsername: TLabeledEdit;
    leActivationKey: TLabeledEdit;
    leCRC: TLabeledEdit;
    procedure btGenerateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;
function GetCryptKey:PChar;external 'Shared.dll';
function md5_32(InputString:WideString):WideString;external 'Shared.dll';
implementation

{$R *.dfm}

procedure TFMain.btGenerateClick(Sender: TObject);
var
 key:String;
 cd:TBFCoder;
begin
 cd:=TBFCoder.Create;
 key:=leUsername.Text+leCRC.Text+String(GetCryptKey);
 cd.Key:=String(GetCryptKey);
 key:=trim(cd.Crypt(key));
 leActivationKey.Text:=md5_32(key);
 cd.Free;
end;

end.
