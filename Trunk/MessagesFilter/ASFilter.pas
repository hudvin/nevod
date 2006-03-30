unit ASFilter;

interface
uses
   Windows,SysUtils,Classes, Shared, ADODB,DB,Typinfo,RegExpr,IdText;
type
  TBaseFilter = class
  private
    FFilterType: TFilterType;
    FMarkAs: string;
    Proc: TADOQuery;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); virtual;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): TFilterResult; virtual; abstract;
    procedure MarkMessage; virtual;
    property FilterType: TFilterType read FFilterType;
    property MarkAs: string read FMarkAs write FMarkAs;
  end;

  TSenderFilter = class(TBaseFilter)
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); override;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): TFilterResult; virtual;
  end;

  TStampFilter = class(TBaseFilter)
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); override;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): TFilterResult; override;
  end;

  TSignalFilter = class(TBaseFilter)
  private
    Exp: TRegExpr;
    FSignalLocation: TSignalLocation;
    function FindString(InpText:String;SubString:string;TextType:TBodyType;
        SignalForm:TSignalForm): Boolean;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType;
        SignalLocation:TSignalLocation); overload;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): TFilterResult; override;
  end;

implementation

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


procedure TBaseFilter.MarkMessage;
begin
end;

constructor TSenderFilter.Create(ADOCon:TADOConnection;Filter:TFilterType);
begin
  inherited Create(ADOCon,Filter);
end;

destructor TSenderFilter.Destroy;
begin
  inherited;
end;

function TSenderFilter.AnalyzeMessage(Mess:TFMessage): TFilterResult;
var
 email,mask,FilterName,Reason:String;
 res:boolean;
 Count:integer;
begin
 {
  сделать выборку всех адресов из таблицы
  пройти в цикле
   для каждого адреса собирать строку выражения
   проверять на на совпадение адрес в сообщении с помощью сге
    нерированного шаблона


 }


 Res:=False;
 Reason:='';
 email:=Mess.Sender.Address;
 mask:='*'+Copy(email,pos('@',email),Length(email)-pos('@',email)+1);    // маска в виде *@domain.com
 FilterName:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
 with Proc do
  begin
   Close;
   Parameters.Clear;
   SQL.Text:='SELECT COUNT(Id) FROM SenderFilter WHERE mid=(SELECT id FROM Filters WHERE '+
             ' type=:FilterType) AND FValue=:email AND Active=True';
   Parameters.ParamByName('FilterType').Value:=FilterName;
   Parameters.ParamByName('email').Value:=email;
   ExecSQL;
   Open;
   Count:=Proc.Fields[0].AsInteger;
   Close;
   if Count>0  then  Res:=True
    else
     begin
      SQL.Text:='SELECT COUNT(Id) FROM SenderFilter WHERE mid=(SELECT id FROM Filters WHERE '+
             ' type=:FilterType) AND FValue=:mask';
      Parameters.ParamByName('FilterType').Value:=FilterName;
      Parameters.ParamByName('mask').Value:=mask;
      ExecSQL;
      Open;
      Count:=Proc.Fields[0].AsInteger;
      Close;
      if Count>0 then Res:=True;
     end;
  end;
 if Res then  // значит есть в таблице
   {если причина не указана - использовать стандартную - устанавливать при добавлении}
   with Proc do
    begin
     Close;
     SQL.Text:='SELECT Reason FROM Filters WHERE type=:FilterType';
     Parameters.ParamByName('FilterType').Value:=FilterName;
     ExecSQL;
     Open;
     Reason:=Fields[0].AsString;
     Result.FilterType:=FilterType;
     Result.Reason:=Reason;
    end
 else
  Result.FilterType:=ftNone;

end;

constructor TStampFilter.Create(ADOCon:TADOConnection;Filter:TFilterType);
begin
  inherited Create(ADOCon,Filter);
end;

destructor TStampFilter.Destroy;
begin
  inherited;
end;

function TStampFilter.AnalyzeMessage(Mess:TFMessage): TFilterResult;
var
 Exp:TRegExpr;
 StrExp,MessText,KeyWord,SQL:String;
 i:Integer;
 Flag:boolean;
begin
 Flag:=True;
 MessText:='';
 Result.Reason:='';
 Result.FilterType:=ftNone;
 for i:=0 to Mess.MessageParts.Count-1 do
  if Mess.MessageParts.Items[i] is TIdText then MessText:=MessText+(Mess.MessageParts[i] as TIdText).Body.Text;

 if MessText<>'' then
  begin
   try
    Exp:=TRegExpr.Create;
    StrExp:='(?s)(?i)(&lt;|<)\s*(&nbsp;\s*)*Nevod\s*(&nbsp;\s*)*AntiSpam\s*(&nbsp;\s*)*:(\s*)(&nbsp;\s*)*';
    StrExp:=StrExp+'("(.*)"|'+''''+'(.*)'+''''+')\s*(&nbsp;\s*)*(&gt;|>)';
    SQL:='SELECT COUNT(Id) FROM StampFilter WHERE FValue=:Stamp AND Active=True';
    Proc.SQL.Text:=SQL;
    Exp.ModifierG:=False;
    Exp.Expression:=StrExp;
    if Exp.Exec (MessText) then
      Repeat
       if Exp.Match[8]<>'' then KeyWord:=Exp.Match[8]
        else KeyWord:=Exp.Match[9];         
       with Proc do
        begin
         Close;
         Parameters.ParamByName('Stamp').Value:=KeyWord;
         ExecSQL;
         Open;
         if Fields[0].AsInteger>0 then Flag:=False;
        end;
      Until (not Exp.ExecNext)and (not Flag);
    if NOT Flag then   // найдено в таблице
     Result.FilterType:=ftStamp;
   finally
    Exp.Free;
   end;
  end;
end;

constructor TSignalFilter.Create(ADOCon:TADOConnection;Filter:TFilterType;
    SignalLocation:TSignalLocation);
begin
  inherited Create(ADOCon,Filter);
  FSignalLocation:=SignalLocation;
  Exp:=TRegExpr.Create;
end;

destructor TSignalFilter.Destroy;
begin
  Exp.Free;
  inherited;
end;

function TSignalFilter.AnalyzeMessage(Mess:TFMessage): TFilterResult;
 function GetRowText(MessageText:String):String;
 var buff:String;
 begin
  buff:=MessageText;
  with Exp  do
   begin
    ModifierG:=False;
    Expression:='<.*>';
    buff:=Replace(buff,'',True); // удаление всех тегов
    Expression:='\s{2,}';     // удаление лишних пробелов
    buff:=Replace(buff,' ',True);
   end;
  Result:=buff;
 end;

var
 SQLProc,RowText:String;
 Flag:Boolean;
begin
 if Mess.BodyType=btHtml then
  RowText:=GetRowText(Mess.MessageText) // получение текста сообщения без тегов и лишних пробелов
 else RowText:=Mess.MessageText;
 Proc.Close;
 case FSignalLocation of  // по каким полям сообщения должен производится поиск
  slAnywhere:
   begin
    SQLProc:= 'SELECT FValue,Location,Decsription,SignalForm FROM SignalFilter '+
              ' (WHERE Active=TRUE) AND (Location=:Location_1 OR Location=:Location_2 OR Location=:Location_3)';
    Proc.SQL.Text:=SQLProc;
    Proc.Parameters.ParamByName('Location_1').Value:='slSubject';
    Proc.Parameters.ParamByName('Location_2').Value:='slAnyWhere';
    Proc.Parameters.ParamByName('Location_3').Value:='slBody';
   end;
  slBody:
   begin
    SQLProc:= 'SELECT FValue,Location,Decsription,SignalForm FROM SignalFilter '+
              ' (WHERE Active=TRUE) AND (Location=:Location_1 OR Location=:Location_2)';
    Proc.SQL.Text:=SQLProc;
    Proc.Parameters.ParamByName('Location_1').Value:='slAnyWhere';
    Proc.Parameters.ParamByName('Location_2').Value:='slBody';
   end;
  slSubject:
   begin
    SQLProc:= 'SELECT FValue,Location,Decsription,SignalForm FROM SignalFilter '+
              ' (WHERE Active=TRUE) AND (Location=:Location_1 OR Location=:Location_2)';
    Proc.SQL.Text:=SQLProc;
    Proc.Parameters.ParamByName('Location_1').Value:='slAnyWhere';
    Proc.Parameters.ParamByName('Location_2').Value:='slSubject';
   end;
 end;

 with Proc do
  begin
   ExecSQL;
   Open;
   First;
   Flag:=True;
   while (not Proc.Eof) and (Flag) do
    begin
     try
      case TSignalLocation(GetEnumValue(TypeInfo(TSignalLocation),FieldByName('Location').AsString)) of    //
       slAnywhere:;   // давать два запроса 
       slSubject: ;
       slBody:    ;
      end;
     except
     end;

    end;
  end;
end;

function TSignalFilter.FindString(InpText:String;SubString:string;
    TextType:TBodyType; SignalForm:TSignalForm): Boolean;
begin
 {
  InpText - строка, в которой будет произовдится поиск
  SubString - слово,которое будет искаться
  TextType - какой тип имеет входной текст (html или простой текст)
  SignalForm - в какой форме искать слово (одиночное слово, в составе другого слова, оба варианта)

 }

 {
  text
   одиночное слово (?s)(?i)(\s+|^)inter(\s+|$)
   в начале другого слова (?s)(?i)(\A|\s)(Destroy)(\Z|\w*[^\s])
   (\A|\w*)(Destroy)(\Z|\w*)   - тип (в составе слова или одиночно ) определять по карманам
  если html - выделить простой текст и далее искать как обычно
 }

 if TextType=btHtml then Exp.Expression:='(?s)(?i)>(.*?)<'
  else Exp.Expression:='(?s)(?i)(\s+|^)receive(\s+|$)';

 {
 разные выражение для поиска в простом тексте и html
 искать с помощью регулярных выражений


 }
end;

{
   описвние сигнального фильтра
   передавать в конструкторе, какие части сообшения просматривать
   при создании внутреннего массива слов учитывать место поиска
   если сообщение в черном списке - делать пометку
   использовать структурный массив

}
end.

