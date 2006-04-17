unit main;

interface

uses Forms,Windows, Dialogs, Registry, dxBar, cxStyles, Shared,
  cxTL, DB, ADODB,  StdCtrls, ExtCtrls, cxContainer, cxEdit,
  cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  SysUtils, Typinfo, FilterManager,

  cxGridCustomView, cxGrid, Menus,
  cxGridCustomPopupMenu, cxGridPopupMenu, Classes, Controls,
  cxGridDBTableView, cxClasses, cxControls, cxPC, cxSplitter,
  cxInplaceContainer, dxStatusBar, cxLookAndFeels, ActnList,
  XPStyleActnCtrls, ActnMan, ImgList, dxBarExtItems;



type
 TNodeParamsList=class
  List:TList;

 public
  destructor Destroy; override;
  constructor Create;
  procedure Add(NodeIndex:Integer;FilterType:TFilterType;Sheet:TcxTabSheet;
      Grid:TcxGridDBTableView;adTab:TADOQuery);
  procedure Remove(i:integer);
end;

type
  TFMain = class(TForm)
    stBar: TdxStatusBar;
    SettingsTree: TcxTreeList;
    cxSplitter1: TcxSplitter;
    STree: TcxTreeListColumn;
    stPages: TcxPageControl;
    cxTab_Accounts: TcxTabSheet;
    cxTab_General: TcxTabSheet;
    cbRun: TcxCheckBox;
    LabeledEdit1: TLabeledEdit;
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
    cxTab_Stamp: TcxTabSheet;
    dsStamp: TDataSource;
    cxStamps: TcxGridDBTableView;
    cxStampsGridLevel1: TcxGridLevel;
    cxStampsGrid: TcxGrid;
    cxStampsFValue: TcxGridDBColumn;
    cxStampsDescription: TcxGridDBColumn;
    cxStampsActive: TcxGridDBColumn;
    dxMFilters: TdxBarSubItem;
    adTest: TADOQuery;
    amAddStamp: TAction;
    cxTab_BlackWords: TcxTabSheet;
    adBlackWords: TADOQuery;
    dsBlackWords: TDataSource;
    cxBlackWords: TcxGridDBTableView;
    cxBlackWordsGridLevel1: TcxGridLevel;
    cxBlackWordsGrid: TcxGrid;
    adBlackWordsSignalFilterDescription: TWideStringField;
    adBlackWordsTypesDescription: TWideStringField;
    adBlackWordsFValue: TWideStringField;
    adBlackWordsActive: TBooleanField;
    cxBlackWordsFValue: TcxGridDBColumn;
    cxBlackWordsSignalFilterDescription: TcxGridDBColumn;
    cxBlackWordsTypesDescription: TcxGridDBColumn;
    cxBlackWordsActive: TcxGridDBColumn;
    adBlackWordsId: TAutoIncField;
    cxBlackWordsId: TcxGridDBColumn;
    cxTab_WhiteWords: TcxTabSheet;
    adWhiteWords: TADOQuery;
    dsWhiteWords: TDataSource;
    cxWhiteWordsGrid: TcxGrid;
    cxWhiteWords: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxWhiteWordsId: TcxGridDBColumn;
    cxWhiteWordsFValue: TcxGridDBColumn;
    cxWhiteWordsSignalFilterDescription: TcxGridDBColumn;
    cxWhiteWordsTypesDescription: TcxGridDBColumn;
    cxWhiteWordsActive: TcxGridDBColumn;
    amModifyWord: TAction;
    amAddWord: TAction;
    dxBarButton1: TdxBarButton;
    amModifyStamp: TAction;
    dxBarButton4: TdxBarButton;
    adStamp: TADOQuery;
    adStampFValue: TWideStringField;
    adStampDescription: TWideStringField;
    adStampActive: TBooleanField;
    adStampid: TAutoIncField;
    cxStampsId: TcxGridDBColumn;
    dxFiltersStamps: TdxBarSubItem;
    dxFiltersStampsAdd: TdxBarButton;
    dxFiltersStampsDelete: TdxBarButton;
    dxFiltersStampsEdit: TdxBarButton;
    amRemoveStamp: TAction;
    dxPopupStampEdit: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxStampsPopup: TdxBarPopupMenu;
    dxpFiltersStampsEdit: TdxBarButton;
    dxpFiltersRevomeStamp: TdxBarButton;
    dxpFiltersStampsAdd: TdxBarButton;
    amSetStampsStatusToActive: TAction;
    dxpFiltersStampSetToActive: TdxBarButton;
    dxFiltersStampsSetToActive: TdxBarButton;
    amSetStampsStatusToNonActive: TAction;
    dxpFiltersStampSetToNonActive: TdxBarButton;
    dxFiltersStampSetToNonActive: TdxBarButton;
    Button1: TButton;
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
    Button2: TButton;
    adWhiteSenders: TADOQuery;
    dsWhiteSenders: TDataSource;
    dsBlackSenders: TDataSource;
    adBlackSenders: TADOQuery;
    adWhiteSendersid: TAutoIncField;
    adWhiteSendersFValue: TWideStringField;
    adWhiteSendersDescription: TWideStringField;
    adWhiteSendersActive: TBooleanField;
    cxTab_WhiteSenders: TcxTabSheet;
    cxTab_BlackSenders: TcxTabSheet;
    cxWhiteSenders: TcxGridDBTableView;
    cxWhiteSendersGridLevel1: TcxGridLevel;
    cxWhiteSendersGrid: TcxGrid;
    cxWhiteSendersid: TcxGridDBColumn;
    cxWhiteSendersFValue: TcxGridDBColumn;
    cxWhiteSendersDescription: TcxGridDBColumn;
    cxWhiteSendersActive: TcxGridDBColumn;
    cxBlackSenders: TcxGridDBTableView;
    cxBlackSendersGridLevel1: TcxGridLevel;
    cxBlackSendersGrid: TcxGrid;
    cxBlackSendersid: TcxGridDBColumn;
    cxBlackSendersFValue: TcxGridDBColumn;
    cxBlackSendersDescription: TcxGridDBColumn;
    cxBlackSendersActive: TcxGridDBColumn;
    adBlackSendersid: TAutoIncField;
    adBlackSendersFValue: TWideStringField;
    adBlackSendersDescription: TWideStringField;
    adBlackSendersActive: TBooleanField;
    adWhiteExt: TADOQuery;
    adBlackExt: TADOQuery;
    dsWhiteExt: TDataSource;
    dsBlackExt: TDataSource;
    cxTab_WhiteExt: TcxTabSheet;
    cxTab_BlackExt: TcxTabSheet;
    cxWhiteExt: TcxGridDBTableView;
    cxWhiteExtGridLevel1: TcxGridLevel;
    cxWhiteExtGrid: TcxGrid;
    cxWhiteExtid: TcxGridDBColumn;
    cxWhiteExtFValue: TcxGridDBColumn;
    cxWhiteExtDescription: TcxGridDBColumn;
    cxWhiteExtActive: TcxGridDBColumn;
    cxBlackExt: TcxGridDBTableView;
    cxBlackExtGridLevel1: TcxGridLevel;
    cxBlackExtGrid: TcxGrid;
    cxBlackExtid: TcxGridDBColumn;
    cxBlackExtFValue: TcxGridDBColumn;
    cxBlackExtDescription: TcxGridDBColumn;
    cxBlackExtActive: TcxGridDBColumn;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    dxBarButton3: TdxBarButton;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyleRepository2: TcxStyleRepository;
    cxStyle2: TcxStyle;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure amDeleteAccountExecute(Sender: TObject);
    procedure cxTab_BlackWordsShow(Sender: TObject);
    procedure cxTab_StampShow(Sender: TObject);
    procedure cxTab_WhiteSendersShow(Sender: TObject);
    procedure cxTab_BlackSendersShow(Sender: TObject);
    procedure cxTab_WhiteExtShow(Sender: TObject);
    procedure cxTab_BlackExtShow(Sender: TObject);
    procedure SettingsTreeSelectionChanged(Sender: TObject);
  private
    Reg: TRegistry;
    NodeList:TNodeParamsList;
    Coder:TBFCoder;
    CurrNode:TcxTreeListNode;
    { Private declarations }
  public
    CurrentGrid:TcxGridDBTableView; // ссылка на текущую таблицу
    CurrentFilterType:TFilterType;  // тип текущего фильтра

 //   PSManager: TPostManager;
    WordsTable:TFilterType;
    FManager:TFilterManager;
    cxWordsGrid:TcxGridDBTableView;
    cxWordsActive:TcxGridDBColumn;
    cxWordsFValue:TcxGridDBColumn;
    cxWordsId:TcxGridDBColumn;
    cxWordSignalFilterDescription:TcxGridDBColumn;
    cxWordsTypesDescription:TcxGridDBcolumn;
    function IndexByCaption(ColumnCaption:String): Integer;
    procedure RunOnStartup(Run:boolean);

    { Public declarations }
  protected
    procedure SetCurrentParams(Grid:TcxGridDBTableView;Filter:TFilterType);
  end;

{

при смене таблицы передавать в функцию параметры
 таблица, тип фильтра

}


var
  FMain: TFMain;
  DragState:boolean=False;
implementation


{$R *.dfm}
{$R ..\Resources\WinXP.res}


function TFMain.IndexByCaption(ColumnCaption:String): Integer;
var
 i:integer;
 Flag:boolean;
begin
 Flag:=False;
 i:=0;
 while (not Flag) and (i<CurrentGrid.ColumnCount) do
   begin
    if CurrentGrid.Columns[i].Caption=ColumnCaption then
     begin
      Flag:=False;
      Result:=CurrentGrid.Columns[i].Index;
     end
      else inc(i);
   end;
 if Flag then Result:=-1; // нет колонки с таким именем
end;

procedure TFMain.RunOnStartup(Run:boolean);
begin
end;

procedure TFMain.FormCreate(Sender: TObject);
begin

 NodeList:=TNodeParamsList.Create;

// NodeList.Add(1,ftBlackEmail,cxTab_Accounts,cxBlackWords);
// Coder.Key:=CriptKey;

// FManager:=TFilterManager.Create(adCon,adBlackWords,adWhiteWords,adStamp,adWhiteSenders,adBlackSenders,adBlackExt,adWhiteExt);
end;


procedure TFMain.FormDestroy(Sender: TObject);
begin
 FManager.Free;
end;

procedure TFMain.amDeleteAccountExecute(Sender: TObject);
begin
 if Application.MessageBox('Are you are sure ?','Deleting Account',MB_OKCANCEL)=IDOK then
  begin
 //  PSManager.AccountManager.DeleteAccount( PSManager.AccountManager.AccountName2Id(cxAccounts.Controller.SelectedRecords[0].Values[cxAccountsAccountName.VisibleIndex]));
  end;
end;

procedure TFMain.cxTab_BlackWordsShow(Sender: TObject);
begin
 SetCurrentParams(cxBlackWords,ftBlackWord);
end;

procedure TFMain.cxTab_StampShow(Sender: TObject);
begin
 SetCurrentParams(cxWhiteWords,ftWhiteWord);
end;

procedure TFMain.cxTab_WhiteSendersShow(Sender: TObject);
begin
 SetCurrentParams(cxWhiteSenders,ftWhiteEmail);
end;

procedure TFMain.cxTab_BlackSendersShow(Sender: TObject);
begin
 SetCurrentParams(cxBlackSenders,ftBlackEmail);
end;

procedure TFMain.cxTab_WhiteExtShow(Sender: TObject);
begin
 SetCurrentParams(cxWhiteExt,ftWhiteAttach);
end;

procedure TFMain.cxTab_BlackExtShow(Sender: TObject);
begin
 SetCurrentParams(cxBlackExt,ftBlackAttach);
end;

procedure TFMain.SettingsTreeSelectionChanged(Sender: TObject);
var
 NodeIndex:Integer;
begin
 NodeIndex:=STree.TreeList.FocusedNode.AbsoluteIndex;
 if not DragState then
 case NodeIndex of
   0: cxTab_General.Show;
   1: cxTab_Accounts.Show;
   2: ;
   3: ;
   4: cxTab_WhiteWords.Show ;
   5: cxTab_Stamp.Show ;
   6: cxTab_WhiteExt.Show;
   7: cxTab_WhiteSenders.Show ;
   9: cxTab_BlackWords.Show ;
   10:cxTab_BlackSenders.Show;
   11:cxTab_BlackExt.Show;
 end;

end;

procedure TFMain.SetCurrentParams(Grid:TcxGridDBTableView;Filter:TFilterType);
begin
 CurrentGrid:=Grid;
 CurrentFilterType:=Filter;
end;

destructor TNodeParamsList.Destroy;
var
 i:integer;
begin
 for I:=0 to List.Count-1 do
    Remove(i);
 List.Free;
end;

constructor TNodeParamsList.Create;
begin
 List:=TList.Create;
end;

procedure TNodeParamsList.Add(NodeIndex:Integer;FilterType:TFilterType;
    Sheet:TcxTabSheet;Grid:TcxGridDBTableView;adTab:TADOQuery);
var
 buf:PNodeParams;
begin
 New(buf);
 buf.NodeIndex:=NodeIndex;
 buf.FilterType:=FilterType;
 buf.Sheet:=Sheet;
 buf.Grid:=Grid;
 buf.adTab:=adTab;
 List.Add(buf);
end;

procedure TNodeParamsList.Remove(i:integer);
var
 buf:PNodeParams;
begin
 buf:=List.Items[i];
 Dispose(buf);
 List.Items[i]:=nil;
end;

end.


{

при смене вкладки устанавливать ссылку на таблицу и тип фильтра
изменить названия типов фильров (слишком длинные и некорректные)

}
