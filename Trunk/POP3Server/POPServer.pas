unit POPServer;

interface
uses
    Shared,Windows,Dialogs,Classes,ASFilter, Messages, SysUtils,IdContext, StdCtrls,
     ADODB, IdBaseComponent, IdComponent, Math, IdCommandHandlers,WinSock,
     IdTCPServer, IdPOP3Server,  AccountManager,DBTables;

type
  TPOP3ServerContext = class;
 TPOPServer=class
  private
   FAccountManager: TAccountManager;
   FADOCon: TADOConnection;
   Mutex: THandle;
   SProvider: TSettings;
   function BindPort(Port:integer): Boolean;
   procedure CheckAccount(AThread: TIdContext;LThread: TIdPOP3ServerContext);
   procedure Connect(AContext: TIdContext);
   procedure QUIT(ASender: TIdCommand);
   procedure STAT(ASender: TIdCommand);
   procedure Disconnect(AContext: TIdContext);
   function GetLocalIP: String;
   function GetServerPort: Integer;
   procedure LIST(ASender: TIdCommand; AMessageNum: Integer);
   procedure SetServerPort(const Value: Integer);
 public
   pop: TIdPOP3Server;
   constructor Create(ADOCon:TADOConnection; AccountManager:TAccountManager);
   destructor  Destroy(); override;
   procedure DELE(ASender: TIdCommand; AMessageNum: Integer);
   procedure Disable;
   function LoadParams: Boolean;
   procedure RETR(ASender: TIdCommand; AMessageNum: Integer);
   property ServerPort: Integer read GetServerPort write SetServerPort;
end;

  TPOP3ServerContext = class
  private
    AllowFilter: TAllowFilterGroup;
    DenyFilter: TDenyFilterGroup;
    FAccountId: Integer;
    FadProc: TADOQuery;
    FSettings: TSettings;
    procedure SetadProc(const Value: TADOQuery);
    procedure SetSettings(const Value: TSettings);
  public
    constructor Create(AccountId:integer;adCon:TADOConnection);
    destructor Destroy; override;
    property AccountId: Integer read FAccountId write FAccountId;
    property adProc: TADOQuery read FadProc write SetadProc;
    property Settings: TSettings read FSettings write SetSettings;
  end;

implementation

uses DB, IdTCPConnection, IdTask,main;

constructor TPOPServer.Create(ADOCon:TADOConnection;
    AccountManager:TAccountManager);
begin
 Mutex:=CreateMutex(nil,False,MutexName);
 FADOCon:=ADOCon;
 SProvider:=TSettings.Create(ADOCon);
 FAccountManager:=AccountManager;
 pop:=TIdPOP3Server.Create(nil);
 with pop do
  begin
    CheckUser:=CheckAccount;
    OnDisconnect:=Disconnect;
    OnConnect:=Connect;
    OnQUIT:=QUIT;
    OnSTAT:=STAT;
    OnLIST:=LIST;
    OnDELE:=DELE;
    OnRETR:=RETR;
 end;
end;

function TPOPServer.LoadParams: Boolean;
var
 Port:integer;
begin
 try
 pop.Active:=False;
 Port:=ServerPort;
 if not (BindPort(Port)) then
  Result:=False
   else
    begin
     pop.DefaultPort:=Port;
     pop.Active:=True;
     Result:=True;
    end;

 except
  Result:=False;
 end;
end;

destructor TPOPServer.Destroy();
begin
 pop.Active:=False;
 pop.Free;
 SProvider.Free;
 FADOCon:=nil;
 CloseHandle(Mutex);
end;

function TPOPServer.BindPort(Port:integer): Boolean;
var
 FAddr: TSockAddrIn;
 FSocket:TSocket;
 wsaD: WSADATA;
begin
 Result:=True;
 FSocket := socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
 FAddr.sin_family := AF_INET;
 FAddr.sin_addr.s_addr := INADDR_ANY;
 FAddr.sin_port := htons(Port);
 if WSAStartup($101, WsaD) = 0 then
  begin
   if bind(FSocket, FAddr, SizeOf(FAddr))=SOCKET_ERROR then
    Result:=False;
   WSACleanUp;
   closesocket(FSocket);
  end;
end;

procedure TPOPServer.CheckAccount(AThread: TIdContext;LThread:
    TIdPOP3ServerContext);
var
    Password,Username:string;
    AParams:TAccountParams;
    id:integer;
    i:integer;
    AContext:TPOP3ServerContext;
begin
 WaitForSingleObject(Mutex,INFINITE);
  if AThread.Connection.Socket.Binding.PeerIP<>GetLocalIP // проверка на допустимость адреса клиента
   then AThread.Connection.Socket.Close;
  Password:=LThread.Password;
  Username:=LThread.Username;
  Id:=FAccountManager.AccountName2Id(Username);
  AContext:=TPOP3ServerContext.Create(Id,FADOCon);
  if Id<>-1 then
  begin
  AParams:=FAccountManager.AccountById[Id];
   if AParams.Password=Password then
     case AParams.Status of    //
       asFree:                // ящик свободен
        with AContext.adProc do
          begin
           FAccountManager.SetStatus(AParams.Id,asServer);
           Active:=False;
           SQL.Text:='UPDATE Messages SET Deleted=False WHERE mid=:AccountId AND Deleted=TRUE';
           Parameters.ParamByName('AccountId').Value:=AParams.Id;
           ExecSQL;
           Active:=False;
           SQL.Text:='SELECT id,num FROM Messages WHERE mid=:AccountId';
           Parameters.ParamByName('AccountId').Value:=AParams.Id;
           Active:=True;
           i:=1;
           while (not Eof) do
            begin
             Edit;
             FieldByName('num').Value:=i;
             Post;
             inc(i);
             Next;
            end;
           Active:=false;
          LThread.State:=Trans;
          LThread.Connection.Tag:=Integer(AContext);
        end;
       asClient:  // выполняется получение новой почты
        begin
          AContext.AccountId:=0;
          LThread.Connection.Tag:=Integer(AContext);
          LThread.State:=Trans;
        end;
     else     // доступ запрещен
      begin
        AContext.AccountId:=-1;
        LThread.Connection.Tag:=Integer(AContext);
      end;
     end;    // case
  end;
 ReleaseMutex(Mutex);
end;

procedure TPOPServer.Connect(AContext: TIdContext);
begin
 AContext.Connection.Tag:=-1;
end;

procedure TPOPServer.DELE(ASender: TIdCommand; AMessageNum: Integer);
var
    AccountId:integer;
    Cont:TPOP3ServerContext;
begin
 Cont:=TPOp3ServerContext(ASender.Context.Connection.Tag);
 AccountId:=Cont.AccountId;
 if AccountId=0 then   // если статус asClient
  ASender.Reply.SetReply(ERR, ' No such message ! ');
 if AccountId>0 then
  with Cont.adProc do
    begin
     SQL.Text:='SELECT id,deleted FROM messages WHERE mid=:AccountId AND num=:MessNum AND Deleted=FALSE';
     Parameters.ParamByName('AccountId').Value:=AccountId;
     Parameters.ParamByName('MessNum').Value:=AMessageNum;
     Active:=True;
     if RecordCount=0 then ASender.Reply.SetReply(ERR, 'No such message')
      else
       begin
        Edit;
        FieldByName('deleted').AsBoolean:=true;
        Post;
       end;
     Active:=False;
    end;
end;

procedure TPOPServer.Disable;
begin
 try
 pop.Free;// Active:=false;
 except
 end;
end;



procedure TPOPServer.Disconnect(AContext: TIdContext);
var
    Cont:TPOP3ServerContext;
begin
 try
 // AContext.Connection.Socket.Close;
  if (AContext.Connection.Tag<>-1)and (TPOP3ServerContext(AContext.Connection.Tag).AccountId<>-1) then  // если -1 - ничего не делать - клиент просто отключился или доступ запрещен
   begin
    Cont:=TPOP3ServerContext(AContext.Connection.Tag);
      WaitForSingleObject(Mutex,INFINITE);
       FAccountManager.SetStatus(Cont.AccountId,asFree);
      ReleaseMutex(Mutex);
    TPOP3ServerContext(AContext.Connection.Tag).Destroy;
   end;
 except
 end;
end;

function TPOPServer.GetLocalIP: String;
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
  end;
end;

function TPOPServer.GetServerPort: Integer;
begin
 Result:=StrToInt(SProvider.GetValue('ServerPort'));
end;

procedure TPOPServer.LIST(ASender: TIdCommand; AMessageNum: Integer);
var
    AccountId:integer;
    Cont:TPOP3ServerContext;
begin
 try
   Cont:=TPOp3ServerContext(ASender.Context.Connection.Tag);
   AccountId:=Cont.AccountId;
   {-----------------------------Если загружается почта из Инета----------------------------------}
   if AccountId=0 then   // если статус asClient
    if AMessageNum=-1 then  ASender.Reply.SetReply(OK, '0 0')  // показ всех писем
     else ASender.Reply.SetReply(ERR, 'No such message'); // показ определенного сообщения
   {-----------------------------Если можно отдавать почту----------------------------------------}
   if AccountId>0 then
    begin
     if AMessageNum=-1 then   // вывести все сообщения
      with Cont.adProc do
        begin
         Active:=False;
         SQL.Text:='SELECT num,MessSize FROM Messages WHERE mid=:AccountId AND Deleted=False';
         Parameters.ParamByName('AccountId').Value:=AccountId;
         Active:=True;
         if RecordCount>0 then // если есть сообщения
          while not EOF do
           begin
            ASender.Response.Add(IntToStr(FieldByName('num').AsInteger)+ ' ' +IntToStr(FieldByName('messsize').AsInteger));
            Next;
           end
            else  ASender.Reply.SetReply(OK, '0 0');
         Active:=False;
        end;
     if AMessageNum>0 then    // если указан номер сообщения
      with Cont.adProc do
        begin
         Active:=False;
         SQL.Text:='SELECT num,MessSize FROM Messages WHERE mid=:AccountId AND Deleted=False AND num=:MessNum';
         Parameters.ParamByName('AccountId').Value:=AccountId;
         Parameters.ParamByName('MessNum').Value:=AMessageNum;
         Active:=True;
         if RecordCount=0 then  ASender.Reply.SetReply(ERR, 'No such message')
          else
            ASender.Reply.SetReply(OK,IntToStr(RecNo)+ ' ' +IntToStr(FieldByname('MessSize').AsInteger));
         Active:=False;
        end;
    end;
 except

 end;
end;

procedure TPOPServer.QUIT(ASender: TIdCommand);
var
    AccountId:integer;
    Cont:TPOP3ServerContext;
begin
 Cont:=TPOp3ServerContext(ASender.Context.Connection.Tag);
 AccountId:=Cont.AccountId;
 if AccountId>0 then
   with Cont.adProc do
     begin
       Active:=False;
       SQL.Text:='DELETE FROM Messages WHERE mid=:AccountId AND Deleted=TRUE';
       Parameters.ParamByName('AccountId').Value:=AccountId;
       ExecSQL;
     end;
end;

procedure TPOPServer.RETR(ASender: TIdCommand; AMessageNum: Integer);
var
   AccountId:integer;
   Cont:TPOP3ServerContext;
   MessStream:TMemoryStream;
   Mess:TFMessage;
begin
 Cont:=TPOp3ServerContext(ASender.Context.Connection.Tag);
 AccountId:=Cont.AccountId;
 if AccountId=0
  then  ASender.Reply.SetReply(ERR, 'No such message')
   else
    with Cont.adProc do
      begin
       SQL.Text:='SELECT Message FROM Messages WHERE num=:AMessageNum AND Deleted=False AND mid=:AccountId';
       Parameters.ParamByName('AMessageNum').Value:=AMessageNum;
       Parameters.ParamByName('AccountId').Value:=AccountId;

       Active:=True;
       if RecordCount=0 then  ASender.Reply.SetReply(ERR, 'No such message')
        else
         begin
          
          MessStream:=TMemoryStream.Create;
          Mess:=TFMessage.Create;
          TBlobField(FieldByName('Message')).SaveToStream(MessStream);
          MessStream.Position:=0;
          if StrToBool(Cont.Settings.GetValue('EnableFiltering')) then
           begin
            Mess.LoadFromStream(MessStream);
            if StrToBool(Cont.Settings.GetValue('EnableFiltering')) then
             begin
              if Cont.AllowFilter.AnalyzeMessage(Mess) then
               Mess.Subject:=Cont.AllowFilter.Reason
              else
               if Cont.DenyFilter.AnalyzeMessage(Mess) then
                mess.Subject:=Cont.DenyFilter.Reason;
             end;
            MessStream.Clear;
            Mess.SaveToStream(MessStream);
           end;

          messStream.Position:=0;
          ASender.Reply.SetReply(OK,'');
          MessStream.Size:=MessStream.Size-3;
          ASender.Response.LoadFromStream(MessStream);
          MessStream.Free;
          Mess.Free;

         end;
      end;
end;

procedure TPOPServer.SetServerPort(const Value: Integer);
begin
 SProvider.SetValue('ServerPort',IntToStr(Value));
end;

procedure TPOPServer.STAT(ASender: TIdCommand);
var
 MessCount,MessSize:Integer;
 AccountId:integer;
 Cont:TPOP3ServerContext;
begin
 Cont:=TPOp3ServerContext(ASender.Context.Connection.Tag);
 AccountId:=Cont.AccountId;
  if AccountId>0 then
   with Cont.adProc do
     begin
      // получение количества сообщений
      Active:=False;
      SQL.Text:='SELECT COUNT(Id) FROM messages WHERE mid=:AccountId AND Deleted=False ';
      Parameters.ParamByName('AccountId').Value:=AccountId;
      Active:=True;
      MessCount:=Fields[0].AsInteger;
      Active:=False;
      // получение объема сообщений
      SQL.Text:='SELECT SUM(MessSize) FROM messages WHERE mid=:AccountId AND Deleted=False ';
      Parameters.ParamByName('AccountId').Value:=AccountId;
      Active:=True;
      MessSize:=Fields[0].AsInteger;

      ASender.Reply.SetReply(OK,IntToStr(MessCount)+ ' '+ IntToStr(MessSize));
     end
  else
   ASender.Reply.SetReply(OK, '0 0');
end;

constructor TPOP3ServerContext.Create(AccountId:integer;adCon:TADOConnection);
begin
  FadProc:=TADOQuery.Create(nil);
  FadProc.Connection:=adCon;
  FAccountId:=AccountId;
  AllowFilter:=TAllowFilterGroup.Create(adCon);
  DenyFilter:=TDenyFilterGroup.Create(adCon);
  FSettings:=TSettings.Create(adCon);
end;

destructor TPOP3ServerContext.Destroy;
begin
  AllowFilter.Free;
  DenyFilter.Free;
  FadProc.Free;
  Settings.Free;
end;

procedure TPOP3ServerContext.SetadProc(const Value: TADOQuery);
begin
  if FadProc <> Value then
  begin
    FadProc := Value;
  end;
end;

procedure TPOP3ServerContext.SetSettings(const Value: TSettings);
begin
  if FSettings <> Value then
  begin
    FSettings := Value;
  end;
end;

end.
