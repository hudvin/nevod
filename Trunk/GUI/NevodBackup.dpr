program NevodBackup;
{$R ..\Resources\WinXP.res}

uses
  SysUtils,tlhelp32, ActiveX,Classes,Registry,ComObj,ZLib,Windows,ADODB,DB,IdHashMessageDigest,IdHash,Dialogs;
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
 try
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
 except
    on E: Exception do
    // ShowMessage(e.message);
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
   ShowMessage('Ѕаза данных повреждена');
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
       ZCom:=TCompressor.Create;
       PackDB(DBPath,'',DBPassword);
       DBStream:=TFileStream.Create(DBPath,fmOpenRead);
       pDBStream:=TFileStream.Create(selFile.FileName+'.nbk',fmCreate);
       ZCom.CompressStream(DBStream,pDBStream);
      except
       ShowMessage('Ќевозможно создать резервную копию');
      end;
     finally
      DBStream.Free;
      pDBStream.Free;
      ZCom.Free;
     end;
  end;
 selFile.Free;
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

function KillTask(FileName: string): integer; //0 - пpибить не полyчилось
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
const
  PROCESS_TERMINATE = $0001;
begin
  FileName:=ExtractFileName(FileName);
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    if
      ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(FileName))
      or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(FileName))) then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),

        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

begin
 CoInitialize(nil);
 { проверить, активно ли приложение
   если оно активно, выставить флаг
    произвести операцию
    если оно было активно, запустить оп€ть

 }
 CreateBackUp;
 CoUninitialize;
end.
