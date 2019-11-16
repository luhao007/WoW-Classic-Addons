local _, T = ...
if T.SkipLocalActionBook then return end
local MODERN = select(4,GetBuildInfo()) >= 8e4
local AB, mark = assert(T.ActionBook:compatible(2, 21), "A compatible version of ActionBook is required"), {}
local RW = assert(T.ActionBook:compatible("Rewire", 1, 10), "A compatible version of Rewire is required")
local L = AB:locale()

local function icmp(a,b)
	return strcmputf8i(a,b) < 1
end

do -- spellbook
	local function addEntry(add, at, _ok, st, sid)
		if st == "SPELL" and not IsPassiveSpell(sid) and not mark[sid] then
			mark[sid] = 1
			add(at, sid)
		elseif st == "FLYOUT" then
			for j=1,select(3,GetFlyoutInfo(sid)) do
				local asid, _osid, ik = GetFlyoutSlotInfo(sid, j)
				if ik then
					addEntry(add, at, true, "SPELL", asid)
				end
			end
		end
	end
	AB:AugmentCategory(L"Abilities", function(_, add)
		wipe(mark)
		if UnitLevel("player") >= 90 and GetExpansionLevel() >= 5 then
			add("spell", 161691)
		end
		for i=1,GetNumSpellTabs()+12 do
			local _, _, ofs, c, _, sid = GetSpellTabInfo(i)
			for j=ofs+1,sid == 0 and (ofs+c) or 0 do
				addEntry(add, "spell", pcall(GetSpellBookItemInfo, j, "spell"))
			end
		end
		wipe(mark)
		for i=1,MODERN and 4 or 0 do
			local id = C_SpecializationInfo.GetPvpTalentSlotInfo(i)
			id = id and id.selectedTalentID
			if id then
				local sid = select(6, GetPvpTalentInfoByID(id))
				if sid and not IsPassiveSpell(sid) then
					add("spell", sid)
				end
			end
		end
	end)
	local _, cl = UnitClass("player")
	if cl == "HUNTER" or cl == "WARLOCK" or MODERN and cl == "MAGE" then
		AB:AugmentCategory(L"Pet abilities", function(_, add)
		if not PetHasSpellbook() then return end
		wipe(mark)
		for i=1,HasPetSpells() or 0 do
			if MODERN then
				addEntry(add, "petspell", pcall(GetSpellBookItemInfo, i, "pet"))
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
	for t=0,1 do
		t = t == 0 and GetItemSpell or IsEquippableItem
		for bag=0,4 do
			for slot=1,GetContainerNumSlots(bag) do
				local iid = GetContainerItemID(bag, slot)
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
	local tx, search, push, pop = C_ToyBox
	hooksecurefunc(C_ToyBox, "SetFilterString", function(s) search = s end) -- No corresponding Get
	local fs, fc, fu, fsearch = {}
	function push()
		local ns = C_PetJournal.GetNumPetSources()
		fsearch = search, tx.SetFilterString("")
		fc = tx.GetCollectedShown(), tx.SetCollectedShown(true)
		fu = tx.GetUncollectedShown(), tx.SetUncollectedShown(false)
		for i=1,ns do
			fs[i] = tx.IsSourceTypeFilterChecked(i)
		end
		tx.SetAllSourceTypeFilters(true)
		tx.ForceToyRefilter()
	end
	function pop()
		local ns = C_PetJournal.GetNumPetSources()
		tx.SetFilterString(fsearch or "")
		tx.SetCollectedShown(fc)
		tx.SetUncollectedShown(fu)
		for i=1,ns do
			tx.SetSourceTypeFilter(i, not fs[i])
		end
		tx.ForceToyRefilter()
	end
	AB:AugmentCategory(L"Toys", function(_, add)
		push()
		for i=1,C_ToyBox.GetNumFilteredToys() do
			local iid = C_ToyBox.GetToyFromIndex(i)
			if iid > 0 and PlayerHasToy(iid) then
				add("toy", iid)
			end
		end
		pop()
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