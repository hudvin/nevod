object FAccountEditor: TFAccountEditor
  Left = 553
  Top = 106
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FAccountEditor'
  ClientHeight = 210
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object cxTab: TcxTabControl
    Left = 0
    Top = 0
    Width = 278
    Height = 210
    Align = alClient
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    TabOrder = 0
    ClientRectBottom = 206
    ClientRectLeft = 2
    ClientRectRight = 274
    ClientRectTop = 2
    object leAccountName: TLabeledEdit
      Left = 88
      Top = 8
      Width = 161
      Height = 21
      EditLabel.Width = 74
      EditLabel.Height = 13
      EditLabel.Caption = 'AccountName  '
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object leUsername: TLabeledEdit
      Left = 88
      Top = 32
      Width = 161
      Height = 21
      EditLabel.Width = 54
      EditLabel.Height = 13
      EditLabel.Caption = 'Username  '
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object lePassword: TLabeledEdit
      Left = 88
      Top = 56
      Width = 161
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = 'Password  '
      LabelPosition = lpLeft
      TabOrder = 2
    end
    object leHost: TLabeledEdit
      Left = 88
      Top = 80
      Width = 161
      Height = 21
      EditLabel.Width = 28
      EditLabel.Height = 13
      EditLabel.Caption = 'Host  '
      LabelPosition = lpLeft
      TabOrder = 3
    end
    object lePort: TLabeledEdit
      Left = 88
      Top = 104
      Width = 161
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
      Width = 161
      Height = 21
      EditLabel.Width = 44
      EditLabel.Height = 13
      EditLabel.Caption = 'Timeout  '
      LabelPosition = lpLeft
      TabOrder = 5
      Text = '60'
      OnKeyPress = leTimeoutKeyPress
    end
    object btOK: TButton
      Left = 40
      Top = 168
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 6
      OnClick = btOKClick
    end
    object btCancel: TButton
      Left = 152
      Top = 168
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 7
      OnClick = btCancelClick
    end
  end
end
