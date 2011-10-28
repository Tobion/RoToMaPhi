object RoToMaPhiServerForm: TRoToMaPhiServerForm
  Left = 204
  Top = 181
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'RoToMaPhi Server'
  ClientHeight = 299
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 280
    Width = 521
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object RegisteredUsersListView: TListView
    Left = 0
    Top = 130
    Width = 521
    Height = 150
    Align = alBottom
    Columns = <
      item
        AutoSize = True
        Caption = 'Registrierte Spieler'
      end
      item
        Alignment = taRightJustify
        Caption = 'Spiele'
        Width = 70
      end
      item
        Alignment = taRightJustify
        Caption = 'Siege'
        Width = 70
      end
      item
        Caption = 'Letzter Login'
        Width = 115
      end
      item
        Alignment = taRightJustify
        Caption = 'Bildgr'#246#223'e in Byte'
        Width = 100
      end
      item
        Caption = 'Bildtyp'
        Width = 60
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object OptionsPanel: TPanel
    Left = 0
    Top = 0
    Width = 311
    Height = 130
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object PortLabel: TLabel
      Left = 74
      Top = 48
      Width = 27
      Height = 16
      Caption = 'Port:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object SpielerAnzLabel: TLabel
      Left = 16
      Top = 16
      Width = 85
      Height = 16
      Caption = 'Spieleranzahl:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ServerStartenBtn: TButton
      Left = 16
      Top = 83
      Width = 177
      Height = 30
      Caption = 'Server starten'
      TabOrder = 0
      OnClick = ServerStartenBtnClick
    end
    object PortSpinEdit: TSpinEdit
      Left = 120
      Top = 48
      Width = 73
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 1357
    end
    object SpielerAnzComboBox: TComboBox
      Left = 120
      Top = 16
      Width = 73
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 2
      Text = '3'
      Items.Strings = (
        '3'
        '4'
        '5'
        '6'
        '7'
        '8')
    end
    object NeuesSpielBtn: TButton
      Left = 216
      Top = 16
      Width = 81
      Height = 42
      Caption = 'Neues Spiel'
      Enabled = False
      TabOrder = 3
      OnClick = NeuesSpielBtnClick
    end
    object NeueKIBtn: TButton
      Left = 216
      Top = 71
      Width = 81
      Height = 42
      Caption = 'KI hinzuf'#252'gen'
      Enabled = False
      TabOrder = 4
      OnClick = NeueKIBtnClick
    end
  end
  object SpielerListView: TListView
    Left = 311
    Top = 0
    Width = 210
    Height = 130
    Align = alRight
    Columns = <
      item
        Caption = 'Spieler Online'
        Width = 160
      end
      item
        Alignment = taCenter
        Caption = 'Karten'
        Width = 45
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 3
    ViewStyle = vsReport
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = ServerSocketClientConnect
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    OnClientError = ServerSocketClientError
    Left = 16
    Top = 40
  end
end
