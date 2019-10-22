-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local MailTracking = TSM.Inventory:NewPackage("MailTracking")
local private = {
	mailDB = nil,
	itemDB = nil,
	isOpen = false,
	tooltip = nil,
}
local PLAYER_NAME = UnitName("player")



-- ============================================================================
-- Module Functions
-- ============================================================================

function MailTracking.OnInitialize()
	-- update the structure of TSM.db.factionrealm.internalData.pendingMail
	local toUpdate = TSM.TempTable.Acquire()
	for character, pendingMailData in pairs(TSM.db.factionrealm.internalData.pendingMail) do
		if pendingMailData.items then
			TSM:LOG_INFO("Converting pending mail data for %s", character)
			toUpdate[character] = pendingMailData.items
		end
	end
	for character, items in pairs(toUpdate) do
		TSM.db.factionrealm.internalData.pendingMail[character] = items
	end
	TSM.TempTable.Release(toUpdate)

	-- remove data for characters we don't own
	local toRemove = TSM.TempTable.Acquire()
	for character in pairs(TSM.db.factionrealm.internalData.pendingMail) do
		local owner = TSM.db:GetSyncOwnerAccountKey(character)
		if owner and owner ~= TSM.db:GetSyncAccountKey() then
			TSM:LOG_INFO("Removed pending mail data for %s", character)
			tinsert(toRemove, character)
		end
	end
	for _, character in ipairs(toRemove) do
		TSM.db.factionrealm.internalData.pendingMail[character] = nil
	end
	TSM.TempTable.Release(toRemove)

	private.mailDB = TSMAPI_FOUR.Database.NewSchema("MAILTRACKING_INBOX_INFO")
		:AddUniqueNumberField("index")
		:AddStringField("icon")
		:AddStringField("subject")
		:AddStringField("itemString")
		:AddNumberField("itemCount")
		:AddNumberField("money")
		:AddNumberField("cod")
		:AddNumberField("expires")
		:AddIndex("index")
		:Commit()
	private.itemDB = TSMAPI_FOUR.Database.NewSchema("MAILTRACKING_INBOX_ITEMS")
		:AddNumberField("index")
		:AddNumberField("itemIndex")
		:AddStringField("itemLink")
		:AddNumberField("quantity")
		:Commit()

	TSM.db.factionrealm.internalData.pendingMail[PLAYER_NAME] = TSM.db.factionrealm.internalData.pendingMail[PLAYER_NAME] or {}
	TSM.Event.Register("MAIL_SHOW", private.MailShowHandler)
	TSM.Event.Register("MAIL_CLOSED", private.MailClosedHandler)
	TSM.Event.Register("MAIL_INBOX_UPDATE", private.MailInboxUpdateHandler)

	if select(4, GetBuildInfo()) < 80300 then
		-- handle auction buying
		hooksecurefunc("PlaceAuctionBid", function(listType, index, bidPlaced)
			local itemString = TSMAPI_FOUR.Item.ToBaseItemString(GetAuctionItemLink(listType, index))
			local _, _, stackSize, _, _, _, _, _, _, buyout = GetAuctionItemInfo(listType, index)
			if not itemString or bidPlaced ~= buyout then
				return
			end
			TSM.Inventory.ChangePendingMailQuantity(itemString, stackSize)
		end)

		-- handle auction canceling
		hooksecurefunc("CancelAuction", function(index)
			local itemString = TSMAPI_FOUR.Item.ToBaseItemString(GetAuctionItemLink("owner", index))
			local _, _, stackSize = GetAuctionItemInfo("owner", index)
			-- for some reason, these APIs don't always work properly, so check the return values
			if not itemString or not stackSize or stackSize == 0 then
				return
			end
			TSM.Inventory.ChangePendingMailQuantity(itemString, stackSize)
		end)
	else
		-- handle auction buying
		hooksecurefunc(C_AuctionHouse, "PlaceBid", function(auctionId, bidPlaced)
			-- TODO: figure out how to get the info we need
		end)

		-- handle auction canceling
		hooksecurefunc(C_AuctionHouse, "CancelAuction", function(auctionId)
			local itemString = TSM.Inventory.AuctionTracking.GetFieldByIndex(auctionId, "itemString")
			if not itemString then
				return
			end
			local stackSize = TSM.Inventory.AuctionTracking.GetFieldByIndex(auctionId, "stackSize")
			TSM.Inventory.ChangePendingMailQuantity(itemString, stackSize)
		end)
	end

	-- handle sending mail to alts
	hooksecurefunc("SendMail", function(target)
		local character = private.ValidateCharacter(target)
		if not character then
			return
		end
		TSM.db.factionrealm.internalData.pendingMail[character] = TSM.db.factionrealm.internalData.pendingMail[character] or {}
		local altPendingMail = TSM.db.factionrealm.internalData.pendingMail[character]
		for i = 1, ATTACHMENTS_MAX_SEND do
			local itemString = TSMAPI_FOUR.Item.ToBaseItemString(GetSendMailItemLink(i))
			local _, _, _, quantity = GetSendMailItem(i)
			if itemString and quantity then
				altPendingMail[itemString] = (altPendingMail[itemString] or 0) + quantity
			end
		end
	end)

	-- handle returning mail to alts
	hooksecurefunc("ReturnInboxItem", function(index)
		local character = private.ValidateCharacter(select(3, GetInboxHeaderInfo(index)))
		if not character then
			return
		end
		TSM.db.factionrealm.internalData.pendingMail[character] = TSM.db.factionrealm.internalData.pendingMail[character] or {}
		local altPendingMail = TSM.db.factionrealm.internalData.pendingMail[character]
		for i = 1, ATTACHMENTS_MAX_SEND do
			local itemString = TSMAPI_FOUR.Item.ToBaseItemString(GetInboxItemLink(index, i))
			local _, _, _, quantity = GetInboxItem(index, i)
			if itemString and quantity then
				altPendingMail[itemString] = (altPendingMail[itemString] or 0) + quantity
			end
		end
	end)
end

function MailTracking.CreateMailInboxQuery()
	return private.mailDB:NewQuery()
end

function MailTracking.CreateMailItemQuery()
	return private.itemDB:NewQuery()
end

function MailTracking.GetInboxItemLink(index)
	return private.GetInboxItemLink(index)
end

function MailTracking.GetMailType(index)
	return private.GetMailType(index)
end



-- ============================================================================
-- Event Handlers
-- ============================================================================

function private.MailShowHandler()
	private.isOpen = true
end

function private.MailClosedHandler()
	private.isOpen = false
end

function private.MailInboxUpdateHandler()
	if not private.isOpen then
		return
	end

	TSMAPI_FOUR.Delay.AfterFrame("mailInboxScan", 1, private.MailInboxUpdateDelayed)
end

function private.MailInboxUpdateDelayed()
	if not private.isOpen then
		return
	end

	private.mailDB:TruncateAndBulkInsertStart()
	private.itemDB:TruncateAndBulkInsertStart()

	TSM.Inventory.WipePendingMail(PLAYER_NAME)
	TSM.Inventory.WipeMailQuantity()

	local expiration = math.huge
	for i = 1, GetInboxNumItems() do
		local _, _, _, subject, money, cod, daysLeft, itemCount = GetInboxHeaderInfo(i)
		if itemCount and itemCount > 0 and money and money > 0 then
			expiration = min(expiration, time() + (daysLeft * 24 * 60 * 60))
		end
		local firstItemString = TSMAPI_FOUR.Item.ToItemString(private.GetInboxItemLink(i))
		local mailType = private.GetMailType(i) or ""
		if mailType == "BUY" then
			local _, _, _, bid = GetInboxInvoiceInfo(i)
			cod = bid
		end

		if money and money > 0 then
			private.itemDB:BulkInsertNewRow(i, 0, tostring(money), 0)
		end

		for j = 1, ATTACHMENTS_MAX do
			local itemString = TSMAPI_FOUR.Item.ToBaseItemString(GetInboxItemLink(i, j))
			local _, _, _, quantity = GetInboxItem(i, j)
			if itemString and quantity and quantity > 0 then
				TSM.Inventory.ChangeMailQuantity(itemString, quantity)
			end

			local itemLink = private.GetInboxItemLink(i, j)
			if itemLink and quantity and quantity > 0 then
				private.itemDB:BulkInsertNewRow(i, j, itemLink, quantity)
			end
		end

		private.mailDB:BulkInsertNewRow(i, mailType, subject or "--", firstItemString or "", itemCount or 0, money or 0, cod or 0, daysLeft)
	end

	private.itemDB:BulkInsertEnd()
	private.mailDB:BulkInsertEnd()

	TSM.db.factionrealm.internalData.expiringMail[PLAYER_NAME] = expiration ~= math.huge and expiration or nil
	TSM.TaskList.Expirations.UpdateDelayed()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ValidateCharacter(character)
	if not character then
		return
	end
	local characterName, realm = strsplit("-", strlower(character))
	-- we only care to track mails with characters on this realm
	if realm and realm ~= strlower(GetRealmName()) then
		return
	end
	-- we only care to track mails with characters on this account
	local result = nil
	for _, name in TSM.db:FactionrealmCharacterByAccountIterator() do
		if strlower(name) == characterName then
			result = name
		end
	end
	return result
end

function private.GetInboxItemLink(index, num)
	if not num then
		num = 1
	end

	if not private.tooltip then
		private.tooltip = CreateFrame("GameTooltip", "TSM4MailingInboxTooltip", UIParent, "GameTooltipTemplate")
	end

	private.tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	private.tooltip:ClearLines()

	local _, speciesId, level, breedQuality, maxHealth, power, speed = private.tooltip:SetInboxItem(index, num)
	local link
	if (speciesId or 0) > 0 then
		link = TSMAPI_FOUR.Item.GetLink(strjoin(":", "p", speciesId, level, breedQuality, maxHealth, power, speed))
	else
		link = GetInboxItemLink(index, num)
	end

	private.tooltip:Hide()

	return link
end

function private.GetMailType(index)
	local _, _, _, subject, money, cod, _, numItems, _, _, _, _, isGM = GetInboxHeaderInfo(index)

	if isGM or (cod and cod > 0) or (money == 0 and (not numItems or numItems == 0)) then
		return nil
	end

	local info = GetInboxInvoiceInfo(index)

	if money and money > 0 and info == "seller" then
		return "SALE"
	elseif numItems and numItems > 0 and info == "buyer" then
		return "BUY"
	elseif not info and numItems == 1 then
		local itemName = TSMAPI_FOUR.Item.GetName(private.GetInboxItemLink(index))
		if itemName then
			local _, _, _, quantity = GetInboxItem(index, 1)
			if quantity and quantity > 0 and (subject == format(AUCTION_REMOVED_MAIL_SUBJECT.." (%d)", itemName, quantity) or subject == format(AUCTION_REMOVED_MAIL_SUBJECT, itemName)) then
				return "CANCEL"
			end

			if itemName and strfind(subject, "^"..TSM.String.Escape(format(AUCTION_EXPIRED_MAIL_SUBJECT, itemName))) then
				return "EXPIRE"
			end
		end
	end

	return ""
end
