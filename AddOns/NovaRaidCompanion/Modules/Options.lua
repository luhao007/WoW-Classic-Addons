-----------------------
--Nova Raid Companion--
-----------------------
--Novaspark-Arugal OCE (classic).
--https://www.curseforge.com/members/venomisto/projects

local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");
NRC.maxCooldownFrameCount = 5;

local spellWidth, mergedWidth, frameWidth = 0.8, 0.8, 0.5;
local function setCooldownFrameOption(values)
	local t = {};
	for i = 1, NRC.maxCooldownFrameCount do
		if (values) then
			t[i] = L["List"] .. " " .. tostring(i);
		else
			t[i] = i;
		end
	end;
	return t;
end

local function setCooldownSoulstonesPositionOption(values)
	local t = {};
	local count = 0;
	for i = 1, NRC.maxCooldownFrameCount do
		count = count + 1;
		if (values) then
			t[count] = L["List"] .. " " .. tostring(i);
		else
			t[count] = count;
		end
	end;
	return t;
end

local function updateSreOptions()
	if (not NRC.config) then
		--No need to display the text before it needs to be viewed.
		return "Config not loaded.";
	end
	local text = "|cFFFFFF00" .. L["Custom Spells"] .. ":|r";
	local found;
	for k, v in NRC:pairsByKeys(NRC.config.sreCustomSpells) do
		local iconText = "";
		if (v.icon) then
			iconText = "|T" .. v.icon .. ":14:14|t ";
		end
		text = text .. "\n" .. iconText .. k .. " |cFF9CD6DE" .. v.spellName .. "|r";
		if (v.rank) then
			text = text .. " |cFF9CD6DE(" .. v.rank .. ")|r"
		end
		found = true;
	end
	if (not found) then
		return text .. "\nNo custom spells added yet.";
	else
		return text;
	end
end

local function addSreSpell()

end

local function removeSreSpell()

end

NRC.options = {
	name =  "",
	handler = NRC,
	type = 'group',
	args = {
		titleText = {
			type = "description",
			name = "        " .. NRC.prefixColor .. "NovaRaidCompanion (v" .. GetAddOnMetadata("NovaRaidCompanion", "Version") .. ")",
			fontSize = "large",
			order = 1,
		},
		authorText = {
			type = "description", --Using a temp icon from Blizzard.
			name = "|TInterface\\AddOns\\NovaRaidCompanion\\Media\\nrc_icon2:32:32:0:20|t |cFF9CD6DEby Novaspark-Arugal|r  |cFF00C800-|r  |cFFFFFF00For help or suggestions discord.gg/RTKMfTmkdj|r",
			fontSize = "medium",
			order = 2,
		},
		lockAllFrames = {
			type = "toggle",
			--name = "|cFFFF6900" .. L["lockAllFramesTitle"],
			name = "|cFF3CE13F" .. L["lockAllFramesTitle"],
			desc = L["lockAllFramesDesc"],
			order = 3,
			get = "getLockAllFrames",
			set = "setLockAllFrames",
		},
		--[[resetAllFrames = {
			type = "execute",
			name = L["resetAllFramesTitle"],
			desc = L["resetAllFramesDesc"],
			func = "testAllFrames",
			order = 6,
			confirm = function()
				return string.format(L["resetAllFramesConfirm"], "|cFFFFFF00" .. NIT.db.global.trimDataBelowLevel .. "|r");
			end,
		},]]
		--[[mainText = {
			type = "description",
			name = "|cFFFFFF00" .. L["mainTextDesc"],
			fontSize = "medium",
			order = 10,
		},]]
		general = {
			name = "General Options",
			desc = "Main options.",
			type = "group",
			order = 30,
			args = {
				showMobSpawnedTime = {
					type = "toggle",
					name = L["showMobSpawnedTimeTitle"],
					desc = L["showMobSpawnedTimeDesc"],
					order = 1,
					get = "getShowMobSpawnedTime",
					set = "setShowMobSpawnedTime",
				},
				minimapButton = {
					type = "toggle",
					name = L["minimapButtonTitle"],
					desc = L["minimapButtonDesc"],
					order = 2,
					get = "getMinimapButton",
					set = "setMinimapButton",
				},
				summonStoneMsg = {
					type = "toggle",
					name = L["summonStoneMsgTitle"],
					desc = L["summonStoneMsgDesc"],
					order = 3,
					get = "getSummonStoneMsg",
					set = "setSummonStoneMsg",
				},
				duraWarning = {
					type = "toggle",
					name = L["duraWarningTitle"],
					desc = L["duraWarningDesc"],
					order = 4,
					get = "getDuraWarning",
					set = "setDuraWarning",
				},
				attunementWarnings = {
					type = "toggle",
					name = L["attunementWarningsTitle"],
					desc = L["attunementWarningsDesc"],
					order = 5,
					get = "getAttunementWarnings",
					set = "setAttunementWarnings",
				},
				resetFrames = {
					type = "execute",
					name = L["resetFramesTitle"],
					desc = L["resetFramesDesc"],
					func = "resetFrames",
					order = 60,
				},
				showMoneyTradedChat = {
					type = "toggle",
					name = L["showMoneyTradedChatTitle"],
					desc = L["showMoneyTradedChatDesc"],
					order = 6,
					get = "getShowMoneyTradedChat",
					set = "setShowMoneyTradedChat",
				},
				showInspectTalents = {
					type = "toggle",
					name = L["showInspectTalentsTitle"],
					desc = L["inspectTalentsCheckBoxTooltip"],
					order = 7,
					get = "getShowInspectTalents",
					set = "setShowInspectTalents",
				},
				autoCombatLog = {
					type = "toggle",
					name = L["autoCombatLogTitle"],
					desc = L["autoCombatLogDesc"],
					order = 8,
					get = "getAutoCombatLog",
					set = "setAutoCombatLog",
				},
				cauldronMsg = {
					type = "toggle",
					name = L["cauldronMsgTitle"],
					desc = L["cauldronMsgDesc"],
					order = 9,
					get = "getCauldronMsg",
					set = "setCauldronMsg",
				},
				checkMetaGem = {
					type = "toggle",
					name = L["checkMetaGemTitle"],
					desc = L["checkMetaGemDesc"],
					order = 9,
					get = "getCheckMetaGem",
					set = "setCheckMetaGem",
				},
				releaseWarning = {
					type = "toggle",
					name = L["releaseWarningTitle"],
					desc = L["releaseWarningDesc"],
					order = 10,
					get = "getReleaseWarning",
					set = "setReleaseWarning",
				},
				showTrainset = {
					type = "toggle",
					name = L["showTrainsetTitle"],
					desc = L["showTrainsetDesc"],
					order = 11,
					get = "getShowTrainset",
					set = "setShowTrainset",
				},
				autoInv = {
					type = "toggle",
					name = L["autoInvTitle"],
					desc = L["autoInvDesc"],
					order = 112,
					get = "getAutoInv",
					set = "setAutoInv",
				},
				autoInvKeyword = {
					type = "input",
					name = L["autoInvKeywordTitle"],
					desc = L["autoInvKeywordDesc"],
					get = "getAutoInvKeyword",
					set = "setAutoInvKeyword",
					order = 113,
				},
				timeStampFormat = {
					type = "select",
					name = L["timeStampFormatTitle"],
					desc = L["timeStampFormatDesc"],
					values = {
						[12] = "12 hour",
						[24] = "24 hour",
					},
					sorting = {
						[1] = 12,
						[2] = 24,
					},
					order = 20,
					get = "getTimeStampFormat",
					set = "setTimeStampFormat",
				},
			},
		},
		raidCooldowns = {
			name = "Raid Cooldowns",
			desc = "Raid cooldown tracking, group battle res tracking, etc.",
			type = "group",
			order = 40,
			args = {
				--[[raidCooldownsMainHeader = {
					type = "header",
					name = "|cFFFF6900Raid Cooldowns",
					order = 1,
				},]]
				mainText = {
					type = "description",
					name = "|cFF3CE13F" .. L["raidCooldownsMainTextDesc"],
					fontSize = "medium",
					order = 1,
				},
				showRaidCooldowns = {
					type = "toggle",
					name = L["showRaidCooldownsTitle"],
					desc = L["showRaidCooldownsDesc"],
					order = 2,
					get = "getShowRaidCooldowns",
					set = "setShowRaidCooldowns",
				},
				showRaidCooldownsInRaid = {
					type = "toggle",
					name = L["showRaidCooldownsInRaidTitle"],
					desc = L["showRaidCooldownsInRaidDesc"],
					order = 3,
					get = "getShowRaidCooldownsInRaid",
					set = "setShowRaidCooldownsInRaid",
				},
				showRaidCooldownsInParty = {
					type = "toggle",
					name = L["showRaidCooldownsInPartyTitle"],
					desc = L["showRaidCooldownsInPartyDesc"],
					order = 4,
					get = "getShowRaidCooldownsInParty",
					set = "setShowRaidCooldownsInParty",
				},
				--[[showRaidCooldownsInWorld = {
					type = "toggle",
					name = L["showRaidCooldownsInWorldTitle"],
					desc = L["showRaidCooldownsInWorldDesc"],
					order = 5,
					get = "getShowRaidCooldownsInWorld",
					set = "setShowRaidCooldownsInWorld",
				},]]
				showRaidCooldownsInBG = {
					type = "toggle",
					name = L["showRaidCooldownsInBGTitle"],
					desc = L["showRaidCooldownsInBGDesc"],
					order = 5,
					get = "getShowRaidCooldownsInBG",
					set = "setShowRaidCooldownsInBG",
				},
				raidCooldownsSoulstones = {
					type = "toggle",
					name = L["raidCooldownsSoulstonesTitle"],
					desc = L["raidCooldownsSoulstonesDesc"],
					order = 13,
					get = "getRaidCooldownsSoulstones",
					set = "setRaidCooldownsSoulstones",
				},
				--[[mergeRaidCooldowns = {
					type = "toggle",
					name = L["mergeRaidCooldownsTitle"],
					desc = L["mergedRaidCooldownsDesc"],
					order = 14,
					--width = "full",
					get = "getMergeRaidCooldowns",
					set = "setMergeRaidCooldowns",
				},]]
				raidCooldownsNecksRaidOnly = {
					type = "toggle",
					name = L["raidCooldownsNecksRaidOnlyTitle"],
					desc = L["raidCooldownsNecksRaidOnlyDesc"],
					order = 15,
					get = "getRaidCooldownsNecksRaidOnly",
					set = "setRaidCooldownsNecksRaidOnly",
				},
				raidCooldownLayoutHeader = {
					type = "header",
					name = "|cFFFF6900" .. L["Layout"],
					order = 19,
				},
				--[[mainText = {
					type = "description",
					name = "|cFF3CE13F" .. L["raidCooldownsTextDesc"],
					fontSize = "medium",
					order = 20,
				},]]
				cooldownFrameCount = {
					type = "range",
					name = L["cooldownFrameCountTitle"],
					desc = L["cooldownFrameCountDesc"],
					order = 21,
					get = "getCooldownFrameCount",
					set = "setCooldownFrameCount",
					min = 1,
					max = NRC.maxCooldownFrameCount,
					softMin = 1,
					softMax = NRC.maxCooldownFrameCount,
					step = 1,
					width = 2,
				},
				raidCooldownsGrowthDirection = {
					type = "select",
					name = L["raidCooldownsGrowthDirectionTitle"],
					desc = L["raidCooldownsGrowthDirectionDesc"],
					values = {
						[1] = "Down",
						[2] = "Up",
					},
					sorting = {
						[1] = 2,
						[2] = 1,
					},
					order = 22,
					get = "getraidCooldownsGrowthDirection",
					set = "setraidCooldownsGrowthDirection",
				},
				raidCooldownsScale = {
					type = "range",
					name = L["raidCooldownsScaleTitle"],
					desc = L["raidCooldownsScaleDesc"],
					order = 23,
					get = "getRaidCooldownsScale",
					set = "setRaidCooldownsScale",
					min = 0.3,
					max = 1.7,
					softMin = 0.3,
					softMax = 1.7,
					step = 0.1,
				},
				raidCooldownsWidth = {
					type = "range",
					name = L["raidCooldownsWidthTitle"],
					desc = L["raidCooldownsWidthDesc"],
					order = 24,
					get = "getRaidCooldownsWidth",
					set = "setRaidCooldownsWidth",
					min = 10,
					max = 400,
					softMin = 10,
					softMax = 400,
					step = 1,
				},
				raidCooldownsHeight = {
					type = "range",
					name = L["raidCooldownsHeightTitle"],
					desc = L["raidCooldownsHeightDesc"],
					order = 25,
					get = "getRaidCooldownsHeight",
					set = "setRaidCooldownsHeight",
					min = 10,
					max = 50,
					softMin = 10,
					softMax = 50,
					step = 1,
				},
				raidCooldownsBackdropAlpha = {
					type = "range",
					name = L["raidCooldownsBackdropAlphaTitle"],
					desc = L["raidCooldownsBackdropAlphaDesc"],
					order = 26,
					get = "getRaidCooldownsBackdropAlpha",
					set = "setRaidCooldownsBackdropAlpha",
					min = 0,
					max = 1,
					softMin = 0,
					softMax = 1,
					step = 0.05,
				},
				raidCooldownsBorderAlpha = {
					type = "range",
					name = L["raidCooldownsBorderAlphaTitle"],
					desc = L["raidCooldownsBorderAlphaDesc"],
					order = 27,
					get = "getRaidCooldownsBorderAlpha",
					set = "setRaidCooldownsBorderAlpha",
					min = 0,
					max = 1,
					softMin = 0,
					softMax = 1,
					step = 0.05,
				},
				raidCooldownsNumType = {
					type = "select",
					name = L["raidCooldownsNumTypeTitle"],
					desc = L["raidCooldownsNumTypeDesc"],
					values = {
						[1] = "Ready",
						[2] = "Ready/Total",
					},
					sorting = {
						[1] = 1,
						[2] = 2,
					},
					order = 33,
					get = "getRaidCooldownsNumType",
					set = "setRaidCooldownsNumType",
				},
				raidCooldownsBorderType = {
					type = "select",
					name = L["raidCooldownsBorderTypeTitle"],
					desc = L["raidCooldownsBorderTypeDesc"],
					values = {
						[1] = "Square",
						[2] = "Round",
					},
					sorting = {
						[1] = 1,
						[2] = 2,
					},
					order = 33,
					get = "getRaidCooldownsBorderType",
					set = "setRaidCooldownsBorderType",
				},
				raidCooldownsSoulstonesPosition = {
					type = "select",
					name = L["raidCooldownsSoulstonesPositionTitle"],
					desc = L["raidCooldownsSoulstonesPositionDesc"],
					values = setCooldownSoulstonesPositionOption(true),
					sorting = setCooldownSoulstonesPositionOption(),
					order = 33,
					get = "getRaidCooldownsSoulstonesPosition",
					set = "setRaidCooldownsSoulstonesPosition",
				},
				raidCooldownsSortOrder = {
					type = "select",
					name = L["raidCooldownsSortOrderTitle"],
					desc = L["raidCooldownsSortOrderDesc"],
					values = {
						[1] = "Class (Ascending)",
						[2] = "Class (Descending)",
						[3] = "Spell Name (Ascending)",
						[4] = "Spell Name (Descending)",
						[5] = "Shortest Cooldown",
						[6] = "Longest Cooldown",
					},
					sorting = {
						[1] = 1,
						[2] = 2,
						[3] = 3,
						[4] = 4,
						[5] = 5,
						[6] = 6,
					},
					order = 34,
					get = "getRaidCooldownsSortOrder",
					set = "setRaidCooldownsSortOrder",
				},
				raidCooldownsFont = {
					type = "select",
					name = L["raidCooldownsFontTitle"],
					desc = L["raidCooldownsFontDesc"],
					values = NRC.LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					order = 35,
					get = "getRaidCooldownsFont",
					set = "setRaidCooldownsFont",
				},
				raidCooldownsFontNumbers = {
					type = "select",
					name = L["raidCooldownsFontNumbersTitle"],
					desc = L["raidCooldownsFontNumbersDesc"],
					values = NRC.LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					order = 36,
					get = "getRaidCooldownsFontNumbers",
					set = "setRaidCooldownsFontNumbers",
				},
				raidCooldownsFontSize = {
					type = "range",
					name = L["raidCooldownsFontSizeTitle"],
					desc = L["raidCooldownsFontSizeDesc"],
					order = 37,
					get = "getRaidCooldownsFontSize",
					set = "setRaidCooldownsFontSize",
					min = 6,
					max = 20,
					softMin = 6,
					softMax = 20,
					step = 1,
				},
				raidCooldownsFontOutline = {
					type = "select",
					name = L["raidCooldownsFontOutlineTitle"],
					desc = L["raidCooldownsFontOutlineDesc"],
					values = {
						["NONE"] = L["None"],
						["OUTLINE"] = L["Thin Outline"],
						["THICKOUTLINE"] = L["Thick Outline"],
					},
					sorting = {
						[1] = "NONE",
						[2] = "OUTLINE",
						[3] = "THICKOUTLINE",
					},
					order = 38,
					get = "getRaidCooldownsFontOutline",
					set = "setRaidCooldownsFontOutline",
				},
				--[[raidCooldownsDisableMouse = {
					type = "toggle",
					name = L["raidCooldownsDisableMouseTitle"],
					desc = L["raidCooldownsDisableMouseDesc"],
					order = 37,
					get = "getRaidCooldownsDisableMouse",
					set = "setRaidCooldownsDisableMouse",
				},]]
				raidCooldownsClicksHeader = {
					type = "header",
					name = "|cFFFF6900" .. L["raidCooldownsClicksHeaderDesc"],
					order = 40,
				},
				raidCooldownsLeftClick = {
					type = "select",
					name = L["raidCooldownsLeftClickTitle"],
					desc = L["raidCooldownsLeftClickDesc"],
					values = {
						[1] = L["Do Nothing"],
						[2] = L["raidCooldownsClickOption2"],
						[3] = L["raidCooldownsClickOption3"],
					},
					sorting = {
						[1] = 1,
						[2] = 2,
						[3] = 3,
					},
					order = 41,
					get = "getRaidCooldownsLeftClick",
					set = "setRaidCooldownsLeftClick",
					width = 1.7,
				},
				raidCooldownsRightClick = {
					type = "select",
					name = L["raidCooldownsRightClickTitle"],
					desc = L["raidCooldownsRightClickDesc"],
					values = {
						[1] = L["Do Nothing"],
						[2] = L["raidCooldownsClickOption2"],
						[3] = L["raidCooldownsClickOption3"],
					},
					sorting = {
						[1] = 1,
						[2] = 2,
						[3] = 3,
					},
					order = 42,
					get = "getRaidCooldownsRightClick",
					set = "setRaidCooldownsRightClick",
					width = 1.7,
				},
				raidCooldownsShiftLeftClick = {
					type = "select",
					name = L["raidCooldownsShiftLeftClickTitle"],
					desc = L["raidCooldownsShiftLeftClickDesc"],
					values = {
						[1] = L["Do Nothing"],
						[2] = L["raidCooldownsClickOption2"],
						[3] = L["raidCooldownsClickOption3"],
					},
					sorting = {
						[1] = 1,
						[2] = 2,
						[3] = 3,
					},
					order = 43,
					get = "getRaidCooldownsShiftLeftClick",
					set = "setRaidCooldownsShiftLeftClick",
					width = 1.7,
				},
				raidCooldownsShiftRightClick = {
					type = "select",
					name = L["raidCooldownsShiftRightClickTitle"],
					desc = L["raidCooldownsShiftRightClickDesc"],
					values = {
						[1] = L["Do Nothing"],
						[2] = L["raidCooldownsClickOption2"],
						[3] = L["raidCooldownsClickOption3"],
					},
					sorting = {
						[1] = 1,
						[2] = 2,
						[3] = 3,
					},
					order = 44,
					get = "getRaidCooldownsShiftRightClick",
					set = "setRaidCooldownsShiftRightClick",
					width = 1.7,
				},
				raidCooldownSpellsHeader = {
					type = "header",
					name = "|cFFFF6900" .. L["raidCooldownSpellsHeaderDesc"],
					order = 99,
				},
				--Druid.
				raidCooldownRebirth = {
					type = "toggle",
					name = "|cFFFF7C0A" .. L["raidCooldownRebirthTitle"],
					desc = L["raidCooldownRebirthDesc"],
					order = 200,
					width = spellWidth,
					get = "getRaidCooldownRebirth",
					set = "setRaidCooldownRebirth",
				},
				raidCooldownRebirthMerged = {
					type = "toggle",
					name = "|cFFFF7C0A" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Rebirth"]),
					order = 201,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownRebirthMerged; end,
					set = function(info, value) NRC.config.raidCooldownRebirthMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownRebirthFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Rebirth"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 202,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownRebirthFrame; end,
					set = function(info, value) NRC.config.raidCooldownRebirthFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownInnervate = {
					type = "toggle",
					name = "|cFFFF7C0A" .. L["raidCooldownInnervateTitle"],
					desc = L["raidCooldownInnervateDesc"],
					order = 205,
					width = spellWidth,
					get = "getRaidCooldownInnervate",
					set = "setRaidCooldownInnervate",
				},
				raidCooldownInnervateMerged = {
					type = "toggle",
					name = "|cFFFF7C0A" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Innervate"]),
					order = 206,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownInnervateMerged; end,
					set = function(info, value) NRC.config.raidCooldownInnervateMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownInnervateFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Innervate"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 207,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownInnervateFrame; end,
					set = function(info, value) NRC.config.raidCooldownInnervateFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownTranquility = {
					type = "toggle",
					name = "|cFFFF7C0A" .. L["raidCooldownTranquilityTitle"],
					desc = L["raidCooldownTranquilityDesc"],
					order = 208,
					width = spellWidth,
					get = "getRaidCooldownTranquility",
					set = "setRaidCooldownTranquility",
				},
				raidCooldownTranquilityMerged = {
					type = "toggle",
					name = "|cFFFF7C0A" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Tranquility"]),
					order = 209,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownTranquilityMerged; end,
					set = function(info, value) NRC.config.raidCooldownTranquilityMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownTranquilityFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Tranquility"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 210,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownTranquilityFrame; end,
					set = function(info, value) NRC.config.raidCooldownTranquilityFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownChallengingRoar = {
					type = "toggle",
					name = "|cFFFF7C0A" .. L["raidCooldownChallengingRoarTitle"],
					desc = L["raidCooldownChallengingRoarDesc"],
					order = 211,
					width = spellWidth,
					get = "getRaidCooldownChallengingRoar",
					set = "setRaidCooldownChallengingRoar",
				},
				raidCooldownChallengingRoarMerged = {
					type = "toggle",
					name = "|cFFFF7C0A" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Challenging Roar"]),
					order = 212,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownChallengingRoarMerged; end,
					set = function(info, value) NRC.config.raidCooldownChallengingRoarMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownChallengingRoarFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Challenging Roar"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 213,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownChallengingRoarFrame; end,
					set = function(info, value) NRC.config.raidCooldownChallengingRoarFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				--Hunter.
				raidCooldownMisdirection = {
					type = "toggle",
					name = "|cFFAAD372" .. L["raidCooldownMisdirectionTitle"],
					desc = L["raidCooldownMisdirectionDesc"],
					order = 301,
					width = spellWidth,
					get = "getRaidCooldownMisdirection",
					set = "setRaidCooldownMisdirection",
				},
				raidCooldownMisdirectionMerged = {
					type = "toggle",
					name = "|cFFAAD372" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Misdirection"]),
					order = 302,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownMisdirectionMerged; end,
					set = function(info, value) NRC.config.raidCooldownMisdirectionMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownMisdirectionFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Misdirection"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 303,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownMisdirectionFrame; end,
					set = function(info, value) NRC.config.raidCooldownMisdirectionFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				--Mage.
				raidCooldownEvocation = {
					type = "toggle",
					name = "|cFF3FC7EB" .. L["raidCooldownEvocationTitle"],
					desc = L["raidCooldownEvocationDesc"],
					order = 401,
					width = spellWidth,
					get = "getRaidCooldownEvocation",
					set = "setRaidCooldownEvocation",
				},
				raidCooldownEvocationMerged = {
					type = "toggle",
					name = "|cFF3FC7EB" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Evocation"]),
					order = 405,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownEvocationMerged; end,
					set = function(info, value) NRC.config.raidCooldownEvocationMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownEvocationFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Evocation"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 406,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownEvocationFrame; end,
					set = function(info, value) NRC.config.raidCooldownEvocationFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownIceBlock = {
					type = "toggle",
					name = "|cFF3FC7EB" .. L["raidCooldownIceBlockTitle"],
					desc = L["raidCooldownIceBlockDesc"],
					order = 407,
					width = spellWidth,
					get = "getRaidCooldownIceBlock",
					set = "setRaidCooldownIceBlock",
				},
				raidCooldownIceBlockMerged = {
					type = "toggle",
					name = "|cFF3FC7EB" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["IceBlock"]),
					order = 408,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownIceBlockMerged; end,
					set = function(info, value) NRC.config.raidCooldownIceBlockMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownIceBlockFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["IceBlock"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 409,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownIceBlockFrame; end,
					set = function(info, value) NRC.config.raidCooldownIceBlockFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownInvisibility = {
					type = "toggle",
					name = "|cFF3FC7EB" .. L["raidCooldownInvisibilityTitle"],
					desc = L["raidCooldownInvisibilityDesc"],
					order = 410,
					width = spellWidth,
					get = "getRaidCooldownInvisibility",
					set = "setRaidCooldownInvisibility",
				},
				raidCooldownInvisibilityMerged = {
					type = "toggle",
					name = "|cFF3FC7EB" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Invisibility"]),
					order = 411,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownInvisibilityMerged; end,
					set = function(info, value) NRC.config.raidCooldownInvisibilityMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownInvisibilityFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Invisibility"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 412,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownInvisibilityFrame; end,
					set = function(info, value) NRC.config.raidCooldownInvisibilityFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				--Paladin.
				raidCooldownDivineIntervention = {
					type = "toggle",
					name = "|cFFF48CBA" .. L["raidCooldownDivineInterventionTitle"],
					desc = L["raidCooldownDivineInterventionDesc"],
					order = 501,
					width = spellWidth,
					get = "getRaidCooldownDivineIntervention",
					set = "setRaidCooldownDivineIntervention",
				},
				raidCooldownDivineInterventionMerged = {
					type = "toggle",
					name = "|cFFF48CBA" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Divine Intervention"]),
					order = 502,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownDivineInterventionMerged; end,
					set = function(info, value) NRC.config.raidCooldownDivineInterventionMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownDivineInterventionFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Divine Intervention"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 503,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownDivineInterventionFrame; end,
					set = function(info, value) NRC.config.raidCooldownDivineInterventionFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownDivineShield = {
					type = "toggle",
					name = "|cFFF48CBA" .. L["raidCooldownDivineShieldTitle"],
					desc = L["raidCooldownDivineShieldDesc"],
					order = 504,
					width = spellWidth,
					get = "getRaidCooldownDivineShield",
					set = "setRaidCooldownDivineShield",
				},
				raidCooldownDivineShieldMerged = {
					type = "toggle",
					name = "|cFFF48CBA" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Divine Shield"]),
					order = 505,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownDivineShieldMerged; end,
					set = function(info, value) NRC.config.raidCooldownDivineShieldMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownDivineShieldFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Divine Shield"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 506,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownDivineShieldFrame; end,
					set = function(info, value) NRC.config.raidCooldownDivineShieldFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownDivineProtection = {
					type = "toggle",
					name = "|cFFF48CBA" .. L["raidCooldownDivineProtectionTitle"],
					desc = L["raidCooldownDivineProtectionDesc"],
					order = 507,
					width = spellWidth,
					get = "getRaidCooldownDivineProtection",
					set = "setRaidCooldownDivineProtection",
				},
				raidCooldownDivineProtectionMerged = {
					type = "toggle",
					name = "|cFFF48CBA" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Divine Protection"]),
					order = 508,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownDivineProtectionMerged; end,
					set = function(info, value) NRC.config.raidCooldownDivineProtectionMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownDivineProtectionFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Divine Protection"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 509,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownDivineProtectionFrame; end,
					set = function(info, value) NRC.config.raidCooldownDivineProtectionFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownLayonHands = {
					type = "toggle",
					name = "|cFFF48CBA" .. L["raidCooldownLayonHandsTitle"],
					desc = L["raidCooldownLayonHandsDesc"],
					order = 510,
					width = spellWidth,
					get = "getRaidCooldownLayonHands",
					set = "setRaidCooldownLayonHands",
				},
				raidCooldownLayonHandsMerged = {
					type = "toggle",
					name = "|cFFF48CBA" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Lay on Hands"]),
					order = 511,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownLayonHandsMerged; end,
					set = function(info, value) NRC.config.raidCooldownLayonHandsMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownLayonHandsFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Lay on Hands"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 512,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownLayonHandsFrame; end,
					set = function(info, value) NRC.config.raidCooldownLayonHandsFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownBlessingofProtection = {
					type = "toggle",
					name = "|cFFF48CBA" .. L["raidCooldownBlessingofProtectionTitle"],
					desc = L["raidCooldownBlessingofProtectionDesc"],
					order = 513,
					width = spellWidth,
					get = "getRaidCooldownBlessingofProtection",
					set = "setRaidCooldownBlessingofProtection",
				},
				raidCooldownBlessingofProtectionMerged = {
					type = "toggle",
					name = "|cFFF48CBA" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Blessing of Protection"]),
					order = 514,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownBlessingofProtectionMerged; end,
					set = function(info, value) NRC.config.raidCooldownBlessingofProtectionMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownBlessingofProtectionFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Blessing of Protection"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 515,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownBlessingofProtectionFrame; end,
					set = function(info, value) NRC.config.raidCooldownBlessingofProtectionFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				--Priest.
				raidCooldownFearWard = {
					type = "toggle",
					name = "|cFFFFFFFF" .. L["raidCooldownFearWardTitle"],
					desc = L["raidCooldownFearWardDesc"],
					order = 601,
					width = spellWidth,
					get = "getRaidCooldownFearWard",
					set = "setRaidCooldownFearWard",
				},
				raidCooldownFearWardMerged = {
					type = "toggle",
					name = "|cFFFFFFFF" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Fear Ward"]),
					order = 602,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownFearWardMerged; end,
					set = function(info, value) NRC.config.raidCooldownFearWardMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownFearWardFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Fear Ward"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 603,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownFearWardFrame; end,
					set = function(info, value) NRC.config.raidCooldownFearWardFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownShadowfiend = {
					type = "toggle",
					name = "|cFFFFFFFF" .. L["raidCooldownShadowfiendTitle"],
					desc = L["raidCooldownShadowfiendDesc"],
					order = 604,
					width = spellWidth,
					get = "getRaidCooldownShadowfiend",
					set = "setRaidCooldownShadowfiend",
				},
				raidCooldownShadowfiendMerged = {
					type = "toggle",
					name = "|cFFFFFFFF" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Shadowfiend"]),
					order = 605,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownShadowfiendMerged; end,
					set = function(info, value) NRC.config.raidCooldownShadowfiendMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownShadowfiendFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Shadowfiend"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 606,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownShadowfiendFrame; end,
					set = function(info, value) NRC.config.raidCooldownShadowfiendFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownPsychicScream = {
					type = "toggle",
					name = "|cFFFFFFFF" .. L["raidCooldownPsychicScreamTitle"],
					desc = L["raidCooldownPsychicScreamDesc"],
					order = 607,
					width = spellWidth,
					get = "getRaidCooldownPsychicScream",
					set = "setRaidCooldownPsychicScream",
				},
				raidCooldownPsychicScreamMerged = {
					type = "toggle",
					name = "|cFFFFFFFF" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Psychic Scream"]),
					order = 608,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownPsychicScreamMerged; end,
					set = function(info, value) NRC.config.raidCooldownPsychicScreamMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownPsychicScreamFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Psychic Scream"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 609,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownPsychicScreamFrame; end,
					set = function(info, value) NRC.config.raidCooldownPsychicScreamFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownPowerInfusion = {
					type = "toggle",
					name = "|cFFFFFFFF" .. L["raidCooldownPowerInfusionTitle"],
					desc = L["raidCooldownPowerInfusionDesc"],
					order = 610,
					width = spellWidth,
					get = "getRaidCooldownPowerInfusion",
					set = "setRaidCooldownPowerInfusion",
				},
				raidCooldownPowerInfusionMerged = {
					type = "toggle",
					name = "|cFFFFFFFF" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Power Infusion"]),
					order = 611,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownPowerInfusionMerged; end,
					set = function(info, value) NRC.config.raidCooldownPowerInfusionMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownPowerInfusionFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Power Infusion"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 612,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownPowerInfusionFrame; end,
					set = function(info, value) NRC.config.raidCooldownPowerInfusionFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownPainSuppression = {
					type = "toggle",
					name = "|cFFFFFFFF" .. L["raidCooldownPainSuppressionTitle"],
					desc = L["raidCooldownPainSuppressionDesc"],
					order = 615,
					width = spellWidth,
					get = "getRaidCooldownPainSuppression",
					set = "setRaidCooldownPainSuppression",
				},
				raidCooldownPainSuppressionMerged = {
					type = "toggle",
					name = "|cFFFFFFFF" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Pain Suppression"]),
					order = 616,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownPainSuppressionMerged; end,
					set = function(info, value) NRC.config.raidCooldownPainSuppressionMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownPainSuppressionFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Pain Suppression"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 617,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownPainSuppressionFrame; end,
					set = function(info, value) NRC.config.raidCooldownPainSuppressionFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				--Rogue (need to add talent reduction checks later).
				raidCooldownBlind = {
					type = "toggle",
					name = "|cFFFFF468" .. L["raidCooldownBlindTitle"],
					desc = L["raidCooldownBlindDesc"],
					order = 701,
					width = spellWidth,
					get = "getRaidCooldownBlind",
					set = "setRaidCooldownBlind",
				},
				raidCooldownBlindMerged = {
					type = "toggle",
					name = "|cFFFFF468" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Blind"]),
					order = 801,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownBlindMerged; end,
					set = function(info, value) NRC.config.raidCooldownBlindMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownBlindFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Blind"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 802,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownBlindFrame; end,
					set = function(info, value) NRC.config.raidCooldownBlindFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownVanish = {
					type = "toggle",
					name = "|cFFFFF468" .. L["raidCooldownVanishTitle"],
					desc = L["raidCooldownVanishDesc"],
					order = 805,
					width = spellWidth,
					get = "getRaidCooldownVanish",
					set = "setRaidCooldownVanish",
				},
				raidCooldownVanishMerged = {
					type = "toggle",
					name = "|cFFFFF468" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Vanish"]),
					order = 806,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownVanishMerged; end,
					set = function(info, value) NRC.config.raidCooldownVanishMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownVanishFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Vanish"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 807,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownVanishFrame; end,
					set = function(info, value) NRC.config.raidCooldownVanishFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownEvasion = {
					type = "toggle",
					name = "|cFFFFF468" .. L["raidCooldownEvasionTitle"],
					desc = L["raidCooldownEvasionDesc"],
					order = 808,
					width = spellWidth,
					get = "getRaidCooldownEvasion",
					set = "setRaidCooldownEvasion",
				},
				raidCooldownEvasionMerged = {
					type = "toggle",
					name = "|cFFFFF468" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Evasion"]),
					order = 809,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownEvasionMerged; end,
					set = function(info, value) NRC.config.raidCooldownEvasionMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownEvasionFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Evasion"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 810,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownEvasionFrame; end,
					set = function(info, value) NRC.config.raidCooldownEvasionFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownDistract = {
					type = "toggle",
					name = "|cFFFFF468" .. L["raidCooldownDistractTitle"],
					desc = L["raidCooldownDistractDesc"],
					order = 811,
					width = spellWidth,
					get = "getRaidCooldownDistract",
					set = "setRaidCooldownDistract",
				},
				raidCooldownDistractMerged = {
					type = "toggle",
					name = "|cFFFFF468" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Distract"]),
					order = 812,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownDistractMerged; end,
					set = function(info, value) NRC.config.raidCooldownDistractMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownDistractFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Distract"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 813,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownDistractFrame; end,
					set = function(info, value) NRC.config.raidCooldownDistractFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				--Shaman.
				raidCooldownEarthElemental = {
					type = "toggle",
					name = "|cFF0070DD" .. L["raidCooldownEarthElementalTitle"],
					desc = L["raidCooldownEarthElementalDesc"],
					order = 901,
					width = spellWidth,
					get = "getRaidCooldownEarthElemental",
					set = "setRaidCooldownEarthElemental",
				},
				raidCooldownEarthElementalMerged = {
					type = "toggle",
					name = "|cFF0070DD" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Earth Elemental"]),
					order = 902,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownEarthElementalMerged; end,
					set = function(info, value) NRC.config.raidCooldownEarthElementalMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownEarthElementalFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Earth Elemental"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 903,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownEarthElementalFrame; end,
					set = function(info, value) NRC.config.raidCooldownEarthElementalFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownFireElemental = {
					type = "toggle",
					name = "|cFF0070DD" .. L["raidCooldownFireElementalTitle"],
					desc = L["raidCooldownFireElementalDesc"],
					order = 904,
					width = spellWidth,
					get = "getRaidCooldownFireElemental",
					set = "setRaidCooldownFireElemental",
				},
				raidCooldownFireElementalMerged = {
					type = "toggle",
					name = "|cFF0070DD" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Fire Elemental"]),
					order = 905,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownFireElementalMerged; end,
					set = function(info, value) NRC.config.raidCooldownFireElementalMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownFireElementalFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Fire Elemental"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 906,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownFireElementalFrame; end,
					set = function(info, value) NRC.config.raidCooldownFireElementalFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownReincarnation = {
					type = "toggle",
					name = "|cFF0070DD" .. L["raidCooldownReincarnationTitle"],
					desc = L["raidCooldownReincarnationDesc"],
					order = 907,
					width = spellWidth,
					get = "getRaidCooldownReincarnation",
					set = "setRaidCooldownReincarnation",
				},
				raidCooldownReincarnationMerged = {
					type = "toggle",
					name = "|cFF0070DD" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Reincarnation"]),
					order = 908,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownReincarnationMerged; end,
					set = function(info, value) NRC.config.raidCooldownReincarnationMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownReincarnationFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Reincarnation"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 909,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownReincarnationFrame; end,
					set = function(info, value) NRC.config.raidCooldownReincarnationFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownManaTide = {
					type = "toggle",
					name = "|cFF0070DD" .. L["raidCooldownManaTideTitle"],
					desc = L["raidCooldownManaTideDesc"],
					order = 910,
					width = spellWidth,
					get = "getRaidCooldownManaTide",
					set = "setRaidCooldownManaTide",
				},
				raidCooldownManaTideMerged = {
					type = "toggle",
					name = "|cFF0070DD" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Mana Tide"]),
					order = 911,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownManaTideMerged; end,
					set = function(info, value) NRC.config.raidCooldownManaTideMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownManaTideFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Mana Tide"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 912,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownManaTideFrame; end,
					set = function(info, value) NRC.config.raidCooldownManaTideFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				--Warlock.
				raidCooldownSoulstone = {
					type = "toggle",
					name = "|cFF8788EE" .. L["raidCooldownSoulstoneTitle"],
					desc = L["raidCooldownSoulstoneDesc"],
					order = 1001,
					width = spellWidth,
					get = "getRaidCooldownSoulstone",
					set = "setRaidCooldownSoulstone",
				},
				raidCooldownSoulstoneMerged = {
					type = "toggle",
					name = "|cFF8788EE" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Soulstone"]),
					order = 1002,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownSoulstoneMerged; end,
					set = function(info, value) NRC.config.raidCooldownSoulstoneMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownSoulstoneFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Soulstone"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1003,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownSoulstoneFrame; end,
					set = function(info, value) NRC.config.raidCooldownSoulstoneFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownSoulshatter = {
					type = "toggle",
					name = "|cFF8788EE" .. L["raidCooldownSoulshatterTitle"],
					desc = L["raidCooldownSoulshatterDesc"],
					order = 1004,
					width = spellWidth,
					get = "getRaidCooldownSoulshatter",
					set = "setRaidCooldownSoulshatter",
				},
				raidCooldownSoulshatterMerged = {
					type = "toggle",
					name = "|cFF8788EE" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Soulshatter"]),
					order = 1005,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownSoulshatterMerged; end,
					set = function(info, value) NRC.config.raidCooldownSoulshatterMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownSoulshatterFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Soulshatter"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1006,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownSoulshatterFrame; end,
					set = function(info, value) NRC.config.raidCooldownSoulshatterFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownDeathCoil = {
					type = "toggle",
					name = "|cFF8788EE" .. L["raidCooldownDeathCoilTitle"],
					desc = L["raidCooldownDeathCoilDesc"],
					order = 1007,
					width = spellWidth,
					get = "getRaidCooldownDeathCoil",
					set = "setRaidCooldownDeathCoil",
				},
				raidCooldownDeathCoilMerged = {
					type = "toggle",
					name = "|cFF8788EE" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Death Coil"]),
					order = 1008,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownDeathCoilMerged; end,
					set = function(info, value) NRC.config.raidCooldownDeathCoilMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownDeathCoilFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Death Coil"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1009,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownDeathCoilFrame; end,
					set = function(info, value) NRC.config.raidCooldownDeathCoilFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				--[[raidCooldownRitualofSouls = {
					type = "toggle",
					name = "|cFF8788EE" .. L["raidCooldownRitualofSoulsTitle"],
					desc = L["raidCooldownRitualofSoulsDesc"],
					order = 180,
					width = spellWidth,
					get = "getRaidCooldownRitualofSouls",
					set = "setRaidCooldownRitualofSouls",
				},]]
				--Warrior.
				raidCooldownChallengingShout = {
					type = "toggle",
					name = "|cFFC69B6D" .. L["raidCooldownChallengingShoutTitle"],
					desc = L["raidCooldownChallengingShoutDesc"],
					order = 1101,
					width = spellWidth,
					get = "getRaidCooldownChallengingShout",
					set = "setRaidCooldownChallengingShout",
				},
				raidCooldownChallengingShoutMerged = {
					type = "toggle",
					name = "|cFFC69B6D" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Challenging Shout"]),
					order = 1102,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownChallengingShoutMerged; end,
					set = function(info, value) NRC.config.raidCooldownChallengingShoutMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownChallengingShoutFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Challenging Shout"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1103,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownChallengingShoutFrame; end,
					set = function(info, value) NRC.config.raidCooldownChallengingShoutFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownIntimidatingShout = {
					type = "toggle",
					name = "|cFFC69B6D" .. L["raidCooldownIntimidatingShoutTitle"],
					desc = L["raidCooldownIntimidatingShoutDesc"],
					order = 1104,
					width = spellWidth,
					get = "getRaidCooldownIntimidatingShout",
					set = "setRaidCooldownIntimidatingShout",
				},
				raidCooldownIntimidatingShoutMerged = {
					type = "toggle",
					name = "|cFFC69B6D" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Intimidating Shout"]),
					order = 1105,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownIntimidatingShoutMerged; end,
					set = function(info, value) NRC.config.raidCooldownIntimidatingShoutMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownIntimidatingShoutFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Intimidating Shout"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1106,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownIntimidatingShoutFrame; end,
					set = function(info, value) NRC.config.raidCooldownIntimidatingShoutFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownMockingBlow = {
					type = "toggle",
					name = "|cFFC69B6D" .. L["raidCooldownMockingBlowTitle"],
					desc = L["raidCooldownMockingBlowDesc"],
					order = 1107,
					width = spellWidth,
					get = "getRaidCooldownMockingBlow",
					set = "setRaidCooldownMockingBlow",
				},
				raidCooldownMockingBlowMerged = {
					type = "toggle",
					name = "|cFFC69B6D" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Mocking Blow"]),
					order = 1108,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownMockingBlowMerged; end,
					set = function(info, value) NRC.config.raidCooldownMockingBlowMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownMockingBlowFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Mocking Blow"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1109,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownMockingBlowFrame; end,
					set = function(info, value) NRC.config.raidCooldownMockingBlowFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownRecklessness = {
					type = "toggle",
					name = "|cFFC69B6D" .. L["raidCooldownRecklessnessTitle"],
					desc = L["raidCooldownRecklessnessDesc"],
					order = 1110,
					width = spellWidth,
					get = "getRaidCooldownRecklessness",
					set = "setRaidCooldownRecklessness",
				},
				raidCooldownRecklessnessMerged = {
					type = "toggle",
					name = "|cFFC69B6D" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Recklessness"]),
					order = 1112,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownRecklessnessMerged; end,
					set = function(info, value) NRC.config.raidCooldownRecklessnessMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownRecklessnessFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Recklessness"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1113,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownRecklessnessFrame; end,
					set = function(info, value) NRC.config.raidCooldownRecklessnessFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownShieldWall = {
					type = "toggle",
					name = "|cFFC69B6D" .. L["raidCooldownShieldWallTitle"],
					desc = L["raidCooldownShieldWallDesc"],
					order = 1115,
					width = spellWidth,
					get = "getRaidCooldownShieldWall",
					set = "setRaidCooldownShieldWall",
				},
				raidCooldownShieldWallMerged = {
					type = "toggle",
					name = "|cFFC69B6D" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["Shield Wall"]),
					order = 1116,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownShieldWallMerged; end,
					set = function(info, value) NRC.config.raidCooldownShieldWallMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownShieldWallFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["Shield Wall"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1117,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownShieldWallFrame; end,
					set = function(info, value) NRC.config.raidCooldownShieldWallFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNecksHeader = {
					type = "header",
					name = L["raidCooldownNecksHeaderDesc"],
					order = 1320,
				},
				raidCooldownNeckSP = {
					type = "toggle",
					name = "|cFF9CD6DE" .. "|TInterface\\Icons\\inv_jewelry_necklace_28:16:16|t " .. L["raidCooldownNeckSPTitle"],
					desc = L["raidCooldownNeckSPDesc"],
					order = 1321,
					width = spellWidth,
					get = "getRaidCooldownNeckSP",
					set = "setRaidCooldownNeckSP",
				},
				raidCooldownNeckSPMerged = {
					type = "toggle",
					name = "|cFF9CD6DE" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["raidCooldownNeckSPDesc"]),
					order = 1322,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownNeckSPMerged; end,
					set = function(info, value) NRC.config.raidCooldownNeckSPMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNeckSPFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["raidCooldownNeckSPDesc"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1323,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownNeckSPFrame; end,
					set = function(info, value) NRC.config.raidCooldownNeckSPFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNeckCrit = {
					type = "toggle",
					name = "|cFF9CD6DE" .. "|TInterface\\Icons\\inv_jewelry_necklace_ahnqiraj_02:16:16|t " .. L["raidCooldownNeckCritTitle"],
					desc = L["raidCooldownNeckCritDesc"],
					order = 1324,
					width = spellWidth,
					get = "getRaidCooldownNeckCrit",
					set = "setRaidCooldownNeckCrit",
				},
				raidCooldownNeckCritMerged = {
					type = "toggle",
					name = "|cFF9CD6DE" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["raidCooldownNeckCritDesc"]),
					order = 1325,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownNeckCritMerged; end,
					set = function(info, value) NRC.config.raidCooldownNeckCritMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNeckCritFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["raidCooldownNeckCritDesc"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1326,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownNeckCritFrame; end,
					set = function(info, value) NRC.config.raidCooldownNeckCritFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNeckCritRating = {
					type = "toggle",
					name = "|cFF9CD6DE" .. "|TInterface\\Icons\\inv_jewelry_necklace_07:16:16|t " .. L["raidCooldownNeckCritRatingTitle"],
					desc = L["raidCooldownNeckCritRatingDesc"],
					order = 1327,
					width = spellWidth,
					get = "getRaidCooldownNeckCritRating",
					set = "setRaidCooldownNeckCritRating",
				},
				raidCooldownNeckCritRatingMerged = {
					type = "toggle",
					name = "|cFF9CD6DE" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["raidCooldownNeckCritRatingDesc"]),
					order = 1328,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownNeckCritRatingMerged; end,
					set = function(info, value) NRC.config.raidCooldownNeckCritRatingMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNeckCritRatingFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["raidCooldownNeckCritRatingDesc"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1329,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownNeckCritRatingFrame; end,
					set = function(info, value) NRC.config.raidCooldownNeckCritRatingFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNeckStam = {
					type = "toggle",
					name = "|cFF9CD6DE" .. "|TInterface\\Icons\\inv_jewelry_necklace_17:16:16|t " .. L["raidCooldownNeckStamTitle"],
					desc = L["raidCooldownNeckStamDesc"],
					order = 1330,
					width = spellWidth,
					get = "getRaidCooldownNeckStam",
					set = "setRaidCooldownNeckStam",
				},
				raidCooldownNeckStamMerged = {
					type = "toggle",
					name = "|cFF9CD6DE" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["raidCooldownNeckStamDesc"]),
					order = 1331,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownNeckStamMerged; end,
					set = function(info, value) NRC.config.raidCooldownNeckStamMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNeckStamFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["raidCooldownNeckStamDesc"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1332,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownNeckStamFrame; end,
					set = function(info, value) NRC.config.raidCooldownNeckStamFrame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNeckHP5 = {
					type = "toggle",
					name = "|cFF9CD6DE" .. "|TInterface\\Icons\\inv_jewelry_necklace_15:16:16|t " .. L["raidCooldownNeckHP5Title"],
					desc = L["raidCooldownNeckHP5Desc"],
					order = 1333,
					width = spellWidth,
					get = "getRaidCooldownNeckHP5",
					set = "setRaidCooldownNeckHP5",
				},
				raidCooldownNeckHP5Merged = {
					type = "toggle",
					name = "|cFF9CD6DE" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["raidCooldownNeckHP5Desc"]),
					order = 1334,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownNeckHP5Merged; end,
					set = function(info, value) NRC.config.raidCooldownNeckHP5Merged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNeckHP5Frame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["raidCooldownNeckHP5Desc"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1335,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownNeckHP5Frame; end,
					set = function(info, value) NRC.config.raidCooldownNeckHP5Frame = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNeckStats = {
					type = "toggle",
					name = "|cFF9CD6DE" .. "|TInterface\\Icons\\inv_jewelry_necklace_29naxxramas:16:16|t " .. L["raidCooldownNeckStatsTitle"],
					desc = L["raidCooldownNeckStatsDesc"],
					order = 1336,
					width = spellWidth,
					get = "getRaidCooldownNeckStats",
					set = "setRaidCooldownNeckStats",
				},
				raidCooldownNeckStatsMerged = {
					type = "toggle",
					name = "|cFF9CD6DE" .. L["Merged"],
					desc = string.format(L["mergedDesc"], L["raidCooldownNeckStatsDesc"]),
					order = 1337,
					width = mergedWidth,
					get = function(info) return NRC.config.raidCooldownNeckStatsMerged; end,
					set = function(info, value) NRC.config.raidCooldownNeckStatsMerged = value; NRC:reloadRaidCooldowns(); end,
				},
				raidCooldownNeckStatsFrame = {
					type = "select",
					name = "",
					desc = string.format(L["frameDesc"], L["raidCooldownNeckStatsDesc"]),
					values = setCooldownFrameOption(true),
					sorting = setCooldownFrameOption(),
					order = 1338,
					width = frameWidth,
					get = function(info) return NRC.config.raidCooldownNeckStatsFrame; end,
					set = function(info, value) NRC.config.raidCooldownNeckStatsFrame = value; NRC:reloadRaidCooldowns(); end,
				},
			},
		},
		raidStatus = {
			name = "Raid Status",
			desc = "Raid status tracking, flasks, buffs, durability, etc.",
			type = "group",
			order = 41,
			args = {
				mainText = {
					type = "description",
					name = "|cFF3CE13F" .. L["raidStatusTextDesc"],
					fontSize = "medium",
					order = 1,
				},
				raidStatusScale = {
					type = "range",
					name = L["raidStatusScaleTitle"],
					desc = L["raidStatusScaleDesc"],
					order = 2,
					get = "getRaidStatusScale",
					set = "setRaidStatusScale",
					min = 0.3,
					max = 1.7,
					softMin = 0.3,
					softMax = 1.7,
					step = 0.01,
					width = 2,
				},
				raidStatusShowReadyCheck = {
					type = "toggle",
					name = L["raidStatusShowReadyCheckTitle"],
					desc = L["raidStatusShowReadyCheckDesc"],
					order = 6,
					get = "getRaidStatusShowReadyCheck",
					set = "setRaidStatusShowReadyCheck",
				},
				raidStatusFadeReadyCheck = {
					type = "toggle",
					name = L["raidStatusFadeReadyCheckTitle"],
					desc = L["raidStatusFadeReadyCheckDesc"],
					order = 7,
					get = "getRaidStatusFadeReadyCheck",
					set = "setRaidStatusFadeReadyCheck",
					width = 1.2,
				},
				raidStatusFont = {
					type = "select",
					name = L["raidStatusFontTitle"],
					desc = L["raidStatusFontDesc"],
					values = NRC.LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					order = 8,
					get = "getRaidStatusFont",
					set = "setRaidStatusFont",
				},
				raidStatusFontSize = {
					type = "range",
					name = L["raidStatusFontSizeTitle"],
					desc = L["raidStatusFontSizeDesc"],
					order = 9,
					get = "getRaidStatusFontSize",
					set = "setRaidStatusFontSize",
					min = 6,
					max = 20,
					softMin = 6,
					softMax = 20,
					step = 1,
				},
				--[[raidStatusFontOutline = {
					type = "select",
					name = L["raidStatusFontOutlineTitle"],
					desc = L["raidStatusFontOutlineDesc"],
					values = {
						["NONE"] = L["None"],
						["OUTLINE"] = L["Thin Outline"],
						["THICKOUTLINE"] = L["Thick Outline"],
					},
					sorting = {
						[1] = "NONE",
						[2] = "OUTLINE",
						[3] = "THICKOUTLINE",
					},
					order = 10,
					get = "getRaidStatusFontOutline",
					set = "setRaidStatusFontOutline",
				},]]
				raidStatusHideCombat = {
					type = "toggle",
					name = L["raidStatusHideCombatTitle"],
					desc = L["raidStatusHideCombatDesc"],
					order = 11,
					get = "getRaidStatusHideCombat",
					set = "setRaidStatusHideCombat",
				},
				sortRaidStatusByGroupsColor = {
					type = "toggle",
					name = L["sortRaidStatusByGroupsColorTitle"],
					desc = L["sortRaidStatusByGroupsColorDesc"],
					order = 12,
					get = "getSortRaidStatusByGroupsColor",
					set = "setSortRaidStatusByGroupsColor",
				},
				sortRaidStatusByGroupsColorBackground = {
					type = "toggle",
					name = L["sortRaidStatusByGroupsColorBackgroundTitle"],
					desc = L["sortRaidStatusByGroupsColorBackgroundDesc"],
					order = 13,
					get = "getSortRaidStatusByGroupsColorBackground",
					set = "setSortRaidStatusByGroupsColorBackground",
				},
				raidCooldownSpellsHeader = {
					type = "header",
					name = L["raidStatusColumsHeaderDesc"],
					order = 20,
				},
				raidStatusFlask = {
					type = "toggle",
					name = L["raidStatusFlaskTitle"],
					desc = L["raidStatusFlaskDesc"],
					order = 21,
					get = "getRaidStatusFlask",
					set = "setRaidStatusFlask",
				},
				raidStatusFood = {
					type = "toggle",
					name = L["raidStatusFoodTitle"],
					desc = L["raidStatusFoodDesc"],
					order = 22,
					get = "getRaidStatusFood",
					set = "setRaidStatusFood",
				},
				raidStatusScroll = {
					type = "toggle",
					name = L["raidStatusScrollTitle"],
					desc = L["raidStatusScrollDesc"],
					order = 23,
					get = "getRaidStatusScroll",
					set = "setRaidStatusScroll",
				},
				raidStatusInt = {
					type = "toggle",
					name = L["raidStatusIntTitle"],
					desc = L["raidStatusIntDesc"],
					order = 24,
					get = "getRaidStatusInt",
					set = "setRaidStatusInt",
				},
				raidStatusFort = {
					type = "toggle",
					name = L["raidStatusFortTitle"],
					desc = L["raidStatusFortDesc"],
					order = 25,
					get = "getRaidStatusFort",
					set = "setRaidStatusFort",
				},
				raidStatusSpirit = {
					type = "toggle",
					name = L["raidStatusSpiritTitle"],
					desc = L["raidStatusSpiritDesc"],
					order = 27,
					get = "getRaidStatusSpirit",
					set = "setRaidStatusSpirit",
				},
				raidStatusShadow = {
					type = "toggle",
					name = L["raidStatusShadowTitle"],
					desc = L["raidStatusShadowDesc"],
					order = 28,
					get = "getRaidStatusShadow",
					set = "setRaidStatusShadow",
				},
				raidStatusMotw = {
					type = "toggle",
					name = L["raidStatusMotwTitle"],
					desc = L["raidStatusMotwDesc"],
					order = 29,
					get = "getRaidStatusMotw",
					set = "setRaidStatusMotw",
				},
				raidStatusPal = {
					type = "toggle",
					name = L["raidStatusPalTitle"],
					desc = L["raidStatusPalDesc"],
					order = 30,
					get = "getRaidStatusPal",
					set = "setRaidStatusPal",
				},
				raidStatusDura = {
					type = "toggle",
					name = L["raidStatusDuraTitle"],
					desc = L["raidStatusDuraDesc"],
					order = 31,
					get = "getRaidStatusDura",
					set = "setRaidStatusDura",
				},
				raidStatusExpandHeader = {
					type = "header",
					name = L["raidStatusExpandHeaderDesc"],
					order = 40,
				},
				raidStatusExpandText = {
					type = "description",
					name = "|cFF9CD6DE" .. L["raidStatusExpandTextDesc"],
					fontSize = "medium",
					order = 41,
				},
				raidStatusShadowRes = {
					type = "toggle", --0, 1.0, 0.453125, 0.56640625 first 2 args multipled by width, 2nd 2 multiplied by height?
					name = "|TInterface\\PaperDollInfoFrame\\UI-Character-ResistanceIcons:22:26:0:0:32:256:0:32:116:145|t " .. L["raidStatusShadowResTitle"],
					desc = L["raidStatusShadowResDesc"],
					order = 42,
					get = "getRaidStatusShadowRes",
					set = "setRaidStatusShadowRes",
				},
				raidStatusFireRes = {
					type = "toggle",
					name = "|TInterface\\PaperDollInfoFrame\\UI-Character-ResistanceIcons:22:26:0:0:32:256:0:32:0:29|t " .. L["raidStatusFireResTitle"],
					desc = L["raidStatusFireResDesc"],
					order = 43,
					get = "getRaidStatusFireRes",
					set = "setRaidStatusFireRes",
				},
				raidStatusNatureRes = {
					type = "toggle",
					name = "|TInterface\\PaperDollInfoFrame\\UI-Character-ResistanceIcons:22:26:0:0:32:256:0:32:29:58|t " .. L["raidStatusNatureResTitle"],
					desc = L["raidStatusNatureResDesc"],
					order = 44,
					get = "getRaidStatusNatureRes",
					set = "setRaidStatusNatureRes",
				},
				raidStatusFrostRes = {
					type = "toggle",
					name = "|TInterface\\PaperDollInfoFrame\\UI-Character-ResistanceIcons:22:26:0:0:32:256:0:32:87:116|t " .. L["raidStatusFrostResTitle"],
					desc = L["raidStatusFrostResDesc"],
					order = 45,
					get = "getRaidStatusFrostRes",
					set = "setRaidStatusFrostRes",
				},
				raidStatusArcaneRes = {
					type = "toggle",
					name = "|TInterface\\PaperDollInfoFrame\\UI-Character-ResistanceIcons:22:26:0:0:32:256:0:32:58:87|t " .. L["raidStatusArcaneResTitle"],
					desc = L["raidStatusArcaneResDesc"],
					order = 46,
					get = "getRaidStatusArcaneRes",
					set = "setRaidStatusArcaneRes",
				},
				raidStatusWeaponEnchants = {
					type = "toggle",
					name = L["raidStatusWeaponEnchantsTitle"],
					desc = L["raidStatusWeaponEnchantsDesc"],
					order = 47,
					get = "getRaidStatusWeaponEnchants",
					set = "setRaidStatusWeaponEnchants",
				},
				raidStatusTalents = {
					type = "toggle",
					name = L["raidStatusTalentsTitle"],
					desc = L["raidStatusTalentsDesc"],
					order = 48,
					get = "getRaidStatusTalents",
					set = "setRaidStatusTalents",
				},
				raidStatusExpandAlways = {
					type = "toggle",
					name = L["raidStatusExpandAlwaysTitle"],
					desc = L["raidStatusExpandAlwaysDesc"],
					order = 49,
					get = "getRaidStatusExpandAlways",
					set = "setRaidStatusExpandAlways",
				},
			},
		},
		raidMana = {
			name = "Raid Mana",
			desc = "Track healer mana or any class you choose.",
			type = "group",
			order = 42,
			args = {
				mainText = {
					type = "description",
					name = "|cFF3CE13F" .. L["raidManaMainTextDesc"],
					fontSize = "medium",
					order = 1,
				},
				raidManaEnabled = {
					type = "toggle",
					name = L["raidManaEnabledTitle"],
					desc = L["raidManaEnabledDesc"],
					order = 3,
					get = "getRaidManaEnabled",
					set = "setRaidManaEnabled",
				},
				raidManaEnabledEverywhere = {
					type = "toggle",
					name = L["raidManaEnabledEverywhereTitle"],
					desc = L["raidManaEnabledEverywhereDesc"],
					order = 4,
					get = "getRaidManaEnabledEverywhere",
					set = "setRaidManaEnabledEverywhere",
				},
				raidManaEnabledRaid = {
					type = "toggle",
					name = L["raidManaEnabledRaidTitle"],
					desc = L["raidManaEnabledRaidDesc"],
					order = 6,
					get = "getRaidManaEnabledRaid",
					set = "setRaidManaEnabledRaid",
				},
				raidManaEnabledPvP = {
					type = "toggle",
					name = L["raidManaEnabledPvPTitle"],
					desc = L["raidManaEnabledPvPDesc"],
					order = 7,
					get = "getRaidManaEnabledPvP",
					set = "setRaidManaEnabledPvP",
				},
				raidManaAverage = {
					type = "toggle",
					name = L["raidManaAverageTitle"],
					desc = L["raidManaAverageDesc"],
					order = 10,
					get = "getRaidManaAverage",
					set = "setRaidManaAverage",
				},
				raidManaShowSelf = {
					type = "toggle",
					name = L["raidManaShowSelfTitle"],
					desc = L["raidManaShowSelfDesc"],
					order = 11,
					get = "getRaidManaShowSelf",
					set = "setRaidManaShowSelf",
				},
				raidManaResurrection = {
					type = "toggle",
					name = L["raidManaResurrectionTitle"],
					desc = L["raidManaResurrectionDesc"],
					order = 12,
					get = "getRaidManaResurrection",
					set = "setRaidManaResurrection",
				},
				raidManaResurrectionDir = {
					type = "select",
					name = L["raidManaResurrectionDirTitle"],
					desc = L["raidManaResurrectionDirDesc"],
					values = {
						[1] = "Auto",
						[2] = "Left",
						[3] = "Right",
					},
					sorting = {
						[1] = 1,
						[2] = 2,
						[3] = 3,
					},
					order = 13,
					get = "getRaidManaResurrectionDir",
					set = "setRaidManaResurrectionDir",
				},
				raidManaLayoutHeader = {
					type = "header",
					name = "|cFFFF6900" .. L["Layout"],
					order = 20,
				},
				raidManaGrowthDirection = {
					type = "select",
					name = L["raidManaGrowthDirectionTitle"],
					desc = L["raidManaGrowthDirectionDesc"],
					values = {
						[1] = "Down",
						[2] = "Up",
					},
					sorting = {
						[1] = 2,
						[2] = 1,
					},
					order = 21,
					get = "getRaidManaGrowthDirection",
					set = "setRaidManaGrowthDirection",
				},
				raidManaScale = {
					type = "range",
					name = L["raidManaScaleTitle"],
					desc = L["raidManaScaleDesc"],
					order = 22,
					get = "getRaidManaScale",
					set = "setRaidManaScale",
					min = 0.3,
					max = 2,
					softMin = 0.3,
					softMax = 2,
					step = 0.05,
					width = 1,
				},
				raidManaWidth = {
					type = "range",
					name = L["raidManaWidthTitle"],
					desc = L["raidManaWidthDesc"],
					order = 24,
					get = "getRaidManaWidth",
					set = "setRaidManaWidth",
					min = 10,
					max = 400,
					softMin = 10,
					softMax = 400,
					step = 1,
				},
				raidManaHeight = {
					type = "range",
					name = L["raidManaHeightTitle"],
					desc = L["raidManaHeightDesc"],
					order = 25,
					get = "getRaidManaHeight",
					set = "setRaidManaHeight",
					min = 10,
					max = 50,
					softMin = 10,
					softMax = 50,
					step = 1,
				},
				raidManaBackdropAlpha = {
					type = "range",
					name = L["raidManaBackdropAlphaTitle"],
					desc = L["raidManaBackdropAlphaDesc"],
					order = 27,
					get = "getRaidManaBackdropAlpha",
					set = "setRaidManaBackdropAlpha",
					min = 0,
					max = 1,
					softMin = 0,
					softMax = 1,
					step = 0.05,
				},
				raidManaBorderAlpha = {
					type = "range",
					name = L["raidManaBorderAlphaTitle"],
					desc = L["raidManaBorderAlphaDesc"],
					order = 28,
					get = "getRaidManaBorderAlpha",
					set = "setRaidManaBorderAlpha",
					min = 0,
					max = 1,
					softMin = 0,
					softMax = 1,
					step = 0.05,
				},
				raidManaUpdateInterval = {
					type = "range",
					name = L["raidManaUpdateIntervalTitle"],
					desc = L["raidManaUpdateIntervalDesc"],
					order = 29,
					get = "getRaidManaUpdateInterval",
					set = "setRaidManaUpdateInterval",
					min = 0.1,
					max = 1,
					softMin = 0.1,
					softMax = 1,
					step = 0.05,
				},
				raidManaSortOrder = {
					type = "select",
					name = L["raidManaSortOrderTitle"],
					desc = L["raidManaSortOrderDesc"],
					values = {
						[1] = "Class Then Name",
						[2] = "Name (Ascending)",
						[3] = "Name (Descending)",
						[4] = "Most Mana",
						[5] = "Least Mana",
					},
					sorting = {
						[1] = 1,
						[2] = 2,
						[3] = 3,
						[4] = 4,
						[5] = 5,
					},
					order = 30,
					get = "getRaidManaSortOrder",
					set = "setRaidManaSortOrder",
				},
				raidManaFont = {
					type = "select",
					name = L["raidManaFontTitle"],
					desc = L["raidManaFontDesc"],
					values = NRC.LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					order = 31,
					get = "getRaidManaFont",
					set = "setRaidManaFont",
				},
				raidManaFontNumbers = {
					type = "select",
					name = L["raidManaFontNumbersTitle"],
					desc = L["raidManaFontNumbersDesc"],
					values = NRC.LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					order = 32,
					get = "getRaidManaFontNumbers",
					set = "setRaidManaFontNumbers",
				},
				raidManaFontSize = {
					type = "range",
					name = L["raidManaFontSizeTitle"],
					desc = L["raidManaFontSizeDesc"],
					order = 33,
					get = "getRaidManaFontSize",
					set = "setRaidManaFontSize",
					min = 6,
					max = 20,
					softMin = 6,
					softMax = 20,
					step = 1,
				},
				raidManaFontOutline = {
					type = "select",
					name = L["raidManaFontOutlineTitle"],
					desc = L["raidManaFontOutlineDesc"],
					values = {
						["NONE"] = L["None"],
						["OUTLINE"] = L["Thin Outline"],
						["THICKOUTLINE"] = L["Thick Outline"],
					},
					sorting = {
						[1] = "NONE",
						[2] = "OUTLINE",
						[3] = "THICKOUTLINE",
					},
					order = 34,
					get = "getRaidManaFontOutline",
					set = "setRaidManaFontOutline",
				},
				raidManaSpellsHeader = {
					type = "header",
					name = "|cFFFF6900" .. L["Players Shown"],
					order = 40,
				},
				raidManaHealers = {
					type = "toggle",
					name = L["raidManaHealersTitle"],
					desc = L["raidManaHealersDesc"],
					order = 41,
					get = "getRaidManaHealers",
					set = "setRaidManaHealers",
				},
				raidManaDruid = {
					type = "toggle",
					name = "|cFFFF7C0ADruids",
					desc = L["raidManaDruidDesc"],
					order = 45,
					get = "getRaidManaDruid",
					set = "setRaidManaDruid",
				},
				raidManaHunter = {
					type = "toggle",
					name = "|cFFAAD372Hunters",
					desc = L["raidManaHunterDesc"],
					order = 46,
					get = "getRaidManaHunter",
					set = "setRaidManaHunter",
				},
				raidManaMage = {
					type = "toggle",
					name = "|cFF3FC7EBMages",
					desc = L["raidManaMageDesc"],
					order = 47,
					get = "getRaidManaMage",
					set = "setRaidManaMage",
				},
				raidManaPaladin = {
					type = "toggle",
					name = "|cFFF48CBAPaladins",
					desc = L["raidManaPaladinDesc"],
					order = 48,
					get = "getRaidManaPaladin",
					set = "setRaidManaPaladin",
				},
				raidManaPriest = {
					type = "toggle",
					name = "|cFFFFFFFFPriests",
					desc = L["raidManaPriestDesc"],
					order = 49,
					get = "getRaidManaPriest",
					set = "setRaidManaPriest",
				},
				raidManaShaman = {
					type = "toggle",
					name = "|cFF0070DDShamans",
					desc = L["raidManaShamanDesc"],
					order = 50,
					get = "getRaidManaShaman",
					set = "setRaidManaShaman",
				},
				raidManaWarlock = {
					type = "toggle",
					name = "|cFF8788EEWarlocks",
					desc = L["raidManaWarlockDesc"],
					order = 51,
					get = "getRaidManaWarlock",
					set = "setRaidManaWarlock",
				},
			},
		},
		scrollingRaidEvents = {
			name = "Scrolling Raid Events",
			desc = "A scrolling frame that shows raid events as they happen.",
			type = "group",
			order = 43,
			args = {
				mainText = {
					type = "description",
					name = "|cFF3CE13F" .. L["sreMainTextDesc"],
					fontSize = "medium",
					order = 1,
				},
				sreEnabled = {
					type = "toggle",
					name = L["sreEnabledTitle"],
					desc = L["sreEnabledDesc"],
					order = 3,
					get = "getSreEnabled",
					set = "setSreEnabled",
				},
				sreEnabledEverywhere = {
					type = "toggle",
					name = L["sreEnabledEverywhereTitle"],
					desc = L["sreEnabledEverywhereDesc"],
					order = 5,
					get = "getSreEnabledEverywhere",
					set = "setSreEnabledEverywhere",
				},
				sreEnabledRaid = {
					type = "toggle",
					name = L["sreEnabledRaidTitle"],
					desc = L["sreEnabledRaidDesc"],
					order = 6,
					get = "getSreEnabledRaid",
					set = "setSreEnabledRaid",
				},
				sreEnabledPvP = {
					type = "toggle",
					name = L["sreEnabledPvPTitle"],
					desc = L["sreEnabledPvPDesc"],
					order = 7,
					get = "getSreEnabledPvP",
					set = "setSreEnabledPvP",
				},
				sreGroupMembers = {
					type = "toggle",
					name = L["sreGroupMembersTitle"],
					desc = L["sreGroupMembersDesc"],
					order = 8,
					get = "getSreGroupMembers",
					set = "setSreGroupMembers",
				},
				sreAllPlayers = {
					type = "toggle",
					name = L["sreAllPlayersTitle"],
					desc = L["sreAllPlayersDesc"],
					order = 10,
					get = "getSreAllPlayers",
					set = "setSreAllPlayers",
				},
				sreNpcs = {
					type = "toggle",
					name = L["sreNpcsTitle"],
					desc = L["sreNpcsDesc"],
					order = 11,
					get = "getSreNpcs",
					set = "setSreNpcs",
				},
				sreNpcsRaidOnly = {
					type = "toggle",
					name = L["sreNpcsRaidOnlyTitle"],
					desc = L["sreNpcsRaidOnlyDesc"],
					order = 12,
					get = "getSreNpcsRaidOnly",
					set = "setSreNpcsRaidOnly",
					width = 1.1,
				},
				sreShowSelf = {
					type = "toggle",
					name = L["sreShowSelfTitle"],
					desc = L["sreShowSelfDesc"],
					order = 15,
					get = "getSreShowSelf",
					set = "setSreShowSelf",
				},
				sreShowSelfRaidOnly = {
					type = "toggle",
					name = L["sreShowSelfRaidOnlyTitle"],
					desc = L["sreShowSelfRaidOnlyDesc"],
					order = 16,
					get = "getSreShowSelfRaidOnly",
					set = "setSreShowSelfRaidOnly",
					width = 1.1,
				},
				sreLayoutHeader = {
					type = "header",
					name = "|cFFFF6900" .. L["Layout"],
					order = 20,
				},
				sreAnimationSpeed = {
					type = "range",
					name = L["sreAnimationSpeedTitle"],
					desc = L["sreAnimationSpeedDesc"],
					order = 21,
					get = "getSreAnimationSpeed",
					set = "setSreAnimationSpeed",
					min = 1,
					max = 200,
					softMin = 1,
					softMax = 200,
					step = 1,
					width = 2,
				},
				sreLineFrameScale = {
					type = "range",
					name = L["sreLineFrameScaleTitle"],
					desc = L["sreLineFrameScaleDesc"],
					order = 22,
					get = "getSreLineFrameScale",
					set = "setSreLineFrameScale",
					min = 0.3,
					max = 2,
					softMin = 0.3,
					softMax = 2,
					step = 0.05,
					width = 1,
				},
				sreScrollHeight = {
					type = "range",
					name = L["sreScrollHeightTitle"],
					desc = L["sreScrollHeightDesc"],
					order = 23,
					get = "getSreScrollHeight",
					set = "setSreScrollHeight",
					min = 100,
					max = 600,
					softMin = 100,
					softMax = 600,
					step = 1,
					width = 1,
				},
				sreGrowthDirection = {
					type = "select",
					name = L["sreGrowthDirectionTitle"],
					desc = L["sreGrowthDirectionDesc"],
					values = {
						[1] = "Up",
						[2] = "Down",
					},
					sorting = {
						[1] = 1,
						[2] = 2,
					},
					order = 26,
					get = "getSreGrowthDirection",
					set = "setSreGrowthDirection",
				},
				sreAlignment = {
					type = "select",
					name = L["sreAlignmentTitle"],
					desc = L["sreAlignmentDesc"],
					values = {
						[1] = "Left",
						[2] = "Middle",
						[3] = "Right",
					},
					sorting = {
						[1] = 1,
						[2] = 2,
						[3] = 3,
					},
					order = 27,
					get = "getSreAlignment",
					set = "setSreAlignment",
				},
				sreFont = {
					type = "select",
					name = L["sreFontTitle"],
					desc = L["sreFontDesc"],
					values = NRC.LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					order = 28,
					get = "getSreFont",
					set = "setSreFont",
				},
				sreFontOutline = {
					type = "select",
					name = L["sreFontOutlineTitle"],
					desc = L["sreFontOutlineDesc"],
					values = {
						["NONE"] = L["None"],
						["OUTLINE"] = L["Thin Outline"],
						["THICKOUTLINE"] = L["Thick Outline"],
					},
					sorting = {
						[1] = "NONE",
						[2] = "OUTLINE",
						[3] = "THICKOUTLINE",
					},
					order = 29,
					get = "getSreFontOutline",
					set = "setSreFontOutline",
				},
				sreSpellsHeader = {
					type = "header",
					name = "|cFFFF6900" .. L["Events Shown"],
					order = 40,
				},
				sreAddRaidCooldownsToSpellList = {
					type = "toggle",
					name = L["sreAddRaidCooldownsToSpellListTitle"],
					desc = L["sreAddRaidCooldownsToSpellListDesc"],
					order = 41,
					get = "getSreAddRaidCooldownsToSpellList",
					set = "setSreAddRaidCooldownsToSpellList",
				},
				sreShowCooldownReset = {
					type = "toggle",
					name = L["sreShowCooldownResetTitle"],
					desc = L["sreShowCooldownResetDesc"],
					order = 43,
					get = "getSreShowCooldownReset",
					set = "setSreShowCooldownReset",
				},
				sreShowInterrupts = {
					type = "toggle",
					name = L["sreShowInterruptsTitle"],
					desc = L["sreShowInterruptsDesc"],
					order = 44,
					get = "getSreShowInterrupts",
					set = "setSreShowInterrupts",
				},
				sreShowDispels = {
					type = "toggle",
					name = L["sreShowDispelsTitle"],
					desc = L["sreShowDispelsDesc"],
					order = 45,
					get = "getSreShowDispels",
					set = "setSreShowDispels",
				},
				sreShowSpellName = {
					type = "toggle",
					name = L["sreShowSpellNameTitle"],
					desc = L["sreShowSpellNameDesc"],
					order = 46,
					get = "getSreShowSpellName",
					set = "setSreShowSpellName",
				},
				sreOnlineStatus = {
					type = "toggle",
					name = L["sreOnlineStatusTitle"],
					desc = L["sreOnlineStatusDesc"],
					order = 48,
					get = "getSreOnlineStatus",
					set = "setSreOnlineStatus",
				},
				sreShowCauldrons = {
					type = "toggle",
					name = L["sreShowCauldronsTitle"],
					desc = L["sreShowCauldronsDesc"],
					order = 50,
					get = "getSreShowCauldrons",
					set = "setSreShowCauldrons",
				},
				--[[sreShowSoulstoneRes = {
					type = "toggle",
					name = L["sreShowSoulstoneResTitle"],
					desc = L["sreShowSoulstoneResDesc"],
					order = 51,
					get = "getSreShowSoulstoneRes",
					set = "setSreShowSoulstoneRes",
				},]]
				sreShowManaPotions = {
					type = "toggle",
					name = L["sreShowManaPotionsTitle"],
					desc = L["sreShowManaPotionsDesc"],
					order = 55,
					get = "getSreShowManaPotions",
					set = "setSreShowManaPotions",
				},
				sreShowHealthPotions = {
					type = "toggle",
					name = L["sreShowHealthPotionsTitle"],
					desc = L["sreShowHealthPotionsDesc"],
					order = 56,
					get = "getSreShowHealthPotions",
					set = "setSreShowHealthPotions",
				},
				sreShowDpsPotions = {
					type = "toggle",
					name = L["sreShowDpsPotionsTitle"],
					desc = L["sreShowDpsPotionsDesc"],
					order = 57,
					get = "getSreShowDpsPotions",
					set = "setSreShowDpsPotions",
				},
				sreShowMagePortals = {
					type = "toggle",
					name = L["sreShowMagePortalsTitle"],
					desc = L["sreShowMagePortalsDesc"],
					order = 58,
					get = "getSreShowMagePortals",
					set = "setSreShowMagePortals",
				},
				sreShowResurrections = {
					type = "toggle",
					name = L["sreShowResurrectionsTitle"],
					desc = L["sreShowResurrectionsDesc"],
					order = 59,
					get = "getSreShowResurrections",
					set = "setSreShowResurrections",
				},
				sreShowMisdirection = {
					type = "toggle",
					name = L["sreShowMisdirectionTitle"],
					desc = L["sreShowMisdirectionDesc"],
					order = 60,
					get = "getSreShowMisdirection",
					set = "setSreShowMisdirection",
				},
				sreCustomSpellsHeader = {
					type = "header",
					name = "|cFFFF6900" .. L["sreCustomSpellsHeaderDesc"],
					order = 70,
				},
				sreAddSpell = {
					type = "input",
					name = L["sreAddSpellTitle"],
					desc = L["sreAddSpellDesc"],
					get = "getSreAddSpell",
					set = "setSreAddSpell",
					order = 71,
				},
				sreRemoveSpell = {
					type = "input",
					name = L["sreRemoveSpellTitle"],
					desc = L["sreRemoveSpellDesc"],
					get = "getSreRemoveSpell",
					set = "setSreRemoveSpell",
					order = 72,
					--width = 1.7,
					--confirm = function(self, input)
					--	return string.format(L["trimDataCharInputConfirm"], "|cFFFFFF00" .. input .. "|r");
					--end,
				},
				customSpellsText = {
					type = "description",
					name = function()
						return updateSreOptions();
					end,
					fontSize = "medium",
					order = 80,
				},
			},
		},
		dispels = {
			name = "Offensive Dispels",
			desc = "Chat msgs for offensive dispels and tranq shot.",
			type = "group",
			order = 44,
			args = {
				dispelsText = {
					type = "description",
					name = "|cFF3CE13F" .. L["dispelsMainTextDesc"],
					fontSize = "medium",
					order = 200,
				},
				dispelsHeader = {
					type = "header",
					name = "|cFFFF6900" .. L["Sources"],
					order = 201,
				},
				dispelsFriendlyPlayers = {
					type = "toggle",
					name = L["dispelsFriendlyPlayersTitle"],
					desc = L["dispelsFriendlyPlayersDesc"],
					order = 202,
					get = "getDispelsFriendlyPlayers",
					set = "setDispelsFriendlyPlayers",
				},
				dispelsEnemyPlayers = {
					type = "toggle",
					name = L["dispelsEnemyPlayersTitle"],
					desc = L["dispelsEnemyPlayersDesc"],
					order = 203,
					get = "getDispelsEnemyPlayers",
					set = "setDispelsEnemyPlayers",
				},
				dispelsCreatures = {
					type = "toggle",
					name = L["dispelsCreaturesTitle"],
					desc = L["dispelsCreaturesDesc"],
					order = 204,
					get = "getDispelsCreatures",
					set = "setDispelsCreatures",
				},
				dispelsTranqOnly = {
					type = "toggle",
					name = L["dispelsTranqOnlyTitle"],
					desc = L["dispelsTranqOnlyDesc"],
					order = 205,
					get = "getDispelsTranqOnly",
					set = "setDispelsTranqOnly",
				},
				dispelsHeader2 = {
					type = "header",
					name = "|cFFFF6900" .. L["My Offensive Dispel Casts"],
					order = 220,
				},
				dispelsMyCastGroup = {
					type = "toggle",
					name = L["dispelsMyCastGroupTitle"],
					desc = L["dispelsMyCastGroupDesc"],
					order = 221,
					get = "getDispelsMyCastGroup",
					set = "setDispelsMyCastGroup",
				},
				dispelsMyCastSay = {
					type = "toggle",
					name = L["dispelsMyCastSayTitle"],
					desc = L["dispelsMyCastSayDesc"],
					order = 222,
					get = "getDispelsMyCastSay",
					set = "setDispelsMyCastSay",
				},
				dispelsMyCastPrint = {
					type = "toggle",
					name = L["dispelsMyCastPrintTitle"],
					desc = L["dispelsMyCastPrintDesc"],
					order = 223,
					get = "getDispelsMyCastPrint",
					set = "setDispelsMyCastPrint",
				},
				dispelsMyCastRaid = {
					type = "toggle",
					name = L["dispelsMyCastRaidTitle"],
					desc = L["dispelsMyCastRaidDesc"],
					order = 227,
					get = "getDispelsMyCastRaid",
					set = "setDispelsMyCastRaid",
				},
				dispelsMyCastWorld = {
					type = "toggle",
					name = L["dispelsMyCastWorldTitle"],
					desc = L["dispelsMyCastWorldDesc"],
					order = 228,
					get = "getDispelsMyCastWorld",
					set = "setDispelsMyCastWorld",
				},
				dispelsMyCastPvp = {
					type = "toggle",
					name = L["dispelsMyCastPvpTitle"],
					desc = L["dispelsMyCastPvpDesc"],
					order = 229,
					get = "getDispelsMyCastPvp",
					set = "setDispelsMyCastPvp",
				},
				dispelsHeader3 = {
					type = "header",
					name = "|cFFFF6900" .. L["Other Players/Creatures Offensive Dispel Casts"],
					order = 240,
				},
				--[[dispelsOtherCastGroup = {
					type = "toggle",
					name = L["dispelsOtherCastGroupTitle"],
					desc = L["dispelsOtherCastGroupDesc"],
					order = 241,
					get = "getDispelsOtherCastGroup",
					set = "setDispelsOtherCastGroup",
				},]]
				--[[dispelsOtherCastSay = {
					type = "toggle",
					name = L["dispelsOtherCastSayTitle"],
					desc = L["dispelsOtherCastSayDesc"],
					order = 242,
					get = "getDispelsOtherCastSay",
					set = "setDispelsOtherCastSay",
				},]]
				dispelsOtherCastPrint = {
					type = "toggle",
					name = L["dispelsOtherCastPrintTitle"],
					desc = L["dispelsOtherCastPrintDesc"],
					order = 243,
					get = "getDispelsOtherCastPrint",
					set = "setDispelsOtherCastPrint",
				},
				dispelsOtherCastRaid = {
					type = "toggle",
					name = L["dispelsOtherCastRaidTitle"],
					desc = L["dispelsOtherCastRaidDesc"],
					order = 244,
					get = "getDispelsOtherCastRaid",
					set = "setDispelsOtherCastRaid",
				},
				dispelsOtherCastWorld = {
					type = "toggle",
					name = L["dispelsOtherCastWorldTitle"],
					desc = L["dispelsOtherCastWorldDesc"],
					order = 245,
					get = "getDispelsOtherCastWorld",
					set = "setDispelsOtherCastWorld",
				},
				dispelsOtherCastPvp = {
					type = "toggle",
					name = L["dispelsOtherCastPvpTitle"],
					desc = L["dispelsOtherCastPvpDesc"],
					order = 246,
					get = "getDispelsOtherCastPvp",
					set = "setDispelsOtherCastPvp",
				},
				dispelsText2 = {
					type = "description",
					name = "\n|cFF9CD6DE" .. L["dispelsMainText2Desc"],
					fontSize = "medium",
					order = 260,
				},
			},
		},
		dataOptions = {
			name = "Data Management",
			desc = "Options for how data is recorded and stored.",
			type = "group",
			order = 45,
			args = {
				mainText = {
					type = "description",
					name = "|cFF3CE13F" .. L["dataOptionsTextDesc"],
					fontSize = "medium",
					order = 1,
				},
				logRaids = {
					type = "toggle",
					name = L["logRaidsTitle"],
					desc = L["logRaidsDesc"],
					order = 5,
					get = "getLogRaids",
					set = "setLogRaids",
				},
				logDungeons = {
					type = "toggle",
					name = L["logDungeonsTitle"],
					desc = L["logDungeonsDesc"],
					order = 6,
					get = "getLogDungeons",
					set = "setLogDungeons",
				},
				maxRecordsKept = {
					type = "range",
					name = L["maxRecordsKeptTitle"],
					desc = L["maxRecordsKeptDesc"],
					order = 10,
					get = "getMaxRecordsKept",
					set = "setMaxRecordsKept",
					min = 10,
					max = 50,
					softMin = 10,
					softMax = 50,
					step = 1,
				},
				maxRecordsShown = {
					type = "range",
					name = L["maxRecordsShownTitle"],
					desc = L["maxRecordsShownDesc"],
					order = 11,
					get = "getMaxRecordsShown",
					set = "setMaxRecordsShown",
					min = 10,
					max = 50,
					softMin = 10,
					softMax = 50,
					step = 1,
				},
				maxTradesKept = {
					type = "range",
					name = L["maxTradesKeptTitle"],
					desc = L["maxTradesKeptDesc"],
					order = 12,
					get = "getMaxTradesKept",
					set = "setMaxTradesKept",
					min = 50,
					max = 1000,
					softMin = 50,
					softMax = 1000,
					step = 10,
				},
				maxTradesShown = {
					type = "range",
					name = L["maxTradesShownTitle"],
					desc = L["maxTradesShownDesc"],
					order = 13,
					get = "getMaxTradesShown",
					set = "setMaxTradesShown",
					min = 50,
					max = 1000,
					softMin = 50,
					softMax = 1000,
					step = 10,
				},
			},
		},
		--[[spacer = {
			name = "",
			desc = "",
			type = "group",
			childGroups = "tree",
			order = 49,
			args = {
			},
		},]]
		classTools = {
			name = "[Class Tools]",
			desc = "Helpful tools for each class.",
			type = "group",
			childGroups = "tree",
			order = 50,
			args = {
				raidsText = {
					type = "description",
					name = "Choose a class to see class specific options.",
					fontSize = "medium",
					order = 1,
				},
			},
		},
		classDruid = {
			name = "   |cFFFF7C0ADruid",
			desc = "Druid tools.",
			type = "group",
			order = 100,
			args = {
				comingSoon = {
					type = "description",
					name = "Coming soon.",
					fontSize = "medium",
					order = 1,
				},
			},
		},
		classHunter = {
			name = "   |cFFAAD372Hunter",
			desc = "Hunter tools.",
			type = "group",
			order = 101,
			args = {
				raidCooldownLayoutHeader = {
					type = "header",
					name = "|cFFAAD372My " .. L["Misdirection"] .. " Casts",
					order = 1,
				},
				mdMyText = {
					type = "description",
					name = "|cFF3CE13F" .. L["mdMyTextDesc"],
					fontSize = "medium",
					order = 2,
				},
				mdSendMyThreatGroup = {
					type = "toggle",
					name = L["mdSendMyThreatGroupTitle"],
					desc = L["mdSendMyThreatGroupDesc"],
					order = 3,
					get = "getMdSendMyThreatGroup",
					set = "setMdSendMyThreatGroup",
					width = 1.2,
				},
				mdSendMyThreatSay = {
					type = "toggle",
					name = L["mdSendMyThreatSayTitle"],
					desc = L["mdSendMyThreatSayDesc"],
					order = 4,
					get = "getMdSendMyThreatSay",
					set = "setMdSendMyThreatSay",
					width = 1.2,
				},
				--[[mdSendOthersThreatSay = {
					type = "toggle",
					name = L["mdSendOthersThreatSayTitle"],
					desc = L["mdSendOthersThreatSayDesc"],
					order = 6,
					get = "getMdSendOthersThreatSay",
					set = "setMdSendOthersThreatSay",
					width = 1.2,
				},]]
				mdShowMySelf = {
					type = "toggle",
					name = L["mdShowMySelfTitle"],
					desc = L["mdShowMySelfDesc"],
					order = 7,
					get = "getMdShowMySelf",
					set = "setMdShowMySelf",
					width = 1.2,
				},
				mdSendMyCastGroup = {
					type = "toggle",
					name = L["mdSendMyCastGroupTitle"],
					desc = L["mdSendMyCastGroupDesc"],
					order = 8,
					get = "getMdSendMyCastGroup",
					set = "setMdSendMyCastGroup",
					width = 1.2,
				},
				mdSendMyCastSay = {
					type = "toggle",
					name = L["mdSendMyCastSayTitle"],
					desc = L["mdSendMyCastSayDesc"],
					order = 9,
					get = "getMdSendMyCastSay",
					set = "setMdSendMyCastSay",
					width = 1.2,
				},
				mdShowSpells = {
					type = "toggle",
					name = L["mdShowSpellsTitle"],
					desc = L["mdShowSpellsDesc"],
					order = 11,
					get = "getMdShowSpells",
					set = "setMdShowSpells",
					width = 1.2,
				},
				mdSendTarget = {
					type = "toggle",
					name = L["mdSendTargetTitle"],
					desc = L["mdSendTargetDesc"],
					order = 12,
					get = "getMdSendTarget",
					set = "setMdSendTarget",
					width = 1.2,
				},
				raidCooldownLayoutHeaderOther = {
					type = "header",
					name = "|cFFAAD372Other Hunters " .. L["Misdirection"] .. " Casts",
					order = 20,
				},
				mdOtherText = {
					type = "description",
					name = "|cFF3CE13F" .. L["mdOtherTextDesc"],
					fontSize = "medium",
					order = 21,
				},
				mdSendOthersThreatGroup = {
					type = "toggle",
					name = L["mdSendOthersThreatGroupTitle"],
					desc = L["mdSendOthersThreatGroupDesc"],
					order = 22,
					get = "getMdSendOthersThreatGroup",
					set = "setMdSendOthersThreatGroup",
					width = 1.2,
				},
				mdShowOthersSelf = {
					type = "toggle",
					name = L["mdShowOthersSelfTitle"],
					desc = L["mdShowOthersSelfDesc"],
					order = 23,
					get = "getMdShowOthersSelf",
					set = "setMdShowOthersSelf",
					width = 1.2,
				},
				mdSendOtherCastGroup = {
					type = "toggle",
					name = L["mdSendOtherCastGroupTitle"],
					desc = L["mdSendOtherCastGroupDesc"],
					order = 24,
					get = "getMdSendOtherCastGroup",
					set = "setMdSendOtherCastGroup",
					width = 1.2,
				},
				mdShowSpellsOther = {
					type = "toggle",
					name = L["mdShowSpellsOtherTitle"],
					desc = L["mdShowSpellsOtherDesc"],
					order = 25,
					get = "getMdShowSpellsOther",
					set = "setMdShowSpellsOther",
					width = 1.2,
				},
				mdLastText = {
					type = "description",
					name = "|cFF3CE13F" .. L["mdLastTextDesc"],
					fontSize = "medium",
					order = 30,
				},
				hunterGeneralOptionsHeader = {
					type = "header",
					name = "|cFFFF6900General Options",
					order = 40,
				},
				lowAmmoCheck = {
					type = "toggle",
					name = L["lowAmmoCheckTitle"],
					desc = L["lowAmmoCheckDesc"],
					order = 41,
					get = "getLowAmmoCheck",
					set = "setLowAmmoCheck",
					width = 1.2,
				},
				lowAmmoCheckThreshold = {
					type = "range",
					name = L["lowAmmoCheckThresholdTitle"],
					desc = L["lowAmmoCheckThresholdDesc"],
					order = 42,
					get = "getLowAmmoCheckThreshold",
					set = "setLowAmmoCheckThreshold",
					min = 100,
					max = 10000,
					softMin = 100,
					softMax = 10000,
					step = 100,
					--width = 2,
				},
				hunterDistractingShotGroup = {
					type = "toggle",
					name = L["hunterDistractingShotGroupTitle"],
					desc = L["hunterDistractingShotGroupDesc"],
					order = 43,
					get = "getHunterDistractingShotGroup",
					set = "setHunterDistractingShotGroup",
					width = 1.2,
				},
				hunterDistractingShotSay = {
					type = "toggle",
					name = L["hunterDistractingShotSayTitle"],
					desc = L["hunterDistractingShotSayDesc"],
					order = 44,
					get = "getHunterDistractingShotSay",
					set = "setHunterDistractingShotSay",
					width = 1.2,
				},
				hunterDistractingShotYell = {
					type = "toggle",
					name = L["hunterDistractingShotYellTitle"],
					desc = L["hunterDistractingShotYellDesc"],
					order = 45,
					get = "getHunterDistractingShotYell",
					set = "setHunterDistractingShotYell",
					width = 1.2,
				},
			},
		},
		classMage = {
			name = "   |cFF3FC7EBMage",
			desc = "Mage tools.",
			type = "group",
			order = 102,
			args = {
				comingSoon = {
					type = "description",
					name = "Coming soon.",
					fontSize = "medium",
					order = 1,
				},
			},
		},
		classPaladin = {
			name = "   |cFFF48CBAPaladin",
			desc = "Paladin tools.",
			type = "group",
			order = 103,
			args = {
				comingSoon = {
					type = "description",
					name = "Coming soon.",
					fontSize = "medium",
					order = 1,
				},
			},
		},
		classPriest = {
			name = "   |cFFFFFFFFPriest",
			desc = "Priest tools.",
			type = "group",
			order = 104,
			args = {
				comingSoon = {
					type = "description",
					name = "Coming soon.",
					fontSize = "medium",
					order = 1,
				},
			},
		},
		classRogue = {
			name = "   |cFFFFF468Rogue",
			desc = "Rogue tools.",
			type = "group",
			order = 105,
			args = {
				--Loaded in wrath options below.
			},
		},
		classShaman = {
			name = "   |cFF0070DDShaman",
			desc = "Shaman tools.",
			type = "group",
			order = 106,
			args = {
				comingSoon = {
					type = "description",
					name = "Coming soon.",
					fontSize = "medium",
					order = 1,
				},
			},
		},
		classWarlock = {
			name = "   |cFF8788EEWarlock",
			desc = "Warlock tools.",
			type = "group",
			order = 107,
			args = {
				summonMsg = {
					type = "toggle",
					name = L["summonMsgTitle"],
					desc = L["summonMsgDesc"],
					order = 1,
					get = "getSummonMsg",
					set = "setSummonMsg",
				},
				healthstoneMsg = {
					type = "toggle",
					name = L["healthstoneMsgTitle"],
					desc = L["healthstoneMsgDesc"],
					order = 2,
					get = "getHealthstoneMsg",
					set = "setHealthstoneMsg",
				},
				soulstoneMsgSay = {
					type = "toggle",
					name = L["soulstoneMsgSayTitle"],
					desc = L["soulstoneMsgSayDesc"],
					order = 3,
					get = "getsoulstoneMsgSay",
					set = "setsoulstoneMsgSay",
				},
				soulstoneMsgGroup = {
					type = "toggle",
					name = L["soulstoneMsgGroupTitle"],
					desc = L["soulstoneMsgGroupDesc"],
					order = 4,
					get = "getsoulstoneMsgGroup",
					set = "setsoulstoneMsgGroup",
				},
			},
		},
		classWarrior = {
			name = "   |cFFC69B6DWarrior",
			desc = "Warrior tools.",
			type = "group",
			order = 108,
			args = {
				comingSoon = {
					type = "description",
					name = "Coming soon.",
					fontSize = "medium",
					order = 1,
				},
			},
		},
		raids = {
			name = "[Raids]",
			desc = "Raid specific tools.",
			type = "group",
			childGroups = "tree",
			order = 150,
			args = {
				raidsText = {
					type = "description",
					name = "Choose a raid to see raid specific options.",
					fontSize = "medium",
					order = 1,
				},
			},
		},
		raidsTempestKeep = {
			name = "   |cFFFFFFFFTempest Keep",
			desc = "Tempest Keep",
			type = "group",
			order = 151,
			args = {
				ktNoWeaponsWarning = {
					type = "toggle",
					name = L["ktNoWeaponsWarningTitle"],
					desc = L["ktNoWeaponsWarningDesc"],
					order = 1,
					width = "full",
					get = "getKtNoWeaponsWarning",
					set = "setKtNoWeaponsWarning",
				},
			},
		},
		raidsSsc = {
			name = "   |cFFFFFFFFSSC",
			desc = "Serpentshrine Cavern",
			type = "group",
			order = 201,
			args = {
				acidGeyserWarning = {
					type = "toggle",
					name = L["acidGeyserWarningTitle"],
					desc = L["acidGeyserWarningDesc"],
					order = 1,
					width = "full",
					get = "getAcidGeyserWarning",
					set = "setAcidGeyserWarning",
				},
			},
		},
		raidsSunwell = {
			name = "   |cFFFFFFFFSunwell",
			desc = "Sunwell",
			type = "group",
			order = 251,
			args = {
				autoSunwellPortal = {
					type = "toggle",
					name = L["autoSunwellPortalTitle"],
					desc = L["autoSunwellPortalDesc"],
					order = 1,
					width = "full",
					get = "getAutoSunwellPortal",
					set = "setAutoSunwellPortal",
				},
			},
		},
	},
};

local function setAllCooldownsMerged()
	for k, v in pairs(NRC.cooldowns) do
		NRC.config["raidCooldown" .. string.gsub(k, " ", "") .. "Merged"] = true;
	end
	NRC.acr:NotifyChange("NovaRaidCompanion");
	NRC:reloadRaidCooldowns();
end

local function setAllCooldownsUnmerged()
	for k, v in pairs(NRC.cooldowns) do
		NRC.config["raidCooldown" .. string.gsub(k, " ", "") .. "Merged"] = false;
	end
	NRC.acr:NotifyChange("NovaRaidCompanion");
	NRC:reloadRaidCooldowns();
end

function NRC:loadExtraOptions()
	if (NRC.faction == "Alliance") then
		NRC.options.args.raidCooldowns.args["raidCooldownHeroism"] = {
			type = "toggle",
			name = "|cFF0070DD" .. L["raidCooldownHeroismTitle"],
			desc = L["raidCooldownHeroismDesc"],
			order = 951,
			width = spellWidth,
			get = "getRaidCooldownHeroism",
			set = "setRaidCooldownHeroism",
		};
		NRC.options.args.raidCooldowns.args["raidCooldownHeroismMerged"] = {
			type = "toggle",
			name = "|cFF0070DD" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Heroism"]),
			order = 952,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownHeroismMerged; end,
			set = function(info, value) NRC.config.raidCooldownHeroismMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args["raidCooldownHeroismFrame"] = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Heroism"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 953,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownHeroismFrame; end,
			set = function(info, value) NRC.config.raidCooldownHeroismFrame = value; NRC:reloadRaidCooldowns(); end,
		};
	else
		NRC.options.args.raidCooldowns.args["raidCooldownBloodlust"] = {
			type = "toggle",
			name = "|cFF0070DD" .. L["raidCooldownBloodlustTitle"],
			desc = L["raidCooldownBloodlustDesc"],
			order = 951,
			width = spellWidth,
			get = "getRaidCooldownBloodlust",
			set = "setRaidCooldownBloodlust",
		};
		NRC.options.args.raidCooldowns.args["raidCooldownBloodlustMerged"] = {
			type = "toggle",
			name = "|cFF0070DD" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Bloodlust"]),
			order = 952,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownBloodlustMerged; end,
			set = function(info, value) NRC.config.raidCooldownBloodlustMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args["raidCooldownBloodlustFrame"] = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Bloodlust"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 953,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownBloodlustFrame; end,
			set = function(info, value) NRC.config.raidCooldownBloodlustFrame = value; NRC:reloadRaidCooldowns(); end,
		};
	end
	NRC.options.args.testAllFrames = {
		type = "execute",
		name = function()
			if (NRC:getRaidCooldownsTestState()) then
				return L["Stop Frames Test"];
			else
				return L["Start Frames Test"];
			end
		end,
		--name = L["testAllFramesTitle"],
		desc = L["testAllFramesDesc"],
		func = function()
			if (NRC:getRaidCooldownsTestState()) then
				NRC:stopTestAllFrames();
			else
				NRC:startTestAllFrames();
			end
		end,
		order = 5,
	};
	--[[NRC.options.args.raidCooldowns.args.testCooldownFrames = {
		type = "execute",
		name = function()
			if (NRC:getRaidCooldownsTestState()) then
				return L["Stop Test"];
			else
				return L["Start Test Cooldowns"];
			end
		end,
		desc = L["testRaidCooldownsDesc"],
		func = function()
			if (NRC:getRaidCooldownsTestState()) then
				NRC:stopRaidCooldownsTest();
			else
				NRC:startRaidCooldownsTest();
			end
		end,
		order = 22,
		width = 1,
	};]]
	NRC.options.args.raidCooldowns.args.mergeAllCooldowns = {
		type = "execute",
		name = L["Merge All"],
		desc = L["resetFramesDesc"],
		func = setAllCooldownsMerged,
		order = 1500,
		width = 1,
	};
	NRC.options.args.raidCooldowns.args.unmergeAllCooldowns = {
		type = "execute",
		name = L["Unmerge All"],
		desc = L["resetFramesDesc"],
		func = setAllCooldownsUnmerged,
		order = 1501,
		width = 1,
	};
	if (not NRC.isTBC and not NRC.isClassic) then
		NRC.options.args.classRogue.args.classRogueLayoutHeader = {
			type = "header",
			name = "|cFFFFFF00My " .. L["Tricks"] .. " Casts",
			order = 1,
		};
		NRC.options.args.classRogue.args.tricksMyText = {
			type = "description",
			name = "|cFFDEDE42" .. L["tricksMyTextDesc"],
			fontSize = "medium",
			order = 2,
		};
		NRC.options.args.classRogue.args.tricksSendMyThreatGroup = {
			type = "toggle",
			name = L["tricksSendMyThreatGroupTitle"],
			desc = L["tricksSendMyThreatGroupDesc"],
			order = 3,
			get = "getTricksSendMyThreatGroup",
			set = "setTricksSendMyThreatGroup",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksSendMyThreatSay = {
			type = "toggle",
			name = L["tricksSendMyThreatSayTitle"],
			desc = L["tricksSendMyThreatSayDesc"],
			order = 4,
			get = "getTricksSendMyThreatSay",
			set = "setTricksSendMyThreatSay",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksShowMySelf = {
			type = "toggle",
			name = L["tricksShowMySelfTitle"],
			desc = L["tricksShowMySelfDesc"],
			order = 7,
			get = "getTricksShowMySelf",
			set = "setTricksShowMySelf",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksSendMyCastGroup = {
			type = "toggle",
			name = L["tricksSendMyCastGroupTitle"],
			desc = L["tricksSendMyCastGroupDesc"],
			order = 8,
			get = "getTricksSendMyCastGroup",
			set = "setTricksSendMyCastGroup",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksSendMyCastSay = {
			type = "toggle",
			name = L["tricksSendMyCastSayTitle"],
			desc = L["tricksSendMyCastSayDesc"],
			order = 9,
			get = "getTricksSendMyCastSay",
			set = "setTricksSendMyCastSay",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksShowSpells = {
			type = "toggle",
			name = L["tricksShowSpellsTitle"],
			desc = L["tricksShowSpellsDesc"],
			order = 11,
			get = "getTricksShowSpells",
			set = "setTricksShowSpells",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksSendTarget = {
			type = "toggle",
			name = L["tricksSendTargetTitle"],
			desc = L["tricksSendTargetDesc"],
			order = 12,
			get = "getTricksSendTarget",
			set = "setTricksSendTarget",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.classRogueLayoutHeaderOther = {
			type = "header",
			name = "|cFFFFFF00Other Rogues " .. L["Tricks"] .. " Casts",
			order = 20,
		};
		NRC.options.args.classRogue.args.tricksOtherText = {
			type = "description",
			name = "|cFFDEDE42" .. L["tricksOtherTextDesc"],
			fontSize = "medium",
			order = 21,
		};
		NRC.options.args.classRogue.args.tricksSendOthersThreatGroup = {
			type = "toggle",
			name = L["tricksSendOthersThreatGroupTitle"],
			desc = L["tricksSendOthersThreatGroupDesc"],
			order = 22,
			get = "getTricksSendOthersThreatGroup",
			set = "setTricksSendOthersThreatGroup",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksShowOthersSelf = {
			type = "toggle",
			name = L["tricksShowOthersSelfTitle"],
			desc = L["tricksShowOthersSelfDesc"],
			order = 23,
			get = "getTricksShowOthersSelf",
			set = "setTricksShowOthersSelf",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksSendOtherCastGroup = {
			type = "toggle",
			name = L["tricksSendOtherCastGroupTitle"],
			desc = L["tricksSendOtherCastGroupDesc"],
			order = 24,
			get = "getTricksSendOtherCastGroup",
			set = "setTricksSendOtherCastGroup",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksShowSpellsOther = {
			type = "toggle",
			name = L["tricksShowSpellsOtherTitle"],
			desc = L["tricksShowSpellsOtherDesc"],
			order = 25,
			get = "getTricksShowSpellsOther",
			set = "setTricksShowSpellsOther",
			width = 1.2,
		};
		--[[NRC.options.args.classRogue.args.tricksLastText = {
			type = "description",
			name = "|cFFDEDE42" .. L["tricksLastTextDesc"],
			fontSize = "medium",
			order = 30,
		};]]
		NRC.options.args.classRogue.args.classRogueLayoutHeaderDamage = {
			type = "header",
			name = "|cFFFFFF00" .. L["Tricks"] .. " Damage Boost Info",
			order = 40,
		};
		NRC.options.args.classRogue.args.tricksDamageText = {
			type = "description",
			name = "|cFFDEDE42" .. L["tricksDamageTextDesc"],
			fontSize = "medium",
			order = 41,
		};
		NRC.options.args.classRogue.args.tricksSendamageGroup = {
			type = "toggle",
			name = L["tricksSendDamageGroupTitle"],
			desc = L["tricksSendDamageGroupDesc"],
			order = 42,
			get = "getTricksSendDamageGroup",
			set = "setTricksSendDamageGroup",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksSendamageGroupOther = {
			type = "toggle",
			name = L["tricksSendDamageGroupOtherTitle"],
			desc = L["tricksSendDamageGroupOtherDesc"],
			order = 43,
			get = "getTricksSendDamageGroupOther",
			set = "setTricksSendDamageGroupOther",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksSendOthersThreatPrint = {
			type = "toggle",
			name = L["tricksSendDamagePrintTitle"],
			desc = L["tricksSendDamagePrintDesc"],
			order = 44,
			get = "getTricksSendDamagePrint",
			set = "setTricksSendDamagePrint",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksSendOthersThreatPrintOther = {
			type = "toggle",
			name = L["tricksSendDamagePrintOtherTitle"],
			desc = L["tricksSendDamagePrintOtherDesc"],
			order = 45,
			get = "getTricksSendDamagePrintOther",
			set = "setTricksSendDamagePrintOther",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksOnlyWhenDamage = {
			type = "toggle",
			name = L["tricksOnlyWhenDamageTitle"],
			desc = L["tricksOnlyWhenDamageDesc"],
			order = 46,
			get = "getTricksOnlyWhenDamage",
			set = "setTricksOnlyWhenDamage",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksSendOthersThreatWhisper = {
			type = "toggle",
			name = L["tricksSendDamageWhisperTitle"],
			desc = L["tricksSendDamageWhisperDesc"],
			order = 47,
			get = "getTricksSendDamageWhisper",
			set = "setTricksSendDamageWhisper",
			width = 1.2,
		};
		NRC.options.args.classRogue.args.tricksOtherRoguesMineGained = {
			type = "toggle",
			name = "|cFF00C800" .. L["tricksOtherRoguesMineGainedTitle"],
			desc = L["tricksOtherRoguesMineGainedDesc"],
			order = 48,
			get = "getTricksOtherRoguesMineGained",
			set = "setTricksOtherRoguesMineGained",
			width = 2.4,
		};
		
		--Wrath Cooldowns.
		--Druid.
		NRC.options.args.raidCooldowns.args.raidCooldownSurvivalInstincts = {
			type = "toggle",
			name = "|cFFFF7C0A" .. L["raidCooldownSurvivalInstinctsTitle"],
			desc = L["raidCooldownSurvivalInstinctsDesc"],
			order = 221,
			width = spellWidth,
			get = "getRaidCooldownSurvivalInstincts",
			set = "setRaidCooldownSurvivalInstincts",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownSurvivalInstinctsMerged = {
			type = "toggle",
			name = "|cFFFF7C0A" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Survival Instincts"]),
			order = 222,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownSurvivalInstinctsMerged; end,
			set = function(info, value) NRC.config.raidCooldownSurvivalInstinctsMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownSurvivalInstinctsFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Survival Instincts"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 223,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownSurvivalInstinctsFrame; end,
			set = function(info, value) NRC.config.raidCooldownSurvivalInstinctsFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownStarfall = {
			type = "toggle",
			name = "|cFFFF7C0A" .. L["raidCooldownStarfallTitle"],
			desc = L["raidCooldownStarfallDesc"],
			order = 224,
			width = spellWidth,
			get = "getRaidCooldownStarfall",
			set = "setRaidCooldownStarfall",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownStarfallMerged = {
			type = "toggle",
			name = "|cFFFF7C0A" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Starfall"]),
			order = 225,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownStarfallMerged; end,
			set = function(info, value) NRC.config.raidCooldownStarfallMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownStarfallFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Starfall"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 226,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownStarfallFrame; end,
			set = function(info, value) NRC.config.raidCooldownStarfallFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		--Death Knight.
		NRC.options.args.raidCooldowns.args.raidCooldownArmyoftheDead = {
			type = "toggle",
			name = "|cFFC41E3A" .. L["raidCooldownArmyoftheDeadTitle"],
			desc = L["raidCooldownArmyoftheDeadDesc"],
			order = 101,
			width = spellWidth,
			get = "getRaidCooldownArmyoftheDead",
			set = "setRaidCooldownArmyoftheDead",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownArmyoftheDeadMerged = {
			type = "toggle",
			name = "|cFFC41E3A" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Army of the Dead"]),
			order = 102,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownArmyoftheDeadMerged; end,
			set = function(info, value) NRC.config.raidCooldownArmyoftheDeadMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownArmyoftheDeadFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Army of the Dead"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 103,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownArmyoftheDeadFrame; end,
			set = function(info, value) NRC.config.raidCooldownArmyoftheDeadFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownIceboundFortitude = {
			type = "toggle",
			name = "|cFFC41E3A" .. L["raidCooldownIceboundFortitudeTitle"],
			desc = L["raidCooldownIceboundFortitudeDesc"],
			order = 104,
			width = spellWidth,
			get = "getRaidCooldownIceboundFortitude",
			set = "setRaidCooldownIceboundFortitude",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownIceboundFortitudeMerged = {
			type = "toggle",
			name = "|cFFC41E3A" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Icebound Fortitude"]),
			order = 105,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownIceboundFortitudeMerged; end,
			set = function(info, value) NRC.config.raidCooldownIceboundFortitudeMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownIceboundFortitudeFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Icebound Fortitude"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 106,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownIceboundFortitudeFrame; end,
			set = function(info, value) NRC.config.raidCooldownIceboundFortitudeFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownAntiMagicZone = {
			type = "toggle",
			name = "|cFFC41E3A" .. L["raidCooldownAntiMagicZoneTitle"],
			desc = L["raidCooldownAntiMagicZoneDesc"],
			order = 107,
			width = spellWidth,
			get = "getRaidCooldownAntiMagicZone",
			set = "setRaidCooldownAntiMagicZone",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownAntiMagicZoneMerged = {
			type = "toggle",
			name = "|cFFC41E3A" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Anti-Magic Zone"]),
			order = 108,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownAntiMagicZoneMerged; end,
			set = function(info, value) NRC.config.raidCooldownAntiMagicZoneMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownAntiMagicZoneFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Anti-Magic Zone"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 109,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownAntiMagicZoneFrame; end,
			set = function(info, value) NRC.config.raidCooldownAntiMagicZoneFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownUnholyFrenzy = {
			type = "toggle",
			name = "|cFFC41E3A" .. L["raidCooldownUnholyFrenzyTitle"],
			desc = L["raidCooldownUnholyFrenzyDesc"],
			order = 110,
			width = spellWidth,
			get = "getRaidCooldownUnholyFrenzy",
			set = "setRaidCooldownUnholyFrenzy",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownUnholyFrenzyMerged = {
			type = "toggle",
			name = "|cFFC41E3A" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Unholy Frenzy"]),
			order = 111,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownUnholyFrenzyMerged; end,
			set = function(info, value) NRC.config.raidCooldownUnholyFrenzyMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownUnholyFrenzyFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Unholy Frenzy"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 112,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownUnholyFrenzyFrame; end,
			set = function(info, value) NRC.config.raidCooldownUnholyFrenzyFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownVampiricBlood = {
			type = "toggle",
			name = "|cFFC41E3A" .. L["raidCooldownVampiricBloodTitle"],
			desc = L["raidCooldownVampiricBloodDesc"],
			order = 113,
			width = spellWidth,
			get = "getRaidCooldownVampiricBlood",
			set = "setRaidCooldownVampiricBlood",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownVampiricBloodMerged = {
			type = "toggle",
			name = "|cFFC41E3A" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Vampiric Blood"]),
			order = 114,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownVampiricBloodMerged; end,
			set = function(info, value) NRC.config.raidCooldownVampiricBloodMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownVampiricBloodFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Vampiric Blood"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 115,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownVampiricBloodFrame; end,
			set = function(info, value) NRC.config.raidCooldownVampiricBloodFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		--Paladin.
		--Replace Blessing of Protection with Hand of Protection.
		NRC.options.args.raidCooldowns.args.raidCooldownBlessingofProtection = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["raidCooldownHandofProtectionTitle"],
			desc = L["raidCooldownHandofProtectionDesc"],
			order = 523,
			width = spellWidth,
			get = "getRaidCooldownHandofProtection",
			set = "setRaidCooldownHandofProtection",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownBlessingofProtectionMerged = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Hand of Protection"]),
			order = 524,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownHandofProtectionMerged; end,
			set = function(info, value) NRC.config.raidCooldownHandofProtectionMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownBlessingofProtectionFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Hand of Protection"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 525,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownHandofProtectionFrame; end,
			set = function(info, value) NRC.config.raidCooldownHandofProtectionFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownDivineSacrifice = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["raidCooldownDivineSacrificeTitle"],
			desc = L["raidCooldownDivineSacrificeDesc"],
			order = 526,
			width = spellWidth,
			get = "getRaidCooldownDivineSacrifice",
			set = "setRaidCooldownDivineSacrifice",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownDivineSacrificeMerged = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Divine Sacrifice"]),
			order = 527,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownDivineSacrificeMerged; end,
			set = function(info, value) NRC.config.raidCooldownDivineSacrificeMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownDivineSacrificeFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Divine Sacrifice"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 528,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownDivineSacrificeFrame; end,
			set = function(info, value) NRC.config.raidCooldownDivineSacrificeFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownAuraMastery = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["raidCooldownAuraMasteryTitle"],
			desc = L["raidCooldownAuraMasteryDesc"],
			order = 529,
			width = spellWidth,
			get = "getRaidCooldownAuraMastery",
			set = "setRaidCooldownAuraMastery",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownAuraMasteryMerged = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Aura Mastery"]),
			order = 530,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownAuraMasteryMerged; end,
			set = function(info, value) NRC.config.raidCooldownAuraMasteryMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownAuraMasteryFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Aura Mastery"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 531,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownAuraMasteryFrame; end,
			set = function(info, value) NRC.config.raidCooldownAuraMasteryFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownHandofSacrifice = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["raidCooldownHandofSacrificeTitle"],
			desc = L["raidCooldownHandofSacrificeDesc"],
			order = 532,
			width = spellWidth,
			get = "getRaidCooldownHandofSacrifice",
			set = "setRaidCooldownHandofSacrifice",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownHandofSacrificeMerged = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Hand of Sacrifice"]),
			order = 533,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownHandofSacrificeMerged; end,
			set = function(info, value) NRC.config.raidCooldownHandofSacrificeMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownHandofSacrificeFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Hand of Sacrifice"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 534,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownHandofSacrificeFrame; end,
			set = function(info, value) NRC.config.raidCooldownHandofSacrificeFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownHandofSalvation = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["raidCooldownHandofSalvationTitle"],
			desc = L["raidCooldownHandofSalvationDesc"],
			order = 535,
			width = spellWidth,
			get = "getRaidCooldownHandofSalvation",
			set = "setRaidCooldownHandofSalvation",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownHandofSalvationMerged = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Hand of Salvation"]),
			order = 536,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownHandofSalvationMerged; end,
			set = function(info, value) NRC.config.raidCooldownHandofSalvationMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownHandofSalvationFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Hand of Salvation"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 537,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownHandofSalvationFrame; end,
			set = function(info, value) NRC.config.raidCooldownHandofSalvationFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownDivineGuardian = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["raidCooldownDivineGuardianTitle"],
			desc = L["raidCooldownDivineGuardianDesc"],
			order = 538,
			width = spellWidth,
			get = "getRaidCooldownDivineGuardian",
			set = "setRaidCooldownDivineGuardian",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownDivineGuardianMerged = {
			type = "toggle",
			name = "|cFFF48CBA" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Divine Guardian"]),
			order = 539,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownDivineGuardianMerged; end,
			set = function(info, value) NRC.config.raidCooldownDivineGuardianMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownDivineGuardianFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Divine Guardian"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 540,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownDivineGuardianFrame; end,
			set = function(info, value) NRC.config.raidCooldownDivineGuardianFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		--Priest.
		NRC.options.args.raidCooldowns.args.raidCooldownDivineHymn = {
			type = "toggle",
			name = "|cFFFFFFFF" .. L["raidCooldownDivineHymnTitle"],
			desc = L["raidCooldownDivineHymnDesc"],
			order = 628,
			width = spellWidth,
			get = "getRaidCooldownDivineHymn",
			set = "setRaidCooldownDivineHymn",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownDivineHymnMerged = {
			type = "toggle",
			name = "|cFFFFFFFF" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Divine Hymn"]),
			order = 629,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownDivineHymnMerged; end,
			set = function(info, value) NRC.config.raidCooldownDivineHymnMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownDivineHymnFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Divine Hymn"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 630,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownDivineHymnFrame; end,
			set = function(info, value) NRC.config.raidCooldownDivineHymnFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownHymnofHope = {
			type = "toggle",
			name = "|cFFFFFFFF" .. L["raidCooldownHymnofHopeTitle"],
			desc = L["raidCooldownHymnofHopeDesc"],
			order = 631,
			width = spellWidth,
			get = "getRaidCooldownHymnofHope",
			set = "setRaidCooldownHymnofHope",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownHymnofHopeMerged = {
			type = "toggle",
			name = "|cFFFFFFFF" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Hymn of Hope"]),
			order = 632,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownHymnofHopeMerged; end,
			set = function(info, value) NRC.config.raidCooldownHymnofHopeMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownHymnofHopeFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Hymn of Hope"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 633,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownHymnofHopeFrame; end,
			set = function(info, value) NRC.config.raidCooldownHymnofHopeFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownGuardianSpirit = {
			type = "toggle",
			name = "|cFFFFFFFF" .. L["raidCooldownGuardianSpiritTitle"],
			desc = L["raidCooldownGuardianSpiritDesc"],
			order = 634,
			width = spellWidth,
			get = "getRaidCooldownGuardianSpirit",
			set = "setRaidCooldownGuardianSpirit",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownGuardianSpiritMerged = {
			type = "toggle",
			name = "|cFFFFFFFF" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Guardian Spirit"]),
			order = 635,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownGuardianSpiritMerged; end,
			set = function(info, value) NRC.config.raidCooldownGuardianSpiritMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownGuardianSpiritFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Guardian Spirit"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 636,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownGuardianSpiritFrame; end,
			set = function(info, value) NRC.config.raidCooldownGuardianSpiritFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		--Rogue.
		NRC.options.args.raidCooldowns.args.raidCooldownTricksoftheTrade = {
			type = "toggle",
			name = "|cFFFFF468" .. L["raidCooldownTricksoftheTradeTitle"],
			desc = L["raidCooldownTricksoftheTradeDesc"],
			order = 824,
			width = spellWidth,
			get = "getRaidCooldownTricksoftheTrade",
			set = "setRaidCooldownTricksoftheTrade",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownTricksoftheTradeMerged = {
			type = "toggle",
			name = "|cFFFFF468" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Tricks of the Trade"]),
			order = 825,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownTricksoftheTradeMerged; end,
			set = function(info, value) NRC.config.raidCooldownTricksoftheTradeMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownTricksoftheTradeFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Tricks of the Trade"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 827,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownTricksoftheTradeFrame; end,
			set = function(info, value) NRC.config.raidCooldownTricksoftheTradeFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		--Warrior.
		NRC.options.args.raidCooldowns.args.raidCooldownBladestorm = {
			type = "toggle",
			name = "|cFFC69B6D" .. L["raidCooldownBladestormTitle"],
			desc = L["raidCooldownBladestormDesc"],
			order = 1127,
			width = spellWidth,
			get = "getRaidCooldownBladestorm",
			set = "setRaidCooldownBladestorm",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownBladestormMerged = {
			type = "toggle",
			name = "|cFFC69B6D" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Bladestorm"]),
			order = 1128,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownBladestormMerged; end,
			set = function(info, value) NRC.config.raidCooldownBladestormMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownBladestormFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Bladestorm"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 1129,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownBladestormFrame; end,
			set = function(info, value) NRC.config.raidCooldownBladestormFrame = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownShatteringThrow = {
			type = "toggle",
			name = "|cFFC69B6D" .. L["raidCooldownShatteringThrowTitle"],
			desc = L["raidCooldownShatteringThrowDesc"],
			order = 1130,
			width = spellWidth,
			get = "getRaidCooldownShatteringThrow",
			set = "setRaidCooldownShatteringThrow",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownShatteringThrowMerged = {
			type = "toggle",
			name = "|cFFC69B6D" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Shattering Throw"]),
			order = 1131,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownShatteringThrowMerged; end,
			set = function(info, value) NRC.config.raidCooldownShatteringThrowMerged = value; NRC:reloadRaidCooldowns(); end,
		};
		NRC.options.args.raidCooldowns.args.raidCooldownShatteringThrowFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Shattering Throw"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 1132,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownShatteringThrowFrame; end,
			set = function(info, value) NRC.config.raidCooldownShatteringThrowFrame = value; NRC:reloadRaidCooldowns(); end,
		};
	end
end

		--[[NRC.options.args.raidCooldowns.args.raidCooldownRebirth = {
			type = "toggle",
			name = "|cFFFF7C0A" .. L["raidCooldownRebirthTitle"],
			desc = L["raidCooldownRebirthDesc"],
			order = 50,
			width = spellWidth,
			get = "getRaidCooldownRebirth",
			set = "setRaidCooldownRebirth",
		};
		NRC.options.args.raidCooldowns.args.raidCooldownRebirthMerged = {
			type = "toggle",
			name = "|cFFFF7C0A" .. L["Merged"],
			desc = string.format(L["mergedDesc"], L["Rebirth"]),
			order = 51,
			width = mergedWidth,
			get = function(info) return NRC.config.raidCooldownRebirthMerged; end,
			set = function(info, value) NRC.config.raidCooldownRebirthMerged = value; NRC:reloadRaidCooldowns(); end,
		},;
		NRC.options.args.raidCooldowns.args.raidCooldownRebirthFrame = {
			type = "select",
			name = "",
			desc = string.format(L["frameDesc"], L["Rebirth"]),
			values = setCooldownFrameOption(true),
			sorting = setCooldownFrameOption(),
			order = 52,
			width = frameWidth,
			get = function(info) return NRC.config.raidCooldownRebirthFrame; end,
			set = function(info, value) NRC.config.raidCooldownRebirthFrame = value; NRC:reloadRaidCooldowns(); end,
		};]]
------------------------
--Load option defaults--
------------------------
NRC.optionDefaults = {
	global = {
		---Global settings.
		raidID = 0,
		maxRecordsKept = 50,
		maxRecordsShown = 50,
		maxTradesKept = 400,
		maxTradesShown = 400,
		timeStampFormat = 12,
		--timeStampZone = nil,
		--moneyString = nil,
		lastVersionMsg = 0,
		minimapIcon = {["minimapPos"] = 203, ["hide"] = false},
		minimapButton = true,
		timeStringType = "medium",
		chatColorR = 1, chatColorG = 1, chatColorB = 0,
		prefixColorR = 1, prefixColorG = 0.4117647058823529, prefixColorB = 0,
		middleColorR = 1, middleColorG = 0.96, middleColorB = 0.41,
		mmColorR = 1, mmColorG = 1, mmColorB = 1,
		detectSameInstance = true,
		raidCooldownsBackdropAlpha = 0.3,
		raidCooldownsBorderAlpha = 0.2,
		raidCooldownsGrowthDirection = 1,
		raidCooldownsNumType = 1,
		raidCooldownsBorderType = 1,
		raidCooldownsSortOrder = 1,
		raidCooldownsScale = 1,
		raidStatusScale = 1,
		raidCooldownsDisableMouse = false,
		raidCooldownsFont = "NRC Default",
		raidCooldownsFontNumbers = "NRC Default",
		raidCooldownsFontSize = 12,
		raidCooldownsWidth = 150,
		raidCooldownsHeight = 20,
		raidCooldownsFontOutline = "NONE",
		
		raidManaBackdropAlpha = 0.3,
		raidManaBorderAlpha = 0,
		raidManaGrowthDirection = 1,
		raidManaSortOrder = 1,
		raidManaScale = 1,
		raidManaUpdateInterval = 0.5,
		raidManaResurrectionDir = 1,
		raidManaFont = "NRC Default",
		raidManaFontNumbers = "NRC Numbers",
		raidManaFontSize = 12,
		raidManaWidth = 130,
		raidManaHeight = 15,
		raidManaFontOutline = "NONE",
		
		sreFont = "NRC Default",
		sreFontOutline = "NONE",
		
		raidStatusFont = "NRC Default",
		raidStatusFontSize = 12,
		--raidStatusFontOutline = "NONE",
		
		copyGlobalToProfile = true,
		
		---Settings that change with profiles.
		---These can be deleted from here in a few months.
		---They have been moved to profile in v1.08 but left here to copy over when people update.
		---Delete copyGlobalDefaults() at same time.
		showRaidCooldowns = true,
		showRaidCooldownsInRaid = true,
		showRaidCooldownsInParty = true,
		--showRaidCooldownsInWorld = true,
		showRaidCooldownsInBG = false,
		--mergeRaidCooldowns = true,
		raidCooldownsSoulstones = true,
		ktNoWeaponsWarning = true,
		showMobSpawnedTime = false,
		acidGeyserWarning = true,
		raidStatusShowReadyCheck = false,
		raidStatusHideCombat = false,
		raidCooldownsNecksRaidOnly = true,
		logDungeons = false,
		logRaids = true,
		summonStoneMsg = true,
		duraWarning = true,
		showMoneyTradedChat = false,
		sortRaidStatusByGroups = false,
		sortRaidStatusByGroupsColor = true,
		sortRaidStatusByGroupsColorBackground = false,
		attunementWarnings = true,
		checkShadowNeckBT = true,
		
		--Druid.
		raidCooldownRebirth = true,
		raidCooldownInnervate = false,
		raidCooldownTranquility = false,
		--Hunter
		raidCooldownMisdirection = false,
		--Mage.
		raidCooldownEvocation = false,
		raidCooldownIceBlock = false,
		raidCooldownInvisibility = false,
		--Paladin.
		raidCooldownDivineIntervention = true,
		raidCooldownDivineShield = false,
		raidCooldownLayonHands = false,
		raidCooldownBlessingofProtection = false,
		--Priest.
		raidCooldownFearWard = false,
		raidCooldownShadowfiend = false,
		raidCooldownPsychicScream = false,
		raidCooldownPowerInfusion = false,
		raidCooldownPainSuppression = false,
		--Rogue.
		raidCooldownBlind = false,
		raidCooldownVanish = false,
		--Shaman.
		raidCooldownEarthElemental = false,
		raidCooldownReincarnation = true,
		raidCooldownBloodlust = false,
		raidCooldownHeroism = false,
		raidCooldownManaTide = false,
		--Warlock.
		raidCooldownSoulstone = true,
		raidCooldownSoulshatter = false,
		raidCooldownRitualofSouls = false,
		summonMsg = true,
		healthstoneMsg = true,
		soulstoneMsgSay = false,
		soulstoneMsgGroup = false,
		--Warrior.
		raidCooldownChallengingShout = false,
		raidCooldownIntimidatingShout = false,
		raidCooldownMockingBlow = false,
		raidCooldownRecklessness = false,
		raidCooldownShieldWall = false,
		--Necks
		--raidCooldownNeckBuffs = false,
		raidCooldownNeckSP = false,
		raidCooldownNeckCrit = false,
		raidCooldownNeckCritRating = false,
		raidCooldownNeckStam = false,
		raidCooldownNeckHP5 = false,
		raidCooldownNeckStats = false,
		
		raidStatusFlask = true,
		raidStatusFood = true,
		raidStatusScroll = true,
		raidStatusInt = true,
		raidStatusFort = true,
		raidStatusSpirit = false,
		raidStatusShadow = false,
		raidStatusMotw = true,
		raidStatusPal = true,
		raidStatusDura = true,
		raidStatusShadowRes = true,
		raidStatusFireRes = true,
		raidStatusNatureRes = true,
		raidStatusFrostRes = true,
		raidStatusArcaneRes = true,
		--raidStatusHoly = false,
		--raidStatusArmor = true,
		raidStatusWeaponEnchants = true,
		raidStatusTalents = true,
		raidStatusExpandAlways = false,
		--Debug.
		--raidCooldownArcaneIntellect = true,
		--raidCooldownFelArmor = true,
	},
	profile = {
		lockAllFrames = false,
		showRaidCooldowns = true,
		showRaidCooldownsInRaid = true,
		showRaidCooldownsInParty = true,
		--showRaidCooldownsInWorld = true,
		showRaidCooldownsInBG = false,
		--mergeRaidCooldowns = true,
		raidCooldownsSoulstones = true,
		ktNoWeaponsWarning = true,
		showMobSpawnedTime = false,
		acidGeyserWarning = true,
		raidStatusShowReadyCheck = false,
		raidStatusFadeReadyCheck = false,
		raidStatusHideCombat = false,
		raidCooldownsNecksRaidOnly = true,
		logDungeons = false,
		logRaids = true,
		summonStoneMsg = true,
		duraWarning = true,
		showMoneyTradedChat = false,
		sortRaidStatusByGroups = false,
		sortRaidStatusByGroupsColor = true,
		sortRaidStatusByGroupsColorBackground = false,
		attunementWarnings = true,
		checkShadowNeckBT = true,
		checkPvpTrinket = true,
		showInspectTalents = true,
		cooldownFrameCount = 1,
		raidCooldownsSoulstonesPosition = 1,
		autoCombatLog = false,
		cauldronMsg = true,
		sreEnabled = true,
		sreEnabledEverywhere = false,
		sreEnabledRaid = true,
		sreEnabledPvP = false,
		sreGroupMembers = true,
		sreShowSelf = true,
		sreShowSelfRaidOnly = false,
		sreAllPlayers = false,
		sreNpcs = true,
		sreNpcsRaidOnly = true,
		sreGrowthDirection = 1,
		sreAlignment = 1,
		sreAnimationSpeed = 35,
		sreLineFrameScale = 1,
		sreScrollHeight = 250,
		sreCustomSpells = {},
		sreShowMisdirection = true,
		sreLineFrameHeight = 15,
		sreAddRaidCooldownsToSpellList = true,
		sreShowCooldownReset = false,
		sreShowInterrupts = true,
		sreShowDispels = false,
		sreShowSpellName = true,
		sreOnlineStatus = false,
		sreShowCauldrons = true,
		sreShowSoulstoneRes = false,
		sreShowDpsPotions = false,
		sreShowManaPotions = false,
		sreShowHealthPotions = false,
		sreShowMagePortals = true,
		sreShowResurrections = true,
		autoSunwellPortal = true,
		consumesViewType = 1,
		itemUseShowConsumes = true,
		itemUseShowRacials = true,
		itemUseShowScrolls = true,
		itemUseShowInterrupts = true,
		itemUseShowFood = false,
		checkMetaGem = true,
		releaseWarning = true,
		showTrainset = false,
		autoInv = false,
		autoInvKeyword = "inv",
		
		raidManaEnabled = true,
		raidManaShowSelf = true,
		raidManaEnabledEverywhere = true,
		raidManaEnabledRaid = true,
		raidManaEnabledPvp = false,
		raidManaAverage = true,
		raidManaResurrection = true,
		raidManaHealers = true,
		raidManaDruid = false,
		raidManaHunter = false,
		raidManaMage = false,
		raidManaPaladin = false,
		raidManaPriest = false,
		raidManaShaman = false,
		raidManaWarlock = false,
		
		lootExportLegendary = true,
		lootExportEpic = true,
		lootExportRare = true,
		lootExportUncommon = true,
		lootExportTradeskill = true,
		exportType = "fightclub",
		mapLootDisplayToTrades = true,
		exportCustomHeader = "date;player;itemlink;itemid",
		exportCustomString = "%date%;%player%;%itemlink%;%itemid%",
		exportDate = "yyyy/mm/dd",
		
		raidCooldownsLeftClick = 1,
		raidCooldownsRightClick = 1,
		raidCooldownsShiftLeftClick = 1,
		raidCooldownsShiftRightClick = 1,
		
		tradeExportGoldGiven = true,
		tradeExportGoldReceived = true,
		tradeExportItemsGiven = true,
		tradeExportItemsReceived = true,
		tradeExportEnchants = false,
		tradeExportItemsType = "wowhead",
		tradeExportStart = 1,
		tradeExportEnd = 400,
		tradeExportAttendees = true,
		
		dispelsMyCastGroup = false,
		dispelsMyCastPrint = false,
		dispelsMyCastSay = false,
		dispelsMyCastRaid = false,
		dispelsMyCastWorld = false,
		dispelsMyCastPvp = false,
		dispelsOtherCastGroup = false,
		dispelsOtherCastPrint = false,
		dispelsOtherCastSay = false,
		dispelsOtherCastRaid = false,
		dispelsOtherCastWorld = false,
		dispelsOtherCastPvP = false,
		dispelsCreatures = true,
		dispelsTranqOnly = false,
		dispelsFriendlyPlayers = true,
		dispelsEnemyPlayers = false,
			
		--Death Knight.
		raidCooldownArmyoftheDead = false,
		raidCooldownArmyoftheDeadMerged = true,
		raidCooldownArmyoftheDeadFrame = 1,
		raidCooldownIceboundFortitude = false,
		raidCooldownIceboundFortitudeMerged = true,
		raidCooldownIceboundFortitudeFrame = 1,
		raidCooldownAntiMagicZone = false,
		raidCooldownAntiMagicZoneMerged = true,
		raidCooldownAntiMagicZoneFrame = 1,
		raidCooldownUnholyFrenzy = false,
		raidCooldownUnholyFrenzyMerged = true,
		raidCooldownUnholyFrenzyFrame = 1,
		raidCooldownVampiricBlood = false,
		raidCooldownVampiricBloodMerged = true,
		raidCooldownVampiricBloodFrame = 1,
		raidCooldownAntiMagicZone = false,
		raidCooldownAntiMagicZoneMerged = true,
		raidCooldownAntiMagicZoneFrame = 1,
		--Druid.
		raidCooldownRebirth = true,
		raidCooldownRebirthMerged = true,
		raidCooldownRebirthFrame = 1,
		raidCooldownInnervate = false,
		raidCooldownInnervateMerged = true,
		raidCooldownInnervateFrame = 1,
		raidCooldownTranquility = false,
		raidCooldownTranquilityMerged = true,
		raidCooldownTranquilityFrame = 1,
		raidCooldownSurvivalInstincts = false,
		raidCooldownSurvivalInstinctsMerged = true,
		raidCooldownSurvivalInstinctsFrame = 1,
		raidCooldownChallengingRoar = false,
		raidCooldownChallengingRoarMerged = true,
		raidCooldownChallengingRoarFrame = 1,
		raidCooldownStarfall = false,
		raidCooldownStarfallMerged = true,
		raidCooldownStarfallFrame = 1,
		--Hunter
		raidCooldownMisdirection = false,
		raidCooldownMisdirectionMerged = true,
		raidCooldownMisdirectionFrame = 1,
		mdSendMyCastGroup = false,
		mdSendMyCastSay = false,
		mdSendOtherCastGroup = false,
		mdSendMyThreatGroup = true,
		mdSendMyThreatSay = false,
		mdSendOthersThreatGroup = false,
		mdSendOthersThreatSelf = false,
		mdShowMySelf = false,
		mdShowOthersSelf = false,
		mdShowSpells = true,
		mdShowSpellsOther = false,
		mdSendTarget = false,
		lowAmmoCheck = true,
		lowAmmoCheckThreshold = 1000,
		hunterDistractingShotGroup = false,
		hunterDistractingShotSay = false,
		hunterDistractingShotYell = false,
		--Mage.
		raidCooldownEvocation = false,
		raidCooldownEvocationMerged = true,
		raidCooldownEvocationFrame = 1,
		raidCooldownIceBlock = false,
		raidCooldownIceBlockMerged = true,
		raidCooldownIceBlockFrame = 1,
		raidCooldownInvisibility = false,
		raidCooldownInvisibilityMerged = true,
		raidCooldownInvisibilityFrame = 1,
		--Paladin.
		raidCooldownDivineIntervention = true,
		raidCooldownDivineInterventionMerged = true,
		raidCooldownDivineInterventionFrame = 1,
		raidCooldownDivineShield = false,
		raidCooldownDivineShieldMerged = true,
		raidCooldownDivineShieldFrame = 1,
		raidCooldownLayonHands = false,
		raidCooldownLayonHandsMerged = true,
		raidCooldownLayonHandsFrame = 1,
		raidCooldownBlessingofProtection = false,
		raidCooldownBlessingofProtectionMerged = true,
		raidCooldownBlessingofProtectionFrame = 1,
		raidCooldownHandofProtection = false,
		raidCooldownHandofProtectionMerged = true,
		raidCooldownHandofProtectionFrame = 1,
		raidCooldownDivineSacrifice = false,
		raidCooldownDivineSacrificeMerged = true,
		raidCooldownDivineSacrificeFrame = 1,
		raidCooldownAuraMastery = false,
		raidCooldownAuraMasteryMerged = true,
		raidCooldownAuraMasteryFrame = 1,
		raidCooldownHandofSacrifice = false,
		raidCooldownHandofSacrificeMerged = true,
		raidCooldownHandofSacrificeFrame = 1,
		raidCooldownHandofSalvation = false,
		raidCooldownHandofSalvationMerged = true,
		raidCooldownHandofSalvationFrame = 1,
		raidCooldownDivineProtection = false,
		raidCooldownDivineProtectionMerged = true,
		raidCooldownDivineProtectionFrame = 1,
		raidCooldownDivineGuardian = false,
		raidCooldownDivineGuardianMerged = true,
		raidCooldownDivineGuardianFrame = 1,
		--Priest.
		raidCooldownFearWard = false,
		raidCooldownFearWardMerged = true,
		raidCooldownFearWardFrame = 1,
		raidCooldownShadowfiend = false,
		raidCooldownShadowfiendMerged = true,
		raidCooldownShadowfiendFrame = 1,
		raidCooldownPsychicScream = false,
		raidCooldownPsychicScreamMerged = true,
		raidCooldownPsychicScreamFrame = 1,
		raidCooldownPowerInfusion = false,
		raidCooldownPowerInfusionMerged = true,
		raidCooldownPowerInfusionFrame = 1,
		raidCooldownPainSuppression = false,
		raidCooldownPainSuppressionMerged = true,
		raidCooldownPainSuppressionFrame = 1,
		raidCooldownDivineHymn = false,
		raidCooldownDivineHymnMerged = true,
		raidCooldownDivineHymnFrame = 1,
		raidCooldownHymnofHope = false,
		raidCooldownHymnofHopeMerged = true,
		raidCooldownHymnofHopeFrame = 1,
		raidCooldownGuardianSpirit = false,
		raidCooldownGuardianSpiritMerged = true,
		raidCooldownGuardianSpiritFrame = 1,
		--Rogue.
		raidCooldownBlind = false,
		raidCooldownBlindMerged = true,
		raidCooldownBlindFrame = 1,
		raidCooldownVanish = false,
		raidCooldownVanishMerged = true,
		raidCooldownVanishFrame = 1,
		raidCooldownEvasion = false,
		raidCooldownEvasionMerged = true,
		raidCooldownEvasionFrame = 1,
		raidCooldownDistract = false,
		raidCooldownDistractMerged = true,
		raidCooldownDistractFrame = 1,
		raidCooldownTricksoftheTrade = false,
		raidCooldownTricksoftheTradeMerged = true,
		raidCooldownTricksoftheTradeFrame = 1,
		tricksSendMyCastGroup = false,
		tricksSendMyCastSay = false,
		tricksSendOtherCastGroup = false,
		tricksSendMyThreatGroup = true,
		tricksSendMyThreatSay = false,
		tricksSendOthersThreatGroup = false,
		tricksSendOthersThreatSelf = false,
		tricksShowMySelf = false,
		tricksShowOthersSelf = false,
		tricksShowSpells = false,
		tricksShowSpellsOther = false,
		tricksSendTarget = false,
		tricksSendDamageGroup = false,
		tricksSendDamageWhisper = false,
		tricksSendDamagePrint = true,
		tricksSendDamagePrintOther = false,
		tricksOtherRoguesMineGained = true,
		tricksSendDamageGroupOther = false,
		tricksOnlyWhenDamage = false,
		--Shaman.
		raidCooldownEarthElemental = false,
		raidCooldownEarthElementalMerged = true,
		raidCooldownEarthElementalFrame = 1,
		raidCooldownFireElemental = false,
		raidCooldownFireElementalMerged = true,
		raidCooldownFireElementalFrame = 1,
		raidCooldownReincarnation = true,
		raidCooldownReincarnationMerged = true,
		raidCooldownReincarnationFrame = 1,
		raidCooldownBloodlust = false,
		raidCooldownBloodlustMerged = true,
		raidCooldownBloodlustFrame = 1,
		raidCooldownHeroism = false,
		raidCooldownHeroismMerged = true,
		raidCooldownHeroismFrame = 1,
		raidCooldownManaTide = false,
		raidCooldownManaTideMerged = true,
		raidCooldownManaTideFrame = 1,
		--Warlock.
		raidCooldownSoulstone = true,
		raidCooldownSoulstoneMerged = true,
		raidCooldownSoulstoneFrame = 1,
		raidCooldownSoulshatter = false,
		raidCooldownSoulshatterMerged = true,
		raidCooldownSoulshatterFrame = 1,
		raidCooldownDeathCoil = false,
		raidCooldownDeathCoilMerged = true,
		raidCooldownDeathCoilFrame = 1,
		--raidCooldownRitualofSouls = false,
		--raidCooldownRitualofSoulsMerged = true,
		--raidCooldownRitualofSoulsFrame = 1,
		summonMsg = true,
		healthstoneMsg = true,
		soulstoneMsgSay = false,
		soulstoneMsgGroup = false,
		warlockCurseReminder = false,
		--Warrior.
		raidCooldownChallengingShout = false,
		raidCooldownChallengingShoutMerged = true,
		raidCooldownChallengingShoutFrame = 1,
		raidCooldownIntimidatingShout = false,
		raidCooldownIntimidatingShoutMerged = true,
		raidCooldownIntimidatingShoutFrame = 1,
		raidCooldownMockingBlow = false,
		raidCooldownMockingBlowMerged = true,
		raidCooldownMockingBlowFrame = 1,
		raidCooldownRecklessness = false,
		raidCooldownRecklessnessMerged = true,
		raidCooldownRecklessnessFrame = 1,
		raidCooldownShieldWall = false,
		raidCooldownShieldWallMerged = true,
		raidCooldownShieldWallFrame = 1,
		raidCooldownBladestorm = false,
		raidCooldownBladestormMerged = true,
		raidCooldownBladestormFrame = 1,
		raidCooldownShatteringThrow = false,
		raidCooldownShatteringThrowMerged = true,
		raidCooldownShatteringThrowFrame = 1,
		--Necks
		raidCooldownNeckSP = false,
		raidCooldownNeckSPMerged = true,
		raidCooldownNeckSPFrame = 1,
		raidCooldownNeckCrit = false,
		raidCooldownNeckCritMerged = true,
		raidCooldownNeckCritFrame = 1,
		raidCooldownNeckCritRating = false,
		raidCooldownNeckCritRatingMerged = true,
		raidCooldownNeckCritRatingFrame = 1,
		raidCooldownNeckStam = false,
		raidCooldownNeckStamMerged = true,
		raidCooldownNeckStamFrame = 1,
		raidCooldownNeckHP5 = false,
		raidCooldownNeckHP5Merged = true,
		raidCooldownNeckHP5Frame = 1,
		raidCooldownNeckStats = false,
		raidCooldownNeckStatsMerged = true,
		raidCooldownNeckStatsFrame = 1,
		
		raidStatusFlask = true,
		raidStatusFood = true,
		raidStatusScroll = true,
		raidStatusInt = true,
		raidStatusFort = true,
		raidStatusSpirit = false,
		raidStatusShadow = false,
		raidStatusMotw = true,
		raidStatusPal = true,
		raidStatusDura = true,
		raidStatusShadowRes = true,
		raidStatusFireRes = true,
		raidStatusNatureRes = true,
		raidStatusFrostRes = true,
		raidStatusArcaneRes = true,
		--raidStatusHoly = false,
		--raidStatusArmor = true,
		raidStatusWeaponEnchants = true,
		raidStatusTalents = true,
		raidStatusExpandAlways = false,
		--Debug.
		--raidCooldownArcaneIntellect = true,
		--raidCooldownFelArmor = true,
	},
};

--This is a one time run function, it runs during the version upgrade to 1.08.
--In 1.08 profiles were added, this just copys what settings the user already had over to the default profile.
local function copyGlobalDefaults()
	for k, v in pairs(NRC.optionDefaults.global) do
		--Some non-settings keys are kept reading from global db instead.
		if (NRC.db.global[k] ~= v and k ~= "minimapIcon" and k ~= "lastVersionMsg" and k ~= "raidID" and k ~= "maxRecordsKept"
		and k ~= "maxRecordsShown" and k ~= "maxTradesKept" and k ~= "maxTradesShown" and k ~= "timeStampFormat"
		and k ~= "lastVersionMsg" and k ~= "minimapIcon" and k ~= "minimapButton" and k ~= "timeStringType"
		and k ~= "chatColorR" and k ~= "chatColorG" and k ~= "chatColorB" and k ~= "prefixColorR" and k ~= "prefixColorG"
		and k ~= "prefixColorB" and k ~= "middleColorR" and k ~= "middleColorG" and k ~= "middleColorB" and k ~= "mmColorR"
		and k ~= "mmColorG" and k ~= "mmColorB" and k ~= "detectSameInstance" and k ~= "raidCooldownsBackdropAlpha"
		and k ~= "raidCooldownsBorderAlpha" and k ~= "raidCooldownNumType" and k~= "copyGlobalToProfile"
		and k ~= "raidCooldownsNumType") then
			NRC.config[k] = NRC.db.global[k];
		end
	end
end

--Configuraton options are shared but data is realm and faction specific so I store timer data seperately.
function NRC:loadDatabase()
	NRC.db = LibStub("AceDB-3.0"):New("NRCdatabase", NRC.optionDefaults, "Default");
    NRC.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(NRC.db);
    NRC.profiles.order = 49;
    NRC.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(NRC.db);
    NRC.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("NovaRaidCompanion", "NovaRaidCompanion");
    LibStub("AceConfig-3.0"):RegisterOptionsTable("NovaRaidCompanion", NRC.options);
	--Create realm and faction tables if they don't exist.
	if (not self.db.global[NRC.realm]) then
		self.db.global[NRC.realm] = {};
	end
	if (not self.db.global[NRC.realm][NRC.faction]) then
		self.db.global[NRC.realm][NRC.faction] = {};
	end
	if (not self.db.global[NRC.realm][NRC.faction].raidCooldowns) then
		self.db.global[NRC.realm][NRC.faction].raidCooldowns = {};
	end
	if (not self.db.global[NRC.realm][NRC.faction].hasSoulstone) then
		self.db.global[NRC.realm][NRC.faction].hasSoulstone = {};
	end
	if (not self.db.global[NRC.realm][NRC.faction].myChars) then
		self.db.global[NRC.realm][NRC.faction].myChars = {};
	end
	if (not self.db.global[NRC.realm][NRC.faction].myChars[UnitName("player")]) then
		self.db.global[NRC.realm][NRC.faction].myChars[UnitName("player")] = {};
	end
	local localizedClass, englishClass = UnitClass("player");
	self.db.global[NRC.realm][NRC.faction].myChars[UnitName("player")].localizedClass = localizedClass;
	self.db.global[NRC.realm][NRC.faction].myChars[UnitName("player")].englishClass = englishClass;
	self.db.global[NRC.realm][NRC.faction].myChars[UnitName("player")].level = UnitLevel("player");
	self.db.global[NRC.realm][NRC.faction].myChars[UnitName("player")].race = UnitRace("player");
	self.db.global[NRC.realm][NRC.faction].myChars[UnitName("player")].faction = UnitFactionGroup("player");
	--local defaults = {	
	--};
	--for k, v in pairs(defaults) do
	--	if (not self.db.global[NRC.realm][NRC.faction][k]) then
			--Add default values if no value is already set.
	--		self.db.global[NRC.realm][NRC.faction][k] = v;
	--	end
	--end
	if (not self.db.global.instances) then
		self.db.global.instances = {};
	end
	if (not self.db.global.npcData) then
		self.db.global.npcData = {};
	end
	if (not self.db.global.versions) then
		self.db.global.versions = {};
	end
	if (not self.db.global.trades) then
		self.db.global.trades = {};
	end
	self.data = self.db.global[NRC.realm][NRC.faction];
	self.config = self.db.profile;
	self.db.RegisterCallback(NRC, "OnProfileChanged", "refreshConfig");
	self.db.RegisterCallback(NRC, "OnProfileCopied", "refreshConfig");
	self.db.RegisterCallback(NRC, "OnProfileReset", "refreshConfig");
	--NRC.calcFrame = CreateFrame("frame", "NRCCalcFrame");
	--NRC.calcFrame.fs = NRC.calcFrame:CreateFontString("NRCCalcFrameFS", "ARTWORK");
	---This is a one db copy in v1.08 when profiles were added, it can be removed a few months down the track when people had a chance to update.
	---Delete old globals above at same time.
	if (NRC.db.global.copyGlobalToProfile) then
		copyGlobalDefaults();
		NRC.db.global.copyGlobalToProfile = false;
	end
end

function NRC:refreshConfig(event, database, newProfileKey)
	self.config = database.profile;
end

local linesVersion;
local function loadNewVersionFrame()
	--local frame = NRC:createSimpleScrollFrame("NRCNewVersionFrame", 600, 400, 0, 150, true);
	local frame = NRC:createSimpleScrollFrame("NRCNewVersionFrame", 600, 670, 0, 0, true);
	frame:SetFrameStrata("HIGH");
	frame:SetClampedToScreen(true);
	frame.scrollChild.fs:SetFont(NRC.regionFont, 14);
	frame.scrollChild.fs2:SetFontObject(Game15Font);
	frame.scrollChild.fs3:SetFont(NRC.regionFont, 14);
	frame.scrollChild.fs:ClearAllPoints();
	frame.scrollChild.fs2:ClearAllPoints();
	frame.scrollChild.fs3:ClearAllPoints();
	frame.scrollChild.fs:SetPoint("TOP", 0, -5);
	frame.scrollChild.fs2:SetPoint("TOP", 0, -19);
	frame.scrollChild.fs3:SetPoint("TOPLEFT", 10, -40);
	frame.scrollChild.fs3:SetPoint("RIGHT", 0, -40);
	frame.scrollChild.fs3:SetJustifyH("LEFT");
	frame.scrollChild.fs3:CanWordWrap(true);
	frame.scrollChild.fs3:CanNonSpaceWrap(true);
	frame.scrollChild.fs3:SetNonSpaceWrap(true);
	frame.scrollChild.fs3:SetWordWrap(true);
	frame.scrollChild.fs:SetText("|cFFFFFF00Nova Raid Companion");
	frame.scrollChild.fs2:SetText("|cFFFFFF00New in version|r |cFFFF6900" .. string.format("%.2f", NRC.version));
	frame:Hide();
	linesVersion = 1.24;
	local lines = {
		"New feature: Glyph inspecting.\n-Inspecting a player with NRC or the weakaura helper will also show their glyphs.\n-Clicking the talents icon of a player in the raid status window when expanding with the \"More\" button will show their glyphs if they have NRC.",
		"New feature: Dispels tracking\n-Offensive Dispel options added to send your offensive dispels/purges/tranq shot to group or /say or just print to your own window.\n-Seperate options for your own dispels and other players dispels.\n-This was mainly added for hunter tranq shot removing enrage but works for all classes with a dispel.\n-All dispel options are turned off by default, you need to enable if you want them.\n-New dispels options have also been added to scrolling raid events if you want see them scroll by there.",
		"New feature: Trades exporting to spreadsheet.\n-An export button has been added to the \"All Trades\" window and Trades tab for a specific raid in the log.\n-For \"All Trades\" chose with the sliders the start and end trade to export all between those numbers.\n-For the Trades tab in a specific raid only trades during that raid will be included.",
		"Added autoinvite to group via whisper option with keyword.\nAdded a dropdown box on the loot export window to change date format.\nAdded shortcut to open current raid loot log, control left click minimap button or type /nrc loot.\nAdded raid type (10m/25m) info to minimap button tooltip lockouts and raid log entries.\nAdded Dalaran Intellect and Brilliance buffs to raid status.\nAdded Fort/Int/Motw/Kings runescrolls and drums to raid status.\nAdded Starfall to raid cooldowns.\nAdded Challenging Road aoe taunt to raid cooldowns.\nAdded Fire Elemental Totem to raid cooldowns.\nAdded hunter distracting shot options to announce your cast to group or yell/say.\nItems in the loot log shows tooltip on mouseover instead of clicking, you can still right click an itemlink or anywhere on the entry to change looter.\nFixed Malygos and Sarth data so loot can be assigned correctly and models show up in raid log.\nFixed config option for dk Unholy Frenzy raid cooldown, it can now be enabled.\nFixed config option for druid Tranquility raid cooldown., it can now be enabled.\nFixed priest guardian spirit cooldown not showing up (it had wrong talent data).\nThe NRC helper weakaura has been updated for wrath on wago https://wago.io/sof4ehBA6 (for people without the addon to share shares talents/glyphs data etc).",
	};
	local text = "";
	--Seperator lines couldn't be used because the wow client won't render 1 pixel frames if they are in certain posotions.
	--Not sure what causes some frame lines to render thicker than others and some not render at all.
	local separatorText = "-";
	while (frame.scrollFrame:GetWidth() - 55 > frame.scrollChild.fs3:GetStringWidth()) do
		separatorText = separatorText .. "-";
		frame.scrollChild.fs3:SetText(separatorText);
	end
	text = text .. separatorText .. "\n";
	if (lines) then
		for k, v in ipairs(lines) do
			text = text .. "|cFF9CD6DE" .. v .. "|r\n";
			text = text .. separatorText .. "\n";
			frame.scrollChild.fs3:SetText(text);
			--[[if (not frame.separators[k]) then
				frame.separators[k] = frame.scrollChild:CreateTexture(nil, "BORDER");
				frame.separators[k]:SetColorTexture(0.6, 0.6, 0.6, 0.5);
				frame.separators[k]:SetHeight(2);
			end
			if (k ~= #lines) then
				local offset = frame.scrollChild.fs3:GetStringHeight() - (frame.scrollChild.fs3:GetLineHeight() / 2);
				frame.separators[k]:SetPoint("TOPLEFT", frame.scrollChild.fs3, "TOPLEFT", 0, -offset);
				frame.separators[k]:SetPoint("TOPRIGHT", frame.scrollChild.fs3, "TOPRIGHT", 0, -offset);
			end]]
		end
	end
	if (text ~= "" and linesVersion == NRC.version) then
		frame.scrollChild.fs3:SetText(text);
		frame:Show();
	end
end

function NRC:checkNewVersion()
	--loadNewVersionFrame();
	if (NRC.version and NRC.version ~= 9999) then
		if (not NRC.db.global.versions[NRC.version]) then
			loadNewVersionFrame();
			--NRC:setLockAllFrames(nil, false);
			--Wipe old data.
			NRC.db.global.versions = {};
			--Set this version has been loaded before.
			NRC.db.global.versions[NRC.version] = GetServerTime();
		end
	end
end

--Show mob spawned time.
function NRC:setShowMobSpawnedTime(info, value)
	self.config.showMobSpawnedTime = value;
	NRC:refreshTargetSpawnTimeFrame();
end

function NRC:getShowMobSpawnedTime(info)
	return self.config.showMobSpawnedTime;
end

--Minimap button.
function NRC:setMinimapButton(info, value)
	self.db.global.minimapButton = value;
	if (value) then
		NRC.LDBIcon:Show("NovaRaidCompanion");
		self.db.global.minimapIcon.hide = false;
	else
		NRC.LDBIcon:Hide("NovaRaidCompanion");
		self.db.global.minimapIcon.hide = true;
	end
end

function NRC:getMinimapButton(info)
	return self.db.global.minimapButton;
end

--Log dungeons.
function NRC:setLogDungeons(info, value)
	self.config.logDungeons = value;
end

function NRC:getLogDungeons(info)
	return self.config.logDungeons;
end

--Log raids.
function NRC:setLogRaids(info, value)
	self.config.logRaids = value;
end

function NRC:getLogRaids(info)
	return self.config.logRaids;
end

--Attunement warnings.
function NRC:setAttunementWarnings(info, value)
	self.config.attunementWarnings = value;
end

function NRC:getAttunementWarnings(info)
	return self.config.attunementWarnings;
end

--Show raid cooldowns.
function NRC:setShowRaidCooldowns(info, value)
	self.config.showRaidCooldowns = value;
	NRC:loadRaidCooldownFrames();
	NRC:updateRaidCooldownsVisibility();
end

function NRC:getShowRaidCooldowns(info)
	return self.config.showRaidCooldowns;
end

--Show raid cooldowns in raid.
function NRC:setShowRaidCooldownsInRaid(info, value)
	self.config.showRaidCooldownsInRaid = value;
	NRC:updateRaidCooldownsVisibility();
end

function NRC:getShowRaidCooldownsInRaid(info)
	return self.config.showRaidCooldownsInRaid;
end

--Show raid cooldowns in dungeon.
function NRC:setShowRaidCooldownsInParty(info, value)
	self.config.showRaidCooldownsInParty = value;
	NRC:updateRaidCooldownsVisibility();
end

function NRC:getShowRaidCooldownsInParty(info)
	return self.config.showRaidCooldownsInParty;
end

--Show raid cooldowns in outdoor world.
--[[function NRC:setShowRaidCooldownsInWorld(info, value)
	self.config.showRaidCooldownsInWorld = value;
	NRC:updateRaidCooldownsVisibility();
end

function NRC:getShowRaidCooldownsInWorld(info)
	return self.config.showRaidCooldownsInWorld;
end]]

--Show raid cooldowns in battlegrounds and arena.
function NRC:setShowRaidCooldownsInBG(info, value)
	self.config.showRaidCooldownsInBG = value;
	NRC:updateRaidCooldownsVisibility();
end

function NRC:getShowRaidCooldownsInBG(info)
	return self.config.showRaidCooldownsInBG;
end

--KT no weapons warning.
function NRC:setKtNoWeaponsWarning(info, value)
	self.config.ktNoWeaponsWarning = value;
end

function NRC:getKtNoWeaponsWarning(info)
	return self.config.ktNoWeaponsWarning;
end

--Acid geyser warning.
function NRC:setAcidGeyserWarning(info, value)
	self.config.acidGeyserWarning = value;
end

function NRC:getAcidGeyserWarning(info)
	return self.config.acidGeyserWarning;
end

--Auto sunwell portal.
function NRC:setAutoSunwellPortal(info, value)
	self.config.autoSunwellPortal = value;
end

function NRC:getAutoSunwellPortal(info)
	return self.config.autoSunwellPortal;
end

--Raid cooldown growth direction.
function NRC:setraidCooldownsGrowthDirection(info, value)
	self.db.global.raidCooldownsGrowthDirection = value;
	NRC:updateRaidCooldownFramesLayout();
	NRC:updateRaidCooldowns();
end

function NRC:getraidCooldownsGrowthDirection(info)
	return self.db.global.raidCooldownsGrowthDirection;
end

--Raid cooldown count display type.
function NRC:setRaidCooldownsNumType(info, value)
	self.db.global.raidCooldownsNumType = value;
	NRC:updateRaidCooldowns();
end

function NRC:getRaidCooldownsNumType(info)
	return self.db.global.raidCooldownsNumType;
end

--Raid cooldown border type.
function NRC:setRaidCooldownsBorderType(info, value)
	self.db.global.raidCooldownsBorderType = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsBorderType(info)
	return self.db.global.raidCooldownsBorderType;
end

--Raid cooldown sort order.
function NRC:setRaidCooldownsSortOrder(info, value)
	self.db.global.raidCooldownsSortOrder = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsSortOrder(info)
	return self.db.global.raidCooldownsSortOrder;
end

--Raid cooldown soulstones position.
function NRC:setRaidCooldownsSoulstonesPosition(info, value)
	self.config.raidCooldownsSoulstonesPosition = value;
	NRC:updateRaidCooldownFramesLayout();
	NRC:updateRaidCooldowns();
end

function NRC:getRaidCooldownsSoulstonesPosition(info)
	return self.config.raidCooldownsSoulstonesPosition;
end

--Raid cooldown scale.
function NRC:setRaidCooldownsScale(info, value)
	self.db.global.raidCooldownsScale = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsScale(info)
	return self.db.global.raidCooldownsScale;
end

--Raid cooldown backdrop alpha.
function NRC:setRaidCooldownsBackdropAlpha(info, value)
	self.db.global.raidCooldownsBackdropAlpha = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsBackdropAlpha(info)
	return self.db.global.raidCooldownsBackdropAlpha;
end

--Raid cooldown border alpha.
function NRC:setRaidCooldownsBorderAlpha(info, value)
	self.db.global.raidCooldownsBorderAlpha = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsBorderAlpha(info)
	return self.db.global.raidCooldownsBorderAlpha;
end

--Show soulstone buffs.
function NRC:setRaidCooldownsSoulstones(info, value)
	self.config.raidCooldownsSoulstones = value;
	NRC:updateRaidCooldowns();
end

function NRC:getRaidCooldownsSoulstones(info)
	return self.config.raidCooldownsSoulstones;
end

--Show neck buffs in raid only.
function NRC:setRaidCooldownsNecksRaidOnly(info, value)
	self.config.raidCooldownsNecksRaidOnly = value;
	NRC:loadPartyNeckBuffs();
	NRC:updateRaidCooldowns();
end

function NRC:getRaidCooldownsNecksRaidOnly(info)
	return self.config.raidCooldownsNecksRaidOnly;
end

--Raid cooldowns font.
function NRC:setRaidCooldownsFont(info, value)
	self.db.global.raidCooldownsFont = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsFont(info)
	return self.db.global.raidCooldownsFont;
end

--Raid cooldowns numbers font.
function NRC:setRaidCooldownsFontNumbers(info, value)
	self.db.global.raidCooldownsFontNumbers = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsFontNumbers(info)
	return self.db.global.raidCooldownsFontNumbers;
end

--Raid cooldowns font size.
function NRC:setRaidCooldownsFontSize(info, value)
	self.db.global.raidCooldownsFontSize = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsFontSize(info)
	return self.db.global.raidCooldownsFontSize;
end

--Raid cooldowns font outline.
function NRC:setRaidCooldownsFontOutline(info, value)
	self.db.global.raidCooldownsFontOutline = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsFontOutline(info)
	return self.db.global.raidCooldownsFontOutline;
end

--Raid cooldowns width.
function NRC:setRaidCooldownsWidth(info, value)
	self.db.global.raidCooldownsWidth = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsWidth(info)
	return self.db.global.raidCooldownsWidth;
end

--Raid cooldowns height.
function NRC:setRaidCooldownsHeight(info, value)
	self.db.global.raidCooldownsHeight = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsHeight(info)
	return self.db.global.raidCooldownsHeight;
end

--Disable mouseover when inactive.
function NRC:setRaidCooldownsDisableMouse(info, value)
	self.db.global.raidCooldownsDisableMouse = value;
	NRC:updateRaidCooldownFramesLayout();
end

function NRC:getRaidCooldownsDisableMouse(info)
	return self.db.global.raidCooldownsDisableMouse;
end

--Raid status scale.
function NRC:setRaidStatusScale(info, value)
	self.db.global.raidStatusScale = value;
	NRC:setRaidStatusSize();
end

function NRC:getRaidStatusScale(info)
	return self.db.global.raidStatusScale;
end

--Show raid status on ready check.
function NRC:setRaidStatusShowReadyCheck(info, value)
	self.config.raidStatusShowReadyCheck = value;
end

function NRC:getRaidStatusShowReadyCheck(info)
	return self.config.raidStatusShowReadyCheck;
end

--Fade raid status on ready check complete.
function NRC:setRaidStatusFadeReadyCheck(info, value)
	self.config.raidStatusFadeReadyCheck = value;
end

function NRC:getRaidStatusFadeReadyCheck(info)
	return self.config.raidStatusFadeReadyCheck;
end

--Hide raid status if combat starts.
function NRC:setRaidStatusHideCombat(info, value)
	self.config.raidStatusHideCombat = value;
end

function NRC:getRaidStatusHideCombat(info)
	return self.config.raidStatusHideCombat;
end

--Merge raid cooldown list.
function NRC:setMergeRaidCooldowns(info, value)
	self.config.mergeRaidCooldowns = value;
	local frames = {NRCRaidCooldowns:GetChildren()};
	for k, v in ipairs(frames) do
		if (v.fs4) then
			v.fs4:SetText("");
		end
	end
	NRC:updateRaidCooldowns();
end

function NRC:getMergeRaidCooldowns(info)
	return self.config.mergeRaidCooldowns;
end

--Raid cooldowns left click.
function NRC:setRaidCooldownsLeftClick(info, value)
	self.config.raidCooldownsLeftClick = value;
end

function NRC:getRaidCooldownsLeftClick(info)
	return self.config.raidCooldownsLeftClick;
end

--Raid cooldowns right click.
function NRC:setRaidCooldownsRightClick(info, value)
	self.config.raidCooldownsRightClick = value;
end

function NRC:getRaidCooldownsRightClick(info)
	return self.config.raidCooldownsRightClick;
end

--Raid cooldowns shift left click.
function NRC:setRaidCooldownsShiftLeftClick(info, value)
	self.config.raidCooldownsShiftLeftClick = value;
end

function NRC:getRaidCooldownsShiftLeftClick(info)
	return self.config.raidCooldownsShiftLeftClick;
end

--Raid Cooldowns shift right click.
function NRC:setRaidCooldownsShiftRightClick(info, value)
	self.config.raidCooldownsShiftRightClick = value;
end

function NRC:getRaidCooldownsShiftRightClick(info)
	return self.config.raidCooldownsShiftRightClick;
end

--Neck buff raid cooldowns.
--[[function NRC:setRaidCooldownNeckBuffs(info, value)
	self.config.raidCooldownNeckBuffs = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownNeckBuffs(info)
	return self.config.raidCooldownNeckBuffs;
end]]

--Neck SP buff raid cooldowns.
function NRC:setRaidCooldownNeckSP(info, value)
	self.config.raidCooldownNeckSP = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownNeckSP(info)
	return self.config.raidCooldownNeckSP;
end

--Neck Crit buff raid cooldowns.
function NRC:setRaidCooldownNeckCrit(info, value)
	self.config.raidCooldownNeckCrit = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownNeckCrit(info)
	return self.config.raidCooldownNeckCrit;
end

--Neck CritRating buff raid cooldowns.
function NRC:setRaidCooldownNeckCritRating(info, value)
	self.config.raidCooldownNeckCritRating = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownNeckCritRating(info)
	return self.config.raidCooldownNeckCritRating;
end

--Neck Stam buff raid cooldowns.
function NRC:setRaidCooldownNeckStam(info, value)
	self.config.raidCooldownNeckStam = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownNeckStam(info)
	return self.config.raidCooldownNeckStam;
end

--Neck HP5 buff raid cooldowns.
function NRC:setRaidCooldownNeckHP5(info, value)
	self.config.raidCooldownNeckHP5 = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownNeckHP5(info)
	return self.config.raidCooldownNeckHP5;
end

--Neck Stats buff raid cooldowns.
function NRC:setRaidCooldownNeckStats(info, value)
	self.config.raidCooldownNeckStats = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownNeckStats(info)
	return self.config.raidCooldownNeckStats;
end

--Cooldown frame count.
function NRC:setCooldownFrameCount(info, value)
	self.config.cooldownFrameCount = value;
	NRC:loadRaidCooldownFrames();
	NRC:reloadRaidCooldowns();
end

function NRC:getCooldownFrameCount(info)
	return self.config.cooldownFrameCount;
end
		
--Death Knight raid cooldowns.
function NRC:setRaidCooldownArmyoftheDead(info, value)
	self.config.raidCooldownArmyoftheDead = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownArmyoftheDead(info)
	return self.config.raidCooldownArmyoftheDead;
end

function NRC:setRaidCooldownIceboundFortitude(info, value)
	self.config.raidCooldownIceboundFortitude = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownIceboundFortitude(info)
	return self.config.raidCooldownIceboundFortitude;
end

function NRC:setRaidCooldownAntiMagicZone(info, value)
	self.config.raidCooldownAntiMagicZone = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownAntiMagicZone(info)
	return self.config.raidCooldownAntiMagicZone;
end

function NRC:setRaidCooldownAntiMagicShield(info, value)
	self.config.raidCooldownAntiMagicShield = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownAntiMagicShield(info)
	return self.config.raidCooldownAntiMagicShield;
end

function NRC:setRaidCooldownUnholyFrenzy(info, value)
	self.config.raidCooldownUnholyFrenzy = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownUnholyFrenzy(info)
	return self.config.raidCooldownUnholyFrenzy;
end

function NRC:setRaidCooldownVampiricBlood(info, value)
	self.config.raidCooldownVampiricBlood = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownVampiricBlood(info)
	return self.config.raidCooldownVampiricBlood;
end

--Druid raid cooldowns.
function NRC:setRaidCooldownRebirth(info, value)
	self.config.raidCooldownRebirth = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownRebirth(info)
	return self.config.raidCooldownRebirth;
end

function NRC:setRaidCooldownInnervate(info, value)
	self.config.raidCooldownInnervate = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownInnervate(info)
	return self.config.raidCooldownInnervate;
end

function NRC:setRaidCooldownTranquility(info, value)
	self.config.raidCooldownTranquility = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownTranquility(info)
	return self.config.raidCooldownTranquility;
end

function NRC:setRaidCooldownSurvivalInstincts(info, value)
	self.config.raidCooldownSurvivalInstincts = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownSurvivalInstincts(info)
	return self.config.raidCooldownSurvivalInstincts;
end

function NRC:setRaidCooldownChallengingRoar(info, value)
	self.config.raidCooldownChallengingRoar = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownChallengingRoar(info)
	return self.config.raidCooldownChallengingRoar;
end

function NRC:setRaidCooldownStarfall(info, value)
	self.config.raidCooldownStarfall = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownStarfall(info)
	return self.config.raidCooldownStarfall;
end

--Hunter raid cooldowns.
function NRC:setRaidCooldownMisdirection(info, value)
	self.config.raidCooldownMisdirection = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownMisdirection(info)
	return self.config.raidCooldownMisdirection;
end

--Mage raid cooldowns.
function NRC:setRaidCooldownEvocation(info, value)
	self.config.raidCooldownEvocation = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownEvocation(info)
	return self.config.raidCooldownEvocation;
end

function NRC:setRaidCooldownIceBlock(info, value)
	self.config.raidCooldownIceBlock = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownIceBlock(info)
	return self.config.raidCooldownIceBlock;
end

function NRC:setRaidCooldownInvisibility(info, value)
	self.config.raidCooldownInvisibility = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownInvisibility(info)
	return self.config.raidCooldownInvisibility;
end

--Paladin raid cooldowns.
function NRC:setRaidCooldownDivineIntervention(info, value)
	self.config.raidCooldownDivineIntervention = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownDivineIntervention(info)
	return self.config.raidCooldownDivineIntervention;
end

function NRC:setRaidCooldownDivineShield(info, value)
	self.config.raidCooldownDivineShield = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownDivineShield(info)
	return self.config.raidCooldownDivineShield;
end

function NRC:setRaidCooldownLayonHands(info, value)
	self.config.raidCooldownLayonHands = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownLayonHands(info)
	return self.config.raidCooldownLayonHands;
end

function NRC:setRaidCooldownBlessingofProtection(info, value)
	self.config.raidCooldownBlessingofProtection = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownBlessingofProtection(info)
	return self.config.raidCooldownBlessingofProtection;
end

function NRC:setRaidCooldownHandofProtection(info, value)
	self.config.raidCooldownHandofProtection = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownHandofProtection(info)
	return self.config.raidCooldownHandofProtection;
end

function NRC:setRaidCooldownDivineGuardian(info, value)
	self.config.raidCooldownDivineGuardian = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownDivineGuardian(info)
	return self.config.raidCooldownDivineGuardian;
end

function NRC:setRaidCooldownDivineSacrifice(info, value)
	self.config.raidCooldownDivineSacrifice = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownDivineSacrifice(info)
	return self.config.raidCooldownDivineSacrifice;
end

function NRC:setRaidCooldownAuraMastery(info, value)
	self.config.raidCooldownAuraMastery = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownAuraMastery(info)
	return self.config.raidCooldownAuraMastery;
end

function NRC:setRaidCooldownDivineProtection(info, value)
	self.config.raidCooldownDivineProtection = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownDivineProtection(info)
	return self.config.raidCooldownDivineProtection;
end

function NRC:setRaidCooldownHandofSacrifice(info, value)
	self.config.raidCooldownHandofSacrifice = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownHandofSacrifice(info)
	return self.config.raidCooldownHandofSacrifice;
end

function NRC:setRaidCooldownHandofSalvation(info, value)
	self.config.raidCooldownHandofSalvation = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownHandofSalvation(info)
	return self.config.raidCooldownHandofSalvation;
end

--Priest raid cooldowns.
function NRC:setRaidCooldownFearWard(info, value)
	self.config.raidCooldownFearWard = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownFearWard(info)
	return self.config.raidCooldownFearWard;
end

function NRC:setRaidCooldownShadowfiend(info, value)
	self.config.raidCooldownShadowfiend = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownShadowfiend(info)
	return self.config.raidCooldownShadowfiend;
end

function NRC:setRaidCooldownPsychicScream(info, value)
	self.config.raidCooldownPsychicScream = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownPsychicScream(info)
	return self.config.raidCooldownPsychicScream;
end

function NRC:setRaidCooldownPowerInfusion(info, value)
	self.config.raidCooldownPowerInfusion = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownPowerInfusion(info)
	return self.config.raidCooldownPowerInfusion;
end

function NRC:setRaidCooldownPainSuppression(info, value)
	self.config.raidCooldownPainSuppression = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownPainSuppression(info)
	return self.config.raidCooldownPainSuppression;
end

function NRC:setRaidCooldownDivineHymn(info, value)
	self.config.raidCooldownDivineHymn = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownDivineHymn(info)
	return self.config.raidCooldownDivineHymn;
end

function NRC:setRaidCooldownHymnofHope(info, value)
	self.config.raidCooldownHymnofHope = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownHymnofHope(info)
	return self.config.raidCooldownHymnofHope;
end

function NRC:setRaidCooldownGuardianSpirit(info, value)
	self.config.raidCooldownGuardianSpirit = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownGuardianSpirit(info)
	return self.config.raidCooldownGuardianSpirit;
end

--Rogue raid cooldowns.
function NRC:setRaidCooldownBlind(info, value)
	self.config.raidCooldownBlind = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownBlind(info)
	return self.config.raidCooldownBlind;
end

function NRC:setRaidCooldownVanish(info, value)
	self.config.raidCooldownVanish = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownVanish(info)
	return self.config.raidCooldownVanish;
end

function NRC:setRaidCooldownEvasion(info, value)
	self.config.raidCooldownEvasion = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownEvasion(info)
	return self.config.raidCooldownEvasion;
end

function NRC:setRaidCooldownDistract(info, value)
	self.config.raidCooldownDistract = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownDistract(info)
	return self.config.raidCooldownDistract;
end

function NRC:setRaidCooldownTricksoftheTrade(info, value)
	self.config.raidCooldownTricksoftheTrade = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownTricksoftheTrade(info)
	return self.config.raidCooldownTricksoftheTrade;
end

--Shaman raid cooldowns.
function NRC:setRaidCooldownEarthElemental(info, value)
	self.config.raidCooldownEarthElemental = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownEarthElemental(info)
	return self.config.raidCooldownEarthElemental;
end

function NRC:setRaidCooldownFireElemental(info, value)
	self.config.raidCooldownFireElemental = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownFireElemental(info)
	return self.config.raidCooldownFireElemental;
end

function NRC:setRaidCooldownReincarnation(info, value)
	self.config.raidCooldownReincarnation = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownReincarnation(info)
	return self.config.raidCooldownReincarnation;
end

function NRC:setRaidCooldownHeroism(info, value)
	self.config.raidCooldownHeroism = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownHeroism(info)
	return self.config.raidCooldownHeroism;
end

function NRC:setRaidCooldownBloodlust(info, value)
	self.config.raidCooldownBloodlust = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownBloodlust(info)
	return self.config.raidCooldownBloodlust;
end

function NRC:setRaidCooldownManaTide(info, value)
	self.config.raidCooldownManaTide = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownManaTide(info)
	return self.config.raidCooldownManaTide;
end

--Warlock raid cooldowns.
function NRC:setRaidCooldownSoulstone(info, value)
	self.config.raidCooldownSoulstone = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownSoulstone(info)
	return self.config.raidCooldownSoulstone;
end

function NRC:setRaidCooldownSoulshatter(info, value)
	self.config.raidCooldownSoulshatter = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownSoulshatter(info)
	return self.config.raidCooldownSoulshatter;
end

function NRC:setRaidCooldownDeathCoil(info, value)
	self.config.raidCooldownDeathCoil = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownDeathCoil(info)
	return self.config.raidCooldownDeathCoil;
end

function NRC:setRaidCooldownRitualofSouls(info, value)
	self.config.raidCooldownRitualofSouls = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownRitualofSouls(info)
	return self.config.raidCooldownRitualofSouls;
end

--Warrior raid cooldowns.
function NRC:setRaidCooldownChallengingShout(info, value)
	self.config.raidCooldownChallengingShout = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownChallengingShout(info)
	return self.config.raidCooldownChallengingShout;
end

function NRC:setRaidCooldownIntimidatingShout(info, value)
	self.config.raidCooldownIntimidatingShout = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownIntimidatingShout(info)
	return self.config.raidCooldownIntimidatingShout;
end

function NRC:setRaidCooldownMockingBlow(info, value)
	self.config.raidCooldownMockingBlow = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownMockingBlow(info)
	return self.config.raidCooldownMockingBlow;
end

function NRC:setRaidCooldownRecklessness(info, value)
	self.config.raidCooldownRecklessness = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownRecklessness(info)
	return self.config.raidCooldownRecklessness;
end

function NRC:setRaidCooldownShieldWall(info, value)
	self.config.raidCooldownShieldWall = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownShieldWall(info)
	return self.config.raidCooldownShieldWall;
end

function NRC:setRaidCooldownBladestorm(info, value)
	self.config.raidCooldownBladestorm = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownBladestorm(info)
	return self.config.raidCooldownBladestorm;
end

function NRC:setRaidCooldownShatteringThrow(info, value)
	self.config.raidCooldownShatteringThrow = value;
	NRC:reloadRaidCooldowns();
end

function NRC:getRaidCooldownShatteringThrow(info)
	return self.config.raidCooldownShatteringThrow;
end

--Raid status font.
function NRC:setRaidStatusFont(info, value)
	self.db.global.raidStatusFont = value;
	NRC:updateRaidStatusFramesLayout();
end

function NRC:getRaidStatusFont(info)
	return self.db.global.raidStatusFont;
end

--Raid status font size.
function NRC:setRaidStatusFontSize(info, value)
	self.db.global.raidStatusFontSize = value;
	NRC:updateRaidStatusFramesLayout();
end

function NRC:getRaidStatusFontSize(info)
	return self.db.global.raidStatusFontSize;
end

--Raid status font outline.
--[[function NRC:setRaidStatusFontOutline(info, value)
	self.db.global.raidStatusFontOutline = value;
	NRC:updateRaidStatusFramesLayout();
end

function NRC:getRaidStatusFontOutline(info)
	return self.db.global.raidStatusFontOutline;
end]]

--Raid status flask.
function NRC:setRaidStatusFlask(info, value)
	self.config.raidStatusFlask = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusFlask(info)
	return self.config.raidStatusFlask;
end

--Raid status food.
function NRC:setRaidStatusFood(info, value)
	self.config.raidStatusFood = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusFood(info)
	return self.config.raidStatusFood;
end

--Raid status scroll.
function NRC:setRaidStatusScroll(info, value)
	self.config.raidStatusScroll = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusScroll(info)
	return self.config.raidStatusScroll;
end

--Raid status int.
function NRC:setRaidStatusInt(info, value)
	self.config.raidStatusInt = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusInt(info)
	return self.config.raidStatusInt;
end

--Raid status fort.
function NRC:setRaidStatusFort(info, value)
	self.config.raidStatusFort = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusFort(info)
	return self.config.raidStatusFort;
end

--Raid status spirit.
function NRC:setRaidStatusSpirit(info, value)
	self.config.raidStatusSpirit = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusSpirit(info)
	return self.config.raidStatusSpirit;
end

--Raid status shadow.
function NRC:setRaidStatusShadow(info, value)
	self.config.raidStatusShadow = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusShadow(info)
	return self.config.raidStatusShadow;
end

--Raid status motw.
function NRC:setRaidStatusMotw(info, value)
	self.config.raidStatusMotw = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusMotw(info)
	return self.config.raidStatusMotw;
end

--Raid status pal.
function NRC:setRaidStatusPal(info, value)
	self.config.raidStatusPal = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusPal(info)
	return self.config.raidStatusPal;
end

--Raid status dura.
function NRC:setRaidStatusDura(info, value)
	self.config.raidStatusDura = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusDura(info)
	return self.config.raidStatusDura;
end

--Raid status shadow.
function NRC:setRaidStatusShadowRes(info, value)
	self.config.raidStatusShadowRes = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusShadowRes(info)
	return self.config.raidStatusShadowRes;
end

--Raid status fire.
function NRC:setRaidStatusFireRes(info, value)
	self.config.raidStatusFireRes = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusFireRes(info)
	return self.config.raidStatusFireRes;
end

--Raid status nature.
function NRC:setRaidStatusNatureRes(info, value)
	self.config.raidStatusNatureRes = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusNatureRes(info)
	return self.config.raidStatusNatureRes;
end

--Raid status frost.
function NRC:setRaidStatusFrostRes(info, value)
	self.config.raidStatusFrostRes = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusFrostRes(info)
	return self.config.raidStatusFrostRes;
end

--Raid status arcane.
function NRC:setRaidStatusArcaneRes(info, value)
	self.config.raidStatusArcaneRes = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusArcaneRes(info)
	return self.config.raidStatusArcaneRes;
end

--Raid status weapon enchants.
function NRC:setRaidStatusWeaponEnchants(info, value)
	self.config.raidStatusWeaponEnchants = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusWeaponEnchants(info)
	return self.config.raidStatusWeaponEnchants;
end

--Raid talents.
function NRC:setRaidStatusTalents(info, value)
	self.config.raidStatusTalents = value;
	NRC:reloadRaidStatusFrames();
end

function NRC:getRaidStatusTalents(info)
	return self.config.raidStatusTalents;
end

--Raid status always show more.
function NRC:setRaidStatusExpandAlways(info, value)
	self.config.raidStatusExpandAlways = value;
end

function NRC:getRaidStatusExpandAlways(info)
	return self.config.raidStatusExpandAlways;
end

--Summon msg.
function NRC:setSummonMsg(info, value)
	self.config.summonMsg = value;
end

function NRC:getSummonMsg(info)
	return self.config.summonMsg;
end

--Summon stone msg.
function NRC:setSummonStoneMsg(info, value)
	self.config.summonStoneMsg = value;
end

function NRC:getSummonStoneMsg(info)
	return self.config.summonStoneMsg;
end

--Heathstone msg.
function NRC:setHealthstoneMsg(info, value)
	self.config.healthstoneMsg = value;
end

function NRC:getHealthstoneMsg(info)
	return self.config.healthstoneMsg;
end

--Soulstone msg say.
function NRC:setsoulstoneMsgSay(info, value)
	self.config.soulstoneMsgSay = value;
end

function NRC:getsoulstoneMsgSay(info)
	return self.config.soulstoneMsgSay;
end

--Soulstone msg group.
function NRC:setsoulstoneMsgGroup(info, value)
	self.config.soulstoneMsgGroup = value;
end

function NRC:getsoulstoneMsgGroup(info)
	return self.config.soulstoneMsgGroup;
end

--Durability warning.
function NRC:setDuraWarning(info, value)
	self.config.duraWarning = value;
end

function NRC:getDuraWarning(info)
	return self.config.duraWarning;
end

--Raid database size.
function NRC:setMaxRecordsKept(info, value)
	self.db.global.maxRecordsKept = value;
end

function NRC:getMaxRecordsKept(info)
	return self.db.global.maxRecordsKept;
end

--Raids shown in log.
function NRC:setMaxRecordsShown(info, value)
	self.db.global.maxRecordsShown = value;
end

function NRC:getMaxRecordsShown(info)
	return self.db.global.maxRecordsShown;
end

--Trades database size.
function NRC:setMaxTradesKept(info, value)
	self.db.global.maxTradesKept = value;
end

function NRC:getMaxTradesKept(info)
	return self.db.global.maxTradesKept;
end

--Trades shown in log.
function NRC:setMaxTradesShown(info, value)
	self.db.global.maxTradesShown = value;
end

function NRC:getMaxTradesShown(info)
	return self.db.global.maxTradesShown;
end

--Trade msgs in chat.
function NRC:setShowMoneyTradedChat(info, value)
	self.config.showMoneyTradedChat = value;
end

function NRC:getShowMoneyTradedChat(info)
	return self.config.showMoneyTradedChat;
end

--Show NRC talents frame when inspecting someone.
function NRC:setShowInspectTalents(info, value)
	self.config.showInspectTalents = value;
	NRC:updateInspectTalentsCheckBoxFromConfig(value);
end

function NRC:getShowInspectTalents(info)
	return self.config.showInspectTalents;
end

--Auto start combat logging.
function NRC:setAutoCombatLog(info, value)
	self.config.autoCombatLog = value;
	if (value) then
		NRC:startCombatLogging();
	end
end

function NRC:getAutoCombatLog(info)
	return self.config.autoCombatLog;
end

--Cauldron msg.
function NRC:setCauldronMsg(info, value)
	self.config.cauldronMsg = value;
end

function NRC:getCauldronMsg(info)
	return self.config.cauldronMsg;
end

--Check meta gem.
function NRC:setCheckMetaGem(info, value)
	self.config.checkMetaGem = value;
end

function NRC:getCheckMetaGem(info)
	return self.config.checkMetaGem;
end

--Release warning.
function NRC:setReleaseWarning(info, value)
	self.config.releaseWarning = value;
end

function NRC:getReleaseWarning(info)
	return self.config.releaseWarning;
end

--Train set.
function NRC:setShowTrainset(info, value)
	self.config.showTrainset = value;
end

function NRC:getShowTrainset(info)
	return self.config.showTrainset;
end

--Auto inv.
function NRC:setAutoInv(info, value)
	self.config.autoInv = value;
end

function NRC:getAutoInv(info)
	return self.config.autoInv;
end

--Auto inv keyword.
function NRC:setAutoInvKeyword(info, value)
	self.config.autoInvKeyword = value;
end

function NRC:getAutoInvKeyword(info)
	return self.config.autoInvKeyword;
end

--Colorize raid status groups.
function NRC:setSortRaidStatusByGroupsColor(info, value)
	self.config.sortRaidStatusByGroupsColor = value;
	NRC:updateRaidStatusGroupColors();
end

function NRC:getSortRaidStatusByGroupsColor(info)
	return self.config.sortRaidStatusByGroupsColor;
end

--Colorize raid status groups background.
function NRC:setSortRaidStatusByGroupsColorBackground(info, value)
	self.config.sortRaidStatusByGroupsColorBackground = value;
	NRC:updateRaidStatusGroupColors();
end

function NRC:getSortRaidStatusByGroupsColorBackground(info)
	return self.config.sortRaidStatusByGroupsColorBackground;
end

--Which timestamp format to use 12h/24h.
function NRC:setTimeStampFormat(info, value)
	self.db.global.timeStampFormat = value;
end

function NRC:getTimeStampFormat(info)
	return self.db.global.timeStampFormat;
end
		
--My MD cast in group.
function NRC:setMdSendMyCastGroup(info, value)
	self.config.mdSendMyCastGroup = value;
	NRC:throddleEventByFunc("CONFIG_UPDATE", 3, "sendSettings");
end

function NRC:getMdSendMyCastGroup(info)
	return self.config.mdSendMyCastGroup;
end

--MD cast in say.
function NRC:setMdSendMyCastSay(info, value)
	self.config.mdSendMyCastSay = value;
end

function NRC:getMdSendMyCastSay(info)
	return self.config.mdSendMyCastSay;
end

--Other MD cast in group.
function NRC:setMdSendOtherCastGroup(info, value)
	self.config.mdSendOtherCastGroup = value;
	NRC:throddleEventByFunc("CONFIG_UPDATE", 3, "sendSettings");
end

function NRC:getMdSendOtherCastGroup(info)
	return self.config.mdSendOtherCastGroup;
end

--My MD threat in group.
function NRC:setMdSendMyThreatGroup(info, value)
	self.config.mdSendMyThreatGroup = value;
	NRC:throddleEventByFunc("CONFIG_UPDATE", 3, "sendSettings");
end

function NRC:getMdSendMyThreatGroup(info)
	return self.config.mdSendMyThreatGroup;
end

--My MD threat in say.
function NRC:setMdSendMyThreatSay(info, value)
	self.config.mdSendMyThreatSay = value;
end

function NRC:getMdSendMyThreatSay(info)
	return self.config.mdSendMyThreatSay;
end

--Others MD threat in group.
function NRC:setMdSendOthersThreatGroup(info, value)
	self.config.mdSendOthersThreatGroup = value;
	NRC:throddleEventByFunc("CONFIG_UPDATE", 3, "sendSettings");
end

function NRC:getMdSendOthersThreatGroup(info)
	return self.config.mdSendOthersThreatGroup;
end

--Others MD threat in say.
function NRC:setMdSendOthersThreatSay(info, value)
	self.config.mdSendOthersThreatSay = value;
end

function NRC:getMdSendOthersThreatSay(info)
	return self.config.mdSendOthersThreatSay;
end

--Print my MD threat to chat.
function NRC:setMdShowMySelf(info, value)
	self.config.mdShowMySelf = value;
end

function NRC:getMdShowMySelf(info)
	return self.config.mdShowMySelf;
end

--Print others MD threat to chat.
function NRC:setMdShowOthersSelf(info, value)
	self.config.mdShowOthersSelf = value;
end

function NRC:getMdShowOthersSelf(info)
	return self.config.mdShowOthersSelf;
end

--Show MD spells.
function NRC:setMdShowSpells(info, value)
	self.config.mdShowSpells = value;
end

function NRC:getMdShowSpells(info)
	return self.config.mdShowSpells;
end

--Show MD spells other players.
function NRC:setMdShowSpellsOther(info, value)
	self.config.mdShowSpellsOther = value;
end

function NRC:getMdShowSpellsOther(info)
	return self.config.mdShowSpellsOther;
end

--Send threat msg to tank.
function NRC:setMdSendTarget(info, value)
	self.config.mdSendTarget = value;
end

function NRC:getMdSendTarget(info)
	return self.config.mdSendTarget;
end

--Low ammo check.
function NRC:setLowAmmoCheck(info, value)
	self.config.lowAmmoCheck = value;
end

function NRC:getLowAmmoCheck(info)
	return self.config.lowAmmoCheck;
end

--Low ammo check threshold.
function NRC:setLowAmmoCheckThreshold(info, value)
	self.config.lowAmmoCheckThreshold = value;
end

function NRC:getLowAmmoCheckThreshold(info)
	return self.config.lowAmmoCheckThreshold;
end

--Distracting Shot group msg.
function NRC:setHunterDistractingShotGroup(info, value)
	self.config.hunterDistractingShotGroup = value;
end

function NRC:getHunterDistractingShotGroup(info)
	return self.config.hunterDistractingShotGroup;
end

--Distracting Shot say msg.
function NRC:setHunterDistractingShotSay(info, value)
	self.config.hunterDistractingShotSay = value;
end

function NRC:getHunterDistractingShotSay(info)
	return self.config.hunterDistractingShotSay;
end

--Distracting Shot yell msg.
function NRC:setHunterDistractingShotYell(info, value)
	self.config.hunterDistractingShotYell = value;
end

function NRC:getHunterDistractingShotYell(info)
	return self.config.hunterDistractingShotYell;
end

--SRE animaton speed.
function NRC:setSreAnimationSpeed(info, value)
	self.config.sreAnimationSpeed = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreAnimationSpeed(info)
	return self.config.sreAnimationSpeed;
end

--SRE line scale.
function NRC:setSreLineFrameScale(info, value)
	self.config.sreLineFrameScale = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreLineFrameScale(info)
	return self.config.sreLineFrameScale;
end

--SRE scroll height.
function NRC:setSreScrollHeight(info, value)
	self.config.sreScrollHeight = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreScrollHeight(info)
	return self.config.sreScrollHeight;
end

--SRE growth direction.
function NRC:setSreGrowthDirection(info, value)
	self.config.sreGrowthDirection = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreGrowthDirection(info)
	return self.config.sreGrowthDirection;
end

--SRE alignment.
function NRC:setSreAlignment(info, value)
	self.config.sreAlignment = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreAlignment(info)
	return self.config.sreAlignment;
end

--SRE font.
function NRC:setSreFont(info, value)
	self.db.global.sreFont = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreFont(info)
	return self.db.global.sreFont;
end

--SRE font outline.
function NRC:setSreFontOutline(info, value)
	self.db.global.sreFontOutline = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreFontOutline(info)
	return self.db.global.sreFontOutline;
end

--SRE add raid cooldowns list to sre.
function NRC:setSreAddRaidCooldownsToSpellList(info, value)
	self.config.sreAddRaidCooldownsToSpellList = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreAddRaidCooldownsToSpellList(info)
	return self.config.sreAddRaidCooldownsToSpellList;
end

--SRE show when cooldowns reset.
function NRC:setSreShowCooldownReset(info, value)
	self.config.sreShowCooldownReset = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowCooldownReset(info)
	return self.config.sreShowCooldownReset;
end

--SRE enabled.
function NRC:setSreEnabled(info, value)
	self.config.sreEnabled = value;
	NRC:loadScrollingRaidEventsFrames();
end

function NRC:getSreEnabled(info)
	return self.config.sreEnabled;
end

--SRE enabled everywhere.
function NRC:setSreEnabledEverywhere(info, value)
	self.config.sreEnabledEverywhere = value;
	NRC:loadScrollingRaidEventsFrames();
end

function NRC:getSreEnabledEverywhere(info)
	return self.config.sreEnabledEverywhere;
end

--SRE enabled raid.
function NRC:setSreEnabledRaid(info, value)
	self.config.sreEnabledRaid = value;
	NRC:loadScrollingRaidEventsFrames();
end

function NRC:getSreEnabledRaid(info)
	return self.config.sreEnabledRaid;
end

--SRE enabled pvp.
function NRC:setSreEnabledPvP(info, value)
	self.config.sreEnabledPvP = value;
	NRC:loadScrollingRaidEventsFrames();
end

function NRC:getSreEnabledPvP(info)
	return self.config.sreEnabledPvP;
end

--SRE group members only.
function NRC:setSreGroupMembers(info, value)
	self.config.sreGroupMembers = value;
	NRC:loadScrollingRaidEventsFrames();
end

function NRC:getSreGroupMembers(info)
	return self.config.sreGroupMembers;
end

--SRE show my spells.
function NRC:setSreShowSelf(info, value)
	self.config.sreShowSelf = value;
	NRC:loadScrollingRaidEventsFrames();
end

function NRC:getSreShowSelf(info)
	return self.config.sreShowSelf;
end

--SRE show my spells in raid only.
function NRC:setSreShowSelfRaidOnly(info, value)
	self.config.sreShowSelfRaidOnly = value;
	NRC:loadScrollingRaidEventsFrames();
end

function NRC:getSreShowSelfRaidOnly(info)
	return self.config.sreShowSelfRaidOnly;
end

--SRE show all players.
function NRC:setSreAllPlayers(info, value)
	self.config.sreAllPlayers = value;
	NRC:loadScrollingRaidEventsFrames();
end

function NRC:getSreAllPlayers(info)
	return self.config.sreAllPlayers;
end

--SRE show npcs.
function NRC:setSreNpcs(info, value)
	self.config.sreNpcs = value;
	NRC:loadScrollingRaidEventsFrames();
end

function NRC:getSreNpcs(info)
	return self.config.sreNpcs;
end

--SRE show npcs raid only.
function NRC:setSreNpcsRaidOnly(info, value)
	self.config.sreNpcsRaidOnly = value;
	NRC:loadScrollingRaidEventsFrames();
end

function NRC:getSreNpcsRaidOnly(info)
	return self.config.sreNpcsRaidOnly;
end

--SRE show interrupts.
function NRC:setSreShowInterrupts(info, value)
	self.config.sreShowInterrupts = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowInterrupts(info)
	return self.config.sreShowInterrupts;
end

--SRE show dispels.
function NRC:setSreShowDispels(info, value)
	self.config.sreShowDispels = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowDispels(info)
	return self.config.sreShowDispels;
end

--SRE show cauldrons.
function NRC:setSreShowCauldrons(info, value)
	self.config.sreShowCauldrons = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowCauldrons(info)
	return self.config.sreShowCauldrons;
end

--SRE show soulstone res used.
function NRC:setSreShowSoulstoneRes(info, value)
	self.config.sreShowSoulstoneRes = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowSoulstoneRes(info)
	return self.config.sreShowSoulstoneRes;
end

--SRE show mana pots.
function NRC:setSreShowManaPotions(info, value)
	self.config.sreShowManaPotions = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowManaPotions(info)
	return self.config.sreShowManaPotions;
end

--SRE show health pots.
function NRC:setSreShowHealthPotions(info, value)
	self.config.sreShowHealthPotions = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowHealthPotions(info)
	return self.config.sreShowHealthPotions;
end

--SRE show dps pots.
function NRC:setSreShowDpsPotions(info, value)
	self.config.sreShowDpsPotions = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowDpsPotions(info)
	return self.config.sreShowDpsPotions;
end

--SRE show mage portals.
function NRC:setSreShowMagePortals(info, value)
	self.config.sreShowMagePortals = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowMagePortals(info)
	return self.config.sreShowMagePortals;
end

--SRE show resurrections.
function NRC:setSreShowResurrections(info, value)
	self.config.sreShowResurrections = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowResurrections(info)
	return self.config.sreShowResurrections;
end

--SRE show misdirection.
function NRC:setSreShowMisdirection(info, value)
	self.config.sreShowMisdirection = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowMisdirection(info)
	return self.config.sreShowMisdirection;
end

--SRE show spell name.
function NRC:setSreShowSpellName(info, value)
	self.config.sreShowSpellName = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreShowSpellName(info)
	return self.config.sreShowSpellName;
end

--SRE online status.
function NRC:setSreOnlineStatus(info, value)
	self.config.sreOnlineStatus = value;
	NRC:sreUpdateSettings();
end

function NRC:getSreOnlineStatus(info)
	return self.config.sreOnlineStatus;
end

--SRE add spell.
local spellLookups = {};
function NRC:setSreAddSpell(info, value)
	if (not value or not tonumber(value)) then
		NRC:print(L["inputValidSpellID"]);
		return;
	end
	value = tonumber(value);
	if (value > 999999999) then
		--To catch an integer overflow lua error.
		NRC:print(L["inputLowerSpellID"]);
		return;
	end
	for k, v in pairs(self.config.sreCustomSpells) do
		if (k == value) then
			NRC:print(string.format(L["spellIDAlreadyCustomSpell"], "|cFF9CD6DE" .. value .. "|r."));
			return;
		end
	end
	local spellName, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(value);
	if (not spellName) then
		NRC:print(string.format(L["noSpellFoundWithID"], "|cFF9CD6DE" .. value .. "|r."));
		return;
	end
	local spellData = Spell:CreateFromSpellID(value);
	--These have to be created seperately so they exist in order or they can't reference each other.
	--There's probably a better way to do this...
	spellLookups[value] = {};
	spellLookups[value].timer = C_Timer.NewTimer(3, function()
		if (spellLookups[value] and spellLookups[value].cancelFunc) then
			spellLookups[value].cancelFunc();
		end
		spellLookups[value] = nil;
		NRC:print(string.format(L["notValidSpell"], "|cFF9CD6DE" .. value .. "|r."));
	end);
	spellLookups[value].cancelFunc = spellData:ContinueWithCancelOnSpellLoad(function()
		local spellName = spellData:GetSpellName();
		local icon = GetSpellTexture(value);
		local rank = spellData:GetSpellSubtext();
		--local desc = spellData:GetSpellDescription();
		self.config.sreCustomSpells[value] = {
			spellName = spellName,
			icon = icon,
			rank = rank,
		};
		updateSreOptions();
		spellData:Clear();
		NRC:sreLoadSpellList();
		local iconText = "";
		if (icon) then
			iconText = "|T" .. icon .. ":12:12|t";
		end
		local text = string.format(L["addedCustomScrollingSpell"], iconText, "|cFF9CD6DE" .. spellName .. "|r.");
		if (rank) then
			text = text .. " (" .. rank .. ")"
		end
		text = text .. "|r.";
		NRC:print(text);
		if (spellLookups[value] and spellLookups[value].timer) then
			spellLookups[value].timer:Cancel();
		end
		spellLookups[value] = nil;
	end);
end

function NRC:getSreAddSpell(info)
	return self.config.sreAddSpell;
end

function NRC:setSreRemoveSpell(info, value)
	if (not value or not tonumber(value)) then
		NRC:print(L["inputLowerSpellIDRemove"]);
		return;
	end
	local found;
	value = tonumber(value);
	for k, v in pairs(self.config.sreCustomSpells) do
		if (k == value) then
			found = true;
		end
	end
	if (not found) then
		NRC:print(string.format(L["spellIDNotCustomSpell"], "|cFF9CD6DE" .. value .. "|r."));
		return;
	end
	local spellName = self.config.sreCustomSpells[value].spellName;
	local spellText = "";
	if (spellName) then
		spellText = " " .. spellName;
	end
	local icon = self.config.sreCustomSpells[value].icon;
	local iconText = "";
	if (icon) then
		iconText = " |T" .. icon .. ":12:12|t";
	end
	local rank = self.config.sreCustomSpells[value].rank;
	local rankText = "";
	if (rank) then
		rankText = " (" .. rank .. ")";
	end
	self.config.sreCustomSpells[value] = nil;
	NRC:print(string.format(L["removedScrollingCustomSpellID"], iconText, "|cFFFFFFFF" .. value .. "|r", "|cFF9CD6DE" .. spellText .. rankText .. "|r"));
	NRC:sreLoadSpellList();
end

function NRC:getSreRemoveSpell(info)
	return self.config.sreAddSpell;
end

--Raid mana enabled.
function NRC:setRaidManaEnabled(info, value)
	self.config.raidManaEnabled = value;
	NRC:loadRaidManaFrame();
end

function NRC:getRaidManaEnabled(info)
	return self.config.raidManaEnabled;
end

--Raid mana enabled everywhere.
function NRC:setRaidManaEnabledEverywhere(info, value)
	self.config.raidManaEnabledEverywhere = value;
	NRC:loadRaidManaFrame();
end

function NRC:getRaidManaEnabledEverywhere(info)
	return self.config.raidManaEnabledEverywhere;
end

--Raid mana enabled raid.
function NRC:setRaidManaEnabledRaid(info, value)
	self.config.raidManaEnabledRaid = value;
	NRC:loadRaidManaFrame();
end

function NRC:getRaidManaEnabledRaid(info)
	return self.config.raidManaEnabledRaid;
end

--Raid mana enabled pvp.
function NRC:setRaidManaEnabledPvP(info, value)
	self.config.raidManaEnabledPvP = value;
	NRC:loadRaidManaFrame();
end

function NRC:getRaidManaEnabledPvP(info)
	return self.config.raidManaEnabledPvP;
end

--Raid mana show average mana.
function NRC:setRaidManaAverage(info, value)
	self.config.raidManaAverage = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaAverage(info)
	return self.config.raidManaAverage;
end

--Raid mana show myself.
function NRC:setRaidManaShowSelf(info, value)
	self.config.raidManaShowSelf = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaShowSelf(info)
	return self.config.raidManaShowSelf;
end

--Raid mana scale.
function NRC:setRaidManaScale(info, value)
	self.db.global.raidManaScale = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaScale(info)
	return self.db.global.raidManaScale;
end

--Raid mana growth direction.
function NRC:setRaidManaGrowthDirection(info, value)
	self.db.global.raidManaGrowthDirection = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaGrowthDirection(info)
	return self.db.global.raidManaGrowthDirection;
end

--Raid mana font.
function NRC:setRaidManaFont(info, value)
	self.db.global.raidManaFont = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaFont(info)
	return self.db.global.raidManaFont;
end

--Raid mana numbers font.
function NRC:setRaidManaFontNumbers(info, value)
	self.db.global.raidManaFontNumbers = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaFontNumbers(info)
	return self.db.global.raidManaFontNumbers;
end

--Raid mana font size.
function NRC:setRaidManaFontSize(info, value)
	self.db.global.raidManaFontSize = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaFontSize(info)
	return self.db.global.raidManaFontSize;
end

--Raid mana font outline.
function NRC:setRaidManaFontOutline(info, value)
	self.db.global.raidManaFontOutline = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaFontOutline(info)
	return self.db.global.raidManaFontOutline;
end

--Raid mana width.
function NRC:setRaidManaWidth(info, value)
	self.db.global.raidManaWidth = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaWidth(info)
	return self.db.global.raidManaWidth;
end

--Raid mana height.
function NRC:setRaidManaHeight(info, value)
	self.db.global.raidManaHeight = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaHeight(info)
	return self.db.global.raidManaHeight;
end

--Raid mana resurrection.
function NRC:setRaidManaResurrection(info, value)
	self.config.raidManaResurrection = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaResurrection(info)
	return self.config.raidManaResurrection;
end

--Raid mana resurrection dir
function NRC:setRaidManaResurrectionDir(info, value)
	self.db.global.raidManaResurrectionDir = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaResurrectionDir(info)
	return self.db.global.raidManaResurrectionDir;
end

--Raid mana backdrop alpha.
function NRC:setRaidManaBackdropAlpha(info, value)
	self.db.global.raidManaBackdropAlpha = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaBackdropAlpha(info)
	return self.db.global.raidManaBackdropAlpha;
end

--Raid mana border alpha.
function NRC:setRaidManaBorderAlpha(info, value)
	self.db.global.raidManaBorderAlpha = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaBorderAlpha(info)
	return self.db.global.raidManaBorderAlpha;
end

--Raid mana update interval.
function NRC:setRaidManaUpdateInterval(info, value)
	self.db.global.raidManaUpdateInterval = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaUpdateInterval(info)
	return self.db.global.raidManaUpdateInterval;
end

--Raid mana sort order.
function NRC:setRaidManaSortOrder(info, value)
	self.db.global.raidManaSortOrder = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaSortOrder(info)
	return self.db.global.raidManaSortOrder;
end

--Raid mana show healers.
function NRC:setRaidManaHealers(info, value)
	self.config.raidManaHealers = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaHealers(info)
	return self.config.raidManaHealers;
end

--Raid mana show druids.
function NRC:setRaidManaDruid(info, value)
	self.config.raidManaDruid = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaDruid(info)
	return self.config.raidManaDruid;
end

--Raid mana show hunters.
function NRC:setRaidManaHunter(info, value)
	self.config.raidManaHunter = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaHunter(info)
	return self.config.raidManaHunter;
end

--Raid mana show mages.
function NRC:setRaidManaMage(info, value)
	self.config.raidManaMage = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaMage(info)
	return self.config.raidManaMage;
end

--Raid mana show paladins.
function NRC:setRaidManaPaladin(info, value)
	self.config.raidManaPaladin = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaPaladin(info)
	return self.config.raidManaPaladin;
end

--Raid mana show priests.
function NRC:setRaidManaPriest(info, value)
	self.config.raidManaPriest = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaPriest(info)
	return self.config.raidManaPriest;
end

--Raid mana show shamans.
function NRC:setRaidManaShaman(info, value)
	self.config.raidManaShaman = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaShaman(info)
	return self.config.raidManaShaman;
end

--Raid mana show warlocks.
function NRC:setRaidManaWarlock(info, value)
	self.config.raidManaWarlock = value;
	NRC:updateRaidManaFramesLayout();
end

function NRC:getRaidManaWarlock(info)
	return self.config.raidManaWarlock;
end

------------
---Sounds---
------------

local sounds = {
	--Random snipets from youtube mostly.
	--["NRC - Zelda"] = "Interface\\AddOns\\NovaRaidCompanion\\Media\\Zelda.ogg",
}

function NRC:registerSounds()
	for k, v in pairs(sounds) do
		NRC.LSM:Register("sound", k, v);
	end
end

function NRC:getSounds(type)
	NRC.sounds = {};
	if (self.db.global.extraSoundOptions) then
		for _, v in pairs(NRC.LSM:List("sound")) do
			NRC.sounds[v] = v;
		end
	else
		for k, v in NRC:pairsByKeys(sounds) do
			NRC.sounds[k] = k;
		end
		NRC.sounds["None"] = "None";
	end
	return NRC.sounds;
end

--Reset frames.
function NRC:resetFrames()
	for frameName, frame in pairs(NRC.framePool) do
		if (frame.defaultX and frame.defaultY) then
			frame:ClearAllPoints();
			frame:SetPoint("CENTER", UIParent, "CENTER", frame.defaultX, frame.defaultY);
			NRC.db.global[frame:GetName() .. "_point"], _, NRC.db.global[frame:GetName() .. "_relativePoint"], 
					NRC.db.global[frame:GetName() .. "_x"], NRC.db.global[frame:GetName() .. "_y"] = frame:GetPoint();
			frame.firstRun = true;
			frame.hasBeenReset = true;
			if (frame.reset) then
				frame.reset();
			end
		end
	end
	NRC:updateRaidCooldowns();
	NRC:updateTargetSpawnTime();
	NRC:print(L["resetFramesMsg"]);
	NRC:setLockAllFrames(nil, false);
end

--Lock all frames.
function NRC:setLockAllFrames(info, value)
	self.config.lockAllFrames = value;
	NRC:updateFrameLocks();
end

function NRC:getLockAllFrames(info)
	return self.config.lockAllFrames;
end

function NRC:updateFrameLocks()
	NRC:raidCooldownsUpdateFrameLocks();
	NRC:sreUpdateFrameLocks();
	NRC:raidManaUpdateFrameLocks();
end

function NRC:startTestAllFrames()
	NRC:print("|cFF00C800Starting Frame Layout Test for 30 seconds.");
	NRC.allFramesTestRunning = true;
	NRC:startRaidCooldownsTest(true);
	NRC:startSreTest(true);
	NRC:startRaidManaTest(true);
end

function NRC:stopTestAllFrames()
	NRC:stopRaidCooldownsTest();
	NRC:stopSreTest();
	NRC:stopRaidManaTest();
end

--My Tricks cast in group.
function NRC:setTricksSendMyCastGroup(info, value)
	self.config.tricksSendMyCastGroup = value;
	NRC:throddleEventByFunc("CONFIG_UPDATE", 3, "sendSettings");
end

function NRC:getTricksSendMyCastGroup(info)
	return self.config.tricksSendMyCastGroup;
end

--Tricks cast in say.
function NRC:setTricksSendMyCastSay(info, value)
	self.config.tricksSendMyCastSay = value;
end

function NRC:getTricksSendMyCastSay(info)
	return self.config.tricksSendMyCastSay;
end

--Other Tricks cast in group.
function NRC:setTricksSendOtherCastGroup(info, value)
	self.config.tricksSendOtherCastGroup = value;
	NRC:throddleEventByFunc("CONFIG_UPDATE", 3, "sendSettings");
end

function NRC:getTricksSendOtherCastGroup(info)
	return self.config.tricksSendOtherCastGroup;
end

--My Tricks threat in group.
function NRC:setTricksSendMyThreatGroup(info, value)
	self.config.tricksSendMyThreatGroup = value;
	NRC:throddleEventByFunc("CONFIG_UPDATE", 3, "sendSettings");
end

function NRC:getTricksSendMyThreatGroup(info)
	return self.config.tricksSendMyThreatGroup;
end

--My Tricks threat in say.
function NRC:setTricksSendMyThreatSay(info, value)
	self.config.tricksSendMyThreatSay = value;
end

function NRC:getTricksSendMyThreatSay(info)
	return self.config.tricksSendMyThreatSay;
end

--Others Tricks threat in group.
function NRC:setTricksSendOthersThreatGroup(info, value)
	self.config.tricksSendOthersThreatGroup = value;
	NRC:throddleEventByFunc("CONFIG_UPDATE", 3, "sendSettings");
end

function NRC:getTricksSendOthersThreatGroup(info)
	return self.config.tricksSendOthersThreatGroup;
end

--Others Tricks threat in say.
function NRC:setTricksSendOthersThreatSay(info, value)
	self.config.tricksSendOthersThreatSay = value;
end

function NRC:getTricksSendOthersThreatSay(info)
	return self.config.tricksSendOthersThreatSay;
end

--Print my Tricks threat to chat.
function NRC:setTricksShowMySelf(info, value)
	self.config.tricksShowMySelf = value;
end

function NRC:getTricksShowMySelf(info)
	return self.config.tricksShowMySelf;
end

--Print others Tricks threat to chat.
function NRC:setTricksShowOthersSelf(info, value)
	self.config.tricksShowOthersSelf = value;
end

function NRC:getTricksShowOthersSelf(info)
	return self.config.tricksShowOthersSelf;
end

--Show Tricks spells.
function NRC:setTricksShowSpells(info, value)
	self.config.tricksShowSpells = value;
end

function NRC:getTricksShowSpells(info)
	return self.config.tricksShowSpells;
end

--Show Tricks spells other players.
function NRC:setTricksShowSpellsOther(info, value)
	self.config.tricksShowSpellsOther = value;
end

function NRC:getTricksShowSpellsOther(info)
	return self.config.tricksShowSpellsOther;
end

--Send tricks threat msg to tank.
function NRC:setTricksSendTarget(info, value)
	self.config.tricksSendTarget = value;
end

function NRC:getTricksSendTarget(info)
	return self.config.tricksSendTarget;
end

--Tricks my damage to group.
function NRC:setTricksSendDamageGroup(info, value)
	self.config.tricksSendDamageGroup = value;
end

function NRC:getTricksSendDamageGroup(info)
	return self.config.tricksSendDamageGroup;
end

--Tricks other rogues damage to group.
function NRC:setTricksSendDamageGroupOther(info, value)
	self.config.tricksSendDamageGroupOther = value;
end

function NRC:getTricksSendDamageGroupOther(info)
	return self.config.tricksSendDamageGroupOther;
end

--Tricks damage whisper.
function NRC:setTricksSendDamageWhisper(info, value)
	self.config.tricksSendDamageWhisper = value;
end

function NRC:getTricksSendDamageWhisper(info)
	return self.config.tricksSendDamageWhisper;
end

--Tricks damage print.
function NRC:setTricksSendDamagePrint(info, value)
	self.config.tricksSendDamagePrint = value;
end

function NRC:getTricksSendDamagePrint(info)
	return self.config.tricksSendDamagePrint;
end

--Tricks damage print other.
function NRC:setTricksSendDamagePrintOther(info, value)
	self.config.tricksSendDamagePrintOther = value;
end

function NRC:getTricksSendDamagePrintOther(info)
	return self.config.tricksSendDamagePrintOther;
end

--Tricks mine print gained from other rogues.
function NRC:setTricksOtherRoguesMineGained(info, value)
	self.config.tricksOtherRoguesMineGained = value;
end

function NRC:getTricksOtherRoguesMineGained(info)
	return self.config.tricksOtherRoguesMineGained;
end

--Tricks damage only when > 0.
function NRC:setTricksOnlyWhenDamage(info, value)
	self.config.tricksOnlyWhenDamage = value;
end

function NRC:getTricksOnlyWhenDamage(info)
	return self.config.tricksOnlyWhenDamage;
end

--Dispels creature casts.
function NRC:setDispelsCreatures(info, value)
	self.config.dispelsCreatures = value;
end

function NRC:getDispelsCreatures(info)
	return self.config.dispelsCreatures;
end

--Dispels tranq shot only.
function NRC:setDispelsTranqOnly(info, value)
	self.config.dispelsTranqOnly = value;
end

function NRC:getDispelsTranqOnly(info)
	return self.config.dispelsTranqOnly;
end

--Dispels friendly players casts.
function NRC:setDispelsFriendlyPlayers(info, value)
	self.config.dispelsFriendlyPlayers = value;
end

function NRC:getDispelsFriendlyPlayers(info)
	return self.config.dispelsFriendlyPlayers;
end

--Dispels enemy players casts.
function NRC:setDispelsEnemyPlayers(info, value)
	self.config.dispelsEnemyPlayers = value;
end

function NRC:getDispelsEnemyPlayers(info)
	return self.config.dispelsEnemyPlayers;
end

--Dispels mine group.
function NRC:setDispelsMyCastGroup(info, value)
	self.config.dispelsMyCastGroup = value;
end

function NRC:getDispelsMyCastGroup(info)
	return self.config.dispelsMyCastGroup;
end

--Dispels mine say.
function NRC:setDispelsMyCastPrint(info, value)
	self.config.dispelsMyCastPrint = value;
end

function NRC:getDispelsMyCastPrint(info)
	return self.config.dispelsMyCastPrint;
end

--Dispels mine print.
function NRC:setDispelsMyCastSay(info, value)
	self.config.dispelsMyCastSay = value;
end

function NRC:getDispelsMyCastSay(info)
	return self.config.dispelsMyCastSay;
end

--Dispels mine in raids/dungeons.
function NRC:setDispelsMyCastRaid(info, value)
	self.config.dispelsMyCastRaid = value;
end

function NRC:getDispelsMyCastRaid(info)
	return self.config.dispelsMyCastRaid;
end

--Dispels mine in My.
function NRC:setDispelsMyCastWorld(info, value)
	self.config.dispelsMyCastWorld = value;
end

function NRC:getDispelsMyCastWorld(info)
	return self.config.dispelsMyCastWorld;
end

--Dispels mine pvp.
function NRC:setDispelsMyCastPvp(info, value)
	self.config.dispelsMyCastPvp = value;
end

function NRC:getDispelsMyCastPvp(info)
	return self.config.dispelsMyCastPvp;
end

--Dispels others group.
function NRC:setDispelsOtherCastGroup(info, value)
	self.config.dispelsOtherCastGroup = value;
end

function NRC:getDispelsOtherCastGroup(info)
	return self.config.dispelsOtherCastGroup;
end

--Dispels others say.
function NRC:setDispelsOtherCastPrint(info, value)
	self.config.dispelsOtherCastPrint = value;
end

function NRC:getDispelsOtherCastPrint(info)
	return self.config.dispelsOtherCastPrint;
end

--Dispels others print.
function NRC:setDispelsOtherCastSay(info, value)
	self.config.dispelsOtherCastSay = value;
end

function NRC:getDispelsOtherCastSay(info)
	return self.config.dispelsOtherCastSay;
end

--Dispels others in raids/dungeons.
function NRC:setDispelsOtherCastRaid(info, value)
	self.config.dispelsOtherCastRaid = value;
end

function NRC:getDispelsOtherCastRaid(info)
	return self.config.dispelsOtherCastRaid;
end

--Dispels others in world.
function NRC:setDispelsOtherCastWorld(info, value)
	self.config.dispelsOtherCastWorld = value;
end

function NRC:getDispelsOtherCastWorld(info)
	return self.config.dispelsOtherCastWorld;
end

--Dispels others pvp.
function NRC:setDispelsOtherCastPvp(info, value)
	self.config.dispelsOtherCastPvp = value;
end

function NRC:getDispelsOtherCastPvp(info)
	return self.config.dispelsOtherCastPvp;
end

--Dispels include players.
function NRC:setDispelsIncludePlayers(info, value)
	self.config.dispelsIncludePlayers = value;
end

function NRC:getDispelsIncludePlayers(info)
	return self.config.dispelsIncludePlayers;
end