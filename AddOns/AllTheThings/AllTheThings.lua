--------------------------------------------------------------------------------
--                        A L L   T H E   T H I N G S                         --
--------------------------------------------------------------------------------
--				Copyright 2017-2025 Dylan Fortune (Crieve-Sargeras)           --
--------------------------------------------------------------------------------
-- App locals
local appName, app = ...;
local L = app.L;

local AssignChildren, GetRelativeValue, IsQuestFlaggedCompleted
	= app.AssignChildren, app.GetRelativeValue, app.IsQuestFlaggedCompleted

-- Abbreviations
L.ABBREVIATIONS[L.UNSORTED .. " %> " .. L.UNSORTED] = "|T" .. app.asset("WindowIcon_Unsorted") .. ":0|t " .. L.SHORTTITLE .. " %> " .. L.UNSORTED;

-- Binding Localizations
BINDING_HEADER_ALLTHETHINGS = L.TITLE
BINDING_NAME_ALLTHETHINGS_TOGGLEACCOUNTMODE = L.TOGGLE_ACCOUNT_MODE
BINDING_NAME_ALLTHETHINGS_TOGGLECOMPLETIONISTMODE = L.TOGGLE_COMPLETIONIST_MODE
BINDING_NAME_ALLTHETHINGS_TOGGLEDEBUGMODE = L.TOGGLE_DEBUG_MODE
BINDING_NAME_ALLTHETHINGS_TOGGLEFACTIONMODE = L.TOGGLE_FACTION_MODE
BINDING_NAME_ALLTHETHINGS_TOGGLELOOTMODE = L.TOGGLE_LOOT_MODE

BINDING_HEADER_ALLTHETHINGS_PREFERENCES = PREFERENCES
BINDING_NAME_ALLTHETHINGS_TOGGLECOMPLETEDTHINGS = L.TOGGLE_COMPLETEDTHINGS
BINDING_NAME_ALLTHETHINGS_TOGGLECOMPLETEDGROUPS = L.TOGGLE_COMPLETEDGROUPS
BINDING_NAME_ALLTHETHINGS_TOGGLECOLLECTEDTHINGS = L.TOGGLE_COLLECTEDTHINGS
BINDING_NAME_ALLTHETHINGS_TOGGLEBOEITEMS = L.TOGGLE_BOEITEMS
BINDING_NAME_ALLTHETHINGS_TOGGLESOURCETEXT = L.TOGGLE_SOURCETEXT

BINDING_HEADER_ALLTHETHINGS_MODULES = L.MODULES
BINDING_NAME_ALLTHETHINGS_TOGGLEMAINLIST = L.TOGGLE_MAINLIST
BINDING_NAME_ALLTHETHINGS_TOGGLEMINILIST = L.TOGGLE_MINILIST
BINDING_NAME_ALLTHETHINGS_TOGGLE_PROFESSION_LIST = L.TOGGLE_PROFESSION_LIST
BINDING_NAME_ALLTHETHINGS_TOGGLE_RAID_ASSISTANT = L.TOGGLE_RAID_ASSISTANT
BINDING_NAME_ALLTHETHINGS_TOGGLE_WORLD_QUESTS_LIST = L.TOGGLE_WORLD_QUESTS_LIST
BINDING_NAME_ALLTHETHINGS_TOGGLERANDOM = L.TOGGLE_RANDOM
BINDING_NAME_ALLTHETHINGS_REROLL_RANDOM = L.REROLL_RANDOM

-- Performance Cache
local print, rawget, rawset, tostring, ipairs, pairs, tonumber, wipe, select, setmetatable, getmetatable, tinsert, tremove, type, math_floor
	= print, rawget, rawset, tostring, ipairs, pairs, tonumber, wipe, select, setmetatable, getmetatable, tinsert, tremove, type, math.floor

-- Global WoW API Cache
local C_Map_GetMapInfo = C_Map.GetMapInfo;
local InCombatLockdown = _G.InCombatLockdown;
local IsInInstance = IsInInstance

-- WoW API Cache;
local GetSpellName = app.WOWAPI.GetSpellName;
local GetTradeSkillTexture = app.WOWAPI.GetTradeSkillTexture;

local C_TradeSkillUI = C_TradeSkillUI;
local C_TradeSkillUI_GetCategories, C_TradeSkillUI_GetCategoryInfo, C_TradeSkillUI_GetRecipeInfo, C_TradeSkillUI_GetRecipeSchematic, C_TradeSkillUI_GetTradeSkillLineForRecipe
	= C_TradeSkillUI.GetCategories, C_TradeSkillUI.GetCategoryInfo, C_TradeSkillUI.GetRecipeInfo, C_TradeSkillUI.GetRecipeSchematic, C_TradeSkillUI.GetTradeSkillLineForRecipe;

-- App & Module locals
local ArrayAppend = app.ArrayAppend
local CacheFields, SearchForField, SearchForFieldContainer, SearchForObject
	= app.CacheFields, app.SearchForField, app.SearchForFieldContainer, app.SearchForObject
local IsRetrieving = app.Modules.RetrievingData.IsRetrieving;
local GetProgressColorText = app.Modules.Color.GetProgressColorText;
local CleanLink = app.Modules.Item.CleanLink
local TryColorizeName = app.TryColorizeName;
local MergeProperties = app.MergeProperties
local DESCRIPTION_SEPARATOR = app.DESCRIPTION_SEPARATOR;
local ATTAccountWideData;

local
CreateObject,
MergeObject,
NestObject,
MergeObjects,
NestObjects,
PriorityNestObjects
=
app.__CreateObject,
app.MergeObject,
app.NestObject,
app.MergeObjects,
app.NestObjects,
app.PriorityNestObjects

-- Color Lib;
local Colorize = app.Modules.Color.Colorize;

-- Coroutine Helper Functions
local Push = app.Push;
local StartCoroutine = app.StartCoroutine;
local Callback = app.CallbackHandlers.Callback;
local DelayedCallback = app.CallbackHandlers.DelayedCallback;
local AfterCombatCallback = app.CallbackHandlers.AfterCombatCallback;
app.FillRunner = app.CreateRunner("fill");
local LocalizeGlobal = app.LocalizeGlobal
local LocalizeGlobalIfAllowed = app.LocalizeGlobalIfAllowed
local contains = app.contains;
local containsValue = app.containsValue;
local indexOf = app.indexOf;
local CloneArray = app.CloneArray

-- OnLoad assignments, probably temporary as code gets migrated
local ExpandGroupsRecursively
app.AddEventHandler("OnLoad", function()
	ExpandGroupsRecursively = app.ExpandGroupsRecursively
end)

-- Data Lib
local AllTheThingsAD = {};			-- For account-wide data.

local function formatNumericWithCommas(amount)
  local k
  while true do
	amount, k = tostring(amount):gsub("^(-?%d+)(%d%d%d)", '%1,%2')
	if k == 0 then
		break
	end
  end
  return amount
end
local function GetMoneyString(amount)
	if amount > 0 then
		local formatted
		local gold,silver,copper = math_floor(amount / 100 / 100), math_floor((amount / 100) % 100), math_floor(amount % 100)
		if gold > 0 then
			formatted = formatNumericWithCommas(gold) .. "|T237618:0|t"
		end
		if silver > 0 then
			formatted = (formatted or "") .. silver .. "|T237620:0|t"
		end
		if copper > 0 then
			formatted = (formatted or "") .. copper .. "|T237617:0|t"
		end
		return formatted
	end
	return amount
end

do -- TradeSkill Functionality
local tradeSkillSpecializationMap = app.SkillDB.Specializations
local specializationTradeSkillMap = app.SkillDB.BaseSkills
local tradeSkillMap = app.SkillDB.Conversion
-- this is still required by Shared Modules
app.SkillIDToSpellID = app.SkillDB.SkillToSpell
local function GetBaseTradeSkillID(skillID)
	return tradeSkillMap[skillID] or skillID;
end
local function GetTradeSkillSpecialization(skillID)
	return tradeSkillSpecializationMap[skillID];
end
app.GetTradeSkillLine = function()
	local profInfo = C_TradeSkillUI.GetBaseProfessionInfo();
	return GetBaseTradeSkillID(profInfo.professionID);
end
app.GetSpecializationBaseTradeSkill = function(specializationID)
	return specializationTradeSkillMap[specializationID];
end
-- Refreshes the known Trade Skills/Professions of the current character (app.CurrentCharacter.Professions)
local function RefreshTradeSkillCache()
	local cache = app.CurrentCharacter.Professions;
	wipe(cache);
	-- "Professions" that anyone can "know"
	for _,skillID in ipairs(app.SkillDB.AlwaysAvailable) do
		cache[skillID] = true
	end
	-- app.PrintDebug("RefreshTradeSkillCache");
	local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
	for i,j in ipairs({prof1 or 0, prof2 or 0, archaeology or 0, fishing or 0, cooking or 0, firstAid or 0}) do
		if j ~= 0 then
			local prof = select(7, GetProfessionInfo(j));
			cache[GetBaseTradeSkillID(prof)] = true;
			-- app.PrintDebug("KnownProfession",j,GetProfessionInfo(j));
			local specializations = GetTradeSkillSpecialization(prof);
			if specializations ~= nil then
				for _,spellID in pairs(specializations) do
					if spellID and app.IsSpellKnownHelper(spellID) then
						cache[spellID] = true;
					end
				end
			end
		end
	end
end
app.AddEventHandler("OnStartup", RefreshTradeSkillCache)
app.AddEventHandler("OnStartup", function()
	local conversions = app.Settings.InformationTypeConversionMethods;
	conversions.professionName = function(skillID)
		local texture = GetTradeSkillTexture(skillID or 0)
		local name = GetSpellName(app.SkillDB.SkillToSpell[skillID] or 0) or C_TradeSkillUI.GetTradeSkillDisplayName(skillID) or RETRIEVING_DATA
		return texture and "|T"..texture..":0|t "..name or name
	end;
end);
app.AddEventRegistration("SKILL_LINES_CHANGED", function()
	-- app.PrintDebug("SKILL_LINES_CHANGED")
	-- seems to be a reliable way to notice a player has changed professions? not sure how else often it actually triggers... hopefully not too excessive...
	DelayedCallback(RefreshTradeSkillCache, 2);
end)
end -- TradeSkill Functionality

local ResolveSymbolicLink;

local GetSpecsString, GetGroupItemIDWithModID, GetItemIDAndModID, GroupMatchesParams, GetClassesString
	= app.GetSpecsString, app.GetGroupItemIDWithModID, app.GetItemIDAndModID, app.GroupMatchesParams, app.GetClassesString

local function CleanInheritingGroups(groups, ...)
	-- Cleans any groups which are nested under any group with any specified fields
	local arrs = select("#", ...);
	if groups and arrs > 0 then
		local refined, f, match = {}, nil, nil;
		-- app.PrintDebug("CIG:Start",#groups,...)
		for _,j in ipairs(groups) do
			match = nil;
			for n=1,arrs do
				f = select(n, ...);
				if GetRelativeValue(j, f) then
					match = true;
					-- app.PrintDebug("CIG:Skip",j.hash,f)
					break;
				end
			end
			if not match then
				tinsert(refined, j);
			end
		end
		-- app.PrintDebug("CIG:End",#refined)
		return refined;
	end
end
-- Symlink Lib
do
local select, tremove, unpack =
	  select, tremove, unpack;
local FinalizeModID, PruneFinalized, FillFinalized, SelectMod
-- Checks if any of the provided arguments can be found within the first array object
local function ContainsAnyValue(arr, ...)
	local value;
	local vals = select("#", ...);
	for i=1,vals do
		value = select(i, ...);
		for _,v in ipairs(arr) do
			if v == value then return true; end
		end
	end
end
local function Resolve_Extract(results, group, field)
	if group[field] then
		results[#results + 1] = group
	elseif group.g then
		for _,o in ipairs(group.g) do
			Resolve_Extract(results, o, field);
		end
	end
end
local function Resolve_Find(results, groups, field, val)
	if groups then
		for _,o in ipairs(groups) do
			if o[field] == val then
				results[#results + 1] = o
			else
				Resolve_Find(results, o.g, field, val)
			end
		end
	end
end
local GetAchievementNumCriteria = GetAchievementNumCriteria
local GetItemInfoInstant = app.WOWAPI.GetItemInfoInstant;

-- Defines a known set of functions which can be run via symlink resolution. The inputs to each function will be identical in order when called.
-- searchResults - the current set of searchResults when reaching the current sym command
-- o - the specific group object which contains the symlink commands
-- (various expected components of the respective sym command)
local ResolveFunctions = {
	-- Instruction to search the full database for multiple of a given type
	["select"] = function(finalized, searchResults, o, cmd, field, ...)
		local cache, val;
		local vals = select("#", ...);
		local Search = SearchForObject
		for i=1,vals do
			val = select(i, ...) + (SelectMod or 0)
			if field == "modItemID" then
				-- this is really dumb but direct raw values don't 'always' properly match generated values...
				-- but splitting the value apart and putting it back together searches accurately
				val = GetGroupItemIDWithModID(nil, GetItemIDAndModID(val))
			end
			cache = Search(field, val, "field", true);
			if cache and #cache > 0 then
				ArrayAppend(searchResults, cache)
			else
				-- TODO: re-enable after all catalystID's are re-structured
				-- app.print("Failed to select ", field, val);
			end
		end
		SelectMod = nil
	end,
	-- Instruction to select the parent object of the group that owns the symbolic link
	["selectparent"] = function(finalized, searchResults, o, cmd, level)
		level = level or 1;
		-- an search for the specific 'o' to retrieve the source parent since the parent is not always actually attached to the reference resolving the symlink
		local parent
		local searchedObject = app.SearchForObject(o.key, o.keyval, "key");
		if searchedObject then
			parent = searchedObject.parent;
			while level > 1 do
				parent = parent and parent.parent;
				level = level - 1;
			end
			if parent then
				-- app.PrintDebug("selectparent-searched",level,parent.hash,parent.text)
				tinsert(searchResults, parent);
				return;
			end
		end
		app.print("'selectparent' failed for",o.hash);
	end,
	-- Instruction to find all content marked with the specified 'requireSkill'
	["selectprofession"] = function(finalized, searchResults, o, cmd, requireSkill)
		local search = app:BuildSearchResponse("requireSkill", requireSkill);
		ArrayAppend(searchResults, search);
	end,
	-- Instruction to fill with identical content Sourced elsewhere for this group (no symlinks)
	["fill"] = function(finalized, searchResults, o)
		local okey = o.key;
		if okey then
			local okeyval = o[okey];
			if okeyval then
				for _,result in ipairs(SearchForObject(okey, okeyval, "field", true)) do
					ArrayAppend(searchResults, result.g);
				end
			end
		end
	end,
	-- Instruction to finalize the current search results and prevent additional queries from affecting this selection
	["finalize"] = function(finalized, searchResults)
		ArrayAppend(finalized, searchResults);
		wipe(searchResults);
	end,
	-- Instruction to take all of the finalized and non-finalized search results and merge them back in to the processing queue
	["merge"] = function(finalized, searchResults)
		local orig;
		if #searchResults > 0 then
			orig = CloneArray(searchResults);
		end
		wipe(searchResults);
		-- finalized first
		ArrayAppend(searchResults, finalized);
		wipe(finalized);
		-- then any existing searchResults
		ArrayAppend(searchResults, orig);
	end,
	-- Instruction to "push" all of the group values into an object as specified
	["push"] = function(finalized, searchResults, o, cmd, field, value)
		local orig;
		if #searchResults > 0 then
			orig = CloneArray(searchResults);
		end
		wipe(searchResults);
		local group = CreateObject({[field] = value });
		NestObjects(group, orig);
		searchResults[1] = group;
	end,
	-- Instruction to "pop" all of the group values up one level
	["pop"] = function(finalized, searchResults)
		local orig;
		if #searchResults > 0 then
			orig = CloneArray(searchResults);
		end
		wipe(searchResults);
		if orig then
			for _,obj in ipairs(orig) do
				-- insert raw & symlinked Things from this group
				ArrayAppend(searchResults, obj.g, ResolveSymbolicLink(obj));
			end
		end
	end,
	-- Instruction to include only search results where a key value is a value
	["where"] = function(finalized, searchResults, o, cmd, field, value)
		for k=#searchResults,1,-1 do
			local result = searchResults[k];
			if not result[field] or result[field] ~= value then
				tremove(searchResults, k);
			end
		end
	end,
	-- Instruction to include only search results where a key value is a value
	["whereany"] = function(finalized, searchResults, o, cmd, field, ...)
		local hash = {};
		for k,value in ipairs({...}) do
			hash[value] = true;
		end
		for k=#searchResults,1,-1 do
			local result = searchResults[k];
			if not result[field] or not hash[result[field]] then
				tremove(searchResults, k);
			end
		end
	end,
	-- Instruction to extract all nested results which contain a given field
	["extract"] = function(finalized, searchResults, o, cmd, field)
		local orig;
		if #searchResults > 0 then
			orig = CloneArray(searchResults);
		end
		wipe(searchResults);
		if orig then
			for _,o in ipairs(orig) do
				Resolve_Extract(searchResults, o, field);
			end
		end
	end,
	-- Instruction to find all nested results which contain a given field/value
	["find"] = function(finalized, searchResults, o, cmd, field, val)
		if #searchResults > 0 then
			local resolved = {}
			Resolve_Find(resolved, searchResults, field, val)
			wipe(searchResults)
			ArrayAppend(searchResults, resolved)
		end
	end,
	-- Instruction to include the search result with a given index within each of the selection's groups
	["index"] = function(finalized, searchResults, o, cmd, index)
		local orig;
		if #searchResults > 0 then
			orig = CloneArray(searchResults);
		end
		wipe(searchResults);
		if orig then
			local result, g;
			for k=#orig,1,-1 do
				result = orig[k];
				g = result.g;
				if g and index <= #g then
					tinsert(searchResults, g[index]);
				end
			end
		end
	end,
	-- Instruction to include only search results where a key value is not a value
	["not"] = function(finalized, searchResults, o, cmd, field, ...)
		local vals = select("#", ...);
		if vals < 1 then
			app.print("'",cmd,"' had empty value set")
			return;
		end
		local result, value;
		for k=#searchResults,1,-1 do
			result = searchResults[k];
			for i=1,vals do
				value = select(i, ...);
				if result[field] == value then
					tremove(searchResults, k);
					break;
				end
			end
		end
	end,
	-- Instruction to include only search results where a key exists
	["is"] = function(finalized, searchResults, o, cmd, field)
		for k=#searchResults,1,-1 do
			if not searchResults[k][field] then tremove(searchResults, k); end
		end
	end,
	-- Instruction to include only search results where a key doesn't exist
	["isnt"] = function(finalized, searchResults, o, cmd, field)
		for k=#searchResults,1,-1 do
			if searchResults[k][field] then tremove(searchResults, k); end
		end
	end,
	-- Instruction to include only search results where a key value/table contains a value
	["contains"] = function(finalized, searchResults, o, cmd, field, ...)
		local vals = select("#", ...);
		if vals < 1 then
			app.print("'",cmd,"' had empty value set")
			return;
		end
		local result, kval;
		for k=#searchResults,1,-1 do
			result = searchResults[k];
			kval = result[field];
			-- key doesn't exist at all on the result
			if not kval then
				tremove(searchResults, k);
			-- none of the values match the contains values
			elseif type(kval) == "table" then
				if not ContainsAnyValue(kval, ...) then
					tremove(searchResults, k);
				end
			-- key exists with single value on the result
			else
				local match;
				for i=1,vals do
					if kval == select(i, ...) then
						match = true;
						break;
					end
				end
				if not match then
					tremove(searchResults, k);
				end
			end
		end
	end,
	-- Instruction to exclude search results where a key value contains a value
	["exclude"] = function(finalized, searchResults, o, cmd, field, ...)
		local vals = select("#", ...);
		if vals < 1 then
			app.print("'",cmd,"' had empty value set")
			return;
		end
		local result, kval;
		for k=#searchResults,1,-1 do
			result = searchResults[k];
			kval = result[field];
			-- key exists
			if kval then
				local match;
				for i=1,vals do
					if kval == select(i, ...) then
						match = true;
						break;
					end
				end
				if match then
					-- TEMP logic to allow Ensembles to continue working until they get fixed again
					if field == "itemID" and result.g and kval == o[field] then
						ArrayAppend(searchResults, result.g);
					end
					tremove(searchResults, k);
				end
			end
		end
	end,
	-- Instruction to include only search results where an item is of a specific inventory type
	["invtype"] = function(finalized, searchResults, o, cmd, ...)
		local vals = select("#", ...);
		if vals < 1 then
			app.print("'",cmd,"' had empty value set")
			return;
		end
		local result, invtype, itemID;
		for k=#searchResults,1,-1 do
			result = searchResults[k];
			itemID = result.itemID;
			if itemID then
				invtype = select(4, GetItemInfoInstant(itemID));
				local match;
				for i=1,vals do
					if invtype == select(i, ...) then
						match = true;
						break;
					end
				end
				if not match then
					tremove(searchResults, k);
				end
			end
		end
	end,
	-- Instruction to search the full database for multiple achievementID's and persist only actual achievements
	["meta_achievement"] = function(finalized, searchResults, o, cmd, ...)
		local vals = select("#", ...);
		if vals < 1 then
			app.print("'",cmd,"' had empty value set")
			return;
		end
		local Search = SearchForObject
		local cache, value;
		for i=1,vals do
			value = select(i, ...);
			cache = CleanInheritingGroups(Search("achievementID", value, "key", true), "sourceIgnored")
			local mergeAch = cache[1]
			-- multiple achievements match the selection, make sure to merge them together so we don't lose fields
			-- that only exist in the original Source (Achievements source prunes some data)
			local count = #cache
			if count > 1 then
				for j=2,count do
					-- app.PrintDebug("Merge Ach",app:SearchLink(cache[j]))
					MergeProperties(mergeAch, cache[j])
				end
			end
			if mergeAch then
				searchResults[#searchResults + 1] = mergeAch
			else
				app.print("Failed to select achievementID",value);
			end
		end
		PruneFinalized = { "g" };
	end,
	-- Instruction to search the full database for an achievementID and persist the associated Criteria
	["partial_achievement"] = function(finalized, searchResults, o, cmd, achID)
		local cache = app.SearchForField("achievementID", achID)
		local crit
		for i=1,#cache do
			crit = cache[i]
			if crit.criteriaID then
				searchResults[#searchResults + 1] = crit
			end
		end
	end,
	-- Instruction to simply 'prune' sub-groups from the finalized selection, or specified fields
	["prune"] = function(finalized, searchResults, o, cmd, ...)
		local vals = select("#", ...);
		if vals < 1 then
			PruneFinalized = { "g" }
			return;
		end
		local value;
		for i=1,vals do
			value = select(i, ...);
			if PruneFinalized then PruneFinalized[#PruneFinalized + 1] = value
			else PruneFinalized = { value } end
		end
	end,
	-- Instruction to apply a specific modID to any Items within the finalized search results
	["modID"] = function(finalized, searchResults, o, cmd, modID)
		FinalizeModID = modID
	end,
	-- Instruction to apply the modID from the Source object to any Items within the finalized search results
	["myModID"] = function(finalized, searchResults, o)
		FinalizeModID = o.modID
	end,
	-- Instruction to apply a specific modID to any Items within the finalized search results
	["usemodID"] = function(finalized, searchResults, o, cmd, modID)
		SelectMod = GetGroupItemIDWithModID(nil, nil, modID)
	end,
	-- Instruction to apply the modID from the Source object to any Items within the finalized search results
	["usemyModID"] = function(finalized, searchResults, o)
		SelectMod = GetGroupItemIDWithModID(nil, nil, o.modID)
	end,
	-- Instruction to use the modID from the Source object to filter matching modID on any Items within the finalized search results
	["whereMyModID"] = function(finalized, searchResults, o)
		local modID = o.modID
		for k=#searchResults,1,-1 do
			local result = searchResults[k];
			if not result.modID or result.modID ~= modID then
				tremove(searchResults, k);
			end
		end
	end,
	-- Instruction to perform an immediate 'FillGroups' against the objects in the finalized set prior to returning the results
	-- or to fill the groups currently within the searchResults at this step
	["groupfill"] = function(finalized, searchResults, o, cmd, onCurrent)
		if onCurrent then
			if #searchResults == 0 then return end
			local orig = CloneArray(searchResults);
			wipe(searchResults);
			local Fill = app.FillGroups
			local result
			for k=1,#orig do
				result = CreateObject(orig[k])
				Fill(result)
				searchResults[#searchResults + 1] = result
			end
		else
			FillFinalized = true
		end
	end,
};

-- Replace achievementy_criteria function if criteria API doesn't exist
if GetAchievementNumCriteria then
	local GetAchievementCriteriaInfo = _G.GetAchievementCriteriaInfo;
	-- Instruction to query all criteria of an Achievement via the in-game APIs and generate Criteria data into the most-accurate Sources
	ResolveFunctions.achievement_criteria = function(finalized, searchResults, o)
		-- Instruction to select the criteria provided by the achievement this is attached to. (maybe build this into achievements?)
		local achievementID = o.achievementID;
		if not achievementID then
			app.PrintDebug("'achievement_criteria' used on a non-Achievement group")
			return;
		end
		local _, criteriaType, _, _, reqQuantity, _, _, assetID, _, _, criteriaObject, uniqueID
		---@diagnostic disable-next-line: redundant-parameter
		for criteriaID=1,GetAchievementNumCriteria(achievementID, true),1 do
			---@diagnostic disable-next-line: redundant-parameter
			_, criteriaType, _, _, reqQuantity, _, _, assetID, _, uniqueID = GetAchievementCriteriaInfo(achievementID, criteriaID, true);
			if not uniqueID or uniqueID <= 0 then uniqueID = criteriaID; end
			criteriaObject = app.CreateAchievementCriteria(uniqueID, {["achievementID"] = achievementID}, true);

			-- criteriaType ref: https://warcraft.wiki.gg/wiki/API_GetAchievementCriteriaInfo
			-- Quest source
			if criteriaType == 27	-- Completing a quest
			then
				local quests = SearchForField("questID", assetID)
				if #quests > 0 then
					for _,c in ipairs(quests) do
						-- criteria inherit their achievement data ONLY when the achievement data is actually referenced... this is required for proper caching
						NestObject(c, criteriaObject);
						AssignChildren(c);
						CacheFields(criteriaObject);
						app.DirectGroupUpdate(c);
						criteriaObject = app.CreateAchievementCriteria(uniqueID, {["achievementID"] = achievementID}, true);
						-- app.PrintDebug("Add-Crit",achievementID,uniqueID,"=>",c.hash)
					end
					-- added to the quest(s) groups, not added to achievement
					criteriaObject = nil;
				else
					app.print("'achievement_criteria' Quest type missing Quest Source group!","Quest",assetID,app:Linkify("Achievement #"..achievementID,app.Colors.ChatLink,"search:achievementID:"..achievementID))
				end
			-- NPC source
			elseif criteriaType == 0	-- Monster kill
			then
				-- app.PrintDebug("NPC Kill Criteria",assetID)
				local c = SearchForObject("npcID", assetID, "field")
				if c then
					-- criteria inherit their achievement data ONLY when the achievement data is actually referenced... this is required for proper caching
					NestObject(c, criteriaObject);
					AssignChildren(c);
					CacheFields(criteriaObject);
					app.DirectGroupUpdate(c);
					-- app.PrintDebug("Add-Crit",achievementID,uniqueID,"=>",c.hash)
					-- added to the npc group, not added to achievement
					criteriaObject = nil;
				elseif assetID and assetID > 0 then
					app.print("'achievement_criteria' NPC type missing NPC Source group!","NPC",assetID,app:Linkify("Achievement #"..achievementID,app.Colors.ChatLink,"search:achievementID:"..achievementID))
					criteriaObject.crs = { assetID };
				end
			-- Items
			elseif criteriaType == 36	-- Acquiring items (soulbound)
				or criteriaType == 41	-- Eating or drinking a specific item
				or criteriaType == 42	-- Fishing things up
				or criteriaType == 57	-- Having items (tabards and legendaries)
			then
				criteriaObject.providers = {{ "i", assetID }};
			-- Currency
			elseif criteriaType == 12	-- Collecting currency
			then
				criteriaObject.cost = {{ "c", assetID, reqQuantity }};
			-- Ignored
			elseif criteriaType == 29	-- Casting a spell (often crafting)
				or criteriaType == 43	-- Exploration
				or criteriaType == 52	-- Killing specific classes of player
				or criteriaType == 53	-- Kill-a-given-race (TODO?)
				or criteriaType == 54	-- Using emotes on targets
				or criteriaType == 69	-- Buff Gained
				or criteriaType == 110	-- Casting spells on specific target
			then
				-- nothing to do here
			else
				--app.print("Unhandled Criteria Type", criteriaType, assetID, achievementID);
				-- app.PrintDebug("Collecting currency",criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, uniqueID)
			end
			-- Criteria was not Sourced, so return it in search results
			if criteriaObject then
				CacheFields(criteriaObject);
				-- this criteria object may have been turned into a cost via costs/providers assignment, so make sure we update those respective costs via the Cost Runner
				-- if settings are changed while this is running, it's ok because it refreshes costs from the cache
				app.HandleEvent("OnSearchResultUpdate", criteriaObject)
				tinsert(searchResults, criteriaObject);
			end
		end
	end
end

-- Subroutine Logic Cache
local SubroutineCache = {
	["pvp_gear_base"] = function(finalized, searchResults, o, cmd, _, headerID1, headerID2)
		local select, find = ResolveFunctions.select, ResolveFunctions.find
		select(finalized, searchResults, o, "select", "headerID", headerID1);	-- Select the Season header
		if headerID2 then
			find(finalized, searchResults, o, "find", "headerID", headerID2);	-- Find the Set header
		end
	end,
	["pvp_gear_faction_base"] = function(finalized, searchResults, o, cmd, _, headerID1, headerID2, headerID3)
		local select, find = ResolveFunctions.select, ResolveFunctions.find
		select(finalized, searchResults, o, "select", "headerID", headerID1);	-- Select the Season header
		find(finalized, searchResults, o, "find", "headerID", headerID2);	-- Select the Faction header
		find(finalized, searchResults, o, "find", "headerID", headerID3);	-- Select the Set header
	end,
	-- Set Gear
	["pvp_set_ensemble"] = function(finalized, searchResults, o, cmd, _, headerID1, headerID2, classID)
		local select, find, extract = ResolveFunctions.select, ResolveFunctions.find, ResolveFunctions.extract
		select(finalized, searchResults, o, "select", "headerID", headerID1);	-- Select the Season header
		find(finalized, searchResults, o, "find", "headerID", headerID2);	-- Select the Set header
		find(finalized, searchResults, o, "find", "classID", classID);		-- Select the class header
		extract(finalized, searchResults, o, "extract", "sourceID");	-- Extract all Items with a SourceID
	end,
	["pvp_set_faction_ensemble"] = function(finalized, searchResults, o, cmd, _, headerID1, headerID2, headerID3, classID)
		local select, find, extract = ResolveFunctions.select, ResolveFunctions.find, ResolveFunctions.extract
		select(finalized, searchResults, o, "select", "headerID", headerID1);	-- Select the Season header
		find(finalized, searchResults, o, "find", "headerID", headerID2);	-- Select the Faction header
		find(finalized, searchResults, o, "find", "headerID", headerID3);	-- Select the Set header
		find(finalized, searchResults, o, "find", "classID", classID);		-- Select the class header
		extract(finalized, searchResults, o, "extract", "sourceID");	-- Extract all Items with a SourceID
	end,
	-- Weapons
	["pvp_weapons_ensemble"] = function(finalized, searchResults, o, cmd, _, headerID1, headerID2)
		local select, find, extract = ResolveFunctions.select, ResolveFunctions.find, ResolveFunctions.extract
		select(finalized, searchResults, o, "select", "headerID", headerID1);	-- Select the Season header
		find(finalized, searchResults, o, "find", "headerID", headerID2);	-- Select the Set header
		find(finalized, searchResults, o, "find", "headerID", app.HeaderConstants.WEAPONS);	-- Select the "Weapons" header.
		extract(finalized, searchResults, o, "extract", "sourceID");	-- Extract all Items with a SourceID
	end,
	["pvp_weapons_faction_ensemble"] = function(finalized, searchResults, o, cmd, _, headerID1, headerID2, headerID3)
		local select, find, extract = ResolveFunctions.select, ResolveFunctions.find, ResolveFunctions.extract
		select(finalized, searchResults, o, "select", "headerID", headerID1);	-- Select the Season header
		find(finalized, searchResults, o, "find", "headerID", headerID2);	-- Select the Faction header
		find(finalized, searchResults, o, "find", "headerID", headerID3);	-- Select the Set header
		find(finalized, searchResults, o, "find", "headerID", app.HeaderConstants.WEAPONS);	-- Select the "Weapons" header.
		extract(finalized, searchResults, o, "extract", "sourceID");	-- Extract all Items with a SourceID
	end,
	-- Common Northrend/Cataclysm Recipes Vendor
	["common_recipes_vendor"] = function(finalized, searchResults, o, cmd, npcID)
			local select, pop, is, exclude = ResolveFunctions.select, ResolveFunctions.pop, ResolveFunctions.is, ResolveFunctions.exclude;
		select(finalized, searchResults, o, "select", "creatureID", npcID);	-- Main Vendor
		pop(finalized, searchResults);	-- Remove Main Vendor and push his children into the processing queue.
		is(finalized, searchResults, o, "is", "itemID");	-- Only Items
		-- Exclude items specific to certain vendors
		exclude(finalized, searchResults, o, "exclude", "itemID",
			-- Borya <Tailoring Supplies> Cataclysm Tailoring
			6270,	-- Pattern: Blue Linen Vest
			6274,	-- Pattern: Blue Overalls
			10314,	-- Pattern: Lavender Mageweave Shirt
			10317,	-- Pattern: Pink Mageweave Shirt
			5772,	-- Pattern: Red Woolen Bag
			-- Sumi <Blacksmithing Supplies> Cataclysm Blacksmithing
			12162,	-- Plans: Hardened Iron Shortsword
			-- Tamar <Leatherworking Supplies> Cataclysm Leatherworking
			18731,	-- Pattern: Heavy Leather Ball
			-- Kithas <Enchanting Supplies> Cataclysm Enchanting
			6349,	-- Formula: Enchant 2H Weapon - Lesser Intellect
			20753,	-- Formula: Lesser Wizard Oil
			20752,	-- Formula: Minor Mana Oil
			20758,	-- Formula: Minor Wizard Oil
			22307,	-- Pattern: Enchanted Mageweave Pouch
			-- Marith Lazuria <Jewelcrafting Supplies> Cataclysm Jewelcrafting
			-- Shazdar <Sous Chef> Cataclysm Cooking
			-- Tiffany Cartier <Jewelcrafting Supplies> Northrend Jewelcrafting
			-- Timothy Jones <Jewelcrafting Trainer> Northrend Jewelcrafting
		0);	-- 0 allows the trailing comma on previous itemIDs for cleanliness
	end,
	["common_vendor"] = function(finalized, searchResults, o, cmd, npcID)
		local select, pop, is = ResolveFunctions.select, ResolveFunctions.pop, ResolveFunctions.is;
		select(finalized, searchResults, o, "select", "npcID", npcID);	-- Main Vendor
		pop(finalized, searchResults);	-- Remove Main Vendor and push his children into the processing queue.
	end,
	-- TW Instance
	["tw_instance"] = function(finalized, searchResults, o, cmd, instanceID)
		local select, pop, whereany, push, finalize = ResolveFunctions.select, ResolveFunctions.pop, ResolveFunctions.whereany, ResolveFunctions.push, ResolveFunctions.finalize;
		select(finalized, searchResults, o, "select", "itemID", 133543);	-- Infinite Timereaver
		push(finalized, searchResults, o, "push", "headerID", app.HeaderConstants.COMMON_BOSS_DROPS);	-- Push into 'Common Boss Drops' header
		finalize(finalized, searchResults);	-- capture current results
		select(finalized, searchResults, o, "select", "instanceID", instanceID);	-- select this instance
		whereany(finalized, searchResults, o, "whereany", "e", unpack(app.TW_EventIDs or app.EmptyTable) );	-- Select any TIMEWALKING eventID
		if #searchResults > 0 then o.e = searchResults[1].e; end
		pop(finalized, searchResults);	-- pop the instance header
	end,
	["instance_tier"] = function(finalized, searchResults, o, cmd, instanceID, difficultyID, classID)
		local select, pop, where, extract, invtype =
			ResolveFunctions.select,
			ResolveFunctions.pop,
			ResolveFunctions.where,
			ResolveFunctions.extract,
			ResolveFunctions.invtype;

		-- Select the Instance & pop out all results
		select(finalized, searchResults, o, "select", "instanceID", instanceID);
		pop(finalized, searchResults);

		-- If there's a Difficulty, filter by Difficulty
		if difficultyID then
			where(finalized, searchResults, o, "where", "difficultyID", difficultyID);
			pop(finalized, searchResults);
		end

		-- Extract the Items that have a Class restriction
		extract(finalized, searchResults, o, "extract", "c");

		local orig;
		-- Pop out any actual Tier Tokens
		if #searchResults > 0 then
			orig = CloneArray(searchResults);
		end
		wipe(searchResults);
		if orig then
			for _,o in ipairs(orig) do
				if not o.f then
					if o.g then
						-- no filter Item with sub-groups
						ArrayAppend(searchResults, o.g)
					else
						-- no filter Item without sub-groups, keep it directly in case it is a cost for the actual Tier pieces
						tinsert(searchResults, o);
					end
				end
			end
		end

		-- Exclude anything that isn't a Tier slot
		invtype(finalized, searchResults, o, "invtype",
			"INVTYPE_HEAD",
			"INVTYPE_SHOULDER",
			"INVTYPE_CHEST", "INVTYPE_ROBE",
			"INVTYPE_LEGS",
			"INVTYPE_HAND"
		);

		-- If there's a Class, filter by Class
		if classID then
			if #searchResults > 0 then
				orig = CloneArray(searchResults);
			end
			wipe(searchResults);
			local c;
			if orig then
				for _,o in ipairs(orig) do
					c = o.c;
					if c and ContainsAnyValue(c, classID) then
						tinsert(searchResults, o);
					end
				end
			end
		end
	end,
};
app.RegisterSymlinkResolveFunction = function(name, method)
	ResolveFunctions[name] = method;
end
app.RegisterSymlinkSubroutine = function(name, method)
	-- NOTE: This passes a function to call immediately and cache used resolve functions.
	SubroutineCache[name] = method(ResolveFunctions);
end
-- TODO: when symlink becomes a stand-alone Module, it should work like this
-- Don't expect every caller to know what event is proper for registering a symlink
-- Plus we need to ensure RegisterSymlinkResolveFunction handles additions prior to all RegisterSymlinkSubroutine
-- Since we won't know the order of the callers assigning the handlers
-- local RegisteredSymlinkSubroutines, RegisteredResolveFunctions = {}
-- app.RegisterSymlinkResolveFunction = function(name, method)
-- 	RegisteredResolveFunctions[name] = method
-- end
-- app.RegisterSymlinkSubroutine = function(name, method)
-- 	-- NOTE: This stores a function to call immediately OnLoad and cache used resolve functions.
-- 	RegisteredSymlinkSubroutines[name] = method
-- end
-- app.AddEventHandler("OnLoad", function()
-- 	for name,method in pairs(RegisteredResolveFunctions) do
-- 		ResolveFunctions[name] = method
-- 	end
-- 	for name,method in pairs(RegisteredSymlinkSubroutines) do
-- 		SubroutineCache[name] = method(ResolveFunctions)
-- 	end
-- end);
-- Instruction to perform a specific subroutine using provided input values
ResolveFunctions.sub = function(finalized, searchResults, o, cmd, sub, ...)
	local subroutine = SubroutineCache[sub];
	-- new logic: no metatable cloning, no table creation for sub-commands
	if subroutine then
		-- app.PrintDebug("sub",o.hash,sub,...)
		subroutine(finalized, searchResults, o, cmd, ...);
		-- each subroutine result is finalized after being processed
		ResolveFunctions.finalize(finalized, searchResults);
		return;
	end
	app.print("Could not find subroutine", sub);
end;
local NonSelectCommands = {
	finalize = true,
	achievement_criteria = true,
	sub = true,
	myModID = true,
	modID = true,
	usemyModID = true,
	usemodID = true,
}
local HandleCommands = app.Debugging and function(finalized, searchResults, o, oSym)
	local cmd, cmdFunc
	local debug = true
	for _,sym in ipairs(oSym) do
		cmd = sym[1];
		cmdFunc = ResolveFunctions[cmd];
		-- app.PrintDebug("sym: '",cmd,"' for",o.hash,"with:",unpack(sym))
		if cmdFunc then
			cmdFunc(finalized, searchResults, o, unpack(sym));
			if debug and #searchResults == 0 and not NonSelectCommands[cmd] then
				app.PrintDebug(Colorize("Symlink command with no results for: "..app:SearchLink(o), app.Colors.ChatLinkError),"@",_,unpack(sym))
				app.PrintTable(oSym)
				debug = false
			end
		else
			app.print("Unknown symlink command",cmd);
		end
		-- app.PrintDebug("Finalized",#finalized,"Results",#searchResults,"from",o.hash,"with:",unpack(sym))
	end
end or function(finalized, searchResults, o, oSym)
	local cmd, cmdFunc
	for _,sym in ipairs(oSym) do
		cmd = sym[1];
		cmdFunc = ResolveFunctions[cmd];
		if cmdFunc then
			cmdFunc(finalized, searchResults, o, unpack(sym));
		else
			app.print("Unknown symlink command",cmd);
		end
	end
end
local ResolveCache = {};
ResolveSymbolicLink = function(o, refonly)
	local oSym = o.sym
	if not oSym then return end

	local oHash, oKey = o.hash, o.key;
	if o.resolved or (oKey and app.ThingKeys[oKey] and ResolveCache[oHash]) then
		if refonly then
			return o.resolved or ResolveCache[oHash]
		end
		-- app.PrintDebug(o.resolved and "Object Resolve" or "Cache Resolve",oHash,#(o.resolved or ResolveCache[oHash]))
		local cloned = {};
		MergeObjects(cloned, o.resolved or ResolveCache[oHash], true);
		return cloned;
	end

	FinalizeModID = nil;
	PruneFinalized = nil;
	FillFinalized = nil
	-- app.PrintDebug("Fresh Resolve:",oHash)
	local searchResults, finalized = {}, {};
	HandleCommands(finalized, searchResults, o, oSym)

	-- Verify the final result is finalized
	ResolveFunctions.finalize(finalized, searchResults);
	-- app.PrintDebug("Forced Finalize",oKey,oKey and o[oKey],#finalized)

	-- If we had any finalized search results, then clone all the records, store the results, and return them
	if #finalized == 0 then
		-- app.PrintDebug("Symbolic Link for ", oKey, " ",oKey and o[oKey], " contained no values after filtering.")
		return
	end
	local cloned = {};
	-- app.PrintDebug("Symbolic Link for", oKey,oKey and o[oKey], "contains", #cloned, "values after filtering.")
	local sHash, clone
	local Fill = app.FillGroups
	for i=1,#finalized do
		clone = finalized[i]

		-- if somehow the symlink pulls in the same item as used as the source of the symlink, notify in chat and clear any symlink on it
		sHash = clone.hash;
		if clone == o or (sHash and sHash == oHash) then
			app.print("Symlink group pulled itself into finalized results!",oHash,o.key,o.modItemID,o.link or o.text,i,FinalizeModID)
		else
			clone = CreateObject(clone)
			cloned[#cloned + 1] = clone

			-- Apply any modID if necessary
			if FinalizeModID and clone.itemID and clone.modID ~= FinalizeModID then
				clone.modID = FinalizeModID;
				-- refresh the item group since certain metadata may be different now
				app.RefreshItemGroup(clone)
			end
			if PruneFinalized then
				for _,field in ipairs(PruneFinalized) do
					clone[field] = nil
				end
			end
			if FillFinalized then
				-- app.PrintDebug("Fill",clone.hash)
				Fill(clone)
				clone.skipFill = 2
			end

			-- in symlinking a Thing to another Source, we are effectively declaring that it is Sourced within this Source, for the specific scope
			clone.symParent = clone.parent
			clone.sourceParent = nil;
			clone.parent = nil;
		end
	end
	if oKey and app.ThingKeys[oKey] then
		-- global resolve cache if it's a 'Thing'
		-- app.PrintDebug("Thing Results",oHash,#cloned)
		ResolveCache[oHash] = cloned;
	elseif oKey ~= false then
		-- otherwise can store it in the object itself (like a header from the Main list with symlink), if it's not specifically a pseudo-symlink resolve group
		o.resolved = cloned;
		-- app.PrintDebug("Object Results",oHash,#cloned)
	end
	return cloned;
end
app.ResolveSymbolicLink = ResolveSymbolicLink

local function ResolveSymlinkGroupAsync(group)
	-- app.PrintDebug("RSGa",group.hash)
	local groups = ResolveSymbolicLink(group);
	group.sym = nil;
	if groups then
		PriorityNestObjects(group, groups, nil, app.RecursiveCharacterRequirementsFilter, app.RecursiveGroupRequirementsFilter);
		-- app.PrintDebug("RSGa",group.g and #group.g,group.hash)
		-- newly added group data needs to be checked again for further content to fill, since it will not have been recursively checked
		-- on the initial pass due to the async nature
		app.FillGroups(group);
		AssignChildren(group);
		-- auto-expand the symlink group
		ExpandGroupsRecursively(group, true);
		app.DirectGroupUpdate(group);
	end
end
-- Fills the symlinks within a group by using an 'async' process to spread the filler function over multiple game frames to reduce stutter or apparent lag
-- NOTE: ONLY performs the symlink for 'achievement_criteria'
app.FillAchievementCriteriaAsync = function(o)
	local sym = o.sym
	if not sym then return end

	local sym = sym[1][1]
	if sym ~= "achievement_criteria" then return end

	-- app.PrintDebug("resolve achievement_criteria",o.hash)
	app.FillRunner.Run(ResolveSymlinkGroupAsync, o);
end
end	-- Symlink Lib

do
local ContainsLimit, ContainsExceeded;
local Indicator, GetProgressTextForRow, GetUnobtainableTexture
app.AddEventHandler("OnLoad", function()
	GetProgressTextForRow = app.GetProgressTextForRow
	Indicator = app.GetIndicatorIcon
	GetUnobtainableTexture = app.GetUnobtainableTexture
end)

local MaxLayer = 4
local Indents = {
	"  ",
}
for i=2,MaxLayer do
	Indents[i] = Indents[i-1].."  "
end
local ContainsTypesIndicators
app.AddEventHandler("OnStartup", function() ContainsTypesIndicators = app.Modules.Fill.Settings.Icons end)
local function BuildContainsInfo(root, entries, indent, layer)
	local subgroups = root and root.g
	if not subgroups or #subgroups == 0 then return end

	for _,group in ipairs(subgroups) do
		-- If there's progress to display for a non-sourceIgnored group, then let's summarize a bit better.
		if group.visible and not group.sourceIgnored and not group.skipContains then
			-- Special case to ignore 'container' layers where the container is a Header which matches the ItemID of the parent
			if group.headerID and group.headerID == root.itemID then
				BuildContainsInfo(group, entries, indent, layer)
			else
				-- Count it, but don't actually add it to entries if it meets the limit
				if #entries >= ContainsLimit then
					ContainsExceeded = ContainsExceeded + 1;
				else
					-- Insert into the display.
					-- app.PrintDebug("INCLUDE",app.Debugging,GetProgressTextForRow(group),group.hash,group.key,group.key and group[group.key])
					local o = { group = group, right = GetProgressTextForRow(group) };
					local indicator = ContainsTypesIndicators[group.filledType] or Indicator(group);
					o.prefix = indicator and (Indents[indent]:sub(3) .. "|T" .. indicator .. ":0|t ") or Indents[indent]
					entries[#entries + 1] = o
				end

				-- Only go down one more level.
				if layer < MaxLayer then
					BuildContainsInfo(group, entries, indent + 1, layer + 1);
				end
			end
			-- else
			-- 	app.PrintDebug("EXCLUDE",app.Debugging,GetProgressTextForRow(group),group.hash,group.key,group.key and group[group.key])
		end
	end
end
-- Fields on groups which can be utilized in tooltips to show additional Source location info for that group (by order of priority)
local TooltipSourceFields = {
	"professionID",
	"instanceID",
	"mapID",
	"maps",
	"npcID",
	"questID"
};
local SourceLocationSettingsKey = setmetatable({
	creatureID = "SourceLocations:Creatures",
	npcID = "SourceLocations:Creatures",
}, {
	__index = function(t, key)
		return "SourceLocations:Things";
	end
});
local UnobtainableTexture = " |T"..L.UNOBTAINABLE_ITEM_TEXTURES[1]..":0|t"
local NotCurrentCharacterTexture = " |T"..L.UNOBTAINABLE_ITEM_TEXTURES[0]..":0|t"
local SummarizeShowForActiveRowKeys
local function AddContainsData(group, tooltipInfo)
	local key = group.key
	-- only show Contains on Things
	if not app.ThingKeys[key] or (app.ActiveRowReference and not SummarizeShowForActiveRowKeys[key]) then return end
	local id = group[key]
	local working = group.working
	-- Sort by the heirarchy of the group if not the raw group of an ATT list
	if not working and not app.ActiveRowReference then
		app.Sort(group.g, app.SortDefaults.Hierarchy, true);
	end
	-- app.PrintDebug("SummarizeThings",app:SearchLink(group),group.g and #group.g)
	local entries = {};
	-- app.Debugging = "CONTAINS-"..group.hash;
	ContainsLimit = app.Settings:GetTooltipSetting("ContainsCount") or 25;
	ContainsExceeded = 0;
	BuildContainsInfo(group, entries, 1, 1)
	-- app.Debugging = nil;
	-- app.PrintDebug(entries and #entries,"contains entries")
	if #entries > 0 then
		local left, right;
		tinsert(tooltipInfo, { left = L.CONTAINS });
		local item, entry;
		local RecursiveParentField = app.GetRelativeValue
		for i=1,#entries do
			item = entries[i];
			entry = item.group;
			if not entry.objectiveID then
				left = entry.text;
				if not left or IsRetrieving(left) then
					left = RETRIEVING_DATA;
					working = true;
				end
				left = TryColorizeName(entry, left);
				-- app.PrintDebug("Entry#",i,app:SearchLink(entry),app.GenerateSourcePathForTooltip(entry))

				-- If this entry has a specific Class requirement and is not itself a 'Class' header, tack that on as well
				if entry.c and entry.key ~= "classID" and #entry.c == 1 then
					left = left .. " [" .. TryColorizeName(entry, app.ClassInfoByID[entry.c[1]].name) .. "]";
				end
				if entry.icon then item.prefix = item.prefix .. "|T" .. entry.icon .. ":0|t "; end

				-- If this entry has specialization requirements, let's attempt to show the specialization icons.
				right = item.right;
				local specs = entry.specs;
				if specs and #specs > 0 then
					right = GetSpecsString(specs, false, false) .. right;
				else
					local c = entry.c;
					if c and #c > 0 then
						right = GetClassesString(c, false, false) .. right;
					end
				end

				-- If this entry has customCollect requirements, list them for clarity
				if entry.customCollect then
					for i,c in ipairs(entry.customCollect) do
						local reason = L.CUSTOM_COLLECTS_REASONS[c];
						local icon_color_str = reason.icon.." |c"..reason.color..reason.text;
						if i > 1 then
							right = icon_color_str .. " / " .. right;
						else
							right = icon_color_str .. "  " .. right;
						end
					end
				end

				-- If this entry is an Item, show additional Source information for that Item (since it needs to be acquired in a specific location most-likely)
				if entry.itemID and key ~= "npcID" and key ~= "encounterID" then
					-- Add the Zone name
					local field, id;
					for _,v in ipairs(TooltipSourceFields) do
						id = RecursiveParentField(entry, v, true);
						-- print("check",v,id)
						if id then
							field = v;
							break;
						end
					end
					if field then
						local locationGroup, locationName;
						-- convert maps
						if field == "maps" then
							-- if only a few maps, list them all
							local count = #id;
							if count == 1 then
								locationName = app.GetMapName(id[1]);
							else
								-- instead of listing individual zone names, just list zone count for brevity
								local names = {__count=0}
								local name
								for j=1,count,1 do
									name = app.GetMapName(id[j]);
									if name and not names[name] then
										names.__count = names.__count + 1
									end
								end
								locationName = "["..names.__count.." "..BRAWL_TOOLTIP_MAPS.."]"
								-- old: list 3 zones/+++
								-- local mapsConcat, names, name = {}, {}, nil;
								-- for j=1,count,1 do
								-- 	name = app.GetMapName(id[j]);
								-- 	if name and not names[name] then
								-- 		names[name] = true;
								-- 		mapsConcat[#mapsConcat + 1] = name
								-- 	end
								-- end
								-- -- 1 unique map name displayed
								-- if #mapsConcat < 2 then
								-- 	locationName = app.TableConcat(mapsConcat, nil, nil, "/");
								-- else
								-- 	mapsConcat[2] = "+"..(count - 1);
								-- 	locationName = app.TableConcat(mapsConcat, nil, nil, "/", 1, 2);
								-- end
							end
						else
							locationGroup = SearchForObject(field, id, "field") or (id and field == "mapID" and C_Map_GetMapInfo(id));
							locationName = locationGroup and TryColorizeName(locationGroup, locationGroup.name);
						end
						-- print("contains info",entry.itemID,field,id,locationGroup,locationName)
						if locationName then
							-- Add the immediate parent group Vendor name
							local rawParent, sParent = rawget(entry, "parent"), entry.sourceParent;
							-- the source entry is different from the raw parent and the search context, then show the source parent text for reference
							if sParent and sParent.text and not GroupMatchesParams(rawParent, sParent.key, sParent[sParent.key]) and not GroupMatchesParams(sParent, key, id) then
								local parentText = sParent.text;
								if IsRetrieving(parentText) then
									working = true;
								end
								right = locationName .. " > " .. parentText .. " " .. right;
							else
								right = locationName .. " " .. right;
							end
						-- else
							-- print("No Location name for item",entry.itemID,id,field)
						end
					end
				end

				-- If this entry is an Achievement Criteria (whose raw parent is not the Achievement) then show the Achievement
				if entry.criteriaID and entry.achievementID then
					local rawParent = rawget(entry, "parent");
					if not rawParent or rawParent.achievementID ~= entry.achievementID then
						local critAch = SearchForObject("achievementID", entry.achievementID, "key");
						left = left .. " > " .. (critAch and critAch.text or "???");
					end
				end

				tinsert(tooltipInfo, { left = item.prefix .. left, right = right });
			end
		end

		if ContainsExceeded > 0 then
			tinsert(tooltipInfo, { left = (L.AND_MORE):format(ContainsExceeded) });
		end

		if app.Settings:GetTooltipSetting("Currencies") then
			local currencyCount = app.CalculateTotalCosts(group, id)
			if currencyCount > 0 then
				tinsert(tooltipInfo, { left = L.CURRENCY_NEEDED_TO_BUY, right = formatNumericWithCommas(currencyCount) });
			end
		end
	end
	return working
end
app.AddEventHandler("OnLoad", function()
	SummarizeShowForActiveRowKeys = app.CloneDictionary(app.ThingKeys, {
		-- Specific keys which we don't want to list Contains data on row reference tooltips but are considered Things
		npcID = false,
		creatureID = false,
		encounterID = false,
		explorationID = false,
	})
	app.Settings.CreateInformationType("SummarizeThings", {
		text = "SummarizeThings",
		priority = 2.9, HideCheckBox = true,
		Process = function(t, reference, tooltipInfo)
			if reference.g then
				if AddContainsData(reference, tooltipInfo) then
					reference.working = true
				end
			end
		end
	})
end)

local SourceSearcher = app.SourceSearcher

local function AddSourceLinesForTooltip(tooltipInfo, paramA, paramB)
	-- Create a list of sources
	-- app.PrintDebug("SourceLocations",paramA,paramB,SourceLocationSettingsKey[paramA])
	if not app.ThingKeys[paramA] then return end
	local settings = app.Settings
	if not settings:GetTooltipSetting("SourceLocations") or not settings:GetTooltipSetting(SourceLocationSettingsKey[paramA]) then return end

	local text, parent, right
	local character, unavailable, unobtainable = {}, {}, {}
	local showUnsorted = settings:GetTooltipSetting("SourceLocations:Unsorted");
	local showCompleted = settings:GetTooltipSetting("SourceLocations:Completed");
	local FilterSettings, FilterInGame, FilterCharacter, FirstParent
		= app.RecursiveGroupRequirementsFilter, app.Modules.Filter.Filters.InGame, app.RecursiveCharacterRequirementsFilter, app.GetRelativeGroup
	local abbrevs = L.ABBREVIATIONS;
	local sourcesToShow
	-- paramB is the modItemID for itemID searches, so we may have to fallback to the base itemID if nothing sourced for the modItemID
	-- TODO: Rings from raid showing all difficulties, need fallback matching for items... modItemID, modID, itemID
	-- using a second return, directSources, to indicate the SourceSearcher has returned the Sources rather than the Things
	local allReferences, directSources = SourceSearcher[paramA](paramA,paramB)
	-- app.PrintDebug(directSources and "Source count" or "Search count",#allReferences,paramA,paramB,GetItemIDAndModID(paramB))
	for _,j in ipairs(allReferences or app.EmptyTable) do
		parent = directSources and j or j.parent
		-- app.PrintDebug("source:",app:SearchLink(j),parent and parent.parent,showCompleted or not app.IsComplete(j))
		if parent and parent.parent
			and (showCompleted or not app.IsComplete(j))
		then
			text = app.GenerateSourcePathForTooltip(parent);
			-- app.PrintDebug("SourceLocation",text,FilterInGame(j),FilterSettings(parent),FilterCharacter(parent))
			if showUnsorted or (not text:match(L.UNSORTED) and not text:match(L.HIDDEN_QUEST_TRIGGERS)) then
				-- doesn't meet current unobtainable filters from the Thing itself
				if not FilterInGame(parent) then
					unobtainable[#unobtainable + 1] = text..UnobtainableTexture
				else
					-- something user would currently see in a list or not
					sourcesToShow = FilterSettings(parent) and character or unavailable
					-- from obtainable, different character source
					if not FilterCharacter(parent) then
						sourcesToShow[#sourcesToShow + 1] = text..NotCurrentCharacterTexture
					else
						-- check if this needs a status icon even though it's being shown
						right = GetUnobtainableTexture(FirstParent(parent, "e", true) or FirstParent(parent, "u", true) or parent)
							or (parent.rwp and app.asset("status-prerequisites"))
						if right then
							sourcesToShow[#sourcesToShow + 1] = text.." |T" .. right .. ":0|t"
						else
							sourcesToShow[#sourcesToShow + 1] = text
						end
					end
				end
			end
		end
	end
	-- app.PrintDebug("Sources count",#character,#unobtainable)
	-- if in Debug, add any unobtainable & unavailable sources
	if app.MODE_DEBUG then
		-- app.PrintDebug("+unavailable",#unavailable,"+unobtainable",#unobtainable)
		app.ArrayAppend(character, unavailable, unobtainable)
	elseif #character == 0 and not (paramA == "creatureID" or paramA == "encounterID") then
		-- no sources available to the character, add any unavailable/unobtainable sources
		if #unavailable > 0 then
			-- app.PrintDebug("+unavailable",#unavailable)
			app.ArrayAppend(character, unavailable)
		elseif #unobtainable > 0 then
			-- app.PrintDebug("+unobtainable",#unobtainable)
			app.ArrayAppend(character, unobtainable)
		end
	end
	if #character > 0 then
		local listing = {};
		local maximum = settings:GetTooltipSetting("Locations");
		local count = 0;
		app.Sort(character, app.SortDefaults.Strings);
		for _,text in ipairs(character) do
			-- since the strings are sorted, we only need to add ones that are not equal to the previously-added one
			-- instead of checking all existing strings
			if listing[#listing] ~= text then
				count = count + 1;
				if count <= maximum then
					listing[#listing + 1] = text
					-- app.PrintDebug("add source",text)
				end
			-- else app.PrintDebug("exclude source by last match",text)
			end
		end
		if count > maximum then
			listing[#listing + 1] = (L.AND_OTHER_SOURCES):format(count - maximum)
		end
		if #listing > 0 then
			local wrap = settings:GetTooltipSetting("SourceLocations:Wrapping");
			local working
			for _,text in ipairs(listing) do
				for source,replacement in pairs(abbrevs) do
					text = text:gsub(source, replacement);
				end
				if not working and IsRetrieving(text) then working = true; end
				local left, right = DESCRIPTION_SEPARATOR:split(text);
				tooltipInfo[#tooltipInfo + 1] = { left = left, right = right, wrap = wrap }
			end
			tooltipInfo.hasSourceLocations = true;
			return working
		end
	end
end
app.AddEventHandler("OnLoad", function()
	local SourceShowKeys = app.CloneDictionary(app.ThingKeys, {
		-- Specific keys which we don't want to list Sources but are considered Things
		npcID = false,
		creatureID = false,
		encounterID = false,
		explorationID = false,
	})
	app.Settings.CreateInformationType("SourceLocations", {
		priority = 2.7,
		text = "Source Locations",
		HideCheckBox = true,
		Process = function(t, reference, tooltipInfo)
			local key = reference.key
			local id = key == "itemID" and reference.modItemID or reference[key]
			if key and id and SourceShowKeys[key] then
				if tooltipInfo.hasSourceLocations then return end
				if AddSourceLinesForTooltip(tooltipInfo, key, id) then
					reference.working = true
				end
			end
		end
	})
end)

local unpack = unpack
local function GetSearchResults(method, paramA, paramB, options)
	-- app.PrintDebug("GetSearchResults",method,paramA,paramB)
	if not method then
		print("GetSearchResults: Invalid method: nil");
		return nil, true;
	end
	if not paramA then
		print("GetSearchResults: Invalid paramA: nil");
		return nil, true;
	end

	-- If we are searching for only one parameter, it is a raw link.
	local rawlink;
	if paramB then paramB = tonumber(paramB);
	else rawlink = paramA; end

	local RecursiveCharacterRequirementsFilter, RecursiveGroupRequirementsFilter
		= app.RecursiveCharacterRequirementsFilter, app.RecursiveGroupRequirementsFilter

	-- Call to the method to search the database.
	local group, a, b
	if options and options.AppendSearchParams then
		group, a, b = method(paramA, paramB, unpack(options.AppendSearchParams))
	else
		group, a, b = method(paramA, paramB)
	end
	-- app.PrintDebug("GetSearchResults:method",group and #group,a,b)
	if group then
		if a then paramA = a; end
		if b then paramB = b; end
		if paramA == "modItemID" then paramA = "itemID" end
		-- Move all post processing here?
		if #group > 0 then
			-- For Creatures, Objects and Encounters that are inside of an instance, we only want the data relevant for the instance + difficulty.
			if paramA == "creatureID" or paramA == "npcID" or paramA == "encounterID" or paramA == "objectID" then
				local subgroup = {};
				for _,j in ipairs(group) do
					if not j.ShouldExcludeFromTooltip then
						tinsert(subgroup, j);
					end
				end
				group = subgroup;
			elseif paramA == "azeriteessenceID" then
				local regroup = {};
				local rank = options and options.Rank
				if app.MODE_ACCOUNT then
					for i,j in ipairs(group) do
						if j.rank == rank and app.RecursiveUnobtainableFilter(j) then
							if j.mapID or j.parent == nil or j.parent.parent == nil then
								tinsert(regroup, setmetatable({["g"] = {}}, { __index = j }));
							else
								tinsert(regroup, j);
							end
						end
					end
				else
					for i,j in ipairs(group) do
						if j.rank == rank and RecursiveCharacterRequirementsFilter(j) and app.RecursiveUnobtainableFilter(j) and RecursiveGroupRequirementsFilter(j) then
							if j.mapID or j.parent == nil or j.parent.parent == nil then
								tinsert(regroup, setmetatable({["g"] = {}}, { __index = j }));
							else
								tinsert(regroup, j);
							end
						end
					end
				end

				group = regroup;
			elseif paramA == "titleID" or paramA == "followerID" then
				-- Don't do anything
				local regroup = {};
				if app.MODE_ACCOUNT then
					for i,j in ipairs(group) do
						if app.RecursiveUnobtainableFilter(j) then
							tinsert(regroup, setmetatable({["g"] = {}}, { __index = j }));
						end
					end
				else
					for i,j in ipairs(group) do
						if RecursiveCharacterRequirementsFilter(j) and app.RecursiveUnobtainableFilter(j) and RecursiveGroupRequirementsFilter(j) then
							tinsert(regroup, setmetatable({["g"] = {}}, { __index = j }));
						end
					end
				end

				group = regroup;
			end
		end
	else
		group = {};
	end

	-- Determine if this is a cache for an item
	if rawlink and not paramB then
		local itemString = CleanLink(rawlink)
		if itemString:match("item") then
			-- app.PrintDebug("Rawlink SourceID",sourceID,rawlink)
			local _, itemID, enchantId, gemId1, gemId2, gemId3, gemId4, suffixId, uniqueId, linkLevel, specializationID, upgradeId, linkModID, numBonusIds, bonusID1 = (":"):split(itemString);
			if itemID then
				itemID = tonumber(itemID);
				local modID = tonumber(linkModID) or 0;
				if modID == 0 then modID = nil; end
				local bonusID = (tonumber(numBonusIds) or 0) > 0 and tonumber(bonusID1) or 3524;
				if bonusID == 3524 then bonusID = nil; end
				local sourceID = app.GetSourceID(rawlink);
				if sourceID then
					paramA = "sourceID"
					paramB = sourceID
					-- app.PrintDebug("use sourceID params",paramA,paramB)
				else
					paramA = "itemID";
					paramB = GetGroupItemIDWithModID(nil, itemID, modID, bonusID) or itemID;
					-- app.PrintDebug("use itemID params",paramA,paramB)
				end
			end
		else
			local kind, id = (":"):split(rawlink);
			kind = kind:lower();
			if id then id = tonumber(id); end
			if kind == "itemid" then
				paramA = "itemID";
				paramB = id;
			elseif kind == "questid" then
				paramA = "questID";
				paramB = id;
			elseif kind == "creatureid" or kind == "npcid" then
				paramA = "creatureID";
				paramB = id;
			elseif kind == "achievementid" then
				paramA = "achievementID";
				paramB = id;
			end
		end
	end

	-- Create clones of the search results
	if not group.g then
		-- Clone all the non-ignored groups so that things don't get modified in the Source
		-- app.PrintDebug("Cloning Roots for",paramA,paramB,"#group",group and #group);
		local cloned = {};
		for _,o in ipairs(group) do
			-- app.PrintDebug("Clone:",app:SearchLink(o),GetRelativeValue(o, "sourceIgnored"),app.GetRelativeRawWithField(o, "sourceIgnored"),app.GenerateSourcePathForTooltip(o))
			if not GetRelativeValue(o, "sourceIgnored") then
				cloned[#cloned + 1] = CreateObject(o)
			end
		end
		-- replace the Source references with the cloned references
		group = cloned;
		local clearSourceParent = #group > 1;
		-- Find or Create the root group for the search results, and capture the results which need to be nested instead
		local root, filtered
		local nested = {};
		-- app.PrintDebug("Find Root for",paramA,paramB,"#group",group and #group);
		-- check for Item groups in a special way to account for extra ID's
		if paramA == "itemID" then
			local refinedMatches = app.GroupBestMatchingItems(group, paramB);
			if refinedMatches then
				-- move from depth 3 to depth 1 to find the set of items which best matches for the root
				for depth=3,1,-1 do
					if refinedMatches[depth] then
						-- app.PrintDebug("refined",depth,#refinedMatches[depth])
						if not root then
							for _,o in ipairs(refinedMatches[depth]) do
								-- object meets filter criteria and is exactly what is being searched
								if RecursiveCharacterRequirementsFilter(o) then
									-- app.PrintDebug("filtered root");
									if root then
										if filtered then
											-- app.PrintDebug("merge root",app:SearchLink(o));
											-- app.PrintTable(o)
											MergeProperties(root, o, filtered);
											-- other root content will be nested after
											MergeObjects(nested, o.g);
										else
											local otherRoot = root;
											-- app.PrintDebug("replace root",app:SearchLink(otherRoot));
											root = o;
											MergeProperties(root, otherRoot);
											-- previous root content will be nested after
											MergeObjects(nested, otherRoot.g);
										end
									else
										root = o;
										-- app.PrintDebug("first root",app:SearchLink(o));
									end
									filtered = true
								else
									-- app.PrintDebug("unfiltered root",app:SearchLink(o),o.modItemID,paramB);
									if root then MergeProperties(root, o, true);
									else root = o; end
								end
							end
						else
							for _,o in ipairs(refinedMatches[depth]) do
								-- Not accurate matched enough to be the root, so it will be nested
								-- app.PrintDebug("nested",app:SearchLink(o))
								nested[#nested + 1] = o
							end
						end
					end
				end
			end
		else
			for _,o in ipairs(group) do
				-- If the obj "is" the root obj
				-- app.PrintDebug(o.key,o[o.key],o.modItemID,"=parent>",o.parent and o.parent.key,o.parent and o.parent.key and o.parent[o.parent.key],o.parent and o.parent.text);
				if GroupMatchesParams(o, paramA, paramB) then
					-- object meets filter criteria and is exactly what is being searched
					if RecursiveCharacterRequirementsFilter(o) then
						-- app.PrintDebug("filtered root");
						if root then
							if filtered then
								-- app.PrintDebug("merge root",o.key,o[o.key]);
								-- app.PrintTable(o)
								MergeProperties(root, o, filtered);
								-- other root content will be nested after
								MergeObjects(nested, o.g);
							else
								local otherRoot = root;
								-- app.PrintDebug("replace root",otherRoot.key,otherRoot[otherRoot.key]);
								-- app.PrintTable(o)
								root = o;
								MergeProperties(root, otherRoot);
								-- previous root content will be nested after
								MergeObjects(nested, otherRoot.g);
							end
						else
							-- app.PrintDebug("first root",o.key,o[o.key]);
							-- app.PrintTable(o)
							root = o;
						end
						filtered = true
					else
						-- app.PrintDebug("unfiltered root",o.key,o[o.key],o.modItemID,paramB);
						if root then MergeProperties(root, o, true);
						else root = o; end
					end
				else
					-- Not the root, so it will be nested
					-- app.PrintDebug("nested")
					nested[#nested + 1] = o
				end
			end
		end
		if not root then
			-- app.PrintDebug("Create New Root",paramA,paramB)
			if paramA == "criteriaID" then
				local critID, achID = (":"):split(paramB)
				root = CreateObject({ [paramA] = tonumber(critID), achievementID = tonumber(achID) })
			else
				root = CreateObject({ [paramA] = paramB })
			end
			root.missing = true
		end
		-- If rawLink exists, import it into the root
		if rawlink then app.ImportRawLink(root, rawlink); end
		-- Ensure the param values are consistent with the new root object values (basically only affects creatureID)
		paramA, paramB = root.key, root[root.key];
		-- Special Case for itemID, need to use the modItemID for accuracy in item matching
		if root.itemID then
			if paramA ~= "sourceID" then
				paramA = "itemID"
				paramB = root.modItemID or paramB
			end
			-- if our item root has a bonusID, then we will rely on upgrade module to provide any upgrade
			-- raw groups with 'up' will never be sourced with a bonusID
			local bonusID = root.bonusID
			if bonusID ~= 3524 and bonusID or 0 > 0 then
				root.up = nil
			end
		end
		-- app.PrintDebug("Root",root.key,root[root.key],root.modItemID,root.up,root._up);
		-- app.PrintTable(root)
		-- app.PrintDebug("Root Collect",root.collectible,root.collected,root.collectibleAsCost,root.hasUpgrade);
		-- app.PrintDebug("params",paramA,paramB);
		-- app.PrintDebug(#nested,"Nested total");
		if #nested > 0 then
			-- Nest the objects by matching filter priority if it's not a currency
			if paramA ~= "currencyID" then
				PriorityNestObjects(root, nested, nil, RecursiveCharacterRequirementsFilter, RecursiveGroupRequirementsFilter)
			else
				-- do roughly the same logic for currency, but will not add the skipped objects afterwards
				local added = {};
				for i,o in ipairs(nested) do
					-- If the obj meets the recursive group filter
					if RecursiveCharacterRequirementsFilter(o) then
						-- Merge the obj into the merged results
						-- app.PrintDebug("Merge object",o.key,o[o.key])
						added[#added + 1] = o
					end
				end
				-- Nest the added objects
				NestObjects(root, added)
			end
		end

		-- if not root.key then
		-- 	app.PrintDebug("UNKNOWN ROOT GROUP",paramA,paramB)
		-- 	app.PrintTable(root)
		-- end

		-- Single group which matches the root, then collapse it
		-- This could only happen if a Thing is literally listed underneath itself...
		if root.g and #root.g == 1 then
			local o = root.g[1];
			-- if not o.key then
			-- 	app.PrintDebug("UNKNOWN OBJECT GROUP",paramA,paramB)
			-- 	app.PrintTable(o)
			-- end
			if o.key then
				local okey, rootkey = o.key, root.key
				-- print("Check Single",root.key,root.key and root[root.key],o.key and root[o.key],o.key,o.key and o[o.key],root.key and o[root.key])
				-- Heroic Tusks of Mannoroth triggers this logic
				if (root[okey] == o[okey]) or (root[rootkey] == o[rootkey]) then
					-- print("Single group")
					root.g = nil;
					MergeProperties(root, o, true);
				end
			end
		end

		-- Replace as the group
		group = root;
		-- Ensure some specific relative values are captured in the base group
		-- can make this a loop if there ends up being more needed...
		group.difficultyID = GetRelativeValue(group, "difficultyID");
		-- Ensure no weird parent references attached to the base search result if there were multiple search results
		group.parent = nil;
		if clearSourceParent then
			group.sourceParent = nil;
		end

		-- app.PrintDebug(group.g and #group.g,"Merge total");
		-- app.PrintDebug("Final Group",group.key,group[group.key],group.collectible,group.collected,app:SearchLink(group.sourceParent));
		-- app.PrintDebug("Group Type",group.__type)

		-- Special cases
		-- Don't show nested criteria of achievements (unless loading popout/row content)
		if group.g and group.key == "achievementID" and app.GetSkipLevel() < 2 then
			local noCrits = {};
			-- print("achieve group",#group.g)
			for i=1,#group.g do
				if group.g[i].key ~= "criteriaID" then
					tinsert(noCrits, group.g[i]);
				end
			end
			group.g = noCrits;
			-- print("achieve nocrits",#group.g)
		end

		-- Fill the search result but not if the search itself was skipped (Mark of Honor) or indicated to skip
		if not options or not options.SkipFill then
			-- Fill up the group
			app.FillGroups(group)
		end

		-- Only need to build groups from the top level
		AssignChildren(group);
	-- delete sub-groups if there are none
	elseif #group.g == 0 then
		group.g = nil;
	end

	app.TopLevelUpdateGroup(group);

	group.isBaseSearchResult = true;

	return group
end
app.GetCachedSearchResults = function(method, paramA, paramB, options)
	if options and options.IgnoreCache then
		return GetSearchResults(method, paramA, paramB, options)
	end
	return app.GetCachedData(paramB and paramA..":"..paramB or paramA, GetSearchResults, method, paramA, paramB, options);
end

local IsComplete = app.IsComplete
local function CalculateGroupsCostAmount(g, costID, includedHashes)
	local o, subg, subcost, c
	local cost = 0
	for i=1,#g do
		o = g[i]
		subcost = o.visible and not IsComplete(o) and o.cost or nil
		if not includedHashes[o.hash] and subcost and type(subcost) == "table" then
			for j=1,#subcost do
				c = subcost[j]
				if c[2] == costID then
					includedHashes[o.hash] = true
					cost = cost + c[3];
					break
				end
			end
		end
		subg = o.g
		if subg then
			cost = cost + CalculateGroupsCostAmount(subg, costID, includedHashes)
		end
	end
	return cost
end
-- Returns the total amount of 'costID' for all non-collected Things within the group (not including the group itself)
app.CalculateTotalCosts = function(group, costID)
	-- app.PrintDebug("CalculateTotalCosts",group.hash,costID)
	local g = group and group.g
	local cost = g and CalculateGroupsCostAmount(g, costID, {}) or 0
	-- app.PrintDebug("CalculateTotalCosts",group.hash,costID,"=>",cost)
	return cost
end
end	-- Search results Lib

(function()
-- Keys for groups which are in-game 'Things'
app.ThingKeys = {
	-- filterID = true,
	flightpathID = true,
	-- professionID = true,
	-- categoryID = true,
	-- mapID = true,
	npcID = true,
	creatureID = true,
	currencyID = true,
	itemID = true,
	toyID = true,
	sourceID = true,
	speciesID = true,
	recipeID = true,
	runeforgepowerID = true,
	spellID = true,
	missionID = true,
	mountID = true,
	mountmodID = true,
	illusionID = true,
	questID = true,
	objectID = true,
	encounterID = true,
	artifactID = true,
	azeriteessenceID = true,
	followerID = true,
	factionID = true,
	explorationID = true,
	titleID = true,
	campsiteID = true,
	achievementID = true,	-- special handling
	criteriaID = true,	-- special handling
};
local SpecificSources = {
	headerID = {
		[app.HeaderConstants.COMMON_BOSS_DROPS] = true,
		[app.HeaderConstants.COMMON_VENDOR_ITEMS] = true,
		[app.HeaderConstants.DROPS] = true,
	},
}
local KeepSourced = {
	criteriaID = true
}
local SourceSearcher = app.SourceSearcher
local function GetThingSources(field, value)
	if field == "achievementID" then
		return SearchForField(field, value)
	end
	if field == "itemID" then
		-- allow extra return val (indicates directSources)
		return SourceSearcher.itemID(field, value)
	end
	-- ignore extra return vals
	local results = app.SearchForLink(field..":"..value)
	return results
end

-- Builds a 'Source' group from the parent of the group (or other listings of this group) and lists it under the group itself for
local function BuildSourceParent(group)
	-- only show sources for Things or specific of other types
	if not group or not group.key then return; end
	local groupKey, thingKeys = group.key, app.ThingKeys;
	local thingCheck = thingKeys[groupKey];
	local specificSource = SpecificSources[groupKey]
	if specificSource then
		 specificSource = specificSource[group[groupKey]];
	end
	-- group with some Source-able data can be treated as specific Source
	if not specificSource and (
		group.npcID or group.creatureID or group.crs or group.providers
	) then
		specificSource = true;
	end
	if not thingCheck and not specificSource then return; end

	-- pull all listings of this 'Thing'
	local keyValue = group[groupKey];
	local isDirectSources
	local things = specificSource and { group }
	if not things then
		things, isDirectSources = GetThingSources(groupKey, keyValue)
	end
	-- app.PrintDebug("BuildSourceParent",group.hash,thingCheck,specificSource,keyValue,#things,isDirectSources)
	-- if app.Debugging then
	-- 	local sourceGroup = {
	-- 		["text"] = "DEBUG THINGS",
	-- 		["OnUpdate"] = app.AlwaysShowUpdate,
	-- 		["skipFill"] = true,
	-- 		["g"] = {},
	-- 	};
	-- 	NestObjects(sourceGroup, things, true)
	-- 	NestObject(group, sourceGroup, nil, 1)
	-- end
	if things then
		local groupHash = group.hash;
		local parents = {};
		local isAchievement = groupKey == "achievementID";
		local parentKey, parent;
		-- collect all possible parent groups for all instances of this Thing
		for _,thing in ipairs(things) do
			if isDirectSources then
				parents[#parents + 1] = CreateObject(thing)
			elseif isAchievement or GroupMatchesParams(thing, groupKey, keyValue) then
				---@class ATTTempParentObject
				---@field key string
				---@field hash string
				---@field npcID number
				---@field creatureID number
				---@field _keepSource boolean
				---@field parent ATTTempParentObject
				parent = thing.parent;
				while parent do
					-- app.PrintDebug("parent",parent.text,parent.key)
					parentKey = parent.key;
					if parentKey and parent[parentKey] and parent.hash ~= groupHash then
						-- only show certain types of parents as sources.. typically 'Game World Things'
						-- or if the parent is directly tied to an NPC
						if thingKeys[parentKey] or parent.npcID or parent.creatureID then
							-- add the parent for display later
							parent = CreateObject(parent, true)
							parents[#parents + 1] = parent
							-- achievement criteria can nest inside their Source for clarity
							if isAchievement and KeepSourced[thing.key] then
								NestObject(parent, thing, true)
							end
							break;
						end
						-- TODO: maybe handle mapID/instanceID in a different way as a fallback for things nested under headers within a zone....?
					end
					-- move to the next parent if the current parent is not a valid 'Thing'
					parent = parent.parent;
				end
				-- Things tagged with an npcID should show that NPC as a Source
				if thing.key ~= "npcID" and (thing.npcID or thing.creatureID) then
					local parentNPC = CreateObject(SearchForObject("creatureID", thing.npcID or thing.creatureID, "field") or {["npcID"] = thing.npcID or thing.creatureID}, true)
					parents[#parents + 1] = parentNPC
					-- achievement criteria can nest inside their Source for clarity
					if isAchievement and KeepSourced[thing.key] then
						NestObject(parentNPC, thing, true)
					end
				end
				-- Things tagged with many npcIDs should show all those NPCs as a Source
				if thing.crs then
					-- app.PrintDebug("thing.crs",#thing.crs)
					local parentNPC;
					for _,npcID in ipairs(thing.crs) do
						parentNPC = CreateObject(SearchForObject("creatureID", npcID, "field") or {["npcID"] = npcID}, true)
						parents[#parents + 1] = parentNPC
						-- achievement criteria can nest inside their Source for clarity
						if isAchievement and KeepSourced[thing.key] then
							NestObject(parentNPC, thing, true)
						end
					end
				end
				-- Things tagged with providers should show the providers as a Source
				if thing.providers then
					local type, id;
					for _,p in ipairs(thing.providers) do
						type, id = p[1], p[2];
						-- app.PrintDebug("Root Provider",type,id);
						---@type any
						local pRef = (type == "i" and SearchForObject("itemID", id, "field"))
								or   (type == "o" and SearchForObject("objectID", id, "field"))
								or   (type == "n" and SearchForObject("npcID", id, "field"))
								or   (type == "s" and SearchForObject("spellID", id, "field"));
						if pRef then
							pRef = CreateObject(pRef, true);
							parents[#parents + 1] = pRef
						else
							pRef = (type == "i" and app.CreateItem(id))
								or   (type == "o" and app.CreateObject(id))
								or   (type == "n" and app.CreateNPC(id))
								or   (type == "s" and app.CreateSpell(id));
							parents[#parents + 1] = pRef
						end
						-- achievement criteria can nest inside their Source for clarity
						if isAchievement and thing.key == "criteriaID" then
							NestObject(pRef, thing, true)
						end
					end
				end
				-- Things tagged with qgs should show the quest givers as a Source
				if thing.qgs then
					for _,id in ipairs(thing.qgs) do
						-- app.PrintDebug("Root Provider",type,id);
						local pRef = SearchForObject("npcID", id, "field");
						if pRef then
							pRef = CreateObject(pRef, true);
							parents[#parents + 1] = pRef
						else
							pRef = app.CreateNPC(id);
							parents[#parents + 1] = pRef
						end
					end
				end
				-- Things tagged with 'sourceQuests' should show the quests as a Source (if the Thing itself is not a raw Quest)
				-- if thing.sourceQuests and groupKey ~= "questID" then
				-- 	local questRef;
				-- 	for _,sq in ipairs(thing.sourceQuests) do
				-- 		questRef = SearchForObject("questID", sq) or {["questID"] = sq};
				-- 		tinsert(parents, questRef);
				-- 	end
				-- end
			end
		end
		-- Raw Criteria include their containing Achievement as the Source
		-- re-popping this Achievement will do normal Sources for all the Criteria and be useful
		if groupKey == "criteriaID" then
			local achID = group.achievementID;
			parent = CreateObject(SearchForObject("achievementID", achID, "key") or { achievementID = achID }, true)
			-- app.PrintDebug("add achievement for empty criteria",achID)
			parents[#parents + 1] = parent
		end

		if #parents == 0 then return end

		-- if there are valid parent groups for sources, merge them into a 'Source(s)' group
		-- app.PrintDebug("Found parents",#parents)
		local sourceGroup = app.CreateRawText(L.SOURCES, {
			description = L.SOURCES_DESC,
			icon = 134441,
			OnUpdate = app.AlwaysShowUpdate,
			sourceIgnored = true,
			skipFull = true,
			SortPriority = -3.0,
			g = {},
			OnClick = app.UI.OnClick.IgnoreRightClick,
		})
		for _,parent in ipairs(parents) do
			-- if there's nothing nested under the parent, then force it to be visible
			-- otherwise the visibility can be driven by the nested thing
			parent.OnSetVisibility = not parent.g and app.AlwaysShowUpdate or nil	-- TODO: filter actual unobtainable sources...
		end
		PriorityNestObjects(sourceGroup, parents, nil, app.RecursiveCharacterRequirementsFilter, app.RecursiveGroupRequirementsFilter);
		NestObject(group, sourceGroup, nil, 1);
	end
end
app.AddEventHandler("OnNewPopoutGroup", BuildSourceParent)
end)();




-- Synchronization Functions
(function()
local C_CreatureInfo_GetRaceInfo = C_CreatureInfo.GetRaceInfo;
local outgoing,incoming,queue,active = {},{},{},nil;
local whiteListedFields = { --[["Achievements",]] "Artifacts", "AzeriteEssenceRanks", "BattlePets", "Exploration", "Factions", "FlightPaths", "Followers", "GarrisonBuildings", "Quests", "Spells", "Titles" };
app.CharacterSyncTables = whiteListedFields;
local function splittoarray(sep, inputstr)
	local t = {};
	for str in inputstr:gmatch("([^" .. (sep or "%s") .. "]+)") do
		tinsert(t, str);
	end
	return t;
end
local function processQueue()
	if #queue > 0 and not active then
		local data = queue[1];
		tremove(queue, 1);
		active = data[1];
		app.print("Updating " .. data[2] .. " from " .. data[3] .. "...");
		C_ChatInfo.SendAddonMessage("ATT", "!\tsyncsum\t" .. data[1], "WHISPER", data[3]);
	end
end

function app:AcknowledgeIncomingChunks(sender, uid, total)
	local incomingFromSender = incoming[sender];
	if not incomingFromSender then
		incomingFromSender = {};
		incoming[sender] = incomingFromSender;
	end
	incomingFromSender[uid] = { ["chunks"] = {}, ["total"] = total };
	C_ChatInfo.SendAddonMessage("ATT", "chksack\t" .. uid, "WHISPER", sender);
end
local function ProcessIncomingChunk(sender, uid, index, chunk)
	if not (chunk and index and uid and sender) then return false; end
	local incomingFromSender = incoming[sender];
	if not incomingFromSender then return false; end
	local incomingForUID = incomingFromSender[uid];
	if not incomingForUID then return false; end
	incomingForUID.chunks[index] = chunk;
	if index < incomingForUID.total then
		if index % 25 == 0 then app.print("Syncing " .. index .. " / " .. incomingForUID.total); end
		return true;
	end

	incomingFromSender[uid] = nil;

	local msg = "";
	for i=1,incomingForUID.total,1 do
		msg = msg .. incomingForUID.chunks[i];
	end
	-- app:ShowPopupDialogWithMultiLineEditBox(msg);
	local characters = splittoarray("\t", msg);
	for _,characterString in ipairs(characters) do
		local data = splittoarray(":", characterString);
		local guid = data[1];
		local character = ATTCharacterData[guid];
		if not character then
			character = {};
			character.guid = guid;
			ATTCharacterData[guid] = character;
		end
		character.name = data[2];
		character.lvl = tonumber(data[3]);
		character.text = data[4];
		if data[5] ~= "" and data[5] ~= " " then character.realm = data[5]; end
		if data[6] ~= "" and data[6] ~= " " then character.factionID = tonumber(data[6]); end
		if data[7] ~= "" and data[7] ~= " " then character.classID = tonumber(data[7]); end
		if data[8] ~= "" and data[8] ~= " " then character.raceID = tonumber(data[8]); end
		character.lastPlayed = tonumber(data[9]);
		character.Deaths = tonumber(data[10]);
		if character.classID then character.class = app.ClassInfoByID[character.classID].file; end
		if character.raceID then character.race = C_CreatureInfo_GetRaceInfo(character.raceID).clientFileString; end
		for i=11,#data,1 do
			local piece = splittoarray("/", data[i]);
			local key = piece[1];
			local field = {};
			character[key] = field;
			for j=2,#piece,1 do
				local index = tonumber(piece[j]);
				if index then field[index] = 1; end
			end
		end
		app.print("Update complete for " .. character.text .. ".");
	end

	app:RecalculateAccountWideData();
	app.Settings:Refresh();
	active = nil;
	processQueue();
	return false;
end
function app:AcknowledgeIncomingChunk(sender, uid, index, chunk)
	if chunk and ProcessIncomingChunk(sender, uid, index, chunk) then
		C_ChatInfo.SendAddonMessage("ATT", "chkack\t" .. uid .. "\t" .. index .. "\t1", "WHISPER", sender);
	else
		C_ChatInfo.SendAddonMessage("ATT", "chkack\t" .. uid .. "\t" .. index .. "\t0", "WHISPER", sender);
	end
end
function app:SendChunk(sender, uid, index, success)
	local outgoingForSender = outgoing[sender];
	if outgoingForSender then
		local chunksForUID = outgoingForSender.uids[uid];
		if chunksForUID and success == 1 then
			local chunk = chunksForUID[index];
			if chunk then
				C_ChatInfo.SendAddonMessage("ATT", "chk\t" .. uid .. "\t" .. index .. "\t" .. chunk, "WHISPER", sender);
			end
		else
			outgoingForSender.uids[uid] = nil;
		end
	end
end

function app:IsAccountLinked(sender)
	return AllTheThingsAD.LinkedAccounts[sender] or AllTheThingsAD.LinkedAccounts[("-"):split(sender)];
end
local function DefaultSyncCharacterData(allCharacters, key)
	local characterData
	local data = ATTAccountWideData[key];
	wipe(data);
	for guid,character in pairs(allCharacters) do
		characterData = character[key];
		if characterData then
			for index,_ in pairs(characterData) do
				data[index] = 1;
			end
		end
	end
end
-- Used for data which is defaulted as Account-learned, but has Character-learned exceptions
local function PartialSyncCharacterData(allCharacters, key)
	local characterData
	local data = ATTAccountWideData[key];
	-- wipe account data saved based on character data
	for id,completion in pairs(data) do
		if completion == 2 then
			data[id] = nil
		end
	end
	for guid,character in pairs(allCharacters) do
		characterData = character[key];
		if characterData then
			for id,_ in pairs(characterData) do
				-- character-based completion in account data saved as 2 for these types
				data[id] = 2
			end
		end
	end
end
local function RankSyncCharacterData(allCharacters, key)
	local characterData
	local data = ATTAccountWideData[key];
	wipe(data);
	local oldRank;
	for guid,character in pairs(allCharacters) do
		characterData = character[key];
		if characterData then
			for index,rank in pairs(characterData) do
				oldRank = data[index];
				if not oldRank or oldRank < rank then
					data[index] = rank;
				end
			end
		end
	end
end
local function SyncCharacterQuestData(allCharacters, key)
	local characterData
	local data = ATTAccountWideData[key];
	-- don't completely wipe quest data, some questID are marked as 'complete' due to other restrictions on the account
	-- so we want to maintain those even though no character actually has it completed
	-- TODO: perhaps in the future we can instead treat these quests as 'uncollectible' for the account rather than 'complete'
	-- TODO: once these quests are no longer assigned as completion == 2 we can then use the PartialSyncCharacterData for Quests
	-- and make sure AccountWide quests are instead saved directly into ATTAccountWideData when completed
	-- and cleaned from individual Character caches here during sync
	for questID,completion in pairs(data) do
		if completion ~= 2 then
			data[questID] = nil
		-- else app.PrintDebug("not-reset",questID,completion)
		end
	end
	for guid,character in pairs(allCharacters) do
		characterData = character[key];
		if characterData then
			for index,_ in pairs(characterData) do
				data[index] = 1;
			end
		end
	end
end
-- TODO: individual Classes should be able to add the proper functionality here to determine the account-wide
-- collection states of a 'Thing', if the refresh can't account for it
-- i.e. Mounts... 99% account-wide by default, like 5 per character. don't want to save 900+ id's for
-- each character just to sync into account data properly
local SyncFunctions = setmetatable({
	AzeriteEssenceRanks = RankSyncCharacterData,
	Quests = SyncCharacterQuestData,
	Mounts = PartialSyncCharacterData,
	BattlePets = PartialSyncCharacterData,
}, { __index = function(t, key)
	if contains(whiteListedFields, key) then
		return DefaultSyncCharacterData
	end
end })

function app:RecalculateAccountWideData()
	local allCharacters = ATTCharacterData;
	local syncFunc;
	for key,data in pairs(ATTAccountWideData) do
		syncFunc = SyncFunctions[key];
		if syncFunc then
			-- app.PrintDebug("Sync:",key)
			syncFunc(allCharacters, key);
		end
	end
	local deaths = 0;
	for guid,character in pairs(allCharacters) do
		if character.Deaths then
			deaths = deaths + character.Deaths;
		end
	end
	ATTAccountWideData.Deaths = deaths;
end
app.AddEventHandler("OnRecalculateDone", app.RecalculateAccountWideData)
function app:ReceiveSyncRequest(sender, battleTag)
	if battleTag ~= select(2, BNGetInfo()) then
		-- Check to see if the character/account is linked.
		if not (app:IsAccountLinked(sender) or AllTheThingsAD.LinkedAccounts[battleTag]) then
			return false;
		end
	end

	-- Whitelist the character name, if not already. (This is needed for future sync methods)
	AllTheThingsAD.LinkedAccounts[sender] = true;

	-- Generate the sync string (there may be several depending on how many alts there are)
	-- TODO: use app.TableConcat()
	-- local msgs = {};
	local msg = "?\tsyncsum";
	for guid,character in pairs(ATTCharacterData) do
		if character.lastPlayed then
			local charsummary = "\t" .. guid .. ":" .. character.lastPlayed;
			if (msg:len() + charsummary:len()) < 255 then
				msg = msg .. charsummary;
			else
				C_ChatInfo.SendAddonMessage("ATT", msg, "WHISPER", sender);
				msg = "?\tsyncsum" .. charsummary;
			end
		end
	end
	C_ChatInfo.SendAddonMessage("ATT", msg, "WHISPER", sender);
end
function app:ReceiveSyncSummary(sender, summary)
	if app:IsAccountLinked(sender) then
		local first = #queue == 0;
		for i,data in ipairs(summary) do
			local guid,lastPlayed = (":"):split(data);
			local character = ATTCharacterData[guid];
			if not character or not character.lastPlayed or (character.lastPlayed < tonumber(lastPlayed)) and guid ~= active then
				tinsert(queue, { guid, character and character.text or guid, sender });
			end
		end
		if first then processQueue(); end
	end
end
function app:ReceiveSyncSummaryResponse(sender, summary)
	if app:IsAccountLinked(sender) then
		local rawMsg;
		for i,guid in ipairs(summary) do
			local character = ATTCharacterData[guid];
			if character then
				-- Put easy character data into a raw data string
				local rawData = character.guid .. ":" .. character.name .. ":" .. character.lvl .. ":" .. character.text .. ":" .. (character.realm or " ") .. ":" .. (character.factionID or " ") .. ":" .. (character.classID or " ") .. ":" .. (character.raceID or " ") .. ":" .. character.lastPlayed .. ":" .. character.Deaths;

				for i,field in ipairs(whiteListedFields) do
					if character[field] then
						rawData = rawData .. ":" .. field;
						for index,value in pairs(character[field]) do
							if value then
								rawData = rawData .. "/" .. index;
							end
						end
					end
				end

				if not rawMsg then
					rawMsg = rawData;
				else
					rawMsg = rawMsg .. "\t" .. rawData;
				end
			end
		end

		if rawMsg then
			-- Send Addon Message Back
			local length = rawMsg:len();
			local chunks = {};
			for i=1,length,241 do
				tinsert(chunks, rawMsg:sub(i, math.min(length, i + 240)));
			end
			local outgoingForSender = outgoing[sender];
			if not outgoingForSender then
				outgoingForSender = { ["total"] = 0, ["uids"] = {}};
				outgoing[sender] = outgoingForSender;
			end
			local uid = outgoingForSender.total + 1;
			outgoingForSender.uids[uid] = chunks;
			outgoingForSender.total = uid;

			-- Send Addon Message Back
			C_ChatInfo.SendAddonMessage("ATT", "chks\t" .. uid .. "\t" .. #chunks, "WHISPER", sender);
		end
	end
end
function app:Synchronize(automatically)
	-- Update the last played timestamp. This ensures the sync process does NOT destroy unsaved progress on this character.
	local battleTag = select(2, BNGetInfo());
	if battleTag then
		app.CurrentCharacter.lastPlayed = time();
		local any, msg = false, "?\tsync\t" .. battleTag;
		for playerName,allowed in pairs(AllTheThingsAD.LinkedAccounts) do
			if allowed and not playerName:find("#") then
				C_ChatInfo.SendAddonMessage("ATT", msg, "WHISPER", playerName);
				any = true;
			end
		end
		if not any and not automatically then
			app.print("You need to link a character or BNET account in the settings first before you can Sync accounts.");
		end
	end
end
function app:SynchronizeWithPlayer(playerName)
	-- Update the last played timestamp. This ensures the sync process does NOT destroy unsaved progress on this character.
	local battleTag = select(2, BNGetInfo());
	if battleTag then
		app.CurrentCharacter.lastPlayed = time();
		C_ChatInfo.SendAddonMessage("ATT", "?\tsync\t" .. battleTag, "WHISPER", playerName);
	end
end
app.AddEventHandler("OnReady", function()
	-- Attempt to register for the addon message prefix.
	-- NOTE: This is only used by this old sync module and will be removed at some point.
	C_ChatInfo.RegisterAddonMessagePrefix("ATT");
	if app.Settings:GetTooltipSetting("Auto:Sync") then
		app:Synchronize(true)
	end
end);
end)();

do	-- Main Data
-- Returns {name,icon} for a known HeaderConstants NPCID
local function SimpleNPCGroup(npcID, t)
	if t then
		t.name = app.NPCNameFromID[npcID]
		t.icon = L.HEADER_ICONS[npcID]
		if t.suffix then
			t.name = t.name .. " (".. t.suffix ..")"
			t.suffix = nil
		end
	else
		t = {
				name = app.NPCNameFromID[npcID],
				icon = L.HEADER_ICONS[npcID]
			}
	end
	return t
end

function app:GetDataCache()
	if not app.Categories then
		return nil;
	end

	-- app.PrintDebug("Start loading data cache")
	-- app.PrintMemoryUsage()

	-- Update the Row Data by filtering raw data (this function only runs once)
	local rootData = setmetatable({
		text = L.TITLE,
		icon = app.asset("logo_32x32"),
		preview = app.asset("Discord_2_128"),
		description = L.DESCRIPTION,
		font = "GameFontNormalLarge",
		expanded = true,
		visible = true,
		progress = 0,
		total = 0,
		g = {},
	}, {
		-- TODO: yuck all of this... should assign the available functionality during startup events
		-- and use proper methods
		__index = function(t, key)
			-- app.PrintDebug("Top-Root-Get",rawget(t,"TLUG"),key)
			if key == "title" then
				return t.modeString .. DESCRIPTION_SEPARATOR .. t.untilNextPercentage;
			elseif key == "progressText" then
				if not rawget(t,"TLUG") and app.CurrentCharacter then
					local primeData = app.CurrentCharacter.PrimeData;
					if primeData then
						return GetProgressColorText(primeData.progress, primeData.total);
					end
				end
				return GetProgressColorText(t.progress, t.total);
			elseif key == "modeString" then
				return app.Settings:GetModeString();
			elseif key == "untilNextPercentage" then
				if not rawget(t,"TLUG") and app.CurrentCharacter then
					local primeData = app.CurrentCharacter.PrimeData;
					if primeData then
						return app.Modules.Color.GetProgressTextToNextPercent(primeData.progress, primeData.total);
					end
				end
				return app.Modules.Color.GetProgressTextToNextPercent(t.progress, t.total);
			elseif key == "visible" then
				return true;
			end
		end,
		__newindex = function(t, key, val)
			-- app.PrintDebug("Top-Root-Set",rawget(t,"TLUG"),key,val)
			if key == "visible" then
				return;
			end
			-- until the Main list receives a top-level update
			if not rawget(t,"TLUG") then
				-- ignore setting progress/total values
				if key == "progress" or key == "total" then
					return;
				end
			end
			rawset(t, key, val);
		end
	});
	local g, db = rootData.g, nil;

	-- Dungeons & Raids
	db = app.CreateRawText(GROUP_FINDER);
	db.g = app.Categories.Instances;
	db.icon = app.asset("Category_D&R");
	tinsert(g, db);

	-- Delves
	if app.Categories.Delves then
		tinsert(g, app.CreateNPC(app.HeaderConstants.DELVES, app.Categories.Delves));
	end

	-- Zones
	if app.Categories.Zones then
		db = app.CreateRawText(BUG_CATEGORY2);
		db.g = app.Categories.Zones;
		db.icon = app.asset("Category_Zones")
		tinsert(g, db);
	end

	-- World Drops
	if app.Categories.WorldDrops then
		db = app.CreateRawText(TRANSMOG_SOURCE_4);
		db.g = app.Categories.WorldDrops;
		db.isWorldDropCategory = true;
		db.icon = app.asset("Category_WorldDrops");
		tinsert(g, db);
	end

	-- Group Finder
	if app.Categories.GroupFinder then
		db = app.CreateRawText(DUNGEONS_BUTTON);
		db.g = app.Categories.GroupFinder;
		db.icon = app.asset("Category_GroupFinder")
		tinsert(g, db);
	end

	-- Achievements
	if app.Categories.Achievements then
		db = app.CreateNPC(app.HeaderConstants.ACHIEVEMENTS, app.Categories.Achievements);
		db.sourceIgnored = 1;	-- everything in this category is now cloned!
		for _, o in ipairs(db.g) do
			o.sourceIgnored = nil
		end
		tinsert(g, db);
	end

	-- Expansion Features
	if app.Categories.ExpansionFeatures then
		local text = GetCategoryInfo(15301)
		db = app.CreateRawText(text);
		db.g = app.Categories.ExpansionFeatures;
		db.lvl = 10;
		db.description = "These expansion features are new systems or ideas by Blizzard which are spread over multiple zones. For the ease of access & for the sake of reducing numbers, these are tagged as expansion features.\nIf an expansion feature is limited to 1 zone, it will continue being listed only under its respective zone.";
		db.icon = app.asset("Category_ExpansionFeatures");
		tinsert(g, db);
	end

	-- Holidays
	if app.Categories.Holidays then
		db = app.CreateNPC(app.HeaderConstants.HOLIDAYS, app.Categories.Holidays);
		db.isHolidayCategory = true;
		db.SortType = "EventStart";
		tinsert(g, db);
	end

	-- Events
	if app.Categories.WorldEvents then
		db = app.CreateRawText(BATTLE_PET_SOURCE_7);
		db.description = "These events occur at different times in the game's timeline, typically as one time server wide events. Special celebrations such as Anniversary events and such may be found within this category.";
		db.icon = app.asset("Category_Event");
		db.g = app.Categories.WorldEvents;
		tinsert(g, db);
	end

	-- Promotions
	if app.Categories.Promotions then
		db = app.CreateRawText(BATTLE_PET_SOURCE_8);
		db.description = "This section is for real world promotions that seeped extremely rare content into the game prior to some of them appearing within the In-Game Shop.";
		db.icon = app.asset("Category_Promo");
		db.g = app.Categories.Promotions;
		db.isPromotionCategory = true;
		tinsert(g, db);
	end

	-- Pet Battles
	if app.Categories.PetBattles then
		db = app.CreateNPC(app.HeaderConstants.PET_BATTLES);
		db.g = app.Categories.PetBattles;
		tinsert(g, db);
	end

	-- PvP
	if app.Categories.PVP then
		db = app.CreateNPC(app.HeaderConstants.PVP, app.Categories.PVP);
		db.isPVPCategory = true;
		tinsert(g, db);
	end

	-- Craftables
	if app.Categories.Craftables then
		db = app.CreateRawText(LOOT_JOURNAL_LEGENDARIES_SOURCE_CRAFTED_ITEM);
		db.g = app.Categories.Craftables;
		db.DontEnforceSkillRequirements = true;
		db.icon = app.asset("Category_Crafting");
		tinsert(g, db);
	end

	-- Professions
	if app.Categories.Professions then
		db = app.CreateNPC(app.HeaderConstants.PROFESSIONS, app.Categories.Professions);
		tinsert(g, db);
	end

	-- Secrets
	if app.Categories.Secrets then
		db = app.CreateNPC(app.HeaderConstants.SECRETS, app.Categories.Secrets);
		tinsert(g, db);
	end

	-- Character
	if app.Categories.Character then
		db = app.CreateRawText(CHARACTER);
		db.g = app.Categories.Character;
		db.icon = app.asset("Category_ItemSets");
		tinsert(g, db);
	end

	-- In-Game Store
	if app.Categories.InGameShop then
		db = app.CreateNPC(app.HeaderConstants.IN_GAME_SHOP, app.Categories.InGameShop);
		tinsert(g, db);
	end

	-- Trading Post
	if app.Categories.TradingPost then
		db = app.CreateRawText(L.TRADING_POST);	-- Probably some global string Later
		db.g = app.Categories.TradingPost;
		db.icon = app.asset("Category_TradingPost");
		tinsert(g, db);
	end

	-- Black Market
	if app.Categories.BlackMarket then
		db = app.CreateNPC(app.HeaderConstants.BLACK_MARKET_AUCTION_HOUSE, app.Categories.BlackMarket);
		db.icon = app.asset("Category_Blackmarket");
		tinsert(g, db);
	end

	-- Track Deaths!
	tinsert(g, app:CreateDeathClass());

	-- Yourself.
	tinsert(g, app.CreateUnit("player", {
		["description"] = L.DEBUG_LOGIN,
		["races"] = { app.RaceIndex },
		["c"] = { app.ClassIndex },
		["r"] = app.FactionID,
		["collected"] = 1,
		["nmr"] = false,
		["OnUpdate"] = function(self)
			self.lvl = app.Level;
			if app.MODE_DEBUG then
				self.collectible = true;
			else
				self.collectible = false;
			end
		end
	}));

	-- Module-based Groups
	app.HandleEvent("OnAddExtraMainCategories", g)

	-- Create Dynamic Groups Button
	tinsert(g, app.CreateRawText(L.CLICK_TO_CREATE_FORMAT:format(L.SETTINGS_MENU.DYNAMIC_CATEGORY_LABEL), {
		icon = app.asset("Interface_CreateDynamic"),
		OnUpdate = app.AlwaysShowUpdate,
		sourceIgnored = true,
		-- ["OnClick"] = function(row, button)
			-- could implement logic to auto-populate all dynamic groups like before... will see if people complain about individual generation
		-- end,
		-- Top-Level Dynamic Categories
		g = {
			-- Future Unobtainable
			app.CreateDynamicHeader("rwp", {
				dynamic_withsubgroups = true,
				dynamic_value = app.GameBuildVersion,
				dynamic_searchcriteria = {
					SearchValueCriteria = {
						-- only include 'rwp' search results where the value is >= the current game version
						function(o,field,value)
							local rwp = o[field]
							if not rwp then return end
							return rwp >= value
						end
					}
				},
				name = L.FUTURE_UNOBTAINABLE,
				description = L.FUTURE_UNOBTAINABLE_TOOLTIP,
				icon = app.asset("Interface_Future_Unobtainable")
			}),

			-- Recently Added
			app.CreateDynamicHeader("awp", {
				dynamic_value = app.GameBuildVersion,
				dynamic_withsubgroups = true,
				name = L.NEW_WITH_PATCH,
				description = L.NEW_WITH_PATCH_TOOLTIP,
				icon = app.asset("Interface_Newly_Added")
			}),

			-- Artifacts
			app.CreateDynamicHeader("artifactID", SimpleNPCGroup(app.HeaderConstants.ARTIFACTS)),

			-- Azerite Essences
			app.CreateDynamicHeader("azeriteessenceID", SimpleNPCGroup(app.HeaderConstants.AZERITE_ESSENCES)),

			-- Battle Pets
			app.CreateDynamicHeader("speciesID", {
				name = AUCTION_CATEGORY_BATTLE_PETS,
				icon = app.asset("Category_PetJournal")
			}),

			-- Campsites
			app.CreateDynamicHeader("campsiteID", {
				name = WARBAND_SCENES,
				icon = app.asset("Category_Campsites")
			}),

			-- Character Unlocks
			app.CreateDynamicHeader("characterUnlock", {
				name = CHARACTER.." "..UNLOCK.."s",
				icon = app.asset("Category_ItemSets")
			}),

			-- Conduits
			app.CreateDynamicHeader("conduitID", SimpleNPCGroup(app.HeaderConstants.CONDUITS, {suffix=EXPANSION_NAME8})),

			-- Currencies
			app.CreateDynamicHeaderByValue("currencyID", {
				dynamic_withsubgroups = true,
				name = CURRENCY,
				icon = app.asset("Interface_Vendor")
			}),

			-- Factions
			app.CreateDynamicHeaderByValue("factionID", {
				dynamic_withsubgroups = true,
				name = L.FACTIONS,
				icon = app.asset("Category_Factions")
			}),

			-- Flight Paths
			app.CreateDynamicHeader("flightpathID", {
				name = L.FLIGHT_PATHS,
				icon = app.asset("Category_FlightPaths")
			}),

			-- Followers
			app.CreateDynamicHeader("followerID", SimpleNPCGroup(app.HeaderConstants.FOLLOWERS)),

			-- Garrison Buildings
			-- TODO: doesn't seem to work...
			-- app.CreateDynamicHeader("garrisonbuildingID", SimpleNPCGroup(app.HeaderConstants.BUILDINGS)),

			-- Heirlooms
			app.CreateDynamicHeader("heirloomID", SimpleNPCGroup(app.HeaderConstants.HEIRLOOMS)),

			-- Illusions
			app.CreateDynamicHeader("illusionID", {
				name = L.FILTER_ID_TYPES[103],
				icon = app.asset("Category_Illusions")
			}),

			-- Mounts
			app.CreateDynamicHeader("mountID", {
				name = MOUNTS,
				icon = app.asset("Category_Mounts")
			}),

			-- Mount Mods
			app.CreateDynamicHeader("mountmodID", SimpleNPCGroup(app.HeaderConstants.MOUNT_MODS)),

			-- Pet Battles
			app.CreateDynamicHeader("pb", SimpleNPCGroup(app.HeaderConstants.PET_BATTLES, {dynamic_withsubgroups = true})),

			-- Professions
			app.CreateDynamicHeaderByValue("professionID", {
				dynamic_withsubgroups = true,
				dynamic_valueField = "requireSkill",
				name = TRADE_SKILLS,
				icon = app.asset("Category_Professions")
			}),

			-- Runeforge Powers
			app.CreateDynamicHeader("runeforgepowerID", SimpleNPCGroup(app.HeaderConstants.LEGENDARIES, {suffix=EXPANSION_NAME8})),

			-- Titles
			app.CreateDynamicHeader("titleID", {
				name = PAPERDOLL_SIDEBAR_TITLES,
				icon = app.asset("Category_Titles")
			}),

			-- Toys
			app.CreateDynamicHeader("toyID", {
				name = TOY_BOX,
				icon = app.asset("Category_ToyBox")
			}),

			-- Various Quest groups
			app.CreateNPC(app.HeaderConstants.QUESTS, {
				visible = true,
				OnUpdate = app.AlwaysShowUpdate,
				g = {
					-- Breadcrumbs
					app.CreateDynamicHeader("isBreadcrumb", {
						name = L.BREADCRUMBS,
						icon = 134051
					}),

					-- Dailies
					app.CreateDynamicHeader("isDaily", {
						name = DAILY,
						icon = app.asset("Interface_Questd")
					}),

					-- Weeklies
					app.CreateDynamicHeader("isWeekly", {
						name = CALENDAR_REPEAT_WEEKLY,
						icon = app.asset("Interface_Questw")
					}),

					-- HQTs
					app.CreateDynamicHeader("isHQT", {
						name = MINIMAP_TRACKING_HIDDEN_QUESTS,
						icon = app.asset("Interface_Quest"),
					}),

					-- All Quests
					-- this works but..... bad idea instead use /att list type=quest limit=79000
					-- app.CreateDynamicHeaderByValue("questID", {
					-- 	dynamic_withsubgroups = true,
					-- 	name = QUESTS_LABEL,
					-- 	icon = app.asset("Interface_Quest_header")
					-- }),
				}
			}),

		},
	}));

	-- The Main Window's Data
	app.refreshDataForce = true;
	-- app.PrintMemoryUsage("Prime.Data Ready")
	local primeWindow = app:GetWindow("Prime");
	primeWindow:SetData(rootData);
	-- app.PrintMemoryUsage("Prime Window Data Set")
	primeWindow:BuildData();
	-- app.PrintMemoryUsage()
	-- app.PrintDebug("Begin Cache Prime")
	CacheFields(rootData);
	-- app.PrintDebugPrior("Ended Cache Prime")
	-- app.PrintMemoryUsage()

	-- Function to build a hidden window's data
	local AllHiddenWindows = {}
	local function BuildHiddenWindowData(name, icon, description, category, flags)
		if not app.Categories[category] then return end

		local windowData = app.CreateRawText(Colorize(name, flags and flags.Color or app.Colors.ChatLinkError), app.Categories[category])
		windowData.title = name .. DESCRIPTION_SEPARATOR .. app.Version
		windowData.icon = app.asset(icon)
		windowData.description = description
		windowData.font = "GameFontNormalLarge"
		for k, v in pairs(flags or app.EmptyTable) do
			windowData[k] = v
		end

		CacheFields(windowData, true)
		AllHiddenWindows[#AllHiddenWindows + 1] = windowData

		-- Filter for Never Implemented things
		if category == "NeverImplemented" then
			app.AssignFieldValue(windowData, "u", 1)
		end

		local window = app:GetWindow(category)
		window.AdHoc = true
		window:SetData(windowData)
		window:BuildData()
	end

	-- Build all the hidden window's data
	BuildHiddenWindowData(L.UNSORTED, "WindowIcon_Unsorted", L.UNSORTED_DESC, "Unsorted", { _missing = true, _unsorted = true, _nosearch = true })
	BuildHiddenWindowData(L.NEVER_IMPLEMENTED, "status-unobtainable", L.NEVER_IMPLEMENTED_DESC, "NeverImplemented", { _nyi = true, _nosearch = true })
	BuildHiddenWindowData(L.HIDDEN_ACHIEVEMENT_TRIGGERS, "Category_Achievements", L.HIDDEN_ACHIEVEMENT_TRIGGERS_DESC, "HiddenAchievementTriggers", { _hqt = true, _nosearch = true, Color = app.Colors.ChatLinkHQT })
	BuildHiddenWindowData(L.HIDDEN_CURRENCY_TRIGGERS, "Interface_Vendor", L.HIDDEN_CURRENCY_TRIGGERS_DESC, "HiddenCurrencyTriggers", { _hqt = true, _nosearch = true, Color = app.Colors.ChatLinkHQT })
	BuildHiddenWindowData(L.HIDDEN_QUEST_TRIGGERS, "Interface_Quest", L.HIDDEN_QUEST_TRIGGERS_DESC, "HiddenQuestTriggers", { _hqt = true, _nosearch = true, Color = app.Colors.ChatLinkHQT })
	BuildHiddenWindowData(L.SOURCELESS, "WindowIcon_Unsorted", L.SOURCELESS_DESC, "Sourceless", { _missing = true, _unsorted = true, _nosearch = true, Color = app.Colors.TooltipWarning })

	-- a single Unsorted window to collect all base Unsorted windows
	-- TODO: migrate this logic once Window creation is revised
	app.ChatCommands.Add("all-hidden", function(args)
		local window = app:GetWindow("all-hidden")
		if window and not window.HasPendingUpdate then window:Toggle() return true end

		-- local allHiddenSearch = app:BuildTargettedSearchResponse(AllUnsortedGroups, "_nosearch", true, nil, {ParentInclusionCriteria={},SearchCriteria={},SearchValueCriteria={}})

		local windowData = app.CreateRawText(Colorize("All-Hidden", app.Colors.ChatLinkError), {
			-- clone all unhidden groups into this window
			g = CreateObject(AllHiddenWindows),
			title = "All-Hidden" .. DESCRIPTION_SEPARATOR .. app.Version,
			icon = app.asset("status-unobtainable"),
			description = "All Hidden ATT Content",
			font = "GameFontNormalLarge",
			AdHoc = true
		})
		window:SetData(windowData)
		window:BuildData()
		window:Toggle()
		return true
	end, {
		"Usage : /att all-hidden",
		"Provides a single command to open all Hidden content in a single window",
	})

	-- StartCoroutine("VerifyRecursionUnsorted", function() app.VerifyCache(); end, 5);
	-- app.PrintDebug("Finished loading data cache")
	-- app.PrintMemoryUsage()
	app.GetDataCache = function()
		-- app.PrintDebug("Cached data cache")
		return rootData;
	end
	return rootData;
end
app.AddEventHandler("OnLoad", app.GetDataCache)

end	-- Dynamic/Main Data

do -- Search Response Logic
end -- Search Response Logic

-- Store the Custom Windows Update functions which are required by specific Windows
(function()
local customWindowUpdates = { params = {} };
-- Returns the Custom Update function based on the Window suffix if existing
function app:CustomWindowUpdate(suffix)
	return customWindowUpdates[suffix];
end
-- Retrieves the value of the specific attribute for the given window suffix
app.GetCustomWindowParam = function(suffix, name)
	local params = customWindowUpdates.params[suffix];
	-- app.PrintDebug("GetCustomWindowParam",suffix,name,params and params[name])
	return params and params[name] or nil;
end
-- Defines the value of the specific attribute for the given window suffix
app.SetCustomWindowParam = function(suffix, name, value)
	local params = customWindowUpdates.params;
	if params[suffix] then params[suffix][name] = value;
	else params[suffix] = { [name] = value } end
	-- app.PrintDebug("SetCustomWindowParam",suffix,name,params[suffix][name])
end
-- Removes the custom attributes for a given window suffix
app.ResetCustomWindowParam = function(suffix)
	customWindowUpdates.params[suffix] = nil;
	-- app.PrintDebug("ResetCustomWindowParam",suffix)
end
-- Allows externally adding custom window update logic which doesn't exist already
app.AddCustomWindowOnUpdate = function(customName, onUpdate)
	if customWindowUpdates[customName] then
		app.print("Cannot replace Custom Window: "..customName)
	end
	app.print("Added",customName)
	customWindowUpdates[customName] = onUpdate
end
customWindowUpdates.AchievementHarvester = function(self, ...)
	-- /run AllTheThings:GetWindow("AchievementHarvester"):Toggle();
	if self:IsVisible() then
		if not self.initialized then
			self.doesOwnUpdate = true;
			self.initialized = true;
			self.Limit = 45000;	-- MissingAchievements:11.0.0.54774 (maximum achievementID)
			self.PartitionSize = 5000;
			local db = {};
			local CleanUpHarvests = function()
				local g, partition, pg, pgcount, refresh = self.data.g, nil, nil, nil, nil;
				local count = g and #g or 0;
				if count > 0 then
					for p=count,1,-1 do
						partition = g[p];
						if partition.g and partition.expanded then
							refresh = true;
							pg = partition.g;
							pgcount = #pg;
							-- print("UpdateDone.Partition",partition.text,pgcount)
							if pgcount > 0 then
								for i=pgcount,1,-1 do
									if pg[i].collected then
										-- item harvested, so remove it
										-- print("remove",pg[i].text)
										tremove(pg, i);
									end
								end
							else
								-- empty partition, so remove it
								tremove(g, p);
							end
						end
					end
					if refresh then
						-- refresh the window again
						self:BaseUpdate();
					else
						-- otherwise stop until a group is expanded again
						self.UpdateDone = nil;
					end
				end
			end;
			-- add a bunch of raw, delay-loaded items in order into the window
			local groupCount = math_floor(self.Limit / self.PartitionSize);
			local g, overrides = {}, {visible=true};
			local partition, partitionStart, partitionGroups;
			local dlo, obj = app.DelayLoadedObject, app.CreateAchievementHarvester;
			for j=0,groupCount,1 do
				partitionStart = j * self.PartitionSize;
				partitionGroups = {};
				-- define a sub-group for a range of quests
				partition = {
					["text"] = tostring(partitionStart + 1).."+",
					["icon"] = app.asset("Interface_Quest_header"),
					["visible"] = true,
					["OnClick"] = function(row, button)
						-- assign the clean up method now that the group was clicked
						self.UpdateDone = CleanUpHarvests;
						-- no return so that it acts like a normal row
					end,
					["g"] = partitionGroups,
				};
				for i=1,self.PartitionSize,1 do
					tinsert(partitionGroups, dlo(obj, "text", overrides, partitionStart + i));
				end
				tinsert(g, partition);
			end
			db.g = g;
			db.text = "Achievement Harvester";
			db.icon = app.asset("WindowIcon_RaidAssistant");
			db.description = "This is a contribution debug tool. NOT intended to be used by the majority of the player base.\n\nExpand a group to harvest the 1,000 Achievements within that range.";
			db.visible = true;
			db.back = 1;
			self:SetData(db);
		end
		self:BaseUpdate(true);
	end
end;
local function RoundNumber(number, decimalPlaces)
	local ret;
	if number < 60 then
		ret = number .. " second(s)";
	else
		ret = (("%%.%df"):format(decimalPlaces)):format(number/60) .. " minute(s)";
	end
	return ret;
end
customWindowUpdates.AuctionData = function(self)
	if not self.initialized then
		local C_AuctionHouse_ReplicateItems = C_AuctionHouse.ReplicateItems;
		self.initialized = true;
		self:SetData({
			["text"] = "Auction Module",
			["visible"] = true,
			["back"] = 1,
			["icon"] = 133784,
			["description"] = "This is a debug window for all of the auction data that was returned. Turn on 'Account Mode' to show items usable on any character on your account!",
			["options"] = {
				{
					["text"] = "Wipe Scan Data",
					["icon"] = 2065582,
					["description"] = "Click this button to wipe out all of the previous scan data.",
					["visible"] = true,
					["priority"] = -4,
					["OnClick"] = function()
						if AllTheThingsAuctionData then
							local window = app:GetWindow("AuctionData");
							wipe(AllTheThingsAuctionData);
							wipe(window.data.g);
							for i,option in ipairs(window.data.options) do
								tinsert(window.data.g, option);
							end
							window:Update();
						end
					end,
					['OnUpdate'] = function(data)
						local window = app:GetWindow("AuctionData");
						data.visible = #window.data.g > #window.data.options;
						return true;
					end,
				},
				{
					["text"] = "Scan or Load Last Save",
					["icon"] = 1100023,
					["description"] = "Click this button to perform a full scan of the auction house or load the last scan conducted within 15 minutes. The game may or may not freeze depending on the size of your auction house.\n\nData should populate automatically.",
					["visible"] = true,
					["priority"] = -3,
					["OnClick"] = function()
						if AucAdvanced and AucAdvanced.API then AucAdvanced.API.CompatibilityMode(1, ""); end

						-- Only allow a scan once every 15 minutes.
						local cooldown = self.AuctionScanCooldownTime or 0;
						local now = time();
						if cooldown - now < 0 then
							self.AuctionScanCooldownTime = now + 900;
							app.AuctionFrame:RegisterEvent("REPLICATE_ITEM_LIST_UPDATE");
							C_AuctionHouse_ReplicateItems();
						else
							app.print(": Throttled scan! Please wait " .. RoundNumber(cooldown - now, 0) .. " before running another. Loading last save instead...");
							StartCoroutine("ProcessAuctionData", app.ProcessAuctionData, 1);
						end
					end,
					['OnUpdate'] = app.AlwaysShowUpdate,
				},
				{
					["text"] = "Toggle Debug Mode",
					["icon"] = 134521,
					["description"] = "Click this button to toggle debug mode to show everything regardless of filters!",
					["visible"] = true,
					["priority"] = -2,
					["OnClick"] = function()
						app.Settings:ToggleDebugMode();
					end,
					['OnUpdate'] = function(data)
						data.visible = true;
						if app.MODE_DEBUG then
							-- Novaplane made me do it
							data.trackable = true;
							data.saved = true;
						else
							data.trackable = nil;
							data.saved = nil;
						end
						return true;
					end,
				},
				{
					["text"] = "Toggle Account Mode",
					["icon"] = 413583,
					["description"] = "Turn this setting on if you want to track all of the Things for all of your characters regardless of class and race filters.\n\nUnobtainable filters still apply.",
					["visible"] = true,
					["priority"] = -1,
					["OnClick"] = function()
						app.Settings:ToggleAccountMode();
					end,
					['OnUpdate'] = function(data)
						data.visible = true;
						if app.MODE_ACCOUNT then
							data.trackable = true;
							data.saved = true;
						else
							data.trackable = nil;
							data.saved = nil;
						end
						return true;
					end,
				},
				{
					["text"] = "Toggle Faction Mode",
					["icon"] = 134932,
					["description"] = "Click this button to toggle faction mode to show everything for your faction!",
					["visible"] = true,
					["OnClick"] = function()
						app.Settings:ToggleFactionMode();
					end,
					['OnUpdate'] = function(data)
						if app.MODE_DEBUG or not app.MODE_ACCOUNT then
							data.visible = false;
						else
							data.visible = true;
							if app.Settings:Get("FactionMode") then
								data.trackable = true;
								data.saved = true;
							else
								data.trackable = nil;
								data.saved = nil;
							end
						end
						return true;
					end,
				},
				{
					["text"] = "Toggle Unobtainable Items",
					["icon"] = 135767,
					["description"] = "Click this button to see currently unobtainable items in the auction data.",
					["visible"] = true,
					["priority"] = 0,
					["OnClick"] = function()
						local show = not app.Settings:GetValue("Unobtainable", 7);
						app.Settings:SetValue("Unobtainable", 7, show);
						for k,v in pairs(L.PHASES) do
							if v.state < 4 then
								if k ~= 7 then
									app.Settings:SetValue("Unobtainable", k, show);
								end
							end
						end
						app.Settings:Refresh();
						-- TODO: use events
						-- app:RefreshData();
					end,
					['OnUpdate'] = function(data)
						data.visible = true;
						if app.Settings:GetValue("Unobtainable", 7) then
							data.trackable = true;
							data.saved = true;
						else
							data.trackable = nil;
							data.saved = nil;
						end
						return true;
					end,
				},
			},
			["g"] = {}
		});
		for i,option in ipairs(self.data.options) do
			tinsert(self.data.g, option);
		end
	end

	-- Update the window and all of its row data
	self.data.progress = 0;
	self.data.total = 0;
	self.data.indent = 0;
	self.data.back = 1;
	AssignChildren(self.data);
	app.TopLevelUpdateGroup(self.data);
	self.data.visible = true;
	self:BaseUpdate(true);
end;
customWindowUpdates.Bounty = function(self, force, got)
	if not self.initialized then
		self.initialized = true;
		local autoOpen = app.CreateToggle("openAuto", {
			["text"] = L.OPEN_AUTOMATICALLY,
			["icon"] = 134327,
			["description"] = L.OPEN_AUTOMATICALLY_DESC,
			["visible"] = true,
			["OnUpdate"] = app.AlwaysShowUpdate,
			["OnClickHandler"] = function(toggle)
				app.Settings:SetTooltipSetting("Auto:BountyList", toggle);
				self:BaseUpdate(true, got);
			end,
		});
		local header = app.CreateNPC(app.HeaderConstants.UI_BOUNTY_WINDOW, {
			['visible'] = true,
			["g"] = {
				autoOpen,
			},
		});
		-- add bounty content
		-- TODO: This window pulls its data manually, there should be a key for bounty.
		-- Update this when we merge over Classic's extended window logic.
		-- NOTE: Everything we want is current marked with a u value of 45, so why not just pull that in? :)
		NestObjects(header, {
			app.CreateNPC(app.HeaderConstants.RARES, {
				app.CreateNPC(87622, {	-- Ogom the Mangler
					['g'] = {
						app.CreateItemSource(67041, 119366),
					},
				}),
			}),
			app.CreateNPC(app.HeaderConstants.ZONE_DROPS, {
				["description"] = "These items were likely not readded with 10.1.7 or their source is currently unknown.",
				["g"] = {
					app.CreateItemSource(85, 778),	-- Kobold Excavation Pick
					app.CreateItemSource(1932, 4951),	-- Squeeler's Belt
					app.CreateItem(1462),	-- Ring of the Shadow
					app.CreateItem(1404),	-- Tidal Charm
				},
			}),
		});
		self:SetData(header);
		AssignChildren(self.data);
		self.rawData = {};
		local function RefreshBounties()
			if #self.data.g > 1 and app.Settings:GetTooltipSetting("Auto:BountyList") then
				autoOpen.saved = true;
				self:SetVisible(true);
			end
		end
		self:SetScript("OnEvent", function(self, e, ...)
			if select(1, ...) == appName then
				self:UnregisterEvent("ADDON_LOADED");
				Callback(RefreshBounties);
			end
		end);
		self:RegisterEvent("ADDON_LOADED");
	end
	if self:IsVisible() then
		-- Update the window and all of its row data
		self.data.back = 1;
		self:BaseUpdate(true, got);
	end
end;
customWindowUpdates.CosmicInfuser = function(self, force)
	if self:IsVisible() then
		if not self.initialized then
			self.initialized = true;
			force = true;
			local g = {};
			local rootData = {
				text = "Cosmic Infuser",
				icon = app.asset("Category_Zones"),
				description = "This window helps debug when we're missing map IDs in the addon.",
				OnUpdate = app.AlwaysShowUpdate,
				back = 1,
				indent = 0,
				visible = true,
				expanded = true,
				g = g,
			};

			-- Cache all maps by their ID number, starting with maps we reference in our DB.
			local mapsByID = {};
			for mapID,_ in pairs(app.SearchForFieldContainer("mapID")) do
				if not mapsByID[mapID] then
					local mapObject = app.CreateMap(mapID, {
						mapInfo = C_Map_GetMapInfo(mapID),
						collectible = true,
						collected = true
					});
					mapsByID[mapID] = mapObject;
					mapObject.g = {};	-- Doing this prevents the CreateMap function from creating an exploration header.
				end
			end

			-- Go through all of the possible maps, including only maps that have C_Map data.
			for mapID=1,10000,1 do
				if not mapsByID[mapID] then
					local mapInfo = C_Map_GetMapInfo(mapID);
					if mapInfo then
						local mapObject = app.CreateMap(mapID, {
							mapInfo = mapInfo,
							collectible = true,
							collected = false
						});
						mapsByID[mapID] = mapObject;
						mapObject.g = {};	-- Doing this prevents the CreateMap function from creating an exploration header.
					end
				end
			end

			-- Iterate through the maps we have cached, determine their parents and link them together.
			-- Also push them on to the stack.
			for mapID,mapObject in pairs(mapsByID) do
				local parent = rootData;
				if mapObject.mapInfo then
					local parentMapID = mapObject.mapInfo.parentMapID;
					if parentMapID and parentMapID > 0 then
						local parentMapObject = mapsByID[parentMapID];
						if parentMapObject then
							parent = parentMapObject;
						else
							print("Failed to find parent map in the mapsByID table!", parentMapID);
						end
					end
				end
				mapObject.parent = parent;
				tinsert(parent.g, mapObject);
			end

			-- Sort the maps by number of relative maps, then by name if matching.
			app.Sort(g, function(a, b)
				local aSize, bSize = #a.g, #b.g;
				if aSize > bSize then
					return true;
				elseif bSize == aSize then
					return b.name > a.name;
				else
					return false;
				end
			end, true);

			-- Now finally, clear out unused gs.
			for i,mapObject in ipairs(g) do
				if #mapObject.g < 1 then
					mapObject.g = nil;
				end
			end

			self:SetData(rootData);
		end

		-- Update the window and all of its row data
		self:BaseUpdate(force);
	end
end;
customWindowUpdates.CurrentInstance = function(self, force, got)
	-- app.PrintDebug("CurrentInstance:Update",force,got)
	if not self.initialized then
		force = true;
		self.initialized = true;
		self.CurrentMaps = {};
		self.mapID = -1;
		self.IsSameMapID = function(self)
			return self.CurrentMaps[self.mapID];
		end
		self.SetMapID = function(self, mapID)
			-- app.PrintDebug("SetMapID",mapID)
			self.mapID = mapID;
			self:SetVisible(true);
			self:Update();
		end
		-- local C_Map_GetMapChildrenInfo = C_Map.GetMapChildrenInfo;

		-- Wraps a given object such that it can act as an unfiltered Header of the base group
		local CreateWrapVisualHeader = app.CreateVisualHeaderWithGroups
		-- Returns the consolidated data format for the next header level
		-- Headers are forced not collectible, and will have their content sorted, and can be copied from the existing Source header
		local function CreateHeaderData(group, header)
			-- copy an uncollectible version of the existing header
			if header then
				header = CreateWrapVisualHeader(header, {group})
				header.SortType = "name"
				return header
			else
				return { g = { group }, ["collectible"] = false, SortType = "name" };
			end
		end
		-- set of keys for headers which can be nested in the minilist automatically, but not confined to a direct top header
		local subGroupKeys = {
			"filterID",
			"professionID",
			"raceID",
			"eventID",
			"instanceID",
			"achievementID",
		};
		-- set of keys for headers which can be nested in the minilist within an Instance automatically, but not confined to a direct top header
		local subGroupInstanceKeys = {
			"filterID",
			"professionID",
			"raceID",
			"eventID",
			"achievementID",
		};
		-- Headers possible in a hierarchy that should just be ignored
		local ignoredHeaders = app.HeaderData.IGNOREINMINILIST or app.EmptyTable;

		local function BuildDiscordMapInfoTable(id, mapInfo)
			-- Builds a table to be used in the SetupReportDialog to display text which is copied into Discord for player reports
			mapInfo = mapInfo or C_Map_GetMapInfo(id)
			local info = {
				"### missing-map"..":"..id,
				"```elixir",	-- discord fancy box start
				"L:"..app.Level.." R:"..app.RaceID.." ("..app.Race..") C:"..app.ClassIndex.." ("..app.Class..")",
				id and ("mapID:"..id.." ("..(mapInfo.name or ("Map ID #" .. id))..")") or "mapID:??",
				"real-name:"..(GetRealZoneText() or "?"),
				"sub-name:"..(GetSubZoneText() or "?"),
			};

			local mapID = mapInfo.parentMapID
			while mapID do
				mapInfo = C_Map_GetMapInfo(mapID)
				if mapInfo then
					tinsert(info, "> parentMapID:"..mapID.." ("..(mapInfo.name or "??")..")")
					mapID = mapInfo.parentMapID;
				else break
				end
			end

			local position, coord = id and C_Map.GetPlayerMapPosition(id, "player"), nil;
			if position then
				local x,y = position:GetXY();
				coord = (math_floor(x * 1000) / 10) .. ", " .. (math_floor(y * 1000) / 10);
			end
			tinsert(info, coord and ("coord:"..coord) or "coord:??");

			if app.GameBuildVersion >= 100000 then	-- Only include this after Dragonflight
				local acctUnlocks = {
					IsQuestFlaggedCompleted(72366) and "DF_CA" or "N",	-- Dragonflight Campaign Complete
					IsQuestFlaggedCompleted(75658) and "DF_ZC" or "N",	-- Dragonflight Zaralek Caverns Complete
					IsQuestFlaggedCompleted(79573) and "WW_CA" or "N",	-- The War Within Campaign Complete
				}
				tinsert(info, "unlocks:"..app.TableConcat(acctUnlocks, nil, nil, "/"))
			end
			tinsert(info, "lq:"..(app.TableConcat(app.MostRecentQuestTurnIns or app.EmptyTable, nil, nil, "<") or ""));

			local inInstance, instanceType = IsInInstance()
			tinsert(info, "instance:"..(inInstance and "true" or "false")..":"..(instanceType or ""))
			tinsert(info, "ver:"..app.Version);
			tinsert(info, "build:"..app.GameBuildVersion);
			tinsert(info, "```");	-- discord fancy box end
			return info
		end

		(function()
		local results, groups, nested, header, headerKeys, difficultyID, nextParent, headerID, isInInstance
		local rootGroups, mapGroups = {}, {};

		local function TryExpandCurrentDifficulty()

			if not app.Settings:GetTooltipSetting("Expand:Difficulty") then return end

			local difficultyID = app.GetCurrentDifficultyID()
			if difficultyID == 0 or not header.g then return end

			local expanded
			for _,row in ipairs(header.g) do
				if row.difficultyID or row.difficulties then
					if (row.difficultyID or -1) == difficultyID or (row.difficulties and containsValue(row.difficulties, difficultyID)) then
						if not row.expanded then
							ExpandGroupsRecursively(row, true, true);
							expanded = true;
						end
					elseif row.expanded then
						ExpandGroupsRecursively(row, false, true);
					end
				-- Zone Drops/Common Boss Drops should also be expanded within instances
				-- elseif row.headerID == app.HeaderConstants.ZONE_DROPS or row.headerID == app.HeaderConstants.COMMON_BOSS_DROPS then
				-- 	if not row.expanded then ExpandGroupsRecursively(row, true); expanded = true; end
				end
			end
			-- No difficulty found to expand, so just expand everything in the list once it is built
			if not expanded then
				self.ExpandInfo = { Expand = true };
				expanded = true;
			end
			return expanded
		end

		self.MapCache = setmetatable({}, { __mode = "kv" })
		local function TrySwapFromCache()
			-- window to keep cached maps/not re-build & update them
			local expired = GetTimePreciseSec() - 60
			for mapID,mapData in pairs(self.MapCache) do
				-- app.PrintDebug("Check expired cached map",mapID,mapData._lastshown,expired)
				if mapData._lastshown < expired then
					-- app.PrintDebug("Removed cached map",mapID,mapData._lastshown,expired)
					self.MapCache[mapID] = nil
				end
			end
			local mapID = self.mapID
			header = self.MapCache[mapID]
			if not header then return end
			if not header._maps[mapID] then
				-- app.PrintDebug("cache maps cleared! rebuild new for",mapID)
				self.MapCache[mapID] = nil
				return
			end
			-- app.PrintDebug("Loaded cached Map",mapID)
			header._lastshown = GetTimePreciseSec()
			self:SetData(header)
			TryExpandCurrentDifficulty()
			self.CurrentMaps = header._maps
			-- app.PrintTable(self.CurrentMaps)
			-- Reset the Fill if needed
			if not header._fillcomplete then
				-- app.PrintDebug("Re-fill cached Map",mapID)
				app.SetSkipLevel(2);
				app.FillGroups(header);
				app.SetSkipLevel(0);
			end
			Callback(self.Update, self);
			return true
		end

		app.AddEventHandler("OnSettingsNeedsRefresh", function()
			-- if settings change that requrie refresh, wipe cached maps
			wipe(self.MapCache)
		end)

		self.Rebuild = function(self)
			-- Reset the minilist Runner before building new data
			self:GetRunner().Reset()

			if TrySwapFromCache() then return end
			-- app.PrintDebug("Rebuild",self.mapID);
			local currentMaps, mapID = {}, self.mapID

			-- Get all results for this map, without any results that have been cloned into Source Ignored groups or are under Unsorted
			results = CleanInheritingGroups(SearchForField("mapID", mapID), "sourceIgnored");
			-- app.PrintDebug("Rebuild#",#results);
			if results and #results > 0 then

				-- I tend to like this way of finding sub-maps, but it does mean we rely on Blizzard and get whatever maps they happen to claim
				-- are children of a given map... sometimes has weird results like scenarios during quests being considered children in
				-- other zones. Since it can give us special top-level maps (Anniversary AV) also as children of other top-level maps (Hillsbarad)
				-- we would need to filter the results and add them properly into the results below via sub-groups if they are maps themselves
				-- local submapinfos = ArrayAppend(C_Map_GetMapChildrenInfo(mapID, 5), C_Map_GetMapChildrenInfo(mapID, 6))
				-- if submapinfos then
					-- for _,mapInfo in ipairs(submapinfos) do
						-- subresults = CleanInheritingGroups(SearchForField("mapID", mapInfo.mapID), "sourceIgnored")
						-- app.PrintDebug("Adding Sub-Map Results:",mapInfo.mapID,mapInfo.mapType,#subresults)
						-- results = ArrayAppend(results, subresults)
					-- end
				-- end
				-- See if there are any sub-maps we should also include by way of the 'maps' field on the 'real' map for this id
				local rootMap
				for _,result in ipairs(results) do
					if result.key == "mapID" and result.mapID == mapID then
						rootMap = result
						break;
					end
				end
				if rootMap and rootMap.maps then
					local subresults
					for _,subMapID in ipairs(rootMap.maps) do
						if subMapID ~= mapID then
							subresults = CleanInheritingGroups(SearchForField("mapID", subMapID), "sourceIgnored")
							-- app.PrintDebug("Adding Sub-Map Results:",subMapID,#subresults)
							results = ArrayAppend(results, subresults)
						end
					end
				end
				-- Simplify the returned groups
				groups = {};
				wipe(rootGroups);
				wipe(mapGroups);
				header = { mapID = mapID, g = groups }
				currentMaps[mapID] = true;
				isInInstance = IsInInstance();
				headerKeys = isInInstance and subGroupInstanceKeys or subGroupKeys;
				-- split search results by whether they represent the 'root' of the minilist or some other mapped content
				for _,group in ipairs(results) do
					-- do not use any raw Source groups in the final list
					group = CreateObject(group);
					-- Instance/Map/Class/Header(of current map) groups are allowed as root of minilist
					if (group.instanceID or (group.mapID and (group.key == "mapID" or (group.key == "headerID" and group.mapID == mapID))) or group.key == "classID")
						-- and actually match this minilist...
						-- only if this group mapID matches the minilist mapID directly or by maps
						and (group.mapID == mapID or (group.maps and contains(group.maps, mapID))) then
						rootGroups[#rootGroups + 1] = group
					else
						mapGroups[#mapGroups + 1] = group
					end
				end
				-- first merge all root groups into the list
				for _,group in ipairs(rootGroups) do
					if group.maps then
						for _,m in ipairs(group.maps) do
							currentMaps[m] = true;
						end
					end
					-- app.PrintDebug("Merge as Root",group.hash)
					MergeProperties(header, group, true);
					NestObjects(header, group.g);
				end
				-- then merge all mapped groups into the list
				for _,group in ipairs(mapGroups) do
					-- app.PrintDebug("Mapping:",app:SearchLink(group))
					nested = nil;

					-- Get the header chain for the group
					nextParent = group.parent;

					-- Cache the difficultyID, if there is one and we are in an actual instance where the group is being mapped
					difficultyID = isInInstance and GetRelativeValue(nextParent, "difficultyID");

					-- Building the header chain for each mapped Thing
					while nextParent do
						headerID = nextParent.headerID
						if headerID then
							-- all Headers implicitly are allowed as visual headers in minilist unless explicitly ignored
							if not ignoredHeaders[headerID] then
								group = CreateHeaderData(group, nextParent);
								nested = true;
							end
						elseif nextParent.isMinilistHeader then
							group = CreateHeaderData(group, nextParent);
							nested = true;
						else
							for _,hkey in ipairs(headerKeys) do
								if nextParent[hkey] then
									-- create the specified group Type header
									group = CreateHeaderData(group, nextParent);
									nested = true;
									break;
								end
							end
						end
						nextParent = nextParent.parent;
					end

					-- really really special cases...
					-- Battle Pets get an additional raw Filter nesting
					if not nested and group.key == "speciesID" then
						group = app.CreateFilter(101, CreateHeaderData(group));
					end

					-- If relative to a difficultyID, then merge it into one.
					if difficultyID then group = app.CreateDifficulty(difficultyID, { g = { group } }); end
					-- app.PrintDebug("Merge as Mapped:",app:SearchLink(group))
					MergeObject(groups, group);
				end

				if #rootGroups == 0 then
					-- if only one group in the map root, then shift it up as the map root instead
					local headerGroups = header.g;
					if #headerGroups == 1 then
						header.g = nil;
						MergeProperties(header, headerGroups[1], true);
						NestObjects(header, headerGroups[1].g);
					else
						app.PrintDebug("No root Map groups!",mapID)
					end
				end

				header.u = nil;
				header.e = nil;
				if header.instanceID then
					header = app.CreateInstance(header.instanceID, header);
				else
					if header.classID then
						header = app.CreateCharacterClass(header.classID, header);
					else
						header = app.CreateMap(header.mapID, header);
					end
					-- sort top level by name if not in an instance
					header.SortType = "Global";
				end

				-- Swap out the map data for the header.
				self:SetData(header);
				header._maps = currentMaps
				header._lastshown = GetTimePreciseSec()
				-- app.PrintDebug("Saved cached Map",mapID,header._lastshown)
				self.MapCache[mapID] = header
				-- Fill up the groups that need to be filled!
				app.SetSkipLevel(2);
				app.FillGroups(header);
				app.SetSkipLevel(0);

				-- if enabled, minimize rows based on difficulty
				local expanded = TryExpandCurrentDifficulty()

				self:BuildData();

				-- check to expand groups after they have been built and updated
				-- dont re-expand if the user has previously full-collapsed the minilist
				-- need to force expand if so since the groups haven't been updated yet
				if not expanded and not self.fullCollapsed then
					self.ExpandInfo = { Expand = true };
				end
				self.CurrentMaps = currentMaps;

				-- Make sure to scroll to the top when being rebuilt
				self.ScrollBar:SetValue(1);
			else
				-- If we don't have any data cached for this mapID and it exists in game, report it to the chat window.
				self.CurrentMaps = {[mapID]=true};
				local mapInfo = C_Map_GetMapInfo(mapID);
				if mapInfo then
					-- only report for mapIDs which actually exist
					mapID = self.mapID
					-- Linkify the output
					local popupID = "map-" .. mapID
					app:SetupReportDialog(popupID, "Missing Map: " .. mapID, BuildDiscordMapInfoTable(mapID, mapInfo))
					app.report(app:Linkify(app.Version.." (Click to Report) No data found for this Location!", app.Colors.ChatLinkError, "dialog:" .. popupID));
				end
				self:SetData(app.CreateMap(mapID, {
					["text"] = L.MINI_LIST .. " [" .. mapID .. "]",
					["icon"] = 237385,
					["description"] = L.MINI_LIST_DESC,
					["visible"] = true,
					["g"] = {
						{
							["text"] = L.UPDATE_LOCATION_NOW,
							["icon"] = 134269,
							["description"] = L.UPDATE_LOCATION_NOW_DESC,
							["OnClick"] = function(row, button)
								Callback(app.LocationTrigger)
								return true;
							end,
							["OnUpdate"] = app.AlwaysShowUpdate,
						},
					},
				}));
				self:BuildData();
			end
			-- app.PrintDebugPrior("RB-Done")
			return true;
		end
		end)()
		self.RefreshLocation = function(show)
			-- Acquire the new map ID.
			local mapID = app.CurrentMapID;
			-- app.PrintDebug("RefreshLocation",mapID)
			-- can't really do anything about this from here anymore
			if not mapID then return end
			-- don't auto-load minimap to anything higher than a 'Zone' if we are in an instance, unless it has no parent?
			if IsInInstance() then
				local mapInfo = app.CurrentMapInfo;
				if mapInfo and mapInfo.parentMapID and (mapInfo.mapType or 0) < 3 then
					-- app.PrintDebug("Don't load Large Maps in minilist")
					return;
				end
			end

			-- Cache that we're in the current map ID.
			-- app.PrintDebug("new map");
			self.mapID = mapID;
			if show then
				self:SetVisible(true)
			end
			-- force update when showing the minilist
			Callback(self.Update, self);
		end
	end
	if self:IsVisible() then
		-- Update the window and all of its row data
		if not self:IsSameMapID() then
			-- app.PrintDebug("Leaving map",self.data.mapID)
			self.data._lastshown = GetTimePreciseSec()
			force = self:Rebuild();
		else
			-- Update the mapID into the data for external reference in case not rebuilding
			self.data.mapID = self.mapID;
		end
		self:BaseUpdate(force, got);
	end
end;
customWindowUpdates.ItemFilter = function(self, force)
	if self:IsVisible() then
		if not app:GetDataCache() then	-- This module requires a valid data cache to function correctly.
			return;
		end
		if not self.initialized then
			self.initialized = true;

			function self:Clear()
				local temp = self.data.g[1];
				wipe(self.data.g);
				tinsert(self.data.g, temp);
			end

			function self:Search(field, value)
				value = value or true
				-- app.PrintDebug("Search",field,value)
				local results = app:BuildSearchResponse(field, value, {g=true});
				-- app.PrintDebug("Results",#results)
				ArrayAppend(self.data.g, results);
				self.data.text = L.ITEM_FILTER_TEXT..("  [%s=%s]"):format(field,tostring(value == app.Modules.Search.SearchNil and "nil" or value));
			end

			-- Item Filter
			local data = {
				['text'] = L.ITEM_FILTER_TEXT,
				['icon'] = app.asset("Category_ItemSets"),
				["description"] = L.ITEM_FILTER_DESCRIPTION,
				['visible'] = true,
				['back'] = 1,
				['g'] = {
					{
						['text'] = L.ITEM_FILTER_BUTTON_TEXT,
						['icon'] = 134246,
						['description'] = L.ITEM_FILTER_BUTTON_DESCRIPTION,
						['visible'] = true,
						['OnUpdate'] = app.AlwaysShowUpdate,
						['OnClick'] = function(row, button)
							app:ShowPopupDialogWithEditBox(L.ITEM_FILTER_POPUP_TEXT, "", function(input)
								local text = input:lower();
								local f = tonumber(text);
								if text ~= "" and tostring(f) ~= text then
									text = text:gsub("-", "%%-");
									-- app.PrintDebug("search match",text)
									-- The string form did not match, the filter must have been by name.
									for id,filter in pairs(L.FILTER_ID_TYPES) do
										if filter:lower():match(text) then
											f = tonumber(id);
											break;
										end
									end
								end

								self:Clear();

								if f then
									self:Search("f", f);
								else
									-- direct field search
									local field, value = ("="):split(input);
									value = tonumber(value) or value;
									if value and value ~= "" then
										-- allows performing a value search when looking for 'nil'
										if value == "nil" then
											value = app.Modules.Search.SearchNil;
										-- use proper bool values if specified
										elseif value == "true" then
											value = true;
										elseif value == "false" then
											value = false;
										end
										self:Search(field, value);
									else
										self:Search(field);
									end
								end
								-- maybe local table of common fields from lowercase -> match

								self:BuildData();
								self:Update(true);
							end);
							return true;
						end,
					},
				},
			};

			self:SetData(data);
			self:BuildData();
		end

		self:BaseUpdate(force);
	end
end;
customWindowUpdates.NWP = function(self, force)
	if not self.initialized then
		if not app:GetDataCache() then	-- This module requires a valid data cache to function correctly.
			return;
		end
		self.initialized = true;
		local TypeGroupOverrides = {
			visible = true
		}
		local function OnUpdate_RemoveEmptyDynamic(t)
			-- nothing to show so don't be visible
			if not t.g or #t.g == 0 then
				return
			end
			local o
			for i=#t.g,1,-1 do
				o = t.g[i]
				if o.__empty then
					tremove(t.g, i)
				end
			end
			if #t.g == 0 then
				return
			end
			t.visible = true
			return true
		end
		local function CreateTypeGroupsForHeader(header, searchResults)
			-- TODO: professions would be more complex since it's so many sub-groups to organize
			-- maybe just simpler to look for the 'requireSkill' field and put all those results into one 'Professions' group?
			-- app.PrintDebug("Creating type group header",header.name, header.id, searchResults and #searchResults)
			local typeGroup = app.CreateRawText(header.name, header)
			local headerDataWithinPatch = app:BuildTargettedSearchResponse(searchResults, header.id, nil, {g=true})
			-- app.PrintDebug("Found",#headerDataWithinPatch,"search groups for",header.id)
			NestObjects(typeGroup, headerDataWithinPatch)
			-- did we populate nothing?
			if not typeGroup.g or #typeGroup.g == 0 then
				typeGroup.__empty = true
			else
				app.AssignChildren(typeGroup)
			end
			Callback(app.DirectGroupUpdate, typeGroup.parent)
			return typeGroup
		end
		local function CreateNWPWindow()
			-- Fetch search results
			local searchResults = app:BuildSearchResponse("awp", app.GameBuildVersion)

			-- Create the dynamic category
			local dynamicCategory = app.CreateRawText(L.CLICK_TO_CREATE_FORMAT:format(L.SETTINGS_MENU.DYNAMIC_CATEGORY_LABEL), {
				icon = app.asset("Interface_CreateDynamic"),
				OnUpdate = OnUpdate_RemoveEmptyDynamic,
				g = {}
			})

			-- Dynamic category headers
			-- TODO: If possible, change the creation of names and icons to SimpleNPCGroup to take the localized names
			local headers = {
				{ id = "achievementID", name = ACHIEVEMENTS, icon = app.asset("Category_Achievements") },
				{ id = "sourceID", name = "Appearances", icon = 135276 },
				{ id = "artifactID", name = ITEM_QUALITY6_DESC, icon = app.asset("Weapon_Type_Artifact") },
				{ id = "azeriteessenceID", name = SPLASH_BATTLEFORAZEROTH_8_2_0_FEATURE2_TITLE, icon = app.asset("Category_AzeriteEssences") },
				{ id = "speciesID", name = AUCTION_CATEGORY_BATTLE_PETS, icon = app.asset("Category_PetJournal") },
				{ id = "campsiteID", name = WARBAND_SCENES, icon = app.asset("Category_Campsites") },
				{ id = "characterUnlock", name = CHARACTER .. " " .. UNLOCK .. "s", icon = app.asset("Category_ItemSets") },
				{ id = "conduitID", name = GetSpellName(348869) .. " (" .. EXPANSION_NAME8 .. ")", icon = 3601566 },
				{ id = "currencyID", name = CURRENCY, icon = app.asset("Interface_Vendor") },
				{ id = "explorationID", name = "Exploration", icon = app.asset("Category_Exploration") },
				{ id = "factionID", name = L.FACTIONS, icon = app.asset("Category_Factions") },
				{ id = "flightpathID", name = L.FLIGHT_PATHS, icon = app.asset("Category_FlightPaths") },
				{ id = "followerID", name = GARRISON_FOLLOWERS, icon = app.asset("Category_Followers") },
				{ id = "heirloomID", name = HEIRLOOMS, icon = app.asset("Weapon_Type_Heirloom") },
				{ id = "illusionID", name = L.FILTER_ID_TYPES[103], icon = app.asset("Category_Illusions") },
				{ id = "mountID", name = MOUNTS, icon = app.asset("Category_Mounts") },
				{ id = "mountmodID", name = "Mount Mods", icon = 975744 },
				-- TODO: Add professions here using the byValue probably
				{ id = "questID", name = TRACKER_HEADER_QUESTS, icon = app.asset("Interface_Quest_header") },
				{ id = "runeforgepowerID", name = LOOT_JOURNAL_LEGENDARIES .. " (" .. EXPANSION_NAME8 .. ")", icon = app.asset("Weapon_Type_Legendary") },
				{ id = "titleID", name = PAPERDOLL_SIDEBAR_TITLES, icon = app.asset("Category_Titles") },
				{ id = "toyID", name = TOY_BOX, icon = app.asset("Category_ToyBox") },
			}

			-- Loop through the dynamic headers and insert them into the "g" field of dynamic category
			for _, header in ipairs(headers) do
				header.parent = dynamicCategory
				dynamicCategory.g[#dynamicCategory.g + 1] = app.DelayLoadedObject(CreateTypeGroupsForHeader, "text", TypeGroupOverrides, header, searchResults)
			end

			-- Merge searchResults with dynamicCategory
			tinsert(searchResults, dynamicCategory)

			return searchResults
		end
		local NWPwindow = {
			text = L.NEW_WITH_PATCH,
			icon = app.asset("WindowIcon_RWP"),
			description = L.NEW_WITH_PATCH_TOOLTIP,
			visible = true,
			back = 1,
			g = CreateNWPWindow(),
		};
		self:SetData(NWPwindow);
		self:BuildData();
	end
	if self:IsVisible() then
		self:BaseUpdate(force);
	end
end;
customWindowUpdates.awp = function(self, force)	-- TODO: Change this to remember window data of each expansion (param) and dont make new windows infinitely
	-- Patch Interface Build tables
	local CLASSIC = {10100,10200,10300,10400,10500,10600,10700,10800,10900,10903,11000,11100,11101,11102,11200,11201}
	-- Classic was using different build numbers originally, so these are made up to make a correct timeline search
	local TBC = {20000,20001,20003,20005,20006,20007,20008,20010,20012,20100,20101,
	20102,20103,20200,20202,20203,20300,20302,20303,20400,20401,20402,20403}
	-- TBC Patch 2.0.10 and 2.0.12 did not have a valid build numbers, so these are made up to make a correct timeline search
	local WRATH = {30002,30003,30008,30100,30101,30102,30103,30200,30202,30300,30302,30303,30305}
	local CATA = {40001,40003,40006,40100,40200,40202,40300,40302}
	local MOP = {50004,50100,50200,50300,50400,50402,50407}
	local WOD = {60002,60003,60100,60102,60200,60202,60203,60204}
	local LEGION = {70003,70100,70105,70200,70205,70300,70302,70305}
	local BFA = {80001,80100,80105,80200,80205,80300,80307}
	local SL = {90001,90002,90005,90100,90105,90200,90205,90207}
	local DF = {100000,100002,100005,100007,100100,100105,100107,100200,100205,100206,100207}
	local TWW = {110000,110002,110005,110007,110100,110105,110107}

	-- Locals
	local param = {}
	local foundExpansion = false
	local expansionHeader, patchString, majorVersion, middleDigits, lastDigits, formattedPatch

	-- Table to map expansion shortcuts to their respective parameters and headers
	local expansions = {
		classic = {param = CLASSIC, header = 1},
		tbc = {param = TBC, header = 2},
		wotlk = {param = WRATH, header = 3},
		cata = {param = CATA, header = 4},
		mop = {param = MOP, header = 5},
		wod = {param = WOD, header = 6},
		legion = {param = LEGION, header = 7},
		bfa = {param = BFA, header = 8},
		sl = {param = SL, header = 9},
		df = {param = DF, header = 10},
		tww = {param = TWW, header = 11}
	}

	-- Function for dynamic groups
	local function GetSearchCriteriaForPatch(patch)
		local dynamic_searchcriteria = {
			SearchValueCriteria = {
				-- Only include 'awp' search results where the value is equal to the patch
				function(o, field, value)
					local awp = o[field]
					if not awp then return end
					return (app.GetRelativeValue(o, "awp") or 0) == patch
				end
			},
		}
		return dynamic_searchcriteria
	end


	-- Iterate over the expansions and check for the selected one
	for k, v in pairs(expansions) do
		if app.GetCustomWindowParam("awp", k) == true then
			param = v.param
			expansionHeader = v.header
			foundExpansion = true
			break
		end
	end

	-- If no expansion was found, print an error message
	if foundExpansion == false then
		app.print("Unknown expansion shortcut.")
		self:Hide();
	elseif not self.initialized then
		if not app:GetDataCache() then	-- This module requires a valid data cache to function correctly.
			return;
		end
		self.initialized = true;
		local TypeGroupOverrides = {
			visible = true
		}
		local function OnUpdate_RemoveEmptyDynamic(t)
			-- nothing to show so don't be visible
			if not t.g or #t.g == 0 then
				return
			end
			local o
			for i=#t.g,1,-1 do
				o = t.g[i]
				if o.__empty then
					tremove(t.g, i)
				end
			end
			if #t.g == 0 then
				return
			end
			t.visible = true
			return true
		end
		local function CreateTypeGroupsForHeader(header, searchResults)
			-- TODO: professions would be more complex since it's so many sub-groups to organize
			-- maybe just simpler to look for the 'requireSkill' field and put all those results into one 'Professions' group?
			-- app.PrintDebug("Creating type group header",header.name, header.id, searchResults and #searchResults)
			local typeGroup = app.CreateRawText(header.name, header)
			local headerDataWithinPatch = app:BuildTargettedSearchResponse(searchResults, header.id, nil, {g=true})
			-- app.PrintDebug("Found",#headerDataWithinPatch,"search groups for",header.id)
			NestObjects(typeGroup, headerDataWithinPatch)
			-- did we populate nothing?
			if not typeGroup.g or #typeGroup.g == 0 then
				typeGroup.__empty = true
			else
				app.AssignChildren(typeGroup)
			end
			Callback(app.DirectGroupUpdate, typeGroup.parent)
			return typeGroup
		end
		local function CreatePatches(patchTable)
			local patchBuild = {}
			for _, patch in ipairs(patchTable) do
				patchString = tostring(patch)
				if math.floor(patch / 10000) < 10 then	-- Before Dragonflight
					majorVersion = patchString:sub(1, 1)  -- "7"	-- Patch 7.x.x
					middleDigits = patchString:sub(2, 3)  -- "02"	-- Patch x.2.x
				else	-- After Dragonflight
					majorVersion = patchString:sub(1, 2)  -- "10"	-- Patch 10.x.x
					middleDigits = patchString:sub(3, 4)  -- "02"	-- Patch x.2.x
				end
				lastDigits = patchString:sub(-2)  -- "02"	-- Patch x.x.2
				formattedPatch = majorVersion .. "." .. middleDigits .. lastDigits

				-- Create the patch header
				local patchHeader = app.CreateExpansion(formattedPatch, {g={}})

				-- Fetch search results
				local searchResults = app:BuildSearchResponse("awp", patch)
				NestObjects(patchHeader, searchResults)

				-- Create the dynamic category
				local dynamicCategory = app.CreateRawText(L.CLICK_TO_CREATE_FORMAT:format(L.SETTINGS_MENU.DYNAMIC_CATEGORY_LABEL), {
					icon = app.asset("Interface_CreateDynamic"),
					OnUpdate = OnUpdate_RemoveEmptyDynamic,
					g = {}
				})

				-- Dynamic category headers
				-- TODO: If possible, change the creation of names and icons to SimpleNPCGroup to take the localized names
				local headers = {
					{ id = "achievementID", name = ACHIEVEMENTS, icon = app.asset("Category_Achievements") },
					{ id = "sourceID", name = "Appearances", icon = 135276 },
					{ id = "artifactID", name = ITEM_QUALITY6_DESC, icon = app.asset("Weapon_Type_Artifact") },
					{ id = "azeriteessenceID", name = SPLASH_BATTLEFORAZEROTH_8_2_0_FEATURE2_TITLE, icon = app.asset("Category_AzeriteEssences") },
					{ id = "speciesID", name = AUCTION_CATEGORY_BATTLE_PETS, icon = app.asset("Category_PetJournal") },
					{ id = "campsiteID", name = WARBAND_SCENES, icon = app.asset("Category_Campsites") },
					{ id = "characterUnlock", name = CHARACTER .. " " .. UNLOCK .. "s", icon = app.asset("Category_ItemSets") },
					{ id = "conduitID", name = GetSpellName(348869) .. " (" .. EXPANSION_NAME8 .. ")", icon = 3601566 },
					{ id = "currencyID", name = CURRENCY, icon = app.asset("Interface_Vendor") },
					{ id = "explorationID", name = "Exploration", icon = app.asset("Category_Exploration") },
					{ id = "factionID", name = L.FACTIONS, icon = app.asset("Category_Factions") },
					{ id = "flightpathID", name = L.FLIGHT_PATHS, icon = app.asset("Category_FlightPaths") },
					{ id = "followerID", name = GARRISON_FOLLOWERS, icon = app.asset("Category_Followers") },
					{ id = "heirloomID", name = HEIRLOOMS, icon = app.asset("Weapon_Type_Heirloom") },
					{ id = "illusionID", name = L.FILTER_ID_TYPES[103], icon = app.asset("Category_Illusions") },
					{ id = "mountID", name = MOUNTS, icon = app.asset("Category_Mounts") },
					{ id = "mountmodID", name = "Mount Mods", icon = 975744 },
					-- TODO: Add professions here using the byValue probably
					{ id = "questID", name = TRACKER_HEADER_QUESTS, icon = app.asset("Interface_Quest_header") },
					{ id = "runeforgepowerID", name = LOOT_JOURNAL_LEGENDARIES .. " (" .. EXPANSION_NAME8 .. ")", icon = app.asset("Weapon_Type_Legendary") },
					{ id = "titleID", name = PAPERDOLL_SIDEBAR_TITLES, icon = app.asset("Category_Titles") },
					{ id = "toyID", name = TOY_BOX, icon = app.asset("Category_ToyBox") },
				}

				-- Loop through the dynamic headers and insert them into the "g" field of dynamic category
				for _, header in ipairs(headers) do
					header.parent = dynamicCategory
					dynamicCategory.g[#dynamicCategory.g + 1] = app.DelayLoadedObject(CreateTypeGroupsForHeader, "text", TypeGroupOverrides, header, searchResults)
				end

				-- Merge patchHeaders and searchResults with dynamicCategory
				tinsert(patchHeader.g, dynamicCategory)

				-- Insert the final merged patchHeader into patchBuild
				tinsert(patchBuild, patchHeader)
			end
			return patchBuild
		end
		local AWPwindow = {
			text = L.ADDED_WITH_PATCH,
			icon = 135769,
			description = L.ADDED_WITH_PATCH_TOOLTIP,
			visible = true,
			back = 1,
			g = {
				app.CreateExpansion(expansionHeader, {
					expanded=true,
					g = CreatePatches(param),
				}),
			},
		};
		self:SetData(AWPwindow);
		self:BuildData();
	end
	if self:IsVisible() then
		self:BaseUpdate(force);
	end
end;
customWindowUpdates.Prime = function(self, ...)
	self:BaseUpdate(...);

	-- Write the current character's progress if a top-level update has been completed
	local rootData = self.data;
	if rootData and rootData.TLUG and rootData.total and rootData.total > 0 then
		app.CurrentCharacter.PrimeData = {
			progress = rootData.progress,
			total = rootData.total,
			modeString = rootData.modeString,
		};
	end
end
customWindowUpdates.RaidAssistant = function(self)
	if self:IsVisible() then
		if not self.initialized then
			self.initialized = true;
			self.doesOwnUpdate = true;

			-- Define the different window configurations that the mini list will switch to based on context.
			local raidassistant, lootspecialization, dungeondifficulty, raiddifficulty, legacyraiddifficulty;
			local GetDifficultyInfo, GetInstanceInfo = GetDifficultyInfo, GetInstanceInfo;

			-- Raid Assistant
			local switchDungeonDifficulty = function(row, button)
				self:SetData(raidassistant);
				SetDungeonDifficultyID(row.ref.difficultyID);
				Callback(self.Update, self);
				return true;
			end
			local switchRaidDifficulty = function(row, button)
				self:SetData(raidassistant);
				local myself = self;
				local difficultyID = row.ref.difficultyID;
				if not self.running then
					self.running = true;
				else
					self.running = false;
				end

				SetRaidDifficultyID(difficultyID);
				StartCoroutine("RaidDifficulty", function()
					while InCombatLockdown() do coroutine.yield(); end
					while myself.running do
						for i=0,150,1 do
							if myself.running then
								coroutine.yield();
							else
								break;
							end
						end
						if app.RaidDifficulty == difficultyID then
							myself.running = false;
							break;
						else
							SetRaidDifficultyID(difficultyID);
						end
					end
					Callback(self.Update, self);
				end);
				return true;
			end
			local switchLegacyRaidDifficulty = function(row, button)
				self:SetData(raidassistant);
				local myself = self;
				local difficultyID = row.ref.difficultyID;
				if not self.legacyrunning then
					self.legacyrunning = true;
				else
					self.legacyrunning = false;
				end
				SetLegacyRaidDifficultyID(difficultyID);
				StartCoroutine("LegacyRaidDifficulty", function()
					while InCombatLockdown() do coroutine.yield(); end
					while myself.legacyrunning do
						for i=0,150,1 do
							if myself.legacyrunning then
								coroutine.yield();
							else
								break;
							end
						end
						if app.LegacyRaidDifficulty == difficultyID then
							myself.legacyrunning = false;
							break;
						else
							SetLegacyRaidDifficultyID(difficultyID);
						end
					end
					Callback(self.Update, self);
				end);
				return true;
			end
			local function AttemptResetInstances()
				ResetInstances();
			end
			raidassistant = {
				['text'] = L.RAID_ASSISTANT,
				['icon'] = app.asset("WindowIcon_RaidAssistant"),
				["description"] = L.RAID_ASSISTANT_DESC,
				['visible'] = true,
				['back'] = 1,
				['g'] = {
					{
						['text'] = L.LOOT_SPEC_UNKNOWN,
						['title'] = L.LOOT_SPEC,
						["description"] = L.LOOT_SPEC_DESC,
						['visible'] = true,
						['OnClick'] = function(row, button)
							self:SetData(lootspecialization);
							Callback(self.Update, self);
							return true;
						end,
						['OnUpdate'] = function(data)
							if self.Spec then
								local id, name, description, icon, role, class = GetSpecializationInfoByID(self.Spec);
								if name then
									if GetLootSpecialization() == 0 then name = name .. " (Automatic)"; end
									data.text = name;
									data.icon = icon;
								end
							end
						end,
					},
					app.CreateDifficulty(1, {
						['title'] = L.DUNGEON_DIFF,
						["description"] = L.DUNGEON_DIFF_DESC,
						['visible'] = true,
						["trackable"] = false,
						['OnClick'] = function(row, button)
							self:SetData(dungeondifficulty);
							Callback(self.Update, self);
							return true;
						end,
						['OnUpdate'] = function(data)
							if app.DungeonDifficulty then
								data.difficultyID = app.DungeonDifficulty;
								data.name = GetDifficultyInfo(data.difficultyID) or "???";
								local name, instanceType, instanceDifficulty, difficultyName = GetInstanceInfo();
								if instanceDifficulty and data.difficultyID ~= instanceDifficulty and instanceType == 'party' then
									data.name = data.name .. " (" .. (difficultyName or "???") .. ")";
								end
							end
						end,
					}),
					app.CreateDifficulty(14, {
						['title'] = L.RAID_DIFF,
						["description"] = L.RAID_DIFF_DESC,
						['visible'] = true,
						["trackable"] = false,
						['OnClick'] = function(row, button)
							-- Don't allow you to change difficulties when you're in LFR / Raid Finder
							if app.RaidDifficulty == 7 or app.RaidDifficulty == 17 then return true; end
							self:SetData(raiddifficulty);
							Callback(self.Update, self);
							return true;
						end,
						['OnUpdate'] = function(data)
							if app.RaidDifficulty then
								data.difficultyID = app.RaidDifficulty;
								local name, instanceType, instanceDifficulty, difficultyName = GetInstanceInfo();
								if instanceDifficulty and data.difficultyID ~= instanceDifficulty and instanceType == 'raid' then
									data.name = (GetDifficultyInfo(data.difficultyID) or "???") .. " (" .. (difficultyName or "???") .. ")";
								else
									data.name = GetDifficultyInfo(data.difficultyID);
								end
							end
						end,
					}),
					app.CreateDifficulty(5, {
						['title'] = L.LEGACY_RAID_DIFF,
						["description"] = L.LEGACY_RAID_DIFF_DESC,
						['visible'] = true,
						["trackable"] = false,
						['OnClick'] = function(row, button)
							-- Don't allow you to change difficulties when you're in LFR / Raid Finder
							if app.RaidDifficulty == 7 or app.RaidDifficulty == 17 then return true; end
							self:SetData(legacyraiddifficulty);
							Callback(self.Update, self);
							return true;
						end,
						['OnUpdate'] = function(data)
							if app.LegacyRaidDifficulty then
								data.difficultyID = app.LegacyRaidDifficulty;
							end
						end,
					}),
					{
						['text'] = L.RESET_INSTANCES,
						['icon'] = app.asset("Button_Reset"),
						['description'] = L.RESET_INSTANCES_DESC,
						['visible'] = true,
						['OnClick'] = function(row, button)
							-- make sure the indicator icon is allowed to show
							if IsAltKeyDown() then
								row.ref.saved = not row.ref.saved;
								Callback(self.Update, self);
							else
								ResetInstances();
							end
							return true;
						end,
						['OnUpdate'] = function(data)
							data.trackable = data.saved;
							data.visible = not IsInGroup() or UnitIsGroupLeader("player");
							if data.visible and data.saved then
								if IsInInstance() or C_Scenario.IsInScenario() then
									data.shouldReset = true;
								elseif data.shouldReset then
									data.shouldReset = nil;
									C_Timer.After(0.5, AttemptResetInstances);
								end
							end
						end,
					},
					{
						['text'] = L.TELEPORT_TO_FROM_DUNGEON,
						['icon'] = 136222,
						['description'] = L.TELEPORT_TO_FROM_DUNGEON_DESC,
						['visible'] = true,
						['OnClick'] = function(row, button)
							LFGTeleport(IsInLFGDungeon() and true or false);
							return true;
						end,
						['OnUpdate'] = function(data)
							data.visible = IsAllowedToUserTeleport();
						end,
					},
					{
						['text'] = L.DELIST_GROUP,
						['icon'] = 252175,
						['description'] = L.DELIST_GROUP_DESC,
						['visible'] = true,
						['OnClick'] = function(row, button)
							C_LFGList.RemoveListing();
							if GroupFinderFrame:IsVisible() then
								PVEFrame_ToggleFrame("GroupFinderFrame")
							end
							self:SetData(raidassistant);
							Callback(self.BaseUpdate, self, true);
							return true;
						end,
						['OnUpdate'] = function(data)
							data.visible = C_LFGList.GetActiveEntryInfo();
						end,
					},
					{
						['text'] = L.LEAVE_GROUP,
						['icon'] = 132331,
						['description'] = L.LEAVE_GROUP_DESC,
						['visible'] = true,
						['OnClick'] = function(row, button)
							C_PartyInfo.LeaveParty();
							if GroupFinderFrame:IsVisible() then
								PVEFrame_ToggleFrame("GroupFinderFrame")
							end
							self:SetData(raidassistant);
							Callback(self.BaseUpdate, self, true);
							return true;
						end,
						['OnUpdate'] = function(data)
							data.visible = IsInGroup();
						end,
					},
				}
			};
			lootspecialization = {
				['text'] = L.LOOT_SPEC,
				['icon'] = 1499566,
				["description"] = L.LOOT_SPEC_DESC_2,
				['OnClick'] = function(row, button)
					self:SetData(raidassistant);
					Callback(self.Update, self);
					return true;
				end,
				['OnUpdate'] = function(data)
					data.g = {};
					local numSpecializations = GetNumSpecializations();
					if numSpecializations and numSpecializations > 0 then
						tinsert(data.g, {
							['text'] = L.CURRENT_SPEC,
							['title'] = select(2, GetSpecializationInfo(GetSpecialization())),
							['icon'] = 1495827,
							['id'] = 0,
							["description"] = L.CURRENT_SPEC_DESC,
							['visible'] = true,
							['OnClick'] = function(row, button)
								self:SetData(raidassistant);
								SetLootSpecialization(row.ref.id);
								Callback(self.Update, self);
								return true;
							end,
						});
						for i=1,numSpecializations,1 do
							local id, name, description, icon, background, role, primaryStat = GetSpecializationInfo(i);
							tinsert(data.g, {
								['text'] = name,
								['icon'] = icon,
								['id'] = id,
								["description"] = description,
								['visible'] = true,
								['OnClick'] = function(row, button)
									self:SetData(raidassistant);
									SetLootSpecialization(row.ref.id);
									Callback(self.Update, self);
									return true;
								end,
							});
						end
					end
				end,
				['visible'] = true,
				['back'] = 1,
				['g'] = {},
			};
			dungeondifficulty = {
				['text'] = L.DUNGEON_DIFF,
				['icon'] = 236530,
				["description"] = L.DUNGEON_DIFF_DESC_2,
				['OnClick'] = function(row, button)
					self:SetData(raidassistant);
					Callback(self.Update, self);
					return true;
				end,
				['visible'] = true,
				["trackable"] = false,
				['back'] = 1,
				['g'] = {
					app.CreateDifficulty(1, {
						['OnClick'] = switchDungeonDifficulty,
						["description"] = L.CLICK_TO_CHANGE,
						['visible'] = true,
						["trackable"] = false,
					}),
					app.CreateDifficulty(2, {
						['OnClick'] = switchDungeonDifficulty,
						["description"] = L.CLICK_TO_CHANGE,
						['visible'] = true,
						["trackable"] = false,
					}),
					app.CreateDifficulty(23, {
						['OnClick'] = switchDungeonDifficulty,
						["description"] = L.CLICK_TO_CHANGE,
						['visible'] = true,
						["trackable"] = false,
					})
				},
			};
			raiddifficulty = {
				['text'] = L.RAID_DIFF,
				['icon'] = 236530,
				["description"] = L.RAID_DIFF_DESC_2,
				['OnClick'] = function(row, button)
					self:SetData(raidassistant);
					Callback(self.Update, self);
					return true;
				end,
				['visible'] = true,
				["trackable"] = false,
				['back'] = 1,
				['g'] = {
					app.CreateDifficulty(14, {
						['OnClick'] = switchRaidDifficulty,
						["description"] = L.CLICK_TO_CHANGE,
						['visible'] = true,
						["trackable"] = false,
					}),
					app.CreateDifficulty(15, {
						['OnClick'] = switchRaidDifficulty,
						["description"] = L.CLICK_TO_CHANGE,
						['visible'] = true,
						["trackable"] = false,
					}),
					app.CreateDifficulty(16, {
						['OnClick'] = switchRaidDifficulty,
						["description"] = L.CLICK_TO_CHANGE,
						['visible'] = true,
						["trackable"] = false,
					})
				},
			};
			legacyraiddifficulty = {
				['text'] = L.LEGACY_RAID_DIFF,
				['icon'] = 236530,
				["description"] = L.LEGACY_RAID_DIFF_DESC_2,
				['OnClick'] = function(row, button)
					self:SetData(raidassistant);
					Callback(self.Update, self);
					return true;
				end,
				['visible'] = true,
				["trackable"] = false,
				['back'] = 1,
				['g'] = {
					app.CreateDifficulty(3, {
						['OnClick'] = switchLegacyRaidDifficulty,
						["description"] = L.CLICK_TO_CHANGE,
						['visible'] = true,
						["trackable"] = false,
					}),
					app.CreateDifficulty(5, {
						['OnClick'] = switchLegacyRaidDifficulty,
						["description"] = L.CLICK_TO_CHANGE,
						['visible'] = true,
						["trackable"] = false,
					}),
					app.CreateDifficulty(4, {
						['OnClick'] = switchLegacyRaidDifficulty,
						["description"] = L.CLICK_TO_CHANGE,
						['visible'] = true,
						["trackable"] = false,
					}),
					app.CreateDifficulty(6, {
						['OnClick'] = switchLegacyRaidDifficulty,
						["description"] = L.CLICK_TO_CHANGE,
						['visible'] = true,
						["trackable"] = false,
					}),
				},
			};
			self:SetData(raidassistant);

			-- Setup Event Handlers and register for events
			self:SetScript("OnEvent", function(self, e, ...) DelayedCallback(self.Update, 0.5, self, true); end);
			self:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED");
			self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED");
			self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
			self:RegisterEvent("CHAT_MSG_SYSTEM");
			self:RegisterEvent("SCENARIO_UPDATE");
			self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
			self:RegisterEvent("GROUP_ROSTER_UPDATE");
		end

		-- Update the window and all of its row data
		app.LegacyRaidDifficulty = GetLegacyRaidDifficultyID() or 1;
		app.DungeonDifficulty = GetDungeonDifficultyID() or 1;
		app.RaidDifficulty = GetRaidDifficultyID() or 14;
		self.Spec = GetLootSpecialization();
		if not self.Spec or self.Spec == 0 then
			local spec = GetSpecialization();
			if spec then self.Spec = GetSpecializationInfo(spec); end
		end

		-- Update the window and all of its row data
		if self.data.OnUpdate then self.data.OnUpdate(self.data); end
		for i,g in ipairs(self.data.g) do
			if g.OnUpdate then g.OnUpdate(g, self); end
		end

		-- Update the groups without forcing Debug Mode.
		local visibleState = app.Modules.Filter.Get.Visible();
		app.Modules.Filter.Set.Visible()
		self:BuildData();
		self:BaseUpdate(true);
		app.Modules.Filter.Set.Visible(visibleState)
	end
end;
customWindowUpdates.Random = function(self)
	if self:IsVisible() then
		if not self.initialized then
			self.initialized = true;
			local searchCache = {}

			local function ClearCache()
				wipe(searchCache)
			end

			-- when changing settings, we need the random cache to be cleared since it's determined based on search
			-- results with specific settings
			self:AddEventHandler("OnRecalculate_NewSettings", ClearCache)

			local function SearchRecursively(group, results, func, field)
				if group.visible and not (group.saved or group.collected) then
					if group.g then
						for i, subgroup in ipairs(group.g) do
							SearchRecursively(subgroup, field, results, func);
						end
					end
					if group[field] and (not func or func(group)) then
						results[#results + 1] = group
					end
				end
			end
			local function SearchRecursivelyForValue(group, results, func, field, value)
				if group.visible and not (group.saved or group.collected) then
					if group.g then
						for i, subgroup in ipairs(group.g) do
							SearchRecursivelyForValue(subgroup, field, value, results, func);
						end
					end
					if group[field] and group[field] == value and (not func or func(group)) then
						results[#results + 1] = group
					end
				end
			end
			local function SearchRecursivelyForEverything(group, results)
				if group.visible and not (group.saved or group.collected) then
					if group.g then
						for i, subgroup in ipairs(group.g) do
							SearchRecursivelyForEverything(subgroup, results);
						end
					end
					if group.collectible then
						results[#results + 1] = group
					end
				end
			end

			local excludedZones = {
				[12] = 1,	-- Kalimdor
				[13] = 1, -- Eastern Kingdoms
				[101] = 1,	-- Outland
				[113] = 1,	-- Northrend
				[424] = 1,	-- Pandaria
				[948] = 1,	-- The Maelstrom
				[572] = 1,	-- Draenor
				[619] = 1,	-- The Broken Isles
				[905] = 1,	-- Argus
				[876] = 1,	-- Kul'Tiras
				[875] = 1,	-- Zandalar
				[1550] = 1,	-- The Shadowlands
				[1978] = 1,	-- Dragon Isles
				[2274] = 1,	-- Khaz Algar
			};

			-- Represents how to search for a given named-Thing
			local SelectionMethods = setmetatable({
				AllTheThings = SearchRecursivelyForEverything,
			}, { __index = function() return SearchRecursively end})
			-- Named-TypeIDs for the field to Select for a given named-Thing
			local TypeIDLookups = {
				Achievement = "achievementID",
				Dungeon = "instanceID",
				Factions = "factionID",
				-- Follower = "followerID",
				Item = "itemID",
				Instance = "instanceID",
				Mount = "mountID",
				Pet = "speciesID",
				Quest = "questID",
				Raid = "instanceID",
				Titles = "titleID",
				Toy = "toyID",
				Zone = "mapID",
			}
			-- Named-Values for the value of a field in the Select
			local TypeIDValueLookups = {
			}
			local DefaultSelectionFilter = function(o) return o.collectible and not o.collected end
			-- Named-Functions (if not ignored) for whether to select data pertaining to a specific named-Thing
			local SelectionFilters = setmetatable({
				Achievement = function(o)
					return o.collectible and not o.collected and not o.mapID and not o.criteriaID;
				end,
				Dungeon = function(o)
					return not o.isRaid and (((o.total or 0) - (o.progress or 0)) > 0);
				end,
				-- Factions - default
				-- Follower - default
				-- Item - default
				Instance = function(o)
					return ((o.total or 0) - (o.progress or 0)) > 0;
				end,
				-- Mount - default
				-- Pet - default
				-- Quest - default
				Raid = function(o)
					return o.isRaid and (((o.total or 0) - (o.progress or 0)) > 0);
				end,
				-- Titles - default
				-- Toy - default
				Zone = function(o)
					return (((o.total or 0) - (o.progress or 0)) > 0) and not o.instanceID and not excludedZones[o.mapID];
				end,
			}, { __index = function() return DefaultSelectionFilter end})

			local function GetSearchResults(rootData, name)
				if searchCache[name] then return searchCache[name] end
				local searchResults = {}
				SelectionMethods[name](rootData, searchResults, SelectionFilters[name], TypeIDLookups[name], TypeIDValueLookups[name])
				if #searchResults > 0 then
					searchCache[name] = searchResults
					return searchResults
				end
			end

			local mainHeader
			local function AddRandomCategoryButton(text, icon, desc, name)
				return
				{
					["text"] = text,
					["icon"] = icon,
					["description"] = desc,
					["visible"] = true,
					["OnUpdate"] = app.AlwaysShowUpdate,
					["OnClick"] = function(row, button)
						self.RandomSearchFilter = name
						self:SetData(mainHeader)
						self:Reroll()
						return true
					end,
				}
			end

			local rerollOption = {
				['text'] = L.REROLL,
				['icon'] = app.asset("Button_Reroll"),
				['description'] = L.REROLL_DESC,
				['visible'] = true,
				['OnClick'] = function(row, button)
					self:Reroll();
					return true;
				end,
				['OnUpdate'] = app.AlwaysShowUpdate,
			};
			local filterHeader = {
				['text'] = L.APPLY_SEARCH_FILTER,
				['icon'] = app.asset("Button_Search"),
				["description"] = L.APPLY_SEARCH_FILTER_DESC,
				['visible'] = true,
				['OnUpdate'] = app.AlwaysShowUpdate,
				["indent"] = 0,
				['back'] = 1,
				['g'] = {
					setmetatable({
						['description'] = L.SEARCH_EVERYTHING_BUTTON_OF_DOOM,
						['visible'] = true,
						['OnClick'] = function(row, button)
							self.RandomSearchFilter = appName;
							self:SetData(mainHeader);
							self:Reroll();
							return true;
						end,
						['OnUpdate'] = app.AlwaysShowUpdate,
					}, { __index = function(t, key)
						if key == "text" or key == "icon" or key == "preview" or key == "texcoord" or key == "previewtexcoord" then
							return app:GetWindow("Prime").data[key];
						end
					end}),
					AddRandomCategoryButton(L.ACHIEVEMENT, app.asset("Category_Achievements"), L.ACHIEVEMENT_DESC, "Achievement"),
					AddRandomCategoryButton(L.DUNGEON, app.asset("Difficulty_Normal"), L.DUNGEON_DESC, "Dungeon"),
					AddRandomCategoryButton(L.FACTIONS, app.asset("Category_Factions"), L.FACTION_DESC, "Factions"),
					-- missing locale values
					-- AddRandomCategoryButton(app.NPCNameFromID[app.HeaderConstants.FOLLOWERS], L.HEADER_ICONS[app.HeaderConstants.FOLLOWERS], L.FOLLOWER_DESC, "Follower"),
					AddRandomCategoryButton(L.INSTANCE, app.asset("Category_D&R"), L.INSTANCE_DESC, "Instance"),
					AddRandomCategoryButton(L.ITEM, app.asset("Interface_Zone_drop"), L.ITEM_DESC, "Item"),
					AddRandomCategoryButton(L.MOUNT, app.asset("Category_Mounts"), L.MOUNT_DESC, "Mount"),
					AddRandomCategoryButton(L.PET, app.asset("Category_PetBattles"), L.PET_DESC, "Pet"),
					AddRandomCategoryButton(L.QUEST, app.asset("Interface_Quest"), L.QUEST_DESC, "Quest"),
					AddRandomCategoryButton(L.RAID, app.asset("Difficulty_Heroic"), L.RAID_DESC, "Raid"),
					AddRandomCategoryButton(L.TITLES, app.asset("Category_Titles"), L.TITLES_RAND_DESC, "Titles"),
					AddRandomCategoryButton(L.TOY, app.asset("Category_ToyBox"), L.TOY_DESC, "Toy"),
					AddRandomCategoryButton(L.ZONE, app.asset("Category_Zones"), L.ZONE_DESC, "Zone"),
				},
			};
			mainHeader = {
				['text'] = L.GO_GO_RANDOM,
				['icon'] = app.asset("WindowIcon_Random"),
				["description"] = L.GO_GO_RANDOM_DESC,
				['visible'] = true,
				['OnUpdate'] = app.AlwaysShowUpdate,
				['back'] = 1,
				["indent"] = 0,
				['options'] = {
					{
						['text'] = L.CHANGE_SEARCH_FILTER,
						['icon'] = app.asset("Button_Search"),
						["description"] = L.CHANGE_SEARCH_FILTER_DESC,
						['visible'] = true,
						['OnClick'] = function(row, button)
							self:SetData(filterHeader);
							self:Update(true);
							return true;
						end,
						['OnUpdate'] = app.AlwaysShowUpdate,
					},
					rerollOption,
				},
				['g'] = { },
			};
			self:SetData(mainHeader);
			self.Rebuild = function(self, no)
				-- Rebuild all the datas
				wipe(self.data.g);

				local primeWindow = app:GetWindow("Prime")
				local primePending = primeWindow.HasPendingUpdate

				-- Call to our method and build a list to draw from if Prime has been opened
				if not primePending then
					local method = self.RandomSearchFilter or appName;
					rerollOption.text = L.REROLL_2 .. (method ~= appName and L[method:upper()] or method);
					local temp = GetSearchResults(primeWindow.data, method) or app.EmptyTable;
					local totalWeight = 0;
					for i,o in ipairs(temp) do
						totalWeight = totalWeight + ((o.total or 1) - (o.progress or 0));
					end
					-- app.PrintDebug("#random",temp and #temp,totalWeight)
					if totalWeight > 0 and #temp > 0 then
						local weight, selected = math.random(totalWeight), nil;
						totalWeight = 0;
						for i,o in ipairs(temp) do
							totalWeight = totalWeight + ((o.total or 1) - (o.progress or 0));
							if weight <= totalWeight then
								selected = o;
								break;
							end
						end
						-- app.PrintDebug("select",weight,selected and (selected.text or selected.hash))
						if not selected then selected = temp[#temp - 1]; end
						if selected then
							NestObject(self.data, selected, true);
						else
							app.print(L.NOTHING_TO_SELECT_FROM);
						end
					else
						app.print(L.NOTHING_TO_SELECT_FROM);
					end
				else
					rerollOption.text = "Please open /att"
					app.print(L.NOTHING_TO_SELECT_FROM);
				end
				for i=#self.data.options,1,-1 do
					tinsert(self.data.g, 1, self.data.options[i]);
				end
				AssignChildren(self.data);
				if not no then self:Update(); end
			end
			self.Reroll = function(self)
				Push(self, "Rebuild", self.Rebuild);
			end
			for i,o in ipairs(self.data.options) do
				tinsert(self.data.g, o);
			end
			local method = self.RandomSearchFilter or appName;
			rerollOption.text = L.REROLL_2 .. (method ~= appName and L[method:upper()] or method);
		end

		-- Update the window and all of its row data
		self.data.progress = 0;
		self.data.total = 0;
		self.data.indent = 0;
		AssignChildren(self.data);
		self:BaseUpdate(true);
	end
end;
customWindowUpdates.RWP = function(self, force)
	if not self.initialized then
		if not app:GetDataCache() then	-- This module requires a valid data cache to function correctly.
			return;
		end
		self.initialized = true;
		self:SetData({
			["text"] = L.FUTURE_UNOBTAINABLE,
			["icon"] = app.asset("WindowIcon_RWP"),
			["description"] = L.FUTURE_UNOBTAINABLE_TOOLTIP,
			["visible"] = true,
			["back"] = 1,
			["g"] = app:BuildSearchResponse("rwp"),
		});
		self:BuildData();
		self.ExpandInfo = { Expand = true, Manual = true };
	end
	if self:IsVisible() then
		self:BaseUpdate(force);
	end
end;
customWindowUpdates.Sync = function(self)
	if self:IsVisible() then
		if not self.initialized then
			self.initialized = true;

			local function OnRightButtonDeleteCharacter(row, button)
				if button == "RightButton" then
					app:ShowPopupDialog("CHARACTER DATA: " .. (row.ref.text or RETRIEVING_DATA) .. L.CONFIRM_DELETE,
					function()
						ATTCharacterData[row.ref.datalink] = nil;
						app:RecalculateAccountWideData();
						self:Reset();
					end);
				end
				return true;
			end
			local function OnRightButtonDeleteLinkedAccount(row, button)
				if button == "RightButton" then
					app:ShowPopupDialog("LINKED ACCOUNT: " .. (row.ref.text or RETRIEVING_DATA) .. L.CONFIRM_DELETE,
					function()
						AllTheThingsAD.LinkedAccounts[row.ref.datalink] = nil;
						app:SynchronizeWithPlayer(row.ref.datalink);
						self:Reset();
					end);
				end
				return true;
			end
			local function OnTooltipForCharacter(t, tooltipInfo)
				local character = ATTCharacterData[t.unit];
				if character then
					-- last login info
					local login = character.lastPlayed;
					if login then
						local d = C_DateAndTime.GetCalendarTimeFromEpoch(login * 1e6);
						tinsert(tooltipInfo, {
							left = PLAYED,
							right = ("%d-%02d-%02d %02d:%02d"):format(d.year, d.month, d.monthDay, d.hour, d.minute),
							r = 0.8, g = 0.8, b = 0.8
						});
					else
						tinsert(tooltipInfo, {
							left = PLAYED,
							right = NEVER,
							r = 0.8, g = 0.8, b = 0.8
						});
					end
					local total = 0;
					for i,field in ipairs(app.CharacterSyncTables) do
						local values = character[field];
						if values then
							local subtotal = 0;
							for key,value in pairs(values) do
								if value then
									subtotal = subtotal + 1;
								end
							end
							total = total + subtotal;
							tinsert(tooltipInfo, {
								left = field,
								right = tostring(subtotal),
								r = 1, g = 1, b = 1
							});
						end
					end
					tinsert(tooltipInfo, { left = " " });
					tinsert(tooltipInfo, {
						left = "Total",
						right = tostring(total),
						r = 0.8, g = 0.8, b = 1
					});
					tinsert(tooltipInfo, {
						left = L.DELETE_CHARACTER,
						r = 1, g = 0.8, b = 0.8
					});
				end
			end
			local function OnTooltipForLinkedAccount(t, tooltipInfo)
				if t.unit then
					tinsert(tooltipInfo, {
						left = L.LINKED_ACCOUNT_TOOLTIP,
						r = 0.8, g = 0.8, b = 1, wrap = true,
					});
					tinsert(tooltipInfo, {
						left = L.DELETE_LINKED_CHARACTER,
						r = 1, g = 0.8, b = 0.8
					});
				else
					tinsert(tooltipInfo, {
						left = L.DELETE_LINKED_ACCOUNT,
						r = 1, g = 0.8, b = 0.8
					});
				end
			end

			local syncHeader = {
				['text'] = L.ACCOUNT_MANAGEMENT,
				['icon'] = app.asset("WindowIcon_AccountManagement"),
				["description"] = L.ACCOUNT_MANAGEMENT_TOOLTIP,
				['visible'] = true,
				['back'] = 1,
				['OnUpdate'] = app.AlwaysShowUpdate,
				OnClick = app.UI.OnClick.IgnoreRightClick,
				['g'] = {
					{
						['text'] = L.ADD_LINKED_CHARACTER_ACCOUNT,
						['icon'] = app.asset("Button_Add"),
						['description'] = L.ADD_LINKED_CHARACTER_ACCOUNT_TOOLTIP,
						['visible'] = true,
						['OnUpdate'] = app.AlwaysShowUpdate,
						['OnClick'] = function(row, button)
							app:ShowPopupDialogWithEditBox(L.ADD_LINKED_POPUP, "", function(cmd)
								if cmd and cmd ~= "" then
									AllTheThingsAD.LinkedAccounts[cmd] = true;
									self:Reset();
								end
							end);
							return true;
						end,
					},
					-- Characters Section
					{
						['text'] = L.CHARACTERS,
						['icon'] = 526421,
						["description"] = L.SYNC_CHARACTERS_TOOLTIP,
						['visible'] = true,
						['expanded'] = true,
						['g'] = {},
						OnClick = app.UI.OnClick.IgnoreRightClick,
						['OnUpdate'] = function(data)
							local g = {};
							for guid,character in pairs(ATTCharacterData) do
								if character then
									tinsert(g, app.CreateUnit(guid, {
										['datalink'] = guid,
										['OnClick'] = OnRightButtonDeleteCharacter,
										['OnTooltip'] = OnTooltipForCharacter,
										["OnUpdate"] = app.AlwaysShowUpdate,
										name = character.name,
										lvl = character.lvl,
										['visible'] = true,
									}));
								end
							end

							if #g < 1 then
								tinsert(g, {
									['text'] = L.NO_CHARACTERS_FOUND,
									['icon'] = 526421,
									['visible'] = true,
									OnClick = app.UI.OnClick.IgnoreRightClick,
									["OnUpdate"] = app.AlwaysShowUpdate,
								});
							else
								data.SortType = "textAndLvl";
							end
							data.g = g;
							AssignChildren(data);
							return true;
						end,
					},

					-- Linked Accounts Section
					{
						['text'] = L.LINKED_ACCOUNTS,
						['icon'] = 526421,
						["description"] = L.LINKED_ACCOUNTS_TOOLTIP,
						['visible'] = true,
						['g'] = {},
						OnClick = app.UI.OnClick.IgnoreRightClick,
						['OnUpdate'] = function(data)
							data.g = {};
							local charactersByName = {};
							for guid,character in pairs(ATTCharacterData) do
								if character.name then
									charactersByName[character.name] = character;
								end
							end

							for playerName,allowed in pairs(AllTheThingsAD.LinkedAccounts) do
								local character = charactersByName[playerName];
								if character then
									tinsert(data.g, app.CreateUnit(playerName, {
										['datalink'] = playerName,
										['OnClick'] = OnRightButtonDeleteLinkedAccount,
										['OnTooltip'] = OnTooltipForLinkedAccount,
										["OnUpdate"] = app.AlwaysShowUpdate,
										['visible'] = true,
									}));
								elseif playerName:find("#") then
									-- Garbage click handler for unsync'd account data.
									tinsert(data.g, {
										['text'] = playerName,
										['datalink'] = playerName,
										['icon'] = 526421,
										['OnClick'] = OnRightButtonDeleteLinkedAccount,
										['OnTooltip'] = OnTooltipForLinkedAccount,
										['OnUpdate'] = app.AlwaysShowUpdate,
										['visible'] = true,
									});
								else
									-- Garbage click handler for unsync'd character data.
									tinsert(data.g, {
										['text'] = playerName,
										['datalink'] = playerName,
										['icon'] = 374212,
										['OnClick'] = OnRightButtonDeleteLinkedAccount,
										['OnTooltip'] = OnTooltipForLinkedAccount,
										['OnUpdate'] = app.AlwaysShowUpdate,
										['visible'] = true,
									});
								end
							end

							if #data.g < 1 then
								tinsert(data.g, {
									['text'] = L.NO_LINKED_ACCOUNTS,
									['icon'] = 526421,
									['visible'] = true,
									OnClick = app.UI.OnClick.IgnoreRightClick,
									["OnUpdate"] = app.AlwaysShowUpdate,
								});
							end
							AssignChildren(data);
							return true;
						end,
					},
				}
			};

			self.Reset = function()
				self:SetData(syncHeader);
				self:Update(true);
			end
			self:Reset();
		end

		-- Update the groups without forcing Debug Mode.
		if self.data.OnUpdate then self.data.OnUpdate(self.data, self); end
		self:BuildData();
		for i,g in ipairs(self.data.g) do
			if g.OnUpdate then g.OnUpdate(g, self); end
		end
		self:BaseUpdate(true);
	end
end;

-- Returns an Object based on a QuestID a lot of Quest information for displaying in a row
---@return table?
local function GetPopulatedQuestObject(questID)
	-- cannot do anything on a missing object or questID
	if not questID then return; end
	-- either want to duplicate the existing data for this quest, or create new data for a missing quest
	local questObject = CreateObject(SearchForObject("questID", questID, "field") or { questID = questID, _missing = true }, true);
	-- if questID == 78663 then
	-- 	local debug = app.Debugging
	-- 	app.Debugging = true
	-- 	app.PrintTable(questObject)
	-- 	app.Debugging = debug
	-- end
	-- Try populating quest rewards
	app.TryPopulateQuestRewards(questObject);
	return questObject;
end
customWindowUpdates.list = function(self, force, got)
	if not self.initialized then
		self.VerifyGroupSourceID = function(data)
			-- can only determine a sourceID if there is an itemID/sourceID on the group
			if not data.itemID and not data.sourceID then return true end
			if not data._VerifyGroupSourceID then data._VerifyGroupSourceID = 0 end
			if data._VerifyGroupSourceID > 5 then
				-- app.PrintDebug("Cannot Harvest: No Item Info",
				-- 	app:SearchLink(SearchForObject("itemID",data.modItemID,"field") or SearchForObject("sourceID",data.sourceID,"field")),
				-- 	data._VerifyGroupSourceID)
				return true
			end
			data._VerifyGroupSourceID = data._VerifyGroupSourceID + 1
			local link, source = data.link or data.silentLink, data.sourceID;
			if not link then return; end
			-- If it doesn't, the source ID will need to be harvested.
			local sourceID = app.GetSourceID(link);
			-- app.PrintDebug("SourceIDs",data.modItemID,source,app.GetSourceID(link),link)
			if sourceID and sourceID > 0 then
				-- only save the source if it is different than what we already have, or being forced
				if not source or source < 1 or source ~= sourceID then
					-- print(GetItemInfo(text))
					if not source then
						-- app.print("SourceID Update",link,data.modItemID,source,"=>",sourceID);
						data.sourceID = sourceID
						app.SaveHarvestSource(data)
					else
						app.print("SourceID Diff!",link,source,"=>",sourceID)
						-- replace the item information of the root Item (this affects the Main list)
						-- since the inherent item information does not match the SourceID any longer
						local mt = getmetatable(data)
						if mt then
							local rootData = mt.__index
							if rootData then
								rootData.rawlink = nil
								rootData.itemID = nil
								rootData.modItemID = nil
							end
						end
					end
				end
			end
			return true
		end
		self.RemoveSelf = function(o)
			local parent = rawget(o, "parent");
			if not parent then
				app.PrintDebug("no parent?",o.text)
				return;
			end
			local og = parent.g;
			if not og then
				app.PrintDebug("no g?",parent.text)
				return;
			end
			local i = indexOf(og, o) or (o.__dlo and indexOf(og, o.__dlo));
			if i and i > 0 then
				-- app.PrintDebug("RemoveSelf",#og,i,o.text)
				tremove(og, i);
				-- app.PrintDebug("RemoveSelf",#og)
			end
			return og;
		end
		self.AutoHarvestFirstPartitionCoroutine = function()
			-- app.PrintDebug("AutoExpandingPartitions")
			local i = 10;
			-- yield a few frames to allow the list to fully generate
			while i > 0 do
				coroutine.yield();
				i = i - 1;
			end

			local partitions = self.data.g;
			if not partitions then return; end

			local part;
			-- app.PrintDebug("AutoExpandingPartitions",#partitions)
			while #partitions > 0 do
				part = partitions[1];
				if not part.expanded then
					part.expanded = true;
					-- app.PrintDebug("AutoExpand",part.text)
					app.DirectGroupRefresh(part);
				end
				coroutine.yield();
				-- Make sure the coroutine stops running if we close the list window
				if not self:IsVisible() then return; end
			end
		end

		-- temporarily prevent a force refresh from exploding the game if this window is open
		self.doesOwnUpdate = true;
		self.initialized = true;
		force = true;
		local DGU, DGR = app.DirectGroupUpdate, app.DirectGroupRefresh;

		-- custom params for initialization
		local dataType = (app.GetCustomWindowParam("list", "type") or "quest");
		local onlyMissing = app.GetCustomWindowParam("list", "missing");
		local onlyCached = app.GetCustomWindowParam("list", "cached");
		local onlyCollected = app.GetCustomWindowParam("list", "collected");
		local harvesting = app.GetCustomWindowParam("list", "harvesting");
		self.PartitionSize = tonumber(app.GetCustomWindowParam("list", "part")) or 1000;
		self.Limit = tonumber(app.GetCustomWindowParam("list", "limit")) or 1000;
		local min = tonumber(app.GetCustomWindowParam("list", "min")) or 0
		-- print("Quests - onlyMissing",onlyMissing)
		local CacheFields, ItemHarvester;

		-- manual type adjustments to match internal use (due to lowercase keys with non-lowercase cache keys >_<)
		if dataType == "s" or dataType == "source" then
			dataType = "source";
		elseif dataType == "achievementcategory" then
			dataType = "achievementCategory";
		elseif dataType == "azeriteessence" then
			dataType = "azeriteEssence";
		elseif dataType == "flightpath" then
			dataType = "flightPath";
		elseif dataType == "runeforgepower" then
			dataType = "runeforgePower";
		elseif dataType == "itemharvester" then
			if not app.CreateItemHarvester then
				app.print("'itemharvester' Requires 'Debugging' enabled when loading the game!")
				return
			end
			ItemHarvester = app.CreateItemHarvester;
		elseif dataType:find("cache") then
			-- special data type to utilize an ATT cache instead of generating raw groups
			-- "cache:item"
			-- => itemID
			-- fill all items from itemID cache into list, sorted by itemID
			local added = {};
			CacheFields = {};
			local cacheID;
			local _, cacheKey = (":"):split(dataType);
			local cacheKeyID = cacheKey.."ID";
			local imin, imax = 0, 999999
			-- convert the list min/max into cache-based min/max for cache lists
			if self.Limit ~= 1000 then
				imax = self.Limit + 1;
				self.Limit = 999999
			end
			if min ~= 0 then
				imin = min;
				min = 0;
			end
			dataType = cacheKey;
			-- collect valid id values
			for id,groups in pairs(app.GetRawFieldContainer(cacheKey) or app.GetRawFieldContainer(cacheKeyID) or app.EmptyTable) do
				for index,o in ipairs(groups) do
					cacheID = tonumber(o.modItemID or o[dataType] or o[cacheKeyID]) or 0;
					if imin <= cacheID and cacheID <= imax then
						added[cacheID] = true;
						-- app.PrintDebug("CacheID",cacheID,"from cache",id,"@",index,#groups)
						-- app.PrintDebug(o.modItemID,o[dataType],o[cacheKeyID])
					-- else app.PrintDebug("Ignored Data for Harvest due to CacheID Bounds",cacheID,app:SearchLink(o))
					end
				end
			end
			for id,_ in pairs(added) do
				CacheFields[#CacheFields + 1] = id
			end
			app.Sort(CacheFields, app.SortDefaults.Values);
			app.PrintDebug(#CacheFields,"CacheFields:Sorted",CacheFields[1],"->",CacheFields[#CacheFields])
		end

		-- add the ID
		dataType = dataType.."ID";

		local ForceVisibleFields = {
			visible = true,
			total = 0,
			progress = 0,
		};
		local PartitionUpdateFields = {
			total = true,
			progress = true,
			parent = true,
			expanded = true,
			window = true
		};
		local PartitionMeta = {
			__index = ForceVisibleFields,
			__newindex = function(t, key, val)
				-- only allow changing existing table fields
				if PartitionUpdateFields[key] then
					rawset(t, key, val);
					-- app.PrintDebug("__newindex:part",key,val)
				end
			end
		};

		local ObjectTypeFuncs = {
			questID = GetPopulatedQuestObject,
		};
		if CacheFields then
			-- app.PrintDebug("OTF:Define",dataType)
			ObjectTypeFuncs[dataType] = function(id)
				-- use the cached id in the slot of the requested id instead
				-- app.PrintDebug("OTF",id)
				id = CacheFields[id];
				-- app.PrintDebug("OTF:CacheID",dataType,id)
				return setmetatable({ visible = true }, {
					__index = id and (SearchForObject(dataType, id, "key")
									or SearchForObject(dataType, id, "field")
									or CreateObject({[dataType]=id}))
								or setmetatable({name=EMPTY}, app.BaseClass)
				});
			end
			-- app.PrintDebug("SetLimit",#CacheFields)
			self.Limit = #CacheFields;
		end
		if ItemHarvester then
			ObjectTypeFuncs[dataType] = ItemHarvester;
		end
		local function CreateTypeObject(type, id)
			-- app.PrintDebug("DLO-Obj:",type,id)
			local func = ObjectTypeFuncs[type];
			if func then return func(id); end
			-- Simply a visible table whose Base will be the actual referenced object
			return setmetatable({ visible = true }, {
				__index = SearchForObject(dataType, id, "key")
					or SearchForObject(type, id, "field")
					or CreateObject({[type]=id})
			});
		end

		-- info about the Window
		local g = {};
		self:SetData(setmetatable({
			text = "Full Data List - "..(dataType or "None"),
			icon = app.asset("Interface_Quest_header"),
			description = "1 - "..self.Limit,
			g = g,
		}, PartitionMeta));

		local overrides = {
			visible = not harvesting and true or nil,
			indent = 2,
			collectibleAsCost = false,
			costCollectibles = false,
			g = false,
			back = function(o, key)
				return o._missing and 1 or 0;
			end,
			text = harvesting and function(o, key)
				local text = o.text;
				if not IsRetrieving(text) then
					DGR(o);
					if not self.VerifyGroupSourceID(o) then
						return "Harvesting..."
					end
					local og = self.RemoveSelf(o);
					-- app.PrintDebug(#og,"-",text)
					if #og <= 0 then
						self.RemoveSelf(o.parent);
					else
						o.visible = true;
					end
					return text;
				end
			end
			or function(o, key)
				local text = o.text;
				if not IsRetrieving(text) then
					if not self.VerifyGroupSourceID(o) then
						DGR(o);
						return "Harvesting..."
					end
					return "#"..(o[dataType] or o.keyval or "?")..": "..text;
				end
			end,
			OnLoad = function(o)
				-- app.PrintDebug("DGU-OnLoad:",o.hash)
				DGU(o);
			end,
		};
		if onlyMissing then
			app.SetDGUDelay(0);
			if onlyCached then
				overrides.visible = function(o, key)
					if o._missing then
						local text = o.text;
						-- app.PrintDebug("check",text)
						return IsRetrieving(text) or
							(not text:find("#") and text ~= UNKNOWN and not text:find("transmogappearance:"));
					end
				end
			else
				overrides.visible = function(o, key)
					return o._missing;
				end
			end
		end
		if onlyCollected then
			app.SetDGUDelay(0);
			if onlyMissing then
				overrides.visible = function(o, key)
					if o._missing and o.collected then
						return o.collected;
					end
				end
			else
				overrides.visible = function(o, key)
					return o.collected;
				end
			end
		end
		if harvesting then
			app.SetDGUDelay(0);
			StartCoroutine("AutoHarvestFirstPartitionCoroutine", self.AutoHarvestFirstPartitionCoroutine);
		end
		-- add a bunch of raw, delay-loaded objects in order into the window
		local groupCount = math_floor(self.Limit / self.PartitionSize);
		local groupStart = math_floor(min / self.PartitionSize);
		local partition, partitionStart, partitionGroups;
		local dlo = app.DelayLoadedObject;
		for j=groupStart,groupCount,1 do
			partitionStart = j * self.PartitionSize;
			partitionGroups = {};
			-- define a sub-group for a range of things
			partition = setmetatable({
				text = tostring(partitionStart + 1).."+",
				icon = app.asset("Interface_Quest_header"),
				g = partitionGroups,
			}, PartitionMeta);
			for i=1,self.PartitionSize,1 do
				tinsert(partitionGroups, dlo(CreateTypeObject, "text", overrides, dataType, partitionStart + i));
			end
			tinsert(g, partition);
		end
		self:BuildData();
	end
	if self:IsVisible() then
		-- requires Visibility filter to check .visibile for display of the group
		local filterVisible = app.Modules.Filter.Get.Visible();
		app.Modules.Filter.Set.Visible(true);
		self:BaseUpdate(force);
		app.Modules.Filter.Set.Visible(filterVisible);
	end
end
customWindowUpdates.Tradeskills = function(self, force, got)
	if not app:GetDataCache() then	-- This module requires a valid data cache to function correctly.
		return;
	end
	if not self.initialized then
		self.initialized = true;
		self.SkillsInit = {};
		self.force = true;
		self:SetMovable(false);
		self:SetUserPlaced(false);
		self:SetClampedToScreen(false);
		self:RegisterEvent("TRADE_SKILL_SHOW");
		self:RegisterEvent("TRADE_SKILL_LIST_UPDATE");
		self:RegisterEvent("TRADE_SKILL_CLOSE");
		self:RegisterEvent("GARRISON_TRADESKILL_NPC_CLOSED");
		self:SetData({
			['text'] = L.PROFESSION_LIST,
			['icon'] = 134940,
			["description"] = L.PROFESSION_LIST_DESC,
			['visible'] = true,
			["indent"] = 0,
			['back'] = 1,
			['g'] = { },
		});

		local MissingRecipes = {}
		-- Adds the pertinent information about a given recipeID to the reagentcache
		local function CacheRecipeSchematic(recipeID)
			local schematic = C_TradeSkillUI_GetRecipeSchematic(recipeID, false);
			local craftedItemID = schematic.outputItemID;
			if not craftedItemID then return end
			local cachedRecipe = SearchForObject("recipeID",recipeID,"key")
			local recipeInfo = C_TradeSkillUI_GetRecipeInfo(recipeID)
			if not cachedRecipe then
				local tradeSkillID, skillLineName, parentTradeSkillID = C_TradeSkillUI_GetTradeSkillLineForRecipe(recipeID)
				local missing = app.TableConcat({"Missing Recipe:",recipeID,skillLineName,tradeSkillID,"=>",parentTradeSkillID}, nil, nil, " ")
				-- app.PrintDebug(missing)
				MissingRecipes[#MissingRecipes + 1] = missing
			elseif cachedRecipe.u == app.PhaseConstants.NEVER_IMPLEMENTED then
				-- learned NYI recipe?
				if recipeInfo and recipeInfo.learned then
					-- known NYI recipes
					app.PrintDebug("Learned NYI Recipe",app:SearchLink(cachedRecipe))
				else
					-- don't cache reagents for unknown NYI recipes
					-- app.PrintDebug("Skip NYI Recipe",app:SearchLink(cachedRecipe))
					return
				end
			end

			local reagentCache = app.ReagentsDB
			local itemRecipes, reagentCount, reagentItemID;

			-- handle other types of recipes maybe
			if recipeInfo then
				if recipeInfo.craftable then
					-- Salvage Recipe harvest
					if recipeInfo.isSalvageRecipe then
						-- craftedItemID from salvage...
						-- in some cases this is the 'actual' ouput of the salvage (TWW Cooking)
						-- but in many other cases this is a 'fake item' representing 'multiple possible item outputs'
						-- theoretically we could list this 'fake item' under Profession > Crafted > with all possible outputs
						-- to allow driving crafting chains

						-- Not really a great way to utilize this output currently, since typically the input drives the output through
						-- the same Recipe, and it can be variable depending on skill or reagent qualities
						-- local salvageItems = C_TradeSkillUI_GetSalvagableItemIDs(recipeID)
						-- for _,salvageItemID in ipairs(salvageItems) do
						-- 	reagentItemID = salvageItemID
						-- 	-- only requirement is Reagent -> Recipe -> Crafted | Reagent Count
						-- 	-- Minimum Structure
						-- 	-- reagentCache[reagentItemID][<recipeID>] = { craftedItemID, reagentCount }
						-- 	if reagentItemID then
						-- 		itemRecipes = reagentCache[reagentItemID];
						-- 		if not itemRecipes then
						-- 			itemRecipes = { };
						-- 			reagentCache[reagentItemID] = itemRecipes;
						-- 		end
						-- 		-- app.PrintDebug("Reagent",reagentItemID,"x 5 =>",craftedItemID,"via",app:SearchLink(cachedRecipe))
						-- 		-- Salvage recipes are always '5' per
						-- 		itemRecipes[recipeID] = { craftedItemID, 5 };
						-- 	end
						-- end
						return
					end
				end
			end
			-- app.PrintDebug("Recipe",recipeID,"==>",craftedItemID)
			-- Recipes now have Slots for available Regeants...
			if #schematic.reagentSlotSchematics == 0 and schematic.hasCraftingOperationInfo then
				-- Milling Recipes...
				app.PrintDebug("EMPTY SCHEMATICS",app:SearchLink(cachedRecipe or CreateObject({recipeID=recipeID})))
				return;
			end

			-- Typical Recipe harvest
			for _,reagentSlot in ipairs(schematic.reagentSlotSchematics) do
				-- reagentType: 0 = sparks?, 1 = required, 2 = optional
				if reagentSlot.required then
					reagentCount = reagentSlot.quantityRequired;
					-- Each available Reagent for the Slot can be associated to the Recipe/Output Item
					for _,reagentSlotSchematic in ipairs(reagentSlot.reagents) do
						reagentItemID = reagentSlotSchematic.itemID;
						-- only requirement is Reagent -> Recipe -> Crafted | Reagent Count
						-- Minimum Structure
						-- reagentCache[reagentItemID][<recipeID>] = { craftedItemID, reagentCount }
						if reagentItemID then
							itemRecipes = reagentCache[reagentItemID];
							if not itemRecipes then
								itemRecipes = { };
								reagentCache[reagentItemID] = itemRecipes;
							end
							-- app.PrintDebug("Reagent",reagentItemID,"x",reagentCount,"=>",craftedItemID,"via",recipeID)
							itemRecipes[recipeID] = { craftedItemID, reagentCount };
						end
					end
				end
			end
		end
		app.HarvestRecipes = function()
			local reagentsDB = LocalizeGlobal("AllTheThingsHarvestItems", true)
			reagentsDB.ReagentsDB = app.ReagentsDB
			local Runner = self:GetRunner()
			Runner.SetPerFrame(100);
			local Run = Runner.Run;
			for spellID,data in pairs(SearchForFieldContainer("spellID")) do
				Run(CacheRecipeSchematic, spellID);
			end
			Runner.OnEnd(function()
				app.print("Harvested all Sourced Recipes & Reagents => [Reagents]")
			end);
		end
		local function UpdateLocalizedCategories(self, updates)
			if not updates.Categories then
				-- app.PrintDebug("UpdateLocalizedCategories",self.lastTradeSkillID)
				local categories = AllTheThingsAD.LocalizedCategoryNames;
				updates.Categories = true;
				local currentCategoryID;
				local categoryData = {};
				local categoryIDs = { C_TradeSkillUI_GetCategories() };
				for i = 1,#categoryIDs do
					currentCategoryID = categoryIDs[i];
					if not categories[currentCategoryID] then
						C_TradeSkillUI_GetCategoryInfo(currentCategoryID, categoryData);
						if categoryData.name then
							categories[currentCategoryID] = categoryData.name;
						end
					end
				end
			end
		end
		local function UpdateLearnedRecipes(self, updates)
			-- Cache learned recipes
			if not updates.Recipes then
				-- app.PrintDebug("UpdateLearnedRecipes",self.lastTradeSkillID)
				if app.Debugging then
					local reagentsDB = LocalizeGlobal("AllTheThingsHarvestItems", true)
					reagentsDB.ReagentsDB = app.ReagentsDB
				end
				updates.Recipes = true;
				wipe(MissingRecipes)
				local categoryData = {};
				local learned, recipeID = {}, nil;
				local recipeIDs = C_TradeSkillUI.GetAllRecipeIDs();
				local acctSpells, charSpells = ATTAccountWideData.Spells, app.CurrentCharacter.Spells;
				local spellRecipeInfo, currentCategoryID;
				local categories = AllTheThingsAD.LocalizedCategoryNames;
				-- app.PrintDebug("Scanning recipes",#recipeIDs)
				for i = 1,#recipeIDs do
					spellRecipeInfo = C_TradeSkillUI_GetRecipeInfo(recipeIDs[i]);
					-- app.PrintDebug("Recipe",recipeIDs[i])
					if spellRecipeInfo then
						recipeID = spellRecipeInfo.recipeID;
						local cachedRecipe = SearchForObject("recipeID",recipeID,"key")
						currentCategoryID = spellRecipeInfo.categoryID;
						if not categories[currentCategoryID] then
							C_TradeSkillUI_GetCategoryInfo(currentCategoryID, categoryData);
							if categoryData.name then
								categories[currentCategoryID] = categoryData.name;
							end
						end
						-- recipe is learned, so cache that it's learned regardless of being craftable
						if spellRecipeInfo.learned then
							-- Shadowlands recipes are weird...
							local rank = spellRecipeInfo.unlockedRecipeLevel or 0;
							if rank > 0 then
								-- when the recipeID specifically is available, it will show as available for ALL possible ranks
								-- so we can check if the next known rank is also considered available for this recipeID
								spellRecipeInfo = C_TradeSkillUI_GetRecipeInfo(recipeID, rank + 1);
								-- app.PrintDebug("NextRankCheck",recipeID,rank + 1, spellRecipeInfo.learned)
							end
						end
						-- recipe is learned, so cache that it's learned regardless of being craftable
						if spellRecipeInfo and spellRecipeInfo.learned then
							-- only disabled & enable-type recipes should be un-cached when considered learned
							if spellRecipeInfo.disabled and cachedRecipe and cachedRecipe.isEnableTypeRecipe then
								-- disabled learned enable-type recipes shouldn't be marked as known by the character (they require an 'unlock' typically to become usable)
								if charSpells[recipeID] then
									charSpells[recipeID] = nil;
									-- local link = app:Linkify(recipeID, app.Colors.ChatLink, "search:recipeID:"..recipeID);
									-- app.PrintDebug("Unlearned Disabled Recipe", link);
								end
							else
								charSpells[recipeID] = 1;
								if not acctSpells[recipeID] then
									acctSpells[recipeID] = 1;
									tinsert(learned, recipeID);
								end
							end
						else
							if spellRecipeInfo.disabled then
								-- disabled & unlearned recipes shouldn't be marked as known by the character
								if charSpells[recipeID] then
									charSpells[recipeID] = nil;
									-- local link = app:Linkify(recipeID, app.Colors.ChatLink, "search:spellID:"..recipeID);
									-- app.PrintDebug("Unlearned Disabled Recipe", link);
								end
							else
								-- ignore removal of enable-type recipes when considered unlearned and not disabled
								if cachedRecipe and cachedRecipe.isEnableTypeRecipe then
									-- local link = app:Linkify(recipeID, app.Colors.ChatLink, "search:recipeID:"..recipeID);
									-- app.PrintDebug("Unlearned Enable-Type Recipe", link);
								else
									-- non-disabled, unlearned recipes shouldn't be marked as known by the character
									if charSpells[recipeID] then
										charSpells[recipeID] = nil;
										-- local link = app:Linkify(recipeID, app.Colors.ChatLink, "search:spellID:"..recipeID);
										-- app.PrintDebug("Unlearned Recipe", link);
									end
								end
							end
						end

						-- moved to stand-alone on-demand function across all known professions, or called if DEBUG_PRINT is enabled to harvest un-sourced recipes
						if app.Debugging then
							CacheRecipeSchematic(recipeID);
						end
					end
				end
				-- If something new was "learned", then refresh the data.
				-- app.PrintDebug("Done. learned",#learned)
				app.UpdateRawIDs("spellID", learned);
				if #learned > 0 then
					app.HandleEvent("OnThingCollected", "Recipes")
					self.force = true;
				end
				-- In Debugging, pop a dialog of all found missing recipes
				if app.Debugging then
					if #MissingRecipes > 0 then
						app:ShowPopupDialogWithMultiLineEditBox(app.TableConcat(MissingRecipes, nil, nil, "\n"), nil, "Missing Recipes")
					else
						app.PrintDebug("No Missing Recipes!")
					end
				end
			end
		end
		-- Custom SearchValueCriteria for requireSkill searches
		local criteria = {
			SearchValueCriteria = {
				-- Include if the field of the group matches the desired value (or via translated requireSkill value matches)
				-- and if it filters for the current character
				function(o, field, value)
					local v = o[field]
					return v and (v == value or app.SkillDB.SpellToSkill[app.SpecializationSpellIDs[v] or 0] == value)
						and app.CurrentCharacterFilters(o)
				end
			}
		}
		local function UpdateData(self, updates)
			-- Open the Tradeskill list for this Profession
			local data = updates.Data;
			if not data then
				-- app.PrintDebug("UpdateData",self.lastTradeSkillID)
				data = app.CreateProfession(self.lastTradeSkillID);
				app.BuildSearchResponse_IgnoreUnavailableRecipes = true;
				NestObjects(data, app:BuildSearchResponse("requireSkill", data.requireSkill, nil, criteria));
				-- Profession headers use 'professionID' and don't actually convey a requirement on knowing the skill
				-- but in a Profession window for that skill it's nice to see what that skill can craft...
				NestObjects(data, app:BuildSearchResponse("professionID", data.requireSkill));
				app.BuildSearchResponse_IgnoreUnavailableRecipes = nil;
				data.indent = 0;
				data.visible = true;
				AssignChildren(data);
				updates.Data = data;
				-- only expand the list if this is the first time it is being generated
				self.ExpandInfo = { Expand = true };
				self.force = true;
			end
			self:SetData(data);
			self:Update(self.force);
		end
		-- Can trigger multiple times quickly, but will only run once per profession in a row
		self.RefreshRecipes = function(self, doUpdate)
			-- If it's not yours, don't take credit for it.
			if C_TradeSkillUI.IsTradeSkillLinked() or C_TradeSkillUI.IsTradeSkillGuild() then return; end

			if app.Settings.Collectibles.Recipes then
				-- app.PrintDebug("RefreshRecipes")
				-- Cache Learned Spells
				local skillCache = app.GetRawFieldContainer("spellID");
				if not skillCache then return; end

				local tradeSkillID = app.GetTradeSkillLine();
				self.lastTradeSkillID = tradeSkillID;
				local updates = self.SkillsInit[tradeSkillID] or {};
				self.SkillsInit[tradeSkillID] = updates;

				if doUpdate then
					-- allow re-scanning learned Recipes
					-- app.PrintDebug("Allow Rescan of Recipes")
					updates.Recipes = nil;
				end

				local Runner = self:GetRunner()
				Runner.Run(UpdateLocalizedCategories, self, updates);
				Runner.Run(UpdateLearnedRecipes, self, updates);
				Runner.Run(UpdateData, self, updates);
			end
		end

		-- TSM Shenanigans
		self.TSMCraftingVisible = nil;
		self.SetTSMCraftingVisible = function(self, visible)
			visible = not not visible;
			if visible == self.TSMCraftingVisible then
				return;
			end
			self.TSMCraftingVisible = visible;
			self:SetMovable(true);
			self:ClearAllPoints();
			if visible and self.cachedTSMFrame then
				---@diagnostic disable-next-line: undefined-field
				local queue = self.cachedTSMFrame.queue;
				if queue and queue:IsShown() then
					self:SetPoint("TOPLEFT", queue, "TOPRIGHT", 0, 0);
					self:SetPoint("BOTTOMLEFT", queue, "BOTTOMRIGHT", 0, 0);
				else
					self:SetPoint("TOPLEFT", self.cachedTSMFrame, "TOPRIGHT", 0, 0);
					self:SetPoint("BOTTOMLEFT", self.cachedTSMFrame, "BOTTOMRIGHT", 0, 0);
				end
				self:SetMovable(false);
			-- Skillet compatibility
			elseif SkilletFrame then
				self:SetPoint("TOPLEFT", SkilletFrame, "TOPRIGHT", 0, 0);
				self:SetPoint("BOTTOMLEFT", SkilletFrame, "BOTTOMRIGHT", 0, 0);
				self:SetMovable(true);
			elseif TradeSkillFrame then
				-- Default Alignment on the WoW UI.
				self:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 0, 0);
				self:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 0, 0);
				self:SetMovable(false);
			elseif ProfessionsFrame then
				-- Default Alignment on the 10.0 WoW UI
				self:SetPoint("TOPLEFT", ProfessionsFrame, "TOPRIGHT", 0, 0);
				self:SetPoint("BOTTOMLEFT", ProfessionsFrame, "BOTTOMRIGHT", 0, 0);
				self:SetMovable(false);
			else
				self:SetMovable(false);
				StartCoroutine("TSMWHY", function()
					while InCombatLockdown() or not TradeSkillFrame do coroutine.yield(); end
					StartCoroutine("TSMWHYPT2", function()
						local thing = self.TSMCraftingVisible;
						self.TSMCraftingVisible = nil;
						self:SetTSMCraftingVisible(thing);
					end);
				end);
				return;
			end
			AfterCombatCallback(self.Update, self);
		end
		-- Setup Event Handlers and register for events
		local EventHandlers = {
			TRADE_SKILL_SHOW = function(self)
				-- If it's not yours, don't take credit for it.
				if C_TradeSkillUI.IsTradeSkillLinked() or C_TradeSkillUI.IsTradeSkillGuild() then
					self:SetVisible(false)
					return false
				end

				-- Check to see if ATT has information about this profession.
				local tradeSkillID = app.GetTradeSkillLine()
				if not tradeSkillID or #SearchForField("professionID", tradeSkillID) < 1 then
					self:SetVisible(false)
					return false
				end

				if self.TSMCraftingVisible == nil then
					self:SetTSMCraftingVisible(false)
				end
				if app.Settings:GetTooltipSetting("Auto:ProfessionList") then
					self:SetVisible(true)
				end
				self:RefreshRecipes(true)
			end,
			TRADE_SKILL_CLOSE = function(self)
				self:SetVisible(false)
			end,
		}
		EventHandlers.GARRISON_TRADESKILL_NPC_CLOSED = EventHandlers.TRADE_SKILL_CLOSE

		self:SetScript("OnEvent", function(self, e, ...)
			-- app.PrintDebug("Tradeskills.event",e,...)
			local handler = EventHandlers[e]
			if not handler then return end

			-- app.PrintDebug("Tradeskills.event.handle",e)
			handler(self, e, ...)
			-- app.PrintDebugPrior("Tradeskills.event.done")
		end)
		return
	end
	if self:IsVisible() then
		if TSM_API and TSMAPI_FOUR then
			if not self.cachedTSMFrame then
				for i,child in ipairs({UIParent:GetChildren()}) do
					---@class ATTChildFrameTemplate: Frame
					---@field headerBgCenter any
					local f = child;
					if f.headerBgCenter then
						self.cachedTSMFrame = f;
						local oldSetVisible = f.SetVisible;
						local oldShow = f.Show;
						local oldHide = f.Hide;
						f.SetVisible = function(frame, visible)
							oldSetVisible(frame, visible);
							self:SetTSMCraftingVisible(visible);
						end
						f.Hide = function(frame)
							oldHide(frame);
							self:SetTSMCraftingVisible(false);
						end
						f.Show = function(frame)
							oldShow(frame);
							self:SetTSMCraftingVisible(true);
						end
						if self.gettinMadAtDumbNamingConventions then
							TSMAPI_FOUR.UI.NewElement = self.OldNewElement;
							self.gettinMadAtDumbNamingConventions = nil;
							self.OldNewElement = nil;
						end
						self:SetTSMCraftingVisible(f:IsShown());
						return;
					end
				end
				if not self.gettinMadAtDumbNamingConventions then
					self.gettinMadAtDumbNamingConventions = true;
					self.OldNewElement = TSMAPI_FOUR.UI.NewElement;
					---@diagnostic disable-next-line: duplicate-set-field
					TSMAPI_FOUR.UI.NewElement = function(...)
						AfterCombatCallback(self.Update, self);
						return self.OldNewElement(...);
					end
				end
			end
		elseif TSMCraftingTradeSkillFrame then
			-- print("TSMCraftingTradeSkillFrame")
			if not self.cachedTSMFrame then
				local f = TSMCraftingTradeSkillFrame;
				self.cachedTSMFrame = f;
				local oldSetVisible = f.SetVisible;
				local oldShow = f.Show;
				local oldHide = f.Hide;
				f.SetVisible = function(frame, visible)
					oldSetVisible(frame, visible);
					self:SetTSMCraftingVisible(visible);
				end
				f.Hide = function(frame)
					oldHide(frame);
					self:SetTSMCraftingVisible(false);
				end
				f.Show = function(frame)
					oldShow(frame);
					self:SetTSMCraftingVisible(true);
				end
				if f.queueBtn then
					local setScript = f.queueBtn.SetScript;
					f.queueBtn.SetScript = function(frame, e, callback)
						if e == "OnClick" then
							setScript(frame, e, function(...)
								if callback then callback(...); end

								local thing = self.TSMCraftingVisible;
								self.TSMCraftingVisible = nil;
								self:SetTSMCraftingVisible(thing);
							end);
						else
							setScript(frame, e, callback);
						end
					end
					f.queueBtn:SetScript("OnClick", f.queueBtn:GetScript("OnClick"));
				end
				self:SetTSMCraftingVisible(f:IsShown());
				return;
			end
		end

		-- Update the window and all of its row data
		self:BaseUpdate(force or self.force, got);
		self.force = nil;
	end
end;
customWindowUpdates.WorldQuests = function(self, force, got)
	-- localize some APIs
	local C_TaskQuest_GetQuestsForPlayerByMapID = C_TaskQuest.GetQuestsOnMap;
	local C_QuestLine_RequestQuestLinesForMap = C_QuestLine.RequestQuestLinesForMap;
	local C_QuestLine_GetAvailableQuestLines = C_QuestLine.GetAvailableQuestLines;
	local C_Map_GetMapChildrenInfo = C_Map.GetMapChildrenInfo;
	local C_AreaPoiInfo_GetAreaPOISecondsLeft = C_AreaPoiInfo.GetAreaPOISecondsLeft;
	local C_QuestLog_GetBountiesForMapID = C_QuestLog.GetBountiesForMapID;
	local GetNumRandomDungeons, GetLFGDungeonInfo, GetLFGRandomDungeonInfo, GetLFGDungeonRewards, GetLFGDungeonRewardInfo =
		  GetNumRandomDungeons, GetLFGDungeonInfo, GetLFGRandomDungeonInfo, GetLFGDungeonRewards, GetLFGDungeonRewardInfo;

	if self:IsVisible() then
		if not self.initialized then
			self.initialized = true;
			force = true;
			local UpdateButton = app.CreateRawText(L.UPDATE_WORLD_QUESTS, {
				["icon"] = 134269,
				["description"] = L.UPDATE_WORLD_QUESTS_DESC,
				["hash"] = "funUpdateWorldQuests",
				["OnClick"] = function(data, button)
					Push(self, "WorldQuests-Rebuild", self.Rebuild);
					return true;
				end,
				["OnUpdate"] = app.AlwaysShowUpdate,
			})
			local data = app.CreateRawText(L.WORLD_QUESTS, {
				["icon"] = 237387,
				["description"] = L.WORLD_QUESTS_DESC,
				["indent"] = 0,
				["back"] = 1,
				["g"] = {
					UpdateButton,
				},
			})
			self:SetData(data);
			-- Build the initial heirarchy
			self:BuildData();
			local emissaryMapIDs = {
				{ 619, 650 },	-- Broken Isles, Highmountain
				{ app.FactionID == Enum.FlightPathFaction.Horde and 875 or 876, 895 },	-- Kul'Tiras or Zandalar, Stormsong Valley
			};
			local worldMapIDs = {
				-- The War Within Continents
				{
					2274,	-- Khaz Algar
				},
				-- Dragon Isles Continents
				{
					1978,	-- Dragon Isles
					{
						{ 2085 },	-- Primalist Tomorrow
						-- any un-attached sub-zones
					}
				},
				-- Shadowlands Continents
				{
					1550,	-- Shadowlands
					-- {}
				},
				-- BFA Continents
				{
					875,	-- Zandalar
					{
						{ 863, 5969, { 54135, 54136 }},	-- Nazmir (Romp in the Swamp [H] / March on the Marsh [A])
						{ 864, 5970, { 53885, 54134 }},	-- Voldun (Isolated Victory [H] / Many Fine Heroes [A])
						{ 862, 5973, { 53883, 54138 }},	-- Zuldazar (Shores of Zuldazar [H] / Ritual Rampage [A])
					}
				},
				{
					876,	-- Kul'Tiras
					{
						{ 896, 5964, { 54137, 53701 }},	-- Drustvar (In Every Dark Corner [H] / A Drust Cause [A])
						{ 942, 5966, { 54132, 51982 }},	-- Stormsong Valley (A Horde of Heroes [H] / Storm's Rage [A])
						{ 895, 5896, { 53939, 53711 }},	-- Tiragarde Sound (Breaching Boralus [H] / A Sound Defense [A])
					}
				},
				{ 1355 },	-- Nazjatar
				-- Legion Continents
				{
					619,	-- Broken Isles
					{
						{ 627 },	-- Dalaran (not a Zone, so doesn't list automatically)
						{ 630, 5175, { 47063 }},	-- Azsuna
						{ 650, 5177, { 47063 }},	-- Highmountain
						{ 634, 5178, { 47063 }},	-- Stormheim
						{ 641, 5210, { 47063 }},	-- Val'Sharah
					}
				},
				{ 905 },	-- Argus
				-- WoD Continents
				{ 572 },	-- Draenor
				-- MoP Continents
				{
					424,	-- Pandaria
					{
						{ 1530, 6489, { 56064 }},	-- Assault: The Black Empire
						{ 1530, 6491, { 57728 }},	-- Assault: The Endless Swarm
						{ 1530, 6490, { 57008 }},	-- Assault: The Warring Clans
					},
				},
				-- Cataclysm Continents
				{ 948 },	-- The Maelstrom
				-- WotLK Continents
				{ 113 },	-- Northrend
				-- BC Continents
				{ 101 },	-- Outland
				-- Vanilla Continents
				{
					12,		-- Kalimdor
					{
						{ 1527, 6486, { 57157 }},	-- Assault: The Black Empire
						{ 1527, 6488, { 56308 }},	-- Assault: Aqir Unearthed
						{ 1527, 6487, { 55350 }},	-- Assault: Amathet Advance
						{ 62 },	-- Darkshore
					},
				},
				{	13,		-- Eastern Kingdoms
					{
						{ 14 },	-- Arathi Highlands
					},
				},
			}
			local RepeatablesPerMapID = {
				[2200] = {	-- Emerald Dream
					78319,	-- The Superbloom
				},
				[2024] = {	-- The Azure Span
					79226,	-- The Big Dig: Traitor's Rest
				},
			}
			-- Blizz likes to list the same quest on multiple maps
			local AddedQuestIDs = {}
			self.Clear = function(self)
				self:GetRunner().Reset()
				local g = self.data.g
				-- wipe parent references from current top-level groups so any delayed
				-- updates on sub-groups no longer chain to the window
				for _,o in ipairs(g) do
					o.parent = nil
				end
				wipe(g);
				tinsert(g, UpdateButton);
				self:BuildData();
				self:Update(true);
			end
			-- World Quests (Tasks)
			self.MergeTasks = function(self, mapObject)
				local mapID = mapObject.mapID;
				if not mapID then return; end
				local pois = C_TaskQuest_GetQuestsForPlayerByMapID(mapID);
				-- app.PrintDebug(#pois,"WQ in",mapID);
				if pois then
					for i,poi in ipairs(pois) do
						-- only include Tasks on this actual mapID since each Zone mapID is checked individually
						if poi.mapID == mapID and not AddedQuestIDs[poi.questID] then
							-- app.PrintTable(poi)
							AddedQuestIDs[poi.questID] = true
							local questObject = GetPopulatedQuestObject(poi.questID);
							if questObject then
								if self.includeAll or
									-- include the quest in the list if holding shift and tracking quests
									(self.includePermanent and self.includeQuests) or
									-- or if it is repeatable (i.e. one attempt per day/week/year)
									questObject.repeatable or
									-- or if it has time remaining
									(questObject.timeRemaining or 0 > 0)
								then
									-- if poi.questID == 78663 then
									-- 	app.print("WQ",questObject.questID,questObject.g and #questObject.g);
									-- end
									-- add the map POI coords to our new quest object
									if poi.x and poi.y then
										questObject.coords = {{ 100 * poi.x, 100 * poi.y, mapID }}
									end
									NestObject(mapObject, questObject);
									-- see if need to retry based on missing data
									-- if not self.retry and questObject.missingData then self.retry = true; end
								end
							end
						-- else app.PrintDebug("Skipped WQ",mapID,poi.mapID,poi.questID)
						end
					end
				end
			end
			-- Storylines/Map Quest Icons
			self.MergeStorylines = function(self, mapObject)
				local mapID = mapObject.mapID;
				if not mapID then return; end
				C_QuestLine_RequestQuestLinesForMap(mapID);
				local questLines = C_QuestLine_GetAvailableQuestLines(mapID)
				if questLines then
					for id,questLine in pairs(questLines) do
						-- dont show 'hidden' quest lines... not sure what this is exactly
						if not questLine.isHidden and not AddedQuestIDs[questLine.questID] then
							AddedQuestIDs[questLine.questID] = true
							local questObject = GetPopulatedQuestObject(questLine.questID);
							if questObject then
								if self.includeAll or
									-- include the quest in the list if holding shift and tracking quests
									(self.includePermanent and self.includeQuests) or
									-- or if it is repeatable (i.e. one attempt per day/week/year)
									questObject.repeatable or
									-- or if it has time remaining
									(questObject.timeRemaining or 0 > 0)
								then
									NestObject(mapObject, questObject);
									-- see if need to retry based on missing data
									-- if not self.retry and questObject.missingData then self.retry = true; end
								end
							end
						end
					end
				else
					-- print("No questline data yet for mapID:",mapID);
					self.retry = true;
				end
			end
			-- Static Repeatables
			self.MergeRepeatables = function(self, mapObject)
				local mapID = mapObject.mapID;
				if not mapID then return; end
				local repeatables = RepeatablesPerMapID[mapID]
				if not repeatables then return end

				local questObject
				for _,questID in ipairs(repeatables) do
					questObject = GetPopulatedQuestObject(questID)
					if questObject then
						if self.includeAll or
							-- Account/Debug or not saved
							(app.MODE_DEBUG_OR_ACCOUNT or not questObject.saved)
						then
							NestObject(mapObject, questObject);
							-- see if need to retry based on missing data
							-- if not self.retry and questObject.missingData then self.retry = true; end
						end
					end
				end

			end
			self.BuildMapAndChildren = function(self, mapObject)
				if not mapObject.mapID then return; end

				-- print("Build Map",mapObject.mapID,mapObject.text);

				-- Merge Tasks for Zone
				self:MergeTasks(mapObject);
				-- Merge Storylines for Zone
				self:MergeStorylines(mapObject);
				-- Merge Repeatables for Zone
				self:MergeRepeatables(mapObject);

				-- look for quests on map child maps as well
				local mapChildInfos = C_Map_GetMapChildrenInfo(mapObject.mapID, 3);
				if mapChildInfos then
					for _,mapInfo in ipairs(mapChildInfos) do
						-- start fetching the data while other stuff is setup
						C_QuestLine_RequestQuestLinesForMap(mapInfo.mapID);
						local subMapObject = app.CreateMapWithStyle(mapInfo.mapID);

						-- Build the children maps
						self:BuildMapAndChildren(subMapObject);

						NestObject(mapObject, subMapObject);
					end
				end
			end
			self.Rebuild = function(self, no)
				-- Already filled with data and nothing needing to retry, just give it a forced update pass since data for quests should now populate dynamically
				if not self.retry and #self.data.g > 1 then
					-- app.PrintDebug("Already WQ data, just update again")
					-- Force Update Callback
					Callback(self.Update, self, true);
					return;
				end
				-- Reset the world quests Runner before building new data
				self:GetRunner().Reset()
				wipe(self.data.g);
				-- Rebuild all World Quest data
				wipe(AddedQuestIDs)
				-- app.PrintDebug("Rebuild WQ Data")
				self.retry = nil;
				-- Put a 'Clear World Quests' click first in the list
				local temp = {{
					['text'] = L.CLEAR_WORLD_QUESTS,
					['icon'] = 2447782,
					['description'] = L.CLEAR_WORLD_QUESTS_DESC,
					['hash'] = "funClearWorldQuests",
					['OnClick'] = function(data, button)
						Push(self, "WorldQuests-Clear", self.Clear);
						return true;
					end,
					['OnUpdate'] = app.AlwaysShowUpdate,
				}};

				-- options when refreshing the list
				self.includeAll = app.MODE_DEBUG;
				self.includeQuests = app.Settings.Collectibles.Quests or app.Settings.Collectibles.QuestsLocked;
				self.includePermanent = IsAltKeyDown() or self.includeAll;

				-- Acquire all of the world mapIDs
				for _,pair in ipairs(worldMapIDs) do
					local mapID = pair[1];
					-- app.PrintDebug("WQ.WorldMapIDs.", mapID)
					-- start fetching the data while other stuff is setup
					C_QuestLine_RequestQuestLinesForMap(mapID);
					local mapObject = app.CreateMapWithStyle(mapID);

					-- Build top-level maps all the way down
					self:BuildMapAndChildren(mapObject);

					-- Invasions
					local mapIDPOIPairs = pair[2];
					if mapIDPOIPairs then
						for i,arr in ipairs(mapIDPOIPairs) do
							-- Sub-Map with Quest information to track
							if #arr >= 3 then
								for j,questID in ipairs(arr[3]) do
									if not IsQuestFlaggedCompleted(questID) then
										local timeLeft = C_AreaPoiInfo_GetAreaPOISecondsLeft(arr[2]);
										if timeLeft and timeLeft > 0 then
											local questObject = GetPopulatedQuestObject(questID);
											-- Custom time remaining based on the map POI since the quest itself does not indicate time remaining
											questObject.timeRemaining = timeLeft;
											local subMapObject = app.CreateMapWithStyle(arr[1]);
											NestObject(subMapObject, questObject);
											NestObject(mapObject, subMapObject);
										end
									end
								end
							else
								-- Basic Sub-map
								local subMap = app.CreateMapWithStyle(arr[1]);

								-- Build top-level maps all the way down for the sub-map
								self:BuildMapAndChildren(subMap);

								NestObject(mapObject, subMap);
							end
						end
					end

					-- Merge everything for this map into the list
					app.Sort(mapObject.g);
					if mapObject.g then
						-- Sort the sub-groups as well
						for i,mapGrp in ipairs(mapObject.g) do
							if mapGrp.mapID then
								app.Sort(mapGrp.g);
							end
						end
					end
					MergeObject(temp, mapObject);
				end

				-- Acquire all of the emissary quests
				for _,pair in ipairs(emissaryMapIDs) do
					local mapID = pair[1];
					-- print("WQ.EmissaryMapIDs." .. tostring(mapID))
					local mapObject = app.CreateMapWithStyle(mapID);
					local bounties = C_QuestLog_GetBountiesForMapID(pair[2]);
					if bounties and #bounties > 0 then
						for _,bounty in ipairs(bounties) do
							local questObject = GetPopulatedQuestObject(bounty.questID);
							NestObject(mapObject, questObject);
						end
					end
					app.Sort(mapObject.g);
					if mapObject.g then
						-- Sort the sub-groups as well
						for i,mapGrp in ipairs(mapObject.g) do
							if mapGrp.mapID then
								app.Sort(mapGrp.g);
							end
						end
					end
					MergeObject(temp, mapObject);
				end

				-- Heroic Deeds
				if self.includePermanent and not (IsQuestFlaggedCompleted(32900) or IsQuestFlaggedCompleted(32901)) then
					local mapObject = app.CreateMapWithStyle(424);
					NestObject(mapObject, GetPopulatedQuestObject(app.FactionID == Enum.FlightPathFaction.Alliance and 32900 or 32901));
					MergeObject(temp, mapObject);
				end

				local OnUpdateForLFGHeader = function(group)
					local meetLevelrange = app.Modules.Filter.Filters.Level(group);
					if meetLevelrange or app.MODE_DEBUG_OR_ACCOUNT then
						-- default logic for available LFG category/Debug/Account
						return false;
					else
						group.visible = nil;
						return true;
					end
				end

				-- Get the LFG Rewards Available at this level
				local numRandomDungeons = GetNumRandomDungeons();
				-- print(numRandomDungeons,"numRandomDungeons");
				if numRandomDungeons > 0 then
					local groupFinder = { text = DUNGEONS_BUTTON, icon = app.asset("Category_GroupFinder") };
					local gfg = {}
					groupFinder.g = gfg
					for index=1,numRandomDungeons,1 do
						local dungeonID = GetLFGRandomDungeonInfo(index);
						-- app.PrintDebug("RandInfo",index,GetLFGRandomDungeonInfo(index));
						-- app.PrintDebug("NormInfo",dungeonID,GetLFGDungeonInfo(dungeonID))
						-- app.PrintDebug("DungeonAppearsInRandomLFD(dungeonID)",DungeonAppearsInRandomLFD(dungeonID)); -- useless
						local name, typeID, subtypeID, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel, expansionLevel, groupID, textureFilename, difficulty, maxPlayers, description, isHoliday, bonusRepAmount, minPlayers, isTimeWalker, name2, minGearLevel = GetLFGDungeonInfo(dungeonID);
						-- print(dungeonID,name, typeID, subtypeID, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel, expansionLevel, groupID, textureFilename, difficulty, maxPlayers, description, isHoliday, bonusRepAmount, minPlayers, isTimeWalker, name2, minGearLevel);
						local _, gold, unknown, xp, unknown2, numRewards, unknown = GetLFGDungeonRewards(dungeonID);
						-- print("GetLFGDungeonRewards",dungeonID,GetLFGDungeonRewards(dungeonID));
						local header = { dungeonID = dungeonID, text = name, description = description, lvl = { minRecLevel or 1, maxRecLevel }, OnUpdate = OnUpdateForLFGHeader}
						local hg = {}
						header.g = hg
						if expansionLevel and not isHoliday then
							header.icon = app.CreateExpansion(expansionLevel + 1).icon;
						elseif isTimeWalker then
							header.icon = app.asset("Difficulty_Timewalking");
						end
						for rewardIndex=1,numRewards,1 do
							local itemName, icon, count, claimed, rewardType, itemID, quality = GetLFGDungeonRewardInfo(dungeonID, rewardIndex);
							-- common logic
							local idType = (rewardType or "item").."ID";
							local thing = { [idType] = itemID };
							local _cache = SearchForField(idType, itemID);
							for _,data in ipairs(_cache) do
								-- copy any sourced data for the dungeon reward into the list
								if GroupMatchesParams(data, idType, itemID, true) then
									MergeProperties(thing, data);
								end
								local lvl;
								if isTimeWalker then
									lvl = (data.lvl and type(data.lvl) == "table" and data.lvl[1]) or
											data.lvl or
											(data.parent and data.parent.lvl and type(data.parent.lvl) == "table" and data.parent.lvl[1]) or
											data.parent.lvl or 0;
								else
									lvl = 0;
								end
								-- Should the rewards be listed in the window based on the level of the rewards
								if lvl <= minRecLevel then
									NestObjects(thing, data.g);	-- no need to clone, everything is re-created at the end
								end
							end
							hg[#hg + 1] = thing
						end
						gfg[#gfg + 1] = header
					end
					tinsert(temp, CreateObject(groupFinder));
				end

				-- put all the things into the window data, turning them into objects as well
				NestObjects(self.data, temp);
				-- Build the heirarchy
				self:BuildData();
				-- Force Update
				self:Update(true);
			end
		end

		self:BaseUpdate(force);
	end
end;
end)();

-- Auction House Lib
(function()
local auctionFrame = CreateFrame("Frame");
app.AuctionFrame = auctionFrame;
app.ProcessAuctionData = function()
	-- If we have no auction data, then simply return now.
	if not AllTheThingsAuctionData then return end;
	local count = 0;
	for _ in pairs(AllTheThingsAuctionData) do count = count+1 end
	if count < 1 then return end;

	-- Search the ATT Database for information related to the auction links (items, species, etc)
	local filterID;
	local searchResultsByKey, searchResult, searchResults, key, keys, value, data = {}, nil, nil, nil, nil, nil, nil;
	for k,v in pairs(AllTheThingsAuctionData) do
		searchResults = app.SearchForLink(v.itemLink);
		if searchResults then
			if #searchResults > 0 then
				searchResult = searchResults[1];
				key = searchResult.key;
				if key == "npcID" then
					if searchResult.itemID then
						key = "itemID";
					end
				elseif key == "spellID" then
					local AuctionDataItemKeyOverrides = {
						[92426] = "itemID", -- Sealed Tome of the Lost Legion
					};
					if AuctionDataItemKeyOverrides[searchResult.itemID] then
						key = AuctionDataItemKeyOverrides[searchResult.itemID]
					end
				end
				value = searchResult[key];
				keys = searchResultsByKey[key];

				-- Make sure that the key type is represented.
				if not keys then
					keys = {};
					searchResultsByKey[key] = keys;
				end

				-- First time this key value was used.
				data = keys[value];
				if not data then
					data = CreateObject(searchResult);
					for i=2,#searchResults,1 do
						MergeObject(data, CreateObject(searchResults[i]));
					end
					if data.key == "npcID" then app.CreateItem(data.itemID, data); end
					data.auctions = {};
					keys[value] = data;
				end
				tinsert(data.auctions, v.itemLink);
			end
		end
	end

	-- Move all achievementID-based items into criteriaID
	if searchResultsByKey.achievementID then
		local criteria = searchResultsByKey.criteriaID;
		if criteria then
			for key,entry in pairs(searchResultsByKey.achievementID) do
				criteria[key] = entry;
			end
		else
			searchResultsByKey.criteriaID = searchResultsByKey.achievementID;
		end
		searchResultsByKey.achievementID = nil;
	end

	-- Apply a sub-filter to items with spellID-based identifiers.
	if searchResultsByKey.spellID then
		local filteredItems = {};
		for key,entry in pairs(searchResultsByKey.spellID) do
			filterID = entry.filterID or entry.f;
			if filterID then
				local filterData = filteredItems[filterID];
				if not filterData then
					filterData = {};
					filteredItems[filterID] = filterData;
				end
				filterData[key] = entry;
			else
				print("Spell " .. entry.spellID .. " (Item ID #" .. (entry.itemID or "???") .. ") is missing a filterID?");
			end
		end

		if filteredItems[100] then searchResultsByKey.mountID = filteredItems[100]; end	-- Mounts
		if filteredItems[200] then searchResultsByKey.recipeID = filteredItems[200]; end -- Recipes
		searchResultsByKey.spellID = nil;
	end

	if searchResultsByKey.sourceID then
		local filteredItems = {};
		local cachedSourceIDs = searchResultsByKey.sourceID;
		searchResultsByKey.sourceID = {};
		for sourceID,entry in pairs(cachedSourceIDs) do
			filterID = entry.filterID or entry.f;
			if filterID then
				local filterData = filteredItems[entry.f];
				if not filterData then
					filterData = app.CreateFilter(filterID);
					filterData.g = {};
					filteredItems[filterID] = filterData;
					tinsert(searchResultsByKey.sourceID, filterData);
				end
				tinsert(filterData.g, entry);
			end
		end
		for f,entry in pairs(filteredItems) do
			app.Sort(entry.g, function(a,b)
				return a.u and not b.u;
			end);
		end
	end

	-- Process the Non-Collectible Items for Reagents
	local reagentCache = app.ReagentsDB;
	if reagentCache and searchResultsByKey.itemID then
		local cachedItems = searchResultsByKey.itemID;
		searchResultsByKey.itemID = {};
		searchResultsByKey.reagentID = {};
		for itemID,entry in pairs(cachedItems) do
			if reagentCache[itemID] then
				searchResultsByKey.reagentID[itemID] = entry;
				if not entry.g then entry.g = {}; end
				for itemID2,count in pairs(reagentCache[itemID][2]) do
					local searchResults = SearchForField("itemID", itemID2);
					if #searchResults > 0 then
						tinsert(entry.g, CreateObject(searchResults[1]));
					end
				end
			else
				-- Push it back into the itemID table
				searchResultsByKey.itemID[itemID] = entry;
			end
		end
	end

	-- Insert Buttons into the groups.
	-- not sure what this was but unreferenced globals currently
	-- wipe(window.data.g);
	-- for i,option in ipairs(window.data.options) do
	-- 	tinsert(window.data.g, option);
	-- end

	local ObjectTypeMetas = {
		["criteriaID"] = app.CreateFilter(105, {	-- Achievements
			["icon"] = 341221,
			["description"] = L.ITEMS_FOR_ACHIEVEMENTS_DESC,
			["priority"] = 1,
		}),
		["sourceID"] = {	-- Appearances
			["text"] = "Appearances",
			["icon"] = 135276,
			["description"] = L.ALL_APPEARANCES_DESC,
			["priority"] = 2,
		},
		["mountID"] = app.CreateFilter(100, {	-- Mounts
			["description"] = L.ALL_THE_MOUNTS_DESC,
			["priority"] = 3,
		}),
		["speciesID"] = app.CreateFilter(101, {	-- Battle Pets
			["description"] = L.ALL_THE_BATTLEPETS_DESC,
			["priority"] = 4,
		}),
		["questID"] = app.CreateNPC(app.HeaderConstants.QUESTS, {	-- Quests
			["icon"] = 464068,
			["description"] = L.ALL_THE_QUESTS_DESC,
			["priority"] = 5,
		}),
		["recipeID"] = app.CreateFilter(200, {	-- Recipes
			["icon"] = 134942,
			["description"] = L.ALL_THE_RECIPES_DESC,
			["priority"] = 6,
		}),
		["itemID"] = {					-- General
			["text"] = "General",
			["icon"] = 334365,
			["description"] = L.ALL_THE_ILLUSIONS_DESC,
			["priority"] = 7,
		},
		["reagentID"] = app.CreateFilter(56, {	-- Reagent
			["icon"] = 135851,
			["description"] = L.ALL_THE_REAGENTS_DESC,
			["priority"] = 8,
		}),
	};

	-- Display Test for Raw Data + Filtering
	for key, searchResults in pairs(searchResultsByKey) do
		local subdata = {};
		subdata.visible = true;
		if ObjectTypeMetas[key] then
			setmetatable(subdata, { __index = ObjectTypeMetas[key] });
		else
			subdata.description = "Container for '" .. key .. "' object types.";
			subdata.text = key;
		end
		subdata.g = {};
		for i,j in pairs(searchResults) do
			tinsert(subdata.g, j);
		end
		-- not sure what this was but unreferenced globals currently
		-- tinsert(window.data.g, subdata);
	end
	-- not sure what this was but unreferenced globals currently
	-- app.Sort(window.data.g, function(a, b)
	-- 	return (b.priority or 0) > (a.priority or 0);
	-- end);
	-- AssignChildren(window.data);
	-- app.TopLevelUpdateGroup(window.data);
	-- window:Show();
	-- window:Update();
end

app.OpenAuctionModule = function(self)
	-- TODO: someday someone might fix this AH functionality...
	if true then return; end

	if C_AddOns.IsAddOnLoaded("TradeSkillMaster") then -- Why, TradeSkillMaster, why are you like this?
		C_Timer.After(2, app.EmptyFunction);
	end
	if app.Blizzard_AuctionHouseUILoaded then
		-- Localize some global APIs
		local C_AuctionHouse_GetNumReplicateItems = C_AuctionHouse.GetNumReplicateItems;
		local C_AuctionHouse_GetReplicateItemInfo = C_AuctionHouse.GetReplicateItemInfo;
		local C_AuctionHouse_GetReplicateItemLink = C_AuctionHouse.GetReplicateItemLink;

		-- Create the Auction Tab for ATT.
		local tabID = AuctionHouseFrame.numTabs+1;
		local button = CreateFrame("Button", "AuctionHouseFrameTab"..tabID, AuctionHouseFrame, "AuctionHouseFrameDisplayModeTabTemplate");
		button:SetID(tabID);
		button:SetText(L.SHORTTITLE);
		button:SetNormalFontObject(GameFontHighlightSmall);
		button:SetPoint("LEFT", AuctionHouseFrame.Tabs[tabID-1], "RIGHT", -15, 0);
		tinsert(AuctionHouseFrame.Tabs, button);

		PanelTemplates_SetNumTabs (AuctionHouseFrame, tabID);
		PanelTemplates_EnableTab  (AuctionHouseFrame, tabID);

		-- Garbage collect the function after this is executed.
		app.OpenAuctionModule = app.EmptyFunction;
		app.AuctionModuleTabID = tabID;

		-- Create the movable Auction Data window.
		local window = app:GetWindow("AuctionData", AuctionHouseFrame);
		auctionFrame:SetScript("OnEvent", function(self, e, ...)
			if e == "REPLICATE_ITEM_LIST_UPDATE" then
				self:UnregisterEvent("REPLICATE_ITEM_LIST_UPDATE");
				AllTheThingsAuctionData = {};
				local items = {};
				local auctionItems = C_AuctionHouse_GetNumReplicateItems();
				for i=0,auctionItems-1 do
					local itemLink;
					local count, _, _, _, _, _, _, price, _, _, _, _, _, _, itemID, status = select(3, C_AuctionHouse_GetReplicateItemInfo(i));
					if itemID then
						if price and status then
							itemLink = C_AuctionHouse_GetReplicateItemLink(i);
							if itemLink then
								AllTheThingsAuctionData[itemID] = { itemLink = itemLink, count = count, price = (price/count) };
							end
						else
							local item = Item:CreateFromItemID(itemID);
							items[item] = true;

							item:ContinueOnItemLoad(function()
								count, _, _, _, _, _, _, price, _, _, _, _, _, _, itemID, status = select(3, C_AuctionHouse_GetReplicateItemInfo(i));
								items[item] = nil;
								if itemID and status then
									itemLink = C_AuctionHouse_GetReplicateItemLink(i);
									if itemLink then
										AllTheThingsAuctionData[itemID] = { itemLink = itemLink, count = count, price = (price/count) };
									end
								end
								if not next(items) then
									items = {};
								end
							end);
						end
					end
				end
				if not next(items) then
					items = {};
				end
				print(L.TITLE .. L.AH_SCAN_SUCCESSFUL_1 .. auctionItems .. L.AH_SCAN_SUCCESSFUL_2);
				StartCoroutine("ProcessAuctionData", app.ProcessAuctionData, 1);
			end
		end);
		window:SetPoint("TOPLEFT", AuctionHouseFrame, "TOPRIGHT", 0, -10);
		window:SetPoint("BOTTOMLEFT", AuctionHouseFrame, "BOTTOMRIGHT", 0, 10);
		window:Hide();

		-- Cache some functions to make them faster
		local origSideDressUpFrameHide, origSideDressUpFrameShow = SideDressUpFrame.Hide, SideDressUpFrame.Show;
		---@diagnostic disable-next-line: duplicate-set-field
		SideDressUpFrame.Hide = function(...)
			origSideDressUpFrameHide(...);
			window:ClearAllPoints();
			window:SetPoint("TOPLEFT", AuctionHouseFrame, "TOPRIGHT", 0, -10);
			window:SetPoint("BOTTOMLEFT", AuctionHouseFrame, "BOTTOMRIGHT", 0, 10);
		end
		---@diagnostic disable-next-line: duplicate-set-field
		SideDressUpFrame.Show = function(...)
			origSideDressUpFrameShow(...);
			window:ClearAllPoints();
			window:SetPoint("LEFT", SideDressUpFrame, "RIGHT", 0, 0);
			window:SetPoint("TOP", AuctionHouseFrame, "TOP", 0, -10);
			window:SetPoint("BOTTOM", AuctionHouseFrame, "BOTTOM", 0, 10);
		end

		button:SetScript("OnClick", function(self) -- This is the "ATT" button at the bottom of the auction house frame
			if self:GetID() == tabID then
				window:Show();
			end
		end);
	end
end
end)();

do -- Setup and Startup Functionality
-- Creates the data structures and initial 'Default' profiles for ATT
app.SetupProfiles = function()
	-- base profiles containers
	local ATTProfiles = {
		Profiles = {},
		Assignments = {},
	};
	AllTheThingsProfiles = ATTProfiles;
	local default = app.Settings:NewProfile(DEFAULT);
	-- copy various existing settings that are now Profiled
	if AllTheThingsSettings then
		-- General Settings
		if AllTheThingsSettings.General then
			for k,v in pairs(AllTheThingsSettings.General) do
				default.General[k] = v;
			end
		end
		-- Tooltip Settings
		if AllTheThingsSettings.Tooltips then
			for k,v in pairs(AllTheThingsSettings.Tooltips) do
				default.Tooltips[k] = v;
			end
		end
		-- Seasonal Filters
		if AllTheThingsSettings.Seasonal then
			for k,v in pairs(AllTheThingsSettings.Seasonal) do
				default.Seasonal[k] = v;
			end
		end
		-- Unobtainable Filters
		if AllTheThingsSettings.Unobtainable then
			for k,v in pairs(AllTheThingsSettings.Unobtainable) do
				default.Unobtainable[k] = v and true or nil;
			end
		end
	end

	-- pull in window data for the default profile
	for _,window in pairs(app.Windows) do
		window:StorePosition();
	end

	app.print("Initialized ATT Profiles!");

	-- delete old variables
	AllTheThingsSettings = nil;
	AllTheThingsAD.UnobtainableItemFilters = nil;
	AllTheThingsAD.SeasonalFilters = nil;

	-- initialize settings again due to profiles existing now
	app.Settings:Initialize();
end

-- Called when the Addon is loaded to process initial startup information
app.Startup = function()
	-- app.PrintMemoryUsage("Startup")
	AllTheThingsAD = LocalizeGlobalIfAllowed("AllTheThingsAD", true);	-- For account-wide data.
	-- Cache the Localized Category Data
	AllTheThingsAD.LocalizedCategoryNames = setmetatable(AllTheThingsAD.LocalizedCategoryNames or {}, { __index = app.CategoryNames });
	app.CategoryNames = nil;

	-- Clear some keys which got added and shouldn't have been
	AllTheThingsAD.ExplorationDB = nil
	AllTheThingsAD.ExplorationAreaPositionDB = nil

	-- Character Data Storage
	local characterData = LocalizeGlobalIfAllowed("ATTCharacterData", true);
	local currentCharacter = characterData[app.GUID];
	if not currentCharacter then
		currentCharacter = {};
		characterData[app.GUID] = currentCharacter;
	end
	local name, realm = UnitName("player");
	if not realm then realm = GetRealmName(); end
	if name then currentCharacter.name = name; end
	if realm then currentCharacter.realm = realm; end
	if app.Me then currentCharacter.text = app.Me; end
	if app.GUID then currentCharacter.guid = app.GUID; end
	if app.Level then currentCharacter.lvl = app.Level; end
	if app.FactionID then currentCharacter.factionID = app.FactionID; end
	if app.ClassIndex then currentCharacter.classID = app.ClassIndex; end
	if app.RaceIndex then currentCharacter.raceID = app.RaceIndex; end
	if app.Class then currentCharacter.class = app.Class; end
	if app.Race then currentCharacter.race = app.Race; end
	if not currentCharacter.ActiveSkills then currentCharacter.ActiveSkills = {}; end
	if not currentCharacter.CustomCollects then currentCharacter.CustomCollects = {}; end
	if not currentCharacter.Deaths then currentCharacter.Deaths = 0; end
	if not currentCharacter.Lockouts then currentCharacter.Lockouts = {}; end
	if not currentCharacter.Professions then currentCharacter.Professions = {}; end
	app.CurrentCharacter = currentCharacter;
	app.AddEventHandler("OnPlayerLevelUp", function()
		currentCharacter.lvl = app.Level;
	end);

	-- Account Wide Data Storage
	ATTAccountWideData = LocalizeGlobalIfAllowed("ATTAccountWideData", true);
	local accountWideData = ATTAccountWideData;
	if not accountWideData.FactionBonus then accountWideData.FactionBonus = {}; end
	if not accountWideData.HeirloomRanks then accountWideData.HeirloomRanks = {}; end

	-- Old unused data
	currentCharacter.CommonItems = nil
	ATTAccountWideData.CommonItems = nil

	-- Notify Event Handlers that Saved Variable Data is available.
	app.HandleEvent("OnSavedVariablesAvailable", currentCharacter, ATTAccountWideData);
	-- Event handlers which need Saved Variable data which is added by OnSavedVariablesAvailable handlers into saved variables
	app.HandleEvent("OnAfterSavedVariablesAvailable", currentCharacter, ATTAccountWideData);

	-- Update the total account wide death counter.
	local deaths = 0;
	for guid,character in pairs(characterData) do
		if character and character.Deaths and character.Deaths > 0 then
			deaths = deaths + character.Deaths;
		end
	end
	ATTAccountWideData.Deaths = deaths;

	-- CRIEVE NOTE: Once the Sync Window is moved over from Classic, this can be removed.
	if not AllTheThingsAD.LinkedAccounts then
		AllTheThingsAD.LinkedAccounts = {};
	end
	-- app.PrintMemoryUsage("Startup:Done")
end
-- This needs to be the first OnStartup event processed
app.AddEventHandler("OnStartup", app.Startup, true)

local function PrePopulateAchievementSymlinks()
	local achCache = app.SearchForFieldContainer("achievementID")
	-- app.PrintDebug("FillAchSym")
	if achCache then
		local FillSym = app.FillAchievementCriteriaAsync
		app.FillRunner.SetPerFrame(500)
		local Run = app.FillRunner.Run
		local group
		for achID,groups in pairs(achCache) do
			for i=1,#groups do
				group = groups[i]
				if group.__type == "Achievement" and not GetRelativeValue(group, "sourceIgnored") then
					-- app.PrintDebug("FillAchSym",group.hash)
					Run(FillSym, group)
				end
			end
		end
		app.FillRunner.SetPerFrame(25)
	end
	app.RemoveEventHandler(PrePopulateAchievementSymlinks)
	-- app.PrintDebug("Done:FillAchSym")
end
app.AddEventHandler("OnRefreshCollectionsDone", PrePopulateAchievementSymlinks)

-- Function which is triggered after Startup
local function InitDataCoroutine()
	local yield = coroutine.yield
	-- app.PrintMemoryUsage("InitDataCoroutine")
	-- if IsInInstance() then
	-- 	app.print("cannot fully load while in an Instance due to Blizzard restrictions. Please Zone out to finish loading ATT.")
	-- end

	-- Wait for the Data Cache to return something.
	while not app:GetDataCache() do yield(); end
	-- Wait for the app to finish OnStartup event, somehow this can trigger out of order on some clients
	while app.Wait_OnStartupDone do yield(); end

	local accountWideData = LocalizeGlobalIfAllowed("ATTAccountWideData", true);
	local characterData = LocalizeGlobalIfAllowed("ATTCharacterData", true);
	local currentCharacter = characterData[app.GUID];

	-- Clean up other matching Characters with identical Name-Realm but differing GUID
	Callback(function()
		local myGUID = app.GUID;
		local myName, myRealm = currentCharacter.name, currentCharacter.realm;
		local myRegex = "%|cff[A-z0-9][A-z0-9][A-z0-9][A-z0-9][A-z0-9][A-z0-9]"..myName.."%-"..myRealm.."%|r";
		local otherName, otherRealm, otherText;
		local toClean;
		for guid,character in pairs(characterData) do
			-- simple check on name/realm first
			otherName = character.name;
			otherRealm = character.realm;
			otherText = character.text;
			if guid ~= myGUID then
				if otherName == myName and otherRealm == myRealm then
					if toClean then tinsert(toClean, guid)
					else toClean = { guid }; end
				elseif otherText and otherText:match(myRegex) then
					if toClean then tinsert(toClean, guid)
					else toClean = { guid }; end
				end
			end
		end
		if toClean then
			local copyTables = { "Buildings","GarrisonBuildings","Factions","FlightPaths" };
			local cleanCharacterFunc = function(guid)
				-- copy the set of QuestIDs from the duplicate character (to persist repeatable Quests collection)
				local character = characterData[guid];
				for _,tableName in ipairs(copyTables) do
					local copyTable = character[tableName];
					if copyTable then
						-- app.PrintDebug("Copying Dupe",tableName)
						local currentTable = currentCharacter[tableName];
						if not currentTable then
							-- old/restored character missing copied data
							currentTable = {}
							currentCharacter[tableName] = currentTable
						end
						for ID,complete in pairs(copyTable) do
							-- app.PrintDebug("Check",ID,complete,"?",currentTable[ID])
							if complete and not currentTable[ID] then
								-- app.PrintDebug("Copied Completed",ID)
								currentTable[ID] = complete;
							end
						end
					end
				end
				-- Remove the actual dupe data afterwards
				-- move to a backup table temporarily in case anyone reports weird issues, we could potentially resolve them?
				local backups = accountWideData._CharacterBackups;
				if not backups then
					backups = {};
					accountWideData._CharacterBackups = backups;
				end
				backups[guid] = character;
				characterData[guid] = nil;
				local count = 0
				for guid,char in pairs(backups) do
					count = count + 1
				end
				app.print("Removed & Backed up Duplicate Data of Current Character:",character.text,guid,"[You have",count,"total character backups]")
				app.print("Use '/att remove-deleted-character-backups help' for more info")
			end
			for _,guid in ipairs(toClean) do
				app.FunctionRunner.Run(cleanCharacterFunc, guid);
			end
		end

		-- Allows removing the character backups that ATT automatically creates for duplicated characters which are replaced by new ones
		app.ChatCommands.Add("remove-deleted-character-backups", function(args)
			local backups = 0
			for guid,char in pairs(accountWideData._CharacterBackups) do
				backups = backups + 1
			end
			accountWideData._CharacterBackups = nil
			app.print("Cleaned up",backups,"character backups!")
			return true
		end, {
			"Usage : /att remove-deleted-character-backups",
			"Allows permanently removing all deleted character backup data",
			"-- ATT removes and cleans out character-specific cached data which is stored by a character with the same Name-Realm as the logged-in character but a different character GUID. If you find yourself creating and deleting a lot of repeated characters, this will clean up those characters' data backups",
		})
	end);

	app.HandleEvent("OnInit")

	-- Current character collections shouldn't use '2' ever... so clear any 'inaccurate' data
	local currentQuestsCache = currentCharacter.Quests;
	for questID,completion in pairs(currentQuestsCache) do
		if completion == 2 then currentQuestsCache[questID] = nil; end
	end

	-- Setup the use of profiles after a short delay to ensure that the layout window positions are collected
	if not AllTheThingsProfiles then DelayedCallback(app.SetupProfiles, 5); end

	-- do a settings apply to ensure ATT windows which have now been created, are moved according to the current Profile
	app.Settings:ApplyProfile();

	-- clear harvest data on load in case someone forgets
	AllTheThingsHarvestItems = {};

	-- warning about debug logging in case it sneaks in we can realize quicker
	app.PrintDebug("NOTE: ATT debug prints enabled!")

	-- Execute the OnReady handlers.
	app.HandleEvent("OnReady")

	-- finally can say the app is ready
	app.IsReady = true;
	-- app.PrintDebug("ATT is Ready!");

	-- app.PrintMemoryUsage("InitDataCoroutine:Done")
end

app:RegisterFuncEvent("PLAYER_ENTERING_WORLD", function(...)
	-- app.PrintDebug("PLAYER_ENTERING_WORLD",...)
	app.InWorld = true;
	app:UnregisterEventClean("PLAYER_ENTERING_WORLD")
	StartCoroutine("InitDataCoroutine", InitDataCoroutine);
end);
end -- Setup and Startup Functionality

-- Define Event Behaviours
app.AddonLoadedTriggers = {
	[appName] = function()
		-- OnLoad events (saved variables are now available)
		app.HandleEvent("OnLoad")
	end,
	["Blizzard_AuctionHouseUI"] = function()
		app.Blizzard_AuctionHouseUILoaded = true;
		if app.Settings:GetTooltipSetting("Auto:AH") then
			app:OpenAuctionModule();
		end
	end,
};
-- Register Event for startup
app:RegisterFuncEvent("ADDON_LOADED", function(addonName)
	local addonTrigger = app.AddonLoadedTriggers[addonName];
	if addonTrigger then addonTrigger(); end
end)

app.Wait_OnStartupDone = true
app.AddEventHandler("OnStartupDone", function() app.Wait_OnStartupDone = nil end)

-- app.PrintMemoryUsage("AllTheThings.EOF");