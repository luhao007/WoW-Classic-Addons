-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local SavedSearches = TSM.Shopping:NewPackage("SavedSearches")
local Log = TSM.Include("Util.Log")
local Database = TSM.Include("Util.Database")
local TempTable = TSM.Include("Util.TempTable")
local private = {
	db = nil,
}
local MAX_RECENT_SEARCHES = 2000



-- ============================================================================
-- Module Functions
-- ============================================================================

function SavedSearches.OnInitialize()
	-- remove duplicates
	local keepSearch = TempTable.Acquire()
	for _, data in ipairs(TSM.db.global.userData.savedShoppingSearches) do
		data.searchMode = nil -- clear out old 4.9.x data
		local filter = strlower(data.filter)
		if not keepSearch[filter] then
			keepSearch[filter] = data
		else
			if data.isFavorite == keepSearch[filter].isFavorite then
				if data.lastSearch > keepSearch[filter].lastSearch then
					keepSearch[filter] = data
				end
			elseif data.isFavorite then
				keepSearch[filter] = data
			end
		end
	end
	for i = #TSM.db.global.userData.savedShoppingSearches, 1, -1 do
		if not keepSearch[strlower(TSM.db.global.userData.savedShoppingSearches[i].filter)] then
			tremove(TSM.db.global.userData.savedShoppingSearches, i)
		end
	end
	TempTable.Release(keepSearch)

	-- remove old recent searches
	local remainingRecentSearches = MAX_RECENT_SEARCHES
	local numRemoved = 0
	for i = #TSM.db.global.userData.savedShoppingSearches, 1, -1 do
		if not TSM.db.global.userData.savedShoppingSearches[i].isFavorite then
			if remainingRecentSearches > 0 then
				remainingRecentSearches = remainingRecentSearches - 1
			else
				tremove(TSM.db.global.userData.savedShoppingSearches, i)
				numRemoved = numRemoved + 1
			end
		end
	end
	if numRemoved > 0 then
		Log.Info("Removed %d old recent searches", numRemoved)
	end

	private.db = Database.NewSchema("SHOPPING_SAVED_SEARCHES")
		:AddUniqueNumberField("index")
		:AddStringField("name")
		:AddNumberField("lastSearch")
		:AddBooleanField("isFavorite")
		:AddStringField("filter")
		:AddIndex("index")
		:AddIndex("lastSearch")
		:AddIndex("name")
		:Commit()
	private.db:BulkInsertStart()
	for index, data in pairs(TSM.db.global.userData.savedShoppingSearches) do
		private.db:BulkInsertNewRow(index, data.name, data.lastSearch, data.isFavorite and true or false, data.filter)
	end
	private.db:BulkInsertEnd()
end

function SavedSearches.CreateRecentSearchesQuery()
	return private.db:NewQuery()
		:OrderBy("lastSearch", false)
end

function SavedSearches.CreateFavoriteSearchesQuery()
	return private.db:NewQuery()
		:Equal("isFavorite", true)
		:OrderBy("name", true)
end

function SavedSearches.SetSearchIsFavorite(dbRow, isFavorite)
	TSM.db.global.userData.savedShoppingSearches[dbRow:GetField("index")].isFavorite = isFavorite or nil
	dbRow:SetField("isFavorite",  isFavorite)
		:Update()
end

function SavedSearches.RenameSearch(dbRow, newName)
	TSM.db.global.userData.savedShoppingSearches[dbRow:GetField("index")].name = newName
	dbRow:SetField("name", newName)
		:Update()
end

function SavedSearches.DeleteSearch(dbRow)
	local index = dbRow:GetField("index")
	tremove(TSM.db.global.userData.savedShoppingSearches, index)
	private.db:SetQueryUpdatesPaused(true)
	private.db:DeleteRow(dbRow)
	-- need to decrement the index fields of all the rows which got shifted up
	local query = private.db:NewQuery()
		:GreaterThan("index", index)
		:OrderBy("index", true)
	for _, row in query:Iterator() do
		row:SetField("index", row:GetField("index") - 1)
			:Update()
	end
	query:Release()
	private.db:SetQueryUpdatesPaused(false)
end

function SavedSearches.RecordFilterSearch(filter)
	local found = false
	for i, data in ipairs(TSM.db.global.userData.savedShoppingSearches) do
		if strlower(data.filter) == strlower(filter) then
			data.lastSearch = time()
			local row = private.db:GetUniqueRow("index", i)
			row:SetField("lastSearch", data.lastSearch)
				:Update()
			row:Release()
			found = true
			break
		end
	end
	if not found then
		local data = {
			name = filter,
			filter = filter,
			lastSearch = time(),
			isFavorite = nil,
		}
		tinsert(TSM.db.global.userData.savedShoppingSearches, data)
		private.db:NewRow()
			:SetField("index", #TSM.db.global.userData.savedShoppingSearches)
			:SetField("name", data.name)
			:SetField("lastSearch", data.lastSearch)
			:SetField("isFavorite", data.isFavorite and true or false)
			:SetField("filter", data.filter)
			:Create()
	end
end
