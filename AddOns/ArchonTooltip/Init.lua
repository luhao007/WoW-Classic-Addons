local IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
local IsWrath = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC
local IsCata = WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC

if not IsRetail and not IsClassic and not IsWrath and not IsCata then
	return
end

---@class Difficulty
---@field name string
---@field abbreviation string

---@type string
local AddonName = ...

---@class Private
local Private = select(2, ...)

Private.L = {}
Private.IsRetail = IsRetail
Private.IsClassicEra = IsClassic
Private.IsWrath = IsWrath
Private.IsCata = IsCata

---@type table<number, function>
Private.LoginFnQueue = {}
Private.IsInitialized = false

---@class Realm
---@field name string
---@field slug string
---@field database string
---@field region string

---@type table<number, Realm>
Private.Realms = {}

---@class ArchonTooltip
ArchonTooltip = {}

---@param ownerId number
---@param loadedAddonName string
local function OnAddonLoaded(ownerId, loadedAddonName)
	if loadedAddonName == AddonName then
		ArchonTooltipSaved = ArchonTooltipSaved or {}
		Private.db = ArchonTooltipSaved
		EventRegistry:UnregisterFrameEventAndCallback("ADDON_LOADED", ownerId)
	end
end

---@param ownerId number
local function OnPlayerLogin(ownerId)
	EventRegistry:UnregisterFrameEventAndCallback("PLAYER_LOGIN", ownerId)

	for i = 1, #Private.LoginFnQueue do
		local fn = Private.LoginFnQueue[i]
		fn()
	end

	table.wipe(Private.LoginFnQueue)

	local databaseKey = Private.CurrentRealm.database
	local addonToLoad = format("%sDB_%s", AddonName, databaseKey)

	if C_AddOns.DoesAddOnExist and not C_AddOns.DoesAddOnExist(addonToLoad) then
		print(format(Private.L.SubAddonMissing, AddonName, databaseKey))
		return
	end

	local startTs = debugprofilestop()

	local fn = C_AddOns.LoadAddOn or LoadAddOn
	local loaded, reason = fn(addonToLoad, select(1, UnitName("player")))

	if not loaded then
		print(format(Private.L.DBLoadError, AddonName, databaseKey, reason or Private.L.Unknown))
		return
	end

	Private.IsInitialized = true

	Private.Print("Init", "Loaded", addonToLoad, "in", format("%1.3f ms", debugprofilestop() - startTs))
end

EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", OnAddonLoaded)
EventRegistry:RegisterFrameEventAndCallback("PLAYER_LOGIN", OnPlayerLogin)

---@class Encounter
---@field id number

---@class Zone
---@field id number
---@field encounters table<number, Encounter>
---@field hasMultipleSizes boolean
---@field difficultyIconMap table<number, number|string>|nil

---@type table<number, Zone>
Private.Zones = {}

---@type table<number, number>
Private.EncounterZoneIdMap = {}

---@param encounterId number
---@return Zone|nil
function Private.GetZoneForEncounterId(encounterId)
	local zoneId = Private.EncounterZoneIdMap[encounterId]

	return zoneId and Private.Zones[zoneId]
end

---@param zoneId number
---@return Zone|nil
function Private.GetZoneById(zoneId)
	return Private.Zones[zoneId]
end
