-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Queue = TSM.Crafting:NewPackage("Queue")
local Database = TSM.Include("Util.Database")
local Math = TSM.Include("Util.Math")
local Log = TSM.Include("Util.Log")
local Inventory = TSM.Include("Service.Inventory")
local CustomPrice = TSM.Include("Service.CustomPrice")
local private = {
	db = nil,
}
local MAX_NUM_QUEUED = 9999



-- ============================================================================
-- Module Functions
-- ============================================================================

function Queue.OnEnable()
	private.db = Database.NewSchema("CRAFTING_QUEUE")
		:AddUniqueNumberField("spellId")
		:AddNumberField("num")
		:Commit()
	private.db:SetQueryUpdatesPaused(true)
	for spellId, data in pairs(TSM.db.factionrealm.internalData.crafts) do
		Queue.SetNum(spellId, data.queued) -- sanitize / cache the number queued
	end
	private.db:SetQueryUpdatesPaused(false)
end

function Queue.GetDBForJoin()
	return private.db
end

function Queue.CreateQuery()
	return private.db:NewQuery()
end

function Queue.SetNum(spellId, num)
	local craftInfo = TSM.db.factionrealm.internalData.crafts[spellId]
	if not craftInfo then
		Log.Err("Could not find craft: "..spellId)
		return
	end
	craftInfo.queued = min(max(Math.Round(num or 0), 0), MAX_NUM_QUEUED)
	local query = private.db:NewQuery()
		:Equal("spellId", spellId)
	local row = query:GetFirstResult()
	if row and craftInfo.queued == 0 then
		-- delete this row
		private.db:DeleteRow(row)
	elseif row then
		-- update this row
		row:SetField("num", craftInfo.queued)
			:Update()
	elseif craftInfo.queued > 0 then
		-- insert a new row
		private.db:NewRow()
			:SetField("spellId", spellId)
			:SetField("num", craftInfo.queued)
			:Create()
	end
	query:Release()
end

function Queue.GetNum(spellId)
	return private.db:GetUniqueRowField("spellId", spellId, "num") or 0
end

function Queue.Add(spellId, quantity)
	Queue.SetNum(spellId, Queue.GetNum(spellId) + quantity)
end

function Queue.Remove(spellId, quantity)
	Queue.SetNum(spellId, Queue.GetNum(spellId) - quantity)
end

function Queue.Clear()
	local query = private.db:NewQuery()
		:Select("spellId")
	for _, spellId in query:Iterator() do
		local craftInfo = TSM.db.factionrealm.internalData.crafts[spellId]
		if craftInfo then
			craftInfo.queued = 0
		end
	end
	query:Release()
	private.db:Truncate()
end

function Queue.GetNumItems()
	return private.db:NewQuery():CountAndRelease()
end

function Queue.GetTotals()
	local totalCost, totalProfit, totalCastTimeMs, totalNumQueued = nil, nil, nil, 0
	local query = private.db:NewQuery()
		:Select("spellId", "num")
	for _, spellId, numQueued in query:Iterator() do
		local numResult = TSM.db.factionrealm.internalData.crafts[spellId] and TSM.db.factionrealm.internalData.crafts[spellId].numResult or 0
		local cost, _, profit = TSM.Crafting.Cost.GetCostsBySpellId(spellId)
		if cost then
			totalCost = (totalCost or 0) + cost * numQueued * numResult
		end
		if profit then
			totalProfit = (totalProfit or 0) + profit * numQueued * numResult
		end
		local castTime = select(4, GetSpellInfo(spellId))
		if castTime then
			totalCastTimeMs = (totalCastTimeMs or 0) + castTime * numQueued
		end
		totalNumQueued = totalNumQueued + numQueued

	end
	query:Release()
	return totalCost, totalProfit, totalCastTimeMs and ceil(totalCastTimeMs / 1000) or nil, totalNumQueued
end

function Queue.RestockGroups(groups)
	private.db:SetQueryUpdatesPaused(true)
	for _, groupPath in ipairs(groups) do
		if groupPath ~= TSM.CONST.ROOT_GROUP_PATH then
			for _, itemString in TSM.Groups.ItemIterator(groupPath) do
				if TSM.Crafting.CanCraftItem(itemString) then
					local isValid, err = TSM.Operations.Crafting.IsValid(itemString)
					if isValid then
						private.RestockItem(itemString)
					elseif err then
						Log.PrintUser(err)
					end
				end
			end
		end
	end
	private.db:SetQueryUpdatesPaused(false)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.RestockItem(itemString)
	local cheapestCost, cheapestSpellId = TSM.Crafting.Cost.GetLowestCostByItem(itemString)
	if not cheapestSpellId then
		-- can't craft this item
		return
	end
	local itemValue = TSM.Crafting.Cost.GetCraftedItemValue(itemString)
	local profit = itemValue and cheapestCost and (itemValue - cheapestCost) or nil
	local hasMinProfit, minProfit = TSM.Operations.Crafting.GetMinProfit(itemString)
	if hasMinProfit and (not minProfit or not profit or profit < minProfit) then
		-- profit is too low
		return
	end

	local haveQuantity = CustomPrice.GetItemPrice(itemString, "NumInventory") or 0
	for guild, ignored in pairs(TSM.db.global.craftingOptions.ignoreGuilds) do
		if ignored then
			haveQuantity = haveQuantity - Inventory.GetGuildQuantity(itemString, guild)
		end
	end
	for player, ignored in pairs(TSM.db.global.craftingOptions.ignoreCharacters) do
		if ignored then
			haveQuantity = haveQuantity - Inventory.GetBagQuantity(itemString, player)
			haveQuantity = haveQuantity - Inventory.GetBankQuantity(itemString, player)
			haveQuantity = haveQuantity - Inventory.GetReagentBankQuantity(itemString, player)
			haveQuantity = haveQuantity - Inventory.GetAuctionQuantity(itemString, player)
			haveQuantity = haveQuantity - Inventory.GetMailQuantity(itemString, player)
		end
	end
	assert(haveQuantity >= 0)
	local neededQuantity = TSM.Operations.Crafting.GetRestockQuantity(itemString, haveQuantity)
	if neededQuantity == 0 then
		return
	end
	-- queue only if it satisfies all operation criteria
	Queue.SetNum(cheapestSpellId, floor(neededQuantity / TSM.Crafting.GetNumResult(cheapestSpellId)))
end
