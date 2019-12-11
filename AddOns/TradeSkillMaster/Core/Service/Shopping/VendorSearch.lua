-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local VendorSearch = TSM.Shopping:NewPackage("VendorSearch")
local L = TSM.Include("Locale").GetTable()
local Log = TSM.Include("Util.Log")
local Threading = TSM.Include("Service.Threading")
local ItemInfo = TSM.Include("Service.ItemInfo")
local private = {
	itemList = {},
	scanThreadId = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function VendorSearch.OnInitialize()
	-- initialize thread
	private.scanThreadId = Threading.New("VENDOR_SEARCH", private.ScanThread)
end

function VendorSearch.GetScanContext()
	return private.scanThreadId, private.MarketValueFunction
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread(auctionScan)
	if (TSM.AuctionDB.GetLastCompleteScanTime() or 0) < time() - 60 * 60 * 12 then
		Log.PrintUser(L["No recent AuctionDB scan data found."])
		return false
	end
	auctionScan:SetCustomFilterFunc(private.ScanFilter)

	-- create the list of items, and add filters for them
	wipe(private.itemList)
	for _, itemString, _, minBuyout in TSM.AuctionDB.LastScanIteratorThreaded() do
		local vendorSell = ItemInfo.GetVendorSell(itemString) or 0
		if vendorSell and minBuyout and minBuyout < vendorSell then
			tinsert(private.itemList, itemString)
		end
		Threading.Yield()
	end
	auctionScan:AddItemListFiltersThreaded(private.itemList)

	-- run the scan
	auctionScan:StartScanThreaded()
	return true
end

function private.ScanFilter(itemString, itemBuyout)
	local vendorSell = ItemInfo.GetVendorSell(itemString)
	return not vendorSell or itemBuyout == 0 or itemBuyout >= vendorSell
end

function private.MarketValueFunction(row)
	return ItemInfo.GetVendorSell(row:GetField("itemString"))
end
