--[[
	Description: Titan Panel plugin that shows your Reputations
	Author: Eliote
--]]

local ADDON_NAME, L = ...;
local VERSION = GetAddOnMetadata(ADDON_NAME, "Version")

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
local GetMajorFactionData = C_MajorFactions and C_MajorFactions.GetMajorFactionData and C_MajorFactions.GetMajorFactionData or nop
local HasMaximumRenown = C_MajorFactions and C_MajorFactions.HasMaximumRenown and C_MajorFactions.HasMaximumRenown or nop
local GetCurrentRenownLevel = C_MajorFactions and C_MajorFactions.GetCurrentRenownLevel or nop

local sessionStart = {}
local sessionStartMajorFaction = {}

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

local function GetBalanceForMajorFaction(factionId, currentXp, currentLvl)
	if (not sessionStartMajorFaction[factionId]) then
		local data = GetMajorFactionData(factionId)
		sessionStartMajorFaction[factionId] = {
			startLvl = data.renownLevel,
			[data.renownLevel] = { start = 0, max = data.renownLevelThreshold }
		}
	end
	local balance = 0
	local start = sessionStartMajorFaction[factionId].startLvl
	for i = start, currentLvl do
		local data = sessionStartMajorFaction[factionId][i]
		-- we might not have data yet if we just leveled and UPDATE_FACTION run before MAJOR_FACTION_RENOWN_LEVEL_CHANGED
		if (data) then
			local endXp = (currentLvl == i) and currentXp or data.max
			balance = balance + (endXp - data.start)
		end
	end
	return balance
end

-- @return current, maximun, color, standingText
local function GetValueAndMaximum(standingId, barValue, bottomValue, topValue, factionId, colors)
	if (IsMajorFaction(factionId)) then
		local data = GetMajorFactionData(factionId)
		local isCapped = HasMaximumRenown(factionId)
		local current = isCapped and data.renownLevelThreshold or data.renownReputationEarned or 0
		local standingText = " (" .. (RENOWN_LEVEL_LABEL .. data.renownLevel) .. ")"
		local session = GetBalanceForMajorFaction(factionId, current, data.renownLevel)
		return current, data.renownLevelThreshold, colors.renown, standingText, nil, session
	end

	if (standingId == nil) then
		return "0", "0", "|cFFFF0000", "??? - " .. (factionId .. "?")
	end

	if (C_Reputation.IsFactionParagon(factionId)) then
		local color = colors.paragon
		local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionId);
		local standingText = " (" .. GetFactionLabel("paragon") .. ")"
		if hasRewardPending then
			standingText = " (" .. GetFactionLabel("paragon") .. " |A:ParagonReputation_Bag:0:0|a" .. ")"
		end
		sessionStart[factionId] = sessionStart[factionId] or barValue
		local session = barValue - sessionStart[factionId]
		return mod(currentValue, threshold), threshold, color, standingText, hasRewardPending, session
	end

	local friendID, friendRep, _, _, _, _, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionId)
	if (friendID) then
		local standingText = " (" .. friendTextLevel .. ")"
		local color = colors[standingId] or colors[5]
		local maximun, current = 1, 1
		if (nextFriendThreshold) then
			maximun, current = nextFriendThreshold - friendThreshold, friendRep - friendThreshold
		end
		sessionStart[factionId] = sessionStart[factionId] or friendRep
		local session = friendRep - sessionStart[factionId]
		return current, maximun, color, standingText, nil, session
	end

	local current = barValue - bottomValue
	local maximun = topValue - bottomValue
	local color = colors[standingId] or colors[5]
	local standingText = " (" .. GetFactionLabel(standingId) .. ")"
	sessionStart[factionId] = sessionStart[factionId] or barValue
	local session = barValue - sessionStart[factionId]
	return current, maximun, color, standingText, nil, session
end

local function GetButtonText(self, id)
	local name, standingID, bottomValue, topValue, barValue, factionId = GetWatchedFactionInfo()

	if not name then
		return "", ""
	end
	local value, max, color, _, hasRewardPending, balance = GetValueAndMaximum(standingID, barValue, bottomValue, topValue, factionId, GetColors(id))

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
			text = "*" + text
		end
	end

	if TitanGetVar(id, "ShowSessionBalance") and balance > 0 then
		text = text .. " [" .. balance .. "]"
	end

	return name .. ":", text
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

local function formatRep(nameColor, name, valueColor, value, max, standing, balance)
	if (balance == 0) then
		balance = ""
	else
		balance = " [" .. balance .. "]"
	end

	return nameColor .. name .. "\t" .. valueColor .. value .. "/" .. max .. standing .. balance .. "|r\n"
end

local function GetTooltipText(self, id)
	local text = ""

	local hideNeutral = TitanGetVar(id, "HideNeutral")
	local showHeaders = TitanGetVar(id, "ShowHeaders")
	local alwaysShowParagon = TitanGetVar(id, "AlwaysShowParagon")

	local numFactions = GetNumFactions()

	local topText = ""

	local headerText
	local childText = ""

	local colors = GetColors(id)

	for factionIndex = 1, numFactions do
		local name, _, standingId, bottomValue, topValue, earnedValue, atWarWith, _, isHeader, _, hasRep, isWatched, _, factionId, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex)

		if name then
			if isWatched then
				local value, max, color, standing, _, balance = GetValueAndMaximum(standingId, earnedValue, bottomValue, topValue, factionId, colors)
				local nameColor = (atWarWith and Color.RED) or ""

				topText = formatRep(nameColor, name, color, value, max, standing, balance) .. "\n"
			end

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

				if (alwaysShowParagon and C_Reputation.IsFactionParagon(factionId)) then
					show = true
				end

				if show then
					local value, max, color, standing, _, balance = GetValueAndMaximum(standingId, earnedValue, bottomValue, topValue, factionId, colors)
					local nameColor = (atWarWith and Color.RED) or ""

					local prefix = "-"
					if isHeader then
						-- this is for headers with reputation
						nameColor = Color.WHITE
						prefix = ""
					end

					childText = childText .. prefix .. formatRep(nameColor, name, color, value, max, standing, balance)
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

local function prepareSessionTable()
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
			elseif (friendID) then
				sessionStart[factionId] = friendRep
			elseif name then
				sessionStart[factionId] = earnedValue
			end
		end
	end
end

local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		prepareSessionTable()

		TitanPanelButton_UpdateButton(self.registry.id)
	end,
	UPDATE_FACTION = function(self)
		TitanPanelButton_UpdateButton(self.registry.id)
	end,
}

if (C_Reputation.IsMajorFaction) then
	eventsTable.MAJOR_FACTION_RENOWN_LEVEL_CHANGED = function(self, factionId, newRenownLevel, oldRenownLevel)
		local data = GetMajorFactionData(factionId)
		sessionStartMajorFaction[factionId][newRenownLevel] = { start = 0, max = data.renownLevelThreshold }
		TitanPanelButton_UpdateButton(self.registry.id)
	end
end

local function OnClick(self, button)
	if (button == "LeftButton") then
		ToggleCharacter("ReputationFrame");
	end
end

local subColor = {}
for _, k in ipairs(defaultColorsSortedKeys) do
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
					TitanSetVar("TITAN_REPUTATION_XP", "ColorStanding" .. k, defaultColors[k])
					TitanPanelButton_UpdateButton("TITAN_REPUTATION_XP")
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
	{ type = "space" },
	{ type = "button", text = COLORS, menuList = subColor }
}

LibStub("Elib-4.0").Register({
	id = "TITAN_REPUTATION_XP",
	name = L["Reputation"],
	tooltip = L["Reputation"],
	icon = "Interface\\Icons\\INV_MISC_NOTE_02",
	category = "Information",
	version = VERSION,
	getButtonText = GetButtonText,
	getTooltipText = GetTooltipText,
	eventsTable = eventsTable,
	menus = menus,
	onClick = OnClick
})


