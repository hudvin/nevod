object FMain: TFMain
  Left = 247
  Top = 286
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
    Width = 169
    Height = 370
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
    OptionsData.Deleting = False
    OptionsSelection.CellSelect = False
    OptionsSelection.HideSelection = True
    OptionsSelection.MultiSelect = True
    OptionsView.ColumnAutoWidth = True
    OptionsView.TreeLineStyle = tllsSolid
    ParentFont = False
    TabOrder = 1
    Data = {
      020004006C0100000F00000044617461436F6E74726F6C6C6572310100000012
      000000546378537472696E6756616C7565547970650B00000000000700000047
      656E6572616C00000700000046696C746572730000080000004163636F756E74
      7301010101000005000000416C6C6F7700000400000044656E79000007000000
      436F6D706C6578010800000000000000100000000000000000000000FFFFFFFF
      02000000100000000000000000000000FFFFFFFF010000000400000003000000
      0000000000000000FFFFFFFF07000000100000000000000000000000FFFFFFFF
      08000000100000000000000000000000FFFFFFFF090000001000000000000000
      00000000FFFFFFFF03000000100000000000000000000000FFFFFFFF04000000
      100000000000000000000000FFFFFFFF05000000100000000000000000000000
      FFFFFFFF06000000100000000000000000000000FFFFFFFF0A00000010000000
      0000000000000000FFFFFFFF}
    object STree: TcxTreeListColumn
      DataBinding.ValueType = 'String'
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 169
    Top = 25
    Width = 8
    Height = 370
    HotZoneClassName = 'TcxMediaPlayer9Style'
    AutoSnap = True
    ResizeUpdate = True
    Control = SettingsTree
  end
  object stPages: TcxPageControl
    Left = 177
    Top = 25
    Width = 594
    Height = 370
    ActivePage = cxTab_Stamp
    Align = alClient
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    TabOrder = 3
    ClientRectBottom = 366
    ClientRectLeft = 2
    ClientRectRight = 590
    ClientRectTop = 22
    object cxTab_Accounts: TcxTabSheet
      Caption = 'cxTab_Accounts'
      ImageIndex = 1
      object cxAccountsGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 588
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
    object cxTabSheet3: TcxTabSheet
      Caption = 'cxTabSheet3'
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
        Width = 588
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
          Styles.Background = cxStyle10
          Styles.Content = cxStyle8
          Styles.Selection = cxStyle7
          object cxGrid2DBTableView1AccountName: TcxGridDBColumn
            DataBinding.FieldName = 'AccountName'
            Styles.Content = cxStyle1
            Width = 102
          end
          object cxGrid2DBTableView1ErrorType: TcxGridDBColumn
            DataBinding.FieldName = 'ErrorType'
            Styles.Content = cxStyle1
            Width = 65
          end
          object cxGrid2DBTableView1Message: TcxGridDBColumn
            DataBinding.FieldName = 'Message'
            Styles.Content = cxStyle1
            Width = 194
          end
          object cxGrid2DBTableView1ErrorTime: TcxGridDBColumn
            DataBinding.FieldName = 'ErrorTime'
            Styles.Content = cxStyle1
            Width = 66
          end
          object cxGrid2DBTableView1Id: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Styles.Content = cxStyle1
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
      object cxStampsGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 588
        Height = 344
        Align = alClient
        TabOrder = 0
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = True
        object cxStamps: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = dsStamp
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsSelection.InvertSelect = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object cxStampsFValue: TcxGridDBColumn
            DataBinding.FieldName = 'FValue'
            Options.Editing = False
          end
          object cxStampsDescription: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
            Options.Editing = False
          end
          object cxStampsActive: TcxGridDBColumn
            DataBinding.FieldName = 'Active'
          end
        end
        object cxStampsGridLevel1: TcxGridLevel
          GridView = cxStamps
        end
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
    Left = 136
    Top = 24
  end
  object dsLog: TDataSource
    DataSet = adLog
    Left = 40
    Top = 232
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
    Top = 232
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
  object cxStyleRepository1: TcxStyleRepository
    Left = 96
    Top = 56
    object cxStyle1: TcxStyle
      AssignedValues = [svFont]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -7
      Font.Name = 'MS Sans Serif'
      Font.Style = []
    end
    object cxStyle2: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle3: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle4: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 12937777
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clWhite
    end
    object cxStyle5: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 12937777
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clWhite
    end
    object cxStyle6: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 16247513
      TextColor = clBlack
    end
    object cxStyle7: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 16445924
      TextColor = clBlack
    end
    object cxStyle8: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 15850688
      TextColor = clBlack
    end
    object cxStyle9: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 12937777
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clWhite
    end
    object cxStyle10: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle11: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 4707838
      TextColor = clBlack
    end
    object cxStyle12: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle13: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 16711164
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clSilver
    end
    object cxStyle14: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 12937777
      TextColor = clWhite
    end
    object TreeListStyleSheetDevExpress: TcxTreeListStyleSheet
      Caption = 'DevExpress'
      Styles.Background = cxStyle2
      Styles.Content = cxStyle6
      Styles.Inactive = cxStyle10
      Styles.Selection = cxStyle14
      Styles.BandBackground = cxStyle3
      Styles.BandHeader = cxStyle4
      Styles.ColumnHeader = cxStyle5
      Styles.ContentEven = cxStyle7
      Styles.ContentOdd = cxStyle8
      Styles.Footer = cxStyle9
      Styles.IncSearch = cxStyle11
      Styles.Indicator = cxStyle12
      Styles.Preview = cxStyle13
      BuiltIn = True
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
            Item = dxBarSubItem1
            Visible = True
          end
          item
            Item = dxBarSubItem2
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
        PopupMenu = dxBarPopupMenu1
      end
      item
        Control = cxAccountsGrid
        PopupMenu = dxAccountsPopup
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
    object dxBarButton1: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton2: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton3: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton4: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton5: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton6: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton7: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton8: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton9: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'Account'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = dxBarButton10
          Visible = True
        end
        item
          Item = dxBarButton11
          Visible = True
        end
        item
          Item = dxBarButton12
          Visible = True
        end
        item
          Item = dxBarButton13
          Visible = True
        end>
    end
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
    object dxBarButton13: TdxBarButton
      Caption = 'Exit'
      Category = 0
      Hint = 'Exit'
      Visible = ivAlways
    end
    object pbAddAccount: TdxBarButton
      Action = amAddAccount
      Caption = 'Add Account ...'
      Category = 0
      Hint = 'Add Account '
    end
    object dxBarButton15: TdxBarButton
      Caption = 'Edit ...'
      Category = 0
      Hint = 'Edit '
      Visible = ivAlways
      OnClick = dxBarButton15Click
    end
    object dxBarButton16: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton17: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton14: TdxBarButton
      Caption = 'Filters'
      Category = 0
      Hint = 'Filters'
      Visible = ivAlways
    end
    object dxBarButton18: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = 'Filters'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = dxBarButton20
          Visible = True
        end
        item
          Item = dxBarButton21
          Visible = True
        end>
    end
    object dxBarButton19: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton20: TdxBarButton
      Action = amAddStamp
      Category = 0
    end
    object dxBarButton21: TdxBarButton
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
  end
  object dxBarPopupMenu1: TdxBarPopupMenu
    BarManager = dxBarManager1
    ItemLinks = <
      item
        Item = dxBarButton5
        Visible = True
      end
      item
        Item = dxBarButton7
        Visible = True
      end
      item
        Item = dxBarButton9
        Visible = True
      end
      item
        Item = dxBarButton8
        Visible = True
      end
      item
        Item = dxBarButton6
        Visible = True
      end>
    UseOwnFont = False
    Left = 755
    Top = 158
  end
  object aMan: TActionManager
    Left = 48
    Top = 336
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
  end
  object dxAccountsPopup: TdxBarPopupMenu
    BarManager = dxBarManager1
    ItemLinks = <
      item
        Item = pbAddAccount
        Visible = True
      end
      item
        Item = dxBarButton15
        Visible = True
      end
      item
        Item = dxBarButton17
        Visible = True
      end
      item
        Item = dxBarButton16
        Visible = True
      end>
    UseOwnFont = False
    OnPopup = dxAccountsPopupPopup
    Left = 139
    Top = 79
  end
  object adStamp: TADOTable
    Active = True
    Connection = adCon
    CursorType = ctStatic
    TableName = 'StampFilter'
    Left = 8
    Top = 264
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
  end
  object dsStamp: TDataSource
    DataSet = adStamp
    Left = 40
    Top = 264
  end
  object adTest: TADOQuery
    Connection = adCon
    Parameters = <>
    Left = 104
    Top = 24
  end
end
