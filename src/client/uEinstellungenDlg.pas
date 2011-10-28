unit uEinstellungenDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

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
    function GetRueckseite: TBitmap;
  end;

implementation

{$R *.dfm}

procedure TEinstellungenDlg.FormCreate(Sender: TObject);
begin
  RueckseiteImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'Rueckseite'+ IntToStr(RueckseiteCB.ItemIndex));
end;

procedure TEinstellungenDlg.RueckseiteCBChange(Sender: TObject);
begin
  RueckseiteImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'Rueckseite'+ IntToStr(RueckseiteCB.ItemIndex));
end;

function TEinstellungenDlg.GetRueckseite: TBitmap;
begin
  Result := TBitmap.Create;
  Result.LoadFromResourceName(HInstance, 'Rueckseite'+ IntToStr(RueckseiteCB.ItemIndex));
end;



end.
