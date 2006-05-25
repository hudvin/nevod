unit ASFilter;

interface
uses  Dialogs,  masks,   StrUtils, IdAttachment,IdMessageParts, IdMessage,
   Windows,SysUtils,Classes, Shared, ADODB,DB,Typinfo,RegExpr,IdText,PerlRegEx;
type
  TBaseFilter = class
  private
    FExp: TRegExp;
    FFilterType: TFilterType;
    FReason: string;
    FProc: TADOQuery;
    function GetReason(FilterType:TFilterType): string;
  public
    constructor Create(Exp:TRegExp;Proc:TADOQuery;FilterType:TFilterType); virtual;
    function AnalyzeMessage(Mess:TFMessage): Boolean; virtual; abstract;
    procedure MarkMessage; virtual;
    property FilterType: TFilterType read FFilterType;
    property Reason: string read FReason;
  end;

  TSenderFilter = class(TBaseFilter)
  private
  public
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TStampFilter = class(TBaseFilter)
  private
  public
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TSignalFilter = class(TBaseFilter)
  private
    FSignalLocation: TSignalLocation;
    function FindString(InpText:String;SubString:string): Boolean;
  public
    constructor Create(Exp:TRegExp;Proc:TADOQuery;FilterType:TFilterType); overload;
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TImageFilter = class(TBaseFilter)
  private
    MaxImg: Integer;
  public
    constructor Create(Exp:TRegExp;Proc:TADOQuery;FilterType:TFilterType); override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TLinkFilter = class(TBaseFilter)
  private
    MaxLinks: Integer;
  public
    constructor Create(Exp:TRegExp;Proc:TADOQuery;FilterType:TFilterType); override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TAttachmentExtFilter = class(TBaseFilter)
  private
    function GetFileExtension(FileName:string): string;
  public
    constructor Create(Exp:TRegExp;Proc:TADOQuery;FilterType:TFilterType); override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TMessageSizeFilter = class(TBaseFilter)
  private
    MaxSize: Integer;
  public
    constructor Create(Exp:TRegExp;Proc:TADOQuery;FilterType:TFilterType); override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; override;
  end;

  TBaseFilterContainer = class
  private
    Exp: TRegExp;
    FADOCon: TADOConnection;
    FilterList: TList;
    Filters4Loading: set of TFilterType;
    FReason: string;
    Proc: TADOQuery;
    SubProc: TADOQuery;
    procedure AddFilter(FilterType:TFilterType); virtual;
    procedure DeleteFilter(FilterType:TFilterType); virtual;
  public
    constructor Create(ADOCon:TADOConnection); virtual;
    destructor Destroy; override;
    function AnalyzeMessage(Mess:TFMessage): Boolean; virtual;
    procedure LoadFilters; virtual;
    property Reason: string read FReason;
  end;

  TAllowFilterGroup = class(TBaseFilterContainer)
  public
    constructor Create(ADOCon:TADOConnection);
  end;

  TDenyFilterGroup = class(TBaseFilterContainer)
  public
    constructor Create(ADOCon:TADOConnection);
  end;


implementation
uses main, IdEMailAddress;

constructor TBaseFilter.Create(Exp:TRegExp;Proc:TADOQuery;
    FilterType:TFilterType);
begin
  FFilterType:=FilterType;
  FExp:=Exp;
  FProc:=Proc;
end;

function TBaseFilter.GetReason(FilterType:TFilterType): string;
begin
 with FProc do
  begin
   Active:=False;
   SQL.Text:='SELECT Reason FROM Filters WHERE type=:FilterType';
   Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
   Active:=True;
   Result:=Fields[0].AsString;
   Active:=False;
  end; 
end;


procedure TBaseFilter.MarkMessage;
begin
end;


function TSenderFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 Res:boolean;
 sender:String;
begin
  Res:=False;
  Sender:=Mess.From.Address;
  with FProc do
   begin       // делать выбоку по типу фильтра
    Active:=False;
    SQL.Text:='SELECT FVAlue FROM FiltersParams WHERE (Active=TRUE) AND '+
     ' (mid=(SELECT id FROM Filters WHERE type=:FilterType) ) ' ;
    Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
    Active:=True;



    while (not Res) and (not Eof) do
     begin
      FExp.Options:=[preCaseLess];
      FExp.RegEx:=FExp.BuildExp(FieldByName('FValue').AsString);
      FExp.Subject:=Sender;
      if FExp.Match then Res:=True
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


function TStampFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 StrExp:String;
 Flag:boolean;
begin
  Flag:=True;
 if Mess.MessageText<>'' then
  begin
   StrExp:='(?s)(?i)(&lt;|<)(\s*(&nbsp;)*\s*)*Nevod(\s*(&nbsp;)*\s*)*AntiSpam(\s*(&nbsp;)*\s*)*:(\s*(&nbsp;)*\s*)';
   StrExp:=StrExp+'("(\w+)"|'+''''+'(\w+)'+''''+')(\s*(&nbsp;)*\s*)*(&gt;|>)';
   FExp.RegEx :=StrExp;
   FExp.Subject := Mess.MessageText;
   FProc.SQL.Text:='SELECT COUNT(Id) FROM FiltersParams WHERE FValue=:Stamp AND Active=True AND  '+
    ' (mid=(SELECT id FROM Filters WHERE type=:FilterType) ) ' ;
   FProc.Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
   Flag:=True;
   if FExp.Match then
    repeat
     with FProc do
      begin
       Active:=False;
       Parameters.ParamByName('Stamp').Value:=Trim(FExp.SubExpressions[12]);
       Active:=True;
       if Fields[0].AsInteger>0 then Flag:=False;
       Close;
      end;
    until (not FExp.MatchAgain)and (not Flag);
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

constructor TSignalFilter.Create(Exp:TRegExp;Proc:TADOQuery;
    FilterType:TFilterType);
begin
  inherited Create(Exp,Proc,FilterType);
  with Proc do
    begin
     Active:=False;
     SQL.Text:='SELECT Var FROM Settings WHERE Name=FName';
     Parameters.ParamByName('FName').Value:='SignalLocation';
     Active:=True;
     FSignalLocation:=TSignalLocation(GetEnumValue(TypeInfo(TSignalLocation),FieldByName('Var').AsString));
     Active:=False;
    end;
end;

function TSignalFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
 function GetRowText(MessageText:String):String;  // удаляет теги из текста и лишние пробелы
 var buff:String;
 begin
  buff:=MessageText;
  with FExp  do
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
// неправильно определяется текст сообщения
if Mess.BodyType=btHtml then
  RowText:=GetRowText(Mess.MessageText) // получение текста сообщения без тегов и лишних пробелов
 else RowText:=Mess.MessageText;
 FProc.Active:=False;
 FType:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
 case FSignalLocation of  // по каким полям сообщения должен производится поиск
  slAnywhere:
   begin
    FProc.SQL.Text:='SELECT id, FValue,Params,Description FROM FiltersParams  WHERE     (Active=TRUE) AND'  +
     '(Params=:Location_1 OR Params=:Location_2 OR Params=:Location_3)'+
     'AND (mid=(SELECT id FROM Filters WHERE type='+ ''''+FType +'''' +'))';
    FProc.Parameters.ParamByName('Location_1').Value:='slSubject';
    FProc.Parameters.ParamByName('Location_2').Value:='slAnyWhere';
    FProc.Parameters.ParamByName('Location_3').Value:='slBody';
   end;
  slBody:
   begin
    FProc.SQL.Text:='SELECT id, FValue,Params,Description FROM FiltersParams  WHERE     (Active=TRUE) AND'  +
     '(Params=:Location_1 OR Params=:Location_2)'+
     'AND (mid=(SELECT id FROM Filters WHERE type='+ ''''+FType +'''' +'))';
    FProc.Parameters.ParamByName('Location_1').Value:='slAnyWhere';
    FProc.Parameters.ParamByName('Location_2').Value:='slBody';
   end;
  slSubject:
   begin
    FProc.SQL.Text:='SELECT id, FValue,Params,Description FROM FiltersParams  WHERE     (Active=TRUE) AND'  +
     '(Params=:Location_1 OR Params=:Location_2)'+
     'AND (mid=(SELECT id FROM Filters WHERE type='+ ''''+FType +'''' +'))';
    FProc.Parameters.ParamByName('Location_1').Value:='slAnyWhere';
    FProc.Parameters.ParamByName('Location_2').Value:='slSubject';
   end;
 end;


 with FProc do    // поиск слов из таблицы в сообщении
  begin
   FType:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
   Active:=True;
   First;
   Flag:=False;
   while (not FProc.Eof) and (not Flag) do
    begin
     try
      case TSignalLocation(GetEnumValue(TypeInfo(TSignalLocation),FieldByName('Params').AsString)) of    //
       slAnywhere:
        if FindString(RowText+' '+mess.Subject,FProc.FieldByName('FValue').AsString)
         then Flag:=True;
       slSubject:
        if FindString(mess.Subject,FProc.FieldByName('FValue').AsString)
         then Flag:=True ;
       slBody:
        if FindString(RowText,FProc.FieldByName('FValue').AsString)
         then Flag:=True;
      end;
     except
     end;
     FProc.Next;
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
 FExp.RegEx:=FExp.BuildExp(SubString);
 FExp.Subject:=InpText;
 if FExp.Match then   Result:=True
  else result:=false;

end;

constructor TImageFilter.Create(Exp:TRegExp;Proc:TADOQuery;
    FilterType:TFilterType);
begin
  inherited Create(Exp,Proc,FilterType);
  with Proc do
  begin
   Active:=False;
   SQL.Text:='SELECT Var FROM Settings WHERE Name='+'''' +'MaxImg'+'''';
   Active:=True;
   MaxImg:=StrToInt(Fields[0].AsString);
   Active:=False;
  end;
end;

function TImageFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 i:integer;
 Flag:boolean;
begin
  if Mess.MessageText<>'' then
   begin
   i:=0;
   Flag:=True;
   FExp.RegEx:='<\w*img';
  // Exp.Subject:='<img sr=> <img>  <img srcgf>   fvsdfs'; // убрать нафиг - только для проверки
   FExp.Subject:=Mess.MessageText;
   if FExp.Match then
    repeat
     inc(i);
     if (i>MaxImg)
       then Flag:=False;
    until (not FExp.MatchAgain)or (not Flag);
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

constructor TLinkFilter.Create(Exp:TRegExp;Proc:TADOQuery;
    FilterType:TFilterType);
begin
  inherited Create(Exp,Proc,FilterType);
  with Proc do
  begin
   Active:=False;
   SQL.Text:='SELECT Var FROM Settings WHERE Name='+'''' +'MaxLinks'+'''';
   Active:=True;
   MaxLinks:=StrToInt(Fields[0].AsString);
   Active:=False;
  end;
end;

function TLinkFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 i:integer;
 Flag:boolean;
begin
  Flag:=True;
  i:=0;
  if Mess.MessageText<>'' then
   begin
   if Mess.BodyType=btText then
    begin
     FExp.Subject:=Mess.MessageText;
     FExp.RegEx:='(http://www.|http://|www.|https://www.)([_a-z\d\-]+(\.[_a-z\d\-]+)+)((/[ _a-z\d\-\\\.]+)+)*';
     if FExp.Match then
      repeat
       inc(i);
       if (i>MaxLinks) then Flag:=False;
      until (not FExp.MatchAgain)or (not Flag);
    end
     else
      begin
       FExp.Subject:=Mess.MessageText;
       FExp.RegEx:='(http://www.|http://|www.|https://www.)([_a-z\d\-]+(\.[_a-z\d\-]+)+)((/[ _a-z\d\-\\\.]+)+)*';
       i:=0;
       if FExp.Match then
        repeat
         inc(i);
         if (i>MaxLinks) then Flag:=False;
        until (not FExp.MatchAgain)or (not Flag);

       FExp.Subject:=Mess.MessageText;
       FExp.RegEx:='<\s*a\s*href';
      
       if FExp.Match then
        repeat
         inc(i);
         if (i>MaxLinks) then Flag:=False;
        until (not FExp.MatchAgain)or (not Flag);
      end;
   if not Flag then    // количество  превышено
    begin
     Result:=True;
    FReason:=GetReason(FFilterType);//+IntToStr(i);
    end
   else  // количество не превышено
    begin
     Result:=False;
     FReason:='';
    end;
   end;
end;

constructor TAttachmentExtFilter.Create(Exp:TRegExp;Proc:TADOQuery;
    FilterType:TFilterType);
begin
  inherited Create(Exp,Proc,FilterType);
 { with Proc do   // выборка всех расширений для фильтра данного типа
   begin
    Active:=False;
    SQL.Text:='SELECT FVAlue FROM AttachmentExtFilter WHERE (Active=TRUE) AND '+
     ' (mid=(SELECT id FROM Filters WHERE type=:FilterType) ) ' ;
    Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
   end;  }

   {
   код неизвестно зачем !
   }

end;

function TAttachmentExtFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 Flag:boolean;
 i:integer;
 Ext:String;
begin
 i:=0;
 Flag:=False;
 FProc.Active:=False;
 FProc.SQL.Text:='SELECT FVAlue FROM FiltersParams WHERE (Active=TRUE) AND '+
                ' (mid=(SELECT id FROM Filters WHERE type=:FilterType) ) AND FValue=:Ext';
 while (not Flag) AND  (i<Mess.MessageParts.Count) do
  begin
    if Mess.MessageParts.Items[i] is TIdAttachment then
      with FProc do   // поиск данного расширения в таблице
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
 if Flag  then FReason:=GetReason(FFilterType)
  else FReason:='';

 Result:=Flag;
// FReason:=GetReason(FFilterType);
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

constructor TMessageSizeFilter.Create(Exp:TRegExp;Proc:TADOQuery;
    FilterType:TFilterType);
begin
  inherited Create(Exp,Proc,FilterType);
  with Proc do
  begin
   Active:=False;
   SQL.Text:='SELECT Var FROM Settings WHERE Name='+'''' +'MaxSize'+'''';
   Active:=True;
   MaxSize:=StrToInt(Fields[0].AsString);
   Active:=False;
  end;
end;

function TMessageSizeFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
begin
 with FProc do
  begin
   SQL.Text:='SELECT MessSize FROM Messages WHERE messId=:MessageId';
   Parameters.ParamByName('MessageId').Value:=Mess.MsgId;
   Active:=True;
   if RecordCount>0 then
    if StrToInt(FieldByName('MessSize').AsString)>MaxSize
     then   Result:=True
      else Result:=False
    else Result:=False;
   Active:=False;
  end;
 if Result then FReason:=GetReason(FFilterType)
    
end;

constructor TBaseFilterContainer.Create(ADOCon:TADOConnection);
begin
 FADOCon:=ADOCon;
 FilterList:=TList.Create;
 SubProc:=TADOQuery.Create(nil);
 SubProc.Connection:=FADOCon;
 Exp:=TRegExp.Create(nil);
 Proc:=TADOQuery.Create(nil);
 Proc.Connection:=FADOCon;
 LoadFilters;
end;

destructor TBaseFilterContainer.Destroy;
var
 i:integer;
begin
 for  i:= 0 to FilterList.Count-1 do     // удаление объктов-фильтров из списка
     TBaseFilter(FilterList[i]).Free;
 FilterList.Free;
 Exp.Free;
 Proc.Free;
 SubProc.Free;
end;

procedure TBaseFilterContainer.AddFilter(FilterType:TFilterType);
begin
  case FilterType of
    ftBlackSender: FilterList.Add(TSenderFilter.Create(Exp,Proc,ftBlackSender));
    ftWhiteSender: FilterList.Add(TSenderFilter.Create(Exp,Proc,ftWhiteSender));
    ftStamp: FilterList.Add(TStampFilter.Create(Exp,Proc,ftStamp));
    ftBlackWord: FilterList.Add(TSignalFilter.Create(Exp,Proc,ftBlackWord)) ;
    ftWhiteWord:FilterList.Add(TSignalFilter.Create(Exp,Proc,ftWhiteWord)) ;
    ftImageFilter:FilterList.Add(TImageFilter.Create(Exp,Proc,ftBlackWord)) ;
    ftLinkFilter:FilterList.Add(TLinkFilter.Create(Exp,Proc,ftLinkFilter)) ;
    ftBlackAttach:FilterList.Add(TAttachmentExtFilter.Create(Exp,Proc,ftBlackAttach));
    ftWhiteAttach:FilterList.Add(TAttachmentExtFilter.Create(Exp,Proc,ftWhiteAttach));
    ftMessSize:FilterList.Add(TMessageSizeFilter.Create(Exp,Proc,ftMessSize));
   // ftSpamWord:FIlterList.Add(TCOmplexFilter.Create(Exp,Proc,ftSpamWord));
  end;
end;

function TBaseFilterContainer.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 Flag:boolean;
 i:integer;
begin
 Flag:=False;
 i:=0;
 while (not Flag) and (i<FilterList.Count) do
  if TBaseFilter(FilterList[i]).AnalyzeMessage(Mess) then
   begin
    Flag:=True;
    FReason:=TBaseFilter(FilterList[i]).Reason;
   end
   else
    begin
     FReason:=''; 
     inc(i);
    end;
 Result:=Flag;
  {
  True  - подошло под фильтр
  False - не подошло под фильтр
  }
end;

procedure TBaseFilterContainer.DeleteFilter(FilterType:TFilterType);
var
 i:integer;
begin
 // удаление фильтра из списка по типу фильтра ( по классу объекта )
 for i:=0 to FilterList.Count-1 do
  if TBaseFilter(FilterList[i]).FilterType=FilterType then   // поиск объкта нужного класса
   begin
     TBaseFilter(FilterList[i]).Free;
     FilterList[i]:=nil;
     FilterList.Pack;
   end;
end;

procedure TBaseFilterContainer.LoadFilters;
var
 TabFilter:TFilterType;
begin
 with SubProc do
   begin
    SQL.Text:='SELECT Type FROM Filters WHERE Active=TRUE ORDER By Priority ';
    Active:=TRUE;
    while not Eof do
      begin
       TabFilter:=TFilterType(GetEnumValue(TypeInfo(TFilterType),FieldByName('Type').AsString));
       if TabFilter in Filters4Loading then
        AddFilter(TabFilter);
       Next;
      end;
    Active:=False;
   end;
end;

constructor TAllowFilterGroup.Create(ADOCon:TADOConnection);
begin
  Filters4Loading:=[ftWhiteSender,ftStamp,ftWhiteWord,ftWhiteAttach];
  inherited Create(ADOCon);
end;

constructor TDenyFilterGroup.Create(ADOCon:TADOConnection);
begin
  Filters4Loading:=[ftBlackSender,ftBlackWord,ftImageFilter,ftLinkFilter,ftBlackAttach,ftMessSize];
  inherited Create(ADOCon);
end;



end.

