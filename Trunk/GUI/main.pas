unit main;

interface

uses
  Forms, PostManager, DB, ADODB, Classes, Controls, dbtables,
  StrUtils,PostReceiver, Dialogs, Shared,IniFiles,AccountManager,
  Windows,ThreadManager, Messages, SysUtils, Variants, StdCtrls,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  IdCmdTCPServer, IdExplicitTLSClientServerBase, IdPOP3Server;

type
  TFMain = class(TForm)
    acon: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  FMain: TFMain;
implementation



{$R *.dfm}
{$R ..\Resources\WinXP.res}

end.

{

проверить выполняется ли шифрование с использованием ключа

}
