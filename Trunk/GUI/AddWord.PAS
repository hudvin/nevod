unit AddWord;

interface

uses
  Windows, main,Typinfo, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxContainer,
  cxEdit, cxCheckBox, ExtCtrls, cxControls, cxPC,Shared;


type
  TFAddWord = class(TForm)
    cxTabControl1: TcxTabControl;
    leWord: TLabeledEdit;
    leDescription: TLabeledEdit;
    chbActive: TcxCheckBox;
    cbLocation: TcxComboBox;
    btOK: TButton;
    btCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  FAddWord: TFAddWord;
  SelDesc:TSignalDescriptorsList;
implementation

uses ADODB;

{$R *.dfm}


procedure TFAddWord.FormCreate(Sender: TObject);
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

procedure TFAddWord.FormDestroy(Sender: TObject);
begin
 SelDesc.Free;
end;

procedure TFAddWord.btOKClick(Sender: TObject);
var
 loc:TSignalLocation;
 Flag:boolean;
begin
 try
  if chbActive.Checked then Flag:=True
   else Flag:=False;
  loc:=SelDesc.LocationByDescription(cbLocation.Properties.Items.Strings[cbLocation.SelectedItem]);
  main.FMain.FManager.AddSignal(leWord.Text,leDescription.Text,main.FMain.WordsTable,loc,Flag);
  Close;
 except
  on e: Exception do
   ShowMessage(e.Message);
 end;
end;

procedure TFAddWord.FormShow(Sender: TObject);
begin
 cbLocation.ItemIndex:=0;
 leWord.Text:='';
 leDescription.Text:='';
 chbActive.Checked:=True;
end;

procedure TFAddWord.btCancelClick(Sender: TObject);
begin
 Close;
end;

end.
