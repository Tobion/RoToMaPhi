object RoToMaPhiForm: TRoToMaPhiForm
  Left = 166
  Top = 55
  Width = 730
  Height = 612
  Caption = 'RoToMaPhi'
  Color = clBtnFace
  Constraints.MinHeight = 612
  Constraints.MinWidth = 690
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object UntererRandPanel: TPanel
    Left = 0
    Top = 549
    Width = 722
    Height = 9
    Align = alBottom
    BevelOuter = bvNone
    Color = clBackground
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
  end
  object ObererRandPanel: TPanel
    Left = 0
    Top = 0
    Width = 722
    Height = 9
    Align = alTop
    BevelOuter = bvNone
    Color = clBackground
    TabOrder = 1
  end
  object OberflaechePanel: TPanel
    Left = 9
    Top = 9
    Width = 704
    Height = 540
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object BottomContainerPannel: TPanel
      Left = 0
      Top = 465
      Width = 704
      Height = 58
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object SpielerListView: TListView
        Left = 494
        Top = 9
        Width = 210
        Height = 49
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
        TabOrder = 0
        ViewStyle = vsReport
      end
      object ChatContainerPanel: TPanel
        Left = 0
        Top = 9
        Width = 494
        Height = 49
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object MsgPanel: TPanel
          Left = 0
          Top = 24
          Width = 494
          Height = 25
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            494
            25)
          object MsgSendenSpeedBtn: TSpeedButton
            Left = 445
            Top = 2
            Width = 48
            Height = 21
            Anchors = [akTop, akRight]
            Caption = 'Senden'
            Flat = True
            OnClick = MsgSendenSpeedBtnClick
          end
          object MsgEdit: TEdit
            Left = 0
            Top = 2
            Width = 443
            Height = 21
            Anchors = [akLeft, akRight, akBottom]
            MaxLength = 255
            TabOrder = 0
            OnKeyPress = MsgEditKeyPress
          end
        end
        object ChatRichEdit: TRichEdit
          Left = 0
          Top = 0
          Width = 494
          Height = 24
          Align = alClient
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 1
        end
      end
      object ORButtomContainerPanel: TPanel
        Left = 0
        Top = 0
        Width = 704
        Height = 9
        Align = alTop
        BevelOuter = bvNone
        Color = clBackground
        TabOrder = 2
      end
    end
    object UserKartenPanel: TPanel
      Left = 0
      Top = 249
      Width = 704
      Height = 216
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object LeftKartenPanel: TPanel
        Left = 0
        Top = 17
        Width = 32
        Height = 199
        Align = alLeft
        BevelOuter = bvNone
        Color = cl3DLight
        TabOrder = 0
      end
      object RightKartenPanel: TPanel
        Left = 673
        Top = 17
        Width = 31
        Height = 199
        Align = alRight
        BevelOuter = bvNone
        Color = cl3DLight
        TabOrder = 1
      end
      object UserScrollBox: TScrollBox
        Left = 32
        Top = 17
        Width = 641
        Height = 199
        Align = alClient
        BorderStyle = bsNone
        Color = cl3DLight
        ParentColor = False
        TabOrder = 2
        OnResize = UserScrollBoxResize
      end
      object TopKartenPanel: TPanel
        Left = 0
        Top = 0
        Width = 704
        Height = 17
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Deine Karten:'
        Color = cl3DLight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
    object StapelPanel: TPanel
      Left = 0
      Top = 0
      Width = 704
      Height = 249
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        704
        249)
      object BackgroundImage: TImage
        Left = 0
        Top = 0
        Width = 704
        Height = 249
        Align = alClient
        Stretch = True
        OnClick = BackgroundImageClick
      end
      object AnzNotwendigerSpielerLabel: TLabel
        Left = 0
        Top = 88
        Width = 704
        Height = 33
        Alignment = taCenter
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '*** Warte auf x weitere Spieler...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        OnClick = BackgroundImageClick
      end
      object EinloggenLabel: TLabel
        Left = 0
        Top = 88
        Width = 704
        Height = 33
        Alignment = taCenter
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '*** Bitte einloggen'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object SpielPanel: TPanel
        Left = 24
        Top = 0
        Width = 657
        Height = 249
        Anchors = [akTop]
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          657
          249)
        object KreisShape1: TShape
          Left = 167
          Top = 56
          Width = 129
          Height = 129
          Anchors = [akTop]
          Brush.Color = clActiveBorder
          Pen.Style = psClear
          Shape = stCircle
        end
        object KreisShape2: TShape
          Left = 351
          Top = 56
          Width = 129
          Height = 129
          Anchors = [akTop]
          Brush.Color = clActiveBorder
          Pen.Style = psClear
          Shape = stCircle
        end
        object SpielzustandShape: TShape
          Left = 239
          Top = 32
          Width = 169
          Height = 169
          Anchors = [akTop]
          Brush.Color = clCream
          Pen.Style = psClear
          Shape = stCircle
        end
        object WunschfarbePanel: TShape
          Left = 354
          Top = 104
          Width = 23
          Height = 25
          Anchors = [akTop]
          Brush.Color = clCream
          Pen.Style = psClear
          Shape = stRoundSquare
        end
        object AblageStapelShape: TShape
          Left = 424
          Top = 8
          Width = 217
          Height = 217
          Anchors = [akTop]
          Brush.Color = cl3DLight
          Pen.Style = psClear
          Shape = stCircle
        end
        object ZiehStapelShape: TShape
          Left = 5
          Top = 8
          Width = 217
          Height = 217
          Anchors = [akTop]
          Brush.Color = cl3DLight
          Pen.Style = psClear
          Shape = stCircle
        end
        object AblagestapelLabel: TLabel
          Left = 513
          Top = 196
          Width = 39
          Height = 13
          Anchors = [akTop]
          Caption = 'x Karten'
          Color = cl3DLight
          ParentColor = False
        end
        object AblagestapelImage: TImage
          Left = 481
          Top = 36
          Width = 100
          Height = 157
          Anchors = [akTop]
          ParentShowHint = False
          ShowHint = True
        end
        object ZiehstapelLabel: TLabel
          Left = 94
          Top = 196
          Width = 39
          Height = 13
          Anchors = [akTop]
          Caption = 'x Karten'
          Color = cl3DLight
          ParentColor = False
        end
        object ZuZiehenLabel: TLabel
          Left = 266
          Top = 75
          Width = 55
          Height = 13
          Anchors = [akTop]
          Caption = 'Zu Ziehen: '
          Color = clCream
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object SperrLabel: TLabel
          Left = 268
          Top = 140
          Width = 43
          Height = 13
          Anchors = [akTop]
          Caption = 'Gesperrt:'
          Color = clCream
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object WunschfarbeLabel: TLabel
          Left = 257
          Top = 108
          Width = 67
          Height = 13
          Anchors = [akTop]
          Caption = 'Wunschfarbe:'
          Color = clCream
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object LetzteInfosLabel: TLabel
          Left = 204
          Top = 196
          Width = 66
          Height = 13
          Anchors = [akTop]
          Caption = 'Letzte Info:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ZiehstapelImage: TImage
          Left = 66
          Top = 36
          Width = 100
          Height = 157
          Hint = 'Ziehstapel: Karte ziehen durch Klicken'
          Anchors = [akTop]
          AutoSize = True
          ParentShowHint = False
          ShowHint = True
          OnClick = ZiehstapelImageClick
        end
        object InfoLabel: TLabel
          Left = 216
          Top = 212
          Width = 23
          Height = 13
          Anchors = [akTop]
          Caption = 'Infos'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 80
          Top = 16
          Width = 66
          Height = 16
          Caption = ' Ziehstapel'
          Color = cl3DLight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object Label2: TLabel
          Left = 488
          Top = 16
          Width = 81
          Height = 16
          Caption = 'Ablagestapel'
          Color = cl3DLight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object SperrAnzLabel: TLabel
          Left = 332
          Top = 156
          Width = 24
          Height = 13
          Anchors = [akTop]
          Caption = 'x mal'
          Color = clCream
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
      end
    end
    object StatusBar: TStatusBar
      Left = 0
      Top = 523
      Width = 704
      Height = 17
      Panels = <>
      SimplePanel = True
    end
  end
  object LinkerRandPanel: TPanel
    Left = 0
    Top = 9
    Width = 9
    Height = 540
    Align = alLeft
    BevelOuter = bvNone
    Color = clBackground
    TabOrder = 3
  end
  object RechterRandPanel: TPanel
    Left = 713
    Top = 9
    Width = 9
    Height = 540
    Align = alRight
    BevelOuter = bvNone
    Color = clBackground
    TabOrder = 4
  end
  object MainMenu: TMainMenu
    Left = 8
    Top = 8
    object SpielMenu: TMenuItem
      Caption = '&Spiel'
      Hint = 'Spieloptionen'
      object EinloggenMenu: TMenuItem
        Caption = '&Einloggen'
        Hint = 'Verbindung zum Server aufnehmen'
        OnClick = EinloggenMenuClick
      end
      object AusloggenMenu: TMenuItem
        Caption = '&Ausloggen'
        OnClick = AusloggenMenuClick
      end
      object MenuLine1: TMenuItem
        Caption = '-'
      end
      object BeendenMenu: TMenuItem
        Caption = '&Beenden'
        OnClick = BeendenMenuClick
      end
    end
    object HilfeMenu: TMenuItem
      Caption = '&Hilfe'
      Hint = 'Ruft die Hilfe auf'
      OnClick = HilfeMenuClick
    end
    object OptionenMenu: TMenuItem
      Caption = '&Optionen'
      object EinstellungenMenu: TMenuItem
        Caption = 'Einstellungen'
        OnClick = EinstellungenMenuClick
      end
    end
  end
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 40
    Top = 8
  end
end
