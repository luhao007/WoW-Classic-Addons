-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local FilterSearch = TSM.Shopping:NewPackage("FilterSearch")
local L = TSM.Include("Locale").GetTable()
local DisenchantInfo = TSM.Include("Data.DisenchantInfo")
local TempTable = TSM.Include("Util.TempTable")
local String = TSM.Include("Util.String")
local Log = TSM.Include("Util.Log")
local Threading = TSM.Include("Service.Threading")
local ItemFilter = TSM.Include("Service.ItemFilter")
local CustomPrice = TSM.Include("Service.CustomPrice")
local Conversions = TSM.Include("Service.Conversions")
local private = {
	scanThreadId = nil,
	itemFilter = nil,
	isSpecial = false,
	craftingModeTargetItem = nil,
	marketValueSource = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function FilterSearch.OnInitialize()
	-- initialize thread
	private.scanThreadId = Threading.New("FILTER_SEARCH", private.ScanThread)
	private.itemFilter = ItemFilter.New()
end

function FilterSearch.GetScanContext(isSpecial)
	private.isSpecial = isSpecial
	return private.scanThreadId, private.MarketValueFunction
end

function FilterSearch.PrepareFilter(filterStr, mode, marketValueSource)
	assert(mode == "NORMAL" or mode == "CRAFTING" or mode == "DISENCHANT")
	local isValid = true
	local filters = TempTable.Acquire()

	for filter in String.SplitIterator(filterStr, ";") do
		filter = strtrim(filter)
		if isValid and filter ~= "" and private.itemFilter:ParseStr(filter) then
			local str = private.itemFilter:GetStr()
			if mode == "CRAFTING" and not strfind(strlower(filter), "/crafting") and str then
				filter = filter.."/crafting"
			elseif mode == "DISENCHANT" and not strfind(strlower(filter), "/disenchant") and str then
				filter = filter.."/disenchant"
			end
			if strfind(strlower(filter), "/crafting") then
				local craftingTargetItem = str and Conversions.GetTargetItemByName(str) or nil
				if not craftingTargetItem or not Conversions.GetSourceItems(craftingTargetItem) then
					isValid = false
				end
			end
			if strfind(strlower(filter), "/disenchant") then
				local targetItemString = str and Conversions.GetTargetItemByName(str) or nil
				if not DisenchantInfo.IsTargetItem(targetItemString) then
					isValid = false
				end
			end
		else
			isValid = false
		end
		if isValid then
			tinsert(filters, filter)
		end
	end

	local result = table.concat(filters, ";")
	TempTable.Release(filters)
	if not isValid or result == "" then
		return
	end

	private.marketValueSource = marketValueSource
	return result
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread(auctionScan, filterStr)
	local hasFilter = false
	for filter in String.SplitIterator(filterStr, ";") do
		filter = strtrim(filter)
		if filter ~= "" and private.itemFilter:ParseStr(filter) then
			auctionScan:AddItemFilterThreaded(private.itemFilter)
			hasFilter = true
		end
	end
	if not hasFilter then
		Log.PrintUser(L["Invalid search filter"]..": "..filterStr)
		return false
	end
	if not private.isSpecial then
		TSM.Shopping.SavedSearches.RecordFilterSearch(filterStr)
	end

	-- run the scan
	auctionScan:StartScanThreaded()
	return true
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MarketValueFunction(row)
	local targetItem, targetItemRate = row:GetFields("targetItem", "targetItemRate")
	local value = CustomPrice.GetValue(private.marketValueSource, targetItem)
	if not value then
		return
	end
	return value * targetItemRate
end
