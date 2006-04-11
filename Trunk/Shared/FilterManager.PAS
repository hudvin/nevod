unit FilterManager;

interface
uses
 Windows,DB,Exceptions, ADODB,Typinfo, Messages, Shared, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs;
type
  TFilterManager = class
  private
    adProc: TADOQuery;
    FBlackWordsTab: TADOQuery;
    FStampTab: TADOQuery;
    FWhiteWordsTab: TADOQuery;
  public
    constructor Create(adCon:TADOConnection;BlackWordsTab,WhiteWordsTab,
        StampTab:TADOQuery);
    destructor Destroy; override;
    procedure AddSender(Value:String;Description:String;SenderType:TFilterType;
        Active:boolean);
    procedure AddSignal(Value:String;Description:String;SignalType:TFilterType;
        Location:TSignalLocation;Active:Boolean);
    procedure AddStamp(Value:String;Description:String;Status:Boolean);
    procedure ModifySender(SenderId:Integer;Value:String;Description:String;
        SenderType:TFilterType; Active:boolean);
    procedure ModifySignal(SignalId:Integer;Value:String;Description:String;
        SignalType:TFilterType;Location:TSignalLocation; Active:Boolean);
    procedure ModifyStamp(StampId:Integer;Value:String;Description:String;
        Status:boolean);
    procedure RemoveSender(SenderId:Integer);
    procedure RemoveSignal(SignalId:Integer);
    procedure RemoveStamp(StampId:Integer);
    procedure SetStampStatus(StampsId: Array of Integer;Status:boolean);
  end;

implementation

constructor TFilterManager.Create(adCon:TADOConnection;BlackWordsTab,
    WhiteWordsTab, StampTab:TADOQuery);
begin
 adProc:=TADOQuery.Create(nil);
 adProc.Connection:=adCon;
 FBlackWordsTab:=BlackWordsTab;
 FWhiteWordsTab:=WhiteWordsTab;
 FStampTab:=StampTab;
end;

destructor TFilterManager.Destroy;
begin
 adProc.Free;
end;

procedure TFilterManager.AddSender(Value:String;Description:String;
    SenderType:TFilterType;Active:boolean);
var
 mid:Integer;
begin
 Value:=Trim(Value);
 if Value='' then
  Raise EInvalidFilterParams.Create('Адрес отправителя не может быть пустным');
 if NOT ((SenderType=ftBlackEmail) or (SenderType=ftWhiteEmail)) then
  Raise EInvalidFilterParams.Create('Неправильный тип фильтра');

 with adProc do  // есть ли элемент в таблице
   begin
    Active:=False;
    SQL.Text:='SELECT COUNT(Id) FROM SenderFilter WHERE FValue=:Value ';
    Parameters.ParamByName('Value').Value:=Value;
    Active:=True;
    if Fields[0].AsInteger>0 then
     begin
      Active:=False;
      Raise EInvalidFilterParams.Create('Данный отпрвитель уже есть в списке');
     end;
    Active:=False;
    SQL.Text:='SELECT id FROM Filters WHERE Type=:FilterType';
    Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(SenderType));
    Active:=True;
    mid:=Fields[0].AsInteger;
    Active:=False;

    SQL.Text:='INSERT INTO SenderFilter(mid,FValue,Description,Active) ' +
               'VALUES(:mid,:Value,:Description,:Active)';
    Parameters.ParamByName('mid').Value:=mid;
    Parameters.ParamByName('Value').Value:=Value;
    Parameters.ParamByName('Description').Value:=Description;
    Parameters.ParamByName('Active').Value:=Active;
    ExecSQL;
   end;
end;

procedure TFilterManager.AddSignal(Value:String;Description:String;
    SignalType:TFilterType; Location:TSignalLocation;Active:Boolean);
var
 mid:Integer;
begin
 Value:=Trim(Value);
 if Value='' then
  Raise EInvalidFilterParams.Create(' Сигнал не может быть пустым ');
 if  NOT ((SignalType=ftBlackWord) or (SignalType=ftWhiteWord)) then
  Raise EInvalidFilterParams.Create(' Неправильный ти фильтра ');

 with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT COUNT (Id) FROM SignalFilter WHERE FValue=:Value';
    Parameters.ParamByName('Value').Value:=Value;
    Active:=True;
    if Fields[0].AsInteger>0 then
     begin
      Active:=False;
      Raise EInvalidFilterParams.Create('Данное слово уже есть в таблице');
     end;
    Active:=False;
   end;

 with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT id FROM Filters WHERE Type=:FilterType';
    Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(SignalType));
    Active:=True;
    mid:=Fields[0].AsInteger;
    Active:=False;

    SQL.Text:='INSERT INTO SignalFilter(mid,FValue,Location,Description,Active) ' +
               'VALUES(:mid,:Value,:Location,:Description,:Active)';
    Parameters.ParamByName('mid').Value:=mid;
    Parameters.ParamByName('Value').Value:=Value;
    Parameters.ParamByName('Location').Value:=GetEnumName(TypeInfo(TSignalLocation), Ord(SignalType));
    Parameters.ParamByName('Description').Value:=Description;
    Parameters.ParamByName('Active').Value:=Active;
    ExecSQL;
   end;
end;

procedure TFilterManager.AddStamp(Value:String;Description:String;
    Status:Boolean);
begin
 Value:=Trim(Value);
 if Value='' then
  Raise EInvalidFilterParams.Create('Stamp cannot be empty');

 with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT COUNT(Id) FROM StampFilter WHERE FValue=:Value';
    Parameters.ParseSQL(SQL.Text,True);
    Parameters.ParamByName('Value').Value:=Value;
    Active:=True;
    if Fields[0].AsInteger>0 then
     begin
      Close;
      Raise EInvalidFilterParams.Create(' Данный штамп уже есть в таблице ');
     end;
    Active:=False;
    SQL.Text:='INSERT INTO StampFilter(FValue,Description,Active) '+
               'VALUES(:Value,:Description,:Active)';
    Parameters.ParamByName('Value').Value:=Value;
    Parameters.ParamByName('Description').Value:=Description;
    Parameters.ParamByName('Active').Value:=Status;
    ExecSQL;
    FStampTab.Requery;
   end;
end;

procedure TFilterManager.ModifySender(SenderId:Integer;Value:String;
    Description:String; SenderType:TFilterType; Active:boolean);
var
 mid:Integer;
begin
 Value:=Trim(Value);
 if SenderId<1  then
  Raise EInvalidFilterParams.Create('Неправильный id отправителя');
 if Value='' then
  Raise EInvalidFilterParams.Create('Значение отпрвителя не может быть пустым');

 with adProc do
   begin
    Active:=False;
    SQl.Text:='SELECT COUNT(Id) FROM SenderFilter WHERE FValue=:Value AND Id<>:SenderId ';
    Parameters.ParamByName('Value').Value:=Value;
    Parameters.ParamByName('SenderId').Value:=SenderId;
    Active:=True;
    if Fields[0].AsInteger>0 then
     begin
      Active:=False;
      Raise EInvalidFilterParams.Create('Данный отпарвитель уже есть  в таблице');
     end;
   end;

  with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT id FROM Filters WHERE Type=:FilterType';
    Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(SenderType));
    Active:=True;
    mid:=Fields[0].AsInteger;
    Active:=False;
    SQL.Text:='UPDATE SenderFilter SET mid=:mid, FValue=:Value,Descripton=:Description,Active=:Active'+
              'WHERE Id=:SenderId';
    Parameters.ParamByName('mid').Value:=mid;
    Parameters.ParamByName('Value').Value:=Value;
    Parameters.ParamByName('Description').Value:=Description;
    Parameters.ParamByName('Active').Value:=Active;
    Parameters.ParamByName('SenderId').Value:=SenderId;
    ExecSQL;
    FStampTab.Requery;
   end;
end;

procedure TFilterManager.ModifySignal(SignalId:Integer;Value:String;
    Description:String; SignalType:TFilterType;Location:TSignalLocation;
    Active:Boolean);
var
 mid:Integer;
begin
 Value:=Trim(Value);
 if SignalId<1 then
  Raise EInvalidFilterParams.Create('Неправильный id сигнала');
 if Value='' then
  Raise EInvalidFilterParams.Create(' Сигнал не может быть пустым ');
 if  NOT ((SignalType=ftBlackWord) or (SignalType=ftWhiteWord)) then
  Raise EInvalidFilterParams.Create(' Неправильный ти фильтра ');

 with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT COUNT (Id) FROM SignalFilter WHERE FValue=:Value'+
              'AND id<>:SignalId ' ;
    Parameters.ParamByName('Value').Value:=Value;
    Parameters.ParamByName('SignalId').Value:=SignalId;
    Active:=True;
    if Fields[0].AsInteger>0 then
     begin
      Active:=False;
      Raise EInvalidFilterParams.Create('Данное слово уже есть в таблице');
     end;
    Active:=False;
   end;

 with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT id FROM Filters WHERE Type=:FilterType';
    Parameters.ParamByName('FilterType').Value:=GetEnumName(TypeInfo(TFilterType), Ord(SignalType));
    Active:=True;
    mid:=Fields[0].AsInteger;
    Active:=False;

    SQL.Text:='UPDATE SignalFilter SET mid=:mid,FValue=:Value,Location=:Location,'+
              ' Description=:Description,Active=:Active)';
    Parameters.ParamByName('mid').Value:=mid;
    Parameters.ParamByName('Value').Value:=Value;
    Parameters.ParamByName('Location').Value:=GetEnumName(TypeInfo(TSignalLocation), Ord(Location));
    Parameters.ParamByName('Description').Value:=Description;
    Parameters.ParamByName('Active').Value:=Active;
    ExecSQL;
    Active:=False;
   end;
end;

procedure TFilterManager.ModifyStamp(StampId:Integer;Value:String;
    Description:String; Status:boolean);
begin
 Value:=Trim(Value);
 if StampId<1  then
  Raise EInvalidFilterParams.Create('Invalid Stamp');
 if Value='' then
  Raise EInvalidFilterParams.Create('Stamp cannot be empty');

 with adProc do
   begin
    Active:=False;
    SQl.Text:='SELECT COUNT(Id) FROM StampFilter WHERE FValue=:Value AND Id<>:StampId ';
    Parameters.ParamByName('Value').Value:=Value;
    Parameters.ParamByName('StampId').Value:=StampId;
    Active:=True;
    if Fields[0].AsInteger>0 then
     begin
      Active:=False;
      Raise EInvalidFilterParams.Create('Даннй штамп уже есть в таблице');
     end;
    Active:=False;
    SQL.Text:='UPDATE StampFilter SET FValue=:Value,Description=:Description,Active=:Active '+
              ' WHERE Id=:StampId';
    Parameters.ParamByName('Value').Value:=Value;
    Parameters.ParamByName('Description').Value:=Description;
    Parameters.ParamByName('Active').Value:=Status;
    Parameters.ParamByName('StampId').Value:=StampId;
    ExecSQL;
    FStampTab.Requery;
   end;
end;

procedure TFilterManager.RemoveSender(SenderId:Integer);
begin
if SenderId<1 then
  Raise EInvalidFilterParams.Create(' Неправильный id отправителя ');

 with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT COUNT(Id) FROM SenderFilter WHERE Id=:Id';
    Parameters.ParamByName('Id').Value:=SenderId;
    Active:=True;
    if Fields[0].AsInteger=0 then
     begin
      Active:=False;
      Raise EInvalidFilterParams.Create('Отправитель с данными id не существует ');
     end;
    Active:=False;
    SQl.Text:='DELETE FROM SenderFilter WHERE id=:Id';
    Parameters.ParamByName('Id').Value:=SenderId;
    ExecSQL;
    Active:=False;
   end;
end;

procedure TFilterManager.RemoveSignal(SignalId:Integer);
begin
 if SignalId<1 then
  Raise EInvalidFilterParams.Create(' Неправильный id сигнала ');

 with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT COUNT(Id) FROM SignalFilter WHERE Id=:Id';
    Parameters.ParamByName('Id').Value:=SignalId;
    Active:=True;
    if Fields[0].AsInteger=0 then
     begin
      Active:=False;
      Raise EInvalidFilterParams.Create('Сигнала с данными id не существует ');
     end;
    Active:=False;
    SQl.Text:='DELETE FROM SignalFilter WHERE id=:Id';
    Parameters.ParamByName('Id').Value:=SignalId;
    ExecSQL;
    Active:=False;
   end;
end;

procedure TFilterManager.RemoveStamp(StampId:Integer);
begin
 if StampId<1  then
  Raise EInvalidFilterParams.Create('Invalid Stamp');

 with adProc do
   begin
    Active:=False;
    SQL.Text:='SELECT COUNT(Id) FROM StampFilter WHERE Id=:StampId ';
    Parameters.ParamByName('StampId').Value:=StampId;
    Active:=True;
    if Fields[0].AsInteger=0 then
     begin
      Close;
      Raise EInvalidFilterParams.Create(' Данный штамп в таблице не обнаружен ');
     end;
    Active:=False;
   end;

 with adProc do
  begin
   Active:=False;
   SQL.Text:='DELETE  FROM StampFilter WHERE Id=:StampId ';
   Parameters.ParamByName('StampId').Value:=StampId;
   ExecSQL;
  end;
end;

procedure TFilterManager.SetStampStatus(StampsId: Array of Integer;
    Status:boolean);
var
 i:integer;
 RowSQL:String;
begin
 RowSQL:='';
 for i := Low(StampsId) to High(StampsId) do
  begin
   RowSQL:=RowSQL+ ' id='+IntToStr(StampsId[i]);
   if i<>High(StampsId) then RowSQL:=RowSQl+' OR ';
  end;

 with adProc do
  begin
   Active:=False;
   SQL.Text:='UPDATE StampFilter SET Active=:Status WHERE ' + RowSQL;
   Parameters.ParamByName('Status').Value:=Status;
   ExecSQL;
  end;
 FStampTab.Requery;
end;

{

вынести проверку наличия в таблице в отдельные ф-ии

}
end.
