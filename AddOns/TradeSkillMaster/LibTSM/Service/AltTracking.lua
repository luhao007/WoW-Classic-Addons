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
		:AddUniqueStringField("levelItemString")
		:AddNumberField("quantity")
		:Commit()

	local altItemQuantity = TempTable.Acquire()
	for _, factionrealm, character, syncScopeKey in Settings.ConnectedFactionrealmAltCharacterIterator() do
		for _, key in Vararg.Iterator("bagQuantity", "bankQuantity", "reagentBankQuantity", "auctionQuantity", "mailQuantity") do
			for levelItemString, quantity in pairs(Settings.Get("sync", syncScopeKey, "internalData", key)) do
				altItemQuantity[levelItemString] = (altItemQuantity[levelItemString] or 0) + quantity
			end
		end
		local pendingMailLookup = Settings.Get("factionrealm", factionrealm, "internalData", "pendingMail")
		local pendingMail = pendingMailLookup[character]
		local isValid = true
		if pendingMail then
			for levelItemString, quantity in pairs(pendingMail) do
				if type(quantity) ~= "number" then
					isValid = false
					break
				end
				altItemQuantity[levelItemString] = (altItemQuantity[levelItemString] or 0) + quantity
			end
		end
		if not isValid then
			pendingMailLookup[character] = nil
		end
	end
	private.quantityDB:BulkInsertStart()
	for levelItemString, quantity in pairs(altItemQuantity) do
		private.quantityDB:BulkInsertNewRow(levelItemString, quantity)
	end
	private.quantityDB:BulkInsertEnd()
	TempTable.Release(altItemQuantity)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function AltTracking.ItemIterator()
	return private.quantityDB:NewQuery()
		:Select("levelItemString")
		:IteratorAndRelease()
end

function AltTracking.GetQuantityByLevelItemString(levelItemString)
	return private.quantityDB:GetUniqueRowField("levelItemString", levelItemString, "quantity") or 0
end
