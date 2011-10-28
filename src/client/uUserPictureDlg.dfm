object UserPictureDlg: TUserPictureDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'UserPictureDlg'
  ClientHeight = 106
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object UserPictureLabelEdit: TLabeledEdit
    Left = 8
    Top = 31
    Width = 161
    Height = 21
    EditLabel.Width = 63
    EditLabel.Height = 16
    EditLabel.Caption = 'Nutzerbild:'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -13
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    LabelSpacing = 5
    TabOrder = 0
    OnChange = UserPictureLabelEditChange
  end
  object UserPictureButton: TButton
    Left = 176
    Top = 31
    Width = 65
    Height = 22
    Caption = #214'ffnen'
    TabOrder = 1
    OnClick = UserPictureButtonClick
  end
  object SaveBtn: TButton
    Left = 8
    Top = 72
    Width = 65
    Height = 25
    Caption = 'Speichern'
    Enabled = False
    ModalResult = 6
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 176
    Top = 72
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    Default = True
    ModalResult = 2
    TabOrder = 3
  end
  object DeleteBtn: TButton
    Left = 92
    Top = 72
    Width = 65
    Height = 25
    Caption = 'L'#246'schen'
    ModalResult = 7
    TabOrder = 4
  end
  object UserPictureDialog: TOpenPictureDialog
    Filter = 
      'Image File (.png, .jpg, .jpeg, .gif, .bmp, .ico)|*.png;*.jpg;*.j' +
      'peg;*.gif;*.bmp;*.ico|Portable Network Graphics|*.png|JPEG|*.jpg' +
      ';*.jpeg|Graphics Interchange Format|*.gif|Bitmap|*.bmp|Symbol|*.' +
      'ico'
    Left = 208
  end
end
