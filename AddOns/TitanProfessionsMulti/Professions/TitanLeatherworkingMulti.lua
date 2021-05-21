--[[
Description: This plugin is part of the "Titan Panel [Professions] Multi" addon. It shows your Leatherworking skill level.
Site: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local LibAddonCompat = LibStub("LibAddonCompat-1.0")
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "LEAM"
local LEAM, prevLEAM = 0.0, -2
local LEAMmax = 0
local LEAMIncrease = 0
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
		if name == L["leatherworking"] then
			LEAM = skillLevel
			LEAMmax = maxSkillLevel
			LEAMIncrease = IncreaseSkillLevel
			profOffset = offset
			if not startskill then startskill = skillLevel end
		elseif prof2 ~= nil then
			local name, _, skillLevel, maxSkillLevel, _, offset, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(prof2)
			if name == L["leatherworking"] then
				LEAM = skillLevel
				LEAMmax = maxSkillLevel
				LEAMIncrease = IncreaseSkillLevel
				profOffset = offset
				if not startskill then startskill = skillLevel end
			end
		end
	end

	if LEAM == prevLEAM and LEAMmax == preLEAMmax and prevLEAMIncrease == LEAMIncrease then
		return
	end

	preLEAMmax = LEAMmax
	prevLEAM = LEAM
	prevLEAMIncrease = LEAMIncrease

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local LEAMtext
	local bonusText = ""
	if LEAMIncrease and LEAMIncrease > 0 then -- Bônus da profissão
		bonusText = "|r|cFFFFFFFF".." + |r|cFF69FF69"..LEAMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(LEAM+LEAMIncrease)
	end
	local HideText = "" -- Texto HideMax
	if not TitanGetVar(ID, "HideMax") then
		HideText = "|r/|cFFFF2e2e"..LEAMmax
	end
	local SimpleText = bonusText -- Texto de bônus simples
	if TitanGetVar(ID, "SimpleBonus") and LEAMIncrease > 0 then
		SimpleText = "|r|cFFFFFFFF".." (+|r|cFF69FF69"..LEAMIncrease.."|r|cFFFFFFFF)"
	end

	local BarBalanceText = ""
	if LEAMmax ~= 0 and (LEAM - startskill) > 0 and TitanGetVar(ID, "ShowBarBalance") then
		BarBalanceText = " |cFF69FF69["..(LEAM - startskill).."]"
	end

	if LEAM == 375 then
		LEAMtext = "|cFF69FF69"..L["maximum"].."!"..SimpleText
	elseif LEAMmax == 0 then
		LEAMtext = "|cFFFF2e2e"..L["noprof"]
	elseif LEAM == LEAMmax then
		LEAMtext = "|cFFFFFFFF"..LEAM.."|cFFFF2e2e! ["..L["maximum"].."]"..SimpleText..BarBalanceText
	else
		LEAMtext = "|cFFFFFFFF"..LEAM..HideText..SimpleText..BarBalanceText
	end

	return L["leatherworking"]..": ", LEAMtext
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local BonusTooltip = L["craftsmanship"].."|r|cFFFFFFFF"..LEAM.." + |r|cFF69FF69"..LEAMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(LEAM+LEAMIncrease) -- Bônus da profissão

	local Goodwith = L["goodwith"]..L["skinning"] -- Texto de combinação

	local maxtext = L["maxtext"]..TitanUtils_GetHighlightText(LEAMmax)

	local ColorValueAccount -- Conta de ganho de perícia
	if not LEAM then
		ColorValueAccount = ""
	elseif LEAM == 375 then
		ColorValueAccount = "\r"..L["maxskill"]
	elseif not startskill  or (LEAM - startskill) == 0 then
		ColorValueAccount = "\r"..L["session"]..TitanUtils_GetHighlightText("0")
	elseif (LEAM - startskill) > 0 then
		ColorValueAccount = "\r"..L["session"].."|cFF69FF69"..(LEAM - startskill).."|r"
	end

	local warning -- Aviso de que não está mais aprendendo
	if LEAMmax == 375 then
		warning = ""
	elseif LEAM == LEAMmax then
		warning = L["warning"]
	else
		warning = ""
	end

	local ValueText = "" -- Difere com e sem profissão
	if LEAM == 0 then
		ValueText = L["noskill"]..Goodwith
	else
		ValueText = L["hint"]..L["info"]..BonusTooltip..maxtext..ColorValueAccount..Goodwith..warning
	end

	return ValueText
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|c22fdce08 "..L["leatherworking"].."|r".." Multi",
	tooltip = L["leatherworking"],
	icon = "Interface\\Icons\\Trade_leatherworking.blp",
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
