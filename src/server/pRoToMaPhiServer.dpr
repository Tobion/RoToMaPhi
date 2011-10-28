program pRoToMaPhiServer;





uses
  Forms,
  uRoToMaPhiServer in 'uRoToMaPhiServer.pas' {RoToMaPhiServerForm},
  uZiehstapel in '..\universal\uZiehstapel.pas',
  uAblagestapel in '..\universal\uAblagestapel.pas',
  uKarte in '..\universal\uKarte.pas',
  uSpielregeln in '..\universal\uSpielregeln.pas',
  uGlobalTypes in '..\universal\uGlobalTypes.pas',
  uSpieler in '..\universal\uSpieler.pas',
  uVerwaltung in 'uVerwaltung.pas',
  uKI in 'uKI.pas',
  SQLite3 in 'SQLite3.pas',
  SQLiteTable3 in 'SQLiteTable3.pas',
  uResourceAccess in '..\universal\uResourceAccess.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'RoToMaPhi Server';
  Application.CreateForm(TRoToMaPhiServerForm, RoToMaPhiServerForm);
  Application.Run;
end.
