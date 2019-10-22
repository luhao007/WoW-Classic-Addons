-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM:NewPackage("Crafting")
local L = TSM.L
local private = {
	spellDB = nil,
	matDB = nil,
	matItemDB = nil,
	matDBSpellIdQuery = nil,
	ignoredCooldownDB = nil,
}
local CHARACTER_KEY = UnitName("player").." - "..GetRealmName()
local IGNORED_COOLDOWN_SEP = "\001"
local PROFESSION_SEP = ","
local PLAYER_SEP = ","



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	local used = TSM.TempTable.Acquire()
	for _, craftInfo in pairs(TSM.db.factionrealm.internalData.crafts) do
		for itemString in pairs(craftInfo.mats) do
			used[itemString] = true
			if not TSM.db.factionrealm.internalData.mats[itemString] then
				TSM.db.factionrealm.internalData.mats[itemString] = {}
			end
			-- clear the old name field
			TSM.db.factionrealm.internalData.mats[itemString].name = nil
		end
	end
	for itemString in pairs(TSM.db.factionrealm.internalData.mats) do
		if not used[itemString] then
			TSM.db.factionrealm.internalData.mats[itemString] = nil
		end
	end
	TSM.TempTable.Release(used)

	local professionItems = TSM.TempTable.Acquire()
	local matSpellCount = TSM.TempTable.Acquire()
	local matFirstItemString = TSM.TempTable.Acquire()
	local matFirstQuantity = TSM.TempTable.Acquire()
	private.matDB = TSMAPI_FOUR.Database.NewSchema("CRAFTING_MATS")
		:AddNumberField("spellId")
		:AddStringField("itemString")
		:AddNumberField("quantity")
		:AddIndex("spellId")
		:AddIndex("itemString")
		:Commit()
	private.matDB:BulkInsertStart()
	private.spellDB = TSMAPI_FOUR.Database.NewSchema("CRAFTING_SPELLS")
		:AddUniqueNumberField("spellId")
		:AddStringField("itemString")
		:AddStringField("itemName")
		:AddStringField("name")
		:AddStringField("profession")
		:AddNumberField("numResult")
		:AddStringField("players")
		:AddBooleanField("hasCD")
		:AddIndex("itemString")
		:Commit()
	private.spellDB:BulkInsertStart()
	local playersTemp = TSM.TempTable.Acquire()
	for spellId, craftInfo in pairs(TSM.db.factionrealm.internalData.crafts) do
		wipe(playersTemp)
		for player in pairs(craftInfo.players) do
			tinsert(playersTemp, player)
		end
		sort(playersTemp)
		local playersStr = table.concat(playersTemp, PLAYER_SEP)
		local itemName = TSMAPI_FOUR.Item.GetName(craftInfo.itemString) or ""
		private.spellDB:BulkInsertNewRow(spellId, craftInfo.itemString, itemName, craftInfo.name or "", craftInfo.profession, craftInfo.numResult, playersStr, craftInfo.hasCD and true or false)

		for matItemString, matQuantity in pairs(craftInfo.mats) do
			private.matDB:BulkInsertNewRow(spellId, matItemString, matQuantity)
			professionItems[craftInfo.profession] = professionItems[craftInfo.profession] or TSM.TempTable.Acquire()
			professionItems[craftInfo.profession][matItemString] = true
			matSpellCount[spellId] = (matSpellCount[spellId] or 0) + 1
			matFirstItemString[spellId] = matItemString
			matFirstQuantity[spellId] = matQuantity
		end
	end
	TSM.TempTable.Release(playersTemp)
	private.spellDB:BulkInsertEnd()
	private.matDB:BulkInsertEnd()

	private.matDBMatsInTableQuery = private.matDB:NewQuery()
		:Select("itemString", "quantity")
		:Equal("spellId", TSM.CONST.BOUND_QUERY_PARAM)

	private.matItemDB = TSMAPI_FOUR.Database.NewSchema("CRAFTING_MAT_ITEMS")
		:AddUniqueStringField("itemString")
		:AddStringField("professions")
		:AddBooleanField("hasCustomValue")
		:Commit()
	private.matItemDB:BulkInsertStart()
	local professionsTemp = TSM.TempTable.Acquire()
	for itemString, info in pairs(TSM.db.factionrealm.internalData.mats) do
		wipe(professionsTemp)
		for profession, items in pairs(professionItems) do
			if items[itemString] then
				tinsert(professionsTemp, profession)
			end
		end
		sort(professionsTemp)
		local professionsStr = table.concat(professionsTemp)
		private.matItemDB:BulkInsertNewRow(itemString, professionsStr, info.customValue and true or false)
	end
	TSM.TempTable.Release(professionsTemp)
	private.matItemDB:BulkInsertEnd()

	for _, tbl in pairs(professionItems) do
		TSM.TempTable.Release(tbl)
	end
	TSM.TempTable.Release(professionItems)

	private.matDBSpellIdQuery = private.matDB:NewQuery()
		:Equal("spellId", TSM.CONST.BOUND_QUERY_PARAM)

	-- register 1:1 crafting conversions
	local query = private.spellDB:NewQuery()
		:Select("spellId", "itemString", "numResult")
		:Equal("hasCD", false)
	for _, spellId, itemString, numResult in query:Iterator() do
		if not TSM.CONST.MASS_MILLING_RECIPES[spellId] and matSpellCount[spellId] == 1 then
			TSMAPI_FOUR.Conversions.Add(itemString, matFirstItemString[spellId], numResult / matFirstQuantity[spellId], "craft")
		end
	end
	query:Release()
	TSM.TempTable.Release(matSpellCount)
	TSM.TempTable.Release(matFirstItemString)
	TSM.TempTable.Release(matFirstQuantity)

	local isValid, err = TSMAPI_FOUR.CustomPrice.Validate(TSM.db.global.craftingOptions.defaultCraftPriceMethod, "crafting")
	if not isValid then
		TSM:Printf(L["Your default craft value method was invalid so it has been returned to the default. Details: %s"], err)
		TSM.db.global.craftingOptions.defaultCraftPriceMethod = TSM.db:GetDefault("global", "craftingOptions", "defaultCraftPriceMethod")
	end

	private.ignoredCooldownDB = TSMAPI_FOUR.Database.NewSchema("IGNORED_COOLDOWNS")
		:AddStringField("characterKey")
		:AddNumberField("spellId")
		:Commit()
	private.ignoredCooldownDB:BulkInsertStart()
	for entry in pairs(TSM.db.factionrealm.userData.craftingCooldownIgnore) do
		local characterKey, spellId = strsplit(IGNORED_COOLDOWN_SEP, entry)
		private.ignoredCooldownDB:BulkInsertNewRow(characterKey, tonumber(spellId))
	end
	private.ignoredCooldownDB:BulkInsertEnd()
end

function Crafting.HasSpellId(spellId)
	return private.spellDB:HasUniqueRow("spellId", spellId)
end

function Crafting.CreateRawCraftsQuery()
	return private.spellDB:NewQuery()
end

function Crafting.CreateCraftsQuery()
	return private.spellDB:NewQuery()
		:LeftJoin(TSM.Crafting.Queue.GetDBForJoin(), "spellId")
		:VirtualField("bagQuantity", "number", TSMAPI_FOUR.Inventory.GetBagQuantity, "itemString")
		:VirtualField("auctionQuantity", "number", TSMAPI_FOUR.Inventory.GetAuctionQuantity, "itemString")
		:VirtualField("craftingCost", "number", private.CraftingCostVirtualField, "spellId")
		:VirtualField("itemValue", "number", private.ItemValueVirtualField, "itemString")
		:VirtualField("profit", "number", private.ProfitVirtualField, "spellId")
		:VirtualField("saleRate", "number", private.SaleRateVirtualField, "itemString")
end

function Crafting.CreateQueuedCraftsQuery()
	return private.spellDB:NewQuery()
		:InnerJoin(TSM.Crafting.Queue.GetDBForJoin(), "spellId")
end

function Crafting.CreateCooldownSpellsQuery()
	return private.spellDB:NewQuery()
		:Equal("hasCD", true)
end

function Crafting.CreateRawMatItemQuery()
	return private.matItemDB:NewQuery()
end

function Crafting.CreateMatItemQuery()
	return private.matItemDB:NewQuery()
		:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
		:VirtualField("matCost", "number", private.MatCostVirtualField, "itemString")
		:VirtualField("totalQuantity", "number", TSMAPI_FOUR.Inventory.GetTotalQuantity, "itemString")
end

function Crafting.SpellIterator()
	return private.spellDB:NewQuery()
		:Select("spellId")
		:IteratorAndRelease()
end

function Crafting.GetSpellIdsByItem(itemString, ignoreCD)
	local query = private.spellDB:NewQuery()
		:Equal("itemString", itemString)

	if ignoreCD then
		query:Select("spellId")
		query:Equal("hasCD", false)
	else
		query:Select("spellId", "hasCD")
	end

	return query:IteratorAndRelease()
end

function Crafting.GetMostProfitableSpellIdByItem(itemString, playerFilter)
	local maxProfit, bestSpellId = nil, nil
	local maxProfitCD, bestSpellIdCD = nil, nil
	for _, spellId, hasCD in Crafting.GetSpellIdsByItem(itemString, TSM.db.global.craftingOptions.ignoreCDCraftCost) do
		if not playerFilter or TSM.Vararg.In(playerFilter, Crafting.GetPlayers(spellId)) then
			local profit = TSM.Crafting.Cost.GetProfitBySpellId(spellId)
			if hasCD then
				if profit and profit > (maxProfitCD or -math.huge) then
					maxProfitCD = profit
					bestSpellIdCD = spellId
				elseif not maxProfitCD then
					bestSpellIdCD = spellId
				end
			else
				if profit and profit > (maxProfit or -math.huge) then
					maxProfit = profit
					bestSpellId = spellId
				elseif not maxProfit then
					bestSpellId = spellId
				end
			end
		end
	end
	if maxProfit then
		return bestSpellId, maxProfit
	elseif maxProfitCD then
		return bestSpellIdCD, maxProfitCD
	else
		return bestSpellId or bestSpellIdCD or nil, nil
	end
end

function Crafting.GetItemString(spellId)
	return private.spellDB:GetUniqueRowField("spellId", spellId, "itemString")
end

function Crafting.GetProfession(spellId)
	return private.spellDB:GetUniqueRowField("spellId", spellId, "profession")
end

function Crafting.GetNumResult(spellId)
	return private.spellDB:GetUniqueRowField("spellId", spellId, "numResult")
end

function Crafting.GetPlayers(spellId)
	local players = private.spellDB:GetUniqueRowField("spellId", spellId, "players")
	if not players then
		return
	end
	return strsplit(PLAYER_SEP, players)
end

function Crafting.GetName(spellId)
	return private.spellDB:GetUniqueRowField("spellId", spellId, "name")
end

function Crafting.MatIterator(spellId)
	return private.matDB:NewQuery()
		:Select("itemString", "quantity")
		:Equal("spellId", spellId)
		:IteratorAndRelease()
end

function Crafting.GetMatsAsTable(spellId, tbl)
	private.matDBMatsInTableQuery:BindParams(spellId)
	private.matDBMatsInTableQuery:AsTable(tbl)
end

function Crafting.RemovePlayers(spellId, playersToRemove)
	local shouldRemove = TSM.TempTable.Acquire()
	for _, player in ipairs(playersToRemove) do
		shouldRemove[player] = true
	end
	local players = TSM.TempTable.Acquire(Crafting.GetPlayers(spellId))
	for i = #players, 1, -1 do
		local player = players[i]
		if shouldRemove[player] then
			TSM.db.factionrealm.internalData.crafts[spellId].players[player] = nil
			tremove(players, i)
		end
	end
	TSM.TempTable.Release(shouldRemove)
	local query = private.spellDB:NewQuery()
		:Equal("spellId", spellId)
	local row = query:GetFirstResult()

	local playersStr = strjoin(PLAYER_SEP, TSM.TempTable.UnpackAndRelease(players))
	if playersStr ~= "" then
		row:SetField("players", playersStr)
			:Update()
		query:Release()
		return true
	end

	-- no more players so remove this spell and all its mats
	private.spellDB:DeleteRow(row)
	query:Release()
	TSM.db.factionrealm.internalData.crafts[spellId] = nil

	local removedMats = TSM.TempTable.Acquire()
	private.matDB:SetQueryUpdatesPaused(true)
	query = private.matDB:NewQuery()
		:Equal("spellId", spellId)
	for _, matRow in query:Iterator() do
		removedMats[matRow:GetField("itemString")] = true
		private.matDB:DeleteRow(matRow)
	end
	query:Release()
	private.matDB:SetQueryUpdatesPaused(false)
	private.ProcessRemovedMats(removedMats)
	TSM.TempTable.Release(removedMats)

	return false
end

function Crafting.SetSpellDBQueryUpdatesPaused(paused)
	private.spellDB:SetQueryUpdatesPaused(paused)
end

function Crafting.CreateOrUpdate(spellId, itemString, profession, name, numResult, player, hasCD)
	local row = private.spellDB:GetUniqueRow("spellId", spellId)
	if row then
		local playersStr = row:GetField("players")
		local foundPlayer = TSM.String.SeparatedContains(playersStr, PLAYER_SEP, player)
		if not foundPlayer then
			assert(playersStr ~= "")
			playersStr = playersStr .. PLAYER_SEP .. player
		end
		row:SetField("itemString", itemString)
			:SetField("profession", profession)
			:SetField("itemName", TSMAPI_FOUR.Item.GetName(itemString) or "")
			:SetField("name", name)
			:SetField("numResult", numResult)
			:SetField("players", playersStr)
			:SetField("hasCD", hasCD)
			:Update()
		row:Release()
		local craftInfo = TSM.db.factionrealm.internalData.crafts[spellId]
		craftInfo.itemString = itemString
		craftInfo.profession = profession
		craftInfo.name = name
		craftInfo.numResult = numResult
		craftInfo.players[player] = true
		craftInfo.hasCD = hasCD or nil
	else
		TSM.db.factionrealm.internalData.crafts[spellId] = {
			mats = {},
			players = { [player] = true },
			queued = 0,
			itemString = itemString,
			name = name,
			profession = profession,
			numResult = numResult,
			hasCD = hasCD,
		}
		private.spellDB:NewRow()
			:SetField("spellId", spellId)
			:SetField("itemString", itemString)
			:SetField("profession", profession)
			:SetField("itemName", TSMAPI_FOUR.Item.GetName(itemString) or "")
			:SetField("name", name)
			:SetField("numResult", numResult)
			:SetField("players", player)
			:SetField("hasCD", hasCD)
			:Create()
	end
end

function Crafting.AddPlayer(spellId, player)
	if TSM.db.factionrealm.internalData.crafts[spellId].players[player] then
		return
	end
	local row = private.spellDB:GetUniqueRow("spellId", spellId)
	local playersStr = row:GetField("players")
	assert(playersStr ~= "")
	playersStr = playersStr .. PLAYER_SEP .. player
	row:SetField("players", playersStr)
	row:Update()
	row:Release()
	TSM.db.factionrealm.internalData.crafts[spellId].players[player] = true
end

function Crafting.SetMats(spellId, matQuantities)
	if TSM.Table.Equal(TSM.db.factionrealm.internalData.crafts[spellId].mats, matQuantities) then
		-- nothing changed
		return
	end

	wipe(TSM.db.factionrealm.internalData.crafts[spellId].mats)
	for itemString, quantity in pairs(matQuantities) do
		TSM.db.factionrealm.internalData.crafts[spellId].mats[itemString] = quantity
	end

	private.matDB:SetQueryUpdatesPaused(true)
	local removedMats = TSM.TempTable.Acquire()
	local usedMats = TSM.TempTable.Acquire()
	private.matDBSpellIdQuery:BindParams(spellId)
	for _, row in private.matDBSpellIdQuery:Iterator() do
		local itemString = row:GetField("itemString")
		local quantity = matQuantities[itemString]
		if not quantity then
			-- remove this row
			private.matDB:DeleteRow(row)
			removedMats[itemString] = true
		else
			usedMats[itemString] = true
			row:SetField("quantity", quantity)
				:Update()
		end
	end
	local profession = Crafting.GetProfession(spellId)
	for itemString, quantity in pairs(matQuantities) do
		if not usedMats[itemString] then
			private.matDB:NewRow()
				:SetField("spellId", spellId)
				:SetField("itemString", itemString)
				:SetField("quantity", quantity)
				:Create()
			local matItemRow = private.matItemDB:GetUniqueRow("itemString", itemString)
			if matItemRow then
				-- update the professions if necessary
				local professions = TSM.TempTable.Acquire(strsplit(PROFESSION_SEP, matItemRow:GetField("professions")))
				if not TSM.Table.KeyByValue(professions, profession) then
					tinsert(professions, profession)
					sort(professions)
					matItemRow:SetField("professions", table.concat(professions, PROFESSION_SEP))
						:Update()
				end
				TSM.TempTable.Release(professions)
			else
				private.matItemDB:NewRow()
					:SetField("itemString", itemString)
					:SetField("professions", profession)
					:SetField("hasCustomValue", TSM.db.factionrealm.internalData.mats[itemString].customValue and true or false)
					:Create()
			end
		end
	end
	TSM.TempTable.Release(usedMats)
	private.matDB:SetQueryUpdatesPaused(false)

	private.ProcessRemovedMats(removedMats)
	TSM.TempTable.Release(removedMats)
end

function Crafting.SetMatCustomValue(itemString, value)
	TSM.db.factionrealm.internalData.mats[itemString].customValue = value
	private.matItemDB:GetUniqueRow("itemString", itemString)
		:SetField("hasCustomValue", value and true or false)
		:Update()
end

function Crafting.CanCraftItem(itemString)
	local count = private.spellDB:NewQuery()
		:Equal("itemString", itemString)
		:CountAndRelease()
	return count > 0
end

function Crafting.RestockHelp(link)
	local itemString = TSMAPI_FOUR.Item.ToItemString(link)
	if not itemString then
		return print(L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"])
	end

	TSM:Printf(L["Restock help for %s:"], link)

	-- check if the item is in a group
	local groupPath = TSM.Groups.GetPathByItem(itemString)
	if not groupPath then
		return print(L["This item is not in a TSM group."])
	end

	-- check that there's a crafting operation applied
	if not TSM.Operations.Crafting.HasOperation(itemString) then
		return print(format(L["There is no Crafting operation applied to this item's TSM group (%s)."], TSM.Groups.Path.Format(groupPath)))
	end

	-- check if it's an invalid operation
	local isValid, err = TSM.Operations.Crafting.IsValid(itemString)
	if not isValid then
		return print(err)
	end

	-- check that this item is craftable
	if not TSM.Crafting.CanCraftItem(itemString) then
		return print(L["You don't know how to craft this item."])
	end

	-- check the restock quantity
	local neededQuantity = TSM.Operations.Crafting.GetRestockQuantity(itemString, TSMAPI_FOUR.Inventory.GetTotalQuantity(itemString))
	if neededQuantity then
		return print(format(L["You either already have at least your max restock quantity of this item or the number which would be queued is less than the min restock quantity."]))
	end

	-- check the prices on the item and the min profit
	local hasMinProfit, minProfit = TSM.Operations.Crafting.GetMinProfit(itemString)
	if hasMinProfit then
		local cost = TSM.Crafting.Cost.GetLowestCostByItem(itemString)
		local craftedValue = TSM.Crafting.Cost.GetCraftedItemValue(itemString)
		local profit = cost and craftedValue and (craftedValue - cost) or nil

		-- check that there's a crafted value
		if not craftedValue then
			return print(L["The 'Craft Value Method' did not return a value for this item."])
		end

		-- check that there's a crafted cost
		if not cost then
			return print(L["This item does not have a crafting cost. Check that all of its mats have mat prices."])
		end

		-- check that there's a profit
		if not profit then
			return print(L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"])
		end

		if not minProfit then
			return print(L["The min profit did not evalulate to a valid value for this item."])
		end

		if profit < minProfit then
			return print(format(L["The profit of this item (%s) is below the min profit (%s)."], TSM.Money.ToString(profit), TSM.Money.ToString(minProfit)))
		end
	end

	print(L["This item will be added to the queue when you restock its group. If this isn't happening, please visit http://support.tradeskillmaster.com for further assistance."])
end

function Crafting.IgnoreCooldown(spellId)
	assert(not TSM.db.factionrealm.userData.craftingCooldownIgnore[CHARACTER_KEY..IGNORED_COOLDOWN_SEP..spellId])
	TSM.db.factionrealm.userData.craftingCooldownIgnore[CHARACTER_KEY..IGNORED_COOLDOWN_SEP..spellId] = true
	private.ignoredCooldownDB:NewRow()
		:SetField("characterKey", CHARACTER_KEY)
		:SetField("spellId", spellId)
		:Create()
end

function Crafting.IsCooldownIgnored(spellId)
	return TSM.db.factionrealm.userData.craftingCooldownIgnore[CHARACTER_KEY..IGNORED_COOLDOWN_SEP..spellId]
end

function Crafting.CreateIgnoredCooldownQuery()
	return private.ignoredCooldownDB:NewQuery()
end

function Crafting.RemoveIgnoredCooldown(characterKey, spellId)
	assert(TSM.db.factionrealm.userData.craftingCooldownIgnore[characterKey..IGNORED_COOLDOWN_SEP..spellId])
	TSM.db.factionrealm.userData.craftingCooldownIgnore[characterKey..IGNORED_COOLDOWN_SEP..spellId] = nil
	local row = private.ignoredCooldownDB:NewQuery()
		:Equal("characterKey", characterKey)
		:Equal("spellId", spellId)
		:GetFirstResultAndRelease()
	assert(row)
	private.ignoredCooldownDB:DeleteRow(row)
	row:Release()
end

function Crafting.GetMatNames(spellId)
	local query = private.matDB:NewQuery()
		:Select("name")
		:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
		:Equal("spellId", spellId)
	local result = query:JoinedString("name", "")
	query:Release()
	return result
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ProcessRemovedMats(removedMats)
	private.matItemDB:SetQueryUpdatesPaused(true)
	for itemString in pairs(removedMats) do
		local numSpells = private.matDB:NewQuery()
			:Equal("itemString", itemString)
			:CountAndRelease()
		if numSpells == 0 then
			local matItemRow = private.matItemDB:GetUniqueRow("itemString", itemString)
			private.matItemDB:DeleteRow(matItemRow)
			matItemRow:Release()
		end
	end
	private.matItemDB:SetQueryUpdatesPaused(false)
end

function private.CraftingCostVirtualField(spellId)
	return TSM.Crafting.Cost.GetCraftingCostBySpellId(spellId) or math.huge * 0
end

function private.ItemValueVirtualField(itemString)
	return TSM.Crafting.Cost.GetCraftedItemValue(itemString) or math.huge * 0
end

function private.ProfitVirtualField(spellId)
	return TSM.Crafting.Cost.GetProfitBySpellId(spellId) or math.huge * 0
end

function private.SaleRateVirtualField(itemString)
	local saleRate = TSM.AuctionDB.GetRegionItemData(itemString, "regionSalePercent")
	return saleRate and (saleRate / 100) or math.huge * 0
end

function private.MatCostVirtualField(itemString)
	return TSM.Crafting.Cost.GetMatCost(itemString) or math.huge * 0
end
