object FMain: TFMain
  Left = 316
  Top = 218
  BorderStyle = bsSingle
  Caption = 'FMain'
  ClientHeight = 291
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 88
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 32
    Top = 56
    Width = 129
    Height = 33
    Caption = 'Start'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 40
    Top = 112
    Width = 137
    Height = 25
    Caption = 'StopAllThreads'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 176
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
  object acon: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=..\DB' +
      '\messages.mdb;Mode=Share Deny None;Extended Properties="";Persis' +
      't Security Info=False;Jet OLEDB:System database="";Jet OLEDB:Reg' +
      'istry Path="";Jet OLEDB:Database Password="";Jet OLEDB:Engine Ty' +
      'pe=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial ' +
      'Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Da' +
      'tabase Password="";Jet OLEDB:Create System Database=False;Jet OL' +
      'EDB:Encrypt Database=False;Jet OLEDB:Don'#39't Copy Locale on Compac' +
      't=False;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB' +
      ':SFP=False'
    LoginPrompt = False
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 8
    Top = 8
  end
  object pop: TIdPOP3Server
    Bindings = <
      item
        IP = '127.0.0.1'
        Port = 110
      end>
    OnDisconnect = popDisconnect
    CommandHandlers = <>
    ExceptionReply.Code = '-ERR'
    ExceptionReply.Text.Strings = (
      'Unknown Internal Error')
    Greeting.Code = '+OK'
    Greeting.Text.Strings = (
      'Welcome to Indy POP3 Server')
    HelpReply.Code = '+OK'
    HelpReply.Text.Strings = (
      'Help follows')
    MaxConnectionReply.Code = '-ERR'
    MaxConnectionReply.Text.Strings = (
      'Too many connections. Try again later.')
    ReplyTexts = <>
    ReplyUnknownCommand.Code = '-ERR'
    ReplyUnknownCommand.Text.Strings = (
      'Sorry, Unknown Command')
    CheckUser = popCheckUser
    OnQUIT = popQUIT
    Left = 136
    Top = 136
  end
end
