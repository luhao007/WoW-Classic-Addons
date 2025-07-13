local COMPAT, _, T = select(4,GetBuildInfo()), ...
if T.SkipLocalActionBook then return end
if T.TenEnv then T.TenEnv() end

local EV, AB, KR, RW, IM = T.Evie, T.ActionBook:compatible(2,38), T.ActionBook:compatible("Kindred", 1,26), T.ActionBook:compatible("Rewire", 1,27), T.ActionBook:compatible("Imp", 1,11)
assert(EV and AB and KR and RW and IM and 1, "Incompatible library bundle")
local MODERN, CI_ERA, CF_CATA = COMPAT >= 10e4, COMPAT < 2e4, COMPAT < 10e4 and COMPAT > 4e4
local playerClass, _, playerRace = UnitClassBase("player"), UnitRace("player")

local safequote do
	local r = {u="\\117", ["{"]="\\123", ["}"]="\\125"}
	function safequote(s)
		return (("%q"):format(s):gsub("[{}u]", r))
	end
end

securecall(function() -- weirdly-persistent Druid Incarnations
	if not MODERN then
		return
	end
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
end)
securecall(function() -- class/race-locked mounts
	if not (MODERN or CF_CATA) then
		return
	end
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
end)
securecall(function() -- Tarecgosa's Visage
	if not MODERN then
		return
	end
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
end)
securecall(function() -- Classic Paladin mounts
	if not (CF_CATA and playerClass == "PALADIN" and playerRace ~= "Tauren") then
		-- Only the Sunwalker kodos work with /cast out of the box
		return
	end
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
end)
securecall(function() -- failing ability rank disambiguation
	if not MODERN then
		return
	end
	local Spell_ForcedID = {126819, 28272, 28271, 161372, 51514, 210873, 211004, 211010, 211015, 783, 126892}
	local function checkForcedIDCastable(id)
		return not not FindSpellBookSlotBySpellID(id), "forced-id-cast"
	end
	for i=1,#Spell_ForcedID do
		RW:SetSpellCastableChecker(Spell_ForcedID[i], checkForcedIDCastable)
	end
end)
securecall(function() -- failing profession rank disambiguation
	if not MODERN then
		return
	end
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
end)
securecall(function() -- missing usability conditions for Garrison/Dalaran Hearthstone toys
	if not MODERN then
		return
	end
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
end)
securecall(function() -- /ping's option parsing is silly
	if not MODERN then
		return
	end
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
end)
securecall(function() -- /equipset {not a set name} errors
	if not MODERN then
		-- Classic lacks the SABT action
		return
	end
	local function uniqueName(prefix)
		local bni, bn = 1 repeat
			bn, bni = prefix .. bni, bni + 1
		until _G[bn] == nil and GetClickFrame(bn) == nil
		return bn
	end
	local f = CreateFrame("Button", uniqueName("ABEquipSetQuirk!"), nil, "SecureActionButtonTemplate")
	f:SetAttribute("pressAndHoldAction", 1)
	f:SetAttribute("type", "equipmentset")
	f:SetAttribute("typerelease", "equipmentset")
	f:SetAttribute("DoEquipCommand", SLASH_CLICK1 .. " " .. f:GetName())
	f:SetAttribute("RunSlashCmd", [[-- AB_EquipSetQuirk_Run 
		local cmd, v = ...
		if v and v ~= "" then
			self:SetAttribute("equipmentset", v)
			return self:GetAttribute("DoEquipCommand"), "notified-click", v
		end
	]])
	f:SetAttribute("RunSlashCmd-PreClick", [[-- AB_EquipSetQuirk_PreRun 
		local cmd, v = ...
		self:SetAttribute("equipmentset", v)
	]])
	RW:RegisterCommand(SLASH_EQUIP_SET1, true, false, f)
end)
securecall(function() -- ClassTalentHelper commands are in SlashCmdList instead of SecureCmdList
	if not MODERN then
		return
	end
	RW:ImportSlashCmd("TALENT_LOADOUT_BY_NAME", true, false)
	RW:ImportSlashCmd("TALENT_LOADOUT_BY_INDEX", true, false)
	RW:ImportSlashCmd("TALENT_SPEC_BY_NAME", true, false)
	RW:ImportSlashCmd("TALENT_SPEC_BY_INDEX", true, false)
end)
securecall(function() -- SoD rune ability castable checks
	if not CI_ERA then
		return
	end
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
end)
securecall(function() -- 4.4.0 misplaces secure commands
	if not CF_CATA then
		return
	end
	RW:ImportSlashCmd("WORLD_MARKER", true, false)
	RW:ImportSlashCmd("CLEAR_WORLD_MARKER", true, false)
	RW:ImportSlashCmd("EQUIP_SET", true, false)
end)
securecall(function() -- Draenic Hologem usability limitation
	if MODERN and playerRace ~= "Draenei" and playerRace ~= "LightforgedDraenei" then
		AB:SetPlayerHasToyOverride(210455, false)
	end
end)

local MAYBE_FLYABLE, FLIGHT_BLOCKER = true
securecall(function() -- FLIGHT_BLOCKER init
	if not MODERN then
		return
	end
	local f = CreateFrame("Frame", nil, nil, "SecureHandlerAttributeTemplate")
	f:SetFrameRef("KR", KR:seclib())
	f:Execute('KR = self:GetFrameRef("KR")')
	f:SetAttribute("_onattributechanged", [[-- AB_BlockedFlyable_Driver 
		local sk, v = name:match("^state%-(.+)"), value
		if v == 1 or v == 0 then
			KR:RunAttribute("UpdateStateConditional", "blockedflyable", v == 1 and sk or "", v == 0 and sk or "")
		end
	]])
	FLIGHT_BLOCKER = f
end)
securecall(function() -- MAYBE_FLYABLE: [anyflyable] mirror
	if not (MODERN and (playerClass == "DRUID" or playerRace == "Dracthyr")) then
		return
	end
	local f = CreateFrame("Frame", nil, nil, "SecureFrameTemplate")
	f:SetScript("OnAttributeChanged", function(_, a, v)
		if a == "state-anyflyable" then
			MAYBE_FLYABLE = v == 1
		end
	end)
	KR:RegisterStateDriver(f, "anyflyable", "[anyflyable] 1;")
end)

securecall(function() -- Siren Isle flight restrictions
	if not MODERN then
		return
	end
	local SIREN_ISLE_STORM_SID, inStorm, noPendingUpdate, onSirenIsle = 458069, 0, 1
	local checkSIStormTimer
	local function checkSIStorm(e)
		if e == "PLAYER_ENTERING_WORLD" then
			local _,_,_,_, _,_,_,imid = GetInstanceInfo()
			onSirenIsle = imid == 2127
		elseif e == 'RAID_BOSS_EMOTE' then
			EV.After(0.25, checkSIStormTimer)
		end
		local nv = onSirenIsle and C_UnitAuras.GetPlayerAuraBySpellID(SIREN_ISLE_STORM_SID) and 1 or 0
		if nv == inStorm then
		elseif not InCombatLockdown() then
			inStorm = nv
			FLIGHT_BLOCKER:SetAttribute("state-sirenislestorm", nv)
		elseif noPendingUpdate then
			EV.PLAYER_REGEN_ENABLED, noPendingUpdate = checkSIStorm
		end
		if e == "PLAYER_REGEN_ENABLED" then
			noPendingUpdate = 1
			return "remove"
		end
	end
	function checkSIStormTimer()
		checkSIStorm('TIMER')
	end
	local SIREN_ISLE_FLIGHT_QID, disarm = 85657
	local function disarmSIFBlock()
		if not InCombatLockdown() and disarm ~= 2 then
			KR:RegisterStateDriver(FLIGHT_BLOCKER, "sirenisle", nil)
			FLIGHT_BLOCKER:SetAttribute("state-sirenisle", 0)
			disarm = 2
			EV.PLAYER_ENTERING_WORLD, EV.RAID_BOSS_EMOTE = checkSIStorm, checkSIStorm
			checkSIStorm("PLAYER_ENTERING_WORLD")
		elseif not disarm then
			disarm, EV.PLAYER_REGEN_ENABLED = 1, disarmSIFBlock
		end
		return "remove"
	end
	local function checkSIFBlock(ev, qid)
		if ev == "QUEST_TURNED_IN" and qid == SIREN_ISLE_FLIGHT_QID or
		   ev == "PLAYER_ENTERING_WORLD" and C_QuestLog.IsQuestFlaggedCompletedOnAccount(SIREN_ISLE_FLIGHT_QID) then
			return disarmSIFBlock()
		end
		return disarm and "remove"
	end
	EV.QUEST_TURNED_IN = checkSIFBlock
	EV.PLAYER_ENTERING_WORLD = checkSIFBlock
	KR:RegisterStateDriver(FLIGHT_BLOCKER, "sirenisle", "[in:siren isle] 1;0")
end)
securecall(function() -- Oribos/Tazavesh flight restriction
	if not MODERN then
		return
	end
	local unflyableMaps = {[1670]=1, [1671]=1, [1672]=1, [1673]=1, [2016]=2}
	local inSL, state, goal, pending = false, false, false
	local function syncState()
		if state ~= goal then
			FLIGHT_BLOCKER:SetAttribute("state-oribos", goal and 1 or 0)
			state = goal
		end
		pending = nil
		return "remove"
	end
	local function onZoneChange()
		goal = inSL and unflyableMaps[C_Map.GetBestMapForUnit("player")] ~= nil
		if goal == state then
		elseif not InCombatLockdown() then
			syncState()
		elseif not pending then
			EV.PLAYER_REGEN_ENABLED, pending = syncState, true
		end
	end
	function EV.PLAYER_ENTERING_WORLD()
		local f,_,_,_, _,_,_,imid = GetInstanceInfo()
		if (imid == 2222) ~= inSL then
			inSL, f = not inSL, EV[inSL and "UnregisterEvent" or "RegisterEvent"]
			f("ZONE_CHANGED_NEW_AREA", onZoneChange)
			onZoneChange()
		end
	end
end)
securecall(function() -- Darkmoon Fairegrounds flight restriction
	if not MODERN then
		return
	end
	KR:RegisterStateDriver(FLIGHT_BLOCKER, "dmf", "[in:darkmoon faire] 1; 0")
end)
securecall(function() -- TWW dungeon/delve flight restriction
	if not MODERN then
		return
	end
	KR:RegisterStateDriver(FLIGHT_BLOCKER, "dung", "[in:dungeon,noin:nokhud/dawnbreaker][in:delve] 1; 0")
end)
securecall(function() -- Travel form outcome feedback
	if not (MODERN and playerClass == "DRUID") then
		return
	end
	local CAN_FLY, CAN_SWIM = false, false
	AB:SetSpellIconOverride(783, function()
		if CAN_SWIM and IsSwimming() then
			return 132112
		end
		return CAN_FLY and MAYBE_FLYABLE and not InCombatLockdown() and 132128 or 132144, not IsIndoors()
	end)
	local function syncLevel(ev)
		local lv = UnitLevel("player") or 0
		CAN_SWIM = CAN_SWIM or lv >= 17
		CAN_FLY = CAN_FLY or lv >= 30
		return (ev == "PLAYER_LOGIN" or CAN_FLY and CAN_SWIM) and "remove"
	end
	EV.PLAYER_LEVEL_UP = syncLevel
	EV.PLAYER_LOGIN = syncLevel
end)
securecall(function() -- Soar usability feedback
	if MODERN and playerRace == "Dracthyr" then
		AB:SetSpellIconOverride(369536, function()
			if not MAYBE_FLYABLE then
				return nil, false
			end
		end)
	end
end)
securecall(function() -- Siren Isle Research Journal requires pages to use
	if MODERN then
		AB:SetItemCountOverride(227405, function()
			local noteCount = C_Item.GetItemCount(227406)
			return noteCount, noteCount > 0
		end)
	end
end)
securecall(function() -- Modern: some mounts aren't castable by spell IDs
	if not MODERN then
		return
	end
	local BROKEN_SPELL_IDS, lockdown = {366962, 471562}
	local function pushMountCasts(ev)
		if InCombatLockdown() then
			lockdown = 1
		elseif ev ~= "PLAYER_REGEN_ENABLED" or lockdown then
			local gsn, ei = C_Spell.GetSpellName, #BROKEN_SPELL_IDS
			for i=ei, 1, -1 do
				local sn = gsn(BROKEN_SPELL_IDS[i])
				if sn and gsn(sn) then
					RW:SetCastAlias("spell:" .. BROKEN_SPELL_IDS[i], sn)
					BROKEN_SPELL_IDS[i], ei, BROKEN_SPELL_IDS[ei] = i ~= ei and BROKEN_SPELL_IDS[ei] or nil, ei - 1
				end
			end
		end
		return (#BROKEN_SPELL_IDS == 0 or ev == "PLAYER_LOGIN") and "remove"
	end
	EV.NEW_MOUNT_ADDED, EV.PLAYER_REGEN_ENABLED, EV.PLAYER_LOGIN = pushMountCasts, pushMountCasts, pushMountCasts
end)
securecall(function() -- Modern: G-99 Breakneck is a fake mount
	if not MODERN then
		return
	end
	local G99_SPELL_ID, G99_QUEST_ID, questOK = 460013, 84352
	local inUndermine, wf = false, CreateFrame("Frame", nil, nil, "SecureFrameTemplate")
	local function pushG99SpellCastID()
		RW:SetCastAlias("spell:" .. G99_SPELL_ID, C_Spell.GetSpellName(G99_SPELL_ID))
		return "remove"
	end
	local function hasUnlockedG99()
		if not questOK and C_QuestLog.IsQuestFlaggedCompletedOnAccount(G99_QUEST_ID) then
			questOK = true
			if InCombatLockdown() then
				EV.PLAYER_REGEN_ENABLED = pushG99SpellCastID
			else
				pushG99SpellCastID()
			end
		end
		return questOK
	end
	local function updateGroundMount()
		IM:SetMountPreference(inUndermine and G99_SPELL_ID or false)
		AB:NotifyObservers("imptext")
	end
	wf:SetScript("OnAttributeChanged", function(_, a, v)
		if a ~= "state-um" or (v == 1) == inUndermine then
			return
		end
		inUndermine = v == 1
		return hasUnlockedG99() and updateGroundMount()
	end)
	wf:Hide()
	KR:RegisterStateDriver(wf, 'um', '[in:undermine] 1; 0')
	RW:SetSpellCastableChecker(G99_SPELL_ID, function()
		if hasUnlockedG99() and inUndermine then
			return true, "g99-quirk"
		end
		return false, "g99-quirk"
	end)
	AB:AugmentCategory(AB.L"Mounts", function(_, add)
		if hasUnlockedG99() then
			add("spell", G99_SPELL_ID)
		end
	end)
	function EV:QUEST_TURNED_IN(qid)
		if qid == G99_QUEST_ID then
			questOK = true
			updateGroundMount()
		end
		return questOK and "remove"
	end
	function EV:LOADING_SCREEN_ENABLED()
		-- [11.1/2504] quest completion cache is flushed on PLW; may not repop by PEW.
		return hasUnlockedG99() and "remove"
	end
end)