-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local RecipeString = TSM.Init("Util.RecipeString") ---@class Util.RecipeString
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

---Creates a recipe string from its components.
---@param spellId number The spell ID of the recipe
---@param optionalMats table<number,number> The optional materials (slotId -> itemId table)
---@param rank? number The rank of the recipe
---@param level? number The level of the recipe
---@return string @The recipe string
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

---Creates a recipe string from a craft string.
---@param craftString string The recipe string
---@param optionalMats table<number,number> The optional materials (slotId -> itemId table)
---@param overrideRank? number Overrides the rank of the craft string
---@param overrideLevel? number Overrides the level of the craft string
---@return string @The recipe string
function RecipeString.FromCraftString(craftString, optionalMats, overrideRank, overrideLevel)
	local spellId = strmatch(craftString, "^c:(%d+)")
	if overrideRank and overrideRank < 0 then
		overrideRank = nil
	end
	local rank = overrideRank or strmatch(craftString, ":r(%d)$")
	local level = overrideLevel or strmatch(craftString, ":l(%d)$")
	return RecipeString.Get(spellId, optionalMats, rank, level)
end

---Gets the spell ID from the recipe string.
---@param recipeString string The recipe string
---@return number @The spell ID
function RecipeString.GetSpellId(recipeString)
	local spellId = strmatch(recipeString, "^r:(%d+)")
	return tonumber(spellId)
end

---Gets the rank from the recipe string.
---@param recipeString string The recipe string
---@return number|nil @The rank
function RecipeString.GetRank(recipeString)
	local rank = strmatch(recipeString, ":r(%d)$")
	return tonumber(rank)
end

---Gets the level from the recipe string.
---@param recipeString string The recipe string
---@return number|nil @The level
function RecipeString.GetLevel(recipeString)
	local level = strmatch(recipeString, ":l(%d)$")
	return tonumber(level)
end

---Iterates over the optional mats within the recipe string.
---@param recipeString string The recipe string
---@return fun():number, string, number @An iterator with fields: `index`, `slotId`, `itemId`
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

---Returns whether or not the recipe string includes optional materials.
---@param recipeString string The recipe string
---@return boolean
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
