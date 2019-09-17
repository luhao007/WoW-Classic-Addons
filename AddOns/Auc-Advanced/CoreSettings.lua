--[[
	Auctioneer
	Version: 8.2.6420 (SwimmingSeadragon)
	Revision: $Id: CoreSettings.lua 6420 2019-09-13 05:07:31Z none $
	URL: http://auctioneeraddon.com/

	Settings GUI

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


data layout:
		AucAdvancedConfig = {

			["profile.test4"] = {
				["miniicon.distance"] = 56,
				["miniicon.angle"] = 189,
				["show"] = true,
				["enable"] = true,
				["util"] = {
					["scanprogress"] = {
						["activated"] = false,
						["leaveshown"] = false,
					},
					["protectwindow"] = {
						["protectwindow"] = 2,
					},
					["pricelevel"] = {
						["colorize"] = true,
					},
				},

					["profiles"] = {
						"Default", -- [1]
				"test4", -- [2]
			},

			["users.Foobar.Picksell"] = "test4",

			["profile.Default"] = {
				["miniicon.angle"] = 187,
				["miniicon.distance"] = 15,
			},

		}

if user does not have a set profile name, they get the default profile.
All modules should use this format for stored KEYS         ModuleType.ModuleName.setting   = value    for example     util.automagic.showmailgui = true


Usage:
	def = AucAdvanced.Settings.GetDefault('util.example.showgui')
	val = AucAdvanced.Settings.GetSetting(util.example.showgui')
	AucAdvanced.Settings.SetSetting('util.example.showgui', true );

]]
if not AucAdvanced then return end
AucAdvanced.CoreFileCheckIn("CoreSettings")
local coremodule, internalLib, private, internal = AucAdvanced.GetCoreModule("CoreSettings", "Settings", true, nil, "CoreSettings")
if not coremodule or not internal then return end -- Someone has explicitely broken us

local lib = AucAdvanced.Settings
local gui
local Const = AucAdvanced.Const
local Libraries = AucAdvanced.Libraries
local UserSig = format("users.%s.%s", Const.PlayerRealm, Const.PlayerName)

local aucPrint,decode,_,_,replicate,empty,_,_,_,debugPrint,fill, _TRANS = AucAdvanced.GetModuleLocals()

local strsplit = strsplit
local next = next
local type = type

function coremodule.OnLoad(addon)
	if not AucAdvancedConfig then AucAdvancedConfig = {} end
	if addon == "auc-advanced" then
		private.CheckObsolete()
	end
end

coremodule.Processors = {
	gameactive = function() private.Activate() end,
}

local function getUserProfileName()
	return AucAdvancedConfig[UserSig] or "Default"
end

local function getUserProfile()
	local data = AucAdvancedConfig["profile."..getUserProfileName()]
	if not data then
		AucAdvancedConfig[UserSig] = "Default"
		data = AucAdvancedConfig["profile.Default"]
		if not data then
			data = {}
			AucAdvancedConfig["profile.Default"] = data
		end
	end
	return data
end

-- Default setting values
local settingDefaults = {
	['all'] = true,
	['locale'] = 'default',
	['scandata.tooltip.display'] = false,
	['scandata.tooltip.modifier'] = true,
	["tooltip.marketprice.show"] = true,
	["tooltip.marketprice.stacksize"] = true,
	['scandata.force'] = false,
	["core.scan.disable_scandatawarning"] = false,
	['scandata.summaryonfull'] = true,
	['scandata.summaryonmicro'] = false,
	['scandata.summaryonpartial'] = true,
	['clickhook.enable'] = true,
	['scancommit.targetFPS'] = 25,
	['scancommit.progressbar'] = true,
	['scancommit.ttl'] = 5,
	['printwindow'] = 1,
	["core.marketvalue.tolerance"] = .08,
	["ShowPurchaseDebug"] = true,
	["SelectedLocale"] = GetLocale(),
	["ModTTShow"] = "always",
	["post.clearonclose"] = true,
	["post.confirmonclose"] = true,
	["core.scan.sellernamedelay"] = false,
	["core.scan.unresolvedtolerance"] = 0,
	["core.scan.scanallqueries"] = true,
	["core.scan.fillduringscan"] = false,
	["core.scan.scannerthrottle"] = Const.ALEVEL_MIN,
	["core.scan.stage1throttle"] = Const.ALEVEL_OFF,
	["core.scan.stage3garbage"] = Const.ALEVEL_OFF,
	["core.scan.stage5garbage"] = false,
	--["core.scan.keepinfocacheonclose"] = true, -- ### setting temporarily disabled
	["core.tooltip.altchatlink_leftclick"] = false,
	["core.tooltip.enableincombat"] = false,
	["core.tooltip.depositcost"] = true,
	["core.tooltip.depositduration"] = 48,
}

if AucAdvanced.Classic then
    settingDefaults["core.tooltip.depositduration"] = 24
end

local function getDefault(setting)
	-- If setting is a function reference, call it.
	-- This was added to enable Protect Window to update its
	-- status without a UI reload by calling a function rather
	-- than a setting in the Control definition.
	if (type(setting) == "function") then
		return setting("getdefault")
	end

	-- lookup the simple settings
	return settingDefaults[setting]
end

function lib.GetDefault(setting)
	return getDefault(setting)
end

function lib.SetDefault(setting, default)
	settingDefaults[setting] = default
end

local function setter(setting, value, silent)
	-- turn value into a canonical true or false
	if value == 'on' then
		value = true
	elseif value == 'off' then
		value = false
	end

	-- is the setting actually a function ref? if so call it.
	-- This was added to enable Protect Window to update its
	-- status without a UI reload by calling a function rather
	-- than a setting in the Control definition.
	-- setting function is responsible for issuing any appropriate "configchanged" processor message
	if type(setting)=="function" then
		return setting("set", value)
	end

	--Store the value before we nil it to be used in callback
	local callbackValue = value
	-- for defaults, just remove the value and it'll fall through
	if (value == 'default') or (value == getDefault(setting)) then
		-- Don't save default values
		value = nil
	end

	local a, b, c = strsplit(".", setting, 3)
	if (a == "profile") then
		if setting == "profile.save" or setting == "profile.duplicate" then
			-- User clicked either the New Profile or Copy Profile button
			value = gui.elements["profile.name"]:GetText()

			if value and value ~= "" then
				-- Create the new profile
				local newProfile
				if setting == "profile.duplicate" then
					local curName = gui.elements["profile"].value
					local curProfile = AucAdvancedConfig["profile."..curName]
					if curProfile then
						newProfile = replicate(curProfile)
					end
				end
				AucAdvancedConfig["profile."..value] = newProfile or {}

				-- Set the user profile to the new profile
				AucAdvancedConfig[UserSig] = value

				-- Add the new profile to the profiles list:-

				-- Check/create the profiles list
				local profiles = AucAdvancedConfig["profiles"]
				if (not profiles) then
					profiles = { "Default" }
					AucAdvancedConfig["profiles"] = profiles
				end

				-- Check to see if the new profile's name already exists
				local found = false
				for pos, name in ipairs(profiles) do
					if (name == value) then found = true break end
				end

				-- If not, add it and then sort it
				if (not found) then
					table.insert(profiles, value)
					table.sort(profiles)
				end
			else
				message(_TRANS("ADV_Help_InvalidProfileName")) --"Cannot create new profile: please enter a new profile name first"
				return
			end
		elseif (setting == "profile.delete") then
			-- User clicked the Delete button, see what the select box's value is.
			value = gui.elements["profile"].value

			-- If there's a profile name supplied
			if value and value ~= "Default" then -- don't let the user delete the Default profile!

				-- Delete its profile container
				AucAdvancedConfig["profile."..value] = nil

				-- Find its entry in the profiles list
				local profiles = AucAdvancedConfig["profiles"]
				if (profiles) then
					for pos, name in ipairs(profiles) do
						-- If this is it, then extract it
						if name == value then
							table.remove(profiles, pos)
						end
					end
				end

				-- If the user was using this one, then move them to Default
				if (getUserProfileName() == value) then
					AucAdvancedConfig[UserSig] = 'Default'
					private.CheckObsolete()
				end
			else
				message(_TRANS("ADV_Help_CannotDeleteProfile")) --"The selected profile cannot be deleted"
				return
			end
		elseif (setting == "profile.default") then
			-- User clicked the reset settings button

			-- Get the current profile from the select box
			value = gui.elements["profile"].value

			-- Overwrite with an empty profile
			AucAdvancedConfig["profile."..value] = {}

		elseif (setting == "profile") then
			-- User selected a different value in the select box, get it
			value = gui.elements["profile"].value

			-- Change the user's current profile to this new one
			AucAdvancedConfig[UserSig] = value

			-- Check newly loaded profile
			private.CheckObsolete()
		end

		-- Refresh all values to reflect current data
		gui:Refresh()
	elseif a == "maintenance" then
		if setting == "maintenance.clearscan" then
			if IsAltKeyDown() and not IsShiftKeyDown() and not IsControlKeyDown() then -- Alt key and NO other mod keys
				AucAdvanced.Scan.ClearScanData("ALL")
				message("ScanData cleared")
			else
				message("You must hold down the Alt key to clear all ScanData")
			end
		end
	elseif (a == "matcher") then
		if internal.API.MatcherSetter(setting, value) then
			gui:Refresh()
		end
	else
		-- Set the value for this setting in the current profile
		local db = getUserProfile()

		if c then -- All modules should be using tripart-style "type.modulename.setting"
			if value == nil then -- delete an entry: special handling to avoid empty tables
				local dba = db[a]
				if not dba then return end
				local dbab = dba[b]
				if not dbab then return end
				if dbab[c] == value then return end -- value unchanged
				dbab[c] = value
				if not next(dbab) then
					dba[b] = nil
					if not next(dba) then
						db[a] = nil
					end
				end
			else -- create or replace an entry
				local dba = db[a]
				if not dba then
					dba = {}
					db[a] = dba
				end
				local dbab = dba[b]
				if not dbab then
					dbab = {}
					dba[b] = dbab
				end
				if dbab[c] == value then return end -- value unchanged
				dbab[c] = value
			end
		else --non valid format saved variables are stored in flat mode here.
			if db[setting] == value then return end
			db[setting] = value
		end
	end
	if setting == "uselocale" then--Stores the last user choosen locale so it can be used next time
		lib.SetSetting("SelectedLocale", value)
	end

	if silent then
		-- caller has specified that "configchanged" should not be sent - should only be used in exceptional circumstances
		-- where a "configchanged" message might cause a conflict, e.g. from within the caller's configchanged handler!
		-- where the setting is an obsolete setting being deleted
		return
	end
	if not c then
		c = setting
		b = "flat"
	end
	AucAdvanced.SendProcessorMessage("configchanged", setting, callbackValue, c, b, a)
end

function lib.SetSetting(...)
	setter(...)
	if (gui) then
		gui:Refresh()
	end
end


local function getter(setting)
	--Is the setting actually a function reference? If so, call it.
	-- This was added to enable Protect Window to update its
	-- status without a UI reload by calling a function rather
	-- than a setting in the Control definition.
	if type(setting)=="function" then
		return setting("getsetting")
	end

	local a, b, c = strsplit(".", setting, 3)
	if (a == 'profile') then
		if not b then -- (setting == 'profile')
			return getUserProfileName()
		elseif (b == 'profiles') then
			local pList = AucAdvancedConfig["profiles"]
			if (not pList) then
				pList = { "Default" }
			end
			return pList
		end
	elseif a == "maintenance" then
		-- placeholder for use by Data Maintenance tab
		return nil
	elseif a == "matcher" then
		return internal.API.MatcherGetter(setting)
	end

	local db = getUserProfile()

	-- All modules should now be using "type.modulename.setting" format
	if c then
		-- valid tripart setting - look for it in the nested tables of db
		local dba = db[a]
		if dba then
			local dbab = dba[b]
			if dbab then
				local dbabc = dbab[c]
				if dbabc ~= nil then
					return dbabc
				end
			end
		end
	elseif ( db[setting] ~= nil ) then
		-- invalid (flat) format saved variables are stored here
		return db[setting]
	end

	-- return default values if all else fails
	return getDefault(setting)
end

function lib.GetSetting(setting, default)
	local option = getter(setting)
	if ( option ~= nil ) then
		return option
	else
		return default
	end
end

function lib.Show()
	if not gui then
		lib.MakeGuiConfig()
		-- check that MakeGuiConfig succeeded
		if not gui then
			return
		end
	end
	gui:Show()
end

function lib.Hide()
	if (gui) then
		gui:Hide()
	end
end

function lib.Toggle()
	if (gui and gui:IsShown()) then
		lib.Hide()
	else
		lib.Show()
	end
end

function lib.MakeGuiConfig()
	if private.MakeGuiConfig then private.MakeGuiConfig() end
end
function private._MakeGuiConfig() -- Name mangled to block gui creation at first; will be corrected by private.Activate
	private.MakeGuiConfig = nil -- only run once

	local id, last, cont
	local Configator = Libraries.Configator
	gui = Configator:Create(setter, getter)
	lib.Gui = gui
	gui:AddCat("Core Options", nil, false)


	id = gui:AddTab("Profiles")

	gui:AddControl(id, "Header",     0,    _TRANS('ADV_Interface_SetupProfile')) --"Setup, Configure and Edit Profiles"
	gui:AddControl(id, "Subhead",    0,    _TRANS('ADV_Interface_ActivateProfile')) --"Activate a current profile"
	gui:AddControl(id, "Selectbox",  0, 1, "profile.profiles", "profile")
	gui:AddTip(id, _TRANS('ADV_Help_ActivateProfile')) --"Select the profile that you wish to use for this character"

	gui:AddControl(id, "Button",     0, 1, "profile.delete", _TRANS('ADV_Interface_Delete')) --"Delete"
	gui:AddTip(id, _TRANS('ADV_Help_DeleteProfile')) --"Deletes the currently selected profile"
	gui:AddControl(id, "Button",     0, 1, "profile.default", _TRANS("ADV_Interface_ResetProfile")) --"Reset"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ResetProfile')) --"Reset all settings in the current profile to the default values"

	gui:AddControl(id, "Subhead",    0,    _TRANS('ADV_Interface_CreateProfile')) --"Create or replace a profile"
	gui:AddControl(id, "Text",       0, 1, "profile.name", _TRANS('ADV_Interface_ProfileName')) --"New profile name:"
	gui:AddTip(id, _TRANS('ADV_Help_ProfileName')) --"Enter the name of the profile that you wish to create"

	gui:AddControl(id, "Button",     0, 1, "profile.save", _TRANS('ADV_Interface_NewProfile')) --"New"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_NewProfile')) --"Create or overwrite a profile with the specified profile name. All settings will be reset to the default values."
	gui:AddControl(id, "Button",     0, 1, "profile.duplicate", _TRANS("ADV_Interface_CopyProfile")) --"Copy"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_CopyProfile')) --"Create or overwrite a profile with the specified profile name. All settings will be copied from the current profile.")

--localize AddHelp for Profiles
	gui:AddHelp(id, "what is",
		"What is a profile?",
		"A profile is used to contain a group of settings, you can use different profiles for different characters, or switch between profiles for the same character when doing different tasks."
	)
	gui:AddHelp(id, "how create",
		"How do I create a new profile?",
		"You enter the name of the new profile that you wish to create into the text box labelled \"New profile name\", and then click the \"New\" or \"Copy\" button. A profile may be called whatever you wish, but it should reflect the purpose of the profile so that you may more easily recall that purpose at a later date."
	)
	gui:AddHelp(id, "how delete",
		"How do I delete a profile?",
		"To delete a profile, simply select the profile you wish to delete with the drop-down selection box and then click the Delete button. You cannot delete the \"Default\" profile."
	)
	gui:AddHelp(id, "why delete",
		"Why would I want to delete a profile?",
		"You can delete a profile when you don't want to use it anymore. Deleting a profile will also affect any other characters who are using the profile."
	)


	id = gui:AddTab("General")
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",     0,    _TRANS('ADV_Interface_AucOptions')) --"Main Auctioneer Options"

	gui:AddControl(id, "Subhead",     0,	_TRANS('ADV_Interface_PreferredOutputFrame')) --"Preferred Output Frame"
	gui:AddControl(id, "Selectbox", 0, 1, AucAdvanced.configFramesList, "printwindow")
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ChatOutputFrame')) --"This allows you to select which chat window Auctioneer prints its output to."

	gui:AddControl(id, "Subhead",     0,	_TRANS('ADV_Interface_PreferredLanguage')) --"Preferred Language"
	gui:AddControl(id, "Selectbox", 0, 1, AucAdvanced.changeLocale(), "uselocale")
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_PreferredLanguage')) --"Chooses the language used by Auctioneer. This will require a /console reloadui or restart to take full effect"

	gui:AddControl(id, "Checkbox",   0, 1, "clickhook.enable", _TRANS('ADV_Interface_SearchingClickHooks')) --"Enable searching click-hooks"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_SearchClickHooks')) --"Enables the click-hooks for searching"

	gui:AddControl(id, "Subhead",     0,    _TRANS('ADV_Interface_MktPriceOptions')) --"Market Price Options"
	gui:AddControl(id, "Slider", 0, 1, "core.marketvalue.tolerance", 0.001, 1, 0.001, _TRANS('ADV_Interface_MarketValueAccuracy')) --"Market Pricing Error: %5.3f%%"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_MarketValueAccuracy')) --"Sets the accuracy of computations for market pricing. This indicates the maximum error that will be tolerated. Higher numbers reduce the amount of processing required by your computer (improving frame rate while calculating) at the cost of some accuracy."
	gui:AddControl(id, "Subhead",     0,    _TRANS('ADV_Interface_MatchOrder')) --"Matcher Order"
	last = gui:GetLast(id)
	gui:AddControl(id, "Selectbox",  0, 1, internal.API.GetMatcherDropdownList, "matcher.select")
	gui:SetLast(id, last)
	gui:AddControl(id, "Button",     0.3,1, "matcher.up", _TRANS('ADV_Interface_Up')) --"Up"
	gui:SetLast(id, last)
	gui:AddControl(id, "Button",     0.45, 1, "matcher.down", _TRANS('ADV_Interface_Down')) --"Down"

	gui:AddControl(id, "Subhead",     0,     _TRANS('ADV_Interface_PurchasingOptions')) --"Purchasing Options"
	gui:AddControl(id, "Checkbox",    0, 1,  "ShowPurchaseDebug", _TRANS('ADV_Interface_ShowPurchaseDebug')) --"Show purchase queue info"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ShowPurchaseDebug')) --"Shows what is added to the purchase queue, and what is being purchased"

	gui:AddControl(id, "Subhead",     0,     _TRANS('ADV_Interface_PostingOptions')) --"Posting Options"
	gui:AddControl(id, "Checkbox",    0, 1,  "post.clearonclose", _TRANS('ADV_Interface_PostClearOnClose')) --"Clear the posting queue when the Auctionhouse is closed"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_PostClearOnClose')) --"When the Auctionhouse closes, cancels any auction requests queued up to be posted"
	gui:AddControl(id, "Checkbox",    0, 2,  "post.confirmonclose", _TRANS('ADV_Interface_PostConfirmOnClose')) --"Ask before clearing the posting queue"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_PostConfirmOnClose')) --"When the Auctionhouse closes, presents a popup dialog asking if you really want to clear the posting queue"

	gui:AddHelp(id, "what is preferred output frame",
		_TRANS('ADV_Help_WhatPreferredChatFrame'), --"What is the Preferred Output Frame?",
		_TRANS('ADV_Help_WhatPreferredChatFrameAnswer')) --"The Preferred Output Frame allows you to designate which of your chat windows Auctioneer prints its output to.  Select one of the frames listed in the drop down menu and Auctioneer will print all subsequent output to that window."
	gui:AddHelp(id, "what is preferred language",
		_TRANS('ADV_Help_WhatPreferredLanguage'), --"What is the Preferred Language?",
		_TRANS('ADV_Help_WhatPreferredLanguageAnswer')) --"The Preferred Language allows you to designate which of the supported translations you want Auctioneer to use. This can be handy if you prefer auctioneer to use a diffrent locale than the game client. This requires a restart or /console reloadui"
	gui:AddHelp(id, "what is clickhook",
		_TRANS('ADV_Help_WhatClickHooks'), --"What are the click-hooks?",
		_TRANS('ADV_Help_WhatClickHooksAnswer')) --"The click-hooks let you perform a search for an item either by Alt-right-clicking the item in your bags, or by Alt-clicking an item link in the chat pane.")
	gui:AddHelp(id, "what is accuracy",
        _TRANS('ADV_Help_WhatAccuracy'), --"What is Market Pricing error?",
        _TRANS('ADV_Help_WhatAccuracyAnswer')) --"Market Pricing Error allows you to set the amount of error that will be tolerated while computing market prices. Because the algorithm is extremely complex, only an estimate can be made. Lowering this number will make the estimate more accurate, but will require more processing power (and may be slower for older computers)."


	id = gui:AddTab("Scanner")
	gui:AddControl(id, "Header", 0, _TRANS("ADV_Interface_ScanOptions"))--"Scanning Options"

	gui:AddControl(id, "Subhead", 0, _TRANS("ADV_Interface_Displays"))--"Displays and Reports"
	gui:AddControl(id, "Checkbox",   0, 1, "scancommit.progressbar", _TRANS('ADV_Interface_ProgressBar')) --"Enable processing progress bar"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ProgressBar')) --"Displays a progress bar while Auctioneer is processing data"

	gui:AddControl(id, "Checkbox",   0, 1, "scandata.summaryonfull", _TRANS('ADV_Interface_ScanDataSummaryFull')) --"Enables the display of the post scan summary"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ScanDataSummaryFull')) --"Display the summation of an Auction House scan"
	gui:AddControl(id, "Checkbox",   0, 1, "scandata.summaryonpartial", _TRANS('ADV_Interface_ScanDataSummaryPartial')) --"Enables the display of the post scan summary"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ScanDataSummaryPartial')) --"Display the summation of an Auction House scan"
	gui:AddControl(id, "Checkbox",   0, 1, "scandata.summaryonmicro", _TRANS('ADV_Interface_ScanDataSummaryMicro')) --"Enables the display of the post scan summary"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ScanDataSummaryMicro')) --"Display the summation of an Auction House scan"

	gui:AddControl(id, "Subhead",     0,	_TRANS('ADV_Interface_DataRetrieval')) --"Data Retrieval"
	gui:AddControl(id, "Slider",	0, 1, "scancommit.targetFPS", 5, 100, 5, _TRANS('ADV_Interface_ProcessingTargetFPS')) --"Desired FPS during scan: %d"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ProcessingTargetFPS')) --"Sets the target frame rate during the scan. Higher values will be smoother, but will take more time overall."
	gui:AddControl(id, "Slider",	0, 1, "scancommit.ttl", 1, 70, 1, _TRANS('ADV_Interface_ScanRetrieveTTL').." %d ".._TRANS('ADV_Interface_seconds'))--Scan Retrieval Time-to-Live
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ScanRetrieveTTL') )--The number of seconds Auctioneer will spend trying to get data that was missing from the scan initially.
	gui:AddControl(id, "Slider",	0, 1, "core.scan.unresolvedtolerance", 0, 100, 1, _TRANS("ADV_Interface_UnresolvedAuctionsTolerance").." %d") --Unresolved Auctions Tolerance
	gui:AddTip(id, _TRANS("ADV_HelpTooltip_UnresolvedAuctionsTolerance")) --Maximum number of unresolvable auctions allowed for a full scan to still be treated as Complete

	gui:AddControl(id, "Checkbox",	0, 1, "core.scan.sellernamedelay", _TRANS('ADV_Interface_ScanSellerNames'))--Additional scanning to retrieve more Seller names
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ScanSellerNames')) --Perform additional scanning to retrieve more data about the names of Sellers. If this option is disabled scans will finish sooner but some filters and searchers will not work
	gui:AddControl(id, "Checkbox",	0, 1, "core.scan.scanallqueries", _TRANS('ADV_Interface_ScanAllQueries')) --Scan manual searches and searches by other Addons
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ScanAllQueries')) --Enable to perform scanning of every Auctionhouse search. Disable to only scan Auctioneer's own searches.\nYou may need to disable this option if you have compatibility problems with other AddOns

	gui:AddControl(id, "Subhead", 0, "Experimental Settings (consult the forums before using these)")
	gui:AddControl(id, "Selectbox",  0, 1, AucAdvanced.selectorActivityLevelB, "core.scan.scannerthrottle", 80, "Scanner stage: Throttle during fast scans")
	gui:AddTip(id, "Slow down the Scanning stage during Getall scans. May help avoid disconnects during this stage. May result in missed auctions and incomplete scans")
	gui:AddControl(id, "Checkbox",	0, 1, "core.scan.fillduringscan", "Scanner stage: Read extra item data early")
	gui:AddTip(id, "Perform additional data gathering during the Scanning stage. This item data will otherwise be gathered during Processing Stage 1. This option may speed up overall scanning. Alternatively it may cause system freezes.")

	gui:AddControl(id, "Selectbox",  0, 1, AucAdvanced.selectorActivityLevelA, "core.scan.stage1throttle", 80, "Processing Stage 1: Throttle processing speed")
	gui:AddTip(id, "Throttle the speed of Stage 1 Processing. Applying this setting may help if you get disconnects during Stage 1")
	gui:AddControl(id, "Selectbox",  0, 1, AucAdvanced.selectorActivityLevelA, "core.scan.stage3garbage", 80, "Processing Stage 3: Extra memory cleanup")
	gui:AddTip(id, "Perform extra memory cleanup during Processing Stage 3. Will cause momentary freezes, and will cause Processing to take longer")
	gui:AddControl(id, "Checkbox",	0, 1, "core.scan.stage5garbage", "Processing Finished: Extra memory cleanup")
	gui:AddTip(id, "Perform extra memory cleanup when scan processing finishes. Will cause a momentary freeze at the end of every scan")
	--[[ ### temporarily disabled: we're converting to the LibAucItemCache lib, which doesn't have this capability yet
	gui:AddControl(id, "Checkbox",	0, 1, "core.scan.keepinfocacheonclose", "Keep data in Item Info cache when AuctionHouse closed")
	gui:AddTip(id, "Auctioneer Scanner stores some item data to help reduce the number of server calls it makes. Normally this is cleared when the AuctionHouse is closed, to free up some memory. Enabling this option retains the data until the end of the session.")
	--]]



	gui:AddHelp(id, "why show summation",
		_TRANS('ADV_Help_WhyShowSummation'), --"What is the post scan summary?",
		_TRANS('ADV_Help_WhyShowSummationAnswer')) --"It displays the number of new, updated, or unchanged auctions gathered from a scan of the auction house."
	--[[
	gui:AddHelp(id, "what is priority",
		_TRANS('ADV_Help_WhatPriority'), --"What is the Processing Priority?",
		_TRANS('ADV_Help_WhatPriorityAnswer')) --"The Processing Priority sets the speed to process the data at the end of the scan. Lower values will take longer, but will let you move around more easily.  Higher values will take less time, but may cause jitter.  Updated data will not be available until processing is complete."
	--]]
	gui:AddHelp(id, "what is ttl",
		_TRANS('ADV_Interface_ScanRetrieveTTL'), --Scan Retrieval Time-to-Live,
		_TRANS('ADV_Help_ScanRetrieveTTL'))--After a fast (GetAll) scan, there are usually many items for which we did not receive data. We can try to get a complete scan by rechecking the items for new information.  This slider sets the time, in seconds, we will wait before giving up if we're unable to get new data.
	gui:AddHelp(id, "what is unresolved tolerance",
		_TRANS("ADV_Interface_UnresolvedAuctionsTolerance"), --Unresolved Auctions Tolerance
		_TRANS("ADV_Help_UnresolvedAuctionsTolerance")) --Auctioneer is sometimes unable to resolve a number of auctions during a scan, causing the scan to be incomplete. Unresolved Auctions Tolerance allows Auctioneer to still mark as scan as complete if the number of these errors is very small. May be useful when the server is unstable, particularly after major patches.


	-- Data Maintenance tab under development - do not localize yet
	id = gui:AddTab("Data Maintenance")
	gui:AddControl(id, "Header", 0, "Database Options and Maintenance")

	gui:AddControl(id, "Subhead", 0, "ScanData Settings")
	gui:AddControl(id, "Checkbox",   0, 1, "scandata.force", _TRANS('ADV_Interface_ScanDataForce')) --"Force load scan data"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ScanDataForce')) --"Forces the scan data to load when Auctioneer is first loaded rather than on demand when first needed"
	gui:AddControl(id, "Checkbox",   0, 1, "core.scan.disable_scandatawarning", _TRANS('ADV_Interface_NoScanDataWarning')) --Disable warning popup when scan data cannot load
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_NoScanDataWarning')) --Use this option if you often disable the Auc-ScanData AddOn to conserve memory. Warning: most Stats cannot be recorded if Auc-ScanData is not loaded

	gui:AddControl(id, "Note", 0, 1, nil, 12, " ") -- blank line separator
	gui:AddControl(id, "Button",     0, 1, "maintenance.clearscan", "Clear ALL ScanData")
	gui:AddTip(id, "Clear ScanData for all realms and factions.\nThe Alt key must be held down to activate this button.")

	gui:AddHelp(id, "why force load",
		_TRANS('ADV_Help_WhyForceLoad'), --"Why would you want to force load the scan data?"
		_TRANS('ADV_Help_WhyForceLoadAnswer')) --"If you are going to be using the image data in the game, some people would prefer to wait longer for the game to start, rather than the game lagging for a couple of seconds when the data is demand loaded."
	gui:AddHelp(id, "why clear scandata",
		"Why would you want to clear ScanData?",
		"The ScanData image can become corrupted, causing slowdowns, errors or even disconnects while scanning. If you experience these problems, clearing ScanData may help.\nClearing ScanData will affect Stat recording, so it should only be used if there is a problem.")


	--Tooltip category for all modules to add tooltip related settings too
	id = gui:AddTab("Tooltip")
	gui:MakeScrollable(id)
	lib.Gui.tooltipID = id
	gui:AddHelp(id, "what is the tooltip tab",
		_TRANS('ADV_Help_WhatTooltipTab'), --What is the tooltip tab?
		_TRANS('ADV_Help_WhatTooltipTabAnswer')) --This tab allows you to adjust what data gets displayed in the tooltips added by auctioneer. It provides a single point for any module to add settings that are related to tooltip functionality.

	gui:AddControl(id, "Header",   0,    _TRANS('ADV_Interface_TooltipDisplayOptionsOptions') ) --Tooltip Display Options
	gui:AddControl(id, "Subhead",    0,    _TRANS('ADV_Interface_ControlsShowHideTooltip') ) --Controls to show or hide tooltip information.
	gui:AddControl(id, "Note",       0, 1, nil, nil, " ")

	gui:AddControl(id, "Header",     0,    _TRANS('ADV_Interface_AucOptions')) --"Main Auctioneer Options"
	gui:AddControl(id, "Subhead",     0,	_TRANS('ADV_Interface_ModTTShow')) --"Show Tooltip:"
	gui:AddControl(id, "Selectbox", 0, 1, { { "always", _TRANS('ADV_Interface_mts_always') }, {"alt", _TRANS('ADV_Interface_mts_alt') }, { "noalt", _TRANS('ADV_Interface_mts_noalt') }, {"shift", _TRANS('ADV_Interface_mts_shift') }, {"noshift", _TRANS('ADV_Interface_mts_noshift')}, {"ctrl", _TRANS('ADV_Interface_mts_ctrl')},{"noctrl", _TRANS('ADV_Interface_mts_noctrl')}, { "never", _TRANS('ADV_Interface_mts_never')} }, "ModTTShow")
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ModTTShow')) --"Determines Tooltip behavior. Always: Show Auctioneer's Tooltip every time. When <mod> is pressed: Only show Auctioneer's tooltip if the specified modifier is pressed. When <mod> is not pressed: Only show Auctioneer's tooltip if the specified modifier is not pressed. Never: Never show Auctioneer's tooltip."
	gui:AddControl(id, "Checkbox",   0, 1, "core.tooltip.enableincombat", _TRANS("ADV_Interface_ShowTooltipInCombat")) --Show Auctioneer's tooltip when in combat
	gui:AddTip(id, _TRANS("ADV_HelpTooltip_ShowTooltipInCombat")) --Enable the display of Auctioneer's extended tooltips while in combat. Auctioneer tooltips can occasionally cause brief screen freezes so they are best left disabled during combat.
	gui:AddControl(id, "Checkbox",   0, 1, "core.tooltip.altchatlink_leftclick", _TRANS('ADV_Interface_AltChatLinkLeft')) --"Open tooltips from chat links with Alt left-clicks"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_AltChatLinkLeft')) --"Enables opening a tooltip by left-clicking on an item link in chat while the Alt key is pressed."
	gui:AddControl(id, "Checkbox",   0, 1, "scandata.tooltip.display", _TRANS('ADV_Interface_ScanDataDisplay')) --"Display scan data tooltip"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ScanDataDisplay')) --"Enable the display of how many items in the current scan image match this item"
	gui:AddControl(id, "Checkbox",   0, 3, "scandata.tooltip.modifier", _TRANS('ADV_Interface_ScanDataModifier')) --"Only show exact match unless SHIFT is held"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_ScanDataModifier')) --"Makes the scan data only display exact matches unless the shift key is held down"
	gui:AddControl(id, "Note",       0, 1, nil, nil, " ")

	gui:AddControl(id, "Header",     0,    _TRANS('ADV_Interface_MktPriceOptions')) --"Market Price Options"
	gui:AddControl(id, "Checkbox",   0, 1, "tooltip.marketprice.show", _TRANS('ADV_Interface_MktPriceShow')) --"Display Market Price in the tooltip"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_MktPrice')) --"Enables the display of Marketprice in the tooltip.  Holding down Shift will also show the prices that went into marketprice"
	gui:AddControl(id, "Checkbox",   0, 2, "tooltip.marketprice.stacksize", _TRANS('ADV_Interface_MultiplyStack')) --"Multiply by Stack Size"
	gui:AddTip(id, _TRANS('ADV_HelpTooltip_MultiplyStack')) --"Multiplies by current stack size if enabled"
	gui:AddControl(id, "Checkbox",   0, 1, "core.tooltip.depositcost", _TRANS('ADV_Interface_ShowDepositInTooltip')) --Show deposit cost in tooltip
	gui:AddControl(id, "Selectbox", 0, 1, AucAdvanced.selectorAuctionLength, "core.tooltip.depositduration", 90, _TRANS("ADV_Interface_DepositDuration")) --Auction duration for deposit cost
	gui:AddControl(id, "Note",       0, 1, nil, nil, " ")

	gui:AddHelp(id, "what is scandata",
		_TRANS('ADV_Help_WhatIsScanData'), --"What is the scan data tooltip?"
		_TRANS('ADV_Help_WhatIsScanDataAnswer')) --"The scan data tooltip is a line that appears in your tooltip that informs you how many of the current item have been seen in the auction house image."
	gui:AddHelp(id, "what is image",
		_TRANS('ADV_Help_WhatIsImage'), --"What is an auction house image?"
		_TRANS('ADV_Help_WhatIsImageAnswer')) --"As you scan the auction house, Auctioneer builds up an image of what is at the auction. This is the image. It represents Auctioneer's best guess at what is currently being auctioned. If your scan is fresh, this will be reasonably accurate, if it is not a recent scan, then the info will not."
	gui:AddHelp(id, "what is exact",
		_TRANS('ADV_Help_WhatExactMatch'), --"What is an exact match?"
		_TRANS('ADV_Help_WhatExactMatchAnswer')) --"Some items can vary slightly by suffix (for example: of the Bear/Eagle/Ferret etc), or exact stats (eg.: two items both of the Bear, but have differing statistics). An exact match will not match anything that is not 100% the same."


	gui:AddCat("Stat Modules")
  	gui:AddCat("Filter Modules")
  	gui:AddCat("Match Modules")
  	gui:AddCat("Util Modules")

	-- Alert all modules that the config screen is being built, so that they
	-- may place their own configuration should they desire it.
	AucAdvanced.SendProcessorMessage("config", gui)
end

function private.Activate()
	private.Activate = nil

	private.MakeGuiConfig = private._MakeGuiConfig
	private._MakeGuiConfig = nil

	local LibDataBroker = Libraries.LibDataBroker
	if LibDataBroker then
		private.LDBButton = LibDataBroker:NewDataObject("AucAdvanced", {
					type = "launcher",
					icon = "Interface\\AddOns\\Auc-Advanced\\Textures\\AucAdvIcon",
					OnClick = function(self, button) lib.Toggle(self, button) end,
				})

		function private.LDBButton:OnTooltipShow()
			self:AddLine("Auctioneer",  1,1,0.5, 1)
			self:AddLine("Auctioneer allows you to scan the auction house and collect statistics about prices.",  1,1,0.5, 1)
			self:AddLine("It also provides a framework for creating auction related addons.",  1,1,0.5, 1)
			self:AddLine("|cff1fb3ff".."Click|r to edit the configuration.",  1,1,0.5, 1)
		end
		function private.LDBButton:OnEnter()
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
			GameTooltip:ClearLines()
			private.LDBButton.OnTooltipShow(GameTooltip)
			GameTooltip:Show()
		end
		function private.LDBButton:OnLeave()
			GameTooltip:Hide()
		end
	end
end

--Changes the layout of saved var from a flat table to a nested set
--called from coremain lua's onload. This also adds a version # to our saved variables for future use
function internalLib.upgradeSavedVariables()
	if not AucAdvancedConfig["version"] then
		for p, data in pairs(AucAdvancedConfig) do
			if type(p) == "string" then
				local profile = strsplit(".",p)
				if profile =="profile" then
					local temp = {}
					for setting, value in pairs(data) do
						local a, b, c = setting:match("(.-)%.(.-)%.(.*)")
						if  a and b and c then
							if not temp[a] then temp[a] = {} end
							if not temp[a][b] then temp[a][b] = {} end
							temp[a][b][c] = value
						else --still keep the improper keys
							temp[setting] = value
						end
					end
					AucAdvancedConfig[p] = temp
				end
			end
		end
		AucAdvancedConfig["version"] = 1
	end
end

-- Check for obsolete settings and either convert to new "triplet" version, or delete if no longer required
-- Only checks the current profile, so must be called at OnLoad, and when user selects a new profile
-- todo: this list is probably going to get quite long, also it is related to upgradeSavedVariables -
---- can we do something to reduce duplicate code, and/or merge with upgradeSavedVariables?
function private.CheckObsolete()
	-- clean up obsolete setting(s)
	if getter("matcherdynamiclist") then
		setter("matcherdynamiclist", nil, true)
	end
	if getter("alwaysHomeFaction") then
		setter("alwaysHomeFaction", nil, true)
	end
	if getter("core.general.alwaysHomeFaction") then
		setter("core.general.alwaysHomeFaction", nil, true)
	end
	if getter("core.scan.scannerthrottle") == true then
		setter("core.scan.scannerthrottle", Const.ALEVEL_MED, true)
	end
	if getter("core.scan.hybridscans") then
		setter("core.scan.hybridscans", nil, true)
	end

	local old
	local old = getter("matcherlist")
	if old then
		if not getter("core.matcher.matcherlist") then
			setter("core.matcher.matcherlist", old, true)
		end
		setter("matcherlist", nil, true)
	end
	old = getter("marketvalue.accuracy")
	if old then
		if getter("core.marketvalue.tolerance") == getDefault("core.marketvalue.tolerance") then
			setter("core.marketvalue.tolerance", old, true)
		end
		setter("marketvalue.accuracy", nil, true)
	end
end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/CoreSettings.lua $", "$Rev: 6420 $")
AucAdvanced.CoreFileCheckOut("CoreSettings")
