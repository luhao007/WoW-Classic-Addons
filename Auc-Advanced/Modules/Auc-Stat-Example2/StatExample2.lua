--[[ DELETE v DELETE v DELETE v DELETE v DELETE v DELETE v DELETE v DELETE --

	NOTE:
	This is an example addon. Use the below code to start your own
	module should you wish.

	This top section should be deleted from any derivative code
	before you distribute it.

]]

if true then
	 --Comment out this return to see the example module running.
	 return
end

--^ DELETE ^ DELETE ^ DELETE ^ DELETE ^ DELETE ^ DELETE ^ DELETE ^ DELETE ^--

--[[
	Auctioneer - Stat's API Example module
	Version: <%version%> (<%codename%>)
	Revision: $Id$
	URL: http://auctioneeraddon.com/

	This is an Auctioneer module that does something nifty.

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have recenived a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]

-- Make sure Auctioneer is loaded.  Especially important if used as an embedded module
-- in a non-auctioneer addon that doesn't require auctioneer (auctioneer is an optional dependency)
if not AucAdvanced then return end

--[[
Convention Used to identify the addon to Auctioneer is a libType and a name.
The name must be unique (case insensitive).
Valid libType's are:
	Filter	-- Allows removal of auctions from consideration by Stats modules for statistical use.
	Stat	-- Gathers and reports statistics about items.  The heart of Auctioneer.
	Util	-- This is a catch-all.  A module that doesn't do the additional items of the others.
	Match	-- Module is used by Auctioneer to control pricing (set to some value).
--]]
local libName = "Example2" -- note: Auc-Util-Example has already taken the name "Example"!
local libType = "Stat"

local lib,parent,private = AucAdvanced.NewModule(libType, libName)
-- One case where this will happen is if the libName has already been registered.
if not lib then return end

local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill,_TRANS = AucAdvanced.GetModuleLocals()

--[[
The following functions are part of the module's exposed methods:
	GetName()         (created by NewModule) Returns libName. Should never be overridden
	GetLocalName()    (optional) Returns a localized name (NewModule creates a default version, which may be overridden)
	CommandHandler()  (optional) Slash command handler for this module
	Processors ={}    (optional) Table containing functions to process messages sent by Auctioneer
	ScanProcessors={} (optional) Table containing functions to process items during a scan
	GetPrice()        (optional) Returns estimated price for item link
	GetPriceColumns() (optional) Returns the column names for GetPrice
	OnLoad()          (optional) Receives load message for self, and for any modules specified by LoadTriggers table
	OnUnload()        (optional) Called during logout, just before data gets saved

	GetPriceArray()   (*) Returns pricing and other statistical info in an array
	GetItemPDF()      (**) Returns Probability Density Function for item link (see below)
	AuctionFilter()   (##) Perform filtering on an auction entry
	GetMatchArray()   ($$) Perform price matching on an item link

	* Required for Stat modules, optional for other module types
	** Required for Stat modules, not used by other module types
	## Required for Filter modules, not used by other module types
	$$ Required for Match modules, not used by other module types

]]

lib.Processors = {}
lib.Processors.listupdate = function(callbackType) end
lib.Processors.blockupdate = function(callbackType, blocked) end
lib.Processors.buyqueue = function(callbackType, itemsInQueue) end
-- Note, this returns a string of "<link>;<price>;<count>'
--  it probably should be modified to in the future return callbackType, link, price, count
lib.Processors.bidcancelled = function(callbackType, cancelInfo) end
-- Note, this returns a string of "<link>;<seller>;<count>;<price>;<reason>'
--  it probably should be modified to in the future return callbackType, link, seller, count, price, reason
lib.Processors.bidplaced = function(callbackType, bidInfo) end
-- Deprecated tooltip message, still supported for legacy modules
lib.Processors.tooltip = function(callbackType, tooltip, name, hyperlink, quality, quantity, cost, extra) end
-- Separate item and battlepet tooltip messages, with serverKey support
lib.Processors.itemtooltip = function(callbackType, tooltip, hyperlink, serverKey, quantity, decoded, additional, order) end
lib.Processors.battlepettooltip = function(callbackType, tooltip, hyperlink, serverKey, quantity, decoded, additional, order) end
-- Blizzard_AuctionUI has loaded. Use to hook into Blizzard auction code (e.g. AuctionFrame, etc.)
lib.Processors.auctionui = function(callbackType) end
-- An auctioneer addon has been loaded.
lib.Processors.load = function(callbackType, addon) end
-- Auction UI Opened
lib.Processors.auctionopen = function(callbackType) end
-- Auction UI Closed
lib.Processors.auctionclose = function(callbackType) end
-- A module has been registered with NewModule. Use to flush caches. Note: the module will not yet be fully loaded
lib.Processors.newmodule = function(callbackType, libType, libName) end
-- Indicate post queue lenght has changed
lib.Processors.postqueue = function(callbackType, queuelength) end
-- Indicate results of a post attempt
lib.Processors.postresult = function(callbackType, successful, id, request, reason) end
--[[
ToDo: Document these.
These a bit messy.  More docs needed here.
]]
lib.Processors.scanprogress = function(callbackType, state, totalAuctions, scannedAuctions, elapsedTime, page, maxPages, query, scanCount) end
lib.Processors.scanstats = function(callbackType, stats) end
lib.Processors.scanfinish = function(callbackType, scanSizre, querySig, qryInfo, inComplete, curQuery, scanStats) end
-- A query was sent.  via QueryAuctionItems.  Not the ... are the standard return items form QueryAuctionItems.
lib.Processors.querysent = function(callbackType, query, isSearch, ...) end
-- Page Store for page has completed.
lib.Processors.pagefinished = function(callbackType, pageNum) end
lib.Processors.scanstart = function(callbackType, scanSize, querySig, qryInfo) end
-- A config setting has changed. For convenience, the 3 parts from splitting fullsetting are also provided (fullsetting = settingbase.settingmodule.settingname)
lib.Processors.configchanged = function(callbackType, fullsetting, value, settingname, settingmodule, settingbase) end
-- Request for config screen gui elements.  gui references the config screen GUI.
lib.Processors.config = function(callbackType, gui) end
lib.Processors.searchbegin = function(callbackType, searcherName) end
lib.Processors.searchcomplete = function(callbackType, searcherName) end

-- ToDo: figure out what events there are, and document them.



function lib.ProcessTooltip(frame, name, hyperlink, quality, quantity, cost, additional)
	-- In this function, you are afforded the opportunity to add data to the tooltip should you so
	-- desire. You are passed a hyperlink, and it's up to you to determine whether or what you should
	-- display in the tooltip.
end

function lib.OnLoad()
	--This function is called when your variables have been loaded.
	--Localizations are now available
	--You should also set your Configator defaults here

	-- note: this sort of announcement can get annoying, so should usually be avoided
	aucPrint("AucAdvanced: {{"..libType..":"..libName.."}} loaded!")

	-- setting strings should be of the form "libType.libName.settingName"
	-- they should contain exactly 2 '.' characters
	AucAdvanced.Settings.SetDefault("stat.example2.active", true)
	AucAdvanced.Settings.SetDefault("stat.example2.slider", 50)
	AucAdvanced.Settings.SetDefault("stat.example2.wideslider", 100)
	AucAdvanced.Settings.SetDefault("stat.example2.hardselectbox", 5)
	AucAdvanced.Settings.SetDefault("stat.example2.dynamicselectbox", 5)
	AucAdvanced.Settings.SetDefault("stat.example2.label", "Label")
	AucAdvanced.Settings.SetDefault("stat.example2.text", "")
	AucAdvanced.Settings.SetDefault("stat.example2.numberbox", "5")
	AucAdvanced.Settings.SetDefault("stat.example2.moneyframe", "50000000")
	AucAdvanced.Settings.SetDefault("stat.example2.moneyframepinned", "010101")
end

-- Example of making a Probability Density Function from mean and stddev
local bellCurve = AucAdvanced.API.GenerateBellCurve();
function lib.GetItemPDF(hyperlink, serverKey)
	local mean, seen, stddev = private.GetInfo(hyperlink, serverKey)
	-- you should check that mean and stddev are valid here, before continuing
	local lower, upper = mean - 3*stddev, mean + 3*stddev
	bellCurve:SetParameters(mean, stddev)
	return bellCurve, lower, upper;
end

local array = {}
function lib.GetPriceArray(hyperlink, serverKey)
	local mean, seen, stddev = private.GetInfo(hyperlink, serverKey)
	wipe(array)
	-- expected entries
	array.price = mean
	array.seen = seen
end

--[[ Local functions ]]--

function private.GetInfo(hyperlink, serverKey)
	local mean, seen, stddev
	-- do your processing here
	return mean, seen, stddev
end

function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	-- Localizations will be available using _TRANS
	local id = gui:AddTab(libName)
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",     0,    libName.." options")
	gui:AddControl(id, "Checkbox",   0, 1, "stat.example2.active", "This is a checkbox, it has two settings true (selected) and false (cleared)")

	gui:AddControl(id, "Subhead",    0,    "There are two kinds of sliders:")
	gui:AddControl(id, "Slider",     0, 1, "stat.example2.slider", 0, 100, 1, "Normal Sliders: %d%%")
	gui:AddControl(id, "WideSlider", 0, 1, "stat.example2.wideslider",    0, 200, 1, "And Wide Sliders: %d%%")

	gui:AddControl(id, "Subhead",    0,    "There are also two ways to build a selection box:")
	gui:AddControl(id, "Selectbox",  0, 1, {
		{0, "Zero"},
		{1, "One"},
		{2, "Two"},
		{3, "Three"},
		{4, "Four"},
		{5, "Five"},
		{6, "Six"},
		{7, "Seven"},
		{8, "Eight"},
		{9, "Nine"}
	}, "stat.example2.hardselectbox")
	gui:AddControl(id, "Selectbox",  0, 1, private.GetNumbers, "stat.example2.dynamicselectbox")

	gui:AddControl(id, "Subhead",    0,    "There are also a few ways to add text:\n  The Headers and SubHeaders that you've already seen...")
	gui:AddControl(id, "Note",       0, 1, nil, nil, "Notes...")
	gui:AddControl(id, "Label",      0, 1, "stat.example2.label", "And Labels")

	gui:AddControl(id, "Subhead",    0,    "There are two ways to get input via keyboard:")
	gui:AddControl(id, "Text",       0, 1, "stat.example2.text", "Via the Text Control...")
	gui:AddControl(id, "NumberBox",  0, 1, "stat.example2.numberbox", 0, 9, "Or using the NumberBox if you only need numbers.")

	gui:AddControl(id, "Subhead",          0,    "There are two kinds of Money Frames:")
	gui:AddControl(id, "MoneyFrame",       0, 1, "stat.example2.moneyframe", "MoneyFrames...")
	gui:AddControl(id, "MoneyFramePinned", 0, 1, "stat.example2.moneyframepinned", 0, 101010, "And PinnedMoneyFrames.")

	gui:AddControl(id, "Subhead",    0,    "And finally...")
	gui:AddControl(id, "Button",     0, 1, "stat.example2.button", "The Button!")
end

function private.GetNumbers()
	return { {0, "Zero"}, {1, "One"}, {2, "Two"}, {3, "Three"}, {4, "Four"}, {5, "Five"}, {6, "Six"}, {7, "Seven"}, {8, "Eight"}, {9, "Nine"} }
end

function private.Foo()
end

function private.Bar()
end

function private.Baz()
end

AucAdvanced.RegisterRevision("$URL$", "$Rev$")
