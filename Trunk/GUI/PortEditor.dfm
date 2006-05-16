object FPortEditor: TFPortEditor
  Left = 588
  Top = 333
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1086#1074#1099#1081' '#1087#1086#1088#1090' '#1089#1077#1088#1074#1077#1088#1072
  ClientHeight = 78
  ClientWidth = 147
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
    Width = 147
    Height = 78
    Align = alClient
    LookAndFeel.Kind = lfOffice11
    TabOrder = 3
    ClientRectBottom = 78
    ClientRectRight = 147
    ClientRectTop = 0
  end
  object leServerPort: TLabeledEdit
    Left = 8
    Top = 8
    Width = 129
    Height = 21
    EditLabel.Width = 79
    EditLabel.Height = 13
    EditLabel.Caption = #1055#1086#1088#1090' '#1089#1077#1088#1074#1077#1088#1072'   '
    LabelPosition = lpBelow
    TabOrder = 0
  end
  object btOK: TButton
    Left = 8
    Top = 40
    Width = 65
    Height = 25
    Caption = #1054#1050
    TabOrder = 1
    OnClick = btOKClick
  end
  object btCancel: TButton
    Left = 80
    Top = 40
    Width = 57
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = btCancelClick
  end
end
