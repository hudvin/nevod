unit POPServer;

interface
uses Shared,
  Windows, Messages, SysUtils,
  StdCtrls, ADODB, IdBaseComponent, IdComponent,
  IdTCPServer, IdPOP3Server, MMSystem,ActiveX,Blowfish;

type
 TPOPServer=class
  public
   constructor Create(ADOCon:TADOConnection);
   destructor  Destroy(); override;
  private
   SManager:TSettings;
   pop:TIdPOP3Server;
   ACon:TADOConnection;
   procedure CheckAccount(AThread: TIdPeerThread;LThread: TIdPOP3ServerThread);// +
   procedure LIST(ASender: TIdCommand; AMessageNum: Integer);
   procedure RETR(ASender: TIdCommand; AMessageNum: Integer);
   procedure DELE(ASender: TIdCommand; AMessageNum: Integer);
   procedure QUIT(ASender: TIdCommand);
   procedure STAT(ASender: TIdCommand);               //+
   procedure Disconnect(AThread: TIdPeerThread);
end;

implementation
// доступ только с локального хоста
constructor TPOPServer.Create(ADOCon:TADOConnection);
begin
ACon:=ADOCon;
SManager:=TSettings.Create(ACon);
pop:=TIdPOP3Server.Create(nil);
with pop do
 begin
   DefaultPort:=StrToInt(SManager.GetValue('ServerPort'));
   CheckUser:=CheckAccount;
   OnLIST:=LIST;
   OnSTAT:=STAT;
   OnRETR:=RETR;
   OnDELE:=DELE;
   OnQUIT:=QUIT;
   OnDisconnect:=Disconnect;
   Active:=true;
 end;
end;

destructor TPOPServer.Destroy();
begin
pop.Free;
SManager.Free;
ACon.Free;
end;


procedure TPOPServer.CheckAccount(AThread: TIdPeerThread;LThread: TIdPOP3ServerThread);
var
    password,username:string;
    Ast:TADOStoredProc;
    id:integer;
begin
CoInitialize(nil);
password:=LThread.Password;
username:=LThread.Username;
Ast:=TADOStoredProc.Create(nil);
Ast.Connection:=ACon;
Ast.ProcedureName:='CheckForUserAccess';
with Ast.Parameters do
 begin
    Clear;
    AddParameter.Name:='username';
    ParamByName('username').Value:=username;
    AddParameter.Name:='password';
    ParamByName('password').Value:=password;
end;
ast.ExecProc;
ast.Open;
if ast.RecordCount>0 then     // если пароль верен
 if Trim(ast.FieldByName('status').AsString)='fmClient' then
  begin
    AThread.Connection.Tag:=0; // показывать что сообщений нет
    LThread.State:=trans;
  end;
 if Trim(ast.FieldByName('status').AsString)='fmFree' then
  begin
    id:=ast.FieldByName('id').AsInteger;   //  установка статуса аккаунта
    ast.Close;
    ast.Active:=false;
    ast.ProcedureName:='SetStatusById';
    with   ast.Parameters do
      begin
        Clear;
        AddParameter.Name:='status';
        ParamByName('status').Value:='fmServer';
        AddParameter.Name:='id';
        ParamByName('id').Value:=id;
      end;
    ast.ExecProc;
    Ast.Parameters.Clear;
    Ast.ProcedureName:='UndeleteCheckedMessages'; // очистка флагов
    Ast.Parameters.AddParameter.Name:='id';
    Ast.Parameters.ParamByName('id').Value:=id;
    Ast.ExecProc;
    LThread.State:=Trans;
    AThread.Connection.Tag:=id;
    end;
ast.Close;
ast.Free;
end;

procedure TPOPServer.STAT(ASender: TIdCommand);
var
    id,size,count:integer;
    ast:TADOStoredProc;
begin
id:=ASender.Thread.Connection.Tag;
if id=0 then ASender.Thread.Connection.WriteLn('+OK 0 0') else
 begin
  ast:=TADOStoredProc.Create(nil);
  ast.Connection:=ACon;
  ast.ProcedureName:='CreateMessageList';
  ast.Parameters.AddParameter.Name:='id';
  ast.Parameters.ParamByName('id').Value:=id;
  ast.Active:=true;
  ast.ExecProc;
  ast.Open;
  count:=0; // количество неудаленных писем
  while not ast.Eof do
   begin
    if not ast.FieldByName('deleted').AsBoolean then
      begin
       size:=size+Length(ast.FieldByName('message').AsString);
       inc(count);
      end;
    ast.Next;
   end;
  ASender.Thread.Connection.WriteLn('+OK' + ' '+ IntToStr(count)+' '+IntToStr(size));
 end;
end;


procedure TPOPServer.LIST(ASender: TIdCommand; AMessageNum: Integer);
var
    id,size,count:integer;
    ast:TADOStoredProc;
begin
id:=ASender.Thread.Connection.Tag;
if id=0 then  ASender.Thread.Connection.WriteLn('+OK  Your mailbox is empty ') else
 begin
  ast:=TADOStoredProc.Create(nil);
  ast.Connection:=ACon;
  ast.ProcedureName:='CreateMessageList';
  ast.Parameters.AddParameter.Name:='id';
  ast.Parameters.ParamByName('id').Value:=id;
  ast.ExecProc;
  ast.Open;
  while not ast.Eof do
   begin
    if not ast.FieldByName('deleted').AsBoolean then
     begin
      size:=size+Length(ast.FieldByName('message').AsString);  // не используется !!!
      inc(count);
     end;
    ast.Next;
  end;

  case AMessageNum of
   -1:       // вывод всех сообщений
    begin
      if count=0 then
        begin
          ASender.Thread.Connection.WriteLn('+OK  Your mailbox is empty ');
          ASender.Thread.Connection.WriteLn('.');
        end
        else   //  вывод списка
         begin
          ASender.Thread.Connection.WriteLn('+OK' + ' '+ IntToStr(count)+' messages');
          ast.First;
           while not ast.Eof do
             begin
                if not ast.FieldByName('deleted').AsBoolean then
                  ASender.Thread.Connection.WriteLn(IntToStr(ast.RecNo)+ ' ' + IntToStr(Length(ast.FieldByName('message').AsString)));
                ast.Next;
             end;
           ASender.Thread.Connection.WriteLn('.');
        end;
    end;
 1..1000000000:    // вывод конкретного сообщения
    begin
      if AMessageNum>ast.RecordCount then
        begin
        ASender.Thread.Connection.WriteLn('-ERR  NO such mail ');
        ASender.Thread.Connection.WriteLn('.');
        end
       else
        begin
         ast.RecNo:=AMessageNum;
         if ast.FieldByName('deleted').AsBoolean then
           begin
             ASender.Thread.Connection.WriteLn('-ERR  NO such mail ');
             ASender.Thread.Connection.WriteLn('.');
           end
            else ASender.Thread.Connection.WriteLn(IntToStr(ast.RecNo)+ ' ' + IntToStr(Length(ast.FieldByName('message').AsString)));
        end;
    end;
end;
ast.Close;
ast.Free;
end;
end;

procedure TPOPServer.RETR(ASender: TIdCommand; AMessageNum: Integer);
var
    id:integer;
    ast:TADOStoredProc;
begin
id:=ASender.Thread.Connection.Tag;
if id=0  then     ASender.Thread.Connection.WriteLn('-ERR No such message') else
  begin
   ast:=TADOStoredProc.Create(nil);
   ast.Connection:=ACon;
   ast.ProcedureName:='CreateMessageList';
   ast.Parameters.AddParameter.Name:='id';
   ast.Parameters.ParamByName('id').Value:=id;
   ast.ExecProc;
   ast.Open;

  if AMessageNum>ast.RecordCount then
   ASender.Thread.Connection.WriteLn('-ERR No such message')
    else
     begin
     ast.RecNo:=AMessageNum;
     if not ast.FieldByName('deleted').AsBoolean then
        begin
          ASender.Thread.Connection.WriteLn('+OK');
          ASender.Thread.Connection.WriteLn(ast.FieldByName('message').AsString);
          ASender.Thread.Connection.WriteLn('.');
        end
        else   ASender.Thread.Connection.WriteLn('-ERR No such message ');
   end;
ast.Close;
ast.Free;
end;
end;


procedure TPOPServer.DELE(ASender: TIdCommand; AMessageNum: Integer);
var id:integer;
    ast:TADOStoredProc;
begin
id:=ASender.Thread.Connection.Tag;
if id=0 then ASender.Thread.Connection.WriteLn('-ERR No such message') else
 begin
  ast:=TADOStoredProc.Create(nil);
  ast.Connection:=ACon;
  ast.ProcedureName:='CreateMessageList';
  ast.Parameters.AddParameter.Name:='id';
  ast.Parameters.ParamByName('id').Value:=id;
  ast.Active:=true;
  ast.ExecProc;
  ast.Open;

  if AMessageNum>ast.RecordCount then ASender.Thread.Connection.WriteLn('-ERR No such mail')
   else
   begin
     ast.RecNo:=AMessageNum;
     if not ast.FieldByName('deleted').AsBoolean then
        begin
         ast.Edit;
         ast.FieldByName('deleted').AsBoolean:=true;
         ast.Post;
         ASender.Thread.Connection.WriteLn('+OK Deleted');
        end
         else   ASender.Thread.Connection.WriteLn('-ERR No such message');
   end;
  ast.Close;
  ast.Free;
 end;
end;

procedure TPOPServer.QUIT(ASender: TIdCommand);
var
    id:integer;
    ast:TADOStoredProc;
begin
id:=ASender.Thread.Connection.Tag;
if id=0 then   ASender.Thread.Connection.WriteLn('+OK') else
  begin
   ast:=TADOStoredProc.Create(nil);
   ast.Connection:=ACon;
   ast.ProcedureName:='DeleteCheckedMessages';
   ast.Parameters.AddParameter.Name:='id';
   ast.Parameters.ParamByName('id').Value:=id;
   ast.ExecProc;

   ast.Close;
   ast.Parameters.Clear;
   ast.ProcedureName:='setStatusById';
   ast.Parameters.AddParameter.Name:='status';
   ast.Parameters.ParamByName('status').Value:='fmFree';
   ast.Parameters.AddParameter.Name:='id';
   ast.Parameters.ParamByName('id').Value:=id;
   ast.ExecProc;
   ast.Close;
   ast.Free;

   ASender.Thread.Connection.WriteLn('+OK');
  end;
end;


procedure TPOPServer.Disconnect(AThread: TIdPeerThread);
var
    id:integer;
    ast:TADOStoredProc;
begin
id:=AThread.Connection.Tag;
if id<>0 then
  begin
   ast:=TADOStoredProc.Create(nil);
   ast.Connection:=ACon;
   ast.ProcedureName:='UnDeleteCheckedMessages';
   ast.Parameters.AddParameter.Name:='id';
   ast.Parameters.ParamByName('id').Value:=id;
   ast.ExecProc;
   ast.Close;

  ast.Parameters.Clear;
  ast.ProcedureName:='setStatusById';
  ast.Parameters.AddParameter.Name:='status';
  ast.Parameters.ParamByName('status').Value:='fmFree';
  ast.Parameters.AddParameter.Name:='id';
  ast.Parameters.ParamByName('id').Value:=id;
  ast.ExecProc;
  ast.Close;

  ast.Free;
 end;
end;

end.
