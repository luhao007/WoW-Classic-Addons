-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local GuildTracking = TSM.Init("Service.GuildTracking")
local Database = TSM.Include("Util.Database")
local Delay = TSM.Include("Util.Delay")
local Event = TSM.Include("Util.Event")
local TempTable = TSM.Include("Util.TempTable")
local SlotId = TSM.Include("Util.SlotId")
local Log = TSM.Include("Util.Log")
local ItemString = TSM.Include("Util.ItemString")
local Settings = TSM.Include("Service.Settings")
local private = {
	settings = nil,
	slotDB = nil,
	quantityDB = nil,
	isOpen = nil,
	pendingPetSlotIds = {},
}
local PLAYER_NAME = UnitName("player")
local PLAYER_GUILD = nil
local MAX_PET_SCANS = 10
-- don't use MAX_GUILDBANK_SLOTS_PER_TAB since it isn't available right away
local GUILD_BANK_TAB_SLOTS = 98



-- ============================================================================
-- Module Loading
-- ============================================================================

GuildTracking:OnSettingsLoad(function()
	private.settings = Settings.NewView()
		:AddKey("factionrealm", "internalData", "characterGuilds")
		:AddKey("factionrealm", "internalData", "guildVaults")
	private.slotDB = Database.NewSchema("GUILD_TRACKING_SLOTS")
		:AddUniqueNumberField("slotId")
		:AddNumberField("tab")
		:AddNumberField("slot")
		:AddStringField("itemString")
		:AddSmartMapField("baseItemString", ItemString.GetBaseMap(), "itemString")
		:AddNumberField("quantity")
		:AddIndex("slotId")
		:AddIndex("itemString")
		:Commit()
	private.quantityDB = Database.NewSchema("GUILD_TRACKING_QUANTITY")
		:AddUniqueStringField("itemString")
		:AddNumberField("quantity")
		:Commit()
	if not TSM.IsWowClassic() then
		Event.Register("GUILDBANKFRAME_OPENED", private.GuildBankFrameOpenedHandler)
		Event.Register("GUILDBANKFRAME_CLOSED", private.GuildBankFrameClosedHandler)
		Event.Register("GUILDBANKBAGSLOTS_CHANGED", private.GuildBankBagSlotsChangedHandler)
		Delay.AfterFrame(1, private.GetGuildName)
		Event.Register("PLAYER_GUILD_UPDATE", private.GetGuildName)
	end
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function GuildTracking.BaseItemIterator()
	return private.quantityDB:NewQuery()
		:Select("itemString")
		:IteratorAndRelease()
end

function GuildTracking.CreateQuery()
	return private.slotDB:NewQuery()
end

function GuildTracking.CreateQueryItem(itemString)
	local query = GuildTracking.CreateQuery()
	if itemString == ItemString.GetBaseFast(itemString) then
		query:Equal("baseItemString", itemString)
	else
		query:Equal("itemString", itemString)
	end
	return query
end

function GuildTracking.GetQuantityByBaseItemString(baseItemString)
	return private.quantityDB:GetUniqueRowField("itemString", baseItemString, "quantity") or 0
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetGuildName()
	if not IsInGuild() then
		private.settings.characterGuilds[PLAYER_NAME] = nil
		return
	end
	PLAYER_GUILD = GetGuildInfo("player")
	if not PLAYER_GUILD then
		-- try again next frame
		Delay.AfterFrame(1, private.GetGuildName)
		return
	end

	private.settings.characterGuilds[PLAYER_NAME] = PLAYER_GUILD

	-- clean up any guilds with no players in them
	local validGuilds = TempTable.Acquire()
	for _, character in Settings.CharacterByAccountFactionrealmIterator() do
		local guild = private.settings.characterGuilds[character]
		if guild then
			validGuilds[guild] = true
		end
	end
	for character, guild in pairs(private.settings.characterGuilds) do
		if not validGuilds[guild] then
			private.settings.characterGuilds[character] = nil
		end
	end
	for guild in pairs(private.settings.guildVaults) do
		if not validGuilds[guild] then
			private.settings.guildVaults[guild] = nil
		end
	end
	TempTable.Release(validGuilds)

	private.settings.guildVaults[PLAYER_GUILD] = private.settings.guildVaults[PLAYER_GUILD] or {}
	for itemString, quantity in pairs(private.settings.guildVaults[PLAYER_GUILD]) do
		if quantity <= 0 or itemString ~= ItemString.GetBase(itemString) then
			private.settings.guildVaults[PLAYER_GUILD][itemString] = nil
		end
	end
	private.RebuildQuantityDB()
end

function private.RebuildQuantityDB()
	private.quantityDB:TruncateAndBulkInsertStart()
	for itemString, quantity in pairs(private.settings.guildVaults[PLAYER_GUILD]) do
		if quantity > 0 then
			private.quantityDB:BulkInsertNewRow(itemString, quantity)
		else
			private.settings.guildVaults[PLAYER_GUILD][itemString] = nil
		end
	end
	private.quantityDB:BulkInsertEnd()
end

function private.GuildBankFrameOpenedHandler()
	local initialTab = GetCurrentGuildBankTab()
	for i = 1, GetNumGuildBankTabs() do
		QueryGuildBankTab(i)
	end
	QueryGuildBankTab(initialTab)
	private.isOpen = true
end

function private.GuildBankFrameClosedHandler()
	private.isOpen = nil
end

function private.GuildBankBagSlotsChangedHandler()
	Delay.AfterFrame("guildBankScan", 2, private.GuildBankChangedDelayed)
end

function private.GuildBankChangedDelayed()
	if not private.isOpen then
		return
	end
	if not PLAYER_GUILD then
		-- we don't have the guild name yet, so try again after a short delay
		Delay.AfterFrame("guildBankScan", 2, private.GuildBankChangedDelayed)
		return
	end
	private.ScanGuildBank()
end

function private.ScanGuildBank()
	wipe(private.settings.guildVaults[PLAYER_GUILD])
	wipe(private.pendingPetSlotIds)
	private.slotDB:TruncateAndBulkInsertStart()
	local didFail = false
	for tab = 1, GetNumGuildBankTabs() do
		-- only scan tabs which we have at least enough withdrawals to withdraw every slot
		local _, _, _, _, numWithdrawals = GetGuildBankTabInfo(tab)
		if numWithdrawals == -1 or numWithdrawals >= GUILD_BANK_TAB_SLOTS then
			for slot = 1, GUILD_BANK_TAB_SLOTS do
				local itemLink = GetGuildBankItemLink(tab, slot)
				if itemLink then
					local slotId = SlotId.Join(tab, slot)
					local baseItemString = ItemString.GetBase(itemLink)
					if baseItemString == ItemString.GetPetCage() then
						private.pendingPetSlotIds[slotId] = true
						baseItemString = nil
					end
					if baseItemString then
						local _, quantity = GetGuildBankItemInfo(tab, slot)
						if quantity == 0 then
							-- the info for this slot isn't fully loaded yet
							Log.Err("Failed to scan guild bank slot (%d)", slotId)
							didFail = true
							break
						end
						private.settings.guildVaults[PLAYER_GUILD][baseItemString] = (private.settings.guildVaults[PLAYER_GUILD][baseItemString] or 0) + quantity
						local itemString = ItemString.Get(itemLink)
						private.slotDB:BulkInsertNewRow(slotId, tab, slot, itemString, quantity)
					end
				end
			end
		end
		if didFail then
			break
		end
	end
	private.RebuildQuantityDB()
	private.slotDB:BulkInsertEnd()
	if didFail then
		Delay.AfterFrame("guildBankScan", 2, private.GuildBankChangedDelayed)
	elseif next(private.pendingPetSlotIds) then
		Delay.AfterFrame("guildBankPetScan", 2, private.ScanPetsDeferred)
	else
		Delay.Cancel("guildBankPetScan")
	end
end

function private.ScanPetsDeferred()
	if not TSMScanTooltip then
		CreateFrame("GameTooltip", "TSMScanTooltip", UIParent, "GameTooltipTemplate")
	end
	TSMScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	TSMScanTooltip:ClearLines()

	local numPetSlotIdsScanned = 0
	local toRemove = TempTable.Acquire()
	private.slotDB:BulkInsertStart()
	for slotId in pairs(private.pendingPetSlotIds) do
		local tab, slot = SlotId.Split(slotId)
		local speciesId, level, rarity = TSMScanTooltip:SetGuildBankItem(tab, slot)
		if speciesId and level and rarity then
			local itemString = "p:"..speciesId..":"..level..":"..rarity
			if itemString then
				tinsert(toRemove, slotId)
				local _, quantity = GetGuildBankItemInfo(tab, slot)
				local baseItemString = ItemString.GetBase(itemString)
				private.settings.guildVaults[PLAYER_GUILD][baseItemString] = (private.settings.guildVaults[PLAYER_GUILD][baseItemString] or 0) + quantity
				private.slotDB:BulkInsertNewRow(slotId, tab, slot, itemString, quantity)
			end
		end
		-- throttle how many pet slots we scan per call (regardless of whether or not it was successful)
		numPetSlotIdsScanned = numPetSlotIdsScanned + 1
		if numPetSlotIdsScanned == MAX_PET_SCANS then
			break
		end
	end
	private.RebuildQuantityDB()
	private.slotDB:BulkInsertEnd()
	Log.Info("Scanned %d pet slots", numPetSlotIdsScanned)
	for _, slotId in ipairs(toRemove) do
		private.pendingPetSlotIds[slotId] = nil
	end
	TempTable.Release(toRemove)

	if next(private.pendingPetSlotIds) then
		-- there are more to scan
		Delay.AfterFrame("guildBankPetScan", 2, private.ScanPetsDeferred)
	end
end
