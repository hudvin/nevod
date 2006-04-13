object FModifyExt: TFModifyExt
  Left = 673
  Top = 231
  Width = 219
  Height = 175
  BorderIcons = [biSystemMenu]
  Caption = 'Modify Ext'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cxTabControl1: TcxTabControl
    Left = 0
    Top = 0
    Width = 211
    Height = 141
    Align = alClient
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    TabOrder = 0
    ClientRectBottom = 137
    ClientRectLeft = 2
    ClientRectRight = 207
    ClientRectTop = 2
    object leWord: TLabeledEdit
      Left = 80
      Top = 16
      Width = 121
      Height = 21
      EditLabel.Width = 40
      EditLabel.Height = 13
      EditLabel.Caption = 'Sender  '
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object leDescription: TLabeledEdit
      Left = 80
      Top = 40
      Width = 121
      Height = 21
      EditLabel.Width = 56
      EditLabel.Height = 13
      EditLabel.Caption = 'Description '
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object chbActive: TcxCheckBox
      Left = 80
      Top = 64
      Caption = 'Active'
      Style.LookAndFeel.Kind = lfStandard
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 2
      Width = 121
    end
    object btOK: TButton
      Left = 16
      Top = 104
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 3
    end
    object btCancel: TButton
      Left = 120
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 4
    end
  end
end
