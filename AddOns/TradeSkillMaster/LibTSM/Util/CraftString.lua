-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local CraftString = TSM.Init("Util.CraftString") ---@class Util.CraftString



-- ============================================================================
-- Module Functions
-- ============================================================================

---Creates a craft string from its components.
---@param spellId number The craft's spell ID
---@param rank? number The rank of the craft
---@param level? number The level of the craft
---@return string @The craft string
function CraftString.Get(spellId, rank, level)
	local suffix = ""
	if rank and rank > 0 then
		assert(not level or level <= 0)
		suffix = ":r"..rank
	end
	if level and level > 0 then
		assert(not rank or rank <= 0)
		suffix = ":l"..level
	end
	return "c:"..spellId..suffix
end

---Creates a craft string from a recipe string.
---@param recipeString string The recipe string
---@return string @The craft string
function CraftString.FromRecipeString(recipeString)
	local spellId = strmatch(recipeString, "^r:(%d+)")
	local rank = tonumber(strmatch(recipeString, ":r(%d+)"))
	local level = tonumber(strmatch(recipeString, ":l(%d+)"))
	return CraftString.Get(spellId, rank, level)
end

---Gets the spell ID from a craft string.
---@param craftString string The craft string
---@return number @The spell ID
function CraftString.GetSpellId(craftString)
	return tonumber(strmatch(craftString, "^c:(%d+)"))
end

---Gets the rank from the craft string.
---@param craftString string The craft string
---@return number|nil @The rank
function CraftString.GetRank(craftString)
	return tonumber(strmatch(craftString, ":r(%d+)"))
end

---Gets the level from the craft string.
---@param craftString string The craft string
---@return number|nil @The level
function CraftString.GetLevel(craftString)
	return tonumber(strmatch(craftString, ":l(%d+)"))
end
