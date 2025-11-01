-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local VendorSearch = TSM.Shopping:NewPackage("VendorSearch")
local L = TSM.Locale.GetTable()
local ChatMessage = TSM.LibTSMService:Include("UI.ChatMessage")
local Threading = TSM.LibTSMTypes:Include("Threading")
local ItemInfo = TSM.LibTSMService:Include("Item.ItemInfo")
local AuctionSearchContext = TSM.LibTSMService:IncludeClassType("AuctionSearchContext")
local LibTSMClass = LibStub("LibTSMClass")
local VendorSearchContext = LibTSMClass.DefineClass("VendorSearchContext", AuctionSearchContext) ---@class VendorSearchContext: AuctionSearchContext
local private = {
	itemList = {},
	scanThreadId = nil,
	searchContext = nil ---@type VendorSearchContext,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function VendorSearch.OnInitialize()
	-- initialize thread
	private.scanThreadId = Threading.New("VENDOR_SEARCH", private.ScanThread)
	private.searchContext = VendorSearchContext(private.scanThreadId, private.MarketValueFunction)
end

function VendorSearch.GetSearchContext()
	return private.searchContext:SetScanContext(L["Vendor Search"], nil, nil, L["Vendor Sell Price"])
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
		local vendorSell = ItemInfo.GetVendorSell(itemString) or 0
		if vendorSell and minBuyout and minBuyout < vendorSell then
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
	local vendorSell = ItemInfo.GetVendorSell(itemString)
	return not vendorSell or itemBuyout == 0 or itemBuyout >= vendorSell
end

function private.MarketValueFunction(row)
	return ItemInfo.GetVendorSell(row:GetItemString() or row:GetBaseItemString())
end



-- ============================================================================
-- VendorSearchContext Class
-- ============================================================================

function VendorSearchContext:GetMaxCanBuy()
	-- Buy everything that's below the vendor cost
	return math.huge
end
