-- Thanks to SOCD and QuickQuest for inspiration

local _

local LEW = LibStub("LibEventWindow-1.0");
local GSB = FishingBuddy.GetSettingBool;

local function GetNPCID()
	return tonumber(string.match(UnitGUID('npc') or UnitGUID('target') or '', 'Creature%-.-%-.-%-.-%-.-%-(.-)%-'))
end

local function procLunkerQuests(index, title, level, isTrivial, frequency, isRepeatable, isLegendary, ...)
	local isDaily = frequency == LE_QUEST_FREQUENCY_DAILY
	local isWeekly = frequency == LE_QUEST_FREQUENCY_WEEKLY

	local n = GetItemCount(title)
	if (n > 0) then
		SelectGossipAvailableQuest(index)
	end
	
	if ... then
		return procLunkerQuests(index + 1, ...)
	else
		return
	end
end

-- 109098
local _fqframe = LEW:CreateWindow()

_fqframe:Register('GOSSIP_SHOW', function()
	local npcID = GetNPCID()
	if (GSB("HandleQuests")) then
	
		if (npcID == 77733) then
			-- print ("Hi Ron Ashton!");
		elseif (npcID == 85984) then
			-- print ("Hi Nat Pagle at the shack!")
			if (GSB("AutoLunker")) then
				procLunkerQuests(1, GetGossipAvailableQuests() )
			end
		elseif (npcID == 108825) then
			local _, _, _, _, _, _, _, _, nextThreshold = GetFriendshipReputation();
			--  if max rank, don't do turn-in
			if (nextThreshold  and GSB("DrownedMana")) then
				local mana = GetItemCount(138777);
				if (mana > 10) then
					SelectGossipOption(5, true)
				elseif (mana > 1) then
					SelectGossipOption(4, true)
				end
			end
		end
	end
end, true)

_fqframe:Register('QUEST_PROGRESS', function(_, ...)
	if (GSB("HandleQuests") and GSB("AutoLunker")) then
		local npcID = GetNPCID()
	
		if (npcID == 85984) then
			local title = GetTitleText()
			local n = GetItemCount(title)
			if (n > 0) then
				return CompleteQuest()
			end
		end
	end
end, true)

_fqframe:Register('QUEST_COMPLETE', function(_, ...)
	if (GSB("HandleQuests") and GSB("AutoLunker")) then
		local npcID = GetNPCID()
	
		if (npcID == 85984) then
			local title = GetTitleText()
			local n = GetItemCount(title)
			if (n > 0) then
				return GetQuestReward(1)
			end
		end
	end
end, true)

local QuestOptions = {
	["HandleQuests"] = {
		["text"] = FBConstants.CONFIG_HANDLEQUESTS_ONOFF,
		["tooltip"] = FBConstants.CONFIG_HANDLEQUESTS_INFO,
		["v"] = 1,
		["default"] = true },
	["AutoLunker"] = {
		["text"] = FBConstants.CONFIG_LUNKERQUESTS_ONOFF,
		["tooltip"] = FBConstants.CONFIG_LUNKERQUESTS_INFO,
		["v"] = 1,
		["default"] = true,
		["parents"] = { ["HandleQuests"] = "d", },
	},
	["DrownedMana"] = {
		["text"] = FBConstants.CONFIG_DROWNEDMANA_ONOFF,
		["tooltip"] = FBConstants.CONFIG_DROWNEDMANA_INFO,
		["v"] = 1,
		["default"] = false,
		["parents"] = { ["HandleQuests"] = "d", },
	},
}

_fqframe:Register("VARIABLES_LOADED", function(_, ...)
	FishingBuddy.OptionsFrame.HandleOptions(GENERAL, nil, QuestOptions);
end, true)
