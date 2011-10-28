unit uUserPictureDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs, JPEG, GIFImg;

type
  TUserPictureDlg = class(TForm)
    UserPictureDialog: TOpenPictureDialog;
    UserPictureLabelEdit: TLabeledEdit;
    UserPictureButton: TButton;
    SaveBtn: TButton;
    CancelBtn: TButton;
    DeleteBtn: TButton;
    procedure UserPictureButtonClick(Sender: TObject);
    procedure UserPictureLabelEditChange(Sender: TObject);
  private
  public
    function GetPicture: String;
  end;

var
  UserPictureDlg: TUserPictureDlg;

implementation

{$R *.dfm}

function TUserPictureDlg.GetPicture: String;
begin
  Result := UserPictureLabelEdit.Text;
end;

procedure TUserPictureDlg.UserPictureButtonClick(Sender: TObject);
begin
  if UserPictureDialog.Execute then
  begin
    UserPictureLabelEdit.Text := UserPictureDialog.FileName;
  end;
end;

procedure TUserPictureDlg.UserPictureLabelEditChange(Sender: TObject);
begin
  SaveBtn.Enabled := Trim(UserPictureLabelEdit.Text) <> '';
end;

end.
