------------------------------
---NovaRaidCompanion Talents--
------------------------------
local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

local exportFrame, customStringFrame;

local function loadExportFrame()
	if (not exportFrame) then
		exportFrame = NRC:createExportFrame("NRCExportFrame", 600, 300, 0, 100);
	end
end

local function generateGoogleLootExportString(logID)
	local data = NRC.db.global.instances[logID];
	if (not data) then
		return "Error generating export string, raid data not found.";
	end
	local mapToTrades = NRC.config.mapLootDisplayToTrades;
	local raidDate = date("%Y-%m-%d", data.enteredTime);
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
	local raidDate = date("%Y-%m-%d", data.enteredTime);
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
	local raidDate = date("%Y-%m-%d", data.enteredTime);
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
	exportFrame.EditBox:SetFocus();
	exportFrame:Show();
end