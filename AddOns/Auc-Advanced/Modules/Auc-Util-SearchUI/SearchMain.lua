--[[
	Auctioneer - Search UI
	Version: 8.2.6415 (SwimmingSeadragon)
	Revision: $Id: SearchMain.lua 6415 2019-09-22 00:20:05Z none $
	URL: http://auctioneeraddon.com/

	This Addon provides a Search tab on the AH interface, which allows
	Auctioneer users to use Searcher plug-ins to search for good deals
	in the auction house.  It searches the "snapshot", which requires
	having data from recent auction house scans.

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

local libType, libName = "Util", "SearchUI"
local AucAdvanced = AucAdvanced
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local aucPrint,decode,_,_,replicate,_,get,set,default,debugPrint,fill, _TRANS = AucAdvanced.GetModuleLocals()

local empty = wipe
local ipairs,pairs,type,select = ipairs,pairs,type,select
local tostring,tonumber = tostring,tonumber
local floor,ceil,abs = floor,ceil,abs
local strmatch,format = strmatch,format
local tinsert,tremove = tinsert,tremove
-- GLOBALS: CreateFrame, GameTooltip

-- Our official name:
AucSearchUI = lib

local Const = AucAdvanced.Const
local coreResources = AucAdvanced.Resources -- the resources table inherited from AucAdvanced core
local gui
private.data = {}
private.sheetData = {}
private.sheetStyle = {}
private.isSearching = false
local coSearch
local SettingCache = {}
local currentSettings = {}
local hasUnsaved = nil

local TAB_NAME = "Search"

private.tleft = {
	"|cff000001|cffe5e5e530m", -- 30m
	"|cff000002|cffe5e5e52h",  --2h
	"|cff000003|cffe5e5e512h", --12h
	"|cff000004|cffe5e5e548h"  --48h
}

if AucAdvanced.Classic then
    private.tleft = {
        "|cff000001|cffe5e5e530m", --30m
        "|cff000002|cffe5e5e52h",  --2h
        "|cff000003|cffe5e5e58h",  --8h
        "|cff000004|cffe5e5e524h"  --24h
    }
end

lib.CleanTable = wipe -- for compatibility

local resources = {} -- the resources table passed on to the Searcher & Filter submodules
lib.Resources = resources
local flagScanFinished = false
local flagRescan

-- Faction Resources
-- Commonly used values which may change during the session (though most of them are no longer subject to change after initialization)
-- Actually handled by CoreResources - modules should probably convert to using CoreResources directly
-- Initialized by the "gameactive" Processor message - values should not be accessed before then
resources.Realm = Const.PlayerRealm -- will not change during session
function private.UpdateFactionResources()
	resources.Faction = coreResources.CurrentFaction
	resources.faction = resources.Faction:lower() -- lowercase (deprecated - no longer needed by GetDepositCost)
	resources.serverKey = coreResources.ServerKey
	resources.CutAdjust = coreResources.AHCutAdjust -- multiply price by .CutAdjust to subtract the AH brokerage fees
	lib.NotifyCallbacks("resources", "faction", resources.serverKey)
end

-- Selectbox Resources
--[[ Usages:
gui:AddControl(id, "Selectbox", column, indent, resources.selectorPriceModels, "searcher.model")
gui:AddControl(id, "Selectbox", column, indent, resources.selectorPriceModelsEnx, "searcher.model")
gui:AddControl(id, "Selectbox", column, indent, resources.selectorAuctionLength, "searcher.deplength")
local price, seen, curModel = resources.lookupPriceModel[model](model, link || itemID [, serverKey]) ~ price, seen or curModel may be nil
local price, seen, curModel = resources.GetPrice(model, link || itemID [, serverKey]) ~ simplified wrapper function for lookupPriceModel
if not resources.isValidPriceModel(get("searcher.model")) then <code to report warning...>
--]]
do -- limit scope of locals
	resources.selectorAuctionLength = AucAdvanced.selectorAuctionLength
	lib.AucLengthSelector = AucAdvanced.selectorAuctionLength -- for compatibility
	resources.selectorPriceModels = AucAdvanced.selectorPriceModels

	local pricemodelsenx
	function resources.selectorPriceModelsEnx()
		if not pricemodelsenx then
			pricemodelsenx = replicate(resources.selectorPriceModels())
			if resources.isEnchantrixLoaded then
				tinsert(pricemodelsenx, 1, {"Enchantrix", "Enchantrix"})
			end
		end
		return pricemodelsenx
	end
	function private.ResetPriceModelEnx()
		pricemodelsenx = nil
	end

	function resources.isValidPriceModel(testmodel)
		local pricemodels = resources.selectorPriceModelsEnx() -- make sure table is up to date
		local found -- default return value nil
		for pos, model in ipairs(pricemodels) do
			if model[1] == testmodel then
				found = model[2]
				break
			end
		end
		return found
	end

	-- lookup functions
	local function UnknownFunc() end -- return nil

	local function MarketFunc(model, link, serverKey)
		local price, seen = AucAdvanced.API.GetMarketValue(link, serverKey)
		return price, seen, model
	end

	local function AppraiserFunc(model, link, serverKey)
		local market, bid, _, seen, curModel = AucAdvanced.Modules.Util.Appraiser.GetPrice(link, serverKey)
		if not market or market == 0 then
			market = bid -- fallback to bid price if no market
		end
		return market, seen, curModel
	end

	local function EnchantrixFunc(model, link, serverKey)
		-- GetReagentPrice does not handle serverKey, and it does not return a seen count
		if serverKey and serverKey ~= coreResources.ServerKeyCurrent and serverKey ~= coreResources.ServerKey then return end
		local extra, mkt, five, _
		_, extra = Enchantrix.Util.GetPricingModel()
		_, _, mkt, five = Enchantrix.Util.GetReagentPrice(link, extra)
		return five or mkt, nil, extra or model
	end

	local function AlgorithmFunc(model, link, serverKey)
		local market, seen = AucAdvanced.API.GetAlgorithmValue(model, link, serverKey)
		return market, seen, model
	end

	local function indexFunc(lookup, model)
		local func
		if model == "Appraiser" and AucAdvanced.Modules.Util.Appraiser then
			func = AppraiserFunc
		elseif model == "Enchantrix" and resources.isEnchantrixLoaded then
			func = EnchantrixFunc
		elseif AucAdvanced.API.IsValidAlgorithm(model) then
			func = AlgorithmFunc
		end
		if func then
			rawset(lookup, model, func)
			return func
		end
		return UnknownFunc
	end

	local lookuppricemodel = setmetatable({market = MarketFunc}, {__index = indexFunc})

	resources.lookupPriceModel = lookuppricemodel
	function resources.GetPrice(model, link, serverKey) -- simplified wrapper
		return lookuppricemodel[model](model, link, serverKey)
	end
end

-- Enchantrix Load detection
if Enchantrix and Enchantrix.Storage and Enchantrix.Util then
	resources.isEnchantrixLoaded = true
else
	local _, _, _, _, reason = GetAddOnInfo("Enchantrix") -- check it's actually possible to load
	if reason == "DEMAND_LOADED" then
		Stubby.RegisterAddOnHook("Enchantrix", "Auc-Util-SearchUI", function()
			if Enchantrix and Enchantrix.Storage and Enchantrix.Util then
				Stubby.UnregisterAddOnHook("Enchantrix", "Auc-Util-SearchUI")
				resources.isEnchantrixLoaded = true
				private.ResetPriceModelEnx()
				lib.NotifyCallbacks("onload", "enchantrix")
			end
		end)
	end
end


--The rescan method is a button that is displayed only if the searcher implements a rescan function. The searcher then passes any itemlinks it wants refreshed data on
--Will accept either full search details or a hyperlink (item or battlepet)
function lib.RescanAuctionHouse(searchName, minUseLevel, maxUseLevel, isUsable, searchQuality, exactMatch, filterData) -- ### Legion : may need refining
	if type(searchName) ~= "string" or searchName == "" then
		searchName = nil -- nil invalid name - we could still search on other params
	end
	if searchName then
		-- we should either have a plain searchName or a link: a link will contain eaxctly 5 '|' characters
		-- a plain text searchName should not contain any '|' characters
		local _, hasBar, itemString, _, _, has5Bar, has6Bar = strsplit("|", searchName)
		if hasBar then -- contains at least 1 '|'
			if has6Bar or not has5Bar then -- check there are exactly 5 '|'
				return
			end
			local hyperlink = searchName -- save the full hyperlink
			-- override any provided function parameters with values for this link
			searchName, minUseLevel, maxUseLevel, isUsable, searchQuality, exactMatch, filterData = nil, nil, nil, nil, nil, nil, nil
			local lType, itemID, _, petQuality = strsplit(":", itemString)
			itemID = tonumber(itemID)
			if not itemID then return end -- check there is a valid itemID in this link
			-- note: lType should have a leading 'H'
			if lType == "Hitem" then
				local iname, _, qual, _, ulvl, _, _, _, _, _, _, classID, subClassID = GetItemInfo(hyperlink)
				if not iname then return end
				searchName = iname
				if ulvl and ulvl > 0 then
					minUseLevel = ulvl
					maxUseLevel = ulvl
				end
				if qual and qual > 0 then searchQuality = qual end
				filterData = AucAdvanced.Scan.QueryFilterFromID(classID, subClassID)
			elseif lType == "Hbattlepet" then
				local iname, _, petType = C_PetJournal.GetPetInfoBySpeciesID(itemID)
				if not iname then return end
				searchName = iname
				petQuality = tonumber(petQuality)
				if petQuality and petQuality > 0 then searchQuality = petQuality end
				filterData = AucAdvanced.Scan.QueryFilterFromID(LE_ITEM_CLASS_BATTLEPET, Const.AC_PetType2SubClassID[petType])
			end
			exactMatch = #searchName < 60 -- use exact match, except for very long names
		end
	end

	if searchName or filterData then
		if AucAdvanced.Scan.IsScanning() or AucAdvanced.Scan.IsPaused() then
			AucAdvanced.Scan.StartPushedScan(searchName, minUseLevel, maxUseLevel, isUsable, searchQuality, exactMatch, filterData)
		else
			AucAdvanced.Scan.PushScan()
			AucAdvanced.Scan.StartScan(searchName, minUseLevel, maxUseLevel, isUsable, searchQuality, nil, exactMatch, filterData)
		end
	end
end

function lib.OnLoad(addon)
	-- Notify that SearchUI is fully loaded
	resources.isSearchUILoaded = true
	lib.NotifyCallbacks("onload", addon)
end

lib.Processors = {}
function lib.Processors.load(callbackType, ...)
	private.ResetPriceModelEnx()
end

function lib.Processors.auctionclose(callbackType, ...)
	if private.isAttached then
		lib.DetachFromAH()
	end
	lib.NotifyCallbacks("auctionclose")
end

function lib.Processors.auctionopen(callbackType, ...)
	lib.NotifyCallbacks("auctionopen")
end

function lib.Processors.iteminfoupdate(callbackType, ...)
	lib.NotifyCallbacks("iteminfoupdate")
end

lib.Processors.gameactive = private.UpdateFactionResources
lib.Processors.factionselect = private.UpdateFactionResources

function lib.Processors.auctionui(callbackType, ...)
	if lib.Searchers.RealTime then
		lib.Searchers.RealTime.HookAH()
	end

	--we need to make sure that the GUI is made by the time the AH opens, as RealTime could be trying to add lines to it.
	lib.MakeGuiConfig()

	private.CreateAuctionFrames()
end

function lib.Processors.pagefinished(callbackType, ...)
	if lib.Searchers.RealTime then
		lib.Searchers.RealTime.FinishedPage(...)
	end
end

function lib.Processors.bidcancelled(callbackType, ...)
	private.bidcancelled(...)
end

function lib.Processors.scanfinish(callbackType, ...)
	-- pass the message in next OnUpdate
	flagScanFinished = true
end

function lib.Processors.scanprogress(callbackType, ...)
	if private.UpdateScanProgress then
		private.UpdateScanProgress(...)
	end
end

function lib.Processors.buyqueue(callbackType, ...)
	if private.UpdateBuyQueue then
		private.UpdateBuyQueue()
	end
end

function lib.Processors.itemtooltip(callbackType, tooltip, hyperlink, serverKey, quantity, decoded, additional, order)
	if not additional or additional.event ~= "SetAuctionItem" then
		--this isn't an auction, so we're not interested
		return
	end
	if order ~= 1 then
		-- only once per tooltip
		return
	end
	if not lib.GetSetting("debug.show") then
		--we're not interested in adding debug
		return
	end
	local button = GetMouseFocus():GetParent() --Note: check that it works without CompactUI
	local id = button.id --CompactUI's layout
	if not id then
		id = button:GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame) --without CompactUI
	end

	local ItemTable = AucAdvanced.Scan.GetAuctionItem("list", id)
	if not ItemTable then return end

	tooltip:AddLine("SearchUI:", 1, 0.7, 0.3)

	local active = false
	for name, searcher in pairs(lib.Searchers) do
		if lib.GetSetting("debug."..name) then
			active = true
			local success, returnvalue, value = lib.SearchItem(name, ItemTable, true, true)
			if success then
				if value then
					tooltip:AddLine("  "..name.." profit:"..floor(100*returnvalue/value).."%:", returnvalue, 1, 0.7, 0.3)
				elseif returnvalue then
					tooltip:AddLine("  "..name.." profit:", returnvalue, 1, 0.7, 0.3)
				else
					tooltip:AddLine("  "..name.." success", 1, 0.7, 0.3)
				end
			else
				tooltip:AddLine("  "..name..":"..returnvalue, 1, 0.7, 0.3)
			end
		end
	end
	if not active then --if it hasn't changed, we're not enabled for any searcher
		tooltip:AddLine("  No debugging enabled", 1, 0.7, 0.3)
	end
end
lib.Processors.battlepettooltip = lib.Processors.itemtooltip

-- Default setting values
local settingDefaults = {
	["processpriority"] = 60,
	["reserve"] = 0,
	["reserve.enable"] = false,
	["global.createtab"] = true,
	["maxprice"] = 10000000,
	["maxprice.enable"] = false,
	["tooltiphelp.show"] = true,
	--Scrollframe defaults
	["columnwidth.Item"] = 120,
	["columnwidth.Pct"] = 30,
	["columnwidth.Profit"] = 85,
	["columnwidth.Stk"] = 30,
	["columnwidth.Buyout"] = 85,
	["columnwidth.Bid"] = 85,
	["columnwidth.Reason"] = 85,
	["columnwidth.Seller"] = 75,
	["columnwidth.Left"] = 40,
	["columnwidth.Buy/ea"] = 85,
	["columnwidth.Bid/ea"] = 85,
	["columnwidth.MinBid"] = 85,
	["columnwidth.CurBid"] = 85,
	["columnwidth.Min/ea"] = 85,
	["columnwidth.Cur/ea"] = 85,

	["global.memorycleanup"] = false,
	["global.fast_remove_mode"] = false,
}

local function getDefault(setting)
	return settingDefaults[setting]
end

function lib.GetDefault(setting)
	return getDefault(setting)
end

function lib.SetDefault(setting, default)
	settingDefaults[setting] = default
end

local function initData()
	local data = AucAdvancedData.UtilSearchUiData
	if not data then
		data = {}
		data.Version = 1
		AucAdvancedData.UtilSearchUiData = data
	end
	if not data.SavedSearches then data.SavedSearches = {} end
	if not data.Current then data.Current = {} end
	if not data.Global then data.Global = {} end
end

local function isGlobalSetting(setting)
	local a,b,c = strsplit(".", setting)
	if a == "configator" then return true end
	if a == "global" then return true end
	return
end

local function setter(setting, value, silent)
	initData()

	local db = currentSettings

	-- turn value into a canonical true or false
	if value == 'on' then
		value = true
	elseif value == 'off' then
		value = false
	end

	if (isGlobalSetting(setting)) then
		AucAdvancedData.UtilSearchUiData.Global[setting] = value
		return -- ### todo: this is bypassing processor messages and callbacks ###
	end

	-- for defaults, just remove the value and it'll fall through
	if (value == 'default') or (value == getDefault(setting)) then
		-- Don't save default values
		value = nil
	end

	if db[setting] == value then
		if type(value) == "table" then
			-- same table as before
			-- call UpdateSave to check if the *contents* of the table have changed
			-- but don't send Processor message as *setting* is the same (consistent with Core version of 'setter')
			hasUnsaved = true
			lib.UpdateSave()
		end
		return
	end
	db[setting] = value

	hasUnsaved = true
	lib.UpdateSave()

	-- 'silent' flag inhibits notifications - only to be used for obsolete settings (see also equivalent CoreSettings function)
	if not silent then
		AucAdvanced.SendProcessorMessage("configchanged", setting, value, setting, "searchui", "util")
		lib.NotifyCallbacks('config', 'changed', setting, value)
	end
end

function lib.SetSetting(...)
	setter(...)
	if (gui) then
		gui:Refresh()
	end
end

local function getter(setting)
	initData()
	local db = currentSettings

	if (isGlobalSetting(setting)) then
		local value = AucAdvancedData.UtilSearchUiData.Global[setting]
		if value ~= nil then return value end
		return getDefault(setting)
	end

	if ( db[setting] ~= nil ) then
		return db[setting]
	else
		return getDefault(setting)
	end
end

function lib.GetSetting(setting, default)
	--use settings cache during a search
	if private.isSearching then
		if SettingCache[setting]~=nil then
			return SettingCache[setting]
		end
	end
	local option = getter(setting)
	if ( option ~= nil ) then
		if private.isSearching then
			SettingCache[setting] = option
		end
		return option
	else
		if private.isSearching then
			SettingCache[setting] = default
		end
		return default
	end
end

function lib.Show()
	lib.MakeGuiConfig()
	gui:Show()
end

function lib.Hide()
	if (gui) then
		gui:Hide()
	end
end

function lib.Toggle()
	if private.isAttached then return end
	if (gui and gui:IsShown()) then
		lib.Hide()
	else
		lib.Show()
	end
end

private.callbacks = {}
function lib.AddCallback(name, callback)
	if private.callbacks[name] then -- prevent overwriting an exisiting callback
		error("AucSearchUI.AddCallback Error:\nCallback for "..name.." already exists", 2) -- level 2 is calling function
	end
	private.callbacks[name] = callback
	-- fire certain callbacks, that have already happened, to new callback function
	if resources.isEnchantrixLoaded then
		callback("onload", "enchantrix")
	end
	if resources.isSearchUILoaded then
		callback("onload", "auc-util-searchui")
	end
	if gui then
		callback("guiconfig", gui)
	end
end

function lib.NotifyCallbacks(msg, ...)
	for name, callback in pairs(private.callbacks) do
		callback(msg, ...)
	end

	for name, searcher in pairs(lib.Searchers) do
		local processor = searcher.Processor
		if processor then
			local pType = type(processor)
			if pType == "table" then
				processor = processor[msg]
				if type(processor) == "function" then
					processor(...)
				end
			elseif pType == "function" then
				processor(msg, ...)
			end
		end
	end
	for name, filter in pairs(lib.Filters) do
		local processor = filter.Processor
		if processor then
			local pType = type(processor)
			if pType == "table" then
				processor = processor[msg]
				if type(processor) == "function" then
					processor(...)
				end
			elseif pType == "function" then
				processor(msg, ...)
			end
		end
	end
end

function lib.RemoveCallback(name, callback)
	if callback and private.callbacks[name] == callback then
		private.callbacks[name] = nil
		return true
	end
end

local searcherKit = {}
function searcherKit:GetName()
	return self.name
end

lib.Searchers = {}
function lib.NewSearcher(searcherName)
	if not lib.Searchers[searcherName] then
		local searcher = {}
		searcher.name = searcherName
		for k,v in pairs(searcherKit) do
			searcher[k] = v
		end

		lib.Searchers[searcherName] = searcher
		return searcher, lib, {}
	end
end

local filterKit = {}
function filterKit:GetName()
	return self.name
end

lib.Filters = {}
function lib.NewFilter(filterName)
	if not lib.Filters[filterName] then
		local filter = {}
		filter.name = filterName
		for k,v in pairs(filterKit) do
			filter[k] = v
		end

		lib.Filters[filterName] = filter
		return filter, lib, {}
	end
end

function lib.GetSearchLocals()
	return lib.GetSetting, lib.SetSetting, lib.SetDefault, Const, resources
end

function private.removeline(force)
	local selected = gui.sheet.selected
	--find the place in the sort list, so we can select the next one.
	for i,j in ipairs(gui.sheet.sort) do
		if j == selected then
			selected = i
			break
		end
	end

	if force or not lib.GetSetting("global.fast_remove_mode") then
		tremove(private.sheetData, gui.sheet.selected)
		--regenerate style elements, to match shorter data table
		local total =  #private.sheetData
		for i = gui.sheet.selected, total do
			private.sheetStyle[i] = private.sheetStyle[i+1]
		end
		private.sheetStyle[total+1] = nil --remove extra style
	else
		-- fast remove workaround: simply skip to the next line
		-- this reduces the number of (expensive) table removes, but leaves the 'removed' line in the data table
		selected = selected + 1
	end

	gui.sheet.selected = nil
	gui.sheet:SetData(private.sheetData, private.sheetStyle)
	lib.UpdateControls()
	gui.sheet.selected = gui.sheet.sort[selected]
	gui.sheet:Render() --need to redraw, so the selection looks right
	lib.UpdateControls()
end

function private.removeall()
	empty(private.sheetData)
	empty(private.sheetStyle)
	gui.sheet.selected = nil
	gui.sheet:SetData(private.sheetData, private.sheetStyle)
	gui.sheet:Render() --need to redraw, so the selection looks right
	lib.UpdateControls()
end

function private.repaintSheet()
	local wasEmpty = #gui.sheet.data < 1
	gui.sheet:SetData(private.sheetData, private.sheetStyle)
	if wasEmpty and #gui.sheet.data >= 1 then --sheet was empty, so select the just added auction
		gui.sheet.selected = 1
		gui.sheet:Render() --need to redraw, so the selection looks right
		lib.UpdateControls()
	end
end

function private.cropreason(reason)
	if reason then
		reason = strsplit(":", reason)
		return reason
	end
end

function private.buyauction()
	AucAdvanced.Buy.QueueBuy(private.data.link, private.data.seller, private.data.stack, private.data.minbid, private.data.buyout, private.data.buyout, private.cropreason(private.data.reason))
	private.removeline()
end

function private.bidauction()
	local bid = MoneyInputFrame_GetCopper(gui.frame.bidbox)
	AucAdvanced.Buy.QueueBuy(private.data.link, private.data.seller, private.data.stack, private.data.minbid, private.data.buyout, bid, private.cropreason(private.data.reason))
	private.removeline()
end

function private.buyfirst()
	gui.sheet.selected = gui.sheet.sort[1]
	if not gui.sheet.selected then
		return
	end
	lib.UpdateControls()
	if strmatch(private.data.reason, ":buy") then
		AucAdvanced.Buy.QueueBuy(private.data.link, private.data.seller, private.data.stack, private.data.minbid, private.data.buyout, private.data.buyout, private.cropreason(private.data.reason))
	elseif strmatch(private.data.reason, ":bid") then
		AucAdvanced.Buy.QueueBuy(private.data.link, private.data.seller, private.data.stack, private.data.minbid, private.data.buyout, private.data.bid, private.cropreason(private.data.reason))
	elseif private.data.buyout > 0 then
		AucAdvanced.Buy.QueueBuy(private.data.link, private.data.seller, private.data.stack, private.data.minbid, private.data.buyout, private.data.buyout, private.cropreason(private.data.reason))
	else
		AucAdvanced.Buy.QueueBuy(private.data.link, private.data.seller, private.data.stack, private.data.minbid, private.data.buyout, private.data.bid, private.cropreason(private.data.reason))
	end
	private.removeline()
end

--private.purchase
--Will buy/bid selected auction based on "reason" column
function private.purchase()
	if not gui.sheet.selected then
		return
	end
	local enableres = lib.GetSetting("reserve.enable")
	local reserve = lib.GetSetting("reserve") or 1
	local bidqueue = gui.frame.cancel.value or 0
	local balance = GetMoney()
	balance = balance - bidqueue --account for money we've already "spent"

	local price = 0
	if strmatch(private.data.reason, ":buy") then
		price = private.data.buyout
	elseif strmatch(private.data.reason, ":bid") then
		price = private.data.bid
	elseif private.data.buyout > 0 then
		price = private.data.buyout
	else
		price = private.data.bid
	end
	if ((balance-price) > reserve or not enableres) then
		AucAdvanced.Buy.QueueBuy(private.data.link, private.data.seller, private.data.stack, private.data.minbid, private.data.buyout, price, private.cropreason(private.data.reason))
	else
		aucPrint("Purchase cancelled: Reserve reached")
	end
	private.removeline()
end

--Will buy/bid ALL auctions based on "reason" column
function private.purchaseall()
	local enableres = lib.GetSetting("reserve.enable")
	local reserve = lib.GetSetting("reserve") or 1
	local money = GetMoney()
	for _, sortedRow in ipairs(gui.sheet.sort) do
		local bidqueue = gui.frame.cancel.value or 0
		local balance = money - bidqueue --account for money we've already "spent"

		local data = gui.sheet:GetRowData(sortedRow)
		local link = data[1]
		local seller = data[8]
		local stack = data[4]
		local bid = data[6]
		local minbid = data[12]
		local curbid = data[13]
		local buyout = data[5]
		local reason = data[7]
		local price = 0

		if strmatch(reason, ":buy") then
			price = buyout
		elseif strmatch(reason, ":bid") then
			price = bid
		elseif buyout > 0 then
			price = buyout
		else
			price = bid
		end

		if ((balance-price) > reserve or not enableres) then
			AucAdvanced.Buy.QueueBuy(link, seller, stack, minbid, buyout, price, private.cropreason(reason))

		else
			aucPrint("Purchase cancelled: Reserve reached")
		end
	end
	private.removeall()
end

function private.ignore()
	local sig = AucAdvanced.API.GetSigFromLink(private.data.link)
	local price
	if strmatch(private.data.reason, ":buy") then
		price = private.data.buyout
	elseif strmatch(private.data.reason, ":bid") then
		price = private.data.bid
	elseif private.data.buyout > 0 then
		price = private.data.buyout
	else
		price = private.data.bid
	end
	local count = private.data.stack or 1
	price = floor(price/count)
	AucSearchUI.Filters.ItemPrice.AddIgnore(sig, price)
	aucPrint("SearchUI now ignoring "..private.data.link.." at "..AucAdvanced.Coins(price, true))
	private.removeline()
end

function private.ignoreperm()
	local sig = AucAdvanced.API.GetSigFromLink(private.data.link)
	AucSearchUI.Filters.ItemPrice.AddIgnore(sig, 0)
	aucPrint("SearchUI now ignoring "..private.data.link.." at any price")
	private.removeline()
end

--a bid was cancelled, so ignore for session
function private.bidcancelled(callbackstring)
	local link, price, count = strsplit(";", callbackstring)
	local sig = AucAdvanced.API.GetSigFromLink(link)
	local price = floor(price/count) - 1
	if AucSearchUI.Filters.ItemPrice then
		AucSearchUI.Filters.ItemPrice.AddIgnore(sig, price, true)
		aucPrint("SearchUI now ignoring "..link.." at "..AucAdvanced.Coins(price, true).." for the session")
	end

end

function private.ignoretemp()
	local sig = AucAdvanced.API.GetSigFromLink(private.data.link)
	local price
	if strmatch(private.data.reason, ":buy") then
		price = private.data.buyout
	elseif strmatch(private.data.reason, ":bid") then
		price = private.data.bid
	elseif private.data.buyout > 0 then
		price = private.data.buyout
	else
		price = private.data.bid
	end
	local count = private.data.stack or 1
	price = floor(price/count)
	AucSearchUI.Filters.ItemPrice.AddIgnore(sig, price, true)
	aucPrint("SearchUI now ignoring "..private.data.link.." at "..AucAdvanced.Coins(price, true).." for the session")
	private.removeline()
end

function private.snatch()
	local link = private.data.link
	local price
		if strmatch(private.data.reason, ":buy") then
		price = private.data.buyout
	elseif strmatch(private.data.reason, ":bid") then
		price = private.data.bid
	elseif private.data.buyout > 0 then
		price = private.data.buyout
	else
		price = private.data.bid
	end
	local count = private.data.stack or 1
	price = floor(price/count) + 1 -- +1 so the current item also matches the search
	lib.Searchers.Snatch.AddSnatch(link,price)
	aucPrint("SearchUI will now snatch "..private.data.link.." at "..AucAdvanced.Coins(price, true))
end

local function keyPairs(t,f)
	local a, i = {}, 0
	for n in pairs(t) do tinsert(a, n) end
	table.sort(a, f)
	local iter = function ()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]] end
	end
	return iter
end

local function isEqual(a, b, l)
	if not l then l = 0
	elseif l > 10 then return false end

	local ta, tb = type(a), type(b)
	if ta ~= tb then return false end
	if ta == 'table' then
		for k,v in pairs(a) do
			if not isEqual(v, b[k], l+1) then return false end
		end
		for k,v in pairs(b) do
			if not isEqual(v, a[k], l+1) then return false end
		end
	else
		if tostring(a) ~= tostring(b) then
			return false
		end
	end
	return true
end

lib.IsEqual = isEqual

function lib.LoadCurrent()
	initData()
	local name = gui.saves.name:GetText()
	currentSettings = AucAdvancedData.UtilSearchUiData.Current
	if not currentSettings then
		lib.LoadSearch()
		return
	end

	local existing = AucAdvancedData.UtilSearchUiData.SavedSearches[name]
	if not existing then
		hasUnsaved = true
	elseif not isEqual(currentSettings, existing) then
		hasUnsaved = true
	else
		hasUnsaved = nil
	end
	lib.UpdateSave()
	gui:Refresh()
	lib.NotifyCallbacks('config', 'loaded', nil)
end

function lib.LoadSearch()
	initData()
	local name = gui.saves.name:GetText()
	if not AucAdvancedData.UtilSearchUiData.SavedSearches[name] then
		message("SearchUI warning:\nThat search does not exist, please select an available search from the menu.")
		return
	end
	currentSettings = replicate(AucAdvancedData.UtilSearchUiData.SavedSearches[name])
	AucAdvancedData.UtilSearchUiData.Current = currentSettings
	AucAdvancedData.UtilSearchUiData.Selected = name
	hasUnsaved = nil
	lib.UpdateSave()
	gui:Refresh()
	lib.NotifyCallbacks('config', 'loaded', name)
end

function lib.SaveSearch()
	initData()
	local name = gui.saves.name:GetText()
	AucAdvancedData.UtilSearchUiData.SavedSearches[name] = replicate(currentSettings)
	AucAdvancedData.UtilSearchUiData.Selected = name
	hasUnsaved = nil
	lib.UpdateSave()
	gui:Refresh()
	lib.NotifyCallbacks('config', 'saved', name)
end

function lib.DeleteSearch()
	initData()
	local name = gui.saves.name:GetText()
	AucAdvancedData.UtilSearchUiData.SavedSearches[name] = nil
	hasUnsaved = nil
	AucAdvancedData.UtilSearchUiData.Selected = ""
	gui.saves.name:SetText("")
	lib.UpdateSave()
	gui:Refresh()
	lib.NotifyCallbacks('config', 'deleted', name)
end

function lib.ResetSearch()
	initData()
	currentSettings = {}
	AucAdvancedData.UtilSearchUiData.Current = currentSettings
	hasUnsaved = nil
	AucAdvancedData.UtilSearchUiData.Selected = ""
	gui.saves.name:SetText("")
	lib.UpdateSave()
	gui:Refresh()
	lib.NotifyCallbacks('config', 'reset')
end

local curColor = "white"
function lib.UpdateSave()
	if not (gui and AucAdvancedData.UtilSearchUiData) then return end

	local name = gui.saves.name:GetText()

	if hasUnsaved then
		local saved = AucAdvancedData.UtilSearchUiData.SavedSearches[name]
		if saved and isEqual(currentSettings, saved) then
			hasUnsaved = false
		end
	end

	if AucAdvancedData.UtilSearchUiData.Selected ~= name then
		if curColor ~= "white" then
			gui.saves.name:SetTextColor(1, 1, 1, 1)
			curColor = "white"
		end
	elseif hasUnsaved then
		if curColor ~= "red" then
			gui.saves.name:SetTextColor(1, 0.5, 0.1, 1)
			curColor = "red"
		end
	else
		if curColor ~= "green" then
			gui.saves.name:SetTextColor(0.3, 1, 0.3, 1)
			curColor = "green"
		end
	end
end

function lib.AddSearcher(gui, searchType, searchDetail, searchPos)
	if not gui.searchers[searchPos] then gui.searchers[searchPos] = {} end
	gui.searchers[searchPos][searchType] = searchDetail
end

function lib.AttachToAH()
	if private.isAttached then return end
	local height, width = 410, 830
	gui.buttonTop = -30
	gui:SetPosition(gui.AuctionFrame, width, height, 5, 7+height)
	gui:HideBackdrop()
	gui:EnableMouse(false)
	gui:RealSetScale(0.9999)
	gui:RealSetScale(1.0)
	gui:Show()
	private.isAttached = true
end

function lib.DetachFromAH()
	if not private.isAttached then return end
	gui.buttonTop = 0
	gui:SetPosition()
	gui:EnableMouse(true)
	gui:ShowBackdrop()
	gui:RealSetScale(0.9999)
	gui:RealSetScale(private.scale or 1)
	gui:Hide()
	private.isAttached = nil
end

function private.CreateAuctionFrames()
	private.CreateAuctionFrames = nil
	if not lib.GetSetting("global.createtab") then return end

	local frame = CreateFrame("Frame", "AucAdvSearchUiAuctionFrame", AuctionFrame)
	gui.AuctionFrame = frame

	frame:SetParent(AuctionFrame)
	frame:SetPoint("TOPLEFT", AuctionFrame, "TOPLEFT")
	frame:SetPoint("BOTTOMRIGHT", AuctionFrame, "BOTTOMRIGHT")

	frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	frame.title:SetPoint("TOP", frame,  "TOP", 20, -17)
	frame.title:SetText("SearchUI - Auction search interface")

	local myTabName = "AuctionFrameTabUtilSearchUi"
	frame.tab = CreateFrame("Button", myTabName, AuctionFrame, "AuctionTabTemplate")
	frame.tab:SetText(TAB_NAME)
	frame.tab:Show()

	function frame.tab.OnClick(self, button, down)
		local index = self:GetID()
		local tab = _G["AuctionFrameTab"..index]
		if (tab and tab:GetName() == myTabName) then
			AuctionFrameTopLeft:SetTexture("Interface\\AddOns\\Auc-Advanced\\Textures\\AuctionFrameTopLeft")
			AuctionFrameTop:SetTexture("Interface\\AddOns\\Auc-Advanced\\Textures\\AuctionFrameTopMid")
			AuctionFrameTopRight:SetTexture("Interface\\AddOns\\Auc-Advanced\\Textures\\AuctionFrameTopRight")
			AuctionFrameBotLeft:SetTexture("Interface\\AddOns\\Auc-Advanced\\Textures\\AuctionFrameBotLeft")
			AuctionFrameBot:SetTexture("Interface\\AddOns\\Auc-Advanced\\Textures\\AuctionFrameBotMid")
			AuctionFrameBotRight:SetTexture("Interface\\AddOns\\Auc-Advanced\\Textures\\AuctionFrameBotRight")
			AuctionFrameMoneyFrame:Hide()
			frame:Show()
			lib.AttachToAH()
		else
			AuctionFrameMoneyFrame:Show()
			frame:Hide()
			lib.DetachFromAH()
		end
	end

	PanelTemplates_DeselectTab(frame.tab)
	AucAdvanced.AddTab(frame.tab, frame)

	hooksecurefunc("AuctionFrameTab_OnClick", frame.tab.OnClick)

	frame.money = frame:CreateTexture(nil, "ARTWORK")
	frame.money:SetTexture("Interface\\AddOns\\Auc-Advanced\\Textures\\GoldMoney")
	frame.money:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 18, 34)
	frame.money:SetWidth(256)
	frame.money:SetHeight(32)

	frame.backing = CreateFrame("Frame", nil, frame)
	frame.backing:SetPoint("TOPLEFT", frame, "TOPLEFT", 17, -70)
	frame.backing:SetPoint("BOTTOMRIGHT", frame.money, "TOPLEFT", 145, 50)
	frame.backing:SetBackdrop({ bgFile="Interface\\AddOns\\Auc-Advanced\\Textures\\BlackBack", edgeFile="Interface\\AddOns\\Auc-Advanced\\Textures\\WhiteCornerBorder", tile=1, tileSize=8, edgeSize=8, insets={left=3, right=3, top=3, bottom=3} })
	frame.backing:SetBackdropColor(0,0,0, 0.60)
	frame.backing:SetFrameLevel(frame:GetFrameLevel())

	frame.scanslabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.scanslabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 72, -19)
	frame.scanslabel:SetText("Pending Scans")
	frame.scanscount = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.scanscount:ClearAllPoints()
	frame.scanscount:SetPoint("LEFT", frame.scanslabel, "RIGHT", 5, 0)
	frame.scanscount:SetText("0")
	frame.scanscount:SetJustifyH("RIGHT")
	private.lastScansCount = 0
	function private.UpdateScanProgress(_, _, _, _, _, _, _, scansQueued)
		if AucAdvanced.Scan.IsScanning() then
			scansQueued = scansQueued + 1
		end
		if scansQueued ~= private.lastScansCount then
			private.lastScansCount = scansQueued
			frame.scanscount:SetText(scansQueued)
		end
	end

	if lib.Searchers.RealTime then
		local RTSButton = lib.Searchers.RealTime.CreateRTSButton(frame, true) -- norightclick option
		RTSButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 218, -15)
	end
end

function lib.MakeGuiConfig()
	if private.MakeGuiConfig then private.MakeGuiConfig() end
end

function private.MakeGuiConfig()
	private.MakeGuiConfig = nil

	local Configator = LibStub("Configator")
	local ScrollSheet = LibStub("ScrollSheet")
	local id, last, cont
	local selected

	gui = Configator:Create(setter,getter, 900, 500, 5, 350, 20, 5)
	gui:SetBackdropColor(0,0,0,1)

	gui.expandGap = 25
	gui.expandOnActivate = true
	gui.autoScrollTabs = true

	gui.searchers = {}
	gui.AddSearcher = function (self, searchType, searchDetail, searchPos)
		lib.AddSearcher(self, searchType, searchDetail, searchPos)
	end

	-- Only set scale if the gui isn't attached to the AH frame
	gui.RealSetScale = gui.SetScale
	function gui:SetScale(scale)
		private.scale = scale
		if private.isAttached then return end
		gui:RealSetScale(scale)
	end

	-- hook ActivateTab to notify callback
	gui.RealActivateTab = gui.ActivateTab
	function gui:ActivateTab(...)
		gui:RealActivateTab(...)
		local newtab = gui.config.selectedTab
		if newtab ~= gui.LastActiveTab then
			gui.LastActiveTab = newtab
			lib.NotifyCallbacks("selecttab", newtab)
		end
		gui.Search.updateDisplay()
	end

	private.gui = gui

	-- common functions and scripthandlers, used by various buttons and frames
	local function showTooltipText(button)
		if lib.GetSetting("tooltiphelp.show") then
			GameTooltip:SetOwner(button, "ANCHOR_TOPLEFT")
			GameTooltip:SetText(button.TooltipText)
		end
	end
	local function hideTooltip()
		GameTooltip:Hide()
	end

	gui.frame = CreateFrame("Frame", nil, gui)
	gui.frame:SetPoint("TOP", gui, "TOP", 0, -115)
	gui.frame:SetPoint("BOTTOMRIGHT", gui.Done, "TOPRIGHT", 0,25)
	gui.frame:SetPoint("LEFT", gui:GetButton(1), "RIGHT", 5,0)
	gui.frame:SetBackdrop({
		bgFile = "Interface/Tooltips/ChatBubble-Background",
		edgeFile = "Interface/Tooltips/ChatBubble-BackDrop",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 32, right = 32, top = 32, bottom = 32 }
	})
	gui.frame:SetBackdropColor(0, 0, 0, 1)

	gui.saves = CreateFrame("Frame", nil, gui)
	gui.saves:SetPoint("TOPRIGHT", gui, "TOPRIGHT", -5,-7)
	gui.saves:SetPoint("LEFT", gui:GetButton(1), "RIGHT", 10,0)
	gui.saves:SetHeight(28)

	gui.saves.title = gui.saves:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	gui.saves.title:SetPoint("LEFT", gui.saves, "LEFT", 10,0)
	gui.saves.title:SetText("Saved searches:")

	gui.saves.name = CreateFrame("EditBox", "SearchUiSaveName", gui.saves, "InputBoxTemplate")
	gui.saves.name:SetPoint("LEFT", gui.saves.title, "RIGHT", 10,0)
	gui.saves.name:SetAutoFocus(false)
	gui.saves.name:SetWidth(200)
	gui.saves.name:SetHeight(18)
	gui.saves.name:SetScript("OnTextChanged", function() lib.UpdateSave() end)
	if AucAdvancedData.UtilSearchUiData then
		local curSearch = AucAdvancedData.UtilSearchUiData.Selected or ""
		if AucAdvancedData.UtilSearchUiData.SavedSearches[curSearch] then
			gui.saves.name:SetText(curSearch)
		else
			gui.saves.name:SetText("")
		end
		lib.LoadCurrent()
	end

	local SelectBox = LibStub:GetLibrary("SelectBox")

	gui.saves.select = SelectBox:Create("SearchUiSaveSelect", gui.saves, 220, function(pos, key, value)
		gui.saves.name:SetText(value)
	end, function ()
		local saves = AucAdvancedData.UtilSearchUiData.SavedSearches
		local items = {}
		if (saves) then
			for name, sdata in keyPairs(saves) do
				tinsert(items, name)
			end
		end
		return items
	end, "")
	gui.saves.select:SetParent(gui.saves)
	gui.saves.select:SetScale(0.999)
	gui.saves.select:SetScale(1.0)
	gui.saves.select:SetPoint("RIGHT", gui.saves.name, "RIGHT", 38,-4)
	gui.saves.select:SetInputHidden(true)

	gui.saves.load = CreateFrame("Button", nil, gui.saves, "OptionsButtonTemplate")
	gui.saves.load:SetPoint("LEFT", gui.saves.name, "RIGHT", 25, 0)
	gui.saves.load:SetWidth(70)
	gui.saves.load:SetHeight(20)
	gui.saves.load:SetText("Load")
	gui.saves.load:SetScript("OnClick", function() lib.LoadSearch() end)

	gui.saves.save = CreateFrame("Button", nil, gui.saves, "OptionsButtonTemplate")
	gui.saves.save:SetPoint("LEFT", gui.saves.load, "RIGHT", 5, 0)
	gui.saves.save:SetWidth(70)
	gui.saves.save:SetHeight(20)
	gui.saves.save:SetText("Save")
	gui.saves.save:SetScript("OnClick", function() lib.SaveSearch() end)

	gui.saves.delete = CreateFrame("Button", nil, gui.saves, "OptionsButtonTemplate")
	gui.saves.delete:SetPoint("LEFT", gui.saves.save, "RIGHT", 5, 0)
	gui.saves.delete:SetWidth(70)
	gui.saves.delete:SetHeight(20)
	gui.saves.delete:SetText("Delete")
	gui.saves.delete:SetScript("OnClick", function() lib.DeleteSearch() end)

	gui.saves.reset = CreateFrame("Button", nil, gui.saves, "OptionsButtonTemplate")
	gui.saves.reset:SetPoint("LEFT", gui.saves.delete, "RIGHT", 10, 0)
	gui.saves.reset:SetWidth(70)
	gui.saves.reset:SetHeight(20)
	gui.saves.reset:SetText("Reset")
	gui.saves.reset:SetScript("OnClick", function()
		if IsShiftKeyDown() and IsControlKeyDown() and IsAltKeyDown() then
			lib.ResetSearch()
			aucPrint("All searchUI settings have been reset.")
		else
			aucPrint("This resets all searchUI settings, you must hold CTRL + SHIFT + ALT when clicking this button")
		end
	end)

	function lib.UpdateControls()
		if gui.sheet.selected then
			gui.frame.ignore:Enable()
			gui.frame.ignoreperm:Enable()
			gui.frame.notnow:Enable()
			gui.frame.snatch:Enable()
		else
			gui.frame.ignore:Disable()
			gui.frame.ignoreperm:Disable()
			gui.frame.notnow:Disable()
			gui.frame.snatch:Disable()
		end
		if selected ~= gui.sheet.selected then
			selected = gui.sheet.selected
			local data = gui.sheet:GetSelection()
			if not data then
				empty(private.data)
			else
				private.data.link = data[1]
				private.data.seller = data[8]
				private.data.stack = data[4]
				private.data.bid = data[6]
				private.data.minbid = data[12]
				private.data.curbid = data[13]
				private.data.buyout = data[5]
				private.data.reason = data[7]
			end
			if private.data.buyout and (private.data.buyout > 0) then
				gui.frame.buyout:Enable()
				gui.frame.buyoutbox:SetText(AucAdvanced.Coins(private.data.buyout, true))
			else
				gui.frame.buyout:Disable()
				gui.frame.buyoutbox:SetText(AucAdvanced.Coins(0, true))
			end
			gui.frame.bid.ClearBid() -- reset bid box to force following UpdateEnable to recalculate it
		end
		gui.frame.bid.UpdateEnable()
		gui.frame.purchase.updateEnable()
	end

	function lib.OnEnterSheet(button, row, index)
		if gui.sheet.rows[row][index]:IsShown() then --Hide tooltip for hidden cells
			local link = gui.sheet.rows[row][index]:GetText()
			local linkType = link and strmatch(link, "|H(%l+):%d")
			if linkType then
				local count
				if gui.sheet.order then
					for i, label in pairs(gui.sheet.labels) do
						if  label:GetText() == "Stk" then --need to localize this when we localize the rest of searchUI
							count = tonumber(gui.sheet.rows[row][i]:GetText())
							break
						end
					end
				else
					count = tonumber(gui.sheet.rows[row][4]:GetText() )
				end

				if linkType == "item" then
					GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
					AucAdvanced.ShowItemLink(GameTooltip, link, count)
				elseif linkType == "battlepet" then
					AucAdvanced.ShowPetLink(BattlePetTooltip, link, count)
					BattlePetTooltip:ClearAllPoints()
					BattlePetTooltip:SetPoint("BOTTOMLEFT", button, "TOPRIGHT")
				end
			end
		end
	end

	function lib.OnClickSheet(button, row, index)
		index = index - (index%15-1)
		if IsShiftKeyDown() then --Add the item link to chat
			local link = gui.sheet.rows[row][index]:GetText()
			if not link then
				return
			end
			ChatEdit_InsertLink(link)
		elseif IsAltKeyDown() then --Search for the item in browse tab.
			local link = gui.sheet.rows[row][index]:GetText()
			if not link then
				return
			end
			local itemName
			local header, id = strsplit(":", link)
			if header:sub(-9) == "battlepet" then
				id = tonumber(id)
				if id then
					itemName = C_PetJournal.GetPetInfoBySpeciesID(id)
				end
			else
				itemName = GetItemInfo(link)
			end
			if not itemName then
				return
			end
			AuctionFrameBrowse_Reset(BrowseResetButton)
			AuctionFrameBrowse.page = 0
			BrowseName:SetText(itemName)
			AuctionFrameBrowse_Search()
		end
	end
	--records the column width changes
	--store width by header name, that way if column reorginizing is added we apply size to proper column
	function private.OnResizeSheet(self, column, width)
		if not width then
			lib.SetSetting("columnwidth."..self.labels[column]:GetText(), "default") --reset column if no width is passed. We use CTRL+rightclick to reset column
			self.labels[column].button:SetWidth(lib.GetSetting("columnwidth."..self.labels[column]:GetText()))
		else
			lib.SetSetting("columnwidth."..self.labels[column]:GetText(), width)
		end
	end

	gui.sheet = ScrollSheet:Create(gui.frame, {
		{ "Item",   "TOOLTIP", lib.GetSetting("columnwidth.Item") }, --120
		{ "Pct",    "INT", lib.GetSetting("columnwidth.Pct")   }, --30
		{ "Profit", "COIN", lib.GetSetting("columnwidth.Profit") , { DESCENDING=true } }, --85
		{ "Stk",    "INT",  lib.GetSetting("columnwidth.Stk")  }, --30
		{ "Buyout", "COIN", lib.GetSetting("columnwidth.Buyout"), { DESCENDING=true } }, --85
		{ "Bid",    "COIN", lib.GetSetting("columnwidth.Bid"), { DESCENDING=true } }, --85
		{ "Reason", "TEXT", lib.GetSetting("columnwidth.Reason")  }, --85
		{ "Seller", "TEXT", lib.GetSetting("columnwidth.Seller")  }, --75
		{ "Left",   "TEXT", lib.GetSetting("columnwidth.Left")  }, --40
		{ "Buy/ea", "COIN", lib.GetSetting("columnwidth.Buy/ea"), { DESCENDING=true, DEFAULT=true } }, --85
		{ "Bid/ea", "COIN", lib.GetSetting("columnwidth.Bid/ea"), { DESCENDING=true, DEFAULT=true } }, --85
		{ "MinBid", "COIN", lib.GetSetting("columnwidth.MinBid"), { DESCENDING=true } }, --85
		{ "CurBid", "COIN", lib.GetSetting("columnwidth.CurBid"), { DESCENDING=true } }, --85
		{ "Min/ea", "COIN", lib.GetSetting("columnwidth.Min/ea"), { DESCENDING=true } }, --85
		{ "Cur/ea", "COIN", lib.GetSetting("columnwidth.Cur/ea"), { DESCENDING=true } }, --85
	})
	gui.sheet:EnableSelect(true)
	gui.sheet:EnableVerticalScrollReset(false) --tells scrollframes we do NOT want to reset position when rendering a new data table

	--If we have a saved order reapply
	if lib.GetSetting("columnorder") then
		--aucPrint("saved order applied")
		gui.sheet:SetOrder(lib.GetSetting("columnorder") )
	end
	--Apply last column sort used
	if lib.GetSetting("columnsortcurSort") then
		gui.sheet.curSort = lib.GetSetting("columnsortcurSort") or 1
		gui.sheet.curDir = lib.GetSetting("columnsortcurDir") or 1
		gui.sheet:PerformSort()
	end
	--After we have finished creating the scrollsheet and all saved settings have been applied set our event processor
	function gui.sheet.Processor(callback, self, button, column, row, order, curDir, ...)
		if (callback == "ColumnOrder") then
			lib.SetSetting("columnorder", order)
		elseif (callback == "ColumnWidthSet") then
			private.OnResizeSheet(self, column, button:GetWidth() )
		elseif (callback == "ColumnWidthReset") then
			private.onResize(self, column, nil)
		elseif (callback == "OnEnterCell")  then
			lib.OnEnterSheet(button, row, column)
		elseif (callback == "OnLeaveCell") then
			GameTooltip:Hide()
			if BattlePetTooltip then
				BattlePetTooltip:Hide()
			end
		elseif (callback == "OnClickCell") then
			lib.OnClickSheet(button, row, column)
		elseif (callback == "ColumnSort") then
			-- ColumnSort notifies that data has been sorted, which occurs very frequently
			-- Here we only want to detect changes to sort column or direction
			-- SetSetting exits early if the setting has not actually changed, so there shouldn't be a problem with notification message spam
			lib.SetSetting("columnsortcurDir", curDir)
			lib.SetSetting("columnsortcurSort", column)
		elseif (callback == "OnMouseDownCell") then
			lib.UpdateControls()
		end
	end

	gui.Search = CreateFrame("Button", "AucSearchUISearchButton", gui, "OptionsButtonTemplate")
	gui.Search:SetPoint("BOTTOMLEFT", gui, "BOTTOMLEFT", 30, 80)
	gui.Search:SetText("Search")
	gui.Search:SetScript("OnClick", function() lib.PerformSearch() end)
	gui.Search:SetFrameLevel(11)
	gui.Search.TooltipText = "Search Snapshot using current Searcher"
	gui.Search:SetScript("OnEnter", showTooltipText)
	gui.Search:SetScript("OnLeave", hideTooltip)
	gui.Search:Disable()
	gui.Search.updateDisplay = function()
		if gui.config.selectedCat == "Searchers" then
			gui.Search:Enable()
			--Check if rescan method is implemented
			local searcher = private.FindSearcher() -- find Selected searcher
			if searcher.Rescan then
				gui.Rescan.searcher = searcher
				gui.Rescan:Show()
			else
				gui.Rescan.searcher = nil
				gui.Rescan:Hide()
			end
		else
			gui.Search:Disable()
			gui.Rescan.searcher = nil
			gui.Rescan:Hide()
		end
	end

	--rescan AH button.
	gui.Rescan = CreateFrame("Button", "AucSearchUIRescanButton", gui, "UIPanelCloseButton")
	gui.Rescan:Show()
	gui.Rescan:SetWidth(20)
	gui.Rescan:SetHeight(20)
	gui.Rescan:SetNormalTexture("Interface\\ICONS\\Ability_Creature_Cursed_04")
	gui.Rescan:SetPoint("LEFT", gui.Search, "RIGHT", 5, 0)
	gui.Rescan:Hide()
	gui.Rescan.TooltipText = "Refresh the Auction House snapshot, then search\nClick again to cancel"
	gui.Rescan:SetScript("OnEnter", showTooltipText)
	gui.Rescan:SetScript("OnLeave", hideTooltip)
	--animation (using cooldown frame. ### todo: use one of the animation widgets instead?)
	gui.Rescan.frame = CreateFrame("Cooldown", nil, gui.Rescan, "CooldownFrameTemplate")
	gui.Rescan.frame:SetAllPoints(gui.Rescan)
	gui.Rescan:SetScript("OnClick", function(self)
		if flagRescan then
			flagRescan = nil
			CooldownFrame_Set(self.frame, 0, 0, false)
			gui.Search:Enable()
			lib.PerformSearch()
		elseif self.searcher then
			self.searcher.Rescan()
			local gt = GetTime()
			CooldownFrame_Set(self.frame, gt, 2, true)
			gui.Search:Disable()
			flagRescan = gt + 2.5 -- time to trigger next animation
		end
	end)


	gui:AddCat("Welcome")

	id = gui:AddTab("About")
	gui.aboutTab = id
	gui:MakeScrollable(id)
	gui:AddControl(id, "Subhead",    0,    "About the SearchUI")

	gui:AddCat("Searchers", nil, nil, true)
	gui:AddCat("Filters")

	gui:AddCat("Options")
	id = gui:AddTab("General Options", "Options")
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",           0,    "Setup general options")
	gui:AddControl(id, "WideSlider",       0, 1, "processpriority", 10, 100, 10, "Search process priority: %s")
	gui:AddControl(id, "Subhead",          0,    "Purchase Settings")
	gui:AddControl(id, "Checkbox",         0, 1, "reserve.enable", "Enable reserve amount:")
	gui:AddControl(id, "MoneyFramePinned", 0, 2, "reserve", 0, Const.MAXBIDPRICE, "Reserve Amount")
	gui:AddTip(id, "Sets the amount that you don't want your cash-on-hand to fall below")
	gui:AddControl(id, "Checkbox",         0, 1, "maxprice.enable", "Enable maximum price:")
	gui:AddControl(id, "MoneyFramePinned", 0, 2, "maxprice", 1, Const.MAXBIDPRICE, "Maximum Price")
	gui:AddTip(id, "Sets the amount that you don't want to spend more than")

	id = gui:AddTab("Global Settings", "Options")
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",           0,    "Setup global options")

	gui:AddControl(id, "Subhead",          0,    "Integration")
	gui:AddControl(id, "Checkbox",          0, 1, "global.createtab", "Create tab in auction house (requires restart)")

	gui:AddControl(id, "Subhead", 0, "Experimental settings")
	gui:AddControl(id, "Checkbox", 0, 1, "global.memorycleanup", "Additional memory cleanup while searching")

	gui:AddControl(id, "Checkbox", 0, 1, "global.fast_remove_mode", "Do not remove items from list after bid/buy (to speed up operations for very large lists)")

	gui:AddControl(id, "Subhead",          0,    "Tooltip")
	gui:AddControl(id, "Checkbox",          0, 1, "tooltiphelp.show", "Show tooltip help over buttons")
	gui:AddControl(id, "Checkbox",         0, 1, "debug.show", "Show debug line in tooltip for auctions")
	for name, searcher in pairs(lib.Searchers) do
		if searcher and searcher.Search then
			gui:AddControl(id, "Checkbox",  0, 2, "debug."..name, "Show debug for "..name)
			gui:AddTip(id, "Show a debug line in the tooltip over auctions for searcher: "..name)
		end
	end

	gui.frame.purchase = CreateFrame("Button", nil, gui.frame, "OptionsButtonTemplate")
	gui.frame.purchase:SetPoint("BOTTOMLEFT", gui, "BOTTOMLEFT", 170, 35)
	gui.frame.purchase:SetText("Purchase")
	gui.frame.purchase:SetScript("OnClick", private.purchase)
	gui.frame.purchase:Disable()
	gui.frame.purchase.TooltipText = "Bid/BuyOut selected auction\nbased on 'reason' column. \nHold CTRL+ALT+SHIFT to purchase all items."
	gui.frame.purchase:SetScript("OnEnter", showTooltipText)
	gui.frame.purchase:SetScript("OnLeave", hideTooltip)
	gui.frame.purchase.toggleAll = false
	gui.frame.purchase.updateEnable = function()
		if gui.frame.purchase.toggleAll then
			if gui.sheet.sort[1] then
				gui.frame.purchase:Enable()
			else
				gui.frame.purchase:Disable()
			end
		else
			if gui.frame.bid.CanBid() or gui.frame.buyout:IsEnabled() then
				gui.frame.purchase:Enable()
			else
				gui.frame.purchase:Disable()
			end
		end
	end
	gui.frame.purchase.updateDisplay = function()
		local all = IsShiftKeyDown() and IsControlKeyDown() and IsAltKeyDown()
		if all ~= gui.frame.purchase.toggleAll then
			gui.frame.purchase.toggleAll = all
			if all then
				gui.frame.purchase:SetText("Purchase All")
				gui.frame.purchase:SetScript("OnClick", private.purchaseall)
			else
				gui.frame.purchase:SetText("Purchase")
				gui.frame.purchase:SetScript("OnClick", private.purchase)
			end
		end
		gui.frame.purchase.updateEnable()
	end

	gui.frame.notnow = CreateFrame("Button", nil, gui.frame, "OptionsButtonTemplate")
	gui.frame.notnow:SetPoint("TOP", gui.frame.purchase, "BOTTOM", 0, -2)
	gui.frame.notnow:SetText("Not Now")
	gui.frame.notnow:SetScript("OnClick", private.ignoretemp)
	gui.frame.notnow:Disable()
	gui.frame.notnow.TooltipText = "Ignore selected auction for session"
	gui.frame.notnow:SetScript("OnEnter", showTooltipText)
	gui.frame.notnow:SetScript("OnLeave", hideTooltip)

	gui.frame.ignore = CreateFrame("Button", nil, gui.frame, "OptionsButtonTemplate")
	gui.frame.ignore:SetPoint("LEFT", gui.frame.purchase, "RIGHT", 280, 0)
	gui.frame.ignore:SetText("Ignore Price")
	gui.frame.ignore:SetScript("OnClick", private.ignore)
	gui.frame.ignore:Disable()
	gui.frame.ignore.TooltipText = "Ignore selected auction at listed price"
	gui.frame.ignore:SetScript("OnEnter", showTooltipText)
	gui.frame.ignore:SetScript("OnLeave", hideTooltip)

	gui.frame.ignoreperm = CreateFrame("Button", nil, gui.frame, "OptionsButtonTemplate")
	gui.frame.ignoreperm:SetPoint("TOP", gui.frame.ignore, "BOTTOM",0 , -2)
	gui.frame.ignoreperm:SetText("Ignore")
	gui.frame.ignoreperm:SetScript("OnClick", private.ignoreperm)
	gui.frame.ignoreperm:Disable()
	gui.frame.ignoreperm.TooltipText = "Ignore selected auction at any price"
	gui.frame.ignoreperm:SetScript("OnEnter", showTooltipText)
	gui.frame.ignoreperm:SetScript("OnLeave", hideTooltip)

	gui.frame.snatch = CreateFrame("Button", nil, gui.frame, "OptionsButtonTemplate")
	gui.frame.snatch:SetPoint("BOTTOMLEFT", gui, "BOTTOMLEFT", 630, 35)
	gui.frame.snatch:SetText("Snatch")
	gui.frame.snatch:SetScript("OnClick", private.snatch)
	gui.frame.snatch:Disable()
	gui.frame.snatch.TooltipText = "Add selected auction to snatch list"
	gui.frame.snatch:SetScript("OnEnter", showTooltipText)
	gui.frame.snatch:SetScript("OnLeave", hideTooltip)

	gui.frame.clear = CreateFrame("Button", nil, gui.frame, "OptionsButtonTemplate")
	gui.frame.clear:SetPoint("TOP", gui.Search, "BOTTOM", 0, -5)
	gui.frame.clear:SetText("Clear")
	gui.frame.clear:SetScript("OnClick", private.removeall)
	gui.frame.clear:Enable()
	gui.frame.clear.TooltipText = "Clear results list"
	gui.frame.clear:SetScript("OnEnter", showTooltipText)
	gui.frame.clear:SetScript("OnLeave", hideTooltip)

	gui.frame.cancel = CreateFrame("Button", "AucAdvSearchUICancelButton", gui.frame, "OptionsButtonTemplate")
	gui.frame.cancel:SetPoint("BOTTOMLEFT", gui, "BOTTOMLEFT", 30, 30)
	gui.frame.cancel:SetWidth(22)
	gui.frame.cancel:SetHeight(18)
	gui.frame.cancel:Disable()
	gui.frame.cancel:SetScript("OnClick", function()
		AucAdvanced.Buy.CancelBuyQueue(true)
		gui.frame.cancel.value = 0
	end)
	gui.frame.cancel.value = 0
	private.UpdateBuyQueue = function ()
		local queuelen, queuecost, prompt, promptcost = AucAdvanced.Buy.GetQueueStatus()
		if prompt then
			queuelen = queuelen + 1
			queuecost = queuecost + promptcost
		end
		if queuelen > 0 then
			gui.frame.cancel.label:SetText(tostring(queuelen)..": "..AucAdvanced.Coins(queuecost, true))
			gui.frame.cancel.value = queuecost
			gui.frame.cancel:Enable()
			gui.frame.cancel.tex:SetVertexColor(1.0, 0.9, 0.1)
		else
			gui.frame.cancel.label:SetText("")
			gui.frame.cancel.value = 0
			gui.frame.cancel:Disable()
			gui.frame.cancel.tex:SetVertexColor(0.3, 0.3, 0.3)
		end
	end
	gui.frame.cancel.tex = gui.frame.cancel:CreateTexture(nil, "OVERLAY")
	gui.frame.cancel.tex:SetPoint("TOPLEFT", gui.frame.cancel, "TOPLEFT", 4, -2)
	gui.frame.cancel.tex:SetPoint("BOTTOMRIGHT", gui.frame.cancel, "BOTTOMRIGHT", -4, 2)
	gui.frame.cancel.tex:SetTexture("Interface\\Addons\\Auc-Advanced\\Textures\\NavButtons")
	gui.frame.cancel.tex:SetTexCoord(0.25, 0.5, 0, 1)
	gui.frame.cancel.tex:SetVertexColor(0.3, 0.3, 0.3)
	gui.frame.cancel.label = gui.frame.cancel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	gui.frame.cancel.label:SetPoint("LEFT", gui.frame.cancel, "RIGHT", 5, 0)
	gui.frame.cancel.label:SetTextColor(1, 0.8, 0)
	gui.frame.cancel.label:SetText("")
	gui.frame.cancel.label:SetJustifyH("LEFT")

	gui.frame.buyout = CreateFrame("Button", nil, gui.frame, "OptionsButtonTemplate")
	gui.frame.buyout:SetPoint("LEFT", gui.frame.notnow, "RIGHT", 5, 0)
	gui.frame.buyout:SetText("Buyout")
	gui.frame.buyout:SetScript("OnClick", private.buyauction)
	gui.frame.buyout:Disable()
	gui.frame.buyout.TooltipText = "Buyout selected auction"
	gui.frame.buyout:SetScript("OnEnter", showTooltipText)
	gui.frame.buyout:SetScript("OnLeave", hideTooltip)

	gui.frame.buyoutbox = gui.frame.buyout:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	gui.frame.buyoutbox:SetPoint("LEFT", gui.frame.buyout, "RIGHT", 0, 0)
	gui.frame.buyoutbox:SetWidth(100)

	do -- bid button and bid box
		local bidbutton = CreateFrame("Button", nil, gui.frame, "OptionsButtonTemplate")
		gui.frame.bid = bidbutton
		bidbutton:SetPoint("LEFT", gui.frame.purchase, "RIGHT", 5, 0)
		local bidbox = CreateFrame("Frame", "AucAdvSearchUIBidBox", gui.frame, "MoneyInputFrameTemplate")
		gui.frame.bidbox = bidbox
		bidbox:SetPoint("LEFT", bidbutton, "RIGHT", 10, 2)

		bidbutton:SetText("Bid")
		bidbutton:Disable()
		bidbutton.TooltipText = "Bid on selected auction using custom price\nAlt click to reset bid price to default value"
		bidbutton:SetScript("OnEnter", showTooltipText)
		bidbutton:SetScript("OnLeave", hideTooltip)
		bidbutton:SetScript("OnClick", function(self)
			if self.toggleReset then
				MoneyInputFrame_SetCopper(bidbox, private.data.bid) -- will trigger UpdateEnable via OnValueChangedFunc
			else
				private.bidauction()
			end
		end)
		MoneyInputFrame_SetCopper(bidbox, 0)
		bidbox:Hide()

		-- functions controlling status of bid button and bidbox (attached to gui.frame.bid)
		bidbutton.ClearBid = function()
			bidbutton.itemCanBid = nil
			bidbutton:Disable()
			bidbox:Hide()
			MoneyInputFrame_SetCopper(bidbox, 0)
			-- Purchase button needs to be updated whenever itemCanBid changes
			gui.frame.purchase.updateEnable()
		end
		bidbutton.CanBid = function()
			return bidbutton.itemCanBid
		end
		bidbutton.UpdateEnable = function()
			local price = private.data.bid
			local buyout = private.data.buyout

			if not (price and buyout) or (buyout > 0 and price >= buyout) then
				-- no item selected, or only possible to 'buyout' item
				if bidbutton.itemCanBid then
					bidbutton.ClearBid()
				end
				return
			end

			if not bidbutton.itemCanBid then
				bidbutton.itemCanBid = true
				bidbox:Show()
				-- Purchase button needs to be updated whenever itemCanBid changes
				gui.frame.purchase.updateEnable()
			end
			local curbid = MoneyInputFrame_GetCopper(bidbox)
			if curbid == 0 then -- flagged to be (re)set to default bid price
				curbid = price
				-- will trigger another call to UpdateEnable, but only after the current execution thread has finished
				MoneyInputFrame_SetCopper(bidbox, curbid)
			end

			if bidbutton.toggleReset then -- in 'Reset Bid' mode
				if curbid ~= price then
					bidbutton:Enable()
				else
					bidbutton:Disable()
				end
			else
				if curbid < price or (buyout > 0 and curbid >= buyout) then
					bidbutton:Disable()
				else
					bidbutton:Enable()
				end
			end
		end
		bidbutton.UpdateDisplay = function()
			local reset = IsAltKeyDown() and not IsShiftKeyDown() and not IsControlKeyDown()
			if reset ~= bidbutton.toggleReset then
				bidbutton.toggleReset = reset
				if reset then
					bidbutton:SetText("Reset Bid")
				else
					bidbutton:SetText("Bid")
				end
				bidbutton.UpdateEnable()
			end
		end

		MoneyInputFrame_SetOnValueChangedFunc(bidbox, bidbutton.UpdateEnable)
	end -- of bid button/box cluster

	gui.frame.progressbar = CreateFrame("STATUSBAR", nil, gui.frame, "TextStatusBar")
	gui.frame.progressbar:SetWidth(400)
	gui.frame.progressbar:SetHeight(30)
	gui.frame.progressbar:SetPoint("BOTTOM", gui.frame, "BOTTOM", 0, 100)
	gui.frame.progressbar:SetBackdrop({
	  bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
	  edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
	  tile=1, tileSize=10, edgeSize=10,
	  insets={left=3, right=3, top=3, bottom=3}
	})
	gui.frame.progressbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	gui.frame.progressbar:SetStatusBarColor(0.6, 0, 0, 0.4)
	gui.frame.progressbar:SetMinMaxValues(0, 1000)
	gui.frame.progressbar:SetValue(0)
	gui.frame.progressbar:SetFrameLevel(10)
	gui.frame.progressbar:Hide()

	gui.frame.progressbar.text = gui.frame.progressbar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	gui.frame.progressbar.text:SetPoint("CENTER", gui.frame.progressbar, "CENTER")
	gui.frame.progressbar.text:SetText("AucAdv SearchUI: Searching")
	gui.frame.progressbar.text:SetTextColor(1,1,1)

	gui.frame.progressbar.cancel = CreateFrame("Button", nil, gui.frame.progressbar, "OptionsButtonTemplate")
	gui.frame.progressbar.cancel:SetPoint("BOTTOMRIGHT", gui.frame.progressbar, "BOTTOMRIGHT", -5, 5)
	gui.frame.progressbar.cancel:SetPoint("TOPLEFT", gui.frame.progressbar, "TOPRIGHT", -25, -5)
	gui.frame.progressbar.cancel:SetText("X")
	gui.frame.progressbar.cancel:SetScript("OnClick", private.cancelSearch)


	Stubby.RegisterEventHook("MODIFIER_STATE_CHANGED", "Auc-Util-SearchUI", function ()
		if gui.frame:IsVisible() then
			gui.frame.purchase.updateDisplay()
			gui.frame.bid.UpdateDisplay()
		end
	end)

	-- Alert our searchers?
	for name, searcher in pairs(lib.Searchers) do
		if searcher.MakeGuiConfig then
			searcher:MakeGuiConfig(gui)
		end
	end
	--Alert our Filters
	for name, filter in pairs(lib.Filters) do
		if filter.MakeGuiConfig then
			filter:MakeGuiConfig(gui)
		end
	end

	lib.NotifyCallbacks('guiconfig', gui)

	-- Add the welcome text now
	local b = "  |TInterface\\QuestFrame\\UI-Quest-BulletPoint.blp:13|t "
	local w = ""
	w=w.."The Auctioneer Search UI is here to assist you in finding the Auctions that are of special interest to you.\n"
	w=w.."\n"
	w=w.."It has 2 modes of operation:\n"
	w=w..b.."Offline - Searches are applied against the current data\n"
	w=w..b.."Realtime - Searches are applied against the realtime scans of the AH\n"
	w=w.."\n"
	w=w.."There are also 2 types of searching modules that exist in the Search UI:\n"
	w=w..b.."Searchers - Searches for a specific set of criteria, only 1 searcher is active at once\n"
	w=w..b.."Filters - All filters always apply their criteria, excluding non-matching items from the search.\n"
	w=w.."\n"
	w=w.."In order to begin using the Search UI, you should first setup your filters to exclude the items you don't wish to find, then select a searcher to perform a search.\n"
	w=w.."\n"
	w=w.."Here's a quick list of the searchers and filters that you may wish to investigate:\n"
	for pos, sdata in keyPairs(gui.searchers) do
		for searchType, searchDetail in keyPairs(sdata) do
			w=w..b.."|cffffce00"..searchType.."|r - "..searchDetail.."\n"
		end
	end

	gui:AddControl(gui.aboutTab, "Note", 0, 1, nil, nil, w)
	gui:ActivateTab(gui.aboutTab)
end

if LibStub then
	--Need to figure out if we're embedded first
	local embedded = false
	for _, module in ipairs(AucAdvanced.EmbeddedModules) do
		if module == "Auc-Util-SearchUI"  then
			embedded = true
		end
	end
	local sideIcon
	if embedded then
		sideIcon = "Interface\\AddOns\\Auc-Advanced\\Modules\\Auc-Util-SearchUI\\Textures\\SearchUIIcon"
	else
		sideIcon = "Interface\\AddOns\\Auc-Util-SearchUI\\Textures\\SearchUIIcon"
	end

	local LibDataBroker = LibStub:GetLibrary("LibDataBroker-1.1", true)
	if LibDataBroker then
		private.LDBButton = LibDataBroker:NewDataObject("Auc-Util-SearchUI", {
					type = "launcher",
					icon = sideIcon,
					OnClick = function(self, button) lib.Toggle(self, button) end,
				})

		function private.LDBButton:OnTooltipShow()
			self:AddLine("Auction SearchUI",  1,1,0.5, 1)
			self:AddLine("Allows you to perform searches on the Auctioneer auction cache snapshot, even when away from the Auction House",  1,1,0.5, 1)
			self:AddLine("|cff1fb3ff".."Click|r to open the Search UI.",  1,1,0.5, 1)
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

function private.FindSearcher(item)
	local selected
	if item then -- item may be either the searcher's lib or its name
		local searcher = lib.Searchers[item]
		if searcher then -- item is the searcher name
			if searcher.Search then
				return searcher, item
			end
			return -- we found a match, but it's not a valid searcher
		end
		-- otherwise item should be the lib table
	else -- no item, default to finding current selected searcher
		selected = gui and gui.config.selectedTab
	end
	if not item and not selected then return end
	for name, searcher in pairs(lib.Searchers) do
		if searcher == item or (selected and searcher.tabname == selected) then
			if searcher.Search then
				return searcher, name
			end
			return -- we found a match, but it's not a valid searcher
		end
	end
end

function private.cancelSearch()
	private.SearchCancel = true
end

--lib.SearchItem(searcherName, item, nodupes)
--purpose: handles sending the item to the specified searcher, and if necessary, adds it to the SearchUI results
--nodupes is boolean flag.  If true, no duplicate checking is done.  This flag is true for searching from the cache, but false for realtime.
--skipresults is boolean flag, If true, nothing gets added to the results list
--returns true, value, profit when successful
--returns false, reason when not
function lib.SearchItem(searcherName, item, nodupes, skipresults)
	if not searcherName or not item or #item == 0 then
		return
	end
	if item[Const.SELLER] == UnitName("player") then
		return false, "Blocked: Can't buy own auction"
	end
	local searcher = lib.Searchers[searcherName]
	if not searcher then
		return
	end
	local debugstring

	--next, pass the item through the filters
	local isfiltered = false
	for filtername, filter in pairs(lib.Filters) do
		if filter.Filter then
			local dofilter, filterreturn = filter.Filter(item, searcherName)
			if dofilter then
				return false, "Filter:"..filtername..": "..tostring(filterreturn)
			end
		end
	end

	--buyorbid must be either "bid", "buy", true, false, or nil
	--if string is returned for buyorbid, value must be number or nil (in which case value will be Marketprice)
	local buyorbid, value, pct, reason = searcher.Search(item)
	if buyorbid then
		--give the filters a second chance to filter out, based on bid/buy differences
		for filtername, filter in pairs(lib.Filters) do
			if filter.PostFilter then
				local dofilter, filterreturn = filter.PostFilter(item, searcherName, buyorbid)
				if dofilter then
					return false, "Filtered by "..filtername..": "..filterreturn
				end
			end
		end

		local cost
		if type(buyorbid) == "string" then
			if reason then
				item["reason"] = reason..":"..buyorbid
			else
				item["reason"] = searcher.tabname..":"..buyorbid
			end
			if buyorbid == "bid" then
				--don't show result if we're already the highest bidder
				if item[Const.AMHIGH] then
					return false, "Bid blocked: Already high bidder"
				end
				cost = item[Const.PRICE]
			else
				cost = item[Const.BUYOUT]
			end
		else --the searcher only returned that it matches the criteria, so assume buyout if possible.
			item["reason"] = reason or searcher.tabname
			if item[Const.BUYOUT] and item[Const.BUYOUT] > 0 then
				cost = item[Const.BUYOUT]
			elseif item[Const.PRICE] and item[Const.PRICE] > 0 then
				cost = item[Const.PRICE]
				if item[Const.AMHIGH] then
					return false, "Bid blocked: Already high bidder"
				end
			end
		end
		if not value then
			local market = AucAdvanced.API.GetMarketValue(item[Const.LINK])
			if market then -- needs a nil check
				value = item[Const.COUNT]*market
			end
		end
		if not value then
			value = 0
		end
		if not cost then
			return false, "Bid blocked: No valid price possible"
		end
		item["profit"] = value - cost
		local enablemax = lib.GetSetting("maxprice.enable")
		local maxprice = lib.GetSetting("maxprice") or 10000000
		local enableres = lib.GetSetting("reserve.enable")
		local reserve = lib.GetSetting("reserve") or 1
		local bidqueue = gui.frame.cancel.value or 0

		local balance = GetMoney()
		balance = balance - bidqueue --account for money we've already "spent"

		if (cost <= maxprice or not enablemax) and ((balance-cost) > reserve or not enableres) then
			--Check to see whether the item already exists in the results table
			local isdupe = false
			if not nodupes then

				if not private.sheetData then
					private.sheetData = {}
					private.sheetStyle = {}
				end
				for j,k in pairs(private.sheetData) do
					if (k[1] == item[Const.LINK]) and (k[7] == item["reason"]) then
						isdupe = true
					end
				end

			end
			if nodupes or (not isdupe) then
				local level, _, r, g, b
				pct = tonumber(pct) --make sure its not a string
				if not pct and AucAdvanced.Modules.Util.PriceLevel then
					local valueper
					if value and value > 0 then
						valueper = value/item[Const.COUNT]
					end
					if buyorbid == "bid" then
						level, _, r, g, b = AucAdvanced.Modules.Util.PriceLevel.CalcLevel(item[Const.LINK], item[Const.COUNT], item[Const.PRICE], item[Const.PRICE], valueper)
					else
						level, _, r, g, b = AucAdvanced.Modules.Util.PriceLevel.CalcLevel(item[Const.LINK], item[Const.COUNT], item[Const.PRICE], item[Const.BUYOUT], valueper)
					end
					if not r or not b or not g then
					--aucPrint("price level failure in searchUI")
					--aucPrint(r,g,b, item[Const.LINK], item[Const.COUNT], item[Const.PRICE], item[Const.BUYOUT], valueper)
					r,g,b = 1,1,1
					end
					local total = #private.sheetData+1
					private.sheetStyle[total] = {}
					private.sheetStyle[total][2] = {["textColor"] = {r, g, b}}
					private.sheetStyle[total][1] = {["rowColor"] = {r, g, b, 0, 0.2, "Horizontal"}} --allow row coloring, needs config options
					level = level or 0
					pct = floor(level)
				end
				item["pct"] = pct
				item["cost"] = cost
				local count = item[Const.COUNT] or 1
				local min = item[Const.MINBID] or 0
				local cur = item[Const.CURBID] or 0
				local buy = item[Const.BUYOUT] or 0
				local price = item[Const.PRICE] or 0
				if not skipresults then
					tinsert(private.sheetData, {
						item[Const.LINK],
						item["pct"],
						item["profit"],
						count,
						buy,
						price,
						item["reason"],
						item[Const.SELLER],
						private.tleft[item[Const.TLEFT]],
						buy/count,
						price/count,
						min,
						cur,
						min/count,
						cur/count
					})
				end
				return true, item["profit"], value
			end
		elseif cost > maxprice and enablemax then
			return false, "Price higher than maxprice"
		else
			return false, "Balance lower than reserve"
		end
	end
	return false, value
end

local PerformSearch = function(item)
	local searcher, searcherName = private.FindSearcher(item) -- if item provided, use it to find seacher
	if not searcher and item then
		-- we tried using item but got no result, it must be invalid, try again without it
		searcher, searcherName = private.FindSearcher()
	end
	if not searcher then
		aucPrint("No valid Searches selected")
		return
	end

	private.SearchCancel = nil
	if gui.tabs.active then
		gui:ContractFrame(gui.tabs.active)
	end
	gui:ClearFocus()
	private.removeall() --clear the results table
	gui.frame.progressbar.text:SetText("AucAdv SearchUI: Searching |cffffcc19"..gui.config.selectedTab)
	gui.frame.progressbar:SetValue(0)
	gui.frame.progressbar:Show()
	coroutine.yield() -- allow progress bar to be displayed

	local memorycleanup = lib.GetSetting("global.memorycleanup")
	if memorycleanup then
		collectgarbage()
		coroutine.yield()
	end

	local image = AucAdvanced.Scan.GetImageCopy() --GetImageCopy provides a table that can be used in coroutines
	local imagesize = #image
	coroutine.yield() -- GetImageCopy can take some time, so allow a frame update just after

	--[[ processing timer using debugprofilestop:
	we do not call debugprofilestart, instead we check the difference between two calls to debugprofilestop
	this should make it safer if another process actually wants to use debugprofilestart/stop for profiling

	we must not attempt to time across a yield using this method, as during that yield another AddOn could call debugprofilestart
	however GetTime *does* work across yields
	--]]
	local processingTime = 90 * (lib.GetSetting("processpriority")/100)^2 + 10 -- time in milliseconds (possible range 10.9 - 100)
	local GetTime, debugprofilestop, time = GetTime, debugprofilestop, time
	local nextPause = debugprofilestop() + processingTime
	local lastTime = time()
	local repaintSheet = false
	local nextRepaint = 0	-- no delay for first repaint
	local nextMemory = GetTime() + 2

	private.isSearching = true
	AucAdvanced.SendProcessorMessage("searchbegin", searcherName)
	lib.NotifyCallbacks("search", "begin", searcherName)
	for i, data in ipairs(image) do
		if debugprofilestop() > nextPause or time() > lastTime then
			gui.frame.progressbar:SetValue((i/imagesize)*1000)
			if repaintSheet and GetTime() >= nextRepaint then -- using GetTime here as this needs to track time across yields
				local b=debugprofilestop()
				private.repaintSheet()
				repaintSheet = false
				local e=debugprofilestop()
				-- we use debugprofilestop to calculate time taken by repaint (in ms; divide this by 1000 to convert for use by GetTime)
				nextRepaint = GetTime() + ((e-b)*0.01)-- only let repainting consume 10% of our total CPU (0.01 == 10/1000)
			end

			coroutine.yield()

			if memorycleanup and GetTime() > nextMemory then
				collectgarbage()
				coroutine.yield()
				nextMemory = GetTime() + 2
			end

			nextPause = debugprofilestop() + processingTime
			lastTime = time()

			if private.SearchCancel then
				private.SearchCancel = nil
				break
			end
		end
		if lib.SearchItem(searcher.name, data, true) then
			repaintSheet = true
		end
	end
	image = nil

	private.repaintSheet()

	private.isSearching = false
	empty(SettingCache)
	gui.frame.progressbar:Hide()
	if memorycleanup then
		coroutine.yield()
		collectgarbage()
		coroutine.yield()
	end
	AucAdvanced.SendProcessorMessage("searchcomplete", searcherName)
	lib.NotifyCallbacks("search", "complete", searcherName)
end

function lib.IsSearching()
	return private.isSearching
end

function lib.PerformSearch(searcher)
	if (not coSearch) or (coroutine.status(coSearch) == "dead") then
		coSearch = coroutine.create(PerformSearch)
		local status, result = coroutine.resume(coSearch, searcher)
		if not status and result then
            error("Error in search coroutine: "..result.."\n\n{{{Coroutine Stack:}}}\n"..debugstack(coSearch));
		end
	else
		debugPrint("coroutine already running: "..coroutine.status(coSearch))
	end
end

local function OnUpdate(self, elapsed)
	if coSearch then
		if coroutine.status(coSearch) == "suspended" then
			local status, result = coroutine.resume(coSearch)
			if not status and result then
				error("Error in search coroutine: "..result.."\n\n{{{Coroutine Stack:}}}\n"..debugstack(coSearch));
			end
		elseif coroutine.status(coSearch) == "dead" then
			coSearch = nil
		end
	end
	if flagScanFinished then
		flagScanFinished = false
		lib.NotifyCallbacks("postscanupdate")
	end

	if flagRescan then
		--are we finished scanning
		if private.lastScansCount == 0 then
			flagRescan = nil
			CooldownFrame_Set(private.gui.Rescan.frame, 0, 0, false)
			private.gui.Search:Enable()
			lib.PerformSearch()
		else
			--if scan still in progress, keep the button churnin'
			local gt = GetTime()
			if gt > flagRescan then
				flagRescan = gt + 2.5
				CooldownFrame_Set(private.gui.Rescan.frame, gt, 2, true)
			end
		end
	end
end

private.updater = CreateFrame("Frame", nil, UIParent)
private.updater:SetScript("OnUpdate", OnUpdate)

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-SearchUI/SearchMain.lua $", "$Rev: 6415 $")
