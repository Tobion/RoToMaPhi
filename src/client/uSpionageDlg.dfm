object SpionageDlg: TSpionageDlg
  Left = 464
  Top = 107
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Spionage'
  ClientHeight = 321
  ClientWidth = 177
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object SpionagePanel: TPanel
    Left = 0
    Top = 0
    Width = 177
    Height = 321
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 161
      Height = 20
      Caption = 'Bitte Opfer ausw'#228'hlen:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object KartenAnzahlLabel: TLabel
      Left = 16
      Top = 72
      Width = 80
      Height = 16
      Caption = 'Kartenanzahl:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object SpielerComboBox1: TComboBox
      Left = 16
      Top = 40
      Width = 145
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 0
      OnChange = SpielerComboBox1Change
    end
    object SpionageBtn: TButton
      Left = 16
      Top = 104
      Width = 145
      Height = 25
      Caption = 'ausspionieren'
      TabOrder = 1
      OnClick = SpionageBtnClick
    end
  end
  object AbgebenPanel: TPanel
    Left = 0
    Top = 0
    Width = 177
    Height = 321
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object KarteImage: TImage
      Left = 41
      Top = 81
      Width = 105
      Height = 161
    end
    object Label3: TLabel
      Left = 33
      Top = 9
      Width = 113
      Height = 20
      Caption = 'Karte geben an:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object SpielerComboBox2: TComboBox
      Left = 17
      Top = 41
      Width = 145
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 0
    end
    object OKBtn: TButton
      Left = 17
      Top = 257
      Width = 145
      Height = 25
      Caption = 'Karte geben'
      TabOrder = 1
      OnClick = OKBtnClick
    end
    object BehaltenBtn: TButton
      Left = 16
      Top = 288
      Width = 145
      Height = 25
      Caption = 'Behalten'
      TabOrder = 2
      OnClick = BehaltenBtnClick
    end
  end
end
