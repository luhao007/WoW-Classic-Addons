--[[
	Auctioneer - Search UI - Filter IgnoreItemQuality
	Version: 8.2.6415 (SwimmingSeadragon)
	Revision: $Id: FilterItemLevel.lua 6415 2019-09-22 00:20:05Z none $
	URL: http://auctioneeraddon.com/

	This is a plugin module for the SearchUI that assists in searching by refined parameters

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
-- Create a new instance of our lib with our parent
if not AucSearchUI then return end
local lib, parent, private = AucSearchUI.NewFilter("ItemLevel")
if not lib then return end
--local print,decode,_,_,replicate,empty,_,_,_,debugPrint,fill = AucAdvanced.GetModuleLocals()
local get,set,default,Const = AucSearchUI.GetSearchLocals()
lib.tabname = "ItemLevel"
-- Set our defaults
default("ignoreitemlevel.enable", false)

--local typename = Const.CLASSES
local classIDs = Const.AC_ClassIDList
local classNames = Const.AC_ClassNameList


-- This function is automatically called when we need to create our search parameters
function lib:MakeGuiConfig(gui)
	-- Get our tab and populate it with our controls
	local id = gui:AddTab(lib.tabname, "Filters")
	gui:MakeScrollable(id)

	-- Add the help
	gui:AddSearcher("Item Level", "Filter out items based on their level and type", 600)
	gui:AddHelp(id, "itemlevel filter",
		"What does this filter do?",
		"This filter provides the ability to filter out specific item types which are below a preset level threshold. It can selectively apply it's filters only for certain types of searches.")

	gui:AddControl(id, "Header",     0,      "ItemLevel Filter Criteria")

	gui:AddControl(id, "Checkbox",    0, 1,  "ignoreitemlevel.enable", "Enable ItemLevel filtering")
	gui:AddControl(id, "Subhead",     0, "Filter for:")
	for name, searcher in pairs(AucSearchUI.Searchers) do
		if searcher and searcher.Search then
			local setting = "ignoreitemlevel.filter."..name
			default(setting, false)
			gui:AddControl(id, "Checkbox", 0, 1, setting, name)
			gui:AddTip(id, "Filter Item Level when searching with "..name)
		end
	end

-- Assume valid minimum item level is 0 and valid max item level is Const.MAXITEMLEVEL.
-- Configure slider controls to reflect this range of values.
-- See norganna.org JIRA ASER-106 and ASER-132 for additional info about this value range.
	gui:AddControl(id, "Subhead",     0,  "Minimum itemLevels by Type")
	for i = 1, #classIDs do
		default("ignoreitemlevel.minlevel."..classIDs[i], 61)
		gui:AddControl(id, "WideSlider",   0, 1, "ignoreitemlevel.minlevel."..classIDs[i], 0, Const.MAXITEMLEVEL, 1, "Min iLevel for "..classNames[i]..": %s")

		-- ### Legion : try to delete obsolete settings,
		-- we now use classID instead of class name (same as CoreScan)
		-- to be removed after a suitable time interval...
		set("ignoreitemlevel.minlevel."..classNames[i], nil, true)
	end
end

--lib.Filter(item, searcher)
--This function will return true if the item is to be filtered
--Item is the itemtable, and searcher is the name of the searcher being called. If searcher is not given, it will assume you want it active.
function lib.Filter(item, searcher)
	if (not get("ignoreitemlevel.enable"))
			or (searcher and (not get("ignoreitemlevel.filter."..searcher))) then
		return
	end

	local classID = item[Const.CLASSID]
	local ilevel = item[Const.ILEVEL]

	local minlevel = get("ignoreitemlevel.minlevel."..classID)
	if not ilevel then
		return true, "Error: no ilevel"
	elseif not minlevel then
		return true, "Error: no min level set for "..classID
	elseif ilevel < minlevel then
		return true, "ItemLevel too low"
	end
end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-SearchUI/FilterItemLevel.lua $", "$Rev: 6415 $")
