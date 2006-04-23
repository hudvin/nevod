unit main;

interface

uses Commctrl, Forms,Windows, Dialogs, Registry, dxBar, cxStyles, Shared,
  cxTL, DB, ADODB,  StdCtrls, ExtCtrls, cxContainer, cxEdit,
  cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView, ShellAPI,
  SysUtils, Typinfo, FilterManager, AccountManager,  AccountEditor,  Graphics,

  cxGridCustomView, cxGrid, Menus,   Messages,
  cxGridCustomPopupMenu, cxGridPopupMenu, Classes, Controls,
  cxGridDBTableView, cxClasses, cxControls, cxPC, cxSplitter,
  cxInplaceContainer, dxStatusBar, cxLookAndFeels,CustomEditor, ActnList,
  XPStyleActnCtrls, ActnMan,  Clipbrd, PerlRegEx,
  ImgList, dxBarExtItems, CoolTrayIcon;


type
  TFMain = class(TForm)
    stBar: TdxStatusBar;
    SettingsTree: TcxTreeList;
    cxSplitter1: TcxSplitter;
    STree: TcxTreeListColumn;
    stPages: TcxPageControl;
    cxTab_Accounts: TcxTabSheet;
    cxAccountsGrid: TcxGrid;
    dsAccounts: TDataSource;
    adCon: TADOConnection;
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
    aMan: TActionManager;
    cxTab_Filters: TcxTabSheet;
    cxFilters: TcxGridDBTableView;
    cxFiltersGridLevel1: TcxGridLevel;
    cxFiltersGrid: TcxGrid;
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
    Button2: TButton;
    Action1: TAction;
    Button3: TButton;
    dxBarButton1: TdxBarButton;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarStatic1: TdxBarStatic;
    ImageList1: TImageList;
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure amDeleteAccountExecute(Sender: TObject);
    procedure SettingsTreeSelectionChanged(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure adFiltersParamsGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure SettingsTreeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure cxFiltersEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure cxFiltersStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure SettingsTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dxBarLargeButton1Click(Sender: TObject);
    procedure adAccountspassGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure adAccountsTimeoutGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure adAccountsstatusGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure trayClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure trayBalloonHintShow(Sender: TObject);
  private
    CurrNode:TcxTreeListNode;
    PrevHwnd: Hwnd;
    Exp:TPerlRegEx;
    procedure WMChangeCBChain(var Msg: TWMChangeCBChain);
    message WM_CHANGECBCHAIN;

  procedure WMDrawClipboard(var Msg: TWMDrawClipboard);
    message WM_DRAWCLIPBOARD;

    { Private declarations }
  public
    SignList:TSignalDescriptorsList;
    CurrentFilterType:TFilterType;  // ��� �������� �������
    TwinFilterType:TFilterType;
    SNConverter:TSNIndexConverter;
 //   PSManager: TPostManager;
    FManager:TFilterManager;
    procedure ActivateNode(NodeIndex:Integer);
    procedure MoveElements(NewType:TFilterType);
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
  FAccountEditor:TFAccountEditor;
  Coder:TBFCoder;
  AccountManager:TAccountManager;
 // FAddAccount:TFAddAccount;
//  PSManager:T


implementation

{$R *.dfm}
{$R ..\Resources\WinXP.res}


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
begin
  SendMessage(PrevHWnd, WM_DRAWCLIPBOARD, 0, 0);
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    H := Clipboard.GetAsHandle(CF_TEXT);
    Len := GlobalSize(H) + 1;
    P := GlobalLock(H);
  //  Memo1.SetTextBuf(P);
  {
  ����������� �� ������� ������� � url
  }
   // if pos('@',P)<>0 then
       
    Exp.RegEx:='[_a-zA-Z\d\-\.\*]+@([_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+)';
    Exp.Subject:=p;
    if  Exp.Match then
      tray.ShowBalloonHint('Balloon hint',Exp.MatchedExpression, bitInfo, 10);

    GlobalUnlock(H);
  end;
  Msg.Result := 0;
end;




procedure TFMain.RunOnStartup(Run:boolean);
begin
end;

procedure TFMain.FormCreate(Sender: TObject);
var
 Headers:TColumnsHeaders;
begin
 Exp:=TPerlRegEx.Create(nil);

 PrevHwnd := SetClipboardViewer(Handle);
 Coder:=TBFCoder.Create;
 Coder.Key:=CriptKey;

 SNConverter:=TSNIndexConverter.Create;
 SignList:=TSignalDescriptorsList.Create;
 SignList.Add(slAnywhere,' � ���� � � ���� ��������� ');
 SignList.Add(slSubject,' � ���� ��������� ');
 SignList.Add(slBody,' � ���� ��������� ');

 Headers.Active:='Active';
 Headers.Description:='Description';
 with SNConverter do
   begin
    Headers.FValue:='Sender';
    Add(6,ftWhiteSender,'�������� �����/����� � ����� ������',cxTab_Filters,Headers); //����� � ����� ������
    Add(10,ftBlackSender,'�������� �����/����� � ������ ������',cxTab_Filters,Headers); //����� � ������ ������

    Headers.FValue:='File Extension';
    Add(7,ftWhiteAttach,'�������� ���������� ������������ ����� � ����� ������',cxTab_Filters,Headers); // ���������� � ����� ������
    Add(11,ftBlackAttach,'�������� ���������� ������������ ����� � ������ ������',cxTab_Filters,Headers);// ���������� � ������ ������

    Headers.Params:='Location';
    Headers.FValue:='Word';
    Add(4,ftWhiteWord,'�������� ����� � ����� ������',cxTab_Filters,Headers); // ����� � ����� ������
    Add(9,ftBlackWord,'�������� ����� � ������ ������',cxTab_Filters,Headers); // ����� � ������ ������

    Headers.FValue:='Nevod Stamp';
    Add(5,ftStamp,'�������� �����',cxTab_Filters,Headers); // �����
    // ���������� ������� ��-��������
   Add(0,ftNone,'',cxTab_Settings);      // �������� ���������
   Add(1,ftNone,'',cxTab_Accounts);      // ������� ������
   Add(13,ftNone,'',cxTab_Log);
   end;



 FManager:=TFilterManager.Create(adCon);
 AccountManager:=TAccountManager.Create(adAccounts);

 FEditor:=TFCustomEditor.Create(SNConverter,FManager,adFilters,SignList);
 FAccountEditor:=TFAccountEditor.Create(adAccounts,AccountManager);

 adAccounts.Active:=True;

end;


procedure TFMain.FormDestroy(Sender: TObject);
begin
 FManager.Free;
 SNConverter.Free;
 FEditor.Free;
 SignList.Free;
 AccountManager.Free;
 FAccountEditor.Free;
 Coder.Free;
 Exp.Free;
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
 if not DragState then
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
 //cxFilters.Controller.SelectedRecords[];
 FEditor.ShowModal(id,Value,Description,Params,Active,STree.TreeList.FocusedNode.AbsoluteIndex);
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
    Stree.TreeList.Select(STree.TreeList.Items[i]);
    Flag:=True;
   end
  else inc(i);
end;

procedure TFMain.Button3Click(Sender: TObject);
begin
  FAccountEditor.ShowModal;
 //ShowMessage(IntToStr(SettingsTree.Nodes.Count));
// ActivateNode(5);
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
 // ������ ��������������
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

procedure TFMain.dxBarLargeButton1Click(Sender: TObject);
begin
 //FAddAccount.ShowModal;
end;

procedure TFMain.adAccountspassGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
 Text:=Coder.DeCrypt(Trim(Sender.Value))
end;

procedure TFMain.adAccountsTimeoutGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
 Text:=FloatToStr(Sender.AsInteger/(60*1000)); // �� ��������� ���� ������� ��������
end;

procedure TFMain.adAccountsstatusGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
var
 AStatus:TAccountStatus;
begin
 AStatus:=TAccountStatus(GetEnumValue(TypeInfo(TAccountStatus),Sender.Value));
 case AStatus of    //
   asFree: Text:='��������' ;
   asClient:Text:='����������� ����� ' ;
   asServer: Text:='��������� ��������� ������' ;
 end;
end;

procedure TFMain.trayClick(Sender: TObject);
begin
 tray.ShowMainForm;
end;

procedure TFMain.Timer1Timer(Sender: TObject);
begin
tray.ShowBalloonHint('fsdgsgs','fdsafa',bitInfo,10);
end;

procedure TFMain.trayBalloonHintShow(Sender: TObject);
begin
 Caption:='';
end;

end.
