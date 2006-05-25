unit FilterManager;

interface
uses gnugettext,
 Windows,DB,Exceptions,Shared,Dialogs, ADODB,Typinfo,PerlRegEx, Messages,  SysUtils,
 Variants, Classes;

type
  TFilterManager = class
  private
    adProc: TADOQuery;
    Exp: TPerlRegEx;
    procedure Modify(ElementId:Integer;ElementValue:String;FilterType:TFilterType;
        Description:String; Status:Boolean;Params:Variant);
  protected
    procedure Add(ElementValue:String;FilterType:TFilterType;Description:String;
        Status:Boolean;Params:Variant);
  public
    constructor Create(adCon:TADOConnection); virtual;
    destructor Destroy; override;
    procedure Activate(ElementsId:Array of integer;Status:boolean);
    procedure AddElement(ElementValue:String;FilterType:TFilterType;
        Description:String; Status:Boolean;Params:Variant);
    procedure ChangeFilterElementType(ElementsId:Array of integer;
        FilterType:TFilterType);
    procedure DeleteElement(ElementValue:String;FilterType:TFilterType);
    function ElementExists(ElementValue:String;FilterType:TFilterType): Boolean;
        overload;
    function ElementExists(ElementValue:String;ElementId:integer;
        FilterType:TFilterType): Boolean; overload;
    procedure FilterStatus(FilterType:TFilterType;Status:boolean);
    function MidByFilterType(FilterType:TFilterType): Integer;
    procedure ModifyElement(ElementId:Integer;ElementValue:String;
        FilterType:TFilterType; Description:String; Status:Boolean;Params:Variant);
    procedure RemoveElements(ElementsId:array of integer);
    function TwinFilter(FilterType:TFilterType):TFilterType;
  end;

implementation

constructor TFilterManager.Create(adCon:TADOConnection);
begin
 adProc:=TADOQuery.Create(nil);
 adProc.Connection:=adCon;
 Exp:=TPerlRegEx.Create(nil);
end;

destructor TFilterManager.Destroy;
begin
 adProc.Free;
 Exp.Free;
end;

procedure TFilterManager.Activate(ElementsId:Array of integer;Status:boolean);
var
 RowSQl:String;
 i:integer;
begin
 with adProc do
   begin
    for i:=Low(ElementsId) to High(ElementsId) do
     begin
      RowSQL:=RowSQL+ ' id='+IntToStr(ElementsId[i]);
      if i<>High(ElementsId) then RowSQL:=RowSQl+' OR ';
     end;
    Active:=False;
    SQL.Text:='UPDATE  FiltersParams SET Active=:Status WHERE ' + RowSQL;
    Parameters.ParamByName('Status').Value:=Status;
    ExecSQL;
   end;  
end;

procedure TFilterManager.Add(ElementValue:String;FilterType:TFilterType;
    Description:String; Status:Boolean;Params:Variant);
var
 Proc:TADOQuery;
 buf:String;
begin
 Proc:=TADOQuery.Create(nil);
 if FilterType in [ftBlackWord,ftWhiteWord]
   then
    case TSignalLocation(Params) of
     slSubject: buf:='slSubject' ;
     slBody: buf:='slBody';
     slAnywhere: buf:='slAnywhere';
    end;
 Proc.Connection:=adProc.Connection;
 with Proc do
   begin
    Active:=False;
    SQL.Add('INSERT INTO FiltersParams (mid,FValue,Description,Active,Params)');
    SQL.Add(' VALUES (:mid,:Value,:Description,:Active,:Params)');
    Parameters.ParamByName('mid').Value:=MidByFilterType(FilterType);
    Parameters.ParamByName('Value').Value:=ElementValue;
    Parameters.ParamByName('Description').Value:=Description;
    Parameters.ParamByName('Active').Value:=Status;
    Parameters.ParamByName('Params').Value:=buf;
    ExecSQL;
    Active:=False;
   end;
 Proc.Free;
end;

procedure TFilterManager.AddElement(ElementValue:String;FilterType:TFilterType;
    Description:String; Status:Boolean;Params:Variant);
var
 tFilter:TFilterType;
 Flag:boolean;
begin
// if Params=slAnywhere then ShowMessage('');

 ElementValue:=Trim(ElementValue);
 if ElementValue='' then
  Raise EInvalidFilterParams.Create(_('Фильтр не может быть пустым'));
 if not (FilterType in [ftBlackSender,ftWhiteSender,ftStamp,ftBlackWord,ftWhiteWord,
               ftBlackAttach,ftWhiteAttach]) then
   Raise EInvalidFilterParams.Create(_('Неправильный тип фильтра'));

 Flag:=False;;
 if FilterType in [ftWhiteSender,ftBlackSender] then
  begin
   Exp.RegEx:='[_a-zA-Z\d\-\.\*]+@([_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+)';
   Exp.Subject:=ElementValue;
   if  (Exp.Match) and (Exp.MatchedExpression=ElementValue) then  Flag:=True;
    Exp.RegEx:='(?i)(http://www.|http://|www.)([_a-z\d\-]+(\.[_a-z\d\-]+)+)((/[ _a-z\d\-\\\.]+)+)*';
   if (Exp.Match)and (Exp.MatchedExpression=ElementValue) then
    begin
     Flag:=True;
     ElementValue:='*@' +Exp.SubExpressions[2];
    end;
   if not Flag then
     Raise EInvalidFilterParams.Create(_('Адрес отправителя некорректен'));
  end;


 // разобраться с преобразованиями  
 if ((FilterType=ftWhiteWord) or (FilterType=ftBlackWord)) and not( (Params=slAnywhere) or (Params=slSubject)  or (Params=slBody) ) then
   Raise EInvalidFilterParams.Create(_('Неправильное расположение спам-слова'));
 if ElementExists(ElementValue,FilterType) then
   Raise EInvalidFilterParams.Create(_('Фильтр уже есть в данной группе'));
 tFilter:=TwinFilter(FilterType);
 if tFilter<>FilterType then
  if ElementExists(ElementValue,tFilter) then
   Raise EInvalidFilterParams.Create(_(' Фильтр уже есть в противоположной группе '));
   
 Add(ElementValue,FilterType,Description,Status,Params);

end;

procedure TFilterManager.ChangeFilterElementType(ElementsId:Array of integer;
    FilterType:TFilterType);
var
 RowSQl:String;
 i:integer;
begin
 with adProc do
  begin
   for i:=Low(ElementsId) to High(ElementsId) do
    begin
      RowSQL:=RowSQL+ ' id='+IntToStr(ElementsId[i]);
      if i<>High(ElementsId) then RowSQL:=RowSQl+' OR ';
    end;
    Active:=False;
    SQL.Text:='UPDATE FiltersParams SET mid='+IntToStr(MidByFilterType(FilterType)) +' WHERE ' +RowSQl;
    ExecSQL;
  end;
end;

procedure TFilterManager.DeleteElement(ElementValue:String;
    FilterType:TFilterType);
var
 Proc:TADOQuery;
begin
 ElementValue:=Trim(ElementValue);
 Proc:=TADOQuery.Create(nil);
 Proc.Connection:=adProc.Connection;
 with Proc do
  begin
   Active:=False;
   SQL.Text:='DELETE  FROM FiltersParams WHERE  (mid=:mid) AND (FValue=:Value) ';
   Parameters.ParamByName('mid').Value:=MidByFilterType(FilterType);
   Parameters.ParamByName('Value').Value:=ElementValue;
   ExecSQL;
  end;
 Proc.Free;
end;

function TFilterManager.ElementExists(ElementValue:String;
    FilterType:TFilterType): Boolean;
var
 mid:integer;
begin
 ElementValue:=Trim(ElementValue);
 Result:=False;
 mid:=MidByFilterType(FilterType);
 if mid<>-1 then
  with adProc do
    begin
     Active:=False;
     SQL.Text:='SELECT COUNT(id) FROM FiltersParams WHERE mid=:mid AND FVAlue=:FValue';
     Parameters.ParamByName('mid').Value:=mid;
     Parameters.ParamByName('FValue').Value:=ElementValue;
     Active:=True;
     if Fields[0].AsInteger>0 then
      Result:=True
       else Result:=False;
     Active:=False;       
    end;
end;

function TFilterManager.ElementExists(ElementValue:String;ElementId:integer;
    FilterType:TFilterType): Boolean;
var
 Proc:TADOQuery;
begin
 ElementValue:=Trim(ElementValue);
 Result:=False;
 Proc:=TADOQuery.Create(nil);
 Proc.Connection:=adProc.Connection;
 with Proc do
  begin
   Active:=False;
   SQL.Text:='SELECT COUNT(id) FROM FiltersParams WHERE  (id<>:id) AND (mid=:mid) AND (FValue=:Value) ';
   Parameters.ParamByName('id').Value:=ElementId;
   Parameters.ParamByName('mid').Value:=MidByFilterType(FilterType);
   Parameters.ParamByName('Value').Value:=ElementValue;
   Active:=True;
   if Fields[0].AsInteger>0 then
    Result:=True
    else Result:=False;
   Active:=False;
  end;
 Proc.Free;
end;

procedure TFilterManager.FilterStatus(FilterType:TFilterType;Status:boolean);
begin
 with adProc do
   begin
    Active:=False;
    SQL.Text:='UPDATE Filters SET Active=:Status WHERE Type=:FilterType ';
    Parameters.ParamByName('Status').Value:=Status;
    Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
    ExecSQL;
    Active:=False;
   end;
end;

function TFilterManager.MidByFilterType(FilterType:TFilterType): Integer;
begin
 with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT id FROM Filters WHERE Type=:FilterType';
    Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FilterType));
    Active:=True;
    if RecordCount=0 then
       Result:=-1
    else
     Result:=Fields[0].AsInteger;
    Active:=False;
   end;
end;

procedure TFilterManager.Modify(ElementId:Integer;ElementValue:String;
    FilterType:TFilterType; Description:String; Status:Boolean;Params:Variant);
var
 Proc:TADOQuery;
 buf:String;
begin
 Proc:=TADOQuery.Create(nil);
 Proc.Connection:=adProc.Connection;
 case TSignalLocation(Params) of
    slSubject: buf:='slSubject' ;
    slBody: buf:='slBody';
    slAnywhere: buf:='slAnywhere';
  end;

 with Proc do
   begin
    Active:=False;
    SQL.Text:='UPDATE FiltersParams SET mid=:mid,FValue=:Value,Description=:Description,Active=:Status,Params=:Params ' +
               ' WHERE id=:id ';
    Parameters.ParamByName('mid').Value:=MidByFilterType(FilterType);
    Parameters.ParamByName('Value').Value:=ElementValue;
    Parameters.ParamByName('Description').Value:=Description;
    Parameters.ParamByName('Status').Value:=Status;
    Parameters.ParamByName('Params').Value:=buf;
    Parameters.ParamByName('id').Value:=ElementId;
    ExecSQL;
    Active:=False;
   end;
 Proc.Free;
end;

procedure TFilterManager.ModifyElement(ElementId:Integer;ElementValue:String;
    FilterType:TFilterType; Description:String; Status:Boolean;Params:Variant);
var
 tFilter:TFilterType;
 Flag:boolean;
begin
 ElementValue:=Trim(ElementValue);
 if ElementValue='' then
  Raise EInvalidFilterParams.Create(_('Фильтр не может быть пустым'));
 if not (FilterType in [ftBlackSender,ftWhiteSender,ftStamp,ftBlackWord,ftWhiteWord,
               ftBlackAttach,ftWhiteAttach]) then
   Raise EInvalidFilterParams.Create(_('Неправильный тип фильтра'));

 // проверки на корректность адресов

 Flag:=False;;
 if FilterType in [ftWhiteSender,ftBlackSender] then
  begin
   Exp.RegEx:='[_a-zA-Z\d\-\.\*]+@([_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+)';
   Exp.Subject:=ElementValue;
   if  (Exp.Match)and (Exp.MatchedExpression=ElementValue) then  Flag:=True;
    Exp.RegEx:='(?i)(http://www.|http://|www.)([_a-z\d\-]+(\.[_a-z\d\-]+)+)((/[ _a-z\d\-\\\.]+)+)*';
   if (Exp.Match)and (Exp.MatchedExpression=ElementValue) then
    begin
     Flag:=True;
     ElementValue:='*@' +Exp.SubExpressions[2];
    end;
   if not Flag then
     Raise EInvalidFilterParams.Create(_('Адрес отправителя некорректен'));
  end;


 if ((FilterType=ftWhiteWord) or (FilterType=ftBlackWord)) and not( (Params=slAnywhere) or (Params=slSubject)  or (Params=slBody) ) then
   Raise EInvalidFilterParams.Create(_('Неправильное расположение спам-слова'));

 if ElementExists(ElementValue,ElementId,FilterType) then
   Raise EInvalidFilterParams.Create(_('Фильтр уже есть в данной группе'));
 tFilter:=TwinFilter(FilterType);
 if tFilter<>FilterType then
  if ElementExists(ElementValue,ElementId,tFilter) then
   Raise EInvalidFilterParams.Create(_(' Фильтр уже есть в противоположной группе '));
 Modify(ElementId,ElementValue,FilterType,Description,Status,Params);

end;

procedure TFilterManager.RemoveElements(ElementsId:array of integer);
var
 i:integer;
 RowSQl:String;
begin
 RowSQL:='';
 for i:=Low(ElementsId) to High(ElementsId) do
   begin
    RowSQL:=RowSQL+ ' id='+IntToStr(ElementsId[i]);
    if i<>High(ElementsId) then RowSQL:=RowSQl+' OR ';
   end;

 with adProc do
  begin
   Active:=False;
   SQL.Text:='DELETE FROM FiltersParams WHERE ' + RowSQL;
   ExecSQL;
  end;
end;

function TFilterManager.TwinFilter(FilterType:TFilterType):TFilterType;
var
 buff:TFilterType;
begin
 buff:=FilterType;
 if FilterType=ftBlackSender then  buff:=ftWhiteSender;
 if FilterType=ftWhiteSender then  buff:=ftBlackSender;
 if FilterType=ftBlackWord  then  buff:=ftWhiteWord;
 if FilterType=ftWhiteWord then   buff:=ftBlackWord;
 if FilterType=ftBlackAttach then buff:=ftWhiteAttach;
 if FilterType=ftWhiteAttach then buff:=ftBlackAttach;
 if FilterType=ftStamp then buff:=ftNone;
   
 Result:=buff;
end;

end.

