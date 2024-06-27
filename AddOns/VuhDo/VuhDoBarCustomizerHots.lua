local _;
local huge = math.huge;
local format = format;

local sIsFade;
local sIsFlashWhenLow;
local sIsWarnColor;
local sIsSwiftmend;
local sHotSetup;
local sBuffs2Hots = { };
local sHotCols;
local sHotSlots;
local sBarColors;
local sIsHotShowIcon;
local sHotSlotCfgs;
local sIsChargesIcon;
local sClipL, sClipR, sClipT, sClipB = 0, 1, 0, 1;

local sIsPlayerKnowsSwiftmend = false;
local sSwiftmendUnits = { };

VUHDO_MY_HOTS = { };
local VUHDO_MY_HOTS = VUHDO_MY_HOTS;
VUHDO_OTHER_HOTS = { };
local VUHDO_OTHER_HOTS = VUHDO_OTHER_HOTS;
VUHDO_MY_AND_OTHERS_HOTS = { };
local VUHDO_MY_AND_OTHERS_HOTS = VUHDO_MY_AND_OTHERS_HOTS;

local VUHDO_ACTIVE_HOTS = { };
local VUHDO_ACTIVE_HOTS_OTHERS = { };
local sOthersHotsInfo = { };

local VUHDO_CHARGE_TEXTURES = {
	"Interface\\AddOns\\VuhDo\\Images\\hot_stacks1", "Interface\\AddOns\\VuhDo\\Images\\hot_stacks2",
	"Interface\\AddOns\\VuhDo\\Images\\hot_stacks3", "Interface\\AddOns\\VuhDo\\Images\\hot_stacks4" };

local VUHDO_SHIELD_TEXTURES = {
	"Interface\\AddOns\\VuhDo\\Images\\shield_stacks1", "Interface\\AddOns\\VuhDo\\Images\\shield_stacks2",
	"Interface\\AddOns\\VuhDo\\Images\\shield_stacks3", "Interface\\AddOns\\VuhDo\\Images\\shield_stacks4" };

local VUHDO_CHARGE_COLORS = { "HOT_CHARGE_1", "HOT_CHARGE_2", "HOT_CHARGE_3", "HOT_CHARGE_4" };

local VUHDO_HOT_CFGS = { "HOT1", "HOT2", "HOT3", "HOT4", "HOT5", "HOT6", "HOT7", "HOT8", "HOT9", "HOT10", };


-- BURST CACHE -------------------------------------------------


local floor = floor;
local table = table;
local GetSpellCooldown = GetSpellCooldown;
local GetTime = GetTime;
local strfind = strfind;
local pairs = pairs;
local twipe = table.wipe;
local tostring = tostring;
local ForEachAura = AuraUtil.ForEachAura or VUHDO_forEachAura;
local UnpackAuraData = AuraUtil.UnpackAuraData or VUHDO_unpackAuraData;

local _G = _G;

local VUHDO_getHealthBar;
local VUHDO_getBarRoleIcon;
local VUHDO_updateAllClusterIcons;
local VUHDO_shouldScanUnit;
local VUHDO_getShieldLeftCount;
local VUHDO_resolveVehicleUnit;
local VUHDO_isPanelVisible;
local VUHDO_getHealButton;
local VUHDO_getUnitButtons;
local VUHDO_getBarIcon;
local VUHDO_getBarIconTimer;
local VUHDO_getBarIconCounter;
local VUHDO_getBarIconCharge;
local VUHDO_getBarIconClockOrStub;
local VUHDO_backColor;
local VUHDO_textColor;

local VUHDO_PANEL_SETUP;
local VUHDO_CAST_ICON_DIFF;
local VUHDO_HEALING_HOTS;
local VUHDO_RAID;
local sIsClusterIcons;
local sIsOthersHots;

function VUHDO_customHotsInitLocalOverrides()
	-- variables
	VUHDO_PANEL_SETUP = _G["VUHDO_PANEL_SETUP"];
	VUHDO_CAST_ICON_DIFF = _G["VUHDO_CAST_ICON_DIFF"];
	VUHDO_HEALING_HOTS = _G["VUHDO_HEALING_HOTS"];
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_ACTIVE_HOTS = _G["VUHDO_ACTIVE_HOTS"];
	VUHDO_ACTIVE_HOTS_OTHERS = _G["VUHDO_ACTIVE_HOTS_OTHERS"];
	-- functions
	VUHDO_getUnitButtons = _G["VUHDO_getUnitButtons"];
	VUHDO_getHealthBar = _G["VUHDO_getHealthBar"];
	VUHDO_getBarRoleIcon = _G["VUHDO_getBarRoleIcon"];
	VUHDO_updateAllClusterIcons = _G["VUHDO_updateAllClusterIcons"];
	VUHDO_shouldScanUnit = _G["VUHDO_shouldScanUnit"];
	VUHDO_getShieldLeftCount = _G["VUHDO_getShieldLeftCount"];
	VUHDO_resolveVehicleUnit = _G["VUHDO_resolveVehicleUnit"];
	VUHDO_isPanelVisible = _G["VUHDO_isPanelVisible"];
	VUHDO_getHealButton = _G["VUHDO_getHealButton"];
	VUHDO_getBarIcon = _G["VUHDO_getBarIcon"];
	VUHDO_getBarIconTimer = _G["VUHDO_getBarIconTimer"];
	VUHDO_getBarIconCounter = _G["VUHDO_getBarIconCounter"];
	VUHDO_getBarIconCharge = _G["VUHDO_getBarIconCharge"];
	VUHDO_getBarIconClockOrStub = _G["VUHDO_getBarIconClockOrStub"];
	VUHDO_backColor = _G["VUHDO_backColor"];
	VUHDO_textColor = _G["VUHDO_textColor"];

	sBarColors = VUHDO_PANEL_SETUP["BAR_COLORS"];
	sHotCols = sBarColors["HOTS"];
	sIsFade = sHotCols["isFadeOut"];
	sIsFlashWhenLow = sHotCols["isFlashWhenLow"];
	sIsWarnColor = sHotCols["WARNING"]["enabled"];
	sHotSetup = VUHDO_PANEL_SETUP["HOTS"];
	sHotSlots = VUHDO_PANEL_SETUP["HOTS"]["SLOTS"];
	sIsHotShowIcon = sHotSetup["iconRadioValue"] == 1;
	sIsChargesIcon = sHotSetup["stacksRadioValue"] == 3;
	sIsClusterIcons = VUHDO_INTERNAL_TOGGLES[16] or VUHDO_INTERNAL_TOGGLES[18]; -- -- VUHDO_UPDATE_NUM_CLUSTER -- VUHDO_UPDATE_MOUSEOVER_CLUSTER
	sIsOthersHots = VUHDO_ACTIVE_HOTS["OTHER"];

	sHotSlotCfgs = { };
	for tCnt = 1, 10 do
		sHotSlotCfgs[tCnt] = VUHDO_PANEL_SETUP["HOTS"]["SLOTCFG"][tostring(tCnt)];
	end
end

----------------------------------------------------



--
function VUHDO_hotsSetClippings(aLeft, aRight, aTop, aBottom)
	sClipL, sClipR, sClipT, sClipB = aLeft, aRight, aTop, aBottom;
end



--
local tOphEmpty = { nil, 0 };
function VUHDO_getOtherPlayersHotInfo(aUnit)
	return sOthersHotsInfo[aUnit] or tOphEmpty;
end



--
function VUHDO_setKnowsSwiftmend(aKnowsSwiftmend)
	sIsPlayerKnowsSwiftmend = aKnowsSwiftmend;
end



--
--
local tCopy = { };
local function VUHDO_copyColor(aColor)
	tCopy["R"], tCopy["G"], tCopy["B"], tCopy["O"] = aColor["R"], aColor["G"], aColor["B"], aColor["O"];
	tCopy["TR"], tCopy["TG"], tCopy["TB"], tCopy["TO"] = aColor["TR"], aColor["TG"], aColor["TB"], aColor["TO"];
	tCopy["useBackground"], tCopy["useText"], tCopy["useOpacity"] = aColor["useBackground"], aColor["useText"], aColor["useOpacity"];
	return tCopy;
end



--
local tHotBar;
local function VUHDO_customizeHotBar(aButton, aRest, anIndex, aDuration, aColor)
	tHotBar = VUHDO_getHealthBar(aButton, anIndex + 3);

	if aColor then tHotBar:SetVuhDoColor(aColor); end

	if (aDuration or 0) == 0 or not aRest then tHotBar:SetValue(0);
	else tHotBar:SetValue(aRest / aDuration); end
end



--
local tHotName;
local tDuration2;
local tChargeTexture;
local tIsChargeShown;
local tIcon;
local tTimer;
local tCounter;
local tClock;
local tDuration;
local tHotCfg;
local tIsChargeAlpha;
local tStarted;
local tClockDuration;
local tOpacity, tTextOpacity;
local tHotColor;
local tTimes;
local function VUHDO_customizeHotIcons(aButton, aHotName, aRest, aTimes, anIcon, aDuration, aShieldCharges, aColor, anIndex, aClipL, aClipR, aClipT, aClipB)

	tHotCfg = sBarColors[VUHDO_HOT_CFGS[anIndex]];
	tIcon = VUHDO_getBarIcon(aButton, anIndex);
	
	-- Noch nicht erstellt von redraw
	if not tIcon then
		return;
	end

	local VUHDO_UIFrameFlash = (sIsFlashWhenLow or tHotCfg["isFlashWhenLow"]) and _G["VUHDO_UIFrameFlash"] or function() end;
	local VUHDO_UIFrameFlashStop = (sIsFlashWhenLow or tHotCfg["isFlashWhenLow"]) and _G["VUHDO_UIFrameFlashStop"] or function() end;

	if not aRest then
		VUHDO_UIFrameFlashStop(tIcon);
		VUHDO_getBarIconFrame(aButton, anIndex):Hide();

		return;
	else
		VUHDO_getBarIconFrame(aButton, anIndex):Show();
	end

	tTimer = VUHDO_getBarIconTimer(aButton, anIndex);
	tCounter = VUHDO_getBarIconCounter(aButton, anIndex);
	tClock = VUHDO_getBarIconClockOrStub(aButton, anIndex, tHotCfg["isClock"]);
	tChargeTexture = VUHDO_getBarIconCharge(aButton, anIndex);

	if aColor and aColor["useText"] and aColor["TR"] then
		tCounter:SetTextColor(VUHDO_textColor(aColor));
	end

	if anIcon and (sIsHotShowIcon or aColor) then
		if VUHDO_ATLAS_TEXTURES[anIcon] then
			tIcon:SetAtlas(anIcon);

		else
			tIcon:SetTexture(anIcon);
		end
	end

	tIcon:SetTexCoord(aClipL or sClipL, aClipR or sClipR, aClipT or sClipT, aClipB or sClipB);
	
	aTimes = aTimes or 0;
	tIsChargeShown = sIsChargesIcon and aTimes > 0;
	
	--@TESTING
	--aTimes = floor(aRest / 3.5);

	tTimes = aTimes > 4 and 4 or aTimes;

	tIsChargeAlpha = false;

	-- FIXME: useSlotColor no longer has a clear purpose
	if aColor and aColor["useSlotColor"] then
		tHotColor = VUHDO_copyColor(tHotCfg);
	elseif aColor and (not aColor["isDefault"] or not sIsHotShowIcon) then
		tHotColor = aColor;

		if tTimes > 1 and not aColor["noStacksColor"] then
			tChargeColor = sBarColors[VUHDO_CHARGE_COLORS[tTimes]];
			if sHotCols["useColorBack"] then
				tHotColor["R"], tHotColor["G"], tHotColor["B"], tHotColor["O"]
					= tChargeColor["R"], tChargeColor["G"], tChargeColor["B"], tChargeColor["O"];
				tIsChargeAlpha = true;
			end
			if sHotCols["useColorText"] then
				tHotColor["TR"], tHotColor["TG"], tHotColor["TB"], tHotColor["TO"]
					= tChargeColor["TR"], tChargeColor["TG"], tChargeColor["TB"], tChargeColor["TO"];
			end
		end

		if tHotColor["useText"] and not sIsHotShowIcon then
			tTimer:SetTextColor(VUHDO_textColor(tHotColor));
		end

	elseif sIsWarnColor and aRest < sHotCols["WARNING"]["lowSecs"] then
		tHotColor = sHotCols["WARNING"];
		tTimer:SetTextColor(VUHDO_textColor(tHotColor));
	else
		tHotColor = VUHDO_copyColor(tHotCfg);

		-- FIXME: color swatch should set isOpacity but doesn't
		if tHotColor["O"] then
			tHotColor["useOpacity"] = true;
		end

		if sIsHotShowIcon then
			if aColor then
				tHotColor = aColor;
			else
				tHotColor["R"], tHotColor["G"], tHotColor["B"] = 1, 1, 1;
			end
		elseif tTimes <= 1 or not sHotCols["useColorText"] then
			tTimer:SetTextColor(VUHDO_textColor(tHotColor));
		end

		if tTimes > 1 then
			tChargeColor = sBarColors[VUHDO_CHARGE_COLORS[tTimes]];
			if sHotCols["useColorBack"] then
				tHotColor["R"], tHotColor["G"], tHotColor["B"], tHotColor["O"]
					= tChargeColor["R"], tChargeColor["G"], tChargeColor["B"], tChargeColor["O"];
				tIsChargeAlpha = true;
			end
			if sHotCols["useColorText"] then
				tHotColor["TR"], tHotColor["TG"], tHotColor["TB"], tHotColor["TO"]
					= tChargeColor["TR"], tChargeColor["TG"], tChargeColor["TB"], tChargeColor["TO"];
				tTimer:SetTextColor(VUHDO_textColor(tHotColor));
			end
		end
	end

	if tHotColor and (tIsChargeAlpha or tHotColor["useOpacity"]) and tHotColor["O"] then
		tOpacity = tHotColor["O"];
		tTextOpacity = tHotColor["TO"];
	else
		tOpacity = nil;
		tTextOpacity = nil;
	end

	if tHotColor and tHotColor["useBackground"] and tHotColor["R"] then
		if tOpacity then
			tIcon:SetVertexColor(tHotColor["R"], tHotColor["G"], tHotColor["B"], tOpacity);
		else
			tIcon:SetVertexColor(tHotColor["R"], tHotColor["G"], tHotColor["B"]);
		end
	else
		if tOpacity then
			tIcon:SetVertexColor(1, 1, 1, tOpacity);
		else
			tIcon:SetVertexColor(1, 1, 1);
		end
	end

	if aRest == 999 then -- Other players' HoTs
		if aTimes > 0 then
			if tOpacity then
				tIcon:SetAlpha(tOpacity);
			end

			tCounter:SetText(aTimes > 1 and aTimes or "");
		else
			VUHDO_UIFrameFlashStop(tIcon);
			tIcon:SetAlpha(0);
			tCounter:SetText("");
		end
		
		tTimer:SetText("");
		tClock:SetAlpha(0);

		return;

	elseif aRest > 0 then
		if aRest < 10 or tHotCfg["isFullDuration"] then
			tDuration = (tHotCfg["countdownMode"] == 2 and aRest < sHotCols["WARNING"]["lowSecs"])
				and format("%.1f", aRest) or format("%d", aRest);
		elseif tIsChargeShown or (tOpacity and tOpacity > 0) then
			tDuration = "";
		else
			tDuration = "X";
		end

		tTimer:SetText(tDuration);

		tStarted = floor(10 * (GetTime() - aDuration + aRest) + 0.5) * 0.1;
		tClockDuration = tClock:GetCooldownDuration() * 0.001;

		if aDuration > 0 and 
			(tClock:GetAlpha() == 0 or (tClock:GetAttribute("started") or tStarted) ~= tStarted or 
			(tClock:IsVisible() and aDuration > tClockDuration)) then
			tClock:SetAlpha(1);
			tClock:SetCooldown(tStarted, aDuration);
			tClock:SetAttribute("started", tStarted);
		end

		if tOpacity then
			tIcon:SetAlpha(((sIsFade or tHotCfg["isFadeOut"]) and aRest < 10) and tOpacity * aRest * 0.1 or tOpacity);
		end

		if aRest > 5 then
			VUHDO_UIFrameFlashStop(tIcon);
			tTimer:SetTextColor(1, 1, 1, tTextOpacity or 1);
		else
			tDuration2 = aRest * 0.2;
			tTimer:SetTextColor(1, tDuration2, tDuration2, tTextOpacity or 1);
			VUHDO_UIFrameFlash(tIcon, 0.2, 0.1, 5, true, 0, 0.1);
		end

		tCounter:SetText(aTimes > 1 and aTimes or "");

	else
		VUHDO_UIFrameFlashStop(tIcon);
		tTimer:SetText("");
		tClock:SetAlpha(0);
		tCounter:SetText(aTimes > 1 and aTimes or "");

		if tOpacity then
			tIcon:SetAlpha(tOpacity);
		end
	end

	-- FIXME: this whole function needs refactored to logically group (and dedupe) setting the icon, timer and charges colors
	if aColor and (not aColor["isDefault"] or not sIsHotShowIcon) then
		-- respect the default timer text color set above based on remaining duration
	elseif sIsWarnColor and aRest < sHotCols["WARNING"]["lowSecs"] then
		tTimer:SetTextColor(VUHDO_textColor(tHotColor));
	else
		if not sIsHotShowIcon and (tTimes <= 1 or not sHotCols["useColorText"]) then
			tTimer:SetTextColor(VUHDO_textColor(tHotColor));
		end

		if tTimes > 1 and sHotCols["useColorText"] then
			tTimer:SetTextColor(VUHDO_textColor(tHotColor));
		end
	end

	if tIsChargeShown then
		tChargeTexture:SetTexture(VUHDO_CHARGE_TEXTURES[tTimes]);
		tChargeTexture:SetVertexColor(VUHDO_backColorWithFallback(tHotColor));
		
		tChargeTexture:Show();
	elseif aShieldCharges > 0 then
		if sIsHotShowIcon then
			tHotColor = tHotCfg;
		end

		tChargeTexture:SetTexture(VUHDO_SHIELD_TEXTURES[aShieldCharges]);
		
		if tHotColor and tHotColor["R"] then
			tChargeTexture:SetVertexColor(tHotColor["R"] + 0.15, tHotColor["G"] + 0.15, tHotColor["B"] + 0.15, tHotColor["O"]);
		end
		
		tChargeTexture:Show();
	else
		tChargeTexture:Hide();
	end

end



--
local tAllButtons;
local tShieldCharges, tShieldName;
local tIsMatch;
local tIsMine, tIsOthers;
local function VUHDO_updateHotIcons(aUnit, aHotName, aRest, aTimes, anIcon, aDuration, aMode, aColor, aHotSpellName, aClipL, aClipR, aClipT, aClipB)
	tAllButtons = VUHDO_getUnitButtons(VUHDO_resolveVehicleUnit(aUnit));
	if not tAllButtons then return; end

	tShieldName = aHotSpellName or aHotName;

	if type(tonumber(tShieldName)) == "number" then
		tShieldName = GetSpellInfo(tonumber(tShieldName));
	end

	tShieldCharges = VUHDO_getShieldLeftCount(aUnit, tShieldName, aMode) or 0; -- if not our shield don't show remaining absorption

	for tIndex, tHotName in pairs(sHotSlots) do
		if aHotName == tHotName then

			if aMode == 0 or aColor then tIsMatch = true; -- Bouquet => aColor ~= nil
			else
				tIsMine, tIsOthers = sHotSlotCfgs[tIndex]["mine"], sHotSlotCfgs[tIndex]["others"];
				tIsMatch = (aMode == 1 and     tIsMine and not tIsOthers)
								or (aMode == 2 and not tIsMine and     tIsOthers)
								or (aMode == 3 and     tIsMine and     tIsOthers);
			end

			if tIsMatch then
				if tIndex >= 6 and tIndex <= 8 then
					for _, tButton in pairs(tAllButtons) do
						VUHDO_customizeHotBar(tButton, aRest, tIndex, aDuration, aColor);
					end
				else
					for _, tButton in pairs(tAllButtons) do
						VUHDO_customizeHotIcons(tButton, aHotName, aRest, aTimes, anIcon, aDuration, tShieldCharges, aColor, tIndex, aClipL, aClipR, aClipT, aClipB);
					end
				end
			end
		end
	end

end



--
local tHotIconFrame;
local function VUHDO_removeButtonHots(aButton)
	for tCnt = 1, 5 do
		VUHDO_UIFrameFlashStop(VUHDO_getBarIcon(aButton, tCnt));
		tHotIconFrame = VUHDO_getBarIconFrame(aButton, tCnt);
		if tHotIconFrame then tHotIconFrame:Hide(); end
	end

	for tCnt = 9, 10 do
		VUHDO_UIFrameFlashStop(VUHDO_getBarIcon(aButton, tCnt));
		tHotIconFrame = VUHDO_getBarIconFrame(aButton, tCnt);
		if tHotIconFrame then tHotIconFrame:Hide(); end
	end

	for tCnt = 9, 11 do
		VUHDO_getHealthBar(aButton, tCnt):SetValue(0);
	end
	VUHDO_getBarRoleIcon(aButton, 51):Hide(); -- Swiftmend indicator
end



--
function VUHDO_removeHots(aUnit)
	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		VUHDO_removeButtonHots(tButton);
	end
end
local VUHDO_removeHots = VUHDO_removeHots;



--
local tCount;
local tHotInfo;
local tAlive;
local function VUHDO_snapshotHot(aHotName, aRest, aStacks, anIcon, anIsMine, aDuration, aUnit, anExpiry)
	aStacks = aStacks or 0;
	tCount = aStacks == 0 and 1 or aStacks;
	tAlive = GetTime() - anExpiry + (aDuration or 0);

	if anIsMine then
		if not VUHDO_MY_HOTS[aUnit][aHotName] then VUHDO_MY_HOTS[aUnit][aHotName] = { }; end
		tHotInfo = VUHDO_MY_HOTS[aUnit][aHotName];
		tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], tHotInfo[5] = aRest, aStacks, anIcon, aDuration, tAlive;

	elseif VUHDO_ACTIVE_HOTS_OTHERS[aHotName] then
		if not VUHDO_OTHER_HOTS[aUnit][aHotName] then	VUHDO_OTHER_HOTS[aUnit][aHotName] = { }; end
		tHotInfo = VUHDO_OTHER_HOTS[aUnit][aHotName];

		if not tHotInfo[1] then
			tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], tHotInfo[5] = aRest, aStacks, anIcon, aDuration, tAlive;
		else
			if aRest > tHotInfo[1] then	tHotInfo[1] = aRest; end
			tHotInfo[2] = tHotInfo[2] + tCount;
		end
	end

	if not VUHDO_MY_AND_OTHERS_HOTS[aUnit][aHotName] then VUHDO_MY_AND_OTHERS_HOTS[aUnit][aHotName] = { }; end
	tHotInfo = VUHDO_MY_AND_OTHERS_HOTS[aUnit][aHotName];
	if not tHotInfo[1] then
		tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], tHotInfo[5] = aRest, aStacks, anIcon, aDuration, tAlive;
	else
		if anIsMine or aRest > tHotInfo[1] then tHotInfo[1] = aRest; end
		tHotInfo[2] = tHotInfo[2] + tCount;
	end
end



local VUHDO_IGNORE_HOT_IDS = {
	[67358] = true, -- "Rejuvenating" proc has same name in russian and spanish as rejuvenation
	[126921] = true, -- "Weakened Soul" by Shao-Tien Soul-Render
	[109964] = true, -- "Spirit Shell" ability aura has the same name as the absorb aura itself
}



--
function VUHDO_hotBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName, anImpact, aTimer2, aClipL, aClipR, aClipT, aClipB)

	VUHDO_updateHotIcons(aUnit, "BOUQUET_" .. (aBouquetName or ""), aTimer, aCounter, anIcon, aDuration, 0, aColor, aBuffName, aClipL, aClipR, aClipT, aClipB);

end



--
local tUnit;
local tBuffName;
local tBuffIcon;
local tStacks;
local tDuration;
local tExpiry;
local tCaster;
local tSpellId;
local tIsCastByPlayer;
local tStart;
local tSmDuration;
local tEnabled;
local tRest;
local tOtherIcon;
local tOtherHotCnt;
local tNow;
local function VUHDO_updateHotIconPredicate(anAuraData)

	tBuffName, tBuffIcon, tStacks, _, tDuration, tExpiry, tCaster, _, _, tSpellId = UnpackAuraData(anAuraData);

	if not tBuffIcon then
		return;
	end

	tIsCastByPlayer = tCaster == "player" or tCaster == VUHDO_PLAYER_RAID_ID;

	if sIsPlayerKnowsSwiftmend and not sIsSwiftmend then
		if VUHDO_SPELL_ID.REGROWTH == tBuffName or VUHDO_SPELL_ID.REJUVENATION == tBuffName or VUHDO_SPELL_ID.GERMINATION == tBuffName then
				tStart, tSmDuration, tEnabled = GetSpellCooldown(VUHDO_SPELL_ID.SWIFTMEND);

				if tEnabled ~= 0 and (tStart == nil or tSmDuration == nil or tStart <= 0 or tSmDuration <= 1.6) then
					sIsSwiftmend = true;
				end
		end
	end

	if (tExpiry or 0) == 0 then
		tExpiry = (tNow + 9999);
	end

	if not VUHDO_IGNORE_HOT_IDS[tSpellId] then
		if VUHDO_ACTIVE_HOTS[tostring(tSpellId or -1)] or VUHDO_ACTIVE_HOTS[tBuffName] then
			tRest = tExpiry - tNow;

			if tRest > 0 then
				if VUHDO_ACTIVE_HOTS[tostring(tSpellId or -1)] then
					VUHDO_snapshotHot(tostring(tSpellId), tRest, tStacks, tBuffIcon, tIsCastByPlayer, tDuration, tUnit, tExpiry);
				end

				if VUHDO_ACTIVE_HOTS[tBuffName] then
					VUHDO_snapshotHot(tBuffName, tRest, tStacks, tBuffIcon, tIsCastByPlayer, tDuration, tUnit, tExpiry);
				end
			end
		end
	end

	if not tIsCastByPlayer and VUHDO_HEALING_HOTS[tBuffName] and
		not VUHDO_ACTIVE_HOTS_OTHERS[tBuffName] and not VUHDO_ACTIVE_HOTS_OTHERS[tostring(tSpellId or -1)] then
		tOtherIcon = tBuffIcon;
		tOtherHotCnt = tOtherHotCnt + 1;

		sOthersHotsInfo[tUnit][1] = tOtherIcon;
		sOthersHotsInfo[tUnit][2] = tOtherHotCnt;
	end

end



--
function VUHDO_updateHots(aUnit, anInfo)

	if anInfo["isVehicle"] then
		VUHDO_removeHots(aUnit);

		aUnit = anInfo["petUnit"];

		if not aUnit then
			return;
		end -- bei z.B. focus/target
	end

	if not VUHDO_MY_HOTS[aUnit] then
		VUHDO_MY_HOTS[aUnit] = { };
	end

	if not VUHDO_OTHER_HOTS[aUnit] then
		VUHDO_OTHER_HOTS[aUnit] = { };
	end

	if not VUHDO_MY_AND_OTHERS_HOTS[aUnit] then
		VUHDO_MY_AND_OTHERS_HOTS[aUnit] = { };
	end

	for _, tHotInfo in pairs(VUHDO_MY_HOTS[aUnit]) do
		tHotInfo[1] = nil;
	end -- Rest == nil => Icon löschen

	for _, tHotInfo in pairs(VUHDO_OTHER_HOTS[aUnit]) do
		tHotInfo[1] = nil;
	end

	for _, tHotInfo in pairs(VUHDO_MY_AND_OTHERS_HOTS[aUnit]) do
		tHotInfo[1] = nil;
	end

	sIsSwiftmend = false;
	tOtherIcon = nil;
	tOtherHotCnt = 0;

	if not sOthersHotsInfo[aUnit] then
		sOthersHotsInfo[aUnit] = { nil, 0 };
	else
		sOthersHotsInfo[aUnit][1], sOthersHotsInfo[aUnit][2] = nil, 0;
	end

	if VUHDO_shouldScanUnit(aUnit) then
		tUnit = aUnit;
		tNow = GetTime();

		ForEachAura(aUnit, "HELPFUL", nil, VUHDO_updateHotIconPredicate, true);
		ForEachAura(aUnit, "HARMFUL", nil, VUHDO_updateHotIconPredicate, true);

		-- Other players' HoTs
		if sIsOthersHots then
			VUHDO_updateHotIcons(aUnit, "OTHER", 999, tOtherHotCnt, tOtherIcon, nil, 0, nil, nil, nil, nil, nil, nil);
		end

		-- Clusters
		if sIsClusterIcons then
			VUHDO_updateAllClusterIcons(aUnit, anInfo);
		end

		-- Swiftmend
		if sIsPlayerKnowsSwiftmend then
			sSwiftmendUnits[aUnit] = sIsSwiftmend;
		end
	end -- Should scan unit

	-- Own
	for tHotCmpName, tHotInfo in pairs(VUHDO_MY_HOTS[aUnit]) do
		VUHDO_updateHotIcons(aUnit, tHotCmpName, tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], 1, nil, nil, nil, nil, nil, nil);

		if not tHotInfo[1] then
			twipe(tHotInfo);
			VUHDO_MY_HOTS[aUnit][tHotCmpName] = nil;
		end
	end

	-- Others
	for tHotCmpName, tHotInfo in pairs(VUHDO_OTHER_HOTS[aUnit]) do
		VUHDO_updateHotIcons(aUnit, tHotCmpName, tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], 2, nil, nil, nil, nil, nil, nil);

		if not tHotInfo[1] then
			twipe(tHotInfo);
			VUHDO_OTHER_HOTS[aUnit][tHotCmpName] = nil;
		end
	end

	-- Own+Others
	for tHotCmpName, tHotInfo in pairs(VUHDO_MY_AND_OTHERS_HOTS[aUnit]) do
		VUHDO_updateHotIcons(aUnit, tHotCmpName, tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], 3, nil, nil, nil, nil, nil, nil);

		if not tHotInfo[1] then
			twipe(tHotInfo);
			VUHDO_MY_AND_OTHERS_HOTS[aUnit][tHotCmpName] = nil;
		end
	end

end


--
local tIcon;
local tPanelNum;
function VUHDO_swiftmendIndicatorBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName, anImpact, aTimer2, aClipL, aClipR, aClipT, aClipB)

	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		tPanelNum = VUHDO_BUTTON_CACHE[tButton];

		if VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["SWIFTMEND_INDICATOR"] == aBouquetName then
			if anIsActive and aColor then
				tIcon = VUHDO_getBarRoleIcon(tButton, 51);

				if VUHDO_ATLAS_TEXTURES[anIcon] then
					tIcon:SetAtlas(anIcon);
				else
					tIcon:SetTexture(anIcon);
				end

				tIcon:SetVertexColor(VUHDO_backColorWithFallback(aColor));

				tIcon:SetTexCoord(aClipL or 0, aClipR or 1, aClipT or 0, aClipB or 1);

				tIcon:Show();

				if VUHDO_INDICATOR_CONFIG[tPanelNum]["CUSTOM"]["SWIFTMEND_INDICATOR"]["isBarGlow"] then
					VUHDO_LibCustomGlow.PixelGlow_Start(
						tButton,
						{
							VUHDO_PANEL_SETUP.BAR_COLORS["DEBUFF_BAR_GLOW"]["R"],
							VUHDO_PANEL_SETUP.BAR_COLORS["DEBUFF_BAR_GLOW"]["G"],
							VUHDO_PANEL_SETUP.BAR_COLORS["DEBUFF_BAR_GLOW"]["B"],
							VUHDO_PANEL_SETUP.BAR_COLORS["DEBUFF_BAR_GLOW"]["O"]
						},
						14,                             -- number of particles
						0.3,                            -- frequency
						8,                              -- length
						2,                              -- thickness
						0,                              -- x offset
						0,                              -- y offset
						false,                          -- border
						VUHDO_CUSTOM_GLOW_SWIFTMEND_FRAME_KEY
					);
				end

				if VUHDO_INDICATOR_CONFIG[tPanelNum]["CUSTOM"]["SWIFTMEND_INDICATOR"]["isIconGlow"] then
					VUHDO_LibCustomGlow.PixelGlow_Start(
						tIcon,
						{
							VUHDO_PANEL_SETUP.BAR_COLORS["DEBUFF_ICON_GLOW"]["R"],
							VUHDO_PANEL_SETUP.BAR_COLORS["DEBUFF_ICON_GLOW"]["G"],
							VUHDO_PANEL_SETUP.BAR_COLORS["DEBUFF_ICON_GLOW"]["B"],
							VUHDO_PANEL_SETUP.BAR_COLORS["DEBUFF_ICON_GLOW"]["O"]
						},
						8,                                           -- number of particles
						0.3,                                         -- frequency
						6,                                           -- length
						2,                                           -- thickness
						0,                                           -- x offset
						0,                                           -- y offset
						false,                                       -- border
						VUHDO_CUSTOM_GLOW_SWIFTMEND_ICON_KEY
					);
				end
			else
				VUHDO_LibCustomGlow.PixelGlow_Stop(tButton, VUHDO_CUSTOM_GLOW_SWIFTMEND_FRAME_KEY);

				tIcon = VUHDO_getBarRoleIcon(tButton, 51);
				VUHDO_LibCustomGlow.PixelGlow_Stop(tIcon, VUHDO_CUSTOM_GLOW_SWIFTMEND_ICON_KEY);
				tIcon:Hide();
			end
		end
	end

end



--
local sIsSuspended = false;
function VUHDO_suspendHoTs(aFlag)
	sIsSuspended = aFlag;
end



--
function VUHDO_updateAllHoTs()
	if sIsSuspended then return; end

	twipe(sSwiftmendUnits);
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		VUHDO_updateHots(tUnit, tInfo);
	end
end



--
function VUHDO_removeAllHots()
	local tButton;
	local tCnt2;
	for tCnt = 1, 10 do
		if VUHDO_getActionPanel(tCnt) then
			if VUHDO_isPanelVisible(tCnt) then

				tCnt2 = 1;
				while true do
					tButton = VUHDO_getHealButton(tCnt2, tCnt);
					if not tButton then break; end -- Auch nicht belegte buttons ausblenden
					VUHDO_removeButtonHots(tButton);
					tCnt2 = tCnt2 + 1;
				end

			end
		else
			break;
		end
	end

	VUHDO_updatePlayerTarget();
end



--
function VUHDO_resetHotBuffCache()
	twipe(sBuffs2Hots);
end



function VUHDO_isUnitSwiftmendable(aUnit)
	return sSwiftmendUnits[aUnit];
end
