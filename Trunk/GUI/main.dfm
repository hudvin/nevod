object FMain: TFMain
  Left = 447
  Top = 172
  BorderStyle = bsSingle
  Caption = 'FMain'
  ClientHeight = 305
  ClientWidth = 572
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object dxStatusBar1: TdxStatusBar
    Left = 0
    Top = 285
    Width = 572
    Height = 20
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
      end>
    PaintStyle = stpsUseLookAndFeel
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object cxTreeList1: TcxTreeList
    Left = 0
    Top = 0
    Width = 169
    Height = 285
    Align = alLeft
    Bands = <
      item
      end>
    BufferedPaint = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    LookAndFeel.Kind = lfOffice11
    OptionsData.Deleting = False
    OptionsSelection.CellSelect = False
    OptionsSelection.HideSelection = True
    OptionsSelection.MultiSelect = True
    OptionsView.ColumnAutoWidth = True
    OptionsView.TreeLineStyle = tllsSolid
    ParentFont = False
    TabOrder = 1
    Data = {
      020004004A0100000F00000044617461436F6E74726F6C6C6572310100000012
      000000546378537472696E6756616C7565547970650A00000000000700000047
      656E6572616C00000700000046696C746572730101010101000005000000416C
      6C6F7700000400000044656E79000007000000436F6D706C6578070000000000
      0000100000000000000000000000FFFFFFFF0100000004000000030000000000
      000000000000FFFFFFFF07000000100000000000000000000000FFFFFFFF0800
      0000100000000000000000000000FFFFFFFF0900000010000000000000000000
      0000FFFFFFFF02000000100000000000000000000000FFFFFFFF030000001000
      00000000000000000000FFFFFFFF04000000100000000000000000000000FFFF
      FFFF05000000100000000000000000000000FFFFFFFF06000000100000000000
      000000000000FFFFFFFF}
    object cxTreeList1cxTreeListColumn1: TcxTreeListColumn
      DataBinding.ValueType = 'String'
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 169
    Top = 0
    Width = 8
    Height = 285
    HotZoneClassName = 'TcxMediaPlayer9Style'
    AutoSnap = True
    ResizeUpdate = True
  end
end
