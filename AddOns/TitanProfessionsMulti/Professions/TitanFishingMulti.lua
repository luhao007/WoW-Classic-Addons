--[[
Description: This plugin is part of the "Titan Panel [Professions] Multi" addon. It shows your Fishing skill level.
Site: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local LibAddonCompat = LibStub("LibAddonCompat-1.0")
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "FISM"
local FISM, prevFISM = 0.0, -2
local FISMmax = 0
local FISMIncrease = 0
local startskill
-----------------------------------------------
local function OnUpdate(self, id)
	local prof1, prof2, _, fishing, cooking, firstAid = LibAddonCompat:GetProfessions();

	if fishing ~= nil then
		local name, _, skillLevel, maxSkillLevel, _, offset, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(fishing)
		FISM = skillLevel
		FISMmax = maxSkillLevel
		FISMIncrease = IncreaseSkillLevel
		if not startskill then startskill = skillLevel end

		if FISM == prevFISM and prevFISMmax == FISMmax and prevFISMIncrease == FISMIncrease then
			return
		end

		prevFISMmax = FISMmax
		prevFISM  = FISM
		prevFISMIncrease = FISMIncrease

		TitanPanelButton_UpdateButton(id)
		return true
	end
end
-----------------------------------------------
local function GetButtonText(self, id)
	local FISMtext
	local bonusText = ""
	if FISMIncrease and FISMIncrease > 0 then -- Bônus da profissão
		bonusText = "|r|cFFFFFFFF".." + |r|cFF69FF69"..FISMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(FISM+FISMIncrease)
	end
	local HideText = "" -- Texto HideMax
	if not TitanGetVar(ID, "HideMax") then
		HideText = "|r/|cFFFF2e2e"..FISMmax
	end
	local SimpleText = bonusText -- Texto de bônus simples
	if TitanGetVar(ID, "SimpleBonus") and FISMIncrease > 0 then
		SimpleText = "|r|cFFFFFFFF".." (+|r|cFF69FF69"..FISMIncrease.."|r|cFFFFFFFF)"
	end

	local BarBalanceText = ""
	if FISMmax ~= 0 and (FISM - startskill) > 0 and TitanGetVar(ID, "ShowBarBalance") then
		BarBalanceText = " |cFF69FF69["..(FISM - startskill).."]"
	end

	if FISM == 375 then
		FISMtext = "|cFF69FF69"..L["maximum"].."!"..SimpleText
	elseif FISMmax == 0 then
		FISMtext = "|cFFFF2e2e"..L["noprof"]
	elseif FISM == FISMmax then
		FISMtext = "|cFFFFFFFF"..FISM.."|cFFFF2e2e! ["..L["maximum"].."]"..SimpleText..BarBalanceText
	else
		FISMtext = "|cFFFFFFFF"..FISM..HideText..SimpleText..BarBalanceText
	end

	return L["fishing"]..": ", FISMtext
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local BonusTooltip = L["craftsmanship"].."|r|cFFFFFFFF"..FISM.." + |r|cFF69FF69"..FISMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(FISM+FISMIncrease) -- Bônus da profissão

	local Goodwith = L["goodwith"]..L["cooking"] -- Texto de combinação

	local maxtext = L["maxtext"]..TitanUtils_GetHighlightText(FISMmax)

	local ColorValueAccount -- Conta de ganho de perícia
	if FISMmax == 0 then
		ColorValueAccount = ""
	elseif FISM == 375 then
		ColorValueAccount = "\r"..L["maxskill"]
	elseif not startskill  or (FISM - startskill) == 0 then
		ColorValueAccount = "\r"..L["session"]..TitanUtils_GetHighlightText("0")
	elseif (FISM - startskill) > 0 then
		ColorValueAccount = "\r"..L["session"].."|cFF69FF69"..(FISM - startskill).."|r"
	end

	local warning -- Aviso de que não está mais aprendendo
	if FISMmax == 375 then
		warning = ""
	elseif FISM == FISMmax then
		warning = L["warning"]
	else
		warning = ""
	end

	local ValueText = "" -- Difere com e sem profissão
	if FISM == 0 then
		ValueText = L["nosecskill"]..Goodwith
	else
		ValueText = L["info"]..BonusTooltip..maxtext..ColorValueAccount..Goodwith..warning
	end

	return ValueText
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|c113bafe3 "..L["fishing"].."|r".." Multi",
	tooltip = L["fishing"],
	icon = "Interface\\Icons\\Trade_fishing.blp",
	category = "Profession",
	version = version,
	onUpdate = OnUpdate,
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
