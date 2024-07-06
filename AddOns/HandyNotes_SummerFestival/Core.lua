
------------------------------------------
--  This addon was heavily inspired by  --
--    HandyNotes_Lorewalkers            --
--    HandyNotes_LostAndFound           --
--  by Kemayo                           --
------------------------------------------

---Updated for Classic/TBC by Venomisto (Novaspark-Arugal) with permission from Ravendwyr the original author.
---This versions works for all 3 game clients Classic/TBC/Retail and loads what bonfires are needed for each.
---Notes of things changed:
---Updated all mapid's to work with classic, zones have diff mapid's than retail.
---Uupdated all bonfire coords for TBC/Classic positions.
---Added TBC/Classic function to check completed quests GetQuestsCompleted().
---Disabled calender events for TBC/Classic.
---"continents" table seperation for game versions.
---"notes" table seperation for game versions.
---Removed some bonfires that don't exist pre-cata.
---Added South Shore and Thousand Needles bonfires that only exists pre-cata.
---Added always enabled for TBC/Vanilla version, dates checks need to be added after this event ends for next year.
---There's no C_Calendar and current event (2021) is manually spawned by Blizzard and not the usual spawn time.
---Updated many bonfire locations for Cata.
---Added Dragonflight locations.


-- declaration
local _, SummerFestival = ...
SummerFestival.points = {}
SummerFestival.expansionNum = 1;
if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
	SummerFestival.isClassic = true
elseif (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC) then
	SummerFestival.isTBC = true
	SummerFestival.expansionNum = 2;
elseif (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC) then
	SummerFestival.isWrath = true
	SummerFestival.expansionNum = 3;
elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) then
	SummerFestival.isCata = true
	SummerFestival.expansionNum = 4;
elseif (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
	SummerFestival.isRetail = true
	SummerFestival.expansionNum = 10;
end
local HereBeDragons = LibStub("HereBeDragons-2.0", true);
local GetAllCompletedQuestIDs = GetAllCompletedQuestIDs or C_QuestLog.GetAllCompletedQuestIDs;

-- our db and defaults
local db
local defaults = { profile = { completed = false, icon_scale = 1.4, icon_alpha = 0.8 } }

--Map IDs updated for classic TBC by Novaspark-Arugal.
local continents = {}
if (SummerFestival.isClassic) then
	continents[1414] = true -- Kalimdor
	continents[1415] = true -- Eastern Kingdoms
	continents[947] = true -- Azeroth
elseif (SummerFestival.isTBC) then
	continents[1414] = true -- Kalimdor
	continents[1415] = true -- Eastern Kingdoms
	continents[1945] = true -- Outland
	continents[947] = true -- Azeroth
elseif (SummerFestival.isWrath) then
	--Old classic map ids up till tbc, then retail map id for northrend?
	continents[1414] = true -- Kalimdor
	continents[1415] = true -- Eastern Kingdoms
	continents[1945] = true -- Outland
	continents[947] = true -- Azeroth
	continents[113] = true -- Northrend
elseif (SummerFestival.isCata) then
	continents[1414] = true -- Kalimdor
	continents[1415] = true -- Eastern Kingdoms
	continents[1945] = true -- Outland
	continents[947] = true -- Azeroth
	continents[113] = true -- Northrend
else
	continents[12]  = true -- Kalimdor
	continents[13]  = true -- Eastern Kingdoms
	continents[101] = true -- Outland
	continents[113] = true -- Northrend
	continents[203] = true -- Vashj'ir
	continents[224] = true -- Stranglethorn Vale
	continents[424] = true -- Pandaria
	continents[572] = true -- Draenor
	continents[619] = true -- Broken Isles
	continents[875] = true -- Zandalar
	continents[876] = true -- Kul Tiras
	continents[947] = true -- Azeroth
end

local notes = {}
if (SummerFestival.expansionNum > 3) then
	-- Arathi
	notes["11732"] = "Speak to Zidormi at the south of the zone to gain access to this bonfire."
	notes["11764"] = "Speak to Zidormi at the south of the zone to gain access to this bonfire."
	notes["11804"] = "Speak to Zidormi at the south of the zone to gain access to this bonfire."
	notes["11840"] = "Speak to Zidormi at the south of the zone to gain access to this bonfire."

	-- Blasted Lands
	notes["11737"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire."
	notes["11808"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire."
	notes["28917"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire."
	notes["28930"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire."

	-- Darkshore
	notes["11740"] = "Speak to Zidormi in Darkshore to gain access to Lor'danel."
	notes["11811"] = "Speak to Zidormi in Darkshore to gain access to Lor'danel."

	-- Silithus
	notes["11760"] = "Speak to Zidormi at the north-east of the zone to gain access to this bonfire."
	notes["11800"] = "Speak to Zidormi at the north-east of the zone to gain access to this bonfire."
	notes["11831"] = "Speak to Zidormi at the north-east of the zone to gain access to this bonfire."
	notes["11836"] = "Speak to Zidormi at the north-east of the zone to gain access to this bonfire."

	-- Teldrassil
	notes["9332"]  = "Speak to Zidormi in Darkshore to gain access to Darnassus."
	notes["11753"] = "Speak to Zidormi in Darkshore to gain access to Teldrassil."
	notes["11824"] = "Speak to Zidormi in Darkshore to gain access to Teldrassil."

	-- Tirisfal Glades
	notes["9326"]  = "Speak to Zidormi in Tirisfal to gain access to The Undercity."
	notes["11786"] = "Speak to Zidormi in Tirisfal to gain access to Brill."
	notes["11862"] = "Speak to Zidormi in Tirisfal to gain access to Brill."
end


-- upvalues
local C_Calendar = _G.C_Calendar
local C_DateAndTime = _G.C_DateAndTime
local C_Map = _G.C_Map
local C_QuestLog = _G.C_QuestLog
local C_Timer_After = _G.C_Timer.After
local GameTooltip = _G.GameTooltip
local IsControlKeyDown = _G.IsControlKeyDown
local UIParent = _G.UIParent

local LibStub = _G.LibStub
local HandyNotes = _G.HandyNotes
local TomTom = _G.TomTom

local completedQuests = {}
local points = SummerFestival.points


-- plugin handler for HandyNotes
function SummerFestival:OnEnter(mapFile, coord)
	if self:GetCenter() > UIParent:GetCenter() then -- compare X coordinate
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	local point = points[mapFile] and points[mapFile][coord]
	local text
	local questID, mode = point:match("(%d+):(.*)")

	if mode == "H" then -- honour the flame
		text = "Honour the Flame"
	elseif mode == "D" then -- desecrate this fire
		text = "Desecrate this Fire"
	elseif mode == "C" then -- stealing the enemy's flame
		text = "Capture the City's Flame"
	end

	GameTooltip:SetText(text)

	if notes[questID] then
		GameTooltip:AddLine(notes[questID])
		GameTooltip:AddLine(" ")
	end

	if TomTom then
		GameTooltip:AddLine("Right-click to set a waypoint.", 1, 1, 1)
		GameTooltip:AddLine("Control-Right-click to set waypoints to every bonfire.", 1, 1, 1)
	end

	GameTooltip:Show()
end

function SummerFestival:OnLeave()
	GameTooltip:Hide()
end


local function createWaypoint(mapFile, coord)
	local x, y = HandyNotes:getXY(coord)
	local point = points[mapFile] and points[mapFile][coord]

	TomTom:AddWaypoint(mapFile, x, y, { title = "Midsummer Bonfire", persistent = nil, minimap = true, world = true })
end

local function createAllWaypoints()
	local questID, mode

	for mapFile, coords in next, points do
		if not continents[mapFile] then
		for coord, value in next, coords do
			questID, mode = value:match("(%d+):(.*)")

			if coord and (db.completed or not completedQuests[tonumber(questID)]) then
				createWaypoint(mapFile, coord)
			end
		end
		end
	end
	TomTom:SetClosestWaypoint()
end

function SummerFestival:OnClick(button, down, mapFile, coord)
	if TomTom and button == "RightButton" and not down then
		if IsControlKeyDown() then
			createAllWaypoints()
		else
			createWaypoint(mapFile, coord)
		end
	end
end


do
	-- custom iterator we use to iterate over every node in a given zone
	local function iterator(t, prev)
		if not SummerFestival.isEnabled then return end
		if not t then return end

		local coord, value = next(t, prev)
		while coord do
			local questID, mode = value:match("(%d+):(.*)")
			local icon

			if mode == "H" then -- honour the flame
				icon = "interface\\icons\\inv_summerfest_firespirit"
			elseif mode == "D" then -- desecrate this fire
				icon = "interface\\icons\\spell_fire_masterofelements"
			elseif mode == "C" then -- stealing the enemy's flame
				icon = "interface\\icons\\spell_fire_flameshock"
			end

			if value and (db.completed or not completedQuests[tonumber(questID)]) then
				return coord, nil, icon, db.icon_scale, db.icon_alpha
			end

			coord, value = next(t, coord)
		end
	end

	function SummerFestival:GetNodes2(mapID)
		return iterator, points[mapID]
	end
end


-- config
local options = {
	type = "group",
	name = "Midsummer Festival",
	desc = "Midsummer Fesitval bonfire locations.",
	get = function(info) return db[info[#info]] end,
	set = function(info, v)
		db[info[#info]] = v
		SummerFestival:Refresh()
	end,
	args = {
		desc = {
			name = "These settings control the look and feel of the icon.",
			type = "description",
			order = 1,
		},
		completed = {
			name = "Show completed",
			desc = "Show icons for bonfires you have already visited.",
			type = "toggle",
			width = "full",
			arg = "completed",
			order = 2,
		},
		icon_scale = {
			type = "range",
			name = "Icon Scale",
			desc = "Change the size of the icons.",
			min = 0.25, max = 2, step = 0.01,
			arg = "icon_scale",
			order = 3,
		},
		icon_alpha = {
			type = "range",
			name = "Icon Alpha",
			desc = "Change the transparency of the icons.",
			min = 0, max = 1, step = 0.01,
			arg = "icon_alpha",
			order = 4,
		},
	},
}


-- check
local setEnabled = false
local function CheckEventActive()
	if (SummerFestival.isClassic or SummerFestival.isTBC) then
		--Always enabled in TBC/Classic, there's no C_Calendar and blizzard has been manually changing the dates.
		--Some kind of date check for the standard spawn date should be added for next year after the current fesival ends.
		setEnabled = true;
	else
		local calendar = C_DateAndTime.GetCurrentCalendarTime()
		local month, day, year = calendar.month, calendar.monthDay, calendar.year
		local hour, minute = calendar.hour, calendar.minute
	
		local monthInfo = C_Calendar.GetMonthInfo()
		local curMonth, curYear = monthInfo.month, monthInfo.year
	
		local monthOffset = -12 * (curYear - year) + month - curMonth
		local numEvents = C_Calendar.GetNumDayEvents(monthOffset, day)
	
		for i=1, numEvents do
			local event = C_Calendar.GetDayEvent(monthOffset, day, i)
	
			if event.iconTexture == 235472 or event.iconTexture == 235473 or event.iconTexture == 235474 then
				setEnabled = event.sequenceType == "ONGOING" -- or event.sequenceType == "INFO"
	
				if event.sequenceType == "START" then
					setEnabled = hour >= event.startTime.hour and (hour > event.startTime.hour or minute >= event.startTime.minute)
				elseif event.sequenceType == "END" then
					setEnabled = hour <= event.endTime.hour and (hour < event.endTime.hour or minute <= event.endTime.minute)
				end
			end
		end
	end
	if setEnabled and not SummerFestival.isEnabled then
		if (GetQuestsCompleted) then
			for id, _ in pairs(GetQuestsCompleted()) do
				completedQuests[id] = true
			end
		elseif (GetAllCompletedQuestIDs) then
			for _, id in ipairs(GetAllCompletedQuestIDs()) do
				completedQuests[id] = true
			end
		end
		
		SummerFestival.isEnabled = true
		SummerFestival:Refresh()
		SummerFestival:RegisterEvent("QUEST_TURNED_IN", "Refresh")

		HandyNotes:Print("The Midsummer Fire Festival has begun!  Locations of bonfires are now marked on your map.")
	elseif not setEnabled and SummerFestival.isEnabled then
		SummerFestival.isEnabled = false
		SummerFestival:Refresh()
		SummerFestival:UnregisterAllEvents()

		HandyNotes:Print("The Midsummer Fire Festival has ended.  See you next year!")
	end
end

local function RepeatingCheck()
	CheckEventActive()
	C_Timer_After(60, RepeatingCheck)
end


-- initialise
function SummerFestival:OnEnable()
	self.isEnabled = false

	if not HereBeDragons then
		HandyNotes:Print("Your installed copy of HandyNotes is out of date and the Summer Festival plug-in will not work correctly.  Please update HandyNotes to version 1.5.0 or newer.")
		return
	end

	if (not SummerFestival.isClassic and not SummerFestival.isTBC) then
		-- special treatment for Teldrassil as C_Map.GetMapChildrenInfo() isn't recognising it as a "child zone" of Kalimdor at the moment
		if UnitFactionGroup("player") == "Alliance" then
			points[12] = {
				[43611031] = "11824:H", -- Dolanaar
			}
		elseif UnitFactionGroup("player") == "Horde" then
			points[12] = {
				[43541026] = "11753:D", -- Dolanaar
				[40370935] = "9332:C",  -- Stealing Darnassus' Flame
			}
		end
	end
	
	for continentMapID in next, continents do
		local children = C_Map.GetMapChildrenInfo(continentMapID, nil, true)
		for _, map in next, children do
			local coords = points[map.mapID]
			if coords then
				for coord, criteria in next, coords do
					local mx, my = HandyNotes:getXY(coord)
					local cx, cy = HereBeDragons:TranslateZoneCoordinates(mx, my, map.mapID, continentMapID)
					if cx and cy then
						points[continentMapID] = points[continentMapID] or {}
						points[continentMapID][HandyNotes:getCoord(cx, cy)] = criteria
					end
				end
			end
		end
	end

	local calendar = C_DateAndTime.GetCurrentCalendarTime()
	if (not SummerFestival.isClassic and not SummerFestival.isTBC) then
		C_Calendar.SetAbsMonth(calendar.month, calendar.year)
	end
	CheckEventActive()

	HandyNotes:RegisterPluginDB("SummerFestival", self, options)
	db = LibStub("AceDB-3.0"):New("HandyNotes_SummerFestivalDB", defaults, "Default").profile
	if (not SummerFestival.isClassic and not SummerFestival.isTBC) then
		self:RegisterEvent("CALENDAR_UPDATE_EVENT", CheckEventActive)
		self:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST", CheckEventActive)
	end
	self:RegisterEvent("ZONE_CHANGED", CheckEventActive)
	
	C_Timer_After(60, RepeatingCheck)
end

function SummerFestival:Refresh(_, questID)
	if questID then completedQuests[questID] = true end
	self:SendMessage("HandyNotes_NotifyUpdate", "SummerFestival")
end


-- activate
LibStub("AceAddon-3.0"):NewAddon(SummerFestival, "HandyNotes_SummerFestival", "AceEvent-3.0")


--Debug stuff for recording data.
--[[function MS_COORDS()
	local x, y, zone = HereBeDragons:GetPlayerZonePosition();
	x = string.sub(string.match(x, "0%.(%d+)"), 1, 4);
	y = string.sub(string.match(y, "0%.(%d+)"), 1, 4);
	print("Zone:", zone);
	print("[" .. x .. y .. "] = \"0:\",");
end

local f = CreateFrame("Frame", "NRCRaidBres");
f:RegisterEvent("QUEST_TURNED_IN");
f:SetScript('OnEvent', function(self, event, ...)
	if (event == "QUEST_TURNED_IN") then
		local questID = ...;
		local x, y, zone = HereBeDragons:GetPlayerZonePosition();
		x = string.sub(string.match(x, "0%.(%d+)"), 1, 4);
		y = string.sub(string.match(y, "0%.(%d+)"), 1, 4);
		local type = "";
		local GetQuestInfo = C_QuestLog.GetQuestInfo or C_QuestLog.GetTitleForQuestID;
		local questName = GetQuestInfo(questID);
		if (questName == "Honor the Flame") then
			type = "H";
		elseif (questName == "Honor the Flame") then
			type = "D";
		end
		print("Zone:", zone);
		print("[" .. x .. y .. "] = \"" .. questID .. ":" .. type .. "\",");
	end
end)]]