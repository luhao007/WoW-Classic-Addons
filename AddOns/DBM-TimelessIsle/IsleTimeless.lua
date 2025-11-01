local mod	= DBM:NewMod("IsleTimeless", "DBM-TimelessIsle")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20240528023610")
mod:SetZone(DBM_DISABLE_ZONE_DETECTION)

mod:RegisterEvents(
	"ZONE_CHANGED_NEW_AREA"
)

--TODO, add a cauterize timer.
--TODO, add move warning for dread ship fire.

--All
local warnFlameBreath			= mod:NewSpellAnnounce(147817, 3)
local warnFireBlossom			= mod:NewTargetNoFilterAnnounce(147818, 3)
local warnLightningBreath		= mod:NewSpellAnnounce(147826, 3)
local warnStormBlossom			= mod:NewTargetNoFilterAnnounce(147828, 3)
local warnConjurGolem			= mod:NewSpellAnnounce(148001, 3)
local warnCauterize				= mod:NewCastAnnounce(147997, 4)

--Serpants
local specWarnFireBlossom		= mod:NewSpecialWarningYou(147818, nil, nil, nil, 1, 2)
local specWarnStormBlossom		= mod:NewSpecialWarningYou(147828, nil, nil, nil, 1, 2)
--Spawns
local specWarnShip				= mod:NewSpecialWarning("specWarnShip", false)--No voice pack, since there isn't really a sound for "rare spawn up"
local specWarnGolg				= mod:NewSpecialWarning("specWarnGolg")--No voice pack, since there isn't really a sound for "rare spawn up"
--Frogs
local specWarnFrogToxin			= mod:NewSpecialWarningStack(147655, nil, 7, nil, nil, 1, 6)
--Weaker Ordon
local specWarnCracklingBlow		= mod:NewSpecialWarningDodge(147674, nil, nil, nil, 1, 2)
local specWarnFallingFlames		= mod:NewSpecialWarningSpell(147723, "-Tank", nil, nil, 2, 2)
local specWarnBlazingCleave		= mod:NewSpecialWarningRun(147702, "-Tank", nil, nil, 4, 2)--Tanks stand in it on purpose so no need to warn them
--Tougher Ordon
local specWarnBlazingBlow		= mod:NewSpecialWarningDodge(148003, nil, nil, nil, 1, 2)
local specWarnConjurKiln		= mod:NewSpecialWarningSwitch(148004, false, nil, 2, 1, 2)
local specWarnFireStorm			= mod:NewSpecialWarningDodge(147998, nil, nil, nil, 2, 2)
local specWarnCauterize			= mod:NewSpecialWarningInterrupt(147997, nil, nil, nil, 1, 2)
--Rock Moss/Spelurk
local specWarnRenewingMists		= mod:NewSpecialWarningInterrupt(147769, nil, nil, nil, 1, 2)

local currentZoneID = -1
local eventsRegistered = false

local function zoneCode()
	currentZoneID = C_Map.GetBestMapForUnit("player") or 0
	if currentZoneID == 554 and not eventsRegistered then
		--Self can be used but LuaLS doesn't understand it's inherting "mod" and causes it to throw errors
		eventsRegistered = true
		mod:RegisterShortTermEvents(
			"SPELL_CAST_START 148003 148004 147997 148001 147998 147828 147826 147674 147723 147769 147702 147818 147817",
			"SPELL_AURA_APPLIED_DOSE 147655",
			"CHAT_MSG_MONSTER_YELL"
		)
	elseif currentZoneID ~= 554 and eventsRegistered then
		--Self can be used but LuaLS doesn't understand it's inherting "mod" and causes it to throw errors
		eventsRegistered = false
		mod:UnregisterShortTermEvents()
	end
end
zoneCode()--Make sure it runs on mod load

function mod:FireBlossomTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnFireBlossom:Show()
		specWarnFireBlossom:Play("targetyou")
	else
		warnFireBlossom:Show(targetname)
	end
end

function mod:StormBlossomTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnStormBlossom:Show()
		specWarnStormBlossom:Play("targetyou")
	else
		warnStormBlossom:Show(targetname)
	end
end

function mod:ZONE_CHANGED_NEW_AREA()
	zoneCode()
end

function mod:SPELL_CAST_START(args)
	local sourceGUID = args.sourceGUID
	if not self:IsValidWarning(sourceGUID, nil, nil, nil, true) then return end
	local spellId = args.spellId
	if spellId == 147997 then
		if self.Options.SpecWarn147997interrupt and self:CheckInterruptFilter(args.sourceGUID, nil, false) then--Purposely no CD check, some casters can be stunned/knocked/etc (outside of high priests)
			specWarnCauterize:Show(args.sourceName)
			specWarnCauterize:Play("kickcast")
		elseif self:AntiSpam(2, 7) then
			warnCauterize:Show()
		end
	elseif spellId == 148004 and self:AntiSpam(3, 5) then
		specWarnConjurKiln:Show()
		specWarnConjurKiln:Play("targetchange")
	elseif spellId == 147674 and self:AntiSpam(2.5, 2) then
		specWarnCracklingBlow:Show()
		specWarnCracklingBlow:Play("shockwave")
	elseif spellId == 148003 and self:AntiSpam(2.5, 2) then
		specWarnBlazingBlow:Show()
		specWarnBlazingBlow:Play("shockwave")
	elseif spellId == 148001 and self:AntiSpam(3, 1) then
		warnConjurGolem:Show()
	elseif spellId == 147998 and self:AntiSpam(2.5, 2) then
		specWarnFireStorm:Show()
		specWarnFireStorm:Play("watchstep")
	elseif spellId == 147723 and self:AntiSpam(2.5, 2) then
		specWarnFallingFlames:Show()
		specWarnFallingFlames:Play("watchstep")
	elseif spellId == 147818 then
		self:BossTargetScanner(sourceGUID, "FireBlossomTarget", 0.02, 16)
	elseif spellId == 147828 then
		self:BossTargetScanner(sourceGUID, "StormBlossomTarget", 0.02, 16)
	elseif spellId == 147817 and self:AntiSpam(2.5, 6) then
		warnFlameBreath:Show()
	elseif spellId == 147826 and self:AntiSpam(2.5, 6) then
		warnLightningBreath:Show()
	elseif spellId == 147769 then
		if self:CheckInterruptFilter(args.sourceGUID, nil, false) then
			specWarnRenewingMists:Show(args.sourceName)
			specWarnRenewingMists:Play("kickcast")
		end
	elseif spellId == 147702 and self:AntiSpam(3, 1) then
		specWarnBlazingCleave:Show()
		specWarnBlazingCleave:Play("justrun")
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	local spellId = args.spellId
	if spellId == 147655 and args:IsPlayer() then
		local amount = args.amount or 1
		if (amount % 3 == 0) or amount >= 7 then
			specWarnFrogToxin:Show(args.amount or 1)
			specWarnFrogToxin:Play("stackhigh")
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.shipSummon or msg:find(L.shipSummon) then
		specWarnShip:Show()
	elseif msg == L.golgSpawn or msg:find(L.golgSpawn) then
		specWarnGolg:Show()
	end
end
