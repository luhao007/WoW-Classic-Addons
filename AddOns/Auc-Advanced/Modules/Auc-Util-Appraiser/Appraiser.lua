--[[
	Auctioneer - Appraisals and Auction Posting
	Version: 8.2.6417 (SwimmingSeadragon)
	Revision: $Id: Appraiser.lua 6417 2019-09-22 00:20:05Z none $
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds an appraisals tab to the AH for
	easy posting of your auctionables when you are at the auction house.

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

local libType, libName = "Util", "Appraiser"
local lib = AucAdvanced.NewModule(libType, libName, nil, true) -- no Private table
if not lib then return end
local private = {}
local aucPrint,decode,_,_,replicate,_,get,set,default,debugPrint,fill, _TRANS = AucAdvanced.GetModuleLocals()

-- reduce global lookups
local wipe, tinsert = wipe, tinsert
local floor, ceil, max = floor, ceil, max
local tonumber = tonumber
local AucAdvanced = AucAdvanced
local Resources = AucAdvanced.Resources
local GetMarketValue = AucAdvanced.API.GetMarketValue
local GetAlgorithmValue = AucAdvanced.API.GetAlgorithmValue
local GetBestMatch = AucAdvanced.API.GetBestMatch
local GetSigFromLink = AucAdvanced.API.GetSigFromLink
local GetDepositCost = AucAdvanced.Post.GetDepositCost
local GetItemInfoCache = AucAdvanced.GetItemInfoCache

local pricecache -- cache for GetPrice; only used in certain circumstances
local tooltipcache = {} -- cache for ProcessTooltip

lib.Processors = {}
function lib.Processors.itemtooltip(callbackType, ...)
	lib.ProcessTooltip(...)
end
lib.Processors.battlepettooltip = lib.Processors.itemtooltip

function lib.Processors.auctionui(callbackType, ...)
	if private.CreateFrames then private.CreateFrames(...) end
end

function lib.Processors.config(callbackType, ...)
	private.SetupConfigGui(...)
end

function lib.Processors.configchanged(callbackType, fullsetting, value, subsetting, module, base)
	if private.frame then
		-- Appraiser pricing may be affected by changes in other modules, e.g. Stat module price calculation options
		-- As we cannot practically predict which changes will affect Appraiser price, we update pricing for every change
		-- ### todo: reduce amount of work in this event further: check if frame shown; move to OnUpdate handler; refine these functions; other?
		private.frame.salebox.config = true -- ### not used?
		--	private.frame.SetPriceFromModel()
		private.frame.UpdatePricing()
		private.frame.UpdateDisplay()
		--	private.frame.salebox.config = nil -- ### not used?
	end
	local isprofile = base == "profile"
	if isprofile or module == "appraiser" then
		if private.frame then
			if isprofile or fullsetting == "util.appraiser.color" or fullsetting == "util.appraiser.colordirection" then
				private.frame.UpdateImage()
			end
			--show/hide the appraiser tab on the AH
			if isprofile or fullsetting == "util.appraiser.displayauctiontab" then
				private.frame.ScanTab:SetDisplay()
			end
		end
		if isprofile or fullsetting:sub(1, 20) == "util.appraiser.round" then
			private.updateRoundExample()
		end
	end
	-- clear cache for any changes, as we can't always predict what will change our cached values
	wipe(tooltipcache)
end

function lib.Processors.inventory(callbackType, ...)
	if private.frame and private.frame:IsVisible() then
		private.frame.GenerateList()
	end
end

function lib.Processors.iteminfoupdate()
	if private.needListRefresh then
		private.needListRefresh = nil
		if private.frame and private.frame:IsVisible() then
			private.frame.GenerateList()
		end
	end
end

function lib.Processors.scanstats()
	-- flush all caches
	if private.frame then
		private.frame.olddistributioncache = private.frame.distributioncache
		private.frame.distributioncache = {}
	end
	wipe(tooltipcache)
end

function lib.Processors.scanfinish()
	-- schedule a refresh of the frame
	if private.frame then
		private.frame.scanFinished = true
	end
end

function lib.Processors.postresult(callbackType, ...)
	private.SelectNextOnPost(...)
end

function lib.Processors.postqueue(callbackType, ...)
	if private.UpdatePostQueueProgress then private.UpdatePostQueueProgress(...) end
end

function lib.Processors.searchbegin(callbackType, ...)
	pricecache = {} -- use cache when SearchUI is running a search
end

function lib.Processors.searchcomplete(callbackType, ...)
	pricecache = nil -- stop using cache when search ends
end



-- Deprecated. For backwards compatibility, leave these here. This is now a capability of the core API
lib.GetSigFromLink = GetSigFromLink
lib.GetLinkFromSig = AucAdvanced.API.GetLinkFromSig

function lib.ProcessTooltip(tooltip, hyperlink, serverKey, quantity, decoded, additional, order)--(tooltip, name, hyperlink, quality, quantity, cost, additional)
	if not get("util.appraiser.enable") then return end
	if not get("util.appraiser.model") then return end
	local sig = GetSigFromLink(hyperlink)
	if not sig then return end

	tooltip:SetColor(0.3, 0.9, 0.8)

	local value, bid, curModel, _

	if tooltipcache[sig] then
		value, bid, curModel = unpack(tooltipcache[sig]) -- all values should be non-nil
	else
		value, bid, _, curModel = private.GetPriceCore(sig, hyperlink, serverKey, true)
		if curModel ~= "Enchantrix" then -- don't cache values based on modules which don't broadcast configchanged
			tooltipcache[sig] = {value, bid, curModel}
		end
	end

	if value then
		tooltip:AddLine(_TRANS('APPR_Tooltip_AppraiserCurModel'):format(curModel, quantity) , value * quantity)--Appraiser ({{%s}}x{{%s}}
		if get("util.appraiser.bidtooltip") then
			tooltip:AddLine("  ".._TRANS('APPR_Tooltip_StartingBid'):format(quantity), bid * quantity)--Starting bid x {{%d}}
		end
	end
    if get("util.appraiser.ownauctions") then
        local itemName = additional.name

        local colored = get('util.appraiser.manifest.color') and AucAdvanced.Modules.Util.PriceLevel

		local results = lib.ownResults[itemName]
		local counts = lib.ownCounts[itemName]

		if counts and #counts>0 then
            local sumBid, sumBO = 0, 0
            local countBid, countBO = 0, 0
			for _,count in ipairs(counts) do
				local res = results[count]
				sumBid = sumBid + res.sumBid --*res.stackCount
                sumBO = sumBO + res.sumBO --*res.stackCount
                countBid = countBid + res.countBid --*res.stackCount
                countBO = countBO + res.countBO --*res.stackCount
			end
            local avgBid =  countBid>0 and (sumBid / countBid) or nil
            local avgBO =  countBO>0 and (sumBO / countBO) or nil
            local r,g,b,_
			if colored then
				_, _, r,g,b = AucAdvanced.Modules.Util.PriceLevel.CalcLevel(hyperlink, 1, avgBid, avgBO)
			end
			r,g,b = r or 1,g or 1, b or 1

            tooltip:AddLine("  ".._TRANS('APPR_Tooltip_PostedCount'):format(countBO or countBid, avgBO and "" or " (bid)"), avgBO or avgBid, r,g,b)--Posted %2d at avg/ea %s
		end
    end
end

function lib.GetPrice(link, serverKey)
	local newBuy, newBid, seen, curModelText, MatchString, stack, number, duration
	local sig = GetSigFromLink(link)
	if not sig then
       	return 0, 0, false, 0, "Unknown", "", 0, 0, 0
	end
	if not serverKey then serverKey = Resources.ServerKey end

	if pricecache then
		local cacheSig = serverKey..sig
		if pricecache[cacheSig] then
			newBuy, newBid, seen, curModelText, MatchString, stack, number, duration = unpack(pricecache[cacheSig], 1, 8) -- some values may be nil
		else
			newBuy, newBid, seen, curModelText, MatchString, stack, number, duration = private.GetPriceCore(sig, link, serverKey, true)
			pricecache[cacheSig] = {newBuy, newBid, seen, curModelText, MatchString, stack, number, duration}
		end
	else
		newBuy, newBid, seen, curModelText, MatchString, stack, number, duration = private.GetPriceCore(sig, link, serverKey, true)
	end

	return newBuy, newBid, false, seen, curModelText, MatchString, stack, number, duration
end

function lib.GetPriceUnmatched(link, serverKey)
	local sig = GetSigFromLink(link)
	if not sig then
       	return 0, 0, false, 0, "Unknown", "", 0, 0, 0
	end

	local newBuy, newBid, seen, curModelText, MatchString, stack, number, duration
	newBuy, newBid, seen, curModelText, MatchString, stack, number, duration = private.GetPriceCore(sig, link, serverKey)
	return newBuy, newBid, false, seen, curModelText, MatchString, stack, number, duration
end

function lib.GetPriceColumns()
	return "Buyout", "Bid", false, "seen", "curModelText", "MatchString", "Stack", "Number", "Duration"
end

local array = {}
--returns pricing and posting settings
function lib.GetPriceArray(link, serverKey)
	wipe(array)

	local newBuy, newBid, _, seen, curModelText, MatchString, stack, number, duration = lib.GetPrice(link, serverKey)

	array.price = newBuy
	array.seen = seen

	array.stack = stack
	array.number = number
	array.duration = duration

	return array
end

function lib.OnLoad()
	-- Configure our defaults

    local maxDuration = 2880;
    if AucAdvanced.Classic then maxDuration = 1440 end

	default("util.appraiser.enable", false)
	default("util.appraiser.bidtooltip", true)
	default("util.appraiser.model", "market")
	default("util.appraiser.ownauctions", false)
	default("util.appraiser.altModel", "market")
	default("util.appraiser.duration", maxDuration)
	default("util.appraiser.round.bid", false)
	default("util.appraiser.round.buy", false)
	default("util.appraiser.round.method", "unit")
	default("util.appraiser.round.position", 0.10)
	default("util.appraiser.round.magstep", 5)
	default("util.appraiser.round.subtract", 1)
	default("util.appraiser.bid.markdown", 10)
	default("util.appraiser.bid.subtract", 0)
	default("util.appraiser.bid.deposit", false)
	default("util.appraiser.bid.vendor", true)
	default("util.appraiser.color", true)
	default("util.appraiser.colordirection","RIGHT")
	default("util.appraiser.manifest.color", true)
	default("util.appraiser.tint.color", true)
	default("util.appraiser.match", "on")
	default("util.appraiser.stack", "max")
	default("util.appraiser.number", "maxplus")
	default("util.appraiser.clickhookany", true)
	default("util.appraiser.reselect", true)
	default("util.appraiser.buttontips", true)
	default("util.appraiser.displayauctiontab", true)
	--Default sizes for the scrollframe column widths
	default("util.appraiser.columnwidth.".._TRANS('APPR_Interface_Seller'), 71) --Seller
	default("util.appraiser.columnwidth.".._TRANS('APPR_Interface_TimeLeft'), 27) --Left
	default("util.appraiser.columnwidth.".._TRANS('APPR_Interface_Stk'), 27 ) --Stk
	default("util.appraiser.columnwidth.".._TRANS('APPR_Interface_Min/ea'), 65) --Min/ea
	default("util.appraiser.columnwidth.".._TRANS('APPR_Interface_Cur/ea'), 65) --Cur/ea
	default("util.appraiser.columnwidth.".._TRANS('APPR_Interface_Buy/ea'), 65) --Buy/ea
	default("util.appraiser.columnwidth.".._TRANS('APPR_Interface_MinBid'), 65) --MinBid
	default("util.appraiser.columnwidth.".._TRANS('APPR_Interface_CurBid'), 65) --CurBid
	default("util.appraiser.columnwidth.".._TRANS('APPR_Interface_Buyout'), 67) --Buyout
	default("util.appraiser.columnwidth.BLANK", 0.05)

	local localName = _TRANS('APPR_Interface_Appraiser')
	function lib.GetLocalName() return localName end
end

function lib.ClearItem()
	-- we only need this to clear caches
	wipe(tooltipcache)
	if pricecache then wipe(pricecache) end
end
lib.ClearData = lib.ClearItem

function private.GetPriceCore(sig, link, serverKey, match)
	local newBuy, newBid, seen, DiffFromModel, MatchString

	local curModel = get("util.appraiser.item."..sig..".model") or "default"
	local curModelText = curModel
	local duration = get("util.appraiser.item."..sig..".duration") or get("util.appraiser.duration")

	-- valuation
	if curModel == "default" then
		curModel = get("util.appraiser.model") or "market"
		if curModel == "market" then
			newBuy, seen = GetMarketValue(link, serverKey)
		else
			newBuy, seen = GetAlgorithmValue(curModel, link, serverKey)
		end
		if (not newBuy) or (newBuy == 0) then
			curModel = get("util.appraiser.altModel")
			if curModel == "market" then
				newBuy, seen = GetMarketValue(link, serverKey)
			else
				newBuy, seen = GetAlgorithmValue(curModel, link, serverKey)
			end
		end
		curModelText = curModelText.."("..curModel..")"
	elseif curModel == "fixed" then
		newBuy = get("util.appraiser.item."..sig..".fixed.buy")
		newBid = get("util.appraiser.item."..sig..".fixed.bid")
		seen = 0
	elseif curModel == "market" then
		newBuy, seen = GetMarketValue(link, serverKey)
	else
		newBuy, seen = GetAlgorithmValue(curModel, link, serverKey)
	end

	-- matching
	if match then
		match = get("util.appraiser.item."..sig..".match")
		if match == nil then
			match = get("util.appraiser.match")
		end
		if match then
			if curModel == "fixed" then
				if newBuy and newBuy > 0 then
					local tBuy, _, _, tDiff, tString = GetBestMatch(link, newBuy, serverKey)
					if newBid then
						newBid = newBid * tBuy / newBuy
					end
					newBuy = tBuy
					DiffFromModel = tDiff
					MatchString = tString
				end
			else
				local tBuy, _, _, tDiff, tString = GetBestMatch(link, newBuy, serverKey)
				newBuy = tBuy
				DiffFromModel = tDiff
				MatchString = tString
			end
		end
	end

	-- other return values
	local stack = get("util.appraiser.item."..sig..".stack") or get("util.appraiser.stack")
	local number = get("util.appraiser.item."..sig..".number") or get("util.appraiser.number")
	local  maxStack, _, _, vendor = GetItemInfoCache(link, 8)
	if not maxStack then maxStack = 1 end
	--we only officially accept "max" or a number, but user could have input any random string, so add some sanitization
	stack = tonumber(stack)
	if stack then
		if stack > maxStack then
			stack = maxStack --never allow a saved stack value larger than the item can really stack to
		elseif stack < 1 then
			stack = 1
		end
	else
		stack = maxStack
	end
	if number == "maxplus" then
		number = -1
	elseif number == "maxfull" then
		number = -2
	else
		number = tonumber(number)
	end

	-- generate bid value
	if curModel ~= "fixed" and newBuy then
		if not newBid then
			local markdown = newBuy * (get("util.appraiser.bid.markdown") or 0)/100
			local subtract = get("util.appraiser.bid.subtract") or 0
			local deposit = 0
			if get("util.appraiser.bid.deposit") then
				local dep = GetDepositCost(link, duration, 1, newBuy * stack, stack)
				if dep then
					deposit = dep / stack
				end
			end

			newBid = newBuy - markdown - subtract - deposit
			if newBid < 1 then
				newBid = 1
			end
		end

		if get("util.appraiser.bid.vendor") then
			if vendor and vendor>0 then
				vendor = ceil(vendor / Resources.AHCutAdjust)
				if newBid < vendor then
					newBid = vendor
				end
			end
		end

		if newBid > newBuy then
			newBuy = newBid
		end
	end

	-- pricing: final checks
	newBid = floor((newBid or 0) + 0.5)
	newBuy = floor((newBuy or 0) + 0.5)

	-- Caution: this is NOT the same return order as GetPrice
	return newBuy, newBid, seen, curModelText, MatchString, stack, number, duration
end

lib.ownResults = {}
lib.ownCounts = {}
function lib.GetOwnAuctionDetails()
	local results = lib.ownResults
	local counts = lib.ownCounts
	wipe(results)
	wipe(counts)
	local numBatchAuctions, totalAuctions = GetNumAuctionItems("owner");
	if totalAuctions >0 then
		for i=1, totalAuctions do
			local name, _, count, _, _, _, _, minBid, _, buyoutPrice, bidAmount = GetAuctionItemInfo("owner", i)
			if name and (count>0) then
				if not results[name] then
					results[name] = {}
					counts[name] = {}
				end
				local r = results[name][count]
				if not r then
					r = { stackCount=0, countBid=0, sumBid=0, countBO=0, sumBO=0 }
					results[name][count] = r
					tinsert(counts[name], count)
				end
				if (minBid or 0)>0 then
					r.countBid = r.countBid + count
					r.sumBid = r.sumBid + bidAmount
				end
				if (buyoutPrice or 0)>0 then
					r.countBO = r.countBO + count
					r.sumBO = r.sumBO + buyoutPrice
				end
				r.stackCount = r.stackCount + 1
			end
		end
	end
end
Stubby.RegisterEventHook("AUCTION_OWNED_LIST_UPDATE", "Auc-Util-Appraiser", lib.GetOwnAuctionDetails)

-- Pass the private table to other files; each file reads and then deletes its own entry, and will not load if the entry is missing.
lib.Private_AprFrame = private
lib.Private_AprSettings = private

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-Appraiser/Appraiser.lua $", "$Rev: 6417 $")
