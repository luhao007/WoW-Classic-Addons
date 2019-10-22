-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--          http://www.curse.com/addons/wow/tradeskillmaster_warehousing          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AuctionTracking = TSM.Inventory:NewPackage("AuctionTracking")
local private = {
	db = nil,
	updateQuery = nil,
	isAHOpen = false,
	callbacks = {},
	indexUpdates = {
		list = {},
		pending = {},
	},
	lastScanNum = nil,
	ignoreUpdateEvent = nil,
}
local PLAYER_NAME = UnitName("player")
local SALE_HINT_SEP = "\001"
local SALE_HINT_EXPIRE_TIME = 33 * 24 * 60 * 60



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionTracking.OnInitialize()
	TSM.Event.Register("AUCTION_HOUSE_SHOW", private.AuctionHouseShowHandler)
	TSM.Event.Register("AUCTION_HOUSE_CLOSED", private.AuctionHouseClosedHandler)
	if select(4, GetBuildInfo()) < 80300 then
		TSM.Event.Register("AUCTION_OWNED_LIST_UPDATE", private.AuctionOwnedListUpdateHandler)
	else
		TSM.Event.Register("OWNED_AUCTIONS_UPDATED", private.AuctionOwnedListUpdateHandler)
	end
	private.db = TSMAPI_FOUR.Database.NewSchema("AUCTION_TRACKING")
		:AddUniqueNumberField("index")
		:AddStringField("itemString")
		:AddSmartMapField("baseItemString", TSM.Item.GetBaseItemStringMap(), "itemString")
		:AddSmartMapField("autoBaseItemString", TSM.Groups.GetAutoBaseItemStringSmartMap(), "itemString")
		:AddStringField("itemLink")
		:AddNumberField("itemTexture")
		:AddStringField("itemName")
		:AddNumberField("itemQuality")
		:AddNumberField("duration")
		:AddStringField("highBidder")
		:AddNumberField("currentBid")
		:AddNumberField("buyout")
		:AddNumberField("stackSize")
		:AddNumberField("saleStatus")
		:AddIndex("index")
		:AddIndex("autoBaseItemString")
		:AddIndex("saleStatus")
		:Commit()
	private.updateQuery = private.db:NewQuery()
		:SetUpdateCallback(private.OnCallbackQueryUpdated)
	for info, timestamp in pairs(TSM.db.char.internalData.auctionSaleHints) do
		if time() > timestamp + SALE_HINT_EXPIRE_TIME then
			TSM.db.char.internalData.auctionSaleHints[info] = nil
		end
	end

	if select(4, GetBuildInfo()) < 80300 then
		hooksecurefunc("PostAuction", function(_, _, duration)
			private.PostAuctionHookHandler(duration)
		end)
	else
		hooksecurefunc(C_AuctionHouse, "PostCommodity", function(_, duration)
			private.PostAuctionHookHandler(duration)
		end)
		hooksecurefunc(C_AuctionHouse, "PostItem", function(_, duration)
			private.PostAuctionHookHandler(duration)
		end)
	end
end

function AuctionTracking.RegisterCallback(callback)
	tinsert(private.callbacks, callback)
end

function AuctionTracking.DatabaseFieldIterator()
	return private.db:FieldIterator()
end

function AuctionTracking.CreateQuery()
	return private.db:NewQuery()
end

function AuctionTracking.GetFieldByIndex(index, field)
	return private.db:GetUniqueRowField("index", index, field)
end

function AuctionTracking.GetSaleHintItemString(name, stackSize, buyout)
	for info in pairs(TSM.db.char.internalData.auctionSaleHints) do
		local infoName, itemString, infoStackSize, infoBuyout = strsplit(SALE_HINT_SEP, info)
		if infoName == name and tonumber(infoStackSize) == stackSize and tonumber(infoBuyout) == buyout then
			return itemString
		end
	end
end



-- ============================================================================
-- Event Handlers
-- ============================================================================

function private.AuctionHouseShowHandler()
	private.isAHOpen = true
	private.QueryOwnedAuctions()
	-- We don't always get AUCTION_OWNED_LIST_UPDATE events, so do our own scanning if needed
	TSMAPI_FOUR.Delay.AfterTime("AUCTION_BACKGROUND_SCAN", 1, private.DoBackgroundScan, 1)
end

function private.AuctionHouseClosedHandler()
	private.isAHOpen = false
	TSMAPI_FOUR.Delay.Cancel("AUCTION_BACKGROUND_SCAN")
end

function private.DoBackgroundScan()
	if private.GetNumOwnedAuctions() ~= private.lastScanNum then
		private.AuctionOwnedListUpdateHandler()
	end
end

function private.AuctionOwnedListUpdateHandler()
	if private.ignoreUpdateEvent then
		return
	end
	wipe(private.indexUpdates.pending)
	wipe(private.indexUpdates.list)
	private.QueryOwnedAuctions()
	for i = 1, private.GetNumOwnedAuctions() do
		if not private.indexUpdates.pending[i] then
			private.indexUpdates.pending[i] = true
			tinsert(private.indexUpdates.list, i)
		end
	end
	TSMAPI_FOUR.Delay.AfterFrame("AUCTION_OWNED_LIST_SCAN", 2, private.AuctionOwnedListUpdateDelayed)
end

function private.AuctionOwnedListUpdateDelayed()
	if not private.isAHOpen then
		return
	elseif AuctionFrame and AuctionFrame:IsVisible() and AuctionFrame.selectedTab == 3 then
		-- default UI auctions tab is visible, so scan later
		TSMAPI_FOUR.Delay.AfterFrame("AUCTION_OWNED_LIST_SCAN", 2, private.AuctionOwnedListUpdateDelayed)
		return
	elseif select(4, GetBuildInfo()) >= 80300 and not C_AuctionHouse.HasFullOwnedAuctionResults() then
		-- don't have all the results yet, so try again in a moment
		TSMAPI_FOUR.Delay.AfterFrame("AUCTION_OWNED_LIST_SCAN", 0.1, private.AuctionOwnedListUpdateDelayed)
		return
	end
	if select(4, GetBuildInfo()) < 80300 then
		-- check if we need to change the sort
		local needsSort = false
		local numColumns = #AuctionSort.owner_duration
		for i, info in ipairs(AuctionSort.owner_duration) do
			local col, reversed = GetAuctionSort("owner", numColumns - i + 1)
			-- we want to do the opposite order
			reversed = not reversed
			if col ~= info.column or info.reverse ~= reversed then
				needsSort = true
				break
			end
		end
		if needsSort then
			TSM:LOG_INFO("Sorting owner auctions")
			-- ignore events while changing the sort
			private.ignoreUpdateEvent = true
			AuctionFrame_SetSort("owner", "duration", true)
			SortAuctionApplySort("owner")
			private.ignoreUpdateEvent = nil
		end
	end

	-- scan the auctions
	TSM.Inventory.WipeAuctionQuantity()

	private.db:TruncateAndBulkInsertStart()
	local expire = math.huge
	for i = #private.indexUpdates.list, 1, -1 do
		local index = private.indexUpdates.list[i]
		local auctionId, link, name, texture, stackSize, quality, minBid, buyout, bid, highBidder, saleStatus, duration = private.GetOwnedAuctionInfo(index)
		name = name or TSMAPI_FOUR.Item.GetName(link)
		texture = texture or TSMAPI_FOUR.Item.GetTexture(link)
		quality = quality or TSMAPI_FOUR.Item.GetQuality(link)
		if link and name and texture and quality then
			assert(saleStatus == 0 or saleStatus == 1)
			duration = saleStatus == 0 and duration or (time() + duration)
			if saleStatus == 0 then
				if duration == 1 then -- 30 min
					expire = min(expire, time() + 0.5 * 60 * 60)
				elseif duration == 2 then -- 2 hours
					expire = min(expire, time() + 2 * 60 * 60)
				elseif duration == 3 then -- 12 hours
					expire = min(expire, time() + 12 * 60 * 60)
				end
			end
			highBidder = highBidder or ""
			local itemString = TSMAPI_FOUR.Item.ToItemString(link)
			local currentBid = highBidder ~= "" and bid or minBid
			if saleStatus == 0 then
				TSM.Inventory.ChangeAuctionQuantity(TSMAPI_FOUR.Item.ToBaseItemString(itemString), stackSize)
				local hintInfo = strjoin(SALE_HINT_SEP, TSMAPI_FOUR.Item.GetName(link), itemString, stackSize, buyout)
				TSM.db.char.internalData.auctionSaleHints[hintInfo] = time()
			end
			private.indexUpdates.pending[index] = nil
			tremove(private.indexUpdates.list, i)
			private.db:BulkInsertNewRow(auctionId, itemString, link, texture, name, quality, duration, highBidder, currentBid, buyout, stackSize, saleStatus)
		end
	end
	private.db:BulkInsertEnd()

	if expire ~= math.huge then
		if (TSM.db.factionrealm.internalData.expiringAuction[PLAYER_NAME] or math.huge) > expire then
			TSM.db.factionrealm.internalData.expiringAuction[PLAYER_NAME] = expire
			TSM.TaskList.Expirations.Update()
		end
	end

	TSM:LOG_INFO("Scanned auctions (left=%d)", #private.indexUpdates.list)
	if #private.indexUpdates.list > 0 then
		-- some failed to scan so try again
		TSMAPI_FOUR.Delay.AfterFrame("AUCTION_OWNED_LIST_SCAN", 2, private.AuctionOwnedListUpdateDelayed)
	else
		private.lastScanNum = private.GetNumOwnedAuctions()
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.QueryOwnedAuctions()
	if select(4, GetBuildInfo()) < 80300 then
		GetOwnerAuctionItems()
	else
		C_AuctionHouse.QueryOwnedAuctions({})
	end
end

function private.GetNumOwnedAuctions()
	if select(4, GetBuildInfo()) < 80300 then
		return GetNumAuctionItems("owner")
	else
		return C_AuctionHouse.GetNumOwnedAuctions()
	end
end

function private.GetOwnedAuctionInfo(index)
	if select(4, GetBuildInfo()) < 80300 then
		local name, texture, stackSize, quality, _, _, _, minBid, _, buyout, bid, highBidder, _, _, _, saleStatus = GetAuctionItemInfo("owner", index)
		local link = name and name ~= "" and GetAuctionItemLink("owner", index)
		if not link then
			return
		end
		local duration = GetAuctionItemTimeLeft("owner", index)
		return index, link, name, texture, stackSize, quality, minBid, buyout, bid, highBidder, saleStatus, duration
	else
		local info = C_AuctionHouse.GetOwnedAuctionInfo(index)
		local link = info and info.itemLink
		if not link then
			return
		end
		local bid = info.bidAmount or info.buyoutAmount
		local minBid = bid
		local duration = 2 -- FIXME
		return info.auctionID, link, nil, nil, info.quantity, nil, minBid, info.buyoutAmount, bid, info.bidder or "", info.status, duration
	end
end

function private.OnCallbackQueryUpdated()
	for _, callback in ipairs(private.callbacks) do
		callback()
	end
end

function private.PostAuctionHookHandler(duration)
	local days = nil
	if duration == 1 then
		days = 0.5
	elseif duration == 2 then
		days = 1
	elseif duration == 3 then
		days = 2
	end

	local expiration = time() + (days * 24 * 60 * 60)
	if (TSM.db.factionrealm.internalData.expiringAuction[PLAYER_NAME] or math.huge) < expiration then
		return
	end

	TSM.db.factionrealm.internalData.expiringAuction[PLAYER_NAME] = expiration
	TSM.TaskList.Expirations.Update()
end
