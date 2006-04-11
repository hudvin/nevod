unit main;

interface

uses Forms,Windows, Dialogs, ASFilter, Registry, dxBar, cxStyles, Shared,
  cxTL, DB, ADODB,  StdCtrls, ExtCtrls, cxContainer, cxEdit,
  cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  PostManager, SysUtils, Typinfo, FilterManager,

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
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    aMan: TActionManager;
    amAddAccount: TAction;
    amDeleteAccount: TAction;
    dxAccountsPopup: TdxBarPopupMenu;
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
    dxWhiteWordsPopup: TdxBarPopupMenu;
    dxBlackWordsPopup: TdxBarPopupMenu;
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
    procedure dxWhiteWordsPopupPopup(Sender: TObject);
    procedure dxBlackWordsPopupPopup(Sender: TObject);
    procedure amModifyWordExecute(Sender: TObject);
    procedure amModifyStampExecute(Sender: TObject);
    procedure amRemoveStampExecute(Sender: TObject);
    procedure amSetStampsStatusToActiveExecute(Sender: TObject);
    procedure amSetStampsStatusToNonActiveExecute(Sender: TObject);
    procedure dxStampsPopupPopup(Sender: TObject);
    procedure dxFiltersStampsPopup(Sender: TObject);
  private
    Reg: TRegistry;
    Coder:TBFCoder;

    { Private declarations }
  public
    PSManager: TPostManager;
    FManager:TFilterManager;
    procedure RunOnStartup(Run:boolean);
    { Public declarations }
  protected
  end;


var
  FMain: TFMain;
implementation

uses AddAccount, ModifyAccount, AddStamp, ModifyWord, ModifyStamp;

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
 FManager:=TFilterManager.Create(adCon,adBlackWords,adWhiteWords,adStamp);
end;


procedure TFMain.FormDestroy(Sender: TObject);
begin
 Coder.Free;
 Reg.Free;
 PSManager.Free;
 FManager.Free;
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
 // �������� ������� ������
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
  // �������� ������
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

procedure TFMain.amModifyStampExecute(Sender: TObject);
begin
 FModifyStamp.ShowModal;
end;

procedure TFMain.amRemoveStampExecute(Sender: TObject);
begin
 if Application.MessageBox('Are you are sure ?','Deleting Stamp',MB_OKCANCEL)=IDOK then
  begin
   cxStamps.Controller.DeleteSelection;
  end;
end;

procedure TFMain.amSetStampsStatusToActiveExecute(Sender: TObject);
var
  I: Integer;
  Elem:array of integer;
begin
 SetLength(Elem,cxStamps.Controller.SelectedRowCount);
 for I := 0 to cxStamps.Controller.SelectedRowCount-1 do
   Elem[i]:=cxStamps.Controller.SelectedRows[i].Values[cxStampsId.Index];
 FManager.SetStampStatus(Elem,True);
end;

procedure TFMain.amSetStampsStatusToNonActiveExecute(Sender: TObject);
var
  I: Integer;
  Elem:array of integer;
begin
 SetLength(Elem,cxStamps.Controller.SelectedRowCount);
 for I := 0 to cxStamps.Controller.SelectedRowCount-1 do
   Elem[i]:=cxStamps.Controller.SelectedRows[i].Values[cxStampsId.Index];
 FManager.SetStampStatus(Elem,False);

end;

procedure TFMain.dxStampsPopupPopup(Sender: TObject);
var
 SAct,SNonAct:boolean;
 i:integer;
begin
 SAct:=False;
 SNonAct:=False;
 if cxStamps.Controller.SelectedRowCount>0 then // ���� ���� ���������� ������
  begin
   dxpFiltersRevomeStamp.Enabled:=True;
   dxpFiltersStampsEdit.Enabled:=True;
   i:=0;
   while (i<cxStamps.Controller.SelectedRowCount) and (not SAct) do
    if not cxStamps.Controller.SelectedRows[i].Values[cxStampsActive.Index]  // ���� �� �������
     then  SAct:=True else inc(i);
   i:=0;
   while (i<cxStamps.Controller.SelectedRowCount) and (not SNonAct) do
    if  cxStamps.Controller.SelectedRows[i].Values[cxStampsActive.Index]  // ���� �� �������
     then  SNonAct:=True else inc(i);

   if SAct then dxpFiltersStampSetToActive.Enabled:=True
    else  dxpFiltersStampSetToActive.Enabled:=False;
   if SNonAct then dxpFiltersStampSetToNonActive.Enabled:=True
    else  dxpFiltersStampSetToNonActive.Enabled:=False;
  end
   else
    begin
     dxpFiltersRevomeStamp.Enabled:=False;
     dxpFiltersStampsEdit.Enabled:=False;
     dxpFiltersStampsEdit.Enabled:=False;
     dxpFiltersStampSetToActive.Enabled:=False;
     dxpFiltersStampSetToNonActive.Enabled:=False;
    end;
end;

procedure TFMain.dxFiltersStampsPopup(Sender: TObject);
var
 SAct,SNonAct:boolean;
 i:integer;
begin
 SAct:=False;
 SNonAct:=False;
 if cxStamps.Controller.SelectedRowCount>0 then // ���� ���� ���������� ������
  begin
   i:=0;
   dxFiltersStampsEdit.Enabled:=True;
   dxFiltersStampsDelete.Enabled:=True;
   while (i<cxStamps.Controller.SelectedRowCount) and (not SAct) do
    if not cxStamps.Controller.SelectedRows[i].Values[cxStampsActive.Index]  // ���� �� �������
     then  SAct:=True else inc(i);
   i:=0;
   while (i<cxStamps.Controller.SelectedRowCount) and (not SNonAct) do
    if  cxStamps.Controller.SelectedRows[i].Values[cxStampsActive.Index]  // ���� �� �������
     then  SNonAct:=True else inc(i);

   if SAct then dxFiltersStampsSetToActive.Enabled:=True
    else  dxFiltersStampsSetToActive.Enabled:=False;
   if SNonAct then dxFiltersStampSetToNonActive.Enabled:=True
    else  dxFiltersStampSetToNonActive.Enabled:=False;
  end
   else
    begin
     dxFiltersStampsEdit.Enabled:=False;
     dxFiltersStampsDelete.Enabled:=False;
     dxFiltersStampsSetToActive.Enabled:=False;
     dxFiltersStampSetToNonActive.Enabled:=False;
    end;
end;

end.

