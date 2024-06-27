-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local CustomString = TSM.Init("Util.CustomString") ---@class Util.CustomString
local String = TSM.Include("Util.CustomStringClasses.String")
local Types = TSM.Include("Util.CustomStringClasses.Types")
local Tokenizer = TSM.Include("Util.CustomStringClasses.Tokenizer")
CustomString.TOKEN_TYPE = Types.TOKEN
CustomString.ERROR_TYPE = Types.ERROR



-- ============================================================================
-- Module Functions
-- ============================================================================

---Creates a new token list object.
---@return NamedTupleList
function CustomString.CreateTokenList()
	return Types.CreateTokenList()
end

---Populates an empty token list object based on the specified custom string.
---@param tokenList NamedTupleList The token list
---@param str string The custom string
function CustomString.PopulateTokenList(tokenList, str)
	Tokenizer.GetTokens(str, tokenList)
end

---Sets the function used to lookup a price value.
---@param priceFunc fun(itemString: string, key: string): number? The function
function CustomString.SetPriceFunc(priceFunc)
	String.SetPriceFunc(priceFunc)
end

---Creates a custom string for the specified text.
---@param text string The custom string text
---@return CustomStringObject
function CustomString.Parse(text)
	return String.Create(text)
end

---Returns whether or not a string is a reserved word.
---@param str string The string (must be lower case)
---@return boolean
function CustomString.IsReservedWord(str)
	return (Types.FUNCTION_INFO[str] or str == "baseitem") and true or false
end
