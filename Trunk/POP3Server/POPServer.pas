unit POPServer;

interface
uses
    Shared,Windows,Dialogs,Classes, Messages, SysUtils,IdContext, StdCtrls,
     ADODB, IdBaseComponent, IdComponent, Math, IdCommandHandlers,WinSock,
     IdTCPServer, IdPOP3Server,  AccountManager,DBTables;

type
 TPOPServer=class
  private
   FAccountManager: TAccountManager;
   FADOCon: TADOConnection;
   Mutex: THandle;
   pop:TIdPOP3Server;
   SProvider: TSettings;
   function BindPort(Port:integer): Boolean;
   procedure CheckAccount(AThread: TIdContext;LThread: TIdPOP3ServerContext);
   procedure Connect(AContext: TIdContext);
   procedure QUIT(ASender: TIdCommand);
   procedure STAT(ASender: TIdCommand);
   procedure Disconnect(AContext: TIdContext);
   function GetServerPort: Integer;
   procedure LIST(ASender: TIdCommand; AMessageNum: Integer);
   procedure SetServerPort(const Value: Integer);
 public
   constructor Create(ADOCon:TADOConnection; AccountManager:TAccountManager);
   destructor  Destroy(); override;
   procedure DELE(ASender: TIdCommand; AMessageNum: Integer);
   function LoadParams: Boolean;
   procedure RETR(ASender: TIdCommand; AMessageNum: Integer);
   property ServerPort: Integer read GetServerPort write SetServerPort;
end;

implementation

uses DB, IdTCPConnection, IdTask;

constructor TPOPServer.Create(ADOCon:TADOConnection;
    AccountManager:TAccountManager);
begin

 Mutex:=CreateMutex(nil,False,MutexName);
 FADOCon:=ADOCon;
 SProvider:=TSettings.Create(ADOCon);
 FAccountManager:=AccountManager;
 pop:=TIdPOP3Server.Create(nil);

// pop.DefaultPort:=DefaultPort;
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
  // Active:=true;
 end;
end;

function TPOPServer.LoadParams: Boolean;
var
 Port:integer;
begin
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
    Password,Username,Server:string;
    AParams:TAccountParams;
    id:integer;
    Proc:TADOQuery;
begin
 WaitForSingleObject(Mutex,INFINITE);
 Proc:=TADOQuery.Create(nil);
 Proc.Connection:=FADOCon;
 // нафига тут мьютекс ?    - а затем, чтобы несколько клиентов не залогинилось одновременно под одним паролем
  Password:=LThread.Password;
  Username:=LThread.Username;

  //Lthread.Data:=Proc;

  Id:=FAccountManager.AccountName2Id(Username);
  if Id<>-1 then
  begin
   AParams:=FAccountManager.AccountById[Id];
   if AParams.Password=Password then
     case AParams.Status of    //
       asFree:                // ящик свободен
        begin
          FAccountManager.SetStatus(AParams.Id,asServer);

          Proc.SQL.Text:='UPDATE Messages SET Deleted=False WHERE mid=:AccountId AND Deleted=TRUE';
           {
           обновление статуса сообщений, если соединение было разорвано
           }
          Proc.Parameters.ParamByName('AccountId').Value:=AParams.Id;
          Proc.ExecSQL;
          LThread.Connection.Tag:=AParams.Id;
          LThread.State:=Trans;
        end;
       asClient:  // выполняется получение новой почты
        begin
         // LThread.Connection.Tag:=AParams.Id;
          LThread.Connection.Tag:=0;
          LThread.State:=Trans;
        end;
     else
       LThread.Connection.Tag:=-1;  // доступ запрещен
     end;    // case
  end;
 Proc.Free;
 ReleaseMutex(Mutex);
end;

procedure TPOPServer.Connect(AContext: TIdContext);
begin
 AContext.Connection.Tag:=-1;
end;

procedure TPOPServer.DELE(ASender: TIdCommand; AMessageNum: Integer);
var
    AccountId,MessCount:integer;
    Proc:TADOQuery;
    Flag:boolean;

begin
 AccountId:=ASender.Context.Connection.Tag;
 if AccountId=0 then   // если статус asClient
  ASender.Reply.SetReply(ERR, ' No such message ! ');
 if AccountId>0 then
  begin
   Proc:=TADOQuery.Create(nil);
   Proc.Connection:=FADOCon;
   Proc.SQL.Text:='SELECT id,deleted FROM messages WHERE mid=:AccountId  '; // не делать выборку всех полей
   Proc. Parameters.ParamByName('AccountId').Value:=AccountId;
   Proc.Active:=True;
   if AMessageNum>Proc.RecordCount then  ASender.Reply.SetReply(ERR, 'No such message')
    else
     begin
     // Proc.SQL.Text:='SELECT deleted FROM Messages WHERE Id=:AccountId ';
    //  Proc.Parameters.ParamByName('AccountId').Value:=AccountId;
      Proc.RecNo:=AMessageNum;
      if not Proc.FieldByName('deleted').AsBoolean then
        begin
         Proc.Edit;
         Proc.FieldByName('deleted').AsBoolean:=true;
         Proc.Post;
         ASender.Reply.SetReply(OK, 'Message deleted');
        end
         else    ASender.Reply.SetReply(ERR,'No such message');
     end;
   Proc.Free;
  end;
end;



procedure TPOPServer.Disconnect(AContext: TIdContext);
var
    AccountId:integer;
begin
 // если -1 - ничего не делать - клиент просто отключился или доступ запрещен
 AccountId:=AContext.Connection.Tag;
 if AccountId>0 then
  begin
   WaitForSingleObject(Mutex,INFINITE);
     FAccountManager.SetStatus(AccountId,asFree);
   ReleaseMutex(Mutex);
  end //
  else // если -1 или 0
   begin

   end;
end;

function TPOPServer.GetServerPort: Integer;
begin
 Result:=StrToInt(SProvider.GetValue('ServerPort'));
end;

procedure TPOPServer.LIST(ASender: TIdCommand; AMessageNum: Integer);
var
    AccountId,MessCount:integer;
    Proc:TADOQuery;
    Flag:boolean;

begin
 AccountId:=ASender.Context.Connection.Tag;
 if AccountId=0 then   // если статус asClient
   if AMessageNum=-1 then  ASender.Reply.SetReply(OK, '0 0')
    else ASender.Reply.SetReply(ERR, 'No such message')
  else // если получение разрешено
   begin
    Proc:=TADOQuery.Create(nil);
    Proc.Connection:=FADOCon;
    Proc.SQL.Text:='SELECT MessSize FROM messages WHERE mid=:AccountId AND Deleted=False ';
    Proc. Parameters.ParamByName('AccountId').Value:=AccountId;
    Proc.Active:=True;
    MessCount:=Proc.RecordCount;
    Proc.Close;
    if AMessageNum=-1 then          // вывести весь список сообщений или указать что ящик пуст
      if MessCount=0 then          // если ящик пустой
        begin
         ASender.Reply.SetReply(OK, '0 0');
         ASender.Response.Add('.');
        end
       else // если сообщения есть - выполнить запрос и вывести данные о сообщении
        begin
         Proc. Open;
         Proc.First;
         while not Proc.EOF do
           begin
            ASender.Response.Add(IntToStr(Proc.RecNo)+ ' ' +IntToStr(Proc.Fields[0].AsInteger));
            Proc.Next;
           end;
        end;
    if AMessageNum>0 then
     begin
       Proc.Open;
       if (AMessageNum<=Proc.RecordCount) and (AMessageNum>0) then
        begin
         Proc.RecNo:=AMessageNum;
         ASender.Reply.SetReply(OK,IntToStr(Proc.RecNo)+ ' ' +IntToStr(Proc.Fields[0].AsInteger));
        end
         else ASender.Reply.SetReply(ERR, 'No such message');
     end;
    Proc.Free;
   end;

end;

procedure TPOPServer.QUIT(ASender: TIdCommand);
var
    AccountId:integer;
    Proc:TADOQuery;
begin
 {
 если id  равен 0 - ничего не делать
 }
  AccountId:=ASender.Context.Connection.Tag;
  if AccountId>0 then
   begin
    Proc:=TADOQuery.Create(nil);
    Proc.Connection:=FADOCon;
    Proc.SQL.Text:='DELETE FROM Messages WHERE mid=:AccountId AND Deleted=TRUE';
    Proc.Parameters.ParamByName('AccountId').Value:=AccountId;
    Proc.ExecSQL;
    Proc.Free;
   end;
end;

procedure TPOPServer.RETR(ASender: TIdCommand; AMessageNum: Integer);
var
   AccountId:integer;
   Proc:TADOQuery;
   MessCount,MessSize:Integer;
   MessStream,outp:TMemoryStream;
   comp:TCompressor;
   buff:integer;
   bn:String;
   const
  s: string = '';

begin
AccountId:=ASender.Context.Connection.Tag;
 if AccountId=0
  then  ASender.Reply.SetReply(ERR, 'No such message')
   else
    begin
     Proc:=TADOQuery.Create(nil);
     Proc.CacheSize:=20;
     Proc.Connection:=FADOCon;
    // Proc.SQL.Text:='SELECT * FROM messages WHERE mid=:AccountId AND Deleted=False ';
    Proc.SQL.Text:='SELECT TOP 1 message FROM ( SELECT TOP 10 id,message FROM messages WHERE mid=26 ORDER BY id) ORDER BY  id DESC';
   //  Proc. Parameters.ParamByName('AccountId').Value:=AccountId;
     Proc.Active:=True;
   //  if AMessageNum>Proc.RecordCount
   if  Proc.RecordCount=0
   // then
      then ASender.Reply.SetReply(ERR, 'No such message')
      else
       begin
        Proc.RecNo:=AMessageNum;
        MessStream:=TMemoryStream.Create;
        ASender.Reply.SetReply(OK,'');

      //  TBlobField(Proc.FieldByName('Message')).SaveToStream(MessStream);
      //  MessStream.Size:=MessStream.Size-3;
     //   MessSTream.Position:=0;
    //  ASender.Response.Add(Proc.FieldDef]);
       ASender.Response.Add(Proc.FieldByName('Message').AsString);
       // ASender.Response.LoadFromStream(MessStream);
        MessStream.Free;
       end;
     Proc.Active:=False;
     Proc.Free;
   end;
end;

procedure TPOPServer.SetServerPort(const Value: Integer);
begin
 SProvider.SetValue('ServerPort',IntToStr(Value));
end;

procedure TPOPServer.STAT(ASender: TIdCommand);
var
 AccountId:integer;
 Proc:TADOQuery;
 MessCount,MessSize:Integer;
begin
  AccountId:=ASender.Context.Connection.Tag;
  if AccountId>0 then
   with Proc do
     begin
      // получение количества сообщений
      Proc:=TADOQuery.Create(nil);
      Proc.Connection:=FADOCon;
      SQL.Text:='SELECT COUNT(Id) FROM messages WHERE mid=:AccountId AND Deleted=False ';
      Parameters.ParamByName('AccountId').Value:=AccountId;
      Active:=True;
      MessCount:=Fields[0].AsInteger;
      Close;
      // получение объема сообщений
      SQL.Text:='SELECT SUM(MessSize) FROM messages WHERE mid=:AccountId AND Deleted=False ';
      Parameters.ParamByName('AccountId').Value:=AccountId;
      Active:=True;
      MessSize:=Fields[0].AsInteger;

      ASender.Reply.SetReply(OK,IntToStr(MessCount)+ ' '+ IntToStr(MessSize));
      Proc.Free;
     end
  else ASender.Reply.SetReply(OK, '0 0');
end;

end.
