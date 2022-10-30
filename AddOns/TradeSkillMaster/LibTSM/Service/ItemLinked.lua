-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- ItemLinked Functions.
-- @module ItemLinked

local _, TSM = ...
local ItemLinked = TSM.Init("Service.ItemLinked")
local Table = TSM.Include("Util.Table")
local ItemInfo = TSM.Include("Service.ItemInfo")
local private = {
	callbacks = {},
	priorityLookup = {}
}



-- ============================================================================
-- Module Loading
-- ============================================================================

ItemLinked:OnModuleLoad(function()
	local origHandleModifiedItemClick = HandleModifiedItemClick
	HandleModifiedItemClick = function(...)
		return private.ItemLinkedHook(origHandleModifiedItemClick, ...)
	end
	local origChatEdit_InsertLink = ChatEdit_InsertLink
	ChatEdit_InsertLink = function(...)
		return private.ItemLinkedHook(origChatEdit_InsertLink, ...)
	end
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function ItemLinked.RegisterCallback(callback, priority)
	assert(type(callback) == "function")
	tinsert(private.callbacks, callback)
	private.priorityLookup[callback] = (priority or 0) + #private.callbacks * 0.01
	Table.SortWithValueLookup(private.callbacks, private.priorityLookup)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ItemLinkedHook(origFunc, ...)
	local putIntoChat = origFunc(...)
	if putIntoChat then
		return putIntoChat
	end
	local itemLink = ...
	local name = ItemInfo.GetName(itemLink)
	if not name or not private.HandleItemLinked(name, itemLink) then
		return putIntoChat
	end
	return true
end

function private.HandleItemLinked(name, itemLink)
	for _, callback in ipairs(private.callbacks) do
		if callback(name, itemLink) then
			return true
		end
	end
end
