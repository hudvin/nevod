unit AddStamp;

interface

uses
  Windows,DB, ADODB, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,main, cxContainer, cxEdit, cxCheckBox, StdCtrls, ExtCtrls, cxControls,
  cxPC;

type
  TFAddStamp = class(TForm)
    cxTabControl1: TcxTabControl;
    leStamp: TLabeledEdit;
    leDescription: TLabeledEdit;
    cxActive: TcxCheckBox;
    btAdd: TButton;
    btCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
  private
    adTest:TADOQuery;
  public
    { Public declarations }
  end;

var
  FAddStamp: TFAddStamp;

implementation

{$R *.dfm}

procedure TFAddStamp.FormShow(Sender: TObject);
begin
 leDescription.Text:='';
 leStamp.Text:='';
end;

procedure TFAddStamp.btAddClick(Sender: TObject);
begin
 if Trim(leStamp.Text)<>'' then
  begin
   with adTest do
     begin
      Close;
      SQL.Text:='SELECT COUNT(id) FROM StampFilter WHERE FVAlue=:Stamp ';
      Parameters.ParamByName('Stamp').Value:=leStamp.Text;
      Active:=True;
      if Fields[0].AsInteger>0 then  // если есть в таблице
       begin
        Close;
        ShowMessage(' Stamp ' +leStamp.Text + ' already in table ');
       end
        else // если нет в таблице
          begin
            Close;
            SQL.Text:='INSERT INTO StampFilter(FValue,Description,Active) '+
                      'VALUES(:Stamp,:Description,:Active)';
            Parameters.ParamByName('Stamp').Value:=leStamp.Text;
            Parameters.ParamByName('Description').Value:=leDescription.Text;
            if cxActive.Checked then
             Parameters.ParamByName('Active').Value:=True
              else Parameters.ParamByName('Active').Value:=False;
             ExecSQL;
             main.FMain.adStamp.Requery;
             FAddStamp.Close;
          end;
     end;

  end;
end;

procedure TFAddStamp.FormCreate(Sender: TObject);
begin
 adTest:=main.FMain.adTest; // создание ссылки на компонент для проверки данных
end;

procedure TFAddStamp.btCancelClick(Sender: TObject);
begin
 Close;
end;

end.
