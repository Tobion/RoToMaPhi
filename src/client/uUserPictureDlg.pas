unit uUserPictureDlg;

interface

uses
  SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls, ExtDlgs, Dialogs, Graphics;

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
    procedure FormCreate(Sender: TObject);
  private
  public
    function GetPicture: String;
  end;

var
  UserPictureDlg: TUserPictureDlg;

implementation

{$R *.dfm}

procedure TUserPictureDlg.FormCreate(Sender: TObject);
begin
  //UserPictureDialog.Filter := GraphicFilter(TGraphic);
end;

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
