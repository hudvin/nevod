unit Settings;

interface
uses
    ADODB,DB,Exceptions;

type
  TPostSettings = class
  private
    function GetSetting(SettingName:String): string;
    procedure SetSetting(SettingName:String; const Value: string);
  protected
    FADOCon: TADOConnection;
    SettingsProc: TADOQuery;
  public
    constructor Create(ADOCon:TADOConnection);
    destructor Destroy; override;
    property Setting[Name:String]: string read GetSetting write SetSetting;
  end;



implementation


constructor TPostSettings.Create(ADOCon:TADOConnection);
begin
 FADOCon:=ADOCon;
 SettingsProc:=TADOQuery.Create(nil);
 SettingsProc.Connection:=FADOCon;
end;

destructor TPostSettings.Destroy;
begin
 SettingsProc.Free;
 FADOCon:=nil;
end;

function TPostSettings.GetSetting(SettingName:String): string;
begin
 with SettingsProc  do
  begin
   Close;
   SQL.Text:='SELECT Var FROM Settings WHERE Name=:SettingName';
   Parameters.ParamByName('Settingname').Value:=SettingName;
   ExecSQL;
   Open;
   if RecordCount=0 then    // если выборка не вернула записей
    begin
     Close;
     Result:='';
     Raise EInvalidSettingName.Create(' Invalid Setting Name ');
    end
   else
    begin
     Result:=Fields[0].AsString;
     Close;
    end; 
  end;
end;

procedure TPostSettings.SetSetting(SettingName:String; const Value: string);
begin
 with SettingsProc do
  begin
   Close;
   SQL.Text:='SELECT COUNT (Id) FROM Settings WHERE Name=:SettingName';
   Parameters.ParamByName('SettingName').Value:=SettingName;
   ExecSQL;
   Open;
   if Fields[0].AsInteger=0 then
    begin
     Close;
     Raise EInvalidSettingName.Create(' Invalid Setting Name ');
    end
   else
    begin
     Close;
     SQL.Text:='UPDATE Settings SET Var=:Value WHERE Name=:SettingName';
     Parameters.ParamByName('Value').Value:=Value;
     Parameters.ParamByName('SettingName').Value:=SettingName;
     ExecSQL;
    end;
  end;
end;
end.

{

если настройки повреждены - восстанавливать дефолтовые значения
базу закрывать на пароль - чтобы было невозможно поверидить настройки


 все данные читать из поля
 свойство для записи данных в таблицу (с проверкой или без)
 процедура для обновления 



}
