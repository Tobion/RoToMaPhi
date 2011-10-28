object TauschDlg: TTauschDlg
  Left = 302
  Top = 126
  BorderStyle = bsDialog
  Caption = 'Tauschen'
  ClientHeight = 134
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 205
    Height = 20
    Caption = 'Bitte zwei Spieler ausw'#228'hlen,'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 32
    Width = 272
    Height = 20
    Caption = 'deren Karten getauscht werden sollen:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object OKBtn: TButton
    Left = 16
    Top = 96
    Width = 273
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object ComboBox1: TComboBox
    Left = 16
    Top = 64
    Width = 129
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 1
  end
  object ComboBox2: TComboBox
    Left = 160
    Top = 64
    Width = 129
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 2
  end
end
