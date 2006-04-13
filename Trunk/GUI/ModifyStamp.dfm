object FModifyStamp: TFModifyStamp
  Left = 666
  Top = 181
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Modify Stamp'
  ClientHeight = 164
  ClientWidth = 225
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
    Width = 225
    Height = 164
    Align = alClient
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    TabOrder = 0
    ClientRectBottom = 160
    ClientRectLeft = 2
    ClientRectRight = 221
    ClientRectTop = 2
    object leStamp: TLabeledEdit
      Left = 72
      Top = 16
      Width = 145
      Height = 21
      EditLabel.Width = 36
      EditLabel.Height = 13
      EditLabel.Caption = 'Stamp  '
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object leDescription: TLabeledEdit
      Left = 72
      Top = 48
      Width = 145
      Height = 21
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = 'Description  '
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object cxActive: TcxCheckBox
      Left = 72
      Top = 80
      Caption = 'Active'
      State = cbsChecked
      Style.HotTrack = True
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
    object btAdd: TButton
      Left = 16
      Top = 120
      Width = 75
      Height = 25
      Caption = 'Modify'
      TabOrder = 3
      OnClick = btAddClick
    end
    object btCancel: TButton
      Left = 136
      Top = 120
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 4
      OnClick = btCancelClick
    end
  end
end
