unit uSpielregeln;

interface

uses
  uKarte, uGlobalTypes;

type
  TSpielzustand = record
    Ziehkarten: Byte;
    Sperre, SperrIndex, Strafkarten: Byte;
    WunschFarbe: TFarben;
    end;

  TSpielregeln = class(TObject)
  private
  public
    Spielzustand: TSpielzustand;
    constructor Create;
    procedure Reset;
    function LegenMoeglich(Liegt, ZuLegen: TKarte): Boolean;
    procedure WunschfarbeAufheben;
    procedure Ziehkarten(Karte: TKarte);
    procedure ZiehkartenAufheben;
    function Sperrpruefung(Karte: TKarte): Boolean;
    function FarbSperrpruefung(Farbe: TFarben): Boolean;
    procedure Sperren(ZuSperren: Byte);
    procedure SperreAufheben;
  end;

implementation

constructor TSpielregeln.Create;
begin
  Reset;
end;

procedure TSpielregeln.Reset;
begin
  with Spielzustand do
    begin
    Ziehkarten := 0;
    SperrIndex := 0;
    Sperre := 0;
    Strafkarten := 0;
    WunschFarbe := Ohne;
    end;
end;

function TSpielregeln.LegenMoeglich(Liegt, ZuLegen: TKarte): Boolean;
begin
  Result := false;
  if (Liegt = nil) or (ZuLegen = nil) then Exit;
  if (ZuLegen.GetTyp = 11) then
    Result := true
  else if (Liegt.GetTyp = 17) and (Spielzustand.Sperre = 199) then
    Result := true
  else if ((Spielzustand.WunschFarbe = Ohne) and (Spielzustand.Ziehkarten = 0)) and ((Liegt.GetFarbe = ZuLegen.GetFarbe) or (Liegt.GetTyp = ZuLegen.GetTyp) or (ZuLegen.GetTyp = 7) or (ZuLegen.GetTyp = 12) or ((Liegt.GetTyp = 8) and (ZuLegen.GetTyp = 9))) then
    Result := true
  else if ((Spielzustand.WunschFarbe = Ohne) and (Spielzustand.Ziehkarten > 0)) and  ((Liegt.GetTyp = ZuLegen.GetTyp) or ((Liegt.GetFarbe = ZuLegen.GetFarbe) and ((ZuLegen.GetTyp = 8) or (ZuLegen.GetTyp = 9) or (ZuLegen.GetTyp = 10) or (ZuLegen.GetTyp = 13))) or ((Liegt.GetTyp = 8) and (ZuLegen.GetTyp = 9))) then
    Result := true
  else if ((Spielzustand.WunschFarbe <> Ohne) and (Spielzustand.Ziehkarten = 0)) and ((Spielzustand.WunschFarbe = ZuLegen.GetFarbe) or (ZuLegen.GetTyp = 12)) then
    Result := true
  else if ((Spielzustand.WunschFarbe <> Ohne) and (Spielzustand.Ziehkarten > 0)) and ((Spielzustand.WunschFarbe = ZuLegen.GetFarbe) and ((ZuLegen.GetTyp = 8) or (ZuLegen.GetTyp = 9) or (ZuLegen.GetTyp = 10) or (ZuLegen.GetTyp = 13))) then
    Result := true;
end;

procedure TSpielregeln.WunschfarbeAufheben;
begin
  Spielzustand.WunschFarbe := Ohne;
end;

procedure TSpielregeln.Ziehkarten(Karte: TKarte);
begin
with Spielzustand do
  begin
  case Karte.GetTyp of
    8: Ziehkarten := Ziehkarten + 2;
    9: Ziehkarten := Ziehkarten + 3;
    11: Ziehkarten := Ziehkarten + 5;
    13: Ziehkarten := 0;
    end;
  end;
end;

procedure TSpielregeln.ZiehkartenAufheben;
begin
  Spielzustand.Ziehkarten := 0;
end;

function TSpielregeln.Sperrpruefung(Karte: TKarte): Boolean;
// liefert true bei Verstoﬂ
begin
Result := false;
with Spielzustand do
  begin
  if (Sperre <> 0) then
    begin
    if ((Karte.GetTyp = Sperre) or ((Karte.GetTyp = 12) and (Sperre = 11)) or (((Karte.GetTyp = 15) or (Karte.GetTyp = 16)) and (Sperre = 14))) then
      Result := true
    else
      Result := FarbSperrpruefung(Karte.GetFarbe)
    end;
  end;
end;

function TSpielregeln.FarbSperrpruefung(Farbe: TFarben): Boolean;
// liefert true bei Verstoﬂ
begin
Result := false;
with Spielzustand do
  begin
  if (Sperre <> 0) then
    begin
    case Farbe of
      Schwarz: if (Sperre = 196) then Result := true;
      Rot: if (Sperre = 197) then Result := true;
      Gruen: if (Sperre = 198) then Result := true;
      Blau: if (Sperre = 199) then Result := true;
      end;
    end;
  end;
end;

procedure TSpielregeln.Sperren(ZuSperren: Byte);
begin
with Spielzustand do
  begin
  if (Sperre = ZuSperren) then
    Inc(SperrIndex)
  else
    begin
    Sperre := ZuSperren;
    SperrIndex := 1;
    end;
  Strafkarten := 5 * SperrIndex;
  end;
end;

procedure TSpielregeln.SperreAufheben;
begin
with Spielzustand do
  begin
  SperrIndex := 0;
  Sperre := 0;
  Strafkarten := 0;
  end;
end;

end.
 