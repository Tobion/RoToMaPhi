unit uKarte;

interface

uses
  Windows, Graphics, SysUtils, Classes, uGlobalTypes, uResourceAccess;

type
  TKartenEigenschaften = record
    ID: Longword;                  // f�r jede Karte individuell
    Typ: Byte;                     // gibt den Typ der Karte an und somit deren Funktion
                                   // also alle Karten mit dem gleichen Typ haben die gleiche Funktion
    Name: String;                  // Name der Karte
    Farbe: TFarben;                // Farbe der Karte
    Info: String;                  // Beschreibung der Karte
    SortWert: String;              // Sortierwert
    end;

  TKarte = class(TObject)
  private
    Eigenschaften: TKartenEigenschaften;
  public
    constructor Create(const InitKarten: TInitKarten);
    function GetImage: TGraphic;
    function GetID: Longword;
    function GetTyp: Byte;
    function GetName: String;
    function GetFarbe: TFarben;
    function GetInfo: String;
    function GetSortWert: String;
  end;

const
  KartenWidth = 100;
  KartenHeight = 157;

  Karten: array[0..16] of TKartenEigenschaften = (
    (Typ: 1; Name: 'Sklave'; Info: ''; SortWert: '001'),
    (Typ: 2; Name: 'Bettler'; Info: ''; SortWert: '002'),
    (Typ: 3; Name: 'Bauer'; Info: ''; SortWert: '003'),
    (Typ: 4; Name: 'Handwerker'; Info: ''; SortWert: '004'),
    (Typ: 5; Name: 'H�ndler'; Info: ''; SortWert: '005'),
    (Typ: 6; Name: 'Adliger'; Info: ''; SortWert: '006'),
    (Typ: 7; Name: 'Hellseher'; Info: 'K�nnen die als n�chstes zu spielende Farbe bestimmen.'; SortWert: '007'),
    (Typ: 8; Name: 'S�ldner'; Info: 'S�ldner haben eine Angriffsst�rke von 2.'; SortWert: '008'),
    (Typ: 9; Name: 'Ritter'; Info: 'Ritter haben eine Angriffsst�rke von 3.'; SortWert: '009'),
    (Typ: 10; Name: 'Diplomat'; Info: 'Diplomaten leiten den Angriff auf den n�chsten Spieler weiter bzw. lassen diesen aussetzen, wenn keine Karten zu ziehen sind.'; SortWert: '010'),
    (Typ: 11; Name: 'Schwarzer Magier'; Info: 'Schwarze Magier sind die st�rksten Angriffskarten.'; SortWert: '011'),
    (Typ: 12; Name: 'Wei�er Magier'; Info: 'Wei�e Magier halbieren deine Karten und lassen dich eine Farbe w�nschen.'; SortWert: '012'),
    (Typ: 13; Name: 'Mauer'; Info: 'Mauern k�nnen Angriffe abwehren.'; SortWert: '013'),
    (Typ: 14; Name: 'Spionage'; Info: 'Spioniere einem Mitspieler eine Karte aus.'; SortWert: '014'),
    (Typ: 15; Name: 'Herrschaftswechsel'; Info: 'Bestimme, welche Spieler die Karten tauschen m�ssen.'; SortWert: '015'),
    (Typ: 16; Name: 'Exil'; Info: 'Noch keine Bedeutung.'; SortWert: '016'),
    (Typ: 17; Name: 'Tribunal'; Info: 'Sperre Typ, Farbe oder Ereignisse.'; SortWert: '017')
  );

implementation

constructor TKarte.Create(const InitKarten: TInitKarten);

  function GetIndex: Integer;
  var i: Integer;
  begin
  Result := Low(Karten);
  for i:=Low(Karten) to High(Karten) do
    begin
    if (Karten[i].Typ = InitKarten.Typ) then
      begin
      Result := i;
      Break;
      end;
    end;
  end;

var Index: Integer;
begin
  inherited Create;
  with Eigenschaften do
    begin
    ID := InitKarten.ID;
    Typ := InitKarten.Typ;
    Farbe := InitKarten.Farbe;
    Index := GetIndex;
    Name := Karten[Index].Name;
    Info := Karten[Index].Info;
    case Farbe of
      Schwarz: SortWert := 'A';
      Rot: SortWert := 'B';
      Gruen: SortWert := 'C';
      Blau: SortWert := 'D';
      Ohne: SortWert := 'E';
      end;
    SortWert := SortWert + Karten[Index].SortWert;
    end;
end;


function TKarte.GetImage: TGraphic;
begin
  Result := GetImageFromResource((Integer(GetFarbe) + 1) * 100 + GetTyp, iGIF);
end;

function TKarte.GetID: Longword;
begin
  Result := Eigenschaften.ID;
end;

function TKarte.GetTyp: Byte;
begin
  Result := Eigenschaften.Typ;
end;

function TKarte.GetName: String;
begin
  Result := Eigenschaften.Name;
end;

function TKarte.GetFarbe: TFarben;
begin
  Result := Eigenschaften.Farbe;
end;

function TKarte.GetInfo: String;
begin
  Result := Eigenschaften.Info;
end;

function TKarte.GetSortWert: String;
begin
  Result := Eigenschaften.SortWert;
end;


end.
