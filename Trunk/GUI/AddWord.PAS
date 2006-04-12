unit AddWord;

interface

uses
  Windows, main,Typinfo, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxContainer,
  cxEdit, cxCheckBox, ExtCtrls, cxControls, cxPC,Shared;

type
 PSignalTypeDescriptor=^TSignalTypeDescriptor;
 TSignalTypeDescriptor = record
    Description: string;
    Location: TSignalLocation;
  end;

type
  TFAddWord = class(TForm)
    cxTabControl1: TcxTabControl;
    leWord: TLabeledEdit;
    leDescription: TLabeledEdit;
    chbActive: TcxCheckBox;
    cbLocation: TcxComboBox;
    btOK: TButton;
    btCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TSignalDescriptorsList = class
  private
    List: TList;
    function GetCount: Integer;
    function GetIndex(Index: Integer): TSignalTypeDescriptor;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Location:TSignalLocation;Description:String);
    property Count: Integer read GetCount;
    property Index[Index: Integer]: TSignalTypeDescriptor read GetIndex;
  end;



var
  FAddWord: TFAddWord;
  SelDesc:TSignalDescriptorsList;
implementation

uses ADODB;

{$R *.dfm}
{

по активной таблице определить тип для добавления
список вариантов грузить из таблицы при создании формы !

сделать выборку из таблицы Types, упорядочить по id
 сделать приведения для каждого типа
 добавить элементы в прямом порядке

 создать массив  описание - тип поиска
 из таблицы добавлять все, что вхожит в подтип


}

procedure TFAddWord.FormCreate(Sender: TObject);
var
 buff:TSignalLocation;
begin
 SelDesc:=TSignalDescriptorsList.Create;
 with main.FMain.adTest do
  begin
    Active:=False;
    SQl.Text:='SELECT Type,Description FROM Types ORDER BY Id ';
    Active:=True;
    while not Eof do
      begin
       buff:=TSignalLocation(GetEnumValue(TypeInfo(TSignalLocation),FieldByName('Type').AsString));
       if buff in [slBody,slSubject,slAnywhere]
        then  SelDesc.Add(buff,FieldByName('Description').AsString) ;
       Next;
      end;
  end;
  {

  добавить элементы в список вариантов
  добавить метод для поиска типа по имени

  }

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

function TSignalDescriptorsList.GetCount: Integer;
begin
 Result:=List.Count;
end;

function TSignalDescriptorsList.GetIndex(Index: Integer): TSignalTypeDescriptor;
begin
 Result.Description:=PSignalTypeDescriptor(List.Items[Index]).Description;
 Result.Location:=PSignalTypeDescriptor(List.Items[Index]).Location;
end;

procedure TFAddWord.FormDestroy(Sender: TObject);
begin
 SelDesc.Free;
end;

end.
