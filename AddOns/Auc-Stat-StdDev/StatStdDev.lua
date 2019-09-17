--[[
	Auctioneer - Standard Deviation Statistics module
	Version: 8.2.6369 (SwimmingSeadragon)
	Revision: $Id: StatStdDev.lua 6369 2019-09-13 05:07:31Z none $
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

local libType, libName = "Stat", "StdDev"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end

local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill, _TRANS = AucAdvanced.GetModuleLocals()
local Resources = AucAdvanced.Resources
local AucGetStoreKeyFromLink = AucAdvanced.API.GetStoreKeyFromLink
local ResolveServerKey = AucAdvanced.ResolveServerKey
local GetServerKeyText = AucAdvanced.GetServerKeyText

local DATABASE_VERSION = 2
local PET_BAND = 5
local MAX_DATAPOINTS = 100

-- Constants used when creating a PDF:
local BASE_WEIGHT = 1
local STDDEV_PDF_SCALE = 1 -- tuning value to adjust the stddev used in the PDF function
	-- for future - intended to be used to balance the PDF against other Stat modules (currently set to 1 for 'no effect')
	-- reducing STDDEV_PDF_SCALE makes the PDF 'stronger' compared to other modules, inceasing makes it 'weaker' - without adjusting the area/weight
-- Clamping limits for stddev relative to mean
local CLAMP_STDDEV_LOWER = 0.02
local CLAMP_STDDEV_UPPER = 1
local OVERCLAMP_WEIGHT_FACTOR = 0.5 -- tuning value to control how rapidly weight gets reduced as (stddev/mean) increases beyond the upper clamp limit.
	-- a lower value of OVERCLAMP_WEIGHT_FACTOR causes the weight to fall more slowly as stddev rises, and the lowest possible weight will tend toward (1-OVERCLAMP_WEIGHT_FACTOR)
	-- has no effect in cases where stddev does not exceed the upper clamp limit
-- Adjustments when seen count is very low (in this case, auctionscount)
local LOWSEEN_MINIMUM = 1 -- lowest possible count for a valid PDF
-- Weight taper for low seen count
local TAPER_THRESHOLD = 10 -- seen count at which we stop making adjustments
local TAPER_WEIGHT = .1 -- weight multiplier at LOWSEEN_MINIMUM
local TAPER_SLOPE = (1 - TAPER_WEIGHT) / (TAPER_THRESHOLD - LOWSEEN_MINIMUM)
local TAPER_OFFSET = TAPER_WEIGHT - LOWSEEN_MINIMUM * TAPER_SLOPE
-- StdDev Estimate for low seen count
-- Note: ESTIMATE_FACTOR / (ESTIMATE_THRESHOLD - 1) should be >= CLAMP_STDDEV_LOWER
local ESTIMATE_THRESHOLD = 10
local ESTIMATE_FACTOR = 0.33

local tonumber,strsplit,select,pairs=tonumber,strsplit,select,pairs
local setmetatable=setmetatable
local wipe=wipe
local floor,ceil,abs=floor,ceil,abs
local tconcat=table.concat
local tinsert,tremove=table.insert,table.remove
-- GLOBALS: AucAdvancedStatStdDevData


local pricecache = {}

local ZValues = {.063, .126, .189, .253, .319, .385, .454, .525, .598, .675, .756, .842, .935, 1.037, 1.151, 1.282, 1.441, 1.646, 1.962, 20, 20000}

-- Wrapper around AucAdvanced.API.GetStoreKeyFromLink to customize it for Stat-StdDev
local GetStoreKey = function(link)
	local id, property, linktype = AucGetStoreKeyFromLink(link, PET_BAND)
	if linktype == "item" then
		-- use number here so we don't need to convert older database
		return tonumber(id), property
	elseif linktype == "battlepet" then
		-- add "P" marker to battlepet ID
		return "P"..id, property
	end
end

function lib.CommandHandler(command, ...)
	local serverKey = Resources.ServerKey
	local keyText = GetServerKeyText(serverKey)
	if (command == "help") then
		aucPrint(_TRANS('SDEV_Help_SlashHelp1') )--Help for Auctioneer - StdDev
		local line = AucAdvanced.Config.GetCommandLead(libType, libName)
		aucPrint(line, "help}} - ".._TRANS('SDEV_Help_SlashHelp2') ) --this StdDev help
		aucPrint(line, "clear}} - ".._TRANS('SDEV_Help_SlashHelp3'):format(keyText) ) --clear current %s StdDev price database
	elseif (command == "clear") then
		lib.ClearData(serverKey)
	end
end

lib.Processors = {}
function lib.Processors.itemtooltip(callbackType, ...)
	lib.ProcessTooltip(...)
end
lib.Processors.battlepettooltip = lib.Processors.itemtooltip
function lib.Processors.config(callbackType, gui)
	--Called when you should build your Configator tab.
	if private.SetupConfigGui then private.SetupConfigGui(gui) end
end
function lib.Processors.scanstats()
	wipe(pricecache)
end
function lib.Processors.gameactive()
	if private.LookForOldData then private.LookForOldData() end
end

lib.ScanProcessors = {}
function lib.ScanProcessors.create(operation, itemData, oldData)
	if not get("stat.stddev.enable") then return end

	-- We're only interested in items with buyouts.
	local buyout = itemData.buyoutPrice
	if not buyout or buyout == 0 then return end
	if (itemData.stackSize > 1) then
		buyout = buyout.."/"..itemData.stackSize
	else
		buyout = tostring(buyout)
	end

	-- Get the key for this item and find it's stats.
	local keyId, property = GetStoreKey(itemData.link)
	if not keyId then return end
	local serverdata = private.GetServerData(Resources.ServerKey, true)
	local stats = private.UnpackStats(serverdata[keyId])
	if not stats[property] then stats[property] = {} end

	if #stats[property] >= MAX_DATAPOINTS then
		tremove(stats[property], 1)
	end
	tinsert(stats[property], buyout)
	serverdata[keyId] = private.PackStats(stats)
end

local BellCurve = AucAdvanced.API.GenerateBellCurve()
-----------------------------------------------------------------------------------
-- The PDF for standard deviation data, standard bell curve
-----------------------------------------------------------------------------------
function lib.GetItemPDF(hyperlink, serverKey)
	if not get("stat.stddev.enable") then return end
	-- Get the data
	local average, mean, _, stddev, variance, count, confidence = lib.GetPrice(hyperlink, serverKey)

	if not (average and stddev and count) or average == 0 or count < LOWSEEN_MINIMUM then
		return nil -- No data, cannot determine pricing
	end

	-- The area of the BellCurve can be used to adjust its weight vs other Stat modules
	local area = BASE_WEIGHT
	if count < TAPER_THRESHOLD then
		-- when seen count is very low, reduce weight
		area = area * (count * TAPER_SLOPE + TAPER_OFFSET)
	end

	-- We also allow the StdDev used by the PDF to be scaled, as another method of adjusting relative weight (lower STDDEV_PDF_SCALE gives higher weight)
	stddev = stddev * STDDEV_PDF_SCALE

	-- Extremely large or small values of stddev can cause problems with GetMarketValue
	-- we shall apply limits relative to the mean of the bellcurve (local 'average')
	local clamplower, clampupper = average * CLAMP_STDDEV_LOWER, average * CLAMP_STDDEV_UPPER
	if count < ESTIMATE_THRESHOLD then
		-- We assume that calculated stddev is unreliable at very low seen counts, so we apply a minimum value based on average and count
		-- in particular fixes up the case where count is 1, and stddev is therefore 0
		clamplower = ESTIMATE_FACTOR * average / count
	end
	if stddev < clamplower then
		stddev = clamplower
	elseif stddev > clampupper then
		-- Note that even with this adjustment, 'lower' can still be significantly negative!
		--area = area * clampupper / stddev -- as we're hard capping the stddev, reduce weight to compensate
		area = area * (1 + OVERCLAMP_WEIGHT_FACTOR * (clampupper / stddev - 1)) -- as we're hard capping the stddev, reduce weight to compensate
		stddev = clampupper
	end

	local lower, upper = average - 3 * stddev, average + 3 * stddev

	BellCurve:SetParameters(average, stddev, area)
	return BellCurve, lower, upper, area   -- This has a __call metamethod so it's ok
end

-----------------------------------------------------------------------------------

function private.GetCfromZ(Z)
	--C = 0.05*i
	if (not Z) then
		return .05
	end
	if (Z > 10) then
		return .99
	end
	local i = 1
	while Z > ZValues[i] do
		i = i + 1
	end
	if i == 1 then
		return .05
	else
		i = i - 1 + ((Z - ZValues[i-1]) / (ZValues[i] - ZValues[i-1]))
		return i*0.05
	end
end

local datapoints_price = {}	-- used temporarily in .GetPrice() to avoid unpacking strings multiple times
local datapoints_stack = {}

function lib.GetPrice(hyperlink, serverKey)
	if not get("stat.stddev.enable") then return end
	local keyId, property = GetStoreKey(hyperlink)
	if not keyId then return end
	serverKey = ResolveServerKey(serverKey)
	if not serverKey then return end
	local serverdata = private.GetServerData(serverKey)
	if not serverdata or not serverdata[keyId] then return end

	local cacheKey = serverKey ..":"..keyId..":"..property
	if pricecache[cacheKey] then
		return unpack(pricecache[cacheKey], 1, 7)
	end

	local stats = private.UnpackStats(serverdata[keyId])
	local statsprop = stats[property]
	if not statsprop then return end
	local count = #statsprop
	if (count < 1) then return end

	local total, number = 0, 0
	for i = 1, count do
		local price, stack = strsplit("/", statsprop[i])
		price = tonumber(price) or 0
		stack = tonumber(stack) or 1
		if (stack < 1) then stack = 1 end
		datapoints_price[i] = price		-- cache these for further processing below (so they don't need to strsplit etc)
		datapoints_stack[i] = stack
		total = total + price
		number = number + stack
	end
	local mean = total / number

	if (count < 2) then
		return nil, mean, false, 0, 0, count, 0
	end

	local variance = 0
	for i = 1, count do
		variance = variance + ((mean - datapoints_price[i]/datapoints_stack[i]) ^ 2);
	end

	variance = variance / count;
	local stdev = variance ^ 0.5

	local deviation = 1.5 * stdev

	total = 0	-- recompute them from entries inside the allowed deviation
	number = 0

	for i = 1, count do
		local price,stack = datapoints_price[i], datapoints_stack[i]
		if abs((price/stack) - mean) < deviation then
			total = total + price
			number = number + stack
		end
	end

	local confidence = .01
	local average
	if (number > 0) then	-- number<1  will happen if we have e.g. two big clusters: one at 1g and one at 10g
		average = total / number
		confidence = (.15*average)*(number^0.5)/(stdev)
		confidence = private.GetCfromZ(confidence)
	end

	pricecache[cacheKey] = { average, mean, false, stdev, variance, count, confidence }
	return average, mean, false, stdev, variance, count, confidence
end

function lib.GetPriceColumns()
	return "Average", "Mean", false, "Std Deviation", "Variance", "Count", "Confidence"
end

local array = {}
function lib.GetPriceArray(hyperlink, serverKey)
	if not get("stat.stddev.enable") then return end
	-- Clean out the old array
	wipe(array)

	-- Get our statistics
	local average, mean, _, stdev, variance, count, confidence = lib.GetPrice(hyperlink, serverKey)

	-- These 3 are the ones that most algorithms will look for
	array.price = average or mean
	array.seen = count
	array.confidence = confidence
	-- This is additional data
	array.normalized = average
	array.mean = mean
	array.deviation = stdev
	array.variance = variance

	-- Return a temporary array. Data in this array is
	-- only valid until this function is called again.
	return array
end

function private.SetupConfigGui(gui)
	private.SetupConfigGui = nil
	local id = gui:AddTab(lib.libName, lib.libType.." Modules")
	--gui:MakeScrollable(id)

	gui:AddHelp(id, "what stddev stats",
		_TRANS('SDEV_Help_StdDevStats') ,--What are StdDev stats?
		_TRANS('SDEV_Help_StdDevStatsAnswer') --StdDev stats are the numbers that are generated by the StdDev module consisting of a filtered Standard Deviation calculation of item cost.
		)

	--all options in here will be duplicated in the tooltip frame
	function private.addTooltipControls(id)
		gui:AddHelp(id, "filtered stddev",
			_TRANS('SDEV_Help_Filtered') ,--What do you mean filtered?
			_TRANS('SDEV_Help_FilteredAnswer') --Items outside a (1.5*Standard) variance are ignored and assumed to be wrongly priced when calculating the deviation.
			)

		gui:AddHelp(id, "what standard deviation",
			_TRANS('SDEV_Help_StandardDeviationCalculation') ,--What is a Standard Deviation calculation?
			_TRANS('SDEV_Help_StandardDeviationCalculationAnswer') --In short terms, it is a distance to mean average calculation.
			)

		gui:AddHelp(id, "what normalized",
			_TRANS('SDEV_Help_Normalized') ,--What is the Normalized calculation?
			_TRANS('SDEV_Help_NormalizedAnswer') --In short terms again, it is the average of those values determined within the standard deviation variance calculation.
			)

		gui:AddHelp(id, "what confidence",
			_TRANS('SDEV_Help_Confidence') ,--What does confidence mean?
			_TRANS('SDEV_Help_ConfidenceAnswer') --Confidence is a value between 0 and 1 that determines the strength of the calculations (higher the better).
			)

		gui:AddHelp(id, "why multiply stack size stddev",
			_TRANS('SDEV_Help_WhyMultiplyStack') ,--Why have the option to multiply by stack size?
			_TRANS('SDEV_Help_WhyMultiplyStackAnswer') --The original Stat-StdDev multiplied by the stack size of the item, but some like dealing on a per-item basis.
			)

		gui:AddControl(id, "Header",     0,   _TRANS('SDEV_Interface_StdDevOptions') )--StdDev options
		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
		gui:AddControl(id, "Checkbox",   0, 1, "stat.stddev.enable", _TRANS('SDEV_Interface_EnableStdDevStats') )--Enable StdDev Stats
		gui:AddTip(id, _TRANS('SDEV_HelpTooltip_EnableStdDevStats') )--Allow StdDev to gather and return price data
		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")

		gui:AddControl(id, "Checkbox",   0, 4, "stat.stddev.tooltip", _TRANS('SDEV_Interface_Show') )--Show stddev stats in the tooltips?
		gui:AddTip(id, _TRANS('SDEV_HelpTooltip_Show') )--Toggle display of stats from the StdDev module on or off
		gui:AddControl(id, "Checkbox",   0, 6, "stat.stddev.mean", _TRANS('SDEV_Interface_DisplayMean') )--Display Mean
		gui:AddTip(id, _TRANS('SDEV_HelpTooltip_DisplayMean') )--Toggle display of 'Mean' calculation in tooltips on or off
		gui:AddControl(id, "Checkbox",   0, 6, "stat.stddev.normal", _TRANS('SDEV_Interface_DisplayNormalized') )--Display Normalized
		gui:AddTip(id, _TRANS('SDEV_HelpTooltip_DisplayNormalized') )--Toggle display of 'Normalized' calculation in tooltips on or off'
		gui:AddControl(id, "Checkbox",   0, 6, "stat.stddev.stdev", _TRANS('SDEV_Interface_DisplayStandardDeviation') )--Display Standard Deviation
		gui:AddTip(id,_TRANS('SDEV_HelpTooltip_DisplayStandardDeviation') )--Toggle display of 'Standard Deviation' calculation in tooltips on or off
		gui:AddControl(id, "Checkbox",   0, 6, "stat.stddev.confid", _TRANS('SDEV_Interface_DisplayConfidence') )--Display Confidence
		gui:AddTip(id,_TRANS('SDEV_HelpTooltip_DisplayConfidence') )--Toggle display of 'Confidence' calculation in tooltips on or off
		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
		gui:AddControl(id, "Checkbox",   0, 4, "stat.stddev.quantmul", _TRANS('SDEV_Interface_MultiplyStack') )--Multiply by Stack Size
		gui:AddTip(id,_TRANS('SDEV_HelpTooltip_MultiplyStack') )--Multiplies by current stack size if on
		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
	end
	--This is the Tooltip tab provided by aucadvnced so all tooltip configuration is in one place
	local tooltipID = AucAdvanced.Settings.Gui.tooltipID

	--now we create a duplicate of these in the tooltip frame
	private.addTooltipControls(id)
	if tooltipID then private.addTooltipControls(tooltipID) end
end

function lib.ProcessTooltip(tooltip, hyperlink, serverKey, quantity, decoded, additional, order)
	-- In this function, you are afforded the opportunity to add data to the tooltip should you so
	-- desire. You are passed a hyperlink, and it's up to you to determine whether or what you should
	-- display in the tooltip.

	if not get("stat.stddev.tooltip") then return end

	if not quantity or quantity < 1 then quantity = 1 end
	if not get("stat.stddev.quantmul") then quantity = 1 end
	local average, mean, _, stdev, var, count, confidence = lib.GetPrice(hyperlink, serverKey)

	if (mean and mean > 0) then
		tooltip:AddLine(_TRANS('SDEV_Tooltip_PricesPoints'):format(count) )--StdDev prices %d points:

		if get("stat.stddev.mean") then
			tooltip:AddLine("  ".._TRANS('SDEV_Tooltip_MeanPrice'), mean*quantity)-- Mean price
		end
		if (average and average > 0) then
			if get("stat.stddev.normal") then
				tooltip:AddLine("  ".._TRANS('SDEV_Tooltip_Normalized'), average*quantity)--  Normalized
				if (quantity > 1) then
					tooltip:AddLine("  ".._TRANS('SDEV_Tooltip_Individually'), average)--  (or individually)
				end
			end
			if get("stat.stddev.stdev") then
				tooltip:AddLine("  ".._TRANS('SDEV_Tooltip_StdDeviation'), stdev*quantity)--  Std Deviation
                if (quantity > 1) then
                    tooltip:AddLine("  ".._TRANS('SDEV_Tooltip_Individually'), stdev)--  (or individually)
                end

			end
			if get("stat.stddev.confid") then
				tooltip:AddLine("  ".._TRANS('SDEV_Tooltip_Confidence')..(floor(confidence*1000))/1000)-- Confidence:
			end
		end
	end
end

function lib.OnLoad(addon)
	if not private.InitData then return end

	default("stat.stddev.tooltip", false)
	default("stat.stddev.mean", false)
	default("stat.stddev.normal", false)
	default("stat.stddev.stdev", true)
	default("stat.stddev.confid", true)
	default("stat.stddev.quantmul", true)
	default("stat.stddev.enable", true)

	private.InitData()
end


--[[ Private functions ]]--

function private.UnpackStatIter(data, ...)
	local c = select("#", ...)
	local v
	for i = 1, c do
		v = select(i, ...)
		local property, info = strsplit(":", v)
		if (property and info) then
			data[property] = {strsplit(";", info)}
			-- don't tonumber the entries in this table yet
		end
	end
end
function private.UnpackStats(dataItem)
	local data = {}
	if (dataItem) then
		private.UnpackStatIter(data, strsplit(",", dataItem))
	end
	return data
end

local tmp={}
function private.PackStats(data)
	local n=0
	for property, info in pairs(data) do
		n=n+1
		tmp[n]=property..":"..tconcat(info, ";")
	end
	return tconcat(tmp,",",1,n)
end

--[[ Database functions ]]--
local SSDRealmData

function private.UpgradeDB()
	private.UpgradeDB = nil

	local saved = AucAdvancedStatStdDevData

	if saved and saved.Version == DATABASE_VERSION then return end

	AucAdvancedStatStdDevData = {
		Version = DATABASE_VERSION,
		RealmData = {},
	}

	if saved and not saved.Version then
		-- original version: should be a table with simple format [serverKey] = {<data>}
		-- used old-style serverKeys; we want to upgrade to new-style
		-- internal format of {<data>} is unchanged

		for serverKey, data in pairs(saved) do
			if type(data) ~= "table" or not next(data) then -- don't keep invalid entries or empty tables
				saved[serverKey] = nil
			else
				local realm, faction = AucAdvanced.SplitServerKey(serverKey)
				if not realm or faction == "Neutral" then -- don't keep invalid or neutral (old style) serverKeys
					saved[serverKey] = nil
				end
			end
		end

		if next(saved) then
			AucAdvancedStatStdDevData.OldRealmData = saved
			saved.expires = time() + 1209600 -- 60 * 60 * 24 * 14 = 14 days
		end
	end
end

function private.LookForOldData()
	private.LookForOldData = nil

	local oldrealms = AucAdvancedStatStdDevData.OldRealmData
	if not oldrealms then return end

	local newKey = Resources.ServerKey
	if  not SSDRealmData[newKey] then
		-- prefer home faction, but use opposing if no home data
		SSDRealmData[newKey] = oldrealms[Resources.ServerKeyHome] or oldrealms[Resources.ServerKeyOpposing]
	end

	if not oldrealms.expires or time() > oldrealms.expires then
		AucAdvancedStatStdDevData.OldRealmData = nil
	else
		oldrealms[Resources.ServerKeyHome] = nil
		oldrealms[Resources.ServerKeyOpposing] = nil
	end
end

function lib.ClearItem(hyperlink, serverKey)
	local keyId, property = GetStoreKey(hyperlink)
	if not keyId then return end

	serverKey = ResolveServerKey(serverKey)
	if SSDRealmData[serverKey] and SSDRealmData[serverKey][keyId] then
		local stats = private.UnpackStats(SSDRealmData[serverKey][keyId])
		if stats[property] then
			stats[property] = nil
			SSDRealmData[serverKey][keyId] = private.PackStats(stats)
			wipe(pricecache)
			local keyText = GetServerKeyText(serverKey)
			aucPrint(libType.._TRANS('SDEV_Interface_ClearingData'):format(hyperlink, keyText))--- StdDev: clearing data for %s for {{%s}}
		end
	end
end

function lib.ClearData(serverKey)
	if serverKey and AucAdvanced.API.IsKeyword(serverKey, "ALL") then
		wipe(SSDRealmData)
		wipe(pricecache)
		aucPrint(_TRANS('SDEV_Help_SlashHelp4').." {{".._TRANS("ADV_Interface_AllRealms").."}}") --Clearing StdDev stats for // All realms
		return
	end
	serverKey = ResolveServerKey(serverKey)
	if SSDRealmData[serverKey] then
		SSDRealmData[serverKey] = nil
		wipe(pricecache)
		local keyText = GetServerKeyText(serverKey)
		aucPrint(_TRANS('SDEV_Help_SlashHelp4').." {{"..keyText.."}}") --Clearing StdDev stats for
	end
end

function private.GetServerData(serverKey, create)
	local data = SSDRealmData[serverKey]
	if not data and create then
		data = {}
		SSDRealmData[serverKey] = data
	end
	return data
end

function private.InitData()
	private.InitData = nil

	-- Do any database upgrades here
	if private.UpgradeDB then private.UpgradeDB() end

	SSDRealmData = AucAdvancedStatStdDevData.RealmData
	if not SSDRealmData then
		SSDRealmData = {} -- dummy value to avoid more errors - will not get saved
		error("Error loading or creating Stat-StdDev database")
	end

	-- Do any regular database maintenance here
end

function lib.GetServerKeyList()
	if not SSDRealmData then return end
	local list = {}
	for serverKey in pairs(SSDRealmData) do
		tinsert(list, serverKey)
	end
	return list
end

function lib.ChangeServerKey(oldKey, newKey)
	if not SSDRealmData then return end
	local oldData = SSDRealmData[oldKey]
	SSDRealmData[oldKey] = nil
	if oldData and newKey then
		SSDRealmData[newKey] = oldData
		-- if there was data for newKey then it will be discarded (simplest implementation)
	end
end

AucAdvanced.RegisterRevision("$URL: Auc-Stat-StdDev/StatStdDev.lua $", "$Rev: 6369 $")
