local addon, L = ...
local C_Map, MapUtil, next, wipe, random, C_PetJournal, IsSpellKnown, GetTime, IsFlyableArea, IsSubmerged, GetInstanceInfo, IsIndoors, UnitInVehicle, IsMounted, InCombatLockdown, GetSpellCooldown, UnitBuff, IsUsableSpell, GetSubZoneText, SecureCmdOptionParse = C_Map, MapUtil, next, wipe, random, C_PetJournal, IsSpellKnown, GetTime, IsFlyableArea, IsSubmerged, GetInstanceInfo, IsIndoors, UnitInVehicle, IsMounted, InCombatLockdown, GetSpellCooldown, UnitBuff, IsUsableSpell, GetSubZoneText, SecureCmdOptionParse
local util = MountsJournalUtil
local mounts = CreateFrame("Frame", "MountsJournal")
util.setEventsMixin(mounts)


mounts:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
mounts:RegisterEvent("ADDON_LOADED")
mounts:RegisterEvent("PLAYER_LOGIN")
mounts:RegisterEvent("UPDATE_INVENTORY_DURABILITY")


function mounts:ADDON_LOADED(addonName)
	if addonName == addon then
		self:UnregisterEvent("ADDON_LOADED")

		local mapInfo = MapUtil.GetMapParentInfo(C_Map.GetFallbackWorldMapID(), Enum.UIMapType.Cosmic, true)
		self.defMountsListID = mapInfo and mapInfo.mapID or 946 -- WORLD

		MountsJournalDB = MountsJournalDB or {}
		self.globalDB = MountsJournalDB
		self.globalDB.mountTags = self.globalDB.mountTags or {}
		self.globalDB.filters = self.globalDB.filters or {}
		self.globalDB.defFilters = self.globalDB.defFilters or {}
		self.globalDB.config = self.globalDB.config or {}
		self.globalDB.mountAnimations = self.globalDB.mountAnimations or {}
		self.globalDB.defProfile = self.globalDB.defProfile or {}
		self.globalDB.mountsProfiles = self.globalDB.mountsProfiles or {}
		self.globalDB.holidayNames = self.globalDB.holidayNames or {}

		self.defProfile = self.globalDB.defProfile
		self:checkProfile(self.defProfile)
		self.profiles = self.globalDB.mountsProfiles
		for name, profile in next, self.profiles do
			self:checkProfile(profile)
		end
		self.filters = self.globalDB.filters
		self.defFilters = self.globalDB.defFilters
		self.config = self.globalDB.config
		if self.config.mountDescriptionToggle == nil then
			self.config.mountDescriptionToggle = true
		end
		if self.config.arrowButtonsBrowse == nil then
			self.config.arrowButtonsBrowse = true
		end
		if self.config.openHyperlinks == nil then
			self.config.openHyperlinks = true
		end
		if self.config.showWowheadLink == nil then
			self.config.showWowheadLink = true
		end
		self.config.useRepairMountsDurability = self.config.useRepairMountsDurability or 41
		self.config.useRepairFlyableDurability = self.config.useRepairFlyableDurability or 31
		self.config.summonPetEveryN = self.config.summonPetEveryN or 5
		self.config.macrosConfig = self.config.macrosConfig or {}
		for i = 1, GetNumClasses() do
			local _, className = GetClassInfo(i)
			if className then
				self.config.macrosConfig[className] = self.config.macrosConfig[className] or {}
			end
		end
		self.config.omb = self.config.omb or {}
		self.config.camera = self.config.camera or {}
		self.cameraConfig = self.config.camera
		if self.cameraConfig.xAccelerationEnabled == nil then
			self.cameraConfig.xAccelerationEnabled = true
		end
		self.cameraConfig.xInitialAcceleration = self.cameraConfig.xInitialAcceleration or .5
		self.cameraConfig.xAcceleration = self.cameraConfig.xAcceleration or -1
		self.cameraConfig.xMinAcceleration = nil
		self.cameraConfig.xMinSpeed = self.cameraConfig.xMinSpeed or 0
		if self.cameraConfig.yAccelerationEnabled == nil then
			self.cameraConfig.yAccelerationEnabled = true
		end
		self.cameraConfig.yInitialAcceleration = self.cameraConfig.yInitialAcceleration or .5
		self.cameraConfig.yAcceleration = self.cameraConfig.yAcceleration or -1
		self.cameraConfig.yMinAcceleration = nil
		self.cameraConfig.yMinSpeed = self.cameraConfig.yMinSpeed or 0

		MountsJournalChar = MountsJournalChar or {}
		self.charDB = MountsJournalChar
		self.charDB.macrosConfig = self.charDB.macrosConfig or {}
		self.charDB.profileBySpecializationPVP = self.charDB.profileBySpecializationPVP or {}
		self.charDB.holidayProfiles = self.charDB.holidayProfiles or {}

		-- Списки
		self.sFlags = {}
		self.priorityProfiles = {}
		self.list = {}
		self.empty = {}
		self.repairMounts = {
			280,
			284,
		}
		self.usableRepairMounts = {}

		-- MINIMAP BUTTON
		local ldb_icon = LibStub("LibDataBroker-1.1"):NewDataObject(addon, {
			type = "launcher",
			text = addon,
			icon = 303868,
			OnClick = function(_, button)
				if button == "LeftButton" then
					MountsJournalFrame:showToggle()
				elseif button == "RightButton" then
					MountsJournalConfig:openConfig()
				end
			end,
			OnTooltipShow = function(tooltip)
				tooltip:SetText(("%s (|cffff7f3f%s|r)"):format(addon, C_AddOns.GetAddOnMetadata(addon, "Version")))
				tooltip:AddLine("\n")
				tooltip:AddLine(L["|cffff7f3fClick|r to open %s"]:format(addon), .5, .8, .5, false)
				tooltip:AddLine(L["|cffff7f3fRight-Click|r to open Settings"], .5, .8, .5, false)
				if InCombatLockdown() then
					GameTooltip_AddErrorLine(GameTooltip, SPELL_FAILED_AFFECTING_COMBAT)
				end
			end,
		})
		LibStub("LibDBIcon-1.0"):Register(addon, ldb_icon, mounts.config.omb)

		-- Dalaran - Krasus' Landing
		local locale = GetLocale()
		if locale == "deDE" then
			self.krasusLanding = "Krasus' Landeplatz"
		elseif locale == "esES" then
			self.krasusLanding = "Alto de Krasus"
		elseif locale == "esMX" then
			self.krasusLanding = "Alto de Krasus"
		elseif locale == "frFR" then
			self.krasusLanding = "Aire de Krasus"
		elseif locale == "itIT" then
			self.krasusLanding = "Terrazza di Krasus"
		elseif locale == "koKR" then
			self.krasusLanding = "크라서스 착륙장"
		elseif locale == "ptBR" then
			self.krasusLanding = "Plataforma de Krasus"
		elseif locale == "ruRU" then
			self.krasusLanding = "Площадка Краса"
		elseif locale == "zhCN" then
			self.krasusLanding = "克拉苏斯平台"
		elseif locale == "zhTW" then
			self.krasusLanding = "卡薩斯平臺"
		else
			self.krasusLanding = "Krasus' Landing"
		end

		self:convertOldData()
	end
end


function mounts:convertOldData()
	self.convertOldData = nil
	if not self.config.journalPosX then return end
	self.config.journalPosX = nil
	self.config.journalPosY = nil
	self.globalDB.mountFavoritesList = nil
	self.globalDB.petFavoritesList = nil

	if self.config.repairSelectedMount then
		self.config.repairSelectedMount = C_MountJournal.GetMountFromSpell(self.config.repairSelectedMount)
	end

	local function spellToMount(tbl)
		local newTbl = {}
		for spellID, v in pairs(tbl) do
			local mountID = C_MountJournal.GetMountFromSpell(spellID)
			if mountID then
				newTbl[mountID] = v
			end
		end
		return newTbl
	end

	self.globalDB.mountTags = spellToMount(self.globalDB.mountTags)

	local function getPetIDFromSpellID(spellID)
		local sName = GetSpellInfo(spellID)
		for i, petID in ipairs(self.pets.list) do
			local _,_,_,_,_,_,_, name = C_PetJournal.GetPetInfoByPetID(petID)
			if name == sName then
				return petID
			end
		end
	end

	local petToUpdate = {}
	self:on("PET_LIST_UPDATE.old", function(self)
		if #self.pets.list == 0 then return end
		self:off("PET_LIST_UPDATE.old")

		for i, petForMount in ipairs(petToUpdate) do
			for spellID, v in pairs(petForMount) do
				local mountID = C_MountJournal.GetMountFromSpell(spellID)
				if mountID then
					if v == false then
						petForMount[spellID] = 1
					elseif v == true then
						petForMount[spellID] = 2
					elseif type(v) == "number" then
						petForMount[spellID] = getPetIDFromSpellID(v)
					end
				else
					petForMount[spellID] = nil
				end
			end
		end
	end)

	local function profileUpdate(profile)
		profile.fly = spellToMount(profile.fly)
		profile.ground = spellToMount(profile.ground)
		profile.swimming = spellToMount(profile.swimming)
		profile.mountsWeight = spellToMount(profile.mountsWeight)

		for map, v in pairs(profile.zoneMounts) do
			v.fly = spellToMount(v.fly)
			v.ground = spellToMount(v.ground)
			v.swimming = spellToMount(v.swimming)
		end

		petToUpdate[#petToUpdate + 1] = profile.petForMount
	end

	profileUpdate(self.defProfile)
	for name, profile in next, self.profiles do
		profileUpdate(profile)
	end
end


function mounts:checkProfile(profile)
	profile.fly = profile.fly or {}
	profile.ground = profile.ground or {}
	profile.swimming = profile.swimming or {}
	profile.zoneMounts = profile.zoneMounts or {}
	profile.petForMount = profile.petForMount or {}
	profile.mountsWeight = profile.mountsWeight or {}
end


function mounts:PLAYER_LOGIN()
	-- INIT
	self:setModifier(self.config.modifier)
	self:setUsableRepairMounts()
	self:updateProfessionsRank()
	self:init()
	self.pets:setSummonEvery()
	self.calendar:init()

	-- MAP CHANGED
	-- self:RegisterEvent("NEW_WMO_CHUNK")
	-- self:RegisterEvent("ZONE_CHANGED")
	-- self:RegisterEvent("ZONE_CHANGED_INDOORS")
	-- self:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	-- INSTANCE INFO UPDATE
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- PROFESSION CHANGED
	self:RegisterEvent("SKILL_LINES_CHANGED")

	-- MOUNT ADDED
	self:RegisterEvent("NEW_MOUNT_ADDED")
	-- self:RegisterEvent("COMPANION_UPDATE")
	-- self:RegisterEvent("COMPANION_LEARNED")
	-- self:RegisterEvent("COMPANION_UNLEARNED")

	-- PET USABLE
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")

	-- CALENDAR
	self:on("CALENDAR_UPDATE_EVENT_LIST", self.setDB)
end


do
	local durabilitySlots = {
		INVSLOT_HEAD,
		INVSLOT_SHOULDER,
		INVSLOT_CHEST,
		INVSLOT_WRIST,
		INVSLOT_HAND,
		INVSLOT_WAIST,
		INVSLOT_LEGS,
		INVSLOT_FEET,
		INVSLOT_MAINHAND,
		INVSLOT_OFFHAND,
		INVSLOT_RANGED,
	}
	function mounts:UPDATE_INVENTORY_DURABILITY()
		local percent = (tonumber(self.config.useRepairMountsDurability) or 0) / 100
		local flyablePercent = (tonumber(self.config.useRepairFlyableDurability) or 0) / 100
		self.sFlags.repair = false
		self.sFlags.flyableRepair = false
		if self.config.useRepairMounts then
			for i = 1, #durabilitySlots do
				local durCur, durMax = GetInventoryItemDurability(durabilitySlots[i])
				if durCur and durMax then
					local itemPercent = durCur / durMax
					if itemPercent < percent then
						self.sFlags.repair = true
					end
					if itemPercent < flyablePercent then
						self.sFlags.flyableRepair = true
					end
				end
			end
			if not self.config.useRepairFlyable then
				self.sFlags.flyableRepair = self.sFlags.repair
			end
		end
	end
end


function mounts:setUsableRepairMounts()
	local playerFaction = UnitFactionGroup("Player")

	wipe(self.usableRepairMounts)
	for i = 1, #self.repairMounts do
		local mountID = self.repairMounts[i]
		local _,_,_,_,_,_,_,_, mountFaction, _, isCollected = C_MountJournal.GetMountInfoByID(mountID)

		if mountFaction == 0 and playerFaction == "Horde"
		or mountFaction == 1 and playerFaction == "Alliance" then
			mounts.config.repairSelectedMount = mountID
			if isCollected then
				self.usableRepairMounts[mountID] = true
			end
			break
		end
	end
end


function mounts:PLAYER_ENTERING_WORLD()
	local _, instanceType, _,_,_,_,_, instanceID = GetInstanceInfo()
	self.instanceID = instanceID
	local pvp = instanceType == "arena" or instanceType == "pvp"
	if self.pvp ~= pvp then
		self.pvp = pvp
		self:setDB()
	end
end


function mounts:PLAYER_REGEN_DISABLED()
	self:UnregisterEvent("UNIT_SPELLCAST_START")
end


function mounts:PLAYER_REGEN_ENABLED()
	self:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
end


do
	local function summonPet(petID)
		if InCombatLockdown() then return end
		if type(petID) == "number" then
			mounts.pets:summonRandomPet(petID == 1)
		else
			mounts.pets:summon(petID)
		end
	end


	local timer
	function mounts:UNIT_SPELLCAST_START(_,_, spellID)
		local petID
		for i = 1, #self.priorityProfiles do
			petID = self.priorityProfiles[i].petForMount[spellID]
			if petID then break end
		end

		if petID then
			local groupType = util.getGroupType()
			if self.config.noPetInRaid and groupType == "raid"
			or self.config.noPetInGroup and groupType == "group"
			then return end

			if timer and not timer:IsCancelled() then
				timer:Cancel()
				timer = nil
			end

			local start, duration = GetSpellCooldown(61304)

			if duration == 0 then
				summonPet(petID)
			else
				timer = C_Timer.NewTicker(start + duration - GetTime(), function() summonPet(petID) end, 1)
			end
		end
	end
end


function mounts:NEW_MOUNT_ADDED(mountID)
	self:autoAddNewMount(mountID)
end


function mounts:updateProfessionsRank()
	local engineeringName = GetSpellInfo(4036)
	local tailoringName = GetSpellInfo(3908)

	self.engineeringRank = nil
	self.tailoringRank = nil

	for i = 1, GetNumSkillLines() do
		local skillName, _,_, skillRank = GetSkillLineInfo(i)
		if skillName == engineeringName then
			self.engineeringRank = skillRank
		elseif skillName == tailoringName then
			self.tailoringRank = skillRank
		end
	end
end
mounts.SKILL_LINES_CHANGED = mounts.updateProfessionsRank


function mounts:isCanUseFlying(mapID)
	if self.instanceID == 571 then -- Northrend
		if IsSpellKnown(54197) then
			if not mapID then mapID = MapUtil.GetDisplayableMapForPlayer() end
			if mapID ~= 126
			and (mapID ~= 125 or GetSubZoneText() == self.krasusLanding)
			then
				return true
			end
		end
		return false
	end
	return true
end


do
	local canUseMounts = {
		[219] = true, -- 48025 | Headless Horseman's Mount
		[352] = true, -- 71342 | X-45 Heartbreaker
		[363] = true, -- 72286 | Invincible
		[371] = true, -- 74856 | Blazing Hippogryph
		[376] = true, -- 75614 | Celestial Steed
		[1762] = true, -- 372677 | Kalu'ak Whalebone Glider
		[1770] = true, -- 394209 | Festering Emerald Drake
	}

	local mountsRequiringProf = {
		[204] = {"engineeringRank", 375}, -- 44151 | Turbo-Charged Flying Machine
		[205] = {"engineeringRank", 300}, -- 44153 | Flying Machine
		[279] = {"tailoringRank", 425}, -- 61309 | Magnificent Flying Carpet
		[285] = {"tailoringRank", 300}, -- 61451 | Flying Carpet
		[375] = {"tailoringRank", 425}, -- 75596 | Frosty Flying Carpet
	}

	function mounts:isUsable(mountID, mType, canUseFlying)
		local prof = mountsRequiringProf[mountID]
		if prof and (self[prof[1]] or 0) < prof[2] then return false end

		if not mType then
			local _,_,_,_, mountType = C_MountJournal.GetMountInfoExtraByID(mountID)
			mType = util.mountTypes[mountType]
		end

		if not canUseFlying then
			canUseFlying = self:isCanUseFlying()
		end

		if mType ~= 1 or canUseFlying or canUseMounts[mountID] then return true end
		return false
	end
end


function mounts:addMountToList(list, mountID)
	local _,_,_,_, mountType = C_MountJournal.GetMountInfoExtraByID(mountID)
	local mType = util.mountTypes[mountType]

	if mType == 1 then
		mType = "fly"
	elseif mType == 2 then
		mType = "ground"
	else
		mType = "swimming"
	end

	list[mType][mountID] = true
end


function mounts:autoAddNewMount(mountID)
	if self.defProfile.autoAddNewMount then
		self:addMountToList(self.defProfile, mountID)
	end

	for _, profile in next, self.profiles do
		if profile.autoAddNewMount then
			self:addMountToList(profile, mountID)
		end
	end
end


function mounts:setModifier(modifier)
	if modifier == "NONE" then
		self.config.modifier = modifier
		self.modifier = function() return false end
	elseif modifier == "SHIFT" then
		self.config.modifier = modifier
		self.modifier = IsShiftKeyDown
	elseif modifier == "CTRL" then
		self.config.modifier = modifier
		self.modifier = IsControlKeyDown
	else
		self.config.modifier = "ALT"
		self.modifier = IsAltKeyDown
	end
end


function mounts:setMountsList()
	self.mapInfo = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player") or C_Map.GetFallbackWorldMapID())
	local mapInfo = self.mapInfo
	local zoneMounts = self.zoneMounts
	self.mapFlags = nil
	wipe(self.list)

	local mapInfo = self.mapInfo
	while mapInfo do
		for i = 1, #self.priorityProfiles do
			local profile, list = self.priorityProfiles[i]

			if mapInfo.mapID == self.defMountsListID then
				list = profile
			else
				local zoneMounts = profile.zoneMountsFromProfile and self.defProfile.zoneMounts or profile.zoneMounts
				list = zoneMounts[mapInfo.mapID]

				if list and not self.mapFlags and list.flags.enableFlags then
					self.mapFlags = list.flags
				end
			end

			if list then
				if not (self.list.fly and self.list.ground and self.list.swimming) then
					while list and list.listFromID do
						if list.listFromID == self.defMountsListID then
							list = profile
						else
							list = zoneMounts[list.listFromID]
						end
					end
					if list then
						if not self.list.fly and next(list.fly) then
							self.list.fly = list.fly
							self.list.flyWeight = profile.mountsWeight
						end
						if not self.list.ground and next(list.ground) then
							self.list.ground = list.ground
							self.list.groundWeight = profile.mountsWeight
						end
						if not self.list.swimming and next(list.swimming) then
							self.list.swimming = list.swimming
							self.list.swimmingWeight = profile.mountsWeight
						end
					end
				elseif self.mapFlags then return end
			end
		end

		if mapInfo.parentMapID == 0 and mapInfo.mapID ~= self.defMountsListID then
			mapInfo = C_Map.GetMapInfo(self.defMountsListID)
		else
			mapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
		end
	end

	if not self.list.fly then self.list.fly = self.empty end
	if not self.list.ground then self.list.ground = self.empty end
	if not self.list.swimming then self.list.swimming = self.empty end
end
-- mounts.NEW_WMO_CHUNK = mounts.setMountsList
-- mounts.ZONE_CHANGED = mounts.setMountsList
-- mounts.ZONE_CHANGED_INDOORS = mounts.setMountsList
-- mounts.ZONE_CHANGED_NEW_AREA = mounts.setMountsList


function mounts:setDB()
	profileName = self.charDB.profileBySpecializationPVP[1]
	if profileName and not self.profiles[profileName] then
		self.charDB.profileBySpecializationPVP[1] = nil
	end

	if self.charDB.currentProfileName and not self.profiles[self.charDB.currentProfileName] then
		self.charDB.currentProfileName = nil
	end

	local profileName
	wipe(self.priorityProfiles)

	if self.pvp and self.charDB.profileBySpecializationPVP.enable then
		profileName = self.charDB.profileBySpecializationPVP[1]
		self.priorityProfiles[1] = self.profiles[profileName] or self.defProfile
	end

	local holidayProfiles = self.calendar:getHolidayProfileNames()
	for i = 1, #holidayProfiles do
		self.priorityProfiles[#self.priorityProfiles + 1] = self.profiles[holidayProfiles[i].profileName] or self.defProfile
	end

	profileName = self.charDB.currentProfileName
	self.db = self.profiles[profileName] or self.defProfile
	self.priorityProfiles[#self.priorityProfiles + 1] = self.db
end
mounts.PLAYER_SPECIALIZATION_CHANGED = mounts.setDB


function mounts:getTargetMount()
	if self.config.copyMountTarget then
		local i = 1
		repeat
			local _,_,_,_,_,_,_,_,_, spellID = UnitBuff("target", i)
			if spellID then
				local mountID = C_MountJournal.GetMountFromSpell(spellID)
				if mountID then
					local _, spellID, _,_, isUsable = C_MountJournal.GetMountInfoByID(mountID)
					if isUsable and IsUsableSpell(spellID) then
						return self:isUsable(spellID, nil ,self.sFlags.canUseFlying) and mountID
					end
					break
				end
				i = i + 1
			end
		until not spellID
	end
end


do
	local usableIDs = {}
	function mounts:summon(ids, mountsWeight)
		local weight, canUseFlying = 0, self.sFlags.canUseFlying
		for mountID in next, ids do
			local _, spellID, _,_, isUsable = C_MountJournal.GetMountInfoByID(mountID)
			if isUsable and IsUsableSpell(spellID) and self:isUsable(mountID, nil, canUseFlying) then
				weight = weight + (mountsWeight[mountID] or 100)
				usableIDs[weight] = mountID
			end
		end
		if weight > 0 then
			for i = random(weight), weight do
				if usableIDs[i] then
					C_MountJournal.SummonByID(usableIDs[i])
					break
				end
			end
			wipe(usableIDs)
			return true
		else
			return false
		end
	end
end


function mounts:isWaterWalkLocation()
	return self.mapFlags and self.mapFlags.waterWalkOnly or false
end


function mounts:setFlags()
	self:setMountsList()
	local flags = self.sFlags
	local modifier = self.modifier() or flags.forceModifier
	local isFlyableLocation = IsFlyableArea()
	                          and not (self.mapFlags and self.mapFlags.groundOnly)

	flags.isSubmerged = IsSubmerged()
	flags.isIndoors = IsIndoors()
	flags.inVehicle = UnitInVehicle("player")
	flags.isMounted = IsMounted()
	flags.swimming = flags.isSubmerged
	                 and not modifier
	flags.canUseFlying = self:isCanUseFlying(self.mapInfo.mapID)
	flags.fly = isFlyableLocation
	            and flags.canUseFlying
	            and (not modifier or flags.isSubmerged)
	flags.waterWalk = not isFlyableLocation and modifier
	                  or self:isWaterWalkLocation()
	flags.targetMount = self:getTargetMount()
end


function mounts:errorSummon()
	UIErrorsFrame:AddMessage(InCombatLockdown() and SPELL_FAILED_AFFECTING_COMBAT or ERR_MOUNT_NO_FAVORITES, 1, .1, .1, 1)
end


function mounts:init()
	SLASH_MOUNTSJOURNAL1 = "/mount"
	SlashCmdList["MOUNTSJOURNAL"] = function(msg)
		local flags = self.sFlags
		if msg ~= "doNotSetFlags" then
			if not SecureCmdOptionParse(msg) then return end
			flags.forceModifier = nil
			self:setFlags()
		end
		if flags.inVehicle then
			VehicleExit()
		elseif flags.isMounted then
			Dismount()
		-- repair mounts
		elseif not ((flags.repair and not flags.fly or flags.flyableRepair and flags.fly) and self:summon(self.usableRepairMounts, self.db.mountsWeight))
		-- target's mount
		and not (flags.targetMount and (C_MountJournal.SummonByID(flags.targetMount) or true))
		-- swimming
		and not (flags.swimming and self:summon(self.list.swimming, self.list.swimmingWeight))
		-- fly
		and not (flags.fly and self:summon(self.list.fly, self.list.flyWeight))
		-- ground
		and not self:summon(self.list.ground, self.list.groundWeight)
		and not self:summon(self.list.fly, self.list.flyWeight)
		then
			self:errorSummon()
		end
	end
end