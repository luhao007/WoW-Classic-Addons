-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local BuyoutSearch = TSM.Sniper:NewPackage("BuyoutSearch")
local SoundAlert = TSM.LibTSMWoW:Include("UI.SoundAlert")
local ClientInfo = TSM.LibTSMWoW:Include("Util.ClientInfo")
local Group = TSM.LibTSMTypes:Include("Group")
local Threading = TSM.LibTSMTypes:Include("Threading")
local ItemInfo = TSM.LibTSMService:Include("Item.ItemInfo")
local SniperOperation = TSM.LibTSMSystem:Include("SniperOperation")
local private = {
	settings = nil,
	scanThreadId = nil,
	searchContext = nil,
}
local RESCAN_DELAY = ClientInfo.IsVanillaClassic() and 0 or 30



-- ============================================================================
-- Module Functions
-- ============================================================================

function BuyoutSearch.OnInitialize(settingsDB)
	private.settings = settingsDB:NewView()
		:AddKey("global", "sniperOptions", "sniperSound")
	private.scanThreadId = Threading.New("SNIPER_BUYOUT_SEARCH", private.ScanThread)
	private.searchContext = TSM.Sniper.SniperSearchContext(private.scanThreadId, private.MarketValueFunction, "BUYOUT")
end

function BuyoutSearch.GetSearchContext()
	return private.searchContext
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

---@param auctionScan AuctionScanManager
function private.ScanThread(auctionScan)
	local numQueries = auctionScan:GetNumQueries()
	if numQueries == 0 then
		local query = auctionScan:NewQuery()
			:AddCustomFilter(private.QueryFilter)
		if ClientInfo.IsVanillaClassic() then
			query:SetPage("LAST")
		end
	end
	auctionScan:SetScript("OnQueryDone", private.OnQueryDone)
	-- Just constantly rerun the scan until the thread is killed (don't care if it fails)
	while true do
		auctionScan:ScanQueriesThreaded()
		auctionScan:SleepThreaded(RESCAN_DELAY)
	end
end

function private.QueryFilter(_, subRow, isSubRow, itemKey)
	local baseItemString = subRow:GetBaseItemString()
	local itemString = subRow:GetItemString()
	local maxPrice = itemString and SniperOperation.GetMaxPrice(itemString) or nil
	if itemString and not maxPrice then
		-- No Sniper operation applies to this item, so filter it out
		return true
	end
	local auctionBuyout, itemBuyout, minItemBuyout = subRow:GetBuyouts()
	itemBuyout = itemBuyout or minItemBuyout
	if not itemBuyout then
		-- Don't have buyout info yet, so don't filter
		return false
	elseif auctionBuyout == 0 then
		-- No buyout, so filter it out
		return true
	elseif itemString then
		-- Filter if the buyout is too high
		return itemBuyout > maxPrice
	elseif not ClientInfo.IsVanillaClassic() or not ItemInfo.CanHaveVariations(baseItemString) then
		-- Check the buyout against the base item
		maxPrice = SniperOperation.GetMaxPrice(baseItemString) or 0
		return itemBuyout > maxPrice
	end

	-- Check if any variant of this item is in a group and could potentially be worth scanning
	local hasPotentialItem = false
	for _, groupItemString in Group.ItemByBaseItemStringIterator(baseItemString) do
		hasPotentialItem = hasPotentialItem or itemBuyout < (SniperOperation.GetMaxPrice(groupItemString) or 0)
	end
	if hasPotentialItem then
		return false
	elseif not SniperOperation.HasOperation(baseItemString) then
		-- No potential other variants we care about
		return true
	end
	return false
end

function private.MarketValueFunction(row)
	local itemString = row:GetItemString()
	return itemString and SniperOperation.GetMaxPrice(itemString) or nil
end

function private.OnQueryDone(_, _, numNewResults)
	if numNewResults > 0 then
		SoundAlert.Play(private.settings.sniperSound)
	end
end
