unit uSperrDlg;

interface

uses
  Windows, Forms, StdCtrls, ExtCtrls, Controls, Classes;

type
  TSperrDlg = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Panel1: TPanel;
    RdSchwarz: TRadioButton;
    RdRot: TRadioButton;
    RdGruen: TRadioButton;
    RdBlau: TRadioButton;
    GroupBox1: TGroupBox;
    RdSklave: TRadioButton;
    RdBettler: TRadioButton;
    RdBauer: TRadioButton;
    RdHandwerker: TRadioButton;
    RdHaendler: TRadioButton;
    RdAdliger: TRadioButton;
    RdHellseher: TRadioButton;
    RdSoeldner: TRadioButton;
    RdRitter: TRadioButton;
    RdDiplomat: TRadioButton;
    RdMagier: TRadioButton;
    RdEreignisse: TRadioButton;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    RdMauer: TRadioButton;
  private
  public
    function GetSperre: Byte;
  end;

var
  SperrDlg: TSperrDlg;

implementation

{$R *.dfm}

function TSperrDlg.GetSperre: Byte;
begin
  Result := 0;
  if RdSklave.Checked then
    Result := 1
  else if RdBettler.Checked then
    Result := 2
  else if RdBauer.Checked then
    Result := 3
  else if RdHandwerker.Checked then
    Result := 4
  else if RdHaendler.Checked then
    Result := 5
  else if RdAdliger.Checked then
    Result := 6
  else if RdHellseher.Checked then
    Result := 7
  else if RdSoeldner.Checked then
    Result := 8
  else if RdRitter.Checked then
    Result := 9
  else if RdDiplomat.Checked then
    Result := 10
  else if RdMagier.Checked then
    Result := 11
  else if RdMauer.Checked then
    Result := 13
  else if RdEreignisse.Checked then
    Result := 14
  else if RdSchwarz.Checked then
    Result := 196
  else if RdRot.Checked then
    Result := 197
  else if RdGruen.Checked then
    Result := 198
  else if RdBlau.Checked then
    Result := 199;
end;

end.
