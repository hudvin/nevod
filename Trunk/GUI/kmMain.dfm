object FMain: TFMain
  Left = 248
  Top = 210
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Nevod AntiSpam KeyMaker'
  ClientHeight = 127
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btGenerate: TButton
    Left = 8
    Top = 96
    Width = 257
    Height = 25
    Caption = 'Generate'
    TabOrder = 0
    OnClick = btGenerateClick
  end
  object leUsername: TLabeledEdit
    Left = 88
    Top = 16
    Width = 169
    Height = 21
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = 'Username '
    LabelPosition = lpLeft
    TabOrder = 1
  end
  object leActivationKeu: TLabeledEdit
    Left = 88
    Top = 64
    Width = 169
    Height = 21
    EditLabel.Width = 71
    EditLabel.Height = 13
    EditLabel.Caption = 'Activation Key '
    LabelPosition = lpLeft
    TabOrder = 2
  end
  object leCRC: TLabeledEdit
    Left = 88
    Top = 40
    Width = 169
    Height = 21
    EditLabel.Width = 25
    EditLabel.Height = 13
    EditLabel.Caption = 'CRC '
    LabelPosition = lpLeft
    TabOrder = 3
  end
  object XPManifest1: TXPManifest
    Left = 240
    Top = 112
  end
end
