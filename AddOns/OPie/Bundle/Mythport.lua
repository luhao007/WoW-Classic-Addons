local COMPAT, _, T = select(4, GetBuildInfo()), ...
local MODERN = COMPAT > 11e4

local L, EV, PC, AB = T.L, T.Evie, T.OPieCore, T.ActionBook:compatible("ActionBook", 2, 48)
local RW, KR = AB and AB:compatible("Rewire", 1, 47), AB and AB:compatible("Kindred", 1, 32)
local IM = AB and AB:compatible("Imp", 1, 13)
local AL = AB and AB.L
assert(EV and AB and RW and KR and PC and AL and IM and 1, "Incompatible library bundle")

if not MODERN then
	IM:SetTokenReplacement('opie:mythport', false)
	return
end

local SPELL_NAME_EN = "Path of the Seasoned Hero"
local SPELL_NAME   = L"Path of the Seasoned Hero"
local SPELL_ICON   = 255347

local portDriver = "" do
	for k,v in pairs({
		aldani=1237215, floodgate=1216786, dawnbreaker=445414, arakara=445417,
		priory=445444, tazavesh=367416, atonement=354465,
		manaforge=1239155, liberation=1226482,
		-- Legion Remix [no azshara, vault, maw, arcway]
		karazhan=373262, valor=393764, lair=410078, stars=393766,
		ticket=424163, rook=424153,
	}) do
		portDriver = portDriver .. "[myth:" .. k .. ",known:" .. v .. "] " .. v .. "; "
	end
	portDriver = portDriver .. 'nil'
end
KR:SetStateConditionalDriver("mythport", portDriver, false)

local castButton = CreateFrame("Button", nil, nil, "SecureActionButtonTemplate")
castButton:Hide()
castButton:SetAttribute("type", "spell")
castButton:SetAttribute("useOnKeyDown", false)
KR:RegisterStateDriver(castButton, "spell", portDriver) -- TODO: Should've exposed an attribute driver
SecureHandlerWrapScript(castButton, "PreClick", castButton, 'self:SetAttribute("spell", self:GetAttribute("state-spell"))')


local function SetFallbackPathTooltip(tip)
	local nc = NORMAL_FONT_COLOR
	tip:AddLine(SPELL_NAME, 1,1,1)
	tip:AddDoubleLine(SPELL_CAST_TIME_SEC:format(1000/(100+GetHaste())), SPELL_RECAST_TIME_HOURS:format(8), 1,1,1, 1,1,1)
	tip:AddLine(L"Teleport to where you are needed... if you know that Path.", nc.r, nc.g, nc.b, true)
end
local function portHint()
	local sid = castButton:GetAttribute("state-spell")
	if sid then
		return AB:GetNativeSpellFeedback(sid)
	end
	return false, 0, SPELL_ICON, SPELL_NAME, 1, 0, 0, SetFallbackPathTooltip, 0
end

local castSlotID = AB:CreateActionSlot(portHint, nil, "attribute", "type","click", "clickbutton",castButton)
local function getMythport()
	return castSlotID
end
local function describeMythport()
	return AL"Spell", SPELL_NAME, SPELL_ICON, nil, SetFallbackPathTooltip, 0
end
RW:SetCastEscapeAction(SPELL_NAME_EN, castSlotID, false)
RW:SetCastEscapeAction(SPELL_NAME, castSlotID, false)
PC:RegisterExtAction("mythport", getMythport, describeMythport)
IM:AddTokenizableAbility(SPELL_NAME_EN, 'opie:mythport')
IM:AddTokenizableAbility(SPELL_NAME, 'opie:mythport')
IM:SetTokenReplacement('opie:mythport', SPELL_NAME)
AB:AddActionToCategory(AL"Abilities", "opie.ext", "mythport")