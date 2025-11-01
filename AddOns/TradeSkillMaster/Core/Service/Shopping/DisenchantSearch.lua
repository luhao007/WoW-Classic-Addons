-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local DisenchantSearch = TSM.Shopping:NewPackage("DisenchantSearch") ---@type AddonPackage
local CustomString = TSM.LibTSMTypes:Include("CustomString")
local L = TSM.Locale.GetTable()
local ChatMessage = TSM.LibTSMService:Include("UI.ChatMessage")
local Threading = TSM.LibTSMTypes:Include("Threading")
local ItemInfo = TSM.LibTSMService:Include("Item.ItemInfo")
local AuctionSearchContext = TSM.LibTSMService:IncludeClassType("AuctionSearchContext")
local private = {
	settings = nil,
	itemList = {},
	scanThreadId = nil,
	searchContext = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function DisenchantSearch.OnInitialize(settingsDB)
	private.settings = settingsDB:NewView()
		:AddKey("global", "shoppingOptions", "minDeSearchLvl")
		:AddKey("global", "shoppingOptions", "maxDeSearchLvl")
		:AddKey("global", "shoppingOptions", "maxDeSearchPercent")
	private.scanThreadId = Threading.New("DISENCHANT_SEARCH", private.ScanThread)
	private.searchContext = AuctionSearchContext(private.scanThreadId, private.MarketValueFunction)
end

function DisenchantSearch.GetSearchContext()
	return private.searchContext:SetScanContext(L["Disenchant Search"], nil, nil, L["Disenchant Value"])
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread(auctionScan)
	if TSM.AuctionDB.GetAppDataUpdateTimes() < time() - 60 * 60 * 12 then
		ChatMessage.PrintUser(L["No recent AuctionDB scan data found."])
		return false
	end

	-- create the list of items
	wipe(private.itemList)
	for itemString, minBuyout in TSM.AuctionDB.LastScanIteratorThreaded() do
		if minBuyout and private.ShouldInclude(itemString, minBuyout) then
			tinsert(private.itemList, itemString)
		end
		Threading.Yield()
	end

	-- run the scan
	auctionScan:AddItemListQueriesThreaded(private.itemList)
	for _, query in auctionScan:QueryIterator() do
		query:AddCustomFilter(private.QueryFilter)
	end
	if not auctionScan:ScanQueriesThreaded() then
		ChatMessage.PrintUser(L["TSM failed to scan some auctions. Please rerun the scan."])
	end

end

function private.ShouldInclude(itemString, minBuyout)
	if not ItemInfo.IsDisenchantable(itemString) then
		return false
	end

	local itemLevel = ItemInfo.GetItemLevel(itemString) or -1
	if itemLevel < private.settings.minDeSearchLvl or itemLevel > private.settings.maxDeSearchLvl then
		return false
	end

	if private.IsItemBuyoutTooHigh(itemString, minBuyout) then
		return false
	end

	return true
end

function private.QueryFilter(_, row)
	local itemString = row:GetItemString()
	if not itemString then
		return false
	end
	local _, itemBuyout = row:GetBuyouts()
	if not itemBuyout then
		return false
	end
	return private.IsItemBuyoutTooHigh(itemString, itemBuyout)
end

function private.IsItemBuyoutTooHigh(itemString, itemBuyout)
	local disenchantValue = CustomString.GetSourceValue("Destroy", itemString)
	return not disenchantValue or itemBuyout > private.settings.maxDeSearchPercent / 100 * disenchantValue
end

function private.MarketValueFunction(row)
	return CustomString.GetSourceValue("Destroy", row:GetItemString() or row:GetBaseItemString())
end
