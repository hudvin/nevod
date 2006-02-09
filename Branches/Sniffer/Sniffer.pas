{********************************************************************************
 --------------------------------------------------------------------------------
                         TSniffer component for Delphi

     GERGRTHRTH                           uses winpcap

               Packet Capture Driver by Politecnico di Torino

                            Written by Umar Sear
 --------------------------------------------------------------------------------

 TERMS AND CONDITIONS OF USE.

 Code in this unit is Copyright(C) 2003 Umar Sear

 The author of this software assumes no liability for damages caused under
 any circumstances whatsoever, and is under no obligation. Use of the software
 indicates acceptance of all conditions contained in this document. If you do
 not agree to these terms, you must delete this software immediately.

 You may distribute the archive in which this software is distributed, but
 under no circumstances must this archive be changed. Distributing a modified
 archive is a violation of the software license.

 If you do redistribute this software, please let me know at the email address
 given below.

 This software is not freeware, if you wish to use it other than for trial
 purposes, please contact me for a full licence.

 If you have any questions, requests, bug reports, etc., please contact me at
 the address given below.

 Umar Sear

 Email  : usear@yahoo.com

 Winpcap author:
 webpsite: http://netgroup-serv.polito.it
********************************************************************************}

unit sniffer;

interface

uses winpcap,winpcaptypes,winsock,Classes,DesignIntf,Sysutils;

Type

 PInterface=^TInterFace;
 TInterface=Packed record
   iName,
   iDesc   : String;
   Addr,
   Mask,
   Bcast   : LongWord;
 End;

 // Capture event callback definations

 TOnCapture    =  Procedure (const Header:PTpcap_pkthdr; const Data:Pointer) of object;
 TOnCaptureIP  =  Procedure (const Header:PTpcap_pkthdr; const Data:PIPPckt) of object;
 TOnCaptureTcp =  Procedure (const Header:PTpcap_pkthdr; const Data:PTCPPckt) of object;
 TOnCaptureUdp =  Procedure (const Header:PTpcap_pkthdr; const Data:PUDPPckt) of object;

 TProto   = (pIP, pTCP, pUDP, pICMP, pAny, pArp);
 TCapMode = (capPromiscuous, capNonPromiscuous);

  TSniffer = class;

  TSnifferThread = Class(Tthread)
  private
    sniffer     : TSniffer;
  public
    ReadTimes : integer;
    Constructor Create(Sniff:TSniffer);
    Destructor  Destroy;override;
    Procedure   Execute;override;
  end;


  Tsniffer = Class(TComponent)
  Protected
    FOnCapture    : TOnCapture;
    FOnCaptureIP  : TOnCaptureIP;
    FOnCaptureTCP : TOnCaptureTCP;
    FOnCaptureUDP : TOnCaptureUDP;
    FPCAP         : PPCAP;                     // Handle to the pcapdriver
    FBpfProgram   : Pbpf_program;
    FProto        : TProto;
    FIList        : TList;
    FDevNames     : TStringList;
    FDevDesc      : TStringList;
    FIIndex 	    : Integer;                   // current adapter
    FIName,		                                 // Interface name
    FFilter,
    FIDesc        : String;  	                 // Interface description
    FIMask,
    FIIp          : LongWord;
    FThread       : TSnifferThread;            // The listening thread
    FCapMode      : TCapMode;
    FSniffing     : Boolean;                   // Flag indicating snooping activity
    FSnapLen	    : Integer;                   // Snapshot length
    FFiltered     : Boolean;                   // Filtered flag
    FInterface    : PInterface;
    Function      GetInterfaces     (Var ErrStr:string) : boolean;
    procedure     ThreadTerminate   (Sender:tobject);
    procedure     SetInterfaceIndex (const Value: integer);
    Procedure 	  SetSnapLen        (Const Value: Integer);
    Procedure     SetProtocol       (Const Value : TProto);
    Procedure     SetFDesc          (Const Value : String);
    Procedure     SetFiltered       (Const value : Boolean);
    Procedure     SetFilterStr      (Const Value : String);
    Procedure     AddInterface      (dev  : Ppcap_if);
    Function      GetFMask : String;
    Function      GetIP    : String;
    Procedure     SetFMask          (Const Value : String);
    Procedure     SetIP            (Const Value : String);

  public
    Constructor   Create(AOwner: TComponent); override;
    Destructor    Destroy;override;
    Function      Activate    : Integer;
    Function      Deactivate  : Integer;
                  property      DeviceNames           : TStringList read FDevNames;
                  property      DeviceDescriptions    : TStringList read FDevDesc;
    Published     property      DeviceIndex           : Integer  read FIIndex       write SetInterfaceIndex;
    Published     Property      CaptureProtocol       : TProto   read FProto        Write SetProtocol;
    Published     property      Filtered              : Boolean  read FFiltered     Write SetFiltered;
    Published     property      DeviceName            : String   read FIName        Write SetFDesc;
    Published     property      DeviceDescription     : String   read FIDesc        Write SetFDesc;
    Published     property      CaptureLength 	      : Integer  read FSnapLen      Write SetSnapLen;
    Published     property      FilterString          : String   read FFilter       Write SetFilterStr;
    Published     property      OnCapture    : TOnCapture        read FOnCapture    write FOnCapture;
    Published     property      OnCaptureIP  : TOnCaptureIP      read FOnCaptureIP  write FOnCaptureIP;
    Published     property      OnCaptureTCP : TOnCaptureTCP     read FOnCaptureTCP write FOnCaptureTCP;
    Published     property      OnCaptureUDP : TOnCaptureUDP     read FOnCaptureUDP write FOnCaptureUDP;
    Published     Property      CaptureMode           : TCapMode read FCapMode      Write FCapMode;
    Published     property      DeviceMask            : String   read GetFMask      Write SetFMask;
    Published     property      DeviceAddress         : String   read GetIP         Write SetIP;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Sniffer', [TSniffer]);
  RegisterPropertiesInCategory('Device',['DeviceIndex','DeviceName','DeviceDescription',
                               'DeviceMask','DeviceAddress','CaptureMode']);
  RegisterPropertiesInCategory('Capture',['CaptureLength','CaptureProtocol','CaptureMode']);
  RegisterPropertiesInCategory('Filter',['Filtered','CaptureProtocol','FilterString']);
end;

//Capture Call Back
procedure CaptureCB(User:pointer;const Header:PTpcap_pkthdr;const Data:Pointer); cdecl;
begin
  // Trigger OnCapture event
  If Assigned(TSniffer(User).OnCapture) Then
    TSniffer(user).OnCapture(Header,Data);

  // Trigger OnCaptureIP event
  If (Assigned(TSniffer(User).OnCaptureIP)) and (Ntohs(PEthernetHdr(Data).Protocol)=Proto_IP) Then
    TSniffer(user).OnCaptureIP(Header,PIPPckt(Data));

  // Trigger OnCaptureTCP event
  If Assigned(TSniffer(User).OnCaptureTCP) and (PIPHdr(Data).Protocol=Proto_TCP) Then
    TSniffer(user).OnCaptureTCP(Header,PTCPPckt(Data));

  // Trigger OnCaptureUDP event
  If Assigned(TSniffer(User).OnCaptureUDP) and (PIPHdr(Data).Protocol=Proto_UDP) Then
    TSniffer(user).OnCaptureUDP(Header,PUDPPckt(Data));
end;

Constructor TSniffer.Create(AOwner: TComponent);
Var  ErrStr : String;
begin
  inherited Create(AOwner);
  FDevNames:=TStringList.Create;
  FDevDesc :=TStringList.Create;
  FSnapLen:=DEFAULT_SNAPLEN;
  FIList:=Tlist.create;
  If GetInterfaces(ErrStr) Then
    SetInterfaceIndex(0)
  Else
    SetInterfaceIndex(-1);
  Fproto:=pAny;
  FPCAP := Nil;
  Fsniffing:=false;
end;

Destructor TSniffer.Destroy;
begin
  DeActivate;
  FIList.Free;
  Inherited Destroy;
end;

function TSniffer.Activate: Integer;
Var ErrStr : String;
    i      : Integer;
begin
//  Result:=0;
  If (FSniffing) or (fpcap<>nil) then
  Begin
    Result:=1;  //Already sniffing
    Exit;
  End;

  If (Not Assigned(OnCapture)) and (Not Assigned(OnCaptureIP)) and (Not Assigned(OnCaptureTCP)) and
     (Not Assigned(OnCaptureUDP)) Then
  begin
//    ErrStr:='No callback specified';
    Result:=2;
    exit;
  end;

  If FCapMode=capPromiscuous then
    Fpcap:=pcap_open_live(pchar(FIName),FSnapLen,1, 20, pchar(ErrStr))
  Else
    Fpcap:=pcap_open_live(pchar(FIName),FSnapLen,0, 20, pchar(ErrStr));

  Fsnaplen:=pcap_snapshot(Fpcap);

  If Fpcap=nil then
  Begin
//    ErrStr:='Packet capture failed';
    Result:=3;
    Exit;
  End;

  If FFiltered Then
    pcap_setfilter(Fpcap,FBpfProgram);

  FThread := TSnifferThread.create(self);
  Fthread.OnTerminate := ThreadTerminate;
  Fthread.FreeOnTerminate := false;
  Fthread.resume;
  FSniffing := True;
  result:=0;
end;

Function TSniffer.Deactivate: Integer;
begin
//  result := false;

   if (not Fsniffing) then
  begin
    // errstr:='not active';
    Result:=1;
    exit;
  end;

  if FThread=nil then
  begin
    //errstr:='Thread not active';
    Result:=2;
    exit;
  end;

  Pcap_Close(FPCAP);
  FThread.Terminate;
  FThread.WaitFor;
  FThread.Free;
  Fthread := nil;
  Fpcap:=Nil;
  FSniffing:=False;
  result :=0;
end;

Procedure TSniffer.AddInterface(dev : Ppcap_if);
Var anInterface : PInterFace;
Begin
  FDevNames.Add(Dev.name);
  FDevDesc.Add(Dev.description);
  New(AnInterFace);
  AnInterFace.iName:=Dev.name;
  AnInterFace.iDesc:=Dev.description;
  If Dev.addresses<>nil then
  Begin
    AnInterFace.Addr:=StrToIP(Dev.addresses.addr);
    AnInterFace.Mask:=StrToIP(Dev.addresses.netmask);
    AnInterFace.Bcast:=StrToIP(Dev.addresses.broadaddr);
  End;
  FIList.Add(AnInterFace);
End;

function TSniffer.GetInterfaces(var ErrStr:string): boolean;
Var alldevs : PPPcap_if;
    dev     : ppcap_if;
begin
  Result:=False;
  New(alldevs);
  If Initializewpcap then
  Begin
    If pcap_findalldevs(alldevs,Pchar(errStr))=-1 then
      Exit;
    Try
      dev:=Alldevs^;
      AddInterface(dev);
      While dev.next <>nil do
      Begin
        dev:=dev.next;
        AddInterFace(dev);
      end;
      pcap_freealldevs(Alldevs^);
      Result:=True;
    Except
      ErrStr:='Error whilst retrieving interface names';
    End;
  End;
  Dispose(allDevs);
end;

constructor TSnifferThread.Create(Sniff:TSniffer);
begin
  ReadTimes:=0;
  Sniffer:=Sniff;
  inherited Create(TRUE);
end;

destructor TSnifferThread.Destroy;
begin
  inherited;
end;

procedure TSnifferThread.Execute;
begin
  if Sniffer=nil then exit;
  pcap_loop(Sniffer.FPCAP,0,@CaptureCB,Pointer(Sniffer));
  Sniffer.FSniffing:=True;
end;

procedure TSniffer.ThreadTerminate(Sender: tobject);
begin
  FSniffing:=false;
end;

procedure TSniffer.SetInterfaceIndex(const Value: integer);
begin
  If FIIndex=Value then
    exit;
  SetFiltered(False);
  if (value>-1) and (value<FIList.count) then
  Begin
    FInterFace:=FIList.Items[Value];
    FIIndex := Value;
    FIName  :=FInterFace.iName;         // Interfaces.Names[Value];
    FIDesc  :=FInterFace.iDesc;         // InterFaces.ValueFromIndex[Value];
    FIMask  :=FInterFace.Mask;          // Mask
    FIip    :=FInterFace.Addr;          // IP address
  End
  else
  Begin
    FIIndex := -1;
    FIName  := 'Invalid interface';
    FIDesc  := 'Invalid interface';
    FIMask  := 0;
    FIip    := 0;
  End;
end;

procedure TSniffer.SetSnapLen(const Value: integer);
Begin
  FSnapLen:=Value;
End;

Procedure TSniffer.SetProtocol(Const Value : TProto);
Begin
  If Value=Fproto then
    exit;
  FProto:=Value;
  Case Fproto of
    pIP   : FFilter:='ip';
    pTCP  : FFilter:='tcp';
    pUDP  : FFilter:='udp';
    pICMP : FFilter:='icmp';
    PArp  : FFilter:='arp';
    pAny  : FFilter:='';
  End; {Case}
  SetFiltered(false);
End;

Procedure TSniffer.SetFDesc (Const Value : String);
Begin
End;

Procedure TSniffer.SetFMask (Const Value : String);
Begin
End;

Procedure TSniffer.SetIp (Const Value : String);
Begin
End;

Function TSniffer.GetFMask: String;
Begin
  Result:=IPToStr(FIMask);
End;

Function TSniffer.GetIp: String;
Begin
  Result:=IPToStr(FIIp);
End;

Procedure TSniffer.SetFiltered (Const value : Boolean);
Var MyPcap   : PPcap;
    ErrStr   : String;
Begin
  if value=FFiltered then
    exit;

  If (Value) and (FIIndex>-1) then
  Begin
    Mypcap:=pcap_open_live(pchar(FIName),FSnapLen,1, 20, pchar(ErrStr));
//    Mypcap:=pcap_open_live(pchar(FIName),150,1, 20, pchar(ErrStr));
    If MyPcap=nil then
    Begin
      FFiltered:=False;
      Exit;
    End;
    New(FBpfProgram);
//  If pcap_compile(Mypcap,FBpfProgram,Pchar(FFilter),1,$ffff0000)=-1 then
    If pcap_compile(Mypcap,FBpfProgram,Pchar(FFilter),1,FIMask)=-1 then
    Begin
      Filtered:=False;
 //     ErrStr:=pcap_geterr(MyPcap);
      Exit;
    End;
    Pcap_Close(MyPcap);
  End;

  If not (Value) and (FBpfProgram<>nil) then
    Dispose(FBpfProgram);
  FFiltered:=Value;
End;

Procedure TSniffer.SetFilterStr (Const value : String);
Begin
  if value=FFilter then
    exit;
  FFilter:=LowerCase(Value);
  SetFiltered(false);
  Fproto:=pAny;
End;

end.
