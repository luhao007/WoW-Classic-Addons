--[[
	Auctioneer
	Version: 8.2.6430 (SwimmingSeadragon)
	Revision: $Id: CorePost.lua 6430 2019-09-22 00:20:05Z none $
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

--[[
	Auctioneer Posting Engine.

	This code helps modules that need to post things to do so in an extremely easy and
	queueable fashion.

	This code takes "sigs" as input to most of it's functions. A "sig" is a string containing
	a colon seperated concatenation of itemID:suffixId:suffixFactor:enchantId
	A sig must be shortened by truncating trailing 0's - this is required for equality testing
	Any missing values at the end will be set to zero when the sig is decoded
	The function AucAdvanced.API.GetSigFromLink(link) may be used to construct a valid sig
]]
if not AucAdvanced then return end
AucAdvanced.CoreFileCheckIn("CorePost")
local coremodule, _, private = AucAdvanced.GetCoreModule("CorePost", nil, true)
if not coremodule then return end -- Someone has explicitely broken us

local lib = AucAdvanced.Post
lib.Private = private

local aucPrint = AucAdvanced.Print
local Const = AucAdvanced.Const
local debugPrint = AucAdvanced.Debug.DebugPrint
local _TRANS = AucAdvanced.localizations
local DecodeSig -- to be filled with AucAdvanced.API.DecodeSig when it has loaded
local GetSigFromLink -- to be filled with AucAdvanced.API.GetSigFromLink when it has loaded

-- local versions of API globals
local floor = floor
local type = type
local GetItemInfo = GetItemInfo

-- Local tooltip for getting soulbound line from tooltip contents
local ScanTip = CreateFrame("GameTooltip", "AppraiserTip", UIParent, "GameTooltipTemplate")
local line_metatable = {
	__index = function(t,k)
		local v = _G[t.name..k]
		rawset(t,k,v)
		return v
	end
}
ScanTip.Left = setmetatable({name = ScanTip:GetName().."TextLeft"},line_metatable)
ScanTip.Right = setmetatable({name = ScanTip:GetName().."TextRight"},line_metatable)
local ScanTipLeft = ScanTip.Left


-- control constants used in the posting mechanism
local LAG_ADJUST = (4 / 1000)
local SIGLOCK_TIMEOUT = 8 -- seconds timeout waiting for bags to update after auction created
local POST_TIMEOUT = 8 -- seconds general timeout after starting an auction, before deciding the auction has failed
local POST_ERROR_PAUSE = 5 -- seconds pause after an error before trying next request
local POST_THROTTLE = 0 -- time before starting to post the next item in the queue
local POST_TIMER_INTERVAL = 0.5 -- default interval of updates from the timer
local MINIMUM_DEPOSIT = 100 -- 1 silver minimum deposit, used in deposit cost calculation
local MAX_EXTRA_FEE = 10000000 -- cap the extra fee for stackable tradegoods, used in deposit cost calculation
local PROMPT_HEIGHT = 140
local PROMPT_MIN_WIDTH = 400

if AucAdvanced.Classic then
    MINIMUM_DEPOSIT = 0     -- no minimum in Classic
end

-- Used to check for bound items in bags - only checks for strings indicating item is already bound
-- In particular we do not check for ITEM_BIND_ON_PICKUP, as for our tests,
-- that could only occur on an *unbound* recipe that creates a BoP item
local BindTypes = {
	[ITEM_SOULBOUND] = "Bound",
	[ITEM_BIND_QUEST] = "Quest",
	[ITEM_CONJURED] = "Conjured",
	[ITEM_BNETACCOUNTBOUND] = "Accountbound",
}

if ITEM_ACCOUNTBOUND then
	-- may be obsolete, check in case it is removed by a patch
	BindTypes[ITEM_ACCOUNTBOUND] = "Accountbound"
end

-- Info for handling UI_ERROR_MESSAGE errors
local UIKnownErrors = {
	[ERR_NOT_ENOUGH_MONEY] = "ERR_NOT_ENOUGH_MONEY",
	[ERR_AUCTION_BAG] = "ERR_AUCTION_BAG",
	[ERR_AUCTION_BOUND_ITEM] = "ERR_AUCTION_BOUND_ITEM",
	[ERR_AUCTION_CONJURED_ITEM] = "ERR_AUCTION_CONJURED_ITEM",
	[ERR_AUCTION_DATABASE_ERROR] = "ERR_AUCTION_DATABASE_ERROR",
	[ERR_AUCTION_ENOUGH_ITEMS] = "ERR_AUCTION_ENOUGH_ITEMS",
	[ERR_AUCTION_HOUSE_DISABLED] = "ERR_AUCTION_HOUSE_DISABLED",
	[ERR_AUCTION_LIMITED_DURATION_ITEM] = "ERR_AUCTION_LIMITED_DURATION_ITEM",
	[ERR_AUCTION_LOOT_ITEM] = "ERR_AUCTION_LOOT_ITEM",
	[ERR_AUCTION_QUEST_ITEM] = "ERR_AUCTION_QUEST_ITEM",
	[ERR_AUCTION_REPAIR_ITEM] = "ERR_AUCTION_REPAIR_ITEM",
	[ERR_AUCTION_USED_CHARGES] = "ERR_AUCTION_USED_CHARGES",
	[ERR_AUCTION_WRAPPED_ITEM] = "ERR_AUCTION_WRAPPED_ITEM",
	[ERR_AUCTION_REPAIR_ITEM] = "ERR_AUCTION_REPAIR_ITEM",
}
-- If the UI error message one that is known to cause posting to fail
function private.IsBlockingError(errorcode)
	if UIKnownErrors[errorcode] then
		return true
	end
end
-- Whether we want the user to report the UI error message
function private.IsReportableError(errorcode)
	if errorcode and not UIKnownErrors[errorcode] then
		return true
	end
end

-- All errorcodes returned by any CorePost function should have an entry in this table
-- todo: in OnLoad auto-replace values with translations based on table key: "ADV_Help_PostError"..key - e.g. "ADV_Help_PostErrorBound"
-- Some of these errors are only of use when debugging, so should probably not be translated. i.e. the "InvalidX" codes
local ErrorText = {
	UnknownError = "An unknown error has occured",
	Bound = "Cannot auction a Soulbound item",
	Accountbound = "Cannot auction an Account Bound item",
	Conjured = "Cannot auction a Conjured item",
	Quest = "Cannot auction a Quest item",
	Token = "Auctioneer cannot post a WoW Token. Use the Auctions tab instead.",
	Lootable = "Cannot auction a Lootable item",
	Damaged = "Cannot auction a Damaged item",
	InvalidBid = "Bid value is invalid",
	InvalidBuyout = "Buyout value is invalid",
	InvalidDuration = "Duration value is invalid",
	InvalidSize = "Size value is invalid",
	InvalidMultiple = "Multiple stack value is invalid",
	UnknownItem = "Item is unknown",
	MaxSize = "Item cannot be stacked that high",
	NotFound = "Item was not found in inventory",
	NotEnough = "Not enough of item available",
	PayDeposit = "Not enough money to pay the deposit",
	FailTimeout = "Timed out while waiting for confirmation of posting",
	FailSlot = "Unable to place item in the Auction slot",
	FailStart = "Failed to start auction",
	FailMultisell = "Multisell failed to post all requested stacks",
	QueueBusy = "The posting queue is currently busy",
}
lib.ErrorText = ErrorText -- Deprecated: we don't want to give other modules direct access to the table
-- lib.GetErrorText shall be expected to always return a string
function lib.GetErrorText(code)
	if not code then
		return "No error"
	end
	local text = ErrorText[code]
	if text then
		return text
	end
	code = tostring(code)
	debugPrint("Error code without matching ErrorText: "..code, "CorePost", "Unknown Errorcode", "Warning")
	return "Unknown Errorcode ("..code..")"
end

do
--[[
	Functions to safely handle the Post Request queue
]]
	local postRequests = {}
	local lastReported = 0
	local lastCountSig, lastCountRequests, lastCountItems, lastCountAuctions
	function private.QueueReport()
		lastCountSig = nil
		local queuelength = #postRequests
		if lastReported ~= queuelength then
			lastReported = queuelength
			AucAdvanced.SendProcessorMessage("postqueue", queuelength)
		end
	end
	function private.QueueInsert(request)
		tinsert(postRequests, request)
		private.QueueReport()
	end
	function private.QueueRemove(index)
		index = index or 1
		if postRequests[index] then
			local request = tremove(postRequests, index)
			private.QueueReport()
			return request
		end
	end
	function private.QueueReorder(indexfrom, indexto)
		-- removes the request at position indexfrom and reinserts it at position indexto
		-- when indexto > indexfrom, be aware that the remove operation reindexes the table positions after indexfrom, before the reinsert occurs
		local queuelen = #postRequests
		if queuelen < 2 then return end
		indexfrom = indexfrom or 1
		if not indexto or indexto > queuelen then
			indexto = queuelen
		end
		if indexfrom == indexto then return end
		local request = tremove(postRequests, indexfrom)
		if not request then return end
		tinsert(postRequests, indexto, request)
		private.QueueReport()
		return true
	end
	function private.GetQueueIndex(index)
		return postRequests[index]
	end
	function private.GetQueueIterator()
		return ipairs(postRequests)
	end

	--[[ GetQueueLen()
		Return number of requests remaining in the Post Queue
	--]]
	function lib.GetQueueLen()
		return #postRequests
	end

	--[[ GetQueueItemCount(sig)
		Return number of requests, total number of items and total number of auctions matching the sig
	--]]
	function lib.GetQueueItemCount(sig)
		if sig and sig == lastCountSig then
			-- "last item" cache: this function tends to get called multiple times for the same sig
			return lastCountRequests, lastCountItems, lastCountAuctions
		end
		local requestCount, itemCount, auctionCount = 0, 0, 0
		for _, request in ipairs(postRequests) do
			if request.sig == sig then
				local numstacks = request.stacks
				requestCount = requestCount + 1
				itemCount = itemCount + request.count * numstacks
				auctionCount = auctionCount + numstacks
			end
		end
		lastCountSig = sig
		lastCountRequests = requestCount
		lastCountItems = itemCount
		lastCountAuctions = auctionCount
		return requestCount, itemCount, auctionCount
	end

	--[[ CancelPostQueue()
		Safely removes all possible Post requests from the Post queue
		If we are in the process of posting an auction, that request cannot be removed
	--]]
	function lib.CancelPostQueue()
		if #postRequests > 0 then
			local request = postRequests[1] -- save the first request
			wipe(postRequests)
			private.HidePrompt()
			if request.posting then
				-- request is currently being posted, put it back in the queue until the posting resolves
				tinsert(postRequests, request)
				CancelSell() -- abort current Multisell operation
			end
			private.QueueReport()
		end
	end
end --of Post Request Queue section


local AuctionDurationCode = {
    1, --[1]
    2, --[2]
    3, --[3]
    [12] = 1, -- hours
    [24] = 2,
    [48] = 3,
    [720] = 1, -- minutes
    [1440] = 2,
    [2880] = 3,
}

local LookupDurationHours = {12, 24, 48} -- convert duration code to hours, for display

if AucAdvanced.Classic then
    AuctionDurationCode = {
        [1] = 1,
-- 2 would cause issues here, but already exists as a value
        [3] = 3,

        [2] = 1, -- hours
        [8] = 2,
        [24] = 3,

        [120] = 1, -- minutes
        [480] = 2,
        [1440] = 3,
    }
    LookupDurationHours = {2, 8, 24} -- convert duration code to hours, for display
end

do
	function lib.ValidateAuctionDuration(duration)
		return AuctionDurationCode[duration]
	end
	function lib.AuctionDurationHours(duration)
		return LookupDurationHours[AuctionDurationCode[duration]]
	end
end

-- Check if 'item' is a valid parameter for PostAuction
-- returns sig, id, linkType, exactLink
local function AnalyzeItem(item)
	local iType = type(item)
	if iType == "string" then
		if strfind(item, "|H") then
			-- looks like a link
			local sig, linkType = GetSigFromLink(item)
			if sig then
				if linkType == "battlepet" then
					return sig, 82800, "battlepet", item
				else
					local sigType, id = DecodeSig(sig)
					if sigType == "item" then
						return sig, id, "item", item
					end
				end
			end

		else -- check it it's a sig
			local sigType, id = DecodeSig(item)
			if sigType == "battlepet" then
				return item, 82800, "battlepet"

			elseif sigType == "item" then
				return item, id, "item"
			end
		end
	elseif iType == "number" then
		if item ~= 82800 then
			return tostring(item), item, "item"
		end
	end
end

local lastPostId = 0
function private.GetRequest(item, size, bid, buyout, duration, multiple)
	local sig, id, linkType, exactLink = AnalyzeItem(item)
	if not (sig and id) then
		return nil, "InvalidItem"
	elseif C_WowTokenPublic.IsAuctionableWowToken(id) then
		-- WoW tokens require special handling, which Auctioneer currently doesn't support
		return nil, "Token"
	elseif type(size) ~= "number" or size < 1 then
		return nil, "InvalidSize"
	elseif type(bid) ~= "number" or bid < 1 then
		return nil, "InvalidBid"
	elseif type(buyout) ~= "number" or (buyout < bid and buyout ~= 0) then
		return nil, "InvalidBuyout"
	end
	duration = lib.ValidateAuctionDuration(duration)
	if not duration then
		return nil, "InvalidDuration"
	end

	local _,_,_,_,_,_,_, maxSize = GetItemInfo(id)
	if not maxSize then
		return nil, "UnknownItem"
	elseif size > maxSize then
		return nil, "MaxSize"
	end

	multiple = tonumber(multiple) or 1
	if multiple < 1 or multiple ~= floor(multiple) then
		return nil, "InvalidMultiple"
	end
	local available, total, _, _, _, reason = lib.CountAvailableItems(sig)
	if total == 0 then
		return nil, "NotFound"
	elseif available == 0 and reason then
		return nil, reason
	elseif available < size * multiple then
		return nil, "NotEnough"
	end

	lastPostId = lastPostId + 1
	local request = {
		sig = sig,
		count = size,
		bid = bid,
		buy = buyout,
		duration = duration,
		stacks = multiple,
		id = lastPostId,
		posted = 0,
		linkType = linkType, -- for battlepet special handling
		exactLink = exactLink, -- for future: will be used to post item with exact matching link
	}

	--[[ Temporary fix {ADV-665}
		Multisell API is currently not working for battlepets
		handle if the user requests to post multiple of the same pet, by generating multiple individual requests of size 1 each
		patch intended to be easily removed assuming Blizzard fixes the API
		also changes in PostAuction and PostAuctionClick, and a related fix in LoadAuctionSlot
	--]]
	local petextrarequests = nil
	if linkType == "battlepet" and multiple > 1 then
		request.stacks = 1 -- only post 1 pet in the primary request
		petextrarequests = {}
		for i = 1, multiple-1 do
				lastPostId = lastPostId + 1
				tinsert(petextrarequests, {
				sig = sig,
				count = size,
				bid = bid,
				buy = buyout,
				duration = duration,
				stacks = 1, -- 1 pet per extra request
				id = lastPostId,
				posted = 0,
				linkType = linkType,
				--exactLink = exactLink, -- planned implementation of exactLink will only be for single item
			})
		end
	end

	return request, nil, petextrarequests
end

--[[
    PostAuction(sig, size, bid, buyout, duration, [multiple])

	Places the request to post a stack of the "sig" item, "size" high
	into the auction house for "bid" minimum bid, and "buy" buyout and
	posted for "duration" minutes. The request will be posted
	"multiple" number of times.

	This is the main entry point to the Post library for other AddOns, so has the strictest parameter checking
	"multiple" is optional, defaulting to 1. All other parameters are required.

	If successful it returns a request id; the id will be included in the "postresult" Processor message for each request
	If a problem is detected it returns nil, reason
		reason is an internal short text code; it can be converted to a displayable text message using lib.GetErrorText(reason)
]]
function lib.PostAuction(sig, size, bid, buyout, duration, multiple)
	local request, reason, extra = private.GetRequest(sig, size, bid, buyout, duration, multiple)
	if not request then
		return nil, reason
	end
	private.QueueInsert(request)
	private.Wait(0) -- delay until next OnUpdate

	-- temp fix {ADV-665} as above
	if extra then
		for _, xrequest in ipairs(extra) do
			private.QueueInsert(xrequest)
		end
	end
	-- be aware that we currently only return the id for the *first* request

	return request.id
end

--[[ PostAuctionClick(sig, size, bid, buyout, duration, multiple)
	As PostAuction, except that this function will attempt to post the auction immediately if possible
	May only be called from an OnClick handler
--]]
function lib.PostAuctionClick(sig, size, bid, buyout, duration, multiple)
	local request, failure, extra = private.GetRequest(sig, size, bid, buyout, duration, multiple)
	if not request then
		return nil, failure
	end
	local noqueue = false -- placeholder for a Setting to block queueing when CorePost is busy

	local postNow = lib.GetQueueLen() == 0
	if postNow then
		private.SigLockUpdate()
		if private.IsSigLocked(request.sig) then
			postNow = false
		end
	end
	if not postNow and noqueue then
		return nil, "QueueBusy"
	end
	private.QueueInsert(request)
	local id = request.id

	-- temp fix {ADV-665} as above
	if extra and not noqueue then
		for _, xrequest in ipairs(extra) do
			private.QueueInsert(xrequest)
		end
	end

	if postNow then
		local success, reason, special
		-- Attempt to post the auction immediately
		private.Wait(0)
		success, reason, special = private.LoadAuctionSlot(request)
		if success then
			if special == -1 then -- indicates a deposit cost mismatch, prompt before posting (prompt shows deposit)
				private.ShowPrompt(request)
				return id
			else
				success, reason, special = private.StartAuction(request)
				if success then
					return id
				end
			end
		end
		if noqueue and not reason then
			private.QueueRemove() -- request will be at index 1
			reason = "QueueBusy"
		end
		if reason then
			if special then
				if private.IsReportableError(special) then
					geterrorhandler()(("Auctioneer encountered an error while posting: %s (%s)"):format(lib.GetErrorText(reason), tostring(special)))
				end
			end
			return nil, reason or "UnknownError"
		end
	end
	return id
end

--[[
    IsAuctionable(bag, slot)
    Returns:
		true : if the item is (probably) auctionable.
		false, reason : if the item is not auctionable
			reason is an internal (non-localized) string code, use lib.GetErrorText(errorcode) for a printable text string

    This function does not check everything, but if it says no,
    then the item is definately not auctionable.
]]
function lib.IsAuctionable(bag, slot)
	local itemID = GetContainerItemID(bag, slot)
	if itemID == 82800 then
		-- battlepet cage always sellable
		-- we test for it specially, as battlepets may break the other tests :(
		return true
	elseif C_WowTokenPublic.IsAuctionableWowToken(itemID) then
		-- WoW tokens are technically auctionable, but not by Auctioneer currently
		-- For now we shall report them as NOT auctionable
		return false, "Token"
	end

	local _,_,_,_,_,lootable = GetContainerItemInfo(bag, slot)
	if lootable then
		return false, "Lootable"
	end

	ScanTip:SetOwner(UIParent, "ANCHOR_NONE")
	ScanTip:ClearLines()
	ScanTip:SetBagItem(bag, slot)
	local test = nil
	for index = 2, 8 do
		local line = ScanTipLeft[index]
		if line then
			test = BindTypes[line:GetText()]
		end
		if test or not line then
			break
		end
	end
	ScanTip:Hide()
	if test then
		return false, test
	end

	-- Check for 'fixable' conditions only after checking all 'unfixable' conditions

	local damage, maxdur = GetContainerItemDurability(bag, slot)
	if damage and damage ~= maxdur then
		return false, "Damaged"
	end

	return true
end

--[[
	CountAvailableItems(sig)
	Returns: availableCount, totalCount, unpostableCount, queuedCount, postedCount, unpostableError
	The Posting modules need to know how many items are available to be posted;
	this is not the same as the number of items currently in the bags
--]]
function lib.CountAvailableItems(sig)
	if type(sig) ~= "string" then return end
	local totalCount, unpostableCount = 0, 0
	local unpostableError

	for bag = 0, NUM_BAG_FRAMES do
		for slot = 1, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link and GetSigFromLink(link) == sig then
				local _, count = GetContainerItemInfo(bag, slot)
				if not count or count < 1 then count = 1 end
				totalCount = totalCount + count
				local test, code = lib.IsAuctionable(bag, slot)
				if not test then
					unpostableCount = unpostableCount + count
					if unpostableError ~= "Damaged" then -- if there are both "Damaged" and "Soulbound" items, we want to report the "Damaged" code here
						unpostableError = code
					end
				end
			end
		end
	end

	-- any items queued to be posted are unavailable
	local _, queuedCount = lib.GetQueueItemCount(sig)

	-- any items under SigLock are unavailable, still appear in bags, but are not included in queue count
	local siglockCount = private.GetSigLockCount(sig)

	return (totalCount - unpostableCount - queuedCount - siglockCount), totalCount, unpostableCount, queuedCount, siglockCount, unpostableError
end


do --[[ Deposit Cost Calculator ]]--

	local lookupExcludeSubclass, lookupExceptionID = {}, {}
	function private.InitDepositCostData()
		local Data = AucAdvanced.Data
		InitDepositCostData = nil

		-- lookup table for subclasses of tradeskill reagents that do NOT have increased deposit
		-- these must be numbers, to match the subclassID return from GetItemInfo
		-- Source table is in DataPostDeposit.lua, in List form - convert to lookup
		for _, subclass in ipairs(Data.DepositExcludedSubclasses) do
			lookupExcludeSubclass[subclass] = true
		end
		Data.DepositExcludedSubclasses = nil

		-- lookup table for itemIDs in a subclass that usually has an increased deposit cost, but which actually have base deposit cost (exceptions)
		-- these must be strings to match the itemID extracted from the itemLink
		-- Source table is in DataPostDeposit.lua in List for, convert to lookup, and convert each entry to a string
		for _, item in ipairs(Data.DepositItemIDExceptions) do
			lookupExceptionID[tostring(item)] = true
		end
		Data.DepositItemIDExceptions = nil

	end
	AucAdvanced.Data.DepositCalcAlgorithmDebugVersion = 2 -- ### used by debugging tools, stored in an out-of-the-way place

	--[[
		lib.GetDepositCost(item, duration, bidprice, buyprice, stacksize, numstacks)
		item: itemID or "itemString" or "itemName" or "itemLink" [Required]
		duration: 1, 2, 3 (Blizzard auction duration codes), 12, 24, 48 (hours), 720, 1440, 2880 (minutes) [defaults to 3]
		Classic duration: 1, 2, 3 (Blizzard auction duration codes), 2, 8, 24 (hours), 120, 480, 1440 (minutes) [defaults to 3]
		bidprice, buyprice: prices for the stack
		stacksize: [defaults to 1]
		numstacks: [defaults to 1]

	]]
	function lib.GetDepositCost(item, duration, bidprice, buyprice, stacksize, numstacks)
		local vendor, classID, subclassID, itemID
		--[[
            Base Deposit = 0.15 * VendorPrice * StackSize * DurationMultiplier
                DurationMultiplier = (1 for 12hrs, 2 for 24hrs, 4 for 48hrs)

                or 0.0125 * VendorPrice * StackSize * DurationInHours

            Extra Deposit = 0.2 * max(StackBidPrice, StackBuyPrice) / StackSize
                Extra Deposit is added to some Trade goods

            -- ### todo: figure out proper rounding algorithm
		--]]

		local itype = type(item)
		if itype == "number" then
			itemID = tostring(item)
			vendor, classID, subclassID = AucAdvanced.GetItemInfoCache(item, 11)
		elseif itype == "string" then
			local head, id, _ = strsplit(":", item, 3)
			local ltype = head:sub(-4)
			if ltype == "epet" then -- battlepet
				vendor = 0
			elseif ltype == "item" then
				vendor, classID, subclassID = AucAdvanced.GetItemInfoCache(item, 11)
				itemID = id
			else
				return
			end
		else
			return
		end

		if vendor then
            --local start_duration = duration -- DEBUGGING
			duration = AuctionDurationCode[duration] or 3       -- default to max time (most common case) if no duration given or invalid
			if not stacksize or stacksize < 1 then stacksize = 1 end
            local deposit = 0
            local hours = LookupDurationHours[duration]
            local vendstack = stacksize*vendor
            local DepositMultiplier = 0.0125    --- multiplier in Current (48 hour max)

            -- ccox - NOTE - the real game function may have more inflection points, but this matches items from 5c to 2g exactly
            -- Current may use a similar function as the math is close to /20, need to test
            if AucAdvanced.Classic then
                if (vendstack < 80) then
                    deposit = floor( (vendstack+12)/24 )
                else
                    deposit = floor(vendstack/20)
                end
                deposit = deposit * hours / 2
            else
                deposit = DepositMultiplier * vendstack * hours
            end

            --debugPrint("deposit: "..deposit.." stack: "..stacksize.." hours: "..hours.." start_duration: "..start_duration, "CorePost", "Debugging", "Warning")

			if (not AucAdvanced.Classic) and (classID == LE_ITEM_CLASS_TRADEGOODS) then
				-- additional deposit fee for certain tradegoods
				if not (lookupExcludeSubclass[subclassID] or lookupExceptionID[itemID]) then
					local extra = max(bidprice or 1, buyprice or 0)
					extra = .2 * extra / stacksize -- extra fee is not affected by auction duration
					if extra > MAX_EXTRA_FEE then
						extra = MAX_EXTRA_FEE
					end
					deposit = deposit + extra
				end
			end

			deposit = floor(deposit) -- ### try rounding to coppers as last thing...

			if deposit < MINIMUM_DEPOSIT then
				deposit = MINIMUM_DEPOSIT
			end

			return deposit * (numstacks or 1)
		end
	end

	function GetDepositCost(item, duration, unused, count)
		-- ### temporary wrapper until we convert all our calls
		-- calls lib.GetDepositCost inserting default (i.e. fake) values for missing arguaments
		return lib.GetDepositCost(item, duration, 10000 * count, 0, count, 1)
	end

	lib.DepositCostDebugVersion = 2 -- ### temp value for use by debugging tools for GetDepositCost
end

function GetDepositCost(item, duration, unused, count)
	-- ### temporary wrapper until we convert all our calls
	-- calls lib.GetDepositCost inserting default (i.e. fake) values for missing arguaments
	return lib.GetDepositCost(item, duration, 10000 * count, 0, count, 1)
end

do
--[[ SigLock
	'Locks' a sig to prevent ProcessPosts from posting it until certain conditions apply
	This attempts to avoid Internal Auction Errors, which can sometimes be caused by
	trying to post multiple requests of the same item before the bags are updated
--]]
	local lockedsigs
	local lastlocktime
	function private.IsSigLocked(sig)
		if lockedsigs then
			if not sig or lockedsigs[sig] then
				return true
			end
		end
	end
	function private.GetSigLockCount(sig)
		-- return count of items posted for locked sig
		if lockedsigs and lockedsigs[sig] then
			return lockedsigs[sig].postedcount
		end
		return 0
	end
	function private.LockSig(request)
		local sig = request.sig
		local postedcount = request.count * request.posted
		local expectedcount = request.totalcount - postedcount
		lastlocktime = GetTime()
		if not lockedsigs then lockedsigs = {} end
		lockedsigs[sig] = {
			expectedcount = expectedcount,
			postedcount = postedcount,
		}
	end
	function private.SigLockClear()
		-- called when the posting timer is deactivated
		lockedsigs = nil
	end
	function private.SigLockBagUpdate()
		if not lockedsigs then return end
		-- BAG_UPDATE events often occur in batches
		-- so throttle our checks by delaying until the next OnUpdate
		private.Wait(0)
	end
	function private.SigLockUpdate()
		if not lockedsigs then return end
		-- use longer timeout delays if connectivity is bad, but always at least 1 second
		-- todo: is the lag adjustment really necessary or useful?
		local _,_, lag = GetNetStats()
		lag = max(lag * LAG_ADJUST, 1)
		if GetTime() > lastlocktime + lag * SIGLOCK_TIMEOUT then
			-- global timeout for all SigLocks based on when the last item was locked
			lockedsigs = nil
			debugPrint("All SigLocks cleared due to timeout", "CorePost", "SigLock Timeout", "Info")
			return
		end

		-- count items in bags (only for locked sigs)
		local sigcounts = {}
		for bag = 0, NUM_BAG_FRAMES do
			for slot = 1, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				if link then
					local sig = GetSigFromLink(link)
					if lockedsigs[sig] then
						local _, count = GetContainerItemInfo(bag, slot)
						if not count or count < 1 then count = 1 end
						sigcounts[sig] = (sigcounts[sig] or 0) + count
					end
				end
			end
		end
		-- test each sig to see if it can be unlocked
		for sig, data in pairs(lockedsigs) do
			if not sigcounts[sig] or sigcounts[sig] <= data.expectedcount then
				-- number of items in bags now matches (or less than) expected count
				lockedsigs[sig] = nil
			end
		end
		if not next(lockedsigs) then lockedsigs = nil end -- delete table if empty
	end
end -- SigLock

--[[ PRIVATE: RequestDisplayString(request [, link])
	Generates a display string for use in printout
--]]
function private.RequestDisplayString(request, link)
	local msg = link or request.exactLink or request.link or AucAdvanced.API.GetLinkFromSig(request.sig) or "|cffff0000[Unknown]|r"
	local count = request.count
	local numstacks = request.stacks
	if count > 1 then
		msg = msg.."x"..count
	end
	if numstacks > 1 then
		msg = numstacks.." * "..msg
	end
	return msg
end

--[[ PRIVATE: HandlePostingError1
	Consolidates messaging and processing for a certain style of posting error (number 1, in case we add more styles later)
--]]
function private.HandlePostingError1(request, reason, special)
	private.Wait(POST_ERROR_PAUSE)
	local msg = ("%s not posted\n%s"):format(private.RequestDisplayString(request), lib.GetErrorText(reason))
	if type(special) == "string" then
		msg = msg.."\n("..special..")"
	end
	debugPrint(msg, "CorePost", "Post request failed", "Warning")
	AucAdvanced.SendProcessorMessage("postresult", false, request.id, request, reason)
	if private.IsReportableError(special) then
		geterrorhandler()("Auctioneer CorePost Error: "..msg)
	else
		message(msg)
	end
end

function private.TrackPostingSuccess()
	local request = private.GetQueueIndex(1)
	if not (request and request.posting) then return end
	local posted = request.posted + 1
	request.posted = posted
	if posted >= request.stacks then -- all stacks posted
		private.ClearAuctionSlot()
		private.LockSig(request)
		private.QueueRemove()
		private.Wait(POST_THROTTLE)
	else
		request.posting = GetTime() -- renew timeout for the next stack
	end
	AucAdvanced.SendProcessorMessage("postresult", true, request.id, request)
end

function private.TrackPostingMultisellFail()
	private.ClearAuctionSlot()
	local request = private.GetQueueIndex(1)
	if not (request and request.posting) then return end
	local link = request.link
	if not link then return end
	private.LockSig(request)
	private.QueueRemove()
	private.Wait(POST_ERROR_PAUSE)
	AucAdvanced.SendProcessorMessage("postresult", false, request.id, request, "FailMultisell")

	if request.cancelled and not private.lastUIError then
		-- cancelled by user: display a chat message instead of throwing an error
		aucPrint(("Multisell batch of %s was cancelled. %d were posted."):format(private.RequestDisplayString(request, link), request.posted))
	else
		local msg = ("Failed to post all requested auctions of %s (posted %d)"):format(private.RequestDisplayString(request, link), request.posted)
		if private.lastUIError then
			msg = msg.."\nAdditional info: "..private.lastUIError
		end
		debugPrint(msg, "CorePost", "Posting Failure", "Warning")
		geterrorhandler()(msg)
	end
end

function private.TrackCancelSell()
	local request = private.GetQueueIndex(1)
	if not request or not request.posting then return end
	-- flag to suppress error messages when the cancelled Multisell 'fails'
	request.cancelled = true
end

--[[ PRIVATE: SelectStack(request)
	Decide which stack to put into the Auction Slot for posting
--]]
function private.SelectStack(request)
	local sig, count = request.sig, request.count
	local foundBag, foundSlot, foundStop, foundSize

	--[[ Selection algorithm version 4

		Only useful when posting a single stack, as Multisell mode will ignore our selection

		Ignore un-auctionable stacks
		Return nil, nil if any matching stacks are locked
		Find the first stack of the exact size
		Otherwise find the smallest stack larger than the requested size
		Otherwise use the first stack found
	--]]

	for bag = 0, NUM_BAG_FRAMES do
		for slot = 1, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link and GetSigFromLink(link) == sig and lib.IsAuctionable(bag, slot) then
				local _, thiscount, locked = GetContainerItemInfo(bag,slot)
				if locked then
					return -- return immediately if we find a locked stack
				elseif not foundStop then
					if thiscount == count then
						-- found a stack the correct size
						foundBag = bag
						foundSlot = slot
						foundStop = true
					elseif thiscount > count and (not foundSize or thiscount < foundSize) then
						-- find the smallest stack larger than the requested size
						foundSize = thiscount
						foundBag = bag
						foundSlot = slot
					elseif not foundBag then
						-- record the first bag/slot, if none of the above cases apply
						foundBag = bag
						foundSlot = slot
					end
				end
			end
		end
	end

	if foundBag then
		return foundBag, foundSlot
	end

	return nil, "NotFound"
end

function private.ClearAuctionSlot()
	ClearCursor()
	if GetAuctionSellItemInfo() then
		ClickAuctionSellItemButton()
		ClearCursor()
		if GetAuctionSellItemInfo() then
			-- it's locked, wait for it to clear
			return
		end
	end
	return true
end

--[[ PRIVATE: LoadAuctionSlot(request)
	Loads the item specified in 'request' into AuctionSellItem slot
	Performs numerous checks to verify the item is loaded correctly and is postable
	If successful, returns true
	If request is unpostable, returns nil, reason, additional
		reason: errorcode - see entries in ErrorText
		additional: may contain additional error info, used to determine if a full error should be thrown
	(also if unpostable, dequeues the request and attempts to clean up the AuctionSellItem slot)
	Otherwise returns nil, nil, action
		action: code used by Update/Event mechanism
	(Something prevents posting right now, but should clear given enough waiting time)
--]]
function private.LoadAuctionSlot(request)
	if not private.ClearAuctionSlot() then
		return nil, nil, 1 -- wait & watch for bag changes
	end

	local bag, slot = private.SelectStack(request)
	if not bag then
		if slot then -- not postable
			private.QueueRemove()
			return nil, slot, nil
		end
		return nil, nil, 1 -- wait & watch for bag changes
	end

	local link = GetContainerItemLink(bag, slot)
	local itemID = GetContainerItemID(bag, slot)
	if not (link and itemID) then
		private.QueueRemove()
		return nil, "NotFound", nil
	end
	local checkname, checkquality
	if itemID == 82800 then
		-- battlepet special handling
		local _, speciesID, _, breedQuality = strsplit(":", link)
		speciesID = tonumber(speciesID)
		if speciesID then
			checkname = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
			checkquality = tonumber(breedQuality)
		end
	else
		local na,_,qu = GetItemInfo(link)
		checkname, checkquality = na, qu
	end
	if not (checkname and checkquality) then
		private.QueueRemove()
		return nil, "UnknownItem", nil
	end

	PickupContainerItem(bag, slot)
	if not CursorHasItem() then
		-- failed to pick up from bags, probably due to some unfinished operation; wait for another cycle
		return nil, nil, 1 -- wait & watch for bag changes
	end

	private.lastUIError = nil
	if not AuctionFrameAuctions.duration then
		-- Fix in case Blizzard_AuctionUI hasn't set this value yet (causes an error otherwise)
		-- todo: periodically check if this is still needed
		AuctionFrameAuctions.duration = 2
	end
	ClickAuctionSellItemButton()

	-- verify that the contents of the Auction slot are what we expect
	local name, texture, count, quality, canUse, price, pricePerUnit, stackCount, totalCount, slotItemID = GetAuctionSellItemInfo()
	if slotItemID ~= itemID or name ~= checkname or quality ~= checkquality then
		-- failed to drop item in auction slot, probably because item is not auctionable (but was missed by our checks)
		private.ClearAuctionSlot()
		private.QueueRemove()
		return nil, "FailSlot", private.lastUIError
	end
	if private.lastUIError then
		-- error can only have come from ClickAuctionSellItemButton or GetAuctionSellItemInfo
		-- but item in slot appears to be correct
		-- report for debugging
		private.ClearAuctionSlot() -- Put it back in the bags
		private.QueueRemove()
		return nil, "UnknownError", private.lastUIError
	end
	--[[ Temporary fix {ADV-655}
		GetAuctionSellItemInfo returns incorrect totalCount for battlepets (always returns 1)
		to be removed when Blizzard fixes the API (CountAvailableItems is not a particularly efficient or reliable way to do this)
	--]]
	if itemID == 82800 then
		local _, tc = lib.CountAvailableItems(request.sig)
		totalCount = tc
	end

	if totalCount < request.count * request.stacks then
		local doAbort = true
		-- Provisional fix for GetAuctionSellItemInfo sometimes returning incorrect counts
		-- This only appears to be a problem when multiposting items with a stack size of 1
		if request.count == 1 and request.stacks > 1 and totalCount > 0 then
			local _, countAvail, unpostable = lib.CountAvailableItems(request.sig)
			if countAvail then
				local newTotalCount = countAvail -- store unadjusted count to store into totalCount at end of this block
				if unpostable then countAvail = countAvail - unpostable end
				if countAvail >= request.count * request.stacks then
					-- looks like we have enough items to fulfil request, but GetAuctionSellItemInfo is returning incorrect count
					-- we won't be able to post them all in one go; post as many as we can and requeue the remainder
					-- we should be able to post totalCount stacks immediately, so we should requeue request.stacks - totalCount
					doAbort = false
					-- queue a new request to post the remainder
					lastPostId = lastPostId + 1
					local newrequest = {
						sig = request.sig,
						count = request.count, -- this will always be 1
						bid = request.bid,
						buy = request.buy,
						duration = request.duration,
						stacks = request.stacks - totalCount, -- try to post the remainder in one go; if this fails again this code should split it again, unless size reaches 1
						id = lastPostId,
						posted = 0,
						linkType = request.linkType,
					}
					private.QueueInsert(newrequest)
					-- change current request to only post totalCount stacks
					request.stacks = totalCount
					-- Use correct totalCount below (stored in request.totalcount)
					totalCount = newTotalCount
				end
			end
		end
		if doAbort then
			-- not enough items to complete this request; abort whole request
			private.ClearAuctionSlot() -- Put it back in the bags
			private.QueueRemove()
			return nil, "NotEnough", nil
		end
	end
	local depositBlizz = GetAuctionDeposit(request.duration, request.bid, request.buy, request.count, request.stacks)
	if GetMoney() < depositBlizz then
		-- not enough money to pay the deposit
		private.ClearAuctionSlot() -- Put it back in the bags
		private.QueueRemove()
		return nil, "PayDeposit", nil
	end

	request.link = link -- store specific link (uniqueID)
	request.totalcount = totalCount -- this will be used by the SigLock mechanism
	request.selectedcount = count -- used by the Prompt sanity checks
	request.name = name -- used by the Prompt sanity checks
	request.quality = quality
	request.texture = texture -- displayed in the Prompt
	request.depositB = depositBlizz

	local depositCalc = lib.GetDepositCost(link, request.duration, request.bid, request.buy, request.count, request.stacks)
	if depositBlizz and depositBlizz > depositCalc * 1.05 then -- ### for now we test with a small leeway to allow for round - we don't know the rounding algorithm yet
		return true, nil, -1 -- flag to prevent immediate posting (should popup the positng prompt instead, which will display deposit cost)
	end
	return true
end

--[[ PRIVATE: VerifyAuctionSlot(request)
	Checks that the item in the AuctionSellItem slot still matches the item in 'request' and is still sellable
	Used while the Prompt is open to see if something has changed
--]]
function private.VerifyAuctionSlot(request)
	local name, texture, count, quality, canUse, price, pricePerUnit, stackCount, totalCount = GetAuctionSellItemInfo()
	if name ~= request.name or quality ~= request.quality or count ~= request.selectedcount then
		-- Either slot has been cleared, or has been replaced with something else
		return nil, "FailSlot"
	end
	if totalCount < request.count * request.stacks then
		return nil, "NotEnough"
	end
	if GetMoney() < GetAuctionDeposit(request.duration, request.bid, request.buy, request.count, request.stacks) then -- ### use request.depositB here?
		return nil, "PayDeposit"
	end

	return true
end

--[[ PRIVATE: PerformPosting()
	Called from the Prompt Yes/Continue button
	Note: silently does nothing when prompt is hidden, to handle macro spam
--]]
function private.PerformPosting()
	local request = private.promptRequest
	private.HidePrompt()
	if not request then return end

	-- Sanity checks
	if request ~= private.GetQueueIndex(1) then return end
	if not private.VerifyAuctionSlot(request) then return end

	local success, reason, special = private.StartAuction(request)
	if not success then
		private.HandlePostingError1(request, reason, special)
	end
end

--[[ PRIVATE: CancelPosting()
	Called from the Prompt No/Cancel button
--]]
function private.CancelPosting()
	local request = private.promptRequest
	private.HidePrompt()
	if request and request == private.GetQueueIndex(1) then
		private.ClearAuctionSlot()
		private.QueueRemove()
	end
end

--[[ PRIVATE: ShowPrompt(request)
	Display the confirmation prompt
	Item must already be loaded in AuctionSellItem slot
--]]
function private.ShowPrompt(request)
	if private.promptRequest then
		error("CorePost:ShowPrompt - private.promptRequest is not nil")
	end
	if private.Prompt:IsShown() then
		error("CorePost:ShowPrompt - Prompt is already shown")
	end
	private.promptRequest = request
	request.prompt = true
	private.Prompt:Show()
	private.Prompt.Text1:SetText("Ready to post "..private.RequestDisplayString(request))
	private.Prompt.Text2:SetText("Min Bid "..AucAdvanced.Coins(request.bid, true)..", Buyout "..AucAdvanced.Coins(request.buy, true))
	private.Prompt.Text3:SetText("Deposit "..AucAdvanced.Coins(request.depositB, true))
	private.Prompt.Item.tex:SetTexture(request.texture)
	local headwidth = (private.Prompt.Heading:GetStringWidth() or 0) + 70
	local width1 = (private.Prompt.Text1:GetStringWidth() or 0) + 70
	local width2 = (private.Prompt.Text2:GetStringWidth() or 0) + 70
	local width3 = (private.Prompt.Text3:GetStringWidth() or 0) + 70
	private.Prompt.Frame:SetWidth(max(headwidth, width1, width2, width3, PROMPT_MIN_WIDTH))
end

--[[ PRIVATE: HidePrompt()
	Close the prompt and tidy up flags
	May be safely called at any time
--]]
function private.HidePrompt()
	local request = private.promptRequest
	private.Prompt:Hide()
	private.promptRequest = nil
	if request then
		request.prompt = nil
	end
end


--[[ PRIVATE: StartAuction(request)
	Starts the auction
	Item must already be loaded in AuctionSellItem slot
	Must only be called from within an OnClick handler (hardware event required)
--]]
function private.StartAuction(request)
	debugPrint("Starting auction "..private.RequestDisplayString(request), "CorePost", "Starting Auction", "Info")
	private.lastUIError = nil
	PostAuction(request.bid, request.buy, request.duration, request.count, request.stacks)
	if private.IsBlockingError(private.lastUIError) then
		-- UI Error is one of the known Auction errors that prevent posting
		private.ClearAuctionSlot() -- Put it back in the bags
		private.QueueRemove()
		return nil, "FailStart", private.lastUIError
	end
	request.posting = GetTime() -- record time of posting for calculating timeout

	return true
end


--[[
	Frame for OnUpdate and OnEvent handlers
]]

local EventFrame = CreateFrame("Frame")
local EventFrameTimer -- Countdown timer
EventFrame:Hide() -- Timer is initially stopped
local function UpdateHandler(self, elapsed)
	EventFrameTimer = EventFrameTimer - elapsed
	if EventFrameTimer > 0 then return end
	private.Wait(POST_TIMER_INTERVAL) -- set default wait time (overwritten later in certain cases)
	private.waitBagUpdate = nil
	private.SigLockUpdate()

	if lib.GetQueueLen() <= 0 or not (AuctionFrame and AuctionFrame:IsVisible()) then
		if not private.IsSigLocked() then -- check for *any* sig locks
			private.Wait() -- put timer to sleep
		end
		return
	end

	local request = private.GetQueueIndex(1)

	if request.prompt then
		return
	end
	if request.posting then
		-- This request is being posted. Check for timeout
		-- (Other success/fail situations are handled by the TrackPostingX functions)
		-- use longer timeout delays if connectivity is bad, but always at least 1 second
		-- todo: is lag adjustment really necessary or useful?
		local _,_, lag = GetNetStats()
		lag = max(lag * LAG_ADJUST, 1)
		if GetTime() > request.posting + lag * POST_TIMEOUT then
			private.QueueRemove()
			private.HandlePostingError1(request, "FailTimeout", private.lastUIError)
		end
		return
	end

	if private.IsSigLocked(request.sig) then
		-- see if we can find a request in the queue that is not SigLocked
		for index, req in private.GetQueueIterator() do
			if not private.IsSigLocked(req.sig) then
				private.QueueReorder(index, 1) -- move to the front of the queue
				private.Wait(0) -- wait for next OnUpdate
				return
			end
		end
		-- otherwise wait for the SigLock(s) to clear
		return
	end

	local success, reason, special = private.LoadAuctionSlot(request)
	if success then
		private.ShowPrompt(request)
	elseif reason then
		private.HandlePostingError1(request, reason, special)
	else
		if special == 1 then
			private.waitBagUpdate = true
		end
	end
end
EventFrame:SetScript("OnUpdate", UpdateHandler)

--[[
	PRIVATE: Wait(delay)
	Used to control the timer and event handler
	Use delay = nil to stop the timer
	Use delay >= 0 to start the timer and set the delay length
--]]
function private.Wait(delay)
	if delay then
		if not EventFrameTimer then
			EventFrame:Show()
		end
		EventFrameTimer = delay
	else
		if EventFrameTimer then
			EventFrame:Hide()
			EventFrameTimer = nil
		end
		private.SigLockClear()
	end
end

local function EventHandler(self, event, arg1, arg2)
	if not EventFrameTimer then
		if event == "AUCTION_HOUSE_SHOW" then
			if lib.GetQueueLen() > 0 then
				private.Wait(0) -- wake up timer
			end
		end
		return
	end
	if event == "CHAT_MSG_SYSTEM" then
		if arg1 == ERR_AUCTION_STARTED then
			private.TrackPostingSuccess()
		end
	elseif event == "UI_ERROR_MESSAGE" then
		private.lastUIError = arg2
	elseif event == "AUCTION_MULTISELL_START" then
		if AuctionProgressFrame.fadeOut then
			-- stop the fade and set alpha back to full
			-- AuctionProgressFrame is a global defined in Blizzard_AuctionUI
			AuctionProgressFrame.fadeOut = nil
			AuctionProgressFrame:SetAlpha(1)
		end
	--elseif event == "AUCTION_MULTISELL_UPDATE" then
	elseif event == "AUCTION_MULTISELL_FAILURE" then
		private.TrackPostingMultisellFail()
	elseif event == "ITEM_LOCK_CHANGED" then
		if private.waitBagUpdate then
			private.waitBagUpdate = nil
			private.Wait(0)
		end
	elseif event == "BAG_UPDATE" then
		private.SigLockBagUpdate()
		if private.waitBagUpdate then
			private.waitBagUpdate = nil
			private.Wait(0)
		end
	elseif event == "AUCTION_HOUSE_CLOSED" then
		if lib.GetQueueLen() > 0 then
			private.HidePrompt()
			if AucAdvanced.Settings.GetSetting("post.clearonclose") then
				if AucAdvanced.Settings.GetSetting("post.confirmonclose") then
					StaticPopup_Show("POST_CANCEL_QUEUE_AH_CLOSED")
				else
					lib.CancelPostQueue()
				end
			end
			-- if currently multiselling, it will fail - treat as deliberate cancel to suppress error
			private.TrackCancelSell()
		end
	elseif event == "NEW_AUCTION_UPDATE" then
		-- something has changed about the AuctionSellItem slot - should not happen while we are Prompting
		if private.promptRequest and not private.VerifyAuctionSlot(private.promptRequest) then
			private.HidePrompt()
		end
	end
end
EventFrame:SetScript("OnEvent", EventHandler)
EventFrame:RegisterEvent("CHAT_MSG_SYSTEM")
EventFrame:RegisterEvent("UI_ERROR_MESSAGE")
EventFrame:RegisterEvent("AUCTION_MULTISELL_START")
--EventFrame:RegisterEvent("AUCTION_MULTISELL_UPDATE")
EventFrame:RegisterEvent("AUCTION_MULTISELL_FAILURE")
EventFrame:RegisterEvent("ITEM_LOCK_CHANGED")
EventFrame:RegisterEvent("BAG_UPDATE")
EventFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
EventFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")
EventFrame:RegisterEvent("NEW_AUCTION_UPDATE")

function private.OnLoadRunOnce()
	private.OnLoadRunOnce = nil
	-- Install values into locals/tables, that are not available until Auctioneer is fully loaded
	DecodeSig = AucAdvanced.API.DecodeSig
	GetSigFromLink = AucAdvanced.API.GetSigFromLink
	for code, text in pairs(ErrorText) do
		local transkey = "ADV_Help_PostError"..code
		local transtext = _TRANS(transkey)
		if transtext ~= transkey then -- _TRANS returns transkey if there is no available translation
			ErrorText[code] = transtext
		end
	end
end
function coremodule.OnLoad(addon)
	if addon == "auc-advanced" and private.OnLoadRunOnce then
		private.OnLoadRunOnce()
	end
end

coremodule.Processors = {
	gameactive = function()
		private.InitDepositCostData()
	end,
}

-- Other hooks
private.hook_CancelSell = CancelSell
CancelSell = function(...)
	private.TrackCancelSell() -- needs to be pre-hooked
	return private.hook_CancelSell(...)
end

StaticPopupDialogs["POST_CANCEL_QUEUE_AH_CLOSED"] = {
  text = "The Auctionhouse has closed. Do you want to clear the Posting queue?",
  button1 = YES,
  button2 = NO,
  OnAccept = lib.CancelPostQueue,
  timeout = 20,
  whileDead = true,
  hideOnEscape = true,
}

--[[ Prompt Frame ]]--
-- (Cloned and modified from CoreBuy)

--this is a anchor frame that never changes size
private.Prompt = CreateFrame("Frame", "AuctioneerPostPrompt", UIParent)
private.Prompt:Hide()
private.Prompt:SetPoint("CENTER", UIParent, "CENTER", 0, -50)
private.Prompt:SetFrameStrata("DIALOG")
private.Prompt:SetHeight(PROMPT_HEIGHT)
private.Prompt:SetWidth(PROMPT_MIN_WIDTH)
private.Prompt:SetMovable(true)
private.Prompt:SetClampedToScreen(true)

--The "graphic" frame and backdrop that we resize
private.Prompt.Frame = CreateFrame("Frame", nil, private.Prompt)
private.Prompt.Frame:SetPoint("CENTER", private.Prompt, "CENTER" )
private.Prompt.Frame:SetFrameLevel(private.Prompt:GetFrameLevel() - 1) -- lower level than parent (backdrop)
private.Prompt.Frame:SetHeight(PROMPT_HEIGHT)
private.Prompt.Frame:SetWidth(PROMPT_MIN_WIDTH)
private.Prompt.Frame:SetClampedToScreen(true)
private.Prompt.Frame:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 9, right = 9, top = 9, bottom = 9 }
})
private.Prompt.Frame:SetBackdropColor(0,0,0,0.8)

-- Helper functions
local function ShowTooltip()
	local link = private.promptRequest and (private.promptRequest.link or private.promptRequest.exactLink)
	if not link then return end
	local linkType = private.promptRequest.linkType
	GameTooltip:SetOwner(private.Prompt.Item, "ANCHOR_TOPRIGHT")
	if linkType == "item" then
		GameTooltip:SetHyperlink(link)
	elseif linkType == "battlepet" then
		local _, speciesID, level, breedQuality, maxHealth, power, speed, battlePetID = strsplit(":", link)
		-- BattlePetToolTip_Show gets the anchor point from GameTooltip
		BattlePetToolTip_Show(tonumber(speciesID), tonumber(level), tonumber(breedQuality), tonumber(maxHealth), tonumber(power), tonumber(speed), string.gsub(string.gsub(link, "^(.*)%[", ""), "%](.*)$", ""))
	end
end
local function HideTooltip()
	GameTooltip:Hide()
	if BattlePetTooltip then
		BattlePetTooltip:Hide()
	end
end
local function DragStart()
	private.Prompt:StartMoving()
end
local function DragStop()
	private.Prompt:StopMovingOrSizing()
end

private.Prompt.Item = CreateFrame("Button", nil, private.Prompt) -- todo: does this really need to be a button?
private.Prompt.Item:SetNormalTexture("Interface\\Buttons\\UI-Slot-Background")
private.Prompt.Item:GetNormalTexture():SetTexCoord(0,0.640625, 0, 0.640625)
private.Prompt.Item:SetPoint("TOPLEFT", private.Prompt.Frame, "TOPLEFT", 15, -15)
private.Prompt.Item:SetHeight(37)
private.Prompt.Item:SetWidth(37)
private.Prompt.Item:SetScript("OnEnter", ShowTooltip)
private.Prompt.Item:SetScript("OnLeave", HideTooltip)
private.Prompt.Item.tex = private.Prompt.Item:CreateTexture(nil, "OVERLAY")
private.Prompt.Item.tex:SetPoint("TOPLEFT", private.Prompt.Item, "TOPLEFT", 0, 0)
private.Prompt.Item.tex:SetPoint("BOTTOMRIGHT", private.Prompt.Item, "BOTTOMRIGHT", 0, 0)

private.Prompt.Heading = private.Prompt:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
private.Prompt.Heading:SetPoint("CENTER", private.Prompt.Frame, "CENTER", 20, 38)
private.Prompt.Heading:SetText("Auctioneer needs a confirmation to continue posting")

private.Prompt.Text1 = private.Prompt:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
private.Prompt.Text1:SetPoint("CENTER", private.Prompt.Frame, "CENTER", 20, 18)

private.Prompt.Text2 = private.Prompt:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
private.Prompt.Text2:SetPoint("CENTER", private.Prompt.Frame, "CENTER", 20, -2)

private.Prompt.Text3 = private.Prompt:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
private.Prompt.Text3:SetPoint("CENTER", private.Prompt.Frame, "CENTER", 20, -22)


-- Yes and No buttons are named to allow macros to /click them
private.Prompt.Yes = CreateFrame("Button", "AuctioneerPostPromptYes", private.Prompt, "OptionsButtonTemplate")
private.Prompt.Yes:SetText(CONTINUE)
private.Prompt.Yes:SetPoint("BOTTOMLEFT", private.Prompt, "BOTTOMLEFT", 100, 10)
private.Prompt.Yes:SetScript("OnClick", private.PerformPosting)

private.Prompt.No = CreateFrame("Button", "AuctioneerPostPromptNo", private.Prompt, "OptionsButtonTemplate")
private.Prompt.No:SetText(CANCEL)
private.Prompt.No:SetPoint("BOTTOMLEFT", private.Prompt.Yes, "BOTTOMRIGHT", 60, 0)
private.Prompt.No:SetScript("OnClick", private.CancelPosting)

private.Prompt.DragTop = CreateFrame("Button", nil, private.Prompt)
private.Prompt.DragTop:SetPoint("TOPLEFT", private.Prompt, "TOPLEFT", 10, -5)
private.Prompt.DragTop:SetPoint("TOPRIGHT", private.Prompt, "TOPRIGHT", -10, -5)
private.Prompt.DragTop:SetHeight(6)
private.Prompt.DragTop:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
private.Prompt.DragTop:SetScript("OnMouseDown", DragStart)
private.Prompt.DragTop:SetScript("OnMouseUp", DragStop)

private.Prompt.DragBottom = CreateFrame("Button", nil, private.Prompt)
private.Prompt.DragBottom:SetPoint("BOTTOMLEFT", private.Prompt, "BOTTOMLEFT", 10, 5)
private.Prompt.DragBottom:SetPoint("BOTTOMRIGHT", private.Prompt, "BOTTOMRIGHT", -10, 5)
private.Prompt.DragBottom:SetHeight(6)
private.Prompt.DragBottom:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
private.Prompt.DragBottom:SetScript("OnMouseDown", DragStart)
private.Prompt.DragBottom:SetScript("OnMouseUp", DragStop)


AucAdvanced.RegisterRevision("$URL: Auc-Advanced/CorePost.lua $", "$Rev: 6430 $")
AucAdvanced.CoreFileCheckOut("CorePost")
