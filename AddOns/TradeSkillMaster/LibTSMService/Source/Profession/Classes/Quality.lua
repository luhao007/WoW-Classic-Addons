-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMService = select(2, ...).LibTSMService
local Quality = LibTSMService:Init("Profession.Quality")
local OptionalMatData = LibTSMService:From("LibTSMData"):Include("OptionalMat")
local MatString = LibTSMService:From("LibTSMTypes"):Include("Crafting.MatString")
local private = {
	matQualityIterContext = {
		inUse = false,
		isFirst = false,
		result = {},
		qualityMatStrings = {},
	},
}
local NUM_QUALITY_MAT_QUALITIES = 3
local MAX_QUALITY_MAT_DIFFICULTY_RATIO = 0.25
local SKILL_PER_TARGET_QUALITY = {
	[3] = {
		0,
		0.5,
		1.0,
	},
	[5] = {
		0,
		0.2,
		0.5,
		0.8,
		1.0,
	},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

---Gets the needed skill to craft a specific quality of a recipe.
---@param targetQuality number The target quality
---@param recipeDifficulty number The base recipe difficulty
---@param recipeQuality number The base recipe quality
---@param recipeMaxQuality number The max number of qualities for the recipe
---@param hasQualityMats boolean Whether or not the recipe has quality mats
---@param inspirationAmount number The inspiration amount
---@return number neededSkill
---@return number maxAddedSkill
---@return number maxQualityMatSkill
function Quality.GetNeededSkill(targetQuality, recipeDifficulty, recipeQuality, recipeMaxQuality, hasQualityMats, inspirationAmount)
	if recipeMaxQuality == 1 then
		-- This recipe has quality mats, but doesn't produce a quality item
		return 0, math.huge, 0
	end
	-- Calculate how much skill we need to add in order to craft the target item
	local neededSkill, maxAddedSkill = 0, 0
	local minQuality = floor(recipeQuality)
	local skillPerTargetQuality = SKILL_PER_TARGET_QUALITY[recipeMaxQuality]
	if targetQuality < minQuality then
		-- We can't craft this low of a quality anymore
		return nil, nil
	else
		local currentLowerBound = skillPerTargetQuality[minQuality] * recipeDifficulty
		local currentUpperBound = skillPerTargetQuality[min(ceil(recipeQuality), recipeMaxQuality)] * recipeDifficulty
		local currentQualityRatio = recipeQuality - minQuality
		local currentSkill = currentLowerBound + currentQualityRatio * (currentUpperBound - currentLowerBound)
		local targetLowerBound = skillPerTargetQuality[targetQuality] * recipeDifficulty
		local targetUpperBound = skillPerTargetQuality[min(targetQuality + 1, recipeMaxQuality)] * recipeDifficulty
		neededSkill = max(targetLowerBound - currentSkill, 0)
		maxAddedSkill = targetQuality == recipeMaxQuality and math.huge or (targetUpperBound - currentSkill)
	end
	assert(neededSkill >= 0 and maxAddedSkill > 0)
	local maxQualityMatSkill = hasQualityMats and recipeDifficulty * MAX_QUALITY_MAT_DIFFICULTY_RATIO or 0
	if neededSkill > maxQualityMatSkill + (inspirationAmount or 0) then
		-- We can't get this much skill with just quality reagents and inspiration
		-- TODO: We potentically could with finishing / optional(?) mats
		return nil, nil
	end
	return neededSkill, maxAddedSkill, maxQualityMatSkill
end

---Iterates over the possible combinations of quality mats.
---@param mats table<string,any> The mats as keys
---@return fun(): table<string,number> @Iterator with fields: `mats`
function Quality.MatCombationIterator(mats)
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
	return private.MatCombationIterator, context
end

---Iterates over the quality mats provided by `Quality.MatCombationIterator`.
---@param qualities table<string,number> The mat qualities
---@return fun(): string, number, number @Iterator with fields: `matString`, `quality`, `matWeight`
function Quality.MatQualityItemIterator(qualities)
	return private.MatQualityItemIterator, qualities, nil
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MatCombationIterator(context)
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

function private.MatQualityItemIterator(tbl, matString)
	matString = next(tbl, matString)
	if not matString then
		return
	end
	local quality = tbl[matString]
	local matItemString = MatString.GetQualityItem(matString, quality)
	local matWeight = nil
	if quality == 1 then
		matWeight = 0
	else
		matWeight = OptionalMatData.QualityWeight[matItemString] * (quality - 1) / (NUM_QUALITY_MAT_QUALITIES - 1)
	end
	return matString, quality, matWeight
end
