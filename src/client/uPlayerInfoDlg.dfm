object PlayerInfoDlg: TPlayerInfoDlg
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Spielerinformation'
  ClientHeight = 243
  ClientWidth = 243
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Padding.Left = 10
  Padding.Top = 10
  Padding.Right = 10
  Padding.Bottom = 10
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object UserImage: TImage
    Left = 10
    Top = 96
    Width = 223
    Height = 137
    AutoSize = True
    Constraints.MaxHeight = 600
    Constraints.MaxWidth = 800
    Stretch = True
  end
  object UsernameLabel: TLabel
    Left = 10
    Top = 10
    Width = 95
    Height = 23
    Caption = 'Username'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StatsLabel: TLabel
    Left = 13
    Top = 61
    Width = 125
    Height = 19
    Caption = 'X Spiele (X Siege)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LastLoginLabel: TLabel
    Left = 10
    Top = 39
    Width = 204
    Height = 16
    Caption = 'Letzter Login: 2008-07-27 15:00:00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
end
