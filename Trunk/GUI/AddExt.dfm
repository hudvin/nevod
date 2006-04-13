object FAddExt: TFAddExt
  Left = 671
  Top = 231
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Add Extension'
  ClientHeight = 145
  ClientWidth = 216
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxTabControl1: TcxTabControl
    Left = 0
    Top = 0
    Width = 216
    Height = 145
    Align = alClient
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    TabOrder = 0
    ClientRectBottom = 141
    ClientRectLeft = 2
    ClientRectRight = 212
    ClientRectTop = 2
    object leWord: TLabeledEdit
      Left = 80
      Top = 16
      Width = 121
      Height = 21
      EditLabel.Width = 46
      EditLabel.Height = 13
      EditLabel.Caption = 'Extension'
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
      Top = 72
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
      Top = 96
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 3
      OnClick = btOKClick
    end
    object btCancel: TButton
      Left = 112
      Top = 96
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 4
      OnClick = btCancelClick
    end
  end
end
