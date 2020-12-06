-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Item String functions
-- @module ItemString

local _, TSM = ...
local ItemString = TSM.Init("Util.ItemString")
local BonusIds = TSM.Include("Data.BonusIds")
local SmartMap = TSM.Include("Util.SmartMap")
local private = {
	filteredItemStringCache = {},
	itemStringCache = {},
	baseItemStringMap = nil,
	baseItemStringReader = nil,
	hasNonBaseItemStrings = {},
	bonusIdsTemp = {},
	modifiersTemp = {},
}
local ITEM_MAX_ID = 999999
local UNKNOWN_ITEM_STRING = "i:0"
local PLACEHOLDER_ITEM_STRING = "i:1"
local PET_CAGE_ITEM_STRING = "i:82800"
local MINIMUM_VARIANT_ITEM_ID = 152632
local IMPORTANT_MODIFIER_TYPES = {
	[9] = true,
	[28] = true,
	[29] = true,
	[30] = true,
}



-- ============================================================================
-- Module Loading
-- ============================================================================

ItemString:OnModuleLoad(function()
	private.baseItemStringMap = SmartMap.New("string", "string", private.ToBaseItemString)
	private.baseItemStringReader = private.baseItemStringMap:CreateReader()
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Gets the constant unknown item string for places where the itemString is not known.
-- @treturn string The itemString
function ItemString.GetUnknown()
	return UNKNOWN_ITEM_STRING
end

--- Gets the constant placeholder item string.
-- @treturn string The itemString
function ItemString.GetPlaceholder()
	return PLACEHOLDER_ITEM_STRING
end

--- Gets the battlepet cage item string.
-- @treturn string The itemString
function ItemString.GetPetCage()
	return PET_CAGE_ITEM_STRING
end

--- Gets the base itemString smart map.
-- @treturn SmartMap The smart map
function ItemString.GetBaseMap()
	return private.baseItemStringMap
end

--- Converts the parameter into an itemString.
-- @tparam ?number|string item Either an itemId, itemLink, or itemString to be converted
-- @treturn string The itemString
function ItemString.Get(item)
	if not item then
		return nil
	end
	if not private.itemStringCache[item] then
		private.itemStringCache[item] = private.ToItemString(item)
	end
	return private.itemStringCache[item]
end

function ItemString.Filter(itemString)
	if not private.filteredItemStringCache[itemString] then
		private.filteredItemStringCache[itemString] = private.FilterBonusIdsAndModifiers(itemString, true, strsplit(":", itemString))
	end
	return private.filteredItemStringCache[itemString]
end

--- Converts the parameter into an itemId.
-- @tparam string item An item to get the id of
-- @treturn number The itemId
function ItemString.ToId(item)
	local itemString = ItemString.Get(item)
	if type(itemString) ~= "string" then
		return
	end
	return tonumber(strmatch(itemString, "^[ip]:(%d+)"))
end

--- Converts the parameter into a base itemString.
-- @tparam string itemString An itemString to get the base itemString of
-- @treturn string The base itemString
function ItemString.GetBaseFast(itemString)
	if not itemString then
		return nil
	end
	return private.baseItemStringReader[itemString]
end

--- Converts the parameter into a base itemString.
-- @tparam string item An item to get the base itemString of
-- @treturn string The base itemString
function ItemString.GetBase(item)
	-- make sure it's a valid itemString
	local itemString = ItemString.Get(item)
	if not itemString then return end

	-- quickly return if we're certain it's already a valid baseItemString
	if type(itemString) == "string" and strmatch(itemString, "^[ip]:[0-9]+$") then return itemString end
	return ItemString.GetBaseFast(itemString)
end

--- Converts an itemKey from WoW into a base itemString.
-- @tparam table itemKey An itemKey to get the itemString of
-- @treturn string The base itemString
function ItemString.GetBaseFromItemKey(itemKey)
	if itemKey.battlePetSpeciesID > 0 then
		return "p:"..itemKey.battlePetSpeciesID
	else
		return "i:"..itemKey.itemID
	end
end

function ItemString.HasNonBase(baseItemString)
	return private.hasNonBaseItemStrings[baseItemString] or false
end

--- Converts the parameter into a WoW itemString.
-- @tparam string itemString An itemString to get the WoW itemString of
-- @treturn number The WoW itemString
function ItemString.ToWow(itemString)
	local _, itemId, rand, extra = strsplit(":", itemString)
	local level = UnitLevel("player")
	local spec = not TSM.IsWowClassic() and GetSpecialization() or nil
	spec = spec and GetSpecializationInfo(spec) or ""
	local extraPart = extra and strmatch(itemString, "i:[0-9]+:[0-9%-]*:(.+)") or ""
	return "item:"..itemId.."::::::"..(rand or "").."::"..level..":"..spec..":::"..extraPart..":::"
end

function ItemString.IsItem(itemString)
	return strmatch(itemString, "^i:[%-:0-9]+$") and true or false
end

function ItemString.IsPet(itemString)
	return strmatch(itemString, "^p:[%-:0-9]+$") and true or false
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.ToItemString(item)
	local paramType = type(item)
	if paramType == "string" then
		item = strtrim(item)
		local itemId = strmatch(item, "^[ip]:([0-9]+)$")
		if itemId then
			if tonumber(itemId) > ITEM_MAX_ID then
				return nil
			end
			-- this is already an itemString
			return item
		end
		itemId = strmatch(item, "item:(%d+)")
		if itemId and tonumber(itemId) > ITEM_MAX_ID then
			return nil
		end
	elseif paramType == "number" or tonumber(item) then
		local itemId = tonumber(item)
		if itemId > ITEM_MAX_ID then
			return nil
		end
		-- assume this is an itemId
		return "i:"..item
	else
		error("Invalid item parameter type: "..tostring(item))
	end

	-- test if it's already (likely) an item string or battle pet string
	if strmatch(item, "^i:([0-9%-:]+)$") then
		return private.FixItemString(item)
	elseif strmatch(item, "^p:([0-9:]+)$") then
		return private.FixPet(item)
	end

	local result = strmatch(item, "^\124cff[0-9a-z]+\124[Hh](.+)\124h%[.+%]\124h\124r$")
	if result then
		-- it was a full item link which we've extracted the itemString from
		item = result
	end

	-- test if it's an old style item string
	result = strjoin(":", strmatch(item, "^(i)tem:([0-9%-]+):[0-9%-]+:[0-9%-]+:[0-9%-]+:[0-9%-]+:[0-9%-]+:([0-9%-]+)$"))
	if result then
		return private.FixItemString(result)
	end

	-- test if it's an old style battle pet string (or if it was a link)
	result = strjoin(":", strmatch(item, "^battle(p)et:(%d+:%d+:%d+)"))
	if result then
		return private.FixPet(result)
	end
	result = strjoin(":", strmatch(item, "^battle(p)et:(%d+)[:]*$"))
	if result then
		return result
	end
	result = strjoin(":", strmatch(item, "^(p):(%d+:%d+:%d+)"))
	if result then
		return private.FixPet(result)
	end

	-- test if it's a long item string
	result = strjoin(":", strmatch(item, "(i)tem:([0-9%-]+):[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:([0-9%-]*):[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:([0-9%-:]+)"))
	if result and result ~= "" then
		return private.FixItemString(result)
	end

	-- test if it's a shorter item string (without bonuses)
	result = strjoin(":", strmatch(item, "(i)tem:([0-9%-]+):[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:([0-9%-]*)"))
	if result and result ~= "" then
		return result
	end
end

function private.RemoveExtra(itemString)
	local num = 1
	while num > 0 do
		itemString, num = gsub(itemString, ":0?$", "")
	end
	return itemString
end

function private.FixItemString(itemString)
	itemString = gsub(itemString, ":0:", "::") -- remove 0s which are in the middle
	itemString = private.RemoveExtra(itemString)
	return private.FilterBonusIdsAndModifiers(itemString, false, strsplit(":", itemString))
end

function private.FixPet(itemString)
	itemString = private.RemoveExtra(itemString)
	local result = strmatch(itemString, "^(p:%d+:%d+:%d+)$")
	if result then
		return result
	end
	return strmatch(itemString, "^(p:%d+)")
end

function private.FilterBonusIdsAndModifiers(itemString, importantBonusIdsOnly, itemType, itemId, rand, numBonusIds, ...)
	numBonusIds = tonumber(numBonusIds) or 0
	local numParts = select("#", ...)
	if numParts == 0 then
		return itemString
	end

	-- grab the modifiers and filter them
	local numModifiers = numParts - numBonusIds
	local modifiersStr = (numModifiers > 0 and numModifiers > 1 and numModifiers % 2 == 1) and strjoin(":", select(numBonusIds + 1, ...)) or ""
	if modifiersStr ~= "" then
		wipe(private.modifiersTemp)
		local num, modifierType = nil, nil
		for modifier in gmatch(modifiersStr, "[0-9]+") do
			modifier = tonumber(modifier)
			if not num then
				num = modifier
			elseif not modifierType then
				modifierType = modifier
			else
				if IMPORTANT_MODIFIER_TYPES[modifierType] then
					tinsert(private.modifiersTemp, modifierType)
					tinsert(private.modifiersTemp, modifier)
				end
				modifierType = nil
			end
		end
		if #private.modifiersTemp > 0 then
			assert(#private.modifiersTemp % 2 == 0)
			tinsert(private.modifiersTemp, 1, #private.modifiersTemp / 2)
			modifiersStr = table.concat(private.modifiersTemp, ":")
		end
	end

	-- filter the bonusIds
	local bonusIdsStr = ""
	if numBonusIds > 0 then
		-- get the list of bonusIds and filter them
		wipe(private.bonusIdsTemp)
		for i = 1, numBonusIds do
			private.bonusIdsTemp[i] = select(i, ...)
		end
		if importantBonusIdsOnly then
			-- Only track bonusIds if the itemId is above our minimum
			if tonumber(itemId) >= MINIMUM_VARIANT_ITEM_ID then
				bonusIdsStr = BonusIds.FilterImportant(table.concat(private.bonusIdsTemp, ":"))
			end
		else
			bonusIdsStr = BonusIds.FilterAll(table.concat(private.bonusIdsTemp, ":"))
		end
	end

	-- rebuild the itemString
	itemString = strjoin(":", itemType, itemId, rand, bonusIdsStr, modifiersStr)
	itemString = gsub(itemString, ":0:", "::") -- remove 0s which are in the middle
	return private.RemoveExtra(itemString)
end

function private.ToBaseItemString(itemString)
	local baseItemString = strmatch(itemString, "[ip]:%d+")
	if baseItemString ~= itemString then
		private.hasNonBaseItemStrings[baseItemString] = true
	end
	return baseItemString
end
