unit uSpieler;

interface

uses
  Classes, ExtCtrls, Controls, Forms, Math, Graphics, SysUtils, ScktComp, uKarte;

type
  TSpieler = class(TObject)
  private
  protected
    procedure SortiereKarten;
  public
    ID: Longword;
    Name: String;
    RemoteAddress: String;
    RemoteHost: String;
    Socket: TCustomWinSocket;
    Ready: Boolean;
    LetzteKarte: TKarte;
    KartenListe: TList;
    constructor Create(const AID: Longword; const AName: String; ASocket: TCustomWinSocket = nil);
    destructor Destroy; override;
    procedure KarteAufnehmen(const AKarte: TKarte);
    function KarteAblegen(const KartenID: Longword): TKarte; overload;
    function KarteAblegen(const AKarte: TKarte): TKarte; overload;
    procedure LetzteKarteAblegen(const KartenID: Longword);
    function CountKarten: Integer;
    procedure ShowKarten(ScrollBox: TScrollBox; MouseDown: TMouseEvent);
    procedure ResizeKarten(ScrollBox: TScrollBox);
    function GetKarte(const KartenID: Longword): TKarte; virtual;
    function GetZufallsKarte: TKarte;
  end;

  function CompareKarten(Item1, Item2: Pointer): Integer;

const
  DefaultMarginTop = 20;
  PossibilityMarginTop = 13;
  SelectedMarginTop = 0;

implementation

constructor TSpieler.Create(const AID: Longword; const AName: String; ASocket: TCustomWinSocket = nil);
begin
  inherited Create;
  ID := AID;
  Name := AName;
  Socket := ASocket;
  if Assigned(Socket) then
    begin
    RemoteAddress := Socket.RemoteAddress;
    RemoteHost := Socket.RemoteHost;
    end;
  KartenListe := TList.Create;
  Ready := false;
  LetzteKarte := nil;
end;

destructor TSpieler.Destroy;
begin
  KartenListe.Clear;
  KartenListe.Free;
  LetzteKarte.Free;
  inherited Destroy;
end;

procedure TSpieler.KarteAufnehmen(const AKarte: TKarte);
begin
  if (AKarte <> nil) then
    begin
    KartenListe.Add(AKarte);
    SortiereKarten;
    end;
end;

function TSpieler.KarteAblegen(const KartenID: Longword): TKarte;
begin
  Result := KartenListe.Extract(GetKarte(KartenID));
end;

function TSpieler.KarteAblegen(const AKarte: TKarte): TKarte;
begin
  Result := KartenListe.Extract(AKarte);
end;

procedure TSpieler.LetzteKarteAblegen(const KartenID: Longword);
begin
  if Assigned(LetzteKarte) then KarteAufnehmen(LetzteKarte);
  LetzteKarte := KarteAblegen(KartenID);
end;

function TSpieler.CountKarten: Integer;
begin
  Result := KartenListe.Count;
  if Assigned(LetzteKarte) then Inc(Result);
end;

procedure TSpieler.SortiereKarten;
begin
  KartenListe.Sort(CompareKarten);
end;

function CompareKarten(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(TKarte(Item1).GetSortWert, TKarte(Item2).GetSortWert);
end;

procedure TSpieler.ShowKarten(ScrollBox: TScrollBox; MouseDown: TMouseEvent);
const MaxAbstand = KartenWidth + 5;
      MinAbstand = 20;
var graphic: TGraphic;
    Image: TImage;
    i, Abstand, WidthNeeded, xoffset: Integer;
begin
  while ScrollBox.ControlCount > 0 do
    ScrollBox.Controls[0].Free;
  if not (KartenListe.Count > 0) then Exit;
  Abstand := Min(MaxAbstand, Max(MinAbstand, Trunc(ScrollBox.Width / KartenListe.Count)));
  WidthNeeded := Abstand * KartenListe.Count;
  if (Abstand < MaxAbstand) then // damit die letzte Karte vollständig angezeigt wird
    Abstand := Trunc(Abstand - ((KartenWidth - Abstand) / KartenListe.Count));
  xoffset := Round((ScrollBox.Width / 2) - (WidthNeeded / 2));
  xoffset := Max(0, xoffset);
  ScrollBox.HorzScrollBar.Visible := (WidthNeeded > ScrollBox.Width + 2);
  for i:=0 to KartenListe.Count-1 do
    begin
    graphic := TKarte(KartenListe.Items[i]).GetImage;
    try
    Image := TImage.Create(ScrollBox);
    with Image do
      begin
      Parent := ScrollBox;
      SetBounds(xoffset + (i * Abstand),DefaultMarginTop,KartenWidth,KartenHeight);
      Picture.Graphic := graphic;
      ShowHint := true;
      Hint := TKarte(KartenListe.Items[i]).GetName + #10 + TKarte(KartenListe.Items[i]).GetInfo;
      Tag := TKarte(KartenListe.Items[i]).GetID;
      OnMouseDown := MouseDown;
      Show;
      end;
    finally
      graphic.Free;
    end;
    end;
end;

procedure TSpieler.ResizeKarten(ScrollBox: TScrollBox);
const KartenWidth = 100;
      KartenHeight = 157;
      MaxAbstand = KartenWidth + 5;
      MinAbstand = 20;
var i, Abstand, WidthNeeded, xoffset: Integer;
begin
  if not (ScrollBox.ControlCount > 0) then Exit;
  Abstand := Min(MaxAbstand, Max(MinAbstand, Trunc(ScrollBox.Width / ScrollBox.ControlCount)));
  WidthNeeded := Abstand * ScrollBox.ControlCount;
  if (Abstand < MaxAbstand) then // damit die letzte Karte vollständig angezeigt wird
    Abstand := Trunc(Abstand - ((KartenWidth - Abstand) / ScrollBox.ControlCount));
  xoffset := Max(0, Round((ScrollBox.Width / 2) - (WidthNeeded / 2)));
  ScrollBox.HorzScrollBar.Visible := (WidthNeeded > ScrollBox.Width + 2);
  for i:=0 to ScrollBox.ControlCount-1 do
    begin
    ScrollBox.Controls[i].Left := xoffset + (i * Abstand);
    end;
end;

function TSpieler.GetKarte(const KartenID: Longword): TKarte;
var i: Integer;
begin
  Result := nil;
  for i:=0 to KartenListe.Count-1 do
    begin
    if (TKarte(KartenListe.Items[i]).GetID = KartenID) then
      begin
      Result := KartenListe.Items[i];
      Break;
      end;
    end;
end;

function TSpieler.GetZufallsKarte: TKarte;
begin
  Result := KartenListe.Items[Random(KartenListe.Count)];
end;

end.
 
 