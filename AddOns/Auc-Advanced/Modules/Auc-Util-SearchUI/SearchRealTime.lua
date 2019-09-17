--[[
	Auctioneer - Search UI - Realtime module
	Version: 8.2.6415 (SwimmingSeadragon)
	Revision: $Id: SearchRealTime.lua 6415 2019-09-13 05:07:31Z none $
	URL: http://auctioneeraddon.com/

	This Auctioneer module allows the user to search the current Browse tab
	results in real time, without requiring scans or an up-to-date snapshot.
	It also provides top- and bottom-scanning capabilities (i.e. first and
	last AH pages) to find deals on items about to expire, or recently added
	to the AH.

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
--]]

if not AucSearchUI then return end

local AddOnName = ...
local embedpath
AddOnName = AddOnName:lower()
if AddOnName == "auc-util-searchui" then
	embedpath = "Interface\\AddOns\\"
elseif AddOnName == "auc-advanced" then
	embedpath = "Interface\\AddOns\\Auc-Advanced\\Modules\\"
else
	return -- unknown location, cannot continue
end

local lib, parent, private = AucSearchUI.NewSearcher("RealTime")
if not lib then return end
local AucPrint,decode,_,_,replicate,empty,_,_,_,debugPrint,fill = AucAdvanced.GetModuleLocals()
local get,set,default,Const = AucSearchUI.GetSearchLocals()
lib.tabname = "RealTime"

private.IsScanning = false
private.ItemTable = {}
private.searchertable = {}
private.buttontable = {}
private.offset = 0
private.IsRefresh = false
private.pageCount = -1 -- signal value, to indicate not previously tested
private.scannedPage = -1

default("realtime.always", true)
default("realtime.reload.enable", true)
default("realtime.reload.interval", 20)
default("realtime.reload.topscan", false)
default("realtime.reload.manpause", 60)
default("realtime.maxprice", 10000000)
default("realtime.alert.chat", true)
default("realtime.alert.showwindow", true)
default("realtime.alert.sound", "DoorBell")
default("realtime.skipresults", false)

function private.MakeGuiConfig(gui)
	private.MakeGuiConfig = nil
	private.SearchUIgui = gui
	local id = gui:AddTab(lib.tabname, "Options")
	gui:MakeScrollable(id)

	gui:AddControl(id, "Header",      0,   "RealTime Search Options")

	gui:AddControl(id, "Subhead",       0,    "Scan Settings")
	gui:AddControl(id, "Checkbox",      0, 1, "realtime.always", "Search while browsing")
	gui:AddTip(id, "Enables searching for results when browsing or scanning")
	gui:AddControl(id, "Checkbox",      0, 1, "realtime.reload.enable", "Enable automatic last page refreshing")
	gui:AddTip(id, "Refreshes the last page, looking for new bargains. (Bottomscanning)")
	gui:AddControl(id, "Slider",        0, 2, "realtime.reload.interval", 6, 60, 1, "Reload interval: %s seconds")
	gui:AddControl(id, "Slider",        0, 2, "realtime.reload.manpause", 10, 120, 1, "Pause after a manual search: %s seconds")
	gui:AddControl(id, "Checkbox",      0, 2, "realtime.reload.topscan", "Refresh first page as well")
	gui:AddTip(id, "Refreshes the first page, looking for bids about to expire")

	gui:AddControl(id, "Subhead",       0,    "Alert Settings")
	gui:AddControl(id, "Checkbox",      0, 1, "realtime.alert.chat", "Show alert in chat window")
	gui:AddControl(id, "Checkbox",      0, 1, "realtime.alert.showwindow", "Show SearchUI window")
	gui:AddTip(id, "When a bargain is found, opens the SearchUI window to facilitate buying the bargain")
	gui:AddControl(id, "Selectbox",     0, 1, {
		{"none", "None (do not play a sound)"},
		{"LEVELUP", "Level Up"},
		{"AuctionWindowOpen", "AuctionHouse Open"},
		{"AuctionWindowClose", "AuctionHouse Close"},
		{"RaidWarning", "Raid Warning"},
		{"DoorBell", "DoorBell (BottomScan-style)"},
	}, "realtime.alert.sound")
	gui:AddTip(id, "The selected sound will play whenever a bargain is found")
	gui:AddControl(id, "Subhead",       0,    "Power-user setting: One-Click Buying")
	gui:AddControl(id, "Checkbox",      0, 1, "realtime.skipresults", "Skip results and go straight to purchase confirmation !Power-user setting!")
	gui:AddTip(id, "One-Click Buying: RTS will queue the purchase instead of listing the item in SearchUI")
	gui:AddControl(id, "Subhead",          0,    "Searchers to use")
	for name, searcher in pairs(AucSearchUI.Searchers) do
		if searcher and searcher.Search then
			gui:AddControl(id, "Checkbox", 0, 1, "realtime.use."..name, name)
			gui:AddTip(id, "Include "..name.." when searching realtime")
		end
	end
end
function lib:MakeGuiConfig(gui)
	if private.MakeGuiConfig then private.MakeGuiConfig(gui) end
end

lib.Processor = {
	config = function(sub, setting, value)
		-- perform certain resets on config change

		-- Changes that affect RTSButtons status
		if sub == "changed" and setting == "realtime.reload.enable" then
			for _, button in ipairs(private.buttontable) do
				button:SetState()
			end
		end
	end,

	auctionopen = function()
		lib.SetTimerInterval(get("realtime.reload.interval"))
	end,
}

--lib.RefreshPage()
--role: refreshes the page based on settings, and updates private.lastPage, private.interval, and private.manualSearchPause
function lib.RefreshPage()
	--Check to see if the AH is open for business
	if not (AuctionFrame and AuctionFrame:IsVisible()) then
		lib.SetTimerInterval(120) -- basically do nothing - we wait for auctionopen event
		return
	end

	--Check to see if AucAdv is already scanning
	if AucAdvanced.Scan.IsScanning() or AucAdvanced.Scan.IsPaused() then
		lib.SetTimerInterval(get("realtime.reload.manpause"))
		private.findLast = nil
		return
	end

	--Check to see if we can send a query
	if not (CanSendAuctionQuery()) then
		lib.SetTimerInterval(1) --try again in one second
		return
	end

	lib.SetTimerInterval(get("realtime.reload.interval"))

	--Get the current number of auctions and pages
	local count, totalCount = GetNumAuctionItems("list")
	local totalPages = floor((totalCount-1)/NUM_AUCTION_ITEMS_PER_PAGE)
	if (totalPages < 0) then
		totalPages = 0
	end

	-- Detect change of number of pages, and go into findLast mode to find the (new) last page quickly
	if totalPages ~= private.pageCount then
		private.pageCount = totalPages
		private.findLast = true
	end

	local page = private.pageCount

	if private.findLast then
		private.topScan = nil
	else
		if get("realtime.reload.topscan") then
			private.topScan = not private.topScan -- flip the variable, so we alternate first and last pages
			if private.topScan then
				page = 0
			end
		else
			private.topScan = nil -- make sure we don't topScan if we don't want to
		end
		if page > 0 then
			--every 5 pages, go back one just to doublecheck that nothing got by us
			private.offset = (private.offset + 1) % 5
			if private.offset == 0 then
				page = page - 1
				private.findLast = true
			end
		end
	end

	AuctionFrameBrowse.page = page
	private.scannedPage = page
	SortAuctionClearSort("list")
	if private.topScan then
		-- When top scanning, sort auctions by time left
		SortAuctionSetSort("list", "duration")
	end
	private.IsRefresh = true
	AucAdvanced.Scan.SetAuctioneerQuery()
	QueryAuctionItems(nil, nil, nil, page, nil, nil, nil, nil, nil)
	lib.SignalRTSButton()
end

-- private.OnUpdate()
-- checks whether it's time to refresh the page
-- called from the OnUpdate script of the currently visible RTSButton
function private.OnUpdate(me, elapsed)
	-- Bail out immediately if we're not scanning
	if not private.IsScanning then
		return
	end

	-- We use GetTime() to check how long since last update, instead of using elapsed
	-- Workaround for the possibility of OnUpdate getting called multiple times per frame
	local now = GetTime()

	--Check whether enough time has elapsed to do anything
	if now - private.lasttime < private.interval then
		return
	end
	private.lasttime = now

	if get("realtime.reload.enable") then
		-- if we've gotten to this point, it's time to refresh the page
		lib.RefreshPage()
	else
		-- at this point we are waiting to see if the user enables scanning
		-- keep checking at short intervals
		private.interval = 2
	end
end

function lib.SetTimerInterval(interval)
	private.interval = interval
	private.lasttime = GetTime()
end
lib.SetTimerInterval(2) -- initialize

--lib.FinishedPage()
--called by AucAdv via SearchUI main when a page is done
--role: starts the page scan
function lib.FinishedPage()
	--if we're not scanning, we don't need to do anything
	--if we don't have searching while browsing on, then don't do anything if we're not actively refreshing
	local always = get("realtime.always")
	if not private.IsRefresh then
		lib.SetTimerInterval(get("realtime.reload.manpause"))
		private.findLast = nil
	end
	if (not private.IsScanning)
			or (not always and (not private.IsRefresh or AucAdvanced.Scan.IsScanning())) then
		lib.SetTimerInterval(get("realtime.reload.manpause"))
		private.IsRefresh = false
		private.findLast = nil
		return
	end
	--scan the current page
	lib.ScanPage()
end

--[[
	lib.ScanPage()
	Called: from lib.FinishedPage, when AA is done with a page
	Function: Scans current AH page for bargains
	Note: will return if current page has > NUM_AUCTION_ITEMS_PER_PAGE auctions on it
	(NUM_AUCTION_ITEMS_PER_PAGE defined as 50 in Blizzard_AuctionUI.lua)
]]
function lib.ScanPage()
	local isRefresh = private.IsRefresh
	private.IsRefresh = false
	if not private.IsScanning then return end
	local batch, totalCount = GetNumAuctionItems("list")
	if batch > NUM_AUCTION_ITEMS_PER_PAGE then
		-- we don't want to freeze the computer by trying to process a getall, so return
		return
	end
	if batch == 0 then -- found an empty page
		if isRefresh and totalCount > 0 then
			lib.SetTimerInterval(.5) -- immediate refresh to find the last page
			private.findLast = true
		end
		return
	end

	--this is a new page, so no alert sound has been played for it yet
	private.playedsound = false

	if isRefresh and private.findLast then
		-- in findLast mode - hunting for the last page
		local topPage = floor((totalCount-1)/NUM_AUCTION_ITEMS_PER_PAGE)
		if topPage < 0 then
			topPage = 0
		end
		if private.scannedPage == topPage then
			private.findLast = nil -- found the last page
		else
			lib.SetTimerInterval(3) -- short interval to find the last page quickly
		end
	end

	--Put all the searchers that are activated into a local table, so that the get()s are only called every page, not every auction
	for name, searcher in pairs(AucSearchUI.Searchers) do
		if get("realtime.use."..name) then
			tinsert(private.searchertable, searcher)
		end
	end
	local skipresults = get("realtime.skipresults")
	for i = 1, batch do
		if AucAdvanced.Scan.GetAuctionItem("list", i, private.ItemTable) then
			for i, searcher in pairs(private.searchertable) do
				if AucSearchUI.SearchItem(searcher.name, private.ItemTable, false, skipresults) then
					private.alert(private.ItemTable[Const.LINK], private.ItemTable["cost"], private.ItemTable["reason"])
					if skipresults then
						AucAdvanced.Buy.QueueBuy(private.ItemTable[Const.LINK],
							private.ItemTable[Const.SELLER],
							private.ItemTable[Const.COUNT],
							private.ItemTable[Const.MINBID],
							private.ItemTable[Const.BUYOUT],
							private.ItemTable["cost"],
							AucSearchUI.Private.cropreason(private.ItemTable["reason"]),
							true -- do not trigger a search if CoreBuy is unable to find this auction
							)
					else
						AucSearchUI.Private.repaintSheet()
					end
				end
			end
		end
		wipe(private.ItemTable)
	end
	wipe(private.searchertable)
end


-- Conversion table for PlaySound change -- HYBRID73
local lookupSound
if SOUNDKIT then
	lookupSound = {
		["LEVELUP"] = 888, -- not in SOUNDKIT
		["AuctionWindowOpen"] = SOUNDKIT.AUCTION_WINDOW_OPEN,
		["AuctionWindowClose"] = SOUNDKIT.AUCTION_WINDOW_CLOSE,
		["RaidWarning"] = SOUNDKIT.RAID_WARNING,
	}
else
	lookupSound = {}
end

--private.alert()
--alerts the user that a deal has been found,
--both by opening the searchUI panel and playing a sound
--(subject to options)
function private.alert(link, cost, reason)
	if get("realtime.alert.chat") then
		AucPrint("SearchUI: "..reason..": Found "..link.." for "..AucAdvanced.Coins(cost, true))
	end
	if get("realtime.alert.showwindow") and (not get("realtime.skipresults")) then
		AucSearchUI.Show()
		if private.SearchUIgui then
			if private.SearchUIgui.tabs.active then
				private.SearchUIgui:ContractFrame(private.SearchUIgui.tabs.active)
			end
			private.SearchUIgui:ClearFocus()
		end
	end
	local SoundPath = get("realtime.alert.sound")
	if SoundPath and (SoundPath ~= "none") and not private.playedsound then
		private.playedsound = true
		if SoundPath == "DoorBell" then
			PlaySoundFile(embedpath.."Auc-Util-SearchUI\\DoorBell.mp3")
		else
			PlaySound(lookupSound[SoundPath] or SoundPath) -- HYBRID73
		end
	end
end

--[[
	lib.SetScanning(boolean)
	Turn RTS bottom/top scanning on or off
	Note: active RTS scanning can only occur if one of the RTS buttons is visible
--]]
function lib.SetScanning(active)
	if active then
		if not private.IsScanning then
			private.IsScanning = true
			lib.SetTimerInterval(.5) -- just started scanning so do first scan immediately
		end
	else
		private.IsScanning = false
	end
	for _, button in ipairs(private.buttontable) do
		button:SetState()
	end
end

-- Scripts for RTSButtons
local function OnClick(self, button)
	if button == "LeftButton" then
		lib.SetScanning(not private.IsScanning)
	elseif button == "RightButton" then
		if self.hasRight then
			AucSearchUI.Toggle()
		end
	end
end
local function OnEnter(self)
	local text
	if private.IsScanning then
		text = "Click to stop RealTime Search"
	else
		text = "Click to start RealTime Search"
	end
	if self.hasRight then
		text = text .. "\nRight-Click to open SearchUI"
	end
	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	GameTooltip:SetText(text)
end
local function OnLeave(self)
	GameTooltip:Hide()
end
local function SetState(self)
	if private.IsScanning then
		self.tex:SetTexCoord(0.5, 1, 0, 1)
		if not self.isSpiking and get("realtime.reload.enable") then
			self.pulse:Play()
		else
			self.pulse:Stop()
		end
	else
		self.tex:SetTexCoord(0, .5, 0, 1)
		self.pulse:Stop()
		self.spike:Stop()
	end
end
local function OnSpikeFinished(self)
	-- pulse is temporarily disabled while spiking; restart pulse animation when spike ends
	self.button.isSpiking = nil
	self.button:SetState()
end

--[[
	lib.CreateRTSButton(parent, norightclick)
	Create a new RTS scan toggle button to add to a GUI
	Caller will need to anchor it using SetPoint
	parent (frame) - parent to use when creating the new button
	norightclick (boolean) - if true, disables right-clicking the button to open the SearchUI panel
	Note: active RTS scanning can only occur if one of these buttons is visible
--]]
function lib.CreateRTSButton(parent, norightclick)
	local right = not norightclick -- invert and force type to boolean

	local button = CreateFrame("Button", nil, parent, "OptionsButtonTemplate")
	button:SetWidth(22)
	button:SetHeight(18)
	if right then
		button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	else
		button:RegisterForClicks("LeftButtonUp")
	end
	button.hasRight = right
	button:SetScript("OnClick", OnClick)
	button:SetScript("OnEnter", OnEnter)
	button:SetScript("OnLeave", OnLeave)
	button:SetScript("OnUpdate", private.OnUpdate)
	button.tex = button:CreateTexture(nil, "OVERLAY")
	button.tex:SetPoint("TOPLEFT", button, "TOPLEFT", 4, -2)
	button.tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 2)
	button.tex:SetTexture(embedpath.."Auc-Util-SearchUI\\Textures\\SearchButton")
	button.tex:SetVertexColor(1, 0.9, 0.1)

	-- continuous animation to indicate that RTS is active
	local pulse = button.tex:CreateAnimationGroup()
	pulse:SetLooping("REPEAT")
	local pulse1 = pulse:CreateAnimation("Alpha")
	pulse1:SetStartDelay(1)
	pulse1:SetFromAlpha(1)
	pulse1:SetToAlpha(.2)
	pulse1:SetDuration(.5)
	pulse1:SetOrder(1)
	local pulse2 = pulse:CreateAnimation("Alpha")
	pulse2:SetFromAlpha(.2)
	pulse2:SetToAlpha(1)
	pulse2:SetDuration(.5)
	pulse2:SetOrder(2)
	button.pulse = pulse

	-- single animation to indicate that RTS has refreshed the page
	local spike = button.tex:CreateAnimationGroup()
	local spike1 = spike:CreateAnimation("Scale")
	spike1:SetOrigin("CENTER", 0, 0)
	spike1:SetScale(.1, .1)
	spike1:SetDuration(.1)
	spike1:SetOrder(1)
	local spike2 = spike:CreateAnimation("Scale")
	spike2:SetOrigin("CENTER", 0, 0)
	spike2:SetScale(10, 10)
	spike2:SetDuration(1.5)
	spike2:SetSmoothing("OUT") -- animation will be initially fast, then slowing
	spike2:SetOrder(2)
	spike.button = button -- save so we don't have to drill up through GetParent()'s
	spike:SetScript("OnFinished", OnSpikeFinished)
	button.spike = spike

	button.SetState = SetState
	button:SetState()

	tinsert(private.buttontable, button)

	return button
end

--[[
	lib.SignalRTSButton()
	Cause the RTS button to display a one-off animation, to indicate that the scan page has changed
	Only applies to the current visible button
--]]
function lib.SignalRTSButton()
	for _, button in ipairs(private.buttontable) do
		if button:IsVisible() then
			-- internally this is called a Spike
			button.isSpiking = true
			button.pulse:Stop() -- don't pulse while spiking
			button.spike:Stop() -- reset if it's already playing
			button.spike:Play()
			return
		end
	end
end

--[[
	lib.HookAH()
	Called from SearchMain when the AH opens for the first time
	function: to create the control button on the AH, to the right of the regular ScanButtons
]]
function lib.HookAH()
	if private.HookAH then private.HookAH() end
end
function private.HookAH()
	private.HookAH = nil -- prevent calling more than once
	local BrowseRTSButton = lib.CreateRTSButton(AuctionFrameBrowse)
	BrowseRTSButton:SetPoint("TOPRIGHT", AuctionFrameBrowse, "TOPLEFT", 310, -15)
end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-SearchUI/SearchRealTime.lua $", "$Rev: 6415 $")
