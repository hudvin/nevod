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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    WordId:Integer;
  public
  end;

var
  FModifyWord: TFModifyWord;
  SelDesc:TSignalDescriptorsList;
implementation
uses main;
{$R *.dfm}

procedure TFModifyWord.btCancelClick(Sender: TObject);
begin
 Close;
end;



procedure TFModifyWord.FormCreate(Sender: TObject);
var
 buff:TSignalLocation;
begin
 SelDesc:=TSignalDescriptorsList.Create;
 with main.FMain.adTest do
  begin
    Active:=False;
    SQl.Text:='SELECT Type,Description FROM Types ORDER BY Id ';
    Active:=True;
    while not Eof do
      begin
       buff:=TSignalLocation(GetEnumValue(TypeInfo(TSignalLocation),FieldByName('Type').AsString));
       if buff in [slBody,slSubject,slAnywhere]
        then  SelDesc.Add(buff,FieldByName('Description').AsString) ;
       Next;
      end;
  end;

 cbLocation.Properties.Items.Add(SelDesc.DescriptionByLocation(slAnywhere));
 cbLocation.Properties.Items.Add(SelDesc.DescriptionByLocation(slSubject));
 cbLocation.Properties.Items.Add(SelDesc.DescriptionByLocation(slBody));
end;

procedure TFModifyWord.FormDestroy(Sender: TObject);
begin
 SelDesc.Free;
end;

procedure TFModifyWord.btOKClick(Sender: TObject);
var
 loc:TSignalLocation;
 Flag:boolean;
begin
 try
  if chbActive.Checked then Flag:=True
   else Flag:=False;
  loc:=SelDesc.LocationByDescription(cbLocation.Properties.Items.Strings[cbLocation.SelectedItem]);
  main.FMain.FManager.ModifySignal(WordId, leWord.Text,leDescription.Text,main.FMain.WordsTable,loc,Flag);
  Close;
 except
  on e: Exception do
   ShowMessage(e.Message);
 end;

end;

procedure TFModifyWord.FormShow(Sender: TObject);
var
 Flag:boolean;
 i:integer;
 loc:String;
begin
with main.FMain do
 begin
  WordId:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsId.Index];
  leWord.Text:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsFValue.Index];
  leDescription.Text:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordSignalFilterDescription.Index];
  chbActive.Checked:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsActive.Index];
  loc:=cxWordsGrid.Controller.SelectedRecords[0].Values[cxWordsTypesDescription.Index];
 end;
  Flag:=False;
  i:=0;
  while (not Flag) and (i<cbLocation.Properties.Items.Count) do
     if cbLocation.Properties.Items.Strings[i]=loc then
      begin
       Flag:=True;
       cbLocation.ItemIndex:=i;
      end
       else
        inc(i);
end;

end.
