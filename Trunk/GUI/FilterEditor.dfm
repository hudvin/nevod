object FCustomEditor: TFCustomEditor
  Left = 510
  Top = 278
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1085#1086#1074#1086#1075#1086' '#1092#1080#1083#1100#1090#1088#1072
  ClientHeight = 158
  ClientWidth = 262
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl: TcxTabControl
    Left = 0
    Top = 0
    Width = 262
    Height = 158
    Align = alClient
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    TabOrder = 0
    ClientRectBottom = 158
    ClientRectRight = 262
    ClientRectTop = 0
    object leFilter: TLabel
      Left = 44
      Top = 60
      Width = 43
      Height = 13
      Caption = #1060#1080#1083#1100#1090#1088' '
    end
    object leLocation: TLabel
      Left = 8
      Top = 84
      Width = 41
      Height = 13
      Caption = 'Location'
    end
    object cCBFilter: TcxComboBox
      Left = 88
      Top = 56
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cCBFilterPropertiesChange
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 0
      Width = 161
    end
    object cxCbActive: TcxCheckBox
      Left = 8
      Top = 104
      Caption = #1040#1082#1090#1080#1074#1077#1085' '
      State = cbsChecked
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 1
      Transparent = True
      Width = 121
    end
    object leValue: TLabeledEdit
      Left = 88
      Top = 8
      Width = 161
      Height = 21
      EditLabel.Width = 54
      EditLabel.Height = 13
      EditLabel.Caption = #1047#1085#1072#1095#1077#1085#1080#1077'  '
      LabelPosition = lpLeft
      TabOrder = 2
      OnKeyPress = leValueKeyPress
    end
    object leDescription: TLabeledEdit
      Left = 88
      Top = 32
      Width = 161
      Height = 21
      EditLabel.Width = 53
      EditLabel.Height = 13
      EditLabel.Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '
      LabelPosition = lpLeft
      TabOrder = 3
    end
    object btOK: TButton
      Left = 16
      Top = 128
      Width = 97
      Height = 25
      Caption = 'OK'
      TabOrder = 4
      OnClick = btOKClick
    end
    object btCancel: TButton
      Left = 136
      Top = 128
      Width = 97
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 5
      OnClick = btCancelClick
    end
    object cCBLocation: TcxComboBox
      Left = 88
      Top = 80
      Properties.DropDownListStyle = lsFixedList
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 6
      Width = 161
    end
  end
end
