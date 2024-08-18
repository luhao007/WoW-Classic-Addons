---@type string
local AddonName = ...

---@class Private
local Private = select(2, ...)

---@param table table
---@param recursive boolean|nil
function Private.PrintTable(table, recursive)
	if Private.IsTestCharacter then
		recursive = recursive == nil and true or recursive

		Private.Print("", "-->")
		for k, v in pairs(table) do
			local typeOf = type(v)
			Private.Print(WrapTextInColorCode(k, "ffffd900"), WrapTextInColorCode(typeOf, "ffff0000"), v)

			if recursive and typeOf == "table" then
				Private.Print("", "--->")
				Private.PrintTable(v)
			end
		end
	end
end

---@key string
function Private.Print(key, ...)
	if Private.IsTestCharacter then
		local colors = {
			["Provider"] = "FF525252",
			["Frame"] = "FFFF0000",
			["Tooltip"] = "FFFFD900",
			["Dropdown"] = "FF91FF00",
			["Init"] = "FF00FFC8",
		}

		print("|cff9900ff" .. AddonName .. "|r", (colors[key] and "[" .. WrapTextInColorCode(key, colors[key]) .. "]" or key), ...)
	end
end

---@param percentile number
---@param content string|number|nil
function Private.EncodeWithPercentileColor(percentile, content)
	local color = "ff666666"

	if percentile >= 100 then
		color = "ffe5cc80"
	elseif percentile >= 99 then
		color = "ffe268a8"
	elseif percentile >= 95 then
		color = "ffff8000"
	elseif percentile >= 75 then
		color = "ffa335ee"
	elseif percentile >= 50 then
		color = "ff0070ff"
	elseif percentile >= 25 then
		color = "ff1eff00"
	end

	return WrapTextInColorCode(content, color)
end

---@param texture string|number
---@return string
function Private.EncodeWithTexture(texture)
	if type(texture) == "number" then
		return format("|T%s:0|t", texture)
	end

	texture = string.lower(texture)
	texture = string.gsub(texture, ".blp", "")
	texture = string.gsub(texture, "/", "\\")
	texture = string.find(texture, "interface") == nil and format("interface\\icons\\%s", texture) or texture
	return format("|T%s:0|t", texture)
end

---@param percentile number
---@return string
function Private.FormatPercentile(percentile)
	return format("%.0f", percentile)
end

---@param percentile number
---@return string
function Private.FormatAveragePercentile(percentile)
	return format("%.1f", percentile)
end

---@param name string
---@param realmNameOrId string|number
---@param projectId number|nil
---@return string
function Private.GetProfileUrl(name, realmNameOrId, projectId)
	projectId = projectId or WOW_PROJECT_ID

	---@type string|nil
	local subdomain = nil
	if projectId == WOW_PROJECT_CLASSIC then
		subdomain = "sod"
	elseif projectId == WOW_PROJECT_WRATH_CLASSIC or projectId == WOW_PROJECT_CATACLYSM_CLASSIC then
		subdomain = "classic"
	end

	---@type table<number, string>
	local parts = {}

	local locale = GAME_LOCALE or GetLocale()

	if locale ~= "enUS" and Private.LocaleToSiteSubDomainMap[locale] ~= nil then
		parts[#parts + 1] = Private.LocaleToSiteSubDomainMap[locale]
		if subdomain then
			parts[#parts + 1] = subdomain
		end
	elseif subdomain ~= nil then
		parts[#parts + 1] = subdomain
	else
		parts[#parts + 1] = "www"
	end

	local subdomains = #parts == 1 and parts[1] or table.concat(parts, ".")
	local baseUrl = format("https://%s.warcraftlogs.com%s", subdomains, Private.CharacterBaseUrl)

	realmNameOrId = realmNameOrId or Private.CurrentRealm.name

	if type(realmNameOrId) == "string" then
		realmNameOrId = select(1, realmNameOrId:gsub("%s+", ""))

		for _, dataset in ipairs(Private.Realms) do
			if dataset.name == realmNameOrId then
				realmNameOrId = dataset.slug
				break
			end
		end
	else
		for id, dataset in ipairs(Private.Realms) do
			if id == realmNameOrId then
				realmNameOrId = dataset.slug
				break
			end
		end
	end

	return string.lower(format(baseUrl, Private.CurrentRealm.region, realmNameOrId, name))
end

---@param difficulty number
---@param size number
---@param zoneId number|nil
---@return string
function Private.GetDifficultyString(difficulty, size, zoneId)
	if Private.HasDifficulties == false then
		return ""
	end

	local translatedDifficulty = Private.L["Difficulty-" .. difficulty] or ""
	-- weekly data has no encounter ids and thus no zone id
	local zone = zoneId and Private.GetZoneById(zoneId) or nil
	local hasMultipleSizes = zone and zone.hasMultipleSizes or (Private.IsWrath or Private.IsCata)
	local difficultyIcon = zone and zone.difficultyIconMap and zone.difficultyIconMap[difficulty] or nil

	if difficultyIcon then
		translatedDifficulty = format("%s %s", Private.EncodeWithTexture(difficultyIcon), translatedDifficulty)
	end

	return hasMultipleSizes and format("%d%s", size, translatedDifficulty) or translatedDifficulty
end

---@param realm string|nil
---@return string
function Private.GetRealmOrDefault(realm)
	-- in classic, party frames return an empty string as realm
	if not realm or #realm == 0 then
		return Private.CurrentRealm.name
	end

	return realm
end

if Private.IsRetail and Private.IsTestCharacter then
	AddonCompartmentFrame:RegisterAddon({
		text = AddonName,
		icon = "Interface/AddOns/ArchonTooltip/Media/logo-32-circle.tga",
		registerForAnyClick = true,
		notCheckable = true,
		func = function(btn, arg1, arg2, checked, mouseButton)
			Private.Print("Init", "AddonCompartment Functionality NYI")
		end,
		funcOnEnter = function()
			GameTooltip:SetOwner(AddonCompartmentFrame, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(AddonName)
			GameTooltip:AddLine("|cffeda55fLeft-Click|r to toggle showing the main window.", 1, 1, 1, true)
			GameTooltip:Show()
		end,
		funcOnLeave = function()
			GameTooltip:Hide()
		end,
	})
end
