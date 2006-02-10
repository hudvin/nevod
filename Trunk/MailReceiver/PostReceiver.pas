unit PostReceiver;

interface
uses   Shared,
  IdThread, IdMessage,Variants, Classes,  Controls,DBTables, Dialogs,
  IdPOP3,Windows, SysUtils, ADODB,DB, DateUtils,  ActiveX;


type
  TBaseReceiver = class(TIdThread)
  private
    FADOCon: TADOConnection;
    FAccountParams: AccountParams;
    Log: TLogger;
    FPackMessages: Boolean;
    ReceivedMessages: TStringList;
    FTimeout: Integer;
    RecMessage: TFMessage;
    StoredSaver: TADOStoredProc;
    OldMessages: TADOStoredProc;
    procedure AddToOldMessages;
    procedure LoadOldMessages;
    function MessageExists(MsgId: string): Boolean;
    procedure ReceiveMessages; virtual; abstract;
    procedure SaveMessage(Mess: TFMessage); virtual;
  protected
    procedure Run; override;
  public
    constructor Create(Account: AccountParams; ADOCon: TADOConnection; Timeout:
        Integer; PackMessages: Boolean); virtual;
    destructor Destroy; override;
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
constructor TBaseReceiver.Create(Account: AccountParams; ADOCon:
    TADOConnection; Timeout: Integer; PackMessages: Boolean);
begin
  inherited Create(False);
  FADOCon:=ADOCon;
  FAccountParams:=Account;
  FTimeout:=TimeOut;
  FPackMessages:=PackMessages;
  Log:=TLogger.Create(FADOCon);
  StoredSaver:=TADOStoredProc.Create(nil);
  StoredSaver.Connection:=FADOCon;
  RecMessage:=TFMessage.Create;
  ReceivedMessages:=TStringList.Create;
  OldMessages:=TADOStoredProc.Create(nil);
  OldMessages.Connection:=FADOCon;
  LoadOldMessages;
end;

destructor TBaseReceiver.Destroy;
begin
  inherited Destroy;
  Log.Free;
  StoredSaver.Free;
  RecMessage.Free;
  OldMessages.Free;
  ReceivedMessages.Free;
end;

procedure TBaseReceiver.AddToOldMessages;
var
  i: Integer;
  Ast:TADOStoredProc;
begin      //добвить новый класс для добавления идентификаторов
  Ast:=TADOStoredProc.Create(nil);
  Ast.Connection:=FADOCon;
  Ast.ProcedureName:='AddOldMsgId';
  for i:=1 to ReceivedMessages.Count-1 do
      with Ast.Parameters do
        begin
          Clear;
          AddParameter.Name:='AccountId';
          ParamByName('AccountId').Value:=FAccountParams.Id;

          AddParameter.Name:='MessId';
          ParamByName('MessId').Value:=ReceivedMessages.Strings[i];

          Ast.ExecProc;
        end;
  Ast.Close;
end;

procedure TBaseReceiver.LoadOldMessages;
begin
  OldMessages.ProcedureName:='GetOldMessagesList';
  OldMessages.Parameters.AddParameter.Name:='AccountId';
  OldMessages.Parameters.ParamByName('AccountId').Value:=FAccountParams.Id;
  OldMessages.ExecProc;
end;

function TBaseReceiver.MessageExists(MsgId: string): Boolean;
var
  flag: Boolean;
begin
  OldMessages.Open;
  OldMessages.First;
  flag:=True;
  while (not OldMessages.Eof)  and (flag) do
    begin
      if Trim(OldMessages.Fields[0].AsString)=MsgId then flag:=False;
      OldMessages.Next;
    end;
  OldMessages.Close;
  Result:= NOT flag; //возврашает истину если идентификатор существует в таблице
end;

procedure TBaseReceiver.Run;
begin
  ReceiveMessages;
end;

procedure TBaseReceiver.SaveMessage(Mess: TFMessage);
var
  MessStream: TMemoryStream;
begin
  MessStream:=TMemoryStream.Create;
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
  end;
  StoredSaver.ExecProc;
  MessStream.Free;
end;

constructor TPOP3Receiver.Create(Account: AccountParams; ADOCon: TADOConnection; Timeout:
        Integer; PackMessages: Boolean);
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
             if not MessageExists(RecMessage.MsgId) then  // если нет в списке
               begin
                 RecMessage.Clear;
                 POP3Client.Retrieve(i,RecMessage);
                 POP3Client.Delete(i);
                 ReceivedMessages.Add(RecMessage.MsgId); // добавление в список полученных
                 SaveMessage(RecMessage);
               end else   // если нет в списке
                begin
                 POP3Client.Delete(i); // удаление сообщения полученного в предудущей сессии
            //     DeletedMsg.Add(Mess.MsgId); // уже есть в таблице выборки !!!
               end;
           end;
        OldMessages.Open;
        OldMessages.First;
        while not OldMessages.Eof do
         begin
          OldMessages.Edit;
          OldMessages.Delete;
          OldMessages.Next;
          OldMessages.Post;
        end;
        OldMessages.Close;
      end;
  POP3Client.Disconnect;
  except
    on E:Exception do
     begin
      Log.Add(E.Message,FAccountParams.Id,ltPostReceiver);
      AddToOldMessages;
     end;
  end;
  Terminate;
end;


end.


