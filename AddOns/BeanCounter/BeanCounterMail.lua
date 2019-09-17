--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: 8.2.6422 (SwimmingSeadragon)
	Revision: $Id: BeanCounterMail.lua 6422 2019-09-13 05:07:31Z none $
	URL: http://auctioneeraddon.com/

	BeanCounterMail - Handles recording of all auction house related mail

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
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
LibStub("LibRevision"):Set("$URL: BeanCounter/BeanCounterMail.lua $","$Rev: 6422 $","5.1.DEV.", 'auctioneer', 'libs')

local lib = BeanCounter
local private, print, get, set, _BC = lib.getLocals() --_BC localization function

local _G = _G
local pairs,ipairs,select,type,next = pairs,ipairs,select,type,next
local tonumber,tostring,format = tonumber,tostring,format
local tinsert,tremove = tinsert,tremove
local strsplit,strfind,strbyte = strsplit,strfind,strbyte
local time = time
local GetTime = GetTime
local floor = floor
local bitand = bit.band


local function debugPrint(...)
    if get("util.beancounter.debugMail") then
        private.debugPrint("BeanCounterMail",...)
    end
end

local expiredLocale = AUCTION_EXPIRED_MAIL_SUBJECT:gsub("%%s", "") --remove the %s
local salePendingLocale = AUCTION_INVOICE_MAIL_SUBJECT:gsub("%%s", "") --sale pending
local outbidLocale = AUCTION_OUTBID_MAIL_SUBJECT:gsub("%%s", "(.+)")
local cancelledLocale = AUCTION_REMOVED_MAIL_SUBJECT:gsub("%%s", "")
local successLocale = AUCTION_SOLD_MAIL_SUBJECT:gsub("%%s", "")
local wonLocale = AUCTION_WON_MAIL_SUBJECT:gsub("%%s", "")
local retrievingData = RETRIEVING_DATA

local reportTotalMail, reportReadMail = 0, 0 --Used as a debug check on mail scanning engine

-- usage: factionEncode[private.playerSettings.faction]
local factionEncode = {
	Alliance = "A",
	Horde = "H",
}

local senderAuctionHouse
function private.isAuctionHouseMail(sender, subject)
	if not sender or sender == "" then return end

	if not senderAuctionHouse then
		senderAuctionHouse = {}
		senderAuctionHouse[_BC('MailSenderAuctionHouse')] = true -- from BeanCounterStrings.lua
		if BUTTON_LAG_AUCTIONHOUSE then -- from GlobalStrings.lua: looks like this may be a viable localized string for "Auction House"?
			senderAuctionHouse[BUTTON_LAG_AUCTIONHOUSE] = true
		end
		if BeanCounterMailPatch then -- recorded value(s) from known AH mail
			for _, s in ipairs(BeanCounterMailPatch) do
				senderAuctionHouse[s] = true
			end
		end
	end
	if senderAuctionHouse[sender] then
		return true
	end

	-- try to 'learn' Auction House sender localized name by inspecting subject
	-- temporary fix - this is slow and will trigger for every non-AH mail
	-- also, potentially prone to accidental matches?
	if subject and subject ~= "" and subject ~= retrievingData then
		if subject:match(expiredLocale) or subject:match(outbidLocale) or subject:match(successLocale) or subject:match(wonLocale) or subject:match(cancelledLocale) then
			if not BeanCounterMailPatch then
				BeanCounterMailPatch = {}
			end
			tinsert(BeanCounterMailPatch, sender)
			senderAuctionHouse[sender] = true

			return true
		end
	end
end

local registeredInboxFrameHook = false
function private.mailMonitor(event,arg1)
	if (event == "MAIL_INBOX_UPDATE") then
		-- Throttle calls to private.updateInboxStart as we now get large numbers of MAIL_INBOX_UPDATE at the same time
		if not private.limitMailUpdateEvent then
			private.limitMailUpdateEvent = true
			C_Timer.After(0.1, private.updateInboxStart) -- ### todo: experiment with delay length
		end

	elseif (event == "MAIL_SHOW") then
		private.inboxStart = {} --clear the inbox list, if we errored out this should give us a fresh start.
		private.mailReadOveride = {}
		private.lastSkipString = nil
		if not registeredInboxFrameHook then --make sure we only ever register this hook once
			registeredInboxFrameHook = true
			hooksecurefunc("InboxFrame_OnClick", private.mailFrameClick)
			hooksecurefunc("InboxFrame_Update", private.mailFrameUpdate)
		end
		--We cannot use mail show since the GetInboxNumItems() returns 0 till the first "MAIL_INBOX_UPDATE"

	elseif (event == "MAIL_CLOSED") then
		private.HideMailGUI()
		private.sumDatabase() --Sum total fo DB for the display on browse pane
	end
end

--[[Watch who reads the mail. and what they read. Use this to play nicely with altaholic and other addons]]
private.mailReadOveride = {}
function private.PreGetInboxTextHook(n, ...)
	if n and n > 0 then
		local _, _, sender, subject, money, _, daysLeft, _, wasRead, _, _, _ = GetInboxHeaderInfo(n)
		if not wasRead then
			private.mailReadOveride[n] = true
		end
	end
	return private.GetInboxText(n, ...)
end
--hook and replace GetInboxText()
private.GetInboxText = GetInboxText
GetInboxText = private.PreGetInboxTextHook

--New function to hide/unhide mail GUI.
local HideMailGUI
function private.HideMailGUI( hide )
	if hide then
		HideMailGUI = true
		MailFrameCloseButton:Hide()
		InboxFrame:Hide()
		MailFrameTab2:Hide()
		private.MailGUI:Show()
		private.wipeSearchCache() --clear the search cache, we are updating data so it is now outdated
	else
		HideMailGUI = false
		MailFrameCloseButton:Show()
		InboxFrame:Show()
		MailFrameTab2:Show()
		private.MailGUI:Hide()
		private.wipeSearchCache() --clear the search cache, we are updating data so it is now outdated
	end
end
--Mailbox Snapshots
function private.updateInboxStart()
	private.limitMailUpdateEvent = nil
	reportTotalMail = GetInboxNumItems()
	local skipString
	for n = reportTotalMail, 1, -1 do
		local _, _, sender, subject, money, _, daysLeft, _, wasRead, _, _, _ = GetInboxHeaderInfo(n)
		if not subject or subject == "" or subject == retrievingData then
			-- mail info is incomplete, will be retried
			if not skipString then
				skipString = tostring(n)
			else
				skipString = tostring(n) .. "," .. skipString
			end
		elseif not wasRead or private.mailReadOveride[n] then
			if private.isAuctionHouseMail(sender, subject) then
				private.HideMailGUI(true)
				wasRead = wasRead and 1 or 0 -- three possible states 0=unread 1=read by addon 2=read by player
				private.mailReadOveride[n] = false -- set back to false so we don't read the same message more than once
				local itemLink = GetInboxItemLink(n, 1) -- We only check the 1st attachment, as AH mail should never have more than 1
				local _, _, _, stack = GetInboxItem(n, 1)
				local invoiceType, itemName, playerName, bid, buyout, deposit, consignment, retrieved, startTime = private.getInvoice(n,sender, subject)
				--subject now can contain a stack size. Remove them so only itemName remains
				subject = subject:gsub("%s-%(%d-%)", "") --strips off the count (x) from the itemName
				tinsert(private.inboxStart, {["n"] = n, ["sender"]=sender, ["subject"]=subject,["money"]=money, ["read"]=wasRead, ["age"] = daysLeft,
						["invoiceType"] = invoiceType, ["itemName"] = itemName, ["Seller/buyer"] = playerName, ['bid'] = bid, ["buyout"] = buyout,
						["deposit"] = deposit, ["fee"] = consignment, ["retrieved"] = retrieved, ["startTime"] = startTime, ["itemLink"] = itemLink,
						["stack"] = stack, ["auctionHouse"] = factionEncode[private.playerSettings.faction],
						})
				private.GetInboxText(n) --read message
				reportReadMail = reportReadMail + 1
			end
		end
		private.lastCheckedMail = GetTime() --this keeps us from hiding the mail UI too early and causing flicker
	end
	if skipString and skipString ~= private.lastSkipString then
		debugPrint("Skipping mail #", skipString, "The server is not sending the subject data. Mail will be left unread and we will retry")
		private.lastSkipString = skipString
	end
	private.wipeSearchCache() --clear the search cache, we are updating data so it is now outdated
end
function private.getInvoice(n, sender, subject)
	if private.isAuctionHouseMail(sender, subject) then
		if subject:match(successLocale) or subject:match(wonLocale) then
			local invoiceType, itemName, playerName, bid, buyout, deposit, consignment = GetInboxInvoiceInfo(n)
			if invoiceType and playerName and playerName ~= "" and bid and bid > 0 then --Silly name throttling lead to missed invoice lookups
				--debugPrint("getInvoice", invoiceType, itemName, playerName, bid, buyout, deposit, consignment, "yes")
				return invoiceType, itemName, playerName, bid, buyout, deposit, consignment, "yes", time()
			else
				--debugPrint("getInvoice", invoiceType, itemName, playerName, bid, buyout, deposit, consignment, "no")
				return invoiceType, itemName, playerName, bid, buyout, deposit, consignment, "no", time()
			end
		end
	end
	return
end

private.lastCheckedMail = GetTime()
function private.mailonUpdate()
	local total = #private.inboxStart
	if total > 0 then
		for i = total, 1, -1 do
			--update mail GUI Count
			local count = #private.inboxStart
			--private.CountGUI:SetText("Recording: "..total-count.." of "..total.." items")
			private.CountGUI:SetText("Recording: "..reportReadMail.." items, Please wait")--not happy, would like a better count
			local data = private.inboxStart[i]
			if not data.retrieved then --Send non invoiceable mails through
				tinsert(private.reconcilePending, data)
				--private.inboxStart[i] = nil
				tremove(private.inboxStart, i)
				--debugPrint("not a invoice mail type", i)

			elseif  data.retrieved == "failed" then
				tinsert(private.reconcilePending, data)
				--private.inboxStart[i] = nil
				tremove(private.inboxStart, i)
				--debugPrint("data.retrieved == failed", i)

			elseif  data.retrieved == "yes" then
				tinsert(private.reconcilePending, data)
				--private.inboxStart[i] = nil
				tremove(private.inboxStart, i)
				--debugPrint("data.retrieved == yes", i)

			elseif  time() - data.startTime > get("util.beacounter.invoicetime") then --time exceded so fail it and process on next update
				debugPrint("time to retrieve invoice exceeded, most likely waiting on players name if this is blank>..", data["Seller/buyer"], i)
				data["retrieved"] = "failed" --time to get invoice exceded
			else
				--debugPrint("Invoice retieve attempt",data["subject"])
				data["invoiceType"], data["itemName"], data["Seller/buyer"], data['bid'], data["buyout"] , data["deposit"] , data["fee"], data["retrieved"], _ = private.getInvoice(data.n, data.sender, data.subject)
			end
		end
	end
	if (#private.inboxStart == 0) and (HideMailGUI == true) and (private.lastCheckedMail + 1 < GetTime() ) then --time delay added to prevent possible flicker
		debugPrint("Total Mail in inbox:{{", reportTotalMail, "}}Reading:{{",reportReadMail, "}}new AH mails")
		reportTotalMail, reportReadMail = 0, 0
		private.HideMailGUI( )
		private.mailBoxColorStart() --delay recolor system till we have had a chance to read the mail
	end

	if (#private.reconcilePending > 0) then
		private.mailSort()
	end
end

function private.mailSort()
	for i = #private.reconcilePending, 1, -1 do
		--Get Age of message for timestamp
		local messageAgeInSeconds = floor((30 - private.reconcilePending[i]["age"]) * 24 * 60 * 60)
		private.reconcilePending[i]["time"] = (time() - messageAgeInSeconds)

		if private.isAuctionHouseMail(private.reconcilePending[i].sender, private.reconcilePending[i].subject) then
			if private.reconcilePending[i].subject:match(successLocale) and (private.reconcilePending[i].retrieved == "yes" or private.reconcilePending[i].retrieved == "failed") then
				private.sortCompletedAuctions( i )

			elseif private.reconcilePending[i].subject:match(expiredLocale)then
				private.sortFailedAuctions( i )

			elseif private.reconcilePending[i].subject:match(wonLocale) and (private.reconcilePending[i].retrieved == "yes" or private.reconcilePending[i].retrieved == "failed") then
				private.sortCompletedBidsBuyouts( i )

			elseif private.reconcilePending[i].subject:match(outbidLocale) then
				private.sortFailedBids( i )

			elseif private.reconcilePending[i].subject:match(cancelledLocale) then
				private.sortCancelledAuctions( i )

			elseif private.reconcilePending[i].subject:match(salePendingLocale) then
				--ignore We dont care about this message
				tremove(private.reconcilePending,i)
			else
				debugPrint("We had an Auction mail that failed mailsort(). Subject:", private.reconcilePending[i].subject, "at index", i)
				tremove(private.reconcilePending,i)
			end
		else --if its not AH do we care? We need to record cash arrival from other toons
			debugPrint("OTHER", private.reconcilePending[i].subject)
			tremove(private.reconcilePending, i)

		end
	end
end

--retrieves the itemID from the DB
function private.matchDB(text, itemKey)
	local itemID
	for itemKey, data in next, BeanCounterDBNames, itemKey do
		local _, name = strsplit(";", data)
		if text == name then
			itemID = string.split(":", itemKey)
			local itemLink = lib.API.createItemLinkFromArray(itemKey)
			--debugPrint("|CFFFFFF00Searching",data,"for",text,"Success: link is",itemLink, "itemID is ", itemID)
			return itemID, itemLink, itemKey
		end
	end
	debugPrint("Searching DB for ItemID..", text, "Failed Item does not exist in the name array")
	return nil
end

-- private.getSuffixHelper : used to match suffixed items when the uniqueId gets mangled by the Mail API
-- param: itemString or itemLink
-- returns: suffix (string), uniqueId (string), cleanedUniqueId (number : low 16 bits nilled)
--   note: cleanedUniqueId must only be compared against another cleanedUniqueId
-- or returns all nil for a non-suffixed item
function private.getSuffixHelper(itemString)
	local _, _, _, _, _, _, _, suffix, strUniqueId = strsplit(":", itemString)
	if strbyte(suffix, 1) == 45 then -- '-' character, it's a negative suffix
		local numUniqueId = tonumber(strUniqueId)
		if numUniqueId then
			return suffix, strUniqueId, bitand(numUniqueId, 0xffff0000)
		end
	end
end

function private.sortCompletedAuctions( i )
	--Get itemID from database
	local itemName = private.reconcilePending[i].subject:match(successLocale.."(.*)")
	local itemID, itemLink, itemKey

	while true do
		itemID, itemLink, itemKey = private.matchDB(itemName, itemKey)
		if itemID then
			--Get the Bid,stack size, and a proper itemString
			local stack, bid, itemString = private.findStackcompletedAuctions("postedAuctions", itemID, itemLink, private.reconcilePending[i].deposit, private.reconcilePending[i]["buyout"], private.reconcilePending[i]["time"])
			if stack then
				local value = private.packString(stack, private.reconcilePending[i]["money"], private.reconcilePending[i]["deposit"], private.reconcilePending[i]["fee"], private.reconcilePending[i]["buyout"], bid, private.reconcilePending[i]["Seller/buyer"], private.reconcilePending[i]["time"], "", private.reconcilePending[i]["auctionHouse"])
				if private.reconcilePending[i]["auctionHouse"] == "A" or private.reconcilePending[i]["auctionHouse"] == "H" then
					private.databaseAdd("completedAuctions", nil, itemString, value)
					--debugPrint("databaseAdd completedAuctions", itemID, itemLink)
				else
					private.databaseAdd("completedAuctionsNeutral", nil, itemString, value)
				end
				break
			end
		else
			debugPrint("Failure for completedAuctions", itemID, itemLink, "index", private.reconcilePending[i].n)
			break
		end
		--debugPrint("sortCompletedAuctions: Trying to find another match for", itemName)
	end
	tremove(private.reconcilePending, i)
end

--Find the stack information in postedAuctions to add into the completedAuctions DB on mail arrivial
function private.findStackcompletedAuctions(key, itemID, itemLink, soldDeposit, soldBuy, soldTime)
	if not private.playerData[key][itemID] then return end --if no keys present abort
	local soldDeposit, soldBuy, soldTime ,oldestPossible = tonumber(soldDeposit), tonumber(soldBuy), tonumber(soldTime), tonumber(soldTime - 208800) --58H 15min oldest we will go back
	local DBitemID, DBSuffix = lib.API.decodeLink(itemLink)
	for itemString,v in pairs (private.playerData[key][itemID]) do
		local SearchID, SearchSuffix = lib.API.decodeLink(itemString)
		if SearchID == DBitemID and  SearchSuffix == DBSuffix then
			for index, text in pairs(v) do
				if not text:match(".*USED.*") then
					local postStack, postBid, postBuy, postRunTime, postDeposit, postTime, postReason = strsplit(";", private.playerData[key][itemID][itemString][index])
					postDeposit, postBuy, postBid, postTime = tonumber(postDeposit) or 0, tonumber(postBuy) or 0, tonumber(postBid) or 0, tonumber(postTime) or 0
					--if the deposits and buyouts match, check if time range would make this a possible match
					if postDeposit == soldDeposit and (not postBuy or postBuy >= soldBuy) and postBid <= soldBuy then --We may have sold it on a bid so we need to loosen this search
						if (soldTime > postTime) and (oldestPossible < postTime) then
							tremove(private.playerData[key][itemID][itemString], index) --remove the matched item From postedAuctions DB
							--private.playerData[key][itemID][itemString][index] = private.playerData[key][itemID][itemString][index]..";USED Sold"
							--debugPrint("postedAuction removed as sold", itemID, itemLink, itemString)
							return tonumber(postStack) or 0, postBid, itemString   --itemString is the "real" itemlink
						end
					end
				end
			end
		end
	end
	--return 1 if the item is nonstackable and no match was found
	if private.getItemInfo(itemID, "stack") == 1 then return 1 end
end

-- Failed (expired) auctions
function private.sortFailedAuctions(i)
	private.sortReturnedAuctions(i, private.checkStackFailedAuctions, "failedAuctions", "")
end
function private.checkStackFailedAuctions(datalist, returnedStack, expiredTime)
	for index = #datalist, 1, -1 do -- check entries from oldest to newest
		local postStack, postBid, postBuy, postRunTime, postDeposit, postTime, postReason = strsplit(";", datalist[index])
        postStack, postDeposit, postBuy, postBid, postTime = tonumber(postStack) or 0, tonumber(postDeposit) or 0, tonumber(postBuy) or 0, tonumber(postBid) or 0, tonumber(postTime) or 0
        postRunTime = tonumber(postRunTime) or 0
		if returnedStack == postStack then --stacks same see if we can match time
			local timeAuctionPosted, timeFailedAuctionStarted = postTime, expiredTime - postRunTime * 60 --Earliest time we could have posted the auction
			if (timeAuctionPosted - 21600) <= timeFailedAuctionStarted and timeFailedAuctionStarted <= (timeAuctionPosted + 21600) then
				tremove(datalist, index) --remove the matched item From postedAuctions DB
				return postStack, postBid, postBuy, postDeposit
			end
		end
	end
end

-- Cancelled auctions recorded as failed auctions with just cancelled added as the reason tag.
function private.sortCancelledAuctions(i)
	private.sortReturnedAuctions(i, private.checkStackCancelledAuctions, "cancelledAuctions", _BC('Cancelled'))
end
function private.checkStackCancelledAuctions(datalist, returnedStack, expiredTime)
	for index = #datalist, 1, -1 do -- check entries from oldest to newest
		local postStack, postBid, postBuy, postRunTime, postDeposit, postTime, postReason = strsplit(";", datalist[index])
        postStack, postDeposit, postBuy, postBid, postTime = tonumber(postStack) or 0, tonumber(postDeposit) or 0, tonumber(postBuy) or 0, tonumber(postBid) or 0, tonumber(postTime) or 0
        postRunTime = tonumber(postRunTime) or 0
		if returnedStack == postStack then --stacks same see if we can match time
			local timeAuctionPosted, timeCancelledAuctionStarted = postTime, expiredTime - postRunTime * 60 --Earliest time we could have posted the auction
			if (timeAuctionPosted - 21600) > (timeCancelledAuctionStarted) then --cancelled auctions could have just been posted so no way to age check beyond oldest possible
				tremove(datalist, index) --remove the matched item From postedAuctions DB
				return postStack, postBid, postBuy, postDeposit
			end
		end
	end
end

-- Combined sort function for Returned auctions: handles failed (expired) and cancelled
-- Additional parameters are used to handle the minor differences
function private.sortReturnedAuctions(i, checkfunc, display, reason)
	local mailPending = private.reconcilePending[i]
	local mailItemLink = mailPending.itemLink
	local itemID =  lib.API.decodeLink(mailItemLink)
	if itemID then
		local stack, bid, buyout, deposit, itemString = private.findStackReturnedAuctions(checkfunc, itemID, mailItemLink, mailPending.stack, mailPending.time)
		if stack then
			local mailAuctionHouse = mailPending.auctionHouse
			local value = private.packString(stack, "", deposit , "", buyout, bid, "", mailPending.time, reason, mailAuctionHouse)
			if mailAuctionHouse == "A" or mailAuctionHouse == "H" then
				private.databaseAdd("failedAuctions", nil, itemString, value)
			else
				private.databaseAdd("failedAuctionsNeutral", nil, itemString, value)
			end
			--debugPrint("Success for", display, itemID, mailItemLink, "index", mailPending.n)
		else
			debugPrint("Failure for", display, itemID, mailItemLink, "index", mailPending.n)
		end
	end
	tremove(private.reconcilePending, i)
end

-- Find database info for returned auctions : either failed (expired) or cancelled
function private.findStackReturnedAuctions(checkfunc, itemID, itemLink, returnedStack, expiredTime)
	local dataItemBase = private.playerData.postedAuctions[itemID]
	if not dataItemBase then return end
	local mailItemString = lib.API.getItemString(itemLink) -- entries in database are keyed by itemString

	-- see if there is an exact match
	local datalist = dataItemBase[mailItemString]
	if datalist then
		local postStack, postBid, postBuy, postDeposit = checkfunc(datalist, returnedStack, expiredTime)
		if postStack then
			return postStack, postBid, postBuy, postDeposit, mailItemString
		end
	end

	-- no exact matches, keep looking for a fuzzy match
	local mailSuffix, mailUniqueId, mailCleanId = private.getSuffixHelper(mailItemString)
	local mailAdjustedString
	if mailSuffix then
		mailAdjustedString = mailItemString:gsub(mailUniqueId, mailCleanId)
	end

	for dbItemString, datalist in pairs(dataItemBase) do
		if dbItemString ~= mailItemString then -- we've already tested that case above so don't test it again

			if strfind(mailItemString, dbItemString, 1, true) then
				-- mailItemString contains dbItemString, most likely due to change in itemString format after a patch
				local postStack, postBid, postBuy, postDeposit = checkfunc(datalist, returnedStack, expiredTime)
				if postStack then
					return postStack, postBid, postBuy, postDeposit, mailItemString
				end
			end

			if mailSuffix then
				-- suffixed item; for some items the uniqueId gets mangled by the Mail API
				local dbSuffix, dbUniqueId, dbCleanId = private.getSuffixHelper(dbItemString)
				if mailSuffix == dbSuffix and mailCleanId == dbCleanId then
					local dbAdjustedString = dbItemString:gsub(dbUniqueId, dbCleanId)
					if mailAdjustedString == dbAdjustedString or strfind(mailAdjustedString, dbAdjustedString, 1, true) then
						local postStack, postBid, postBuy, postDeposit = checkfunc(datalist, returnedStack, expiredTime)
						if postStack then
							-- mailItemString is mangled, determine the correct itemString
							local correctItemString
							if mailAdjustedString == dbAdjustedString then
								correctItemString = dbItemString
							else
								-- dbItemString is not correct, most likely due to change in itemString format after a patch
								-- dbUniqueId is the correct uniqueId, mailUniqueId is mangled
								local item, itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4, suffixID, uniqueID, tail = strsplit(":", mailItemString, 10)
								correctItemString = strjoin(":", item, itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4, suffixID, dbUniqueId, tail)
							end
							return postStack, postBid, postBuy, postDeposit, correctItemString
						end
					end
				end
			end
		end
	end
end

-- Most data for won bids/buyouts should be provided in the invoice. We still need to reconcile postedBids entries
function private.sortCompletedBidsBuyouts( i )
	local mailPending = private.reconcilePending[i]
	local mailItemLink = mailPending.itemLink
	local itemID = lib.API.decodeLink(mailItemLink)
	if itemID then
		local reason, itemString = private.findCompletedBids(itemID, mailPending.bid, mailItemLink)
		if not itemString then
			debugPrint("No postedBids entry for completedBidsBuyouts", itemID, mailItemLink, "index", mailPending.n)
			itemString = lib.API.getItemString(mailItemLink)
		end
		local auctionHouse = mailPending.auctionHouse
		--For a Won Auction money, deposit, fee are always 0  so we can use them as placeholders for BeanCounter Data
		local value = private.packString(mailPending.stack, mailPending.money, nil, mailPending.fee, mailPending.buyout, mailPending.bid, mailPending["Seller/buyer"], mailPending.time, reason, auctionHouse)
		if auctionHouse == "A" or auctionHouse == "H" then
			private.databaseAdd("completedBidsBuyouts", nil, itemString, value)
		else
			private.databaseAdd("completedBidsBuyoutsNeutral", nil, itemString, value)
		end
		--debugPrint("databaseAdd completedBidsBuyouts", itemID, mailItemLink)
	else
		debugPrint("Failure for completedBidsBuyouts", mailItemLink, "index", mailPending.n)
	end

	tremove(private.reconcilePending,i)
end
-- Clear postedBid entries, return reason (if any)
function private.findCompletedBids(itemID, bid, itemLink)
	local dataItemBase = private.playerData.postedBids[itemID]
	if not dataItemBase then return end
	local mailItemString = lib.API.getItemString(itemLink) -- entries in database are keyed by itemString
	bid = tonumber(bid) or 0

	-- see if there is an exact match
	local datalist = dataItemBase[mailItemString]
	if datalist then
		local reason = private.checkCompletedBidsBuyouts(datalist, bid)
		if reason then
			return reason, mailItemString
		end
	end

	-- no exact matches, keep looking for a fuzzy match
	local mailSuffix, mailUniqueId, mailCleanId = private.getSuffixHelper(mailItemString)
	local mailAdjustedString
	if mailSuffix then
		mailAdjustedString = mailItemString:gsub(mailUniqueId, mailCleanId)
	end

	for dbItemString, datalist in pairs(dataItemBase) do
		if dbItemString ~= mailItemString then -- we've already tested that case above so don't test it again

			if strfind(mailItemString, dbItemString, 1, true) then
				-- mailItemString contains dbItemString, most likely due to change in itemString format after a patch
				local reason = private.checkCompletedBidsBuyouts(datalist, bid)
				if reason then
					return reason, mailItemString
				end
			end

			if mailSuffix then
				-- suffixed item; for some items the uniqueId gets mangled by the Mail API
				local dbSuffix, dbUniqueId, dbCleanId = private.getSuffixHelper(dbItemString)
				if mailSuffix == dbSuffix and mailCleanId == dbCleanId then
					local dbAdjustedString = dbItemString:gsub(dbUniqueId, dbCleanId)
					if mailAdjustedString == dbAdjustedString or strfind(mailAdjustedString, dbAdjustedString, 1, true) then
						local reason = private.checkCompletedBidsBuyouts(datalist, bid)
						if reason then
							-- mailItemString is mangled, determine the correct itemString
							local correctItemString
							if mailAdjustedString == dbAdjustedString then
								correctItemString = dbItemString
							else
								-- dbItemString is not correct, most likely due to change in itemString format after a patch
								-- dbUniqueId is the correct uniqueId, mailUniqueId is mangled
								local item, itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4, suffixID, uniqueID, tail = strsplit(":", mailItemString, 10)
								correctItemString = strjoin(":", item, itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4, suffixID, dbUniqueId, tail)
							end
							return reason, correctItemString
						end
					end
				end
			end
		end
	end
end
function private.checkCompletedBidsBuyouts(datalist, bid)
	for index = #datalist, 1, -1 do -- check entries from oldest to newest
		local postStack, postBid, postBuy, postRunTime, postDeposit, postTime, postReason = strsplit(";", datalist[index])
        postBid = tonumber(postBid) or 0
		if postBid == bid then
			tremove(datalist, index) --remove the matched item From postedBids DB
			return postReason --return the reason code provided for why we bid/bought item
		end
	end
end

function private.sortFailedBids( i )
	local itemName = private.reconcilePending[i].subject:match(outbidLocale.."(.*)")
	local postStack, postSeller, reason, itemString = private.findFailedBids(itemName, private.reconcilePending[i]["money"])
	if itemString then
		local value = private.packString(postStack, "", "", "", "", private.reconcilePending[i]["money"], postSeller, private.reconcilePending[i]["time"], reason, private.reconcilePending[i]["auctionHouse"])
		if private.reconcilePending[i]["auctionHouse"] == "A" or private.reconcilePending[i]["auctionHouse"] == "H" then
			private.databaseAdd("failedBids", nil, itemString, value)
		else
			private.databaseAdd("failedBidsNeutral", nil, itemString, value)
		end
		--debugPrint("databaseAdd failedBids", value)
	else
		debugPrint("Failure for failedBids", itemName, ", index", private.reconcilePending[i].n)
	end
	tremove(private.reconcilePending,i)
end

function private.findFailedBids(itemName, gold)
	gold = tonumber(gold) or 0
	local itemID, itemLink, itemKey

	while true do
		itemID, itemLink, itemKey = private.matchDB(itemName, itemKey)

		if not itemLink then
			debugPrint("Failed auction ItemStrig nil", itemID, itemLink)
			return
		end

		if not itemID or not private.playerData["postedBids"] then
			debugPrint("Missing critical data for FailedBid lookup.", itemID, private.playerData["postedBids"], private.playerData["postedBids"][itemID])
			return
		end

		if private.playerData["postedBids"][itemID] then
			local DBitemID, DBSuffix = lib.API.decodeLink(itemLink)
			for itemString,v in pairs (private.playerData["postedBids"][itemID]) do
				local SearchID, SearchSuffix = lib.API.decodeLink(itemString)
				if SearchID == DBitemID and SearchSuffix == DBSuffix then
					for index, text in pairs(v) do
						if not text:match(".*USED.*") then
							local postStack, postBid, postSeller, isBuyout, postTimeLeft, postTime, reason = private.unpackString(text)
                            postBid = tonumber(postBid) or 0
                            postStack = tonumber(postStack) or 0
							if postBid == gold then
								tremove(private.playerData["postedBids"][itemID][itemString], index) --remove the matched item From postedBids DB
								--private.playerData["postedBids"][itemID][itemString][index] = private.playerData["postedBids"][itemID][itemString][index] ..";USED FAILED"
								--debugPrint("posted Bid removed as Failed", itemString, index, itemLink)
								return postStack, postSeller, reason, itemString
							end
						end
					end
				end
			end
		end
		--debugPrint("findFailedBids: Trying to find another match for", itemName)
	end
end

--Hook, take money event, if this still has an unretrieved invoice we delay X sec or invoice retrieved
local inboxHookMessage = false --Stops spam of the message.
function private.PreTakeInboxMoneyHook(funcArgs, retVal, index, ignore)
	if #private.inboxStart > 0 or HideMailGUI then
		if not inboxHookMessage then
			print("Please allow BeanCounter time to reconcile the mail box")
			inboxHookMessage = true
		end
		return "abort"
	end
end

--Hook, take item event, if this still has an unretrieved invoice we delay X sec or invoice retrieved
function private.PreTakeInboxItemHook( ignore, retVal, index)
	if #private.inboxStart > 0 or HideMailGUI then
		if not inboxHookMessage then
			print("Please allow BeanCounter time to reconcile the mail box")
			inboxHookMessage = true
		end
		return "abort"
	end
end

--[[
The below code manages the mailboxes Icon color /read/unread status

]]--
function private.mailFrameClick(self, index)
	if private.playerSettings["mailbox"][index] then
		private.playerSettings["mailbox"][index]["read"] = 2
	end
end

local NORMAL_FONT_COLOR, HIGHLIGHT_FONT_COLOR = NORMAL_FONT_COLOR, HIGHLIGHT_FONT_COLOR

function private.mailFrameUpdate()
	--Change Icon back color if only addon read
	local db = private.playerSettings
	if not db["mailbox"] then return end  --we havn't read mail yet
	if get("util.beancounter.mailrecolor") == "off" then return end

	local numItems = GetInboxNumItems()
	local  index
	if (InboxFrame.pageNum * 7) < numItems then
		index = 7
	else
		index = 7 - ((InboxFrame.pageNum * 7) - numItems)
	end
	for i = 1, index do
		local basename=format("MailItem%d",i)
		local button = _G[basename.."Button"]
		local buttonIcon = _G[basename.."ButtonIcon"]
		local senderText = _G[basename.."Sender"]
		local subjectText = _G[basename.."Subject"]
		button:Show()

		local itemindex = ((InboxFrame.pageNum * 7) - 7 + i) --this gives us the actual itemindex as oposed to teh 1-7 button index
		--local _, _, sender, subject, money, _, daysLeft, _, wasRead, _, _, _ = GetInboxHeaderInfo(itemindex)
		if db["mailbox"][itemindex] then
			local sender = db["mailbox"][itemindex]["sender"]
			local subject = db["mailbox"][itemindex]["subject"]
			if private.isAuctionHouseMail(sender, subject) then
				if (db["mailbox"][itemindex]["read"] ~= 2) then
					if get("util.beancounter.mailrecolor") == "icon" or get("util.beancounter.mailrecolor") == "both" then
						_G[basename.."ButtonSlot"]:SetVertexColor(1.0, 0.82, 0)
						SetDesaturation(buttonIcon, nil)
					end
					if get("util.beancounter.mailrecolor") == "text" or get("util.beancounter.mailrecolor") == "both" then
						senderText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
						subjectText:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
					end
				end
			end
		end
	end

end
--CHANGE THIS TO REVERSE ORDER
local mailCurrent
local group = {["n"] = "", ["start"] = 1, ["end"] = 1} --stores the start and end locations for a group of same name items
function private.mailBoxColorStart()
	mailCurrent = {} --clean table every update
	local db=BeanCounterDBSettings[private.realmName][private.playerName]

	for n = 1,GetInboxNumItems() do
		local _, _, sender, subject, money, _, daysLeft, _, wasRead, _, _, _ = GetInboxHeaderInfo(n);
		mailCurrent[n] = {["time"] = daysLeft ,["sender"] = sender, ["subject"] = subject, ["read"] = wasRead and 1 or 0 }
	end

	--Fix reported errors of mail DB not existing for some reason.
	if not db["mailbox"] then db["mailbox"] = {} end
	--Create Characters Mailbox, or resync if we get more that 5 mails out of tune
	if #db["mailbox"] > (#mailCurrent+2) or #db["mailbox"] == 0 then
		--debugPrint("Mail tables too far out of sync, resyncing #mailCurrent", #mailCurrent,"#mailData" ,#BeanCounterDB[private.realmName][private.playerName]["mailbox"])
		db["mailbox"] = {}
		for i, v in pairs(mailCurrent) do
			db["mailbox"][i] = v
		end
	end

	if #db["mailbox"] >= #mailCurrent then --mail removed or same
		for i in ipairs(mailCurrent) do
			if db["mailbox"][i]["subject"] == group["n"] then
				if group["start"] then group["end"] = i else group["start"] = i end
			else
				group["n"], group["start"], group["end"] = db["mailbox"][i]["subject"], i, i
			end

			if mailCurrent[i]["subject"] ~= db["mailbox"][i]["subject"] then
				--debugPrint("group = ",group["n"], group["start"], group["end"])
				if db["mailbox"][i]["read"] == 2 then
					--debugPrint("This is marked read so removing ", i)
					tremove(db["mailbox"], i)
					break
				elseif db["mailbox"][i]["read"] ~= 2 then
	--This message has not been read, so we have a sequence of messages with the same name. Need to go back recursivly till we find the "Real read" message that need removal
					for V = group["end"], group["start"], -1 do
						if db["mailbox"][V]["read"] == 2 then
							--debugPrint("recursive read group",group["end"] ,"--",group["start"], "found read at",V )
							tremove(db["mailbox"], V)
							break
						end
					end
				end
				break
			end
		end
	elseif #db["mailbox"] < #mailCurrent then --mail added
		for i,v in ipairs(mailCurrent) do
			if db["mailbox"][i] then
				if mailCurrent[i]["subject"] ~=  db["mailbox"][i]["subject"] then
					--debugPrint("#private.mailData < #mailCurrent adding", i, mailCurrent[i]["subject"])
					tinsert(db["mailbox"], i, v)
				end
			else
			--debugPrint("need to add key ", i)
				tinsert(db["mailbox"], i, v)
			end
		end

	end
	private.mailFrameUpdate()
	private.hasUnreadMail()
end

function private.hasUnreadMail()
	--[[if HasNewMail() then MiniMapMailFrame:Show() debugPrint("We have real unread mail, mail icon show/hide code bypassed") return end  --no need to process if we have real unread messages waiting
	if not get("util.beancounter.mailrecolor") then MiniMapMailFrame:Hide() return end --no need to do this if user isn't using recolor system, and mail icon should not show since HasnewMail() failed

	local mailunread = false
	for i,v in pairs(BeanCounterDB[private.realmName][private.playerName]["mailbox"]) do
		if BeanCounterDB[private.realmName][private.playerName]["mailbox"][i]["read"] < 2 then
		    mailunread = true
		end
	end
	if mailunread then
		lib.SetSetting("util.beancounter.hasUnreadMail", true)
		MiniMapMailFrame:Show()
	else
		lib.SetSetting("util.beancounter.hasUnreadMail", false)
		MiniMapMailFrame:Hide()
	end]]
end
