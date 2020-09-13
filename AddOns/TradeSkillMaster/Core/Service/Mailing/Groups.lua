-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Groups = TSM.Mailing:NewPackage("Groups")
local L = TSM.Include("Locale").GetTable()
local Log = TSM.Include("Util.Log")
local Threading = TSM.Include("Service.Threading")
local Inventory = TSM.Include("Service.Inventory")
local PlayerInfo = TSM.Include("Service.PlayerInfo")
local BagTracking = TSM.Include("Service.BagTracking")
local private = {
	thread = nil,
	sendDone = false,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Groups.OnInitialize()
	private.thread = Threading.New("MAIL_GROUPS", private.GroupsMailThread)
end

function Groups.KillThread()
	Threading.Kill(private.thread)
end

function Groups.StartSending(callback, groupList, sendRepeat, isDryRun)
	Threading.Kill(private.thread)

	Threading.SetCallback(private.thread, callback)
	Threading.Start(private.thread, groupList, sendRepeat, isDryRun)
end



-- ============================================================================
-- Group Sending Thread
-- ============================================================================

function private.GroupsMailThread(groupList, sendRepeat, isDryRun)
	while true do
		local targets = Threading.AcquireSafeTempTable()
		local numMailable = Threading.AcquireSafeTempTable()
		for _, groupPath in ipairs(groupList) do
			if groupPath ~= TSM.CONST.ROOT_GROUP_PATH then
				local used = Threading.AcquireSafeTempTable()
				local keep = Threading.AcquireSafeTempTable()
				for _, _, operationSettings in TSM.Operations.GroupOperationIterator("Mailing", groupPath) do
					local target = operationSettings.target
					if target ~= "" then
						local targetItems = targets[target] or Threading.AcquireSafeTempTable()
						for _, itemString in TSM.Groups.ItemIterator(groupPath) do
							itemString = TSM.Groups.TranslateItemString(itemString)
							used[itemString] = used[itemString] or 0
							keep[itemString] = max(keep[itemString] or 0, operationSettings.keepQty)
							numMailable[itemString] = numMailable[itemString] or BagTracking.GetNumMailable(itemString)
							local numAvailable = numMailable[itemString] - used[itemString] - keep[itemString]
							local quantity = private.GetItemQuantity(itemString, numAvailable, operationSettings)
							assert(quantity >= 0)
							if PlayerInfo.IsPlayer(target) then
								keep[itemString] = max(keep[itemString], quantity)
							else
								used[itemString] = used[itemString] + quantity
								if quantity > 0 then
									targetItems[itemString] = quantity
								end
							end
						end
						if next(targetItems) then
							targets[target] = targetItems
						else
							Threading.ReleaseSafeTempTable(targetItems)
						end
					end
				end
				Threading.ReleaseSafeTempTable(used)
				Threading.ReleaseSafeTempTable(keep)
			end
		end
		Threading.ReleaseSafeTempTable(numMailable)

		if not next(targets) then
			Log.PrintUser(L["Nothing to send."])
		end
		for name, items in pairs(targets) do
			private.SendItems(name, items, isDryRun)
			Threading.ReleaseSafeTempTable(items)
			Threading.Sleep(0.5)
		end

		Threading.ReleaseSafeTempTable(targets)

		if sendRepeat then
			Threading.Sleep(TSM.db.global.mailingOptions.resendDelay * 60)
		else
			break
		end
	end
end

function private.SendItems(target, items, isDryRun)
	private.sendDone = false
	TSM.Mailing.Send.StartSending(private.SendCallback, target, "", "", 0, items, true, isDryRun)
	while not private.sendDone do
		Threading.Yield(true)
	end
end

function private.SendCallback()
	private.sendDone = true
end

function private.GetItemQuantity(itemString, numAvailable, operationSettings)
	if numAvailable <= 0 then
		return 0
	end
	local numToSend = 0
	local isTargetPlayer = PlayerInfo.IsPlayer(operationSettings.target)
	if operationSettings.maxQtyEnabled then
		if operationSettings.restock then
			local targetQty = private.GetTargetQuantity(operationSettings.target, itemString, operationSettings.restockSources)
			if isTargetPlayer and targetQty <= operationSettings.maxQty then
				numToSend = numAvailable
			else
				numToSend = min(numAvailable, operationSettings.maxQty - targetQty)
			end
			if isTargetPlayer then
				numToSend = numAvailable - (targetQty - operationSettings.maxQty)
			end
		else
			numToSend = min(numAvailable, operationSettings.maxQty)
		end
	elseif not isTargetPlayer then
		numToSend = numAvailable
	end
	return max(numToSend, 0)
end

function private.GetTargetQuantity(player, itemString, sources)
	if player then
		player = strtrim(strmatch(player, "^[^-]+"))
	end
	local num = Inventory.GetBagQuantity(itemString, player) + Inventory.GetMailQuantity(itemString, player) + Inventory.GetAuctionQuantity(itemString, player)
	if sources then
		if sources.guild then
			num = num + Inventory.GetGuildQuantity(itemString, PlayerInfo.GetPlayerGuild(player))
		end
		if sources.bank then
			num = num + Inventory.GetBankQuantity(itemString, player) + Inventory.GetReagentBankQuantity(itemString, player)
		end
	end

	return num
end
