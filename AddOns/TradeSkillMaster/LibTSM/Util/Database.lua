-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Database Functions.
-- @module Database

local _, TSM = ...
local Database = TSM.Init("Util.Database")
local Constants = TSM.Include("Util.DatabaseClasses.Constants")
local Schema = TSM.Include("Util.DatabaseClasses.Schema")
local Table = TSM.Include("Util.DatabaseClasses.DBTable")
local private = {
	dbByNameLookup = {},
	infoNameDB = nil,
	infoFieldDB = nil,
}



-- ============================================================================
-- Module Loading
-- ============================================================================

Database:OnModuleLoad(function()
	-- create our info database tables - don't use :Commit() to create these since that'll insert into these tables
	private.infoNameDB = Database.NewSchema("DEBUG_INFO_NAME")
		:AddUniqueStringField("name")
		:AddIndex("name")
		:Commit()
	private.infoFieldDB = Database.NewSchema("DEBUG_INFO_FIELD")
		:AddStringField("dbName")
		:AddStringField("field")
		:AddStringField("type")
		:AddStringField("attributes")
		:AddNumberField("order")
		:AddIndex("dbName")
		:Commit()

	Table.SetCreateCallback(private.OnTableCreate)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function Database.NewSchema(name)
	return Schema.Get(name)
end

function Database.OtherFieldQueryParam(otherFieldName)
	return Constants.OTHER_FIELD_QUERY_PARAM, otherFieldName
end

function Database.BoundQueryParam()
	return Constants.BOUND_QUERY_PARAM
end



-- ============================================================================
-- Debug Functions
-- ============================================================================

function Database.InfoNameIterator()
	return private.infoNameDB:NewQuery()
		:Select("name")
		:OrderBy("name", true)
		:IteratorAndRelease()
end

function Database.CreateInfoFieldQuery(dbName)
	return private.infoFieldDB:NewQuery()
		:Equal("dbName", dbName)
end

function Database.GetNumRows(dbName)
	return private.dbByNameLookup[dbName]:GetNumRows()
end

function Database.GetNumActiveQueries(dbName)
	return #private.dbByNameLookup[dbName]._queries
end

function Database.CreateDBQuery(dbName)
	return private.dbByNameLookup[dbName]:NewQuery()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OnTableCreate(tbl, schema)
	local name = schema:_GetName()
	assert(not private.dbByNameLookup[name], "A database with this name already exists")
	private.dbByNameLookup[name] = tbl

	private.infoNameDB:NewRow()
		:SetField("name", name)
		:Create()

	for index, fieldName, fieldType, isIndex, isUnique in schema:_FieldIterator() do
		local fieldAttributes = (isIndex and isUnique and "index,unique") or (isIndex and "index") or (isUnique and "unique") or ""
		private.infoFieldDB:NewRow()
			:SetField("dbName", name)
			:SetField("field", fieldName)
			:SetField("type", fieldType)
			:SetField("attributes", fieldAttributes)
			:SetField("order", index)
			:Create()
	end
	for fieldName in schema:_MultiFieldIndexIterator() do
		private.infoFieldDB:NewRow()
			:SetField("dbName", name)
			:SetField("field", fieldName)
			:SetField("type", "-")
			:SetField("attributes", "multi-field index")
			:SetField("order", -1)
			:Create()
	end
end
