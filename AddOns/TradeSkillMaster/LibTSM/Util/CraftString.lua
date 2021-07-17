-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Craft String functions
-- @module CraftString

local _, TSM = ...
local CraftString = TSM.Init("Util.CraftString")



-- ============================================================================
-- Module Functions
-- ============================================================================

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

function CraftString.FromRecipeString(recipeString)
	local spellId = strmatch(recipeString, "^r:(%d+)")
	local rank = tonumber(strmatch(recipeString, ":r(%d+)"))
	local level = tonumber(strmatch(recipeString, ":l(%d+)"))
	return CraftString.Get(spellId, rank, level)
end

function CraftString.GetSpellId(craftString)
	return tonumber(strmatch(craftString, "^c:(%d+)"))
end

function CraftString.GetRank(craftString)
	return tonumber(strmatch(craftString, ":r(%d+)"))
end

function CraftString.GetLevel(craftString)
	return tonumber(strmatch(craftString, ":l(%d+)"))
end
