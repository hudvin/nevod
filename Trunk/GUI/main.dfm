object FMain: TFMain
  Left = 221
  Top = 123
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FMain'
  ClientHeight = 448
  ClientWidth = 771
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'c:\d7.hlp'
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object stBar: TdxStatusBar
    Left = 0
    Top = 428
    Width = 771
    Height = 20
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
      end>
    PaintStyle = stpsUseLookAndFeel
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object SettingsTree: TcxTreeList
    Left = 0
    Top = 28
    Width = 177
    Height = 400
    Styles.Inactive = cxStyle2
    Styles.HotTrack = cxStyle1
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
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    OptionsBehavior.DragFocusing = True
    OptionsBehavior.WaitForExpandNodeTime = 5
    OptionsData.Editing = False
    OptionsData.Deleting = False
    OptionsSelection.InvertSelect = False
    OptionsView.ColumnAutoWidth = True
    OptionsView.TreeLineStyle = tllsSolid
    ParentFont = False
    TabOrder = 1
    OnDragDrop = SettingsTreeDragDrop
    OnDragOver = SettingsTreeDragOver
    OnSelectionChanged = SettingsTreeSelectionChanged
    Data = {
      02000400120200000F00000044617461436F6E74726F6C6C6572310100000012
      000000546378537472696E6756616C7565547970650E00000000000700000047
      656E6572616C00000700000046696C746572730000080000004163636F756E74
      73000005000000416C6C6F7700000400000044656E79000007000000436F6D70
      6C6578000005000000576F7264730000060000005374616D7073000007000000
      53656E6465727300000B0000004174746163686D656E7473000005000000576F
      72647300000700000053656E6465727300000B0000004174746163686D656E74
      730000030000004C6F670300000000000000100000000000000000000000FFFF
      FFFF02000000100000000000000000000000FFFFFFFF01000000040000000400
      00000000000000000000FFFFFFFF030000000400000004000000000000000000
      0000FFFFFFFF06000000100000000000000000000000FFFFFFFF070000001000
      00000000000000000000FFFFFFFF08000000100000000000000000000000FFFF
      FFFF09000000100000000000000000000000FFFFFFFF04000000040000000300
      00000000000000000000FFFFFFFF0A000000100000000000000000000000FFFF
      FFFF0B000000100000000000000000000000FFFFFFFF0C000000100000000000
      000000000000FFFFFFFF05000000100000000000000000000000FFFFFFFF0D00
      0000100000000000000000000000FFFFFFFF}
    object STree: TcxTreeListColumn
      DataBinding.ValueType = 'String'
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 177
    Top = 28
    Width = 8
    Height = 400
    HotZoneClassName = 'TcxMediaPlayer9Style'
    AutoSnap = True
    ResizeUpdate = True
    Control = SettingsTree
  end
  object stPages: TcxPageControl
    Left = 185
    Top = 28
    Width = 586
    Height = 400
    ActivePage = cxTab_Filters
    Align = alClient
    DragMode = dmAutomatic
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    TabOrder = 3
    ClientRectBottom = 396
    ClientRectLeft = 2
    ClientRectRight = 582
    ClientRectTop = 22
    object cxTab_Accounts: TcxTabSheet
      Caption = 'cxTab_Accounts'
      ImageIndex = 1
      object cxAccountsGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 580
        Height = 374
        Align = alClient
        TabOrder = 0
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = True
        object cxAccounts: TcxGridTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsSelection.CellSelect = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object cxAccountsAccountName: TcxGridColumn
            Caption = 'Account Name'
            Width = 117
          end
          object cxAccountsUsername: TcxGridColumn
            Caption = 'Username'
            Width = 112
          end
          object cxAccountsPassword: TcxGridColumn
            Caption = 'Password'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.EchoMode = eemPassword
            Properties.PasswordChar = '*'
            Width = 104
          end
          object cxAccountsServer: TcxGridColumn
            Caption = 'Server'
            Width = 104
          end
          object cxAccountsPort: TcxGridColumn
            Caption = 'Port'
            Width = 47
          end
          object cxAccountsTimeout: TcxGridColumn
            Caption = 'Timeout'
            Width = 51
          end
          object cxAccountsStatus: TcxGridColumn
            Caption = 'Status'
            Width = 51
          end
        end
        object cxAccountsGridLevel1: TcxGridLevel
          GridView = cxAccounts
        end
      end
    end
    object cxTab_Log: TcxTabSheet
      Caption = 'cxTab_Log'
      ImageIndex = 3
      object cxGrid2: TcxGrid
        Left = 0
        Top = 0
        Width = 580
        Height = 374
        Align = alClient
        TabOrder = 0
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = True
        object cxGrid2DBTableView1: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = dsLog
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsSelection.CellSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.CellAutoHeight = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.DataRowHeight = 19
          OptionsView.FooterAutoHeight = True
          OptionsView.GroupByBox = False
          object cxGrid2DBTableView1AccountName: TcxGridDBColumn
            DataBinding.FieldName = 'AccountName'
            Width = 102
          end
          object cxGrid2DBTableView1ErrorType: TcxGridDBColumn
            DataBinding.FieldName = 'ErrorType'
            Width = 65
          end
          object cxGrid2DBTableView1Message: TcxGridDBColumn
            DataBinding.FieldName = 'Message'
            Width = 194
          end
          object cxGrid2DBTableView1ErrorTime: TcxGridDBColumn
            DataBinding.FieldName = 'ErrorTime'
            Width = 66
          end
          object cxGrid2DBTableView1Id: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Width = 53
          end
        end
        object cxGrid2Level1: TcxGridLevel
          GridView = cxGrid2DBTableView1
        end
      end
    end
    object cxTab_Filters: TcxTabSheet
      Caption = 'cxTab_Filters'
      ImageIndex = 9
      object cxFiltersGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 580
        Height = 374
        Align = alClient
        TabOrder = 0
        LookAndFeel.NativeStyle = True
        object cxFilters: TcxGridDBTableView
          DragMode = dmAutomatic
          OnEndDrag = cxFiltersEndDrag
          OnStartDrag = cxFiltersStartDrag
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = dsFilters
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnFiltering = False
          OptionsSelection.CellSelect = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object cxFiltersid: TcxGridDBColumn
            DataBinding.FieldName = 'id'
            Visible = False
            Width = 53
          end
          object cxFiltersFValue: TcxGridDBColumn
            DataBinding.FieldName = 'FValue'
            Width = 168
          end
          object cxFiltersDescription: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
            Width = 168
          end
          object cxFiltersParams: TcxGridDBColumn
            DataBinding.FieldName = 'Params'
            Width = 123
          end
          object cxFiltersActive: TcxGridDBColumn
            DataBinding.FieldName = 'Active'
            Width = 66
          end
        end
        object cxFiltersGridLevel1: TcxGridLevel
          GridView = cxFilters
        end
      end
      object Button1: TButton
        Left = 152
        Top = 176
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 264
        Top = 184
        Width = 217
        Height = 49
        Caption = 'Button2'
        TabOrder = 2
        OnClick = Button2Click
      end
    end
    object cxTab_Settings: TcxTabSheet
      Caption = 'cxTab_Settings'
      ImageIndex = 3
    end
  end
  object Button3: TButton
    Left = 128
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 8
    OnClick = Button3Click
  end
  object adAccounts: TADOTable
    Connection = adCon
    CursorType = ctStatic
    TableName = 'Accounts'
    Top = 272
    object adAccountsid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object adAccountsAccountName: TWideStringField
      FieldName = 'AccountName'
      Size = 50
    end
    object adAccountsusername: TWideStringField
      FieldName = 'username'
      Size = 50
    end
    object adAccountspass: TWideStringField
      FieldName = 'pass'
      Size = 50
    end
    object adAccountshost: TWideStringField
      FieldName = 'host'
      Size = 50
    end
    object adAccountsport: TIntegerField
      FieldName = 'port'
    end
    object adAccountsTimeout: TIntegerField
      FieldName = 'Timeout'
    end
  end
  object dsAccounts: TDataSource
    DataSet = adAccounts
    Left = 32
    Top = 272
  end
  object adCon: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Projects\Nevod\D' +
      'B\messages.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Top = 368
  end
  object dsLog: TDataSource
    DataSet = adLog
    Left = 32
    Top = 304
  end
  object adLog: TADOQuery
    Active = True
    Connection = adCon
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT Log.Id,Accounts.AccountName,ErrorType,Log.Message,ErrorTi' +
        'me  FROM Log,Accounts'
      'WHERE  Accounts.Id=log.mid')
    Top = 304
    object adLogId: TAutoIncField
      FieldName = 'Id'
      ReadOnly = True
    end
    object adLogAccountName: TWideStringField
      FieldName = 'AccountName'
      Size = 50
    end
    object adLogErrorType: TWideStringField
      FieldName = 'ErrorType'
      Size = 50
    end
    object adLogMessage: TWideStringField
      FieldName = 'Message'
      Size = 255
    end
    object adLogErrorTime: TDateTimeField
      FieldName = 'ErrorTime'
    end
  end
  object dxBarManager1: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Bars = <
      item
        Caption = 'Custom 1'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 177
        FloatTop = 169
        FloatClientWidth = 0
        FloatClientHeight = 0
        IsMainMenu = True
        ItemLinks = <>
        MultiLine = True
        Name = 'Custom 1'
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        Visible = True
        WholeRow = True
      end>
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    LookAndFeel.Kind = lfUltraFlat
    LookAndFeel.NativeStyle = False
    PopupMenuLinks = <
      item
        Control = cxGrid2
      end
      item
        Control = cxAccountsGrid
      end
      item
      end
      item
      end
      item
      end>
    Style = bmsFlat
    SunkenBorder = True
    UseSystemFont = True
    Left = 147
    Top = 126
    DockControlHeights = (
      0
      0
      28
      0)
  end
  object aMan: TActionManager
    Left = 152
    Top = 152
    StyleName = 'XP Style'
    object Action1: TAction
      Caption = 'Action1'
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 104
    Top = 392
    object cxStyle1: TcxStyle
    end
  end
  object cxStyleRepository2: TcxStyleRepository
    Left = 72
    Top = 392
    object cxStyle2: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clWhite
    end
  end
  object adFilters: TADOQuery
    Connection = adCon
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT id,FValue,Description,Active,Params'
      'FROM FiltersParams')
    Top = 240
    object adFiltersid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object adFiltersFValue: TWideStringField
      FieldName = 'FValue'
      Size = 50
    end
    object adFiltersDescription: TWideStringField
      FieldName = 'Description'
      Size = 50
    end
    object adFiltersParams: TWideStringField
      FieldName = 'Params'
      OnGetText = adFiltersParamsGetText
      Size = 50
    end
    object adFiltersActive: TBooleanField
      FieldName = 'Active'
    end
  end
  object dsFilters: TDataSource
    DataSet = adFilters
    Left = 32
    Top = 240
  end
  object ADOQuery1: TADOQuery
    Connection = adCon
    Parameters = <
      item
        Name = 'mid'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'Value'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'Description'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'Active'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'Params'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'INSERT INTO FiltersParams (mid,FValue,Description,Active,Params)'
      'VALUES (:mid,:Value,:Description,:Active,:Params)')
    Left = 283
    Top = 183
  end
end
