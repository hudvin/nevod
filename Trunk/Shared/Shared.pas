unit Shared;

interface

uses
  Windows,ZLib,TypInfo, Messages, SysUtils, Variants,
  Dialogs, StdCtrls, DB, ADODB,IdMessage, Classes,
  IdText,IdMessageParts, StrUtils,IdAttachment,IdZLibCompressorBase,
  DCPcrypt,Blowfish,Base64,IdHash,IdHashMessageDigest;

const
  WM_WTSSESSION_CHANGE = $2B1;
  WTS_CONSOLE_CONNECT = 1;
  WTS_CONSOLE_DISCONNECT = 2;
  WTS_REMOTE_CONNECT = 3;
  WTS_REMOTE_DISCONNECT = 4;
  WTS_SESSION_LOGON = 5;
  WTS_SESSION_LOGOFF = 6;
  WTS_SESSION_LOCK = 7;
  WTS_SESSION_UNLOCK = 8;
  WTS_SESSION_REMOTE_CONTROL = 9;
  NOTIFY_FOR_THIS_SESSION = 0;
  NOTIFY_FOR_ALL_SESSIONS = 1;

type
  TAccountStatus=(asFree,asClient,asServer);

type
  TLogType=(ltPOP3Server,ltPostReceiver);

type
  TFilterType=(ftBEMail,ftWEmail,ftBExt,ftWExt,ftBURL,ftWURL,ftBWord,ftWWord,ftNone);

type
  TBodyType=(btText,btHtml);  // тип тела сообщения

type
  TSubFilterType=(sfStruct,sfContext);  // подтип фильтра

type
  TWordLocation=(wlAnywhere,wlSubject,wlBody);

type
  TSearchType=(stSubject,stBody,stBoth);

type
  TIntVect = array[0..255] of Integer;
  TBMTable = array[0..0] of TIntVect;
  PBMTable = ^TBMTable;

type
  TDirectResult = record
    FilterType: TFilterType;
    Subject: string;
  end;

type
  AccountParams = record
    AccountName: string;
    Username: string;
    Host: string;
    Password: string;
    Port: Integer;
    Id: Integer;
  end;

type
  TFilterParams = record
    AccountId: Integer;
    FilterType: TFilterType;
    Priority: Integer;
    Subject: string;
  end;

type
  TFilterList = class(TList)
  public
    procedure DestroyItem(Index:Integer); virtual;
  end;

  TStringSeacher = class(TObject)
  private
    sTable: PBMTable;
    function BMSearch(StartPos, lp: Integer; const S: string; BMT: PBMTable):
        Integer;
    function FindRightmost(const S, P: string; n: Integer): Integer;
    procedure MakeBMTable(var BMT: PBMTable; const P: string);
  public
    function Find(SearchString:string;Text:string): Integer;
  end;

  TCompressor = class(TObject)
  public
    procedure CompressStream(InputStream, OutputStream: TStream);
    procedure DecompressStream(InputStream, OutputStream: TStream);
  end;

  TFMessage = class(TIdMessage)
  private
    Compressor: TCompressor;
    FBodyType: TBodyType;
    FCompression: Real;
    FExtensions: TStringList;
    FImageCount: Integer;
    FLinkCount: Integer;
    FMessageText: string;
    Seacher: TStringSeacher;
    function GetFileExtension(FileName:string): string;
  public
    constructor Create;
    destructor Destroy; override;
    function ExtensionExists(Extension:String): Boolean; virtual;
    function FindString(SearchString:string;SearchType:TSearchType): Integer;
    procedure LoadFromZFile(FileName: String);
    procedure LoadFromZStream(ZStream:TStream);
    procedure SaveToZFile(FileName: String);
    procedure SaveToZStream(ZStream:TStream);
    procedure Update;
    property BodyType: TBodyType read FBodyType;
    property Compression: Real read FCompression write FCompression;
    property Extensions: TStringList read FExtensions;
    property ImageCount: Integer read FImageCount;
    property LinkCount: Integer read FLinkCount;
    property MessageText: string read FMessageText;
  end;

  TLogger = class(TObject)
  private
    ACon: TADOConnection;
    Ast: TADOStoredProc;
  public
    constructor Create(ADOCon:TADOConnection);
    destructor Destroy; override;
    procedure Add(LogMessage:string;AccountId:integer;LogType:TLogType);
  end;

  TBFCoder = class(TObject)
  private
    DCP_BF: TDCP_Blowfish;
    FKey: string;
    procedure SetKey(const Value: string);
  public
    constructor Create; virtual;
    destructor Destroy; virtual;
    function Crypt(InputString:string): string;
    function DeCrypt(OutPutString:string): string;
    function Hash(InputString:string): string;
    property Key: string read FKey write SetKey;
  end;

  TSettings = class(TObject)
  private
    ACon: TADOConnection;
    Ast: TADOStoredProc;
  public
    constructor Create(ADOCon:TADOConnection); virtual;
    destructor Destroy; virtual;
    function GetValue(SettingName:string): string;
    function SetValue(SettingName,Value:string): Boolean;
  end;


procedure Register;

function RegisterSessionNotification(Wnd: HWND; dwFlags: DWORD): Boolean;
function UnRegisterSessionNotification(Wnd: HWND): Boolean;
function GetCurrentSessionID: Integer;

implementation

procedure Register;
begin
end;

{
********************************* TFilterList **********************************
}
procedure TFilterList.DestroyItem(Index:Integer);
begin
  TObject(Items[Index]).Free;
end;

{
******************************** TStringSeacher ********************************
}
function TStringSeacher.BMSearch(StartPos, lp: Integer; const S: string; BMT:
    PBMTable): Integer;
var
  Pos, i: Integer;
begin
  Pos := StartPos + lp -1;
  while Pos<= Length(S) do   // исправлено < на <=
   for i := lp downto 1 do
     if BMT^[i - 1][Byte(S[Pos - lp + i])] <> 0 then
       begin
         Pos := Pos + BMT^[i - 1][Byte(S[Pos - lp + i])];
         Break;
       end
        else if i = 1 then
        begin
          Result := Pos - lp + 1;
          Exit;
        end;
      Result := 0;
end;

function TStringSeacher.Find(SearchString:string;Text:string): Integer;
var
  count, PatPos: Integer;
begin
  if (Length(Trim(SearchString))>0) AND  (Length(Trim(Text))>0) then
    begin
      Text:=LowerCase(Text);
      count:=0;
      MakeBMTable(sTable, LowerCase(SearchString));
      PatPos := BMSearch(1, Length(SearchString),Text, sTable);
      while  PatPos <> 0 do
        begin
         PatPos := BMSearch(PatPos + 1, Length(SearchString),Text, sTable);
         inc(Count);
      end;
      FreeMem(sTable);
      Result:=count;
    end
    else
     Result:=-1; // если входные строки не заданы
end;

function TStringSeacher.FindRightmost(const S, P: string; n: Integer): Integer;
var
  i, j, lp: Integer;
begin
  Result := 0;
  lp := Length(P);
  if lp > n then Exit;
  for i := n - lp + 1 downto 1 do
    for j := 1 to lp do
      if P[j] <> S[i + j - 1] then Break
        else if j = lp then
        begin
          Result := i;
          Exit;
        end;
end;

procedure TStringSeacher.MakeBMTable(var BMT: PBMTable; const P: string);
var
  i, j, lp, MaxShift, CurShift, SufPos: Integer;
  Suffix: string;
begin
  lp := Length(P);
  GetMem(BMT, SizeOf(TIntVect) * lp);
  for i := 0 to 255 do
    BMT^[lp - 1][i] := lp;
  for i := lp downto 1 do
    if BMT^[lp - 1][Byte(P[i])] = lp then
      BMT^[lp - 1][Byte(P[i])] := lp - i;
  MaxShift := lp;
  for i := lp - 1 downto 1 do
    begin
     SetLength(Suffix, lp - i);
     Move(P[i + 1], Suffix[1], lp - i);
     if Pos(Suffix, P) = 1 then MaxShift := i;
     for j := 0 to 255 do
       begin
         CurShift := MaxShift;
         SetLength(Suffix, lp - i + 1);
         Suffix[1] := Char(j);
         Move(P[i + 1], Suffix[2], lp - i);
         SufPos := FindRightmost(P, Suffix, lp - 1);
         if SufPos <> 0 then CurShift := i - SufPos;
         BMT^[i - 1][j] := CurShift;
       end;
     BMT^[i - 1][Byte(P[i])] := 0;
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

{
********************************** TFMessage ***********************************
}
constructor TFMessage.Create;
begin
  inherited Create;
  Compressor:=TCompressor.Create;
  FExtensions:=TStringList.Create;
  FExtensions.Sorted := True;
  FExtensions.Duplicates := dupIgnore;
  FCompression:=0;
  Seacher:=TStringSeacher.Create;
end;

destructor TFMessage.Destroy;
begin
  inherited Destroy;
  Compressor.Free;
  FExtensions.Free;
  Seacher.Free;
end;

function TFMessage.ExtensionExists(Extension:String): Boolean;
begin
  if Extensions.IndexOf(Extension)<>-1 then Result:=True
    else Result:=False;
end;

function TFMessage.FindString(SearchString:string;SearchType:TSearchType):
    Integer;
var
  Flag: Boolean;
  Counter: Integer;
begin
  counter:=0;
  Flag:=False;
  case  SearchType of
    stSubject :
        Counter:=Seacher.Find(SearchString,Subject);
    stBody    :
        Counter:=Seacher.Find(SearchString,FMessageText);
    stBoth    :
        Counter:=Seacher.Find(SearchString,FMessageText)+Seacher.Find(SearchString,Subject);
   end;
  Result:=Counter;
end;

function TFMessage.GetFileExtension(FileName:string): string;
var
  Buff: string;
begin
  Buff:=FileName;
  Buff:=ReverseString(Buff);
  Buff:=Copy(Buff,0,Pos('.',Buff)-1);
  Result:=ReverseString(Buff);
end;

procedure TFMessage.LoadFromZFile(FileName: String);
var
  Buffer, UnPacked: TMemoryStream;
begin
  // Compression - отношение размера несжатого потока к
  // размеру сжатого
  Buffer:=TMemoryStream.Create;
  Buffer.LoadFromFile(FileName);
  UnPacked:=TMemoryStream.Create;
  Compressor.DecompressStream(Buffer,UnPacked);
  Compression:=Unpacked.Size/Buffer.Size;
  LoadFromStream(UnPacked);
  Buffer.Free;
  UnPacked.Free;
end;

procedure TFMessage.LoadFromZStream(ZStream:TStream);
var
  Buffer, UnPacked: TMemoryStream;
begin
  Buffer:=TMemoryStream.Create;
  UnPacked:=TMemoryStream.Create;
  Buffer.CopyFrom(ZStream,0);
  Compressor.DecompressStream(Buffer,UnPacked);
  LoadFromStream(UnPacked);
  Compression:=Unpacked.Size/Buffer.Size;
  Buffer.Free;
  UnPacked.Free;
end;

procedure TFMessage.SaveToZFile(FileName: String);
var
  Buffer, PackedStr: TMemoryStream;
begin
  Buffer:=TMemoryStream.Create;
  PackedStr:=TMemoryStream.Create;
  SaveToStream(Buffer);
  Compressor.CompressStream(Buffer,PackedStr);
  PackedStr.SaveToFile(FileName);
  Compression:=Buffer.Size/PackedStr.Size;
  Buffer.Free;
  PackedStr.Free;
end;

procedure TFMessage.SaveToZStream(ZStream:TStream);
var
  Buffer, PackedStr: TMemoryStream;
begin
  Buffer:=TMemoryStream.Create;
  PackedStr:=TMemoryStream.Create;
  SaveToStream(Buffer);
  Compressor.CompressStream(Buffer,PackedStr);
  ZStream.CopyFrom(PackedStr,0);
  Buffer.Free;
  PackedStr.Free;
  Compression:=Buffer.Size/PackedStr.Size;
end;

procedure TFMessage.Update;
var
  i: Integer;
  Res: string;
begin
  // текст сообщения
  for i:=0 to MessageParts.Count-1 do
    if MessageParts.Items[i] is TIdText then Res:=Res+(MessageParts[i] as TIdText).Body.Text;
  FMessageText:=Res;
  // массив расширений приложенных файлов - дубликаты удалять
  FExtensions.Clear;
  for i:=0 to MessageParts.Count-1 do
        if MessageParts.Items[i] is TIdAttachment then
           FExtensions.Add(GetFileExtension(TIdAttachment(MessageParts.Items[i]).FileName));
  // тип сообщения
  if Seacher.Find('<html',FMessageText)>0 then FBodyType:=btHtml
     else FBodyType:=btText;
  // количество изображений
  if FBodyType=btHtml then FImageCount:=Seacher.Find('src',FMessageText)
     else FImageCount:=0;
  FLinkCount:=0;
  // количество ссылок
  if FBodyType=btHtml then FLinkCount:=Seacher.Find(' href',MessageText);
  if FBodyType=btText then FLinkCount:=(Seacher.Find(' www.',MessageText)+Seacher.Find('http://',MessageText));

end;

{
*********************************** TLogger ************************************
}
constructor TLogger.Create(ADOCon:TADOConnection);
begin
  ACon:=ADOCon;
  Ast:=TADOStoredProc.Create(nil);
  Ast.Connection:=ACon;
  Ast.ProcedureName:='AddLogRecord';
end;

destructor TLogger.Destroy;
begin
  Ast.Close;
  Ast.Free;
end;

procedure TLogger.Add(LogMessage:string;AccountId:integer;LogType:TLogType);
begin
  try
   with Ast do
    begin
      with Parameters do
        begin
          Clear;
          AddParameter.Name:='Message';
          ParamByName('Message').Value:=LogMessage;
          AddParameter.Name:='ErrorTime';
          ParamByName('ErrorTime').Value:=Now;;
          AddParameter.Name:='mid';
          ParamByName('mid').Value:=AccountId;
          AddParameter.Name:='ErrorType';
          ParamByName('ErrorType').Value:=GetEnumName(TypeInfo(TLogType), Ord(LogType));
        end;
      ExecProc;
    end;
   except
    on E:Exception do ShowMessage('Cannot add log record !!!' + E.Message);
   end;
end;

{
*********************************** TBFCoder ***********************************
}
constructor TBFCoder.Create;
begin
  DCP_BF:=TDCP_Blowfish.Create(nil);
end;

destructor TBFCoder.Destroy;
begin
  DCP_BF.Free;
end;

function TBFCoder.Crypt(InputString:string): string;
var
  Cipher: TDCP_blockcipher;
begin
  with Cipher do
    begin
      Cipher:= TDCP_blockcipher(DCP_BF);
      InitStr(Key);
      EncryptCFB(InputString[1],InputString[1],Length(InputString));
      Reset;
      Burn;
    end;
  Result:= B64Encode(InputString); // перемещено !!!
end;

function TBFCoder.DeCrypt(OutPutString:string): string;
var
  Cipher: TDCP_blockcipher;
begin
  with Cipher do
    begin
      Cipher:= TDCP_blockcipher(DCP_BF);
      InitStr(key);
      OutputString:= B64Decode(OutputString);
      DecryptCFB(OutputString[1],OutputString[1],Length(OutputString));
      Reset;
      Burn;
    end;
  Result:=OutputString;
end;

function TBFCoder.Hash(InputString:string): string;
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

procedure TBFCoder.SetKey(const Value: string);
begin
  if FKey <> Value then
  begin
    FKey := Value;
  end;
end;

{
********************************** TSettings ***********************************
}
constructor TSettings.Create(ADOCon:TADOConnection);
begin
  ACon:=ADOCon;
  Ast:=TADOStoredProc.Create(nil);
  Ast.Connection:=ACon;
end;

destructor TSettings.Destroy;
begin
  Ast.Free;
end;

function TSettings.GetValue(SettingName:string): string;
begin
  with Ast do
    begin
     Close;
     ProcedureName:='GetSettingValue';
     Parameters.Clear;
     Parameters.AddParameter.Name:='SettingName';
     Parameters.ParamByName('SettingName').Value:=SettingName;
     ExecProc;
     Open;
     if RecordCount>0 then Result:=Fields[0].AsString else Result:='Error';
     Close;
    end;
end;

function TSettings.SetValue(SettingName,Value:string): Boolean;
begin
  try
   with ast do
    begin
     Close;
     ProcedureName:='SetSettingValue';
     Parameters.Clear;
     Parameters.AddParameter.Name:='Value';
     Parameters.ParamByName('Value').Value:=Value;
     Parameters.AddParameter.Name:='SettingName';
     Parameters.ParamByName('SettingName').Value:=SettingName;
     ExecProc;
    end;
    Result:=True;
  except
   Result:=False;
  end;
end;

function RegisterSessionNotification(Wnd: HWND; dwFlags: DWORD): Boolean;
type
  TWTSRegisterSessionNotification = function(Wnd: HWND; dwFlags: DWORD): BOOL; stdcall;
var
  hWTSapi32dll: THandle;
  WTSRegisterSessionNotification: TWTSRegisterSessionNotification;
begin
  Result := False;
  hWTSAPI32DLL := LoadLibrary('Wtsapi32.dll');
  if (hWTSAPI32DLL > 0) then
  begin
    try @WTSRegisterSessionNotification :=
        GetProcAddress(hWTSAPI32DLL, 'WTSRegisterSessionNotification');
      if Assigned(WTSRegisterSessionNotification) then
      begin
        Result:= WTSRegisterSessionNotification(Wnd, dwFlags);
      end;
    finally
      if hWTSAPI32DLL > 0 then
        FreeLibrary(hWTSAPI32DLL);
    end;
  end;
end;

function UnRegisterSessionNotification(Wnd: HWND): Boolean;
type
  TWTSUnRegisterSessionNotification = function(Wnd: HWND): BOOL; stdcall;
var
  hWTSapi32dll: THandle;
  WTSUnRegisterSessionNotification: TWTSUnRegisterSessionNotification;
begin
  Result := False;
  hWTSAPI32DLL := LoadLibrary('Wtsapi32.dll');
  if (hWTSAPI32DLL > 0) then
  begin
    try @WTSUnRegisterSessionNotification :=
        GetProcAddress(hWTSAPI32DLL, 'WTSUnRegisterSessionNotification');
      if Assigned(WTSUnRegisterSessionNotification) then
      begin
        Result:= WTSUnRegisterSessionNotification(Wnd);
      end;
    finally
      if hWTSAPI32DLL > 0 then
        FreeLibrary(hWTSAPI32DLL);
    end;
  end;
end;

function GetCurrentSessionID: Integer;
type
  TProcessIdToSessionId = function(dwProcessId: DWORD; pSessionId: DWORD): BOOL; stdcall;
var
  ProcessIdToSessionId: TProcessIdToSessionId;
  hWTSapi32dll: THandle;
  Lib : THandle;
  pSessionId : DWord;
begin
  Result := 0;
  Lib := GetModuleHandle('kernel32');
  if Lib <> 0 then
  begin
    ProcessIdToSessionId := GetProcAddress(Lib, '1ProcessIdToSessionId');
    if Assigned(ProcessIdToSessionId) then
    begin
      ProcessIdToSessionId(GetCurrentProcessId(), DWORD(@pSessionId));
      Result:= pSessionId;
    end;
  end;
end;


end.
