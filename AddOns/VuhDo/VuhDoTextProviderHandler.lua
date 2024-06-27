--local _ = _;
local pairs = pairs;




local VUHDO_RAID;

function VUHDO_textProviderHandlersInitLocalOverrides()
	VUHDO_RAID = _G["VUHDO_RAID"];
end



--
VUHDO_TEXT_PROVIDER_COMBO_MODEL = { };
local VUHDO_REGISTERED_PROVIDERS = { };
setmetatable(VUHDO_REGISTERED_PROVIDERS, VUHDO_META_NEW_ARRAY);
local VUHDO_INTERESTED_PROVIDERS = { };
setmetatable(VUHDO_INTERESTED_PROVIDERS, VUHDO_META_NEW_ARRAY);



--
local function VUHDO_isTextProviderInterestedInEvent(aProviderName, anEventType)

	if not VUHDO_INTERESTED_PROVIDERS[aProviderName][anEventType] then
		VUHDO_INTERESTED_PROVIDERS[aProviderName][anEventType] =
			VUHDO_tableGetKeyFromValue(VUHDO_TEXT_PROVIDERS[aProviderName]["interests"], anEventType) ~= nil
			and 1 or 0;
	end

	return 1 == VUHDO_INTERESTED_PROVIDERS[aProviderName][anEventType] or 1 == anEventType ; -- VUHDO_UPDATE_ALL
end



--
local tInfo;
local tText, tValue, tMaxValue;
local tEmpty = { };
function VUHDO_updateAllTextIndicatorsForEvent(aUnit, anEventType)
	tInfo = (VUHDO_RAID or tEmpty)[aUnit];
	if tInfo then

		for tProviderName, tAllIndicators in pairs(VUHDO_REGISTERED_PROVIDERS) do
			if VUHDO_isTextProviderInterestedInEvent(tProviderName, anEventType) then
				tValue, tMaxValue = VUHDO_TEXT_PROVIDERS[tProviderName]["calculator"](tInfo);
				tText = VUHDO_TEXT_PROVIDERS[tProviderName]["validator"](tInfo, tValue, tMaxValue);

				for tIndicatorName, tFunction in pairs(tAllIndicators) do
					tFunction(aUnit, tProviderName, tText, tValue, tIndicatorName);
				end

			end
		end
	elseif aUnit then

		for tProviderName, tAllIndicators in pairs(VUHDO_REGISTERED_PROVIDERS) do
			if VUHDO_isTextProviderInterestedInEvent(tProviderName, anEventType) then
				for tIndicatorName, tFunction in pairs(tAllIndicators) do
					tFunction(aUnit, tProviderName, "", 0, tIndicatorName);
				end
			end
		end

	end
end
local VUHDO_updateAllTextIndicatorsForEvent = VUHDO_updateAllTextIndicatorsForEvent;



--
function VUHDO_isAnyTextIndicatorInterestedIn(anEventType)
	for tProviderNameName, _ in pairs(VUHDO_REGISTERED_PROVIDERS) do
		if VUHDO_isTextProviderInterestedInEvent(tProviderNameName, anEventType) then
			return true;
		end
	end

	return false;
end



--
local function VUHDO_registerIndicatorForProvider(aProviderName, anIndicatorName, aFunction)

	VUHDO_REGISTERED_PROVIDERS[aProviderName][anIndicatorName] = aFunction;

	for tUnit, _ in pairs(VUHDO_RAID) do
		VUHDO_updateAllTextIndicatorsForEvent(tUnit, 1); -- VUHDO_UPDATE_ALL
	end

end



--
local function VUHDO_registerIndicatorForProviderUnique(aProviderName, anIndicatorName, aFunction, anAlreadyRegistered)

	if not anAlreadyRegistered then
		return;
	end

	if not VUHDO_strempty(aProviderName) and not VUHDO_strempty(anIndicatorName) and not anAlreadyRegistered[aProviderName .. anIndicatorName] then
		VUHDO_registerIndicatorForProvider(aProviderName, anIndicatorName, aFunction);

		anAlreadyRegistered[aProviderName .. anIndicatorName] = true;
	end

end



--
local function VUHDO_initTextProviderComboModel()
	table.wipe(VUHDO_TEXT_PROVIDER_COMBO_MODEL);

	for tName, tInfo in pairs(VUHDO_TEXT_PROVIDERS) do
		tinsert(VUHDO_TEXT_PROVIDER_COMBO_MODEL, { tName, tInfo["displayName"] });
	end

	table.sort(VUHDO_TEXT_PROVIDER_COMBO_MODEL,
		function(anEntry, anotherEntry)
			return anEntry[2] < anotherEntry[2];
		end
	);

	tinsert(VUHDO_TEXT_PROVIDER_COMBO_MODEL, 1, { "", "- empty / nothing -" });
end



--
local VUHDO_TEXT_INDICATOR_CALLBACKS = {
	["OVERHEAL_TEXT"] = "VUHDO_overhealTextCallback",
	["MANA_BAR"] = "VUHDO_manaBarTextCallback",
	["SIDE_LEFT"] = "VUHDO_sideLeftTextCallback",
	["SIDE_RIGHT"] = "VUHDO_sideRightTextCallback",
	["THREAT_BAR"] = "VUHDO_threatBarTextCallback",
}



--
local tAlreadyRegistered = { };
function VUHDO_registerAllTextIndicators()

	table.wipe(VUHDO_REGISTERED_PROVIDERS);
	table.wipe(VUHDO_INTERESTED_PROVIDERS);

	table.wipe(tAlreadyRegistered);

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		if VUHDO_PANEL_MODELS[tPanelNum] then
			for tIndicatorName, tIndicatorConfig in pairs(VUHDO_INDICATOR_CONFIG[tPanelNum]["TEXT_INDICATORS"]) do
				VUHDO_registerIndicatorForProviderUnique(tIndicatorConfig["TEXT_PROVIDER"], tIndicatorName, 
					_G[VUHDO_TEXT_INDICATOR_CALLBACKS[tIndicatorName]], tAlreadyRegistered);
			end
		end
	end

	VUHDO_initTextProviderComboModel();

end
