object EinloggenDlg: TEinloggenDlg
  Left = 349
  Top = 187
  BorderStyle = bsDialog
  Caption = 'Einloggen'
  ClientHeight = 169
  ClientWidth = 275
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel: TBevel
    Left = 8
    Top = 8
    Width = 257
    Height = 122
    Shape = bsFrame
  end
  object PortLabel: TLabel
    Left = 96
    Top = 88
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
  object OKBtn: TButton
    Left = 63
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 144
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 1
  end
  object StaticText1: TStaticText
    Left = 152
    Top = 136
    Width = 4
    Height = 4
    TabOrder = 2
  end
  object SpielernameLabelEdit: TLabeledEdit
    Left = 128
    Top = 24
    Width = 121
    Height = 21
    EditLabel.Width = 80
    EditLabel.Height = 16
    EditLabel.Caption = 'Spielername:'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -13
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    LabelPosition = lpLeft
    LabelSpacing = 5
    MaxLength = 19
    TabOrder = 3
    OnChange = SpielernameLabelEditChange
  end
  object HostLabelEdit: TLabeledEdit
    Left = 128
    Top = 56
    Width = 121
    Height = 21
    EditLabel.Width = 105
    EditLabel.Height = 16
    EditLabel.Caption = 'Server Name / IP:'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -13
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    LabelPosition = lpLeft
    LabelSpacing = 5
    TabOrder = 4
    Text = 'localhost'
    OnChange = SpielernameLabelEditChange
  end
  object PortSpinEdit: TSpinEdit
    Left = 128
    Top = 88
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 1357
  end
end
