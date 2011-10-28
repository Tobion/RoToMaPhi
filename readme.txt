{*******************************************************}
{                                                       }
{                       RoToMaPhi                       }
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


Ordnerstruktur


doc
Ordner mit den Dokumentationen


src
gesamter Sourcecode + clear.cmd [ein von Tobias geschriebenes Script, das alle für das Senden unnötige Dateien
aus unserem Projekt löscht (compiled units, Backupdateien etc.)]

client
Client-SourceCode

server
Server-SourceCode

universal
Dateien, die sowohl von Server als auch vom Client gebraucht werden

images
alle verwendeten Bilder



Zum Spielen:
1. Server starten und Einstellungen vornehmen (Port, Spieleranzahl)
2. entsprechend viele Clients starten und einloggen
3. wenn alle clients ready sind, wird das Spiel gestartet
4. das Spiel ist ähnlich wie MauMau zu spielen 
   (nähere Infos zu den Spielregeln auf der Webseite: http://www.rotomaphi.de.vu)



Arbeitsgebiete:

Tobias:	Spielstruktur/Schnittstellen (uVerwaltung, uAblagestapel, uZiehstapel, uSpieler, uKarte, uGlobalTypes)
	Netzwerkcode (uRoToMaPhiServer, uRoToMaPhi)
	Bugfixing

Robert:	Spielregeln (uSpielregeln)
	einige Spielelemete (Spionage, Herrschaftswechsel, Tribunal)
	Layout

Manu: 	Erstellung der Kartenbilder
	Protokoll (uProtokoll)
	Funktionsweise, wenn mehr Karten zu ziehen sind, als auf dem Ziehstapel liegen

Philipp: uKI (noch nicht funktionsfähig, daher auch noch keine KI implementiert)

Alle: 	Spielidee
	Testing

