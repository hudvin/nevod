unit PostReceiver;

interface
uses   Shared,
  IdThread, IdMessage,Variants, Classes,  Controls,DBTables, Dialogs,
  IdPOP3,Windows, SysUtils, ADODB,DB, DateUtils,  ActiveX;


type
  TBaseReceiver = class(TIdThread)
  private
    FAccountParams: AccountParams;
    FADOCon: TADOConnection;
    FPackMessages: Boolean;
    FTimeout: Integer;
    Log: TLogger;
    OldMessagesId: TADOStoredProc;
    RecMessage: TFMessage;
    StoredSaver: TADOStoredProc;
    procedure AddToOldMessagesId(Mess: TFMessage);
    function MessageIdExists(MsgId: string): Boolean;
    procedure ReceiveMessages; virtual; abstract;
    procedure SaveMessage(Mess: TFMessage); virtual;
  protected
    procedure Run; override;
  public
    constructor Create(Account: AccountParams; ADOCon: TADOConnection; Timeout:
        Integer; PackMessages: Boolean); virtual;
    destructor Destroy; override;
    property AccountId: Integer read FAccountParams.Id;
  end;

  TPOP3Receiver = class(TBaseReceiver)
  private
    POP3Client: TIdPOP3;
    procedure ReceiveMessages; override;
  public
    constructor Create(Account: AccountParams; ADOCon: TADOConnection; Timeout:
        Integer; PackMessages: Boolean);
    destructor Destroy; override;
  end;

implementation

{
******************************** TBaseReceiver *********************************
}
constructor TBaseReceiver.Create(Account: AccountParams; ADOCon: TADOConnection;
    Timeout: Integer; PackMessages: Boolean);
begin
  inherited Create(False);
  FreeOnTerminate:=True;
  FADOCon:=ADOCon;
  FAccountParams:=Account;
  FTimeout:=TimeOut;
  FPackMessages:=PackMessages;
  Log:=TLogger.Create(FADOCon);
  StoredSaver:=TADOStoredProc.Create(nil);
  StoredSaver.Connection:=FADOCon;
  OldMessagesId:=TADOStoredProc.Create(nil);
  OldMessagesId.Connection:=FADOCon;
  RecMessage:=TFMessage.Create;
end;

destructor TBaseReceiver.Destroy;
begin
  inherited Destroy;
  Log.Free;
  StoredSaver.Free;
  RecMessage.Free;
  OldMessagesId.Free;
  FADOCon:=nil;
end;

procedure TBaseReceiver.AddToOldMessagesId(Mess: TFMessage);
begin
  CoInitialize(nil);
  with OldMessagesId do
   begin
    ProcedureName:='AddOldMsgId';
    with Parameters do
     begin
      Clear;
      AddParameter.Name:='AccountId';
      ParamByName('AccountId').Value:=FAccountParams.Id;

      AddParameter.Name:='MessId';
      ParamByName('MessId').Value:=Mess.MsgId;
     end;
    ExecProc;
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
  with OldMessagesId do
   begin
    Close;
    Parameters.Clear;
    ProcedureName:='GetMessIdCount';
    Parameters.AddParameter.Name:='MessId';
    Parameters.ParamByName('MessId').Value:=MsgId;
    Open;
    if Fields[0].AsInteger>0 then Flag:=True;
    Close;
   end;
  Result:=Flag; //возврашает истину если идентификатор существует в таблице
  CoUninitialize;
end;

procedure TBaseReceiver.Run;
begin
  ReceiveMessages;
  Terminate;
end;

procedure TBaseReceiver.SaveMessage(Mess: TFMessage);
var
  MessStream: TMemoryStream;
begin
  CoInitialize(nil);
  MessStream:=TMemoryStream.Create;
  // к сообщению добавить свойство - размер - получать из потока
  // размер сообщения получать от сервера при
  // получении письма
  // созранять значение сжатия
  if FPackMessages then  Mess.SaveToZStream(MessStream)
    else Mess.SaveToStream(MessStream);
  StoredSaver.Close;
  StoredSaver.Parameters.Clear;
  StoredSaver.ProcedureName:='SaveMessage';
  with   StoredSaver.Parameters do
    begin
      Clear;

      AddParameter.Name:='mid';
      ParamByName('mid').Value:=FAccountParams.Id;

      AddParameter.Name:='Message';
      ParamByName('Message').LoadFromStream(MessStream,ftMemo);

      AddParameter.Name:='messId';
      ParamByName('messId').Value:=Mess.MsgId;

      AddParameter.Name:='Address';
      ParamByName('Address').Value:=Mess.From.Address;

      AddParameter.Name:='Compression';
      ParamByName('Compression').Value:=Mess.Compression;
  end;
  StoredSaver.ExecProc;
  MessStream.Free;
  CoUninitialize;
end;

{
******************************** TPOP3Receiver *********************************
}
constructor TPOP3Receiver.Create(Account: AccountParams; ADOCon: TADOConnection;
    Timeout: Integer; PackMessages: Boolean);
begin
  inherited Create(Account,ADOCon,Timeout,PackMessages);
  POP3Client:=TIdPOP3.Create(nil);
end;

destructor TPOP3Receiver.Destroy;
begin
  inherited Destroy;
  if POP3Client.Connected then POP3Client.Disconnect;
  POP3Client.Free;
end;

procedure TPOP3Receiver.ReceiveMessages;
var
  i, MessCount: Integer;
begin
  POP3Client.Host:=FAccountParams.Host;
  POP3Client.Port:=FAccountParams.Port;
  POP3Client.Username:=FAccountParams.Username;
  POP3Client.Password:=FAccountParams.Password;
  try
   POP3Client.Connect;
   MessCount:=POP3Client.CheckMessages;
   if messcount>0 then
       begin
         for i:=1 to messcount do
            begin
              RecMessage.Clear;
              POP3Client.RetrieveHeader(i,RecMessage);
              if not MessageIdExists(RecMessage.MsgId) then  // если нет в списке
                 begin
                  RecMessage.Clear;
                  POP3Client.Retrieve(i,RecMessage);
              //    POP3Client.Delete(i);
                  AddToOldMessagesId(RecMessage);
                  SaveMessage(RecMessage);
                 end
                 else   POP3Client.Delete(i);
            end;
         end;
   POP3Client.Disconnect;
   CoInitialize(nil);
   with OldMessagesId do
    begin
     Parameters.Clear;
     ProcedureName:='DeleteOldMessagesId';
     Parameters.AddParameter.Name:='AccountId';
     Parameters.ParamByName('AccountId').Value:=AccountId;
     ExecProc;
    end;
   CoUninitialize;
   except
     on E:Exception do
      begin
       Log.Add(E.Message,FAccountParams.Id,ltPostReceiver);
      end;
   end;
end;


end.


