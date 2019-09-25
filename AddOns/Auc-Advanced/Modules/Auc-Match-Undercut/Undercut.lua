--[[
	Auctioneer - Price Level Utility module
	Version: 8.2.6351 (SwimmingSeadragon)
	Revision: $Id: Undercut.lua 6351 2019-09-22 00:20:05Z none $
	URL: http://auctioneeraddon.com/

	This is an Auctioneer Matcher module that returns an undercut price
	based on the current market snapshot

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

local libType, libName = "Match", "Undercut"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end

local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill, _TRANS = AucAdvanced.GetModuleLocals()
local floor,min,max,ceil = floor,min,max,ceil
local tonumber,tostring = tonumber,tostring
local wipe = wipe

local QueryImage = AucAdvanced.API.QueryImage
local Const = AucAdvanced.Const
local Resources = AucAdvanced.Resources

local CONST_BUYOUT = Const.BUYOUT
local CONST_COUNT = Const.COUNT
local CONST_CURBID = Const.CURBID
local CONST_MINBID = Const.MINBID
local CONST_SELLER = Const.SELLER
local playerName = Const.PlayerName

local tooltipCache = setmetatable({}, {__mode="v"})
local matchArrayCache = {}
function private.clearMatchArrayCache()
	wipe(matchArrayCache)
end
function private.clearTooltipCache()
	wipe(tooltipCache)
end

lib.Processors = {}
function lib.Processors.itemtooltip(callbackType, ...)
	--Called when the tooltip is being drawn.
	private.ProcessTooltip(...)
end
lib.Processors.battlepettooltip = lib.Processors.itemtooltip

function lib.Processors.config(callbackType, ...)
	--Called when you should build your Configator tab.
	private.SetupConfigGui(...)
end

function lib.Processors.configchanged(callbackType, ...)
	--Called when your config options (if Configator) have been changed.
	private.clearMatchArrayCache()
	private.clearTooltipCache()
end

function lib.Processors.scanstats(callbackType, ...)
	-- AH has been scanned
	private.clearMatchArrayCache()
	private.clearTooltipCache()
end

function lib.Processors.auctionclose(callbackType, ...)
	private.clearMatchArrayCache()	-- this is mostly to conserve RAM, we don't really need to wipe the cache here
end


local query = {} -- reusable table
function lib.GetMatchArray(hyperlink, marketprice, serverKey)
	if not get("match.undercut.enable") then return end

	serverKey = serverKey or Resources.ServerKey
	marketprice = marketprice or 0
	local linkType, id, suffix, factor = decode(hyperlink)
	local cacheKey
	if linkType == "item" then
		query.itemId = id
		query.suffix = suffix
		query.factor = factor
		query.speciesID = nil
		query.quality = nil
		query.minItemLevel = nil
		query.maxItemLevel = nil
		cacheKey = serverKey .. id .."x".. suffix .."x".. factor .."x".. marketprice
	elseif linkType == "battlepet" then
		query.speciesID = id
		query.quality = factor
		query.minItemLevel = suffix
		query.maxItemLevel = suffix
		query.itemId = 82800
		query.suffix = nil
		query.factor = nil
		cacheKey = serverKey .. id .."p".. suffix .."p".. factor .."p".. marketprice
	else
		return
	end

	if matchArrayCache[cacheKey] then return matchArrayCache[cacheKey] end

	local overmarket = get("match.undermarket.overmarket")
	local undermarket = get("match.undermarket.undermarket")
	local usevalue = get("match.undercut.usevalue")
	local undercut
	if usevalue then
		undercut = get("match.undercut.value")
	else
		undercut = get("match.undermarket.undercut")
	end
	local marketdiff = 0
	local competing = 0
	local matchprice = 0
	local minprice = 0
	local lowest = true
	if marketprice > 0 then
		matchprice = floor(marketprice*(1+(overmarket/100)))
		minprice = ceil(marketprice*(1+(undermarket/100)))
	end

	local data = QueryImage(query, serverKey)
	competing = #data
	local lowestBidOnly = matchprice
	for i = 1, #data do
		local item = data[i]
		local buyout = item[CONST_BUYOUT]
		local count = item[CONST_COUNT] -- should be non-nil and non-zero
		if buyout < 1 then
			local bid = item[CONST_CURBID] -- should be non-nil
			if bid == 0 then bid = item[CONST_MINBID] end -- should be non-nil
			bid = bid / count
			if bid < lowestBidOnly then lowestBidOnly = bid end
		else
			buyout = buyout / count
			if usevalue then
				buyout = buyout - undercut
			else
				buyout = floor(buyout*((100-undercut)/100))
			end
			if buyout <= 0 then
				buyout = 1
			end
			if (buyout < matchprice) then
				if (buyout > minprice) then
					if item[CONST_SELLER] ~= playerName then
						matchprice = buyout
					end
				elseif (buyout > 0) then
					lowest = false
				end
			end
		end
	end
	if (marketprice > 0) then
		marketdiff = floor((matchprice - marketprice) /marketprice *100 +0.5)
	else
		marketdiff = 0
	end
	local matchArray = {}
	matchArray.value = matchprice
	if lowest then
		if matchprice<=lowestBidOnly then
			matchArray.returnstring = _TRANS('UCUT_Interface_UndercutLowestPrice'):format(marketdiff, "\n")--Undercut: %% change: %s%s Undercut: Lowest Price
			matchArray.Result = "Lowest" -- non-localized code for internal use
		else
			matchArray.returnstring = _TRANS('UCUT_Interface_UndercutLowestBid'):format(marketdiff, "\n")--Undercut: %% change: %s%s Undercut: Lower bid-only auctions
			matchArray.Result = "LowerBid"
		end
	else
		matchArray.returnstring = _TRANS('UCUT_Interface_UndercutNoMatch'):format(marketdiff, "\n")--Undercut: %% change: %s%s Undercut: Can not match lowest price')
		matchArray.Result = "NoMatch"
	end
	matchArray.competing = competing
	matchArray.diff = marketdiff
	matchArrayCache[cacheKey] = matchArray
	return matchArray
end

function private.ProcessTooltip(tooltip, link, serverKey, quantity, decoded, additional, order)
	if not link then return end
	if not get("match.undercut.tooltip") then return end
	local model = get("match.undercut.model")
	if not model then return end
	local market

	local matcharray = tooltipCache[link]
	if matcharray then
		market = matcharray.market
	else
		if model == "market" then
			market = AucAdvanced.API.GetMarketValue(link, serverKey)
		else
			market = AucAdvanced.API.GetAlgorithmValue(model, link, serverKey)
		end
		if not market then return end
		matcharray = lib.GetMatchArray(link, market, serverKey)
		if not matcharray then return end
		matcharray = replicate(matcharray)
		matcharray.market = market
		tooltipCache[link] = matcharray
	end
	if not matcharray.value or matcharray.value <= 0 then return end

	tooltip:SetColor(0.3, 0.9, 0.8)

	if matcharray.competing == 0 then
		tooltip:AddLine(_TRANS('UCUT_Tooltip_NoCompetition'):format("|cff00ff00") )--Undercut: %s No competition
	elseif matcharray.Result == "NoMatch" then
		tooltip:AddLine(_TRANS('UCUT_Tooltip_CannotUndercut'):format("|cffff0000") )--Undercut: %s Cannot Undercut
	elseif matcharray.Result == "Lowest" then
		if matcharray.value >= market then
			tooltip:AddLine(_TRANS('UCUT_Tooltip_CompetitionAbove'):format("|cff40ff00") )--Undercut: %s Competition Above market
		else
			tooltip:AddLine(_TRANS('UCUT_Tooltip_Undercutting'):format("|cfffff000") )--Undercut: %s Undercutting competition
		end
	elseif matcharray.Result == "LowerBid" then
		tooltip:AddLine(_TRANS('UCUT_Tooltip_LowBidOnly'):format("|cfffff000") )--Undercut: %s Lower Bid-only auctions
	end
	tooltip:AddLine("  ".._TRANS('UCUT_Tooltip_MovingPrice').." "..tostring(matcharray.diff).."%:", matcharray.value)--Moving price
end

function lib.OnLoad()
	default("match.undercut.enable", true)
	default("match.undermarket.undermarket", -20)
	default("match.undermarket.overmarket", 10)
	default("match.undermarket.undercut", 1)
	default("match.undercut.tooltip", true)
	default("match.undercut.model", "market")
	default("match.undercut.usevalue", false)
	default("match.undercut.value", 1)
end

--[[ Local functions ]]--

function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id = gui:AddTab(libName, libType.." Modules")
	--gui:MakeScrollable(id)

	gui:AddHelp(id, "what undercut module",
		_TRANS('UCUT_Help_WhatUndercut') ,--What is this undercut module?
		_TRANS('UCUT_Help_WhatUndercutAnswer') )--The undercut module allows you to undercut the lowest price of all currently available items, based on your settings. \n\n It is recommended to have undercut run after any other matcher modules.

	gui:AddControl(id, "Header",     0,   _TRANS('UCUT_Interface_UndercutOptions') )--Undercut options

	gui:AddControl(id, "Subhead",    0,   _TRANS('UCUT_Interface_CompetitionMatching') )--Competition Matching

	gui:AddControl(id, "Checkbox",   0, 1, "match.undercut.enable", _TRANS('UCUT_Interface_EnableUndercut') )--Enable Auc-Match-Undercut
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_EnableUndercut') )--Enable this module's functions.

	gui:AddControl(id, "WideSlider", 0, 1, "match.undermarket.undermarket", -100, 0, 1, _TRANS('UCUT_Interface_MaxMarkdown').." %d%%")--Max under market price (markdown):
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_MaxMarkdown') )--This controls how much below the market price you are willing to undercut before giving up. \n If Auctioneer cannot beat the lowest price, it will undercut the lowest price it can.

	gui:AddControl(id, "WideSlider", 0, 1, "match.undermarket.overmarket", 0, 100, 1, _TRANS('UCUT_Interface_MaxMarkup').." %d%%")--Max over market price (markup):
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_MaxMarkup') )--This controls how much above the market price you are willing to mark up. If there is no competition, or the competition is marked up higher than this value Auctioneer will set the price to this value above market.

	gui:AddControl(id, "Slider",     0, 1, "match.undermarket.undercut", 0, 20, 0.1, _TRANS('UCUT_Interface_UndercutMinimum').." %g%%")--Undercut:
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_UndercutMinimum') )--This controls the minimum undercut.  Auctioneer will try to undercut the competition by this amount

	gui:AddControl(id, "Checkbox",   0, 1, "match.undercut.usevalue", _TRANS('UCUT_Interface_UndercutAmount') )--Specify undercut amount by coin value
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_UndercutAmount') )--Specify the amount to undercut by a specific amount, instead of by a percentage

	gui:AddControl(id, "MoneyFramePinned", 0, 2, "match.undercut.value", 1, Const.MAXBIDPRICE, _TRANS('UCUT_Interface_CurrentValue') )--Undercut Amount
	gui:AddControl(id, "Subhead",    0,    _TRANS('UCUT_Interface_UndercutTooltipSettings') )--Tooltip Setting
	gui:AddControl(id, "Checkbox",   0, 1, "match.undercut.tooltip",_TRANS('UCUT_Interface_ShowInTooltip') )--Show undercut status in tooltip
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_ShowInTooltip') )--Add a line to the tooltip showing whether the current competition is undercuttable
	gui:AddControl(id, "Note",       0, 2, 500, 15, _TRANS('UCUT_Interface_TooltipValuationMethod') )--Tooltip price valuation method
	gui:AddControl(id, "Selectbox",  0, 2, parent.selectorPriceModels, "match.undercut.model" )--Pricing model to use
	gui:AddTip(id, _TRANS('UCUT_HelpTooltip_PricingModel'))--The pricing model to use to compare the competition against.  Should be set to the model most often used for posting.  --Note: this is ONLY for basing the tooltip on, nothing else

end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Match-Undercut/Undercut.lua $", "$Rev: 6351 $")
