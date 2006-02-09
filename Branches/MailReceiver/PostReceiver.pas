unit PostReceiver;

interface
uses   Shared,
  IdThread, IdMessage,Variants, Classes,  Controls,DBTables, Dialogs,
  IdPOP3,Windows, SysUtils, ADODB,DB, DateUtils,  ActiveX;


type
 TPostRec=class(TIdThread)
  public
   AParams:AccountParams;
   constructor Create(Account:AccountParams;ADOCon:TADOConnection;TimeOut:integer);
   destructor Destroy;override;
   procedure Run; override;
  private
   UndelMsg:TADOStoredProc;   // таблица с идентификаторами неудаленных сообщений
   pop:TIdPOP3;
   ACon:TADOConnection;
   DeletedMsg:TStringList;
   TimeOut_Disconnect:integer;
   Mess:TIdMessage;
   Log:TLogger;
   Ast:TADOStoredProc;
   procedure AddToDB();
   procedure AddToUndelMsg();
   function MsgExists(MsgId:string):boolean;
   procedure GetUndeleted();
   procedure SetLastUpdateTime();
end;

implementation


constructor TPostRec.Create(Account:AccountParams;ADOCon:TADOConnection;TimeOut:integer);
begin
inherited Create(False);
ACon:=ADOCon;
AParams:=Account;
TimeOut_Disconnect:=TimeOut;
Log:=TLogger.Create(ACon);

UndelMsg:=TADOStoredProc.Create(nil);
Ast:=TADOStoredProc.Create(nil);
Ast.Connection:=ACon;
Mess:=TIdMessage.Create(nil);
DeletedMsg:=TStringList.Create;
pop:=TIdPOP3.Create(nil);

UndelMsg.Connection:=ACon;
pop.username:=AParams.Username;
pop.Password:=AParams.Password;
pop.Host:=AParams.Host;
pop.Port:=AParams.Port;
pop.ConnectTimeout:=TimeOut_Disconnect;
end;


destructor TPostRec.Destroy;
begin
inherited Destroy;
if pop.Connected then pop.Disconnect;
pop.Free;
Log.Free;
Mess.Free;
UndelMsg.Free;
Ast.Free;
DeletedMsg.Free;
end;

procedure TPostRec.AddtoDB();
var MessStream:TMemoryStream;
begin
// грузить сообшения через поток
MessStream:=TMemoryStream.Create;
Mess.SaveToStream(MessStream);
ast.ProcedureName:='SaveMessage';
with   ast.Parameters do
  begin
    Clear;

    AddParameter.Name:='mid';
    ParamByName('mid').Value:=AParams.Id;

    AddParameter.Name:='Message';
    ParamByName('Message').LoadFromStream(MessStream,ftMemo);  // грузить как файловый поток

    AddParameter.Name:='messId';
    ParamByName('messId').Value:=Mess.MsgId;       // идентификатор сообщения

    AddParameter.Name:='Address';
    ParamByName('Address').Value:=Mess.From.Address;
end;
ast.ExecProc;
MessStream.Free;
end;


procedure TPostRec.Run; 
var
   i,messcount:integer;
begin
GetUndeleted;
try
  pop.Connect();
  SetLastUpdateTime();
  messcount:=pop.CheckMessages;
  if messcount>0 then
    begin
      for i:=1 to messcount do
         begin
           pop.RetrieveHeader(i,mess);
           if not MsgExists(Mess.MsgId) then  // если нет в списке
             begin
               mess.Clear;
               pop.Retrieve(i,mess);

               pop.Delete(i);
               DeletedMsg.Add(Mess.MsgId); // добавление в список удаленных
               AddToDB();
             end else
              begin
               pop.Delete(i); // удаление сообщения полученного в предудущей сессии
          //     DeletedMsg.Add(Mess.MsgId); // уже есть в таблице выборки !!!
             end;
          
         end;
    end;
  pop.Disconnect;
  UndelMsg.Open;
  UndelMsg.First;
  while not UndelMsg.Eof do
   begin
     UndelMsg.Edit;
     UndelMsg.Delete;
     UndelMsg.Next;
     UndelMsg.Post;
   end;

  UndelMsg.Close;
except
  on E:Exception do
      begin
        Log.Add(E.Message,AParams.Id,ltPostReceiver);
        AddToUndelMsg();

      end;

  // добавить все записи из списка  в таблицу
end;
Terminate;
end;




procedure TPostRec.AddToUndelMsg();
var
    i:integer;
begin
UndelMsg.Close;
UndelMsg.ProcedureName:='AddUndelMsgId';
for i:=1 to DeletedMsg.Count-1 do
    with UndelMsg.Parameters do
      begin
        Clear;
        AddParameter.Name:='AccountId';
        ParamByName('AccountId').Value:=AParams.Id;

        AddParameter.Name:='MessId';
        ParamByName('MessId').Value:=DeletedMsg.Strings[i];

        UndelMsg.ExecProc;
      end;
UndelMsg.Close;
end;

function TPostRec.MsgExists(MsgId:string):boolean;
var
    flag:boolean;
begin
UndelMsg.Open;
UndelMsg.First;
flag:=True;
while (not UndelMsg.Eof)  and (flag) do
  begin
    if Trim(UndelMsg.Fields[0].AsString)=MsgId then flag:=False;
    UndelMsg.Next;
  end;
UndelMsg.Close;
Result:= NOT flag; //возврашает истину если идентификатор существует в таблице
end;

procedure TPostRec.GetUndeleted();
begin
CoInitialize(nil);
with UndelMsg do
  begin
   Close;
   ProcedureName:='GetUndeleteMessageList';
   Parameters.AddParameter.Name:='AccountId';
   Parameters.ParamByName('AccountId').Value:=AParams.Id;
   ExecProc;
   Close;
  end;
CoUninitialize;
end;

procedure TPostRec.SetLastUpdateTime();
begin
CoInitialize(nil);
ast.ProcedureName:='SetLastUpdateTime';
with   ast.Parameters do
  begin
    Clear;
    AddParameter.Name:='LastUpdateTime';
    ParamByName('LastUpdateTime').Value:=Now;

    AddParameter.Name:='Id';
    ParamByName('Id').Value:=AParams.Id;
  end;
ast.ExecProc;
CoUninitialize;
end;



end.


