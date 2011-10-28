unit uGlobalTypes;

interface

type
  THeader = record
    Size: Longword;             // Größe des Packets (ohne Header)
    MsgID: Longword;            // repräsentiert die Art der Nachricht
                                // z.B. Spielerzug oder Chat-Nachricht
    SenderID: Longword;         // 0 - Server, sonst SpielerID
  end;

  TInitSpieler = record
    SpielerID: Longword;
    Name: String[19];
  end;

  TFarben = (Schwarz, Rot, Gruen, Blau, Ohne);

  TInitKarten = record
    ID: Longword;
    Typ: Byte;
    Farbe: TFarben;
  end;

const
  Msg_Server_SetUserID        = $0100;  // Server zu Client
  Msg_Server_GameConfig       = $0101;  // Server zu Client
  Msg_Server_SendSpieler      = $0102;  // Server zu Client
  Msg_Server_UserQuit         = $0103;  // Server zu Client
  Msg_Server_InitKarten       = $0104;  // Server zu Client
  Msg_Server_NextPlayer       = $0105;  // Server zu Client
  Msg_Server_FarbWunsch       = $0106;  // Server zu Client
  Msg_Server_Tauschen         = $0107;  // Server zu Client
  Msg_Server_Sperren          = $0108;  // Server zu Client
  Msg_Server_Spionage         = $0109;  // Server zu Client
  Msg_Server_KartenHalbieren  = $0110;  // Server zu Client
  Msg_Server_KartenGemischt   = $0111;  // Server zu Client
  Msg_Server_Winner           = $0112;  // Server zu Client
  Msg_Server_NeuesSpiel       = $0113;  // Server zu Client

//Msg_Server_Exil             = $0114;  // Server zu Client


  Msg_User_SendName           = $FE00;  // Client zu Server
  Msg_User_Ready              = $FE01;  // Client zu Server & Server zu Client
  Msg_User_KarteLegen         = $FE02;  // Client zu Server & Server zu Client
  Msg_User_KarteZiehen        = $FE03;  // Client zu Server & Server zu Client
  Msg_User_ChatMsg            = $FE04;  // Client zu Server & Server zu Client
  Msg_User_FarbWunsch         = $FE05;  // Client zu Server & Server zu Client
  Msg_User_Tauschen           = $FE06;  // Client zu Server & Server zu Client
  Msg_User_Sperren            = $FE07;  // Client zu Server & Server zu Client
  Msg_User_Spionage           = $FE08;  // Client zu Server & Server zu Client

implementation

end.
 