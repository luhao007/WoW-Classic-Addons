-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local DFCrafting = TSM.Crafting:NewPackage("DFCrafting")
local String = TSM.Include("Util.String")
local CraftString = TSM.Include("Util.CraftString")
local TempTable = TSM.Include("Util.TempTable")
local Table = TSM.Include("Util.Table")
local ProfessionInfo = TSM.Include("Data.ProfessionInfo")
local private = {
	matQualityIterContext = {
		inUse = false,
		isFirst = false,
		result = {},
		qualityMatStrings = {},
	},
	tempTables = {{}, {}},
	tempTableInUse = {false, false},
}
local MAX_QUALITY_MAT_DIFFICULTY_RATIO = 0.25
local NUM_QUALITY_MAT_QUALITIES = 3
local QUALITY_MAT_STRING_ITEM_ID_PATTERNS = {
	"^q:%d+:(%d+),%d+,%d+$",
	"^q:%d+:%d+,(%d+),%d+$",
	"^q:%d+:%d+,%d+,(%d+)$",
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function DFCrafting.CanCraftQuality(targetQuality, recipeDifficulty, recipeQuality, recipeMaxQuality)
	return private.GetNeededSkill(targetQuality, recipeDifficulty, recipeQuality, recipeMaxQuality) and true or false
end

function DFCrafting.GetOptionalMats(craftString, mats, optionalMats)
	local recipeDifficulty, recipeQuality, recipeMaxQuality = TSM.Crafting.GetQualityInfo(craftString)
	if not recipeDifficulty then
		return false
	end
	local targetQuality = CraftString.GetQuality(craftString)
	local neededSkill, maxAddedSkill, maxQualityMatSkill = private.GetNeededSkill(targetQuality, recipeDifficulty, recipeQuality, recipeMaxQuality)
	if not neededSkill then
		return false
	end

	-- Cache the cost of each quality mat and calculate the total weight
	local totalWeight = 0
	local qualityMatCostTemp = private.AcquireTempTable()
	for matString, quantity in pairs(mats) do
		local prefix = strsub(matString, 1, 2)
		if prefix == "i:" then
			-- Not worrying about regular mats here
		elseif prefix == "q:" then
			local isFirst = true
			local _, dataSlotIndex, itemList = strsplit(":", matString)
			dataSlotIndex = tonumber(dataSlotIndex)
			local hasValidCost = false
			for matItemString in String.SplitIterator(itemList, ",") do
				matItemString = "i:"..matItemString
				qualityMatCostTemp[matItemString] = TSM.Crafting.Cost.GetMatCost(matItemString)
				hasValidCost = hasValidCost or qualityMatCostTemp[matItemString] ~= nil
				if isFirst then
					isFirst = false
					totalWeight = totalWeight + ProfessionInfo.GetQualityMatWeight(matItemString) * quantity
				end
			end
			if not hasValidCost then
				private.ReleaseTempTable(qualityMatCostTemp)
				return false
			end
			assert(not isFirst)
		elseif prefix == "f:" or prefix == "o:" then
			-- Ignore for now
		else
			error("Invalid matString: "..tostring(matString))
		end
	end

	-- Get all combinations of quality mats
	local lowestQualityMatCost = math.huge
	for qualities in private.MatQualityIterator(mats) do
		-- Calculate the weight and cost for this set of qualities
		local currentMatCost = 0
		local weight = 0
		for matString, quality in pairs(qualities) do
			local matItemString = "i:"..strmatch(matString, QUALITY_MAT_STRING_ITEM_ID_PATTERNS[quality])
			local matWeight = nil
			if quality == 1 then
				matWeight = 0
			else
				matWeight = ProfessionInfo.GetQualityMatWeight(matItemString) * (quality - 1) / (NUM_QUALITY_MAT_QUALITIES - 1)
			end
			local quantity = mats[matString]
			weight = weight + matWeight * quantity
			local matCost = qualityMatCostTemp[matItemString]
			if not matCost then
				currentMatCost = math.huge
				break
			end
			currentMatCost = currentMatCost + matCost * quantity
		end
		local bonusSkill = (weight / totalWeight) * maxQualityMatSkill
		if bonusSkill >= neededSkill and bonusSkill <= maxAddedSkill and currentMatCost < lowestQualityMatCost then
			lowestQualityMatCost = currentMatCost
			wipe(optionalMats)
			for matString in pairs(mats) do
				local prefix = strsub(matString, 1, 2)
				if prefix == "i:" then
					-- Not worrying about regular mats here
				elseif prefix == "q:" then
					local quality = qualities[matString]
					local matItemString = "i:"..strmatch(matString, QUALITY_MAT_STRING_ITEM_ID_PATTERNS[quality])
					tinsert(optionalMats, matItemString)
					optionalMats[matItemString] = matString
				elseif prefix == "f:" or prefix == "o:" then
					-- Ignore for now
				else
					error("Invalid matString: "..tostring(matString))
				end
			end
		end
	end
	private.ReleaseTempTable(qualityMatCostTemp)
	if lowestQualityMatCost == math.huge then
		return false
	end
	Table.SortWithValueLookup(optionalMats, optionalMats)
	return true
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetNeededSkill(targetQuality, recipeDifficulty, recipeQuality, recipeMaxQuality)
	if recipeMaxQuality == 1 then
		-- This recipe has quality mats, but doesn't produce a quality item
		return 0, math.huge, 0
	end
	-- Calculate how much skill we need to add in order to craft the target item
	local difficultyPerQuality = recipeDifficulty / (recipeMaxQuality - 1)
	local neededSkill, maxAddedSkill = 0, 0
	local minQuality = floor(recipeQuality)
	if targetQuality < minQuality then
		-- We can't craft this low of a quality anymore
		return nil, nil
	elseif targetQuality == recipeMaxQuality then
		neededSkill = difficultyPerQuality * (targetQuality - recipeQuality)
		maxAddedSkill = math.huge
	else
		neededSkill = max(difficultyPerQuality * (targetQuality - recipeQuality), 0)
		maxAddedSkill = difficultyPerQuality * (targetQuality + 1 - recipeQuality)
	end
	assert(neededSkill >= 0 and maxAddedSkill > 0)
	local maxQualityMatSkill = recipeDifficulty * MAX_QUALITY_MAT_DIFFICULTY_RATIO
	if neededSkill > maxQualityMatSkill then
		-- We can't get this much skill with just quality reagents
		-- TODO: We potentically could with finishing / optional(?) mats
		return nil, nil
	end
	return neededSkill, maxAddedSkill, maxQualityMatSkill
end

function private.MatQualityIterator(mats)
	local context = private.matQualityIterContext
	assert(not context.inUse)
	context.inUse = true
	context.isFirst = true
	for matString in pairs(mats) do
		if strmatch(matString, "^q:") then
			tinsert(context.qualityMatStrings, matString)
			context.qualityMatStrings[matString] = 1
		end
	end
	return private.MatQualityIteratorHelper, context
end

function private.MatQualityIteratorHelper(context)
	if context.isFirst then
		context.isFirst = false
	else
		-- Increment the current value
		local carry = true
		for i = #context.qualityMatStrings, 1, -1 do
			local matString = context.qualityMatStrings[i]
			context.qualityMatStrings[matString] = context.qualityMatStrings[matString] + 1
			if context.qualityMatStrings[matString] > NUM_QUALITY_MAT_QUALITIES then
				context.qualityMatStrings[matString] = 1
			else
				carry = false
				break
			end
		end
		if carry then
			-- No more values
			wipe(context.result)
			wipe(context.qualityMatStrings)
			context.inUse = false
			return
		end
	end
	for matString, quality in pairs(context.qualityMatStrings) do
		if type(matString) == "string" then
			context.result[matString] = quality
		end
	end
	return context.result
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
