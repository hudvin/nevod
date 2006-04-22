unit FilterManager;

interface
uses
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
    procedure AddElement(ElementValue:String;FilterType:TFilterType;
        Description:String; Status:Boolean;Params:Variant);
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

procedure TFilterManager.Add(ElementValue:String;FilterType:TFilterType;
    Description:String; Status:Boolean;Params:Variant);
var
 Proc:TADOQuery;
 buf:String;
begin
 Proc:=TADOQuery.Create(nil);
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
begin
// if Params=slAnywhere then ShowMessage('');
   
 ElementValue:=Trim(ElementValue);
 if ElementValue='' then
  Raise EInvalidFilterParams.Create('Фильтр не может быть пустым');
 if not (FilterType in [ftBlackSender,ftWhiteSender,ftStamp,ftBlackWord,ftWhiteWord,
               ftBlackAttach,ftWhiteAttach,ftSpamWord]) then
   Raise EInvalidFilterParams.Create('Неправильный тип фильтра');

 if FilterType in [ftWhiteSender,ftBlackSender] then
  begin
   Exp.RegEx:='[_a-zA-Z\d\-\.\*]+@([_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+)';
   Exp.Subject:=ElementValue;
   if not Exp.Match then
    Raise EInvalidFilterParams.Create('Адрес отправителя некорректен');
  end;
 // разобраться с преобразованиями  
 if ((FilterType=ftWhiteWord) or (FilterType=ftBlackWord)) and not( (Params=slAnywhere) or (Params=slSubject)  or (Params=slBody) ) then
   Raise EInvalidFilterParams.Create('Неправильное расположение спам-слова');
 if ElementExists(ElementValue,FilterType) then
   Raise EInvalidFilterParams.Create('Фильтр уже есть в данной группе');
 tFilter:=TwinFilter(FilterType);
 if tFilter<>FilterType then
  if ElementExists(ElementValue,tFilter) then
   Raise EInvalidFilterParams.Create(' Фильтр уже есть в противоположной группе ');
   
 Add(ElementValue,FilterType,Description,Status,Params);

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
begin
 ElementValue:=Trim(ElementValue);
 if ElementValue='' then
  Raise EInvalidFilterParams.Create('Фильтр не может быть пустым');
 if not (FilterType in [ftBlackSender,ftWhiteSender,ftStamp,ftBlackWord,ftWhiteWord,
               ftBlackAttach,ftWhiteAttach,ftSpamWord]) then
   Raise EInvalidFilterParams.Create('Неправильный тип фильтра');

 if ((FilterType=ftWhiteWord) or (FilterType=ftBlackWord)) and not( (Params=slAnywhere) or (Params=slSubject)  or (Params=slBody) ) then
   Raise EInvalidFilterParams.Create('Неправильное расположение спам-слова');

 if ElementExists(ElementValue,ElementId,FilterType) then
   Raise EInvalidFilterParams.Create('Фильтр уже есть в данной группе');
 tFilter:=TwinFilter(FilterType);
 if tFilter<>FilterType then
  if ElementExists(ElementValue,ElementId,tFilter) then
   Raise EInvalidFilterParams.Create(' Фильтр уже есть в противоположной группе ');
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
 {

 все управление фильтрами перенести в один класс

 }
end.

