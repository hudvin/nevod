unit main;

interface

uses Forms,Windows, Dialogs, ASFilter, Registry, dxBar, cxStyles, Shared,
  cxTL, DB, ADODB, RXShell, StdCtrls, ExtCtrls, cxContainer, cxEdit,
  cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  PostManager,
  
  cxGridCustomView, cxGrid, Menus, CoolTrayIcon,
  cxGridCustomPopupMenu, cxGridPopupMenu, Classes, Controls,
  cxGridDBTableView, cxClasses, cxControls, cxPC, cxSplitter,
  cxInplaceContainer, dxStatusBar;

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
    rxTray: TRxTrayIcon;
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
    Button1: TButton;
    cxAccounts: TcxGridTableView;
    cxAccountsAccountName: TcxGridColumn;
    cxAccountsUsername: TcxGridColumn;
    cxAccountsPassword: TcxGridColumn;
    cxAccountsServer: TcxGridColumn;
    cxAccountsPort: TcxGridColumn;
    cxAccountsTimeout: TcxGridColumn;
    cxAccountsStatus: TcxGridColumn;
    procedure cbRunPropertiesChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rxTrayClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Reg: TRegistry;
    Coder:TBFCoder;
    PSManager: TPostManager;
    { Private declarations }
  public
    procedure RunOnStartup(Run:boolean);
    { Public declarations }
  protected
  end;


var
  FMain: TFMain;
implementation

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

procedure TFMain.Button1Click(Sender: TObject);
var
  i,J:integer;
begin

{ cxAccounts.DataController.RecordCount := 10;
  Randomize;
  for I := 0 to 9 do
    for J := 0 to 4 do
      cxAccounts.DataController.SetValue(I, J, Random(100));
 }
  cxAccounts.DataController.RecordCount:=PSManager.AccountManager.Count;
 for i := 0 to PSManager.AccountManager.Count-1 do  // ������ �� �������
   begin
 //   cxAccounts.DataController.SetValue(i,cxName.Index,'dffsafasfassa');
      //cxGrid1DBTableView1.DataController.SetValue(I, J, Random(100));
   end;

end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
 Coder.Free;
 Reg.Free;
 PSManager.Free;
end;

end.

{
��������� � ��������� ���� !
��� ����������� - � ����
���� ������� � �������� ������������ (Documents and Settings)
������� ����� TAccountManager � ����� ���� �������� ������ ������� �������
��� ��������������� - ����������� � ����
������������ ������ ��� ��������� ��������

}
