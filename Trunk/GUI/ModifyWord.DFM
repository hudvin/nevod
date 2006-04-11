object FModifyWord: TFModifyWord
  Left = 234
  Top = 139
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Modify Word'
  ClientHeight = 152
  ClientWidth = 227
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxTabControl1: TcxTabControl
    Left = 0
    Top = 0
    Width = 227
    Height = 152
    Align = alClient
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    TabOrder = 0
    ClientRectBottom = 148
    ClientRectLeft = 2
    ClientRectRight = 223
    ClientRectTop = 2
    object leWord: TLabeledEdit
      Left = 80
      Top = 16
      Width = 121
      Height = 21
      EditLabel.Width = 32
      EditLabel.Height = 13
      EditLabel.Caption = 'Word  '
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
      Top = 88
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
    object cbLocation: TcxComboBox
      Left = 80
      Top = 64
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        'Only in mail subject'
        'Only in mail body'
        'In mail body and subject')
      Properties.OnChange = cbLocationPropertiesChange
      Style.BorderStyle = ebsNone
      Style.LookAndFeel.Kind = lfStandard
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 3
      Width = 121
    end
    object btOK: TButton
      Left = 16
      Top = 112
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 4
      OnClick = btOKClick
    end
    object btCancel: TButton
      Left = 120
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 5
      OnClick = btCancelClick
    end
  end
end
