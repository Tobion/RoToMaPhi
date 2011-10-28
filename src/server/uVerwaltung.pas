unit uVerwaltung;

interface

uses
  Classes, SysUtils, ExtCtrls, Graphics, ScktComp, ComCtrls,
  uSpieler, uKarte, uZiehstapel, uAblagestapel, uSpielregeln, uGlobalTypes;

type
  TVerwaltung = class(TObject)
  private
    Ziehstapel: TZiehstapel;
    Ablagestapel: TAblagestapel;
    Spielregeln: TSpielregeln;
    WhoseTurn: TSpieler;
    Aussetzen: Boolean;
    RestKarten: Byte;
  public
    SpielerListe: TList;
    GameStarted: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Reset(SpielerLoeschen: Boolean);
    function NewSpieler(ASocket: TCustomWinSocket): TSpieler;
    function NewKI: TSpieler;
    function KISpielzug(const AKI: TSpieler): Longword;
    procedure KISpionage(const AKI: TSpieler; out IDSpielerFrom, IDSpielerTo, SpioKartenID: Longword);
    procedure DeleteSpieler(const Spieler: TSpieler);
    function SpielerOnline: Integer;
    function GetSpieler(const SpielerID: Longword): TSpieler; overload;
    function GetSpieler(ASocket: TCustomWinSocket): TSpieler; overload;
    function GetSpielerListeStream: TMemoryStream;
    procedure KarteErzeugen(const InitKarten: TInitKarten);
    procedure KarteZiehen(const Spieler: TSpieler; Strafe: Boolean = false);
    function KarteAblegen(const Spieler: TSpieler; const KartenID: Longword): Longword;
    function LegenMoeglich(const Spieler: TSpieler; const KartenID: Longword): Boolean;
    procedure ShowSpieler(ListView: TListView);
    function GetAblagestapelKartenAnzahl: Integer;
    function GetZiehstapelKartenAnzahl: Integer;
    procedure InitKarten;
    function MischeStapel: TMemoryStream;
    procedure InitGame;
    function AllReady: Boolean;
    procedure SetTurn(const Spieler: TSpieler);
    function NextPlayer(const VorigerSpieler: TSpieler = nil): TSpieler;
    function MyTurn(const Spieler: TSpieler): Boolean;
    function GetZiehkartenAnzahl: Integer;
    procedure SetWunschFarbe(const Spieler: TSpieler; const WunschFarbe: TFarben);
    procedure SetSperre(const Sperre: Byte);
    procedure KartenTauschen(const Spieler1, Spieler2: TSpieler);
    procedure Spionage(const SpielerFrom, SpielerTo: TSpieler; SpioKartenID: Longword);
    procedure ZiehkartenAnzahlDefinieren(const Differenz: Integer);
    function GetHalbeKartenStream(const Spieler: TSpieler): TMemoryStream;
    function GetWinner: TSpieler;
  end;

const
  KartenArray: array[0..99] of TInitKarten = (
    (ID: 1; Typ: 1; Farbe: Schwarz),
    (ID: 2; Typ: 1; Farbe: Schwarz),
    (ID: 3; Typ: 1; Farbe: Rot),
    (ID: 4; Typ: 1; Farbe: Rot),
    (ID: 5; Typ: 1; Farbe: Gruen),
    (ID: 6; Typ: 1; Farbe: Gruen),
    (ID: 7; Typ: 1; Farbe: Blau),
    (ID: 8; Typ: 1; Farbe: Blau),
    (ID: 9; Typ: 2; Farbe: Schwarz),
    (ID: 10; Typ: 2; Farbe: Schwarz),
    (ID: 11; Typ: 2; Farbe: Rot),
    (ID: 12; Typ: 2; Farbe: Rot),
    (ID: 13; Typ: 2; Farbe: Gruen),
    (ID: 14; Typ: 2; Farbe: Gruen),
    (ID: 15; Typ: 2; Farbe: Blau),
    (ID: 16; Typ: 2; Farbe: Blau),
    (ID: 17; Typ: 3; Farbe: Schwarz),
    (ID: 18; Typ: 3; Farbe: Schwarz),
    (ID: 19; Typ: 3; Farbe: Rot),
    (ID: 20; Typ: 3; Farbe: Rot),
    (ID: 21; Typ: 3; Farbe: Gruen),
    (ID: 22; Typ: 3; Farbe: Gruen),
    (ID: 23; Typ: 3; Farbe: Blau),
    (ID: 24; Typ: 3; Farbe: Blau),
    (ID: 25; Typ: 4; Farbe: Schwarz),
    (ID: 26; Typ: 4; Farbe: Schwarz),
    (ID: 27; Typ: 4; Farbe: Rot),
    (ID: 28; Typ: 4; Farbe: Rot),
    (ID: 29; Typ: 4; Farbe: Gruen),
    (ID: 30; Typ: 4; Farbe: Gruen),
    (ID: 31; Typ: 4; Farbe: Blau),
    (ID: 32; Typ: 4; Farbe: Blau),
    (ID: 33; Typ: 5; Farbe: Schwarz),
    (ID: 34; Typ: 5; Farbe: Schwarz),
    (ID: 35; Typ: 5; Farbe: Rot),
    (ID: 36; Typ: 5; Farbe: Rot),
    (ID: 37; Typ: 5; Farbe: Gruen),
    (ID: 38; Typ: 5; Farbe: Gruen),
    (ID: 39; Typ: 5; Farbe: Blau),
    (ID: 40; Typ: 5; Farbe: Blau),
    (ID: 41; Typ: 6; Farbe: Schwarz),
    (ID: 42; Typ: 6; Farbe: Schwarz),
    (ID: 43; Typ: 6; Farbe: Rot),
    (ID: 44; Typ: 6; Farbe: Rot),
    (ID: 45; Typ: 6; Farbe: Gruen),
    (ID: 46; Typ: 6; Farbe: Gruen),
    (ID: 47; Typ: 6; Farbe: Blau),
    (ID: 48; Typ: 6; Farbe: Blau),
    (ID: 49; Typ: 7; Farbe: Schwarz),
    (ID: 50; Typ: 7; Farbe: Schwarz),
    (ID: 51; Typ: 7; Farbe: Rot),
    (ID: 52; Typ: 7; Farbe: Rot),
    (ID: 53; Typ: 7; Farbe: Gruen),
    (ID: 54; Typ: 7; Farbe: Gruen),
    (ID: 55; Typ: 7; Farbe: Blau),
    (ID: 56; Typ: 7; Farbe: Blau),
    (ID: 57; Typ: 8; Farbe: Schwarz),
    (ID: 58; Typ: 8; Farbe: Schwarz),
    (ID: 59; Typ: 8; Farbe: Rot),
    (ID: 60; Typ: 8; Farbe: Rot),
    (ID: 61; Typ: 8; Farbe: Gruen),
    (ID: 62; Typ: 8; Farbe: Gruen),
    (ID: 63; Typ: 8; Farbe: Blau),
    (ID: 64; Typ: 8; Farbe: Blau),
    (ID: 65; Typ: 9; Farbe: Schwarz),
    (ID: 66; Typ: 9; Farbe: Schwarz),
    (ID: 67; Typ: 9; Farbe: Rot),
    (ID: 68; Typ: 9; Farbe: Rot),
    (ID: 69; Typ: 9; Farbe: Gruen),
    (ID: 70; Typ: 9; Farbe: Gruen),
    (ID: 71; Typ: 9; Farbe: Blau),
    (ID: 72; Typ: 9; Farbe: Blau),
    (ID: 73; Typ: 10; Farbe: Schwarz),
    (ID: 74; Typ: 10; Farbe: Schwarz),
    (ID: 75; Typ: 10; Farbe: Rot),
    (ID: 76; Typ: 10; Farbe: Rot),
    (ID: 77; Typ: 10; Farbe: Gruen),
    (ID: 78; Typ: 10; Farbe: Gruen),
    (ID: 79; Typ: 10; Farbe: Blau),
    (ID: 80; Typ: 10; Farbe: Blau),
    (ID: 81; Typ: 11; Farbe: Ohne),
    (ID: 82; Typ: 12; Farbe: Ohne),
    (ID: 83; Typ: 11; Farbe: Ohne),
    (ID: 84; Typ: 12; Farbe: Ohne),
    (ID: 85; Typ: 13; Farbe: Schwarz),
    (ID: 86; Typ: 13; Farbe: Schwarz),
    (ID: 87; Typ: 13; Farbe: Rot),
    (ID: 88; Typ: 13; Farbe: Rot),
    (ID: 89; Typ: 13; Farbe: Gruen),
    (ID: 90; Typ: 13; Farbe: Gruen),
    (ID: 91; Typ: 13; Farbe: Blau),
    (ID: 92; Typ: 13; Farbe: Blau),
    (ID: 93; Typ: 14; Farbe: Schwarz),
    (ID: 94; Typ: 14; Farbe: Schwarz),
    (ID: 95; Typ: 15; Farbe: Gruen),
    (ID: 96; Typ: 15; Farbe: Gruen),
    (ID: 97; Typ: 16; Farbe: Rot),
    (ID: 98; Typ: 16; Farbe: Rot),
    (ID: 99; Typ: 17; Farbe: Blau),
    (ID: 100; Typ: 17; Farbe: Blau){,

    (ID: 101; Typ: 14; Farbe: Schwarz),
    (ID: 102; Typ: 14; Farbe: Schwarz),
    (ID: 103; Typ: 14; Farbe: Schwarz),
    (ID: 104; Typ: 14; Farbe: Schwarz),
    (ID: 105; Typ: 14; Farbe: Schwarz),
    (ID: 106; Typ: 14; Farbe: Schwarz),
    (ID: 107; Typ: 14; Farbe: Schwarz) }
  );

implementation

uses
  uKI;

constructor TVerwaltung.Create;
begin
  inherited Create;
  SpielerListe := TList.Create;
  Ziehstapel := TZiehstapel.Create;
  Ablagestapel := TAblagestapel.Create;
  Spielregeln := TSpielregeln.Create;
  Randomize;
  Aussetzen := false;
  GameStarted := false;
  WhoseTurn := nil;
end;

destructor TVerwaltung.Destroy;
begin
  Reset(true);
  SpielerListe.Free;
  Ziehstapel.Free;
  Ablagestapel.Free;
  inherited Destroy;
end;

procedure TVerwaltung.Reset(SpielerLoeschen: Boolean);
var i: Integer;
begin
  Aussetzen := false;
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
      if not (TObject(SpielerListe.Items[i]) is TKI) then
        TSpieler(SpielerListe.Items[i]).Ready := false;
      end
      else
        begin
        TSpieler(SpielerListe.Items[i]).Free;
        SpielerListe.Delete(i);
        end;
    end;
end;

function TVerwaltung.NewSpieler(ASocket: TCustomWinSocket): TSpieler;
begin
  Result := TSpieler.Create(Random(High(Integer))+1, '', ASocket);
  SpielerListe.Add(Result);
end;

function TVerwaltung.NewKI: TSpieler;
var KI: TKI;
    AID: Longword;
begin
  AID := Random(High(Integer))+1;
  KI := TKI.Create(AID, 'KI '+IntToStr(AID), Self, SpielerListe, Spielregeln, Ziehstapel, Ablagestapel);
  KI.Ready := true;
  SpielerListe.Add(KI);
  Result := KI;
end;

function TVerwaltung.KISpielzug(const AKI: TSpieler): Longword;
// liefert 0 - Karte ziehen, sonst KartenID
var Karte: TKarte;
begin
  Karte := (AKI as TKI).Spielzug;
  if Assigned(Karte) then
    Result := Karte.GetID
  else
    begin
    Result := 0;
    KarteZiehen(AKI);
    end;
end;

procedure TVerwaltung.KISpionage(const AKI: TSpieler; out IDSpielerFrom, IDSpielerTo, SpioKartenID: Longword);
var Karte: TKarte;
    Opfer: TSpieler;
    Beguenstigter: TSpieler;
begin
  Opfer := (AKI as TKI).WenAusspionieren;
  IDSpielerFrom := Opfer.ID;
  Karte := Opfer.GetZufallsKarte;
  SpioKartenID := Karte.GetID;
  Beguenstigter := (AKI as TKI).WhoGetsSpionierteKarte(Karte);
  IDSpielerTo := Beguenstigter.ID;
  Spionage(Opfer, Beguenstigter, SpioKartenID);
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

function TVerwaltung.GetSpieler(ASocket: TCustomWinSocket): TSpieler;
var i: Integer;
begin
Result := nil;
for i:=0 to SpielerListe.Count-1 do
  begin
  if (TSpieler(SpielerListe.Items[i]).Socket = ASocket) then
    begin
    Result := TSpieler(SpielerListe.Items[i]);
    Break;
    end;
  end;
end;

function TVerwaltung.GetSpielerListeStream: TMemoryStream;
var InitSpieler: TInitSpieler;
    i: Integer;
begin
  Result := TMemoryStream.Create;
  for i:=0 to SpielerListe.Count-1 do
    begin
    InitSpieler.Name := TSpieler(SpielerListe.Items[i]).Name;
    InitSpieler.SpielerID := TSpieler(SpielerListe.Items[i]).ID;
    Result.WriteBuffer(InitSpieler, SizeOf(InitSpieler));
    end;
end;

procedure TVerwaltung.KarteErzeugen(const InitKarten: TInitKarten);
var Karte: TKarte;
begin
  Karte := TKarte.Create(InitKarten);
  Ziehstapel.PushKarte(Karte);
end;

procedure TVerwaltung.KarteZiehen(const Spieler: TSpieler; Strafe: Boolean = false);
var i: Integer;
begin
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
RestKarten:=Spieler.CountKarten;
end;

function TVerwaltung.KarteAblegen(const Spieler: TSpieler; const KartenID: Longword): Longword;
// liefer MsgID <> 0, falls gelegte Karte eine Sonderfunktion hat
var Karte: TKarte;
begin
  Result := 0;
  Karte := Spieler.KarteAblegen(KartenID);
  Ablagestapel.PushKarte(Karte);

  if Spielregeln.Sperrpruefung(Karte) then
    KarteZiehen(Spieler, true);
  Spielregeln.Ziehkarten(Karte);
  Spielregeln.WunschfarbeAufheben;

  case Karte.GetTyp of
    7: Result := Msg_Server_FarbWunsch;
    10: begin
        if (Spielregeln.Spielzustand.Ziehkarten = 0) then
          Aussetzen := true;
        end;
    11: Result := Msg_Server_FarbWunsch;
    12: Result := Msg_Server_KartenHalbieren;
    14: Result := Msg_Server_Spionage;
    15: begin
        Result := Msg_Server_Tauschen;
        end;
    17: Result := Msg_Server_Sperren;
    else begin
         RestKarten:=Spieler.CountKarten;
         end;
    end;

  RestKarten := Spieler.CountKarten;
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
  ListItem.Caption := TSpieler(SpielerListe.Items[i]).Name;
  if not GameStarted and TSpieler(SpielerListe.Items[i]).Ready then
    ListItem.Caption := ListItem.Caption + ' (Ready)'
  else if (TSpieler(SpielerListe.Items[i]) = WhoseTurn) then
    ListItem.Caption := ListItem.Caption + ' (Am Zug)';
  ListItem.SubItems.Add(IntToStr(TSpieler(SpielerListe.Items[i]).CountKarten));
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

procedure TVerwaltung.InitKarten;
var i: Integer;
begin
for i:=Low(KartenArray) to High(KartenArray) do
  begin
  KarteErzeugen(KartenArray[i]);
  end;
end;

function TVerwaltung.MischeStapel: TMemoryStream;
// transferiert alle Karten, bis auf die oberste, aus dem Ablagestapel in den
// Ziehstapel und mischt sie dort
// gibt die Karten als Stream zurück
var i: Integer;
    AblageObersteKarte: TKarte;
    TempKarte: TKarte;
    TempListe: TList;
    InitKarten: TInitKarten;
begin
  Result := TMemoryStream.Create;
  Result.Position := 0;
  AblageObersteKarte := Ablagestapel.PopKarte;
  TempListe := TList.Create;
  for i:=0 to Ablagestapel.CountKarten-1 do
    TempListe.Add(Ablagestapel.PopKarte);
  for i:=0 to Ziehstapel.CountKarten-1 do
    TempListe.Add(Ziehstapel.PopKarte);
  for i:=TempListe.Count-1 downto 0 do
    begin
    TempKarte := TKarte(TempListe.Extract(TempListe.Items[Random(i+1)]));
    InitKarten.ID := TempKarte.GetID;
    InitKarten.Typ := TempKarte.GetTyp;
    InitKarten.Farbe := TempKarte.GetFarbe;
    Ziehstapel.PushKarte(TempKarte);
    Result.WriteBuffer(InitKarten, SizeOf(InitKarten));
    end;
  if Assigned(AblageObersteKarte) then
    begin
    InitKarten.ID := AblageObersteKarte.GetID;
    InitKarten.Typ := AblageObersteKarte.GetTyp;
    InitKarten.Farbe := AblageObersteKarte.GetFarbe;
    Ablagestapel.PushKarte(AblageObersteKarte);
    Result.WriteBuffer(InitKarten, SizeOf(InitKarten));
    end;
  TempListe.Free;
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

function TVerwaltung.AllReady: Boolean;
var i: Integer;
begin
Result := false;
for i:=0 to SpielerListe.Count-1 do
  begin
  if TSpieler(SpielerListe.Items[i]).Ready then
    Result := true
    else
      begin
      Result := false;
      Break;
      end;
  end;
end;

procedure TVerwaltung.SetTurn(const Spieler: TSpieler);
begin
  WhoseTurn := Spieler;
end;

function TVerwaltung.NextPlayer(const VorigerSpieler: TSpieler = nil): TSpieler;
var i: Integer;
begin
Result := nil;
if (SpielerListe.Count > 0) then
begin
if (VorigerSpieler = nil) then
  Result := TSpieler(SpielerListe.Items[0])
else
  begin
  if (Aussetzen = false) then
    i := SpielerListe.IndexOf(VorigerSpieler) + 1
  else
    begin
    i := SpielerListe.IndexOf(VorigerSpieler) + 2;
    if (i = SpielerListe.Count) then i := 0
    else if (i > SpielerListe.Count) then i := 1;
    Aussetzen := false;
    end;
  if (i >= SpielerListe.Count) then i := 0;
  Result := TSpieler(SpielerListe.Items[i]);
  end;
end;
SetTurn(Result);
end;

function TVerwaltung.MyTurn(const Spieler: TSpieler): Boolean;
begin
  Result := Spieler = WhoseTurn;
end;

function TVerwaltung.GetZiehkartenAnzahl: Integer;
begin
  Result := Spielregeln.Spielzustand.Ziehkarten;
end;

procedure TVerwaltung.SetWunschFarbe(const Spieler: TSpieler; const WunschFarbe: TFarben);
begin
  Spielregeln.Spielzustand.WunschFarbe := WunschFarbe;
  if Spielregeln.FarbSperrpruefung(WunschFarbe) then
    KarteZiehen(Spieler, true);
end;

procedure TVerwaltung.SetSperre(const Sperre: Byte);
begin
  Spielregeln.Sperren(Sperre);
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

function TVerwaltung.GetHalbeKartenStream(const Spieler: TSpieler): TMemoryStream;
var KartenID: Longword;
    Karte, TmpKarte: TKarte;
    i, x: Integer;
begin
  Result := TMemoryStream.Create;
  TmpKarte := Ablagestapel.PopKarte;
  x := Spieler.KartenListe.Count div 2;
  for i:=1 to x do
    begin
    Karte := Spieler.GetZufallsKarte;
    Ablagestapel.PushKarte(Spieler.KarteAblegen(Karte));
    KartenID := Karte.GetID;
    Result.WriteBuffer(KartenID, SizeOf(KartenID));
    end;
  Ablagestapel.PushKarte(TmpKarte);
end;

function TVerwaltung.GetWinner: TSpieler;
var i: Integer;
begin
Result := nil;
if (SpielerListe.Count > 1) then
  begin
  for i:=0 to SpielerListe.Count-1 do
    begin
    if (TSpieler(SpielerListe.Items[i]).CountKarten = 0) then
      begin
      Result := TSpieler(SpielerListe.Items[i]);
      Break;
      end;
    end;
  end
  else if (SpielerListe.Count = 1) then
    Result := TSpieler(SpielerListe.Items[0]);
end;

end.
