-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local AuctionChatMessage = TSM.Init("Service.AuctionChatMessage") ---@class Service.AuctionChatMessage: TSMModule
local TempTable = TSM.LibTSMUtil:Include("BaseType.TempTable")
local Money = TSM.LibTSMUtil:Include("UI.Money")
local AuctionHouse = TSM.LibTSMWoW:Include("API.AuctionHouse")
local Event = TSM.LibTSMWoW:Include("Service.Event")
local ClientInfo = TSM.LibTSMWoW:Include("Util.ClientInfo")
local Auction = TSM.LibTSMService:Include("Auction")
local ItemInfo = TSM.LibTSMService:Include("Item.ItemInfo")
local L = TSM.Locale.GetTable()
local ChatMessage = TSM.LibTSMService:Include("UI.ChatMessage")
local Sound = TSM.Include("Util.Sound")
local Theme = TSM.LibTSMService:Include("UI.Theme")
local private = {
	settings = nil,
	prevLineId = nil,
}



-- ============================================================================
-- Module Loading
-- ============================================================================

AuctionChatMessage:OnSettingsLoad(function(db)
	private.settings = db:NewView()
		:AddKey("char", "internalData", "auctionPrices")
		:AddKey("char", "internalData", "auctionMessages")
		:AddKey("global", "coreOptions", "auctionSaleSound")

	Auction.RegisterThrottledIndexCallback(private.HandleThrottledAuctionsUpdate)

	-- Setup enhanced sale / buy messages
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE) then
		Event.Register("AUCTION_HOUSE_SHOW_NOTIFICATION", private.HandleNotification)
		Event.Register("AUCTION_HOUSE_SHOW_FORMATTED_NOTIFICATION", private.HandleNotification)
		Event.Register("AUCTION_HOUSE_SHOW_COMMODITY_WON_NOTIFICATION", private.HandleCommodityNotification)
	else
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", private.FilterSystemMsg)
	end
end)

AuctionChatMessage:OnGameDataLoad(function()
	if not ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE) then
		-- Setup auction created / cancelled filtering
		-- NOTE: This is delayed until the game is loaded to avoid taint issues
		local funcTable = _G
		-- luacheck: globals ElvUI
		if C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI then
			local tbl, _, settings = unpack(ElvUI)
			if settings.chat.enable then
				funcTable = tbl:GetModule("Chat")
			end
		end
		local origChatFrameOnEvent = funcTable.ChatFrame_OnEvent
		funcTable.ChatFrame_OnEvent = function(self, event, msg, ...)
			-- Suppress auction created / cancelled spam
			if event == "CHAT_MSG_SYSTEM" and (msg == ERR_AUCTION_STARTED or msg == ERR_AUCTION_REMOVED) then
				return
			end
			return origChatFrameOnEvent(self, event, msg, ...)
		end
	end
end)



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.HandleThrottledAuctionsUpdate()
	local INVALID_STACK_SIZE = -1
	-- Recycle tables from private.settings.auctionPrices if we can so we're not creating a ton of garbage
	local freeTables = TempTable.Acquire()
	for _, tbl in pairs(private.settings.auctionPrices) do
		wipe(tbl)
		tinsert(freeTables, tbl)
	end
	wipe(private.settings.auctionPrices)
	wipe(private.settings.auctionMessages)
	local auctionPrices = TempTable.Acquire()
	local auctionStackSizes = TempTable.Acquire()
	local query = Auction.NewIndexQuery()
		:Select("itemLink", "stackSize", "buyout", "isSold")
		:Equal("isSold", false)
		:GreaterThan("buyout", 0)
		:OrderBy("index", true)
	for _, link, stackSize, buyout, isSold in query:IteratorAndRelease() do
		if buyout > 0 and not isSold then
			auctionPrices[link] = auctionPrices[link] or tremove(freeTables) or {}
			if stackSize ~= auctionStackSizes[link] then
				auctionStackSizes[link] = stackSize
			end
			tinsert(auctionPrices[link], buyout)
		end
	end
	for link, prices in pairs(auctionPrices) do
		local name = ItemInfo.GetName(link)
		if auctionStackSizes[link] ~= INVALID_STACK_SIZE then
			sort(prices)
			private.settings.auctionPrices[link] = prices
			if ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE) then
				private.settings.auctionMessages[name] = link
			else
				private.settings.auctionMessages[format(ERR_AUCTION_SOLD_S, name)] = link
			end
		end
	end
	TempTable.Release(freeTables)
	TempTable.Release(auctionPrices)
	TempTable.Release(auctionStackSizes)
end

function private.FilterSystemMsg(_, _, msg, ...)
	local lineID = select(10, ...)
	if lineID == private.prevLineId then
		return
	end
	private.prevLineId = lineID
	local chatMsg = nil
	if private.LastPurchaseMatchesAuctionWonMessage(msg) then
		-- We just bought an auction
		chatMsg = private.GetAuctionWonMessage()
	elseif private.settings.auctionMessages[msg] then
		-- We just sold an auction
		chatMsg = private.GetAuctionSoldMessage(msg)
	end
	if chatMsg then
		return nil, chatMsg, ...
	end
end

function private.LastPurchaseMatchesAuctionWonMessage(msg)
	local _, name, quantity = private.GetLastPurchase()
	if not name then
		return false
	end
	if msg == format(ERR_AUCTION_WON_S, name) then
		return true
	end
	if quantity and ClientInfo.IsRetail() and msg == format(ERR_AUCTION_COMMODITY_WON_S, name, quantity) then
		return true
	end
	return false
end

function private.GetLastPurchase()
	local link, name, quantity, buyout = AuctionHouse.GetLastPurchase()
	if type(link) == "number" then
		link = ItemInfo.GetLink("i:"..link)
	end
	if not link then
		return nil, nil, nil, nil
	end
	name = ItemInfo.GetName(link) or name
	return link, name, quantity, buyout
end

function private.HandleNotification(_, msg, msgArg)
	local chatMsg = nil
	if msg == Enum.AuctionHouseNotification.AuctionWon then
		chatMsg = private.GetAuctionWonMessage()
	elseif msg == Enum.AuctionHouseNotification.AuctionSold and msgArg then
		chatMsg = private.GetAuctionSoldMessage(msgArg)
	elseif msg == Enum.AuctionHouseNotification.AuctionOutbid and msgArg then
		chatMsg = format(ERR_AUCTION_OUTBID_S, msgArg)
	elseif msg == Enum.AuctionHouseNotification.AuctionExpired and msgArg then
		chatMsg = format(ERR_AUCTION_EXPIRED_S, msgArg)
	elseif msg == Enum.AuctionHouseNotification.BidPlaced then
		chatMsg = ERR_AUCTION_BID_PLACED
	end
	if not chatMsg then
		return
	end
	ChatMessage.PrintUserRaw(Theme.GetColor("BLIZZARD_YELLOW"):ColorText(chatMsg))
end

function private.HandleCommodityNotification(_, _, quantity)
	local msg = private.GetAuctionWonMessage(quantity)
	if not msg then
		return
	end
	ChatMessage.PrintUserRaw(Theme.GetColor("BLIZZARD_YELLOW"):ColorText(msg))
end

function private.GetAuctionSoldMessage(msg)
	local link = private.settings.auctionMessages[msg]
	local price = nil
	if link then
		price = tremove(private.settings.auctionPrices[link], 1)
		if #private.settings.auctionPrices[link] == 0 then
			-- This was the last auction
			private.settings.auctionMessages[msg] = nil
		end
	else
		link = msg
	end
	Sound.PlaySound(private.settings.auctionSaleSound)
	if price then
		return format(L["Your auction of %s has sold for %s!"], link, Money.ToStringForAH(price, "|cffffffff"))
	else
		return format(L["Your auction of %s has sold!"], link)
	end
end

function private.GetAuctionWonMessage(forceQuantity)
	local link, _, quantity, buyout = private.GetLastPurchase()
	if not link then
		return nil
	end
	return format(L["You won an auction for %sx%d for %s"], link, forceQuantity or quantity, Money.ToStringForAH(buyout, "|cffffffff"))
end
