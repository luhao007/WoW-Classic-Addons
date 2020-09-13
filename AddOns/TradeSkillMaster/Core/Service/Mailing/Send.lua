-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Send = TSM.Mailing:NewPackage("Send")
local L = TSM.Include("Locale").GetTable()
local Table = TSM.Include("Util.Table")
local Money = TSM.Include("Util.Money")
local SlotId = TSM.Include("Util.SlotId")
local Log = TSM.Include("Util.Log")
local ItemString = TSM.Include("Util.ItemString")
local Theme = TSM.Include("Util.Theme")
local Threading = TSM.Include("Service.Threading")
local ItemInfo = TSM.Include("Service.ItemInfo")
local InventoryInfo = TSM.Include("Service.InventoryInfo")
local BagTracking = TSM.Include("Service.BagTracking")
local private = {
	thread = nil,
	bagUpdate = nil,
}

local PLAYER_NAME = UnitName("player")
local PLAYER_NAME_REALM = string.gsub(PLAYER_NAME.."-"..GetRealmName(), "%s+", "")



-- ============================================================================
-- Module Functions
-- ============================================================================

function Send.OnInitialize()
	private.thread = Threading.New("MAIL_SENDING", private.SendMailThread)
	BagTracking.RegisterCallback(private.BagUpdate)
end

function Send.KillThread()
	Threading.Kill(private.thread)
end

function Send.StartSending(callback, recipient, subject, body, money, items, isGroup, isDryRun)
	Threading.Kill(private.thread)

	Threading.SetCallback(private.thread, callback)
	Threading.Start(private.thread, recipient, subject, body, money, items, isGroup, isDryRun)
end



-- ============================================================================
-- Mail Sending Thread
-- ============================================================================

function private.SendMailThread(recipient, subject, body, money, items, isGroup, isDryRun)
	if recipient == "" or recipient == PLAYER_NAME or recipient == PLAYER_NAME_REALM then
		return
	end

	private.PrintMailMessage(money, items, recipient, isGroup, isDryRun)
	if isDryRun then
		return
	end

	if not items then
		private.SendMail(recipient, subject, body, money, true)
		return
	end

	ClearSendMail()
	local itemInfo = Threading.AcquireSafeTempTable()

	local query = BagTracking.CreateQueryBags()
		:OrderBy("slotId", true)
		:Select("bag", "slot", "itemString", "quantity")
		:Equal("isBoP", false)
	for _, bag, slot, itemString, quantity in query:Iterator() do
		if isGroup then
			itemString = TSM.Groups.TranslateItemString(itemString)
		end
		if items[itemString] and not InventoryInfo.IsBagSlotLocked(bag, slot) then
			if not itemInfo[itemString] then
				itemInfo[itemString] = { locations = {} }
			end
			tinsert(itemInfo[itemString].locations, { bag = bag, slot = slot, quantity = quantity })
		end
	end
	query:Release()

	for itemString, quantity in pairs(items) do
		if quantity > 0 and itemInfo[itemString] and #itemInfo[itemString].locations > 0 then
			for i = 1, #itemInfo[itemString].locations do
				local info = itemInfo[itemString].locations[i]
				if info.quantity > 0 then
					if quantity == info.quantity then
						PickupContainerItem(info.bag, info.slot)
						ClickSendMailItemButton()

						if private.GetNumPendingAttachments() == ATTACHMENTS_MAX_SEND or (isGroup and TSM.db.global.mailingOptions.sendItemsIndividually) then
							private.SendMail(recipient, subject, body, money)
						end

						items[itemString] = 0
						info.quantity = 0

						break
					end
				end
			end
		end
	end

	for itemString in pairs(items) do
		if items[itemString] > 0 and itemInfo[itemString] and #itemInfo[itemString].locations > 0 then
			local emptySlotIds = private.GetEmptyBagSlotsThreaded(ItemString.IsItem(itemString) and GetItemFamily(ItemString.ToId(itemString)) or 0)
			for i = 1, #itemInfo[itemString].locations do
				local info = itemInfo[itemString].locations[i]
				if items[itemString] > 0 and info.quantity > 0 then
					if items[itemString] < info.quantity then
						if #emptySlotIds > 0 then
							local splitBag, splitSlot = SlotId.Split(tremove(emptySlotIds, 1))
							SplitContainerItem(info.bag, info.slot, items[itemString])
							PickupContainerItem(splitBag, splitSlot)
							Threading.WaitForFunction(private.BagSlotHasItem, splitBag, splitSlot)
							PickupContainerItem(splitBag, splitSlot)
							ClickSendMailItemButton()

							if private.GetNumPendingAttachments() == ATTACHMENTS_MAX_SEND then
								private.SendMail(recipient, subject, body, money)
							end

							items[itemString] = 0
							info.quantity = 0

							break
						end
					else
						PickupContainerItem(info.bag, info.slot)
						ClickSendMailItemButton()

						if private.GetNumPendingAttachments() == ATTACHMENTS_MAX_SEND then
							private.SendMail(recipient, subject, body, money)
						end

						items[itemString] = items[itemString] - info.quantity
						info.quantity = 0
					end
				end
			end

			if isGroup and TSM.db.global.mailingOptions.sendItemsIndividually then
				private.SendMail(recipient, subject, body, money)
			end
			Threading.ReleaseSafeTempTable(emptySlotIds)
		end
	end

	if private.HasPendingAttachments() then
		private.SendMail(recipient, subject, body, money)
	end

	Threading.ReleaseSafeTempTable(itemInfo)
end

function private.PrintMailMessage(money, items, target, isGroup, isDryRun)
	if not TSM.db.global.mailingOptions.sendMessages and not isDryRun then
		return
	end
	if money > 0 and not items then
		Log.PrintfUser(L["Sending %s to %s"], Money.ToString(money), target)
		return
	end

	if not items then
		return
	end

	local itemList = ""
	for k, v in pairs(items) do
		local coloredItem = ItemInfo.GetLink(k)
		itemList = itemList..coloredItem.."x"..v..", "
	end
	itemList = strtrim(itemList, ", ")

	if next(items) and money < 0 then
		if isDryRun then
			Log.PrintfUser(L["Would send %s to %s with a COD of %s"], itemList, target, Money.ToString(money, Theme.GetFeedbackColor("RED"):GetTextColorPrefix()))
		else
			Log.PrintfUser(L["Sending %s to %s with a COD of %s"], itemList, target, Money.ToString(money, Theme.GetFeedbackColor("RED"):GetTextColorPrefix()))
		end
	elseif next(items) then
		if isDryRun then
			Log.PrintfUser(L["Would send %s to %s"], itemList, target)
		else
			Log.PrintfUser(L["Sending %s to %s"], itemList, target)
		end
	end
end

function private.SendMail(recipient, subject, body, money, noItem)
	if subject == "" then
		local text = SendMailSubjectEditBox:GetText()
		subject = text ~= "" and text or "TSM Mailing"
	end

	if money > 0 then
		SetSendMailMoney(money)
		SetSendMailCOD(0)
	elseif money < 0 then
		SetSendMailCOD(abs(money))
		SetSendMailMoney(0)
	else
		SetSendMailMoney(0)
		SetSendMailCOD(0)
	end

	private.bagUpdate = false
	SendMail(recipient, subject, body)

	if Threading.WaitForEvent("MAIL_SUCCESS", "MAIL_FAILED") == "MAIL_SUCCESS" then
		if noItem then
			Threading.Sleep(0.5)
		else
			Threading.WaitForFunction(private.HasNewBagUpdate)
		end
	else
		Threading.Sleep(0.5)
	end
end

function private.BagUpdate()
	private.bagUpdate = true
end

function private.HasNewBagUpdate()
	return private.bagUpdate
end

function private.HasPendingAttachments()
	for i = 1, ATTACHMENTS_MAX_SEND do
		if GetSendMailItem(i) then
			return true
		end
	end

	return false
end

function private.GetNumPendingAttachments()
	local totalAttached = 0
	for i = 1, ATTACHMENTS_MAX_SEND do
		if GetSendMailItem(i) then
			totalAttached = totalAttached + 1
		end
	end

	return totalAttached
end

function private.BagSlotHasItem(bag, slot)
	return GetContainerItemInfo(bag, slot) and true or false
end

function private.GetEmptyBagSlotsThreaded(itemFamily)
	local emptySlotIds = Threading.AcquireSafeTempTable()
	local sortvalue = Threading.AcquireSafeTempTable()
	for bag = 0, NUM_BAG_SLOTS do
		-- make sure the item can go in this bag
		local bagFamily = bag ~= 0 and GetItemFamily(GetInventoryItemLink("player", ContainerIDToInventoryID(bag))) or 0
		if bagFamily == 0 or bit.band(itemFamily, bagFamily) > 0 then
			for slot = 1, GetContainerNumSlots(bag) do
				if not GetContainerItemInfo(bag, slot) then
					local slotId = SlotId.Join(bag, slot)
					tinsert(emptySlotIds, slotId)
					-- use special bags first
					sortvalue[slotId] = slotId + (bagFamily > 0 and 0 or 100000)
				end
			end
		end
		Threading.Yield()
	end
	Table.SortWithValueLookup(emptySlotIds, sortvalue)
	Threading.ReleaseSafeTempTable(sortvalue)

	return emptySlotIds
end
