--[[
	Auctioneer - Outlier Filter
	Version: 8.2.6357 (SwimmingSeadragon)
	Revision: $Id: OutlierFilter.lua 6357 2019-09-13 05:07:31Z none $
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

local libType, libName = "Filter", "Outlier"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill, _TRANS = AucAdvanced.GetModuleLocals()

local data

local reset = true
local valuecache, model, minseen, levels
local CFromZ = {};

local GetMarketValue = AucAdvanced.API.GetMarketValue
local GetSigFromLink = AucAdvanced.API.GetSigFromLink

lib.Processors = {}
function lib.Processors.config(callbackType, ...)
	private.SetupConfigGui(...)
end
local function doReset()
	valuecache = nil
	levels = nil
	reset = true
end
lib.Processors.scanstats = doReset
lib.Processors.auctionclose = doReset
lib.Processors.configchanged = doReset

function lib.AuctionFilter(operation, itemData)
	if not get("filter.outlier.activated") then
		return
	end
	if reset then
		minseen = get("filter.outlier.minseen")
		valuecache = {}
		levels = {}
		if get("filter.outlier.poor.enabled") then levels[0] = get("filter.outlier.poor.level") end
		if get("filter.outlier.common.enabled") then levels[1] = get("filter.outlier.common.level") end
		if get("filter.outlier.uncommon.enabled") then levels[2] = get("filter.outlier.uncommon.level") end
		if get("filter.outlier.rare.enabled") then levels[3] = get("filter.outlier.rare.level") end
		if get("filter.outlier.epic.enabled") then levels[4] = get("filter.outlier.epic.level") end
		if get("filter.outlier.legendary.enabled") then levels[5] = get("filter.outlier.legendary.level") end
		if get("filter.outlier.artifact.enabled") then levels[6] = get("filter.outlier.artifact.level") end
		reset = false
	end

	local quality = itemData.quality
	-- If we're not allowed to filter this quality of item
	if not levels[quality] then return false end

	local link = itemData.link
	local key = GetSigFromLink(link)
	local value = valuecache[key]
	if not value then
		local seen
		value, seen = GetMarketValue(link, nil, CFromZ[levels[quality]])

		if not value or not seen or seen < minseen then
			value = 0
		end
		valuecache[key] = value
	end

	-- If there's no value then we can't filter it
	if value == 0 then return false end

	-- Check to see if the item price is below the price
	local price = itemData.buyoutPrice or itemData.price
	local maxcap = value

	-- If the price is acceptible then allow it
	if itemData.stackSize > 1 then price = math.floor(price / itemData.stackSize) end
	if price <= maxcap then return false end

	-- Otherwise this item needs to be filtered

	-- debug line commented out: this module is under development so we may need still it
	--[=[
	debugPrint(format("Outlier filtered out item %s: price %s is above %.2f%% confidence level %s", link, tostring(price), CFromZ[levels[quality]] * 100, tostring(value)),
		"Outlier", "Filtered item", "Info")
	--]=]
	return true
end

function lib.OnLoad(addon)
	local function boundConfiguration(name, max, default)
		if get(name) > max then
			set(name, default)
		end
	end

	default("filter.outlier.activated", true)
	default("filter.outlier.minseen", 10)
	default("filter.outlier.poor.enabled", true)
	default("filter.outlier.common.enabled", true)
	default("filter.outlier.uncommon.enabled", true)
	default("filter.outlier.rare.enabled", true)
	default("filter.outlier.epic.enabled", true)
	default("filter.outlier.legendary.enabled", true)
	default("filter.outlier.artifact.enabled", true)
	default("filter.outlier.poor.level", 2.17)
	default("filter.outlier.common.level", 2.17)
	default("filter.outlier.uncommon.level", 2.17)
	default("filter.outlier.rare.level", 2.17)
	default("filter.outlier.epic.level", 2.17)
	default("filter.outlier.legendary.level", 3)
	default("filter.outlier.artifact.level", 3)

	boundConfiguration("filter.outlier.poor.level", 10, 2.17)
	boundConfiguration("filter.outlier.common.level", 10, 2.17)
	boundConfiguration("filter.outlier.uncommon.level", 10, 2.17)
	boundConfiguration("filter.outlier.rare.level", 10, 2.17)
	boundConfiguration("filter.outlier.epic.level", 10, 2.17)
	boundConfiguration("filter.outlier.legendary.level", 10, 3)
	boundConfiguration("filter.outlier.artifact.level", 10, 3)
end

function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id = gui:AddTab(libName, libType.." Modules")

	gui:AddHelp(id, "what outlier filter",
		_TRANS('OUTL_Help_WhatOutlierFilter') ,--What is this Outlier Filter?
		_TRANS('OUTL_Help_WhatOutlierFilterAnswer') )--When you get auctions that are posted up, many of the more common ones can become prey to people listing auctions for many times the 'real worth' of the actual item.\nThis filter detects such outliers and prevents them from being entered into the data stream if it\'s value exceeds a specified percentage of the normal value of the item. While still allowing for normal fluctuations in the prices of the items from day to day.

	gui:AddHelp(id, "can retroactive",
		_TRANS('OUTL_Help_RemoveOldOutliers') ,--Can it remove old outliers?
		_TRANS('OUTL_Help_RemoveOldOutliersAnswer') )--The simple answer is no, it only works from this point on. Any settings you apply are applied from here on in, and any current stats are left alone.\nThe complex answer? Well, you see there's this bowl of soup...

	gui:AddControl(id, "Header",     0,    _TRANS('OUTL_Interface_OutlierOptions') )--Outlier options
	gui:AddControl(id, "Checkbox",   0, 1, "filter.outlier.activated", _TRANS('OUTL_Interface_EnableOutlierFilter') )--Enable use of the outlier filter
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_EnableOutlierFilter') )--Ticking this box will enable the outlier filter to perform filtering of your auction scans

	gui:AddControl(id, "WideSlider", 0, 1, "filter.outlier.minseen", 1, 50, 1, _TRANS('OUTL_Interface_MinimumSeen') )--Minimum seen: %d
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_MinimumSeen') )--If an item has been seen less than this many times, it will not be filtered

	gui:AddControl(id, "Subhead",    0,    _TRANS('OUTL_Interface_SettingsQuality') )--Settings per quality:

	local _,_,_, hex = GetItemQualityColor(0)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.outlier.poor.enabled", _TRANS('OUTL_Interface_EnablePoor'):format("|c"..hex, "|r") )--Enable filtering %s poor %s quality items
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_EnablePoor') )--Ticking this box will enable outlier filtering on poor quality items
	gui:AddControl(id, "WideSlider", 0, 1, "filter.outlier.poor.level", 0.25, 5, .01, _TRANS('OUTL_Interface_CapGrowthParam'))--Cap growth to:
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_MaximumAmt') )--Set the maximum amount that an item's price can grow before being filtered

	local _,_,_, hex = GetItemQualityColor(1)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.outlier.common.enabled", _TRANS('OUTL_Interface_EnableCommon'):format("|c"..hex, "|r") )--Enable filtering %s common %s quality items
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_EnableCommon') )--Ticking this box will enable outlier filtering on common quality items
	gui:AddControl(id, "WideSlider", 0, 1, "filter.outlier.common.level", 0.25, 5, .01, _TRANS('OUTL_Interface_CapGrowthParam'))--Cap growth to:
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_MaximumAmt') )--Set the maximum amount that an item's price can grow before being filtered

	local _,_,_, hex = GetItemQualityColor(2)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.outlier.uncommon.enabled", _TRANS('OUTL_Interface_EnableUnCommon'):format("|c"..hex, "|r") )--Enable filtering %s uncommon %s quality items
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_EnableUnCommon') )--Ticking this box will enable outlier filtering on uncommon quality items
	gui:AddControl(id, "WideSlider", 0, 1, "filter.outlier.uncommon.level", 0.25, 5, .01, _TRANS('OUTL_Interface_CapGrowthParam'))--Cap growth to:
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_MaximumAmt') )--Set the maximum amount that an items price can grow before being filtered

	local _,_,_, hex = GetItemQualityColor(3)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.outlier.rare.enabled", _TRANS('OUTL_Interface_EnableRare'):format("|c"..hex, "|r") )--Enable filtering %s rare %s quality items
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_EnableRare') )--Ticking this box will enable outlier filtering on rare quality items
	gui:AddControl(id, "WideSlider", 0, 1, "filter.outlier.rare.level", 0.25, 5, .01, _TRANS('OUTL_Interface_CapGrowthParam'))--Cap growth to:
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_MaximumAmt') )--Set the maximum amount that an items price can grow before being filtered

	local _,_,_, hex = GetItemQualityColor(4)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.outlier.epic.enabled", _TRANS('OUTL_Interface_EnableEpic'):format("|c"..hex, "|r") )--Enable filtering %s epic %s quality items
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_EnableEpic') )--Ticking this box will enable outlier filtering on epic quality items
	gui:AddControl(id, "WideSlider", 0, 1, "filter.outlier.epic.level", 0.25, 5, .01, _TRANS('OUTL_Interface_CapGrowthParam'))--Cap growth to:
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_MaximumAmt') )--Set the maximum amount that an items price can grow before being filtered

	local _,_,_, hex = GetItemQualityColor(5)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.outlier.legendary.enabled", _TRANS('OUTL_Interface_EnableLegendary'):format("|c"..hex, "|r") )--Enable filtering %s legendary %s quality items
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_EnableLegendary') )--Ticking this box will enable outlier filtering on legendary quality items
	gui:AddControl(id, "WideSlider", 0, 1, "filter.outlier.legendary.level", 0.25, 5, .01, _TRANS('OUTL_Interface_CapGrowthParam'))--Cap growth to:
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_MaximumAmt') )--Set the maximum amount that an items price can grow before being filtered

	local _,_,_, hex = GetItemQualityColor(6)
	gui:AddControl(id, "Checkbox",   0, 1, "filter.outlier.artifact.enabled", _TRANS('OUTL_Interface_EnableArtifact'):format("|c"..hex, "|r") )--Enable filtering %s artifact %s quality items
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_EnableArtifact') )--Ticking this box will enable outlier filtering on artifact quality items
	gui:AddControl(id, "WideSlider", 0, 1, "filter.outlier.artifact.level", 0.25, 5, .01, _TRANS('OUTL_Interface_CapGrowthParam'))--Cap growth to:
	gui:AddTip(id, _TRANS('OUTL_HelpTooltip_MaximumAmt') )--Set the maximum amount that an items price can grow before being filtered

end

do
	local abs = math.abs;
	local sqrt = math.sqrt;
	local exp = math.exp;

	function private.GetCfromZ(Z)
		-- Estimation of the normal curve CDF based on a magic formula
		-- Adapted courtesy http://www.johndcook.com/cpp_phi.html
		local a1 = 0.254829592;
		local a2 = -0.284496736;
		local a3 = 1.421413741;
		local a4 = -1.453152027;
		local a5 = 1.061405429;
		local p =  0.3275911;

		local x = abs(Z) / sqrt(2);
		local t = 1 / (1 + p * x);
		local y = 1 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-x * x);

		return 0.5 * (1 + (Z < 0 and -y or y));
	end
end

-- Memoizing implementation of private.GetCFromZ()
setmetatable(CFromZ, {__index = function(t,k)
	local value = private.GetCfromZ(k);
	t[k] = value;
	return value;
end});


AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Filter-Outlier/OutlierFilter.lua $", "$Rev: 6357 $")
