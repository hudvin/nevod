unit main;

interface

uses Forms,Windows, Dialogs, ASFilter, Registry, dxBar, cxStyles, Shared,
  cxTL, DB, ADODB, RXShell, StdCtrls, ExtCtrls, cxContainer, cxEdit,
  cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  PostManager, SysUtils,
  
  cxGridCustomView, cxGrid, Menus, CoolTrayIcon,
  cxGridCustomPopupMenu, cxGridPopupMenu, Classes, Controls,
  cxGridDBTableView, cxClasses, cxControls, cxPC, cxSplitter,
  cxInplaceContainer, dxStatusBar, cxLookAndFeels, ActnList,
  XPStyleActnCtrls, ActnMan;

type
  TFMain = class(TForm)
    stBar: TdxStatusBar;
    SettingsTree: TcxTreeList;
    cxSplitter1: TcxSplitter;
    STree: TcxTreeListColumn;
    stPages: TcxPageControl;
    cxTab_Accounts: TcxTabSheet;
    cxTabSheet3: TcxTabSheet;
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
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    TreeListStyleSheetDevExpress: TcxTreeListStyleSheet;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxStyle4: TcxStyle;
    cxStyle5: TcxStyle;
    cxStyle6: TcxStyle;
    cxStyle7: TcxStyle;
    cxStyle8: TcxStyle;
    cxStyle9: TcxStyle;
    cxStyle10: TcxStyle;
    cxStyle11: TcxStyle;
    cxStyle12: TcxStyle;
    cxStyle13: TcxStyle;
    cxStyle14: TcxStyle;
    dxBarManager1: TdxBarManager;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarPopupMenu1: TdxBarPopupMenu;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
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
    dxBarButton13: TdxBarButton;
    aMan: TActionManager;
    amAddAccount: TAction;
    Action2: TAction;
    dxAccountsPopup: TdxBarPopupMenu;
    pbAddAccount: TdxBarButton;
    dxBarButton15: TdxBarButton;
    dxBarButton16: TdxBarButton;
    dxBarButton17: TdxBarButton;
    procedure cbRunPropertiesChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rxTrayClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure amAddAccountExecute(Sender: TObject);
    procedure dxBarButton15Click(Sender: TObject);
    procedure dxAccountsPopupPopup(Sender: TObject);
    procedure dxBarButton11Click(Sender: TObject);
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

uses AddAccount, ModifyAccount;

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

// Application.ShowMainForm:=False;
end;

procedure TFMain.rxTrayClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if not FMain.Active then
  FMain.Show;

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

procedure TFMain.dxBarButton15Click(Sender: TObject);
begin
 //
//  cxAccountsAccountName.
 Caption:= cxAccounts.Controller.SelectedRecords[0].Values[cxAccountsAccountName.VisibleIndex];
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

end.

{
запускать в свернутом виде !
при минимизации - в трей
базу хранить в каталоге пользователя (Documents and Settings)
создать класс TAccountManager и через него получать список учетныЯ записей
при минимизировании - сворачивать в трей
проигрывание музыки при системных событиях хранить в минутах (тольк целые числа !!!) !!!

}
