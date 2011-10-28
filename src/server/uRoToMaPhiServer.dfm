object RoToMaPhiServerForm: TRoToMaPhiServerForm
  Left = 204
  Top = 181
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'RoToMaPhi Server'
  ClientHeight = 388
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 369
    Width = 590
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object SpielerListView: TListView
    Left = 380
    Top = 0
    Width = 210
    Height = 369
    Align = alRight
    Columns = <
      item
        Caption = 'Spieler'
        Width = 160
      end
      item
        Alignment = taCenter
        Caption = 'Karten'
        Width = 45
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object OptionsPanel: TPanel
    Left = 0
    Top = 0
    Width = 380
    Height = 369
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
      Left = 8
      Top = 80
      Width = 97
      Height = 33
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
      Left = 112
      Top = 80
      Width = 81
      Height = 33
      Caption = 'Neues Spiel'
      Enabled = False
      TabOrder = 3
      OnClick = NeuesSpielBtnClick
    end
    object NeueKIBtn: TButton
      Left = 200
      Top = 80
      Width = 105
      Height = 33
      Caption = 'Neue KI erzeugen'
      Enabled = False
      TabOrder = 4
      OnClick = NeueKIBtnClick
    end
    object UserScrollBox: TScrollBox
      Left = 8
      Top = 128
      Width = 361
      Height = 233
      BorderStyle = bsNone
      Color = cl3DLight
      ParentColor = False
      TabOrder = 5
    end
    object BeendenBtn: TButton
      Left = 264
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Beenden'
      TabOrder = 6
      OnClick = BeendenBtnClick
    end
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = ServerSocketClientConnect
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    OnClientError = ServerSocketClientError
    Left = 208
    Top = 16
  end
end
