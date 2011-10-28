unit uTauschDlg;

interface

uses
  Windows, Forms, StdCtrls, ExtCtrls, Controls, Classes, Dialogs, uSpieler, uVerwaltung;

type
  TTauschDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    OKBtn: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    constructor Create(AOwner: TComponent; AVerwaltung: TVerwaltung); reintroduce;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    Verwaltung: TVerwaltung;
  public
    function GetSpieler1: Longword;
    function GetSpieler2: Longword;
  end;

var
  TauschDlg: TTauschDlg;

implementation

{$R *.dfm}

constructor TTauschDlg.Create(AOwner: TComponent; AVerwaltung: TVerwaltung);
begin
  inherited create(AOwner);
  Verwaltung := AVerwaltung;
end;

function TTauschDlg.GetSpieler1: Longword;
begin
  Result := TSpieler(Verwaltung.SpielerListe.Items[ComboBox1.ItemIndex]).ID;
end;

function TTauschDlg.GetSpieler2: Longword;
begin
  Result := TSpieler(Verwaltung.SpielerListe.Items[ComboBox2.ItemIndex]).ID;
end;

procedure TTauschDlg.FormShow(Sender: TObject);
var i: Integer;
begin
  ComboBox1.Clear;
  ComboBox2.Clear;
  for i:=0 to (Verwaltung.SpielerListe.Count-1) do
  begin
    ComboBox1.Items.Add(TSpieler(Verwaltung.SpielerListe.Items[i]).Name);
    ComboBox2.Items.Add(TSpieler(Verwaltung.SpielerListe.Items[i]).Name);
  end;
  ComboBox1.ItemIndex := 0;
  ComboBox2.ItemIndex := 1;
end;

procedure TTauschDlg.OKBtnClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TTauschDlg.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ComboBox1.ItemIndex = ComboBox2.ItemIndex then
  begin
    Self.ModalResult := mrNone;
    CanClose := false;
    ShowMessage('Bitte zwei unterschiedliche Spieler auswählen!');
  end
  else
  begin
    Self.ModalResult := mrOk;
    CanClose := true;
  end;
end;

end.
