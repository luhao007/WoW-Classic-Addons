--[[
Description: This plugin is part of the "Titan Panel [Professions] Multi" addon. It shows your Enchanting skill level.
Site: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local LibAddonCompat = LibStub("LibAddonCompat-1.0")
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "ENCM"
local ENCM, prevENCM = 0.0, -2
local ENCMmax = 0
local ENCMIncrease = 0
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
		if name == L["enchanting"] then
			ENCM = skillLevel
			ENCMmax = maxSkillLevel
			ENCMIncrease = IncreaseSkillLevel
			profOffset = offset
			if not startskill then startskill = skillLevel end
			if name ~= L["enchanting"] then prof1 = nil end
		elseif prof2 ~= nil then
			local name, _, skillLevel, maxSkillLevel, _, offset, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(prof2)
			if name == L["enchanting"] then
				ENCM = skillLevel
				ENCMmax = maxSkillLevel
				ENCMIncrease = IncreaseSkillLevel
				profOffset = offset
				if not startskill then startskill = skillLevel end
				if name ~= L["enchanting"] then prof2 = nil end
			end
		end
	end

	if ENCM == prevENCM and ENCMmax == preENCMmax and prevENCMIncrease == ENCMIncrease then
		return
	end

	preENCMmax = ENCMmax
	prevENCM = ENCM
	prevENCMIncrease = ENCMIncrease

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local ENCMtext
	local bonusText = ""
	if ENCMIncrease and ENCMIncrease > 0 then -- Bônus da profissão
		bonusText = "|r|cFFFFFFFF".." + |r|cFF69FF69"..ENCMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(ENCM+ENCMIncrease)
	end
	local HideText = "" -- Texto HideMax
	if not TitanGetVar(ID, "HideMax") then
		HideText = "|r/|cFFFF2e2e"..ENCMmax
	end
	local SimpleText = bonusText -- Texto de bônus simples
	if TitanGetVar(ID, "SimpleBonus") and ENCMIncrease > 0 then
		SimpleText = "|r|cFFFFFFFF".." (+|r|cFF69FF69"..ENCMIncrease.."|r|cFFFFFFFF)"
	end

	local BarBalanceText = ""
	if ENCMmax ~= 0 and (ENCM - startskill) > 0 and TitanGetVar(ID, "ShowBarBalance") then
		BarBalanceText = " |cFF69FF69["..(ENCM - startskill).."]"
	end

	if ENCM == 375 then
		ENCMtext = "|cFF69FF69"..L["maximum"].."!"..SimpleText
	elseif ENCMmax == 0 then
		ENCMtext = "|cFFFF2e2e"..L["noprof"]
	elseif ENCM == ENCMmax then
		ENCMtext = "|cFFFFFFFF"..ENCM.."|cFFFF2e2e! ["..L["maximum"].."]"..SimpleText..BarBalanceText
	else
		ENCMtext = "|cFFFFFFFF"..ENCM..HideText..SimpleText..BarBalanceText
	end

	return L["enchanting"]..": ", ENCMtext
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local BonusTooltip = L["craftsmanship"].."|r|cFFFFFFFF"..ENCM.." + |r|cFF69FF69"..ENCMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(ENCM+ENCMIncrease) -- Bônus da profissão

	local Goodwith = L["goodwith"]..L["tailoring"] -- Texto de combinação

	local maxtext = L["maxtext"]..TitanUtils_GetHighlightText(ENCMmax)

	local ColorValueAccount -- Conta de ganho de perícia
	if not ENCM then
		ColorValueAccount = ""
	elseif ENCM == 375 then
		ColorValueAccount = "\r"..L["maxskill"]
	elseif not startskill  or (ENCM - startskill) == 0 then
		ColorValueAccount = "\r"..L["session"]..TitanUtils_GetHighlightText("0")
	elseif (ENCM - startskill) > 0 then
		ColorValueAccount = "\r"..L["session"].."|cFF69FF69"..(ENCM - startskill).."|r"
	end

	local warning -- Aviso de que não está mais aprendendo
	if ENCMmax == 375 then
		warning = ""
	elseif ENCM == ENCMmax then
		warning = L["warning"]
	else
		warning = ""
	end

	local ValueText = "" -- Difere com e sem profissão
	if ENCM == 0 then
		ValueText = L["noskill"]..Goodwith
	else
		ValueText = L["hint"]..L["info"]..BonusTooltip..maxtext..ColorValueAccount..Goodwith..warning
	end

	return ValueText
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|c22fdce08 "..L["enchanting"].."|r".." Multi",
	tooltip = L["enchanting"],
	icon = "Interface\\Icons\\Trade_engraving.blp",
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
