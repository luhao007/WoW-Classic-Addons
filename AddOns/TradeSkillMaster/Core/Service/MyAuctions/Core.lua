-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local MyAuctions = TSM:NewPackage("MyAuctions")
local Database = TSM.Include("Util.Database")
local Event = TSM.Include("Util.Event")
local TempTable = TSM.Include("Util.TempTable")
local Log = TSM.Include("Util.Log")
local AuctionTracking = TSM.Include("Service.AuctionTracking")
local ItemInfo = TSM.Include("Service.ItemInfo")
local private = {
	pendingDB = nil,
	ahOpen = false,
	pendingHashes = {},
	expectedCounts = {},
	auctionInfo = { numPosted = 0, numSold = 0, postedGold = 0, soldGold = 0 },
	dbHashFields = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function MyAuctions.OnInitialize()
	private.pendingDB = Database.NewSchema("MY_AUCTIONS_PENDING")
		:AddUniqueNumberField("index")
		:AddNumberField("hash")
		:AddBooleanField("isPending")
		:AddNumberField("pendingAuctionId")
		:AddIndex("index")
		:Commit()
	for field in AuctionTracking.DatabaseFieldIterator() do
		if field ~= "index" and field ~= "auctionId" then
			tinsert(private.dbHashFields, field)
		end
	end

	Event.Register("AUCTION_HOUSE_SHOW", private.AuctionHouseShowEventHandler)
	Event.Register("AUCTION_HOUSE_CLOSED", private.AuctionHouseHideEventHandler)
	Event.Register("CHAT_MSG_SYSTEM", private.ChatMsgSystemEventHandler)
	Event.Register("UI_ERROR_MESSAGE", private.UIErrorMessageEventHandler)
	AuctionTracking.RegisterCallback(private.OnAuctionsUpdated)
end

function MyAuctions.CreateQuery()
	return AuctionTracking.CreateQuery()
		:LeftJoin(private.pendingDB, "index")
		:OrderBy("index", TSM.IsWow83())
end

function MyAuctions.CancelAuction(auctionId)
	local row = private.pendingDB:NewQuery()
		:Equal("pendingAuctionId", auctionId)
		:GetFirstResultAndRelease()
	local hash = row:GetField("hash")
	assert(hash)
	if private.expectedCounts[hash] and private.expectedCounts[hash] > 0 then
		private.expectedCounts[hash] = private.expectedCounts[hash] - 1
	else
		private.expectedCounts[hash] = private.GetNumRowsByHash(hash) - 1
	end
	assert(private.expectedCounts[hash] >= 0)

	Log.Info("Canceling (auctionId=%d, hash=%d)", auctionId, hash)
	if not TSM.IsWow83() then
		CancelAuction(auctionId)
	else
		C_AuctionHouse.CancelAuction(auctionId)
	end
	assert(not row:GetField("isPending"))
	row:SetField("isPending", true)
		:Update()
	row:Release()

	tinsert(private.pendingHashes, hash)
end

function MyAuctions.CanCancel(index)
	local query = private.pendingDB:NewQuery()
		:Equal("isPending", true)
	if TSM.IsWow83() then
		query:Equal("pendingAuctionId", index)
	else
		query:LessThanOrEqual("index", index)
	end
	return query:CountAndRelease() == 0
end

function MyAuctions.GetNumPending()
	return private.pendingDB:NewQuery()
		:Equal("isPending", true)
		:CountAndRelease()
end

function MyAuctions.GetAuctionInfo()
	if not private.ahOpen then
		return
	end
	return private.auctionInfo.numPosted, private.auctionInfo.numSold, private.auctionInfo.postedGold, private.auctionInfo.soldGold
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.AuctionHouseShowEventHandler()
	private.ahOpen = true
end

function private.AuctionHouseHideEventHandler()
	private.ahOpen = false
end

function private.ChatMsgSystemEventHandler(_, msg)
	if msg == ERR_AUCTION_REMOVED and #private.pendingHashes > 0 then
		local hash = tremove(private.pendingHashes, 1)
		assert(hash)
		Log.Info("Confirmed (hash=%d)", hash)
	end
end

function private.UIErrorMessageEventHandler(_, _, msg)
	if (msg == ERR_ITEM_NOT_FOUND or msg == ERR_NOT_ENOUGH_MONEY) and #private.pendingHashes > 0 then
		local hash = tremove(private.pendingHashes, 1)
		assert(hash)
		Log.Info("Failed to cancel (hash=%d)", hash)
		if private.expectedCounts[hash] then
			private.expectedCounts[hash] = private.expectedCounts[hash] + 1
		end
	end
end

function private.GetNumRowsByHash(hash)
	return private.pendingDB:NewQuery()
		:Equal("hash", hash)
		:CountAndRelease()
end

function private.OnAuctionsUpdated()
	local minPendingIndexByHash = TempTable.Acquire()
	local numByHash = TempTable.Acquire()
	local query = AuctionTracking.CreateQuery()
		:OrderBy("index", true)
	for _, row in query:Iterator() do
		local index = row:GetField("index")
		local hash = row:CalculateHash(private.dbHashFields)
		numByHash[hash] = (numByHash[hash] or 0) + 1
		if not minPendingIndexByHash[hash] and private.pendingDB:GetUniqueRowField("index", index, "isPending") then
			minPendingIndexByHash[hash] = index
		end
	end
	local numUsed = TempTable.Acquire()
	private.pendingDB:TruncateAndBulkInsertStart()
	for _, row in query:Iterator() do
		local hash = row:CalculateHash(private.dbHashFields)
		assert(numByHash[hash] > 0)
		local expectedCount = private.expectedCounts[hash]
		local isPending = nil
		if not expectedCount then
			-- this was never pending
			isPending = false
		elseif numByHash[hash] <= expectedCount then
			-- this is no longer pending
			isPending = false
			private.expectedCounts[hash] = nil
		elseif row:GetField("index") >= (minPendingIndexByHash[hash] or math.huge) then
			local numPending = numByHash[hash] - expectedCount
			assert(numPending > 0)
			numUsed[hash] = (numUsed[hash] or 0) + 1
			isPending = numUsed[hash] <= numPending
		else
			-- it's a later auction which is pending
			isPending = false
		end
		private.pendingDB:BulkInsertNewRow(row:GetField("index"), hash, isPending, row:GetField("auctionId"))
	end
	private.pendingDB:BulkInsertEnd()
	TempTable.Release(numByHash)
	TempTable.Release(numUsed)
	TempTable.Release(minPendingIndexByHash)

	-- update the player's auction status
	private.auctionInfo.numPosted = 0
	private.auctionInfo.numSold = 0
	private.auctionInfo.postedGold = 0
	private.auctionInfo.soldGold = 0
	for _, row in query:Iterator() do
		local itemString, saleStatus, buyout, currentBid, stackSize = row:GetFields("itemString", "saleStatus", "buyout", "currentBid", "stackSize")
		private.auctionInfo.numPosted = private.auctionInfo.numPosted + 1
		if not TSM.IsWowClassic() and ItemInfo.IsCommodity(itemString) then
			private.auctionInfo.postedGold = private.auctionInfo.postedGold + (buyout * stackSize)
		else
			private.auctionInfo.postedGold = private.auctionInfo.postedGold + buyout
		end
		if saleStatus == 1 then
			private.auctionInfo.numSold = private.auctionInfo.numSold + 1
			-- if somebody did a buyout, then bid will be equal to buyout, otherwise it'll be the winning bid
			private.auctionInfo.soldGold = private.auctionInfo.soldGold + currentBid
		end
	end
	query:Release()
end
