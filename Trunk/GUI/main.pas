unit main;

interface

uses  Commctrl,tlhelp32, StdCtrls, Dialogs, ImgList, Controls, dxBar,  Math,
  ExtCtrls, dxBarExtItems, Classes, ActnList, CoolTrayIcon, DB, ADODB,
  cxMemo, cxButtonEdit, cxTextEdit, cxMaskEdit, cxSpinEdit, cxCheckBox,
  cxContainer, cxEdit, cxGroupBox, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxControls,
  cxGridCustomView, cxGrid, cxPC, cxSplitter, cxInplaceContainer, cxTL,
  dxStatusBar ,  Forms,Windows,IdContext, Registry,  cxStyles, Shared,
  WinSock,  IdGlobalProtocols,  ShellAPI, PortEditor,
  SysUtils, Typinfo, FilterManager, AccountManager,  AccountEditor,  Graphics,

    Menus,   Messages, ThreadManager, POPServer,
  cxGridCustomPopupMenu, cxGridPopupMenu, aspr_api,
   cxLookAndFeels,FilterEditor,  Register,
  XPStyleActnCtrls, ActnMan,  Clipbrd, PerlRegEx,
   ToolWin, ActnCtrls, ActnColorMaps,
  ActnPopupCtrl,  cxRichEdit,  gnugettext,
  cxButtons, cxDropDownEdit,  ComCtrls, JvHotKey, JvComponent,
  JvAppHotKey,    RegistrationKey, About,
    IdBaseComponent, IdComponent, IdCustomTCPServer, IdEchoServer,
  IdIPWatch, JvComponentBase, JvExComCtrls;


type
  TCopyDataStruct = packed record
    dwData: DWORD;
    cbData: DWORD;
    lpData: Pointer;
  end;
  
type
  TFMain = class(TForm)
    stBar: TdxStatusBar;
    SettingsTree: TcxTreeList;
    STree: TcxTreeListColumn;
    stPages: TcxPageControl;
    cxTab_Accounts: TcxTabSheet;
    cxAccountsGrid: TcxGrid;
    dsAccounts: TDataSource;
    adCon: TADOConnection;
    dsLog: TDataSource;
    adLog: TADOQuery;
    cxTab_Log: TcxTabSheet;
    cxLog: TcxGridDBTableView;
    cxLogGridLevel1: TcxGridLevel;
    cxLogGrid: TcxGrid;
    cxLogAccountName: TcxGridDBColumn;
    cxLogErrorType: TcxGridDBColumn;
    cxLogMessage: TcxGridDBColumn;
    cxLogErrorTime: TcxGridDBColumn;
    cxLogId: TcxGridDBColumn;
    cxTab_Filters: TcxTabSheet;
    cxFilters: TcxGridDBTableView;
    cxFiltersGridLevel1: TcxGridLevel;
    cxFiltersGrid: TcxGrid;
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
    cxTab_Settings: TcxTabSheet;
    adAccounts: TADOQuery;
    adAccountsid: TAutoIncField;
    adAccountsAccountName: TWideStringField;
    adAccountsusername: TWideStringField;
    adAccountspass: TWideStringField;
    adAccountshost: TWideStringField;
    adAccountsport: TIntegerField;
    adAccountsTimeout: TIntegerField;
    adAccountsstatus: TWideStringField;
    cxAccounts: TcxGridDBTableView;
    cxAccountsGridLevel1: TcxGridLevel;
    cxAccountsid: TcxGridDBColumn;
    cxAccountsAccountName: TcxGridDBColumn;
    cxAccountsusername: TcxGridDBColumn;
    cxAccountspass: TcxGridDBColumn;
    cxAccountshost: TcxGridDBColumn;
    cxAccountsport: TcxGridDBColumn;
    cxAccountsTimeout: TcxGridDBColumn;
    cxAccountsstatus: TcxGridDBColumn;
    tray: TCoolTrayIcon;
    AList: TActionList;
    alAddAccount: TAction;
    dxBar: TdxBarManager;
    msAccounts: TdxBarSubItem;
    msAddAccount: TdxBarButton;
    msEditAccount: TdxBarButton;
    msDeleteAccount: TdxBarButton;
    msAppExit: TdxBarButton;
    alEditAccount: TAction;
    alDeleteAccount: TAction;
    alAppTerminate: TAction;
    alStopThread: TAction;
    msStopThread: TdxBarButton;
    alStartThread: TAction;
    msStartThread: TdxBarButton;
    alStartAllThreads: TAction;
    msStartAllThreads: TdxBarButton;
    alStopAllThreads: TAction;
    msStopAllThreads: TdxBarButton;
    msCanCheckAccounts: TdxBarButton;
    alCanCheckAccounts: TAction;
    pAccounts: TdxBarPopupMenu;
    alOnAccountsPopUp: TAction;
    pmAddAccount: TdxBarButton;
    pmDeleteAccount: TdxBarButton;
    pmStopThread: TdxBarButton;
    pmEditAccount: TdxBarButton;
    pmStartThread: TdxBarButton;
    pmStartAllThreads: TdxBarButton;
    pmStopAllThreads: TdxBarButton;
    pmCheckAccounts: TdxBarButton;
    cxTab_AFSettings: TcxTabSheet;
    cxTab_DFSettings: TcxTabSheet;
    cxWhiteWordDescription: TcxMemo;
    cbStamp: TcxCheckBox;
    cbWhiteWord: TcxCheckBox;
    cxStampDescription: TcxMemo;
    cbWhiteSender: TcxCheckBox;
    cxSenderDescription: TcxMemo;
    cbWhiteAttach: TcxCheckBox;
    cxWhiteAttachDescription: TcxMemo;
    cbBlackWord: TcxCheckBox;
    cxBlackWordDescription: TcxMemo;
    cbBlackSender: TcxCheckBox;
    cxBlackSenderDescription: TcxMemo;
    cbBlackAttach: TcxCheckBox;
    cxBlackAttachDescription: TcxMemo;
    cxSpinLinks: TcxSpinEdit;
    cbMaxLinks: TcxCheckBox;
    cxMaxLinksDescription: TcxMemo;
    cbMaxImages: TcxCheckBox;
    cxSpinImages: TcxSpinEdit;
    cxMaxImagesDescription: TcxMemo;
    cbMaxSize: TcxCheckBox;
    cxSpinMaxSize: TcxSpinEdit;
    cxMaxSizeDescription: TcxMemo;
    msFilters: TdxBarSubItem;
    alAddFilterElement: TAction;
    msAddFilterElement: TdxBarButton;
    alRemoveFilterElement: TAction;
    msRemoveFiltersElement: TdxBarButton;
    alOnFiltersPopUp: TAction;
    alEditFilterElement: TAction;
    msEditFilterElement: TdxBarButton;
    pFilters: TdxBarPopupMenu;
    pmEditFilterElement: TdxBarButton;
    pmAddFilterElement: TdxBarButton;
    pmRemoveFilterElement: TdxBarButton;
    btAddAccount: TdxBarLargeButton;
    gbSystem: TcxGroupBox;
    lbServerPort: TLabeledEdit;
    cbRunAtStartUp: TcxCheckBox;
    leInterval: TLabel;
    gbNag: TcxGroupBox;
    cbBallonOnReceive: TcxCheckBox;
    beSoundOnNew: TcxButtonEdit;
    cbSoundOnReceive: TcxCheckBox;
    cbBaloonOnError: TcxCheckBox;
    cbSoundOnError: TcxCheckBox;
    beSoundOnError: TcxButtonEdit;
    cbCheckIfNotConnected: TcxCheckBox;
    seCheckInterval: TcxSpinEdit;
    lbCheckInterval: TLabel;
    cbCanCheckAccounts: TcxCheckBox;
    cbEnableFiltering: TcxCheckBox;
    selSound: TOpenDialog;
    alClearLog: TAction;
    alDeleteSelectedLog: TAction;
    alSaveLog: TAction;
    sdLog: TSaveDialog;
    pLog: TdxBarPopupMenu;
    pmClearLog: TdxBarButton;
    pmDeleteSelectedLog: TdxBarButton;
    pmSaveLogToFile: TdxBarButton;
    alOnLogPopUp: TAction;
    msLogs: TdxBarSubItem;
    msClearLog: TdxBarButton;
    msSaveLog: TdxBarButton;
    msDeleteSelectedLog: TdxBarButton;
    gbSpy: TcxGroupBox;
    cbActivateClbSpy: TcxCheckBox;
    leSpyFor: TLabel;
    cmSpyFor: TcxComboBox;
    lbAddTo: TLabel;
    cmAddTo: TcxComboBox;
    cbShowEditor: TcxCheckBox;
    cbSoundOnAdd: TcxCheckBox;
    beSoundOnAdd: TcxButtonEdit;
    pTray: TdxBarPopupMenu;
    ptStartAllThreads: TdxBarButton;
    ptAppTerminate: TdxBarButton;
    JvAppAddHotKey: TJvApplicationHotKey;
    gbHotKeys: TcxGroupBox;
    leAddHotKey: TLabel;
    JvAddHotKey: TJvHotKey;
    alHideToTray: TAction;
    msHideToTray: TdxBarButton;
    alSetToActive: TAction;
    alSetSelectedFiltersToActive: TAction;
    alSetSelectedFiltersToNonActive: TAction;
    pmSetToActive: TdxBarButton;
    pmSetToNonActive: TdxBarButton;
    msSetToActive: TdxBarButton;
    msSetToNonActive: TdxBarButton;
    alRunMailClient: TAction;
    ptRunMailClient: TdxBarButton;
    msRunMailClient: TdxBarButton;
    btAddHotKey: TButton;
    alMoveSelectedFiltersElements: TAction;
    pmMoveSelectedFiltersElements: TdxBarButton;
    msMoveSelectedFiltersEsements: TdxBarButton;
    msTools: TdxBarSubItem;
    msRestoreFromBackUp: TdxBarButton;
    msSaveToBackUp: TdxBarButton;
    alRestoreFromBackUp: TAction;
    alSaveToBackUp: TAction;
    msHelp: TdxBarSubItem;
    leShowMainWindow: TLabel;
    jvShowMainWindow: TJvHotKey;
    JvCheckAllAccounts: TJvHotKey;
    JvRunMailClient: TJvHotKey;
    JvAppShowMainWindow: TJvApplicationHotKey;
    JvAppCheckAllAccounts: TJvApplicationHotKey;
    jvAppRunMailClient: TJvApplicationHotKey;
    btShowMainWindow: TButton;
    leCheckAllAccounts: TLabel;
    btCheckAllAccounts: TButton;
    leRunMailClient: TLabel;
    btRunMailClient: TButton;
    msEnableFiltering: TdxBarButton;
    alEnableFiltering: TAction;
    ptEnableFiltering: TdxBarButton;
    ptAddFilterElement: TdxBarButton;
    alShowAbout: TAction;
    msShowAbout: TdxBarButton;
    alCheckForUpdates: TAction;
    alGotoNevilon: TAction;
    alBuyNow: TAction;
    msCheckForUpdates: TdxBarButton;
    msBuyNow: TdxBarButton;
    msGotoNevilon: TdxBarButton;
    ptAbout: TdxBarButton;
    pGotoNevilon: TdxBarButton;
    alRunAtStartUp: TAction;
    msRunAtStartUp: TdxBarButton;
    pRunAtStartUp: TdxBarButton;
    pCanCheckAccounts: TdxBarButton;
    alEnableClbSpy: TAction;
    msEnableClbSpy: TdxBarButton;
    pEnableClbSpy: TdxBarButton;
    alShowEditorForm: TAction;
    msShowSpyEditor: TdxBarButton;
    pShowSpyEditor: TdxBarButton;
    alShowMainWindow: TAction;
    pShowMain: TdxBarButton;
    cxSplitter1: TcxSplitter;
    alRegister: TAction;
    msRegister: TdxBarButton;
    gbSounds: TcxGroupBox;
    trImages: TImageList;
    dxCheckAllAccounts: TdxBarButton;
    dxRunMailClient: TdxBarButton;
    dxAddRule: TdxBarButton;
    adLogId: TAutoIncField;
    adLogAccountName: TWideStringField;
    adLogErrorType: TWideStringField;
    adLogMessage: TMemoField;
    adLogErrorTime: TDateTimeField;
    cxStyles: TcxStyleRepository;
    cxGrid: TcxStyle;
    cxStyle1: TcxStyle;
    ptStopAllThreads: TdxBarButton;
    msShowHelp: TdxBarButton;
    alShowHelp: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SettingsTreeSelectionChanged(Sender: TObject);
    procedure adFiltersParamsGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure SettingsTreeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure cxFiltersEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure cxFiltersStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure SettingsTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure adAccountspassGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure adAccountsTimeoutGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure adAccountsstatusGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure trayClick(Sender: TObject);
    procedure alAddAccountExecute(Sender: TObject);
    procedure msAccountsPopup(Sender: TObject);
    procedure alEditAccountExecute(Sender: TObject);
    procedure alDeleteAccountExecute(Sender: TObject);
    procedure alAppTerminateExecute(Sender: TObject);
    procedure alStopThreadExecute(Sender: TObject);
    procedure alStartThreadExecute(Sender: TObject);
    procedure alStartAllThreadsExecute(Sender: TObject);
    procedure alStopAllThreadsExecute(Sender: TObject);
    procedure alCanCheckAccountsExecute(Sender: TObject);
    procedure alOnAccountsPopUpExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbWhiteWordPropertiesChange(Sender: TObject);
    procedure cbStampPropertiesChange(Sender: TObject);
    procedure cbWhiteSenderPropertiesChange(Sender: TObject);
    procedure cbWhiteAttachPropertiesChange(Sender: TObject);
    procedure cbBlackWordPropertiesChange(Sender: TObject);
    procedure cbBlackSenderPropertiesChange(Sender: TObject);
    procedure cbBlackAttachPropertiesChange(Sender: TObject);
    procedure cbMaxLinksPropertiesChange(Sender: TObject);
    procedure cbMaxImagesPropertiesChange(Sender: TObject);
    procedure cbMaxSizePropertiesChange(Sender: TObject);
    procedure cxSpinLinksExit(Sender: TObject);
    procedure cxSpinImagesExit(Sender: TObject);
    procedure cxSpinMaxSizeExit(Sender: TObject);
    procedure cxSpinLinksPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure cxSpinImagesPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure cxSpinSpamWordsPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure cxSpinMaxSizePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure alAddFilterElementExecute(Sender: TObject);
    procedure alRemoveFilterElementExecute(Sender: TObject);
    procedure alOnFiltersPopUpExecute(Sender: TObject);
    procedure alEditFilterElementExecute(Sender: TObject);
    procedure cxAccountsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxFiltersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbServerPortKeyPress(Sender: TObject; var Key: Char);
    procedure seCheckIntervalPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure seCheckIntervalExit(Sender: TObject);
    procedure cbCheckIfNotConnectedPropertiesChange(Sender: TObject);
    procedure cbEnableFilteringPropertiesChange(Sender: TObject);
    procedure cbBallonOnReceivePropertiesChange(Sender: TObject);
    procedure cbBaloonOnErrorPropertiesChange(Sender: TObject);
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure beSoundOnErrorPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cbSoundOnReceivePropertiesChange(Sender: TObject);
    procedure cbSoundOnErrorPropertiesChange(Sender: TObject);
    procedure alClearLogExecute(Sender: TObject);
    procedure alDeleteSelectedLogExecute(Sender: TObject);
    procedure alSaveLogExecute(Sender: TObject);
    procedure alOnLogPopUpExecute(Sender: TObject);
    procedure cbActivateClbSpyPropertiesChange(Sender: TObject);
    procedure cmSpyForPropertiesChange(Sender: TObject);
    procedure cmAddToPropertiesChange(Sender: TObject);
    procedure cbSoundOnAddPropertiesChange(Sender: TObject);
    procedure beSoundOnAddPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxAccountsDblClick(Sender: TObject);
    procedure trayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure JvAppAddHotKeyHotKey(Sender: TObject);
    procedure JvAddHotKeyEnter(Sender: TObject);
    procedure JvAppAddHotKeyHotKeyRegisterFailed(Sender: TObject;
      var HotKey: TShortCut);
    procedure alHideToTrayExecute(Sender: TObject);
    procedure cxFiltersDblClick(Sender: TObject);
    procedure alSetSelectedFiltersToActiveExecute(Sender: TObject);
    procedure alSetSelectedFiltersToNonActiveExecute(Sender: TObject);
    procedure alRunMailClientExecute(Sender: TObject);
    procedure btAddHotKeyClick(Sender: TObject);
    procedure alMoveSelectedFiltersElementsExecute(Sender: TObject);
    procedure alRestoreFromBackUpExecute(Sender: TObject);
    procedure alSaveToBackUpExecute(Sender: TObject);
    procedure btShowMainWindowClick(Sender: TObject);
    procedure btCheckAllAccountsClick(Sender: TObject);
    procedure btRunMailClientClick(Sender: TObject);
    procedure JvAppShowMainWindowHotKey(Sender: TObject);
    procedure JvAppCheckAllAccountsHotKey(Sender: TObject);
    procedure jvAppRunMailClientHotKey(Sender: TObject);
    procedure JvAppShowMainWindowHotKeyRegisterFailed(Sender: TObject;
      var HotKey: TShortCut);
    procedure JvAppCheckAllAccountsHotKeyRegisterFailed(Sender: TObject;
      var HotKey: TShortCut);
    procedure jvAppRunMailClientHotKeyRegisterFailed(Sender: TObject;
      var HotKey: TShortCut);
    procedure jvShowMainWindowEnter(Sender: TObject);
    procedure JvCheckAllAccountsEnter(Sender: TObject);
    procedure JvRunMailClientEnter(Sender: TObject);
    procedure alEnableFilteringExecute(Sender: TObject);
    procedure alShowAboutExecute(Sender: TObject);
    procedure alCheckForUpdatesExecute(Sender: TObject);
    procedure alGotoNevilonExecute(Sender: TObject);
    procedure alBuyNowExecute(Sender: TObject);
    procedure alRunAtStartUpExecute(Sender: TObject);
    procedure alEnableClbSpyExecute(Sender: TObject);
    procedure alShowEditorFormExecute(Sender: TObject);
    procedure alShowMainWindowExecute(Sender: TObject);
    procedure alRegisterExecute(Sender: TObject);
    procedure JvAddHotKeyExit(Sender: TObject);
    procedure jvShowMainWindowExit(Sender: TObject);
    procedure JvCheckAllAccountsExit(Sender: TObject);
    procedure JvRunMailClientExit(Sender: TObject);
    procedure lbServerPortChange(Sender: TObject);
    procedure beSoundOnNewPropertiesChange(Sender: TObject);
    procedure beSoundOnErrorPropertiesChange(Sender: TObject);
    procedure beSoundOnAddPropertiesChange(Sender: TObject);
    procedure cxLogKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure alShowHelpExecute(Sender: TObject);
  private
    adProc: TADOQuery;
    LastHooked:String;  // �������� ��������� ����������� �� ������ �������
    PrevHwnd: Hwnd;
    Exp:TPerlRegEx;
    function GetFilterState(FilterType:TFilterType): Boolean;
    procedure WMChangeCBChain(var Msg: TWMChangeCBChain);
     message WM_CHANGECBCHAIN;
    procedure WMDrawClipboard(var Msg: TWMDrawClipboard);
    message WM_DRAWCLIPBOARD;
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure WMShowRegistrationForm(var Msg: TMessage); message WM_ShowRegistrationForm;
    procedure UMActivate( var msg: TMessage ); message UM_ACTIVATE;
    procedure UpdateLog(var Msg: TMessage); message WM_UpdateLog;
    procedure UpdateAccountStatus(var Msg: TMessage); message WM_UpdateAccountStatus;
    procedure UpdateFilters(var Msg: TMessage); message WM_UpdateFilters;
    procedure ActivateWindow(var Msg:TMessage);message WM_ActivateWindow;
    procedure DestroyRulesEditor(var Msg:TMessage);message WM_DestroyRulesEditor;
    procedure DestroyAccountEditor(var Msg:TMessage);message WM_DestroyAccountEditor;
    { Private declarations }
  public
    SignList:TSignalDescriptorsList;
    CurrentFilterType:TFilterType;  // ��� �������� �������
    TwinFilterType:TFilterType;
    SNConverter:TSNIndexConverter;
    SProvider:TSettings;
    FManager:TFilterManager;
    procedure ActivateNode(NodeIndex:Integer);
    procedure RunBkp(const CmdLine: string;WindowState: Word);
    procedure UpdateStatusBar();
    function FindElement(Text:String;SType:TClbHookMode): string;
    procedure MoveElements(NewType:TFilterType);
    procedure SetFilterState(FilterType:TFilterType; const FilterStatus: Boolean);
    procedure UpdateHeaders(Headers:TColumnsHeaders);
    property FilterState[FilterType:TFilterType]: Boolean read GetFilterState write
        SetFilterState; default;
    function GetTotalMessCount: Integer;
    function IsDiffFrom(Status:boolean): Boolean;
    procedure SetStatusTo(Status:boolean);
    procedure ShowEditor(var AMessage: TMessage); message
        WM_ShowCEditor;
    { Public declarations }
  protected
    ClbHookMode:TClbHookMode;
    AddClb:TFilterType;
    procedure SetCurrentParams(Grid:TcxGridDBTableView;Filter:TFilterType);
  end;



var
  FMain: TFMain;
  DragState:boolean=False;
  CanShowTray:boolean=True;
  FEditor:TFCustomEditor;
  FPortEditor:TFPortEditor;
  FAccountEditor:TFAccountEditor;
  FAboutForm:TFAbout;
  Coder:TBFCoder;
  AccountManager:TAccountManager;
  ThreadManager:TThreadManager;
  POP3Server:TPOPServer;
  Mutex:THandle;
  pp:integer;
  IsCreated:boolean;

implementation

uses  MultInst,SplashScreen;

{$R *.dfm}
{$R ..\Resources\WinXP.res}
{$R ..\Resources\Messages.res}
//{$R ..\Resources\Version.res}

procedure TFMain.ActivateWindow(var Msg:TMessage);
begin
 tray.ShowMainForm;
 SetForegroundWindow(Handle);
 SetActiveWindow(Handle);
 
end;

procedure TFMain.DestroyRulesEditor(var Msg:TMessage);
begin
 if FEditor<>nil then
  begin
   while FEditor.Showing do
    sleep(100);
    FreeAndNil(FEditor);
  end;
end;


procedure TFMain.DestroyAccountEditor(var Msg:TMessage);
begin
 if FAccountEditor<>nil then
  begin
   while FAccountEditor.Showing do
    sleep(100);
   FreeAndNil(FAccountEditor);
  end
end;

procedure TFMain.WMShowRegistrationForm(var Msg: TMessage);
var
 RegForm:TFRegister;
begin
 GetRegistrationInformation(UserKey,UserName );
 if not((UserKey <> nil) AND (StrLen(UserKey) > 0)) then
  begin
   SetActiveWindow(Handle);
   RegForm:=TFRegister.Create(nil);
   RegForm.ShowModal;
   if  RegForm.Result=0 then
     begin
      Application.Terminate;
     end;
  end;
end;

procedure TFMain.UpdateStatusBar;
begin
  stBar.Panels.Items[1].Text:=_('���������� ��������� � ���� ������ : ') + IntToStr(GetTotalMessCount);
  stBar.Panels.Items[0].Text:=_('������ ���� ������ : ')+ FloatToStr(RoundTo((Shared.GetFileSize(GetAppDataPath+'\Nevilon Software\Nevod AntiSpam\messages.ndb'))/(1024*1024),-2))+_(' ��');
end;

procedure TFMain.ShowEditor(var AMessage: TMessage);
begin
 FEditor.Show;
end;

procedure TFMain.UpdateLog(var Msg: TMessage);
begin
 if (Application.MainForm <>nil ) then
  begin
   if not adLog.Active then adLog.Active:=True;
   adLog.Requery;
  end;
end;

procedure TFMain.UpdateAccountStatus(var Msg: TMessage);
var
 SelRow:integer;
begin
 SelRow:=-1;
 if (cxAccounts.DataController.RecordCount>0)and(cxAccounts.Controller.SelectedRowCount>0) then
  SelRow:= cxAccounts.Controller.SelectedRows[0].RecordIndex;
 UpdateStatusBar;
 if not adAccounts.Active then adAccounts.Active:=True;
 if not adLog.Active then adLog.Active:=True;
 adAccounts.Requery;
 adLog.Requery;
 if SelRow<>-1 then cxAccounts.DataController.SelectRows(SelRow,SelRow);
 if not adAccounts.Active then adAccounts.Active:=True;
 adAccounts.Requery;
end;

procedure TFMain.UpdateFilters(var Msg: TMessage);
begin
 if  (Application.MainForm <>nil )  then
  begin
   if not adFilters.Active then adFilters.Active:=True;
    adFilters.Requery;
  end;
end;

procedure TFMain.WMChangeCBChain(var Msg: TWMChangeCBChain);
begin
  if PrevHWnd = Msg.Remove then
    PrevHWnd := Msg.Next;
  if Msg.Remove <> Handle then
    SendMessage(PrevHWnd, WM_CHANGECBCHAIN, Msg.Remove, Msg.Next);
end;

procedure TFMain.WMDrawClipboard(var Msg: TWMDrawClipboard);
var
  P: PChar;
  H: THandle;
  Len:integer;
  buf:String;
begin
try
  SendMessage(PrevHWnd, WM_DRAWCLIPBOARD, 0, 0);
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    H := Clipboard.GetAsHandle(CF_TEXT);
    Len := GlobalSize(H) + 1;
    P := GlobalLock(H);
    if StrToBool(SProvider.GetValue('EnableClbSpy'))=True then
     if (Length(Trim(p))=Length(p) ) and (pos(' ',p)=0) then
      begin
       ClbHookMode:=TClbHookMode(GetEnumValue(TypeInfo(TCLbHookMode),SProvider.GetValue('ClbHookMode')));
       buf:=FindElement(P,CLbHookMode);
       if  (IsCreated)
       and(buf<>'')and
       //(LastHooked<>buf) and
        (not FManager.ElementExists(buf,AddClb)) and
         (not FManager.ElementExists(buf,FManager.TwinFilter(AddClb))) then
        begin
         LastHooked:=buf;
         if StrToBool(SProvider.GetValue('SoundOnAdd'))=True then
          TSounder.Create(SProvider.GetValue('AddSound'));
         if StrToBool(SProvider.GetValue('ShowspyEditor')) then
          begin
           if FEditor<>nil  then FEditor.Free;
             FEditor:=TFCustomEditor.Create(SNConverter,FManager,adFilters,SignList);
           FEditor.Show(buf,TFIlterType(GetEnumValue(TypeInfo(TFilterType),SProvider.GetValue('AddClb'))));
           with FEditor do
            SetWindowPos(Handle, HWND_TOPMOST,Left,Top,Width,Height,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
          end
         else
          begin
           FManager.AddElement(buf,AddClb,'',True,'');
          end;
      //   adFilters.Active:=True;
      //   adFilters.Requery;
        end;
      end
    else LastHooked:='';
    GlobalUnlock(H);
  end;
  Msg.Result := 0;
except
end;
end;

procedure TFMain.UMActivate(var msg: TMessage);
begin
  SetForegroundWindow( handle );
end;

procedure TFMain.FormCreate(Sender: TObject);

var
 Headers:TColumnsHeaders;
 TmAppl,buf:boolean;
 Key:TRegistry;
 Sel:Integer;
 RegForm:TFRegister;
begin
 ShowWindow(Application.Handle, sw_Hide);

 IsCreated:=False;
 CanShowTray:=false;
 GetRegistrationInformation(UserKey,UserName );
 if not((UserKey <> nil) AND (StrLen(UserKey) > 0)) then
  begin
   SetActiveWindow(Application.Handle);
   RegForm:=TFRegister.Create(nil);
   RegForm.ShowModal;
   if  RegForm.Result=0 then
    begin
     FreeAndNil(RegForm);
     Application.Terminate;
   end;
   FreeAndNil(RegForm);
 end;
   CanShowTray:=True;
   adCon.ConnectionString:=GetConnectionString;
   WriteAppPath(PChar(Application.ExeName));
   //WriteAppHandle(Handle);
   AccountManager:=TAccountManager.Create(adAccounts);
   SProvider:=TSettings.Create(adCon);
   POP3Server:=TPOPServer.Create(adCon,AccountManager);

   TmAppl:=False;
   if not POP3Server.LoadParams then
     if  ShowMessageBox(Application.Handle,String(_(' ����������� ���� ������� �����. ������ ������� ���� ? ')),String(_(' ������ ������� ������� ')),MB_OKCANCEL or MB_ICONWARNING)=IDOK then
      begin
       FPortEditor:=TFPortEditor.Create(adCon);
       while (not POP3Server.LoadParams) and (not TmAppl) do
        begin
         FPortEditor.ShowModal;
         if FPortEditor.CanExit=True then TmAppl:=True;
        end;
       FreeAndNil(FPortEditor);
       if TmAppl then
        begin
         Hide;
         Application.Terminate;
        end;
      end
     else
      begin
       Hide;
       Application.Terminate;
      end;




   SNConverter:=TSNIndexConverter.Create;
   SignList:=TSignalDescriptorsList.Create;
   SignList.Add(slAnywhere,_(' � ���� � � ���� ��������� '));
   SignList.Add(slSubject,_(' � ���� ��������� '));
   SignList.Add(slBody,_(' � ���� ��������� '));

   Headers.Active:=_('�������');
   Headers.Description:=_('��������');
   with SNConverter do
     begin
      Headers.FValue:=_('�����������');
      Add(6,ftWhiteSender,_('�������� �����/����� � ����� ������'),cxTab_Filters,Headers); //����� � ����� ������
      Add(10,ftBlackSender,_('�������� �����/����� � ������ ������'),cxTab_Filters,Headers); //����� � ������ ������

      Headers.FValue:=_('���������� �����');
      Add(7,ftWhiteAttach,_('�������� ���������� ������������ ����� � ����� ������'),cxTab_Filters,Headers); // ���������� � ����� ������
      Add(11,ftBlackAttach,_('�������� ���������� ������������ ����� � ������ ������'),cxTab_Filters,Headers);// ���������� � ������ ������

      Headers.Params:=_('������������');
      Headers.FValue:=_('�����');
      Add(4,ftWhiteWord,_('�������� ����� � ����� ������'),cxTab_Filters,Headers); // ����� � ����� ������
      Add(9,ftBlackWord,_('�������� ����� � ������ ������'),cxTab_Filters,Headers); // ����� � ������ ������

      Headers.FValue:=_('Nevod Stamp');
      Add(5,ftStamp,_('�������� �����'),cxTab_Filters,Headers); // �����
      // ���������� ������� ��-��������
     Add(0,ftNone,'',cxTab_Settings);      // �������� ���������
     Add(1,ftNone,'Accounts',cxTab_Accounts);      // ������� ������
     Add(13,ftNone,'',cxTab_Log);
     Add(3,ftNone,'',cxTab_AFSettings);
     Add(8,ftNone,'',cxTab_DFSettings);
     Add(12,ftNone,'',cxTab_Log);
     end;

   FManager:=TFilterManager.Create(adCon);
   Exp:=TPerlRegEx.Create(nil);

   AddClb:=TFilterType(GetEnumValue(TypeInfo(TFilterType),SProvider.GetValue('AddClb')));

   adProc:=TADOQuery.Create(nil);
   adProc.Connection:=adCon;

   PrevHwnd := SetClipboardViewer(Handle);
   Coder:=TBFCoder.Create;
   Coder.Key:=CriptKey;
   
   

   ThreadManager:=TThreadManager.Create(adCon,AccountManager);

   cbStamp.Checked:=FilterState[ftStamp];
   cbWhiteWord.Checked:=FilterState[ftWhiteWord];
   cbWhiteSender.Checked:=FilterState[ftWhiteSender];
   cbWhiteAttach.Checked:=FilterState[ftWhiteAttach];
   cbBlackWord.Checked:=FilterState[ftBlackWord];
   cbBlackSender.Checked:=FilterState[ftBlackSender];
   cbBlackAttach.Checked:=FilterState[ftBlackAttach];
   cbMaxLinks.Checked:=FilterState[ftLinkFilter];
   cbMaxSize.Checked:=FilterState[ftMessSize];

   cxSpinLinks.Value:=StrToInt(SProvider.GetValue('MaxLinks'));
   cxSpinImages.Value:=StrToInt(SProvider.GetValue('MaxImg'));
   cxSpinMaxSize.Value:=StrToInt(SProvider.GetValue('MaxSize'))/1000;

   lbServerPort.Text:=SProvider.GetValue('ServerPort');
   seCheckInterval.Value:=StrToInt(SProvider.GetValue('CheckInterval'))/(1000*60);
   cbCheckIfNotConnected.Checked:=StrToBool(SProvider.GetValue('CheckIfNotConnected'));
   alCanCheckAccounts.Checked:=StrToBool(SProvider.GetValue('CanCheckAccounts'));
   alEnableFiltering.Checked:=StrToBool(SProvider.GetValue('EnableFiltering'));
   cbBallonOnReceive.Checked:=StrToBool(SProvider.GetValue('BaloonOnNew'));
   cbBaloonOnError.Checked:=StrToBool(SProvider.GetValue('BaloonOnError'));
   beSoundOnNew.Text:=SProvider.GetValue('NewSound');
   beSoundOnError.Text:=SProvider.GetValue('ErrorSound');
   beSoundOnAdd.Text:=SProvider.GetValue('AddSound');
   cbSoundOnReceive.Checked:=StrToBool(SProvider.GetValue('SoundOnNew'));
   cbSoundOnError.Checked:=StrToBool(SProvider.GetValue('SoundOnError'));
   cbSoundOnAdd.Checked:=StrToBool(SProvider.GetValue('SoundOnAdd'));
   alShowEditorForm.Checked:=StrToBool(SProvider.GetValue('ShowspyEditor'));

   JvAppAddHotKey.HotKey:=StrToInt(SProvider.GetValue('AddHotKey'));
   JvAppAddHotKey.Active:=True;
   JvAppShowMainWindow.HotKey:=StrToInt(SProvider.GetValue('ShowMainWindowHotKey'));
   JvAppShowMainWindow.Active:=True;
   JvAppCheckAllAccounts.HotKey:=StrToInt(SProvider.GetValue('CheckAllAccountshotKey'));
   JvAppCheckAllAccounts.Active:=True;
   jvAppRunMailClient.HotKey:=StrToInt(SProvider.GetValue('RunMailClientHotKey'));
   jvAppRunMailClient.Active:=True;

   JvAddHotKey.HotKey:= JvAppAddHotKey.HotKey;
   jvShowMainWindow.HotKey:=JvAppShowMainWindow.HotKey;
   JvCheckAllAccounts.HotKey:=JvAppCheckAllAccounts.HotKey;
   JvRunMailClient.HotKey:=jvAppRunMailClient.HotKey;

   alRunMailClient.ShortCut:=jvAppRunMailClient.HotKey;
   alStartAllThreads.ShortCut:=JvCheckAllAccounts.HotKey;
   alShowMainWindow.ShortCut:=JvAppShowMainWindow.HotKey;
   alAddFilterElement.ShortCut:=JvAddHotKey.HotKey;

   Sel:=-1;
   case TCLbHookMode(GetEnumValue(TypeInfo(TClbHookMode),SProvider.GetValue('ClbHookMode'))) of    //
     chEmail:Sel:=0 ;
     chURL: Sel:=1;
     chEmailURL:Sel:=2 ;

   end;
   cmSpyFor.ItemIndex:=Sel;
   Sel:=-1;

   case TFIlterType(GetEnumValue(TypeInfo(TFilterType),SProvider.GetValue('AddClb'))) of    //
     ftWhiteSender:Sel:=0 ;
     ftBlackSender: Sel:=1;
   end;
   cmAddTo.ItemIndex:=Sel;

   alEnableClbSpy.Checked:=StrToBool(SProvider.GetValue('EnableClbSpy'));

   buf:=StrToBool(SProvider.GetValue('RunAtStartUp'));
   cbRunAtStartUp.Checked:=buf;
   alRunAtStartUp.Checked:=buf;
   Key:=TRegistry.Create;
   Key.RootKey:=HKEY_CURRENT_USER;
   Key.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run',True);
   if buf then
    Key.WriteString('Nevod AntiSpam',Application.ExeName+' -h')
     else Key.DeleteValue('Nevod AntiSpam');
   Key.CloseKey;
   Key.Free;
   IsCreated:=True;
   UpdateStatusBar;
   TranslateComponent(self);
   adAccounts.Active:=True;
   adLog.Active:=True;


end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
 if FAboutForm<>nil then FAboutForm.Free;
 if FEditor<>nil then FEditor.Free;
 if FAccountEditor<>nil then FAccountEditor.Free;
 if FPortEditor<>nil then  FPortEditor.Free;
   
 tray.Enabled:=False;
 tray.HideTaskbarIcon;
 tray.Free;
 ThreadManager.Free;
 FManager.Free;
 SNConverter.Free;
 SignList.Free;
 AccountManager.Free;
 Coder.Free;
 Exp.Free;
 SProvider.Free;
 adProc.Free;
 CloseHandle(Mutex);
 KillProgram(Handle);
 if POP3Server<>nil then POP3Server.Free;
end;

procedure TFMain.SettingsTreeSelectionChanged(Sender: TObject);
var
 NodeIndex:Integer;
 Res:TSNConvert;
begin
  if not DragState then
  begin
   NodeIndex:=STree.TreeList.FocusedNode.AbsoluteIndex;
   if SNConverter.Find(NodeIndex,Res) then
    Res.Sheet.Show;

   if Res.Sheet=cxTab_Accounts then
    begin
    end;

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
       SQL.Text:='SELECT id,FValue,Description,Active,Params '+
                  ' FROM FiltersParams WHERE mid=(SELECT id FROM Filters WHERE Type=:FilterType) ';
       Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(Res.FilterType));
       Active:=True;
      end;
    end;
  end;
end;

procedure TFMain.SetCurrentParams(Grid:TcxGridDBTableView;Filter:TFilterType);
begin
 CurrentFilterType:=Filter;
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

procedure TFMain.adFiltersParamsGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
 Text:=SignList.DescriptionByLocation(TSignalLocation(GetEnumValue(TypeInfo(TSignalLocation),Sender.AsString)));
end;

procedure TFMain.ActivateNode(NodeIndex:Integer);
var
 i:integer;
 Flag:boolean;
begin
 i:=0;
 Flag:=False;
 while (not Flag) and (i<STree.TreeList.LastNode.AbsoluteIndex) do
  if STree.TreeList.Items[i].AbsoluteIndex=NodeIndex then
   begin
    Stree.TreeList.FocusedNode:=STree.TreeList.Items[i];
    Flag:=True;
   end
  else inc(i);
end;

procedure TFMain.SettingsTreeDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
 buf:TSNConvert;
begin
 SNConverter.Find(STree.TreeList.FocusedNode.AbsoluteIndex,buf);
 if buf.FilterType=TwinFilterType then
  Accept:=True
   else Accept:=False;
end;

procedure TFMain.cxFiltersEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
 DragState:=False;
end;

procedure TFMain.cxFiltersStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
 buf:TSNConvert;
begin
 DragState:=True;
 SNConverter.Find(STree.TreeList.FocusedNode.AbsoluteIndex,buf);
 CurrentFilterType:=buf.FilterType;
 TwinFilterType:=FManager.TwinFilter(CurrentFilterType);
end;

procedure TFMain.MoveElements(NewType:TFilterType);
var
 Elementid:Integer;
 Params:Variant;
 FValue:String;
 Active:boolean;
 Description:String;
 i:integer;
 Location:TSignalLocation;
begin
 with cxFilters.Controller do
  for i:=0 to SelectedRowCount-1 do
   begin
    ElementId:=SelectedRows[0].Values[cxFiltersid.Index];
    FValue:=SelectedRows[0].Values[cxFiltersFValue.Index];
    Description:=SelectedRows[0].Values[cxFiltersDescription.Index];
    Params:=SelectedRows[0].Values[cxFiltersParams.Index];
    Active:=SelectedRows[0].Values[cxFiltersActive.Index];

    Location:=TSignalLocation(GetEnumValue(TypeInfo(TSignalLocation),Params));
    FManager.ModifyElement(ElementId,FValue,NewType,Description,Active,Location);
    adFilters.Requery;
   end;
end;

procedure TFMain.SettingsTreeDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
 MoveElements(TwinFilterType);
end;

procedure TFMain.adAccountspassGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
 Text:=Coder.DeCrypt(Trim(Sender.Value))
end;

procedure TFMain.adAccountsTimeoutGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
 Text:=FloatToStr(Sender.AsInteger/(1000)); // �� ��������� ���� ������� ��������
end;

function TFMain.FindElement(Text:String;SType:TClbHookMode): string;
begin
 case SType of
   chURL:
    begin
     Exp.Subject:=Text;
     Exp.RegEx:='(?i)(http://www.|http://|www.|https://www.)([_a-z\d\-]+(\.[_a-z\d\-]+)+)((/[ _a-z\d\-\\\.]+)+)*';
     if  (Exp.Match) then
       Result:='*@' +Exp.SubExpressions[2];
    end;
   chEmail:
    begin
     Exp.Subject:=Text;
     Exp.RegEx:='[_a-zA-Z\d\-\.\*]+@([_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+)';
     if  (Exp.Match)  then
       Result:=Exp.MatchedExpression;
    end;
   chEmailURL:
    begin
     Exp.Subject:=Text;
     Exp.RegEx:='(?i)(http://www.|http://|www.)([_a-z\d\-]+(\.[_a-z\d\-]+)+)((/[ _a-z\d\-\\\.]+)+)*';
     if  (Exp.Match)  then
       Result:='*@'+Exp.SubExpressions[2]
        else
         begin
          Exp.Subject:=Text;
          Exp.RegEx:='[_a-zA-Z\d\-\.\*]+@([_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+)';
          if  (Exp.Match)  then
           Result:=Exp.MatchedExpression;
         end;
    end;
 end;
end;

procedure TFMain.adAccountsstatusGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
var
 AStatus:TAccountStatus;
begin
 AStatus:=TAccountStatus(GetEnumValue(TypeInfo(TAccountStatus),Sender.Value));
 case AStatus of    //
   asFree: Text:=_('��������') ;
   asClient:Text:=_('����������� ����� ') ;
   asServer: Text:=_('��������� ��������� ������') ;
 end;
end;

procedure TFMain.trayClick(Sender: TObject);
begin
 if not CanShowTray then beep()
  else tray.ShowMainForm;
end;

procedure TFMain.alAddAccountExecute(Sender: TObject);
begin
 if FAccountEditor<>nil then FAccountEditor.Free;
 FAccountEditor:=TFAccountEditor.Create(adAccounts,AccountManager);
 CanShowTray:=False;
 FAccountEditor.ShowModal;
 CanShowTray:=True;
 FreeAndNil(FAccountEditor);
end;

procedure TFMain.msAccountsPopup(Sender: TObject);
begin
 alOnAccountsPopUp.Execute;
end;

procedure TFMain.alEditAccountExecute(Sender: TObject);
var
 AccountId:integer;
begin
 if FAccountEditor<>nil then FAccountEditor.Free;
 FAccountEditor:=TFAccountEditor.Create(adAccounts,AccountManager);
 CanShowTray:=False;
 AccountId:= cxAccounts.Controller.SelectedRows[0].Values[cxAccountsid.Index];
 FAccountEditor.ShowModal(AccountId);
 CanShowTray:=True;
 FreeAndNil(FAccountEditor);
end;

procedure TFMain.alDeleteAccountExecute(Sender: TObject);
var
 AccountId:integer;
begin
 AccountId:= cxAccounts.Controller.SelectedRows[0].Values[cxAccountsid.Index];
 if ShowMessageBox(Application.Handle,_('�� ������������� ������ ������� ������� ������'),_('�������� ������� ������'),MB_OKCANCEL or MB_ICONWARNING)=IDOK then
  begin
   ThreadManager.StopThread(AccountId);
   AccountManager.DeleteAccount([AccountId]);
  end;
end;

procedure TFMain.alAppTerminateExecute(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TFMain.WMCopyData(var Msg: TWMCopyData);
var
 mess:TWMMessanger;
 i:integer;
begin
 with Msg.CopyDataStruct^ do
  begin
   mess:=TWMMessanger(lpdata^);
   if ( (mess.BallonType=bitInfo) and (StrToBool(SProvider.GetValue('BaloonOnNew'))) )
    or ((mess.BallonType=bitError) and (StrToBool(SProvider.GetValue('BaloonOnError'))))
    then
     begin
     for i:=1 to 100 do
       begin
        sleep(10);
        Application.ProcessMessages;
       end;
     
     tray.HideBalloonHint;
     end;
   tray.ShowBalloonHint(mess.Caption,mess.LogMessage,mess.BallonType,10);
   if StrToBool(SProvider.GetValue('SoundOnError')) and (mess.BallonType=bitError) then
    TSounder.Create(SProvider.GetValue('ErrorSound'));
   if StrToBool(SProvider.GetValue('SoundOnNew')) and (mess.BallonType=bitInfo) then
    TSounder.Create(SProvider.GetValue('NewSound'));
  end;
end;

procedure TFMain.alStopThreadExecute(Sender: TObject);
var
 AccountId:integer;
begin
 AccountId:= cxAccounts.Controller.SelectedRows[0].Values[cxAccountsid.Index];
 ThreadManager.StopThread(AccountId);
end;

procedure TFMain.alStartThreadExecute(Sender: TObject);
var
 AccountId:integer;
begin
 AccountId:= cxAccounts.Controller.SelectedRows[0].Values[cxAccountsid.Index];
 ThreadManager.StartThread(AccountId,True);
end;

procedure TFMain.alStartAllThreadsExecute(Sender: TObject);
begin
 ThreadManager.StartAllThreads(False);
end;

procedure TFMain.alStopAllThreadsExecute(Sender: TObject);
begin
 ThreadManager.StopAllThreads(True);
end;

procedure TFMain.alCanCheckAccountsExecute(Sender: TObject);
begin
 alCanCheckAccounts.Checked:=NOT alCanCheckAccounts.Checked;
 SProvider.SetValue('CanCheckAccounts',BoolToStr(alCanCheckAccounts.Checked,True));
end;

procedure TFMain.alOnAccountsPopUpExecute(Sender: TObject);
var
 buf:TSNConvert;
 Status:TAccountStatus;
begin
 alCanCheckAccounts.Checked:=StrToBool(SProvider.GetValue('CanCheckAccounts'));
 SNConverter.Find(STree.TreeList.FocusedNode.AbsoluteIndex,buf);
 if (buf.Sheet=cxTab_Accounts) and (cxAccounts.Controller.SelectedRowCount>0) then
  begin
   alEditAccount.Enabled:=True;
   alDeleteAccount.Enabled:=True;
   Status:=TAccountStatus(GetEnumValue(TypeInfo(TAccountStatus),cxAccounts.Controller.SelectedRows[0].Values[cxAccountsstatus.Index]));
   if Status=asClient then
     alStopThread.Enabled:=True
      else alStopThread.Enabled:=False;
   if Status=asFree then
    alStartThread.Enabled:=True
      else alStartThread.Enabled:=False;
  end
   else
    begin
     alEditAccount.Enabled:=False;
     alDeleteAccount.Enabled:=False;
     alStopThread.Enabled:=False;
     alStartThread.Enabled:=False;
    end;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 ShowWindow(Application.Handle, sw_Hide);
 tray.HideTaskbarIcon;
 tray.Enabled:=False;
 Hide;
 Action:=caFree;
end;

procedure TFMain.SetFilterState(FilterType:TFilterType; const FilterStatus:
    Boolean);
var
  oFt: Set of TFilterType;
  FilterString:String;
begin
 oFt:=[ftMessSize,ftImageFilter,ftLinkFilter];
 with adProc do
   begin
    Active:=False;
    if (FilterType in  oFt ) then
     begin
      case FilterType of
      // ftSpamWord: FilterString:='SpamWords';
       ftMessSize:FilterString:='MaxSize';
       ftImageFilter:FilterString:='MaxImg';
       ftLinkFilter:FilterString:='MaxLinks' ;
      end;
      SQL.Text:='UPDATE Settings SET Active=:FilterStatus  WHERE Name=:FilterName';
      Parameters.ParamByName('FilterStatus').Value:=FilterStatus;
      Parameters.ParamByName('FilterName').Value:=FilterString;
     end
    else
     begin
      SQL.Text:=' UPDATE Filters SET Active=:FilterStatus  WHERE Type=:FilterType';
      Parameters.ParamByName('FilterStatus').Value:=FilterStatus;
      Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
     end;
    ExecSQL;
   end;
end;

procedure TFMain.cbWhiteWordPropertiesChange(Sender: TObject);
begin
 FilterState[ftWhiteWord]:=cbWhiteWord.Checked;
end;

procedure TFMain.cbStampPropertiesChange(Sender: TObject);
begin
 FilterState[ftStamp]:=cbStamp.Checked;
end;

procedure TFMain.cbWhiteSenderPropertiesChange(Sender: TObject);
begin
 FilterState[ftWhiteSender]:=cbWhiteSender.Checked;
end;

procedure TFMain.cbWhiteAttachPropertiesChange(Sender: TObject);
begin
 FilterState[ftWhiteAttach]:=cbWhiteAttach.Checked;
end;

procedure TFMain.cbBlackWordPropertiesChange(Sender: TObject);
begin
 FilterState[ftBlackWord]:=cbBlackWord.Checked;
end;

function TFMain.GetFilterState(FilterType:TFilterType): Boolean;
var
  oFt: Set of TFilterType;
  FilterString:String;
begin
 oFt:=[ftMessSize,ftImageFilter,ftLinkFilter];
 with adProc do
   begin
    Active:=False;
    if (FilterType in  oFt ) then
     begin
      case FilterType of
      // ftSpamWord: FilterString:='SpamWords';
       ftMessSize:FilterString:='MaxSize';
       ftImageFilter:FilterString:='MaxImg';
       ftLinkFilter:FilterString:='MaxLinks' ;
      end;
      SQL.Text:='SELECT Active FROM Settings WHERE Name=:FilterName';
      Parameters.ParamByName('FilterName').Value:=FilterString;
     end
    else
     begin
      SQL.Text:='SELECT Active FROM Filters WHERE Type=:FilterType';
      Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
     end;
    Active:=True;
    Result:=Fields[0].AsBoolean;
    Active:=False;
   end;
end;

procedure TFMain.cbBlackSenderPropertiesChange(Sender: TObject);
begin
 FilterState[ftBlackSender]:=cbBlackSender.Checked;
end;

procedure TFMain.cbBlackAttachPropertiesChange(Sender: TObject);
begin
 FilterState[ftBlackAttach]:=cbBlackAttach.Checked;
end;

procedure TFMain.cbMaxLinksPropertiesChange(Sender: TObject);
begin
 FilterState[ftLinkFilter]:=cbMaxLinks.Checked;
end;

procedure TFMain.cbMaxImagesPropertiesChange(Sender: TObject);
begin
 FilterState[ftImageFilter]:=cbMaxImages.Checked;
end;

procedure TFMain.cbMaxSizePropertiesChange(Sender: TObject);
begin
 FilterState[ftMessSize]:=cbMaxSize.Checked;
end;

procedure TFMain.cxSpinLinksExit(Sender: TObject);
begin
 SProvider.SetValue('MaxLinks',IntToStr(cxSpinLinks.Value));
end;

procedure TFMain.cxSpinImagesExit(Sender: TObject);
begin
 SProvider.SetValue('MaxLinks',IntToStr(cxSpinImages.Value));
end;

procedure TFMain.cxSpinMaxSizeExit(Sender: TObject);
begin
 SProvider.SetValue('MaxLinks',IntToStr(cxSpinLinks.Value*1000));
end;

procedure TFMain.cxSpinLinksPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
 if Error  then   ErrorText:='';
end;

procedure TFMain.cxSpinImagesPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
 if Error  then   ErrorText:='';
end;

procedure TFMain.cxSpinSpamWordsPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
 if Error  then   ErrorText:='';
end;

procedure TFMain.cxSpinMaxSizePropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
 if Error  then   ErrorText:='';
end;

procedure TFMain.alAddFilterElementExecute(Sender: TObject);
begin
  if not Application.MainForm.Showing then
   Application.MainForm.Hide;

  if FEditor<>nil  then FEditor.Free;
  FEditor:=TFCustomEditor.Create(SNConverter,FManager,adFilters,SignList);
  FEditor.Show(STree.TreeList.FocusedNode.AbsoluteIndex);

  with FEditor do
   SetWindowPos(Handle, HWND_TOPMOST, Left,Top,Width,Height,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TFMain.alRemoveFilterElementExecute(Sender: TObject);
var
 ElementsId:Array of integer;
 SelCount:Integer;
 i:integer;
begin
 SelCount:=cxFilters.Controller.SelectedRowCount;
 if (SelCount>0) and ( ShowMessageBox(Application.Handle,(' �� ������������� ������ ������� ������� ?'),_('�������� ��������'),MB_OKCANCEL or MB_ICONWARNING)=IDOK) then
  begin
   SetLength(ElementsId,SelCount);
   for I:=0 to SelCount - 1 do
    ElementsId[i]:=cxFilters.Controller.SelectedRows[i].Values[cxFiltersid.Index];
   FManager.RemoveElements(ElementsId);
   adFilters.Requery;
  end;
end;

procedure TFMain.alOnFiltersPopUpExecute(Sender: TObject);
var
 Res:TSNConvert;
 tFilter:TFilterType;
 btCaption,FilterString:String;
begin
 SNConverter.Find(STree.TreeList.FocusedNode.AbsoluteIndex,Res);
 tFilter:=FManager.TwinFilter(Res.FilterType);
 if (Res.FilterType<>ftNone) and (cxFilters.Controller.SelectedRowCount>0) then
  begin
   if tFilter<>ftNone then
    begin
     btCaption:='';
     FilterString:=GetEnumName(TypeInfo(TFilterType), Ord(tFilter));
     if pos('White',FilterString)<>0 then
      btCaption:=_('��������� � ����� ������');
     if pos('Black',FilterString)<>0 then
       btCaption:=_('��������� � ������  ������');
     alMoveSelectedFiltersElements.Enabled:=True;
     if btCaption<>'' then   alMoveSelectedFiltersElements.Caption:=btCaption;
    end
     else
      begin
       alRemoveFilterElement.Enabled:=False;
      end;
   alRemoveFilterElement.Enabled:=True;
   alEditFilterElement.Enabled:=True;
   if   IsDiffFrom(False) then alSetSelectedFiltersToNonActive.Enabled:=True
    else alSetSelectedFiltersToNonActive.Enabled:=False;
   if   IsDiffFrom(True) then alSetSelectedFiltersToActive.Enabled:=True
    else alSetSelectedFiltersToActive.Enabled:=False;
  end
 else
  begin
   alRemoveFilterElement.Enabled:=False;
   alMoveSelectedFiltersElements.Enabled:=False;
   alEditFilterElement.Enabled:=False;
   alSetSelectedFiltersToNonActive.Enabled:=False;
   alSetSelectedFiltersToActive.Enabled:=False;
 end;
end;

procedure TFMain.alEditFilterElementExecute(Sender: TObject);
var
 id:Integer;
 Params:Variant;
 Value:String;
 Active:boolean;
 Description:String;
begin
 with cxFilters.Controller do
  begin
   id:=SelectedRows[0].Values[cxFiltersid.Index];
   Value:=SelectedRows[0].Values[cxFiltersFValue.Index];
   Description:=SelectedRows[0].Values[cxFiltersDescription.Index];
   Params:=SelectedRows[0].Values[cxFiltersParams.Index];
   Active:=SelectedRows[0].Values[cxFiltersActive.Index];
  end;

 if FEditor<>nil  then FEditor.Free;
 FEditor:=TFCustomEditor.Create(SNConverter,FManager,adFilters,SignList);
 FEditor.Show(id,Value,Description,Params,Active,STree.TreeList.FocusedNode.AbsoluteIndex);
 with FEditor do
   SetWindowPos(Handle, HWND_TOPMOST, Left,Top,Width,Height,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
end;


procedure TFMain.cxAccountsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 alOnAccountsPopUp.Execute;
 if (Key=46) or (Key=110) then
  begin
   alOnAccountsPopUp.Execute;
   alDeleteAccount.Execute;
  end;
 if Key=13 then
  begin
   alOnAccountsPopUp.Execute;
   alEditAccount.Execute;
  end;
end;

procedure TFMain.cxFiltersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  alOnFiltersPopUp.Execute;
 if (Key=46) or (Key=110) then  // ������� ������
   alRemoveFilterElement.Execute;
 if Key=13 then     // ������������� ������
   alEditFilterElement.Execute;
end;

procedure TFMain.lbServerPortKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key  in ['0'..'9',#8]) then
  begin
   Key := #0;
   Beep;
  end;
end;

procedure TFMain.seCheckIntervalPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
 if Error  then   ErrorText:='';
end;

procedure TFMain.seCheckIntervalExit(Sender: TObject);
begin
 SProvider.SetValue('CheckInterval',IntToStr(seCheckInterval.Value*60*1000))
end;

procedure TFMain.cbCheckIfNotConnectedPropertiesChange(Sender: TObject);
begin
 SProvider.SetValue('CheckIfNotConnected',BoolToStr(cbCheckIfNotConnected.Checked,True));
end;

procedure TFMain.cbEnableFilteringPropertiesChange(Sender: TObject);
begin
 SProvider.SetValue('EnableFiltering',BoolToStr(cbEnableFiltering.Checked,True));
end;

procedure TFMain.cbBallonOnReceivePropertiesChange(Sender: TObject);
begin
 SProvider.SetValue('BaloonOnNew',BoolToStr(cbBallonOnReceive.Checked,True));
end;

procedure TFMain.cbBaloonOnErrorPropertiesChange(Sender: TObject);
begin
 SProvider.SetValue('BaloonOnError',BoolToStr(cbBaloonOnError.Checked,True));

end;

procedure TFMain.cxButtonEdit1PropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
 if AButtonIndex=0 then
  begin
   if selSound.Execute then
    begin
     beSoundOnNew.Text:=selSound.FileName;
     SProvider.SetValue('NewSound',selSound.FileName)
    end;
  end
 else
 TSounder.Create(beSoundOnNew.Text);
end;

procedure TFMain.beSoundOnErrorPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
 if AButtonIndex=0 then
  begin
   if selSound.Execute then
    begin
     beSoundOnError.Text:=selSound.FileName;
     SProvider.SetValue('ErrorSound',selSound.FileName);
    end;
  end
 else
  TSounder.Create(beSoundOnError.Text);
end;

procedure TFMain.cbSoundOnReceivePropertiesChange(Sender: TObject);
begin
 SProvider.SetValue('SoundOnNew',BoolToStr(cbSoundOnReceive.Checked,True));
end;

procedure TFMain.cbSoundOnErrorPropertiesChange(Sender: TObject);
begin
 SProvider.SetValue('SoundOnError',BoolToStr(cbSoundOnError.Checked,True));
end;

procedure TFMain.alClearLogExecute(Sender: TObject);
begin
 with adProc do
   begin
    Active:=False;
    SQL.Text:='DELETE FROM Log';
    ExecSQL;
    Active:=False;
   end;
 adLog.Requery;
end;

procedure TFMain.alDeleteSelectedLogExecute(Sender: TObject);
var
 i,SelCount:integer;
 LInd:Array of integer;
 RowSQL:String;
begin
 SelCount:=cxLog.Controller.SelectedRowCount;
 SetLength(LInd,SelCount);
 for i:=0 to SelCount-1 do
  LInd[i]:=cxLog.Controller.SelectedRows[i].Values[cxLogId.Index];
 RowSQL:='';
 for i:=Low(LInd) to High(LInd) do
   begin
    RowSQL:=RowSQL+ ' id='+IntToStr(LInd[i]);
    if i<>High(LInd) then RowSQL:=RowSQl+' OR ';
   end;
 with adProc do
  begin
   Active:=False;
   SQL.Text:='DELETE FROM Log WHERE ' + RowSQL;
   ExecSQL;
  end;
 adLog.Requery;
end;

procedure TFMain.alSaveLogExecute(Sender: TObject);
var
 FileName,iFile:String;
 ExpLog:TADOQuery;
 selFile:TSaveDialog;
begin
 selFile:=TSaveDialog.Create(nil);
 selFile.Options:=[ofOverwritePrompt];
 selFile.Filter:=_('��������� �����(*.txt)|*.txt');
 if selFile.Execute then
   with ExpLog do
     begin
      ExpLog:=TADOQuery.Create(nil);
      ExpLog.Connection:=adCon;
      FileName:=selFile.FileName;
      if ExtractFileExt(FileName)<>'' then
        FileName:=Copy(FileName,0,length(FileName)-pos('.',FileName)+1);
      FileName:=FileName+'.txt';
      if FileExists(FileName) then DeleteFile(FileName);
      SQL.Clear;
      SQL.Add('SELECT Accounts.AccountName,Log.Message,ErrorTime');
      SQL.Add('INTO ['+ ExtractFileName(FileName)+']');
      SQL.Add(' IN '+''''+ ExtractFilePath(FileName) + ''''+'[Text;]');
      SQL.Add('FROM Log,Accounts WHERE  Accounts.Id=log.mid');
      ExecSQL;
      Free;
      iFile:=ExtractFilePath(FileName)+'schema.ini';
      if FileExists(iFile) then DeleteFile(iFile);
     end;
 selFile.Free;
end;

procedure TFMain.alOnLogPopUpExecute(Sender: TObject);
begin
 if cxLog.DataController.RecNo=-1 then    // ���� ������� ������
  begin
   alSaveLog.Enabled:=False;
   alClearLog.Enabled:=False;
   alDeleteSelectedLog.Enabled:=False;
   Exit;
  end
   else
    begin
     alSaveLog.Enabled:=True;
     alClearLog.Enabled:=True;
    end;
 if cxLog.Controller.SelectedRowCount>0 then
  alDeleteSelectedLog.Enabled:=True
   else alDeleteSelectedLog.Enabled:=False;
end;

procedure TFMain.cbActivateClbSpyPropertiesChange(Sender: TObject);
begin
 SProvider.SetValue('EnableClbSpy',BoolToStr(cbActivateClbSpy.Checked,True));
end;

procedure TFMain.cmSpyForPropertiesChange(Sender: TObject);
var
 Res:TClbHookMode;
begin
 case cmSpyFor.ItemIndex of
   0: Res:=chEmail  ;  // email
   1: Res:=chURL ;  // URL
   2: Res:=chEmailURL;  // EMail & URL
 end;
 SProvider.SetValue('ClbHookMode',GetEnumName(TypeInfo(TClbHookMode), Ord(Res)));
end;

procedure TFMain.cmAddToPropertiesChange(Sender: TObject);
var
 Res:TFilterType;
begin
 case cmAddTo.ItemIndex of
   0: Res:=ftWhiteSender  ;
   1: Res:=ftBlackSender ;
 end;
 SProvider.SetValue('AddClb',GetEnumName(TypeInfo(TFilterType), Ord(Res)));
end;

procedure TFMain.cbSoundOnAddPropertiesChange(Sender: TObject);
begin
 SProvider.SetValue('SoundOnAdd',BoolToStr(cbSoundOnAdd.Checked,True));
end;

procedure TFMain.beSoundOnAddPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
 if AButtonIndex=0 then
  begin
   if selSound.Execute then
    begin
     beSoundOnAdd.Text:=selSound.FileName;
     SProvider.SetValue('AddSound',selSound.FileName);
    end;
  end
 else
  TSounder.Create(beSoundOnAdd.Text);
end;

procedure TFMain.cxAccountsDblClick(Sender: TObject);
begin
 alOnAccountsPopUp.Execute;
 alEditAccount.Execute;
end;

procedure TFMain.trayMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if (not CanShowTray)and (Button=mbRight) then beep()
  else
   if (Button=mbRight) then
    begin
     SetForegroundWindow(Handle);
     pTray.PopupFromCursorPos;
     PostMessage(Handle, WM_NULL, 0, 0);
    end;
end;

procedure TFMain.JvAppAddHotKeyHotKey(Sender: TObject);
begin
 alAddFilterElement.Execute;
end;

procedure TFMain.JvAddHotKeyEnter(Sender: TObject);
begin
 jvAppAddHotKey.Active:=False;
 btAddHotKey.Tag:=JvAddHotKey.HotKey;
 alAddFilterElement.ShortCut:=0;
end;

procedure TFMain.JvAppAddHotKeyHotKeyRegisterFailed(Sender: TObject;
  var HotKey: TShortCut);
begin
// ShowMessageBox(Application.Handle,_('������ ��� ����������'),'������ ���������� ������������ ������ ����������� !',MB_ICONWARNING);
 JvAddHotKey.HotKey:=btAddHotKey.Tag;
 JvAppAddHotKey.HotKey:=btAddHotKey.Tag;
 SProvider.SetValue('AddHotKey',IntToStr(btAddHotKey.Tag));
 alAddFilterElement.ShortCut:=JvAppAddHotKey.HotKey;
end;

procedure TFMain.alHideToTrayExecute(Sender: TObject);
begin
 tray.HideMainForm;
end;

procedure TFMain.cxFiltersDblClick(Sender: TObject);
begin
  alOnFiltersPopUp.Execute;
  alEditFilterElement.Execute;
end;

function TFMain.IsDiffFrom(Status:boolean): Boolean;
var
 i:integer;
 flag:boolean;
begin
 i:=0;
 Flag:=False;
 while (not Flag) and (i<cxFilters.Controller.SelectedRowCount) do
  if cxFilters.Controller.SelectedRows[i].Values[cxFiltersActive.Index]<>Status
   then Flag:=True
    else inc(i);
 Result:=Flag; // ���������� True, ���� ���� ��������
end;

procedure TFMain.SetStatusTo(Status:boolean);
var
 ElementsId:Array of integer;
 i:integer;
begin
 with cxFilters.Controller do
  begin
   SetLength(ElementsId,SelectedRowCount);
   for i:=0 to SelectedRowCount-1 do
    ElementsId[i]:=SelectedRows[i].Values[cxFiltersid.Index];
  end;
 FManager.Activate(ElementsId,Status);
 adFilters.Requery;
end;

procedure TFMain.alSetSelectedFiltersToActiveExecute(Sender: TObject);
begin
 SetStatusTo(True);
end;

procedure TFMain.alSetSelectedFiltersToNonActiveExecute(Sender: TObject);
begin
 SetStatusTo(False);
end;


procedure TFMain.alRunMailClientExecute(Sender: TObject);
begin
 TMailClientRunner.Create;
end;

procedure TFMain.btAddHotKeyClick(Sender: TObject);
begin
 JvAppAddHotKey.HotKey:=JvAddHotKey.HotKey;
 SProvider.SetValue('AddHotKey',IntToStr(JvAddHotKey.HotKey));
 alAddFilterElement.ShortCut:=JvAppAddHotKey.HotKey;
end;


procedure TFMain.alMoveSelectedFiltersElementsExecute(Sender: TObject);
var
 Res:TSNConvert;
 ElementsId:Array of integer;
 i:integer;
begin
 SNConverter.Find(STree.TreeList.FocusedNode.AbsoluteIndex,Res);
 with cxFilters.Controller do
  begin
   SetLength(ElementsId,SelectedRowCount);
   for i:=0 to SelectedRowCount-1 do
    ElementsId[i]:=SelectedRows[i].Values[cxFiltersid.Index];
  end;
 FManager.ChangeFilterElementType(ElementsId,FManager.TwinFilter(Res.FilterType));
 adFilters.Requery;
end;

procedure TFMain.RunBkp(const CmdLine: string;   WindowState: Word);
var
 SUInfo: TStartupInfo;
 ProcInfo: TProcessInformation;
begin
 FillChar(SUInfo, SizeOf(SUInfo), #0);
 with SUInfo do
  begin
   cb := SizeOf(SUInfo);
   dwFlags := STARTF_USESHOWWINDOW;
   wShowWindow := WindowState;
  end;
   CreateProcess(nil, PChar(CmdLine), nil, nil, False,
     CREATE_NEW_CONSOLE or
     NORMAL_PRIORITY_CLASS, nil,
     nil,
     SUInfo, ProcInfo);
end;


procedure TFMain.alRestoreFromBackUpExecute(Sender: TObject);
begin
 if ShowMessageBox(Application.Handle,_('���������� ����� ���������'),_('���������'),MB_OKCANCEL or MB_ICONWARNING)=IDOK
  then
   RunBkp('NevodBackup.exe -rb',SW_SHOWNORMAL);
end;

procedure TFMain.alSaveToBackUpExecute(Sender: TObject);
begin
 if ShowMessageBox(Application.Handle,_('���������� ����� ���������'),_('���������'),MB_OKCANCEL or MB_ICONWARNING)=IDOK
  then
   RunBkp('NevodBackup.exe -sb',SW_SHOWNORMAL);
end;

procedure TFMain.btShowMainWindowClick(Sender: TObject);
begin
 JvAppShowMainWindow.HotKey:=jvShowMainWindow.HotKey;
 JvAppShowMainWindow.Active:=True;
 SProvider.SetValue('ShowMainWindowHotKey',IntToStr(jvShowMainWindow.HotKey));
 alShowMainWindow.ShortCut:=JvAppShowMainWindow.HotKey;
end;

procedure TFMain.btCheckAllAccountsClick(Sender: TObject);
begin
 JvAppCheckAllAccounts.HotKey:=JvCheckAllAccounts.HotKey;
 JvAppCheckAllAccounts.Active:=True;
 SProvider.SetValue('CheckAllAccountsHotKey',IntToStr(JvCheckAllAccounts.HotKey));
 alStartAllThreads.ShortCut:=JvAppCheckAllAccounts.HotKey;
end;

procedure TFMain.btRunMailClientClick(Sender: TObject);
begin
 jvAppRunMailClient.HotKey:=JvRunMailClient.HotKey;
 SProvider.SetValue('RunMailClientHotKey',IntToStr(JvRunMailClient.HotKey));
 alRunMailClient.ShortCut:=jvAppRunMailClient.HotKey;
 jvAppRunMailClient.Active:=True;
end;

procedure TFMain.JvAppShowMainWindowHotKey(Sender: TObject);
begin
 tray.ShowMainForm;
 SetActiveWindow(Handle);
end;

procedure TFMain.JvAppCheckAllAccountsHotKey(Sender: TObject);
begin
 alStartAllThreads.Execute;
end;

procedure TFMain.jvAppRunMailClientHotKey(Sender: TObject);
begin
 alRunMailClient.Execute;
end;

procedure TFMain.JvAppShowMainWindowHotKeyRegisterFailed(Sender: TObject;
  var HotKey: TShortCut);
begin
 jvShowMainWindow.HotKey:=btShowMainWindow.Tag;
 jvAppShowMainWindow.HotKey:=btShowMainWindow.Tag;
 SProvider.SetValue('ShowMainWindowHotKey',IntToStr(btShowMainWindow.Tag));
 alShowMainWindow.ShortCut:=jvShowMainWindow.HotKey;
end;

procedure TFMain.JvAppCheckAllAccountsHotKeyRegisterFailed(Sender: TObject;
  var HotKey: TShortCut);
begin
 JvCheckAllAccounts.HotKey:=btCheckAllAccounts.Tag;
 JvAppCheckAllAccounts.HotKey:=btCheckAllAccounts.Tag;
 SProvider.SetValue('CheckAllAccountsHotKey',IntToStr(btCheckAllAccounts.Tag));
 alStartAllThreads.ShortCut:=JvAppCheckAllAccounts.HotKey;
end;

procedure TFMain.jvAppRunMailClientHotKeyRegisterFailed(Sender: TObject;
  var HotKey: TShortCut);
begin
 JvRunMailClient.HotKey:=btRunMailClient.Tag;
 JvAppRunMailClient.HotKey:=btRunMailClient.Tag;
 SProvider.SetValue('RunMailClientHotKey',IntToStr(btRunMailClient.Tag));
 alRunMailClient.ShortCut:=jvAppRunMailClient.HotKey;
end;

procedure TFMain.jvShowMainWindowEnter(Sender: TObject);
begin
  btShowMainWindow.Tag:=jvShowMainWindow.HotKey;
  jvAppShowMainWindow.Active:=False;
  alShowMainWindow.ShortCut:=0
end;

procedure TFMain.JvCheckAllAccountsEnter(Sender: TObject);
begin
 btCheckAllAccounts.Tag:=JvCheckAllAccounts.HotKey;
 JvAppCheckAllAccounts.Active:=False;
 alStartAllThreads.ShortCut:=0;
end;

procedure TFMain.JvRunMailClientEnter(Sender: TObject);
begin
  btRunMailClient.Tag:=JvRunMailClient.HotKey;

 JvAppRunMailClient.Active:=False;
 alRunMailClient.ShortCut:=0;

end;

procedure TFMain.alEnableFilteringExecute(Sender: TObject);
begin
 alEnableFiltering.Checked:= NOT alEnableFiltering.Checked;
 SProvider.SetValue('EnableFiltering',BoolToStr(alEnableFiltering.Checked,True));
end;

function TFMain.GetTotalMessCount: Integer;
begin
 with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT COUNT(*) FROM Messages ';
    Active:=True;
    Result:=Fields[0].AsInteger;
    Active:=False;
   end;
end;

procedure TFMain.alShowAboutExecute(Sender: TObject);
begin
 if FAboutForm=nil then
  begin
   CanShowTray:=False;
   FAboutForm:=TFAbout.Create(nil);
   FAboutForm.ShowModal;
   FreeAndNil(FAboutForm);
   CanShowTray:=True;
  end;
end;

procedure TFMain.alCheckForUpdatesExecute(Sender: TObject);
begin
 ShellExecute(Handle, nil, 'http:\\www.nevilon.com\products\NevodAntiSpam', nil, nil, SW_SHOW);
end;

procedure TFMain.alGotoNevilonExecute(Sender: TObject);
begin
 ShellExecute(Handle, nil, 'http:\\www.nevilon.com', nil, nil, SW_SHOW);
end;

procedure TFMain.alBuyNowExecute(Sender: TObject);
begin
 ShellExecute(Handle, nil, 'http:\\www.emetrix.com', nil, nil, SW_SHOW);
end;

procedure TFMain.alRunAtStartUpExecute(Sender: TObject);
var
 Key:TRegistry;
begin
 alRunAtStartUp.Checked:=NOT alRunAtStartUp.Checked;
 Key:=TRegistry.Create;
 Key.RootKey:=HKEY_CURRENT_USER;
 Key.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run',True);
 if alRunAtStartUp.Checked then
  Key.WriteString('Nevod AntiSpam',Application.ExeName+' -h')
   else Key.DeleteValue('Nevod AntiSpam');
 Key.CloseKey;
 Key.Free;
 SProvider.SetValue('RunAtStartUp',BoolToStr(alRunAtStartUp.Checked,True));
end;

procedure TFMain.alEnableClbSpyExecute(Sender: TObject);
begin
 alEnableClbSpy.Checked:=NOT alEnableClbSpy.Checked;
 SProvider.SetValue('EnableClbSpy',BoolToStr(cbActivateClbSpy.Checked,True));
end;

procedure TFMain.alShowEditorFormExecute(Sender: TObject);
begin
 alShowEditorForm.Checked:=NOT alShowEditorForm.Checked;
 SProvider.SetValue('ShowspyEditor',BoolToStr(alShowEditorForm.Checked,True));
end;

procedure TFMain.alShowMainWindowExecute(Sender: TObject);
begin
 tray.ShowMainForm;
 SetActiveWindow(Handle);
end;

procedure TFMain.alRegisterExecute(Sender: TObject);
var
 RegistrationKey:TFRegistrationKey;
begin
 GetRegistrationInformation(UserKey,UserName );
 if ((UserKey <> nil) AND (StrLen(UserKey) > 0)) then
   ShowMessageBox(Application.Handle, _('��������� ����������������'), _('�����������'), MB_ICONINFORMATION or MB_ICONINFORMATION)
  else
   begin
     RegistrationKey:=TFRegistrationKey.Create(nil);
     RegistrationKey.ShowModal;
     RegistrationKey.Free;
   end;
end;

procedure TFMain.JvAddHotKeyExit(Sender: TObject);
begin
 jvAppAddHotKey.Active:=True;
 alAddFilterElement.ShortCut:=jvAppAddHotKey.HotKey;
end;

procedure TFMain.jvShowMainWindowExit(Sender: TObject);
begin
 jvAppShowMainWindow.Active:=True;
 alShowMainWindow.ShortCut:=JvAppShowMainWindow.HotKey;
end;

procedure TFMain.JvCheckAllAccountsExit(Sender: TObject);
begin
 JvAppCheckAllAccounts.Active:=True;
 alStartAllThreads.ShortCut:=JvAppCheckAllAccounts.HotKey;
end;

procedure TFMain.JvRunMailClientExit(Sender: TObject);
begin
 JvAppRunMailClient.Active:=True;
 alRunMailClient.ShortCut:=jvAppRunMailClient.HotKey;
end;

procedure TFMain.lbServerPortChange(Sender: TObject);
var
 buf,code:integer;
begin
 Val(lbServerPort.Text,buf,code);
 if code=0 then
   SProvider.SetValue('ServerPort',IntToStr(buf));
end;

procedure TFMain.beSoundOnNewPropertiesChange(Sender: TObject);
begin
 SProvider.SetValue('NewSound',beSoundOnNew.Text);
end;

procedure TFMain.beSoundOnErrorPropertiesChange(Sender: TObject);
begin
 SProvider.SetValue('ErrorSound',beSoundOnError.Text);
end;

procedure TFMain.beSoundOnAddPropertiesChange(Sender: TObject);
begin
 SProvider.SetValue('AddSound',beSoundOnAdd.Text);
end;

procedure TFMain.cxLogKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  alOnLogPopUp.Execute;
 if (Key=46) or (Key=110) then
  begin
   alDeleteSelectedLog.Execute;
  end;
 if Key=13 then
   alDeleteSelectedLog.Execute;
end;


procedure TFMain.alShowHelpExecute(Sender: TObject);
begin
 ShellExecute(Handle, nil, PChar(ExtractFilePath(Application.ExeName)+'help.chm'), nil, nil, SW_MAXIMIZE);
end;

end.
