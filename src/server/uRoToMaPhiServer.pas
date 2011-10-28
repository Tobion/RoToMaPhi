{*******************************************************}
{                                                       }
{                   RoToMaPhi Server                    }
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

unit uRoToMaPhiServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Spin, ScktComp, SyncObjs, uVerwaltung,
  uGlobalTypes, uSpieler, uKI, SQLiteTable3;

type
  TRoToMaPhiServerForm = class(TForm)
    ServerSocket: TServerSocket;
    StatusBar: TStatusBar;
    RegisteredUsersListView: TListView;
    OptionsPanel: TPanel;
    ServerStartenBtn: TButton;
    PortSpinEdit: TSpinEdit;
    PortLabel: TLabel;
    SpielerAnzLabel: TLabel;
    SpielerAnzComboBox: TComboBox;
    NeuesSpielBtn: TButton;
    NeueKIBtn: TButton;
    SpielerListView: TListView;
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
    procedure FormDestroy(Sender: TObject);
  private
    lCS: TCriticalSection;
    Verwaltung: TVerwaltung;
    Database: TSQLiteDatabase;

    procedure InitDatabase;
    procedure DB_SaveUser(const Spieler: TSpieler);
    procedure DB_SavePicture(AMessageBuffer: TStream; const Spieler: TSpieler);
    procedure DB_DeletePicture(const Spieler: TSpieler);
    procedure DB_AddGame;
    procedure DB_AddWin(const Spieler: TSpieler);
    procedure ShowRegisteredUsers;

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
    procedure Net_SendPlayerInfo(AMessageBuffer: TStream; const Spieler: TSpieler);
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

const
  DbFileName = 'RoToMaPhi.sqlite';
  KIDELAY = 1000;

implementation

{$R *.dfm}

procedure TRoToMaPhiServerForm.FormCreate(Sender: TObject);
begin
  lCS := TCriticalSection.Create;
  Verwaltung := TVerwaltung.Create;
  InitDatabase;
  UpdateGUI;
end;


procedure TRoToMaPhiServerForm.FormDestroy(Sender: TObject);
begin
  lCS.Free;
  Verwaltung.Free;
  Database.Free;
end;

procedure TRoToMaPhiServerForm.InitDatabase;
var
  DBpath: String;
  sSQL: String;
begin

  DBPath := ExtractFilepath(Application.exename) + DbFileName;
  Database := TSQLiteDatabase.Create(DBPath);

  if not Database.TableExists('users') then
  begin
    sSQL := 'CREATE TABLE users ( ' +
      'name VARCHAR(19) PRIMARY KEY, ' +
      'games INTEGER NOT NULL DEFAULT 0, ' +
      'wins INTEGER NOT NULL DEFAULT 0, ' +
      'lastlogin DATETIME NOT NULL DEFAULT "", ' +
      'pictype CHAR(10) NOT NULL DEFAULT "", ' +
      'picture BLOB COLLATE NOCASE NULL DEFAULT NULL' +
      ');';
    Database.execsql(sSQL);
  end;

  ShowRegisteredUsers;

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
      DB_AddGame;
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
    begin
      Net_SendWinner(Winner);
      DB_AddWin(Winner);
      Reset(false);
      UpdateGUI;
    end
    else Result := false;
    end;
end;

procedure TRoToMaPhiServerForm.NeuesSpielBtnClick(Sender: TObject);
begin
  Reset(false);
  UpdateGUI;
  Net_SendNeuesSpiel;
  CheckStartGame;
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
    //Buff: array[Word] of Byte;
    DataStream: TMemoryStream;
    lBuffer: Pointer;
begin
  DataStream := Socket.Data;

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
  try

  DataStream.Position := DataStream.Size;
  repeat
    nRead := Socket.ReceiveBuf(Buff, High(Buff) - Low(Buff));
    DataStream.WriteBuffer(Buff, nRead);
  until (Socket.ReceiveLength = 0);

  except
    on E: EWriteError do // Stream Schreibfehler abfangen
  end;
  *)

  while (Net_DecodeMessage(DataStream)) do
    Application.ProcessMessages;
{ es können mehrere Nachrichten im DataStream sein, da man zu diesem Zeitpunkt
  schon meherere Botschaften empfangen haben kann
  -> so lange komplette Nachrichten vorliegen, alle nacheinander bearbeiten }
end;

(*
  Es wird der DataStream weiterverarbeitet
  Wenn ein Packet vollständig empfangen wurde, dann wird Game_DecodeMessage
  aufegerufen, die anhand der Packet-ID und Nutzdaten die entsprechende Aktion ausführt
  Dann wird das verarbeitete Packet aus dem Stream gelöscht
  Return true, wenn im DataStream noch weitere Packete enthalten sind, sonst false
*)
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
      try
        if (Header.Size > 0) then
          lMessageData.CopyFrom(DataStream, Header.Size);
        DataStream.Position := 0;
        Net_RemoveMessage(DataStream, Header.Size + SizeOf(THeader));
        Game_DecodeMessage(lMessageData, Header.MsgID, Header.SenderID);
        Result := (DataStream.Size >= SizeOf(THeader));
      except

      end;
      finally
        lMessageData.Free;
      end;
    end;
  end;
end;

procedure TRoToMaPhiServerForm.Net_RemoveMessage(DataStream: TStream; const ASize : Cardinal);
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
    DB_SaveUser(Spieler);
    Net_SendSpielerListe(Spieler);
    Net_SendUserEnter(Spieler);
    UpdateGUI;
    Result := true;
    end;
  Msg_User_SendPicture:
    begin
    DB_SavePicture(AMessageData, Spieler);
    Result := true;
    end;
  Msg_User_DeletePicture:
    begin
    DB_DeletePicture(Spieler);
    Result := true;
    end;
  Msg_User_GetPlayerInfo:
    begin
    Net_SendPlayerInfo(AMessageData, Spieler);
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


procedure TRoToMaPhiServerForm.DB_SaveUser(const Spieler: TSpieler);
var sSQL: String;
  sltb: TSQLIteTable;
begin
  sSQL := 'SELECT name FROM users WHERE name = "' + Spieler.Name + '";';
  sltb := Database.GetTable(sSQL);

  if (sltb.Count = 0) then
  begin
    sSQL := 'INSERT INTO users (name, lastlogin) VALUES ("' + Spieler.Name + '", datetime("now"));';
    Database.ExecSQL(sSQL);
  end
  else
  begin
    sSQL := 'UPDATE users SET lastlogin = datetime("now") WHERE name = "' + Spieler.Name + '";';
    Database.ExecSQL(sSQL);
  end;

  ShowRegisteredUsers;
end;

procedure TRoToMaPhiServerForm.DB_SavePicture(AMessageBuffer: TStream; const Spieler: TSpieler);
var FileExt: TFileExt;
    PictureStream: TMemoryStream;
begin
  AMessageBuffer.ReadBuffer(FileExt, SizeOf(TFileExt));
  //Showmessage('Bild speichern: ' + IntToStr(AMessageBuffer.Size) + ' (' + FileExt + ')');
  PictureStream := TMemoryStream.Create;
  try
    PictureStream.CopyFrom(AMessageBuffer, AMessageBuffer.Size - AMessageBuffer.Position);
    PictureStream.Position := 0;
    Database.UpdateBlob('UPDATE users SET pictype = "' + FileExt + '", picture = ? WHERE name = "' + Spieler.Name + '"', PictureStream);
  finally
     PictureStream.Free;
  end;
  ShowRegisteredUsers;
end;

procedure TRoToMaPhiServerForm.DB_DeletePicture(const Spieler: TSpieler);
begin
  Database.ExecSQL('UPDATE users SET pictype = "", picture = NULL WHERE name = "' + Spieler.Name + '"');
  ShowRegisteredUsers;
end;

procedure TRoToMaPhiServerForm.DB_AddGame;
var sSQL: String;
  i: Integer;
begin
for i := 0 to Verwaltung.SpielerListe.Count - 1 do
  begin
    sSQL := 'UPDATE users SET games = games + 1 WHERE name = "' + TSpieler(Verwaltung.SpielerListe.Items[i]).Name + '";';
    Database.ExecSQL(sSQL);
  end;
  ShowRegisteredUsers;
end;

procedure TRoToMaPhiServerForm.DB_AddWin(const Spieler: TSpieler);
var sSQL: String;
begin
  sSQL := 'UPDATE users SET wins = wins + 1 WHERE name = "' + Spieler.Name + '";';
  Database.ExecSQL(sSQL);
  ShowRegisteredUsers;
end;


procedure TRoToMaPhiServerForm.ShowRegisteredUsers;
var sSQL: String;
  sltb: TSQLIteTable;
  i: Integer;
  ListItem: TListItem;
begin
RegisteredUsersListView.Clear;

sSQL := 'SELECT *, IFNULL(LENGTH(picture), 0) as picsize, ' +
    'ROUND(IFNULL(CAST(wins AS real) / CAST(games AS real) * 100, 0), 1) AS winpercent ' +
    'FROM users ORDER BY lastlogin DESC';
sltb := Database.GetTable(sSQL);
try

for i:=0 to sltb.Count - 1 do
begin
  ListItem := RegisteredUsersListView.Items.Add;
  ListItem.Caption := sltb.FieldAsString(sltb.FieldIndex['name']);
  ListItem.SubItems.Add(IntToStr(sltb.FieldAsInteger(sltb.FieldIndex['games'])));
  ListItem.SubItems.Add(
    sltb.FieldAsString(sltb.FieldIndex['wins']) + ' (' +
    sltb.FieldAsString(sltb.FieldIndex['winpercent']) + ' %)'
  );
  ListItem.SubItems.Add(sltb.FieldAsString(sltb.FieldIndex['lastlogin']));
  ListItem.SubItems.Add(sltb.FieldAsString(sltb.FieldIndex['picsize']));
  ListItem.SubItems.Add(sltb.FieldAsString(sltb.FieldIndex['pictype']));
  sltb.next();
end;

finally
  sltb.Free;
end;

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

// Spieler ist der, der die Anfrage stellt
procedure TRoToMaPhiServerForm.Net_SendPlayerInfo(AMessageBuffer: TStream; const Spieler: TSpieler);
var InfoAboutWhom: Longword;
    PlayerInfo: TSpieler;
    sSQL: String;
    sltb: TSQLIteTable;
    Stats: TStats;
    FileExt: TFileExt;
    PlayerInfoStream: TMemoryStream;
    PictureStream: TMemoryStream;
begin
  // über wenn sollen Informationen gesendet werden
  AMessageBuffer.ReadBuffer(InfoAboutWhom, SizeOf(InfoAboutWhom));
  PlayerInfo := Verwaltung.GetSpieler(InfoAboutWhom);

  if not (PlayerInfo is TKI) then   // nur wenn der Spieler keine KI ist senden
  begin

  // Datenbank abfragen
  sSQL := 'SELECT * FROM users WHERE name = "' + PlayerInfo.Name + '";';
  sltb := Database.GetTable(sSQL);

  PlayerInfoStream := TMemoryStream.Create;

  try

  if (sltb.Count > 0) then
  begin
    Stats.Games := sltb.FieldAsInteger(sltb.FieldIndex['games']);
    Stats.Wins := sltb.FieldAsInteger(sltb.FieldIndex['wins']);
    Stats.LastLogin := sltb.FieldAsString(sltb.FieldIndex['lastlogin']);
    FileExt := sltb.FieldAsString(sltb.FieldIndex['pictype']);
    // Statistiken in Stream schreiben
    PlayerInfoStream.WriteBuffer(Stats, SizeOf(TStats));
    // Bildtyp (jpg, bmp, gif) in den Stream schreiben, damit der Client
    // weiß, was für ein Bild er aus dem Stream erstellen muss
    PlayerInfoStream.WriteBuffer(FileExt, SizeOf(TFileExt));

    PictureStream := sltb.FieldAsBlob(sltb.FieldIndex['picture']);
    // wenn ein Bild gespeichert ist, dann füge es an Ende des Streams
    if Assigned(PictureStream) then
    begin
      PlayerInfoStream.CopyFrom(PictureStream, 0);
    end;
    //Showmessage('Nutzer Info von ' + PlayerInfo.Name + ': ' + IntToStr(PlayerInfoStream.Size));
    Net_SendToUser(PlayerInfoStream, Spieler, Msg_Server_SendPlayerInfo, PlayerInfo.ID);
  end;

  finally
    PlayerInfoStream.Free;
    sltb.Free; // also frees PictureStream
  end;

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

      try
        UpdateGUI;
        //NextSpieler.ShowKarten(UserScrollBox, nil);
        Delay(KIDELAY);
        DoKIZug(NextSpieler as TKI);
      except
        on E: EAccessViolation do
        // Access violation abfangen, falls Server wärend des Delays geschlossen wurde
      end;

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
  begin
    Net_SendToAll(nil, Msg_User_KarteZiehen, AKI.ID); // KI hat gezogen
    if (Verwaltung.GetZiehstapelKartenAnzahl = 0) then
      Net_SendKartenGemischt(AKI.ID);
  end
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


end.
