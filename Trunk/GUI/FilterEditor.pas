unit FilterEditor;

interface

uses  Shared,   FilterManager, TypInfo,  gnugettext, 
  Windows, Messages, SysUtils,ADODB,DB, Classes, Controls, cxControls, cxPC ,Variants, Graphics,  Forms,
  Dialogs,   StdCtrls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, ExtCtrls, cxCheckBox, cxButtons, JvComponent,
  JvBalloonHint, cxGroupBox, JvComponentBase;



type
  TFCustomEditor = class(TForm)
    cCBFilter: TcxComboBox;
    cxCbActive: TcxCheckBox;
    leValue: TLabeledEdit;
    leDescription: TLabeledEdit;
    leFilter: TLabel;
    btOK: TButton;
    btCancel: TButton;
    leLocation: TLabel;
    cCBLocation: TcxComboBox;
    JvBal: TJvBalloonHint;
    cxTab: TcxTabControl;
    cxGroupBox1: TcxGroupBox;
    procedure cCBFilterPropertiesChange(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure leValueKeyPress(Sender: TObject; var Key: Char);
  private
    FFilterManager:TFilterManager;
    FFiltersTable: TADOQuery;
    FSNConverter: TSNIndexConverter;
    FEditorMode:TEditorMode;
    FSignList: TSignalDescriptorsList;
    FElementId:integer;
    FShowed:boolean;
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
uses main;
{$R *.dfm}

constructor TFCustomEditor.Create(SNConverter:TSNIndexConverter;
    FilterManager:TFilterManager; FilterTable:TADOQuery;
    SignList:TSignalDescriptorsList);
var
 i:integer;
begin
  FShowed:=False;
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
               ftBlackAttach,ftWhiteAttach] then
         cCBFilter.Properties.Items.Add(FSNConverter.Item[i].Name);
    end;
  TranslateComponent(Self);
end;

procedure TFCustomEditor.Show(NodeIndex:integer);
var
 Res:TSNConvert;
begin
 FEditorMode:=emAdd;
 Caption:=_('Добавление нового фильтра');
 cCBFilter.Enabled:=True;
 if FSNConverter.Find(NodeIndex,Res) then
  if Res.FilterType=ftNone then // фильтр не был выбран
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
 FShowed:=True;
end;

procedure TFCustomEditor.Show(ElementId:Integer;ElementValue:String;
    Description:String; Params:Variant;Status:boolean;NodeIndex:Integer);
var
 Res:TSNConvert;
 i:integer;
 Desc:String;
begin
 FEditorMode:=emEdit;
 Caption:=_('Редактирование фильтра');
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
 //  cCBLocation.Enabled:=False;
  // cCBFilter.ItemIndex:=0;
  end
  else
   begin
    for i:=0 to FSignList.Count-1 do
      if cCBLocation.Properties.Items.Strings[i]=Desc then  cCBLocation.ItemIndex:=i;
   end;
 inherited Show;
 if not main.FMain.Showing then main.FMain.Hide;
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
 mError,mCaption:String;
begin
 FSNConverter.FindByName(cCBFilter.Properties.Items.Strings[cCBFilter.SelectedItem],Res);// тип фильтра
 if Res.FilterType in [ftBlackWord,ftWhiteWord] then
  Location:=FSignList.LocationByDescription(cCBLocation.Properties.Items.Strings[cCBLocation.SelectedItem]);
 try
  if FEditorMode=emAdd
   then FFilterManager.AddElement(leValue.Text,Res.FilterType,leDescription.Text,cxCbActive.Checked,Location)
    else FFilterManager.ModifyElement(FElementId,leValue.Text,Res.FilterType,leDescription.Text,cxCbActive.Checked,Location);
  PostMessage(main.FMain.Handle,WM_UpdateFilters,0,0);
  Close;
 except
  on e: Exception do
    ShowMessageBox(Handle,e.Message,String(_('Ошибка')),MB_ICONWARNING or MB_SETFOREGROUND);
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
 JvBal.CancelHint;
 PostMessage(main.FMain.Handle,WM_DestroyRulesEditor,0,0 );

end;

procedure TFCustomEditor.Show(ElementValue:String; FilterType:TFilterType);
begin
 leValue.Text:=ElementValue;
 FEditorMode:=emAdd;
 caption:=_('Добавление фильтра');
 cCBFilter.Enabled:=True;
 cCBFilter.ItemIndex:=FSNConverter.FindIndex(FilterType);
 inherited Show;
 if not main.FMain.Showing then
  main.FMain.Hide;
   
end;

procedure TFCustomEditor.leValueKeyPress(Sender: TObject; var Key: Char);
begin
 if Ord(key)>127 then
  begin
   Key := #0;
   JvBal.ActivateHint(leValue,_('В данное поле можно вводить только английские символы и цифры'),_('Внимание !'),1500);
   Beep;
  end;
end;

end.
