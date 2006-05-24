object FAccountEditor: TFAccountEditor
  Left = 335
  Top = 404
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FAccountEditor'
  ClientHeight = 192
  ClientWidth = 240
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cxTab: TcxTabControl
    Left = 0
    Top = 0
    Width = 240
    Height = 192
    Align = alClient
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    Options = []
    Style = 8
    TabOrder = 0
    ClientRectBottom = 192
    ClientRectRight = 240
    ClientRectTop = 0
    object leAccountName: TLabeledEdit
      Left = 112
      Top = 8
      Width = 121
      Height = 21
      EditLabel.Width = 103
      EditLabel.Height = 13
      EditLabel.Caption = #1048#1084#1103' '#1091#1095#1077#1090#1085#1086#1081' '#1079#1072#1087#1080#1089#1080
      LabelPosition = lpLeft
      TabOrder = 0
      OnKeyPress = leAccountNameKeyPress
    end
    object leUsername: TLabeledEdit
      Left = 112
      Top = 32
      Width = 121
      Height = 21
      EditLabel.Width = 99
      EditLabel.Height = 13
      EditLabel.Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '
      LabelPosition = lpLeft
      TabOrder = 1
      OnKeyPress = leUsernameKeyPress
    end
    object lePassword: TLabeledEdit
      Left = 112
      Top = 56
      Width = 121
      Height = 21
      EditLabel.Width = 38
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1072#1088#1086#1083#1100
      LabelPosition = lpLeft
      PasswordChar = '*'
      TabOrder = 2
      OnKeyPress = lePasswordKeyPress
    end
    object leHost: TLabeledEdit
      Left = 112
      Top = 80
      Width = 121
      Height = 21
      EditLabel.Width = 37
      EditLabel.Height = 13
      EditLabel.Caption = #1057#1077#1088#1074#1077#1088
      LabelPosition = lpLeft
      TabOrder = 3
      OnKeyPress = leHostKeyPress
    end
    object lePort: TLabeledEdit
      Left = 112
      Top = 104
      Width = 57
      Height = 21
      EditLabel.Width = 28
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1086#1088#1090' '
      LabelPosition = lpLeft
      TabOrder = 4
      Text = '110'
      OnKeyPress = lePortKeyPress
    end
    object leTimeout: TLabeledEdit
      Left = 112
      Top = 128
      Width = 57
      Height = 21
      EditLabel.Width = 76
      EditLabel.Height = 13
      EditLabel.Caption = #1058#1072#1081#1084#1072#1091#1090'  ('#1089#1077#1082') '
      LabelPosition = lpLeft
      TabOrder = 5
      Text = '60'
      OnKeyPress = leTimeoutKeyPress
    end
    object btOK: TButton
      Left = 16
      Top = 160
      Width = 81
      Height = 25
      Caption = 'Add'
      TabOrder = 6
      OnClick = btOKClick
    end
    object btCancel: TButton
      Left = 136
      Top = 160
      Width = 81
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 7
      OnClick = btCancelClick
    end
  end
end
