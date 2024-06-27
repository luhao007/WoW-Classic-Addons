local _;

VUHDO_DEBUFF_BLACKLIST_SORTABLE = { };
VUHDO_DEBUFF_IGNORE_COMBO_MODEL = { };
VUHDO_SELECTED_DEBUFF_IGNORE = "";
VUHDO_DEBUFF_IGNORE_SHARE_VERSION = 1;



--
local tSpellNameById;
function VUHDO_initDebuffIgnoreComboModel()

	table.wipe(VUHDO_DEBUFF_BLACKLIST_SORTABLE);

	for tName, _ in pairs(VUHDO_DEBUFF_BLACKLIST) do
		tinsert(VUHDO_DEBUFF_BLACKLIST_SORTABLE, tName);
	end
	
	table.sort(VUHDO_DEBUFF_BLACKLIST_SORTABLE,
	    function(aDebuff, anotherDebuff)
		    return VUHDO_resolveSpellId(aDebuff) < VUHDO_resolveSpellId(anotherDebuff);
	    end
	);

	table.wipe(VUHDO_DEBUFF_IGNORE_COMBO_MODEL);

	for _, tName in pairs(VUHDO_DEBUFF_BLACKLIST_SORTABLE) do 
		tSpellNameById = VUHDO_resolveSpellId(tName);

		if (tSpellNameById ~= tName) then
			tinsert(VUHDO_DEBUFF_IGNORE_COMBO_MODEL, { tName, "[" .. tName .. "] " .. tSpellNameById });
		else
			tinsert(VUHDO_DEBUFF_IGNORE_COMBO_MODEL, { tName, tName });
		end
	end

end



--
local tText;
function VUHDO_saveDebuffIgnoreClicked(aButton)

	local tText = _G[aButton:GetParent():GetName() .. "IgnoreComboBoxEditBox"]:GetText();

	if (tText ~= nil) then
		VUHDO_DEBUFF_BLACKLIST[strtrim(tText)] = true;
		VUHDO_initDebuffIgnoreComboModel();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Hide();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Show();
	end

end



--
function VUHDO_deleteDebuffIgnoreClicked(aButton)
	local tText = _G[aButton:GetParent():GetName() .. "IgnoreComboBoxEditBox"]:GetText();

	if (tText ~= nil) then
		if (VUHDO_DEBUFF_BLACKLIST[strtrim(tText)]) then
			VUHDO_DEBUFF_BLACKLIST[strtrim(tText)] = nil;
		else
			local tSpellId = string.match(tText, '([^%]%[]+)');

			if (tSpellId ~= nil and VUHDO_DEBUFF_BLACKLIST[tSpellId]) then
				VUHDO_DEBUFF_BLACKLIST[tSpellId] = nil;
			end
		end


		VUHDO_initDebuffIgnoreComboModel();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Hide();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Show();
	end
end



--
function VUHDO_addDebuffToBlacklist(aCuDeIconFrame)

	if not aCuDeIconFrame then
		return;
	end

	local debuffName = aCuDeIconFrame["debuffInfo"];
				
	if debuffName then
		local debuffSpellId = strtrim(aCuDeIconFrame["debuffSpellId"]);

		if not VUHDO_DEBUFF_BLACKLIST[debuffSpellId] then
			VUHDO_DEBUFF_BLACKLIST[debuffSpellId] = true;
	
			VUHDO_updateAllDebuffIcons(false);
			VUHDO_initDebuffIgnoreComboModel();
	
			VUHDO_Msg(format(VUHDO_I18N_DEBUFF_BLACKLIST_ADDED, debuffSpellId, debuffName), 1, 0.4, 0.4);
		end
	end

end



--
function VUHDO_exportDebuffIgnoreClicked(aButton)

	_G[aButton:GetParent():GetParent():GetName() .. "ExportFrame"]:Show();

end



--
function VUHDO_importDebuffIgnoreClicked(aButton)

	_G[aButton:GetParent():GetParent():GetName() .. "ImportFrame"]:Show();

end



--
local tDebuffIgnoreCompressed;
local tDebuffIgnoreTable;
local tDebuffIgnoreString;
local function VUHDO_debuffIgnoreTableToString(aDebuffIgnore)

	if (aDebuffIgnore ~= nil) then
		tDebuffIgnoreCompressed = VUHDO_compressAndPackTable(aDebuffIgnore);

		tDebuffIgnoreTable = {
			["debuffIgnoreVersion"] = VUHDO_DEBUFF_IGNORE_SHARE_VERSION,
			["playerName"] = GetUnitName("player", true),
			["debuffIgnore"] = tDebuffIgnoreCompressed,
		};

		tDebuffIgnoreString = VUHDO_serializeTable(tDebuffIgnoreTable);
		tDebuffIgnoreString = VUHDO_LibBase64.Encode(tDebuffIgnoreString);

		return tDebuffIgnoreString;
	end

end



--
local tDecodedDebuffIgnoreString;
local tDebuffIgnoreTable;
local tDecompressedDebuffIgnoreTable;
local function VUHDO_debuffIgnoreStringToTable(aDebuffIgnoreString)

	tDecodedDebuffIgnoreString = VUHDO_LibBase64.Decode(aDebuffIgnoreString);
	tDebuffIgnoreTable = VUHDO_deserializeTable(tDecodedDebuffIgnoreString);

	if tDebuffIgnoreTable and tDebuffIgnoreTable["debuffIgnore"] then
		tDecompressedDebuffIgnoreTable = VUHDO_decompressIfCompressed(tDebuffIgnoreTable["debuffIgnore"]);

		tDebuffIgnoreTable["debuffIgnore"] = tDecompressedDebuffIgnoreTable;
	end

	return tDebuffIgnoreTable;

end



--
local tEditText;
function VUHDO_debuffIgnoreExportButtonShown(aEditBox)

	tEditText = VUHDO_debuffIgnoreTableToString(VUHDO_DEBUFF_BLACKLIST);

	aEditBox:SetText(tEditText);
	aEditBox:SetTextInsets(0, 10, 5, 5);

	aEditBox:Show();

end



--
local tImportString;
local tImportTable;
local tName;
local tProfile;
local tPos;
function VUHDO_debuffIgnoreImport(aEditBoxName)

	tImportString = _G[aEditBoxName]:GetText();
	tImportTable = VUHDO_debuffIgnoreStringToTable(tImportString);

	if (tImportTable == nil or tImportTable["debuffIgnoreVersion"] == nil or tonumber(tImportTable["debuffIgnoreVersion"]) == nil or 
		tonumber(tImportTable["debuffIgnoreVersion"]) ~= VUHDO_DEBUFF_IGNORE_SHARE_VERSION or tImportTable["playerName"] == nil or 
		tImportTable["debuffIgnore"] == nil or type(tImportTable["debuffIgnore"]) ~= "table") then
		VUHDO_Msg(VUHDO_I18N_IMPORT_STRING_INVALID);

		return;
	end

	for tDebuffIgnoreSpell, _ in pairs(tImportTable["debuffIgnore"]) do
		VUHDO_DEBUFF_BLACKLIST[tDebuffIgnoreSpell] = true;
	end

	VUHDO_Msg(VUHDO_I18N_DEBUFF_IGNORE_IMPORTED);

end



--
function VUHDO_yesNoImportDebuffIgnoreCallback(aDecision)

	if (VUHDO_YES == aDecision) then
		local tEditBoxName = VuhDoYesNoFrame:GetAttribute("importStringEditBoxName");

		VUHDO_debuffIgnoreImport(tEditBoxName);

		_G[tEditBoxName]:GetParent():GetParent():GetParent():Hide();

		VUHDO_initDebuffIgnoreComboModel();
		_G["VuhDoNewOptionsDebuffsStandardIconsPanelIgnoreComboBox"]:Hide();
		_G["VuhDoNewOptionsDebuffsStandardIconsPanelIgnoreComboBox"]:Show();
	end

end



--
function VUHDO_importDebuffIgnoreOkayClicked(aButton)

	VuhDoYesNoFrameText:SetText(VUHDO_I18N_REALLY_IMPORT);

	VuhDoYesNoFrame:SetAttribute("callback", VUHDO_yesNoImportDebuffIgnoreCallback);
	VuhDoYesNoFrame:SetAttribute("importStringEditBoxName", aButton:GetParent():GetName() .. "StringScrollFrameStringEditBox");

	VuhDoYesNoFrame:Show();

end
