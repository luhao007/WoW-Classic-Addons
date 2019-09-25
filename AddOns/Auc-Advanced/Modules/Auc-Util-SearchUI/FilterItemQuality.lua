--[[
	Auctioneer - Search UI - Filter IgnoreItemQuality
	Version: 8.2.6415 (SwimmingSeadragon)
	Revision: $Id: FilterItemQuality.lua 6415 2019-09-22 00:20:05Z none $
	URL: http://auctioneeraddon.com/

	This is a plugin module for the SearchUI that assists in searching by refined paramaters

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
local lib, parent, private = AucSearchUI.NewFilter("ItemQuality")
if not lib then return end
local print,decode,_,_,replicate,empty,_,_,_,debugPrint,fill = AucAdvanced.GetModuleLocals()
local get,set,default,Const = AucSearchUI.GetSearchLocals()
lib.tabname = "ItemQuality"
-- Set our defaults
default("ignoreitemquality.enable", false)

local classIDs = Const.AC_ClassIDList
local classNames = Const.AC_ClassNameList

local qualnames = {
	[0] = "Poor",
	[1] = "Common",
	[2] = "Uncommon",
	[3] = "Rare",
	[4] = "Epic",
	[5] = "Legendary",
	[6] = "Artifact",
} -- ### todo: localize

-- This function is automatically called when we need to create our search parameters
function lib:MakeGuiConfig(gui)
	-- Get our tab and populate it with our controls
	local id = gui:AddTab(lib.tabname, "Filters")
	gui:MakeScrollable(id)

	-- Add the help
	gui:AddSearcher("ItemQuality", "Filter items by quality and type", 600)
	gui:AddHelp(id, "itemquality filter",
		"What does this filter do?",
		"This filter provides the ability to filter out specific item types which have a given quality. It can selectively apply it's filters only for certain types of searches.")

	gui:AddControl(id, "Header",     0,      "ItemQuality Filter Criteria")

	gui:AddControl(id, "Checkbox",    0, 1,  "ignoreitemquality.enable", "Enable ItemQuality filtering")
	gui:AddControl(id, "Subhead",     0, "Filter for:")
	for name, searcher in pairs(AucSearchUI.Searchers) do
		if searcher and searcher.Search then
			local setting = "ignoreitemquality.filter."..name
			default(setting, false)
			gui:AddControl(id, "Checkbox", 0, 1, setting, name)
			gui:AddTip(id, "Filter Item Quality when searching with "..name)
		end
	end

	gui:AddControl(id, "Subhead",      0,    "Ignore Item Quality by Type")
	for i = 0, 6 do
		local last = gui:GetLast(id)
		gui:AddControl(id, "Note", i*0.1, 1, 50, 20, qualnames[i])
		if i < 6 then
			gui:SetLast(id, last)
		end
	end
	for i = 1, #classIDs do
		for j = 0, 6 do
			local last = gui:GetLast(id)
			gui:AddControl(id, "Checkbox", j*0.1+0.02, 1, "ignoreitemquality."..classIDs[i].."."..j, "")
			gui:AddTip(id, "Ignore "..qualnames[j].." "..classNames[i])
			gui:SetLast(id, last)

			-- ### Legion : try to delete obsolete settings,
			-- we now use classID instead of class name (same as CoreScan), and numeric quality values instead of text (as we want to localize the text at some time)
			-- to be removed after a suitable time interval...
			set("ignoreitemquality."..classNames[i].."."..qualnames[j], nil, true)
		end
		gui:AddControl(id, "Note", .67, 1, 200, 20, classNames[i])
	end
end

--lib.Filter(item, searcher)
--This function will return true if the item is to be filtered
--Item is the itemtable, and searcher is the name of the searcher being called. If searcher is not given, it will assume you want it active.
function lib.Filter(item, searcher)
	if (not get("ignoreitemquality.enable"))
			or (searcher and (not get("ignoreitemquality.filter."..searcher))) then
		return
	end

	local classID = item[Const.CLASSID]
	local quality = item[Const.QUALITY]
	local qualname = qualnames[quality]
	if not qualname then return end

	if get("ignoreitemquality."..classID.."."..quality) then
		return true, qualname.." "..classID.." filtered"
	end
	return false
end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-SearchUI/FilterItemQuality.lua $", "$Rev: 6415 $")
