--- Some functions to handle collection of Classic character data, in lieu of a Blizzard Web API. It's kinda formatted
--- as a singleton class.

--- *****************
--- ***** SETUP *****
--- *****************

local addonName, addonTable = ...;

local public, private = {}, {};
addonTable.profileData = public;

--- *********************
--- ***** VARIABLES *****
--- *********************

--- --------------
--- --- PUBLIC ---
--- --------------

--- Exported character data. This is declared here but gets overridden when saved variables are loaded.
wlProfileData = {};

--- ---------------
--- --- PRIVATE ---
--- ---------------

--- Frame to capture events.
private.eventFrame = CreateFrame("FRAME", addonName .. "wlProfileDataEvents");

--- *********************
--- ***** FUNCTIONS *****
--- *********************

--- --------------
--- --- PUBLIC ---
--- --------------

--- Scans the current character and saves the info to the addon's SavedVariables. It's assumed that this data MAY get
--- wiped in the SavedVariables after it's sent to Wowhead, and Wowhead MAY completely replace its old record of the
--- data with whatever we save here.
function public.scan()
    local savedData = private.getDataTable();
    local key = private.getKey();

    savedData[key] = savedData[key] or {};

    savedData[key].version = 1; --- Increment this on breaking changes for this data structure.
    savedData[key].timestamp = GetServerTime();

    savedData[key].name = private.selectOne(1, UnitName("player"));
    savedData[key].realm = GetRealmName();
    savedData[key].guid = UnitGUID("player");
    savedData[key].class = private.selectOne(3, UnitClass("player"));
    savedData[key].race = private.selectOne(3, UnitRace("player"));
    savedData[key].sex = UnitSex("player");
    savedData[key].locale = GetLocale();

    savedData[key].level = max(savedData[key].level or 0, UnitLevel("player"));

    savedData[key].equipment = savedData[key].equipment or {};
    private.getEquipment(savedData[key].equipment);

    savedData[key].factions = savedData[key].factions or {};
    private.getFactions(savedData[key].factions);

    savedData[key].skills = savedData[key].skills or {};
    private.getSkills(savedData[key].skills);

    --- Technically we could do this once with the initial scan, then listen for the QUEST_TURNED_IN event to keep it
    --- updated, but some quests can trigger multiple quest IDs as complete (like breadcrumbs).
    savedData[key].quests = savedData[key].quests or {};
    GetQuestsCompleted(savedData[key].quests);

    savedData[key].talents = private.getTalentHash();
end

--- ---------------
--- --- PRIVATE ---
--- ---------------

--- Generic event handler. If a private.event_$event function is defined, call it, otherwise just run another scan.
-- @param self The frame that triggered the event
-- @param event The name of the event that triggered
-- @param ... Event-specific arguments
function private:eventHandler(event, ...)
    local callback = private['event_' .. event]

    if callback then
        callback(self, ...);
    else
        --- Stuff happened, scan to update our data.
        public.scan();
    end
end

--- Event handler for level up. UnitLevel("player") lags behind the level up event, so we set it here.
-- @param level The new player level.
function private:event_PLAYER_LEVEL_UP(level)
    local savedData = private.getDataTable();
    local key = private.getKey();

    if savedData[key] then
        savedData[key].level = level;
    end
end

--- Runs an initial scan on the PLAYER_LOGIN event.
-- @param self The frame that triggered the event
function private:event_PLAYER_LOGIN()
    self:UnregisterEvent("PLAYER_LOGIN");
    public.scan();
end

--- Removes invalid character info on the PLAYER_LOGOUT event.
-- @param self The frame that triggered the event
function private:event_PLAYER_LOGOUT()
    self:UnregisterEvent("PLAYER_LOGOUT");

    local savedData = private.getDataTable();
    local key = private.getKey();
    if savedData[key] then
        if not savedData[key].level then
            savedData[key] = nil;
        end
    end
end

--- Returns a reference to the SavedVariables table where we collect profile data.
-- @return wlProfileData
function private.getDataTable()
    return wlProfileData;
end

--- Fills a table with the item links of all the character's equipped items.
-- @param equipTable The table to fill.
function private.getEquipment(equipTable)
    wipe(equipTable)

    for slotId=0, CONTAINER_BAG_OFFSET+4 do
        local itemLink = GetInventoryItemLink("player", slotId);
        if itemLink then
            equipTable[slotId] = string.match(itemLink, "item[%-?%d:]+")
        end
    end
end

--- Fills a table with the faction IDs and earned reputation level for all factions this character encountered.
-- @param factionsTable The table to fill.
function private.getFactions(factionsTable)
    wipe(factionsTable)

    local toCollapse
    local collapseIndex = 1

    local numFactions = GetNumFactions()
    local factionIndex = 1
    while (factionIndex <= numFactions) do
        local _, _, _, _, _, earnedValue, _, _,
            isHeader, isCollapsed, hasRep, _, _, factionID, _, _ = GetFactionInfo(factionIndex)
        if isHeader and isCollapsed then
            toCollapse = toCollapse or {}
            toCollapse[collapseIndex] = factionIndex
            collapseIndex = collapseIndex + 1
            ExpandFactionHeader(factionIndex)
            numFactions = GetNumFactions()
        end
        if hasRep or not isHeader then
            factionsTable[factionID] = earnedValue
        end
        factionIndex = factionIndex + 1
    end
    while (collapseIndex > 1) do
        collapseIndex = collapseIndex - 1
        CollapseFactionHeader(toCollapse[collapseIndex])
    end
end

--- Returns a "unique" key for the character for the SavedVariables data.
-- @return The character name and realm, formatted the same as wlId
function private.getKey()
    return private.selectOne(1, UnitName("player")) .. '^' .. GetRealmName();
end

--- Fills a table with the skill names and earned skill level for all skills this character has.
-- @param skillsTable The table to fill.
function private.getSkills(skillsTable)
    wipe(skillsTable)

    local toCollapse
    local collapseIndex = 1

    local numSkills = GetNumSkillLines()
    local skillIndex = 1
    while (skillIndex <= numSkills) do
        local name, isHeader, isExpanded, skillRank, _, _, maxRank = GetSkillLineInfo(skillIndex)
        if isHeader and not isExpanded then
            toCollapse = toCollapse or {}
            toCollapse[collapseIndex] = skillIndex
            collapseIndex = collapseIndex + 1
            ExpandSkillHeader(skillIndex)
            numSkills = GetNumSkillLines()
        end
        if not isHeader and maxRank > 1 then
            skillsTable[name] = skillRank
        end
        skillIndex = skillIndex + 1
    end
    while (collapseIndex > 1) do
        collapseIndex = collapseIndex - 1
        CollapseSkillHeader(toCollapse[collapseIndex])
    end
end

--- Returns the Wowhead-style talent hash for the current talent build.
-- @return Hash string, without player class.
function private.getTalentHash()
    local result = {};
    local pos = 1;

    for tab=1, GetNumTalentTabs() do
        if tab > 1 then
            --- Add - separator between trees.
            result[pos] = '-';
            pos = pos + 1;
        end
        for idx=1, GetNumTalents(tab) do
            local _, _, _, _, currentPoints = GetTalentInfo(tab, idx);
            result[pos] = currentPoints;
            pos = pos + 1;
        end
        --- Trim trailing 0s
        while pos > 1 and result[pos - 1] == 0 do
            pos = pos - 1;
            result[pos] = nil;
        end
    end
    --- Trim trailing -s
    while pos > 1 and result[pos - 1] == '-' do
        pos = pos - 1;
        result[pos] = nil;
    end

    return table.concat(result);
end

--- Runs once upon first load, to set up the class.
function private.init()
    private.eventFrame:RegisterEvent("PLAYER_LOGIN");
    private.eventFrame:RegisterEvent("PLAYER_LOGOUT");
    private.eventFrame:RegisterEvent("PLAYER_LEVEL_UP");
    private.eventFrame:RegisterEvent("QUEST_TURNED_IN");
    private.eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
    private.eventFrame:RegisterEvent("CHARACTER_POINTS_CHANGED"); -- Talent update

    private.eventFrame:SetScript("OnEvent", private.eventHandler);
end

--- Returns only the Ith value of the remaining arguments
-- @param i
-- @param ...
-- @return Value #i of the arguments.
function private.selectOne(i, ...)
    local v = select(i, ...);

    return v;
end

--- Run init. This should come last in this file.
private.init();
