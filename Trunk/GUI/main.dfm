object FMain: TFMain
  Left = 334
  Top = 239
  Width = 476
  Height = 457
  Caption = 'FMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 64
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 216
    Top = 48
    Width = 105
    Height = 25
    Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1087#1086#1095#1090#1091
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 104
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 2
    OnClick = Button3Click
  end
  object DBGrid1: TDBGrid
    Left = 88
    Top = 152
    Width = 320
    Height = 120
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object ACon: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=E:\Ne' +
      'vilon\Projects\Nevod\DB\messages.mdb;Mode=Share Deny None;Extend' +
      'ed Properties="";Persist Security Info=False;Jet OLEDB:System da' +
      'tabase="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password' +
      '="";Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Je' +
      't OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transact' +
      'ions=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create Syste' +
      'm Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don'#39 +
      't Copy Locale on Compact=False;Jet OLEDB:Compact Without Replica' +
      ' Repair=False;Jet OLEDB:SFP=False'
    LoginPrompt = False
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 8
    Top = 8
  end
  object aTab: TADOTable
    Connection = ACon
    CursorType = ctStatic
    TableName = 'Filters'
    Left = 8
    Top = 40
  end
  object IdPOP31: TIdPOP3
    AutoLogin = True
    SASLMechanisms = <>
    Left = 144
    Top = 16
  end
  object tab: TADOTable
    Connection = ACon
    CursorType = ctStatic
    TableName = 'Messages'
    Left = 192
    Top = 152
    object tabid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object tabmid: TIntegerField
      FieldName = 'mid'
    end
    object tabdeleted: TBooleanField
      FieldName = 'deleted'
    end
    object tabmessage: TMemoField
      FieldName = 'message'
      BlobType = ftMemo
    end
    object tabmessId: TWideStringField
      FieldName = 'messId'
      Size = 255
    end
    object tabAddress: TWideStringField
      FieldName = 'Address'
      Size = 255
    end
  end
  object DataSource1: TDataSource
    Left = 256
    Top = 112
  end
end
