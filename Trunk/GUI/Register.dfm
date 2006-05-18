object FRegister: TFRegister
  Left = 277
  Top = 200
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Registration'
  ClientHeight = 129
  ClientWidth = 349
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object cxTab: TcxTabControl
    Left = 0
    Top = 0
    Width = 349
    Height = 129
    Align = alClient
    LookAndFeel.Kind = lfOffice11
    TabOrder = 0
    ClientRectBottom = 129
    ClientRectRight = 349
    ClientRectTop = 0
    object cxProgressBar: TcxProgressBar
      Left = 8
      Top = 40
      Position = 1.000000000000000000
      Properties.Max = 15.000000000000000000
      Properties.Min = 1.000000000000000000
      Properties.OverloadValue = 15.000000000000000000
      Properties.PeakValue = 1.000000000000000000
      Style.BorderStyle = ebsOffice11
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 0
      Width = 329
    end
    object btBuy: TButton
      Left = 8
      Top = 80
      Width = 75
      Height = 25
      Caption = #1050#1091#1087#1080#1090#1100
      TabOrder = 1
      OnClick = btBuyClick
    end
    object btEnterCode: TButton
      Left = 96
      Top = 80
      Width = 75
      Height = 25
      Caption = #1042#1074#1077#1089#1090#1080' '#1082#1086#1076
      TabOrder = 2
      OnClick = btEnterCodeClick
    end
    object btLater: TButton
      Left = 184
      Top = 80
      Width = 75
      Height = 25
      Caption = #1055#1086#1079#1078#1077
      TabOrder = 3
    end
    object btExit: TButton
      Left = 264
      Top = 80
      Width = 75
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 4
      OnClick = btExitClick
    end
  end
end
