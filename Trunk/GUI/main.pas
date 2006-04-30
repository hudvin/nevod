unit main;

interface

uses Commctrl, Forms,Windows, Dialogs, Registry, dxBar, cxStyles, Shared, 
  ExtCtrls, Classes, ActnList, CoolTrayIcon, DB, ADODB, StdCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxControls, cxGridCustomView, cxGrid, cxPC, cxSplitter,
  cxInplaceContainer, cxTL, Controls, dxStatusBar,
   cxContainer, cxEdit, WinSock,
  cxCheckBox,  ShellAPI, PortEditor,
  SysUtils, Typinfo, FilterManager, AccountManager,  AccountEditor,  Graphics,

    Menus,   Messages, ThreadManager, POPServer,
  cxGridCustomPopupMenu, cxGridPopupMenu,
   cxLookAndFeels,CustomEditor,
  XPStyleActnCtrls, ActnMan,  Clipbrd, PerlRegEx,
  ImgList, dxBarExtItems,  ToolWin, ActnCtrls, ActnColorMaps,
  ActnPopupCtrl;

 

type 
  TCopyDataStruct = packed record 
    dwData: DWORD;   // anwendungsspezifischer Wert 
    cbData: DWORD;   // Byte-Lдnge der zu ьbertragenden Daten 
    lpData: Pointer; // Adresse der Daten 
  end;
  
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
    Button1: TButton;
    cxTab_Settings: TcxTabSheet;
    Button2: TButton;
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
    AccountsUpdater: TTimer;
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
    Button6: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SettingsTreeSelectionChanged(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure adFiltersParamsGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
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
    procedure alAddAccountExecute(Sender: TObject);
    procedure msAccountsPopup(Sender: TObject);
    procedure alEditAccountExecute(Sender: TObject);
    procedure alDeleteAccountExecute(Sender: TObject);
    procedure alAppTerminateExecute(Sender: TObject);
    procedure AccountsUpdaterTimer(Sender: TObject);
    procedure alStopThreadExecute(Sender: TObject);
    procedure alStartThreadExecute(Sender: TObject);
    procedure alStartAllThreadsExecute(Sender: TObject);
    procedure alStopAllThreadsExecute(Sender: TObject);
    procedure alCanCheckAccountsExecute(Sender: TObject);
    procedure alOnAccountsPopUpExecute(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    adProc: TADOQuery;
    LastHooked:String;  // содержит последний захваченный из буфера элемент
    CurrNode:TcxTreeListNode;
    PrevHwnd: Hwnd;
    Exp:TPerlRegEx;
    procedure ShowNewMail(var Msg: TMessage); message WM_BallonMessage;
    procedure WMChangeCBChain(var Msg: TWMChangeCBChain);
     message WM_CHANGECBCHAIN;
    procedure WMDrawClipboard(var Msg: TWMDrawClipboard);
    message WM_DRAWCLIPBOARD;

    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;

    { Private declarations }
  public
    SignList:TSignalDescriptorsList;
    CurrentFilterType:TFilterType;  // тип текущего фильтра
    TwinFilterType:TFilterType;
    SNConverter:TSNIndexConverter;
     SProvider:TSettings;
 //   PSManager: TPostManager;
    FManager:TFilterManager;
    procedure ActivateNode(NodeIndex:Integer);
    function FindElement(Text:String;SType:TClbHookMode): string;
    procedure MoveElements(NewType:TFilterType);
    procedure RunOnStartup(Run:boolean);
    procedure UpdateHeaders(Headers:TColumnsHeaders);

    { Public declarations }
  protected
    ClbHookMode:TClbHookMode;
    AddClb:TFilterType;
    procedure SetCurrentParams(Grid:TcxGridDBTableView;Filter:TFilterType);
  end;


var
  FMain: TFMain;
  DragState:boolean=False;
  FEditor:TFCustomEditor;
  FPortEditor:TFPortEditor;
  FAccountEditor:TFAccountEditor;
  Coder:TBFCoder;
  AccountManager:TAccountManager;
  ThreadManager:TThreadManager;
  POP3Server:TPOPServer;
  Mutex:THandle;

implementation

uses Unit1, AddHooked, USock;

{$R *.dfm}
{$R ..\Resources\WinXP.res}

function CheckPortForFree(Port:Integer):boolean; External 'Shared.dll';

procedure TFMain.ShowNewMail(var Msg: TMessage);
begin
 Randomize;
 tray.ShowBalloonHint('Получена новая почта','В ящике ' +IntToStr(Random(1000)) +' новых сообщений',bitInfo,10);

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
  buf,Res:String;

begin
  SendMessage(PrevHWnd, WM_DRAWCLIPBOARD, 0, 0);
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    H := Clipboard.GetAsHandle(CF_TEXT);
    Len := GlobalSize(H) + 1;
    P := GlobalLock(H);
    if (Length(Trim(p))=Length(p) ) and (pos(' ',p)=0) then
     begin
      buf:=FindElement(P,CLbHookMode);
      if buf<>'' then
       if not FManager.ElementExists(buf,AddClb) then
        begin
         FManager.AddElement(buf,AddClb,'',True,'');
         LastHooked:=buf;
        end;
     end
      else LastHooked:='';


   //   tray.ShowBalloonHint('Balloon hint',Exp.MatchedExpression, bitInfo, 10);

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
 TmAppl:boolean;
begin

 FPortEditor:=TFPortEditor.Create(adCon);
 Mutex:=CreateMutex(nil, False,MutexName);
 AccountManager:=TAccountManager.Create(adAccounts);
 SProvider:=TSettings.Create(adCon);

 SNConverter:=TSNIndexConverter.Create;
 SignList:=TSignalDescriptorsList.Create;
 SignList.Add(slAnywhere,' в теле и в теме сообщения ');
 SignList.Add(slSubject,' в теме сообщения ');
 SignList.Add(slBody,' в теле сообщения ');

 Headers.Active:='Active';
 Headers.Description:='Description';
 with SNConverter do
   begin
    Headers.FValue:='Sender';
    Add(6,ftWhiteSender,'Добавить адрес/домен в белый список',cxTab_Filters,Headers); //адрес в белый список
    Add(10,ftBlackSender,'Добавить адрес/домен в черный список',cxTab_Filters,Headers); //адрес в черный список

    Headers.FValue:='File Extension';
    Add(7,ftWhiteAttach,'Добавить расширений приложенного файла в белый список',cxTab_Filters,Headers); // расширение в белый список
    Add(11,ftBlackAttach,'Добавить расширений приложенного файла в черный список',cxTab_Filters,Headers);// расширение в черный список

    Headers.Params:='Location';
    Headers.FValue:='Word';
    Add(4,ftWhiteWord,'Добавить слово в белый список',cxTab_Filters,Headers); // слово в белый список
    Add(9,ftBlackWord,'Добавить слово в черный список',cxTab_Filters,Headers); // слово в черный список

    Headers.FValue:='Nevod Stamp';
    Add(5,ftStamp,'Добавить штамп',cxTab_Filters,Headers); // штамп
    // добавление панелей не-фильтров
   Add(0,ftNone,'',cxTab_Settings);      // основные настройки
   Add(1,ftNone,'Accounts',cxTab_Accounts);      // учетные записи
   Add(13,ftNone,'',cxTab_Log);
   end;

 POP3Server:=TPOPServer.Create(adCon,AccountManager);
 TmAppl:=False;
 if not POP3Server.LoadParams then
   if MessageBox(Handle,' Ошибка запуска сервера ',' Стандартный порт фильтра занят. Хотите сменить порт ? ',MB_OKCANCEL)=IDOK then
    begin
     while (not POP3Server.LoadParams) and (not TmAppl) do
      begin
       FPortEditor.ShowModal;
       if FPortEditor.CanExit=True then
        TmAppl:=True;
      end;
     if TmAppl then
      Application.Terminate;
    end
  else
   Application.Terminate;


 FManager:=TFilterManager.Create(adCon);
 Exp:=TPerlRegEx.Create(nil);

 AddClb:=TFilterType(GetEnumValue(TypeInfo(TFilterType),SProvider.GetValue('AddClb')));
 ClbHookMode:=TClbHookMode(GetEnumValue(TypeInfo(TCLbHookMode),SProvider.GetValue('ClbHookMode')));

 adProc:=TADOQuery.Create(nil);
 adProc.Connection:=adCon;

 PrevHwnd := SetClipboardViewer(Handle);
 Coder:=TBFCoder.Create;
 Coder.Key:=CriptKey;








 FEditor:=TFCustomEditor.Create(SNConverter,FManager,adFilters,SignList);
 FAccountEditor:=TFAccountEditor.Create(adAccounts,AccountManager);

 adAccounts.Active:=True;

 ThreadManager:=TThreadManager.Create(adCon,AccountManager);

end;


procedure TFMain.FormDestroy(Sender: TObject);
begin
 POP3Server.Free;
 tray.Enabled:=False;
 ThreadManager.Free;
 FManager.Free;
 SNConverter.Free;
 FEditor.Free;
 SignList.Free;
 AccountManager.Free;
 FAccountEditor.Free;
 //FPortEditor.Free;
 Coder.Free;
 Exp.Free;
 SProvider.Free;
 adProc.Free;

 CloseHandle(Mutex);

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
 // начало перетаскивания
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
 Text:=FloatToStr(Sender.AsInteger/(60*1000)); // не допускать ввод нулевых значений
end;

function TFMain.FindElement(Text:String;SType:TClbHookMode): string;
var
 RegStr:String;
begin
 case SType of
   chURL:
    begin
     Exp.Subject:=Text;
     Exp.RegEx:='(?i)(http://www.|http://|www.)([_a-z\d\-]+(\.[_a-z\d\-]+)+)((/[ _a-z\d\-\\\.]+)+)*';
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
   asFree: Text:='свободен' ;
   asClient:Text:='загружается почта ' ;
   asServer: Text:='подключен локальный клиент' ;
 end;
end;

procedure TFMain.trayClick(Sender: TObject);
begin
 tray.ShowMainForm;
end;

procedure TFMain.alAddAccountExecute(Sender: TObject);
var
 buf:TSNConvert;
begin
 SNConverter.FindByName('Accounts',buf);
 ActivateNode(buf.NodeIndex);
 FAccountEditor.ShowModal;
end;

procedure TFMain.msAccountsPopup(Sender: TObject);
begin
 alOnAccountsPopUp.Execute;
end;

procedure TFMain.alEditAccountExecute(Sender: TObject);
var
 AccountId:integer;
begin
 AccountId:= cxAccounts.Controller.SelectedRows[0].Values[cxAccountsid.Index];
 FAccountEditor.ShowModal(AccountId);
end;

procedure TFMain.alDeleteAccountExecute(Sender: TObject);
var
 AccountId:integer;
begin
 AccountId:= cxAccounts.Controller.SelectedRows[0].Values[cxAccountsid.Index];
 if Application.MessageBox('Are you are sure ?','Deleting Account',MB_OKCANCEL)=IDOK then
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
begin
 with Msg.CopyDataStruct^ do
  begin
   mess:=TWMMessanger(lpdata^);
   tray.ShowBalloonHint(mess.Caption,mess.LogMessage,mess.BallonType,10);
  end;
end;



procedure TFMain.AccountsUpdaterTimer(Sender: TObject);
begin
 if FMain.Active then adAccounts.Requery;
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
// alCanCheckAccounts.Checked:=NOT alCanCheckAccounts.Checked;
 SProvider.SetValue('CanCheckAccounts',BoolToStr(NOT alCanCheckAccounts.Checked,True));
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

procedure TFMain.Button6Click(Sender: TObject);
var
FAddr: TSockAddrIn;
FSocket:TSocket;
wsaD: WSADATA;
begin
FSocket := socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
FAddr.sin_family := AF_INET;
FAddr.sin_addr.s_addr := INADDR_ANY;
FAddr.sin_port := htons(11000);
 if WSAStartup($101, WsaD) = 0 then
  begin
if bind(FSocket, FAddr, SizeOf(FAddr))=SOCKET_ERROR then
  showmessage('Немогу создать');
 WSACleanUp;
 closesocket(FSocket);
 end;
end;

procedure TFMain.Button3Click(Sender: TObject);
var
 t:TPOPServer;
begin
 t:=TPOPServer.Create(adCon,AccountManager);
 if not t.LoadParams then
  ShowMessage('Выберите другой порт');
   
   
end;

procedure TFMain.Button4Click(Sender: TObject);
begin
if CheckPortForFree(11100) then
   ShowMessage('!!!!'); 
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 tray.Enabled:=False;
 Hide;
end;

end.
