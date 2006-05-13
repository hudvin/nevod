object FAccountEditor: TFAccountEditor
  Left = 357
  Top = 258
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FAccountEditor'
  ClientHeight = 194
  ClientWidth = 226
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object cxTab: TcxTabControl
    Left = 0
    Top = 0
    Width = 226
    Height = 194
    Align = alClient
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    TabOrder = 0
    ClientRectBottom = 194
    ClientRectRight = 226
    ClientRectTop = 0
    object leAccountName: TLabeledEdit
      Left = 88
      Top = 8
      Width = 121
      Height = 21
      EditLabel.Width = 74
      EditLabel.Height = 13
      EditLabel.Caption = 'AccountName  '
      LabelPosition = lpLeft
      TabOrder = 0
      OnKeyPress = leAccountNameKeyPress
    end
    object leUsername: TLabeledEdit
      Left = 88
      Top = 32
      Width = 121
      Height = 21
      EditLabel.Width = 54
      EditLabel.Height = 13
      EditLabel.Caption = 'Username  '
      LabelPosition = lpLeft
      TabOrder = 1
      OnKeyPress = leUsernameKeyPress
    end
    object lePassword: TLabeledEdit
      Left = 88
      Top = 56
      Width = 121
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = 'Password  '
      LabelPosition = lpLeft
      PasswordChar = '*'
      TabOrder = 2
      OnKeyPress = lePasswordKeyPress
    end
    object leHost: TLabeledEdit
      Left = 88
      Top = 80
      Width = 121
      Height = 21
      EditLabel.Width = 28
      EditLabel.Height = 13
      EditLabel.Caption = 'Host  '
      LabelPosition = lpLeft
      TabOrder = 3
      OnKeyPress = leHostKeyPress
    end
    object lePort: TLabeledEdit
      Left = 88
      Top = 104
      Width = 57
      Height = 21
      EditLabel.Width = 25
      EditLabel.Height = 13
      EditLabel.Caption = 'Port  '
      LabelPosition = lpLeft
      TabOrder = 4
      Text = '110'
      OnKeyPress = lePortKeyPress
    end
    object leTimeout: TLabeledEdit
      Left = 88
      Top = 128
      Width = 57
      Height = 21
      EditLabel.Width = 68
      EditLabel.Height = 13
      EditLabel.Caption = 'Timeout  ('#1089#1077#1082')'
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
