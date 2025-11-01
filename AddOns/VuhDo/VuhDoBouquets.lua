local _;

local table = table;
local floor = floor;
local select = select;
local twipe = table.wipe;
local pairs = pairs;
local sPlayerArray = { };
local VUHDO_BOUQUETS = { };
local VUHDO_RAID = { };
local VUHDO_CONFIG = { };
local VUHDO_BOUQUET_BUFFS_SPECIAL = { };
local VUHDO_CUSTOM_ICONS;

local VUHDO_CUSTOM_BOUQUETS = {
	VUHDO_I18N_DEF_BOUQUET_TARGET_HEALTH,
};


----------------------------------------------------------



function VUHDO_bouquetsInitLocalOverrides()
	VUHDO_BOUQUETS = _G["VUHDO_BOUQUETS"];
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_CUSTOM_ICONS = _G["VUHDO_CUSTOM_ICONS"];
	VUHDO_BOUQUET_BUFFS_SPECIAL = _G["VUHDO_BOUQUET_BUFFS_SPECIAL"];
	sPlayerArray["player"] = VUHDO_RAID["player"];
end

----------------------------------------------------------

local VUHDO_LAST_EVALUATED_BOUQUETS = { };
setmetatable(VUHDO_LAST_EVALUATED_BOUQUETS, VUHDO_META_NEW_ARRAY);
local VUHDO_REGISTERED_BOUQUETS = { };
setmetatable(VUHDO_REGISTERED_BOUQUETS, VUHDO_META_NEW_ARRAY);
local VUHDO_ACTIVE_BOUQUETS = { };
setmetatable(VUHDO_ACTIVE_BOUQUETS, VUHDO_META_NEW_ARRAY);

local VUHDO_REGISTERED_BOUQUET_INDICATORS = { };
local VUHDO_CYCLIC_BOUQUETS = { };


--
local function VUHDO_getColorHash(aColor)
		return
			(aColor["R"] or 0) * 0.0001
		+ (aColor["G"] or 0) * 0.001
		+ (aColor["B"] or 0) * 0.01
		+ (aColor["O"] or 0) * 0.1
		+ (aColor["TR"] or 0)
		+ (aColor["TG"] or 0) * 10
		+ (aColor["TB"] or 0) * 100
		+ (aColor["TO"] or 0) * 1000;
end



--
local tHasChanged, tLastTime;
local function VUHDO_hasBouquetChanged(aUnit, aBouquetName, anArg1, anArg2, anArg3, anArg4, anArg5, anArg6, anArg7, anArg8, anArg9, anArg10)
	tLastTime = VUHDO_LAST_EVALUATED_BOUQUETS[aBouquetName][aUnit];
	if not tLastTime then
		VUHDO_LAST_EVALUATED_BOUQUETS[aBouquetName][aUnit] = { };
		return true;
	end

	tHasChanged = false;
	if anArg1  ~= tLastTime[ 1] then tLastTime[ 1] = anArg1;  tHasChanged = true; end
	if anArg2  ~= tLastTime[ 2] then tLastTime[ 2] = anArg2;  tHasChanged = true; end
	if anArg3  ~= tLastTime[ 3] then tLastTime[ 3] = anArg3;  tHasChanged = true; end
	if anArg4  ~= tLastTime[ 4] then tLastTime[ 4] = anArg4;  tHasChanged = true; end
	if anArg5  ~= tLastTime[ 5] then tLastTime[ 5] = anArg5;  tHasChanged = true; end
	if anArg6  ~= tLastTime[ 6] then tLastTime[ 6] = anArg6;  tHasChanged = true; end
	if anArg7  ~= tLastTime[ 7] then tLastTime[ 7] = anArg7;  tHasChanged = true; end
	if anArg8  ~= tLastTime[ 8] then tLastTime[ 8] = anArg8;  tHasChanged = true; end
	if anArg9  ~= tLastTime[ 9] then tLastTime[ 9] = anArg9;  tHasChanged = true; end
	if anArg10 ~= tLastTime[10] then tLastTime[10] = anArg10; tHasChanged = true; end
	return tHasChanged;
end



--
local tColor;
local tFactor;
local tModi, tInvModi;
local tR1, tG1, tB1, tO1;
local tR2, tG2, tB2, tO2;
local tGood, tFair, tLow;
local tDestColor = { ["useBackground"] = true, ["useOpacity"] = true };
local tRadio;
local tIsGradient;
local tClassId;
local tMaxColor;
local tDestMaxColor = { ["useBackground"] = true, ["useOpacity"] = true };
local function VUHDO_getBouquetStatusBarColor(anEntry, anInfo, aValue, aMaxValue)
	tRadio = anEntry["custom"]["radio"];

	if 1 == tRadio then -- solid
		tColor = anEntry["color"];
		tIsGradient = anEntry["custom"]["isSolidGradient"];

		if tIsGradient then
			tMaxColor = anEntry["custom"]["maxColor"];

			tDestColor["R"], tDestColor["G"], tDestColor["B"], tDestColor["O"] = tColor["R"], tColor["G"], tColor["B"], tColor["O"];

			if tMaxColor then
				tDestMaxColor["R"], tDestMaxColor["G"], tDestMaxColor["B"], tDestMaxColor["O"]
					= tMaxColor["R"], tMaxColor["G"], tMaxColor["B"], tMaxColor["O"];

				return tDestColor, tDestMaxColor;
			else
				return tDestColor, nil;
			end
		else
			tDestColor["R"], tDestColor["G"], tDestColor["B"], tDestColor["O"] = tColor["R"], tColor["G"], tColor["B"], tColor["O"];

			return tDestColor, nil;
		end
	elseif 2 == tRadio then -- class color
		tClassId = anInfo["classId"];
		tFactor = anEntry["custom"]["bright"];
		tIsGradient = anEntry["custom"]["isClassGradient"];

		if tIsGradient then
			tColor = VUHDO_USER_CLASS_GRADIENT_COLORS[tClassId]["min"] or anEntry["color"];
			tMaxColor = VUHDO_USER_CLASS_GRADIENT_COLORS[tClassId]["max"] or anEntry["custom"]["maxColor"];

			tDestColor["R"], tDestColor["G"], tDestColor["B"], tDestColor["O"]
				= tColor["R"] * tFactor, tColor["G"] * tFactor, tColor["B"] * tFactor, tColor["O"];

			if tMaxColor then
				tDestMaxColor["R"], tDestMaxColor["G"], tDestMaxColor["B"], tDestMaxColor["O"]
					= tMaxColor["R"] * tFactor, tMaxColor["G"] * tFactor, tMaxColor["B"] * tFactor, tMaxColor["O"];

				return tDestColor, tDestMaxColor;
			else
				return tDestColor, nil;
			end
		else
			tColor = VUHDO_USER_CLASS_COLORS[tClassId] or anEntry["color"];

			tDestColor["R"], tDestColor["G"], tDestColor["B"], tDestColor["O"]
				= tColor["R"] * tFactor, tColor["G"] * tFactor, tColor["B"] * tFactor, tColor["O"];

			return tDestColor, nil;
		end
	elseif aMaxValue ~= 0 then -- 3 == gradient

		tModi = ((aValue / aMaxValue) ^ 1.7) * 2;
		tFair = anEntry["custom"]["grad_med"];
		if tModi > 1 then
			tGood = anEntry["color"];
			tR1, tG1, tB1, tO1 = tGood["R"], tGood["G"], tGood["B"], tGood["O"];
			tR2, tG2, tB2, tO2 = tFair["R"], tFair["G"], tFair["B"], tFair["O"];
			tModi = tModi - 1;
		else
			tLow = anEntry["custom"]["grad_low"];
			tR1, tG1, tB1, tO1 = tFair["R"], tFair["G"], tFair["B"], tFair["O"];
			tR2, tG2, tB2, tO2 = tLow["R"], tLow["G"], tLow["B"], tLow["O"];
		end

		tInvModi = 1 - tModi;
		tDestColor["R"], tDestColor["G"], tDestColor["B"], tDestColor["O"]
			= tR2 * tInvModi + tR1 * tModi, tG2 * tInvModi + tG1 * tModi,
		 		tB2 * tInvModi + tB1 * tModi, tO2 * tInvModi + tO1 * tModi;

		return tDestColor, nil;
	else
		tColor = anEntry["color"];

		tDestColor["R"], tDestColor["G"], tDestColor["B"], tDestColor["O"] = tColor["R"], tColor["G"], tColor["B"], tColor["O"];

		return tDestColor, nil;
	end
end



--
local txActive;
function VUHDO_getIsCurrentBouquetActive()
	return txActive;
end



--
local txColor = { };
local tIsTxColorInit = false;
function VUHDO_getCurrentBouquetColor()
	if (not tIsTxColorInit) then
		twipe(txColor);
	end
	return txColor;
end



--
local txMaxColor = { };
local tIsTxMaxColorInit = false;
function VUHDO_getCurrentBouquetMaxColor()

	if (not tIsTxMaxColorInit) then
		twipe(txMaxColor);
	end

	return txMaxColor;

end


--
local txCounter;
function VUHDO_getCurrentBouquetStacks()
	return txCounter;
end



--
local txTimer;
function VUHDO_getCurrentBouquetTimer()
	return txTimer;
end



--
local txActiveAuras;
function VUHDO_getCurrentBouquetActiveAuras()

	return txActiveAuras;

end



--
local tBouquet;
local tInfos;
local tName;
local tSpecial;
local tIsActive;
local tIcon;
local tTimer;
local tCounter;
local tDuration;
local tSourceType;
local tUnitHot;
local tUnitHotInfo;
local tNow;
local tTimer2
local tClipL, tClipR, tClipT, tClipB;
local tAnzInfos;
local tColor;
local txIcon;
local txDuration;
local txName;
local txLevel;
local txTimer2;
local txClipL, txClipR, txClipT, txClipB;
local tFactor;
local tMaxColor;
local tInfo, tUnit;
local tEmptyInfo = { };

local function VUHDO_evaluateBouquet(aUnit, aBouquetName, anInfo)

	tUnit = (VUHDO_RAID[aUnit] or tEmptyInfo)["isVehicle"] and VUHDO_RAID[aUnit]["petUnit"] or aUnit;
	tInfo = anInfo or VUHDO_RAID[tUnit];

	if not tInfo then
		return false, nil, nil, nil, nil, nil, nil,
			VUHDO_hasBouquetChanged(aUnit, aBouquetName, false), 0, 0;
	end

	txActive = false;
	txIcon, tIsTxColorInit, txName = nil, false, nil;
	txCounter, txTimer, txDuration, txTimer2, txLevel = 0, 0, 0, 0, 0;
	txActiveAuras = 0;

	tBouquet = VUHDO_BOUQUETS["STORED"][aBouquetName];
	tAnzInfos = #tBouquet;

	for tCnt = tAnzInfos, 1, -1  do
		tInfos = tBouquet[tCnt];
		tSpecial = VUHDO_BOUQUET_BUFFS_SPECIAL[tInfos["name"]];
		if tSpecial then
			tName = nil;
			tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tTimer2, tClipL, tClipR, tClipT, tClipB = tSpecial["validator"](tInfo, tInfos);

			if tIsActive then
				if tInfos["icon"] ~= 1 then	tIcon = VUHDO_CUSTOM_ICONS[tInfos["icon"]][2]; end

				if not tColor then
					if 3 == tSpecial["custom_type"] then
						tColor, tMaxColor = VUHDO_getBouquetStatusBarColor(tInfos, tInfo, tTimer, tDuration);
					end

					if not tColor then
						tColor = tInfos["color"]; -- VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR
					end
				elseif 4 == tSpecial["custom_type"] then -- VUHDO_BOUQUET_CUSTOM_TYPE_BRIGHTNESS
					tFactor = tInfos["custom"]["bright"];
					if (tColor["useBackground"]) then
						tColor["R"], tColor["G"], tColor["B"] = tColor["R"] * tFactor, tColor["G"] * tFactor, tColor["B"] * tFactor;
					end
					if tColor["useText"] then
						tColor["TR"], tColor["TG"], tColor["TB"] = tColor["TR"] * tFactor, tColor["TG"] * tFactor, tColor["TB"] * tFactor;
					end
				end

				if tColor["useText"] then	tColor["useText"] = tInfos["color"]["useText"]; end
				if tColor["useBackground"] then	tColor["useBackground"] = tInfos["color"]["useBackground"]; end
				if tColor["useOpacity"] then tColor["useOpacity"] = tInfos["color"]["useOpacity"]; end
			end
		else -- Buff/Debuff
			tName = tInfos["name"];

			tIsActive = false;
			tSourceType = 0;

			if tInfos["mine"] and tInfos["others"] then
				tSourceType = VUHDO_UNIT_HOT_TYPE_BOTH;
			elseif tInfos["mine"] then
				tSourceType = VUHDO_UNIT_HOT_TYPE_MINE;
			elseif tInfos["others"] then
				tSourceType = VUHDO_UNIT_HOT_TYPE_OTHERS;
			end

			if tSourceType > 0 then
				tUnitHot, _ = VUHDO_getUnitHot(tUnit, tName, tSourceType);

				if tUnitHot and tUnitHot["auraInstanceId"] then
					-- tUnitHotInfo: aura icon, expiration, stacks, duration, isMine, name, spell ID
					tUnitHotInfo = VUHDO_getUnitHotInfo(aUnit, tUnitHot["auraInstanceId"]);

					if tUnitHotInfo then
						tIsActive = true;

						txActiveAuras = txActiveAuras + 1;

						tNow = GetTime();

						if tInfos["alive"] then
							tTimer = tNow - tUnitHotInfo[2] + (tUnitHotInfo[4] or 0);
						else
							tTimer = tUnitHotInfo[2] - tNow;
						end

						tIcon, tCounter, tDuration = tUnitHotInfo[1], tUnitHotInfo[3], tUnitHotInfo[4];

						if tTimer then
							tTimer = floor(tTimer * 10) * 0.1;
						end

						tColor = tInfos["color"];

						if tInfos["icon"] ~= 1 then
							tIcon = VUHDO_CUSTOM_ICONS[tInfos["icon"]][2];
							tColor["isDefault"] = false;
						else
							tColor["isDefault"] = true;
						end
					end
				end
			end

			tTimer2, tClipL, tClipR, tClipT, tClipB = nil, nil, nil, nil, nil;
		end

		if tIsActive then
			txActive = true;
			txName = tName;
			txLevel = tCnt;
			-- Icon
			if tInfos["icon"] ~= 1 then
				tIcon = VUHDO_CUSTOM_ICONS[tInfos["icon"]][2];
				txClipL, txClipR, txClipT, txClipB = nil, nil, nil, nil;
			elseif tIcon ~= nil then
				txClipL, txClipR, txClipT, txClipB = tClipL, tClipR, tClipT, tClipB;
			end

			if tIcon then
				txIcon = tIcon;
			end

			-- Color
			if tColor then
				if not tIsTxColorInit then
					twipe(txColor);
					tIsTxColorInit = true;
				end

				if tColor["useText"] then
					txColor["useText"], txColor["TR"], txColor["TG"], txColor["TB"], txColor["TO"] = true, tColor["TR"], tColor["TG"], tColor["TB"], tColor["TO"];
				end

				if tColor["useBackground"] then
					txColor["useBackground"], txColor["R"], txColor["G"], txColor["B"], txColor["O"] = true, tColor["R"], tColor["G"], tColor["B"], tColor["O"];
				end

				if tColor["useOpacity"] then
					txColor["useOpacity"] = true;

					if tColor["TO"] ~= nil then
						txColor["TO"] = (txColor["TO"] or 1) * tColor["TO"];
					end

					if tColor["O"] ~= nil then
						txColor["O"] = (txColor["O"] or 1) * tColor["O"];
					end
				end

				txColor["isDefault"] = tColor["isDefault"];
				txColor["noStacksColor"] = tColor["noStacksColor"];
				txColor["useSlotColor"] = tColor["useSlotColor"];

				if tMaxColor then
					if not tIsTxMaxColorInit then
						twipe(txMaxColor);
						tIsTxMaxColorInit = true;
					end

					if tMaxColor["useText"] then
						txMaxColor["useText"], txMaxColor["TR"], txMaxColor["TG"], txMaxColor["TB"], txMaxColor["TO"] =
							true, tMaxColor["TR"], tMaxColor["TG"], tMaxColor["TB"], tMaxColor["TO"];
					end

					if tMaxColor["useBackground"] then
						txMaxColor["useBackground"], txMaxColor["R"], txMaxColor["G"], txMaxColor["B"], txMaxColor["O"] =
							true, tMaxColor["R"], tMaxColor["G"], tMaxColor["B"], tMaxColor["O"];
					end

					if tMaxColor["useOpacity"] then
						txMaxColor["useOpacity"] = true;

						if tMaxColor["TO"] ~= nil then
							txMaxColor["TO"] = (txMaxColor["TO"] or 1) * tMaxColor["TO"];
						end

						if tMaxColor["O"] ~= nil then
							txMaxColor["O"] = (txMaxColor["O"] or 1) * tMaxColor["O"];
						end
					end
				else
					tIsTxMaxColorInit = false;
				end
			else
				tIsTxColorInit = false;
				tIsTxMaxColorInit = false;
			end

			-- Stacks
			tCounter = tCounter or 0;
			if tCounter >= 0 then txCounter = tCounter;	end
			tTimer, tTimer2, tDuration = tTimer or 0, tTimer2 or 0, tDuration or 0;
			if tDuration >= 0 then
				if tTimer >= 0 then	txTimer, txDuration = tTimer, tDuration; end
				if tTimer2 >= 0 then txTimer2 = tTimer2; end
			end
		end
	end

	if txActive then
		if not tIsTxColorInit then
			txColor["R"], txColor["G"], txColor["B"], txColor["O"], txColor["TR"], txColor["TG"], txColor["TB"], txColor["TO"],
				txColor["useText"], txColor["useBackground"], txColor["useOpacity"] = 1,1,1,1, 1,1,1,1, true,true,true;
		elseif not txColor["useOpacity"] then
			txColor["TO"], txColor["O"] = 1, 1;
		end

		if tIsTxMaxColorInit and not txMaxColor["useOpacity"] then
			txMaxColor["TO"], txMaxColor["O"] = 1, 1;
		end

		return true, txIcon, txTimer, txCounter, txDuration, txColor, txName,
			VUHDO_hasBouquetChanged(aUnit, aBouquetName, true, txIcon, txTimer, txCounter, txDuration, VUHDO_getColorHash(txColor), txClipL, txClipR, txClipT, txClipB),
			tAnzInfos - txLevel, txTimer2, txClipL, txClipR, txClipT, txClipB, tIsTxMaxColorInit and txMaxColor or nil;
	else
		return false, nil, nil, nil, nil, nil, nil, VUHDO_hasBouquetChanged(aUnit, aBouquetName, false), 0, 0;
	end

end




--
local tBouquet;
local tName;
local function VUHDO_activateBuffsInScanner(aBouquetName)
	tBouquet = VUHDO_BOUQUETS["STORED"][aBouquetName];

	for _, tInfos in pairs(tBouquet) do
		tName = tInfos["name"];
		if not VUHDO_strempty(tName) and not VUHDO_BOUQUET_BUFFS_SPECIAL[tName] then
			VUHDO_ACTIVE_HOTS[tName] = true;

			if tInfos["others"] then VUHDO_ACTIVE_HOTS_OTHERS[tName] = true; end
		end
	end
end



--
local function VUHDO_hasCyclic(aBouquetName)
	for _, tItem in pairs(VUHDO_BOUQUETS["STORED"][aBouquetName]) do
		if not VUHDO_BOUQUET_BUFFS_SPECIAL[tItem["name"]] or VUHDO_BOUQUET_BUFFS_SPECIAL[tItem["name"]]["updateCyclic"] then
			return true;
		end
	end

	return false;
end



--
local function VUHDO_registerForBouquet(aBouquetName, anOwnerName, aFunction)

	if VUHDO_strempty(aBouquetName) or VUHDO_strempty(anOwnerName) then
		return;
	elseif not VUHDO_BOUQUETS["STORED"][aBouquetName] then
		VUHDO_Msg(format(VUHDO_I18N_ERR_NO_BOUQUET, anOwnerName, aBouquetName), 1, 0.4, 0.4);

		return;
	end

	VUHDO_BOUQUETS["STORED"][aBouquetName] = VUHDO_decompressIfCompressed(VUHDO_BOUQUETS["STORED"][aBouquetName]);

	VUHDO_REGISTERED_BOUQUETS[aBouquetName][anOwnerName] = aFunction;

	if not VUHDO_REGISTERED_BOUQUET_INDICATORS[anOwnerName] then
		VUHDO_REGISTERED_BOUQUET_INDICATORS[anOwnerName] = { };
	end

	VUHDO_REGISTERED_BOUQUET_INDICATORS[anOwnerName][aBouquetName] = aFunction;

	VUHDO_activateBuffsInScanner(aBouquetName);

	for tUnit, _ in pairs(VUHDO_RAID) do
		aFunction(tUnit, false, nil, 0, 0, 0, nil, nil, nil);
	end

	if VUHDO_hasCyclic(aBouquetName) then
		VUHDO_CYCLIC_BOUQUETS[aBouquetName] = true;
	end

end



--
function VUHDO_registerForBouquetUnique(aBouquetName, anOwnerName, aFunction, anAlreadyRegistered)

	if not anAlreadyRegistered then
		return;
	end

	if not VUHDO_strempty(aBouquetName) and not VUHDO_strempty(anOwnerName) and not anAlreadyRegistered[aBouquetName .. anOwnerName] then
		VUHDO_registerForBouquet(aBouquetName, anOwnerName, aFunction);

		anAlreadyRegistered[aBouquetName .. anOwnerName] = true;
	end

end



--
local tHotSlots;
local tAlreadyRegistered = { };
function VUHDO_registerAllBouquets(aDoCompress)

	twipe(VUHDO_REGISTERED_BOUQUETS);
	twipe(VUHDO_CYCLIC_BOUQUETS);
	twipe(VUHDO_REGISTERED_BOUQUET_INDICATORS);

	if not VUHDO_BOUQUETS["STORED"] then return; end
	if (aDoCompress) then VUHDO_compressAllBouquets(); end

	twipe(tAlreadyRegistered);

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		if VUHDO_PANEL_MODELS[tPanelNum] then
			-- Hot Icons+Bars
			tHotSlots = VUHDO_PANEL_SETUP[tPanelNum]["HOTS"]["SLOTS"];

			for _, tHotName in pairs(tHotSlots) do
				if tHotName and "BOUQUET_" == strsub(tHotName, 1, 8) then
					VUHDO_registerForBouquetUnique(
						strsub(tHotName, 9),
						"HoT",
						VUHDO_hotBouquetCallback,
						tAlreadyRegistered
					);
				end
			end

			-- Bar (=Outer) Border
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["BAR_BORDER"],
				"Outer Border",
				VUHDO_barBorderBouquetCallback,
				tAlreadyRegistered
			);

			-- Cluster (=Inner) Border
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["CLUSTER_BORDER"],
				"Inner Border",
				VUHDO_clusterBorderBouquetCallback,
				tAlreadyRegistered
			);

			-- Swiftmend Indicator
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["SWIFTMEND_INDICATOR"],
				"Special Dot",
				VUHDO_swiftmendIndicatorBouquetCallback,
				tAlreadyRegistered
			);

			-- Aggro Line
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["AGGRO_BAR"],
				"Aggro Bar",
				VUHDO_aggroBarBouquetCallback,
				tAlreadyRegistered
			);

			-- Mouseover Highlighter
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["MOUSEOVER_HIGHLIGHT"],
				"Mouseover Highlight",
				VUHDO_highlighterBouquetCallback,
				tAlreadyRegistered
			);

			-- Threat Marks
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["THREAT_MARK"],
				"Threat Indicators",
				VUHDO_threatIndicatorsBouquetCallback,
				tAlreadyRegistered
			);

			-- Threat Bar
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["THREAT_BAR"],
				"THREAT_BAR",
				VUHDO_threatBarBouquetCallback,
				tAlreadyRegistered
			);

			-- Mana Bar
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["MANA_BAR"],
				"MANA_BAR",
				VUHDO_manaBarBouquetCallback,
				tAlreadyRegistered
			);

			-- Background Bar
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["BACKGROUND_BAR"],
				"Background Bar",
				VUHDO_backgroundBarBouquetCallback,
				tAlreadyRegistered
			);

			-- Health Bar
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["HEALTH_BAR"],
				"Health Bar",
				VUHDO_healthBarBouquetCallback,
				tAlreadyRegistered
			);

			-- Side bar left
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["SIDE_LEFT"],
				"SIDE_LEFT",
				VUHDO_sideBarLeftBouquetCallback,
				tAlreadyRegistered
			);

			-- Side bar right
			VUHDO_registerForBouquetUnique(
				VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["SIDE_RIGHT"],
				"SIDE_RIGHT",
				VUHDO_sideBarRightBouquetCallback,
				tAlreadyRegistered
			);
		end
	end

	for _, tBouquetName in pairs(VUHDO_CUSTOM_BOUQUETS) do
		VUHDO_BOUQUETS["STORED"][tBouquetName] = VUHDO_decompressIfCompressed(VUHDO_BOUQUETS["STORED"][tBouquetName]);
	end

	twipe(VUHDO_LAST_EVALUATED_BOUQUETS);

	VUHDO_updateGlobalToggles();
	VUHDO_initAllEventBouquets();

end



--
local VUHDO_EVENT_BOUQUETS = { };
setmetatable(VUHDO_EVENT_BOUQUETS, VUHDO_META_NEW_ARRAY);
local tName;
local function VUHDO_isBouquetInterestedInEvent(aBouquetName, anEventType)
	if not VUHDO_EVENT_BOUQUETS[aBouquetName][anEventType] then
		VUHDO_EVENT_BOUQUETS[aBouquetName][anEventType] = 0;

		for _, tItem in pairs(VUHDO_BOUQUETS["STORED"][aBouquetName]) do
			tName = tItem["name"];
			if VUHDO_BOUQUET_BUFFS_SPECIAL[tName] then

				for _, tInterest in pairs(VUHDO_BOUQUET_BUFFS_SPECIAL[tName]["interests"]) do
					if tInterest == anEventType then
						VUHDO_EVENT_BOUQUETS[aBouquetName][anEventType] = 1;
						break;
					end
				end

			end
		end
	end

	return 1 == VUHDO_EVENT_BOUQUETS[aBouquetName][anEventType] or 1 == anEventType; -- VUHDO_UPDATE_ALL
end



--
local tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, tHasChanged, tImpact, tTimer2;
local tClipL, tClipR, tClipT, tClipB;
local tMaxColor;
local function VUHDO_updateEventBouquet(aUnit, aBouquetName, anEventType)

	tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName,
		tHasChanged, tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB, tMaxColor
		= VUHDO_evaluateBouquet(aUnit, aBouquetName, nil);

	if not tHasChanged then
		return;
	end

	if tHasChanged or tIsActive then
		for _, tDelegate in pairs(VUHDO_REGISTERED_BOUQUETS[aBouquetName]) do
			tDelegate(aUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
				tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB, tMaxColor);
		end

		VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] = true;

		VUHDO_updateAllTextIndicatorsForEvent(aUnit, anEventType, aBouquetName, tIsActive);
	elseif VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] then
		for _, tDelegate in pairs(VUHDO_REGISTERED_BOUQUETS[aBouquetName]) do
			tDelegate(aUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
				tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB, tMaxColor);
		end

		VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] = false;

		VUHDO_updateAllTextIndicatorsForEvent(aUnit, anEventType, aBouquetName, false);
	end

	return;

end



--
local tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, _, tImpact, tTimer2;
local tClipL, tClipR, tClipT, tClipB;
local tMaxColor;
function VUHDO_invokeCustomBouquet(aButton, aUnit, anInfo, aBouquetName, aDelegate)
	tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName,
		_, tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB, tMaxColor
		= VUHDO_evaluateBouquet(aUnit, aBouquetName, anInfo);

	-- Do not check "hasChanged" because this is button-wise
	if tIsActive then
		aDelegate(aButton, aUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
			tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB, tMaxColor);
		VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] = true;
	elseif VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] then
		aDelegate(aButton, aUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
			tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB, tMaxColor);
		VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] = false;
	end
end



--
local function VUHDO_isAnyBouquetInterestedIn(anUpdateMode)
	for tName, _ in pairs(VUHDO_REGISTERED_BOUQUETS) do
		if VUHDO_isBouquetInterestedInEvent(tName, anUpdateMode) then return true; end
	end

	return false;
end



--
local tInfo;
function VUHDO_updateBouquetsForEvent(aUnit, anEventType)

	tInfo = VUHDO_RAID[aUnit];

	-- FIXME: if aUnit is nil they why iterate?
	for tName, _ in pairs(VUHDO_REGISTERED_BOUQUETS) do
		if VUHDO_isBouquetInterestedInEvent(tName, anEventType) then
			if tInfo then
				VUHDO_updateEventBouquet(aUnit, tName, anEventType);

			elseif aUnit then -- focus / n/a
				for _, tDelegate in pairs(VUHDO_REGISTERED_BOUQUETS[tName]) do
					if VUHDO_isBouquetInterestedInEvent(tName, VUHDO_UPDATE_DC) then
						tDelegate(aUnit, true, nil, 100, 0, 100, VUHDO_PANEL_SETUP["BAR_COLORS"]["OFFLINE"], nil, tName, 0);
					end
				end
			end
		end
	end

	VUHDO_updateAllTextIndicatorsForEvent(aUnit, anEventType);

	return;

end
local VUHDO_updateBouquetsForEvent = VUHDO_updateBouquetsForEvent;



-- Bei Panel-Redraw aufzurufen
function VUHDO_initAllEventBouquets()
	twipe(VUHDO_LAST_EVALUATED_BOUQUETS);
	for tUnit, _ in pairs(VUHDO_RAID) do
		VUHDO_updateBouquetsForEvent(tUnit, 1); -- VUHDO_UPDATE_ALL
	end

	VUHDO_updateBouquetsForEvent("focus", 19); -- VUHDO_UPDATE_DC
	VUHDO_updateBouquetsForEvent("target", 19); -- VUHDO_UPDATE_DC
	VUHDO_registerAllTextIndicators();
end



--
local tUnitToInit;
function VUHDO_initEventBouquetsFor(...)

	for tCnt = 1, select('#', ...) do
		tUnitToInit = select(tCnt, ...);

		for _, tAllBouquetUnits in pairs(VUHDO_LAST_EVALUATED_BOUQUETS) do
			for tUnit, tAllResults in pairs(tAllBouquetUnits) do
				if tUnit == tUnitToInit then
					tAllResults[1] = nil; -- Change "active" flag to enforce re-evaluation
				end
			end
		end

		VUHDO_updateBouquetsForEvent(tUnitToInit, 1); -- VUHDO_UPDATE_ALL
	end

	return;

end



--
local tAllListeners;
local tIsActive, tIcon, tTimer, tCounter, tDuration, tBuffName, tHasChanged, tImpact;
local tClipL, tClipR, tClipT, tClipB;
local tMaxColor;
local tDestArray;
function VUHDO_updateAllCyclicBouquets(anIsPlayerOnly)
	tDestArray = anIsPlayerOnly and sPlayerArray or VUHDO_RAID;

	for tBouquetName, _ in pairs(VUHDO_CYCLIC_BOUQUETS) do
		tAllListeners = VUHDO_REGISTERED_BOUQUETS[tBouquetName];

		for tUnit, _ in pairs(tDestArray) do
			tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, tHasChanged,
				tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB, tMaxColor = VUHDO_evaluateBouquet(tUnit, tBouquetName, nil);

			if tHasChanged and (tIsActive or VUHDO_ACTIVE_BOUQUETS[tUnit][tBouquetName]) then
				for _, tDelegate in pairs(tAllListeners) do
					tDelegate(tUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, tBouquetName,
						tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB, tMaxColor);
				end
				VUHDO_ACTIVE_BOUQUETS[tUnit][tBouquetName] = tIsActive;
			end


		end
	end
end



--
function VUHDO_bouqetsChanged()
	twipe(VUHDO_EVENT_BOUQUETS);
	VUHDO_initFromSpellbook();
	VUHDO_registerAllBouquets(false);
end



--
function VUHDO_isAnyoneInterestedIn(anUpdateMode)

	if (VUHDO_isAnyBouquetInterestedIn(anUpdateMode) or VUHDO_isAnyTextIndicatorInterestedIn(anUpdateMode)) then
		return true;
	else
		if 5 == anUpdateMode then -- VUHDO_UPDATE_RANGE
			return true;
		elseif 7 == anUpdateMode then -- VUHDO_UPDATE_AGGRO
			return VUHDO_CONFIG["THREAT"]["AGGRO_USE_TEXT"];
		elseif 16 == anUpdateMode then -- VUHDO_UPDATE_NUM_CLUSTER
			return VUHDO_getIsClusterSlotActive();
		elseif 22 == anUpdateMode then -- VUHDO_UPDATE_UNIT_TARGET
			for tCnt = 1, 10 do -- VUHDO_MAX_PANELS
				if VUHDO_PANEL_MODELS[tCnt] then
					if (VUHDO_PANEL_SETUP[tCnt]["SCALING"]["showTarget"] or VUHDO_PANEL_SETUP[tCnt]["SCALING"]["showTot"]) then
						return true;
					end
				end
			end
		end

		return false;
	end
end

function VUHDO_getRegisteredBouquets()

	return VUHDO_REGISTERED_BOUQUETS;

end

function VUHDO_getActiveBouquets()

	return VUHDO_ACTIVE_BOUQUETS;

end



--
function VUHDO_getRegisteredBouquetIndicators(anIndicatorName)

	if anIndicatorName then
		return VUHDO_REGISTERED_BOUQUET_INDICATORS[anIndicatorName];
	else
		return VUHDO_REGISTERED_BOUQUET_INDICATORS;
	end

end
