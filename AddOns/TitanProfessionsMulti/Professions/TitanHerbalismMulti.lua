--[[
Description: This plugin is part of the "Titan Panel [Professions] Multi" addon. It shows your Herbalism skill level.
Site: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local LibAddonCompat = LibStub("LibAddonCompat-1.0")
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "HERM"
local HERM, prevHERM = 0.0, -2
local HERMmax = 0
local HERMIncrease = 0
local startskill
-----------------------------------------------
local function OnUpdate(self, id)
	local prof1, prof2 = LibAddonCompat:GetProfessions();

	local skillLevel = 0
	local maxSkillLevel = 0

	if prof1 ~= nil then
		local name, _, skillLevel, maxSkillLevel, _, offset, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(prof1)
		if name == L["herbalism"] then
			HERM = skillLevel
			HERMmax = maxSkillLevel
			HERMIncrease = IncreaseSkillLevel
			if not startskill then startskill = skillLevel end
		elseif prof2 ~= nil then
			local name, _, skillLevel, maxSkillLevel, _, offset, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(prof2)
			if name == L["herbalism"] then
				HERM = skillLevel
				HERMmax = maxSkillLevel
				HERMIncrease = IncreaseSkillLevel
				if not startskill then startskill = skillLevel end
			end
		end
	end

	if HERM == prevHERM and HERMmax == preHERMmax and prevHERMIncrease == HERMIncrease then
		return
	end

	preHERMmax = HERMmax
	prevHERM = HERM
	prevHERMIncrease = HERMIncrease

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local HERMtext
	local bonusText = ""
	if HERMIncrease and HERMIncrease > 0 then -- Bônus da profissão
		bonusText = "|r|cFFFFFFFF".." + |r|cFF69FF69"..HERMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(HERM+HERMIncrease)
	end
	local HideText = "" -- Texto HideMax
	if not TitanGetVar(ID, "HideMax") then
		HideText = "|r/|cFFFF2e2e"..HERMmax
	end
	local SimpleText = bonusText -- Texto de bônus simples
	if TitanGetVar(ID, "SimpleBonus") and HERMIncrease > 0 then
		SimpleText = "|r|cFFFFFFFF".." (+|r|cFF69FF69"..HERMIncrease.."|r|cFFFFFFFF)"
	end

	local BarBalanceText = ""
	if HERMmax ~= 0 and (HERM - startskill) > 0 and TitanGetVar(ID, "ShowBarBalance") then
		BarBalanceText = " |cFF69FF69["..(HERM - startskill).."]"
	end

	if HERM == 375 then
		HERMtext = "|cFF69FF69"..L["maximum"].."!"..SimpleText
	elseif HERMmax == 0 then
		HERMtext = "|cFFFF2e2e"..L["noprof"]
	elseif HERM == HERMmax then
		HERMtext = "|cFFFFFFFF"..HERM.."|cFFFF2e2e! ["..L["maximum"].."]"..SimpleText..BarBalanceText
	else
		HERMtext = "|cFFFFFFFF"..HERM..HideText..SimpleText..BarBalanceText
	end

	return L["herbalism"]..": ", HERMtext
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local BonusTooltip = L["craftsmanship"].."|r|cFFFFFFFF"..HERM.." + |r|cFF69FF69"..HERMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(HERM+HERMIncrease) -- Bônus da profissão

	local Goodwith = L["goodwith"]..L["alchemy"] -- Texto de combinação

	local maxtext = L["maxtext"]..TitanUtils_GetHighlightText(HERMmax)

	local ColorValueAccount -- Conta de ganho de perícia
	if not HERM then
		ColorValueAccount = ""
	elseif HERM == 375 then
		ColorValueAccount = "\r"..L["maxskill"]
	elseif not startskill  or (HERM - startskill) == 0 then
		ColorValueAccount = "\r"..L["session"]..TitanUtils_GetHighlightText("0")
	elseif (HERM - startskill) > 0 then
		ColorValueAccount = "\r"..L["session"].."|cFF69FF69"..(HERM - startskill).."|r"
	end

	local warning -- Aviso de que não está mais aprendendo
	if HERMmax == 375 then
		warning = ""
	elseif HERM == HERMmax then
		warning = L["warning"]
	else
		warning = ""
	end

	local ValueText = "" -- Difere com e sem profissão
	if HERM == 0 then
		ValueText = L["noskill"]..Goodwith
	else
		ValueText = L["hint"]..L["info"]..BonusTooltip..maxtext..ColorValueAccount..Goodwith..warning
	end

	return ValueText
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|c00a7f200 "..L["herbalism"].."|r".." Multi",
	tooltip = L["herbalism"],
	icon = "Interface\\Icons\\Trade_herbalism.blp",
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
