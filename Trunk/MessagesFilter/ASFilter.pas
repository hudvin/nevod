unit ASFilter;

interface
uses  Dialogs,  masks,   StrUtils, IdAttachment,IdMessageParts, IdMessage,
   Windows,SysUtils,Classes, Shared, ADODB,DB,Typinfo,RegExpr,IdText,PerlRegEx;
type
  TBaseFilter = class
  private
    FFilterType: TFilterType;
    FReason: string;
    Proc: TADOQuery;
    function GetReason(FilterType:TFilterType): string;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); virtual;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; virtual; abstract;
    procedure MarkMessage; virtual;
    property FilterType: TFilterType read FFilterType;
    property Reason: string read FReason;
  end;

  TSenderFilter = class(TBaseFilter)
  private
    Exp: TRegExp;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); override;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; virtual;
  end;

  TStampFilter = class(TBaseFilter)
  private
    Exp: TRegExp;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); override;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TSignalFilter = class(TBaseFilter)
  private
    Exp: TRegExp;
    FSignalLocation: TSignalLocation;
    function FindString(InpText:String;SubString:string): Boolean;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType;
        SignalLocation:TSignalLocation); overload;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TImageFilter = class(TBaseFilter)
  private
    Exp: TRegExp;
    MaxImg: Integer;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TLinkFilter = class(TBaseFilter)
  private
    Exp: TRegExp;
    MaxLinks: Integer;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TAttachmentExtFilter = class(TBaseFilter)
  private
    function GetFileExtension(FileName:string): string;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TMessageSizeFilter = class(TBaseFilter)
  private
    MaxSize: Integer;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;


implementation
uses main;

constructor TBaseFilter.Create(ADOCon:TADOConnection;Filter:TFilterType);
begin
  FFilterType:=Filter;
  Proc:=TADOQuery.Create(nil);
  Proc.Connection:=ADOCon;
end;

destructor TBaseFilter.Destroy;
begin
  Proc.Free;
end;

function TBaseFilter.GetReason(FilterType:TFilterType): string;
begin
 with Proc do
  begin
   Close;
   SQL.Text:='SELECT Reason FROM Filters WHERE type=:FilterType';
   Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
   ExecSQL;
   Open;
   Result:=Fields[0].AsString;
   Close;
  end; 
end;


procedure TBaseFilter.MarkMessage;
begin
end;

constructor TSenderFilter.Create(ADOCon:TADOConnection;Filter:TFilterType);
begin
  inherited Create(ADOCon,Filter);
  Exp:=TRegExp.Create(nil);
end;

destructor TSenderFilter.Destroy;
begin
  Exp.Free;
  inherited;
end;

function TSenderFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 Res:boolean;
 sender:String;
begin
  Res:=False;
  Sender:=Mess.Sender.Address;
  with Proc do
   begin       // делать выбоку по типу фильтра
    SQL.Text:='SELECT FVAlue FROM SenderFilter WHERE (Active=TRUE) AND '+
     ' (mid=(SELECT id FROM Filters WHERE type=:FilterType) ) ' ;
    Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
  //  ExecSQL;
    Open;
    First;
    while (not Res) and (not Eof) do
     begin
      Exp.Options:=[preCaseLess];
      Exp.ShieldingExp:=FieldByName('FValue').AsString; // сырая маска получателся
      Exp.Subject:=Sender;
      if Exp.Match then Res:=True
       else Next;
     end;
    if Res then  // значит есть в таблице
     begin
      Result:=True;
      FReason:=GetReason(FilterType);
     end
    else
     begin
      Result:=False;
      FReason:='';
     end;
   end;
end;

constructor TStampFilter.Create(ADOCon:TADOConnection;Filter:TFilterType);
begin
  inherited Create(ADOCon,Filter);
  Exp:=TRegExp.Create(nil);
end;

destructor TStampFilter.Destroy;
begin
  Exp.Free;
  inherited;
end;

function TStampFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 StrExp:String;
 Flag:boolean;
begin

 if Mess.MessageText<>'' then
  begin
   StrExp:='(?s)(?i)(&lt;|<)(\s*(&nbsp;)*\s*)*Nevod(\s*(&nbsp;)*\s*)*AntiSpam(\s*(&nbsp;)*\s*)*:(\s*(&nbsp;)*\s*)';
   StrExp:=StrExp+'("(\w+)"|'+''''+'(\w+)'+''''+')(\s*(&nbsp;)*\s*)*(&gt;|>)';
   Exp.RegEx :=StrExp;
   Exp.Subject := Mess.MessageText;
   Proc.SQL.Text:='SELECT COUNT(Id) FROM StampFilter WHERE FValue=:Stamp AND Active=True';
   Flag:=True;
   if Exp.Match then
    repeat
     with Proc do
      begin
       Close;
       Parameters.ParamByName('Stamp').Value:=Trim(Exp.SubExpressions[12]);
       ExecSQL;
       Open;
       if Fields[0].AsInteger>0 then Flag:=False;
       Close;
      end;
    until (not Exp.MatchAgain)and (not Flag);
  end;

  if not Flag  then   // в сообщении обнаружен штамп
   begin
    Result:=True;
    FReason:=GetReason(FilterType);
   end
    else
     begin
      Result:=False;
      FReason:='';
     end;
end;

constructor TSignalFilter.Create(ADOCon:TADOConnection;Filter:TFilterType;
    SignalLocation:TSignalLocation);
begin
  inherited Create(ADOCon,Filter);
  FSignalLocation:=SignalLocation;
  Exp:=TRegExp.Create(nil);
end;

destructor TSignalFilter.Destroy;
begin
  Exp.Free;
  inherited;
end;

function TSignalFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
 function GetRowText(MessageText:String):String;
 var buff:String;
 begin
  buff:=MessageText;
  with Exp  do
   begin
    RegEx:='<.*>';     // удаление тегов
    Options:=[preUnGreedy];
    Subject :=buff;
    Replacement := '';
    ReplaceAll;
    buff:=Subject;


    RegEx:='\s{2,}';     // удаление лишних пробелов
    Options:=[preUnGreedy];
    Subject :=buff;
    Replacement := '';
    ReplaceAll;
    buff:=Subject;
   end;
  Result:=buff;
 end;

var
 RowText,FType:String;
 Flag:Boolean;
begin
if Mess.BodyType=btHtml then
  RowText:=GetRowText(Mess.MessageText) // получение текста сообщения без тегов и лишних пробелов
 else RowText:=Mess.MessageText;
 Proc.Close;
 FType:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
 case FSignalLocation of  // по каким полям сообщения должен производится поиск
  slAnywhere:
   begin
    Proc.SQL.Text:='SELECT id, FValue,Location,Description FROM SignalFilter  WHERE     (Active=TRUE) AND'  +
     '(Location=:Location_1 OR Location=:Location_2 OR Location=:Location_3)'+
     'AND (mid=(SELECT id FROM Filters WHERE type='+ ''''+FType +'''' +'))';
    Proc.Parameters.ParamByName('Location_1').Value:='slSubject';
    Proc.Parameters.ParamByName('Location_2').Value:='slAnyWhere';
    Proc.Parameters.ParamByName('Location_3').Value:='slBody';
   end;
  slBody:
   begin
    Proc.SQL.Text:='SELECT id, FValue,Location,Description FROM SignalFilter  WHERE     (Active=TRUE) AND'  +
     '(Location=:Location_1 OR Location=:Location_2)'+
     'AND (mid=(SELECT id FROM Filters WHERE type='+ ''''+FType +'''' +'))';
    Proc.Parameters.ParamByName('Location_1').Value:='slAnyWhere';
    Proc.Parameters.ParamByName('Location_2').Value:='slBody';
   end;
  slSubject:
   begin
    Proc.SQL.Text:='SELECT id, FValue,Location,Description FROM SignalFilter  WHERE     (Active=TRUE) AND'  +
     '(Location=:Location_1 OR Location=:Location_2)'+
     'AND (mid=(SELECT id FROM Filters WHERE type='+ ''''+FType +'''' +'))';
    Proc.Parameters.ParamByName('Location_1').Value:='slAnyWhere';
    Proc.Parameters.ParamByName('Location_2').Value:='slSubject';
   end;
 end;

   
 with Proc do    // поиск слов из таблицы в сообщении
  begin
   FType:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
   Active:=True;
   First;
   Flag:=False;
   while (not Proc.Eof) and (not Flag) do
    begin
     try
      case TSignalLocation(GetEnumValue(TypeInfo(TSignalLocation),FieldByName('Location').AsString)) of    //
       slAnywhere:
        if FindString(RowText+' '+mess.Subject,Proc.FieldByName('FValue').AsString)
         then Flag:=True;
       slSubject:
        if FindString(mess.Subject,Proc.FieldByName('FValue').AsString)
         then Flag:=True ;
       slBody:
        if FindString(RowText,Proc.FieldByName('FValue').AsString)
         then Flag:=True;
      end;
     except
     end;
     Proc.Next;
    end;
  end;
 if Flag then
  begin
   Result:=True;
   FReason:=GetReason(FFilterType);
  end
  else
   begin
    Result:=False;
    FReason:='';
   end;

end;

function TSignalFilter.FindString(InpText:String;SubString:string): Boolean;
begin
 Exp.ShieldingExp:=SubString;
 Exp.Subject:=InpText;
 if Exp.Match then   Result:=True
  else result:=false;

end;

constructor TImageFilter.Create(ADOCon:TADOConnection;Filter:TFilterType);
begin
  inherited Create(ADOCon,Filter);
  Exp:=TRegExp.Create(nil);
  with Proc do
  begin
   Close;
   SQL.Text:='SELECT Var FROM Settings WHERE Name='+'''' +'MaxImg'+'''';
   Active:=True;
   MaxImg:=Fields[0].AsInteger;
   Close;
  end;
end;

function TImageFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 i:integer;
 Flag:boolean;
begin
  {

  возвращает количество ссылок на изображения в сообещении
  максимальное количество изображений хранить в таблице
  в конструкторе - класс для получения настроек
  или получать при вызове конструктора
  использовать регулярные выражения
  }
  if Mess.MessageText<>'' then
   begin
   i:=0;
   Flag:=True;
   Exp.RegEx:='<\w*img';
  // Exp.Subject:='<img sr=> <img>  <img srcgf>   fvsdfs'; // убрать нафиг - только для проверки
   Exp.Subject:=Mess.MessageText;
   if Exp.Match then
    repeat
     inc(i);
     if (i>MaxImg)
       then Flag:=False;
    until (not Exp.MatchAgain)or (not Flag);
   if not Flag then    // количество  превышено
    begin
     Result:=True;
     FReason:=GetReason(FFilterType);
    end
   else  // количество не превышено
    begin
     Result:=False;
     FReason:='';
    end;
   end;
end;

constructor TLinkFilter.Create(ADOCon:TADOConnection;Filter:TFilterType);
begin
  inherited Create(ADOCon,Filter);
  Exp:=TRegExp.Create(nil);
  with Proc do
  begin
   Close;
   SQL.Text:='SELECT Var FROM Settings WHERE Name='+'''' +'MaxLinks'+'''';
   Active:=True;
   MaxLinks:=Fields[0].AsInteger;
   Close;
  end;
end;

function TLinkFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 i:integer;
 Flag:boolean;
begin
  if Mess.MessageText<>'' then
   begin
   i:=0;
   Flag:=True;
   Exp.RegEx:='<\s*a\s*href';  // проверить, насколько правильно
   Exp.Subject:=Mess.MessageText;
   if Exp.Match then
    repeat
     inc(i);
     if (i>MaxLinks)
       then Flag:=False;
    until (not Exp.MatchAgain)or (not Flag);
   if not Flag then    // количество  превышено
    begin
     Result:=True;
     FReason:=GetReason(FFilterType);
    end
   else  // количество не превышено
    begin
     Result:=False;
     FReason:='';
    end;
   end;
end;

constructor TAttachmentExtFilter.Create(ADOCon:TADOConnection;
    Filter:TFilterType);
begin
  inherited Create(ADOCon,Filter);
  with Proc do   // выборка всех расширений для фильтра данного типа
   begin
    Close;
    SQL.Text:='SELECT FVAlue FROM AttachmentExtFilter WHERE (Active=TRUE) AND '+
     ' (mid=(SELECT id FROM Filters WHERE type=:FilterType) ) ' ;
    Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
   end;
end;

function TAttachmentExtFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 Flag:boolean;
 i:integer;
 Ext:String;
begin
 i:=0;
 Flag:=False;
 Proc.SQL.Text:='SELECT FVAlue FROM AttachmentExtFilter WHERE (Active=TRUE) AND '+
                ' (mid=(SELECT id FROM Filters WHERE type=:FilterType) ) AND FValue=:Ext';
 while not Flag do
  begin
   if i<Mess.MessageParts.Count then
    if Mess.MessageParts.Items[i] is TIdAttachment then
      with Proc do   // поиск данного расширения в таблице
       begin
        Ext:=GetFileExtension(TIdAttachment(Mess.MessageParts.Items[i]).FileName);
        Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
        Parameters.ParamByName('Ext').Value:=Ext;
        Active:=True;
        if RecordCount>0 then          
          Flag:=True;          // расширение найдено в списке
        Active:=False;
       end;
   inc(i);
  end;  

 Result:=Flag;
 FReason:=GetReason(FFilterType);
end;

function TAttachmentExtFilter.GetFileExtension(FileName:string): string;
var
  Buff: string;
begin
  Buff:=FileName;
  Buff:=ReverseString(Buff);
  Buff:=Copy(Buff,0,Pos('.',Buff)-1);
  Result:=ReverseString(Buff);
end;

constructor TMessageSizeFilter.Create(ADOCon:TADOConnection;Filter:TFilterType);
begin
  inherited Create(ADOCon,Filter);
  with Proc do
  begin
   Close;
   SQL.Text:='SELECT Var FROM Settings WHERE Name='+'''' +'MaxSize'+'''';
   Active:=True;
   MaxSize:=Fields[0].AsInteger;
   Close;
  end;
end;

function TMessageSizeFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
begin
 with Proc do
  begin
   SQL.Text:='SELECT MessSize FROM Messages WHERE messId=:MessageId';
   Parameters.ParamByName('MessageId').Value:=Mess.MsgId;
   Active:=True;
   if RecordCount>0 then
    if FieldByName('MessSize').AsInteger>MaxSize
     then   Result:=True
      else Result:=False
    else Result:=False;
   Active:=True;
  end;
end;


end.


