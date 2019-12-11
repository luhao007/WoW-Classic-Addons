-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local QueryClause = TSM.Init("Util.DatabaseClasses.QueryClause")
local Constants = TSM.Include("Util.DatabaseClasses.Constants")
local ObjectPool = TSM.Include("Util.ObjectPool")
local LibTSMClass = TSM.Include("LibTSMClass")
local DatabaseQueryClause = LibTSMClass.DefineClass("DatabaseQueryClause")
local private = {
	objectPool = nil,
}



-- ============================================================================
-- Module Loading
-- ============================================================================

QueryClause:OnModuleLoad(function()
	private.objectPool = ObjectPool.New("DATABASE_QUERY_CLAUSES", DatabaseQueryClause, 1)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function QueryClause.Get(query, parent)
	local clause = private.objectPool:Get()
	clause:_Acquire(query, parent)
	return clause
end



-- ============================================================================
-- Class Method Methods
-- ============================================================================

function DatabaseQueryClause.__init(self)
	self._query = nil
	self._operation = nil
	self._parent = nil
	-- comparison
	self._field = nil
	self._value = nil
	self._boundValue = nil
	self._otherField = nil
	-- or / and
	self._subClauses = {}
end

function DatabaseQueryClause._Acquire(self, query, parent)
	self._query = query
	self._parent = parent
end

function DatabaseQueryClause._Release(self)
	self._query = nil
	self._operation = nil
	self._parent = nil
	self._field = nil
	self._value = nil
	self._boundValue = nil
	self._otherField = nil
	for _, clause in ipairs(self._subClauses) do
		clause:_Release()
	end
	wipe(self._subClauses)
	private.objectPool:Recycle(self)
end



-- ============================================================================
-- Public Class Method
-- ============================================================================

function DatabaseQueryClause.Equal(self, field, value, otherField)
	return self:_SetComparisonOperation("EQUAL", field, value, otherField)
end

function DatabaseQueryClause.NotEqual(self, field, value, otherField)
	return self:_SetComparisonOperation("NOT_EQUAL", field, value, otherField)
end

function DatabaseQueryClause.LessThan(self, field, value, otherField)
	return self:_SetComparisonOperation("LESS", field, value, otherField)
end

function DatabaseQueryClause.LessThanOrEqual(self, field, value, otherField)
	return self:_SetComparisonOperation("LESS_OR_EQUAL", field, value, otherField)
end

function DatabaseQueryClause.GreaterThan(self, field, value, otherField)
	return self:_SetComparisonOperation("GREATER", field, value, otherField)
end

function DatabaseQueryClause.GreaterThanOrEqual(self, field, value, otherField)
	return self:_SetComparisonOperation("GREATER_OR_EQUAL", field, value, otherField)
end

function DatabaseQueryClause.Matches(self, field, value)
	return self:_SetComparisonOperation("MATCHES", field, value)
end

function DatabaseQueryClause.IsNil(self, field)
	return self:_SetComparisonOperation("IS_NIL", field)
end

function DatabaseQueryClause.IsNotNil(self, field)
	return self:_SetComparisonOperation("IS_NOT_NIL", field)
end

function DatabaseQueryClause.Custom(self, func, arg)
	return self:_SetComparisonOperation("CUSTOM", func, arg)
end

function DatabaseQueryClause.HashEqual(self, fields, value)
	return self:_SetComparisonOperation("HASH_EQUAL", fields, value)
end

function DatabaseQueryClause.InTable(self, field, value)
	return self:_SetComparisonOperation("IN_TABLE", field, value)
end

function DatabaseQueryClause.Or(self)
	return self:_SetSubClauseOperation("OR")
end

function DatabaseQueryClause.And(self)
	return self:_SetSubClauseOperation("AND")
end



-- ============================================================================
-- Private Class Method
-- ============================================================================

function DatabaseQueryClause._GetParent(self)
	return self._parent
end

function DatabaseQueryClause._IsTrue(self, row)
	local value = self._value
	if value == Constants.BOUND_QUERY_PARAM then
		value = self._boundValue
	elseif value == Constants.OTHER_FIELD_QUERY_PARAM then
		value = row:GetField(self._otherField)
	end
	local operation = self._operation
	if operation == "EQUAL" then
		return row[self._field] == value
	elseif operation == "NOT_EQUAL" then
		return row[self._field] ~= value
	elseif operation == "LESS" then
		return row[self._field] < value
	elseif operation == "LESS_OR_EQUAL" then
		return row[self._field] <= value
	elseif operation == "GREATER" then
		return row[self._field] > value
	elseif operation == "GREATER_OR_EQUAL" then
		return row[self._field] >= value
	elseif operation == "MATCHES" then
		return strmatch(strlower(row[self._field]), value) and true or false
	elseif operation == "IS_NIL" then
		return row[self._field] == nil
	elseif operation == "IS_NOT_NIL" then
		return row[self._field] ~= nil
	elseif operation == "CUSTOM" then
		return self._field(row, value) and true or false
	elseif operation == "HASH_EQUAL" then
		return row:CalculateHash(self._field) == value
	elseif operation == "IN_TABLE" then
		return value[row[self._field]] ~= nil
	elseif operation == "OR" then
		for i = 1, #self._subClauses do
			if self._subClauses[i]:_IsTrue(row) then
				return true
			end
		end
		return false
	elseif operation == "AND" then
		for i = 1, #self._subClauses do
			if not self._subClauses[i]:_IsTrue(row) then
				return false
			end
		end
		return true
	else
		error("Invalid operation: " .. tostring(operation))
	end
end

function DatabaseQueryClause._GetIndexValue(self, indexField)
	if self._operation == "EQUAL" then
		if self._field ~= indexField then
			return
		end
		if self._value == Constants.OTHER_FIELD_QUERY_PARAM then
			return
		elseif self._value == Constants.BOUND_QUERY_PARAM then
			return self._boundValue, self._boundValue
		else
			return self._value, self._value
		end
	elseif self._operation == "LESS_OR_EQUAL" then
		if self._field ~= indexField then
			return
		end
		if self._value == Constants.OTHER_FIELD_QUERY_PARAM then
			return
		elseif self._value == Constants.BOUND_QUERY_PARAM then
			return nil, self._boundValue
		else
			return nil, self._value
		end
	elseif self._operation == "GREATER_OR_EQUAL" then
		if self._field ~= indexField then
			return
		end
		if self._value == Constants.OTHER_FIELD_QUERY_PARAM then
			return
		elseif self._value == Constants.BOUND_QUERY_PARAM then
			return self._boundValue, nil
		else
			return self._value, nil
		end
	elseif self._operation == "OR" then
		local numSubClauses = #self._subClauses
		if numSubClauses == 0 then
			return
		end
		-- all of the subclauses need to support the same index
		local valueMin, valueMax = self._subClauses[1]:_GetIndexValue(indexField)
		for i = 2, numSubClauses do
			local subClauseValueMin, subClauseValueMax = self._subClauses[i]:_GetIndexValue(indexField)
			if subClauseValueMin ~= valueMin or subClauseValueMax ~= valueMax then
				return
			end
		end
		return valueMin, valueMax
	elseif self._operation == "AND" then
		-- get the most constrained range of index values from the subclauses
		local valueMin, valueMax = nil, nil
		for _, subClause in ipairs(self._subClauses) do
			local subClauseValueMin, subClauseValueMax = subClause:_GetIndexValue(indexField)
			if subClauseValueMin ~= nil and (valueMin == nil or subClauseValueMin > valueMin) then
				valueMin = subClauseValueMin
			end
			if subClauseValueMax ~= nil and (valueMax == nil or subClauseValueMax < valueMax) then
				valueMax = subClauseValueMax
			end
		end
		return valueMin, valueMax
	end
end

function DatabaseQueryClause._IsStrictIndex(self, indexField, indexValueMin, indexValueMax)
	if self._value == Constants.OTHER_FIELD_QUERY_PARAM then
		return false
	end
	if self._operation == "EQUAL" and self._field == indexField and indexValueMin == indexValueMax then
		if self._value == Constants.BOUND_QUERY_PARAM then
			return self._boundValue == indexValueMin
		else
			return self._value == indexValueMin
		end
	elseif self._operation == "GREATER_OR_EQUAL" and self._field == indexField then
		if self._value == Constants.BOUND_QUERY_PARAM then
			return self._boundValue == indexValueMin
		else
			return self._value == indexValueMin
		end
	elseif self._operation == "LESS_OR_EQUAL" and self._field == indexField then
		if self._value == Constants.BOUND_QUERY_PARAM then
			return self._boundValue == indexValueMax
		else
			return self._value == indexValueMax
		end
	elseif self._operation == "OR" and #self._subClauses == 1 then
		return self._subClauses[1]:_IsStrictIndex(indexField, indexValueMin, indexValueMax)
	elseif self._operation == "AND" then
		-- must be strict for all subclauses
		for _, subClause in ipairs(self._subClauses) do
			if not subClause:_IsStrictIndex(indexField, indexValueMin, indexValueMax) then
				return false
			end
		end
		return true
	else
		return false
	end
end

function DatabaseQueryClause._UsesField(self, field)
	if field == self._field or self._operation == "CUSTOM" then
		return true
	end
	if self._operation == "OR" or self._operation == "AND" then
		for i = 1, #self._subClauses do
			if self._subClauses[i]:_UsesField(field) then
				return true
			end
		end
	end
	return false
end

function DatabaseQueryClause._InsertSubClause(self, subClause)
	assert(self._operation == "OR" or self._operation == "AND")
	tinsert(self._subClauses, subClause)
	self._query:_MarkResultStale()
	return self
end

function DatabaseQueryClause._SetComparisonOperation(self, operation, field, value, otherField)
	assert(not self._operation)
	assert(value == Constants.OTHER_FIELD_QUERY_PARAM or not otherField)
	self._operation = operation
	self._field = field
	self._value = value
	self._otherField = otherField
	self._query:_MarkResultStale()
	return self
end

function DatabaseQueryClause._SetSubClauseOperation(self, operation)
	assert(not self._operation)
	self._operation = operation
	assert(#self._subClauses == 0)
	self._query:_MarkResultStale()
	return self
end

function DatabaseQueryClause._BindParams(self, ...)
	if self._value == Constants.BOUND_QUERY_PARAM then
		self._boundValue = ...
		self._query:_MarkResultStale()
		return 1
	end
	local valuesUsed = 0
	for _, clause in ipairs(self._subClauses) do
		valuesUsed = valuesUsed + clause:_BindParams(select(valuesUsed + 1, ...))
	end
	self._query:_MarkResultStale()
	return valuesUsed
end
