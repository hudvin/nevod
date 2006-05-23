object FRegistrationKey: TFRegistrationKey
  Left = 366
  Top = 253
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1050#1083#1102#1095' '#1072#1082#1090#1080#1074#1072#1094#1080#1080
  ClientHeight = 125
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxTab: TcxTabControl
    Left = 0
    Top = 0
    Width = 275
    Height = 125
    Align = alClient
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    Options = []
    TabOrder = 0
    ClientRectBottom = 125
    ClientRectRight = 275
    ClientRectTop = 0
    object leUsername: TLabeledEdit
      Left = 8
      Top = 24
      Width = 257
      Height = 21
      EditLabel.Width = 99
      EditLabel.Height = 13
      EditLabel.Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '
      TabOrder = 0
    end
    object leKey: TLabeledEdit
      Left = 8
      Top = 64
      Width = 257
      Height = 21
      EditLabel.Width = 96
      EditLabel.Height = 13
      EditLabel.Caption = #1050#1083#1102#1095' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080' '
      TabOrder = 1
    end
    object btOk: TButton
      Left = 16
      Top = 96
      Width = 75
      Height = 25
      Caption = #1054#1050
      TabOrder = 2
      OnClick = btOkClick
    end
    object btCancel: TButton
      Left = 168
      Top = 96
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 3
      OnClick = btCancelClick
    end
  end
end
