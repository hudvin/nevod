unit main;

interface

uses Forms,Windows, Dialogs, ASFilter, Registry, dxBar, cxStyles, Shared,
  cxTL, DB, ADODB,  StdCtrls, ExtCtrls, cxContainer, cxEdit,
  cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  PostManager, SysUtils, Typinfo,

  cxGridCustomView, cxGrid, Menus,
  cxGridCustomPopupMenu, cxGridPopupMenu, Classes, Controls,
  cxGridDBTableView, cxClasses, cxControls, cxPC, cxSplitter,
  cxInplaceContainer, dxStatusBar, cxLookAndFeels, ActnList,
  XPStyleActnCtrls, ActnMan, ImgList;

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
    dxBarPopupMenu1: TdxBarPopupMenu;
    cxAccounts: TcxGridTableView;
    cxAccountsAccountName: TcxGridColumn;
    cxAccountsUsername: TcxGridColumn;
    cxAccountsPassword: TcxGridColumn;
    cxAccountsServer: TcxGridColumn;
    cxAccountsPort: TcxGridColumn;
    cxAccountsTimeout: TcxGridColumn;
    cxAccountsStatus: TcxGridColumn;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    aMan: TActionManager;
    amAddAccount: TAction;
    amDeleteAccount: TAction;
    dxAccountsPopup: TdxBarPopupMenu;
    pbAddAccount: TdxBarButton;
    dxBarButton15: TdxBarButton;
    cxTab_Stamp: TcxTabSheet;
    adStamp: TADOTable;
    dsStamp: TDataSource;
    adStampFValue: TWideStringField;
    adStampDescription: TWideStringField;
    adStampActive: TBooleanField;
    cxStamps: TcxGridDBTableView;
    cxStampsGridLevel1: TcxGridLevel;
    cxStampsGrid: TcxGrid;
    cxStampsFValue: TcxGridDBColumn;
    cxStampsDescription: TcxGridDBColumn;
    cxStampsActive: TcxGridDBColumn;
    dxBarSubItem2: TdxBarSubItem;
    adTest: TADOQuery;
    amAddStamp: TAction;
    dxStampsPopup: TdxBarPopupMenu;
    dxBarButton22: TdxBarButton;
    adDeleteStamp: TAction;
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
    dxWhiteWordsPopup: TdxBarPopupMenu;
    dxBlackWordsPopup: TdxBarPopupMenu;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    Action1: TAction;
    dxBarButton4: TdxBarButton;
    procedure cbRunPropertiesChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure amAddAccountExecute(Sender: TObject);
    procedure dxAccountsPopupPopup(Sender: TObject);
    procedure dxBarButton11Click(Sender: TObject);
    procedure amDeleteAccountExecute(Sender: TObject);
    procedure amAddStampExecute(Sender: TObject);
    procedure adDeleteStampExecute(Sender: TObject);
    procedure SettingsTreeFocusedNodeChanged(Sender: TObject;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure cxBlackWordsDblClick(Sender: TObject);
    procedure amAddWordExecute(Sender: TObject);
    procedure dxWhiteWordsPopupPopup(Sender: TObject);
    procedure dxBlackWordsPopupPopup(Sender: TObject);
    procedure amModifyWordExecute(Sender: TObject);
  private
    Reg: TRegistry;
    Coder:TBFCoder;

    { Private declarations }
  public
    PSManager: TPostManager;
    procedure RunOnStartup(Run:boolean);
    { Public declarations }
  protected
  end;


var
  FMain: TFMain;
implementation

uses AddAccount, ModifyAccount, AddStamp, ModifyWord;

{$R *.dfm}
{$R ..\Resources\WinXP.res}


procedure TFMain.cbRunPropertiesChange(Sender: TObject);
begin
 if cbRun.Checked then
   RunOnStartup(True)
  else RunOnStartup(False);
end;


procedure TFMain.RunOnStartup(Run:boolean);
begin
 with Reg do
  begin
   RootKey:=HKEY_LOCAL_MACHINE;
   OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',False);
   if Run then
     WriteString('NevodAntiSpam',Application.ExeName)
    else DeleteValue('NevodAntiSpam');
     CloseKey;
   end;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
 with Reg do
  begin
   RootKey:=HKEY_LOCAL_MACHINE;
   OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',False);
   if Reg.ValueExists('NevodAntispam') then
    cbRun.Checked:=True
     else cbRun.Checked:=False;
   end;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
 Reg:=TRegistry.Create;
 Coder:=TBFCoder.Create;
 Coder.Key:=CriptKey;
 PSManager:=TPostManager.Create(adCon,cxAccounts);
end;


procedure TFMain.FormDestroy(Sender: TObject);
begin
 Coder.Free;
 Reg.Free;
 PSManager.Free;
end;

procedure TFMain.amAddAccountExecute(Sender: TObject);
begin
 ShowMessage(IntToStr(cxAccounts.Controller.SelectedRowCount));
  FAddAccount.ShowModal;
end;

procedure TFMain.dxAccountsPopupPopup(Sender: TObject);
begin
 if cxAccounts.Controller.SelectedRowCount=0 then
  begin
  //  pbAddAccount.Enabled:=False;

  end;
end;

procedure TFMain.dxBarButton11Click(Sender: TObject);
begin
 FModifyAccount.ShowModal;
end;

procedure TFMain.amDeleteAccountExecute(Sender: TObject);
begin
 // удаление учетной записи
 if Application.MessageBox('Are you are sure ?','Deleting Account',MB_OKCANCEL)=IDOK then
  begin
   PSManager.AccountManager.DeleteAccount( PSManager.AccountManager.AccountName2Id(cxAccounts.Controller.SelectedRecords[0].Values[cxAccountsAccountName.VisibleIndex]));
  end;
end;

procedure TFMain.amAddStampExecute(Sender: TObject);
begin
 FAddStamp.ShowModal;
end;

procedure TFMain.adDeleteStampExecute(Sender: TObject);
begin
  // удаление штампа
 if Application.MessageBox('Are you are sure ?','Deleting Stamp',MB_OKCANCEL)=IDOK then
  begin
   cxStamps.Controller.DeleteSelection;
  end;
end;

procedure TFMain.SettingsTreeFocusedNodeChanged(Sender: TObject;
  APrevFocusedNode, AFocusedNode: TcxTreeListNode);
var
 Node:String;
begin
 Node:= STree.TreeList.FocusedNode.Texts[0];
 case TNodeGroup(GetEnumValue(TypeInfo(TNodeGroup),'nd'+Node)) of
   ndGeneral:
    begin
     Caption:='General' ;
     cxTab_General.Show;
    end;
   ndAccounts:
    begin
     Caption:='Accounts' ;
     cxTab_Accounts.Show;
    end;
   ndStamps:
    begin
     Caption:='Stamps' ;
     cxTab_Stamp.Show;
    end;
 end;
end;

procedure TFMain.cxBlackWordsDblClick(Sender: TObject);
begin
// FModifyWord.ShowModal;
end;

procedure TFMain.amAddWordExecute(Sender: TObject);
begin
 {

 взять данные из текущей строки
 заполнить поля в форме
 для модификации использовать id в таблице
 показать модальную форму

 
 поддержка переноса (Drag&Drop) ! (для аналогичной таблицы)
 }
end;

procedure TFMain.dxWhiteWordsPopupPopup(Sender: TObject);
begin
 with FModifyWord do
  if Grid<>cxWhiteWords then
   begin
    adWords:=adWhiteWords;
    Grid:=cxWhiteWords;
    cxWordsActive:=cxWhiteWordsActive;
    cxWordsFValue:=cxWhiteWordsFValue;
    cxWordsId:=cxWhiteWordsId;
    cxWordSignalFilterDescription:=cxWhiteWordsSignalFilterDescription;
    cxWordsTypesDescription:=cxWhiteWordsTypesDescription;
   end;
end;

procedure TFMain.dxBlackWordsPopupPopup(Sender: TObject);
begin
 with FModifyWord do
    if Grid<>cxBlackWords then
     begin
      adWords:=adBlackWords;
      Grid:=cxBlackWords;
      cxWordsActive:=cxBlackWordsActive;
      cxWordsFValue:=cxBlackWordsFValue;
      cxWordsId:=cxBlackWordsId;
      cxWordSignalFilterDescription:=cxBlackWordsSignalFilterDescription;
      cxWordsTypesDescription:=cxBlackWordsTypesDescription;
     end;
end;

procedure TFMain.amModifyWordExecute(Sender: TObject);
begin
 FModifyWord.ShowModal;
end;

end.

{


редактирование либо прямо в таблице
 либо в отдельной форме !!!
 два метода не использовать - возможна путаница


запускать в свернутом виде !
при минимизации - в трей
базу хранить в каталоге пользователя (Documents and Settings)
создать класс TAccountManager и через него получать список учетныЯ записей
при минимизировании - сворачивать в трей
проигрывание музыки при системных событиях хранить в минутах (тольк целые числа !!!) !!!
слова для cbLocation грузить из базы данных

}
