-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Inventory TSMAPI_FOUR Functions
-- @module Inventory

TSMAPI_FOUR.Inventory = {}
local _, TSM = ...
local ItemString = TSM.Include("Util.ItemString")
local private = {
	altQuantityDB = nil,
}
local PLAYER_NAME = UnitName("player")



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

function TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "bagQuantity", character, factionrealm)
end

function TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "bankQuantity", character, factionrealm)
end

function TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "reagentBankQuantity", character, factionrealm)
end

function TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "auctionQuantity", character, factionrealm)
end

function TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, character, factionrealm)
	itemString = ItemString.GetBase(itemString)
	character = character or PLAYER_NAME
	local pendingQuantity = itemString and TSM.db.factionrealm.internalData.pendingMail[character] and TSM.db.factionrealm.internalData.pendingMail[character][itemString] or 0
	return private.InventoryQuantityHelper(itemString, "mailQuantity", character, factionrealm) + pendingQuantity
end

function TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString, guild)
	itemString = ItemString.GetBase(itemString)
	if not itemString then
		return 0
	end
	guild = guild or (IsInGuild() and GetGuildInfo("player") or nil)
	if not guild or TSM.db.factionrealm.coreOptions.ignoreGuilds[guild] then
		return 0
	end
	return TSM.db.factionrealm.internalData.guildVaults[guild] and TSM.db.factionrealm.internalData.guildVaults[guild][itemString] or 0
end

function TSMAPI_FOUR.Inventory.GetPlayerTotals(itemString)
	local numPlayer, numAlts, numAuctions, numAltAuctions = 0, 0, 0, 0
	for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
		for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
			if character == PLAYER_NAME and factionrealm == UnitFactionGroup("player").." - "..GetRealmName() then
				numPlayer = numPlayer + TSMAPI_FOUR.Inventory.GetBagQuantity(itemString)
				numPlayer = numPlayer + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString)
				numPlayer = numPlayer + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString)
				numPlayer = numPlayer + TSMAPI_FOUR.Inventory.GetMailQuantity(itemString)
			else
				numAlts = numAlts + TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, character, factionrealm)
				numAlts = numAlts + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, character, factionrealm)
				numAlts = numAlts + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
				numAlts = numAlts + TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, character, factionrealm)
				numAltAuctions = numAltAuctions + TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, character, factionrealm)
			end
			numAuctions = numAuctions + TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, character, factionrealm)
		end
	end
	return numPlayer, numAlts, numAuctions, numAltAuctions
end

function TSMAPI_FOUR.Inventory.GetGuildTotal(itemString)
	itemString = ItemString.GetBase(itemString)
	if not itemString then
		return 0
	end
	local numGuild = 0
	for guild, data in pairs(TSM.db.factionrealm.internalData.guildVaults) do
		if not TSM.db.factionrealm.coreOptions.ignoreGuilds[guild] then
			numGuild = numGuild + (data[itemString] or 0)
		end
	end
	return numGuild
end

function TSMAPI_FOUR.Inventory.GetTotalQuantity(itemString)
	itemString = ItemString.GetBase(itemString)
	if not itemString then
		return 0
	end
	local numPlayer, numAlts, numAuctions = TSMAPI_FOUR.Inventory.GetPlayerTotals(itemString)
	local numGuild = TSMAPI_FOUR.Inventory.GetGuildTotal(itemString)
	return numPlayer + numAlts + numAuctions + numGuild
end

function TSMAPI_FOUR.Inventory.GetCraftingTotals(ignoreCharacters, otherItems)
	local bagTotal, auctionTotal, otherTotal, total = {}, {}, {}, {}

	for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
		for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
			if not ignoreCharacters[character] then
				for itemString, quantity in pairs(private.GetCharacterInventoryData("bagQuantity", character, factionrealm)) do
					if character == PLAYER_NAME then
						bagTotal[itemString] = (bagTotal[itemString] or 0) + quantity
						total[itemString] = (total[itemString] or 0) + quantity
					else
						otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
						total[itemString] = (total[itemString] or 0) + quantity
					end
				end
				for itemString, quantity in pairs(private.GetCharacterInventoryData("bankQuantity", character, factionrealm)) do
					otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
					total[itemString] = (total[itemString] or 0) + quantity
				end
				for itemString, quantity in pairs(private.GetCharacterInventoryData("reagentBankQuantity", character, factionrealm)) do
					if character == PLAYER_NAME then
						if otherItems[itemString] then
							otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
						else
							bagTotal[itemString] = (bagTotal[itemString] or 0) + quantity
						end
					else
						otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
					end
					total[itemString] = (total[itemString] or 0) + quantity
				end
				for itemString, quantity in pairs(private.GetCharacterInventoryData("mailQuantity", character, factionrealm)) do
					otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
					total[itemString] = (total[itemString] or 0) + quantity
				end
				for itemString, quantity in pairs(private.GetCharacterInventoryData("auctionQuantity", character, factionrealm)) do
					auctionTotal[itemString] = (auctionTotal[itemString] or 0) + quantity
					total[itemString] = (total[itemString] or 0) + quantity
				end
			end
		end
	end

	for _, data in pairs(TSM.db.factionrealm.internalData.pendingMail) do
		for itemString, quantity in pairs(data) do
			otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
			total[itemString] = (total[itemString] or 0) + quantity
		end
	end

	for guild, data in pairs(TSM.db.factionrealm.internalData.guildVaults) do
		if not TSM.db.factionrealm.coreOptions.ignoreGuilds[guild] then
			for itemString, quantity in pairs(data) do
				otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
				total[itemString] = (total[itemString] or 0) + quantity
			end
		end
	end

	return bagTotal, auctionTotal, otherTotal, total
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetCharacterInventoryData(settingKey, character, factionrealm)
	local scopeKey = character and TSM.db:GetSyncScopeKeyByCharacter(character, factionrealm) or nil
	return TSM.db:Get("sync", scopeKey, "internalData", settingKey)
end

function private.InventoryQuantityHelper(itemString, settingKey, character, factionrealm)
	itemString = ItemString.GetBase(itemString)
	if not itemString then
		return 0
	end
	local tbl = private.GetCharacterInventoryData(settingKey, character, factionrealm)
	return tbl and tbl[itemString] or 0
end
