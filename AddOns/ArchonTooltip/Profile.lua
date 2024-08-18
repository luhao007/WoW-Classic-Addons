---@class Private
local Private = select(2, ...)

---@class Profile
---@field difficulty number
---@field progress ProfileProgress
---@field average number
---@field specs ProfileSpec[]
---@field isSubscriber boolean
---@field size number
---@field zoneId number

---@class ProfileProgress
---@field count number
---@field total number

---@class ProfileSpec
---@field type string
---@field difficulty number
---@field progress ProfileProgress
---@field average number|nil
---@field asp number
---@field rank number
---@field encounters EncounterProfile[]
---@field size number

---@class EncounterProfile
---@field id number
---@field kills number
---@field best number|nil

---@param name string
---@param realm string
---@return Profile|nil
function Private.GetProfile(name, realm)
	realm = Private.GetRealmOrDefault(realm)

	Private.Print("loading profile for " .. name .. "-" .. realm)
	local providerProfile = Private.GetProviderProfile(name, realm)

	if providerProfile == nil then
		return nil
	end

	---@type number|nil
	local zoneId = nil

	if providerProfile.encounters ~= nil then
		local firstEncounterId = next(providerProfile.encounters)

		if firstEncounterId then
			local zone = Private.GetZoneForEncounterId(firstEncounterId)

			if zone then
				zoneId = zone.id
			end
		end

		-- workaround for incorrect data
		if zoneId == nil then
			return nil
		end
	end

	local specs = {}
	for _, providerSpec in ipairs(providerProfile.perSpec) do
		---@type EncounterProfile[]
		local encounters = {}

		if providerSpec.encounters ~= nil then
			local firstEncounterId = next(providerSpec.encounters)
			local zone = Private.GetZoneForEncounterId(firstEncounterId)

			if zone ~= nil then
				-- We want to ensure that encounters match the order of the zone
				-- and that we include encounters the player has no data for
				for _, zoneEncounter in ipairs(zone.encounters) do
					local encounterId = zoneEncounter.id
					local encounter = {
						id = encounterId,
						kills = 0,
						best = nil,
					}

					local specEncounter = providerSpec.encounters[encounterId]
					if specEncounter ~= nil then
						encounter.kills = specEncounter.kills
						encounter.best = specEncounter.best
					end

					table.insert(encounters, encounter)
				end
			end
		end

		---@type ProfileSpec
		local spec = {
			type = providerSpec.spec,
			difficulty = providerSpec.difficulty,
			progress = {
				count = providerSpec.progress,
				total = providerSpec.total,
			},
			average = providerSpec.average,
			asp = providerSpec.asp,
			rank = providerSpec.rank,
			encounters = encounters,
			size = providerSpec.size,
		}

		table.insert(specs, spec)
	end

	table.sort(specs, function(a, b)
		if a.progress.count == b.progress.count then
			return (a.average or 0) > (b.average or 0)
		end

		return a.progress.count > b.progress.count
	end)

	return {
		difficulty = providerProfile.difficulty,
		progress = {
			count = providerProfile.progress,
			total = providerProfile.total,
		},
		average = providerProfile.average,
		specs = specs,
		isSubscriber = providerProfile.subscriber,
		size = providerProfile.size,
		zoneId = zoneId,
	}
end
