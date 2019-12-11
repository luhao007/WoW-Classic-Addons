-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
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

	if not private.registered then
		Event.Register("PLAYER_MONEY", private.MoneyOnUpdate)
		private.registered = true
	end
end

function PlayerGoldText.Acquire(self)
	private.elements[self] = true
	self.__super:Acquire()
	self:SetText(Money.ToString(GetMoney()))
	self:SetTooltip(private.MoneyTooltipFunc)
end

function PlayerGoldText.Release(self)
	private.elements[self] = nil
	self.__super:Release()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MoneyOnUpdate()
	for element in pairs(private.elements) do
		element:SetText(Money.ToString(GetMoney()))
		element:Draw()
	end
end

function private.MoneyTooltipFunc()
	local tooltipLines = TempTable.Acquire()
	tinsert(tooltipLines, strjoin(TSM.CONST.TOOLTIP_SEP, L["Player Gold"]..":", Money.ToString(GetMoney())))
	local numPosted, numSold, postedGold, soldGold = TSM.MyAuctions.GetAuctionInfo()
	if numPosted then
		tinsert(tooltipLines, strjoin(TSM.CONST.TOOLTIP_SEP, format(L["%d Sold Auctions"], numSold)..":", Money.ToString(soldGold)))
		tinsert(tooltipLines, strjoin(TSM.CONST.TOOLTIP_SEP, format(L["%d Posted Auctions"], numPosted)..":", Money.ToString(postedGold)))
	end
	return strjoin("\n", TempTable.UnpackAndRelease(tooltipLines))
end
