--[[
Auctioneer - StatSimple
Version: 8.2.6399 (SwimmingSeadragon)
Revision: $Id: StatSimple.lua 6399 2019-09-22 00:20:05Z none $
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

local libType, libName = "Stat", "Simple"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end

local aucPrint,decode,_,_,replicate,_,get,set,default,debugPrint,fill, L = AucAdvanced.GetModuleLocals()
local Resources = AucAdvanced.Resources
local GetStoreKey = AucAdvanced.API.GetStoreKeyFromLinkB
local ResolveServerKey = AucAdvanced.ResolveServerKey

local DATABASE_VERSION = 3.0
local DATA_DIVIDER = ";"
local PROPERTY_DIVIDER = "@"
local ITEM_DIVIDER = "_"
local PET_BAND = 10
local PUSHTIME = 57600 -- 60 * 60 * 16; schedule next "daily" push after 16 hours

-- Constants used when creating a PDF:
local BASE_WEIGHT = 1
-- Clamping limits for stddev relative to mean
local CLAMP_STDDEV_LOWER = 0.01
local CLAMP_STDDEV_UPPER = 1
-- Adjustments when seen count is very low (seen days in this case)
local LOWSEEN_MINIMUM = 0 -- lowest possible count for a valid PDF
-- Weight taper for low seen count
local TAPER_THRESHOLD = 8 -- seen count at which we stop making adjustments
local TAPER_WEIGHT = .1 -- weight multiplier at LOWSEEN_MINIMUM
local TAPER_SLOPE = (1 - TAPER_WEIGHT) / (TAPER_THRESHOLD - LOWSEEN_MINIMUM)
local TAPER_OFFSET = TAPER_WEIGHT - LOWSEEN_MINIMUM * TAPER_SLOPE
-- StdDev Estimate for low seen count
local ESTIMATE_THRESHOLD = 13
local ESTIMATE_FACTOR = 0.33

-- Eliminate some global lookups
local sqrt = sqrt
local ipairs = ipairs
local unpack = unpack
local tinsert = table.insert
local tonumber = tonumber
local pairs = pairs
local time, wipe, ceil = time, wipe, ceil
local tconcat = table.concat
local strsplit = strsplit
-- GLOBALS: AucAdvancedStatSimpleData

function lib.CommandHandler(command, ...)
	local serverKey = Resources.ServerKey
	local keyText = AucAdvanced.GetServerKeyText(serverKey)
	if (command == "help") then
		aucPrint(L'SIMP_Help_SlashHelp1') --Help for Auctioneer Advanced - Simple
		local line = AucAdvanced.Config.GetCommandLead(libType, libName)
		aucPrint(line, "help}} - "..L'SIMP_Help_SlashHelp2') --this Simple help
		aucPrint(line, "clear}} - "..L('SIMP_Help_SlashHelp3'):format(keyText) ) --clear current %s Simple price database
		aucPrint(line, "push}} - "..L('SIMP_Help_SlashHelp4'):format(keyText) ) --force the %s Simple daily stats to archive (start a new day)
	elseif (command == "clear") then
		lib.ClearData(serverKey)
	elseif (command == "push") then
		aucPrint(L('SIMP_Help_SlashHelp6'):format(keyText) ) --Archiving {{%s}} daily stats and starting a new day
		private.PushStats(serverKey)
	end
end

lib.Processors = {
	itemtooltip = function(callbackType, ...)
		private.ProcessTooltip(...)
	end,
	config = function(callbackType, gui)
		if private.SetupConfigGui then private.SetupConfigGui(gui) end
	end,
}
lib.Processors.battlepettooltip = lib.Processors.itemtooltip

lib.ScanProcessors = {
	create = function(operation, itemData, oldData)
		if not get("stat.simple.enable") then return end
		local buyout = itemData.buyoutPrice
		if not buyout or buyout == 0 then return end -- We're only interested in items with buyouts
		local storeID, storeProperty = GetStoreKey(itemData.link, PET_BAND)
		if not storeID then return end -- Link does not produce a valid store key

		local stack = itemData.stackSize
		local buyoutper = ceil(buyout/stack)
		local serverKey = Resources.ServerKey
		local data0, dataP = private.GetItemDataWrite(serverKey, storeID, storeProperty)
		--[[ data = {
			[1] = total buyout,
			[2] = seen count,
			[3] = today's minimum buyout,
			[4] = auctions count, (only recorded if different from seen count)
		}--]]

		if data0 then
			local aucs = data0[4]
			if aucs then
				data0[4] = aucs + 1
			elseif stack > 1 then
				-- no recorded auctions count, so auctions count must have been equal to seen count up to this point
				data0[4] = data0[2] + 1
			end
			local mbo = data0[3]
			if mbo == 0 or buyoutper < mbo then
				data0[3] = buyoutper
			end
			data0[2] = data0[2] + stack
			data0[1] = data0[1] + buyout
		end

		if dataP then
			local aucs = dataP[4]
			if aucs then
				dataP[4] = aucs + 1
			elseif stack > 1 then
				-- no recorded auctions count, so auctions count must have been equal to seen count up to this point
				dataP[4] = dataP[2] + 1
			end
			local mbo = dataP[3]
			if mbo == 0 or buyoutper < mbo then
				dataP[3] = buyoutper
			end
			dataP[2] = dataP[2] + stack
			dataP[1] = dataP[1] + buyout
		end

		private.WriteItemData(serverKey, storeID, storeProperty)
	end,
}

local valueset, weightset = {}, {}
function lib.GetPrice(hyperlink, serverKey)
	if not get("stat.simple.enable") then return end
	serverKey = ResolveServerKey(serverKey)
	if not serverKey then return end
	local storeID, storeProperty, linktype = GetStoreKey(hyperlink, PET_BAND)
	if not storeID then return end
	if get("stat.simple.basemode") then storeProperty = "0" end -- change storeProperty to "0" if user requested base item (transmog) mode
	local dailydata, meansdata = private.GetItemDataRead(serverKey, storeID, storeProperty)
	if not (dailydata or meansdata) then
		if storeProperty ~= "0" and get("stat.simple.fallback") then -- fallback mode: see if data exists for property "0"
			dailydata, meansdata = private.GetItemDataRead(serverKey, storeID, "0")
		end
		if not (dailydata or meansdata) then
			return
		end
	end

	local dayTotal, dayCount, dayAverage, minBuyout,dayAuctions = 0, 0, 0, 0, 0
	local seenDays, seenCount, avg3, avg7, avg14, avgmins, auctionsCount = 0, 0, 0, 0, 0, 0, 0
	local mean, stddev = 0, 0

	if dailydata then
		dayTotal, dayCount, minBuyout, dayAuctions = unpack(dailydata)
		if dayCount > 0 then
			dayAverage = dayTotal/dayCount
		else
			dailydata = nil -- this is an empty dummy entry (only possible for property "0"), unflag so we don't try to use it in calculations
		end
		dayAuctions = dayAuctions or dayCount
	end
	if meansdata then
		seenDays, seenCount, avg3, avg7, avg14, avgmins, auctionsCount = unpack(meansdata)
		auctionsCount = auctionsCount or seenCount
		if seenDays <= 3 then -- Stat-Simple doesn't start calculating EMAs until day 4
			mean = avg3
			if dailydata then
				mean = (mean * seenDays + dayAverage) / (seenDays + 1)
			end
		else
			-- we have 4 or more days of data, potentially enough to perform mean and stddev calculations
			local count = 0

			-- include daily data if available
			if dailydata then
				count = 1
				valueset[count] = dayAverage
				weightset[count] = 1
			end

			-- EMA3: standard weight 3, reduced if seenDays < 6, reduced if there was daily data, but never less than 1
			local weight = 3 - count
			if seenDays < 6 then
				weight = seenDays - 3
				if weight > 1 then
					weight = weight - count
				end
			end
			count = count + 1
			valueset[count] = avg3
			weightset[count] = weight

			-- EMA7: standard weight 4, reduced if seenDays < 10
			if seenDays > 6 then
				count = count + 1
				valueset[count] = avg7
				if seenDays < 10 then
					weightset[count] = seenDays - 6
				else
					weightset[count] = 4
				end
			end

			-- EMA14: standard weight 7, reduced if seenDays < 17
			if seenDays > 10 then
				count = count + 1
				valueset[count] = avg14
				if seenDays < 17 then
					weightset[count] = seenDays - 10
				else
					weightset[count] = 7
				end
			end

			if count >= 2 then
				-- we will use a weighted incremental algorithm, based on sample code by West and Knuth http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
				local sumWeight, sumSquares = 0, 0 -- actually "sum of squares of differences from the (current) mean", but that's rather long for a variable name.
				for i = 1, count do
					local value, weight = valueset[i], weightset[i]
					local nextweight = weight + sumWeight
					local valuediff = value - mean
					local meanadjust = valuediff * weight / nextweight
					mean = mean + meanadjust
					sumSquares = sumSquares + sumWeight * valuediff * meanadjust
					sumWeight = nextweight
				end

				stddev = sqrt(sumSquares / sumWeight * count / (count - 1))
			else -- only EMA3 was available
				mean = avg3
			end
		end
	else -- no means data, use only daily
		mean = dayAverage
	end

	return dayAverage, avg3, avg7, avg14, minBuyout, avgmins, false, dayTotal, dayCount, seenDays, seenCount, mean, stddev, dayAuctions, auctionsCount
end

function lib.GetPriceColumns()
	return "Daily Avg", "3 Day Avg", "7 Day Avg", "14 Day Avg", "Min BO", "Avg MBO", false, "Daily Total", "Daily Count", "Seen Days", "Seen Count", "Mean", "StdDev", "Daily Auctions", "Auctions Count"
end

local array = {}
function lib.GetPriceArray(hyperlink, serverKey)
	local dayAverage, avg3, avg7, avg14, minBuyout, avgmins, _, dayTotal, dayCount, seenDays, seenCount, mean, stddev, dayAuctions, auctionsCount = lib.GetPrice(hyperlink, serverKey)
	if not dayCount then return end

	wipe(array)
	array.price = mean
	array.stddev = stddev
	array.seen = seenCount
	array.auctions = auctionsCount
	array.avgday = dayAverage
	array.avg3 = avg3
	array.avg7 = avg7
	array.avg14 = avg14
	array.mbo = minBuyout
	array.avgmins = avgmins
	array.daytotal = dayTotal
	array.daycount = dayCount
	array.dayauctions = dayAuctions
	array.seendays = seenDays

	-- Return a temporary array. Data in this array is
	-- only valid until this function is called again.
	return array
end

local bellCurve = AucAdvanced.API.GenerateBellCurve()
-- Gets the PDF curve for a given item. This curve indicates
-- the probability of an item's mean price. Uses an estimation
-- of the normally distributed bell curve by performing
-- calculations on the daily, 3-day, 7-day, and 14-day averages
-- stored by SIMP
-- @param hyperlink The item to generate the PDF curve for
-- @param serverKey The realm-faction key from which to look up the data
-- @return The PDF for the requested item, or nil if no data is available
-- @return The lower limit of meaningful data for the PDF
-- @return The upper limit of meaningful data for the PDF
-- @return The area of the PDF
function lib.GetItemPDF(hyperlink, serverKey)
	-- Calculate the SE estimated standard deviation & mean
	local dayAverage, avg3, avg7, avg14, minBuyout, avgmins, _, dayTotal, dayCount, seenDays, seenCount, mean, stddev = lib.GetPrice(hyperlink, serverKey)

	if not (mean and stddev and seenDays) or mean == 0 or seenDays < LOWSEEN_MINIMUM then
		return -- No available data or cannot estimate
	end

	local area = BASE_WEIGHT
	if seenDays < TAPER_THRESHOLD then
		-- when seenDays is very low, reduce weight
		area = area * (seenDays * TAPER_SLOPE + TAPER_OFFSET)
	end

	-- Extremely large or small values of stddev can cause problems with GetMarketValue
	-- we shall apply limits relative to the mean of the bellcurve
	local clamplower, clampupper = mean * CLAMP_STDDEV_LOWER, mean * CLAMP_STDDEV_UPPER

	if seenDays < ESTIMATE_THRESHOLD then
		-- when seenDays is low, stddev will typically be extremely low (or 0),
		-- because the EMAs won't have had time to drift very far apart yet.
		-- we shall estimate (i.e. fake) stddev based on mean and seenDays
		if seenDays <= 3 then
			-- when seenDays is less than or equal to 3 there will not be any EMA7 or EMA14 data yet
			-- 'real' stddev will normally be 0
			-- use the maximum allowable 'fake' stddev
			stddev = clampupper
		else
			clamplower = ESTIMATE_FACTOR * mean / (seenDays - 3)
		end
		-- todo: this is a very rough formula, can anyone improve it? (see also Stat-Purchased)
		-- note: originally we only checked if stddev == 0,
		-- in which case we substituted stddev = mean / sqrt(seenCount)
	end

	if stddev < clamplower then
		stddev = clamplower
	elseif stddev > clampupper then
		-- Note that even with this adjustment, 'lower' can still be significantly negative!
		area = area * clampupper / stddev -- as we're hard capping the stddev, reduce weight to compensate
		stddev = clampupper
	end

	-- Calculate the lower and upper bounds as +/- 3 standard deviations
	local lower, upper = mean - 3*stddev, mean + 3*stddev

	bellCurve:SetParameters(mean, stddev, area)
	return bellCurve, lower, upper, area
end

function lib.OnLoad(addon)
	if private.InitData then -- Load and check data
		private.InitData()
	else -- already loaded
		return
	end

	-- Set defaults
	default("stat.simple.tooltip", false)
	default("stat.simple.average", true)

	default("stat.simple.avg3", false)
	default("stat.simple.avg7", false)
	default("stat.simple.avg14", false)
	default("stat.simple.minbuyout", true)
	default("stat.simple.avgmins", true)
	default("stat.simple.stddev", false)
	default("stat.simple.quantmul", true)

	default("stat.simple.enable", true)

	default("stat.simple.fallback", true)
	default("stat.simple.basemode", false)

	set("stat.simple.reportsafe", nil)
end


function private.SetupConfigGui(gui)
	private.SetupConfigGui = nil
	local id = gui:AddTab(lib.libName, lib.libType.." Modules" )

	gui:AddControl(id, "Header",     0,    L'SIMP_Interface_SimpleOptions')--Simple options'
	gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
	gui:AddControl(id, "Checkbox",   0, 1, "stat.simple.enable", L'SIMP_Interface_EnableSimpleStats')--Enable Simple Stats
	gui:AddTip(id, L'SIMP_HelpTooltip_EnableSimpleStats')--Allow Simple Stats to gather and return price data

	gui:AddHelp(id, "what simple stats",
	L'SIMP_Help_SimpleStats',--What are simple stats?
	L'SIMP_Help_SimpleStatsAnswer'
	)--Simple stats are the numbers that are generated by the Simple module, the Simple module averages all of the prices for items that it sees and provides moving 3, 7, and 14 day averages.  It also provides daily minimum buyout along with a running average minimum buyout within 10% variance.

	--all options in here will be duplicated in the tooltip frame
	local function addTooltipControls(id)
		gui:AddHelp(id, "what moving day average",
		L'SIMP_Help_MovingAverage' , --What does \'moving day average\' mean?
		L'SIMP_Help_MovingAverageAnswer' --Moving average means that it places more value on yesterday\'s moving averagethan today\'s average.  The determined amount is then used for tomorrow\'s moving average calculation.
		)

		gui:AddHelp(id, "how day average calculated",
		L'SIMP_Help_HowAveragesCalculated', --How is the moving day averages calculated exactly?
		L'SIMP_Help_HowAveragesCalculatedAnswer' --Todays Moving Average is ((X-1)*YesterdaysMovingAverage + TodaysAverage) / X, where X is the number of days (3,7, or 14).
		)

		gui:AddHelp(id, "no day saved",
		L'SIMP_Help_NoDaySaved',--So you aren't saving a day-to-day average?
		L'SIMP_Help_NoDaySavedAnswer')--No, that would not only take up space, but heavy calculations on each auction house scan, and this is only a simple model.

		gui:AddHelp(id, "minimum buyout",
		L'SIMP_Help_MinimumBuyout',--Why do I need to know minimum buyout?
		L'SIMP_Help_MinimumBuyoutAnswer'--While some items will sell very well at average within 2 days, others may sell only if it is the lowest price listed.  This was an easy calculation to do, so it was put in this module.
		)

		gui:AddHelp(id, "average minimum buyout",
		L'SIMP_Help_AverageMinimumBuyout',--What's the point in an average minimum buyout?
		L'SIMP_Help_AverageMinimumBuyoutAnswer'--This way you know how good a market is dealing.  If the MBO (minimum buyout) is bigger than the average MBO, then it\'s usually a good time to sell, and if the average MBO is greater than the MBO, then it\'s a good time to buy.
		)

		gui:AddHelp(id, "average minimum buyout variance",
		L('SIMP_Help_MinimumBuyoutVariance') ,--What\'s the \'10% variance\' mentioned earlier for?
		L('SIMP_Help_MinimumBuyoutVarianceAnswer')--If the current MBO is inside a 10% range of the running average, the current MBO is averaged in to the running average at 50% (normal).  If the current MBO is outside the 10% range, the current MBO will only be averaged in at a 12.5% rate.
		)

		gui:AddHelp(id, "why have variance",
		L'SIMP_Help_WhyVariance',--What\'s the point of a variance on minimum buyout?
		L'SIMP_Help_WhyVarianceAnswer' --Because some people put their items on the market for ridiculous price (too low or too high), so this helps keep the average from getting out of hand.
		)

		gui:AddHelp(id, "why multiply stack size simple",
		L'SIMP_Help_WhyMultiplyStack',--Why have the option to multiply stack size?
		L'SIMP_Help_WhyMultiplyStackAnswer' --The original Stat-Simple multiplied by the stack size of the item, but some like dealing on a per-item basis.
		)

		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")

		gui:AddControl(id, "Checkbox",   0, 1, "stat.simple.tooltip", L"SIMP_Interface_Show")--Show simple stats in the tooltips?
		gui:AddTip(id, L"SIMP_HelpTooltip_Show")--Toggle display of stats from the Simple module on or off
		gui:AddControl(id, "Checkbox",   0, 3, "stat.simple.average", L"SIMP_Interface_CombinedAverage") --Display Combined Average
		gui:AddTip(id, L"SIMP_HelpTooltip_CombinedAverage") --Toggle display of combined average from the Simple module on or off
		gui:AddControl(id, "Checkbox",   0, 3, "stat.simple.avg3", L"SIMP_Interface_Toggle3Day")--Display Moving 3 Day Average
		gui:AddTip(id, L"SIMP_HelpTooltip_Toggle3Day")--Toggle display of 3-Day average from the Simple module on or off
		gui:AddControl(id, "Checkbox",   0, 3, "stat.simple.avg7", L"SIMP_Interface_Toggle7Day")--Display Moving 7 Day Average
		gui:AddTip(id, L"SIMP_HelpTooltip_Toggle7Day")--Toggle display of 7-Day average from the Simple module on or off
		gui:AddControl(id, "Checkbox",   0, 3, "stat.simple.avg14", L"SIMP_Interface_Toggle14Day")--Display Moving 14 Day Average
		gui:AddTip(id,L"SIMP_HelpTooltip_Toggle14Day")--Toggle display of 14-Day average from the Simple module on or off
		gui:AddControl(id, "Checkbox",   0, 3, "stat.simple.minbuyout", L"SIMP_Interface_MinBuyout")--Display Daily Minimum Buyout
		gui:AddTip(id, L"SIMP_HelpTooltip_MinBuyout")--Toggle display of Minimum Buyout from the Simple module on or offMultiplies by current stack size if on
		gui:AddControl(id, "Checkbox",   0, 3, "stat.simple.avgmins", L"SIMP_Interface_MinBuyoutAverage")--Display Average of Daily Minimum Buyouts
		gui:AddTip(id,L"SIMP_HelpTooltip_MinBuyoutAverage")--Toggle display of Minimum Buyout average from the Simple module on or off
		gui:AddControl(id, "Checkbox",   0, 3, "stat.simple.stddev", L"SIMP_Interface_StdDev")--Display Standard Deviation
		gui:AddTip(id, L"SIMP_HelpTooltip_StdDev")--Toggle Standard Deviation for the combined average on or off
		gui:AddControl(id, "Note",       0, 1, nil, nil, "")
		gui:AddControl(id, "Checkbox",   0, 3, "stat.simple.quantmul", L"SIMP_Interface_MultiplyStack")--Multiply by stack size
		gui:AddTip(id, L"SIMP_HelpTooltip_MultiplyStack")--Multiplies by current stack size if on
		gui:AddControl(id, "Note",       0, 1, nil, nil, "")
	end

	addTooltipControls(id)
	gui:AddControl(id, "Checkbox",   0, 1, "stat.simple.fallback", L"SIMP_Interface_Fallback")--Use fallback prices
	gui:AddTip(id, L"SIMP_HelpTooltip_Fallback")--If there is no price info for the exact item, use the price for the base item if it is available
	gui:AddControl(id, "Checkbox",   0, 1, "stat.simple.basemode", "Base item mode (Transmog/Petbreed mode)") -- ### -- experimental, do not localize
	gui:AddTip(id,"Experimental: always use prices for the base item (ignoring item suffixes) or the pet breed (ignoring pet level or quality)") -- ###


	--This is the Tooltip tab provided by aucadvanced so all tooltip configuration is in one place
	local tooltipID = AucAdvanced.Settings.Gui.tooltipID
	if tooltipID then
		gui:AddControl(tooltipID, "Header", 0, L"SIMP_Interface_SimpleOptions")--Simple options
		addTooltipControls(tooltipID)
	end
end

function private.ProcessTooltip(tooltip, hyperlink, serverKey, quantity, decoded, additional, order)
	if not get("stat.simple.tooltip") then return end

	if not quantity or quantity < 1 then quantity = 1 end
	if not get("stat.simple.quantmul") then quantity = 1 end

	local dayAverage, avg3, avg7, avg14, minBuyout, avgmins, _, dayTotal, dayCount, seenDays, seenCount, mean, stddev, dayAuctions, auctionsCount = lib.GetPrice(hyperlink, serverKey)
	if not dayAverage then return end
	local dispAvgComb = get("stat.simple.average")
	local dispAvg3 = get("stat.simple.avg3")
	local dispAvg7 = get("stat.simple.avg7")
	local dispAvg14 = get("stat.simple.avg14")
	local dispMinB = get("stat.simple.minbuyout")
	local dispAvgMBO = get("stat.simple.avgmins")
	local dispStdDev = get("stat.simple.stddev")

	if (seenDays + dayCount > 0) then
		tooltip:AddLine(L"SIMP_Tooltip_SimplePrices")--Simple prices:

		if seenDays > 0 then
			tooltip:AddLine("  "..L("SIMP_Tooltip_SeenNumberDays"):format(seenCount, seenDays) ) --Seen {{%s}} over {{%s}} days:
			if dispAvgComb then
				tooltip:AddLine("  "..L"SIMP_Tooltip_CombinedAverage", mean * quantity) -- Combined average
			end
			if seenDays > 10 and dispAvg14 then
				tooltip:AddLine("  "..L"SIMP_Tooltip_14DayAverage", avg14*quantity)--  14 day average
			end
			if seenDays > 6 and dispAvg7 then
				tooltip:AddLine("  "..L"SIMP_Tooltip_7DayAverage", avg7*quantity) --  7 day average
			end
			if seenDays > 3 and dispAvg3 then
				tooltip:AddLine("  "..L"SIMP_Tooltip_3DayAverage", avg3*quantity)--  3 day average
			end
			if avgmins > 0 and dispAvgMBO then
				tooltip:AddLine("  "..L"SIMP_Tooltip_AverageMBO", avgmins*quantity)--  Average MBO
			end
			if stddev > 0 and dispStdDev then
				tooltip:AddLine("  "..L"SIMP_Tooltip_StdDev", stddev * quantity) -- Standard Deviation
			end
		end
		if (dayCount > 0) then
			tooltip:AddLine("  "..L("SIMP_Tooltip_SeenToday"):format(dayCount) , dayAverage*quantity) --Seen {{%s}} today:
			if minBuyout > 0 and dispMinB then
				tooltip:AddLine("  "..L"SIMP_Tooltip_TodaysMBO", minBuyout*quantity)-- Today"s Min BO
			end
		end
	end
end


--[[ Functions handling access to the permanent store data ]]--

-- local reference to stored realm data
local SSRealmData

function private.InitData()
	private.InitData = nil

	-- Load data
	private.UpgradeDb()
	SSRealmData = AucAdvancedStatSimpleData.RealmData
	if not SSRealmData then
		SSRealmData = {} -- dummy value to avoid more errors - will not get saved
		error("Error loading or creating StatSimple database")
	end

	for serverKey, data in pairs (SSRealmData) do
		if time() > data.dailypush then
			private.PushStats(serverKey)
		end
	end
end

function private.UpgradeDb()
	private.UpgradeDb = nil
	if type(AucAdvancedStatSimpleData) == "table" and AucAdvancedStatSimpleData.Version == DATABASE_VERSION then return end

	-- "Upgrade" to Version 3.0: database format has changed so drastically that we shall wipe the data and start fresh
	AucAdvancedStatSimpleData = {Version = DATABASE_VERSION, RealmData = {}}
end

-- Clear all stats for the requested item in the data for serverKey
-- For items that can have multiple properties, there will also be a property "0" which represents combined stats for all the properties
-- If we clear this "0" property, it would make no sense to leave any of the other properties uncleared
-- Therefore, ClearItem will clear all data for the itemID, regardless of the property within the hyperlink
function lib.ClearItem(hyperlink, serverKey)
	serverKey = ResolveServerKey(serverKey)
	if not serverKey then return end
	local realmdata = SSRealmData[serverKey]
	if not realmdata then return end
	local storeID, storeProperty = GetStoreKey(hyperlink, PET_BAND)
	if not storeID then return end

	local cleareditem = false
	if realmdata.daily[storeID] then
		realmdata.daily[storeID] = nil
		cleareditem = true
	end
	if realmdata.means[storeID] then
		realmdata.means[storeID] = nil
		cleareditem = true
	end

	if cleareditem then
		local keyText = AucAdvanced.GetServerKeyText(serverKey)
		aucPrint(L('SIMP_Help_SlashHelpClearingData'):format(libType, hyperlink, keyText)) --%s - Simple: clearing data for %s for {{%s}}
	end
end

-- Clear data for the requested serverKey, or for ALL data
function lib.ClearData(serverKey)
	if AucAdvanced.API.IsKeyword(serverKey, "ALL") then
		wipe(SSRealmData)
		aucPrint(L"SIMP_Interface_ClearingSimple".." {{"..L"ADV_Interface_AllRealms".."}}") --Clearing Simple stats for // All realms
	else
		serverKey = ResolveServerKey(serverKey)
		if serverKey and SSRealmData[serverKey] then
			local keyText = AucAdvanced.GetServerKeyText(serverKey)
			SSRealmData[serverKey] = nil
			aucPrint(L"SIMP_Interface_ClearingSimple".." {{"..keyText.."}}") --Clearing Simple stats for
		end
	end
end

-- PushStats: migrates the data from a daily average to the Exponential Moving Averages over the 3, 7 and 14 day ranges
local newstringtemplate6 = "%s"..PROPERTY_DIVIDER.."1"..DATA_DIVIDER.."%d"..DATA_DIVIDER.."%0.0f"..DATA_DIVIDER.."0"..DATA_DIVIDER.."0"..DATA_DIVIDER.."%0.0f"
local newstringtemplate7 = newstringtemplate6..DATA_DIVIDER.."%d"
local function numberformat(value) -- helper function
	local stringvalue
	if value >= 1000000 then
		stringvalue = ("%0.0f"):format(value)
	else -- less than 7 digits before the decimal point, keep 1 extra digit after
		stringvalue = ("%0.1f"):format(value)
		if stringvalue:byte(-1) == 48 then -- digit after the decimal point is "0"
			stringvalue = stringvalue:sub(1, -3)
		end
	end
	return stringvalue
end
function private.PushStats(serverKey)
	local realmdata = SSRealmData[serverKey]
	if not realmdata then return end
	local daily, means = realmdata.daily, realmdata.means
	local lookupmeansdata, lookupmeansindex = {}, {}

	for storeID, itemstring in pairs(daily) do
		-- find the means data for this storeID, and build lookup tables to help cross-index
		-- we leave the last (DATA_DIVIDER) level of the data as strings for now; later we will fully unpack only the ones we need
		local itemstoremeans
		if means[storeID] then
			itemstoremeans = {strsplit(ITEM_DIVIDER, means[storeID])}
		else
			itemstoremeans = {}
		end
		for index, propertystring in ipairs(itemstoremeans) do
			local prop, datastringmeans = strsplit(PROPERTY_DIVIDER, propertystring)
			lookupmeansdata[prop] = datastringmeans
			lookupmeansindex[prop] = index -- remember where we got datastringmeans from, so we can put the revised datastring back in the same place
		end

		local itemsdaily = {strsplit(ITEM_DIVIDER, itemstring)}
		for index, propertystring in ipairs(itemsdaily) do
			-- extract daily data entries for this itemID & property
			local prop, datastringdaily = strsplit(PROPERTY_DIVIDER, propertystring)
			local dailybuy, dailyseen, dailymbo, dailyauctions = strsplit(DATA_DIVIDER, datastringdaily)
			dailybuy, dailyseen, dailymbo, dailyauctions = tonumber(dailybuy), tonumber(dailyseen), tonumber(dailymbo), tonumber(dailyauctions)
			local dailyavg = dailybuy
			-- dailyseen may be 0 for certain unusual items which do not modify property "0"
			-- our database format requires that there must always be a property "0" (which must always be at index 1)
			-- if no items of that base type with property "0" were seen today, the entry will be empty (all 0)
			if dailyseen > 0 then
				dailyavg = dailyavg / dailyseen
			end

			-- look for existing means data for this property
			local datastringmeans = lookupmeansdata[prop]
			if datastringmeans then
				if dailyseen > 0 then
					local datameans = {strsplit(DATA_DIVIDER, datastringmeans)} -- seendays, seencount, EMA3, EMA7, EMA14, avgminbuy [, seenauctions]
					for k, v in ipairs(datameans) do
						datameans[k] = tonumber(v)
					end

					-- update means data for this entry
					local seendays = datameans[1]
					local newseendays = seendays + 1
					datameans[1] = newseendays
					datameans[2] = datameans[2] + dailyseen
					local seenauctions = datameans[7]
					if seenauctions then
						datameans[7] = seenauctions + (dailyauctions or dailyseen)
					else
						datameans[7] = dailyauctions -- may be nil
					end

					if seendays < 3 then
						-- for first 3 days perform plain average insead of EMAs
						datameans[3] = numberformat((datameans[3] * seendays + dailyavg) / newseendays) -- EMA3
						datameans[6] = numberformat((datameans[6] * seendays + dailymbo) / newseendays) -- average minimum buyout
						if newseendays == 3 then
							-- this is the third day, prep other EMAs for next time
							datameans[4] = datameans[3]
							datameans[5] = datameans[3]
						end
					else
						-- do normal EMA calculations
						datameans[3] = numberformat((datameans[3] * 2 + dailyavg) / 3) -- EMA3
						datameans[4] = numberformat((datameans[4] * 6 + dailyavg) / 7) -- EMA7
						datameans[5] = numberformat((datameans[5] * 13 + dailyavg) / 14) -- EMA14

						local avgmbo = datameans[6] -- average minimum buyout
						if avgmbo < 1 then
							datameans[6] = dailymbo
						else
							if dailymbo >= 1 then
								if avgmbo < dailymbo then
									if (avgmbo*10/dailymbo) < 9 then
										datameans[6] = numberformat((avgmbo+dailymbo)/2)
									else
										datameans[6] = numberformat((avgmbo*7+dailymbo)/8)
									end
								else
									if (dailymbo*10/avgmbo) < 9 then
										datameans[6] = numberformat((avgmbo+dailymbo)/2)
									else
										datameans[6] = numberformat((avgmbo*7+dailymbo)/8)
									end
								end
							end
						end
					end
					itemstoremeans[lookupmeansindex[prop]] = prop..PROPERTY_DIVIDER..tconcat(datameans, DATA_DIVIDER)
				end
			else
				-- this property has not been seen before, create a new entry for it
				-- we don't need to use an intermediate table, we can build the datastring directly
				-- there is no need to update lookupmeansdata[prop] or lookupmeansindex[prop], as each prop should only occur once for each storeID
				if dailyauctions then
					tinsert(itemstoremeans, newstringtemplate7:format(prop, dailyseen, dailyavg, dailymbo, dailyauctions)) -- represents data table with 7 entries
				else
					tinsert(itemstoremeans, newstringtemplate6:format(prop, dailyseen, dailyavg, dailymbo)) -- represents data table with 6 entries (missing seenauctions)
				end
			end
		end

		means[storeID] = tconcat(itemstoremeans, ITEM_DIVIDER)
		wipe(lookupmeansdata)
		wipe(lookupmeansindex)
	end

	realmdata.dailypush = time() + PUSHTIME
	wipe(daily)
end

-- Get item data for reading for the requested serverKey/itemID/property
-- Dedicated helper function for GetPrice
-- returns daily and means datatables, if an entry exists (each return value may be a table or nil, independant of the other)
function private.GetItemDataRead(serverKey, storeID, storeProperty)
	local realmdata = SSRealmData[serverKey]
	if not realmdata then return end

	local dailydata, meansdata

	local itemstring = realmdata.daily[storeID]
	if itemstring then
		local itemstore = {strsplit(ITEM_DIVIDER, itemstring)}
		for index, propertystring in ipairs(itemstore) do
			local prop, datastring = strsplit(PROPERTY_DIVIDER, propertystring)
			if prop == storeProperty then
				dailydata = {strsplit(DATA_DIVIDER, datastring)}
				for k, v in ipairs(dailydata) do
					dailydata[k] = tonumber(v)
				end
				break
			end
		end
	end

	itemstring = realmdata.means[storeID]
	if itemstring then
		local itemstore = {strsplit(ITEM_DIVIDER, itemstring)}
		for index, propertystring in ipairs(itemstore) do
			local prop, datastring = strsplit(PROPERTY_DIVIDER, propertystring)
			if prop == storeProperty then
				meansdata = {strsplit(DATA_DIVIDER, datastring)}
				for k, v in ipairs(meansdata) do
					meansdata[k] = tonumber(v)
				end
				break
			end
		end
	end

	return dailydata, meansdata
end

-- GetServerKeyList
function lib.GetServerKeyList()
	if not SSRealmData then return end
	local list = {}
	for serverKey in pairs(SSRealmData) do
		tinsert(list, serverKey)
	end
	return list
end

-- ChangeServerKey
function lib.ChangeServerKey(oldKey, newKey)
	if not SSRealmData then return end
	local oldData = SSRealmData[oldKey]
	SSRealmData[oldKey] = nil
	if oldData and newKey then
		SSRealmData[newKey] = oldData
		-- any prior data for newKey will be discarded (simplest implementation)
	end
end

-- WriteStore retains data from GetItemDataWrite for use by WriteItemData
local WriteStore = {} -- keys: storeID, storeProperty, serverKey, itemstore, data0, dataP, indexP

-- Get daily item data table(s) for the requested serverKey/itemID/property, ready to be written to
-- Dedicated helper function for ScanProcessors.create
-- Returns one or two data tables; creates new data table(s) if they don't exist
--    table1 represents property "0", may rarely be nil for certain unusual items
--    table2 represents the requested storeProperty, if this is not "0"
-- After modifying the data table(s), private.WriteItemData must be called to store the data
-- Only one item may be open for writing at a time
function private.GetItemDataWrite(serverKey, storeID, storeProperty)
	local modify0 = true
	if storeProperty == "0" then
		storeProperty = nil
	elseif storeProperty:byte(1) == 48 then -- has a leading 0
		-- this item requires special handling; most likely it is an item with bonus data
		-- unlike with suffixed items, items of this base type with property "0" do exist
		-- therefore we should not modify data0 for this item
		modify0 = nil
	end

	if WriteStore.storeID then
		-- GetItemDataWrite called without calling WriteItemData on previous entry
		-- assume caused by some error, previous data assumed to be corrupted
		debugPrint("Stat-Simple GetItemDataWrite called without clearing previous WriteStore. ID="..WriteStore.storeID)
		wipe(WriteStore)
	end

	local realmdata = SSRealmData[serverKey]
	if not realmdata then
		realmdata = {means = {}, daily = {}, dailypush = time() + PUSHTIME}
		SSRealmData[serverKey] = realmdata
	end

	local itemstring = realmdata.daily[storeID]
	local itemstore
	if itemstring then
		itemstore = {strsplit(ITEM_DIVIDER, itemstring)}
	else
		itemstore = {}
	end
	local itemstoremax = #itemstore


	local data0, dataP, indexP

	local propertystring = itemstore[1] -- 'index0' is always 1
	if propertystring then
		if modify0 then -- only do the processing if we are going to write to it
			local prop, datastring = strsplit(PROPERTY_DIVIDER, propertystring)
			if prop ~= "0" then
				debugPrint("Stat-Simple GetItemDataWrite: property \"0\" not found at index 1. ID="..storeID)
			end
			data0 = {strsplit(DATA_DIVIDER, datastring)}
			for k, v in ipairs(data0) do
				data0[k] = tonumber(v)
			end
		end
	else
		-- property "0" does not yet exist, we must create an entry for it even if we are not going to write to it this time
		data0 = {0, 0, 0} -- totalbuyout, seencount, minbuyout [, auctionscount]
		itemstoremax = 1
	end

	if storeProperty then
		for index = 2, itemstoremax do
			local prop, datastring = strsplit(PROPERTY_DIVIDER, itemstore[index])
			if prop == storeProperty then
				dataP = {strsplit(DATA_DIVIDER, datastring)}
				for k, v in ipairs(dataP) do
					dataP[k] = tonumber(v)
				end
				indexP = index
				break
			end
		end
		if not indexP then
			dataP = {0, 0, 0} -- totalbuyout, seencount, minbuyout [, auctionscount]
			indexP = itemstoremax + 1
		end
	end

	WriteStore.storeID = storeID
	WriteStore.storeProperty = storeProperty -- may be nil (if it was originally "0")
	WriteStore.serverKey = serverKey
	WriteStore.itemstore = itemstore
	WriteStore.data0 = data0 -- may be nil if modify0 is nil
	WriteStore.dataP = dataP -- will be nil if storeProperty is nil
	WriteStore.indexP = indexP -- will be nil if storeProperty is nil

	return modify0 and data0, dataP
end

-- Write item data following a prior call to private.GetItemDataWrite, and modification of the data
-- Dedicated helper function for ScanProcessors.create
-- serverKey, storeID, storeProperty must match the ones used in GetItemDataWrite - this is used as a check
function private.WriteItemData(serverKey, storeID, storeProperty)
	if serverKey ~= WriteStore.serverKey or storeID ~= WriteStore.storeID or (storeProperty ~= "0" and storeProperty ~= WriteStore.storeProperty) then
		debugPrint("Stat-Simple WriteItemData: parameters do not match WriteStore"..
			format("\nParameters serverKey %s, storeID %s, storeProperty %s", tostringall(serverKey, storeID, storeProperty))..
			format("\nWriteStore serverKey %s, storeID %s, storeProperty %s", tostringall(WriteStore.serverKey, WriteStore.storeID, WriteStore.storeProperty))
		)
		return
	end

	local itemstore = WriteStore.itemstore
	if WriteStore.data0 then
		itemstore[1] = "0"..PROPERTY_DIVIDER..tconcat(WriteStore.data0, DATA_DIVIDER)
	end
	if WriteStore.storeProperty then
		itemstore[WriteStore.indexP] = WriteStore.storeProperty..PROPERTY_DIVIDER..tconcat(WriteStore.dataP, DATA_DIVIDER)
	end
	SSRealmData[serverKey].daily[WriteStore.storeID] = tconcat(itemstore, ITEM_DIVIDER)

	wipe(WriteStore)
end

AucAdvanced.RegisterRevision("$URL: Auc-Stat-Simple/StatSimple.lua $", "$Rev: 6399 $")
