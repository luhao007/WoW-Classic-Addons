--[[
	Auctioneer - Histogram Statistics module
	Version: 8.2.6366 (SwimmingSeadragon)
	Revision: $Id: StatHistogram.lua 6366 2019-09-22 00:20:05Z none $
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
--]]
if not AucAdvanced then return end

local libType, libName = "Stat", "Histogram"
local LIBSTRING = libType.."-"..libName
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end

local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill, _TRANS = AucAdvanced.GetModuleLocals()
local Resources = AucAdvanced.Resources
local GetStoreKey = AucAdvanced.API.GetStoreKeyFromLinkB
local ResolveServerKey = AucAdvanced.ResolveServerKey

local DATABASE_VERSION = 3.0
local TABLE_DIVIDER = ";"
local DATA_DIVIDER = "!"
local PROPERTY_DIVIDER = "@"
local ITEM_DIVIDER = "_"
local PET_BAND = 10

local tonumber,pairs,type,setmetatable=tonumber,pairs,type,setmetatable
local strsplit,strjoin = strsplit,strjoin
local min,max,abs,ceil,floor = min,max,abs,ceil,floor
local tconcat = table.concat
local wipe,unpack = wipe,unpack


local RealmData
local StatTable = {}
local PDcurve = {}
local array = {}
local frame
local pricecache
local meta0 = {__index = function() return 0 end}

function private.ClearCache()
	pricecache = nil
end


function lib.CommandHandler(command, ...)
	local serverKey = Resources.ServerKey
	local keyText = AucAdvanced.GetServerKeyText(serverKey)
	if (command == "help") then
		aucPrint(_TRANS('SHTG_Help_SlashHelp1') )--Help for Auctioneer - Histogram
		local line = AucAdvanced.Config.GetCommandLead(libType, libName)
		aucPrint(line, "help}} - ".._TRANS('SHTG_Help_SlashHelp2') ) -- this Histogram help
		aucPrint(line, "clear}} - ".._TRANS('SHTG_Help_SlashHelp3'):format(keyText) ) --clear current %s Histogram price database
	elseif (command == "clear") then
		lib.ClearData(serverKey)
	end
end

lib.Processors = {
	itemtooltip = function(callbackType, ...)
		private.ProcessTooltip(...)
	end,
	config = function(callbackType, gui)
		--Called when you should build your Configator tab.
		if private.SetupConfigGui then private.SetupConfigGui(gui) end
	end,
}
lib.Processors.battlepettooltip = lib.Processors.itemtooltip
lib.Processors.scanstats = private.ClearCache
lib.Processors.auctionclose = private.ClearCache -- not actually needed, just conserving RAM

function private.GetPriceData()
	if not StatTable.count then
		debugPrint("GetPriceData: No data in StatTable", LIBSTRING, "Error")
		return
	end
	local median, Qone, Qthree, percent40, percent30 = 0, 0, 0, 0, 0
	local count = StatTable.count
	local refactored = false
	--now find the Q1, median, and Q3 values
	if StatTable.min == StatTable.max then
		--no need to do fancy median calculations
		median = StatTable.min * StatTable.step
		--count = value at the only index we have
		count = StatTable[StatTable.min]
		StatTable.count = count
	else
		local recount = 0
		for i = StatTable.min, StatTable.max do
			recount = recount + (StatTable[i] or 0)
			if Qone == 0 and count > 4 then --Q1 is meaningless with very little data
				if recount >= count * 0.25 then
					Qone = i * StatTable.step
				end
			end
			if percent30 == 0 then
				if recount >= count * 0.3 then
					percent30 = i * StatTable.step
				end
			end
			if percent40 == 0 then
				if recount >= count * 0.4 then
					percent40 = i * StatTable.step
				end
			end
			if median == 0 then
				if recount >= count * 0.5 then
					median = i * StatTable.step
				end
			end
			if Qthree == 0 and count > 4 then--Q3 is meaningless with very little data
				if recount >= count * 0.75 then
					Qthree = i * StatTable.step
				end
			end
		end
		if count ~= recount then
			-- This should not happen, but was sometimes occurring in earlier builds. Make correction and report if it happens again.
			count = recount
			StatTable.count = count
			refactored = true
			debugPrint("GetPriceData: corrected count mismatch", LIBSTRING, "Warning")
		end
	end
	local step = StatTable.step
	if count > 20 then --we've seen enough to get a fairly decent price to base the precision on
		if (step > (median / 85)) and (step > 1) then
			private.refactor(median * 3, 300)
			refactored = true
		elseif step < (median / 115) then
			private.refactor(median * 3, 300)
			refactored = true
		end
	end
	return median, Qone, Qthree, step, count, refactored, percent40, percent30
end

function lib.GetPrice(link, serverKey)
	if not get("stat.histogram.enable") then return end

	serverKey = ResolveServerKey(serverKey)
	if not serverKey then return end

	local itemID, property = GetStoreKey(link, PET_BAND)
	if not itemID then return end

	-- ### todo: rethink cache
	if pricecache and pricecache[serverKey] and pricecache[serverKey][itemID] and pricecache[serverKey][itemID][property] then
		return unpack(pricecache[serverKey][itemID][property], 1, 7)
	end

	if not private.StatTableOpen(serverKey, itemID, property) then return end -- fill in StatTable, bail if no data

	local median, Qone, Qthree, step, count, refactored, percent40, percent30 = private.GetPriceData()
	if refactored then
		--data has been refactored, so we need to repack it
		private.StatTableWrite(serverKey, itemID, property)
		--get the updated data
		median, Qone, Qthree, step, count = private.GetPriceData()
	end
	--we're done with the data, so clear the table
	private.StatTableClose()

	if not pricecache then pricecache = {} end
	if not pricecache[serverKey] then pricecache[serverKey] = {} end
	if not pricecache[serverKey][itemID] then pricecache[serverKey][itemID] = {} end
	pricecache[serverKey][itemID][property] = {median, Qone, Qthree, step, count, percent40, percent30}
	return median, Qone, Qthree, step, count, percent40, percent30
end


function lib.GetPriceColumns()
	return "Median", "Q1", "Q3", "step", "Seen", "Percent40", "Percent30"
end

function lib.GetPriceArray(link, serverKey)
	if not get("stat.histogram.enable") then return end
	--make sure that array is empty
	wipe(array)
	local median, Qone, Qthree, step, count, percent40, percent30 = lib.GetPrice(link, serverKey)
	--these are the two values that GetMarketPrice cares about
	array.price = median
	array.seen = count
	--additional data
	array.Qone = Qone
	array.Qthree = Qthree
	array.step = step
	array.percent40 = percent40
	array.percent30 = percent30

	-- Return a temporary array. Data in this array is
	-- only valid until this function is called again.
	return array
end

function private.ItemPDF(price)
	if not PDcurve.step then return 0 end -- ### or PDcurve.step == 0
	local index = floor(price / PDcurve.step)
	if index >= PDcurve.min and index <= PDcurve.max then
		return PDcurve[index]
	else
		return 0
	end
end

function lib.GetItemPDF(link, serverKey)
	if not get("stat.histogram.enable") then return end

	serverKey = ResolveServerKey(serverKey)
	if not serverKey then return end

	local itemID, property = GetStoreKey(link, PET_BAND)
	if not itemID then return end

	if not private.StatTableOpen(serverKey, itemID, property) then return end -- fill in StatTable, bail if no data

	-- ### todo: consider refactoring test here
	-- ### todo 2: consider caching? May be impractical as we'd need to store entire PDcurve array?

	wipe(PDcurve)

	local count = StatTable.count
	local step = StatTable.step

	local curcount = 0
	local area = 0
	local targetarea = min(1, count / 30) --if count is less than thirty, we're not very sure about the price

	PDcurve.step = step
	PDcurve.min = StatTable.min - 1
	PDcurve.max = StatTable.max + 1

	for i = StatTable.min, StatTable.max do
		curcount = curcount + StatTable[i]
		if count == StatTable[i] then
			PDcurve[i] = 1
		else
			PDcurve[i] = 1 - abs(2 * curcount - count) / count
		end
		area = area + step * PDcurve[i]
	end

	local areamultiplier = 1
	if area > 0 then -- ### todo: should return nil if area == 0 ? can that even happen?
		areamultiplier = targetarea / area
	end
	for i = PDcurve.min, PDcurve.max do
		PDcurve[i]= (PDcurve[i] or 0) * areamultiplier
	end
	private.StatTableClose()
	return private.ItemPDF, PDcurve.min * PDcurve.step, PDcurve.max * PDcurve.step, targetarea
end

lib.ScanProcessors = {}
function lib.ScanProcessors.create(operation, itemData, oldData)
	if not get("stat.histogram.enable") then return end

	-- We're only interested in items with buyouts.
	local buyout = itemData.buyoutPrice
	if not buyout or buyout == 0 then return end
	if (itemData.stackSize > 1) then
		buyout = buyout/itemData.stackSize
	end

	local itemID, property = GetStoreKey(itemData.link, PET_BAND)
	if not itemID then return end
	local serverKey = Resources.ServerKey
	private.StatTableOpen(serverKey, itemID, property, true) -- Fill StatTable; create new record for this item if one doesn't exist

	if not StatTable.count then -- ### or StatTable.count == 0 ?
		StatTable.step = ceil(buyout / 100)
		StatTable.count = 0
	end
	local priceindex = ceil(buyout / StatTable.step)
	if StatTable.count <= 20 then
		--start out with first 20 prices pushing max to 100.  This should help prevent losing data due to the first price being way too low
		--also keeps data small initially, as we don't need extremely accurate prices with that little data
		--get the refactoring out of the way first, because we're not capping the price yet
		--failure to do this now can cause major trouble in the form of massive tables
		if priceindex > 100 then
			private.refactor(buyout, 100)
			priceindex = 100
		end
		if not StatTable.min then
			StatTable.min = priceindex
			StatTable.max = priceindex
			StatTable[priceindex] = 0
		elseif StatTable.min > priceindex then
			for i = priceindex, StatTable.min - 1 do
				StatTable[i] = 0
			end
			StatTable.min = priceindex
		elseif StatTable.max < priceindex then
			for i = StatTable.max + 1, priceindex do
				StatTable[i] = 0
			end
			StatTable.max = priceindex
		end
		StatTable.count = StatTable.count + 1
		if not StatTable[priceindex] then StatTable[priceindex] = 0 end
		StatTable[priceindex] = StatTable[priceindex] + 1
		private.StatTableWrite(serverKey, itemID, property)
	elseif priceindex <= 300 then --we don't want prices too high: they'll bloat the data.  If range needs to go higher, we'll refactor later
		if not StatTable.min then --first time we've seen this -- ### todo: this should never happen?
			debugPrint("create: count > 20 but no StatTable.min", LIBSTRING, "Warning")
			StatTable.min = priceindex
			StatTable.max = priceindex
			StatTable[priceindex] = 0
		elseif StatTable.min > priceindex then
			for i = priceindex, StatTable.min - 1 do
				StatTable[i] = 0
			end
			StatTable.min = priceindex
		elseif StatTable.max < priceindex then
			for i = StatTable.max + 1, priceindex do
				StatTable[i] = 0
			end
			StatTable.max = priceindex
		end
		StatTable.count = StatTable.count + 1
		if not StatTable[priceindex] then StatTable[priceindex] = 0 end
		StatTable[priceindex] = StatTable[priceindex] + 1
		private.StatTableWrite(serverKey, itemID, property)
	end
	private.StatTableClose()
end

function private.SetupConfigGui(gui)
	private.SetupConfigGui = nil
	local id = gui:AddTab(lib.libName, lib.libType.." Modules")

	gui:AddHelp(id, "what histogram stats",
		_TRANS('SHTG_Help_WhatHistogramStats') ,--What are Histogram stats?
		_TRANS('SHTG_Help_WhatHistogramStatsAnswer') )--Histogram stats record a histogram of past prices.
	gui:AddHelp(id, "what advantages",
		_TRANS('SHTG_Help_WhatAdvantageHistogram') ,--What advantages does Histogram have?
		_TRANS('SHTG_Help_WhatAdvantageHistogramAnswer') )--Histogram stats don't have a limitation to how many, or how long, it can keep data, so it can keep track of high-volume items well
	gui:AddHelp(id, "what disadvantage",
		_TRANS('SHTG_Help_WhatDisadvantagesHistogram') ,--What disadvantages does Histogram have?
		_TRANS('SHTG_Help_WhatDisadvantagesHistogramAnswer') )--Histogram rounds prices slightly to help store them, so there is a slight precision loss. However, it is precise to 1/250th of market price. (an item with market price 250g will have prices stored to the nearest 1g)

	frame = gui.tabs[id].content
	private.frame = frame

	frame.slot = frame:CreateTexture(nil, "BORDER")
	frame.slot:SetDrawLayer("Artwork") -- or the border shades it
	frame.slot:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -210)
	frame.slot:SetWidth(45)
	frame.slot:SetHeight(45)
	frame.slot:SetTexCoord(0.17, 0.83, 0.17, 0.83)
	frame.slot:SetTexture("Interface\\Buttons\\UI-EmptySlot")
	function frame.IconClicked()
		local objtype, _, link = GetCursorInfo()
		ClearCursor()
		if objtype == "item" or objtype == "battlepet" then
			lib.SetWorkingItem(link)
		else
			lib.SetWorkingItem()
		end
	end
	function frame.ClickHook(link)
		if not frame.slot:IsVisible() then return end
		lib.SetWorkingItem(link)
	end
	hooksecurefunc("HandleModifiedItemClick", frame.ClickHook)
	frame.icon = CreateFrame("Button", nil, frame)
	frame.icon:SetPoint("TOPLEFT", frame.slot, "TOPLEFT", 2, -2)
	frame.icon:SetPoint("BOTTOMRIGHT", frame.slot, "BOTTOMRIGHT", -2, 2)
	frame.icon:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square.blp")
	frame.icon:SetScript("OnClick", frame.IconClicked)
	frame.icon:SetScript("OnReceiveDrag", frame.IconClicked)
	frame.icon:SetScript("OnEnter", function() --set mouseover tooltip
			if not frame.link then return end
			GameTooltip:SetOwner(frame.icon, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:SetHyperlink(frame.link)
		end)
	frame.icon:SetScript("OnLeave", function() GameTooltip:Hide() end)

	frame.name = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	frame.name:SetPoint("TOPLEFT", frame.slot, "TOPRIGHT", 5,-2)
	frame.name:SetPoint("RIGHT", frame, "RIGHT", -15)
	frame.name:SetHeight(20)
	frame.name:SetJustifyH("LEFT")
	frame.name:SetJustifyV("TOP")
	frame.name:SetText("Insert or Alt-Click Item to start")
	frame.name:SetTextColor(0.5, 0.5, 0.7)

	frame.bargraph = CreateFrame("Frame", nil, frame)
	frame.bargraph:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -260)
	frame.bargraph:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, -260)
	frame.bargraph:SetHeight(300)
	frame.bargraph:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frame.bargraph:SetBackdropColor(0, 0, 0.0, 0.5)
	frame.bargraph.bars = {}
	frame.bargraph.pdf = {}
	frame.bargraph.max = 100
	local graphwidth = frame.bargraph:GetWidth()-10
	local graphheight = frame.bargraph:GetHeight()-10
	for i = 1, 300 do
		frame.bargraph.bars[i] = frame.bargraph:CreateTexture(nil)
		local bar = frame.bargraph.bars[i]
		bar:SetPoint("BOTTOMLEFT", frame.bargraph, "BOTTOMLEFT", (graphwidth*(i-1)/300)+5, 5)
		bar:SetWidth(graphwidth/300)
		bar:SetColorTexture(0.2, 0.8, 0.2)
		function bar:SetValue(value)
			if value == 0 then value = 0.001 end
			self:SetHeight((self:GetParent():GetHeight()-20)*value)
		end
		bar:SetValue(0)
	end
	for i = 1, 300 do
		frame.bargraph.pdf[i] = frame.bargraph:CreateTexture(nil)
		local pdf = frame.bargraph.pdf[i]
		pdf.offset = (graphwidth*(i-1)/300)+5
		pdf:SetPoint("BOTTOMLEFT", frame.bargraph, "BOTTOMLEFT", pdf.offset, 50)
		pdf:SetWidth(graphwidth/300)
		pdf:SetHeight(5)
		pdf:SetColorTexture(.2, .2, 0.8, .6)
		function pdf:SetValue(value)
			local bottom = (self:GetParent():GetHeight()-20)*value
			self:SetPoint("BOTTOMLEFT", frame.bargraph, "BOTTOMLEFT", self.offset, bottom)
		end
		pdf:SetValue(0)
	end

	frame.key = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	frame.key:SetPoint("BOTTOMRIGHT", frame.bargraph, "TOPRIGHT", 0, 2)
	frame.key:SetPoint("TOPLEFT", frame.bargraph, "TOPLEFT", 5, 22)
	frame.key:SetJustifyH("RIGHT")
	frame.key:SetJustifyV("TOP")
	frame.key:SetText("|cff3fff3fRaw Data   |cffff3f3fMedian   |cff3f3fffPrice Probability")

	frame.med = frame.bargraph:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.med:SetPoint("TOP", frame.bargraph, "BOTTOM", -50, -10)
	frame.med:SetPoint("BOTTOM", frame.bargraph, "BOTTOM", -50, -25)
	frame.med:SetWidth(150)

	frame.max = frame.bargraph:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.max:SetPoint("TOPRIGHT", frame.bargraph, "BOTTOMRIGHT", 0, -10)
	frame.max:SetPoint("BOTTOMLEFT", frame.bargraph, "BOTTOMRIGHT", -150, -25)

	--all options in here will be duplicated in the tooltip frame
	function private.addTooltipControls(id)
		gui:AddControl(id, "Header",     0,    _TRANS('SHTG_Interface_HistogramOptions') )--Histogram options
		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
		gui:AddControl(id, "Checkbox",   0, 1, "stat.histogram.enable", _TRANS('SHTG_Interface_EnableHistogram') )--Enable Histogram Stats
		gui:AddTip(id, _TRANS('SHTG_HelpTooltip_EnableHistogram') )--Allow Histogram to gather and return price data
		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")

		gui:AddControl(id, "Checkbox",   0, 4, "stat.histogram.tooltip", _TRANS('SHTG_Interface_ShowHistogramTooltips') )--Show Histogram stats in the tooltips?
		gui:AddTip(id, _TRANS('SHTG_HelpTooltip_ShowHistogramTooltips') )--Toggle display of stats from the Histogram module on or off
		gui:AddControl(id, "Checkbox",   0, 6, "stat.histogram.median", _TRANS('SHTG_Interface_DisplayMedian') )--Display Median
		gui:AddTip(id, _TRANS('SHTG_HelpTooltip_DisplayMedian') )--Toggle display of \'Median\' calculation in tooltips on or off
		gui:AddControl(id, "Checkbox",   0, 6, "stat.histogram.iqr", _TRANS('SHTG_Interface_DisplayIQR') )--Display IQR
		gui:AddTip(id, _TRANS('SHTG_HelpTooltip_DisplayIQR') )--Toggle display of \'IQR\' calculation in tooltips on or off.  See help for further explanation.
		gui:AddControl(id, "Checkbox",   0, 6, "stat.histogram.precision", _TRANS('SHTG_Interface_DisplayPrecision') )--Display Precision
		gui:AddTip(id, _TRANS('SHTG_HelpTooltip_DisplayPrecision') )--Toggle display of \'precision\' calculation in tooltips on or off
		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
		gui:AddControl(id, "Checkbox",   0, 4, "stat.histogram.quantmul", _TRANS('SHTG_Interface_MultiplyStack') )--Multiply by Stack Size
		gui:AddTip(id, _TRANS('SHTG_HelpTooltip_MultiplyStack') )--Multiplies by current Stack Size if on

		gui:AddHelp(id, "what median",
			_TRANS('SHTG_Help_WhatMedian') ,--What is the median?
			_TRANS('SHTG_Help_WhatMedianAnswer') )--The median value is the value where half of the prices seen are above, and half are below.
		gui:AddHelp(id, "what IQR",
			_TRANS('SHTG_Help_WhatIQR') ,--What is the IQR?
			_TRANS('SHTG_Help_WhatIQRAnswer') )--The IQR is a measure of spread.  The middle half of the prices seen is confined with the range of IQR. An item with median 100g, and IQR 10g, has very consistent data.  If the IQR was 100g, the prices are all over the place.
		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
	end
	--This is the Tooltip tab provided by aucadvnced so all tooltip configuration is in one place
	local tooltipID = AucAdvanced.Settings.Gui.tooltipID

	--now we create a duplicate of these in the tooltip frame
	private.addTooltipControls(id)
	if tooltipID then private.addTooltipControls(tooltipID) end

	gui:MakeScrollable(id)

	gui:AddControl(id, "Subhead",    0,    _TRANS('SHTG_Interface_ItemDataViewer') )--Item Data Viewer

end

function lib.SetWorkingItem(link)
	--clear the graph
	frame.name:SetText(_TRANS('SHTG_Interface_InsertItemStart') )--Insert or Alt-Click Item to start
	frame.icon:SetNormalTexture(nil) --set icon texture
	frame.med:SetText("")
	frame.max:SetText("")
	frame.link = nil
	for i = 1,300 do
		frame.bargraph.bars[i]:SetValue(0)
		frame.bargraph.bars[i]:SetColorTexture(0.2, 0.8, 0.2)
		frame.bargraph.pdf[i]:SetValue(0)
	end

	if not link then return end
	local itemID, property, linktype = GetStoreKey(link, PET_BAND)
	if not itemID then return end
	local texture
	if linktype == "item" then
		texture = GetItemIcon(link)
	elseif linktype == "battlepet" then
		local speciesID = tonumber(strmatch(link, "battlepet:(%d+)"))
		if speciesID then
			local _, t = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
			texture = t
		end
	end
	if not texture then return end

	frame.name:SetText(link)
	frame.link = link
	frame.icon:SetNormalTexture(texture) --set icon texture


	if not private.StatTableOpen(Resources.ServerKey, itemID, property) then return end -- fill in StatTable, bail if no data

	local maxvalue = 0
	local indexes = 0
	local count = StatTable.count
	local recount = 0
	local median = 0
	for i = StatTable.min, StatTable.max do
		indexes = indexes +1 -- ### todo: not used anywhere?
		if StatTable[i] > maxvalue then maxvalue = StatTable[i] end
		recount = recount + StatTable[i]
		if median == 0 then
			if recount >= count/2 then
				median = i
				frame.bargraph.bars[i]:SetColorTexture(0.8, 0.2, 0.2)
			end
		end
	end
	for i = StatTable.min, StatTable.max do
		frame.bargraph.bars[i]:SetValue(StatTable[i]/maxvalue)
	end

	--now show the PD curve
	wipe(PDcurve)
	PDcurve.step = StatTable.step
	PDcurve.min = StatTable.min
	PDcurve.max = StatTable.max
	local curcount = 0
	count = StatTable.count -- ### todo: shouldn't have changed from above?
	maxvalue = 0
	for i = StatTable.min, StatTable.max do
		curcount = curcount + StatTable[i]
		if count == StatTable[i] then
			PDcurve[i] = 1
		else
			PDcurve[i] = 1-(abs(2*curcount - count)/count)
		end
		if PDcurve[i] > maxvalue then
			maxvalue = PDcurve[i]
		end
	end
	for i = PDcurve.min, PDcurve.max do -- ### todo: can some of these extra loops be merged?
		PDcurve[i]= PDcurve[i] or 0
	end

	for i = 1,300 do
		if i >= PDcurve.min and i <= PDcurve.max then
			frame.bargraph.pdf[i]:SetValue(PDcurve[i])
		else
			frame.bargraph.pdf[i]:SetValue(0)
		end
	end

	frame.med:SetText("Median: "..AucAdvanced.Coins(median * StatTable.step, true)) -- ### todo: localize
	frame.max:SetText("Max: "..AucAdvanced.Coins(300 * StatTable.step, true))
	private.StatTableClose()
end

function private.ProcessTooltip(tooltip, hyperlink, serverKey, quantity, decoded, additional, order)
	if not get("stat.histogram.tooltip") then return end

	local quantmul = get("stat.histogram.quantmul")
	if (not quantmul) or (not quantity) or (quantity < 1) then quantity = 1 end
	local median, Qone, Qthree, step, count, percent40, percent30 = lib.GetPrice(hyperlink, serverKey)
	if not count then
		count = 0
	end
	if median then
		if quantity == 1 then
			tooltip:AddLine(_TRANS('SHTG_Tooltip_PricesSeenOnce'):format(count) )--Histogram prices: (seen {{%s}})
		else
			tooltip:AddLine(_TRANS('SHTG_Tooltip_Prices'):format(quantity, count) )--Histogram prices x {{%s}}) : (seen {{%s}})
		end
		local iqr = Qthree-Qone
		if get("stat.histogram.median") then
			tooltip:AddLine("  ".._TRANS('SHTG_Tooltip_Median'), median*quantity)--median:
			if quantity > 1 then
				tooltip:AddLine("  ".._TRANS('SHTG_Tooltip_Individually'), median)--(or individually):
			end
		end
		if (iqr > 0) and (get("stat.histogram.iqr")) then
			tooltip:AddLine("  ".._TRANS('SHTG_Tooltip_IQR') , iqr*quantity)--  IQR:
		end
		if get("stat.histogram.precision") then
		tooltip:AddLine("  ".._TRANS('SHTG_Tooltip_Precision'), step*quantity)--precision:
		end
	end
end

function lib.OnLoad(addon)
	private.InitData()
	default("stat.histogram.tooltip", false)
	default("stat.histogram.median", false)
	default("stat.histogram.iqr", true)
	default("stat.histogram.precision", false)
	default("stat.histogram.quantmul", true)
	default("stat.histogram.enable", true)
end

function lib.ClearItem(link, serverKey)
	if not link then return end
	serverKey = ResolveServerKey(serverKey)
	if not serverKey then return end

	local storeID, storeProperty = GetStoreKey(link, PET_BAND)
	if not storeID then return end

	if private.FindRemoveEntry(serverKey, storeID, storeProperty) then
		local keyText = AucAdvanced.GetServerKeyText(serverKey)
		aucPrint(libType.._TRANS('SHTG_Interface_ClearingData'):format(link, keyText))--- Histogram: clearing data for %s for {{%s}}
		private.ClearCache()
	end
end

function lib.ClearData(serverKey)
	if not RealmData then return end
	if AucAdvanced.API.IsKeyword(serverKey, "ALL") then
		wipe(RealmData)
		aucPrint(_TRANS('SHTG_Help_SlashHelp5').." {{".._TRANS("ADV_Interface_AllRealms").."}}") --Clearing Histogram stats for // All realms
		private.ClearCache()
	else
		serverKey = ResolveServerKey(serverKey)
		if serverKey and RealmData[serverKey] then
			local keyText = AucAdvanced.GetServerKeyText(serverKey)
			RealmData[serverKey] = nil
			aucPrint(_TRANS('SHTG_Help_SlashHelp5').." {{"..keyText.."}}") --Clearing Histogram stats for
			private.ClearCache()
		end
	end
end

--[[ Local and Database functions ]]--

function private.UpgradeDB()
	private.UpgradeDB = nil
	if type(AucAdvancedStatHistogramData) == "table" and AucAdvancedStatHistogramData.Version == DATABASE_VERSION then return end

	-- "Upgrade" to Version 3.0: database format has changed completely; we shall wipe the data and start fresh
	AucAdvancedStatHistogramData = {Version = DATABASE_VERSION, RealmData = {}}
end

function private.InitData()
	private.InitData = nil

	private.UpgradeDB()
	RealmData = AucAdvancedStatHistogramData.RealmData
	if not RealmData then
		RealmData = {} -- dummy value to avoid more errors - will not get saved
		error("Error loading or creating "..LIBSTRING.." database")
	end

end


local WriteStore = {}

-- helper function for private.StatTableOpen: Unpack datastring to StatTable
local function UnpackStats(datastring)
	if datastring then
		local minvalue, maxvalue, step, count, newdataItem = strsplit(DATA_DIVIDER,datastring)
		if not newdataItem then
			debugPrint("UnpackStats: datastring is missing data table", LIBSTRING, "Error")
			return
		end
		minvalue, maxvalue, step, count = tonumber(minvalue), tonumber(maxvalue), tonumber(step),  tonumber(count)
		if not minvalue or not maxvalue or not step or not count then
			debugPrint("UnpackStats: datastring is missing control values", LIBSTRING, "Error")
			return
		end
		StatTable.min, StatTable.max, StatTable.step, StatTable.count = minvalue, maxvalue, step, count
		local index = minvalue -- StatTable.min
		for n in newdataItem:gmatch("[0-9]+") do
			StatTable[index] = tonumber(n)
			index = index + 1
		end

		return true -- success
	else
		debugPrint("UnpackStats: No data passed", LIBSTRING, "Error")
	end
end

-- helper function for private.StatTableWrite. Repack StatTable to a datastring. Inverse of UnpackStats
local function RepackStats()
	local minvalue, maxvalue, step, count = StatTable.min, StatTable.max, StatTable.step, StatTable.count
	if not minvalue or not maxvalue or not step or not count or minvalue == 0 or maxvalue == 0 or step == 0 or count == 0 then
		debugPrint("RepackStats: StatTable is missing control values", LIBSTRING, "Error")
		return
	end

	setmetatable(StatTable, meta0)	-- Instead of looping through and checking for nil->0. /Mikk
	local values = tconcat(StatTable, TABLE_DIVIDER, minvalue, maxvalue)
	setmetatable(StatTable, nil)	-- I'm not even sure if this needs to be unset, but I don't want to change the behavior of code I don't fully understand, so unsetting it. /Mikk
									-- currently does need to be unset, as there are places we test for the existence of certain values, to see if StatTable holds valid data -- brykrys

	local datastring = strjoin(DATA_DIVIDER, minvalue, maxvalue, step, count, values)
	return datastring
end

-- Function to load an item into StatTable
-- serverKey, storeID, storeProperty must be validated by caller
-- 'create' is a boolean flag to indicate that the entry should be created if it does not already exist
-- Returns StatTable to indicate success
-- Use private.StatTableWrite to write StatTable back to saved variables
-- Caller must release StatTable by calling private.StatTableClose.
function private.StatTableOpen(serverKey, storeID, storeProperty, create)
	if WriteStore.storeID then
		-- StatTableOpen called without calling StatTableClose on previous entry
		-- assume caused by some error, previous data assumed to be corrupted
		debugPrint("StatTableOpen called without clearing previous WriteStore. ID="..WriteStore.storeID, LIBSTRING, "Error")
		wipe(WriteStore)
	end
	wipe(StatTable) -- ### todo: should already be clear here?

	local currentrealm = RealmData[serverKey]
	if not currentrealm then
		if not create then return end
		currentrealm = {}
		RealmData[serverKey] = currentrealm
	end

	local itemstring = currentrealm[storeID]
	local itemstore, propindex
	if itemstring then
		itemstore = {strsplit(ITEM_DIVIDER, itemstring)}
		for index = 1, #itemstore do
			local prop, datastring = strsplit(PROPERTY_DIVIDER, itemstore[index])
			if prop == storeProperty then
				if UnpackStats(datastring) then -- try to unpack datastring into StatTable
					propindex = index
				elseif create then
					-- UnpackStats failed (corrupted data); it should have left StatTable empty
					-- we are in create mode, so overwrite this index with new data
					propindex = index
				else
					-- UnpackStats failed, we are not in create mode
					-- remove corrupted data, repack, and bail out
					tremove(itemstore, index)
					currentrealm[storeID] = tconcat(itemstore, ITEM_DIVIDER)
					return
				end
				break -- we found the matching property, no need to search further
			end
		end
	elseif create then
		itemstore = {}
	else
		return
	end

	if not propindex then
		if not create then return end
		propindex = #itemstore + 1
	end

	WriteStore.storeID = storeID
	WriteStore.storeProperty = storeProperty
	WriteStore.serverKey = serverKey
	WriteStore.itemstore = itemstore
	--WriteStore.data = StatTable
	WriteStore.index = propindex

	return StatTable -- return non-nil to signal success
end

-- Called after StatTableOpen, and after StatTable has been modified, to write data back to saved variables
-- serverKey, storeID, storeProperty should match the last call to StatTableOpen; this is a debug check (may be removed in future)
-- StatTableWrite may be called multiple times after a call to StatTableOpen, up until StatTable is "closed" by StatTableClose
function private.StatTableWrite(serverKey, storeID, storeProperty)
	if not WriteStore.storeID then
		debugPrint("StatTableWrite: no data in WriteStore", LIBSTRING, "Error")
		return
	end
	if serverKey ~= WriteStore.serverKey or storeID ~= WriteStore.storeID or storeProperty ~= WriteStore.storeProperty then
		debugPrint("StatTableWrite: parameters do not match WriteStore"..
			format("\nParameters serverKey %s, storeID %s, storeProperty %s", tostringall(serverKey, storeID, storeProperty))..
			format("\nWriteStore serverKey %s, storeID %s, storeProperty %s", tostringall(WriteStore.serverKey, WriteStore.storeID, WriteStore.storeProperty)),
			LIBSTRING,
			"Error"
		)
		return
	end

	local itemstore = WriteStore.itemstore
	local datastring = RepackStats()
	if datastring then
		itemstore[WriteStore.index] = WriteStore.storeProperty..PROPERTY_DIVIDER..datastring
		RealmData[serverKey][WriteStore.storeID] = tconcat(itemstore, ITEM_DIVIDER)
	else
		tremove(itemstore, WriteStore.index)
		if #itemstore >= 1 then
			RealmData[serverKey][WriteStore.storeID] = tconcat(itemstore, ITEM_DIVIDER)
		else
			RealmData[serverKey][WriteStore.storeID] = nil
		end
	end
end

-- Mark the current StatTable as "closed", signalling that all work is complete on the current item
-- Block any futher calls to StatTableWrite on this entry
function private.StatTableClose()
	wipe(WriteStore)
	wipe(StatTable)
end

-- Function to search for a specific record, and delete it if found
-- Implemented as a shortcut, without going through the StatTableOpen/Write/Close functions
-- returns true if found and deleted, nil otherwise
function private.FindRemoveEntry(serverKey, storeID, storeProperty)
	if WriteStore.storeID then
		-- FindRemoveEntry called while StatTableOpen still has data open for writing
		-- as above, assume caused by some error, previous data assumed to be corrupted
		debugPrint("FindRemoveEntry called without clearing previous WriteStore. ID="..WriteStore.storeID, LIBSTRING, "Error")
		wipe(WriteStore)
		wipe(StatTable)
	end

	local currentrealm = RealmData[serverKey]
	if not currentrealm then return end

	local itemstring = currentrealm[storeID]
	if not itemstring then return end

	if not storeProperty then -- request to delete all entries for storeID, regardless of properties
		currentrealm[storeID] = nil
		return true
	end

	local itemstore = {strsplit(ITEM_DIVIDER, itemstring)}
	local storecount = #itemstore
	for index = 1, storecount do
		local prop, datastring = strsplit(PROPERTY_DIVIDER, itemstore[index])
		if prop == storeProperty then
			if storecount == 1 then -- there is only one entry in this storeID, and it matches, so delete the whole storeID record
				currentrealm[storeID] = nil
			else -- there were multiple properties for this storeID; remove the matching one, and repack
				tremove(itemstore, index)
				currentrealm[storeID] = tconcat(itemstore, ITEM_DIVIDER)
			end
			return true
		end
	end
end

--private.refactor(pmax, precision)
--pmax is the max for the distribution
--redistributes the price data so that pmax is at precision
--this does cause some loss of accuracy, but should only be necessary every once in a great while
--and increases future accuracy.
--If data points would end up having an index > 300, they get cut off.  They're more than 3x market price, and should not be taken into account anyway
--called by the GetPrice function when median is detected as being too far off an index of 100
--Also called when adding new data early on that would push the max up.
local newstats = {}
function private.refactor(pmax, precision)
	-- we've had report of a NaN sneaking in here somehow...
	if type(pmax)~="number" or pmax == 0 or pmax ~= pmax or StatTable.step == 0 then
		debugPrint("private.refactor - invalid parameters", LIBSTRING, "Error")
		return
	end

	local newstep = ceil(pmax / precision)
	local conversion = StatTable.step / newstep
	local newmin = ceil(conversion * StatTable.min)
	local newmax = ceil(conversion * StatTable.max)
	if newmax > 300 then
		--we need to crop off the top end
		newmax = 300
		StatTable.max = floor(300 / conversion)
	end
	local newcount = 0
	for i = newmin, newmax do
		newstats[i] = 0
	end

	for oldindex = StatTable.min, StatTable.max do
		local curcount = StatTable[oldindex]
		local newindex = ceil(conversion * oldindex)
		newstats[newindex]= (newstats[newindex] or 0) + curcount -- ### todo: is the 0 check really needed?
		newcount = newcount + curcount
	end
	while newstats[newmax] == 0 and newmax > newmin do
		-- if we cropped newmax above, we could end up with a lot of trailing 0's at the top end of newstats
		-- decrement newmax until we finc a non-zero entry; also nil out the 0 value so it doesn't get copied later
		newstats[newmax] = nil
		newmax = newmax - 1
	end
	-- ### todo: is it possible to get 0's at the bottom end of newstats too?

	wipe(StatTable)
	for i,j in pairs(newstats) do
		StatTable[i] = j
	end
	StatTable.min = newmin
	StatTable.max = newmax
	StatTable.step = newstep
	StatTable.count = newcount

	wipe(newstats)
end

-- GetServerKeyList
function lib.GetServerKeyList()
	if not RealmData then return end
	local list = {}
	for serverKey in pairs(RealmData) do
		tinsert(list, serverKey)
	end
	return list
end

-- ChangeServerKey
function lib.ChangeServerKey(oldKey, newKey)
	if not RealmData then return end
	local oldData = RealmData[oldKey]
	RealmData[oldKey] = nil
	if oldData and newKey then
		RealmData[newKey] = oldData
		-- any prior data for newKey will be discarded (simplest implementation)
	end
end


AucAdvanced.RegisterRevision("$URL: Auc-Stat-Histogram/StatHistogram.lua $", "$Rev: 6366 $")
