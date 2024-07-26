-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMService = select(2, ...).LibTSMService
local SaleHint = LibTSMService:Init("Auction.SaleHint")
local Scanner = LibTSMService:Include("Auction.Scanner")
local ItemInfo = LibTSMService:Include("Item.ItemInfo")
local ItemString = LibTSMService:From("LibTSMTypes"):Include("Item.ItemString")
local AuctionHouse = LibTSMService:From("LibTSMWoW"):Include("API.AuctionHouse")
local Event = LibTSMService:From("LibTSMWoW"):Include("Service.Event")
local ClientInfo = LibTSMService:From("LibTSMWoW"):Include("Util.ClientInfo")
local private = {
	storage = nil,
	pendingItemLink = nil,
	pendingQuantity = nil,
	pendingUnitPrice = nil,
}
local SALE_HINT_SEP = "\001"
local SALE_HINT_EXPIRE_TIME = 33 * 24 * 60 * 60



-- ============================================================================
-- Module Functions
-- ============================================================================

---Loads and sets the stored data table.
---@param saleHintData table<string,number> Auction sale hints
function SaleHint.Load(saleHintData)
	-- Clear out expired sales
	for info, timestamp in pairs(saleHintData) do
		if LibTSMService.GetTime() > timestamp + SALE_HINT_EXPIRE_TIME then
			saleHintData[info] = nil
		end
	end
	private.storage = saleHintData
end

---Starts auction sale hint tracking.
function SaleHint.Start()
	if ClientInfo.HasFeature(ClientInfo.FEATURES.C_AUCTION_HOUSE) then
		Event.Register("AUCTION_HOUSE_AUCTION_CREATED", private.AuctionCreatedHandler)
	end
	Scanner.RegisterThrottledIndexCallback(private.HandleThrottledAuctionsUpdate)
	AuctionHouse.SecureHookPost(private.PostAuctionHookHandler)
end

---Gets the item string for a given auction sale.
---@param name string The item name
---@param stackSize number The stack size
---@param buyout number The buyout price
---@return string?
function SaleHint.GetItemString(name, stackSize, buyout)
	if not ClientInfo.HasFeature(ClientInfo.FEATURES.AH_STACKS) and stackSize > 1 then
		buyout = buyout / stackSize
	end
	for info in pairs(private.storage) do
		local infoName, itemString, infoStackSize, infoBuyout = strsplit(SALE_HINT_SEP, info)
		if infoName == name and tonumber(infoStackSize) == stackSize and tonumber(infoBuyout) == buyout then
			return itemString
		end
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.AuctionCreatedHandler()
	if not private.pendingItemLink then
		return
	end
	private.StoreHint(private.pendingItemLink, ItemString.Get(private.pendingItemLink), private.pendingQuantity, private.pendingUnitPrice)
	private.pendingItemLink = nil
end

function private.PostAuctionHookHandler(_, itemLink, quantity, unitPrice)
	if not itemLink then
		private.pendingItemLink = nil
		return
	end
	private.pendingItemLink = itemLink
	private.pendingQuantity = quantity
	private.pendingUnitPrice = unitPrice
end

function private.HandleThrottledAuctionsUpdate()
	local query = Scanner.NewIndexQuery()
		:Select("itemLink", "itemString", "stackSize", "buyout")
		:Equal("isSold", false)
	for _, itemLink, itemString, stackSize, buyout in query:Iterator() do
		private.StoreHint(itemLink, itemString, stackSize, buyout)
	end
	query:Release()
end

function private.StoreHint(itemLink, itemString, stackSize, unitPrice)
	local hintInfo = strjoin(SALE_HINT_SEP, ItemInfo.GetName(itemLink), itemString, stackSize, unitPrice)
	private.storage[hintInfo] = floor(LibTSMService.GetTime())
end
