-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Queue = TSM.Crafting:NewPackage("Queue")
local ProfessionInfo = TSM.Include("Data.ProfessionInfo")
local CraftString = TSM.Include("Util.CraftString")
local Database = TSM.Include("Util.Database")
local Math = TSM.Include("Util.Math")
local Log = TSM.Include("Util.Log")
local RecipeString = TSM.Include("Util.RecipeString")
local ItemString = TSM.Include("Util.ItemString")
local Inventory = TSM.Include("Service.Inventory")
local CustomPrice = TSM.Include("Service.CustomPrice")
local private = {
	db = nil,
	optionalMatTemp = {},
}
local MAX_NUM_QUEUED = 9999



-- ============================================================================
-- Module Functions
-- ============================================================================

function Queue.OnEnable()
	private.db = Database.NewSchema("CRAFTING_QUEUE")
		:AddUniqueStringField("recipeString")
		:AddStringField("craftString")
		:AddNumberField("num")
		:Commit()
	private.db:SetQueryUpdatesPaused(true)
	for recipeString, numQueued in pairs(TSM.db.factionrealm.internalData.craftingQueue) do
		Queue.SetNum(recipeString, numQueued) -- sanitize / cache the number queued
	end
	private.db:SetQueryUpdatesPaused(false)
end

function Queue.GetDBForJoin()
	return private.db
end

function Queue.CreateQuery()
	return private.db:NewQuery()
end

function Queue.SetNum(recipeString, num)
	assert(type(recipeString) == "string")
	assert(strfind(recipeString, "^r:%d+"))
	local numQueued = min(max(Math.Round(num or 0), 0), MAX_NUM_QUEUED)
	TSM.db.factionrealm.internalData.craftingQueue[recipeString] = numQueued
	local query = private.db:NewQuery()
		:Equal("recipeString", recipeString)
	local row = query:GetFirstResult()
	if row and numQueued == 0 then
		-- delete this row
		private.db:DeleteRow(row)
	elseif row then
		-- update this row
		row:SetField("num", numQueued)
			:Update()
	elseif numQueued > 0 then
		local craftString = CraftString.FromRecipeString(recipeString)
		-- insert a new row
		private.db:NewRow()
			:SetField("recipeString", recipeString)
			:SetField("craftString", craftString)
			:SetField("num", numQueued)
			:Create()
	end
	query:Release()
end

function Queue.GetNum(recipeString)
	return private.db:GetUniqueRowField("recipeString", recipeString, "num") or 0
end

function Queue.GetNumByCraftString(craftString)
	return private.db:NewQuery()
		:Equal("craftString", craftString)
		:SumAndRelease("num")
end

function Queue.Add(recipeString, quantity)
	Queue.SetNum(recipeString, Queue.GetNum(recipeString) + quantity)
end

function Queue.Remove(recipeString, quantity)
	Queue.SetNum(recipeString, Queue.GetNum(recipeString) - quantity)
end

function Queue.Clear()
	local query = private.db:NewQuery()
		:Select("recipeString")
	for _, recipeString in query:Iterator() do
		TSM.db.factionrealm.internalData.craftingQueue[recipeString] = nil
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
		:Select("recipeString", "craftString", "num")
	for _, recipeString, craftString, numQueued in query:Iterator() do
		local numResult = TSM.db.factionrealm.internalData.crafts[craftString] and TSM.db.factionrealm.internalData.crafts[craftString].numResult or 0
		local cost, _, profit = TSM.Crafting.Cost.GetCostsByRecipeString(recipeString)
		if cost then
			totalCost = (totalCost or 0) + cost * numQueued * numResult
		end
		if profit then
			totalProfit = (totalProfit or 0) + profit * numQueued * numResult
		end
		local spellId = CraftString.GetSpellId(craftString)
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
				local baseItemString = ItemString.GetBaseFast(itemString)
				if TSM.Crafting.CanCraftItem(baseItemString) then
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
	local cheapestCost, cheapestCraftString = TSM.Crafting.Cost.GetLowestCostByItem(itemString)
	if not cheapestCraftString then
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
	local itemLevel = ItemString.GetItemLevel(itemString)
	local levelOptionalMat = itemLevel and ProfessionInfo.GetOptionalMatByItemLevel(itemLevel) or nil
	assert(not next(private.optionalMatTemp))
	if levelOptionalMat then
		local levelOptionalMatItemId = ItemString.ToId(levelOptionalMat)
		local found = false
		for _, optionalMatString, slotId in TSM.Crafting.OptionalMatIterator(cheapestCraftString) do
			if not found and (strmatch(optionalMatString, "[:,]"..levelOptionalMatItemId.."$") or strmatch(optionalMatString, "[:,]"..levelOptionalMatItemId..",")) then
				private.optionalMatTemp[slotId] = levelOptionalMatItemId
				found = true
			end
		end
	end
	local level = CraftString.GetLevel(cheapestCraftString)
	if level then
		local relItemLevel, isAbs = ItemString.ParseLevel(ItemString.ToLevel(itemString))
		if not isAbs then
			local optionalMatItemString = ProfessionInfo.GetOptionalMatByRelItemLevel(relItemLevel)
			if relItemLevel and optionalMatItemString then
				private.optionalMatTemp[#private.optionalMatTemp + 1] = ItemString.ToId(optionalMatItemString)
			end
		end
	end
	local cheapestRecipeString = RecipeString.FromCraftString(cheapestCraftString, private.optionalMatTemp)
	wipe(private.optionalMatTemp)
	Queue.SetNum(cheapestRecipeString, floor(neededQuantity / TSM.Crafting.GetNumResult(cheapestCraftString)))
end
