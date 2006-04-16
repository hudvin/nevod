object FMain: TFMain
  Left = 213
  Top = 157
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FMain'
  ClientHeight = 415
  ClientWidth = 771
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object stBar: TdxStatusBar
    Left = 0
    Top = 395
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
    Top = 25
    Width = 177
    Height = 370
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
    OnDragOver = SettingsTreeDragOver
    OnSelectionChanged = SettingsTreeSelectionChanged
    Data = {
      02000400F50100000F00000044617461436F6E74726F6C6C6572310100000012
      000000546378537472696E6756616C7565547970650D00000000000700000047
      656E6572616C00000700000046696C746572730000080000004163636F756E74
      73000005000000416C6C6F7700000400000044656E79000007000000436F6D70
      6C6578000005000000576F7264730000060000005374616D7073000007000000
      53656E6465727300000B0000004174746163686D656E7473000005000000576F
      72647300000700000053656E6465727300000B0000004174746163686D656E74
      730300000000000000100000000000000000000000FFFFFFFF02000000100000
      000000000000000000FFFFFFFF01000000040000000300000000000000000000
      00FFFFFFFF0300000004000000040000000000000000000000FFFFFFFF060000
      00100000000000000000000000FFFFFFFF070000001000000000000000000000
      00FFFFFFFF08000000100000000000000000000000FFFFFFFF09000000100000
      000000000000000000FFFFFFFF04000000040000000300000000000000000000
      00FFFFFFFF0A000000100000000000000000000000FFFFFFFF0B000000100000
      000000000000000000FFFFFFFF0C000000100000000000000000000000FFFFFF
      FF05000000100000000000000000000000FFFFFFFF}
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
    Top = 25
    Width = 8
    Height = 370
    HotZoneClassName = 'TcxMediaPlayer9Style'
    AutoSnap = True
    ResizeUpdate = True
    Control = SettingsTree
  end
  object stPages: TcxPageControl
    Left = 185
    Top = 25
    Width = 586
    Height = 370
    ActivePage = cxTab_BlackWords
    Align = alClient
    DragMode = dmAutomatic
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    TabOrder = 3
    ClientRectBottom = 366
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
        Height = 344
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
    object cxTab_General: TcxTabSheet
      Caption = 'cxTab_General'
      ImageIndex = 2
      object cbRun: TcxCheckBox
        Left = 8
        Top = 16
        Caption = 'Run program on statrtup'
        Properties.OnChange = cbRunPropertiesChange
        State = cbsChecked
        Style.LookAndFeel.Kind = lfOffice11
        Style.LookAndFeel.NativeStyle = True
        StyleDisabled.LookAndFeel.Kind = lfOffice11
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.Kind = lfOffice11
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.Kind = lfOffice11
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 0
        Width = 145
      end
      object LabeledEdit1: TLabeledEdit
        Left = 8
        Top = 40
        Width = 41
        Height = 21
        EditLabel.Width = 55
        EditLabel.Height = 13
        EditLabel.Caption = ' Server port'
        LabelPosition = lpRight
        TabOrder = 1
      end
    end
    object cxTab_Log: TcxTabSheet
      Caption = 'cxTab_Log'
      ImageIndex = 3
      object cxGrid2: TcxGrid
        Left = 0
        Top = 0
        Width = 580
        Height = 344
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
    object cxTab_Stamp: TcxTabSheet
      Caption = 'cxTab_Stamp'
      ImageIndex = 3
      OnShow = cxTab_StampShow
      object cxStampsGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 580
        Height = 344
        Align = alClient
        TabOrder = 0
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = True
        object cxStamps: TcxGridDBTableView
          PopupMenu = dxStampsPopup
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = dsStamp
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.DeletingConfirmation = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object cxStampsFValue: TcxGridDBColumn
            Caption = 'Stamp'
            DataBinding.FieldName = 'FValue'
            Options.Editing = False
            Width = 211
          end
          object cxStampsDescription: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
            Options.Editing = False
            Width = 299
          end
          object cxStampsActive: TcxGridDBColumn
            DataBinding.FieldName = 'Active'
            Width = 68
          end
          object cxStampsId: TcxGridDBColumn
            DataBinding.FieldName = 'id'
            Visible = False
          end
        end
        object cxStampsGridLevel1: TcxGridLevel
          GridView = cxStamps
        end
      end
    end
    object cxTab_BlackWords: TcxTabSheet
      Caption = 'cxTab_BlackWords'
      ImageIndex = 4
      OnShow = cxTab_BlackWordsShow
      object cxBlackWordsGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 580
        Height = 344
        Align = alClient
        DragMode = dmAutomatic
        TabOrder = 0
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = True
        object cxBlackWords: TcxGridDBTableView
          DragMode = dmAutomatic
          OnEndDrag = cxBlackWordsEndDrag
          OnStartDrag = cxBlackWordsStartDrag
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = dsBlackWords
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.DeletingConfirmation = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object cxBlackWordsFValue: TcxGridDBColumn
            Caption = 'Word'
            DataBinding.FieldName = 'FValue'
            Options.Editing = False
            Width = 176
          end
          object cxBlackWordsSignalFilterDescription: TcxGridDBColumn
            Caption = 'Description'
            DataBinding.FieldName = 'SignalFilter.Description'
            Options.Editing = False
            Width = 199
          end
          object cxBlackWordsTypesDescription: TcxGridDBColumn
            Caption = 'Location'
            DataBinding.FieldName = 'Types.Description'
            Options.Editing = False
            Width = 153
          end
          object cxBlackWordsActive: TcxGridDBColumn
            DataBinding.FieldName = 'Active'
            Options.Editing = False
            Width = 58
          end
          object cxBlackWordsId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
          end
        end
        object cxBlackWordsGridLevel1: TcxGridLevel
          GridView = cxBlackWords
        end
      end
      object Button1: TButton
        Left = 128
        Top = 144
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 376
        Top = 176
        Width = 75
        Height = 25
        Caption = 'Button2'
        TabOrder = 2
        OnClick = Button2Click
      end
      object Memo1: TMemo
        Left = 64
        Top = 200
        Width = 185
        Height = 89
        Lines.Strings = (
          'Memo1')
        TabOrder = 3
      end
      object Memo2: TMemo
        Left = 288
        Top = 184
        Width = 185
        Height = 89
        Lines.Strings = (
          'Memo2')
        TabOrder = 4
      end
    end
    object cxTab_WhiteWords: TcxTabSheet
      Caption = 'cxTab_WhiteWords'
      ImageIndex = 5
      object cxWhiteWordsGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 580
        Height = 344
        Align = alClient
        TabOrder = 0
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = True
        object cxWhiteWords: TcxGridDBTableView
          DragMode = dmAutomatic
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = dsWhiteWords
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.DeletingConfirmation = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object cxWhiteWordsFValue: TcxGridDBColumn
            Caption = 'Word'
            DataBinding.FieldName = 'FValue'
            Options.Editing = False
            Width = 201
          end
          object cxWhiteWordsSignalFilterDescription: TcxGridDBColumn
            Caption = 'Description'
            DataBinding.FieldName = 'SignalFilter.Description'
            Options.Editing = False
            Width = 176
          end
          object cxWhiteWordsTypesDescription: TcxGridDBColumn
            Caption = 'Location'
            DataBinding.FieldName = 'Types.Description'
            Options.Editing = False
            Width = 96
          end
          object cxWhiteWordsActive: TcxGridDBColumn
            DataBinding.FieldName = 'Active'
            Width = 46
          end
          object cxWhiteWordsId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
            Options.Editing = False
            Width = 59
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxWhiteWords
        end
      end
    end
    object cxTab_WhiteSenders: TcxTabSheet
      Caption = 'cxTab_WhiteSenders'
      ImageIndex = 6
      OnShow = cxTab_WhiteSendersShow
      object cxWhiteSendersGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 580
        Height = 344
        Align = alClient
        TabOrder = 0
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = True
        object cxWhiteSenders: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = dsWhiteSenders
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsSelection.CellSelect = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object cxWhiteSendersid: TcxGridDBColumn
            DataBinding.FieldName = 'id'
            Visible = False
            Width = 53
          end
          object cxWhiteSendersFValue: TcxGridDBColumn
            DataBinding.FieldName = 'FValue'
            Width = 267
          end
          object cxWhiteSendersDescription: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
            Width = 251
          end
          object cxWhiteSendersActive: TcxGridDBColumn
            DataBinding.FieldName = 'Active'
            Width = 60
          end
        end
        object cxWhiteSendersGridLevel1: TcxGridLevel
          GridView = cxWhiteSenders
        end
      end
      object Button3: TButton
        Left = 312
        Top = 176
        Width = 75
        Height = 25
        Caption = 'Button3'
        TabOrder = 1
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 88
        Top = 184
        Width = 75
        Height = 25
        Caption = 'Button4'
        TabOrder = 2
        OnClick = Button4Click
      end
    end
    object cxTab_BlackSenders: TcxTabSheet
      Caption = 'cxTab_BlackSenders'
      DragMode = dmAutomatic
      ImageIndex = 7
      OnShow = cxTab_BlackSendersShow
      object cxBlackSendersGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 580
        Height = 344
        Align = alClient
        DragMode = dmAutomatic
        TabOrder = 0
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = True
        object cxBlackSenders: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = dsBlackSenders
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsSelection.CellSelect = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object cxBlackSendersid: TcxGridDBColumn
            DataBinding.FieldName = 'id'
            Visible = False
            Width = 20
          end
          object cxBlackSendersFValue: TcxGridDBColumn
            DataBinding.FieldName = 'FValue'
            Width = 309
          end
          object cxBlackSendersDescription: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
            Width = 137
          end
          object cxBlackSendersActive: TcxGridDBColumn
            DataBinding.FieldName = 'Active'
            Width = 112
          end
        end
        object cxBlackSendersGridLevel1: TcxGridLevel
          GridView = cxBlackSenders
        end
      end
    end
    object cxTab_WhiteExt: TcxTabSheet
      Caption = 'cxTab_WhiteExt'
      ImageIndex = 8
      OnShow = cxTab_WhiteExtShow
      object cxWhiteExtGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 580
        Height = 344
        Align = alClient
        TabOrder = 0
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = True
        object cxWhiteExt: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = dsWhiteExt
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsSelection.CellSelect = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object cxWhiteExtid: TcxGridDBColumn
            DataBinding.FieldName = 'id'
            Visible = False
          end
          object cxWhiteExtFValue: TcxGridDBColumn
            DataBinding.FieldName = 'FValue'
          end
          object cxWhiteExtDescription: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
          end
          object cxWhiteExtActive: TcxGridDBColumn
            DataBinding.FieldName = 'Active'
          end
        end
        object cxWhiteExtGridLevel1: TcxGridLevel
          GridView = cxWhiteExt
        end
      end
      object Button5: TButton
        Left = 312
        Top = 176
        Width = 75
        Height = 25
        Caption = 'Button5'
        TabOrder = 1
        OnClick = Button5Click
      end
      object Button6: TButton
        Left = 64
        Top = 136
        Width = 75
        Height = 25
        Caption = 'Button6'
        TabOrder = 2
        OnClick = Button6Click
      end
    end
    object cxTab_BlackExt: TcxTabSheet
      Caption = 'cxTab_BlackExt'
      ImageIndex = 9
      OnShow = cxTab_BlackExtShow
      object cxBlackExtGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 580
        Height = 344
        Align = alClient
        TabOrder = 0
        LookAndFeel.NativeStyle = True
        object cxBlackExt: TcxGridDBTableView
          DragMode = dmAutomatic
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = dsBlackExt
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsSelection.CellSelect = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object cxBlackExtid: TcxGridDBColumn
            DataBinding.FieldName = 'id'
            Visible = False
          end
          object cxBlackExtFValue: TcxGridDBColumn
            DataBinding.FieldName = 'FValue'
          end
          object cxBlackExtDescription: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
          end
          object cxBlackExtActive: TcxGridDBColumn
            DataBinding.FieldName = 'Active'
          end
        end
        object cxBlackExtGridLevel1: TcxGridLevel
          GridView = cxBlackExt
        end
      end
      object Button7: TButton
        Left = 136
        Top = 208
        Width = 75
        Height = 25
        Caption = 'Button7'
        TabOrder = 1
        OnClick = Button7Click
      end
    end
  end
  object adAccounts: TADOTable
    Connection = adCon
    CursorType = ctStatic
    TableName = 'Accounts'
    Left = 8
    Top = 192
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
    Left = 40
    Top = 192
  end
  object adCon: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Projects\Nevod\D' +
      'B\messages.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 96
    Top = 368
  end
  object dsLog: TDataSource
    DataSet = adLog
    Left = 40
    Top = 224
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
    Left = 8
    Top = 224
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
        ItemLinks = <
          item
            Item = dxMFilters
            Visible = True
          end>
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
        Control = cxStampsGrid
      end
      item
        Control = cxBlackWordsGrid
      end
      item
        Control = cxWhiteWordsGrid
      end>
    Style = bmsFlat
    SunkenBorder = True
    UseSystemFont = True
    Left = 147
    Top = 126
    DockControlHeights = (
      0
      0
      25
      0)
    object dxBarButton10: TdxBarButton
      Action = amAddAccount
      Caption = 'Add Account ...'
      Category = 0
      Hint = 'Add Account '
    end
    object dxBarButton11: TdxBarButton
      Caption = 'Edit ...'
      Category = 0
      Hint = 'Edit '
      Visible = ivAlways
      OnClick = dxBarButton11Click
    end
    object dxBarButton12: TdxBarButton
      Action = amDeleteAccount
      Caption = 'Delete ...'
      Category = 0
      Hint = 'Delete '
    end
    object pbAddAccount: TdxBarButton
      Action = amAddAccount
      Caption = 'Add Account ...'
      Category = 0
      Hint = 'Add Account '
    end
    object dxMFilters: TdxBarSubItem
      Caption = 'Filters'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = dxFiltersStamps
          Visible = True
        end
        item
          Item = dxFiltersBlackWords
          Visible = True
        end
        item
          Item = dxFiltersWhiteWords
          Visible = True
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = amModifyWord
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = amModifyWord
      Category = 0
    end
    object dxFiltersStamps: TdxBarSubItem
      Caption = 'Stamps'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = dxFiltersStampsAdd
          Visible = True
        end
        item
          Item = dxFiltersStampsDelete
          Visible = True
        end
        item
          Item = dxFiltersStampsEdit
          Visible = True
        end
        item
          Item = dxFiltersStampsSetToActive
          Visible = True
        end
        item
          Item = dxFiltersStampSetToNonActive
          Visible = True
        end>
      OnPopup = dxFiltersStampsPopup
    end
    object dxFiltersStampsAdd: TdxBarButton
      Action = amAddStamp
      Caption = 'Add'
      Category = 0
      Hint = 'Add'
    end
    object dxFiltersStampsDelete: TdxBarButton
      Action = amRemoveStamp
      Caption = 'Delete'
      Category = 0
      Hint = 'Delete'
    end
    object dxFiltersStampsEdit: TdxBarButton
      Action = amModifyStamp
      Caption = 'Edit Stamp'
      Category = 0
      Hint = 'Edit Stamp'
    end
    object dxPopupStampEdit: TdxBarButton
      Action = amModifyStamp
      Caption = 'Edit Stamp'
      Category = 0
      Enabled = False
      Hint = 'Edit Stamp'
    end
    object dxBarButton6: TdxBarButton
      Action = amModifyStamp
      Category = 0
    end
    object dxpFiltersStampsEdit: TdxBarButton
      Action = amModifyStamp
      Caption = 'Edit Stamp'
      Category = 0
      Hint = 'Edit Stamp'
    end
    object dxpFiltersRevomeStamp: TdxBarButton
      Action = amRemoveStamp
      Caption = 'Remove Stamp'
      Category = 0
      Hint = 'Remove Stamp'
    end
    object dxpFiltersStampsAdd: TdxBarButton
      Action = amAddStamp
      Caption = 'Add Stamp'
      Category = 0
      Hint = 'Add Stamp'
    end
    object dxpFiltersStampSetToActive: TdxBarButton
      Action = amSetStampsStatusToActive
      Category = 0
    end
    object dxFiltersStampsSetToActive: TdxBarButton
      Action = amSetStampsStatusToActive
      Category = 0
    end
    object dxpFiltersStampSetToNonActive: TdxBarButton
      Action = amSetStampsStatusToNonActive
      Category = 0
    end
    object dxFiltersStampSetToNonActive: TdxBarButton
      Action = amSetStampsStatusToNonActive
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Caption = 'BlackWords'
      Category = 0
      Hint = 'BlackWords'
      Visible = ivAlways
    end
    object dxFiltersBlackWords: TdxBarSubItem
      Caption = 'BlackWords'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = dxFiltersBlackWordsAdd
          Visible = True
        end
        item
          Item = dxFiltersBlackWordsEdit
          Visible = True
        end
        item
          Item = dxFiltersBlackWordsDelete
          Visible = True
        end
        item
          Item = dxFiltersBlackWordsSetToActive
          Visible = True
        end
        item
          Item = dxFiltersBlackWordsSetToNonActive
          Visible = True
        end>
    end
    object dxFiltersBlackWordsAdd: TdxBarButton
      Caption = 'Add'
      Category = 0
      Hint = 'Add'
      Visible = ivAlways
    end
    object dxFiltersBlackWordsDelete: TdxBarButton
      Caption = 'Delete'
      Category = 0
      Hint = 'Delete'
      Visible = ivAlways
    end
    object dxFiltersBlackWordsEdit: TdxBarButton
      Caption = 'Edit'
      Category = 0
      Hint = 'Edit'
      Visible = ivAlways
    end
    object dxFiltersBlackWordsSetToActive: TdxBarButton
      Caption = 'Set To Active'
      Category = 0
      Hint = 'Set To Active'
      Visible = ivAlways
    end
    object dxFiltersBlackWordsSetToNonActive: TdxBarButton
      Caption = 'Set To nonActive'
      Category = 0
      Hint = 'Set To nonActive'
      Visible = ivAlways
    end
    object dxFiltersWhiteWords: TdxBarSubItem
      Caption = 'WhiteWords'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = dxFiltersWhiteWordsAdd
          Visible = True
        end
        item
          Item = dxFiltersWhiteWordsEdit
          Visible = True
        end
        item
          Item = dxFiltersWhiteWordsDelete
          Visible = True
        end
        item
          Item = dxFiltersWhiteWordsSetToActive
          Visible = True
        end
        item
          Item = dxFiltersWhiteWordsSetToNonActive
          Visible = True
        end>
    end
    object dxFiltersWhiteWordsAdd: TdxBarButton
      Caption = 'Add'
      Category = 0
      Hint = 'Add'
      Visible = ivAlways
    end
    object dxFiltersWhiteWordsEdit: TdxBarButton
      Caption = 'Edit'
      Category = 0
      Hint = 'Edit'
      Visible = ivAlways
    end
    object dxFiltersWhiteWordsDelete: TdxBarButton
      Caption = 'Delete'
      Category = 0
      Hint = 'Delete'
      Visible = ivAlways
    end
    object dxFiltersWhiteWordsSetToActive: TdxBarButton
      Caption = 'Set To Active'
      Category = 0
      Hint = 'Set To Active'
      Visible = ivAlways
    end
    object dxFiltersWhiteWordsSetToNonActive: TdxBarButton
      Caption = 'Set To nonActive'
      Category = 0
      Hint = 'Set To nonActive'
      Visible = ivAlways
    end
    object dxBarButton18: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PaintStyle = psCaptionInMenu
    end
    object dxBarButton19: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PaintStyle = psCaptionGlyph
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarStatic1: TdxBarStatic
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton3: TdxBarButton
      Caption = 'Black Extensions'
      Category = 0
      Hint = 'Black Extensions'
      Visible = ivAlways
    end
  end
  object aMan: TActionManager
    Left = 96
    Top = 168
    StyleName = 'XP Style'
    object amAddAccount: TAction
      Caption = 'amAddAccount'
      OnExecute = amAddAccountExecute
    end
    object amDeleteAccount: TAction
      Caption = 'amDeleteAccount'
      OnExecute = amDeleteAccountExecute
    end
    object amAddStamp: TAction
      Caption = 'amAddStamp'
      OnExecute = amAddStampExecute
    end
    object amModifyWord: TAction
      Caption = 'amModifyWord'
      OnExecute = amModifyWordExecute
    end
    object amAddWord: TAction
      Caption = 'amAddWord'
    end
    object amModifyStamp: TAction
      Caption = 'Modify Stamp'
      OnExecute = amModifyStampExecute
    end
    object amRemoveStamp: TAction
      Caption = 'amRemoveStamp'
      OnExecute = amRemoveStampExecute
    end
    object amSetStampsStatusToActive: TAction
      Caption = 'Set To Active'
      OnExecute = amSetStampsStatusToActiveExecute
    end
    object amSetStampsStatusToNonActive: TAction
      Caption = 'Set To nonActive'
      OnExecute = amSetStampsStatusToNonActiveExecute
    end
  end
  object dsStamp: TDataSource
    DataSet = adStamp
    Left = 40
    Top = 256
  end
  object adTest: TADOQuery
    Connection = adCon
    Parameters = <>
    Left = 128
    Top = 368
  end
  object adBlackWords: TADOQuery
    Active = True
    Connection = adCon
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT SignalFilter.Id, SignalFilter.FValue,SignalFilter.Descrip' +
        'tion,Types.Description,SignalFilter.Active  FROM SignalFilter,Ty' +
        'pes'
      'WHERE SignalFilter.Location=Types.Type'
      'AND'
      'mid=('
      '          SELECT id FROM Filters'
      '          WHERE Type='#39'ftBlackWord'#39
      '         )')
    Left = 8
    Top = 288
    object adBlackWordsId: TAutoIncField
      FieldName = 'Id'
      ReadOnly = True
    end
    object adBlackWordsFValue: TWideStringField
      FieldName = 'FValue'
      Size = 255
    end
    object adBlackWordsSignalFilterDescription: TWideStringField
      FieldName = 'SignalFilter.Description'
      Size = 255
    end
    object adBlackWordsTypesDescription: TWideStringField
      FieldName = 'Types.Description'
      Size = 50
    end
    object adBlackWordsActive: TBooleanField
      FieldName = 'Active'
    end
  end
  object dsBlackWords: TDataSource
    DataSet = adBlackWords
    Left = 40
    Top = 288
  end
  object adWhiteWords: TADOQuery
    Active = True
    Connection = adCon
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT SignalFilter.Id, SignalFilter.FValue,SignalFilter.Descrip' +
        'tion,Types.Description,SignalFilter.Active  FROM SignalFilter,Ty' +
        'pes'
      'WHERE SignalFilter.Location=Types.Type'
      'AND'
      'mid=('
      '          SELECT id FROM Filters'
      '          WHERE Type='#39'ftWhiteWord'#39
      '         )')
    Left = 8
    Top = 320
  end
  object dsWhiteWords: TDataSource
    DataSet = adWhiteWords
    Left = 40
    Top = 320
  end
  object adStamp: TADOQuery
    Active = True
    Connection = adCon
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT id,FValue,Description,Active'
      'FROM StampFilter')
    Left = 8
    Top = 256
    object adStampFValue: TWideStringField
      FieldName = 'FValue'
      Size = 255
    end
    object adStampDescription: TWideStringField
      FieldName = 'Description'
      Size = 255
    end
    object adStampActive: TBooleanField
      FieldName = 'Active'
    end
    object adStampid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
  end
  object dxStampsPopup: TdxBarPopupMenu
    BarManager = dxBarManager1
    ItemLinks = <
      item
        Item = dxpFiltersStampsEdit
        Visible = True
      end
      item
        Item = dxpFiltersStampsAdd
        Visible = True
      end
      item
        Item = dxpFiltersRevomeStamp
        Visible = True
      end
      item
        Item = dxpFiltersStampSetToActive
        Visible = True
      end
      item
        Item = dxpFiltersStampSetToNonActive
        Visible = True
      end>
    UseOwnFont = False
    OnPopup = dxStampsPopupPopup
    Left = 192
    Top = 200
  end
  object adWhiteSenders: TADOQuery
    Active = True
    Connection = adCon
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT id,FValue,Description,Active FROM SenderFilter'
      'WHERE mid=('
      '          SELECT id FROM Filters'
      '          WHERE Type='#39'ftWhiteEMail'#39
      '         )')
    Left = 8
    Top = 352
    object adWhiteSendersid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object adWhiteSendersFValue: TWideStringField
      FieldName = 'FValue'
      Size = 255
    end
    object adWhiteSendersDescription: TWideStringField
      FieldName = 'Description'
      Size = 50
    end
    object adWhiteSendersActive: TBooleanField
      FieldName = 'Active'
    end
  end
  object dsWhiteSenders: TDataSource
    DataSet = adWhiteSenders
    Left = 40
    Top = 352
  end
  object dsBlackSenders: TDataSource
    DataSet = adBlackSenders
    Left = 40
    Top = 384
  end
  object adBlackSenders: TADOQuery
    Active = True
    Connection = adCon
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT id,FValue,Description,Active FROM SenderFilter'
      'WHERE mid=('
      '          SELECT id FROM Filters'
      '          WHERE Type='#39'ftBlackEMail'#39
      '         )')
    Left = 8
    Top = 384
    object adBlackSendersid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object adBlackSendersFValue: TWideStringField
      FieldName = 'FValue'
      Size = 255
    end
    object adBlackSendersDescription: TWideStringField
      FieldName = 'Description'
      Size = 50
    end
    object adBlackSendersActive: TBooleanField
      FieldName = 'Active'
    end
  end
  object adWhiteExt: TADOQuery
    Active = True
    Connection = adCon
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT id,FValue,Description,Active FROM AttachmentExtFilter'
      'WHERE mid=('
      '          SELECT id FROM Filters'
      '          WHERE Type='#39'ftWhiteAttachExtFilter'#39
      '         )')
    Left = 8
    Top = 160
  end
  object adBlackExt: TADOQuery
    Active = True
    Connection = adCon
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT id,FValue,Description,Active FROM AttachmentExtFilter'
      'WHERE mid=('
      '          SELECT id FROM Filters'
      '          WHERE Type='#39'ftBlackAttachExtFilter'#39
      '         )')
    Left = 8
    Top = 128
  end
  object dsWhiteExt: TDataSource
    DataSet = adWhiteExt
    Left = 40
    Top = 160
  end
  object dsBlackExt: TDataSource
    DataSet = adBlackExt
    Left = 40
    Top = 128
  end
  object cxStyleRepository1: TcxStyleRepository
    object cxStyle1: TcxStyle
    end
  end
  object cxStyleRepository2: TcxStyleRepository
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
end
