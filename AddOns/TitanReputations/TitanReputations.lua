--[[
	Description: Titan Panel plugin that shows your Reputations
	Author: Eliote
--]]

local ADDON_NAME, L = ...;
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local VERSION = GetAddOnMetadata(ADDON_NAME, "Version")
local PLUGIN_ID = "TITAN_REPUTATION_XP"
local ICON = "Interface\\Icons\\INV_MISC_NOTE_02"

local Color = {}
Color.WHITE = "|cFFFFFFFF"
Color.RED = "|cFFDC2924"
Color.YELLOW = "|cFFFFF244"
Color.GREEN = "|cFF3DDC53"
Color.ORANGE = "|cFFE77324"

local SEX = UnitSex("player")

local GetFriendshipReputation = GetFriendshipReputation
if not GetFriendshipReputation and C_GossipInfo and C_GossipInfo.GetFriendshipReputation then
	GetFriendshipReputation = function(factionId)
		local info = C_GossipInfo.GetFriendshipReputation(factionId)
		if not info or not info.friendshipFactionID or info.friendshipFactionID == 0 then
			return
		end
		local texture = info.texture
		if (texture == 0) then
			texture = nil
		end
		--     friendID,                 friendRep,     _, _, friendText, texture, friendTextLevel, friendThreshold,     nextFriendThreshold
		return info.friendshipFactionID, info.standing, nil, nil, info.text, texture, info.reaction, info.reactionThreshold, info.nextThreshold
	end
end
GetFriendshipReputation = GetFriendshipReputation or nop

local IsMajorFaction = C_Reputation.IsMajorFaction or nop
local IsFactionParagon = C_Reputation.IsFactionParagon or nop
local GetMajorFactionData = C_MajorFactions and C_MajorFactions.GetMajorFactionData and C_MajorFactions.GetMajorFactionData or nop
local HasMaximumRenown = C_MajorFactions and C_MajorFactions.HasMaximumRenown and C_MajorFactions.HasMaximumRenown or nop
local GetCurrentRenownLevel = C_MajorFactions and C_MajorFactions.GetCurrentRenownLevel or nop
local GetNumFactions = GetNumFactions or C_Reputation.GetNumFactions

local IsFactionInactive = IsFactionInactive or function(...)
	return not C_Reputation.IsFactionActive(...)
end

local function unwrapFactionData(data)
	if not data then return nil end
	return data.name, data.description, data.reaction, data.currentReactionThreshold, data.nextReactionThreshold,
	data.currentStanding, data.atWarWith, data.canToggleAtWar, data.isHeader, data.isCollapsed, data.isHeaderWithRep,
	data.isWatched, data.isChild, data.factionID, data.hasBonusRepGain
end

--name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain
local GetFactionInfo = GetFactionInfo or function(factionIndex)
	local data = C_Reputation.GetFactionDataByIndex(factionIndex)
	return unwrapFactionData(data)
end
local GetFactionInfoByID = GetFactionInfoByID or function(factionID)
	local data = C_Reputation.GetFactionDataByID(factionID)
	return unwrapFactionData(data)
end

local GetWatchedFactionID = function()
	if (GetWatchedFactionInfo) then
		local _, _, _, _, _, factionID = GetWatchedFactionInfo()
		return factionID
	end
	local data = C_Reputation.GetWatchedFactionData()
	return data and data.factionID
end

local sessionStart = {}
local sessionStartMajorFaction = {}
local lastReps = {}

local defaultColors = {
	[1] = "FFCC2222",
	[2] = "FFFF0000",
	[3] = "FFEE6622",
	[4] = "FFFFFF00",
	[5] = "FF00FF00",
	[6] = "FF00FF88",
	[7] = "FF00FFCC",
	[8] = "FF00FFFF",
	paragon = "FF6DB3FF",
	renown = "FF00BFF3",
}

local defaultColorsSortedKeys = {}
for k, _ in pairs(defaultColors) do
	table.insert(defaultColorsSortedKeys, k)
end
table.sort(defaultColorsSortedKeys, function(a, b)
	if type(a) == type(b) then
		return a < b
	end
	return type(b) == "string"
end)

local function GetColors(id)
	local colors = {}
	for k, v in pairs(defaultColors) do
		colors[k] = "|c" .. (TitanGetVar(id, "ColorStanding" .. k) or v)
	end
	return colors
end

local function GetFactionLabel(standingId)
	if standingId == "paragon" then
		return L["Paragon"]
	end
	if (standingId == "renown") then
		return L["Renown"]
	end
	return GetText("FACTION_STANDING_LABEL" .. standingId, SEX)
end

local function MajorFactionTexture(majorFactionData)
	local kit = majorFactionData.textureKit
	if (not kit) then return nil end

	if (majorFactionData.expansionID >= 10) then
		-- yes, the new ones are in plural "MajorFaction[s]" ¯\_(ツ)_/¯
		return ([[Interface\Icons\UI_MajorFactions_%s]]):format(kit)
	end
	return ([[Interface\Icons\UI_MajorFaction_%s]]):format(kit)
end

local function GetSessionStartTable(factionId)
	if (not sessionStartMajorFaction[factionId]) then
		local data = GetMajorFactionData(factionId)
		if not data then return nil end
		sessionStartMajorFaction[factionId] = {
			startLvl = data.renownLevel,
			[data.renownLevel] = { start = 0, max = data.renownLevelThreshold }
		}
	end
	return sessionStartMajorFaction[factionId]
end

local function GetBalanceForMajorFaction(factionId, currentXp, currentLvl)
	local sessionTable = GetSessionStartTable(factionId)
	if not sessionTable then return 0 end
	local balance = 0
	local start = sessionTable.startLvl
	for i = start, currentLvl do
		local data = sessionTable[i]
		-- we might not have data yet if we just leveled and UPDATE_FACTION run before MAJOR_FACTION_RENOWN_LEVEL_CHANGED
		if (data) then
			local endXp = (currentLvl == i) and currentXp or data.max
			balance = balance + (endXp - data.start)
		end
	end
	return balance
end

local function GetParagonValues(barValue, factionId, colors, texture)
	local color = colors.paragon
	local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionId);
	local standingText = " (" .. GetFactionLabel("paragon") .. ")"
	if hasRewardPending then
		standingText = " (" .. GetFactionLabel("paragon") .. " |A:ParagonReputation_Bag:0:0|a" .. ")"
	end
	sessionStart[factionId] = sessionStart[factionId] or barValue
	local session = barValue - sessionStart[factionId]
	return mod(currentValue, threshold), threshold, color, standingText, hasRewardPending, session, texture
end

-- @return current, maximum, color, standingText, hasRewardPending, session, texture
local function GetValueAndMaximum(standingId, barValue, bottomValue, topValue, factionId, colors)
	if (IsMajorFaction(factionId)) then
		local data = GetMajorFactionData(factionId)
		local isCapped = HasMaximumRenown(factionId)
		local current = isCapped and data.renownLevelThreshold or data.renownReputationEarned or 0
		local standingText = " (" .. (RENOWN_LEVEL_LABEL .. data.renownLevel) .. ")"
		local session = GetBalanceForMajorFaction(factionId, current, data.renownLevel)
		local texture = MajorFactionTexture(data)
		if (IsFactionParagon(factionId)) then
			return GetParagonValues(barValue, factionId, colors, texture)
		end
		return current, data.renownLevelThreshold, colors.renown, standingText, nil, session, texture
	end

	if (standingId == nil) then
		return "0", "0", "|cFFFF0000", "??? - " .. (factionId .. "?")
	end

	if (IsFactionParagon(factionId)) then
		return GetParagonValues(barValue, factionId, colors)
	end

	local friendID, friendRep, _, _, _, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionId)
	if (friendID) then
		local standingText = " (" .. friendTextLevel .. ")"
		local color = colors[standingId] or colors[5]
		local maximum, current = 1, 1
		if (nextFriendThreshold) then
			maximum, current = nextFriendThreshold - friendThreshold, friendRep - friendThreshold
		end
		sessionStart[factionId] = sessionStart[factionId] or friendRep
		local session = friendRep - sessionStart[factionId]
		return current, maximum, color, standingText, nil, session, friendTexture
	end

	local current = barValue - bottomValue
	local maximum = topValue - bottomValue
	local color = colors[standingId] or colors[5]
	local standingText = " (" .. GetFactionLabel(standingId) .. ")"
	sessionStart[factionId] = sessionStart[factionId] or barValue
	local session = barValue - sessionStart[factionId]
	return current, maximum, color, standingText, nil, session
end

local function GetButtonMainRepInfo(self)
	local name, standingId, bottomValue, topValue, barValue, factionId, atWarWith, _
	factionId = TitanGetVar(self.registry.id, "LastUpdatedReputation")
	if (factionId and factionId ~= 0 and TitanGetVar(PLUGIN_ID, "SmartReputation") == 1) then
		name, _, standingId, bottomValue, topValue, barValue, atWarWith = GetFactionInfoByID(factionId)
	else
		factionId = GetWatchedFactionID()
		if (factionId) then
			name, _, standingId, bottomValue, topValue, barValue, atWarWith = GetFactionInfoByID(factionId)
		end
	end
	return {
		name = name,
		standingId = standingId,
		bottomValue = bottomValue,
		topValue = topValue,
		barValue = barValue,
		factionId = factionId,
		atWarWith = atWarWith
	}
end

local function GetButtonText(self, id)
	local info = GetButtonMainRepInfo(self, id)
	if not info or not info.name then
		return "", ""
	end
	local value, max, color, _, hasRewardPending, balance, texture = GetValueAndMaximum(
			info.standingId, info.barValue, info.bottomValue, info.topValue, info.factionId, GetColors(id)
	)
	self.registry.icon = texture or ICON

	local text = "" .. color

	local showvalue = TitanGetVar(id, "ShowValue")
	local hideMax = TitanGetVar(id, "HideMax")
	if showvalue then
		text = text .. value

		if not hideMax then
			text = text .. "/" .. max
		end
	end
	if TitanGetVar(id, "ShowPercent") then
		local percent = math.floor((value) * 100 / (max))
		if (max == 0) then
			percent = 100
		end

		if showvalue then
			text = text .. " (" .. percent .. "%)"
		else
			text = text .. percent .. "%"
		end

		if hasRewardPending then
			text = "*" .. text
		end
	end

	if TitanGetVar(id, "ShowSessionBalance") and balance > 0 then
		text = text .. " [" .. balance .. "]"
	end

	return info.name .. ":", text
end

local function IsNeutral(factionId, standingId)
	if (IsMajorFaction(factionId)) then
		return false
	end

	local friendID = GetFriendshipReputation(factionId)

	if friendID then
		return false
	end

	return standingId <= 4
end

local function MajorFactionMaxLevel(factionId)
	local list = C_MajorFactions.GetRenownLevels(factionId)
	return list[#list].level
end

local function IsMaxed(factionId, standingId)
	if (IsMajorFaction(factionId)) then
		return HasMaximumRenown(factionId) and GetCurrentRenownLevel(factionId) == MajorFactionMaxLevel(factionId)
	end

	local friendID, _, _, _, _, _, _, _, nextFriendThreshold = GetFriendshipReputation(factionId)

	if friendID then
		return not nextFriendThreshold
	end

	return standingId == 8
end

local function formatRep(nameColor, name, valueColor, value, max, standing, balance, texture, prefix)
	if (balance == 0) then
		balance = ""
	else
		balance = " [" .. balance .. "]"
	end

	texture = texture and (" |T" .. texture .. ":0|t") or ""
	prefix = prefix or ""

	return nameColor .. prefix .. name .. texture .. "\t" .. valueColor .. value .. "/" .. max .. standing .. balance .. "|r\n"
end

local function GetTooltipText(self, id)
	local text = ""

	local hideNeutral = TitanGetVar(id, "HideNeutral")
	local showHeaders = TitanGetVar(id, "ShowHeaders")
	local alwaysShowParagon = TitanGetVar(id, "AlwaysShowParagon")
	local colors = GetColors(id)

	local topText = ""
	do
		local info = GetButtonMainRepInfo(self, id)
		if (info and info.name) then
			local value, max, color, standing, _, balance, texture = GetValueAndMaximum(
					info.standingId, info.barValue, info.bottomValue, info.topValue, info.factionId, colors
			)
			local nameColor = (info.atWarWith and Color.RED) or ""
			topText = formatRep(nameColor, info.name, color, value, max, standing, balance, texture) .. "\n"
		end
	end

	local headerText
	local childText = ""

	local numFactions = GetNumFactions()
	for factionIndex = 1, numFactions do
		local name, _, standingId, bottomValue, topValue, earnedValue, atWarWith, _, isHeader, _, hasRep, isWatched, _, factionId = GetFactionInfo(factionIndex)

		if name then
			if isHeader and not hasRep then
				-- if the previous header has child
				if (headerText and childText ~= "") then
					text = text .. headerText .. childText
					headerText = nil
					childText = ""
				end

				if showHeaders then
					headerText = Color.WHITE .. name .. "|r\n"
				end
			else
				local hideExalted = TitanGetVar(id, "HideExalted")
				local show = true

				if IsFactionInactive(factionIndex) then
					show = false
				elseif hideNeutral and IsNeutral(factionId, standingId) then
					show = false
				elseif hideExalted and IsMaxed(factionId, standingId) then
					show = false
				end

				if (alwaysShowParagon and IsFactionParagon(factionId)) then
					show = true
				end

				if show then
					local value, max, color, standing, _, balance, texture = GetValueAndMaximum(standingId, earnedValue, bottomValue, topValue, factionId, colors)
					local nameColor = (atWarWith and Color.RED) or ""

					local prefix = "-"
					if isHeader then
						-- this is for headers with reputation
						nameColor = Color.WHITE
						prefix = ""
					end

					childText = childText .. formatRep(nameColor, name, color, value, max, standing, balance, texture, prefix)
				end
			end
		end
	end

	if (childText ~= "") then
		if (headerText) then
			text = text .. headerText
		end

		text = text .. childText
	end

	return topText .. text
end

local function PrepareSessionTable()
	local numFactions = GetNumFactions()
	for factionIndex = 1, numFactions do
		local name, _, _, _, _, earnedValue, _, _, _, _, _, _, _, factionId = GetFactionInfo(factionIndex)
		if (factionId) then
			local friendID, friendRep = GetFriendshipReputation(factionId)
			if (IsMajorFaction(factionId)) then
				local data = GetMajorFactionData(factionId)
				local isCapped = HasMaximumRenown(factionId)
				earnedValue = isCapped and data.renownLevelThreshold or data.renownReputationEarned or 0
				sessionStartMajorFaction[factionId] = {
					startLvl = data.renownLevel,
					[data.renownLevel] = { start = earnedValue, max = data.renownLevelThreshold },
				}
				sessionStart[factionId] = earnedValue
				lastReps[factionId] = {
					lvl = data.renownLevel,
					rep = data.renownReputationEarned,
				}
			elseif (friendID) then
				sessionStart[factionId] = friendRep
				lastReps[factionId] = friendRep
			elseif name then
				sessionStart[factionId] = earnedValue
				lastReps[factionId] = earnedValue
			end
		end
	end
end

local GUILD_ID = 1168
local lastUpdate = 0
local needUpdate = false

local function UpdateLastRepIfNeeded()
	-- the idea here, is to throttle how many times this runs, making sure the last update will eventually run
	if (not needUpdate or (GetTime() - lastUpdate < 5)) then
		return
	end

	needUpdate = false
	local numFactions = GetNumFactions()
	local lastUpdateId
	for factionIndex = 1, numFactions do
		local name, _, _, _, _, earnedValue, _, _, _, _, _, _, _, factionId = GetFactionInfo(factionIndex)
		if (factionId and factionId ~= GUILD_ID) then
			if (IsMajorFaction(factionId)) then
				local data = GetMajorFactionData(factionId)
				local lastValue = lastReps[factionId]
				lastReps[factionId] = {
					lvl = data.renownLevel,
					rep = data.renownReputationEarned,
				}
				if (not lastValue or (lastValue.lvl ~= data.renownLevel or lastValue.rep ~= data.renownReputationEarned)) then
					lastUpdateId = factionId
				end
			else
				local lastValue = lastReps[factionId]
				local friendID, friendRep = GetFriendshipReputation(factionId)
				if (friendID) then
					lastReps[factionId] = friendRep
				elseif name then
					lastReps[factionId] = earnedValue
				end
				if (lastValue ~= lastReps[factionId]) then
					lastUpdateId = factionId
				end
			end
		end
	end
	if (lastUpdateId) then
		TitanSetVar(PLUGIN_ID, "LastUpdatedReputation", lastUpdateId)
	end
end

local function OnUpdate()
	UpdateLastRepIfNeeded()
end

local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		PrepareSessionTable()

		self:SetScript("OnUpdate", OnUpdate)

		TitanPanelButton_UpdateButton(self.registry.id)
	end,
	UPDATE_FACTION = function(self)
		if (TitanGetVar(self.registry.id, "SmartReputation") == 1) then
			needUpdate = true
			UpdateLastRepIfNeeded()
		end
		TitanPanelButton_UpdateButton(self.registry.id)
	end,
}

if (C_Reputation.IsMajorFaction) then
	eventsTable.MAJOR_FACTION_RENOWN_LEVEL_CHANGED = function(self, factionId, newRenownLevel, oldRenownLevel)
		local data = GetMajorFactionData(factionId)
		if not data then return end
		GetSessionStartTable(factionId)[newRenownLevel] = { start = 0, max = data.renownLevelThreshold }
		TitanPanelButton_UpdateButton(self.registry.id)
	end
end

local function OnClick(self, button)
	if (button == "LeftButton") then
		ToggleCharacter("ReputationFrame");
	end
end

local subColor = {}
local savedVariables = {
	LastUpdatedReputation = 0,
}
for _, k in ipairs(defaultColorsSortedKeys) do
	local var = "ColorStanding" .. k
	savedVariables[var] = defaultColors[k]
	table.insert(subColor, {
		type = "button",
		text = GetFactionLabel(k),
		menuList = {
			{
				type = "color",
				text = COLOR,
				var = "ColorStanding" .. k,
				def = defaultColors[k]
			},
			{
				type = "button",
				text = L["Reset"],
				func = function()
					TitanSetVar(PLUGIN_ID, "ColorStanding" .. k, defaultColors[k])
					TitanPanelButton_UpdateButton(PLUGIN_ID)
				end
			}
		}
	})
end

local menus = {
	{ type = "rightSideToggle" },
	{ type = "toggle", text = L["HideNeutral"], var = "HideNeutral", def = false, keepShown = true },
	{ type = "toggle", text = L["ShowValue"], var = "ShowValue", def = true, keepShown = true },
	{ type = "toggle", text = L["ShowPercent"], var = "ShowPercent", def = true, keepShown = true },
	{ type = "toggle", text = L["ShowHeaders"], var = "ShowHeaders", def = true, keepShown = true },
	{ type = "toggle", text = L["HideMax"], var = "HideMax", def = false, keepShown = true },
	{ type = "toggle", text = L["HideExalted"], var = "HideExalted", def = false, keepShown = true },
	{ type = "toggle", text = L["AlwaysShowParagon"], var = "AlwaysShowParagon", def = true, keepShown = true },
	{ type = "toggle", text = L["ShowSessionBalance"], var = "ShowSessionBalance", def = false, keepShown = true },
	{ type = "toggle", text = L["SmartReputation"], var = "SmartReputation", def = false, keepShown = true },
	{ type = "space" },
	{ type = "button", text = COLORS, menuList = subColor }
}

LibStub("Elib-4.0").Register({
	id = PLUGIN_ID,
	name = L["Reputation"],
	tooltip = L["Reputation"],
	icon = "Interface\\Icons\\INV_MISC_NOTE_02",
	category = "Information",
	version = VERSION,
	getButtonText = GetButtonText,
	getTooltipText = GetTooltipText,
	eventsTable = eventsTable,
	menus = menus,
	onClick = OnClick,
	savedVariables = savedVariables
})


