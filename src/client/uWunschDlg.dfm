object WunschDlg: TWunschDlg
  Left = 438
  Top = 192
  BorderStyle = bsDialog
  Caption = 'W'#252'nschen'
  ClientHeight = 133
  ClientWidth = 274
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
  object HeadlineLabel: TLabel
    Left = 24
    Top = 8
    Width = 220
    Height = 20
    Caption = 'Bitte eine Farbe w'#252'nschen:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object scgePanel: TPanel
    Left = 24
    Top = 32
    Width = 57
    Height = 57
    BevelOuter = bvNone
    Color = clYellow
    TabOrder = 8
  end
  object grgePanel: TPanel
    Left = 136
    Top = 32
    Width = 57
    Height = 57
    BevelOuter = bvNone
    Color = clYellow
    TabOrder = 7
    Visible = False
  end
  object blgePanel: TPanel
    Left = 192
    Top = 32
    Width = 57
    Height = 57
    BevelOuter = bvNone
    Color = clYellow
    TabOrder = 6
    Visible = False
  end
  object rogePanel: TPanel
    Left = 80
    Top = 32
    Width = 57
    Height = 57
    BevelOuter = bvNone
    Color = clYellow
    TabOrder = 5
    Visible = False
  end
  object OKBtn: TButton
    Left = 24
    Top = 96
    Width = 225
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object RotPanel: TPanel
    Left = 88
    Top = 40
    Width = 41
    Height = 41
    BevelOuter = bvNone
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = PanelClick
  end
  object SchwarzPanel: TPanel
    Left = 32
    Top = 40
    Width = 41
    Height = 41
    BevelOuter = bvNone
    Color = clBlack
    TabOrder = 2
    OnClick = PanelClick
  end
  object BlauPanel: TPanel
    Left = 200
    Top = 40
    Width = 41
    Height = 41
    BevelOuter = bvNone
    Color = clBlue
    TabOrder = 3
    OnClick = PanelClick
  end
  object GruenPanel: TPanel
    Left = 144
    Top = 40
    Width = 41
    Height = 41
    BevelOuter = bvNone
    Color = clGreen
    TabOrder = 4
    OnClick = PanelClick
  end
end
