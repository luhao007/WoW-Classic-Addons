--[[
	Auctioneer
	Version: 8.2.6430 (SwimmingSeadragon)
	Revision: $Id: CoreConst.lua 6430 2019-09-22 00:20:05Z none $
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds statistical history to the auction data that is collected
	when the auction is scanned, so that you can easily determine what price
	you will be able to sell an item for at auction or at a vendor whenever you
	mouse-over an item in the game

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
]]
if not AucAdvanced then return end
AucAdvanced.CoreFileCheckIn("CoreConst")

local lib = {
	PlayerName = UnitName("player"),
	PlayerRealm = GetRealmName(),

	AucMinTimes = {
		0,
		1800, -- 30 mins
		7200, -- 2 hours
		43200, -- 12 hours
	},
	AucMaxTimes = {
		1800,  -- 30 mins
		7200,  -- 2 hours
		43200, -- 12 hours
		172800 -- 48 hours
	},
	AucTimes = {
		0,
		1800, -- 30 mins
		7200, -- 2 hours
		43200, -- 12 hours
		172800 -- 48 hours
	},

	EquipEncode = { -- Converts "INVTYPE_*" strings to an internal number code; stored in scandata and used by Stat-iLevel
		INVTYPE_HEAD = 1,
		INVTYPE_NECK = 2,
		INVTYPE_SHOULDER = 3,
		INVTYPE_BODY = 4,
		INVTYPE_CHEST = 5,
		INVTYPE_WAIST = 6,
		INVTYPE_LEGS = 7,
		INVTYPE_FEET = 8,
		INVTYPE_WRIST = 9,
		INVTYPE_HAND = 10,
		INVTYPE_FINGER = 11,
		INVTYPE_TRINKET = 12,
		INVTYPE_WEAPON = 13,
		INVTYPE_SHIELD = 14,
		INVTYPE_RANGEDRIGHT = 15,
		INVTYPE_CLOAK = 16,
		INVTYPE_2HWEAPON = 17,
		INVTYPE_BAG = 18,
		INVTYPE_TABARD = 19,
		INVTYPE_ROBE = 20,
		INVTYPE_WEAPONMAINHAND = 21,
		INVTYPE_WEAPONOFFHAND = 22,
		INVTYPE_HOLDABLE = 23,
		INVTYPE_AMMO = 24,
		INVTYPE_THROWN = 25,
		INVTYPE_RANGED = 26,
	},
	-- EquipDecode = <add a reverse lookup table here if we need it>

	--EquipLocToInvIndex = {}, -- converts "INVTYPE_*" strings to invTypeIndex for scan queries - only valid for Armour types
	--EquipCodeToInvIndex = {}, -- as above, but converts the EquipEncode'd number to invTypeIndex
	-- InvIndexToEquipLoc = <add a reverse lookup table here if we need it>

	LINK = 1,
	ILEVEL = 2,
	ITYPE = 3, -- deprecated
	CLASSID = 3,
	ISUB = 4, -- deprecated
	SUBCLASSID = 4,
	IEQUIP = 5,
	PRICE = 6,
	TLEFT = 7,
	TIME = 8,
	NAME = 9,
	DEP2 = 10,
	COUNT = 11,
	QUALITY = 12,
	CANUSE = 13,
	ULEVEL = 14,
	MINBID = 15,
	MININC = 16,
	BUYOUT = 17,
	CURBID = 18,
	AMHIGH = 19,
	SELLER = 20,
	FLAG = 21,
	BONUSES = 22,
	ITEMID = 23,
	SUFFIX = 24,
	FACTOR = 25,
	ENCHANT = 26,
	SEED = 27,
	LASTENTRY = 27, -- Used to determine how many entries the table has when copying (some entries can be nil so # won't work)

	ScanPosLabels = {"LINK", "ILEVEL", "CLASSID", "SUBCLASSID", "IEQUIP", "PRICE", "TLEFT", "TIME", "NAME", "DEP2", "COUNT", "QUALITY", "CANUSE", "ULEVEL", "MINBID", "MININC",
		"BUYOUT", "CURBID", "AMHIGH", "SELLER", "FLAG", "BONUSES", "ITEMID", "SUFFIX", "FACTOR", "ENCHANT", "SEED" },

	-- Permanent flags (stored in save file)
	FLAG_UNSEEN = 2,
	FLAG_FILTER = 4,
	-- Temporary flags (only used during processing - higher values to leave lower ones free for permanent flags)
	FLAG_DIRTY = 64,
	FLAG_EXPIRED = 128,

	ALEVEL_OFF = 0,
	ALEVEL_MIN = 1,
	ALEVEL_LOW = 2,
	ALEVEL_MED = 3,
	ALEVEL_HI = 4,
	ALEVEL_MAX = 5,

	MAXSKILLLEVEL = 800,
	MAXUSERLEVEL = 120,
	MAXITEMLEVEL = 1100,
	MAXBIDPRICE = 99999999999, -- copy from Blizzard_AuctionUI.lua, so it is available before AH loads
}

if AucAdvanced.Classic then
	lib.MAXSKILLLEVEL = 300
	lib.MAXUSERLEVEL = 60
	lib.MAXITEMLEVEL = 92

    -- times are in seconds
	lib.AucMinTimes = {
		0,
		1800, -- 30 mins
		7200, -- 2 hours
		43200, -- 8 hours
	}
	lib.AucMaxTimes = {
		1800,  -- 30 mins
		7200,  -- 2 hours
		28800, -- 8 hours
		86400  -- 24 hours
	}
	lib.AucTimes = {
		0,
		1800, -- 30 mins
		7200, -- 2 hours
		28800, -- 8 hours
		86400  -- 24 hours
	}

end

AucAdvanced.Const = lib

lib.CompactRealm = lib.PlayerRealm:gsub("[ %-]", "") -- CompactRealm is realm name with spaces and dashes removed

-- *** AuctionCategory tables (AC_*) ***
-- Indexed list of class IDs
-- CoreScan records item class in the form of these IDs in ScanData

if AucAdvanced.Classic then
	lib.AC_ClassIDList = {
		LE_ITEM_CLASS_WEAPON,
		LE_ITEM_CLASS_ARMOR,
		LE_ITEM_CLASS_CONTAINER,
		LE_ITEM_CLASS_GEM,
		LE_ITEM_CLASS_ITEM_ENHANCEMENT,
		LE_ITEM_CLASS_CONSUMABLE,
		-- LE_ITEM_CLASS_GLYPH, Does not exist in Classic
		LE_ITEM_CLASS_TRADEGOODS,
		LE_ITEM_CLASS_RECIPE,
		-- LE_ITEM_CLASS_BATTLEPET, Does not exist in Classic
		LE_ITEM_CLASS_QUESTITEM,
		LE_ITEM_CLASS_MISCELLANEOUS,
	}
else
	lib.AC_ClassIDList = {
		LE_ITEM_CLASS_WEAPON,
		LE_ITEM_CLASS_ARMOR,
		LE_ITEM_CLASS_CONTAINER,
		LE_ITEM_CLASS_GEM,
		LE_ITEM_CLASS_ITEM_ENHANCEMENT,
		LE_ITEM_CLASS_CONSUMABLE,
		LE_ITEM_CLASS_GLYPH,
		LE_ITEM_CLASS_TRADEGOODS,
		LE_ITEM_CLASS_RECIPE,
		LE_ITEM_CLASS_BATTLEPET,
		LE_ITEM_CLASS_QUESTITEM,
		LE_ITEM_CLASS_MISCELLANEOUS,
	}
end

-- Indexed list of class names, indexes will match AC_ClassIDList
-- names should match the (localized string) return values from GetItemInfo
-- *not* the same as Category names (i.e. AUCTION_CATEGORY_*)
lib.AC_ClassNameList = {}
-- Table of lists of subClassIDs, referenced by classID
-- May not always be the the same order as Blizzard's subClassIndex values
lib.AC_SubClassIDLists = {}
-- Table of lists of subclass names, in the same order as AC_SubClassIDLists, also referenced by classID
lib.AC_SubClassNameLists = {}
-- Build the class and subclass tables:
for index, classID in ipairs(lib.AC_ClassIDList) do
	lib.AC_ClassNameList[index] = GetItemClassInfo(classID)
	local subClassIDs, subClassNames = {GetAuctionItemSubClasses(classID)}, {}
	lib.AC_SubClassIDLists[classID] = subClassIDs
	lib.AC_SubClassNameLists[classID] = subClassNames
	for subindex, subClassID in ipairs(subClassIDs) do
		subClassNames[subindex] = GetItemSubClassInfo(classID, subClassID)
	end
end
-- List of Inventory Type IDs, only used for Armour category
-- Each armour subcategory only uses a subset of this list of invtypes (and some have no invtypes at all)
-- Therefore indexes of this list are not the same as Blizzard's subSubIndex values
lib.AC_InvTypeIDList = {
	-- Cloth/Leather/Mail/Plate InvTypes:
	LE_INVENTORY_TYPE_HEAD_TYPE, -- also Generic
	LE_INVENTORY_TYPE_SHOULDER_TYPE,
	LE_INVENTORY_TYPE_CHEST_TYPE,
	LE_INVENTORY_TYPE_WAIST_TYPE,
	LE_INVENTORY_TYPE_LEGS_TYPE,
	LE_INVENTORY_TYPE_FEET_TYPE,
	LE_INVENTORY_TYPE_WRIST_TYPE,
	LE_INVENTORY_TYPE_HAND_TYPE,
	-- Generic InvTypes:
	LE_INVENTORY_TYPE_NECK_TYPE,
	LE_INVENTORY_TYPE_CLOAK_TYPE, -- Actually typed as Cloth in Blizzard data
	LE_INVENTORY_TYPE_FINGER_TYPE,
	LE_INVENTORY_TYPE_TRINKET_TYPE,
	LE_INVENTORY_TYPE_HOLDABLE_TYPE,
	-- Shield has no InvType
	LE_INVENTORY_TYPE_BODY_TYPE,
	-- Head is listed again as a Generic type in Blizzard data
	-- Cosmetic has no InvTypes
}
-- List of Inventory Type names, in the same order as the IDs in AC_InvTypeIDList
lib.AC_InvTypeNameList = {}
for index, invtypeID in ipairs(lib.AC_InvTypeIDList) do
	lib.AC_InvTypeNameList[index] = GetItemInventorySlotInfo(invtypeID)
end
-- Map equipment locations (INVTYPE_*) to inventory type IDs
-- Only valid for Armour types for which an ID code LE_INVENTORY_TYPE_*_TYPE exists
lib.AC_EquipLoc2InvTypeID = {
	INVTYPE_HEAD = LE_INVENTORY_TYPE_HEAD_TYPE,
	INVTYPE_NECK = LE_INVENTORY_TYPE_NECK_TYPE,
	INVTYPE_SHOULDER = LE_INVENTORY_TYPE_SHOULDER_TYPE,
	INVTYPE_BODY = LE_INVENTORY_TYPE_BODY_TYPE,
	INVTYPE_CHEST = LE_INVENTORY_TYPE_CHEST_TYPE,
	INVTYPE_WAIST = LE_INVENTORY_TYPE_WAIST_TYPE,
	INVTYPE_LEGS = LE_INVENTORY_TYPE_LEGS_TYPE,
	INVTYPE_FEET = LE_INVENTORY_TYPE_FEET_TYPE,
	INVTYPE_WRIST = LE_INVENTORY_TYPE_WRIST_TYPE,
	INVTYPE_HAND = LE_INVENTORY_TYPE_HAND_TYPE,
	INVTYPE_FINGER = LE_INVENTORY_TYPE_FINGER_TYPE,
	INVTYPE_TRINKET = LE_INVENTORY_TYPE_TRINKET_TYPE,
	INVTYPE_CLOAK = LE_INVENTORY_TYPE_CLOAK_TYPE,
	INVTYPE_HOLDABLE = LE_INVENTORY_TYPE_HOLDABLE_TYPE,
}
-- Map Auctioneer equipment codes (as stored in scandata) to inventory type IDs
lib.AC_EquipCode2InvTypeID = {}
for equiploc, invtypeID in pairs(lib.AC_EquipLoc2InvTypeID) do
	lib.AC_EquipCode2InvTypeID[lib.EquipEncode[equiploc]] = invtypeID
end

-- Special Case for battlepets: convert the petType return from C_PetJournal.GetPetInfoBySpeciesID into a subClassID
-- ### todo: keep checking this conversion is correct, otherwise will have to hard-code lookup table
lib.AC_PetType2SubClassID = {GetAuctionItemSubClasses(LE_ITEM_CLASS_BATTLEPET)}

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/CoreConst.lua $", "$Rev: 6430 $")
AucAdvanced.CoreFileCheckOut("CoreConst")
