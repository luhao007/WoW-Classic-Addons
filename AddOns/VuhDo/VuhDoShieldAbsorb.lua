local _;
local select = select;
local type = type;

local UnitGetTotalAbsorbs = VUHDO_unitGetTotalAbsorbs;

local VUHDO_SHIELDS = {
	[17] = 30,    -- Power Word: Shield (rank 1)
	[592] = 30,   -- Power Word: Shield (rank 2)
	[600] = 30,   -- Power Word: Shield (rank 3)
	[3747] = 30,  -- Power Word: Shield (rank 4)
	[6056] = 30,  -- Power Word: Shield (rank 5)
	[6066] = 30,  -- Power Word: Shield (rank 6)
	[10898] = 30, -- Power Word: Shield (rank 7)
	[10899] = 30, -- Power Word: Shield (rank 8)
	[10900] = 30, -- Power Word: Shield (rank 9)
	[10901] = 30, -- Power Word: Shield (rank 10)
	[25217] = 30, -- Power Word: Shield (rank 11)
	[25218] = 30, -- Power Word: Shield (rank 12)
	[48065] = 30, -- Power Word: Shield (rank 13)
	[48066] = 30, -- Power Word: Shield (rank 14)
	[56160] = 30, -- Glyph of Power Word: Shield
}


--
local VUHDO_PUMP_SHIELDS = {
}


-- HoTs which we want to explicitly update on SPELL_AURA_APPLIED 
-- This avoids any display delays on contingent auras (eg. Atonement)
local VUHDO_IMMEDIATE_HOTS = {
	[VUHDO_SPELL_ID.ATONEMENT] = true,
}



local VUHDO_ABSORB_DEBUFFS = {
	[109379] = function(aUnit) return 200000, 5 * 60; end, -- Searing Plasma
	[105479] = function(aUnit) return 200000, 5 * 60; end,

	[110214] = function(aUnit) return 280000, 2 * 60; end, -- Consuming Shroud

	-- Patch 6.2 - Hellfire Citadel
	[189030] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_BEFOULED)), 10 * 60; end, -- Fel Lord Zakuun
	[189031] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_BEFOULED)), 10 * 60; end, -- Fel Lord Zakuun
	[189032] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_BEFOULED)), 10 * 60; end, -- Fel Lord Zakuun
	[180164] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_TOUCH_OF_HARM)), 10 * 60; end, -- Tyrant Velhari
	[180166] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_TOUCH_OF_HARM)), 10 * 60; end, -- Tyrant Velhari

	-- Patch 7.0 - Legion
	[221772] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_OVERFLOW)), 1 * 60; end, -- Mythic+ affix

	-- Patch 7.1 - Legion - Trial of Valor
	[228253] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_SHADOW_LICK)), 10 * 60; end, -- Shadow Lick
	[232450] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_CORRUPTED_AXION)), 30; end, -- Corrupted Axion

	-- Patch 7.1.5 - Legion - Nighthold
	[206609] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_TIME_RELEASE)), 30; end, -- Chronomatic Anomaly Time Release
	[219964] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_TIME_RELEASE)), 30; end, -- Chronomatic Anomaly Time Release Geen
	[219965] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_TIME_RELEASE)), 30; end, -- Chronomatic Anomaly Time Release Yellow
	[219966] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_TIME_RELEASE)), 30; end, -- Chronomatic Anomaly Time Release Red

	-- Patch 7.2.5 - Legion - Tomb of Sargeras
	[233263] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_EMBRACE_OF_THE_ECLIPSE)), 12; end, -- Sisters Embrace of the Eclipse

	-- Patch 7.3 - Legion - Antorus, The Burning Throne
	[245586] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_CHILLED_BLOOD)), 10; end, -- Coven Chilled Blood

	-- Patch 8.0 - Battle for Azeroth - Uldir
	[265206] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_IMMUNOSUPPRESSION)), 10 * 60; end, -- Vectis Immunosuppression

	-- Patch 8.0 - Battle for Azeroth - The Underrot
	[278961] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_DECAYING_MIND)), 30; end, -- Diseased Lasher Decaying Mind

	-- Patch 8.1.5 - Battle for Azeroth - Crucible of Storms
	[284722] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_UMBRAL_SHELL)), 10 * 60; end, -- Uu'nat Umbral Shell
	[286771] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_UMBRAL_SHELL)), 10 * 60; end, -- Uu'nat Umbral Shell

	-- Patch 8.3.0 - Battle for Azeroth - Ny'alotha
	[306184] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_UNLEASHED_VOID)), 40; end, -- Unleashed Void

	-- Patch 9.0.2 - Shadowlands - Castle Nathria
	[338600] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_CLOAK_OF_FLAMES)), 10 * 60; end, -- Cloak of Flames
	[343026] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_CLOAK_OF_FLAMES)), 10 * 60; end, -- Cloak of Flames
	[337859] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_CLOAK_OF_FLAMES)), 10 * 60; end, -- Cloak of Flames

	-- Patch 9.0.2 - Shadowlands - Necrotic Wake
	[320462] = function(aUnit) return select(18, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_NECROTIC_BOLT)), 1 * 60; end, -- Necrotic Bolt
	[320170] = function(aUnit) return select(18, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_NECROTIC_BOLT)), 2 * 60; end, -- Necrotic Bolt 

	-- Patch 9.0.2 - Shadowlands - Theater of Pain
	[330784] = function(aUnit) return select(18, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_NECROTIC_BOLT)), 1 * 60; end, -- Necrotic Bolt
	[330868] = function(aUnit) return select(18, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_NECROTIC_BOLT_VOLLEY)), 1 * 60; end, -- Necrotic Bolt Volley

	-- Patch 9.0.2 - Death Knight ability
	[223929] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_NECROTIC_WOUND)), 18; end, -- Necrotic Wound 

	-- Patch 9.1.0 - Shadowlands - Sanctum of Domination
	-- neither of these Sanctum debuff absorbs tracked the usual way (missing SPELL_HEAL etc. events w/ absorb amount), disable for now
	--[347704] = function(aUnit) return select(18, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_VEIL_OF_DARKNESS)), 10 * 60; end, -- Sylvanas Veil of Darkness
	--[351091] = function(aUnit) return select(17, VUHDO_unitDebuff(aUnit, VUHDO_SPELL_ID.DEBUFF_DESTABILIZE)), 6; end, -- Mawsworn Hopebreaker Destabilize

	--[79105] = function(aUnit) return 280000, 60 * 60; end, -- @TESTING PW:F
};



local sMissedEvents = {
	["SWING_MISSED"] = true,
	["RANGE_MISSED"] = true,
	["SPELL_MISSED"] = true,
	["SPELL_PERIODIC_MISSED"] = true,
	["ENVIRONMENTAL_MISSED"] = true
};



local VUHDO_SHIELD_LEFT = { };
setmetatable(VUHDO_SHIELD_LEFT, VUHDO_META_NEW_ARRAY);
local VUHDO_SHIELD_LEFT_TEMP = { };
setmetatable(VUHDO_SHIELD_LEFT_TEMP, VUHDO_META_NEW_ARRAY);
local VUHDO_SHIELD_SIZE = { };
setmetatable(VUHDO_SHIELD_SIZE, VUHDO_META_NEW_ARRAY);
local VUHDO_SHIELD_EXPIRY = { };
setmetatable(VUHDO_SHIELD_EXPIRY, VUHDO_META_NEW_ARRAY);
local VUHDO_SHIELD_LAST_SOURCE_GUID = { };
setmetatable(VUHDO_SHIELD_LAST_SOURCE_GUID, VUHDO_META_NEW_ARRAY);


local VUHDO_PLAYER_SHIELDS = { };


--
local pairs = pairs;
local ceil = ceil;
local floor = floor;
local GetTime = GetTime;
local select = select;
local GetSpellInfo = GetSpellInfo;



--
local VUHDO_PLAYER_GUID = -1;
local sIsPumpAegis = false;
local sShowAbsorb = false;
function VUHDO_shieldAbsorbInitLocalOverrides()
	VUHDO_PLAYER_GUID = UnitGUID("player");
	sShowAbsorb = VUHDO_PANEL_SETUP["BAR_COLORS"]["HOTS"]["showShieldAbsorb"];
	sIsPumpAegis = VUHDO_PANEL_SETUP["BAR_COLORS"]["HOTS"]["isPumpDivineAegis"];
end


--
local function VUHDO_initShieldValue(aUnit, aShieldName, anAmount, aDuration)
	if (anAmount or 0) == 0 then
		--VUHDO_xMsg("ERROR: Failed to init shield " .. aShieldName .. " on " .. aUnit, anAmount);
		return;
	end

	VUHDO_SHIELD_LEFT[aUnit][aShieldName] = anAmount;

	if sIsPumpAegis and VUHDO_PUMP_SHIELDS[aShieldName] then
		VUHDO_SHIELD_SIZE[aUnit][aShieldName] = VUHDO_RAID["player"]["healthmax"] * VUHDO_PUMP_SHIELDS[aShieldName];
	elseif aShieldName == VUHDO_SPELL_ID.SPIRIT_SHELL then
		-- as of 9.0.5 Priest 'Spirit Shell' cap is 11 times the caster's current intellect
		VUHDO_SHIELD_SIZE[aUnit][aShieldName] = select(1, UnitStat("player", 4)) * 11;
	else
		VUHDO_SHIELD_SIZE[aUnit][aShieldName] = anAmount;
	end

	VUHDO_SHIELD_EXPIRY[aUnit][aShieldName] = GetTime() + aDuration;
	--VUHDO_xMsg("Init shield " .. aShieldName .. " on " .. aUnit .. " for " .. anAmount .. " / " .. VUHDO_SHIELD_SIZE[aUnit][aShieldName], aDuration);
end



--
local function VUHDO_updateShieldValue(aUnit, aShieldName, anAmount, aDuration, aExpirationTime)
	if not VUHDO_SHIELD_SIZE[aUnit][aShieldName] then
		--VUHDO_xMsg("ERROR: Failed to update shield " .. aShieldName .. " on " .. aUnit);
		return;
	end

	if (anAmount or 0) == 0 then
		--VUHDO_xMsg("ERROR: Failed to update shield " .. aShieldName .. " on " .. aUnit, anAmount);
		return;
	end

	if aDuration then 
		VUHDO_SHIELD_EXPIRY[aUnit][aShieldName] = GetTime() + aDuration;
		
		VUHDO_SHIELD_SIZE[aUnit][aShieldName] = anAmount;
		--VUHDO_xMsg("Shield overwritten");
	elseif (aExpirationTime or 0) > VUHDO_SHIELD_EXPIRY[aUnit][aShieldName] then
		VUHDO_SHIELD_EXPIRY[aUnit][aShieldName] = aExpirationTime;
	elseif VUHDO_SHIELD_SIZE[aUnit][aShieldName] < anAmount then
		VUHDO_SHIELD_SIZE[aUnit][aShieldName] = anAmount;
	end

	VUHDO_SHIELD_LEFT[aUnit][aShieldName] = anAmount;
	--VUHDO_xMsg("Updated shield " .. aShieldName .. " on " .. aUnit .. " to " .. anAmount, aDuration);
end



--
local function VUHDO_removeShield(aUnit, aShieldName)
	if not VUHDO_SHIELD_SIZE[aUnit][aShieldName] then return; end

	VUHDO_SHIELD_SIZE[aUnit][aShieldName] = nil;
	VUHDO_SHIELD_LEFT[aUnit][aShieldName] = nil;
	VUHDO_SHIELD_EXPIRY[aUnit][aShieldName] = nil;
	VUHDO_SHIELD_LAST_SOURCE_GUID[aUnit][aShieldName] = nil;
	--VUHDO_xMsg("Removed shield " .. aShieldName .. " from " .. aUnit);
end



--
local tNow;
function VUHDO_removeObsoleteShields()
	tNow = GetTime();
	for tUnit, tAllShields in pairs(VUHDO_SHIELD_EXPIRY) do
		for tShieldName, tExpiry in pairs(tAllShields) do
			if tExpiry < tNow then
				VUHDO_removeShield(tUnit, tShieldName);
			end
		end
	end
end



--
local tInit, tValue, tSourceGuid;
function VUHDO_getShieldLeftCount(aUnit, aShield, aMode)
	tInit = sShowAbsorb and VUHDO_SHIELD_SIZE[aUnit][aShield] or 0;

	if tInit > 0 then
		tSourceGuid = VUHDO_SHIELD_LAST_SOURCE_GUID[aUnit][aShield];
		if aMode == 3 or aMode == 0
		or (aMode == 1 and tSourceGuid == VUHDO_PLAYER_GUID)
		or (aMode == 2 and tSourceGuid ~= VUHDO_PLAYER_GUID) then
			tValue = floor(4 * (VUHDO_SHIELD_LEFT[aUnit][aShield] or 0) / tInit);
			return tValue > 4 and 4 or (tValue < 1 and 1 or tValue);
		end
	end
	return 0;
end



--
local tExpirationTime;
local tRemain;
local tSpellName;
function VUHDO_updateShield(aUnit, aSpellId)

	tSpellName, _, _, _, _, tExpirationTime, _, _, _, _, _, _, _, _, _, _, tRemain = VUHDO_unitBuff(aUnit, aSpellId);

	if tRemain and "number" == type(tRemain) then
		if tRemain > 0 then
			VUHDO_updateShieldValue(aUnit, tSpellName, tRemain, nil, tExpirationTime);
		else
			VUHDO_removeShield(aUnit, tSpellName);
		end
	end

end



--
local function VUHDO_updateShields(aUnit)

	for tSpellId, _ in pairs(VUHDO_SHIELDS) do
		VUHDO_updateShield(aUnit, tSpellId);
	end

end



--
local function VUHDO_getShieldLeftAmount(aUnit, aShieldName)
	return VUHDO_SHIELD_LEFT[aUnit][aShieldName] or 0;
end



--
local tInit, tValue;
function VUHDO_getShieldPerc(aUnit, aShield)
	tInit = VUHDO_SHIELD_SIZE[aUnit][aShield] or 0;

	if tInit > 0 then
		tValue = ceil(100 * (VUHDO_SHIELD_LEFT[aUnit][aShield] or 0) / tInit);
		return tValue > 100 and 100 or tValue;
	else
		return 0;
	end
end



--
function VUHDO_getUnitOverallShieldRemain(aUnit)
	local aRemain = UnitGetTotalAbsorbs(aUnit);

	if aRemain > 0 then 
		return aRemain;
	end

	if VUHDO_SHIELD_LEFT[aUnit] then
		for _, value in pairs(VUHDO_SHIELD_LEFT[aUnit]) do
			if value then
				aRemain = aRemain + value;
			end
		end
	end

	return aRemain;
end



--
local tUnit;
local VUHDO_DEBUFF_SHIELDS = { };
local tDelta, tShieldName;
function VUHDO_parseCombatLogShieldAbsorb(aMessage, aSrcGuid, aDstGuid, aShieldName, anAmount, aSpellId, anAbsorbAmount, aHealAmount, aCritical, anAbsorbSpellName, anAbsorbSpellSchool, anAbsorbSpellDamageAmount, anAbsorbSwingDamageAmount)
	tUnit = VUHDO_RAID_GUIDS[aDstGuid];
	if not tUnit then return; end

	if sMissedEvents[aMessage] then
		VUHDO_updateShields(tUnit);
		return;
	end

	--VUHDO_Msg(aSpellId);

	--[[if ("SPELL_AURA_APPLIED" == aMessage) then
		VUHDO_xMsg(aShieldName, aSpellId);
	end]]

	if VUHDO_SHIELDS[aSpellId] then

		if "SPELL_AURA_REFRESH" == aMessage then 
			if not anAmount then -- anAmount is always nil in Wrath Classic
				anAmount = VUHDO_SHIELD_LEFT_TEMP[tUnit][aShieldName] or 0;
			end

			VUHDO_updateShieldValue(tUnit, aShieldName, anAmount, VUHDO_SHIELDS[aSpellId]);
		elseif "SPELL_AURA_APPLIED" == aMessage then 
			if not anAmount then -- anAmount is always nil in Wrath Classic
				anAmount = VUHDO_SHIELD_LEFT_TEMP[tUnit][aShieldName] or 0;
			end

			VUHDO_initShieldValue(tUnit, aShieldName, anAmount, VUHDO_SHIELDS[aSpellId]);
			VUHDO_SHIELD_LAST_SOURCE_GUID[tUnit][aShieldName] = aSrcGuid;
		elseif "SPELL_AURA_REMOVED" == aMessage
			or "SPELL_AURA_BROKEN" == aMessage
			or "SPELL_AURA_BROKEN_SPELL" == aMessage then
			VUHDO_removeShield(tUnit, aShieldName);
		elseif "SPELL_HEAL" == aMessage and aSpellId == 56160 then -- Glyph of Power Word: Shield
			anAmount = aHealAmount / 0.2; -- the glyph heal amount is 20% of the absorb amount

			if aCritical then
				anAmount = math.floor(anAmount / 1.5); -- critical heals in Wrath Classic are 150%
			end

			VUHDO_SHIELD_LEFT_TEMP[tUnit][VUHDO_SPELL_ID.POWERWORD_SHIELD] = anAmount;
		end
	elseif VUHDO_ABSORB_DEBUFFS[aSpellId] then

		if "SPELL_AURA_REFRESH" == aMessage then
			VUHDO_updateShieldValue(tUnit, aShieldName, VUHDO_ABSORB_DEBUFFS[aSpellId](tUnit));
		elseif "SPELL_AURA_APPLIED" == aMessage then
			VUHDO_initShieldValue(tUnit, aShieldName, VUHDO_ABSORB_DEBUFFS[aSpellId](tUnit));
			VUHDO_DEBUFF_SHIELDS[tUnit] = aShieldName;
		elseif "SPELL_AURA_REMOVED" == aMessage
			or "SPELL_AURA_BROKEN" == aMessage
			or "SPELL_AURA_BROKEN_SPELL" == aMessage then
			VUHDO_removeShield(tUnit, aShieldName);
			VUHDO_DEBUFF_SHIELDS[tUnit] = nil;
		end
	elseif ("SPELL_HEAL" == aMessage or "SPELL_PERIODIC_HEAL" == aMessage)
		and VUHDO_DEBUFF_SHIELDS[tUnit]
		and (tonumber(anAbsorbAmount) or 0) > 0 then
		tShieldName = VUHDO_DEBUFF_SHIELDS[tUnit];
		tDelta = VUHDO_getShieldLeftAmount(tUnit, tShieldName) - anAbsorbAmount;
		VUHDO_updateShieldValue(tUnit, tShieldName, tDelta);
	elseif "UNIT_DIED" == aMessage then
		VUHDO_SHIELD_SIZE[tUnit] = nil;
		VUHDO_SHIELD_LEFT[tUnit] = nil;
		VUHDO_SHIELD_EXPIRY[tUnit] = nil;
		VUHDO_DEBUFF_SHIELDS[tUnit] = nil;
		VUHDO_SHIELD_LAST_SOURCE_GUID[tUnit] = nil;
	elseif VUHDO_IMMEDIATE_HOTS[aShieldName] and VUHDO_ACTIVE_HOTS[aShieldName] and 
		("SPELL_AURA_APPLIED" == aMessage or "SPELL_AURA_REMOVED" == aMessage or 
		 "SPELL_AURA_REFRESH" == aMessage or "SPELL_AURA_BROKEN" == aMessage or 
		 "SPELL_AURA_BROKEN_SPELL" == aMessage) then
		VUHDO_updateAllHoTs();
		VUHDO_updateAllCyclicBouquets(true);
	elseif "SPELL_ABSORBED" == aMessage then
		-- SPELL_ABSORBED optionally includes the spell payload if triggered from what would be SPELL_DAMAGE
		-- this offsets the CLEU payload by +3
		-- see: https://wowpedia.fandom.com/wiki/COMBAT_LOG_EVENT#SPELL_ABSORBED
		if anAbsorbSpellSchool then
			tShieldName = anAbsorbSpellName;
			anAmount = anAbsorbSpellDamageAmount or 0;
		else
			tShieldName = anAbsorbAmount;
			anAmount = anAbsorbSwingDamageAmount or 0;
		end

		if VUHDO_SHIELD_LEFT[tUnit][tShieldName] then
			tDelta = VUHDO_getShieldLeftAmount(tUnit, tShieldName) - anAmount;
			VUHDO_updateShieldValue(tUnit, tShieldName, tDelta);
		end
	end

	VUHDO_updateBouquetsForEvent(tUnit, 36); -- VUHDO_UPDATE_SHIELD
	VUHDO_updateShieldBar(tUnit);
	VUHDO_updateHealAbsorbBar(tUnit);
end
