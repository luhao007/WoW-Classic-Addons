local _, T = ...
if T.SkipLocalActionBook then return end
local MODERN = select(4,GetBuildInfo()) >= 8e4
local MODERN_CONTAINERS = MODERN or C_Container and C_Container.GetContainerNumSlots
local CF_WRATH = not MODERN and select(4,GetBuildInfo()) >= 3e4
local AB = assert(T.ActionBook:compatible(2, 21), "A compatible version of ActionBook is required")
local RW = assert(T.ActionBook:compatible("Rewire", 1, 10), "A compatible version of Rewire is required")
local L = AB:locale()
local mark = {}

local function icmp(a,b)
	return strcmputf8i(a,b) < 1
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
		local cid = C_ClassTalents.GetActiveConfigID()
		if not cid then
			local spec = GetSpecializationInfo(GetSpecialization())
			local cc = C_ClassTalents.GetConfigIDsBySpecID(spec)
			cid = cc and cc[1]
		end
		local conf = cid and C_Traits.GetConfigInfo(cid)
		local tree = conf and conf.treeIDs and conf.treeIDs[1]
		local nodes = tree and C_Traits.GetTreeNodes(tree)
		for i=1,nodes and #nodes or 0 do
			local node = C_Traits.GetNodeInfo(cid, nodes[i])
			local activeEID = node.activeEntry and node.activeEntry.entryID
			for i=1, #node.entryIDs do
				local eid = node.entryIDs[i]
				if knownFilter == (eid == activeEID) then
					local entry = C_Traits.GetEntryInfo(cid, eid)
					local def = entry and C_Traits.GetDefinitionInfo(entry.definitionID)
					local sid = def and def.spellID and not IsPassiveSpell(def.spellID) and def.spellID
					if sid and not mark[sid] then
						mark[sid] = 1
						add("spell", sid)
					end
				end
			end
		end
	end
	local function addSpells(add, knownFilter)
		local asv = not MODERN and GetCVar("showAllSpellRanks")
		if asv and asv ~= "1" then
			SetCVar("showAllSpellRanks", "1")
		end
		for i=1,GetNumSpellTabs()+12 do
			local _, _, ofs, c, _, otherSpecID = GetSpellTabInfo(i)
			local isNotOffspec = otherSpecID == 0
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
				procSpellBookEntry(add, "petspell", true, true, pcall(GetSpellBookItemInfo, i, "pet"))
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
	local ns = MODERN_CONTAINERS and C_Container.GetContainerNumSlots or GetContainerNumSlots
	local giid = MODERN_CONTAINERS and C_Container.GetContainerItemID or GetContainerItemID
	for t=0,1 do
		t = t == 0 and GetItemSpell or IsEquippableItem
		for bag=0,4 do
			for slot=1, ns(bag) do
				local iid = giid(bag, slot)
				if iid and not mark[iid] and t(iid) then
					add("item", iid)
					mark[iid] = 1
				end
			end
		end
		for slot=INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
			local iid = GetInventoryItemID("player", slot)
			if iid and not mark[iid] and t(iid) then
				add("item", iid)
				mark[iid] = 1
			end
		end
	end
end)
if MODERN then -- Battle pets
	local running, sourceFilters, typeFilters, flagFilters, search = false, {}, {}, {[LE_PET_JOURNAL_FILTER_COLLECTED]=1, [LE_PET_JOURNAL_FILTER_NOT_COLLECTED]=1}, ""
	hooksecurefunc(C_PetJournal, "SetSearchFilter", function(filter) search = filter end)
	hooksecurefunc(C_PetJournal, "ClearSearchFilter", function() if not running then search = "" end end)
	AB:AugmentCategory(L"Battle pets", function(_, add)
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
		
		add("battlepet", "fave")
		for i=1,C_PetJournal.GetNumPets() do
			add("battlepet", (C_PetJournal.GetPetInfoByIndex(i)))
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
elseif CF_WRATH then
	AB:AugmentCategory(COMPANIONS, function(_, add)
		for i=1, GetNumCompanions("CRITTER") do
			local _, _, sid = GetCompanionInfo("CRITTER", i)
			add("spell", sid)
		end
	end)
end
if MODERN then -- Mounts
	AB:AugmentCategory(L"Mounts", function(_, add)
		if GetSpellInfo(150544) then add("spell", 150544) end
		local myFactionId = UnitFactionGroup("player") == "Horde" and 0 or 1
		local idm, i2, i2n = C_MountJournal.GetMountIDs(), {}, {}
		for i=1, #idm do
			local mid = idm[i]
			local name, sid, _3, _4, _5, _6, _7, factionLocked, factionId, hide, have = C_MountJournal.GetMountInfoByID(mid)
			if have and not hide
			   and (not factionLocked or factionId == myFactionId)
			   and RW:IsSpellCastable(sid)
			   then
				i2[#i2+1], i2n[mid] = mid, name
			end
		end
		table.sort(i2, function(a,b) return i2n[a] < i2n[b] end)
		for i=1,#i2 do
			add("mount", i2[i])
		end
	end)
elseif CF_WRATH then
	AB:AugmentCategory(L"Mounts", function(_, add)
		for i=1, GetNumCompanions("MOUNT") do
			local _, _, sid = GetCompanionInfo("MOUNT", i)
			add("spell", sid)
		end
	end)
end
AB:AugmentCategory(L"Macros", function(_, add)
	add("macrotext", "")
	local n, ni = {}, 1
	for name in RW:GetNamedMacros() do
		n[ni], ni = name, ni + 1
	end
	table.sort(n, icmp)
	for i=1,#n do
		add("macro", n[i])
	end
end)
if MODERN then -- equipmentset
	AB:AugmentCategory(L"Equipment sets", function(_, add)
		for _,id in pairs(C_EquipmentSet.GetEquipmentSetIDs()) do
			add("equipmentset", (C_EquipmentSet.GetEquipmentSetInfo(id)))
		end
	end)
end
AB:AugmentCategory(L"Raid markers", function(_, add)
	for k=0, MODERN and 1 or 0 do
		k = k == 0 and "raidmark" or "worldmark"
		for i=0,8 do
			add(k, i)
		end
	end
end)
if MODERN then -- toys
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
	if MODERN then
		AB:AddActionToCategory(L"Miscellaneous", "extrabutton", 1)
	end
	AB:AddActionToCategory(L"Miscellaneous", "macrotext", "")
end
do -- aliases
	AB:AddCategoryAlias("Miscellaneous", L"Miscellaneous")
end