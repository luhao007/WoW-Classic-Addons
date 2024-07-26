-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMService = select(2, ...).LibTSMService
local Util = LibTSMService:Init("AuctionScan.Util")
local ItemInfo = LibTSMService:Include("Item.ItemInfo")



-- ============================================================================
-- Module Functions
-- ============================================================================

---Returns whether or not sufficient item info is available for an item.
---@param itemString string The item string
---@return boolean
function Util.HasItemInfo(itemString)
	local itemName = ItemInfo.GetName(itemString)
	local itemLevel = ItemInfo.GetItemLevel(itemString)
	local quality = ItemInfo.GetQuality(itemString)
	local minLevel = ItemInfo.GetMinLevel(itemString)
	local hasIsCommodity = not LibTSMService.IsRetail() or ItemInfo.IsCommodity(itemString) ~= nil
	local hasCanHaveVariations = ItemInfo.CanHaveVariations(itemString) ~= nil
	local result = itemName and itemLevel and quality and minLevel and hasIsCommodity and hasCanHaveVariations
	if not result then
		ItemInfo.FetchInfo(itemString)
	end
	return result
end
