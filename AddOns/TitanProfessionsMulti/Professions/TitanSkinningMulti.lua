--[[
Description: This plugin is part of the "Titan Panel [Professions] Multi" addon. It shows your Skinning skill level.
Site: https://www.curseforge.com/wow/addons/titan-panel-professions-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local LibAddonCompat = LibStub("LibAddonCompat-1.0")
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "SKIM"
local SKIM, prevSKIM = 0.0, -2
local SKIMmax = 0
local SKIMIncrease = 0
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
		if name == L["skinning"] then
			SKIM = skillLevel
			SKIMmax = maxSkillLevel
			SKIMIncrease = IncreaseSkillLevel
			profOffset = offset
			if not startskill then startskill = skillLevel end
		elseif prof2 ~= nil then
			local name, _, skillLevel, maxSkillLevel, _, offset, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(prof2)
			if name == L["skinning"] then
				SKIM = skillLevel
				SKIMmax = maxSkillLevel
				SKIMIncrease = IncreaseSkillLevel
				profOffset = offset
				if not startskill then startskill = skillLevel end
			end
		end
	end

	if SKIM == prevSKIM and SKIMmax == preSKIMmax and prevSKIMIncrease == SKIMIncrease then
		return
	end

	preSKIMmax = SKIMmax
	prevSKIM = SKIM
	prevSKIMIncrease = SKIMIncrease

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local SKIMtext
	local bonusText = ""
	if SKIMIncrease and SKIMIncrease > 0 then -- Bônus da profissão
		bonusText = "|r|cFFFFFFFF".." + |r|cFF69FF69"..SKIMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(SKIM+SKIMIncrease)
	end
	local HideText = "" -- Texto HideMax
	if not TitanGetVar(ID, "HideMax") then
		HideText = "|r/|cFFFF2e2e"..SKIMmax
	end
	local SimpleText = bonusText -- Texto de bônus simples
	if TitanGetVar(ID, "SimpleBonus") and SKIMIncrease > 0 then
		SimpleText = "|r|cFFFFFFFF".." (+|r|cFF69FF69"..SKIMIncrease.."|r|cFFFFFFFF)"
	end

	local BarBalanceText = ""
	if SKIMmax ~= 0 and (SKIM - startskill) > 0 and TitanGetVar(ID, "ShowBarBalance") then
		BarBalanceText = " |cFF69FF69["..(SKIM - startskill).."]"
	end

	if SKIM == 375 then
		SKIMtext = "|cFF69FF69"..L["maximum"].."!"..SimpleText
	elseif SKIMmax == 0 then
		SKIMtext = "|cFFFF2e2e"..L["noprof"]
	elseif SKIM == SKIMmax then
		SKIMtext = "|cFFFFFFFF"..SKIM.."|cFFFF2e2e! ["..L["maximum"].."]"..SimpleText..BarBalanceText
	else
		SKIMtext = "|cFFFFFFFF"..SKIM..HideText..SimpleText..BarBalanceText
	end

	return L["skinning"]..": ", SKIMtext
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local BonusTooltip = L["craftsmanship"].."|r|cFFFFFFFF"..SKIM.." + |r|cFF69FF69"..SKIMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(SKIM+SKIMIncrease) -- Bônus da profissão

	local Goodwith = L["goodwith"]..L["leatherworking"] -- Texto de combinação

	local maxtext = L["maxtext"]..TitanUtils_GetHighlightText(SKIMmax)

	local ColorValueAccount -- Conta de ganho de perícia
	if not SKIM then
		ColorValueAccount = ""
	elseif SKIM == 375 then
		ColorValueAccount = "\r"..L["maxskill"]
	elseif not startskill  or (SKIM - startskill) == 0 then
		ColorValueAccount = "\r"..L["session"]..TitanUtils_GetHighlightText("0")
	elseif (SKIM - startskill) > 0 then
		ColorValueAccount = "\r"..L["session"].."|cFF69FF69"..(SKIM - startskill).."|r"
	end

	local warning -- Aviso de que não está mais aprendendo
	if SKIMmax == 375 then
		warning = ""
	elseif SKIM == SKIMmax then
		warning = L["warning"]
	else
		warning = ""
	end

	local ValueText = "" -- Difere com e sem profissão
	if SKIM == 0 then
		ValueText = L["noskill"]..Goodwith
	else
		ValueText = L["hint"]..L["info"]..BonusTooltip..maxtext..ColorValueAccount..Goodwith..warning
	end

	return ValueText
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|c00a7f200 "..L["skinning"].."|r".." Multi",
	tooltip = L["skinning"],
	icon = "Interface\\Icons\\Inv_misc_pelt_wolf_01.blp",
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
