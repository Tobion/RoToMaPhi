unit uKarte;

interface

uses
  Graphics, SysUtils, uGlobalTypes;

type
  TKartenEigenschaften = record
    ID: Longword;                  // für jede Karte individuell
    Typ: Byte;                     // gibt den Typ der Karte an und somit deren Funktion
                                   // also alle Karten mit dem gleichen Typ haben die gleiche Funktion
    Name: String;                  // Name der Karte
    Farbe: TFarben;                // Farbe der Karte
    Info: String;                  // Beschreibung der Karte
    ResName: String;               // Resourcenname bestimmt das Kartenbitmap
    SortWert: String;              // Sortierwert
    end;

  TKarte = class(TObject)
  private
    Eigenschaften: TKartenEigenschaften;
  public
    constructor Create(const InitKarten: TInitKarten);
    procedure LoadBitmap(bmp: TBitmap);
    function GetID: Longword;
    function GetTyp: Byte;
    function GetName: String;
    function GetFarbe: TFarben;
    function GetInfo: String;
    function GetSortWert: String;
    procedure SetColor(AFarbe: TFarben);
  end;

const
  Karten: array[0..16] of TKartenEigenschaften = (
    (Typ: 1; Name: 'Sklave'; Info: ''; SortWert: '001'),
    (Typ: 2; Name: 'Bettler'; Info: ''; SortWert: '002'),
    (Typ: 3; Name: 'Bauer'; Info: ''; SortWert: '003'),
    (Typ: 4; Name: 'Handwerker'; Info: ''; SortWert: '004'),
    (Typ: 5; Name: 'Händler'; Info: ''; SortWert: '005'),
    (Typ: 6; Name: 'Adliger'; Info: ''; SortWert: '006'),
    (Typ: 7; Name: 'Hellseher'; Info: 'Können die als nächstes zu spielende Farbe bestimmen.'; SortWert: '007'),
    (Typ: 8; Name: 'Söldner'; Info: 'Söldner haben eine Angriffsstärke von 2.'; SortWert: '008'),
    (Typ: 9; Name: 'Ritter'; Info: 'Ritter haben eine Angriffsstärke von 3.'; SortWert: '009'),
    (Typ: 10; Name: 'Diplomat'; Info: 'Diplomaten leiten den Angriff auf den nächsten Spieler weiter bzw. lassen diesen aussetzen, wenn keine Karten zu ziehen sind.'; SortWert: '010'),
    (Typ: 11; Name: 'Schwarzer Magier'; Info: 'Schwarze Magier sind die stärksten Angriffskarten.'; SortWert: '011'),
    (Typ: 12; Name: 'Weißer Magier'; Info: 'Weiße Magier halbieren deine Karten und lassen dich eine Farbe wünschen.'; SortWert: '012'),
    (Typ: 13; Name: 'Mauer'; Info: 'Mauern können Angriffe abwehren.'; SortWert: '013'),
    (Typ: 14; Name: 'Spionage'; Info: 'Spioniere einem Mitspieler eine Karte aus.'; SortWert: '014'),
    (Typ: 15; Name: 'Herrschaftswechsel'; Info: 'Bestimme, welche Spieler die Karten tauschen müssen.'; SortWert: '015'),
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
      Schwarz: begin ResName := 'S'; SortWert := 'A'; end;
      Rot: begin ResName := 'R'; SortWert := 'B'; end;
      Gruen: begin ResName := 'G'; SortWert := 'C'; end;
      Blau: begin ResName := 'B'; SortWert := 'D'; end;
      Ohne: begin ResName := 'O'; SortWert := 'E'; end;
      end;
    ResName := ResName + IntToStr(Typ);
    SortWert := SortWert + Karten[Index].SortWert;
    end;
end;

procedure TKarte.LoadBitmap(bmp: TBitmap);
begin
  try
    bmp.LoadFromResourceName(HInstance, Eigenschaften.ResName);
  except
    bmp.Free;
  end;
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

procedure TKarte.SetColor(AFarbe: TFarben);
begin
with Eigenschaften do
  begin
  Farbe := AFarbe;
  case Farbe of
      Schwarz: ResName := 'S';
      Rot: ResName := 'R';
      Gruen: ResName := 'G';
      Blau: ResName := 'B';
      Ohne: ResName := 'O';
      end;
  ResName := ResName + IntToStr(Typ);
  end;
end;

end.
