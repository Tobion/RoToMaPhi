program pRoToMaPhi;



{$R '..\universal\Karten.res' '..\universal\Karten.rc'}

uses
  Forms,
  uRoToMaPhi in 'uRoToMaPhi.pas' {RoToMaPhiForm},
  uEinloggenDlg in 'uEinloggenDlg.pas' {EinloggenDlg},
  uZiehstapel in '..\universal\uZiehstapel.pas',
  uAblagestapel in '..\universal\uAblagestapel.pas',
  uKarte in '..\universal\uKarte.pas',
  uGlobalTypes in '..\universal\uGlobalTypes.pas',
  uSpieler in '..\universal\uSpieler.pas',
  uWunschDlg in 'uWunschDlg.pas' {WunschDlg},
  uSpielregeln in '..\universal\uSpielregeln.pas',
  uVerwaltung in 'uVerwaltung.pas',
  uTauschDlg in 'uTauschDlg.pas' {TauschDlg},
  uSperrDlg in 'uSperrDlg.pas' {SperrDlg},
  uEinstellungenDlg in 'uEinstellungenDlg.pas' {EinstellungenDlg},
  uSpionageDlg in 'uSpionageDlg.pas' {SpionageDlg},
  uPlayerInfoDlg in 'uPlayerInfoDlg.pas' {PlayerInfoDlg},
  uUserPictureDlg in 'uUserPictureDlg.pas' {UserPictureDlg},
  uResourceAccess in '..\universal\uResourceAccess.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'RoToMaPhi';
  Application.CreateForm(TRoToMaPhiForm, RoToMaPhiForm);
  Application.Run;
end.
