local COMPAT, _, T = select(4, GetBuildInfo()), ...
if COMPAT < 11e4 then return end
local env = {}

function env.GetSpellTabInfo(idx)
	local i = C_SpellBook.GetSpellBookSkillLineInfo(idx)
	if i then
		return i.name, i.iconID, i.itemIndexOffset, i.numSpellBookItems, i.isGuild, i.specID or 0
	else
		return nil, nil, 0, -1, nil, 0
	end
end
env.GetNumSpellTabs = C_SpellBook.GetNumSpellBookSkillLines

local bookTypeMap = {spell=0, pet=1, [0]=0, [1]=1}
local bookItemTypeMap = {[0]="NONE", "SPELL", "FUTURESPELL", "PETACTION", "FLYOUT"}
function env.GetSpellBookItemInfo(idx, bookType)
	local ii = C_SpellBook.GetSpellBookItemInfo(idx, bookTypeMap[bookType] or 0)
	if ii then
		return bookItemTypeMap[ii.itemType], ii.actionID
	end
end
function env.GetSpellBookItemName(idx, bookType)
	return C_SpellBook.GetSpellBookItemName(idx, bookTypeMap[bookType] or 0)
end
function env.GetSpellBookItemTexture(idx, bookType)
	return C_SpellBook.GetSpellBookItemTexture(idx, bookTypeMap[bookType] or 0)
end
env.HasPetSpells = C_SpellBook.HasPetSpells
env.BOOKTYPE_SPELL = 0
env.BOOKTYPE_PET = 1

function env.GetSpellInfo(id, rt)
	if id and rt and type(rt) == "string" and type(id) == "string" then
		id = id .. "(" .. rt .. ")"
	end
	local si = id and C_Spell.GetSpellInfo(id)
	if si then
		return si.name, nil, si.iconID, si.castTime, si.minRange, si.maxRange, si.spellID, si.originalIconID
	end
end
function env.GetSpellCooldown(id)
	id = id and C_Spell.GetOverrideSpell(id)
	local ci = id and C_Spell.GetSpellCooldown(id)
	if ci then
		return ci.startTime, ci.duration, ci.isEnabled and 1 or 0, ci.modRate
	end
end
function env.GetSpellCharges(id)
	id = id and C_Spell.GetOverrideSpell(id)
	local ci = id and C_Spell.GetSpellCharges(id)
	if ci then
		return ci.currentCharges, ci.maxCharges, ci.cooldownStartTime, ci.cooldownDuration, ci.chargeModRate
	end
end
env.GetSpellSubtext = C_Spell.GetSpellSubtext
env.IsPassiveSpell = C_Spell.IsSpellPassive
env.IsSpellInRange = C_Spell.IsSpellInRange
env.IsUsableSpell = C_Spell.IsSpellUsable
env.GetSpellCount = C_Spell.GetSpellCastCount
env.IsCurrentSpell = C_Spell.IsCurrentSpell
env.GetSpellTexture = C_Spell.GetSpellTexture
env.DoesSpellExist = C_Spell.DoesSpellExist
env.GetSpellLink = C_Spell.GetSpellLink

function env.GetStablePetInfo(idx)
	local si = C_StableInfo.GetStablePetInfo(idx)
	if si then
		return si.icon, si.name, si.level, si.familyName, si.specialization
	end
end

env.Vector2DMixin = Vector2DMixin

local function proxyFor(p, t)
	setmetatable(p, {__index=t, __newindex=function(_,k,v) t[k] = v end})
end
env._G = env
proxyFor(env, _G)

function T.TenEnv()
	setfenv(2, env)
end