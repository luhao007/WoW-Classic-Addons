-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local DFCrafting = TSM.Crafting:NewPackage("DFCrafting")
local Quality = TSM.Include("Service.ProfessionHelpers.Quality")
local CraftString = TSM.Include("Util.CraftString")
local MatString = TSM.Include("Util.MatString")
local TempTable = TSM.Include("Util.TempTable")
local Table = TSM.Include("Util.Table")
local ProfessionInfo = TSM.Include("Data.ProfessionInfo")
local Conversions = TSM.Include("Service.Conversions")
local CustomPrice = TSM.Include("Service.CustomPrice")
local private = {
	tempTables = {{}, {}},
	tempTableInUse = {false, false},
}
local DRAGON_ISLES_SALVAGE_CRAFTSTRINGS = {
	[Conversions.METHOD.MILL] = "c:382981",
	[Conversions.METHOD.PROSPECT] = "c:374627",
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function DFCrafting.GetOptionalMats(craftString, mats, optionalMats)
	if not TSM.Crafting.IsQualityCraft(craftString) then
		return false, nil
	end
	local recipeDifficulty, recipeQuality, recipeMaxQuality, inspirationAmount, inspirationChance = TSM.Crafting.GetQualityInfo(craftString)
	if not recipeDifficulty then
		return false, nil
	end
	local hasQualityMats = false
	for _ in private.QualityMatIterator(mats) do --luacheck: ignore 512
		hasQualityMats = true
		break
	end
	local targetQuality = CraftString.GetQuality(craftString)
	local neededSkill, maxAddedSkill, maxQualityMatSkill = Quality.GetNeededSkill(targetQuality, recipeDifficulty, recipeQuality, recipeMaxQuality, hasQualityMats, inspirationAmount)
	if not neededSkill then
		return false, nil
	end

	-- Handle crafts with no quality mats
	if not hasQualityMats then
		if neededSkill == 0 then
			return true, 1
		elseif inspirationAmount >= neededSkill then
			return true, inspirationChance
		else
			return false, nil
		end
	end

	-- Cache the cost of each quality mat and calculate the total weight
	local totalWeight = 0
	local qualityMatCostTemp = private.AcquireTempTable()
	for matString in private.QualityMatIterator(mats) do
		local quantity = mats[matString]
		local isFirst = true
		local hasValidCost = false
		for matItemString in MatString.ItemIterator(matString) do
			qualityMatCostTemp[matItemString] = CustomPrice.GetSourcePrice(matItemString, "MatPrice")
			hasValidCost = hasValidCost or qualityMatCostTemp[matItemString] ~= nil
			if isFirst then
				isFirst = false
				totalWeight = totalWeight + ProfessionInfo.GetQualityMatWeight(matItemString) * quantity
			end
		end
		if not hasValidCost then
			private.ReleaseTempTable(qualityMatCostTemp)
			return false, nil
		end
		assert(not isFirst)
	end

	-- Get all combinations of quality mats
	local lowestQualityMatCost, isLowestInspired = math.huge, true
	for qualities in Quality.MatCombationIterator(mats) do
		-- Calculate the weight and cost for this set of qualities
		local currentMatCost = 0
		local weight = 0
		for matString, quality, matWeight in Quality.MatQualityItemIterator(qualities) do
			local matItemString = MatString.GetQualityItem(matString, quality)
			local quantity = mats[matString]
			weight = weight + matWeight * quantity
			local matCost = qualityMatCostTemp[matItemString]
			if not matCost then
				currentMatCost = math.huge
				break
			end
			currentMatCost = currentMatCost + matCost * quantity
		end
		-- NOTE: Only rely on inspiration if we can't find a non-inspirated way to craft it
		local bonusSkill = (weight / totalWeight) * maxQualityMatSkill
		local isNewLowest = false
		if bonusSkill >= neededSkill and bonusSkill <= maxAddedSkill and (isLowestInspired or currentMatCost < lowestQualityMatCost) then
			isNewLowest = true
			isLowestInspired = false
		elseif (bonusSkill + inspirationAmount) >= neededSkill and (bonusSkill + inspirationAmount) <= maxAddedSkill and isLowestInspired and currentMatCost < lowestQualityMatCost then
			isNewLowest = true
		end
		if isNewLowest then
			lowestQualityMatCost = currentMatCost
			wipe(optionalMats)
			for matString in private.QualityMatIterator(mats) do
				local quality = qualities[matString]
				local matItemString = MatString.GetQualityItem(matString, quality)
				tinsert(optionalMats, matItemString)
				optionalMats[matItemString] = matString
			end
		end
	end
	private.ReleaseTempTable(qualityMatCostTemp)
	if lowestQualityMatCost == math.huge then
		return false, nil
	end
	Table.SortWithValueLookup(optionalMats, optionalMats)
	return true, isLowestInspired and inspirationChance or 1
end

function DFCrafting.GetSourceMatSkill(recipeDifficulty, sourceQuality)
	return sourceQuality == 3 and recipeDifficulty * 0.25 or (sourceQuality == 2 and recipeDifficulty * 0.125 or 0)
end

function DFCrafting.GetExpectedSalvageResult(method, sourceQuality)
	local craftString = DRAGON_ISLES_SALVAGE_CRAFTSTRINGS[method]
	assert(craftString)
	local baseRecipeDifficulty, baseRecipeQuality = TSM.Crafting.GetQualityInfo(craftString)
	-- Show quality 1 results when Dragon Isles Milling/Prospecting is not learned
	if not baseRecipeDifficulty or not baseRecipeQuality then
		return 1
	end

	local quality = 1
	local sourceMatSkill = DFCrafting.GetSourceMatSkill(baseRecipeDifficulty, sourceQuality)
	for i = 2, 3 do
		-- TODO: take inspiration into account
		local neededSkill = Quality.GetNeededSkill(i, baseRecipeDifficulty, baseRecipeQuality, 3, true, 0)
		if neededSkill and neededSkill >= sourceMatSkill then
			quality = i
		end
	end
	return quality
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.QualityMatIterator(mats)
	return private.QualityMatIteratorHelper, mats, nil
end

function private.QualityMatIteratorHelper(mats, matString)
	while true do
		matString = next(mats, matString)
		if not matString then
			return
		end
		if MatString.GetType(matString) == MatString.TYPE.QUALITY then
			return matString
		end
	end
end

function private.AcquireTempTable()
	for i = 1, #private.tempTables do
		if not private.tempTableInUse[i] then
			local tbl = private.tempTables[i]
			private.tempTableInUse[i] = true
			wipe(tbl)
			return tbl
		end
	end
	return TempTable.Acquire()
end

function private.ReleaseTempTable(tbl)
	for i = 1, #private.tempTables do
		if tbl == private.tempTables[i] then
			private.tempTableInUse[i] = false
			return
		end
	end
	TempTable.Release(tbl)
end
