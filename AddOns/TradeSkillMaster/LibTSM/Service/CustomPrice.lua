-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local CustomPrice = TSM.Init("Service.CustomPrice") ---@class Service.CustomPrice
local L = TSM.Include("Locale").GetTable()
local TempTable = TSM.Include("Util.TempTable")
local Money = TSM.Include("Util.Money")
local String = TSM.Include("Util.String")
local Log = TSM.Include("Util.Log")
local Theme = TSM.Include("Util.Theme")
local SmartMap = TSM.Include("Util.SmartMap")
local CustomString = TSM.Include("Util.CustomString")
local EnumType = TSM.Include("Util.EnumType")
local Settings = TSM.Include("Service.Settings")
local Conversions = TSM.Include("Service.Conversions")
CustomPrice.SOURCE_TYPE = EnumType.New("SOURCE_TYPE", {
	PRICE_DB = EnumType.CreateValue(), -- Changes infrequently and all at once (communicated via CustomPrice.OnSourceChange)
	NORMAL = EnumType.CreateValue(), -- Changes are communicated via CustomPrice.OnSourceChange
	VOLATILE = EnumType.CreateValue(), -- Changes without calling CustomPrice.OnSourceChange
})
local private = {
	sanitizeMap = nil,
	sanitizeMapReader = nil,
	customStrings = {}, ---@type table<string,CustomStringObject>
	customStringSourcesValidated = {},
	priceSourceKeys = {},
	priceSourceInfo = {},
	settings = nil,
	sanitizeCache = {},
	customSourceCallbacks = {},
	lastRegisteredSourceChange = 0,
	convertCache = {},
}



-- ============================================================================
-- Module Loading
-- ============================================================================

CustomPrice:OnModuleLoad(function()
	private.sanitizeMap = SmartMap.New("string", "string", function(str) return strlower(strtrim(str)) end)
	private.sanitizeMapReader = private.sanitizeMap:CreateReader()
	CustomString.SetPriceFunc(private.PriceFunc)
end)

CustomPrice:OnSettingsLoad(function()
	private.settings = Settings.NewView()
		:AddKey("global", "userData", "customPriceSources")

	for name, str in pairs(private.settings.customPriceSources) do
		if CustomPrice.ValidateName(name, true) then
			str = private.SanitizeCustomPriceString(str)
			private.settings.customPriceSources[name] = str
		else
			Log.PrintfUser(L["Removed custom price source (%s) which has an invalid name."], name)
			CustomPrice.DeleteCustomPriceSource(name)
		end
	end
	private.lastRegisteredSourceChange = GetTime()
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

---Register a built-in price source.
---@param moduleName string The name of the module which provides this source
---@param key string The key for this price source (i.e. DBMarket)
---@param label string The label which describes this price source for display to the user
---@param callback function The price source callback
---@param sourceType CustomPrice.SOURCE_TYPE The type of the source
function CustomPrice.RegisterSource(moduleName, key, label, callback, sourceType)
	tinsert(private.priceSourceKeys, strlower(key))
	private.priceSourceInfo[strlower(key)] = {
		moduleName = moduleName,
		key = key,
		label = label,
		callback = callback,
		sourceType = sourceType,
		cache = {},
	}
	private.lastRegisteredSourceChange = GetTime()
end

---Register a callback when custom sources change.
---@param callback function The callback function
function CustomPrice.RegisterCustomSourceCallback(callback)
	tinsert(private.customSourceCallbacks, callback)
end

---Create a new custom price source.
---@param name string The name of the custom price source
---@param value string The value of the custom price source
function CustomPrice.CreateCustomPriceSource(name, value)
	assert(name ~= "")
	assert(gsub(name, "([a-z]+)", "") == "")
	assert(not private.settings.customPriceSources[name])
	value = private.SanitizeCustomPriceString(value)
	private.settings.customPriceSources[name] = value
	private.CallCustomSourceCallbacks()
	private.lastRegisteredSourceChange = GetTime()
end

---Rename a custom price source.
---@param oldName string The old name of the custom price source
---@param newName string The new name of the custom price source
function CustomPrice.RenameCustomPriceSource(oldName, newName)
	if oldName == newName then
		return
	end
	local value = private.settings.customPriceSources[oldName]
	assert(value)
	private.settings.customPriceSources[newName] = value
	private.settings.customPriceSources[oldName] = nil
	CustomPrice.OnSourceChange(oldName)
	CustomPrice.OnSourceChange(newName)
	private.CallCustomSourceCallbacks()
	private.lastRegisteredSourceChange = GetTime()
end

---Delete a custom price source.
---@param name string The name of the custom price source
function CustomPrice.DeleteCustomPriceSource(name)
	assert(private.settings.customPriceSources[name])
	private.settings.customPriceSources[name] = nil
	CustomPrice.OnSourceChange(name)
	private.CallCustomSourceCallbacks()
	private.lastRegisteredSourceChange = GetTime()
end

---Sets the value of a custom price source.
---@param name string The name of the custom price source
---@param value string The value of the custom price source
function CustomPrice.SetCustomPriceSource(name, value)
	assert(private.settings.customPriceSources[name])
	value = private.SanitizeCustomPriceString(value)
	private.settings.customPriceSources[name] = value
	CustomPrice.OnSourceChange(name)
	private.lastRegisteredSourceChange = GetTime()
end

---Bulk creates custom price sources from a group import.
---@param customSources table<string, string> The custom sources to impor
---@param replaceExisting boolean Whether or not existing sources should be replaced
function CustomPrice.BulkCreateCustomPriceSourcesFromImport(customSources, replaceExisting)
	for name, value in pairs(customSources) do
		value = private.SanitizeCustomPriceString(value)
		assert(not private.settings.customPriceSources[name] or replaceExisting)
		if private.settings.customPriceSources[name] then
			CustomPrice.SetCustomPriceSource(name, value)
		else
			CustomPrice.CreateCustomPriceSource(name, value)
		end
	end
	private.lastRegisteredSourceChange = GetTime()
end

---Print built-in price sources to chat.
function CustomPrice.PrintSources()
	Log.PrintUser(L["Below is a list of all available price sources, along with a brief description of what they represent."])
	local moduleList = TempTable.Acquire()

	for _, info in pairs(private.priceSourceInfo) do
		if not tContains(moduleList, info.moduleName) then
			tinsert(moduleList, info.moduleName)
		end
	end
	sort(moduleList, private.ModuleSortFunc)

	for _, module in ipairs(moduleList) do
		Log.PrintUserRaw("|cffffff00"..module..":|r")
		local lines = TempTable.Acquire()
		for _, info in pairs(private.priceSourceInfo) do
			if info.moduleName == module then
				tinsert(lines, format("  %s (%s)", Log.ColorUserAccentText(info.key), info.label))
			end
		end
		sort(lines)
		for _, line in ipairs(lines) do
			Log.PrintfUserRaw(line)
		end
		TempTable.Release(lines)
	end

	TempTable.Release(moduleList)
end

---Gets the description of a price source.
---@param key string The custom price source
---@return string?
function CustomPrice.GetDescription(key)
	local info = private.priceSourceInfo[key]
	return info and info.label or nil
end

---Validate a custom price name.
---@param customPriceName string The custom price name
---@param ignoreExistingCustomPriceSources boolean Whether or not to ignore existing custom price sources
---@return boolean @Whether or not the custom price name is valid
function CustomPrice.ValidateName(customPriceName, ignoreExistingCustomPriceSources)
	if gsub(customPriceName, "([a-z]+)", "") ~= "" or strlower(customPriceName) ~= customPriceName then
		return false, L["Custom price names can only contain lowercase letters."]
	end
	-- User defined price sources
	if not ignoreExistingCustomPriceSources and private.settings.customPriceSources[customPriceName] then
		return false, format(L["Custom price name %s already exists."], Theme.GetColor("INDICATOR"):ColorText(customPriceName))
	end
	-- Reserved words
	if private.priceSourceInfo[customPriceName] or CustomString.IsReservedWord(customPriceName) then
		return false, format(L["Custom price name %s is a reserved word which cannot be used."], Theme.GetColor("INDICATOR"):ColorText(customPriceName))
	end
	return true
end

---Validate a custom price string.
---@param str string The custom price string
---@param badPriceSources? table A table of price sources (as keys) which aren't allowed to be used
---@return boolean @Whether or not the custom price string is valid
---@return string? @The error message if the custom price string was invalid
function CustomPrice.Validate(str, badPriceSources)
	local obj, errMsg = private.GetObject(str)
	if not obj then
		return nil, errMsg
	end
	if badPriceSources then
		for source in pairs(badPriceSources) do
			if obj:IsDependantOnSource(source) then
				return false, format(L["You cannot use %s as part of this custom price."], source)
			end
		end
	end
	return true, nil
end

---Evaulates a custom price source for an item.
---@param str string The custom price string
---@param itemString string The item to evaluate the custom price string for
---@param allowZero boolean If true, allows the result to be 0
---@return number? @The resulting value or nil if the custom price string is invalid
---@return string? @The error message if the custom price string was invalid
function CustomPrice.GetValue(str, itemString, allowZero)
	local obj, errMsg = private.GetObject(str)
	if not obj then
		return nil, errMsg
	end
	local value = obj:Evaluate(itemString)
	if not value or (not allowZero and value == 0) then
		return nil, L["No value was returned by the custom price for the specified item."]
	end
	return value
end

---Gets a built-in price source's value for an item.
---@param itemString string The item to evaluate the price source for
---@param key string The key of the price source
---@return number? @The resulting value or nil if no price was found for the item
function CustomPrice.GetSourcePrice(itemString, key)
	key = strlower(key)
	local info = private.priceSourceInfo[key]
	if not itemString or not info then
		return nil
	end
	if info.sourceType == CustomPrice.SOURCE_TYPE.VOLATILE then
		local currentFrame = GetTime()
		if (info.cache.frame or currentFrame) ~= currentFrame then
			wipe(info.cache)
		end
		info.cache.frame = currentFrame
	end
	local cachedValue = info.cache[itemString]
	if cachedValue ~= nil then
		return cachedValue or nil
	end
	local value = info.callback(itemString)
	value = type(value) == "number" and value or nil
	info.cache[itemString] = value or false
	return value
end

---Iterate over the price sources.
---@return any @An iterator which provides the following fields: `index, key, moduleName, label`
function CustomPrice.Iterator()
	return private.IteratorHelper, nil, 0
end

---Returns whether or not a key is a math function.
---@param key string The key to check
---@return boolean
function CustomPrice.IsMathFunction(key)
	key = strlower(key)
	return CustomString.IsReservedWord(key) and key ~= "convert"
end

---Returns whether or not a key is a source.
---@param key string The key to check
---@return boolean
function CustomPrice.IsSource(key)
	key = strlower(key)
	return (private.priceSourceInfo[key] or key == "convert") and true or false
end

---Returns whether or not a key is a custom source.
---@param key string The key to check
---@return boolean
function CustomPrice.IsCustomSource(key)
	return private.settings.customPriceSources[strlower(key)] and true or false
end

---Should be called when the value of a registered source changes.
---@param key string The key of the price source
---@param itemString? string The item which the source changed for or nil if it changed for all items
function CustomPrice.OnSourceChange(key, itemString)
	key = strlower(key)
	local info = private.priceSourceInfo[key]
	if not info then
		return
	end
	if info.sourceType == CustomPrice.SOURCE_TYPE.PRICE_DB then
		assert(not itemString)
	elseif info.sourceType == CustomPrice.SOURCE_TYPE.NORMAL then
		-- pass
	else
		error("Source cannot change: "..key)
	end
	if private.convertCache[key] then
		wipe(private.convertCache[key])
	end
	if itemString then
		info.cache[itemString] = nil
	else
		wipe(info.cache)
	end
end

---Iterates over the custom sources which a string depends on.
---@param str string The custom string
---@return fun():number, string, string @An iterator with fields: `index`, `name`, `customSourceStr`
function CustomPrice.DependantCustomSourceIterator(str)
	local result = TempTable.Acquire()
	local obj = private.GetObject(str)
	if obj then
		for name, customSourceStr in pairs(private.settings.customPriceSources) do
			if obj:IsDependantOnSource(name) then
				tinsert(result, name)
				tinsert(result, customSourceStr)
			end
		end
	end
	return TempTable.Iterator(result, 2)
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.PriceFunc(itemString, key, convertSource)
	local value = nil
	if key == "convert" then
		private.convertCache[convertSource] = private.convertCache[convertSource] or {}
		if not private.convertCache[convertSource][itemString] then
			local conversions = Conversions.GetSourceItems(itemString)
			if conversions then
				local minPrice = nil
				for sourceItemString, rate in pairs(conversions) do
					local price = CustomPrice.GetSourcePrice(sourceItemString, convertSource)
					if price then
						price = price / rate
						minPrice = min(minPrice or price, price)
					end
				end
				private.convertCache[convertSource][itemString] = minPrice or -1
			else
				private.convertCache[convertSource][itemString] = -1
			end
		end
		value = private.convertCache[convertSource][itemString]
	else
		local customPriceSourceStr = private.settings.customPriceSources[key]
		if customPriceSourceStr then
			value = CustomPrice.GetValue(customPriceSourceStr, itemString)
		else
			value = CustomPrice.GetSourcePrice(itemString, key)
		end
	end
	if not value or value < 0 then
		return nil
	end
	return value
end

function private.ModuleSortFunc(a, b)
	if a == "TSM" then
		return true
	elseif b == "TSM" then
		return false
	else
		return a < b
	end
end

function private.SanitizeCustomPriceString(customPriceStr)
	assert(customPriceStr)
	local result = private.sanitizeCache[customPriceStr]
	if not result then
		result = strlower(strtrim(tostring(customPriceStr)))
		result = Money.FromString(result) and gsub(result, String.Escape(LARGE_NUMBER_SEPERATOR), "") or result
		private.sanitizeCache[customPriceStr] = result
	end
	return result
end

function private.CallCustomSourceCallbacks()
	for _, callback in ipairs(private.customSourceCallbacks) do
		callback()
	end
end

function private.IteratorHelper(_, index)
	index = index + 1
	local key = private.priceSourceKeys[index]
	if not key then
		return
	end
	local info = private.priceSourceInfo[key]
	return index, info.key, info.moduleName, info.label
end

function private.GetObject(str)
	str = private.sanitizeMapReader[tostring(str)]
	if str == "" then
		return nil, L["Empty price string."]
	end

	private.customStrings[str] = private.customStrings[str] or CustomString.Parse(str)
	local obj = private.customStrings[str]

	local isValid, errType, _, errTokenStr = obj:Validate()
	if not isValid then
		if errType == CustomString.ERROR_TYPE.INVALID_TOKEN then
			assert(errTokenStr)
			return nil, format(L["Unexpected word ('%s') in custom string."], errTokenStr)
		elseif errType == CustomString.ERROR_TYPE.UNBALANCED_PARENS then
			return nil, L["There are unbalanced parentheses in this custom string."]
		elseif errType == CustomString.ERROR_TYPE.INVALID_NUM_ARGS then
			assert(errTokenStr)
			return nil, format(L["The '%s' function has an invalid number of arguments."], errTokenStr)
		elseif errType == CustomString.ERROR_TYPE.TOO_MANY_VARS then
			return nil, L["This custom string is too complex for WoW to handle; use custom sources to simplify it."]
		elseif errType == CustomString.ERROR_TYPE.INVALID_ITEM_STRING then
			assert(errTokenStr)
			return nil, format(L["'%s' is not a valid item argument."], errTokenStr)
		elseif errType == CustomString.ERROR_TYPE.INVALID_CONVERT_ARG then
			assert(errTokenStr)
			return nil, format(L["'%s' is not a valid argument for convert()."], errTokenStr)
		elseif errType == CustomString.ERROR_TYPE.NO_ITEM_PARAM_PARENT then
			assert(errTokenStr)
			return nil, format(L["The '%s' item parameter was used outside of a custom source."], errTokenStr)
		else
			error("Invalid error type: "..tostring(errType))
		end
	end
	if (private.customStringSourcesValidated[str] or 0) < private.lastRegisteredSourceChange then
		for _, source, convertArg in obj:DependantSourceIterator() do
			if source == "convert" then
				if not private.priceSourceInfo[convertArg] or private.priceSourceInfo[convertArg].sourceType ~= CustomPrice.SOURCE_TYPE.PRICE_DB then
					return nil, format(L["'%s' is not a valid argument for convert()."], convertArg)
				end
			elseif not private.priceSourceInfo[source] and not private.settings.customPriceSources[source] then
				return nil, format(L["%s is not a valid source."], source)
			end
		end
		private.customStringSourcesValidated[str] = GetTime()
	end
	return obj, nil
end
