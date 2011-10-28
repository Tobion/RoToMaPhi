{*******************************************************}
{                                                       }
{                   RoToMaPhi Server                    }
{                                                       }
{ Ein selbsterfundenes Multiplayer-Kartenspiel          }
{ über Internet/Netzwerk spielbar                       }
{                                                       }
{ Copyright © 2005/2006                                 }
{   Tobias Schultze  (webmaster@tubo-world.de)          }
{   Robert Stascheit (roberto-online@web.de)            }
{   Manuel Mähl      (manu@maehls.de)                   }
{   Philipp Müller   (philippmue@aol.com)               }
{ Website: http://www.rotomaphi.de.vu                   }
{                                                       }
{ Informatik Jahrgang 13 Herr Willemeit                 }
{                                                       }
{*******************************************************}

unit uRoToMaPhiServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Spin, ScktComp, uVerwaltung,
  uGlobalTypes, uSpieler, uKI;

type
  TRoToMaPhiServerForm = class(TForm)
    ServerSocket: TServerSocket;
    StatusBar: TStatusBar;
    SpielerListView: TListView;
    OptionsPanel: TPanel;
    ServerStartenBtn: TButton;
    PortSpinEdit: TSpinEdit;
    PortLabel: TLabel;
    SpielerAnzLabel: TLabel;
    SpielerAnzComboBox: TComboBox;
    NeuesSpielBtn: TButton;
    NeueKIBtn: TButton;
    UserScrollBox: TScrollBox;
    BeendenBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ServerStartenBtnClick(Sender: TObject);
    procedure NeuesSpielBtnClick(Sender: TObject);
    procedure NeueKIBtnClick(Sender: TObject);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure BeendenBtnClick(Sender: TObject);
  private
    Verwaltung: TVerwaltung;
    procedure Reset(const SpielerLoeschen: Boolean);
    procedure UpdateGUI;
    procedure CheckStartGame;
    function CheckGameOver: Boolean;

    procedure Delay(const Milliseconds: DWord);
    procedure DoKIZug(const AKI: TKI);
    procedure DoKIKarteLegen(const AKI: TKI; KartenID: Longword);
    procedure DoKIFarbWunsch(const AKI: TKI);
    procedure DoKITauschen(const AKI: TKI);
    procedure DoKISpionage(const AKI: TKI);
    procedure DoKISperren(const AKI: TKI);
    procedure DoKIKartenHalbieren(const AKI: TKI);

    function  Net_DecodeMessage(DataStream: TStream): Boolean;
    procedure Net_RemoveMessage(DataStream: TStream; const ASize : Cardinal);
    function  Game_DecodeMessage(AMessageData: TStream; const MsgID, SenderID: Longword): Boolean;

    procedure Help_SetUserName(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure Help_SetReadyStatus(AMessageBuffer: TStream; const Spieler: TSpieler);
    function Help_KarteLegen(AMessageBuffer: TStream; const Spieler: TSpieler): Longword;
    procedure Help_SetFarbWunsch(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure Help_SetSperren(AMessageBuffer: TStream);
    procedure Help_SetTauschen(AMessageBuffer: TStream);
    procedure Help_SetSpionage(AMessageBuffer: TStream);

    procedure Net_SendUserID(const Spieler: TSpieler);
    procedure Net_SendGameConfig(const Spieler: TSpieler);
    procedure Net_SendSpielerListe(const Spieler: TSpieler);
    procedure Net_SendUserEnter(const Spieler: TSpieler);
    procedure Net_SendInitKarten;
    procedure Net_SendNextPlayer(const Spieler: TSpieler = nil; const AWhoNot: TSpieler = nil);
    procedure Net_SendKartenHalbieren(const Spieler: TSpieler);
    procedure Net_SendKartenGemischt(const SenderID: Cardinal);
    procedure Net_SendWinner(const Spieler: TSpieler);
    procedure Net_SendNeuesSpiel;
    procedure Net_SendUserQuit(const Spieler: TSpieler);
    procedure Net_SendToAll(AMessageBuffer: TStream; const AMsgID, ASenderID: Longword; const AWhoNot: TSpieler = nil);
    procedure Net_SendToUser(AMessageBuffer: TStream; const Spieler: TSpieler; AMsgID, ASenderID: Longword);
  public
  end;

var
  RoToMaPhiServerForm: TRoToMaPhiServerForm;

implementation

{$R *.dfm}

procedure TRoToMaPhiServerForm.FormCreate(Sender: TObject);
begin
  Verwaltung := TVerwaltung.Create;
  UpdateGUI;
end;

procedure TRoToMaPhiServerForm.Reset(const SpielerLoeschen: Boolean);
begin
  Verwaltung.Reset(SpielerLoeschen);
  Verwaltung.InitKarten;
end;

procedure TRoToMaPhiServerForm.UpdateGUI;
begin
  SpielerAnzComboBox.Enabled := not ServerSocket.Active;
  PortSpinEdit.Enabled := not ServerSocket.Active;
  Verwaltung.ShowSpieler(SpielerListView);
  StatusBar.SimpleText := Format('%d Spieler online', [Verwaltung.SpielerOnline]);
  NeuesSpielBtn.Enabled := ServerSocket.Active and Verwaltung.GameStarted;
  NeueKIBtn.Enabled := ServerSocket.Active and not Verwaltung.GameStarted and (Verwaltung.SpielerOnline < StrToInt(SpielerAnzComboBox.Text));
end;

procedure TRoToMaPhiServerForm.Delay(const Milliseconds: DWord);
var  FirstTickCount: DWord;
begin
  FirstTickCount := GetTickCount;
  while ((GetTickCount - FirstTickCount) < Milliseconds) do
    Application.ProcessMessages;
end;

procedure TRoToMaPhiServerForm.ServerStartenBtnClick(Sender: TObject);
begin
  ServerSocket.Port := StrToInt(PortSpinEdit.Text);
  ServerSocket.Active := not ServerSocket.Active;
  Reset(true);
  if ServerSocket.Active then
    ServerStartenBtn.Caption := 'Server schließen'
  else
    ServerStartenBtn.Caption := 'Server starten';
  UpdateGUI;
end;

procedure TRoToMaPhiServerForm.CheckStartGame;
begin
  if not Verwaltung.GameStarted and Verwaltung.AllReady and
    (Verwaltung.SpielerOnline >= StrToInt(SpielerAnzComboBox.Text)) then
      begin
      Net_SendInitKarten;
      Net_SendNextPlayer;
      end;
end;

function TRoToMaPhiServerForm.CheckGameOver: Boolean;
// Überprüft, ob Spiel beendet ist / jemand gewonnen hat
var Winner: TSpieler;
begin
  Result := true;
  if Verwaltung.GameStarted then
    begin
    Winner := Verwaltung.GetWinner;
    if Assigned(Winner) then
      Net_SendWinner(Winner)
      else Result := false;
    end;
end;

procedure TRoToMaPhiServerForm.NeuesSpielBtnClick(Sender: TObject);
begin
  Reset(false);
  UpdateGUI;
  Net_SendNeuesSpiel;
end;

procedure TRoToMaPhiServerForm.NeueKIBtnClick(Sender: TObject);
begin
if not Verwaltung.GameStarted and (Verwaltung.SpielerOnline  < StrToInt(SpielerAnzComboBox.Text)) then
  begin
  Net_SendUserEnter(Verwaltung.NewKI);
  UpdateGUI;
  CheckStartGame;
  end
  else Showmessage('Bereits genug Spieler vorhanden!');
end;

procedure TRoToMaPhiServerForm.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var MemStream: TMemoryStream;
    Spieler: TSpieler;
begin
if (Verwaltung.SpielerOnline < StrToInt(SpielerAnzComboBox.Text))
  and not Verwaltung.GameStarted then // wenn neue Spieler sich einloggen dürfen
  begin
  MemStream := TMemoryStream.Create; // MemoryStream für jeden Client erstellen in den seine Daten geschrieben werden
  Socket.Data := MemStream; // den Pointer zu diesem Stream auf Socket.Data legen
  Spieler := Verwaltung.NewSpieler(Socket); // neuen Spieler erzeugen
  Net_SendUserID(Spieler); // ihm seine ID senden
  Net_SendGameConfig(Spieler); // ihm die GameConfig senden (Anzahl der benötigten Spieler)
  end
    else Socket.Close; // sonst Socket disconnecten
UpdateGUI;
end;

procedure TRoToMaPhiServerForm.ServerSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var Spieler: TSpieler;
begin
  Spieler := Verwaltung.GetSpieler(Socket);
  // Spieler bekommen, der das Spiel verlässt (anhand des Sockets eindeutig identifizierbar)
  if Assigned(Spieler) then
    begin
    if Verwaltung.MyTurn(Spieler) then // wenn Spieler quits, der am Zug war
      Net_SendNextPlayer(Spieler, Spieler); // nächster Spieler am Zug
    Net_SendUserQuit(Spieler); // User quit senden
    Verwaltung.DeleteSpieler(Spieler); // Spieler löschen
    TMemoryStream(Socket.Data).Free; // dessen MemoryStream löschen
    CheckGameOver; // überprüfen, ob Spiel beendet (nur noch 1 Spieler übrig) -> Gewinner senden
    UpdateGUI;
    end;
end;

procedure TRoToMaPhiServerForm.ServerSocketClientError(Sender: TObject;
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
  UpdateGUI;
end;

procedure TRoToMaPhiServerForm.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var nRead: Integer;
    OldPos: Int64;
    Buff: array[Word] of Byte;
    DataStream: TMemoryStream;
begin
  DataStream := Socket.Data;
  OldPos := DataStream.Position;
  DataStream.Position := DataStream.Size;
  repeat
    nRead := Socket.ReceiveBuf(Buff, High(Buff) - Low(Buff));
    DataStream.WriteBuffer(Buff, nRead);
  until (Socket.ReceiveLength = 0);
  DataStream.Position := OldPos;

  while (Net_DecodeMessage(DataStream)) do
    Application.ProcessMessages;
{ es können mehrere Nachrichten im DataStream sein, da man zu diesem Zeitpunkt
  schon meherere Botschaften empfangen haben kann
  -> so lange komplette Nachrichten vorliegen, alle nacheinander bearbeiten }
end;

function  TRoToMaPhiServerForm.Net_DecodeMessage(DataStream: TStream): Boolean;
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
        Net_RemoveMessage(DataStream, Header.Size + SizeOf(THeader));
        Game_DecodeMessage(lMessageData, Header.MsgID, Header.SenderID);
        Result := (DataStream.Size >= SizeOf(THeader));
      finally
        lMessageData.Free;
      end;
    end;
  end;
end;

procedure TRoToMaPhiServerForm.Net_RemoveMessage(DataStream: TStream; const ASize : Cardinal);
var lStream: TMemoryStream;
begin
  if (DataStream.Size >= Integer(ASize)) then
  begin
    lStream := TMemoryStream.Create;
    try
      DataStream.Position := ASize;
      if ((DataStream.Size - Integer(ASize)) > 0 ) then
        lStream.CopyFrom(DataStream, DataStream.Size - Integer(ASize));
      DataStream.Size := 0;
      DataStream.CopyFrom(lStream, 0);
    finally
      lStream.Free;
    end;
  end
  else
    DataStream.Size := 0;
end;

function TRoToMaPhiServerForm.Game_DecodeMessage(AMessageData: TStream; const MsgID, SenderID: Longword): Boolean;
var Spieler: TSpieler;
    ReturnMsgID: Longword;
    Differenz: Integer;
begin
  Result := false;
  AMessageData.Position := 0;
  Spieler := Verwaltung.GetSpieler(SenderID);
  case MsgID of
  Msg_User_SendName:
    begin
    Help_SetUserName(AMessageData, Spieler);
    Net_SendSpielerListe(Spieler);
    Net_SendUserEnter(Spieler);
    UpdateGUI;
    Result := true;
    end;
  Msg_User_Ready:
    begin
    Help_SetReadyStatus(AMessageData, Spieler);
    Net_SendToAll(AMessageData, MsgID, SenderID);
    CheckStartGame;
    UpdateGUI;
    Result := true;
    end;
  Msg_User_KarteLegen:
    begin
    ReturnMsgID := Help_KarteLegen(AMessageData, Spieler);
    Net_SendToAll(AMessageData, MsgID, SenderID);
    if not CheckGameOver then
      if (ReturnMsgID = Msg_Server_KartenHalbieren) then
        Net_SendKartenHalbieren(Spieler) // weißer Magier gelegt
      else if (ReturnMsgID <> 0) then
        Net_SendToUser(nil, Spieler, ReturnMsgID, 0) // andere Sonderfunktion
      else
        Net_SendNextPlayer(Spieler);  // nächster Spieler am Zug
    UpdateGUI;
    Result := true;
    end;
  Msg_User_KarteZiehen:
    begin
    if (Verwaltung.GetZiehstapelKartenAnzahl < Verwaltung.GetZiehkartenAnzahl) then
      begin
      Differenz := Verwaltung.GetZiehkartenAnzahl - Verwaltung.GetZiehstapelKartenAnzahl;
      Verwaltung.KarteZiehen(Spieler);
      Verwaltung.ZiehkartenAnzahlDefinieren(Differenz);
      Net_SendToAll(AMessageData, MsgID, SenderID);
      Net_SendKartenGemischt(SenderID);
      Verwaltung.KarteZiehen(Spieler);
      end
      else
        begin
        Verwaltung.KarteZiehen(Spieler);
        Net_SendToAll(AMessageData, MsgID, SenderID);
        end;
    if (Verwaltung.GetZiehstapelKartenAnzahl = 0) then
      Net_SendKartenGemischt(SenderID);
    Net_SendNextPlayer(Spieler);
    UpdateGUI;
    Result := true;
    end;
  Msg_User_FarbWunsch:
    begin
    Help_SetFarbWunsch(AMessageData, Spieler);
    Net_SendToAll(AMessageData, MsgID, SenderID);
    Net_SendNextPlayer(Spieler);
    Result := true;
    end;
  Msg_User_Sperren:
    begin
    Help_SetSperren(AMessageData);
    Net_SendToAll(AMessageData, MsgID, SenderID);
    Net_SendNextPlayer(Spieler);
    Result := true;
    end;
  Msg_User_Tauschen:
    begin
    Help_SetTauschen(AMessageData);
    Net_SendToAll(AMessageData, MsgID, SenderID);
    Net_SendNextPlayer(Spieler);
    Result := true;
    end;
  Msg_User_Spionage:
    begin
    Help_SetSpionage(AMessageData);
    Net_SendToAll(AMessageData, MsgID, SenderID);
    if not CheckGameOver then
      Net_SendNextPlayer(Spieler);
    Result := true;
    end;
  Msg_User_ChatMsg:
    begin
    Net_SendToAll(AMessageData, MsgID, SenderID);
    Result := true;
    end
  else
    begin
    StatusBar.SimpleText := 'Unbekanntes Packet empfangen!';
    end;
  end;
end;

procedure TRoToMaPhiServerForm.Help_SetUserName(AMessageBuffer: TStream; const Spieler: TSpieler);
var UserName: String[19];
begin
AMessageBuffer.ReadBuffer(UserName, SizeOf(UserName));
Spieler.Name := UserName;
end;

procedure TRoToMaPhiServerForm.Help_SetReadyStatus(AMessageBuffer: TStream; const Spieler: TSpieler);
var Ready: Boolean;
begin
AMessageBuffer.ReadBuffer(Ready, SizeOf(Ready));
Spieler.Ready := Ready;
end;

function TRoToMaPhiServerForm.Help_KarteLegen(AMessageBuffer: TStream; const Spieler: TSpieler): Longword;
var KartenID: Longword;
begin
AMessageBuffer.ReadBuffer(KartenID, SizeOf(KartenID));
Result := Verwaltung.KarteAblegen(Spieler, KartenID);
end;

procedure TRoToMaPhiServerForm.Help_SetFarbWunsch(AMessageBuffer: TStream; const Spieler: TSpieler);
var Farbe: TFarben;
begin
AMessageBuffer.ReadBuffer(Farbe, SizeOf(Farbe));
Verwaltung.SetWunschFarbe(Spieler, Farbe);
end;

procedure TRoToMaPhiServerForm.Help_SetSperren(AMessageBuffer: TStream);
var Sperre: Byte;
begin
AMessageBuffer.ReadBuffer(Sperre, SizeOf(Sperre));
Verwaltung.SetSperre(Sperre);
end;

procedure TRoToMaPhiServerForm.Help_SetTauschen(AMessageBuffer: TStream);
var ID1, ID2: Longword;
    TmpSpieler1, TmpSpieler2: TSpieler;
begin
AMessageBuffer.ReadBuffer(ID1, SizeOf(ID1));
AMessageBuffer.ReadBuffer(ID2, SizeOf(ID2));
TmpSpieler1 := Verwaltung.GetSpieler(ID1);
TmpSpieler2 := Verwaltung.GetSpieler(ID2);
Verwaltung.KartenTauschen(TmpSpieler1, TmpSpieler2);
end;

procedure TRoToMaPhiServerForm.Help_SetSpionage(AMessageBuffer: TStream);
var IDSpielerFrom, IDSpielerTo, SpioKartenID: Longword;
    TmpSpielerFrom, TmpSpielerTo: TSpieler;
begin
AMessageBuffer.ReadBuffer(IDSpielerFrom, SizeOf(IDSpielerFrom));
AMessageBuffer.ReadBuffer(IDSpielerTo, SizeOf(IDSpielerTo));
AMessageBuffer.ReadBuffer(SpioKartenID, SizeOf(SpioKartenID));
TmpSpielerFrom := Verwaltung.GetSpieler(IDSpielerFrom);
TmpSpielerTo := Verwaltung.GetSpieler(IDSpielerTo);
Verwaltung.Spionage(TmpSpielerFrom, TmpSpielerTo, SpioKartenID);
end;

procedure TRoToMaPhiServerForm.Net_SendUserID(const Spieler: TSpieler);
var Data: TMemoryStream;
    AID: Longword;
begin
  AID := Spieler.ID;
  Data := TMemoryStream.Create;
  try
    Data.WriteBuffer(AID, SizeOf(AID));
    Net_SendToUser(Data, Spieler, Msg_Server_SetUserID, 0);
  finally
    Data.Free;
  end;
end;

procedure TRoToMaPhiServerForm.Net_SendGameConfig(const Spieler: TSpieler);
var Data: TMemoryStream;
    SpielerAnz: Byte;
begin
  SpielerAnz := StrToInt(SpielerAnzComboBox.Text);
  Data := TMemoryStream.Create;
  try
    Data.WriteBuffer(SpielerAnz, SizeOf(SpielerAnz));
    Net_SendToUser(Data, Spieler, Msg_Server_GameConfig, 0);
  finally
    Data.Free;
  end;
end;

procedure TRoToMaPhiServerForm.Net_SendSpielerListe(const Spieler: TSpieler);
var Data: TMemoryStream;
begin
  Data := Verwaltung.GetSpielerListeStream;
  try
    Net_SendToUser(Data, Spieler, Msg_Server_SendSpieler, 0);
  finally
    Data.Free;
  end;
end;

procedure TRoToMaPhiServerForm.Net_SendUserEnter(const Spieler: TSpieler);
var Data: TMemoryStream;
    InitSpieler: TInitSpieler;
begin
  Data := TMemoryStream.Create;
  try
    InitSpieler.Name := Spieler.Name;
    InitSpieler.SpielerID := Spieler.ID;
    Data.WriteBuffer(InitSpieler, SizeOf(InitSpieler));
    Net_SendToAll(Data, Msg_Server_SendSpieler, 0, Spieler);
  finally
    Data.Free;
  end;
end;

procedure TRoToMaPhiServerForm.Net_SendInitKarten;
var Data: TMemoryStream;
begin
  Data := Verwaltung.MischeStapel;
  try
    Net_SendToAll(Data, Msg_Server_InitKarten, 0);
    Verwaltung.InitGame;
  finally
    Data.Free;
  end;
end;

procedure TRoToMaPhiServerForm.Net_SendNextPlayer(const Spieler: TSpieler = nil; const AWhoNot: TSpieler = nil);
// Spieler = der vorige Spieler
// AWhoNot = falls User quits, der am Zug war
var Data: TMemoryStream;
    NextSpieler: TSpieler;
begin
  NextSpieler := Verwaltung.NextPlayer(Spieler);
  if not Assigned(NextSpieler) then Exit;
  //Assert(NextSpieler <> Spieler, 'Next Spieler = Spieler?!');
  Data := TMemoryStream.Create;
  try
    Data.WriteBuffer(NextSpieler.ID, SizeOf(NextSpieler.ID));
    Net_SendToAll(Data, Msg_Server_NextPlayer, 0, AWhoNot);
  finally
    Data.Free;
  end;
  if (NextSpieler is TKI) then  // nächster Spieler ist eine KI
    begin
      try
        //showmessage(IntToStr(NextSpieler.ID));
        UpdateGUI;
        NextSpieler.ShowKarten(UserScrollBox, nil);
        Delay(1000);
        DoKIZug(NextSpieler as TKI);
      finally
        if not CheckGameOver then
          Net_SendNextPlayer(NextSpieler, AWhoNot);
      end;

    end;
end;

procedure TRoToMaPhiServerForm.Net_SendKartenHalbieren(const Spieler: TSpieler);
var Data: TMemoryStream;
begin
  Data := Verwaltung.GetHalbeKartenStream(Spieler);
  try
    Net_SendToAll(Data, Msg_Server_KartenHalbieren, Spieler.ID);
    Net_SendToUser(nil, Spieler, Msg_Server_FarbWunsch, 0);
  finally
    Data.Free;
  end;
end;

procedure TRoToMaPhiServerForm.Net_SendKartenGemischt(const SenderID: Cardinal);
var Data: TMemoryStream;
begin
  Data := Verwaltung.MischeStapel;
  try
    Net_SendToAll(Data, Msg_Server_KartenGemischt, SenderID);
  finally
    Data.Free;
  end;
end;

procedure TRoToMaPhiServerForm.Net_SendWinner(const Spieler: TSpieler);
begin
  Net_SendToAll(nil, Msg_Server_Winner, Spieler.ID);
  Reset(false);
  UpdateGUI;
end;

procedure TRoToMaPhiServerForm.Net_SendNeuesSpiel;
begin
  Net_SendToAll(nil, Msg_Server_NeuesSpiel, 0);
end;

procedure TRoToMaPhiServerForm.Net_SendUserQuit(const Spieler: TSpieler);
begin
  Net_SendToAll(nil, Msg_Server_UserQuit, Spieler.ID, Spieler);
end;

procedure TRoToMaPhiServerForm.Net_SendToAll(AMessageBuffer: TStream; const AMsgID, ASenderID: Longword; const AWhoNot: TSpieler = nil);
var Header: THeader;
    MemBuf: TStream;
    i: Integer;
begin
  Header.MsgID := AMsgID;
  if Assigned(AMessageBuffer) then     // wenn Nutzdaten verschickt werden sollen
    Header.Size := AMessageBuffer.Size // dann dem Header.Size die Größe zuweisen
    else Header.Size := 0;             // sonst Size := 0
  Header.SenderID := ASenderID;
  for i:=0 to ServerSocket.Socket.ActiveConnections-1 do // connections array durchlaufen
    begin
    if Assigned(AWhoNot) then // wenn AWhoNot zugewiesen ist
      if (ServerSocket.Socket.Connections[i] = AWhoNot.Socket) then
        Continue; // Schleife fortsetzen, wenn Sockets übereinstimmen
(*
der Socket wird erst nach dem OnClientDisconnect aus dem connections array entfernt
-> manche Nachrichten wie z.B. Msg_Server_UserQuit dürfen nicht an dem rausgegangenen
  Spieler selbst gesendet werden, sonst kommt es zu einer Endlosschleife, denn
  wenn das Socket-Handle nicht mehr gültig ist, ruft die TServerSocket-Komponente
  erneut OnClientDisconnect auf (dies macht die Komponente standardmässig,
  wenn das Socket-Handle nicht mehr gültig ist und das socket handle überprüft er
  jedesmal, wenn er es braucht; hier braucht er es zum senden) und die Nachricht
  wird daraufhin wieder versucht zu senden usw. -> EStackOverflow
eigentlich überprüft die Eigenschaft ServerSocket.Socket.Connections[i].Connected,
ob das Handle noch gültig ist, jedoch wird sie nicht immer korrekt gesetzt
*)
    ServerSocket.Socket.Connections[i].SendBuf(Header, SizeOf(THeader)); // erst Header senden
    if Assigned(AMessageBuffer) then
      begin // Nutzdaten senden
      MemBuf := TMemoryStream.Create; // bei jedem Senden einen neuen MemoryStream erzeugen
      MemBuf.CopyFrom(AMessageBuffer, 0); // AMessageBuffer in MemBuf kopieren
      MemBuf.Position := 0; // vor dem Senden immer Position auf 0 setzen!
      ServerSocket.Socket.Connections[i].SendStream(MemBuf); // MemBuf senden
      (* SendStream gibt den gesendeten Stream selbst wieder frei
      -> bei jedem Senden einen neuen Stream erzeugen, da sonst beim 2. Durchlauf
         der Stream schon gelöscht ist *)
      end;
    end;
end;

procedure TRoToMaPhiServerForm.Net_SendToUser(AMessageBuffer: TStream; const Spieler: TSpieler; AMsgID, ASenderID: Longword);
var Header: THeader;
    MemBuf: TStream;
begin
  Header.MsgID := AMsgID;
  if Assigned(AMessageBuffer) then
    Header.Size := AMessageBuffer.Size
    else Header.Size := 0;
  Header.SenderID := ASenderID;
  Spieler.Socket.SendBuf(Header, SizeOf(THeader));
  if Assigned(AMessageBuffer) then
    begin
    MemBuf := TMemoryStream.Create;
    MemBuf.CopyFrom(AMessageBuffer, 0);
    MemBuf.Position := 0;
    Spieler.Socket.SendStream(MemBuf); // SendStream gibt MemBuf selbst frei
    end;
end;

procedure TRoToMaPhiServerForm.DoKIZug(const AKI: TKI);
var KartenID: Longword;
begin
  KartenID := Verwaltung.KISpielzug(AKI); // welche KartenID will KI legen?
  if (KartenID = 0) then
    Net_SendToAll(nil, Msg_User_KarteZiehen, AKI.ID) // KI hat gezogen
  else
    DoKIKarteLegen(AKI, KartenID);        // KI will eine Karte ablegen
end;

procedure TRoToMaPhiServerForm.DoKIKarteLegen(const AKI: TKI; KartenID: Longword);
var Data: TMemoryStream;
    ReturnMsg: Longword;
begin
  ReturnMsg := Verwaltung.KarteAblegen(AKI, KartenID);
  Data := TMemoryStream.Create;
  try
    Data.WriteBuffer(KartenID, SizeOf(KartenID));
    Net_SendToAll(Data, Msg_User_KarteLegen, AKI.ID);
  finally
    Data.Free;
  end;
  case ReturnMsg of                       // hat ablegte Karte Sonderfunktion?
    Msg_Server_FarbWunsch:
      DoKIFarbWunsch(AKI);
    Msg_Server_Tauschen:
      DoKITauschen(AKI);
    Msg_Server_Spionage:
      DoKISpionage(AKI);
    Msg_Server_Sperren:
      DoKISperren(AKI);
    Msg_Server_KartenHalbieren:
      DoKIKartenHalbieren(AKI);
  end;
end;

procedure TRoToMaPhiServerForm.DoKIFarbWunsch(const AKI: TKI);
var Data: TMemoryStream;
    WunschFarbe: TFarben;
begin
  WunschFarbe := AKI.GetWunschfarbe;
  Verwaltung.SetWunschFarbe(AKI, WunschFarbe);
  Data := TMemoryStream.Create;
  try
    Data.WriteBuffer(WunschFarbe, SizeOf(WunschFarbe));
    Net_SendToAll(Data, Msg_User_FarbWunsch, AKI.ID);
  finally
    Data.Free;
  end;
end;

procedure TRoToMaPhiServerForm.DoKITauschen(const AKI: TKI);
var Data: TMemoryStream;
    Spieler1, Spieler2: TSpieler;
begin
  AKI.Herrschaftswechsel(Spieler1, Spieler2);
  Verwaltung.KartenTauschen(Spieler1, Spieler2);
  Data := TMemoryStream.Create;
  try
    Data.WriteBuffer(Spieler1.ID, SizeOf(Spieler1.ID));
    Data.WriteBuffer(Spieler2.ID, SizeOf(Spieler2.ID));
    Net_SendToAll(Data, Msg_User_Tauschen, AKI.ID);
  finally
    Data.Free;
  end;
end;

procedure TRoToMaPhiServerForm.DoKISpionage(const AKI: TKI);
var Data: TMemoryStream;
    IDSpielerFrom, IDSpielerTo, SpioKartenID: Longword;
begin
  Verwaltung.KISpionage(AKI, IDSpielerFrom, IDSpielerTo, SpioKartenID);
  Data := TMemoryStream.Create;
  try
    Data.WriteBuffer(IDSpielerFrom, SizeOf(IDSpielerFrom));
    Data.WriteBuffer(IDSpielerTo, SizeOf(IDSpielerTo));
    Data.WriteBuffer(SpioKartenID, SizeOf(SpioKartenID));
    Net_SendToAll(Data, Msg_User_Spionage, AKI.ID);
  finally
    Data.Free;
  end;
end;

procedure TRoToMaPhiServerForm.DoKISperren(const AKI: TKI);
var Data: TMemoryStream;
    Sperre: Byte;
begin
  Sperre := AKI.Sperren;
  Verwaltung.SetSperre(Sperre);
  Data := TMemoryStream.Create;
  try
    Data.WriteBuffer(Sperre, SizeOf(Sperre));
    Net_SendToAll(Data, Msg_User_Sperren, AKI.ID);
  finally
    Data.Free;
  end;
end;

procedure TRoToMaPhiServerForm.DoKIKartenHalbieren(const AKI: TKI);
var Data: TMemoryStream;
begin
  Data := Verwaltung.GetHalbeKartenStream(AKI);
  try
    Net_SendToAll(Data, Msg_Server_KartenHalbieren, AKI.ID);
  finally
    Data.Free;
    DoKIFarbWunsch(AKI);
  end;
end;

procedure TRoToMaPhiServerForm.BeendenBtnClick(Sender: TObject);
begin
  Verwaltung.Free;
  Self.Close;
end;

end.
