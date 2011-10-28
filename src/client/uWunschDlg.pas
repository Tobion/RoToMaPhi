unit uWunschDlg;

interface

uses
  Windows, Forms, StdCtrls, ExtCtrls, Controls, Classes, uGlobalTypes;

type
  TWunschDlg = class(TForm)
    OKBtn: TButton;
    RotPanel: TPanel;
    SchwarzPanel: TPanel;
    BlauPanel: TPanel;
    GruenPanel: TPanel;
    HeadlineLabel: TLabel;
    rogePanel: TPanel;
    blgePanel: TPanel;
    grgePanel: TPanel;
    scgePanel: TPanel;
    procedure PanelClick(Sender: TObject);
  private
  public
    function GetFarbe: TFarben;
  end;

var
  WunschDlg: TWunschDlg;

implementation

{$R *.dfm}

procedure TWunschDlg.PanelClick(Sender: TObject);
begin
  rogePanel.Visible:= (Sender as TPanel).Name = 'RotPanel';
  blgePanel.Visible:= (Sender as TPanel).Name = 'BlauPanel';
  grgePanel.Visible:= (Sender as TPanel).Name = 'GruenPanel';
  scgePanel.Visible:= (Sender as TPanel).Name = 'SchwarzPanel';
end;

function TWunschDlg.GetFarbe: TFarben;
begin
  Result := Ohne;
  if rogePanel.Visible then
    Result := Rot
  else if blgePanel.Visible then
    Result := Blau
  else if grgePanel.Visible then
    Result := Gruen
  else if scgePanel.Visible then
    Result := Schwarz
end;


end.