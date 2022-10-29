-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ProfessionScanner = TSM.Crafting:NewPackage("ProfessionScanner")
local ProfessionInfo = TSM.Include("Data.ProfessionInfo")
local CraftString = TSM.Include("Util.CraftString")
local Database = TSM.Include("Util.Database")
local Event = TSM.Include("Util.Event")
local Delay = TSM.Include("Util.Delay")
local TempTable = TSM.Include("Util.TempTable")
local Math = TSM.Include("Util.Math")
local Log = TSM.Include("Util.Log")
local String = TSM.Include("Util.String")
local ItemString = TSM.Include("Util.ItemString")
local ItemInfo = TSM.Include("Service.ItemInfo")
local private = {
	db = nil,
	hasScanned = false,
	callbacks = {},
	disabled = false,
	ignoreUpdatesUntil = 0,
	categorySkillLevelCache = { lastUpdate = 0 },
	recipeInfoCache = {},
	prevScannedHash = nil,
}
-- don't want to scan a bunch of times when the profession first loads so add a 10 frame debounce to update events
local SCAN_DEBOUNCE_FRAMES = 10
local MAX_CRAFT_LEVEL = 4



-- ============================================================================
-- Module Functions
-- ============================================================================

function ProfessionScanner.OnInitialize()
	if not TSM.IsWowClassic() then
		private.db = Database.NewSchema("CRAFTING_RECIPES")
			:AddUniqueStringField("craftString")
			:AddNumberField("index")
			:AddStringField("name")
			:AddNumberField("categoryId")
			:AddNumberField("difficulty")
			:AddNumberField("rank")
			:AddNumberField("numSkillUps")
			:AddNumberField("level")
			:AddNumberField("currentExp")
			:AddNumberField("nextExp")
			:AddNumberField("stepExp")
			:Commit()
	else
		private.db = Database.NewSchema("CRAFTING_RECIPES")
			:AddUniqueStringField("craftString")
			:AddNumberField("index")
			:AddStringField("name")
			:AddNumberField("categoryId")
			:AddStringField("difficulty")
			:AddNumberField("rank")
			:AddNumberField("numSkillUps")
			:AddNumberField("level")
			:AddNumberField("currentExp")
			:AddNumberField("nextExp")
			:AddNumberField("stepExp")
			:Commit()
	end
	TSM.Crafting.ProfessionState.RegisterUpdateCallback(private.ProfessionStateUpdate)
	if TSM.IsWowClassic() then
		Event.Register("CRAFT_UPDATE", private.OnTradeSkillUpdateEvent)
		Event.Register("TRADE_SKILL_UPDATE", private.OnTradeSkillUpdateEvent)
	else
		Event.Register("TRADE_SKILL_LIST_UPDATE", private.OnTradeSkillUpdateEvent)
	end
	Event.Register("CHAT_MSG_SKILL", private.ChatMsgSkillEventHandler)
end

function ProfessionScanner.SetDisabled(disabled)
	if private.disabled == disabled then
		return
	end
	private.disabled = disabled
	if not disabled then
		private.ScanProfession()
	end
end

function ProfessionScanner.HasScanned()
	return private.hasScanned
end

function ProfessionScanner.HasSkills()
	return private.hasScanned and private.db:GetNumRows() > 0
end

function ProfessionScanner.RegisterHasScannedCallback(callback)
	tinsert(private.callbacks, callback)
end

function ProfessionScanner.IgnoreNextProfessionUpdates()
	private.ignoreUpdatesUntil = GetTime() + 1
end

function ProfessionScanner.CreateQuery()
	return private.db:NewQuery()
end

function ProfessionScanner.GetIndexByCraftString(craftString)
	assert(TSM.IsWowClassic() or private.hasScanned)
	return private.db:GetUniqueRowField("craftString", craftString, "index")
end

function ProfessionScanner.GetCategoryIdByCraftString(craftString)
	assert(private.hasScanned)
	return private.db:GetUniqueRowField("craftString", craftString, "categoryId")
end

function ProfessionScanner.GetNameByCraftString(craftString)
	assert(private.hasScanned)
	return private.db:GetUniqueRowField("craftString", craftString, "name")
end

function ProfessionScanner.GetCurrentExpByCraftString(craftString)
	assert(private.hasScanned)
	return private.db:GetUniqueRowField("craftString", craftString, "currentExp")
end

function ProfessionScanner.GetNextExpByCraftString(craftString)
	assert(private.hasScanned)
	return private.db:GetUniqueRowField("craftString", craftString, "nextExp")
end

function ProfessionScanner.GetStepExpByCraftString(craftString)
	assert(private.hasScanned)
	return private.db:GetUniqueRowField("craftString", craftString, "stepExp")
end

function ProfessionScanner.GetDifficultyByCraftString(craftString)
	assert(private.hasScanned)
	return private.db:GetUniqueRowField("craftString", craftString, "difficulty")
end

function ProfessionScanner.GetFirstCraftString()
	if not private.hasScanned then
		return
	end
	return private.db:NewQuery()
		:Select("craftString")
		:OrderBy("index", true)
		:Equal("level", 1)
		:GetFirstResultAndRelease()
end

function ProfessionScanner.HasCraftString(craftString)
	return private.hasScanned and private.db:HasUniqueRow("craftString", craftString)
end



-- ============================================================================
-- Event Handlers
-- ============================================================================

function private.ProfessionStateUpdate()
	private.hasScanned = false
	for _, callback in ipairs(private.callbacks) do
		callback()
	end
	if TSM.Crafting.ProfessionState.GetCurrentProfession() then
		private.db:Truncate()
		private.prevScannedHash = nil
		private.OnTradeSkillUpdateEvent()
	else
		Delay.Cancel("PROFESSION_SCAN_DELAY")
	end
end

function private.OnTradeSkillUpdateEvent()
	Delay.Cancel("PROFESSION_SCAN_DELAY")
	private.QueueProfessionScan()
end

function private.ChatMsgSkillEventHandler(_, msg)
	local professionName = TSM.Crafting.ProfessionState.GetCurrentProfession()
	if not professionName or not strmatch(msg, professionName) then
		return
	end
	private.ignoreUpdatesUntil = 0
	private.QueueProfessionScan()
end



-- ============================================================================
-- Profession Scanning
-- ============================================================================

function private.QueueProfessionScan()
	Delay.AfterFrame("PROFESSION_SCAN_DELAY", SCAN_DEBOUNCE_FRAMES, private.ScanProfession)
end

function private.ScanProfession()
	if InCombatLockdown() then
		-- we are in combat, so try again in a bit
		private.QueueProfessionScan()
		return
	elseif private.disabled then
		return
	elseif GetTime() < private.ignoreUpdatesUntil then
		return
	end

	local professionName = TSM.Crafting.ProfessionState.GetCurrentProfession()
	if not professionName or not TSM.Crafting.ProfessionUtil.IsDataStable() then
		-- profession hasn't fully opened yet
		private.QueueProfessionScan()
		return
	end

	assert(professionName and TSM.Crafting.ProfessionUtil.IsDataStable())
	if TSM.IsWowClassic() then
		-- TODO: check and clear filters on classic
	else
		local hadFilter = false
		if C_TradeSkillUI.GetShowUnlearned() then
			C_TradeSkillUI.SetShowLearned(true)
			C_TradeSkillUI.SetShowUnlearned(false)
			hadFilter = true
		end
		if C_TradeSkillUI.GetOnlyShowMakeableRecipes() then
			C_TradeSkillUI.SetOnlyShowMakeableRecipes(false)
			hadFilter = true
		end
		if C_TradeSkillUI.GetOnlyShowSkillUpRecipes() then
			C_TradeSkillUI.SetOnlyShowSkillUpRecipes(false)
			hadFilter = true
		end
		if C_TradeSkillUI.AnyRecipeCategoriesFiltered() then
			C_TradeSkillUI.ClearRecipeCategoryFilter()
			hadFilter = true
		end
		if C_TradeSkillUI.AreAnyInventorySlotsFiltered() then
			C_TradeSkillUI.ClearInventorySlotFilter()
			hadFilter = true
		end
		for i = 1, C_PetJournal.GetNumPetSources() do
			if C_TradeSkillUI.IsAnyRecipeFromSource(i) and C_TradeSkillUI.IsRecipeSourceTypeFiltered(i) then
				C_TradeSkillUI.ClearRecipeSourceTypeFilter()
				hadFilter = true
				break
			end
		end
		if C_TradeSkillUI.GetRecipeItemNameFilter() ~= "" then
			C_TradeSkillUI.SetRecipeItemNameFilter(nil)
			hadFilter = true
		end
		local minItemLevel, maxItemLevel = C_TradeSkillUI.GetRecipeItemLevelFilter()
		if minItemLevel ~= 0 or maxItemLevel ~= 0 then
			C_TradeSkillUI.SetRecipeItemLevelFilter(0, 0)
			hadFilter = true
		end

		if hadFilter then
			-- an update event will be triggered
			return
		end
	end

	local scannedHash = nil
	if TSM.IsWowClassic() then
		local lastHeaderIndex = 0
		private.db:TruncateAndBulkInsertStart()
		for i = 1, TSM.Crafting.ProfessionState.IsClassicCrafting() and GetNumCrafts() or GetNumTradeSkills() do
			local name, _, skillType, hash = nil, nil, nil, nil
			if TSM.Crafting.ProfessionState.IsClassicCrafting() then
				name, _, skillType = GetCraftInfo(i)
				if skillType ~= "header" then
					hash = Math.CalculateHash(name)
					hash = Math.CalculateHash(GetCraftIcon(i), hash)
					for j = 1, GetCraftNumReagents(i) do
						local _, _, quantity = GetCraftReagentInfo(i, j)
						hash = Math.CalculateHash(ItemString.Get(GetCraftReagentItemLink(i, j)), hash)
						hash = Math.CalculateHash(quantity, hash)
					end
				end
			else
				name, skillType = GetTradeSkillInfo(i)
				if skillType ~= "header" then
					hash = Math.CalculateHash(name)
					hash = Math.CalculateHash(GetTradeSkillIcon(i), hash)
					for j = 1, GetTradeSkillNumReagents(i) do
						local _, _, quantity = GetTradeSkillReagentInfo(i, j)
						hash = Math.CalculateHash(ItemString.Get(GetTradeSkillReagentItemLink(i, j)), hash)
						hash = Math.CalculateHash(quantity, hash)
					end
				end
			end
			if skillType == "header" then
				lastHeaderIndex = i
			else
				if name then
					local craftString = CraftString.Get(hash)
					private.db:BulkInsertNewRow(craftString, i, name, lastHeaderIndex, skillType, -1, 1, 1, -1, -1, -1)
				end
			end
		end
		private.db:BulkInsertEnd()
	else
		wipe(private.recipeInfoCache)
		local prevRecipeIds = TempTable.Acquire()
		local nextRecipeIds = TempTable.Acquire()
		local recipes = TempTable.Acquire()
		assert(C_TradeSkillUI.GetFilteredRecipeIDs(recipes) == recipes)
		for index, spellId in ipairs(recipes) do
			-- There's a Blizzard bug where First Aid duplicates spellIds, so check that we haven't seen this before
			if not private.recipeInfoCache[spellId] then
				local info = C_TradeSkillUI.GetRecipeInfo(spellId)
				assert(not info.index)
				info.index = index
				if info.previousRecipeID then
					prevRecipeIds[spellId] = info.previousRecipeID
					nextRecipeIds[info.previousRecipeID] = spellId
				end
				if info.nextRecipeID then
					nextRecipeIds[spellId] = info.nextRecipeID
					prevRecipeIds[info.nextRecipeID] = spellId
				end
				private.recipeInfoCache[spellId] = info
			end
		end
		scannedHash = Math.CalculateHash(private.recipeInfoCache)
		if scannedHash == private.prevScannedHash then
			Log.Info("Hash hasn't changed, so not scanning")
			TempTable.Release(recipes)
			TempTable.Release(prevRecipeIds)
			TempTable.Release(nextRecipeIds)
			private.DoneScanning(scannedHash)
			return
		end
		private.db:TruncateAndBulkInsertStart()
		local inactiveCraftStrings = TempTable.Acquire()
		for index, spellId in ipairs(recipes) do
			local info = private.recipeInfoCache[spellId]
			local nextSpellId = nextRecipeIds[spellId]
			local hasHigherRank = nextSpellId and private.recipeInfoCache[nextSpellId] and private.recipeInfoCache[nextSpellId].learned
			local rank = -1
			if prevRecipeIds[spellId] or nextSpellId then
				rank = 1
				local tempSpellId = spellId
				while prevRecipeIds[tempSpellId] do
					rank = rank + 1
					tempSpellId = prevRecipeIds[tempSpellId]
				end
			end
			local unlockedLevel = info.unlockedRecipeLevel
			for i = 1, unlockedLevel and MAX_CRAFT_LEVEL or 1 do
				-- If there's no max level, then this recipe doesn't have levels
				local level = unlockedLevel and i or nil
				local craftString = CraftString.Get(spellId, rank, level)
				if level then
					-- Remove any old version of the spell without a level
					inactiveCraftStrings[CraftString.Get(spellId)] = true
				end
				-- TODO: show unlearned recipes in the TSM UI
				-- There's a Blizzard bug where First Aid duplicates spellIds, so check that this is the right index
				if info and info.index == index and info.learned and not hasHigherRank and (not level or level <= unlockedLevel) then
					local numSkillUps = info.relativeDifficulty == Enum.TradeskillRelativeDifficulty.Optimal and info.numSkillUps or 1
					private.db:BulkInsertNewRow(craftString, index, info.name, info.categoryID, info.relativeDifficulty, rank, numSkillUps, level or 1, info.currentRecipeExperience or -1, info.nextLevelRecipeExperience or -1, info.earnedExperience or -1)
					private.recipeInfoCache[craftString] = private.recipeInfoCache[spellId]
				else
					inactiveCraftStrings[craftString] = true
				end
			end
		end
		private.db:BulkInsertEnd()
		-- remove crafts which are not active (i.e. older ranks)
		if next(inactiveCraftStrings) then
			TSM.Crafting.RemovePlayerSpells(inactiveCraftStrings)
		end
		TempTable.Release(inactiveCraftStrings)
		TempTable.Release(recipes)
		TempTable.Release(prevRecipeIds)
		TempTable.Release(nextRecipeIds)
	end

	if TSM.Crafting.ProfessionUtil.IsNPCProfession() or TSM.Crafting.ProfessionUtil.IsLinkedProfession() or TSM.Crafting.ProfessionUtil.IsGuildProfession() then
		-- we don't want to store this profession in our DB, so we're done
		private.DoneScanning(scannedHash)
		return
	end

	if not TSM.db.sync.internalData.playerProfessions[professionName] then
		-- we are in combat or the player's professions haven't been scanned yet by PlayerProfessions.lua, so try again in a bit
		private.QueueProfessionScan()
		return
	end

	-- update the link for this profession
	TSM.db.sync.internalData.playerProfessions[professionName].link = not TSM.IsWowClassic() and C_TradeSkillUI.GetTradeSkillListLink() or nil

	-- scan all the recipes
	TSM.Crafting.SetSpellDBQueryUpdatesPaused(true)
	local query = private.db:NewQuery()
		:Select("craftString")
	local numFailed = 0
	for _, craftString in query:Iterator() do
		if not private.ScanRecipe(professionName, craftString) then
			numFailed = numFailed + 1
		end
	end
	query:Release()
	TSM.Crafting.SetSpellDBQueryUpdatesPaused(false)

	Log.Info("Scanned %s (failed to scan %d)", professionName, numFailed)
	if numFailed > 0 then
		-- didn't completely scan, so we'll try again
		private.QueueProfessionScan()
	end
	private.DoneScanning(scannedHash)

	-- explicitly run GC
	wipe(private.recipeInfoCache)
	collectgarbage()
end

function private.ScanRecipe(professionName, craftString)
	-- get the links
	local spellId = CraftString.GetSpellId(craftString)
	local level = CraftString.GetLevel(craftString)
	local itemLink, lNum, hNum = TSM.Crafting.ProfessionUtil.GetRecipeInfo(craftString)
	assert(itemLink, "Invalid craft: "..tostring(craftString))

	-- get the itemString and craft name
	local itemString, craftName, indirectSpellId = nil, nil, nil
	if strfind(itemLink, "enchant:") then
		if TSM.IsWowClassic() and not TSM.IsWowWrathClassic() then
			return true
		else
			-- result of craft is not an item
			if TSM.IsWowWrathClassic() then
				indirectSpellId = strmatch(itemLink, "enchant:(%d+)")
				indirectSpellId = indirectSpellId and tonumber(indirectSpellId)
				if not indirectSpellId then
					return true
				end
			else
				indirectSpellId = spellId
			end
			itemString = ProfessionInfo.GetIndirectCraftResult(indirectSpellId)
			if not itemString then
				-- we don't care about this craft
				return true
			end
			craftName = GetSpellInfo(indirectSpellId)
		end
	elseif strfind(itemLink, "item:") then
		-- result of craft is item
		itemString = ItemString.GetBase(itemLink)
		craftName = ItemInfo.GetName(itemLink)
		-- Blizzard broke Brilliant Scarlet Ruby in 8.3, so just hard-code a workaround
		if spellId == 53946 and not itemString and not craftName then
			itemString = "i:39998"
			craftName = GetSpellInfo(spellId)
		end
	else
		error("Invalid craft: "..tostring(craftString))
	end
	if not itemString or not craftName then
		Log.Warn("No itemString (%s) or craftName (%s) found (%s, %s)", tostring(itemString), tostring(craftName), tostring(professionName), tostring(craftString))
		return false
	end

	-- get the result number
	local numResult = nil
	local isEnchant, vellumable = TSM.Crafting.ProfessionUtil.IsEnchant(craftString)
	if isEnchant then
		numResult = 1
	else
		-- workaround for incorrect values returned for Temporal Crystal
		if spellId == 169092 and itemString == "i:113588" then
			lNum, hNum = 1, 1
		end
		-- workaround for incorrect values returned for new mass milling recipes
		if ProfessionInfo.IsMassMill(spellId) then
			if spellId == 210116 then -- Yseralline
				lNum, hNum = 4, 4 -- always four
			elseif spellId == 209664 then -- Felwort
				lNum, hNum = 42, 42 -- amount is variable but the values are conservative
			elseif spellId == 247861 then -- Astral Glory
				lNum, hNum = 4, 4 -- amount is variable but the values are conservative
			else
				lNum, hNum = 8, 8.8
			end
		end
		numResult = floor(((lNum or 1) + (hNum or 1)) / 2)
	end

	-- store general info about this recipe
	local hasCD = TSM.Crafting.ProfessionUtil.HasCooldown(craftString)
	TSM.Crafting.CreateOrUpdate(craftString, itemString, professionName, craftName, numResult, UnitName("player"), hasCD)

	-- get the mat quantities and add mats to our DB
	local matQuantities = TempTable.Acquire()
	local haveInvalidMats = false
	local numReagents = TSM.Crafting.ProfessionUtil.GetNumMats(spellId, level)
	for i = 1, numReagents do
		local matItemLink, name, _, quantity = TSM.Crafting.ProfessionUtil.GetMatInfo(spellId, i, level)
		local matItemString = ItemString.GetBase(matItemLink)
		if not matItemString then
			Log.Warn("Failed to get itemString for mat %d (%s, %s)", i, tostring(professionName), tostring(craftString))
			haveInvalidMats = true
			break
		end
		if not name or not quantity then
			Log.Warn("Failed to get name (%s) or quantity (%s) for mat (%s, %s, %d)", tostring(name), tostring(quantity), tostring(professionName), tostring(craftString), i)
			haveInvalidMats = true
			break
		end
		ItemInfo.StoreItemName(matItemString, name)
		TSM.db.factionrealm.internalData.mats[matItemString] = TSM.db.factionrealm.internalData.mats[matItemString] or {}
		matQuantities[matItemString] = quantity
	end
	-- if this is an enchant, add a vellum to the list of mats
	if isEnchant and vellumable then
		local matItemString = ProfessionInfo.GetVellumItemString(indirectSpellId)
		TSM.db.factionrealm.internalData.mats[matItemString] = TSM.db.factionrealm.internalData.mats[matItemString] or {}
		matQuantities[matItemString] = 1
	end

	if not haveInvalidMats then
		local optionalMats = private.GetOptionalMats(spellId, level)
		if optionalMats then
			for _, matStr in ipairs(optionalMats) do
				local _, _, mats = strsplit(":", matStr)
				for itemId in String.SplitIterator(mats, ",") do
					local matItemString = "i:"..itemId
					TSM.db.factionrealm.internalData.mats[matItemString] = TSM.db.factionrealm.internalData.mats[matItemString] or {}
				end
				matQuantities[matStr] = -1
			end
		end
		TSM.Crafting.SetMats(craftString, matQuantities)
	end
	TempTable.Release(matQuantities)
	return not haveInvalidMats
end

function private.GetOptionalMats(spellId, level)
	if TSM.IsWowClassic() then
		return nil
	end
	local optionalMats = nil
	local info = C_TradeSkillUI.GetRecipeSchematic(spellId, false, level)
	optionalMats = {}
	local options = TempTable.Acquire()
	local skillLevel = private.GetCurrentCategorySkillLevel(private.recipeInfoCache[spellId].categoryID)
	for _, data in ipairs(info.reagentSlotSchematics) do
		if data.reagentType == Enum.CraftingReagentType.Optional and data.slotInfo.requiredSkillRank <= skillLevel then
			wipe(options)
			for _, craftingReagent in ipairs(data.reagents) do
				tinsert(options, craftingReagent.itemID)
			end
			local matList = table.concat(options, ",")
			-- FIXME: `data.slotInfo.slotText` seems to not exist here, not sure how Blizzard gets this text
			-- TSM.Crafting.ProfessionUtil.StoreOptionalMatText(matList, data.slotInfo.slotText or OPTIONAL_REAGENT_POSTFIX)
			optionalMats[data.dataSlotIndex] = "o:"..data.dataSlotIndex..":"..matList
		end
	end
	TempTable.Release(options)
	return optionalMats
end

function private.GetCurrentCategorySkillLevel(categoryId)
	if private.categorySkillLevelCache.lastUpdate ~= GetTime() then
		wipe(private.categorySkillLevelCache)
		private.categorySkillLevelCache.lastUpdate = GetTime()
	end
	if not private.categorySkillLevelCache[categoryId] then
		local categoryInfo = C_TradeSkillUI.GetCategoryInfo(categoryId)
		while not categoryInfo.skillLineCurrentLevel and categoryInfo.parentCategoryID do
			categoryInfo = C_TradeSkillUI.GetCategoryInfo(categoryInfo.parentCategoryID)
		end
		private.categorySkillLevelCache[categoryId] = categoryInfo.skillLineCurrentLevel or 0
	end
	return private.categorySkillLevelCache[categoryId]
end

function private.DoneScanning(scannedHash)
	private.prevScannedHash = scannedHash
	if not private.hasScanned then
		private.hasScanned = true
		for _, callback in ipairs(private.callbacks) do
			callback()
		end
	end
end
