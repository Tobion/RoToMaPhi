{*******************************************************}
{                                                       }
{                       RoToMaPhi                       }
{                                                       }
{ Ein selbsterfundenes Multiplayer-Kartenspiel          }
{ über Internet/Netzwerk spielbar                       }
{                                                       }
{ Copyright © 2008                                      }
{   Tobias Schultze  (webmaster@tubo-world.de)          }
{                                                       }
{ Website: http://www.rotomaphi.de.vu                   }
{                                                       }
{ FHTW Berlin                                           }
{ Verteilte Systeme                                     }
{ Sommersemester 2008                                   }
{                                                       }
{*******************************************************}

unit uRoToMaPhi;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Menus, Buttons, ScktComp, SyncObjs,
  uResourceAccess, JPEG, GIFImg, uVerwaltung, uGlobalTypes, uSpieler;

type
  TRoToMaPhiForm = class(TForm)
    MainMenu: TMainMenu;
    SpielMenu: TMenuItem;
    EinloggenMenu: TMenuItem;
    AusloggenMenu: TMenuItem;
    MenuLine1: TMenuItem;
    BeendenMenu: TMenuItem;
    HilfeMenu: TMenuItem;
    ClientSocket: TClientSocket;
    OptionenMenu: TMenuItem;
    EinstellungenMenu: TMenuItem;
    OberflaechePanel: TPanel;
    BottomContainerPannel: TPanel;
    SpielerListView: TListView;
    ChatContainerPanel: TPanel;
    MsgPanel: TPanel;
    MsgSendenSpeedBtn: TSpeedButton;
    MsgEdit: TEdit;
    ChatRichEdit: TRichEdit;
    UserKartenPanel: TPanel;
    UserScrollBox: TScrollBox;
    TopKartenPanel: TPanel;
    StapelPanel: TPanel;
    BackgroundImage: TImage;
    StatusBar: TStatusBar;
    SpielPanel: TPanel;
    KreisShape1: TShape;
    KreisShape2: TShape;
    SpielzustandShape: TShape;
    WunschfarbePanel: TShape;
    AblageStapelShape: TShape;
    ZiehStapelShape: TShape;
    AblagestapelLabel: TLabel;
    AblagestapelImage: TImage;
    ZiehstapelLabel: TLabel;
    ZuZiehenLabel: TLabel;
    SperrLabel: TLabel;
    WunschfarbeLabel: TLabel;
    LetzteInfosLabel: TLabel;
    ZiehstapelImage: TImage;
    InfoLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    SperrAnzLabel: TLabel;
    AnzNotwendigerSpielerLabel: TLabel;
    EinloggenLabel: TLabel;
    MeinAvatarMenu: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure UpdateGUI;
    procedure UserScrollBoxResize(Sender: TObject);
    procedure EinloggenMenuClick(Sender: TObject);
    procedure AusloggenMenuClick(Sender: TObject);
    procedure HilfeMenuClick(Sender: TObject);
    procedure BeendenMenuClick(Sender: TObject);
    procedure EinstellungenMenuClick(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure UserKartenMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ZiehstapelImageClick(Sender: TObject);
    procedure BackgroundImageClick(Sender: TObject);
    procedure MsgSendenSpeedBtnClick(Sender: TObject);
    procedure MsgEditKeyPress(Sender: TObject; var Key: Char);
    procedure SpielerListViewDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MeinAvatarMenuClick(Sender: TObject);
  private
    lCS: TCriticalSection;
    Verwaltung: TVerwaltung;
    SpielerNotwendig: Byte;           // Anzahl der notwendigen Spieler des Spiels
    Ready: Boolean;                   // ob Spieler ready ist
    LoggedIn: Boolean;                // ob Spieler eingeloggt ist
    SelectedKarte: Longword;          // zuletzt ausgewählte KartenID
    MySelf: TSpieler;                 // mein eigenes Spielerobjekt
    MyUserID: Longword;               // meine UserID
    MyUserName: String[19];           // mein UserName (max. 19 Zeichen lang)
    MyPictureFile: String;
    DataStream: TMemoryStream;        // Empfangsstream

    procedure Reset;
    function CanPlay: Boolean;
    procedure SetGUI;

    function Net_DecodeMessage: Boolean;
    procedure Net_RemoveMessage(const ASize : Cardinal);
    function  Game_DecodeMessage(AMessageData: TStream; const MsgID, SenderID: Longword): Boolean;

    procedure Help_InitSpieler(AMessageBuffer: TStream);
    procedure Help_ShowPlayerInfo(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure Help_InitKarten(AMessageBuffer: TStream);
    procedure Help_InitKartenGemischt(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure Help_SetReadyStatus(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure Help_KarteLegen(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure Help_NextPlayer(AMessageBuffer: TStream);
    procedure Help_SetFarbWunsch(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure Help_SetSperren(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure Help_SetTauschen(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure Help_SetSpionage(AMessageBuffer: TStream; const Spion: TSpieler);
    procedure Help_ChatMsg(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure Help_SetKartenHalbieren(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure Help_Winner(const Spieler: TSpieler);
    procedure Help_UserQuit(const Spieler: TSpieler);

    procedure Net_SendUserName;
    procedure Net_SendPicture;
    procedure Net_DeletePicture;
    procedure Net_GetPlayerInfo(const Spieler: TSpieler);
    procedure Net_SendReadyStatus(Ready: Boolean);
    procedure Net_SendTurn(const GelegteKartenID: Longword);
    procedure Net_SendKarteZiehen;
    procedure Net_SendFarbWunsch(Farbe: TFarben);
    procedure Net_SendSperren(Sperre: Byte);
    procedure Net_SendTauschen(ID1, ID2: Longword);
    procedure Net_SendSpionage(IDSpielerFrom, IDSpielerTo, SpioKartenID: Longword);
    procedure Net_SendChat;
  public
  end;

var
  RoToMaPhiForm: TRoToMaPhiForm;

implementation

uses
  uEinloggenDlg, uEinstellungenDlg, uUserPictureDlg, uPlayerInfoDlg,
  uWunschDlg, uTauschDlg, uSperrDlg, uSpionageDlg;

{$R *.dfm}

procedure TRoToMaPhiForm.FormCreate(Sender: TObject);
begin
  lCS := TCriticalSection.Create;
  DataStream := TMemoryStream.Create;
  Verwaltung := TVerwaltung.Create;
  EinloggenDlg := TEinloggenDlg.Create(Self);
  UserPictureDlg := TUserPictureDlg.Create(Self);
  EinstellungenDlg := TEinstellungenDlg.Create(Self);
  PlayerInfoDlg := TPlayerInfoDlg.Create(Self);
  WunschDlg := TWunschDlg.Create(Self);
  SperrDlg := TSperrDlg.Create(Self);
  TauschDlg := TTauschDlg.Create(Self, Verwaltung);
  SpionageDlg := TSpionageDlg.Create(Self, Verwaltung);
  Reset;
  ZiehstapelImage.Picture.Graphic := EinstellungenDlg.GetBackSideImage;
  BackGroundImage.Picture.Graphic := GetImageFromResource(50 + Random(4), iJPEG);
  EinloggenMenuClick(Sender);
end;

procedure TRoToMaPhiForm.FormDestroy(Sender: TObject);
begin
  Reset;
  lCS.Free;
  DataStream.Free;
  Verwaltung.Free;
  EinloggenDlg.Free;
  UserPictureDlg.Free;
  EinstellungenDlg.Free;
  PlayerInfoDlg.Free;
  WunschDlg.Free;
  SperrDlg.Free;
  TauschDlg.Free;
  SpionageDlg.Free;
end;

procedure TRoToMaPhiForm.Reset;
begin
  if ClientSocket.Active then ClientSocket.Close;
  LoggedIn := false;
  Verwaltung.Reset(true);
  SelectedKarte := 0;
  MyUserID := 0;
  MyUserName := '';
  MySelf := nil;
  Ready := false;
  SpielerNotwendig := 0;
  SetGUI;
  UpdateGUI;
end;

procedure TRoToMaPhiForm.SetGUI;
begin
  EinloggenMenu.Enabled := not LoggedIn;
  AusloggenMenu.Enabled := LoggedIn;
  MeinAvatarMenu.Enabled := LoggedIn;
  MsgEdit.ReadOnly := not LoggedIn;
  MsgSendenSpeedBtn.Enabled := LoggedIn;
  UserKartenPanel.Visible := LoggedIn and Verwaltung.GameStarted;
  SpielPanel.Visible := LoggedIn and Verwaltung.GameStarted;
  BackGroundImage.Visible := not Verwaltung.GameStarted;
  AnzNotwendigerSpielerLabel.Visible := LoggedIn and not Verwaltung.GameStarted;
  EinloggenLabel.Visible := not LoggedIn;
  Ready := Verwaltung.GameStarted;
end;

procedure TRoToMaPhiForm.SpielerListViewDblClick(Sender: TObject);
begin
if Assigned(SpielerListView.Selected) then
  Net_GetPlayerInfo(TSpieler(SpielerListView.Selected.Data));
end;

procedure TRoToMaPhiForm.UpdateGUI;
var Sperre: String;
begin
if LoggedIn then
begin
with Verwaltung do
  begin
  if Verwaltung.MyTurn(MySelf) then
    begin
    UserKartenPanel.Color := clSilver;
    end
    else
      begin
      UserKartenPanel.Color := cl3DLight;
      end;
  TopKartenPanel.Caption := Format('%s: %d Karten', [MySelf.Name, MySelf.CountKarten]);
  MySelf.ShowKarten(UserScrollBox, UserKartenMouseDown);
  ShowSpieler(SpielerListView);
  ShowAblagestapel(AblagestapelImage);
  ZiehstapelLabel.Caption := Format('Karten:  %d', [GetZiehstapelKartenAnzahl]);
  AblagestapelLabel.Caption := Format('Karten:  %d', [GetAblagestapelKartenAnzahl]);
  case GetWunschFarbe of
    Schwarz: WunschfarbePanel.Brush.Color := clBlack;
    Rot: WunschfarbePanel.Brush.Color := clRed;
    Gruen: WunschfarbePanel.Brush.Color := clGreen;
    Blau: WunschfarbePanel.Brush.Color := clBlue;
    else WunschfarbePanel.Brush.Color := clCream;
  end;
  if (GetSperre <> 0) then
    begin
    case GetSperre of
      1:   Sperre := 'Sklaven';
      2:   Sperre := 'Bettler';
      3:   Sperre := 'Bauern';
      4:   Sperre := 'Handwerker';
      5:   Sperre := 'Händler';
      6:   Sperre := 'Adlige';
      7:   Sperre := 'Hellseher';
      8:   Sperre := 'Söldner';
      9:   Sperre := 'Ritter';
      10:  Sperre := 'Diplomaten';
      11:  Sperre := 'Magier';
      13:  Sperre := 'Mauern';
      14:  Sperre := 'Ereignisse';
      196: Sperre := 'Schwarz';
      197: Sperre := 'Rot';
      198: Sperre := 'Grün';
      199: Sperre := 'Blau';
      else Sperre := '???';
      end;
    SperrLabel.Caption := Format('Gesperrt:     %s', [Sperre]);
    SperrAnzLabel.Caption := Format('(%d x)', [GetSperrIndex]);
    end
    else
      begin
      SperrLabel.Caption := 'Gesperrt:';
      SperrAnzLabel.Caption := '';
      end;
  if (GetZiehkartenAnzahl > 0) then
    ZuZiehenLabel.Caption := Format('Zu Ziehen:     %d Karten', [GetZiehkartenAnzahl])
    else ZuZiehenLabel.Caption := 'Zu Ziehen:';

  // sorgt dafür, dass die möglichen Züge angezeigt werden
  UserKartenMouseDown(Self, mbLeft, [], 0, 0);
  end;
end
else
  begin
  SelectedKarte := 0;
  while UserScrollBox.ControlCount > 0 do
    UserScrollBox.Controls[0].Free;
  SpielerListView.Clear;
  ZiehstapelLabel.Caption := '';
  AblagestapelLabel.Caption := '';
  TopKartenPanel.Caption := '';
  WunschfarbePanel.Brush.Color := clBtnFace;
  AblagestapelImage.Picture := nil;
  InfoLabel.Caption := '';
  end;
end;

procedure TRoToMaPhiForm.UserScrollBoxResize(Sender: TObject);
begin
  if Assigned(MySelf) then MySelf.ResizeKarten(UserScrollBox);
end;

procedure TRoToMaPhiForm.EinloggenMenuClick(Sender: TObject);
begin
with EinloggenDlg do
  begin
  ShowModal;
  if (ModalResult = mrOK) then
    begin
    MyUserName := GetName;
    ClientSocket.Port := GetPort;
    ClientSocket.Host := GetHost;
    ClientSocket.Open;
    end;
  end;
end;

procedure TRoToMaPhiForm.AusloggenMenuClick(Sender: TObject);
begin
  Reset;
end;

procedure TRoToMaPhiForm.BeendenMenuClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TRoToMaPhiForm.HilfeMenuClick(Sender: TObject);
begin
Application.MessageBox(PChar('*******************************************************'+#10+#10+
'RoToMaPhi'+#10+#10+
'Ein selbsterfundenes Kartenspiel für zwei und mehr Spieler,'+#10+
'bei dem es darum geht, seine Karten möglichst schnell abzulegen.'+#10+
'Ähnlich wie Mau-Mau, aber mit neuen Funktionen und eigenem Kartenblatt.'+#10+
'Es ist über Internet/Netzwerk spielbar und unterstützt auch rudimentäre KI Gegner.'+#10+#10+
'Copyright © 2008 Tobias Schultze'+#10+
'FHTW Berlin - Verteilte Systeme - Sommersemester 2008 '+#10+#10+
'*******************************************************'), 'Hilfe' , MB_ICONINFORMATION);
end;

procedure TRoToMaPhiForm.EinstellungenMenuClick(Sender: TObject);
begin
with EinstellungenDlg do
  begin
  ShowModal;
  if (ModalResult = mrOK) then
    ZiehstapelImage.Picture.Graphic := GetBackSideImage;
  end;
end;

procedure TRoToMaPhiForm.MeinAvatarMenuClick(Sender: TObject);
begin
with UserPictureDlg do
  begin
  ShowModal;
  if (ModalResult = mrYes) then
    begin
    MyPictureFile := GetPicture;
    Net_SendPicture;
    end
  else if (ModalResult = mrNo) then
    begin
      Net_DeletePicture;
    end;
       
  end;
end;

procedure TRoToMaPhiForm.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  StatusBar.SimpleText := 'Verbunden mit Server';
end;

procedure TRoToMaPhiForm.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  StatusBar.SimpleText := 'Getrennt vom Server';
  Reset;
end;

procedure TRoToMaPhiForm.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  case ErrorEvent of
    eeDisconnect  : StatusBar.SimpleText := 'Network error on disconnect';
    eeGeneral     : StatusBar.SimpleText := 'General network error';
    eeReceive     : StatusBar.SimpleText := 'Network error on receive';
    eeSend        : StatusBar.SimpleText := 'Network error on send';
    eeAccept      : StatusBar.SimpleText := 'Network error on accept';
    eeConnect     : StatusBar.SimpleText := 'Network error on connect';
  else
    StatusBar.SimpleText := 'Unknown network error occured';
  end;
  ErrorCode := 0;
  Reset;
end;

function TRoToMaPhiForm.CanPlay: Boolean;
begin
  Result := LoggedIn and Verwaltung.MyTurn(MySelf);
end;

procedure TRoToMaPhiForm.UserKartenMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: Integer;
begin
  if not CanPlay then Exit;

  for i:=UserScrollBox.ControlCount-1 downto 0 do
  begin
    if (UserScrollBox.Controls[i] is TImage) then
      if Verwaltung.LegenMoeglich(MySelf, UserScrollBox.Controls[i].Tag) then
        UserScrollBox.Controls[i].Top := PossibilityMarginTop
      else
        UserScrollBox.Controls[i].Top := DefaultMarginTop;
  end;

  if not (Sender is TImage) then Exit;
  
  if (SelectedKarte = Longword((Sender as TImage).Tag)) then
    begin
    Net_SendTurn((Sender as TImage).Tag);
    end
    else if Verwaltung.LegenMoeglich(MySelf, (Sender as TImage).Tag) then
      begin
      SelectedKarte := (Sender as TImage).Tag;
      (Sender as TImage).Top := SelectedMarginTop;
      end
      else SelectedKarte := 0;
end;

procedure TRoToMaPhiForm.ZiehstapelImageClick(Sender: TObject);
begin
  if CanPlay then Net_SendKarteZiehen;
end;

procedure TRoToMaPhiForm.BackgroundImageClick(Sender: TObject);
begin
if LoggedIn and (SpielerNotwendig - Verwaltung.SpielerOnline <= 0) then
  begin
  Ready := not Ready;
  Net_SendReadyStatus(Ready);
  end;
end;

procedure TRoToMaPhiForm.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var nRead: Integer;
    //Buff: array[Word] of Byte;
    lBuffer: Pointer;
begin
  lCS.Enter;
  try
    nRead := Socket.ReceiveLength();
    GetMem(lBuffer, nRead);
    try
      Socket.ReceiveBuf(lBuffer^, nRead);
      DataStream.Position := DataStream.Size;
      DataStream.WriteBuffer(lBuffer^, nRead);
    finally
      FreeMem(lBuffer);
    end;
  finally
    lCS.Leave;
  end;

  (*
  DataStream.Position := DataStream.Size;

  while (Socket.ReceiveLength > 0) do
  begin
    nRead := Socket.ReceiveBuf(Buff, High(Buff) - Low(Buff));
    DataStream.WriteBuffer(Buff, nRead);
  end;
  *)

  while (Net_DecodeMessage) do
    Application.ProcessMessages;
{ es können mehrere Nachrichten im DataStream sein, da man zu diesem Zeitpunkt
  schon meherere Botschaften empfangen haben kann
  -> so lange komplette Nachrichten vorliegen, alle nacheinander bearbeiten }
end;


function  TRoToMaPhiForm.Net_DecodeMessage: Boolean;
var Header: THeader;
    lMessageData: TMemoryStream;
begin
  Result := false;
  if (DataStream.Size >= SizeOf(THeader)) then
  begin
    DataStream.Position := 0;
    DataStream.ReadBuffer(Header, SizeOf(THeader));
    if (DataStream.Size >= (Integer(Header.Size) + SizeOf(THeader))) then
    begin
      lMessageData := TMemoryStream.Create;
      try
        if (Header.Size > 0) then
          lMessageData.CopyFrom(DataStream, Header.Size);
        DataStream.Position := 0;
        Net_RemoveMessage(Header.Size + SizeOf(THeader));
        Game_DecodeMessage(lMessageData, Header.MsgID, Header.SenderID);
        Result := (DataStream.Size >= SizeOf(THeader));
      finally
        lMessageData.Free;
      end;
    end;
  end;
end;

procedure TRoToMaPhiForm.Net_RemoveMessage(const ASize : Cardinal);
var lStream: TMemoryStream;
begin
  if (DataStream.Size > Integer(ASize)) then
  begin
    lStream := TMemoryStream.Create;
    try
      DataStream.Position := ASize;
      lStream.CopyFrom(DataStream, DataStream.Size - Integer(ASize));
      DataStream.Size := 0;
      DataStream.CopyFrom(lStream, 0);
      //DataStream.LoadFromStream(lStream);
    finally
      lStream.Free;
    end;
  end
  else
    DataStream.Size := 0; // DataStream.Clear;
end;

function  TRoToMaPhiForm.Game_DecodeMessage(AMessageData: TStream; const MsgID, SenderID: Longword): Boolean;
var Spieler: TSpieler;
begin
  Result := false;
  Spieler := Verwaltung.GetSpieler(SenderID);
  AMessageData.Position := 0;
  case MsgID of
  Msg_Server_SetUserID:
    begin
    AMessageData.ReadBuffer(MyUserID, SizeOf(MyUserID));
    Net_SendUserName;
    Result := true;
    end;
  Msg_Server_GameConfig:
    begin
    AMessageData.ReadBuffer(SpielerNotwendig, SizeOf(SpielerNotwendig));
    UpdateGUI;
    Result := true;
    end;
  Msg_Server_SendSpieler:
    begin
    Help_InitSpieler(AMessageData);
    Result := true;
    end;
  Msg_Server_SendPlayerInfo:
    begin
    Help_ShowPlayerInfo(AMessageData, Spieler);
    Result := true;
    end;
  Msg_Server_InitKarten:
    begin
    Help_InitKarten(AMessageData);
    Result := true;
    end;
  Msg_User_Ready:
    begin
    Help_SetReadyStatus(AMessageData, Spieler);
    Result := true;
    end;
  Msg_Server_NextPlayer:
    begin
    Help_NextPlayer(AMessageData);
    Result := true;
    end;
  Msg_User_KarteLegen:
    begin
    Help_KarteLegen(AMessageData, Spieler);
    Result := true;
    end;
  Msg_User_KarteZiehen:
    begin
    Verwaltung.KarteZiehen(Spieler);
    UpdateGUI;
    Result := true;
    end;
  Msg_Server_FarbWunsch:
    begin
    with WunschDlg do
      begin
      ShowModal;
      Net_SendFarbWunsch(GetFarbe);
      end;
    Result := true;
    end;
  Msg_User_FarbWunsch:
    begin
    Help_SetFarbWunsch(AMessageData, Spieler);
    Result := true;
    end;
  Msg_Server_Sperren:
    begin
    with SperrDlg do
      begin
      ShowModal;
      Net_SendSperren(GetSperre);
      end;
    Result := true;
    end;
  Msg_User_Sperren:
    begin
    Help_SetSperren(AMessageData, Spieler);
    Result := true;
    end;
  Msg_Server_Tauschen:
     begin
     with TauschDlg do
       begin
       ShowModal;
       Net_SendTauschen(GetSpieler1,GetSpieler2);
       end;
     Result := true;
     end;
  Msg_User_Tauschen:
     begin
     Help_SetTauschen(AMessageData, Spieler);
     Result := true;
     end;
  Msg_Server_Spionage:
     begin
     with SpionageDlg do
       begin
       SpielerAuflisten(MySelf);
       ShowModal;
       if (ModalResult = mrOk) then
         Net_SendSpionage(GetIDSpielerFrom,GetIDSpielerTo,GetSpioKartenID)
       else if (ModalResult = mrYes) then
         Net_SendSpionage(GetIDSpielerFrom,MySelf.ID,GetSpioKartenID)
       end;
     Result := true;
     end;
  Msg_User_Spionage:
     begin
     Help_SetSpionage(AMessageData, Spieler);
     Result := true;
     end;
  Msg_Server_KartenHalbieren:
    begin
    Help_SetKartenHalbieren(AMessageData, Spieler);
    Result := true;
    end;
  Msg_User_ChatMsg:
    begin
    Help_ChatMsg(AMessageData, Spieler);
    Result := true;
    end;
  Msg_Server_UserQuit:
    begin
    Help_UserQuit(Spieler);
    Result := true;
    end;
  Msg_Server_KartenGemischt:
    begin
    Help_InitKartenGemischt(AMessageData, Spieler);
    Result := true;
    end;
  Msg_Server_Winner:
    begin
    Help_Winner(Spieler);
    Result := true;
    end;
  Msg_Server_NeuesSpiel:
    begin
    Verwaltung.Reset(false);
    SetGUI;
    UpdateGUI;
    Result := true;
    end
  else
    begin
    StatusBar.SimpleText := 'Unbekanntes Packet empfangen!';
    end;
  end;
end;

procedure TRoToMaPhiForm.MsgSendenSpeedBtnClick(Sender: TObject);
begin
if not LoggedIn then Exit;
MsgEdit.Text := Trim(MsgEdit.Text);
if (MsgEdit.Text <> '') then
  Net_SendChat;
MsgEdit.Clear;
end;


procedure TRoToMaPhiForm.MsgEditKeyPress(Sender: TObject; var Key: Char);
begin
if (Ord(Key) = VK_Return) then
  begin
  Key := #0;
  MsgSendenSpeedBtnClick(Sender);
  end;
end;

procedure TRoToMaPhiForm.Help_InitSpieler(AMessageBuffer: TStream);
var i: Integer;
    InitSpieler: TInitSpieler;
begin
for i := 0 to Pred(AMessageBuffer.Size div SizeOf(TInitSpieler)) do
  begin
  AMessageBuffer.ReadBuffer(InitSpieler, SizeOf(TInitSpieler));
  Verwaltung.NewSpieler(InitSpieler);
  end;
ChatRichEdit.Lines.Add('*** '+InitSpieler.Name+' betritt das Spiel!');
MySelf := Verwaltung.GetSpieler(MyUserID);
LoggedIn := true;
if (SpielerNotwendig - Verwaltung.SpielerOnline > 0) then
  AnzNotwendigerSpielerLabel.Caption := Format('*** Warte auf %d weitere Spieler...', [SpielerNotwendig - Verwaltung.SpielerOnline])
  else if (SpielerNotwendig - Verwaltung.SpielerOnline <= 0) then
    AnzNotwendigerSpielerLabel.Caption := '*** Hier klicken, um das Spiel zu starten.';
SetGUI;
UpdateGUI;
end;

procedure TRoToMaPhiForm.Help_ShowPlayerInfo(AMessageBuffer: TStream; const Spieler: TSpieler);
var Img: TGraphic ;
    UserStats: TStats;
    FileExt: TFileExt;
    PictureStream: TMemoryStream;
begin
  AMessageBuffer.ReadBuffer(UserStats, SizeOf(TStats));
  AMessageBuffer.ReadBuffer(FileExt, SizeOf(TFileExt));

  if (AMessageBuffer.Position < AMessageBuffer.Size) then
  begin
    PictureStream := TMemoryStream.Create;
    try
      PictureStream.CopyFrom(AMessageBuffer, AMessageBuffer.Size - AMessageBuffer.Position);
      PictureStream.Position := 0;
      Img := CreateGraphic(FileExt);
      try
        Img.LoadFromStream(PictureStream);
        PlayerInfoDlg.SetImage(Img);
      finally
        Img.Free;
      end;
    finally
      PictureStream.Free;
    end;
  end
  else PlayerInfoDlg.SetImage(nil);

  with PlayerInfoDlg do
  begin
    SetUserName(Spieler.Name);
    SetStats(UserStats.Games, UserStats.Wins);
    SetLastLogin(UserStats.LastLogin);
    Show;
  end;
end;

procedure TRoToMaPhiForm.Help_InitKarten(AMessageBuffer: TStream);
var i: Integer;
    InitKarten: TInitKarten;
begin
for i := 0 to Pred(AMessageBuffer.Size div SizeOf(TInitKarten)) do
  begin
  AMessageBuffer.ReadBuffer(InitKarten, SizeOf(TInitKarten));
  Verwaltung.KarteErzeugen(InitKarten);
  end;
Verwaltung.InitGame;
SetGUI;
UpdateGUI;
end;

procedure TRoToMaPhiForm.Help_InitKartenGemischt(AMessageBuffer: TStream; const Spieler: TSpieler);
var i: Integer;
    InitKarten: TInitKarten;
begin
Verwaltung.ClearStapel;
for i := 0 to Pred(AMessageBuffer.Size div SizeOf(TInitKarten)) do
  begin
  AMessageBuffer.ReadBuffer(InitKarten, SizeOf(TInitKarten));
  Verwaltung.KarteErzeugen(InitKarten);
  end;
Verwaltung.KarteAufdecken;
if (Verwaltung.Differenz > 0) then
  begin
  Verwaltung.ZiehkartenAnzahlDefinieren(Verwaltung.Differenz);
  Verwaltung.KarteZiehen(Spieler);
  Verwaltung.Differenz := 0;
  end;
UpdateGUI;
end;

procedure TRoToMaPhiForm.Help_SetReadyStatus(AMessageBuffer: TStream; const Spieler: TSpieler);
var Ready: Boolean;
begin
AMessageBuffer.ReadBuffer(Ready, SizeOf(Ready));
Spieler.Ready := Ready;
UpdateGUI;
end;

procedure TRoToMaPhiForm.Help_KarteLegen(AMessageBuffer: TStream; const Spieler: TSpieler);
var KartenID: Longword;
begin
AMessageBuffer.ReadBuffer(KartenID, SizeOf(KartenID));
Verwaltung.KarteAblegen(Spieler, KartenID);
UpdateGUI;
end;

procedure TRoToMaPhiForm.Help_NextPlayer(AMessageBuffer: TStream);
var SpielerID: Longword;
begin
AMessageBuffer.ReadBuffer(SpielerID, SizeOf(SpielerID));
Verwaltung.SetTurn(Verwaltung.GetSpieler(SpielerID));
UpdateGUI;
end;

procedure TRoToMaPhiForm.Help_SetFarbWunsch(AMessageBuffer: TStream; const Spieler: TSpieler);
var Farbe: TFarben;
begin
AMessageBuffer.ReadBuffer(Farbe, SizeOf(Farbe));
Verwaltung.SetWunschFarbe(Spieler, Farbe);
case Farbe of
  Schwarz: InfoLabel.Caption := Spieler.Name + ' hat sich schwarz gewünscht.';
  Rot:     InfoLabel.Caption := Spieler.Name + ' hat sich rot gewünscht.';
  Gruen:   InfoLabel.Caption := Spieler.Name + ' hat sich grün gewünscht.';
  Blau:    InfoLabel.Caption := Spieler.Name + ' hat sich blau gewünscht.';
  end;
UpdateGUI;
end;

procedure TRoToMaPhiForm.Help_SetSperren(AMessageBuffer: TStream; const Spieler: TSpieler);
var Sperre: Byte;
begin
AMessageBuffer.ReadBuffer(Sperre, SizeOf(Sperre));
Verwaltung.SetSperre(Sperre);
case Sperre of
  1:   InfoLabel.Caption := Spieler.Name + ' hat Sklaven gesperrt.';
  2:   InfoLabel.Caption := Spieler.Name + ' hat Bettler gesperrt.';
  3:   InfoLabel.Caption := Spieler.Name + ' hat Bauern gesperrt.';
  4:   InfoLabel.Caption := Spieler.Name + ' hat Handwerker gesperrt.';
  5:   InfoLabel.Caption := Spieler.Name + ' hat Händler gesperrt.';
  6:   InfoLabel.Caption := Spieler.Name + ' hat Adlige gesperrt.';
  7:   InfoLabel.Caption := Spieler.Name + ' hat Hellseher gesperrt.';
  8:   InfoLabel.Caption := Spieler.Name + ' hat Söldner gesperrt.';
  9:   InfoLabel.Caption := Spieler.Name + ' hat Ritter gesperrt.';
  10:  InfoLabel.Caption := Spieler.Name + ' hat Diplomaten gesperrt.';
  11:  InfoLabel.Caption := Spieler.Name + ' hat Magier gesperrt.';
  13:  InfoLabel.Caption := Spieler.Name + ' hat Mauern gesperrt.';
  14:  InfoLabel.Caption := Spieler.Name + ' hat Ereignisse gesperrt.';
  196: InfoLabel.Caption := Spieler.Name + ' hat schwarz gesperrt.';
  197: InfoLabel.Caption := Spieler.Name + ' hat rot gesperrt.';
  198: InfoLabel.Caption := Spieler.Name + ' hat grün gesperrt.';
  199: InfoLabel.Caption := Spieler.Name + ' hat blau gesperrt.';
  end;
UpdateGUI;
end;

procedure TRoToMaPhiForm.Help_SetTauschen(AMessageBuffer: TStream; const Spieler: TSpieler);
var ID1, ID2: Longword;
    TmpSpieler1, TmpSpieler2: TSpieler;
begin
AMessageBuffer.ReadBuffer(ID1, SizeOf(ID1));
AMessageBuffer.ReadBuffer(ID2, SizeOf(ID2));
TmpSpieler1 := Verwaltung.GetSpieler(ID1);
TmpSpieler2 := Verwaltung.GetSpieler(ID2);
Verwaltung.KartenTauschen(TmpSpieler1, TmpSpieler2);
if (Spieler = TmpSpieler1) then
  InfoLabel.Caption := Format('%s hat mit %s die Karten getauscht.', [Spieler.Name, TmpSpieler2.Name])
else if (Spieler = TmpSpieler2) then
  InfoLabel.Caption := Format('%s hat mit %s die Karten getauscht.', [Spieler.Name, TmpSpieler1.Name])
else
  InfoLabel.Caption := Format('%s hat %s und %s'+#13#10+'die Karten tauschen lassen.', [Spieler.Name, TmpSpieler1.Name, TmpSpieler2.Name]) ;
UpdateGUI;
end;

procedure TRoToMaPhiForm.Help_SetSpionage(AMessageBuffer: TStream; const Spion: TSpieler);
var IDSpielerFrom, IDSpielerTo, SpioKartenID: Longword;
    TmpSpielerFrom, TmpSpielerTo: TSpieler;
begin
AMessageBuffer.ReadBuffer(IDSpielerFrom, SizeOf(IDSpielerFrom));
AMessageBuffer.ReadBuffer(IDSpielerTo, SizeOf(IDSpielerTo));
AMessageBuffer.ReadBuffer(SpioKartenID, SizeOf(SpioKartenID));
TmpSpielerFrom := Verwaltung.GetSpieler(IDSpielerFrom);
TmpSpielerTo := Verwaltung.GetSpieler(IDSpielerTo);
Verwaltung.Spionage(TmpSpielerFrom, TmpSpielerTo, SpioKartenID);
if (TmpSpielerTo = Spion) then
  InfoLabel.Caption := Format('%s hat %s ausspioniert'+#13#10+'und die Karte behalten.', [Spion.Name, TmpSpielerFrom.Name])
else if (TmpSpielerFrom = TmpSpielerTo) then
  InfoLabel.Caption := Format('%s hat %s ausspioniert'+#13#10+'und ihm die Karte zurückgegeben.', [Spion.Name, TmpSpielerFrom.Name])
else
  InfoLabel.Caption := Format('%s hat %s ausspioniert'+#13#10+'und die Karte an %s weitergegeben.', [Spion.Name, TmpSpielerFrom.Name, TmpSpielerTo.Name]);
UpdateGUI;
end;

procedure TRoToMaPhiForm.Help_SetKartenHalbieren(AMessageBuffer: TStream; const Spieler: TSpieler);
begin
Verwaltung.KartenHalbieren(AMessageBuffer, Spieler);
InfoLabel.Caption := 'Die Karten von ' + Spieler.Name + ' wurden halbiert.';
UpdateGUI;
end;

procedure TRoToMaPhiForm.Help_ChatMsg(AMessageBuffer: TStream; const Spieler: TSpieler);
var ChatText: String[255];
begin
AMessageBuffer.ReadBuffer(ChatText, SizeOf(ChatText));
ChatRichEdit.Lines.Add(Spieler.Name + ': ' + ChatText);
end;

procedure TRoToMaPhiForm.Help_Winner(const Spieler: TSpieler);
begin
Verwaltung.Reset(false);
if (Spieler = MySelf) then
  Application.MessageBox(PChar('Herzlichen Glückwunsch.'+#10+'Du hast gewonnen!'), 'Game Over' , MB_ICONINFORMATION)
  else Application.MessageBox(PChar(Spieler.Name + ' hat gewonnen!'), 'Game Over' , MB_ICONINFORMATION);
SetGUI;
UpdateGUI;
end;


procedure TRoToMaPhiForm.Help_UserQuit(const Spieler: TSpieler);
begin
ChatRichEdit.Lines.Add('*** '+Spieler.Name+' hat das Spiel verlassen!');
Verwaltung.DeleteSpieler(Spieler);
if (SpielerNotwendig - Verwaltung.SpielerOnline > 0) then
  AnzNotwendigerSpielerLabel.Caption := Format('*** Warte auf %d weitere Spieler...', [SpielerNotwendig - Verwaltung.SpielerOnline])
  else if (SpielerNotwendig - Verwaltung.SpielerOnline <= 0) then
    AnzNotwendigerSpielerLabel.Caption := '*** Hier klicken, um das Spiel zu starten.';
UpdateGUI;
end;


procedure TRoToMaPhiForm.Net_SendUserName;
var Header: THeader;
begin
  Header.MsgID    := Msg_User_SendName;
  Header.Size     := SizeOf(MyUserName);
  Header.SenderID := MyUserID;
  ClientSocket.Socket.SendBuf(Header, SizeOf(THeader));
  ClientSocket.Socket.SendBuf(MyUserName, SizeOf(MyUserName));
end;

procedure TRoToMaPhiForm.Net_SendPicture;
var Header: THeader;
  Stream: TFileStream;
  FileExt: TFileExt;
begin
  FileExt := ExtractFileExt(MyPictureFile);
  Delete(FileExt, 1, 1); // remove dot
  if not IsSupportedImg(FileExt) then
  begin
    Application.MessageBox(PChar('Unbekannte Dateiendung.'), 'Fehler' , MB_ICONERROR);
  end
  else
  begin
    try
      Stream := TFileStream.Create(MyPictureFile, fmOpenRead);
      Stream.Position := 0;
      //Showmessage('Bild senden: ' + IntToStr(Stream.Size));
      Header.MsgID    := Msg_User_SendPicture;
      Header.Size := SizeOf(TFileExt) + Stream.Size;
      Header.SenderID := MyUserID;
      ClientSocket.Socket.SendBuf(Header, SizeOf(THeader));
      ClientSocket.Socket.SendBuf(FileExt, SizeOf(TFileExt));
      ClientSocket.Socket.SendStream(Stream);
    except
      on E: EFOpenError do
        Application.MessageBox(PChar('Datei kann nicht gelesen werden.'), 'Fehler' , MB_ICONERROR);
    end;
  end;
end;

procedure TRoToMaPhiForm.Net_DeletePicture;
var Header: THeader;
begin
  Header.MsgID    := Msg_User_DeletePicture;
  Header.Size := 0;
  Header.SenderID := MyUserID;
  ClientSocket.Socket.SendBuf(Header, SizeOf(THeader));
end;

procedure TRoToMaPhiForm.Net_GetPlayerInfo(const Spieler: TSpieler);
var Header: THeader;
begin
  Header.MsgID    := Msg_User_GetPlayerInfo;
  Header.Size     := SizeOf(Spieler.ID);
  Header.SenderID := MyUserID;
  ClientSocket.Socket.SendBuf(Header, SizeOf(THeader));
  ClientSocket.Socket.SendBuf(Spieler.ID, SizeOf(Spieler.ID));
end;

procedure TRoToMaPhiForm.Net_SendReadyStatus(Ready: Boolean);
var Header: THeader;
begin
  Header.MsgID    := Msg_User_Ready;
  Header.Size     := SizeOf(Ready);
  Header.SenderID := MyUserID;
  ClientSocket.Socket.SendBuf(Header, SizeOf(THeader));
  ClientSocket.Socket.SendBuf(Ready, SizeOf(Ready));
end;

procedure TRoToMaPhiForm.Net_SendTurn(const GelegteKartenID: Longword);
var Header: THeader;
    KartenID: Longword;
begin
  Header.MsgID    := Msg_User_KarteLegen;
  Header.Size     := SizeOf(KartenID);
  Header.SenderID := MyUserID;
  KartenID        := GelegteKartenID;
  ClientSocket.Socket.SendBuf(Header, SizeOf(THeader));
  ClientSocket.Socket.SendBuf(KartenID, SizeOf(KartenID));
end;

procedure TRoToMaPhiForm.Net_SendKarteZiehen;
var Header: THeader;
begin
  Header.MsgID    := Msg_User_KarteZiehen;
  Header.Size     := 0;
  Header.SenderID := MyUserID;
  ClientSocket.Socket.SendBuf(Header, SizeOf(THeader));
end;

procedure TRoToMaPhiForm.Net_SendFarbWunsch(Farbe: TFarben);
var Header: THeader;
begin
  Header.MsgID    := Msg_User_FarbWunsch;
  Header.Size     := SizeOf(Farbe);
  Header.SenderID := MyUserID;
  ClientSocket.Socket.SendBuf(Header, SizeOf(THeader));
  ClientSocket.Socket.SendBuf(Farbe, SizeOf(Farbe));
end;

procedure TRoToMaPhiForm.Net_SendSperren(Sperre: Byte);
var Header: THeader;
begin
  Header.MsgID    := Msg_User_Sperren;
  Header.Size     := SizeOf(Sperre);
  Header.SenderID := MyUserID;
  ClientSocket.Socket.SendBuf(Header, SizeOf(THeader));
  ClientSocket.Socket.SendBuf(Sperre, SizeOf(Sperre));
end;

procedure TRoToMaPhiForm.Net_SendTauschen(ID1, ID2: Longword);
var Header: THeader;
begin
  Header.MsgID    := Msg_User_Tauschen;
  Header.Size     := SizeOf(ID1) + SizeOf(ID2);
  Header.SenderID := MyUserID;
  ClientSocket.Socket.SendBuf(Header, Sizeof(THeader));
  ClientSocket.Socket.SendBuf(ID1, SizeOf(ID1));
  ClientSocket.Socket.SendBuf(ID2, SizeOf(ID2));
end;

procedure TRoToMaPhiForm.Net_SendSpionage(IDSpielerFrom, IDSpielerTo, SpioKartenID: Longword);
var Header: THeader;
begin
  Header.MsgID    := Msg_User_Spionage;
  Header.Size     := SizeOf(IDSpielerFrom) + SizeOf(IDSpielerTo) + SizeOf(SpioKartenID);
  Header.SenderID := MyUserID;
  ClientSocket.Socket.SendBuf(Header, Sizeof(THeader));
  ClientSocket.Socket.SendBuf(IDSpielerFrom, SizeOf(IDSpielerFrom));
  ClientSocket.Socket.SendBuf(IDSpielerTo, SizeOf(IDSpielerTo));
  ClientSocket.Socket.SendBuf(SpioKartenID, SizeOf(SpioKartenID));
end;

procedure TRoToMaPhiForm.Net_SendChat;
var Header: THeader;
    ChatText: String[255];
begin
  Header.MsgID    := Msg_User_ChatMsg;
  Header.Size     := SizeOf(ChatText);
  Header.SenderID := MyUserID;
  ChatText        := MsgEdit.Text;
  ClientSocket.Socket.SendBuf(Header, SizeOf(THeader));
  ClientSocket.Socket.SendBuf(ChatText, SizeOf(ChatText));
end;



end.
