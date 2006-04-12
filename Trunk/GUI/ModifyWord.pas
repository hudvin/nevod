unit ModifyWord;

interface

uses
  Windows,Shared, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxControls, cxPC, StdCtrls, cxTextEdit, cxMaskEdit, ADODB,DB,  Typinfo,
  cxDropDownEdit, cxContainer, cxEdit, cxCheckBox, ExtCtrls, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid;

type
  TFModifyWord = class(TForm)
    cxTabControl1: TcxTabControl;
    leWord: TLabeledEdit;
    leDescription: TLabeledEdit;
    chbActive: TcxCheckBox;
    cbLocation: TcxComboBox;
    btOK: TButton;
    btCancel: TButton;
    procedure btCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbLocationPropertiesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FSelectedLocation: TSignalLocation;
    Proc:TADOQuery;
    { Private declarations }

  public
    adWords:TADOQuery;
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

procedure TFModifyWord.FormShow(Sender: TObject);
begin
 leWord.Text:=Grid.Controller.SelectedRecords[0].Values[cxWordsFValue.Index];
 leDescription.Text:=Grid.Controller.SelectedRecords[0].Values[cxWordSignalFilterDescription.Index];
 if Grid.Controller.SelectedRecords[0].Values[cxWordsActive.Index]
  then chbActive.Checked:=True
   else chbActive.Checked:=False;
 with Proc do
   begin
    Active:=False;
    SQL.Text:='SELECT Type FROM Types WHERE Description=:Desc';
    Parameters.ParamByName('Desc').Value:=Grid.Controller.SelectedRecords[0].Values[cxWordsTypesDescription.Index];
    Active:=True;
    case TSignalLocation(GetEnumValue(TypeInfo(TSignalLocation),FieldByName('Type').AsString)) of
     slAnywhere: cbLocation.ItemIndex:=2;
     slBody:     cbLocation.ItemIndex:=1;
     slSubject:  cbLocation.ItemIndex:=0;
    end;
    Active:=False;
   end;

end;

procedure TFModifyWord.cbLocationPropertiesChange(Sender: TObject);
begin
 case cbLocation.SelectedItem of
   0: FSelectedLocation:=slSubject ;
   1: FSelectedLocation:=slBody;
   2: FSelectedLocation:=slAnywhere;
 end;
end;

procedure TFModifyWord.FormCreate(Sender: TObject);
begin
 Proc:=main.FMain.adTest;
end;

end.
