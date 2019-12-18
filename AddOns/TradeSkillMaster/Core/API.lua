-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Public TSM API functions
-- @module TSM_API

local _, TSM = ...
local Money = TSM.Include("Util.Money")
local ItemString = TSM.Include("Util.ItemString")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
TSM_API = {}
local private = {}



-- ============================================================================
-- UI
-- ============================================================================

--- Checks if a TSM UI is currently visible.
-- @within UI
-- @tparam string uiName A string which represents the UI ("AUCTION", "CRAFTING", "MAILING", or "VENDORING")
-- @treturn boolean Whether or not the TSM UI is visible
function TSM_API.IsUIVisible(uiName)
	private.CheckCallMethod(uiName)
	if uiName == "AUCTION" then
		return TSM.UI.AuctionUI.IsVisible()
	elseif uiName == "CRAFTING" then
		return TSM.UI.CraftingUI.IsVisible()
	elseif uiName == "MAILING" then
		return TSM.UI.MailingUI.IsVisible()
	elseif uiName == "VENDORING" then
		return TSM.UI.VendoringUI.IsVisible()
	else
		error("Invalid uiName: "..tostring(uiName), 2)
	end
end



-- ============================================================================
-- Groups
-- ============================================================================

--- Gets a current list of TSM group paths.
-- @within Group
-- @tparam table result A table to store the result in
-- @treturn table The passed table, populated with group paths
function TSM_API.GetGroupPaths(result)
	private.CheckCallMethod(result)
	if type(result) ~= "table" then
		error("Invalid 'result' argument type (must be a table): "..tostring(result), 2)
	end
	for _, groupPath in TSM.Groups.GroupIterator() do
		tinsert(result, groupPath)
	end
	return result
end

--- Formats a TSM group path into a human-readable form
-- @within Group
-- @tparam string path The group path to be formatted
-- @treturn string The formatted group path
function TSM_API.FormatGroupPath(path)
	private.CheckCallMethod(path)
	if type(path) ~= "string" then
		error("Invalid 'path' argument type (must be a string): "..tostring(path), 2)
	elseif path == "" then
		error("Invalid 'path' argument (empty string)", 2)
	end
	return TSM.Groups.Path.Format(path)
end

--- Splits a TSM group path into its parent path and group name components.
-- @within Group
-- @tparam string path The group path to be split
-- @treturn string The path of the parent group or nil if the specified path has no parent
-- @treturn string The name of the group
function TSM_API.SplitGroupPath(path)
	private.CheckCallMethod(path)
	if type(path) ~= "string" then
		error("Invalid 'path' argument type (must be a string): "..tostring(path), 2)
	elseif path == "" then
		error("Invalid 'path' argument (empty string)", 2)
	end
	local parentPath, groupName = TSM.Groups.Path.Split(path)
	if parentPath == TSM.CONST.ROOT_GROUP_PATH then
		parentPath = nil
	end
	return parentPath, groupName
end

--- Gets the path to the group which a specific item is in.
-- @within Group
-- @tparam string itemString The TSM item string to get the group path of
-- @treturn string The path to the group which the item is in, or nil if it's not in a group
function TSM_API.GetGroupPathByItem(itemString)
	private.CheckCallMethod(itemString)
	itemString = private.ValidateTSMItemString(itemString)
	local path = TSM.Groups.GetPathByItem(itemString)
	return path ~= TSM.CONST.ROOT_GROUP_PATH and path or nil
end



-- ============================================================================
-- Profiles
-- ============================================================================

--- Gets a current list of TSM profiles.
-- @within Profile
-- @tparam table result A table to store the result in
-- @treturn table The passed table, populated with group paths
function TSM_API.GetProfiles(result)
	private.CheckCallMethod(result)
	for _, profileName in TSM.db:ProfileIterator() do
		tinsert(result, profileName)
	end
	return result
end

--- Gets the active TSM profile.
-- @within Profile
-- @treturn string The name of the currently active profile
function TSM_API.GetActiveProfile()
	return TSM.db:GetCurrentProfile()
end

--- Sets the active TSM profile.
-- @within Profile
-- @tparam string profile The name of the profile to make active
function TSM_API.SetActiveProfile(profile)
	private.CheckCallMethod(profile)
	if type(profile) ~= "string" then
		error("Invalid 'profile' argument type (must be a string): "..tostring(profile), 2)
	elseif not TSM.db:ProfileExists(profile) then
		error("Profile does not exist: "..profile, 2)
	elseif profile == TSM.db:GetCurrentProfile() then
		error("Profile is already active: "..profile, 2)
	end
	return TSM.db:SetProfile(profile)
end



-- ============================================================================
-- Prices
-- ============================================================================

--- Gets a list of price source keys which can be used in TSM custom prices.
-- @within Price
-- @tparam table result A table to store the result in
-- @treturn table The passed table, populated with price source keys
function TSM_API.GetPriceSourceKeys(result)
	private.CheckCallMethod(result)
	if type(result) ~= "table" then
		error("Invalid 'result' argument type (must be a table): "..tostring(result), 2)
	end
	for key in CustomPrice.Iterator() do
		tinsert(result, key)
	end
	return result
end

--- Gets the localized description of a given price source key.
-- @within Price
-- @tparam string key The price source key
-- @treturn string The localized description
function TSM_API.GetPriceSourceDescription(key)
	private.CheckCallMethod(key)
	if type(key) ~= "string" then
		error("Invalid 'key' argument type (must be a string): "..tostring(key), 2)
	end
	local result = CustomPrice.GetDescription(key)
	if not result then
		error("Unknown price source key: "..tostring(key), 2)
	end
	return result
end

--- Gets whether or not a custom price string is valid.
-- @within Price
-- @tparam string customPriceStr The custom price string
-- @treturn boolean Whether or not the custom price is valid
-- @treturn string The (localized) error message or nil if the custom price was valid
function TSM_API.IsCustomPriceValid(customPriceStr)
	private.CheckCallMethod(customPriceStr)
	if type(customPriceStr) ~= "string" then
		error("Invalid 'customPriceStr' argument type (must be a string): "..tostring(customPriceStr), 2)
	end
	return CustomPrice.Validate(customPriceStr)
end

--- Evalulates a custom price string or price source key for a given item
-- @within Price
-- @tparam string customPriceStr The custom price string or price source key to get the value of
-- @tparam string itemString The TSM item string to get the value for
-- @treturn number The value in copper or nil if the custom price string is not valid
-- @treturn string The (localized) error message if the custom price string is not valid or nil if it is valid
function TSM_API.GetCustomPriceValue(customPriceStr, itemString)
	private.CheckCallMethod(customPriceStr)
	if type(customPriceStr) ~= "string" then
		error("Invalid 'customPriceStr' argument type (must be a string): "..tostring(customPriceStr), 2)
	end
	itemString = private.ValidateTSMItemString(itemString)
	return CustomPrice.GetValue(customPriceStr, itemString)
end



-- ============================================================================
-- Money
-- ============================================================================

--- Converts a money value to a formatted, human-readable string.
-- @within Money
-- @tparam number value The money value in copper to be converted
-- @treturn string The formatted money string
function TSM_API.FormatMoneyString(value)
	private.CheckCallMethod(value)
	if type(value) ~= "number" then
		error("Invalid 'value' argument type (must be a number): "..tostring(value), 2)
	end
	local result = Money.ToString(value)
	assert(result)
	return result
end

--- Converts a formatted, human-readable money string to a value.
-- @within Money
-- @tparam string str The formatted money string
-- @treturn number The money value in copper
function TSM_API.ParseMoneyString(str)
	private.CheckCallMethod(str)
	if type(str) ~= "string" then
		error("Invalid 'str' argument type (must be a string): "..tostring(str), 2)
	end
	local result = Money.FromString(str)
	assert(result)
	return result
end



-- ============================================================================
-- Item
-- ============================================================================

--- Converts an item to a TSM item string.
-- @within Item
-- @tparam string item Either an item link, TSM item string, or WoW item string
-- @treturn string The TSM item string or nil if the specified item could not be converted
function TSM_API.ToItemString(item)
	private.CheckCallMethod(item)
	if type(item) ~= "string" then
		error("Invalid 'item' argument type (must be a string): "..tostring(item), 2)
	end
	return ItemString.Get(item)
end

--- Gets an item's name from a given TSM item string
-- @within Item
-- @tparam string itemString The TSM item string
-- @treturn string The name of the item or nil if it couldn't be determined
function TSM_API.GetItemName(itemString)
	private.CheckCallMethod(itemString)
	itemString = private.ValidateTSMItemString(itemString)
	return ItemInfo.GetName(itemString)
end

--- Gets an item link from a given TSM item string
-- @within Item
-- @tparam string itemString The TSM item string
-- @treturn string The item link or an "[Unknown Item]" link
function TSM_API.GetItemLink(itemString)
	private.CheckCallMethod(itemString)
	itemString = private.ValidateTSMItemString(itemString)
	local result = ItemInfo.GetLink(itemString)
	assert(result)
	return result
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ValidateTSMItemString(itemString)
	if type(itemString) ~= "string" or not strmatch(itemString, "[ip]:%d+") then
		error("Invalid 'itemString' argument type (must be a TSM item string): "..tostring(itemString), 3)
	end
	local newItemString = ItemString.Get(itemString)
	if not newItemString then
		error("Invalid TSM itemString: "..itemString, 3)
	end
	return newItemString
end

function private.CheckCallMethod(firstArg)
	if firstArg == TSM_API then
		error("Invalid usage of colon operator to call TSM_API function", 3)
	end
end
