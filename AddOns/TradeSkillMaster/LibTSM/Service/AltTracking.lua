-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AltTracking = TSM.Init("Service.AltTracking")
local Database = TSM.Include("Util.Database")
local TempTable = TSM.Include("Util.TempTable")
local Vararg = TSM.Include("Util.Vararg")
local Settings = TSM.Include("Service.Settings")
local private = {
	quantityDB = nil,
}



-- ============================================================================
-- Module Loading
-- ============================================================================

AltTracking:OnSettingsLoad(function()
	private.quantityDB = Database.NewSchema("INVENTORY_ALT_QUANTITY")
		:AddUniqueStringField("itemString")
		:AddNumberField("quantity")
		:Commit()

	local altItemQuantity = TempTable.Acquire()
	for _, factionrealm, character, syncScopeKey in Settings.ConnectedFactionrealmAltCharacterIterator() do
		for _, key in Vararg.Iterator("bagQuantity", "bankQuantity", "reagentBankQuantity", "auctionQuantity", "mailQuantity") do
			for itemString, quantity in pairs(Settings.Get("sync", syncScopeKey, "internalData", key)) do
				altItemQuantity[itemString] = (altItemQuantity[itemString] or 0) + quantity
			end
		end
		local pendingMailLookup = Settings.Get("factionrealm", factionrealm, "internalData", "pendingMail")
		local pendingMail = pendingMailLookup[character]
		local isValid = true
		if pendingMail then
			for itemString, quantity in pairs(pendingMail) do
				if type(quantity) ~= "number" then
					isValid = false
					break
				end
				altItemQuantity[itemString] = (altItemQuantity[itemString] or 0) + quantity
			end
		end
		if not isValid then
			pendingMailLookup[character] = nil
		end
	end
	private.quantityDB:BulkInsertStart()
	for itemString, quantity in pairs(altItemQuantity) do
		private.quantityDB:BulkInsertNewRow(itemString, quantity)
	end
	private.quantityDB:BulkInsertEnd()
	TempTable.Release(altItemQuantity)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function AltTracking.BaseItemIterator()
	return private.quantityDB:NewQuery()
		:Select("itemString")
		:IteratorAndRelease()
end

function AltTracking.GetQuantityByBaseItemString(baseItemString)
	return private.quantityDB:GetUniqueRowField("itemString", baseItemString, "quantity") or 0
end
