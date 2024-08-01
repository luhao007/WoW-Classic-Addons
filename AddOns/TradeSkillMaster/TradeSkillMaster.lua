-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Environment = TSM.Include("Environment")
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
local LibDBIcon = LibStub("LibDBIcon-1.0")
local L = TSM.Include("Locale").GetTable()
local private = {
	settings = nil,
	itemInfoPublisher = nil,  --luacheck: ignore 1004 - just stored for GC reasons
	oribosExchangeTemp = {},
}
local LOGOUT_TIME_WARNING_THRESHOLD = 0.02
do
	-- show a message if we were updated
	if GetAddOnMetadata("TradeSkillMaster", "Version") ~= "v4.13.21" then
		Wow.ShowBasicMessage("TSM was just updated and may not work properly until you restart WoW.")
	end
end



-- ============================================================================
-- Module Functions
-- ============================================================================

function TSM.OnInitialize()
	-- Load settings
	TSM.db = Settings.GetDB()
	private.settings = Settings.NewView()
		:AddKey("global", "coreOptions", "chatFrame")
		:AddKey("global", "coreOptions", "destroyValueSource")
		:AddKey("global", "coreOptions", "minimapIcon")
		:AddKey("global", "debug", "chatLoggingEnabled")
		:AddKey("global", "internalData", "appMessageId")
		:AddKey("global", "internalData", "lastCharacter")
		:AddKey("global", "internalData", "whatsNewVersion")
		:AddKey("sync", "internalData", "classKey")
		:RegisterCallback("destroyValueSource", function() CustomPrice.OnSourceChange("Destroy") end)

	-- Set the last character we logged into for display in the app
	private.settings.lastCharacter = UnitName("player").." - "..GetRealmName()

	-- Configure the logger
	Log.SetChatFrame(private.settings.chatFrame)
	Log.SetLoggingToChatEnabled(private.settings.chatLoggingEnabled)
	Log.SetCurrentThreadNameFunction(Threading.GetCurrentThreadName)

	-- Store the class of this character
	private.settings.classKey = select(2, UnitClass("player"))

	-- Core price sources
	private.itemInfoPublisher = ItemInfo.GetPublisher()
		:CallFunction(function(itemString)
			CustomPrice.OnSourceChange("VendorBuy", itemString)
			CustomPrice.OnSourceChange("VendorSell", itemString)
			CustomPrice.OnSourceChange("ItemQuality", itemString)
			CustomPrice.OnSourceChange("ItemLevel", itemString)
			CustomPrice.OnSourceChange("RequiredLevel", itemString)
		end)
		:Stored()
	CustomPrice.RegisterSource("TSM", "VendorBuy", L["Buy from Vendor"], ItemInfo.GetVendorBuy, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("TSM", "VendorSell", L["Sell to Vendor"], ItemInfo.GetVendorSell, CustomPrice.SOURCE_TYPE.NORMAL)
	local function GetDestroyValue(itemString)
		return TSM.Crafting.GetConversionsValue(itemString, private.settings.destroyValueSource)
	end
	CustomPrice.RegisterSource("TSM", "Destroy", L["Destroy Value"], GetDestroyValue, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("TSM", "ItemQuality", L["Item Quality"], ItemInfo.GetQuality, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("TSM", "ItemLevel", L["Item Level"], ItemInfo.GetItemLevel, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("TSM", "RequiredLevel", L["Required Level"], ItemInfo.GetMinLevel, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("TSM", "NumInventory", L["Total Inventory Quantity"], Inventory.GetTotalQuantity, CustomPrice.SOURCE_TYPE.NORMAL)

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
			local function PriceFunc(itemString)
				local itemLink = ItemInfo.GetLink(itemString)
				if not itemLink then
					return nil
				end
				return AucAdvanced.Modules.Util.Appraiser.GetPrice(itemLink)
			end
			CustomPrice.RegisterSource("External", "AucAppraiser", L["Auctioneer - Appraiser"], PriceFunc, CustomPrice.SOURCE_TYPE.PRICE_DB)
			tinsert(registeredAuctioneerSources, "AucAppraiser")
		end
		if AucAdvanced.Modules.Util.SimpleAuction and AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems then
			local function PriceFunc(itemString)
				local itemLink = ItemInfo.GetLink(itemString)
				if not itemLink then
					return nil
				end
				return select(6, AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems(itemLink)) or nil
			end
			CustomPrice.RegisterSource("External", "AucMinBuyout", L["Auctioneer - Minimum Buyout"], PriceFunc, CustomPrice.SOURCE_TYPE.PRICE_DB)
			tinsert(registeredAuctioneerSources, "AucMinBuyout")
		end
		if AucAdvanced.API.GetMarketValue then
			local function PriceFunc(itemString)
				local itemLink = ItemInfo.GetLink(itemString)
				if not itemLink then
					return nil
				end
				return AucAdvanced.API.GetMarketValue(itemLink)
			end
			CustomPrice.RegisterSource("External", "AucMarket", L["Auctioneer - Market Value"], PriceFunc, CustomPrice.SOURCE_TYPE.PRICE_DB)
			tinsert(registeredAuctioneerSources, "AucMarket")
		end
	end

	-- Auctionator price sources
	if Wow.IsAddonEnabled("Auctionator") then
		local PriceFunc = nil
		if Auctionator and Auctionator.API and Auctionator.API.v1 and Auctionator.API.v1.RegisterForDBUpdate then
			-- Retail version
			local ok = pcall(function()
				Auctionator.API.v1.RegisterForDBUpdate("TradeSkillMaster", function() CustomPrice.OnSourceChange("AtrValue") end)
			end)
			if ok then
				PriceFunc = function(itemString)
					local itemLink = ItemInfo.GetLink(itemString)
					if not itemLink then
						return nil
					end
					return Auctionator.API.v1.GetAuctionPriceByItemLink("TradeSkillMaster", itemLink)
				end
			end
		elseif Atr_GetAuctionBuyout and Atr_RegisterFor_DBupdated then
			-- Classic version
			Atr_RegisterFor_DBupdated(function()
				CustomPrice.OnSourceChange("AtrValue")
			end)
			PriceFunc = function(itemString)
				local itemLink = ItemInfo.GetLink(itemString)
				if not itemLink then
					return nil
				end
				return Atr_GetAuctionBuyout(itemLink)
			end
		end
		if PriceFunc then
			CustomPrice.RegisterSource("External", "AtrValue", L["Auctionator - Auction Value"], PriceFunc, CustomPrice.SOURCE_TYPE.PRICE_DB)
		end
	end

	-- OribosExchange price sources
	if Wow.IsAddonEnabled("OribosExchange") and OEMarketInfo then
		local function PriceFuncHelper(itemString, key)
			local itemLink = ItemInfo.GetLink(itemString)
			if not itemLink then
				return nil
			end
			local data = OEMarketInfo(itemLink, private.oribosExchangeTemp)
			return data and data[key] or nil
		end
		local function RealmPriceFunc(itemString)
			return PriceFuncHelper(itemString, "realm")
		end
		CustomPrice.RegisterSource("External", "OERealm", L["Oribos Exchange Realm Price"], RealmPriceFunc, CustomPrice.SOURCE_TYPE.PRICE_DB)
		local function RegionPriceFunc(itemString)
			return PriceFuncHelper(itemString, "region")
		end
		CustomPrice.RegisterSource("External", "OERegion", L["Oribos Exchange Region Price"], RegionPriceFunc, CustomPrice.SOURCE_TYPE.PRICE_DB)
	end

	-- AHDB price sources
	if Wow.IsAddonEnabled("AuctionDB") and AuctionDB and AuctionDB.AHGetAuctionInfoByLink then
		hooksecurefunc(AuctionDB, "AHendOfScanCB", function()
			CustomPrice.OnSourceChange("AHDBMinBuyout")
			CustomPrice.OnSourceChange("AHDBMinBid")
		end)
		local function PriceFuncHelper(itemString, key)
			local itemLink = ItemInfo.GetLink(itemString)
			if not itemLink then
				return nil
			end
			local info = AuctionDB:AHGetAuctionInfoByLink(itemLink)
			return info and info[key] or nil
		end
		local function MinBuyoutPriceFunc(itemString)
			return PriceFuncHelper(itemString, "minBuyout")
		end
		CustomPrice.RegisterSource("External", "AHDBMinBuyout", L["AHDB Minimum Buyout"], MinBuyoutPriceFunc, CustomPrice.SOURCE_TYPE.PRICE_DB)
		local function MinBidPriceFunc(itemString)
			return PriceFuncHelper(itemString, "minBid")
		end
		CustomPrice.RegisterSource("External", "AHDBMinBid", L["AHDB Minimum Bid"], MinBidPriceFunc, CustomPrice.SOURCE_TYPE.PRICE_DB)
	end

	-- Accounting sources
	CustomPrice.RegisterSource("Accounting", "AvgSell", L["Avg Sell Price"], TSM.Accounting.Transactions.GetAverageSalePrice, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("Accounting", "MaxSell", L["Max Sell Price"], TSM.Accounting.Transactions.GetMaxSalePrice, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("Accounting", "MinSell", L["Min Sell Price"], TSM.Accounting.Transactions.GetMinSalePrice, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("Accounting", "AvgBuy", L["Avg Buy Price"], TSM.Accounting.Transactions.GetAverageBuyPrice, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("Accounting", "SmartAvgBuy", L["Smart Avg Buy Price"], TSM.Accounting.Transactions.GetSmartAverageBuyPrice, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("Accounting", "MaxBuy", L["Max Buy Price"], TSM.Accounting.Transactions.GetMaxBuyPrice, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("Accounting", "MinBuy", L["Min Buy Price"], TSM.Accounting.Transactions.GetMinBuyPrice, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("Accounting", "NumExpires", L["Expires Since Last Sale"], TSM.Accounting.Auctions.GetNumExpiresSinceSale, CustomPrice.SOURCE_TYPE.NORMAL)
	CustomPrice.RegisterSource("Accounting", "SaleRate", L["Sale Rate"], TSM.Accounting.GetSaleRate, CustomPrice.SOURCE_TYPE.NORMAL)

	-- AuctionDB sources
	local function GetAuctionDBPriceFunc(key, isRegion)
		return function(itemString)
			if isRegion then
				return TSM.AuctionDB.GetRegionItemData(itemString, key)
			else
				return TSM.AuctionDB.GetRealmItemData(itemString, key)
			end
		end
	end
	CustomPrice.RegisterSource("AuctionDB", "DBMarket", L["AuctionDB - Market Value"], GetAuctionDBPriceFunc("marketValue"), CustomPrice.SOURCE_TYPE.PRICE_DB)
	CustomPrice.RegisterSource("AuctionDB", "DBMinBuyout", L["AuctionDB - Minimum Buyout"], GetAuctionDBPriceFunc("minBuyout"), CustomPrice.SOURCE_TYPE.PRICE_DB)
	CustomPrice.RegisterSource("AuctionDB", "DBRecent", L["AuctionDB - Recent Value"], GetAuctionDBPriceFunc("marketValueRecent"), CustomPrice.SOURCE_TYPE.PRICE_DB)
	CustomPrice.RegisterSource("AuctionDB", "DBHistorical", L["AuctionDB - Historical Price"], GetAuctionDBPriceFunc("historical"), CustomPrice.SOURCE_TYPE.PRICE_DB)
	CustomPrice.RegisterSource("AuctionDB", "DBRegionMarketAvg", L["AuctionDB - Region Market Value Average"], GetAuctionDBPriceFunc("regionMarketValue", true), CustomPrice.SOURCE_TYPE.PRICE_DB)
	CustomPrice.RegisterSource("AuctionDB", "DBRegionHistorical", L["AuctionDB - Region Historical Price"], GetAuctionDBPriceFunc("regionHistorical", true), CustomPrice.SOURCE_TYPE.PRICE_DB)
	CustomPrice.RegisterSource("AuctionDB", "DBRegionSaleAvg", L["AuctionDB - Region Sale Average"], GetAuctionDBPriceFunc("regionSale", true), CustomPrice.SOURCE_TYPE.PRICE_DB)
	CustomPrice.RegisterSource("AuctionDB", "DBRegionSaleRate", L["AuctionDB - Region Sale Rate"], GetAuctionDBPriceFunc("regionSalePercent", true), CustomPrice.SOURCE_TYPE.PRICE_DB)
	CustomPrice.RegisterSource("AuctionDB", "DBRegionSoldPerDay", L["AuctionDB - Region Sold Per Day"], GetAuctionDBPriceFunc("regionSoldPerDay", true), CustomPrice.SOURCE_TYPE.PRICE_DB)

	-- Crafting sources
	CustomPrice.RegisterSource("Crafting", "Crafting", L["Crafting Cost"], TSM.Crafting.Cost.GetLowestCostByItem, CustomPrice.SOURCE_TYPE.VOLATILE)
	CustomPrice.RegisterSource("Crafting", "MatPrice", L["Crafting Material Cost"], TSM.Crafting.Cost.GetMatCost, CustomPrice.SOURCE_TYPE.VOLATILE)

	-- Operation-based price sources
	CustomPrice.RegisterSource("Operations", "AuctioningOpMin", L["First Auctioning Operation Min Price"], TSM.Operations.Auctioning.GetMinPrice, CustomPrice.SOURCE_TYPE.VOLATILE)
	CustomPrice.RegisterSource("Operations", "AuctioningOpMax", L["First Auctioning Operation Max Price"], TSM.Operations.Auctioning.GetMaxPrice, CustomPrice.SOURCE_TYPE.VOLATILE)
	CustomPrice.RegisterSource("Operations", "AuctioningOpNormal", L["First Auctioning Operation Normal Price"], TSM.Operations.Auctioning.GetNormalPrice, CustomPrice.SOURCE_TYPE.VOLATILE)
	CustomPrice.RegisterSource("Operations", "ShoppingOpMax", L["Shopping Operation Max Price"], TSM.Operations.Shopping.GetMaxPrice, CustomPrice.SOURCE_TYPE.VOLATILE)
	CustomPrice.RegisterSource("Operations", "SniperOpMax", L["Sniper Operation Below Price"], TSM.Operations.Sniper.GetBelowPrice, CustomPrice.SOURCE_TYPE.VOLATILE)

	-- Slash commands
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
			tooltip:AddLine("TradeSkillMaster "..Environment.GetVersion())
			tooltip:AddLine(format(L["%sLeft-Click%s to open the main window"], cs, ce))
			tooltip:AddLine(format(L["%sDrag%s to move this button"], cs, ce))
		end,
	})
	LibDBIcon:Register("TradeSkillMaster", dataObj, private.settings.minimapIcon)

	-- cache battle pet names
	if Environment.HasFeature(Environment.FEATURES.BATTLE_PETS) then
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

	local lastSync = TSM.AppHelper.GetLastSync()
	if not lastSync then
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

	local msg, msgId = TSM.AppHelper.GetMessage()
	if msg and msgId > private.settings.appMessageId then
		-- show the message from the app
		private.settings.appMessageId = msgId
		StaticPopupDialogs["TSM_APP_MESSAGE"] = {
			text = msg,
			button1 = OKAY,
			timeout = 0,
		}
		Wow.ShowStaticPopupDialog("TSM_APP_MESSAGE")
	end

	if time() - lastSync > 60 * 60 then
		-- the app hasn't been running for over an hour
		StaticPopupDialogs["TSM_APP_DATA_ERROR"] = {
			text = L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."],
			button1 = OKAY,
			timeout = 0,
			whileDead = true,
		}
		Wow.ShowStaticPopupDialog("TSM_APP_DATA_ERROR")
	end
end

function TSM.OnDisable()
	local originalProfile = TSM.db:GetCurrentProfile()
	-- erroring here would cause the profile to be reset, so use pcall
	local startTime = GetTimePreciseSec()
	local success, errMsg = pcall(private.SaveAppData)
	local timeTaken = GetTimePreciseSec() - startTime
	if timeTaken > LOGOUT_TIME_WARNING_THRESHOLD then
		Log.Warn("private.SaveAppData took %0.5fs", timeTaken)
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
	if targetProfile == "" then
		Log.PrintfUser(L["No profile specified. Possible profiles: '%s'"], private.GetProfileListStr())
	else
		for _, profile in TSM.db:ScopeKeyIterator("profile") do
			if profile == targetProfile then
				if profile ~= TSM.db:GetCurrentProfile() then
					TSM.db:SetProfile(profile)
				end
				Log.PrintfUser(L["Profile changed to '%s'."], profile)
				return
			end
		end
		Log.PrintfUser(L["Could not find profile '%s'. Possible profiles: '%s'"], targetProfile, private.GetProfileListStr())
	end
end

function private.GetProfileListStr()
	local profiles = TempTable.Acquire()
	for _, profile in TSM.db:ScopeKeyIterator("profile") do
		tinsert(profiles, profile)
	end
	local result = table.concat(profiles, "', '")
	TempTable.Release(profiles)
	return result
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
	elseif arg == "sb" or arg == "story" or arg == "storyboard" then
		TSM.UI.StoryBoard.Toggle()
	elseif arg == "logout" then
		TSM.AddonTestLogout()
	elseif arg == "clearitemdb" then
		ItemInfo.ClearDB()
	elseif arg == "clearcraftdb" then
		TSM.db.factionrealm.internalData.crafts = {}
		ReloadUI()
	elseif arg == "leaks" then
		TempTable.EnableLeakDebug()
		ObjectPool.EnableLeakDebug()
	elseif arg == "whatsnew" then
		private.settings.whatsNewVersion = 0
	end
end

function private.PrintVersions()
	Log.PrintUser(L["TSM Version Info:"])
	Log.PrintUserRaw("TradeSkillMaster "..Log.ColorUserAccentText(Environment.GetVersion()))
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
	if not Wow.IsAddonInstalled("TradeSkillMaster_AppHelper") or not Wow.IsAddonEnabled("TradeSkillMaster_AppHelper") then
		return
	end

	TradeSkillMaster_AppHelperDB = TradeSkillMaster_AppHelperDB or {}
	local appDB = TradeSkillMaster_AppHelperDB

	-- store region
	local region = TSM.AppHelper.GetRegion()
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
