unit Shared;

interface

uses  PerlRegEx, MMSystem,
  cxEdit,
  cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  

  cxGridCustomView, cxGrid, Menus,  CoolTrayIcon,
  cxGridCustomPopupMenu, cxGridPopupMenu,  Controls,
  cxGridDBTableView, cxClasses, cxControls, cxPC, cxSplitter,
  cxInplaceContainer, dxStatusBar, cxLookAndFeels,



  Windows,WinSock, Registry,  ZLib,TypInfo, Messages, SysUtils, Variants,  ComObj,ActiveX,
  Dialogs, StdCtrls, DB, ADODB,IdMessage, Classes, IniFiles,
  IdText,IdMessageParts, StrUtils,IdAttachment,IdZLibCompressorBase,
  DCPcrypt,Blowfish,Base64,IdHash,IdHashMessageDigest;

const
  SIO_GET_INTERFACE_LIST = $4004747F;
  IFF_UP = $00000001;
  IFF_BROADCAST = $00000002;
  IFF_LOOPBACK = $00000004;
  IFF_POINTTOPOINT = $00000008;
  IFF_MULTICAST = $00000010;
  HEAP_ZERO_MEMORY = $00000008;
  SID_REVISION     = 1; 

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
  CriptKey=' &(5428396%:?(__*:?:(_(%fGfhhKJHFGHD12_= ';
  MutexName='{94FA4497-A317-4C45-9B57-A0558F8221D7}';
  ServerMutex='{B66AEAD2-94BF-453B-9D79-27CC798B6657}';
  WaitTime=5000;      // время между проверками состояний
  WM_BallonMessage = WM_USER + 1;
  WM_ShowCEditor=WM_USER+2;

type
 TClbHookMode=(chEmail,chURL,chEmailURL);

type
 TNodeGroup=(ndGeneral,ndAccounts,ndStamps);  

type
  TAccountStatus=(asFree,asClient,asServer);

type
  TLogType=(ltPOP3Server,ltPostReceiver);


type
  TFilterType=(ftBlackSender,ftWhiteSender,ftStamp,ftBlackWord,ftWhiteWord,ftImageFilter,ftLinkFilter,
               ftBlackAttach,ftWhiteAttach,ftMessSize,ftSpamWord,ftNone);

type
  TBodyType=(btText,btHtml);  // тип тела сообщения


type
  TSignalLocation=(slAnywhere,slSubject,slBody);

type
  TSearchType=(stSubject,stBody,stBoth);

type
 TEditorMode=(emEdit,emAdd);  

type
  TIntVect = array[0..255] of Integer;
  TBMTable = array[0..0] of TIntVect;
  PBMTable = ^TBMTable;

type
   PTokenUser = ^TTokenUser;
   TTokenUser = packed record
     User: TSidAndAttributes;
   end;  


type
 SockAddr_Gen = packed record
  AddressIn: sockaddr_in;
  Filter: packed array [0..7] of char;
end;

type
 INTERFACE_INFO = packed record
  iiFlags: u_long; // Флаги интерфейса
  iiAddress: sockaddr_gen; // Адрес интерфейса
  iiBroadcastAddress: sockaddr_gen; // Broadcast адрес
  iiNetmask: sockaddr_gen; // Маска подсети
end;



type
  TFilterResult = record
    FilterType: TFilterType;
    Reason: string;
  end;

type
  TAccountParams = packed record
    AccountName: string;
    Username: string;
    Host: string;
    Password: string;
    Port: Integer;
    Id: Integer;
    Status:TAccountStatus;
    Timeout: Integer;
  end;

type
  TFilterParams = record
    AccountId: Integer;
    FilterType: TFilterType;
    Priority: Integer;
    Subject: string;
  end;

type
 PSignalTypeDescriptor=^TSignalTypeDescriptor;
 TSignalTypeDescriptor = packed record
    Description: string;
    Location: TSignalLocation;
  end;

type
 PNodeParams=^TNodeParams;
 TNodeParams=record
  NodeIndex:integer;
  FilterType:TFilterType;
  Sheet:TcxTabSheet;
  adTab:TADOQuery;
  Grid:TcxGridDBTableView;
end;

  TColumnsHeaders = record
    Active: string;
    Description: string;
    FValue: string;
    Params: string;
  end;

  TSNConvert = record
 
    Caption: string;
    FilterType: TFilterType;
    Headers: TColumnsHeaders;
    Name: String;
    NodeIndex: Integer;
    SelectionIndex: Integer;
    Sheet: TCxTabSheet;
  end;

type
  PAccountParams = ^TAccountParams;
type
  PSNConvert=^TSNConvert;
type
  TCompressor = class(TObject)
  public
    procedure CompressStream(InputStream, OutputStream: TStream);
    procedure DecompressStream(InputStream, OutputStream: TStream);
  end;

  TFMessage = class(TIdMessage)
  private
    Compressor: TCompressor;
    FCompression: Real;
    function GetBodyType: TBodyType;
    function GetMessageText: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromZFile(FileName: String);
    procedure LoadFromZStream(ZStream:TStream);
    procedure SaveToZFile(FileName: String);
    procedure SaveToZStream(ZStream:TStream);
    property BodyType: TBodyType read GetBodyType;
    property Compression: Real read FCompression write FCompression;
    property MessageText: string read GetMessageText;
  end;

  TLogger = class(TObject)
  private
    adProc: TADOQuery;
  public
    constructor Create(ADOCon:TADOConnection);
    destructor Destroy; override;
    procedure Add(LogMessage:string;AccountId:integer;LogType:TLogType);
  end;

  TBFCoder = class(TObject)
  private
    DCP_BF: TDCP_Blowfish;
    FKey: string;
  protected
    function Hash(InputString:string): string;
    procedure SetKey(const Value: string);
  public
    constructor Create; virtual;
    destructor Destroy;override;
    function Crypt(InputString:string): string;
    function DeCrypt(OutPutString:string): string;
    property Key: string read FKey write SetKey;
  end;

  TSettings = class(TObject)
  private
    adProc: TADOQuery;
  public
    constructor Create(adCon:TADOConnection); virtual;
    destructor Destroy; virtual;
    function GetValue(SettingName:string): string;
    function SetValue(SettingName,Value:string): Boolean;
  end;

  TRegExp = class(TPerlRegEx)
  { при присвоении текста для обработки -экранирование спецсимволов }
  private
  public
    function BuildExp(const Value: string): string;
  end;

  TSignalDescriptorsList = class
  private
    List: TList;
    function GetCount: Integer;
    function GetItems(Index: Integer): TSignalTypeDescriptor;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Location:TSignalLocation;Description:String);
    function DescriptionByLocation(Location:TSignalLocation): string;
    function LocationByDescription(Description:String): TSignalLocation;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSignalTypeDescriptor read GetItems;
  end;

  TSNIndexConverter = class
  private
    List: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSNConvert;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(NodeIndex:Integer;FilterType:TFilterType; FilterName:String;
        Sheet:TcxTabSheet;Headers:TColumnsHeaders); overload;
    procedure Add(NodeIndex:Integer;FilterType:TFilterType; FilterName:String;
        Sheet:TcxTabSheet); overload;
    function Find(NodeIndex:Integer; var Res:TSNConvert): Boolean; overload;
    function FindByName(FilterName:string;var Res:TSNConvert): Boolean;
    function FindIndex(FilterType:TFilterType): Integer;
    function NIndex2SIndex(NodeIndex:Integer): Integer;
    function SIndex2NIndex(SelectionIndex:Integer): Integer;
    property Count: Integer read GetCount;
    property Item[Index: Integer]: TSNConvert read GetItem;
  end;

  TWMMessanger = class
  private
  public
    BallonType: TBalloonHintIcon;
    Caption: string;
    LogMessage: string;
    MessagesCount: Integer;
  end;

  TSounder = class(TThread)
  private
    FFilePath: string;
  public
    constructor Create(FilePath:String);
    procedure Execute; override;
  end;

  TMailClientRunner = class(TThread)
  private
    procedure OpenMailClient;
  public
    constructor Create;
    procedure Execute; override;
  end;

function md5(InputString:ShortString): ShortString; external 'Shared.DLL';
function GetAppDataPath: PChar;external 'Shared.DLL';
function DBPassword:ShortString;external 'Shared.DLL';
procedure PackDB(DatabaseName:PChar; DestDatabaseName:PChar; Password:ShortString);external 'Shared.DLL';
procedure WriteAppHandle(Handle:DWORD);external 'Shared.DLL';
function DatabaseCompact(const sdbName: WideString;Password:ShortString): boolean;external 'Shared.DLL';

function BindPort(Port:integer): Boolean;
function IsConnected():Boolean;
function WSAIoctl(s: TSocket; cmd: DWORD; lpInBuffer: PCHAR; dwInBufferLen:
  DWORD;
  lpOutBuffer: PCHAR; dwOutBufferLen: DWORD;
  lpdwOutBytesReturned: LPDWORD;
  lpOverLapped: POINTER;
  lpOverLappedRoutine: POINTER): Integer; stdcall; external 'WS2_32.DLL';

function GetCurrentSessionID: Integer;
function GetLocalIP: String;

function ConvertSid(Sid: PSID; pszSidText: PChar; var dwBufferLen: DWORD): BOOL;
function GetCurrentUserSid: string;
function ObtainTextSid(hToken: THandle; pszSid: PChar;
   var dwBufferLen: DWORD): BOOL;

procedure PlaySound(FilePath:String);

//function md5(InputString:string): string;


procedure WriteAppPath(AppPath:String);

function GetConnectionString: string;

procedure RestoreDB;




function GetFileSize(FileName: String): Integer;

implementation


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
  FCompression:=0;
end;

destructor TFMessage.Destroy;
begin
  inherited Destroy;
  Compressor.Free;
end;

function TFMessage.GetBodyType: TBodyType;
var
 Flag:Boolean;
 i:integer;
 buf:String;
begin
 Flag:=True;
 i:=0;
 if (not IsEncoded) then
  buf:=ContentType;
 if pos('multipart',ContentType)<>0 then
  while (Flag) and (i<MessageParts.Count) do
   if  MessageParts.Items[i] is TIdText then
    begin
     buf:=(MessageParts[i] as TIdText).ContentType;
     Flag:=False;
    end
   else inc(i);

  if (pos('html',buf)<>0) or (pos('xml',buf)<>0) then Result:=btHtml
   else Result:=btText;
end;

function TFMessage.GetMessageText: string;
var
 i:integer;
begin
 if pos('multipart',ContentType)<>0 then
   for i:=0 to MessageParts.Count-1 do
    if MessageParts.Items[i] is TIdText then Result:=Result+(MessageParts[i] as TIdText).Body.Text;
 //if IsEncoded then
 // for i:=0 to MessageParts.Count-1 do
 //  if MessageParts.Items[i] is TIdText then Result:=Result+(MessageParts[i] as TIdText).Body.Text;
// if (Not IsEncoded) then Result:=Body.Text;
  if pos('multipart',ContentType)=0 then Result:=Body.Text;
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
  Compression:=Buffer.Size/PackedStr.Size;
  Buffer.Free;
  PackedStr.Free;
end;

{
*********************************** TLogger ************************************
}
constructor TLogger.Create(ADOCon:TADOConnection);
begin
  adProc:=TADOQuery.Create(nil);
  adProc.Connection:=ADOCon;
  adProc.SQL.Text:='INSERT INTO log ( Message, ErrorTime, mid, ErrorType ) '+
                   'VALUES (:Message,:ErrorTime,:mid,:ErrorType)';
end;

destructor TLogger.Destroy;
begin
  adProc.Close;
  adProc.Free;
end;

procedure TLogger.Add(LogMessage:string;AccountId:integer;LogType:TLogType);
begin
  try
   with adProc do
    begin
      Active:=False;
      CoInitialize(nil);
      with Parameters do
        begin
          ParamByName('Message').Value:=LogMessage;
          ParamByName('ErrorTime').Value:=Now;;
          ParamByName('mid').Value:=AccountId;
          ParamByName('ErrorType').Value:=GetEnumName(TypeInfo(TLogType), Ord(LogType));
        end;
      ExecSQL;
      CoUninitialize;
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
constructor TSettings.Create(adCon:TADOConnection);
begin
  adProc:=TADOQuery.Create(nil);
  adProc.Connection:=adCon;
end;

destructor TSettings.Destroy;
begin
  adProc.Free;
end;

function TSettings.GetValue(SettingName:string): string;
begin
  with adProc do
    begin
     Close;
     SQL.Text:='SELECT Var FROM Settings WHERE Name=:SettingName';
     Parameters.ParamByName('SettingName').Value:=SettingName;
     ExecSQL;
     Open;
     if RecordCount>0 then Result:=Fields[0].AsString else Result:='Error';
     Close;
    end;
end;

function GetFileSize(FileName: String): Integer;
var
  FS: TFileStream;
begin
  try
    FS := TFileStream.Create(Filename, fmShareDenyNone);
  except
    Result := -1;
  end;
  if Result <> -1 then Result := FS.Size;
  FS.Free;
end;

function TSettings.SetValue(SettingName,Value:string): Boolean;
begin
  try
   with adProc do
    begin
     Close;
     SQL.Text:='UPDATE Settings SET Var=:Value WHERE Name=:SettingName ';
     Parameters.ParamByName('Value').Value:=Value;
     Parameters.ParamByName('SettingName').Value:=SettingName;
     ExecSQL;
    end;
    Result:=True;
  except
   Result:=False;
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


function IsConnected():boolean;
var
  s: TSocket;
  wsaD: WSADATA;
  NumInterfaces: Integer;
  BytesReturned, SetFlags: u_long;
  PtrA: pointer;
  Buffer: array[0..20] of INTERFACE_INFO;
  i: Integer;
begin
 WSAStartup($0101, wsaD);
 S := Socket(AF_INET, SOCK_STREAM, 0); // Открываем сокет
 if (s = INVALID_SOCKET) then
  exit;
 try // Вызываем WSAIoCtl
  PtrA := @bytesReturned;
  if (WSAIoCtl(s, SIO_GET_INTERFACE_LIST, nil, 0, @Buffer,1024, PtrA, nil, nil) <> SOCKET_ERROR) then
    begin
     NumInterfaces := BytesReturned div SizeOf(INTERFACE_INFO);
     i:=0;
     Result:=false;
     while (i<NumInterfaces) and (not Result) do
      begin
       SetFlags := Buffer[i].iiFlags;
       if  ((SetFlags and IFF_UP) = IFF_UP) then
        if (SetFlags and IFF_LOOPBACK) <>IFF_LOOPBACK then
        Result:=True
       else inc(i);
      end;

 end;
 except
  CloseSocket(s);
  WSACleanUp;
 end;
end;

function BindPort(Port:integer): Boolean;
var
 FAddr: TSockAddrIn;
 FSocket:TSocket;
 wsaD: WSADATA;
begin
 Result:=True;
 FSocket := socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
 FAddr.sin_family := AF_INET;
 FAddr.sin_addr.s_addr := INADDR_ANY;
 FAddr.sin_port := htons(Port);
 if WSAStartup($101, WsaD) = 0 then
  begin
   if bind(FSocket, FAddr, SizeOf(FAddr))=SOCKET_ERROR then
    Result:=False;
   WSACleanUp;
   closesocket(FSocket);
  end;
end;

function GetLocalIP: String;
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
  end;
end;

 function ConvertSid(Sid: PSID; pszSidText: PChar; var dwBufferLen: DWORD): BOOL;
 var
   psia: PSIDIdentifierAuthority;
   dwSubAuthorities: DWORD;
   dwSidRev: DWORD;
   dwCounter: DWORD;
   dwSidSize: DWORD;
 begin
   Result := False;

   dwSidRev := SID_REVISION;

   if not IsValidSid(Sid) then Exit;

   psia := GetSidIdentifierAuthority(Sid);

   dwSubAuthorities := GetSidSubAuthorityCount(Sid)^;

   dwSidSize := (15 + 12 + (12 * dwSubAuthorities) + 1) * SizeOf(Char);

   if (dwBufferLen < dwSidSize) then
   begin
     dwBufferLen := dwSidSize;
     SetLastError(ERROR_INSUFFICIENT_BUFFER);
     Exit;
   end;

   StrFmt(pszSidText, 'S-%u-', [dwSidRev]);

   if (psia.Value[0] <> 0) or (psia.Value[1] <> 0) then
     StrFmt(pszSidText + StrLen(pszSidText),
       '0x%.2x%.2x%.2x%.2x%.2x%.2x',
       [psia.Value[0], psia.Value[1], psia.Value[2],
       psia.Value[3], psia.Value[4], psia.Value[5]])
   else
     StrFmt(pszSidText + StrLen(pszSidText),
       '%u',
       [DWORD(psia.Value[5]) +
       DWORD(psia.Value[4] shl 8) +
       DWORD(psia.Value[3] shl 16) +
       DWORD(psia.Value[2] shl 24)]);

   dwSidSize := StrLen(pszSidText);

   for dwCounter := 0 to dwSubAuthorities - 1 do
   begin
     StrFmt(pszSidText + dwSidSize, '-%u',
       [GetSidSubAuthority(Sid, dwCounter)^]);
     dwSidSize := StrLen(pszSidText);
   end;

   Result := True;
 end;

 function ObtainTextSid(hToken: THandle; pszSid: PChar;
   var dwBufferLen: DWORD): BOOL;
 var
   dwReturnLength: cardinal;
   dwTokenUserLength:Cardinal;
   tic: TTokenInformationClass;
   ptu: Pointer;
 begin
   Result := False;
   dwReturnLength := 0;
   dwTokenUserLength := 0;
   tic := TokenUser;
   ptu := nil;

   if not GetTokenInformation(hToken, tic, ptu, dwTokenUserLength,dwReturnLength) then
   begin
     if GetLastError = ERROR_INSUFFICIENT_BUFFER then
     begin
       ptu := HeapAlloc(GetProcessHeap, HEAP_ZERO_MEMORY, dwReturnLength);
       if ptu = nil then Exit;
       dwTokenUserLength := dwReturnLength;
       dwReturnLength    := 0;

       if not GetTokenInformation(hToken, tic, ptu, dwTokenUserLength,
         dwReturnLength) then Exit;
     end
      else
        Exit;
   end;

   if not ConvertSid((PTokenUser(ptu).User).Sid, pszSid, dwBufferLen) then Exit;

   if not HeapFree(GetProcessHeap, 0, ptu) then Exit;

   Result := True;
 end;

 function GetCurrentUserSid: string;
 var
   hAccessToken: THandle;
   bSuccess: BOOL;
   dwBufferLen: DWORD;
   szSid: array[0..260] of Char;
 begin
   Result := '';

   bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
     hAccessToken);
   if not bSuccess then
   begin
     if GetLastError = ERROR_NO_TOKEN then
       bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY,
         hAccessToken);
   end;
   if bSuccess then
   begin
     ZeroMemory(@szSid, SizeOf(szSid));
     dwBufferLen := SizeOf(szSid);

     if ObtainTextSid(hAccessToken, szSid, dwBufferLen) then
       Result := szSid;
     CloseHandle(hAccessToken);
   end;
 end;

procedure PlaySound(FilePath:String);
begin
  MMSystem.PlaySound(PChar(FilePath),0,SND_FILENAME);
end;

{ function md5(InputString:string): string;
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
end; }



procedure WriteAppPath(AppPath:String);
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

function GetConnectionString: string;
var
 DBPath:String;
begin
 DBPath:=GetAppDataPath+'\Nevilon Software\Nevod AntiSpam';
 Result:='Provider=Microsoft.Jet.OLEDB.4.0;'+'Data Source='+DBPath+'\messages.ndb;'+
            'Jet OLEDB:Database Password='+DBPassword;
end;

procedure RestoreDB;
var
 DBPath:String;
 rs: TResourceStream;
begin
 DBPath:=GetAppDataPath+'\Nevilon Software\Nevod AntiSpam';
 ForceDirectories(DBPath);
 rs := TResourceStream.Create(hinstance, 'MessDB', RT_RCDATA);
 try
  rs.SaveToFile(DBPath+'\messages.ndb');
 finally
  rs.Free;
 end;
end;




function TRegExp.BuildExp(const Value: string): string;
var inpString,buff,symbols:String;
    i:Integer;
begin
 inpString:=Value;
 Symbols:='.[]\$^()';
 buff:='';
 for I := 1 to Length(inpString) do  // экранирование спецсимволов
  begin
    if pos(inpString[i],symbols)<>0
     then buff:=buff+'\'+inpString[i]
      else buff:=buff+InpString[i];
  end;

  inpString:='';
  for I := 1 to Length(buff) do   // замена * и ? на поисковые кмбинации
  begin
    if  buff[i]='*'
     then inpString:=InpString+'.*' else
      if  buff[i]='?'
        then inpString:=InpString+'.'
         else InpString:=InpString + buff[i];
  end;
 if (InpString[1]<>'.') AND (InpString[1]<>'.') then   // проверка в начале
  inpString:='\b'+InpString;

 if (InpString[Length(InpString)]<>'.') AND (InpString[Length(InpString)]<>'*') then   // проверка в конце
  inpString:=InpString+'\b';

  Result:=InpString;
end;

constructor TSignalDescriptorsList.Create;
begin
 List:=TList.Create;
end;

destructor TSignalDescriptorsList.Destroy;
var
 i:integer;
 DelRecord:PSignalTypeDescriptor;
begin
 for I := 0 to List.Count - 1 do
   begin
     DelRecord:=List.Items[i];
     Dispose(DelRecord);
   end;
end;

procedure TSignalDescriptorsList.Add(Location:TSignalLocation;
    Description:String);
var
 NewItem:PSignalTypeDescriptor;
begin
 New(NewItem);
 NewItem.Description:=Description;
 NewItem.Location:=Location;
 List.Add(NewItem);
end;

function TSignalDescriptorsList.DescriptionByLocation(
    Location:TSignalLocation): string;
var
 Flag:boolean;
 i:integer;
begin
 Flag:=False;
 i:=0;
 while (not Flag) and (i<List.Count) do
    if PSignalTypeDescriptor(List.Items[i]).Location=Location then
     begin
      Flag:=True;
      Result:=PSignalTypeDescriptor(List.Items[i]).Description;
     end
    else inc(i);
end;

function TSignalDescriptorsList.GetCount: Integer;
begin
 Result:=List.Count;
end;

function TSignalDescriptorsList.GetItems(Index: Integer): TSignalTypeDescriptor;
begin
 Result.Description:=PSignalTypeDescriptor(List.Items[Index]).Description;
 Result.Location:=PSignalTypeDescriptor(List.Items[Index]).Location;
end;

function TSignalDescriptorsList.LocationByDescription(Description:String):
    TSignalLocation;
var
 Flag:boolean;
 i:integer;
begin
 Flag:=False;
 i:=0;
 while (not Flag) and (i<List.Count) do
    if PSignalTypeDescriptor(List.Items[i]).Description=Description then
     begin
      Flag:=True;
      Result:=PSignalTypeDescriptor(List.Items[i]).Location;
     end
    else inc(i);
end;

constructor TSNIndexConverter.Create;
begin
 List:=TList.Create;
end;

destructor TSNIndexConverter.Destroy;
var
 i:integer;
 DelRecord:PSNConvert;
begin
 for I := 0 to List.Count - 1 do
   begin
     DelRecord:=List.Items[i];
     Dispose(DelRecord);
   end;
end;

procedure TSNIndexConverter.Add(NodeIndex:Integer;FilterType:TFilterType;
    FilterName:String;Sheet:TcxTabSheet;Headers:TColumnsHeaders);
var
 NewItem:PSNConvert;
begin
 New(NewItem);
 NewItem.NodeIndex:=NodeIndex;
 NewItem.FilterType:=FilterType;
 NewItem.Name:=FilterName;
 NewItem.Sheet:=Sheet;
 NewItem.Headers:=Headers;
 List.Add(NewItem);
end;

procedure TSNIndexConverter.Add(NodeIndex:Integer;FilterType:TFilterType;
    FilterName:String;Sheet:TcxTabSheet);
var
 ClearHeaders:TColumnsHeaders;
begin
  Add(NodeIndex,FilterType,FilterName,Sheet,ClearHeaders);
end;

function TSNIndexConverter.Find(NodeIndex:Integer; var Res:TSNConvert): Boolean;
var
 i:integer;
 Flag:boolean;
begin
 Flag:=False;
 i:=0;
 while (not Flag) and (i<List.Count) do
  if PSNConvert(List.Items[i]).NodeIndex = NodeIndex then
   begin
    Flag:=True;
    Res:=PSNConvert(List.Items[i])^;
   end
  else inc(i);
 Result:=Flag;
end;

function TSNIndexConverter.FindByName(FilterName:string;var Res:TSNConvert):
    Boolean;
var
 i:integer;
 Flag:boolean;
begin
 Flag:=False;
 i:=0;
 while (not Flag) and (i<List.Count) do
  if PSNConvert(List.Items[i]).Name = FilterName then
   begin
    Flag:=True;
    Res:=PSNConvert(List.Items[i])^;
   end
  else inc(i);
 Result:=Flag;
end;

function TSNIndexConverter.FindIndex(FilterType:TFilterType): Integer;
var
 i:integer;
 Flag:boolean;
begin
 Flag:=False;
 i:=0;
 Result:=-1;
 while (not Flag) and (i<List.Count) do
  if PSNConvert(List.Items[i]).FilterType = FilterType then
   begin
    Flag:=True;
    Result:=i;
   end
  else inc(i);
end;

function TSNIndexConverter.GetCount: Integer;
begin
 Result:=List.Count
end;

function TSNIndexConverter.GetItem(Index: Integer): TSNConvert;
begin
 Result:=PSNConvert(List.Items[Index])^;
end;

function TSNIndexConverter.NIndex2SIndex(NodeIndex:Integer): Integer;
var
 i:integer;
 Flag:boolean;
begin
 i:=0;
 Flag:=False;
 while (not Flag) and (i<List.Count) do
   begin
    if PSNConvert(List.Items[i]).NodeIndex=NodeIndex then
     begin
      Result:=PSNConvert(List.Items[i]).SelectionIndex;
      Flag:=True;
     end
      else inc(i);
   end;
 if not Flag then Result:=-1;
end;

function TSNIndexConverter.SIndex2NIndex(SelectionIndex:Integer): Integer;
var
 i:integer;
 Flag:boolean;
begin
 i:=0;
 Flag:=False;
 while (not Flag) and (i<List.Count) do
   begin
    if PSNConvert(List.Items[i]).SelectionIndex=SelectionIndex then
     begin
      Result:=PSNConvert(List.Items[i]).NodeIndex;
      Flag:=True;
     end
      else inc(i);
   end;
 if not Flag then Result:=-1;
end;

constructor TSounder.Create(FilePath:String);
begin

  inherited Create(false);
  FFilePath:=FilePath;
  FreeOnTerminate:=True;
end;

procedure TSounder.Execute;
begin
  MMSystem.PlaySound(PChar(FFilePath),0,SND_FILENAME);
  Terminate;
end;

constructor TMailClientRunner.Create;
begin
  inherited Create(False) ;
  FreeOnTerminate:=True;
end;

procedure TMailClientRunner.Execute;
begin
 OpenMailClient;
 Terminate;
end;

procedure TMailClientRunner.OpenMailClient;
const
   cMailClient = '\SOFTWARE\Clients\Mail\';
var
 reg: TRegistry;
 RegClientDefault: string;
begin
 reg := TRegistry.Create;
 try
  with reg do
   begin
    CloseKey;
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly(cMailClient) then  RegClientDefault := reg.ReadString('');
    if OpenKeyReadOnly(cMailClient + RegClientDefault + '\shell\open\command') then
     WinExec(PChar(ReadString('')), SW_SHOWNORMAL);
   end;
 finally
    reg.Free;
 end;
end;




end.


