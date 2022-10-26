-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Recipe String functions
-- @module RecipeString

local _, TSM = ...
local RecipeString = TSM.Init("Util.RecipeString")
local String = TSM.Include("Util.String")
local Table = TSM.Include("Util.Table")
local private = {
	partsTemp = {},
	partsOrderTemp = {},
	iterTemp = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function RecipeString.Get(spellId, optionalMats, rank, level)
	local recipeString = "r:"..spellId
	local suffix = ""
	if rank then
		assert(not level)
		suffix = ":r"..(rank or 1)
	end
	if level then
		assert(not rank)
		suffix = ":l"..(level or 1)
	end
	if not optionalMats or not next(optionalMats) then
		return recipeString..suffix
	end
	wipe(private.partsTemp)
	wipe(private.partsOrderTemp)
	for slotId, itemId in pairs(optionalMats) do
		local part = slotId..":"..itemId
		private.partsOrderTemp[part] = slotId
		tinsert(private.partsTemp, part)
	end
	Table.SortWithValueLookup(private.partsTemp, private.partsOrderTemp)
	recipeString = recipeString..":"..table.concat(private.partsTemp, ":")..suffix
	return recipeString
end

function RecipeString.FromCraftString(craftString, optionalMats, overrideRank, overrideLevel)
	local spellId = strmatch(craftString, "^c:(%d+)")
	if overrideRank and overrideRank < 0 then
		overrideRank = nil
	end
	local rank = overrideRank or strmatch(craftString, ":r(%d)$")
	local level = overrideLevel or strmatch(craftString, ":l(%d)$")
	return RecipeString.Get(spellId, optionalMats, rank, level)
end

function RecipeString.GetSpellId(recipeString)
	local spellId = strmatch(recipeString, "^r:(%d+)")
	return tonumber(spellId)
end

function RecipeString.GetRank(recipeString)
	local rank = strmatch(recipeString, ":r(%d)$")
	return tonumber(rank)
end

function RecipeString.GetLevel(recipeString)
	local level = strmatch(recipeString, ":l(%d)$")
	return tonumber(level)
end

function RecipeString.OptionalMatIterator(recipeString)
	recipeString = gsub(recipeString, ":l%d$", "")
	recipeString = gsub(recipeString, ":r%d$", "")
	local optionalMatsStr = strmatch(recipeString, "^r:%d+:?(.*)")
	assert(optionalMatsStr)
	wipe(private.iterTemp)
	for part in String.SplitIterator(optionalMatsStr, ":") do
		part = tonumber(part)
		assert(part)
		tinsert(private.iterTemp, part)
	end
	assert(#private.iterTemp % 2 == 0)
	return private.OptionalMatIteratorHelper, private.iterTemp, 0
end

function RecipeString.HasOptionalMats(recipeString)
	recipeString = gsub(recipeString, ":l%d$", "")
	recipeString = gsub(recipeString, ":r%d$", "")
	return strmatch(recipeString, "^r:%d+:(.+)") and true or false
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OptionalMatIteratorHelper(tbl, index)
	index = index + 1
	if index > #tbl then
		return
	end
	assert(index + 1 <= #tbl)
	return index + 1, tbl[index], tbl[index + 1]
end
