local mod	= DBM:NewMod("BigBadWolf", "DBM-Raids-BC", 8)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20241103131702")
mod:SetCreatureID(17521)
--mod:SetEncounterID(655)--used by all 3 of them, so not usuable
mod:SetModelID(17053)
mod:SetUsedIcons(8)
mod:SetZone(532)

mod:RegisterCombat("combat_yell", L.DBM_BBW_YELL_1)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 30753 30752",
	"SPELL_AURA_REMOVED 30753"
)

local warningFear		= mod:NewSpellAnnounce(30752, 3)
local warningRRH		= mod:NewTargetNoFilterAnnounce(30753, 4)

local specWarnRRH		= mod:NewSpecialWarningRun(30753, nil, nil, nil, 4, 2)

local timerRRH			= mod:NewTargetTimer(20, 30753, nil, nil, nil, 3)
local timerRRHCD		= mod:NewNextTimer(30, 30753, nil, nil, nil, 3)
local timerFearCD		= mod:NewNextTimer(24, 30752, nil, nil, nil, 2)

mod:AddSetIconOption("RRHIcon", 30753, true, 0, {8})

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 30753 then
		timerRRH:Start(args.destName)
		if self:IsInCombat() then--Because sometimes debuff goes out half sec after combat end
			timerRRHCD:Start()
			if args:IsPlayer() then
				specWarnRRH:Show()
				specWarnRRH:Play("justrun")
				specWarnRRH:ScheduleVoice(1, "keepmove")
			else
				warningRRH:Show(args.destName)
			end
			if self.Options.RRHIcon then
				self:SetIcon(args.destName, 8, 20)
			end
		end
	elseif args.spellId == 30752 and self:AntiSpam() then
		warningFear:Show()
		timerFearCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 30753 and self.Options.RRHIcon then
		self:SetIcon(args.destName, 0)
	end
end
