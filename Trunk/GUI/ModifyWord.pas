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
    cxWordSignalFilterDescription:TcxGridDBColumn;  // �������� �����
    cxWordsTypesDescription:TcxGridDBcolumn;  // ��������, ��� ����� ��������� ����� 
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
 // �������� ������ ������ �����
  {

  ��������� ���� ������� ������� �� �������
   ��� �����������
    ���������, ����� ���� �� ���� �������
      �������� ��� ������� (?)
      ��������� ������ �� ����������� � ������� �����

  }
end;

end.
