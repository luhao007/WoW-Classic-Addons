---There is no retail of this addon, probably never will be.
---This is just copy pasted from wrath for now basically.



----------------------------------
---NovaRaidCompanion Talent Data--
----------------------------------

local addonName, NRC = ...;
if (not NRC.isRetail) then
	return;
end

local specData = {
	--classID.
	[1] = {
		name = "WARRIOR",
		icon = 626008,
		iconPath = "Interface\\Icons\\ClassIcon_Warrior",
		--Specs, id is from talent book left to right.
		[1] = {
			name = "Arms",
			icon = 132219,
			iconPath = "Interface\\Icons\\Ability_Kick",
		},
		[2] = {
			name = "Fury",
			icon = 132347,
			iconPath = "Interface\\Icons\\Ability_Warrior_InnerRage",
		},
		[3] = {
			name = "Protection",
			icon = 132341,
			iconPath = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
		},
	},
	[2] = {
		name = "PALADIN",
		icon = 626003,
		iconPath = "Interface\\Icons\\ClassIcon_Paladin",
		[1] = {
			name = "Holy",
			icon = 135920,
			iconPath = "Interface\\Icons\\Spell_Holy_HolyBolt",
		},
		[2] = {
			name = "Protection",
			icon = 135893,
			iconPath = "Interface\\Icons\\SPELL_HOLY_DEVOTIONAURA",
		},
		[3] = {
			name = "Retribution",
			icon = 135873,
			iconPath = "Interface\\Icons\\Spell_Holy_AuraOfLight",
		},
	},
	[3] = {
		name = "HUNTER",
		icon = 626000,
		iconPath = "Interface\\Icons\\ClassIcon_Hunter",
		[1] = {
			name = "Beast Mastery",
			icon = 132164,
			iconPath = "Interface\\Icons\\Ability_Hunter_BeastTaming",
		},
		[2] = {
			name = "Marksmanship",
			icon = 132222,
			iconPath = "Interface\\Icons\\Ability_Marksmanship",
		},
		[3] = {
			name = "Survival",
			icon = 132215,
			iconPath = "Interface\\Icons\\Ability_Hunter_SwiftStrike",
		},
	},
	[4] = {
		name = "ROGUE",
		icon = 626005,
		iconPath = "Interface\\Icons\\ClassIcon_Rogue",
		[1] = {
			name = "Assassination",
			icon = 132292,
			iconPath = "Interface\\Icons\\Ability_Rogue_Eviscerate",
		},
		[2] = {
			name = "Combat",
			icon = 132090,
			iconPath = "Interface\\Icons\\Ability_BackStab",
		},
		[3] = {
			name = "Subtlety",
			icon = 132320,
			iconPath = "Interface\\Icons\\Ability_Stealth",
		},
	},
	[5] = {
		name = "PRIEST",
		icon = 626004,
		iconPath = "Interface\\Icons\\ClassIcon_Priest",
		[1] = {
			name = "Discipline",
			icon = 135940,
			iconPath = "Interface\\Icons\\spell_holy_powerwordshield",
		},
		[2] = {
			name = "Holy",
			--icon = 135920, --Classic/TBC
			--iconPath = "Interface\\Icons\\Spell_Holy_HolyBolt",
			--icon = 237542, --Better holy priest icon but doesn't exist in Classic/TBC.
			--iconPath = "Interface\\Icons\\Spell_Holy_GuardianSpirit",
			--Use addon path for both, should be fine as icon is just for setextures for now.
			icon = "Interface\\AddOns\\NovaRaidCompanion\\Media\\Blizzard\\Spell_Holy_GuardianSpirit",
			iconPath = "Interface\\AddOns\\NovaRaidCompanion\\Media\\Blizzard\\Spell_Holy_GuardianSpirit",
		},
		[3] = {
			name = "Shadow",
			icon = 136207,
			iconPath = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
		},
	},
	[6] = {
		name = "DEATHKNIGHT",
		icon = 135771,
		iconPath = "Interface\\Icons\\ClassIcon_DeathKnight",
		[1] = {
			name = "Blood",
			icon = 135770,
			iconPath = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
		},
		[2] = {
			name = "Frost",
			icon = 135773,
			iconPath = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
		},
		[3] = {
			name = "Unholy",
			icon = 135775,
			iconPath = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
		},
	},
	[7] = {
		name = "SHAMAN",
		icon = 626006,
		iconPath = "Interface\\Icons\\ClassIcon_Shaman",
		[1] = {
			name = "Elemental",
			icon = 136048,
			iconPath = "Interface\\Icons\\Spell_Nature_Lightning",
		},
		[2] = {
			name = "Enhancement",
			icon = 136051,
			iconPath = "Interface\\Icons\\Spell_Nature_LightningShield",
		},
		[3] = {
			name = "Restoration",
			icon = 136052,
			iconPath = "Interface\\Icons\\Spell_Nature_MagicImmunity",
		},
	},
	[8] = {
		name = "MAGE",
		icon = 626001,
		iconPath = "Interface\\Icons\\ClassIcon_Mage",
		[1] = {
			name = "Arcane",
			icon = 135932,
			iconPath = "Interface\\Icons\\Spell_Holy_MagicalSentry",
		},
		[2] = {
			name = "Fire",
			icon = 135810,
			iconPath = "Interface\\Icons\\Spell_Fire_FireBolt02",
		},
		[3] = {
			name = "Frost",
			icon = 135846,
			iconPath = "Interface\\Icons\\Spell_Frost_FrostBolt02",
		},
	},
	[9] = {
		name = "WARLOCK",
		icon = 626007,
		iconPath = "Interface\\Icons\\ClassIcon_Warlock",
		--Specs, id is from talent book left to right.
		[1] = {
			name = "Affliction",
			icon = 136145,
			iconPath = "Interface\\Icons\\Spell_Shadow_DeathCoil",
		},
		[2] = {
			name = "Demonology",
			icon = 136172,
			iconPath = "Interface\\Icons\\Spell_Shadow_Metamorphosis",
		},
		[3] = {
			name = "Destruction",
			icon = 136186,
			iconPath = "Interface\\Icons\\Spell_Shadow_RainOfFire",
		},
	},
	--[[[10] = {
		name = "MONK",
		icon = 136830,
		iconPath = "Interface\\Icons\\ClassIcon_Monk",
		[1] = {
			name = "Windwalker",
			icon = 608953,
			iconPath = "Interface\\Icons\\Spell_Monk_WindWalker_Spec",
		},
		[2] = {
			name = "Brewmaster",
			icon = 608951,
			iconPath = "Interface\\Icons\\Spell_Monk_Brewmaster_Spec",
		},
		[3] = {
			name = "Mistweaver",
			icon = 608952,
			iconPath = "Interface\\Icons\\Spell_Monk_MistWeaver_Spec",
		},
	},]]
	[11] = {
		name = "DRUID",
		icon = 625999,
		iconPath = "Interface\\Icons\\ClassIcon_Druid",
		[1] = {
			name = "Balance",
			icon = 136096,
			iconPath = "Interface\\Icons\\Spell_Nature_StarFall",
		},
		[2] = {
			name = "Feral",
			icon = 132276,
			iconPath = "Interface\\Icons\\Ability_Racial_BearForm",
		},
		--[3] = {
		--	name = "Guardian",
		--	icon = 132276,
			iconPath = "Interface\\Icons\\Ability_Racial_BearForm",
		--},
		[3] = { --Needs changing to 4 once druids gain 4th spec.
			name = "Restoration",
			icon = 136041,
			iconPath = "Interface\\Icons\\SPELL_NATURE_HEALINGTOUCH",
		},
	},
};

function NRC.getSpecData(classID, specID)
	if (specData[classID] and specData[classID][specID]) then
		local name = specData[classID][specID].name;
		local icon = specData[classID][specID].icon;
		local iconPath = specData[classID][specID].iconPath;
		return name, icon, iconPath;
	end
end

--All this class data has come from Talented Classic, a very good talent template addon.
--Permission was given by the author to use it here.
local talents = {};
talents.deathKnight = {
	{
		
	},
}

talents.demonHunter = {
	{
		
	},
}

talents.druid = {
	{
		
	},
}

talents.evoker = {
	{
		
	},
}

talents.hunter = {
	{
		
	},
}

talents.mage = {
	{
		
	},
}

talents.monk = {
	{
		
	},
}

talents.paladin = {
	{
		
	},
}

talents.priest = {
	{
		
	},
}

talents.rogue = {
	{
		
	},
}

talents.shaman = {
	{
		
	},
}

talents.warlock = {
	{
		
	},
}

talents.warrior = {
	{
		
	},
}




function NRC:getTalentData(class)
	class = string.lower(class);
	return talents[class];
end

function NRC:getTabData(class)
	class = string.lower(class);
	if (talents[class]) then
		local tabData = {};
		for k, v in ipairs(talents[class]) do
			tabData[k] = {
				numTalents = v.numtalents;
			};
		end
		return tabData;
	end
end