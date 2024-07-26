-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMService = select(2, ...).LibTSMService
local Buy = LibTSMService:Init("Vendor.Buy")
local Log = LibTSMService:From("LibTSMUtil"):Include("Util.Log")
local ItemString = LibTSMService:From("LibTSMTypes"):Include("Item.ItemString")
local Merchant = LibTSMService:From("LibTSMWoW"):Include("API.Merchant")
local DelayTimer = LibTSMService:From("LibTSMWoW"):IncludeClassType("DelayTimer")
local ChatEvent = LibTSMService:From("LibTSMWoW"):Include("Service.ChatEvent")
local DefaultUI = LibTSMService:From("LibTSMWoW"):Include("UI.DefaultUI")
local private = {
	timeoutTimer = nil,
	pendingIndex = nil,
	pendingQuantity = 0,
}
local FIRST_BUY_TIMEOUT = 5
local FIRST_BUY_TIMEOUT_PER_STACK = 1
local CONSECUTIVE_BUY_TIMEOUT = 5



-- ============================================================================
-- Module Loading
-- ============================================================================

Buy:OnModuleLoad(function()
	private.timeoutTimer = DelayTimer.New("VENDOR_BUY_TIMEOUT", private.BuyTimeout)
	DefaultUI.RegisterMerchantVisibleCallback(private.ClearPendingContext, false)
	ChatEvent.RegisterLootHandler(private.LootHandler)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

---Buys an item from the vendor.
---@param index number The index of the item to buy
---@param quantity number The quantity to buy
function Buy.BuyIndex(index, quantity)
	private.BuyIndex(index, quantity)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.BuyIndex(index, quantity)
	local maxStack = Merchant.GetItemMaxStack(index)
	private.ClearPendingContext()
	private.pendingIndex = index
	local numStacks = 0
	while quantity > 0 do
		local buyQuantity = min(quantity, maxStack)
		Merchant.BuyItem(index, buyQuantity)
		private.pendingQuantity = private.pendingQuantity + buyQuantity
		quantity = quantity - buyQuantity
		numStacks = numStacks + 1
	end
	Log.Info("Buying %d of %d (%d stacks)", private.pendingQuantity, index, numStacks)
	private.timeoutTimer:RunForTime(numStacks * FIRST_BUY_TIMEOUT_PER_STACK + FIRST_BUY_TIMEOUT)
end

function private.LootHandler(msgItemLink, quantity)
	if not private.pendingIndex then
		return
	end
	local link = Merchant.GetItemLink(private.pendingIndex)
	if not link then
		Log.Err("Failed to get link (%s)", private.pendingIndex)
		private.ClearPendingContext()
		return
	end
	if ItemString.GetBase(msgItemLink) ~= ItemString.GetBase(link) then
		Log.Info("Unknown item link (%s, %s)", msgItemLink, link)
		return
	end
	Log.Info("Got CHAT_MSG_LOOT(%s) with a quantity of %s (%d pending)", msgItemLink, quantity, private.pendingQuantity)
	private.pendingQuantity = private.pendingQuantity - quantity
	if private.pendingQuantity <= 0 then
		-- We're done
		private.ClearPendingContext()
		return
	end

	-- Reset the timeout
	private.timeoutTimer:Cancel()
	private.timeoutTimer:RunForTime(CONSECUTIVE_BUY_TIMEOUT)
end

function private.BuyTimeout()
	Log.Warn("Retrying buying (%d, %d)", private.pendingIndex, private.pendingQuantity)
	private.BuyIndex(private.pendingIndex, private.pendingQuantity)
end

function private.ClearPendingContext()
	private.pendingIndex = nil
	private.pendingQuantity = 0
	private.timeoutTimer:Cancel()
end
