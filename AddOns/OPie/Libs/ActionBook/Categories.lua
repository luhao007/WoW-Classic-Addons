local COMPAT, _, T = select(4,GetBuildInfo()), ...
if T.SkipLocalActionBook then return end
if T.TenEnv then T.TenEnv() end

local MODERN, CF_WRATH, CF_CATA, CF_MISTS, CI_ERA = COMPAT > 10e4, COMPAT < 10e4 and COMPAT >= 3e4, COMPAT < 10e4 and COMPAT >= 4e4, COMPAT < 10e4 and COMPAT > 5e4, COMPAT < 2e4
local MODERN_BATTLEPETS = MODERN or CF_MISTS
local AB = T.ActionBook:compatible(2,21)
local RW = T.ActionBook:compatible("Rewire", 1,27)
local IM = T.ActionBook:compatible("Imp", 1,8)
assert(AB and RW and IM and 1, "Incompatible library bundle")
local L = T.ActionBook.L
local mark = {}

local function icmp(a,b)
	return strcmputf8i(a,b) < 0
end
local function isItemInteresting(tf, testIdx, bag, slot, iid)
	if testIdx == 2 then
		local r = tf(bag, slot)
		return r and (r.hasLoot or r.isReadable)
	end
	return tf(iid)
end

do -- spellbook
	local function procSpellBookEntry(add, at, knownFilter, sourceKnown, _ok, st, sid)
		if (st == "SPELL" or st == "FUTURESPELL") and not IsPassiveSpell(sid) and not mark[sid] then
			if (not knownFilter) == (st == "FUTURESPELL" or not sourceKnown) then
				mark[sid] = 1
				add(at, sid)
			end
		elseif st == "FLYOUT" then
			for j=1,select(3,GetFlyoutInfo(sid)) do
				local asid, _osid, ik = GetFlyoutSlotInfo(sid, j)
				if (not ik) == (not knownFilter) then
					procSpellBookEntry(add, at, knownFilter, sourceKnown, true, ik and "SPELL" or "FUTURESPELL", asid)
				end
			end
		end
	end
	local function procRuneBookEntry(add, _ok, st, sid)
		if st == "SPELL" and sid then
			local n1 = GetSpellInfo(sid)
			local n2, _, _, _, _, _, sid2 = GetSpellInfo(n1 or "")
			if n2 ~= n1 and sid2 and not IsPassiveSpell(sid2) and not mark[sid2] then
				mark[sid2] = 1
				add("spell", sid2)
			end
		end
	end
	local function addModernPvpTalents(add, knownFilter)
		local getSlot = C_SpecializationInfo.GetPvpTalentSlotInfo
		local s1, s2, s3 = getSlot(1), getSlot(2), getSlot(3)
		local i1, i2, i3 = s1 and s1.selectedTalentID, s2 and s2.selectedTalentID, s3 and s3.selectedTalentID
		for i=1,3 do
			local sid = knownFilter and i1 and select(6, GetPvpTalentInfoByID(i1))
			if sid and not IsPassiveSpell(sid) and not mark[sid] then
				mark[sid] = 1
				add("spell", sid)
			end
			for j=1, not knownFilter and s1 and s1.availableTalentIDs and #s1.availableTalentIDs or 0 do
				local tid = s1.availableTalentIDs[j]
				local sid = select(6, GetPvpTalentInfoByID(tid))
				if sid and not IsPassiveSpell(sid) and not mark[sid] and (tid ~= i1 and tid ~= i2 and tid ~= i3) then
					mark[sid] = 1
					add("spell", sid)
				end
			end
			i1, i2, i3, s1, s2, s3 = i2, i3, i1, s2, s3, s1
		end
	end
	local function addModernTalents(add, knownFilter)
		knownFilter = not not knownFilter
		for sid, active in IM:GetModernTalentSpells() do
			if active == knownFilter and not IsPassiveSpell(sid) and not mark[sid] then
				mark[sid] = 1
				add("spell", sid)
			end
		end
	end
	local function addSpells(add, knownFilter)
		local asv = not MODERN and GetCVar("showAllSpellRanks")
		if asv and asv ~= "1" then
			SetCVar("showAllSpellRanks", "1")
		end
		for i=1,GetNumSpellTabs()+12 do
			local _, ico, ofs, c, _, otherSpecID = GetSpellTabInfo(i)
			local isNotOffspec = otherSpecID == 0
			for j=ofs+1, knownFilter and CI_ERA and ico == 134419 and ofs+c or 0 do
				procRuneBookEntry(add, pcall(GetSpellBookItemInfo, j, "spell"))
			end
			for j=ofs+1,(isNotOffspec or not knownFilter) and (ofs+c) or 0 do
				procSpellBookEntry(add, "spell", knownFilter, isNotOffspec, pcall(GetSpellBookItemInfo, j, "spell"))
			end
		end
		if MODERN then
			addModernTalents(add, knownFilter)
			addModernPvpTalents(add, knownFilter)
		end
		if asv and asv ~= "1" and not MODERN then
			SetCVar("showAllSpellRanks", asv)
		end
	end
	AB:AugmentCategory(L"Abilities", function(_, add)
		wipe(mark)
		addSpells(add, true)
		if MODERN and UnitLevel("player") >= 10 and not mark[161691] then
			add("spell", 161691)
		end
		addSpells(add, false)
		wipe(mark)
	end)
	local _, cl = UnitClass("player")
	if cl == "HUNTER" or cl == "WARLOCK" or MODERN and cl == "MAGE" then
		AB:AugmentCategory(L"Pet abilities", function(_, add)
		if not PetHasSpellbook() then return end
		wipe(mark)
		for i=1,HasPetSpells() or 0 do
			if MODERN then
				local ok, st, aid = pcall(GetSpellBookItemInfo, i, "pet")
				local sid = ok and st == "PETACTION" and aid and C_PetInfo.GetSpellForPetAction(aid)
				if sid and sid > 10 then -- BUG[10.x] shared control commands return bogus low "spell IDs"
					procSpellBookEntry(add, "petspell", true, true, ok, "SPELL", sid)
				end
			else
				local sid = select(7, GetSpellInfo(i, "pet"))
				if sid and not IsPassiveSpell(sid) then
					add("petspell", sid)
				end
			end
		end
		for s in ("attack move stay follow assist defend passive dismiss"):gmatch("%S+") do
			if MODERN or s ~= "move" then
				add("petspell", s)
			end
		end
		wipe(mark)
		end)
	end
end
AB:AugmentCategory(L"Items", function(_, add)
	wipe(mark)
	local ns, giid = C_Container.GetContainerNumSlots, C_Container.GetContainerItemID
	for t=0,2 do
		local tf = t == 0 and C_Item.GetItemSpell or t == 1 and C_Item.IsEquippableItem or C_Container.GetContainerItemInfo
		for bag=0,4 do
			for slot=1, ns(bag) do
				local iid = giid(bag, slot)
				if iid and not mark[iid] and isItemInteresting(tf, t, bag, slot, iid) then
					add("item", iid)
					mark[iid] = 1
				end
			end
		end
		for slot=INVSLOT_FIRST_EQUIPPED, t < 2 and INVSLOT_LAST_EQUIPPED or -10 do
			local iid = GetInventoryItemID("player", slot)
			if iid and not mark[iid] and tf(iid) then
				add("item", iid)
				mark[iid] = 1
			end
		end
	end
end)
AB:AugmentCategory(L"Equipped", function(_, add)
	for w in ("head neck shoulders back chest tabard shirt wrist hands waist legs feet finger1 finger2 trinket1 trinket2"):gmatch("%S+") do
		add("peq", w)
	end
end)
if MODERN or CF_WRATH then -- Battle pets/Companions
	local running, sourceFilters, typeFilters, flagFilters, search = false, {}, {}, {[LE_PET_JOURNAL_FILTER_COLLECTED]=1, [LE_PET_JOURNAL_FILTER_NOT_COLLECTED]=1}, ""
	hooksecurefunc(C_PetJournal, "SetSearchFilter", function(filter) search = filter end)
	hooksecurefunc(C_PetJournal, "ClearSearchFilter", function() if not running then search = "" end end)
	local function FilterPetInfo(...)
		local petID, spID = ...
		if spID and not select(15, ...) then -- can't battle
			return petID, spID
		end
		return petID
	end
	AB:AugmentCategory(not MODERN_BATTLEPETS and COMPANIONS or L"Battle pets", function(_, add)
		assert(not running, "Battle pets enumerator is not reentrant")
		running = true
		for i=1, C_PetJournal.GetNumPetSources() do
			sourceFilters[i] = C_PetJournal.IsPetSourceChecked(i)
		end
		C_PetJournal.SetAllPetSourcesChecked(true)
	
		for i=1, C_PetJournal.GetNumPetTypes() do
			typeFilters[i] = C_PetJournal.IsPetTypeChecked(i)
		end
		C_PetJournal.SetAllPetTypesChecked(true)
	
		-- There's no API to retrieve the filter, so rely on hooks
		C_PetJournal.ClearSearchFilter()
		
		for k in pairs(flagFilters) do
			flagFilters[k] = C_PetJournal.IsFilterChecked(k)
		end
		C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, true)
		C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, false)
		local sortParameter = C_PetJournal.GetPetSortParameter()
		C_PetJournal.SetPetSortParameter(LE_SORT_BY_LEVEL)
		
		if MODERN then
			add("battlepet", "fave")
		end
		for i=1,C_PetJournal.GetNumPets() do
			add("battlepet", FilterPetInfo(C_PetJournal.GetPetInfoByIndex(i)))
		end
		
		for k, v in pairs(flagFilters) do
			C_PetJournal.SetFilterChecked(k, v)
		end
		for i=1,#typeFilters do
			C_PetJournal.SetPetTypeFilter(i, typeFilters[i])
		end
		for i=1,#sourceFilters do
			C_PetJournal.SetPetSourceChecked(i, sourceFilters[i])
		end
		C_PetJournal.SetSearchFilter(search)
		C_PetJournal.SetPetSortParameter(sortParameter)
		
		running = false
	end)
end
if MODERN or CF_WRATH then -- Mounts
	AB:AugmentCategory(L"Mounts", function(_, add)
		if GetSpellInfo(150544) then add("spell", 150544) end
		local myFactionId = UnitFactionGroup("player") == "Horde" and 0 or 1
		local idm, i2, i2n = C_MountJournal.GetMountIDs(), {}, {}
		for i=1, #idm do
			local mid = idm[i]
			local name, sid, _3, _4, _5, _6, _7, factionLocked, factionId, hide, have = C_MountJournal.GetMountInfoByID(mid)
			if have and not hide and (not factionLocked or factionId == myFactionId) and RW:IsSpellCastable(sid, 2) then
				i2[#i2+1], i2n[mid] = mid, name
			end
		end
		table.sort(i2, function(a,b) return icmp(i2n[a], i2n[b]) end)
		for i=1,#i2 do
			add("mount", i2[i])
		end
	end)
end
AB:AugmentCategory(L"Macros", function(_, add)
	add("imptext", "")
	local n, ni = {}, 1
	for name in RW:GetNamedMacros() do
		n[ni], ni = name, ni + 1
	end
	table.sort(n, icmp)
	for i=1,#n do
		add("macro", n[i])
	end
end)
if COMPAT >= 3e4 then -- equipmentset
	AB:AugmentCategory(L"Equipment sets", function(_, add)
		for _,id in pairs(C_EquipmentSet.GetEquipmentSetIDs()) do
			add("equipmentset", (C_EquipmentSet.GetEquipmentSetInfo(id)))
		end
	end)
end
AB:AugmentCategory(L"Raid markers", function(_, add)
	local NUM_WORLD_MARKERS = CF_CATA and NUM_WORLD_RAID_MARKERS_CATA == 5 and 5 or 8
	for k=0, (MODERN or CF_CATA) and 1 or 0 do
		k = k == 0 and "raidmark" or "worldmark"
		for i=0, k == "worldmark" and NUM_WORLD_MARKERS or 8 do
			add(k, i)
		end
	end
end)
if MODERN or CF_WRATH then -- toys
	local tx, fs, fx, tfs = C_ToyBox, {}, {}
	hooksecurefunc(C_ToyBox, "SetFilterString", function(s) tfs = s end) -- No corresponding Get
	local function doAddToys(add)
		for i=1,C_ToyBox.GetNumFilteredToys() do
			local iid = C_ToyBox.GetToyFromIndex(i)
			if iid > 0 and PlayerHasToy(iid) then
				add("toy", iid)
			end
		end
	end
	AB:AugmentCategory(L"Toys", function(_, add)
		local ff = tfs
		local fc = tx.GetCollectedShown()
		local fu = tx.GetUncollectedShown()
		for i=1,C_PetJournal.GetNumPetSources() do
			fs[i] = tx.IsSourceTypeFilterChecked(i)
		end
		for i=1,GetNumExpansions() do
			fx[i] = tx.IsExpansionTypeFilterChecked(i)
		end
		tx.SetFilterString("")
		tx.SetCollectedShown(true)
		tx.SetUncollectedShown(false)
		tx.SetAllSourceTypeFilters(true)
		tx.SetAllExpansionTypeFilters(true)
		tx.ForceToyRefilter()

		securecall(doAddToys, add)

		tx.SetFilterString(ff or "")
		tx.SetCollectedShown(fc)
		tx.SetUncollectedShown(fu)
		for i=1,C_PetJournal.GetNumPetSources() do
			tx.SetSourceTypeFilter(i, fs[i])
		end
		for i=1,GetNumExpansions() do
			tx.SetExpansionTypeFilter(i, fx[i])
		end
		tx.ForceToyRefilter()
	end)
end
do -- misc
	if (MODERN or CF_CATA) and GetExtraBarIndex then
		AB:AddActionToCategory(L"Miscellaneous", "extrabutton", 1)
	end
	if MODERN then
		AB:AddActionToCategory(L"Miscellaneous", "zoneability", 0)
	end
	AB:AddActionToCategory(L"Miscellaneous", "imptext", "")
end
do -- aliases
	AB:AddCategoryAlias("Miscellaneous", L"Miscellaneous")
end
do
	local panels = {"character", "reputation", "currency", "spellbook", "talents", "profs", "achievements", "quests", "groupfinder", "collections", "adventureguide", "guild", "map", "vault", "social", "calendar", "macro", "options", "gamemenu"}
	AB:AugmentCategory(L"UI panels", function(_, add)
		for i=1,#panels do
			i = panels[i]
			if select(2, AB:GetActionListDescription("uipanel", i)) then
				add("uipanel", i)
			end
		end
	end)
end