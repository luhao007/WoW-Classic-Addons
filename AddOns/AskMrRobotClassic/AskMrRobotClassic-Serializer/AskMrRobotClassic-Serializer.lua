-- AskMrRobotClassic-Serializer will serialize and communicate character data between users.

local MAJOR, MINOR = "AskMrRobotClassic-Serializer", 16
local Amr, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not Amr then return end -- already loaded by something else

-- event and comm used for player snapshotting on entering combat
LibStub("AceEvent-3.0"):Embed(Amr)

----------------------------------------------------------------------------------------
-- Constants
----------------------------------------------------------------------------------------

-- map of region ids to AMR region names
Amr.RegionNames = {
	[1] = "US",
	[2] = "KR",
	[3] = "EU",
	[4] = "TW",
	[5] = "CN"
}

-- map of the skillLine returned by profession API to the AMR profession name
Amr.ProfessionSkillLineToName = {
	[794] = "Archaeology",
	[171] = "Alchemy",
	[164] = "Blacksmithing",
	[185] = "Cooking",
	[333] = "Enchanting",
	[202] = "Engineering",
	[129] = "First Aid",
	[356] = "Fishing",
	[182] = "Herbalism",
	[773] = "Inscription",
	[755] = "Jewelcrafting",
	[165] = "Leatherworking",
	[186] = "Mining",
	[393] = "Skinning",
	[197] = "Tailoring"
}

-- all slot IDs that we care about, ordered in AMR standard display order
Amr.SlotIds = { 16, 17, 18, 1, 2, 3, 15, 5, 9, 10, 6, 7, 8, 11, 12, 13, 14 }

Amr.SpecIds = {
    [250] = 1, -- DeathKnightBlood
    [251] = 2, -- DeathKnightFrost
    [252] = 3, -- DeathKnightUnholy
	[577] = 4, -- DemonHunterHavoc
	[581] = 5, -- DemonHunterVengeance
    [102] = 6, -- DruidBalance
    [103] = 7, -- DruidFeral
    [104] = 8, -- DruidGuardian
    [105] = 9, -- DruidRestoration
    [253] = 10, -- HunterBeastMastery
    [254] = 11, -- HunterMarksmanship
    [255] = 12, -- HunterSurvival
    [62] = 13, -- MageArcane
    [63] = 14, -- MageFire
    [64] = 15, -- MageFrost
    [268] = 16, -- MonkBrewmaster
    [270] = 17, -- MonkMistweaver
    [269] = 18, -- MonkWindwalker
    [65] = 19, -- PaladinHoly
    [66] = 20, -- PaladinProtection
    [70] = 21, -- PaladinRetribution
    [256] = 22, -- PriestDiscipline
    [257] = 23, -- PriestHoly
    [258] = 24, -- PriestShadow
    [259] = 25, -- RogueAssassination
    [260] = 26, -- RogueOutlaw
    [261] = 27, -- RogueSubtlety
    [262] = 28, -- ShamanElemental
    [263] = 29, -- ShamanEnhancement
    [264] = 30, -- ShamanRestoration
    [265] = 31, -- WarlockAffliction
    [266] = 32, -- WarlockDemonology
    [267] = 33, -- WarlockDestruction
    [71] = 34, -- WarriorArms
    [72] = 35, -- WarriorFury
    [73] = 36 -- WarriorProtection
}

Amr.ClassIds = {
    ["NONE"] = 0,
    ["DEATHKNIGHT"] = 1,
	["DEMONHUNTER"] = 2,
    ["DRUID"] = 3,
    ["HUNTER"] = 4,
    ["MAGE"] = 5,
    ["MONK"] = 6,
    ["PALADIN"] = 7,
    ["PRIEST"] = 8,
    ["ROGUE"] = 9,
    ["SHAMAN"] = 10,
    ["WARLOCK"] = 11,
    ["WARRIOR"] = 12,
}

Amr.ProfessionIds = {
    ["None"] = 0,
    ["Mining"] = 1,
    ["Skinning"] = 2,
    ["Herbalism"] = 3,
    ["Enchanting"] = 4,
    ["Jewelcrafting"] = 5,
    ["Engineering"] = 6,
    ["Blacksmithing"] = 7,
    ["Leatherworking"] = 8,
    ["Inscription"] = 9,
    ["Tailoring"] = 10,
    ["Alchemy"] = 11,
    ["Fishing"] = 12,
    ["Cooking"] = 13,
    ["First Aid"] = 14,
    ["Archaeology"] = 15
}

Amr.RaceIds = {
    ["None"] = 0,
    ["BloodElf"] = 1,
    ["Draenei"] = 2,
    ["Dwarf"] = 3,
    ["Gnome"] = 4,
    ["Human"] = 5,
    ["NightElf"] = 6,
    ["Orc"] = 7,
    ["Tauren"] = 8,
    ["Troll"] = 9,
    ["Scourge"] = 10,
    ["Undead"] = 10,
    ["Goblin"] = 11,
    ["Worgen"] = 12,
    ["Pandaren"] = 13,
	["Nightborne"] = 14,
    ["HighmountainTauren"] = 15,
    ["VoidElf"] = 16,
	["LightforgedDraenei"] = 17,
	["DarkIronDwarf"] = 18,
	["MagharOrc"] = 19,
	["ZandalariTroll"] = 20,
	["KulTiran"] = 21
}

Amr.FactionIds = {
    ["None"] = 0,
    ["Alliance"] = 1,
    ["Horde"] = 2
}

Amr.InstanceIds = {
	Naxx = 533,
	Eye = 616,
	Obsidian = 615,
	Ulduar = 603,
	Trial = 649,
	Onyxia = 249,
	Icecrown = 631,
	Ruby = 724
	--MoltenCore = 409,
	--Bwl = 469,
	--ZulGurub = 309,
	--Aq20 = 509,
	--Aq40 = 531,
	--Kara = 532,
	--Serpentshrine = 548,
	--TempestKeep = 550,
	--Hyjal = 534,
	--BlackTemple = 564,
	--Sunwell = 580,
	--Gruul = 565,
	--Mag = 544,
	--ZulAman = 568
}

-- instances that AskMrRobot currently supports logging for
Amr.SupportedInstanceIds = {
	[533] = true,
	[616] = true,
	[615] = true,
	[603] = true,
	[649] = true,
	[249] = true,
	[631] = true,
	[724] = true
	--[409] = true,
	--[469] = true,
	--[309] = true,
	--[509] = true,
	--[531] = true,
	--[532] = true,
	--[548] = true,
	--[550] = true,
	--[534] = true,
	--[564] = true,
	--[580] = true,
	--[565] = true,
	--[544] = true,
	--[568] = true
}

-- available difficulties for raids
Amr.InstanceDifficulties = {
    [533] = {1, 2},
    [616] = {1, 2},
	[615] = {1, 2},
	[603] = {1, 2},
	[649] = {1, 2, 3, 4},
	[249] = {1, 2},
	[631] = {1, 2, 3, 4},
	[724] = {1, 2, 3, 4}
}


----------------------------------------------------------------------------------------
-- Public Utility Methods
----------------------------------------------------------------------------------------

local function readBonusIdList(parts, first, last)
	local ret = {}	
	for i = first, last do
		table.insert(ret, tonumber(parts[i]))
	end
	table.sort(ret)
	return ret
end

--|cffe6cc80|Hitem: 10090:    :      :      :      :    :1616:   :10 :    :        :          :           :                  :      :[name]
--                 1      2    3      4      5      6    7    8   9   10   11       12         
--                 itemId:ench:gem1  :gem2  :gem3  :gem4:suf :uid:lvl:spec:flags   :instdiffid:numbonusIDs:bonusIDs1...n     :varies:?:relic bonus ids
--|cffe6cc80|Hitem:128866:    :152046:147100:152025:    :    :   :110:66  :16777472:9         :4          :736:1494:1490:1495:709   :1:3:3610:1472:3528:3:3562:1483:3528:3:3610:1477:3336|h[Truthguard]|h|r
--
-- get an object with all of the parts of the item link format that we care about
function Amr.ParseItemLink(itemLink)
    if not itemLink then return nil end
    
    local str = string.match(itemLink, "|Hitem:([\-%d:]+)|")
    if not str then return nil end
    
    local parts = { strsplit(":", str) }
    
	local item = {}
	item.link = itemLink
    item.id = tonumber(parts[1]) or 0
    item.enchantId = tonumber(parts[2]) or 0
    item.gemIds = { tonumber(parts[3]) or 0, tonumber(parts[4]) or 0, tonumber(parts[5]) or 0, tonumber(parts[6]) or 0 }
    item.suffixId = math.abs(tonumber(parts[7]) or 0) -- convert suffix to positive number, that's what we use in our code
    -- part 8 is some unique ID... we never really used it
    -- part 9 is current player level
	-- part 10 is player spec
	local upgradeIdType = tonumber(parts[11]) or 0 -- part 11 indicates what kind of upgrade ID is just after the bonus IDs
    -- part 12 is instance difficulty id
    
    local numBonuses = tonumber(parts[13]) or 0
	local offset = numBonuses
    if numBonuses > 0 then
        item.bonusIds = readBonusIdList(parts, 14, 13 + numBonuses)
    end
	
	item.upgradeId = 0
	item.level = 0
	
	-- the next part after bonus IDs depends on the upgrade id type
	if upgradeIdType == 4 then
		item.upgradeId = tonumber(parts[14 + offset]) or 0
	elseif upgradeIdType == 512 then
		item.level = tonumber(parts[14 + offset]) or 0
	elseif #parts > 16 + offset then
		-- check for relic info
		item.relicBonusIds = { nil, nil, nil }
		numBonuses = tonumber(parts[16 + offset])
		if numBonuses then
			if numBonuses > 0 then
				item.relicBonusIds[1] = readBonusIdList(parts, 17 + offset, 16 + offset + numBonuses)
			end
					
			offset = offset + numBonuses
			if #parts > 17 + offset then
				numBonuses = tonumber(parts[17 + offset])
				if numBonuses then
					if numBonuses > 0 then
						item.relicBonusIds[2] = readBonusIdList(parts, 18 + offset, 17 + offset + numBonuses)
					end

					offset= offset + numBonuses
					if #parts > 18 + offset then
						numBonuses = tonumber(parts[18 + offset])
						if numBonuses then
							if numBonuses > 0 then
								item.relicBonusIds[3] = readBonusIdList(parts, 19 + offset, 18 + offset + numBonuses)
							end	
						end
					end
				end
			end
		end
	end
	
    return item
end

function Amr.GetItemUniqueId(item, noUpgrade)
    if not item then return "" end
    local ret = item.id .. ""
    if item.bonusIds then
		for i = 1, #item.bonusIds do
			ret = ret .. "b" .. item.bonusIds[i]
        end
    end
    if item.suffixId ~= 0 then
        ret = ret .. "s" .. item.suffixId
    end
    if not noUpgrade and item.upgradeId ~= 0 then
        ret = ret .. "u" .. item.upgradeId
    end
	if item.level ~= 0 then
		ret = ret .. "v" .. item.level
	end
    return ret
end

-- returns true if this is an instance that AskMrRobot supports for logging
function Amr.IsSupportedInstanceId(instanceMapID)
	if Amr.SupportedInstanceIds[tonumber(instanceMapID)] then
		return true
	else
		return false
	end
end

-- returns true if currently in a supported instance for logging
function Amr.IsSupportedInstance()
	local _, _, _, _, _, _, _, instanceMapID = GetInstanceInfo()
	return Amr.IsSupportedInstanceId(instanceMapID)
end

-- for debugging
local function dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
end

--[[
-- scanning tooltip b/c for some odd reason the api has no way to get basic item properties...
-- so you have to generate a fake item tooltip and search for pre-defined strings in the display text
local _scanTt
function Amr.GetScanningTooltip()
	if not _scanTt then
		_scanTt = CreateFrame("GameTooltip", "AmrUiScanTooltip", nil, "GameTooltipTemplate")
		_scanTt:SetOwner(UIParent, "ANCHOR_NONE")
	end
	return _scanTt
end

-- get the item tooltip for the specified item in one of your bags, or if bagId is nil, an equipped item, or if slotId is also nil, the specified item link
function Amr.GetItemTooltip(bagId, slotId, link)
	local tt = Amr.GetScanningTooltip()
	tt:ClearLines()
	if bagId then
		tt:SetBagItem(bagId, slotId)
	elseif slotId then
		tt:SetInventoryItem("player", slotId)
	else
		tt:SetHyperlink(link)
	end
	return tt
end
]]

--[[
function Amr.GetItemLevel(bagId, slotId, link)	
	local itemLevelPattern = _G["ITEM_LEVEL"]:gsub("%%d", "(%%d+)")
	local tt = Amr.GetItemTooltip(bagId, slotId, link)
	
	local regions = { tt:GetRegions() }
	for i, region in ipairs(regions) do
		if region and region:GetObjectType() == "FontString" then
			local text = region:GetText()
			if text then
				ilvl = tonumber(text:match(itemLevelPattern))
				if ilvl then
					return ilvl
				end
			end
        end	
	end
	
	-- 0 means we couldn't find it for whatever reason
	return 0
end
]]


----------------------------------------------------------------------------------------
-- Character Reading
----------------------------------------------------------------------------------------

local function readReputations(ret)

	-- we cheat and put it in the profession data as negative
	local numFactions = GetNumFactions()
	local factionIndex = 1
	while (factionIndex <= numFactions) do
		local _, _, _, _, _, earnedValue, _, _, isHeader, isCollapsed, hasRep, _, _, factionId = GetFactionInfo(factionIndex)
		if isHeader and isCollapsed then
			ExpandFactionHeader(factionIndex)
			numFactions = GetNumFactions()
		end
		if hasRep or not isHeader then
			ret.Professions["rep" .. factionId] = earnedValue
		end
		factionIndex = factionIndex + 1
	end

end

local _professionNames = {
	enUS = {
		[164] = "Blacksmithing",
		[165] = "Leatherworking",
		[171] = "Alchemy",
		[182] = "Herbalism",
		[185] = "Cooking",
		[186] = "Mining",
		[197] = "Tailoring",
		[202] = "Engineering",
		[333] = "Enchanting",
		[356] = "Fishing",
		[393] = "Skinning",
		[755] = "Jewelcrafting",
		[773] = "Inscription",
	},
	deDE = {
		[164] = "Schmiedekunst",
		[165] = "Lederverarbeitung",
		[171] = "Alchemie",
		[182] = "Kräuterkunde",
		[185] = "Kochkunst",
		[186] = "Bergbau",
		[197] = "Schneiderei",
		[202] = "Ingenieurskunst",
		[333] = "Verzauberkunst",
		[356] = "Angeln",
		[393] = "Kürschnerei",
		[755] = "Juwelierskunst",
		[773] = "Inschriftenkunde",
	},
	frFR = {
		[164] = "Forge",
		[165] = "Travail du cuir",
		[171] = "Alchimie",
		[182] = "Herboristerie",
		[185] = "Cuisine",
		[186] = "Minage",
		[197] = "Couture",
		[202] = "Ingénierie",
		[333] = "Enchantement",
		[356] = "Pêche",
		[393] = "Dépeçage",
		[755] = "Joaillerie",
		[773] = "Calligraphie",
	},
	esMX = {
		[164] = "Herrería",
		[165] = "Peletería",
		[171] = "Alquimia",
		[182] = "Herboristería",
		[185] = "Cocina",
		[186] = "Minería",
		[197] = "Sastrería",
		[202] = "Ingeniería",
		[333] = "Encantamiento",
		[356] = "Pesca",
		[393] = "Desuello",
		[755] = "Joyería",
		[773] = "Inscripción",
	},
	ptBR = {
		[164] = "Ferraria",
		[165] = "Couraria",
		[171] = "Alquimia",
		[182] = "Herborismo",
		[185] = "Culinária",
		[186] = "Mineração",
		[197] = "Alfaiataria",
		[202] = "Engenharia",
		[333] = "Encantamento",
		[356] = "Pesca",
		[393] = "Esfolamento",
		[755] = "Joalheria",
		[773] = "Escrivania",
	},
	ruRU = {
		[164] = "Кузнечное дело",
		[165] = "Кожевничество",
		[171] = "Алхимия",
		[182] = "Травничество",
		[185] = "Кулинария",
		[186] = "Горное дело",
		[197] = "Портняжное дело",
		[202] = "Инженерное дело",
		[333] = "Наложение чар",
		[356] = "Рыбная ловля",
		[393] = "Снятие шкур",
		[755] = "Ювелирное дело",
		[773] = "Начертание",
	},
	zhCN = {
		[164] = "锻造",
		[165] = "制皮",
		[171] = "炼金术",
		[182] = "草药学",
		[185] = "烹饪",
		[186] = "采矿",
		[197] = "裁缝",
		[202] = "工程学",
		[333] = "附魔",
		[356] = "钓鱼",
		[393] = "剥皮",
		[755] = "珠宝加工",
		[773] = "铭文",
	},
	zhTW = {
		[164] = "鍛造",
		[165] = "製皮",
		[171] = "鍊金術",
		[182] = "草藥學",
		[185] = "烹飪",
		[186] = "採礦",
		[197] = "裁縫",
		[202] = "工程學",
		[333] = "附魔",
		[356] = "釣魚",
		[393] = "剝皮",
		[755] = "珠寶設計",
		[773] = "銘文學",
	},
	koKR = {
		[164] = "대장기술",
		[165] = "가죽세공",
		[171] = "연금술",
		[182] = "약초채집",
		[185] = "요리",
		[186] = "채광",
		[197] = "재봉술",
		[202] = "기계공학",
		[333] = "마법부여",
		[356] = "낚시",
		[393] = "무두질",
		[755] = "보석세공",
		[773] = "주문각인",
	},
	enUS = {
		[164] = "Blacksmithing",
		[165] = "Leatherworking",
		[171] = "Alchemy",
		[182] = "Herbalism",
		[185] = "Cooking",
		[186] = "Mining",
		[197] = "Tailoring",
		[202] = "Engineering",
		[333] = "Enchanting",
		[356] = "Fishing",
		[393] = "Skinning",
		[755] = "Jewelcrafting",
		[773] = "Inscription",
	}
}

_professionNames["enGB"] = _professionNames["enUS"]
_professionNames["esES"] = _professionNames["esMX"]
_professionNames["ptPT"] = _professionNames["ptBR"]


local function readClassicProfessions(ret)

	local profNames = _professionNames[GetLocale()]
	if profNames then
		local profNames_rev = tInvert(profNames)
		 
		for i = 1, GetNumSkillLines() do
			local name, _, _, skillRank = GetSkillLineInfo(i)
			local profId = profNames_rev[name]
			if profId then
				ret.Professions[_professionNames["enUS"][profId]] = skillRank
			end
		end
	end
	
	readReputations(ret)
end

local function readProfessionInfo(prof, ret)
	if prof then
		local _, _, skillLevel, _, _, _, skillLine = GetProfessionInfo(prof);
		if Amr.ProfessionSkillLineToName[skillLine] ~= nil then
			ret.Professions[Amr.ProfessionSkillLineToName[skillLine]] = skillLevel;
		end
	end
end

-- get currently equipped items, store with currently active spec
local function readEquippedItems(ret)
	local equippedItems = {};
	for slotNum = 1, #Amr.SlotIds do
		local slotId = Amr.SlotIds[slotNum]
		local itemLink = GetInventoryItemLink("player", slotId)
		if itemLink then
			local itemData = Amr.ParseItemLink(itemLink)
			if itemData then
				equippedItems[slotId] = itemData
			end
		end
	end
    
    -- store last-seen equipped gear for each spec
	ret.Equipped[1] = equippedItems
end

-- Get just the player's currently equipped gear
function Amr:GetEquipped()
	local ret= {}
	ret.Equipped = {}
	readEquippedItems(ret)
	return ret
end

-- Get all data about the player as an object, includes:
-- serializer version
-- region/realm/name
-- guild
-- race
-- faction
-- level
-- professions
-- spec/talent for all specs
-- equipped gear for the current spec
--
function Amr:GetPlayerData()

	local ret = {}
	
	ret.Region = Amr.RegionNames[GetCurrentRegion()]
    ret.Realm = GetRealmName()
    ret.Name = UnitName("player")
	ret.Guild = GetGuildInfo("player")
    ret.ActiveSpec = 1
    ret.Level = UnitLevel("player");
	
    local _, clsEn = UnitClass("player")
    ret.Class = clsEn;
    
    local _, raceEn = UnitRace("player")
	ret.Race = raceEn;
	ret.Faction = UnitFactionGroup("player")
    
	ret.Professions = {};

	-- classic has super stupid profession api (or lack thereof)
	readClassicProfessions(ret)

	--[[
    local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
	readProfessionInfo(prof1, ret)
	readProfessionInfo(prof2, ret)
	--readProfessionInfo(archaeology, ret)
	readProfessionInfo(fishing, ret)
	readProfessionInfo(cooking, ret)
	readProfessionInfo(firstAid, ret)
	]]

	--ret.Specs = {}
    ret.Talents = {}
	ret.Glyphs = {}

	ret.Equipped = {}	
	readEquippedItems(ret)
	
	return ret
end


----------------------------------------------------------------------------------------
-- Serialization
----------------------------------------------------------------------------------------

local function toCompressedNumberList(list)
    -- ensure the values are numbers, sorted from lowest to highest
    local nums = {}
    for i, v in ipairs(list) do
        table.insert(nums, tonumber(v))
    end
    table.sort(nums)
    
    local ret = {}
    local prev = 0
    for i, v in ipairs(nums) do
        local diff = v - prev
        table.insert(ret, diff)
        prev = v
    end
    
    return table.concat(ret, ",")
end

-- make this utility publicly available
function Amr:ToCompressedNumberList(list)
	return toCompressedNumberList(list)
end

-- appends a list of items to the export
local function appendItemsToExport(fields, itemObjects)

    -- sort by item id so we can compress it more easily
    table.sort(itemObjects, function(a, b) return a.id < b.id end)
    
    -- append to the export string
    local prevItemId = 0
    local prevGemId = 0
    local prevEnchantId = 0
    local prevUpgradeId = 0
    local prevBonusId = 0
	local prevLevel = 0
	local prevRelicBonusId = 0
    for i, itemData in ipairs(itemObjects) do
        local itemParts = {}
        
        table.insert(itemParts, itemData.id - prevItemId)
        prevItemId = itemData.id
        
        if itemData.slot ~= nil then table.insert(itemParts, "s" .. itemData.slot) end
        if itemData.suffixId ~= 0 then table.insert(itemParts, "f" .. itemData.suffixId) end
        if itemData.upgradeId ~= 0 then 
            table.insert(itemParts, "u" .. (itemData.upgradeId - prevUpgradeId))
            prevUpgradeId = itemData.upgradeId
        end
		if itemData.level ~= 0 then
			table.insert(itemParts, "v" .. (itemData.level - prevLevel))
			prevLevel = itemData.level
		end
        if itemData.bonusIds then
            for bIndex, bValue in ipairs(itemData.bonusIds) do
                table.insert(itemParts, "b" .. (bValue - prevBonusId))
                prevBonusId = bValue
            end
		end
		
		if itemData.gemIds[1] ~= 0 then 
			table.insert(itemParts, "x" .. (itemData.gemIds[1] - prevGemId))
			prevGemId = itemData.gemIds[1]
		end
		if itemData.gemIds[2] ~= 0 then 
			table.insert(itemParts, "y" .. (itemData.gemIds[2] - prevGemId))
			prevGemId = itemData.gemIds[2]
		end
		if itemData.gemIds[3] ~= 0 then 
			table.insert(itemParts, "z" .. (itemData.gemIds[3] - prevGemId))
			prevGemId = itemData.gemIds[3]
		end		
        
        if itemData.enchantId ~= 0 then 
            table.insert(itemParts, "e" .. (itemData.enchantId - prevEnchantId))
            prevEnchantId = itemData.enchantId
        end
	
		if itemData.relicBonusIds and itemData.relicBonusIds[1] ~= nil then
			for bIndex, bValue in ipairs(itemData.relicBonusIds[1]) do
                table.insert(itemParts, "p" .. (bValue - prevRelicBonusId))
                prevRelicBonusId = bValue
            end
		end

		if itemData.relicBonusIds and itemData.relicBonusIds[2] ~= nil then
			for bIndex, bValue in ipairs(itemData.relicBonusIds[2]) do
                table.insert(itemParts, "q" .. (bValue - prevRelicBonusId))
                prevRelicBonusId = bValue
            end
		end

		if itemData.relicBonusIds and itemData.relicBonusIds[3] ~= nil then
			for bIndex, bValue in ipairs(itemData.relicBonusIds[3]) do
                table.insert(itemParts, "r" .. (bValue - prevRelicBonusId))
                prevRelicBonusId = bValue
            end
		end
		
        table.insert(fields, table.concat(itemParts, ""))
    end
end

-- Serialize just the identity portion of a player (region/realm/name) in the same format used by the full serialization
function Amr:SerializePlayerIdentity(data)
	local fields = {}    
    table.insert(fields, MINOR)
	table.insert(fields, data.Region)
    table.insert(fields, data.Realm)
    table.insert(fields, data.Name)	
	return "$" .. table.concat(fields, ";") .. "$"
end

-- Serialize player data gathered by GetPlayerData.  This can be augmented with extra data if desired (augmenting used mainly by AskMrRobot addon).
-- Pass complete = true to do a complete export of this extra information, otherwise it is ignored.
-- Extra data can include:
-- equipped gear for the player's inactive spec, slot id to item link dictionary
-- Reputations
-- BagItems, BankItems, VoidItems, lists of item links
--
function Amr:SerializePlayerData(data, complete)

	local fields = {}
    
    -- compressed string uses a fixed order rather than inserting identifiers
    table.insert(fields, MINOR)
	table.insert(fields, data.Region)
    table.insert(fields, data.Realm)
    table.insert(fields, data.Name)

	-- guild name
	if data.Guild == nil then
		table.insert(fields, "")
	else
		table.insert(fields, data.Guild)
    end

    -- race, default to human if we can't read it for some reason
    local raceval = Amr.RaceIds[data.Race]
    if raceval == nil then raceval = 5 end
    table.insert(fields, raceval)
    
    -- faction, default to alliance if we can't read it for some reason
    raceval = Amr.FactionIds[data.Faction]
    if raceval == nil then raceval = 1 end
    table.insert(fields, raceval)
    
	table.insert(fields, data.Level)
	--table.insert(fields, data.HeartOfAzerothLevel)
    
    local profs = {}
    local noprofs = true
    if data.Professions then
	    for k, v in pairs(data.Professions) do
			if strlen(k) > 3 and strsub(k, 1, 3) == "rep" then
				-- a reputation
				table.insert(profs, -tonumber(strsub(k, 4)) .. ":" .. v)
			else
				local profval = Amr.ProfessionIds[k]
				if profval ~= nil then
					noprofs = false
					table.insert(profs, profval .. ":" .. v)				
				end
			end
	    end
	end
    
    if noprofs then
        table.insert(profs, "0:0")
    end
    
    table.insert(fields, table.concat(profs, ","))
    
    -- export specs
	table.insert(fields, data.ActiveSpec)
	
	table.insert(fields, ".s1") -- indicates the start of a spec block
	table.insert(fields, data.Class)
	table.insert(fields, data.Talents[1] or "")	

    -- export equipped gear
    if data.Equipped and data.Equipped[1] then
		table.insert(fields, ".q1") -- indicates the start of an equipped gear block
		
		local itemObjects = {}
		for k, itemData in pairs(data.Equipped[1]) do
			itemData.slot = k
			table.insert(itemObjects, itemData)
		end
		
		appendItemsToExport(fields, itemObjects)
	end

    -- if doing a complete export, include bank/bag items too
	if complete then
		    
        local itemObjects = {}
    	if data.BagItems then
	        for i, itemData in ipairs(data.BagItems) do
				if itemData then
					table.insert(itemObjects, itemData)
				end
	        end
	    end
		if data.BankItems then
	        for i, itemData in ipairs(data.BankItems) do
				if itemData then					
					table.insert(itemObjects, itemData)
				end
	        end
		end
		
        table.insert(fields, ".inv")
        appendItemsToExport(fields, itemObjects)
    end

	-- append glyphs to maintain backwards compatability	
	if data.Glyphs and data.Glyphs[1] then
		table.insert(fields, ".gly")
		for i, glyphId in ipairs(data.Glyphs[1]) do
			table.insert(fields, glyphId)
		end
	end

    return "$" .. table.concat(fields, ";") .. "$"

end
