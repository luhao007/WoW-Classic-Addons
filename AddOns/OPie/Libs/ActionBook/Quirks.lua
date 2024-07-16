local COMPAT, _, T = select(4,GetBuildInfo()), ...
if T.SkipLocalActionBook then return end
if T.TenEnv then T.TenEnv() end

local EV, AB, RW = T.Evie, T.ActionBook:compatible(2,38), T.ActionBook:compatible("Rewire", 1,27)
assert(EV and AB and RW and 1, "Incompatible library bundle")
local MODERN, CI_ERA, CF_CATA = COMPAT >= 10e4, COMPAT < 2e4, COMPAT < 10e4 and COMPAT > 4e4
local playerClass, _, playerRace = UnitClassBase("player"), UnitRace("player")

local safequote do
	local r = {u="\\117", ["{"]="\\123", ["}"]="\\125"}
	function safequote(s)
		return (("%q"):format(s):gsub("[{}u]", r))
	end
end

if MODERN then -- weirdly-persistent Incarnations
	local function checkSpellKnown(id)
		if not IsSpellKnown(id) then
			return false, "known-check"
		end
	end

	RW:SetSpellCastableChecker(33891, checkSpellKnown)
	RW:SetSpellCastableChecker(102543, checkSpellKnown)
	RW:SetSpellCastableChecker(102558, checkSpellKnown)
	RW:SetSpellCastableChecker(102560, function()
		if not (IsSpellKnown(194223) and select(7, GetSpellInfo((GetSpellInfo(194223)))) == 102560) then
			return false, "known-check"
		end
	end)
end

if MODERN or CF_CATA then -- class-locked mount spells
	local classLockedMounts = {
		[48778]="DEATHKNIGHT", [54729]="DEATHKNIGHT", [229387]="DEATHKNIGHT",
		[229417]="DEMONHUNTER", [200175]="DEMONHUNTER",
		[229386]="HUNTER", [229438]="HUNTER", [229439]="HUNTER",
		[229376]="MAGE",
		[229385]="MONK",
		[13819]="PALADIN", [23214]="PALADIN", [34767]="PALADIN", [34769]="PALADIN", [66906]="PALADIN", [69820]="PALADIN", [69826]="PALADIN", [221883]="PALADIN", [205656]="PALADIN", [221885]="PALADIN", [221886]="PALADIN", [231587]="PALADIN", [231588]="PALADIN", [231589]="PALADIN", [231435]="PALADIN",
		[73629]="PALADIN", [73630]="PALADIN", [270564]="PALADIN", [270562]="PALADIN", [290608]="PALADIN", [363613]="PALADIN",
		[229377]="PRIEST",
		[231434]="ROGUE", [231523]="ROGUE", [231524]="ROGUE", [231525]="ROGUE",
		[231442]="SHAMAN",
		[5784]="WARLOCK", [23161]="WARLOCK", [232412]="WARLOCK", [238452]="WARLOCK", [238454]="WARLOCK",
		[229388]="WARRIOR",
	}
	local raceLockedMounts = {
		-- Paladin chargers
		[73629]="Draenei", [73630]="Draenei",
		[34769]="BloodElf", [34767]="BloodElf",
		[69820]="Tauren", [69826]="Tauren",
		[270564]="Dwarf",
		[270562]="DarkIronDwarf",
		[290608]="ZandalariTroll",
		[363613]="LightforgedDraenei",
	}
	local f, m, reason = UnitClass, classLockedMounts, "uncastable-class-lock"
	for i=1,2 do
		local function retUncastable()
			return false, reason, true
		end
		local _, me = f("player")
		for sid, v in pairs(m) do
			if v ~= me then
				RW:SetSpellCastableChecker(sid, retUncastable)
			end
		end
		f, m, reason = UnitRace, raceLockedMounts, "uncastable-race-lock"
	end
end

if MODERN then -- Tarecgosa's Visage
	local SPELL_ID, MOUNT_ID, QUEST_ID = 407555, 1727, 73199
	local questOK, mountOK
	local function addCastEscapes()
		if InCombatLockdown() then
			EV.PLAYER_REGEN_ENABLED = addCastEscapes
			return
		end
		local mslot = AB:GetActionSlot("mount", MOUNT_ID)
		if mslot then
			local sname = GetSpellInfo(SPELL_ID)
			RW:SetCastEscapeAction("spell:" .. SPELL_ID, mslot)
			RW:SetCastEscapeAction(sname, mslot)
			AB:NotifyObservers("spell")
		end
		return "remove"
	end
	local function checkVisageConditions()
		questOK = questOK or C_QuestLog.IsQuestFlaggedCompleted(QUEST_ID)
		if questOK and not mountOK then
			local _, _, _, _, _, _, _, _, _, hide, have = C_MountJournal.GetMountInfoByID(MOUNT_ID)
			mountOK = have and not hide
		end
		if questOK and mountOK and addCastEscapes then
			addCastEscapes()
			addCastEscapes = nil
			return true
		end
	end
	RW:SetSpellCastableChecker(SPELL_ID, function(_, castContext)
		local canMount = questOK and mountOK or checkVisageConditions()
		local castable = canMount and type(castContext) == "number" and castContext % 4 >= 2
		return castable, "visage-check", not castable
	end)
	local function cueVisageCheck()
		return (questOK and mountOK or checkVisageConditions()) and "remove" or nil
	end
	EV.QUEST_TURNED_IN = cueVisageCheck
	EV.PLAYER_ENTERING_WORLD = cueVisageCheck
	EV.NEW_MOUNT_ADDED = cueVisageCheck
end

if CF_CATA and playerClass == "PALADIN" and playerRace ~= "Tauren" then -- Only the Sunwalker kodos work with /cast out of the box
	local pendingMounts, noQueue = {}, 1
	if playerRace == "BloodElf" then
		pendingMounts[34767], pendingMounts[34769] = 1, 1
	else -- Human, Dwarf, Draenei
		pendingMounts[13819], pendingMounts[23214] = 1, 1
	end
	local function castableViaEscape(_, castContext)
		local castable = type(castContext) == "number" and castContext % 4 >= 2
		return castable, "pal-catamount", not castable
	end
	local function cueMountCheck(ev)
		if InCombatLockdown() then
			if noQueue then
				EV.PLAYER_REGEN_ENABLED, noQueue = cueMountCheck, nil
			end
			return
		end
		noQueue = 1
		local foundNew, fromSpell, getInfo = nil, C_MountJournal.GetMountFromSpell, C_MountJournal.GetMountInfoByID
		for sid in pairs(pendingMounts) do
			local mid = fromSpell(sid)
			if mid and select(11, getInfo(mid)) then
				RW:SetSpellCastableChecker(sid, castableViaEscape)
				local mslot = AB:GetActionSlot("mount", mid)
				if mslot then
					local sname = GetSpellInfo(sid)
					RW:SetCastEscapeAction("spell:" .. sid, mslot)
					RW:SetCastEscapeAction(sname, mslot)
				end
				foundNew, pendingMounts[sid] = 1, nil
			end
		end
		if foundNew then
			AB:NotifyObservers("spell")
		end
		return (ev == "PLAYER_REGEN_ENABLED" or next(pendingMounts) == nil) and "remove"
	end
	if next(pendingMounts) then
		EV.SPELLS_CHANGED = cueMountCheck
		EV.PLAYER_ENTERING_WORLD = cueMountCheck
		EV.NEW_MOUNT_ADDED = cueMountCheck
	end
end

if MODERN then -- failing ability rank disambiguation
	local Spell_ForcedID = {126819, 28272, 28271, 161372, 51514, 210873, 211004, 211010, 211015, 783}
	local function checkForcedIDCastable(id)
		return not not FindSpellBookSlotBySpellID(id), "forced-id-cast"
	end
	for i=1,#Spell_ForcedID do
		RW:SetSpellCastableChecker(Spell_ForcedID[i], checkForcedIDCastable)
	end
end

if MODERN then -- failing profession rank disambiguation
	local activeSet, reserveSet, pendingSync = {}, {}
	local function procProfessions(n, a, ...)
		if a then
			local _, _, _, _, scount, sofs = GetProfessionInfo(a)
			for i=sofs+1, sofs+scount do
				local et, eid = GetSpellBookItemInfo(i, "player")
				if et == "SPELL" and not IsPassiveSpell(eid) then
					local vid, sn, sr = "spell:" .. eid, GetSpellInfo(eid), GetSpellSubtext(eid)
					reserveSet[sn], reserveSet[sn .. "()"] = vid, vid
					if sr and sr ~= "" then
						reserveSet[sn .. "(" .. sr .. ")"] = vid
					end
				end
			end
		end
		if n > 1 then
			return procProfessions(n-1, ...)
		end
	end
	local function countValues(...)
		return select("#", ...), ...
	end
	local function syncProf(e)
		if InCombatLockdown() then
			if not pendingSync then
				EV.PLAYER_REGEN_ENABLED, pendingSync = syncProf, true
			end
			return
		end
		pendingSync = false
		wipe(reserveSet)
		procProfessions(countValues(GetProfessions()))
		activeSet, reserveSet = reserveSet, activeSet
		local changed
		for k in pairs(reserveSet) do
			if not activeSet[k] then
				changed = true
				RW:SetCastAlias(k, nil)
			end
		end
		for k,v in pairs(activeSet) do
			if v ~= reserveSet[k] then
				changed = true
				RW:SetCastAlias(k, v, true)
			end
		end
		if changed then
			AB:NotifyObservers("spell")
		end
		return e ~= "CHAT_MSG_SKILL" and "remove"
	end
	EV.PLAYER_LOGIN, EV.CHAT_MSG_SKILL = syncProf, syncProf
end

if MODERN then -- missing usability conditions for certain toys
	local watchedQuests = {}
	function EV:QUEST_TURNED_IN(qid)
		local tid = watchedQuests[qid]
		if tid and PlayerHasToy(tid) then
			watchedQuests[qid] = nil
			AB:NotifyObservers("toy")
		end
	end
	local function collectedAndQuestCompleted(id, q1, q2)
		watchedQuests[q1], watchedQuests[q2 or q1] = id, id
		return id, function(_id)
			if PlayerHasToy(id) then
				local qf = C_QuestLog.IsQuestFlaggedCompleted
				if qf(q1) or q2 and qf(q2) then
					AB:SetPlayerHasToyOverride(id, nil)
					return true
				end
			end
		end
	end
	AB:SetPlayerHasToyOverride(collectedAndQuestCompleted(110560, 34378, 34586)) -- Garrison Hearthstone
	AB:SetPlayerHasToyOverride(collectedAndQuestCompleted(140192, 44184, 44663)) -- Legion Dalaran Hearthstone
end

if MODERN then -- /ping's option parsing is silly
	local f, init = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate"), [[-- AB_PingQuirk_Init 
		PING_COMMAND, TOKENS = %s, newtable()
		TOKENS.assist, TOKENS.attack, TOKENS.onmyway, TOKENS.warning = %s, %s, %s, %s
	]]
	f:Execute(init:format(safequote(SLASH_PING1 .. " "), safequote(PING_TYPE_ASSIST), safequote(PING_TYPE_ATTACK), safequote(PING_TYPE_ON_MY_WAY), safequote(PING_TYPE_WARNING)))
	f:SetAttribute("RunSlashCmd", [[-- AB_PingQuirk_Run 
		local cmd, v, target, s = ...
		if v then
			target = target and target ~= "cursor" and "[@" .. target .. "] " or ""
			return PING_COMMAND .. target .. (TOKENS[v and v:lower()] or v)
		end
	]])
	RW:RegisterCommand(SLASH_PING1, true, false, f)
end

if MODERN then -- /equipset {not a set name} errors
	local function uniqueName(prefix)
		local bni, bn = 1 repeat
			bn, bni = prefix .. bni, bni + 1
		until _G[bn] == nil and GetClickFrame(bn) == nil
		return bn
	end
	local f = CreateFrame("Button", uniqueName("ABEquipSetQuirk!"), nil, "SecureActionButtonTemplate")
	f:SetAttribute("pressAndHoldAction", 1)
	f:SetAttribute("type", "equipmentset")
	f:SetAttribute("DoEquipCommand", SLASH_CLICK1 .. " " .. f:GetName() .. " 1 1")
	f:SetAttribute("RunSlashCmd", [[-- AB_EquipSetQuirk_Run 
		local cmd, v = ...
		if v then
			self:SetAttribute("equipmentset", v)
			return self:GetAttribute("DoEquipCommand")
		end
	]])
	RW:RegisterCommand(SLASH_EQUIP_SET1, true, false, f)
end

if MODERN then -- ClassTalentHelper commands are in SlashCmdList instead of SecureCmdList
	RW:ImportSlashCmd("TALENT_LOADOUT_BY_NAME", true, false)
	RW:ImportSlashCmd("TALENT_LOADOUT_BY_INDEX", true, false)
	RW:ImportSlashCmd("TALENT_SPEC_BY_NAME", true, false)
	RW:ImportSlashCmd("TALENT_SPEC_BY_INDEX", true, false)
end

if CI_ERA then -- 1.15.1 SoD rune abilities
	local function checkRuneSpell(sid)
		local n1, n2, sid2, _ = IsPlayerSpell(sid) and GetSpellInfo(sid)
		if n1 then
			n2, _, _, _, _, _, sid2 = GetSpellInfo(n1)
		end
		return n2 and n1 ~= n2 and not IsPassiveSpell(sid2) or false, "rune-ability-spell"
	end
	for sid in ("399967 417346 399954 417347 415450 417345 399966 417348 415449"):gmatch("%d+") do
		RW:SetSpellCastableChecker(sid+0, checkRuneSpell)
	end
end

if CF_CATA then -- 4.4.0 misplaces secure commands
	RW:ImportSlashCmd("WORLD_MARKER", true, false)
	RW:ImportSlashCmd("CLEAR_WORLD_MARKER", true, false)
	RW:ImportSlashCmd("EQUIP_SET", true, false)
end

if MODERN and playerRace ~= "Draenei" and playerRace ~= "LightforgedDraenei" then -- 10.2.7 thinks Draenic Hologem is usable by everyone
	AB:SetPlayerHasToyOverride(210455, false)
end