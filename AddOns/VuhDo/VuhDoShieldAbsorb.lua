local _;
local select = select;
local type = type;

local UnitGetTotalAbsorbs = VUHDO_unitGetTotalAbsorbs;

local VUHDO_SHIELDS = {
	[17] = 15, -- VUHDO_SPELL_ID.POWERWORD_SHIELD
	[47509] = 15, -- VUHDO_SPELL_ID.DIVINE_AEGIS
	[47753] = 15, -- VUHDO_SPELL_ID.DIVINE_AEGIS
	[76669] = 5, -- VUHDO_SPELL_ID.ILLUMINATED_HEALING
	[86273] = 5, -- VUHDO_SPELL_ID.ILLUMINATED_HEALING
	[11426] = 60, -- VUHDO_SPELL_ID.ICE_BARRIER
	[1463] = 60, -- VUHDO_SPELL_ID.MANA_SHIELD
	[7812] = 30, -- VUHDO_SPELL_ID.SACRIFICE
	[85285] = 15, -- VUHDO_SPELL_ID.SACRED_SHIELD
	[62606] = 10, -- VUHDO_SPELL_ID.SAVAGE_DEFENSE
        [123258] = 15, -- Power Word: Shield (Improved)
        [65148] = 15, -- VUHDO_SPELL_ID.SACRED_SHIELD (Buff) -- ok
        [114908] = 15, -- VUHDO_SPELL_ID.SPIRIT_SHELL (Buff) -- ok
        [116849] = 12, -- Life Cocoon
        [115295] = 30, -- Guard (brewmaster monk's self buff, unglyphed)
        [118604] = 30, -- Guard (brewmaster monk's black ox statue (cast on group), unglyphed)
        --[123402] = 30, -- Guard (brewmaster monk's self buff, with Glyph of Guard) - Magic damage ONLY
        --[136070] = 30, -- Guard (brewmaster monk's black ox statue (cast on group), with Glyph of Guard) - Magic damage ONLY
        [112048] = 6, -- Shield Barrier (Prot warrior)
        --[77535] = 10, -- Blood Shield (Blood DK) - Physical damage ONLY
        [108416] = 20, -- Sacrificial Pact (warlock talent)
        [114893] = 10, -- Stone Bulwark Totem (shaman talent)
}


--
local VUHDO_PUMP_SHIELDS = {
	[VUHDO_SPELL_ID.DIVINE_AEGIS] = 0.6,
	[VUHDO_SPELL_ID.SPIRIT_SHELL] = 0.6,
}


-- HoTs which we want to explicitly update on SPELL_AURA_APPLIED 
-- This avoids any display delays on contingent auras (eg. Atonement)
-- Note: if adding by spell ID table key must be a string e.g. ["17"] not [17]
local VUHDO_IMMEDIATE_HOTS = {
	[VUHDO_SPELL_ID.ATONEMENT] = true,
	["194384"] = true, -- VUHDO_SPELL_ID.ATONEMENT
}



local VUHDO_ABSORB_DEBUFFS = {
	[109379] = function() return 200000, 5 * 60; end, -- Searing Plasma
	[109362] = function() return 300000, 5 * 60; end,
	[105479] = function() return 200000, 5 * 60; end,
	[109364] = function() return 420000, 5 * 60; end,
	[109363] = function() return 280000, 5 * 60; end,

	[110598] = function() return 420000, 2 * 60; end, -- Consuming Shroud
	[110214] = function() return 280000, 2 * 60; end,

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
	["SPELL_ABSORBED"] = true
--[[
	["SWING_MISSED"] = true,
	["RANGE_MISSED"] = true,
	["SPELL_MISSED"] = true,
	["SPELL_PERIODIC_MISSED"] = true,
	["ENVIRONMENTAL_MISSED"] = true
]];
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



--
local pairs = pairs;
local ceil = ceil;
local floor = floor;
local GetTime = GetTime;
local select = select;



--
local VUHDO_updateBouquetsForEvent;
local VUHDO_updateShieldBar;
local VUHDO_updateHealAbsorbBar;
local VUHDO_PLAYER_GUID = -1;
local sIsPumpAegis = false;
local sShowAbsorb = false;
function VUHDO_shieldAbsorbInitLocalOverrides()

	VUHDO_updateBouquetsForEvent = _G["VUHDO_updateBouquetsForEvent"];
	VUHDO_updateShieldBar = _G["VUHDO_updateShieldBar"];
	VUHDO_updateHealAbsorbBar = _G["VUHDO_updateHealAbsorbBar"];

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

		if not sIsPumpAegis or not VUHDO_PUMP_SHIELDS[aShieldName] then
			VUHDO_SHIELD_SIZE[aUnit][aShieldName] = anAmount;
			--VUHDO_xMsg("Shield overwritten");
		end
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

	if not aUnit or not aShield or not aMode then
		return;
	end

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
local tUnit, tInfo;
local VUHDO_DEBUFF_SHIELDS = { };
local tDelta, tShieldName;
local tDoUpdate;
function VUHDO_parseCombatLogShieldAbsorb(aMessage, aSrcGuid, aDstGuid, aShieldName, anAmount, aSpellId, anAbsorbAmount, anAbsorbSpellId)

	tUnit = VUHDO_RAID_GUIDS[aDstGuid];

	if not tUnit then
		return;
	end

	-- only trigger a shield update on subevent SPELL_ABSORBED, no longer for *_MISSED events
	-- event optionally includes the spell payload if trigger by SPELL_DAMAGE
	-- this moves the absorb spell ID from the 16th arg (anAmount) to the 19th arg (anAbsorbSpellId)
	if sMissedEvents[aMessage] then
		if type(anAmount) == "number" then
			anAbsorbSpellId = anAmount;
		end

		if VUHDO_SHIELDS[anAbsorbSpellId] then
			VUHDO_updateShield(tUnit, anAbsorbSpellId);

			VUHDO_updateBouquetsForEvent(tUnit, 36); -- VUHDO_UPDATE_SHIELD

			VUHDO_updateShieldBar(tUnit);
		end

		return;
	end

	--VUHDO_Msg(aSpellId);

	--[[if ("SPELL_AURA_APPLIED" == aMessage) then
		VUHDO_xMsg(aShieldName, aSpellId);
	end]];

	tDoUpdate = true;

	if VUHDO_SHIELDS[aSpellId] then

		if "SPELL_AURA_REFRESH" == aMessage then 
			VUHDO_updateShieldValue(tUnit, aShieldName, anAmount, VUHDO_SHIELDS[aSpellId]);
		elseif "SPELL_AURA_APPLIED" == aMessage then 
			VUHDO_initShieldValue(tUnit, aShieldName, anAmount, VUHDO_SHIELDS[aSpellId]);
			VUHDO_SHIELD_LAST_SOURCE_GUID[tUnit][aShieldName] = aSrcGuid;
		elseif "SPELL_AURA_REMOVED" == aMessage
			or "SPELL_AURA_BROKEN" == aMessage
			or "SPELL_AURA_BROKEN_SPELL" == aMessage then
			VUHDO_removeShield(tUnit, aShieldName);
		else
			tDoUpdate = false;
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
		else
			tDoUpdate = false;
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
	elseif ((VUHDO_IMMEDIATE_HOTS[aShieldName] and VUHDO_ACTIVE_HOTS[aShieldName]) or
		(VUHDO_IMMEDIATE_HOTS[tostring(aSpellId)] and VUHDO_ACTIVE_HOTS[tostring(aSpellId)])) and
		("SPELL_AURA_APPLIED" == aMessage or "SPELL_AURA_REMOVED" == aMessage or
		"SPELL_AURA_REFRESH" == aMessage or "SPELL_AURA_BROKEN" == aMessage or
		"SPELL_AURA_BROKEN_SPELL" == aMessage) then

		tInfo = VUHDO_RAID[tUnit];

		if tInfo then
			VUHDO_updateHots(tUnit, tInfo, aShieldName, aSpellId);

			-- FIXME: why all?
			VUHDO_updateAllCyclicBouquets(true);
		else
			tDoUpdate = false;
		end
	else
		tDoUpdate = false;
	end

	if tDoUpdate then
		VUHDO_updateBouquetsForEvent(tUnit, 36); -- VUHDO_UPDATE_SHIELD

		VUHDO_updateShieldBar(tUnit);
		VUHDO_updateHealAbsorbBar(tUnit);
	end

end
