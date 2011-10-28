unit uProtokoll;

interface

uses
   Classes, SysUtils, uGlobalTypes;

type
  TProtokoll = class(TObject)
  private
    Spielzugliste: TStringlist;
    KartenzahlListe: TStringlist;
    vorherigerKartentyp: Integer;
  public
    Spielerzahl: Integer;
    constructor create;
    procedure Spielstart(const SpielerZahl: Integer);
    procedure Ueberpruefung(const SpielerName: String; ID, KartenID: Longword;
                           KartenTyp, Restkarten: Integer; KartenName: String;
                           Farbe, WunschFarbe: TFarben);
    procedure KarteGelegt(const SpielerName: String; ID, KartenID: Longword;
                           KartenTyp, Restkarten: Integer; KartenName, KartenFarbe, Befehl: String);
    procedure KarteGezogen(SpielerName:String; ID: Cardinal; RestKarten, ZiehZahl: Byte);
    procedure KartenGetauscht(SpielerName1, SpielerName2: String; IDs1,IDs2: Cardinal);
    procedure VergleicheKartenzahl;
    function letzteZeileAendern: String;
    function FarbeUmwandeln(const Farbe:TFarben): String;
    function GetNachfolgerKartenZahl: Integer;
    function GetMaximumKartenZahl: Integer;
    function GetMinimumKartenZahl: Integer;
    function GetSpielerID(const Kartenzahl: integer): Longword;
end;

implementation

constructor TProtokoll.create;
begin
inherited create;
SpielzugListe:= TStringList.Create;
KartenzahlListe:= TStringlist.Create;
end;

procedure TProtokoll.Spielstart(const SpielerZahl: Integer);
begin
  SpielzugListe.Clear;
  SpielzugListe.Add('Ein neues Spiel mit ' + IntToStr(Spielerzahl) + ' Spielern beginnt.');
end;

Procedure TProtokoll.Ueberpruefung(const SpielerName: String; ID, KartenID: Longword;
                                   KartenTyp, Restkarten: Integer; KartenName: String;
                                   Farbe,WunschFarbe: TFarben);
var KartenFarbe, WunschKartenFarbe, SperrKartenFarbe, Befehl : String;
begin
  if (KartenTyp = 7) or (KartenTyp = 11) or (KartenTyp = 12) then
    begin
    WunschKartenFarbe:=FarbeUmwandeln(WunschFarbe);
    Befehl:='Gewünscht:'+WunschKartenFarbe;
    end
  else if KartenTyp = 17 then
    begin
    SperrKartenFarbe:=FarbeUmwandeln(WunschFarbe);
    Befehl:='Gesperrt:'+WunschKartenFarbe;
    end;


  KartenFarbe:=FarbeUmwandeln(Farbe);


KarteGelegt(SpielerName,ID,KartenID,KartenTyp,Restkarten,KartenName,KartenFarbe, Befehl);
end;

procedure TProtokoll.KarteGelegt(const SpielerName: String; ID, KartenID: Longword;
                                  KartenTyp, RestKarten: Integer; KartenName, KartenFarbe, Befehl: String);
begin
  SpielzugListe.Add(
    SpielerName + '(SpielerID:' + IntToStr(ID) + ') legt ' + KartenName + ' in ' +
    KartenFarbe + ' (ID:' + FloatToStr(KartenID) + ' Typ:' + IntToStr(KartenTyp) +
    ') - RestKarten:' + IntToStr(RestKarten) +' '+ Befehl);

  if (Kartentyp = 10) then
    if (VorherigerKartentyp <> 8) and (VorherigerKartentyp <> 9) and (VorherigerKartentyp <> 11) then
      SpielzugListe.Add('Spieler muss aussetzen.');

  VorherigerKartentyp:=KartenTyp;

  SpielzugListe.SaveToFile('Protokoll.txt');
end;

procedure TProtokoll.KarteGezogen(SpielerName:String; ID: Cardinal; RestKarten, ZiehZahl: Byte);
begin
  if ZiehZahl = 0 then ZiehZahl:=1;

  SpielzugListe.Add(SpielerName + '(SpielerID:' + IntToStr(ID) + ') hat '+ IntToStr(Ziehzahl) + ' Karte(n) gezogen.'
                  + ' Restkarten:' + IntToStr(RestKarten));

  VorherigerKartentyp:=0;

  SpielzugListe.SaveToFile('Protokoll.txt');
end;

procedure TProtokoll.KartenGetauscht(SpielerName1, SpielerName2: String; IDs1,IDs2: Cardinal);
var Temp: String;
begin
  Temp:=LetzteZeileAendern;
  SpielzugListe.Add(Temp + '--> ' + SpielerName1 + '(ID1:' + IntToStr(IDs1) + ') und ' + SpielerName2 + '(ID2:' + IntToStr(IDs2) + ') haben ihre Karten getauscht.');
  SpielzugListe.SaveToFile('Protokoll.txt');
end;

procedure TProtokoll.VergleicheKartenzahl;
var i: integer;
begin
  for i:=(SpielzugListe.Count - (SpielerZahl-2)) to SpielzugListe.Count do
    begin
    if (copy(SpielzugListe.Strings[i], pos('Restkarten:', SpielzugListe.Strings[i]), 2) = '') and (SpielzugListe.Count > Spielerzahl+1) then
      begin
      while (copy(SpielzugListe.Strings[i], pos('Restkarten:', SpielzugListe.Strings[i]), 2) = '') do
        Kartenzahlliste.Add(copy(SpielzugListe.Strings[SpielzugListe.Count - (2*SpielerZahl-2)], pos('Restkarten:', SpielzugListe.Strings[SpielzugListe.Count - (2*SpielerZahl-2)]), 2));
      end
    else KartenzahlListe.Add('10');
    end;
end;

function TProtokoll.letzteZeileAendern: String;
begin
  Result:=SpielzugListe.Strings[SpielzugListe.Count - 1];
  SpielzugListe.Delete(SpielzugListe.Count - 1);
end;

function TProtokoll.FarbeUmwandeln(const Farbe: TFarben): String;
begin
  case Farbe of Schwarz : Result:='Schwarz';
                Rot     : Result:='Rot';
                Gruen   : Result:='Grün';
                Blau    : Result:='Blau';
                Ohne    : Result:='Ohne';
  end;
end;

function TProtokoll.GetNachfolgerKartenZahl: Integer;
begin
  Result:=StrToInt(copy(SpielzugListe.Strings[SpielzugListe.Count - (SpielerZahl-2)], pos('Restkarten:', SpielzugListe.Strings[SpielzugListe.Count - (SpielerZahl-2)]), 2));
  if (Result = StrToInt('')) and (SpielzugListe.Count > Spielerzahl+1) then
    begin
    while Result = StrToInt('') do
      Result:= StrToInt(copy(SpielzugListe.Strings[SpielzugListe.Count - (2*SpielerZahl-2)], pos('Restkarten:', SpielzugListe.Strings[SpielzugListe.Count - (2*SpielerZahl-2)]), 2));
    end
  else Result:=10;
end;

function TProtokoll.GetMaximumKartenZahl: Integer;
begin
  VergleicheKartenzahl;
  KartenzahlListe.Sort;
  Result:=StrToInt(Kartenzahlliste.Strings[Spielerzahl]);
  KartenzahlListe.Clear;
end;

function TProtokoll.GetMinimumKartenZahl: Integer;
begin
  VergleicheKartenzahl;
  KartenzahlListe.Sort;
  Result:=StrToInt(Kartenzahlliste.Strings[0]);
  KartenzahlListe.Clear;
end;

function TProtokoll.GetSpielerID(const Kartenzahl: integer): Longword;
var
  i: integer;
begin
  Result := 0;

  VergleicheKartenzahl;
  for i:=0 to Pred(SpielerZahl) do
  begin
    if IntToStr(Kartenzahl) = KartenzahlListe.Strings[i] then
    Begin
      Result := StrToInt(copy(SpielzugListe.Strings[SpielzugListe.count - (KartenzahlListe.count+i)], pos('SpielerID:',SpielzugListe.Strings[SpielzugListe.count - (KartenzahlListe.count+i)]),8));
      Break;
    End;
  end;
  KartenzahlListe.Clear;
end;

end.
