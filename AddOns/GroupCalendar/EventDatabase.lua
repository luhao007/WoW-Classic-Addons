GroupCalendar_cDatabaseFormat = 12;

gGroupCalendar_Database =
{
	Format = GroupCalendar_cDatabaseFormat,
	Databases = {},
};

gGroupCalendar_Database2 =
{
	Format = GroupCalendar_cDatabaseFormat,
	Databases = {},
};

gGroupCalendar_PlayerDatabases = 
{
	Format = GroupCalendar_cDatabaseFormat,
	Databases = {},
}

gGroupCalendar_PlayerVersions = {};

gGroupCalendar_UserDatabase = nil;
gGroupCalendar_GuildDatabase = nil;

gGroupCalendar_MaximumEventAge = 30;
gGroupCalendar_MaximumSyncEventAge = 3;
gGroupCalendar_MinimumEventDate = nil;
gGroupCalendar_MinimumSyncEventDate = nil;

gCategoryType_Class = 1;
gCategoryType_Role = 2;
gCategoryType_Status = 3;

gGroupCalendar_PlayerCharacters = {};

gGroupCalendar_40ManLimits =
{
	mClassLimits =
	{
		P = {mMin = 4, mMax = 6},
		R = {mMin = 4, mMax = 6},
		D = {mMin = 4, mMax = 6},
		W = {mMin = 4, mMax = 6},
		H = {mMin = 4, mMax = 6},
		K = {mMin = 4, mMax = 6},
		M = {mMin = 4, mMax = 6},
		L = {mMin = 4, mMax = 6},
		S = {mMin = 4, mMax = 6},
	},
	
	mMaxAttendance = 40,
};

gGroupCalendar_20ManLimits =
{
	mClassLimits =
	{
		P = {mMin = 2, mMax = 3},
		R = {mMin = 2, mMax = 3},
		D = {mMin = 2, mMax = 3},
		W = {mMin = 2, mMax = 3},
		H = {mMin = 2, mMax = 3},
		K = {mMin = 2, mMax = 3},
		M = {mMin = 2, mMax = 3},
		L = {mMin = 2, mMax = 3},
		S = {mMin = 2, mMax = 3},
	},
	
	mMaxAttendance = 20,
};

gGroupCalendar_15ManLimits =
{
	mClassLimits =
	{
		P = {mMin = 1, mMax = 3},
		R = {mMin = 1, mMax = 3},
		D = {mMin = 1, mMax = 3},
		W = {mMin = 1, mMax = 3},
		H = {mMin = 1, mMax = 3},
		K = {mMin = 1, mMax = 3},
		M = {mMin = 1, mMax = 3},
		L = {mMin = 1, mMax = 3},
		S = {mMin = 1, mMax = 3},
	},
	
	mMaxAttendance = 15,
};

gGroupCalendar_10ManLimits =
{
	mClassLimits =
	{
		P = {mMin = 1, mMax = 2},
		R = {mMin = 1, mMax = 2},
		D = {mMin = 1, mMax = 2},
		W = {mMin = 1, mMax = 2},
		H = {mMin = 1, mMax = 2},
		K = {mMin = 1, mMax = 2},
		M = {mMin = 1, mMax = 2},
		L = {mMin = 1, mMax = 2},
		S = {mMin = 1, mMax = 2},
	},
	
	mMaxAttendance = 10,
};

gGroupCalendar_5ManLimits =
{
	mClassLimits =
	{
		P = {mMax = 1},
		R = {mMax = 1},
		D = {mMax = 1},
		W = {mMax = 1},
		H = {mMax = 1},
		K = {mMax = 1},
		M = {mMax = 1},
		L = {mMax = 1},
		S = {mMax = 1},
	},
	
	mMaxAttendance = 5,
};

gGroupCalendar_EventTypes =
{
	General =
	{
		Title = GroupCalendar_cGeneralEventGroup,
		MenuHint = "FLAT",
		Events =
		{
			{id="Meet", name=GroupCalendar_cMeetingEventName},
			{id="Birth", name=GroupCalendar_cBirthdayEventName},
			{id="RP", name=GroupCalendar_cRoleplayEventName},
			{id="Act", name=GroupCalendar_cActivityEventName},
		},
	},
	
	Raid =
	{
		Title = GroupCalendar_cRaidEventGroup,
		MenuHint = "FLAT",
		Events =
		{
			{id="AQT",       name = GroupCalendar_cAQTEventName,       limits = gGroupCalendar_40ManLimits},
			{id="AQR",       name = GroupCalendar_cAQREventName,       limits = gGroupCalendar_20ManLimits},
			{id="BWL",       name = GroupCalendar_cBWLEventName,       limits = gGroupCalendar_40ManLimits},
			{id="MC",        name = GroupCalendar_cMCEventName,        limits = gGroupCalendar_40ManLimits},
			{id="Onyxia",    name = GroupCalendar_cOnyxiaEventName,    limits = gGroupCalendar_40ManLimits},
			{id="ZG",        name = GroupCalendar_cZGEventName,        limits = gGroupCalendar_20ManLimits},
			{id="UBRS",      name = GroupCalendar_cUBRSEventName,      limits = gGroupCalendar_15ManLimits},
			{id="Naxx",      name = GroupCalendar_cNaxxEventName,      limits = gGroupCalendar_40ManLimits},
		}
	},
	
	Dungeon =
	{
		Title = GroupCalendar_cDungeonEventGroup,
		MenuHint = "FLAT",
		Events =
		{
			{id="Scholo",    name = GroupCalendar_cScholoEventName,    limits = gGroupCalendar_5ManLimits},
			{id="DM",        name = GroupCalendar_cDMEventName,        limits = gGroupCalendar_5ManLimits},
			{id="Strath",    name = GroupCalendar_cStrathEventName,    limits = gGroupCalendar_5ManLimits},
			{id="LBRS",      name = GroupCalendar_cLBRSEventName,      limits = gGroupCalendar_5ManLimits},
			{id="BRD",       name = GroupCalendar_cBRDEventName,       limits = gGroupCalendar_5ManLimits},
			{id="ST",        name = GroupCalendar_cSTEventName,        limits = gGroupCalendar_5ManLimits},
			{id="ZF",        name = GroupCalendar_cZFEventName,        limits = gGroupCalendar_5ManLimits},
			{id="Mara",      name = GroupCalendar_cMaraEventName,      limits = gGroupCalendar_5ManLimits},
			{id="Uld",       name = GroupCalendar_cUldEventName,       limits = gGroupCalendar_5ManLimits},
			{id="RFD",       name = GroupCalendar_cRFDEventName,       limits = gGroupCalendar_5ManLimits},
			{id="SM",        name = GroupCalendar_cSMEventName,        limits = gGroupCalendar_5ManLimits},
			{id="RFK",       name = GroupCalendar_cRFKEventName,       limits = gGroupCalendar_5ManLimits},
			{id="Gnomer",    name = GroupCalendar_cGnomerEventName,    limits = gGroupCalendar_5ManLimits},
			{id="BFD",       name = GroupCalendar_cBFDEventName,       limits = gGroupCalendar_5ManLimits},
			{id="Stockades", name = GroupCalendar_cStockadesEventName, limits = gGroupCalendar_5ManLimits},
			{id="SFK",       name = GroupCalendar_cSFKEventName,       limits = gGroupCalendar_5ManLimits},
			{id="WC",        name = GroupCalendar_cWCEventName,        limits = gGroupCalendar_5ManLimits},
			{id="Deadmines", name = GroupCalendar_cDeadminesEventName, limits = gGroupCalendar_5ManLimits},
			{id="RFC",       name = GroupCalendar_cRFCEventName,       limits = gGroupCalendar_5ManLimits},
		},
	},
	
	Battleground =
	{
		Title = GroupCalendar_cBattlegroundEventGroup,
		MenuHint = "HIER",
		Events =
		{
			{id="PvP",       name=GroupCalendar_cPvPEventName},
			{id="AV",        name=GroupCalendar_cAVEventName},
			{id="AB",        name=GroupCalendar_cABEventName},
			{id="WSG",       name=GroupCalendar_cWSGEventName},
		},
	},
	
	Reset =
	{
		Title = nil,
		Events =
		{
			{id="RSOny", name=GroupCalendar_cOnyxiaResetEventName}, -- Onyxia reset
			{id="RSMC", name=GroupCalendar_cMCResetEventName}, -- MC reset
			{id="RSBWL", name=GroupCalendar_cBWLResetEventName}, -- BWL reset
			{id="RSZG", name=GroupCalendar_cZGResetEventName}, -- ZG reset
			{id="RSAQT", name=GroupCalendar_cAQTResetEventName}, -- AQT reset
			{id="RSAQR", name=GroupCalendar_cAQRResetEventName}, -- AQR reset
			{id="RSNaxx", name=GroupCalendar_cNaxxResetEventName}, -- Naxxramas reset
			{id="RSXmut", name=GroupCalendar_cTransmuteCooldownEventName}, -- Transmute
			{id="RSSalt", name=GroupCalendar_cSaltShakerCooldownEventName}, -- Salt shaker
			{id="RSMoon", name=GroupCalendar_cMoonclothCooldownEventName}, -- Mooncloth
			{id="RSSnow", name=GroupCalendar_cSnowmasterCooldownEventName}, -- Snowmaster 9000
			{id="RSGadget", name=GroupCalendar_cGadgetzanCooldownEventName}, -- Gadgetzan Transporter
		},
		
		ResetEventInfo =
		{
			RSZG = {left = 0.0, top = 0.25, right = 0.25, bottom = 0.5, isDungeon = true, name=GroupCalendar_cRaidInfoZGName, largeIcon="ZG", frequency=3},
			RSOny = {left = 0.25, top = 0.25, right = 0.5, bottom = 0.5, isDungeon = true, name=GroupCalendar_cRaidInfoOnyxiaName, largeIcon="Onyxia", frequency=5},
			RSMC = {left = 0.5, top = 0.25, right = 0.75, bottom = 0.5, isDungeon = true, name=GroupCalendar_cRaidInfoMCName, largeIcon="MC", frequency=7},
			RSBWL = {left = 0.75, top = 0.25, right = 1.0, bottom = 0.5, isDungeon = true, name=GroupCalendar_cRaidInfoBWLName, largeIcon="BWL", frequency=7},
			RSAQT = {left = 0.0, top = 0.5, right = 0.25, bottom = 0.75, isDungeon = true, name=GroupCalendar_cRaidInfoAQTName, largeIcon="AQT", frequency=7},
			RSAQR = {left = 0.25, top = 0.5, right = 0.5, bottom = 0.75, isDungeon = true, name=GroupCalendar_cRaidInfoAQRName, largeIcon="AQR", frequency=3},
			RSNaxx = {left = 0.5, top = 0.5, right = 0.75, bottom = 0.75, isDungeon = true, name=GroupCalendar_cRaidInfoNaxxName, largeIcon="Naxx", frequency=7},
			RSXmut = {left = 0.50, top = 0, right = 0.75, bottom = 0.25, isTradeskill = true, id="Alchemy", largeSysIcon="Interface\\Icons\\Trade_Alchemy"},
			RSSalt = {left = 0.25, top = 0, right = 0.5, bottom = 0.25, isTradeskill = true, id="Leatherworking", largeSysIcon="Interface\\Icons\\Trade_Leatherworking"},
			RSMoon = {left = 0, top = 0, right = 0.25, bottom = 0.25, isTradeskill = true, id="Tailoring", largeSysIcon="Interface\\Icons\\Trade_Tailoring"},
			RSSnow = {left = 0.75, top = 0, right = 1.0, bottom = 0.25, isTradeskill = true, id="Snowmaster", largeSysIcon="Interface\\Icons\\Spell_Frost_WindWalkOn"},
			RSGadget = {left = 0.25, top = 0.5, right = 0.5, bottom = 0.25, isTradeskill = true, name="Gadgetzan Transporter", id="Engineering", largeSysIcon="Interface\\Icons\\Trade_Engineering"},
		},
	},
};

gGroupCalendar_ClassInfoByClassCode =
{
	D = {name = GroupCalendar_cDruidClassName, color = GroupCalendar_cDruidClassColorName, element = "Druid"},
	H = {name = GroupCalendar_cHunterClassName, color = GroupCalendar_cHunterClassColorName, element = "Hunter"},
	M = {name = GroupCalendar_cMageClassName, color = GroupCalendar_cMageClassColorName, element = "Mage"},
	L = {name = GroupCalendar_cPaladinClassName, color = GroupCalendar_cPaladinClassColorName, element = "Paladin", faction="Alliance"},
	P = {name = GroupCalendar_cPriestClassName, color = GroupCalendar_cPriestClassColorName, element = "Priest"},
	R = {name = GroupCalendar_cRogueClassName, color = GroupCalendar_cRogueClassColorName, element = "Rogue"},
	S = {name = GroupCalendar_cShamanClassName, color = GroupCalendar_cShamanClassColorName, element = "Shaman", faction="Horde"},
	K = {name = GroupCalendar_cWarlockClassName, color = GroupCalendar_cWarlockClassColorName, element = "Warlock"},
	W = {name = GroupCalendar_cWarriorClassName, color = GroupCalendar_cWarriorClassColorName, element = "Warrior"},
};

gGroupCalendar_RoleTypes =
{
	T = {name = GroupCalendar_cTankLabel, element = "Tank"},
	H = {name = GroupCalendar_cHealerLabel, element = "Healer"},
	D = {name = GroupCalendar_cDpsLabel, element = "DPS"},
	U = {name = GroupCalendar_cUnknownRoleLabel, element = "Unknown"},
};

gGroupCalendar_RaceNamesByRaceCode =
{
	--A = {name = GroupCalendar_cDraeneiRaceName, faction="Alliance"},
	D = {name = GroupCalendar_cDwarfRaceName, faction="Alliance"},
	G = {name = GroupCalendar_cGnomeRaceName, faction="Alliance"},
	H = {name = GroupCalendar_cHumanRaceName, faction="Alliance"},
	N = {name = GroupCalendar_cNightElfRaceName, faction="Alliance"},
	--B = {name = GroupCalendar_cBloodElfRaceName, faction="Horde"},
	O = {name = GroupCalendar_cOrcRaceName, faction="Horde"},
	T = {name = GroupCalendar_cTaurenRaceName, faction="Horde"},
	R = {name = GroupCalendar_cTrollRaceName, faction="Horde"},
	U = {name = GroupCalendar_cUndeadRaceName, faction="Horde"},
};

function EventDatabase_DatabaseIsVisible(pDatabase)	
	return	pDatabase
		and pDatabase.Realm == gGroupCalendar_RealmName
		and pDatabase.Guild == gGroupCalendar_PlayerGuild
end

function EventDatabase_SetUserName(pUserName)
	gGroupCalendar_UserDatabase = EventDatabase_GetPlayerDatabase(gGroupCalendar_PlayerName, true);
	gGroupCalendar_UserDatabase.UserName = gGroupCalendar_PlayerName;
	gGroupCalendar_UserDatabase.PlayerRaceCode = EventDatabase_GetRaceCodeByRace(UnitRace("PLAYER"));
	
	gGroupCalendar_UserDatabase.PlayerClassCode = EventDatabase_GetClassCodeByClass(UnitClass("PLAYER"));

	gGroupCalendar_UserDatabase.PlayerLevel = UnitLevel("PLAYER");
end

function EventDatabase_IsPlayer(pPlayerName)	
	
	for vRealmUser, vDatabase in pairs(gGroupCalendar_PlayerDatabases.Databases) do
		if EventDatabase_DatabaseIsVisible(vDatabase) then
			if pPlayerName == vDatabase.UserName then
				return true;
			end
		end
	end
	
	return false;
end

function EventDatabase_GetPlayerDatabases()
	local	vOwnedDatabases = {};
	
	for vRealmUser, vDatabase in pairs(gGroupCalendar_PlayerDatabases.Databases) do
		if EventDatabase_DatabaseIsVisible(vDatabase) then
			table.insert(vOwnedDatabases, vDatabase);
		end
	end
	
	return vOwnedDatabases;
end

function EventDatabase_GetPlayerDatabase(pPlayerName, pCreate)
	if not pPlayerName then
		Calendar_DebugMessage("EventDatabase_GetPlayerDatabase: pPlayerName is nil");
		return;
	end
	
	local	vDatabase = gGroupCalendar_PlayerDatabases.Databases[gGroupCalendar_RealmName.."_"..pPlayerName];
	
	if not vDatabase then
		if pCreate then
			vDatabase = {};			
			vDatabase.Realm = gGroupCalendar_RealmName;
			vDatabase.Events = {};
			vDatabase.Guild = pGuildName;
			
			gGroupCalendar_PlayerDatabases.Databases[gGroupCalendar_RealmName.."_"..pPlayerName] = vDatabase;			
		else
			return nil;
		end
	end

	return vDatabase;
end

function EventDatabase_GetEventRSVP(pEvent)
	for DBindex, vPlayerDB in pairs (EventDatabase_GetPlayerDatabases()) do
		for vAttendeeName, vRSVP in pairs(pEvent.mAttendance) do
			if vAttendeeName == vPlayerDB.UserName and (vRSVP.mStatus == "Y" or vRSVP.mStatus == "S") then
				return vAttendeeName, vRSVP;
			end
		end
	end
end

function EventDatabase_GetDatabase(pGuildName, pCreate, pRealmName)
	if not pGuildName then
		Calendar_DebugMessage("EventDatabase_GetDatabase: pGuildName is nil");
		return;
	end
	
	if not pRealmName then
		pRealmName = gGroupCalendar_RealmName;
	end

	local	vDatabase = gGroupCalendar_Database2.Databases[pRealmName.."_"..pGuildName];
	
	if not vDatabase then
		if pCreate then
			vDatabase = {};
			--vDatabase.CurrentEventID = 0;
			vDatabase.Realm = pRealmName;
			vDatabase.Events = {};
			vDatabase.Guild = pGuildName;
			
			gGroupCalendar_Database2.Databases[pRealmName.."_"..pGuildName] = vDatabase;			
		else
			return nil;
		end
	end

	return vDatabase;
end

function EventDatabase_DeleteDatabase(pGuildName)
	local	vDatabase = gGroupCalendar_Database.Databases[gGroupCalendar_RealmName.."_"..pGuildName];
	
	if not vDatabase then
		return;
	end	
	
	gGroupCalendar_Database.Databases[gGroupCalendar_RealmName.."_"..pGuildName] = nil;	
end


function EventDatabase_GenerateGUID(vDatabase)
	local guid = gGroupCalendar_PlayerName..tostring(time());
	local guid_len = strlen(guid);
	-- Check that the ID is really unique
	local vIncrement = 1;
	if vDatabase and vDatabase.Events then
		for vDate, vSchedule in pairs(vDatabase.Events) do
			for vEventIndex, vEvent in pairs(vSchedule) do
				if strsub(vEvent.mGUID, 1, guid_len) == guid then
					-- found a match. Get its incremented value on the end if it has one.
					local foundIncrement = strsub(vEvent.mGUID, guid_len + 1);
					if foundIncrement then
						local vNewIncrement = tonumber(foundIncrement) + 1;
						if vNewIncrement > vIncrement then
							vIncrement = vNewIncrement;
						end
					end
				end
			end
		end
	end

	return guid .. vIncrement;
end

function EventDatabase_NewEvent(pDatabase, pDate, pUserGenerated)
	local	vEvent = {};
	
	vEvent.mStatus = "A";
	local	vDate, vTime60 = EventDatabase_GetServerDateTime60Stamp();	
	vEvent.mChangedDate = vDate;
	vEvent.mChangedTime = vTime60;

	vEvent.mType = nil;
	vEvent.mTitle = nil;
	
	vEvent.mTime = 1140;
	vEvent.mDate = pDate;
	vEvent.mDuration = 120;
	
	vEvent.mDescription = nil;
	
	vEvent.mMinLevel = 0;
	vEvent.mAttendance = nil;
	
	vEvent.mPrivate = nil;
	
	vEvent.mManualConfirm = false;
	vEvent.mLimits = nil;
	
	if pUserGenerated then
		vEvent.mUserName = gGroupCalendar_PlayerName;
	else
		vEvent.mUserName = nil;
	end

	vEvent.mGUID = EventDatabase_GenerateGUID(pDatabase);
	vEvent.mAttendance = {};
	
	return vEvent;
end

function EventDatabase_AddEvent(pDatabase, pEvent, pSilent)	
	local	vSchedule = pDatabase.Events[pEvent.mDate];
	
	if vSchedule == nil then
		vSchedule = {};
		pDatabase.Events[pEvent.mDate] = vSchedule;
	end	
		
	-- append the event
	table.insert(vSchedule, pEvent);
	
	if not pSilent then
		EventDatabase_EventAdded(pDatabase, pEvent);
	end
end

function EventDatabase_GetDateSchedule(pDate)
	return gGroupCalendar_UserDatabase.Events[pDate];
end

function EventDatabase_GetCompiledSchedule(pDate)

	local		vCompiledSchedule = {};
	
	local vMonth, vDay, vYear = Calendar_ConvertDateToMDY(pDate);
	-- Check that the date makes sense
	if vMonth and vDay and vYear then
		if gGroupCalendar_Settings.ShowEventsInLocalTime then
			local		vDate2 = nil;
		
			if gGroupCalendar_ServerTimeZoneOffset < 0 then
			
				vDate2 = Calendar_AddDays(pDate, 1);
				
			elseif gGroupCalendar_ServerTimeZoneOffset > 0 then
				vDate2 = Calendar_AddDays(pDate, -1);
				
			end		
			for vDateIndex = 1, 2 do
				local	vDate;
					
				if vDateIndex == 1 then
					vDate = pDate;
				else
					if not vDate2 then
						break;
					end
						
					vDate = vDate2;
				end
			
				if gGroupCalendar_PlayerDatabases and gGroupCalendar_PlayerDatabases.Databases then
					for vDBname, vPlayerDB in pairs(gGroupCalendar_PlayerDatabases.Databases) do
						if vPlayerDB.Realm == gGroupCalendar_RealmName then
							local	vSchedule = vPlayerDB.Events[vDate];					
							if vSchedule then
								for vIndex, vEvent in pairs(vSchedule) do						
									-- Calculate the local date/time and see if it's still the right date							
									local	vLocalDate, vLocalTime = Calendar_GetLocalDateTimeFromServerDateTime(vDate, vEvent.mTime);
							
									local title = vEvent.mTitle;
									if not title then
										title = vEvent.mGUID
									end

									if vLocalDate == pDate then					
										table.insert(vCompiledSchedule, vEvent);
									end						
								end
							end
						end

					end
				end

				--if gGroupCalendar_UserDatabase then
				--	local	vSchedule = gGroupCalendar_UserDatabase.Events[vDate];
					
				--	if vSchedule then
				--		for vIndex, vEvent in pairs(vSchedule) do						
				--			-- Calculate the local date/time and see if it's still the right date							
				--			local	vLocalDate, vLocalTime = Calendar_GetLocalDateTimeFromServerDateTime(vDate, vEvent.mTime);
							
				--			if vLocalDate == pDate then								
				--				table.insert(vCompiledSchedule, vEvent);
				--			end						
				--		end
				--	end
				--end

				if gGroupCalendar_GuildDatabase then
					local	vSchedule = gGroupCalendar_GuildDatabase.Events[vDate];
					
					if vSchedule then
						for vIndex, vEvent in pairs(vSchedule) do
							if vEvent.mStatus ~= "D" then
								-- Calculate the local date/time and see if it's still the right date							
								local	vLocalDate, vLocalTime = Calendar_GetLocalDateTimeFromServerDateTime(vDate, vEvent.mTime);
							
								local title = vEvent.mTitle;
								if not title then
									title = vEvent.mGUID
								end

								if vLocalDate == pDate then		
									table.insert(vCompiledSchedule, vEvent);
								end
							end
						end
					end
				end
			end
		else	
			if gGroupCalendar_PlayerDatabases and gGroupCalendar_PlayerDatabases.Databases then
				for vDBname, vPlayerDB in pairs(gGroupCalendar_PlayerDatabases.Databases) do
					if vPlayerDB.Realm == gGroupCalendar_RealmName then
						local	vSchedule = vPlayerDB.Events[pDate];					
						if vSchedule then
							for vIndex, vEvent in pairs(vSchedule) do						
								table.insert(vCompiledSchedule, vEvent);
							end
						end
					end

				end
			end
			--if gGroupCalendar_UserDatabase then
			--	local	vSchedule = gGroupCalendar_UserDatabase.Events[pDate];
				
			--	if vSchedule then
			--		for vIndex, vEvent in pairs(vSchedule) do
			--			table.insert(vCompiledSchedule, vEvent);
			--		end
			--	end
			--end

			if gGroupCalendar_GuildDatabase then
				local	vSchedule = gGroupCalendar_GuildDatabase.Events[pDate];
				
				if vSchedule then
					for vIndex, vEvent in pairs(vSchedule) do
						if vEvent.mStatus ~= "D" then
							table.insert(vCompiledSchedule, vEvent);
						end
					end
				end
			end
		
		end
	end
	
	table.sort(vCompiledSchedule, EventDatabase_CompareCompiledEvents);

	return vCompiledSchedule;
end

function EventDatabase_CompareCompiledEvents(pCompiledEvent1, pCompiledEvent2)
	return EventDatabase_CompareEvents(pCompiledEvent1, pCompiledEvent2);
end

function EventDatabase_GetEventDisplayName(pEvent)
	
	if pEvent.mTitle and pEvent.mTitle ~= "" then
		return Calendar_UnescapeString(pEvent.mTitle);
	else
		local	vName = EventDatabase_GetEventNameByID(pEvent.mType);
		
		if vName ~= nil then
			return vName;
		else
			return "";
		end
	end
end

function EventDatabase_SecondDateTimeNewer(pDate1, pTime1, pDate2, pTime2)
	-- 0 = date 2 older
	-- 1 = date 2 same
	-- 2 = date 2 newer
	if not pDate2 then
		return 0;
	elseif not pDate1 and pDate2 then
		return 2;
	elseif pDate2 > pDate1 then
		return 2;
	elseif pDate2 == pDate1 and pTime2 > pTime1 then
		return 2;
	elseif pDate1 == pDate1 and pTime1 == pTime2 then
		return 1;
	else 
		return 0;
	end
end

function EventDatabase_CompareEvents(pEvent1, pEvent2)
	-- If either event has nil for a time (all day event) then
	-- sort based on time or display name
	
	if not pEvent1.mTime or not pEvent2.mTime then
		if pEvent1.mTime == pEvent2.mTime then
			return EventDatabase_GetEventDisplayName(pEvent1) < EventDatabase_GetEventDisplayName(pEvent2);
		elseif pEvent1.mTime == nil then
			return true;
		else
			return false;
		end
	
	-- Otherwise compare dates first
	
	elseif pEvent1.mDate < pEvent2.mDate then
		return true;
	elseif pEvent1.mDate > pEvent2.mDate then
		return false;
	
	-- Dates are the same, compare times
	
	elseif pEvent1.mTime == pEvent2.mTime then
		return EventDatabase_GetEventDisplayName(pEvent1) < EventDatabase_GetEventDisplayName(pEvent2);
	else
		return pEvent1.mTime < pEvent2.mTime;
	end
end

function EventDatabase_GetEventIndex(pSchedule, pEvent)
	for vIndex, vEvent in pairs(pSchedule) do
		if vEvent == pEvent then
			return vIndex;
		end
	end
	
	return 0;
end

function EventDatabase_ScheduleIsEmpty(pSchedule)
	for vIndex, vEvent in pairs(pSchedule) do
		return false;
	end
	
	return true;
end

function EventDatabase_FindEventByID(pDatabase, pGUID)
	for vDate, vSchedule in pairs(pDatabase.Events) do
		for vEventIndex, vEvent in pairs(vSchedule) do
			if vEvent.mGUID == pGUID then
				return vEvent, vDate;
			end
		end
	end
	
	return nil;
end

function EventDatabase_DeleteEvent(pDatabase, pEvent, vForce)
	if not vForce and not pEvent.mPrivate then
		-- Mark the event as deleted and remove the attendance
		local	vDate, vTime60 = EventDatabase_GetServerDateTime60Stamp();	
		pEvent.mStatus = "D";
		pEvent.mChangedTime = vTime60;
		pEvent.mChangedDate = vDate;
		pEvent.mAttendance = {};
	
		CalendarNetwork_SendEventUpdate(pEvent, "ALERT");
		--CalendarNetwork_RemovingEvent(pDatabase, pEvent);	
		-- Notify that the schedule changed
	
		GroupCalendar_ScheduleChanged(pDatabase, pEvent.mDate);
	
		return true;
	else
		local pDate = pEvent.mDate;
		local	vSchedule = pDatabase.Events[pDate];
	
		if vSchedule == nil then
			return false;
		end
	
		-- Find the event index	
		local	vEventIndex = EventDatabase_GetEventIndex(vSchedule, pEvent);
	
		if vEventIndex == 0 then			
			return false;
		end	
	
		-- Remove any pending RSVPs for the event
		if pEvent.mAttendance then
			pEvent.mAttendance = {};
		end
		--EventDatabase_RemoveAllRSVPsForEvent(pDatabase, pEvent, false);
	
		-- Remove the event
	
		table.remove(vSchedule, vEventIndex);
	
		if EventDatabase_ScheduleIsEmpty(vSchedule) then
			pDatabase.Events[pDate] = nil;
			vSchedule = nil;
		end
	
		-- Notify that the schedule changed
	
		GroupCalendar_ScheduleChanged(pDatabase, pDate);
	
		return true;
	end
end

function EventDatabase_CancelEvent(pDatabase, pEvent)
	-- Mark the event as deleted and remove the attendance
	local	vDate, vTime60 = EventDatabase_GetServerDateTime60Stamp();	
	pEvent.mStatus = "C";
	pEvent.mChangedTime = vTime60;
	pEvent.mChangedDate = vDate;
	
	--CalendarNetwork_RemovingEvent(pDatabase, pEvent);	
	-- Notify that the schedule changed
	
	GroupCalendar_ScheduleChanged(pDatabase, pDate);
	
	return true;
end

function EventDatabase_GetEventInfoByID(pID)
	for vGroupID, vEventGroup in pairs(gGroupCalendar_EventTypes) do
		for vIndex, vEventInfo in pairs(vEventGroup.Events) do
			if vEventInfo.id == pID then
				return vEventInfo;
			end
		end
	end
	
	return nil;
end

function EventDatabase_GetEventNameByID(pID)
	local	vEventInfo = EventDatabase_GetEventInfoByID(pID);
	
	if not vEventInfo then
		return nil;
	end
	
	return vEventInfo.name;
end

function EventDatabase_GetStandardLimitsByID(pID)
	local	vEventInfo = EventDatabase_GetEventInfoByID(pID);
	
	if not vEventInfo
	or not vEventInfo.limits then
		return nil;
	end
	
	-- Remove limit for classes from the "wrong" faction
	
	for vClassCode, vClassLimit in pairs(vEventInfo.limits.mClassLimits) do
		local	vClassInfo = gGroupCalendar_ClassInfoByClassCode[vClassCode];
		
		if vClassInfo.faction
		and vClassInfo.faction ~= gGroupCalendar_PlayerFactionGroup then
			vEventInfo.limits.mClassLimits[vClassCode] = nil;
		end
	end
	
	--
	
	return vEventInfo.limits;
end

function EventDatabase_EventAdded(pDatabase, pEvent)
	-- Notify the calendar	
	GroupCalendar_ScheduleChanged(pDatabase, pEvent.mDate);
	
	-- Notify the network	
	--CalendarNetwork_NewEvent(pDatabase, pEvent);
end

function EventDatabase_EventChanged(pDatabase, pEvent, pChangedFields)
	-- If the date changed then move the event to the appropriate slot	
	if pChangedFields and pChangedFields.mDate then
		local	vEvent, vDate = EventDatabase_FindEventByID(pDatabase, pEvent.mGUID);
		
		if vDate ~= pEvent.mDate then
			EventDatabase_DeleteEvent(pDatabase, pEvent, true);
			EventDatabase_AddEvent(pDatabase, pEvent, true);
		end
	end
		
	-- Notify the calendar	
	GroupCalendar_EventChanged(pDatabase, pEvent, pChangedFields);
	
	-- Notify the network	
	CalendarNetwork_EventChanged(pDatabase, pEvent, pChangedFields);
end

function EventDatabase_GetEventPath(pEvent)
	return "EVT:"..pEvent.mGUID.."/";
end

function EventDatabase_PurgeDatabase(pDatabase)
	pDatabase.Events = {};
end

function EventDatabase_ScanForNewlines(pDatabase)
	for vDate, vEvents in pairs(pDatabase.Events) do
		for vEventID, vEvent in pairs(vEvents) do
			if vEvent.mDescription then
				vEvent.mDescription = string.gsub(vEvent.mDescription, "\n", "&n;");
			end
		end
	end	
end

function EventDatabase_Initialize()
	EventDatabase_CheckDatabases();	
end

function EventDatabase_CheckDatabases()
	-- Update databases to new versions here...

	-- Eventually remove this once the new DB structure is in place long for 2 months.
	--EventDatabase_ConvertOldEvents();
	
	-- Causing too many issues
	--CalendarNetwork_QueueTask(
	--		EventDatabase_ConvertOldEvents, nil,
	--		5, "ConvertOldEvents");



	-- Remove old events	
	for vRealmGuild, vDatabase in pairs(gGroupCalendar_Database2.Databases) do		
		EventDatabase_DeleteOldEvents(vDatabase);
	end
end

function EventDatabase_ConvertOldEvents()
	if gGroupCalendar_Database then
		for vRealmUser, vDatabase in pairs(gGroupCalendar_Database.Databases) do	
			if vDatabase.IsPlayerOwned then	
				for vEventDate, vEventList in pairs(vDatabase.Events) do
					for vEventID, vEvent in pairs(vEventList) do
						if not vEvent.mPrivate then
							local vGuildDatabase = EventDatabase_GetDatabase(vDatabase.Guild, true, vDatabase.Realm);
							local vNewEvent = EventDatabase_NewEvent(vGuildDatabase, Calendar_ConvertOldDateToNewDate(vEvent.mDate), false);
							vNewEvent.mTime = vEvent.mTime;
							vNewEvent.mManualConfirm = vEvent.mManualConfirm;
							vNewEvent.mDuration = vEvent.mDuration;
							vNewEvent.mTitle = vEvent.mTitle;
							vNewEvent.mType = vEvent.mType;
							vNewEvent.mMinLevel = vEvent.mMinLevel;
							vNewEvent.mMaxLevel = vEvent.mMaxLevel;
							vNewEvent.mLimits = vEvent.mLimits;
							vNewEvent.mUserName = vDatabase.UserName;

							if vEvent.mAttendance then
								for vAttendeeName, vRSVPstring in pairs(vEvent.mAttendance) do
									local vRSVP = EventDatabase_UnpackEventRSVP(gGroupCalendar_PlayerName, vAttendeeName, vEvent.mID, vRSVPstring);
									local vNewRSVP = {};

									vNewRSVP.mName = vAttendeeName;
									vNewRSVP.mRole = vRSVP.mRole;
									vNewRSVP.mDate = Calendar_ConvertOldDateToNewDate(vRSVP.mDate);
									vNewRSVP.mTime = vRSVP.mTime;
									vNewRSVP.mStatus = vRSVP.mStatus;
									vNewRSVP.mOriginalDate = Calendar_ConvertOldDateToNewDate(vRSVP.mOriginalDate);
									vNewRSVP.mOriginalTime = vRSVP.mOriginalTime;								
									vNewRSVP.mClassCode = vRSVP.mClassCode;
									vNewRSVP.mRaceCode = vRSVP.mRaceCode;
									vNewRSVP.mLevel = vRSVP.mLevel;
									vNewRSVP.mGuildRank = vRSVP.mGuildRank			

									vNewEvent.mAttendance[vAttendeeName] = vNewRSVP;

								end
							end

							EventDatabase_AddEvent(vGuildDatabase, vNewEvent);

						end
					end
				end
			end
		end
		gGroupCalendar_Database = nil;
	end
end

function EventDatabase_UnpackEventRSVP(pOrganizerName, pAttendeeName, pEventID, pEventRSVPString)
	local	vEventParameters = CalendarNetwork_ParseParameterString(pEventRSVPString);
	
	local pRole = "U";
	if tablelength(vEventParameters) >= 10 then
		pRole = vEventParameters[10]
	end

	local	vRSVPFields =
	{
		mOrganizerName = pOrganizerName,
		mName = pAttendeeName,
		mEventID = pEventID,
		mDate = tonumber(vEventParameters[1]),
		mTime = tonumber(vEventParameters[2]),
		mStatus = vEventParameters[3],
		mComment = vEventParameters[5],
		mGuild = vEventParameters[6],
		mGuildRank = tonumber(vEventParameters[7]),
		mOriginalDate = tonumber(vEventParameters[8]),
		mOriginalTime = tonumber(vEventParameters[9]),
		mRole = pRole
	};
	
	if vRSVPFields.mGuild == "" then
		vRSVPFields.mGuild = nil;
	end
	
	EventDatabase_UnpackCharInfo(vEventParameters[4], vRSVPFields);
	
	EventDatabase_FillInRSVPGuildInfo(vRSVPFields);
	
	return vRSVPFields;
end

function EventDatabase_UnpackCharInfo(pString, rCharInfo)
	if not pString then
		rCharInfo.mRaceCode = "?";
		rCharInfo.mClassCode = "?";
		rCharInfo.mLevel = 0;
	else
		rCharInfo.mRaceCode = string.sub(pString, 1, 1);
		rCharInfo.mClassCode = string.sub(pString, 2, 2);
		rCharInfo.mLevel = tonumber(string.sub(pString, 3));
	end
end

function EventDatabase_FillInRSVPGuildInfo(pRSVP)
	if pRSVP.mGuild then	
		return;
	end
	
	vIsInGuild, vRankIndex = CalendarNetwork_UserIsInSameGuild(pRSVP.mName);
	
	if not vIsInGuild then
		return;
	end
	
	pRSVP.mGuild = gGroupCalendar_PlayerGuild;
	pRSVP.mGuildRank = vRankIndex;
end

function EventDatabase_GetDateTime60Stamp()
	local	vYear, vMonth, vDay, vHour, vMinute, vSecond = Calendar_GetCurrentYearMonthDayHourMinute();
	
	local	vDate = Calendar_ConvertMDYToDate(vMonth, vDay, vYear);
	local	vTime60 = Calendar_ConvertHMSToTime60(vHour, vMinute, vSecond);
	
	return vDate, vTime60;
end

function EventDatabase_GetServerDateTime60Stamp()
	local	vYear, vMonth, vDay, vHour, vMinute, vSecond = Calendar_GetCurrentYearMonthDayHourMinute();
	
	local	vDate = Calendar_ConvertMDYToDate(vMonth, vDay, vYear);
	local	vTime = Calendar_ConvertHMToTime(vHour, vMinute);
	
	vDate, vTime = Calendar_GetServerDateTimeFromLocalDateTime(vDate, vTime);
	
	return vDate, vTime * 60 + vSecond;
end

function EventDatabase_EventExists(pEventGUID)
	local vDatabase = EventDatabase_GetDatabase(gGroupCalendar_PlayerGuild, false)

	if not vDatabase then
		return false;
	end
	
	if not EventDatabase_FindEventByID(vDatabase, pEventGUID) then
		return false;
	end
	
	return true;
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function EventDatabase_GetRaceCodeByRace(pRace)
	for vRaceCode, vRaceInfo in pairs(gGroupCalendar_RaceNamesByRaceCode) do
		if pRace == vRaceInfo.name then
			return vRaceCode;
		end
	end
	
	return "?";
end

function EventDatabase_GetRaceByRaceCode(pRaceCode)
	local	vRaceInfo = gGroupCalendar_RaceNamesByRaceCode[pRaceCode];
	
	if not vRaceInfo then
		return nil;
	end
	
	return vRaceInfo.name;
end

function EventDatabase_GetClassCodeByClass(pClass)
	for vClassCode, vClassInfo in pairs(gGroupCalendar_ClassInfoByClassCode) do
		if pClass == vClassInfo.name then
			return vClassCode;
		end
	end
	
	return "?";
end


function EventDatabase_GetClassByClassCode(pClassCode)
	local	vClassInfo = gGroupCalendar_ClassInfoByClassCode[pClassCode];
	
	if not vClassInfo then
		if pClassCode then
			return "Unknown ("..pClassCode..")";
		else
			return "Unknown (nil)";
		end
	else
		return vClassInfo.name;
	end
end

function EventDatabase_GetRoleCodeByRole(pRole)
	for vRoleCode, vRoleInfo in pairs(gGroupCalendar_RoleTypes) do
		if pRole == vRoleInfo.name then
			return vRoleCode;
		end
	end
	
	return "U"; -- Unknown Code
end


function EventDatabase_GetRoleByRoleCode(pRoleCode)
	local	vRoleInfo = gGroupCalendar_RoleTypes[pRoleCode];
	
	if not vRoleInfo then
		return GroupCalendar_cUnknownRoleLabel;
	else
		return vRoleInfo.name;
	end
end
	
function EventDatabase_IsQuestingEventType(pEventType)
	return pEventType ~= "Meet" and pEventType ~= "Birth" and pEventType ~= "Activity";
end

function EventDatabase_IsResetEventType(pEventType)
	if not pEventType then
		return false;
	end
	
	return gGroupCalendar_EventTypes.Reset.ResetEventInfo[pEventType] ~= nil;
end

function EventDatabase_GetResetIconCoords(pEventType)
	if not pEventType then
		return nil;
	end
	
	return gGroupCalendar_EventTypes.Reset.ResetEventInfo[pEventType];
end

function EventDatabase_GetResetEventLargeIconPath(pEventType)
	if not pEventType then
		return nil;
	end
	
	local	vResetEventInfo = gGroupCalendar_EventTypes.Reset.ResetEventInfo[pEventType];
	
	if vResetEventInfo.largeIcon then
		return vResetEventInfo.largeIcon, false;
	elseif vResetEventInfo.largeSysIcon then
		return vResetEventInfo.largeSysIcon, true;
	else
		return nil;
	end
end

function EventDatabase_IsDungeonResetEventType(pEventType)
	if not pEventType then
		return false;
	end
	
	local	vResetEventInfo = gGroupCalendar_EventTypes.Reset.ResetEventInfo[pEventType];
	
	if not vResetEventInfo then
		return false;
	end
	
	return vResetEventInfo.isDungeon;
end

function EventDatabase_LookupDungeonResetEventTypeByName(pName)
	for vEventType, vResetEventInfo in pairs(gGroupCalendar_EventTypes.Reset.ResetEventInfo) do
		if vResetEventInfo.isDungeon then
			if vResetEventInfo.name == pName then
				return vEventType, vResetEventInfo;
			end
		end
	end
	
	return nil;
end

function EventDatabase_LookupTradeskillEventTypeByID(pID)
	for vEventType, vResetEventInfo in pairs(gGroupCalendar_EventTypes.Reset.ResetEventInfo) do
		if vResetEventInfo.isTradeskill then
			if vResetEventInfo.id == pID then
				return vEventType;
			end
		end
	end
	
	return nil;
end

function EventDatabase_EventTypeUsesAttendance(pEventType)
	if pEventType == "Birth"
	or EventDatabase_IsResetEventType(pEventType) then
		return false;
	end
	
	return true;
end

function EventDatabase_EventTypeUsesLevelLimits(pEventType)
	if pEventType == "Birth"
	or pEventType == "Meet"
	or pEventType == "Activity"
	or EventDatabase_IsResetEventType(pEventType) then
		return false;
	end
	
	return true;
end

function EventDatabase_EventTypeUsesTime(pEventType)
	if pEventType == "Birth" then
		return false;
	end
	
	return true;
end

function CalendarAttendanceList_New()
	return
	{
		NumCategories = 0,
		NumPlayers = 0,
		NumAttendees = 0,
		Categories = {},
		SortedCategories = {},
		ClassTotals = {},
		RoleTotals = {},
		Items = {},
	};
end

function CalendarAttendanceList_RemoveCategory(pAttendanceList, pCategoryID)
	local	vClassInfo = pAttendanceList.Categories[pCategoryID];
	
	if not vClassInfo then
		return false;
	end
	
	pAttendanceList.NumPlayers = pAttendanceList.NumPlayers - table.getn(vClassInfo.mAttendees);
	pAttendanceList.NumCategories = pAttendanceList.NumCategories - 1;
	
	-- Remove it from the sorted categories
	
	for vIndex, vCategoryID in pairs(pAttendanceList.SortedCategories) do
		if vCategoryID == pCategoryID then
			table.remove(pAttendanceList.SortedCategories, vIndex);
		end
	end

	pAttendanceList.Categories[pCategoryID] = nil;
	return true;
end

function CalendarAttendanceList_AddItem(pAttendanceList, pCategoryID, pItem, pCategoryType)
	if not pItem then
		Calendar_ErrorMessage("CalendarAttendanceList_AddItem: pItem is nil");
		return;
	end
	
	if not pCategoryID then
		Calendar_ErrorMessage("CalendarAttendanceList_AddItem: pCategoryID is nil");
		return;
	end
	
	if pCategoryType == gCategoryType_Class then

		local	vClassInfo = pAttendanceList.Categories[pCategoryID];
	
		if not vClassInfo then
			vClassInfo = {mCount = 1, mClassCode = pCategoryID, mAttendees = {}};
			pAttendanceList.Categories[pCategoryID] = vClassInfo;
			table.insert(pAttendanceList.SortedCategories, pCategoryID);
		
			pAttendanceList.NumCategories = pAttendanceList.NumCategories + 1;
		else
			vClassInfo.mCount = vClassInfo.mCount + 1;
		end
	
		pAttendanceList.NumPlayers = pAttendanceList.NumPlayers + 1;
	
		table.insert(vClassInfo.mAttendees, pItem);
	else -- role
		
		local	vRoleInfo = pAttendanceList.Categories[pCategoryID];
		if not vRoleInfo then
			vRoleInfo = {mCount = 1, mRoleCode = pCategoryID, mAttendees = {}};
			pAttendanceList.Categories[pCategoryID] = vRoleInfo;
			table.insert(pAttendanceList.SortedCategories, pCategoryID);
		
			pAttendanceList.NumCategories = pAttendanceList.NumCategories + 1;
		else
			vRoleInfo.mCount = vRoleInfo.mCount + 1;
		end
	
		pAttendanceList.NumPlayers = pAttendanceList.NumPlayers + 1;
	
		table.insert(vRoleInfo.mAttendees, pItem);
	end
end

function CalendarAttendanceList_AddPlayer(pAttendanceList, pPlayer, pCategoryType)
	return CalendarAttendanceList_AddItem(pAttendanceList, pPlayer.mClassCode, pPlayer, pCategoryType);
end

function CalendarAttendanceList_AddWhisper(pAttendanceList, pPlayerName, pWhispers, pCategoryType)
	local	vPlayer =
	{
		mName = pPlayerName,
		mWhispers = pWhispers.mWhispers,
	};
	
	local	vGuildMemberIndex = CalendarNetwork_GetGuildMemberIndex(pPlayerName);
	
	if vGuildMemberIndex then
		local	vMemberName, vRank, vRankIndex,
				vLevel, vClass, vZone, vNote,
				vOfficerNote, vOnline = GetGuildRosterInfo(vGuildMemberIndex);
		
		vPlayer.mLevel = vLevel;
		vPlayer.mClassCode = EventDatabase_GetClassCodeByClass(vClass);
		vPlayer.mZone = vZone;
		vPlayer.mOnline = vOnline;
	end
	
	vPlayer.mDate = pWhispers.mDate;
	vPlayer.mTime = pWhispers.mTime;
	vPlayer.mType = "Whisper";

	return CalendarAttendanceList_AddItem(
			pAttendanceList,
			"WHISPERS",
			vPlayer,
			pCategoryType);
end

function CalendarAttendanceList_CalculateClassTotals(pAttendanceList, pIsAttendingFunction)
	pAttendanceList.ClassTotals = {};
	
	for vName, vItem in pairs(pAttendanceList.Items) do
		if vItem.mClassCode
		and pIsAttendingFunction(vItem) then
			local	vTotal = pAttendanceList.ClassTotals[vItem.mClassCode];
			
			if not vTotal then
				pAttendanceList.ClassTotals[vItem.mClassCode] = 1;
			else
				pAttendanceList.ClassTotals[vItem.mClassCode] = vTotal + 1;
			end
		end
	end
end

function CalendarAttendanceList_CalculateRoleTotals(pAttendanceList, pIsAttendingFunction)
	pAttendanceList.RoleTotals = {};
	
	for vName, vItem in pairs(pAttendanceList.Items) do
		if vItem.mRole
		and pIsAttendingFunction(vItem) then
			local	vTotal = pAttendanceList.RoleTotals[vItem.mRole];
			
			if not vTotal then
				pAttendanceList.RoleTotals[vItem.mRole] = 1;
			else
				pAttendanceList.RoleTotals[vItem.mRole] = vTotal + 1;
			end
		end
	end
end

function CalendarAttendanceList_RSVPIsAttending(pItem)
	return pItem.mStatus ~= "-"
	   and pItem.mStatus ~= "N"
	   and pItem.mStatus ~= "C"
	   and pItem.mStatus ~= "S";
end

function CalendarAttendanceList_FindItem(pAttendanceList, pFieldName, pFieldValue, pCategoryID)
	if not pAttendanceList then
		return nil;
	end
	
	if not pFieldValue then
		Calendar_DebugMessage("CalendarAttendanceList_FindItem: pFieldValue is nil for "..pFieldName);
		return nil;
	end
	
	local	vLowerFieldValue = strlower(pFieldValue);
	
	-- Search all categories if none is specified
	
	if not pCategoryID then
		for vCategoryID, vCategoryInfo in pairs(pAttendanceList.Categories) do
			for vIndex, vItem in pairs(vCategoryInfo.mAttendees) do
				local	vItemFieldValue = vItem[pFieldName];
				
				if vItemFieldValue
				and strlower(vItemFieldValue) == vLowerFieldValue then
					return vItem;
				end
			end
		end
	
	-- Search the specified category
	
	else
		local	vCategoryInfo = pAttendanceList.Categories[pCategoryID];
		
		if not vCategoryInfo then
			return nil;
		end
		
		for vIndex, vItem in pairs(vCategoryInfo.mAttendees) do
			if strlower(vItem[pFieldName]) == vLowerFieldValue then
				return vItem;
			end
		end
	end
	
	return nil;
end

GroupCalendar_cSortByFlags =
{
	Date = {Class = true, Rank = false},
	Rank = {Class = true, Rank = true},
	Name = {Class = false, Rank = false, Name = true},
	
	Status = {Class = true, Rank = false},
	ClassRank = {Class = true, Rank = true},
	DateRank = {Class = true, Rank = true},
};

function CalendarAttendanceList_SortIntoCategories(pAttendanceList, pGetItemCategoryFunction, pCategoryType)
	-- Clear the existing categories
	
	pAttendanceList.Categories = {};
	pAttendanceList.SortedCategories = {};
	
	local	vTotalAttendees = 0;
	
	for vName, vItem in pairs(pAttendanceList.Items) do
		local	vCategoryID = pGetItemCategoryFunction(vItem, pCategoryType);
		if vCategoryID then
			if vCategoryID ~= "NO" then
				vTotalAttendees = vTotalAttendees + 1;
			end
			CalendarAttendanceList_AddItem(pAttendanceList, pGetItemCategoryFunction(vItem, pCategoryType), vItem, pCategoryType);
		end
	end
	
	pAttendanceList.NumAttendees = vTotalAttendees;
end

function CalendarAttendanceList_GetRSVPStatusCategory(pItem)
	-- Skip RSVPs which are supposed to be ignored
	
	if pItem.mStatus == "-"
	or pItem.mStatus == "C" then
		return nil;
	end
	
	if pItem.mStatus == "N" then
		return "NO";	
	elseif pItem.mStatus == "S" then
		return "STANDBY";
	elseif pItem.mStatus == "Q" then
		return "QUEUED";
	else
		return "YES";
	end
end

function CalendarAttendanceList_GetRSVPClassCategory(pItem)
	local	vCategoryID = CalendarAttendanceList_GetRSVPStatusCategory(pItem);
	
	if not vCategoryID then
		return nil;
	end
	
	if vCategoryID ~= "YES" then
		return vCategoryID;
	end
	
	if pItem.mClassCode then
		return pItem.mClassCode;
	end
	
	return "?";
end

function CalendarAttendanceList_GetRSVPRoleCategory(pItem)
	local	vCategoryID = CalendarAttendanceList_GetRSVPStatusCategory(pItem);
	
	if not vCategoryID then
		return nil;
	end

	if vCategoryID ~= "YES" then
		return vCategoryID;
	end
	
	if pItem.mRole then
		return pItem.mRole;
	end
	
	return "?";
end

function CalendarAttendanceList_GetRSVPRankCategory(pItem)
	local	vCategoryID = CalendarAttendanceList_GetRSVPStatusCategory(pItem);
	
	if not vCategoryID then
		return nil;
	end
	
	if vCategoryID ~= "YES" then
		return vCategoryID;
	end
	
	vCategoryID = pItem.mGuildRank;
	
	if vCategoryID then
		return vCategoryID;
	end
	
	return "?";
end

function CalendarAttendanceList_AddEventAttendanceItems(pAttendanceList, pDatabase, pEvent)
	if not pEvent.mAttendance then
		return;
	end
	
	for vAttendeeName, vRSVP in pairs(pEvent.mAttendance) do		
		pAttendanceList.Items[vAttendeeName] = vRSVP;
	end
end

function CalendarEvent_GetAttendanceCounts(pDatabase, pEvent, pCategoryType)
	local	vAttendanceList = CalendarAttendanceList_New();

	-- Fill in the items list
	
	CalendarAttendanceList_AddEventAttendanceItems(vAttendanceList, pDatabase, pEvent);
	
	--CalendarAttendanceList_AddPendingRequests(vAttendanceList, pDatabase, pEvent);
	-- Sort into categories
	
	local	vGetItemCategoryFunction;
	
	if pCategoryType == gCategoryType_Class then
		vGetItemCategoryFunction = CalendarAttendanceList_GetRSVPClassCategory;
	elseif pCategoryType == gCategoryType_Role then
		vGetItemCategoryFunction = CalendarAttendanceList_GetRSVPRoleCategory;
	else
		vGetItemCategoryFunction = CalendarAttendanceList_GetRSVPStatusCategory;
	end

	CalendarAttendanceList_SortIntoCategories(vAttendanceList, vGetItemCategoryFunction, pCategoryType);
	
	-- Add pending requests
	
	-- CalendarAttendanceList_AddPendingRequests(vAttendanceList, pDatabase, pEvent);
	
	-- Calculate class totals
	
	CalendarAttendanceList_CalculateClassTotals(vAttendanceList, CalendarAttendanceList_RSVPIsAttending);
	
	-- Calculate role totals
	CalendarAttendanceList_CalculateRoleTotals(vAttendanceList, CalendarAttendanceList_RSVPIsAttending);

	-- Done
	
	return vAttendanceList;
end

function CalendarEvent_SortAttendanceCounts(pAttendanceCounts, pSortBy, pCategoryType)
	local	vSortByClass, vSortByRank, vSortByName;
	
	if pSortBy then
		local	vSortByFlags = GroupCalendar_cSortByFlags[pSortBy];
		
		if not vSortByFlags then
			Calendar_ErrorMessage("CalendarEvent_SortAttendanceCounts: Unknown sort "..pSortBy);
			return;
		end
		
		vSortByClass = vSortByFlags.Class;
		vSortByRank = vSortByFlags.Rank;
		vSortByName = vSortByFlags.Name;
	else
		vSortByClass = EventDatabase_IsQuestingEventType(pEvent.mType);
		vSortByRank = false;
		vSortByName = true;
	end
	
	-- Sort the categories
	if pCategoryType == gCategoryType_Role then
		table.sort(pAttendanceCounts.SortedCategories, EventDatabase_CompareRoleCodes);
	elseif vSortByClass then
		table.sort(pAttendanceCounts.SortedCategories, EventDatabase_CompareClassCodes);
	else
		table.sort(pAttendanceCounts.SortedCategories, EventDatabase_CompareRankCodes);
	end
	
	-- Sort the attendance within each category
	
	local	vCompareFunction;
	
	if vSortByName then
		vCompareFunction = EventDatabase_CompareRSVPsByName;
	elseif vSortByClass and vSortByRank then
		vCompareFunction = EventDatabase_CompareRSVPsByRankAndDate;
	else
		vCompareFunction = EventDatabase_CompareRSVPsByDate;
	end
	
	if vSortByClass and vSortByRank then
	end
	
	for vCategory, vClassInfo in pairs(pAttendanceCounts.Categories) do
		table.sort(vClassInfo.mAttendees, vCompareFunction);
	end
end

function EventAvailableSlots_InitializeFromLimits(pLimits)
	local	vAvailableSlots = {ClassInfo = {}};
	local	vMinTotal = 0;
	
	for vClassCode, vClassCodeInfo in pairs(gGroupCalendar_ClassInfoByClassCode) do
		local	vClassAvailable = nil;
		local	vClassExtrasAvailable = nil;
		
		if pLimits
		and pLimits.mClassLimits then
			local	vClassLimits = pLimits.mClassLimits[vClassCode];
			
			if vClassLimits then
				if vClassLimits.mMin then
					vClassAvailable = vClassLimits.mMin;
					
					if vClassAvailable < 0 then
						vClassAvailable = 0;
					end
					
					vMinTotal = vMinTotal + vClassLimits.mMin;
				end
				
				if vClassLimits.mMax then
					vClassExtrasAvailable = vClassLimits.mMax;
					
					if vClassAvailable then
						vClassExtrasAvailable = vClassExtrasAvailable - vClassAvailable;
					end
					
					if vClassExtrasAvailable < 0 then
						vClassExtrasAvailable = 0;
					end
				end
				
				vClassMax = vClassLimits.mMax;
			end
		end
		
		if vClassAvailable
		or vClassExtrasAvailable then
			vAvailableSlots.ClassInfo[vClassCode] = {};
			vAvailableSlots.ClassInfo[vClassCode].Available = vClassAvailable;
			vAvailableSlots.ClassInfo[vClassCode].ExtrasAvailable = vClassExtrasAvailable;
		end
	end
	
	if pLimits
	and pLimits.mMaxAttendance then
		vAvailableSlots.TotalExtras = pLimits.mMaxAttendance - vMinTotal;
		if vAvailableSlots.TotalExtras < 0 then
			vAvailableSlots.TotalExtras = 0;
		end
	else
		vAvailableSlots.TotalExtras = nil;
	end
	
	return vAvailableSlots;
end

function CalendarEvent_PlayerClassAdded(pAvailableSlots, pClassCode)
	CalendarEvent_PlayerClassMultiAdded(pAvailableSlots, pClassCode, 1);
end

function CalendarEvent_PlayerClassMultiAdded(pAvailableSlots, pClassCode, pNumAdded)
	local	vNumAdded = pNumAdded;
	local	vClassInfo = pAvailableSlots.ClassInfo[pClassCode];
	
	if vNumAdded == 0 then	
		return;
	end
	
	-- If the class hasn't reached its minimum yet then accept the request
	
	if vClassInfo
	and vClassInfo.Available
	and vClassInfo.Available > 0 then
		local	vAvailableUsed = vNumAdded;
		
		if vAvailableUsed > vClassInfo.Available then
			vAvailableUsed = vClassInfo.Available;
		end
		
		vClassInfo.Available = vClassInfo.Available - vAvailableUsed;
		vNumAdded = vNumAdded - vAvailableUsed;
		
		if vNumAdded == 0 then
			return;
		end
	end
	
	-- Nothing to do if there are no limits
	
	if not pAvailableSlots.TotalExtras then
		return;
	end
	
	-- Have to bail if total extras is now zero
	
	if pAvailableSlots.TotalExtras == 0 then
		return;
	end
	
	-- Decrease the space for the class
	
	if vClassInfo
	and vClassInfo.ExtrasAvailable
	and vClassInfo.ExtrasAvailable > 0 then
		if vNumAdded > vClassInfo.ExtrasAvailable then
			vNumAdded = vClassInfo.ExtrasAvailable;
		end
		
		vClassInfo.ExtrasAvailable = vClassInfo.ExtrasAvailable - vNumAdded;
	end
	
	-- Decrease the total available extras
	
	pAvailableSlots.TotalExtras = pAvailableSlots.TotalExtras - vNumAdded;
end

function EventAvailableSlots_AcceptPlayer(pAvailableSlots, pClassCode)
	local	vClassInfo = pAvailableSlots.ClassInfo[pClassCode];

	-- If the class hasn't reached its minimum yet then accept the request
	
	if vClassInfo
	and vClassInfo.Available
	and vClassInfo.Available > 0 then
		vClassInfo.Available = vClassInfo.Available - 1;
		return true;
	end
	
	-- If the minimum has been reached and the extra slots haven't all
	-- been filled then accept the request
	
	if pAvailableSlots.TotalExtras then
		-- Put them on standby if the extras slots have all been filled
		
		if pAvailableSlots.TotalExtras == 0 then
			return false;
		end
		
		-- If the class has a max and it's been reached then put them
		-- on standby
		
		if vClassInfo
		and vClassInfo.ExtrasAvailable then
			if vClassInfo.ExtrasAvailable == 0 then
				return false;
			end
			
			vClassInfo.ExtrasAvailable = vClassInfo.ExtrasAvailable - 1;
		end
		
		pAvailableSlots.TotalExtras = pAvailableSlots.TotalExtras - 1;
		return true;
	end
	
	-- No limits at all, just accept them
	
	return true;
end

function EventAvailableSlots_CountSlots(pDatabase, pEvent)
	local	vAvailableSlots = EventAvailableSlots_InitializeFromLimits(pEvent.mLimits);
	local	pCategoryType = gCategoryType_Role; -- Use radio button here instead of hard coding to role
	local	vAttendanceCounts = CalendarEvent_GetAttendanceCounts(pDatabase, pEvent, pCategoryType);
	
	for vCategory, vClassInfo in pairs(vAttendanceCounts.Categories) do
		if vCategory ~= "NO"
		and vCategory ~= "STANDBY" then
			CalendarEvent_PlayerClassMultiAdded(vAvailableSlots, vCategory, table.getn(vClassInfo.mAttendees));
		end
	end
	
	return vAvailableSlots;
end

function EventDatabase_GetRSVPOriginalDateTime(pRSVP)
	if pRSVP.mOriginalDate then
		return pRSVP.mOriginalDate, pRSVP.mOriginalTime;
	else
		return pRSVP.mDate, pRSVP.mTime;
	end
end

function EventDatabase_CompareRSVPsByDate(pRSVP1, pRSVP2)
	local	vRSVP1Date, vRSVP1Time = EventDatabase_GetRSVPOriginalDateTime(pRSVP1);
	local	vRSVP2Date, vRSVP2Time = EventDatabase_GetRSVPOriginalDateTime(pRSVP2);

	if not vRSVP1Date then
		return false;
	elseif not vRSVP2Date then
		return true;
	end
	
	if vRSVP1Date < vRSVP2Date then
		return true;
	elseif vRSVP1Date > vRSVP2Date then
		return false;
	elseif vRSVP1Time ~= vRSVP2Time then
		return vRSVP1Time < vRSVP2Time;
	else
		return EventDatabase_CompareRSVPsByName(pRSVP1, pRSVP2);
	end
end

function EventDatabase_CompareRSVPsByName(pRSVP1, pRSVP2)
	return pRSVP1.mName < pRSVP2.mName;
end

function EventDatabase_CompareRSVPsByRankAndDate(pRSVP1, pRSVP2)
	local	vRank1 = pRSVP1.mGuildRank;
	local	vRank2 = pRSVP2.mGuildRank;
	
	if not vRank1 then
		if not vRank2 then
			return EventDatabase_CompareRSVPsByDate(pRSVP1, pRSVP2);
		else
			return false;
		end
	elseif not vRank2 then
		return true;
	end
	
	if vRank1 == vRank2 then
		return EventDatabase_CompareRSVPsByDate(pRSVP1, pRSVP2);
	else
		return vRank1 < vRank2;
	end
end

Calendar_cClassCodeSortOrder =
{
	WHISPERS = 4,
	PENDING = 3,
	QUEUED = 2,
	YES = 1,
	STANDBY = -1,
	NO = -2,
};

function EventDatabase_CompareClassCodes(pClassCode1, pClassCode2)
	local	vSortPriority1 = Calendar_cClassCodeSortOrder[pClassCode1];
	local	vSortPriority2 = Calendar_cClassCodeSortOrder[pClassCode2];
	
	if not vSortPriority1 then
		if not vSortPriority2 then
			return EventDatabase_GetClassByClassCode(pClassCode1) < EventDatabase_GetClassByClassCode(pClassCode2);
		else
			return vSortPriority2 < 0;
		end
	elseif not vSortPriority2 then
		return vSortPriority1 > 0;
	else
		return vSortPriority1 > vSortPriority2;
	end
end

function EventDatabase_CompareRoleCodes(pRoleCode1, pRoleCode2)
	local	vSortPriority1 = Calendar_cClassCodeSortOrder[pRoleCode1];
	local	vSortPriority2 = Calendar_cClassCodeSortOrder[pRoleCode2];
	
	if not vSortPriority1 then
		if not vSortPriority2 then
			return EventDatabase_GetRoleByRoleCode(pRoleCode1) < EventDatabase_GetRoleByRoleCode(pRoleCode2);
		else
			return vSortPriority2 < 0;
		end
	elseif not vSortPriority2 then
		return vSortPriority1 > 0;
	else
		return vSortPriority1 > vSortPriority2;
	end
end

function EventDatabase_CompareRankCodes(pRank1, pRank2)
	local	vIsRank1 = type(pRank1) == "number";
	local	vIsRank2 = type(pRank2) == "number";
	
	if vIsRank1 and vIsRank2 then
		return pRank1 < pRank2;
	end
	
	if not vIsRank1 then
		if not vIsRank2 then
			return EventDatabase_CompareClassCodes(pRank1, pRank2);
		else
			return false;
		end
	end
	
	return true;
end

function EventDatabase_CreatePlayerRSVP(
				pDatabase, pEvent,
				pPlayerName,
				pPlayerRace, pPlayerClass, pPlayeLevel,
				pStatus,
				pComment,
				pGuild,
				pGuildRank,
				pRole)
	local	vDate, vTime60 = EventDatabase_GetServerDateTime60Stamp();
	local	vAlts = nil;	
	
	return
	{
		mName = pPlayerName,		
		mDate = vDate,
		mTime = vTime60,
		mOriginalDate = vDate,
		mOriginalTime = vTime60,
		mStatus = pStatus,
		mComment = pComment,
		mRaceCode = pPlayerRace,
		mClassCode = pPlayerClass,
		mLevel = pPlayeLevel,
		mGuild = pGuild,
		mGuildRank = pGuildRank,
		mRole = pRole
	};
end

function EventDatabase_PlayerLevelChanged(pPlayerLevel)

end

function EventDatabase_PlayerIsAttendingEvent(pPlayerName, pEvent)
	if pEvent.mAttendance then
		for vPlayerName, vRSVP in pairs(pEvent.mAttendance) do
			if vPlayerName == pPlayerName and vRSVP.mStatus == "Y" then
				return true;
			end
		end
	end

	return false;
end

function EventDatabase_PlayerIsQualifiedForEvent(pEvent, pPlayerLevel)
	if not pPlayerLevel then
		return false;
	end
	
	if pEvent.mMinLevel and
	pPlayerLevel < pEvent.mMinLevel then
		return false;
	end
	
	if pEvent.mMaxLevel and
	pPlayerLevel > pEvent.mMaxLevel then
		return false;
	end
	
	return true;
end

function EventDatabase_RescheduleEvent(pDatabase, pEvent, pNewDate)
	local	vNewEvent = EventDatabase_NewEvent(pDatabase, pNewDate, false);
	
	vNewEvent.mType = pEvent.mType;
	vNewEvent.mTitle = pEvent.mTitle;

	vNewEvent.mTime = pEvent.mTime;
	vNewEvent.mDuration = pEvent.mDuration;

	vNewEvent.mDescription = pEvent.mDescription;

	vNewEvent.mMinLevel = pEvent.mMinLevel;
	vNewEvent.mAttendance = pEvent.mAttendance;

	EventDatabase_AddEvent(pDatabase, vNewEvent);

	return EventDatabase_DeleteEvent(pDatabase, pEvent, true);
end

function EventDatabase_DeleteOldEvents(pDatabase)
	if not pDatabase.Events then
		return;
	end

	for vDate, vEvents in pairs(pDatabase.Events) do

		if vDate < gGroupCalendar_MinimumEventDate then
			-- Remove or reschedule the events for self date

			local	vNumEvents = table.getn(vEvents);
			local	vEventIndex = 1;
			
			for vIndex = 1, vNumEvents do
				local	vEvent = vEvents[vEventIndex];
				
				--if vEvent.mType == "Birth" then
				--	Calendar_DebugMessage("GroupCalendar: Rescheduling birthday event");
					
				--	local	vMonth, vDay, vYear = Calendar_ConvertDateToMDY(vDate);
				--	vYear = vYear + 1;
				--	local	vNewDate = Calendar_ConvertMDYToDate(vMonth, vDay, vYear);
					
				--	if not EventDatabase_RescheduleEvent(pDatabase, vEvent, vNewDate) then
				--		Calendar_DebugMessage("GroupCalendar: Can't reschedule event: Unknown error");
				--		vEventIndex = vEventIndex + 1;
				--	end
				--else
				if not EventDatabase_DeleteEvent(pDatabase, vEvent, true) then

					Calendar_DebugMessage("GroupCalendar: Can't delete old event: Unknown error");
					vEventIndex = vEventIndex + 1;
				end
			end
		end
	end
end

function EventDatabase_RemoveSavedInstanceEvents(pDatabase)
	if pDatabase then
		local pCutoffDate, pCutoffTime = Calendar_GetCurrentServerDateTime();

		for vDate, vSchedule in pairs(pDatabase.Events) do
			if not pCutoffDate or vDate <= pCutoffDate then
			
				local	vEventIndex = 1;
				local	vNumEvents = table.getn(vSchedule);
			
				while vEventIndex <= vNumEvents do
					local	vEvent = vSchedule[vEventIndex];

					if not pCutoffDate or vDate < pCutoffDate or (vDate == pCutoffDate and vEvent.mTime < pCutoffTime) then -- EventDatabase_IsDungeonResetEventType(vEvent.mType)
					
						EventDatabase_DeleteEvent(pDatabase, vEvent, true);
						vNumEvents = vNumEvents - 1;
					else
						vEventIndex = vEventIndex + 1;
					end
				end
			end
		end
	end
end

function EventDatabase_RemoveSavedInstanceEventsByType(pDatabase, pType)	
	if pDatabase and pType then
		for vDate, vSchedule in pairs(pDatabase.Events) do		
			local	vEventIndex = 1;
			local	vNumEvents = table.getn(vSchedule);
			
			while vEventIndex <= vNumEvents do
				local	vEvent = vSchedule[vEventIndex];

				if vEvent.mType == pType then
					
					EventDatabase_DeleteEvent(pDatabase, vEvent, true);
					vNumEvents = vNumEvents - 1;
				else
					vEventIndex = vEventIndex + 1;
				end
			end		
		end
	end
end

function EventDatabase_RemoveTradeskillEventByType(pDatabase, pEventType)
	for vDate, vSchedule in pairs(pDatabase.Events) do
		local	vEventIndex = 1;
		local	vNumEvents = table.getn(vSchedule);
		
		while vEventIndex <= vNumEvents do
			local	vEvent = vSchedule[vEventIndex];
			
			if vEvent.mType == pEventType then
				EventDatabase_DeleteEvent(pDatabase, vEvent, true);
				vNumEvents = vNumEvents - 1;
			else
				vEventIndex = vEventIndex + 1;
			end
		end
	end
end

function EventDatabase_ScheduleResetEvent(pDatabase, pType, pResetDate, pResetTime)
	-- See if the event already exists
	local	vSchedule = pDatabase.Events[pResetDate];
	
	if vSchedule then
		for vEventIndex, vEvent in pairs(vSchedule) do
			if vEvent.mType == pType then
				-- Just return if it's already the right time
				
				if vEvent.mTime == pResetTime then
					return;
				
				-- Otherwise delete it and schedule a new one
				
				else
					EventDatabase_DeleteEvent(pDatabase, vEvent, true);
					break;
				end
			end
		end
	end
	
	-- Schedule a new reset event
	
	local	vEvent = EventDatabase_NewEvent(pDatabase, pResetDate, true);
	
	vEvent.mType = pType;
	vEvent.mPrivate = true;
	vEvent.mTime = pResetTime;
	vEvent.mDuration = nil;
	
	EventDatabase_AddEvent(pDatabase, vEvent);
end

function EventDatabase_ScheduleSavedInstanceEvents()
	
	EventDatabase_RemoveSavedInstanceEvents(gGroupCalendar_UserDatabase);
	
	--
	
	local	vNumSavedInstances = GetNumSavedInstances();

	for vIndex = 1, vNumSavedInstances do
		vInstanceName, vInstanceID, vInstanceResetSeconds = GetSavedInstanceInfo(vIndex);
		
		local	vServerResetDate, vServerResetTime = Calendar_GetServerDateTimeFromSecondsOffset(tonumber(vInstanceResetSeconds));
		
		EventDatabase_ScheduleSavedInstanceEvent(gGroupCalendar_UserDatabase, vInstanceName, vServerResetDate, vServerResetTime);
	end
end

function EventDatabase_ScheduleSavedInstanceEvent(pDatabase, pName, pResetDate, pResetTime)
	local	vType, vEventInfo = EventDatabase_LookupDungeonResetEventTypeByName(pName);
	
	if not vType then
		Calendar_DebugMessage("GroupCalendar: Can't schedule reset event for "..pName..": The instance name is not recognized");
		return;
	end
	
	-- Clear all existing entries
	EventDatabase_RemoveSavedInstanceEventsByType(gGroupCalendar_UserDatabase, vType);

	local	vNumEvents;
	local	vFrequency;
	
	if vEventInfo.frequency then
		vNumEvents = 4;
		vFrequency = vEventInfo.frequency;
	else
		vNumEvents = 1;
	end
	
	local	vDate = pResetDate;
	local	vTime = pResetTime;
	
	for vIndex = 1, vNumEvents do
		EventDatabase_ScheduleResetEvent(pDatabase, vType, vDate, vTime);
		
		if vEventInfo.frequency then
			vDate = Calendar_AddDays(vDate, vEventInfo.frequency);
		end
	end
end

function EventDatabase_ScheduleTradeskillCooldownEvent(pDatabase, pTradeskillID, pCooldownSeconds)
	local	vType = EventDatabase_LookupTradeskillEventTypeByID(pTradeskillID);
	local	vResetDate, vResetTime = Calendar_GetServerDateTimeFromSecondsOffset(pCooldownSeconds);
	
	EventDatabase_RemoveTradeskillEventByType(pDatabase, vType);
	EventDatabase_ScheduleResetEvent(pDatabase, vType, vResetDate, vResetTime);
end

function EventDatabase_UpdateTradeskillCooldown(pDatabase, pTradeskillID)
	local	vCooldown = Calendar_GetTradeskillCooldown(pTradeskillID);
	
	if vCooldown then
		EventDatabase_ScheduleTradeskillCooldownEvent(pDatabase, pTradeskillID, vCooldown)
	end
end

function EventDatabase_UpdateCurrentTradeskillCooldown()
	local	vTradeskillName, vCurrentLevel, vMaxLevel = GetTradeSkillLine();
	
	if not vTradeskillName then
		return;
	end
	
	local	vTradeskillID = Calendar_LookupTradeskillIDByName(vTradeskillName);
	
	if not vTradeskillID then
		return;
	end
	
	EventDatabase_UpdateTradeskillCooldown(gGroupCalendar_UserDatabase, vTradeskillID);
end


