--[[
	Auctioneer - Search UI - Searcher EnchantMats
	Version: 8.2.6415 (SwimmingSeadragon)
	Revision: $Id: SearcherEnchantMats.lua 6415 2019-09-13 05:07:31Z none $
	URL: http://auctioneeraddon.com/

	This is a plugin module for the SearchUI that assists in searching by refined paramaters

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

-- check prerequisites
if not AucAdvanced then return end
if not AucSearchUI then return end


-- Create a new instance of our lib with our parent
local lib, parent, private = AucSearchUI.NewSearcher("EnchantMats")
if not lib then return end
--local print,decode,_,_,replicate,empty,_,_,_,debugPrint,fill = AucAdvanced.GetModuleLocals()
local get, set ,default ,Const, resources = parent.GetSearchLocals()
lib.tabname = "EnchantMats"


-- need to know early if we're using Classic or Modern version
local MINIMUM_CLASSIC = 11300
local MAXIMUM_CLASSIC = 19999
-- version, build, date, tocversion = GetBuildInfo()
local _,_,_,tocVersion = GetBuildInfo()
local isClassic = (tocVersion > MINIMUM_CLASSIC and tocVersion < MAXIMUM_CLASSIC)


-- Enchanting reagents, from Enchantrix EnxConstants.lua
local VOID = 22450
local NEXUS = 20725
local LPRISMATIC = 22449
local LBRILLIANT = 14344
local LRADIANT = 11178
local LGLOWING = 11139
local LGLIMMERING = 11084
local SPRISMATIC = 22448
local SBRILLIANT = 14343
local SRADIANT = 11177
local SGLOWING = 11138
local SGLIMMERING = 10978
local GPLANAR = 22446
local GETERNAL = 16203
local GNETHER = 11175
local GMYSTIC = 11135
local GASTRAL = 11082
local GMAGIC = 10939
local LPLANAR = 22447
local LETERNAL = 16202
local LNETHER = 11174
local LMYSTIC = 11134
local LASTRAL = 10998
local LMAGIC = 10938
local ARCANE = 22445
local ILLUSION = 16204
local DREAM = 11176
local VISION = 11137
local SOUL = 11083
local STRANGE = 10940

local RILLUSION = 156930

local DREAM_SHARD = 34052
local SDREAM_SHARD = 34053
local INFINITE = 34054
local GCOSMIC = 34055
local LCOSMIC = 34056
local ABYSS = 34057

local HEAVENLY_SHARD = 52721
local SHEAVENLY_SHARD = 52720
local HYPNOTIC = 52555
local GCELESTIAL = 52719
local LCELESTIAL = 52718
local MAELSTROM = 52722

local SHA_CRYSTAL = 74248
local SHA_CRYSTAL_FRAGMENT = 105718
local ETHERAL = 74247
local SETHERAL = 74252
local SPIRIT = 74249
local MYSTERIOUS = 74250

local DRAENIC = 109693
local SLUMINOUS = 115502
local LUMINOUS = 111245
local TEMPORAL = 113588
local FRACTEMPORAL = 115504

local ARKHANA	= 124440
local LEYLIGHT_SHARD = 124441
local CHAOS_CRYSTAL = 124442

local GLOOMDUST = 152875
local UMBRASHARD = 152876
local VEILEDCRYSTAL = 152877


-- a table we can check for item ids
local validReagents =
	{
	[VOID] = true,
	[NEXUS] = true,
	[LPRISMATIC] = true,
	[LBRILLIANT] = true,
	[LRADIANT] = true,
	[LGLOWING] = true,
	[LGLIMMERING] = true,
	[SPRISMATIC] = true,
	[SBRILLIANT] = true,
	[SRADIANT] = true,
	[SGLOWING] = true,
	[SGLIMMERING] = true,
	[GPLANAR] = true,
	[GETERNAL] = true,
	[GNETHER] = true,
	[GMYSTIC] = true,
	[GASTRAL] = true,
	[GMAGIC] = true,
	[LPLANAR] = true,
	[LETERNAL] = true,
	[LNETHER] = true,
	[LMYSTIC] = true,
	[LASTRAL] = true,
	[LMAGIC] = true,
	[ARCANE] = true,
	[ILLUSION] = true,
	[DREAM] = true,
	[VISION] = true,
	[SOUL] = true,
	[STRANGE] = true,
	[DREAM_SHARD] = true,
	[SDREAM_SHARD] = true,
	[INFINITE] = true,
	[GCOSMIC] = true,
	[LCOSMIC] = true,
	[ABYSS] = true,

    [RILLUSION] = true,

	[MAELSTROM] = true,
	[HEAVENLY_SHARD] = true,
	[SHEAVENLY_SHARD] = true,
	[GCELESTIAL] = true,
	[LCELESTIAL] = true,
	[HYPNOTIC] = true,

	[SHA_CRYSTAL] = true,
	[SHA_CRYSTAL_FRAGMENT] = true,
	[ETHERAL] = true,
	[SETHERAL] = true,
	[SPIRIT] = true,
	[MYSTERIOUS] = true,

	[FRACTEMPORAL] = true,
	[TEMPORAL] = true,
	[LUMINOUS] = true,
	[SLUMINOUS] = true,
	[DRAENIC] = true,

	[ARKHANA] = true,
	[LEYLIGHT_SHARD] = true,
	[CHAOS_CRYSTAL] = true,

	[GLOOMDUST] = true,
	[UMBRASHARD] = true,
	[VEILEDCRYSTAL] = true,

	}

-- Set our defaults
default("enchantmats.level.custom", false)
default("enchantmats.level.min", 0)
default("enchantmats.level.max", Const.MAXSKILLLEVEL)
default("enchantmats.allow.bid", true)
default("enchantmats.allow.buy", true)
default("enchantmats.maxprice", 10000000)
default("enchantmats.maxprice.enable", false)
default("enchantmats.model", "Enchantrix")

--Slider variables
if (isClassic) then
    -- Classic materials
    default("enchantmats.PriceAdjust."..GETERNAL, 100)
    default("enchantmats.PriceAdjust."..GNETHER, 100)
    default("enchantmats.PriceAdjust."..GMYSTIC, 100)
    default("enchantmats.PriceAdjust."..GASTRAL, 100)
    default("enchantmats.PriceAdjust."..GMAGIC, 100)

    default("enchantmats.PriceAdjust."..LETERNAL, 100)
    default("enchantmats.PriceAdjust."..LNETHER, 100)
    default("enchantmats.PriceAdjust."..LMYSTIC, 100)
    default("enchantmats.PriceAdjust."..LASTRAL, 100)
    default("enchantmats.PriceAdjust."..LMAGIC, 100)

    default("enchantmats.PriceAdjust."..ILLUSION, 100)
    default("enchantmats.PriceAdjust."..DREAM, 100)
    default("enchantmats.PriceAdjust."..VISION, 100)
    default("enchantmats.PriceAdjust."..SOUL, 100)
    default("enchantmats.PriceAdjust."..STRANGE, 100)

    default("enchantmats.PriceAdjust."..LBRILLIANT, 100)
    default("enchantmats.PriceAdjust."..LRADIANT, 100)
    default("enchantmats.PriceAdjust."..LGLOWING, 100)
    default("enchantmats.PriceAdjust."..LGLIMMERING, 100)

    default("enchantmats.PriceAdjust."..SBRILLIANT, 100)
    default("enchantmats.PriceAdjust."..SRADIANT, 100)
    default("enchantmats.PriceAdjust."..SGLOWING, 100)
    default("enchantmats.PriceAdjust."..SGLIMMERING, 100)
    default("enchantmats.PriceAdjust."..NEXUS, 100)

else
    -- current Wow release
    default("enchantmats.PriceAdjust."..GPLANAR, 100)
    default("enchantmats.PriceAdjust."..GETERNAL, 100)
    default("enchantmats.PriceAdjust."..GMAGIC, 100)
    default("enchantmats.PriceAdjust."..LPLANAR, 100)
    default("enchantmats.PriceAdjust."..LETERNAL, 100)
    default("enchantmats.PriceAdjust."..LMAGIC, 100)

    default("enchantmats.PriceAdjust."..ARCANE, 100)
    default("enchantmats.PriceAdjust."..ILLUSION, 100)
    default("enchantmats.PriceAdjust."..RILLUSION, 100)
    default("enchantmats.PriceAdjust."..STRANGE, 100)
    default("enchantmats.PriceAdjust."..LPRISMATIC, 100)
    default("enchantmats.PriceAdjust."..LBRILLIANT, 100)
    default("enchantmats.PriceAdjust."..SPRISMATIC, 100)
    default("enchantmats.PriceAdjust."..SBRILLIANT, 100)
    default("enchantmats.PriceAdjust."..VOID, 100)
    default("enchantmats.PriceAdjust."..NEXUS, 100)

    default("enchantmats.PriceAdjust."..DREAM_SHARD, 100)
    default("enchantmats.PriceAdjust."..SDREAM_SHARD, 100)
    default("enchantmats.PriceAdjust."..INFINITE, 100)
    default("enchantmats.PriceAdjust."..GCOSMIC, 100)
    default("enchantmats.PriceAdjust."..LCOSMIC, 100)
    default("enchantmats.PriceAdjust."..ABYSS, 100)

    default("enchantmats.PriceAdjust."..HEAVENLY_SHARD, 100)
    default("enchantmats.PriceAdjust."..SHEAVENLY_SHARD, 100)
    default("enchantmats.PriceAdjust."..HYPNOTIC, 100)
    default("enchantmats.PriceAdjust."..GCELESTIAL, 100)
    default("enchantmats.PriceAdjust."..LCELESTIAL, 100)
    default("enchantmats.PriceAdjust."..MAELSTROM, 100)

    default("enchantmats.PriceAdjust."..SPIRIT, 100)
    default("enchantmats.PriceAdjust."..MYSTERIOUS, 100)
    default("enchantmats.PriceAdjust."..SETHERAL, 100)
    default("enchantmats.PriceAdjust."..ETHERAL, 100)
    default("enchantmats.PriceAdjust."..SHA_CRYSTAL, 100)
    default("enchantmats.PriceAdjust."..SHA_CRYSTAL_FRAGMENT, 100)

    default("enchantmats.PriceAdjust."..DRAENIC, 100)
    default("enchantmats.PriceAdjust."..SLUMINOUS, 100)
    default("enchantmats.PriceAdjust."..LUMINOUS, 100)
    default("enchantmats.PriceAdjust."..TEMPORAL, 100)
    default("enchantmats.PriceAdjust."..FRACTEMPORAL, 100)

    default("enchantmats.PriceAdjust."..ARKHANA, 100)
    default("enchantmats.PriceAdjust."..LEYLIGHT_SHARD, 100)
    default("enchantmats.PriceAdjust."..CHAOS_CRYSTAL, 100)

    default("enchantmats.PriceAdjust."..GLOOMDUST, 100)
    default("enchantmats.PriceAdjust."..UMBRASHARD, 100)
    default("enchantmats.PriceAdjust."..VEILEDCRYSTAL, 100)
end


function private.doValidation()
	if not resources.isEnchantrixLoaded then
		message("EnchantMats Searcher Warning!\nEnchantrix not detected\nThis searcher will not function until Enchantrix is loaded")
	elseif not resources.isValidPriceModel(get("enchantmats.model")) then
		message("EnchantMats Searcher Warning!\nCurrent price model setting ("..get("enchantmats.model")..") is not valid. Select a new price model")
	else
		private.doValidation = nil
	end
end

-- This function is automatically called from AucSearchUI.NotifyCallbacks
function lib.Processor(event, subevent)
	if event == "selecttab" then
		if subevent == lib.tabname and private.doValidation then
			private.doValidation()
		end
	end
end


function AddClassicGuiItems( gui, id )
    -- Classic materials
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..GETERNAL, 0, 200, 1, "Greater Eternal Essence %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..GNETHER, 0, 200, 1, "Greater Nether Essence %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..GMYSTIC, 0, 200, 1, "Greater Mystic Essence %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..GASTRAL, 0, 200, 1, "Greater Astral Essence %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..GMAGIC, 0, 200, 1, "Greater Magic Essence %s%%")

    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LETERNAL, 0, 200, 1, "Lesser Eternal Essence %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LNETHER, 0, 200, 1, "Lesser Nether Essence %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LMYSTIC, 0, 200, 1, "Lesser Mystic Essence %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LASTRAL, 0, 200, 1, "Lesser Astral Essence %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LMAGIC, 0, 200, 1, "Lesser Magic Essence %s%%")

    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..ILLUSION, 0, 200, 1, "Illusion Dust %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..DREAM, 0, 200, 1, "Dream Dust %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..VISION, 0, 200, 1, "Vision Dust %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SOUL, 0, 200, 1, "Soul Dust %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..STRANGE, 0, 200, 1, "Strange Dust %s%%")

    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LBRILLIANT, 0, 200, 1, "Large Brilliant Shard %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LRADIANT, 0, 200, 1, "Large Radiant Shard %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LGLOWING, 0, 200, 1, "Large Glowing Shard %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LGLIMMERING, 0, 200, 1, "Large Glimmering Shard %s%%")

    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SBRILLIANT, 0, 200, 1, "Small Brilliant Shard %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SRADIANT, 0, 200, 1, "Small Radiant Shard %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SGLOWING, 0, 200, 1, "Small Glowing Shard %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SGLIMMERING, 0, 200, 1, "Small Glimmering Shard %s%%")

    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..NEXUS, 0, 200, 1, "Nexus Crystal %s%%")
end


function AddCurrentGuiItems( gui, id )
    -- current Wow release
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..MYSTERIOUS, 0, 200, 1, "Mysterious Essence %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..GCELESTIAL, 0, 200, 1, "Greater Celestial Essence %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..GCOSMIC, 0, 200, 1, "Greater Cosmic Essence %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..GPLANAR, 0, 200, 1, "Greater Planar Essence %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..GETERNAL, 0, 200, 1, "Greater Eternal Essence %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..GMAGIC, 0, 200, 1, "Greater Magic Essence %s%%")

    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LCELESTIAL, 0, 200, 1, "Lesser Celestial Essence %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LCOSMIC, 0, 200, 1, "Lesser Cosmic Essence %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LPLANAR, 0, 200, 1, "Lesser Planar Essence %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LETERNAL, 0, 200, 1, "Lesser Eternal Essence %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LMAGIC, 0, 200, 1, "Lesser Magic Essence %s%%")

    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..GLOOMDUST, 0, 200, 1, "Gloom Dust %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..ARKHANA, 0, 200, 1, "Arkhana %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..DRAENIC, 0, 200, 1, "Draenic Dust %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SPIRIT, 0, 200, 1, "Spirit Dust %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..HYPNOTIC, 0, 200, 1, "Hypnotic Dust %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..INFINITE, 0, 200, 1, "Infinite Dust %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..ARCANE, 0, 200, 1, "Arcane Dust %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..RILLUSION, 0, 200, 1, "Rich Illusion Dust %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..ILLUSION, 0, 200, 1, "Light Illusion Dust %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..STRANGE, 0, 200, 1, "Strange Dust %s%%")

    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..UMBRASHARD, 0, 200, 1, "Umbra Shard %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LEYLIGHT_SHARD, 0, 200, 1, "Leylight Shard %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LUMINOUS, 0, 200, 1, "Luminous Shard %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..ETHERAL, 0, 200, 1, "Ethereal Shard %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..HEAVENLY_SHARD, 0, 200, 1, "Heavenly Shard %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..DREAM_SHARD, 0, 200, 1, "Dream Shard %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LPRISMATIC, 0, 200, 1, "Large Prismatic Shard %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..LBRILLIANT, 0, 200, 1, "Large Brilliant Shard %s%%")

    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SLUMINOUS, 0, 200, 1, "Small Luminous Shard %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SETHERAL, 0, 200, 1, "Small Ethereal Shard %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SHEAVENLY_SHARD, 0, 200, 1, "Small Heavenly Shard %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SDREAM_SHARD, 0, 200, 1, "Small Dream Shard %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SPRISMATIC, 0, 200, 1, "Small Prismatic Shard %s%%")
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SBRILLIANT, 0, 200, 1, "Small Brilliant Shard %s%%")

    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..VEILEDCRYSTAL, 0, 200, 1, "Veiled Crystal %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..CHAOS_CRYSTAL, 0, 200, 1, "Chaos Crystal %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..TEMPORAL, 0, 200, 1, "Temporal Crystal %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..FRACTEMPORAL, 0, 200, 1, "Fractured Temporal Crystal %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SHA_CRYSTAL, 0, 200, 1, "Sha Crystal %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..SHA_CRYSTAL_FRAGMENT, 0, 200, 1, "Sha Crystal Fragment %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..MAELSTROM, 0, 200, 1, "Maelstrom Crystal %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..ABYSS, 0, 200, 1, "Abyss Crystal %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..VOID, 0, 200, 1, "Void Crystal %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "enchantmats.PriceAdjust."..NEXUS, 0, 200, 1, "Nexus Crystal %s%%" )
end


-- This function is automatically called when we need to create our search parameters
function lib:MakeGuiConfig(gui)
	-- Get our tab and populate it with our controls
	local id = gui:AddTab(lib.tabname, "Searchers")
	gui:MakeScrollable(id)

	-- Add the help
	gui:AddSearcher("Enchant Mats", "Search for items which will disenchant for you into given reagents (for levelling)", 100)
	gui:AddHelp(id, "enchantmats searcher",
		"What does this searcher do?",
		"This searcher provides the ability to search for items which will disenchant into the reagents you need to have in order to level your enchanting skill. It is not a searcher meant for profit, but rather least cost for levelling.")

	gui:AddControl(id, "Header",     0,      "EnchantMats search criteria")

	local last = gui:GetLast(id)

	gui:AddControl(id, "Checkbox",          0.42, 1, "enchantmats.allow.bid", "Allow Bids")
	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",          0.56, 1, "enchantmats.allow.buy", "Allow Buyouts")
	gui:AddControl(id, "Checkbox",          0.42, 1, "enchantmats.maxprice.enable", "Enable individual maximum price:")
	gui:AddTip(id, "Limit the maximum amount you want to spend with the EnchantMats searcher")
	gui:AddControl(id, "MoneyFramePinned",  0.42, 2, "enchantmats.maxprice", 1, Const.MAXBIDPRICE, "Maximum Price for EnchantMats")

	gui:AddControl(id, "Label",             0.42, 1, nil, "Price Valuation Method:")
	gui:AddControl(id, "Selectbox",         0.42, 1, resources.selectorPriceModelsEnx, "enchantmats.model")
	gui:AddTip(id, "The pricing model that is used to work out the calculated value of items at the Auction House.")

	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",          0, 1, "enchantmats.level.custom", "Use custom enchanting skill levels")
	gui:AddControl(id, "Slider",            0, 2, "enchantmats.level.min", 0, Const.MAXSKILLLEVEL, 25, "Minimum skill: %s")
	gui:AddControl(id, "Slider",            0, 2, "enchantmats.level.max", 25, Const.MAXSKILLLEVEL, 25, "Maximum skill: %s")

	-- spacer to allow for all the controls on the right hand side
	gui:AddControl(id, "Note",              0, 0, nil, 40, "")

	-- aka "what percentage of estimated value am I willing to pay for this reagent"?
	gui:AddControl(id, "Subhead",          0,    "Reageant Price Modification")


    -- work around 60 upvalue per function limits
    if isClassic then
        AddClassicGuiItems( gui, id )
    else
        AddCurrentGuiItems( gui, id )
    end

end

function lib.Search(item)
	-- Can't do anything without Enchantrix
	if not resources.isEnchantrixLoaded then
		return false, "Enchantrix not detected"
	end

	local itemID = item[Const.ITEMID]

	local bidprice, buyprice = item[Const.PRICE], item[Const.BUYOUT]
	local maxprice = get("enchantmats.maxprice.enable") and get("enchantmats.maxprice")
	if buyprice <= 0 or not get("enchantmats.allow.buy") or (maxprice and buyprice > maxprice) then
		buyprice = nil
	end
	if not get("enchantmats.allow.bid") or (maxprice and bidprice > maxprice) then
		bidprice = nil
	end
	if not (bidprice or buyprice) then
		return false, "Does not meet bid/buy requirements"
	end

	local market
	if validReagents[itemID] then
		-- item itself is a reagent; just use item's value
		market = resources.GetPrice(get("enchantmats.model"), itemID)
		if not market then
			return false, "No price for item"
		end

		-- be safe and handle nil results
		local adjustment = get("enchantmats.PriceAdjust."..itemID) or 0
		market = (market * item[Const.COUNT]) * adjustment / 100
	else -- it's not a reagent, figure out what it DEs into
		local itemQuality = item[Const.QUALITY]
		-- All disenchantable items are "uncommon" quality or higher
		-- so bail on items that are white or gray
		if itemQuality <= 1 then
			return false, "Item quality too low"
		end

		local minskill, maxskill
		if get("enchantmats.level.custom") then
			minskill = get("enchantmats.level.min")
			maxskill = get("enchantmats.level.max")
		else
			minskill = 0
			maxskill = Enchantrix.Util.GetUserEnchantingSkill()
		end

		local skillneeded = Enchantrix.Util.DisenchantSkillRequiredForItemLevel(item[Const.ILEVEL], itemQuality)
		if (skillneeded < minskill) or (skillneeded > maxskill) then
			return false, "Skill not high enough to Disenchant"
		end

		local data = Enchantrix.Storage.GetItemDisenchants(item[Const.LINK])
		if not data then -- Give up if it doesn't disenchant to anything
			return false, "Item not Disenchantable"
		end

		local total = data.total

		if total and total[1] > 0 then
			market = 0
			local totalNumber, totalQuantity = unpack(total)
			local model = get("enchantmats.model")
			local GetPrice = resources.lookupPriceModel[model]
			for result, resData in pairs(data) do
				if result ~= "total" then
					local resNumber, resQuantity = unpack(resData)
					local price = GetPrice(model, result)
					price = (price or 0) * resQuantity / totalNumber

					-- be safe and handle nil results
					local adjustment = get("enchantmats.PriceAdjust."..result) or 0
					market = market + price * adjustment / 100
				end
			end
		end

	end
	if not market or market <= 0 then
		return false, "No Price Found"
	end

	if buyprice and buyprice <= market then
		return "buy", market
	elseif bidprice and bidprice <= market then
		return "bid", market
	end
	return false, "Not enough profit"
end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-SearchUI/SearcherEnchantMats.lua $", "$Rev: 6415 $")
