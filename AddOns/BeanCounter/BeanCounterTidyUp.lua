--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: 8.2.6422 (SwimmingSeadragon)
	Revision: $Id: BeanCounterTidyUp.lua 6422 2019-09-13 05:07:31Z none $
	URL: http://auctioneeraddon.com/

	BeanCounterTidyUp - Database clean up and maintenance functions

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
LibStub("LibRevision"):Set("$URL: BeanCounter/BeanCounterTidyUp.lua $","$Rev: 6422 $","5.1.DEV.", 'auctioneer', 'libs')

local lib = BeanCounter
local private = lib.Private
local private, print, get, set, _BC = lib.getLocals()
local pairs,ipairs,next,select,type,random,date = pairs,ipairs,next,select,type,random,date
local strsplit = strsplit

local function debugPrint(...)
    if get("util.beancounter.debugTidyUp") then
        private.debugPrint("BeanCounterTidyUp", ...)
    end
end

function private.maintenanceTasks()
	--check for tasks that need to run.
	for server, serverData in pairs(BeanCounterDB) do
		for player, playerData in pairs(serverData) do
			private.startPlayerMaintenance(server, player)
		end
	end
end

local runServerTaskOnce = true
--[[Checks each players last run time and runs maintaince functions if apprp.  Adds a random amount of days and reschedules]]
function private.startPlayerMaintenance(server, player)
	local currentTime = time()
	local RND = currentTime + random(86400, 432000)
	--get schedule values or create new value that will run task NOW
	local sortArray = get("tasks.sortArray", server, player) or 0
	local prunePostedDB = get("tasks.prunePostedDB", server, player) or 0
	local compactDB = get("tasks.compactDB", server, player) or 0

	--we use random to add 1-5 days to the fixed intervals. This should keep all the tasks from occuring in the same login in general
	if sortArray + 2592000 < currentTime then --run monthly
		private.sortArrayByDate(server, player)
		set("tasks.sortArray", RND, server, player)
	end
	if prunePostedDB + 1296000 < currentTime then --run every 14 days
		private.prunePostedDB(server, player)
		set("tasks.prunePostedDB", RND, server, player)
	end
	if compactDB + 2592000 < currentTime then --run monthly
		private.compactDB(server, player)
		set("tasks.compactDB", RND, server, player)
	end

	--check for non player tasks
	if runServerTaskOnce then
		runServerTaskOnce = false
		local refresh = get("tasks.refreshItemIDArray")
		if refresh and refresh + 604800 < currentTime then--every 7 days
			private.refreshItemIDArray()
			private.pruneItemNameArray()
			set("tasks.refreshItemIDArray", time())
		end
	end
end

--Sum all entries for display in window  TODO:Add in check for lua key value limitations
function private.sumDatabase()
	private.DBSumEntry, private.DBSumItems = 0, 0
	for server, serverData in pairs(BeanCounterDB) do
		for player, playerData in pairs(serverData) do
			for DB, data in pairs(playerData) do
				if DB ~= "postedBids" and DB ~= "postedAuctions" then
					for itemID, value in pairs(data) do
						for itemString, data in pairs(value) do
							private.DBSumEntry = private.DBSumEntry + 1
							private.DBSumItems = private.DBSumItems + #data
						end
					end
				end
			end
		end
	end
	private.frame.DBCount:SetText("Items: "..private.DBSumEntry)
	private.frame.DBItems:SetText("Entries: "..private.DBSumItems)
	return private.DBSumEntry, private.DBSumItems
end

--Recreate/refresh ItemIName to ItemID array
function private.refreshItemIDArray(announce)
	for player, v in pairs(private.serverData)do
		for DB,data in pairs(private.serverData[player]) do
			for itemID, value in pairs(data) do
				for itemString, text in pairs(value) do
					local key, suffix = lib.API.decodeLink(itemString)
					if not BeanCounterDBNames[key..":"..suffix] then
						local _, itemLink = private.getItemInfo(itemString, "itemid")
						if itemLink then
							debugPrint("Added to array, missing value",  itemLink)
							lib.API.storeItemLinkToArray(itemLink)
						end
					end
				end
			end
		end
	end
--~ 	if announce then print("Finished refresing ItemName Array") end
end

--[[ Purge itemID array links that no longer have transactions ]]
local function pruneItemNameArrayHelper(itemID)
	for server, serverData in pairs(BeanCounterDB) do
		for player, playerData in pairs(serverData) do
			for DB, data in pairs(playerData) do
				if data[itemID] then
					--found a match
					return true
				end
			end
		end
	end
end

function private.pruneItemNameArray()
	local  itemID, key
	local del = {}
	for i, link in pairs(BeanCounterDBNames) do
		itemID, key = strsplit(":", i)
		if not pruneItemNameArrayHelper(itemID) then
			debugPrint("No longer any stored data for", itemID, link, "removing from Name directory")
			tinsert(del, i)
		end
	end
	for _, key in pairs(del) do
		BeanCounterDBNames[key] = nil
	end
end

--Moves entries older than 40 days into compressed( non uniqueID) Storage
--Removes data older than X  months from the DB
--Array refresh needs to run before this function
function private.compactDB(server, player)
	local playerData = BeanCounterDB[server][player]
	local TIME = time() --sets TIME for this compact operation

	for DB, data in pairs(playerData) do
		if DB ~= "postedBids" and DB ~= "postedAuctions" then
			local datatoCompress = {}
			local datatoPurge = {}
			for itemID, itemIDData in pairs(data) do
				for itemString, itemStringData in pairs(itemIDData) do
					local _, suffix, uniqueID = lib.API.decodeLink(itemString)
					if uniqueID ~= "0" and string.len(uniqueID) > 8 then --ignore the already compacted keys, compacted keys are uniqueID of 0 or the scaling factor for negative suffix items
						--Since we will be possibly creating new itemID keys we need to delay till after we have parsed all itemID's
						--adding new keys while parsing the table can make it skip checking
						datatoCompress[itemString] = itemStringData
					elseif get("oldDataExpireEnabled") then
				         --for non unique strings we know they are already older than the compress date, So check to see if they are old enough to be pruned by the Remove Old transactions option
						local months = get("monthstokeepdata")
						local expire = TIME - (months * 30 * 24 * 60 * 60)
						--check last key in DB to see if its old enough
						local _, _, _, _, _, _, _, postTime = private.unpackString(itemStringData[#itemStringData])
						if postTime and tonumber(postTime) <= expire then --postTime may not exist if the table is empty
							datatoPurge[itemString] = itemStringData
						end
					end
				end
			end
			private.removeUniqueID(datatoCompress, DB, server, player)
			private.removeOldData(datatoPurge, DB, server, player)
			--check for now empty tables
			for itemID, itemIDData in pairs(data) do
				for itemString, itemStringData in pairs(itemIDData) do
					--remove itemStrings that are now empty, all the keys have been moved to compressed format
					if #itemStringData == 0 then
						debugPrint("Removed empty table:", itemString, server, player)
						playerData[DB][itemID][itemString] = nil
					end
				end
				--after removing the itemStrings look to see if there are itemID's that need removing
				if next (itemIDData) == nil then
					debugPrint("Removed empty itemID:", itemID, server, player)
					BeanCounterDB[server][player][DB][itemID] = nil
				end
			end
		end
	end
	debugPrint("Finished compressing Databases", server, player)
end

function private.removeUniqueID(datatoCompress, DB, server, player)
	local TIME = time()--no need to call this for every loop
	for itemString, itemStringData in pairs(datatoCompress) do
		for i = #itemStringData, 1, -1 do
			local _, _, _, _, _, _, _, postTime  = private.unpackString(itemStringData[i])
			if (TIME - postTime) >= 3456000 then --we have an old data entry lets process this
				debugPrint("Compressed", itemString, itemStringData[i] , server, player)
				private.databaseAdd(DB, nil, itemString, itemStringData[i], true, server, player) --store using the compress option set to true
				table.remove(itemStringData, i)
			else
				break
			end
		end
	end
end

function private.removeOldData(datatoPurge, DB, server, player)
	local months = get("monthstokeepdata") --doh, hard coded the value during testing
	local expire = time() - (months * 30 * 24 * 60 * 60)
	for itemString, itemStringData in pairs(datatoPurge) do
		for i = #itemStringData, 1, -1 do
			local _, _, _, _, _, _, _, postTime = private.unpackString(itemStringData[i])

			if tonumber(postTime) <= expire then --we have an old data entry lets process this
				debugPrint("Removed", itemString, itemStringData[i] , date("%c", postTime) , server, player)
				table.remove(itemStringData, i)
			else
				break
			end
		end
	end
end

--Sort all array entries by Date newest to oldest
--Helps make compact more efficent needs to run once per week or so
function private.sortArrayByDate(server, player)
	for DB, data in pairs(BeanCounterDB[server][player]) do
		if DB ~= "postedBids" and DB ~= "postedAuctions" then
			for itemID, value in pairs(data) do
				for itemString, index in pairs(value) do
					table.sort(index,  function(a,b)
					local _, _, _, _, _, _, _, postTimeA = private.unpackString(a)
					local _, _, _, _, _, _, _, postTimeB = private.unpackString(b)
					return postTimeA > postTimeB end)
				end
			end
		end
	end
	debugPrint("Finished sorting database", server, player)
end

--Prune Old keys from postedXXXX tables
--First we find a itemID that needs pruning then we check all other keys for that itemID and prune.
function private.prunePostedDB(server, player)
	--Used to clean up post DB
	local curTime = time()
	for DB, data in pairs(BeanCounterDB[server][player]) do
		if  DB == "postedBids" or DB == "postedAuctions"  then
			for itemID, itemIDData in pairs(data) do
				for itemString, itemStringData in pairs(itemIDData) do
					for i = #itemStringData, 1, -1 do
						local _, _ ,_ ,_ ,_ ,TIME = strsplit(";",  itemStringData[i])
						TIME = tonumber(TIME) or 0 -- hack to delete invalid strings which may have occurred in Preview version; cause should now be fixed
						--While the entrys remain 40 days old remove entry
						if (curTime - TIME) >= 3456000 then
							table.remove(itemStringData, i)
						else
							break --data should be in oldest to newest so stop when we get to new items
						end
					end
					-- remove empty itemString tables
					if #itemStringData == 0 then
						BeanCounterDB[server][player][DB][itemID][itemString] = nil
					end
				end
				--after removing the itemStrings look to see if there are itemID's that need removing
				if next (itemIDData) == nil then
					BeanCounterDB[server][player][DB][itemID] = nil
				end
			end
		end
	end
	debugPrint("Finished Cleaning Posted Databases", server, player)
end

--deletes all entries matching a itemLink from database for that server
function private.deleteExactItem(itemLink)
	if not itemLink or not itemLink:match("^(|c%x+|H.+|h%[.+%])") then return end
	for player, playerData in pairs(private.serverData) do
		for DB, data in pairs(playerData) do
			for itemID, itemIDData in pairs(data) do
				for itemString, itemStringData in pairs(itemIDData) do
					local  _,_,_,_,_,_, _, suffix, uniqueID = strsplit(":", itemString)
					local linkID, linkSuffix = lib.API.decodeLink(itemLink)
					if linkID == itemID and suffix == linkSuffix then
						debugPrint("matched", itemLink, itemString, linkSuffix, suffix)
						itemIDData[itemString] = nil
					end
				end
			end
		end
	end
end

--[[INTEGRITY CHECKS
Make sure the DB format is correct removing any entries that were missed by updating.
To be run after every DB update
]]--
local integrity = {} --table containing teh DB layout
	integrity["completedBidsBuyouts"] = {"number", "number", "number", "number", "number", "number", "string", "number", "string", "string"}--10
	integrity["completedAuctions"] = {"number", "number", "number", "number", "number", "number", "string", "number", "string", "string"}--10
	integrity["failedBids"] = {"number", "number", "number", "number", "number", "number", "string", "number", "string", "string"}--10
	integrity["failedAuctions"] = {"number", "number", "number", "number", "number", "number", "string", "number", "string", "string"}--10
	integrity["postedBids"] = {"number", "number", "string", "string", "number", "number", "string" } --7
	integrity["postedAuctions"] = {"number", "number", "number", "number", "number" ,"number", "string"} --7

	integrity["completedBidsBuyoutsNeutral"] = {"number", "number", "number", "number", "number", "number", "string", "number", "string", "string"}--10
	integrity["completedAuctionsNeutral"] = {"number", "number", "number", "number", "number", "number", "string", "number", "string", "string"}--10
	integrity["failedBidsNeutral"] = {"number", "number", "number", "number", "number", "number", "string", "number", "string", "string"}--10
	integrity["failedAuctionsNeutral"] = {"number", "number", "number", "number", "number", "number", "string", "number", "string", "string"}--10
local integrityClean, integrityCount = true, 1
 function private.integrityCheck(complete, server)
	if not server then server = private.realmName end
	local tbl
	debugPrint(integrityCount)
	for player, playerData in pairs(BeanCounterDB[server])do
		for DB, data in pairs(playerData) do
			if type(data) ~= "table" then
				debugPrint("Failed: Not a table", server, player, DB)
				playerData[DB] = {}
			else
				for itemID, value in pairs(data) do
					for itemString, data in pairs(value) do
						local _, itemStringLength = itemString:gsub(":", ":")
						--check that the data is a string and table
						if type(itemString) ~= "string"  or  type(data) ~= "table" then
							BeanCounterDB[server][player][DB][itemID][itemString] = nil
							debugPrint("Failed: Invalid format", DB, data, "", itemString)
							integrityClean = false
						--[[ temporarily disabled pending review of WoD: with new bonusID fields, a valid itemString could have any number of ':' from 12 up
						elseif itemStringLength > 10 then --Bad itemstring purge
							debugPrint("Failed: Invalid itemString", DB, data, "", itemString)
							local _, link = GetItemInfo(itemString) --ask server for a good itemlink
							local itemStringNew = lib.API.getItemString(link) --get NEW itemString from itemlink
							if itemStringNew then
								debugPrint(itemStringNew, "New link recived replacing")
								BeanCounterDB[server][player][DB][itemID][itemStringNew] = data
								BeanCounterDB[server][player][DB][itemID][itemString] = nil
							else
								debugPrint(itemString, "New link falied purging item")
								BeanCounterDB[server][player][DB][itemID][itemString] = nil
							end
							integrityClean = false
						--]]
						elseif itemStringLength < 9 then
							local itemStringNew = itemString..":80"
							BeanCounterDB[server][player][DB][itemID][itemStringNew] = data
							BeanCounterDB[server][player][DB][itemID][itemString] = nil
							integrityClean = false
						else
							for index, text in pairs(data) do
								tbl = {strsplit(";", text)}
								--check entries for missing data points, skip any DB we havnt made a key for
								if integrity[DB] then
									if #integrity[DB] ~= #tbl then
										debugPrint("Failed: Number of entries invalid", player, DB, #tbl, text)
										table.remove(data, index)
										integrityClean = false
									elseif complete and private.IC(tbl, DB) then
										--do a full check type() = check
										debugPrint("Failed type() check", player, DB, index, text)
										table.remove(data, index)
										integrityClean = false
									end
								end
							end
						end
					end
				end
			end
		end
	end
	--rerun integrity 10 times or until it goes cleanly
	if not integrityClean and  integrityCount < 10 then
		integrityCount = integrityCount + 1
		integrityClean = true
		private.integrityCheck(complete, server)
	else
		print("BeanCounter Integrity Check Completed after:",integrityCount, "passes", complete)
		integrityClean, integrityCount = true, 1
		--set("util.beancounter.integrityCheckComplete", true)
		--set("util.beancounter.integrityCheck", true)
	end

end

--look at each value and compare to the number, string, number pattern for that specific DB
function private.IC(tbl, DB, text)
	for i,v in pairs(tbl) do
		if v ~= "" then --<nil> is a placeholder for string and number values, ignore
			v = tonumber(v) or v
			if type(v) ~= integrity[DB][i] then
				return true
			end
		end
	end
	return false
end
