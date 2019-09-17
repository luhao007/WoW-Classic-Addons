--[[
	Auctioneer - AH-WindowControl
	Version: 8.2.6359 (SwimmingSeadragon)
	Revision: $Id: Auc-Util-AHWindowControl.lua 6359 2019-09-13 05:07:31Z none $
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds the abilty to drag and reposition the Auction House Frame.
	Protect the Auction Frame from being closed or moved by Escape or Blizzard frames.
	It also adds limited Font and Frame Scaling of the Auction House/CompactUI

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
if not AucAdvanced then return end

local libType, libName = "Util", "AHWindowControl"
local lib, parent, private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill, L = AucAdvanced.GetModuleLocals()

-- Secure attribute handlers - used to modify AuctionFrame layout control
-- SetUIPanelAttribute, UIPanelWindows are defined in Blizzard UIParent.lua
-- GetUIPanelAttribute based on (local) Blizzard function GetUIPanelWindowInfo in UIParent.lua
local GetUIPanelAttribute = GetUIPanelAttribute or function (frame,name)
	local info = UIPanelWindows[frame:GetName()]
	if ( not info ) then
		return;
	end
	if (not frame:GetAttribute("UIPanelLayout-defined") ) then
		return
	end
	local value = frame:GetAttribute("UIPanelLayout-"..name)
	return value
end

local AuctionFrameLoaded = false -- control flag for event handlers


--[[ Event Handlers ]]--

lib.Processors = {
	auctionopen = function()
		if not AuctionFrameLoaded then
			AuctionFrameLoaded = true
			private.MoveFrame()
			-- tech note: AdjustProtection will not work until after AuctionFrame is first opened
			-- in particular, it will not work during "auctionui", which is why we use "auctionopen" instead
			private.AdjustProtection()
		end
		-- restore position on every open, in case UIParent (or another AddOn) has moved it since
		private.RestorePosition()
	end,

	configchanged = function(callbackType, fullsetting, value, settingname, settinggroup, settingbase)
		if settinggroup == "ahwindowcontrol" or settingbase == "profile" then
			if settingbase == "profile" then
				private.checkProfile()
			end
			if AuctionFrameLoaded then
				private.MoveFrame()
				private.AdjustProtection()
				private.RestorePosition()
			end
		end
	end,

	config = function(callbackType, gui)
		if private.SetupConfigGui then private.SetupConfigGui(gui) end
	end,
}

function lib.OnLoad(addon)
	if private.OnLoad then private.OnLoad() end
end


--[[ Setup Functions ]]--

-- checkProfile: Convert settings to new format, all having "ahwindowcontrol" as the module component. Temp function, remove when no longer needed.
local oldtonew = {
	["util.mover.activated"] = "util.ahwindowcontrol.moveenabled",
	["util.mover.rememberlastpos"] = "util.ahwindowcontrol.rememberlastpos",
	["util.mover.anchors"] = "util.ahwindowcontrol.ahframeanchors",
	["util.protectwindow.protectwindow"] = "util.ahwindowcontrol.protectwindow"
}
function private.checkProfile()
	for old, new in pairs(oldtonew) do
		local value = get(old)
		if value ~= nil then
			set(old, nil)
			set(new, value)
		end
	end

	local temp = get("util.ahwindowcontrol.protectwindow")
	if type(temp) ~= "boolean" then
		if temp == 2 then
			set("util.ahwindowcontrol.protectwindow", true)
		else
			set("util.ahwindowcontrol.protectwindow", false)
		end
	end

	temp = get("util.ahwindowcontrol.ahframeanchors")
	if type(temp) ~= "string" then
		if type(temp) == "table" then
			private.setAnchors(unpack(temp, 1, 5))
		else
			set("util.ahwindowcontrol.ahframeanchors", nil)
		end
	end
end

function private.setAnchors(point, relframe, relpoint, offsx, offsy) -- params match the return values from frame:GetPoint()
	-- relframe is assumed to always be UIParent, so is ignored by this function
	if offsy then -- assume if offsy exists then others will exist too
		set("util.ahwindowcontrol.ahframeanchors", format("%s:%s:%.1f:%.1f", point, relpoint, offsx, offsy))
	else
		set("util.ahwindowcontrol.ahframeanchors", nil)
	end
end

function private.getAnchors()
	local point, relpoint, offsx, offsy = strsplit(":", get("util.ahwindowcontrol.ahframeanchors"))
	return point, UIParent, relpoint, tonumber(offsx), tonumber(offsy) -- return values match the parameters for frame:SetPoint()
end

function private.OnLoad()
	private.OnLoad = nil
	default("util.ahwindowcontrol.moveenabled", true)
	default("util.ahwindowcontrol.rememberlastpos", true)
	default("util.ahwindowcontrol.ahframeanchors", "TOPLEFT:TOPLEFT:0.0:-104.0")
	default("util.ahwindowcontrol.protectwindow", false)
	default("util.ahwindowcontrol.auctionscale", 1) --This is the scale of AuctionFrame 1 == default
	default("util.ahwindowcontrol.compactuiscale", 0) --This is the increase of compactUI scale
	default("util.ahwindowcontrol.searchuiscale", 1) --This is the default SearchUI scale

	private.checkProfile()
end

function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id, last
	private.SetupConfigGui = nil

	-- Mover functions
	id = gui:AddTab(libName)
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header", 0, L"AHWC_Interface_WindowMovementOptions") --"Window Movement Options"
	gui:AddControl(id, "Checkbox", 0, 1, "util.ahwindowcontrol.moveenabled", L"AHWC_Interface_AllowMovable") --"Allow the auction frame to be movable?"
	gui:AddTip(id, L"AHWC_HelpTooltip_AllowMovable") --"Ticking this box will enable the ability to relocate the auction frame"
	gui:AddHelp(id, "what is AHWindowControl",
		L"AHWC_Help_whatisthis",--"What is this utility?"
		L"AHWC_Help_whatisthisAnswer")--This utility allows you to drag and relocate the auction frame for this play session. Just click and move where you desire. It also alows you to protect the Auction House from closing when opening certain Blizzard windows."
	gui:AddControl(id, "Checkbox",   0, 1,  "util.ahwindowcontrol.rememberlastpos", L"AHWC_Interface_RemberLastPosition") --"Remember last known window position?"
	gui:AddTip(id, L"AHWC_HelpToolTip_RemberLastPosition") --"If this box is checked, the auction frame will reopen in the last location it was moved to."
	gui:AddHelp(id, "what is remeberpos",
		L"AHWC_Help_RemberLastPosition", --"Remember last known window position?"
		L"AHWC_Help_RemberLastPositionAnswer") --"This will remember the auction frame's last position and re-apply it each session."

	-- Window Protection
	gui:AddControl(id, "Header", 0,	L"AHWC_Interface_WindowProtectionOptions") --WindowProtectionOptions
	gui:AddControl(id, "Checkbox",   0, 1,  "util.ahwindowcontrol.protectwindow",  L"AHWC_Interface_ProtectAuctionWindow") --Protect the Auction House window:
	gui:AddTip(id, L"AHWC_HelpToolTip_PreventClosingAuctionHouse") --This will prevent other windows from closing the Auction House window when you open them, according to your settings.
	gui:AddHelp(id, "What is ProtectWindow",
		L"AHWC_Help_ProtectWindow", --What does Protecting the AH Window do?
		L"AHWC_Help_ProtectWindowAnswer")
		--The Auction House window is normally closed when you open other windows, such as the Social window, the Quest Log, or your profession windows.  This option allows it to remain open, behind those other windows.

	--AuctionFrame Scale
	gui:AddControl(id, "Header", 0, "") --Spacer for options
	gui:AddControl(id, "Header", 0,	L"AHWC_Interface_WindowSizeOptions") --Window Size Options
	gui:AddControl(id, "NumeriSlider", 0, 1, "util.ahwindowcontrol.auctionscale", 0.5, 2, 0.1, L"AHWC_Interface_AuctionHouseScale") --Auction House Scale
	gui:AddTip(id, L"AHWC_HelpToolTip_AuctionHouseScale") --This option allows you to adjust the overall size of the Auction House window. Default is 1.
	gui:AddHelp(id, "what is Auction House Scale",
			L"AHWC_Help_AuctionHouseScale", --Auction House Scale?
			L"AHWC_Help_AuctionHouseScaleAnswer")--The Auction House scale slider adjusts the overall size of the entire Auction House window. The default size is 1.
	--CompactUI
	gui:AddControl(id, "NumeriSlider", 0, 1, "util.ahwindowcontrol.compactuiscale", -5, 5, 0.2, L"AHWC_Interface_CompactUIFontScale") --CompactUI Font Scale
	gui:AddTip(id, L"AHWC_HelpTooltip_CompactUIFontScale") --This option allows you to adjust the text size of the CompactUI on the Browse tab. The default size is 0.
	gui:AddHelp(id, "what is CompactUI Font Scale",
			L"AHWC_Help_CompactUIFontScale", --CompactUI Font Scale?
			L"AHWC_Help_CompactUIFontScaleAnswer") --The CompactUI Font Scale slider adjusts the text size displayed in AucAdvance CompactUI option in the Browse Tab. The default size is 0.
	--SearchUI
	gui:AddControl(id, "NumeriSlider", 0, 1, "util.ahwindowcontrol.searchuiscale", 0.5, 2, 0.1, L"AHWC_Interface_SearchUIScale") --SearchUI Scale
	gui:AddTip(id, L"AHWC_HelpTooltip_SearchUIScale") --This option allows you to adjust the overall size of the non auction house SearchUI window. The default size is 1.
	gui:AddHelp(id, "what is SearchUI Scale",
			L"AHWC_Help_SearchUIScale", --SearchUI Scale?
			L"AHWC_Help_SearchUIScaleAnswer") --The SearchUI scale slider adjusts the overall size of the non auction house SearchUI window. The default size is 1.
end


--[[ Window Control Functions ]]--

-- MoveFrame: Enable or disable the move scripts, apply scale settings
local function OnMouseDown(frame)
	frame:StartMoving()
end
local function OnMouseUp(frame)
	frame:StopMovingOrSizing()
	private.setAnchors(frame:GetPoint()) --store the current anchor points
end
function private.MoveFrame()
	--AH needs to exist
	if AuctionFrame then
		if get("util.ahwindowcontrol.moveenabled") then
			AuctionFrame:SetMovable(true)
			AuctionFrame:SetClampedToScreen(true)
			AuctionFrame:SetScript("OnMouseDown", OnMouseDown)
			AuctionFrame:SetScript("OnMouseUp", OnMouseUp)
		else
			AuctionFrame:SetMovable(false)
			AuctionFrame:SetScript("OnMouseDown", AucAdvanced.NOPFUNCTION)
			AuctionFrame:SetScript("OnMouseUp", AucAdvanced.NOPFUNCTION)
		end
		if get("util.ahwindowcontrol.auctionscale") then
			AuctionFrame:SetScale(get("util.ahwindowcontrol.auctionscale"))
		end
		if get("util.compactui.activated") then
			for i = 1,14 do
				local button = _G["BrowseButton"..i]
				local increase = get('util.ahwindowcontrol.compactuiscale') or 0
				if not button.Count then return end -- we get called before compactUI has built the frame
				button.Count:SetFont(STANDARD_TEXT_FONT, 11 + increase)
				button.Name:SetFont(STANDARD_TEXT_FONT, 10 + increase)
				button.rLevel:SetFont(STANDARD_TEXT_FONT, 11 + increase)
				button.iLevel:SetFont(STANDARD_TEXT_FONT, 11 + increase)
				button.tLeft:SetFont(STANDARD_TEXT_FONT, 11 + increase)
				button.Owner:SetFont(STANDARD_TEXT_FONT, 10 + increase)
				button.Value:SetFont(STANDARD_TEXT_FONT, 11 + increase)
			end
		end
	end
	--searchUi needs to exist
	if AucAdvanced.Modules.Util.SearchUI and AucAdvanced.Modules.Util.SearchUI.Private.gui then
		if get("util.ahwindowcontrol.searchuiscale") then
			AucAdvanced.Modules.Util.SearchUI.Private.gui:SetScale(get("util.ahwindowcontrol.searchuiscale"))
		end
	end
end

-- RestorePosition: Restore saved AuctionFrame position
function private.RestorePosition()
	if get("util.ahwindowcontrol.rememberlastpos") then
		AuctionFrame:ClearAllPoints()
		AuctionFrame:SetPoint(private.getAnchors())
	end
end

-- AdjustProtection: Apply or remove AuctionFrame protection
function private.AdjustProtection()
 	--If the auction frame hasn't been opened yet, we can't do anything.
	if not UIPanelWindows["AuctionFrame"] then
		return
	end

	if get("util.ahwindowcontrol.protectwindow") then -- Protect AuctionFrame from being closed by UIPanel system
		if GetUIPanelAttribute(AuctionFrame,"area") then -- area attribute has a value, i.e. frame is not protected
			-- If AuctionFrame is visible we need to de-synch it from the UIPanel system
			if AuctionFrame:IsVisible() then
				-- Temporarily set AuctionFrame.Hide to an empty function so game will think it is hiding AuctionFrame.
				AuctionFrame.Hide = AucAdvanced.NOPFUNCTION
				-- Tell the game to "hide" the frame
				HideUIPanel(AuctionFrame)
				-- Real AuctionFrame.Hide is stored in the meta-table, restore it by nil-ing our temp function
				AuctionFrame.Hide = nil
			end
			-- Disable the standard frame handler
			SetUIPanelAttribute(AuctionFrame, "area", nil)
		end
	else -- Don't protect AuctionFrame; i.e. let the UIPanel system handle it
		if not GetUIPanelAttribute(AuctionFrame, "area") then -- area attribute has no value, i.e. frame is protected
			--Enable the standard FrameHandler
			SetUIPanelAttribute(AuctionFrame, "area", "doublewide")
			-- If AuctionFrame is visible we need to synch it with the UIPanel system
			if AuctionFrame:IsVisible() then
				-- Temporarily set AuctionFrame.IsShown to an empty function so AuctionFrame appears to be hidden.
				AuctionFrame.IsShown = AucAdvanced.NOPFUNCTION
				-- Tell the game to "show" the frame, making the client aware of our adjusted setting.
				ShowUIPanel(AuctionFrame, 1)
				-- Real AuctionFrame.IsShown is stored in the meta-table, restore it by nil-ing our temp function
				AuctionFrame.IsShown = nil
			end
		end
	end
end


AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-AHWindowControl/Auc-Util-AHWindowControl.lua $", "$Rev: 6359 $")
