-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Item Info Functions
-- @module ItemInfo

local _, TSM = ...
local ItemInfo = TSM.Init("Service.ItemInfo")
local L = TSM.Include("Locale").GetTable()
local ItemClass = TSM.Include("Data.ItemClass")
local VendorSell = TSM.Include("Data.VendorSell")
local ItemString = TSM.Include("Util.ItemString")
local Database = TSM.Include("Util.Database")
local Event = TSM.Include("Util.Event")
local Delay = TSM.Include("Util.Delay")
local TempTable = TSM.Include("Util.TempTable")
local Math = TSM.Include("Util.Math")
local String = TSM.Include("Util.String")
local Log = TSM.Include("Util.Log")
local Settings = TSM.Include("Service.Settings")
local private = {
	db = nil,
	pendingItems = {},
	numRequests = {},
	availableItems = {},
	isRebuilding = false,
	settings = nil,
}
local UNKNOWN_ITEM_ITEMSTRING = "i:0"
local ITEM_MAX_ID = 999999
local SEP_CHAR = "\002"
local ITEM_INFO_INTERVAL = 0.05
local MAX_REQUESTED_ITEM_INFO = 50
local MAX_REQUESTS_PER_ITEM = 5
local UNKNOWN_ITEM_NAME = L["Unknown Item"]
local DB_VERSION = 5
local RECORD_DATA_LENGTH = 17
local FIELD_LENGTH_BITS = {
	itemLevel = 16,
	minLevel = 8,
	maxStack = 16,
	vendorSell = 32,
	invSlotId = 8,
	texture = 32,
	classId = 8,
	subClassId = 8,
	quality = 4,
	isBOP = 2,
	isCraftingReagent = 2,
}
local PENDING_STATE_NEW = 1
local PENDING_STATE_CREATED = 2
do
	local totalLength = 0
	for _, length in pairs(FIELD_LENGTH_BITS) do
		totalLength = totalLength + length
	end
	assert(totalLength == RECORD_DATA_LENGTH * 8)
end
local ITEM_QUALITY_BY_HEX_LOOKUP = {}
for quality, info in pairs(ITEM_QUALITY_COLORS) do
	ITEM_QUALITY_BY_HEX_LOOKUP[info.hex] = quality
end
-- URLs for non-disenchantable items:
-- 	http://www.wowhead.com/items=2?filter=qu=2%3A3%3A4%3Bcr=8%3A2%3Bcrs=2%3A2%3Bcrv=0%3A0
-- 	http://www.wowhead.com/items=4?filter=qu=2%3A3%3A4%3Bcr=8%3A2%3Bcrs=2%3A2%3Bcrv=0%3A0
local NON_DISENCHANTABLE_ITEMS = {
	["i:11290"] = true,
	["i:11289"] = true,
	["i:11288"] = true,
	["i:11287"] = true,
	["i:60223"] = true,
	["i:52252"] = true,
	["i:20406"] = true,
	["i:20407"] = true,
	["i:20408"] = true,
	["i:21766"] = true,
	["i:52485"] = true,
	["i:52486"] = true,
	["i:52487"] = true,
	["i:52488"] = true,
	["i:75274"] = true,
	["i:97826"] = true,
	["i:97827"] = true,
	["i:97828"] = true,
	["i:97829"] = true,
	["i:97830"] = true,
	["i:97831"] = true,
	["i:97832"] = true,
	["i:109262"] = true,
}



-- ============================================================================
-- Module Loading
-- ============================================================================

ItemInfo:OnSettingsLoad(function()
	private.settings = Settings.NewView()
		:AddKey("global", "internalData", "vendorItems")

	Event.Register("GET_ITEM_INFO_RECEIVED", function(_, itemId, success)
		if not success or itemId <= 0 or itemId > ITEM_MAX_ID or private.numRequests[itemId] == math.huge then
			return
		end
		private.availableItems[itemId] = true
		Delay.AfterFrame("ITEM_INFO_DELAY", 0, private.ProcessAvailableItems)
	end)

	-- load the item info database
	local build, revision = GetBuildInfo()
	if not TSMItemInfoDB or #TSMItemInfoDB.data % RECORD_DATA_LENGTH ~= 0 or TSMItemInfoDB.version ~= DB_VERSION or TSMItemInfoDB.locale ~= GetLocale() or TSMItemInfoDB.build ~= build or TSMItemInfoDB.revision ~= revision then
		private.isRebuilding = true
		TSMItemInfoDB = {
			names = nil,
			itemStrings = nil,
			data = "",
		}
		wipe(private.settings.vendorItems)
		-- delay this message to make it more likely to be seen
		Delay.AfterTime(3, function()
			Log.PrintUser(L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."])
		end)
	end

	-- load hard-coded vendor costs
	for itemString, cost in VendorSell.Iterator() do
		private.settings.vendorItems[itemString] = private.settings.vendorItems[itemString] or cost
	end

	local names = TSMItemInfoDB.names and String.SafeSplit(TSMItemInfoDB.names, SEP_CHAR) or {}
	local itemStrings = TSMItemInfoDB.itemStrings and String.SafeSplit(TSMItemInfoDB.itemStrings, SEP_CHAR) or {}
	assert(#itemStrings == #names)
	local numItemsLoaded = #names
	Log.Info("Imported %d items worth of data", numItemsLoaded)

	-- The following code for populating our database is highly optimized as we're processing an excessive amount of data here
	private.db = Database.NewSchema("ITEM_INFO")
		:AddUniqueStringField("itemString")
		:AddStringField("name")
		:AddNumberField("itemLevel")
		:AddNumberField("minLevel")
		:AddNumberField("maxStack")
		:AddNumberField("vendorSell")
		:AddNumberField("invSlotId")
		:AddNumberField("texture")
		:AddNumberField("classId")
		:AddNumberField("subClassId")
		:AddNumberField("quality")
		:AddNumberField("isBOP")
		:AddNumberField("isCraftingReagent")
		:Commit()
	private.db:BulkInsertStart()
	for i = 1, numItemsLoaded do
		local itemString = itemStrings[i]
		local name = names[i]
		-- decode all the fields
		local dataOffset = (i - 1) * RECORD_DATA_LENGTH + 1
		local b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16 = strbyte(TSMItemInfoDB.data, dataOffset, dataOffset + RECORD_DATA_LENGTH - 1)
		local itemLevel = (b0 == 0xff and b1 == 0xff) and -1 or (b0 + b1 * 256)
		local minLevel = (b2 == 0xff) and -1 or b2
		local maxStack = (b3 == 0xff and b4 == 0xff) and -1 or (b3 + b4 * 256)
		local vendorSell = (b5 == 0xff and b6 == 0xff and b7 == 0xff and b8 == 0xff) and -1 or (b5 + b6 * 256 + b7 * 65536 + b8 * 16777216)
		local invSlotId = (b10 == 0xff) and -1 or b10
		local texture = (b11 == 0xff and b12 == 0xff and b13 == 0xff and b14 == 0xff) and -1 or (b11 + b12 * 256 + b13 * 65536 + b14 * 16777216)
		local classId = (b15 == 0xff) and -1 or b15
		local subClassId = (b16 == 0xff) and -1 or b16
		local quality = b9 % 0x10
		b9 = (b9 - quality) / 0x10
		quality = quality == 0xf and -1 or quality
		local isBOP = b9 % 0x4
		b9 = (b9 - isBOP) / 0x4
		isBOP = isBOP == 0x3 and -1 or isBOP
		local isCraftingReagent = b9 % 0x4
		isCraftingReagent = isCraftingReagent == 0x3 and -1 or isCraftingReagent
		-- store in the DB
		private.db:BulkInsertNewRow(itemString, name, itemLevel, minLevel, maxStack, vendorSell, invSlotId, texture, classId, subClassId, quality, isBOP, isCraftingReagent)
	end
	private.db:BulkInsertEnd()

	-- process pending item info every 0.05 seconds
	Delay.AfterTime("processItemInfo", 0, private.ProcessItemInfo, ITEM_INFO_INTERVAL)
	-- scan the merchant when the goods are shown
	Event.Register("MERCHANT_SHOW", private.ScanMerchant)
	Event.Register("MERCHANT_UPDATE", private.UpdateMerchant)
end)

ItemInfo:OnModuleUnload(function()
	-- save the DB
	if not TSMItemInfoDB then
		-- bailing if TSMItemInfoDB doesn't exist gives us an easy way to wipe the DB via "/run TSMItemInfoDB = nil"
		return
	end
	local names = {}
	local itemStrings = {}
	local dataParts = {}
	local rawData = private.db:GetRawData()
	local numFields = private.db:GetNumStoredFields()
	for i = 1, private.db:GetNumRows() do
		local startOffset = (i - 1) * numFields + 1
		local itemString, name, itemLevel, minLevel, maxStack, vendorSell, invSlotId, texture, classId, subClassId, quality, isBOP, isCraftingReagent = unpack(rawData, startOffset, startOffset + numFields - 1)
		itemLevel = itemLevel == -1 and 0xffff or itemLevel
		minLevel = minLevel == -1 and 0xff or minLevel
		maxStack = maxStack == -1 and 0xffff or maxStack
		vendorSell = vendorSell == -1 and 0xffffffff or vendorSell
		invSlotId = invSlotId == -1 and 0xff or invSlotId
		texture = texture == -1 and 0xffffffff or texture
		classId = classId == -1 and 0xff or classId
		subClassId = subClassId == -1 and 0xff or subClassId
		quality = quality == -1 and 0xf or quality
		isBOP = isBOP == -1 and 0x3 or isBOP
		isCraftingReagent = isCraftingReagent == -1 and 0x3 or isCraftingReagent
		local bitfield = quality + isBOP * 16 + isCraftingReagent * 64

		names[i] = name
		itemStrings[i] = itemString
		dataParts[i] = strchar(itemLevel % 256, itemLevel / 256, minLevel, maxStack % 256, maxStack / 256, vendorSell % 256, (vendorSell % 65536) / 256, (vendorSell % 16777216) / 65536, vendorSell / 16777216, bitfield, invSlotId, texture % 256, (texture % 65536) / 256, (texture % 16777216) / 65536, texture / 16777216, classId, subClassId)

		if #dataParts[i] ~= RECORD_DATA_LENGTH then
			names[i] = nil
			itemStrings[i] = nil
			dataParts[i] = nil
		end
	end
	TSMItemInfoDB.names = #names > 0 and table.concat(names, SEP_CHAR) or nil
	TSMItemInfoDB.itemStrings = #itemStrings > 0 and table.concat(itemStrings, SEP_CHAR) or nil
	TSMItemInfoDB.data = table.concat(dataParts)

	if #TSMItemInfoDB.data % RECORD_DATA_LENGTH ~= 0 then
		TSMItemInfoDB = nil
		return
	end

	local build, revision = GetBuildInfo()
	TSMItemInfoDB.version = DB_VERSION
	TSMItemInfoDB.locale = GetLocale()
	TSMItemInfoDB.build = build
	TSMItemInfoDB.revision = revision
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Store the name of an item.
-- This function is used to opportunistically populate the item cache with item names.
-- @tparam string itemString The itemString
-- @tparam string name The item name
function ItemInfo.StoreItemName(itemString, name)
	private.SetSingleField(itemString, "name", name)
end

--- Store information about an item from its link.
-- This function is used to opportunistically populate the item cache with item info.
-- @tparam string itemLink The item link
function ItemInfo.StoreItemInfoByLink(itemLink)
	-- see if we can extract the quality and name from the link
	local colorHex, name = strmatch(itemLink, "^(\124cff[0-9a-z]+)\124[Hh].+\124h%[(.+)%]\124h\124r$")
	if name == "" or name == UNKNOWN_ITEM_NAME then
		name = nil
	end
	local quality = ITEM_QUALITY_BY_HEX_LOOKUP[colorHex]
	local itemString = ItemString.Get(itemLink)
	if not itemString then
		return
	end
	if name then
		private.SetSingleField(itemString, "name", name)
	end
	if quality then
		private.SetSingleField(itemString, "quality", quality)
	end
end

--- Get the itemString from an item name.
-- This API will return the base itemString when there are multiple variants with the same name and will return nil if
-- there are multiple distinct items with the same name.
-- @tparam string name The item name
-- @treturn ?string The itemString
function ItemInfo.ItemNameToItemString(name)
	local result = nil
	local query = private.db:NewQuery()
		:Select("itemString")
		:Equal("name", name)
	for _, itemString in query:Iterator() do
		if not result then
			result = itemString
		elseif result ~= UNKNOWN_ITEM_ITEMSTRING then
			-- multiple matching items
			if ItemString.GetBase(itemString) == ItemString.GetBase(result) then
				result = ItemString.GetBase(itemString)
			else
				result = UNKNOWN_ITEM_ITEMSTRING
			end
		end
	end
	query:Release()
	return result
end

function ItemInfo.GetDBForJoin()
	return private.db
end

--- Get the name.
-- @tparam string item The item
-- @treturn ?string The name
function ItemInfo.GetName(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	if itemString == UNKNOWN_ITEM_ITEMSTRING then
		return UNKNOWN_ITEM_NAME
	end
	local name = private.GetField(itemString, "name")
	if not name then
		-- we can fetch info instantly for pets, so try again afterwards
		ItemInfo.FetchInfo(itemString)
		name = private.GetField(itemString, "name")
	end
	if not name then
		-- if we got passed an item link, we can maybe extract the name from it
		name = strmatch(item, "^\124cff[0-9a-z]+\124[Hh].+\124h%[(.+)%]\124h\124r$")
		if name == "" or name == UNKNOWN_ITEM_NAME then
			name = nil
		end
		if name then
			private.SetSingleField(itemString, "name", name)
		end
	end
	return name
end

--- Get the link.
-- @tparam string item The item
-- @treturn string The link or an "Unknown Item" link
function ItemInfo.GetLink(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	local link = nil
	local itemStringType, speciesId, level, quality, health, power, speed, petId = strsplit(":", itemString)
	if itemStringType == "p" then
		local name = ItemInfo.GetName(item) or UNKNOWN_ITEM_NAME
		local fullItemString = strjoin(":", speciesId, level or "", quality or "", health or "", power or "", speed or "", petId or "")
		quality = tonumber(quality) or 0
		local qualityColor = ITEM_QUALITY_COLORS[quality] and ITEM_QUALITY_COLORS[quality].hex or "|cffff0000"
		link = qualityColor.."|Hbattlepet:"..fullItemString.."|h["..name.."]|h|r"
	else
		local name = ItemInfo.GetName(item) or UNKNOWN_ITEM_NAME
		quality = ItemInfo.GetQuality(item)
		local qualityColor = ITEM_QUALITY_COLORS[quality] and ITEM_QUALITY_COLORS[quality].hex or "|cffff0000"
		link = qualityColor.."|H"..ItemString.ToWow(itemString).."|h["..name.."]|h|r"
	end
	return link
end

--- Get the quality.
-- @tparam string item The item
-- @treturn ?number The quality
function ItemInfo.GetQuality(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
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
		if classId and classId ~= LE_ITEM_CLASS_WEAPON and classId ~= LE_ITEM_CLASS_ARMOR then
			-- the bonusId does not affect the quality of this item
			quality = ItemInfo.GetQuality(ItemString.GetBase(itemString))
		end
	end
	if quality then
		private.SetSingleField(itemString, "quality", quality)
	end
	return quality
end

--- Get the quality color.
-- @tparam string item The item
-- @treturn ?string The quality color string
function ItemInfo.GetQualityColor(item)
	local itemString = ItemString.Get(item)
	local quality = ItemInfo.GetQuality(itemString)
	return ITEM_QUALITY_COLORS[quality] and ITEM_QUALITY_COLORS[quality].hex
end

--- Get the item level.
-- @tparam string item The item
-- @treturn ?number The item level
function ItemInfo.GetItemLevel(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	local itemLevel = private.GetField(itemString, "itemLevel")
	if itemLevel then
		return itemLevel
	end
	local itemType, _, randOrLevel, bonusOrQuality = strsplit(":", itemString)
	randOrLevel = tonumber(randOrLevel)
	bonusOrQuality = tonumber(bonusOrQuality)
	if itemType == "p" then
		-- we can fetch info instantly for pets so try again
		ItemInfo.FetchInfo(itemString)
		itemLevel = private.GetField(itemString, "itemLevel")
		if not itemLevel then
			-- just get the level from the item string
			itemLevel = randOrLevel or 0
			private.SetSingleField(itemString, "itemLevel", itemLevel)
		end
	elseif itemType == "i" then
		if randOrLevel and not bonusOrQuality then
			-- there is a random enchant, but no bonusIds, so the itemLevel is the same as the base item
			itemLevel = ItemInfo.GetItemLevel(ItemString.GetBase(itemString))
		end
		if itemLevel then
			private.SetSingleField(itemString, "itemLevel", itemLevel)
		end
		ItemInfo.FetchInfo(itemString)
	else
		error("Invalid item: "..tostring(itemString))
	end
	return itemLevel
end

--- Get the min level.
-- @tparam string item The item
-- @treturn ?number The min level
function ItemInfo.GetMinLevel(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	-- if there is a random enchant, but no bonusIds, so the itemLevel is the same as the base item
	local baseIsSame = strmatch(itemString, "^i:[0-9]+:[%-0-9]+$") and true or false
	local minLevel = private.GetFieldValueHelper(itemString, "minLevel", baseIsSame, true, 0)
	if not minLevel and private.IsItem(itemString) then
		local baseItemString = ItemString.GetBase(itemString)
		local classId = ItemInfo.GetClassId(itemString)
		local subClassId = ItemInfo.GetSubClassId(itemString)
		if itemString ~= baseItemString and classId and subClassId and classId ~= LE_ITEM_CLASS_WEAPON and classId ~= LE_ITEM_CLASS_ARMOR and (classId ~= LE_ITEM_CLASS_GEM or subClassId ~= LE_ITEM_GEM_ARTIFACTRELIC) then
			-- the bonusId does not affect the minLevel of this item
			minLevel = ItemInfo.GetMinLevel(baseItemString)
			if minLevel then
				private.SetSingleField(itemString, "minLevel", minLevel)
			end
		end
	end
	return minLevel
end

--- Get the max stack size.
-- @tparam string item The item
-- @treturn ?number The max stack size
function ItemInfo.GetMaxStack(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	local maxStack = private.GetFieldValueHelper(itemString, "maxStack", true, true, 1)
	if not maxStack and private.IsItem(itemString) then
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
			private.SetSingleField(itemString, "maxStack", maxStack)
		end
	end
	return maxStack
end

--- Get the inventory slot id.
-- @tparam string item The item
-- @treturn ?number The inventory slot id
function ItemInfo.GetInvSlotId(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	local invSlotId = private.GetFieldValueHelper(itemString, "invSlotId", true, true, 0)
	return invSlotId
end

--- Get the texture.
-- @tparam string item The item
-- @treturn ?number The texture
function ItemInfo.GetTexture(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	local texture = private.GetFieldValueHelper(itemString, "texture", true, false, nil)
	if texture then
		return texture
	end
	private.StoreGetItemInfoInstant(itemString)
	return private.GetField(itemString, "texture")
end

--- Get the vendor sell price.
-- @tparam string item The item
-- @treturn ?number The vendor sell price
function ItemInfo.GetVendorSell(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	local vendorSell = private.GetFieldValueHelper(itemString, "vendorSell", false, false, 0)
	return (vendorSell or 0) > 0 and vendorSell or nil
end

--- Get the class id.
-- @tparam string item The item
-- @treturn ?number The class id
function ItemInfo.GetClassId(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	local classId = private.GetFieldValueHelper(itemString, "classId", true, true, LE_ITEM_CLASS_BATTLEPET)
	if classId then
		return classId
	end
	private.StoreGetItemInfoInstant(itemString)
	return private.GetField(itemString, "classId")
end

--- Get the sub-class id.
-- @tparam string item The item
-- @treturn ?number The sub-class id
function ItemInfo.GetSubClassId(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	local subClassId = private.GetFieldValueHelper(itemString, "subClassId", true, true, nil)
	if subClassId then
		return subClassId
	end
	private.StoreGetItemInfoInstant(itemString)
	return private.GetField(itemString, "subClassId")
end


--- Get whether or not the item is bind on pickup.
-- @tparam string item The item
-- @treturn boolean Whether or not the item is bind on pickup
function ItemInfo.IsSoulbound(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	local isBOP = private.GetFieldValueHelper(itemString, "isBOP", true, true, false)
	if type(isBOP) == "number" then
		isBOP = isBOP == 1
	end
	return isBOP
end

--- Get whether or not the item is a crafting reagent.
-- @tparam string item The item
-- @treturn boolean Whether or not the item is a crafting reagent
function ItemInfo.IsCraftingReagent(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	local isCraftingReagent = private.GetFieldValueHelper(itemString, "isCraftingReagent", true, true, false)
	if type(isCraftingReagent) == "number" then
		isCraftingReagent = isCraftingReagent == 1
	end
	return isCraftingReagent
end

--- Get the vendor buy price.
-- @tparam string item The item
-- @treturn ?number The vendor buy price
function ItemInfo.GetVendorBuy(item)
	local itemString = ItemString.Get(item)
	if not itemString then return end
	return private.settings.vendorItems[itemString]
end

--- Get whether or not the item is disenchantable.
-- @tparam string item The item
-- @treturn ?boolean Whether or not the item is disenchantable (nil means we don't know)
function ItemInfo.IsDisenchantable(item)
	local itemString = ItemString.Get(item)
	if not itemString or NON_DISENCHANTABLE_ITEMS[itemString] then
		return nil
	end
	local quality = ItemInfo.GetQuality(itemString)
	local classId = ItemInfo.GetClassId(itemString)
	if not quality or not classId then
		return nil
	end
	return quality >= LE_ITEM_QUALITY_UNCOMMON and (classId == LE_ITEM_CLASS_ARMOR or classId == LE_ITEM_CLASS_WEAPON)
end

--- Fetch info for the item.
-- This function can be called ahead of time for items which we know we need to have info cached for.
-- @tparam string item The item
function ItemInfo.FetchInfo(item)
	if item == UNKNOWN_ITEM_ITEMSTRING then return end
	local itemString = ItemString.Get(item)
	if not itemString then return end
	if private.IsPet(itemString) then
		if not private.GetField(itemString, "name") then
			private.StoreGetItemInfoInstant(itemString)
		end
		return
	end
	private.pendingItems[itemString] = PENDING_STATE_NEW

	Delay.AfterTime("processItemInfo", 0, private.ProcessItemInfo, ITEM_INFO_INTERVAL)
end

--- Generalize an item link.
-- @tparam string itemLink The item link
-- @treturn ?string The generalized link
function ItemInfo.GeneralizeLink(itemLink)
	local itemString = ItemString.Get(itemLink)
	if not itemString then return end
	if private.IsItem(itemString) and not strmatch(itemString, "i:[0-9]+:[0-9%-]*:[0-9]*") then
		-- swap out the itemString part of the link
		local leader, quality, _, name, trailer, trailer2, extra = ("\124"):split(itemLink)
		if trailer2 and not extra then
			return strjoin("\124", leader, quality, "H"..ItemString.ToWow(itemString), name, trailer, trailer2)
		end
	end
	return ItemInfo.GetLink(itemString)
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.IsPet(itemString)
	return strmatch(itemString, "^p:") and true or false
end

function private.IsItem(itemString)
	return strmatch(itemString, "^i:") and true or false
end

function private.GetFieldValueHelper(itemString, field, baseIsSame, storeBaseValue, petDefaultValue)
	local value = private.GetField(itemString, field)
	if value ~= nil then
		return value
	end
	ItemInfo.FetchInfo(itemString)
	if private.IsPet(itemString) then
		-- we can fetch info instantly for pets so try again
		value = private.GetField(itemString, field)
		if value == nil and petDefaultValue ~= nil then
			value = petDefaultValue
			private.SetSingleField(itemString, field, value)
		end
	end
	if value == nil and baseIsSame then
		-- the value is the same for the base item
		local baseItemString = ItemString.GetBase(itemString)
		if baseItemString ~= itemString then
			value = private.GetFieldValueHelper(baseItemString, field)
			if value ~= nil and storeBaseValue then
				private.SetSingleField(itemString, field, value)
			end
		end
	end
	return value
end

function private.ProcessItemInfo()
	private.db:SetQueryUpdatesPaused(true)

	-- create rows for items which don't exist at all in the DB in bulk
	private.db:BulkInsertStart()
	for itemString, state in pairs(private.pendingItems) do
		if state == PENDING_STATE_NEW then
			local baseItemString = ItemString.GetBase(itemString)
			if not private.db:HasUniqueRow("itemString", itemString) then
				private.db:BulkInsertNewRow(itemString, "", -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1)
			end
			if baseItemString ~= itemString and not private.db:HasUniqueRow("itemString", baseItemString) then
				private.db:BulkInsertNewRow(baseItemString, "", -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1)
			end
			private.pendingItems[itemString] = PENDING_STATE_CREATED
		end
	end
	private.db:BulkInsertEnd()

	-- throttle the max number of item info requests based on the frame rate
	local framerate = GetFramerate()
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

	local toRemove = TempTable.Acquire()
	local numRequested = 0
	for itemString in pairs(private.pendingItems) do
		local name = private.GetField(itemString, "name")
		local quality = private.GetField(itemString, "quality")
		local itemLevel = private.GetField(itemString, "itemLevel")
		if (private.numRequests[itemString] or 0) > MAX_REQUESTS_PER_ITEM then
			-- give up on this item
			if private.numRequests[itemString] ~= math.huge then
				private.numRequests[itemString] = math.huge
				local itemId = ItemString.ToId(itemString)
				if not TSM.IsWowClassic() then
					Log.Err("Giving up on item info for %s", itemString)
				end
				if itemId then
					private.numRequests[itemId] = math.huge
				end
			end
			tinsert(toRemove, itemString)
		elseif name and name ~= "" and quality and quality >= 0 and itemLevel and itemLevel >= 0 then
			-- we have info for this item
			tinsert(toRemove, itemString)
			private.numRequests[itemString] = nil
		else
			-- request info for this item
			if not private.StoreGetItemInfo(itemString) then
				private.numRequests[itemString] = (private.numRequests[itemString] or 0) + 1
				numRequested = numRequested + 1
				if numRequested >= maxRequests then
					break
				end
			end
		end
	end
	for _, itemString in ipairs(toRemove) do
		private.pendingItems[itemString] = nil
	end
	TempTable.Release(toRemove)

	if not next(private.pendingItems) then
		if private.isRebuilding then
			Log.PrintUser(L["Done rebuilding item cache."])
			private.isRebuilding = nil
		end
		Delay.Cancel("processItemInfo")
	end

	private.db:SetQueryUpdatesPaused(false)
end

function private.ScanMerchant()
	for i = 1, GetMerchantNumItems() do
		local itemString = ItemString.Get(GetMerchantItemLink(i))
		if itemString then
			local _, _, price, quantity, _, _, _, extendedCost = GetMerchantItemInfo(i)
			-- bug with big keech vendor returning extendedCost = true for gold only items so need to check GetMerchantItemCostInfo
			if price > 0 and (not extendedCost or GetMerchantItemCostInfo(i) == 0) then
				private.settings.vendorItems[itemString] = Math.Round(price / quantity)
			else
				private.settings.vendorItems[itemString] = nil
			end
		end
	end
end

function private.UpdateMerchant()
	Delay.AfterTime(0.1, private.ScanMerchant)
end

function private.CheckFieldValue(key, value)
	if value == -1 then
		return
	end
	assert(value >= 0 and value < 2 ^ FIELD_LENGTH_BITS[key] - 1)
end

function private.GetField(itemString, key)
	local value = private.db:GetUniqueRowField("itemString", itemString, key)
	if value == -1 or value == "" then
		return nil
	end
	return value
end

function private.CreateDBRowIfNotExists(itemString)
	if private.db:HasUniqueRow("itemString", itemString) then
		return
	end
	private.db:NewRow()
		:SetField("itemString", itemString)
		:SetField("name", "")
		:SetField("minLevel", -1)
		:SetField("itemLevel", -1)
		:SetField("maxStack", -1)
		:SetField("vendorSell", -1)
		:SetField("quality", -1)
		:SetField("isBOP", -1)
		:SetField("isCraftingReagent", -1)
		:SetField("texture", -1)
		:SetField("classId", -1)
		:SetField("subClassId", -1)
		:SetField("invSlotId", -1)
		:Create()
end

function private.SetSingleField(itemString, key, value)
	if key ~= "name" then
		private.CheckFieldValue(key, value)
	end
	if type(value) == "boolean" then
		value = value and 1 or 0
	end
	if private.db:GetUniqueRowField("itemString", itemString, key) == value then
		-- no change
		return
	end
	private.CreateDBRowIfNotExists(itemString)
	private.db:SetUniqueRowField("itemString", itemString, key, value)
end

function private.SetItemInfoInstantFields(itemString, texture, classId, subClassId, invSlotId)
	private.CheckFieldValue("texture", texture)
	private.CheckFieldValue("classId", classId)
	private.CheckFieldValue("subClassId", subClassId)
	private.CheckFieldValue("invSlotId", invSlotId)
	private.CreateDBRowIfNotExists(itemString)
	private.db:SetUniqueRowField("itemString", itemString, "texture", texture)
	private.db:SetUniqueRowField("itemString", itemString, "classId", classId)
	private.db:SetUniqueRowField("itemString", itemString, "subClassId", subClassId)
	private.db:SetUniqueRowField("itemString", itemString, "invSlotId", invSlotId)
end

function private.StoreGetItemInfoInstant(itemString)
	local itemStringType, id, extra1, extra2 = strmatch(itemString, "^([pi]):([0-9]+):?([0-9]*):?([0-9]*)")
	id = tonumber(id)
	if private.GetField(itemString, "texture") then
		-- we already have info cached for this item
		return
	end
	extra1 = tonumber(extra1)
	extra2 = tonumber(extra2)

	if itemStringType == "i" then
		local _, classStr, subClassStr, equipSlot, texture, classId, subClassId = GetItemInfoInstant(id)
		equipSlot = equipSlot and equipSlot ~= "" and _G[equipSlot] or nil
		if not texture then
			return
		end
		-- some items (such as i:37445) give a classId of -1 for some reason in which case we can look up the classId
		if classId < 0 then
			classId = ItemClass.GetClassIdFromClassString(classStr)
			assert(subClassStr == "")
			subClassId = 0
		end
		local invSlotId = equipSlot and ItemClass.GetInventorySlotIdFromInventorySlotString(equipSlot) or 0
		private.SetItemInfoInstantFields(itemString, texture, classId, subClassId, invSlotId)
		local baseItemString = ItemString.GetBase(itemString)
		if baseItemString ~= itemString then
			private.SetItemInfoInstantFields(baseItemString, texture, classId, subClassId, invSlotId)
		end
	elseif itemStringType == "p" then
		if TSM.IsWowClassic() then
			return
		end
		local name, texture, petTypeId = C_PetJournal.GetPetInfoBySpeciesID(id)
		if not texture then
			return
		end
		-- we can now store all the info for this pet
		local classId = LE_ITEM_CLASS_BATTLEPET
		local subClassId = petTypeId - 1
		local invSlotId = 0
		local minLevel = 0
		local itemLevel = extra1 or 0
		local quality = extra2 or 0
		local maxStack = 1
		local vendorSell = 0
		local isBOP = 0
		local isCraftingReagent = 0
		private.SetItemInfoInstantFields(itemString, texture, classId, subClassId, invSlotId)
		private.SetGetItemInfoFields(itemString, name, minLevel, itemLevel, maxStack, vendorSell, quality, isBOP, isCraftingReagent)
		local baseItemString = ItemString.GetBase(itemString)
		if baseItemString ~= itemString then
			itemLevel = 0
			quality = 0
			private.SetItemInfoInstantFields(baseItemString, texture, classId, subClassId, invSlotId)
			private.SetGetItemInfoFields(baseItemString, name, minLevel, itemLevel, maxStack, vendorSell, quality, isBOP, isCraftingReagent)
		end
	else
		assert("Invalid itemString: "..itemString)
	end
end

function private.SetGetItemInfoFields(itemString, name, minLevel, itemLevel, maxStack, vendorSell, quality, isBOP, isCraftingReagent)
	private.CheckFieldValue("minLevel", minLevel)
	private.CheckFieldValue("itemLevel", itemLevel)
	private.CheckFieldValue("maxStack", maxStack)
	private.CheckFieldValue("vendorSell", vendorSell)
	private.CheckFieldValue("quality", quality)
	private.CheckFieldValue("isBOP", isBOP)
	private.CheckFieldValue("isCraftingReagent", isCraftingReagent)
	private.CreateDBRowIfNotExists(itemString)
	private.db:SetUniqueRowField("itemString", itemString, "name", name)
	private.db:SetUniqueRowField("itemString", itemString, "minLevel", minLevel)
	private.db:SetUniqueRowField("itemString", itemString, "itemLevel", itemLevel)
	private.db:SetUniqueRowField("itemString", itemString, "maxStack", maxStack)
	private.db:SetUniqueRowField("itemString", itemString, "vendorSell", vendorSell)
	private.db:SetUniqueRowField("itemString", itemString, "quality", quality)
	private.db:SetUniqueRowField("itemString", itemString, "isBOP", isBOP)
	private.db:SetUniqueRowField("itemString", itemString, "isCraftingReagent", isCraftingReagent)
end

function private.StoreGetItemInfo(itemString)
	private.StoreGetItemInfoInstant(itemString)
	assert(private.IsItem(itemString))
	local wowItemString = ItemString.ToWow(itemString)
	local baseItemString = ItemString.GetBase(itemString)
	local baseWowItemString = ItemString.ToWow(baseItemString)

	local name, _, quality, itemLevel, minLevel, _, _, maxStack, _, _, vendorSell, _, _, bindType, _, _, isCraftingReagent = GetItemInfo(baseWowItemString)
	local isBOP = (bindType == LE_ITEM_BIND_ON_ACQUIRE or bindType == LE_ITEM_BIND_QUEST) and 1 or 0
	isCraftingReagent = isCraftingReagent and 1 or 0
	-- some items (i.e. "i:40752" produce a very high max stack, so cap it)
	maxStack = maxStack and min(maxStack, 2 ^ FIELD_LENGTH_BITS.maxStack - 2) or nil
	-- some items (i.e. "i:117356::1:573") produce an negative min level
	minLevel = minLevel and max(minLevel, 0) or nil

	-- store info for the base item
	if name and quality then
		private.SetGetItemInfoFields(baseItemString, name, minLevel, itemLevel, maxStack, vendorSell, quality, isBOP, isCraftingReagent)
	end

	-- store info for the specific item if it's different
	if itemString ~= baseItemString then
		-- get new values of the fields which can change from the base item
		local baseVendorSell = vendorSell
		name, _, quality, _, minLevel, _, _, _, _, _, vendorSell = GetItemInfo(wowItemString)
		-- some items (i.e. "i:130064::2:196:1812") produce a negative vendor sell, so just use the base one
		if vendorSell and vendorSell < 0 then
			vendorSell = baseVendorSell
		end
		-- some items (i.e. "i:117356::1:573") produce an negative min level
		minLevel = minLevel and max(minLevel, 0) or nil
		itemLevel = GetDetailedItemLevelInfo(wowItemString)
		if name or quality or itemLevel or maxStack then
			if name then
				private.CheckFieldValue("minLevel", minLevel)
			else
				name = ""
				minLevel = -1
			end
			if quality then
				private.CheckFieldValue("quality", quality)
			else
				quality = -1
			end
			if itemLevel then
				private.CheckFieldValue("itemLevel", itemLevel)
			else
				itemLevel = -1
			end
			if maxStack then
				private.CheckFieldValue("maxStack", maxStack)
				private.CheckFieldValue("vendorSell", vendorSell)
				private.CheckFieldValue("isBOP", isBOP)
				private.CheckFieldValue("isCraftingReagent", isCraftingReagent)
			else
				maxStack = -1
				vendorSell = -1
				isBOP = -1
				isCraftingReagent = -1
			end
			private.SetGetItemInfoFields(itemString, name, minLevel, itemLevel, maxStack, vendorSell, quality, isBOP, isCraftingReagent)
		end
	end

	return name ~= nil
end

function private.ProcessAvailableItems()
	private.db:SetQueryUpdatesPaused(true)

	-- bulk insert items we didn't previously know about
	private.db:BulkInsertStart()
	for itemId in pairs(private.availableItems) do
		local itemString = "i:"..itemId
		if not private.db:HasUniqueRow("itemString", itemString) then
			private.db:BulkInsertNewRow(itemString, "", -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1)
		end
	end
	private.db:BulkInsertEnd()

	-- remove the items we process after processing them all because GET_ITEM_INFO_RECEIVED events may fire as we do this
	local processedItems = TempTable.Acquire()
	for itemId in pairs(private.availableItems) do
		processedItems[itemId] = true
		local itemString = "i:"..itemId
		if private.StoreGetItemInfo(itemString) then
			private.pendingItems[itemString] = nil
		end
	end
	for itemId in pairs(processedItems) do
		private.availableItems[itemId] = nil
	end
	TempTable.Release(processedItems)

	private.db:SetQueryUpdatesPaused(false)
end
