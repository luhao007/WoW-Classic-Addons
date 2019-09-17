--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: 8.2.6422 (SwimmingSeadragon)
	Revision: $Id: BeanCounter.lua 6422 2019-09-13 05:07:31Z none $

	BeanCounterCore - BeanCounter: Auction House History
	URL: http://auctioneeraddon.com/

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
LibStub("LibRevision"):Set("$URL: BeanCounter/BeanCounter.lua $","$Rev: 6422 $","5.1.DEV.", 'auctioneer', 'libs')

--AucAdvanced.Modules["Util"]["BeanCounter"]

local select,ipairs,pairs=select,ipairs,pairs
local concat=table.concat
local tonumber,tostring,strsplit,strjoin,UnitName,GetRealmName,GetMoney =tonumber,tostring,strsplit,strjoin,UnitName,GetRealmName,GetMoney
local tinsert,tremove = tinsert,tremove

local libName = "BeanCounter"
local libType = "Util"
local lib
BeanCounter={}
lib = BeanCounter
lib.API = {}
local private = {
	--BeanCounterCore
	playerName = UnitName("player"),
	realmName = GetRealmName(),
	--AucModule, --registers as an auctioneer module if present and stores module local functions
	faction = nil,
	version = 3.03,
	wealth = 0, --This characters current net worth. This will be appended to each transaction.
	compressed = false,

	--playerData, --Alias for BeanCounterDB[private.realmName][private.playerName]
	--serverData, --Alias for BeanCounterDB[private.realmName]
	--playerSettings, --Alias for  BeanCounterDBSettings[private.realmName][private.playerName]
	DBSumEntry = 0,
	DBSumItems = 0,
	--BeanCounter Bids/posts
	PendingBids = {},
	PendingPosts = {},

	--BeanCounterMail
	reconcilePending = {},
	inboxStart = {},
	serverVersion = select(4, GetBuildInfo()),--WOW 3.0 HACK
}

local tooltip = LibStub("nTipHelper:1")
private.tooltip = tooltip

lib.Private = private --allow beancounter's sub lua's access
--Taken from AucAdvCore
function BeanCounter.Print(...)
	local output, part
	for i=1, select("#", ...) do
		part = select(i, ...)
		part = tostring(part):gsub("{{", "|cffddeeff"):gsub("}}", "|r")
		if (output) then output = output .. " " .. part
		else output = part end
	end
	DEFAULT_CHAT_FRAME:AddMessage(output, 0.3, 0.9, 0.8)
end

local print = BeanCounter.Print

local function debugPrint(...)
    if lib.GetSetting("util.beancounter.debugCore") then
        private.debugPrint("BeanCounterCore",...)
    end
end

-- DEBUGGING
--[[
local DebugLib = LibStub("DebugLib")
local debug, assert, printQuick
if DebugLib then
	debug, assert, printQuick = DebugLib("LibExtraTip")
else
	function debug() end
	assert = debug
	printQuick = debug
end

-- when you just want to print a message and don't care about the rest
function DebugPrintQuick(...)
	printQuick(...)
end
--]]

--used to allow beancounter to recive Processor events from Auctioneer. Allows us to send a search request to BC GUI
if AucAdvanced then
	private.AucModule = AucAdvanced.NewModule(libType, libName, nil, true) --register as an Adv Module for callbacks
	if private.AucModule then
		local get, set, default = select(7, AucAdvanced.GetModuleLocals()) --Get locals for use getting settings
		private.AucModule.locals = {["get"] = get, ["set"] = set, ["default"] = default}

		function private.AucModule.Processor(callbackType, ...)
			if (callbackType == "querysent") and lib.API.isLoaded then --if BeanCounter has disabled itself dont try looking for auction House links
				local item = ...
				if item.name then
					if item.name ~= "" then
						lib.API.search(item.name)
					end
				end
			elseif (callbackType == "bidplaced") and lib.API.isLoaded then
				private.storeReasonForBid(...)
			end
		end
		private.AucModule.Processors = {}
		function private.AucModule.Processors.querysent(callbackType, ...)
			if lib.API.isLoaded then
				local item = ...
				if item.name then
					if item.name ~= "" then
						lib.API.search(item.name)
					end
				end
			end
		end
		function private.AucModule.Processors.bidplaced(callbackType, ...)
			if lib.API.isLoaded then
				private.storeReasonForBid(...)
			end
		end
	end
end

-- lib.API.isLoaded  is false until DB is ready and all gui and API elements have been created
lib.API.isLoaded = false
function lib.OnLoad(addon)
	private.initializeDB() --create or initialize the saved DB
	 --OK we now have our Database ready, lets create an Alias to make refrencing easier
	local db = BeanCounterDB
	private.playerData = db[private.realmName][private.playerName]
	private.serverData = db[private.realmName]
	private.playerSettings = BeanCounterDBSettings[private.realmName][private.playerName]
	private.wealth = private.playerSettings["wealth"]
	--Upgrade DB if needed
	private.UpgradeDatabaseVersion()
	--Check if user is trying to use old client with newer database or if the database has failed to update
	if private.version and private.playerData.version then
		if private.version < private.playerData.version then
			private.CreateErrorFrames("bean older", private.version, private.playerData.version)
			return
		elseif private.version ~= private.playerData.version then
			private.CreateErrorFrames("failed update", private.version, private.playerData.version)
			return
		end
	end
	--Continue loading if the Database is ready
	lib.MakeGuiConfig() --create the configurator GUI frame
	private.CreateFrames() --create our framework used for AH and GUI
	private.createDeleteItemPrompt() --create the item delete prompt
	private.slidebar() --create slidebar icon
	private.maintenanceTasks() --run any scheduled tasks

	private.scriptframe:RegisterEvent("PLAYER_MONEY")
	private.scriptframe:RegisterEvent("PLAYER_ENTERING_WORLD")
	private.scriptframe:RegisterEvent("MAIL_INBOX_UPDATE")
	--private.scriptframe:RegisterEvent("UI_ERROR_MESSAGE") -- ### not used?
	private.scriptframe:RegisterEvent("MAIL_SHOW")
	private.scriptframe:RegisterEvent("MAIL_CLOSED")
	private.scriptframe:RegisterEvent("UPDATE_PENDING_MAIL")
	private.scriptframe:RegisterEvent("MERCHANT_SHOW")
	private.scriptframe:RegisterEvent("MERCHANT_UPDATE")
	private.scriptframe:RegisterEvent("MERCHANT_CLOSED")
	private.scriptframe:RegisterEvent("UNIT_SPELLCAST_SENT")

	private.scriptframe:SetScript("OnUpdate", private.onUpdate)

	-- Hook all the methods we need
	Stubby.RegisterAddOnHook("Blizzard_AuctionUi", "BeanCounter", private.AuctionUI) --To be standalone we cannot depend on AucAdv for lib.Processor
	--mail
	Stubby.RegisterFunctionHook("TakeInboxMoney", -100, private.PreTakeInboxMoneyHook)
	Stubby.RegisterFunctionHook("TakeInboxItem", -100, private.PreTakeInboxItemHook)

	--Bids
	Stubby.RegisterFunctionHook("PlaceAuctionBid", 50, private.postPlaceAuctionBidHook)
	--Posting
	Stubby.RegisterFunctionHook("PostAuction", -100, private.prePostAuctionHook)
	--Vendor
	--hooksecurefunc("BuyMerchantItem", private.merchantBuy)

	tooltip:Activate()
	tooltip:AddCallback(private.processTooltip, 700)

	lib.API.isLoaded = true
end

--Create the database
--server and player are passed by upgrade code when we need to reset a toons DB
function private.initializeDB(server, player)
	if not server then server = private.realmName end
	if not player then player = private.playerName end

	local db = BeanCounterDB
	if not db then
		db = {}
		BeanCounterDB = db
	end

	if not db[server] then
		db[server] = {}
	end
	--data
	if not db[server][player] then
		local playerData = {}
		db[server][player] = playerData

		playerData["vendorbuy"] = {}
		playerData["vendorsell"] = {}

		playerData["postedAuctions"] = {}
		playerData["completedAuctions"] = {}
		playerData["failedAuctions"] = {}

		playerData["postedBids"] = {}
		playerData["completedBidsBuyouts"]  = {}
		playerData["failedBids"]  = {}

		playerData["completedAuctionsNeutral"] = {}
		playerData["failedAuctionsNeutral"] = {}

		playerData["completedBidsBuyoutsNeutral"]  = {}
		playerData["failedBidsNeutral"]  = {}
	end
	--settings
	local db = BeanCounterDBSettings
	if not db then
		db = {}
		BeanCounterDBSettings = db
	end

	if not db[server] then
		db[server] = {}
	end

	if not db[server][player] then
		local playerData = {}
		db[server][player] = playerData

		playerData["version"] = private.version
		playerData["faction"] = "unknown" --faction is recorded when we get the login event
		playerData["wealth"] = GetMoney()
		playerData["mailbox"] = {}
	end
	--item Name table
	local db = BeanCounterDBNames
	if not db then
		db = {}
		BeanCounterDBNames = db
	end
end

--[[ Configator Section ]]--
--See BeanCounterConfig.lua
--sets sub luas print, get, set, localization and any future locals
function lib.getLocals()
	return lib.Private, lib.Print, lib.GetSetting, lib.SetSetting, private.localizations
end

--[[Sidebar Section]]--
local sideIcon
function private.slidebar()
	if LibStub then
		local LibDataBroker = LibStub:GetLibrary("LibDataBroker-1.1", true)
		if not LibDataBroker then return end
		private.LDBButton = LibDataBroker:NewDataObject("BeanCounter", {
					type = "launcher",
					icon = "Interface\\AddOns\\BeanCounter\\Textures\\BeanCounterIcon",
					OnClick = function(self, button)
						private.GUI(self, button)
					end,
				})

		function private.LDBButton:OnTooltipShow()
			local count, items = private.DBSumEntry or 0, private.DBSumItems or 0
			self:AddLine("BeanCounter",  1,1,0.5, 1)
			self:AddLine("Tracks your trading activities so that you may review your expenditures and income, perform searches and use this data to determine your successes and failures.",  1,1,0.5, 1)
			self:AddLine(string.format("Items:|CFF00FFF1 %s |r", count),  1,1,0.5, 1 )
			self:AddLine(string.format("Entries:|CFF00FFF1 %s |r", items),  1,1,0.5, 1 )
			self:AddLine("|cff1fb3ff".."Click|r to view your activity report.",  1,1,0.5, 1)
			self:AddLine("|cff1fb3ff".."Right-Click|r to edit the configuration",  1,1,0.5, 1)
		end

		function private.LDBButton:OnEnter()
			--print(self)
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
			GameTooltip:ClearLines()
			private.LDBButton.OnTooltipShow(GameTooltip)
			GameTooltip:Show()
	end
		function private.LDBButton:OnLeave()
		--print(self)
			GameTooltip:Hide()
		end
	end
end

--[[ Local functions ]]--
function private.onUpdate()
	private.mailonUpdate()
end

--sum the Mats value
function private.sumDEValue()
	local deMat, quantity =	private.bag["link"],  private.bag["quantity"]
	local itemLink = private.bag["DElink"]
	if not itemLink or not deMat or not quantity then
		debugPrint("Missing data for DE event", itemLink, deMat, quantity)
		return
	end

	--use average sell price or fall back and use auctionner if possible
	local settings = {["selectbox"] = {"1", "server"} ,["auction"] = true}
	local data = lib.API.search(deMat, settings, true)
	local profit, count = 0, 0
	local days =  7*24*60*60 --one week
	if data and #data > 0 then
		for i = #data, 1, -1 do
			count = count + 1
			profit =  profit + data[i][7]
			if data[i][12] < time() - days then
				--print(i,data[i][7], date("%c", data[i][12]), count)
				break
			end
		end
		profit = floor(profit/count)
	end
	--fall back to auctioneer
	if AucAdvanced and AucAdvanced.API.GetMarketValue and profit < 1 then
		profit = AucAdvanced.API.GetMarketValue(deMat)
	end
	--convert to itemID
	deMat = lib.API.decodeLink(deMat)
	--print("We Disnechnated ", itemLink, " into ", deMat, quantity, profit)
	if not deMat or not quantity or not profit then return end

	local meta = string.join(":", "DE", deMat, quantity, profit)
	meta = meta.."|"
	private.attachMeta( itemLink, meta )
end

function private.attachMeta( itemLink, meta )
	local itemString = lib.API.getItemString(itemLink)
	local itemID, suffix = lib.API.decodeLink(itemLink)

	for  player, playerData in pairs(private.serverData) do
		for DB, data in pairs(playerData) do
			if   DB == "completedBidsBuyouts" or DB == "completedBidsBuyoutsNeutral" then
				if data[itemID] and data[itemID][itemString] then
					for i, text in pairs(data[itemID][itemString]) do
						local STACK, NET, DEPOSIT , FEE, BUY , BID, SELLERNAME, TIME, REASON, META = private.unpackString(text)
						if not META:match("DE:(.-):(.-):(.-)|") then --no DE Meta so add
							if META == 0 then
								META = meta
							else
								META = META.."|"..meta
							end

							local newText = private.packString(STACK, NET, DEPOSIT, FEE, BUY, BID, SELLERNAME, TIME, REASON, META)
							--DebugPrintQuick("Adding Meta for ", itemLink, meta, newText, STACK, NET, DEPOSIT, FEE, BUY, BID, SELLERNAME, TIME, REASON, META)
							table.remove(data[itemID][itemString], i)
							private.databaseAdd(DB, nil, itemString, newText)
							--print(newText)
							private.wipeSearchCache() --clear cached searches
							return
						end
					end
				end
			end
		end
	end
end

function private.onEvent(frame, event, arg, ...)
	if (event == "PLAYER_MONEY") then
		private.wealth = GetMoney()
		private.playerSettings["wealth"] = private.wealth

	elseif (event == "PLAYER_ENTERING_WORLD") then --used to record one time info when player loads
		private.scriptframe:UnregisterEvent("PLAYER_ENTERING_WORLD") --no longer care about this event after we get our current wealth
		private.wealth = GetMoney()
		private.playerSettings["wealth"] = private.wealth
		local faction = UnitFactionGroup("player")
		if faction == "Alliance" or faction == "Horde" then
			private.playerSettings["faction"] = faction
		elseif faction == "Neutral" then -- Pandarian
			private.scriptframe:RegisterEvent("NEUTRAL_FACTION_SELECT_RESULT")
			private.playerSettings["faction"] = "unknown" -- don't use "Neutral" as that refers to the Neutral Auctionhouse
		else
			-- faction is only permitted to be one of "Alliance", "Horde" or "unknown"
			-- if there's a valid faction saved from a previous session, use that
			-- otherwise (nil, unknown or possibly corrupt) overwrite data with "unknown"
			local oldfaction = private.playerSettings["faction"]
			if oldfaction ~= "Alliance" and oldfaction ~= "Horde" then
				private.playerSettings["faction"] = "unknown"
			end
		end
		private.faction = faction -- not used by BeanCounter; record of actual return value for possible debugging
	elseif (event == "MAIL_INBOX_UPDATE") or (event == "MAIL_SHOW") or (event == "MAIL_CLOSED") then
		private.mailMonitor(event, arg, ...)

	elseif (event == "MERCHANT_CLOSED") or (event == "MERCHANT_SHOW") or (event == "MERCHANT_UPDATE") then
			--private.vendorOnevent(event, arg, ...)

	elseif (event == "UPDATE_PENDING_MAIL") then
		private.hasUnreadMail()
		--we also use this event to get faction data - legacy as faction detection was previously unreliable
		if private.playerSettings["faction"] == "unknown" then
			local faction = UnitFactionGroup("player")
			if faction == "Alliance" or faction == "Horde" then
				private.playerSettings["faction"] = faction
			end
			private.faction = faction
		end
	elseif (event == "ADDON_LOADED") then
		if arg == "BeanCounter" then
		   lib.OnLoad()
		   private.scriptframe:UnregisterEvent("ADDON_LOADED")
		end
	elseif event == "NEUTRAL_FACTION_SELECT_RESULT" then
		local faction = UnitFactionGroup("player")
		if faction == "Alliance" or faction == "Horde" then
			private.playerSettings["faction"] = faction
		end
		private.faction = faction
		private.scriptframe:UnregisterEvent("NEUTRAL_FACTION_SELECT_RESULT")
	end
end

--scripts that handle recording DE events
local inDEState = false
function private.onEventDisenchant(frame, event, arg, spell, _, _, spellID)
	if event == "UNIT_SPELLCAST_SUCCEEDED" and arg == "player" and spellID == 13262 then
		inDEState = true
		private.bag = {}
	elseif event == "ITEM_LOCK_CHANGED" and inDEState then
		local bagID, slot = arg, spell
		local link
		if slot then
			link = GetContainerItemLink(bagID, slot)
		else
			link = GetInventoryItemLink("player", bagID)
		end
		private.bag["DElink"] = link
	elseif event == "LOOT_OPENED" and inDEState then --what did it DE into
		for slot = 1, GetNumLootItems() do
			local link = GetLootSlotLink(slot)
			local _, _, quantity = GetLootSlotInfo(slot)
			private.bag["link"] = link
			private.bag["quantity"] = quantity
		end
		private.sumDEValue()
		inDEState =  false
	end
end

--[[ Utility Functions]]--

--will return any length arguments into a ; seperated string
local tmp={}
function private.packString(...)
	local num = select("#", ...)
	for n = 1, num do
		local msg = select(n, ...)
		if msg == nil then
			msg = ""
		elseif msg == true then
			msg = "boolean true"
		elseif msg == false then
			msg = "boolean false"
		elseif msg == "0" then
			msg = ""
		elseif msg == 0 then
			msg = ""
		elseif msg == "<nil>" then
			msg = ""
		end
		tmp[n] = msg
	end
	return concat(tmp,";",1,num)
end

--Will split any string and return a table value, replace gsub with tbl compare, slightly faster this way.
function private.unpackString(text)
	if not text then return end
	local stack,  money, deposit , fee, buyout , bid, buyer, Time, reason, meta = strsplit(";", text)
	if not stack or stack == "" then stack = "0" end
	if not money or money == "" then money = "0" end
	if not deposit or deposit == "" then deposit = "0" end
	if not fee or fee == "" then fee = "0" end
	if not buyout or buyout == "" then buyout = "0" end
	if not bid or bid == "" then bid = "0" end
	if not buyer or buyer == "" then buyer = "0" end
	if not Time or Time == "" then Time = "0" end
	if not reason or reason == "" then reason = "0" end
	if not meta or meta == "" then meta = "0" end

	return stack, money, deposit , fee, buyout , bid, buyer, Time, reason, meta
end

--[[
Adds data to the database in proper place, adds link to itemName array, optionally compresses the itemstring into compact format
return false if data fails to write
Add at start of DB so its in newest to oldest order
]]
function private.databaseAdd(key, itemLink, itemString, value, compress, server, player)
	--if we are passed a link and not both then extract the string
	--DebugPrintQuick("Adding Enry for ", key, itemLink, itemString )

	if itemLink and not itemString then
		itemString = lib.API.getItemString(itemLink)
	end

	--DebugPrintQuick("Updated String for ", key, itemLink, itemString )

	if not key or not itemString or not value then
		debugPrint("BeanCounter database add error: Missing required data")
		debugPrint("Database:", key, "itemString:", itemString, "Value:", value, "compress:",compress)
		return false
	end
	--some keys do not need the uniqueID so Always compress em
	if key == "failedBids" or key == "failedAuctions" or key == "failedAuctionsNeutral" or key == "failedBidsNeutral"  then
		compress = true
	end

	local item, itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4, suffixID, uniqueID, tail = strsplit(":", itemString, 10)
	--if this will be a compressed entry replace uniqueID with 0 or its scaling factor
	if compress then
		local suffixvalue = tonumber(suffixID)
		uniqueID = tonumber(uniqueID)
		if uniqueID and suffixvalue and suffixvalue < 0 then --scaling factor built into uniqueID, extract it and store so we can create properly scaled itemLinks
			uniqueID = tostring(bit.band(uniqueID, 65535))
		else
			uniqueID = ""
		end
		itemString = strjoin(":", item, itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4, suffixID, uniqueID, tail)
	end
	--use current player unless we pass in a server, player
	local db = private.playerData
	if BeanCounterDB[server] and BeanCounterDB[server][player] then
		db = BeanCounterDB[server][player]
	end

	if db[key][itemID] then --if ltemID exists
		if db[key][itemID][itemString] then
			tinsert(db[key][itemID][itemString], 1, value) --insert into front of array
		else
			db[key][itemID][itemString] = {value}
		end
	else
		db[key][itemID]={[itemString] = {value}}
	end
	--Insert into the ItemName:ItemID dictionary array
	if itemLink then
		lib.API.storeItemLinkToArray(itemLink)
	end
	return true
end

--remove item (for pending bids only atm)
function private.databaseRemove(key, itemID, itemLink, NAME, COUNT)
	if key == "postedBids" then
	local itemString = lib.API.getItemString(itemLink)
	local _, suffix = lib.API.decodeLink(itemLink)
		if private.playerData[key][itemID] and private.playerData[key][itemID][itemString] then
			for i, v in pairs(private.playerData[key][itemID][itemString]) do
				local postCount, postBid, postSeller, isBuyout, postTimeLeft, postTime, postReason = private.unpackString(v)
				if postSeller and itemID  and NAME then
					if postSeller == NAME and tonumber(postCount) == COUNT then
						--debugPrint("Removing entry from postedBids this is a match", itemID, NAME, "vs", postedName, postedCount, "vs",  COUNT)
						tremove(private.playerData[key][itemID][itemString], i)--Just remove the key
						break
					end
				end
			end
		end
	end
end

--Store reason Code for BTM/SearchUI
--tostring(bid["link"]), tostring(bid["sellername"]), tostring(bid["count"]), tostring(bid["buyout"]), tostring(bid["price"]), tostring(bid["reason"]))
function private.storeReasonForBid(CallBack)
	--debugPrint("bidplaced", CallBack)
	if not CallBack then return end

	local itemLink, seller, count, buyout, price, reason = strsplit(";", CallBack)
	local itemString = lib.API.getItemString(itemLink)
	local itemID, suffix = lib.API.decodeLink(itemLink)

	--DebugPrintQuick("Storing Reason for ", itemLink, itemID, suffix, reason, CallBack, itemString)

	if private.playerData.postedBids[itemID] and private.playerData.postedBids[itemID][itemString] then
		for i, v in pairs(private.playerData.postedBids[itemID][itemString]) do
			local postCount, postBid, postSeller, isBuyout, postTimeLeft, postTime, postReason = private.unpackString(v)
			if postCount and postBid and itemID and price and count then
				if postCount == count and postBid == price then
					local text = private.packString(postCount, postBid, postSeller, isBuyout, postTimeLeft, postTime, reason)
					--debugPrint("before", private.playerData.postedBids[itemID][itemString][i])
					private.playerData.postedBids[itemID][itemString][i] = text
					--DebugPrintQuick("Stored Reason for ", reason, CallBack, text)
					--debugPrint("after", private.playerData.postedBids[itemID][itemString][i])
					break
				else
					--DebugPrintQuick("item bids did not match", itemID, itemString, postCount, postBid, itemID, price, count)
				end
			else
				--DebugPrintQuick("item bids were nil", itemID, itemString, postCount, postBid, itemID, price, count)
			end
		end
	else
		--DebugPrintQuick("Could not find item in bids", itemID, itemString, private.playerData.postedBids[itemID] )
	end

end

--Get item Info or a specific subset. accepts itemID or "itemString" or "itemName ONLY IF THE ITEM IS IN PLAYERS BAG" or "itemLink"
function private.getItemInfo(link, cmd)
	--debugPrint(link, cmd)
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(link)
	if not cmd and itemLink then --return all
		return itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture

	elseif itemLink and (cmd == "itemid") then
		local itemID = lib.API.decodeLink(itemLink)
		return itemID, itemLink

	elseif itemName and itemTexture  and (cmd == "name") then
		return itemName, itemTexture

	elseif itemStackCount and (cmd == "stack") then
		return itemStackCount
	end
	return
end

function private.debugPrint(...)
	if lib.GetSetting("util.beancounter.debug") then
		print(...)
	end
end

--[[DE event frame]]
private.DisenchantScriptframe = CreateFrame("Frame")
private.DisenchantScriptframe:RegisterEvent( "UNIT_SPELLCAST_SUCCEEDED" ) --Start watching for DE results
private.DisenchantScriptframe:RegisterEvent( "LOOT_OPENED" ) --record what teh DE result is
private.DisenchantScriptframe:RegisterEvent("ITEM_LOCK_CHANGED") --get item that was DE
private.DisenchantScriptframe:SetScript("OnEvent", private.onEventDisenchant)

--[[Bootstrap Code]]
private.scriptframe = CreateFrame("Frame")
private.scriptframe:RegisterEvent("ADDON_LOADED")
private.scriptframe:SetScript("OnEvent", private.onEvent)
