-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

-- This is the main TSM file that holds the majority of the APIs that modules will use.

local _, TSM = ...
TSMAPI = {} -- FIXME: this is still needed for AppHelper
local ClassicRealms = TSM.Include("Data.ClassicRealms")
local Log = TSM.Include("Util.Log")
local Analytics = TSM.Include("Util.Analytics")
local Math = TSM.Include("Util.Math")
local Money = TSM.Include("Util.Money")
local ItemString = TSM.Include("Util.ItemString")
local Wow = TSM.Include("Util.Wow")
local Theme = TSM.Include("Util.Theme")
local TempTable = TSM.Include("Util.TempTable")
local ObjectPool = TSM.Include("Util.ObjectPool")
local ErrorHandler = TSM.Include("Service.ErrorHandler")
local SlashCommands = TSM.Include("Service.SlashCommands")
local Threading = TSM.Include("Service.Threading")
local Settings = TSM.Include("Service.Settings")
local ItemInfo = TSM.Include("Service.ItemInfo")
local CustomPrice = TSM.Include("Service.CustomPrice")
local BlackMarket = TSM.Include("Service.BlackMarket")
local Inventory = TSM.Include("Service.Inventory")
local LibRealmInfo = LibStub("LibRealmInfo")
local LibDBIcon = LibStub("LibDBIcon-1.0")
local L = TSM.Include("Locale").GetTable()
local private = {
	settings = nil,
	appInfo = nil,
}
local APP_INFO_REQUIRED_KEYS = { "version", "lastSync", "message", "news" }
local LOGOUT_TIME_WARNING_THRESHOLD_MS = 20
do
	-- show a message if we were updated
	if GetAddOnMetadata("TradeSkillMaster", "Version") ~= "v4.10.19" then
		Wow.ShowBasicMessage("TSM was just updated and may not work properly until you restart WoW.")
	end
end



-- ============================================================================
-- Module Functions
-- ============================================================================

function TSM.OnInitialize()
	-- load settings
	TSM.db = Settings.GetDB()
	private.settings = Settings.NewView()
		:AddKey("global", "coreOptions", "chatFrame")
		:AddKey("global", "coreOptions", "destroyValueSource")
		:AddKey("global", "coreOptions", "minimapIcon")
		:AddKey("global", "debug", "chatLoggingEnabled")
		:AddKey("global", "internalData", "appMessageId")
		:AddKey("global", "internalData", "lastCharacter")
		:AddKey("sync", "internalData", "classKey")
		:RegisterCallback("destroyValueSource", private.DestroyValueUpdated)

	-- set the last character we logged into for display in the app
	private.settings.lastCharacter = UnitName("player").." - "..GetRealmName()

	-- configure the logger
	Log.SetChatFrame(private.settings.chatFrame)
	Log.SetLoggingToChatEnabled(private.settings.chatLoggingEnabled)
	Log.SetCurrentThreadNameFunction(Threading.GetCurrentThreadName)

	-- store the class of this character
	private.settings.classKey = select(2, UnitClass("player"))

	-- core price sources
	ItemInfo.RegisterInfoChangeCallback(function(itemString)
		CustomPrice.OnSourceChange("VendorBuy", itemString)
		CustomPrice.OnSourceChange("VendorSell", itemString)
		CustomPrice.OnSourceChange("ItemQuality", itemString)
		CustomPrice.OnSourceChange("ItemLevel", itemString)
		CustomPrice.OnSourceChange("RequiredLevel", itemString)
	end)
	CustomPrice.RegisterSource("TSM", "VendorBuy", L["Buy from Vendor"], ItemInfo.GetVendorBuy)
	CustomPrice.RegisterSource("TSM", "VendorSell", L["Sell to Vendor"], ItemInfo.GetVendorSell)
	local function GetDestroyValue(itemString)
		return CustomPrice.GetConversionsValue(itemString, private.settings.destroyValueSource)
	end
	CustomPrice.RegisterSource("TSM", "Destroy", L["Destroy Value"], GetDestroyValue)
	CustomPrice.RegisterSource("TSM", "ItemQuality", L["Item Quality"], ItemInfo.GetQuality)
	CustomPrice.RegisterSource("TSM", "ItemLevel", L["Item Level"], ItemInfo.GetItemLevel)
	CustomPrice.RegisterSource("TSM", "RequiredLevel", L["Required Level"], ItemInfo.GetMinLevel)
	CustomPrice.RegisterSource("TSM", "NumInventory", L["Total Inventory Quantity"], Inventory.GetTotalQuantity)

	-- Auctioneer price sources
	if Wow.IsAddonEnabled("Auc-Advanced") and AucAdvanced then
		local registeredAuctioneerSources = {}
		hooksecurefunc(AucAdvanced, "SendProcessorMessage", function(msg)
			if msg == "scanfinish" then
				for _, source in ipairs(registeredAuctioneerSources) do
					CustomPrice.OnSourceChange(source)
				end
			end
		end)
		if AucAdvanced.Modules.Util.Appraiser and AucAdvanced.Modules.Util.Appraiser.GetPrice then
			CustomPrice.RegisterSource("External", "AucAppraiser", L["Auctioneer - Appraiser"], AucAdvanced.Modules.Util.Appraiser.GetPrice, true)
			tinsert(registeredAuctioneerSources, "AucAppraiser")
		end
		if AucAdvanced.Modules.Util.SimpleAuction and AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems then
			local function GetAucMinBuyout(itemLink)
				return select(6, AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems(itemLink)) or nil
			end
			CustomPrice.RegisterSource("External", "AucMinBuyout", L["Auctioneer - Minimum Buyout"], GetAucMinBuyout, true)
			tinsert(registeredAuctioneerSources, "AucMinBuyout")
		end
		if AucAdvanced.API.GetMarketValue then
			CustomPrice.RegisterSource("External", "AucMarket", L["Auctioneer - Market Value"], AucAdvanced.API.GetMarketValue, true)
			tinsert(registeredAuctioneerSources, "AucMarket")
		end
	end

	-- Auctionator price sources
	if Wow.IsAddonEnabled("Auctionator") and Auctionator and Auctionator.Database and Auctionator.Database.ProcessScan and Auctionator.API and Auctionator.API.v1 then
		-- retail version
		hooksecurefunc(Auctionator.Database, "ProcessScan", function()
			CustomPrice.OnSourceChange("AtrValue")
		end)
		local function GetAuctionatorPrice(itemLink)
			return Auctionator.API.v1.GetAuctionPriceByItemLink("TradeSkillMaster", itemLink)
		end
		CustomPrice.RegisterSource("External", "AtrValue", L["Auctionator - Auction Value"], GetAuctionatorPrice, true)
	elseif Wow.IsAddonEnabled("Auctionator") and Atr_GetAuctionBuyout and Atr_RegisterFor_DBupdated then
		-- classic version
		Atr_RegisterFor_DBupdated(function()
			CustomPrice.OnSourceChange("AtrValue")
		end)
		CustomPrice.RegisterSource("External", "AtrValue", L["Auctionator - Auction Value"], Atr_GetAuctionBuyout, true)
	end

	-- TheUndermineJournal and BootyBayGazette price sources
	if Wow.IsAddonEnabled("TheUndermineJournal") and TUJMarketInfo then
		local function GetTUJPrice(itemLink, arg)
			local data = TUJMarketInfo(itemLink)
			return data and data[arg] or nil
		end
		CustomPrice.RegisterSource("External", "TUJRecent", L["TUJ 3-Day Price"], GetTUJPrice, true, "recent")
		CustomPrice.RegisterSource("External", "TUJMarket", L["TUJ 14-Day Price"], GetTUJPrice, true, "market")
		CustomPrice.RegisterSource("External", "TUJGlobalMean", L["TUJ Global Mean"], GetTUJPrice, true, "globalMean")
		CustomPrice.RegisterSource("External", "TUJGlobalMedian", L["TUJ Global Median"], GetTUJPrice, true, "globalMedian")
	elseif Wow.IsAddonEnabled("BootyBayGazette") and TUJMarketInfo then
		local function GetBBGPrice(itemLink, arg)
			local data = TUJMarketInfo(itemLink)
			return data and data[arg] or nil
		end
		CustomPrice.RegisterSource("External", "BBGRecent", L["BBG 3-Day Price"], GetBBGPrice, true, "recent")
		CustomPrice.RegisterSource("External", "BBGMarket", L["BBG 14-Day Price"], GetBBGPrice, true, "market")
		CustomPrice.RegisterSource("External", "BBGGlobalMean", L["BBG Global Mean"], GetBBGPrice, true, "globalMean")
		CustomPrice.RegisterSource("External", "BBGGlobalMedian", L["BBG Global Median"], GetBBGPrice, true, "globalMedian")
	end

	-- AHDB price sources
	if Wow.IsAddonEnabled("AuctionDB") and AuctionDB and AuctionDB.AHGetAuctionInfoByLink then
		hooksecurefunc(AuctionDB, "AHendOfScanCB", function()
			CustomPrice.OnSourceChange("AHDBMinBuyout")
			CustomPrice.OnSourceChange("AHDBMinBid")
		end)
		local function GetAHDBPrice(itemLink, arg)
			local info = AuctionDB:AHGetAuctionInfoByLink(itemLink)
			return info and info[arg] or nil
		end
		CustomPrice.RegisterSource("External", "AHDBMinBuyout", L["AHDB Minimum Buyout"], GetAHDBPrice, true, "minBuyout")
		CustomPrice.RegisterSource("External", "AHDBMinBid", L["AHDB Minimum Bid"], GetAHDBPrice, true, "minBid")
	end

	-- module price sources
	CustomPrice.RegisterSource("Accounting", "AvgSell", L["Avg Sell Price"], TSM.Accounting.Transactions.GetAverageSalePrice)
	CustomPrice.RegisterSource("Accounting", "MaxSell", L["Max Sell Price"], TSM.Accounting.Transactions.GetMaxSalePrice)
	CustomPrice.RegisterSource("Accounting", "MinSell", L["Min Sell Price"], TSM.Accounting.Transactions.GetMinSalePrice)
	CustomPrice.RegisterSource("Accounting", "AvgBuy", L["Avg Buy Price"], TSM.Accounting.Transactions.GetAverageBuyPrice, nil, false)
	CustomPrice.RegisterSource("Accounting", "SmartAvgBuy", L["Smart Avg Buy Price"], TSM.Accounting.Transactions.GetAverageBuyPrice, nil, true)
	CustomPrice.RegisterSource("Accounting", "MaxBuy", L["Max Buy Price"], TSM.Accounting.Transactions.GetMaxBuyPrice)
	CustomPrice.RegisterSource("Accounting", "MinBuy", L["Min Buy Price"], TSM.Accounting.Transactions.GetMinBuyPrice)
	CustomPrice.RegisterSource("Accounting", "NumExpires", L["Expires Since Last Sale"], TSM.Accounting.Auctions.GetNumExpiresSinceSale)
	CustomPrice.RegisterSource("Accounting", "SaleRate", L["Sale Rate"], TSM.Accounting.GetSaleRate)
	CustomPrice.RegisterSource("AuctionDB", "DBMarket", L["AuctionDB - Market Value"], TSM.AuctionDB.GetRealmItemData, false, "marketValue")
	CustomPrice.RegisterSource("AuctionDB", "DBMinBuyout", L["AuctionDB - Minimum Buyout"], TSM.AuctionDB.GetRealmItemData, false, "minBuyout")
	CustomPrice.RegisterSource("AuctionDB", "DBHistorical", L["AuctionDB - Historical Price (via TSM App)"], TSM.AuctionDB.GetRealmItemData, false, "historical")
	CustomPrice.RegisterSource("AuctionDB", "DBRegionMinBuyoutAvg", L["AuctionDB - Region Minimum Buyout Average (via TSM App)"], TSM.AuctionDB.GetRegionItemData, false, "regionMinBuyout")
	CustomPrice.RegisterSource("AuctionDB", "DBRegionMarketAvg", L["AuctionDB - Region Market Value Average (via TSM App)"], TSM.AuctionDB.GetRegionItemData, false, "regionMarketValue")
	CustomPrice.RegisterSource("AuctionDB", "DBRegionHistorical", L["AuctionDB - Region Historical Price (via TSM App)"], TSM.AuctionDB.GetRegionItemData, false, "regionHistorical")
	CustomPrice.RegisterSource("AuctionDB", "DBRegionSaleAvg", L["AuctionDB - Region Sale Average (via TSM App)"], TSM.AuctionDB.GetRegionItemData, false, "regionSale")
	CustomPrice.RegisterSource("AuctionDB", "DBRegionSaleRate", L["AuctionDB - Region Sale Rate (via TSM App)"], TSM.AuctionDB.GetRegionSaleInfo, false, "regionSalePercent")
	CustomPrice.RegisterSource("AuctionDB", "DBRegionSoldPerDay", L["AuctionDB - Region Sold Per Day (via TSM App)"], TSM.AuctionDB.GetRegionSaleInfo, false, "regionSoldPerDay")
	CustomPrice.RegisterSource("Crafting", "Crafting", L["Crafting Cost"], TSM.Crafting.Cost.GetLowestCostByItem, nil, nil, true)
	CustomPrice.RegisterSource("Crafting", "MatPrice", L["Crafting Material Cost"], TSM.Crafting.Cost.GetMatCost, nil, nil, true)

	-- operation-based price sources
	CustomPrice.RegisterSource("Operations", "auctioningopmin", L["First Auctioning Operation Min Price"], TSM.Operations.Auctioning.GetMinPrice)
	CustomPrice.RegisterSource("Operations", "auctioningopmax", L["First Auctioning Operation Max Price"], TSM.Operations.Auctioning.GetMaxPrice)
	CustomPrice.RegisterSource("Operations", "auctioningopnormal", L["First Auctioning Operation Normal Price"], TSM.Operations.Auctioning.GetNormalPrice)
	CustomPrice.RegisterSource("Operations", "shoppingopmax", L["Shopping Operation Max Price"], TSM.Operations.Shopping.GetMaxPrice)
	CustomPrice.RegisterSource("Operations", "sniperopmax", L["Sniper Operation Below Price"], TSM.Operations.Sniper.GetBelowPrice)

	-- slash commands
	SlashCommands.Register("", TSM.MainUI.Toggle, L["Toggles the main TSM window"])
	SlashCommands.Register("help", SlashCommands.PrintHelp, L["Prints the slash command help listing"])
	SlashCommands.Register("version", private.PrintVersions, L["Prints out the version numbers of all installed modules"])
	SlashCommands.Register("sources", CustomPrice.PrintSources, L["Prints out the available price sources for use in custom prices"])
	SlashCommands.Register("price", private.TestPriceSource, L["Allows for testing of custom prices"])
	SlashCommands.Register("profile", private.ChangeProfile, L["Changes to the specified profile (i.e. '/tsm profile Default' changes to the 'Default' profile)"])
	SlashCommands.Register("debug", private.DebugSlashCommandHandler)
	SlashCommands.Register("destroy", TSM.UI.DestroyingUI.Toggle, L["Opens the Destroying frame if there's stuff in your bags to be destroyed."])
	SlashCommands.Register("crafting", TSM.UI.CraftingUI.Toggle, L["Toggles the TSM Crafting UI."])
	SlashCommands.Register("tasklist", TSM.UI.TaskListUI.Toggle, L["Toggles the TSM Task List UI"])
	SlashCommands.Register("bankui", TSM.UI.BankingUI.Toggle, L["Toggles the TSM Banking UI if either the bank or guild bank is currently open."])
	SlashCommands.Register("get", TSM.Banking.GetByFilter, L["Gets items from the bank or guild bank matching the item or partial text entered."])
	SlashCommands.Register("put", TSM.Banking.PutByFilter, L["Puts items matching the item or partial text entered into the bank or guild bank."])
	SlashCommands.Register("restock_help", TSM.Crafting.RestockHelp, L["Tells you why a specific item is not being restocked and added to the queue."])
	if TSM.IsWowClassic() then
		SlashCommands.Register("scan", TSM.AuctionDB.RunScan, L["Performs a full, manual scan of the AH to populate some AuctionDB data if none is otherwise available."])
	end

	-- create / register the minimap button
	local dataObj = LibStub("LibDataBroker-1.1"):NewDataObject("TradeSkillMaster", {
		type = "launcher",
		icon = "Interface\\Addons\\TradeSkillMaster\\Media\\TSM_Icon2",
		OnClick = function(_, button)
			if button ~= "LeftButton" then return end
			TSM.MainUI.Toggle()
		end,
		OnTooltipShow = function(tooltip)
			local cs = Theme.GetColor("INDICATOR_ALT"):GetTextColorPrefix()
			local ce = "|r"
			tooltip:AddLine("TradeSkillMaster " .. TSM.GetVersion())
			tooltip:AddLine(format(L["%sLeft-Click%s to open the main window"], cs, ce))
			tooltip:AddLine(format(L["%sDrag%s to move this button"], cs, ce))
		end,
	})
	LibDBIcon:Register("TradeSkillMaster", dataObj, private.settings.minimapIcon)

	-- cache battle pet names
	if not TSM.IsWowClassic() then
		for i = 1, C_PetJournal.GetNumPets() do
			C_PetJournal.GetPetInfoByIndex(i)
		end
	end

	-- force a garbage collection
	collectgarbage()
end

function TSM.OnEnable()
	for i = 1, GetNumAddOns() do
		local name = GetAddOnInfo(i)
		if strmatch(name, "^TradeSkillMaster") and name ~= "TradeSkillMaster" and name ~= "TradeSkillMaster_AppHelper" and name ~= "TradeSkillMaster_StringConverter" then
			Wow.ShowBasicMessage(format(L["An old TSM addon was found installed. Please remove %s and any other old TSM addons to avoid issues."], name))
			break
		end
	end

	if not Wow.IsAddonInstalled("TradeSkillMaster_AppHelper") then
		return
	end

	if not Wow.IsAddonEnabled("TradeSkillMaster_AppHelper") then
		-- TSM_AppHelper is disabled
		StaticPopupDialogs["TSM_APP_DATA_ERROR"] = {
			text = L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."],
			button1 = L["Reload"],
			timeout = 0,
			whileDead = true,
			OnAccept = function()
				EnableAddOn("TradeSkillMaster_AppHelper")
				ReloadUI()
			end,
		}
		Wow.ShowStaticPopupDialog("TSM_APP_DATA_ERROR")
		return
	end

	assert(TSMAPI.AppHelper)
	local appInfo = TSMAPI.AppHelper:FetchData("APP_INFO")
	if not appInfo then
		-- The app hasn't run yet or isn't pointing at the right WoW directory
		StaticPopupDialogs["TSM_APP_DATA_ERROR"] = {
			text = L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."],
			button1 = OKAY,
			timeout = 0,
			whileDead = true,
		}
		Wow.ShowStaticPopupDialog("TSM_APP_DATA_ERROR")
		return
	end

	-- load the app info
	assert(#appInfo == 1 and #appInfo[1] == 2 and appInfo[1][1] == "Global")
	private.appInfo = assert(loadstring(appInfo[1][2]))()
	for _, key in ipairs(APP_INFO_REQUIRED_KEYS) do
		assert(private.appInfo[key])
	end

	if private.appInfo.message and private.appInfo.message.id > private.settings.appMessageId then
		-- show the message from the app
		private.settings.appMessageId = private.appInfo.message.id
		StaticPopupDialogs["TSM_APP_MESSAGE"] = {
			text = private.appInfo.message.msg,
			button1 = OKAY,
			timeout = 0,
		}
		Wow.ShowStaticPopupDialog("TSM_APP_MESSAGE")
	end

	if time() - private.appInfo.lastSync > 60 * 60 then
		-- the app hasn't been running for over an hour
		StaticPopupDialogs["TSM_APP_DATA_ERROR"] = {
			text = L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."],
			button1 = OKAY,
			timeout = 0,
			whileDead = true,
		}
		Wow.ShowStaticPopupDialog("TSM_APP_DATA_ERROR")
	end

	if private.appInfo.news then
		-- clean up the news content strings
		for _, info in ipairs(private.appInfo.news) do
			-- for some reason the data is missing a few newlines before bold headings, so add one
			info.content = gsub(info.content, "(<strong>)", "\n\n%1")
			info.content = gsub(info.content, "<br%s+/>", "\n")
			info.content = gsub(info.content, "<strong>(.-)</strong>", "%1")
			info.content = gsub(info.content, "<a href='.-'>(.-)</a>", "%1")
			info.content = gsub(info.content, "&#8211;", "-")
			info.content = gsub(info.content, "&#8216;", "'")
		end
	end
end

function TSM.OnDisable()
	local originalProfile = TSM.db:GetCurrentProfile()
	-- erroring here would cause the profile to be reset, so use pcall
	local startTime = debugprofilestop()
	local success, errMsg = pcall(private.SaveAppData)
	local timeTaken = debugprofilestop() - startTime
	if timeTaken > LOGOUT_TIME_WARNING_THRESHOLD_MS then
		Log.Warn("private.SaveAppData took %0.2fms", timeTaken)
	end
	if not success then
		Log.Err("private.SaveAppData hit an error: %s", tostring(errMsg))
		-- force ourselves back to the original profile
		TSM.db:SetProfile(originalProfile, true)
		error("Error while saving app data: "..tostring(errMsg))
	end
end



-- ============================================================================
-- General Slash-Command Handlers
-- ============================================================================

function private.TestPriceSource(price)
	local _, endIndex, link = strfind(price, "(\124c[0-9a-f]+\124H[^\124]+\124h%[[^%]]+%]\124h\124r)")
	price = link and strtrim(strsub(price, endIndex + 1))
	if not price or price == "" then
		Log.PrintUser(L["Usage: /tsm price <Item Link> <Custom String>"])
		return
	end

	local isValid, err = CustomPrice.Validate(price)
	if not isValid then
		Log.PrintfUser(L["%s is not a valid custom price and gave the following error: %s"], Log.ColorUserAccentText(price), err)
		return
	end

	local itemString = ItemString.Get(link)
	if not itemString then
		Log.PrintfUser(L["%s is a valid custom price but %s is an invalid item."], Log.ColorUserAccentText(price), link)
		return
	end

	local value = CustomPrice.GetValue(price, itemString)
	if not value then
		Log.PrintfUser(L["%s is a valid custom price but did not give a value for %s."], Log.ColorUserAccentText(price), link)
		return
	end

	Log.PrintfUser(L["A custom price of %s for %s evaluates to %s."], Log.ColorUserAccentText(price), link, Money.ToString(value))
end

function private.ChangeProfile(targetProfile)
	targetProfile = strtrim(targetProfile)
	local profiles = TSM.db:GetProfiles()
	if targetProfile == "" then
		Log.PrintfUser(L["No profile specified. Possible profiles: '%s'"], table.concat(profiles, "', '"))
	else
		for _, profile in ipairs(profiles) do
			if profile == targetProfile then
				if profile ~= TSM.db:GetCurrentProfile() then
					TSM.db:SetProfile(profile)
				end
				Log.PrintfUser(L["Profile changed to '%s'."], profile)
				return
			end
		end
		Log.PrintfUser(L["Could not find profile '%s'. Possible profiles: '%s'"], targetProfile, table.concat(profiles, "', '"))
	end
end

function private.DebugSlashCommandHandler(arg)
	if arg == "fstack" then
		TSM.UI.FrameStack.Toggle()
	elseif arg == "error" then
		ErrorHandler.ShowManual()
	elseif arg == "logging" then
		private.settings.chatLoggingEnabled = not private.settings.chatLoggingEnabled
		Log.SetLoggingToChatEnabled(private.settings.chatLoggingEnabled)
		if private.settings.chatLoggingEnabled then
			Log.PrintfUser("Logging to chat enabled")
		else
			Log.PrintfUser("Logging to chat disabled")
		end
	elseif arg == "db" then
		TSM.UI.DBViewer.Toggle()
	elseif arg == "logout" then
		TSM.AddonTestLogout()
	elseif arg == "clearitemdb" then
		ItemInfo.ClearDB()
	elseif arg == "leaks" then
		TempTable.EnableLeakDebug()
		ObjectPool.EnableLeakDebug()
	end
end

function private.PrintVersions()
	Log.PrintUser(L["TSM Version Info:"])
	Log.PrintUserRaw("TradeSkillMaster "..Log.ColorUserAccentText(TSM.GetVersion()))
	local appHelperVersion = GetAddOnMetadata("TradeSkillMaster_AppHelper", "Version")
	if appHelperVersion then
		-- use strmatch so that our sed command doesn't replace this string
		if strmatch(appHelperVersion, "^@tsm%-project%-version@$") then
			appHelperVersion = "Dev"
		end
		Log.PrintUserRaw("TradeSkillMaster_AppHelper "..Log.ColorUserAccentText(appHelperVersion))
	end
end

function private.SaveAppData()
	if not TSMAPI.AppHelper then
		return
	end

	TradeSkillMaster_AppHelperDB = TradeSkillMaster_AppHelperDB or {}
	local appDB = TradeSkillMaster_AppHelperDB

	-- store region
	local region = TSM.GetRegion()
	appDB.region = region

	-- save errors
	ErrorHandler.SaveReports(appDB)

	local function GetShoppingMaxPrice(itemString)
		local value = TSM.Operations.Shopping.GetMaxPrice(itemString)
		return value and value > 0 and value or nil
	end

	-- save TSM_Shopping max prices in the app DB for the current profile
	appDB.shoppingMaxPrices = {}
	local profile = TSM.db:GetCurrentProfile()
	local profileGroupData = {}
	for _, itemString, groupPath in TSM.Groups.ItemIterator() do
		local itemId = tonumber(strmatch(itemString, "^i:([0-9]+)$"))
		if itemId then
			local maxPrice = GetShoppingMaxPrice(itemString)
			if maxPrice then
				if not profileGroupData[groupPath] then
					profileGroupData[groupPath] = {}
				end
				tinsert(profileGroupData[groupPath], "["..table.concat({itemId, maxPrice}, ",").."]")
			end
		end
	end
	if next(profileGroupData) then
		appDB.shoppingMaxPrices[profile] = {}
		for groupPath, data in pairs(profileGroupData) do
			appDB.shoppingMaxPrices[profile][groupPath] = "["..table.concat(data, ",").."]"
		end
		appDB.shoppingMaxPrices[profile].updateTime = time()
	end

	-- save black market data
	local realmName = GetRealmName()
	appDB.blackMarket = appDB.blackMarket or {}
	local blackMarketData, blackMarketTime = BlackMarket.GetScanData()
	if blackMarketData then
		appDB.blackMarket[realmName] = {
			data = blackMarketData,
			key = Math.CalculateHash(blackMarketData..":"..blackMarketTime),
			updateTime = blackMarketTime
		}
	end

	-- save analytics
	Analytics.Save(appDB)
end

function private.DestroyValueUpdated()
	CustomPrice.OnSourceChange("Destroy")
end



-- ============================================================================
-- General Module Functions
-- ============================================================================

function TSM.GetAppNews()
	return private.appInfo and private.appInfo.news
end

function TSM.GetAppUpdateTime()
	return private.appInfo and private.appInfo.lastSync or 0
end

function TSM.GetRegion()
	local cVar = GetCVar("Portal")
	local region = nil
	if TSM.IsWowClassic() then
		local currentRealmName = gsub(GetRealmName(), "\226", "'")
		region = ClassicRealms.GetRegion(currentRealmName) or (cVar ~= "public-test" and cVar) or "PTR"
		region = region.."-Classic"
	else
		region = LibRealmInfo:GetCurrentRegion() or (cVar ~= "public-test" and cVar) or "PTR"
	end
	return region
end

function TSM.GetTSMProfileIterator()
	local originalProfile = TSM.db:GetCurrentProfile()
	local profiles = TSM.db:GetProfiles()

	return function()
		local profile = tremove(profiles)
		if profile then
			TSM.db:SetProfile(profile)
			return profile
		end
		TSM.db:SetProfile(originalProfile)
	end
end
