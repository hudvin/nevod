object FCustomEditor: TFCustomEditor
  Left = 263
  Top = 261
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1085#1086#1074#1086#1075#1086' '#1092#1080#1083#1100#1090#1088#1072
  ClientHeight = 166
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object cxTab: TcxTabControl
    Left = 0
    Top = 0
    Width = 321
    Height = 166
    Align = alClient
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    Options = [pcoGradientClientArea]
    TabOrder = 0
    ClientRectBottom = 166
    ClientRectRight = 321
    ClientRectTop = 0
    object cxGroupBox1: TcxGroupBox
      Left = 4
      Top = -1
      Style.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.Kind = lfOffice11
      TabOrder = 0
      Transparent = True
      Height = 162
      Width = 309
      object leFilter: TLabel
        Left = 44
        Top = 68
        Width = 43
        Height = 13
        Caption = #1060#1080#1083#1100#1090#1088' '
      end
      object leLocation: TLabel
        Left = 9
        Top = 92
        Width = 41
        Height = 13
        Caption = 'Location'
      end
      object leValue: TLabeledEdit
        Left = 88
        Top = 16
        Width = 209
        Height = 21
        EditLabel.Width = 54
        EditLabel.Height = 13
        EditLabel.Caption = #1047#1085#1072#1095#1077#1085#1080#1077'  '
        LabelPosition = lpLeft
        TabOrder = 0
        OnKeyPress = leValueKeyPress
      end
      object leDescription: TLabeledEdit
        Left = 88
        Top = 40
        Width = 209
        Height = 21
        EditLabel.Width = 53
        EditLabel.Height = 13
        EditLabel.Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '
        LabelPosition = lpLeft
        TabOrder = 1
      end
      object cCBFilter: TcxComboBox
        Left = 88
        Top = 64
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
        TabOrder = 2
        Width = 209
      end
      object cCBLocation: TcxComboBox
        Left = 88
        Top = 88
        Properties.DropDownListStyle = lsFixedList
        Style.LookAndFeel.Kind = lfOffice11
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfOffice11
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfOffice11
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfOffice11
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 3
        Width = 209
      end
      object cxCbActive: TcxCheckBox
        Left = 16
        Top = 112
        Caption = #1040#1082#1090#1080#1074#1077#1085' '
        State = cbsChecked
        Style.LookAndFeel.Kind = lfOffice11
        Style.LookAndFeel.NativeStyle = True
        StyleDisabled.LookAndFeel.Kind = lfOffice11
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.Kind = lfOffice11
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.Kind = lfOffice11
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 4
        Transparent = True
        Width = 121
      end
      object btCancel: TButton
        Left = 185
        Top = 132
        Width = 101
        Height = 27
        Caption = #1054#1090#1084#1077#1085#1072
        TabOrder = 5
        OnClick = btCancelClick
      end
      object btOK: TButton
        Left = 23
        Top = 132
        Width = 101
        Height = 27
        Caption = 'OK'
        TabOrder = 6
        OnClick = btOKClick
      end
    end
  end
  object JVHelp: TJvBalloonHint
    DefaultBalloonPosition = bpLeftDown
    Options = [boShowCloseBtn, boPlaySound]
    ApplicationHintOptions = []
    Left = 12
    Top = 104
  end
  object JvBal: TJvBalloonHint
    Options = [boUseDefaultIcon, boShowCloseBtn]
    Left = 176
    Top = 192
  end
end
