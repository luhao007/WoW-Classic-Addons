-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Wow Functions
-- @module Wow

local _, TSM = ...
local Wow = TSM.Init("Util.Wow")
TSM.Wow = Wow
local private = {
	itemLinkedCallbacks = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Shows a WoW static popup dialog.
-- @tparam string name The unique (global) name of the dialog to be shown
function Wow.ShowStaticPopupDialog(name)
	StaticPopupDialogs[name].preferredIndex = 4
	StaticPopup_Show(name)
	for i = 1, 100 do
		if _G["StaticPopup" .. i] and _G["StaticPopup" .. i].which == name then
			_G["StaticPopup" .. i]:SetFrameStrata("TOOLTIP")
			break
		end
	end
end

--- Sets the WoW tooltip to the specified link.
-- @tparam string link The itemLink or TSM itemString to show the tooltip for
function Wow.SafeTooltipLink(link)
	if strmatch(link, "p:") then
		link = TSMAPI_FOUR.Item.GetLink(link)
	end
	if strmatch(link, "battlepet") then
		local _, speciesID, level, breedQuality, maxHealth, power, speed = strsplit(":", link)
		BattlePetToolTip_Show(tonumber(speciesID), tonumber(level) or 0, tonumber(breedQuality) or 0, tonumber(maxHealth) or 0, tonumber(power) or 0, tonumber(speed) or 0, gsub(gsub(link, "^(.*)%[", ""), "%](.*)$", ""))
	elseif strmatch(link, "currency") then
		local currencyID = strmatch(link, "currency:(%d+)")
		GameTooltip:SetCurrencyByID(currencyID)
	else
		GameTooltip:SetHyperlink(TSMAPI_FOUR.Item.GetLink(link))
	end
end

--- Sets the WoW item ref frame to the specified link.
-- @tparam string link The itemLink to show the item ref frame for
function Wow.SafeItemRef(link)
	if type(link) ~= "string" then return end
	-- extract the Blizzard itemString for both items and pets
	local blizzItemString = strmatch(link, "^\124c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]\124H(item:[^\124]+)\124.+$")
	blizzItemString = blizzItemString or strmatch(link, "^\124c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]\124H(battlepet:[^\124]+)\124.+$")
	if blizzItemString then
		SetItemRef(blizzItemString, link)
	end
end

--- Checks if the version of an addon is a dev version.
-- @tparam string name The name of the addon
-- @treturn boolean Whether or not the addon is a dev version
function Wow.IsTSMDevVersion()
	-- use strmatch does this string doesn't itself get replaced when we deploy
	return strmatch(GetAddOnMetadata("TradeSkillMaster", "version"), "^@tsm%-project%-version@$") and true or false
end

--- Checks if an addon is installed.
-- This function only checks if the addon is installed, not if it's enabled.
-- @tparam string name The name of the addon
-- @treturn boolean Whether or not the addon is installed
function Wow.IsAddonInstalled(name)
	return select(2, GetAddOnInfo(name)) and true or false
end

--- Checks if an addon is currently enabled.
-- @tparam string name The name of the addon
-- @treturn boolean Whether or not the addon is enabled
function Wow.IsAddonEnabled(name)
	return GetAddOnEnableState(UnitName("player"), name) == 2 and select(4, GetAddOnInfo(name)) and true or false
end

--- Registers a function which is called when an item is linked.
-- @tparam function callback The function to be called
function Wow.RegisterItemLinkedCallback(callback)
	tinsert(private.itemLinkedCallbacks, callback)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.HandleItemLinked(name, itemLink)
	for _, callback in ipairs(private.itemLinkedCallbacks) do
		if callback(name, itemLink) then
			return true
		end
	end
end



-- ============================================================================
-- Item Link Setup
-- ============================================================================

do
	local function HandleShiftClickItem(origFunc, itemLink)
		local putIntoChat = origFunc(itemLink)
		if putIntoChat then
			return putIntoChat
		end
		local name = TSMAPI_FOUR.Item.GetName(itemLink)
		if not name or not private.HandleItemLinked(name, itemLink) then
			return putIntoChat
		end
		return true
	end
	local origHandleModifiedItemClick = HandleModifiedItemClick
	HandleModifiedItemClick = function(link)
		return HandleShiftClickItem(origHandleModifiedItemClick, link)
	end
	local origChatEdit_InsertLink = ChatEdit_InsertLink
	ChatEdit_InsertLink = function(link)
		return HandleShiftClickItem(origChatEdit_InsertLink, link)
	end
end
