--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: 8.2.6422 (SwimmingSeadragon)
	Revision: $Id: BeanCounterConfig.lua 6422 2019-09-13 05:07:31Z none $
	URL: http://auctioneeraddon.com/

	BeanCounterConfig - Controls Configuration data

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
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
LibStub("LibRevision"):Set("$URL: BeanCounter/BeanCounterConfig.lua $","$Rev: 6422 $","5.1.DEV.", 'auctioneer', 'libs')

--Most of this code is from enchantrix by ccox
local lib = BeanCounter
local private, print, get, set, _BC = lib.getLocals()
local gui, settings, _
local date, format = date, format

local function debugPrint(...)
    if get("util.beancounter.debugConfig") then
        private.debugPrint("BeanCounterConfig",...)
    end
end


-- Default setting values
local Buyer, Seller = string.match(_BC('UiBuyerSellerHeader'), "(.*)/(.*)") --We have no direct translation so this is a temp workaround
private.settingDefaults = {
	["util.beancounter.ButtonExactCheck"] = false,
	["util.beancounter.ButtonClassicCheck"] = false,
	["util.beancounter.ButtonBidCheck"] = true,
	["util.beancounter.ButtonBidFailedCheck"] = true,
	["util.beancounter.ButtonAuctionCheck"] = true,
	["util.beancounter.ButtonAuctionFailedCheck"] = true,

	["util.beancounter.activated"] = true,
	["util.beancounter.integrityCheckComplete"] = false,
	["util.beancounter.integrityCheck"] = true,

	--Tootip Settings
	["util.beancounter.displayReasonCodeTooltip"] = true,
	["util.beancounter.displaybeginerTooltips"] = true,

	--Debug settings
	["util.beancounter.debug"] = false,
	["util.beancounter.debugMail"] = true,
	["util.beancounter.debugCore"] = true,
	["util.beancounter.debugConfig"] = true,
	["util.beancounter.debugVendor"] = true,
	["util.beancounter.debugBid"] = true,
	["util.beancounter.debugPost"] = true,
	["util.beancounter.debugUpdate"] = true,
	["util.beancounter.debugFrames"] = true,
	["util.beancounter.debugAPI"] = true,
	["util.beancounter.debugSearch"] = true,
	["util.beancounter.debugTidyUp"] = true,

	["util.beacounter.invoicetime"] = 5,
	["util.beancounter.mailrecolor"] = "off",
	["util.beancounter.externalSearch"] = true,

	["util.beancounter.hasUnreadMail"] = false,

	--["util.beancounter.dateFormat"] = "%c",
	["dateString"] = "%c",

	--Data storage
	["monthstokeepdata"] = 48,

	--Color gradient
	["colorizeSearch"] = true,
	["colorizeSearchopacity"] = 0.2,

	--Search settings
	["numberofdisplayedsearchs"] = 500,

	--GUI column default widths
	["columnwidth.".._BC('UiNameHeader')] = 120,
	["columnwidth.".._BC('UiTransactions')] = 100,
	["columnwidth.".._BC('UiBidTransaction')] = 60,
	["columnwidth.".._BC('UiBuyTransaction')] = 60,
	["columnwidth.".._BC('UiNetHeader')] = 60,
	["columnwidth.".._BC('UiQuantityHeader')] = 40,

	["columnwidth.".."|CFFFFFF00"..Seller.."/|CFF4CE5CC"..Buyer] = 100,

	["columnwidth.".._BC('UiDepositTransaction')] = 60,
	["columnwidth.".._BC('UiPriceper')] = 60,
	["columnwidth.".._BC("UiFee")] = 60,
	["columnwidth.".._BC('UiReason')] = 90,
	["columnwidth.".._BC('UiDateHeader')] = 140,

	["columnwidth.".._BC('UiProfit')] = 60,
	["ModTTShow"] = false,
    }

local function getDefault(setting)
	-- lookup the simple settings
	local result = private.settingDefaults[setting];
	return result
end

function lib.GetDefault(setting)
	local val = getDefault(setting);
	return val
end


function private.DateStringUpdate(value)
	if not value then value = "%c" end
	local tbl = {}
	for w in string.gmatch(value, "%%(.)" ) do --look for the date commands prefaced by %
		tinsert(tbl, w)
	end

	local valid, invalid = {['a']= 1,['A'] =1,['b'] =1,['B'] =1,['c']=1,['d']=1,['H']=1,['I']=1,['m']=1,['M']=1,['p']=1,['S']=1,['U']=1,['w']=1,['x']=1,['X']=1,['y']=1,['Y']=1} --valid date commands

	for i,v in pairs(tbl) do
		if not valid[v] then  invalid = v break end
	end
	--Prevent processing if we have an invalid command
	if invalid then
		print("Invalid Date Format", "%"..invalid)
		value = "%c"
		gui.elements.dateString:SetText(value)
	end
	gui.elements.dateStringdisplay.textEl:SetText(_BC('C_DateStringExample').." "..date(value, time()))

	return value
end


local function setter(setting, value, server, player)
	if not setting then debugPrint("No setting passed DEBUG STRING REMOVE", setting, value, server, player) return end
	if type(setting) ~= "string" then debugPrint( setting, value, type(setting) ) return end

	local DB = BeanCounterDBSettings
	-- turn value into a canonical true or false
	if value == 'on' then
		value = true
	elseif value == 'off' then
		value = false
	end

	-- Settings that require special handling
	if (setting ==  "monthstokeepdata") then
		local text = format("Enable purging transactions older than %s months from the database. \nYou must hold the SHIFT key to check this box since this will DELETE data.", gui.elements.monthstokeepdata:GetValue()/100 or 48)
		gui.elements.oldDataExpireEnabled.textEl:SetText(text)

		--Always uncheck and set value to off when they change the slider value as a safety precaution
		DB["oldDataExpireEnabled"] = false
		gui.elements.oldDataExpireEnabled:SetChecked(false)
	elseif (setting ==  "oldDataExpireEnabled") and value then
		if not IsShiftKeyDown() then --We wont allow the user to check this box unless shift key is down
			print("You will need to hold down the SHIFT key to check this box")
			lib.SetSetting("oldDataExpireEnabled", false)
			return
		end
	elseif (setting == "dateString") then --used to update the Config GUI when a user enters a new date string
		value = private.DateStringUpdate(value)
	end

	-- For default values 'store' a value of nil, to delete any non-default value previously held in this setting
	if value == 'default' or value == getDefault(setting) then
		value = nil
	end

	-- Set the value for this setting
	if server and player then
		if not DB[server] then DB[server] = {} end
		if not DB[server][player] then DB[server][player] = {} end

		DB[server][player][setting] = value
		return
	end
	--general setting not player specific
	DB[setting] = value
end

function lib.SetSetting(...)
	setter(...)
	if (gui) then-- Refresh all values to reflect current data
		gui:Refresh()
	end
end

local function getter(setting, server, player)
	if not setting then return end
	local DB = BeanCounterDBSettings


	if server and player then
		if DB[server] and DB[server][player] then
			return DB[server][player][setting]
		end
	end
	--non server specific settings
	if ( DB[setting] ~= nil ) then
		return DB[setting]
	else
		return getDefault(setting)
	end
end

function lib.GetSetting(setting, server, player)
	local option = getter(setting, server, player)
	return option
end
--set as local at top of file
_, _, get, set, _ = lib.getLocals()--now we can set our get, set locals to the above functions
private.setter = setter
private.getter = getter
function lib.MakeGuiConfig()
	if gui then return end

	local id
	local Configator = LibStub:GetLibrary("Configator")
	gui = Configator:Create(setter, getter)

	lib.Gui = gui

  	gui:AddCat("BeanCounter")

	id = gui:AddTab(_BC('C_BeanCounterConfig')) --"BeanCounter Config")
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",     0,    _BC('C_BeanCounterOptions')) --"BeanCounter options")
	gui:AddControl(id, "Checkbox", 0 , 1, "ModTTShow", _BC('C_ModTTShow'))--Only show extra tooltip if Alt is pressed.
	gui:AddTip(id, _BC('TTModTTShow'))--This option will display BeanCounter's extra tooltip only if Alt is pressed.
	gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.displaybeginerTooltips", _BC('C_ShowBeginnerTooltips'))--"Show beginner tooltips on mouse over"
	gui:AddTip(id, _BC('TTShowBeginnerTooltips')) --Turns on the beginner tooltips that display on mouse eover

	gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.displayReasonCodeTooltip", _BC('C_ShowReasonPurchase'))--Show reason for purchase in the games Tooltips
	gui:AddTip(id, _BC('TTShowReasonPurchase'))--Turns on the SearchUI reason an item was purchased for in the tooltip

	gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.externalSearch", _BC('C_ExtenalSearch')) --"Allow External Addons to use BeanCounter's Search?")
	gui:AddTip(id, _BC('TTExtenalSearch')) --"When entering a search in another addon, BeanCounter will also display a search for that item.")

	gui:AddControl(id, "Checkbox",   0, 1, "sendSearchBrowseFrame", _BC('C_SendToSearch')) --Add BeanCounter's searched item to the Main Auction House Window?
	gui:AddTip(id, _BC('TT_sendtosearch')) --"When entering a search in BeanCounter it will also add the string to the AH browse frame.

	gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
	gui:AddControl(id, "WideSlider", 0, 1, "util.beacounter.invoicetime",    1, 20, 1, _BC('C_MailInvoiceTimeout')) --"Mail Invoice Timeout = %d seconds")
	gui:AddTip(id, _BC('TTMailInvoiceTimeout')) --Chooses how long BeanCounter will attempt to get a mail invoice from the server before giving up. Lower == quicker but more chance of missing data, Higher == slower but improves chances of getting data if the Mail server is extremely busy.

	gui:AddControl(id, "Subhead",    0,    _BC('C_MailRecolor')) --"Mail Re-Color Method")
	gui:AddControl(id, "Selectbox",  0, 1, {{"off",_BC("NoRe-Color")},{"icon",_BC("Re-ColorIcons")},{"both",_BC("Re-ColorIconsandText")},{"text",_BC("Re-ColorText")}}, "util.beancounter.mailrecolor")
	gui:AddTip(id, _BC('TTMailRecolor')) --"Choose how Mail will appear after BeanCounter has scanned the Mail Box")

	gui:AddControl(id, "Text",       0, 1, "dateString", "|CCFFFCC00".._BC('C_DateString')) --"|CCFFFCC00Date format to use:")
	gui:AddTip(id, _BC('TTDateString'))--"Enter the format that you would like your date field to show. Default is %c")
	gui:AddControl(id, "Checkbox",   0, 1, "dateStringdisplay", "|CCFFFCC00".._BC('C_DateStringExample').." 11/28/07 21:34:21") --"|CCFFFCC00Example Date: 11/28/07 21:34:21")
	gui:AddTip(id, _BC('TTDateStringExample'))--"Displays an example of what your formated date will look like")

	gui:AddControl(id, "Note", 0, 1, nil, nil, " ")
	gui:AddControl(id, "Checkbox",   0, 1, "colorizeSearch", _BC('C_ColorizeSearch'))--Add a gradient color to each result in the search window
	gui:AddTip(id, _BC('TT_ColorizeSearch'))--This option changes the color of the items lines in the BeanCounter search window.

	gui:AddControl(id, "NumeriSlider", 0, 3, "colorizeSearchopacity",    0, 1, 0.1,  _BC('C_OpacityLevel')) --Opacity level
	gui:AddTip(id,  _BC('TT_OpacityLevel')) --This controls the level of opacity for the colored bars in the BeanCounter search window (if enabled)


	gui:AddControl(id, "Subhead",     0,    _BC('C_SearchConfiguration')) --Search Configuration

	gui:AddControl(id, "NumeriSlider", 0, 1, "numberofdisplayedsearchs",    500, 5000, 250,  _BC('C_MaxDisplayedResults')) --Max displayed search results (from each database)
	gui:AddTip(id, _BC('TT_MaxDisplayedResults')) --This controls the total number of results displayed in the scroll frame.

	gui:AddHelp(id, "what is invoice",
		_BC('Q_MailInvoiceTimeout'), --"What is Mail Invoice Timeout?",
		_BC('A_MailInvoiceTimeout') --"The length of time BeanCounter will wait on the server to respond to an invoice request. A invoice is the who, what, how of an Auction house mail"
		)
	gui:AddHelp(id, "what is recolor",
		_BC('Q_MailRecolor'), --"What is Mail Re-Color Method?",
		_BC('A_MailRecolor') --"BeanCounter reads all mail from the Auction House, This option tells Beancounter how the user want's to Recolor the messages to make them look unread."
		)
	gui:AddHelp(id, "what is tooltip",
		_BC('Q_BeanCountersTooltip'),--What is BeanCounters Tooltip
		_BC('A_BeanCountersTooltip')--BeanCounter will store the SearchUI reason an item was purchased and display it in the tooltip
		)
	gui:AddHelp(id, "what is external",
		_BC('Q_ExtenalSearch'), --"Allow External Addons to use BeanCounter?",
		_BC('A_ExtenalSearch') --"Other addons can have BeanCounter search for an item to be displayed in BeanCounter's GUI. For example this allows BeanCounter to show what items you are looking at in Appraiser"
		)
	gui:AddHelp(id, "what is date",
		_BC('Q_DateString'), --"Date Format to use?",
		_BC('A_DateString') --"This controls how the Date field of BeanCounter's GUI is shown. Commands are prefaced by % and multiple commands and text can be mixed. For example %a == %X would display Wed == 21:34:21"
		)
	gui:AddHelp(id, "what is date command",
		_BC('Q_DateStringCommands'), --"Acceptable Date Commands?",
		_BC('A_DateStringCommands') --"Commands: \n %a = abr. weekday name, \n %A = weekday name, \n %b = abr. month name, \n %B = month name,\n %c = date and time, \n %d = day of the month (01-31),\n %H = hour (24), \n %I = hour (12),\n %M = minute, \n %m = month,\n %p = am/pm, \n %S = second,\n %U = week number of the year ,\n %w = numerical weekday (0-6),\n %x = date, \n %X = time,\n %Y = full year (2007), \n %y = two-digit year (07)"
		)

	id = gui:AddTab(_BC('C_DataMaintenance')) --"Data Maintenance"
	lib.Id = id
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",     0,    _BC('C_BeanCounterDatabaseMaintenance')) --"BeanCounter Database Maintenance"


--~ 	local sort, prune, compact = get("sortArray", private.serverName, private.playerName) or 0 , get("prunePostedDB", private.serverName, private.playerName) or 0, get("compactDB", private.serverName, private.playerName) or 0
--~ 	local a = "The next database sort for %s is scheduled to occur in %s day(s)"
--~ 	local b = "The pruning of the posted database for %s is scheduled to occur in %s day(s)"
--~ 	local c = "The compacting and purging for %s is scheduled to occur in %s day(s)"
--~ 	gui:AddControl(id, "Subhead",    0,   a:format(private.playerName, floor( (sort - time() )/86400)))
--~ 	gui:AddControl(id, "Subhead",    0,   b:format(private.playerName, floor( (prune - time() )/86400)))
--~ 	gui:AddControl(id, "Subhead",    0,   c:format(private.playerName, floor( (compact - time() )/86400)))


	gui:AddControl(id, "Subhead",    0,    _BC('C_ScanDatabase')) --"Scan Database for errors: Use if you have errors when searching BeanCounter. \n Backup BeanCounter's saved variables before using."
	--makes button call a function rather than a SV
	local valButton = gui:AddControl(id, "Button",     0, 1, function(...)end, _BC('C_ValidateDatabase'))
	valButton:SetScript("OnClick", function() private.integrityCheck(true) end)

	gui:AddTip(id, _BC('TTValidateDatabase')) --"This will scan Beancounter's Data and attempt to correct any error it may find. Use if you are getting errors on search"

	gui:AddControl(id, "Subhead",    0,    _BC('C_DatabaseLength')) --"Determines how long BeanCounter will save Auction House Transactions."
	gui:AddControl(id, "Checkbox",   0, 1, "oldDataExpireEnabled", format("Enable purging transactions older than %s months from the database. \nYou must hold the SHIFT key to check this box since this will DELETE data.", get("monthstokeepdata") or 48) )--Enable purging transactions older than %s months from the database. This will DELETE data.
	gui:AddTip(id, _BC('TTDataExpireEnabled'))--Data older than the selected time range will be DELETED
	gui:AddControl(id, "NumeriSlider", 0, 3, "monthstokeepdata",    1, 48 , 1, "How many months of data to keep?")

	id = gui:AddTab("BeanCounter Debug")
	gui:AddControl(id, "Header",     0,    "BeanCounter Debug")
	gui:AddControl(id, "Checkbox",   0, 1, "util.beancounter.debug", "Turn on BeanCounter Debugging text. Dont check unless asked to do so")

	gui:AddControl(id, "Subhead",    0,    "Reports From Specific Modules")

	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugMail", "Mail")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugCore", "Core")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugConfig", "Config")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugVendor", "Vendor")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugBid", "Bid")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugPost", "Post")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugUpdate", "Update")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugFrames", "Frames")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugAPI", "API")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugSearch", "Search")
	gui:AddControl(id, "Checkbox",   0, 2, "util.beancounter.debugTidyUp", "TidyUp")

end
