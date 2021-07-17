-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Gathering = TSM.Crafting:NewPackage("Gathering")
local DisenchantInfo = TSM.Include("Data.DisenchantInfo")
local Database = TSM.Include("Util.Database")
local Table = TSM.Include("Util.Table")
local Delay = TSM.Include("Util.Delay")
local CraftString = TSM.Include("Util.CraftString")
local RecipeString = TSM.Include("Util.RecipeString")
local String = TSM.Include("Util.String")
local TempTable = TSM.Include("Util.TempTable")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Conversions = TSM.Include("Service.Conversions")
local BagTracking = TSM.Include("Service.BagTracking")
local Inventory = TSM.Include("Service.Inventory")
local PlayerInfo = TSM.Include("Service.PlayerInfo")
local private = {
	db = nil,
	queuedCraftsUpdateQuery = nil, -- luacheck: ignore 1004 - just stored for GC reasons
	crafterList = {},
	professionList = {},
	contextChangedCallback = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Gathering.OnInitialize()
	if TSM.IsWowClassic() then
		Table.RemoveByValue(TSM.db.profile.gatheringOptions.sources, "guildBank")
		Table.RemoveByValue(TSM.db.profile.gatheringOptions.sources, "altGuildBank")
	end
end

function Gathering.OnEnable()
	private.db = Database.NewSchema("GATHERING_MATS")
		:AddUniqueStringField("itemString")
		:AddNumberField("numNeed")
		:AddNumberField("numHave")
		:AddStringField("sourcesStr")
		:Commit()
	private.queuedCraftsUpdateQuery = TSM.Crafting.CreateQueuedCraftsQuery()
		:SetUpdateCallback(private.OnQueuedCraftsUpdated)
	private.OnQueuedCraftsUpdated()
	BagTracking.RegisterCallback(function()
		Delay.AfterTime("GATHERING_BAG_UPDATE", 1, private.UpdateDB)
	end)
end

function Gathering.SetContextChangedCallback(callback)
	private.contextChangedCallback = callback
end

function Gathering.CreateQuery()
	return private.db:NewQuery()
end

function Gathering.SetCrafter(crafter)
	if crafter == TSM.db.factionrealm.gatheringContext.crafter then
		return
	end
	TSM.db.factionrealm.gatheringContext.crafter = crafter
	wipe(TSM.db.factionrealm.gatheringContext.professions)
	private.UpdateProfessionList()
	private.UpdateDB()
end

function Gathering.SetProfessions(professions)
	local numProfessions = Table.Count(TSM.db.factionrealm.gatheringContext.professions)
	local didChange = false
	if numProfessions ~= #professions then
		didChange = true
	else
		for _, profession in ipairs(professions) do
			if not TSM.db.factionrealm.gatheringContext.professions[profession] then
				didChange = true
			end
		end
	end
	if not didChange then
		return
	end
	wipe(TSM.db.factionrealm.gatheringContext.professions)
	for _, profession in ipairs(professions) do
		assert(private.professionList[profession])
		TSM.db.factionrealm.gatheringContext.professions[profession] = true
	end
	private.UpdateDB()
end

function Gathering.GetCrafterList()
	return private.crafterList
end

function Gathering.GetCrafter()
	return TSM.db.factionrealm.gatheringContext.crafter ~= "" and TSM.db.factionrealm.gatheringContext.crafter or nil
end

function Gathering.GetProfessionList()
	return private.professionList
end

function Gathering.GetProfessions()
	return TSM.db.factionrealm.gatheringContext.professions
end

function Gathering.SourcesStrToTable(sourcesStr, info, alts)
	for source, num, characters in gmatch(sourcesStr, "([a-zA-Z]+)/([0-9]+)/([^,]*)") do
		info[source] = tonumber(num)
		if source == "alt" or source == "altGuildBank" then
			for character in gmatch(characters, "([^`]+)") do
				alts[character] = true
			end
		end
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.UpdateCrafterList()
	local query = TSM.Crafting.CreateQueuedCraftsQuery()
		:Select("players")
		:Distinct("players")
	wipe(private.crafterList)
	for _, players in query:Iterator() do
		for character in gmatch(players, "[^,]+") do
			if not private.crafterList[character] then
				private.crafterList[character] = true
				tinsert(private.crafterList, character)
			end
		end
	end
	query:Release()

	if TSM.db.factionrealm.gatheringContext.crafter ~= "" and not private.crafterList[TSM.db.factionrealm.gatheringContext.crafter] then
		-- the crafter which was selected no longer exists, so clear the selection
		TSM.db.factionrealm.gatheringContext.crafter = ""
	elseif #private.crafterList == 1 then
		-- there is only one crafter in the list, so select it
		TSM.db.factionrealm.gatheringContext.crafter = private.crafterList[1]
	end
	if TSM.db.factionrealm.gatheringContext.crafter == "" then
		wipe(TSM.db.factionrealm.gatheringContext.professions)
	end
end

function private.UpdateProfessionList()
	-- update the professionList
	wipe(private.professionList)
	if TSM.db.factionrealm.gatheringContext.crafter ~= "" then
		-- populate the list of professions
		local query = TSM.Crafting.CreateQueuedCraftsQuery()
			:Select("profession")
			:Custom(private.QueryPlayerFilter, TSM.db.factionrealm.gatheringContext.crafter)
			:Distinct("profession")
		for _, profession in query:Iterator() do
			private.professionList[profession] = true
			tinsert(private.professionList, profession)
		end
		query:Release()
	end

	-- remove selected professions which are no longer in the list
	for profession in pairs(TSM.db.factionrealm.gatheringContext.professions) do
		if not private.professionList[profession] then
			TSM.db.factionrealm.gatheringContext.professions[profession] = nil
		end
	end

	-- select all professions by default
	if not next(TSM.db.factionrealm.gatheringContext.professions) then
		for _, profession in ipairs(private.professionList) do
			TSM.db.factionrealm.gatheringContext.professions[profession] = true
		end
	end
end

function private.OnQueuedCraftsUpdated()
	private.UpdateCrafterList()
	private.UpdateProfessionList()
	private.UpdateDB()
	private.contextChangedCallback()
end

function private.UpdateDB()
	-- delay the update if we're in combat
	if InCombatLockdown() then
		Delay.AfterTime("DELAYED_GATHERING_UPDATE", 1, private.UpdateDB)
		return
	end
	local crafter = TSM.db.factionrealm.gatheringContext.crafter
	if crafter == "" or not next(TSM.db.factionrealm.gatheringContext.professions) then
		private.db:Truncate()
		return
	end

	local matsNumNeed = TempTable.Acquire()
	local query = TSM.Crafting.CreateQueuedCraftsQuery()
		:Select("recipeString", "num")
		:Custom(private.QueryPlayerFilter, crafter)
		:Or()
	for profession in pairs(TSM.db.factionrealm.gatheringContext.professions) do
		query:Equal("profession", profession)
	end
	query:End()
	for _, recipeString, numQueued in query:Iterator() do
		local craftString = CraftString.FromRecipeString(recipeString)
		for _, itemString, quantity in TSM.Crafting.MatIterator(craftString) do
			matsNumNeed[itemString] = (matsNumNeed[itemString] or 0) + quantity * numQueued
		end
		for _, _, itemId in RecipeString.OptionalMatIterator(recipeString) do
			local matItemString = "i:"..itemId
			matsNumNeed[matItemString] = (matsNumNeed[matItemString] or 0) + 1 * numQueued
		end
	end
	query:Release()

	local matQueue = TempTable.Acquire()
	local matsNumHave = TempTable.Acquire()
	local matsNumHaveExtra = TempTable.Acquire()
	for itemString, numNeed in pairs(matsNumNeed) do
		matsNumHave[itemString] = private.GetCrafterInventoryQuantity(itemString)
		local numUsed = nil
		numNeed, numUsed = private.HandleNumHave(itemString, numNeed, matsNumHave[itemString])
		if numUsed < matsNumHave[itemString] then
			matsNumHaveExtra[itemString] = matsNumHave[itemString] - numUsed
		end
		if numNeed > 0 then
			matsNumNeed[itemString] = numNeed
			tinsert(matQueue, itemString)
		else
			matsNumNeed[itemString] = nil
		end
	end

	local sourceList = TempTable.Acquire()
	local matSourceList = TempTable.Acquire()
	while #matQueue > 0 do
		local itemString = tremove(matQueue)
		wipe(sourceList)
		local numNeed = matsNumNeed[itemString]
		-- always add a task to get mail on the crafter if possible
		numNeed = private.ProcessSource(itemString, numNeed, "openMail", sourceList)
		assert(numNeed >= 0)
		for _, source in ipairs(TSM.db.profile.gatheringOptions.sources) do
			local isCraftSource = source == "craftProfit" or source == "craftNoProfit"
			local ignoreSource = false
			if isCraftSource then
				-- check if we are already crafting some materials of this craft so shouldn't craft this item
				local craftString = TSM.Crafting.GetMostProfitableCraftStringByItem(itemString, crafter, true)
				if craftString then
					for _, matItemString in TSM.Crafting.MatIterator(craftString) do
						if not ignoreSource and matSourceList[matItemString] and strmatch(matSourceList[matItemString], "craft[a-zA-Z]+/[^,]+/") then
							ignoreSource = true
						end
					end
				else
					-- can't craft this item
					ignoreSource = true
				end
			end
			if not ignoreSource then
				local prevNumNeed = numNeed
				numNeed = private.ProcessSource(itemString, numNeed, source, sourceList)
				assert(numNeed >= 0)
				if numNeed == 0 then
					if isCraftSource then
						-- we are crafting these, so add the necessary mats
						local craftString = TSM.Crafting.GetMostProfitableCraftStringByItem(itemString, crafter, true)
						assert(craftString)
						local numToCraft = ceil(prevNumNeed / TSM.Crafting.GetNumResult(craftString))
						for _, intMatItemString, intMatQuantity in TSM.Crafting.MatIterator(craftString) do
							local intMatNumNeed, numUsed = private.HandleNumHave(intMatItemString, numToCraft * intMatQuantity, matsNumHaveExtra[intMatItemString] or 0)
							if numUsed > 0 then
								matsNumHaveExtra[intMatItemString] = matsNumHaveExtra[intMatItemString] - numUsed
							end
							if intMatNumNeed > 0 then
								if not matsNumNeed[intMatItemString] then
									local intMatNumHave = private.GetCrafterInventoryQuantity(intMatItemString)
									if intMatNumNeed > intMatNumHave then
										matsNumHave[intMatItemString] = intMatNumHave
										matsNumNeed[intMatItemString] = intMatNumNeed - intMatNumHave
										tinsert(matQueue, intMatItemString)
									elseif intMatNumHave > intMatNumNeed then
										matsNumHaveExtra[intMatItemString] = intMatNumHave - intMatNumNeed
									end
								else
									matsNumNeed[intMatItemString] = (matsNumNeed[intMatItemString] or 0) + intMatNumNeed
									if matSourceList[intMatItemString] then
										-- already processed this item, so queue it again
										tinsert(matQueue, intMatItemString)
									end
								end
							end
						end
					end
					break
				end
			end
		end
		sort(sourceList)
		matSourceList[itemString] = table.concat(sourceList, ",")
	end
	private.db:TruncateAndBulkInsertStart()
	for itemString, numNeed in pairs(matsNumNeed) do
		private.db:BulkInsertNewRow(itemString, numNeed, matsNumHave[itemString], matSourceList[itemString])
	end
	private.db:BulkInsertEnd()

	TempTable.Release(sourceList)
	TempTable.Release(matSourceList)
	TempTable.Release(matsNumNeed)
	TempTable.Release(matsNumHave)
	TempTable.Release(matsNumHaveExtra)
	TempTable.Release(matQueue)
end

function private.ProcessSource(itemString, numNeed, source, sourceList)
	local crafter = TSM.db.factionrealm.gatheringContext.crafter
	local playerName = UnitName("player")
	if source == "openMail" then
		local crafterMailQuantity = Inventory.GetMailQuantity(itemString, crafter)
		if crafterMailQuantity > 0 then
			crafterMailQuantity = min(crafterMailQuantity, numNeed)
			if crafter == playerName then
				tinsert(sourceList, "openMail/"..crafterMailQuantity.."/")
			else
				tinsert(sourceList, "alt/"..crafterMailQuantity.."/"..crafter)
			end
			return numNeed - crafterMailQuantity
		end
	elseif source == "vendor" then
		if ItemInfo.GetVendorBuy(itemString) then
			-- assume we can buy all we need from the vendor
			tinsert(sourceList, "vendor/"..numNeed.."/")
			return 0
		end
	elseif source == "guildBank" then
		local guild = PlayerInfo.GetPlayerGuild(crafter)
		local guildBankQuantity = guild and Inventory.GetGuildQuantity(itemString, guild) or 0
		if guildBankQuantity > 0 then
			guildBankQuantity = min(guildBankQuantity, numNeed)
			if crafter == playerName then
				-- we are on the crafter
				tinsert(sourceList, "guildBank/"..guildBankQuantity.."/")
			else
				-- need to switch to the crafter to get items from the guild bank
				tinsert(sourceList, "altGuildBank/"..guildBankQuantity.."/"..crafter)
			end
			return numNeed - guildBankQuantity
		end
	elseif source == "alt" then
		if ItemInfo.IsSoulbound(itemString) then
			-- can't mail soulbound items
			return numNeed
		end
		if crafter ~= playerName then
			-- we are on the alt, so see if we can gather items from this character
			local bagQuantity = Inventory.GetBagQuantity(itemString)
			local bankQuantity = Inventory.GetBankQuantity(itemString) + Inventory.GetReagentBankQuantity(itemString)
			local mailQuantity = Inventory.GetMailQuantity(itemString)

			if bagQuantity > 0 then
				bagQuantity = min(numNeed, bagQuantity)
				tinsert(sourceList, "sendMail/"..bagQuantity.."/")
				numNeed = numNeed - bagQuantity
				if numNeed == 0 then
					return 0
				end
			end
			if mailQuantity > 0 then
				mailQuantity = min(numNeed, mailQuantity)
				tinsert(sourceList, "openMail/"..mailQuantity.."/")
				numNeed = numNeed - mailQuantity
				if numNeed == 0 then
					return 0
				end
			end
			if bankQuantity > 0 then
				bankQuantity = min(numNeed, bankQuantity)
				tinsert(sourceList, "bank/"..bankQuantity.."/")
				numNeed = numNeed - bankQuantity
				if numNeed == 0 then
					return 0
				end
			end
		end

		-- check alts
		local altNum = 0
		local altCharacters = TempTable.Acquire()
		for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
			for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
				local characterKey = nil
				if factionrealm == UnitFactionGroup("player").." - "..GetRealmName() then
					characterKey = character
				else
					characterKey = character.." - "..factionrealm
				end
				if characterKey ~= crafter and characterKey ~= playerName then
					local num = 0
					num = num + Inventory.GetBagQuantity(itemString, character, factionrealm)
					num = num + Inventory.GetBankQuantity(itemString, character, factionrealm)
					num = num + Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
					num = num + Inventory.GetMailQuantity(itemString, character, factionrealm)
					if num > 0 then
						tinsert(altCharacters, characterKey)
						altNum = altNum + num
					end
				end
			end
		end

		local altCharactersStr = table.concat(altCharacters, "`")
		TempTable.Release(altCharacters)
		if altNum > 0 then
			altNum = min(altNum, numNeed)
			tinsert(sourceList, "alt/"..altNum.."/"..altCharactersStr)
			return numNeed - altNum
		end
	elseif source == "altGuildBank" then
		local currentGuild = PlayerInfo.GetPlayerGuild(playerName)
		if currentGuild and crafter ~= playerName then
			-- we are on an alt, so see if we can gather items from this character's guild bank
			local guildBankQuantity = Inventory.GetGuildQuantity(itemString)
			if guildBankQuantity > 0 then
				guildBankQuantity = min(numNeed, guildBankQuantity)
				tinsert(sourceList, "guildBank/"..guildBankQuantity.."/")
				numNeed = numNeed - guildBankQuantity
				if numNeed == 0 then
					return 0
				end
			end
		end

		-- check alts
		local totalGuildBankQuantity = 0
		local altCharacters = TempTable.Acquire()
		for _, character in PlayerInfo.CharacterIterator(true) do
			local guild = PlayerInfo.GetPlayerGuild(character)
			if guild and guild ~= currentGuild then
				local guildBankQuantity = Inventory.GetGuildQuantity(itemString, guild)
				if guildBankQuantity > 0 then
					tinsert(altCharacters, character)
					totalGuildBankQuantity = totalGuildBankQuantity + guildBankQuantity
				end
			end
		end
		local altCharactersStr = table.concat(altCharacters, "`")
		TempTable.Release(altCharacters)
		if totalGuildBankQuantity > 0 then
			totalGuildBankQuantity = min(totalGuildBankQuantity, numNeed)
			tinsert(sourceList, "altGuildBank/"..totalGuildBankQuantity.."/"..altCharactersStr)
			return numNeed - totalGuildBankQuantity
		end
	elseif source == "craftProfit" or source == "craftNoProfit" then
		local craftString, maxProfit, lowestCraftingCost = TSM.Crafting.GetMostProfitableCraftStringByItem(itemString, crafter, true)
		if craftString and (source == "craftNoProfit" or (maxProfit and maxProfit > 0) or (not maxProfit and ItemInfo.IsSoulbound(itemString) and lowestCraftingCost)) then
			-- assume we can craft all we need
			tinsert(sourceList, source.."/"..numNeed.."/")
			return 0
		end
	elseif source == "auction" then
		if ItemInfo.IsSoulbound(itemString) then
			-- can't buy soulbound items
			return numNeed
		end
		-- assume we can buy all we need from the AH
		tinsert(sourceList, "auction/"..numNeed.."/")
		return 0
	elseif source == "auctionCrafting" then
		if ItemInfo.IsSoulbound(itemString) then
			-- can't buy soulbound items
			return numNeed
		end
		if not Conversions.GetSourceItems(itemString) then
			-- can't convert to get this item
			return numNeed
		end
		-- assume we can buy all we need from the AH
		tinsert(sourceList, "auctionCrafting/"..numNeed.."/")
		return 0
	elseif source == "auctionDE" then
		if ItemInfo.IsSoulbound(itemString) then
			-- can't buy soulbound items
			return numNeed
		end
		if not DisenchantInfo.IsTargetItem(itemString) then
			-- can't disenchant to get this item
			return numNeed
		end
		-- assume we can buy all we need from the AH
		tinsert(sourceList, "auctionDE/"..numNeed.."/")
		return 0
	else
		error("Unkown source: "..tostring(source))
	end
	return numNeed
end

function private.QueryPlayerFilter(row, player)
	return String.SeparatedContains(row:GetField("players"), ",", player)
end

function private.GetCrafterInventoryQuantity(itemString)
	local crafter = TSM.db.factionrealm.gatheringContext.crafter
	return Inventory.GetBagQuantity(itemString, crafter) + Inventory.GetReagentBankQuantity(itemString, crafter) + Inventory.GetBankQuantity(itemString, crafter)
end

function private.HandleNumHave(itemString, numNeed, numHave)
	if numNeed > numHave then
		-- use everything we have
		numNeed = numNeed - numHave
		return numNeed, numHave
	else
		-- we have at least as many as we need, so use all of them
		return 0, numNeed
	end
end
