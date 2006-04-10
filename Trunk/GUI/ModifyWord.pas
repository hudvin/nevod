unit ModifyWord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxControls, cxPC, StdCtrls, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxContainer, cxEdit, cxCheckBox, ExtCtrls, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid;

type
  TFModifyWord = class(TForm)
    cxTabControl1: TcxTabControl;
    leWord: TLabeledEdit;
    leDescription: TLabeledEdit;
    cxCheckBox1: TcxCheckBox;
    cbLocation: TcxComboBox;
    btOK: TButton;
    btCancel: TButton;
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

  public
    Grid:TcxGridDBTableView;
    cxWordsActive:TcxGridDBColumn;
    cxWordsFValue:TcxGridDBColumn;
    cxWordsId:TcxGridDBColumn;
    cxWordSignalFilterDescription:TcxGridDBColumn;  // описание слова
    cxWordsTypesDescription:TcxGridDBcolumn;  // описание, где может находится слово 
  end;

var
  FModifyWord: TFModifyWord;

implementation
uses main;
{$R *.dfm}

procedure TFModifyWord.btCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TFModifyWord.btOKClick(Sender: TObject);
begin
 ShowMessage(cbLocation.EditValue);
end;

procedure TFModifyWord.FormShow(Sender: TObject);
begin
 leWord.Text:=Grid.Controller.SelectedRecords[0].Values[cxWordsFValue.Index];
// leWord.Text:=
//  AName:=cxAccounts.Controller.SelectedRecords[0].Values[cxAccountsAccountName.VisibleIndex];
 // получить нужные данные полей
  {

  заполнить поля нужными данными из таблицы
   при модификации
    проверить, чтобы поля не были пустыми
      получить тип таблицы (?)
      отправить запрос на модификацию и закрыть форму

  }
end;

end.
