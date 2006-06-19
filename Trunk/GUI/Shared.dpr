library Shared;

uses
  FastShareMem in '..\Shared\FastShareMem.pas',
  Dialogs,
  //oleauto,
  Controls,
  Registry,
  ActiveX,
  SysUtils,
  ADODB,
  DB,
  Windows,
  ComObj,
  Classes,
  JRO_TLB in '..\Shared\JRO_TLB.pas',
  ADODB_TLB in '..\Shared\ADODB_TLB.pas',
  gnugettext in '..\Libs\gnugettext.pas',
  md5 in '..\Shared\md5.pas';

const
  CriptKey=' &(5428396%:?(__*:?:(_(%fGfhhKJHFGHD12_= ';

{$R *.res}


function GetTempFile(const Extension:PChar):String;stdcall;
var
 Buffer: array[0..MAX_PATH] of Char;
begin
 repeat
  GetTempPath(SizeOf(Buffer) - 1, Buffer);
  GetTempFileName(Buffer, '~', 0, Buffer);
  Result := PChar(ChangeFileExt(Buffer, Extension));
  until not FileExists(Result);
end;


function md5(InputString:String):String;stdcall;
begin
 Result:=MD5DigestToStr(MD5String(InputString));
end;


function GetAppDataPath():String;stdcall;
var
 Key:TRegistry;
begin
 Key:=TRegistry.Create;
 try
  Key.RootKey:=HKEY_CURRENT_USER;
  Key.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',False);
  Result:=Key.ReadString('AppData');
  Key.CloseKey;
 finally
  Key.Free;
 end;
end;

function DBPassword:String; stdcall;
var
 Sum:String;
begin
  Sum:=md5(CriptKey);
  Sum:=Copy(Sum,0,15);
  Result:=Sum;
end;

function GetConnectionString:String;stdcall;
var
 DBPath:String;
begin
 DBPath:=GetAppDataPath+'\Nevilon Software\Nevod AntiSpam';
 Result:='Provider=Microsoft.Jet.OLEDB.4.0;'+'Data Source='+DBPath+'\messages.ndb;'+
            'Jet OLEDB:Database Password='+DBPassword;
end;

function DatabaseCompact: boolean;stdcall;
var
 JE : TJetEngine; //Jet Engine
 sdbTemp :WideString;
 sdbTempConn : WideString; //Connection string
 sdbName:WideString;
const SProvider = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=';
begin
 sdbTemp :=GetTempFile('ndb');
 sdbTempConn := SProvider + sdbTemp+';Jet OLEDB:Database Password=' + DBPassword;
 if FileExists(sdbTemp) then DeleteFile(PChar(sdbTemp));
 JE := TJetEngine.Create(nil);
 try
  try
   JE.CompactDatabase(GetConnectionString, sdbTempConn);
   sdbName:=GetAppDataPath + '\Nevilon Software\Nevod AntiSpam\messages.ndb';
   DeleteFile(PChar(ExtractShortPathName(sdbName)));
   RenameFile(sdbTemp, sdbName);
  except
  // on E: Exception do  ShowMessage(e.Message);//ShowMessage(_('Не могу упаковать базу'));
  end;
 finally
  JE.FreeOnRelease;
  Result := True;
 end;
end;

procedure WriteAppHandle(Handle:DWORD);stdcall;
var
 Reg: TRegistry;
 Key: string;
begin
 Reg := TRegistry.Create;
 try
  Reg.RootKey := HKEY_CURRENT_USER;
  Key := '\Software\Nevilon Software\Nevod AntiSpam';
  if Reg.OpenKey(Key, True) then
   begin
    Reg.WriteInteger('Handle',Handle);
    Reg.CloseKey;
   end;
 finally
  Reg.Free
 end;
end;



procedure WriteAppPath(AppPath:String);stdcall;
var
 key:TRegistry;
begin
 key:=TRegistry.Create;
 try
   key.RootKey:=HKEY_CURRENT_USER;
   key.OpenKey('\Software\Nevilon Software\Nevod AntiSpam',True);
   key.WriteString('AppPath',AppPath);
   key.CloseKey;
 finally
  key.Free;
 end;
end;

function GetAppPath():String;stdcall;
var
 key:TRegistry;
begin
 key:=TRegistry.Create;
 try
  key.RootKey:=HKEY_CURRENT_USER;
  key.OpenKey('\Software\Nevilon Software\Nevod AntiSpam',True);
  Result:=key.ReadString('AppPath');
  key.CloseKey;
 finally
   key.Free;
 end;
end;

function GetAppHandle():DWORD;stdcall;
var
 Reg: TRegistry;
 RegKey: DWORD;
 Key: string;
begin
 Reg:= TRegistry.Create;
 try
  Reg.RootKey := HKEY_CURRENT_USER;
  Key := '\Software\Nevilon Software\Nevod AntiSpam';
  if Reg.OpenKeyReadOnly(Key) then
   begin
    if Reg.ValueExists('Handle') then
     begin
      RegKey := Reg.ReadInteger('Handle');
      Reg.CloseKey;
     end;
   end;
 finally
  Reg.Free
 end;
 Result:=RegKey;
end;

function IsNormal(DBPath:String): Boolean;stdcall;
var
 adCon:TADOConnection;
 ConStr:String ;
begin
 ConStr:=GetConnectionString;
 Coinitialize(nil);
 adCon:=TADOConnection.Create(nil);
 try
  adCon.ConnectionString:=ConStr;
   try
    adCon.Connected:=True;
    adCon.Connected:=False;
    Result:=True;
   except
    Result:=False;
   end;
 finally
  adCon.Free;
 end;
  CoUninitialize;
end;

function TestDBConnnection
begin

end;

exports GetAppDataPath,DBPassword,DatabaseCompact,GetTempFile,WriteAppHandle,
         GetConnectionString,WriteAppPath,GetAppPath,GetAppHandle,IsNormal;

begin
end.
