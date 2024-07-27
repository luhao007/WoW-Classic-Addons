-- [[ Namespaces ]] --
local _, addon = ...;
local diagnostics = addon.Diagnostics;
addon.Data = {};
local data = addon.Data;

data.TasksGroups = {};

data.TransmogSets = {};

data.BuildVersions = {};
data.BuildVersionsGrouped = {};

data.Achievements = {};
data.AchievementIds = {};

data.Categories, data.SummaryCategories = {}, {};
data.WatchListCategories, data.CurrentZoneCategories, data.SelectedZoneCategories = {}, {}, {};
data.SearchResultsCategories, data.TrackingAchievementsCategories, data.ExcludedCategories = {}, {}, {};
data.UncategorizedCategories = {};

data.RightClickMenuExtras = {};

data.Maps = {};

data.CalendarEvents, data.WidgetEvents, data.WorldEvents = {}, {}, {};

function data:RegisterTooltipDataTasks()
    local name = "Additional Tooltip Data: ";
    for k, v in next, KrowiAF.AdditionalTooltipData do
        self.InjectLoadingDebug(v, name .. k);
        tinsert(self.TasksGroups, 1, v);
    end
end

local LoadBlizzardTabAchievements;
local function PostLoadOnPlayerLogin(self, start)
    self.ExportedAchievements.Load(self.AchievementIds);

    local custom = LibStub("AceConfigRegistry-3.0"):GetOptionsTable(addon.Metadata.Prefix .. "_Layout", "cmd", "KROWIAF-0.0").args.Summary.args.Summary.args.NumAchievements; -- cmd and KROWIAF-0.0 are just to make the function work
    custom.max = #self.AchievementIds;

    LoadBlizzardTabAchievements();

    data.SpecialCategories:Load();

    self.LoadWatchedAchievements();
    self.LoadTrackingAchievements();
    self.LoadExcludedAchievements();

    local function PostBuildCache()
        if AchievementFrame and AchievementFrame:IsShown() then
            addon.Gui:RefreshViewAfterPlayerLogin();
        end

        addon.Diagnostics.Trace("On Player Login: Finished loading data in " .. floor(debugprofilestop() - start + 0.5) .. " ms");
    end

    addon.BuildCacheAsync(PostBuildCache, function(numOfWork)
        addon.Diagnostics.Trace(numOfWork .. " remaining after " .. ("%.2d"):format(debugprofilestop() - start) / 1000);
    end);
end

function data:LoadOnPlayerLogin()
    addon.Diagnostics.Trace("On Player Login: Start loading data");

    self.TemporaryObtainable:Load();
    addon.EventData.BuildCalendarEventsCache();

    if self.ExportedTransmogSets then
        self.ExportedTransmogSets.RegisterTasks(self.TransmogSets);
    end
    self.ExportedBuildVersions.RegisterTasks(self.BuildVersions);
    self.ExportedAchievements.RegisterTasks(self.Achievements, self.BuildVersions, self.TransmogSets);
    self.ExportedCategories.RegisterTasks(self.Categories, self.Achievements, addon.Tabs);
    self.ExportedCalendarEvents.RegisterTasks(self.CalendarEvents, self.Categories);
    if self.ExportedWidgetEvents then
        self.ExportedWidgetEvents.RegisterTasks(self.WidgetEvents, self.Categories);
    end
    if self.ExportedWorldEvents then
        self.ExportedWorldEvents.RegisterTasks(self.WorldEvents, self.Categories);
    end
    if not addon.Util.IsClassicWithAchievements then
        self.ExportedPetBattles.RegisterTasks(self.RightClickMenuExtras);
    end
    self.ExportedUiMaps.RegisterTasks(self.Maps, self.Achievements);

    self:RegisterTooltipDataTasks();

    local overallStart = debugprofilestop();
    addon.StartTasksGroups(
        self.TasksGroups,
        function() PostLoadOnPlayerLogin(self, overallStart); end,
        function(numOfWork)
            addon.Diagnostics.Trace(numOfWork .. " remaining after " .. ("%.2d"):format(debugprofilestop() - overallStart) / 1000);
        end
    );
end

local function LoadAchievements(sourceTable, func)
    if sourceTable == nil or type(sourceTable) ~= "table" then
        return;
    end

    for achievementId, _ in next, sourceTable do
        if data.Achievements[achievementId] then -- This is to clean up achievements that are no longer in the dataset
            func(data.Achievements[achievementId], false);
        else
            sourceTable[achievementId] = nil;
        end
    end
end

function data.LoadWatchedAchievements()
    LoadAchievements(KrowiAF_SavedData.WatchedAchievements, addon.WatchAchievement);
    addon.Diagnostics.Trace("Watched achievements loaded");
end

function data.LoadTrackingAchievements()
    LoadAchievements(addon.TrackingAchievements, addon.AddToTrackingAchievementsCategories);
    addon.Diagnostics.Trace("Tracking achievements loaded");
end

function data.LoadExcludedAchievements()
    LoadAchievements(KrowiAF_SavedData.ExcludedAchievements, addon.ExcludeAchievement);
    addon.Diagnostics.Trace("Excluded achievements loaded");
end

local cachedZone;
function data.GetCurrentZoneAchievements()
	diagnostics.Trace("data.GetCurrentZoneAchievements");

    if #addon.Data.CurrentZoneCategories == 0 then
        return;
    end
    if cachedZone == C_Map.GetBestMapForUnit("player") then
        return;
    end
    cachedZone = C_Map.GetBestMapForUnit("player");
    local achievements = addon.GetAchievementsInZone(cachedZone);
    for i = 1, #addon.Data.CurrentZoneCategories do
        addon.Data.CurrentZoneCategories[i].Achievements = addon.Options.db.profile.AdjustableCategories.CurrentZone[i] and achievements or nil;
    end
    return true; -- Output that the zone has changed
end

function data.AddAchievementIfNil(id)
    if data.Achievements[id] == nil then
        data.Achievements[id] = addon.Objects.Achievement:New(id);
        tinsert(data.AchievementIds, id);
        return true, data.Achievements[id];
    end
    return false, data.Achievements[id];
end

function data.SortAchievementIds()
    sort(data.AchievementIds);
end

local tmpC = {};
local function LoadAllCategories(tabCat, cats)
    for _, id in next, cats do
		local name, parentID = GetCategoryInfo(id);
        tmpC[id] = addon.Objects.Category:New(id, name);
		if parentID == -1 then
			tabCat:AddCategory(tmpC[id]);
		end
	end
end

local function LinkParentAndChildren(cats)
    for _, id in next, cats do
		local _, parentID = GetCategoryInfo(id);
		if parentID ~= -1 then
            tmpC[parentID]:AddCategory(tmpC[id]);
		end
	end
end

local function LinkChainAchievements()
    for i = 1, #data.AchievementIds do
        local prevId = addon.GetPreviousAchievement(data.AchievementIds[i]);
        if prevId and data.Achievements[prevId] then
            data.Achievements[prevId]:AddNext(data.Achievements[data.AchievementIds[i]]);
        end
    end
end

local addedOutOfOrder = {};
local function AddAchievementToCategory(categoryID, achId, excludeTracking)
    local achievement = data.Achievements[achId];
    if achievement ~= nil and not (excludeTracking and achievement.IsTracking) then
        tmpC[categoryID]:AddAchievement(achievement);
        addedOutOfOrder[achId] = true;

        if achievement.NextAchievements then
            for id, _ in next, achievement.NextAchievements do
                AddAchievementToCategory(categoryID, id);
            end
        end
    end
end

local function AddAchievementsToCategory()
    local excludeTracking = not addon.Options.db.profile.Categories.TrackingAchievements.DoLoad;
    for i = 1, #data.AchievementIds do
        local achId = data.AchievementIds[i];
        if addedOutOfOrder[achId] == nil then -- Not yet added
            local categoryID = GetAchievementCategory(achId);
            if tmpC[categoryID] ~= nil then
                achId = addon.GetFirstAchievementId(achId);
                AddAchievementToCategory(categoryID, achId, excludeTracking);
            end
        end
    end
end

local function AddCategoriesToList()
    for k, _ in next, tmpC do
        local newId = data.GetNextFreeCategoryId();
        tmpC[k].Id = newId;
        data.Categories[newId] = tmpC[k];
    end
end

function LoadBlizzardTabAchievements()
    if not addon.Tabs["Achievements"] then
        return;
    end
    local tabCat = addon.Tabs["Achievements"].Category;
    local cats = GetCategoryList();

    LoadAllCategories(tabCat, cats); -- Load all categories, this is done in a random order and is possible for a child to load before a parent
    LinkParentAndChildren(cats); -- When everything is loaded, we can link children and parents
    LinkChainAchievements();
    AddAchievementsToCategory();
    AddCategoriesToList();

    -- Clean up after ourselves
    tmpC = nil;
    addedOutOfOrder = nil;
end

function data.InjectLoadingDebug(workload, name)
    if not addon.Diagnostics.TraceEnabled() then
        return;
    end

    -- Data is in reverse order in the tables so add 'Start' to the end and 'Finished' to the beginning
    tinsert(workload, function() addon.Diagnostics.Trace(name .. ": Start loading data"); end);
    tinsert(workload, 1, function() addon.Diagnostics.Trace(name .. ": Finished loading data"); end);
end

local freeCategoryId = 0;
function data.GetNextFreeCategoryId()
    if freeCategoryId == 0 then
        for id, _ in next, data.Categories do
            if id > freeCategoryId then
                freeCategoryId = id;
            end
        end
    end
    freeCategoryId = freeCategoryId + 1;
    return freeCategoryId;
end

-- function KrowiAF_PrintPetCriteria(achievementID, parentCriteriaID, criteriaNumber)
--     TEST = {};
--     local id, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuild, wasEarnedByMe, earnedBy = GetAchievementInfo(achievementID);

--     local record = "A" .. tostring(id) .. "\t" .. tostring(achievementID) .. "\t" .. tostring(criteriaNumber) .. "\t" .. name .. "\t" .. tostring(parentCriteriaID) .. "\t" .. 0;
--     tinsert(TEST, record);

--     if parentCriteriaID == nil then
--         parentCriteriaID = "A" .. tostring(id);
--     end

--     for i = 1, GetAchievementNumCriteria(achievementID) do
--         local family = "nil";
--         if string.match(description:lower(), "aquatic") then
--             family = "Aquatic";
--         elseif string.match(description:lower(), "beast") then
--             family = "Beast";
--         elseif string.match(description:lower(), "critter") then
--             family = "Critter";
--         elseif string.match(description:lower(), "dragonkin") then
--             family = "Dragonkin";
--         elseif string.match(description:lower(), "elemental") then
--             family = "Elemental";
--         elseif string.match(description:lower(), "flying") then
--             family = "Flying";
--         elseif string.match(description:lower(), "humanoid") then
--             family = "Humanoid";
--         elseif string.match(description:lower(), "magic") then
--             family = "Magic";
--         elseif string.match(description:lower(), "mechanical") then
--             family = "Mechanical";
--         elseif string.match(description:lower(), "undead") then
--             family = "Undead";
--         end
--         local criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID = addon.GetAchievementCriteriaInfo(achievementID, i);
--         if GetAchievementInfo(assetID) ~= nil then -- Means the assetID was not an achievementID but something else like a quest
--             data.PrintCriteria(assetID, "A" .. tostring(id), i);
--         else
--             local record = tostring(criteriaID) .. "\t" .. tostring(nil) .. "\t" .. tostring(i) .. "\t" .. criteriaString .. "\t" .. "A" .. tostring(id) .. "\t" .. family;
--             tinsert(TEST, record);
--         end
--     end
-- end