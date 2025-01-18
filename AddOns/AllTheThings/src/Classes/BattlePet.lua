
-- BattlePet Class (maybe this should move to a MoP Expansion file?)
local _, app = ...

-- Globals
local wipe, setmetatable, rawget, select
	= wipe, setmetatable, rawget, select

-- WoW API Cache
local GetItemInfo = app.WOWAPI.GetItemInfo;

-- Module

-- App

-- BattlePet Lib / Species Lib
do
	local KEY, CACHE = "speciesID", "BattlePets"
	local CLASSNAME = "BattlePet"
	if C_PetBattles then

		local C_PetBattles_GetAbilityInfoByID,C_PetJournal_GetNumCollectedInfo,C_PetJournal_GetPetInfoByPetID,C_PetJournal_GetPetInfoBySpeciesID,C_PetJournal_GetPetInfoByIndex,C_PetJournal_GetNumPets
			= C_PetBattles.GetAbilityInfoByID,C_PetJournal.GetNumCollectedInfo,C_PetJournal.GetPetInfoByPetID,C_PetJournal.GetPetInfoBySpeciesID,C_PetJournal.GetPetInfoByIndex,C_PetJournal.GetNumPets

		local cache = app.CreateCache(KEY);
		local function CacheInfo(t, field)
			local _t, id = cache.GetCached(t);
			-- speciesName, speciesIcon, petType, companionID, tooltipSource, tooltipDescription, isWild,
			-- canBattle, isTradeable, isUnique, obtainable, creatureDisplayID = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
			local speciesName, speciesIcon, petType, _, _, tooltipDescription, _, _, _, _, _, creatureDisplayID = C_PetJournal_GetPetInfoBySpeciesID(id);
			if speciesName and speciesIcon and petType and tooltipDescription and creatureDisplayID then
				_t.name = speciesName;
				_t.icon = speciesIcon;
				_t.petTypeID = petType;
				_t.lore = tooltipDescription;
				_t.displayID = creatureDisplayID;
				if not t.itemID or not t.link then
					_t.text = "|cff0070dd"..speciesName.."|r";
				end
			else
				_t.name = UNKNOWN;
				if not t.itemID or not t.link then
					_t.text = "|cff0070dd"..UNKNOWN.."|r";
				end
			end
			if field then return _t[field]; end
		end
		local function default_link(t)
			if t.itemID then
				local name, link, quality, _, _, _, _, _, _, icon, _, _, _, b = GetItemInfo(t.itemID);
				if link then
					--[[ -- Debug Prints
					local _t, id = cache.GetCached(t);
					print("rawset item info",id,link,name,quality,b)
					--]]
					t = cache.GetCached(t);
					t.link = link;
					t.q = quality;
					if not t.name then
						t.name = name
					end
					if not t.icon then
						t.icon = icon
					end
					if quality > 6 then
						-- heirlooms return as 1 but are technically BoE for our concern
						t.b = 2;
					else
						t.b = b;
					end
					return link;
				end
			end
		end
		local function default_costCollectibles(t)
			local id = t.itemID
			if not id then return app.EmptyTable end
			local results = app.GetRawField("itemIDAsCost", id);
			if results and #results > 0 then
				-- not sure we need to copy these into another table
				-- app.PrintDebug("default_costCollectibles",id,#results,app:SearchLink(t))
				return results;
			end
			return app.EmptyTable;
		end
		-- Returns how many of a given speciesID are currently collected
		local CollectedSpeciesHelper = setmetatable({}, {
			__index = function(t, key)
				if key and key > 0 then
					local num = C_PetJournal_GetNumCollectedInfo(key)
					if not num then
						app.PrintDebug("SpeciesID " .. key .. " was not found.")
						num = 0
					end
					t[key] = num
					return num
				end
				return 0
			end
		});
		local PetIDSpeciesIDHelper = setmetatable({}, {
			-- this metafunction seems to never be utilized... but guess it can stay for now
			__index = function(t, key)
				-- PetID are strings
				local speciesID = C_PetJournal_GetPetInfoByPetID(key);
				if speciesID then
					CollectedSpeciesHelper[speciesID] = 1;
					t[key] = speciesID;
				end
				return speciesID;
			end
		});

		app.CreateSpecies = app.CreateClass(CLASSNAME, KEY, {
			CACHE = function() return CACHE end,
			collectible = function(t) return app.Settings.Collectibles[CACHE]; end,
			collected = function(t)
				-- certain Battle Pets are per Character, so we can implicitly check for them as Account-Wide since Battle Pets have no toggle for that
				-- account-wide collected
				return app.TypicalAccountCollected(CACHE, t[KEY])
			end,
			saved = function(t)
				local saved = CollectedSpeciesHelper[t[KEY]] > 0
				-- weird bug where ATT fails to scan battle pets,
				-- can manually make it collected when checking the saved state (i.e. displayed in a row)
				-- character collected
				if saved then
					if not t.collected then
						app.SetThingCollected(KEY, t[KEY], true, true)
					end
					return 1
				end
			end,
			costCollectibles = function(t)
				return cache.GetCachedField(t, "costCollectibles", default_costCollectibles);
			end,
			f = function(t)
				return 101;
			end,
			text = function(t)
				return t.link or cache.GetCachedField(t, "text", CacheInfo);
			end,
			icon = function(t)
				return cache.GetCachedField(t, "icon", CacheInfo);
			end,
			lore = function(t)
				return cache.GetCachedField(t, "lore", CacheInfo);
			end,
			displayID = function(t)
				return cache.GetCachedField(t, "displayID", CacheInfo);
			end,
			petTypeID = function(t)
				return cache.GetCachedField(t, "petTypeID", CacheInfo);
			end,
			name = function(t)
				return cache.GetCachedField(t, "name", CacheInfo);
			end,
			link = function(t)
				return cache.GetCachedField(t, "link", default_link);
			end,
			b = function(t)
				return cache.GetCachedField(t, "b");
			end,
			tsm = function(t)
				return ("p:%d:1:3"):format(t.speciesID);
			end,
		});

		local function RefreshBattlePets()
			-- app.PrintDebug("RCBP",C_PetJournal_GetNumPets())
			local totalPets, ownedPets = C_PetJournal_GetNumPets()
			-- managed to replicate strange situation where Battle Pets is returned as having 1 Total Pet
			-- and all API calls return nil when checking
			if not totalPets or totalPets == 1 then
				-- app.PrintDebug("RCBP.Callback")
				-- try to load the Blizzard_Collections addon so that the Battle Pet APIs work properly
				-- this doesn't seem to work to load the addon....
				-- app.WOWAPI.LoadAddon("Blizzard_Collections")
				-- app.CallbackHandlers.Callback(RefreshBattlePets)
				return
			end

			wipe(CollectedSpeciesHelper)
			local petID, speciesID
			ownedPets = ownedPets or totalPets
			for i=1,ownedPets do
				petID, speciesID = C_PetJournal_GetPetInfoByIndex(i)
				-- app.PrintDebug("RCBP.ID",i,petID,speciesID)
				if petID then
					PetIDSpeciesIDHelper[petID] = speciesID
				end
				-- placeholder assignment for metatable
				petID = CollectedSpeciesHelper[speciesID]
			end
			-- Cache all ids which are known
			app.SetBatchAccountCached(CACHE, CollectedSpeciesHelper, 1)
			-- app.PrintDebug("RCBP-Done")
		end
		app.AddEventHandler("OnRefreshCollections", RefreshBattlePets)
		app.AddEventHandler("OnSavedVariablesAvailable", function(currentCharacter, accountWideData)
			if not currentCharacter[CACHE] then currentCharacter[CACHE] = {} end
			if not accountWideData[CACHE] then accountWideData[CACHE] = {} end
		end)
		-- at some point speciesID began to be included in the Event payload, huzzah!
		app.AddEventRegistration("NEW_PET_ADDED", function(petID, speciesID)
			local speciesID = speciesID or C_PetJournal_GetPetInfoByPetID(petID)
			PetIDSpeciesIDHelper[petID] = speciesID
			-- app.PrintDebug("NEW_PET_ADDED", petID, speciesID)

			if speciesID then
				CollectedSpeciesHelper[speciesID] = nil
				-- if the CollectedSpeciesHelper is exactly 1, then this is newly collected
				if CollectedSpeciesHelper[speciesID] == 1 then
					app.SetThingCollected(KEY, speciesID, true, true)
				end
			end
		end)
		-- at some point speciesID began to be included in the Event payload, huzzah!
		app.AddEventRegistration("PET_JOURNAL_PET_DELETED", function(petID, speciesID)
			local speciesID = speciesID or PetIDSpeciesIDHelper[petID];
			-- app.PrintDebug("PET_JOURNAL_PET_DELETED",petID,speciesID);

			if speciesID then
				CollectedSpeciesHelper[speciesID] = nil
				-- if the CollectedSpeciesHelper is exactly 0, then this is now removed
				if CollectedSpeciesHelper[speciesID] == 0 then
					-- app.PrintDebug("Pet Missing",speciesID);
					app.SetThingCollected(KEY, speciesID, true)
				end
			end
		end)
		app.AddSimpleCollectibleSwap(CLASSNAME, CACHE)

		app.CreatePetAbility = app.CreateClass("PetAbility", "petAbilityID", {
			["text"] = function(t)
				return select(2, C_PetBattles_GetAbilityInfoByID(t.petAbilityID));
			end,
			["icon"] = function(t)
				return select(3, C_PetBattles_GetAbilityInfoByID(t.petAbilityID));
			end,
			["description"] = function(t)
				return select(5, C_PetBattles_GetAbilityInfoByID(t.petAbilityID));
			end,
		})

		app.CreatePetType = app.CreateClass("PetType", "petTypeID", {
			["text"] = function(t)
				return _G["BATTLE_PET_NAME_" .. t.petTypeID];
			end,
			["icon"] = function(t)
				return app.asset("Icon_PetFamily_"..PET_TYPE_SUFFIX[t.petTypeID]);
			end,
			["filterID"] = function(t)
				return 101;
			end,
		})
	else
		app.CreateSpecies = app.CreateUnimplementedClass("BattlePet", KEY);
		app.CreatePetAbility = app.CreateUnimplementedClass("PetAbility", "petAbilityID");
		app.CreatePetType = app.CreateUnimplementedClass("PetType", "petTypeID");
	end
end