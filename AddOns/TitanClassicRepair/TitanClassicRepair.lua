-- **************************************************************************
-- * TitanRepair.lua
-- *
-- * By: Adsertor, Archarodim and the Titan Panel Development Team
-- **************************************************************************

-- ******************************** Constants *******************************
local TITAN_REPAIR_ID = "Repair";
local L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true)
local TitanRepairModule = LibStub("AceAddon-3.0"):NewAddon("TitanRepair", "AceHook-3.0", "AceTimer-3.0")
local _G = getfenv(0);
local TPR = TitanRepairModule
TPR.ITEM_STATUS = {};
TPR.ITEM_BAG = {};

-- this index (0) will never be set, just accessed to this state,
-- it simplifies code for TitanRepair_GetMostDamagedItem() when Tit_R_EquipedMinIndex == 0
TPR.END=12
TPR.ITEM_STATUS[0] = { values = {}, name = INVTYPE_HEAD, slot = "VIRTUAL" };
TPR.ITEM_STATUS[1] = { values = {}, name = INVTYPE_HEAD, slot = INVSLOT_HEAD };
TPR.ITEM_STATUS[2] = { values = {}, name = INVTYPE_SHOULDER, slot = INVSLOT_SHOULDER };
TPR.ITEM_STATUS[3] = { values = {}, name = INVTYPE_CHEST, slot = INVSLOT_CHEST };
TPR.ITEM_STATUS[4] = { values = {}, name = INVTYPE_WAIST, slot = INVSLOT_WAIST };
TPR.ITEM_STATUS[5] = { values = {}, name = INVTYPE_LEGS, slot = INVSLOT_LEGS };
TPR.ITEM_STATUS[6] = { values = {}, name = INVTYPE_FEET, slot = INVSLOT_FEET };
TPR.ITEM_STATUS[7] = { values = {}, name = INVTYPE_WRIST, slot = INVSLOT_WRIST };
TPR.ITEM_STATUS[8] = { values = {}, name = INVTYPE_HAND, slot = INVSLOT_HAND };
TPR.ITEM_STATUS[9] = { values = {}, name = INVTYPE_WEAPONMAINHAND, slot = INVSLOT_MAINHAND };
TPR.ITEM_STATUS[10] = { values = {}, name = INVTYPE_WEAPONOFFHAND, slot = INVSLOT_OFFHAND };
--TPR.ITEM_STATUS[10] = { values = {}, name = INVTYPE_WEAPONOFFHAND, slot = "SecondaryHand" };
TPR.ITEM_STATUS[11] = { values = {}, name = INVTYPE_RANGED, slot = INVSLOT_RANGED }; -- Ranged weapons are back in Classic
TPR.ITEM_STATUS[TPR.END] = { values = {}, name = INVENTORY_TOOLTIP };
TPR.INVENTORY_STATUS = {}
TPR.INVENTORY_STATUS[0] = { values = {}, name = INVENTORY_TOOLTIP };
TPR.INVENTORY_STATUS[1] = { values = {}, name = INVENTORY_TOOLTIP };
TPR.INVENTORY_STATUS[2] = { values = {}, name = INVENTORY_TOOLTIP };
TPR.INVENTORY_STATUS[3] = { values = {}, name = INVENTORY_TOOLTIP };
TPR.INVENTORY_STATUS[4] = { values = {}, name = INVENTORY_TOOLTIP };

-- ******************************** Variables *******************************
TPR.INDEX = 0;
TPR.MONEY = 0;
TPR.WholeScanInProgress = false;
TPR.EquipedMinIndex = 0; -- keep a record of the most damaged equiped item (used when removing the most damaged item placed in the inventory to switch on an equiped index)
TPR.PleaseCheckBag = { };
TPR.CouldRepair = false;
TPR.MerchantisOpen = false;
TPR.PleaseCheckBag[0] = 0; -- TPR.PleaseCheckBag element values meaning:
TPR.PleaseCheckBag[1] = 0; --  0 means "This bag did not changed, no need to scan it"
TPR.PleaseCheckBag[2] = 0; --  1 means "Please Check This Bag"
TPR.PleaseCheckBag[3] = 0; --  2 means "Yes I'm checking, don't disturb me"
TPR.PleaseCheckBag[4] = 0;
TPR.PleaseCheckBag[5] = 0; -- this will be used for equiped items, not very good but simplify the code...
TPR.show_debug = false; -- will tell you a lot about what's happening

StaticPopupDialogs["REPAIR_CONFIRMATION"] = {
	text = L["REPAIR_LOCALE"]["confirmation"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		TitanRepair_RepairItems();
		TitanPanelRepairButton_ScanAllItems();
		TitanRepairModule:CancelAllTimers()
		TitanRepairModule:ScheduleTimer(TitanPanelRepairButton_OnUpdate, 2)
		TPR.CouldRepair = false;
	end,
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, TPR.MONEY);
	end,
	hasMoneyFrame = 1,
	timeout = 0,
	hideOnEscape = 1
};

-- ******************************** Functions *******************************

-- **************************************************************************
-- NAME : TitanPanelRepairButton_OnLoad(self)
-- DESC : Registers the plugin upon it loading
-- **************************************************************************
function TitanPanelRepairButton_OnLoad(self)
	self.registry = {
		id = TITAN_REPAIR_ID,
		category = "Built-ins",
		version = TITAN_VERSION,
		menuText = L["REPAIR_LOCALE"]["menu"],
		buttonTextFunction = "TitanPanelRepairButton_GetButtonText",
		tooltipTitle = L["REPAIR_LOCALE"]["tooltip"],
		tooltipTextFunction = "TitanPanelRepairButton_GetTooltipText",
		icon = "Interface\\AddOns\\TitanClassicRepair\\TitanClassicRepair",
		iconWidth = 16,
		controlVariables = {
			ShowIcon = true,
			ShowLabelText = true,
			ShowRegularText = false,
			ShowColoredText = true,
			DisplayOnRightSide = true,
		},
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
			ShowMostDamaged = false,
			ShowUndamaged = false,
			ShowPopup = false,
			ShowDurabilityFrame = 1,
			AutoRepair = false,
			DiscountFriendly = false,
			DiscountHonored = false,
			DiscountPVP = false,
			DiscountCombined = false,
			ShowPercentage = false,
			ShowColoredText = false,
			ShowInventory = false,
			ShowRepairCost = 1,
			ShowMostDmgPer = 1,
			IgnoreThrown = false,
			UseGuildBank = false,
			AutoRepairReport = false,
			ShowItems = true,
			ShowDiscounts = true,
			ShowCosts = true,
			DisplayOnRightSide = false,
		}
	};

	self:RegisterEvent("PLAYER_LEAVING_WORLD");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");

	-- (re)set the status structures we need to change & store
	for i = 0, table.getn(TPR.ITEM_STATUS) do
		TitanPanelRepairButton_ResetStatus(TPR.ITEM_STATUS[i].values)
	end
	for i = 0, table.getn(TPR.INVENTORY_STATUS) do
		TitanPanelRepairButton_ResetStatus(TPR.INVENTORY_STATUS[i].values)
	end
end

-- **************************************************************************
-- NAME : TitanPanelRepairButton_ResetStatus(status)
-- DESC : Reset the record to default values
-- VARS : status = the record to (re)set values for
-- **************************************************************************
function TitanPanelRepairButton_ResetStatus(status)
	status.max = 0
	status.val = 0
	status.cost = 0
	status.item_name = ""
	status.item_type = ""
	status.item_subtype = ""
	status.item_quality = ""
	status.item_color = ""
	status.item_frac = 1.0
end

-- **************************************************************************
-- NAME : TitanPanelRepairButton_ScanAllItems()
-- DESC : Set all bags and equipment to be scanned
--        and set the 'scan in progress'
-- **************************************************************************
function TitanPanelRepairButton_ScanAllItems()
-- if (TitanGetVar(TITAN_REPAIR_ID,"ShowInventory") == 1) then
	TPR.PleaseCheckBag[0] = 1;
	TPR.PleaseCheckBag[1] = 1;
	TPR.PleaseCheckBag[2] = 1;
	TPR.PleaseCheckBag[3] = 1;
	TPR.PleaseCheckBag[4] = 1;
-- end
	TPR.PleaseCheckBag[5] = 1;
	TPR.WholeScanInProgress = true;
	TitanPanelButton_UpdateButton(TITAN_REPAIR_ID);
end

-- **************************************************************************
-- NAME : TitanPanelRepairButton_OnEvent(self, event, a1, ...)
-- DESC : This section will grab the events registered to the add on and act on them
-- **************************************************************************
function TitanPanelRepairButton_OnEvent(self, event, a1, ...)

-- NOTE that events test are done in probability order:
-- The events that fires the most are tested first
	if (TPR.show_debug) then -- this is not necessary but is here to optimize this part the most possible
		tit_debug_bis("Event " .. event .. "...");
	end

	if event == "UNIT_INVENTORY_CHANGED" and a1 == "player" then
		TPR.PleaseCheckBag[5] = 1
		TitanRepairModule:CancelAllTimers()
		TitanRepairModule:ScheduleTimer(TitanPanelRepairButton_OnUpdate, 1)
		return
	end

	if event == "PLAYER_MONEY" and TPR.MerchantisOpen == true and CanMerchantRepair() then
		TitanPanelRepairButton_ScanAllItems()
		TitanRepairModule:CancelAllTimers()
		TitanRepairModule:ScheduleTimer(TitanPanelRepairButton_OnUpdate, 1)
		return
	end

	if event == "PLAYER_REGEN_ENABLED" then
		TitanPanelRepairButton_ScanAllItems()
		TitanPanelRepairButton_OnUpdate()
		return
	end

	if event == "PLAYER_DEAD" then
		TitanPanelRepairButton_ScanAllItems()
		TitanPanelRepairButton_OnUpdate()
		return
	end

	if event == "PLAYER_UNGHOST" then
		TitanPanelRepairButton_ScanAllItems()
		TitanPanelRepairButton_OnUpdate()
		return
	end

	if (event == "UPDATE_INVENTORY_ALERTS") then
		-- register to check the equiped items on next appropriate OnUpdate call
		if (TPR.show_debug) then -- this is not necessary but is here to optimize this part the most possible
			tit_debug_bis("Event " .. event .. " TREATED!");
		end
		TPR.PleaseCheckBag[5] = 1;
		TitanPanelRepairButton_OnUpdate()
		return;
	end

	-- when a1 is > 4 it means that a bank's bag has been updated
	if ( (event == "BAG_UPDATE")
		and (a1 < 5)
		--and (TitanGetVar(TITAN_REPAIR_ID,"ShowInventory") == 1)
		)
	then
		-- register to check this bag's items on next appropriate OnUpdate call
		if (TPR.show_debug) then -- this if is not necessary but is here to optimize this part the most possible
			tit_debug_bis("Event " .. event .. " TREATED!");
		end

		TPR.PleaseCheckBag[5] = 1;
		TPR.PleaseCheckBag[a1] = 1;
		TitanRepairModule:CancelAllTimers()
		TitanRepairModule:ScheduleTimer(TitanPanelRepairButton_OnUpdate, 3)
		return;
	end

	if (event == "MERCHANT_SHOW") then
		TPR.MerchantisOpen = true;
		local canRepair = CanMerchantRepair();
		if not canRepair then
			return;
		end
		--if (TitanGetVar(TITAN_REPAIR_ID,"ShowInventory") == 1) then
		TPR.PleaseCheckBag[0] = 1;
		TPR.PleaseCheckBag[1] = 1;
		TPR.PleaseCheckBag[2] = 1;
		TPR.PleaseCheckBag[3] = 1;
		TPR.PleaseCheckBag[4] = 1;
		--end
		TPR.PleaseCheckBag[5] = 1;
		TitanPanelRepairButton_OnUpdate()
		if TitanGetVar(TITAN_REPAIR_ID,"ShowPopup") == 1 then
			local repairCost, canRepair = GetRepairAllCost();
			if (canRepair) then
				TPR.CouldRepair = true;
				if (repairCost > 0) then
					TPR.MONEY = repairCost;
					StaticPopup_Show("REPAIR_CONFIRMATION");
				end
			end
		end
		-- handle auto-repair
		if (TitanGetVar(TITAN_REPAIR_ID,"AutoRepair") == 1) then
			local repairCost, canRepair = GetRepairAllCost();
			if (canRepair) then
				TPR.CouldRepair = true;
				if (repairCost > 0) then
					TitanRepair_RepairItems();
					TitanPanelRepairButton_ScanAllItems();
					TitanRepairModule:CancelAllTimers()
					TitanRepairModule:ScheduleTimer(TitanPanelRepairButton_OnUpdate, 2)
					TPR.CouldRepair = false;
				end
			end
		end
		return;
	end

	if ( event == "MERCHANT_CLOSED" ) then
		TitanRepairModule:CancelAllTimers()
		TPR.MerchantisOpen = false;
		StaticPopup_Hide("REPAIR_CONFIRMATION");
		-- When an object is repaired in a bag,
		-- the BAG_UPDATE event is not sent
		-- so we rescan all
		if (TPR.CouldRepair) then
			TitanPanelRepairButton_ScanAllItems();
			TitanRepairModule:ScheduleTimer(TitanPanelRepairButton_OnUpdate, 1)
			TPR.CouldRepair = false;
		else
			--if (TitanGetVar(TITAN_REPAIR_ID,"ShowInventory") == 1) then
			TPR.PleaseCheckBag[0]  = 1;
			TPR.PleaseCheckBag[1]  = 1;
			TPR.PleaseCheckBag[2]  = 1;
			TPR.PleaseCheckBag[3]  = 1;
			TPR.PleaseCheckBag[4]  = 1;
			--end
			TPR.PleaseCheckBag[5] = 1;
			TitanRepairModule:ScheduleTimer(TitanPanelRepairButton_OnUpdate, 1)
		end
		return;
	end

	if (event == "PLAYER_ENTERING_WORLD") then
		self:RegisterEvent("BAG_UPDATE");
		self:RegisterEvent("UPDATE_INVENTORY_ALERTS");
		self:RegisterEvent("MERCHANT_SHOW");
		self:RegisterEvent("MERCHANT_CLOSED");
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_DEAD")
		self:RegisterEvent("PLAYER_UNGHOST")
		self:RegisterEvent("PLAYER_MONEY");
		self:RegisterEvent("UNIT_INVENTORY_CHANGED");
		-- Check everything on world enter (at init and after zoning)
		TitanPanelRepairButton_ScanAllItems();
		TitanPanelRepairButton_OnUpdate()
		TitanRepair_DurabilityFrame();
		return;
	end

	if (event == "PLAYER_LEAVING_WORLD") then
		self:UnregisterEvent("BAG_UPDATE");
		self:UnregisterEvent("UPDATE_INVENTORY_ALERTS");
		self:UnregisterEvent("MERCHANT_SHOW");
		self:UnregisterEvent("MERCHANT_CLOSED");
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("PLAYER_DEAD")
		self:UnregisterEvent("PLAYER_UNGHOST")
		self:UnregisterEvent("PLAYER_MONEY");
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED");
		return;
	end
end

-- **************************************************************************
-- NAME : tit_debug_bis(Message)
-- DESC : Debug function to print message to chat frame
-- VARS : Message = message to print to chat frame
-- **************************************************************************
function tit_debug_bis(Message)
	if (TPR.show_debug) then
		DEFAULT_CHAT_FRAME:AddMessage("TiT_Rep: " .. Message, 1.00, 0.49, 0.04);
	end
end


-- **************************************************************************
-- NAME : TitanPanelRepairButton_OnUpdate(self, Elapsed)
-- DESC : <research>
-- VARS : elapsed = <research>
-- **************************************************************************
function TitanPanelRepairButton_OnUpdate()
	-- test if a "bag" needs to be scanned
	for tocheck = 0, 5 do
		-- if there is one
		if TPR.PleaseCheckBag[tocheck] == 1 then
			-- we are checking...
			TPR.PleaseCheckBag[tocheck] = 2
			if (tocheck ~= 5) then  -- call update inventory function (I've put this test first because there is 5 chances on 6 that it returns true)
				tit_debug_bis("Update: Checking bag " .. tocheck .. " as requested");
				TitanRepair_GetInventoryInformation(tocheck);
			else -- call update equiped items function
				tit_debug_bis("Update: Checking equiped items as requested");
				TitanRepair_GetEquipedInformation();
			end
			-- test if another check was requested during this update
			-- (avoid to missing something... rare but still)
			if TPR.PleaseCheckBag[tocheck] ~= 1 then
				-- Check completed
				TPR.PleaseCheckBag[tocheck] = 0;
			end
		end
	end
end;

-- **************************************************************************
-- NAME : TitanRepair_GetStatusPercent(val, max)
-- DESC : <research>
-- VARS : val = <research>, max = <research>
-- **************************************************************************
function TitanRepair_GetStatusPercent(val, max)

	-- if max or val are nil then there are other issues but at least return something
	if (max and val) then
		if (max and max > 0) then
			return (val / max);
		end
	end
	return 1.0;
end;

-- **************************************************************************
-- NAME : TitanRepair_GetMostDamagedItem()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_GetMostDamagedItem()
	-- Get repair status for Equiped items and inventory
	-- NOTE: TitanRepair_GetStatusPercent() will return 1.0 if max value <= 0
	local equip_status = TPR.ITEM_STATUS[TPR.EquipedMinIndex].values
	local inv_status = TPR.ITEM_STATUS[TPR.END].values
	local EquipedItemsStatus   = equip_status.item_frac;
	local InventoryItemsStatus = inv_status.item_frac;

	-- if everything is repaired
	if (EquipedItemsStatus == 1.0 and InventoryItemsStatus == 1.0) then
		tit_debug_bis("Everything is repaired");
		return 0;
	end

	-- If something is more or equally damaged than the current most damaged equiped item
	--
	-- NOTE: The <= is important because InventoryItemsStatus is updated BEFORE EquipedItemsStatus
	-- The typical case is when you move the most damaged equiped item to your iventory,
	-- when this function will be called by TitanRepair_GetInventoryInformation(), TPR.EquipedMinIndex will point to an empty slot:
	-- since TitanRepair_GetEquipedInformation() won't have been called yet (bag update events are treated before equiped item event),
	-- EquipedItemsStatus will be egual to InventoryItemsStatus...
	-- So the <= is to avoid that TPR.EquipedMinIndex points to nothing
	-- (even if it has no concequence right now, it may save hours of debugging some day...)

	if ( (InventoryItemsStatus <= EquipedItemsStatus)
	and (TitanGetVar(TITAN_REPAIR_ID,"ShowInventory") == 1) ) then
		tit_debug_bis("Inventory is more damaged than equiped items");
		return TPR.END;
	else -- if EquipedItemsStatus < InventoryItemsStatus
		tit_debug_bis("Equiped items are more damaged than inventory");
		return TPR.EquipedMinIndex;
	end

	-- Typical 6 possibilities:
	-- - InventoryItemsStatus == 1 and EquipedItemsStatus == 1 ==> returns 0
	-- - InventoryItemsStatus < 1 and EquipedItemsStatus == 1 ==> returns TPR.END
	-- - InventoryItemsStatus == 1 and EquipedItemsStatus < 1 ==> ! (InventoryItemsStatus <= EquipedItemsStatus) ==> returns TPR.EquipedMinIndex
	-- - InventoryItemsStatus < 1 and EquipedItemsStatus < 1 :
	-- - InventoryItemsStatus <= EquipedItemsStatus ==> returns TPR.END
	-- - InventoryItemsStatus > EquipedItemsStatus ==> ! (InventoryItemsStatus <= EquipedItemsStatus) ==> returns TPR.EquipedMinIndex

end;

-- **************************************************************************
-- NAME : TitanRepair_GetInventoryInformation(bag)
-- DESC : <research>
-- VARS : bag = <research>
-- **************************************************************************
function TitanRepair_GetInventoryInformation(bag)

 -- check to see if a merchant that can repair is open
	if TPR.MerchantisOpen then
		local canRepair = CanMerchantRepair();
		if not canRepair then
			return;
		end
	end

	local min_status = 1.0;
	local min_val = 0;
	local min_max = 0;

	TitanRepairTooltip:SetOwner(UIParent, "ANCHOR_NONE");

	if (bag > 4) then -- should never get true though, bag > 4 are for the bank's bags
		return;
	end

	-- we re-scan the whole bag so we reset its status
	TPR.INVENTORY_STATUS[bag].values.val = 0
	TPR.INVENTORY_STATUS[bag].values.max = 0
	TPR.INVENTORY_STATUS[bag].values.cost = 0
	for slot = 1, GetContainerNumSlots(bag) do
		-- retrieve item repair status of this slot in the bag
		local act_status, act_val, act_max, act_cost = TitanRepair_GetStatus(slot, bag);
		if act_max ~= 0 then
			TPR.INVENTORY_STATUS[bag].values.val = TPR.INVENTORY_STATUS[bag].values.val + act_val;
			TPR.INVENTORY_STATUS[bag].values.max = TPR.INVENTORY_STATUS[bag].values.max + act_max;
		end
		-- add this item cost to this bag global repair cost
		TPR.INVENTORY_STATUS[bag].values.cost = TPR.INVENTORY_STATUS[bag].values.cost + act_cost;
	end

	-- Recalc the total repair of all bags
	TPR.ITEM_STATUS[TPR.END].values.val = 0
	TPR.ITEM_STATUS[TPR.END].values.max = 0
	TPR.ITEM_STATUS[TPR.END].values.cost = 0
	for bag = 0, 4 do
		local act_val		= TPR.INVENTORY_STATUS[bag].values.val ;
		local act_max		= TPR.INVENTORY_STATUS[bag].values.max ;
		local act_cost		= TPR.INVENTORY_STATUS[bag].values.cost ;
		local act_status	= TPR.INVENTORY_STATUS[bag].values.item_frac;

		TPR.ITEM_STATUS[TPR.END].values.val = TPR.ITEM_STATUS[TPR.END].values.val + act_val;
		TPR.ITEM_STATUS[TPR.END].values.max = TPR.ITEM_STATUS[TPR.END].values.max + act_max;
		-- add each bag global repair cost to inventory global repair cost
		TPR.ITEM_STATUS[TPR.END].values.cost = TPR.ITEM_STATUS[TPR.END].values.cost + act_cost;
	end
	TPR.ITEM_STATUS[TPR.END].values.item_frac =
	TitanRepair_GetStatusPercent(TPR.ITEM_STATUS[TPR.END].values.val, TPR.ITEM_STATUS[TPR.END].values.max)

	TPR.INDEX = TitanRepair_GetMostDamagedItem();

	tit_debug_bis("(inv) REPAIR_INDEX=" ..TPR.INDEX );

	-- Update the button text only if we are not waiting for TitanRepair_GetEquipedInformation()
	-- else an incorrect value may be displayed till TitanRepair_GetEquipedInformation() is called
	-- if a whole scan is in progress we update the button ("Updating..." is displayed in that case, so incorrect values are acceptable)
	if ( (TPR.PleaseCheckBag[5] == 0) or TPR.WholeScanInProgress ) then
		TitanPanelButton_UpdateButton(TITAN_REPAIR_ID);
	else
		tit_debug_bis("Waiting for updating button text");
	end
	local frame = _G["TitanPanelRepairButton"]
	TitanPanelButton_UpdateTooltip(frame);
	TitanRepairTooltip:Hide();
end

-- **************************************************************************
-- NAME : TitanRepair_GetEquipedInformation()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_GetEquipedInformation()

	tit_debug_bis("_GetEquipedInfo Merchant=" ..(TPR.MerchantisOpen and "T" or "F") );
	-- check to see if a merchant that can repair is open
	if TPR.MerchantisOpen then
		local canRepair = CanMerchantRepair();
		if not canRepair then
			return;
		end
	end

	local min_status = 1.0;
	local min_val = 0;
	local min_max = 0;
	local min_index = 0;
	TPR.EquipedMinIndex = 0;

	TitanRepairTooltip:SetOwner(UIParent, "ANCHOR_NONE");

	tit_debug_bis("_GetEquipedInfo loop" );
	for index, value in pairs(INVENTORY_ALERT_STATUS_SLOTS) do -- index begins from 1
--		if index==11 then
			--do nothing
--		else
			local act_status, act_val, act_max, act_cost,
			itemName, itemType, itemSubType, itemRarity, itemColor = TitanRepair_GetStatus(index);
			if TitanGetVar(TITAN_REPAIR_ID,"IgnoreThrown")
				and itemSubType == INVTYPE_THROWN then
				-- do not use it per user request
				act_status = 1.0 -- act as if repaired
				act_val = act_max -- no durability hit
			else
				if ( act_status < min_status ) then
					min_status = act_status;
					min_val = act_val;
					min_max = act_max;
					min_index = index;
				end
			end

			-- this stores some extra information but it makes a quick
			-- lookup in the display parts of the code
			TPR.ITEM_STATUS[index].values.val = act_val;
			TPR.ITEM_STATUS[index].values.max = act_max;
			TPR.ITEM_STATUS[index].values.cost = act_cost;
			TPR.ITEM_STATUS[index].values.item_name = itemName;
			TPR.ITEM_STATUS[index].values.item_type = itemType;
			TPR.ITEM_STATUS[index].values.item_subtype = itemSubType;
			TPR.ITEM_STATUS[index].values.item_quality = itemRarity;
			TPR.ITEM_STATUS[index].values.item_color = itemColor;
			TPR.ITEM_STATUS[index].values.item_frac = act_status;
--		end
	end
	tit_debug_bis("_GetEquipedInfo loop end " .. (min_status or 0).. " | " ..(min_index or 0));
	TPR.EquipedMinIndex = min_index;

	TPR.INDEX = TitanRepair_GetMostDamagedItem();

	-- if a whole update is in progress, and we are here, then we have finished this whole update :)
	-- it has to be here because it changes the text of the button.
	if (TPR.WholeScanInProgress) then
		TPR.WholeScanInProgress = false;
	end

	tit_debug_bis("(equip) REPAIR_INDEX=" ..TPR.INDEX  .. "  min_index=" .. min_index);

	TitanPanelButton_UpdateButton(TITAN_REPAIR_ID);
	local frame = _G["TitanPanelRepairButton"]
	TitanPanelButton_UpdateTooltip(frame);
	TitanRepairTooltip:Hide();
end

-- **************************************************************************
-- NAME : TitanRepair_GetStatus(index, bag)
-- DESC : <research>
-- VARS : index = <research>, bag = <research>
-- **************************************************************************
function TitanRepair_GetStatus(index, bag)
	local _, curDurability, maxDurability, repairCost
	local hasItem, itemName, itemRarity, itemType, itemSubType, itemColor

	--tit_debug_bis("_GetStatus index="..(index or "NIL").." bag="..(bag or "NIL"))
	TitanRepairTooltip:ClearLines()

	if (bag) then
		_, repairCost = TitanRepairTooltip:SetBagItem(bag, index)
		curDurability, maxDurability = GetContainerItemDurability(bag, index)
	else
--		local slotName = TPR.ITEM_STATUS[index].slot.."Slot"
		--tit_debug_bis("_GetStatus index="..index..", slotName="..(slotName or "NIL"))
--		local slotId = GetInventorySlotInfo(slotName) or -1
		-- Had to change the lookup for Classic. Could not find the right lookup text for ranged so used the constants
		-- instead. The slot in the array above was changed to match.
		local slotId = TPR.ITEM_STATUS[index].slot or -1
		tit_debug_bis("_GetStatus index="..index..", slotId="..(slotId or "NIL"))
		hasItem, _, repairCost = TitanRepairTooltip:SetInventoryItem("player", slotId)
		--tit_debug_bis("_GetStatus slotName="..slotName..", slotId="..slotId..", hasItem="..(hasItem or 0))
		if hasItem then
			curDurability, maxDurability = GetInventoryItemDurability(slotId)
			itemName, _, itemRarity, _,	_, itemType, itemSubType = GetItemInfo(GetInventoryItemLink("player", slotId) or "")
			local r, g, b, hex = GetItemQualityColor(itemRarity or 1)
			itemColor = "|c"..hex
		end
	end

	-- Turn any NIL results into 0's
	repairCost = repairCost or 0
	curDurability = curDurability or 0
	maxDurability = maxDurability or 0

	--[[
	tit_debug_bis("_GetStatus: "
		.." curDur="..curDurability
		.." maxDur="..maxDurability
		.." rCost="..repairCost
		.." iName="..(itemName or 0)
		.." iType="..(itemType or 0)
		.." iSubType="..(itemSubType or 0)
		.." iRarity="..(itemRarity or 0)
		.." iColor="..(itemColor or 0)
	)
	--]]

	return
		TitanRepair_GetStatusPercent(curDurability, maxDurability),
		curDurability,
		maxDurability,
		repairCost,
		itemName,
		itemType,
		itemSubType,
		itemRarity,
		itemColor
end

-- **************************************************************************
-- NAME : TitanRepair_GetStatusStr(index, short)
-- DESC : <research>
-- VARS : index = <research>, short = <research>
-- **************************************************************************
TPR.LastKnownText = "";
TPR.LastKnownItemFrac = 1.0;
function TitanRepair_GetStatusStr(index, short)
	-- skip if fully repaired
	if (index == 0) then
		return TitanRepair_AutoHighlight(1.0, "100%");
	end

	local valueText = "";

	-- if used for button text
	if (short) then
		valueText = TPR.LastKnownText;
	end

	local item_status = TPR.ITEM_STATUS[index];
	local item_frac = item_status.values.item_frac;

	-- skip if empty slot
	if (item_status.max == 0) then
		if (short) then
			if (not TPR.WholeScanInProgress) then
				valueText =  TitanRepair_AutoHighlight(TPR.LastKnownItemFrac, valueText
					.. " (" .. L["REPAIR_LOCALE"]["WholeScanInProgress"] .. ")");
			else
				valueText =  TitanRepair_AutoHighlight(TPR.LastKnownItemFrac, valueText);
			end

			return valueText;
		else
			return nil;
		end
	end

	-- determine the percent or value per user request
	if (TitanGetVar(TITAN_REPAIR_ID,"ShowPercentage") or short) then
		valueText = string.format("%d%%", item_frac * 100);
	else
		valueText = string.format("%d / %d", item_status.values.val, item_status.values.max);
	end

	-- determine color
	valueText = TitanRepair_AutoHighlight(item_frac, valueText);

	-- determine the name
	local SlotID, itemColor, itemRarity;
	local itemName = "";
	local itemLabel = "";

	if (not short or TitanGetVar(TITAN_REPAIR_ID, "ShowMostDamaged")) then
		if item_status.slot ~=nil then
			if item_status.values.item_name==nil
			or item_status.values.item_name == "" then
				valueText = valueText .. " " .. LIGHTYELLOW_FONT_COLOR_CODE..item_status.name.._G["FONT_COLOR_CODE_CLOSE"];
				itemLabel = LIGHTYELLOW_FONT_COLOR_CODE..item_status.name.._G["FONT_COLOR_CODE_CLOSE"];
			else
				valueText = valueText .. " "
					..item_status.values.item_color
					..item_status.values.item_name;
				itemLabel = item_status.values.item_color..item_status.values.item_name;
			end
		else
			valueText = valueText .. " " .. LIGHTYELLOW_FONT_COLOR_CODE..item_status.name.._G["FONT_COLOR_CODE_CLOSE"];
			itemLabel = LIGHTYELLOW_FONT_COLOR_CODE..item_status.name.._G["FONT_COLOR_CODE_CLOSE"];
		end
	end

	-- add repair cost
	-- local item_cost = TitanRepair_GetCostStr(item_status.cost);
	local item_cost = TitanPanelRepair_GetTextGSC(item_status.values.cost);
	if (not TPR.MerchantisOpen) and (not TPR.WholeScanInProgress) then
		if TitanGetVar(TITAN_REPAIR_ID, "DiscountHonored") then
			item_cost = TitanPanelRepair_GetTextGSC(item_status.values.cost * 0.90);
		elseif TitanGetVar(TITAN_REPAIR_ID, "DiscountPVP") then
			item_cost = TitanPanelRepair_GetTextGSC(item_status.values.cost * 0.90);
		elseif TitanGetVar(TITAN_REPAIR_ID, "DiscountCombined") then
			item_cost = TitanPanelRepair_GetTextGSC(item_status.values.cost * 0.80);
		end
	end

	if ((not short) and item_cost and TitanGetVar(TITAN_REPAIR_ID,"ShowRepairCost")) then
		if (not TPR.MerchantisOpen) and (not TPR.WholeScanInProgress) then
			if TitanGetVar(TITAN_REPAIR_ID, "DiscountHonored") then
				valueText = valueText .. "\t" .. item_cost..TitanUtils_GetGreenText(" ("..FACTION_STANDING_LABEL6..")");
			elseif TitanGetVar(TITAN_REPAIR_ID, "DiscountPVP") then
                local start=string.find("(",L["REPAIR_LOCALE"]["pvp"]);
                local stop=string.find(")",L["REPAIR_LOCALE"]["pvp"],start+1);
				valueText = valueText .. "\t" .. item_cost..TitanUtils_GetGreenText(" ("..string.sub(L["REPAIR_LOCALE"]["pvp"], start+1, stop-1)..")");
			elseif TitanGetVar(TITAN_REPAIR_ID, "DiscountCombined") then
                local start=string.find("(",L["REPAIR_LOCALE"]["combined"]);
                local stop=string.find(")",L["REPAIR_LOCALE"]["combined"],start+1);
				valueText = valueText .. "\t" .. item_cost..TitanUtils_GetGreenText(" ("..string.sub(L["REPAIR_LOCALE"]["combined"], start+1, stop-1)..")");
			else
				valueText = valueText .. "\t" .. item_cost;
			end
		end
	end

	if (short) then
		local pos;
		pos = string.find(valueText, itemLabel, 1, true);
		if (pos) and itemLabel~= "" then
			valueText = string.sub(valueText,1,pos-1);
		end
		--valueText = string.gsub(valueText, itemLabel, "" );
		TPR.LastKnownText = valueText;
		TPR.LastKnownItemFrac = item_frac;
	end

	return valueText, itemLabel;

end

-- **************************************************************************
-- NAME : TitanRepair_AutoHighlight (item_frac, valueText)
-- DESC : <research>
-- VARS : item_frac = <research>, valueText = <research>
-- **************************************************************************
function TitanRepair_AutoHighlight (item_frac, valueText)
	-- I've changed this so when the ratio is 1, the text is green (green means OK for FPS, Latency, etc...)
	-- beneath 0.91 (so it can be true for 0.90) the text is white
	-- and red if the ratio reach 0.20
	-- I didn't check for <= 0.90 or <= 0.20 because fractional eguality test is not acurate...
	if (TitanGetVar(TITAN_REPAIR_ID, "ShowColoredText")) then
		if (item_frac == 0.0) then
			valueText = TitanUtils_GetRedText(valueText);
		elseif (item_frac < 0.21) then
			valueText = TitanUtils_GetNormalText(valueText);
		elseif (item_frac < 0.91) then
			valueText = TitanUtils_GetHighlightText(valueText);
		else
			valueText = TitanUtils_GetGreenText(valueText);
		end
	else
		valueText = TitanUtils_GetHighlightText(valueText);
	end

	return valueText;
end

function TitanRepair_GetCostStr(cost)
	if (cost > 0) then
		return TitanUtils_GetHighlightText(string.format("%.2fg" , cost / 10000));
	end

	return nil;
end

local function RepairSumTotals()
	local sums = {}
	if (not TPR.WholeScanInProgress) then

		local cost = 0;
		local sum = 0;
		local costStr = 0;
		local item_status = {};
		local item_frac = 0;
		local frac_counter = 0;
		local total_frac = 0;
		local inv_frac = 1 ;
		local duraitems = 0;

		-- calculate the totals
		-- traverse through the durability table and get the damage value,
		-- item_frac = 1 (undamaged), item_frac < 1 (damaged)
		for i = 1, table.getn(TPR.ITEM_STATUS) do
			item_status = TPR.ITEM_STATUS[i].values;
			item_frac = item_status.item_frac;
			-- set the inventory damage to a seperate variable
			if TPR.ITEM_STATUS[i].name == INVENTORY_TOOLTIP then
				inv_frac = item_frac;
				sums.inven_percent = item_frac ;
				sums.inven_cost = item_status.cost
				item_frac = 0;
			end

			if (item_status.max ~=0 and TPR.ITEM_STATUS[i].name ~= INVENTORY_TOOLTIP) then
				frac_counter = frac_counter + item_frac;
				duraitems = duraitems + 1;
				sums.equip_cost = (sums.equip_cost or 0) + item_status.cost
			end

			cost = item_status.cost;
			sum = sum + cost;
		end  -- for loop

		-- failsafe if you have no item with a valid durability value
		if duraitems == 0 then
			duraitems = 1;
			frac_counter = 1;
		end

		--total_frac = frac_counter / 11 ;
		sums.total_percent = (total_frac + inv_frac) / 2;
		sums.total_cost = sum
		sums.equip_percent = frac_counter / duraitems;

		sums.scan = false
	else
		sums.scan = true
	end

	return sums
end
-- **************************************************************************
-- NAME : TitanPanelRepairButton_GetButtonText(id)
-- DESC : <research>
-- VARS : id = <research>
-- **************************************************************************
function TitanPanelRepairButton_GetButtonText(id)
	local text, itemLabel = TitanRepair_GetStatusStr(TPR.INDEX, 1);
	local itemNamesToShow = "";
	local itemPercent = 0
	local itemCost = 0
	if TitanGetVar(TITAN_REPAIR_ID, "ShowMostDamaged") then
		itemPercent = (text or "")
		itemNamesToShow = (itemLabel or "")
	end
	-- supports turning off labels
	if (not TPR.WholeScanInProgress) then

		local cost = 0;
		local sum = 0;
		local costStr = 0;
		local item_status = {};
		local item_frac = 0;
		local frac_counter = 0;
		local total_frac = 0;
		local inv_frac = 1 ;
		local duraitems = 0;
		local discountlabel = "";
		local canRepair = false;

		if TitanGetVar(TITAN_REPAIR_ID, "ShowMostDamaged") then  -- most damaged
			--item_status = TPR.ITEM_STATUS[TPR.INDEX].values;
			total_frac = TPR.ITEM_STATUS[TPR.INDEX].values.item_frac;
			sum = TPR.ITEM_STATUS[TPR.INDEX].values.cost
		else -- calculate the totals
			-- traverse through the durability table and get the damage value,
			-- item_frac = 1 (undamaged), item_frac < 1 (damaged)
			for i = 1, table.getn(TPR.ITEM_STATUS) do
				item_status = TPR.ITEM_STATUS[i].values;
				item_frac = item_status.item_frac;
				-- set the inventory damage to a seperate variable
				if TPR.ITEM_STATUS[i].name == INVENTORY_TOOLTIP then
					inv_frac = item_frac;
					item_frac = 0;
				end

				if (item_status.max ~=0 and TPR.ITEM_STATUS[i].name ~= INVENTORY_TOOLTIP) then
					frac_counter = frac_counter + item_frac;
					duraitems = duraitems + 1;
				end

				cost = item_status.cost;
				sum = sum + cost;
			end  -- for loop

			-- failsafe if you have no item with a valid durability value
			if duraitems == 0 then
				duraitems = 1;
				frac_counter = 1;
			end

			--total_frac = frac_counter / 11 ;
			total_frac = frac_counter / duraitems ;

			if (TitanGetVar(TITAN_REPAIR_ID,"ShowInventory") == 1) then
				total_frac = (total_frac + inv_frac) / 2;
			end
		end  -- if "ShowMostDamaged"

		text = string.format("%d%%", total_frac * 100);
		text = TitanRepair_AutoHighlight (total_frac, text);

		-- check to see if a merchant that can repair is open
		if TPR.MerchantisOpen then
			canRepair = CanMerchantRepair();
		end

		if (not TPR.MerchantisOpen or (TPR.MerchantisOpen and not canRepair)) then
			if TitanGetVar(TITAN_REPAIR_ID, "DiscountFriendly") then
				sum = sum * 0.95;
				discountlabel = FACTION_STANDING_LABEL5;
			elseif TitanGetVar(TITAN_REPAIR_ID, "DiscountHonored") then
				sum = sum * 0.90;
				discountlabel = FACTION_STANDING_LABEL6;
			elseif TitanGetVar(TITAN_REPAIR_ID, "DiscountRevered") then
				sum = sum * 0.85;
				discountlabel = FACTION_STANDING_LABEL7;
			elseif TitanGetVar(TITAN_REPAIR_ID, "DiscountExalted") then
				sum = sum * 0.80;
				discountlabel = FACTION_STANDING_LABEL8;
			end  -- if merchant
		end  -- if discounts

		-- select which % to show
		if (TitanGetVar(TITAN_REPAIR_ID,"ShowMostDamaged")) then
			text = itemPercent.." " -- item %
		else
			text = text.." " -- total %
		end

		-- show cost per the user choice
		if (sum > 0 and TitanGetVar(TITAN_REPAIR_ID,"ShowRepairCost")) then
			costStr = "(".. TitanPanelRepair_GetTextGSC(sum)..") ";
			discountlabel = GREEN_FONT_COLOR_CODE..discountlabel..FONT_COLOR_CODE_CLOSE.." "
		else
			-- user does not want to see cost; clear the reputation also
			costStr = ""
			discountlabel = ""
		end

		-- Now that the pieces have been created, return the whole string
		return L["REPAIR_LOCALE"]["button"],
			text
			..costStr
			..discountlabel
			..itemNamesToShow
--			..(TitanGetVar(TITAN_REPAIR_ID,"ShowInventory" and "*" or "^"))
	else
		return L["REPAIR_LOCALE"]["button"],
			text .. " (" .. L["REPAIR_LOCALE"]["WholeScanInProgress"] .. ")";
	end
end


-- **************************************************************************
-- NAME : TitanPanelRepairButton_GetTooltipText()
-- DESC : <research>
-- **************************************************************************
function TitanPanelRepairButton_GetTooltipText()

	local out = "";
	local str = "";
	local label = "";
	local cost = 0;
	local sum = 0;

	-- Checking if the user wants to show items several times looks odd
	-- but we need to calc 'sum' and we need to format the tooltip
	if (TitanGetVar(TITAN_REPAIR_ID,"ShowItems")) then
		out = out..TitanUtils_GetGoldText(L["REPAIR_LOCALE"]["Items"])..TitanUtils_GetHighlightText("\n")
	end
	for i = 1, table.getn(TPR.ITEM_STATUS) do
		cost = TPR.ITEM_STATUS[i].values.cost;
		str, label = TitanRepair_GetStatusStr(i);

		sum = sum + cost;

		if (TitanGetVar(TITAN_REPAIR_ID,"ShowItems")) then
			if ((str) and (TitanGetVar(TITAN_REPAIR_ID,"ShowUndamaged") or (cost > 0))) then
				if TitanGetVar(TITAN_REPAIR_ID,"IgnoreThrown")
					and TPR.ITEM_STATUS[i].values.item_subtype == INVTYPE_THROWN then
					-- do not show it per user request
				else
					out = out .. str .. "\n";
				end
			end
		end
	end
	if (TitanGetVar(TITAN_REPAIR_ID,"ShowItems")) then
		out = out.."\n"
	end

	if (TitanGetVar(TITAN_REPAIR_ID,"ShowDiscounts")) then
		if (sum > 0) then
			out = out..TitanUtils_GetGoldText(L["REPAIR_LOCALE"]["Discounts"])..TitanUtils_GetHighlightText("")
			local costStr = TitanPanelRepair_GetTextGSC(sum);
			local costfrStr = TitanPanelRepair_GetTextGSC(sum * 0.95);
			local costhonStr = TitanPanelRepair_GetTextGSC(sum * 0.90);
			local costrevStr = TitanPanelRepair_GetTextGSC(sum * 0.85);
			local costexStr = TitanPanelRepair_GetTextGSC(sum * 0.80);
			if (costStr) then
				if TPR.MerchantisOpen then
					out = out .. "\n" .. TitanUtils_GetHighlightText(REPAIR_COST) .. " " .. costStr;
					local canRepair = CanMerchantRepair();
					if not canRepair then
						out = out .. "\n"
							.. GREEN_FONT_COLOR_CODE..L["REPAIR_LOCALE"]["badmerchant"];
					end
				else
					out = out .. "\n" .. TitanUtils_GetHighlightText(L["REPAIR_LOCALE"]["normal"]) .. "\t" .. costStr;
				end
				if (not TPR.MerchantisOpen) and (not TPR.WholeScanInProgress) then
					out = out .. "\n" .. TitanUtils_GetHighlightText(L["REPAIR_LOCALE"]["friendly"]) .. "\t" .. costfrStr;
					out = out .. "\n" .. TitanUtils_GetHighlightText(L["REPAIR_LOCALE"]["honored"]) .. "\t" .. costhonStr;
					out = out .. "\n" .. TitanUtils_GetHighlightText(L["REPAIR_LOCALE"]["revered"]) .. "\t" .. costrevStr;
					out = out .. "\n" .. TitanUtils_GetHighlightText(L["REPAIR_LOCALE"]["exalted"]) .. "\t" .. costexStr;
				end
			end
			out = out.."\n\n"
		end
	end

	if (TitanGetVar(TITAN_REPAIR_ID,"ShowCosts")) then
		out = out..TitanUtils_GetGoldText(L["REPAIR_LOCALE"]["Costs"])
		local sums = RepairSumTotals()
		out = out .. "\n" .. TitanUtils_GetHighlightText(L["REPAIR_LOCALE"]["CostTotal"]).. "\t" .. TitanPanelRepair_GetTextGSC(sums.total_cost)
		out = out .. "\n\n" .. TitanUtils_GetHighlightText(L["REPAIR_LOCALE"]["CostEquip"]).. "\t" .. TitanPanelRepair_GetTextGSC(sums.equip_cost)
		out = out .. "\n" .. TitanUtils_GetHighlightText(L["REPAIR_LOCALE"]["CostBag"]).. "\t" .. TitanPanelRepair_GetTextGSC(sums.inven_cost)
		out = out .. "\n\n"
	end

	return out;
end

-- **************************************************************************
-- NAME : TitanPanelRepair_GetGSC(money)
-- DESC : <research>
-- VARS : money = <research>
-- **************************************************************************
function TitanPanelRepair_GetGSC(money)
	local neg = false;
	if (money == nil) then money = 0; end
	if (money < 0) then
		neg = true;
		money = money * -1;
	end
	local g = math.floor(money / 10000);
	local s = math.floor((money - (g * 10000)) / 100);
	local c = math.floor(money - (g * 10000) - (s * 100));
	return g, s, c, neg;
end

function TitanPanelRepair_GetTextGSC(money)
	local GSC_GOLD = "ffd100";
	local GSC_SILVER = "e6e6e6";
	local GSC_COPPER = "c8602c";
	local GSC_START = "|cff%s%d|r";
	local GSC_PART = ".|cff%s%02d|r";
	local GSC_NONE = "|cffa0a0a0" .. NONE .. "|r";
	local g, s, c, neg = TitanPanelRepair_GetGSC(money);
	local gsc = "";
	if (g > 0) then
		gsc = format(GSC_START, GSC_GOLD, g);
		gsc = gsc .. format(GSC_PART, GSC_SILVER, s);
		gsc = gsc .. format(GSC_PART, GSC_COPPER, c);
	elseif (s > 0) then
		gsc = format(GSC_START, GSC_SILVER, s);
		gsc = gsc .. format(GSC_PART, GSC_COPPER, c);
	elseif (c > 0) then
		gsc = gsc .. format(GSC_START, GSC_COPPER, c);
	else
		gsc = GSC_NONE;
	end
	if (neg) then gsc = "(" .. gsc .. ")"; end
	return gsc;
end

-- **************************************************************************
-- NAME : TitanPanelRightClickMenu_PrepareRepairMenu()
-- DESC : <research>
-- **************************************************************************
function TitanPanelRightClickMenu_PrepareRepairMenu()
local info;

	-- level 2
	if _G["L_UIDROPDOWNMENU_MENU_LEVEL"] == 2 then
		if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == "Discount" then
			TitanPanelRightClickMenu_AddTitle(L["REPAIR_LOCALE"]["discount"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["buttonNormal"];
			info.checked = not TitanGetVar(TITAN_REPAIR_ID,"DiscountFriendly") and not TitanGetVar(TITAN_REPAIR_ID,"DiscountHonored") and not TitanGetVar(TITAN_REPAIR_ID,"DiscountRevered") and not TitanGetVar(TITAN_REPAIR_ID,"DiscountExalted");
			info.disabled = TPR.MerchantisOpen;
			info.func = function()
				TitanSetVar(TITAN_REPAIR_ID,"DiscountFriendly", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountHonored", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountRevered", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountExalted", nil)
				TitanPanelButton_UpdateButton(TITAN_REPAIR_ID)
			end
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["buttonFriendly"];
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"DiscountFriendly");
			info.disabled = TPR.MerchantisOpen;
			info.func = function()
				TitanSetVar(TITAN_REPAIR_ID,"DiscountFriendly", 1)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountHonored", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountRevered", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountExalted", nil)
				TitanPanelButton_UpdateButton(TITAN_REPAIR_ID)
			end
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["buttonHonored"];
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"DiscountHonored");
			info.disabled = TPR.MerchantisOpen;
			info.func = function()
				TitanSetVar(TITAN_REPAIR_ID,"DiscountFriendly", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountHonored", 1)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountRevered", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountExalted", nil)
				TitanPanelButton_UpdateButton(TITAN_REPAIR_ID)
			end
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["buttonRevered"];
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"DiscountRevered");
			info.disabled = TPR.MerchantisOpen;
			info.func = function()
				TitanSetVar(TITAN_REPAIR_ID,"DiscountFriendly", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountHonored", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountRevered", 1)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountExalted", nil)
				TitanPanelButton_UpdateButton(TITAN_REPAIR_ID)
			end
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["buttonExalted"];
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"DiscountExalted");
			info.disabled = TPR.MerchantisOpen;
			info.func = function()
				TitanSetVar(TITAN_REPAIR_ID,"DiscountFriendly", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountHonored", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountRevered", nil)
				TitanSetVar(TITAN_REPAIR_ID,"DiscountExalted", 1)
				TitanPanelButton_UpdateButton(TITAN_REPAIR_ID)
			end
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

		end

		if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == "Options" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_OPTIONS"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["percentage"];
--			info.func = TitanRepair_ShowPercentage;
			info.func = function()
				TitanToggleVar(TITAN_REPAIR_ID, "ShowPercentage");
				TitanPanelButton_UpdateButton(TITAN_REPAIR_ID);
			end
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"ShowPercentage");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["mostdamaged"];
			info.func = TitanRepair_ShowMostDamaged;
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"ShowMostDamaged");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["undamaged"];
			info.func = TitanRepair_ShowUndamaged;
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"ShowUndamaged");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["showinventory"];
			info.func = TitanRepair_ShowInventory;
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"ShowInventory");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["ShowRepairCost"];  --"Show Repair Cost"
			info.func = TitanRepair_ShowRepairCost;
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"ShowRepairCost");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["showdurabilityframe"];
			info.func = function()
			TitanToggleVar(TITAN_REPAIR_ID, "ShowDurabilityFrame");
			TitanRepair_DurabilityFrame();
			end
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"ShowDurabilityFrame");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["ignoreThrown"];
			info.func = TitanRepair_IgnoreThrown;
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"IgnoreThrown");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
		end

		if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == "AutoRepair" then
			TitanPanelRightClickMenu_AddTitle(L["REPAIR_LOCALE"]["AutoReplabel"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["popup"];
			info.func = TitanRepair_ShowPop;
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"ShowPopup");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["AutoRepitemlabel"];
			info.func = TitanRepair_AutoRep;
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"AutoRepair");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_REPAIR_REPORT_COST_MENU"]
			info.func = function() TitanToggleVar(TITAN_REPAIR_ID, "AutoRepairReport"); end
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"AutoRepairReport");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
		end

		if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == "GuildBank" then
			totalGBCP = GetGuildBankMoney();
			withdrawGBCP = GetGuildBankWithdrawMoney();
			if IsGuildLeader() ~= true then
				withdrawGB = TitanPanelRepair_GetTextGSC(withdrawGBCP);
			end
			totalGB = TitanPanelRepair_GetTextGSC(GetGuildBankMoney());
			if (totalGBCP < withdrawGBCP) or IsGuildLeader() == true then
				withdrawGB = totalGB;
			end
			TitanPanelRightClickMenu_AddTitle(L["TITAN_REPAIR_GBANK_TOTAL"].." "..totalGB, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
			TitanPanelRightClickMenu_AddTitle(L["TITAN_REPAIR_GBANK_WITHDRAW"].." "..withdrawGB, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
			info = {}
			info.text = L["TITAN_REPAIR_GBANK_USEFUNDS"]
			info.func = function() TitanToggleVar(TITAN_REPAIR_ID, "UseGuildBank"); end
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"UseGuildBank");
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
		end

		if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == "TooltipOptions" then
			TitanPanelRightClickMenu_AddTitle(L["REPAIR_LOCALE"]["TooltipOptions"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["ShowItems"];
			info.func = function() TitanToggleVar(TITAN_REPAIR_ID, "ShowItems"); end
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"ShowItems");
			info.keepShownOnClick = 1
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["ShowDiscounts"];
			info.func = function() TitanToggleVar(TITAN_REPAIR_ID, "ShowDiscounts"); end
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"ShowDiscounts");
			info.keepShownOnClick = 1
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["REPAIR_LOCALE"]["ShowCosts"];
			info.func = function() TitanToggleVar(TITAN_REPAIR_ID, "ShowCosts"); end
			info.checked = TitanGetVar(TITAN_REPAIR_ID,"ShowCosts");
			info.keepShownOnClick = 1
			L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
		end

		return
	end

	-- level 1
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_REPAIR_ID].menuText);

	info = {};
	info.notCheckable = true
	info.text = L["TITAN_PANEL_OPTIONS"];
	info.value = "Options"
	info.hasArrow = 1;
	L_UIDropDownMenu_AddButton(info);

	info = {};
	info.notCheckable = true
	info.text = L["REPAIR_LOCALE"]["AutoReplabel"];
	info.value = "AutoRepair"
	info.hasArrow = 1;
	L_UIDropDownMenu_AddButton(info);

	local guildName, _, _ = GetGuildInfo("player")
	info = {};
	info.notCheckable = true
	info.text = _G["GUILD_BANK"];
	info.value = "GuildBank"
	if guildName then
		info.hasArrow = 1
	else
		info.disabled = true
	end
	L_UIDropDownMenu_AddButton(info);

	info = {};
	info.notCheckable = true
	info.text = L["REPAIR_LOCALE"]["discount"];
	info.value = "Discount"
	info.hasArrow = 1;
	L_UIDropDownMenu_AddButton(info);

	info = {};
	info.notCheckable = true
	info.text = L["REPAIR_LOCALE"]["TooltipOptions"];
	info.value = "TooltipOptions"
	info.hasArrow = 1;
	L_UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddToggleIcon(TITAN_REPAIR_ID);
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_REPAIR_ID);
	TitanPanelRightClickMenu_AddToggleColoredText(TITAN_REPAIR_ID);
	TitanPanelRightClickMenu_AddToggleRightSide(TITAN_REPAIR_ID);
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_REPAIR_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end


-- **************************************************************************
-- NAME : TitanRepair_ShowPercentage()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_ShowPercentage()
	TitanToggleVar(TITAN_REPAIR_ID, "ShowPercentage");
	TitanPanelButton_UpdateButton(TITAN_REPAIR_ID);
end

-- **************************************************************************
-- NAME : TitanRepair_IgnoreThrown()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_IgnoreThrown()
	TitanToggleVar(TITAN_REPAIR_ID, "IgnoreThrown");
	-- Need to recalc the cost at least. May have to change most damaged item.
	TitanPanelRepairButton_ScanAllItems()
	TitanPanelRepairButton_OnUpdate()
	TitanPanelButton_UpdateButton(TITAN_REPAIR_ID);
end

-- **************************************************************************
-- NAME : TitanRepair_ShowRepairCost()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_ShowRepairCost()
	TitanToggleVar(TITAN_REPAIR_ID, "ShowRepairCost");
	TitanPanelButton_UpdateButton(TITAN_REPAIR_ID);
end

-- **************************************************************************
-- NAME : TitanRepair_ShowDurabilityFrame()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_DurabilityFrame(isOnShow)
	if TitanGetVar(TITAN_REPAIR_ID,"ShowDurabilityFrame") then
		-- Prevent a circular reference by checking if function was triggered by our SecureHook into OnShow.
		-- If OnShow didn't trigger this just do whatever Blizzard wants.
		if not isOnShow then DurabilityFrame_SetAlerts() end
	else
		-- Always hide this frame since user wants it hidden.
		DurabilityFrame:Hide()
	end
end

-- **************************************************************************
-- NAME : TitanRepair_ShowMostDamaged()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_ShowMostDamaged()
	TitanToggleVar(TITAN_REPAIR_ID, "ShowMostDamaged");
	TitanPanelButton_UpdateButton(TITAN_REPAIR_ID);
end

-- **************************************************************************
-- NAME : TitanRepair_ShowUndamaged()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_ShowUndamaged()
	TitanToggleVar(TITAN_REPAIR_ID, "ShowUndamaged");
end

-- **************************************************************************
-- NAME : TitanRepair_ShowPop()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_ShowPop()
	TitanToggleVar(TITAN_REPAIR_ID, "ShowPopup");
	if TitanGetVar(TITAN_REPAIR_ID,"ShowPopup") and TitanGetVar(TITAN_REPAIR_ID,"AutoRepair") then
		TitanSetVar(TITAN_REPAIR_ID,"AutoRepair",nil);
	end
end

-- **************************************************************************
-- NAME : TitanRepair_AutoRep()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_AutoRep()
	TitanToggleVar(TITAN_REPAIR_ID, "AutoRepair");
	if TitanGetVar(TITAN_REPAIR_ID,"AutoRepair") and TitanGetVar(TITAN_REPAIR_ID,"ShowPopup") then
		TitanSetVar(TITAN_REPAIR_ID,"ShowPopup",nil);
	end
end

-- **************************************************************************
-- NAME : TitanRepair_ShowInventory()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_ShowInventory()
	tit_debug_bis("TitanRepair_ShowInventory has been called !!");
	TitanToggleVar(TITAN_REPAIR_ID, "ShowInventory");

	if TitanGetVar(TITAN_REPAIR_ID,"ShowInventory") ~= 1 then
		TitanPanelRepairButton_ResetStatus(TPR.ITEM_STATUS[TPR.END].values)
	end

	TitanPanelRepairButton_ScanAllItems();
	TitanPanelRepairButton_OnUpdate()
end

-- **************************************************************************
-- NAME : TitanRepair_RepairItems()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_RepairItems()
	-- New RepairAll function
	local cost = GetRepairAllCost();
	local money = GetMoney();
	local withdrawLimit = GetGuildBankWithdrawMoney();
	local guildBankMoney = GetGuildBankMoney();

	-- Use Guild Bank funds
	if TitanGetVar(TITAN_REPAIR_ID,"UseGuildBank") then
		if IsInGuild() and CanGuildBankRepair() then
			if withdrawLimit > cost then
				RepairAllItems(true)
				-- disable repair all icon in merchant
				SetDesaturation(MerchantRepairAllIcon, 1);
				MerchantRepairAllButton:Disable();
				-- disable guild bank repair all icon in merchant
				SetDesaturation(MerchantGuildBankRepairButtonIcon, 1);
				MerchantGuildBankRepairButton:Disable();
				-- report repair cost to chat (optional)
				if TitanGetVar(TITAN_REPAIR_ID,"AutoRepairReport") then
					DEFAULT_CHAT_FRAME:AddMessage(_G["GREEN_FONT_COLOR_CODE"]..L["TITAN_REPAIR"]..": ".."|r"..L["TITAN_REPAIR_REPORT_COST_CHAT"]..TitanPanelRepair_GetTextGSC(cost).."|r.")
				end
			else
				DEFAULT_CHAT_FRAME:AddMessage(_G["GREEN_FONT_COLOR_CODE"]..L["TITAN_REPAIR"]..": ".."|r"..L["TITAN_REPAIR_GBANK_NOMONEY"])
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage(_G["GREEN_FONT_COLOR_CODE"]..L["TITAN_REPAIR"]..": ".."|r"..L["TITAN_REPAIR_GBANK_NORIGHTS"])
		end
	end

	-- Use own funds
	if not TitanGetVar(TITAN_REPAIR_ID,"UseGuildBank") then
		if money > cost then
			RepairAllItems()
			-- disable repair all icon in merchant
			SetDesaturation(MerchantRepairAllIcon, 1);
			MerchantRepairAllButton:Disable();
			-- disable guild bank repair all icon in merchant
			SetDesaturation(MerchantGuildBankRepairButtonIcon, 1);
			MerchantGuildBankRepairButton:Disable();
			-- report repair cost to chat (optional)
			if TitanGetVar(TITAN_REPAIR_ID,"AutoRepairReport") then
				DEFAULT_CHAT_FRAME:AddMessage(_G["GREEN_FONT_COLOR_CODE"]..L["TITAN_REPAIR"]..": ".."|r"..L["TITAN_REPAIR_REPORT_COST_CHAT"]..TitanPanelRepair_GetTextGSC(cost))
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage(_G["GREEN_FONT_COLOR_CODE"]..L["TITAN_REPAIR"]..": ".."|r"..L["TITAN_REPAIR_CANNOT_AFFORD"])
		end
	end
end

-- **************************************************************************
-- NAME : TitanRepair_GetRepairInvCost()
-- DESC : <research>
-- **************************************************************************
function TitanRepair_GetRepairInvCost()
	local result = 0;
	local bag;
	TitanRepairTooltip:SetOwner(UIParent, "ANCHOR_NONE");

	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local _, repairCost = TitanRepairTooltip:SetBagItem(bag, slot);
			if (repairCost and (repairCost > 0)) then
				result = result + repairCost;
			end
		end
	end
	TitanRepairTooltip:Hide();

	return result;
end

-- Hooks
--TitanRepairModule:SecureHook("DurabilityFrame_SetAlerts", TitanRepair_DurabilityFrame)
TitanRepairModule:SecureHook(DurabilityFrame, "Show", function() TitanRepair_DurabilityFrame(true) end)