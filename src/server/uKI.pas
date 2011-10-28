unit uKI;

interface

uses
  Classes, uKarte, uSpieler, uSpielregeln, uGlobalTypes,
  uVerwaltung, uProtokoll, uZiehstapel, uAblagestapel;

type
  TKI = class(TSpieler)
  private
    Wunschfarbe: TFarben;
    Spielregeln: TSpielregeln;
    Verwaltung: TVerwaltung;
    Ablagestapel: TAblagestapel;
    Ziehstapel: TZiehstapel;
    Protokoll: TProtokoll;
    Spielerliste: TList;
    LegbareKarten: TList;
    BesteKartenListe: TList;
    function LegbareKartenVorhanden(OKarte: TKarte): boolean; // Gibt wieder, ob legbare Karten vorhanden sind und erstellt eine Liste mit Karten, die gelegt werden können
    function Verteidigung(OKarte: TKarte): TKarte;
    function NormalerZug(OKarte: TKarte): TKarte;
    function NormalZug(OKarte: TKarte): TKarte;
    function GetNachfolgerKartenzahl: Integer;
    function MinimumKartenZahl: Integer;
    function MaximumKartenZahl: Integer;
    function GetFarbIndex(Karte: TKarte): Integer;
    function Anzahl(Typ: Byte): Integer;
    function Lege(Typ: Byte; Anzahl: Integer; Sperrfarbe: Boolean=true): TKarte;
    function LegeOhneFkt(OKarte: TKarte): TKarte;

    function Vergleich(a,b,c,d,e,f,g: integer): Integer;
    function Vergleiche(a,b: integer): Integer;

    function FarbanzahlGross(AFarbe: TFarben): Boolean;       // Überprüft, ob die Kartenzahl von der Farbe OFarbe am größten ist
    function Farbanzahl(AFarbe: TFarben): Integer;            // Übergibt die Kartenzahl der Farbe AFarbe


    function VerteidigungVorhanden: Boolean;                  // Überprüft, ob Söldner, Ritter, Diplomaten oder Mauern vorhanden sind
    procedure Farbvergleich(const F1,F2,F3: TFarben);         // Vergleicht die Kartenzahlen von zwei oder drei Farben miteinander
    function GetSperrFarbe(Index:Integer): TFarben;           // Rechnet einen Index in eine Farbe um und gibt diese aus
    function BesteFarbeSuchen(OKarte: TKarte): TFarben;       // Gibt die Beste Farbe aus
    function BesteVerteidigung(OKarte: TKarte): TFarben;      // Sucht die beste Farbe aus, für den Fall, dass man sich im nächsten zug verteidigen muss
    function VergleicheAnzahlen(s,r,g,b:integer; OKArte:TKarte): TFarben;       // vergleicht die Kartenzahlen der verschiedenen Farben und gibt die Farbe, die am meisten vorhanden ist aus


    function OKarteTypDa(OKarte: TKarte): boolean;            // Gibt an, ob sich eine Karte vom Typ der obersten Karte auf dem Ablagestapel in der Kartenliste befindet
    function FunktionskartenDa:boolean;                       // Gibt an, ob Karten mit Funktion in der Kartenliste vorhanden sind


    function Vorgaenger: TSpieler;


  public
    constructor Create(const AID: Longword; const AName: String; AVerwaltung: TVerwaltung;
      ASpielerliste: TList; ASpielregeln: TSpielregeln; AZiehstapel: TZiehstapel;
      AAblagestapel: TAblagestapel; AProtokoll: TProtokoll);
    destructor Destroy; override;
    function Spielzug: TKarte;                 // Simuliert den Spielzug der KI und gibt die zu legende Karte aus
    function GetWunschfarbe: TFarben;       // WÜNSCHEN (Sonderfunktion)
    //function ExilPlayer(Spielerzahl:Integer): Longword;     // SPIELER FÜR EXIL AUSSUCHEN (Sonderfunktion)
    procedure Herrschaftswechsel(out Spieler1: TSpieler; out Spieler2: TSpieler);
    //function HerrschaftVerwechseln: TSpielerbox; // HERRSCHAFTSWECHSEL (Sonderfunktion)
    function WenAusspionieren: TSpieler;                                  // SPIONAGE (Sonderfunktion)
    function WhoGetsSpionierteKarte(SpionierteKarte: TKarte): TSpieler;
    function Sperren: Byte;                             // SPERREN (Sonderfunktion)
  end;


var
    KI : TKI;
     // Mauerliste: TList;
    // BesteKarte,Verteidigungskarte,Mauer: TKarte;

implementation

constructor TKI.Create(const AID: Longword; const AName: String; AVerwaltung: TVerwaltung;
  ASpielerliste: TList; ASpielregeln: TSpielregeln; AZiehstapel: TZiehstapel;
  AAblagestapel: TAblagestapel; AProtokoll: TProtokoll);
begin
  inherited create(AID,AName);
  LegbareKarten := TList.create;
  BesteKartenListe := TList.create;
  Verwaltung := AVerwaltung;
  Spielerliste := ASpielerliste;
  Spielregeln := ASpielregeln;
  Ziehstapel := AZiehstapel;
  Ablagestapel := AAblagestapel;
  Protokoll := AProtokoll;
end;

destructor TKI.Destroy;
begin
  LegbareKarten.Clear;
  LegbareKarten.Free;
  BesteKartenListe.Clear;
  BesteKartenListe.Free;
  inherited Destroy;
end;

function TKI.Spielzug: TKarte;
var OKarte: TKarte;
begin
  OKarte := Ablagestapel.PeekKarte;
  Result := nil;
 {1}  if LegbareKartenVorhanden(OKarte)=true then
   {2}  if Spielregeln.Spielzustand.Ziehkarten <> 0 then
     {3}  Result:=Verteidigung(OKarte)
        else
     {4}  Result:=NormalerZug(OKarte);
   {  Result:=TKarte(LegbareKarten.Items[Random(LegbareKarten.Count)])  }
      while LegbareKarten.Count>0 do
        LegbareKarten.Delete(0);
end;

function TKI.LegbareKartenVorhanden(OKarte: TKarte): boolean;
var i: integer;
begin
      Result:=false;
      for i:= 0 to Kartenliste.Count-1 do
      begin
          if Spielregeln.LegenMoeglich(OKarte,TKarte(Kartenliste.Items[i]))=true then
          begin
            LegbareKarten.Add(TKarte(Kartenliste.Items[i]));
            Result:= true;
          end;
      end;
end;

function TKI.Verteidigung(OKarte: TKarte): TKarte;
var i:integer;
begin
      Result:=nil;
      i:=0;
  {3b}If GetNachfolgerKartenzahl < 5  then
      begin
        If (Anzahl(8)<>0) and (Spielregeln.Spielzustand.Sperre<>8) then   // Söldner
        begin
          Result:=Lege(8,Anzahl(8));
          i:=8;
        end
        else
          if (Anzahl(9)<>0) and (Spielregeln.Spielzustand.Sperre<>9) then    // Ritter
          begin
            Result:=Lege(9,Anzahl(9));
            i:=9;
          end
          else
            if (Anzahl(10)<>0) and (Spielregeln.Spielzustand.Sperre<>10) then   // Diplomat
            begin
              Result:=Lege(10,Anzahl(10));
              i:=10;
            end
            else
              if (Anzahl(11)<>0) and (Spielregeln.Spielzustand.Sperre<>11) then   // Schwarzer Magier
                Result:=Lege(11,Anzahl(11))
              else
                if (Anzahl(13)<>0) and (Spielregeln.Spielzustand.Sperre<>13) then   // Mauer
                  Result:=Lege(13,Anzahl(13));
      end
      else
  {3d}Case OKarte.GetTyp of
      8:begin
          If Anzahl(8)<>0 then    // Söldner
            Result:=Lege(8,Anzahl(8))
          else
            if (Anzahl(10)<>0) and (Spielregeln.Spielzustand.Sperre<>10) then    // Diplomat
              Result:=Lege(10,Anzahl(10))
            else
              if (Anzahl(13)<>0) and (Spielregeln.Spielzustand.Sperre<>13) then   // Mauer
                Result:=Lege(13,Anzahl(13))
              else
                if (Anzahl(9)<>0) and (Spielregeln.Spielzustand.Sperre<>9) then   // Ritter
                  Result:=Lege(9,Anzahl(9))
                else
                  if (Anzahl(11)<>0) and (Spielregeln.Spielzustand.Sperre<>11) then   // Schwarzer Magier
                  begin
                    Result:=Lege(11,Anzahl(11));
                    i:=9;
                  end;
        end;
      9:begin
          If (Anzahl(10)<>0) and (Spielregeln.Spielzustand.Sperre<>10) then    // Diplomat
          begin
            Result:=Lege(10,Anzahl(10));
            i:=10;
          end
          else
            if Anzahl(9)<>0 then    // Ritter
            begin
              Result:=Lege(9,Anzahl(9));
              i:=9;
            end
            else
              if (Anzahl(8)<>0) and (Spielregeln.Spielzustand.Sperre<>9) then   // Söldner
              begin
                Result:=Lege(8,Anzahl(8));
                i:=8;
              end
              else
                if (Anzahl(13)<>0) and (Spielregeln.Spielzustand.Sperre<>13) then   // Mauer
                begin
                  Result:=Lege(13,Anzahl(13));
                  i:=13;
                end
                else
                  if (Anzahl(11)<>0) and (Spielregeln.Spielzustand.Sperre<>11) then   // Schwarzer Magier
                  begin
                    Result:=Lege(11,Anzahl(11));
                    i:=9;
                  end
        end;
     11:begin
         If (Anzahl(13)<>0) and (Spielregeln.Spielzustand.Sperre<>13) then    // Mauer
         begin
           Result:=Lege(13,Anzahl(13));
           i:=13;
         end
         else
           if (Anzahl(10)<>0) and (Spielregeln.Spielzustand.Sperre<>10) then    // Diplomat
           begin
             Result:=Lege(10,Anzahl(10));
             i:=10;
           end
           else
             if (Anzahl(8)<>0) and (Spielregeln.Spielzustand.Sperre<>8) then   // Söldner
             begin
               Result:=Lege(8,Anzahl(8));
               i:=8;
             end
             else
               if (Anzahl(9)<>0) and (Spielregeln.Spielzustand.Sperre<>9) then   // Ritter
               begin
                 Result:=Lege(9,Anzahl(9));
                 i:=9;
               end
               else
                 if Anzahl(11)<>0 then   // Schwarzer Magier
                 begin
                   Result:=Lege(11,Anzahl(11));
                    i:=11;
                 end
        end;
     10:begin
          If Anzahl(10)<>0 then    // Diplomat
          begin
            Result:=Lege(10,Anzahl(10));
            i:=10;
          end
          else
            if (Anzahl(8)<>0) and (Spielregeln.Spielzustand.Sperre<>8) then    // Söldner
            begin
              Result:=Lege(8,Anzahl(8));
              i:=8;
            end
            else
              if (Anzahl(13)<>0) and (Spielregeln.Spielzustand.Sperre<>13) then   // Mauer
              begin
                Result:=Lege(13,Anzahl(13));
                i:=13;
              end
              else
                if (Anzahl(9)<>0) and (Spielregeln.Spielzustand.Sperre<>9) then   // Ritter
                begin
                  Result:=Lege(9,Anzahl(9));
                  i:=9;
                end
                else
                  if (Anzahl(11)<>0) and (Spielregeln.Spielzustand.Sperre<>11) then   // Schwarzer Magier
                  begin
                    Result:=Lege(11,Anzahl(11));
                    i:=11;
                  end;
        end;
      end;
      if (Result= nil) and (i<>0) then
        Result:=Lege(i,Anzahl(i),false);
end;

function TKI.NormalerZug(OKarte: TKarte): TKarte;
var i: integer;
begin
    i:=0;
    Result := nil;
   Case OKarte.GetTyp of
   7,12,11: begin
          if (Farbanzahl(Spielregeln.Spielzustand.WunschFarbe)<3) or (Vorgaenger.CountKarten <4) then
           if (Anzahl(7)<>0) and (Spielregeln.Spielzustand.Sperre<>7) then   // Hellseher
           begin
             Result:=Lege(7,Anzahl(7));
             i:=7;
           end
           else
            if (Vorgaenger.CountKarten <2) and (Anzahl(12)<>0) and (Spielregeln.Spielzustand.Sperre<>12) then   // Weißer Magier
            begin
              Result:=Lege(12,Anzahl(12));
              i:=12;
            end
            else
            if (Anzahl(14)<>0) and (Spielregeln.Spielzustand.Sperre<>14) then   // Spionage
            begin
              Result:=Lege(14,Anzahl(14));
              i:=14;
            end
            else
              if (Anzahl(8)<>0) and (Spielregeln.Spielzustand.Sperre<>8) then   // Söldner
              begin
                Result:=Lege(8,Anzahl(8));
                i:=8;
              end
              else
                if (Anzahl(15)<>0) and (Spielregeln.Spielzustand.Sperre<>15) then   // Herrschaftswechsel
                begin
                  Result:=Lege(15,Anzahl(15));
                  i:=15;
                end
                else
                  if (Anzahl(9)<>0) and (Spielregeln.Spielzustand.Sperre<>9) then   // Ritter
                  begin
                    Result:=Lege(9,Anzahl(9));
                    i:=9;
                  end
                  else
                    Result:= Normalzug(OKarte);
          end;
1..6,
8..10,
13..17:   Result:= Normalzug(OKarte);
   end;
   if (Result=nil) and (i>0) then
     Result:=Lege(i,Anzahl(i),false);
end;

function TKI.NormalZug(OKarte: TKarte): TKarte;
var i:integer;
begin
      i:=0;
      Result := nil;
      If MinimumKartenZahl < 3  then
         begin
           if (Anzahl(8)<>0) and (Spielregeln.Spielzustand.Sperre<>8) then   // Söldner
           begin
             Result:=Lege(8,Anzahl(8));
             i:=8;
           end
           else
            if (Anzahl(9)<>0) and (Spielregeln.Spielzustand.Sperre<>9) then   // Ritter
            begin
              Result:=Lege(9,Anzahl(9));
              i:=9;
            end;
         end
         else
          if MinimumKartenZahl < 3 then
          begin
            if (Anzahl(14)<>0) and (Spielregeln.Spielzustand.Sperre<>14) then   // Spionage
            begin
              Result:=Lege(14,Anzahl(14));
              i:=14;
            end
            else
              if (Anzahl(15)<>0) and (Spielregeln.Spielzustand.Sperre<>15) then   // Herrschaftswechsel
              begin
                Result:=Lege(15,Anzahl(15));
                i:=15;
              end
              else
                if (Anzahl(7)<>0) and (Spielregeln.Spielzustand.Sperre<>7) then   // Hellseher
                begin
                  Result:=Lege(7,Anzahl(7));
                  i:=7;
                end;
          end
          else
            Result:=LegeOhneFkt(OKarte);
            if (Result= nil) then
              if (i>0) then
                Result:=Lege(7,Anzahl(7))
              else
                Result:= TKarte(LegbareKarten.Items[Random(LegbareKarten.Count)]);
end;

function TKI.GetNachfolgerKartenzahl: Integer;
begin
      If Spielerliste.IndexOf(Self)+1 = Spielerliste.Count then
        Result:=TSpieler(Spielerliste.Items[0]).CountKarten
      else
        Result:=TSpieler(Spielerliste.Items[Spielerliste.IndexOf(Self)+1]).CountKarten;
end;

function TKI.GetFarbIndex(Karte: TKarte): Integer;
begin
  case Karte.GetFarbe of
     Schwarz: Result:=0;
     Rot:     Result:=1;
     Gruen:   Result:=2;
     Blau:    Result:=3;
    else Result := 0;
  end;
end;

function TKI.Anzahl(Typ: Byte): integer;
var i: integer;
begin
    Result:= 0;
    for i:=0 to LegbareKarten.Count-1 do
        if TKarte(LegbareKarten.Items[i]).GetTyp=Typ then
          inc(Result);
end;

function TKI.Lege(Typ: Byte; Anzahl: Integer; Sperrfarbe: Boolean=true): TKarte;
var i: integer;
    Typliste: TList;
begin
  Result := nil;
      Typliste:= TList.Create;
      For i:=0 to LegbareKarten.Count-1 do
        if TKarte(LegbareKarten.Items[i]).GetTyp=Typ then
          if (Sperrfarbe=false) or (GetFarbIndex(TKarte(LegbareKarten.Items[i]))<>Spielregeln.Spielzustand.Sperre-196) then
            Typliste.Add(LegbareKarten.Items[i]);
      case Anzahl of
        1: Result:= TKarte(LegbareKarten.Items[0]);
        2..8: Result:= TKarte(Typliste.Items[Random(Typliste.Count)]);
      end;
  Typliste.Free;
end;

function TKI.Farbanzahl(AFarbe: TFarben): Integer;
var i:integer;
begin
     Result:=0;
     for i:=0 to Kartenliste.Count-1 do
     begin
          If TKarte(KartenListe.Items[i]).GetFarbe=AFarbe then
            inc(Result);
     end;
end;

function TKI.MinimumKartenZahl: Integer;
var i: integer;
begin
     Result:= maxint;
     for i:= 0 to Spielerliste.Count-1 do
        if TSpieler(Spielerliste.Items[i]).CountKarten< Result then
          Result:= TSpieler(Spielerliste.Items[i]).CountKarten;
end;

function TKI.MaximumKartenZahl: Integer;
var i: integer;
begin
     Result:= 0;
     for i:= 0 to Spielerliste.Count-1 do
        if TSpieler(Spielerliste.Items[i]).CountKarten > Result then
          Result:= TSpieler(Spielerliste.Items[i]).CountKarten;
end;

function TKI.LegeOhneFkt(OKarte: TKarte): TKarte;
var i,j,k: integer;
    sk,be,ba,ha,he,ad,ex: integer;

    OhneFktListe,Ruecklage,Auswahlliste, Auswahl2: TList;
begin
    Result:= nil;
    sk:=0; be:=0; ba:=0; ha:=0; he:=0; ad:=0; ex:=0;
     OhneFktListe:= TList.Create;
     Ruecklage:= TList.Create;
     Auswahlliste:= TList.Create;
     Auswahl2:= TList.Create;
      for i:=0 to LegbareKarten.count-1 do
     case TKarte(LegbareKarten.Items[i]).GetTyp of
     1..6,16: OhneFktListe.Add(TKarte(LegbareKarten.Items[i]));
     end;
     For i:=0 to OhneFktListe.Count-1 do
     begin
        if (Farbanzahlgross(TKarte(OhnefktListe.Items[i]).GetFarbe)=true) and (TKarte(OhnefktListe.Items[i]).GetTyp<>Spielregeln.Spielzustand.Sperre) and (GetFarbIndex(TKarte(OhnefktListe.Items[i]))<>Spielregeln.Spielzustand.Sperre-196) then
        begin
          case TKarte(OhnefktListe.Items[i]).GetTyp of
          1: inc(sk);
          2: inc(be);
          3: inc(ba);
          4: inc(ha);
          5: inc(he);
          6: inc(ad);
          16: inc(ex);
          end;
        end
        else
          Ruecklage.Add(TKarte(OhnefktListe.Items[i]));
     end;
     j:= Vergleich(sk,be,ba,ha,he,ad,ex);
     if j>0 then
     begin
     if j=7 then j:=16;
      if OhneFktListe.Count>0 then
      begin
     for k:=0 to OhneFktListe.Count-1 do
      if TKarte(OhneFktListe.Items[k]).GetTyp=j then
        Auswahlliste.Add(TKarte(OhneFktListe.Items[k]));
     if Auswahlliste.Count>0 then
      Result:= TKarte(Auswahlliste.Items[Random(Auswahlliste.Count)]);
     end;
     end;
     if Result = nil then
     begin
      sk:=0; be:=0; ba:=0; ha:=0; he:=0; ad:=0; ex:=0;
      For i:=0 to Ruecklage.Count-1 do
      begin
        if (TKarte(Ruecklage.Items[i]).GetTyp<>Spielregeln.Spielzustand.Sperre) and (GetFarbIndex(TKarte(Ruecklage.Items[i]))<>Spielregeln.Spielzustand.Sperre-196) then
        begin
          case TKarte(Ruecklage.Items[i]).GetTyp of
          1: inc(sk);
          2: inc(be);
          3: inc(ba);
          4: inc(ha);
          5: inc(he);
          6: inc(ad);
          16: inc(ex);
          end;
        end
        else
          Auswahlliste.Add(TKarte(OhnefktListe.Items[i]));
     end;
     j:=0;
     j:= Vergleich(sk,be,ba,ha,he,ad,ex);
     if j>0 then
     begin
      if j=7 then j:=16;
      if Ruecklage.Count>0 then
      begin
      for k:=0 to Ruecklage.Count-1 do
        if TKarte(Ruecklage.Items[k]).GetTyp=j then
          Auswahl2.Add(TKarte(Ruecklage.Items[k]));
      if Auswahl2.Count>0 then
      Result:= TKarte(Auswahl2.Items[Random(Auswahl2.Count)]);
      end;
     end;
     if Result= nil then
     begin
      sk:=0; be:=0; ba:=0; ha:=0; he:=0; ad:=0; ex:=0;
      For i:=0 to Auswahlliste.Count-1 do
      begin
        case TKarte(Auswahlliste.Items[i]).GetTyp of
          1: inc(sk);
          2: inc(be);
          3: inc(ba);
          4: inc(ha);
          5: inc(he);
          6: inc(ad);
          16: inc(ex);
        end;
     end;
     j:=0;
     j:= Vergleich(sk,be,ba,ha,he,ad,ex);
     if j>0 then
     begin
      if j=7 then j:=16;
      if Auswahlliste.Count>0 then
      begin
      for k:=0 to Auswahlliste.Count-1 do
        if TKarte(Auswahlliste.Items[k]).GetTyp=j then
          Auswahl2.Add(TKarte(Auswahlliste.Items[k]));
      if Auswahl2.Count>0 then
      Result:= TKarte(Auswahl2.Items[Random(Auswahl2.Count)]);
        end;
     end
     else
      if Result= nil then
        if OhneFktListe.Count>0 then
          Result:= TKarte(OhneFktListe.Items[OhneFktListe.Count]);
     end;
     end;
  OhneFktListe.Free;
  Ruecklage.Free;
  Auswahlliste.Free;
  Auswahl2.Free;
end;


{##############################################################################}
{                                                                              }
{                                                                              }
{                             Hilfsfunktionen                                  }
{                                                                              }
{                                                                              }
{##############################################################################}



function TKI.Vorgaenger: TSpieler;
var i: integer;
begin
  Result := nil;
      for i:= 0 to Spielerliste.Count-1 do
        if (TKI(Spielerliste.Items[i])=Self) and (i>0) then
          Result:=TSpieler(Spielerliste.Items[i-1])
        else
          Result:=TSpieler(Spielerliste.Items[Spielerliste.Count-1]);
end;

function TKI.FarbanzahlGross(AFarbe: TFarben): Boolean;
var fs,fr,fg,fb,fo,i: Integer;
begin   
     Result:=false;
     fs:=0;
     fr:=0;
     fg:=0;
     fb:=0;
     fo:=0;
     for i:= 0 to Kartenliste.count-1 do
     begin
          case TKarte(KartenListe.Items[i]).GetFarbe of
            Schwarz:  inc(fs);
            Rot:      inc(fr);
            Gruen:    inc(fg);
            Blau:     inc(fb);
            Ohne:     inc(fo);
          end;
     end;
     case AFarbe of
      Schwarz: if (fs>fr) and (fs>fg) and (fs>fb) then
                 Result:= true;
      Rot:     if (fr>fs) and (fr>fg) and (fr>fb) then
                 Result:= true;
      Gruen:   if (fg>fr) and (fg>fs) and (fg>fb) then
                 Result:= true;
      Blau:    if (fb>fr) and (fb>fg) and (fb>fs) then
                 Result:= true;
      end;
end;

function TKI.Vergleich(a,b,c,d,e,f,g: Integer): Integer;
var v,w: Array[1..7] of integer;
    h,i,j,k:integer;
    x: boolean;
begin
    for i:= 1 to 7 do
    w[i]:=0;
    if (a<>0) or (b<>0) or (c<>0) or (d<>0) or (e<>0) or (f<>0) or (g<>0) then
    begin
    v[1]:=a; v[2]:=b; v[3]:=c; v[4]:=d; v[5]:=e; v[6]:=f; v[7]:=g;
    for i:= 1 to 6 do
    for j:= 2 to 7 do
      case vergleiche(v[i],v[j]) of
      1: v[j]:= 0;
      2: v[i]:= 0;
      end;
      k:=2;
      x:=false;
      h:=0;
    for i:= 1 to 7 do
    if v[i]>0 then
      if h=0 then
        h:=i
      else
      begin
        w[1]:=h; w[k]:=i; inc(k); x:=true;
      end;
    if x=true then
    begin
    k:=0;
    for i:=1 to 7 do
     if w[i]>0 then
      inc(k);
    Result:= w[Random(k)+1];
    end else
    Result:=h;
    end
    else
    Result:=0;
end;

function TKI.Vergleiche(a,b: integer): integer;
begin
    if a>b then Result:=1 else if a<b then Result:=2 else Result:=0;
end;




{##############################################################################}
{                                                                              }
{                                                                              }
{                             Sonderfunktionen                                 }
{                                                                              }
{                                                                              }
{##############################################################################}



{procedure TKI.BesteKartenFinden;
var i,j,k,l: integer;
    Hilfsbox: TKartenBoxes;
begin
      while BesteKartenListe.Count > 0 do
      begin
        BesteKartenListe.Delete(0);
      end;
      for i := 0 to LegbareKarten.Count-1 do
      begin
          j:=0;
          while j < BesteKartenListe.Count do
          begin
            if TKartenboxes(LegbareKarten.Items[i]).Wert <= TKartenboxes(Bestekartenliste.Items[j]).Wert then
              inc(j)
              else
              break;
          end;
            BesteKartenListe.Insert(j,LegbareKarten.Items[i]);
      end;
      while LegbareKarten.Count > 0 do
      begin
        LegbareKarten.Delete(0);
      end;
      k:=1;
      Hilfsbox:= BesteKartenliste.Items[0];
      while k < BesteKartenliste.Count do
      begin
          If TKartenboxes(BesteKartenliste.Items[k]).Wert < Hilfsbox.Wert then
            BesteKartenliste.Delete(k);
          inc(k);
      end;
      l:=Random(BesteKartenListe.Count-1);
      Auswertung:=BesteKartenListe.Items[l];
      BesteKarte:= Auswertung.Karte;
end;}

function TKI.VerteidigungVorhanden: Boolean;
var i: integer;
begin
    Result:=false;
    for i:=0 to Kartenliste.count-1 do
      case TKarte(Kartenliste.Items[i]).GetTyp of
        8,9,10,13: Result:=true;
      end;
end;

function TKI.GetWunschfarbe: TFarben;
var Farbe: TFarben;
        k,i: integer;
        l: byte;
    OKarte: TKarte;
    Spielerzahl: Integer;
begin
  Result := Ohne;
  OKarte := Ablagestapel.PeekKarte;
  Spielerzahl := Spielerliste.Count;
  case OKarte.GetTyp of
  7,12: begin
        if (Kartenliste.Count=1) and (Spielerzahl > 3) then
          begin
          k := Random(2);
          case k of
            0: begin
               i:= Random(4)+196;
               if (i = Spielregeln.Spielzustand.Sperre) then
                Farbe:= GetSperrfarbe(i);
               i:=Random(3);
               case i of
                  0: if Farbe=Schwarz then Farbe:=Blau else Farbe:= Schwarz;
                  1: if Farbe=Rot     then Farbe:=Blau else Farbe:= Rot;
                  2: if Farbe=Gruen   then Farbe:=Blau else Farbe:= Gruen;
                end;
               end;
            1: begin
               Farbe:=BesteFarbeSuchen(OKarte);
               end;
            end;
          end;
        Result:= Farbe;
        end;
  11: begin
      if VerteidigungVorhanden = false then
        Result:=BesteFarbeSuchen(OKarte)
      else
        Result:=BesteVerteidigung(OKarte);
      end;
  end;
  if (Result <> Schwarz) and (Result <> Rot) and (Result <> Gruen) and (Result <> Blau) then
    Result := Schwarz;
end;

function TKI.GetSperrFarbe(Index: Integer): TFarben;
begin
     case Index of
      0: Result:= Schwarz;
      1: Result:= Rot;
      2: Result:= Gruen;
      3: Result:= Blau;
     end;
end;

function TKI.BesteVerteidigung(OKarte: TKarte): TFarben;
var s,r,g,b,i: integer;
begin
     for i:= 0 to Kartenliste.count-1 do
     begin
       case TKarte(Kartenliste.Items[i]).GetTyp of
        8,9,10,13:
            case TKarte(Kartenliste.Items[i]).GetFarbe of
              Schwarz:  inc(s);
              Rot    :  inc(r);
              Gruen  :  inc(g);
              Blau   :  inc(b);
            end;
      end;
     end;
     Result:= VergleicheAnzahlen(s,r,g,b,OKarte);
end;

function TKI.BesteFarbeSuchen(OKarte: TKarte): TFarben;
var s,r,g,b,o,i: integer;
    Karte: TKarte;
begin
     s:=0; r:=0; g:=0; b:=0; o:=0;
     for i:= 0 to Kartenliste.Count-1 do
     begin
        Karte:= Kartenliste.Items[i];
          case Karte.getFarbe of

            Schwarz: inc(s);
            Rot: inc(r);
            Gruen: inc(g);
            Blau: inc(b);
            Ohne: inc(o);
          end;
     end;
     if OKarte.GetFarbe= Schwarz then s:=0 else
       if OKarte.GetFarbe= Rot then r:=0 else
         if OKarte.GetFarbe= Gruen then g:=0 else
           if OKarte.GetFarbe= Blau then b:=0;
     Result:= VergleicheAnzahlen(s,r,g,b,OKarte);
end;

function  TKI.VergleicheAnzahlen(s,r,g,b:integer; OKarte: TKarte): TFarben;
begin
    // case Verwaltung.
     //i:=Random(j);
     //case i of
     case Spielregeln.Spielzustand.Sperre of
      196: s:=0;
      197: r:=0;
      198: g:=0;
      199: b:=0;
     end;
     if (s>r) and (s>g) and (s>b) then              // 1/15
        Wunschfarbe:=Schwarz;
     if (s=r) and (s>g) and (s>b) then              // 2/15
        Farbvergleich(Schwarz,Rot,Ohne);
     if (s>r) and (s=g) and (s>b) then              // 3/15
        Farbvergleich(Schwarz,Gruen,Ohne);
     if (s>r) and (s>g) and (s=b) then              // 4/15
        Farbvergleich(Schwarz,Blau,Ohne);
     if (s>r) and (s=g) and (s=b) then              // 5/15
        Farbvergleich(Schwarz,Gruen,Blau);
     if (s=r) and (s=g) and (s>b) then              // 6/15
        Farbvergleich(Schwarz,Rot,Gruen);
     if (s=r) and (s>g) and (s=b) then              // 7/15
        Farbvergleich(Schwarz,Rot,Blau);
     if (s=r) and (s=g) and (s=b) then              // 8/15
        WunschFarbe:=OKarte.GetFarbe;
     if (r>s) and (r>g) and (r>b) then              // 9/15
        WunschFarbe:=Rot;
     if (r>s) and (r=g) and (r>b) then              // 10/15
        Farbvergleich(Rot,Gruen,Ohne);
     if (r>s) and (r>g) and (r=b) then              // 11/15
        Farbvergleich(Rot,Blau,Ohne);
     if (r>s) and (r=g) and (r=b) then              // 12/15
        Farbvergleich(Rot,Gruen,Blau);
     if (g>s) and (g>r) and (g>b) then              // 13/15
        WunschFarbe:=Gruen;
     if (g>s) and (g>r) and (g=b) then              // 14/15
        Farbvergleich(Gruen,Blau,Ohne);
     if (b>s) and (b>r) and (b>g) then              // 15/15
        WunschFarbe:=Blau;
     Result:=Wunschfarbe;
end;

procedure TKI.Farbvergleich(const F1,F2,F3: TFarben);
var
    z1,z2,z3,i: integer;
    Karte: TKarte;
begin
    z1:=0;
    z2:=0;
    z3:=0;
    for i:=0 to Kartenliste.Count-1 do
    begin
      Karte:=Kartenliste.Items[i];
      if Karte.GetTyp <= 6 then
      begin
        if Karte.GetFarbe= F1 then inc(z1)
        else
          if Karte.GetFarbe= F2 then inc(z2)
          else
            if Karte.GetFarbe= F3 then inc(z3);
      end;
    end;
    if (z1>z2) then
      if (z1>z3) then WunschFarbe:=F1
      else
        if (z1=z3) then WunschFarbe:=f1 //muss verändert werden!!!
        else
          WunschFarbe:=F3
    else
      if (z1=z2) then
        if (z1>z3) then WunschFarbe:=f1 //muss verändert werden!!!
        else
          if (z1=z3) then WunschFarbe:= f2 //muss verändert werden!!!
          else
            WunschFarbe:=F3
      else
        if (z2>z3) then WunschFarbe:=F2
        else
          if (z2=z3) then WunschFarbe:= f2 //muss verädert werden!!!
          else
            WunschFarbe:=F3;
end;

function TKI.OKarteTypDa(OKarte: TKarte): boolean;
var i:integer;
begin
      Result:=false;
     for i:= 0 to Kartenliste.Count-1 do
          if OKarte.GetTyp = TKarte(Kartenliste.Items[i]).GetTyp then
            Result:=true;
end;

function TKI.FunktionskartenDa: boolean;
var i:integer;
begin
      Result:=false;
     for i:= 0 to Kartenliste.Count-1 do
          if TKarte(Kartenliste.Items[i]).GetTyp > 6 then
            Result:=true;
end;

{function TKI.ExilPlayer(Spielerzahl:integer): Longword;
var i,j:integer;
    Spielerliste:TList;
begin
    for i:= 1 to Spielerzahl do
     begin
        //Spielerliste.Add(Protokoll.SpielerKartenCount(i));
     end;
     j:=1;
     while (j+1<=Spielerliste.Count) and (Spielerliste.Items[j]<Spielerliste.Items[j+1]) do
     inc(j);
     If Spielerzahl

end;      }

procedure TKI.Herrschaftswechsel(out Spieler1: TSpieler; out Spieler2: TSpieler);
var HilfsSpieler: TSpieler;
    i: integer;
begin
           if (MinimumKartenZahl < 3) and (MaximumKartenZahl > 15) then    // 2.
           begin
              Spieler1 := Self;
              For i:=0 to Spielerliste.Count-1 do
                if TSpieler(Spielerliste.Items[i]).CountKarten=MinimumKartenZahl then
                  Spieler2 := TSpieler(Spielerliste.Items[i]);
           end
           else
           begin
              i:= Spielerliste.Count;
              Spieler1 := TSpieler(Spielerliste.Items[Random(i)]);
              Hilfsspieler:=TSpieler(Spielerliste.Items[Random(i)]);
              while Hilfsspieler = Spieler1 do
                Hilfsspieler:=TSpieler(Spielerliste.Items[Random(i)]);
              Spieler2 := Hilfsspieler;
           end;
           
           if not Assigned(Spieler1) or not Assigned(Spieler2) or (Spieler1 = Spieler2) then
            begin
            Spieler1 := Spielerliste.Items[0];
            Spieler2 := Spielerliste.Items[1];
            end;
              // 1. Wenn ich selber wenig karten haben will und viele habe
              // 3. Wenn ich wenig Karten habe und der Spieler vor mir viel, dann den mit jemandem mit weniger Karten tauschen lassen, um Risiko zu senken, dass ich ziehen muss

end;

function TKI.Sperren: Byte;
var i: integer;
begin
     Result:= Random(21)+1;
     Case Result of
     18..21: Result:=Result+ 178;
     end;
    { for i:= 0 to Kartenliste.Count-1 do
      if (TKarte(Kartenliste.Items[i]).GetTyp = Result) or (GetFarbindex(TKarte(Kartenliste.Items[i])) = Result-196) then
        Result:=Sperren; }
        // kommentar von Tubo: verstehe nicht, wie das funktionieren soll und was es bewirkt
        // außerdem endlosschleife sehr wahrscheinlich....
end;

function TKI.WenAusspionieren: TSpieler;
begin
  repeat
    Result := TSpieler(Spielerliste.Items[Random(Spielerliste.Count)]);
  until Result <> Self;
end;

function TKI.WhoGetsSpionierteKarte(SpionierteKarte: TKarte): TSpieler;
begin
  Result := TSpieler(Spielerliste.Items[Random(Spielerliste.Count)]);
end;

end.

