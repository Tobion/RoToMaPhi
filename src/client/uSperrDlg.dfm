object SperrDlg: TSperrDlg
  Left = 264
  Top = 155
  BorderStyle = bsDialog
  Caption = 'Sperren'
  ClientHeight = 232
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 242
    Height = 20
    Caption = 'Bitte zu sperrende Farbe bzw.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 124
    Height = 20
    Caption = 'Typ ausw'#228'hlen:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 56
    Width = 297
    Height = 177
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 8
      Top = 8
      Width = 81
      Height = 89
      Caption = 'Farben'
      TabOrder = 4
    end
    object RdSchwarz: TRadioButton
      Left = 16
      Top = 24
      Width = 65
      Height = 17
      BiDiMode = bdLeftToRight
      Caption = 'Schwarz'
      Checked = True
      ParentBiDiMode = False
      TabOrder = 0
      TabStop = True
    end
    object RdRot: TRadioButton
      Left = 16
      Top = 40
      Width = 65
      Height = 17
      BiDiMode = bdLeftToRight
      Caption = 'Rot'
      ParentBiDiMode = False
      TabOrder = 1
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 112
      Width = 177
      Height = 57
      Caption = 'Anderes'
      TabOrder = 19
    end
    object RdEreignisse: TRadioButton
      Left = 16
      Top = 128
      Width = 161
      Height = 17
      Caption = 'Ereignisse (au'#223'er Tribunal)'
      TabOrder = 16
    end
    object RdGruen: TRadioButton
      Left = 16
      Top = 56
      Width = 65
      Height = 17
      BiDiMode = bdLeftToRight
      Caption = 'Gr'#252'n'
      ParentBiDiMode = False
      TabOrder = 2
    end
    object RdBlau: TRadioButton
      Left = 16
      Top = 72
      Width = 65
      Height = 17
      BiDiMode = bdLeftToRight
      Caption = 'Blau'
      ParentBiDiMode = False
      TabOrder = 3
    end
    object GroupBox3: TGroupBox
      Left = 192
      Top = 8
      Width = 97
      Height = 121
      Caption = 'Gesellschaft'
      TabOrder = 18
    end
    object GroupBox2: TGroupBox
      Left = 96
      Top = 8
      Width = 89
      Height = 105
      Caption = 'Einheiten'
      TabOrder = 17
    end
    object RdSklave: TRadioButton
      Left = 200
      Top = 24
      Width = 81
      Height = 17
      Caption = 'Sklaven'
      TabOrder = 5
    end
    object RdBettler: TRadioButton
      Left = 200
      Top = 40
      Width = 81
      Height = 17
      Caption = 'Bettler'
      TabOrder = 6
    end
    object RdBauer: TRadioButton
      Left = 200
      Top = 56
      Width = 81
      Height = 17
      Caption = 'Bauern'
      TabOrder = 7
    end
    object RdHandwerker: TRadioButton
      Left = 200
      Top = 72
      Width = 81
      Height = 17
      Caption = 'Handwerker'
      TabOrder = 8
    end
    object RdHaendler: TRadioButton
      Left = 200
      Top = 88
      Width = 81
      Height = 17
      Caption = 'H'#228'ndler'
      TabOrder = 9
    end
    object RdAdliger: TRadioButton
      Left = 200
      Top = 104
      Width = 81
      Height = 17
      Caption = 'Adlige'
      TabOrder = 10
    end
    object RdHellseher: TRadioButton
      Left = 104
      Top = 24
      Width = 73
      Height = 17
      Caption = 'Hellseher'
      TabOrder = 11
    end
    object RdSoeldner: TRadioButton
      Left = 104
      Top = 40
      Width = 73
      Height = 17
      Caption = 'S'#246'ldner'
      TabOrder = 12
    end
    object RdRitter: TRadioButton
      Left = 104
      Top = 56
      Width = 73
      Height = 17
      Caption = 'Ritter'
      TabOrder = 13
    end
    object RdDiplomat: TRadioButton
      Left = 104
      Top = 72
      Width = 73
      Height = 17
      Caption = 'Diplomaten'
      TabOrder = 14
    end
    object RdMagier: TRadioButton
      Left = 104
      Top = 88
      Width = 73
      Height = 17
      Caption = 'Magier'
      TabOrder = 15
    end
    object RdMauer: TRadioButton
      Left = 16
      Top = 144
      Width = 161
      Height = 17
      Caption = 'Mauer'
      TabOrder = 20
    end
  end
  object Button1: TButton
    Left = 200
    Top = 192
    Width = 81
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
