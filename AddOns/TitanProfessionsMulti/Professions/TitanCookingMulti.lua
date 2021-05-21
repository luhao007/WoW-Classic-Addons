--[[
Description: This plugin is part of the "Titan Panel [Professions] Multi" addon. It shows your Cooking skill level.
Site: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local LibAddonCompat = LibStub("LibAddonCompat-1.0")
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "COOM"
local COOM, prevCOOM = 0.0, -2
local COOMmax = 0
local COOMIncrease = 0
local startskill
local profOffset
-----------------------------------------------
local function OnClick(self, button)
	if (button == "LeftButton" and profOffset) then
		CastSpell(profOffset + 1, "Spell")
	end
end
-----------------------------------------------
local function OnUpdate(self, id)
	local prof1, prof2, _, fishing, cooking, firstAid = LibAddonCompat:GetProfessions();

	local skillLevel = 0
	local maxSkillLevel = 0
	profOffset = nil

	if cooking ~= nil then
		local name, _, skillLevel, maxSkillLevel, _, offset, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(cooking)
		COOM = skillLevel
		COOMmax = maxSkillLevel
		COOMIncrease = IncreaseSkillLevel
		profOffset = offset
		if not startskill then startskill = skillLevel end

		if COOM == prevCOOM and prevCOOMmax == COOMmax and prevCOOMIncrease == COOMIncrease then
			return
		end

		prevCOOMmax = COOMmax
		prevCOOM  = COOM
		prevCOOMIncrease = COOMIncrease

		TitanPanelButton_UpdateButton(id)
		return true
	end
end
-----------------------------------------------
local function GetButtonText(self, id)
	local COOMtext
	local bonusText = ""
	if COOMIncrease and COOMIncrease > 0 then -- Bônus da profissão
		bonusText = "|r|cFFFFFFFF".." + |r|cFF69FF69"..COOMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(COOM+COOMIncrease)
	end
	local HideText = "" -- Texto HideMax
	if not TitanGetVar(ID, "HideMax") then
		HideText = "|r/|cFFFF2e2e"..COOMmax
	end
	local SimpleText = bonusText -- Texto de bônus simples
	if TitanGetVar(ID, "SimpleBonus") and COOMIncrease > 0 then
		SimpleText = "|r|cFFFFFFFF".." (+|r|cFF69FF69"..COOMIncrease.."|r|cFFFFFFFF)"
	end

	local BarBalanceText = ""
	if COOMmax ~= 0 and (COOM - startskill) > 0 and TitanGetVar(ID, "ShowBarBalance") then
		BarBalanceText = " |cFF69FF69["..(COOM - startskill).."]"
	end

	if COOM == 375 then
		COOMtext = "|cFF69FF69"..L["maximum"].."!"..SimpleText
	elseif COOMmax == 0 then
		COOMtext = "|cFFFF2e2e"..L["noprof"]
	elseif COOM == COOMmax then
		COOMtext = "|cFFFFFFFF"..COOM.."|cFFFF2e2e! ["..L["maximum"].."]"..SimpleText..BarBalanceText
	else
		COOMtext = "|cFFFFFFFF"..COOM..HideText..SimpleText..BarBalanceText
	end

	return L["cooking"]..": ", COOMtext
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local BonusTooltip = L["craftsmanship"].."|r|cFFFFFFFF"..COOM.." + |r|cFF69FF69"..COOMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(COOM+COOMIncrease) -- Bônus da profissão

	local Goodwith = L["goodwith"]..L["fishing"] -- Texto de combinação

	local maxtext = L["maxtext"]..TitanUtils_GetHighlightText(COOMmax)

	local ColorValueAccount -- Conta de ganho de perícia
	if COOMmax == 0 then
		ColorValueAccount = ""
	elseif COOM == 375 then
		ColorValueAccount = "\r"..L["maxskill"]
	elseif not startskill  or (COOM - startskill) == 0 then
		ColorValueAccount = "\r"..L["session"]..TitanUtils_GetHighlightText("0")
	elseif (COOM - startskill) > 0 then
		ColorValueAccount = "\r"..L["session"].."|cFF69FF69"..(COOM - startskill).."|r"
	end

	local warning -- Aviso de que não está mais aprendendo
	if COOMmax == 375 then
		warning = ""
	elseif COOM == COOMmax then
		warning = L["warning"]
	else
		warning = ""
	end

	local ValueText = "" -- Difere com e sem profissão
	if COOM == 0 then
		ValueText = L["nosecskill"]..Goodwith
	else
		ValueText = L["hint"]..L["info"]..BonusTooltip..maxtext..ColorValueAccount..Goodwith..warning
	end

	return ValueText
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|c113bafe3 "..L["cooking"].."|r".." Multi",
	tooltip = L["cooking"],
	icon = "Interface\\Icons\\Inv_misc_food_15.blp",
	category = "Profession",
	version = version,
	onUpdate = OnUpdate,
	onClick = OnClick,
	getButtonText = GetButtonText,
	getTooltipText = GetTooltipText,
	prepareMenu = L.PrepareProfessionsMenu,
	savedVariables = {
		ShowIcon = 1,
		DisplayOnRightSide = false,
		HideMax = false,
		SimpleBonus = true,
		ShowBarBalance = false,
		ShowLabelText = false,
	}
})
