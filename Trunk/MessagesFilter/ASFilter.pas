unit ASFilter;

interface
uses  Dialogs,  masks,
   Windows,SysUtils,Classes, Shared, ADODB,DB,Typinfo,RegExpr,IdText,PerlRegEx;
type
  TBaseFilter = class
  private
    FFilterType: TFilterType;
    FMarkAs: string;
    Proc: TADOQuery;
    function GetReason(FilterType:TFilterType): string;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); virtual;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): TFilterResult; virtual; abstract;
    procedure MarkMessage; virtual;
    property FilterType: TFilterType read FFilterType;
    property MarkAs: string read FMarkAs write FMarkAs;
  end;

  TSenderFilter = class(TBaseFilter)
  private
    Exp: TRegExp;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); override;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): TFilterResult; virtual;
  end;

  TStampFilter = class(TBaseFilter)
  private
    Exp: TRegExp;
  public
    constructor Create(ADOCon:TADOConnection;Filter:TFilterType); override;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): TFilterResult; override;
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
    function AnalyzeMessage(Mess:TFMessage): TFilterResult; override;
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

function TSenderFilter.AnalyzeMessage(Mess:TFMessage): TFilterResult;
var
 email,Reason:String;
 Res:boolean;
 sender,mask:String;
begin
  Res:=False;
  Sender:=Mess.Sender.Address;
  with Proc do
   begin       // делать выбоку по типу фильтра
    SQL.Text:='SELECT FVAlue FROM SenderFilter WHERE (Active=TRUE) AND '+
     ' (mid=(SELECT id FROM Filters WHERE type=:FilterType) ) ' ;
    Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
    ExecSQL;
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
      Result.FilterType:=FilterType;
      Result.Reason:=GetReason(FilterType);
     end
    else
     Result.FilterType:=ftNone;
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

function TStampFilter.AnalyzeMessage(Mess:TFMessage): TFilterResult;
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
    Result.FilterType:=FilterType;
    Result.Reason:=GetReason(FilterType);
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

function TSignalFilter.AnalyzeMessage(Mess:TFMessage): TFilterResult;
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
 SQLProc,RowText,FType:String;
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
end;

function TSignalFilter.FindString(InpText:String;SubString:string): Boolean;
begin
 Exp.ShieldingExp:=SubString;
 Exp.Subject:=InpText;
 if Exp.Match then   Result:=True
  else result:=false;

end;


end.



{

свойство фильтра типа должно устанавливаться само при вызове конструктора

}

