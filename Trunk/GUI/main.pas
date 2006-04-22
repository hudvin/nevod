unit main;

interface

uses Forms,Windows, Dialogs, Registry, dxBar, cxStyles, Shared,
  cxTL, DB, ADODB,  StdCtrls, ExtCtrls, cxContainer, cxEdit,
  cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  SysUtils, Typinfo, FilterManager,

  cxGridCustomView, cxGrid, Menus,
  cxGridCustomPopupMenu, cxGridPopupMenu, Classes, Controls,
  cxGridDBTableView, cxClasses, cxControls, cxPC, cxSplitter,
  cxInplaceContainer, dxStatusBar, cxLookAndFeels,CustomEditor, ActnList,
  XPStyleActnCtrls, ActnMan, 
  ImgList, dxBarExtItems;


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
    ADOQuery1: TADOQuery;
    Button2: TButton;
    Action1: TAction;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure amDeleteAccountExecute(Sender: TObject);
    procedure SettingsTreeSelectionChanged(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure adFiltersParamsGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure Button3Click(Sender: TObject);
  private
    CurrNode:TcxTreeListNode;
    { Private declarations }
  public
    SignList:TSignalDescriptorsList;
    CurrentFilterType:TFilterType;  // ��� �������� �������
    SNConverter:TSNIndexConverter;
 //   PSManager: TPostManager;
    FManager:TFilterManager;
    procedure ActivateNode(NodeIndex:Integer);
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
implementation



{$R *.dfm}
{$R ..\Resources\WinXP.res}



procedure TFMain.RunOnStartup(Run:boolean);
begin
end;

procedure TFMain.FormCreate(Sender: TObject);
var
 Headers:TColumnsHeaders;
begin
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

// Coder.Key:=CriptKey;

 FManager:=TFilterManager.Create(adCon);
 FEditor:=TFCustomEditor.Create(SNConverter,FManager,adFilters,SignList);
end;


procedure TFMain.FormDestroy(Sender: TObject);
begin
 FManager.Free;
 SNConverter.Free;
 FEditor.Free;
 SignList.Free;
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
   //  if (FilterType in [ftBlackWord,ftWhiteWord]) then
     SQL.Text:='SELECT id,FValue,Description,Active,Params '+
                  ' FROM FiltersParams WHERE mid=(SELECT id FROM Filters WHERE Type=:FilterType) ';
    {   else
        begin
         SQL.Add('SELECT FiltersParams.Id, ');
         SQL.Add('FiltersParams.FValue,FiltersParams.Description,Types.Description,FiltersParams.Active  FROM ');
         SQL.Add('FiltersParams,Types WHERE FiltersParams.Params=Types.Type');
         SQL.Add('AND mid=( SELECT id FROM Filters  WHERE Type=:FilterType )');
        end;   }
     Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(Res.FilterType));
     Active:=True;
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

{ if Trim(Sender.Value)='slSubject'
   then  Text:=' � ���� ��������� ';
 if Trim(Sender.Value)='slAnywhere'
   then  Text:=' � ���� � � ���� ��������� ';
 if Trim(Sender.Value)='slBody'
   then  Text:=' � ���� ��������� ';  }
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
 
 ShowMessage(IntToStr(SettingsTree.Nodes.Count));
// ActivateNode(5);
end;

end.
