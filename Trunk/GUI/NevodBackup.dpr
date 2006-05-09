program NevodBackup;
{$R ..\Resources\WinXP.res}

uses
  SysUtils,tlhelp32, Messages,ActiveX,Classes,Registry,ComObj,ZLib,Windows,ADODB,DB,IdHashMessageDigest,IdHash,Dialogs;
 type
  TCompressor = class
  public
    procedure CompressStream(InputStream, OutputStream: TStream);
    procedure DecompressStream(InputStream, OutputStream: TStream);
  end;

const
  CriptKey=' &(5428396%:?(__*:?:(_(%fGfhhKJHFGHD12_= ';
  MutexName='{94FA4497-A317-4C45-9B57-A0558F8221D7}';

procedure PackDB(DatabaseName: string; DestDatabaseName: string = ''; Password:
    string = '');
const
  Provider = 'Provider=Microsoft.Jet.OLEDB.4.0;';
var
  TempName: array[0..MAX_PATH] of Char;
  TempPath,Name: string;
  Src, Dest: WideString;
  V: Variant;
begin
  Src := Provider + 'Data Source=' + DatabaseName;
  if DestDatabaseName <> '' then Name := DestDatabaseName
  else
   begin
    TempPath := ExtractFilePath(DatabaseName);
    if TempPath = '' then TempPath := GetCurrentDir;
    GetTempFileName(PChar(TempPath), 'ndb', 0, TempName);
    Name := StrPas(TempName);
   end;
   DeleteFile(PChar(Name));
   Dest := Provider + 'Data Source=' + Name;
   if Password <> '' then
    begin
     Src := Src + ';Jet OLEDB:Database Password=' + Password;
     Dest := Dest + ';Jet OLEDB:Database Password=' + Password;
    end;
    V := CreateOleObject('jro.JetEngine');
    try
      V.CompactDatabase(Src, Dest);
    finally
      V := 0;
    end;
    if DestDatabaseName = '' then
    begin
     DeleteFile(PChar(DatabaseName));
     RenameFile(Name, DatabaseName);
    end;
end;

function md5(InputString:string): string;
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

function GetAppDataPath: string;
var
 Key:TRegistry;
begin
 Key:=TRegistry.Create;
 Key.RootKey:=HKEY_CURRENT_USER;
 Key.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',False);
 Result:=Key.ReadString('AppData');
 Key.CloseKey;
 Key.Free;
end;

function GetAppPath():String;
var
 key:TRegistry;
begin
 key:=TRegistry.Create;
 key.RootKey:=HKEY_CURRENT_USER;
 key.OpenKey('\Software\Nevilon\Nevod AntiSpam',True);
 Result:=key.ReadString('AppPath');
 key.CloseKey;
 key.Free;
end;

function DBPassword: string;
begin
  Result := Copy((md5(CriptKey+MutexName)),0,15);
end;

function GetConnectionString: string;
var
 DBPath:String;
begin
 DBPath:=GetAppDataPath+'\Nevilon Software\Nevod AntiSpam';
 Result:='Provider=Microsoft.Jet.OLEDB.4.0;'+'Data Source='+DBPath+'\messages.ndb;'+
            'Jet OLEDB:Database Password='+DBPassword;
end;

function IsNormal(DBPath:String): Boolean;
var
 adCon:TADOConnection;
begin
  try
    adCon:=TADOConnection.Create(nil);
    adCon.ConnectionString:=GetConnectionString;
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
end;

procedure CreateBackUp();
var
 selFile:TSaveDialog;
 DBStream,pDBStream:TFileStream;
 ZCom:TCompressor;
 DBPath:String;
 canExit:boolean;
begin
 canExit:=False;
 DBPath:=GetAppDataPath+'\Nevilon Software\Nevod AntiSpam\messages.ndb';
 if not FileExists(DBPath) then
  begin
   ShowMessage('ѕользовательска€ база данных не обнаружена !');
   CanExit:=True;
  end;
 if (not CanExit)and (not IsNormal(DBPath)) then
  begin
   CanExit:=True;
   ShowMessage('Ќевозможно подключитьс€ к базе данных');
  end;

 if not CanExit then
   try
    PackDB(DBPath,'',DBPassword);
   except
    ShowMessage('Ќевозможно запаковать базу ');
   end;

 selFile:=TSaveDialog.Create(nil);
 selFile.Options:=[ofOverwritePrompt];
 selFile.Filter:='–езервный копии(*.nbk)|*.nbk';   //'|*.nbk';
 if (not CanExit)and (selFile.Execute)  then
  begin
   if not CanExit then
     try
      try
       DBStream:=TFileStream.Create(DBPath,fmShareDenyNone);
       pDBStream:=TFileStream.Create(selFile.FileName+'.nbk',fmCreate);
       ZCom:=TCompressor.Create;
       ZCom.CompressStream(DBStream,pDBStream);
      except
       on e:Exception do
          ShowMessage(E.Message);
      // ShowMessage('Ќевозможно создать резервную копию');
      end;
     finally
      if DBStream<>nil then DBStream.Free;
      if pDBStream<>nil then pDBStream.Free;
      if ZCom<>nil then  ZCom.Free;
     end;
  end;
 selFile.Free;
end;


procedure RestoreFromBackUp();
begin
 {

 запросить путь к запакованной базе
 проверить, не существует ли конечна€ база данных
 распаковать и сохранить

 }


end;

{
********************************* TCompressor **********************************
}
procedure TCompressor.CompressStream(InputStream, OutputStream: TStream);
var
  InpBuf, OutBuf: Pointer;
  InpBytes, OutBytes: Integer;
begin
  InpBuf := nil;
  OutBuf := nil;
  InputStream.Position := 0;
  try
   GetMem(InpBuf, InputStream.Size);
   InpBytes := InputStream.Read(InpBuf^, InputStream.Size);
   CompressBuf(InpBuf, InpBytes, OutBuf, OutBytes);
   OutputStream.Write(OutBuf^, OutBytes);
  finally
   if InpBuf <> nil then FreeMem(InpBuf);
   if OutBuf <> nil then FreeMem(OutBuf);
  end;
end;

procedure TCompressor.DecompressStream(InputStream, OutputStream: TStream);
var
  InpBuf, OutBuf: Pointer;
  OutBytes, sz: Integer;
begin
  InpBuf := nil;
  OutBuf := nil;
  InputStream.Seek(0,0);
  sz:=InputStream.Size;
  if sz > 0 then
    try
      GetMem(InpBuf, sz);
      InputStream.Read(InpBuf^, sz);
      DecompressBuf(InpBuf, sz, 0, OutBuf, OutBytes);
      OutputStream.Write(OutBuf^, OutBytes);
     finally
      if InpBuf <> nil then FreeMem(InpBuf);
      if OutBuf <> nil then FreeMem(OutBuf);
     end;
  OutputStream.Position:= 0;
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

var
 IsRunning:boolean;

begin
 IsRunning:=False;
 CoInitialize(nil);
if PostMessage(GetAppHandle,WM_QUIT, 0, 0) then
 begin
  sleep(300);
  IsRunning:=True;
 end;
 CreateBackUp;
 if IsRunning then WinExec(PChar(GetAppPath),SW_SHOWNORMAL);
 CoUninitialize;
end.
