--[[
	Auctioneer - BasicFilter
	Version: 8.2.6364 (SwimmingSeadragon)
	Revision: $Id: BasicFilter.lua 6364 2019-09-22 00:20:05Z none $
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds statistical history to the auction data that is collected
	when the auction is scanned, so that you can easily determine what price
	you will be able to sell an item for at auction or at a vendor whenever you
	mouse-over an item in the game

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

local libType, libName = "Filter", "Basic"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill, _TRANS = AucAdvanced.GetModuleLocals()
local Const = AucAdvanced.Const
local Resources = AucAdvanced.Resources

local IgnoreList, IgnoreLookup = {}, {}
local SelectedIgnore = 0
local GUILoaded = false

local NUM_IGNORE_BUTTONS = 18
local PLAYER_NAME = Const.PlayerName

--[[ Exported Library Functions ]]--

function lib.AuctionFilter(operation, itemData)
	if not get("filter.basic.activated") then return end

	if itemData.quality < get("filter.basic.minquality") then
		return true
	end
	if itemData.itemLevel < get("filter.basic.minlevel") then
		return true
	end
	local seller = itemData.sellerName
	if get("filter.basic.ignoreself") and seller == PLAYER_NAME then
		return true
	end
	if lib.IsPlayerIgnored(seller) then
		return true
	end
end

function lib.IsPlayerIgnored(name)
	if IgnoreLookup[name] then
		return true
	end
end
lib.IgnoreList_IsPlayerIgnored = lib.IsPlayerIgnored -- Deprecated - backward compatibility only

function lib.AddPlayerIgnore(name)
	name = private.ValidateName(name)
	if not name then return end

	if not IgnoreLookup[name] then
		tinsert(IgnoreList, name)
		table.sort(IgnoreList)
		for i, n in ipairs(IgnoreList) do
			IgnoreLookup[n] = i
		end
	end
	SelectedIgnore = IgnoreLookup[name]
	private.IgnoreListUpdate()
end

function lib.RemovePlayerIgnore(name)
	local index = IgnoreLookup[name]
	if not index then return end

	IgnoreLookup[name] = nil
	tremove(IgnoreList, index)
	if SelectedIgnore == index then
		SelectedIgnore = 0
	elseif SelectedIgnore > index then
		SelectedIgnore = SelectedIgnore - 1
	end
	for i, n in ipairs(IgnoreList) do
		IgnoreLookup[n] = i
	end
	private.IgnoreListUpdate()
end

function lib.PromptSellerIgnore(name, parent, point, relativeFrame, relativePoint, ofsx, ofsy)
	name = private.ValidateName(name)
	if not name then return end
	if not (parent and point and relativeFrame and relativePoint) then return end -- todo: implement a default anchor of some sort

	local isPromptRemove = lib.IsPlayerIgnored(name)
	if isPromptRemove then
		private.IgnorePrompt.text:SetText(_TRANS("BASC_Interface_RemovePlayerIgnore"))--Remove player from Ignore List
	else
		private.IgnorePrompt.text:SetText(_TRANS("BASC_Interface_AddPlayerIgnore"))--Add player to Ignore List
	end
	private.IgnorePrompt.name:SetText(name)
	private.curPromptName = name
	private.isPromptRemove = isPromptRemove
	private.IgnorePrompt:ClearAllPoints()
	private.IgnorePrompt:SetParent(parent)
	private.IgnorePrompt:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
	private.IgnorePrompt:SetFrameStrata("TOOLTIP")
	private.IgnorePrompt:Show()
end

--[[ Support Functions ]]--

function private.ValidateName(name)
	if type(name) ~= "string" or #name < 2 then return end
	-- Name is stored in the SV with the first letter capitalized and the rest lowercased
	-- This is how it should appear in the ScanData image, and how we want it displayed in our GUI
	-- We must allow for UTF-8 encoding of first character
	local firstbyte, split = name:byte(1), 1
	if firstbyte >= 240 then -- quad
		split = 4
	elseif firstbyte >= 224 then -- triple
		split = 3
	elseif firstbyte >= 192 then -- double
		split = 2
	end
	name = name:sub(1,split):upper()..name:sub(split+1):lower()

	return name
end

function private.IgnoreListUpdate()
	if not GUILoaded then return end
	local numIgnores = #IgnoreList
	if SelectedIgnore > 0 then
		private.UnignoreButton:Enable()
	else
		private.UnignoreButton:Disable()
	end

	local ignoreOffset = FauxScrollFrame_GetOffset(AucFilterBasicScrollFrame)
	for ind = 1, NUM_IGNORE_BUTTONS do
		local ignoreIndex = ind + ignoreOffset
		local ignoreButton = private.ListButtons[ind]
		ignoreButton:SetText(IgnoreList[ignoreIndex] or "")
		-- Update the highlight
		if ( ignoreIndex == SelectedIgnore ) then
			ignoreButton:LockHighlight()
		else
			ignoreButton:UnlockHighlight()
		end

		if ( ignoreIndex > numIgnores ) then
			ignoreButton:Hide()
		else
			ignoreButton:Show()
		end
	end

	-- ScrollFrame stuff
	FauxScrollFrame_Update(AucFilterBasicScrollFrame, numIgnores, NUM_IGNORE_BUTTONS, 16)
end

function private.IgnoreListButtonOnClick(button)
	local index = button:GetID() + FauxScrollFrame_GetOffset(AucFilterBasicScrollFrame)
	if index == SelectedIgnore then
		SelectedIgnore = 0
	else
		SelectedIgnore = index
	end
	private.IgnoreListUpdate()
end

function private.OnPromptYes()
	local name = private.curPromptName
	private.curPromptName = nil
	private.IgnorePrompt:Hide()
	if private.isPromptRemove then
		lib.RemovePlayerIgnore(name)
	else
		lib.AddPlayerIgnore(name)
	end
end

function private.OnPromptNo()
	private.curPromptName = nil
	private.IgnorePrompt:Hide()
end

function private.OnPromptHide()
	private.curPromptName = nil
	if private.IgnorePrompt:IsShown() then
		-- prompt has been implicitly hidden by hiding parent
		-- explicitly hide prompt, so it won't reappear when parent is shown again
		private.IgnorePrompt:Hide()
	end
end

--[[ Initialization and Event Handlers ]]--

local function UpdateDB()
	local realm = Const.PlayerRealm

	if not AucAdvancedFilterBasic_IgnoreList then
		_G["AucAdvancedFilterBasic_IgnoreList"] = {}
	end

	local realmtable = AucAdvancedFilterBasic_IgnoreList[realm]
	if not realmtable then
		realmtable = {}
		AucAdvancedFilterBasic_IgnoreList[realm] = realmtable
	end

	IgnoreList = realmtable.List
	if not IgnoreList then
		IgnoreList = {}
		realmtable.List = IgnoreList

		-- If there are old-style data, merge them
		if realmtable.Alliance then
			for _, name in ipairs(realmtable.Alliance) do
				tinsert(IgnoreList, name)
			end
		end
		if realmtable.Horde then
			for _, name in ipairs(realmtable.Horde) do
				tinsert(IgnoreList, name)
			end
		end
		if realmtable.Alliance or realmtable.Horde then
			table.sort(IgnoreList)
		end
	end

	IgnoreLookup = {}
	for i, name in ipairs(IgnoreList) do
		IgnoreLookup[name] = i
	end
	private.IgnoreListUpdate()

	-- delete any obsolete entries
	-- temp fix, to be removed at a later date -- ###
	realmtable.Neutral = nil
	realmtable.Alliance = nil
	realmtable.Horde = nil

	UpdateDB = nil
end

local function OnLoadRunOnce()
	OnLoadRunOnce = nil
	default("filter.basic.activated", true)
	default("filter.basic.minquality", 1)
	default("filter.basic.minlevel", 0)
	default("filter.basic.ignoreself", false)

	UpdateDB()
end
function lib.OnLoad(addon)
	if OnLoadRunOnce then OnLoadRunOnce() end
end

lib.Processors = {}


local function SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id, last
	SetupConfigGui = nil

	id = gui:AddTab(libName, libType.." Modules")
	gui:AddHelp(id, "what basic filter",
		_TRANS('BASC_Help_WhatBasicFilter') ,--What is the Basic Filter?
		_TRANS('BASC_Help_WhatBasicFilterAnswer') )--This filter allows you to specify certain minimums for an item to be entered into the data stream, such as the minimum item level, and the minimum quality (Junk, Common, Uncommon, Rare, etc). It also allows you to specify items from a certain seller to not be recorded.  One use of this is if a particular seller posts all of his items well over or under the market price, you can ignore all of his/her items

	gui:AddControl(id, "Header", 0, _TRANS('BASC_Interface_BasicFilterOptions') )--Basic filter options
	last = gui:GetLast(id)

	gui:AddControl(id, "Note",		0, 1, nil, nil, " ")
	gui:AddControl(id, "Checkbox",	0, 1,"filter.basic.activated",  _TRANS('BASC_Interface_EnableBasicFilter') )--Enable use of the Basic filter
	gui:AddTip(id, _TRANS('BASC_HelpTooltip_EnableBasicFilterAnswer') )--Ticking this box will enable the basic filter to perform filtering of your auction scans

	gui:AddControl(id, "Note",		0, 1, nil, nil, " ")
	gui:AddControl(id, "Checkbox",	0, 1, "filter.basic.ignoreself", _TRANS('BASC_Interface_IgnoreOwnAuctions') )--Ignore own auctions
	gui:AddTip(id, _TRANS('BASC_Help_IgnoreOwnAuctionsAnswer') )--Ticking this box will disable adding auctions that you posted yourself to the snapshot.

	gui:AddControl(id, "Subhead",	0, _TRANS('BASC_Interface_FilterQuality') )--Filter by Quality
	gui:AddControl(id, "Slider",	0, 1, "filter.basic.minquality", 0, 4, 1, _TRANS('BASC_Interface_MinimumQuality') )--Minimum Quality: %d
	gui:AddTip(id, _TRANS('BASC_HelpTooltip_MinimumQuality').."\n"..--Use this slider to choose the minimum quality to go into storage.
		"\n"..
		"0 = |cff9d9d9d".._TRANS('BASC_HelpTooltip_MinimumQualityJunk').."|r,\n"..--Junk
		"1 = |cffffffff".._TRANS('BASC_HelpTooltip_MinimumQualityCommon').."|r,\n"..--Common
		"2 = |cff1eff00".._TRANS('BASC_HelpTooltip_MinimumQualityUncommon').."|r,\n"..--Uncommon
		"3 = |cff0070dd".._TRANS('BASC_HelpTooltip_MinimumQualityRare').."|r,\n"..--Rare
		"4 = |cffa335ee".._TRANS('BASC_HelpTooltip_MinimumQualityEpic').."|r")--Epic

	gui:AddControl(id, "Subhead",	0, _TRANS('BASC_Interface_FilterItemLevel') )--Filter by Item Level
	gui:AddControl(id, "NumberBox",	0, 1, "filter.basic.minlevel", 0, 400, _TRANS('BASC_Interface_MinimumItemLevel') )--Minimum item level
	gui:AddTip(id, _TRANS('BASC_HelpTooltip_MinimumItemLevel') )--Enter the minimum item level to go into storage.


	gui:SetLast(id, last)
	gui:AddControl(id, "Subhead", 0.55, _TRANS('BASC_Interface_IgnoreList'))--Ignore List
	local listframe = CreateFrame("Frame", nil, gui.tabs[id].content)
	listframe:SetHeight(288)
	listframe:SetWidth(200)
	private.ListButtons = {}
	local lastbutton
	for index = 1, NUM_IGNORE_BUTTONS do
		local button = CreateFrame("Button", nil, listframe, "AucFilterBasicListLineTemplate")
		button:SetID(index)
		if lastbutton then
			button:SetPoint("TOP", lastbutton, "BOTTOM")
		else
			button:SetPoint("TOPLEFT", listframe, "TOPLEFT")
		end
		button:SetScript("OnClick", private.IgnoreListButtonOnClick)
		lastbutton = button
		tinsert(private.ListButtons, button)
	end
	local ignoreplayerbutton = CreateFrame("Button", nil, listframe, "AucFilterBasicWideButtonTemplate")
	ignoreplayerbutton:SetPoint("TOPRIGHT", listframe, "BOTTOM", 0, -5)
	ignoreplayerbutton:SetScript("OnClick", function() StaticPopup_Show("BASICFILTER_ADD_IGNORE") end)
	ignoreplayerbutton:SetText(IGNORE_PLAYER)
	local stopignorebutton = CreateFrame("Button", nil, listframe, "AucFilterBasicWideButtonTemplate")
	stopignorebutton:SetPoint("TOPLEFT", listframe, "BOTTOM", 0, -5)
	stopignorebutton:SetScript("OnClick", function() lib.RemovePlayerIgnore(IgnoreList[SelectedIgnore]) end)
	stopignorebutton:SetText(STOP_IGNORE)
	private.UnignoreButton = stopignorebutton
	AucFilterBasicScrollFrame:SetParent(listframe) -- AucFilterBasicScrollFrame was created by BasicFilter.xml
	AucFilterBasicScrollFrame:SetPoint("TOPRIGHT", listframe, "TOPRIGHT", -30, 0)
	AucFilterBasicScrollFrame:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, 16, private.IgnoreListUpdate)
	end)
	ScrollFrame_OnLoad(AucFilterBasicScrollFrame)
	gui:AddControl(id, "Custom", 0.55, 0, listframe)

	StaticPopupDialogs["BASICFILTER_ADD_IGNORE"] = {
		text = _TRANS("BASC_Interface_PlayerIgnoreLabel"),
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		maxLetters = 12,

		OnAccept = function(self)
			lib.AddPlayerIgnore(self.editBox:GetText())
		end,
		OnShow = function(self)
			self.editBox:SetFocus()
		end,
		OnHide = function(self)
			ChatEdit_FocusActiveWindow();
			self.editBox:SetText("");
		end,
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent()
			lib.AddPlayerIgnore(parent.editBox:GetText())
			parent:Hide()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,

		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	}

	GUILoaded = true
	private.IgnoreListUpdate()
end
lib.Processors.config = function(callbackType, gui)
	if SetupConfigGui then SetupConfigGui(gui) end
end

--[[ Prompt and Dialog Setup ]]--

private.IgnorePrompt = CreateFrame("Frame", nil, UIParent)
private.IgnorePrompt:Hide()
private.IgnorePrompt:SetBackdrop({
	  bgFile = "Interface/Tooltips/ChatBubble-Background",
	  edgeFile = "Interface/Minimap/TooltipBackdrop",
	  tile = true, tileSize = 32, edgeSize = 10,
	  insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
private.IgnorePrompt:SetBackdropColor(0,0,0, 1)
private.IgnorePrompt:SetWidth(100)
private.IgnorePrompt:SetHeight(76)
private.IgnorePrompt:SetPoint("CENTER", UIParent, "CENTER")
private.IgnorePrompt:SetClampedToScreen(true)
private.IgnorePrompt:SetScript("OnHide", private.OnPromptHide)
-- todo: can we hide on ESC too?

private.IgnorePrompt.text = private.IgnorePrompt:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall" )
private.IgnorePrompt.text:SetPoint("TOP", private.IgnorePrompt, "TOP", 0, -8)
private.IgnorePrompt.text:SetWidth(94)
private.IgnorePrompt.text:SetNonSpaceWrap(true)

private.IgnorePrompt.name = private.IgnorePrompt:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall" )
private.IgnorePrompt.name:SetPoint("TOP", private.IgnorePrompt.text, "BOTTOM", 0, -4)
private.IgnorePrompt.name:SetTextColor(1, 1, 1)

private.IgnorePrompt.yes = CreateFrame("Button", nil, private.IgnorePrompt, "AucPromptSmallButtonTemplate")
private.IgnorePrompt.yes:SetPoint("BOTTOMLEFT", private.IgnorePrompt, "BOTTOMLEFT", 10, 8)
private.IgnorePrompt.yes:SetScript("OnClick", private.OnPromptYes)
private.IgnorePrompt.yes:SetText(YES)

private.IgnorePrompt.no = CreateFrame("Button", nil, private.IgnorePrompt, "AucPromptSmallButtonTemplate")
private.IgnorePrompt.no:SetPoint("BOTTOMRIGHT", private.IgnorePrompt, "BOTTOMRIGHT", -10, 8)
private.IgnorePrompt.no:SetScript("OnClick", private.OnPromptNo)
private.IgnorePrompt.no:SetText(NO)

AucAdvanced.RegisterRevision("$URL: Auc-Filter-Basic/BasicFilter.lua $", "$Rev: 6364 $")
