-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Auctioning = TSM.Banking:NewPackage("Auctioning")
local TempTable = TSM.Include("Util.TempTable")
local BagTracking = TSM.Include("Service.BagTracking")
local Inventory = TSM.Include("Service.Inventory")
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Auctioning.MoveGroupsToBank(callback, groups)
	local items = TempTable.Acquire()
	TSM.Banking.Util.PopulateGroupItemsFromBags(items, groups, private.GroupsGetNumToMoveToBank)
	TSM.Banking.MoveToBank(items, callback)
	TempTable.Release(items)
end

function Auctioning.PostCapToBags(callback, groups)
	local items = TempTable.Acquire()
	TSM.Banking.Util.PopulateGroupItemsFromOpenBank(items, groups, private.GetNumToMoveToBags)
	TSM.Banking.MoveToBag(items, callback)
	TempTable.Release(items)
end

function Auctioning.ShortfallToBags(callback, groups)
	local items = TempTable.Acquire()
	TSM.Banking.Util.PopulateGroupItemsFromOpenBank(items, groups, private.GetNumToMoveToBags, true)
	TSM.Banking.MoveToBag(items, callback)
	TempTable.Release(items)
end

function Auctioning.MaxExpiresToBank(callback, groups)
	local items = TempTable.Acquire()
	TSM.Banking.Util.PopulateGroupItemsFromBags(items, groups, private.MaxExpiresGetNumToMoveToBank)
	TSM.Banking.MoveToBank(items, callback)
	TempTable.Release(items)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GroupsGetNumToMoveToBank(itemString, numHave)
	-- move everything
	return numHave
end

function private.GetNumToMoveToBags(itemString, numHave, includeAH)
	local totalNumToMove = 0
	local numAvailable = numHave
	local numInBags = BagTracking.CreateQueryBagsItem(itemString)
		:VirtualField("autoBaseItemString", "string", TSM.Groups.TranslateItemString, "itemString")
		:Equal("autoBaseItemString", itemString)
		:SumAndRelease("quantity") or 0
	if includeAH then
		numInBags = numInBags + select(3, Inventory.GetPlayerTotals(itemString)) + Inventory.GetMailQuantity(itemString)
	end

	for _, _, operationSettings in TSM.Operations.GroupOperationIterator("Auctioning", TSM.Groups.GetPathByItem(itemString)) do
		local maxExpires = TSM.Auctioning.Util.GetPrice("maxExpires", operationSettings, itemString)
		local operationHasExpired = false
		if maxExpires and maxExpires > 0 then
			local numExpires = TSM.Accounting.Auctions.GetNumExpiresSinceSale(itemString)
			if numExpires and numExpires > maxExpires then
				operationHasExpired = true
			end
		end

		local postCap = TSM.Auctioning.Util.GetPrice("postCap", operationSettings, itemString)
		local stackSize = (TSM.IsWowClassic() and TSM.Auctioning.Util.GetPrice("stackSize", operationSettings, itemString)) or (not TSM.IsWowClassic() and 1)
		if not operationHasExpired and postCap and stackSize then
			local numNeeded = stackSize * postCap
			if numInBags > numNeeded then
				-- we can satisfy this operation from the bags
				numInBags = numInBags - numNeeded
				numNeeded = 0
			elseif numInBags > 0 then
				-- we can partially satisfy this operation from the bags
				numNeeded = numNeeded - numInBags
				numInBags = 0
			end

			local numToMove = min(numAvailable, numNeeded)
			if numToMove > 0 then
				numAvailable = numAvailable - numToMove
				totalNumToMove = totalNumToMove + numToMove
			end
		end
	end

	return totalNumToMove
end

function private.MaxExpiresGetNumToMoveToBank(itemString, numHave)
	local numToKeepInBags = 0
	for _, _, operationSettings in TSM.Operations.GroupOperationIterator("Auctioning", TSM.Groups.GetPathByItem(itemString)) do
		local maxExpires = TSM.Auctioning.Util.GetPrice("maxExpires", operationSettings, itemString)
		local operationHasExpired = false
		if maxExpires and maxExpires > 0 then
			local numExpires = TSM.Accounting.Auctions.GetNumExpiresSinceSale(itemString)
			if numExpires and numExpires > maxExpires then
				operationHasExpired = true
			end
		end
		local postCap = TSM.Auctioning.Util.GetPrice("postCap", operationSettings, itemString)
		local stackSize = (TSM.IsWowClassic() and TSM.Auctioning.Util.GetPrice("stackSize", operationSettings, itemString)) or (not TSM.IsWowClassic() and 1)
		if not operationHasExpired and postCap and stackSize then
			numToKeepInBags = numToKeepInBags + stackSize * postCap
		end
	end
	return max(numHave - numToKeepInBags, 0)
end
