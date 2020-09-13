-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Wrapper = TSM.Init("Service.ItemTooltipClasses.Wrapper")
local ExtraTip = TSM.Include("Service.ItemTooltipClasses.ExtraTip")
local Builder = TSM.Include("Service.ItemTooltipClasses.Builder")
local ItemInfo = TSM.Include("Service.ItemInfo")
local Settings = TSM.Include("Service.Settings")
local ItemString = TSM.Include("Util.ItemString")
local private = {
	builder = nil,
	settings = nil,
	tooltipRegistry = {},
	hookedBattlepetGlobal = nil,
	tooltipMethodPrehooks = nil,
	tooltipMethodPosthooks = {},
	lastMailTooltipUpdate = nil,
	lastMailTooltipIndex = nil,
	populateFunc = nil,
}



-- ============================================================================
-- Module Loading
-- ============================================================================

Wrapper:OnSettingsLoad(function()
	private.builder = Builder.Create()
	private.settings = Settings.NewView()
		:AddKey("global", "tooltipOptions", "embeddedTooltip")
		:AddKey("global", "tooltipOptions", "enabled")
		:AddKey("global", "tooltipOptions", "tooltipShowModifier")
	private.RegisterTooltip(GameTooltip)
	private.RegisterTooltip(ItemRefTooltip)
	if not TSM.IsWowClassic() then
		private.RegisterTooltip(BattlePetTooltip)
		private.RegisterTooltip(FloatingBattlePetTooltip)
	end
	local orig = OpenMailAttachment_OnEnter
	OpenMailAttachment_OnEnter = function(self, index)
		private.lastMailTooltipUpdate = private.lastMailTooltipUpdate or 0
		if private.lastMailTooltipIndex ~= index or private.lastMailTooltipUpdate + 0.1 < GetTime() then
			private.lastMailTooltipUpdate = GetTime()
			private.lastMailTooltipIndex = index
			orig(self, index)
		end
	end
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function Wrapper.SetPopulateFunction(func)
	assert(type(func) == "function" and not private.populateFunc)
	private.populateFunc = func
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.RegisterTooltip(tooltip)
	local reg = {}
	reg.extraTip = ExtraTip.Create(tooltip)
	private.tooltipRegistry[tooltip] = reg

	if private.IsBattlePetTooltip(tooltip) then
		if not private.hookedBattlepetGlobal then
			private.hookedBattlepetGlobal = true
			hooksecurefunc("BattlePetTooltipTemplate_SetBattlePet", private.OnTooltipSetBattlePet)
			hooksecurefunc("BattlePetToolTip_Show", private.OnBattlePetTooltipShow)
		end
		tooltip:HookScript("OnHide", private.OnTooltipCleared)
	else
		local scriptHooks = {
			OnTooltipSetItem = private.OnTooltipSetItem,
			OnTooltipCleared = private.OnTooltipCleared
		}
		for script, prehook in pairs(scriptHooks) do
			tooltip:HookScript(script, prehook)
		end

		for method, prehook in pairs(private.tooltipMethodPrehooks) do
			local posthook = private.tooltipMethodPosthooks[method]
			local orig = tooltip[method]
			tooltip[method] = function(...)
				prehook(...)
				local a, b, c, d, e, f, g, h, i, j, k = orig(...)
				posthook(...)
				return a, b, c, d, e, f, g, h, i, j, k
			end
		end
	end
end

function private.IsBattlePetTooltip(tooltip)
	if TSM.IsWowClassic() then
		return false
	end
	return tooltip == BattlePetTooltip or tooltip == FloatingBattlePetTooltip
end

function private.OnTooltipSetItem(tooltip)
	local reg = private.tooltipRegistry[tooltip]
	if reg.hasItem then
		return
	end

	tooltip:Show()
	local testName, item = tooltip:GetItem()
	if not item then
		item = reg.item
	elseif testName == "" then
		-- this is likely a case where :GetItem() is broken for recipes - detect and try to fix it
		if strmatch(item, "item:([0-9]*):") == "" then
			item = reg.item
		end
	end
	if not item then
		return
	end

	private.SetTooltipItem(tooltip, item)
end

function private.OnTooltipSetBattlePet(tooltip, data)
	local reg = private.tooltipRegistry[tooltip]
	if reg.hasItem then
		private.OnTooltipCleared(tooltip)
	end

	local link = reg.item
	if not link then
		-- extract values from data
		local speciesID = data.speciesID
		local level = data.level
		local maxHealth = data.maxHealth
		local power = data.power
		local speed = data.speed
		local battlePetID = data.battlePetID or "0x0000000000000000"
		local name = data.name
		local customName = data.customName
		local breedQuality = data.breedQuality
		local colorCode = breedQuality == -1 and NORMAL_FONT_COLOR_CODE or (ITEM_QUALITY_COLORS[breedQuality] or ITEM_QUALITY_COLORS[0]).hex
		link = format("%s|Hbattlepet:%d:%d:%d:%d:%d:%d:%s|h[%s]|h|r", colorCode, speciesID, level, breedQuality, maxHealth, power, speed, battlePetID, customName or name)
	end

	private.SetTooltipItem(tooltip, link)
end

function private.OnTooltipCleared(tooltip)
	local reg = private.tooltipRegistry[tooltip]
	if reg.ignoreOnCleared then return end

	reg.extraTipUsed = nil
	reg.minWidth = 0
	reg.quantity = nil
	reg.hasItem = nil
	reg.item = nil
	reg.extraTip:Hide()
	reg.extraTip.minWidth = 0
	reg.extraTip.isTop = nil
end

function private.OnBattlePetTooltipShow()
	local reg = private.tooltipRegistry[BattlePetTooltip]
	reg.extraTip:Show()
end

function private.SetTooltipItem(tooltip, link)
	local itemString = ItemString.Get(link)
	if not private.IsEnabled() or not itemString then
		return
	end

	local reg = private.tooltipRegistry[tooltip]
	local quantity = max(IsShiftKeyDown() and reg.quantity or 1, 1)
	local isCached = private.builder:_Prepare(itemString, quantity)
	if not isCached then
		-- populate all the lines
		private.populateFunc(private.builder, itemString)
	end
	if private.builder:_IsEmpty() then
		return
	end
	reg.hasItem = true
	local useExtraTip = private.IsBattlePetTooltip(tooltip) or not private.settings.embeddedTooltip

	-- setup the extra tip if necessary
	if useExtraTip then
		reg.extraTip:Attach(tooltip)
		local r, g, b = GetItemQualityColor(ItemInfo.GetQuality(link) or 0)
		reg.extraTip:AddLine(ItemInfo.GetName(link), r, g, b)
	end

	-- add all the lines
	local targetTip = useExtraTip and reg.extraTip or tooltip
	targetTip:AddLine(" ")
	for _, left, right, lineColor in private.builder:_LineIterator() do
		local r, g, b = lineColor:GetFractionalRGBA()
		if right then
			targetTip:AddDoubleLine(left, right, r, g, b, r, g, b)
		else
			targetTip:AddLine(left, r, g, b)
		end
	end

	-- show the tooltip / extra tip as necessary
	if not private.IsBattlePetTooltip(tooltip) then
		tooltip:Show()
	end
	if useExtraTip then
		reg.extraTip:Show()
	end
end

function private.IsEnabled()
	if not private.settings.enabled then
		return false
	elseif private.settings.tooltipShowModifier == "alt" and not IsAltKeyDown() then
		return false
	elseif private.settings.tooltipShowModifier == "ctrl" and not IsControlKeyDown() then
		return false
	end
	return true
end



-- ============================================================================
-- Hook Setup Code
-- ============================================================================

do
	local function PreHookHelper(self, quantityFunc, quantityOffset, ...)
		private.OnTooltipCleared(self)
		local reg = private.tooltipRegistry[self]
		reg.ignoreOnCleared = true
		if type(quantityFunc) == "number" then
			reg.quantity = quantityFunc
		else
			reg.quantity = select(quantityOffset, quantityFunc(...))
		end
		return reg
	end
	private.tooltipMethodPrehooks = {
		SetQuestItem = function(self, ...) PreHookHelper(self, GetQuestItemInfo, 3, ...) end,
		SetQuestLogItem = function(self, type, ...)
			local quantityFunc = type == "choice" and GetQuestLogChoiceInfo or GetQuestLogRewardInfo
			PreHookHelper(self, quantityFunc, 3, ...)
		end,
		SetRecipeReagentItem = function(self, ...)
			local reg = PreHookHelper(self, C_TradeSkillUI.GetRecipeReagentInfo, 3, ...)
			reg.item = C_TradeSkillUI.GetRecipeReagentItemLink(...)
		end,
		SetRecipeResultItem = function(self, ...)
			private.OnTooltipCleared(self)
			local reg = private.tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local lNum, hNum = C_TradeSkillUI.GetRecipeNumItemsProduced(...)
			-- the quantity can be a range, so use a quantity of 1 if so
			reg.quantity = lNum == hNum and lNum or 1
		end,
		SetBagItem = function(self, ...) PreHookHelper(self, GetContainerItemInfo, 2, ...) end,
		SetGuildBankItem = function(self, ...)
			local reg = PreHookHelper(self, GetGuildBankItemInfo, 2, ...)
			reg.item = GetGuildBankItemLink(...)
		end,
		SetVoidItem = function(self, ...) PreHookHelper(self, 1) end,
		SetVoidDepositItem = function(self, ...) PreHookHelper(self, 1) end,
		SetVoidWithdrawalItem = function(self, ...) PreHookHelper(self, 1) end,
		SetInventoryItem = function(self, ...) PreHookHelper(self, GetInventoryItemCount, 1, ...) end,
		SetMerchantItem = function(self, ...)
			local reg = PreHookHelper(self, GetMerchantItemInfo, 4, ...)
			reg.item = GetMerchantItemLink(...)
		end,
		SetMerchantCostItem = function(self, ...) PreHookHelper(self, GetMerchantItemCostItem, 2, ...) end,
		SetBuybackItem = function(self, ...) PreHookHelper(self, GetBuybackItemInfo, 4, ...) end,
		SetAuctionItem = function(self, ...)
			local reg = PreHookHelper(self, GetAuctionItemInfo, 3, ...)
			reg.item = GetAuctionItemLink(...)
		end,
		SetAuctionSellItem = function(self, ...) PreHookHelper(self, GetAuctionSellItemInfo, 3, ...) end,
		SetInboxItem = function(self, index) PreHookHelper(self, GetInboxItem, 4, index, 1) end,
		SetSendMailItem = function(self, ...) PreHookHelper(self, GetSendMailItem, 4, ...) end,
		SetLootItem = function(self, ...) PreHookHelper(self, GetLootSlotInfo, 3, ...) end,
		SetLootRollItem = function(self, ...) PreHookHelper(self, GetLootRollItemInfo, 3, ...) end,
		SetTradePlayerItem = function(self, ...) PreHookHelper(self, GetTradePlayerItemInfo, 3, ...) end,
		SetTradeTargetItem = function(self, ...) PreHookHelper(self, GetTradeTargetItemInfo, 3, ...) end,
		SetHyperlink = function(self, link)
			local reg = private.tooltipRegistry[self]
			private.OnTooltipCleared(self)
			reg.ignoreOnCleared = true
			reg.item = link
		end,
	}

	-- populate all the posthooks
	local function TooltipMethodPostHook(self)
		private.tooltipRegistry[self].ignoreOnCleared = nil
	end
	for funcName in pairs(private.tooltipMethodPrehooks) do
		private.tooltipMethodPosthooks[funcName] = TooltipMethodPostHook
	end
	-- SetHyperlink is special
	private.tooltipMethodPosthooks.SetHyperlink = function(self)
		local reg = private.tooltipRegistry[self]
		reg.ignoreOnCleared = nil
	end
end
