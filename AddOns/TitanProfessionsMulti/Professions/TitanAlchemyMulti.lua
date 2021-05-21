--[[
Description: This plugin is part of the "Titan Panel [Professions] Multi" addon. It shows your Alchemy skill level.
Site: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local LibAddonCompat = LibStub("LibAddonCompat-1.0")
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "ALCM"
local ALCM, prevALCM = 0.0, -2
local ALCMmax = 0
local ALCMIncrease = 0
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
		if name == L["alchemy"] then
			ALCM = skillLevel
			ALCMmax = maxSkillLevel
			ALCMIncrease = IncreaseSkillLevel
			profOffset = offset
			if not startskill then startskill = skillLevel end
		elseif prof2 ~= nil then
			local name, _, skillLevel, maxSkillLevel, _, offset, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(prof2)
			if name == L["alchemy"] then
				ALCM = skillLevel
				ALCMmax = maxSkillLevel
				ALCMIncrease = IncreaseSkillLevel
				profOffset = offset
				if not startskill then startskill = skillLevel end
			end
		end
	end

	if ALCM == prevALCM and ALCMmax == preALCMmax and prevALCMIncrease == ALCMIncrease then
		return
	end

	preALCMmax = ALCMmax
	prevALCM = ALCM
	prevALCMIncrease = ALCMIncrease

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local ALCMtext
	local bonusText = ""
	if ALCMIncrease and ALCMIncrease > 0 then -- Bônus da profissão
		bonusText = "|r|cFFFFFFFF".." + |r|cFF69FF69"..ALCMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(ALCM+ALCMIncrease)
	end
	local HideText = "" -- Texto HideMax
	if not TitanGetVar(ID, "HideMax") then
		HideText = "|r/|cFFFF2e2e"..ALCMmax
	end
	local SimpleText = bonusText -- Texto de bônus simples
	if TitanGetVar(ID, "SimpleBonus") and ALCMIncrease > 0 then
		SimpleText = "|r|cFFFFFFFF".." (+|r|cFF69FF69"..ALCMIncrease.."|r|cFFFFFFFF)"
	end

	local BarBalanceText = ""
	if ALCMmax ~= 0 and (ALCM - startskill) > 0 and TitanGetVar(ID, "ShowBarBalance") then
		BarBalanceText = " |cFF69FF69["..(ALCM - startskill).."]"
	end

	if ALCM == 375 then
		ALCMtext = "|cFF69FF69"..L["maximum"].."!"..SimpleText
	elseif ALCMmax == 0 then
		ALCMtext = "|cFFFF2e2e"..L["noprof"]
	elseif ALCM == ALCMmax then
		ALCMtext = "|cFFFFFFFF"..ALCM.."|cFFFF2e2e! ["..L["maximum"].."]"..SimpleText..BarBalanceText
	else
		ALCMtext = "|cFFFFFFFF"..ALCM..HideText..SimpleText..BarBalanceText
	end
	return L["alchemy"]..": ", ALCMtext
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local BonusTooltip = L["craftsmanship"].."|r|cFFFFFFFF"..ALCM.." + |r|cFF69FF69"..ALCMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(ALCM+ALCMIncrease) -- Bônus da profissão

	local Goodwith = L["goodwith"]..L["herbalism"] -- Texto de combinação

	local maxtext = L["maxtext"]..TitanUtils_GetHighlightText(ALCMmax)

	local ColorValueAccount -- Conta de ganho de perícia
	if not ALCM then
		ColorValueAccount = ""
	elseif ALCM == 375 then
		ColorValueAccount = "\r"..L["maxskill"]
	elseif not startskill  or (ALCM - startskill) == 0 then
		ColorValueAccount = "\r"..L["session"]..TitanUtils_GetHighlightText("0")
	elseif (ALCM - startskill) > 0 then
		ColorValueAccount = "\r"..L["session"].."|cFF69FF69"..(ALCM - startskill).."|r"
	end

	local warning -- Aviso de que não está mais aprendendo
	if ALCMmax == 375 then
		warning = ""
	elseif ALCM == ALCMmax then
		warning = L["warning"]
	else
		warning = ""
	end

	local ValueText = "" -- Difere com e sem profissão
	if ALCM == 0 then
		ValueText = L["noskill"]..Goodwith
	else
		ValueText = L["hint"]..L["info"]..BonusTooltip..maxtext..ColorValueAccount..Goodwith..warning
	end

	return ValueText
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|c22fdce08 "..L["alchemy"].."|r".." Multi",
	tooltip = L["alchemy"],
	icon = "Interface\\Icons\\Trade_alchemy.blp",
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
