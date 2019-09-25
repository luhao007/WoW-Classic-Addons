--[[
	Auctioneer - Search UI - Searcher General
	Version: 8.2.6415 (SwimmingSeadragon)
	Revision: $Id: SearcherGeneral.lua 6415 2019-09-22 00:20:05Z none $
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
local lib, parent, private = AucSearchUI.NewSearcher("General")
if not lib then return end
local aucPrint,decode,_,_,replicate,empty,_,_,_,debugPrint,fill = AucAdvanced.GetModuleLocals()
local get,set,default,Const = AucSearchUI.GetSearchLocals()
lib.tabname = "General"

function private.getTypes()
	local typetable = private.typetable
	if not typetable then
		typetable = {{-1, "All"}}
		private.typetable = typetable
		local classIDs, classNames = Const.AC_ClassIDList, Const.AC_ClassNameList
		for index, classID in ipairs(classIDs) do
			tinsert(typetable, {classID, classNames[index]})
		end
	end
	return typetable
end

function private.getSubTypes()
	local subtypetable
	local classID = get("general.type")
	if classID == private.lastsubtypeclass then subtypetable = private.subtypetable end
	if not subtypetable then
		subtypetable = {{-1, "All"}}
		private.subtypetable = subtypetable
		private.lastsubtypeclass = classID
		local subClassIDs, subClassNames = Const.AC_SubClassIDLists[classID], Const.AC_SubClassNameLists[classID]
		if subClassIDs then
			for index, subClassID in ipairs(subClassIDs) do
				tinsert(subtypetable, {subClassID, subClassNames[index]})
			end
		end
	end
	return subtypetable
end

--- ### todo: InventoryType table

function private.getQuality()
	return {
			{-1, "All"},
			{0, "Poor"},
			{1, "Common"},
			{2, "Uncommon"},
			{3, "Rare"},
			{4, "Epic"},
			{5, "Legendary"},
			{6, "Artifact"},
		}
end

function private.getTimeLeft()
	return {
			{0, "Any"},
			{1, "less than 30 min"},
			{2, "2 hours"},
			{3, "12 hours"},
			{4, "48 hours"},
		}
end

-- Set our defaults
default("general.name", "")
default("general.name.exact", false)
default("general.name.regexp", false)
default("general.name.invert", false)
default("general.type", -1)
default("general.subtype", -1)
default("general.quality", -1)
default("general.timeleft", 0)
default("general.ilevel.min", 0)
default("general.ilevel.max", Const.MAXITEMLEVEL)
default("general.ulevel.min", 0)
default("general.ulevel.max", Const.MAXUSERLEVEL)
default("general.seller", "")
default("general.seller.exact", false)
default("general.seller.regexp", false)
default("general.seller.invert", false)
default("general.minbid", 0)
default("general.minbuy", 0)
default("general.maxbid", Const.MAXBIDPRICE)
default("general.maxbuy", Const.MAXBIDPRICE)

-- This function is automatically called when we need to create our search generals
function lib:MakeGuiConfig(gui)
	-- Get our tab and populate it with our controls
	local id = gui:AddTab(lib.tabname, "Searchers")

	-- Add the help
	gui:AddSearcher("General", "Search for items by general properties such as name, level etc", 100)
	gui:AddHelp(id, "general searcher",
		"What does this searcher do?",
		"This searcher provides the ability to search for specific items that are in the scan database by name, level, type, subtype, seller, price, timeleft and other similar generals.")

	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",     0,      "Search criteria")

	local last = gui:GetLast(id)
	gui:SetControlWidth(0.35)
	local nameEdit = gui:AddControl(id, "Text",       0,   1, "general.name", "Item name")
	nameEdit:SetScript("OnTextChanged", function(...) gui:ChangeSetting(...) end) --have the edit box update as user types, default box only updates on escape or enter

	local cont = gui:GetLast(id)
	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",   0.11, 0, "general.name.exact", "Exact")
	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",   0.21, 0, "general.name.regexp", "Lua Pattern")
	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",   0.35, 0, "general.name.invert", "Invert")

	gui:SetLast(id, cont)
	last = cont

	gui:AddControl(id, "Note",       0.0, 1, 100, 14, "Type:")
	gui:AddControl(id, "Selectbox",   0.0, 1, private.getTypes, "general.type")
	gui:SetLast(id, last)
	gui:AddControl(id, "Note",       0.3, 1, 100, 14, "SubType:")
	gui:AddControl(id, "Selectbox",   0.3, 1, private.getSubTypes, "general.subtype")

	last = gui:GetLast(id)
	gui:AddControl(id, "Note",       0.0, 1, 100, 14, "Quality:")
	gui:AddControl(id, "Selectbox",   0.0, 1, private.getQuality(), "general.quality")
	gui:SetLast(id, last)
	gui:AddControl(id, "Note",       0.3, 1, 100, 14, "TimeLeft:")
	gui:AddControl(id, "Selectbox",  0.3, 1, private.getTimeLeft(), "general.timeleft")


	last = gui:GetLast(id)
	gui:SetControlWidth(0.37)
	gui:AddControl(id, "NumeriSlider",     0,   1, "general.ilevel.min", 0, Const.MAXITEMLEVEL, 1, "Min item level")
	gui:SetControlWidth(0.37)
	gui:AddControl(id, "NumeriSlider",     0,   1, "general.ilevel.max", 0, Const.MAXITEMLEVEL, 1, "Max item level")
	cont = gui:GetLast(id)

	gui:SetLast(id, last)
	gui:SetControlWidth(0.17)
	gui:AddControl(id, "NumeriSlider",     0.6, 0, "general.ulevel.min", 0, Const.MAXUSERLEVEL, 1, "Min user level")
	gui:SetControlWidth(0.17)
	gui:AddControl(id, "NumeriSlider",     0.6, 0, "general.ulevel.max", 0, Const.MAXUSERLEVEL, 1, "Max user level")

	gui:SetLast(id, cont)

	last = gui:GetLast(id)
	gui:SetControlWidth(0.35)
	gui:AddControl(id, "Text",       0,   1, "general.seller", "Seller name")
	cont = gui:GetLast(id)
	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",   0.13, 0, "general.seller.exact", "Exact")
	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",   0.23, 0, "general.seller.regexp", "Lua Pattern")
	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",   0.37, 0, "general.seller.invert", "Invert")

	gui:SetLast(id, cont)
	gui:AddControl(id, "MoneyFramePinned", 0, 1, "general.minbid", 0, Const.MAXBIDPRICE, "Minimum Bid")
	gui:SetLast(id, cont)
	gui:AddControl(id, "MoneyFramePinned", 0.5, 1, "general.minbuy", 0, Const.MAXBIDPRICE, "Minimum Buyout")
	last = gui:GetLast(id)
	gui:AddControl(id, "MoneyFramePinned", 0, 1, "general.maxbid", 0, Const.MAXBIDPRICE, "Maximum Bid")
	gui:SetLast(id, last)
	gui:AddControl(id, "MoneyFramePinned", 0.5, 1, "general.maxbuy", 0, Const.MAXBIDPRICE, "Maximum Buyout")
end

function lib.Search(item)
	private.debug = ""
	if private.NameSearch("name", item[Const.NAME])
			and private.TypeSearch(item[Const.CLASSID], item[Const.SUBCLASSID])
			and private.TimeSearch(item[Const.TLEFT])
			and private.QualitySearch(item[Const.QUALITY])
			and private.LevelSearch("ilevel", item[Const.ILEVEL])
			and private.LevelSearch("ulevel", item[Const.ULEVEL])
			and private.NameSearch("seller", item[Const.SELLER])
			and private.PriceSearch("Bid", item[Const.PRICE])
			and private.PriceSearch("Buy", item[Const.BUYOUT]) then
		return true
	else
		return false, private.debug
	end
end

--Rescan is an optional method a searcher can implement that allows it to queue a rescan of teh ah
--Just pass any item you want rescaned
function lib.Rescan()
	local searchName, minUseLevel, maxUseLevel, searchQuality, exactMatch, filterData

	local name = get("general.name")
	if name and name ~= "" and not get("general.name.regexp") and not get("general.name.invert") then
		searchName = name
		if get("general.name.exact") and #searchName < 60 then
			-- set exactMatch based on user setting, unless name is very long (names over 64 bytes will be truncated)
			exactMatch = true
		end
	end

	local minlevel, maxlevel = get("general.ulevel.min"), get("general.ulevel.max")
	if minlevel ~= 0 then minUseLevel = minlevel end
	if maxlevel ~= Const.MAXUSERLEVEL then maxUseLevel = maxlevel end

	local quality = get("general.quality")
	if quality > 0 then searchQuality = quality end

	local classID, subClassID = get("general.type"), get("general.subtype")

	-- following line is here in case we have old string values left behind from previous versions
	-- ### todo : can be removed after a suitable time
	classID, subClassID = tonumber(classID), tonumber(subClassID)

	if classID ~= -1 then
		if subClassID == -1 then subClassID = nil end
		filterData = AucAdvanced.Scan.QueryFilterFromID(classID, subClassID) -- ### todo: add invType
	end

	if searchName or filterData then
		-- Usage: RescanAuctionHouse(searchName, minUseLevel, maxUseLevel, isUsable, searchQuality, exactMatch, filterData)
		AucSearchUI.RescanAuctionHouse(searchName, minUseLevel, maxUseLevel, nil, searchQuality, exactMatch, filterData)
	end
end


function private.LevelSearch(levelType, itemLevel)
	local min = get("general."..levelType..".min")
	local max = get("general."..levelType..".max")

	if itemLevel < min then
		private.debug = levelType.." too low"
		return false
	end
	if itemLevel > max then
		private.debug = levelType.." too high"
		return false
	end
	return true
end

function private.NameSearch(nametype,itemName)
	local name = get("general."..nametype)

	-- If there's no name, then this matches
	if not name or name == "" then
		return true
	end

	-- Lowercase the input
	name = name:lower()
	itemName = itemName:lower()

	-- Get the matching options
	local nameExact = get("general."..nametype..".exact")
	local nameRegexp = get("general."..nametype..".regexp")
	local nameInvert = get("general."..nametype..".invert")

	-- if we need to make a non-regexp, exact match:
	if nameExact and not nameRegexp then
		-- If the name matches or we are inverted
		if name == itemName and not nameInvert then
			return true
		elseif name ~= itemName and nameInvert then
			return true
		end
		private.debug = nametype.." is not exact match"
		return false
	end

	local plain, text
	text = name
	if not nameRegexp then
		plain = 1
	elseif nameExact then
		text = "^"..name.."$"
	end

	local matches = itemName:find(text, 1, plain)
	if matches and not nameInvert then
		return true
	elseif not matches and nameInvert then
		return true
	end
	private.debug = nametype.." does not match critia"
	return false
end

-- ### todo: add invtypes
function private.TypeSearch(classID, subClassID)
	local searchtype = get("general.type")
	if searchtype == -1 then -- "All"
		return true
	elseif searchtype == classID then
		local searchsubtype = get("general.subtype")
		if searchsubtype == -1 then -- "All"
			return true
		elseif searchsubtype == subClassID then
			return true
		else
			private.debug = "Wrong Subtype"
			return false
		end
	else
		private.debug = "Wrong Type"
		return false
	end
end

function private.TimeSearch(iTleft)
	local tleft = get("general.timeleft")
	if tleft == 0 then
		return true
	elseif tleft == iTleft then
		return true
	else
		private.debug = "Time left wrong"
		return false
	end
end

function private.QualitySearch(iqual)
	local quality = get("general.quality")
	if quality == -1 then
		return true
	elseif quality == iqual then
		return true
	else
		private.debug = "Wrong Quality"
		return false
	end
end

function private.PriceSearch(buybid, price)
	local minprice, maxprice
	if buybid == "Bid" then
		minprice = get("general.minbid")
		maxprice = get("general.maxbid")
	else
		minprice = get("general.minbuy")
		maxprice = get("general.maxbuy")
	end
	-- disregard maxprice if it is 0, or if it is less then minprice
	if maxprice == 0 or maxprice < minprice then
		maxprice = nil
	end
	if price >= minprice and (not maxprice or price <= maxprice) then
		return true
	elseif price < minprice then
		private.debug = buybid.." price too low"
	else
		private.debug = buybid.." price too high"
	end
	return false
end
AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-SearchUI/SearcherGeneral.lua $", "$Rev: 6415 $")
