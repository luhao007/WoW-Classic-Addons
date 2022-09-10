--[[

	AtlasQuest, a World of Warcraft addon.
	Email me at mystery8@gmail.com

	This file is part of AtlasQuest.

	AtlasQuest is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	AtlasQuest is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with AtlasQuest; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]


------------  WOTLK CLASSIC  ------------

-- 69 = DUNGEON: Caverns of Time: Stratholme Past
-- 70 = DUNGEON: Utgarde Keep: Utgarde Keep
-- 71 = DUNGEON: Utgarde Keep: Utgarde Pinnacle
-- 72 = DUNGEON: The Nexus: The Nexus
-- 73 = DUNGEON: The Nexus: The Oculus
-- 74 = RAID: The Nexus: The Eye of Eternity
-- 75 = DUNGEON: Azjol-Nerub: The Upper Kingdom
-- 76 = DUNGEON: Azjol-Nerub: Ahn'kahet: The Old Kingdom
-- 77 = DUNGEON: Ulduar: Halls of Stone
-- 78 = DUNGEON: Ulduar: Halls of Lightning
-- 79 = RAID: The Obsidian Sanctum
-- 80 = DUNGEON: Drak'Tharon Keep
-- 81 = DUNGEON: Zul'Drak: Gundrak
-- 82 = DUNGEON: The Violet Hold
-- 83 = BATTLEGROUND: Strand of the Ancients (SotA)
-- 84 = RAID: Naxxramas (Naxx)
-- 85 = RAID: Vault of Archavon (VoA)
-- 86 = RAID: Ulduar
-- 87 = DUNGEON: Trial of the Champion (ToC)
-- 88 = RAID: Trial of the Crusader (ToC)
-- 89 = BATTLEGROUND: Isle of Conquest (IoC)
-- 90 = DUNGEON: Forge of Souls (FoS)
-- 91 = DUNGEON: Pit of Saron (PoS)
-- 92 = DUNGEON: Halls of Reflection (HoR)
-- 93 = RAID: Icecrown Citadel (ICC)
-- 94 = RAID: Ruby Sanctum (RS)


if ( GetLocale() == "deDE" ) then


---------------
--- COLOURS ---
---------------

local GREY = "|cff999999";
local RED = "|cffff0000";
local WHITE = "|cffFFFFFF";
local GREEN = "|cff66cc33";
local PURPLE = "|cff9F3FFF";
local BLUE = "|cff0070dd";
local ORANGE = "|cffFF8400";
local YELLOW = "|cffFFd200";   -- Ingame Yellow





--------------- INST69 - Caverns of Time: Stratholme Past ---------------

Inst69Story = "Vor seiner unvorstellbaren Vereinigung mit dem Lich-König führte Arthas Krieg gegen die Geißel, von dem Willen besessen, die Untotenplage auszulöschen, die sich über Lordaeron ausgebreitet hatte. Nachdem Arthas mitansehen musste, wie ganze Orte in Dunkelheit versanken und seine gefallenen Untertanen sich in abscheuliche untote Kreaturen verwandelten, nahmen Angst und Hass Besitz von seinem Geist. Nach der Entdeckung von ersten Anzeichen, dass die Seuche auf Stratholme übergegriffen hatte, wusste er, dass es nur eine Frage der Zeit war, bevor die Bewohner der Stadt ebenfalls als Diener der Geißel wiederauferstehen würden. Für Arthas selbst es nur eine einzige Lösung: Die vollständige Säuberung der Stadt. Innerhalb der Höhlen der Zeit durchdringt nun trügerische Magie Stratholme. Die ewige Drachenbrut und deren Diener haben es auf Arthas und seine Aufgabe, die Säuberung der Stadt, abgesehen und versuchen, die Vergangenheit selbst zu verändern. Die Befürchtung, dass diese Störung im Zeitgefüge sogar die Existenz von ganz Azeroth gefährden könnte, hat den bronzenen Drachenschwarm dazu veranlasst, Sterbliche zu Hilfe zu rufen, die Arthas unterstützen und sicherstellen sollen, dass die Ausmerzung erfolgreich durchgeführt wird. Unabhängig davon wie abscheulich dieses Ereignis auch erscheinen mag, vertreten die Hüter der Zeit die Meinung, dass was einst war, nicht ungeschehenen gemacht werden darf."
Inst69Caption = "HdZ: Das Ausmerzen von Stratholme"
Inst69QAA = "2 Quests"
Inst69QAH = "2 Quests"

--Quest 1 Alliance
Inst69Quest1 = "1. Illusionen bannen"
Inst69Quest1_Aim = "Chromie möchte, dass Ihr den arkanen Disruptor auf die verdächtigen Kisten im Stratholme der Vergangenheit anwendet und sie anschließend am Eingang von Stratholme trefft."
Inst69Quest1_Location = "Chromie (Stratholme Past; "..YELLOW.."[1]"..WHITE..")"
Inst69Quest1_Note = "Die Kisten findet man in der nähe der Häuser entlang des Weges nach Stratholm. Nach beendigung der Aufgabe kannst Du die Quest bei Chromi bei "..YELLOW.."[2]"..WHITE.."."
Inst69Quest1_Prequest = "Nein"
Inst69Quest1_Folgequest = "Die Eskorte des Königs"
-- No Rewards for this quest

--Quest 2 Alliance
Inst69Quest2 = "2. Die Eskorte des Königs"
Inst69Quest2_Aim = "Chromie möchte, dass Ihr Arthas bei seiner Ausmerzaktion in Stratholme begleitet. Ihr sollt wieder mit ihr sprechen, nachdem Mal'Ganis besiegt ist."
Inst69Quest2_Location = "Chromie (Stratholme Past; "..YELLOW.."[2]"..WHITE..")"
Inst69Quest2_Note = "Mal'Ganis ist bei "..YELLOW.."[5]"..WHITE..". Chromie wird erscheinen nachdem Mal'Ganis besiegt worden ist."
Inst69Quest2_Prequest = "Illusionen bannen"
Inst69Quest2_Folgequest = "Nein"
--
Inst69Quest2name1 = "Handschuhe des Zeitwächters"
Inst69Quest2name2 = "Handlappen der erhaltenen Geschichte"
Inst69Quest2name3 = "Handschutz der chronologischen Ereignisse"
Inst69Quest2name4 = "Stulpen der Säuberung"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst69Quest1_HORDE = Inst69Quest1
Inst69Quest1_HORDE_Aim = Inst69Quest1_Aim
Inst69Quest1_HORDE_Location = Inst69Quest1_Location
Inst69Quest1_HORDE_Note = Inst69Quest1_Note
Inst69Quest1_HORDE_Prequest = Inst69Quest1_Prequest
Inst69Quest1_HORDE_Folgequest = Inst69Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst69Quest2_HORDE = Inst69Quest2
Inst69Quest2_HORDE_Aim = Inst69Quest2_Aim
Inst69Quest2_HORDE_Location = Inst69Quest2_Location
Inst69Quest2_HORDE_Note = Inst69Quest2_Note
Inst69Quest2_HORDE_Prequest = Inst69Quest2_Prequest
Inst69Quest2_HORDE_Folgequest = Inst69Quest2_Folgequest
--
Inst69Quest2name1_HORDE = Inst69Quest2name1
Inst69Quest2name2_HORDE = Inst69Quest2name2
Inst69Quest2name3_HORDE = Inst69Quest2name3
Inst69Quest2name4_HORDE = Inst69Quest2name4



--------------- INST70 - Utgarde Keep: Utgarde Keep ---------------

Inst70Story = "Inmitten der Klippen der Dolchbucht im heulenden Fjord steht Burg Utgarde, eine uneinnehmbare Festung, in der die wilden und geheimnisvollen Vrykul hausen. Mit mysteriösen, verdorbenen Magien und Protodrachen unter ihrem Kommando stellen die Vrykul von Burg Utgarde eine unmittelbare Bedrohung sowohl für die Allianz als auch die Horde dar. Nur die Mutigsten werden es wagen, einen Schlag gegen Ymirons Getreue zu führen und in das Herz des urzeitlichen Heims der Vrykul vorzustoßen."
Inst70Caption = "Burg Utgarde"
Inst70QAA = "2 Quests"
Inst70QAH = "3 Quests"

--Quest 1 Alliance
Inst70Quest1 = "1. Nach Utgarde!"
Inst70Quest1_Aim = "Verteidiger Mordun hat Euch mit der Exekution von Ingvar dem Brandschatzer, der tief in Utgarde wohnt, beauftragt.Anschließend sollt Ihr dessen Kopf zu Vizeadmiral Keller bringen."
Inst70Quest1_Location = "Verteidiger Mordun (Heulender Fjord - Valgarde; "..YELLOW.."59.3, 48.8"..WHITE..")"
Inst70Quest1_Note = "Ingvar der Brandschatzer ist bei "..YELLOW.."[3]"..WHITE..".\n\nDie Vorquest ist optional. Die Quest bringt Dich zu Vizeadmiral Keller bei (Heulender Fjord - Valgarde; "..YELLOW.."60.4, 61.0"..WHITE..")."
Inst70Quest1_Prequest = "Ein neuer Abschnitt"
Inst70Quest1_Folgequest = "Nein"
--
Inst70Quest1name1 = "Band des Henkers"
Inst70Quest1name2 = "Ring der Dezimierung"
Inst70Quest1name3 = "Signet des schnellen Richturteils"

--Quest 2 Alliance
Inst70Quest2 = "2. Abrüstung"
Inst70Quest2_Aim = "Verteidiger Mordun möchte, dass Ihr Burg Utgarde betretet und 5 Waffen der Vrykul stehlt"
Inst70Quest2_Location = "Verteidiger Mordun (Heulender Fjord - Valgarde; "..YELLOW.."59.3, 48.8"..WHITE..")"
Inst70Quest2_Note = "Die Waffen der Vykul können überall in der Instant in den Waffenständern gefunden werden. Die Vorquest bekommt man von Kundschafterin Valory (Heulender Fjord - Valgarde; "..YELLOW.."56.0, 55.8"..WHITE..") and is optional."
Inst70Quest2_Prequest = "Nein"
Inst70Quest2_Folgequest = "Nein"
--
Inst70Quest2name1 = "Amulett des ruhigen Gemüts"
Inst70Quest2name2 = "Rasierklingenanhänger"
Inst70Quest2name3 = "Halskette des gestreuten Lichts"
Inst70Quest2name4 = "Gewebte Stahlhalskette"


--Quest 1 Horde
Inst70Quest1_HORDE = "1. Eine Rechnung begleichen"
Inst70Quest1_HORDE_Aim = "Hochexekutor Anselm möchte, dass Ihr nach Utgarde geht und Prinz Keleseth tötet."
Inst70Quest1_HORDE_Location = "Hochexekutor Anselm (Heulender Fjord - Hafen der Vergeltung; "..YELLOW.."78.5, 31.1"..WHITE..")"
Inst70Quest1_HORDE_Note = "Prinz Keleseth ist bei "..YELLOW.."[1]"..WHITE.."."
Inst70Quest1_HORDE_Prequest = "Nein"
Inst70Quest1_HORDE_Folgequest = "Nein"
--
Inst70Quest1name1_HORDE = "Wickel der San'layn"
Inst70Quest1name2_HORDE = "Vendettabindungen"
Inst70Quest1name3_HORDE = "Armschienen des Runenmagiers"
Inst70Quest1name4_HORDE = "Unterarmschienen des Vergeltungsbringers"

--Quest 2 Horde
Inst70Quest2_HORDE = "2. Ingvar muss sterben!"
Inst70Quest2_HORDE_Aim = "Dunkelläuferin Marrah möchte, dass Ihr Ingvar den Brandschatzer in Burg Utgarde tötet und seinen Kopf bei Hochexekutor Anselm im Hafen der Vergeltung abliefert."
Inst70Quest2_HORDE_Location = "Dunkelläuferin Marrah (Burg Utgarde; "..YELLOW.."[??]"..WHITE..")"
Inst70Quest2_HORDE_Note = "Dunkelläuferin Marrah befindet sich in der Instant, nähe des Eingangs.\n\nIngvar der Brandschatzer ist bei "..YELLOW.."[3]"..WHITE..".\n\nDie Quest bringt Dich zurück zu Hochexekutor Anselm in (Heulender Fjord - Hafen der Vergeltung; "..YELLOW.."78.5, 31.1"..WHITE..")."
Inst70Quest2_HORDE_Prequest = "Nein"
Inst70Quest2_HORDE_Folgequest = "Nein"
--
Inst70Quest2name1_HORDE = Inst70Quest1name1
Inst70Quest2name2_HORDE = Inst70Quest1name2
Inst70Quest2name3_HORDE = Inst70Quest1name3

--Quest 3 Horde
Inst70Quest3_HORDE = "3. Abrüstung"
Inst70Quest3_HORDE_Aim = "Dunkelläuferin Marrah möchte, dass Ihr 5 Waffen der Vrykul aus Burg Utgarde stehlt und sie zu Hochexekutor Anselm im Hafen der Vergeltung bringt."
Inst70Quest3_HORDE_Location = "Dunkelläuferin Marrah (Heulender Fjord - ??; "..YELLOW.."??,??"..WHITE..")"
Inst70Quest3_HORDE_Note = "Die Waffen der Vykul können überall in der Instant in den Waffenständern gefunden werden.\n\nDie Quest bringt Dich zu Hochexekutor Anselm in (Heulender Fjord - Hafen der Vergeltung; "..YELLOW.."78.5, 31.1"..WHITE..")."
Inst70Quest3_HORDE_Prequest = "Nein"
Inst70Quest3_HORDE_Folgequest = "Nein"
--
Inst70Quest3name1_HORDE = "Halskette der ruhigen Himmel"
Inst70Quest3name2_HORDE = "Hundertzahnhalskette"
Inst70Quest3name3_HORDE = "Amulett der eingeschränkten Kraft"
Inst70Quest3name4_HORDE = "Kachelsteinanhänger"



--------------- INST71 - Utgarde Keep: Utgarde Pinnacle ---------------

Inst71Story = "Inmitten der Klippen der Dolchbucht im heulenden Fjord steht Burg Utgarde, eine uneinnehmbare Festung, in der die wilden und geheimnisvollen Vrykul hausen. Mit mysteriösen, verdorbenen Magien und Protodrachen unter ihrem Kommando stellen die Vrykul von Burg Utgarde eine unmittelbare Bedrohung sowohl für die Allianz als auch die Horde dar. Nur die Mutigsten werden es wagen, einen Schlag gegen Ymirons Getreue zu führen und in das Herz des urzeitlichen Heims der Vrykul vorzustoßen."
Inst71Caption = "Turm Utgarde"
Inst71QAA = "2 Quests"
Inst71QAH = "2 Quests"

--Quest 1 Alliance
Inst71Quest1 = "1. Schrott in der Truhe"
Inst71Quest1_Aim = "Brigg im Turm Utgarde möchte, dass Ihr 5 blitzblanke Silberbarren, 3 glänzende Schmuckstücke, 2 goldene Kelche und eine Jadestatue beschafft."
Inst71Quest1_Location = "Brigg Kleinkeul (Turm Utgarde; "..YELLOW.."[A]"..WHITE..")"
Inst71Quest1_Note = "Die Gegenstände können überall in der Instanz gefunden werden.Die glänzende Schmuckstücke sind nicht die Selben die man fürs Angeln benutzt."
Inst71Quest1_Prequest = "Nein"
Inst71Quest1_Folgequest = "Nein"
--
Inst71Quest1name1 = "Robe mit eingewebten Schmuckstücken"
Inst71Quest1name2 = "Exotische Ledertunika"
Inst71Quest1name3 = "Versilberte Kampfplatte"
Inst71Quest1name4 = "Güldene Ringpanzerhalsberge"

--Quest 2 Alliance
Inst71Quest2 = "2. Die Rache ist mein!"
Inst71Quest2_Aim = "Brigg im Turm Utgarde möchte, dass Ihr König Ymiron tötet."
Inst71Quest2_Location = "Brigg Kleinkeul (Turm Utgarde; "..YELLOW.."[A]"..WHITE..")"
Inst71Quest2_Note = "König Ymiron ist bei "..YELLOW.."[4]"..WHITE.."."
Inst71Quest2_Prequest = "Nein"
Inst71Quest2_Folgequest = "Nein"
--
Inst71Quest2name1 = "Gugel des rachgierigen Hauptmanns"
Inst71Quest2name2 = "Kopfschutz des Gegenschlags"
Inst71Quest2name3 = "Helm der gerechten Vergeltung"
Inst71Quest2name4 = "Gesichtsschutz der Strafe"
Inst71Quest2name5 = "Plattenhelm der zornigen Rache"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst71Quest1_HORDE = Inst71Quest1
Inst71Quest1_HORDE_Aim = Inst71Quest1_Aim
Inst71Quest1_HORDE_Location = Inst71Quest1_Location
Inst71Quest1_HORDE_Note = Inst71Quest1_Note
Inst71Quest1_HORDE_Prequest = Inst71Quest1_Prequest
Inst71Quest1_HORDE_Folgequest = Inst71Quest1_Folgequest
--
Inst71Quest1name1_HORDE = Inst71Quest1name1
Inst71Quest1name2_HORDE = Inst71Quest1name2
Inst71Quest1name3_HORDE = Inst71Quest1name3
Inst71Quest1name4_HORDE = Inst71Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst71Quest2_HORDE = Inst71Quest2
Inst71Quest2_HORDE_Aim = Inst71Quest2_Aim
Inst71Quest2_HORDE_Location = Inst71Quest2_Location
Inst71Quest2_HORDE_Note = Inst71Quest2_Note
Inst71Quest2_HORDE_Prequest = Inst71Quest2_Prequest
Inst71Quest2_HORDE_Folgequest = Inst71Quest2_Folgequest
--
Inst71Quest2name1_HORDE = Inst71Quest2name1
Inst71Quest2name2_HORDE = Inst71Quest2name2
Inst71Quest2name3_HORDE = Inst71Quest2name3
Inst71Quest2name4_HORDE = Inst71Quest2name4
Inst71Quest2name5_HORDE = Inst71Quest2name5



--------------- INST72 - The Nexus: The Nexus ---------------

Inst72Story = "Der blaue Drachen Aspekt, Malygos, hat Risse mit seiner Handhabung der rohen magischen Energie geschaffen: Risse im Gewebe der magischen Dimension. Die Kirin Tor, die Elite Magier Dalarans, haben einen Rat mit dem roten Drachenschwarm gebildet, die mit der Bewahrung des Lebens aufgeladen werden. Zu diesem Zweck haben die zwei Gruppen aktiv begonnen, die verheerende Kampagne von Malygos zu stürzen. Die Seiten sind gewählt worden; die Kampflinien sind gezogen worden. Die einzige Frage, die jetzt bleibt, ist... Wer gewinnen wird."
Inst72Caption = "Der Nexus: Der Nexus"
Inst72QAA = "4 Quests"
Inst72QAH = "4 Quests"

--Quest 1 Alliance
Inst72Quest1 = "1. Schämen sie sich denn nicht?"
Inst72Quest1_Aim = "Bibliothekarin Serrah möchte, dass Ihr den Nexus betretet und Berinands Forschungsergebnisse beschafft."
Inst72Quest1_Location = "Bibliothekarin Serrah (Boreanische Tundra - Transitusschild; "..YELLOW.."33.4, 34.3"..WHITE..")"
Inst72Quest1_Note = "Das Forschungsergebnissbuch liegt auf dem Boden in der Halle auf den Weg zum Großmagistrix Telestra bei "..YELLOW.."[6]"..WHITE.."."
Inst72Quest1_Prequest = "Nein"
Inst72Quest1_Folgequest = "Nein"
--
Inst72Quest1name1 = "Schultern des Nordlichts"
Inst72Quest1name2 = "Geschmeidiger Mammutbalgmantel"
Inst72Quest1name3 = "Schulterschutz des Tundrafährtenlesers"
Inst72Quest1name4 = "Tundraschulterstücke"

--Quest 2 Alliance
Inst72Quest2 = "2. Das Unvermeidliche hinauszögern"
Inst72Quest2_Aim = "Erzmagier Berinand im Transitusschild möchte, dass Ihr den interdimensionalen Refabrikator in der Nähe des Risses im Nexus benutzt."
Inst72Quest2_Location = "Erzmagier Berinand (Boreanische Tundra - Transitusschild; "..YELLOW.."32.9, 34.3"..WHITE..")"
Inst72Quest2_Note = "Benutze den interdimensionalen Refabrikator am Ende der Plattform wo Anomaluson ist, bei "..YELLOW.."[1]"..WHITE.."."
Inst72Quest2_Prequest = "Die Zähler ablesen"
Inst72Quest2_Folgequest = "Nein"
--
Inst72Quest2name1 = "Zeitverzerrte Stulpen"
Inst72Quest2name2 = "Zeitstoppende Handschuhe"
Inst72Quest2name3 = "Bindungen der Sabotage"
Inst72Quest2name4 = "Stuplen des verwirrten Riesen"

--Quest 3 Alliance
Inst72Quest3 = "3. Kriegsgefangene"
Inst72Quest3_Aim = "Raelorasz im Transitusschild möchte, dass Ihr den Nexus betretet und Keristrasza befreit."
Inst72Quest3_Location = "Raelorasz (Boreanische Tundra - Transitusschild; "..YELLOW.."33.2, 34.4"..WHITE..")"
Inst72Quest3_Note = "Keristrasza ist bei "..YELLOW.."[4]"..WHITE.."."
Inst72Quest3_Prequest = "Keristrasza -> Die Falle zuschnappen lassen"
Inst72Quest3_Folgequest = "Nein"
--
Inst72Quest3name1 = "Umhang des Azurlichts"
Inst72Quest3name2 = "Mantelung von Keristrasza"
Inst72Quest3name3 = "Tuch der flüssigen Angriffe"

--Quest 4 Alliance
Inst72Quest4 = "4. Beschleunigen"
Inst72Quest4_Aim = "Erzmagier Berinand im Transitusschild möchte, dass Ihr den Nexus betretet und 5 arkane Späne von den kristallinen Beschützern beschafft."
Inst72Quest4_Location = "Erzmagier Berinand (Boreanische Tundra - Transitusschild; "..YELLOW.."32.9, 34.3"..WHITE..")"
Inst72Quest4_Note = "Arkane Späne droppen von den kristallinen Beschützern."
Inst72Quest4_Prequest = "Geheimnisse der Urtume"
Inst72Quest4_Folgequest = "Nein"
--
Inst72Quest4name1 = "Sandalen der mystischen Evolution"
Inst72Quest4name2 = "Treter der zerrissenen Zukunft"
Inst72Quest4name3 = "Stacheltreter der Mutation"
Inst72Quest4name4 = "Belebende Sabatons"
Inst72Quest4name5 = "Stiefel des unbeugsamen Beschützers"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst72Quest1_HORDE = Inst72Quest1
Inst72Quest1_HORDE_Aim = Inst72Quest1_Aim
Inst72Quest1_HORDE_Location = Inst72Quest1_Location
Inst72Quest1_HORDE_Note = Inst72Quest1_Note
Inst72Quest1_HORDE_Prequest = Inst72Quest1_Prequest
Inst72Quest1_HORDE_Folgequest = Inst72Quest1_Folgequest
--
Inst72Quest1name1_HORDE = Inst72Quest1name1
Inst72Quest1name2_HORDE = Inst72Quest1name2
Inst72Quest1name3_HORDE = Inst72Quest1ame3
Inst72Quest1name4_HORDE = Inst72Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst72Quest2_HORDE = Inst72Quest2
Inst72Quest2_HORDE_Aim = Inst72Quest2_Aim
Inst72Quest2_HORDE_Location = Inst72Quest2_Location
Inst72Quest2_HORDE_Note = Inst72Quest2_Note
Inst72Quest2_HORDE_Prequest = Inst72Quest2_Prequest
Inst72Quest2_HORDE_Folgequest = Inst72Quest2_Folgequest
--
Inst72Quest2name1_HORDE = Inst72Quest2name1
Inst72Quest2name2_HORDE = Inst72Quest2name2
Inst72Quest2name3_HORDE = Inst72Quest2name3
Inst72Quest2name4_HORDE = Inst72Quest2name4

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst72Quest3_HORDE = Inst72Quest3
Inst72Quest3_HORDE_Aim = Inst72Quest3_Aim
Inst72Quest3_HORDE_Location = Inst72Quest3_Location
Inst72Quest3_HORDE_Note = Inst72Quest3_Note
Inst72Quest3_HORDE_Prequest = Inst72Quest3_Prequest
Inst72Quest3_HORDE_Folgequest = Inst72Quest3_Folgequest
--
Inst72Quest3name1_HORDE = Inst72Quest3name1
Inst72Quest3name2_HORDE = Inst72Quest3name2
Inst72Quest3name3_HORDE = Inst72Quest3name3

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst72Quest4_HORDE = Inst72Quest4
Inst72Quest4_HORDE_Aim = Inst72Quest4_Aim
Inst72Quest4_HORDE_Location = Inst72Quest4_Location
Inst72Quest4_HORDE_Note = Inst72Quest4_Note
Inst72Quest4_HORDE_Prequest = Inst72Quest4_Prequest
Inst72Quest4_HORDE_Folgequest = Inst72Quest4_Folgequest
--
Inst72Quest4name1_HORDE = Inst72Quest4name1
Inst72Quest4name2_HORDE = Inst72Quest4name2
Inst72Quest4name3_HORDE = Inst72Quest4name3
Inst72Quest4name4_HORDE = Inst72Quest4name4
Inst72Quest4name5_HORDE = Inst72Quest4name5



--------------- INST73 - The Nexus: The Oculus ---------------

Inst73Story = "Der blaue Drachen Aspekt, Malygos, hat Risse mit seiner Handhabung der rohen magischen Energie geschaffen: Risse im Gewebe der magischen Dimension. Die Kirin Tor, die Elite Magier Dalarans, haben einen Rat mit dem roten Drachenschwarm gebildet, die mit der Bewahrung des Lebens aufgeladen werden. Zu diesem Zweck haben die zwei Gruppen aktiv begonnen, die verheerende Kampagne von Malygos zu stürzen. Die Seiten sind gewählt worden; die Kampflinien sind gezogen worden. Die einzige Frage, die jetzt bleibt, ist... Wer gewinnen wird."
Inst73Caption = "Der Nexus: Das Oculus"
Inst73QAA = "4 Quests"
Inst73QAH = "4 Quests"

--Quest 1 Alliance
Inst73Quest1 = "1. Der Kampf geht weiter"
Inst73Quest1_Aim = "Raelorasz möchte, dass Ihr Euch in das Oculus begebt und Belgaristrasz und seine Gefährten befreit."
Inst73Quest1_Location = "Raelorasz (Boreanische Tundra - Transitusschild; "..YELLOW.."33.2, 34.4"..WHITE..")"
Inst73Quest1_Note = "Belgaristrasz wird nach der Niedelgae von Drakos der Befrager erscheinen bei "..YELLOW.."[1]"..WHITE.."."
Inst73Quest1_Prequest = "Nein"
Inst73Quest1_Folgequest = "Vereinte Front"
--
Inst73Quest1name1 = "Ring der Kühnheit"
Inst73Quest1name2 = "Blühendes Band"
Inst73Quest1name3 = "Band der Motivation"
Inst73Quest1name4 = "Zuverlässiges Siegel"

--Quest 2 Alliance
Inst73Quest2 = "2. Vereinte Front"
Inst73Quest2_Aim = "Belgaristrasz möchte, dass Ihr 10 Zentrifugenkonstrukte zerstört, um Varos' Schild zu beseitigen. Danach müsst Ihr Varos Wolkenwanderer besiegen."
Inst73Quest2_Location = "Belgaristrasz (Der Nexus: Das Oculus; "..YELLOW.."[1]"..WHITE..")"
Inst73Quest2_Note = "Belgaristrasz erscheint nach dem Tode von Varos Wolkenwanderer bei "..YELLOW.."[2]"..WHITE.."."
Inst73Quest2_Prequest = "Der Kampf geht weiter"
Inst73Quest2_Folgequest = "Magierlord Urom"
-- No Rewards for this quest

--Quest 3 Alliance
Inst73Quest3 = "3. Magierlord Urom"
Inst73Quest3_Aim = "Belgaristrasz möchte, dass Ihr Magierlord Urom im Oculus besiegt."
Inst73Quest3_Location = "Abbild von Belgaristrasz (Der Nexus: Das Oculus; "..YELLOW.."[2]"..WHITE..")"
Inst73Quest3_Note = "Belgaristrasz erscheint nach dem Tode von Magierlord Urom bei "..YELLOW.."[3]"..WHITE.."."
Inst73Quest3_Prequest = "Vereinte Front"
Inst73Quest3_Folgequest = "Schlacht in den Wolken"
-- No Rewards for this quest

--Quest 4 Alliance
Inst73Quest4 = "4. Schlacht in den Wolken"
Inst73Quest4_Aim = "Belgaristrasz möchte, dass Ihr Eregos im Oculus tötet und anschließend bei Raelorasz im Transitusschild in Kaltarra Bericht erstattet."
Inst73Quest4_Location = "Abbild von Belgaristrasz (Der Nexus: Das Oculus; "..YELLOW.."[3]"..WHITE..")"
Inst73Quest4_Note = "Leywächter Eregos ist bei "..YELLOW.."[4]"..WHITE..". Raelorasz ist bei (Boreanische Tundra - Transitusschild; "..YELLOW.."33.2, 34.4"..WHITE..")."
Inst73Quest4_Prequest = "Magierlord Urom"
Inst73Quest4_Folgequest = "Nein"
--
Inst73Quest4name1 = "Fesseln der Dankbarkeit"
Inst73Quest4name2 = "Erhabene Gelenkbänder"
Inst73Quest4name3 = "Bindungen des Raelorasz"
Inst73Quest4name4 = "Armschienen der Ehrerbietung"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst73Quest1_HORDE = Inst73Quest1
Inst73Quest1_HORDE_Aim = Inst73Quest1_Aim
Inst73Quest1_HORDE_Location = Inst73Quest1_Location
Inst73Quest1_HORDE_Note = Inst73Quest1_Note
Inst73Quest1_HORDE_Prequest = Inst73Quest1_Prequest
Inst73Quest1_HORDE_Folgequest = Inst73Quest1_Folgequest
--
Inst73Quest1name1_HORDE = Inst73Quest1name1
Inst73Quest1name2_HORDE = Inst73Quest1name2
Inst73Quest1name3_HORDE = Inst73Quest1name3
Inst73Quest1name4_HORDE = Inst73Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst73Quest2_HORDE = Inst73Quest2
Inst73Quest2_HORDE_Aim = Inst73Quest2_Aim
Inst73Quest2_HORDE_Location = Inst73Quest2_Location
Inst73Quest2_HORDE_Note = Inst73Quest2_Note
Inst73Quest2_HORDE_Prequest = Inst73Quest2_Prequest
Inst73Quest2_HORDE_Folgequest = Inst73Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst73Quest3_HORDE = Inst73Quest3
Inst73Quest3_HORDE_Aim = Inst73Quest3_Aim
Inst73Quest3_HORDE_Location = Inst73Quest3_Location
Inst73Quest3_HORDE_Note = Inst73Quest3_Note
Inst73Quest3_HORDE_Prequest = Inst73Quest3_Prequest
Inst73Quest3_HORDE_Folgequest = Inst73Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst73Quest4_HORDE = Inst73Quest4
Inst73Quest4_HORDE_Aim = Inst73Quest4_Aim
Inst73Quest4_HORDE_Location = Inst73Quest4_Location
Inst73Quest4_HORDE_Note = Inst73Quest4_Note
Inst73Quest4_HORDE_Prequest = Inst73Quest4_Prequest
Inst73Quest4_HORDE_Folgequest = Inst73Quest4_Folgequest
--
Inst73Quest4name1_HORDE = Inst73Quest4name1
Inst73Quest4name2_HORDE = Inst73Quest4name2
Inst73Quest4name3_HORDE = Inst73Quest4name3
Inst73Quest4name4_HORDE = Inst73Quest4name4



--------------- INST74 - The Nexus: The Eye of Eternity ---------------

Inst74Story = {
  ["Page1"] = "Aus der Sicherheit seines persönlichen Domiziels, das Auge der Ewigkeit, führt Malygos einen Kreuzzug, um seine Herrschaft über die arkanen Energien wieder zuerlangen, die durch Azeroth strömt. In seinen Augen haben die unsinnigen Tätigkeiten der Kirin Tor und andere sterblichen Magier die Welt in Chaos gestürzt und der Missbrauch ihrer Kräfte will er nicht länger tolerieren. Bedroht durch die brutalen Taktiken des Spruchwirkers, haben sich die Kirin Tor mit den Roten Drachenschwarm verbündet. Zusammen beobachten die zwei Gruppen Malygos, suchen nach einem Weg, seine Kampagne zu durchkreuzen und den Aspekt der Magie anzugreifen, aber es hat sich erwiesen das es schwer ist den Spruchwirker zu beschäftigen.",
  ["Page2"] = "Am Wyrmruhtempel, dem alten Versammlungsplatz der Drachenschwärme, haben Alexstrasza und die Botschafter der anderen Schwärme über die Rücksichtslosigkeit von Malygos gesprochen und widerwillend beschlossen, dass er nicht mehr zu retten ist. Mit Hilfe der Roten Drachen könnten die Helden Azeroths fähig sein das zu vollbringen was früher undenkbar gewesen wär: das Herausfordern des Spruchwirkers innerhalb des Auge der Ewigkeit. Die Sicherheit Azeroths hängt vom Misserfolgs Malygos ab, aber sein Ende kündigt ein neues Zeitalter an: eine Welt der unbewachten Magie, abwesend des Drachen Aspekts der stark genug ist darüber zu wachen.",
  ["MaxPages"] = "2",
};
Inst74Caption = "Der Nexus: Das Auge der Ewigkeit"
Inst74QAA = "3 Quests"
Inst74QAH = "3 Quests"

--Quest 1 Alliance
Inst74Quest1 = "1. Entscheidung im Auge der Ewigkeit"
Inst74Quest1_Aim = "Krasus auf der Spitze des Wyrmruhtempels in der Drachenöde möchte, dass Ihr mit dem Herzen der Magie zurückkehrt."
Inst74Quest1_Location = "Krasus (Drachenöde - Wyrmruhtempel; "..YELLOW.."59.8, 54.6"..WHITE..")"
Inst74Quest1_Note = "Nach dem Tod von Malygos,kann sein Herz der Magie in der Nähe von Alexstrasza´s Geschenk, in einem rotierenden roten Herzen gefunden werden."
Inst74Quest1_Prequest = "Der Schlüssel der fokussierenden Iris ("..YELLOW.."Naxxramas"..WHITE..")"
Inst74Quest1_Folgequest = "Nein"
--
Inst74Quest1name1 = "Kette des uralten Wyrms"
Inst74Quest1name2 = "Halsreif des roten Drachenschwarms"
Inst74Quest1name3 = "Anhänger des Drachenverschworenen"
Inst74Quest1name4 = "Drachenschuppenkragen"

--Quest 2 Alliance
Inst74Quest2 = "2. Heroische Entscheidung im Auge der Ewigkeit"
Inst74Quest2_Aim = "Krasus auf der Spitze des Wyrmruhtempels in der Drachenöde möchte, dass Ihr mit dem Herzen der Magie zurückkehrt."
Inst74Quest2_Location = "Krasus (Drachenöde - Wyrmruhtemple; "..YELLOW.."59.8, 54.6"..WHITE..")"
Inst74Quest2_Note = "Nach dem Tod von Malygos,kann sein Herz der Magie in der Nähe von Alexstrasza´s Geschenk, in einem rotierenden roten Herzen gefunden werden."
Inst74Quest2_Prequest = "Der heroische Schlüssel der fokussierenden Iris ("..YELLOW.."Naxxramas"..WHITE..")"
Inst74Quest2_Folgequest = "Nein"
--
Inst74Quest2name1 = "Wyrmruhhalskette der Macht"
Inst74Quest2name2 = "Medaillon der Lebensbinderin"
Inst74Quest2name3 = "Gunst der Drachenkönigin"
Inst74Quest2name4 = "Perlen des Nexuskriegchampions"

--Quest 3 Alliance
Inst74Quest3 = "3. Malygos muss sterben! (Wöchentlich)"
Inst74Quest3_Aim = "Tötet Malygos."
Inst74Quest3_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst74Quest3_Note = "Malygos ist bei "..YELLOW.." [1]"..WHITE..".\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst74Quest3_Prequest = "Nein"
Inst74Quest3_Folgequest = "Nein"
--
Inst74Quest3name1 = "Emblem des Frosts"
Inst74Quest3name2 = "Emblem des Triumphs"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst74Quest1_HORDE = Inst74Quest1
Inst74Quest1_HORDE_Aim = Inst74Quest1_Aim
Inst74Quest1_HORDE_Location = Inst74Quest1_Location
Inst74Quest1_HORDE_Note = Inst74Quest1_Note
Inst74Quest1_HORDE_Prequest = Inst74Quest1_Prequest
Inst74Quest1_HORDE_Folgequest = Inst74Quest1_Folgequest
--
Inst74Quest1name1_HORDE = Inst74Quest1name1
Inst74Quest1name2_HORDE = Inst74Quest1name2
Inst74Quest1name3_HORDE = Inst74Quest1name3
Inst74Quest1name4_HORDE = Inst74Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst74Quest2_HORDE = Inst74Quest2
Inst74Quest2_HORDE_Aim = Inst74Quest2_Aim
Inst74Quest2_HORDE_Location = Inst74Quest2_Location
Inst74Quest2_HORDE_Note = Inst74Quest2_Note
Inst74Quest2_HORDE_Prequest = Inst74Quest2_Prequest
Inst74Quest2_HORDE_Folgequest = Inst74Quest2_Folgequest
--
Inst74Quest2name1_HORDE = Inst74Quest2name1
Inst74Quest2name2_HORDE = Inst74Quest2name2
Inst74Quest2name3_HORDE = Inst74Quest2name3
Inst74Quest2name4_HORDE = Inst74Quest2name4

--Quest 3 Horde (same as Quest 3 Alliance)
Inst74Quest3_HORDE = Inst74Quest3
Inst74Quest3_HORDE_Aim = Inst74Quest3_Aim
Inst74Quest3_HORDE_Location = Inst74Quest3_Location
Inst74Quest3_HORDE_Note = Inst74Quest3_Note
Inst74Quest3_HORDE_Prequest = Inst74Quest3_Prequest
Inst74Quest3_HORDE_Folgequest = Inst74Quest3_Folgequest
--
Inst74Quest3name1_HORDE = Inst74Quest3name1
Inst74Quest3name2_HORDE = Inst74Quest3name2



--------------- INST75 - Azjol-Nerub ---------------

Inst75Story = "Als der Lichkönig Nordend erreichte, war Azjol-Nerub ein mächtiges Reich. Eisernem Widerstand zum Trotz gelang es den Streitkräften der Geißel jedoch, das unterirdische Königreich zu erobern und seine Bewohner, die Neruber, zu vernichten. Das riesige, nach Jahren des Kriegs und der Zerstörung vernarbte Reich ist nun an zwei Fronten besetzt: Im Oberen Königreich patrouillieren untote Neruber die Ruinen ihrer Heimat und bewachen Gelege von Eiern, denen eines Tages eine neue Generation von Geißel-Kriegern entschlüpfen werden. Währenddessen rührt sich in den Tiefen des Alten Königreiches Ahn'kahet ein anderer Feind: die Gesichtslosen. Nur wenig ist von diesen schrecklichen Wesen bekannt, aber man munkelt, dass sie einer bösen Macht, die tief unter Nordend haust, zu Diensten sind. Würden die untoten Neruber und ihre verderbten Eier vernichtet werden, so wäre dies ein gewaltiger Schlag gegen den Lichkönig; jedoch ist auch die Eliminierung der mysteriösen Gesichtslosen unerlässlich, soll das gefallene Reich jemals wieder auferstehen."
Inst75Caption = "Azjol-Nerub"
Inst75QAA = "2 Quests"
Inst75QAH = "2 Quests"

--Quest 1 Alliance
Inst75Quest1 = "1. Vergesst nicht die Eier!"
Inst75Quest1_Aim = "Kilix der Entwirrer in der Grube von Narjun möchte, dass Ihr Azjol-Nerub betretet und 6 Eier der Geißelneruber zerstört."
Inst75Quest1_Location = "Kilix der Entwirrer (Drachenöde - Azjol-Nerub; "..YELLOW.."26.1, 50.0"..WHITE..")"
Inst75Quest1_Note = "Die Eier der Geiselneruber sind im ersten Raum überall verteilt, beim ersten Boss, Krik'thir der Torwächter bei "..YELLOW.."[1]"..WHITE.."."
Inst75Quest1_Prequest = "Nein"
Inst75Quest1_Folgequest = "Nein"
--
Inst75Quest1name1 = "Ausstoßende Stulpen"
Inst75Quest1name2 = "Reinigende Handschützer"
Inst75Quest1name3 = "Wickeltücher des bezwungenen Banns"
Inst75Quest1name4 = "Handschuhe der verbannten Auferlegung"

--Quest 2 Alliance
Inst75Quest2 = "2. Tot dem verräter König"
Inst75Quest2_Aim = "Kilix der Entwirrer in der Grube von Narjun hat Euch damit beauftragt, Anub'arak in Azjol-Nerub zu besiegen. Danach sollt Ihr Kilix Anub'araks zerbrochenen Panzer zurückbringen."
Inst75Quest2_Location = "Kilix der Entwirrer (Drachenöde - Azjol-Nerub; "..YELLOW.."26.1, 50.0"..WHITE..")"
Inst75Quest2_Note = "Anub'arak ist bei "..YELLOW.."[3]"..WHITE.."."
Inst75Quest2_Prequest = "Nein"
Inst75Quest2_Folgequest = "Nein"
--
Inst75Quest2name1 = "Kilix' Seidenslipper"
Inst75Quest2name2 = "Don Sotos Stiefel"
Inst75Quest2name3 = "Hüllenfragmentsabatons"
Inst75Quest2name4 = "Schienbeinschützer des Verräters"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst75Quest1_HORDE = Inst75Quest1
Inst75Quest1_HORDE_Aim = Inst75Quest1_Aim
Inst75Quest1_HORDE_Location = Inst75Quest1_Location
Inst75Quest1_HORDE_Note = Inst75Quest1_Note
Inst75Quest1_HORDE_Prequest = Inst75Quest1_Prequest
Inst75Quest1_HORDE_Folgequest = Inst75Quest1_Folgequest
--
Inst75Quest1name1_HORDE = Inst75Quest1name1
Inst75Quest1name2_HORDE = Inst75Quest1name2
Inst75Quest1name3_HORDE = Inst75Quest1name3
Inst75Quest1name4_HORDE = Inst75Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst75Quest2_HORDE = Inst75Quest2
Inst75Quest2_HORDE_Aim = Inst75Quest2_Aim
Inst75Quest2_HORDE_Location = Inst75Quest2_Location
Inst75Quest2_HORDE_Note = Inst75Quest2_Note
Inst75Quest2_HORDE_Prequest = Inst75Quest2_Prequest
Inst75Quest2_HORDE_Folgequest = Inst75Quest2_Folgequest
--
Inst75Quest2name1_HORDE = Inst75Quest2name1
Inst75Quest2name2_HORDE = Inst75Quest2name2
Inst75Quest2name3_HORDE = Inst75Quest2name3
Inst75Quest2name4_HORDE = Inst75Quest2name4



--------------- INST76 - Ahn'kahet: The Old Kingdom ---------------

Inst76Story = "Als der Lichkönig Nordend erreichte, war Azjol-Nerub ein mächtiges Reich. Eisernem Widerstand zum Trotz gelang es den Streitkräften der Geißel jedoch, das unterirdische Königreich zu erobern und seine Bewohner, die Neruber, zu vernichten. Das riesige, nach Jahren des Kriegs und der Zerstörung vernarbte Reich ist nun an zwei Fronten besetzt: Im Oberen Königreich patrouillieren untote Neruber die Ruinen ihrer Heimat und bewachen Gelege von Eiern, denen eines Tages eine neue Generation von Geißel-Kriegern entschlüpfen werden. Währenddessen rührt sich in den Tiefen des Alten Königreiches Ahn'kahet ein anderer Feind: die Gesichtslosen. Nur wenig ist von diesen schrecklichen Wesen bekannt, aber man munkelt, dass sie einer bösen Macht, die tief unter Nordend haust, zu Diensten sind. Würden die untoten Neruber und ihre verderbten Eier vernichtet werden, so wäre dies ein gewaltiger Schlag gegen den Lichkönig; jedoch ist auch die Eliminierung der mysteriösen Gesichtslosen unerlässlich, soll das gefallene Reich jemals wieder auferstehen."
Inst76Caption = "Ahn'kahet: Das alte Königreich"
Inst76QAA = "3 Quests"
Inst76QAH = "3 Quests"

--Quest 1 Alliance
Inst76Quest1 = "1. Alles zu seiner Zeit (Heroisches Tagesquest)"
Inst76Quest1_Aim = "Kilix der Entwirrer in der Grube von Narjun möchte, dass Ihr die Leiche eines Wächters der Ahn'kahar beschafft und sie auf das Kohlebecken von Ahn'kahet in Ahn'kahet legt."
Inst76Quest1_Location = "Kilix der Entwirrer (Drachenöde - Azjol-Nerub; "..YELLOW.."26.1, 50.0"..WHITE..")"
Inst76Quest1_Note = "Diese Aufgabe kann nur auf dem Schwierigkeitsgrad Heroisch abgeschlossen werden.\n\nThe Ahn'kahet Brazier ist hinter Herald Volazj bei "..YELLOW.."[4]"..WHITE..". The corpse has a 1 hour duration timer and will disappear if you leave the instance while alive."
Inst76Quest1_Prequest = "Nein"
Inst76Quest1_Folgequest = "Nein"
-- No Rewards for this quest

--Quest 2 Alliance
Inst76Quest2 = "2. Abgefahrene Pilze"
Inst76Quest2_Aim = "Ihr sollt 6 groteske Pilze von den wilden Höhlenbestien sammeln und sie bei Kilix der Entwirrer in der Grube von Narjun abliefern."
Inst76Quest2_Location = "Groteske Pilze (droppen von den wilden Höhlenbestien in Ahn'kahet)"
Inst76Quest2_Note = "Die wilden Höhlenbestien droppen das Item für die Quest im Gebiet vom Boss Amanitar, bei "..YELLOW.."[5]"..WHITE..".\n\nKilix der Entwirrer ist bei (Drachenöde - Azjol-Nerub; "..YELLOW.."26.1, 50.0"..WHITE..")."
Inst76Quest2_Prequest = "Nein"
Inst76Quest2_Folgequest = "Nein"
-- No Rewards for this quest

--Quest 3 Alliance
Inst76Quest3 = "3. Die Gesichtslosen"
Inst76Quest3_Aim = "Kilix der Entwirrer in der Grube von Narjun möchte, dass Ihr nach Ahn'Kahet geht und Herold Volazj und die drei Vergessenen an seiner Seite tötet."
Inst76Quest3_Location = "Kilix der Entwirrer (Drachenöde - Azjol-Nerub; "..YELLOW.."26.1, 50.0"..WHITE..")"
Inst76Quest3_Note = "Die Vergessenen und Herald Volazj können gefunden werden bei "..YELLOW.."[4]"..WHITE.."."
Inst76Quest3_Prequest = "Nein"
Inst76Quest3_Folgequest = "Nein"
--
Inst76Quest3name1 = "Mantel des vereitelten Übels"
Inst76Quest3name2 = "Schulterpolster der Verachtung"
Inst76Quest3name3 = "Schulterplatten des Abgeschafften"
Inst76Quest3name4 = "Schulterklappen der Gesichtslosen"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst76Quest1_HORDE = Inst76Quest1
Inst76Quest1_HORDE_Aim = Inst76Quest1_Aim
Inst76Quest1_HORDE_Location = Inst76Quest1_Location
Inst76Quest1_HORDE_Note = Inst76Quest1_Note
Inst76Quest1_HORDE_Prequest = Inst76Quest1_Prequest
Inst76Quest1_HORDE_Folgequest = Inst76Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst76Quest2_HORDE = Inst76Quest2
Inst76Quest2_HORDE_Aim = Inst76Quest2_Aim
Inst76Quest2_HORDE_Location = Inst76Quest2_Location
Inst76Quest2_HORDE_Note = Inst76Quest2_Note
Inst76Quest2_HORDE_Prequest = Inst76Quest2_Prequest
Inst76Quest2_HORDE_Folgequest = Inst76Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst76Quest3_HORDE = Inst76Quest3
Inst76Quest3_HORDE_Aim = Inst76Quest3_Aim
Inst76Quest3_HORDE_Location = Inst76Quest3_Location
Inst76Quest3_HORDE_Note = Inst76Quest3_Note
Inst76Quest3_HORDE_Prequest = Inst76Quest3_Prequest
Inst76Quest3_HORDE_Folgequest = Inst76Quest3_Folgequest
--
Inst76Quest3name1_HORDE = Inst76Quest3name1
Inst76Quest3name2_HORDE = Inst76Quest3name2
Inst76Quest3name3_HORDE = Inst76Quest3name3
Inst76Quest3name4_HORDE = Inst76Quest3name4



--------------- INST77 - Ulduar: Halls of Stone ---------------

Inst77Story = "In den kalten Klippen der Sturmgipfeln, verbrachte der legendärere Forscher Brann Bronzebart unzählige Stunden damit Hinweise über die kürzlich entdeckte Titanstadt, die als Ulduar bekannt ist, zu finden. Aber weit ab davon, die Mysterien der Titanen auszugraben, fand der Forscher die Stadt überrannt mit Eisenzwergen. Eifrig, die unbezahlbare Information innerhalb der Titanenstadt zu sichern, bevor diese zerstört würden und für immer verlor gingen, fürchtete Brann, dass ein noch größeres Übel bei der Arbeit hinter dem Fall von Ulduar sein konnte...."
Inst77Caption = "HdS: Hallen des Steins"
Inst77QAA = "1 Quests"
Inst77QAH = "1 Quests"

--Quest 1 Alliance
Inst77Quest1 = "1. Die Hallen des Steins"
Inst77Quest1_Aim = "Brann Bronzebart möchte, dass Ihr ihn bei der Suche nach den Geheimnissen, die in den Hallen des Steins verborgen liegen, begleitet."
Inst77Quest1_Location = "Brann Bronzebart (Ulduar: Die Hallen des Steins; "..YELLOW.."[3]"..WHITE..")"
Inst77Quest1_Note = "Folgt Brann Bronzebart in den naheliegenden Raum bei "..YELLOW.."[4]"..WHITE.." und beschützt ihn vor die Mobwellen während er an der Steintafel arbeitet. Nach seinem Erfolg , kann der Tribunalkasten rechts neben der Steintafel geöffnet werden.\n\nSprecht ihn erneut an und er rennt aus dem Raum raus zu"..YELLOW.."[5]"..WHITE..". Du mußt ihm nicht folgen, er wartet dort auf dich. Ist Sjonnir der Eisenformer besiegt kann Du die Quest bei Brann Bronzebart abgegeben."
Inst77Quest1_Prequest = "Nein"
Inst77Quest1_Folgequest = "Nein"
--
Inst77Quest1name1 = "Mantel des unerschrockenen Entdeckers"
Inst77Quest1name2 = "Schulterpolster des Abenteurers"
Inst77Quest1name3 = "Schiftung der verlorenen Geheimnisse"
Inst77Quest1name4 = "Schulterstücke der Aufklärung"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst77Quest1_HORDE = Inst77Quest1
Inst77Quest1_HORDE_Aim = Inst77Quest1_Aim
Inst77Quest1_HORDE_Location = Inst77Quest1_Location
Inst77Quest1_HORDE_Note = Inst77Quest1_Note
Inst77Quest1_HORDE_Prequest = Inst77Quest1_Prequest
Inst77Quest1_HORDE_Folgequest = Inst77Quest1_Folgequest
--
Inst77Quest1name1_HORDE = Inst77Quest1name1
Inst77Quest1name2_HORDE = Inst77Quest1name2
Inst77Quest1name3_HORDE = Inst77Quest1name3
Inst77Quest1name4_HORDE = Inst77Quest1name4



--------------- INST78 - Ulduar: Halls of Lightning ---------------

Inst78Story = "In den kalten Klippen der Sturmgipfeln, verbrachte der legendärere Forscher Brann Bronzebart unzählige Stunden damit Hinweise über die kürzlich entdeckte Titanstadt, die als Ulduar bekannt ist, zu finden. Aber weit ab davon, die Mysterien der Titanen auszugraben, fand der Forscher die Stadt überrannt mit Eisenzwergen. Eifrig, die unbezahlbare Information innerhalb der Titanenstadt zu sichern, bevor diese zerstört würden und für immer verlor gingen, fürchtete Brann, dass ein noch größeres Übel bei der Arbeit hinter dem Fall von Ulduar sein konnte...."
Inst78Caption = "HdB: Hallen der Blitze"
Inst78QAA = "2 Quests"
Inst78QAH = "2 Quests"

--Quest 1 Alliance
Inst78Quest1 = "1. Koste es, was es wolle!"
Inst78Quest1_Aim = "König Jokkum in Dun Niffelem wünscht, dass Ihr die Hallen der Blitze betretet und Loken besiegt. Danach sollt Ihr mit Lokens Zunge zu König Jokkum zurückkehren."
Inst78Quest1_Location = "König Jokkum (Die Sturmgipfel - Dun Niffelem; "..YELLOW.."65.3, 60.1"..WHITE..")"
Inst78Quest1_Note = "Loken ist bei "..YELLOW.."[4]"..WHITE..".\n\nDiese Quest bekommt man erst nach einer sehr langen Questreihe die bei Gretchen Zischelfunken beginnt (Sturmgipfel - K3; "..YELLOW.."41.1, 86.1"..WHITE..")."
Inst78Quest1_Prequest = "Sie haben unsere Männer! -> Die Abrechnung"
Inst78Quest1_Folgequest = "Nein"
--
Inst78Quest1name1 = "Robe des Blitzes"
Inst78Quest1name2 = "Gehärtete Zungentunika"
Inst78Quest1name3 = "Halsberge des Blitzschlägers"
Inst78Quest1name4 = "Brustplatte des Zackensteins"

--Quest 2 Alliance
Inst78Quest2 = "2. Diametral entgegengesetzt"
Inst78Quest2_Aim = "König Jokkum in Dun Niffelem wünscht, dass Ihr die Hallen der Blitze betretet und Volkhan besiegt."
Inst78Quest2_Location = "König Jokkum (Die Sturmgipfel - Dun Niffelem; "..YELLOW.."65.3, 60.1"..WHITE..")"
Inst78Quest2_Note = "Volkhan ist bei "..YELLOW.."[2]"..WHITE..".\n\nDiese Quest bekommt man erst nach einer sehr langen Questreihe die bei Gretchen Zischelfunken beginnt (Sturmgipfel - K3; "..YELLOW.."41.1, 86.1"..WHITE..")."
Inst78Quest2_Prequest = "Sie haben unsere Männer! -> Die Abrechnung"
Inst78Quest2_Folgequest = "Nein"
--
Inst78Quest2name1 = "Blitzerfüllte Mantelung"
Inst78Quest2name2 = "Verkohlter Lederschulterschutz"
Inst78Quest2name3 = "Strrmgeschmiedete Schultern"
Inst78Quest2name4 = "Schulterstücke des erloschenen Hasses"
Inst78Quest2name5 = "Mantelung von Volkhan"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst78Quest1_HORDE = Inst78Quest1
Inst78Quest1_HORDE_Aim = Inst78Quest1_Aim
Inst78Quest1_HORDE_Location = Inst78Quest1_Location
Inst78Quest1_HORDE_Note = Inst78Quest1_Note
Inst78Quest1_HORDE_Prequest = Inst78Quest1_Prequest
Inst78Quest1_HORDE_Folgequest = Inst78Quest1_Folgequest
--
Inst78Quest1name1_HORDE = Inst78Quest1name1
Inst78Quest1name2_HORDE = Inst78Quest1name2
Inst78Quest1name3_HORDE = Inst78Quest1name3
Inst78Quest1name4_HORDE = Inst78Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst78Quest2_HORDE = Inst78Quest2
Inst78Quest2_HORDE_Aim = Inst78Quest2_Aim
Inst78Quest2_HORDE_Location = Inst78Quest2_Location
Inst78Quest2_HORDE_Note = Inst78Quest2_Note
Inst78Quest2_HORDE_Prequest = Inst78Quest2_Prequest
Inst78Quest2_HORDE_Folgequest = Inst78Quest2_Folgequest
--
Inst78Quest2name1_HORDE = Inst78Quest2name1
Inst78Quest2name2_HORDE = Inst78Quest2name2
Inst78Quest2name3_HORDE = Inst78Quest2name3
Inst78Quest2name4_HORDE = Inst78Quest2name4
Inst78Quest2name5_HORDE = Inst78Quest2name5



--------------- INST79 - The Obsidian Sanctum ---------------

Inst79Story = "No information."
Inst79Caption = "Der Obsidiandrachenschrein"
Inst79QAA = "1 Quest"
Inst79QAH = "1 Quest"

--Quest 1 Alliance
Inst79Quest1 = "1. Sartharion muss sterben! (Wöchentlich)"
Inst79Quest1_Aim = "Tötet Sartharion."
Inst79Quest1_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst79Quest1_Note = "Sartharion ist bei "..YELLOW.."[4]"..WHITE..".\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst79Quest1_Prequest = "Nein"
Inst79Quest1_Folgequest = "Nein"
--
Inst79Quest1name1 = "Emblem des Frosts"
Inst79Quest1name2 = "Emblem des Triumphs"


--Quest 1 Horde (same as Quest 1 Alliance)
Inst79Quest1_HORDE = Inst79Quest1
Inst79Quest1_HORDE_Aim = Inst79Quest1_Aim
Inst79Quest1_HORDE_Location = Inst79Quest1_Location
Inst79Quest1_HORDE_Note = Inst79Quest1_Note
Inst79Quest1_HORDE_Prequest = Inst79Quest1_Prequest
Inst79Quest1_HORDE_Folgequest = Inst79Quest1_Folgequest
--
Inst79Quest1name1_HORDE = Inst79Quest1name1
Inst79Quest1name2_HORDE = Inst79Quest1name2



--------------- INST80 - Drak'Tharon Keep ---------------

Inst80Story = "Einst diente die Feste Drak'Tharon den Drakkari-Trollen als uneinnehmbarer Außenposten am Rande ihres Imperiums, Zul'Drak. Doch nun hat die Invasion der Geißel das Bollwerk dem Lichkönig in die Hände gespielt. Die gefallenen Verteidiger der Festung fristen nun ein Dasein als untote Lakaien des Lichkönig und sind auf dem Vormarsch in das Herz des Drakkari-Territoriums. Selbst den größten Kriegern der Eistrolle ist es nicht gelungen, die besetzte Bastion zurückzugewinnen. Die Neutralisierung der Bedrohung, die Drak'Tharon für die Zukunft Zul'Draks darstellt, ist eine Aufgabe, deren Erfüllung ungeheuren Mut erfordert, und sollte sie nicht schnell angegangen werden, könnte das gesamte Drakkari-Reich, zusammen mit der Macht seiner wilden Götter, der Geißel in die Hände fallen."
Inst80Caption = "Feste Drak'Tharon"
Inst80QAA = "3 Quests"
Inst80QAH = "3 Quests"

--Quest 1 Alliance
Inst80Quest1 = "1. Die Reinigung Drak'Tharons"
Inst80Quest1_Aim = "Drakuru möchte, dass Ihr Drakurus Elixier an seinem Kohlenbecken innerhalb Drak'Tharons Feste benutzt. Um das Elixier dort benutzen zu können, benötigt Ihr 5 Ausdauermojos."
Inst80Quest1_Location = "Abbild von Drakuru"
Inst80Quest1_Note = "Drakuru's Kohlenbecken ist hinter dem Propheten Tharon'ja bei "..YELLOW.."[5]"..WHITE..". Ausdauermojos droppen innerhalb Drak'Tharons Feste."
Inst80Quest1_Prequest = "Waffenstillstand? -> Stimmen aus dem Staub"
Inst80Quest1_Folgequest = "Nein"
--
Inst80Quest1name1 = "Schleier der Verführung"
Inst80Quest1name2 = "Verführerische Sabatons"
Inst80Quest1name3 = "Fesseln des dunklen Geflüsters"
Inst80Quest1name4 = "Schultern des Verführers"

--Quest 2 Alliance
Inst80Quest2 = "2. Rettungsaktion"
Inst80Quest2_Aim = "Mack beim Granitquell möchte, dass Ihr nach Drak'Tharon geht und herausfindet, was mit Kurzel passiert ist."
Inst80Quest2_Location = "Mack Fearsen (Grizzly Hügel - Granitquell; "..YELLOW.."16.6, 48.1"..WHITE..")"
Inst80Quest2_Note = "Kurzel ist in einem der eingesponnenen Kokons bei "..YELLOW.."[2]"..WHITE..". Bekämpfe die eingesponnenen Kokons und Du wirst sie finden."
Inst80Quest2_Prequest = "Die angesengten Geisel"
Inst80Quest2_Folgequest = "Psychospielchen"
--
Inst80Quest2name1 = "Kurzels Angst"
Inst80Quest2name2 = "Kurzels Zorn"
Inst80Quest2name3 = "Kurzels Kriegsband"

--Quest 3 Alliance
Inst80Quest3 = "3. Psychospielchen"
Inst80Quest3_Aim = "Kurzel möchte, dass Ihr den Fetzen von Kurzels Bluse auf die Reste von Novos dem Beschwörer in der Feste Drak'Tharon anwendet und anschließend den sekretbefleckten Stoff zu Mack bringt."
Inst80Quest3_Location = "Kurzel (Feste Drak'Tharon; "..YELLOW.."[2]"..WHITE..")"
Inst80Quest3_Note = "Novos der Beschwörer ist bei "..YELLOW.."[3]"..WHITE..". Mack Fearsen ist bei (Grizzly Hügel - Granitquell; "..YELLOW.."16.6, 48.1"..WHITE..")"
Inst80Quest3_Prequest = "Rettungsaktion"
Inst80Quest3_Folgequest = "Nein"
--
Inst80Quest3name1 = "Beschämende Fesseln"
Inst80Quest3name2 = "Verachtende Bänder"
Inst80Quest3name3 = "Beschuldigte Handgelenksschützer"
Inst80Quest3name4 = "Abgeleugnete Armschienen"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst80Quest1_HORDE = Inst80Quest1
Inst80Quest1_HORDE_Aim = Inst80Quest1_Aim
Inst80Quest1_HORDE_Location = Inst80Quest1_Location
Inst80Quest1_HORDE_Note = Inst80Quest1_Note
Inst80Quest1_HORDE_Prequest = Inst80Quest1_Prequest
Inst80Quest1_HORDE_Folgequest = Inst80Quest1_Folgequest
--
Inst80Quest1name1_HORDE = Inst80Quest1name1
Inst80Quest1name2_HORDE = Inst80Quest1name2
Inst80Quest1name3_HORDE = Inst80Quest1name3
Inst80Quest1name4_HORDE = Inst80Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst80Quest2_HORDE = Inst80Quest2
Inst80Quest2_HORDE_Aim = Inst80Quest2_Aim
Inst80Quest2_HORDE_Location = Inst80Quest2_Location
Inst80Quest2_HORDE_Note = Inst80Quest2_Note
Inst80Quest2_HORDE_Prequest = Inst80Quest2_Prequest
Inst80Quest2_HORDE_Folgequest = Inst80Quest2_Folgequest
--
Inst80Quest2name1_HORDE = Inst80Quest2name1
Inst80Quest2name2_HORDE = Inst80Quest2name2
Inst80Quest2name3_HORDE = Inst80Quest2name3

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst80Quest3_HORDE = Inst80Quest3
Inst80Quest3_HORDE_Aim = Inst80Quest3_Aim
Inst80Quest3_HORDE_Location = Inst80Quest3_Location
Inst80Quest3_HORDE_Note = Inst80Quest3_Note
Inst80Quest3_HORDE_Prequest = Inst80Quest3_Prequest
Inst80Quest3_HORDE_Folgequest = Inst80Quest3_Folgequest
--
Inst80Quest3name1_HORDE = Inst80Quest3name1
Inst80Quest3name2_HORDE = Inst80Quest3name2
Inst80Quest3name3_HORDE = Inst80Quest3name3
Inst80Quest3name4_HORDE = Inst80Quest3name4



--------------- INST81 - Gundrak ---------------

Inst81Story = "In ihrer Verzweiflung, ihr Königreich vor dem Zusammenbruch zu bewahren, haben die Trolle von Zul'Drak mit der Opferung ihrer uralten Götter begonnen. Die wilden Gottheiten werden nun als bislang ungenutzte Energiequelle betrachtet und ihr kraftvolles Blut zur Verteidigung gegen die Diener des Lichkönigs verwendet, die Teile der Trollnation übernommen haben. Vor kurzem sind Helden in die belagerte Region gereist, um einen Schlag gegen die Drakkari und ihre verrückt gewordenen Propheten auszuführen.\n\nTrotzdem lauert die größte Bedrohung für die Region ungestört im Inneren von Gundrak, der Hauptstadt der Eistrolle. Man sagt, dass in den Tiefen der Stadt die geheiligsten Schreine vom Mojo getöteter Götter durchdrungen sein sollen. Von dieser dunklen Energie umgeben, wächst nun die Macht der ruchlosen Hochpropheten der Drakkari, die ihre Anhänger mit unglaublicher Stärke erfüllen. Sollten sie unbehelligt bleiben, werden die Trolle von Gundrak schon bald ihre wachsende Macht entfesseln und die gesamte Region ins Chaos stürzen."
Inst81Caption = "Gundrak"
Inst81QAA = "3 Quests"
Inst81QAH = "3 Quests"

--Quest 1 Alliance
Inst81Quest1 = "1. Für die Nachwelt"
Inst81Quest1_Aim = "Chronistin Bah'Kini in Dubra'Jin möchte, dass Ihr nach Gundrak geht und 6 Geschichtstafeln der Drakkari sammelt."
Inst81Quest1_Location = "Chronistin Bah'Kini (Zul'Drak - Dubra'Jin; "..YELLOW.."70.0, 20.9"..WHITE..")"
Inst81Quest1_Note = "Die Geschichtstafeln sind überall in der Instant verteilt. Es sind genug vorhanden um damit eine komplette Gruppe diese Quest beenden kann. Die Vorquest ist optional."
Inst81Quest1_Prequest = "Nur ma' nachsehen"
Inst81Quest1_Folgequest = "Nein"
--
Inst81Quest1name1 = "Ring des Löwenkopfes"
Inst81Quest1name2 = "Ring des faulen Mojos"
Inst81Quest1name3 = "Solides Platinband"
Inst81Quest1name4 = "Voodoosiegel"

--Quest 2 Alliance
Inst81Quest2 = "2. Gal'darah muss bezahlen"
Inst81Quest2_Aim = "Tol'mar in Dubra'Jin möchte, dass Ihr Gal'darah in Gundrak erschlagt."
Inst81Quest2_Location = "Tol'mar (Zul'Drak - Dubra'Jin; "..YELLOW.."69.9, 22.8"..WHITE..")"
Inst81Quest2_Note = "Gal'darah ist bei "..YELLOW.."[5]"..WHITE.."."
Inst81Quest2_Prequest = "Noch ein Hühnchen rupfen"
Inst81Quest2_Folgequest = "Nein"
--
Inst81Quest2name1 = "Listige Mojoscherpe"
Inst81Quest2name2 = "Seltsamer Voodoogürtel"
Inst81Quest2name3 = "Waldläufergürtel des gefallenen Imperiums"
Inst81Quest2name4 = "Schnalle des gefallenen Halbgotts"

--Quest 3 Alliance
Inst81Quest3 = "3. Einzelstück"
Inst81Quest3_Aim = "Chronistin Bah'Kini in Dubra'Jin möchte, dass Ihr nach Gundrak geht und ein Fragment des Kolosses der Drakkari beschafft."
Inst81Quest3_Location = "Chronicler Bah'Kini (Zul'Drak - Dubra'Jin; "..YELLOW.."70.0, 20.9"..WHITE..")"
Inst81Quest3_Note = "Fragment des Kolosses der Drakkari droppt von den Drakkari Kolossen bei "..YELLOW.."[2]"..WHITE.."."
Inst81Quest3_Prequest = "Nein"
Inst81Quest3_Folgequest = "Nein"
--
Inst81Quest3name1 = "Pelzbesetzte Moccasins"
Inst81Quest3name2 = "Rhinozerosbalgkniestiefel"
Inst81Quest3name3 = "Schuppenstiefel der gefallenen Hoffnung"
Inst81Quest3name4 = "Slipper des Mojodojos"
Inst81Quest3name5 = "Trollkicker"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst81Quest1_HORDE = Inst81Quest1
Inst81Quest1_HORDE_Aim = Inst81Quest1_Aim
Inst81Quest1_HORDE_Location = Inst81Quest1_Location
Inst81Quest1_HORDE_Note = Inst81Quest1_Note
Inst81Quest1_HORDE_Prequest = Inst81Quest1_Prequest
Inst81Quest1_HORDE_Folgequest = Inst81Quest1_Folgequest
--
Inst81Quest1name1_HORDE = Inst81Quest1name1
Inst81Quest1name2_HORDE = Inst81Quest1name2
Inst81Quest1name3_HORDE = Inst81Quest1name3
Inst81Quest1name4_HORDE = Inst81Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst81Quest2_HORDE = Inst81Quest2
Inst81Quest2_HORDE_Aim = Inst81Quest2_Aim
Inst81Quest2_HORDE_Location = Inst81Quest2_Location
Inst81Quest2_HORDE_Note = Inst81Quest2_Note
Inst81Quest2_HORDE_Prequest = Inst81Quest2_Prequest
Inst81Quest2_HORDE_Folgequest = Inst81Quest2_Folgequest
--
Inst81Quest2name1_HORDE = Inst81Quest2name1
Inst81Quest2name2_HORDE = Inst81Quest2name2
Inst81Quest2name3_HORDE = Inst81Quest2name3
Inst81Quest2name4_HORDE = Inst81Quest2name4

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst81Quest3_HORDE = Inst81Quest3
Inst81Quest3_HORDE_Aim = Inst81Quest3_Aim
Inst81Quest3_HORDE_Location = Inst81Quest3_Location
Inst81Quest3_HORDE_Note = Inst81Quest3_Note
Inst81Quest3_HORDE_Prequest = Inst81Quest3_Prequest
Inst81Quest3_HORDE_Folgequest = Inst81Quest3_Folgequest
--
Inst81Quest3name1_HORDE = Inst81Quest3name1
Inst81Quest3name2_HORDE = Inst81Quest3name2
Inst81Quest3name3_HORDE = Inst81Quest3name3
Inst81Quest3name4_HORDE = Inst81Quest3name4
Inst81Quest3name5_HORDE = Inst81Quest3name5



--------------- INST82 - The Violet Hold ---------------

Inst82Caption = "VF: Die Violette Festung"
Inst82QAA = "2 Quests"
Inst82QAH = "2 Quests"

--Quest 1 Alliance
Inst82Quest1 = "1. Diskretion ist der Schlüssel"
Inst82Quest1_Aim = "Rhonin möchte, dass Ihr zur Violetten Festung in Dalaran geht und mit Aufseher Alturas sprecht."
Inst82Quest1_Location = "Rhonin (Dalaran - Die Violette Zitadelle; "..YELLOW.."30.5, 48.4"..WHITE..")"
Inst82Quest1_Note = "Aufseher Alturas ist bei (Dalaran - Die Violette Festung; "..YELLOW.."60.8, 62.7"..WHITE..")"
Inst82Quest1_Prequest = "Nein"
Inst82Quest1_Folgequest = "Eindämmung"
-- No Rewards for this quest

--Quest 2 Alliance
Inst82Quest2 = "2. Eindämmung"
Inst82Quest2_Aim = "Aufseher Alturas möchte, dass Ihr die Violette Festung betretet und den Invasionsstreitkräften des blauen Drachenschwarms ein Ende bereitet. Ihr sollt Euch wieder bei ihm melden, sobald Cyanigosa getötet wurde."
Inst82Quest2_Location = "Aufseher Alturas (Dalaran - Die Violette Festung; "..YELLOW.."60.8, 62.7"..WHITE..")"
Inst82Quest2_Note = "Cyanigosa ist bei "..YELLOW.."[6]"..WHITE.."."
Inst82Quest2_Prequest = "Diskretion ist der Schlüssel"
Inst82Quest2_Folgequest = "Nein"
--
Inst82Quest2name1 = "Tätowierte Wildhautgamaschen"
Inst82Quest2name2 = "Verliehene Pantalons"
Inst82Quest2name3 = "Labyrinthische Beinschützer"
Inst82Quest2name4 = "Beinplatten des Wächters von Dalaran"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst82Quest1_HORDE = Inst82Quest1
Inst82Quest1_HORDE_Aim = Inst82Quest1_Aim
Inst82Quest1_HORDE_Location = Inst82Quest1_Location
Inst82Quest1_HORDE_Note = Inst82Quest1_Note
Inst82Quest1_HORDE_Prequest = Inst82Quest1_Prequest
Inst82Quest1_HORDE_Folgequest = Inst82Quest1_Folgequest
-- No Rewards for this ques

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst82Quest2_HORDE = Inst82Quest2
Inst82Quest2_HORDE_Aim = Inst82Quest2_Aim
Inst82Quest2_HORDE_Location = Inst82Quest2_Location
Inst82Quest2_HORDE_Note = Inst82Quest2_Note
Inst82Quest2_HORDE_Prequest = Inst82Quest2_Prequest
Inst82Quest2_HORDE_Folgequest = Inst82Quest2_Folgequest
--
Inst82Quest2name1_HORDE = Inst82Quest2name1
Inst82Quest2name2_HORDE = Inst82Quest2name2
Inst82Quest2name3_HORDE = Inst82Quest2name3
Inst82Quest2name4_HORDE = Inst82Quest2name4



--------------- INST83 - Strand of the Ancients (SotA)  ---------------

Inst83Story = "Strand der Uralten ist ein Schlachtfeld auf einer Insel südlich der Drachenöde. Hier wurde ein uraltes Titanenrelikt gefunden. Sowohl die Horde als auch die Allianz ist hinter diesem Relikt her und kämpft somit um die Herrschaft über den Strand der Uralten. Wer die Kontrolle über den Strand der Uralten übernimmt, wird auch das Relikt aus den Titanenruinen erhalten und das als Waffe gegen seine Feinde verwenden"
Inst83Caption = "Strand der Uralten"
Inst83QAA = "1 Quest"
Inst83QAH = "1 Quest"

--Quest 1 Alliance
Inst83Quest1 = "1. Ruf zu den Waffen: Strand der Uralten (Tagesquest)"
Inst83Quest1_Aim = "Gewinnt eine Schlacht auf dem Strand der Uralten und meldet Euch anschließend bei einem Brigadegeneral der Allianz in einer der Hauptstädte, in Tausendwinter, Dalaran oder Shattrath."
Inst83Quest1_Location = "Brigadegeneral der Allianz:\n   Tausendwinter: Tausendwinters Festung - "..YELLOW.."50.0, 14.0"..WHITE.." (patroliert)\n   Shattrath: Unteres Viertel - "..YELLOW.."66.6, 34.6"..WHITE.."\n   Sturmwind: Burg Sturmwind - "..YELLOW.."83.8, 35.4"..WHITE.."\n   Eisenschmiede: Militär Viertel - "..YELLOW.."69.9, 89.6"..WHITE.."\n   Darnassus: Terrasse der Krieger - "..YELLOW.."57.6, 34.1"..WHITE.."\n   Exodar: Die Halle des Lichts - "..YELLOW.."24.6, 55.4"
Inst83Quest1_Note = "Diese Quest kann man nur einmal am Tag machen und nur wenn man Level 71 erreicht hat. Bei der Abgabe der Quest gibt es unterschiedliches Gold und Erfahrung basierend auf das jeweilige Level."
Inst83Quest1_Prequest = "Nein"
Inst83Quest1_Folgequest = "Nein"
-- No Rewards for this quest

--Quest 1 Horde
Inst83Quest1_HORDE = "1. Ruf zu den Waffen: Strand der Uralten (Tagesquest)"
Inst83Quest1_HORDE_Aim = "Gewinnt eine Schlacht auf dem Strand der Uralten und meldet Euch anschließend bei einem Kriegshetzer der Horde in einer der Hauptstädte, in Tausendwinter, Dalaran oder Shattrath."
Inst83Quest1_HORDE_Location = "Kriegshetzer der Horde:\n   Tausendwinter: Tausendwinters Festung - "..YELLOW.."50.0, 14.0"..WHITE.." (patroliert)\n   Dalaran: Sonnenhäschers Zuflucht - "..YELLOW.."58.0, 21.1"..WHITE.."\n   Shattrath: Unteres Viertel - "..YELLOW.."67.0, 56.7"..WHITE.."\n   Orgrimmar: Das Tal der Ehre - "..YELLOW.."79.8, 30.3"..WHITE.."\n   Donnerfels: Anhöhe der Jäger - "..YELLOW.."55.8, 76.6"..WHITE.."\n   Unterstadt: Das königliche Viertel - "..YELLOW.."60.7, 87.8"..WHITE.."\n   Silbermond: Platz der Weltenwanderer - "..YELLOW.."97.0, 38.3"
Inst83Quest1_HORDE_Note = "Diese Quest kann man nur einmal am Tag machen und nur wenn man Level 71 erreicht hat. Bei der Abgabe der Quest gibt es unterschiedliches Gold und Erfahrung basierend auf das jeweilige Level."
Inst83Quest1_HORDE_Folgequest = "Nein"
-- No Rewards for this quest



--------------- INST84 - Naxxramas (Naxx) ---------------

Inst84Caption = "Naxxramas"
Inst84QAA = "6 Quests"
Inst84QAH = "6 Quests"

--Quest 1 Alliance
Inst84Quest1 = "1. Schlüssel der fokussierenden Iris"
Inst84Quest1_Aim = "Liefert den Schlüssel zur fokussierenden Iris bei Alexstrasza der Lebensbinderin auf der höchsten Ebene des Wyrmruhtempels in der Drachenöde ab."
Inst84Quest1_Location = "Schlüssel der fokussierenden Iris (droppts von Sapphiron; "..YELLOW.."Frostwyrmhöhle [1]"..WHITE..")"
Inst84Quest1_Note = "Alexstrasza ist bei (Drachenöde - Wyrmruhtempel; "..YELLOW.."59.8, 54.6"..WHITE.."). Die Folge der Quest öffnet die Instant Der Nexus: Auge der Ewigkeit für den normalen 10 Mann Raid."
Inst84Quest1_Prequest = "Nein"
Inst84Quest1_Folgequest = "Entscheidung im Auge der Ewigkeit ("..YELLOW.."Auge der Ewigkeit"..WHITE..")"
--
Inst84Quest1name1 = "Schlüssel der fokussierenden Iris"

--Quest 2 Alliance
Inst84Quest2 = "2. Heroischer Schlüssel der fokussierenden Iris  (Heroisch)"
Inst84Quest2_Aim = "Liefert den heroischen Schlüssel zur fokussierenden Iris bei Alexstrasza der Lebensbinderin auf der höchsten Ebene des Wyrmruhtempels in der Drachenöde ab."
Inst84Quest2_Location = "Der heroische Schlüssel der fokussierenden Iris (droppt von Sapphiron; "..YELLOW.."Frostwyrmhöhle [1]"..WHITE..")"
Inst84Quest2_Note = "Alexstrasza ist bei (Drachenöde - Wyrmruhtempel; "..YELLOW.."59.8, 54.6"..WHITE.."). Die Folge der Quest öffnet die Instant Der Nexus: Auge der Ewigkeit für den Heroischen 25 Mann Raid."
Inst84Quest2_Prequest = "Nein"
Inst84Quest2_Folgequest = "Entscheidung im Auge der Ewigkeit ("..YELLOW.."Auge der Ewigkeit"..WHITE..")"
--
Inst84Quest2name1 = "Heroischer Schlüssel der fokussierenden Iris"

--Quest 3 Alliance
Inst84Quest3 = "3. Anub'Rekhan muss sterben! (Wöchentlich)"
Inst84Quest3_Aim = "Tötet Anub'Rekhan."
Inst84Quest3_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst84Quest3_Note = "Anub'Rekhan ist bei "..YELLOW.."Spinnenviertel [1]"..WHITE..".\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst84Quest3_Prequest = "Nein"
Inst84Quest3_Folgequest = "Nein"
--
Inst84Quest3name1 = "Emblem des Frosts"
Inst84Quest3name2 = "Emblem des Triumphs"

--Quest 4 Alliance
Inst84Quest4 = "4. Instrukteur Razuvious muss sterben! (Wöchentlich)"
Inst84Quest4_Aim = "Tötet Instrukteur Razuvious."
Inst84Quest4_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst84Quest4_Note = "Instrukteur Razuvious ist bei "..YELLOW.."Militärviertel [1]"..WHITE..".\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst84Quest4_Prequest = "Nein"
Inst84Quest4_Folgequest = "Nein"
--
Inst84Quest4name1 = "Emblem of Frost"
Inst84Quest4name2 = "Emblem of Triumph"

--Quest 5 Alliance
Inst84Quest5 = "5. Noth der Seuchenfürst muss sterben! (Wöchentlich)"
Inst84Quest5_Aim = "Tötet Noth der Seuchenfürst."
Inst84Quest5_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst84Quest5_Note = "Noth der Seuchenfürst ist bei "..YELLOW.."Seuchenviertel [1]"..WHITE..".\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst84Quest5_Prequest = "Nein"
Inst84Quest5_Folgequest = "Nein"
--
Inst84Quest5name1 = "Emblem des Frosts"
Inst84Quest5name2 = "Emblem des Triumphs"

--Quest 6 Alliance
Inst84Quest6 = "6. Flickwerk muss sterben! (Wöchentlich)"
Inst84Quest6_Aim = "Tötet Flickwerk."
Inst84Quest6_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst84Quest6_Note = "Flickwerk ist bei "..YELLOW.."Konstruktviertel [1]"..WHITE..".\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst84Quest6_Prequest = "Nein"
Inst84Quest6_Folgequest = "Nein"
--
Inst84Quest6name1 = "Emblem des Frosts"
Inst84Quest6name2 = "Emblem des Triumphs"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst84Quest1_HORDE = Inst84Quest1
Inst84Quest1_HORDE_Aim = Inst84Quest1_Aim
Inst84Quest1_HORDE_Location = Inst84Quest1_Location
Inst84Quest1_HORDE_Note = Inst84Quest1_Note
Inst84Quest1_HORDE_Prequest = Inst84Quest1_Prequest
Inst84Quest1_HORDE_Folgequest = Inst84Quest1_Folgequest
--
Inst84Quest1name1_HORDE = Inst84Quest1name1

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst84Quest2_HORDE = Inst84Quest2
Inst84Quest2_HORDE_Aim = Inst84Quest2_Aim
Inst84Quest2_HORDE_Location = Inst84Quest2_Location
Inst84Quest2_HORDE_Note = Inst84Quest2_Note
Inst84Quest2_HORDE_Prequest = Inst84Quest2_Prequest
Inst84Quest2_HORDE_Folgequest = Inst84Quest2_Folgequest
--
Inst84Quest2name1_HORDE = Inst84Quest2name1

--Quest 3 Horde (same as Quest 3 Alliance)
Inst84Quest3_HORDE = Inst84Quest3
Inst84Quest3_HORDE_Aim = Inst84Quest3_Aim
Inst84Quest3_HORDE_Location = Inst84Quest3_Location
Inst84Quest3_HORDE_Note = Inst84Quest3_Note
Inst84Quest3_HORDE_Prequest = Inst84Quest3_Prequest
Inst84Quest3_HORDE_Folgequest = Inst84Quest3_Folgequest
--
Inst84Quest3name1_HORDE = Inst84Quest3name1
Inst84Quest3name2_HORDE = Inst84Quest3name2

--Quest 4 Horde (same as Quest 4 Alliance)
Inst84Quest4_HORDE = Inst84Quest4
Inst84Quest4_HORDE_Aim = Inst84Quest4_Aim
Inst84Quest4_HORDE_Location = Inst84Quest4_Location
Inst84Quest4_HORDE_Note = Inst84Quest4_Note
Inst84Quest4_HORDE_Prequest = Inst84Quest4_Prequest
Inst84Quest4_HORDE_Folgequest = Inst84Quest4_Folgequest
--
Inst84Quest4name1_HORDE = Inst84Quest4name1
Inst84Quest4name2_HORDE = Inst84Quest4name2

--Quest 5 Horde (same as Quest 5 Alliance)
Inst84Quest5_HORDE = Inst84Quest5
Inst84Quest5_HORDE_Aim = Inst84Quest5_Aim
Inst84Quest5_HORDE_Location = Inst84Quest5_Location
Inst84Quest5_HORDE_Note = Inst84Quest5_Note
Inst84Quest5_HORDE_Prequest = Inst84Quest5_Prequest
Inst84Quest5_HORDE_Folgequest = Inst84Quest5_Folgequest
--
Inst84Quest5name1_HORDE = Inst84Quest5name1
Inst84Quest5name2_HORDE = Inst84Quest5name2

--Quest 6 Horde (same as Quest 6 Alliance)
Inst84Quest6_HORDE = Inst84Quest6
Inst84Quest6_HORDE_Aim = Inst84Quest6_Aim
Inst84Quest6_HORDE_Location = Inst84Quest6_Location
Inst84Quest6_HORDE_Note = Inst84Quest6_Note
Inst84Quest6_HORDE_Prequest = Inst84Quest6_Prequest
Inst84Quest6_HORDE_Folgequest = Inst84Quest6_Folgequest
--
Inst84Quest6name1_HORDE = Inst84Quest6name1
Inst84Quest6name2_HORDE = Inst84Quest6name2



--------------- INST85 - Vault of Archavon ---------------

Inst85Story = "Hoch über den gefrorenen Ebenen der großen Drachenöde und den unwirtlichen Weiten der boreanischen Tundra, liegt eine Region, die unter den Einheimischen Nordends als Tausendwinter bekannt ist. Gelegen auf einem hohen Plateau, blieb Tausendwinter lange Zeit unberührt. Eisige Winde umheulten ungehört die uralten Befestigungen der Titanen, die sich durch die Landschaft ziehen. Sein Reichtum an elementaren Ressourcen und seine strategisch bedeutsamen Befestigungsanlagen, machen Tausendwinter jedoch zum Hauptschauplatz eines heftigen Kampfes zwischen Horde und Allianz. Und dann gibt es da noch die aufkeimenden Gerüchte, unter der Festungsanlage läge uraltes Gewölbe der Titanen. Allein der Gedanke an die unermesslichen Schätze, die sich dort wohl befinden, versetzt in unsägliches Staunen."
Inst85Caption = "AK: Archavons Kammer"
Inst85QAA = "No Quests"
Inst85QAH = "No Quests"



--------------- INST86 - Ulduar ---------------

Inst86Story = "Jahrtausendelang lag Ulduar in von Sterblichen unberührtem Schlaf, fernab von ihren Sorgen, Nöten und Streitigkeiten. Nun jedoch ist der Komplex entdeckt worden und die Frage steht im Raum, welchem Zwecke er ursprünglich dienen sollte. Manche glauben, Ulduar sei eine Stadt, erbaut zum Ruhme ihrer Schöpfer, andere wiederum halten es für eine Schatzkammer, in der unzählige Schätze versteckt liegen, vielleicht sogar die Relikte der Titanen selbst. Sie haben sich geirrt. Hinter den Toren liegt keine Stadt, keine Schatzkammer und auch nicht die endgültige Antwort auf die Geheimnisse der Titanen. Alles, was diejenigen erwartet, die es wagen, einen Fuß nach Ulduar hineinzusetzen, ist ein Grauen, welches selbst die Titanen nicht zu vernichten wagten, etwas Böses, das sie lediglich... in Schach hielten. Unterhalb des uralten Ulduar wartet der Alte Gott des Todes, raunend… Passt auf, wo ihr hintretet, oder das Gefängnis wird zu Eurem Grab werden."
Inst86Caption = "Ulduar"
Inst86QAA = "20 Quests"
Inst86QAH = "20 Quests"

--Quest 1 Alliance
Inst86Quest1 = "1. Datenscheibe des Archivums"
Inst86Quest1_Aim = "Bringt die Datenscheibe des Archivums zur Archivumkonsole in Ulduar."
Inst86Quest1_Location = "Datenscheibe des Archivums (droppt von der Versammlung des Eisens; "..YELLOW.."Die Vorkammer [5]"..WHITE..")"
Inst86Quest1_Note = "Die Datenscheibe droppt nur wenn man die Versammlung des Eisens im harten Modus besiegt.  Nur einer aus dem Raid kann die Datenscheibe an sich nehmen.\n\nNach dem Tot der Versammlung des Eisens, öffnet sich eine Tür.  Gebe die Quest beim Archivumsystem im hinteren Bereich des Raum ab.  Ausgrabungsleiter Doren gibt Dir dann die Folgequest."
Inst86Quest1_Prequest = "Nein"
Inst86Quest1_Folgequest = "Das himmlische Planetarium"
-- No Rewards for this quest

--Quest 2 Alliance
Inst86Quest2 = "2. Das himmlische Planetarium"
Inst86Quest2_Aim = "Ausgrabungsleiter Doren im Archivum in Ulduar möchte, dass Ihr den Eingang zum Himmlischen Planetarium findet."
Inst86Quest2_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest2_Note = "Das himmlische Planetarium ist bei (Ulduar - Die Vorkammer; "..YELLOW.."[7]"..WHITE..").\n\nNach Beendigung dieser Quest gibt Dir Ausgrabungsleiter Doren die vier Siegel Questen."
Inst86Quest2_Prequest = "Datenscheibe des Archivums"
Inst86Quest2_Folgequest = "Die vier Siegel Questen"
-- No Rewards for this quest

--Quest 3 Alliance
Inst86Quest3 = "3. Hodirs Siegel"
Inst86Quest3_Aim = "Ausgrabungsleiter Doren im Archivum in Ulduar möchte, dass Ihr in den Besitz von Hodirs Siegel gelangt."
Inst86Quest3_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest3_Note = "Hodir ist bei "..YELLOW.."Die Behüter [9]"..WHITE..".  Hordir muss im harten Modus gelegt werden um das Siegel zu bekommen."
Inst86Quest3_Prequest = "Das himmlische Planetarium"
Inst86Quest3_Folgequest = "Nein"
-- No Rewards for this quest

--Quest 4 Alliance
Inst86Quest4 = "4. Thorims Siegel"
Inst86Quest4_Aim = "Ausgrabungsleiter Doren im Archivum in Ulduar möchte, dass Ihr in den Besitz von Hodirs Siegel gelangt."
Inst86Quest4_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest4_Note = "Thorim ist bei "..YELLOW.."Die Behüter [10]"..WHITE..".  Thorim muss im harten Modus gelegt werden um das Siegel zu bekommen."
Inst86Quest4_Prequest = "Das himmlische Planetarium"
Inst86Quest4_Folgequest = "Nein"
-- No Rewards for this quest

--Quest 5 Alliance
Inst86Quest5 = "5. Freyas Siegel"
Inst86Quest5_Aim = "Ausgrabungsleiterin Loren im Archivum in Ulduar möchte, dass Ihr in den Besitz von Freyas Siegel gelangt."
Inst86Quest5_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest5_Note = "Freya ist bei "..YELLOW.."Die Behüter [11]"..WHITE..".  Freya muss im harten Modus gelegt werden um das Siegel zu bekommen."
Inst86Quest5_Prequest = "Das himmlische Planetarium"
Inst86Quest5_Folgequest = "Nein"
-- No Rewards for this quest

--Quest 6 Alliance
Inst86Quest6 = "6. Mimirons Siegel"
Inst86Quest6_Aim = "Ausgrabungsleiterin Loren im Archivum in Ulduar möchte, dass Ihr in den Besitz von Mimirons Siegel gelangt."
Inst86Quest6_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest6_Note = "Mimiron ist bei "..YELLOW.."Der Funke der Imagination [12]"..WHITE..".  Mimiron muss im harten Modus gelegt werden um das Siegel zu bekommen."
Inst86Quest6_Prequest = "Das himmlische Planetarium"
Inst86Quest6_Folgequest = "Nein"
-- No Rewards for this quest

--Quest 7 Alliance
Inst86Quest7 = "7. Algalon"
Inst86Quest7_Aim = "Bringt die Siegel der Wächter zur Archivumkonsole in Ulduar."
Inst86Quest7_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest7_Note = "Nach Beendigung der vier Siegel Questen darfst du dann gegen Algalon der Beobachter im himmlischen Planetarium kämpfen."
Inst86Quest7_Prequest = "Die vier Siegel Questen"
Inst86Quest7_Folgequest = "Nein"
--
Inst86Quest7name1 = "Schlüssel des Himmlischen Planetariums"
Inst86Quest7name2 = "Sack mit Schätzen von Ulduar"

--Quest 8 Alliance
Inst86Quest8 = "8. Ende gut, alles gut"
Inst86Quest8_Aim = "Überbringt Rhonin in Dalaran den Antwortcode Alpha."
Inst86Quest8_Location = "Antwortcode Alpha (droppt von Algalon der Beobachter; "..YELLOW.."Die Vorkammer [7]"..WHITE..")"
Inst86Quest8_Note = "Nur einer aus dem Raid kann den Antwortcode nehmen. Rhonin ist in Dalaran - Die violette Zitadelle; "..YELLOW.."30.5, 48.4"..WHITE.."."
Inst86Quest8_Prequest = "Nein"
Inst86Quest8_Folgequest = "Nein"
--
Inst86Quest8name1 = "Tuch des Himmelsherolds"
Inst86Quest8name2 = "Sonnenglimmertuch"
Inst86Quest8name3 = "Branns Siegelring"
Inst86Quest8name4 = "Sternenlichtsiegel"

--Quest 9 Alliance
Inst86Quest9 = "9. Heroisch: Datenscheibe des Archivums"
Inst86Quest9_Aim = "Bringt die Datenscheibe des Archivums zur Archivumkonsole in Ulduar."
Inst86Quest9_Location = "Datenscheibe des Archivums (droppt von der Versammlung des Eisens; "..YELLOW.."Die Vorkammer [5]"..WHITE..")"
Inst86Quest9_Note = "Die Datenscheibe droppt nur wenn man die Versammlung des Eisens im harten Modus besiegt.  Nur einer aus dem Raid kann die Datenscheibe an sich nehmen.\n\nNach dem Tot der Versammlung des Eisens, öffnet sich eine Tür.  Gebe die Quest beim Archivumsystem im hinteren Bereich des Raum ab.  Ausgrabungsleiter Doren gibt Dir dann die Folgequest."
Inst86Quest9_Prequest = "Nein"
Inst86Quest9_Folgequest = "Das himmlische Planetarium"
-- No Rewards for this quest

--Quest 10 Alliance
Inst86Quest10 = "10. Heroisch: Das himmlische Planetarium"
Inst86Quest10_Aim = "Ausgrabungsleiter Doren im Archivum in Ulduar möchte, dass Ihr den Eingang zum Himmlischen Planetarium findet."
Inst86Quest10_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest10_Note = "Das himmlische Planetarium ist bei (Ulduar - Die Vorkammer; "..YELLOW.."[7]"..WHITE..").\n\nNach Beendigung dieser Quest gibt Dir Ausgrabungsleiter Doren die vier Siegel Questen."
Inst86Quest10_Prequest = "Datenscheibe des Archivums"
Inst86Quest10_Folgequest = "Die vier Siegel Questen"
-- No Rewards for this quest

--Quest 11 Alliance
Inst86Quest11 = "11. Heroisch: Hodirs Siegel"
Inst86Quest11_Aim = "Ausgrabungsleiter Doren im Archivum in Ulduar möchte, dass Ihr in den Besitz von Hodirs Siegel gelangt."
Inst86Quest11_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest11_Note = "Hodir ist bei "..YELLOW.."Die Behüter [9]"..WHITE..".  Hordir muss im harten Modus gelegt werden um das Siegel zu bekommen."
Inst86Quest11_Prequest = "Das himmlische Planetarium"
Inst86Quest11_Folgequest = "Nein"
-- No Rewards for this quest

--Quest 12 Alliance
Inst86Quest12 = "12. Heroisch: Thorims Siegel"
Inst86Quest12_Aim = "Ausgrabungsleiter Doren im Archivum in Ulduar möchte, dass Ihr in den Besitz von Hodirs Siegel gelangt."
Inst86Quest12_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest12_Note = "Thorim ist bei "..YELLOW.."Die Behüter [10]"..WHITE..".  Thorim muss im harten Modus gelegt werden um das Siegel zu bekommen."
Inst86Quest12_Prequest = "Das himmlische Planetarium"
Inst86Quest12_Folgequest = "Nein"
-- No Rewards for this quest

--Quest 13 Alliance
Inst86Quest13 = "13. Heroisch: Freyas Siegel"
Inst86Quest13_Aim = "Ausgrabungsleiterin Loren im Archivum in Ulduar möchte, dass Ihr in den Besitz von Freyas Siegel gelangt."
Inst86Quest13_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest13_Note = "Freya ist bei "..YELLOW.."Die Behüter [11]"..WHITE..".  Freya muss im harten Modus gelegt werden um das Siegel zu bekommen."
Inst86Quest13_Prequest = "Das himmlische Planetarium"
Inst86Quest13_Folgequest = "Nein"
-- No Rewards for this quest

--Quest 14 Alliance
Inst86Quest14 = "14. Heroisch: Mimirons Siegel"
Inst86Quest14_Aim = "Ausgrabungsleiterin Loren im Archivum in Ulduar möchte, dass Ihr in den Besitz von Mimirons Siegel gelangt."
Inst86Quest14_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest14_Note = "Mimiron ist bei "..YELLOW.."Der Funke der Imagination [12]"..WHITE..".  Mimiron muss im harten Modus gelegt werden um das Siegel zu bekommen."
Inst86Quest14_Prequest = "Das himmlische Planetarium"
Inst86Quest14_Folgequest = "Nein"
-- No Rewards for this quest

--Quest 15 Alliance
Inst86Quest15 = "15. Heroisch: Algalon"
Inst86Quest15_Aim = "Bringt die Siegel der Wächter zur Archivumkonsole in Ulduar."
Inst86Quest15_Location = "Ausgrabungsleiter Doren (Ulduar - Die Vorkammer; "..YELLOW.."Südlich von [5]"..WHITE..")"
Inst86Quest15_Note = "Nach Beendigung der vier Siegel Questen darfst du dann gegen Algalon der Beobachter im himmlischen Planetarium kämpfen."
Inst86Quest15_Prequest = "Die vier Siegel Questen"
Inst86Quest15_Folgequest = "Nein"
--
Inst86Quest15name1 = "Heroischer Schlüssel des Himmlischen Planetariums"
Inst86Quest15name2 = "Großer Sack mit Schätzen von Ulduar"

--Quest 16 Alliance
Inst86Quest16 = "16. Heroisch: Ende gut, alles gut"
Inst86Quest16_Aim = "Überbringt Rhonin in Dalaran den Antwortcode Alpha."
Inst86Quest16_Location = "Antwortcode Alpha (droppt von Algalon der Beobachter; "..YELLOW.."Die Vorkammer [7]"..WHITE..")"
Inst86Quest16_Note = "Nur einer aus dem Raid kann den Antwortcode nehmen. Rhonin ist in Dalaran - Die violette Zitadelle; "..YELLOW.."30.5, 48.4"..WHITE.."."
Inst86Quest16_Prequest = "Nein"
Inst86Quest16_Folgequest = "Nein"
--
Inst86Quest16name1 = "Tuch des Himmelsgeborenen"
Inst86Quest16name2 = "Sonnenglimmerumhang"
Inst86Quest16name3 = "Branns Siegelring"
Inst86Quest16name4 = "Sternenlichtkreis"

--Quest 17 Alliance
Inst86Quest17 = "17. Der Flammenleviathan muss sterben! (Wöchentlich)"
Inst86Quest17_Aim = "Tötet Flammenleviathan."
Inst86Quest17_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst86Quest17_Note = "Flammenleviathan ist bei "..YELLOW.."Die Belagerung [1]"..WHITE..".\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst86Quest17_Prequest = "Nein"
Inst86Quest17_Folgequest = "Nein"
--
Inst86Quest17name1 = "Emblem des Frosts"
Inst86Quest17name2 = "Emblem des Triumphs"

--Quest 18 Alliance
Inst86Quest18 = "18. Ignis, Meister des Eisenwerks, muss sterben! (Wöchentlich)"
Inst86Quest18_Aim = "Tötet Ignis der Meister des Eisenwerks."
Inst86Quest18_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst86Quest18_Note = "Ignis der Meister des Eisenwerks is at "..YELLOW.."Die Belagerung [3]"..WHITE..".\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst86Quest18_Prequest = "Nein"
Inst86Quest18_Folgequest = "Nein"
--
Inst86Quest18name1 = "Emblem des Frosts"
Inst86Quest18name2 = "Emblem des Triumphs"

--Quest 19 Alliance
Inst86Quest19 = "19. Klingenschuppe muss sterben! (Wöchentlich)"
Inst86Quest19_Aim = "Tötet Klingenschuppe."
Inst86Quest19_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst86Quest19_Note = "Klingenschuppe ist bei "..YELLOW.."Die Belagerung [2]"..WHITE..".\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst86Quest19_Prequest = "Nein"
Inst86Quest19_Folgequest = "Nein"
--
Inst86Quest19name1 = "Emblem des Frosts"
Inst86Quest19name2 = "Emblem des Triumphs"

--Quest 20 Alliance
Inst86Quest20 = "20. XT-002 Dekonstruktor muss sterben! (Wöchentlich)"
Inst86Quest20_Aim = "Tötet XT-002 Dekonstruktor."
Inst86Quest20_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst86Quest20_Note = "XT-002 Dekonstruktor ist bei "..YELLOW.."Die Belagerung [4]"..WHITE..".\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst86Quest20_Prequest = "Nein"
Inst86Quest20_Folgequest = "Nein"
--
Inst86Quest20name1 = "Emblem des Frosts"
Inst86Quest20name2 = "Emblem des Triumphs" 


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst86Quest1_HORDE = Inst86Quest1
Inst86Quest1_HORDE_Aim = Inst86Quest1_Aim
Inst86Quest1_HORDE_Location = Inst86Quest1_Location
Inst86Quest1_HORDE_Note = Inst86Quest1_Note
Inst86Quest1_HORDE_Prequest = Inst86Quest1_Prequest
Inst86Quest1_HORDE_Folgequest = Inst86Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst86Quest2_HORDE = Inst86Quest2
Inst86Quest2_HORDE_Aim = Inst86Quest2_Aim
Inst86Quest2_HORDE_Location = Inst86Quest2_Location
Inst86Quest2_HORDE_Note = Inst86Quest2_Note
Inst86Quest2_HORDE_Prequest = Inst86Quest2_Prequest
Inst86Quest2_HORDE_Folgequest = Inst86Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst86Quest3_HORDE = Inst86Quest3
Inst86Quest3_HORDE_Aim = Inst86Quest3_Aim
Inst86Quest3_HORDE_Location = Inst86Quest3_Location
Inst86Quest3_HORDE_Note = Inst86Quest3_Note
Inst86Quest3_HORDE_Prequest = Inst86Quest3_Prequest
Inst86Quest3_HORDE_Folgequest = Inst86Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst86Quest4_HORDE = Inst86Quest4
Inst86Quest4_HORDE_Aim = Inst86Quest4_Aim
Inst86Quest4_HORDE_Location = Inst86Quest4_Location
Inst86Quest4_HORDE_Note = Inst86Quest4_Note
Inst86Quest4_HORDE_Prequest = Inst86Quest4_Prequest
Inst86Quest4_HORDE_Folgequest = Inst86Quest4_Folgequest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst86Quest5_HORDE = Inst86Quest5
Inst86Quest5_HORDE_Aim = Inst86Quest5_Aim
Inst86Quest5_HORDE_Location = Inst86Quest5_Location
Inst86Quest5_HORDE_Note = Inst86Quest5_Note
Inst86Quest5_HORDE_Prequest = Inst86Quest5_Prequest
Inst86Quest5_HORDE_Folgequest = Inst86Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst86Quest6_HORDE = Inst86Quest6
Inst86Quest6_HORDE_Aim = Inst86Quest6_Aim
Inst86Quest6_HORDE_Location = Inst86Quest6_Location
Inst86Quest6_HORDE_Note = Inst86Quest6_Note
Inst86Quest6_HORDE_Prequest = Inst86Quest6_Prequest
Inst86Quest6_HORDE_Folgequest = Inst86Quest6_Folgequest
-- No Rewards for this quest

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst86Quest7_HORDE = Inst86Quest7
Inst86Quest7_HORDE_Aim = Inst86Quest7_Aim
Inst86Quest7_HORDE_Location = Inst86Quest7_Location
Inst86Quest7_HORDE_Note = Inst86Quest7_Note
Inst86Quest7_HORDE_Prequest = Inst86Quest7_Prequest
Inst86Quest7_HORDE_Folgequest = Inst86Quest7_Folgequest
--
Inst86Quest7name1_HORDE = Inst86Quest7name1
Inst86Quest7name2_HORDE = Inst86Quest7name2

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst86Quest8_HORDE = Inst86Quest8
Inst86Quest8_HORDE_Aim = Inst86Quest8_Aim
Inst86Quest8_HORDE_Location = Inst86Quest8_Location
Inst86Quest8_HORDE_Note = Inst86Quest8_Note
Inst86Quest8_HORDE_Prequest = Inst86Quest8_Prequest
Inst86Quest8_HORDE_Folgequest = Inst86Quest8_Folgequest
--
Inst86Quest8name1_HORDE = Inst86Quest8name1
Inst86Quest8name2_HORDE = Inst86Quest8name2
Inst86Quest8name3_HORDE = Inst86Quest8name3
Inst86Quest8name4_HORDE = Inst86Quest8name4

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst86Quest9_HORDE = Inst86Quest9
Inst86Quest9_HORDE_Aim = Inst86Quest9_Aim
Inst86Quest9_HORDE_Location = Inst86Quest9_Location
Inst86Quest9_HORDE_Note = Inst86Quest9_Note
Inst86Quest9_HORDE_Prequest = Inst86Quest9_Prequest
Inst86Quest9_HORDE_Folgequest = Inst86Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst86Quest10_HORDE = Inst86Quest10
Inst86Quest10_HORDE_Aim = Inst86Quest10_Aim
Inst86Quest10_HORDE_Location = Inst86Quest10_Location
Inst86Quest10_HORDE_Note = Inst86Quest10_Note
Inst86Quest10_HORDE_Prequest = Inst86Quest10_Prequest
Inst86Quest10_HORDE_Folgequest = Inst86Quest10_Folgequest
-- No Rewards for this quest

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst86Quest11_HORDE = Inst86Quest11
Inst86Quest11_HORDE_Aim = Inst86Quest11_Aim
Inst86Quest11_HORDE_Location = Inst86Quest11_Location
Inst86Quest11_HORDE_Note = Inst86Quest11_Note
Inst86Quest11_HORDE_Prequest = Inst86Quest11_Prequest
Inst86Quest11_HORDE_Folgequest = Inst86Quest11_Folgequest
-- No Rewards for this quest

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst86Quest12_HORDE = Inst86Quest12
Inst86Quest12_HORDE_Aim = Inst86Quest12_Aim
Inst86Quest12_HORDE_Location = Inst86Quest12_Location
Inst86Quest12_HORDE_Note = Inst86Quest12_Note
Inst86Quest12_HORDE_Prequest = Inst86Quest12_Prequest
Inst86Quest12_HORDE_Folgequest = Inst86Quest12_Folgequest
-- No Rewards for this quest

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst86Quest13_HORDE = Inst86Quest13
Inst86Quest13_HORDE_Aim = Inst86Quest13_Aim
Inst86Quest13_HORDE_Location = Inst86Quest13_Location
Inst86Quest13_HORDE_Note = Inst86Quest13_Note
Inst86Quest13_HORDE_Prequest = Inst86Quest13_Prequest
Inst86Quest13_HORDE_Folgequest = Inst86Quest13_Folgequest
-- No Rewards for this quest

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst86Quest14_HORDE = Inst86Quest14
Inst86Quest14_HORDE_Aim = Inst86Quest14_Aim
Inst86Quest14_HORDE_Location = Inst86Quest14_Location
Inst86Quest14_HORDE_Note = Inst86Quest14_Note
Inst86Quest14_HORDE_Prequest = Inst86Quest14_Prequest
Inst86Quest14_HORDE_Folgequest = Inst86Quest14_Folgequest
-- No Rewards for this quest

--Quest 15 Horde  (same as Quest 15 Alliance)
Inst86Quest15_HORDE = Inst86Quest15
Inst86Quest15_HORDE_Aim = Inst86Quest15_Aim
Inst86Quest15_HORDE_Location = Inst86Quest15_Location
Inst86Quest15_HORDE_Note = Inst86Quest15_Note
Inst86Quest15_HORDE_Prequest = Inst86Quest15_Prequest
Inst86Quest15_HORDE_Folgequest = Inst86Quest15_Folgequest
--
Inst86Quest15name1_HORDE = Inst86Quest15name1
Inst86Quest15name2_HORDE = Inst86Quest15name2

--Quest 16 Horde  (same as Quest 16 Alliance)
Inst86Quest16_HORDE = Inst86Quest16
Inst86Quest16_HORDE_Aim = Inst86Quest16_Aim
Inst86Quest16_HORDE_Location = Inst86Quest16_Location
Inst86Quest16_HORDE_Note = Inst86Quest16_Note
Inst86Quest16_HORDE_Prequest = Inst86Quest16_Prequest
Inst86Quest16_HORDE_Folgequest = Inst86Quest16_Folgequest
--
Inst86Quest16name1_HORDE = Inst86Quest16name1
Inst86Quest16name2_HORDE = Inst86Quest16name2
Inst86Quest16name3_HORDE = Inst86Quest16name3
Inst86Quest16name4_HORDE = Inst86Quest16name4

--Quest 17 Horde (same as Quest 17 Alliance)
Inst86Quest17_HORDE = Inst86Quest17
Inst86Quest17_HORDE_Aim = Inst86Quest17_Aim
Inst86Quest17_HORDE_Location = Inst86Quest17_Location
Inst86Quest17_HORDE_Note = Inst86Quest17_Note
Inst86Quest17_HORDE_Prequest = Inst86Quest17_Prequest
Inst86Quest17_HORDE_Folgequest = Inst86Quest17_Folgequest
--
Inst86Quest17name1_HORDE = Inst86Quest17name1
Inst86Quest17name2_HORDE = Inst86Quest17name2

--Quest 18 Horde (same as Quest 18 Alliance)
Inst86Quest18_HORDE = Inst86Quest18
Inst86Quest18_HORDE_Aim = Inst86Quest18_Aim
Inst86Quest18_HORDE_Location = Inst86Quest18_Location
Inst86Quest18_HORDE_Note = Inst86Quest18_Note
Inst86Quest18_HORDE_Prequest = Inst86Quest18_Prequest
Inst86Quest18_HORDE_Folgequest = Inst86Quest18_Folgequest
--
Inst86Quest18name1_HORDE = Inst86Quest18name1
Inst86Quest18name2_HORDE = Inst86Quest18name2

--Quest 19 Horde (same as Quest 19 Alliance)
Inst86Quest19_HORDE = Inst86Quest19
Inst86Quest19_HORDE_Aim = Inst86Quest19_Aim
Inst86Quest19_HORDE_Location = Inst86Quest19_Location
Inst86Quest19_HORDE_Note = Inst86Quest19_Note
Inst86Quest19_HORDE_Prequest = Inst86Quest19_Prequest
Inst86Quest19_HORDE_Folgequest = Inst86Quest19_Folgequest
--
Inst86Quest19name1_HORDE = Inst86Quest19name1
Inst86Quest19name2_HORDE = Inst86Quest19name2

--Quest 20 Horde (same as Quest 20 Alliance)
Inst86Quest20_HORDE = Inst86Quest20
Inst86Quest20_HORDE_Aim = Inst86Quest20_Aim
Inst86Quest20_HORDE_Location = Inst86Quest20_Location
Inst86Quest20_HORDE_Note = Inst86Quest20_Note
Inst86Quest20_HORDE_Prequest = Inst86Quest20_Prequest
Inst86Quest20_HORDE_Folgequest = Inst86Quest20_Folgequest
--
Inst86Quest20name1_HORDE = Inst86Quest20name1
Inst86Quest20name2_HORDE = Inst86Quest20name2



--------------- INST87 - Trial of the Champion ---------------

Inst87Story = "Die Zeit naht, der Geißel den Stoß ins Herz zu versetzen. Wolken bedecken den Himmel über Azeroth und unter den von Krieg gezeichneten Bannern versammeln sich die Helden als Vorbereitung für den kommenden Sturm. Doch auf Regen folgt Sonnenschein so sagt man, und es ist diese Hoffnung, welche die Männer und Frauen des Argentumkreuzzugs antreibt: die Hoffnung, dass das Licht sie in diesen schwierigen Zeiten finden wird; die Hoffnung, dass Gut über Böse triumphieren wird; die Hoffnung, dass ein vom Lichte gesegneter Held kommen wird und der dunklen Herrschaft des Lichkönigs ein Ende setzt.\n\nAlso hat der Argentumkreuzzug den Ruf ausgesandt - den Ruf zu den Waffen an alle Helden weit und breit, auf dass sie an der Schwelle zum Reich des Lichkönigs zusammenkommen und ihre Macht auf einem Turnier unter Beweis stellen, wie es noch nie zuvor in Azeroth gesehen wurde. Natürlich braucht ein Turnier wie dieses eine dazu passende Bühne. Einen Ort, an dem potentielle Kandidaten bis zur Grenze ihrer Kräfte auf die Probe gestellt werden. Ein Ort, an dem Helden ... Champions werden. Ein Ort, den man das Kolosseum der Kreuzfahrer nennt." 
Inst87Caption = "PdC: Prüfung der Champions" 
Inst87QAA = "No Quest" 
Inst87QAH = "No Quest"  



--------------- INST88 - Trial of the Crusader ---------------  

Inst88Story = "Die Zeit naht, der Geißel den Stoß ins Herz zu versetzen. Wolken bedecken den Himmel über Azeroth und unter den von Krieg gezeichneten Bannern versammeln sich die Helden als Vorbereitung für den kommenden Sturm. Doch auf Regen folgt Sonnenschein so sagt man, und es ist diese Hoffnung, welche die Männer und Frauen des Argentumkreuzzugs antreibt: die Hoffnung, dass das Licht sie in diesen schwierigen Zeiten finden wird; die Hoffnung, dass Gut über Böse triumphieren wird; die Hoffnung, dass ein vom Lichte gesegneter Held kommen wird und der dunklen Herrschaft des Lichkönigs ein Ende setzt.\n\nAlso hat der Argentumkreuzzug den Ruf ausgesandt - den Ruf zu den Waffen an alle Helden weit und breit, auf dass sie an der Schwelle zum Reich des Lichkönigs zusammenkommen und ihre Macht auf einem Turnier unter Beweis stellen, wie es noch nie zuvor in Azeroth gesehen wurde. Natürlich braucht ein Turnier wie dieses eine dazu passende Bühne. Einen Ort, an dem potentielle Kandidaten bis zur Grenze ihrer Kräfte auf die Probe gestellt werden. Ein Ort, an dem Helden ... Champions werden. Ein Ort, den man das Kolosseum der Kreuzfahrer nennt." 
Inst88Caption = "PdK: Prüfung des Kreuzfahrers" 
Inst88QAA = "1 Quest" 
Inst88QAH = "1 Quest" 

--Quest 1 Alliance
Inst88Quest1 = "1. Lord Jaraxxus muss sterben! (Wöchentlich)"
Inst88Quest1_Aim = "Tötet Lord Jaraxxus."
Inst88Quest1_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst88Quest1_Note = "Lord Jaraxxus ist der zweite Boss.\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst88Quest1_Prequest = "Nein"
Inst88Quest1_Folgequest = "Nein"
--
Inst88Quest1name1 = "Emblem des Frosts"
Inst88Quest1name2 = "Emblem des Triumphs"


--Quest 1 Horde (same as Quest 1 Alliance)
Inst88Quest1_HORDE = Inst88Quest1
Inst88Quest1_HORDE_Aim = Inst88Quest1_Aim
Inst88Quest1_HORDE_Location = Inst88Quest1_Location
Inst88Quest1_HORDE_Note = Inst88Quest1_Note
Inst88Quest1_HORDE_Prequest = Inst88Quest1_Prequest
Inst88Quest1_HORDE_Folgequest = Inst88Quest1_Folgequest
--
Inst88Quest1name1_HORDE = Inst88Quest1name1
Inst88Quest1name2_HORDE = Inst88Quest1name2 



--------------- INST89 - Isle of Conquest (IoC)  ---------------

Inst89Story = "Eine Insel irgendwo vor den Stränden von Nordend. Ein Fels, kaum eines zweiten Blickes würdig. Aber so unscheinbar sie auch aussehen mag, sie ist kein gewöhnlicher Ort. Es donnert, wenn die Wellen unnachgiebig gegen die schroffen Klippen schlagen. Kampfeslärm erfüllt die Luft, wo Schwerter aufeinandertreffen, hier in den blutbefleckten Landstrichen der Insel am Ende vom Nirgendwo.\n\nWillkommen auf der Insel der Eroberung."
Inst89Caption = "Insel der Eroberung"
Inst89QAA = "1 Quest"
Inst89QAH = "1 Quest"

--Quest 1 Alliance
Inst89Quest1 = "1. Zu den Waffen: Insel der Eroberung (Tagesquest)" 
Inst89Quest1_Aim = "Erringt den Sieg bei einer Partie auf dem Schlachtfeld Insel der Eroberung und kehrt zu einem Brigadegeneral der Allianz in irgendeiner Hauptstadt, Dalaran oder Shattrath zurück." 
Inst89Quest1_Location = "Brigadegeneral der Allianz:\n   Tausendwintersee: Tausendwinters Festung - "..YELLOW.."50.0, 14.0"..WHITE.." (patroliert)\n   Dalaran: Die Silberne Enklave - "..YELLOW.."30.0, 76.1"..WHITE.."\n   Shattrath: Unteres Viertel - "..YELLOW.."66.6, 34.6"..WHITE.."\n   Sturmwind: Burg Sturmwind - "..YELLOW.."83.8, 35.4"..WHITE.."\n   Eisenschmiede: Militär Viertel - "..YELLOW.."69.9, 89.6"..WHITE.."\n   Darnassus: Terrasse der Krieger - "..YELLOW.."57.6, 34.1"..WHITE.."\n   Exodar: Die Halle des Lichts - "..YELLOW.."24.6, 55.4" 
Inst89Quest1_Note = "Diese Quest kann man nur einmal am Tag machen wenn sie verfügbar ist. Bei der Abgabe der Quest gibt es unterschiedliches Gold und Erfahrung basierend auf das jeweilige Level." 
Inst89Quest1_Prequest = "Nein" 
Inst89Quest1_Folgequest = "Nein" 
-- No Rewards for this quest   

--Quest 1 Horde Inst89Quest1_HORDE = "1. Zu den Waffen: Insel der Eroberung (Tagesquest)" 
Inst89Quest1_HORDE_Aim = "Erringt den Sieg bei einer Partie auf dem Schlachtfeld Insel der Eroberung und kehrt zu einem Kriegshetzer der Horde in irgendeiner Hauptstadt, Dalaran oder Shattrath zurück."
Inst89Quest1_HORDE_Location = "Kriegshetzer der Horde:\n   Tausendwintersee: Tausendwinters Festung - "..YELLOW.."50.0, 14.0"..WHITE.." (patroliert)\n   Dalaran: Sonnenhäschers Zuflucht - "..YELLOW.."58.0, 21.1"..WHITE.."\n   Shattrath: Unteres Viertel - "..YELLOW.."67.0, 56.7"..WHITE.."\n   Orgrimmar: Das Tal der Ehre - "..YELLOW.."79.8, 30.3"..WHITE.."\n   Donnerfels: Anhöhe der Jäger - "..YELLOW.."55.8, 76.6"..WHITE.."\n   Unterstadt: Das königliche Viertel - "..YELLOW.."60.7, 87.8"..WHITE.."\n   Silbermond: Platz der Weltenwanderer - "..YELLOW.."97.0, 38.3" 
Inst89Quest1_HORDE_Note = "Diese Quest kann man nur einmal am Tag machen wenn sie verfügbar ist. Bei der Abgabe der Quest gibt es unterschiedliches Gold und Erfahrung basierend auf das jeweilige Level." 
Inst89Quest1_HORDE_Prequest = "Nein" 
Inst89Quest1_HORDE_Folgequest = "Nein" 
-- No Rewards for this quest 



--------------- INST90 - Forge of Souls (FoS) ---------------

Inst90Story = "Im ersten Flügel dieses weitläufigen Dungeons, der Seelenschmiede, werden die Spieler schnell einem Test auf Herz und Nieren unterzogen: Die Herausforderung besteht darin, sich durch die Hochburg der Geißel in Richtung der tiefer gelegenen, tückischeren Bereiche zu schlagen. Dabei befehligt auf Seiten der Allianz Jaina die Streitkräfte, während Sylvanas den Truppen der Horde vorsteht. Das Ziel ist es, die verdorbenen, als Seelenschänder bekannten Maschinen zu zerstören, die in diesem Teil der Zitadelle zu finden sind. Erst dann können die Spieler vorrücken – allerdings natürlich nur, wenn es den Streitmächten der Horde und der Allianz gelingt, die Gegner zu überwinden, die sich ihnen in den Weg stellen."
Inst90Caption = "FoS:Die Seelenschmiede"
Inst90QAA = "2 Quests"
Inst90QAH = "2 Quests"

--Quest 1 Alliance
Inst90Quest1 = "1. In der eisigen Zitadelle"
Inst90Quest1_Aim = "Betretet die Seelenschmiede von der Seite der Eiskronenzitadelle und findet Lady Jaina Prachtmeer."
Inst90Quest1_Location = "Lehrling Nelphi (Dalaran Stadt - Wandert vor der südlichen Bank)"
Inst90Quest1_Note = "Lady Jaina Prachtmeer ist innerhalb der Instanz."
Inst90Quest1_Prequest = "Nein"
Inst90Quest1_Folgequest = "Echos gequälter Seelen"
-- No Rewards for this quest

--Quest 2 Alliance
Inst90Quest2 = "2. Echos gequälter Seelen"
Inst90Quest2_Aim = "Tötet Bronjahm und den Verschlinger der Seelen, um den Zugang zur Grube von Saron zu sichern."
Inst90Quest2_Location = "Lady Jaina Prachtmeer (Die Seelenschmiede; "..YELLOW.."Eingang"..WHITE..")"
Inst90Quest2_Note = "Schließe die Quest erfolgreich ab um in die Grube von Saron zu gelangen."
Inst90Quest2_Prequest = "In der eisigen Zitadelle"
Inst90Quest2_Folgequest = "Die Grube von Saron"
--
Inst90Quest2name1 = "Emblem des Frosts"

--Quest 3 Alliance
Inst90Quest3 = "3. Die Klinge tempern"
Inst90Quest3_Aim = "Tempert das neugeschmiedete Quel'Delar im Schmelztiegel der Seelen."
Inst90Quest3_Location = "Caladis Prunkspeer (Eiskrone - Quel'Delars Ruh; "..YELLOW.."74.2, 31.3"..WHITE..")"
Inst90Quest3_Note = "Der Schmelztiegel der Seelen  ist bei "..YELLOW.."[3]"..WHITE..", am Ende der Instanz."
Inst90Quest3_Prequest = "Das Schwert neu schmieden ("..YELLOW.."Grube von Saron"..WHITE..")"
Inst90Quest3_Folgequest = "Die Hallen der Reflexion ("..YELLOW.."Hallen der Reflexion"..WHITE..")"
-- No Rewards for this quest


--Quest 1 Horde
Inst90Quest1_HORDE = "1. In der eisigen Zitadelle"
Inst90Quest1_HORDE_Aim = "Betretet die Seelenschmiede von der Seite der Eiskronenzitadelle und findet Fürstin Sylvanas Windläufer."
Inst90Quest1_HORDE_Location = "Dunkelläuferin Vorel (Dalaran Stadt - Wandert vor der nördlichen Bank)"
Inst90Quest1_HORDE_Note = "Lady Sylvanas Windläufer ist innerhalb der Instanz."
Inst90Quest1_HORDE_Prequest = "Nein"
Inst90Quest1_HORDE_Folgequest = "Echos gequälter Seelen"
-- No Rewards for this quest

--Quest 2 Horde
Inst90Quest2_HORDE = "2. Echos gequälter Seelen"
Inst90Quest2_HORDE_Aim = "Tötet Bronjahm und den Verschlinger der Seelen, um den Zugang zur Grube von Saron zu sichern."
Inst90Quest2_HORDE_Location = "Lady Sylvanas Windläufer (Die Seelenschmiede; "..YELLOW.."Eingang"..WHITE..")"
Inst90Quest2_HORDE_Note = "Schließe die Quest erfolgreich ab um in die Grube von Saron zu gelangen."
Inst90Quest2_HORDE_Prequest = "In der eisigen Zitadelle"
Inst90Quest2_HORDE_Folgequest = "Die Grube von Saron"
--
Inst90Quest2name1_HORDE = "Emblem des Frosts" 

--Quest 3 Horde
Inst90Quest3_HORDE = "3. Die Klinge tempern"
Inst90Quest3_HORDE_Aim = "Tempert das neugeschmiedete Quel'Delar im Schmelztiegel der Seelen."
Inst90Quest3_HORDE_Location = "Myralion Sonnenfeuer (Eiskrone - Quel'Delars Ruh; "..YELLOW.."74.5, 31.1"..WHITE..")"
Inst90Quest3_HORDE_Note = "Der Schmelztiegel der Seelen  ist bei "..YELLOW.."[3]"..WHITE..", am Ende der Instanz."
Inst90Quest3_HORDE_Prequest = "Das Schwert neu schmieden ("..YELLOW.."Grube von Saron"..WHITE..")"
Inst90Quest3_HORDE_Folgequest = "Die Hallen der Reflexion ("..YELLOW.."Hallen der Reflexion"..WHITE..")"
-- No Rewards for this quest



--------------- INST91 - Pit of Saron (PoS) ---------------

Inst91Story = "Die Grube von Saron, nur von denjenigen betretbar, die den unheiligen Vorgängen in der Schmiede der Seelen ein Ende bereitet haben, lässt die Streitkräfte der Horde und der Allianz tiefer in das Reich des Lichkönigs vordringen. Spieler, die sich hier hineinwagen, sehen sich augenblicklich mit dem Herrn dieses Ortes konfrontiert, dem Geißelfürsten Tyrannus. Ihn zu besiegen wird allerdings nicht ganz so einfach werden, wie es zunächst den Anschein hat. Bevor sie sich Tyrannus zuwenden können, müssen die Abenteurer auf Geheiß ihrer Anführer zunächst versklavte Verbündete befreien, die von der Geißel gefangen genommen wurden. Bis das gelungen ist, wird Tyrannus es seinen Günstlingen, den Arbeitern in den Minen der Zitadelle, überlassen, sich um die Eindringlinge zu kümmern. Möglicherweise lassen sich aus den Herausforderungen hier bereits Hinweise herleiten darüber, wo die privaten Gemächer des Lichkönigs jenseits des Frostthrons zu finden sind – tief innerhalb der Hallen der Reflexion."
Inst91Caption = "PoS:Grube von Saron"
Inst91QAA = "3 Quests"
Inst91QAH = "3 Quests"

--Quest 1 Alliance
Inst91Quest1 = "1. Die Grube von Saron"
Inst91Quest1_Aim = "Trefft Lady Jaina Prachtmeer am Eingang zur Grube von Saron."
Inst91Quest1_Location = "Lady Jaina Prachtmeer (Die Seelenschmiede; "..YELLOW.."[2]"..WHITE..")"
Inst91Quest1_Note = "Lady Jaina Prachtmeer ist innerhalb der Instanz."
Inst91Quest1_Prequest = "Echos gequälter Seelen ("..YELLOW.."Die Seelenschmiede"..WHITE..")"
Inst91Quest1_Folgequest = "Der Pfad zur Zitadelle"
-- No Rewards for this quest

--Quest 2 Alliance
Inst91Quest2 = "2. Der Pfad zur Zitadelle"
Inst91Quest2_Aim = "Befreit 15 Allianzsklaven und tötet Schmiedemeister Garfrost."
Inst91Quest2_Location = "Lady Jaina Prachtmeer (Grube von Saron; "..YELLOW.."Eingang"..WHITE..")"
Inst91Quest2_Note = "Die Sklaven findest Du überall in der Grube. Die Quest führt dich zu Gorkun Eisenschädel bei "..YELLOW.."[1]"..WHITE.." nachdem Schmiedemeister Garfrost erledgt worden ist."
Inst91Quest2_Prequest = "Die Grube von Saron"
Inst91Quest2_Folgequest = "Befreiung aus der Grube"
-- No Rewards for this quest

--Quest 3 Alliance
Inst91Quest3 = "3. Befreiung aus der Grube"
Inst91Quest3_Aim = "Tötet Geiselfürst Tyrannus."
Inst91Quest3_Location = "Lady Jaina Prchtmeer (Grube von Saron; "..YELLOW.."[1]"..WHITE..")"
Inst91Quest3_Note = "Geiselfürst Tyrannus ist am Ende der Instanz. Beende die Quests erfolgreich um in die Hallen der Reflexion zu gelangen."
Inst91Quest3_Prequest = "Der Pfad zur Zitadelle"
Inst91Quest3_Folgequest = "Frostgram ("..YELLOW.."Hallen der Reflexion"..WHITE..")"
--
Inst91Quest3name1 = "Emblem des Frosts"

--Quest 4 Alliance
Inst91Quest4 = "4. Das Schwert neu schmieden"
Inst91Quest4_Aim = "Besorgt 5 energieerfüllte Saronitbarren sowie den Hammer des Schmiedemeisters und schmiedet damit Quel'Delar neu."
Inst91Quest4_Location = "Caladis Prunkspeer (Eiskrone - Quel'Delars Ruh; "..YELLOW.."74.2, 31.3"..WHITE..")"
Inst91Quest4_Note = "Die energieerfüllten Saronitbarren sind innerhalb der Grube verteilt.  Benutzt den Hammer, der vom Boss Schmiedemeister Garfrost droppt, bem Amboss in der Nähe von ihm."
Inst91Quest4_Prequest = "Kehrt zu Caladis Prunkspeer zurück"
Inst91Quest4_Folgequest = "Die Klinge tempern ("..YELLOW.."Forge of Souls"..WHITE..")"
-- No Rewards for this quest


--Quest 1 Horde
Inst91Quest1_HORDE = "1. Die Grube von Saron"
Inst91Quest1_HORDE_Aim = "Trefft Lady Sylvanas Windläufer am Eingang zur Grube von Saron."
Inst91Quest1_HORDE_Location = "Lady Sylvanas Windläufer (Die Seelenschmiede; "..YELLOW.."[2]"..WHITE..")"
Inst91Quest1_HORDE_Note = "Lady Sylvanas Windläufer ist innerhalb der Instanz."
Inst91Quest1_HORDE_Prequest = "Echos gequälter Seelen ("..YELLOW.."Die Seelenschmiede"..WHITE..")"
Inst91Quest1_HORDE_Folgequest = "Der Pfad zur Zitadelle"
-- No Rewards for this quest

--Quest 2 Horde
Inst91Quest2_HORDE = "2. Der Pfad zur Zitadelle"
Inst91Quest2_HORDE_Aim = "Befreit 15 Hordensklaven und tötet Schmiedemeister Garfrost."
Inst91Quest2_HORDE_Location = "Lady Sylvanas Windläufer (Grube von Saron; "..YELLOW.."Eingang"..WHITE..")"
Inst91Quest2_HORDE_Note = "Die Sklaven findest Du überall in der Grube. Die Quest führt dich zu Martin Victus bei "..YELLOW.."[1]"..WHITE.." nachdem Schmiedemeister Garfrost erledgt worden ist."
Inst91Quest2_HORDE_Prequest = "Die Grube von Saron"
Inst91Quest2_HORDE_Folgequest = "Befreiung aus der Grube"
-- No Rewards for this quest

--Quest 3 Horde
Inst91Quest3_HORDE = "3. Befreiung aus der Grube"
Inst91Quest3_HORDE_Aim = "Tötet Geiselfürst Tyrannus."
Inst91Quest3_HORDE_Location = "Lady Sylvanas Windrunner (Grube von Saron; "..YELLOW.."[1]"..WHITE..")"
Inst91Quest3_HORDE_Note = "Geiselfürst Tyrannus ist am Ende der Instanz. Beende die Quests erfolgreich um in die Hallen der Reflexion zu gelangen."
Inst91Quest3_HORDE_Prequest = "Der Pfad zur Zitadelle"
Inst91Quest3_HORDE_Folgequest = "Frostgram ("..YELLOW.."Hallen der Reflexion of Reflection"..WHITE..")"
--
Inst91Quest3name1_HORDE = "Emblem des Frosts"

--Quest 4 Horde
Inst91Quest4_HORDE = "4. Das Schwert neu schmieden"
Inst91Quest4_HORDE_Aim = "Besorgt 5 energieerfüllte Saronitbarren sowie den Hammer des Schmiedemeisters und schmiedet damit Quel'Delar neu."
Inst91Quest4_HORDE_Location = "Myralion Sonnenfeuer (Eiskrone - Quel'Delars Ruh; "..YELLOW.."74.5, 31.1"..WHITE..")"
Inst91Quest4_HORDE_Note = "Die energieerfüllten Saronitbarren sind innerhalb der Grube verteilt.  Benutzt den Hammer, der vom Boss Schmiedemeister Garfrost droppt, bem Amboss in der Nähe von ihm."
Inst91Quest4_HORDE_Prequest = "Rückkehr zu Myralion Sonnenfeuer"
Inst91Quest4_HORDE_Folgequest = "Die Klinge tempern ("..YELLOW.."Forge of Souls"..WHITE..")"
-- No Rewards for this quest



--------------- INST92 - Halls of Reflection (HoR) ---------------

Inst92Story = "Mit Jaina und Sylvanas als ihren Anführern werden die Abenteurer, die es bis in diese eisigen Hallen geschafft haben, die Waffe, die vor ihnen liegt, schnell erkennen: Frostgram, die verführerische, verderbliche und legendäre Waffe des Lichkönigs persönlich. Die Privatgemächer des Lichkönigs liegen in greifbarer Nähe– aber sie könnten der Tod eines jeden sein, der sich dorthin wagt."
Inst92Caption = "HoR:Hallen der Reflexion"
Inst92QAA = "2 Quests"
Inst92QAH = "2 Quests"

--Quest 1 Alliance
Inst92Quest1 = "1. Frostgram"
Inst92Quest1_Aim = "Trefft Lady Jaina Prachtmeer am Eingang zu den Hallen der Reflexion."
Inst92Quest1_Location = "Lady Jaina Prachtmeer (Grube von Saron; "..YELLOW.."[3]"..WHITE..")"
Inst92Quest1_Note = "Die Quest bekommst Du am Ende der Instant Grube von Saron und gibst sie gleich am Eingang der Instanz bei Lady Jaina Prachtmeer ab.Die Folgequest bekommst Du nachdem das Event beendet ist bei Lady Jaina Prachtmeer."
Inst92Quest1_Prequest = "Befreiung aus der Grube ("..YELLOW.."Grube von Saron"..WHITE..")"
Inst92Quest1_Folgequest = "Der Zorn des Lichkönigs"
-- No Rewards for this quest

--Quest 2 Alliance
Inst92Quest2 = "2. Der Zorn des Lichkönigs"
Inst92Quest2_Aim = "Findet Lady Jaina Prachtmeer und flieht aus den Hallen der Reflexion."
Inst92Quest2_Location = "Hallen der Reflexion"
Inst92Quest2_Note = "Lady Jaina Prachtmeer flieht vorne weg. Die Quest ist beendet nachdem das Event erfolgreich abgeschlossen ist."
Inst92Quest2_Prequest = "Frostgram"
Inst92Quest2_Folgequest = "Nein"
--
Inst92Quest2name1 = "Emblem des Frosts"

--Quest 3 Alliance
Inst92Quest3 = "3. Die Hallen der Reflexion"
Inst92Quest3_Aim = "Bringt Quel'Delar nach Schwertruh ins Innere der Hallen der Reflexion."
Inst92Quest3_Location = "Caladis Prunkspeer (Eiskrone - Quel'Delars Ruh; "..YELLOW.."74.2, 31.3"..WHITE..")"
Inst92Quest3_Note = "Du kannst diese Quest innerhalb der Instanz beenden."
Inst92Quest3_Prequest = "Die Klinge tempern ("..YELLOW.."Forge of Souls"..WHITE..")"
Inst92Quest3_Folgequest = "Reise zum Sonnenbrunnen"
-- No Rewards for this quest


--Quest 1 Horde
Inst92Quest1_HORDE = "1. Frostgram"
Inst92Quest1_HORDE_Aim = "Trefft Lady Sylvanas Windläufer am Eingang zu den Hallen der Reflexion."
Inst92Quest1_HORDE_Location = "Lady Sylvanas Windläufer (Grube von Saron; "..YELLOW.."[3]"..WHITE..")"
Inst92Quest1_HORDE_Note = "Die Quest bekommst Du am Ende der Instant Grube von Saron und gibst sie gleich am Eingang der Instanz bei Lady Sylvanas Windläufer ab.Die Folgequest bekommst Du nachdem das Event beendet ist bei Lady Sylvanas Windläufer.."
Inst92Quest1_HORDE_Prequest = "Befreiung aus der Grube ("..YELLOW.."Grube von Saron"..WHITE..")"
Inst92Quest1_HORDE_Folgequest = "Der Zorn des Lichkönigs"
-- No Rewards for this quest

--Quest 2 Horde
Inst92Quest2_HORDE = "2. Der Zorn des Lichkönigs"
Inst92Quest2_HORDE_Aim = "Findet Lady Sylvanas Windläufer und flieht aus den Hallen der Reflexion."
Inst92Quest2_HORDE_Location = "Hallen der Reflexion"
Inst92Quest2_HORDE_Note = "Lady Sylvanas Windläufer flieht vorne weg. Die Quest ist beendet nachdem das Event erfolgreich abgeschlossen ist."
Inst92Quest2_HORDE_Prequest = "Frostgram"
Inst92Quest2_HORDE_Folgequest = "Nein"
--
Inst92Quest2name1_HORDE = "Emblem des Frosts"

--Quest 3 Horde
Inst92Quest3_HORDE = "3. Die Hallen der Reflexion"
Inst92Quest3_HORDE_Aim = "Bringt Quel'Delar nach Schwertruh ins Innere der Hallen der Reflexion."
Inst92Quest3_HORDE_Location = "Myralion Sonnenfeuer (Eiskrone - Quel'Delars Ruh; "..YELLOW.."74.5, 31.1"..WHITE..")"
Inst92Quest3_HORDE_Note = "Du kannst diese Quest innerhalb der Instanz beenden."
Inst92Quest3_HORDE_Prequest = "Die Klinge tempern ("..YELLOW.."Forge of Souls"..WHITE..")"
Inst92Quest3_HORDE_Folgequest = "Reise zum Sonnenbrunnen"
-- No Rewards for this quest



--------------- INST93 - Icecrown Citadel (ICC) ---------------

Inst93Story = "Die Eiskronenzitadelle ist eine riesige Festung auf dem Eiskronengletscher mit dicken Wänden, robusten Wachtürmen und massiven Eingangstoren. Die Eiskrone bekam ihren Namen, als Kil'jaeden den Lichkönig zurück in die sterbliche Welt stürzte. Hier verweilte er, bis Arthas ihn befreite und sie zusammen in Arthas Körper verschmolzen. Die Vereinigung löste eine schwere Explosion aus, die den Frostthron freisetzte. Von hier aus befehligt der Lichkönig nun die Geißel. Aus den Trümmern des einstigen Eisturms ist eine mächtige, bedrohliche schwarze Festung geworden. Der Hauptteil der Zitadelle liegt oberhalb des gesplitterten Gletschers, die Gletscherteile selber werden durch Brücken und Wege überwunden. Beim Betreten der Zitadelle stellt man sofort die Kälte fest, die hier innewohnt, keine Dekoration und auch keine Teppiche oder Vorlagewerke schmücken diese Festung. Am Fuße der Gletscherspalte befindet sich der Frostthron, das Herz der Geißel und des Lichkönigs privater Sitz."
Inst93Caption = "ICC:Eiskronenzitadelle"
Inst93QAA = "15 Quest"
Inst93QAH = "15 Quest"

--Quest 1 Alliance
Inst93Quest1 = "1. Lord Mark'gar muss sterben! (Wöchentlich)"
Inst93Quest1_Aim = "Tötet Lord Mark'gar."
Inst93Quest1_Location = "Erzmagier Lan'dalock (Dalaran - Die Violette Festung; "..YELLOW.."57.6, 66.9"..WHITE..")"
Inst93Quest1_Note = "Lord Mark'gar ist bei "..YELLOW.." [1]"..WHITE..".\n\nDiese wöchentliche Quest kann von einem Schlachtzug jeglicher Schwierigkeitsstufe oder Größe abgeschlossen werden."
Inst93Quest1_Prequest = "Nein"
Inst93Quest1_Folgequest = "Nein"
--
Inst93Quest1name1 = "Emblem des Frosts"
Inst93Quest1name2 = "Emblem des Triumphs"

--Quest 2 Alliance
Inst93Quest2 = "2. Entprogrammieren (Zufällig Wöchentlich)"
Inst93Quest2_Aim = "Bezwingt Lady Todeswisper, aber stellt dabei sicher, dass Darnavan überlebt."
Inst93Quest2_Location = "Spitzel Minchar (Eiskronenzitadelle; "..YELLOW.."Near [1]"..WHITE..")"
Inst93Quest2_Note = "Wenn diese Quest für Eure Raid-ID verfügbar ist, erscheint Spietzel Minchar nachdem Lord Mark'gar besiegt wurde.\n\nWährend der Begegnung mit Lady Todeswisper, wird Darnavan erscheinen. Er muß den kompletten Kampf überleben um diese Quest zu beenden."
Inst93Quest2_Prequest = "Nein"
Inst93Quest2_Folgequest = "Nein"
--
Inst93Quest2name1 = "Sack mit frostigen Schätzen"

--Quest 3 Alliance
Inst93Quest3 = "3. Sicherung des Bollwerks (Zufällig Wöchentlich)"
Inst93Quest3_Aim = "Erledigt den verrottenden Frostriesen."
Inst93Quest3_Location = "Leutnant der Himmelsbrecher (Eiskronenzitadelle; "..GREEN.."[3']"..WHITE..")"
Inst93Quest3_Note = "Wenn diese Quest für Eure Raid-ID verfügbar ist, wird Leutnant der Himmelsbrecher erscheinen nachdem der erste Trashmob, nach dem Tot von Lady Todeswisper, gepullt wurde.\n\nDie verrottenden Frostriesen können auf der Plattform gefunden werden."
Inst93Quest3_Prequest = "Nein"
Inst93Quest3_Folgequest = "Nein"
--
Inst93Quest3name1 = "Sack mit frostigen Schätzen"

--Quest 4 Alliance
Inst93Quest4 = "4. Wandelnder Wirt (Zufällig Wöchentlich)"
Inst93Quest4_Aim = "Kehrt zu Alchemistin Adrianna zurück, während Ihr mit der orangenen und der grünen Seuche infiziert seid."
Inst93Quest4_Location = "Alchemistin Adrianna (Eiskronenzitadelle; "..GREEN.."[4']"..WHITE..")"
Inst93Quest4_Note = "Wenn diese Quest für Eure Raid-ID verfügbar ist, wird Alchemistin Adrianna erscheinen nachdem der Teleporter aktiviert wurde der hinter Todesbringer Saurfang ist.\n\nUm diese Quest zu beenden muß mindestens ein Raidmitglied die beiden Debuffs von Fauldarm und Modermiene besitzen und innerhalb von 30 Minuten zu Alchemistin Adrianna zurückkehren nachdem der erste Debuff gesprochen wurde. Alle Raidmitglieder mit dieser Quest bekommen einen Gutschein."
Inst93Quest4_Page = {2, "Die Debuffs verschwinden nach dem Tot, Göttliches Eingreifen und Göttliches Schild und vielleicht auch andere Fähigkeiten könnten dies eventuell verhindern. Jäger die sich totstellen behalten die Debuffs.", };
Inst93Quest4_Prequest = "Nein"
Inst93Quest4_Folgequest = "Nein"
--
Inst93Quest4name1 = "Sack mit frostigen Schätzen"

--Quest 5 Alliance
Inst93Quest5 = "5. Erhöhter Blutdruck (Zufällig Wöchentlich)"
Inst93Quest5_Aim = "Rettet den Spitzel Minchar, bevor er hingerichtet wird."
Inst93Quest5_Location = "Alrin der Bewegliche (Eiskronenzitadelle; Eingang zu den Blutroten Hallen)"
Inst93Quest5_Note = "Wenn diese Quest für Eure Raid-ID verfügbar ist, wird Alrin der Bewegliche erscheinen nachdem die Blutroten Hallen betreten wurden.\n\nEin 30 Minütiger Countdown beginnt nachdem die Hochroten Hallen betreten wurde. Ihr müßt alles bereinigen, besiegt den Blutprinzen und die Blutkönigen Lana'thel bevor die Zeit abläuft um die Quest zu beenden."
Inst93Quest5_Prequest = "Nein"
Inst93Quest5_Folgequest = "Nein"
--
Inst93Quest5name1 = "Sack mit frostigen Schätzen"

--Quest 6 Alliance
Inst93Quest6 = "6. Frieden für eine geschundene Seele (Zufällig Wöchentlich)"
Inst93Quest6_Aim = "Benutzt die Lebenskristall, um Sindragosas Essenz zu erhalten."
Inst93Quest6_Location = "Valithria Traumwandler (Eiskronenzitadelle; "..YELLOW.."[11]"..WHITE..")"
Inst93Quest6_Note = "Wenn diese Quest für Eure Raid-ID verfügbar ist, wird Valithria Traumwandler Euch eine Quest geben nachdem die Begegnung beendet ist.\n\nUm diese Quest zu beenden, müssen die Raidmitglieder den zur Verfügung gestellten Gegenstand benutzen und den Debuff hochstacken (30 bei 10 Spieler, 75 bei 25 Spieler) bei  Sindragosa wenn sie bei 20% Leben oder darunter ist. Wenn dies Erfolgreich gemacht wird und Sindragosa eine Aura der Seelenbewahrung bekommt bevor sie stirbt, ist diese Quest beendet."
Inst93Quest6_Prequest = "Nein"
Inst93Quest6_Folgequest = "Nein"
--
Inst93Quest6name1 = "Sack mit frostigen Schätzen"

--Quest 7 Alliance
Inst93Quest7 = "7. Die Heiligen und die Verderbten"
Inst93Quest7_Aim = "Platziert Lichträcher, 25 Einheiten urtümliches Saronit sowie Modermienes und Fauldarms ätzendes Blut in Hochlord Mograines Runenschmiede in der Eiskronenzitadelle."
Inst93Quest7_Location = "Hochlord Darion Mograine (Eiskronenzitadelle; "..GREEN.."[1']"..WHITE..")"
Inst93Quest7_Note = "Diese Questreihe ist nur für Krieger, Paldine und Todesritter. Hochlord Mograine's Runenschmiede ist am Eingang der Eiskronenzitadelle.\n\nModermienes und Fauldarms ätzendes Blut droppt nur in der 25 Spieler Version und kann nur von einem einzigen Raidmitglied aufgenommen werden."
Inst93Quest7_Prequest = "Nein"
Inst93Quest7_Folgequest = "Schattenschneide"
-- No Rewards for this quest

--Quest 8 Alliance
Inst93Quest8 = "8. Schattenschneide"
Inst93Quest8_Aim = "Vermutlich: Kehrt zu Hochlord Darion Mograin in der Eiskronenzitadelle zurück."
Inst93Quest8_Location = "Hochlord Darion Mograine (Eiskronenzitadelle; "..GREEN.."[1']"..WHITE..")"
Inst93Quest8_Note = "Vermutlich ist dies die Quest wo Du die Schattenschneide bekommst!"
Inst93Quest8_Prequest = "Die Heiligen und die Verderbten"
Inst93Quest8_Folgequest = "Ein Seelenschmaus"
--
Inst93Quest8name1 = "Schattenschneide"

--Quest 9 Alliance
Inst93Quest9 = "9. Ein Seelenschmaus"
Inst93Quest9_Aim = "Hochlord Darion Mograine möchte, dass Ihr mit Schattenschneide 1.000 Diener des Lichkönigs in der Eiskronenzitadelle tötet. Die Seelen sind nur in den Schwierigkeitsgraden für 10 oder 25 Mann erhältlich."
Inst93Quest9_Location = "Hochlord Darion Mograine (Eiskronenzitadelle; "..GREEN.."[1']"..WHITE..")"
Inst93Quest9_Note = "Nur Tötungen in der Eiskronenzitadelle zählen um die 1000 zusammenzubekommen."
Inst93Quest9_Prequest = "Schttenschneide"
Inst93Quest9_Folgequest = "Erfüllt mit unheiliger Macht"
-- No Rewards for this quest

--Quest 10 Alliance
Inst93Quest10 = "10. Erfüllt mit unheiliger Macht"
Inst93Quest10_Aim = "Hochlord Darion Mograine möchte, dass Ihr Schattenschneide mit unheiliger Macht erfüllt und Professor Seuchenmord tötet."
Inst93Quest10_Location = "Hochlord Darion Mograine (Eiskronenzitadelle; "..GREEN.."[1']"..WHITE..")"
Inst93Quest10_Note = "Diese Quest kann nur in der 25 Version beendet werden.\n\nTo infuse Shadow's Edge you must take control of the Abomination during the Professor Putricide encounter and use the special ability called Shadow Infusion."
Inst93Quest10_Prequest = "Ein Seelenschmaus"
Inst93Quest10_Folgequest = "Erfüllt mit der Macht des Blutes"
-- No Rewards for this quest

--Quest 11 Alliance
Inst93Quest11 = "11. Erfüllt mit der Macht des Blutes"
Inst93Quest11_Aim = "Hochlord Darion Mograine möchte, dass Ihr Schattenschneide mit der Macht des Blutes erfüllt und Blutkönigin Lana'thel besiegt."
Inst93Quest11_Location = "Hochlord Darion Mograine (Eiskronenzitadelle; "..GREEN.."[1']"..WHITE..")"
Inst93Quest11_Note = "Diese Quest kann nur in der 25 Version beendet werden.\n\nUm diese Quest zu beenden, mußt Du den Blutspiegel Debuff bekommen. Dann, falls Du nicht als erstes gebissen werden solltest, muß derjenige der gebissen wurde dich beisen. Beise 3 weitere Radimitgliederr und überlebe die Begegnung um diese Quest zu beenden."
Inst93Quest11_Prequest = "Erfüllt mit unheiliger Macht"
Inst93Quest11_Folgequest = "Erfüllt mit der Macht des Frostes"
-- No Rewards for this quest

--Quest 12 Alliance
Inst93Quest12 = "12. Erfüllt mit der Macht des Frostes"
Inst93Quest12_Aim = "Hochlord Darion Mograine hat Euch den Auftrag erteilt, Sindragosa zu töten, nachdem Ihr 4-mal ihren Atemattacken ausgesetzt wart, während Ihr Schattenschneide führt."
Inst93Quest12_Location = "Hochlord Darion Mograine (Eiskronenzitadelle; "..GREEN.."[1']"..WHITE..")"
Inst93Quest12_Note = "Diese Quest kann nur in der 25 Version beendet werden.\n\nNachdem Du 4 mal den Frostatem abbekommen hast, mußt Sindragosa innerhalb von 6 Minuten getötet werden um diese Quest zu beenden."
Inst93Quest12_Prequest = "Erfüllt mit der Macht des Blutes"
Inst93Quest12_Folgequest = "The Splintered Throne"
-- No Rewards for this quest

--Quest 13 Alliance
Inst93Quest13 = "13. Der Zersplitterte Thron"
Inst93Quest13_Aim = "Hochlord Darion Mograine möchte, dass Du 50 Schattenfrostsplitter sammelst."
Inst93Quest13_Location = "Hochlord Darion Mograine (Eiskronenzitadelle; "..GREEN.."[1']"..WHITE..")"
Inst93Quest13_Note = "Diese Quest kann nur in der 25 Version beendet werden.\n\nDie Schattenfrostsplitter sind seltene Drops von den Bossen."
Inst93Quest13_Prequest = "Erfüllt mit der Macht des Frostes"
Inst93Quest13_Folgequest = "Schattengram..."
-- No Rewards for this quest

--Quest 14 Alliance
Inst93Quest14 = "14. Schattengram..."
Inst93Quest14_Aim = "Hochlord Darion Mograine möchte, dass Du ihm Schattenschneide bringst."
Inst93Quest14_Location = "Hochlord Darion Mograine (Eiskronenzitadelle; "..GREEN.."[1']"..WHITE..")"
Inst93Quest14_Note = "Diese Quest verbessert Deine Schattenschneide zu Schattengram."
Inst93Quest14_Prequest = "Der Zersplitterte Thron"
Inst93Quest14_Folgequest = "Der letzte Standplatz des Lichkönigs"
--
Inst93Quest14name1 = "Schattengram"

--Quest 15 Alliance
Inst93Quest15 = "15. Der letzte Standplatz des Lichkönigs"
Inst93Quest15_Aim = "Hochlord Darion Mograine in der Eiskronenzitadelle möchte, dass Du den Lichkönig tötest."
Inst93Quest15_Location = "Hochlord Darion Mograine (Eiskronenzitadelle; "..GREEN.."[1']"..WHITE..")"
Inst93Quest15_Note = "Diese Quest um Schattengram zu bekommen kann man Vermutlich nur in der 25 Mann Version abschließen."
Inst93Quest15_Prequest = "Schattengram..."
Inst93Quest15_Folgequest = "Nein"
-- No Rewards for this quest


--Quest 1 Horde (same as Quest 1 Alliance)
Inst93Quest1_HORDE = Inst93Quest1
Inst93Quest1_HORDE_Aim = Inst93Quest1_Aim
Inst93Quest1_HORDE_Location = Inst93Quest1_Location
Inst93Quest1_HORDE_Note = Inst93Quest1_Note
Inst93Quest1_HORDE_Prequest = Inst93Quest1_Prequest
Inst93Quest1_HORDE_Folgequest = Inst93Quest1_Folgequest
--
Inst93Quest1name1_HORDE = Inst93Quest1name1
Inst93Quest1name2_HORDE = Inst93Quest1name2 

--Quest 2 Horde (same as Quest 2 Alliance)^
Inst93Quest2_HORDE = Inst93Quest2
Inst93Quest2_HORDE_Aim = Inst93Quest2_Aim
Inst93Quest2_HORDE_Location = Inst93Quest2_Location
Inst93Quest2_HORDE_Note = Inst93Quest2_Note
Inst93Quest2_HORDE_Prequest = Inst93Quest2_Prequest
Inst93Quest2_HORDE_Folgequest = Inst93Quest2_Folgequest

Inst93Quest2name1_HORDE = Inst93Quest2name1

--Quest 3 Horde 
Inst93Quest3_HORDE = "3. Sicherung des Bollwerks (Zufällig Wöchentlich)"
Inst93Quest3_HORDE_Aim = "Erledigt den verrottenden Frostriesen."
Inst93Quest3_HORDE_Location = "Leutnant der Ogrims Hammer (Eiskronenzitadelle; "..GREEN.."[3']"..WHITE..")"
Inst93Quest3_HORDE_Note = "Wenn diese Quest für Eure Raid-ID verfügbar ist, wir Leutnant der Ogrims Hammer erscheinen nachdem der erste Trashmob, nach dem Tot von Lady Todeswisper, gepullt wurde.\n\nDie verrottenden Frostriesen können auf der Plattform gefudnen werden."
Inst93Quest3_HORDE_Prequest = "Nein"
Inst93Quest3_HORDE_Folgequest = "Nein"
--
Inst93Quest3name1_HORDE = "Sack mit frostigen Schätzen"

--Quest 4 Horde (same as Quest 4 Alliance)
Inst93Quest4_HORDE = Inst93Quest4
Inst93Quest4_HORDE_Aim = Inst93Quest4_Aim
Inst93Quest4_HORDE_Location = Inst93Quest4_Location
Inst93Quest4_HORDE_Note = Inst93Quest4_Note
Inst93Quest4_HORDE_Page = Inst93Quest4_Page
Inst93Quest4_HORDE_Prequest = Inst93Quest4_Prequest
Inst93Quest4_HORDE_Folgequest = Inst93Quest4_Folgequest
--
Inst93Quest4name1_HORDE = Inst93Quest4name1

--Quest 5 Horde (same as Quest 5 Alliance)
Inst93Quest5_HORDE = Inst93Quest5
Inst93Quest5_HORDE_Aim = Inst93Quest5_Aim
Inst93Quest5_HORDE_Location = Inst93Quest5_Location
Inst93Quest5_HORDE_Note = Inst93Quest5_Note
Inst93Quest5_HORDE_Prequest = Inst93Quest5_Prequest
Inst93Quest5_HORDE_Folgequest = Inst93Quest5_Folgequest
--
Inst93Quest5name1_HORDE = Inst93Quest5name1

--Quest 6 Horde (same as Quest 6 Alliance)
Inst93Quest6_HORDE = Inst93Quest6
Inst93Quest6_HORDE_Aim = Inst93Quest6_Aim
Inst93Quest6_HORDE_Location = Inst93Quest6_Location
Inst93Quest6_HORDE_Note = Inst93Quest6_Note
Inst93Quest6_HORDE_Prequest = Inst93Quest6_Prequest
Inst93Quest6_HORDE_Folgequest = Inst93Quest6_Folgequest
--
Inst93Quest6name1_HORDE = Inst93Quest6name1

--Quest 7 Horde (same as Quest 7 Alliance)
Inst93Quest7_HORDE = Inst93Quest7
Inst93Quest7_HORDE_Aim = Inst93Quest7_Aim
Inst93Quest7_HORDE_Location = Inst93Quest7_Location
Inst93Quest7_HORDE_Note = Inst93Quest7_Note
Inst93Quest7_HORDE_Prequest = Inst93Quest7_Prequest
Inst93Quest7_HORDE_Folgequest = Inst93Quest7_Folgequest

--Quest 8 Horde (same as Quest 8 Alliance)
Inst93Quest8_HORDE = Inst93Quest8
Inst93Quest8_HORDE_Aim = Inst93Quest8_Aim
Inst93Quest8_HORDE_Location = Inst93Quest8_Location
Inst93Quest8_HORDE_Note = Inst93Quest8_Note
Inst93Quest8_HORDE_Prequest = Inst93Quest8_Prequest
Inst93Quest8_HORDE_Folgequest = Inst93Quest8_Folgequest
--
Inst93Quest8name1_HORDE = Inst93Quest8name1

--Quest 9 Horde (same as Quest 9 Alliance)
Inst93Quest9_HORDE = Inst93Quest9
Inst93Quest9_HORDE_Aim = Inst93Quest9_Aim
Inst93Quest9_HORDE_Location = Inst93Quest9_Location
Inst93Quest9_HORDE_Note = Inst93Quest9_Note
Inst93Quest9_HORDE_Prequest = Inst93Quest9_Prequest
Inst93Quest9_HORDE_Folgequest = Inst93Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde (same as Quest 10 Alliance)
Inst93Quest10_HORDE = Inst93Quest10
Inst93Quest10_HORDE_Aim = Inst93Quest10_Aim
Inst93Quest10_HORDE_Location = Inst93Quest10_Location
Inst93Quest10_HORDE_Note = Inst93Quest10_Note
Inst93Quest10_HORDE_Prequest = Inst93Quest10_Prequest
Inst93Quest10_HORDE_Folgequest = Inst93Quest10_Folgequest
-- No Rewards for this quest

--Quest 11 Horde (same as Quest 11 Alliance)
Inst93Quest11_HORDE = Inst93Quest11
Inst93Quest11_HORDE_Aim = Inst93Quest11_Aim
Inst93Quest11_HORDE_Location = Inst93Quest11_Location
Inst93Quest11_HORDE_Note = Inst93Quest11_Note
Inst93Quest11_HORDE_Prequest = Inst93Quest11_Prequest
Inst93Quest11_HORDE_Folgequest = Inst93Quest11_Folgequest
-- No Rewards for this quest

--Quest 12 Horde (same as Quest 12 Alliance)
Inst93Quest12_HORDE = Inst93Quest12
Inst93Quest12_HORDE_Aim = Inst93Quest12_Aim
Inst93Quest12_HORDE_Location = Inst93Quest12_Location
Inst93Quest12_HORDE_Note = Inst93Quest12_Note
Inst93Quest12_HORDE_Prequest = Inst93Quest12_Prequest
Inst93Quest12_HORDE_Folgequest = Inst93Quest12_Folgequest
-- No Rewards for this quest

--Quest 13 Horde (same as Quest 13 Alliance)
Inst93Quest13_HORDE = Inst93Quest13
Inst93Quest13_HORDE_Aim = Inst93Quest13_Aim
Inst93Quest13_HORDE_Location = Inst93Quest13_Location
Inst93Quest13_HORDE_Note = Inst93Quest13_Note
Inst93Quest13_HORDE_Prequest = Inst93Quest13_Prequest
Inst93Quest13_HORDE_Folgequest = Inst93Quest13_Folgequest
-- No Rewards for this quest

--Quest 14 Horde (same as Quest 14 Alliance)
Inst93Quest14_HORDE = Inst93Quest14
Inst93Quest14_HORDE_Aim = Inst93Quest14_Aim
Inst93Quest14_HORDE_Location = Inst93Quest14_Location
Inst93Quest14_HORDE_Note = Inst93Quest14_Note
Inst93Quest14_HORDE_Prequest = Inst93Quest14_Prequest
Inst93Quest14_HORDE_Folgequest = Inst93Quest14_Folgequest
--
Inst93Quest14name1_HORDE = Inst93Quest14name1

--Quest 15 Horde (same as Quest 15 Alliance)
Inst93Quest15_HORDE = Inst93Quest15
Inst93Quest15_HORDE_Aim = Inst93Quest15_Aim
Inst93Quest15_HORDE_Location = Inst93Quest15_Location
Inst93Quest15_HORDE_Note = Inst93Quest15_Note
Inst93Quest15_HORDE_Prequest = Inst93Quest15_Prequest
Inst93Quest15_HORDE_Folgequest = Inst93Quest15_Folgequest
-- No Rewards for this quest 



--------------- INST94 - Ruby Sanctum (RS)  ---------------

Inst94Story = "Eine mächtige Kampftruppe des Schwarzen Drachenschwarms, angeführt vom furchterregenden Zwielichtdrachen Halion, hat den Angriff auf das Rubinsanktum unterhalb des Wyrmruhtempels eingeläutet. Durch die Zerstörung des Rubinsanktums will der Schwarze Drachenschwarm jene vernichten, die die Rückkehr ihres Meisters nach Azeroth zu verhindern suchen und letzten Endes den Wyrmruhpakt endgültig zerschlagen – jenen heiligen Bund, der alle Drachenschwärme eint.\n\nDie Schlacht, die sich anbahnt, wird dem Roten Dracheschwarm ohne Zweifel einen empfindlichen Schlag versetzen, doch es liegt an Euch, diese nie dagewesene Attacke abzuschwächen und das Rubinsanktum zu verteidigen. Zunächst gilt es, den Angriffen von Halions Dienern standzuhalten; Saviana Flammenschlund, Baltharus der Kriegsjünger und General Zarithrian müssen bezwungen werden, bevor der Kampf gegen Halion, den Zwielichtzerstörer, eine neue und überaus tödliche Macht im Reich, aufgenommen werden kann."
Inst94Caption = "RS:Das Rubinsanktum"
Inst94QAA = "3 Quests"
Inst94QAH = "3 Quests"

--Quest 1 Alliance
Inst94Quest1 = "1. Ärger am Wyrmruhtempel"
Inst94Quest1_Aim = "Sprecht mit Krasus im Wyrmruhtempel in der Drachenöde."
Inst94Quest1_Location = "Rhonin (Dalaran - Die Violette Zitadelle; "..YELLOW.."30.5, 48.4"..WHITE..")"
Inst94Quest1_Note = "Krasus ist bei (Drachenöde - Wyrmruhtempel; "..YELLOW.."59.8, 54.6"..WHITE..")."
Inst94Quest1_Prequest = "Nein"
Inst94Quest1_Folgequest = "Angriff auf das Sanktum"
-- No Rewards for this quest

--Quest 2 Alliance
Inst94Quest2 = "2. Angriff auf das Sanktum"
Inst94Quest2_Aim = "Untersucht das Rubinsanktum unterhalb des Wyrmruhtempels."
Inst94Quest2_Location = "Krasus (Drachenöde - Wyrmruhtempel; "..YELLOW.."59.8, 54.6"..WHITE..")"
Inst94Quest2_Note = "Wächterin des Sanktum Xerestrasza ist innerhalb des Rubin Sanktum bei dem 2. Nebenboss Baltharus der Kriegsjünger bei "..YELLOW.."[4]"..WHITE.."."
Inst94Quest2_Prequest = "Ärger am Wyrmruhtempel"
Inst94Quest2_Folgequest = "Der Zwielichtzerstörer"
-- No Rewards for this quest

--Quest 3 Alliance
Inst94Quest3 = "3. Der Zwielichtzerstörer"
Inst94Quest3_Aim = "Besiegt Halion und vertreibt die Invasion aus dem Rubinsanktum."
Inst94Quest3_Location = "Wächterin des Sanktum Xerestrasza (Rubinsanktum; "..YELLOW.."[A] Eingang"..WHITE..")"
Inst94Quest3_Note = "Halion ist der Hauptboss, zu finden bei "..YELLOW.."[1]"..WHITE.."."
Inst94Quest3_Prequest = "Ärger am Wyrmruhtempel"
Inst94Quest3_Folgequest = "Nein"
--
Inst94Quest3name1 = "Emblem des Frosts"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst94Quest1_HORDE = Inst94Quest1
Inst94Quest1_HORDE_Aim = Inst94Quest1_Aim
Inst94Quest1_HORDE_Location = Inst94Quest1_Location
Inst94Quest1_HORDE_Note = Inst94Quest1_Note
Inst94Quest1_HORDE_Prequest = Inst94Quest1_Prequest
Inst94Quest1_HORDE_Folgequest = Inst94Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst94Quest2_HORDE = Inst94Quest2
Inst94Quest2_HORDE_Aim = Inst94Quest2_Aim
Inst94Quest2_HORDE_Location = Inst94Quest2_Location
Inst94Quest2_HORDE_Note = Inst94Quest2_Note
Inst94Quest2_HORDE_Prequest = Inst94Quest2_Prequest
Inst94Quest2_HORDE_Folgequest = Inst94Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst94Quest3_HORDE = Inst94Quest3
Inst94Quest3_HORDE_Aim = Inst94Quest3_Aim
Inst94Quest3_HORDE_Location = Inst94Quest3_Location
Inst94Quest3_HORDE_Note = Inst94Quest3_Note
Inst94Quest3_HORDE_Prequest = Inst94Quest3_Prequest
Inst94Quest3_HORDE_Folgequest = Inst94Quest3_Folgequest
--
Inst94Quest3name1_HORDE = Inst94Quest3name1





end
-- End of File
