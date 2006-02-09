unit ASFilter;

interface

uses  Shared,
  SysUtils, Windows,DB,TypInfo, ADODB, Messages, Classes, Graphics, Controls,
  Forms, Dialogs;

type
 TBaseFilter = class (TObject)
 private
  ACon: TADOConnection;
  FFilterProcedure: string;
  FilterTable: TADOStoredProc;
  FParams: TFilterParams;
  procedure LoadFilterTable; virtual; abstract;
  procedure SetFilterProcedure(Value: string);
 public
  constructor Create(ADOCon:TADOConnection;FilterParams:TFilterParams); virtual;
  destructor Destroy; override;
  function AnalyzeMessage(Mess:TFMessage): Boolean; virtual; abstract;
  property FilterProcedure: string read FFilterProcedure write 
          SetFilterProcedure;
  property Params: TFilterParams read FParams write FParams;
 end;
 
 TExtensionsFilter = class (TBaseFilter)
 private
  procedure LoadFilterTable; override;
 public
  constructor Create(ADOCon:TADOConnection;FilterParams:TFilterParams); virtual;
  destructor Destroy; override;
  function AnalyzeMessage(Mess:TFMessage): Boolean; override;
 end;
 
 TSenderFilter = class (TBaseFilter)
 private
  function CheckEmail(Email:String): Boolean;
  function GetDomain(Email:String): string;
  procedure LoadFilterTable; override;
 public
  constructor Create(ADOCon:TADOConnection;FilterParams:TFilterParams); virtual;
  destructor Destroy; override;
  function AnalyzeMessage(Mess:TFMessage): Boolean; override;
 end;
 
 TASFilter = class (TObject)
 private
  ACon: TADOConnection;
  FAccountId: Integer;
  FiltersList: TFilterList;
  MessagesList: TADOStoredProc;
  function GetFilterParams(FilterTable:TADOStoredProc): TFilterParams;
  procedure LoadFiltersList; virtual;
  procedure LoadMessagesList; virtual;
  procedure SetAccountId(Value: Integer);
 public
  constructor Create(ADOCon:TADOConnection;AccountId:integer); virtual;
  destructor Destroy; override;
  property AccountId: Integer read FAccountId write SetAccountId;
 end;
 


implementation


{
********************************* TBaseFilter **********************************
}
constructor TBaseFilter.Create(ADOCon:TADOConnection;
        FilterParams:TFilterParams);
begin
 inherited Create;
 ACon:=ADOCon;
 Params:=FilterParams;
 FilterTable:=TADOStoredProc.Create(nil);
 FilterTable.Connection:=ACon;
end;

destructor TBaseFilter.Destroy;
begin
 inherited Destroy;
 FilterTable.Free;
end;

procedure TBaseFilter.SetFilterProcedure(Value: string);
begin
 if FFilterProcedure <> Value then
 begin
   FFilterProcedure := Value;
 end;
end;

{
****************************** TExtensionsFilter *******************************
}
constructor TExtensionsFilter.Create(ADOCon:TADOConnection;
        FilterParams:TFilterParams);
begin
 inherited Create(ADOCon,FilterParams);
 LoadFilterTable();
end;

destructor TExtensionsFilter.Destroy;
begin
 inherited Destroy;
end;

function TExtensionsFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 Flag: Boolean;
begin
 Flag:=False;
 FilterTable.Open;
 FilterTable.First;
 while (NOT FilterTable.Eof) AND (NOT Flag) do
     if Mess.ExtensionExists(Trim(Filtertable.Fields[0].AsString))
       then Flag:=True else FilterTable.Next;
 FilterTable.Close;
 Result:=Flag;
end;

procedure TExtensionsFilter.LoadFilterTable;
begin
 FFilterProcedure:='GetStructFilterTable';
 if FilterTable.Active then FilterTable.Close;
 with FilterTable do
  begin
   ProcedureName:=FFilterProcedure;
   Parameters.Clear;
   Parameters.AddParameter.Name:='FilterName';
   Parameters.ParamByName('FilterName').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FParams.FilterType));
   ExecProc;
  end;
end;

{
******************************** TSenderFilter *********************************
}
constructor TSenderFilter.Create(ADOCon:TADOConnection;
        FilterParams:TFilterParams);
begin
 inherited Create(ADOCon,FilterParams);
 LoadFilterTable();
end;

destructor TSenderFilter.Destroy;
begin
 inherited Destroy;
end;

function TSenderFilter.AnalyzeMessage(Mess:TFMessage): Boolean;
var
 Flag: Boolean;
 domain, Email: string;
 IsDomain: Boolean;
begin
 {
   проверить на примере, правильно ли расставлены условия
 }
 Email:=Trim(Mess.From.Address);
 if Length(Email)=0 then
  begin
   Result:=False;
   Exit;
  end else
  begin
  Flag:=False;
  FilterTable.Open;
  FilterTable.First;
  while (NOT FilterTable.Eof) AND (NOT Flag) do
     if Pos('@',Filtertable.Fields[0].AsString)<>0    // если в поле - адрес
        then
          if Email=Trim(Filtertable.Fields[0].AsString)
            then Flag:=True
            else
               if GetDomain(Email)=Trim(Filtertable.Fields[0].AsString) then Result:=True
        else FilterTable.Next;

  FilterTable.Close;
  Result:=Flag;
  end;
end;

function TSenderFilter.CheckEmail(Email:String): Boolean;
var
 P: Integer;
 User, Domain: string;
 i: Integer;
begin
 Result:= False;
 Email:= Trim(AnsiLowerCase(Email));
 P:= Pos('@', Email);
 if P = 0 then
   Exit;
 User := Copy(Email, 1, P - 1);
 Domain := Copy(Email, P + 1, Length(Email) - P);
 for i := 1 to Length(User) do
   if not (User[i] in ['a'..'z', '0'..'9', '.', '-', '_']) then
     Exit else Result:=true;
end;

function TSenderFilter.GetDomain(Email:String): string;
begin
end;

procedure TSenderFilter.LoadFilterTable;
begin
 FFilterProcedure:='GetStructFilterTable';
 if FilterTable.Active then FilterTable.Close;
 with FilterTable do
  begin
   ProcedureName:=FFilterProcedure;
   Parameters.Clear;
   Parameters.AddParameter.Name:='FilterName';
   Parameters.ParamByName('FilterName').Value:=GetEnumName(TypeInfo(TFilterType), Ord(FParams.FilterType));
   ExecProc;
  end;
end;

{
********************************** TASFilter ***********************************
}
constructor TASFilter.Create(ADOCon:TADOConnection;AccountId:integer);
begin
 inherited Create;
 FAccountId:=AccountId;
 ACon:=ADOCon;
 MessagesList:=TADOStoredProc.Create(nil);
 MessagesList.Connection:=ACon;
 LoadMessagesList;
 FiltersList:=TFilterList.Create;
 LoadFiltersList;
end;

destructor TASFilter.Destroy;
var
 i: Integer;
begin
 inherited Destroy;
 for i:=0 to FiltersList.Count-1 do
   FiltersList.DestroyItem(i);
 FiltersList.Free;
 MessagesList.Free;
end;

function TASFilter.GetFilterParams(FilterTable:TADOStoredProc): TFilterParams;
var
 Res: TFilterParams;
begin
 Res.AccountId:=FAccountId;
 Res.FilterType:=TFilterType(GetEnumValue(TypeInfo(TFilterType),FilterTable.FieldByName('type').AsString));
 Res.Priority:=FilterTable.FieldByName('Priority').AsInteger;
 Res.Subject:=FilterTable.FieldByName('Subject').AsString;
 Result:=Res;
end;

procedure TASFilter.LoadFiltersList;
var
 FilterType: TFilterType;
 Ast: TADOStoredProc;
begin
 Ast:=TADOStoredProc.Create(nil);
 Ast.Connection:=ACon;
 with Ast do
  begin
   if Active then Close;
   Parameters.Clear;
   ProcedureName:='GetActiveFilterList';
   ExecProc;
   Open;
   while NOT Eof do
    begin
     FilterType:=TFilterType(GetEnumValue(TypeInfo(TFilterType),FieldByName('type').AsString));
     case FilterType of
      ftBExt,ftWExt:
        FiltersList.Add(TExtensionsFilter.Create(ACon,GetFilterParams(Ast)));
      ftBEMail,ftWEmail:
        FiltersList.Add(TSenderFilter.Create(ACon,GetFilterParams(Ast)));
     end;
     Next;
    end;
  end;
 Ast.Close;
 Ast.Free;
end;

procedure TASFilter.LoadMessagesList;
begin
 with MessagesList do
  begin
   ProcedureName:='CreateMessageList';
   Parameters.AddParameter.Name:='AccountId';
   Parameters.ParamByName('AccountId').Value:=AccountId;
   ExecProc;
  end;
end;

procedure TASFilter.SetAccountId(Value: Integer);
begin
 if FAccountId <> Value then
 begin
 FAccountId := Value;
 end;
end;


end.
