unit POPServer;

interface
uses
    Shared,Windows,Dialogs,Classes, Messages, SysUtils,IdContext, StdCtrls,
     ADODB, IdBaseComponent, IdComponent, Math, IdCommandHandlers,
     IdTCPServer, IdPOP3Server, Settings, AccountManager,DBTables;

type
 TPOPServer=class
  private
   ContextProcs: TAccountContextList;
   FAccountManager: TAccountManager;
   FADOCon: TADOConnection;
   FDefaultPort: Integer;
   Mutex: THandle;
   pop:TIdPOP3Server;
   procedure CheckAccount(AThread: TIdContext;LThread: TIdPOP3ServerContext);
   procedure Connect(AContext: TIdContext);
   procedure QUIT(ASender: TIdCommand);
   procedure STAT(ASender: TIdCommand);
   procedure Disconnect(AContext: TIdContext);
   procedure LIST(ASender: TIdCommand; AMessageNum: Integer);
   procedure SetDefaultPort(const Value: Integer);
 public
   constructor Create(ADOCon:TADOConnection; AccountManager:TAccountManager;
       ServerPort:integer);
   destructor  Destroy(); override;
   procedure DELE(ASender: TIdCommand; AMessageNum: Integer);
   procedure RETR(ASender: TIdCommand; AMessageNum: Integer);
   property DefaultPort: Integer read FDefaultPort write SetDefaultPort;
end;

implementation

uses IdCustomTCPServer, DB;

constructor TPOPServer.Create(ADOCon:TADOConnection;
    AccountManager:TAccountManager;ServerPort:integer);
begin
 Mutex:=CreateMutex(nil,False,MutexName);
 FADOCon:=ADOCon;
 ContextProcs:=TAccountContextList.Create(FADOCon);
 FDefaultPort:=ServerPort;
 FAccountManager:=AccountManager;
 pop:=TIdPOP3Server.Create(nil);

 pop.DefaultPort:=DefaultPort;
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
   Active:=true;
 end;
end;

destructor TPOPServer.Destroy();
begin
 pop.Active:=False;
 pop.Free;
 ContextProcs.Free;
 FADOCon:=nil;
 CloseHandle(Mutex);
end;

procedure TPOPServer.CheckAccount(AThread: TIdContext;LThread:
    TIdPOP3ServerContext);
var
    Password,Username:string;
    AParams:TAccountParams;
    id:integer;
    Proc:TADOQuery;
begin
 WaitForSingleObject(Mutex,INFINITE);
 // нафига тут мьютекс ?
  Password:=LThread.Password;
  Username:=LThread.Username;
  Id:=FAccountManager.AccountName2Id(Username);
  if Id<>-1 then
  begin
   AParams:=FAccountManager.AccountById[Id];
   if AParams.Password=Password then
     case AParams.Status of    //
       asFree:                // ящик свободен
        begin
          FAccountManager.SetStatus(AParams.Id,asServer);
          ContextProcs.AddContext(AParams.Id);
          Proc:=ContextProcs.GetContext(AParams.Id).MessProc;
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
   Proc:=ContextProcs.GetContext(AccountId).MessProc;
   Proc.SQL.Text:='SELECT * FROM messages WHERE mid=:AccountId  '; // не делать выборку всех полей
   Proc. Parameters.ParamByName('AccountId').Value:=AccountId;
   Proc. ExecSQL;
   Proc. Open;
   if AMessageNum>Proc.RecordCount then  ASender.Reply.SetReply(ERR, 'No such message')
    else
     begin
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
     ContextProcs.DeleteContext(AccountId);
     FAccountManager.SetStatus(AccountId,asFree);
   ReleaseMutex(Mutex);
  end //
  else // если -1 или 0
   begin

   end;
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
    Proc:=ContextProcs.GetContext(AccountId).MessProc;
    Proc.SQL.Text:='SELECT MessSize FROM messages WHERE mid=:AccountId AND Deleted=False ';
    Proc. Parameters.ParamByName('AccountId').Value:=AccountId;
    Proc. ExecSQL;
    Proc. Open;
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
    Proc:=ContextProcs.GetContext(AccountId).MessProc;
    Proc.SQL.Text:='DELETE FROM Messages WHERE mid=:AccountId AND Deleted=TRUE';
    Proc.Parameters.ParamByName('AccountId').Value:=AccountId;
    Proc.ExecSQL;
    Proc:=nil;
   end; 
end;

procedure TPOPServer.RETR(ASender: TIdCommand; AMessageNum: Integer);
var
   AccountId:integer;
   Proc:TADOQuery;
   MessCount,MessSize:Integer;
   MessStream,outp:TMemoryStream;
   comp:TCompressor;
begin
 AccountId:=ASender.Context.Connection.Tag;
 if AccountId=0
  then  ASender.Reply.SetReply(ERR, 'No such message')
   else
    begin
     Proc:=ContextProcs.GetContext(AccountId).MessProc;
     Proc.SQL.Text:='SELECT * FROM messages WHERE mid=:AccountId AND Deleted=False ';
     Proc. Parameters.ParamByName('AccountId').Value:=AccountId;
     Proc. ExecSQL;
     Proc. Open;
     if AMessageNum>Proc.RecordCount
      then ASender.Reply.SetReply(ERR, 'No such message')
      else
       begin
        Proc.RecNo:=AMessageNum;

        {получить поток из поля распаковать и вывести}
        MessStream:=TMemoryStream.Create;
        outp:=TMemoryStream.Create;
        comp:=TCompressor.Create;
        TBlobField(Proc.FieldByName('Message')).SaveToStream(MessStream);
        comp.DecompressStream(MessStream,outp);


        ASender.Response.LoadFromStream(outp);


        outp.Free;
        comp.Free;
        MessStream.Free;

       end;
     Proc.Close;
   end;
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
      Proc:=ContextProcs.GetContext(AccountId).MessProc;
      SQL.Text:='SELECT COUNT(Id) FROM messages WHERE mid=:AccountId AND Deleted=False ';
      Parameters.ParamByName('AccountId').Value:=AccountId;
      ExecSQL;
      Open;
      MessCount:=Fields[0].AsInteger;
      Close;
      // получение объема сообщений
      SQL.Text:='SELECT SUM(MessSize) FROM messages WHERE mid=:AccountId AND Deleted=False ';
      Parameters.ParamByName('AccountId').Value:=AccountId;
      ExecSQL;
      Open;
      MessSize:=Fields[0].AsInteger;

      ASender.Reply.SetReply(OK,IntToStr(MessCount)+ ' '+ IntToStr(MessSize));

     end
  else ASender.Reply.SetReply(OK, '0 0');
end;

procedure TPOPServer.SetDefaultPort(const Value: Integer);
begin
  if FDefaultPort <> Value then
   try
    POP.Active:=False;
    FDefaultPort := Value;
    POP.DefaultPort:=FDefaultPort;
    pop.Active:=True;
   except
    on e: Exception do
      ShowMessage(E.Message);
   end;
end;

end.

{
неправильно указывается размер сообщения

}
