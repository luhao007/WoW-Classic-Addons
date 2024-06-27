-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Types = TSM.Init("Util.CustomStringClasses.Types") ---@class Util.CustomStringClasses.Types
local EnumType = TSM.Include("Util.EnumType")
local NamedTupleListType = TSM.Include("Util.NamedTupleListType")
local TreeType = TSM.Include("Util.TreeType")
Types.TOKEN = EnumType.New("TOKEN", {
	UNKNOWN = EnumType.CreateValue(),
	NUMBER = EnumType.CreateValue(),
	MONEY = EnumType.CreateValue(),
	NEWLINE = EnumType.CreateValue(),
	WHITESPACE = EnumType.CreateValue(),
	IDENTIFIER = EnumType.CreateValue(),
	FUNCTION = EnumType.CreateValue(),
	COMMA = EnumType.CreateValue(),
	LEFT_PAREN = EnumType.CreateValue(),
	RIGHT_PAREN = EnumType.CreateValue(),
	MATH_OPERATOR = EnumType.CreateValue(),
	COLORCODE = EnumType.CreateValue(),
	NEGATIVE_OPERATOR = EnumType.CreateValue(),
})
Types.NODE = EnumType.New("NODE", {
	FUNCTION = EnumType.CreateValue(),
	CONSTANT = EnumType.CreateValue(),
	VARIABLE = EnumType.CreateValue(),
	INVALID = EnumType.CreateValue(),
})
Types.ERROR = EnumType.New("ERROR", {
	INVALID_TOKEN = EnumType.CreateValue(),
	UNBALANCED_PARENS = EnumType.CreateValue(),
	INVALID_NUM_ARGS = EnumType.CreateValue(),
	TOO_MANY_VARS = EnumType.CreateValue(),
	INVALID_ITEM_STRING = EnumType.CreateValue(),
	INVALID_CONVERT_ARG = EnumType.CreateValue(),
	NO_ITEM_PARAM_PARENT = EnumType.CreateValue(),
})
Types.FUNCTION_INFO = {
	["+"] = {minArgs=2, maxArgs=2},
	["-"] = {minArgs=2, maxArgs=2},
	["*"] = {minArgs=2, maxArgs=2},
	["/"] = {minArgs=2, maxArgs=2},
	["^"] = {minArgs=2, maxArgs=2},
	["%"] = {minArgs=2, maxArgs=2},
	check = {minArgs=2, maxArgs=3},
	iflte = {minArgs=3, maxArgs=4},
	iflt = {minArgs=3, maxArgs=4},
	ifgte = {minArgs=3, maxArgs=4},
	ifgt = {minArgs=3, maxArgs=4},
	ifeq = {minArgs=3, maxArgs=4},
	round = {minArgs=1, maxArgs=2},
	roundup = {minArgs=1, maxArgs=2},
	rounddown = {minArgs=1, maxArgs=2},
	min = {minArgs=1, maxArgs=math.huge},
	max = {minArgs=1, maxArgs=math.huge},
	avg = {minArgs=1, maxArgs=math.huge},
	first = {minArgs=1, maxArgs=math.huge},
	convert = {minArgs=1, maxArgs=2},
}
local ITEM_STRING_MATCH_STR_1 = "^[ip]:[0-9:%-]+$"
local ITEM_STRING_MATCH_STR_2 = "^item:[0-9:%-]+$"



-- ============================================================================
-- Module Methods
-- ============================================================================

---Creates a new token list.
---@return NamedTupleList
function Types.CreateTokenList()
	return NamedTupleListType.New("token", "str", "startPos", "endPos")
end

---Creates a new node tree.
---@return Tree
function Types.CreateNodeTree()
	return TreeType.Create("type", "value", "tokenIndex")
end

---Return if a value is an item parameter.
---@param value string
---@return boolean
function Types.IsItemParam(value)
	return value == "baseitem" or Types.IsItemStringParam(value)
end

---Return if a value is an item string parameter.
---@param value string
---@return boolean
function Types.IsItemStringParam(value)
	return (strmatch(value, ITEM_STRING_MATCH_STR_1) or strmatch(value, ITEM_STRING_MATCH_STR_2)) and true or false
end
