unit uZiehstapel;

interface

uses
  Contnrs, uKarte;

type
  TZiehstapel = class(TObject)
  private
    Stapel: TStack;
  public
    constructor Create;
    destructor Destroy; override;
    procedure PushKarte(AKarte: TKarte);
    function PopKarte: TKarte;
    function CountKarten: Integer;
    function PeekKarte: TKarte;
    procedure Clear;
  end;

implementation

constructor TZiehstapel.Create;
begin
  inherited Create;
  Stapel := TStack.Create;
end;

destructor TZiehstapel.Destroy;
begin
  Stapel.Free;
  inherited Destroy;
end;

procedure TZiehstapel.PushKarte(AKarte: TKarte);
begin
  if (AKarte <> nil) then Stapel.Push(AKarte);
end;

function TZiehstapel.PopKarte: TKarte;
begin
  if (Stapel.Count > 0) then Result := Stapel.Pop
    else Result := nil;
end;

function TZiehstapel.CountKarten: Integer;
begin
  Result := Stapel.Count;
end;

function TZiehstapel.PeekKarte: TKarte;
begin
  if (Stapel.Count > 0) then
    Result := Stapel.Peek
    else Result := nil;
end;

procedure TZiehstapel.Clear;
begin
  while (Stapel.Count > 0) do
    TKarte(Stapel.Pop).Free;
end;

end.

