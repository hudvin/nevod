object FMain: TFMain
  Left = 266
  Top = 155
  BorderStyle = bsSingle
  Caption = 'FMain'
  ClientHeight = 472
  ClientWidth = 698
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 72
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 176
    Top = 56
    Width = 289
    Height = 81
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button4: TButton
    Left = 264
    Top = 160
    Width = 121
    Height = 105
    Caption = 'Button4'
    TabOrder = 2
    OnClick = Button4Click
  end
  object Edit1: TEdit
    Left = 208
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
  end
  object Button6: TButton
    Left = 112
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Button6'
    TabOrder = 4
    OnClick = Button6Click
  end
  object DBGrid1: TDBGrid
    Left = 184
    Top = 296
    Width = 320
    Height = 120
    DataSource = DataSource1
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object acon: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=..\DB' +
      '\messages.mdb;Mode=Share Deny None;Extended Properties="";Persis' +
      't Security Info=False;Jet OLEDB:System database="";Jet OLEDB:Reg' +
      'istry Path="";Jet OLEDB:Database Password="";Jet OLEDB:Engine Ty' +
      'pe=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial ' +
      'Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Da' +
      'tabase Password="";Jet OLEDB:Create System Database=False;Jet OL' +
      'EDB:Encrypt Database=False;Jet OLEDB:Don'#39't Copy Locale on Compac' +
      't=False;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB' +
      ':SFP=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 8
    Top = 8
  end
  object ADOQuery1: TADOQuery
    Connection = acon
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'LocationA'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 'slBody'
      end
      item
        Name = 'FType'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 'ftBlackWord'
      end>
    Prepared = True
    SQL.Strings = (
      'SELECT FValue FROM SignalFilter '
      'WHERE     Active=TRUE'
      ' AND Location=:LocationA'
      ' AND mid=  '
      '    ('
      'SELECT id '
      '   FROM Filters'
      '    WHERE Type=:FType)'
      '  ')
    Left = 16
    Top = 208
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 16
    Top = 240
  end
end
