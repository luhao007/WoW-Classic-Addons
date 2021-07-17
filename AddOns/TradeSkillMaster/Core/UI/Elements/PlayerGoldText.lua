-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- PlayerGoldText UI Element Class.
-- A text element which contains player gold info which automatically updates when the player's gold amount changes. It
-- is a subclass of the @{Text} class.
-- @classmod PlayerGoldText

local _, TSM = ...
local PlayerGoldText = TSM.Include("LibTSMClass").DefineClass("PlayerGoldText", TSM.UI.Text)
local L = TSM.Include("Locale").GetTable()
local TempTable = TSM.Include("Util.TempTable")
local Event = TSM.Include("Util.Event")
local Money = TSM.Include("Util.Money")
local Settings = TSM.Include("Service.Settings")
local UIElements = TSM.Include("UI.UIElements")
local Tooltip = TSM.Include("UI.Tooltip")
UIElements.Register(PlayerGoldText)
TSM.UI.PlayerGoldText = PlayerGoldText
local private = {
	registered = false,
	elements = {},
}



-- ============================================================================
-- Meta Class Methods
-- ============================================================================

function PlayerGoldText.__init(self)
	self.__super:__init()
	self:_GetBaseFrame():EnableMouse(true)

	if not private.registered then
		Event.Register("PLAYER_MONEY", private.MoneyOnUpdate)
		private.registered = true
	end

	self._justifyH = "RIGHT"
	self._font = "TABLE_TABLE1"
end

function PlayerGoldText.Acquire(self)
	private.elements[self] = true
	self.__super:Acquire()
	self:SetText(Money.ToString(TSM.db.global.appearanceOptions.showTotalMoney and private.GetTotalMoney() or GetMoney()))
	self:SetTooltip(private.MoneyTooltipFunc)
end

function PlayerGoldText.Release(self)
	private.elements[self] = nil
	self.__super:Release()
	self._justifyH = "RIGHT"
	self._font = "TABLE_TABLE1"
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MoneyOnUpdate()
	for element in pairs(private.elements) do
		element:SetText(Money.ToString(TSM.db.global.appearanceOptions.showTotalMoney and private.GetTotalMoney() or GetMoney()))
		element:Draw()
	end
end

function private.MoneyTooltipFunc()
	local tooltipLines = TempTable.Acquire()
	local playerMoney = TSM.db.sync.internalData.money
	local total = playerMoney
	tinsert(tooltipLines, strjoin(Tooltip.GetSepChar(), UnitName("player")..":", Money.ToString(playerMoney)))
	local numPosted, numSold, postedGold, soldGold = TSM.MyAuctions.GetAuctionInfo()
	if numPosted then
		tinsert(tooltipLines, "  "..strjoin(Tooltip.GetSepChar(), format(L["%s Sold Auctions"], numSold)..":", Money.ToString(soldGold)))
		tinsert(tooltipLines, "  "..strjoin(Tooltip.GetSepChar(), format(L["%s Posted Auctions"], numPosted)..":", Money.ToString(postedGold)))
	end
	for _, _, character, syncScopeKey in Settings.ConnectedFactionrealmAltCharacterIterator() do
		local money = Settings.Get("sync", syncScopeKey, "internalData", "money")
		if money > 0 then
			tinsert(tooltipLines, strjoin(Tooltip.GetSepChar(), character..":", Money.ToString(money)))
			total = total + money
		end
	end
	tinsert(tooltipLines, 1, strjoin(Tooltip.GetSepChar(), L["Total Gold"]..":", Money.ToString(total)))
	return strjoin("\n", TempTable.UnpackAndRelease(tooltipLines))
end

function private.GetTotalMoney()
	local total = TSM.db.sync.internalData.money
	for _, _, _, syncScopeKey in Settings.ConnectedFactionrealmAltCharacterIterator() do
		local money = Settings.Get("sync", syncScopeKey, "internalData", "money")
		if money > 0 then
			total = total + money
		end
	end
	return total
end
