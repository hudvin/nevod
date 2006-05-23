program NevodBackup;


uses
  SysUtils,
  Windows,
  Messages,
  Classes,
  ZLib,
  Dialogs,
  gnugettext in '..\..\..\Program Files\dxgettext\gnugettext.pas';
{$R ..\Resources\WinXP.res}
type
  TCompressor = class
  public
    procedure CompressStream(InputStream, OutputStream: TStream);
    procedure DecompressStream(InputStream, OutputStream: TStream);
  end;

function md5(InputString:PChar):PChar; external 'Shared.DLL';
function DBPassword:PChar;external 'Shared.DLL';
function GetAppDataPath: PChar;external 'Shared.DLL';
function GetConnectionString: PChar; external 'Shared.DLL';
function GetTempFile(const Extension: PChar):PChar;external 'Shared.DLL';
function GetAppHandle():DWORD;external 'Shared.DLL';
function DatabaseCompact: boolean;external 'Shared.DLL';
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
   ShowMessage(_('���������������� ���� ������ �� ���������� !'));
   CanExit:=True;
  end;
 if (not CanExit)and (not IsNormal(PChar(DBPath))) then
  begin
   CanExit:=True;
   ShowMessage(_('���������� ������������ � ���� ������'));
  end;

 if not CanExit then
   try
    DatabaseCompact;
   except
    if MessageBoxW(GetStdHandle(STD_INPUT_HANDLE),PWideChar(_('���������� ����� ����')),PWideChar(_('������ ������')),MB_OKCANCEL)=IDCancel
     then Exit;
   end;

 selFile:=TSaveDialog.Create(nil);
 selFile.Options:=[ofOverwritePrompt];
 selFile.Filter:=_('��������� �����(*.nbk)|*.nbk');   //'|*.nbk';
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
      // ShowMessage('���������� ������� ��������� �����');
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
 selFile.Filter:=_('��������� �����(*.nbk)|*.nbk');
 if selFile.Execute then
  begin
     try
       tmpFileName:=GetTempFile('.~tp');
       pStream:=TFileStream.Create(selFile.FileName,fmShareDenyWrite); // ������ �����
       DBStream:=TFileStream.Create(tmpFileName,fmCreate); //   selFile.FileName+'.nbk'
       ZCom:=TCompressor.Create;
       ZCom.DecompressStream(pStream,DBStream);
       pStream.Free;
       DBStream.Free;
       ZCom.Free;
       if not IsNormal(PChar(tmpFileName)) then
        begin
         ShowMessage(_('���� ����������'));
         CanExit:=True;
         DeleteFile(PChar(tmpFileName));
        end;

       if  FileExists(GetAppDataPath+'\Nevilon Software\Nevod AntiSpam\messages.ndb') then
         if MessageBoxW(GetStdHandle(STD_INPUT_HANDLE),PWideChar(_('������� ���� ������ ����� �������')),PWideChar(_('���������')),MB_OKCANCEL)=IDCancel
          then  DeleteFile(PChar(DBPath));
       if not FileExists(GetAppDataPath+'\Nevilon Software\Nevod AntiSpam\messages.ndb')and (FileExists(PChar(tmpFileName))) then
        begin
         CopyFile(PChar(tmpFileName),PChar(DBPath),Res);
         DeleteFile(PChar(tmpFileName));
        end;
      except
      // on e:Exception do
       //   ShowMessage(E.Message);
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



var
 IsRunning:boolean;
begin
 IsRunning:=False;
 if ParamCount>0 then
  begin
   if ParamStr(1)='-rb' then
     begin
      if PostMessage(GetAppHandle,WM_QUIT, 0, 0) then
       begin
        IsRunning:=True;
       end;
      RestoreFromBackUp;
      if IsRunning then WinExec(PChar(GetAppPath),SW_SHOWNORMAL);
     end;

   if ParamStr(1)='-sb' then
    begin
      if PostMessage(GetAppHandle,WM_QUIT, 0, 0) then
       begin
        IsRunning:=True;
       end;
       CreateBackUp;
      if IsRunning then WinExec(PChar(GetAppPath),SW_SHOWNORMAL);
    end;
  end;
end.
