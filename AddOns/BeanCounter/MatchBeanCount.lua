--[[
	Auctioneer - BeanCounter Matcher module
	Version: 8.2.6422 (SwimmingSeadragon)
	Revision: $Id: MatchBeanCount.lua 6422 2019-09-22 00:20:05Z none $
	URL: http://auctioneeraddon.com/

	This is an Auctioneer Matcher module which will modify the Appraiser
	price, based on past successes and failures as recorded by
	BeanCounter.  As an items sells successfully, this matcher will slowly
	raise the price for future auctions; as your auctions expire without
	selling, the price will slowly drop.

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
--if not BeanCounter then
--	AucAdvanced.Print("BeanCounter not loaded")
--	return
--end
LibStub("LibRevision"):Set("$URL: BeanCounter/MatchBeanCount.lua $","$Rev: 6422 $","5.1.DEV.", 'auctioneer', 'libs')

if not AucAdvanced then return end

local libType, libName = "Match", "BeanCount"
local AddOnName = ...
local lib,parent,private = AucAdvanced.NewModule(libType, libName, nil, nil, AddOnName)
if not lib then return end
local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()

local Resources = AucAdvanced.Resources

lib.Processors = {}
function lib.Processors.config(callbackType, gui)
	if private.SetupConfigGui then private.SetupConfigGui(gui) end
end
function lib.Processors.configchanged()
	lib.ClearMatchArrayCache()
end
lib.Processors.scanstats = lib.Processors.configchanged -- AH has been scanned
lib.Processors.mailclose = lib.Processors.configchanged -- Mailbox closed
lib.Processors.auctionclose = lib.Processors.configchanged -- this is mostly to conserve RAM, we don't really need to wipe the cache here

local matchArrayCache = {}

function lib.ClearMatchArrayCache()	-- called from processor
	wipe(matchArrayCache)
end

function lib.GetMatchArray(hyperlink, marketprice, serverKey)
	if not get("match.beancount.enable") or not BeanCounter.API.isLoaded then --check setting is on, and that the database is sound
		return
	end
	local linkType,itemId,property = decode(hyperlink)
	if (linkType ~= "item") then return end
	if not serverKey then serverKey = Resources.ServerKey end

	local cacheKey = serverKey .."x".. itemId .."x".. property .."x".. marketprice
	if matchArrayCache[cacheKey] then return matchArrayCache[cacheKey] end

	local matchArray = {}

	local marketdiff = 0
	local competing = 0
	if not marketprice then marketprice = 0 end
	local matchprice = marketprice
	local increase = get("match.beancount.success")
	local decrease = get("match.beancount.failed")
	local maxincrease = get("match.beancount.maxup")
	local maxdecrease = get("match.beancount.maxdown")
	local daterange = get("match.beancount.daterange")
	--local matchstacksize = get("match.beancount.matchstacksize") --REMOVED for now, the posible issues arising from buying at last appraiser stack price needs to be resolved
	local numdays = get("match.beancount.numdays")
	--nil numdays if we dont care how far back our data goes
	if not daterange then
		numdays = nil
	end

	increase = (increase / 100) + 1
	decrease = (decrease / 100) + 1

	local player =  UnitName("player")
	local success, failed = BeanCounter.API.getAHSoldFailed(player, hyperlink, numdays, serverKey)
	if not success then return end

	increase = (increase ^ (success ^ 0.8))
	decrease = (decrease ^ (failed ^ 0.8))
	matchprice = matchprice * increase * decrease

	if (marketprice > 0) then
		if (matchprice > (marketprice * (maxincrease*0.01))) then
			matchprice = (marketprice * (maxincrease*0.01))
		elseif (matchprice < (marketprice * (maxdecrease*0.01))) then
			matchprice = (marketprice * (maxdecrease*0.01))
		end
		marketdiff = floor((matchprice - marketprice) * 100 / marketprice + 0.5)
	else
		marketdiff = 0
	end
	matchArray.value = matchprice
	matchArray.diff = marketdiff
	matchArray.returnstring = "BeanCount: % change: "..tostring(marketdiff)
	if get("match.beancount.showhistory") then
		matchArray.returnstring = "BeanCount: Succeeded: "..tostring(success).."\nBeanCount: Failed: "..tostring(failed).."\n"..matchArray.returnstring
	end
	matchArrayCache[cacheKey] = matchArray
	return matchArray
end

function lib.OnLoad()
	--aucPrint("AucAdvanced: {{"..libType..":"..libName.."}} loaded!")
	default("match.beancount.enable", false)
	default("match.beancount.daterange", false)
	--default("match.beancount.matchstacksize", false)
	default("match.beancount.numdays", 30)
	default("match.beancount.failed", -0.1)
	default("match.beancount.success", 0.1)
	default("match.beancount.maxup", 150)
	default("match.beancount.maxdown", 50)
	default("match.beancount.showhistory", true)
end

--[[ Local functions ]]--

function private.SetupConfigGui(gui)
	private.SetupConfigGui = nil
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id = gui:AddTab(libName, libType.." Modules")
	--gui:MakeScrollable(id)

	gui:AddHelp(id, "what beancount module",
		"What is this BeanCount module?",
		"The BeanCount module uses BeanCounter's data to adjust the price based on the item's past selling history.")

	gui:AddControl(id, "Header",     0,    libName.." options")

	gui:AddControl(id, "Subhead",    0,    "Price Adjustments")

	gui:AddControl(id, "Checkbox",   0, 1, "match.beancount.enable", "Enable Auc-Match-BeanCount")

	gui:AddControl(id, "WideSlider", 0, 1, "match.beancount.failed", -20, 0, 0.1, "Auction failure markdown: %g%%")
	gui:AddTip(id, "This controls how much you want to markdown an auction for every time it has failed to sell.\n"..
		"This is cumulative.  ie a setting of 10% with two failures will set the price at 81% of market")

	gui:AddControl(id, "WideSlider", 0, 1, "match.beancount.success", 0, 20, 0.1, "Auction success markup: %g%%")
	gui:AddTip(id, "This controls how much you want to markup an auction for every time it has sold.\n"..
		"This is cumulative.  ie a setting of 10% with two successes will set the price at 121% of market")

	gui:AddControl(id, "WideSlider", 0, 1, "match.beancount.maxup", 101, 300, 1, "Maximum: %g%%")
	gui:AddTip(id, "Sets the maximum that you are willing to set the price at, as a % of baseline")

	gui:AddControl(id, "WideSlider", 0, 1, "match.beancount.maxdown", 1, 99, 1, "Minimum: %g%%")
	gui:AddTip(id, "Sets the minimum that you are willing to set the price at, as a % of baseline")

	gui:AddControl(id, "Checkbox",   0, 1, "match.beancount.showhistory", "Show history of successes and failures")
	gui:AddTip(id, "This will add the number of successes and failures for that item to Appraiser's right-hand panel")

	gui:AddControl(id, "Checkbox",   0, 1, "match.beancount.daterange", "Only use recent data")
	gui:AddTip(id, "Only use data from the last x days, as set by the slider.")
	gui:AddControl(id, "WideSlider", 0, 2, "match.beancount.numdays", 1, 300, 1, "Use data from last %g days")
	gui:AddTip(id, "Only use data from the last x days, as set by the slider.")

	--gui:AddControl(id, "Checkbox",   0, 1, "match.beancount.matchstacksize", "Seprerate data by stack size. Only available if Use recent data is set")
	--gui:AddTip(id, "Only use data for the current stack size.")
end
