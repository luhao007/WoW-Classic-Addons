-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Log = TSM.Auctioning:NewPackage("Log")
local L = TSM.Include("Locale").GetTable()
local Database = TSM.Include("Util.Database")
local Theme = TSM.Include("Util.Theme")
local ItemInfo = TSM.Include("Service.ItemInfo")
local private = {
	db = nil,
}
local REASON_INFO = {
	-- general
	invalidItemGroup = { color = "RED", str = L["Item/Group is invalid (see chat)."] },
	invalidSeller = { color = "RED", str = L["Invalid seller data returned by server."] },
	-- post scan
	postDisabled = { color = "ORANGE", str = L["Posting disabled."] },
	postNotEnough = { color = "ORANGE", str = L["Not enough items in bags."] },
	postMaxExpires = { color = "ORANGE", str = L["Above max expires."] },
	postBelowMin = { color = "ORANGE", str = L["Cheapest auction below min price."] },
	postTooMany = { color = "BLUE", str = L["Maximum amount already posted."] },
	postNormal = { color = "GREEN", str = L["Posting at normal price."] },
	postResetMin = { color = "GREEN", str = L["Below min price. Posting at min."] },
	postResetMax = { color = "GREEN", str = L["Below min price. Posting at max."] },
	postResetNormal = { color = "GREEN", str = L["Below min price. Posting at normal."] },
	postAboveMaxMin = { color = "GREEN", str = L["Above max price. Posting at min."] },
	postAboveMaxMax = { color = "GREEN", str = L["Above max price. Posting at max."] },
	postAboveMaxNormal = { color = "GREEN", str = L["Above max price. Posting at normal."] },
	postAboveMaxNoPost = { color = "ORANGE", str = L["Above max price. Not posting."] },
	postUndercut = { color = "GREEN", str = L["Undercutting competition."] },
	postPlayer = { color = "GREEN", str = L["Posting at your current price."] },
	postWhitelist = { color = "GREEN", str = L["Posting at whitelisted player's price."] },
	postWhitelistNoPost = { color = "ORANGE", str = L["Lowest auction by whitelisted player."] },
	postBlacklist = { color = "GREEN", str = L["Undercutting blacklisted player."] },
	-- cancel scan
	cancelDisabled = { color = "ORANGE", str = L["Canceling disabled."] },
	cancelNotUndercut = { color = "GREEN", str = L["Your auction has not been undercut."] },
	cancelBid = { color = "BLUE", str = L["Auction has been bid on."] },
	cancelNoMoney = { color = "BLUE", str = L["Not enough money to cancel."] },
	cancelKeepPosted = { color = "BLUE", str = L["Keeping undercut auctions posted."] },
	cancelBelowMin = { color = "ORANGE", str = L["Not canceling auction below min price."] },
	cancelAtReset = { color = "GREEN", str = L["Not canceling auction at reset price."] },
	cancelAtNormal = { color = "GREEN", str = L["At normal price and not undercut."] },
	cancelAtAboveMax = { color = "GREEN", str = L["At above max price and not undercut."] },
	cancelAtWhitelist = { color = "GREEN", str = L["Posted at whitelisted player's price."] },
	cancelUndercut = { color = "RED", str = L["You've been undercut."] },
	cancelRepost = { color = "BLUE", str = L["Canceling to repost at higher price."] },
	cancelReset = { color = "BLUE", str = L["Canceling to repost at reset price."] },
	cancelWhitelistUndercut = { color = "RED", str = L["Undercut by whitelisted player."] },
	cancelPlayerUndercut = { color = "BLUE", str = L["Canceling auction you've undercut."] },
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Log.OnInitialize()
	private.db = Database.NewSchema("AUCTIONING_LOG")
		:AddNumberField("index")
		:AddStringField("itemString")
		:AddStringField("seller")
		:AddNumberField("buyout")
		:AddStringField("operation")
		:AddStringField("reasonStr")
		:AddStringField("reasonKey")
		:AddStringField("state")
		:AddIndex("index")
		:Commit()
end

function Log.Truncate()
	private.db:Truncate()
end

function Log.CreateQuery()
	return private.db:NewQuery()
		:InnerJoin(ItemInfo.GetDBForJoin(), "itemString")
		:OrderBy("index", true)
end

function Log.UpdateRowByIndex(index, field, value)
	local row = private.db:NewQuery()
		:Equal("index", index)
		:GetFirstResultAndRelease()

	if field == "state" then
		assert(value == "POSTED" or value == "CANCELLED" or value == "SKIPPED")
		if not row then
			return
		end
	end

	row:SetField(field, value)
		:Update()

	row:Release()
end

function Log.SetQueryUpdatesPaused(paused)
	private.db:SetQueryUpdatesPaused(paused)
end

function Log.AddEntry(itemString, operationName, reasonKey, seller, buyout, index)
	private.db:NewRow()
		:SetField("itemString", itemString)
		:SetField("seller", seller)
		:SetField("buyout", buyout)
		:SetField("operation", operationName)
		:SetField("reasonStr", REASON_INFO[reasonKey].str)
		:SetField("reasonKey", reasonKey)
		:SetField("index", index)
		:SetField("state", "PENDING")
		:Create()
end

function Log.GetColorFromReasonKey(reasonKey)
	return Theme.GetFeedbackColor(REASON_INFO[reasonKey].color)
end

function Log.GetInfoStr(row)
	local state, reasonKey = row:GetFields("state", "reasonKey")
	local reasonInfo = REASON_INFO[reasonKey]
	local color = nil
	if state == "PENDING" then
		return Theme.GetFeedbackColor(reasonInfo.color):ColorText(reasonInfo.str)
	elseif state == "POSTED" then
		return Theme.GetColor("INDICATOR"):ColorText(L["Posted:"]).." "..reasonInfo.str
	elseif state == "CANCELLED" then
		return Theme.GetColor("INDICATOR"):ColorText(L["Cancelled:"]).." "..reasonInfo.str
	elseif state == "SKIPPED" then
		return Theme.GetColor("INDICATOR"):ColorText(L["Skipped:"]).." "..reasonInfo.str
	else
		error("Invalid state: "..tostring(state))
	end
	return color:ColorText(reasonInfo.str)
end
