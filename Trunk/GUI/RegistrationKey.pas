unit RegistrationKey;

interface

uses
  Windows,aspr_api,gnugettext, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxControls, cxPC, StdCtrls, ExtCtrls;

type
  TFRegistrationKey = class(TForm)
    cxTab: TcxTabControl;
    leUsername: TLabeledEdit;
    leKey: TLabeledEdit;
    btOk: TButton;
    btCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FResult: Integer;
    { Private declarations }
  public
    property Result: Integer read FResult write FResult;
    { Public declarations }
  end;

var
  FRegistrationKey: TFRegistrationKey;

implementation

{$R *.dfm}

procedure TFRegistrationKey.FormShow(Sender: TObject);
begin
 leUsername.Text:='';
 leKey.Text:='';
 Result:=0;
end;

procedure TFRegistrationKey.btCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TFRegistrationKey.btOkClick(Sender: TObject);
begin
 if CheckKeyAndDecrypt( PChar(leKey.Text), PChar(leUsername.Text), True ) then
  begin
    MessageBoxW(Handle, PWideChar(_('Спасибо за регистрацию!')), PWideChar(_('Регистрация')), MB_ICONINFORMATION);
    Result:=1;
    Close;
  end
 else
  MessageBoxW(Handle, PWideChar(_('Неправильный ключ')),PWideChar(_('Регистрация')), MB_ICONWARNING);
end;

procedure TFRegistrationKey.FormCreate(Sender: TObject);
begin
 TranslateComponent(self);
end;

end.
