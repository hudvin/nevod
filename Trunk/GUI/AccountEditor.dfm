object FAccountEditor: TFAccountEditor
  Left = 269
  Top = 350
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FAccountEditor'
  ClientHeight = 165
  ClientWidth = 349
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
    Width = 349
    Height = 165
    Align = alClient
    LookAndFeel.Kind = lfOffice11
    Options = [pcoGradientClientArea]
    TabOrder = 0
    ClientRectBottom = 165
    ClientRectRight = 349
    ClientRectTop = 0
    object cxGroupBox1: TcxGroupBox
      Left = 4
      Top = 0
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1091#1095#1077#1090#1085#1086#1081' '#1079#1072#1087#1080#1089#1080
      Style.BorderColor = clWindowFrame
      Style.LookAndFeel.Kind = lfOffice11
      StyleDisabled.BorderColor = clBtnShadow
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.Kind = lfOffice11
      TabOrder = 0
      Transparent = True
      Height = 161
      Width = 240
      object leAccountName: TLabeledEdit
        Left = 112
        Top = 16
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
        Top = 40
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
        Top = 64
        Width = 121
        Height = 21
        EditLabel.Width = 38
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1072#1088#1086#1083#1100
        EditLabel.Font.Charset = RUSSIAN_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'MS Sans Serif'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        LabelPosition = lpLeft
        ParentFont = False
        PasswordChar = '1'
        TabOrder = 2
        OnKeyPress = lePasswordKeyPress
      end
      object leHost: TLabeledEdit
        Left = 112
        Top = 85
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
        Top = 109
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
        Top = 132
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
    end
    object cxGroupBox2: TcxGroupBox
      Left = 248
      Top = 0
      Style.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.Kind = lfOffice11
      TabOrder = 1
      Transparent = True
      Height = 161
      Width = 97
      object btOK: TButton
        Left = 8
        Top = 16
        Width = 81
        Height = 25
        Caption = 'Add'
        TabOrder = 0
        OnClick = btOKClick
      end
      object btCancel: TButton
        Left = 8
        Top = 50
        Width = 81
        Height = 25
        Caption = #1054#1090#1084#1077#1085#1072
        TabOrder = 1
        OnClick = btCancelClick
      end
      object btTest: TButton
        Left = 8
        Top = 82
        Width = 81
        Height = 25
        Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
        TabOrder = 2
        OnClick = btTestClick
      end
      object btHelp: TButton
        Left = 8
        Top = 114
        Width = 81
        Height = 25
        Caption = #1057#1087#1088#1072#1074#1082#1072
        TabOrder = 3
      end
    end
  end
  object JVHelp: TJvBalloonHint
    Options = [boUseDefaultIcon, boShowCloseBtn]
    Left = 12
    Top = 136
  end
end
