-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local String = TSM.Init("Util.CustomStringClasses.String") ---@class Util.CustomStringClasses.String
local Tokenizer = TSM.Include("Util.CustomStringClasses.Tokenizer")
local AST = TSM.Include("Util.CustomStringClasses.AST")
local CodeGen = TSM.Include("Util.CustomStringClasses.CodeGen")
local Types = TSM.Include("Util.CustomStringClasses.Types")
local L = TSM.Include("Locale").GetTable()
local Math = TSM.Include("Util.Math")
local ItemString = TSM.Include("Util.ItemString")
local Log = TSM.Include("Util.Log")
local private = {
	priceFunc = nil,
	recursiveCalls = 0,
	lastRecursiveError = nil,
}
local DEPENDENCY_SEP = "/"



-- ============================================================================
-- Helpers Object
-- ============================================================================

local HELPERS = {}
HELPERS.INVALID = newproxy()
HELPERS.GetBaseItemString = function(itemString)
	return ItemString.GetBaseFast(itemString)
end
HELPERS.GetPrice = function(itemString, key, extraArg)
	local val = private.priceFunc(itemString, key, extraArg)
	if not val or val < 0 then
		return HELPERS.INVALID
	end
	return val
end



-- ============================================================================
-- Class Definition
-- ============================================================================

local CustomStringObject = TSM.Include("LibTSMClass").DefineClass("CustomStringObject") ---@class CustomStringObject

function CustomStringObject:__init()
	self._str = nil
	self._errType = nil
	self._errTokenIndex = nil
	self._tokenList = Types.CreateTokenList()
	self._tree = Types.CreateNodeTree()
	self._dependencies = {}
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function CustomStringObject:SetString(str)
	self._str = str
	self._errType = nil
	self._errTokenIndex = nil
	self._tokenList:Wipe()
	self._tree:Wipe()

	-- Parse the string into tokens
	Tokenizer.GetTokens(str, self._tokenList)

	-- Generate the AST
	if not self:_HandleStepResult(AST.Generate(self._tokenList, self._tree)) then
		return
	end

	-- Get the dependencies
	for _, source, itemArg, extraArg in AST.DependencyIterator(self._tree) do
		self._dependencies[source] = true
		if source == "convert" then
			assert(extraArg)
			self._dependencies[extraArg] = true
			if itemArg then
				self._dependencies[source..DEPENDENCY_SEP..extraArg..DEPENDENCY_SEP..itemArg] = true
			else
				self._dependencies[source..DEPENDENCY_SEP..extraArg] = true
			end
		else
			assert(not extraArg)
			self._dependencies[source..DEPENDENCY_SEP..(itemArg or "")] = true
		end
	end

	-- Generate the code
	self._code = self:_HandleStepResult(CodeGen.Execute(self._tree))
	if not self._code then
		return
	end

	-- Compile the code
	self._func = assert(loadstring(self._code))()
end

function CustomStringObject:Validate()
	if self._errType then
		if self._errTokenIndex == -1 then
			return false, self._errType
		else
			return false, self._errType, self._tokenList:GetRow(self._errTokenIndex)
		end
	else
		return true
	end
end

function CustomStringObject:DependantSourceIterator()
	return private.DependantSourceIterator, self._dependencies, nil
end

function CustomStringObject:IsDependantOnSource(source)
	return self._dependencies[source]
end

function CustomStringObject:Evaluate(itemString)
	if self._errType then
		error("Evaluating invalid custom string")
	elseif not private.priceFunc then
		error("No price func was set")
	end

	if private.recursiveCalls >= 100 then
		-- We're in a custom string loop
		if (private.lastRecursiveError or 0) + 1 < time() then
			private.lastRecursiveError = time()
			Log.PrintUser(L["Loop detected in the following custom price:"].." "..Log.ColorUserAccentText(self._str))
		end
		return nil
	end

	private.recursiveCalls = private.recursiveCalls + 1
	local result = self._func(itemString, HELPERS)
	private.recursiveCalls = private.recursiveCalls - 1

	if result == HELPERS.INVALID or result == math.huge or Math.IsNan(result) then
		return nil
	end
	result = result and floor(result + 0.5)
	return result >= 0 and result or nil
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function CustomStringObject:_HandleStepResult(result, errType, errTokenIndex)
	if result then
		assert(errType == nil and errTokenIndex == nil)
	else
		assert(errType ~= nil and errTokenIndex ~= nil)
		self._errType = errType
		self._errTokenIndex = errTokenIndex
	end
	return result
end


-- ============================================================================
-- Module Functions
-- ============================================================================

---Sets the function used to lookup a price value.
---@param priceFunc fun(itemString: string, key: string): number? The function
function String.SetPriceFunc(priceFunc)
	assert(priceFunc and not private.priceFunc)
	private.priceFunc = priceFunc
end

---Creates a custom string for the specified text.
---@param str string The custom string text
---@return CustomStringObject
function String.Create(str)
	local obj = CustomStringObject()
	obj:SetString(str)
	return obj
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.DependantSourceIterator(sources, source)
	while true do
		source = next(sources, source)
		if not source then
			return
		elseif not strmatch(source, DEPENDENCY_SEP) and source ~= "convert" then
			return source, source
		else
			local convertArg = strmatch(source, "^convert"..DEPENDENCY_SEP.."([a-z]+)")
			if convertArg then
				return source, "convert", convertArg
			end
		end
	end
end
