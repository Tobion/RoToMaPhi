unit uAblagestapel;

interface

uses
  Contnrs, uKarte;

type
  TAblagestapel = class(TObject)
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

constructor TAblagestapel.Create;
begin
  inherited Create;
  Stapel := TStack.Create;
end;

destructor TAblagestapel.Destroy;
begin
  Stapel.Free;
  inherited Destroy;
end;

procedure TAblagestapel.PushKarte(AKarte: TKarte);
begin
  if (AKarte <> nil) then Stapel.Push(AKarte);
end;

function TAblagestapel.PopKarte: TKarte;
begin
  if (Stapel.Count > 0) then Result := Stapel.Pop
    else Result := nil;
end;

function TAblagestapel.CountKarten: Integer;
begin
  Result := Stapel.Count;
end;

function TAblagestapel.PeekKarte: TKarte;
begin
  if (Stapel.Count > 0) then
    Result := Stapel.Peek
    else Result := nil;
end;

procedure TAblagestapel.Clear;
begin
  while (Stapel.Count > 0) do
    TKarte(Stapel.Pop).Free;
end;

end.
