object FCustomEditor: TFCustomEditor
  Left = 464
  Top = 221
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FCustomEditor'
  ClientHeight = 192
  ClientWidth = 312
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
  object TabControl: TcxTabControl
    Left = 0
    Top = 0
    Width = 312
    Height = 192
    Align = alClient
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    TabOrder = 0
    ClientRectBottom = 188
    ClientRectLeft = 2
    ClientRectRight = 308
    ClientRectTop = 2
    object leFilter: TLabel
      Left = 32
      Top = 72
      Width = 43
      Height = 13
      Caption = #1060#1080#1083#1100#1090#1088' '
    end
    object Label2: TLabel
      Left = 32
      Top = 96
      Width = 75
      Height = 13
      Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077
    end
    object cCBFilter: TcxComboBox
      Left = 88
      Top = 64
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cCBFilterPropertiesChange
      Style.LookAndFeel.Kind = lfStandard
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 0
      Width = 201
    end
    object cxCbActive: TcxCheckBox
      Left = 32
      Top = 112
      Caption = #1040#1082#1090#1080#1074#1077#1085' '
      Style.LookAndFeel.Kind = lfStandard
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 1
      Width = 121
    end
    object leValue: TLabeledEdit
      Left = 88
      Top = 16
      Width = 201
      Height = 21
      EditLabel.Width = 54
      EditLabel.Height = 13
      EditLabel.Caption = #1047#1085#1072#1095#1077#1085#1080#1077'  '
      LabelPosition = lpLeft
      TabOrder = 2
    end
    object leDescription: TLabeledEdit
      Left = 88
      Top = 40
      Width = 201
      Height = 21
      EditLabel.Width = 53
      EditLabel.Height = 13
      EditLabel.Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '
      LabelPosition = lpLeft
      TabOrder = 3
    end
    object btOK: TButton
      Left = 40
      Top = 152
      Width = 97
      Height = 25
      Caption = 'OK'
      TabOrder = 4
      OnClick = btOKClick
    end
    object btCancel: TButton
      Left = 176
      Top = 152
      Width = 97
      Height = 25
      Caption = 'Cancel'
      TabOrder = 5
      OnClick = btCancelClick
    end
    object cCBLocation: TcxComboBox
      Left = 120
      Top = 88
      Properties.DropDownListStyle = lsFixedList
      Style.LookAndFeel.Kind = lfStandard
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 6
      Width = 169
    end
  end
end
