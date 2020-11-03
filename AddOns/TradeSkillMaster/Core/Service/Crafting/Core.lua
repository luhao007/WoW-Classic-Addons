-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM:NewPackage("Crafting")
local L = TSM.Include("Locale").GetTable()
local ProfessionInfo = TSM.Include("Data.ProfessionInfo")
local Database = TSM.Include("Util.Database")
local TempTable = TSM.Include("Util.TempTable")
local Table = TSM.Include("Util.Table")
local Math = TSM.Include("Util.Math")
local Money = TSM.Include("Util.Money")
local String = TSM.Include("Util.String")
local Vararg = TSM.Include("Util.Vararg")
local Log = TSM.Include("Util.Log")
local ItemString = TSM.Include("Util.ItemString")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
local Conversions = TSM.Include("Service.Conversions")
local Inventory = TSM.Include("Service.Inventory")
local private = {
	spellDB = nil,
	matDB = nil,
	matItemDB = nil,
	matDBSpellIdQuery = nil,
	matDBMatsInTableQuery = nil,
	matDBMatNamesQuery = nil,
	ignoredCooldownDB = nil,
}
local CHARACTER_KEY = UnitName("player").." - "..GetRealmName()
local IGNORED_COOLDOWN_SEP = "\001"
local PROFESSION_SEP = ","
local PLAYER_SEP = ","
local BAD_CRAFTING_PRICE_SOURCES = {
	crafting = true,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	local used = TempTable.Acquire()
	for _, craftInfo in pairs(TSM.db.factionrealm.internalData.crafts) do
		for itemString in pairs(craftInfo.mats) do
			if strmatch(itemString, "^o:") then
				local _, _, matList = strsplit(":", itemString)
				for matItemId in String.SplitIterator(matList, ",") do
					used["i:"..matItemId] = true
				end
			else
				used[itemString] = true
			end
		end
	end
	for itemString in pairs(used) do
		TSM.db.factionrealm.internalData.mats[itemString] = TSM.db.factionrealm.internalData.mats[itemString] or {}
	end
	for itemString in pairs(TSM.db.factionrealm.internalData.mats) do
		if not used[itemString] then
			TSM.db.factionrealm.internalData.mats[itemString] = nil
		end
	end
	TempTable.Release(used)

	local professionItems = TempTable.Acquire()
	local matSpellCount = TempTable.Acquire()
	local matFirstItemString = TempTable.Acquire()
	local matFirstQuantity = TempTable.Acquire()
	private.matDB = Database.NewSchema("CRAFTING_MATS")
		:AddNumberField("spellId")
		:AddStringField("itemString")
		:AddNumberField("quantity")
		:AddIndex("spellId")
		:AddIndex("itemString")
		:Commit()
	private.matDB:BulkInsertStart()
	private.spellDB = Database.NewSchema("CRAFTING_SPELLS")
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
	local playersTemp = TempTable.Acquire()
	for spellId, craftInfo in pairs(TSM.db.factionrealm.internalData.crafts) do
		wipe(playersTemp)
		for player in pairs(craftInfo.players) do
			tinsert(playersTemp, player)
		end
		sort(playersTemp)
		local playersStr = table.concat(playersTemp, PLAYER_SEP)
		local itemName = ItemInfo.GetName(craftInfo.itemString) or ""
		private.spellDB:BulkInsertNewRow(spellId, craftInfo.itemString, itemName, craftInfo.name or "", craftInfo.profession, craftInfo.numResult, playersStr, craftInfo.hasCD and true or false)

		for matItemString, matQuantity in pairs(craftInfo.mats) do
			private.matDB:BulkInsertNewRow(spellId, matItemString, matQuantity)
			professionItems[craftInfo.profession] = professionItems[craftInfo.profession] or TempTable.Acquire()
			matSpellCount[spellId] = (matSpellCount[spellId] or 0) + 1
			if matQuantity > 0 then
				matFirstItemString[spellId] = matItemString
				matFirstQuantity[spellId] = matQuantity
			end
			if strmatch(matItemString, "^o:") then
				local _, _, matList = strsplit(":", matItemString)
				for matItemId in String.SplitIterator(matList, ",") do
					local optionalMatItemString = "i:"..matItemId
					professionItems[craftInfo.profession][optionalMatItemString] = true
				end
			else
				professionItems[craftInfo.profession][matItemString] = true
			end
		end
	end
	TempTable.Release(playersTemp)
	private.spellDB:BulkInsertEnd()
	private.matDB:BulkInsertEnd()

	private.matDBMatsInTableQuery = private.matDB:NewQuery()
		:Select("itemString", "quantity")
		:Equal("spellId", Database.BoundQueryParam())
		:GreaterThan("quantity", 0)
	private.matDBMatNamesQuery = private.matDB:NewQuery()
		:Select("name")
		:InnerJoin(ItemInfo.GetDBForJoin(), "itemString")
		:Equal("spellId", Database.BoundQueryParam())
		:GreaterThan("quantity", 0)

	private.matItemDB = Database.NewSchema("CRAFTING_MAT_ITEMS")
		:AddUniqueStringField("itemString")
		:AddStringField("professions")
		:AddStringField("customValue")
		:Commit()
	private.matItemDB:BulkInsertStart()
	local professionsTemp = TempTable.Acquire()
	for itemString, info in pairs(TSM.db.factionrealm.internalData.mats) do
		wipe(professionsTemp)
		for profession, items in pairs(professionItems) do
			if items[itemString] then
				tinsert(professionsTemp, profession)
			end
		end
		sort(professionsTemp)
		local professionsStr = table.concat(professionsTemp)
		private.matItemDB:BulkInsertNewRow(itemString, professionsStr, info.customValue or "")
	end
	TempTable.Release(professionsTemp)
	private.matItemDB:BulkInsertEnd()

	for _, tbl in pairs(professionItems) do
		TempTable.Release(tbl)
	end
	TempTable.Release(professionItems)

	private.matDBSpellIdQuery = private.matDB:NewQuery()
		:Equal("spellId", Database.BoundQueryParam())

	-- register 1:1 crafting conversions
	local addedConversion = false
	local query = private.spellDB:NewQuery()
		:Select("spellId", "itemString", "numResult")
		:Equal("hasCD", false)
	for _, spellId, itemString, numResult in query:Iterator() do
		if not ProfessionInfo.IsMassMill(spellId) and matSpellCount[spellId] == 1 then
			Conversions.AddCraft(itemString, matFirstItemString[spellId], numResult / matFirstQuantity[spellId])
			addedConversion = true
		end
	end
	query:Release()
	TempTable.Release(matSpellCount)
	TempTable.Release(matFirstItemString)
	TempTable.Release(matFirstQuantity)
	if addedConversion then
		CustomPrice.OnSourceChange("Destroy")
	end

	local isValid, err = CustomPrice.Validate(TSM.db.global.craftingOptions.defaultCraftPriceMethod, BAD_CRAFTING_PRICE_SOURCES)
	if not isValid then
		Log.PrintfUser(L["Your default craft value method was invalid so it has been returned to the default. Details: %s"], err)
		TSM.db.global.craftingOptions.defaultCraftPriceMethod = TSM.db:GetDefault("global", "craftingOptions", "defaultCraftPriceMethod")
	end

	private.ignoredCooldownDB = Database.NewSchema("IGNORED_COOLDOWNS")
		:AddStringField("characterKey")
		:AddNumberField("spellId")
		:Commit()
	private.ignoredCooldownDB:BulkInsertStart()
	for entry in pairs(TSM.db.factionrealm.userData.craftingCooldownIgnore) do
		local characterKey, spellId = strsplit(IGNORED_COOLDOWN_SEP, entry)
		spellId = tonumber(spellId)
		if Crafting.HasSpellId(spellId) then
			private.ignoredCooldownDB:BulkInsertNewRow(characterKey, spellId)
		else
			TSM.db.factionrealm.userData.craftingCooldownIgnore[entry] = nil
		end
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
		:VirtualField("bagQuantity", "number", Inventory.GetBagQuantity, "itemString")
		:VirtualField("auctionQuantity", "number", Inventory.GetAuctionQuantity, "itemString")
		:VirtualField("craftingCost", "number", private.CraftingCostVirtualField, "spellId")
		:VirtualField("itemValue", "number", private.ItemValueVirtualField, "itemString")
		:VirtualField("profit", "number", private.ProfitVirtualField, "spellId")
		:VirtualField("profitPct", "number", private.ProfitPctVirtualField, "spellId")
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
		:InnerJoin(ItemInfo.GetDBForJoin(), "itemString")
		:VirtualField("matCost", "number", private.MatCostVirtualField, "itemString")
		:VirtualField("totalQuantity", "number", private.GetTotalQuantity, "itemString")
end

function Crafting.SpellIterator()
	return private.spellDB:NewQuery()
		:Select("spellId")
		:IteratorAndRelease()
end

function Crafting.GetSpellIdsByItem(itemString)
	local query = private.spellDB:NewQuery()
		:Equal("itemString", itemString)
		:Select("spellId", "hasCD")

	return query:IteratorAndRelease()
end

function Crafting.GetMostProfitableSpellIdByItem(itemString, playerFilter, noCD)
	local maxProfit, bestSpellId = nil, nil
	local maxProfitCD, bestSpellIdCD = nil, nil
	for _, spellId, hasCD in Crafting.GetSpellIdsByItem(itemString) do
		if not playerFilter or playerFilter == "" or Vararg.In(playerFilter, Crafting.GetPlayers(spellId)) then
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
	if noCD then
		maxProfitCD = nil
		bestSpellIdCD = nil
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
		:GreaterThan("quantity", 0)
		:IteratorAndRelease()
end

function Crafting.GetOptionalMatIterator(spellId)
	return private.matDB:NewQuery()
		:Select("itemString", "slotId", "text")
		:VirtualField("slotId", "number", private.OptionalMatSlotIdVirtualField, "itemString")
		:VirtualField("text", "string", private.OptionalMatTextVirtualField, "itemString")
		:Equal("spellId", spellId)
		:LessThan("quantity", 0)
		:OrderBy("slotId", true)
		:IteratorAndRelease()
end

function Crafting.GetMatsAsTable(spellId, tbl)
	private.matDBMatsInTableQuery
		:BindParams(spellId)
		:AsTable(tbl)
end

function Crafting.RemovePlayers(spellId, playersToRemove)
	local shouldRemove = TempTable.Acquire()
	for _, player in ipairs(playersToRemove) do
		shouldRemove[player] = true
	end
	local players = TempTable.Acquire(Crafting.GetPlayers(spellId))
	for i = #players, 1, -1 do
		local player = players[i]
		if shouldRemove[player] then
			TSM.db.factionrealm.internalData.crafts[spellId].players[player] = nil
			tremove(players, i)
		end
	end
	TempTable.Release(shouldRemove)
	local query = private.spellDB:NewQuery()
		:Equal("spellId", spellId)
	local row = query:GetFirstResult()

	local playersStr = strjoin(PLAYER_SEP, TempTable.UnpackAndRelease(players))
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

	local removedMats = TempTable.Acquire()
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
	TempTable.Release(removedMats)

	return false
end

function Crafting.RemovePlayerSpells(inactiveSpellIds)
	local playerName = UnitName("player")
	local query = private.spellDB:NewQuery()
		:InTable("spellId", inactiveSpellIds)
		:Custom(private.QueryPlayerFilter, playerName)
	local removedSpellIds = TempTable.Acquire()
	local toRemove = TempTable.Acquire()
	private.spellDB:SetQueryUpdatesPaused(true)
	if query:Count() > 0 then
		Log.Info("Removing %d inactive spellds", query:Count())
	end
	for _, row in query:Iterator() do
		local players = row:GetField("players")
		if row:GetField("players") == playerName then
			-- the current player was the only player, so we'll delete the entire row and all its mats
			local spellId = row:GetField("spellId")
			removedSpellIds[spellId] = true
			TSM.db.factionrealm.internalData.crafts[spellId] = nil
			tinsert(toRemove, row)
		else
			-- remove this player form the row
			local playersTemp = TempTable.Acquire(strsplit(PLAYER_SEP, players))
			assert(Table.RemoveByValue(playersTemp, playerName) == 1)
			row:SetField("players", strjoin(PLAYER_SEP, TempTable.UnpackAndRelease(playersTemp)))
				:Update()
		end
	end
	for _, row in ipairs(toRemove) do
		private.spellDB:DeleteRow(row)
	end
	TempTable.Release(toRemove)
	query:Release()
	private.spellDB:SetQueryUpdatesPaused(false)

	local removedMats = TempTable.Acquire()
	private.matDB:SetQueryUpdatesPaused(true)
	local matQuery = private.matDB:NewQuery()
		:InTable("spellId", removedSpellIds)
	for _, matRow in matQuery:Iterator() do
		removedMats[matRow:GetField("itemString")] = true
		private.matDB:DeleteRow(matRow)
	end
	TempTable.Release(removedSpellIds)
	matQuery:Release()
	private.matDB:SetQueryUpdatesPaused(false)
	private.ProcessRemovedMats(removedMats)
	TempTable.Release(removedMats)
end

function Crafting.SetSpellDBQueryUpdatesPaused(paused)
	private.spellDB:SetQueryUpdatesPaused(paused)
end

function Crafting.CreateOrUpdate(spellId, itemString, profession, name, numResult, player, hasCD)
	local row = private.spellDB:GetUniqueRow("spellId", spellId)
	if row then
		local playersStr = row:GetField("players")
		local foundPlayer = String.SeparatedContains(playersStr, PLAYER_SEP, player)
		if not foundPlayer then
			assert(playersStr ~= "")
			playersStr = playersStr .. PLAYER_SEP .. player
		end
		row:SetField("itemString", itemString)
			:SetField("profession", profession)
			:SetField("itemName", ItemInfo.GetName(itemString) or "")
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
			:SetField("itemName", ItemInfo.GetName(itemString) or "")
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
	if Table.Equal(TSM.db.factionrealm.internalData.crafts[spellId].mats, matQuantities) then
		-- nothing changed
		return
	end

	wipe(TSM.db.factionrealm.internalData.crafts[spellId].mats)
	for itemString, quantity in pairs(matQuantities) do
		TSM.db.factionrealm.internalData.crafts[spellId].mats[itemString] = quantity
	end

	private.matDB:SetQueryUpdatesPaused(true)
	local removedMats = TempTable.Acquire()
	local usedMats = TempTable.Acquire()
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
			if quantity > 0 then
				private.MatItemDBUpdateOrInsert(itemString, profession)
			else
				local _, _, matList = strsplit(":", itemString)
				for matItemId in String.SplitIterator(matList, ",") do
					private.MatItemDBUpdateOrInsert("i:"..matItemId, profession)
				end
			end
		end
	end
	TempTable.Release(usedMats)
	private.matDB:SetQueryUpdatesPaused(false)

	private.ProcessRemovedMats(removedMats)
	TempTable.Release(removedMats)
end

function Crafting.SetMatCustomValue(itemString, value)
	TSM.db.factionrealm.internalData.mats[itemString].customValue = value
	private.matItemDB:GetUniqueRow("itemString", itemString)
		:SetField("customValue", value or "")
		:Update()
end

function Crafting.CanCraftItem(itemString)
	local count = private.spellDB:NewQuery()
		:Equal("itemString", itemString)
		:CountAndRelease()
	return count > 0
end

function Crafting.RestockHelp(link)
	local itemString = ItemString.Get(link)
	if not itemString then
		Log.PrintUser(L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"])
		return
	end

	local msg = private.GetRestockHelpMessage(itemString)
	Log.PrintfUser(L["Restock help for %s: %s"], link, msg)
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
	return private.matDBMatNamesQuery:BindParams(spellId)
		:JoinedString("name", "")
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
	return TSM.Crafting.Cost.GetCraftingCostBySpellId(spellId) or Math.GetNan()
end

function private.ItemValueVirtualField(itemString)
	return TSM.Crafting.Cost.GetCraftedItemValue(itemString) or Math.GetNan()
end

function private.ProfitVirtualField(spellId)
	return TSM.Crafting.Cost.GetProfitBySpellId(spellId) or Math.GetNan()
end

function private.ProfitPctVirtualField(spellId)
	local craftingCost, _, profit = TSM.Crafting.Cost.GetCostsBySpellId(spellId)
	return (craftingCost and profit) and floor(profit * 100 / craftingCost) or Math.GetNan()
end

function private.SaleRateVirtualField(itemString)
	local saleRate = TSM.AuctionDB.GetRegionItemData(itemString, "regionSalePercent")
	return saleRate and (saleRate / 100) or Math.GetNan()
end

function private.MatCostVirtualField(itemString)
	return TSM.Crafting.Cost.GetMatCost(itemString) or Math.GetNan()
end

function private.OptionalMatSlotIdVirtualField(matStr)
	local _, slotId = strsplit(":", matStr)
	return tonumber(slotId)
end

function private.OptionalMatTextVirtualField(matStr)
	local _, _, matList = strsplit(":", matStr)
	return TSM.Crafting.ProfessionUtil.GetOptionalMatText(matList) or OPTIONAL_REAGENT_POSTFIX
end

function private.GetRestockHelpMessage(itemString)
	-- check if the item is in a group
	local groupPath = TSM.Groups.GetPathByItem(itemString)
	if not groupPath then
		return L["This item is not in a TSM group."]
	end

	-- check that there's a crafting operation applied
	if not TSM.Operations.Crafting.HasOperation(itemString) then
		return format(L["There is no Crafting operation applied to this item's TSM group (%s)."], TSM.Groups.Path.Format(groupPath))
	end

	-- check if it's an invalid operation
	local isValid, err = TSM.Operations.Crafting.IsValid(itemString)
	if not isValid then
		return err
	end

	-- check that this item is craftable
	if not TSM.Crafting.CanCraftItem(itemString) then
		return L["You don't know how to craft this item."]
	end

	-- check the restock quantity
	local neededQuantity = TSM.Operations.Crafting.GetRestockQuantity(itemString, private.GetTotalQuantity(itemString))
	if neededQuantity == 0 then
		return L["You either already have at least your max restock quantity of this item or the number which would be queued is less than the min restock quantity."]
	end

	-- check if we would actually queue any
	local cost, spellId = TSM.Crafting.Cost.GetLowestCostByItem(itemString)
	local numResult = spellId and TSM.Crafting.GetNumResult(spellId)
	if neededQuantity < numResult then
		return format(L["A single craft makes %d and you only need to restock %d."], numResult, neededQuantity)
	end

	-- check the prices on the item and the min profit
	local hasMinProfit, minProfit = TSM.Operations.Crafting.GetMinProfit(itemString)
	if hasMinProfit then
		local craftedValue = TSM.Crafting.Cost.GetCraftedItemValue(itemString)
		local profit = cost and craftedValue and (craftedValue - cost) or nil

		-- check that there's a crafted value
		if not craftedValue then
			return L["The 'Craft Value Method' did not return a value for this item."]
		end

		-- check that there's a crafted cost
		if not cost then
			return L["This item does not have a crafting cost. Check that all of its mats have mat prices."]
		end

		-- check that there's a profit
		assert(profit)

		if not minProfit then
			return L["The min profit did not evalulate to a valid value for this item."]
		end

		if profit < minProfit then
			return format(L["The profit of this item (%s) is below the min profit (%s)."], Money.ToString(profit), Money.ToString(minProfit))
		end
	end

	return L["This item will be added to the queue when you restock its group. If this isn't happening, please visit http://support.tradeskillmaster.com for further assistance."]
end

function private.QueryPlayerFilter(row, player)
	return String.SeparatedContains(row:GetField("players"), ",", player)
end

function private.GetTotalQuantity(itemString)
	return CustomPrice.GetItemPrice(itemString, "NumInventory") or 0
end

function private.MatItemDBUpdateOrInsert(itemString, profession)
	local matItemRow = private.matItemDB:GetUniqueRow("itemString", itemString)
	if matItemRow then
		-- update the professions if necessary
		local professions = TempTable.Acquire(strsplit(PROFESSION_SEP, matItemRow:GetField("professions")))
		if not Table.KeyByValue(professions, profession) then
			tinsert(professions, profession)
			sort(professions)
			matItemRow:SetField("professions", table.concat(professions, PROFESSION_SEP))
				:Update()
		end
		TempTable.Release(professions)
	else
		private.matItemDB:NewRow()
			:SetField("itemString", itemString)
			:SetField("professions", profession)
			:SetField("customValue", TSM.db.factionrealm.internalData.mats[itemString].customValue or "")
			:Create()
	end
end
