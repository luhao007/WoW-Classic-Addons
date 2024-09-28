local addonName, addonTable= ...;
local _, _, _, tocversion = GetBuildInfo()
-------------------
local CommonInfo=addonTable.CommonInfo
--------------
--//快速拾取（不显示拾取界面）/////////--
-- local shiqushike = 0
-- local shiqujiange = 0.01

-- local function ZhixingLoot()
--     if GetTime() - shiqushike >= shiqujiange then
--         shiqushike = GetTime()
--         if GetCVarBool("autoLootDefault")==true then
--         	if IsModifiedClick("AUTOLOOTTOGGLE")~=true then
-- 	            for i = GetNumLootItems(), 1, -1 do
-- 	                LootSlot(i)
-- 	            end
-- 	            shiqushike = GetTime()
-- 	        end
--         end
--     end
-- end
-- local function shiqujinxing()
-- 	if IsInGroup()==true then 
-- 		local lootmethod, _, _ = GetLootMethod();
-- 		if lootmethod~="master" then 
-- 			ZhixingLoot();
-- 		end
-- 	else
-- 		ZhixingLoot();
-- 	end
-- end

-- local LootF = CreateFrame("Frame")
-- LootF:SetScript("OnEvent", shiqujinxing)
-------------------
---模式2
local PIG_AutoLoot = {};
local Settings = {};
local internal = {
    _frame = CreateFrame("frame");
    isItemLocked = false,
    isLooting = false,
    isHidden = false,
    TSM = false,
    ElvUI = false,
    isClassic = true,
    audioChannel = "master",
};
local GetContainerNumFreeSlots=C_Container and C_Container.GetContainerNumFreeSlots or GetContainerNumFreeSlots
function PIG_AutoLoot:ProcessLootItem(itemLink, itemQuantity)
    local itemFamily = GetItemFamily(itemLink);
    for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        local free, bagFamily = GetContainerNumFreeSlots(i);
        if (not bagFamily or bagFamily == 0) or (itemFamily and bit.band(itemFamily, bagFamily) > 0) then
            if free > 0 then
                return true;
            end
        end
    end
    local inventoryItemCount = GetItemCount(itemLink);
    if inventoryItemCount > 0 then
        local itemStackSize = select(8, GetItemInfo(itemLink));
        if itemStackSize > 1 then
            local remainingSpace = (itemStackSize - inventoryItemCount) % itemStackSize;
            if remainingSpace >= itemQuantity then
                return true;
            end
        end
    end
    return false;
end

function PIG_AutoLoot:LootItems(numItems)
    local lootThreshold = (internal.isClassic and select(2,GetLootMethod()) == 0) and GetLootThreshold() or 10;
    for i = numItems, 1, -1 do
        local itemLink = GetLootSlotLink(i);
        local slotType = GetLootSlotType(i);
        local quantity, _, quality, locked, isQuestItem = select(3, GetLootSlotInfo(i));
        if locked or (quality and quality >= lootThreshold) then
            internal.isItemLocked = true;
        else
            if slotType ~= LOOT_SLOT_ITEM or (not internal.isClassic and isQuestItem) or self:ProcessLootItem(itemLink, quantity) then
                numItems = numItems - 1;
                LootSlot(i);
            end
        end
    end
    if numItems > 0 then
        self:ShowLootFrame(true);
        self:PlayInventoryFullSound();
    end
    if IsFishingLoot() and Settings.global and not Settings.global.fishingSoundDisabled then
        PlaySound(SOUNDKIT.FISHING_REEL_IN, internal.audioChannel);
    end
end

function PIG_AutoLoot:OnLootReady(autoLoot)
	if IsInGroup() then 
		local lootmethod = GetLootMethod();
		if lootmethod=="master" then return end
	end
    if not internal.isLooting then
        internal.isLooting = true;
        local numItems = GetNumLootItems();
        if numItems == 0 then
            return;
        end
        if autoLoot or (autoLoot == nil and GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE")) then
            self:LootItems(numItems);
        else
            self:ShowLootFrame(true);
        end
    end
end

function PIG_AutoLoot:OnLootClosed()
	if IsInGroup() then 
		local lootmethod = GetLootMethod();
		if lootmethod=="master" then return end
	end
    internal.isLooting = false;
    internal.isHidden = false;
    internal.isItemLocked = false;
    self:ShowLootFrame(false);
    if internal.TSM and TSMDestroyBtn and TSMDestroyBtn:IsVisible() then
        C_Timer.NewTicker(0, function() SlashCmdList.TSM("destroy") end, 2);
    end
end

function PIG_AutoLoot:OnErrorMessage(...)
	if IsInGroup() then 
		local lootmethod = GetLootMethod();
		if lootmethod=="master" then return end
	end
    if tContains(({ERR_INV_FULL,ERR_ITEM_MAX_COUNT}), select(2,...)) then
        if internal.isLooting and internal.isHidden then
            self:ShowLootFrame(true);
            self:PlayInventoryFullSound();
        end
    end
end

function PIG_AutoLoot:OnBindConfirm()
	if IsInGroup() then 
		local lootmethod = GetLootMethod();
		if lootmethod=="master" then return end
	end
    if internal.isLooting and internal.isHidden then
        self:ShowLootFrame(true);
    end
end

function PIG_AutoLoot:PlayInventoryFullSound()
	if Settings.global then
	    if Settings.global.enableSound and not internal.isItemLocked then
	        PlaySound(Settings.global.InventoryFullSound, internal.audioChannel);
	    end
	end
end

local function AddMessage(...) _G.DEFAULT_CHAT_FRAME:AddMessage(strjoin(" ", tostringall(...))) end;

function PIG_AutoLoot:Anchor(frame)
    internal.isHidden = false;
    frame:SetFrameStrata("HIGH");
    if internal.ElvUI then
        frame:SetParent(ElvLootFrameHolder);
    else
        frame:SetParent(UIParent);
    end

    if GetCVarBool("lootUnderMouse") then
        local x, y = GetCursorPosition();
        x = x / frame:GetEffectiveScale();
        y = y / frame:GetEffectiveScale();

        frame:ClearAllPoints();
        frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x - 40, y + 20);
        frame:GetCenter();
        frame:Raise();
    else
        frame:ClearAllPoints();
        if internal.ElvUI then
            frame:SetPoint("TOPLEFT", ElvLootFrameHolder, "TOPLEFT");
        else
            frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 20, -125);
        end
    end
end

function PIG_AutoLoot:ShowLootFrame(show)
	if IsInGroup() then 
		local lootmethod = GetLootMethod();
		if lootmethod=="master" then return end
	end
    if internal.ElvUI then
        if show then
            self:Anchor(ElvLootFrame);
        else
            ElvLootFrame:SetParent(internal._frame);
            internal.isHidden = true;
        end
    elseif LootFrame:IsEventRegistered("LOOT_SLOT_CLEARED") then
        if show then
            self:Anchor(LootFrame);
        else
            LootFrame:SetParent(internal._frame);
            internal.isHidden = true;
        end
    end
end
function PIG_AutoLoot:RegisterEvent(event, func)
    internal._frame[event] = func;
    internal._frame:RegisterEvent(event);
end
function PIG_AutoLoot:UnregisterEvent(event)
    internal._frame[event] = function() end;
    internal._frame:UnregisterEvent(event);
end
function PIG_AutoLoot:OnInit()
    if PIGA["Common"]["AutoLoot"] and PIGA["Common"]["FastLoot"] then
        self:RegisterEvent("LOOT_READY", self.OnLootReady);
        self:RegisterEvent("LOOT_OPENED", self.OnLootReady);
        self:RegisterEvent("LOOT_CLOSED", self.OnLootClosed);
        self:RegisterEvent("UI_ERROR_MESSAGE", self.OnErrorMessage);
        if internal.isClassic then
            self:RegisterEvent("LOOT_BIND_CONFIRM", self.OnBindConfirm);
        end
    else
        LootFrame:SetParent(UIParent);
        self:UnregisterEvent("LOOT_READY");
        self:UnregisterEvent("LOOT_OPENED");
        self:UnregisterEvent("LOOT_CLOSED");
        self:UnregisterEvent("UI_ERROR_MESSAGE");
        if internal.isClassic then
            self:UnregisterEvent("LOOT_BIND_CONFIRM");
        end
    end
end
internal._frame:SetToplevel(true);
internal._frame:Hide();
internal._frame:SetScript("OnEvent", function(_,event,...)
    internal._frame[event](PIG_AutoLoot, ...) 
end);
--------------------
CommonInfo.Commonfun.FastLoot = function()
    if tocversion<50000 then
        PIG_AutoLoot:OnInit();
        --if PIGA["Common"]["AutoLoot"] and PIGA["Common"]["FastLoot"] then
            --SetCVar("autoLootRate", "0")
            --LootF:RegisterEvent("LOOT_READY")
        --else
            --LootF:UnregisterEvent("LOOT_READY");
        --end
    end
end