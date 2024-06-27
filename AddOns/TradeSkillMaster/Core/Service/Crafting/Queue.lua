-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Queue = TSM.Crafting:NewPackage("Queue")
local CraftString = TSM.Include("Util.CraftString")
local Database = TSM.Include("Util.Database")
local Math = TSM.Include("Util.Math")
local Log = TSM.Include("Util.Log")
local TempTable = TSM.Include("Util.TempTable")
local RecipeString = TSM.Include("Util.RecipeString")
local ItemString = TSM.Include("Util.ItemString")
local MatString = TSM.Include("Util.MatString")
local AltTracking = TSM.Include("Service.AltTracking")
local CustomPrice = TSM.Include("Service.CustomPrice")
local Settings = TSM.Include("Service.Settings")
local private = {
	settings = nil,
	db = nil,
	optionalMatTemp = {},
	matsTemp = {},
	qualityMatTemp = {},
}
local MAX_NUM_QUEUED = 9999



-- ============================================================================
-- Module Functions
-- ============================================================================

function Queue.OnEnable()
	private.settings = Settings.NewView()
		:AddKey("factionrealm", "internalData", "craftingQueue")
	private.db = Database.NewSchema("CRAFTING_QUEUE")
		:AddUniqueStringField("recipeString")
		:AddStringField("craftString")
		:AddNumberField("num")
		:Commit()

	-- Copy to a temp table first since we might otherwise be modifying the settings table as we iterate
	local queuedRecipes = TempTable.Acquire()
	for recipeString, numQueued in pairs(private.settings.craftingQueue) do
		queuedRecipes[recipeString] = numQueued
	end
	private.db:SetQueryUpdatesPaused(true)
	for recipeString, numQueued in pairs(queuedRecipes) do
		Queue.SetNum(recipeString, numQueued)
	end
	private.db:SetQueryUpdatesPaused(false)
	TempTable.Release(queuedRecipes)
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
	private.settings.craftingQueue[recipeString] = numQueued > 0 and numQueued or nil
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
	wipe(private.settings.craftingQueue)
	private.db:Truncate()
end

function Queue.GetNumItems()
	return private.db:NewQuery():CountAndRelease()
end

function Queue.GetTotals()
	local totalCost, totalProfit, totalCastTimeMs = nil, nil, nil
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
	end
	query:Release()
	return totalCost, totalProfit, totalCastTimeMs and ceil(totalCastTimeMs / 1000) or nil
end

function Queue.RestockGroups(groups)
	private.db:SetQueryUpdatesPaused(true)
	for _, groupPath in ipairs(groups) do
		if groupPath ~= TSM.CONST.ROOT_GROUP_PATH then
			for _, itemString in TSM.Groups.ItemIterator(groupPath) do
				local levelItemString = ItemString.ToLevel(itemString)
				if TSM.Crafting.CanCraftItem(levelItemString) then
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
	assert(not next(private.optionalMatTemp) and not next(private.qualityMatTemp))
	local cheapestCost, cheapestCraftString = TSM.Crafting.Cost.GetLowestCostByItem(itemString, private.optionalMatTemp, private.qualityMatTemp)
	if not cheapestCraftString then
		-- can't craft this item
		wipe(private.qualityMatTemp)
		wipe(private.optionalMatTemp)
		return
	end
	for _, matItemString in ipairs(private.qualityMatTemp) do
		local matString = private.qualityMatTemp[matItemString]
		private.optionalMatTemp[MatString.GetSlotId(matString)] = ItemString.ToId(matItemString)
	end
	wipe(private.qualityMatTemp)
	local recipeString = RecipeString.FromCraftString(cheapestCraftString, private.optionalMatTemp)
	wipe(private.optionalMatTemp)
	local itemValue = TSM.Crafting.Cost.GetCraftedItemValue(itemString)
	local profit = itemValue and cheapestCost and (itemValue - cheapestCost) or nil
	local hasMinProfit, minProfit = TSM.Operations.Crafting.GetMinProfit(itemString)
	if hasMinProfit and (not minProfit or not profit or profit < minProfit) then
		-- profit is too low
		return
	end

	local haveQuantity = CustomPrice.GetSourcePrice(itemString, "NumInventory") or 0
	for guild, ignored in pairs(TSM.db.global.craftingOptions.ignoreGuilds) do
		if ignored then
			haveQuantity = haveQuantity - AltTracking.GetGuildQuantity(itemString, guild)
		end
	end
	for player, ignored in pairs(TSM.db.global.craftingOptions.ignoreCharacters) do
		if ignored then
			haveQuantity = haveQuantity - AltTracking.GetBagQuantity(itemString, player)
			haveQuantity = haveQuantity - AltTracking.GetBankQuantity(itemString, player)
			haveQuantity = haveQuantity - AltTracking.GetReagentBankQuantity(itemString, player)
			haveQuantity = haveQuantity - AltTracking.GetAuctionQuantity(itemString, player)
			haveQuantity = haveQuantity - AltTracking.GetMailQuantity(itemString, player)
		end
	end
	assert(haveQuantity >= 0)
	local neededQuantity = TSM.Operations.Crafting.GetRestockQuantity(itemString, haveQuantity)
	if neededQuantity == 0 then
		return
	end
	local chance = 1
	if CraftString.GetQuality(cheapestCraftString) then
		assert(not next(private.matsTemp) and not next(private.qualityMatTemp))
		TSM.Crafting.GetMatsAsTable(cheapestCraftString, private.matsTemp)
		local canCraft, inspirationChance = TSM.Crafting.DFCrafting.GetOptionalMats(cheapestCraftString, private.matsTemp, private.qualityMatTemp)
		if canCraft then
			chance = inspirationChance
		end
		wipe(private.qualityMatTemp)
		wipe(private.matsTemp)
	end
	Queue.SetNum(recipeString, floor(neededQuantity / (TSM.Crafting.GetNumResult(cheapestCraftString) * chance)))
end
