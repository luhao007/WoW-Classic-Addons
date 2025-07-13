-- Catalyst Module
local _, app = ...;

-- Globals
local setmetatable,tonumber,ipairs,tremove,unpack
	= setmetatable,tonumber,ipairs,tremove,unpack

-- WOWAPI
local C_Item_GetItemInfoInstant,C_Item_GetItemUpgradeInfo
	= C_Item.GetItemInfoInstant,C_Item.GetItemUpgradeInfo

-- App
local containsAnyKey
	= app.containsAnyKey

-- Catalyst API Implementation
-- Access via AllTheThings.Modules.Catalyst
local api = {}
app.Modules.Catalyst = api

-- TODO: should actually return a symlink for each bonusID to select the proper 'catalyst' armor listing from ATT
-- then narrow down the matching armor slot, apply the bonusIDs to the new item, and render into tooltip

-- Helpful Reference: https://www.raidbots.com/static/data/live/item-conversions.json
-- Wago: https://wago.tools/db2/ItemBonus?build=11.1.5.60568&filter%5BType%5D=37&page=2
-- References the CatalystID of the corresponding Catalyst object which contains the available Catalyst results in ATT
-- Blizzard likely has some other meaning for the value I've used for 'catalystID' but it seems to correlate to this purpose
local PossibleCatalystBonusIDLookups = app.ItemConversionDB
if not PossibleCatalystBonusIDLookups then
	app.print("Catalyst Module missing ItemConversionDB! Cannot load!")
	return
end

local CatalystArmorSlots = {
	["INVTYPE_HEAD"] = true,
	["INVTYPE_SHOULDER"] = true,
	["INVTYPE_CLOAK"] = true,
	["INVTYPE_BODY"] = true,
	["INVTYPE_CHEST"] = true,
	["INVTYPE_ROBE"] = true,
	["INVTYPE_WRIST"] = true,
	["INVTYPE_HAND"] = true,
	["INVTYPE_WAIST"] = true,
	["INVTYPE_LEGS"] = true,
	["INVTYPE_FEET"] = true,
}

local CatalystInterchangeSlots = {
	["INVTYPE_CHEST"] = {"INVTYPE_CHEST","INVTYPE_BODY","INVTYPE_ROBE"},
	["INVTYPE_BODY"] = {"INVTYPE_BODY","INVTYPE_CHEST","INVTYPE_ROBE"},
	["INVTYPE_ROBE"] = {"INVTYPE_ROBE","INVTYPE_BODY","INVTYPE_CHEST"},
}

local CatalystArmorSubtypesByClass = {
	[1] = 4,
	[2] = 4,
	[3] = 3,
	[4] = 2,
	[5] = 1,
	[6] = 4,
	[7] = 3,
	[8] = 1,
	[9] = 1,
	[10] = 2,
	[11] = 2,
	[12] = 2,
	[13] = 3,
}
local ClassArmorSubtype = CatalystArmorSubtypesByClass[app.ClassIndex]

local function GetCatalystSlot(data)
	local link = data.link
	if not link then return end

	local itemID, _, _, itemEquipLoc, _, classID, subclassID = C_Item_GetItemInfoInstant(link)
	if not itemID then return end

	-- Armor only / Slot
	if classID ~= 4 or not CatalystArmorSlots[itemEquipLoc] then return end

	-- Correct Armor type for current Class (or a Cloth Cloak)
	if not (subclassID == ClassArmorSubtype or (itemEquipLoc == "INVTYPE_CLOAK" and subclassID == 1)) then return end

	return itemEquipLoc
end

local CatalystUpgradeTrackShift = {
	-- 972 = Veteran = LFR -> Champion
	[972] = 973,
	-- 973 = Champion = Normal -> Hero
	[973] = 974,
	-- 974 = Hero = Heroic -> Myth
	[974] = 978,
	-- 978 = Myth = Mythic -> Myth
	[978] = 978,
}

local function GetCatalyst(data)
	-- app.PrintDebug("GetCatalyst", data.hash)
	local bonuses = data.bonuses
	if not bonuses or #bonuses < 1 then return end
	local bonusID = containsAnyKey(PossibleCatalystBonusIDLookups, bonuses)
	if not bonusID then return end
	local slot = GetCatalystSlot(data)
	if not slot then return end

	local catalystID = PossibleCatalystBonusIDLookups[bonusID]
	-- app.PrintDebug("Can Catalyst!",catalystID,app:SearchLink(data))
	local upgradeInfo = C_Item_GetItemUpgradeInfo(data.link)
	if not upgradeInfo then return end -- shouldn't happen

	local upgradeTrackID = upgradeInfo.trackStringID or 0
	local upgradeLevel = upgradeInfo.currentLevel or 0

	-- If our upgrade level is 5+ then the item is actually on the next matching trackID for catalyst output
	if upgradeLevel > 4 then
		upgradeTrackID = CatalystUpgradeTrackShift[upgradeTrackID]
	end

	-- Create a Catalyst group to contain the resulting Catalyst Item
	local SymlinkGroup = {
		sym = {{"sub","catalyst_select_proper_tier_item",
			catalystID,
			upgradeTrackID,
			app.ClassIndex,
			slot,
			data}}
	}
	local catalystResults = app.ResolveSymbolicLink(SymlinkGroup, true)
	local catalystResult = catalystResults and catalystResults[1]

	if not catalystResult then
		app.PrintDebug("Catalyst Item failed to find matching catalyst output",catalystID,upgradeTrackID,slot,app:SearchLink(data))
		return
	end

	-- Copy all but the catalyst bonusID to the resulting item
	tremove(bonuses, app.indexOf(bonuses, bonusID))
	catalystResult.bonuses = app.CloneArray(bonuses)
	-- Don't let a baked-in upgrade persist since our upgradeLevel might not allow it
	catalystResult.up = nil
	catalystResult._up = nil
	catalystResult.filledType = "CATALYST"

	-- app.PrintDebug("Catalyst Result:",catalystResult.hash,catalystResult.up,app:SearchLink(catalystResult))
	-- app.PrintTable(catalystResult.bonuses)
	data._cata = catalystResult
	return catalystResult
end

local function catalyst_select_proper_tier_item(ResolveFunctions)
	local select, pop, contains, find, invtype, is, isnt =
		ResolveFunctions.select,
		ResolveFunctions.pop,
		ResolveFunctions.contains,
		ResolveFunctions.find,
		ResolveFunctions.invtype,
		ResolveFunctions.is,
		ResolveFunctions.isnt
	return function(finalized, searchResults, o, cmd, catalystID, trackID, classID, armorSlot, baseItem)

		-- Select the Catalyst Object
		-- TODO: need to standardize Catalyst data listings...
		-- 1 Catalyst per Tier, list entirely within respective Raid
		select(finalized, searchResults, o, "select", "catalystID", catalystID)
		-- app.PrintDebug("Found",#searchResults,"catalysts for",catalystID)

		-- PvP Items should have a separate Catalyst root
		local ispvp = baseItem.pvp
		if ispvp then
			is(finalized, searchResults, o, "is", "pvp")
			pop(finalized, searchResults)
			-- app.PrintDebug("find pvp version of catalyst",catalystID,app:SearchLink(baseItem),#searchResults)
		else
			isnt(finalized, searchResults, o, "isnt", "pvp")
		end

		-- Find the Upgrade Track
		-- TODO: if we have multiple pvp variants again probably have to revisit this
		if not ispvp then
			find(finalized, searchResults, o, "find", "trackID", trackID)
			-- app.PrintDebug("Track group contains",#searchResults,"groups")
			pop(finalized, searchResults)
		end

		-- Find the Class
		contains(finalized, searchResults, o, "contains", "c", classID)
		-- app.PrintDebug("Matching",#searchResults,"groups by c =",classID)
		pop(finalized, searchResults)	-- this includes the sym on the Class
		-- app.PrintDebug("Class group contains",#searchResults,"items")

		-- Match the slot
		local interchanges = CatalystInterchangeSlots[armorSlot]
		if interchanges then
			invtype(finalized, searchResults, o, "invtype", unpack(interchanges))
			-- app.PrintDebug("Filtered to",#searchResults,"via slot",unpack(interchanges))
		else
			invtype(finalized, searchResults, o, "invtype", armorSlot)
			-- app.PrintDebug("Filtered to",#searchResults,"via slot",armorSlot)
		end
	end
end

-- Event Handling
app.AddEventHandler("OnLoad", function()
	app.RegisterSymlinkSubroutine("catalyst_select_proper_tier_item", catalyst_select_proper_tier_item)
end)

app.AddEventHandler("OnLoad", function()
	local Fill = app.Modules.Fill
	if not Fill then return end

	local CreateObject = app.__CreateObject
	Fill.AddFiller("CATALYST",
	function(t, FillData)
		local catalystResult = t._cata or GetCatalyst(t)
		if not catalystResult then return end

		if not catalystResult.collected then
			t.filledCatalyst = true
		end
		-- app.PrintDebug("filledCatalyst=",catalystResult.modItemID,catalystResult.collected,"<",t.modItemID)
		local o = CreateObject(catalystResult)
		return { o };
	end,
	{
		ScopesIgnored = { "LIST" },
		SettingsIcon = app.asset("Interface_Catalyst"),
		SettingsTooltip = "Fills the Catalyst |T"..app.asset("Interface_Catalyst")..":0|t result of the current Item if one is possible and determined via ATT.\n\nNOTE: This Filler is not applied to ATT Lists."
	})
end)

-- TODO: some way to fill AccountMode/ItemUnbound Catalyst results. Since this typically only happens within Tooltips (other than Item link popouts)
-- we can dynamically add the extra Fill operation into the Fill sequence based on the Fill Source?? and also only when necessary based on Settings
-- potentially even the Fill sequence could then be split based on the Source being Filled instead of checking (Window/Tooltip)