-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Inbox = TSM.Mailing:NewPackage("Inbox")
local Database = TSM.Include("Util.Database")
local TempTable = TSM.Include("Util.TempTable")
local MailTracking = TSM.Include("Service.MailTracking")
local private = {
	itemsQuery = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Inbox.OnInitialize()
	private.itemsQuery = MailTracking.CreateMailItemQuery()
		:Equal("index", Database.BoundQueryParam())
end

function Inbox.CreateQuery()
	return MailTracking.CreateMailInboxQuery()
		:VirtualField("itemList", "string", private.GetVirtualItemList)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetVirtualItemList(row)
	private.itemsQuery:BindParams(row:GetField("index"))

	local items = TempTable.Acquire()
	for _, itemsRow in private.itemsQuery:Iterator() do
		local itemName = TSM.UI.GetColoredItemName(itemsRow:GetField("itemLink")) or ""
		local qty = itemsRow:GetField("quantity")

		tinsert(items, qty > 1 and (itemName.." (x"..qty..")") or itemName)
	end

	local result = table.concat(items, ", ")
	TempTable.Release(items)

	return result
end
