-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMUI = select(2, ...).LibTSMUI
local L = LibTSMUI.Locale.GetTable()
local AuctionHouseUIUtils = LibTSMUI:Include("AuctionHouse.AuctionHouseUIUtils")
local Tooltip = LibTSMUI:Include("Tooltip")
local UIElements = LibTSMUI:Include("Util.UIElements")
local UIUtils = LibTSMUI:Include("Util.UIUtils")
local ItemInfo = LibTSMUI:From("LibTSMService"):Include("Item.ItemInfo")
local TextureAtlas = LibTSMUI:From("LibTSMService"):Include("UI.TextureAtlas")
local Theme = LibTSMUI:From("LibTSMService"):Include("UI.Theme")
local ItemString = LibTSMUI:From("LibTSMTypes"):Include("Item.ItemString")
local TempTable = LibTSMUI:From("LibTSMUtil"):Include("BaseType.TempTable")
local Math = LibTSMUI:From("LibTSMUtil"):Include("Lua.Math")
local Table = LibTSMUI:From("LibTSMUtil"):Include("Lua.Table")
local Money = LibTSMUI:From("LibTSMUtil"):Include("UI.Money")
local private = {
	subRowsTemp = {}, ---@type AuctionSubRow[]
	subRowSortValueTemp = {},
}
local SUB_ROW_TINT_PCT = -20
local INDENT_WIDTH = 8
local ICON_SPACING = 4
local EXPANDER_TEXTURE_EXPANDED = "iconPack.12x12/Caret/Down"
local EXPANDER_TEXTURE_COLLAPSED = "iconPack.12x12/Caret/Right"
local RUNNING_TEXTURE = "iconPack.12x12/Running"
local COL_INFO = {
	item = {
		title = L["Item"],
		justifyH = "LEFT",
		font = "ITEM_BODY3",
		hasTooltip = true,
		disableHiding = true,
		disableReordering = true,
	},
	ilvl = {
		title = L["ilvl"],
		justifyH = "RIGHT",
		font = "TABLE_TABLE1",
	},
	qty = LibTSMUI.IsRetail() and {
		title = L["Qty"],
		justifyH = "RIGHT",
		font = "TABLE_TABLE1",
	} or nil,
	posts = not LibTSMUI.IsRetail() and {
		title = L["Posts"],
		justifyH = "RIGHT",
		font = "TABLE_TABLE1",
	} or nil,
	stack = not LibTSMUI.IsRetail() and {
		title = L["Stack"],
		justifyH = "RIGHT",
		font = "TABLE_TABLE1",
	} or nil,
	timeLeft = {
		titleIcon = "iconPack.14x14/Clock",
		justifyH = "CENTER",
		font = "TABLE_TABLE1",
	},
	seller = {
		title = L["Seller"],
		justifyH = "LEFT",
		font = "ITEM_BODY3",
	},
	itemBid = {
		title = L["Bid (item)"],
		justifyH = "RIGHT",
		font = "TABLE_TABLE1",
	},
	bid = {
		title = LibTSMUI.IsRetail() and L["Bid (stack)"] or L["Bid (total)"],
		justifyH = "RIGHT",
		font = "TABLE_TABLE1",
	},
	itemBuyout = {
		title = L["Buyout (item)"],
		justifyH = "RIGHT",
		font = "TABLE_TABLE1",
	},
	buyout = {
		title = LibTSMUI.IsRetail() and L["Buyout (stack)"] or L["Buyout (total)"],
		justifyH = "RIGHT",
		font = "TABLE_TABLE1",
	},
	bidPct = {
		title = BID.." %",
		justifyH = "RIGHT",
		font = "TABLE_TABLE1",
	},
	pct = {
		title = "%",
		justifyH = "RIGHT",
		font = "TABLE_TABLE1",
	},
}



-- ============================================================================
-- Element Definition
-- ============================================================================

local AuctionScrollTable = UIElements.Define("AuctionScrollTable", "ScrollTable")
AuctionScrollTable:_AddActionScripts("OnSelectionChanged")



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function AuctionScrollTable:__init(colInfo)
	self.__super:__init(colInfo or COL_INFO)
	self._customSourceItemStringDataCol = "item_tooltip"
	self._data.baseItemString = {}
	self._auctionScan = nil
	self._marketValueFunc = nil
	self._isPlayerFunc = nil
	self._expanded = {}
	self._rawData = {} ---@type AuctionRow|AuctionSubRow[]
	self._rowByItem = {} ---@type table<string,AuctionRow>
	self._currentSearchItem = nil
	self._browseResultsVisible = false
	self._selection = nil
	self._selectionBaseItemString = nil
	self._selectionBaseSortValue = nil
	self._selectionSubRowIndex = nil
	self._selectionDisabled = false
	self._pctTooltip = nil
	self._createdGroupName = nil

	self._header.cells.pct:TSMSetScript("OnEnter", self:__closure("_HandlePctHeaderEnter"))
	self._header.cells.pct:TSMSetScript("OnLeave", self:__closure("_HandlePctHeaderLeave"))
end

function AuctionScrollTable:Release()
	if self._auctionScan then
		self._auctionScan:RemoveResultsUpdateCallback(self:__closure("_UpdateData"))
		self._auctionScan:SetNextSearchItemFunction(nil)
		self._auctionScan:SetScript("OnCurrentSearchChanged", nil)
	end
	self._auctionScan = nil
	self._marketValueFunc = nil
	self._isPlayerFunc = nil
	wipe(self._expanded)
	wipe(self._rawData)
	wipe(self._rowByItem)
	self._currentSearchItem = nil
	self._browseResultsVisible = false
	self._selection = nil
	self._selectionBaseItemString = nil
	self._selectionBaseSortValue = nil
	self._selectionSubRowIndex = nil
	self._selectionDisabled = false
	self._pctTooltip = nil
	self._createdGroupName = nil
	self.__super:Release()
end

---Sets the name to assign to the group created from this table.
---@param name string The group name
---@return AuctionScrollTable
function AuctionScrollTable:SetCreatedGroupName(name)
	assert(name)
	self._createdGroupName = name
	return self
end

---Sets the auction scan to use to populate the table.
---@param auctionScan AuctionScanManager The auction scan object
---@return AuctionScrollTable
function AuctionScrollTable:SetAuctionScan(auctionScan)
	if auctionScan == self._auctionScan then
		return self
	end
	if self._auctionScan then
		self._auctionScan:RemoveResultsUpdateCallback(self:__closure("_UpdateData"))
		self._auctionScan:SetNextSearchItemFunction(nil)
		self._auctionScan:SetScript("OnCurrentSearchChanged", nil)
	end
	self._auctionScan = auctionScan
	auctionScan:AddResultsUpdateCallback(self:__closure("_UpdateData"))
	auctionScan:SetNextSearchItemFunction(self:__closure("_GetNextSearchItem"))
	auctionScan:SetScript("OnCurrentSearchChanged", self:__closure("_HandleCurrentSearchChanged"))
	wipe(self._expanded)
	self:_DrawSortFlag()
	self:_UpdateData()
	return self
end

---Sets whether or not browse results are visible.
---@param visible boolean Whether or not browse results should be visible
---@return AuctionScrollTable
function AuctionScrollTable:SetBrowseResultsVisible(visible)
	assert(not self._auctionScan)
	self._browseResultsVisible = visible
	return self
end

---Sets the function used to look up an item's market value.
---@param func fun(row: AuctionRow|AuctionSubRow): number? The function
---@return AuctionScrollTable
function AuctionScrollTable:SetMarketValueFunction(func)
	if func ~= self._marketValueFunc then
		self._marketValueFunc = func
		self:_UpdateData()
	end
	return self
end

---Sets the function to use to check if an owner string includes the player.
---@param func fun(ownerStr: string): boolean The function
---@return AuctionScrollTable
function AuctionScrollTable:SetIsPlayerFunction(func)
	assert(not self._auctionScan)
	self._isPlayerFunc = func
	return self
end

---Sets the tooltip for the percent column header.
---@param tooltip string The tooltip text
---@return AuctionScrollTable
function AuctionScrollTable:SetPctTooltip(tooltip)
	self._pctTooltip = tooltip
	return self
end

---Sets whether or not selection is disabled.
---@param disabled boolean
---@return AuctionScrollTable
function AuctionScrollTable:SetSelectionDisabled(disabled)
	self._selectionDisabled = disabled
	local dataIndex = self._selection and Table.KeyByValue(self._rawData, self._selection) or nil
	local row = dataIndex and self:_GetRow(dataIndex) or nil
	if row then
		row:SetSelected(not self._selectionDisabled)
	end
	return self
end

---Subscribes to a publisher to set whether or not the selection is disabled.
---@param publisher ReactivePublisher The publisher
---@return AuctionScrollTable
function AuctionScrollTable:SetSelectionDisabledPublisher(publisher)
	self:AddCancellable(publisher:CallMethod(self, "SetSelectionDisabled"))
	return self
end

---Sets the selected row
---@param selection? AuctionRow|AuctionSubRow The selected row
---@return AuctionScrollTable
function AuctionScrollTable:SetSelectedRow(selection)
	self:_SetSelectedRow(selection)
	return self
end

---Gets the selected result row.
---@return AuctionRow|AuctionSubRow|nil
function AuctionScrollTable:GetSelectedRow()
	return self._selection
end

---If there's a single auction row in the results, expand it.
function AuctionScrollTable:ExpandSingleResult()
	-- if only one result, expand it
	local firstRow = self._rawData[1]
	if #self._rawData ~= 1 or not firstRow:IsSubRow() then
		return
	end
	self:_SetExpanded(1, true)
end

--TODO: Remove this
function AuctionScrollTable:UpdateData()
	self:_UpdateData()
end



-- ============================================================================
-- Protected/Private Class Methods
-- ============================================================================

---@param updatedRow AuctionRow
function AuctionScrollTable.__protected:_UpdateData(_, _, updatedRow)
	if not self._auctionScan then
		return
	end
	if updatedRow and self:_HandleUpdatedAuctionRow(updatedRow) then
		-- Didn't need to do a full update
		return
	end
	wipe(self._rawData)
	wipe(self._rowByItem)
	local settings = self:_GetSettingsValue()
	local sortKey = settings.sortCol
	local sortAscending = settings.sortAscending

	-- Get the rows and sub rows
	local rows = TempTable.Acquire()
	local rowSortValue = TempTable.Acquire()
	local subRows = TempTable.Acquire()
	local subRowsStart = TempTable.Acquire()
	local subRowsEnd = TempTable.Acquire()
	assert(not next(private.subRowsTemp) and not next(private.subRowSortValueTemp))
	for _, query in self._auctionScan:QueryIterator() do
		for baseItemString, row in query:BrowseResultsIterator() do
			if not self._rowByItem[baseItemString] and row:HasItemInfo() then
				local hasSubRows = false
				for _, subRow in row:SubRowIterator() do
					hasSubRows = true
					private.subRowSortValueTemp[subRow] = self:_GetSortValue(subRow, sortKey, sortAscending)
					tinsert(private.subRowsTemp, subRow)
				end
				if hasSubRows then
					-- Sort all the subRows
					Table.SortWithValueLookup(private.subRowsTemp, private.subRowSortValueTemp, not sortAscending, private.SubRowSecondarySort)
					-- Grab the first subRow which is shown when this item is collapsed
					local firstSubRow = private.subRowsTemp[1]
					rowSortValue[row] = private.subRowSortValueTemp[firstSubRow]
					-- Add all the sub rows
					subRowsStart[baseItemString] = #subRows + 1
					for i = 1, self._expanded[baseItemString] and #private.subRowsTemp or 1 do
						tinsert(subRows, private.subRowsTemp[i])
					end
					subRowsEnd[baseItemString] = #subRows
					self._rowByItem[baseItemString] = row
					tinsert(rows, row)
				elseif self._browseResultsVisible then
					rowSortValue[row] = self:_GetSortValue(row, sortKey, sortAscending)
					self._rowByItem[baseItemString] = row
					tinsert(rows, row)
				end
				wipe(private.subRowsTemp)
				wipe(private.subRowSortValueTemp)
			end
		end
	end

	-- Clean up the expanded table
	for baseItemString in pairs(self._expanded) do
		if not self._rowByItem[baseItemString] then
			self._expanded[baseItemString] = nil
		end
	end

	-- Sort the rows
	Table.SortWithValueLookup(rows, rowSortValue, not sortAscending, private.RowSecondarySort)
	TempTable.Release(rowSortValue)

	-- Insert all the data
	for _, row in ipairs(rows) do
		local baseItemString = row:GetBaseItemString()
		if subRowsStart[baseItemString] then
			for i = subRowsStart[baseItemString], subRowsEnd[baseItemString] do
				tinsert(self._rawData, subRows[i])
			end
		else
			-- Insert the auction row as a placeholder for the pending browse results
			tinsert(self._rawData, row)
			assert(not self._expanded[baseItemString])
		end
	end
	TempTable.Release(rows)
	TempTable.Release(subRows)
	TempTable.Release(subRowsStart)
	TempTable.Release(subRowsEnd)

	-- Insert the full data
	for _, tbl in pairs(self._data) do
		wipe(tbl)
	end
	assert(self._createdGroupName)
	wipe(self._createGroupsData)
	local prevBaseItemString = nil
	for i, row in ipairs(self._rawData) do
		local baseItemString = row:GetBaseItemString()
		self:_SetDataForRow(i, row, baseItemString ~= prevBaseItemString)
		prevBaseItemString = baseItemString
		self._createGroupsData[baseItemString] = self._createdGroupName
	end
	self:_SetNumRows(#self._rawData)
	self:Draw()
	self:_UpdateSelectionData()
end

---@param updatedRow AuctionRow
function AuctionScrollTable.__protected:_HandleUpdatedAuctionRow(updatedRow)
	assert(not updatedRow:IsSubRow())
	local baseItemString = updatedRow:GetBaseItemString()
	local rowDataIndex = Table.KeyByValue(self._rawData, updatedRow)
	if self._rowByItem[baseItemString] ~= updatedRow then
		-- This was likely part of a different query, so just ignore it being updated
		return
	end

	local settings = self:_GetSettingsValue()
	local sortKey = settings.sortCol
	local sortAscending = settings.sortAscending
	if rowDataIndex then
		assert(not self._expanded[baseItemString])
		-- Get the first sub row
		local firstSubRow, firstSortValue = nil, nil
		for _, subRow in updatedRow:SubRowIterator() do
			local sortValue = self:_GetSortValue(subRow, sortKey, sortAscending)
			if not firstSubRow or (sortAscending and sortValue < firstSortValue) or (not sortAscending and sortValue > firstSortValue) or (sortValue == firstSortValue and private.SubRowSecondarySort(subRow, firstSubRow)) then
				firstSubRow = subRow
				firstSortValue = sortValue
			end
		end
		if firstSubRow then
			-- We just need to replace the placeholder row with the first sub row
			self:_ReplaceFirstSubRow(rowDataIndex, firstSubRow)
			self:_UpdateSelectionData()
		else
			-- Just update this placeholder row
			self:_DrawRowsForUpdatedData(rowDataIndex, rowDataIndex)
		end
		return
	end

	-- Get the new sub rows
	assert(not next(private.subRowsTemp) and not next(private.subRowSortValueTemp))
	for _, subRow in updatedRow:SubRowIterator() do
		private.subRowSortValueTemp[subRow] = self:_GetSortValue(subRow, sortKey, sortAscending)
		tinsert(private.subRowsTemp, subRow)
	end
	local numNewSubRows = #private.subRowsTemp
	assert(numNewSubRows > 0)
	Table.SortWithValueLookup(private.subRowsTemp, private.subRowSortValueTemp, not sortAscending, private.SubRowSecondarySort)

	-- NOTE: We need to be very careful here as any sub rows within self._rawData may no longer be valid, so shouldn't be accessed

	if not self._expanded[baseItemString] then
		-- Just need to replace the single sub row that we previously had
		assert(numNewSubRows > 0)
		for i = 1, #self._rawData do
			if self._data.baseItemString[i] == baseItemString then
				assert(not rowDataIndex)
				rowDataIndex = i
			end
		end
		assert(rowDataIndex)
		self:_ReplaceFirstSubRow(rowDataIndex, private.subRowsTemp[1])
		wipe(private.subRowSortValueTemp)
		wipe(private.subRowsTemp)
		self:_UpdateSelectionData()
		return
	end

	-- Get the data range of the upated row and check if they match the new rows
	local oldSubRows = TempTable.Acquire()
	local oldFirstDataIndex = nil
	for i, data in ipairs(self._rawData) do
		if self._data.baseItemString[i] == baseItemString then
			tinsert(oldSubRows, data)
			oldFirstDataIndex = oldFirstDataIndex or i
		end
	end
	local numOldSubRows = #oldSubRows
	assert(numOldSubRows > 0)
	-- Check for a simple diff between the old / new
	local insertedIndexes = TempTable.Acquire()
	local removedIndexes = TempTable.Acquire()
	if Table.GetDiffOrdered(oldSubRows, private.subRowsTemp, insertedIndexes, removedIndexes) then
		for _, index in Table.ReverseIPairs(removedIndexes) do
			local removedIndex = index + oldFirstDataIndex - 1
			self:_RemoveSubRows(removedIndex, removedIndex)
		end
		for _, index in ipairs(insertedIndexes) do
			-- Just a single inserted index
			local insertedIndex = index + oldFirstDataIndex - 1
			self:_InsertSubRow(insertedIndex, private.subRowsTemp[index], index == 1)
		end

		-- Update all the rows in case others also changed
		for i, subRow in ipairs(private.subRowsTemp) do
			self:_SetDataForRow(oldFirstDataIndex + i - 1, subRow, i == 1)
		end
		self:_DrawRowsForUpdatedData(oldFirstDataIndex, oldFirstDataIndex + numNewSubRows - 1)
		self:_UpdateSelectionData()

		TempTable.Release(insertedIndexes)
		TempTable.Release(removedIndexes)
		TempTable.Release(oldSubRows)
		wipe(private.subRowSortValueTemp)
		wipe(private.subRowsTemp)
		return
	else
		TempTable.Release(insertedIndexes)
		TempTable.Release(removedIndexes)
	end

	-- Remove all the existing sub rows
	self:_RemoveSubRows(oldFirstDataIndex, oldFirstDataIndex + numOldSubRows - 1)

	-- Insert the new rows
	local insertIndex = self:_GetRawDataMoveIndex(private.subRowsTemp[1], math.huge)
	self:_InsertSubRows(insertIndex, private.subRowsTemp, true)
	self:_UpdateSelectionData()

	TempTable.Release(oldSubRows)
	wipe(private.subRowSortValueTemp)
	wipe(private.subRowsTemp)
end

function AuctionScrollTable.__private:_ReplaceFirstSubRow(currentDataIndex, newSubRow)
	-- Update the data
	self._rawData[currentDataIndex] = newSubRow
	self:_SetDataForRow(currentDataIndex, newSubRow, true)

	-- Find the new index
	local insertIndex = self:_GetRawDataMoveIndex(newSubRow, currentDataIndex)
	if insertIndex == currentDataIndex then
		-- Just need to redraw the row
		self:_DrawRowsForUpdatedData(currentDataIndex, currentDataIndex)
		return
	end

	-- Move the data
	Table.Move(self._rawData, currentDataIndex, insertIndex)
	for _, data in pairs(self._data) do
		Table.Move(data, currentDataIndex, insertIndex)
	end

	-- Move the row
	self:_MoveRow(currentDataIndex, insertIndex)
end

function AuctionScrollTable.__private:_InsertSubRow(index, subRow, isFirstSubRow)
	Table.InsertMultipleAt(self._rawData, index, subRow)
	for _, data in pairs(self._data) do
		Table.InsertFill(data, index, 1, false)
	end
	self:_SetDataForRow(index, subRow, isFirstSubRow)
	self:_AddRows(index, 1)
end

function AuctionScrollTable.__private:_InsertSubRows(index, subRows, includesFirstSubRow)
	Table.InsertMultipleAt(self._rawData, index, unpack(subRows))
	for _, data in pairs(self._data) do
		Table.InsertFill(data, index, #subRows, false)
	end
	for i, subRow in ipairs(subRows) do
		self:_SetDataForRow(index + i - 1, subRow, includesFirstSubRow and i == 1)
	end
	self:_AddRows(index, #subRows)
end

function AuctionScrollTable.__private:_RemoveSubRows(firstIndex, lastIndex)
	Table.RemoveRange(self._rawData, firstIndex, lastIndex)
	for _, data in pairs(self._data) do
		Table.RemoveRange(data, firstIndex, lastIndex)
	end
	self:_RemoveRows(firstIndex, lastIndex - firstIndex + 1)
end

function AuctionScrollTable.__private:_SetSelectedRow(selection, silent)
	local dataIndex = selection and Table.KeyByValue(self._rawData, selection) or nil
	local prevDataIndex = self._selection and Table.KeyByValue(self._rawData, self._selection) or nil
	if private.RowsEqual(selection, self._selection) and (not selection or dataIndex) then
		if dataIndex then
			self:_ScrollToRow(dataIndex)
		end
		return self
	end
	local prevRow = prevDataIndex and self:_GetRow(prevDataIndex) or nil
	if prevRow then
		prevRow:SetSelected(false)
	end
	if dataIndex then
		local newRow = self:_GetRow(dataIndex)
		if newRow then
			newRow:SetSelected(true)
		end
		self._selection = selection
		local baseItemString = selection:GetBaseItemString()
		self._selectionBaseItemString = baseItemString
		local settings = self:_GetSettingsValue()
		self._selectionBaseSortValue = self:_GetSortValue(selection, settings.sortCol, settings.sortAscending)
		local firstIndex = nil
		self._selectionSubRowIndex = nil
		for i, data in ipairs(self._rawData) do
			if not firstIndex and data:GetBaseItemString() == baseItemString then
				firstIndex = i
			end
			if data == selection then
				self._selectionSubRowIndex = i - firstIndex + 1
				break
			end
		end
		assert(self._selectionSubRowIndex)
		self:_ScrollToRow(dataIndex)
	else
		self._selection = nil
		self._selectionBaseItemString = nil
		self._selectionBaseSortValue = nil
		self._selectionSubRowIndex = nil
	end
	if not silent then
		self:_SendActionScript("OnSelectionChanged")
	end
end

function AuctionScrollTable.__protected:_SetDataForRow(index, row, isFirstSubRow)
	local baseItemString = row:GetBaseItemString()
	self._data.baseItemString[index] = baseItemString
	if row:IsSubRow() then
		local itemLink, rawLink = row:GetLinks()
		local itemTexturePrefix = "|T"..ItemInfo.GetTexture(itemLink)..":0|t "
		self._data.item[index] = itemTexturePrefix..UIUtils.GetDisplayItemName(itemLink, not isFirstSubRow and SUB_ROW_TINT_PCT or nil)
		self._data.item_tooltip[index] = rawLink and ItemString.Get(rawLink) or row:GetItemString() or baseItemString
		self._data.ilvl[index] = ItemInfo.GetItemLevel(itemLink)
		local timeLeft = row:GetListingInfo()
		self._data.timeLeft[index] = UIUtils.GetTimeLeftString(timeLeft)
		local ownerStr = row:GetOwnerInfo()
		if self._isPlayerFunc(ownerStr) then
			self._data.seller[index] = Theme.GetColor("INDICATOR_ALT"):ColorText(ownerStr)
		else
			self._data.seller[index] = ownerStr
		end
		local displayedBid, itemDisplayedBid = row:GetDisplayedBids()
		local _, _, _, isHighBidder = row:GetBidInfo()
		local bidColor = isHighBidder and Theme.GetColor("FEEDBACK_GREEN"):GetTextColorPrefix() or nil
		self._data.itemBid[index] = Money.ToStringForAH(itemDisplayedBid, bidColor)
		self._data.bid[index] = Money.ToStringForAH(displayedBid, bidColor)
	else
		local itemString = row:GetItemString() or baseItemString
		local itemTexturePrefix = "|T"..ItemInfo.GetTexture(itemString)..":0|t "
		self._data.item[index] = itemTexturePrefix..UIUtils.GetDisplayItemName(itemString)
		self._data.item_tooltip[index] = itemString
		self._data.ilvl[index] = ItemInfo.GetItemLevel(itemString)
		self._data.timeLeft[index] = ""
		self._data.seller[index] = ""
		self._data.itemBid[index] = ""
		self._data.bid[index] = ""
	end

	local quantity, numAuctions = row:GetQuantities()
	if LibTSMUI.IsRetail() then
		self._data.qty[index] = quantity and numAuctions and (quantity * numAuctions) or ""
	else
		self._data.posts[index] = numAuctions or ""
		self._data.stack[index] = quantity or ""
	end
	local buyout, itemBuyout, minItemBuyout = row:GetBuyouts()
	itemBuyout = itemBuyout or minItemBuyout
	self._data.itemBuyout[index] = itemBuyout and Money.ToStringForAH(itemBuyout) or ""
	self._data.buyout[index] = buyout and Money.ToStringForAH(buyout) or ""
	local pct, bidPct = self:_GetMarketValuePct(row)
	pct = pct and Math.Round(pct * 100) or nil
	bidPct = bidPct and Math.Round(bidPct * 100) or nil
	self._data.bidPct[index] = AuctionHouseUIUtils.GetMarketValuePercentText(bidPct)
	if pct then
		self._data.pct[index] = AuctionHouseUIUtils.GetMarketValuePercentText(pct)
	elseif bidPct then
		self._data.pct[index] = AuctionHouseUIUtils.GetMarketValuePercentText(bidPct, true)
	else
		self._data.pct[index] = "---"
	end
end

function AuctionScrollTable.__private:_GetRawDataMoveIndex(searchRow, existingIndex)
	local settings = self:_GetSettingsValue()
	local sortKey = settings.sortCol
	local sortAscending = settings.sortAscending
	local searchSortValue = self:_GetSortValue(searchRow, sortKey, sortAscending)
	local low, high = 1, #self._rawData
	while low <= high do
		local mid = floor((low + high) / 2)
		if mid == existingIndex then
			if low == high then
				-- Insert back at the existing index
				return mid
			end
			-- Nudge the mid away from the existing index
			if mid == low then
				mid = mid + 1
			else
				mid = mid - 1
			end
		end
		local data = self._rawData[mid]
		local dataSortValue = self:_GetSortValue(data, sortKey, sortAscending)
		local sortResult = nil
		if dataSortValue == searchSortValue then
			sortResult = private.RowSecondarySort(data, searchRow)
		elseif sortAscending then
			sortResult = dataSortValue < searchSortValue
		else
			sortResult = dataSortValue > searchSortValue
		end
		if sortResult then
			low = mid + 1
		else
			high = mid - 1
		end
	end
	if existingIndex < low then
		-- Take into account the existing index being removed
		low = low - 1
	end
	return low
end

function AuctionScrollTable.__private:_UpdateSelectionData()
	-- Update the selection
	local selectionDataIndex = self._selection and Table.KeyByValue(self._rawData, self._selection)
	if selectionDataIndex then
		-- Update the sort value and sub row index
		local settings = self:_GetSettingsValue()
		self._selectionBaseSortValue = self:_GetSortValue(self._selection, settings.sortCol, settings.sortAscending)
		local firstSubRowIndex = nil
		for i = selectionDataIndex, 1, -1 do
			if i == 1 or self._data.baseItemString[i] ~= self._selectionBaseItemString then
				firstSubRowIndex = i
				break
			end
		end
		self._selectionSubRowIndex = selectionDataIndex - firstSubRowIndex + 1
		return
	end
	if not self._selection then
		return
	end
	assert(self._selectionBaseItemString)
	local nextIndexSelection, subRowIndex, newSelection = nil, nil, nil
	for _, row in ipairs(self._rawData) do
		if row:GetBaseItemString() == self._selectionBaseItemString then
			if row:IsSubRow() then
				subRowIndex = (subRowIndex or 0) + 1
				if self._selectionSubRowIndex == subRowIndex then
					-- This sub row is in the same position as the previous selection, so select it
					newSelection = row
					break
				end
				nextIndexSelection = row
			else
				-- Select the placeholder row
				newSelection = row
				break
			end
		elseif subRowIndex then
			-- Passed the end of the item
			break
		end
	end
	-- Select the next highest index of the same item if we don't otherwise have a new selection
	newSelection = newSelection or nextIndexSelection

	if not newSelection then
		-- Select the next row by sort value (if it exists)
		if not self._selectionBaseSortValue then
			self:_SetSelectedRow(nil)
			return
		end
		local settings = self:_GetSettingsValue()
		local sortKey = settings.sortCol
		local sortAscending = settings.sortAscending
		local bestSortValue, bestNewSelection, prevBaseItemString = nil, nil, nil
		for _, row in ipairs(self._rawData) do
			local baseItemString = row:GetBaseItemString()
			local sortValue = baseItemString ~= prevBaseItemString and self:_GetSortValue(row, sortKey, sortAscending)
			if sortValue then
				if not bestSortValue or (sortAscending and sortValue < bestSortValue) or (not sortAscending and sortValue > bestSortValue) then
					if (sortAscending and sortValue > self._selectionBaseSortValue) or (not sortAscending and sortValue < self._selectionBaseSortValue) then
						bestSortValue = sortValue
						bestNewSelection = row
					elseif sortValue == self._selectionBaseSortValue and baseItemString > self._selectionBaseItemString then
						bestSortValue = sortValue
						bestNewSelection = row
					end
				end
			end
			prevBaseItemString = baseItemString
		end
		if not bestNewSelection then
			self:_SetSelectedRow(nil)
			return
		end
		newSelection = bestNewSelection
	end

	assert(newSelection)
	-- Silently clear the existing selection first since it may have been removed
	self:_SetSelectedRow(nil, true)
	self:_SetSelectedRow(newSelection)
end

function AuctionScrollTable.__private:_GetNextSearchItem()
	if self._selection and not self._selection:IsSubRow() then
		-- The selected row has priority
		return self._selectionBaseItemString
	end
	for i, row in ipairs(self._rawData) do
		if not row:IsSubRow() then
			return self._data.baseItemString[i]
		end
	end
end

function AuctionScrollTable.__private:_HandleCurrentSearchChanged(_, baseItemString)
	if not baseItemString then
		-- The search was paused or unpaused, so just update the current item
		baseItemString = self._currentSearchItem
	end
	local prevSearchItem = self._currentSearchItem ~= baseItemString and self._currentSearchItem or nil
	self._currentSearchItem = baseItemString
	-- Update the pending icon
	for i, data in ipairs(self._rawData) do
		if not data:IsSubRow() and (data:GetBaseItemString() == baseItemString or data:GetBaseItemString() == prevSearchItem) then
			local row = self:_GetRow(i)
			if row then
				self:_DrawRunningIcon(row)
			end
		end
	end
end

---@param row AuctionRow|AuctionSubRow
function AuctionScrollTable.__protected:_GetSortValue(row, id, isAscending)
	if id == "item" then
		local baseItemString = row:GetBaseItemString()
		return ItemInfo.GetName(baseItemString)
	elseif id == "ilvl" then
		return ItemInfo.GetItemLevel(row:GetItemString() or row:GetBaseItemString())
	elseif id == "posts" then
		local _, numAuctions = row:GetQuantities()
		return numAuctions or (isAscending and math.huge or -math.huge)
	elseif id == "stack" then
		local quantity = row:GetQuantities()
		return quantity or (isAscending and math.huge or -math.huge)
	elseif id == "qty" then
		local quantity, numAuctions = row:GetQuantities()
		if not quantity or not numAuctions then
			return isAscending and math.huge or -math.huge
		end
		return quantity * numAuctions
	elseif id == "timeLeft" then
		if not row:IsSubRow() then
			return isAscending and math.huge or -math.huge
		end
		local timeLeft = row:GetListingInfo()
		return timeLeft
	elseif id == "seller" then
		if not row:IsSubRow() then
			return ""
		end
		local ownerStr = row:GetOwnerInfo()
		return ownerStr
	elseif id == "itemBid" then
		if not row:IsSubRow() then
			return isAscending and math.huge or -math.huge
		end
		local _, itemDisplayedBid = row:GetDisplayedBids()
		return itemDisplayedBid
	elseif id == "bid" then
		if not row:IsSubRow() then
			return isAscending and math.huge or -math.huge
		end
		local displayedBid = row:GetDisplayedBids()
		return displayedBid
	elseif id == "itemBuyout" then
		local _, itemBuyout, minItemBuyout = row:GetBuyouts()
		itemBuyout = itemBuyout or minItemBuyout or 0
		return itemBuyout == 0 and (isAscending and math.huge or -math.huge) or itemBuyout
	elseif id == "buyout" then
		local buyout = row:GetBuyouts() or 0
		return buyout == 0 and (isAscending and math.huge or -math.huge) or buyout
	elseif id == "bidPct" then
		local _, pct = self:_GetMarketValuePct(row)
		return pct or (isAscending and math.huge or -math.huge)
	elseif id == "pct" then
		local pct = self:_GetMarketValuePct(row)
		return pct or (isAscending and math.huge or -math.huge)
	else
		error("Invalid sort col id: "..tostring(id))
	end
end

---@param row AuctionRow|AuctionSubRow
function AuctionScrollTable.__private:_GetMarketValuePct(row)
	if not self._marketValueFunc then
		-- no market value function was set
		return nil, nil
	end
	local marketValue = self._marketValueFunc(row) or 0
	if marketValue == 0 then
		-- this item doesn't have a market value
		return nil, nil
	end
	local _, itemBuyout, minItemBuyout = row:GetBuyouts()
	itemBuyout = itemBuyout or minItemBuyout or 0
	local bidPct = nil
	if row:IsSubRow() then
		local _, itemDisplayedBid = row:GetDisplayedBids()
		bidPct = itemDisplayedBid / marketValue
	end
	return itemBuyout > 0 and itemBuyout / marketValue or nil, bidPct
end

function AuctionScrollTable.__protected:_IsFirstSubRow(dataIndex)
	return dataIndex == 1 or self._data.baseItemString[dataIndex] ~= self._data.baseItemString[dataIndex - 1]
end

function AuctionScrollTable.__private:_SetExpanded(dataIndex, expand)
	local data = self._rawData[dataIndex]
	local baseItemString = self._data.baseItemString[dataIndex]
	if (expand and true or false) == (self._expanded[baseItemString] and true or false) then
		return
	end

	if expand then
		self._expanded[baseItemString] = true
		-- Get the sub rows to insert
		local settings = self:_GetSettingsValue()
		local sortKey = settings.sortCol
		local sortAscending = settings.sortAscending
		assert(not next(private.subRowsTemp) and not next(private.subRowSortValueTemp))
		for _, subRow in self._rowByItem[baseItemString]:SubRowIterator() do
			private.subRowSortValueTemp[subRow] = self:_GetSortValue(subRow, sortKey, sortAscending)
			tinsert(private.subRowsTemp, subRow)
		end
		Table.SortWithValueLookup(private.subRowsTemp, private.subRowSortValueTemp, not sortAscending, private.SubRowSecondarySort)
		wipe(private.subRowSortValueTemp)
		assert(tremove(private.subRowsTemp, 1) == data)
		local numNewSubRows = #private.subRowsTemp
		if numNewSubRows > 0 then
			-- Add the new rows
			self:_InsertSubRows(dataIndex + 1, private.subRowsTemp, false)
		end
		wipe(private.subRowsTemp)
		-- Redraw the expanded row
		self:_DrawRowsForUpdatedData(dataIndex, dataIndex)
	else
		self._expanded[baseItemString] = nil
		-- Find the first sub row index
		local firstSubRowIndex = nil
		if self:_IsFirstSubRow(dataIndex) then
			firstSubRowIndex = dataIndex
		else
			for i = dataIndex - 1, 1, -1 do
				if self:_IsFirstSubRow(i) then
					assert(self._data.baseItemString[i] == baseItemString)
					firstSubRowIndex = i
					break
				end
			end
			assert(firstSubRowIndex)
		end
		-- Find the last sub row index
		local lastSubRowIndex = nil
		for i = firstSubRowIndex, #self._rawData do
			if self._data.baseItemString[i] == baseItemString then
				lastSubRowIndex = i
			end
		end
		assert(lastSubRowIndex)
		if firstSubRowIndex ~= lastSubRowIndex then
			-- Remove now-hidden rows
			self:_RemoveSubRows(firstSubRowIndex + 1, lastSubRowIndex)
		end
		-- Redraw the first sub row
		self:_DrawRowsForUpdatedData(firstSubRowIndex, firstSubRowIndex)
	end
end

function AuctionScrollTable.__protected:_HandlePctHeaderEnter(cell)
	Tooltip.Show(cell, self._pctTooltip)
end

function AuctionScrollTable.__protected:_HandlePctHeaderLeave()
	Tooltip.Hide()
end

---@param row ListRow
function AuctionScrollTable.__protected:_HandleRowAcquired(row)
	self.__super:_HandleRowAcquired(row)
	local item = row:GetText("item")
	local running = row:AddRotatingTexture("running")
	running:TSMSetSize(RUNNING_TEXTURE)
	running:SetPoint("LEFT", Theme.GetColSpacing() / 2, 0)
	local expander = row:AddTexture("expander")
	expander:TSMSetSize(EXPANDER_TEXTURE_EXPANDED)
	expander:SetPoint("RIGHT", item, "LEFT", -ICON_SPACING, 0)
	local badge = row:AddText("badge")
	badge:SetJustifyH("RIGHT")
	badge:TSMSetFont("TABLE_TABLE1")
	badge:TSMSubscribeTextColor("INDICATOR")
	badge:SetHeight(item:GetHeight())
	badge:SetPoint("LEFT", item, "RIGHT", ICON_SPACING, 0)
end

---@param row ListRow
function AuctionScrollTable.__protected:_HandleRowDraw(row)
	self.__super:_HandleRowDraw(row)
	local dataIndex = row:GetDataIndex()
	local data = self._rawData[dataIndex]
	local baseItemString = self._data.baseItemString[dataIndex]
	local numSubRows = data:IsSubRow() and data:GetResultRow():GetNumSubRows() or 0
	local isExpanded = self._expanded[baseItemString]
	local itemWidthReduction = 0
	local text = row:GetText("item")
	local expander = row:GetTexture("expander")
	local badge = row:GetText("badge")
	local colSpacing = Theme.GetColSpacing()

	if isExpanded and not self:_IsFirstSubRow(dataIndex) then
		expander:Hide()
		text:SetPoint("LEFT", self._header.moreButton:GetWidth() + colSpacing * 1.5 + INDENT_WIDTH, 0)
		itemWidthReduction = itemWidthReduction + INDENT_WIDTH
	else
		if numSubRows > 1 then
			expander:Show()
			expander:TSMSetTexture(isExpanded and EXPANDER_TEXTURE_EXPANDED or EXPANDER_TEXTURE_COLLAPSED)
		else
			expander:Hide()
		end
	end

	self:_DrawRunningIcon(row)

	if not isExpanded and numSubRows > 1 then
		badge:Show()
		badge:SetText(numSubRows > 999 and "(999+)" or "("..numSubRows..")")
		badge:SetPoint("LEFT", text, "RIGHT", ICON_SPACING, 0)
		local width = badge:GetUnboundedStringWidth()
		badge:SetWidth(width)
		itemWidthReduction = itemWidthReduction + width + ICON_SPACING
		for _, colSettings in ipairs(self:_GetSettingsValue().cols) do
			local id = colSettings.id
			if id ~= "item" and not colSettings.hidden then
				row:GetText(id):SetPoint("LEFT", badge, "RIGHT", colSpacing, 0)
				break
			end
		end
	else
		badge:Hide()
	end

	if itemWidthReduction > 0 then
		text:SetWidth(text:GetWidth() - itemWidthReduction)
	end

	row:SetSelected(data == self._selection)
end

---@param row ListRow
function AuctionScrollTable.__protected:_DrawRunningIcon(row)
	local dataIndex = row:GetDataIndex()
	local data = self._rawData[dataIndex]
	local running = row:GetRotatingTexture("running")
	if data:IsSubRow() then
		running.ag:Stop()
		running:Hide()
	elseif self._data.baseItemString[dataIndex] == self._currentSearchItem then
		running:TSMSetTexture(RUNNING_TEXTURE)
		local _, isPaused = self._auctionScan:GetProgress()
		if isPaused then
			running.ag:Stop()
		else
			running.ag:Play()
		end
	else
		running:TSMSetTexture(TextureAtlas.GetColoredKey(RUNNING_TEXTURE, "ACTIVE_BG_ALT"))
		running:Show()
		running.ag:Stop()
	end
end

---@param row ListRow
function AuctionScrollTable.__protected:_HandleRowClick(row, mouseButton)
	local dataIndex = row:GetDataIndex()
	local expander = row:GetTexture("expander")
	if expander:IsVisible() and expander:IsMouseOver() then
		self:_SetExpanded(dataIndex, not self._expanded[self._data.baseItemString[dataIndex]])
		return
	elseif mouseButton ~= "LeftButton" or self._selectionDisabled then
		return
	end
	self:SetSelectedRow(self._rawData[dataIndex])
end

---@param row ListRow
function AuctionScrollTable.__protected:_HandleRowDoubleClick(row, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	elseif not row:GetTexture("expander"):IsVisible() then
		return
	end
	local dataIndex = row:GetDataIndex()
	self:_SetExpanded(dataIndex, not self._expanded[self._data.baseItemString[dataIndex]])
end

function AuctionScrollTable.__protected:_HandleHeaderCellClick(button, mouseButton)
	if not self.__super:_HandleHeaderCellClick(button, mouseButton) then
		return
	end
	self:_UpdateData()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.RowSecondarySort(a, b)
	return a:GetBaseItemString() < b:GetBaseItemString()
end

function private.SubRowSecondarySort(a, b)
	-- Order by item buyout
	local _, aItemBuyout = a:GetBuyouts()
	local _, bItemBuyout = b:GetBuyouts()
	if aItemBuyout ~= bItemBuyout then
		return aItemBuyout < bItemBuyout
	end

	-- Show the higher auctionId first
	local _, aAuctionId, aBrowseId = a:GetListingInfo()
	local _, bAuctionId, bBrowseId = b:GetListingInfo()
	if aAuctionId ~= bAuctionId then
		return aAuctionId > bAuctionId
	end

	-- Show the higher browseId first
	return aBrowseId > bBrowseId
end

---@param a? AuctionRow|AuctionSubRow
---@param b? AuctionRow|AuctionSubRow
function private.RowsEqual(a, b)
	if not a or not b then
		return a == b
	elseif a:IsSubRow() ~= b:IsSubRow() then
		return false
	elseif a:IsSubRow() then
		return a:GetHashes() == b:GetHashes()
	else
		return a:GetBaseItemString() == b:GetBaseItemString()
	end
end
