-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMService = select(2, ...).LibTSMService
local ItemInfo = LibTSMService:Init("Item.ItemInfo")
local TempTable = LibTSMService:From("LibTSMUtil"):Include("BaseType.TempTable")
local EnumType = LibTSMService:From("LibTSMUtil"):Include("BaseType.EnumType")
local Table = LibTSMService:From("LibTSMUtil"):Include("Lua.Table")
local Log = LibTSMService:From("LibTSMUtil"):Include("Util.Log")
local NonDisenchantable = LibTSMService:From("LibTSMData"):Include("NonDisenchantable")
local ItemString = LibTSMService:From("LibTSMTypes"):Include("Item.ItemString")
local BonusIds = LibTSMService:From("LibTSMTypes"):Include("Item.BonusIds")
local ItemInfoCache = LibTSMService:From("LibTSMTypes"):IncludeClassType("ItemInfoCache")
local DelayTimer = LibTSMService:From("LibTSMWoW"):IncludeClassType("DelayTimer")
local Item = LibTSMService:From("LibTSMWoW"):Include("API.Item")
local Event = LibTSMService:From("LibTSMWoW"):Include("Service.Event")
local ClientInfo = LibTSMService:From("LibTSMWoW"):Include("Util.ClientInfo")
local CharacterInfo = LibTSMService:From("LibTSMWoW"):Include("Util.CharacterInfo")
local ItemClass = LibTSMService:From("LibTSMWoW"):Include("Util.ItemClass")
local private = {
	cache = ItemInfoCache.New(),
	rebuildCallback = nil,
	unknownItemName = nil,
	placeholderItemName = nil,
	pendingItems = {},
	priorityPendingItems = {},
	priorityPendingTime = 0,
	numRequests = {},
	availableItems = {},
	rebuildStage = nil,
	lastDebugLog = 0,
	processInfoTimer = nil,
	processAvailableTimer = nil,
	deferredSetSingleField = {},
	deferredSetSingleFieldTimer = nil,
}
local ITEM_MAX_ID = 999999
local ITEM_INFO_INTERVAL = 0.05
local MAX_REQUESTED_ITEM_INFO = 50
local MAX_REQUESTS_PER_ITEM = 5
local UNKNOWN_ITEM_TEXTURE = 136254
local DB_VERSION = 14
local PENDING_STATE = EnumType.New("ITEM_INFO_PENDING_STATE", {
	NEW = EnumType.NewValue(),
	CREATED = EnumType.NewValue(),
})
-- Some items that can't be sold to a vendor even though GetItemInfo() reports a vendorSell price
local NON_VENDORABLE_ITEMS = {
	["i:194829"] = true, -- Fated Fortune Card
}
local REBUILD_MSG_THRESHOLD = 5000
local REBUILD_STAGE = EnumType.New("ITEM_INFO_REBUILD_STAGE", {
	IDLE = EnumType.NewValue(),
	TRIGGERED = EnumType.NewValue(),
	NOTIFIED = EnumType.NewValue(),
})



-- ============================================================================
-- Module Loading
-- ============================================================================

ItemInfo:OnModuleLoad(function()
	private.rebuildStage = REBUILD_STAGE.IDLE
	private.processAvailableTimer = DelayTimer.New("ITEM_INFO_PROCESS_AVAILABLE", private.ProcessAvailableItems)
	private.processInfoTimer = DelayTimer.New("ITEM_INFO_PROCESS_INFO", private.ProcessItemInfo)
	private.deferredSetSingleFieldTimer = DelayTimer.New("ITEM_INFO_DEFERRED_SET_SINGLE_FIELD", private.HandleDeferredSetSingleField)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

---Configures the item info code.
---@param rebuildCallback fun(isDone: boolean) Function called to notify the application when the cache rebuild has started / finished
---@param unknownItemName string The name to use for the unknown item string
---@param placeholderItemName string The name to use for the placeholder item string
---@return boolean
function ItemInfo.Configure(rebuildCallback, unknownItemName, placeholderItemName)
	private.rebuildCallback = rebuildCallback
	private.unknownItemName = unknownItemName
	private.placeholderItemName = placeholderItemName
end

---Loads the item info cache (returns whether or not the cache was valid).
---@param cacheDB SavedItemInfoCache The cache DB
---@return boolean
function ItemInfo.LoadCache(cacheDB)
	return private.cache:Load(cacheDB, private.GetDBVersionStr())
end

---Starts querying for item info.
function ItemInfo.Start()
	Event.Register("GET_ITEM_INFO_RECEIVED", function(_, itemId, success)
		if not success or itemId <= 0 or itemId > ITEM_MAX_ID or private.numRequests[itemId] == math.huge then
			return
		end
		private.availableItems["i:"..itemId] = true
		private.processAvailableTimer:RunForTime(0)
	end)

	-- Process pending item info every 0.05 seconds
	private.processInfoTimer:RunForTime(0)
end

---Saves the item info cache.
---@param cacheDB SavedItemInfoCache The cache DB to save into
function ItemInfo.SaveCache(cacheDB)
	private.cache:Save(cacheDB, private.GetDBVersionStr())
end

---Sends an item string to the cache's stream to notify consumers of an update.
---@param itemString string
function ItemInfo.StreamSend(itemString)
	return private.cache:StreamSend(itemString)
end

---Gets a publisher for item info changes.
---@return ReactivePublisher
function ItemInfo.GetPublisher()
	return private.cache:Publisher()
end

---Sets whether or not query updates are paused on the item info DB
---@param paused boolean Whether or not query updates are paused
function ItemInfo.SetQueryUpdatesPaused(paused)
	private.cache:SetQueryUpdatesPaused(paused)
end

---Store the name of an item.
-- This function is used to opportunistically populate the item cache with item names.
---@param itemString string The itemString
---@param name string The item name
function ItemInfo.StoreItemName(itemString, name)
	assert(not ItemString.ParseLevel(itemString))
	private.DeferSetSingleField(itemString, "name", name)
end

---Get the itemString from an item name.
---
---This API will return the base itemString when there are multiple variants with the same name and will return nil if
---there are multiple distinct items with the same name.
---@param name string The item name
---@return string?
function ItemInfo.ItemNameToItemString(name)
	local result = nil
	local query = private.cache:NewQuery()
		:Select("itemString")
		:Equal("name", name)
	for _, itemString in query:Iterator() do
		if not result then
			result = itemString
		elseif result ~= ItemString.GetUnknown() then
			-- multiple matching items
			if ItemString.GetBase(itemString) == ItemString.GetBase(result) then
				result = ItemString.GetBase(itemString)
			else
				result = ItemString.GetUnknown()
			end
		end
	end
	query:Release()
	return result
end

---Get the name.
---@param item string The item
---@return string?
function ItemInfo.GetName(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif itemString == ItemString.GetUnknown() then
		return private.unknownItemName
	elseif itemString == ItemString.GetPlaceholder() then
		return private.placeholderItemName
	end
	if ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local name = private.cache:GetField(itemString, "name")
	if not name then
		-- we can fetch info instantly for pets, so try again afterwards
		ItemInfo.FetchInfo(itemString)
		name = private.cache:GetField(itemString, "name")
	end
	if not name then
		-- if we got passed an item link, we can maybe extract the name from it
		name = strmatch(item, "^\124cff[0-9a-z]+\124[Hh].+\124h%[(.+)%]\124h\124r$")
		if name then
			name = gsub(name, " \124A:.+\124a", "")
		end
		if name == "" or name == private.unknownItemName or name == private.placeholderItemName then
			name = nil
		end
		if name then
			private.DeferSetSingleField(itemString, "name", name)
		end
	end
	return name
end

---Get the link (or an "Unknown Item" link).
---@param item string The item
---@return string?
function ItemInfo.GetLink(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	end
	local link = nil
	local itemStringType, speciesId, level, quality, health, power, speed, petId = strsplit(":", itemString)
	local name = ItemInfo.GetName(item) or private.unknownItemName
	local wowItemString = nil
	if itemStringType == "p" then
		quality = tonumber(quality) or 0
		level = level and strmatch(level, "^i(%d+)$") or level
		wowItemString = strjoin(":", "battlepet", speciesId, level or "", quality or "", health or "", power or "", speed or "", petId or "")
	else
		quality = ItemInfo.GetQuality(item)
		wowItemString = private.ToWowItemString(itemString)
	end
	local qualityColor = Item.GetQualityColor(quality) or "|cffff0000"
	link = qualityColor.."|H"..wowItemString.."|h["..name.."]|h|r"
	return link
end

---Get the expansion id.
---@param item string The item
---@return number?
function ItemInfo.GetExpansion(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local expansionId = private.GetFieldValueHelper(itemString, "expansionId", true, true, 0)
	return expansionId
end

---Gets the crafted quality.
---@param item string The item
---@return number?
function ItemInfo.GetCraftedQuality(item)
	if not ClientInfo.HasFeature(ClientInfo.FEATURES.CRAFTING_QUALITY) then
		return nil
	end
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif itemString == ItemString.GetUnknown() or itemString == ItemString.GetPlaceholder() then
		return nil
	elseif ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local craftedQuality = private.GetFieldValueHelper(itemString, "craftedQuality", false, false, 0)
	return (craftedQuality or 0) > 0 and craftedQuality or nil
end

---Get the quality.
---@param item string The item
---@return number?
function ItemInfo.GetQuality(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local itemType, _, randOrLevel, bonusOrQuality = strsplit(":", itemString)
	randOrLevel = tonumber(randOrLevel)
	bonusOrQuality = tonumber(bonusOrQuality)
	local petDefault = itemType == "p" and (bonusOrQuality or 0) or nil
	local quality = private.GetFieldValueHelper(itemString, "quality", false, false, petDefault)
	if quality then
		return quality
	end
	if itemType == "i" and randOrLevel and not bonusOrQuality then
		-- there is a random enchant, but no bonusIds, so the quality is the same as the base item
		quality = ItemInfo.GetQuality(ItemString.GetBase(itemString))
	elseif itemType == "i" and bonusOrQuality then
		-- this item has bonusIds
		local classId = ItemInfo.GetClassId(itemString)
		if classId and not Item.VariationImpactsQualityByClass(classId) then
			-- the bonusId does not affect the quality of this item
			quality = ItemInfo.GetQuality(ItemString.GetBase(itemString))
		end
	end
	if quality then
		private.DeferSetSingleField(itemString, "quality", quality)
	else
		ItemInfo.FetchInfo(itemString)
	end
	return quality
end

---Get the quality color.
---@param item string The item
---@return string?
function ItemInfo.GetQualityColor(item)
	local itemString = ItemString.Get(item)
	if itemString == ItemString.GetUnknown() then
		return "|cffff0000"
	elseif itemString == ItemString.GetPlaceholder() then
		return "|cffffffff"
	end
	local quality = ItemInfo.GetQuality(itemString)
	return quality and Item.GetQualityColor(quality) or nil
end

---Get the item level.
---@param item string The item
---@return number?
function ItemInfo.GetItemLevel(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	end
	local itemStringLevel, itemStringLevelIsAbs = ItemString.ParseLevel(itemString)
	if itemStringLevel then
		if itemStringLevelIsAbs then
			return itemStringLevel
		else
			-- level is relative to the base item
			local baseItemLevel = ItemInfo.GetItemLevel(ItemString.GetBaseFast(itemString))
			if not baseItemLevel then
				return nil
			end
			return baseItemLevel + itemStringLevel
		end
	end
	local itemLevel = private.cache:GetField(itemString, "itemLevel")
	if itemLevel then
		return itemLevel
	end
	local itemType, _, randOrLevel, bonusOrQuality = strsplit(":", itemString)
	randOrLevel = tonumber(randOrLevel)
	bonusOrQuality = tonumber(bonusOrQuality)
	if itemType == "p" then
		-- we can fetch info instantly for pets so try again
		ItemInfo.FetchInfo(itemString)
		itemLevel = private.cache:GetField(itemString, "itemLevel")
		if not itemLevel then
			-- just get the level from the item string
			itemLevel = randOrLevel or ItemString.GetItemLevel(itemString) or 0
			private.DeferSetSingleField(itemString, "itemLevel", itemLevel)
		end
	elseif itemType == "i" then
		if randOrLevel and not bonusOrQuality then
			-- there is a random enchant, but no bonusIds, so the itemLevel is the same as the base item
			itemLevel = ItemInfo.GetItemLevel(ItemString.GetBaseFast(itemString))
		end
		if itemLevel then
			private.DeferSetSingleField(itemString, "itemLevel", itemLevel)
		end
		ItemInfo.FetchInfo(itemString)
	else
		error("Invalid item: "..tostring(itemString))
	end
	return itemLevel
end

---Get the min level.
---@param item string The item
---@return number?
function ItemInfo.GetMinLevel(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif ItemString.IsItem(itemString) and ItemString.ParseLevel(itemString) then
		-- Create a fake itemString with the same itemLevel and look up that.
		itemString = ItemString.Get(private.ToWowItemString(itemString))
		assert(itemString)
	end
	-- if there is a random enchant, but no bonusIds, so the itemLevel is the same as the base item
	local baseIsSame = strmatch(itemString, "^i:[0-9]+:[%-0-9]+$") and true or false
	local minLevel = private.GetFieldValueHelper(itemString, "minLevel", baseIsSame, true, 0)
	if not minLevel then
		if ItemString.IsItem(itemString) then
			local baseItemString = ItemString.GetBase(itemString)
			local canHaveVariations = ItemInfo.CanHaveVariations(itemString)
			if itemString ~= baseItemString and canHaveVariations == false then
				-- the bonusId does not affect the minLevel of this item
				minLevel = ItemInfo.GetMinLevel(baseItemString)
				if minLevel then
					private.DeferSetSingleField(itemString, "minLevel", minLevel)
				end
			end
		else
			-- For pets, the min level and item level are the same
			return ItemInfo.GetItemLevel(item)
		end
	end
	return minLevel
end

---Get the max stack size.
---@param item string The item
---@return number?
function ItemInfo.GetMaxStack(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local maxStack = private.GetFieldValueHelper(itemString, "maxStack", true, true, 1)
	if not maxStack and ItemString.IsItem(itemString) then
		-- we might be able to deduce the maxStack based on the classId and subClassId
		local classId = ItemInfo.GetClassId(item)
		local subClassId = ItemInfo.GetSubClassId(item)
		if classId and subClassId then
			if classId == 1 then
				maxStack = 1
			elseif classId == 2 then
				maxStack = 1
			elseif classId == 4 then
				if subClassId > 0 then
					maxStack = 1
				end
			elseif classId == 15 then
				if subClassId == 5 then
					maxStack = 1
				end
			elseif classId == 16 then
				maxStack = 20
			elseif classId == 17 then
				maxStack = 1
			elseif classId == 18 then
				maxStack = 1
			end
		end
		if maxStack then
			private.DeferSetSingleField(itemString, "maxStack", maxStack)
		end
	end
	return maxStack
end

---Get the inventory slot id.
---@param item string The item
---@return number?
function ItemInfo.GetInvSlotId(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local invSlotId = private.GetFieldValueHelper(itemString, "invSlotId", true, true, 0)
	return invSlotId
end

---Get the texture.
---@param item string The item
---@return number?
function ItemInfo.GetTexture(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif itemString == ItemString.GetUnknown() then
		return UNKNOWN_ITEM_TEXTURE
	elseif ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local texture = private.GetFieldValueHelper(itemString, "texture", true, false, nil)
	if texture then
		return texture
	end
	private.StoreGetItemInfoInstant(itemString)
	return private.cache:GetField(itemString, "texture")
end

---Get the vendor sell price.
---@param item string The item
---@return number?
function ItemInfo.GetVendorSell(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif ItemString.IsPet(itemString) then
		-- Can't vendor pets
		return nil
	elseif ItemString.ParseLevel(itemString) then
		-- The vendorSell price does seem to scale linearly with item level, but at a different
		-- rate for different items, so there's no easy way to figure this out directly. Instead,
		-- we create a fake itemString with the same itemLevel and look up that.
		itemString = ItemString.Get(private.ToWowItemString(itemString))
		assert(itemString)
	end
	local vendorSell = private.GetFieldValueHelper(itemString, "vendorSell", false, false, 0)
	return (vendorSell or 0) > 0 and vendorSell or nil
end

---Get the class id.
---@param item string The item
---@return number?
function ItemInfo.GetClassId(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local classId = private.GetFieldValueHelper(itemString, "classId", true, true, ItemClass.GetPetClassId())
	if classId then
		return classId
	end
	private.StoreGetItemInfoInstant(itemString)
	return private.cache:GetField(itemString, "classId")
end

---Get the sub-class id.
---@param item string The item
---@return number?
function ItemInfo.GetSubClassId(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local subClassId = private.GetFieldValueHelper(itemString, "subClassId", true, true, nil)
	if subClassId then
		return subClassId
	end
	private.StoreGetItemInfoInstant(itemString)
	return private.cache:GetField(itemString, "subClassId")
end

---Get whether or not the item is bind on pickup.
---@param item string The item
---@return boolean?
function ItemInfo.IsSoulbound(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local isBOP = private.GetFieldValueHelper(itemString, "isBOP", true, true, false)
	if type(isBOP) == "number" then
		isBOP = isBOP == 1
	end
	return isBOP
end

---Get whether or not the item is a crafting reagent.
---@param item string The item
---@return boolean?
function ItemInfo.IsCraftingReagent(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local isCraftingReagent = private.GetFieldValueHelper(itemString, "isCraftingReagent", true, true, false)
	if type(isCraftingReagent) == "number" then
		isCraftingReagent = isCraftingReagent == 1
	end
	return isCraftingReagent
end

---Get whether or not the item is disenchantable.
---@param item string The item
---@return boolean?
function ItemInfo.IsDisenchantable(item)
	local itemString = ItemString.Get(item)
	if not itemString then
		return nil
	elseif ItemString.ParseLevel(itemString) then
		itemString = ItemString.GetBaseFast(itemString)
	end
	local invSlotId = ItemInfo.GetInvSlotId(itemString)
	if not Item.IsInventorySlotDisenchantable(invSlotId) or NonDisenchantable.All[itemString] then
		return nil
	end
	local quality = ItemInfo.GetQuality(itemString)
	local classId = ItemInfo.GetClassId(itemString)
	if not quality or not classId then
		return nil
	end
	return Item.IsQualityDisenchantable(quality) and Item.IsClassDisenchantable(classId)
end

---Get whether or not the item is a commodity in WoW 8.3 (and above).
---@param item string The item
---@return boolean?
function ItemInfo.IsCommodity(item)
	if not ClientInfo.HasFeature(ClientInfo.FEATURES.COMMODITY_ITEMS) then
		return false
	end
	local stackSize = ItemInfo.GetMaxStack(item)
	if not stackSize then
		return nil
	end
	return stackSize > 1
end

---Get whether or not the item can have variations.
---@param item string The item
---@return boolean?
function ItemInfo.CanHaveVariations(item)
	local classId = ItemInfo.GetClassId(item)
	if not classId then
		return nil
	end
	local canHaveVariations, specificSubClassId = Item.ClassCanHaveVariations(classId)
	if not canHaveVariations then
		return false
	elseif specificSubClassId then
		return ItemInfo.GetSubClassId(item) == specificSubClassId
	else
		return true
	end
end

---Fetch info for the item.
---This function can be called ahead of time for items which we know we need to have info cached for.
---@param item? string The item
function ItemInfo.FetchInfo(item)
	if item == ItemString.GetUnknown() or item == ItemString.GetPlaceholder() or ItemString.ParseLevel(item) then
		return
	end
	local itemString = ItemString.Get(item)
	if not itemString then return end
	if ItemString.IsPet(itemString) then
		if not private.cache:GetField(itemString, "name") then
			private.StoreGetItemInfoInstant(itemString)
		end
		return
	end
	private.pendingItems[itemString] = private.pendingItems[itemString] or PENDING_STATE.NEW
	if private.priorityPendingTime ~= ClientInfo.GetFrameNumber() then
		wipe(private.priorityPendingItems)
		private.priorityPendingTime = ClientInfo.GetFrameNumber()
	end
	private.priorityPendingItems[itemString] = true

	private.processInfoTimer:RunForTime(0)
end

---Generalize an item link.
---@param itemLink string The item link
---@return string?
function ItemInfo.GeneralizeLink(itemLink)
	local itemString = ItemString.Get(itemLink)
	if not itemString then return end
	if ItemString.IsItem(itemString) and not strmatch(itemString, "i:[0-9]+:[0-9%-]*:[0-9]*") then
		-- swap out the itemString part of the link
		local leader, quality, _, name, trailer, trailer2, extra = strsplit("\124", itemLink)
		if trailer2 and not extra then
			return strjoin("\124", leader, quality, "H"..private.ToWowItemString(itemString), name, trailer, trailer2)
		end
	end
	return ItemInfo.GetLink(itemString)
end

---Creates a query which matches the specified item filter.
---@param itemFilter ItemFilter The item filter
---@param query? DatabaseQuery Optionally, an existing query to reset and reuse
---@return DatabaseQuery
function ItemInfo.MatchItemFilterQuery(itemFilter, query)
	if query then
		query:Reset()
	else
		query = private.cache:NewQuery()
	end

	local str = itemFilter:GetStr()
	if str then
		if itemFilter:GetExactOnly() then
			query:Equal("name", str)
		else
			query:Contains("name", str)
		end
	end
	local minQuality = itemFilter:GetMinQuality()
	if minQuality then
		query:GreaterThanOrEqual("quality", minQuality)
	end
	local maxQuality = itemFilter:GetMaxQuality()
	if maxQuality then
		query:LessThanOrEqual("quality", maxQuality)
	end
	local minLevel = itemFilter:GetMinLevel()
	if minLevel then
		query:GreaterThanOrEqual("minLevel", minLevel)
	end
	local maxLevel = itemFilter:GetMaxLevel()
	if maxLevel then
		query:LessThanOrEqual("minLevel", maxLevel)
	end
	local minItemLevel = itemFilter:GetMinItemLevel()
	if minItemLevel then
		query:GreaterThanOrEqual("itemLevel", minItemLevel)
	end
	local maxItemLevel = itemFilter:GetMaxItemLevel()
	if maxItemLevel then
		query:LessThanOrEqual("itemLevel", maxItemLevel)
	end
	local classId = itemFilter:GetClass()
	if classId then
		query:Equal("classId", classId)
	end
	local subClassId = itemFilter:GetSubClass()
	if subClassId then
		query:Equal("subClassId", subClassId)
	end
	local invSlotId = itemFilter:GetInvSlotId()
	if invSlotId then
		query:Equal("invSlotId", invSlotId)
	end

	return query
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.GetFieldValueHelper(itemString, field, baseIsSame, storeBaseValue, petDefaultValue)
	local value = private.cache:GetField(itemString, field)
	if value ~= nil then
		return value
	end
	ItemInfo.FetchInfo(itemString)
	if ItemString.IsPet(itemString) then
		-- We can fetch info instantly for pets so try again
		value = private.cache:GetField(itemString, field)
		if value == nil and petDefaultValue ~= nil then
			value = petDefaultValue
			private.DeferSetSingleField(itemString, field, value)
		end
	end
	if value == nil and baseIsSame then
		-- The value is the same for the base item
		local baseItemString = ItemString.GetBase(itemString)
		if baseItemString ~= itemString then
			value = private.GetFieldValueHelper(baseItemString, field)
			if value ~= nil and storeBaseValue then
				private.DeferSetSingleField(itemString, field, value)
			end
		end
	end
	return value
end

function private.ProcessPendingItemInfo(itemString)
	local name = private.cache:GetField(itemString, "name")
	local quality = private.cache:GetField(itemString, "quality")
	local itemLevel = private.cache:GetField(itemString, "itemLevel")
	if (private.numRequests[itemString] or 0) > MAX_REQUESTS_PER_ITEM then
		-- Give up on this item
		if private.numRequests[itemString] ~= math.huge then
			private.numRequests[itemString] = math.huge
			local itemId = ItemString.IsItem(itemString) and ItemString.ToId(itemString) or nil
			if LibTSMService.IsRetail() then
				Log.Err("Giving up on item info for %s", itemString)
			end
			if itemId and itemString == ItemString.GetBaseFast(itemString) then
				private.numRequests[itemId] = math.huge
			end
		end
		private.pendingItems[itemString] = nil
		private.priorityPendingItems[itemString] = nil
	elseif name and name ~= "" and quality and quality >= 0 and itemLevel and itemLevel >= 0 then
		-- We have info for this item
		private.pendingItems[itemString] = nil
		private.priorityPendingItems[itemString] = nil
		private.numRequests[itemString] = nil
	else
		-- Request info for this item
		if not private.StoreGetItemInfo(itemString) then
			private.numRequests[itemString] = (private.numRequests[itemString] or 0) + 1
			return true
		end
	end
	return false
end

function private.ProcessItemInfo()
	private.processInfoTimer:RunForTime(ITEM_INFO_INTERVAL)
	if ClientInfo.IsInCombat() then
		return
	end
	local startTime = LibTSMService.GetTime()
	private.cache:SetQueryUpdatesPaused(true)

	-- Create rows for items which don't exist at all in the DB in bulk
	local newItems = TempTable.Acquire()
	for itemString, state in pairs(private.pendingItems) do
		if state == PENDING_STATE.NEW then
			newItems[itemString] = true
			private.pendingItems[itemString] = PENDING_STATE.CREATED
		end
	end
	private.cache:BulkPrepareRows(newItems, true)
	TempTable.Release(newItems)

	-- Get the pending items
	local priorityPendingItems = TempTable.Acquire()
	local pendingItems = TempTable.Acquire()
	for itemString in pairs(private.pendingItems) do
		if private.priorityPendingItems[itemString] then
			tinsert(priorityPendingItems, itemString)
		else
			tinsert(pendingItems, itemString)
		end
	end

	-- Throttle the max number of item info requests based on the frame rate
	local framerate = ClientInfo.GetFrameRate()
	local maxRequests = nil
	if framerate < 30 then
		maxRequests = MAX_REQUESTED_ITEM_INFO / 5
	elseif framerate < 60 then
		maxRequests = MAX_REQUESTED_ITEM_INFO / 3
	elseif framerate < 100 then
		maxRequests = MAX_REQUESTED_ITEM_INFO / 2
	else
		maxRequests = MAX_REQUESTED_ITEM_INFO
	end

	local shouldStop = false
	local numRequested = 0
	-- Do the priority items first
	for i = 1, #priorityPendingItems do
		if private.ProcessPendingItemInfo(priorityPendingItems[i]) then
			numRequested = numRequested + 1
			if numRequested >= maxRequests then
				shouldStop = true
				break
			end
		end
		if (LibTSMService.GetTime() - startTime) > ITEM_INFO_INTERVAL / 5 and numRequested >= maxRequests / 2 then
			-- Bail early since we've already used a good number of CPU cycles this frame
			shouldStop = true
			break
		end
	end
	if not shouldStop then
		for i = 1, #pendingItems do
			if private.ProcessPendingItemInfo(pendingItems[i]) then
				numRequested = numRequested + 1
				if numRequested >= maxRequests then
					shouldStop = true
					break
				end
			end
			if (LibTSMService.GetTime() - startTime) > ITEM_INFO_INTERVAL / 5 and numRequested >= maxRequests / 2 then
				-- Bail early since we've already used a good number of CPU cycles this frame
				shouldStop = true
				break
			end
		end
	end
	if #pendingItems > 0 and LibTSMService.GetTime() - private.lastDebugLog > 5 then
		private.lastDebugLog = LibTSMService.GetTime()
		Log.Info("%d/%d pending items (just requested %d)", #pendingItems, #priorityPendingItems, numRequested)
	end
	TempTable.Release(pendingItems)
	TempTable.Release(priorityPendingItems)

	if private.rebuildStage == REBUILD_STAGE.IDLE and numRequested >= maxRequests / 2 and Table.Count(private.pendingItems) >= REBUILD_MSG_THRESHOLD then
		private.rebuildStage = REBUILD_STAGE.TRIGGERED
		-- Delay this message to make it more likely to be seen and make sure we're actually rebuilding
		local timer = DelayTimer.New("ITEM_INFO_REBUILD_MESSAGE", private.ShowRebuildMessage)
		timer:RunForTime(1)
	end
	if not next(private.pendingItems) then
		if private.rebuildStage == REBUILD_STAGE.NOTIFIED then
			private.rebuildCallback(true)
			private.rebuildStage = REBUILD_STAGE.IDLE
		end
		private.processInfoTimer:Cancel()
	end

	private.cache:SetQueryUpdatesPaused(false)
end

function private.ShowRebuildMessage()
	if Table.Count(private.pendingItems) < REBUILD_MSG_THRESHOLD then
		-- no longer rebuilding
		private.rebuildStage = REBUILD_STAGE.IDLE
		return
	end
	private.rebuildCallback(false)
	private.rebuildStage = REBUILD_STAGE.NOTIFIED
end

function private.DeferSetSingleField(itemString, key, value)
	if type(value) == "boolean" then
		value = value and 1 or 0
	end
	if key ~= "name" then
		ItemInfoCache.CheckFieldValue(key, value)
	end
	Table.InsertMultiple(private.deferredSetSingleField, itemString, key, value)
	private.deferredSetSingleFieldTimer:RunForFrames(0)
end

function private.HandleDeferredSetSingleField()
	for _, itemString, key, value in Table.StrideIterator(private.deferredSetSingleField, 3) do
		private.cache:UpdateField(itemString, key, value)
	end
end

function private.StoreGetItemInfoInstant(itemString)
	local itemStringType, id, extra1, extra2 = strmatch(itemString, "^([pi]):([0-9]+):?([0-9]*):?([0-9]*)")
	id = tonumber(id)
	if private.cache:GetField(itemString, "texture") and private.cache:GetField(itemString, "invSlotId") then
		-- we already have info cached for this item
		return
	end
	if itemStringType == "p" then
		extra1 = tonumber(strmatch(extra1, "i(%d+)") or extra1)
	else
		extra1 = tonumber(extra1)
	end
	extra2 = tonumber(extra2)

	if itemStringType == "i" then
		local texture, classId, subClassId, invSlotId = Item.GetInfoInstant(id)
		if not texture then
			return
		end
		private.cache:SetPreloadedFields(itemString, texture, classId, subClassId, invSlotId)
	elseif itemStringType == "p" then
		if not ClientInfo.HasFeature(ClientInfo.FEATURES.BATTLE_PETS) then
			return
		end
		local name, texture, petTypeId = Item.GetPetInfo(id)
		if not texture then
			return
		end
		-- We can now store all the info for this pet
		local classId = ItemClass.GetPetClassId()
		local subClassId = petTypeId - 1
		local invSlotId = 0
		local minLevel = extra1 or 0
		local itemLevel = extra1 or 0
		local quality = extra2 or 0
		local maxStack = 1
		local vendorSell = 0
		local isBOP = 0
		local isCraftingReagent = 0
		local expansionId = -1
		local craftedQuality = -1
		private.cache:SetAllFields(itemString, texture, classId, subClassId, invSlotId, name, minLevel, itemLevel, maxStack, vendorSell, quality, isBOP, isCraftingReagent, expansionId, craftedQuality)
		local baseItemString = ItemString.GetBase(itemString)
		if baseItemString ~= itemString then
			minLevel = 0
			itemLevel = 0
			quality = 0
			private.cache:SetAllFields(baseItemString, texture, classId, subClassId, invSlotId, name, minLevel, itemLevel, maxStack, vendorSell, quality, isBOP, isCraftingReagent, expansionId, craftedQuality)
		end
	else
		assert("Invalid itemString: "..itemString)
	end
end

function private.StoreGetItemInfo(itemString)
	private.StoreGetItemInfoInstant(itemString)
	assert(ItemString.IsItem(itemString))
	local wowItemString = private.ToWowItemString(itemString)
	local baseItemString = ItemString.GetBase(itemString)
	local baseWowItemString = private.ToWowItemString(baseItemString)

	local name, link, quality, itemLevel, minLevel, maxStack, vendorSell, isBOP, expansionId, isCraftingReagent = Item.GetInfo(baseWowItemString)
	if NON_VENDORABLE_ITEMS[baseItemString] then
		vendorSell = 0
	end
	local craftedQuality = nil
	if not ClientInfo.HasFeature(ClientInfo.FEATURES.CRAFTING_QUALITY) then
		expansionId = -1
		craftedQuality = -1
	elseif link then
		craftedQuality = strmatch(link, "\124A:Professions%-ChatIcon%-Quality%-Tier([0-9]+)")
		craftedQuality = tonumber(craftedQuality) or -1
	end
	isCraftingReagent = isCraftingReagent and 1 or 0

	-- Store info for the base item
	if name and quality and craftedQuality then
		private.cache:SetQueriedFields(baseItemString, name, minLevel, itemLevel, maxStack, vendorSell, quality, isBOP, isCraftingReagent, expansionId, craftedQuality)
	end
	local gotInfo = true
	if not name or name == "" or not quality or quality < 0 or not itemLevel or itemLevel < 0 or not craftedQuality then
		gotInfo = false
	end

	-- Store info for the specific item if it's different
	if itemString ~= baseItemString then
		-- Get new values of the fields which can change from the base item
		local baseVendorSell = vendorSell
		local _
		name, _, quality, _, minLevel, _, vendorSell = Item.GetInfo(wowItemString)
		-- Some items (i.e. "i:130064::2:196:1812") produce a negative vendor sell, so just use the base one
		if vendorSell and vendorSell < 0 then
			vendorSell = baseVendorSell
		end
		itemLevel = Item.GetDetailedItemLevel(wowItemString)
		if name or quality or itemLevel or maxStack then
			if not name then
				name = ""
				minLevel = -1
			end
			quality = quality or -1
			itemLevel = itemLevel or -1
			expansionId = expansionId or -1
			if not maxStack then
				maxStack = -1
				vendorSell = -1
				isBOP = -1
				isCraftingReagent = -1
			end
			craftedQuality = -1
			private.cache:SetQueriedFields(itemString, name, minLevel, itemLevel, maxStack, vendorSell, quality, isBOP, isCraftingReagent, expansionId, craftedQuality)
		end
		if not name or name == "" or not quality or quality < 0 or not itemLevel or itemLevel < 0 then
			gotInfo = false
		end
	end

	return gotInfo
end

function private.ProcessAvailableItems()
	private.cache:SetQueryUpdatesPaused(true)

	-- Bulk insert items we didn't previously know about
	private.cache:BulkPrepareRows(private.availableItems)

	-- Remove the items we process after processing them all because GET_ITEM_INFO_RECEIVED events may fire as we do this
	local processedItems = TempTable.Acquire()
	for itemString in pairs(private.availableItems) do
		processedItems[itemString] = true
		if private.StoreGetItemInfo(itemString) then
			private.pendingItems[itemString] = nil
			private.priorityPendingItems[itemString] = nil
		end
	end
	for itemString in pairs(processedItems) do
		private.availableItems[itemString] = nil
	end
	TempTable.Release(processedItems)

	private.cache:SetQueryUpdatesPaused(false)
end

function private.GetDBVersionStr()
	local buildVersion, buildNum = ClientInfo.GetBuildInfo()
	return strjoin(",", DB_VERSION, ClientInfo.GetLocale(), buildVersion, buildNum)
end

function private.ToWowItemString(itemString)
	local itemStringLevel, isAbsItemStringLevel = ItemString.ParseLevel(itemString)
	local itemId, rand, extraPart = nil, nil, nil
	if itemStringLevel then
		itemId, rand = select(2, strsplit(":", itemString))
		extraPart = BonusIds.GetBonusStringForLevel(itemStringLevel, isAbsItemStringLevel)
	else
		local _, extra = nil, nil
		itemId, rand, extra = select(2, strsplit(":", itemString))
		extraPart = extra and strmatch(itemString, "i:[0-9]+:[0-9%-]*:(.+)") or ""
	end
	local level = CharacterInfo.GetLevel()
	local spec = CharacterInfo.GetSpecializationId() or ""
	return "item:"..itemId.."::::::"..(rand or "").."::"..level..":"..spec..":::"..extraPart..":::"
end
