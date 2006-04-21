unit main;

interface

uses Forms,Windows, Dialogs, Registry, dxBar, cxStyles, Shared,
  cxTL, DB, ADODB,  StdCtrls, ExtCtrls, cxContainer, cxEdit,
  cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  SysUtils, Typinfo, FilterManager,

  cxGridCustomView, cxGrid, Menus,
  cxGridCustomPopupMenu, cxGridPopupMenu, Classes, Controls,
  cxGridDBTableView, cxClasses, cxControls, cxPC, cxSplitter,
  cxInplaceContainer, dxStatusBar, cxLookAndFeels,CustomEditor, ActnList,
  XPStyleActnCtrls, ActnMan, 
  ImgList, dxBarExtItems;


type
  TFMain = class(TForm)
    stBar: TdxStatusBar;
    SettingsTree: TcxTreeList;
    cxSplitter1: TcxSplitter;
    STree: TcxTreeListColumn;
    stPages: TcxPageControl;
    cxTab_Accounts: TcxTabSheet;
    cxAccountsGridLevel1: TcxGridLevel;
    cxAccountsGrid: TcxGrid;
    adAccounts: TADOTable;
    dsAccounts: TDataSource;
    adCon: TADOConnection;
    adAccountsid: TAutoIncField;
    adAccountsAccountName: TWideStringField;
    adAccountsusername: TWideStringField;
    adAccountspass: TWideStringField;
    adAccountshost: TWideStringField;
    adAccountsport: TIntegerField;
    adAccountsTimeout: TIntegerField;
    dsLog: TDataSource;
    adLog: TADOQuery;
    cxTab_Log: TcxTabSheet;
    adLogAccountName: TWideStringField;
    adLogErrorType: TWideStringField;
    adLogMessage: TWideStringField;
    adLogErrorTime: TDateTimeField;
    cxGrid2DBTableView1: TcxGridDBTableView;
    cxGrid2Level1: TcxGridLevel;
    cxGrid2: TcxGrid;
    cxGrid2DBTableView1AccountName: TcxGridDBColumn;
    cxGrid2DBTableView1ErrorType: TcxGridDBColumn;
    cxGrid2DBTableView1Message: TcxGridDBColumn;
    cxGrid2DBTableView1ErrorTime: TcxGridDBColumn;
    adLogId: TAutoIncField;
    cxGrid2DBTableView1Id: TcxGridDBColumn;
    dxBarManager1: TdxBarManager;
    cxAccounts: TcxGridTableView;
    cxAccountsAccountName: TcxGridColumn;
    cxAccountsUsername: TcxGridColumn;
    cxAccountsPassword: TcxGridColumn;
    cxAccountsServer: TcxGridColumn;
    cxAccountsPort: TcxGridColumn;
    cxAccountsTimeout: TcxGridColumn;
    cxAccountsStatus: TcxGridColumn;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    aMan: TActionManager;
    amAddAccount: TAction;
    amDeleteAccount: TAction;
    pbAddAccount: TdxBarButton;
    dxMFilters: TdxBarSubItem;
    amAddStamp: TAction;
    amModifyWord: TAction;
    amAddWord: TAction;
    dxBarButton1: TdxBarButton;
    amModifyStamp: TAction;
    dxBarButton4: TdxBarButton;
    dxFiltersStamps: TdxBarSubItem;
    dxFiltersStampsAdd: TdxBarButton;
    dxFiltersStampsDelete: TdxBarButton;
    dxFiltersStampsEdit: TdxBarButton;
    amRemoveStamp: TAction;
    dxPopupStampEdit: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxpFiltersStampsEdit: TdxBarButton;
    dxpFiltersRevomeStamp: TdxBarButton;
    dxpFiltersStampsAdd: TdxBarButton;
    amSetStampsStatusToActive: TAction;
    dxpFiltersStampSetToActive: TdxBarButton;
    dxFiltersStampsSetToActive: TdxBarButton;
    amSetStampsStatusToNonActive: TAction;
    dxpFiltersStampSetToNonActive: TdxBarButton;
    dxFiltersStampSetToNonActive: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxFiltersBlackWords: TdxBarSubItem;
    dxFiltersBlackWordsAdd: TdxBarButton;
    dxFiltersBlackWordsDelete: TdxBarButton;
    dxFiltersBlackWordsEdit: TdxBarButton;
    dxFiltersBlackWordsSetToActive: TdxBarButton;
    dxFiltersBlackWordsSetToNonActive: TdxBarButton;
    dxFiltersWhiteWords: TdxBarSubItem;
    dxFiltersWhiteWordsAdd: TdxBarButton;
    dxFiltersWhiteWordsEdit: TdxBarButton;
    dxFiltersWhiteWordsDelete: TdxBarButton;
    dxFiltersWhiteWordsSetToActive: TdxBarButton;
    dxFiltersWhiteWordsSetToNonActive: TdxBarButton;
    dxBarButton18: TdxBarButton;
    dxBarButton19: TdxBarButton;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarStatic1: TdxBarStatic;
    cxTab_Filters: TcxTabSheet;
    cxFilters: TcxGridDBTableView;
    cxFiltersGridLevel1: TcxGridLevel;
    cxFiltersGrid: TcxGrid;
    dxBarButton3: TdxBarButton;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyleRepository2: TcxStyleRepository;
    cxStyle2: TcxStyle;
    adFilters: TADOQuery;
    dsFilters: TDataSource;
    adFiltersid: TAutoIncField;
    adFiltersFValue: TWideStringField;
    adFiltersDescription: TWideStringField;
    adFiltersParams: TWideStringField;
    adFiltersActive: TBooleanField;
    cxFiltersid: TcxGridDBColumn;
    cxFiltersFValue: TcxGridDBColumn;
    cxFiltersDescription: TcxGridDBColumn;
    cxFiltersParams: TcxGridDBColumn;
    cxFiltersActive: TcxGridDBColumn;
    Button1: TButton;
    cxTab_Settings: TcxTabSheet;
    ADOQuery1: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure amDeleteAccountExecute(Sender: TObject);
    procedure SettingsTreeSelectionChanged(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure adFiltersParamsGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    CurrNode:TcxTreeListNode;
    { Private declarations }
  public
    SignList:TSignalDescriptorsList;
    CurrentFilterType:TFilterType;  // тип текущего фильтра
    SNConverter:TSNIndexConverter;
 //   PSManager: TPostManager;
    FManager:TFilterManager;
    procedure RunOnStartup(Run:boolean);
    procedure UpdateHeaders(Headers:TColumnsHeaders);

    { Public declarations }
  protected
    procedure SetCurrentParams(Grid:TcxGridDBTableView;Filter:TFilterType);
  end;

var
  FMain: TFMain;
  DragState:boolean=False;
  FEditor:TFCustomEditor;
implementation



{$R *.dfm}
{$R ..\Resources\WinXP.res}



procedure TFMain.RunOnStartup(Run:boolean);
begin
end;

procedure TFMain.FormCreate(Sender: TObject);
var
 Headers:TColumnsHeaders;
begin
 SNConverter:=TSNIndexConverter.Create;
 SignList:=TSignalDescriptorsList.Create;
 SignList.Add(slAnywhere,' в теле и в теме сообщения ');
 SignList.Add(slSubject,' в теме сообщения ');
 SignList.Add(slBody,' в теле сообщения ');

 Headers.Active:='Active';
 Headers.Description:='Description';
 with SNConverter do
   begin
    Headers.FValue:='Sender';
    Add(6,ftWhiteSender,'Добавить адрес/домен в белый список',cxTab_Filters,Headers); //адрес в белый список
    Add(10,ftBlackSender,'Добавить адрес/домен в черный список',cxTab_Filters,Headers); //адрес в черный список

    Headers.FValue:='File Extension';
    Add(7,ftWhiteAttach,'Добавить расширений приложенного файла в белый список',cxTab_Filters,Headers); // расширение в белый список
    Add(11,ftBlackAttach,'Добавить расширений приложенного файла в черный список',cxTab_Filters,Headers);// расширение в черный список

    Headers.Params:='Location';
    Headers.FValue:='Word';
    Add(4,ftWhiteWord,'Добавить слово в белый список',cxTab_Filters,Headers); // слово в белый список
    Add(9,ftBlackWord,'Добавить слово в черный список',cxTab_Filters,Headers); // слово в черный список

    Headers.FValue:='Nevod Stamp';
    Add(5,ftStamp,'Добавить штамп',cxTab_Filters,Headers); // штамп
    // добавление панелей не-фильтров
   Add(0,ftNone,'',cxTab_Settings);      // основные настройки
   Add(1,ftNone,'',cxTab_Accounts);      // учетные записи
   Add(13,ftNone,'',cxTab_Log);
   end;

// Coder.Key:=CriptKey;

 FManager:=TFilterManager.Create(adCon);
 FEditor:=TFCustomEditor.Create(SNConverter,FManager,adFilters,SignList);
end;


procedure TFMain.FormDestroy(Sender: TObject);
begin
 FManager.Free;
 SNConverter.Free;
 FEditor.Free;
 SignList.Free;
end;

procedure TFMain.amDeleteAccountExecute(Sender: TObject);
begin
 if Application.MessageBox('Are you are sure ?','Deleting Account',MB_OKCANCEL)=IDOK then
  begin
 //  PSManager.AccountManager.DeleteAccount( PSManager.AccountManager.AccountName2Id(cxAccounts.Controller.SelectedRecords[0].Values[cxAccountsAccountName.VisibleIndex]));
  end;
end;

procedure TFMain.SettingsTreeSelectionChanged(Sender: TObject);
var
 NodeIndex:Integer;
 FilterType:TFilterType;
 RowSQL:String;
 Res:TSNConvert;
begin
 NodeIndex:=STree.TreeList.FocusedNode.AbsoluteIndex;
 if SNConverter.Find(NodeIndex,Res) then
  Res.Sheet.Show;
 if Res.FilterType<>ftNone then
  begin
   UpdateHeaders(Res.Headers);
   if Res.FilterType in [ftWhiteWord,ftBlackWord] then
    cxFiltersParams.Visible:=True
     else cxFiltersParams.Visible:=False;
   with adFilters do
    begin
     SQL.Clear;
     Active:=False;
   //  if (FilterType in [ftBlackWord,ftWhiteWord]) then
     SQL.Text:='SELECT id,FValue,Description,Active,Params '+
                  ' FROM FiltersParams WHERE mid=(SELECT id FROM Filters WHERE Type=:FilterType) ';
    {   else
        begin
         SQL.Add('SELECT FiltersParams.Id, ');
         SQL.Add('FiltersParams.FValue,FiltersParams.Description,Types.Description,FiltersParams.Active  FROM ');
         SQL.Add('FiltersParams,Types WHERE FiltersParams.Params=Types.Type');
         SQL.Add('AND mid=( SELECT id FROM Filters  WHERE Type=:FilterType )');
        end;   }
     Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(Res.FilterType));
     Active:=True;
    end;
  end;
end;

procedure TFMain.SetCurrentParams(Grid:TcxGridDBTableView;Filter:TFilterType);
begin
 CurrentFilterType:=Filter;
end;

procedure TFMain.Button1Click(Sender: TObject);
begin
 FEditor.ShowModal(STree.TreeList.FocusedNode.AbsoluteIndex);
end;

procedure TFMain.UpdateHeaders(Headers:TColumnsHeaders);
begin
 with Headers do
   begin
    if Active<>'' then cxFiltersActive.Caption:=Active;
    if Description<>'' then cxFiltersDescription.Caption:=Description;
    if FValue<>'' then  cxFiltersFValue.Caption:=FValue;
    if Params<>'' then cxFiltersParams.Caption:=Params;
   end;
end;

procedure TFMain.Button2Click(Sender: TObject);
var
 fm:TFCustomEditor;
begin
 fm:=TFCustomEditor.Create(nil);
 fm.ShowModal(5);
end;

procedure TFMain.adFiltersParamsGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
 Text:=SignList.DescriptionByLocation(TSignalLocation(GetEnumValue(TypeInfo(TSignalLocation),Sender.AsString)));

{ if Trim(Sender.Value)='slSubject'
   then  Text:=' в теме сообщения ';
 if Trim(Sender.Value)='slAnywhere'
   then  Text:=' в теме и в теле сообщения ';
 if Trim(Sender.Value)='slBody'
   then  Text:=' в теле сообщения ';  }
end;

end.
