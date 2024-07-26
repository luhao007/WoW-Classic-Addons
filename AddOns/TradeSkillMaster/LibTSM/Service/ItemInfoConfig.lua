-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local ItemInfoConfig = TSM.Init("Service.ItemInfoConfig") ---@class Service.ItemInfoConfig: Module
local L = TSM.Locale.GetTable()
local ChatMessage = TSM.LibTSMService:Include("UI.ChatMessage")
local ClientInfo = TSM.LibTSMWoW:Include("Util.ClientInfo")
local ItemInfo = TSM.LibTSMService:Include("Item.ItemInfo")
local VendorBuy = TSM.LibTSMService:Include("Item.VendorBuy")
local private = {
	settings = nil,
	wiped = false,
}
local CACHE_DB_GLOBAL_NAME = "TSMItemInfoDB"
local UNKNOWN_ITEM_NAME = L["Unknown Item"]
local PLACEHOLDER_ITEM_NAME = L["Example Item"]



-- ============================================================================
-- Module Loading
-- ============================================================================

ItemInfoConfig:OnModuleLoad(function()
	local function RebuildCallback(isDone)
		if isDone then
			ChatMessage.PrintUser(L["Done rebuilding item cache."])
		else
			ChatMessage.PrintUser(L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes a few minutes."])
		end
	end
	ItemInfo.Configure(RebuildCallback, UNKNOWN_ITEM_NAME, PLACEHOLDER_ITEM_NAME)
end)

ItemInfoConfig:OnSettingsLoad(function(db)
	private.settings = db:NewView()
		:AddKey("global", "internalData", "vendorItems")

	-- Create the DB if it doesn't exist
	local cacheDB = _G[CACHE_DB_GLOBAL_NAME]
	if not cacheDB then
		cacheDB = {}
		_G[CACHE_DB_GLOBAL_NAME] = cacheDB
	end

	-- Migrate from separate fields to a single versionStr field
	if cacheDB.version and not cacheDB.versionStr then
		cacheDB.versionStr = strjoin(",", tostringall(cacheDB.version, cacheDB.locale, cacheDB.build, cacheDB.revision))
	end

	-- Load the DB
	if not ItemInfo.LoadCache(cacheDB) then
		-- Wipe vendor items since the cache wasn't valid
		wipe(private.settings.vendorItems)
	end

	-- Load VendorBuy
	local function VendorBuyUpdateCallback(itemString)
		ItemInfo.StreamSend(itemString)
	end
	VendorBuy.Load(private.settings.vendorItems, VendorBuyUpdateCallback)

	-- Start
	ItemInfo.Start()

	-- Cache battle pet names
	if ClientInfo.HasFeature(ClientInfo.FEATURES.BATTLE_PETS) then
		for i = 1, C_PetJournal.GetNumPets() do
			C_PetJournal.GetPetInfoByIndex(i)
		end
	end
end)

ItemInfoConfig:OnModuleUnload(function()
	if private.wiped then
		return
	end
	ItemInfo.SaveCache(_G[CACHE_DB_GLOBAL_NAME])
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function ItemInfoConfig.WipeCache()
	wipe(_G[CACHE_DB_GLOBAL_NAME])
	private.wiped = true
	ReloadUI()
end
