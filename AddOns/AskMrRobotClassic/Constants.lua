local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")
local L = LibStub("AceLocale-3.0"):GetLocale("AskMrRobotClassic", true)

-- min import version that we will read from the website
Amr.MIN_IMPORT_VERSION = 1

-- min addon version that we will support for inter-addon communication
Amr.MIN_ADDON_VERSION = 1

-- import some constants from the serializer for convenience
Amr.RegionNames = Amr.Serializer.RegionNames
Amr.SlotIds = Amr.Serializer.SlotIds
Amr.SpecIds = Amr.Serializer.SpecIds
Amr.ClassIds = Amr.Serializer.ClassIds
Amr.ProfessionIds = Amr.Serializer.ProfessionIds
Amr.RaceIds = Amr.Serializer.RaceIds
Amr.FactionIds = Amr.Serializer.FactionIds
Amr.InstanceIds = Amr.Serializer.InstanceIds
Amr.SupportedInstanceIds = Amr.Serializer.SupportedInstanceIds
Amr.InstanceDifficulties = Amr.Serializer.InstanceDifficulties
Amr.ParseItemLink = Amr.Serializer.ParseItemLink
Amr.IsSupportedInstanceId = Amr.Serializer.IsSupportedInstanceId
Amr.IsSupportedInstance = Amr.Serializer.IsSupportedInstance
--Amr.GetItemTooltip = Amr.Serializer.GetItemTooltip
--Amr.GetItemLevel = Amr.Serializer.GetItemLevel
Amr.GetItemUniqueId = Amr.Serializer.GetItemUniqueId
Amr.ProfessionSkillLineToName = Amr.Serializer.ProfessionSkillLineToName


-- map of slot ID to display text
Amr.SlotDisplayText = {
    [1] = _G["HEADSLOT"],
    [2] = _G["NECKSLOT"],
    [3] = _G["SHOULDERSLOT"],
    [5] = _G["CHESTSLOT"],
    [6] = _G["WAISTSLOT"],
    [7] = _G["LEGSSLOT"],
    [8] = _G["FEETSLOT"],
    [9] = _G["WRISTSLOT"],
    [10] = _G["HANDSSLOT"],
    [11] = _G["FINGER0SLOT"] .. " 1",
    [12] = _G["FINGER1SLOT"] .. " 2",
    [13] = _G["TRINKET0SLOT"] .. " 1",
    [14] = _G["TRINKET1SLOT"] .. " 2",
    [15] = _G["BACKSLOT"],
    [16] = _G["MAINHANDSLOT"],
    [17] = _G["SECONDARYHANDSLOT"],
    [18] = _G["RANGEDSLOT"]
}

Amr.SlotEnumDisplayText = {
	Head = _G["HEADSLOT"],
    Neck = _G["NECKSLOT"],
    Shoulder = _G["SHOULDERSLOT"],
    Chest = _G["CHESTSLOT"],
    Waist = _G["WAISTSLOT"],
    Legs = _G["LEGSSLOT"],
    Feet = _G["FEETSLOT"],
    Wrist = _G["WRISTSLOT"],
    Hands = _G["HANDSSLOT"],
    Finger1 = _G["FINGER0SLOT"],
    Finger2 = _G["FINGER0SLOT"],
    Trinket1 = _G["TRINKET0SLOT"],
    Trinket2 = _G["TRINKET0SLOT"],
    Back = _G["BACKSLOT"],
    MainHand = _G["MAINHANDSLOT"],
    OffHand = _G["SECONDARYHANDSLOT"],
    Ranged = _G["RANGEDSLOT"],
}

Amr.SpecIcons = {
    [1] = "spell_deathknight_bloodpresence", -- DeathKnightBlood
    [2] = "spell_deathknight_frostpresence", -- DeathKnightFrost
    [3] = "spell_deathknight_unholypresence", -- DeathKnightUnholy
	[4] = "ability_demonhunter_specdps", -- DemonHunterHavoc
	[5] = "ability_demonhunter_spectank", -- DemonHunterVengeance
    [6] = "spell_nature_starfall", -- DruidBalance
    [7] = "ability_druid_catform", -- DruidFeral
    [8] = "ability_racial_bearform", -- DruidGuardian
    [9] = "spell_nature_healingtouch", -- DruidRestoration
    [10] = "ability_hunter_bestialdiscipline", -- HunterBeastMastery
    [11] = "ability_hunter_focusedaim", -- HunterMarksmanship
    [12] = "ability_hunter_camouflage", -- HunterSurvival
    [13] = "spell_holy_magicalsentry", -- MageArcane
    [14] = "spell_fire_firebolt02", -- MageFire
    [15] = "spell_frost_frostbolt02", -- MageFrost
    [16] = "spell_monk_brewmaster_spec", -- MonkBrewmaster
    [17] = "spell_monk_mistweaver_spec", -- MonkMistweaver
    [18] = "spell_monk_windwalker_spec", -- MonkWindwalker
    [19] = "spell_holy_holybolt", -- PaladinHoly
    [20] = "ability_paladin_shieldofthetemplar", -- PaladinProtection
    [21] = "spell_holy_auraoflight", -- PaladinRetribution
    [22] = "spell_holy_powerwordshield", -- PriestDiscipline
    [23] = "spell_holy_guardianspirit", -- PriestHoly
    [24] = "spell_shadow_shadowwordpain", -- PriestShadow
    [25] = "ability_rogue_eviscerate", -- RogueAssassination
    [26] = "inv_sword_30", -- RogueOutlaw
    [27] = "ability_stealth", -- RogueSubtlety
    [28] = "spell_nature_lightning", -- ShamanElemental
    [29] = "spell_nature_lightningshield", -- ShamanEnhancement
    [30] = "spell_nature_magicimmunity", -- ShamanRestoration
    [31] = "spell_shadow_deathcoil", -- WarlockAffliction
    [32] = "spell_shadow_metamorphosis", -- WarlockDemonology
    [33] = "spell_shadow_rainoffire", -- WarlockDestruction
    [34] = "ability_warrior_savageblow", -- WarriorArms
    [35] = "ability_warrior_innerrage", -- WarriorFury
    [36] = "ability_warrior_defensivestance", -- WarriorProtection
}

Amr.ClassIcons = {
    ["DEATHKNIGHT"] = "spell_deathknight_classicon",
    ["DRUID"] = "classicon_druid",
    ["HUNTER"] = "classicon_hunter",
    ["MAGE"] = "classicon_mage",
    ["PALADIN"] = "classicon_paladin",
    ["PRIEST"] = "classicon_priest",
    ["ROGUE"] = "classicon_rogue",
    ["SHAMAN"] = "classicon_shaman",
    ["WARLOCK"] = "classicon_warlock",
    ["WARRIOR"] = "classicon_warrior"
}

-- instance IDs ordered in preferred display order
Amr.InstanceIdsOrdered = { 533, 616, 615, 603, 649, 249, 631, 724 }

Amr.Difficulties = {
    Normal = 1,
    Normal25 = 2,
    Heroic = 3,
    Heroic25 = 4
}

-- get the game's spec id from the AMR spec id
function Amr.GetGameSpecId(specId)
	for k, v in pairs(Amr.SpecIds) do
		if v == specId then return k end
	end
	return nil
end


------------------------------------------------------------------------------------------
-- Item Methods
------------------------------------------------------------------------------------------

--                 1      2    3      4      5      6    7   8   9   10   11       12         
--                 itemId:ench:gem1  :gem2  :gem3  :gem4:suf:uid:lvl:spec:flags   :instdiffid:numbonusIDs:bonusIDs1...n     :varies:?:relic bonus ids
--|cffe6cc80|Hitem:128866:    :152046:147100:152025:    :   :   :110:66  :16777472:9         :4          :736:1494:1490:1495:709   :1:3:3610:1472:3528:3:3562:1483:3528:3:3610:1477:3336|h[Truthguard]|h|r
--
function Amr.CreateItemLink(itemObj)

    if itemObj == nil or itemObj.id == nil or itemObj.id == 0 then return nil end
    
    local parts = {}
    table.insert(parts, "item")
    table.insert(parts, itemObj.id)
    table.insert(parts, itemObj.enchantId)
    table.insert(parts, itemObj.gemIds[1])
    table.insert(parts, itemObj.gemIds[2])
    table.insert(parts, itemObj.gemIds[3])
    table.insert(parts, itemObj.gemIds[4])
    
    if itemObj.suffixId == 0 then
        table.insert(parts, 0)
    else
        table.insert(parts, math.abs(itemObj.suffixId))
    end
    
    table.insert(parts, 0) -- some unique id, doesn't seem to matter
    table.insert(parts, UnitLevel("player"))

    -- was spec... just blank for classic
    table.insert(parts, 0)

	-- this indicates what kind of modifier appears after the bonus IDs
	if itemObj.upgradeId and itemObj.upgradeId ~= 0 then
		table.insert(parts, 4)
	elseif itemObj.level and itemObj.level ~= 0 then
		table.insert(parts, 512)
	else
		table.insert(parts, 0)
	end

    table.insert(parts, 0) -- difficulty id, doesn't matter
    
    if itemObj.bonusIds then
        table.insert(parts, #itemObj.bonusIds)
        for i,v in ipairs(itemObj.bonusIds) do
            table.insert(parts, v)
        end
	else
		table.insert(parts, 0) -- no bonus ids
    end
	
	-- upgrade id or level comes after bonuses
	if itemObj.upgradeId and itemObj.upgradeId ~= 0 then
		table.insert(parts, itemObj.upgradeId)
	elseif itemObj.level and itemObj.level ~= 0 then
		table.insert(parts, itemObj.level)
	else
		table.insert(parts, 0)
	end
    
    -- we don't bother with relic bonus ids anymore when generating links
    table.insert(parts, 0)
    table.insert(parts, 0)
    table.insert(parts, 0)
    
    return table.concat(parts, ":")
end

--[[
-- the server event for getting item info does not specify which item it just fetched... have to track manually
local _pendingItemIds = {}

-- helper for getting item information, which is not always guaranteed to be loaded into memory
function Amr.GetItemInfo(itemIdOrLinkOrName, callback, customArg)
	if not itemIdOrLinkOrName then
		callback(customArg)
		return
	end

	-- see if we can get the information immediately
	local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemIdOrLinkOrName)
	if name then
		callback(customArg, name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice)
		return
	end
	
	-- get the list of registered callbacks for this particular item
	local list = _pendingItemIds[itemIdOrLinkOrName]
	-- if there was a list, then just add the callback to the list
	if list then
		table.insert(list, { Callback = callback, Arg = customArg })
	else
		-- there wasn't a list, so make a new one with this callback
		_pendingItemIds[itemIdOrLinkOrName] = { { Callback = callback, Arg = customArg } }
	end
end

Amr:AddEventHandler("GET_ITEM_INFO_RECEIVED", function()
	-- go through all unresolved items since we don't know which one was just resolved
	for itemId, callbacks in pairs(_pendingItemIds) do
		-- attempt to get the item info again, remove from pending list if we find it
		local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemId)
		if name then
			_pendingItemIds[itemId] = nil

			-- call each callback
			for i = 1, #callbacks do
				callbacks[i].Callback(callbacks[i].Arg, name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice)
			end
		end
	end
end)
]]
