-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Inventory = TSM.Init("Service.Inventory")
local ItemString = TSM.Include("Util.ItemString")
local Settings = TSM.Include("Service.Settings")
local CustomPrice = TSM.Include("Service.CustomPrice")
local BagTracking = TSM.Include("Service.BagTracking")
local AuctionTracking = TSM.Include("Service.AuctionTracking")
local MailTracking = TSM.Include("Service.MailTracking")
local Sync = TSM.Include("Service.Sync")
local private = {
	settings = nil,
	callbacks = {},
}
local PLAYER_NAME = UnitName("player")



-- ============================================================================
-- Module Loading
-- ============================================================================

Inventory:OnSettingsLoad(function()
	private.settings = Settings.NewView()
		:AddKey("factionrealm", "internalData", "pendingMail")
		:AddKey("factionrealm", "coreOptions", "ignoreGuilds")
		:AddKey("factionrealm", "internalData", "guildVaults")
	BagTracking.RegisterCallback(private.QuantityChangedCallback)
	AuctionTracking.RegisterCallback(private.QuantityChangedCallback)
	MailTracking.RegisterCallback(private.QuantityChangedCallback)
	Sync.RegisterMirrorCallback(private.QuantityChangedCallback)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function Inventory.RegisterCallback(callback)
	tinsert(private.callbacks, callback)
end

function Inventory.GetBagQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "bagQuantity", character, factionrealm)
end

function Inventory.GetBankQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "bankQuantity", character, factionrealm)
end

function Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "reagentBankQuantity", character, factionrealm)
end

function Inventory.GetAuctionQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "auctionQuantity", character, factionrealm)
end

function Inventory.GetMailQuantity(itemString, character, factionrealm)
	itemString = ItemString.GetBaseFast(itemString)
	character = character or PLAYER_NAME
	local pendingQuantity = itemString and private.settings.pendingMail[character] and private.settings.pendingMail[character][itemString] or 0
	return private.InventoryQuantityHelper(itemString, "mailQuantity", character, factionrealm) + pendingQuantity
end

function Inventory.GetGuildQuantity(itemString, guild)
	itemString = ItemString.GetBase(itemString)
	if not itemString then
		return 0
	end
	guild = guild or (IsInGuild() and GetGuildInfo("player") or nil)
	if not guild or private.settings.ignoreGuilds[guild] then
		return 0
	end
	return private.settings.guildVaults[guild] and private.settings.guildVaults[guild][itemString] or 0
end

function Inventory.GetPlayerTotals(itemString)
	itemString = ItemString.GetBaseFast(itemString)
	local numPlayer, numAlts, numAuctions, numAltAuctions = 0, 0, 0, 0
	numPlayer = numPlayer + Inventory.GetBagQuantity(itemString)
	numPlayer = numPlayer + Inventory.GetBankQuantity(itemString)
	numPlayer = numPlayer + Inventory.GetReagentBankQuantity(itemString)
	numPlayer = numPlayer + Inventory.GetMailQuantity(itemString)
	numAuctions = numAuctions + Inventory.GetAuctionQuantity(itemString)
	for _, factionrealm, character in Settings.ConnectedFactionrealmAltCharacterIterator() do
		numAlts = numAlts + Inventory.GetBagQuantity(itemString, character, factionrealm)
		numAlts = numAlts + Inventory.GetBankQuantity(itemString, character, factionrealm)
		numAlts = numAlts + Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
		numAlts = numAlts + Inventory.GetMailQuantity(itemString, character, factionrealm)
		local auctionQuantity = Inventory.GetAuctionQuantity(itemString, character, factionrealm)
		numAltAuctions = numAltAuctions + auctionQuantity
		numAuctions = numAuctions + auctionQuantity
	end
	return numPlayer, numAlts, numAuctions, numAltAuctions
end

function Inventory.GetGuildTotal(itemString)
	itemString = ItemString.GetBaseFast(itemString)
	if not itemString then
		return 0
	end
	local numGuild = 0
	for guild, data in pairs(private.settings.guildVaults) do
		if not private.settings.ignoreGuilds[guild] then
			numGuild = numGuild + (data[itemString] or 0)
		end
	end
	return numGuild
end

function Inventory.GetTotalQuantity(itemString)
	local numPlayer, numAlts, numAuctions = Inventory.GetPlayerTotals(itemString)
	local numGuild = Inventory.GetGuildTotal(itemString)
	return numPlayer + numAlts + numAuctions + numGuild
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetCharacterInventoryData(settingKey, character, factionrealm)
	local scopeKey = character and Settings.GetSyncScopeKeyByCharacter(character, factionrealm) or nil
	return Settings.Get("sync", scopeKey, "internalData", settingKey)
end

function private.InventoryQuantityHelper(itemString, settingKey, character, factionrealm)
	itemString = ItemString.GetBase(itemString)
	if not itemString then
		return 0
	end
	local tbl = private.GetCharacterInventoryData(settingKey, character, factionrealm)
	return tbl and tbl[itemString] or 0
end

function private.QuantityChangedCallback()
	CustomPrice.OnSourceChange("NumInventory")
	for _, callback in ipairs(private.callbacks) do
		callback()
	end
end
