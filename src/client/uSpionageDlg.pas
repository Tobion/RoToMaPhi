unit uSpionageDlg;

interface

uses
  Windows, Forms, StdCtrls, ExtCtrls, SysUtils, Graphics, Dialogs, Controls, Classes,
  uKarte, uSpieler, uVerwaltung;

type
  TSpionageDlg = class(TForm)
    SpionagePanel: TPanel;
    AbgebenPanel: TPanel;
    Label1: TLabel;
    SpielerComboBox1: TComboBox;
    KartenAnzahlLabel: TLabel;
    SpionageBtn: TButton;
    SpielerComboBox2: TComboBox;
    KarteImage: TImage;
    OKBtn: TButton;
    Label3: TLabel;
    BehaltenBtn: TButton;
    constructor Create(AOwner: TComponent; AVerwaltung: TVerwaltung); reintroduce;
    procedure SpionageBtnClick(Sender: TObject);
    procedure SpielerComboBox1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OKBtnClick(Sender: TObject);
    procedure BehaltenBtnClick(Sender: TObject);
  private
    Verwaltung: TVerwaltung;
    SpioKarte: TKarte;
    TmpListe: TList;
    Spioniert, CloseAbgeben, CloseBehalten: Boolean;
  public
    procedure SpielerAuflisten(MySelf: TSpieler);
    function GetSpioKartenID: Longword;
    function GetIDSpielerFrom: Longword;
    function GetIDSpielerTo: Longword;
  end;

var
  SpionageDlg: TSpionageDlg;

implementation

{$R *.dfm}

constructor TSpionageDlg.Create(AOwner: TComponent; AVerwaltung: TVerwaltung);
begin
  inherited create(AOwner);
  Verwaltung := AVerwaltung;
  SpioKarte := nil;
  TmpListe := TList.Create;
end;

procedure TSpionageDlg.SpielerAuflisten(MySelf: TSpieler);
var i: Integer;
begin
  AbgebenPanel.Visible := false;
  SpionagePanel.Visible := true;
  SpielerComboBox1.Clear;
  SpielerComboBox2.Clear;
  TmpListe.Clear;
  Spioniert := false;
  CloseAbgeben := false;
  CloseBehalten := false;
  for i:=0 to (Verwaltung.SpielerListe.Count-1) do
    begin
    if TSpieler(Verwaltung.SpielerListe.Items[i]) <> MySelf then
      begin
      TmpListe.Add(TSpieler(Verwaltung.SpielerListe.Items[i]));
      SpielerComboBox1.Items.Add(TSpieler(Verwaltung.SpielerListe.Items[i]).Name);
      SpielerComboBox2.Items.Add(TSpieler(Verwaltung.SpielerListe.Items[i]).Name);
      end;
    end;
  SpielerComboBox1.ItemIndex := 0;
  SpielerComboBox2.ItemIndex := 0;
  KartenAnzahlLabel.Caption := Format('Kartenanzahl:  %d', [TSpieler(TmpListe.Items[SpielerComboBox1.ItemIndex]).KartenListe.Count]);
end;

procedure TSpionageDlg.SpionageBtnClick(Sender: TObject);
var graphic: TGraphic;
begin
  SpioKarte := TSpieler(TmpListe.Items[SpielerComboBox1.ItemIndex]).KartenListe.Items[Random(TSpieler(TmpListe.Items[SpielerComboBox1.ItemIndex]).KartenListe.Count)];
  graphic := SpioKarte.GetImage;
  try
    KarteImage.Picture.Graphic := graphic;
  finally
    graphic.Free;
  end;
  Spioniert := true;
  AbgebenPanel.Visible := true;
  SpionagePanel.Visible := false;
end;

procedure TSpionageDlg.SpielerComboBox1Change(Sender: TObject);
begin
  KartenAnzahlLabel.Caption := Format('Kartenanzahl:  %d', [TSpieler(TmpListe.Items[SpielerComboBox1.ItemIndex]).KartenListe.Count]);
end;

function TSpionageDlg.GetSpioKartenID: Longword;
begin
  Result := SpioKarte.GetID;
end;

function TSpionageDlg.GetIDSpielerFrom: Longword;
begin
  Result := TSpieler(TmpListe.Items[SpielerComboBox1.ItemIndex]).ID;
end;

function TSpionageDlg.GetIDSpielerTo: Longword;
begin
  Result := TSpieler(TmpListe.Items[SpielerComboBox2.ItemIndex]).ID;
end;

procedure TSpionageDlg.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not Spioniert then
    begin
    CanClose := false;
    Showmessage('Bitte erst einen Spieler ausspionieren!');
    end
  else if CloseAbgeben then
    Self.ModalResult := mrOk
  else if CloseBehalten then
    Self.ModalResult := mrYes
  else
    begin
    CanClose := false;
    Showmessage('Karte weitergeben oder behalten?');
    end;
end;

procedure TSpionageDlg.OKBtnClick(Sender: TObject);
begin
  CloseAbgeben := true;
  Self.Close;
end;

procedure TSpionageDlg.BehaltenBtnClick(Sender: TObject);
begin
  CloseBehalten := true;
  Self.Close;
end;

end.
