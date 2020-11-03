-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local VendorTrade = TSM.Init("Data.VendorTrade")
local private = {}



-- ============================================================================
-- Vendor Trade Data
-- ============================================================================

local DATA = TSM.IsWowClassic() and {} or {
	["i:37101"] = {
		["i:173058"] = 1, -- Ivory Ink
	},
	["i:39469"] = {
		["i:173058"] = 1, -- Moonglow Ink
	},
	["i:39774"] = {
		["i:173058"] = 1, -- Midnight Ink
	},
	["i:43116"] = {
		["i:173058"] = 1, -- Lion's Ink
	},
	["i:43118"] = {
		["i:173058"] = 1, -- Jadefire Ink
	},
	["i:43120"] = {
		["i:173058"] = 1, -- Celestial Ink
	},
	["i:43122"] = {
		["i:173058"] = 1, -- Shimmering Ink
	},
	["i:43124"] = {
		["i:173058"] = 1, -- Ethereal Ink
	},
	["i:43126"] = {
		["i:173058"] = 1, -- Ink of the Sea
	},
	["i:43127"] = {
		["i:173058"] = 0.1, -- Snowfall Ink
	},
	["i:61978"] = {
		["i:173058"] = 1, -- Blackfallow Ink
	},
	["i:61981"] = {
		["i:173058"] = 0.1, -- Inferno Ink
	},
	["i:79254"] = {
		["i:173058"] = 1, -- Ink of Dreams
	},
	["i:79255"] = {
		["i:173058"] = 0.1, -- Starlight Ink
	},
	["i:113111"] = {
		["i:173058"] = 1, -- Warbinder's Ink
	},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function VendorTrade.TargetItemIterator()
	return private.TableKeyIterator, DATA, nil
end

function VendorTrade.SourceItemIterator(targetItemString)
	return private.TableKeyIterator, DATA[targetItemString], nil
end

function VendorTrade.GetRate(targetItemString, sourceItemString)
	return DATA[targetItemString][sourceItemString]
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.TableKeyIterator(tbl, index)
	index = next(tbl, index)
	return index
end
