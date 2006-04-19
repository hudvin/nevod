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
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure amDeleteAccountExecute(Sender: TObject);
    procedure SettingsTreeSelectionChanged(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    NodeList:TNodeParamsList;
    CurrNode:TcxTreeListNode;
    { Private declarations }
  public
    CurrentFilterType:TFilterType;  // тип текущего фильтра
    SNConverter:TSNIndexConverter;
 //   PSManager: TPostManager;
    FManager:TFilterManager;
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

uses CustomEditor;


{$R *.dfm}
{$R ..\Resources\WinXP.res}



procedure TFMain.RunOnStartup(Run:boolean);
begin
end;

procedure TFMain.FormCreate(Sender: TObject);
begin

 SNConverter:=TSNIndexConverter.Create;
 with SNConverter do
   begin
    Add(6,0,ftWhiteSender,'Добавить адрес/домен в белый список'); //адрес в белый список
    Add(9,1,ftBlackSender,'Добавить адрес/домен в черный списко'); //адрес в черный список
    Add(7,2,ftWhiteAttach,'Добавить расширений приложенного файла в белый список'); // расширение в белый список
    Add(11,3,ftBlackAttach,'Добавить расширений приложенного файла в черный список');// расширение в черный список
    Add(4,4,ftWhiteWord,'Добавить слово в белый список'); // слово в белый список
    Add(9,5,ftBlackWord,'Добавить слово в черный список'); // слово в черный список
    Add(5,6,ftStamp,'Добавить штамп'); // штамп
   end;










// NodeList.Add(1,ftBlackEmail,cxTab_Accounts,cxBlackWords);
// Coder.Key:=CriptKey;

// FManager:=TFilterManager.Create(adCon,adBlackWords,adWhiteWords,adStamp,adWhiteSenders,adBlackSenders,adBlackExt,adWhiteExt);
end;


procedure TFMain.FormDestroy(Sender: TObject);
begin
 //FManager.Free;
 SNConverter.Free;
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
begin
 NodeIndex:=STree.TreeList.FocusedNode.AbsoluteIndex;
 // устанавливать текущий тип фильтра или ftNone
 case NodeIndex of    //
   0: ;
   1: cxTab_Accounts.Show ;
   2: ;
   3: ;
   4..7,9..11:
    begin
     case NodeIndex of
       4: FilterType:=ftWhiteWord;
       5: FilterType:=ftStamp;
       6: FilterType:=ftWhiteSender;
       7: FilterType:=ftWhiteAttach;
       9: FilterType:=ftBlackWord;
       10:FilterType:=ftBlackSender;
       11:FilterType:=ftBlackAttach;
     end;
     with adFilters do
       begin
        Active:=False;
        if FilterType in[ftWhiteWord,ftBlackWord] then
         cxFiltersParams.Visible:=True
          else
           cxFiltersParams.Visible:=False;
        SQL.Text:='SELECT id,FValue,Description,Active,Params '+
                  ' FROM FiltersParams WHERE mid=(SELECT id FROM Filters WHERE Type=:FilterType) ' ;
        Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
        Active:=True;
       end;

    end;
   8:;
   12:;
 end;
end;

procedure TFMain.SetCurrentParams(Grid:TcxGridDBTableView;Filter:TFilterType);
begin
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

procedure TFMain.Button1Click(Sender: TObject);
begin
 FCustomEditor.Show(1);
end;

end.
