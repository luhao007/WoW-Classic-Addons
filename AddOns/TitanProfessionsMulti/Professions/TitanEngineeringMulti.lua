--[[
Description: This plugin is part of the "Titan Panel [Professions] Multi" addon. It shows your Engineering skill level.
Site: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local LibAddonCompat = LibStub("LibAddonCompat-1.0")
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "ENGM"
local ENGM, prevENGM = 0.0, -2
local ENGMmax = 0
local ENGMIncrease = 0
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
	local prof1, prof2 = LibAddonCompat:GetProfessions();

	local skillLevel = 0
	local maxSkillLevel = 0
	profOffset = nil

	if prof1 ~= nil then
		local name, _, skillLevel, maxSkillLevel, _, offset, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(prof1)
		if name == L["engineering"] then
			ENGM = skillLevel
			ENGMmax = maxSkillLevel
			ENGMIncrease = IncreaseSkillLevel
			profOffset = offset
			if not startskill then startskill = skillLevel end
		elseif prof2 ~= nil then
			local name, _, skillLevel, maxSkillLevel, _, offset, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(prof2)
			if name == L["engineering"] then
				ENGM = skillLevel
				ENGMmax = maxSkillLevel
				ENGMIncrease = IncreaseSkillLevel
				profOffset = offset
				if not startskill then startskill = skillLevel end
			end
		end
	end

	if ENGM == prevENGM and ENGMmax == preENGMmax and prevENGMIncrease == ENGMIncrease then
		return
	end

	preENGMmax = ENGMmax
	prevENGM = ENGM
	prevENGMIncrease = ENGMIncrease

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local ENGMtext
	local bonusText = ""
	if ENGMIncrease and ENGMIncrease > 0 then -- Bônus da profissão
		bonusText = "|r|cFFFFFFFF".." + |r|cFF69FF69"..ENGMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(ENGM+ENGMIncrease)
	end
	local HideText = "" -- Texto HideMax
	if not TitanGetVar(ID, "HideMax") then
		HideText = "|r/|cFFFF2e2e"..ENGMmax
	end
	local SimpleText = bonusText -- Texto de bônus simples
	if TitanGetVar(ID, "SimpleBonus") and ENGMIncrease > 0 then
		SimpleText = "|r|cFFFFFFFF".." (+|r|cFF69FF69"..ENGMIncrease.."|r|cFFFFFFFF)"
	end

	local BarBalanceText = ""
	if ENGMmax ~= 0 and (ENGM - startskill) > 0 and TitanGetVar(ID, "ShowBarBalance") then
		BarBalanceText = " |cFF69FF69["..(ENGM - startskill).."]"
	end

	if ENGM == 375 then
		ENGMtext = "|cFF69FF69"..L["maximum"].."!"..SimpleText
	elseif ENGMmax == 0 then
		ENGMtext = "|cFFFF2e2e"..L["noprof"]
	elseif ENGM == ENGMmax then
		ENGMtext = "|cFFFFFFFF"..ENGM.."|cFFFF2e2e! ["..L["maximum"].."]"..SimpleText..BarBalanceText
	else
		ENGMtext = "|cFFFFFFFF"..ENGM..HideText..SimpleText..BarBalanceText
	end

	return L["engineering"]..": ", ENGMtext
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local BonusTooltip = L["craftsmanship"].."|r|cFFFFFFFF"..ENGM.." + |r|cFF69FF69"..ENGMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(ENGM+ENGMIncrease) -- Bônus da profissão

	local Goodwith = L["goodwith"]..L["mining"] -- Texto de combinação

	local maxtext = L["maxtext"]..TitanUtils_GetHighlightText(ENGMmax)

	local ColorValueAccount -- Conta de ganho de perícia
	if not ENGM then
		ColorValueAccount = ""
	elseif ENGM == 375 then
		ColorValueAccount = "\r"..L["maxskill"]
	elseif not startskill  or (ENGM - startskill) == 0 then
		ColorValueAccount = "\r"..L["session"]..TitanUtils_GetHighlightText("0")
	elseif (ENGM - startskill) > 0 then
		ColorValueAccount = "\r"..L["session"].."|cFF69FF69"..(ENGM - startskill).."|r"
	end

	local warning -- Aviso de que não está mais aprendendo
	if ENGMmax == 375 then
		warning = ""
	elseif ENGM == ENGMmax then
		warning = L["warning"]
	else
		warning = ""
	end

	local ValueText = "" -- Difere com e sem profissão
	if ENGM == 0 then
		ValueText = L["noskill"]..Goodwith
	else
		ValueText = L["hint"]..L["info"]..BonusTooltip..maxtext..ColorValueAccount..Goodwith..warning
	end

	return ValueText
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|c22fdce08 "..L["engineering"].."|r".." Multi",
	tooltip = L["engineering"],
	icon = "Interface\\Icons\\Trade_engineering.blp",
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
