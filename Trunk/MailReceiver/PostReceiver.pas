unit PostReceiver;

interface
uses gnugettext,  Shared, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3,  IdStackBSDBase,
  IdThread, IdMessage,Variants, Classes,DBTables, IdStack,IdreplyPOP3,
  Windows, SysUtils, ADODB,DB, DateUtils,  ActiveX;


type
  TBaseReceiver = class(TIdThread)
  private
    FAccountParams:TAccountParams;
    FPackMessages: Boolean;
    RecMessage: TFMessage;
    adProc: TADOQuery;
    FLogMessage: string;
    FMessagesCount: Integer;
    FSuccessFul: Boolean;
    procedure AddToOldMessagesId(Mess: TFMessage);
    function MessageIdExists(MsgId: string): Boolean;
    procedure ReceiveMessages; virtual; abstract;
    procedure SaveMessage(Mess: TFMessage;MessSize:integer); virtual;
  protected
    procedure Run; override;
  public
    constructor Create(Account: TAccountParams; ADOCon: TADOConnection;
        PackMessages: Boolean); virtual;
    destructor Destroy; override;
    property AccountId: Integer read FAccountParams.Id;
    property AccountParams: TAccountParams read FAccountParams write FAccountParams;
    property LogMessage: string read FLogMessage;
    property MessagesCount: Integer read FMessagesCount;
    property SuccessFul: Boolean read FSuccessFul;
  end;

  TPOP3Receiver = class(TBaseReceiver)
  private
    POP3Client: TIdPOP3;
    procedure ReceiveMessages; override;
  public
    constructor Create(Account: TAccountParams; ADOCon: TADOConnection;
        PackMessages: Boolean);
    destructor Destroy; override;
  end;

implementation
uses main;
{
******************************** TBaseReceiver *********************************
}
constructor TBaseReceiver.Create(Account: TAccountParams; ADOCon:
    TADOConnection; PackMessages: Boolean);
begin
  inherited Create(False);
  FreeOnTerminate:=False;
  FMessagesCount:=0;
  FLogMessage:='';
  FSuccessFul:=True;
  FAccountParams:=Account;
  FPackMessages:=PackMessages;
  adProc:=TADOQuery.Create(nil);
  adProc.Connection:=ADOCon;
  RecMessage:=TFMessage.Create;
end;

destructor TBaseReceiver.Destroy;
begin
  inherited Destroy;
  adProc.Free;
  RecMessage.Free;
end;

procedure TBaseReceiver.AddToOldMessagesId(Mess: TFMessage);
begin
  CoInitialize(nil);
  with adProc do
   begin
    SQL.Text:='INSERT INTO OldMessagesId ( mid, MessId ) VALUES (:AccountId, :MessId)';
    with Parameters do
     begin
      Clear;
      AddParameter.Name:='AccountId';
      ParamByName('AccountId').Value:=FAccountParams.Id;

      AddParameter.Name:='MessId';
      ParamByName('MessId').Value:=Mess.MsgId;
     end;
    ExecSQL;
    Close;
   end;
  CoUninitialize;
end;

function TBaseReceiver.MessageIdExists(MsgId: string): Boolean;
var
  Flag: Boolean;
begin
  CoInitialize(nil);
  Flag:=False;
  with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT COUNT(id) FROM OldMessagesId WHERE MessId=:MessId';
    Parameters.ParamByName('MessId').Value:=MsgId;
    Active:=True;
    if Fields[0].AsInteger>0 then Flag:=True;
    Active:=False;
   end;
  Result:=Flag; //возврашает истину если идентификатор существует в таблице
  CoUninitialize;
end;

procedure TBaseReceiver.Run;
begin
  ReceiveMessages;
  Terminate;
end;

procedure TBaseReceiver.SaveMessage(Mess: TFMessage;MessSize:integer);
var
  MessStream: TMemoryStream;
begin
  CoInitialize(nil);

  MessStream:=TMemoryStream.Create;
  if FPackMessages then    Mess.SaveToZStream(MessStream)
    else  Mess.SaveToStream(MessStream);
  adProc.Close;
 // MessSTream.Size:=MessStream.Size-3;
  adProc.SQL.Text:='INSERT INTO messages (mid, message,messId,Address,CompressionLevel,MessSize)'+
                  ' VALUES (:mid,:message,:messId,:Address,:CompressionLevel,:MessSize)';
  adProc.Parameters.ParseSQL(adProc.sql.text,true);
  with   adProc.Parameters do
    begin
      ParamByName('mid').Value:=FAccountParams.Id;


      ParamByName('Message').LoadFromStream(MessStream,ftBlob);   // ftMemo писать отдельно !!!
      ParamByName('messId').Value:=Mess.MsgId;

      
      ParamByName('Address').Value:=Mess.From.Address;
      ParamByName('CompressionLevel').Value:=Mess.Compression;
      ParamByName('MessSize').Value:=MessSize;
  end;
  adProc.ExecSQL;
  MessStream.Free;
  CoUninitialize;
end;

{
******************************** TPOP3Receiver *********************************
}
constructor TPOP3Receiver.Create(Account: TAccountParams; ADOCon:
    TADOConnection;  PackMessages: Boolean);
begin
  inherited Create(Account,ADOCon,PackMessages);
  POP3Client:=TIdPOP3.Create(nil);
end;

destructor TPOP3Receiver.Destroy;
begin
  try
   if POP3Client.Connected then POP3Client.Disconnect;
   POP3Client.Free;
  except
  end;
  inherited Destroy;
end;

procedure TPOP3Receiver.ReceiveMessages;
var
  i, MessCount,rec: Integer;
  MessSize:Integer;
begin
  POP3Client.Host:=FAccountParams.Host;
  POP3Client.Port:=FAccountParams.Port;
  POP3Client.Username:=FAccountParams.Username;
  POP3Client.Password:=FAccountParams.Password;
  POP3Client.ConnectTimeout:=FAccountParams.Timeout;
  try
   POP3Client.Connect;
   MessCount:=POP3Client.CheckMessages;
   if messcount>0 then
       begin
         rec:=0;
         for i:=1 to messcount do
            begin
              RecMessage.Clear;
              POP3Client.RetrieveHeader(i,RecMessage);
              if not MessageIdExists(RecMessage.MsgId) then  // если нет в списке
                 begin
                  RecMessage.Clear;
                  POP3Client.Retrieve(i,RecMessage);
                  MessSize:=POP3Client.RetrieveMsgSize(i);
                  inc(rec);
                  POP3Client.Delete(i);
                  AddToOldMessagesId(RecMessage);
                  SaveMessage(RecMessage,MessSize);
                 end
                 else   POP3Client.Delete(i);
            end;
         end;
   POP3Client.Disconnect;
   FMessagesCount:=rec;
   FSuccessFul:=True;
 //  CoInitialize(nil);
   with adProc do
    begin
     Active:=False;
     SQL.Text:='DELETE FROM OldmessagesId WHERE mid=:AccountId';
     Parameters.ParamByName('AccountId').Value:=AccountId;
     ExecSQL;
     Active:=False;
    end;
  // CoUninitialize;
   except
    on EIdSocketError do
      begin
       FSuccessFul:=False;
       FLogMessage:=_('Невозможно подключиться к серверу');
      end;
    on  EIdReplyPOP3Error  do
      begin
       FSuccessFul:=False;
       FLogMessage:=_('Неправильные  параметры аккаунта');
      end
      else
       begin
        FSuccessFul:=False;
        FLogMessage:=_('Произошел обрыв соединения ');
       end;

      // обрабатывать исключение при обрыве - таймаут
      { else             
       ShowMessage(E.); }
   end;
end;


end.


