object FMain: TFMain
  Left = 266
  Top = 155
  BorderStyle = bsSingle
  Caption = 'FMain'
  ClientHeight = 291
  ClientWidth = 509
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
    Left = 168
    Top = 56
    Width = 289
    Height = 81
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 88
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 2
    OnClick = Button3Click
  end
  object acon: TADOConnection
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
end
