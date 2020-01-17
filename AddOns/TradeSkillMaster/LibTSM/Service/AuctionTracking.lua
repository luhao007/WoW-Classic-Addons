-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--          http://www.curse.com/addons/wow/tradeskillmaster_warehousing          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AuctionTracking = TSM.Init("Service.AuctionTracking")
local L = TSM.Include("Locale").GetTable()
local Database = TSM.Include("Util.Database")
local Delay = TSM.Include("Util.Delay")
local Event = TSM.Include("Util.Event")
local Log = TSM.Include("Util.Log")
local ItemString = TSM.Include("Util.ItemString")
local TempTable = TSM.Include("Util.TempTable")
local Sound = TSM.Include("Util.Sound")
local Money = TSM.Include("Util.Money")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Settings = TSM.Include("Service.Settings")
local private = {
	settings = nil,
	indexDB = nil,
	quantityDB = nil,
	updateQuery = nil,
	isAHOpen = false,
	callbacks = {},
	expiresCallbacks = {},
	indexUpdates = {
		list = {},
		pending = {},
	},
	cancelAuctionId = nil,
	lastScanNum = nil,
	ignoreUpdateEvent = nil,
	lastPurchase = {},
	prevLineId = nil,
	prevLineResult = nil,
	origChatFrameOnEvent = nil,
}
local PLAYER_NAME = UnitName("player")
local SALE_HINT_SEP = "\001"
local SALE_HINT_EXPIRE_TIME = 33 * 24 * 60 * 60
local SORT_ORDER_83 = TSM.IsWow83() and {
	{ sortOrder = Enum.AuctionHouseSortOrder.Name, reverseSort = false },
	{ sortOrder = Enum.AuctionHouseSortOrder.Buyout, reverseSort = false },
}



-- ============================================================================
-- Module Loading
-- ============================================================================

AuctionTracking:OnSettingsLoad(function()
	private.settings = Settings.NewView()
		:AddKey("char", "internalData", "auctionSaleHints")
		:AddKey("char", "internalData", "auctionPrices")
		:AddKey("char", "internalData", "auctionMessages")
		:AddKey("factionrealm", "internalData", "expiringAuction")
		:AddKey("sync", "internalData", "auctionQuantity")
		:AddKey("global", "coreOptions", "auctionSaleSound")
	Event.Register("AUCTION_HOUSE_SHOW", private.AuctionHouseShowHandler)
	Event.Register("AUCTION_HOUSE_CLOSED", private.AuctionHouseClosedHandler)
	if not TSM.IsWow83() then
		Event.Register("AUCTION_OWNED_LIST_UPDATE", private.AuctionOwnedListUpdateHandler)
	else
		Event.Register("OWNED_AUCTIONS_UPDATED", private.AuctionOwnedListUpdateHandler)
		Event.Register("AUCTION_CANCELED", private.AuctionCanceledHandler)
	end
	private.indexDB = Database.NewSchema("AUCTION_TRACKING_INDEXES")
		:AddUniqueNumberField("index")
		:AddStringField("itemString")
		:AddSmartMapField("baseItemString", ItemString.GetBaseMap(), "itemString")
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
		:AddNumberField("auctionId")
		:AddIndex("index")
		:AddIndex("saleStatus")
		:AddIndex("auctionId")
		:Commit()
	private.quantityDB = Database.NewSchema("AUCTION_TRACKING_QUANTITY")
		:AddUniqueStringField("itemString")
		:AddNumberField("quantity")
		:Commit()
	private.updateQuery = private.indexDB:NewQuery()
		:SetUpdateCallback(private.OnCallbackQueryUpdated)

	private.RebuildQuantityDB()
	for info, timestamp in pairs(private.settings.auctionSaleHints) do
		if time() > timestamp + SALE_HINT_EXPIRE_TIME then
			private.settings.auctionSaleHints[info] = nil
		end
	end

	if not TSM.IsWow83() then
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
		hooksecurefunc(C_AuctionHouse, "CancelAuction", function(auctionId)
			private.cancelAuctionId = auctionId
		end)
	end

	-- setup enhanced sale / buy messages
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", private.FilterSystemMsg)
	if not TSM.IsWow83() then
		hooksecurefunc("PlaceAuctionBid", function(_, index, amountPaid)
			local link = GetAuctionItemLink("list", index)
			local name, _, stackSize, _, _, _, _, _, _, buyout = GetAuctionItemInfo("list", index)
			if amountPaid == buyout then
				wipe(private.lastPurchase)
				private.lastPurchase.name = name
				private.lastPurchase.link = link
				private.lastPurchase.stackSize = stackSize
				private.lastPurchase.buyout = buyout
			end
		end)
	else
		hooksecurefunc(C_AuctionHouse, "PlaceBid", function(auctionId, bidPlaced)
			-- TODO: figure out how to get the info we need
		end)
		-- TODO: hook C_AuctionHouse.StartCommoditiesPurchase / C_AuctionHouse.ConfirmCommoditiesPurchase
	end
end)

AuctionTracking:OnGameDataLoad(function()
	-- setup auction created / cancelled filtering
	-- NOTE: this is delayed until the game is loaded to avoid taint issues
	local ElvUIChat, ElvUIChatIsEnabled = nil, nil
	if IsAddOnLoaded("ElvUI") and ElvUI then
		ElvUIChat = ElvUI[1]:GetModule("Chat")
		if ElvUI[3].chat.enable then
			ElvUIChatIsEnabled = true
		end
	end
	if ElvUIChatIsEnabled then
		private.origChatFrameOnEvent = ElvUIChat.ChatFrame_OnEvent
		ElvUIChat.ChatFrame_OnEvent = private.ChatFrameOnEvent
	else
		private.origChatFrameOnEvent = ChatFrame_OnEvent
		ChatFrame_OnEvent = private.ChatFrameOnEvent
	end
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionTracking.RegisterCallback(callback)
	tinsert(private.callbacks, callback)
end

function AuctionTracking.RegisterExpiresCallback(callback)
	tinsert(private.expiresCallbacks, callback)
end

function AuctionTracking.DatabaseFieldIterator()
	return private.indexDB:FieldIterator()
end

function AuctionTracking.BaseItemIterator()
	return private.quantityDB:NewQuery()
		:Select("itemString")
		:IteratorAndRelease()
end

function AuctionTracking.CreateQuery()
	return private.indexDB:NewQuery()
end

function AuctionTracking.CreateQueryUnsold()
	return AuctionTracking.CreateQuery()
		:Equal("saleStatus", 0)
end

function AuctionTracking.CreateQueryUnsoldItem(itemString)
	return AuctionTracking.CreateQueryUnsold()
		:Equal(itemString == ItemString.GetBaseFast(itemString) and "baseItemString" or "itemString", itemString)
end

function AuctionTracking.GetSaleHintItemString(name, stackSize, buyout)
	for info in pairs(private.settings.auctionSaleHints) do
		local infoName, itemString, infoStackSize, infoBuyout = strsplit(SALE_HINT_SEP, info)
		if infoName == name and tonumber(infoStackSize) == stackSize and tonumber(infoBuyout) == buyout then
			return itemString
		end
	end
end

function AuctionTracking.GetQuantityByBaseItemString(baseItemString)
	return private.quantityDB:GetUniqueRowField("itemString", baseItemString, "quantity") or 0
end

function AuctionTracking.QueryOwnedAuctions()
	if not private.isAHOpen then
		return
	end
	if TSM.IsWow83() then
		C_AuctionHouse.QueryOwnedAuctions(SORT_ORDER_83)
	else
		GetOwnerAuctionItems()
	end
end



-- ============================================================================
-- Event Handlers
-- ============================================================================

function private.AuctionHouseShowHandler()
	private.isAHOpen = true
	if TSM.IsWow83() then
		Delay.AfterTime(0.1, AuctionTracking.QueryOwnedAuctions)
	else
		AuctionTracking.QueryOwnedAuctions()
		-- We don't always get AUCTION_OWNED_LIST_UPDATE events, so do our own scanning if needed
		Delay.AfterTime("AUCTION_BACKGROUND_SCAN", 1, private.DoBackgroundScan, 1)
	end
end

function private.AuctionHouseClosedHandler()
	private.isAHOpen = false
	Delay.Cancel("AUCTION_BACKGROUND_SCAN")
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
	for i = 1, private.GetNumOwnedAuctions() do
		if not private.indexUpdates.pending[i] then
			private.indexUpdates.pending[i] = true
			tinsert(private.indexUpdates.list, i)
		end
	end
	Delay.AfterFrame("AUCTION_OWNED_LIST_SCAN", 2, private.AuctionOwnedListUpdateDelayed)
end

function private.AuctionCanceledHandler(_, auctionId)
	local row = private.indexDB:NewQuery()
		:Equal("auctionId", auctionId == 0 and private.cancelAuctionId or auctionId)
		:GetFirstResultAndRelease()
	private.cancelAuctionId = nil
	if not row then
		return
	end

	private.indexDB:DeleteRow(row)
	row:Release()
end

function private.AuctionOwnedListUpdateDelayed()
	if not private.isAHOpen then
		return
	elseif AuctionFrame and AuctionFrame:IsVisible() and AuctionFrame.selectedTab == 3 then
		-- default UI auctions tab is visible, so scan later
		Delay.AfterFrame("AUCTION_OWNED_LIST_SCAN", 2, private.AuctionOwnedListUpdateDelayed)
		return
	elseif TSM.IsWow83() and not C_AuctionHouse.HasFullOwnedAuctionResults() then
		-- don't have all the results yet, so try again in a moment
		Delay.AfterFrame("AUCTION_OWNED_LIST_SCAN", 0.1, private.AuctionOwnedListUpdateDelayed)
		return
	end
	if not TSM.IsWow83() then
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
			Log.Info("Sorting owner auctions")
			-- ignore events while changing the sort
			private.ignoreUpdateEvent = true
			AuctionFrame_SetSort("owner", "duration", true)
			SortAuctionApplySort("owner")
			private.ignoreUpdateEvent = nil
		end
	end

	-- scan the auctions
	wipe(private.settings.auctionQuantity)
	private.indexDB:TruncateAndBulkInsertStart()
	local expire = math.huge
	for i = #private.indexUpdates.list, 1, -1 do
		local index = private.indexUpdates.list[i]
		local auctionId, link, name, texture, stackSize, quality, minBid, buyout, bid, highBidder, saleStatus, duration = private.GetOwnedAuctionInfo(index)
		name = name or ItemInfo.GetName(link)
		texture = texture or ItemInfo.GetTexture(link)
		quality = quality or ItemInfo.GetQuality(link)
		if link and name and texture and quality then
			assert(saleStatus == 0 or saleStatus == 1)
			highBidder = highBidder or ""
			local itemString = ItemString.Get(link)
			local currentBid = highBidder ~= "" and bid or minBid
			if saleStatus == 0 then
				if TSM.IsWow83() then
					duration = time() + duration
					expire = min(expire, duration)
				else
					if duration == 1 then -- 30 min
						expire = min(expire, time() + 0.5 * 60 * 60)
					elseif duration == 2 then -- 2 hours
						expire = min(expire, time() + 2 * 60 * 60)
					elseif duration == 3 then -- 12 hours
						expire = min(expire, time() + 12 * 60 * 60)
					end
				end
				local baseItemString = ItemString.GetBaseFast(itemString)
				private.settings.auctionQuantity[baseItemString] = (private.settings.auctionQuantity[baseItemString] or 0) + stackSize
				local hintInfo = strjoin(SALE_HINT_SEP, ItemInfo.GetName(link), itemString, stackSize, buyout)
				private.settings.auctionSaleHints[hintInfo] = time()
			else
				duration = time() + duration
			end
			private.indexUpdates.pending[index] = nil
			tremove(private.indexUpdates.list, i)
			private.indexDB:BulkInsertNewRow(index, itemString, link, texture, name, quality, duration, highBidder, currentBid, buyout, stackSize, saleStatus, auctionId)
		end
	end
	private.RebuildQuantityDB()
	private.indexDB:BulkInsertEnd()

	if expire ~= math.huge and (private.settings.expiringAuction[PLAYER_NAME] or math.huge) > expire then
		private.settings.expiringAuction[PLAYER_NAME] = expire
		for _, callback in ipairs(private.expiresCallbacks) do
			callback()
		end
	end

	Log.Info("Scanned auctions (left=%d)", #private.indexUpdates.list)
	if #private.indexUpdates.list > 0 then
		-- some failed to scan so try again
		Delay.AfterFrame("AUCTION_OWNED_LIST_SCAN", 2, private.AuctionOwnedListUpdateDelayed)
	else
		private.lastScanNum = private.GetNumOwnedAuctions()
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.RebuildQuantityDB()
	private.quantityDB:TruncateAndBulkInsertStart()
	for itemString, quantity in pairs(private.settings.auctionQuantity) do
		if quantity > 0 then
			private.quantityDB:BulkInsertNewRow(itemString, quantity)
		else
			private.settings.auctionQuantity[itemString] = nil
		end
	end
	private.quantityDB:BulkInsertEnd()
end

function private.GetNumOwnedAuctions()
	if not TSM.IsWow83() then
		return GetNumAuctionItems("owner")
	else
		return C_AuctionHouse.GetNumOwnedAuctions()
	end
end

function private.GetOwnedAuctionInfo(index)
	if not TSM.IsWow83() then
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
		return info.auctionID, link, nil, nil, info.quantity, nil, minBid, info.buyoutAmount, bid, info.bidder or "", info.status, info.timeLeftSeconds
	end
end

function private.OnCallbackQueryUpdated()
	for _, callback in ipairs(private.callbacks) do
		callback()
	end
	-- updating the auction prices / messages is very low-priority, so throttle it to at most every 0.5 seconds
	Delay.AfterTime("UPDATE_AUCTION_PRICES_MESSAGES_THROTTLE", 0.5, private.UpdateAuctionPricesMessages)
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
	if (private.settings.expiringAuction[PLAYER_NAME] or math.huge) < expiration then
		return
	end
	private.settings.expiringAuction[PLAYER_NAME] = expiration
	for _, callback in ipairs(private.expiresCallbacks) do
		callback()
	end
end

function private.UpdateAuctionPricesMessages()
	local INVALID_STACK_SIZE = -1
	-- recycle tables from private.settings.auctionPrices if we can so we're not creating a ton of garbage
	local freeTables = TempTable.Acquire()
	for _, tbl in pairs(private.settings.auctionPrices) do
		wipe(tbl)
		tinsert(freeTables, tbl)
	end
	wipe(private.settings.auctionPrices)
	wipe(private.settings.auctionMessages)
	local auctionPrices = TempTable.Acquire()
	local auctionStackSizes = TempTable.Acquire()
	local query = AuctionTracking.CreateQueryUnsold()
		:Select("itemLink", "stackSize", "buyout")
		:GreaterThan("buyout", 0)
		:OrderBy("index", true)
	for _, link, stackSize, buyout in query:IteratorAndRelease() do
		auctionPrices[link] = auctionPrices[link] or tremove(freeTables) or {}
		if stackSize ~= auctionStackSizes[link] then
			auctionStackSizes[link] = stackSize
		end
		tinsert(auctionPrices[link], buyout)
	end
	for link, prices in pairs(auctionPrices) do
		local name = ItemInfo.GetName(link)
		if auctionStackSizes[link] ~= INVALID_STACK_SIZE then
			sort(prices)
			private.settings.auctionPrices[link] = prices
			private.settings.auctionMessages[format(ERR_AUCTION_SOLD_S, name)] = link
		end
	end
	TempTable.Release(freeTables)
	TempTable.Release(auctionPrices)
	TempTable.Release(auctionStackSizes)
end

function private.ChatFrameOnEvent(self, event, msg, ...)
	-- surpress auction created / cancelled spam
	if event == "CHAT_MSG_SYSTEM" and (msg == ERR_AUCTION_STARTED or msg == ERR_AUCTION_REMOVED) then
		return
	end
	return private.origChatFrameOnEvent(self, event, msg, ...)
end

function private.FilterSystemMsg(_, _, msg, ...)
	local lineID = select(10, ...)
	if lineID ~= private.prevLineId then
		private.prevLineId = lineID
		private.prevLineResult = nil
		local link = private.settings.auctionMessages and private.settings.auctionMessages[msg]
		if private.lastPurchase.name and msg == format(ERR_AUCTION_WON_S, private.lastPurchase.name) then
			-- we just bought an auction
			private.prevLineResult = format(L["You won an auction for %sx%d for %s"], private.lastPurchase.link, private.lastPurchase.stackSize, Money.ToString(private.lastPurchase.buyout, "|cffffffff"))
			return nil, private.prevLineResult, ...
		elseif link then
			-- we may have just sold an auction
			local price = tremove(private.settings.auctionPrices[link], 1)
			local numAuctions = #private.settings.auctionPrices[link]
			if not price then
				-- couldn't determine the price, so just replace the link
				private.prevLineResult = format(ERR_AUCTION_SOLD_S, link)
				return nil, private.prevLineResult, ...
			end
			if numAuctions == 0 then -- this was the last auction
				private.settings.auctionMessages[msg] = nil
			end
			private.prevLineResult = format(L["Your auction of %s has sold for %s!"], link, Money.ToString(price, "|cffffffff"))
			Sound.PlaySound(private.settings.auctionSaleSound)
			return nil, private.prevLineResult, ...
		end
	end
end
