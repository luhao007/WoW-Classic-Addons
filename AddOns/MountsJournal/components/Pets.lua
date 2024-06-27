local random, C_PetJournal, UnitBuff, C_Timer, wipe, InCombatLockdown, IsFlying, IsMounted, UnitHasVehicleUI, UnitCastingInfo, UnitChannelInfo, IsStealthed, UnitIsGhost, GetSpellCooldown, UnitIsAFK, DoEmote = random, C_PetJournal, UnitBuff, C_Timer, wipe, InCombatLockdown, IsFlying, IsMounted, UnitHasVehicleUI, UnitCastingInfo, UnitChannelInfo, IsStealthed, UnitIsGhost, GetSpellCooldown, UnitIsAFK, DoEmote
local mounts, util = MountsJournal, MountsJournalUtil
local pets = CreateFrame("FRAME")
mounts.pets = pets
util.setEventsMixin(pets)


pets.petJournalFiltersBackup = {
	types = {},
	sources = {},
	search = "",
}
pets.list = {}
pets.favoritesList = {}


hooksecurefunc(C_PetJournal, "SetSearchFilter", function(search)
	if not pets.updatingList then
		pets.petJournalFiltersBackup.search = search or ""
	end
end)
hooksecurefunc(C_PetJournal, "ClearSearchFilter", function()
	if not pets.updatingList then
		pets.petJournalFiltersBackup.search = ""
	end
end)
hooksecurefunc(C_PetJournal, "SetFavorite", function(petID, value)
	pets:updateList(true)
end)


pets:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
pets:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
pets:RegisterEvent("UI_ERROR_MESSAGE")


function pets:summon(petID)
	if C_PetJournal.PetIsSummonable(petID) and not C_PetJournal.IsCurrentlySummoned(petID) then
		C_PetJournal.SummonPetByGUID(petID)
	end
end


function pets:summonRandomPet(isFavorite)
	local list = isFavorite and self.favoritesList or self.list
	local num = #list

	if num < 1 then return
	elseif num == 1 then self:summon(list[1])
	else
		local petID = list[random(num)]

		if C_PetJournal.IsCurrentlySummoned(petID) then
			local newPetID = list[random(num - 1)]
			petID = newPetID == petID and list[num] or newPetID
		end

		self:summon(petID)
	end
end


function pets:dismissPet()
	for i = 1, #self.list do
		local petID = self.list[i]
		if C_PetJournal.IsCurrentlySummoned(petID) then
			C_PetJournal.DismissSummonedPet(petID)
			break
		end
	end
end


do
	local aurasList = {
		[3680] = true, -- Lesser Invisibility
		[11392] = true, -- Invisibility Potion
		[32612] = true, -- Invisibility
	}

	local function isAuraApplied()
		for i = 1, 255 do
			local _,_,_,_,_,_,_,_,_, spellID = UnitBuff("player", i)
			if not spellID then return end
			if aurasList[spellID] then return true end
		end
	end

	function pets:summonByTimer()
		local groupType = util.getGroupType()
		if mounts.config.noPetInRaid and groupType == "raid"
		or mounts.config.noPetInGroup and groupType == "group"
		then return end

		if InCombatLockdown() then
			self:stopTicker()
			self:UnregisterEvent("PLAYER_STARTED_MOVING")
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		elseif IsFlying()
			or IsMounted()
			or UnitHasVehicleUI("player")
			or UnitCastingInfo("player")
			or UnitChannelInfo("player")
			or IsStealthed()
			or UnitIsGhost("player")
			or GetSpellCooldown(61304) ~= 0
			or isAuraApplied()
		then
			self:stopTicker()
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_STARTED_MOVING")
		else
			self:UnregisterEvent("PLAYER_STARTED_MOVING")
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			if UnitIsAFK("player") then DoEmote("STAND") end
			self:summonRandomPet(mounts.config.summonPetOnlyFavorites)
			if not self.ticker then self:setSummonEvery() end
		end
	end
	pets.PLAYER_STARTED_MOVING = pets.summonByTimer
	pets.PLAYER_REGEN_ENABLED = pets.summonByTimer
end


function pets:UI_ERROR_MESSAGE(errType, message)
	if errType == 51
	and message == SPELL_FAILED_NOT_STANDING
	and self.ticker
	and not self.ticker:IsCancelled()
	then
		self:stopTicker()
		self:RegisterEvent("PLAYER_STARTED_MOVING")
	end
end


function pets:stopTicker()
	if self.ticker and not self.ticker:IsCancelled() then
		self.ticker:Cancel()
		self.ticker = nil
	end
end


function pets:setSummonEvery()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterEvent("PLAYER_STARTED_MOVING")

	if mounts.config.summonPetEvery then
		local timer = 60 * (tonumber(mounts.config.summonPetEveryN) or 1)
		if self.timer == timer and self.ticker then return end
		self.timer = timer
		self:stopTicker()
		self.ticker = C_Timer.NewTicker(timer, function() self:summonByTimer() end)
	else
		self:stopTicker()
	end
end


function pets:setPetJournalFiltersBackup()
	local backup = self.petJournalFiltersBackup
	backup.collected = C_PetJournal.IsFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED)
	backup.notCollected = C_PetJournal.IsFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED)
	-- backup.allTypes = true
	-- for i = 1, C_PetJournal.GetNumPetTypes() do
	-- 	backup.types[i] = C_PetJournal.IsPetTypeChecked(i)
	-- 	if not backup.types[i] then backup.allTypes = false end
	-- end
	-- backup.allSources = true
	-- for i = 1, C_PetJournal.GetNumPetSources() do
	-- 	backup.sources[i] = C_PetJournal.IsPetSourceChecked(i)
	-- 	if not backup.sources[i] then backup.allSources = false end
	-- end

	if not backup.collected then
		C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, true)
	end
	if not backup.notCollected then
		C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, true)
	end
	-- if not backup.allTypes then
	-- 	C_PetJournal.SetAllPetTypesChecked(true)
	-- end
	-- if not backup.allSources then
	-- 	C_PetJournal.SetAllPetSourcesChecked(true)
	-- end
	if backup.search ~= "" then
		C_PetJournal.ClearSearchFilter()
	end
end


function pets:restorePetJournalFilters()
	local backup = self.petJournalFiltersBackup
	if not backup.collected then
		C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, backup.collected)
	end
	if not backup.notCollected then
		C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, backup.notCollected)
	end
	-- if not backup.allTypes then
	-- 	for i = 1, C_PetJournal.GetNumPetTypes() do
	-- 		if not backup.types[i] then
	-- 			C_PetJournal.SetPetTypeFilter(i, backup.types[i])
	-- 		end
	-- 	end
	-- end
	-- if not backup.allSources then
	-- 	for i = 1, C_PetJournal.GetNumPetSources() do
	-- 		if not backup.sources[i] then
	-- 			C_PetJournal.SetPetSourceChecked(i, backup.sources[i])
	-- 		end
	-- 	end
	-- end
	if backup.search ~= "" then
		C_PetJournal.SetSearchFilter(backup.search)
	end
end


function pets:updateList(force)
	local _, owned = C_PetJournal.GetNumPets()
	if #self.list ~= owned or force then
		self.updatingList = true
		self:setPetJournalFiltersBackup()

		local GetPetInfoByIndex = C_PetJournal.GetPetInfoByIndex
		wipe(self.list)
		wipe(self.favoritesList)
		for i = 1, owned do
			local petID, _,_,_,_, favorite = GetPetInfoByIndex(i)
			if petID then
				self.list[#self.list + 1] = petID
				if favorite then
					self.favoritesList[#self.favoritesList + 1] = petID
				end
			end
		end

		self:restorePetJournalFilters()
		self.updatingList = nil
	end

	self:event("PET_LIST_UPDATE")
end
pets.PET_JOURNAL_LIST_UPDATE = pets.updateList


SLASH_MOUNTSJOURNALRANDOMPET1 = "/randompet"
SlashCmdList["MOUNTSJOURNALRANDOMPET"] = function() pets:summonRandomPet() end


SLASH_MOUNTSJOURNALRANDOMFAVORITEPET1 = "/randomfavoritepet"
SlashCmdList["MOUNTSJOURNALRANDOMFAVORITEPET"] = function() pets:summonRandomPet(true) end


SLASH_MOUNTSJOURNALDISMISSPET1 = "/dismisspet"
SlashCmdList["MOUNTSJOURNALDISMISSPET"] = function() pets:dismissPet() end