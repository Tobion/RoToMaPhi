object EinstellungenDlg: TEinstellungenDlg
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Einstellungen'
  ClientHeight = 282
  ClientWidth = 215
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
  object OKBtn: TButton
    Left = 32
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 112
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Abbrechen'
    Default = True
    ModalResult = 2
    TabOrder = 1
  end
  object RueckseiteGroup: TGroupBox
    Left = 16
    Top = 8
    Width = 185
    Height = 233
    Align = alCustom
    Caption = 'Kartenr'#252'ckseite ausw'#228'hlen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object RueckseiteImage: TImage
      Left = 40
      Top = 56
      Width = 100
      Height = 157
    end
    object RueckseiteCB: TComboBox
      Left = 16
      Top = 24
      Width = 153
      Height = 19
      Style = csOwnerDrawFixed
      Color = clWhite
      DropDownCount = 10
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = 'R'#252'ckseite 1'
      OnChange = RueckseiteCBChange
      Items.Strings = (
        'R'#252'ckseite 1'
        'R'#252'ckseite 2'
        'R'#252'ckseite 3'
        'R'#252'ckseite 4'
        'R'#252'ckseite 5'
        'R'#252'ckseite 6'
        'R'#252'ckseite 7'
        'R'#252'ckseite 8'
        'R'#252'ckseite 9'
        'R'#252'ckseite 10')
    end
  end
end
