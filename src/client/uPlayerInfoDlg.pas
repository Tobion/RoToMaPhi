unit uPlayerInfoDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TPlayerInfoDlg = class(TForm)
    UserImage: TImage;
    UsernameLabel: TLabel;
    StatsLabel: TLabel;
    LastLoginLabel: TLabel;
  private
    { Private-Deklarationen }
  public
    procedure SetUserName(Name: String);
    procedure SetImage(Img: TGraphic);
    procedure SetStats(Games: Integer; Wins: Integer);
    procedure SetLastLogin(DateTime: String);
  end;

var
  PlayerInfoDlg: TPlayerInfoDlg;

implementation

{$R *.dfm}

procedure TPlayerInfoDlg.SetUserName(Name: String);
begin
  UsernameLabel.Caption := Name;
end;

procedure TPlayerInfoDlg.SetImage(Img: TGraphic);
begin
  // picture is deleted when Img is nil
  UserImage.Picture.Assign(Img);
  Self.Width := 100 // makes sure AutoSize will take effect
end;

procedure TPlayerInfoDlg.SetStats(Games: Integer; Wins: Integer);
begin
  StatsLabel.Caption := Format('%u Spiele (%u Siege)', [Games, Wins]);
end;

procedure TPlayerInfoDlg.SetLastLogin(DateTime: String);
begin
  LastLoginLabel.Caption := Format('Letzter Login: %s', [DateTime]);
end;

end.
