------------------------------
---NovaRaidCompanion Talents--
------------------------------
local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

local exportFrame, customStringFrame, tradeExportFrame;

local function loadExportFrame()
	if (not exportFrame) then
		exportFrame = NRC:createExportFrame("NRCExportFrame", 600, 300, 0, 100);
	end
end

local function getDateString()
	local dateType = NRC.config.exportDate;
	local d = "%Y-%m-%d";
	if (dateType == "mm/dd/yyyy") then
		d = "%m-%d-%Y";
	elseif (dateType == "dd/mm/yyyy") then
		d = "%d-%m-%Y";
	elseif (dateType == "yyyy/mm/dd") then
		d = "%Y-%m-%d";
	elseif (dateType == "yyyy/dd/mm") then
		d = "%Y-%d-%m";
	end
	return d;
end

local function generateGoogleLootExportString(logID)
	local data = NRC.db.global.instances[logID];
	if (not data) then
		return "Error generating export string, raid data not found.";
	end
	local mapToTrades = NRC.config.mapLootDisplayToTrades;
	local raidDate = date(getDateString(), data.enteredTime);
	local exportString = "date,player,itemName\n";
	if (NRC.config.lootExportLegendary) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 5, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			exportString = exportString .. raidDate .. "," .. name .. "," .. itemName .. "\n";
	    end
    end
    if (NRC.config.lootExportEpic) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 4, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			exportString = exportString .. raidDate .. "," .. name .. "," .. itemName .. "\n";
	    end
    end
    if (NRC.config.lootExportRare) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 3, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			exportString = exportString .. raidDate .. "," .. name .. "," .. itemName .. "\n";
	    end
    end
    if (NRC.config.lootExportUncommon) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 2, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			exportString = exportString .. raidDate .. "," .. name .. "," .. itemName .. "\n";
	    end
    end
    exportString = string.gsub(exportString, "\n$", "");
    return exportString;
end

local function generateThatsMyBisExportString(logID)
	local data = NRC.db.global.instances[logID];
	if (not data) then
		return "Error generating export string, raid data not found.";
	end
	local mapToTrades = NRC.config.mapLootDisplayToTrades;
	local raidDate = date(getDateString(), data.enteredTime);
	local exportString = "character,date,itemID,itemName\n";
	if (NRC.config.lootExportLegendary) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 5, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			exportString = exportString .. name .. "," .. raidDate .. "," .. itemID .. "," .. itemName .. "\n";
	    end
    end
    if (NRC.config.lootExportEpic) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 4, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			exportString = exportString .. name .. "," .. raidDate .. "," .. itemID .. "," .. itemName .. "\n";
	    end
    end
    if (NRC.config.lootExportRare) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 3, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			exportString = exportString .. name .. "," .. raidDate .. "," .. itemID .. "," .. itemName .. "\n";
	    end
    end
    if (NRC.config.lootExportUncommon) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 2, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			exportString = exportString .. name .. "," .. raidDate .. "," .. itemID .. "," .. itemName .. "\n";
	    end
    end
    exportString = string.gsub(exportString, "\n$", "");
    return exportString;
end

local function generateFightClubLootExportString(logID, usingID)
	local data = NRC.db.global.instances[logID];
	if (not data) then
		return "Error generating export string, raid data not found.";
	end
	local mapToTrades = NRC.config.mapLootDisplayToTrades;
	local raidDate = date("%m/%d/%Y", data.enteredTime);
	local exportString = "";
	exportString = exportString .. "   Attendees:\n\n";
	for k, v in pairs(data.group) do
		exportString = exportString .. v.name .. ";";
	end
	exportString = exportString .. "\n\n   Loot:\n\n";
	if (NRC.config.lootExportLegendary) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 5, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			if (usingID) then
				local _, itemID = strsplit(":", v.itemLink);
				exportString = exportString .. raidDate .. ";" .. itemID .. ";" .. name .. "\n";
			else
				exportString = exportString .. raidDate .. ";" .. v.itemLink .. ";" .. name .. "\n";
			end
	    end
    end
    if (NRC.config.lootExportEpic) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 4, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			if (usingID) then
				local _, itemID = strsplit(":", v.itemLink);
				exportString = exportString .. raidDate .. ";" .. itemID .. ";" .. name .. "\n";
			else
				exportString = exportString .. raidDate .. ";" .. v.itemLink .. ";" .. name .. "\n";
			end
	    end
    end
    if (NRC.config.lootExportRare) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 3, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			if (usingID) then
				local _, itemID = strsplit(":", v.itemLink);
				exportString = exportString .. raidDate .. ";" .. itemID .. ";" .. name .. "\n";
			else
				exportString = exportString .. raidDate .. ";" .. v.itemLink .. ";" .. name .. "\n";
			end
	    end
    end
    if (NRC.config.lootExportUncommon) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 2, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			if (usingID) then
				local _, itemID = strsplit(":", v.itemLink);
				exportString = exportString .. raidDate .. ";" .. itemID .. ";" .. name .. "\n";
			else
				exportString = exportString .. raidDate .. ";" .. v.itemLink .. ";" .. name .. "\n";
			end
	    end
    end
    exportString = string.gsub(exportString, "\n$", "");
    return exportString;
end

local function replaceCustomStringTokens(string, tokenData)
	local tokens = {};
	for token in string.gmatch(string, "(%%%a+%%)") do
		tinsert(tokens, token);
	end
	local error;
	if (not next(tokens)) then
		error = true;
	end
	if (tokenData and next(tokenData)) then
		if (tokenData.gold) then
			if (tokenData.gold < 1) then
				tokenData.gold = "0g";
			else
				tokenData.gold = NRC:convertMoney(tokenData.gold, true);
			end
		end
		local validTokens = {
			["%date%"] = "raidDate",
			["%player%"] = "name",
			["%itemlink%"] = "itemLink",
			["%itemname%"] = "itemName",
			["%itemid%"] = "itemID",
			["%gold%"] = "gold",
		};
		local replaced = string;
		for k, v in ipairs(tokens) do
			if (validTokens[v] and tokenData[validTokens[v]]) then
				replaced = string.gsub(replaced, "%" .. v .. "%", tokenData[validTokens[v]]);
			end
		end
		return replaced, error;
	else
		return "Error creating string.";
	end
end

local function generateCustomStringExportString(logID)
	local data = NRC.db.global.instances[logID];
	if (not data) then
		return "Error generating export string, raid data not found.";
	end
	local mapToTrades = NRC.config.mapLootDisplayToTrades;
	local raidDate = date(getDateString(), data.enteredTime);
	local exportString = NRC.config.exportCustomHeader;
	if (exportString ~= "") then
		exportString = NRC.config.exportCustomHeader .. "\n";
	end
	local exportCustomString = NRC.config.exportCustomString;
	if (NRC.config.lootExportLegendary) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 5, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			local tokenData = {
				raidDate = raidDate,
				name = name,
				itemLink = v.itemLink,
				itemName = itemName,
				itemID = itemID,
				gold = v.gold or 0,
			};
			local replaced, error = replaceCustomStringTokens(exportCustomString, tokenData);
			if (error) then
				print("|cFFFFFF00No valid tokens found, please check your custom export string and try again.");
				return;
			end
			if (replaced == exportCustomString) then
				replaced = "Error with custom string format, please check it.";
			end
			exportString = exportString .. replaced .. "\n";
	    end
    end
    if (NRC.config.lootExportEpic) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 4, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			local tokenData = {
				raidDate = raidDate,
				name = name,
				itemLink = v.itemLink,
				itemName = itemName,
				itemID = itemID,
				gold = v.gold or 0,
			};
			local replaced, error = replaceCustomStringTokens(exportCustomString, tokenData);
			if (error) then
				print("|cFFFFFF00No valid tokens found, please check your custom export string and try again.");
				return;
			end
			if (replaced == exportCustomString) then
				replaced = "Error with custom string format, please check it.";
			end
			exportString = exportString .. replaced .. "\n";
	    end
    end
    if (NRC.config.lootExportRare) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 3, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			local tokenData = {
				raidDate = raidDate,
				name = name,
				itemLink = v.itemLink,
				itemName = itemName,
				itemID = itemID,
				gold = v.gold or 0,
			};
			local replaced, error = replaceCustomStringTokens(exportCustomString, tokenData);
			if (error) then
				print("|cFFFFFF00No valid tokens found, please check your custom export string and try again.");
				return;
			end
			if (replaced == exportCustomString) then
				replaced = "Error with custom string format, please check it.";
			end
			exportString = exportString .. replaced .. "\n";
	    end
    end
    if (NRC.config.lootExportUncommon) then
		local loot, bossLoot, trashLoot, lootData = NRC:getLootData(logID, nil, 2, nil, nil, nil, not NRC.config.lootExportTradeskill, mapToTrades);
		for k, v in ipairs(lootData) do
			local name = v.name;
			if (v.override) then
				name = v.override;
			elseif (v.traded) then
				name = v.traded;
			end
			local _, itemID = strsplit(":", v.itemLink);
			local itemName = strmatch(v.itemLink, ":|h%[(.+)%]|h");
			local tokenData = {
				raidDate = raidDate,
				name = name,
				itemLink = v.itemLink,
				itemName = itemName,
				itemID = itemID,
				gold = v.gold or 0,
			};
			local replaced, error = replaceCustomStringTokens(exportCustomString, tokenData);
			if (error) then
				print("|cFFFFFF00No valid tokens found, please check your custom export string and try again.");
				return;
			end
			if (replaced == exportCustomString) then
				replaced = "Error with custom string format, please check it.";
			end
			exportString = exportString .. replaced .. "\n";
	    end
    end
    exportString = string.gsub(exportString, "\n$", "");
    return exportString;
end

local function updateCustomString()
	local str = customStringFrame.input2:GetText();
	local _, count = string.gsub(str, "%%", "");
	if (not count or (tonumber(count) and not (count % 2 == 0))) then
		print("Your custom export string seems wrong, please make sure you have spelled the tokens right with a % on both sides.")
	else
		NRC.config.exportCustomHeader = customStringFrame.input:GetText();
		NRC.config.exportCustomString = customStringFrame.input2:GetText();
		customStringFrame.input:ClearFocus();
		customStringFrame.input2:ClearFocus();
		if (NRCExportFrame and NRCExportFrame:IsShown()) then
			NRC:loadLootExportFrame(exportFrame.logID, true);
		end
	end
end

local function loadCreateCustomStringFrame(logID)
	local currentExportHeader = NRC.config.exportCustomHeader;
	local currentExportString = NRC.config.exportCustomString;
	if (not customStringFrame) then
		customStringFrame = NRC:createTextInputFrameLoot("NRCExportCustomStringFrame", 500, 150, exportFrame);
		customStringFrame:SetFrameLevel(20);
		customStringFrame.fs:SetFontObject(Game14Font);
		customStringFrame.fs:SetText("|cFFFFFF00" .. L["customExportStringFrameTitle"]);
		customStringFrame.fs2:SetText("|cFF00C800" .. L["customExportStringFrameHeader"]);
		customStringFrame.fs2:SetPoint("TOP", 0, -23);
		customStringFrame.fs3:SetText("|cFF00C800" .. L["customExportStringFrameText"] .. "\n"
				.. "|cFFFFFF00Tokens:|r|cFF9CD6DE %date% %player% %itemlink% %itemname% %itemid% %gold%|r");
		customStringFrame.fs3:SetPoint("TOP", 0, -65);
		customStringFrame.fs3:SetSpacing(2);
		customStringFrame:SetPoint("BOTTOM", exportFrame, "TOP", 0, -50);
		
		
		customStringFrame.setButton:SetPoint("BOTTOM", customStringFrame, "Bottom", -55, 8);
		customStringFrame.setButton:SetText(L["Set"]);
		customStringFrame.setButton:SetScript("OnClick", function(self, arg)
			updateCustomString();
		end)
		customStringFrame.setButton:Show();
		customStringFrame.resetButton:SetPoint("BOTTOM", customStringFrame, "Bottom", 55, 8);
		customStringFrame.resetButton:SetText(L["Reset"]);
		customStringFrame.resetButton:SetScript("OnClick", function(self, arg)
			NRC.config.exportCustomHeader = "date;player;itemlink;itemid";
			NRC.config.exportCustomString = "%date%;%player%;%itemlink%;%itemid%";
			loadCreateCustomStringFrame();
			if (NRCExportFrame and NRCExportFrame:IsShown()) then
				NRC:loadLootExportFrame(exportFrame.logID, true);
			end
		end)
		customStringFrame.resetButton:Show();

		
		customStringFrame.input = CreateFrame("EditBox", "$parentInput", customStringFrame, "InputBoxTemplate");
		customStringFrame.input:SetAutoFocus(false);
		customStringFrame.input:SetSize(450, 15);
		customStringFrame.input:SetPoint("CENTER", 0, 30);
		customStringFrame.input:SetTextColor(156/255, 214/255, 222/255);
		customStringFrame.input:SetScript("OnEscapePressed", function()
			customStringFrame.input:ClearFocus();
		end)
		customStringFrame.input:SetScript("OnEnterPressed", function()
			updateCustomString();
		end)
		--customStringFrame.input:SetScript("OnTextChanged, function()
		--	
		--end)
		
		customStringFrame.input.tooltip = CreateFrame("Frame", "$parentInputTooltip", customStringFrame.input, "TooltipBorderedFrameTemplate");
		customStringFrame.input.tooltip:SetFrameStrata("TOOLTIP");
		customStringFrame.input.tooltip:SetFrameLevel(9);
		customStringFrame.input.tooltip:SetPoint("BOTTOM", customStringFrame.input, "TOP", 0, 4);
		customStringFrame.input.tooltip.fs = customStringFrame.input.tooltip:CreateFontString("$parentInputTooltipFS", "ARTWORK");
		customStringFrame.input.tooltip.fs:SetPoint("CENTER", 0, 0);
		customStringFrame.input.tooltip.fs:SetFont(NRC.regionFont, 13);
		customStringFrame.input.tooltip.fs:SetJustifyH("LEFT");
		customStringFrame.input.tooltip.fs:SetText("|cFFFFFF00" .. L["customExportStringFrameHeaderTooltip"]);
		customStringFrame.input.tooltip:Hide();
		customStringFrame.input:SetScript("OnEnter", function(self)
			customStringFrame.input.tooltip:SetWidth(customStringFrame.input.tooltip.fs:GetStringWidth() + 18);
			customStringFrame.input.tooltip:SetHeight(customStringFrame.input.tooltip.fs:GetStringHeight() + 12);
			customStringFrame.input.tooltip:Show();
		end)
		customStringFrame.input:SetScript("OnLeave", function(self)
			customStringFrame.input.tooltip:Hide();
		end)
		
		customStringFrame.input2 = CreateFrame("EditBox", "$parentInput2", customStringFrame, "InputBoxTemplate");
		customStringFrame.input2:SetAutoFocus(false);
		customStringFrame.input2:SetSize(450, 15);
		customStringFrame.input2:SetPoint("CENTER", 0, -30);
		customStringFrame.input2:SetTextColor(156/255, 214/255, 222/255);
		customStringFrame.input2:SetScript("OnEscapePressed", function()
			customStringFrame.input2:ClearFocus();
		end)
		customStringFrame.input2:SetScript("OnEnterPressed", function()
			updateCustomString();
		end)
		
		customStringFrame.input2.tooltip2 = CreateFrame("Frame", "$parentInputTooltip", customStringFrame.input2, "TooltipBorderedFrameTemplate");
		customStringFrame.input2.tooltip2:SetFrameStrata("TOOLTIP");
		customStringFrame.input2.tooltip2:SetFrameLevel(9);
		customStringFrame.input2.tooltip2:SetPoint("BOTTOM", customStringFrame.input2, "TOP", 0, 22);
		customStringFrame.input2.tooltip2.fs = customStringFrame.input2.tooltip2:CreateFontString("$parentInputTooltipFS", "ARTWORK");
		customStringFrame.input2.tooltip2.fs:SetPoint("CENTER", 0, 0);
		customStringFrame.input2.tooltip2.fs:SetFont(NRC.regionFont, 13);
		customStringFrame.input2.tooltip2.fs:SetJustifyH("LEFT");
		customStringFrame.input2.tooltip2.fs:SetText("|cFFFFFF00" .. L["customExportStringFrameStringTooltip"]);
		customStringFrame.input2.tooltip2:Hide();
		customStringFrame.input2:SetScript("OnEnter", function(self)
			customStringFrame.input2.tooltip2:SetWidth(customStringFrame.input2.tooltip2.fs:GetStringWidth() + 18);
			customStringFrame.input2.tooltip2:SetHeight(customStringFrame.input2.tooltip2.fs:GetStringHeight() + 12);
			customStringFrame.input2.tooltip2:Show();
		end)
		customStringFrame.input2:SetScript("OnLeave", function(self)
			customStringFrame.input2.tooltip2:Hide();
		end)
		customStringFrame.dropdownMenu:Hide();
	end
	customStringFrame.input:SetText(currentExportHeader);
	customStringFrame.input2:SetText(currentExportString);
	customStringFrame:Show();
end

function NRC:loadLootExportFrame(logID, refresh)
	loadExportFrame();
	local type = NRC.config.exportType;
	exportFrame.EditBox:SetText("");
	exportFrame.logID = logID;
	if (not refresh) then
		exportFrame.topFrame.fs:SetText("|cFFFFFF00Loot Export");
		
		exportFrame.checkbox1.Text:SetText("|cFFff8000" .. L["Legendary"]);
		exportFrame.checkbox1:ClearAllPoints();
		exportFrame.checkbox1:SetPoint("TOPLEFT", exportFrame.topFrame, 5, -2);
		exportFrame.checkbox1:SetChecked(NRC.config.lootExportLegendary);
		exportFrame.checkbox1:SetScript("OnClick", function()
			local value = exportFrame.checkbox1:GetChecked();
			NRC.config.lootExportLegendary = value;
			NRC:loadLootExportFrame(logID)
		end)
		exportFrame.checkbox1:Show();
		
		exportFrame.checkbox2.Text:SetText("|cFFa335ee" .. L["Epic"]);
		exportFrame.checkbox2:ClearAllPoints();
		exportFrame.checkbox2:SetPoint("TOPLEFT", exportFrame.topFrame, 5, -20);
		exportFrame.checkbox2:SetChecked(NRC.config.lootExportEpic);
		exportFrame.checkbox2:SetScript("OnClick", function()
			local value = exportFrame.checkbox2:GetChecked();
			NRC.config.lootExportEpic = value;
			NRC:loadLootExportFrame(logID)
		end)
		exportFrame.checkbox2:Show();
		
		exportFrame.checkbox3.Text:SetText("|cFF0070dd" .. L["Rare"]);
		exportFrame.checkbox3:ClearAllPoints();
		exportFrame.checkbox3:SetPoint("TOPLEFT", exportFrame.topFrame, 5, -38);
		exportFrame.checkbox3:SetChecked(NRC.config.lootExportRare);
		exportFrame.checkbox3:SetScript("OnClick", function()
			local value = exportFrame.checkbox3:GetChecked();
			NRC.config.lootExportRare = value;
			NRC:loadLootExportFrame(logID)
		end)
		exportFrame.checkbox3:Show();
		
		exportFrame.checkbox4.Text:SetText("|cFF1eff00" .. L["Uncommon"]);
		exportFrame.checkbox4:ClearAllPoints();
		exportFrame.checkbox4:SetPoint("TOPLEFT", exportFrame.topFrame, 5, -56);
		exportFrame.checkbox4:SetChecked(NRC.config.lootExportUncommon);
		exportFrame.checkbox4:SetScript("OnClick", function()
			local value = exportFrame.checkbox4:GetChecked();
			NRC.config.lootExportUncommon = value;
			NRC:loadLootExportFrame(logID)
		end)
		exportFrame.checkbox4:Show();
		
		exportFrame.checkbox5.Text:SetText("|cFFDEDE42" .. L["Tradeskill"] .. "/Gems");
		exportFrame.checkbox5:ClearAllPoints();
		exportFrame.checkbox5:SetPoint("TOPLEFT", exportFrame.topFrame, 100, -56);
		exportFrame.checkbox5.tooltip2.fs:SetText("Gems, Sunmotes, other tradeskill items.");
		exportFrame.checkbox5:SetChecked(NRC.config.lootExportTradeskill);
		exportFrame.checkbox5:SetScript("OnClick", function()
			local value = exportFrame.checkbox5:GetChecked();
			NRC.config.lootExportTradeskill = value;
			NRC:loadLootExportFrame(logID)
		end)
		exportFrame.checkbox5:Show();
		
		exportFrame.dropdownMenu1:SetPoint("TOPRIGHT", exportFrame.topFrame, "TOPRIGHT", -20, -3);
		exportFrame.dropdownMenu1.tooltip.fs:SetText("|Cffffd000" .. L["exportTypeTooltip"]);
		exportFrame.dropdownMenu1.tooltip:SetWidth(exportFrame.dropdownMenu1.tooltip.fs:GetStringWidth() + 18);
		exportFrame.dropdownMenu1.tooltip:SetHeight(exportFrame.dropdownMenu1.tooltip.fs:GetStringHeight() + 12);
		exportFrame.dropdownMenu1.tooltip:ClearAllPoints();
		exportFrame.dropdownMenu1.tooltip:SetPoint("BOTTOM", exportFrame.dropdownMenu1, "TOP", 0, 5);
		NRC.DDM:UIDropDownMenu_SetWidth(exportFrame.dropdownMenu1, 155);
		exportFrame.dropdownMenu1.initialize = function(dropdown)
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DE" .. L["Google Spreadsheet"];
			info.checked = false;
			info.value = "google";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportType = info.value;
				NRC:loadLootExportFrame(logID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DE" .. L["DFT Fight Club"];
			info.checked = false;
			info.value = "fightclub";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportType = info.value;
				NRC:loadLootExportFrame(logID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DE" .. L["DFT Fight Club Item IDs"];
			info.checked = false;
			info.value = "fightclubids";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportType = info.value;
				NRC:loadLootExportFrame(logID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DE" .. L["That's My BIS"];
			info.checked = false;
			info.value = "thatsmybis";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportType = info.value;
				NRC:loadLootExportFrame(logID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			NRC.DDM:UIDropDownMenu_AddSeparator();
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFFDEDE42" .. L["Use Custom String"];
			info.checked = false;
			info.value = "customstring";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportType = info.value;
				NRC:loadLootExportFrame(logID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			--NRC.DDM:UIDropDownMenu_AddSeparator();
			if (not NRC.DDM:UIDropDownMenu_GetSelectedValue(exportFrame.dropdownMenu1)) then
				--If no value set then it's first load, set saved db value.
				NRC.DDM:UIDropDownMenu_SetSelectedValue(exportFrame.dropdownMenu1, NRC.config.exportType);
			end
		end
		NRC.DDM:UIDropDownMenu_Initialize(exportFrame.dropdownMenu1, exportFrame.dropdownMenu1.initialize);
		--exportFrame.dropdownMenu1:HookScript("OnShow", function() NRC.DDM:UIDropDownMenu_Initialize(exportFrame.dropdownMenu1) end);
		--If we reopen then reset the dropdowns.
		--if (resetDropdowns) then
		--	NRC.DDM:UIDropDownMenu_SetSelectedValue(exportFrame.dropdownMenu1, NRC.config.exportType);
		--end
		exportFrame.dropdownMenu1:Show();
		
		
		exportFrame.dropdownMenu2:SetPoint("TOPRIGHT", exportFrame.topFrame, "TOPRIGHT", -20, -28);
		exportFrame.dropdownMenu2.tooltip.fs:SetText("|Cffffd000" .. L["exportDateTooltip"]);
		exportFrame.dropdownMenu2.tooltip:SetWidth(exportFrame.dropdownMenu2.tooltip.fs:GetStringWidth() + 18);
		exportFrame.dropdownMenu2.tooltip:SetHeight(exportFrame.dropdownMenu2.tooltip.fs:GetStringHeight() + 12);
		exportFrame.dropdownMenu2.tooltip:ClearAllPoints();
		exportFrame.dropdownMenu2.tooltip:SetPoint("BOTTOM", exportFrame.dropdownMenu2, "TOP", 0, 5);
		NRC.DDM:UIDropDownMenu_SetWidth(exportFrame.dropdownMenu2, 155);
		exportFrame.dropdownMenu2.initialize = function(dropdown)
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DEmm/dd/yyyy";
			info.checked = false;
			info.value = "mm/dd/yyyy";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportDate = info.value;
				NRC:loadLootExportFrame(logID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DEdd/mm/yyyy";
			info.checked = false;
			info.value = "dd/mm/yyyy";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportDate = info.value;
				NRC:loadLootExportFrame(logID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DEyyyy/mm/dd";
			info.checked = false;
			info.value = "yyyy/mm/dd";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportDate = info.value;
				NRC:loadLootExportFrame(logID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DEyyyy/dd/mm";
			info.checked = false;
			info.value = "yyyy/dd/mm";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportDate = info.value;
				NRC:loadLootExportFrame(logID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			if (not NRC.DDM:UIDropDownMenu_GetSelectedValue(exportFrame.dropdownMenu2)) then
				--If no value set then it's first load, set saved db value.
				NRC.DDM:UIDropDownMenu_SetSelectedValue(exportFrame.dropdownMenu2, NRC.config.exportDate);
			end
		end
		NRC.DDM:UIDropDownMenu_Initialize(exportFrame.dropdownMenu2, exportFrame.dropdownMenu2.initialize);
		exportFrame.dropdownMenu2:Show();
	end
	exportFrame.topFrame.button:Hide();
	local text = "Error, export type not found.";
	if (type == "google") then
		--text = "Google export feature unfinished, if you would like a format added that your guild uses please ask on my discord https://discord.gg/RTKMfTmkdj";
		text = generateGoogleLootExportString(logID);
	elseif (type == "fightclub") then
		text = generateFightClubLootExportString(logID);
	elseif (type == "fightclubids") then
		text = generateFightClubLootExportString(logID, true);
	elseif (type == "thatsmybis") then
		text = generateThatsMyBisExportString(logID, true);
	elseif (type == "customstring") then
		exportFrame.topFrame.button:Show();
		text = generateCustomStringExportString(logID, true);
	end
	exportFrame.topFrame.button:SetText("Create Custom Export String");
	exportFrame.topFrame.button:SetScript("OnClick", function(self, arg)
		loadCreateCustomStringFrame();
	end)
	exportFrame.EditBox:Insert(text);
	exportFrame.EditBox:HighlightText();
	C_Timer.After(0.1, function()
		exportFrame.EditBox:SetFocus();
	end)
	exportFrame:Show();
end


------------
---Trades---
------------

local function generateTradesExportString(logID, raidID)
	local data = NRC:getTradeData(logID, raidID);
	if (not data) then
		return "Error generating export string, trade data not found.";
	end
	local mapToTrades = NRC.config.mapLootDisplayToTrades;
	local raidDate = date(getDateString(), data.enteredTime);
	local exportString = "";
	local start = NRC.config.tradeExportStart;
	local finish = NRC.config.tradeExportEnd;
	local itemsType = NRC.config.tradeExportItemsType;
	local wowheadLink = "https://www.wowhead.com/item=";
	if (NRC.isWrath) then
		wowheadLink = "https://www.wowhead.com/wotlk/item=";
	elseif (NRC.isTBC) then
		wowheadLink = "https://www.wowhead.com/tbc/item=";
	elseif (NRC.isClassic) then
		wowheadLink = "https://www.wowhead.com/classic/item=";
	end
	local maxItemsGiven = 0;
	local maxItemsReceived = 0;
	local raidData = NRC.db.global.instances[logID];
	local header = "";
	if (raidID) then
		local instanceName = string.gsub(raidData.instanceName, ".+: ", "");
		local timeString = date(getDateString(), raidData.enteredTime) .. " " .. date("%X", raidData.enteredTime);
		header = header .. "Raid: " .. (instanceName  or "Unknown Raid Name") .. " (" ..(raidData.difficultyName or "Unknown Difficulty") .. ") on " .. timeString .. "\n\n";
	end
	if (NRC.config.tradeExportAttendees and raidID and raidData.group) then
		header = header .. "Attendees:\n";
		if (next(raidData.group)) then
			for k, v in pairs(raidData.group) do
				header = header .. v.name .. ";";
			end
		else
			header = header .. "None found.";
		end
		header = header .. "\n\nTrades:\n";
	end
	--We have to calc cell count first.
	for k, v in ipairs(data) do
		if (NRC.config.tradeExportItemsGiven) then
			if (v.playerItems and next(v.playerItems)) then
				local count = 0;
				for _, itemData in pairs(v.playerItems) do
					count = count + 1;
				end
				if (count > maxItemsGiven) then
					maxItemsGiven = count;
				end
			end
		end
		if (NRC.config.tradeExportItemsReceived) then
			if (v.targetItems and next(v.targetItems)) then
				local count = 0;
				for _, itemData in pairs(v.targetItems) do
					count = count + 1;
				end
				if (count > maxItemsReceived) then
					maxItemsReceived = count;
				end
			end
		end
	end
	for k, v in ipairs(data) do
		if (k >= start and k <= finish) then
			local found;
			local itemsFound;
			local time = date("%X", v.time);
			local date = date(getDateString(), v.time);
			local from = v.me;
			local to = v.tradeWho;
			local goldGiven = "";
			local goldReceived = "";
			local itemsGiven = ""; --Option for wowhead hyperlinks?
			local itemsReceived = "";
			local enchantGiven = "";
			local enchantReceived = "";
			local tempExportString = "";
			--Find if any items exists or only a gold trade ahead of time for spacxng reasons.
			if ((v.playerItems and next(v.playerItems))
					or (v.targetItems and next(v.targetItems))
					or (v.targetItemsEnchant and next(v.targetItemsEnchant))
					or (v.playerItemsEnchant and next(v.playerItemsEnchant))) then
				itemsFound = true;
			end
			--Gold given.
			if (NRC.config.tradeExportGoldGiven) then
				if (v.playerMoney and v.playerMoney > 0) then
					goldGiven = NRC:convertMoney(v.playerMoney, true);
					found = true;
				end
				tempExportString = tempExportString .. "," .. goldGiven;
			end
			--Gold received.
			if (NRC.config.tradeExportGoldReceived) then
				if (v.targetMoney and v.targetMoney > 0) then
					goldReceived = NRC:convertMoney(v.targetMoney, true);
					found = true;
				end
				tempExportString = tempExportString .. "," .. goldReceived;
			end
			--Items given.
			if (NRC.config.tradeExportItemsGiven) then
				if (v.playerItems and next(v.playerItems)) then
					local count = 0;
					for _, itemData in pairs(v.playerItems) do
						count = count + 1;
						if (count > 1) then
							itemsGiven = itemsGiven .. ",";
						end
						local amountString = "";
						if (itemData.count) then
							amountString = "x" .. itemData.count;
						end
						if (itemsType == "wowhead") then
							if (itemData.itemLink) then
								local _, itemID = strsplit(":", itemData.itemLink);
								if (itemID) then
									local name = strmatch(itemData.itemLink, "%[(.+)%]");
									itemsGiven = itemsGiven .. "=HYPERLINK(\"" .. wowheadLink .. itemID .. "\";\"[" .. (name or "Unknown") .. "]"  .. amountString .. "\")";
								elseif (itemData.name) then
									itemsGiven = itemsGiven .. "[" .. itemData.name .. "]" .. amountString;
								else
									itemsGiven = itemsGiven .. "Missing Item Name" .. amountString;
								end
							else
								if (itemData.name) then
									itemsGiven = itemsGiven .. "[" .. itemData.name .. "]" .. amountString;
								else
									itemsGiven = itemsGiven .. "Missing Item Name" .. amountString;
								end
							end
						end
					end
					found = true;
				end
				--We need to make sure we have enough commas for the cell count we're displaying.
				--Cell count is dynamic based on how many items at once is the max traded.
				if (itemsFound) then
					local _, count = string.gsub(itemsGiven, ",", "");
					if (count < maxItemsGiven) then
						local diff = maxItemsGiven - count;
						for i = 1, diff - 1 do
							itemsGiven = itemsGiven .. ",";
						end
					end
				end
				tempExportString = tempExportString .. "," .. itemsGiven;
			end
			--Items received.
			if (NRC.config.tradeExportItemsReceived) then
				if (v.targetItems and next(v.targetItems)) then
					local count = 0;
					for _, itemData in pairs(v.targetItems) do
						count = count + 1;
						if (count > 1) then
							itemsReceived = itemsReceived .. ",";
						end
						local amountString = "";
						if (itemData.count) then
							amountString = "x" .. itemData.count;
						end
						if (itemsType == "wowhead") then
							if (itemData.itemLink) then
								local _, itemID = strsplit(":", itemData.itemLink);
								if (itemID) then
									local name = strmatch(itemData.itemLink, "%[(.+)%]");
									itemsReceived = itemsReceived .. "=HYPERLINK(\"" .. wowheadLink .. itemID .. "\";\"[" .. (name or "Unknown") .. "]"  .. amountString .. "\")";
								elseif (itemData.name) then
									itemsReceived = itemsReceived .. "[" .. itemData.name .. "]" .. amountString;
								else
									itemsReceived = itemsReceived .. "Missing Item Name" .. amountString;
								end
							else
								if (itemData.name) then
									itemsReceived = itemsReceived .. "[" .. itemData.name .. "]" .. amountString;
								else
									itemsReceived = itemsGiven .. "Missing Item Name" .. amountString;
								end
							end
						end
					end
					found = true;
				end
				--We need to make sure we have enough commas for the cell count we're displaying.
				--Cell count is dynamic based on how many items at once is the max traded.
				if (itemsFound) then
					local _, count = string.gsub(itemsReceived, ",", "");
					if (count < maxItemsReceived) then
						local diff = maxItemsReceived - count;
						for i = 1, diff - 1 do
							itemsReceived = itemsReceived .. ",";
						end
					end
				end
				tempExportString = tempExportString .. "," .. itemsReceived;
			end
			--Enchants.
			if (NRC.config.tradeExportEnchants) then
				if (v.targetItemsEnchant and next(v.targetItemsEnchant)) then
					for _, itemData in pairs(v.targetItemsEnchant) do
						local text = (itemData.enchant or "Unknown Enchant");
						--[[if (itemsType == "wowhead") then
							if (itemData.itemLink) then
								local _, itemID = strsplit(":", itemData.itemLink);
								if (itemID) then
									local name = strmatch(itemData.itemLink, "%[(.+)%]");
									text = text .. " on =HYPERLINK(\"" .. wowheadLink .. itemID .. "\":\"[" .. (name or "Unknown") .. "]\")";
								elseif (itemData.name) then
									text = text .. " on [" .. itemData.name .. "]";
								else
									text = text .. " on Missing Item Name";
								end
							else
								if (itemData.name) then
									text = text .. " on [" .. itemData.name .. "]";
								else
									text = text .. " on Missing Item Name";
								end
							end
						end]]
						enchantGiven = text;
					end
					found = true;
				end
				if (v.playerItemsEnchant and next(v.playerItemsEnchant)) then
					for _, itemData in pairs(v.playerItemsEnchant) do
						local text = (itemData.enchant or "Unknown Enchant");
						--[[if (itemsType == "wowhead") then
							if (itemData.itemLink) then
								local _, itemID = strsplit(":", itemData.itemLink);
								if (itemID) then
									local name = strmatch(itemData.itemLink, "%[(.+)%]");
									text = text .. " on =HYPERLINK(\"" .. wowheadLink .. itemID .. "\";\"[" .. (name or "Unknown") .. "]\")";
								elseif (itemData.name) then
									text = text .. " on [" .. itemData.name .. "]";
								else
									text = text .. " on Missing Item Name";
								end
							else
								if (itemData.name) then
									text = text .. " on [" .. itemData.name .. "]";
								else
									text = text .. " on Missing Item Name";
								end
							end
						end]]
						enchantReceived = text;
					end
					found = true;
				end
				tempExportString = tempExportString .. "," .. enchantGiven .. "," .. enchantReceived;
			end
			if (found) then
				exportString = exportString .. "\n" .. date .. "," .. time .. "," .. from .. "," .. to .. tempExportString;
			end
		end
	end
	header = header .. "Date,Time,MyCharacter,TradePartner"; --Add class colors option?
	if (NRC.config.tradeExportGoldGiven) then
		header = header .. ",GoldGiven";
	end
	if (NRC.config.tradeExportGoldReceived) then
		header = header .. ",GoldReceived";
	end
	if (NRC.config.tradeExportItemsGiven) then
		if (maxItemsGiven == 0) then
			header = header .. ",GaveItem1";
		else
			for i = 1, maxItemsGiven do
				header = header .. ",GaveItem" .. i;
			end
		end
	end
	if (NRC.config.tradeExportItemsReceived) then
		if (maxItemsReceived == 0) then
			header = header .. ",ReceivedItem1";
		else
			for i = 1, maxItemsReceived do
				header = header .. ",ReceivedItem" .. i;
			end
		end
	end
	if (NRC.config.tradeExportEnchants) then
		header = header .. ",EnchantGiven,EnchantReceived";
	end
    exportString = header .. string.gsub(exportString, "\n$", "");
    return exportString;
end

function NRC:loadTradesExportFrame(logID, raidID, refresh)
	if (not tradeExportFrame) then
		tradeExportFrame = NRC:createTradeExportFrame("NRCTradeExportFrame", 700, 400, 0, 100);
	end
	local type = NRC.config.exportType;
	local maxTradesShown = NRC.db.global.maxTradesShown;
	tradeExportFrame.EditBox:SetText("");
	tradeExportFrame.logID = logID;
	if (not refresh) then
		tradeExportFrame.checkbox1.Text:SetText("|cFF9CD6DE" .. L["Gold Given"]);
		tradeExportFrame.checkbox1:ClearAllPoints();
		tradeExportFrame.checkbox1:SetPoint("TOPLEFT", tradeExportFrame.topFrame, 5, -2);
		tradeExportFrame.checkbox1:SetChecked(NRC.config.tradeExportGoldGiven);
		tradeExportFrame.checkbox1:SetScript("OnClick", function()
			local value = tradeExportFrame.checkbox1:GetChecked();
			NRC.config.tradeExportGoldGiven = value;
			NRC:loadTradesExportFrame(logID, raidID, true);
		end)
		tradeExportFrame.checkbox1:Show();
		
		tradeExportFrame.checkbox2.Text:SetText("|cFF9CD6DE" .. L["Gold Received"]);
		tradeExportFrame.checkbox2:ClearAllPoints();
		tradeExportFrame.checkbox2:SetPoint("TOPLEFT", tradeExportFrame.topFrame, 5, -20);
		tradeExportFrame.checkbox2:SetChecked(NRC.config.tradeExportGoldReceived);
		tradeExportFrame.checkbox2:SetScript("OnClick", function()
			local value = tradeExportFrame.checkbox2:GetChecked();
			NRC.config.tradeExportGoldReceived = value;
			NRC:loadTradesExportFrame(logID, raidID, true);
		end)
		tradeExportFrame.checkbox2:Show();
		
		tradeExportFrame.checkbox3.Text:SetText("|cFF9CD6DE" .. L["Items Given"]);
		tradeExportFrame.checkbox3:ClearAllPoints();
		tradeExportFrame.checkbox3:SetPoint("TOPLEFT", tradeExportFrame.topFrame, 5, -38);
		tradeExportFrame.checkbox3:SetChecked(NRC.config.tradeExportItemsGiven);
		tradeExportFrame.checkbox3:SetScript("OnClick", function()
			local value = tradeExportFrame.checkbox3:GetChecked();
			NRC.config.tradeExportItemsGiven = value;
			NRC:loadTradesExportFrame(logID, raidID, true);
		end)
		tradeExportFrame.checkbox3:Show();
		
		tradeExportFrame.checkbox4.Text:SetText("|cFF9CD6DE" .. L["Items Received"]);
		tradeExportFrame.checkbox4:ClearAllPoints();
		tradeExportFrame.checkbox4:SetPoint("TOPLEFT", tradeExportFrame.topFrame, 5, -56);
		tradeExportFrame.checkbox4:SetChecked(NRC.config.tradeExportItemsReceived);
		tradeExportFrame.checkbox4:SetScript("OnClick", function()
			local value = tradeExportFrame.checkbox4:GetChecked();
			NRC.config.tradeExportItemsReceived = value;
			NRC:loadTradesExportFrame(logID, raidID, true);
		end)
		tradeExportFrame.checkbox4:Show();
		
		tradeExportFrame.checkbox5.Text:SetText("|cFF9CD6DE" .. L["Enchants"]);
		tradeExportFrame.checkbox5:ClearAllPoints();
		tradeExportFrame.checkbox5:SetPoint("TOPLEFT", tradeExportFrame.topFrame, 5, -74);
		--tradeExportFrame.checkbox5.tooltip2.fs:SetText("");
		tradeExportFrame.checkbox5:SetChecked(NRC.config.tradeExportEnchants);
		tradeExportFrame.checkbox5:SetScript("OnClick", function()
			local value = tradeExportFrame.checkbox5:GetChecked();
			NRC.config.tradeExportEnchants = value;
			NRC:loadTradesExportFrame(logID, raidID, true);
		end)
		tradeExportFrame.checkbox5:Show();
		
		tradeExportFrame.checkbox6.Text:SetText("|cFF9CD6DE" .. L["Include Raid Attendees"]);
		tradeExportFrame.checkbox6:ClearAllPoints();
		tradeExportFrame.checkbox6:SetPoint("BOTTOM", tradeExportFrame.topFrame, -65, 28);
		--tradeExportFrame.checkbox6.tooltip2.fs:SetText("");
		tradeExportFrame.checkbox6:SetChecked(NRC.config.tradeExportAttendees);
		tradeExportFrame.checkbox6:SetScript("OnClick", function()
			local value = tradeExportFrame.checkbox6:GetChecked();
			NRC.config.tradeExportAttendees = value;
			NRC:loadTradesExportFrame(logID, raidID, true);
		end)
		tradeExportFrame.checkbox6:Show();
		
		tradeExportFrame.dropdownMenu1:SetPoint("TOPRIGHT", tradeExportFrame.topFrame, "TOPRIGHT", -20, -3);
		tradeExportFrame.dropdownMenu1.tooltip.fs:SetText("|Cffffd000" .. L["tradeExportItemsTypeTooltip"]);
		tradeExportFrame.dropdownMenu1.tooltip:SetWidth(tradeExportFrame.dropdownMenu1.tooltip.fs:GetStringWidth() + 18);
		tradeExportFrame.dropdownMenu1.tooltip:SetHeight(tradeExportFrame.dropdownMenu1.tooltip.fs:GetStringHeight() + 12);
		tradeExportFrame.dropdownMenu1.tooltip:ClearAllPoints();
		tradeExportFrame.dropdownMenu1.tooltip:SetPoint("BOTTOM", tradeExportFrame.dropdownMenu1, "TOP", 0, 5);
		NRC.DDM:UIDropDownMenu_SetWidth(tradeExportFrame.dropdownMenu1, 155);
		tradeExportFrame.dropdownMenu1.initialize = function(dropdown)
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DE" .. L["Wowhead Links"];
			info.checked = false;
			info.value = "wowhead";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.tradeExportItemsType = info.value;
				NRC:loadTradesExportFrame(logID, raidID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DE" .. L["Item Names"];
			info.checked = false;
			info.value = "namecolor";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.tradeExportItemsType = info.value;
				NRC:loadTradesExportFrame(logID, raidID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			--[[local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DE" .. L["Item Names"];
			info.checked = false;
			info.value = "namenocolor";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.tradeExportItemsType = info.value;
				NRC:loadTradesExportFrame(logID, raidID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DE" .. L["Item Ingame Link"];
			info.checked = false;
			info.value = "ingamelink";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.tradeExportItemsType = info.value;
				NRC:loadTradesExportFrame(logID, raidID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);]]
			if (not NRC.DDM:UIDropDownMenu_GetSelectedValue(tradeExportFrame.dropdownMenu1)) then
				--If no value set then it's first load, set saved db value.
				NRC.DDM:UIDropDownMenu_SetSelectedValue(tradeExportFrame.dropdownMenu1, NRC.config.tradeExportItemsType);
			end
		end
		NRC.DDM:UIDropDownMenu_Initialize(tradeExportFrame.dropdownMenu1, tradeExportFrame.dropdownMenu1.initialize);
		--tradeExportFrame.dropdownMenu1:HookScript("OnShow", function() NRC.DDM:UIDropDownMenu_Initialize(tradeExportFrame.dropdownMenu1) end);
		--If we reopen then reset the dropdowns.
		--if (resetDropdowns) then
		--	NRC.DDM:UIDropDownMenu_SetSelectedValue(tradeExportFrame.dropdownMenu1, NRC.config.exportType);
		--end
		tradeExportFrame.dropdownMenu1:Show();
		
		
		tradeExportFrame.dropdownMenu2:SetPoint("TOPRIGHT", tradeExportFrame.topFrame, "TOPRIGHT", -20, -28);
		tradeExportFrame.dropdownMenu2.tooltip.fs:SetText("|Cffffd000" .. L["exportDateTooltip"]);
		tradeExportFrame.dropdownMenu2.tooltip:SetWidth(tradeExportFrame.dropdownMenu2.tooltip.fs:GetStringWidth() + 18);
		tradeExportFrame.dropdownMenu2.tooltip:SetHeight(tradeExportFrame.dropdownMenu2.tooltip.fs:GetStringHeight() + 12);
		tradeExportFrame.dropdownMenu2.tooltip:ClearAllPoints();
		tradeExportFrame.dropdownMenu2.tooltip:SetPoint("BOTTOM", tradeExportFrame.dropdownMenu2, "TOP", 0, 5);
		NRC.DDM:UIDropDownMenu_SetWidth(tradeExportFrame.dropdownMenu2, 155);
		tradeExportFrame.dropdownMenu2.initialize = function(dropdown)
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DEmm/dd/yyyy";
			info.checked = false;
			info.value = "mm/dd/yyyy";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportDate = info.value;
				NRC:loadTradesExportFrame(logID, raidID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DEdd/mm/yyyy";
			info.checked = false;
			info.value = "dd/mm/yyyy";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportDate = info.value;
				NRC:loadTradesExportFrame(logID, raidID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DEyyyy/mm/dd";
			info.checked = false;
			info.value = "yyyy/mm/dd";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportDate = info.value;
				NRC:loadTradesExportFrame(logID, raidID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			local info = NRC.DDM:UIDropDownMenu_CreateInfo()
			info.text = "|cFF9CD6DEyyyy/dd/mm";
			info.checked = false;
			info.value = "yyyy/dd/mm";
			info.func = function(self)
				NRC.DDM:UIDropDownMenu_SetSelectedValue(dropdown, self.value)
				NRC.config.exportDate = info.value;
				NRC:loadTradesExportFrame(logID, raidID, true);
			end
			NRC.DDM:UIDropDownMenu_AddButton(info);
			if (not NRC.DDM:UIDropDownMenu_GetSelectedValue(tradeExportFrame.dropdownMenu2)) then
				--If no value set then it's first load, set saved db value.
				NRC.DDM:UIDropDownMenu_SetSelectedValue(tradeExportFrame.dropdownMenu2, NRC.config.exportDate);
			end
		end
		NRC.DDM:UIDropDownMenu_Initialize(tradeExportFrame.dropdownMenu2, tradeExportFrame.dropdownMenu2.initialize);
		tradeExportFrame.dropdownMenu2:Show();
		
		tradeExportFrame.slider1:SetPoint("BOTTOM", tradeExportFrame.topFrame, "Bottom", -90, 38);
		NRCTradeExportFrameTopFrameSlider1Text:SetText("|cFFFF6900" ..  L["Start Trade Num"]);
		tradeExportFrame.slider1.tooltip = "Set which trade number to start from.";
		tradeExportFrame.slider1:SetMinMaxValues(1, maxTradesShown);
		tradeExportFrame.slider1:SetValue(NRC.config.tradeExportStart);
		tradeExportFrame.slider1.editBox:SetText(NRC.config.tradeExportStart);
	    NRCTradeExportFrameTopFrameSlider1Low:SetText("1");
	    NRCTradeExportFrameTopFrameSlider1High:SetText(maxTradesShown);
		tradeExportFrame.slider1:HookScript("OnValueChanged", function(self, value)
			NRC.config.tradeExportStart = value;
			tradeExportFrame.slider1.editBox:SetText(value);
			NRC:loadTradesExportFrame(logID, raidID, true);
		end)
		local function EditBox_OnEnterPressed(frame)
			local value = frame:GetText();
			value = tonumber(value);
			if value then
				PlaySound(856);
				NRC.config.tradeExportStart = value;
				tradeExportFrame.slider1:SetValue(value);
				frame:ClearFocus();
				NRC:loadTradesExportFrame(logID, raidID, true);
			else
				--If not a valid number reset the box.
				tradeExportFrame.slider1.editBox:SetText(NRC.config.tradeExportStart);
				frame:ClearFocus();
			end
		end
		tradeExportFrame.slider1.editBox:SetScript("OnEnterPressed", EditBox_OnEnterPressed);
		
		tradeExportFrame.slider2:SetPoint("BOTTOM", tradeExportFrame.topFrame, "Bottom", 190, 38);
		NRCTradeExportFrameTopFrameSlider2Text:SetText("|cFFFF6900" ..  L["End Trade Num"]);
		tradeExportFrame.slider2.tooltip = "Set which trade number to start from.";
		tradeExportFrame.slider2:SetMinMaxValues(1, maxTradesShown);
		tradeExportFrame.slider2:SetValue(NRC.config.tradeExportEnd);
		tradeExportFrame.slider2.editBox:SetText(NRC.config.tradeExportEnd);
	    NRCTradeExportFrameTopFrameSlider2Low:SetText("1");
	    NRCTradeExportFrameTopFrameSlider2High:SetText(maxTradesShown);
		tradeExportFrame.slider2:HookScript("OnValueChanged", function(self, value)
			NRC.config.tradeExportEnd = value;
			tradeExportFrame.slider2.editBox:SetText(value);
			NRC:loadTradesExportFrame(logID, raidID, true);
		end)
		local function EditBox_OnEnterPressed(frame)
			local value = frame:GetText();
			value = tonumber(value);
			if value then
				PlaySound(856);
				NRC.config.tradeExportEnd = value;
				tradeExportFrame.slider2:SetValue(value);
				frame:ClearFocus();
				NRC:loadTradesExportFrame(logID, raidID, true);
			else
				--If not a valid number reset the box.
				tradeExportFrame.slider2.editBox:SetText(NRC.config.tradeExportEnd);
				frame:ClearFocus();
			end
		end
		tradeExportFrame.slider2.editBox:SetScript("OnEnterPressed", EditBox_OnEnterPressed);
	end
	
	if (raidID) then
		tradeExportFrame.slider1:Hide();
		tradeExportFrame.slider2:Hide();
		local instanceName = "Error (Unknown Log)";
		local instanceData = NRC.db.global.instances[logID];
		local instanceID;
		if (instanceData) then
			instanceName = instanceData.instanceName;
			instanceID = instanceData.instanceID;
		end
		tradeExportFrame.topFrame.fs:SetText("|cFFFFFF00" .. string.format(L["tradesForSingleRaid"], instanceName, logID) .. "|r");
		tradeExportFrame.topFrame.fs:SetText("|cFFFFFF00Trades during specific raid (Log " .. logID .. ")");
		--text = text .. " |cFF9CD6DE(" .. NRC:getTimeString(instanceData.startTime, true) .. " " .. L["ago"] .. ")|r";
		--Remove prefix from certain instance names.
		local instanceName = string.gsub(instanceData.instanceName, ".+: ", "");
		instanceName = NRC:addDiffcultyText(instanceName, instanceData.difficultyName, instanceData.difficultyID);
		tradeExportFrame.topFrame.fs2:ClearAllPoints();
		tradeExportFrame.topFrame.fs2:SetPoint("TOP", -15, -50);
		tradeExportFrame.topFrame.fs2:SetFontObject(QuestFont_Huge);
		tradeExportFrame.topFrame.fs2:SetText("|cFFFFD100" .. instanceName);
		tradeExportFrame.checkbox6:Show();
	else
		if (not tradeExportFrame.slider1:IsShown()) then
			tradeExportFrame.slider1:Show();
		end
		if (not tradeExportFrame.slider2:IsShown()) then
			tradeExportFrame.slider2:Show();
		end
		tradeExportFrame.topFrame.fs:SetText("|cFFFFFF00All Trades Export");
		tradeExportFrame.topFrame.fs2:ClearAllPoints();
		tradeExportFrame.topFrame.fs2:SetPoint("TOP", -24, -35);
		tradeExportFrame.topFrame.fs2:SetFontObject(Game12Font);
		tradeExportFrame.topFrame.fs2:SetText("|cFF00C800Set start and end number range of trades to show.");
		tradeExportFrame.checkbox6:Hide();
	end
	tradeExportFrame.topFrame.button:Hide();
	local text = "Error, export type not found.";
	text = generateTradesExportString(logID, raidID);
	tradeExportFrame.topFrame.button:SetText("Create Custom Export String");
	tradeExportFrame.topFrame.button:SetScript("OnClick", function(self, arg)
		loadCreateCustomStringFrame();
	end)
	tradeExportFrame.EditBox:Insert(text);
	tradeExportFrame.EditBox:HighlightText();
	C_Timer.After(0.1, function()
		tradeExportFrame.EditBox:SetFocus();
	end)
	tradeExportFrame:Show();
end