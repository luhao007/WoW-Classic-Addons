--[[
	Auctioneer - FlatOutlier Filter
	Version: 8.2.6394 (SwimmingSeadragon)
	Revision: $Id: FlatOutlier.lua 6394 2019-09-22 00:20:05Z none $
	URL: http://auctioneeraddon.com/

	This is scaning filter plugin for Auctioneer.
	It attempts to detect unreasonably overpriced items, and to prevent them from affecting your Stats.
	It allows you to select different prices models to use as a baseline, when deciding what counts as overpriced.

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

local libType, libName = "Filter", "FlatOutlier"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local aucPrint,_,_,_,_,_,get,set,default,debugPrint,_,L = AucAdvanced.GetModuleLocals()

local MIN_PRICE = 10000 -- (1g) calculated prices below this level are disregarded

-- upvalue caches for settings, to reduce calls to 'get'
local needSettingsReset = true
local active, model1, model2, minseen, levels
function private.resetSettings() -- called when needSettingsReset == true
	needSettingsReset = false

	active = get("filter.flatoutlier.activated")
	if not active then
		return
	end

	model1 = get("filter.flatoutlier.model1")
	if model1 ~= "market" and model1 ~= "none" and not AucAdvanced.API.IsValidAlgorithm(model1) then
		model1 = "none"
	end
	model2 = get("filter.flatoutlier.model2")
	if model2 ~= "market" and model2 ~= "none" and not AucAdvanced.API.IsValidAlgorithm(model2) then
		model2 = "none"
	end
	if model2 == model1 then
		if model1 == "none" then
			-- no valid pricing models selected - filter is 'active' but effectively disabled
			-- deactivate filter, and return a warning value
			active = false
			return "No valid price model selected"
		end
		-- avoid duplicating calculations when models are the same
		model2 = "none"
	end

	minseen = get("filter.flatoutlier.minseen")
	levels = {}
	if get("filter.flatoutlier.poor_enabled") then levels[0] = get("filter.flatoutlier.poor_level")/100 end
	if get("filter.flatoutlier.common_enabled") then levels[1] = get("filter.flatoutlier.common_level")/100 end
	if get("filter.flatoutlier.uncommon_enabled") then levels[2] = get("filter.flatoutlier.uncommon_level")/100 end
	if get("filter.flatoutlier.rare_enabled") then levels[3] = get("filter.flatoutlier.rare_level")/100 end
	if get("filter.flatoutlier.epic_enabled") then levels[4] = get("filter.flatoutlier.epic_level")/100 end

	if not next(levels) then
		-- empty table - all quality levels disabled
		-- deactivate filter, and return warning value
		active = false
		return "All quality levels are disabled"
	end
end

lib.Processors = {
	config = function(callbackType, ...)
		if private.SetupConfigGui then private.SetupConfigGui(...) end
	end,

	newmodule = function()
		private.resetPriceModels()
	end,

	auctionopen = function()
		-- warn user if filter has been *implicitly* disabled by the combination of settings (but not if explicitly disabled) when AuctionHouse opened
		if needSettingsReset then
			local text = private.resetSettings()
			if text then
				aucPrint(format("Auctioneer %s %s has been disabled by settings: %s", libType, libName, text))
			end
		end
	end,

	-- auctionclose = function()
	-- end,

	scanstats = function()
		needSettingsReset = true
	end,
}
lib.Processors.configchanged = lib.Processors.scanstats

function lib.AuctionFilter(operation, itemData)
	local value, value2, seen

	if needSettingsReset then
		private.resetSettings()
	end
	if not active then return false end

	local level = levels[itemData.quality]
	if not level then return false end

	local link = itemData.link

	if model1 == "market" then
		value, seen = AucAdvanced.API.GetMarketValue(link)
	elseif model1 ~= "none" then
		value, seen = AucAdvanced.API.GetAlgorithmValue(model1, link)
	end
	-- if we have a value, check it is greater than or equal to the disregard limit
	-- check seen count is greater than or equal to the min seen setting
	-- special cases: seen == 0, seen == nil are flag values which we shall accept regardless of minseen
	if value and (value < MIN_PRICE or (seen and seen ~= 0 and seen < minseen)) then
		value = nil
	end

	if model2 == "market" then
		value2, seen = AucAdvanced.API.GetMarketValue(link)
	elseif model2 ~= "none" then
		value2, seen = AucAdvanced.API.GetAlgorithmValue(model2, link)
	end
	if value2 and (value2 < MIN_PRICE or (seen and seen ~= 0 and seen < minseen)) then
		value2 = nil
	end

	-- combine values: simple mode - use lowest value
	if value2 and (not value or value2 < value) then
		value = value2
	end

	-- If there's no value then we can't filter it
	if not value then return false end

	-- Check to see if the item price is below the calculated price
	local price = itemData.buyoutPrice
	if price == 0 then price = itemData.price end -- fall back to bid price if no buyout
	local maxcap = value * level
	local stack = itemData.stackSize
	if stack > 1 then price = price / stack end
	if price < maxcap then return false end

	-- Otherwise this item should be filtered
	return true
end

function lib.OnLoad(addon)
	default("filter.flatoutlier.activated", true)
	default("filter.flatoutlier.model1", "StdDev")
	default("filter.flatoutlier.model2", "none")
	default("filter.flatoutlier.minseen", 10)

	default("filter.flatoutlier.poor_enabled", true)
	default("filter.flatoutlier.common_enabled", true)
	default("filter.flatoutlier.uncommon_enabled", true)
	default("filter.flatoutlier.rare_enabled", true)
	default("filter.flatoutlier.epic_enabled", true)

	default("filter.flatoutlier.poor_level", 300)
	default("filter.flatoutlier.common_level", 300)
	default("filter.flatoutlier.uncommon_level", 300)
	default("filter.flatoutlier.rare_level", 300)
	default("filter.flatoutlier.epic_level", 300)
end

-- Create the list of Pricing Models for use in dropdowns
-- FlatOutlier uses a non-standard list; this code has been cloned from CoreUtil and modified
do
	local pricemodels
	function private.resetPriceModels()
		-- called every time a new module loads
		pricemodels = nil
	end
	function private.selectorPriceModels()
		if not pricemodels then
			-- delay creating table until function is first called, to give all modules a chance to load first
			pricemodels = {}
			tinsert(pricemodels, {"none", "None"})
			local algoList, algoNames = AucAdvanced.API.GetAlgorithms()
			for pos, name in ipairs(algoList) do
				tinsert(pricemodels,{name, format(L"ADV_Interface_Algorithm_Price", algoNames[pos])})--%s Price
			end
			-- Market Price is not recommended: we should still permit it, but put it last in the list
			tinsert(pricemodels,{"market", L"ADV_Interface_MarketPrice"})--Market Price
		end
		return pricemodels
	end
end

function private.SetupConfigGui(gui)
	private.SetupConfigGui = nil
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id = gui:AddTab(libName, libType.." Modules")

	gui:AddHelp(id, "what flatoutlier filter",
		"What is this FlatOutlier Filter?",
		"This filter detects auctions where the price exceeds a specified percentage of the normal value of the item, and prevents them from being recorded by the Stat modules")
	gui:AddHelp(id, "is outlier",
		"Is this another Outlier filter?",
		"This is a rewrite of the old version of Outlier. It is simpler, but has the option to select different price models to calculate the base price.")
	gui:AddHelp(id, "how to use",
		"How to use FlatOutlier",
		"For speed, it is recommended to select a simple, general price model such as Stat-StdDev or Stat-Simple.\nAvoid using Market or other complex price models.")
	gui:AddHelp(id, "second price model",
		"What does the second price model do?",
		"If a second price model is selected, FlatOutlier calculates the lower of the two prices.")


	gui:AddControl(id, "Header",     0,    "FlatOutlier Options")
	gui:AddControl(id, "Checkbox",   0, 1, "filter.flatoutlier.activated", "Enable use of the FlatOutlier filter")

	gui:AddControl(id, "Subhead",    0,    "Main price valuation method:")
	gui:AddControl(id, "Selectbox",  0, 1, private.selectorPriceModels, "filter.flatoutlier.model1" )
	gui:AddTip(id, "The main pricing model that will be used to calculate the base pricing level")

	gui:AddControl(id, "Subhead",    0,    "Second price valuation method:")
	gui:AddControl(id, "Selectbox",  0, 1, private.selectorPriceModels, "filter.flatoutlier.model2" )
	gui:AddTip(id, "A second pricing model that may optionally be used to calculate the base pricing level")

	gui:AddControl(id, "WideSlider", 0, 1, "filter.flatoutlier.minseen", 0, 100, 1, "Minimum seen: %d")
	gui:AddTip(id, "If an item has been seen less than this many times, it will not be filtered\nSet to 0 to check all items regardless of the seen count")

	gui:AddControl(id, "Subhead",    0,    "Settings per quality:")

	local enabletemplate = "Enable filtering |c%s%s|r quality items"
	local tooltiptemplate = "Ticking this box will enable filtering on %s quality items"
	local capgrowth = "Cap growth to: %d%%"
	local maxpct = "Set the maximum percentage that an item's price can grow before being filtered"

	local _,_,_, hex = GetItemQualityColor(0)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.flatoutlier.poor_enabled", format(enabletemplate, hex, "poor"))
	gui:AddTip(id, format(tooltiptemplate, "poor"))
	gui:AddControl(id, "WideSlider", 0, 1, "filter.flatoutlier.poor_level", 100, 5000, 25, capgrowth)
	gui:AddTip(id, maxpct)

	local _,_,_, hex = GetItemQualityColor(1)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.flatoutlier.common_enabled", format(enabletemplate, hex, "common"))
	gui:AddTip(id, format(tooltiptemplate, "common"))
	gui:AddControl(id, "WideSlider", 0, 1, "filter.flatoutlier.common_level", 100, 5000, 25, capgrowth)
	gui:AddTip(id, maxpct)

	local _,_,_, hex = GetItemQualityColor(2)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.flatoutlier.uncommon_enabled", format(enabletemplate, hex, "uncommon"))
	gui:AddTip(id, format(tooltiptemplate, "uncommon"))
	gui:AddControl(id, "WideSlider", 0, 1, "filter.flatoutlier.uncommon_level", 100, 5000, 25, capgrowth)
	gui:AddTip(id, maxpct)

	local _,_,_, hex = GetItemQualityColor(3)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.flatoutlier.rare_enabled", format(enabletemplate, hex, "rare"))
	gui:AddTip(id, format(tooltiptemplate, "rare"))
	gui:AddControl(id, "WideSlider", 0, 1, "filter.flatoutlier.rare_level", 100, 5000, 25, capgrowth)
	gui:AddTip(id, maxpct)

	local _,_,_, hex = GetItemQualityColor(4)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.flatoutlier.epic_enabled", format(enabletemplate, hex, "epic"))
	gui:AddTip(id, format(tooltiptemplate, "epic"))
	gui:AddControl(id, "WideSlider", 0, 1, "filter.flatoutlier.epic_level", 100, 5000, 25, capgrowth)
	gui:AddTip(id, maxpct)

end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Filter-FlatOutlier/FlatOutlier.lua $", "$Rev: 6394 $")
