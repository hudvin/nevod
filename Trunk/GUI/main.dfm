object FMain: TFMain
  Left = 334
  Top = 239
  Width = 355
  Height = 257
  Caption = 'FMain'
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
    Left = 120
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Pack'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 48
    Top = 128
    Width = 257
    Height = 65
    Caption = 'Button3'
    TabOrder = 1
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 112
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object ACon: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=../DB/messages.mdb;' +
      'Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
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
end
