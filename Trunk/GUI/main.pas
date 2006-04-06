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
    cxAccounts: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
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
    cxAccountsid: TcxGridDBColumn;
    cxAccountsAccountName: TcxGridDBColumn;
    cxAccountsusername: TcxGridDBColumn;
    cxAccountspass: TcxGridDBColumn;
    cxAccountshost: TcxGridDBColumn;
    cxAccountsport: TcxGridDBColumn;
    cxAccountsTimeout: TcxGridDBColumn;
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
    procedure cbRunPropertiesChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rxTrayClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cxAccountsAccountNameGetDataText(
      Sender: TcxCustomGridTableItem; ARecordIndex: Integer;
      var AText: String);
    procedure cxAccountspassGetDataText(
      Sender: TcxCustomGridTableItem; ARecordIndex: Integer;
      var AText: String);
    procedure cxAccountspassGetDisplayText(
      Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AText: String);
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
 PSManager:=TPostManager.Create(adCon);
    
// Coder:=TBFCoder.Create;
// Coder.Key:=Shared.CriptKey;
// Application.ShowMainForm:=False;
end;

procedure TFMain.rxTrayClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if not FMain.Active then
  FMain.Show;

end;

procedure TFMain.cxAccountsAccountNameGetDataText(
  Sender: TcxCustomGridTableItem; ARecordIndex: Integer;
  var AText: String);
begin
end;
 {

 производить расшифровку пароля и заменять все звездочками

 }
procedure TFMain.cxAccountspassGetDataText(
  Sender: TcxCustomGridTableItem; ARecordIndex: Integer;
  var AText: String);
begin

{  if Coder=nil then
   begin
    Coder:=TBFCoder.Create;
    Coder.Key:=CriptKey;
   end;
   ShowMessage(AText);
   try
   AText:=Coder.DeCrypt(AText);
   except
   end;
}
end;

procedure TFMain.cxAccountspassGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: String);
begin
// ShowMessage('');
end;

procedure TFMain.Button1Click(Sender: TObject);
var
  i,J:integer;
begin

 cxAccounts.DataController.RecordCount := 10;
  Randomize;
  for I := 0 to 9 do
    for J := 0 to 4 do
      cxAccounts.DataController.SetValue(I, J, Random(100));

{  cxAccounts.DataController.RecordCount:=PSManager.AccountManager.Count;
 for i := 0 to PSManager.AccountManager.Count-1 do  // проход по строкам
   begin
    cxAccounts.DataController.SetValue(i,cxAccountsAccountName.Index,'dffsafasfassa');
      //cxGrid1DBTableView1.DataController.SetValue(I, J, Random(100));
   end;
}
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
 Coder.Free;
 Reg.Free;
 PSManager.Free;
end;

end.

{
запускать в свернутом виде !
при минимизации - в трей
базу хранить в каталоге пользователя (Documents and Settings)
создать класс TAccountManager и через него получать список учетныЯ записей
при минимизировании - сворачивать в трей
проигрывание музыки при системных событиях

}
