library Shared;

uses
  Dialogs,
  Registry,
  ActiveX,
  SysUtils,
  IdHashMessageDigest,
  IdHash,
  ADODB,
  DB,
  Windows,
  ComObj,
  Classes,
  JRO_TLB in '..\Shared\JRO_TLB.pas';

const
  CriptKey=' &(5428396%:?(__*:?:(_(%fGfhhKJHFGHD12_= ';


{$R *.res}

function GetTempFile(const Extension: ShortString):PChar;
var
 Buffer: array[0..MAX_PATH] of Char;
 aFile: string;
begin
 repeat
  GetTempPath(SizeOf(Buffer) - 1, Buffer);
  GetTempFileName(Buffer, '~', 0, Buffer);
  Result := PChar(ChangeFileExt(Buffer, Extension));
  until not FileExists(Result);
end;


function md5(InputString:ShortString): ShortString;
var
  Digest: T4x4LongWordRecord;
  S, S1: string;
  i: Integer;
begin
  SetLength(S, 16);
  with TIdHashMessageDigest5.Create do
    begin
      Digest := HashValue(InputString);
      Move(Digest, S[1], 16);
      for i := 1 to Length(InputString) do
        S1 := S1 + Format('%02x', [Byte(S[i])]);
      while Pos(' ', S1) > 0 do S1[Pos(' ', S1)] := '0';
      Result:=s1;
      Free;
    end;
end;


function GetAppDataPath: PChar;
var
 Key:TRegistry;
begin
 Key:=TRegistry.Create;
 Key.RootKey:=HKEY_CURRENT_USER;
 Key.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',False);
 Result:=PChar(Key.ReadString('AppData'));
 Key.CloseKey;
 Key.Free;
end;

function DBPassword:ShortString;
var
 Sum:ShortString;
begin
  Sum:=md5(CriptKey);
  Result :=Copy(Sum,0,15);
end;


function DatabaseCompact(const sdbName: WideString;Password:ShortString): boolean;
var
 JE : TJetEngine; //Jet Engine
 sdbTemp : WideString; //TEMP database
 sdbTempConn: WideString; //Connection string
const SProvider = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=';
begin
 sdbTemp :=GetTempFile('mdb');
 sdbTempConn := SProvider + sdbtemp+';Jet OLEDB:Database Password=' + Password;
 if FileExists(sdbTemp) then DeleteFile(PChar(sdbTemp));
 JE := TJetEngine.Create(nil);
 try
  try
   JE.CompactDatabase(SProvider + sdbName+';Jet OLEDB:Database Password=' + Password, sdbTempConn);
   DeleteFile(PChar(sdbName));
   RenameFile(sdbTemp, sdbName);
  except
//   on E: Exception do ShowMessage(E.Message);
  end;
 finally
  JE.FreeOnRelease;
  Result := True;
 end;
end;

procedure WriteAppHandle(Handle:DWORD);
var
 Reg: TRegistry;
 Key: string;
begin
 Reg := TRegistry.Create;
 try
  Reg.RootKey := HKEY_CURRENT_USER;
  Key := '\Software\Nevilon\Nevod AntiSpam';
  if Reg.OpenKey(Key, True) then
   begin
    Reg.WriteInteger('Handle',Handle);
    Reg.CloseKey;
   end;
 finally
  Reg.Free
 end;
end;

function GetConnectionString: PChar;
var
 DBPath:String;
begin
 DBPath:=GetAppDataPath+'\Nevilon Software\Nevod AntiSpam';
 Result:=PChar('Provider=Microsoft.Jet.OLEDB.4.0;'+'Data Source='+DBPath+'\messages.ndb;'+
            'Jet OLEDB:Database Password='+DBPassword);
end;

procedure WriteAppPath(AppPath:PChar);
var
 key:TRegistry;
begin
 key:=TRegistry.Create;
 key.RootKey:=HKEY_CURRENT_USER;
 key.OpenKey('\Software\Nevilon\Nevod AntiSpam',True);
 key.WriteString('AppPath',AppPath);
 key.CloseKey;
 key.Free;
end;

function GetAppPath():PChar;
var
 key:TRegistry;
begin
 key:=TRegistry.Create;
 key.RootKey:=HKEY_CURRENT_USER;
 key.OpenKey('\Software\Nevilon\Nevod AntiSpam',True);
 Result:=PChar(key.ReadString('AppPath'));
 key.CloseKey;
 key.Free;
end;

function GetAppHandle():DWORD;
var
 Reg: TRegistry;
 RegKey: DWORD;
 Key: string;
begin
 Reg:= TRegistry.Create;
 try
  Reg.RootKey := HKEY_CURRENT_USER;
  Key := '\Software\Nevilon\Nevod AntiSpam';
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

function IsNormal(DBPath:PChar): Boolean;
var
 adCon:TADOConnection;
 ConStr:PChar;
begin
 ConStr:=PChar('Provider=Microsoft.Jet.OLEDB.4.0;'+'Data Source='+DBPath+';'+
            'Jet OLEDB:Database Password='+DBPassword);


  Coinitialize(nil);
  try
  adCon:=TADOConnection.Create(nil);
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

exports md5,GetAppDataPath,DBPassword,DatabaseCompact,GetTempFile,WriteAppHandle,
         GetConnectionString,WriteAppPath,GetAppPath,GetAppHandle,IsNormal;

begin
end.
