unit uVerwaltung;

interface

uses
  Classes, SysUtils, ExtCtrls, Controls, Forms, Graphics, ScktComp, ComCtrls,
  uSpieler, uKarte, uZiehstapel, uAblagestapel, uSpielregeln, uGlobalTypes;

type
  TVerwaltung = class(TObject)
  private
    Ziehstapel: TZiehstapel;
    Ablagestapel: TAblagestapel;
    Spielregeln: TSpielregeln;
    WhoseTurn: TSpieler;
  public
    SpielerListe: TList;
    GameStarted: Boolean;
    Differenz: Integer;
    constructor Create;
    destructor Destroy; override;
    procedure Reset(SpielerLoeschen: Boolean);
    function NewSpieler(const InitSpieler: TInitSpieler): TSpieler;
    procedure DeleteSpieler(const Spieler: TSpieler);
    function SpielerOnline: Integer;
    function GetSpieler(const SpielerID: Longword): TSpieler;
    procedure KarteErzeugen(const InitKarten: TInitKarten);
    procedure KarteZiehen(const Spieler: TSpieler; Strafe: Boolean = false);
    procedure KarteAufdecken;
    procedure ClearStapel;
    procedure KarteAblegen(const Spieler: TSpieler; const KartenID: Longword);
    function LegenMoeglich(const Spieler: TSpieler; const KartenID: Longword): Boolean;
    procedure ShowSpieler(ListView: TListView);
    procedure ShowAblagestapel(Image: TImage);
    function GetAblagestapelKartenAnzahl: Integer;
    function GetZiehstapelKartenAnzahl: Integer;
    procedure InitGame;
    procedure SetTurn(const Spieler: TSpieler);
    function MyTurn(const Spieler: TSpieler): Boolean;
    procedure SetWunschFarbe(const Spieler: TSpieler; const WunschFarbe: TFarben);
    function GetWunschFarbe: TFarben;
    procedure SetSperre(const Sperre: Byte);
    function GetSperre: Byte;
    function GetSperrIndex: Byte;
    function GetZiehkartenAnzahl: Integer;
    procedure KartenTauschen(const Spieler1, Spieler2: TSpieler);
    procedure Spionage(const SpielerFrom, SpielerTo: TSpieler; SpioKartenID: Longword);
    procedure ZiehkartenAnzahlDefinieren(const Differenz: integer);
    procedure KartenHalbieren(AMessageBuffer: TStream; const Spieler: TSpieler);
  end;

implementation

constructor TVerwaltung.Create;
begin
  inherited Create;
  SpielerListe := TList.Create;
  Ziehstapel := TZiehstapel.Create;
  Ablagestapel := TAblagestapel.Create;
  Spielregeln := TSpielregeln.Create;
  Randomize;
  GameStarted := false;
  WhoseTurn := nil;
end;

destructor TVerwaltung.Destroy;
begin
  Reset(true);
  SpielerListe.Free;
  Ziehstapel.Free;
  Ablagestapel.Free;
  Spielregeln.Free;
  inherited Destroy;
end;

procedure TVerwaltung.Reset(SpielerLoeschen: Boolean);
var i: Integer;
begin
  GameStarted := false;
  WhoseTurn := nil;
  Ziehstapel.Clear;
  Ablagestapel.Clear;
  Spielregeln.Reset;
  for i:=SpielerListe.Count-1 downto 0 do
    begin
    if not SpielerLoeschen then
      begin
      TSpieler(SpielerListe.Items[i]).KartenListe.Clear;
      TSpieler(SpielerListe.Items[i]).Ready := false;
      end
      else
        begin
        TSpieler(SpielerListe.Items[i]).Free;
        SpielerListe.Delete(i);
        end;
    end;
end;

function TVerwaltung.NewSpieler(const InitSpieler: TInitSpieler): TSpieler;
begin
  Result := TSpieler.Create(InitSpieler.SpielerID, InitSpieler.Name);
  SpielerListe.Add(Result);
end;

procedure TVerwaltung.DeleteSpieler(const Spieler: TSpieler);
var TmpKarte: TKarte;
begin
if Assigned(Spieler) then
  begin
  TmpKarte := Ablagestapel.PopKarte;
  while Spieler.KartenListe.Count > 0 do
    Ablagestapel.PushKarte(Spieler.KarteAblegen(TKarte(Spieler.KartenListe.Items[0])));
  Ablagestapel.PushKarte(TmpKarte);
  SpielerListe.Delete(SpielerListe.IndexOf(Spieler));
  Spieler.Free;
  end;
end;

function TVerwaltung.SpielerOnline: Integer;
begin
  Result := SpielerListe.Count;
end;

function TVerwaltung.GetSpieler(const SpielerID: Longword): TSpieler;
var i: Integer;
begin
Result := nil;
for i:=0 to SpielerListe.Count-1 do
  begin
  if (TSpieler(SpielerListe.Items[i]).ID = SpielerID) then
    begin
    Result := TSpieler(SpielerListe.Items[i]);
    Break;
    end;
  end;
end;

procedure TVerwaltung.KarteErzeugen(const InitKarten: TInitKarten);
var Karte: TKarte;
begin
  Karte := TKarte.Create(InitKarten);
  Ziehstapel.PushKarte(Karte);
end;

procedure TVerwaltung.KarteAufdecken;
begin
  Ablagestapel.PushKarte(Ziehstapel.PopKarte);
end;

procedure TVerwaltung.ClearStapel;
begin
  Ziehstapel.Clear;
  Ablagestapel.Clear;
end;

procedure TVerwaltung.KarteZiehen(const Spieler: TSpieler; Strafe: Boolean = false);
var i: Integer;
begin
if (GetZiehstapelKartenAnzahl < GetZiehkartenAnzahl) then
  Differenz := GetZiehkartenAnzahl - GetZiehstapelKartenAnzahl
  else Differenz := 0;
with Spielregeln.Spielzustand do
begin
if (Ziehkarten > 0) and not Strafe then // Ziehkarten durch Söldner etc.
  begin
  for i:=1 to Ziehkarten do
    Spieler.KarteAufnehmen(Ziehstapel.PopKarte);
  Spielregeln.ZiehkartenAufheben;
  end
  else if Strafe then // Strafe durch Verstoß gegen Tribunal
    begin
    for i:=1 to Strafkarten do
      Spieler.KarteAufnehmen(Ziehstapel.PopKarte);
    Spielregeln.SperreAufheben;
    end
    else Spieler.KarteAufnehmen(Ziehstapel.PopKarte); // normal eine Karte ziehen
end;
end;

procedure TVerwaltung.KarteAblegen(const Spieler: TSpieler; const KartenID: Longword);
var Karte: TKarte;
begin
  Karte := Spieler.KarteAblegen(KartenID);
  Ablagestapel.PushKarte(Karte);

  if Spielregeln.Sperrpruefung(Karte) then
    KarteZiehen(Spieler, true);
  Spielregeln.Ziehkarten(Karte);
  Spielregeln.WunschfarbeAufheben;
end;

function TVerwaltung.LegenMoeglich(const Spieler: TSpieler; const KartenID: Longword): Boolean;
begin
  Result := Spielregeln.LegenMoeglich(Ablagestapel.PeekKarte, Spieler.GetKarte(KartenID));
end;

procedure TVerwaltung.ShowSpieler(ListView: TListView);
var ListItem: TListItem;
    i: Integer;
begin
ListView.Clear;
for i:=0 to SpielerListe.Count-1 do
  begin
  ListItem := ListView.Items.Add;
  ListItem.Data := TSpieler(SpielerListe.Items[i]);
  ListItem.Caption := TSpieler(SpielerListe.Items[i]).Name;
  if not GameStarted and TSpieler(SpielerListe.Items[i]).Ready then
    ListItem.Caption := ListItem.Caption + ' (Ready)'
  else if (TSpieler(SpielerListe.Items[i]) = WhoseTurn) then
    ListItem.Caption := ListItem.Caption + ' (Am Zug)';
  ListItem.SubItems.Add(IntToStr(TSpieler(SpielerListe.Items[i]).CountKarten));
  end;
end;

procedure TVerwaltung.ShowAblagestapel(Image: TImage);
var graphic: TGraphic;
    Karte: TKarte;
begin
  Karte := TKarte(Ablagestapel.PeekKarte);
  if Assigned(Karte) then
    begin
    graphic := Karte.GetImage;
    try
      Image.Picture.Graphic := graphic;
      Image.Hint := 'Ablagestapel'+#10+'Oberste Karte: '+Karte.GetName;
    finally
      graphic.Free;
    end;
    end
    else
      begin
      Image.Hint := '';
      Image.Picture := nil;
      end;
end;

function TVerwaltung.GetAblagestapelKartenAnzahl: Integer;
begin
  Result := Ablagestapel.CountKarten;
end;

function TVerwaltung.GetZiehstapelKartenAnzahl: Integer;
begin
  Result := Ziehstapel.CountKarten;
end;

procedure TVerwaltung.InitGame;
var i, k: Integer;
begin
Ablagestapel.PushKarte(Ziehstapel.PopKarte);  // oberste Karte aufdecken
for i:=0 to SpielerListe.Count-1 do           // jeder Spieler
  begin
  for k:=0 to 9 do                            // zieht k Karten
    KarteZiehen(TSpieler(SpielerListe.Items[i]));
  end;
GameStarted := true;
end;

procedure TVerwaltung.SetTurn(const Spieler: TSpieler);
begin
  WhoseTurn := Spieler;
end;

function TVerwaltung.MyTurn(const Spieler: TSpieler): Boolean;
begin
  Result := Spieler = WhoseTurn;
end;

procedure TVerwaltung.SetWunschFarbe(const Spieler: TSpieler; const WunschFarbe: TFarben);
begin
  Spielregeln.Spielzustand.WunschFarbe := WunschFarbe;
  if Spielregeln.FarbSperrpruefung(WunschFarbe) then
    KarteZiehen(Spieler, true);
end;

function TVerwaltung.GetWunschFarbe: TFarben;
begin
  Result := Spielregeln.Spielzustand.WunschFarbe;
end;

procedure TVerwaltung.SetSperre(const Sperre: Byte);
begin
  Spielregeln.Sperren(Sperre);
end;

function TVerwaltung.GetSperre: Byte;
begin
  Result := Spielregeln.Spielzustand.Sperre;
end;

function TVerwaltung.GetSperrIndex: Byte;
begin
  Result := Spielregeln.Spielzustand.SperrIndex;
end;

function TVerwaltung.GetZiehkartenAnzahl: Integer;
begin
  Result := Spielregeln.Spielzustand.Ziehkarten;
end;

procedure TVerwaltung.KartenTauschen(const Spieler1, Spieler2: TSpieler);
var TmpListe: TList;
begin
  TmpListe := TList.Create;
  TmpListe.Assign(Spieler1.KartenListe);
  Spieler1.KartenListe.Assign(Spieler2.KartenListe);
  Spieler2.KartenListe.Assign(TmpListe);
  TmpListe.Free;
end;

procedure TVerwaltung.Spionage(const SpielerFrom, SpielerTo: TSpieler; SpioKartenID: Longword);
begin
  SpielerTo.KarteAufnehmen(SpielerFrom.KarteAblegen(SpioKartenID));
end;

procedure TVerwaltung.ZiehkartenAnzahlDefinieren(const Differenz: Integer);
begin
  Spielregeln.Spielzustand.Ziehkarten := Differenz;
end;

procedure TVerwaltung.KartenHalbieren(AMessageBuffer: TStream; const Spieler: TSpieler);
var KartenID: Longword;
    TmpKarte: TKarte;
    i: Integer;
begin
TmpKarte := Ablagestapel.PopKarte;
for i := 0 to Pred(AMessageBuffer.Size div SizeOf(KartenID)) do
  begin
  AMessageBuffer.ReadBuffer(KartenID, SizeOf(KartenID));
  Ablagestapel.PushKarte(Spieler.KarteAblegen(KartenID));
  end;
Ablagestapel.PushKarte(TmpKarte);
end;

end.
