local L = LibStub("AceLocale-3.0"):NewLocale("PallyPower", "deDE", false, false)
if not L then return end
L["AURA"] = "Aura-Taste"
L["AURA_DESC"] = "[|cffffd200Enable|r / |cffffd200Disable|r] Die Aura-Schaltfläche oder wählen Sie die Aura aus, die Sie verfolgen möchten."
L["AURABTN"] = "Aura-Taste"
L["AURABTN_DESC"] = "[Aktivieren / Deaktivieren] Die Aura-Schaltfläche"
L["AURATRACKER"] = "Aura Tracker"
L["AURATRACKER_DESC"] = "Wählen Sie die Aura aus, die Sie verfolgen möchten"
L["AUTO"] = "Auto Buff Button"
L["AUTO_DESC"] = "[|cffffd200Enable|r / |cffffd200Disable|r] Die Auto Buff-Schaltfläche oder [|cffffd200Enable|r / |cffffd200Disable|r] Warten auf Spieler."
L["AUTOASSIGN"] = "Auto-Assign"
L["AUTOASSIGN_DESC"] = [=[Alle Segnungen basierend auf automatisch zuweisen
die Anzahl der verfügbaren Paladine
und ihre verfügbaren Segnungen.

|cffffffff [Umschalt-Linksklick]|r Battleground verwenden
Zuweisungsvorlage anstelle von Raid
Zuweisungsvorlage.]=]
L["AUTOBTN"] = "Auto Buff Button"
L["AUTOBTN_DESC"] = "[Aktivieren / Deaktivieren] Die Auto Buff-Schaltfläche"
L["AUTOKEY1"] = "Auto Normal Blessing Key"
L["AUTOKEY1_DESC"] = "Schlüsselbindung zum automatischen Polieren normaler Segnungen."
L["AUTOKEY2"] = "Auto Greater Blessing Key"
L["AUTOKEY2_DESC"] = "Schlüsselbindung zum automatisierten Polieren größerer Segnungen."
L["BAP"] = "Skala für Segenzuweisungen"
L["BAP_DESC"] = "Hiermit können Sie die Gesamtgröße des Segments für Segenzuweisungen anpassen."
L["BRPT"] = "Segensbericht"
L["BRPT_DESC"] = [=[Alle Segnungen melden
Zuordnungen zu den
Schlachtzugs- oder Partykanal.]=]
L["BSC"] = "PallyPower Buttons Scale"
L["BSC_DESC"] = "Hiermit können Sie die Gesamtgröße der PallyPower-Tasten anpassen."
L["BUFFDURATION"] = "Buff Duration"
L["BUFFDURATION_DESC"] = "Wenn diese Option deaktiviert ist, ignorieren die Klassen- und Spielerschaltflächen eine Buff-Dauer, sodass ein Buff nach Belieben erneut angewendet werden kann. Dies ist besonders nützlich für Schutzpaladine, wenn sie größere Segnungen als Spam versenden, um mehr Bedrohung zu erzeugen."
L["BUTTONS"] = "Buttons"
L["BUTTONS_DESC"] = "Schaltflächeneinstellungen ändern"
L["CLASSBTN"] = "Klassenschaltflächen"
L["CLASSBTN_DESC"] = "Wenn diese Option deaktiviert ist, werden auch die Player-Schaltflächen deaktiviert, und Sie können nur mit der Schaltfläche Automatische Optimierung polieren."
L["CPBTNS"] = "Klassen- und Spielertasten"
L["CPBTNS_DESC"] = "[|cffffd200Enable|r / |cffffd200Disable|r] Die Spieler- oder Klassenschaltflächen."
L["DISPEDGES"] = "Grenzen"
L["DISPEDGES_DESC"] = "Ändern der Schaltflächenränder"
L["DRAG"] = "Handle-Taste ziehen"
L["DRAG_DESC"] = "[|cffffd200Enable|r / |cffffd200Disable|r] Die Drag-Handle-Schaltfläche."
L["DRAGHANDLE"] = [=[|cffffffff [Linksklick]|r |cffff0000Lock|r / |cff00ff00Unlock|r PallyPower
|cffffffff [Linksklick-Halten]|r PallyPower verschieben
|cffffffff [Rechtsklick]|r Segenzuweisungen öffnen
|cffffffff [Umschalt-Rechtsklick]|r Optionen öffnen]=]
L["DRAGHANDLE_ENABLED"] = "Handle ziehen"
L["DRAGHANDLE_ENABLED_DESC"] = "[Aktivieren / Deaktivieren] Der Drag-Handle"
L["ENABLEPP"] = "PallyPower aktivieren"
L["ENABLEPP_DESC"] = "[Aktivieren / Deaktivieren] PallyPower"
L["FREEASSIGN"] = "Freie Zuordnung"
L["FREEASSIGN_DESC"] = [=[Erlaube anderen, deine zu ändern
Segen ohne Partei zu sein
Anführer / Schlachtzugsassistent.]=]
L["FULLY_BUFFED"] = "Vollständig poliert"
L["HORLEFTDOWN"] = "Horizontal links | unten"
L["HORLEFTUP"] = "Horizontal links | oben"
L["HORRIGHTDOWN"] = "Horizontal rechts | unten"
L["HORRIGHTUP"] = "Horizontal rechts | oben"
L["LAYOUT"] = "Buff Button | Player Button Layout"
L["LAYOUT_DESC"] = [=[Vertikal [Links / Rechts]
Horizontal [Auf / Ab]]=]
L["MAINASSISTANT"] = "Auto-Buff-Hauptassistent"
L["MAINASSISTANT_DESC"] = "Wenn Sie diese Option aktivieren, überschreibt PallyPower automatisch einen größeren Segen mit einem normalen Segen für Spieler, die mit der Rolle |cffffd200Main Assistant|r im Blizzard Raid Panel gekennzeichnet sind. Dies ist nützlich, um den Segen des |cffffd200Main Assistant|r zu vermeiden Rolle mit einem größeren Segen der Erlösung. "
L["MAINASSISTANTGBUFFDP"] = "Druiden / Paladine überschreiben ..."
L["MAINASSISTANTGBUFFDP_DESC"] = "Wählen Sie die Zuweisung für den größeren Segen aus, die Sie auf dem Haupttank überschreiben möchten: Druiden / Paladine."
L["MAINASSISTANTGBUFFW"] = "Krieger überschreiben ..."
L["MAINASSISTANTGBUFFW_DESC"] = "Wählen Sie die Aufgabe Größerer Segen aus, die Sie auf Haupttank: Krieger überschreiben möchten."
L["MAINASSISTANTNBUFFDP"] = "... mit Normal ..."
L["MAINASSISTANTNBUFFDP_DESC"] = "Wählen Sie den normalen Segen aus, mit dem Sie den Haupttank überschreiben möchten: Druiden / Paladine."
L["MAINASSISTANTNBUFFW"] = "... mit Normal ..."
L["MAINASSISTANTNBUFFW_DESC"] = "Wählen Sie den normalen Segen aus, mit dem Sie den Hauptpanzer: Krieger überschreiben möchten."
L["MAINROLES"] = "Haupttank / Hauptassistenzrollen"
L["MAINROLES_DESC"] = [=[Diese Optionen können verwendet werden, um automatisch alternative normale Segnungen für jeden größeren Segen zuzuweisen, der nur Kriegern, Druiden oder Paladinen |cffff0000|r zugewiesen ist.

Normalerweise wurden die Rollen Haupttank und Hauptassistent verwendet, um Haupttanks und Off-Tanks (Hauptassistent) zu identifizieren. Einige Gilden weisen jedoch die Haupttankrolle sowohl Haupttanks als auch Off-Tanks zu und weisen Heilern die Rolle des Hauptassistenten zu.

Durch eine separate Einstellung für beide Rollen können Paladin-Klassenleiter oder Schlachtzugsführer beispielsweise den größeren Segen der Erlösung aus Tankklassen entfernen oder wenn Druiden- oder Paladin-Heiler mit der Haupthilfe-Rolle markiert sind, die sie einrichten könnten Normaler Segen der Weisheit im Vergleich zu größerem Segen der Macht, der es ermöglichen würde, größeren Segen der Macht für DPS-spezifizierte Druiden und Paladine und normalen Segen der Weisheit heilenden spezifizierten Druiden und Paladinen zuzuweisen.
]=]
L["MAINTANKGBUFFDP"] = "Druiden / Paladine überschreiben ..."
L["MAINTANKGBUFFDP_DESC"] = "Wählen Sie die Zuweisung für den größeren Segen aus, die Sie auf dem Haupttank überschreiben möchten: Druiden / Paladine."
L["MAINTANKGBUFFW"] = "Krieger überschreiben ..."
L["MAINTANKGBUFFW_DESC"] = "Wählen Sie die Aufgabe Größerer Segen aus, die Sie auf Haupttank: Krieger überschreiben möchten."
L["MAINTANKNBUFFDP"] = "... mit Normal ..."
L["MAINTANKNBUFFDP_DESC"] = "Wählen Sie den normalen Segen aus, mit dem Sie den Haupttank überschreiben möchten: Druiden / Paladine."
L["MAINTANKNBUFFW"] = "... mit Normal ..."
L["MAINTANKNBUFFW_DESC"] = "Wählen Sie den normalen Segen aus, mit dem Sie den Hauptpanzer: Krieger überschreiben möchten."
L["MINIMAPICON"] = [=[|cffffffff [Linksklick]|r Segenzuweisungen öffnen
|cffffffff [Rechtsklick]|r Optionen öffnen]=]
L["NONE"] = "Keine"
L["NONE_BUFFED"] = "Keine gepuffert"
L["OPTIONS"] = "Optionen"
L["OPTIONS_DESC"] = [=[Öffnet die PallyPower
Addon Optionsfeld.]=]
L["PARTIALLY_BUFFED"] = "Teilweise poliert"
L["PLAYERBTNS"] = "Player Buttons"
L["PLAYERBTNS_DESC"] = "Wenn diese Option deaktiviert ist, werden die Pop-Out-Schaltflächen für einzelne Spieler nicht mehr angezeigt und Sie können im Kampf keine normalen Segnungen mehr anwenden."
L["PP_CLEAR"] = "Löschen"
L["PP_CLEAR_DESC"] = [=[Löscht allen Segen
Aufgaben für sich selbst,
Party und Raid Paladins.]=]
L["PP_COLOR"] = "Ändere die Statusfarben der Buff-Schaltflächen"
L["PP_LOOKS"] = "Ändere das Aussehen von PallyPower"
L["PP_MAIN"] = "Haupt-PallyPower-Einstellungen"
L["PP_NAME"] = "PallyPower Classic"
L["PP_RAS1"] = "--- Paladin-Zuweisungen ---"
L["PP_RAS2"] = "--- Ende der Aufgaben ---"
L["PP_RAS3"] = "WARNUNG: Es sind mehr als 5 Paladine im Schlachtzug."
L["PP_RAS4"] = "Panzer, Segen der Erlösung manuell ausschalten!"
L["PP_REFRESH"] = "Aktualisieren"
L["PP_REFRESH_DESC"] = [=[Aktualisiert allen Segen
Aufgaben, Talente und
Symbol der Könige unter sich selbst,
Party und Raid Paladins.]=]
L["PP_RESET"] = "Nur für den Fall, dass Sie es vermasseln"
L["PPMAINTANK"] = "Haupttank automatisch polieren"
L["PPMAINTANK_DESC"] = "Wenn Sie diese Option aktivieren, überschreibt PallyPower automatisch einen größeren Segen mit einem normalen Segen für Spieler, die mit der Rolle |cffffd200Main Tank|r im Blizzard Raid Panel gekennzeichnet sind. Dies ist nützlich, um zu vermeiden, dass der |cffffd200Main Tank|r gesegnet wird Rolle mit einem größeren Segen der Erlösung. "
L["RAID"] = "Raid"
L["RAID_DESC"] = "Nur Raid-Optionen"
L["REPORTCHANNEL"] = "Blessings Report Channel"
L["REPORTCHANNEL_DESC"] = [=[Stellen Sie den gewünschten Kanal für die Übertragung des Bliessings-Berichts ein auf:

|cffffd200 [Keine]|r Wählt den Kanal basierend auf der Gruppenzusammensetzung aus. (Party / Raid)

|cffffd200 [Kanalliste]|r Eine automatisch aufgefüllte Kanalliste basierend auf den Kanälen, denen der Player beigetreten ist. Standardkanäle wie Handel, Allgemein usw. werden automatisch aus der Liste herausgefiltert.

|cffffff00Hinweis: Wenn Sie Ihre Kanalreihenfolge ändern, müssen Sie Ihre Benutzeroberfläche neu laden und überprüfen, ob sie auf den richtigen Kanal sendet.|r]=]
L["RESET"] = "Frames zurücksetzen"
L["RESET_DESC"] = "Alle PallyPower-Frames zurück in die Mitte setzen"
L["RESIZEGRIP"] = [=[Zum Klicken in der linken Maustaste gedrückt halten, um die Größe zu ändern
Rechtsklick setzt Standardgröße zurück]=]
L["RFM"] = "Gerechte Wut"
L["RFM_DESC"] = "[Aktivieren / Deaktivieren] Gerechte Wut"
L["SALVCOMBAT"] = "Salv im Kampf"
L["SALVCOMBAT_DESC"] = [=[Wenn Sie diese Option aktivieren, können Sie Krieger, Druiden und Paladine im Kampf mit größerem Segen der Erlösung stärken.

|cffffff00Hinweis: Diese Einstellung gilt NUR für Schlachtzugsgruppen, da in unserer aktuellen Kultur viele Panzer Skripte / Addons verwenden, um Buffs abzubrechen, die nur im Kampf ausgeführt werden können. Diese Option ist im Grunde genommen eine Sicherheit, um zu verhindern, dass ein Panzer während des Kampfes versehentlich mit Rettung poliert wird.|r]=]
L["SEAL"] = "Seal Button"
L["SEAL_DESC"] = "[|cffffd200Enable|r / |cffffd200Disable|r] Mit der Siegelschaltfläche können Sie Gerechte Wut aktivieren / deaktivieren oder das Siegel auswählen, das Sie verfolgen möchten."
L["SEALBTN"] = "Versiegelungsknopf"
L["SEALBTN_DESC"] = "[Aktivieren / Deaktivieren] Die Aura-Schaltfläche"
L["SEALTRACKER"] = "Seal Tracker"
L["SEALTRACKER_DESC"] = "Wählen Sie das Siegel aus, das Sie verfolgen möchten"
L["SETTINGS"] = "Einstellungen"
L["SETTINGS_DESC"] = "Globale Einstellungen ändern"
L["SETTINGSBUFF"] = "Was mit PallyPower zu polieren ist"
L["SHOWMINIMAPICON"] = "Minimap-Symbol anzeigen"
L["SHOWMINIMAPICON_DESC"] = "Minimap-Symbol [Einblenden / Ausblenden]"
L["SHOWPETS"] = "Haustiere zeigen"
L["SHOWPETS_DESC"] = [=[Wenn Sie diese Option aktivieren, werden Haustiere unter ihrer eigenen Klasse angezeigt.

|cffffff00Hinweis: Aufgrund der Funktionsweise von Greater Blessings und der Klassifizierung von Haustieren müssen Haustiere separat poliert werden. Außerdem werden Warlock-Imps automatisch ausgeblendet, sofern die Phasenverschiebung nicht deaktiviert ist.|r]=]
L["SHOWTIPS"] = "Tooltips anzeigen"
L["SHOWTIPS_DESC"] = "[Ein- / Ausblenden] Die PallyPower-Tooltips"
L["SKIN"] = "Hintergrundtexturen"
L["SKIN_DESC"] = "Ändern der Schaltflächenhintergrundtexturen"
L["SMARTBUFF"] = "Smart Buffs"
L["SMARTBUFF_DESC"] = "Wenn Sie diese Option aktivieren, dürfen Sie Kriegern oder Schurken keinen Segen der Weisheit und Magiern, Hexenmeistern und Jägern den Segen der Macht zuweisen."
L["USEPARTY"] = "In Party verwenden"
L["USEPARTY_DESC"] = "[Aktivieren / Deaktivieren] PallyPower in Party"
L["USESOLO"] = "Verwenden, wenn Solo"
L["USESOLO_DESC"] = "[Aktivieren / Deaktivieren] PallyPower im Solo"
L["VERDOWNLEFT"] = "Vertikal nach unten | Links"
L["VERDOWNRIGHT"] = "Vertikal nach unten | Rechts"
L["VERUPLEFT"] = "Vertikal nach oben | links"
L["VERUPRIGHT"] = "Vertikal nach oben|rechts"
L["WAIT"] = "Warte auf Spieler"
L["WAIT_DESC"] = "Wenn diese Option aktiviert ist, werden mit dem Auto Buff Button und dem Class Buff Button kein größerer Segen automatisch gepuffert, wenn sich die Empfänger nicht im Paladin-Bereich (100yds) befinden. Diese Bereichsprüfung schließt AFK, Dead aus und Offline-Spieler. "

