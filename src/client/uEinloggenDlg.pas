unit uEinloggenDlg;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  ExtCtrls, Spin, Dialogs, ExtDlgs;

type
  TEinloggenDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel: TBevel;
    StaticText1: TStaticText;
    SpielernameLabelEdit: TLabeledEdit;
    HostLabelEdit: TLabeledEdit;
    PortSpinEdit: TSpinEdit;
    PortLabel: TLabel;
    procedure SpielernameLabelEditChange(Sender: TObject);
  private
  public
    function GetName: String;
    function GetHost: String;
    function GetPort: Integer;
  end;

var
  EinloggenDlg: TEinloggenDlg;

implementation

{$R *.dfm}

function TEinloggenDlg.GetName: String;
begin
  Result := SpielernameLabelEdit.Text;
end;

function TEinloggenDlg.GetHost: String;
begin
  Result := HostLabelEdit.Text;
end;

function TEinloggenDlg.GetPort: Integer;
begin
  Result := StrToInt(PortSpinEdit.Text);
end;

procedure TEinloggenDlg.SpielernameLabelEditChange(Sender: TObject);
begin
  OKBtn.Enabled := (Trim(SpielernameLabelEdit.Text) <> '') and (Trim(HostLabelEdit.Text) <> '');
end;

end.
