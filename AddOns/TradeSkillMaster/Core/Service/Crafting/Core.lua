-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM:NewPackage("Crafting")
local L = TSM.Include("Locale").GetTable()
local ProfessionInfo = TSM.Include("Data.ProfessionInfo")
local CraftString = TSM.Include("Util.CraftString")
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
		:AddStringField("craftString")
		:AddStringField("itemString")
		:AddNumberField("quantity")
		:AddIndex("craftString")
		:AddIndex("itemString")
		:Commit()
	private.matDB:BulkInsertStart()
	private.spellDB = Database.NewSchema("CRAFTING_SPELLS")
		:AddUniqueStringField("craftString")
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
	for craftString, craftInfo in pairs(TSM.db.factionrealm.internalData.crafts) do
		wipe(playersTemp)
		for player in pairs(craftInfo.players) do
			tinsert(playersTemp, player)
		end
		sort(playersTemp)
		local playersStr = table.concat(playersTemp, PLAYER_SEP)
		local itemName = ItemInfo.GetName(craftInfo.itemString) or ""
		private.spellDB:BulkInsertNewRow(craftString, craftInfo.itemString, itemName, craftInfo.name or "", craftInfo.profession, craftInfo.numResult, playersStr, craftInfo.hasCD and true or false)

		for matItemString, matQuantity in pairs(craftInfo.mats) do
			private.matDB:BulkInsertNewRow(craftString, matItemString, matQuantity)
			professionItems[craftInfo.profession] = professionItems[craftInfo.profession] or TempTable.Acquire()
			matSpellCount[craftString] = (matSpellCount[craftString] or 0) + 1
			if matQuantity > 0 then
				matFirstItemString[craftString] = matItemString
				matFirstQuantity[craftString] = matQuantity
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
		:Equal("craftString", Database.BoundQueryParam())
	private.matDBMatNamesQuery = private.matDB:NewQuery()
		:Select("name")
		:InnerJoin(ItemInfo.GetDBForJoin(), "itemString")
		:Equal("craftString", Database.BoundQueryParam())
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
		:Equal("craftString", Database.BoundQueryParam())

	-- register 1:1 crafting conversions
	local addedConversion = false
	local query = private.spellDB:NewQuery()
		:Select("craftString", "itemString", "numResult")
		:Equal("hasCD", false)
	for _, craftString, itemString, numResult in query:Iterator() do
		local spellId = CraftString.GetSpellId(craftString)
		if not ProfessionInfo.IsMassMill(spellId) and matSpellCount[craftString] == 1 then
			Conversions.AddCraft(itemString, matFirstItemString[craftString], numResult / matFirstQuantity[craftString])
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
		:AddStringField("craftString")
		:Commit()
	private.ignoredCooldownDB:BulkInsertStart()
	for entry in pairs(TSM.db.factionrealm.userData.craftingCooldownIgnore) do
		local characterKey, craftString = strsplit(IGNORED_COOLDOWN_SEP, entry)
		if Crafting.HasCraftString(craftString) then
			private.ignoredCooldownDB:BulkInsertNewRow(characterKey, craftString)
		else
			TSM.db.factionrealm.userData.craftingCooldownIgnore[entry] = nil
		end
	end
	private.ignoredCooldownDB:BulkInsertEnd()
end

function Crafting.HasCraftString(craftString)
	return private.spellDB:HasUniqueRow("craftString", craftString)
end

function Crafting.CreateRawCraftsQuery()
	return private.spellDB:NewQuery()
end

function Crafting.CreateCraftsQuery()
	return private.spellDB:NewQuery()
		:AggregateJoinSummed(TSM.Crafting.Queue.GetDBForJoin(), "craftString", "num")
		:VirtualField("bagQuantity", "number", Inventory.GetBagQuantity, "itemString")
		:VirtualField("auctionQuantity", "number", Inventory.GetAuctionQuantity, "itemString")
		:VirtualField("craftingCost", "number", TSM.Crafting.Cost.GetCraftingCostByCraftString, "craftString", Math.GetNan())
		:VirtualField("itemValue", "number", TSM.Crafting.Cost.GetCraftedItemValue, "itemString", Math.GetNan())
		:VirtualField("profit", "number", TSM.Crafting.Cost.GetProfitByCraftString, "craftString", Math.GetNan())
		:VirtualField("profitPct", "number", private.ProfitPctVirtualField, "craftString")
		:VirtualField("saleRate", "number", private.SaleRateVirtualField, "itemString")
end

function Crafting.CreateQueueQuery()
	return TSM.Crafting.Queue.CreateQuery()
		:InnerJoin(private.spellDB, "craftString")
		:VirtualField("bagQuantity", "number", Inventory.GetBagQuantity, "itemString")
		:VirtualField("auctionQuantity", "number", Inventory.GetAuctionQuantity, "itemString")
		:VirtualField("craftingCost", "number", TSM.Crafting.Cost.GetCraftingCostByCraftString, "craftString", Math.GetNan())
		:VirtualField("itemValue", "number", TSM.Crafting.Cost.GetCraftedItemValue, "itemString", Math.GetNan())
		:VirtualField("profit", "number", TSM.Crafting.Cost.GetProfitByCraftString, "craftString", Math.GetNan())
		:VirtualField("profitPct", "number", private.ProfitPctVirtualField, "craftString")
		:VirtualField("saleRate", "number", private.SaleRateVirtualField, "itemString")
end

function Crafting.CreateQueuedCraftsQuery()
	return TSM.Crafting.Queue.CreateQuery()
		:InnerJoin(private.spellDB, "craftString")
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
		:VirtualField("matCost", "number", TSM.Crafting.Cost.GetMatCost, "itemString", Math.GetNan())
		:VirtualField("totalQuantity", "number", private.GetTotalQuantity, "itemString")
end

function Crafting.CraftStringIterator()
	return private.spellDB:NewQuery()
		:Select("craftString")
		:IteratorAndRelease()
end

function Crafting.GetCraftStringByItem(itemString)
	local query = private.spellDB:NewQuery()
		:Equal("itemString", itemString)
		:Select("craftString", "hasCD", "profession")
	return query:IteratorAndRelease()
end

function Crafting.GetMostProfitableCraftStringByItem(itemString, playerFilter, noCD)
	local bestCraftString, bestCraftingCost, bestProfit, bestHasCD = nil, nil, nil, nil
	for _, craftString, hasCD in Crafting.GetCraftStringByItem(itemString) do
		if (not playerFilter or playerFilter == "" or Vararg.In(playerFilter, Crafting.GetPlayers(craftString))) and (not noCD or not hasCD) then
			local craftingCost, _, profit = TSM.Crafting.Cost.GetCostsByCraftString(craftString)
			if not bestCraftString or private.IsCraftStringHigherProfit(craftingCost, profit, hasCD, bestCraftingCost, bestProfit, bestHasCD) then
				bestCraftString = craftString
				bestCraftingCost = craftingCost
				bestProfit = profit
				bestHasCD = hasCD
			end
		end
	end
	return bestCraftString, bestProfit, bestCraftingCost
end

function Crafting.GetItemString(craftString)
	return private.spellDB:GetUniqueRowField("craftString", craftString, "itemString")
end

function Crafting.GetProfession(craftString)
	return private.spellDB:GetUniqueRowField("craftString", craftString, "profession")
end

function Crafting.GetNumResult(craftString)
	return private.spellDB:GetUniqueRowField("craftString", craftString, "numResult")
end

function Crafting.GetPlayers(craftString)
	local players = private.spellDB:GetUniqueRowField("craftString", craftString, "players")
	if not players then
		return
	end
	return strsplit(PLAYER_SEP, players)
end

function Crafting.GetName(craftString)
	return private.spellDB:GetUniqueRowField("craftString", craftString, "name")
end

function Crafting.MatIterator(craftString)
	return private.matDB:NewQuery()
		:Select("itemString", "quantity")
		:Equal("craftString", craftString)
		:GreaterThan("quantity", 0)
		:IteratorAndRelease()
end

function Crafting.OptionalMatIterator(craftString)
	return private.matDB:NewQuery()
		:Select("itemString", "slotId", "text")
		:VirtualField("slotId", "number", private.OptionalMatSlotIdVirtualField, "itemString")
		:VirtualField("text", "string", private.OptionalMatTextVirtualField, "itemString")
		:Equal("craftString", craftString)
		:LessThan("quantity", 0)
		:OrderBy("slotId", true)
		:IteratorAndRelease()
end

function Crafting.HasOptionalMats(craftString)
	local numOptionalMats = private.matDB:NewQuery()
		:Equal("craftString", craftString)
		:LessThan("quantity", 0)
		:CountAndRelease()
	return numOptionalMats > 0
end

function Crafting.GetMatsAsTable(craftString, tbl)
	private.matDBMatsInTableQuery
		:BindParams(craftString)
		:AsTable(tbl)
end

function Crafting.RemovePlayers(craftString, playersToRemove)
	local shouldRemove = TempTable.Acquire()
	if type(playersToRemove) == "table" then
		for _, player in ipairs(playersToRemove) do
			shouldRemove[player] = true
		end
	else
		assert(type(playersToRemove) == "string")
		shouldRemove[playersToRemove] = true
	end
	local players = TempTable.Acquire(Crafting.GetPlayers(craftString))
	for i = #players, 1, -1 do
		local player = players[i]
		if shouldRemove[player] then
			TSM.db.factionrealm.internalData.crafts[craftString].players[player] = nil
			tremove(players, i)
		end
	end
	TempTable.Release(shouldRemove)
	local query = private.spellDB:NewQuery()
		:Equal("craftString", craftString)
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
	TSM.db.factionrealm.internalData.crafts[craftString] = nil

	local removedMats = TempTable.Acquire()
	private.matDB:SetQueryUpdatesPaused(true)
	query = private.matDB:NewQuery()
		:Equal("craftString", craftString)
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
		:InTable("craftString", inactiveSpellIds)
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
			local craftString = row:GetField("craftString")
			removedSpellIds[craftString] = true
			TSM.db.factionrealm.internalData.crafts[craftString] = nil
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
		:InTable("craftString", removedSpellIds)
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

function Crafting.CreateOrUpdate(craftString, itemString, profession, name, numResult, player, hasCD)
	local row = private.spellDB:GetUniqueRow("craftString", craftString)
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
		local craftInfo = TSM.db.factionrealm.internalData.crafts[craftString]
		craftInfo.itemString = itemString
		craftInfo.profession = profession
		craftInfo.name = name
		craftInfo.numResult = numResult
		craftInfo.players[player] = true
		craftInfo.hasCD = hasCD or nil
		local spellId = CraftString.GetSpellId(craftString)
		local rank = CraftString.GetRank(craftString)
		local level = CraftString.GetLevel(craftString)
		local deleteRow = private.spellDB:GetUniqueRow("craftString", "c:"..spellId)
		if (rank or level) and deleteRow then
			private.spellDB:DeleteRowByUUID(deleteRow:GetUUID())
			TSM.db.factionrealm.internalData.crafts["c:"..spellId] = nil
		end
		if deleteRow then
			deleteRow:Release()
		end
	else
		TSM.db.factionrealm.internalData.crafts[craftString] = {
			mats = {},
			players = { [player] = true },
			itemString = itemString,
			name = name,
			profession = profession,
			numResult = numResult,
			hasCD = hasCD,
		}
		private.spellDB:NewRow()
			:SetField("craftString", craftString)
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

function Crafting.AddPlayer(craftString, player)
	if TSM.db.factionrealm.internalData.crafts[craftString].players[player] then
		return
	end
	local row = private.spellDB:GetUniqueRow("craftString", craftString)
	local playersStr = row:GetField("players")
	assert(playersStr ~= "")
	playersStr = playersStr .. PLAYER_SEP .. player
	row:SetField("players", playersStr)
	row:Update()
	row:Release()
	TSM.db.factionrealm.internalData.crafts[craftString].players[player] = true
end

function Crafting.SetMats(craftString, matQuantities)
	if Table.Equal(TSM.db.factionrealm.internalData.crafts[craftString].mats, matQuantities) then
		-- nothing changed
		return
	end

	wipe(TSM.db.factionrealm.internalData.crafts[craftString].mats)
	for itemString, quantity in pairs(matQuantities) do
		TSM.db.factionrealm.internalData.crafts[craftString].mats[itemString] = quantity
	end

	private.matDB:SetQueryUpdatesPaused(true)
	local removedMats = TempTable.Acquire()
	local usedMats = TempTable.Acquire()
	private.matDBSpellIdQuery:BindParams(craftString)
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
	local profession = Crafting.GetProfession(craftString)
	for itemString, quantity in pairs(matQuantities) do
		if not usedMats[itemString] then
			private.matDB:NewRow()
				:SetField("craftString", craftString)
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

function Crafting.IgnoreCooldown(craftString)
	assert(not TSM.db.factionrealm.userData.craftingCooldownIgnore[CHARACTER_KEY..IGNORED_COOLDOWN_SEP..craftString])
	TSM.db.factionrealm.userData.craftingCooldownIgnore[CHARACTER_KEY..IGNORED_COOLDOWN_SEP..craftString] = true
	private.ignoredCooldownDB:NewRow()
		:SetField("characterKey", CHARACTER_KEY)
		:SetField("craftString", craftString)
		:Create()
end

function Crafting.IsCooldownIgnored(craftString)
	return TSM.db.factionrealm.userData.craftingCooldownIgnore[CHARACTER_KEY..IGNORED_COOLDOWN_SEP..craftString]
end

function Crafting.CreateIgnoredCooldownQuery()
	return private.ignoredCooldownDB:NewQuery()
end

function Crafting.RemoveIgnoredCooldown(characterKey, craftString)
	assert(TSM.db.factionrealm.userData.craftingCooldownIgnore[characterKey..IGNORED_COOLDOWN_SEP..craftString])
	TSM.db.factionrealm.userData.craftingCooldownIgnore[characterKey..IGNORED_COOLDOWN_SEP..craftString] = nil
	local row = private.ignoredCooldownDB:NewQuery()
		:Equal("characterKey", characterKey)
		:Equal("craftString", craftString)
		:GetFirstResultAndRelease()
	assert(row)
	private.ignoredCooldownDB:DeleteRow(row)
	row:Release()
end

function Crafting.GetMatNames(craftString)
	return private.matDBMatNamesQuery:BindParams(craftString)
		:JoinedString("name", "")
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ProcessRemovedMats(removedMats)
	private.matItemDB:SetQueryUpdatesPaused(true)
	for itemString in pairs(removedMats) do
		if strmatch(itemString, "^o:") then
			local _, _, matList = strsplit(":", itemString)
			for matItemId in String.SplitIterator(matList, ",") do
				local numSpells = private.matDB:NewQuery()
					:Or()
						:Matches("itemString", "[:,]"..matItemId.."$")
						:Matches("itemString", "[:,]"..matItemId..",")
					:End()
					:CountAndRelease()
				if numSpells == 0 then
					local matItemRow = private.matItemDB:GetUniqueRow("itemString", "i:"..matItemId)
					private.matItemDB:DeleteRow(matItemRow)
					matItemRow:Release()
				end
			end
		else
			local numSpells = private.matDB:NewQuery()
				:Equal("itemString", itemString)
				:CountAndRelease()
			if numSpells == 0 then
				local matItemRow = private.matItemDB:GetUniqueRow("itemString", itemString)
				private.matItemDB:DeleteRow(matItemRow)
				matItemRow:Release()
			end
		end
	end
	private.matItemDB:SetQueryUpdatesPaused(false)
end

function private.ProfitPctVirtualField(craftString)
	local craftingCost, _, profit = TSM.Crafting.Cost.GetCostsByCraftString(craftString)
	return (craftingCost and profit) and floor(profit * 100 / craftingCost) or Math.GetNan()
end

function private.SaleRateVirtualField(itemString)
	local saleRate = TSM.AuctionDB.GetRegionItemData(itemString, "regionSalePercent")
	return saleRate and (saleRate / 100) or Math.GetNan()
end

function private.OptionalMatSlotIdVirtualField(matStr)
	local _, slotId = strsplit(":", matStr)
	return tonumber(slotId)
end

function private.OptionalMatTextVirtualField(matStr)
	local _, _, matList = strsplit(":", matStr)
	return TSM.Crafting.ProfessionUtil.GetOptionalMatText(matList)
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
	local cost, craftString = TSM.Crafting.Cost.GetLowestCostByItem(itemString)
	local numResult = craftString and TSM.Crafting.GetNumResult(craftString)
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

function private.IsCraftStringHigherProfit(craftingCost, profit, hasCD, bestCraftingCost, bestProfit, bestHasCD)
	-- No CD is always better than a CD
	if not hasCD and bestHasCD then
		return true
	elseif hasCD and not bestHasCD then
		return false
	end
	-- Order by profit
	if not profit and bestProfit then
		return false
	elseif profit and not bestProfit then
		return true
	elseif profit and bestProfit then
		return profit > bestProfit
	end
	-- Order by crafting cost
	if not craftingCost and bestCraftingCost then
		return false
	elseif craftingCost and not bestCraftingCost then
		return true
	elseif craftingCost and bestCraftingCost then
		return craftingCost < bestCraftingCost
	end
	-- Stick with what we have
	return false
end
