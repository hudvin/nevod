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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure amDeleteAccountExecute(Sender: TObject);
    procedure SettingsTreeSelectionChanged(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    NodeList:TNodeParamsList;
    CurrNode:TcxTreeListNode;
    { Private declarations }
  public
    CurrentFilterType:TFilterType;  // тип текущего фильтра

 //   PSManager: TPostManager;
    FManager:TFilterManager;
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

procedure TFMain.SettingsTreeSelectionChanged(Sender: TObject);
var
 NodeIndex:Integer;
begin
 NodeIndex:=STree.TreeList.FocusedNode.AbsoluteIndex;
{ if not DragState then
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
}
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

procedure TFMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
 ShowMessage('');
end;

end.


{

при смене вкладки устанавливать ссылку на таблицу и тип фильтра
изменить названия типов фильров (слишком длинные и некорректные)

}
