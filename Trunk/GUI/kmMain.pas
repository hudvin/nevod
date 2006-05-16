unit kmMain;

interface

uses
  Windows, Shared,Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, XPMan;

type
  TFMain = class(TForm)
    XPManifest1: TXPManifest;
    btGenerate: TButton;
    leUsername: TLabeledEdit;
    leActivationKeu: TLabeledEdit;
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
function md5(InputString:ShortString): ShortString; external 'Shared.DLL';
implementation

{$R *.dfm}

procedure TFMain.btGenerateClick(Sender: TObject);
var
 cd:TBFCoder;
 key:String;
begin
 cd:=TBFCoder.Create;
 key:=leUsername.Text+leCRC.Text+GetCryptKey;
 cd.Key:=GetCryptKey;
 key:=cd.Crypt(key);
 key:=md5(key);
 leActivationKeu.Text:=key;
 cd.Free;
end;

end.
