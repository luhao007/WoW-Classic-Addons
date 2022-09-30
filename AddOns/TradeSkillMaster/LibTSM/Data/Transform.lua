-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Transform = TSM.Init("Data.Transform")
local private = {}



-- ============================================================================
-- Transform Data
-- ============================================================================

local DATA = {
	-- ================================== Essences / Illusion Dust =================================
	["i:52719"] = not TSM.IsWowClassic() and {
		["i:52718"] = 1/3, -- Greater Celestial Essence
	} or nil,
	["i:52718"] = not TSM.IsWowClassic() and {
		["i:52719"] = 3, -- Lesser Celestial Essence
	} or nil,
	["i:34055"] = not TSM.IsWowVanillaClassic() and {
		["i:34056"] = 1/3, -- Greater Cosmic Essence
	} or nil,
	["i:34056"] = not TSM.IsWowVanillaClassic() and {
		["i:34055"] = 3, -- Lesser Cosmic Essence
	} or nil,
	["i:22446"] = not TSM.IsWowVanillaClassic() and {
		["i:22447"] = 1/3, -- Greater Planar Essence
	} or nil,
	["i:22447"] = not TSM.IsWowVanillaClassic() and {
		["i:22446"] = 3, -- Lesser Planar Essence
	} or nil,
	["i:16203"] = {
		["i:16202"] = 1/3, -- Greater Eternal Essence
	},
	["i:16202"] = {
		["i:16203"] = 3, -- Lesser Eternal Essence
	},
	["i:11175"] = TSM.IsWowClassic() and {
		["i:11174"] = 1/3, -- Greater Nether Essence
	} or nil,
	["i:11174"] = TSM.IsWowClassic() and {
		["i:11175"] = 3, -- Lesser Nether Essence
	} or nil,
	["i:11135"] = TSM.IsWowClassic() and {
		["i:11134"] = 1/3, -- Greater Mystic Essence
	} or nil,
	["i:11134"] = TSM.IsWowClassic() and {
		["i:11135"] = 3, -- Lesser Mystic Essence
	} or nil,
	["i:11082"] = TSM.IsWowClassic() and {
		["i:10998"] = 1/3, -- Greater Astral Essence
	} or nil,
	["i:10998"] = TSM.IsWowClassic() and {
		["i:11082"] = 3, -- Lesser Astral Essence
	} or nil,
	["i:10939"] = {
		["i:10938"] = 1/3, -- Greater Magic Essence
	},
	["i:10938"] = {
		["i:10939"] = 3, -- Lesser Magic Essence
	},
	["i:156930"] = not TSM.IsWowClassic() and {
		["i:16204"] = 1/3, -- Rich Illusion Dust
	} or nil,
	["i:16204"] = not TSM.IsWowClassic() and {
		["i:156930"] = 3, -- Light Illusion Dust
	} or nil,
	-- ============================================ Shards =========================================
	["i:34052"] = not TSM.IsWowVanillaClassic() and {
		["i:34053"] = 1/3, -- Dream Shard
	} or nil,
	["i:52721"] = not TSM.IsWowClassic() and {
		["i:52720"] = 1/3, -- Heavenly Shard
	} or nil,
	["i:74247"] = not TSM.IsWowClassic() and {
		["i:74252"] = 1/3, -- Ethereal Shard
	} or nil,
	["i:111245"] = not TSM.IsWowClassic() and {
		["i:115502"] = 0.1, -- Luminous Shard
	} or nil,
	-- =========================================== Crystals ========================================
	["i:113588"] = not TSM.IsWowClassic() and {
		["i:115504"] = 0.1, -- Temporal Crystal
	} or nil,
	-- ======================================== Primals / Motes ====================================
	["i:21885"] = not TSM.IsWowVanillaClassic() and {
		["i:22578"] = 0.1, -- Water
	} or nil,
	["i:22456"] = not TSM.IsWowVanillaClassic() and {
		["i:22577"] = 0.1, -- Shadow
	} or nil,
	["i:22457"] = not TSM.IsWowVanillaClassic() and {
		["i:22576"] = 0.1, -- Mana
	} or nil,
	["i:21886"] = not TSM.IsWowVanillaClassic() and {
		["i:22575"] = 0.1, -- Life
	} or nil,
	["i:21884"] = not TSM.IsWowVanillaClassic() and {
		["i:22574"] = 0.1, -- Fire
	} or nil,
	["i:22452"] = not TSM.IsWowVanillaClassic() and {
		["i:22573"] = 0.1, -- Earth
	} or nil,
	["i:22451"] = not TSM.IsWowVanillaClassic() and {
		["i:22572"] = 0.1, -- Air
	} or nil,
	-- ===================================== Crystalized / Eternal =================================
	["i:37700"] = not TSM.IsWowClassic() and {
		["i:35623"] = 10, -- Air
	} or nil,
	["i:35623"] = not TSM.IsWowClassic() and {
		["i:37700"] = 0.1, -- Air
	} or nil,
	["i:37701"] = not TSM.IsWowClassic() and {
		["i:35624"] = 10, -- Earth
	} or nil,
	["i:35624"] = not TSM.IsWowClassic() and {
		["i:37701"] = 0.1, -- Earth
	} or nil,
	["i:37702"] = not TSM.IsWowClassic() and {
		["i:36860"] = 10, -- Fire
	} or nil,
	["i:36860"] = not TSM.IsWowClassic() and {
		["i:37702"] = 0.1, -- Fire
	} or nil,
	["i:37703"] = not TSM.IsWowClassic() and {
		["i:35627"] = 10, -- Shadow
	} or nil,
	["i:35627"] = not TSM.IsWowClassic() and {
		["i:37703"] = 0.1, -- Shadow
	} or nil,
	["i:37704"] = not TSM.IsWowClassic() and {
		["i:35625"] = 10, -- Life
	} or nil,
	["i:35625"] = not TSM.IsWowClassic() and {
		["i:37704"] = 0.1, -- Life
	} or nil,
	["i:37705"] = not TSM.IsWowClassic() and {
		["i:35622"] = 10, -- Water
	} or nil,
	["i:35622"] = not TSM.IsWowClassic() and {
		["i:37705"] = 0.1, -- Water
	} or nil,
	-- ========================================= Wod Fish ==========================================
	["i:109137"] = not TSM.IsWowClassic() and {
		["i:111601"] = 4, -- Enormous Crescent Saberfish
		["i:111595"] = 2, -- Crescent Saberfish
		["i:111589"] = 1, -- Small Crescent Saberfish
	} or nil,
	["i:109138"] = not TSM.IsWowClassic() and {
		["i:111676"] = 4, -- Enormous Jawless Skulker
		["i:111669"] = 2, -- Jawless Skulker
		["i:111650"] = 1, -- Small Jawless Skulker
	} or nil,
	["i:109139"] = not TSM.IsWowClassic() and {
		["i:111675"] = 4, -- Enormous Fat Sleeper
		["i:111668"] = 2, -- Fat Sleeper
		["i:111651"] = 1, -- Small Fat Sleeper
	} or nil,
	["i:109140"] = not TSM.IsWowClassic() and {
		["i:111674"] = 4, -- Enormous Blind Lake Sturgeon
		["i:111667"] = 2, -- Blind Lake Sturgeon
		["i:111652"] = 1, -- Small Blind Lake Sturgeon
	} or nil,
	["i:109141"] = not TSM.IsWowClassic() and {
		["i:111673"] = 4, -- Enormous Fire Ammonite
		["i:111666"] = 2, -- Fire Ammonite
		["i:111656"] = 1, -- Small Fire Ammonite
	} or nil,
	["i:109142"] = not TSM.IsWowClassic() and {
		["i:111672"] = 4, -- Enormous Sea Scorpion
		["i:111665"] = 2, -- Sea Scorpion
		["i:111658"] = 1, -- Small Sea Scorpion
	} or nil,
	["i:109143"] = not TSM.IsWowClassic() and {
		["i:111671"] = 4, -- Enormous Abyssal Gulper Eel
		["i:111664"] = 2, -- Abyssal Gulper Eel
		["i:111659"] = 1, -- Small Abyssal Gulper Eel
	} or nil,
	["i:109144"] = not TSM.IsWowClassic() and {
		["i:111670"] = 4, -- Enormous Blackwater Whiptail
		["i:111663"] = 2, -- Blackwater Whiptail
		["i:111662"] = 1, -- Small Blackwater Whiptail
	} or nil,
	-- ========================================== Aromatic Fish Oil (BFA) ===========================
	["i:160711"] = not TSM.IsWowClassic() and {
		["i:152543"] = 1, -- Sand Shifter
		["i:152544"] = 1, -- Slimy Mackerel
		["i:152545"] = 1, -- Frenzied Fangtooth
		["i:152546"] = 1, -- Lane Snapper
		["i:152547"] = 1, -- Great Sea Catfish
		["i:152548"] = 1, -- Tiragarde Perch
		["i:152549"] = 1, -- Redtail Loach
		["i:168302"] = 1, -- Viper Fish
		["i:168646"] = 1, -- Mauve Stinger
		["i:174327"] = 1, -- Malformed Gnasher
		["i:174328"] = 1, -- Aberrant Voidfin
	} or nil,
	-- ========================================== Ore Nuggets =======================================
	["i:2771"] = not TSM.IsWowClassic() and {
		["i:108295"] = 0.1, -- Tin Ore
	} or nil,
	["i:2772"] = not TSM.IsWowClassic() and {
		["i:108297"] = 0.1, -- Iron Ore
	} or nil,
	["i:2775"] = not TSM.IsWowClassic() and {
		["i:108294"] = 0.1, -- Silver Ore
	} or nil,
	["i:2776"] = not TSM.IsWowClassic() and {
		["i:108296"] = 0.1, -- Gold Ore
	} or nil,
	["i:3858"] = not TSM.IsWowClassic() and {
		["i:108300"] = 0.1, -- Mithril Ore
	} or nil,
	["i:7911"] = not TSM.IsWowClassic() and {
		["i:108299"] = 0.1, -- Truesilver Ore
	} or nil,
	["i:10620"] = not TSM.IsWowClassic() and {
		["i:108298"] = 0.1, -- Thorium Ore
	} or nil,
	["i:23424"] = not TSM.IsWowClassic() and {
		["i:108301"] = 0.1, -- Fel Iron Ore
	} or nil,
	["i:23425"] = not TSM.IsWowClassic() and {
		["i:108302"] = 0.1, -- Adamantite Ore
	} or nil,
	["i:23426"] = not TSM.IsWowClassic() and {
		["i:108304"] = 0.1, -- Khorium Ore
	} or nil,
	["i:23427"] = not TSM.IsWowClassic() and {
		["i:108303"] = 0.1, -- Eternium Ore
	} or nil,
	["i:36909"] = not TSM.IsWowClassic() and {
		["i:108305"] = 0.1, -- Cobalt Ore
	} or nil,
	["i:36910"] = not TSM.IsWowClassic() and {
		["i:108391"] = 0.1, -- Titanium Ore
	} or nil,
	["i:36912"] = not TSM.IsWowClassic() and {
		["i:108306"] = 0.1, -- Saronite Ore
	} or nil,
	["i:52183"] = not TSM.IsWowClassic() and {
		["i:108309"] = 0.1, -- Pyrite Ore
	} or nil,
	["i:52185"] = not TSM.IsWowClassic() and {
		["i:108308"] = 0.1, -- Elementium Ore
	} or nil,
	["i:53038"] = not TSM.IsWowClassic() and {
		["i:108307"] = 0.1, -- Obsidium Ore
	} or nil,
	["i:72092"] = not TSM.IsWowClassic() and {
		["i:97512"] = 0.1, -- Ghost Iron Ore
	} or nil,
	["i:109119"] = not TSM.IsWowClassic() and {
		["i:109991"] = 0.1, -- True Iron Ore
	} or nil,
	-- =========================================== Herb Parts ======================================
	["i:2449"] = not TSM.IsWowClassic() and {
		["i:108319"] = 0.1, -- Earthroot Stem
	} or nil,
	["i:2453"] = not TSM.IsWowClassic() and {
		["i:108322"] = 0.1, -- Bruiseweed Stem
	} or nil,
	["i:3357"] = not TSM.IsWowClassic() and {
		["i:108325"] = 0.1, -- Liferoot Stem
	} or nil,
	["i:3358"] = not TSM.IsWowClassic() and {
		["i:108326"] = 0.1, -- Khadgar's Whisker Stem
	} or nil,
	["i:3819"] = not TSM.IsWowClassic() and {
		["i:108329"] = 0.1, -- Dragon's Teeth Stem
	} or nil,
	["i:8839"] = not TSM.IsWowClassic() and {
		["i:108336"] = 0.1, -- Blindweed Stem
	} or nil,
	["i:22792"] = not TSM.IsWowClassic() and {
		["i:108350"] = 0.1, -- Nightmare Vine Stem
	} or nil,
	["i:36903"] = not TSM.IsWowClassic() and {
		["i:108353"] = 0.1, -- Adder's Tongue Stem
	} or nil,
	["i:52985"] = not TSM.IsWowClassic() and {
		["i:108362"] = 0.1, -- Azshara's Veil Stem
	} or nil,
	["i:52988"] = not TSM.IsWowClassic() and {
		["i:108365"] = 0.1, -- Whiptail Stem
	} or nil,
	["i:72235"] = not TSM.IsWowClassic() and {
		["i:97621"] = 0.1, -- Silkweed Stem
	} or nil,
	["i:109124"] = not TSM.IsWowClassic() and {
		["i:109624"] = 0.1, -- Broken Frostweed Stem
	} or nil,
	["i:109125"] = not TSM.IsWowClassic() and {
		["i:109625"] = 0.1, -- Broken Fireweed Stem
	} or nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Transform.TargetItemIterator()
	return private.TableKeyIterator, DATA, nil
end

function Transform.SourceItemIterator(targetItemString)
	return private.TableKeyIterator, DATA[targetItemString], nil
end

function Transform.GetRate(targetItemString, sourceItemString)
	return DATA[targetItemString][sourceItemString]
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.TableKeyIterator(tbl, index)
	index = next(tbl, index)
	return index
end
