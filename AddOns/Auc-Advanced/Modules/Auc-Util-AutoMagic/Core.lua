--[[
	Auctioneer - AutoMagic Utility module
	Version: 8.2.6390 (SwimmingSeadragon)
	Revision: $Id: Core.lua 6390 2019-09-13 05:07:31Z none $
	URL: http://auctioneeraddon.com/

	AutoMagic is an Auctioneer module which automates mundane tasks for you.

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]
if not AucAdvanced then return end

local lib = AucAdvanced.Modules.Util.AutoMagic
if not lib then return end
local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()
local AppraiserValue, DisenchantValue, ProspectValue, VendorValue, bestmethod, bestvalue, runstop, _

-- This table is validating that each ID within it is a gem from prospecting.
local isGem =
	{
	[818] = true,--TIGERSEYE
	[774] = true,--MALACHITE
	[1210] = true,--SHADOWGEM
	[1705] = true,--LESSERMOONSTONE
	[1206] = true,--MOSSAGATE
	[3864] = true,--CITRINE
	[1529] = true,--JADE
	[7909] = true,--AQUAMARINE
	[7910] = true,--STARRUBY
	[12800] = true,--AZEROTHIANDIAMOND
	[12361] = true,--BLUESAPPHIRE
	[12799] = true,--LARGEOPAL
	[12364] = true,--HUGEEMERALD
	[23077] = true,--BLOODGARNET
	[21929] = true,--FLAMESPESSARITE
	[23112] = true,--GOLDENDRAENITE
	[23079] = true,--DEEPPERIDOT
	[23117] = true,--AZUREMOONSTONE
	[23107] = true,--SHADOWDRAENITE
	[23436] = true,--LIVINGRUBY
	[23439] = true,--NOBLETOPAZ
	[23440] = true,--DAWNSTONE
	[23437] = true,--TALASITE
	[23428] = true,--STAROFELUNE
	[23441] = true,--NIGHTSEYE
	[36920] = true,--SUNCRYSTAL
	[36926] = true,--SHADOWCRYSTAL
	[36929] = true,--HUGECITRINE
	[36932] = true,--DARKJADE
	[36923] = true,--CHALCEDONY
	[36917] = true,--BLOODSTONE
	[36927] = true,--TWILIGHTOPAL
	[36924] = true,--SKYSAPPHIRE
	[36918] = true,--SCARLETRUBY
	[36930] = true,--MONARCHTOPAZ
	[36933] = true,---FORESTEMERALD
	[36921] = true,--AUTUMNSGLOW
	[24243] = true,--Adamantite Powder
	[31079] = true,--Mercurial Adamantite
	[41334] = true,--Earthsiege Diamond
	[41266] = true,--Skyflare Diamond
	[25867] = true,--Earthstorm Diamond
	[25868] = true,--Skyfire Diamond
	--EPIC 80
	[36919] = true,--Cardinal Ruby
	[36922] = true,--KING'S AMBER
	[36925] = true,--Majestic Zircon
	[36928] = true,--DREADSTONE
	[36931] = true,--AMETRINE
	[36934] = true,--EYE OF ZUL
	--Cataclysm RARE
	[52195] = true,--Amberjewel
	[52196] = true,--Chimera's Eye
	[52194] = true,--Demonseye
	[52192] = true,--Dream Emerald
	[52193] = true,--Ember Topaz
	[52190] = true,--Inferno Ruby
	[52191] = true,--Ocean Sapphire
	[52303] = true,--Shadowspirit Diamond
	[52339] = true,--Flawless Pearl
	--Cataclysm COMMON
	[52179] = true,--Alicite
	[52177] = true,--Carnelian
	[52181] = true,--Hessonite
	[52182] = true,--Jasper
	[52180] = true,--Nightstone
	[52178] = true,--Zephyrite
	--Catclysm Epic
	[71805] = true,--Queen's Garnet
	[71806] = true,--Lightstone
	[71807] = true,--Deepholm Iolite
	[71808] = true,--Lava Coral
	[71809] = true,--Shadow Spinel
	[71810] = true,--Elven Peridot
	--Pandarian Uncommon
	[76130] = true,--Tiger Opal
	[76133] = true,--Lapis Lazuli
	[76134] = true,--Sunstone
	[76135] = true,--Roguestone
	[76136] = true,--Pandarian Garnet
	[76137] = true,--Alexandrite
	--Pandarian Rare
	[76131] = true,--Primordial Ruby
	[76138] = true,--River's Heart
	[76139] = true,--Wild Jade
	[76140] = true,--Vermilion Onyx
	[76141] = true,--Imperial Amethyst
	[76142] = true,--Sun's Radiance
	--Pandarian Other
	[76132] = true,--Primal Diamond
	[76734] = true,--Serpent's Eye
	[90407] = true,--Sparkling Shard
	--Draenor - none mailable
	--Legion Uncommon
	[130172] = true,--Sangrite
	[130173] = true,--Deepamber
	[130174] = true,--Azsunite
	[130175] = true,--ChaoticSpinel
	[130176] = true,--Skystone
	[130177] = true,--QueensOpal
	--Legion Rare
	[130178] = true,--Furystone
	[130179] = true,--EyeOfProphecy
	[130180] = true,--Dawnlight
	[130181] = true,--Pandemonite
	[130182] = true,--MaelstromSapphire
	[130183] = true,--ShadowRuby
	--Legion Argus
	[151721] = true,--Hesselian
	[151579] = true,--Labradorite
	[151719] = true,--Lightsphene
	[151720] = true,--Chemirine
	[151718] = true,--Argulite
	[151722] = true,--FloridMalachite
	--Legion Other
	[129100] = true,--GemChip
}

-- This table is validating that each ID within it is a mat from disenchanting.
local isDEMats =
	{
	--Legion
	[124440] = true,--Arkana
	[124441] = true,--LeylightShard
	[124442] = true,--ChaosCrystal
	--[124124] = true,--BloodOfSargeros - currently Bind on Pickup
	--Draenor
	[115504] = true,--Fractured Temporal Crystal
	[113588] = true,--Temporal Crystal
	[111245] = true,--Luminous Shard
	[115502] = true,--Small Luminous Shard
	[109693] = true,--Draenic Dust
	--Pandarian
	[74248] = true,--Sha Crystal
	[105718] = true, --Sha Crystal Fragment
	[74247] = true,--Ethereal Shard
	[74252] = true,--Small Ethereal Shard
	[74250] = true,--Mysterious Essence
	[74249] = true,--Spirit Dust
	--Cataclysm
	[52722] = true, --Maelstrom Crystal
	[52721] = true, --Heavenly Shard
	[52720] = true, --Small Heavenly Shard
	[52719] = true, --Greater Celestial Essence
	[52718] = true, --Lesser Celestial Essence
	[52555] = true, --Hypnotic Dust

	[34057] = true,--Abyss Crystal
	[22450] = true,--Void Crystal
	[20725] = true,--Nexus Crystal
	[34052] = true,--Dream Shard
	[34053] = true,--Small Dream Shard
	[22449] = true,--Large Prismatic Shards
	[14344] = true,--Large Brillianr Shards
	[11178] = true,--Large Radiant Shards
	[11139] = true,--Large Glowing Shards
	[11084] = true,--Large Glimmering Shards
	[22448] = true,--Small Primatic Shards
	[14343] = true,--Small Brilliant Shards
	[11177] = true,--Small Radiant Shards
	[11138] = true,--Small Glowing Shards
	[10978] = true,--Small Glimmering Shards
	[34055] = true,--Greater Cosmic Essence
	[34056] = true,--Lesser Cosmic Essence
	[22446] = true,--Greater Planer Essence
	[16203] = true,--Greater Eternal Essence
	[11175] = true,--Greater Nether Essence
	[11135] = true,--Greater Mystic Essence
	[11082] = true,--Greater Astral Essence
	[10939] = true,--Greater Magic Essence
	[22447] = true,--Lesser Planer Essence
	[16202] = true,--Lesser Eternal Essence
	[11174] = true,--Lesser Nether Essence
	[11134] = true,--Lesser Mystic Essence
	[10998] = true,--Lesser Astral Essence
	[10938] = true,--Lesser Magic Essence
	[34054] = true, --Infinite Dust
	[22445] = true,--Arcane Dust
	[16204] = true,--Illusion Dust
	[11176] = true,--Dream Dust
	[11137] = true,--Vision Dust
	[11083] = true,--Soul Dust
	[10940] = true,--Strange Dust
}

-- This table is validating that each ID within it is a mat from Milling (table from enchantrix)
local isPigmentMats =
	{
	[39151] = true,-- ALABASTER_PIGMENT
	[39334] = true,-- DUSKY_PIGMENT
	[39338] = true,-- GOLDEN_PIGMENT
	[39339] = true,-- EMERALD_PIGMENT
	[39340] = true,-- VIOLET_PIGMENT
	[39341] = true,-- SILVERY_PIGMENT
	[43103] = true,-- VERDANT_PIGMENT
	[43104] = true,-- BURNT_PIGMENT
	[43105] = true,-- INDIGO_PIGMENT
	[43106] = true,-- RUBY_PIGMENT
	[43107] = true,-- SAPPHIRE_PIGMENT
	[39342] = true,-- NETHER_PIGMENT
	[43108] = true,-- EBON_PIGMENT
	[39343] = true,-- AZURE_PIGMENT
	[43109] = true,-- ICY_PIGMENT
	--Cataclysm
	[61979] = true,-- ASHEN_PIGMENT
	[61981] = true,-- BURNING_EMBERS
	--Pandarian
	[79251] = true,--Shadow Pigment
	[79253] = true,--Misty Pigment
	--Draenor
	[114931] = true,--Cerulean Pigment
	--Legion
	[129032] = true,--RoseatePigment
	[129034] = true,--SallowPigment
}
-- This table is validating that each ID within it is a herb. Data from informant. This allows locale independent herbs
local isHerb =
	{
	[765] = true, --  Silverleaf
	[785] = true, --  Mageroyal
	[2447] = true, --  Peacebloom
	[2449] = true, --  Earthroot
	[2450] = true, --  Briarthorn
	[2452] = true, --  Swiftthistle
	[2453] = true, --  Bruiseweed
	[3355] = true, --  Wild Steelbloom
	[3356] = true, --  Kingsblood
	[3357] = true, --  Liferoot
	[3358] = true, --  Khadgar's Whisker
	[3369] = true, --  Grave Moss
	[3818] = true, --  Fadeleaf
	[3819] = true, --  Wintersbite
	[3820] = true, --  Stranglekelp
	[3821] = true, --  Goldthorn
	[4625] = true, --  Firebloom
	[8153] = true, --  Wildvine
	[8831] = true, --  Purple Lotus
	[8836] = true, --  Arthas' Tears
	[8838] = true, --  Sungrass
	[8839] = true, --  Blindweed
	[8845] = true, --  Ghost Mushroom
	[8846] = true, --  Gromsblood
	[10286] = true, -- Heart of the Wild
	[13463] = true, --  Dreamfoil
	[13464] = true, --  Golden Sansam
	[13465] = true, --  Mountain Silversage
	[13466] = true, --  Plaguebloom
	[13467] = true, --  Icecap
	[13468] = true, --  Black Lotus
	[19726] = true, --  Bloodvine
	[19727] = true, --  Blood Scythe
	[22710] = true, --  Bloodthistle
	[22785] = true, --  Felweed
	[22786] = true, --  Dreaming Glory
	[22787] = true, --  Ragveil
	[22788] = true, --  Flame Cap
	[22789] = true, --  Terocone
	[22790] = true, --  Ancient Lichen
	[22791] = true, --  Netherbloom
	[22792] = true, --  Nightmare Vine
	[22793] = true, --  Mana Thistle
	[22794] = true, --  Fel Lotus
	[22797] = true, --  Nightmare Seed
	[36901] = true, --  Goldclover
	[36902] = true, --  Constrictor Grass
	[36903] = true, --  Adder's Tongue
	[36904] = true, --  Tiger Lily
	[36905] = true, --  Lichbloom
	[36906] = true, --  Icethorn
	[36907] = true, --  Talandra's Rose
	[36908] = true, --  Frost Lotus
	[37921] = true, --  Deadnettle
	[39970] = true, -- Fire Leaf

	--Cataclysm
	[52983] = true,--CINDERBLOOM
	[52984] = true,-- STORMVINE
	[52985] = true,-- AZSHARAS VEIL
	[52986] = true,-- HEART BLOSSOM
	[52987] = true,-- TWILIGHT JASMINE
	[52988] = true,-- WHIPTAIL
	--Pandarian
	[72234] = true,--Green Tea Leaf
	[72235] = true,--Silkweed
	[72237] = true,--Rain Poppy
	[72238] = true,--Golden Lotus
	[79010] = true,--Snow Lily
	[79011] = true,--Fool's Cap
	[89639] = true,--Desecrated Herb
	--Draenor
	[109124] = true,--Frostweed
	[109125] = true,--Fireweed
	[109126] = true,--Gorgrond Flytrap
	[109127] = true,--Starflower
	[109128] = true,--Nagrand Arrowbloom
	[109129] = true,--Talador Orchid
	[109130] = true,--Chameleon Lotus
	--Legion
	[124101] = true,--Aethril
	[124102] = true,--Dreamleaf
	[124103] = true,--Foxflower
	[124104] = true,--Fjarnskaggle
	[124105] = true,--StarlightRose
	[124106] = true,--Felwort
	[128304] = true,--YserallineSeed
	[151565] = true,--AstralGlory
	}

--Inv slot types, used to help define what gear is usable via tooltip parse
local InventoryTypes = {
	[INVTYPE_2HWEAPON] = INVTYPE_2HWEAPON,
	[INVTYPE_AMMO] = INVTYPE_AMMO,
	[INVTYPE_BAG] = INVTYPE_BAG,
	[INVTYPE_BODY] = INVTYPE_BODY,
	[INVTYPE_CHEST] = INVTYPE_CHEST,
	[INVTYPE_CLOAK] = INVTYPE_CLOAK,
	[INVTYPE_FEET] = INVTYPE_FEET,
	[INVTYPE_FINGER] = INVTYPE_FINGER,
	[INVTYPE_HAND] = INVTYPE_HAND,
	[INVTYPE_HEAD] = INVTYPE_HEAD,
	[INVTYPE_HOLDABLE] = INVTYPE_HOLDABLE,
	[INVTYPE_LEGS] = INVTYPE_LEGS,
	[INVTYPE_NECK] = INVTYPE_NECK,
	[INVTYPE_QUIVER] = INVTYPE_QUIVER,
	[INVTYPE_RANGED] = INVTYPE_RANGED,
	[INVTYPE_RELIC] = INVTYPE_RELIC,
	[INVTYPE_ROBE] = INVTYPE_ROBE,
	[INVTYPE_SHIELD] = INVTYPE_SHIELD,
	[INVTYPE_SHOULDER] = INVTYPE_SHOULDER,
	[INVTYPE_TABARD] = INVTYPE_TABARD,
	[INVTYPE_TRINKET] = INVTYPE_TRINKET ,
	[INVTYPE_WAIST] = INVTYPE_WAIST,
	[INVTYPE_WEAPON] = INVTYPE_WEAPON,
	[INVTYPE_WEAPONMAINHAND] = INVTYPE_WEAPONMAINHAND,
	[INVTYPE_WEAPONMAINHAND_PET] = INVTYPE_WEAPONMAINHAND_PET,
	[INVTYPE_WEAPONOFFHAND] = INVTYPE_WEAPONOFFHAND,
	[INVTYPE_WRIST] = INVTYPE_WRIST,
}
if not AucAdvanced.Classic then
	InventoryTypes[INVTYPE_RANGEDRIGHT] = INVTYPE_RANGEDRIGHT
	InventoryTypes[INVTYPE_THROWN] = INVTYPE_THROWN
end

--Auc Core tooltip scanner
local ScanTip  = AppraiserTip
local ScanTip2  = AppraiserTipTextLeft2
local ScanTip3 = AppraiserTipTextLeft3
local ScanTipRight2  = AppraiserTipTextRight2
local ScanTipRight3 = AppraiserTipTextRight3
function lib.cannotUse(itemSubType)
	--scan tooltip  if its a valid equip text, look at color
	if InventoryTypes[ScanTip2:GetText()] or InventoryTypes[ScanTip3:GetText()] then
		local hex,r,g,b

		r,g,b = ScanTip2:GetTextColor()
		hex = string.format("%02x%02x%02x", r*255, g*255, b*255)
		if ScanTip2:GetText() and hex == "fe1f1f" then
--~ 			aucPrint(2, AppraiserTipTextLeft1:GetText(), ScanTip2:GetText())
			return true
		end

		r,g,b = ScanTip3:GetTextColor()
		hex = string.format("%02x%02x%02x", r*255, g*255, b*255)
		if ScanTip3:GetText() and hex == "fe1f1f" then
--~ 			aucPrint(3, AppraiserTipTextLeft1:GetText(), ScanTip3:GetText())
			return true
		end
		--check for red text in right side of tooltip
		r,g,b = ScanTipRight2:GetTextColor()
		hex = string.format("%02x%02x%02x", r*255, g*255, b*255)
		if ScanTipRight2:GetText() and hex == "fe1f1f" then
--~ 			aucPrint(4, AppraiserTipTextLeft1:GetText(), ScanTipRight2:GetText())
			return true
		end

		r,g,b = ScanTipRight3:GetTextColor()
		hex = string.format("%02x%02x%02x", r*255, g*255, b*255)
		if ScanTipRight3:GetText() and hex == "fe1f1f" then
--~ 			aucPrint(5, AppraiserTipTextLeft1:GetText(), ScanTipRight3:GetText())
			return true
		end

	end
	--its equipable by the class so dont sell
	return false
end

--Taken from auc core, used to find soulbound state
local BindTypes = {
	[ITEM_SOULBOUND] = "Bound",
	[ITEM_BIND_ON_PICKUP] = "Bound",
}
--tooltip checks soulbound status
function lib.isSoulbound(bag, slot)
	ScanTip:SetOwner(UIParent, "ANCHOR_NONE")
	ScanTip:ClearLines()
	ScanTip:SetBagItem(bag, slot)
	return BindTypes[ScanTip2:GetText()] or BindTypes[ScanTip3:GetText()]
end

lib.vendorlist = {}
function lib.vendorAction(autovendor)
--~ 	if not playerArmorType then
--~ 		 playerArmorType = lib.playerArmor()--create the players localized usable armor
--~ 	end
	empty(lib.vendorlist) --this needs to be cleared on every vendor open
--~ 	local  ignoredItemsFound --used to alert players that some vendor items were skipped
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				local itemLink = GetContainerItemLink(bag,slot)
				local texture, itemCount, locked, _, lootable = GetContainerItemInfo(bag, slot) --items that have been vedored but are still in players bag (lag) will be locked by server.
				if itemLink and not locked then
					if not itemCount then itemCount = 1 end
					local linkType, itemID, _, _, _, _ = decode(itemLink)
					if linkType == "item" then
						local itemSig = AucAdvanced.API.GetSigFromLink(itemLink) -- future plan is to use itemSig in place of itemID throughout - to eliminate problems for items with suffixes
						local itemName, _, itemRarity, _, _, itemType, itemSubType = GetItemInfo(itemLink)
						local key = bag..":"..slot -- key needs to be unique, but is not currently used for anything. future: rethink if this can be made useful
						--tooltip checks soulbound status
						-- ScanTip:SetOwner(UIParent, "ANCHOR_NONE")
						-- ScanTip:ClearLines()
						-- ScanTip:SetBagItem(bag, slot)
						-- local soulbound = lib.isSoulbound(bag, slot)
						--item is ignored then skip it. Stops ignored items from showing on vedor list
	--~ 					if not get("util.automagic.vidignored"..itemID) then
							--autovendor  is used to sell without confirmation.
							if autovendor then
								if get("util.automagic.autoselllist") and get("util.automagic.autoselllistnoprompt") and lib.autoSellList[ itemID ] then
									lib.vendorlist[key] = {itemLink, itemSig, itemCount, bag, slot, "Sell List"}
								elseif itemRarity == 0 and get("util.automagic.autosellgrey") and get("util.automagic.autosellgreynoprompt") then
									lib.vendorlist[key] = {itemLink, itemSig, itemCount, bag, slot, "Grey"}
								-- elseif soulbound and get("util.automagic.vendorunusablebop") and get("util.automagic.autosellbopnoprompt") and IsEquippableItem(itemLink) and itemRarity < 3 and not lootable and lib.cannotUse(itemSubType) then
									-- lib.vendorlist[key] = {itemLink, itemSig, itemCount, bag, slot, "Unusable"}
								elseif get("util.automagic.autosellreason") and get("util.automagic.autosellreasonnoprompt") then
									local reason, text = lib.getReason(itemLink, itemName, itemCount, "vendor")
									if reason and text then
										lib.vendorlist[key] = {itemLink, itemSig, itemCount, bag, slot, text}
									end
								end
							else
								if get("util.automagic.autoselllist") and lib.autoSellList[ itemID ] then
									lib.vendorlist[key] = {itemLink, itemSig, itemCount, bag, slot, "Sell List"}
								elseif itemRarity == 0 and get("util.automagic.autosellgrey") then
									lib.vendorlist[key] = {itemLink, itemSig, itemCount, bag, slot, "Grey"}
								-- elseif soulbound and get("util.automagic.vendorunusablebop") and IsEquippableItem(itemLink) and itemRarity < 3 and not lootable and lib.cannotUse(itemSubType) then
									-- lib.vendorlist[key] = {itemLink, itemSig, itemCount, bag, slot, "Unusable"}
								elseif get("util.automagic.autosellreason") then
									local reason, text = lib.getReason(itemLink, itemName, itemCount, "vendor")
									if reason and text then
										lib.vendorlist[key] = {itemLink, itemSig, itemCount, bag, slot, text}
									end
								end
							end
	--~ 					else
	--~ 						ignoredItemsFound = true
	--~ 					end
						--clear tooltip for this loop
						ScanTip:Hide()
					end
				end
			end
		end
	end
	if autovendor then
		lib.ASCConfirmContinue()
	else
		lib.ASCPrompt()
	end
	if ignoredItemsFound then
		aucPrint("Automagic skipped items on vendoring ignore list")
	end

end

function lib.disenchantAction(bag, slot, itemLink, itemID, itemCount, itemName)
	if (AucAdvanced.Modules.Util.ItemSuggest and get("util.automagic.overidebtmmail") == true) then
		local aimethod = AucAdvanced.Modules.Util.ItemSuggest.itemsuggest(itemLink, itemCount)
		if(aimethod == "Disenchant") then
			if (get("util.automagic.chatspam")) then
				aucPrint("AutoMagic has loaded", itemName, "due to Item Suggest(Disenchant)")
			end
			UseContainerItem(bag, slot)
		end
	else --look for btmScan or SearchUI reason codes if above fails
		local reason, text = lib.getReason(itemLink, itemName, itemCount, "disenchant")
		if reason and text then
			if (get("util.automagic.chatspam")) then
				aucPrint("AutoMagic has loaded", itemName, "due to", text ,"Rule(Disenchant)")
			end
			UseContainerItem(bag, slot)
		end
	end
end

function lib.prospectAction(bag, slot, itemLink, itemID, itemCount, itemName)
	if (AucAdvanced.Modules.Util.ItemSuggest and get("util.automagic.overidebtmmail") == true) then
		local aimethod = AucAdvanced.Modules.Util.ItemSuggest.itemsuggest(itemLink, itemCount)
		if(aimethod == "Prospect") then
			if (get("util.automagic.chatspam")) then
				aucPrint("AutoMagic has loaded", itemName, "due to Item Suggest(Prospect)")
			end
			UseContainerItem(bag, slot)
		end
	else --look for btmScan or SearchUI reason codes if above fails
		local reason, text = lib.getReason(itemLink, itemName, itemCount, "prospect")
		if reason and text then
			if (get("util.automagic.chatspam")) then
				aucPrint("AutoMagic has loaded", itemName, "due to", text ,"Rule(Prospect)")
			end
			UseContainerItem(bag, slot)
		end
	end
end

function lib.gemAction(bag, slot, itemLink, itemID, itemCount, itemName)
	if isGem[ itemID ] then
		if (get("util.automagic.chatspam")) then
			aucPrint("AutoMagic has loaded", itemName, "because it is a gem.")
		end
		UseContainerItem(bag, slot)
	end
end

function lib.dematAction(bag, slot, itemLink, itemID, itemCount, itemName)
	if isDEMats[ itemID ] then
		if (get("util.automagic.chatspam")) then
			aucPrint("AutoMagic has loaded", itemName, "because it is a mat used for enchanting.")
		end
		UseContainerItem(bag, slot)
	end
end

function lib.pigmentAction(bag, slot, itemLink, itemID, itemCount, itemName)
	if isPigmentMats[ itemID ] then
		if (get("util.automagic.chatspam")) then
			aucPrint("AutoMagic has loaded", itemName, "because it is a pigment used for milling.")
		end
		UseContainerItem(bag, slot)
	end
end

function lib.herbAction(bag, slot, itemLink, itemID, itemCount, itemName)
	if isHerb[ itemID ] then
		if (get("util.automagic.chatspam")) then
			aucPrint("AutoMagic has loaded", itemName, "because it is a herb.")
		end
		UseContainerItem(bag, slot)
	end
end

--Searches for reason and returns values if found nil other wise.
--Consolidates code into one function instead of 5-6 places that need editing/maintaining
function lib.getReason(itemLink, itemName, itemCount, text)
	if (BtmScan) then
		local bidlist = BtmScan.Settings.GetSetting("bid.list")
		if (bidlist) then
			local id, suffix, enchant, seed = BtmScan.BreakLink(itemLink)
			local sig = ("%d:%d:%d"):format(id, suffix, enchant)
			local bids = bidlist[sig..":"..seed.."x"..itemCount]

			if(bids and bids[1] and bids[1] == text) then
				return bids[1], "BTM"
			end
		end
	end

	if (BeanCounter and BeanCounter.API.isLoaded) then
		local reason = BeanCounter.API.getBidReason(itemLink, itemCount) or ""
		if reason:lower() == text then
			return reason, "SearchUI"
		end
	end

	return
end

--User buttons
function lib.customAction(button)
	MailFrameTab_OnClick(nil, 2)
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				local itemLink = GetContainerItemLink(bag,slot)
				local itemCount = GetContainerItemInfo(bag, slot)
				if (itemLink == nil) then return end
				if itemCount == nil then itemCount = 1 end


				local itemName, _, itemRarity, _, _, _, _, _, _, _ = GetItemInfo(itemLink)
				local itemID = GetContainerItemID(bag, slot)
				local settings = get("util.automagic.SavedMailButtons")
				local buttonName = button:GetText()
				if settings and settings[buttonName] then
					for i, data in pairs (settings[buttonName]) do
						if data[2] == itemID and not lib.isSoulbound(bag, slot) then
							if (get("util.automagic.chatspam")) then
								aucPrint("AutoMagic has loaded", itemName, "from custom button.")
							end
							UseContainerItem(bag, slot)
						end
					end
				end

			end
		end
	end
end
--Consolidate function to read all bags
function lib.scanBags(actionFunction)
	MailFrameTab_OnClick(nil, 2)
	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot)) then
				local itemLink, itemCount = GetContainerItemLink(bag,slot)
				if (itemLink == nil) then return end
				if itemCount == nil then _, itemCount = GetContainerItemInfo(bag, slot) end
				if itemCount == nil then itemCount = 1 end
				local linkType, itemID, _, _, _, _ = decode(itemLink)
				if linkType == "item" then
					local itemName = GetItemInfo(itemLink)
					actionFunction(bag, slot, itemLink, itemID, itemCount, itemName)
				end
			end
		end
	end
end



AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-AutoMagic/Core.lua $", "$Rev: 6390 $")
