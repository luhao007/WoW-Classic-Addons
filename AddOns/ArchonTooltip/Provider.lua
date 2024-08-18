---@class Private
local Private = select(2, ...)

---@class Provider
---@field name string
---@field region string
---@field realm string
---@field date string
---@field data table<string, ProviderProfile>

---@type table<string, Provider>
local providers = {}

---@param dataset table<'realm'|'subscribers', string|number>
---@return string
local function CreateProviderKey(dataset)
	return dataset.realm .. "-" .. dataset.subscribers
end

---@param lookup table<string, string>
---@param value table|string|number|nil|boolean
---@return table|string|number|nil|boolean
local function hydrate(lookup, value)
	if type(value) == "string" then
		return lookup[value] or value
	end

	if type(value) == "table" then
		local result = {}
		for k, v in pairs(value) do
			result[hydrate(lookup, k)] = hydrate(lookup, v)
		end
		return result
	end

	return value
end

---@param lookup table<string, string>
---@param provider table
function ArchonTooltip.AddProvider(lookup, provider)
	assert(type(lookup) == "table", "ArchonTooltip.AddProvider(lookup, provider) expects a table lookup")
	assert(type(provider) == "table", "ArchonTooltip.AddProvider(lookup, provider) expects a table provider")
	assert(type(provider.name) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.name")
	assert(type(provider.region) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.region")
	assert(type(provider.realm) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.realm")
	assert(type(provider.date) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.date")
	assert(type(provider.data) == "table", "ArchonTooltip.AddProvider(lookup, provider) tables must have table provider.data")

	if provider.region ~= Private.CurrentRealm.region then
		Private.Print("Provider", "rejected Provider for region " .. provider.region)
		return
	end

	if provider.name ~= Private.CurrentRealm.database then
		Private.Print("Provider", "rejected Provider for database " .. provider.name .. " as it is not what we should be loading")
		return
	end

	local rawData = provider.data
	local count = 0

	if Private.IsTestCharacter then
		for _ in pairs(rawData) do
			count = count + 1
		end
	end

	provider.data = {}

	setmetatable(provider.data, {
		__index = function(table, key)
			local data = rawData[key]

			if data == nil then
				return nil
			end

			return hydrate(lookup, data)
		end,
	})

	local key = CreateProviderKey({
		realm = provider.realm,
		subscribers = string.find(provider.type, "subscribers") and 1 or 0,
		region = provider.region,
	})

	if count > 0 then
		Private.Print("Provider", "added provider: " .. key .. " with " .. count .. " datasets")
	end

	providers[key] = provider
end

---@class ProviderProfile
---@field progress number
---@field total number
---@field average number
---@field perSpec table<number, ProviderProfileSpec>
---@field difficulty number
---@field subscriber boolean
---@field size number
---@field encounters table<number, ProviderProfileEncounter> | nil

---@class ProviderProfileSpec
---@field progress number
---@field total number
---@field average number|nil
---@field spec string
---@field asp number
---@field rank number
---@field difficulty number
---@field encounters table<number, ProviderProfileEncounter>|nil
---@field size number

---@class ProviderProfileEncounter
---@field kills number
---@field best number

---@param name string
---@param realm string
---@return ProviderProfile|nil
function Private.GetProviderProfile(name, realm)
	realm = Private.GetRealmOrDefault(realm)

	for i = 0, 1 do
		local key = CreateProviderKey({ realm = realm, subscribers = i })
		local provider = providers[key]

		if provider ~= nil then
			local profile = provider.data[name]

			if profile then
				return profile
			end
		end
	end

	return nil
end
