unit main;

interface

uses  PerlRegEx,Forms,  AsFilter, masks,
  StrUtils,PostReceiver, Dialogs, Shared,IniFiles,AccountManager,
  Windows,ThreadManager, Messages, SysUtils, Variants, StdCtrls,
  IdBaseComponent, IdComponent, IdTCPServer,
  IdCmdTCPServer, IdExplicitTLSClientServerBase, IdPOP3Server, IdMessage,
  ADODB, DB, Classes, Controls, Grids, DBGrids, IdTCPConnection,
  IdTCPClient, IdMessageClient, IdPOP3, Unit1, Unit2, CoolTrayIcon, dxBar,
  cxSplitter, cxInplaceContainer, cxTL, cxControls, dxStatusBar;

type
  TFMain = class(TForm)
    dxStatusBar1: TdxStatusBar;
    cxTreeList1: TcxTreeList;
    cxSplitter1: TcxSplitter;
    cxTreeList1cxTreeListColumn1: TcxTreeListColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  FMain: TFMain;
implementation

uses RegExpr, StrMask;



{$R *.dfm}
{$R ..\Resources\WinXP.res}

end.
