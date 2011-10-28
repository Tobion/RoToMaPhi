unit uEinstellungenDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uResourceAccess;

type
  TEinstellungenDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    RueckseiteGroup: TGroupBox;
    RueckseiteImage: TImage;
    RueckseiteCB: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure RueckseiteCBChange(Sender: TObject);
  private
  public
    function GetBackSideImage: TGraphic;
  end;

var
  EinstellungenDlg: TEinstellungenDlg;

implementation

{$R *.dfm}

procedure TEinstellungenDlg.FormCreate(Sender: TObject);
begin
  RueckseiteImage.Picture.Graphic := GetImageFromResource(1, iGIF);
end;

procedure TEinstellungenDlg.RueckseiteCBChange(Sender: TObject);
begin
  RueckseiteImage.Picture.Graphic := GetImageFromResource(RueckseiteCB.ItemIndex + 1, iGIF);
end;

function TEinstellungenDlg.GetBackSideImage: TGraphic;
begin
  Result := GetImageFromResource(RueckseiteCB.ItemIndex + 1, iGIF);
end;

end.
