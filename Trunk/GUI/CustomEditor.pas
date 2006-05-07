unit CustomEditor;

interface

uses  Shared,   FilterManager, TypInfo,
  Windows, Messages, SysUtils,ADODB,DB, Classes, Controls, cxControls, cxPC ,Variants, Graphics,  Forms,
  Dialogs,   StdCtrls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, ExtCtrls, cxCheckBox, cxButtons;



type
  TFCustomEditor = class(TForm)
    TabControl: TcxTabControl;
    cCBFilter: TcxComboBox;
    cxCbActive: TcxCheckBox;
    leValue: TLabeledEdit;
    leDescription: TLabeledEdit;
    leFilter: TLabel;
    btOK: TButton;
    btCancel: TButton;
    leLocation: TLabel;
    cCBLocation: TcxComboBox;
    leMessage: TLabel;
    procedure cCBFilterPropertiesChange(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FFilterManager:TFilterManager;
    FFiltersTable: TADOQuery;
    FSNConverter: TSNIndexConverter;
    FEditorMode:TEditorMode;
    FSignList: TSignalDescriptorsList;
    FElementId:integer;
    { Private declarations }
  public
    constructor Create(SNConverter:TSNIndexConverter;FilterManager:TFilterManager;
        FilterTable:TADOQuery;SignList:TSignalDescriptorsList); reintroduce;
        overload;
    procedure Show(ElementValue:String; FilterType:TFilterType); reintroduce;
        overload; virtual;
    procedure Show(NodeIndex:integer); reintroduce; overload; virtual;
    procedure Show(ElementId:Integer;ElementValue:String; Description:String;
        Params:Variant;Status:boolean;NodeIndex:Integer); reintroduce; overload;
        virtual;
    property FiltersTable: TADOQuery read FFiltersTable write FFiltersTable;
    { Public declarations }
  end;

var
  FCustomEditor: TFCustomEditor;

implementation

{$R *.dfm}

constructor TFCustomEditor.Create(SNConverter:TSNIndexConverter;
    FilterManager:TFilterManager; FilterTable:TADOQuery;
    SignList:TSignalDescriptorsList);
var
 i:integer;
begin

  inherited Create(nil);
  FSignList:=SignList;

  for i:=0 to FSignList.Count-1 do
   cCBLocation.Properties.Items.Add(FSignList.Items[i].Description);
  cCBLocation.ItemIndex:=0;
  FSNConverter:=SNConverter;
  FFilterManager:=FilterManager;
  FFiltersTable:=FilterTable;
  for i:=0 to FSNConverter.Count - 1 do
    begin
      if FSNConverter.Item[i].FilterType in [ftBlackSender,ftWhiteSender,ftStamp,ftBlackWord,ftWhiteWord,
               ftBlackAttach,ftWhiteAttach,ftSpamWord] then
         cCBFilter.Properties.Items.Add(FSNConverter.Item[i].Name);

    end;

end;

procedure TFCustomEditor.Show(NodeIndex:integer);
var
 Res:TSNConvert;
begin
 leMessage.Caption:='';
 FEditorMode:=emAdd;
 cCBFilter.Enabled:=True;
 if FSNConverter.Find(NodeIndex,Res) then
  if Res.FilterType=ftNone then // ������ �� ��� ������
   begin
    cCBLocation.Enabled:=False;
    cCBFilter.ItemIndex:=FSNConverter.FindIndex(ftWhiteSender);
   end
  else
   begin
    cCBFilter.ItemIndex:=FSNConverter.FindIndex(Res.FilterType);
    if Res.FilterType in[ftBlackWord,ftWhiteWord] then cCBLocation.Enabled:=True;
   end;
{  else
   begin
     cCBLocation.Enabled:=False;
    cCBFilter.ItemIndex:=FSNConverter.FindIndex(ftWhiteSender);
   end;
 }    
 inherited Show;
end;

procedure TFCustomEditor.Show(ElementId:Integer;ElementValue:String;
    Description:String; Params:Variant;Status:boolean;NodeIndex:Integer);
var
 Res:TSNConvert;
 i:integer;
 Desc:String;
begin
 leMessage.Caption:='';
 FEditorMode:=emEdit;
 FElementId:=ElementId;
 leValue.Text:=ElementValue;
 leDescription.Text:=Description;
 cxCbActive.Checked:=Status;

 Desc:=FSignList.DescriptionByLocation(TSignalLocation(GetEnumValue(TypeInfo(TSignalLocation),Params)));
 FSNConverter.Find(NodeIndex,Res);
 cCBFilter.ItemIndex:=FSNConverter.FindIndex(Res.FilterType);
 cCBFilter.Enabled:=False;
 if not (Res.FilterType in [ftBlackWord,ftWhiteWord]) then
  begin
   cCBLocation.Enabled:=False;
   cCBFilter.ItemIndex:=0;
  end
  else
   begin
    for i:=0 to FSignList.Count-1 do
      if cCBLocation.Properties.Items.Strings[i]=Desc then  cCBLocation.ItemIndex:=i;
   end;
 inherited Show;
end;

procedure TFCustomEditor.cCBFilterPropertiesChange(Sender: TObject);
var
 Res:TSNConvert;
begin
 FSNConverter.FindByName(cCBFilter.Properties.Items.Strings[cCBFilter.ItemIndex],Res);
 if Res.FilterType in [ftBlackWord,ftWhiteWord] then
   cCBLocation.Enabled:=True
 else
  cCBLocation.Enabled:=False;
end;

procedure TFCustomEditor.btOKClick(Sender: TObject);
var
 Res:TSNConvert;
 Location:TSignalLocation;
begin

 FSNConverter.FindByName(cCBFilter.Properties.Items.Strings[cCBFilter.SelectedItem],Res);
 if Res.FilterType in [ftBlackWord,ftWhiteWord] then
  Location:=FSignList.LocationByDescription(cCBFilter.Properties.Items.Strings[cCBFilter.SelectedItem]);

 try
  if FEditorMode=emAdd
   then FFilterManager.AddElement(leValue.Text,Res.FilterType,leDescription.Text,cxCbActive.Checked,Location)
    else FFilterManager.ModifyElement(FElementId,leValue.Text,Res.FilterType,leDescription.Text,cxCbActive.Checked,Location);
  FFIltersTable.Active:=True;
  FFiltersTable.Requery;
  Close;
 except
  on e: Exception do
    leMessage.Caption:=e.Message;
   // ShowMessage(e.Message);
 end;
end;

procedure TFCustomEditor.btCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TFCustomEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 cxCbActive.Checked:=True;
 leValue.Text:='';
 leDescription.Text:='';
end;

procedure TFCustomEditor.Show(ElementValue:String; FilterType:TFilterType);
begin
 leValue.Text:=ElementValue;
 leMessage.Caption:='';
 FEditorMode:=emAdd;
 cCBFilter.Enabled:=True;
 cCBFilter.ItemIndex:=FSNConverter.FindIndex(FilterType);
 inherited Show;
end;

end.
