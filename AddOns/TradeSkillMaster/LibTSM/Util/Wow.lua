-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Wow Functions
-- @module Wow

local _, TSM = ...
local Wow = TSM.Init("Util.Wow")



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Shows a basic Wow message popup.
-- @tparam string text The text to display
function Wow.ShowBasicMessage(text)
	if BasicMessageDialog:IsShown() then
		return
	end
	BasicMessageDialog.Text:SetText(text)
	BasicMessageDialog:Show()
end

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

--- Sets the WoW item ref frame to the specified link.
-- @tparam string link The itemLink to show the item ref frame for
function Wow.SafeItemRef(link)
	if type(link) ~= "string" then return end
	-- extract the Blizzard itemString for both items and pets
	local blizzItemString = strmatch(link, "^\124c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]\124H(item:[^\124]+)\124.+$")
	blizzItemString = blizzItemString or strmatch(link, "^\124c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]\124H(battlepet:[^\124]+)\124.+$")
	if blizzItemString then
		SetItemRef(blizzItemString, link, "LeftButton")
	end
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
