--[[
	Auctioneer
	Version: 8.2.6420 (SwimmingSeadragon)
	Revision: $Id: CoreScan.lua 6420 2019-09-13 05:07:31Z none $
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
	Auctioneer Scanning Engine.

	Provides a service to walk through an AH Query, reporting changes in the AH to registered utilities and stats modules

	System Overview

		Overloads function QueryAuctionItems.
			when called checks to see if a scan is in progress.
			If we are currently in a scan, store the last recieved page if not saved just in case (shouldn't be necessary).
			Scrubs parameters for when called directly to keep D/Cs from happening (like Blizzard does via UI)
			If in a scan and the current call doesn't match it, commits current scan.
			Else if not in a scan, record the start of a new scan including whether a manual or automated scan.
			if first page of scan, indicate to all clients that a scan has started.
			calls original Blizzard QueryAuctionItems.

		We add a listener on the AH window, and fire every frame it is opened.
			If commit coroutine is asleep, resume it.
			If commit routine is dead and there are scans needing committed, wake it up.
			If current scan is paused or an error occurs, exit out of routine to cut loading on system.
			If scans are queued and we are not currently active scanning, start the next scan and exit.
			If an ah request has been sent and we haven't started to store page, exit if if know data isn't ready to be stored.
			If a store routine is going and is suspended, restart it (if been stopped long enough)
			If it is time to get the next page in an automated scan, send the next page query and exit.
			If AH is open and we were unexpected closed earlier, restart last scan here and exit.
			If AH is open and we made it here start to Store last page recieved.
			IF AH is not open, pause the current scan and put it on the scan stack.

		Storing a Page.
			When a store page is requested, it starts a coroutine.  The coroutine is responsible for all work.
			Note: store page keeps verifying throughout that store hasn't been requested to stop.  It exits immediately if it has.
			Also, this area uses defaults for items from GetItemInfo instead of calling for each auction.
			If a getAll scan, turn off updating of AH Windows.
			Updates scan processors that the page is being stored.
			skips walking through and storing auctions if page isn't later than pages already done.
			walks through all auctions returned.  If data is ready, stores it in page store.  If not, records location # in retry list.
			while retry list has items and retries left is greater than 0, do following
				pauses for 1 second
				decrement retries left
				walks through all auctions in retries list.
					If data is ready, stores it in page store and resets retry count to max.
					If not, records location # in newRetry list.
				replaces retry list with newRetry list.

			add the items to the scan store and record what the next page we need is.
			if isGetAll, put AH Window back in normal state.
			otherwise if an automated scan and there are more pages, start the scan of the next page.
			otherwise if an automated scan then Commit the scan.
			otherwise if a manual scan and on the last page, commit the scan.

			this routine means that a page store can take up to NumActionsOnPage*RetryCount seconds to complete
			for a default page, that is 5 minutes.  For a getall, it could take forever.
			In practice, it adds up to 15 seconds to what already happens for a regular page, and 5 minutes for getAll.

		Committing a scan.
			the commit routine is responsible for storing the scan store into a list and then starting a coroutine (if not already running) that can commit it.
			The coroutine runs in a loop until there are no more items in the commit queue.
			Pull first item from commit queue.

			Stage 1.  Pre-Process new scan. Retrieve item info
			While itemlink lookup has entries and retry count not 0
				create empty next itemlink lookup table
				decrement retry count
				Walk through items in itemlink lookup
					call GetItemInfo for item
					If GetItemInfo returns data
						walk through auction list and fix up data returned for each.
						reset retry count to max.
					else add item to next itemLink lookup
				replace itemlink lookup with next itemLink lookup
			if there are still items in itemlink lookup
				walk scan table from back to front, and remove any item with an ILEVEL of -1
				mark scan an an incomplete scan.


			Stage 2.  Prep AH Image
				mark all auctions in auction house image that match current scan as still needing resolved against scan
				mark all auctions in auction house image that don't match current scan as NOT needing resolved against scan
				build a look-up table for the next stage

			Stage 3.  Merge new scan with AH Image
				walk through all items in new scan.
				if a match is found in AH Image that still needs resolved
					if auction in AH Image was not filtered then
						check if AH exactly matches current info.
						if not, then send 'update' processor message.
						otherwise send 'leave' processor message.
					update item in AH Image from scan info and mark entry as resolved.
				otherwise
					send 'filter' processor message.
					If no filters indicate auction to be filtered, then
						send 'create' processor message.
					otherwise
						add flag to auction to indicate it is filtered.
					add auction to AH Image.

			Stage 4.  Remove unseen from AH Image
				walk through all items in AH Image
				if needs resolved then
					if expired, then remove from image, sending 'delete' processor message
					otherwise if not expired and a complete scan, remove from image, sending 'delete' process message
					otherwise if flagged unseen prior scan, remove from image sending 'delete' processor message
					otherwise mark unseen in AH Scan image.
]]
local _G = _G
local AucAdvanced = AucAdvanced
if not AucAdvanced then return end
AucAdvanced.CoreFileCheckIn("CoreScan")
local coremodule, internalScan, private = AucAdvanced.GetCoreModule("CoreScan", "Scan", true, "CoreScan")
if not coremodule or not internalScan then return end -- Someone has explicitely broken us
local lib = AucAdvanced.Scan

local SCANDATA_VERSION = "A" -- must match Auc-ScanData INTERFACE_VERSION

local TOLERANCE_LOWERLIMIT = 50
local TOLERANCE_TAPERLIMIT = 10000

local Const = AucAdvanced.Const
local Resources = AucAdvanced.Resources
local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill, _TRANS = AucAdvanced.GetModuleLocals()
local ResolveServerKey = AucAdvanced.ResolveServerKey
local EquipCodeToInvType = AucAdvanced.Const.AC_EquipCode2InvTypeID

local table, tinsert, tremove, gsub, string, coroutine, pcall, time = _G.table, _G.tinsert, _G.tremove, _G.gsub, _G.string, _G.coroutine, _G.pcall, _G.time
local ceil, math, mod, floor = _G.ceil, _G.math, _G.mod, _G.floor
local unpack, select = _G.unpack, _G.select
local bitand, bitor, bitnot = bit.band, bit.bor, bit.bnot
local type, wipe = type, wipe
local pairs, ipairs, next = _G.pairs, _G.ipairs, _G.next
local tonumber = tonumber
local strfind = _G.string.find
local GetTime = GetTime
local GetInboxInvoiceInfo, GetInboxItem, GetInboxHeaderInfo = _G.GetInboxInvoiceInfo, _G.GetInboxItem, _G.GetInboxHeaderInfo

local ExpiredLocale = AUCTION_EXPIRED_MAIL_SUBJECT:gsub("%%s", "") --remove the %s
local SalePendingLocale = AUCTION_INVOICE_MAIL_SUBJECT:gsub("%%s", "") --sale pending (temp invoice)
local OutbidLocale = AUCTION_OUTBID_MAIL_SUBJECT:gsub("%%s", "(.+)")
local CancelledLocale = AUCTION_REMOVED_MAIL_SUBJECT:gsub("%%s", "")
local SuccessLocale = AUCTION_SOLD_MAIL_SUBJECT:gsub("%%s", "")
local WonLocale = AUCTION_WON_MAIL_SUBJECT:gsub("%%s", "")

private.isScanning = false
private.auctionItemListUpdated = false

-- Only the following entries in a valid itemdata table are permitted to be nil or false
local ItemDataAllowedNil = {
	[Const.IEQUIP] = true,
	[Const.AMHIGH] = true,
	[Const.CANUSE] = true,
	[Const.DEP2] = true,
}

function private.LoadScanData()
	if not private.loadingScanData then
		local _, _, _, _, reason = GetAddOnInfo("Auc-ScanData")
		if IsAddOnLoaded("Auc-ScanData") then
			-- another AddOn has force-loaded Auc-ScanData
			private.loadingScanData = "loading"
		elseif reason ~= "DEMAND_LOADED" then -- unable to be loaded
			private.loadingScanData = "fallback"
			if reason then
				reason = _G["ADDON_"..reason] or reason
			else
				reason = "Unknown reason"
			end
			private.FallbackScanData = reason
		else
			private.loadingScanData = "block" -- prevents re-entry to this function during the LoadAddOn call
			local loaded, reason = LoadAddOn("Auc-ScanData")
			if loaded then
				private.loadingScanData = "loading"
			elseif reason then
				private.loadingScanData = "fallback"
				private.FallbackScanData = _G["ADDON_"..reason] or reason
			else
				-- LoadAddOn sometimes returns nil, nil if called too early during game startup
				-- assume it needs to be called again at a later stage
				private.loadingScanData = nil
			end
		end
	end
	if private.loadingScanData == "loading" then
		local ready, version
		local scanmodule = AucAdvanced.Modules.Util.ScanData
		if scanmodule and scanmodule.GetAddOnInfo then
			ready, version = scanmodule.GetAddOnInfo()
		end
		if version ~= SCANDATA_VERSION then
			private.loadingScanData = "fallback"
			private.FallbackScanData = "Incorrect version"
		elseif ready then
			-- install functions from Auc-ScanData
			private.GetScanData = scanmodule.GetScanData
			lib.ClearScanData = scanmodule.ClearScanData
			-- cleanup
			private.loadingScanData = nil
			private.LoadScanData = nil
			-- signal success
			return private.GetScanData
		end
	end
	if private.loadingScanData == "fallback" then
		-- cannot load Auc-ScanData, go to fallback image handler
		-- we only support 'home' serverKey
		local scandata = {image = {}, scanstats = {ImageUpdated = time()}}
		private.GetScanData = function(serverKey)
			serverKey = ResolveServerKey(serverKey)
			if serverKey == Resources.ServerKey then
				return scandata
			else
				return nil, "No Fallback Data"
			end
		end
		-- fallback message
		local text = format(_TRANS("ADV_Interface_ScanDataNotLoaded"), private.FallbackScanData) --The Auc-ScanData storage module could not be loaded: %s
		if get("core.scan.disable_scandatawarning") then
			aucPrint("|cffff7f3f"..text.."|r")
		else
			message(text)
		end
		-- cleanup
		private.loadingScanData = nil
		private.LoadScanData = nil
		-- signal success
		return private.GetScanData
	end
end

function lib.LoadScanData()
	if private.LoadScanData then private.LoadScanData() end
end

-- scandataTable = private.GetScanData(serverKey)
-- parameter: serverKey (defaults to home serverKey)
-- returns: scandataTable = {image = imageTable, scanstats = scanstatsTable} for the specified serverKey
--     scandataTable should only be modified for home serverKey
-- returns: nil if there is no data for serverKey or if serverKey is invalid; home serverKey will always return a scandataTable
-- CAUTION: the following is a stub function, which will be overloaded with the real function by LoadScanData
function private.GetScanData(serverKey)
	if private.LoadScanData then
		local newfunc = private.LoadScanData()
		if newfunc then
			return newfunc(serverKey)
		else
			return nil, "Stub Loader Still Loading"
		end
	end
	return nil, "Stub Loader Failed"
end

-- AucAdvanced.Scan.ClearScanData(serverKey)
-- AucAdvanced.Scan.ClearScanData(realmName)
-- AucAdvanced.Scan.ClearScanData("SERVER") -- all data for current server (default)
-- AucAdvanced.Scan.ClearScanData("ALL")
-- CAUTION: the following is a stub function, which will be overloaded with the real function by LoadScanData
function lib.ClearScanData(key)
	aucPrint(_TRANS("ADV_Interface_ScanDataNotCleared")) --Scan Data cannot be cleared because {{Auc-ScanData}} is not loaded
end

function lib.StartPushedScan(name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData, options) -- ### Legion : revised, check
	name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData = private.QueryScrubParameters(
		name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData)

	if private.scanStack then
		for _, scan in ipairs(private.scanStack) do
			if not scan[8] and private.QueryCompareParameters(scan[3], name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData) then
				-- duplicate of exisiting queued query
				if (_G.nLog) then
					_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, "Duplicate pushed scan detected, cancelling duplicate")
				end
				return
			end
		end
	else
		private.scanStack = {}
	end

	local query = private.NewQueryTable(name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData)
	query.qryinfo.pushed = true

	local NoSummary
	if type(options) == "table" then
		-- only 1 option so far
		if options.NoSummary or options.nosummary then
			NoSummary = true
		end
	end

	query.qryinfo.nosummary = NoSummary

	if (_G.nLog) then
		_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, ("Starting pushed scan %d (%s)"):format(query.qryinfo.id, query.qryinfo.sig))
	end

	tinsert(private.scanStack, {time(), false, query, {}, {}, false, 0, false, 0})
end

function lib.PushScan()
	if private.isGetAll then
		-- A GetAll scan cannot be Popped; do not allow it to be Pushed
		aucPrint("Warning: Scan cannot be Pushed because it is a GetAll scan")
		return
	end
	if private.isScanning then
		if (_G.nLog) then
			_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, ("Scan %d (%s) Paused, next page to scan is %d"):format(private.curQuery.qryinfo.id, private.curQuery.qryinfo.sig, private.curQuery.qryinfo.page+1))
		end
		-- aucPrint(("Pausing current scan at page {{%d}}."):format(private.curQuery.qryinfo.page+1))
		if not private.scanStack then private.scanStack = {} end
		private.StopStorePage()
		tinsert(private.scanStack, {
			private.scanStartTime,
			private.sentQuery,
			private.curQuery,
			private.curPages,
			private.curScan,
			private.scanStarted,
			private.totalPaused,
			GetTime(),
			private.storeTime
		})
		local oldquery = private.curQuery
		private.curQuery = nil
		private.scanStartTime = nil
		private.scanStarted = nil
		private.totalPaused = nil
		private.curScan = nil
		private.storeTime = nil
		private.curPages = nil
		private.sentQuery = nil
		private.isScanning = false
		private.UpdateScanProgress(false, nil, nil, nil, nil, nil, oldquery)
	end
end

function lib.PopScan()
	if private.scanStack and #private.scanStack > 0 then
		local now, pauseTime = GetTime()
		private.scanStartTime,
		private.sentQuery,
		private.curQuery,
		private.curPages,
		private.curScan,
		private.scanStarted,
		private.totalPaused,
		pauseTime,
		private.storeTime = unpack(private.scanStack[1])
		tremove(private.scanStack, 1)

		private.scanStarted = private.scanStarted or now -- scans created by StartPushedScan measure start time from when first popped
		local elapsed = pauseTime and (now - pauseTime) or 0
		if elapsed > 300 then
			-- 5 minutes old
			--aucPrint("Paused scan is older than 5 minutes, commiting what we have and aborting")
			if (_G.nLog) then
				_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_WARNING, ("Scan %d Too Old, committing what we have and aborting"):format(private.curQuery.qryinfo.id))
			end
			private.Commit(true, false, false) -- Scan terminated early.
			return
		end

		private.totalPaused = private.totalPaused + elapsed
		if (_G.nLog) then
			_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, ("Scan %d Resumed, next page to scan is %d"):format(private.curQuery.qryinfo.id, private.curQuery.qryinfo.page+1))
		end
		--aucPrint(("Resuming paused scan at page {{%d}}..."):format(private.curQuery.qryinfo.page+1))
		private.isScanning = true
		private.sentQuery = false
		private.ScanPage(private.curQuery.qryinfo.page+1)
		private.UpdateScanProgress(true, nil, nil, nil, nil, nil, private.curQuery)
	end
end

--[[Deprecated This function is now in core API]]
function lib.ProgressBars(name, value, show, text, options)
	AucAdvanced.API.ProgressBars(name, value, show, text, options)
end

function lib.StartScan(name, minUseLevel, maxUseLevel, isUsable, qualityIndex, GetAll, exactMatch, filterData, options) -- ### Legion : revised, check
	if AuctionFrame and AuctionFrame:IsVisible() then
		if private.isPaused then
			message("Scanning is currently paused")
			return
		end
		if private.isScanning then
			message("Scan is currently in progress")
			return
		end
		local CanQuery, CanQueryAll = CanSendAuctionQuery()
		if GetAll then
			local now = time()
			if not CanQueryAll then
				local text = "You cannot do a GetAll scan at this time."
				if private.LastGetAll then
					local timeleft = 900 - (now - private.LastGetAll) -- 900 = 15 * 60 sec = 15 min
					if timeleft > 0 then
						local minleft = floor(timeleft / 60)
						local secleft = timeleft - minleft * 60
						text = text.." You must wait "..minleft..":"..secleft.." until you can scan again."
					end
				end
				message(text)
				return
			end

			AucAdvanced.API.BlockUpdate(true, false)
			BrowseSearchButton:Hide()
			lib.ProgressBars("GetAllProgressBar", 0, true, "Auctioneer: Scan waiting for Server")
			private.isGetAll = true -- indicates that certain functions must take special action, and that the above changes need to be undone

			private.LastGetAll = now
		else
			if not CanQuery then
				private.queueScan = {
					name, minUseLevel, maxUseLevel, isUsable, qualityIndex, GetAll, exactMatch, filterData, options
				}
				private.queueScanParams = 9 -- must match the number of entries we put into the table, including nils. Used when unpacking
				return
			end
		end

		local NoSummary
		if type(options) == "table" then
			-- only 1 option so far
			if options.NoSummary or options.nosummary then
				NoSummary = true
			end
		end

		if private.curQuery then
			private.Commit(true, false, false) -- sets private.curQuery to nil and commits prior cancelled query
		end

		private.isScanning = true
		local startPage = 0

		lib.SetAuctioneerQuery() -- flag the following query as coming from Auctioneer
		SortAuctionClearSort("list")
		QueryAuctionItems(name, minUseLevel, maxUseLevel, startPage, isUsable, qualityIndex, GetAll, exactMatch, filterData)
		if not private.curQuery then
			-- private.curQuery will have been set if QueryAuctionItems succeeded
			-- this should never fail? we checked CanSendAuctionQuery() earlier
			message("Scan failed: unable to send query")
			if private.isGetAll then
				lib.ProgressBars("GetAllProgressBar", nil, false)
				BrowseSearchButton:Show()
				AucAdvanced.API.BlockUpdate(false)
				private.isGetAll = nil
			end
			return
		end
		AuctionFrameBrowse.page = startPage
		private.curQuery.qryinfo.nosummary = NoSummary
		if GetAll then
			private.curQuery.qryinfo.getall = true
		end

		--Show the progress indicator
		private.UpdateScanProgress(true, nil, nil, nil, nil, nil, private.curQuery)
	else
		message("Steady on; You'll need to talk to the auctioneer first!")
	end
end

function lib.IsScanning()
	return (private.isScanning or private.queueScan ~= nil), private.isGetAll
end

function lib.IsPaused()
	return private.isPaused
end

function private.Unpack(item, storage)
	if not storage then storage = {} end
	storage.link = item[Const.LINK]
	storage.useLevel = item[Const.ULEVEL]
	storage.itemLevel = item[Const.ILEVEL]
	storage.itemType = item[Const.ITYPE] -- deprecated ### Legion: todo: find all instances where this is used
	storage.classID = item[Const.CLASSID]
	storage.subType = item[Const.ISUB] -- deprecated
	storage.subClassID = item[Const.SUBCLASSID]
	storage.equipPos = item[Const.IEQUIP]
	storage.price = item[Const.PRICE]
	storage.timeLeft = item[Const.TLEFT]
	storage.seenTime = item[Const.TIME]
	storage.itemName = item[Const.NAME]
	storage.stackSize = item[Const.COUNT]
	storage.quality = item[Const.QUALITY]
	storage.canUse = item[Const.CANUSE]
	storage.minBid = item[Const.MINBID]
	storage.curBid = item[Const.CURBID]
	storage.increment = item[Const.MININC]
	storage.sellerName = item[Const.SELLER]
	storage.buyoutPrice = item[Const.BUYOUT]
	storage.amBidder = item[Const.AMHIGH]
	storage.dataFlag = item[Const.FLAG]
	storage.itemId = item[Const.ITEMID]
	storage.bonusString = item[Const.BONUSES]
	storage.itemSuffix = item[Const.SUFFIX]
	storage.itemFactor = item[Const.FACTOR]
	storage.itemEnchant = item[Const.ENCHANT]
	storage.itemSeed = item[Const.SEED]

	return storage
end
-- Define a public accessor for the above upack function
lib.UnpackImageItem = private.Unpack

--The first parameter will be true if we want to show the process indicator, false if we want to hide it. and nil if we only want to update it.
--The second parameter will be a number that is the max number of items in the scan.
--The third parameter is the current progress of the scan.
function private.UpdateScanProgress(state, totalAuctions, scannedAuctions, elapsedTime, page, maxPages, query)
	if (lib.IsScanning() or (state == false)) then
		if (_G.nLog) then
			_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, "UpdateScanProgress Called", state)
		end
		local scanCount = 0
		if (private.scanStack) then scanCount=#private.scanStack end
		AucAdvanced.SendProcessorMessage("scanprogress", state, totalAuctions, scannedAuctions, elapsedTime, page, maxPages, query, scanCount)
	end
end

function private.IsIdentical(focus, compare)
	for i = 1, Const.SELLER do
		if (i ~= Const.TIME and i ~= Const.CANUSE and focus[i] ~= compare[i]) then
			return false
		end
	end
	return true
end

function private.IsSameItem(focus, compare, onlyDirt)
	if onlyDirt then
		local flag = focus[Const.FLAG]
		if not flag or bitand(flag, Const.FLAG_DIRTY) == 0 then
			return false
		end
	end
	if (focus[Const.LINK] ~= compare[Const.LINK]) then return false end
	if (focus[Const.COUNT] ~= compare[Const.COUNT]) then return false end
	if (focus[Const.MINBID] ~= compare[Const.MINBID]) then return false end
	if (focus[Const.BUYOUT] ~= compare[Const.BUYOUT]) then return false end
	if (focus[Const.CURBID] > compare[Const.CURBID]) then return false end
	return true
end

function lib.FindItem(item, image, lut)
	local focus
	-- If we have a lookuptable, then we don't need to scan the whole lot
	if (lut) then
		local list = lut[item[Const.LINK]]
		if not list then return false
		elseif type(list) == "number" then
			if (private.IsSameItem(image[list], item, true)) then return list end
		else
			local pos
			for i=1, #list do
				pos = list[i]
				if (private.IsSameItem(image[pos], item, true)) then return pos end
			end
		end
	else
		-- We need to scan the whole thing cause there's no lookup table
		for i = 1, #image do
			if (private.IsSameItem(image[i], item, true)) then return i end
		end
	end
end


local function processBeginEndStats(processors, operation, querySizeInfo, TempcurScanStats)
	if (not processors) then return end
	local po = processors[operation]
	if (po) then
		for i=1,#po do
			local x = po[i]
			local f = x.Func
			local pOK, errormsg = pcall(f, operation, querySizeInfo, TempcurScanStats)
			if (not pOK) then
				collectgarbage() -- ### trial to see if this helps recover from Memory Allocation Errors
				local text = ("Error trapped for ScanProcessor '%s' in module %s:\n%s"):format(operation, x.Name, errormsg)
				if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "ScanProcessor Error", text) end
				geterrorhandler()(text)
			end
		end
	end
	return true
end

local statItem = { }
local statItemOld = { }

local function processStats(processors, operation, curItem, oldItem)
	local filtered = false
	if (not processors) then return end
	if (curItem) then private.Unpack(curItem, statItem) end
	if (oldItem) then private.Unpack(oldItem, statItemOld) end
	if (operation == "create" and processors.Filter) then
		--[[
			Filtering out happens here so we only have to do Unpack once.
			Only filter on create because once its in the system, dropping it can give the wrong impression to other mods.
			(it could think it was sold, for instance)
		]]
		local pf = processors.Filter
		for i=1,#pf do
			local x = pf[i]
			local f = x.Func
			local pOK, result=pcall(f, operation, statItem)
			if (pOK) then
				if (result) then
					curItem[Const.FLAG] = bitor(curItem[Const.FLAG] or 0, Const.FLAG_FILTER)
					filtered = true
					break
				end
			else
				collectgarbage() -- ### trial to see if this helps recover from Memory Allocation Errors
				local text = ("Error trapped for AuctionFilter in module %s:\n%s"):format(x.Name, result)
				if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "AuctionFilter Error", text) end
				geterrorhandler()(text)
			end
		end
	elseif curItem and bitand(curItem[Const.FLAG] or 0, Const.FLAG_FILTER) == Const.FLAG_FILTER then
		-- This item is a filtered item
		filtered = true
	end
	if filtered then
		return false
	end

	local po = processors[operation]
	if (po) then
		for i=1,#po do
			local x = po[i]
			local f = x.Func
			local pOK, errormsg = pcall(f, operation, statItem, oldItem and statItemOld or nil)
			if (not pOK) then
				collectgarbage() -- ### trial to see if this helps recover from Memory Allocation Errors
				local text = ("Error trapped for ScanProcessor '%s' in module %s:\n%s"):format(operation, x.Name, errormsg)
				if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "ScanProcessor Error", text) end
				geterrorhandler()(text)
			end
		end
	end
	return true
end


function private.IsInFilter(filterData, data)
	-- To find a match, we need to check that data matches any one filter in filterData
	-- (at least, that's my understanding of how it works)
	local classID, subClassID, inventoryType = data[Const.CLASSID], data[Const.SUBCLASSID], EquipCodeToInvType[data[Const.IEQUIP]] -- must convert iEquip code to inventoryType for comparison
	for _, filter in ipairs(filterData) do
		if filter.classID == classID then
			if filter.subClassID then
				if filter.subClassID == subClassID then
					if not filter.inventoryType or filter.inventoryType == inventoryType then
						-- classID and subClassID both match, and
						-- either there is no inventoryType in the filter or inventoryType matches
						return true
					end
				end
			else
				-- classID matches, no subClassID in filter, so data does match this filter
				return true
			end
		end
	end
end

function private.IsInQuery(curQuery, data)
	if (not curQuery.minUseLevel or (data[Const.ULEVEL] >= curQuery.minUseLevel))
		and (not curQuery.maxUseLevel or (data[Const.ULEVEL] <= curQuery.maxUseLevel))
		and (not curQuery.isUsable or (private.CanUse(data[Const.LINK])))
		then
		if curQuery.quality then
			local q = data[Const.QUALITY]
			-- special handling as GetAuctionItemInfo sometimes returns invalid quality of -1
			if q >= 0 and q < curQuery.quality then
				return false
			end
		end
		if curQuery.name then
			local dataname = data[Const.NAME]:lower() -- case insensitive; curQuery.name is already lowercased
			if dataname ~= curQuery.name and (curQuery.exactMatch or not dataname:find(curQuery.name, 1, true)) then
				return false
			end
		end
		if curQuery.filterData and not private.IsInFilter(curQuery.filterData, data) then
			return false
		end
		return true
	end
	return false
end

function lib.GetScanStats(serverKey)
	local scandata = private.GetScanData(serverKey)
	if scandata then
		return scandata.scanstats
	end
end

function lib.GetImageCopy(serverKey)
	-- Create a fully independent copy of the image - intended for use by coroutines
	local scandata = private.GetScanData(serverKey)
	if scandata then
		local image = scandata.image
		local size = Const.LASTENTRY
		local copy = {}
		for i = 1, #image do
			tinsert(copy, {unpack(image[i], 1, size)})
		end
		return copy
	end
end

function lib.GetImageSize(serverKey)
	local scandata = private.GetScanData(serverKey)
	if scandata then
		return #scandata.image
	end
end

function lib.GetImageItem(index, serverKey, reserved)
	-- reserved flag for possible future expansion
	local scandata = private.GetScanData(serverKey)
	if scandata then
		local item = scandata.image[index]
		if item then return {unpack(item, 1, Const.LASTENTRY)} end
	end
end


private.scandataIndex = {}
private.prevQuery = {}
-- private.queryResults is nil initially
-- private.prevQueryServerKey is nil initially

function private.clearImageCaches(event, scanstats)
	-- todo: different actions based on event & scanstats have been removed for now,
	-- until new-style serverKey is fully implemented
	wipe(private.scandataIndex)

	private.prevQueryServerKey = nil
	private.queryResults = nil -- not required but frees some memory
end

local weaktablemeta = {__mode="kv"}
function private.SubImageCache(itemId, serverKey)
	local itemResults
	serverKey = ResolveServerKey(serverKey)
	if not serverKey then return end
	local indexResults = private.scandataIndex[serverKey]
	if indexResults then
		itemResults = indexResults[itemId]
	end

	if not itemResults then
		local scandata = private.GetScanData(serverKey)
		if not scandata then return end
		itemResults = {}
		local C_ITEMID = Const.ITEMID
		local image = scandata.image
		for pos = 1, #image do
			local data = image[pos]
			if data[C_ITEMID] == itemId then
				tinsert(itemResults, data)
			end
		end
		if not indexResults then
			indexResults = {}
			if serverKey ~= Resources.ServerKey then
				-- use weak table if not 'home' serverKey
				indexResults = setmetatable(indexResults, weaktablemeta)
			end
			private.scandataIndex[serverKey] = indexResults
		end
		indexResults[itemId] = itemResults
	end

	return itemResults
end

function lib.QueryImage(query, serverKey, reserved, ...)
	serverKey = serverKey or Resources.ServerKey
	local prevQuery = private.prevQuery
	local queryResults = private.queryResults

	-- is this the same query as last time?
	if serverKey == private.prevQueryServerKey then
		local samequery = true
		for k,v in pairs(prevQuery) do
			if v ~= query[k] then
				samequery = false
				break
			end
		end
		if samequery then
			for k,v in pairs(query) do
				if v ~= prevQuery[k] then
					samequery = false
					break
				end
			end
			if samequery then
				return queryResults
			end
		end
	end

	-- reset results and save a copy of query
	queryResults = {} -- cannot use wipe; needs to be a new table here {ADV-534}
	private.queryResults = queryResults
	wipe(prevQuery)
	for k, v in pairs(query) do prevQuery[k] = v end
	private.prevQueryServerKey = serverKey

	-- get image to search - may be the whole snapshot or a subset
	local itemId = tonumber(query.itemId)
	local stringSpeciesID
	if query.speciesID then
		-- looking for a battlepet
		-- we will need to split the link for each data item, resulting in a _string containing the speciesID_
		-- make sure the test value is also a string
		stringSpeciesID = tostring(query.speciesID)
		-- also, all battlepets have the same itemId
		if not itemId then
			itemId = 82800
		elseif itemId ~= 82800 then
			-- wrong itemId! return empty results table
			return queryResults
		end
	end
	local saneQueryLink
	if query.link then
		saneQueryLink = SanitizeLink(query.link)
		if not itemId then
			-- it should be more efficient to extract itemId from the link
			-- so we can use SubImageCache
			local header, id = strsplit(":", saneQueryLink)
			itemId = tonumber(id)
		end
	end
	local image
	if itemId then
		image = private.SubImageCache(itemId, serverKey)
	else
		local scandata = private.GetScanData(serverKey)
		if scandata then
			image = scandata.image
		end
	end
	if not image then return queryResults end -- return empty results table

	local lowerName
	if query.name then
		lowerName = query.name:lower()
	end

	-- scan image to build a table of auctions that match query
	local ptr, finish = 1, #image
	while ptr <= finish do
		repeat
			local data = image[ptr]
			ptr = ptr + 1
			if not data then break end
			if bitand(data[Const.FLAG] or 0, Const.FLAG_UNSEEN) == Const.FLAG_UNSEEN then break end
			if query.filter and query.filter(data, ...) then break end
			if saneQueryLink and data[Const.LINK] ~= saneQueryLink then break end
			if query.suffix and data[Const.SUFFIX] ~= query.suffix then break end
			if query.factor and data[Const.FACTOR] ~= query.factor then break end
			if query.minUseLevel and data[Const.ULEVEL] < query.minUseLevel then break end
			if query.maxUseLevel and data[Const.ULEVEL] > query.maxUseLevel then break end
			if query.minItemLevel and data[Const.ILEVEL] < query.minItemLevel then break end
			if query.maxItemLevel and data[Const.ILEVEL] > query.maxItemLevel then break end
			if query.class and data[Const.ITYPE] ~= query.class then break end -- ### Legion todo: revise for CLASSID
			if query.subclass and data[Const.ISUB] ~= query.subclass then break end
			if query.quality and data[Const.QUALITY] ~= query.quality then break end
			if query.invType and data[Const.IEQUIP] ~= query.invType then break end
			if query.seller and data[Const.SELLER] ~= query.seller then break end
			if lowerName then
				local name = data[Const.NAME]
				if not (name and name:lower():find(lowerName, 1, true)) then break end
			end
			if stringSpeciesID then
				local _, id = strsplit(":", data[Const.LINK])
				if id ~= stringSpeciesID then
					break
				end
			end

			local stack = data[Const.COUNT]
			local nextBid = data[Const.PRICE]
			local buyout = data[Const.BUYOUT]
			if query.perItem and stack > 1 then
				nextBid = ceil(nextBid / stack)
				buyout = ceil(buyout / stack)
			end
			if query.minStack and stack < query.minStack then break end
			if query.maxStack and stack > query.maxStack then break end
			if query.minBid and nextBid < query.minBid then break end
			if query.maxBid and nextBid > query.maxBid then break end
			if query.minBuyout and buyout < query.minBuyout then break end
			if query.maxBuyout and buyout > query.maxBuyout then break end

			-- If we're still here, then we've got a winner
			tinsert(queryResults, data)
		until true
	end

	return queryResults
end


private.CommitQueue = {}
private.sessionFirstScan = true

local CommitRunning = false
local Commitfunction = function()
	local commitStarted = GetTime()
	--local totalProcessingTime = 0 -- temp disabled, going to take some work to thread this back in with the broken GetTime / time changes

	-- coroutine speed limiter using debugprofilestop
	-- time in milliseconds: 1000/FPS * 0.8 (80% rough adjustment to allow for other stuff happening during the frame)
	local processingTime = 800 / get("scancommit.targetFPS")
	local debugprofilestop = debugprofilestop
	local nextPause -- gets set before each processing loop, and after each yield within the loop
	-- backup timer, in case debugprofilestop fails - can occur under (currently unknown) circumstances - only used in the merge and cleanup loops {ADV-637}
	local time = time
	local lastTime

	local inscount, delcount = 0, 0
	if #private.CommitQueue == 0 then CommitRunning = false return end
	CommitRunning = true

	--grab the first item in the commit queue, and bump everything else down
	local TempcurCommit = tremove(private.CommitQueue)
	-- setup various locals for later use
	local TempcurScan = TempcurCommit.Scan
	local TempcurQuery = TempcurCommit.Query

	local wasIncomplete = TempcurCommit.wasIncomplete
	local wasEarlyTerm = TempcurCommit.wasEarlyTerm
	local wasEndPagesOnly = TempcurCommit.wasEndPagesOnly

	local wasGetAll = TempcurCommit.wasGetAll
	local scanStarted = TempcurCommit.scanStarted
	local scanStartTime = TempcurCommit.scanStartTime
	local totalPaused = TempcurCommit.totalPaused
	local scanCommitTime = TempcurCommit.scanCommitTime
	local scanStoreTime = scanCommitTime - scanStarted - totalPaused
	local storeTime = TempcurCommit.storeTime
	local wasOnePage = wasGetAll or (TempcurQuery.qryinfo.page == 0) -- retrieved all records in single pull (only one page scanned or was GetAll)
	local wasUnrestricted = not (TempcurQuery.class or TempcurQuery.subclass or TempcurQuery.minUseLevel
		or TempcurQuery.name or TempcurQuery.isUsable or TempcurQuery.invType or TempcurQuery.quality) -- no restrictions, potentially a full scan

	-- ### temp fix, until we figure out what isUsable flag is now doing
	if TempcurQuery.isUsable then
		wasIncomplete = true -- always treat as incomplete
	end

	local serverKey = Resources.ServerKey
	local scandata, reason = private.GetScanData(serverKey)
	if not scandata then
		-- Critical Error Diagnostics
		local scandatatext = "Unloaded"
		local scanmodule = AucAdvanced.Modules.Util.ScanData
		if scanmodule and scanmodule.GetAddOnInfo then
			local ready, version = scanmodule.GetAddOnInfo()
			scandatatext = strjoin(" ", "Loaded", tostringall(ready, version))
		end
		error(format("Critical error: scandata does not exist for serverKey %s\nReason = %s\nAuc-ScanData = %s\nFallback = %s , %s",
			tostringall(serverKey, reason, scandatatext, private.FallbackScanData, private.loadingScanData)))
	end
	local now = time()
	if get("scancommit.progressbar") then
		lib.ProgressBars("CommitProgressBar", 0, true)
	end
	local hadGetError = false
	local oldCount = #scandata.image
	local scanCount = #TempcurScan

	if wasGetAll and scanCount < 100 then
		-- Quick test for a Blizzard error that appeared in Patch 7.3.5 (now fixed, but in case something similar happens again)
		-- GetAll scans were returning no data, which wiped scandata and thereby caused false updates in Stat modules
		-- Assume a GetAll should return a LOT of entries; tag as an error if the count is suspiciously low
		hadGetError = true
		wasIncomplete = true
	end

	local progresscounter = 0
	local progresstotal = 2*oldCount + 6*scanCount
	if progresstotal == 0 then progresstotal = 1 end -- dummy value to avoid potential div0. ### this needs a better solution (if this is 0 can we just bail out??)

	local filterOldCount, filterNewCount, updateCount, sameCount, newCount, updateRecoveredCount, sameRecoveredCount, missedCount = 0,0,0,0, 0,0,0,0
	local unresolvedCount = 0
	local dirtyCount, undirtyCount, matchedCount = 0, 0, 0
	local filterDeleteCount, earlyDeleteCount, expiredDeleteCount, corruptDeleteCount = 0, 0, 0, 0

	local printSummary, scanSize = false, ""
	scanSize = TempcurQuery.qryinfo.scanSize
	if scanSize=="Full" then
		printSummary = get("scandata.summaryonfull");
	elseif scanSize=="Partial" then
		printSummary = get("scandata.summaryonpartial")
	else -- scanSize=="Micro"
		printSummary = get("scandata.summaryonmicro")
	end
	if (wasEndPagesOnly) then
		scanSize = "TailScan-"..scanSize
		printSummary = get("scandata.summaryonpartial") -- todo: do we want a separate "summary on end pages only" option?
	elseif (TempcurQuery.qryinfo.nosummary) then
		printSummary = false
		scanSize = "NoSum-"..scanSize
	end

	local processors = {}
	local modules = AucAdvanced.GetAllModules("AuctionFilter", "Filter")
	for pos, engineLib in ipairs(modules) do
		if (not processors.Filter) then processors.Filter = {} end
		local x = {}
		x.Name = engineLib.GetName()
		x.Func = engineLib.AuctionFilter
		tinsert(processors.Filter, x)
	end
	modules = AucAdvanced.GetAllModules("ScanProcessors")
	for pos, engineLib in ipairs(modules) do
		for op, func in pairs(engineLib.ScanProcessors) do
			if (not processors[op]) then processors[op] = {} end
			local x = {}
			x.Name = engineLib.GetName()
			x.Func = func
			tinsert(processors[op], x)
		end
	end

	do --[[ *** Stage 1 : pre-process the new scan ]]--
		lib.ProgressBars("CommitProgressBar", 100*progresscounter/progresstotal, true, "Auctioneer: Processing Stage 1")
		coroutine.yield() -- yield here to allow the bar to display, and help the frame rate a little
		local breakinterval, timeadjust
		local itemcachedelay -- ### Legion item cache patch
		local stage1throttle = get("core.scan.stage1throttle")
		if stage1throttle >= Const.ALEVEL_HI then
			breakinterval, timeadjust = 500, 0.1
			itemcachedelay = 5 -- ### Legion item cache patch
		elseif stage1throttle >= Const.ALEVEL_MED then
			breakinterval, timeadjust = 2000, 0.4
			itemcachedelay = 4 -- ### Legion item cache patch
		elseif stage1throttle >= Const.ALEVEL_LOW then
			breakinterval, timeadjust = 5000, 1
			itemcachedelay = 3 -- ### Legion item cache patch
		else -- OFF
			breakinterval, timeadjust = nil, 1
			itemcachedelay = 2 -- ### Legion item cache patch
		end
		local breakcount = 0
		local doYield = false
		local battlepetYield = true
		local firstfailureYield = true
		local retries = {}
		nextPause = debugprofilestop() + processingTime * timeadjust
		-- Stage 1 First Pass
		private.InitItemInfoCache()
		for pos = scanCount, 1, -1 do
			if breakinterval then
				breakcount = (breakcount + 1) % breakinterval
				if breakcount == 0 then
					doYield = true
				end
			end
			if doYield or debugprofilestop() > nextPause then
				lib.ProgressBars("CommitProgressBar", 100*progresscounter/progresstotal, true, "Auctioneer: Processing Stage 1")
				coroutine.yield()
				nextPause = debugprofilestop() + processingTime * timeadjust
				doYield = false
			end
			local success, reason, linkType = private.GetAuctionItemFillIn(TempcurScan[pos], true)
			progresscounter = progresscounter + 1
			if linkType == "battlepet" and battlepetYield then
				-- experimental: yield on finding first battlepet
				-- first time battlepet API is used, it appears to trigger a small amount of lag
				doYield = true
				battlepetYield = false
			elseif not success then
				if firstfailureYield then
					-- experimental: yield after first failure detected
					-- todo: fiddle with this, perhaps yielding every X failures, see if it appears to help
					doYield = true
					firstfailureYield = false
				end
				if reason == "Retry" then
					progresscounter = progresscounter - 1 -- undo progress counter for this item ### todo: find a better way?
					tinsert(retries, pos)
				end
			end
		end
		local numretries = #retries

		-- Stage 1 Retry passes - only checks entries in 'retries' table
		local retrypass = 0
		while numretries > 0 and retrypass < 10 do
			local nextWait = GetTime() + itemcachedelay -- delay time depends on stage1throttle
			while GetTime() < nextWait do
				coroutine.yield()
			end

			private.InitItemInfoCache()
			local newretries = {}
			retrypass = retrypass + 1
			for i = #retries, 1, -1 do
				local pos = retries[i]
				if breakinterval then
					breakcount = (breakcount + 1) % breakinterval
					if breakcount == 0 then
						doYield = true
					end
				end
				if doYield or debugprofilestop() > nextPause then
					lib.ProgressBars("CommitProgressBar", 100*progresscounter/progresstotal, true, "Auctioneer: Processing Stage 1."..retrypass)
					coroutine.yield()
					nextPause = debugprofilestop() + processingTime * timeadjust
					doYield = false
				end
				local success, reason, linkType = private.GetAuctionItemFillIn(TempcurScan[pos], true)

				if not success and reason == "Retry" then
					tinsert(newretries, pos)
				else
					progresscounter = progresscounter + 1
				end

			end
			retries = newretries
			numretries = #retries
		end

		-- Stage 1 Final Pass
		breakcount = 0
		doYield = false
		private.InitItemInfoCache()
		for pos = scanCount, 1, -1 do
			if breakinterval then
				breakcount = (breakcount + 1) % breakinterval
				if breakcount == 0 then
					doYield = true
				end
			end
			if doYield or debugprofilestop() > nextPause then
				lib.ProgressBars("CommitProgressBar", 100*progresscounter/progresstotal, true, "Auctioneer: Processing Stage 1")
				coroutine.yield()
				nextPause = debugprofilestop() + processingTime * timeadjust
				doYield = false
			end

			local entryUnusable = false
			local data = TempcurScan[pos]
			local success, reason, linkType = private.GetAuctionItemFillIn(data)
			progresscounter = progresscounter + 1

			if not success then
				entryUnusable = true
			else
				-- full test
				for i = 1, Const.LASTENTRY, 1 do
					if not (data[i] or ItemDataAllowedNil[i]) then
						entryUnusable = true
						break
					end
				end
			end


			if entryUnusable then
				if _G.nLog then
					-- Yes this is a mess.  However, it gives enough information to let us resolve problems in the future when blizzard breaks in a new way.
					_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_WARNING, "Incomplete Auction Seen",
						(("%s%s%s%s%s%s"):format(
						"Page %d, Index %d -- %s\n %s -- %d of %s sold by %s\n",
						"Level %s, Quality %s, Item Level %s\n",
						"Item Class %s, SubClass %s, Equipment Position %s\n",
						"Price %s, Bid %s, NextBid %s, MinInc %s, Buyout %s\n Time Left %s, Time %s\n",
						"High Bidder %s  Can Use: %s  Bonuses %s  Item ID %s  Suffix %s  Factor %s  Enchant %s  Seed %s\n",
						"Deprecated2: %s")):format(
						data.PAGE, data.PAGEINDEX, "too broken, can not use at all",
						data[Const.LINK] or "(nil)", data[Const.COUNT] or -1, data[Const.NAME] or "(nil)", data[Const.SELLER] or "(UNKNOWN)",
						data[Const.ULEVEL] or "(nil)", data[Const.QUALITY] or "(nil)", data[Const.ILEVEL] or "(nil)", data[Const.CLASSID] or "(UNKNOWN)", data[Const.SUBCLASSID] or "(UNKNOWN)", data[Const.IEQUIP] or '(n/a)',
						data[Const.PRICE] or -1, data[Const.CURBID] or -1, data[Const.MINBID] or -1, data[Const.MININC] or -1, data[Const.BUYOUT] or -1,
						data[Const.TLEFT] or -1, data[Const.TIME] or "(nil)", data[Const.AMHIGH] and "Yes" or "No",
						(data[Const.CANUSE]==false and "Yes") or (data[Const.CANUSE] and "No" or "(nil)"), data[Const.BONUSES] or '(nil)', data[Const.ITEMID] or '(nil)',
						data[Const.SUFFIX] or '(nil)', data[Const.FACTOR] or '(nil)', data[Const.ENCHANT] or '(nil)', data[Const.SEED] or '(nil)', data[Const.DEP2] or '(nil)'))
				end
				tremove(TempcurScan, pos)
				unresolvedCount = unresolvedCount + 1
				progresscounter = progresscounter + 4 -- We just wiped the entry from the db, so Stage 3 won't see it.
			end
		end
		local tolerance = 0
		if scanCount > TOLERANCE_LOWERLIMIT then -- don't use tolerance for tiny scans
			tolerance = get("core.scan.unresolvedtolerance")
			if scanCount < TOLERANCE_TAPERLIMIT then -- taper tolerance for smaller scans
				tolerance = ceil(tolerance * scanCount / TOLERANCE_TAPERLIMIT)
			end
		end
		if unresolvedCount > tolerance then
			hadGetError = true
			wasIncomplete = true
		end
	end --[[ of Stage 1 ]]--

	-- Send ScanProcessor message "begin"
	-- This was previously sent before Stage 3, but has been moved to before Stage 2
	-- (this means matchCount can no longer be included)
	coroutine.yield()
	local querySizeInfo = {
		wasIncomplete = wasIncomplete,
		wasGetAll = wasGetAll,
		scanStarted = scanStarted,
		wasUnrestricted = wasUnrestricted,
		wasEarlyTerm = wasEarlyTerm,
		hadGetError = hadGetError,
		wasEndPagesOnly = wasEndPagesOnly,
		Query = TempcurCommit.Query,
		scanCount = scanCount,
		printSummary = printSummary,
		FallbackScanData = private.FallbackScanData,
	}
	processBeginEndStats(processors, "begin", querySizeInfo, nil)

	-- Stage 2 will build the following tables for use in Stages 3 and 4
	local lut = {}
	local workingImage = {} -- local copy of image; we do not modify scandata.image until scan is complete (Stage 5)

	do --[[ *** Stage 2 : Pre-process image table ***
		Copy entries from image into workingImage
		Do not copy expired (or corrupt) entries; issue "delete" processor message for these
		Identify auctions that match the scan query and mark as DIRTY
		Build a LookUpTable ]]
		lib.ProgressBars("CommitProgressBar", 100*progresscounter/progresstotal, true, "Auctioneer: Processing Stage 2")
		coroutine.yield() -- yield to allow updated bar to display

		local firstscan = private.sessionFirstScan
		private.sessionFirstScan = nil

		-- Put flag constants into block locals to avoid multiple upvalue/table lookups within the loop
		-- Todo: some of these would be useful in other Stages
		local C_LINK, C_FLAG, C_TIME, C_TLEFT = Const.LINK, Const.FLAG, Const.TIME, Const.TLEFT
		local F_DIRTY, F_FILTER, F_EXPIRED = Const.FLAG_DIRTY, Const.FLAG_FILTER, Const.FLAG_EXPIRED
		local F_NOT_DIRTY = bitnot(F_DIRTY) -- bitmask for removing DIRTY flag
		local AucMaxTimes = Const.AucMaxTimes

		nextPause = debugprofilestop() + processingTime
		for _, data in ipairs(scandata.image) do
			if debugprofilestop() > nextPause then
				lib.ProgressBars("CommitProgressBar", 100*progresscounter/progresstotal, true, "Auctioneer: Processing Stage 2")
				coroutine.yield()
				nextPause = debugprofilestop() + processingTime
			end
			progresscounter = progresscounter + 1

			local keep, inquery = true, false
			local flags = data[C_FLAG]

			-- Test for corrupt entries : Same test as used in Stage 1 for new scan
			-- Only done for first scan of the session, in case of file corruption
			if firstscan then
				for i = 1, Const.LASTENTRY, 1 do
					if not (data[i] or ItemDataAllowedNil[i]) then
						keep = false
						corruptDeleteCount = corruptDeleteCount + 1
						break
					end
				end
			end

			if keep then
				-- Test for match
				if private.IsInQuery(TempcurQuery, data) then
					matchedCount = matchedCount + 1
					inquery = true
				end
				-- Test for expired
				local auctionmaxtime = AucMaxTimes[data[C_TLEFT]] or 172800
				if now - data[C_TIME] > auctionmaxtime then
					keep = false
					data[C_FLAG] = bitor(flags, F_EXPIRED) -- only really needed in case a "delete" processor looks for it
					if bitand(flags, F_FILTER) ~= 0 then
						filterDeleteCount = filterDeleteCount + 1
					else
						expiredDeleteCount = expiredDeleteCount + 1
						processStats(processors, "delete", data)
					end
				end
			end

			if keep then
				-- Copy entry into working image. Any entries not copied are effectively "deleted" when scandata.image is replaced by workingImage (Stage 5)
				tinsert(workingImage, data)

				if inquery then
					-- Mark Dirty
					data[C_FLAG] = bitor(flags, F_DIRTY)
					dirtyCount = dirtyCount + 1

					-- Build lookup table for links into workingImage
					local link = data[C_LINK]
					local list = lut[link]
					if (not list) then
						lut[link] = #workingImage
					else
						if (type(list) == "number") then
							lut[link] = {}
							tinsert(lut[link], list)
						end
						tinsert(lut[link], #workingImage)
					end
				else -- not in query
					-- Ensure marked NOT Dirty - Stage 4 should be clearing the Dirty flag, but it was not always doing so
					data[C_FLAG] = bitand(flags, F_NOT_DIRTY)
				end
			end
		end
	end -- of Stage 2

	do --[[ *** Stage 3 : Merge new scan into ScanData *** ]]
		lib.ProgressBars("CommitProgressBar", 100*progresscounter/progresstotal, true, "Auctioneer: Processing Stage 3")
		coroutine.yield()

		local maskNotDirtyUnseen = bitnot(bitor(Const.FLAG_DIRTY, Const.FLAG_UNSEEN)) -- only calculate mask for clearing these flags once
		local messageCreate = private.FallbackScanData and "fallbackcreate" or "create"

		local garbageinterval
		local stage3garbage = get("core.scan.stage3garbage")
		if stage3garbage >= Const.ALEVEL_HI then
			garbageinterval = 1000
		elseif stage3garbage >= Const.ALEVEL_MED then
			garbageinterval = 5000
		elseif stage3garbage >= Const.ALEVEL_LOW then
			garbageinterval = 10000
		end

		nextPause = debugprofilestop() + processingTime
		lastTime = time()
		for index, data in ipairs(TempcurScan) do
			local doYield = false
			if garbageinterval and index % garbageinterval == 0 then
				coroutine.yield() -- yield before and after collectgarbage to smooth things a little, as it tends to cause small freezes
				collectgarbage()
				doYield = true
			else
				local checkprofile = debugprofilestop()
				if checkprofile > nextPause then
					checkprofile = (checkprofile - nextPause) / processingTime
					if checkprofile > 2 then
						-- double yield if last processing cycle took more than 2 * the permitted time
						coroutine.yield()
					end
					if checkprofile > 4 then
						-- triple yield if last processing cycle took more than 4 * the permitted time
						coroutine.yield()
					end
					doYield = true
				elseif time() > lastTime then
					doYield = true
				end
			end
			if doYield then
				lib.ProgressBars("CommitProgressBar", 100*progresscounter/progresstotal, true, "Auctioneer: Processing Stage 3")
				coroutine.yield()
				nextPause = debugprofilestop() + processingTime
				lastTime = time()
			end
			local itemPos = lib.FindItem(data, workingImage, lut)
			progresscounter = progresscounter + 4

			if (itemPos) then
				local oldItem = workingImage[itemPos]
				data[Const.FLAG] = bitand(oldItem[Const.FLAG], maskNotDirtyUnseen)
				undirtyCount = undirtyCount + 1
				if data[Const.SELLER] == "" then -- unknown seller name in new data; copy the old name if it exists
					data[Const.SELLER] = oldItem[Const.SELLER]
				end

				if data[Const.QUALITY] == -1 then -- invalid quality value in new data; copy the old quality
					data[Const.QUALITY] = oldItem[Const.QUALITY]
				end
				if bitand(data[Const.FLAG], Const.FLAG_FILTER) ~= 0 then
					filterOldCount = filterOldCount + 1
				else
					if not private.IsIdentical(oldItem, data) then
						if processStats(processors, "update", data, oldItem) then
							updateCount = updateCount + 1
						end
						if bitand(oldItem[Const.FLAG], Const.FLAG_UNSEEN) ~= 0 then
							updateRecoveredCount = updateRecoveredCount + 1
						end
					else
						if processStats(processors, "leave", data) then
							sameCount = sameCount + 1
						end
						if bitand(oldItem[Const.FLAG], Const.FLAG_UNSEEN) ~= 0 then
							sameRecoveredCount = sameRecoveredCount + 1
						end
					end
				end
				workingImage[itemPos] = data
			else
				if (processStats(processors, messageCreate, data)) then
					newCount = newCount + 1
				else -- processStats(processors, "create"...) filtered the auction: flag it
					data[Const.FLAG] = bitor(data[Const.FLAG] or 0, Const.FLAG_FILTER)
					filterNewCount = filterNewCount + 1
				end
				data[Const.FLAG] = bitand(data[Const.FLAG], maskNotDirtyUnseen)
				tinsert(workingImage, data)
			end
		end
		lut = nil -- release some memory
	end -- of Stage 3

	do --[[ *** Stage 4 : Cleanup deleted auctions *** ]]
		lib.ProgressBars("CommitProgressBar", 100*progresscounter/progresstotal, true, "Auctioneer: Processing Stage 4")
		coroutine.yield()
		local progressstep = 1
		if #workingImage > 0 then -- (avoid potential div0)
			-- #workingImage is now different than oldCount, which was used to calculate progresstotal -- adjust the step size to compensate
			progressstep = (progresstotal - progresscounter) / #workingImage
		end
		local loopBegin, loopEnd, loopDirection = #workingImage, 1, -1
		local keepmodeImage
		--[[ Keep mode test
			Using tremove is extremely inefficient when there are a large number of deletions (particularly if the number of kept entries is also large).
			If we estimate this will be the case, switch to Keep mode, where we copy the entries we want to keep into a new image, which then replaces the old one.

			Test version 1: use keep mode if scan is complete, and if number of remaining dirty entries exceeds a fixed threshold
			Test version 2: Test for expired in Stage 2; expiredCount is now available to decide whether to use keep mode
			Test version 3: Stage 2 now actually deletes expired auctions; back to just checking remaining dirty entries, but we now work on workingImage
		--]]
		if not wasIncomplete and dirtyCount - undirtyCount > 1000 then
			loopBegin, loopEnd, loopDirection = 1, #workingImage, 1 -- process Keep mode in ascending order to keep the new table in the same order
			keepmodeImage = {} -- new image table; also acts as a flag for Keep mode
		end
		nextPause = debugprofilestop() + processingTime
		lastTime = time()
		for pos = loopBegin, loopEnd, loopDirection do
			if debugprofilestop() > nextPause or time() > lastTime then
				lib.ProgressBars("CommitProgressBar", 100*progresscounter/progresstotal, true, "Auctioneer: Processing Stage 4")
				coroutine.yield()
				nextPause = debugprofilestop() + processingTime
				lastTime = time()
			end
			local data = workingImage[pos]
			local flags = data[Const.FLAG] -- *caution* if we modify data[Const.FLAG] below, be sure to set flags to the same value again
			local dodelete = false
			progresscounter = progresscounter + progressstep
			-- Corrupt and Expired checking/processing now occurs in Stage 2
			if bitand(flags, Const.FLAG_DIRTY) ~= 0 then
				if wasIncomplete then
					flags = bitand(flags, bitnot(Const.FLAG_DIRTY)) -- Clear Dirty flag
					data[Const.FLAG] = flags
					missedCount = missedCount + 1
				elseif wasOnePage then
					-- a *completed* one-page scan should not have missed any auctions
					dodelete = true
					if bitand(flags, Const.FLAG_FILTER) ~= 0 then
						filterDeleteCount = filterDeleteCount + 1
					else
						earlyDeleteCount = earlyDeleteCount + 1
					end
				else
					if bitand(flags, Const.FLAG_UNSEEN) ~= 0 then
						dodelete = true
						if bitand(flags, Const.FLAG_FILTER) ~= 0 then
							filterDeleteCount = filterDeleteCount + 1
						else
							earlyDeleteCount = earlyDeleteCount + 1
						end
					else
						-- clear Dirty flag, and mark as Unseen
						flags = bitor(bitand(flags, bitnot(Const.FLAG_DIRTY)), Const.FLAG_UNSEEN)
						data[Const.FLAG] = flags
						missedCount = missedCount + 1
					end
				end
			end
			if dodelete then
				if bitand(flags, Const.FLAG_FILTER) == 0 then
					processStats(processors, "delete", data)
				end
				if not keepmodeImage then
					tremove(workingImage, pos)
				end
			else -- keep
				if keepmodeImage then
					tinsert(keepmodeImage, data)
				end
			end
		end
		if keepmodeImage then
			workingImage = keepmodeImage
		end
	end -- of Stage 4

	--[[ *** Stage 5 : Reports *** ]]
	lib.ProgressBars("CommitProgressBar", 100, true, "Auctioneer: Processing Finished")
	-- final yield to update GetTime for the stats
	-- (though we should be aware that whatever else happens during this yield gets added to our final time, we can't get an update of GetTime *without* yielding here!)
	coroutine.yield()
	local endTimeStamp = time()
	local scanTimeSecs, scanTimeMins, scanTimeHours = GetTime() - scanStarted - totalPaused, 0, 0

	-- optionally do a final collection here (as above, we want it surrounded by yields)
	if get("core.scan.stage5garbage") then
		collectgarbage()
		coroutine.yield()
	end

	-- Store workingImage into the scandata record (replacing the old image)
	scandata.image = workingImage

	local currentCount = #scandata.image
	if oldCount - earlyDeleteCount - expiredDeleteCount - corruptDeleteCount + newCount + filterNewCount - filterDeleteCount ~= currentCount then
		local msg = ("%d old count - %d deleted - %d expired - %d corrupt + %d new + %d filtered new - %d filtered deleted != %d current count"):format(
			oldCount, earlyDeleteCount, expiredDeleteCount, corruptDeleteCount, newCount, filterNewCount, filterDeleteCount, currentCount)
		if nLog then
			nLog.AddMessage("Auctioneer", "Scan", N_WARNING, "Image Count Discrepancy", msg)
		end
		geterrorhandler()("CoreScan Image Count Discrepancy\n"..msg)
	end

	if updateCount + sameCount + newCount + filterNewCount + filterOldCount + unresolvedCount ~= scanCount then
		local msg = ("%d updated + %d same + %d new + %d filtered + %d unresolved != %d scanned"):format(
			updateCount, sameCount, newCount, filterOldCount+filterNewCount, unresolvedCount, scanCount)
		if nLog then
			nLog.AddMessage("Auctioneer", "Scan", N_WARNING, "Scan Count Discrepancy", msg)
		end
		geterrorhandler()("CoreScan Scan Count Discrepancy\n"..msg)
	end

	if scanTimeSecs < 1 then
		scanTimeSecs = floor(scanTimeSecs*10)/10
	else
		scanTimeSecs = floor(scanTimeSecs)
		scanTimeMins = floor(scanTimeSecs / 60)
		scanTimeSecs = mod(scanTimeSecs, 60)
		scanTimeHours = floor(scanTimeMins / 60)
		scanTimeMins = mod(scanTimeMins, 60)
	end

	--Hides the end of scan summary if user is not interested
	if (_G.nLog or printSummary) then

		local scanTime = " "
		local summaryLine
		local summary

		if scanTimeHours ~= 0 then
			scanTime = scanTime..scanTimeHours.._TRANS("PSS_Hours")
		end
		if scanTimeMins ~= 0 then
			scanTime = scanTime..scanTimeMins.._TRANS("PSS_Minutes")
		end
		if scanTimeSecs ~= 0 or (scanTimeHours == 0 and scanTimeMins == 0) then
			scanTime = scanTime..scanTimeSecs.._TRANS("PSS_Seconds")
		end

		if (wasEndPagesOnly) then
			summaryLine = (_TRANS("PSS_TailScan")):format(scanCount, scanTime)
		elseif (wasEarlyTerm) then
			summaryLine = (_TRANS("PSS_Incomplete")):format(scanCount, scanTime) --Auctioneer finished scanning {{%d}} auctions over {{%s}} before being stopped
		elseif (hadGetError) then
			summaryLine = (_TRANS("PSS_GetError")):format(scanCount, scanTime) --Auctioneer finished scanning {{%d}} auctions over {{%s}} but was not able to retrieve some auctions
		elseif wasIncomplete then -- any other incomplete (unknown reason)
			summaryLine = (_TRANS("PSS_Incomplete")):format(scanCount, scanTime) --Auctioneer finished scanning {{%d}} auctions over {{%s}} before being stopped
		else
			summaryLine = (_TRANS("PSS_Complete")):format(scanCount, scanTime) --Auctioneer finished scanning {{%d}} auctions over {{%s}}
		end
		if (printSummary) then aucPrint(summaryLine) end
		summary = summaryLine

		summaryLine = "  {{"..oldCount.."}} ".._TRANS("PSS_StartItems").."{{"..matchedCount.."}} ".._TRANS("PSS_MatchedItems").." {{"..currentCount.."}} ".._TRANS("PSS_AtEnd")
		if (printSummary) then aucPrint(summaryLine) end
		summary = summary.."\n"..summaryLine

		if (sameCount > 0) then
			if (sameRecoveredCount > 0) then
				summaryLine = "  {{"..sameCount.."}} ".._TRANS("PSS_Unchanged_Missed")..sameRecoveredCount.._TRANS("PSS_Missed")
			else
				summaryLine = "  {{"..sameCount.."}} ".._TRANS("PSS_Unchanged_NoMissed")
			end
			if (printSummary) then aucPrint(summaryLine) end
			summary = summary.."\n"..summaryLine
		end
		if (updateCount > 0) then
			if (updateRecoveredCount > 0) then
				summaryLine = "  {{"..updateCount.."}} ".._TRANS("PSS_Updated_Missed")..updateRecoveredCount.._TRANS("PSS_Missed")
			else
				summaryLine = "  {{"..updateCount.."}} ".._TRANS("PSS_Updated_NoMissed")
			end
			if (printSummary) then aucPrint(summaryLine) end
			summary = summary.."\n"..summaryLine
		end
		if (newCount > 0) then
			summaryLine = "  {{"..newCount.."}} ".._TRANS("PSS_NewItems")
			if (printSummary) then aucPrint(summaryLine) end
			summary = summary.."\n"..summaryLine
		end
		if (earlyDeleteCount+expiredDeleteCount > 0) then
			if expiredDeleteCount > 0 then
				summaryLine = "  {{"..earlyDeleteCount+expiredDeleteCount.."}} ".._TRANS("PSS_Removed_Expired").." {{"..expiredDeleteCount.."}} ".._TRANS("PSS_Expired")
			else
				summaryLine = "  {{"..earlyDeleteCount+expiredDeleteCount.."}} ".._TRANS("PSS_Removed_NoExpired")
			end
			if (printSummary) then aucPrint(summaryLine) end
			summary = summary.."\n"..summaryLine
		end
		if (filterNewCount+filterOldCount > 0) then
			summaryLine = "  {{"..filterNewCount+filterOldCount.."}} ".._TRANS("PSS_Filtered")
			if (printSummary) then aucPrint(summaryLine) end
			summary = summary.."\n"..summaryLine
		end
		if (filterDeleteCount > 0) then
			summaryLine = "  {{"..filterDeleteCount.."}} ".._TRANS("PSS_Filtered_Removed")
			if (printSummary) then aucPrint(summaryLine) end
			summary = summary.."\n"..summaryLine
		end
		if (missedCount > 0 and not wasEndPagesOnly) then
			if wasIncomplete then
				summaryLine = "  ".._TRANS("PSS_Incomplete_Missed_1").." "..missedCount.."}} ".._TRANS("PSS_Incomplete_Missed_2")
			else
				summaryLine = "  {{"..missedCount.."}} ".._TRANS("PSS_MissedItems")
			end
			if (printSummary) then aucPrint(summaryLine) end
			summary = summary.."\n"..summaryLine
		end
		if unresolvedCount > 0 then
			summaryLine = "  {{"..unresolvedCount.."}} Unresolved entries"
			if (printSummary) then aucPrint(summaryLine) end
			summary = summary.."\n"..summaryLine
		end
		if corruptDeleteCount > 0 then
			summaryLine = "  {{"..corruptDeleteCount.."}} Corrupt entries found and removed"
			if (printSummary) then aucPrint(summaryLine) end
			summary = summary.."\n"..summaryLine
		end

		if (_G.nLog) then
			local eTime = GetTime()
			_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO,
			"Scan "..TempcurQuery.qryinfo.id.."("..TempcurQuery.qryinfo.sig..") Committed",
			--("%s\nTotal Time: %f\nPaused Time: %f\nData Storage Time: %f\nData Store Time (our processing): %f\nTotal Commit Coroutine Execution Time: %f\nTotal Commit Coroutine Execution Time (excluding yields): %f"):format(summary, eTime-scanStarted, totalPaused, scanStoreTime, storeTime, GetTime()-commitStarted, totalProcessingTime))
			-- temporarily removed totalProcessingTime until other fixes go in and we can calculate it again
			("%s\nTotal Time: %f\nPaused Time: %f\nData Storage Time: %f\nData Store Time (our processing): %f\nTotal Commit Coroutine Execution Time: %f"):format(summary, eTime-scanStarted, totalPaused, scanStoreTime, storeTime, GetTime()-commitStarted))
		end
	end


	local TempcurScanStats = {
		source = "scan",
		serverKey = serverKey,
		scanCount = scanCount,
		oldCount = oldCount,
		sameCount = sameCount,
		newCount = newCount,
		updateCount = updateCount,
		matchedCount = matchedCount,
		earlyDeleteCount = earlyDeleteCount,
		expiredDeleteCount = expiredDeleteCount,
		currentCount = currentCount,
		missedCount = missedCount,
		filteredCount = filterNewCount+filterOldCount,
		wasIncomplete = wasIncomplete or false,
		wasGetAll = wasGetAll or false,
		startTime = scanStartTime,
		endTime = endTimeStamp,
		started = scanStarted,
		paused = totalPaused,
		ended = GetTime(),
		elapsed = GetTime() - scanStarted - totalPaused,
		query = TempcurQuery,
		scanStoreTime = scanStoreTime,
		storeTime = storeTime
	}

	local scanstats = scandata.scanstats
	if not scanstats then
		scanstats = {}
		scandata.scanstats = scanstats
	end

	scanstats.LastScan = endTimeStamp
	if oldCount ~= currentCount or scanCount > 0 or dirtyCount > 0 or expiredDeleteCount > 0 or corruptDeleteCount > 0 then
		scanstats.ImageUpdated = endTimeStamp
	end
	if wasUnrestricted and not wasIncomplete then scanstats.LastFullScan = endTimeStamp end

	-- keep 2 old copies for compatibility
	scanstats[2] = scandata.scanstats[1]
	scanstats[1] = scandata.scanstats[0]
	scanstats[0] = TempcurScanStats

	-- Tell everyone that our stats are updated
	TempcurQuery.qryinfo.finished = true

	processBeginEndStats(processors, "complete", querySizeInfo, TempcurScanStats)

	AucAdvanced.SendProcessorMessage("scanstats", TempcurScanStats)

	--Hide the progress indicator
	lib.ProgressBars("CommitProgressBar", nil, false)
	private.UpdateScanProgress(false, nil, nil, nil, nil, nil, TempcurQuery)
	lib.PopScan()
	CommitRunning = false
	if not private.curQuery then
		private.ResetAll()
	end
	AucAdvanced.SendProcessorMessage("scanfinish", scanSize, TempcurQuery.qryinfo.sig, TempcurQuery.qryinfo, not wasIncomplete, TempcurQuery, TempcurScanStats)
end

local CoCommit, CoStore

local function CoroutineResume(...)
	local status, result = coroutine.resume(...)
	if not status and result then
		collectgarbage() -- ### trial to see if this helps recover from Memory Allocation Errors
		local msg = "Error occurred in coroutine: "..result
		if Swatter then
			Swatter.OnError(msg, nil, debugstack((...)))
		else
			geterrorhandler()(msg)
		end
	end
	return status, result
end

function private.Commit(wasEarlyTerm, wasEndPagesOnly, wasGetAll)
	private.StopStorePage()
	local curScan, curQuery, storeTime = private.curScan, private.curQuery, private.storeTime
	local scanStarted, scanStartTime, totalPaused = private.scanStarted, private.scanStartTime, private.totalPaused
	private.curQuery = nil
	private.curScan = nil
	private.isScanning = false
	if not (curQuery and curScan) then return end

	tinsert(private.CommitQueue, {
		Query = curQuery,
		Scan = curScan,
		wasIncomplete = wasEarlyTerm or wasEndPagesOnly,
		wasEarlyTerm = wasEarlyTerm,
		wasEndPagesOnly = wasEndPagesOnly,
		wasGetAll = wasGetAll,
		scanStarted = scanStarted,
		scanStartTime = scanStartTime,
		totalPaused = totalPaused,
		scanCommitTime = GetTime(),
		storeTime = storeTime
	})

	if not CoCommit or coroutine.status(CoCommit) == "dead" then
		CoCommit = coroutine.create(Commitfunction)
	end
	-- wait for the next update to resume CoCommit
end

function private.QuerySent(query, isSearch, ...)
	-- Tell everyone that our stats are updated
	AucAdvanced.SendProcessorMessage("querysent", query, isSearch, ...)
	return ...
end

function private.FinishedPage(nextPage)
	-- Tell everyone that our stats are updated
	local modules = AucAdvanced.GetAllModules("FinishedPage")
	for pos, engineLib in ipairs(modules) do
		local pOK, finished = pcall(engineLib.FinishedPage,nextPage)
		if (pOK) then
			if (finished~=nil) and (finished==false) then
				return false
			end
		else
			if (_G.nLog) then
				_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_WARNING, ("FinishedPage %s Returned Error %s"):format(engineLib.GetName(), finished))
			end
		end
	end
	return true
end

function private.ScanPage(nextPage, really)
	if (private.isScanning) then
		local CanQuery, CanQueryAll = CanSendAuctionQuery()
		if not (CanQuery and private.FinishedPage(nextPage) and really) then
			private.scanNext = GetTime()
			private.scanNextPage = nextPage
			return
		end
		private.sentQuery = true
		private.queryStarted = GetTime()
		private.auctionItemListUpdated = false
		SortAuctionClearSort("list")
		private.Hook.QueryAuctionItems(private.curQuery.name, private.curQuery.minUseLevel, private.curQuery.maxUseLevel,
		nextPage, private.curQuery.isUsable, private.curQuery.quality,
		nil, private.curQuery.exactMatch, private.curQuery.filterData)

		AuctionFrameBrowse.page = nextPage

		private.verifyStart = nil
	end
end

-- Mechanism to limit repeated calls to GetItemInfo and C_PetJournal.GetPetInfoBySpeciesID during processing
do
	local PetInfoCache, ItemTried, PetTried = {}, {}, {}
	local lookupPetType2SubClassID = Const.AC_PetType2SubClassID
	local GetItemInfoCacheLib = AucAdvanced.GetItemInfoCache

	function private.ResetItemInfoCache()
		-- clear all caches and reset everything
		-- note the ItemInfo cache is currently not cleared
		PetInfoCache, ItemTried, PetTried = {}, {}, {}
	end
	function private.InitItemInfoCache()
		wipe(ItemTried)
		wipe(PetTried)
	end

	local function GetItemInfoCacheWrapper(link, itemID, scanthrottle)
		if scanthrottle and ItemTried and ItemTried[itemID] then
			-- if GetItemInfo previously failed for a link with this cachekey in this processing pass (ItemTried is reset each pass)
			return
		end
		local iLevel,uLevel,_,_,_,equipLoc,_,_,classID,subClassID = GetItemInfoCacheLib(link, 4) -- start from 4th return value
		if not classID then
			if scanthrottle then
				ItemTried[itemID] = true
			end
			return
		end

		return classID, subClassID, Const.EquipEncode[equipLoc], iLevel, uLevel or 0
	end

	local function GetPetInfoCache(speciesID, scanthrottle)
		local subtype = PetInfoCache[speciesID]
		if not subtype then
			if scanthrottle and PetTried and PetTried[speciesID] then
				-- GetPetInfoBySpeciesID previously failed for this speciesID in this processing pass
				return
			end
			local _, _, petType = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
			if petType then
				subtype = lookupPetType2SubClassID[petType]
				PetInfoCache[speciesID] = subtype
			else
				if scanthrottle then
					PetTried[speciesID] = true
				end
				return
			end
		end

		return subtype
	end

	-- Called on a data table that has been processed by private.GetAuctionItem
	-- Fills in certain entries that can be calculated from other entries, and so do not need to be determined at scan time
	-- In particular, we avoid calling APIs GetItemInfo or C_PetJournal.GetPetInfoBySpeciesID duing the scan; we can delay them until processing
	function private.GetAuctionItemFillIn(itemData, scanthrottle) -- ### Legion : revised, check
		local linkType
		local itemID = itemData[Const.ITEMID]
		local itemLink = itemData[Const.LINK]
		if not (itemID and itemLink and itemData[Const.TLEFT]) then
			return nil, "Invalid", "unknown"
		end

		if itemID == 82800 then -- "Pet Cage"
			linkType = "battlepet"
			if not itemData[Const.SEED] then
				-- following entries are not relevant to battlepets
				itemData[Const.BONUSES] = ""
				itemData[Const.SUFFIX] = 0
				itemData[Const.FACTOR] = 0
				itemData[Const.ENCHANT] = 0
				itemData[Const.SEED] = 0 -- there must be a hidden unique seed, but I can't find a way to access it
			end
			if not itemData[Const.CLASSID] then
				local _, speciesID, level = strsplit(":", itemLink)
				speciesID = tonumber(speciesID)
				if speciesID then
					local subClassID = GetPetInfoCache(speciesID, scanthrottle)
					if subClassID then
						itemData[Const.CLASSID] = LE_ITEM_CLASS_BATTLEPET
						itemData[Const.IEQUIP] = nil -- always nil for Pet Cages
						itemData[Const.ULEVEL] = itemData[Const.ULEVEL] or 0 -- expected to be 0 for all battlepets
						itemData[Const.SUBCLASSID] = subClassID
						if not itemData[Const.ILEVEL] then
							-- iLevel should normally have been obtained from GetAuctionItemInfo, but if it's missing we can get it from the link
							itemData[Const.ILEVEL] = tonumber(level) or 1
						end
					end
				end
			end
		else
			linkType = "item"
			if not itemData[Const.SEED] then
				local lkt, id, suffix, factor, enchant, seed, _, _, _, _, bonuses = AucAdvanced.DecodeLink(itemLink)
				if lkt == "item" and id == itemID then
					itemData[Const.BONUSES] = bonuses or ""
					itemData[Const.SUFFIX] = suffix
					itemData[Const.FACTOR] = factor
					itemData[Const.ENCHANT] = enchant
					itemData[Const.SEED] = seed
				else
					-- unrecognised link type - if this is happening then we'll need to investigate the link type
					-- and install a special exception for it (similar to battlepet links, as above)
					if nLog then
						nLog.AddMessage("Auctioneer", "Scan", N_WARNING, "GetAuctionItemFillIn could not decode link",
							("Page %d, Index %d\nLink %s, itemID %d (from GetAuctionItemInfo)\ntype %s, id %s, suffix %s, factor %s, enchant %s, seed %s (from Decode)"):format(
								page, index, itemLink, itemID, tostringall(lkt, id, suffix, factor, enchant, seed)))
					end
					-- Note: SEED is still set to nil
					return nil, "UnknownLinkType", "unknown"
				end
			end
			if not itemData[Const.CLASSID] then
				local classID, subClassID, equipCode, iLevel, uLevel = GetItemInfoCacheWrapper(itemLink, itemID, scanthrottle) -- {iType, iSubtype, Const.EquipEncode[equipLoc], iLevel, uLevel}
				if classID then
					itemData[Const.CLASSID] = classID
					itemData[Const.SUBCLASSID] = subClassID
					itemData[Const.IEQUIP] = equipCode
					-- Prefer iLevel and/or uLevel values provided by GetAuctionItemInfo over those from GetItemInfo
					itemData[Const.ILEVEL] = itemData[Const.ILEVEL] or iLevel
					itemData[Const.ULEVEL] = itemData[Const.ULEVEL] or uLevel
				end
			end
		end

		if not itemData[Const.CLASSID] then
			return nil, "Retry", linkType
		end

		if not itemData[Const.SELLER] then itemData[Const.SELLER] = "" end

		return true, nil, linkType
	end
end

--[[ private.GetAuctionItem(list, page, index, itemData)
	Returns itemData, with entries filled in from the GetAuctionItemX & GetItemInfo functions, plus some additional processing
	If page is provided, requires the same itemData table as was used for the same page/index combination previously in the current scan
		This is used during scanning, when retrying an auction entry - also enables some error checking
	If page is not provided, itemData may be an empty table (if reusing a table, wipe it first)

	When checking itemData for completeness, check the following entries:
	Const.LINK : if this is missing, most other entries will be missing too. Auction is unresolvable, but may be possible to resolve after a delay
		if it is present, it is likely that most other entries will be present too
	Const.ITEMID : if present, most useful entries should be present, particularly all prices
	Const.TLEFT : is one of the last entries to get resolved - only happens if no failures were detected

	Const.CLASSID, Const.SEED : left blank
		private.GetAuctionItemFillIn should be called after to fill these in

	Const.SELLER : often missing, particularly during GetAll scans - may be resolvable after a delay, but may require a very long delay
		private.GetAuctionItemFillIn will replace missing seller with ""
--]]
function private.GetAuctionItem(list, page, index, itemData)
	if not itemData then
		itemData = {}
	elseif itemData.NORETRY then
		return itemData
	end
	itemData[Const.FLAG] = itemData[Const.FLAG] or 0

	local isLogging = nLog and page and list == "list"
	if isLogging then
		if not itemData.PAGE then
			itemData.PAGE = page
			itemData.PAGEINDEX = index
		elseif itemData.PAGE ~= page or itemData.PAGEINDEX ~= index then
			-- We messed up the indexing - if we used the page parameter we should have used the same itemData table as before
			local msg = ("Page new=%d old=%d\nIndex new=%d old=%d"):format(page, itemData.PAGE, index, itemData.PAGEINDEX)
			nLog.AddMessage("Auctioneer", "Scan", N_ERROR, "GetAuctionItem called with invalid page/index",
				msg)
			geterrorhandler()("GetAuctionItem called with invalid page/index\n"..msg)
			return itemData
		end
	end

	local itemLink = GetAuctionItemLink(list, index)
	if itemLink then
		itemLink = AucAdvanced.SanitizeLink(itemLink)
		if itemData[Const.LINK] and itemData[Const.LINK] ~= itemLink then
			-- Not the same auction as was at this position in the scan before!
			-- Log and abort so we don't corrupt it
			if isLogging then
				nLog.AddMessage("Auctioneer", "Scan", N_ERROR, "GetAuctionItem ItemLink does not match link found previously at this index",
					("Page %d, Index %d\nOld link %s\nNew link %s\nOld ITEMID %s, MINBID %s, TLEFT %s, SELLER %s"):format(page, index, itemData[Const.LINK], itemLink,
						tostringall(itemData[Const.ITEMID], itemData[Const.MINBID], itemData[Const.TLEFT], itemData[Const.SELLER]))) -- one of these must be missing for us to need to retry
			end
			itemData.NORETRY = "Link changed"
			return itemData
		end
		itemData[Const.LINK] = itemLink
	else
		return itemData
	end

	local name, texture, count, quality, canUse, level, levelColHeader, minBid, minIncrement, buyoutPrice, bidAmount, highBidder, bidderFullName, owner, ownerFullName, saleStatus, itemId = GetAuctionItemInfo(list, index)
	-- Check critical values (if we got those, assume we got the rest as well - except possibly owner)
	if not (itemId and minBid) then
		return itemData
	end
	if itemData[Const.MINBID] and itemData[Const.MINBID] ~= minBid then
		-- similar to itemLink changing, this means the auction is not the same one as was at this position before
		if isLogging then
			nLog.AddMessage("Auctioneer", "Scan", N_ERROR, "GetAuctionItem minBid does not match minBid found previously at this index",
				("Page %d, Index %d\nLink %s\nminBid old %s, new %s\nAll returns from GetAuctionItemInfo:\n%s"):format(page, index, itemLink, itemData[Const.MINBID], minBid,
				strjoin(",", tostringall(name, texture, count, quality, canUse, level, levelColHeader, minBid, minIncrement, buyoutPrice, bidAmount, highBidder, owner, saleStatus, itemId))))
		end
		itemData.NORETRY = "MinBid changed"
		return itemData
	end

	itemData[Const.ITEMID] = itemId
	itemData[Const.MINBID] = minBid

	itemData[Const.NAME] = name
	itemData[Const.DEP2] = nil
	itemData[Const.QUALITY] = quality
	itemData[Const.CANUSE] = canUse
	itemData[Const.AMHIGH] = highBidder and true or false
	itemData[Const.MININC] = minIncrement
	itemData[Const.SELLER] = owner -- if this is nil, it will get set to "" at a later time

	if not count or (count == 0 and (list ~= "owner" or saleStatus ~= 1)) then -- the only time count may be 0 is for a sold auction on the "owner" list
		count = 1
	end
	itemData[Const.COUNT] = count

	bidAmount = bidAmount or 0
	itemData[Const.CURBID] = bidAmount
	buyoutPrice = buyoutPrice or 0
	itemData[Const.BUYOUT] = buyoutPrice
	local nextBid
	if bidAmount > 0 then
		nextBid = bidAmount + minIncrement
		if buyoutPrice > 0 and nextBid > buyoutPrice then
			nextBid = buyoutPrice
		end
	elseif minBid > 0 then
		nextBid = minBid
	else
		nextBid = 1
	end
	itemData[Const.PRICE] = nextBid

	-- use the iLevel or uLevel data from GetAuctionItemInfo, if available
	if level then
		if levelColHeader == "REQ_LEVEL_ABBR" then
			itemData[Const.ULEVEL] = level
		elseif levelColHeader == "ITEM_LEVEL_ABBR"  then
			itemData[Const.ILEVEL] = level
		end
		-- todo: handle other possible values for levelColHeader
	end

	--[[
		Returns Integer giving range of time left for query
		1 -- short time (Less than 30 mins)
		2 -- medium time (30 mins to 2 hours)
		3 -- long time (2 hours to 8 hours)
		4 -- very long time (8 hours+)
	]]
	itemData[Const.TLEFT] = GetAuctionItemTimeLeft(list, index)
	itemData[Const.TIME] = time()

	return itemData
end

function lib.GetAuctionItem(list, index, fillTable)
	if type(fillTable) == "table" then
		wipe(fillTable)
	else
		fillTable = nil
	end
	local itemData = private.GetAuctionItem(list, nil, index, fillTable)
	if not itemData[Const.TLEFT] then
		-- missing TLEFT indicates a failure was detected for one of the GetAuctionItemX functions
		return
	end
	private.GetAuctionItemFillIn(itemData)

	return itemData
end

function lib.GetAuctionSellItem(minBid, buyoutPrice, runTime)
	local itemLink = private.auctionItem
	local name, texture, count, quality, canUse, price = GetAuctionSellItemInfo();

	if name and itemLink then
		local linkType, itemId, itemSuffix, itemFactor, itemEnchant, itemSeed = AucAdvanced.DecodeLink(itemLink)
		if linkType == "item" then
			itemLink = AucAdvanced.SanitizeLink(itemLink)
			local _,_,_,itemLevel,level,_,_,_,itemEquipLoc,_,_,classID,subClassID = GetItemInfo(itemLink)
			local timeLeft = 4
			if runTime <= 12*60 then timeLeft = 3 end
			local curTime = time()

			return {
				itemLink, itemLevel, classID, subClassID, nil, minBid,
				timeLeft, curTime, name, texture, count, quality, canUse, level,
				minBid, 0, buyoutPrice, 0, nil, Const.PlayerName,
				0, -1, itemId, itemSuffix, itemFactor, itemEnchant, itemSeed
			}, price
		end
	end
end

--[[ Used to decide if we should retry scanning this auction
	returns: IsResolved, IsResolvedExceptSeller
	notes: assumes that if certain entries are present then auction is resolved (see notes for GetAuctionItem)
--]]
function private.isComplete(itemData)
	local resolved = itemData and itemData[Const.TLEFT]
	return itemData[Const.SELLER] and resolved, resolved
end

local StorePageFunction = function()
	if (not private.curQuery) or (private.curQuery.name == "empty page") then
		return
	end

	local GetTime = GetTime

	if (not private.scanStarted) then private.scanStarted = GetTime() end
	local queryStarted = private.scanStarted
	local retrievalStarted = GetTime()

	--local RunTime = 0 -- todo: reinstate RunTime calculations
	private.sentQuery = false
	local page = _G.AuctionFrameBrowse.page
	if not private.curScan then
		private.curScan = {}
	end
	if not private.curPages then
		private.curPages = {}
	end

	if (_G.nLog) then
		_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, ("StorePage For Page %d Started %fs after Query Start"):format(page, retrievalStarted - queryStarted), ("StorePage (Page %d) Called\n%f seconds have elapsed since scan start"):format(page, retrievalStarted - queryStarted))
	end

	if private.isGetAll then
		lib.ProgressBars("GetAllProgressBar", 0, true, "Auctioneer: Scan Received")
		--[[
			pre-store delay before starting to store a getall query to give the client a bit of time to sort itself out
			we want to call it before GetNumAuctionItems, so we must use private.isGetAll for detection
		--]]
		coroutine.yield()
	end

	local curQuery, curScan, curPages = private.curQuery, private.curScan, private.curPages
	local qryinfo = curQuery.qryinfo

	local EventFramesRegistered = nil
	local numBatchAuctions, totalAuctions = GetNumAuctionItems("list")
	local maxPages = ceil(totalAuctions / NUM_AUCTION_ITEMS_PER_PAGE)
	local isGetAll = false
	local isGetAllFail = false -- flag to handle certain GetAll failure situations
	if numBatchAuctions > NUM_AUCTION_ITEMS_PER_PAGE then
		isGetAll = true
		maxPages = 1
		if totalAuctions ~= numBatchAuctions then -- check for invalid values from server (residual test in case it starts to happen again...)
			isGetAllFail = true
			if nLog then
				nLog.AddMessage("Auctioneer", "Scan", N_WARNING, "StorePage incomplete GetAll",
					format("Batch size %d\nReported total auctions %d",
					numBatchAuctions, totalAuctions))
			end
			totalAuctions = numBatchAuctions
			aucPrint("|cffff7f3fThe Server has not sent all data for this GetAll scan. The scan will be incomplete.|r")
			aucPrint("Please report this in the Auctioneer forums.")
		end
		EventFramesRegistered = {GetFramesRegisteredForEvent("AUCTION_ITEM_LIST_UPDATE")}
		for _, frame in pairs(EventFramesRegistered) do
			frame:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
		end
		private.verifyStart = 1
		coroutine.yield()
	end

	--Update the progress indicator
	local elapsed = GetTime() - private.scanStarted - private.totalPaused
	--store queued scans to pass along on the callback, used by scanbutton and searchUI etc to display how many scans are still queued

	--page, maxpages, name  lets a module know when a "scan" they have queued is actually in progress. scansQueued lets a module know how may scans are left to go
	private.UpdateScanProgress(nil, totalAuctions, #curScan, elapsed, page+1, maxPages, curQuery) --page starts at 0 so we need to add +1

	-- coroutine speed limiter using debugprofilestop
	-- time in milliseconds: 1000/FPS * 0.8 (80% rough adjustment to allow for other stuff happening during the frame)
	local processingTime = 800 / get("scancommit.targetFPS")
	local debugprofilestop = debugprofilestop
	local nextPause = debugprofilestop() + processingTime
	local fillduringscan = get("core.scan.fillduringscan")

	local breakcount = 10000 -- additional limiter: yield every breakcount auctions scanned
	local scannerthrottle = get("core.scan.scannerthrottle")
	if scannerthrottle >= Const.ALEVEL_HI then
		breakcount = 500
		processingTime = processingTime * 0.1
	elseif scannerthrottle >= Const.ALEVEL_MED then
		breakcount = 2000
		processingTime = processingTime * 0.2
	elseif scannerthrottle >= Const.ALEVEL_LOW then
		breakcount = 5000
		processingTime = processingTime * 0.5
	end

	local storecount = 0
	local sellerOnly = true

	local missedCounts, remissedCounts, switchCounts, mc = {}, {}, nil, nil
	for i = 1, Const.LASTENTRY do
		missedCounts[i] = 0
	end
	local resolvedCounts = {}
	for i = 1, Const.LASTENTRY do
		remissedCounts[i] = 0
	end


	if not private.breakStorePage and (page > qryinfo.page) then
		-- First pass
		local retries = { }
		private.InitItemInfoCache()
		for i = 1, numBatchAuctions do
			if isGetAll then -- only yield for GetAll scans
				if debugprofilestop() > nextPause or i % breakcount == 0 then
					lib.ProgressBars("GetAllProgressBar", 100*storecount/numBatchAuctions, true, "Auctioneer: Scanning")
					coroutine.yield()
					if private.breakStorePage then
						break
					end
					nextPause = debugprofilestop() + processingTime
				end
			end

			local itemData = private.GetAuctionItem("list", page, i)

			if (itemData) then
				local isComplete, completeMinusSeller = private.isComplete(itemData)
				if (isComplete) then
					if fillduringscan then
						private.GetAuctionItemFillIn(itemData, true)
					end
					tinsert(curScan, itemData)
					storecount = storecount + 1
				else
					for mc = 1, Const.LASTENTRY do
						missedCounts[mc] = missedCounts[mc] + ((itemData[mc] and 0) or 1)
					end
					sellerOnly = sellerOnly and completeMinusSeller
					tinsert(retries, { i, itemData })
				end
			else
				for mc = 1, Const.LASTENTRY do
					missedCounts[mc] = missedCounts[mc] + 1
				end
				sellerOnly = false
				tinsert(retries, { i, nil })
			end
		end
		local maxTries = get('scancommit.ttl')
		local tryCount = 0
		if _G.nLog and (#retries > 0) then
			_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, ("StorePage Requires Retries Page %d"):format(page),
				("Page: %d\nRetries Setting: %d\nUnresolved Entries:%d\nPage Elapsed Time: %.2fs"):format(page, maxTries, #retries, GetTime() - retrievalStarted))
		end

		-- Second and subsequent passes
		local newRetries = { }
		local readCount = 1
		local needsRetries = #retries > 0
		while (needsRetries and tryCount < maxTries and ((not sellerOnly) or get("core.scan.sellernamedelay")) and not private.breakStorePage) do
			needsRetries = false
			sellerOnly = true
			tryCount = tryCount + 1
			private.InitItemInfoCache()
			-- must use GetTime to time this pause, as debugprofilestop is unsafe across yields
			local nextWait = GetTime() + 1
			while GetTime() < nextWait do
				coroutine.yield() -- yielding updates GetTime, so this loop will still work
				if private.breakStorePage then break end
			end
			if private.breakStorePage then break end

			nextPause = debugprofilestop() + processingTime
			for pos, i in ipairs(retries) do
				if isGetAll then
					if debugprofilestop() > nextPause or pos % breakcount == 0 then
						lib.ProgressBars("GetAllProgressBar", 100*storecount/numBatchAuctions, true, "Auctioneer: Scanning Retries")
						coroutine.yield()
						if private.breakStorePage then break end
						nextPause = debugprofilestop() + processingTime
					end
				end

				readCount = readCount + 1

				local itemData = private.GetAuctionItem("list", page, i[1], i[2])

				if (itemData) then
					local isComplete, completeMinusSeller = private.isComplete(itemData)
					if (isComplete) then
						if fillduringscan then
							private.GetAuctionItemFillIn(itemData, true)
						end
						tinsert(curScan, itemData)
						storecount = storecount + 1
					else
						for mc = 1, Const.LASTENTRY do
							remissedCounts[mc] = remissedCounts[mc] + ((itemData[mc] and 0) or 1)
						end
						sellerOnly = sellerOnly and completeMinusSeller
						if not itemData.NORETRY then
							needsRetries = true
						end
						tinsert(newRetries, { i[1], itemData })
					end
				else
					for mc = 1, Const.LASTENTRY do
						remissedCounts[mc] = remissedCounts[mc] + ((itemData[mc] and 0) or 1)
					end
					sellerOnly = false
					tinsert(newRetries, i)
				end
			end

			if (#retries ~= #newRetries) then
				if _G.nLog then
					local resolvedMap = ""
					local missingMap = ""
					resolvedMap = ("%d"):format(missedCounts[1]-remissedCounts[1])
					missingMap = ("%d"):format(remissedCounts[1])
					for mc = 2, Const.LASTENTRY do
						resolvedMap = ("%s,%d"):format(resolvedMap,missedCounts[mc]-remissedCounts[mc])
						missingMap = ("%s,%d"):format(missingMap,remissedCounts[mc])
						if mc==Const.SELLER then
							resolvedMap = resolvedMap.."*"
							missingMap = missingMap.."*"
						elseif mc==Const.IEQUIP then
							resolvedMap = resolvedMap.."-"
							missingMap = missingMap.."-"
						end
					end

					_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO,
						("StorePage Retry Successful Page %d"):format(page),
						("Page: %d\nRetry Count: %d\nRecords Returned: %d\nRecords Left: %d\nPage Elapsed Time: %.2fs\nResolved:\n %s\nRemaining Unresolved:\n %s\nSeller Only Remaining: %s,   Wait on Only Seller: %s"):format(page, tryCount,
							#retries - #newRetries, #newRetries, GetTime() - retrievalStarted, resolvedMap, missingMap, sellerOnly and "True" or "False", get("core.scan.sellernamedelay") and "True" or "False"))
				end
				-- Found at least one.  Reset retry delay.
				tryCount = 0
			end
			for mc = 1, Const.LASTENTRY do
				missedCounts[mc]=remissedCounts[mc]
				remissedCounts[mc]=0
			end
			retries = newRetries
			newRetries = { }
		end


		local names_missed, all_missed, ld_and_names_missed, links_missed, link_data_missed = 0,0,0,0,0
		nextPause = debugprofilestop() + processingTime
		for _, i in ipairs(retries) do
			if isGetAll then
				if debugprofilestop() > nextPause then
					lib.ProgressBars("GetAllProgressBar", 100*storecount/numBatchAuctions, true, "Auctioneer: Scanning Cleanup")
					coroutine.yield()
					if private.breakStorePage then break end
					nextPause = debugprofilestop() + processingTime
				end
			end
			readCount = readCount + 1
			-- Put it to scan and let the commit routine deal with it.
			if (not i[2][Const.SELLER] and not i[2][Const.LINK]) then
				i[2][Const.SELLER] = ""
				all_missed = all_missed + 1
			elseif (not i[2][Const.SELLER] and not i[2][Const.ITEMID]) then
				i[2][Const.SELLER] = ""
				ld_and_names_missed = ld_and_names_missed + 1
			elseif (not i[2][Const.SELLER]) then
				i[2][Const.SELLER] = ""
				names_missed = names_missed + 1
			elseif (not i[2][Const.LINK]) then
				links_missed = links_missed + 1
			elseif (not i[2][Const.ITEMID]) then
				link_data_missed = link_data_missed + 1
			end
			tinsert(curScan, i[2])
		end

		if _G.nLog and #retries > 0 then
			_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, ("StorePage Incomplete Resolution of Page %d"):format(page),
				("Page: %d\nRetries Setting: %d\nUnresolved Entries: %d\nMissing Everything: %d, Just Names: %d, Just Links (and link data): %d, Names and Link Data: %d, Link Data: %d"):format(page,
				maxTries, #retries, all_missed, names_missed, links_missed, ld_and_names_missed, link_data_missed ))
		end

		if storecount > 0 or page == 0 then
			qryinfo.page = page
			curPages[page] = true -- we have pulled this page
		end

		if #retries > 0 then
			-- for info only; CommitFunction does its own 'incomplete' detection
			qryinfo.unresolved = (qryinfo.unresolved or 0) + all_missed + links_missed + link_data_missed + ld_and_names_missed
		end
	end

	if EventFramesRegistered then
		for _, frame in pairs(EventFramesRegistered) do
			frame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
			local eventscript = frame:GetScript("OnEvent")
			if eventscript then
				pcall(eventscript, frame, "AUCTION_ITEM_LIST_UPDATE")
			end
		end
		EventFramesRegistered = nil
	end

	--Send a Processor event to modules letting them know we are done with the page
	AucAdvanced.SendProcessorMessage("pagefinished", page)

	-- Clear GetAll changes made by StartScan
	if private.isGetAll then -- in theory private.isGetAll should be true iff (local) isGetAll is true -- unless total auctions <=50 (e.g. on PTR)
		lib.ProgressBars("GetAllProgressBar", 100, false)
		BrowseSearchButton:Show()
		AucAdvanced.API.BlockUpdate(false)
		private.isGetAll = nil
	end

	coroutine.yield() -- update GetTime
	local endTime = GetTime()
	if not private.breakStorePage then
		-- Send the next page query or finish scanning
		if isGetAll then
				elapsed = endTime - private.scanStarted - private.totalPaused
				private.UpdateScanProgress(nil, totalAuctions, #curScan, elapsed, page+2, maxPages, curQuery) -- page+2 signals that scan is done
				private.Commit(isGetAllFail, false, true)
				-- Clear the getall output. We don't want to create a new query so use the hook
				-- ### temp fix: isUsable flag appears to be acting like a mini-getall, in this case we don't want to blank the results
				if not curQuery.isUsable then
					private.queryStarted = GetTime()
					private.Hook.QueryAuctionItems("empty page", nil, nil, nil, nil, nil, nil, nil, nil)
				end -- ###
		elseif private.isScanning then
			if (page+1 < maxPages) then
				private.ScanPage(page + 1)
			else
				elapsed = endTime - private.scanStarted - private.totalPaused
				private.UpdateScanProgress(nil, totalAuctions, #curScan, elapsed, page+2, maxPages, curQuery)
				private.Commit(false, false, false)
			end
		elseif (maxPages == page+1) then
			local incomplete = false
			for i = 0, maxPages-1 do
				if not curPages[i] then
					incomplete = true
					break
				end
			end
			local wasEndOnly = false
			if incomplete and curPages[maxPages-1] then
				wasEndOnly = true
				for i = 1, maxPages-3 do
					if curPages[i] then
						wasEndOnly = false
						break
					end
				end
			end
			elapsed = endTime - private.scanStarted - private.totalPaused
			private.UpdateScanProgress(nil, totalAuctions, #curScan, elapsed, page+2, maxPages, curQuery)
			private.Commit(incomplete, wasEndOnly, false)
		elseif maxPages == 0 and page == 0 and numBatchAuctions == 0 then
			-- manual search, no auctions returned
			elapsed = endTime - private.scanStarted - private.totalPaused
			private.UpdateScanProgress(nil, totalAuctions, #curScan, elapsed, page+2, maxPages, curQuery)
			private.Commit(false, false, false)
		end
	end
	private.storeTime = endTime-retrievalStarted -- temp hack as RunTime calculation is broken - this will include paused and other non-processing time!
	if (_G.nLog) then
		_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, ("StorePage Page %d Complete"):format(page),
--		("Query Elapsed: %fs\nThis Page Store Elapsed: %fs\nThis Page Code Execution Time: %fs"):format(endTime-queryStarted, endTime-retrievalStarted, RunTime))
		("Query Elapsed: %fs\nThis Page Store Elapsed: %fs"):format(endTime-queryStarted, endTime-retrievalStarted))
	end
end

function private.StopStorePage(silent)
	if not CoStore or coroutine.status(CoStore) ~= "suspended" then return end
	local isGetAll = private.isGetAll
	-- flag to break out of the loop, or prevent the loop being entered, within the coroutine
	private.breakStorePage = true
	while coroutine.status(CoStore) == "suspended" do
		CoroutineResume(CoStore)
	end
	private.breakStorePage = nil
	if isGetAll and not silent then
		_G.message("Warning: GetAll scan is incomplete because it was interrupted")
	end
end

function lib.StorePage()
	if not CoStore or coroutine.status(CoStore) == "dead" then
		CoStore = coroutine.create(StorePageFunction)
		CoroutineResume(CoStore)
	elseif coroutine.status(CoStore) == "suspended" then
		CoroutineResume(CoStore)
	end
end

--[[ AucAdvanced.Scan.QueryFilterFromID(classID, subClassID, inventoryType)
	-- Auctioneer core functions generally work with ID values
	-- In scandata records, indexes Const.CLASSID and Const.SUBCLASSID are stored as IDs
	-- GetitemInfo returns classID and subClassID at postions 12 and 13
	-- Caution: this is different from the index system used by Blizzard_AuctionUI
	-- Caution: do not use EquipEncode values for inventoryType
--]]
function lib.QueryFilterFromID(classID, subClassID, inventoryType)
	if type(classID) ~= "number" or classID < 0 then return end
	if subClassID ~= nil and (type(subClassID) ~= "number" or subClassID < 0) then return end
	if type(inventoryType) == "number" then
		if inventoryType < 0 or not subClassID then return end
	elseif inventoryType ~= nil then return end

	return {{ classID = classID, subClassID = subClassID, inventoryType = inventoryType}}
end
--[[ AucAdvanced.Scan.QueryFilterFromIndex(categoryIndex, subCategoryIndex, subSubCategoryIndex)
	Blizzard functions use indexes into the AuctionCategories structure
--]]
function lib.QueryFilterFromIndex(categoryIndex, subCategoryIndex, subSubCategoryIndex)
	if not AuctionCategories then return end
	local node = AuctionCategories[categoryIndex]
	if not node then return end
	if subCategoryIndex then
		local subcat = node.subCategories
		if not subcat then return end
		node = subcat[subCategoryIndex]
		if not node then return nil end

		if subSubCategoryIndex then
			subcat = node.subCategories
			if not subcat then return end
			node = subcat[subSubCategoryIndex]
			if not node then return end
		end
	end

	return node.filters
end
function lib.CreateFilterSig(filterData)
	if type(filterData) ~= "table" then return end
	local sig = ""
	for index, filter in ipairs(filterData) do
		local separator = "+"
		if index == 1 then separator = "" end
		local classID, subClassID, inventoryType = filter.classID, filter.subClassID, filter.inventoryType
		if classID then
			if subClassID then
				if inventoryType then
					sig = sig .. separator .. classID .. "." .. subClassID .. "." .. inventoryType
				else
					sig = sig .. separator .. classID .. "." .. subClassID
				end
			else
				sig = sig .. separator .. classID
			end
		end
	end
	return sig
end
function private.CompareFilterData(data1, data2)
	if data1 == data2 then
		return true -- same table
	elseif not data1 then
		if not data2 then
			return true -- both nil or false
		else
			return false -- one nil, one table
		end
	elseif not data2 then
		return false -- one table, one nil
	end
	-- assume both are tables at this point, as we should have pre-checked this
	local count = #data1
	if #data2 ~= count then
		-- different number of entries
		return false
	end
	for index = 1, count do
		local filter1, filter2 = data1[index], data2[index]
		-- each should be table containing entries classID [, subClassID [, inventoryType]]
		if filter1.classID ~= filter2.classID or filter1.subClassID ~= filter2.subClassID then
			return false
		end
		if filter1.subClassID and filter1.inventoryType ~= filter2.inventoryType then
			-- only check inventoryType if we have subClassID
			return false
		end
	end
	return true
end

--[[ AucAdvanced.Scan.QuerySafeName(name)
	Library function to convert a name to the 'normalized' form used by scan querys
	Note: performs truncation on names over 63 bytes as QueryAuctionItems cannot handle longer strings
--]]
function lib.QuerySafeName(name)
	if type(name) == "string" and #name > 0 then
		if #name > 63 then
			if name:byte(63) >= 192 then -- UTF-8 multibyte first byte
				name = name:sub(1, 62)
			elseif name:byte(62) >= 224 then -- UTF-8 triplebyte first byte
				name = name:sub(1, 61)
			else
				name = name:sub(1, 63)
			end
		end
		return name:lower()
	end
end

--[[ AucAdvanced.Scan.CreateQuerySig(name, minLevel, maxLevel, invTypeIndex, classIndex, subclassIndex, isUsable, qualityIndex)
	Library function to allow other modules to obtain a query sig
	Returns the sig that would be used in a scan with the specified parameters
--]]
function lib.CreateQuerySig(...)
	return private.CreateQuerySig(private.QueryScrubParameters(...))
end

function private.QueryScrubParameters(name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData)
	-- Converts the parameters that we will store in our scanQuery table into a consistent format:
	-- converts each parameter to correct type;
	-- converts all strings to lowercase;
	-- converts all "" and 0 to nil;
	-- converts any invalid parameters to nil.
	name = lib.QuerySafeName(name)
	minLevel = tonumber(minLevel)
	if minLevel and minLevel < 1 then minLevel = nil end
	maxLevel = tonumber(maxLevel)
	if maxLevel and maxLevel < 1 then maxLevel = nil end
	if isUsable and isUsable ~= 0 then
		isUsable = true
	else
		isUsable = nil
	end
	if name and exactMatch and exactMatch ~= 0 then
		exactMatch = true -- exactMatch is only valid if we have a name
	else
		exactMatch = nil
	end
	qualityIndex = tonumber(qualityIndex)
	if qualityIndex and qualityIndex < 1 then qualityIndex = nil end

	-- ### todo: more robust filterData checks?
	if type(filterData) ~= "table" then filterData = nil end

	return name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData
end

function private.CreateQuerySig(name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData)
	return strjoin("#",
		name or "",
		minLevel or "",
		maxLevel or "",
		isUsable and "1" or "", -- can't concatenate booleans
		qualityIndex or "",
		exactMatch and "1" or "",
		lib.CreateFilterSig(filterData) or "" -- filter sigs contain "+" and "." separators
	) -- can use strsplit("#", sig) to extract params
end

function private.QueryCompareParameters(query, name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData)
	-- Returns true if the parameters are identical to the values stored in the specified scanQuery table
	-- Use this function to avoid creating a duplicate scanQuery table
	-- Parameters must have been scrubbed first
	-- Note: to compare two scanQuery tables for equality, just compare the sigs
	if query.name == name -- note: both already converted to lowercase when scrubbed
	and query.minUseLevel == minLevel
	and query.maxUseLevel == maxLevel
	and query.quality == qualityIndex
	and query.isUsable == isUsable
	and query.exactMatch == exactMatch
	and private.CompareFilterData(query.filterData, filterData)
	then
		return true
	end
end

private.querycount = 0

function private.NewQueryTable(name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData)
	-- Assumes the parameters have already been scrubbed
	local class, subclass
	local query, qryinfo = {}, {}
	query.qryinfo = qryinfo
	qryinfo.query = query

	query.name = name
	query.minUseLevel = minLevel
	query.maxUseLevel = maxLevel
	query.isUsable = isUsable
	query.quality = qualityIndex
	query.exactMatch = exactMatch
	query.filterData = filterData

	qryinfo.page = -1 -- use this to store highest page seen by query, and we haven't seen any yet.
	qryinfo.id = private.querycount
	private.querycount = private.querycount+1
	qryinfo.sig = private.CreateQuerySig(name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData)

	-- store the current serverKey value for compatibility, no longer used by Auctioneer code - ### deprecated
	qryinfo.serverKey = Resources.ServerKey

	local scanSize = false, ""
	if ((not query.filterData)
			and (not query.maxUseLevel)
			and (not query.name) and (not query.isUsable)
			and (not query.quality)
			and (not query.exactMatch)) then
		qryinfo.scanSize = "Full"
	elseif (query.name and query.filterData) then
		qryinfo.scanSize = "Micro"
	else
		qryinfo.scanSize = "Partial"
	end
	query.pageIncomplete = false
	return query
end

private.Hook = {}
private.Hook.QueryAuctionItems = QueryAuctionItems
local isSecure, taint = issecurevariable("CanSendAuctionQuery")
if not isSecure then
	private.warnTaint = taint
end
private.CanSend = CanSendAuctionQuery

function QueryAuctionItems(name, minLevel, maxLevel, page, isUsable, qualityIndex, GetAll, exactMatch, filterData, ...) -- ### Legion check
	if not private.isAuctioneerQuery then
		-- Optional bypass to handle compatibility problems with other AddOns
		local doBypass = false
		if private.compatModeLocks then
			local scanbit = private.isBlizzardQuery and 2 or 1
			for lock, mode in pairs(private.compatModeLocks) do
				if bitand(mode, scanbit) ~= 0 then -- another AddOn has requested we bypass this scan type
					doBypass = true
					break
				end
			end
			private.compatModeLocks[""] = nil -- remove anonymous lock (if present)
		end
		doBypass = doBypass or not get("core.scan.scanallqueries")
		if doBypass then
			return private.Hook.QueryAuctionItems(name, minLevel, maxLevel, page, isUsable, qualityIndex, GetAll, exactMatch, filterData, ...)
		end
	end

	private.isAuctioneerQuery = nil
	private.isBlizzardQuery = nil
	if private.compatModeLocks and not next(private.compatModeLocks) then
		private.compatModeLocks = nil -- remove table if empty
	end
	if private.warnTaint then
		aucPrint("\nAuctioneer:\n  WARNING, The CanSendAuctionQuery() function was tainted by the addon: {{"..private.warnTaint.."}}.\n  This may cause minor inconsistencies with scanning.\n  If possible, adjust the load order to get me to load first.\n ")
		private.warnTaint = nil
	end
	if not private.CanSend() then
		aucPrint("Can't send query just at the moment")
		return
	end

	local isSearch = (BrowseSearchButton:GetButtonState() == "PUSHED")

	-- If we're getting called after we've sent a query, but before it's been stored, take this chance to save it.
	if private.sentQuery then
		lib.StorePage()
	end

	name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData = private.QueryScrubParameters(
		name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData)

	local query
	if private.curQuery then
		if not GetAll and not private.isGetAll
		and private.QueryCompareParameters(private.curQuery, name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData) then
			private.StopStorePage()
			query = private.curQuery
			if (_G.nLog) then
				_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, ("Sending existing query %d (%s)"):format(query.qryinfo.id, query.qryinfo.sig))
			end
		else
			private.Commit(true, false, false)
		end
	end
	if not query then
		query = private.NewQueryTable(name, minLevel, maxLevel, isUsable, qualityIndex, exactMatch, filterData)
		private.scanStartTime = time()
		private.scanStarted = GetTime()
		private.totalPaused = 0
		private.storeTime = 0
		private.curQuery = query
	end

	page = tonumber(page) or 0
	if (page==0) then
		local scanSize = query.qryinfo.scanSize
		if (query.qryinfo.NoSummary) then
			scanSize = "NoSum-"..scanSize
		end
		if (_G.nLog) then
			local queryType = "standard"
			if (GetAll) then queryType = "get all" end
			_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, ("Sending new %s query %d (%s)"):format(queryType, query.qryinfo.id, query.qryinfo.sig))
		end
		AucAdvanced.SendProcessorMessage("scanstart", scanSize, query.qryinfo.sig, query)
	end


	private.sentQuery = true
	lib.lastReq = GetTime()

	private.queryStarted = GetTime()
	private.auctionItemListUpdated = false
	return private.QuerySent(query, isSearch,
		private.Hook.QueryAuctionItems(
			name, minLevel, maxLevel, page, isUsable, qualityIndex, GetAll, exactMatch, filterData, ...))
end

private.Hook.PlaceAuctionBid = PlaceAuctionBid
function PlaceAuctionBid(type, index, bid, ...)
	local itemData = lib.GetAuctionItem(type, index)
	if itemData then
		private.Unpack(itemData, statItem)
		local modules = AucAdvanced.GetAllModules("ScanProcessors")
		for pos, engineLib in ipairs(modules) do
			if engineLib.ScanProcessors["placebid"] then
				local pOK, errormsg = pcall(engineLib.ScanProcessors["placebid"],"placebid", statItem, type, index, bid)
				if not pOK then
					local text = ("Error trapped for ScanProcessor 'placebid' in module %s:\n%s"):format(engineLib.GetName(), errormsg)
					if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "ScanProcessor Error", text) end
					geterrorhandler()(text)
				end
			end
		end
	end
	return private.Hook.PlaceAuctionBid(type, index, bid, ...)
end

private.Hook.ClickAuctionSellItemButton = ClickAuctionSellItemButton
function ClickAuctionSellItemButton(...)
	local ctype, itemID, itemLink = GetCursorInfo()
	if ctype == "item" then
		private.auctionItem = itemLink
	else
		private.auctionItem = nil
	end
	return private.Hook.ClickAuctionSellItemButton(...)
end

private.Hook.PostAuction = PostAuction
function PostAuction(minBid, buyoutPrice, runTime, stackSize, numStacks, ...)
	local itemData, price = lib.GetAuctionSellItem(minBid, buyoutPrice, runTime)
	if itemData then
		private.Unpack(itemData, statItem)
		local modules = AucAdvanced.GetAllModules("ScanProcessors")
		for pos, engineLib in ipairs(modules) do
			if engineLib.ScanProcessors["newauc"] then
				local pOK, errormsg = pcall(engineLib.ScanProcessors["newauc"],"newauc", statItem, minBid, buyoutPrice, runTime, price, stackSize, numStacks)
				if not pOK then
					local text = ("Error trapped for ScanProcessor 'newauc' in module %s:\n%s"):format(engineLib.GetName(), errormsg)
					if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "ScanProcessor Error", text) end
					geterrorhandler()(text)
				end
			end
		end
	end
	return private.Hook.PostAuction(minBid, buyoutPrice, runTime, stackSize, numStacks, ...)
end

function ProcessInbox(index)
    local _, _, sender, subject, money, _, daysLeft, itemCount, _, _, _, _, _, firstItemQuantity, firstItemLink = GetInboxHeaderInfo(index)

    if not sender then return end

    local modules = AucAdvanced.GetAllModules("ScanProcessors")
    local auctionTime = daysLeft and (time() + (daysLeft - 30) * 86400)

    -- "Auction successful:"
    if strfind(subject, SuccessLocale) then
        local invoiceType, itemName, playerName, bid, buyout, deposit, consignment, _, _, _, count, _ = GetInboxInvoiceInfo(index)
        if not invoiceType == 'seller' or not money or money == 0 then return end
        
        for engineLib=1, #modules do
            local aucsold = modules[engineLib].ScanProcessors.aucsold
            if aucsold then
                local pOK, errormsg = pcall(aucsold, "aucsold", auctionTime, itemName, playerName, bid, buyout, deposit, consignment, count)
                if not pOK then
                    local text = ("Error trapped for ScanProcessor 'aucsold' in module %s:\n%s"):format(modules[engineLib].GetName(), errormsg)
                    if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "ScanProcessor Error", text) end
                    geterrorhandler()(text)
                end
            end
        end

    -- "Auction won:"
    elseif strfind(subject, WonLocale) then
        local invoiceType, itemName, playerName, bid, buyout, _, _, _, _, _, count, _ = GetInboxInvoiceInfo(index)
        if not invoiceType == 'buyer' or not itemCount or itemCount == 0 then return end

        for engineLib=1, #modules do
            local aucwon = modules[engineLib].ScanProcessors.aucwon
            if aucwon then
                local pOK, errormsg = pcall(aucwon, "aucwon", auctionTime, itemName, playerName, bid, buyout, count, firstItemLink)
                if not pOK then
                    local text = ("Error trapped for ScanProcessor 'aucwon' in module %s:\n%s"):format(modules[engineLib].GetName(), errormsg)
                    if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "ScanProcessor Error", text) end
                    geterrorhandler()(text)
                end
            end
        end

    -- "Auction expired:"
    elseif strfind(subject, ExpiredLocale) then
        if not itemCount or itemCount == 0 then return end

        local itemName = GetInboxItem(index, 1) -- first (only) attachment

        for engineLib=1, #modules do
            local aucexpired = modules[engineLib].ScanProcessors.aucexpired
            if aucexpired then
                local pOK, errormsg = pcall(aucexpired, "aucexpired", auctionTime, itemName, firstItemQuantity, firstItemLink)
                if not pOK then
                    local text = ("Error trapped for ScanProcessor 'aucexpired' in module %s:\n%s"):format(modules[engineLib].GetName(), errormsg)
                    if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "ScanProcessor Error", text) end
                    geterrorhandler()(text)
                end
            end
        end

    -- "Auction cancelled:"
    elseif strfind(subject, CancelledLocale) then
        if not itemCount or itemCount == 0 then return end

        local itemName = GetInboxItem(index, 1) -- first (only) attachment

        for engineLib=1, #modules do
            local auccancelled = modules[engineLib].ScanProcessors.auccancelled
            if auccancelled then
                local pOK, errormsg = pcall(auccancelled, "auccancelled", auctionTime, itemName, firstItemQuantity, firstItemLink)
                if not pOK then
                    local text = ("Error trapped for ScanProcessor 'auccancelled' in module %s:\n%s"):format(modules[engineLib].GetName(), errormsg)
                    if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "ScanProcessor Error", text) end
                    geterrorhandler()(text)
                end
            end
        end

    -- TODO? other tests such as COD Buys or outbid auctions (AUCTION_OUTBID_MAIL_SUBJECT)
    else
        return
    end

    return
end

private.Hook.TakeInboxMoney = TakeInboxMoney
function TakeInboxMoney(index, ...)
    local pOK, errormsg = pcall(ProcessInbox, index)
    if not pOK then
        local text = ("Error trapped for Hook 'TakeInboxMoney'\n%s"):format(errormsg)
        if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "Hook Error", text) end
        geterrorhandler()(text)
    end
    return private.Hook.TakeInboxMoney(index, ...)
end

private.Hook.AutoLootMailItem = AutoLootMailItem
function AutoLootMailItem(index, ...)
    local pOK, errormsg = pcall(ProcessInbox, index)
    if not pOK then
        local text = ("Error trapped for Hook 'AutoLootMailItem'\n%s"):format(errormsg)
        if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "Hook Error", text) end
        geterrorhandler()(text)
    end
    return private.Hook.AutoLootMailItem(index, ...)
end

private.Hook.TakeInboxItem = TakeInboxItem
function TakeInboxItem(index, ...)
    local pOK, errormsg = pcall(ProcessInbox, index)
    if not pOK then
        local text = ("Error trapped for Hook 'TakeInboxItem'\n%s"):format(errormsg)
        if (_G.nLog) then _G.nLog.AddMessage("Auctioneer", "Scan", _G.N_ERROR, "Hook Error", text) end
        geterrorhandler()(text)
    end
    return private.Hook.TakeInboxItem(index, ...)
end

-- Function to indicate that the next call to QueryAuctionItems comes from Auctioneer itself.
function lib.SetAuctioneerQuery()
	private.isAuctioneerQuery = true
end

--[[ Function for third-party AddOns to change Auctioneer's scanning behaviour to avoid compatibility issues
	Duplicates or overrides certain compatibility Config settings
	mode 1 : don't scan next raw call to QueryAuctionItems (i.e. neither isAuctioneerQuery nor isBlizzardQuery is set)
	mode 2 : don't scan next Blizzard query (i.e. isBlizzardQuery is set but isAuctioneerQuery is not set)

	lock : optional lock "key" (preferably string containing AddOn name for uniqueness)
		given mode will persist until cancelled: cancel by calling CompatibilityMode with mode 0 and the same lock "key"
--]]
function lib.CompatibilityMode(mode, lock)
	if type(mode) ~= "number" or floor(mode) ~= mode then
		error("AucAdvanced.Scan.CompatibilityMode(mode, lock)\nmode must be a number (bitfield)", 2)
	end
	lock = lock or "" -- use "" as key for anonymous locks, which are removed by the next call to QueryAuctionItems
	if not private.compatModeLocks then
		private.compatModeLocks = {}
	end

	if lock == "" then -- anonymous lock
		private.compatModeLocks[lock] = bitor(private.compatModeLocks[lock] or 0, mode) -- merge modes
	elseif mode == 0 then
		private.compatModeLocks[lock] = nil
	else
		private.compatModeLocks[lock] = mode -- overwrite mode
	end
end

function lib.SetPaused(pause)
	if private.isGetAll then
		-- A GetAll scan cannot be Popped or Pushed
		assert(not private.isPaused)
		if pause then
			aucPrint("Scan cannot be paused/unpaused because it is a GetAll scan")
		end
		return
	end
	if pause then
		if private.isPaused then return end
		lib.PushScan()
		private.isPaused = true
	elseif private.isPaused then
		lib.PopScan()
		private.isPaused = false
	end
end

private.unexpectedClose = false
local timeoutSentQuery = 0

function private.OnUpdate(me, dur)
	if CoCommit then
		local costat = coroutine.status(CoCommit)
		if costat == "suspended" then
			CoroutineResume(CoCommit)
		elseif costat == "dead" then
			if #private.CommitQueue > 0 then
				CoCommit = coroutine.create(Commitfunction)
				CoroutineResume(CoCommit)
			else
				CoCommit = nil
			end
		end
	end
	local auctionFrame = _G.AuctionFrame
	if not auctionFrame then return end
	if private.isPaused then return end
	local isVisibleAucFrame = auctionFrame:IsVisible()

	if private.queueScan then
		if isVisibleAucFrame and CanSendAuctionQuery() then
			local queued = private.queueScan
			private.queueScan = nil
			lib.StartScan(unpack(queued, 1, private.queueScanParams)) -- explicit start and end points as some entries may be nil
		end
		return
	end

	if CoStore and coroutine.status(CoStore) == "suspended" and isVisibleAucFrame then
		CoroutineResume(CoStore)
	end
	if private.scanNext then
		if isVisibleAucFrame and CanSendAuctionQuery() then
			local nextPage = private.scanNextPage
			private.scanNext = nil
			private.ScanPage(nextPage, true)
		end
		return
	end

	if isVisibleAucFrame then
		if private.unexpectedClose then
			private.unexpectedClose = false
			lib.PopScan()
			return
		end

		if private.sentQuery then
			local itemlistUpdated = private.auctionItemListUpdated
			local canSend = CanSendAuctionQuery()
			if itemlistUpdated and canSend then
				timeoutSentQuery = 0
				lib.StorePage()
			elseif itemlistUpdated and timeoutSentQuery > 30 then
				-- Fix in case CanSendAuctionQuery continues to return nil indefinitely. We use a timeout {ADV-595}
				timeoutSentQuery = 0
				lib.StorePage()
			elseif canSend and timeoutSentQuery > 75 then
				-- Fix for AUCTION_ITEM_LIST_UPDATE sometimes not being sent by server after Legion
				-- In this case Serve has updated CanSendAuctionQuery, it may have sent info, so we'll try to store page
				-- Note longer timeout: AUCTION_ITEM_LIST_UPDATE is the important event, CanSendAuctionQuery is a backup
				timeoutSentQuery = 0
				lib.StorePage()
			elseif timeoutSentQuery > 180 then
				-- Neither CanSendAuctionQuery nor AUCTION_ITEM_LIST_UPDATE have occurred and we have waited a long time
				timeoutSentQuery = 0
				private.ResetAll()
				message("Auctioneer: Scan failed, Server is not responding")
			else
				timeoutSentQuery = timeoutSentQuery + dur
			end
 		end
	elseif private.curQuery then
		lib.Interrupt()
	end
end
private.updater = CreateFrame("Frame", nil, UIParent)
private.updater:SetScript("OnUpdate", private.OnUpdate)

function lib.Cancel()
	if (private.curQuery) then
		aucPrint("Cancelling current scan")
		private.Commit(true, false, false)
	end
	private.ResetAll()
end

function lib.Interrupt()
	if private.curQuery and not _G.AuctionFrame:IsVisible() then
		if private.isGetAll then
			-- GetAll cannot be pushed/popped so we have to commit here instead
			private.Commit(true, false, true)
			private.sentQuery = false
			if private.isGetAll then
				-- If the StorePage function didn't run, we need to cleanup here instead
				lib.ProgressBars("GetAllProgressBar", nil, false)
				BrowseSearchButton:Show()
				AucAdvanced.API.BlockUpdate(false)
				private.isGetAll = nil
			end
		elseif private.isScanning then
			private.unexpectedClose = true
			lib.PushScan()
		else
			private.Commit(true, false, false)
			private.sentQuery = false
		end
	end
end

function lib.Abort()
	if (private.curQuery) then
		aucPrint("Aborting current scan")
	end
	private.ResetAll()
end

function private.ResetAll()
	private.StopStorePage(true)

	-- Fallback in case private.isGetAll and related actions were not cleared during processing
	lib.ProgressBars("GetAllProgressBar", nil, false)
	BrowseSearchButton:Show()
	AucAdvanced.API.BlockUpdate(false)
	private.isGetAll = nil

	local oldquery = private.curQuery
	private.curQuery = nil
	private.curScan = nil
	private.isPaused = nil
	private.sentQuery = nil
	private.isScanning = false
	private.unexpectedClose = false

	private.UpdateScanProgress(false, nil, nil, nil, nil, nil, oldquery)
	if CommitRunning then
		return
	end
	private.scanStartTime = nil
	private.scanStarted = nil
	private.totalPaused = nil
	private.storeTime = nil
	private.curPages = nil
	private.scanStack = nil

	private.Pausing = nil
end

-- In the absence of a proper API function to do it, it's necessary to inspect an item's tooltip to
-- figure out if it's usable by the player
local ItemUsableTooltip = {
	tooltipFrame = nil,
	fontString = {},
	maxLines = 100,

	CanUse = function(this, link)
		-- quick level check first
		local minLevel = select(5, GetItemInfo(link)) or 0
		if UnitLevel("player") < minLevel then
			return false
		end

		-- set up if not done already
		if not this.tooltipFrame then
			this.tooltipFrame = CreateFrame("GameTooltip")
			this.tooltipFrame:SetOwner(UIParent, "ANCHOR_NONE")
			for i = 1, this.maxLines do
				this.fontString[i] = {}
				for j = 1, 2 do
					this.fontString[i][j] = this.tooltipFrame:CreateFontString()
					this.fontString[i][j]:SetFontObject(GameFontNormal)
				end
				this.tooltipFrame:AddFontStrings(this.fontString[i][1], this.fontString[i][2])
			end
			this.minLevelPattern = string.gsub(ITEM_MIN_LEVEL, "(%%d)", "(.+)")
		end

		-- clear tooltip
		local numLines
		numLines = math.min(this.maxLines, this.tooltipFrame:NumLines())
		for i = 1, numLines do
			for j = 1, 2 do
				this.fontString[i][j]:SetText()
				this.fontString[i][j]:SetTextColor(0, 0, 0)
			end
		end

		-- populate tooltip
		this.tooltipFrame:SetHyperlink(link)

		-- search tooltip for red text
		numLines = math.min(this.maxLines, this.tooltipFrame:NumLines())
		for i = 1, numLines do
			for j = 1, 2 do
				local r, g, b = this.fontString[i][j]:GetTextColor()
				if r > 0.8 and g < 0.2 and b < 0.2 then
					-- item is not usable, with one exception: if it doesn't have a level
					-- requirement, red "requires level xxx" text refers to some other item,
					-- e.g. that created by a recipe
					local text = string.lower(this.fontString[i][j]:GetText())
					if not (minLevel == 0 and string.find(text, this.minLevelPattern)) then
						return false
					end
				end
			end
		end

		return true
	end,
}

-- Caching wrapper for ItemUsableTooltip. Invalidates cache when certain events occur
-- (player levels up, learns a new recipe, etc.)
local ItemUsableCached = {
	eventFrame = nil,
	patterns = {},
	cache = {},
	tooltip = ItemUsableTooltip,

	OnEvent = function(this, event, arg1, ...)
		local dirty = false
		-- print("got event " .. event .. ", arg1 " .. arg1)
		if event == "CHAT_MSG_SYSTEM" or event == "CHAT_MSG_SKILL" then
			for _, pattern in pairs(this.patterns) do
				if string.find(arg1, pattern) then
					dirty = true
					break
				end
			end
		elseif event == "PLAYER_LEVEL_UP" then
			dirty = true
		end

		if dirty then
			-- print("invalidating")
			this.cache = {}
		end
	end,

	RegisterChatString = function(this, chatString)
		local pattern = chatString
		pattern = gsub(pattern, "%%s", ".+")
		pattern = gsub(pattern, "%%d", ".+")
		pattern = gsub(pattern, "%%%d+%$s", ".+")
		pattern = gsub(pattern, "%%%d+%$d", ".+")
		pattern = gsub(pattern, "|3%-%d+%(%%s%)", ".+")
		tinsert(this.patterns, pattern)
	end,

	CanUse = function(this, link)
		-- set up if not done already
		if not this.eventFrame then
			this.eventFrame = CreateFrame("Frame")

			-- forward events from frame to self
			this.eventFrame.forwardEventsTo = this
			this.eventFrame:SetScript(
				"OnEvent",
				function(eventFrame, ...)
					eventFrame.forwardEventsTo:OnEvent(...)
				end)

			-- register events and chat patterns
			this.eventFrame:RegisterEvent("CHAT_MSG_SYSTEM")
			this.eventFrame:RegisterEvent("CHAT_MSG_SKILL")
			this.eventFrame:RegisterEvent("PLAYER_LEVEL_UP")

			this:RegisterChatString(_G.ERR_LEARN_ABILITY_S)
			this:RegisterChatString(_G.ERR_LEARN_RECIPE_S)
			this:RegisterChatString(_G.ERR_LEARN_SPELL_S)
			this:RegisterChatString(_G.ERR_SPELL_UNLEARNED_S)
			this:RegisterChatString(_G.ERR_SKILL_GAINED_S)
			this:RegisterChatString(_G.ERR_SKILL_UP_SI)
		end

		local linkType, id = strsplit(":", link)
		linkType = linkType:sub(-4) -- get last 4 characters
		if linkType == "epet" then
			-- battlepet : assume anyone can use it
			-- todo: do we need to check if user has enabled battlepets?
			-- I think you can still "use" the Pet Cage to learn the pet, even if you haven't enabled battlepets yet
			-- todo: what if the user has reached the max pet limit?
			return true
		elseif linkType ~= "item" then
			return
		end
		id = tonumber(id)
		if not id then return end

		-- check cache first. failing that, do a tooltip scan
		if this.cache[id] == nil then
			-- print("miss " .. link)
			this.cache[id] = this.tooltip:CanUse(link)
		else
			-- print("hit  " .. link)
		end

		return this.cache[id]
	end,
}

private.itemUsable = ItemUsableCached
function private.CanUse(link)
	return private.itemUsable:CanUse(link)
end

function lib.GetScanCount()
	local scanCount = 0
	if (private.scanStack) then scanCount = #private.scanStack end
	if (private.isScanning) then
		scanCount = scanCount + 1
	end
	return scanCount
end

function lib.GetStackedScanCount()
	local scanCount = 0
	if (private.scanStack) then scanCount = #private.scanStack end
	return scanCount
end

function coremodule.OnUnload()
	if (private.curQuery) then
		private.Commit(true, false, false)
	end
	if CoCommit then
		while coroutine.status(CoCommit) == "suspended" do
			CoroutineResume(CoCommit)
		end
	end
end

coremodule.Processors = {}
function coremodule.Processors.auctionui()
	private.Hook.AuctionFrameBrowse_Search = AuctionFrameBrowse_Search
	function AuctionFrameBrowse_Search()
		private.isBlizzardQuery = true
		private.Hook.AuctionFrameBrowse_Search()
		private.isBlizzardQuery = nil
	end
end

function coremodule.Processors.scanstats(event, scanstats)
	private.clearImageCaches(event, scanstats)
end

function coremodule.Processors.auctionclose(event)
	-- clearup memory usage when AH closed
	--if not get("core.scan.keepinfocacheonclose") then -- ### setting temporarily disabled as not supported by LibAucItemCache
		private.ResetItemInfoCache()
	--end
	--[[ ### debug start
	local performance = AucAdvanced.Libraries.TipHelper.AIC_GetPerformance(true) -- get performance string
	if performance then debugPrint(performance) end
	-- ### debug end ]]
	private.clearImageCaches(event)
	lib.Interrupt()
end

function internalScan.NotifyItemListUpdated()
	if private.scanStarted then
		private.auctionItemListUpdated = true
		--[[ commented out for now - this gets really spammy
		if (_G.nLog) then
			local startTime = GetTime()
			_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, ("NotifyItemListUpdated Called %fs after Query Start"):format(startTime - private.scanStarted), ("NotifyItemListUpdated Called %f seconds from query to be called"):format(startTime - private.scanStarted))
		end
		--]]
	end
end

function internalScan.NotifyOwnedListUpdated()
--	if private.scanStarted then
--		if (_G.nLog) then
--			local startTime = GetTime()
--			_G.nLog.AddMessage("Auctioneer", "Scan", _G.N_INFO, ("NotifyOwnedListUpdated Called %fs after Query Start"):format(startTime - private.scanStarted), ("NotifyOwnedListUpdated Called %f seconds from query to be called"):format(startTime - private.scanStarted))
--		end
--	end
end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/CoreScan.lua $", "$Rev: 6420 $")
AucAdvanced.CoreFileCheckOut("CoreScan")
