if GetLocale() == "deDE" then
    GroupCalendar_cTitle = "Group Calendar v%s";

    GroupCalendar_cSun = "So";
    GroupCalendar_cMon = "Mo";
    GroupCalendar_cTue = "Di";
    GroupCalendar_cWed = "Mi";
    GroupCalendar_cThu = "Do";
    GroupCalendar_cFri = "Fr";
    GroupCalendar_cSat = "Sa";

	GroupCalendar_cSunday = "Sonntag";
	GroupCalendar_cMonday = "Montag";
	GroupCalendar_cTuesday = "Dienstag";
	GroupCalendar_cWednesday = "Mittwoch";
	GroupCalendar_cThursday = "Donnerstag";
	GroupCalendar_cFriday = "Freitag";
	GroupCalendar_cSaturday = "Samstag";
	
	GroupCalendar_Settings_ShowDebug = "Zeige Debug Meldung";
	GroupCalendar_Settings_ShowDebugTip = "Zeige/Verstecke Debug Meldung.";
	GroupCalendar_Settings_ShowMinimap = "Zeige Minimap";
	GroupCalendar_Settings_ShowMinimapTip = "Zeige/Verstecke Minimap Icon.";
	GroupCalendar_Settings_MondayFirstDay = "Montag ist erster Wochentag";
	GroupCalendar_Settings_MondayFirstDayTip = "Zeige Montag im Kalenderals den ersten Wochentag an.";
	GroupCalendar_Settings_Use24HrTime = "Verwenden Sie die 24-Stunden-Zeit";
	GroupCalendar_Settings_Use24HrTimeTip = "Verwenden Sie die 24-Stunden-Zeit";

    GroupCalendar_cSelfWillAttend = "Teilnahme";
	CalendarEventEditor_cYes = "Ja";
	CalendarEventEditor_cNo = "Nein";

    GroupCalendar_cMonthNames = {"Januar", "Februar", "M\195\164rz", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"};
	GroupCalendar_cDayOfWeekNames = {GroupCalendar_cSunday, GroupCalendar_cMonday, GroupCalendar_cTuesday, GroupCalendar_cWednesday, GroupCalendar_cThursday, GroupCalendar_cFriday, GroupCalendar_cSaturday};
    
    GroupCalendar_cLoadMessage = "GroupCalendar geladen. Gib /calendar zur Anzeige ein";
    GroupCalendar_cInitializingGuilded = "GroupCalendar: Initialisiere Einstellungen f\195\188r Gildenmitglieder";
    GroupCalendar_cInitializingUnguilded = "GroupCalendar: Initialisiere Einstellungen f\195\188r andere Spieler";
    GroupCalendar_cLocalTimeNote = "(%s lokal)";

    GroupCalendar_cOptions = "Setup...";

    GroupCalendar_cCalendar = "Kalender";
    GroupCalendar_cChannel = "Channel";
    GroupCalendar_cTrust = "Berechtigungen";
    GroupCalendar_cAbout = "\195\156ber";

	GroupCalendar_cUseServerDateTime = "Benutze Server-Zeitformat";
	GroupCalendar_cUseServerDateTimeDescription = "Aktivieren um Events im Server Zeitformat anzuzeigen. Deaktivieren um Events im lokalen Zeitformat anzuzeigen";
	    
    GroupCalendar_cChannelStatus =
    {
		Starting = {mText = "Status: Beginnend", mColor = {r = 1, g = 1, b = 0.3}},
		Synching = {mText = "Status: Synchronisieren", mColor = {r = 0.3, g = 1, b = 0.3}},
        Connected = {mText = "Status: In Verbindung gebracht", mColor = {r = 0.3, g = 1, b = 0.3}},
        Disconnected = {mText = "Status: Getrennt", mColor = {r = 1, g = 0.2, b = 0.4}},
        Initializing = {mText = "Status: Initialisierung", mColor = {r = 1, g = 1, b = 0.3}},
		Error = {mText = "Fehler: %s", mColor = {r = 1, g = 0.2, b = 0.4}},
    };

    GroupCalendar_cConnected = "Verbunden";
    GroupCalendar_cDisconnected = "Getrennt";
	GroupCalendar_cTooManyChannels = "Man kann immer nur in h\195\182chstens 10 Channels gleichzeitig sein";
	GroupCalendar_cJoinChannelFailed = "Fehler beim Betreten des Channels";
	GroupCalendar_cWrongPassword = "Falsches Passwort";
	GroupCalendar_cAutoConfigNotFound = "Keine Daten in Gilden Notizen gefunden";
	GroupCalendar_cErrorAccessingNote = "Fehler beim empfangen der Konfigurationsdaten";

    GroupCalendar_cTrustConfigTitle = "Berechtigungen Setup";
    GroupCalendar_cTrustConfigDescription = "Vertrauen bestimmt, wer Ereignisse erstellen kann. Nur der Gildenleiter kann diese Einstellungen ändern.";
    GroupCalendar_cTrustGroupLabel = "Berechtigt:";
    GroupCalendar_cEvent = "Event";
    GroupCalendar_cAttendance = "Anmeldungen";

    GroupCalendar_cAboutTitle = "\195\156ber GroupCalendar";
    GroupCalendar_cTitleVersion = "GroupCalendar v"..gGroupCalendar_VersionString;
    GroupCalendar_cAuthor = "Klassischer Autor: Magne - Remulos".."\n".."Vanille-Autor: Baylord - Thunderlord";
    GroupCalendar_cTestersTitle = "Testerinnen";
    GroupCalendar_cSpecialThanksTitle = "Besonderer Dank";
    GroupCalendar_cRebuildDatabase = "Datenbank erneuern";
    GroupCalendar_cRebuildDatabaseDescription = "Erneuert den Event-Datenbestand deines Charakters.  Dies kann Probleme beheben, wenn andere Spieler nicht alle deine Events sehen k\195\182nnen. Es besteht ein geringes Risiko das einige Anmeldungs-Best\195\164tigungen verloren gehen k\195\182nnen.";

    GroupCalendar_cTrustGroups =
    {
        "Jeder mit Zugriff auf den Daten Channel",
        "Alle Gildenmitglieder",
        "Nur Spieler aus der Berechtigungs Liste"
    };

    GroupCalendar_cTrustAnyone = "Berechtigt jeden mit Zugriff auf den Daten Channel";
    GroupCalendar_cTrustGuildies = "Berechtigt andere Mitglieder deiner Gilde";
    GroupCalendar_cTrustMinRank = "Mindestrang:";
    GroupCalendar_cTrustNobody = "Berechtigt nur Spieler die in der unteren Liste eingetragen sind";
    GroupCalendar_cTrustedPlayers = "Berechtigte Spieler";
    GroupCalendar_cExcludedPlayers = "Ausgeschlossene Spieler"
    GroupCalendar_cPlayerName = "Spieler Name:";
    GroupCalendar_cAddTrusted = "Berechtigen";
    GroupCalendar_cRemoveTrusted = "Entfernen";
    GroupCalendar_cAddExcluded = "Ausschlie\195\159en";

    CalendarEventViewer_cTitle = "Event Details";
    CalendarEventViewer_cDone = "Fertig";

    CalendarEventViewer_cLevelRangeFormat = "Level %i bis %i";
    CalendarEventViewer_cMinLevelFormat = "Ab Level %i";
    CalendarEventViewer_cMaxLevelFormat = "Bis Level %i";
    CalendarEventViewer_cAllLevels = "Alle Level";
    CalendarEventViewer_cSingleLevel = "Nur Level %i";

    CalendarEventViewer_cYes = "Ja - Ich werde teilnehmen";
    CalendarEventViewer_cNo = "Nein - Ich werde nicht teilnehmen";

    CalendarEventViewer_cResponseMessage =
    {
        "Status: Nichts gesendet",
        "Status: Warte auf Best\195\164tigung",
        "Status: Best\195\164tigung - Akzeptiert",
        "Status: Best\195\164tigung - StandBy",
        "Status: Best\195\164tigung - Abgelehnt",
		"Status: Banned from event",
    };

    CalendarEventEditorFrame_cTitle = "Event Neu/Bearbeiten";
    CalendarEventEditor_cDone = "Fertig";
    CalendarEventEditor_cDelete = "L\195\182schen";

    CalendarEventEditor_cConfirmDeleteMsg = "L\195\182schen \"%s\"?"

    -- Event names

	GroupCalendar_cGeneralEventGroup = "Allgemein";
	GroupCalendar_cRaidEventGroup = "Raids";
	GroupCalendar_cDungeonEventGroup = "Dungeons";
	GroupCalendar_cBattlegroundEventGroup = "Schlachtfelder";

    GroupCalendar_cMeetingEventName = "Treffen";
    GroupCalendar_cBirthdayEventName = "Geburtstag";
	GroupCalendar_cRoleplayEventName = "Rollenspiel";
	GroupCalendar_cActivityEventName = "Veranstaltung";

	GroupCalendar_cAQREventName = "Ruinen von Ahn'Qiraj";
	GroupCalendar_cAQTEventName = "Tempel von Ahn'Qiraj";
    GroupCalendar_cBFDEventName = "Blackfathom Tiefen";
    GroupCalendar_cBRDEventName = "Blackrocktiefen";
    GroupCalendar_cUBRSEventName = "Obere Blackrockspitze";
    GroupCalendar_cLBRSEventName = "Untere Blackrockspitze";
    GroupCalendar_cBWLEventName = "Pechschwingenhort";
    GroupCalendar_cDeadminesEventName = "Todesminen";
    GroupCalendar_cDMEventName = "D\195\188sterbruch";
    GroupCalendar_cGnomerEventName = "Gnomeregan";
    GroupCalendar_cMaraEventName = "Maraudon";
    GroupCalendar_cMCEventName = "Geschmolzener Kern";
    GroupCalendar_cOnyxiaEventName = "Onyxias Hort";
    GroupCalendar_cRFCEventName = "Ragefireabgrund";
    GroupCalendar_cRFDEventName = "H\195\188gel von Razorfen";
    GroupCalendar_cRFKEventName = "Kral von Razorfen";
    GroupCalendar_cSMEventName = "Scharlachrotes Kloster";
    GroupCalendar_cScholoEventName = "Scholomance";
    GroupCalendar_cSFKEventName = "Burg Shadowfang";
    GroupCalendar_cStockadesEventName = "Verlies";
    GroupCalendar_cStrathEventName = "Stratholme";
    GroupCalendar_cSTEventName = "Versunkener Tempel";
    GroupCalendar_cUldEventName = "Uldaman";
    GroupCalendar_cWCEventName = "H\195\182hlen des Wehklagens";
    GroupCalendar_cZFEventName = "Zul'Farrak";
    GroupCalendar_cZGEventName = "Zul'Gurub";
	GroupCalendar_cNaxxEventName = "Naxxramas";

	GroupCalendar_cPvPEventName = "General PvP";
	GroupCalendar_cABEventName = "Arathi Becken";
	GroupCalendar_cAVEventName = "Alterac Tal";
	GroupCalendar_cWSGEventName = "Warsong Schlucht";
	
	GroupCalendar_cZGResetEventName = "Zul'Gurub Resets";
	GroupCalendar_cMCResetEventName = "Molten Core Resets";
	GroupCalendar_cOnyxiaResetEventName = "Onyxia Resets";
	GroupCalendar_cBWLResetEventName = "Blackwing Lair Resets";
	GroupCalendar_cAQRResetEventName = "Ahn'Qiraj Ruins Resets";
	GroupCalendar_cAQTResetEventName = "Ahn'Qiraj Temple Resets";
	GroupCalendar_cNaxxResetEventName = "Naxxramas Resets";

	GroupCalendar_cTransmuteCooldownEventName = "Transmute Available";
	GroupCalendar_cSaltShakerCooldownEventName = "Salt Shaker Available";
	GroupCalendar_cMoonclothCooldownEventName = "Mooncloth Available";
	GroupCalendar_cSnowmasterCooldownEventName = "SnowMaster 9000 Available";

	GroupCalendar_cPersonalEventOwner = "Private";

	GroupCalendar_cRaidInfoMCName = GroupCalendar_cMCEventName;
	GroupCalendar_cRaidInfoOnyxiaName = GroupCalendar_cOnyxiaEventName;
	GroupCalendar_cRaidInfoZGName = GroupCalendar_cZGEventName;
	GroupCalendar_cRaidInfoBWLName = GroupCalendar_cBWLEventName;
	GroupCalendar_cRaidInfoAQRName = GroupCalendar_cAQREventName;
	GroupCalendar_cRaidInfoAQTName = GroupCalendar_cAQTEventName;
	GroupCalendar_cRaidInfoNaxxName = GroupCalendar_cNaxxEventName;
	
    -- Race names

    GroupCalendar_cDwarfRaceName = "Zwerg";
    GroupCalendar_cGnomeRaceName = "Gnom";
    GroupCalendar_cHumanRaceName = "Mensch";
    GroupCalendar_cNightElfRaceName = "Nachtelf";
    GroupCalendar_cOrcRaceName = "Ork";
    GroupCalendar_cTaurenRaceName = "Tauren";
    GroupCalendar_cTrollRaceName = "Troll";
    GroupCalendar_cUndeadRaceName = "Untote";
    GroupCalendar_cBloodElfRaceName = "Blutelf";
    GroupCalendar_cDraeneiRaceName = "Draenei";

    -- Class names

    GroupCalendar_cDruidClassName = "Druide";
    GroupCalendar_cHunterClassName = "J\195\164ger";
    GroupCalendar_cMageClassName = "Magier";
    GroupCalendar_cPaladinClassName = "Paladin";
    GroupCalendar_cPriestClassName = "Priester";
    GroupCalendar_cRogueClassName = "Schurke";
    GroupCalendar_cShamanClassName = "Schamane";
    GroupCalendar_cWarlockClassName = "Hexenmeister";
    GroupCalendar_cWarriorClassName = "Krieger";

    -- Plural forms of class names

    GroupCalendar_cDruidsClassName = "Druiden";
    GroupCalendar_cHuntersClassName = "J\195\164ger";
    GroupCalendar_cMagesClassName = "Magier";
    GroupCalendar_cPaladinsClassName = "Paladine";
    GroupCalendar_cPriestsClassName = "Priester";
    GroupCalendar_cRoguesClassName = "Schurken";
    GroupCalendar_cShamansClassName = "Schamanen";
    GroupCalendar_cWarlocksClassName = "Hexenmeister";
    GroupCalendar_cWarriorsClassName = "Krieger";

    -- ClassColorNames are the indices for the RAID_CLASS_COLORS array found in FrameXML\Fonts.xml
    -- in the English version of WoW these are simply the class names in caps, I don't know if that's
    -- true of other languages so I'm putting them here in case they need to be localized

    GroupCalendar_cDruidClassColorName = "DRUID";
    GroupCalendar_cHunterClassColorName = "HUNTER";
    GroupCalendar_cMageClassColorName = "MAGE";
    GroupCalendar_cPaladinClassColorName = "PALADIN";
    GroupCalendar_cPriestClassColorName = "PRIEST";
    GroupCalendar_cRogueClassColorName = "ROGUE";
    GroupCalendar_cShamanClassColorName = "SHAMAN";
    GroupCalendar_cWarlockClassColorName = "WARLOCK";
    GroupCalendar_cWarriorClassColorName = "WARRIOR";

    -- Label forms of the class names for the attendance panel.  Usually just the plural
    -- form of the name followed by a colon

    GroupCalendar_cDruidsLabel = GroupCalendar_cDruidsClassName..":";
    GroupCalendar_cHuntersLabel = GroupCalendar_cHuntersClassName..":";
    GroupCalendar_cMagesLabel = GroupCalendar_cMagesClassName..":";
    GroupCalendar_cPaladinsLabel = GroupCalendar_cPaladinsClassName..":";
    GroupCalendar_cPriestsLabel = GroupCalendar_cPriestsClassName..":";
    GroupCalendar_cRoguesLabel = GroupCalendar_cRoguesClassName..":";
    GroupCalendar_cShamansLabel = GroupCalendar_cShamansClassName..":";
    GroupCalendar_cWarlocksLabel = GroupCalendar_cWarlocksClassName..":";
    GroupCalendar_cWarriorsLabel = GroupCalendar_cWarriorsClassName..":";

    GroupCalendar_cTimeLabel = "Uhrzeit:";
    GroupCalendar_cDurationLabel = "Dauer:";
    GroupCalendar_cEventLabel = "Event:";
    GroupCalendar_cTitleLabel = "Titel:";
    GroupCalendar_cLevelsLabel = "Level:";
    GroupCalendar_cLevelRangeSeparator = "bis";
    GroupCalendar_cDescriptionLabel = "Beschreibung:";
    GroupCalendar_cCommentLabel = "Kommentar:";

    CalendarEditor_cNewEvent = "Neues Event...";
    CalendarEditor_cEventsTitle = "Events";

	GroupCalendar_cRankMinLabel = "Gildenrang:";
	CalendarEventEditor_cNotRightRankMsg = "Dein Gildenrang ist zu niedrig um das Ereigniss anzuzeigen";
	CalendarEventEditor_cNotTrustedMsg = "Ereignisse können aufgrund von Vertrauenseinstellungen nicht erstellt werden";
	CalendarEventEditor_cOk = "in Ordnung";

    CalendarEventEditor_cNotAttending = "Nicht angemeldet";
    CalendarEventEditor_cConfirmed = "Best\195\164tigt";
    CalendarEventEditor_cDeclined = "Abgelehnt";
    CalendarEventEditor_cStandby = "Auf Warteliste";
	CalendarEventEditor_cPending = "Wartet...";
    CalendarEventEditor_cUnknownStatus = "Unbekannt %s";

    GroupCalendar_cChannelNameLabel = "Channel Name:";
    GroupCalendar_cPasswordLabel = "Passwort:";

    GroupCalendar_cTimeRangeFormat = "%s bis %s";
    
	GroupCalendar_cPluralMinutesFormat = "%d Minuten";
	GroupCalendar_cSingularHourFormat = "%d Stunde";
	GroupCalendar_cPluralHourFormat = "%d Stunden";
	GroupCalendar_cSingularHourPluralMinutes = "%d Stunde %d Minuten";
	GroupCalendar_cPluralHourPluralMinutes = "%d Stunden %d Minuten";
	
	GroupCalendar_cLongDateFormat = "$day. $month $year";
	GroupCalendar_cLongDateFormatWithDayOfWeek = "$dow $day. $month $year";
	
	GroupCalendar_cNotAttending = "Abgemeldet";
	GroupCalendar_cAttending = "Angemeldet";
	GroupCalendar_cPendingApproval = "Anmeldung l\195\164uft";

	GroupCalendar_cQuestAttendanceNameFormat = "$name ($role $level $race)";
	GroupCalendar_cMeetingAttendanceNameFormat = "$name ($role $level $class)";

	GroupCalendar_cNumAttendeesFormat = "%d Anmeldungen";
	
	BINDING_HEADER_GROUPCALENDAR_TITLE = "GroupCalendar";
	BINDING_NAME_GROUPCALENDAR_TOGGLE = "GroupCalendar an/aus";

	-- Tradeskill cooldown items
	
	GroupCalendar_cHerbalismSkillName = "Kr\195\164uterkunde";
	GroupCalendar_cAlchemySkillName = "Alchimie";
	GroupCalendar_cEnchantingSkillName = "Verzauberkunst";
	GroupCalendar_cLeatherworkingSkillName = "Lederverarbeitung";
	GroupCalendar_cSkinningSkillName = "K\195\188rschnerei";
	GroupCalendar_cTailoringSkillName = "Schneiderei";
	GroupCalendar_cMiningSkillName = "Bergbau";
	GroupCalendar_cBlacksmithingSkillName = "Schmiedekunst";
	GroupCalendar_cEngineeringSkillName = "Ingenieurskunst";
	
	GroupCalendar_cTransmuteMithrilToTruesilver = "Transmutieren: Mithril in Echtsilber";
	GroupCalendar_cTransmuteIronToGold = "Transmutieren: Eisen in Gold";
	GroupCalendar_cTransmuteLifeToEarth = "Transmutieren: Leben zu Erde";
	GroupCalendar_cTransmuteWaterToUndeath = "Transmutieren: Wasser zu Untod";
	GroupCalendar_cTransmuteWaterToAir = "Transmutieren: Wasser zu Luft";
	GroupCalendar_cTransmuteUndeathToWater = "Transmutieren: Untod zu Wasser";
	GroupCalendar_cTransmuteFireToEarth = "Transmutieren: Feuer zu Erde";
	GroupCalendar_cTransmuteEarthToLife = "Transmutieren: Erde zu Leben";
	GroupCalendar_cTransmuteEarthToWater = "Transmutieren: Erde zu Wasser";
	GroupCalendar_cTransmuteAirToFire = "Transmutieren: Luft zu Feuer";
	GroupCalendar_cTransmuteArcanite = "Transmutieren: Arkanit";
	GroupCalendar_cMooncloth = "Mondstoff";

	GroupCalendar_cCharactersLabel = "Character:";
	GroupCalendar_cRoleLabel = "Rolle:";
	GroupCalendar_cTankLabel = "Tank";
	GroupCalendar_cHealerLabel = "Heiler";
	GroupCalendar_cDpsLabel = "DPS";
	GroupCalendar_cUnknownRoleLabel = "Unbekannt";

	GroupCalendar_cConfirmed = "Angenommen";
	GroupCalendar_cStandby = "Standby";
	GroupCalendar_cDeclined = "Abgelehnt";
	GroupCalendar_cRemove = "Entfernen";
	GroupCalendar_cEditPlayer = "Spieler bearbeiten...";
	GroupCalendar_cInviteNow = "In Gruppe einladen";
	GroupCalendar_cStatus = "Status";
	GroupCalendar_cAddPlayerEllipses = "Spieler hinzufügen...";
	GroupCalendar_cAll = "Alle";
	GroupCalendar_cClearSelected = "Auswahl leern";

	GroupCalendar_cAddPlayer = "Spieler hinzufügen";
	GroupCalendar_cPlayerLevel = "Level:";
	GroupCalendar_cPlayerClassLabel = "Class:";
	GroupCalendar_cPlayerRaceLabel = "Rasse:";
	GroupCalendar_cPlayerStatusLabel = "Status:";
	GroupCalendar_cRankLabel = "Gildenrang:";
	GroupCalendar_cGuildLabel = "Gilde:";
	GroupCalendar_cSave = "Speichern";
	GroupCalendar_cLastWhisper = "Letztet Flüsternachricht:";
	GroupCalendar_cReplyWhisper = "Zurückflüstern:";

	GroupCalendar_cUnknown = "Unbekannt";
	GroupCalendar_cAutoConfirmationTitle = "Automatische Bestätigung";
	GroupCalendar_cEnableAutoConfirm = "Aktiviere automatische Bestätigung";
	GroupCalendar_cMinLabel = "min";
	GroupCalendar_cMaxLabel = "max";

	GroupCalendar_cAddPlayerTitle = "Hinzufügen...";
	GroupCalendar_cAutoConfirmButtonTitle = "Einstellungen...";

	GroupCalendar_cClassLimitDescription = "Verwende die unteren Felder um die minimale und maximale Anzahl an Spieler für jede Klasse festzulegen. Klassen, die die Mindestanzahl noch nicht erfüllt haben, werden bevorzugt befüllt, restliche Plätze werden in der Reihenfolge ihrer Antwort befüllt bis das Maximum erreicht ist.";

	GroupCalendar_cViewByDate = "Nach Datum";
	GroupCalendar_cViewByRank = "Nach Rang";
	GroupCalendar_cViewByName = "Nach Name";
	GroupCalendar_cViewByStatus = "Nach Status";
	GroupCalendar_cViewByClass = "Nach Klasse";
	GroupCalendar_cViewByClassRank = "Nach Klasse und Rang";

	GroupCalendar_cMaxPartySizeLabel = "Maximale Gruppengröße:";
	GroupCalendar_cMinPartySizeLabel = "Minimale Gruppengröße:";
	GroupCalendar_cNoMinimum = "Kein Minimum";
	GroupCalendar_cNoMaximum = "Kein Maximum";
	GroupCalendar_cPartySizeFormat = "%d Spieler";

	GroupCalendar_cInviteButtonTitle = "Auswahl einladen";
	GroupCalendar_cAutoSelectButtonTitle = "Spieler auswählen...";
	GroupCalendar_cAutoSelectWindowTitle = "Spieler auswählen";

	GroupCalendar_cNoSelection = "Keine Spieler ausgewählt";
	GroupCalendar_cSingleSelection = "1 Spieler auswgewählt";
	GroupCalendar_cMultiSelection = "%d Spieler ausgewählt";

	GroupCalendar_cInviteNeedSelectionStatus = "Spieler für Einladung auswählen";
	GroupCalendar_cInviteReadyStatus = "Bereit für Einladung";
	GroupCalendar_cInviteInitialInvitesStatus = "Sende erste Einladung";
	GroupCalendar_cInviteAwaitingAcceptanceStatus = "Warte auf Annahme";
	GroupCalendar_cInviteConvertingToRaidStatus = "In Raid umwandeln";
	GroupCalendar_cInviteInvitingStatus = "Sende Einladungen";
	GroupCalendar_cInviteCompleteStatus = "Einladung komplett";
	GroupCalendar_cInviteReadyToRefillStatus = "Offene Posten befüllen";
	GroupCalendar_cInviteNoMoreAvailableStatus = "Keine weiteren Spieler vorhanden um die Gruppe zu befüllen";
	GroupCalendar_cRaidFull = "Raid voll";

	GroupCalendar_cInviteWhisperFormat = "[GroupCalendar] Du wurdest zu Event '%s' eingeladen.  Bitte nimm die Einladung an, wenn Du an diesem Event teilnehmen willst.";
	GroupCalendar_cAlreadyGroupedWhisper = "[GroupCalendar] Du bist bereits in einer Gruppe. Bitte melde Dich per /w an mich, wenn Du deine Gruppe verlassen hast.";
	GroupCalendar_cAlreadyGroupedSysMsg = "(.+) ist bereits in einer Gruppe!";
	GroupCalendar_cInviteDeclinedSysMsg = "(.+) hat die Gruppeneinladung abgelehnt.";
	GroupCalendar_cNoSuchPlayerSysMsg = "Kein Spieler mit dem Namen '(.+)' aktiv.";

	GroupCalendar_cJoinedGroupStatus = "Beigetreten";
	GropuCalendar_cInvitedGroupStatus = "Eingeladen";
	GropuCalendar_cReadyGroupStatus = "Bereit";
	GroupCalendar_cGroupedGroupStatus = "In einer anderen Gruppe";
	GroupCalendar_cStandbyGroupStatus = "Standby";
	GroupCalendar_cDeclinedGroupStatus = "Abgelehnte Einladungen";
	GroupCalendar_cOfflineGroupStatus = "Offline";
	GroupCalendar_cLeftGroupStatus = "Gruppe verlassen";

	GroupCalendar_cPriorityLabel = "Priorität:";
	GroupCalendar_cPriorityDate = "Datum";
	GroupCalendar_cPriorityRank = "Rang";
	GroupCalendar_cPriorityClass = "Klasse";

	GroupCalendar_cConfrimDeleteRSVP = "Spieler %s von diesem Event entfernen? Er kann nicht selbstständig beitreten, es sei denn Du fügst ihn manuell wieder hinzu unless.";

	GroupCalendar_cConfirmSelfUpdateMsg = "%s";
	GroupCalendar_cConfirmSelfUpdateParamFormat = "Eine neuere Version der Events für $mUserName ist von $mSender verfügbar. Willst Du Deine Events auf eine neuere Version aktualisieren? Falls ja, gehen alle von dir (seit dem letzten Login) hinzugefügten oder geänderten Events verloren.";
	GroupCalendar_cConfirmSelfRSVPUpdateParamFormat = "Eine neuere Version der Teilnehmerliste für $mUserName ist von $mSender verfügbar. Willst Du deine Teilnehmerliste wirklich aktualisieren? Falls ja, gehen alle (seit dem letzten Login) von Dir gemachten Änderungen  an unbestätigten Anmeldungen verloren.";
	GroupCalendar_cUpdate = "Update";

	GroupCalendar_cConfirmClearWhispers = "Letzten Flüsternachrichten löschen?";
	GroupCalendar_cClear = "Löschen";
	
	CalendarDatabases_cTitle = "Group Calendar Versionen";
	CalendarDatabases_cRefresh = "Neu laden";
	CalendarDatabases_cRefreshDescription = "Frage die Versionen der aktiven Spieler ab. Es kann einige Minuten in Anspruch nehmen die Versionsnummern zu updaten. Updates, die erhalten werden, während self Windows geschlossen ist, werden aufgezeichnet und können zu einen späteren Zeitpunkt angesehen werden.";

	GroupCalendar_cVersionFormat = "Group Calendar v%s";
	GroupCalendar_cShortVersionFormat = "v%s";
	GroupCalendar_cVersionUpdatedFormat = "Zum Zeitpunkt: %s %s (Lokale Zeit)";
	GroupCalendar_cVersionUpdatedUnknown = "Status \"Datum/Version/Info zuletzt gesehen\" ist unbekannt";

	GroupCalendar_cToggleVersionsTitle = "Zeige Spieler Versionen";
	GroupCalendar_cToggleVersionsDescription = "Zeigt die Versionen von Group Calendar von anderen Spielern";

	GroupCalendar_cChangesDelayedMessage = "Group Calendar: Änderungen, die während der Synchronisation mit dem Netzwerk gemacht wurden, werden erst nach dem Abschluss gesendet.";

	GroupCalendar_cConfirmKillMsg = "Sicher die Events von %s aus dem Netzwerk zu erzwingen?";
	GroupCalendar_cKill = "Kill";

	GroupCalendar_cNotAnOfficerError = "GroupCalendar: Nur Gilden-Offiziere dürfen das tun!";
	GroupCalendar_cUserNameExpected = "GroupCalendar: Erwarte Username";
	GroupCalendar_cDatabaseNotFoundError = "GroupCalendar: Datenbank für %s nicht gefunden.";
	GroupCalendar_cCantKillGuildieError = "GroupCalendar: Kann Spieler aus Deiner Gilde nicht entfernen";
end
