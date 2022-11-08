AskMrRobotClassic = LibStub("AceAddon-3.0"):NewAddon("AskMrRobotClassic", "AceEvent-3.0", "AceConsole-3.0", "AceSerializer-3.0")
local Amr = AskMrRobotClassic
Amr.Serializer = LibStub("AskMrRobotClassic-Serializer")

Amr.ADDON_NAME = "AskMrRobotClassic"

-- types of inter-addon messages that we receive, used to parcel them out to the proper handlers
Amr.MessageTypes = {
	Version = "_V",
	VersionRequest = "_VR"
}

local L = LibStub("AceLocale-3.0"):GetLocale("AskMrRobotClassic", true)
local AceGUI = LibStub("AceGUI-3.0")

-- minimap icon and LDB support
local _amrLDB = LibStub("LibDataBroker-1.1"):NewDataObject(Amr.ADDON_NAME, {
	type = "launcher",
	text = "Ask Mr. Robot",
	icon = "Interface\\AddOns\\" .. Amr.ADDON_NAME .. "\\Media\\icon",
	OnClick = function(self, button, down)
		if button == "LeftButton" then
			--if IsControlKeyDown() then
			--	Amr:Wipe()
			--else
				Amr:Toggle()
			--end
		elseif button == "RightButton" then
			Amr:EquipGearSet()
		end
	end,
	OnTooltipShow = function(tt)
		tt:AddLine("Ask Mr. Robot", 1, 1, 1);
		tt:AddLine(" ");
		tt:AddLine(L.MinimapTooltip)
	end	
})
local _icon = LibStub("LibDBIcon-1.0")


-- initialize the database
local function initializeDb()

	local defaults = {
		char = {
			LastVersion = 0,           -- used to clean out old stuff	
			FirstUse = true,           -- true if this is first time use, gets cleared after seeing the export help splash window
			Talents = {},              -- for each spec, selected talents
			Glyphs = {},
			Equipped = {},             -- for each spec, slot id to item info
			BagItems = {},             -- list of item info for bags
			BankItems = {},            -- list of item info for bank
			BagItemsAndCounts = {},    -- used mainly for the shopping list
			BankItemsAndCounts = {},   -- used mainly for the shopping list			
			GearSetups = {},           -- imported gear sets
			JunkData = {},             -- imported data about items that can be vendored/scrapped/disenchanted
			ExtraEnchantData = {},     -- enchant id to enchant display information and material information
			Logging = {                -- character logging settings
				Enabled = false,       -- whether logging is currently on or not
				LastZone = nil,        -- last zone the player was in
				LastDiff = nil         -- last difficulty for the last zone the player was in
			}
		},
		profile = {
			minimap = {                -- minimap hide/show and position settings
				hide = false
			},
			window = {},               -- main window position settings
			shopWindow = {},           -- shopping list window position settings
			junkWindow = {},           -- junk list window position settings
			options = {
				autoGear = false,      -- auto-equip saved gear sets when changing specs
				junkVendor = false,    -- auto-show junk list at vendor/scrapper
				shopAh = false,        -- auto-show shopping list at AH
				disableEm = false,     -- disable auto-creation of equipment manager sets
				uiScale = 1            -- custom scale for AMR UI
			},
			Logging = {                -- global logging settings
				Auto = {}              -- for each instanceId, for each difficultyId, true if auto-logging enabled
			}
		},
		global = {
			Region = nil,              -- region that this user is in, all characters on the same account should be the same region
			Shopping2 = {}             -- shopping list data stored globally for access on any character
		}
	}
	
	Amr.db = LibStub("AceDB-3.0"):New("AskMrRobotDbClassic", defaults)
	
	-- set defaults for auto logging; if a new zone is added and some other stuff was turned on, turn on the new zone too
	local hasSomeLogging = false
	local addedLogging = {}
	for i, instanceId in ipairs(Amr.InstanceIdsOrdered) do
		local byDiff = Amr.db.profile.Logging.Auto[instanceId]
		if not byDiff then
			byDiff = {}
			Amr.db.profile.Logging.Auto[instanceId] = byDiff
			addedLogging[instanceId] = byDiff
		end
		
		for j, difficultyId in ipairs(Amr.InstanceDifficulties[instanceId]) do
			if not byDiff[difficultyId] then
				byDiff[difficultyId] = false
			else
				hasSomeLogging = true
			end
		end

		if #Amr.InstanceDifficulties[instanceId] < 4 then
			byDiff[3] = nil
			byDiff[4] = nil
		end
	end	

	for k,v in pairs(Amr.db.profile.Logging.Auto) do
		if not Amr.IsSupportedInstanceId(k) then
			Amr.db.profile.Logging.Auto[k] = nil
		end		
	end
	
	if hasSomeLogging then		
		for instanceId, byDiff in pairs(addedLogging) do
			for j, difficultyId in ipairs(Amr.InstanceDifficulties[instanceId]) do
				byDiff[difficultyId] = true
			end
		end
	end
	
	-- upgrade old gear set info to new format
	if Amr.db.char.GearSets then
		Amr.db.char.GearSets = nil
	end

	if not Amr.db.char.GearSetups then
		Amr.db.char.GearSetups = {}
	end

	if Amr.db.global.Shopping then
		Amr.db.global.Shopping = nil
	end
	
	Amr.db.RegisterCallback(Amr, "OnProfileChanged", "RefreshConfig")
	Amr.db.RegisterCallback(Amr, "OnProfileCopied", "RefreshConfig")
	Amr.db.RegisterCallback(Amr, "OnProfileReset", "RefreshConfig")
end

function Amr:OnInitialize()
    
	initializeDb()

	Amr:RegisterChatCommand("amr", "SlashCommand")
	
	_icon:Register(Amr.ADDON_NAME, _amrLDB, self.db.profile.minimap)	
end

local _enteredWorld = false
local _pendingInit = false

-- upgrade some stuff from old to new formats
local function upgradeFromOld()

	local currentVersion = tonumber(GetAddOnMetadata(Amr.ADDON_NAME, "Version"))

	
	Amr.db.char.LastVersion = currentVersion

end

local function finishInitialize()

	-- record region, the only thing that we still can't get from the log file
	Amr.db.global.Region = Amr.RegionNames[GetCurrentRegion()]
	
	-- make sure that some initialization is deferred until after PLAYER_ENTERING_WORLD event so that data we need is available;
	-- also delay this initialization for a few extra seconds to deal with some event spam that is otherwise hard to identify and ignore when a player logs in
	Amr.Wait(5, function()
		Amr:InitializeGear()
		Amr:InitializeExport()
		Amr:InitializeCombatLog()

		upgradeFromOld()
	end)
end

local function onPlayerEnteringWorld()

	_enteredWorld = true
	
	if _pendingInit then
		finishInitialize()
		_pendingInit = false
	end
end

function Amr:OnEnable()
    
	-- update based on current configuration whenever enabled
	self:RefreshConfig()
	
	-- if we have fully entered the world, do initialization; otherwise wait for PLAYER_ENTERING_WORLD to continue
	if not _enteredWorld then
		_pendingInit = true
	else
		_pendingInit = false
		finishInitialize()
	end
end

function Amr:OnDisable()
	-- disabling is not supported
end

local function onEnterCombat()
	Amr:Hide()
	Amr:HideShopWindow()
	Amr:HideJunkWindow()
end


----------------------------------------------------------------------------------------
-- Slash Commands
----------------------------------------------------------------------------------------
local _slashMethods = {
	hide      = "Hide",
	show      = "Show",
	toggle    = "Toggle",
	equip     = "EquipGearSet",
	--version   = "PrintVersions",
	junk      = "ShowJunkWindow",
	reset     = "Reset",
	test      = "Test"
}

function Amr:SlashCommand(input)
	input = string.lower(input)
	local parts = {}
	for w in input:gmatch("%S+") do 
		table.insert(parts, w) 
	end
	
	if #parts == 0 then return end
	
	local func = _slashMethods[parts[1]]
	if not func then return end
	
	local funcArgs = {}
	for i = 2, #parts do
		table.insert(funcArgs, parts[i])
	end
	
	Amr[func](Amr, unpack(funcArgs))
end


----------------------------------------------------------------------------------------
-- Configuration
----------------------------------------------------------------------------------------

-- refresh all state based on the current values of configuration options
function Amr:RefreshConfig()
	
	self:UpdateMinimap()	
	self:RefreshOptionsUi()
	self:RefreshLogUi()
end

function Amr:UpdateMinimap()

	if self.db.profile.minimap.hide or not Amr:IsEnabled() then
		_icon:Hide(Amr.ADDON_NAME)
	else
		-- change icon color if logging
		if Amr:IsLogging() then
			_amrLDB.icon = 'Interface\\AddOns\\AskMrRobotClassic\\Media\\icon_green'
		else
			_amrLDB.icon = 'Interface\\AddOns\\AskMrRobotClassic\\Media\\icon'
		end
		
		_icon:Show(Amr.ADDON_NAME)
	end
end


----------------------------------------------------------------------------------------
-- Generic Helpers
----------------------------------------------------------------------------------------

local _waitTable = {}
local _waitFrame = nil

-- execute the specified function after the specified delay (in seconds)
function Amr.Wait(delay, func, ...)
	if not _waitFrame then
		_waitFrame = CreateFrame("Frame", "AmrWaitFrame", UIParent)
		_waitFrame:SetScript("OnUpdate", function (self, elapse)
			local count = #_waitTable
			local i = 1
			while(i <= count) do
				local waitRecord = table.remove(_waitTable, i)
				local d = table.remove(waitRecord, 1)
				local f = table.remove(waitRecord, 1)
				local p = table.remove(waitRecord, 1)
				if d > elapse then
					table.insert(_waitTable, i, { d-elapse, f, p })
					i = i + 1
				else
					count = count - 1
					f(unpack(p))
				end
			end
		end)
	end
	table.insert(_waitTable, { delay, func, {...} })
	return true
end

-- helper to iterate over a table in order by its keys
function Amr.spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function Amr.StartsWith(str, prefix)
	if string.len(str) < string.len(prefix) then return false end
	return string.sub(str, 1, string.len(prefix)) == prefix
end

function Amr.IsEmpty(table)
	return next(table) == nil
end

function Amr.Contains(table, value)
	if not table then return false end
	for k,v in pairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

-- helper to determine if we can equip an item (it is soulbound)
function Amr:CanEquip(bagId, slotId)
	local item = Item:CreateFromBagAndSlot(bagId, slotId)
	if item then
		local loc = item:GetItemLocation()
		return C_Item.IsBound(loc)
	else
		-- for now just return true if we can't find the item... will get an error trying to equip if it isn't bound
		return true
	end

	--local tt = Amr.GetItemTooltip(bagId, slotId)
	--if self:IsTextInTooltip(tt, ITEM_SOULBOUND) then return true end
	--if self:IsTextInTooltip(tt, ITEM_BNETACCOUNTBOUND) then return true end
	--if self:IsTextInTooltip(tt, ITEM_ACCOUNTBOUND) then return true end
end

-- helper to determine if an item has a unique constraint
--[[
function Amr:IsUnique(bagId, slotId)
	local tt = Amr.GetItemTooltip(bagId, slotId)
	if self:IsTextInTooltip(tt, ITEM_UNIQUE_EQUIPPABLE)	then return true end
	if self:IsTextInTooltip(tt, ITEM_UNIQUE) then return true end
	return false
end
]]


----------------------------------------------------------------------------------------
-- Events
----------------------------------------------------------------------------------------
local _eventHandlers = {}

local function handleEvent(eventName, ...)
	local list = _eventHandlers[eventName]
	if list then
		--print(eventName .. " handled")
		for i, handler in ipairs(list) do
			if type(handler) == "function" then
				handler(select(1, ...))
			else
				Amr[handler](Amr, select(1, ...))
			end
		end
	end
end

-- WoW and Ace seem to work on a "one handler" kind of approach to events (as far as I can tell from the sparse documentation of both).
-- This is a simple wrapper to allow adding multiple handlers to the same event, thus allowing better encapsulation of code from file to file.
function Amr:AddEventHandler(eventName, methodOrName)
	local list = _eventHandlers[eventName]
	if not list then
		list = {}
		_eventHandlers[eventName] = list
		Amr:RegisterEvent(eventName, handleEvent)
	end
	table.insert(list, methodOrName)
end

Amr:AddEventHandler("PLAYER_ENTERING_WORLD", onPlayerEnteringWorld)

Amr:AddEventHandler("PLAYER_REGEN_DISABLED", onEnterCombat)

----------------------------------------------------------------------------------------
-- Debugging
----------------------------------------------------------------------------------------
function Amr:dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. Amr:dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
end

function Amr:Test()
	
	--[[
	--932 aldor
	--934 scryer

	local numFactions = GetNumFactions()
	local factionIndex = 1
	while (factionIndex <= numFactions) do
		local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar,
			isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex)
		if isHeader and isCollapsed then
			ExpandFactionHeader(factionIndex)
			numFactions = GetNumFactions()
		end
		if hasRep or not isHeader then
			DEFAULT_CHAT_FRAME:AddMessage(factionID .. " " .. name .. " - " .. earnedValue)
		end
		factionIndex = factionIndex + 1
	end
	]]

end
