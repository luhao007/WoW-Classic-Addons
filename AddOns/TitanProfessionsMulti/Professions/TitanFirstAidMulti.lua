--[[
Description: This plugin is part of the "Titan Panel [Professions] Multi" addon. It shows your First Aid skill level.
Site: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local LibAddonCompat = LibStub("LibAddonCompat-1.0")
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "FIRM"
local FIRM, prevFIRM = 0.0, -2
local FIRMmax = 0
local FIRMIncrease = 0
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

	if firstAid ~= nil then
		local name, _, skillLevel, maxSkillLevel, _, offset, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(firstAid)
		FIRM = skillLevel
		FIRMmax = maxSkillLevel
		FIRMIncrease = IncreaseSkillLevel
		profOffset = offset
		if not startskill then startskill = skillLevel end

		if FIRM == prevFIRM and prevFIRMmax == FIRMmax and prevFIRMIncrease == FIRMIncrease then
			return
		end

		prevFIRMmax = FIRMmax
		prevFIRM  = FIRM
		prevFIRMIncrease = FIRMIncrease

		TitanPanelButton_UpdateButton(id)
		return true
	end
end
-----------------------------------------------
local function GetButtonText(self, id)
	local FIRMtext
	local bonusText = ""
	if FIRMIncrease and FIRMIncrease > 0 then -- Bônus da profissão
		bonusText = "|r|cFFFFFFFF".." + |r|cFF69FF69"..FIRMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(FIRM+FIRMIncrease)
	end
	local HideText = "" -- Texto HideMax
	if not TitanGetVar(ID, "HideMax") then
		HideText = "|r/|cFFFF2e2e"..FIRMmax
	end
	local SimpleText = bonusText -- Texto de bônus simples
	if TitanGetVar(ID, "SimpleBonus") and FIRMIncrease > 0 then
		SimpleText = "|r|cFFFFFFFF".." (+|r|cFF69FF69"..FIRMIncrease.."|r|cFFFFFFFF)"
	end

	local BarBalanceText = ""
	if FIRMmax ~= 0 and (FIRM - startskill) > 0 and TitanGetVar(ID, "ShowBarBalance") then
		BarBalanceText = " |cFF69FF69["..(FIRM - startskill).."]"
	end

	if FIRM == 375 then
		FIRMtext = "|cFF69FF69"..L["maximum"].."!"..SimpleText
	elseif FIRMmax == 0 then
		FIRMtext = "|cFFFF2e2e"..L["noprof"]
	elseif FIRM == FIRMmax then
		FIRMtext = "|cFFFFFFFF"..FIRM.."|cFFFF2e2e! ["..L["maximum"].."]"..SimpleText..BarBalanceText
	else
		FIRMtext = "|cFFFFFFFF"..FIRM..HideText..SimpleText..BarBalanceText
	end

	return L["firstAid"]..": ", FIRMtext
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local BonusTooltip = L["craftsmanship"].."|r|cFFFFFFFF"..FIRM.." + |r|cFF69FF69"..FIRMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(FIRM+FIRMIncrease) -- Bônus da profissão

	local Goodwith = L["goodwith"]..L["tailoring"] -- Texto de combinação

	local maxtext = L["maxtext"]..TitanUtils_GetHighlightText(FIRMmax)

	local ColorValueAccount -- Conta de ganho de perícia
	if FIRMmax == 0 then
		ColorValueAccount = ""
	elseif FIRM == 375 then
		ColorValueAccount = "\r"..L["maxskill"]
	elseif not startskill  or (FIRM - startskill) == 0 then
		ColorValueAccount = "\r"..L["session"]..TitanUtils_GetHighlightText("0")
	elseif (FIRM - startskill) > 0 then
		ColorValueAccount = "\r"..L["session"].."|cFF69FF69"..(FIRM - startskill).."|r"
	end

	local warning -- Aviso de que não está mais aprendendo
	if FIRMmax == 375 then
		warning = ""
	elseif FIRM == FIRMmax then
		warning = L["warning"]
	else
		warning = ""
	end

	local ValueText = "" -- Difere com e sem profissão
	if FIRM == 0 then
		ValueText = L["nosecskill"]..Goodwith
	else
		ValueText = L["hint"]..L["info"]..BonusTooltip..maxtext..ColorValueAccount..Goodwith..warning
	end

	return ValueText
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|c113bafe3 "..L["firstAid"].."|r".." Multi",
	tooltip = L["firstAid"],
	icon = "Interface\\Icons\\Spell_holy_sealofsacrifice.blp",
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
