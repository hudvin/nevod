program NevodBackup;
{$R ..\Resources\WinXP.res}

uses
  SysUtils,Windows,Messages, Classes,ZLib,Dialogs;
 type
  TCompressor = class
  public
    procedure CompressStream(InputStream, OutputStream: TStream);
    procedure DecompressStream(InputStream, OutputStream: TStream);
  end;

function md5(InputString:ShortString): ShortString; external 'Shared.DLL';
function DBPassword:ShortString;external 'Shared.DLL';
function GetAppDataPath: PChar;external 'Shared.DLL';
function GetConnectionString: PChar; external 'Shared.DLL';
function GetTempFile(const Extension: ShortString):PChar;external 'Shared.DLL';
function GetAppHandle():DWORD;external 'Shared.DLL';
function DatabaseCompact(const sdbName: WideString;Password:ShortString): boolean;external 'Shared.DLL';
function GetAppPath:PChar;external 'Shared.DLL';
function IsNormal(DBPath:PChar): Boolean;external 'Shared.DLL';


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
   ShowMessage('Пользовательская база данных не обнаружена !');
   CanExit:=True;
  end;
 if (not CanExit)and (not IsNormal(PChar(DBPath))) then
  begin
   CanExit:=True;
   ShowMessage('Невозможно подключиться к базе данных');
  end;

 if not CanExit then
   try
    DatabaseCompact(DBPath,DBPassword);
   except
    if MessageBox(GetStdHandle(STD_INPUT_HANDLE),'Невозможно сжать базу','Ошибка сжатия',MB_OKCANCEL)=IDCancel
     then Exit;
   end;

 selFile:=TSaveDialog.Create(nil);
 selFile.Options:=[ofOverwritePrompt];
 selFile.Filter:='Резервный копии(*.nbk)|*.nbk';   //'|*.nbk';
 if (not CanExit)and (selFile.Execute)  then
  begin
     try
      try
       DBStream:=TFileStream.Create(DBPath,fmShareDenyNone);
       pDBStream:=TFileStream.Create(selFile.FileName+'.nbk',fmCreate);
       ZCom:=TCompressor.Create;
       ZCom.CompressStream(DBStream,pDBStream);
      except
       on e:Exception do
          ShowMessage(E.Message);
      // ShowMessage('Невозможно создать резервную копию');
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
var
 selFile:TOpenDialog;
 pStream,DBStream:TFileStream;
 ZCom:TCompressor;
 DBPath,tmpFileName:String;
 canExit,res:boolean;
begin
 canExit:=False;
 DBPath:=GetAppDataPath+'\Nevilon Software\Nevod AntiSpam\messages.ndb';
 selFile:=TOpenDialog.Create(nil);
 selFile.Options:=[ofOverwritePrompt];
 selFile.Filter:='Резервный копии(*.nbk)|*.nbk';
 if selFile.Execute then
  begin
     try
       tmpFileName:=GetTempFile('.~tp');
       pStream:=TFileStream.Create(selFile.FileName,fmShareDenyWrite); // сжатый поток
       DBStream:=TFileStream.Create(tmpFileName,fmCreate); //   selFile.FileName+'.nbk'
       ZCom:=TCompressor.Create;
       ZCom.DecompressStream(pStream,DBStream);
       pStream.Free;
       DBStream.Free;
       ZCom.Free;
       if not IsNormal(PChar(tmpFileName)) then
        begin
         ShowMessage('База повреждена');
         CanExit:=True;
         DeleteFile(PChar(tmpFileName));
        end;

       if  FileExists(GetAppDataPath+'\Nevilon Software\Nevod AntiSpam\messages.ndb') then
         if MessageBox(GetStdHandle(STD_INPUT_HANDLE),'Текущая база данных будет удалена','Сообшение',MB_OKCANCEL)=IDCancel
          then  DeleteFile(PChar(DBPath));
       if not FileExists(GetAppDataPath+'\Nevilon Software\Nevod AntiSpam\messages.ndb')and (FileExists(PChar(tmpFileName))) then
        begin
         CopyFile(PChar(tmpFileName),PChar(DBPath),Res);
         DeleteFile(PChar(tmpFileName));
        end;
      except
       on e:Exception do
          ShowMessage(E.Message);
      end;
    end;
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



var
 IsRunning:boolean;
begin
 if ParamCount>0 then
  begin
  //  CoInitialize(nil);
    IsRunning:=False;
    if ParamStr(1)='-rb' then
     begin
      if PostMessage(GetAppHandle,WM_QUIT, 0, 0) then
       begin
       sleep(300);
       IsRunning:=True;
       end;
      RestoreFromBackUp;
      if IsRunning then WinExec(PChar(GetAppPath),SW_SHOWNORMAL);
     end;
    if ParamStr(1)='-sb' then
     begin
      if PostMessage(GetAppHandle,WM_QUIT, 0, 0) then
       begin
       sleep(300);
       IsRunning:=True;
       end;
      CreateBackUp;
      if IsRunning then WinExec(PChar(GetAppPath),SW_SHOWNORMAL);
     end;
   // CoUninitialize;
  end;
end.
