unit ThreadManager;

interface

uses
      Exceptions, DB, StrUtils, Shared,PostReceiver,
     SysUtils,TypInfo, Windows,Classes,DateUtils,Dialogs, ADODB, AccountManager;


type
  TThreadManager = class(TThread)
  private
    Accounts: TADOStoredProc;
    FCanExecute: Boolean;
    FAccountManager: TAccountManager;
    FADOCon: TADOConnection;
    FCheckInterval: Integer;
    Mutex: THandle;
    PostReceivers: TList;
    procedure Clean;
    function GetActiveThreads: Integer;
    procedure SetCheckInterval(const Value: Integer);
  public
    constructor Create(ADOCon: TADOConnection; AccountManager:TAccountManager;
        CanExecute:Boolean=True);
    destructor Destroy; override;
    procedure Execute; override;
    procedure StartAllThreads(Intro:boolean=True);
    procedure StartThread(AccountId: Integer;Single:Boolean=False);
    procedure StopAllThreads(Soft:boolean=False);
    procedure StopThread(AccountId: Integer); overload;
    property ActiveThreads: Integer read GetActiveThreads;
    property CheckInterval: Integer read FCheckInterval write SetCheckInterval;
  end;


implementation

{
******************************** TThreadManager ********************************
}
constructor TThreadManager.Create(ADOCon: TADOConnection;
    AccountManager:TAccountManager;CanExecute:Boolean=True);
begin
  inherited Create(False);
  FCheckInterval:=60000;
  Mutex:=CreateMutex(nil,False,MutexName);
  FAccountManager:=AccountManager;
  PostReceivers:=TList.Create;
  FADOCon:=ADOCon;
  FCanExecute:=CanExecute;
end;

destructor TThreadManager.Destroy;
begin
  StopAllThreads();
<<<<<<< .mine
=======
  CloseHandle(Mutex);
>>>>>>> .r28
  FADOCon:=nil;
  FAccountManager:=nil;
<<<<<<< .mine
  inherited Destroy;
  CloseHandle(Mutex);
=======
  inherited Destroy;
>>>>>>> .r28
end;

procedure TThreadManager.Clean;
var
  i: Integer;
begin
  i:=0;
  while i<PostReceivers.Count do
    begin
<<<<<<< .mine
     if TBaseReceiver(PostReceivers[i]).Terminated then
=======
   //  if TPOP3Receiver(PostReceivers[i]).Terminated then
      if  TBaseReceiver(PostReceivers[i]).Terminated then
>>>>>>> .r28
         begin
           FAccountManager.SetStatus(TBaseReceiver(PostReceivers[i]).AccountId,asFree);
           TBaseReceiver(PostReceivers[i]).Free;
           PostReceivers[i]:=nil;
         end;
     inc(i);
    end;
  PostReceivers.Pack;
end;

procedure TThreadManager.Execute;
var
  Counter: Integer;
begin
  Counter:=CheckInterval;
  while not Terminated do
   begin
<<<<<<< .mine
    Counter:=Counter+WaitTime;
    if FCanExecute then
     begin
      WaitForSingleObject(Mutex,WaitTime) ;
      Clean();
      if Counter>=CheckInterval  then
       begin
        StartAllThreads; // ������ ������� ��� ���������
        Counter:=0;
       end;
      ReleaseMutex(Mutex);
     end;
    sleep(WaitTime);
=======
   if FCanExecute then
    begin
     Counter:=Counter+WaitTime;
     WaitForSingleObject(Mutex,WaitTime) ;
     Clean();
     if (Counter>=CheckInterval) then
      begin
       StartAllThreads; // ������ ������� ��� ���������
       Counter:=0;
      end;
     ReleaseMutex(Mutex);
    end;
   sleep(WaitTime);
>>>>>>> .r28
   end;
  Terminate;
end;

function TThreadManager.GetActiveThreads: Integer;
begin
  WaitForSingleObject(Mutex,INFINITE);
    Clean();
    Result:=PostReceivers.Count;
  ReleaseMutex(Mutex);
end;

procedure TThreadManager.SetCheckInterval(const Value: Integer);
var
 Buff:boolean;
begin
  if FCheckInterval <> Value then
  begin
    Buff:=FCanExecute;
    if  Buff then FCanExecute:=False;
    FCheckInterval := Value;
    if Buff then
       FCanExecute:=True;
  end;
end;

procedure TThreadManager.StartAllThreads(Intro:boolean=True);
var
  AParams: TAccountParams;
  i:integer;
begin
 FCanExecute:=True;
 if Intro then   // ���� ������ �� ������
  begin

   for i :=1  to FAccountManager.Count  do
    if FAccountManager.Items[i].Status=asFree
     then StartThread(FAccountManager.Items[i].Id);
  end
 else  // ���� ������ �� ��������� ��� ����������
  begin
   WaitForSingleObject(Mutex,INFINITE);
 //   FCanExecute:=True;
    for i :=1  to FAccountManager.Count  do
     if FAccountManager.Items[i].Status=asFree
      then StartThread(FAccountManager.Items[i].Id);
   ReleaseMutex(Mutex);
  end;
end;

procedure TThreadManager.StartThread(AccountId: Integer;Single:Boolean=False);
var
 AParams:TAccountParams;
begin
 AParams:=FAccountManager.AccountById[AccountId];
 if Single then  // ���� ������ ���������� ������
  begin
   WaitForSingleObject(Mutex,INFINITE);
    FAccountManager.SetStatus(AccountId,asClient);
    PostReceivers.Add(TPOP3Receiver.Create(AParams,FADOCon,True));
   ReleaseMutex(Mutex);
  end
 else // ���� ������ ���������� �� ��������� StartAllThreads - ������� ��������
  begin
   FAccountManager.SetStatus(AccountId,asClient);
   PostReceivers.Add(TPOP3Receiver.Create(AParams,FADOCon,True));
  end;
end;

procedure TThreadManager.StopAllThreads(Soft:boolean=False);
var
 i:integer;
begin
 if NOT Soft then FCanExecute:=False;
 WaitForSingleObject(Mutex,INFINITE);
 // Clean;
  for i :=0  to PostReceivers.Count-1  do
   // if  TPOP3Receiver(PostReceivers[i]).Terminated then
     begin
<<<<<<< .mine
      FAccountManager.SetStatus(TBaseReceiver(PostReceivers[i]).AccountId,asFree);
      TBaseReceiver(PostReceivers[i]).Free;
=======
     {
      ���� ���������� - ���������� ������� � ���������� ������
     }
      FAccountManager.SetStatus(TBaseReceiver(PostReceivers[i]).AccountId,asFree);
      TPOP3Receiver(PostReceivers[i]).Free;
>>>>>>> .r28
      PostReceivers[i]:=nil;
<<<<<<< .mine
     end;
=======
     end ;
   // else
  //   begin
  //    TBaseReceiver(PostReceivers[i]).Free;
  //    PostReceivers[i]:=nil;
  //   end;
>>>>>>> .r28
 PostReceivers.Pack;   
 ReleaseMutex(Mutex);

  {
  ���� ������ ��������� - ������ ���������� ��� ������
  ���� ��� - ��������� CanExecute:=False
  }
end;

procedure TThreadManager.StopThread(AccountId: Integer);
var
 i:integer;
begin
 WaitForSingleObject(Mutex,INFINITE);
  for i :=0  to PostReceivers.Count-1 do
   if TBaseReceiver(PostReceivers[i]).AccountId=AccountId then
    if not TBaseReceiver(PostReceivers[i]).Terminated then
     begin
      TBaseReceiver(PostReceivers[i]).Free;
      PostReceivers[i]:=nil;
     end
    else
     begin
      //TBaseReceiver(PostReceivers[i]).Free;
      PostReceivers[i]:=nil;
     end;
 ReleaseMutex(Mutex);
end;




end.
