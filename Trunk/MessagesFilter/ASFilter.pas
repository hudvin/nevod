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

  TNevodStamp = class(TBaseFilter)
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); override;
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
 Res:=False;
 Reason:='';
 email:=Mess.Sender.Address;
 mask:='*'+Copy(email,pos('@',email),Length(email)-pos('@',email)+1);    // маска в виде *@domain.com
 FilterName:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
 with Proc do
  begin
   Close;
   Parameters.Clear;
   SQL.Text:='SELECT COUNT(Id) FROM FilterList WHERE mid=(SELECT id FROM Filters WHERE '+
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
      SQL.Text:='SELECT COUNT(Id) FROM FilterList WHERE mid=(SELECT id FROM Filters WHERE '+
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

constructor TNevodStamp.Create(ADOCon:TADOConnection;Filter:TFilterType);
begin
  inherited Create(ADOCon,Filter);
end;

destructor TNevodStamp.Destroy;
begin
  inherited;
end;

function TNevodStamp.AnalyzeMessage(Mess:TFMessage): TFilterResult;
var
 Exp:TRegExpr;
 StrExp,MessText,KeyWord,SQL:String;
 i:Integer;
 Flag:boolean;

 email,mask,FilterName,Reason:String;
 res:boolean;
 Count:integer;
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
    StrExp:='(?s)(?i)(&lt;|<)\s*(&nbsp;\s*)*Nevod\s*(&nbsp;\s*)*AntiSpam\s*(&nbsp;\s*)*:(\s*)(&nbsp;\s*)*';
    StrExp:=StrExp+'(".*"|'+''''+'.*'+''''+')\s*(&nbsp;\s*)*(&gt;|>)';
    SQL:='SELECT COUNT(Id) FROM Stamps WHERE FValue=:Stamp AND Active=True';
    Proc.SQL.Text:=SQL;
    Exp:=TRegExpr.Create;
    Exp.ModifierG:=False;
    Exp.Expression:=StrExp;
    if Exp.Exec (MessText) then
      Repeat
       KeyWord:=copy(Exp.Match [7],2,length(Exp.Match [7])-2);
       with Proc do
        begin
         Close;
         Parameters.ParamByName('Stamp').Value:=KeyWord;
         ExecSQL;
         Open;
         if Fields[0].AsInteger>0 then Flag:=False;
        end;
      Until (not Exp.ExecNext)and (Flag);
    if NOT Flag then   // найдено в таблице
     Result.FilterType:=ftStamp;
   finally
    Exp.Free;
   end;

  end;

 

 {
  выделить текст из сообщения и записать во внутреннюю переменную
  через регулярное выражение найти все штампы - при нахождении искать в таблице
  если есть - выход из цикла

 }


end;

end.

