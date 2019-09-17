--[[
	Auctioneer Advanced
	Version: 8.2.6420 (SwimmingSeadragon)
	Revision: $Id: CoreAPI.lua 6420 2019-09-13 05:07:31Z none $
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds statistical history to the auction data that is collected
	when the auction is scanned, so that you can easily determine what price
	you will be able to sell an item for at auction or at a vendor whenever you
	mouse-over an item in the game

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
]]
local AucAdvanced = AucAdvanced
if not AucAdvanced then return end
AucAdvanced.CoreFileCheckIn("CoreAPI")

local coremodule, libinternal, private = AucAdvanced.GetCoreModule("CoreAPI", "API", true, "CoreAPI")
if not coremodule then return end -- would only occur with conflicting module data spaces
local lib = AucAdvanced.API

local Const = AucAdvanced.Const
local Resources = AucAdvanced.Resources
local Data = AucAdvanced.Data
local GetSetting = AucAdvanced.Settings.GetSetting
local SanitizeLink = AucAdvanced.SanitizeLink
local debugPrint = AucAdvanced.Debug.DebugPrint
local ResolveServerKey = AucAdvanced.ResolveServerKey

local tinsert = table.insert
local tremove = table.remove
local next,pairs,ipairs,type = next,pairs,ipairs,type
local wipe = wipe
local ceil,floor,max,abs = ceil,floor,max,abs
local tostring,tonumber,strjoin,strsplit,format = tostring,tonumber,strjoin,strsplit,format
local GetItemInfo = GetItemInfo
local time = time
local bitand = bit.band
local tconcat=table.concat
-- GLOBALS: nLog, N_NOTICE, N_WARNING, N_ERROR

lib.Print = AucAdvanced.Print

coremodule.Processors = {}
function coremodule.Processors.scanstats()
	lib.ClearMarketCache()
	private.ResetAlgorithms()
end
function coremodule.Processors.configchanged(...)
	lib.ClearMarketCache()
	private.ResetMatchers(...)
	private.ResetAlgorithms()
end
function coremodule.Processors.newmodule()
	private.ClearEngineCache()
	lib.ClearMarketCache()
	private.ResetMatchers()
end

function coremodule.Processors.gameactive()
	if private.InitBonusIDHandlers then private.InitBonusIDHandlers() end
end

do
    local EPSILON = 0.000001;
    local IMPROVEMENT_FACTOR = 0.8;
    local CORRECTION_FACTOR = 1000; -- 10 silver per gold, integration steps at tail
    local FALLBACK_ERROR = 1;       -- 1 silver per gold fallback error max

	local INFP = math.huge -- fix for WoW4.3 (as 1/0 will cause an error)
	local INFN = -math.huge

	-- cache[serverKey][itemsig]={value, seen, #stats}
    local cache = setmetatable({}, { __index = function(tbl,key)
			tbl[key] = {}
			return tbl[key]
		end
	})
    local pdfList = {};
    local engines = {};
    local ERROR = 0.05;
    -- local LOWER_INT_LIMIT, HIGHER_INT_LIMIT = -100000, 10000000;
    --[[
        This function acquires the current market value of the mentioned item using
        a configurable algorithm to process the data used by the other installed
        algorithms.

        The returned value is the most probable value that the item is worth
        using the algorithms in each of the STAT modules as specified
        by the GetItemPDF() function.

        AucAdvanced.API.GetMarketValue(itemLink, serverKey, confidence)

	The confidence parameter is the probability that the actual price is less than the returned value.
	In most cases you will want this to be 50% (and that is the default), representing a 50% chance the
	value is higher than the returned price, and a 50% chance the value is lower. However, sometimes you
	may be curious of a different limit (for example, filter modules). In these cases, pass in a different
	value for confidence. 0.5 = 50%, 0.75 = 75%, etc.
    ]]
	function lib.GetMarketValue(itemLink, serverKey, confidence)
		local _;
		if type(itemLink) == 'number' then _, itemLink = GetItemInfo(itemLink) end
		if not itemLink then return end

		local cacheSig = lib.GetSigFromLink(itemLink)
		if not cacheSig then return end -- not a valid item link

		if type(confidence) ~= "number" then
			if confidence then
				-- invalid parameter - not a number and not nil
				-- technically an error, but for the time being we will just log it and use default value
				debugPrint(format("Invalid 'confidence' parameter for GetMarketValue:%s(%s)\nUsing default value.", tostring(confidence), type(confidence)),
					"CoreAPI", "GetMarketValue invalid parameter", "Error")
			end
			confidence = 0.5
		end
		-- need to append confidence level to cacheSig so we don't mix them up later
		-- Rounded to a level that is effectively irrelevant to avoid FP errors
		cacheSig = cacheSig .. (confidence == 0.5 and "" or ("-" .. floor(confidence * 10000)));

		serverKey = ResolveServerKey(serverKey)
		if not serverKey then return end

        local cacheEntry = cache[serverKey][cacheSig]
        if cacheEntry then
            return cacheEntry[1], cacheEntry[2], cacheEntry[3] -- explicit indexing faster than 'unpack' for 3 values
        end

        ERROR = GetSetting("core.marketvalue.tolerance");
        local saneLink = SanitizeLink(itemLink)

        local upperLimit, lowerLimit, seen = 0, 1e11, 0;

        if #engines == 0 then
            -- Rebuild the engine cache
            local modules = AucAdvanced.GetAllModules(nil, "Stat")
            for pos, engineLib in ipairs(modules) do
                local fn = engineLib.GetItemPDF;
                if fn then
                    tinsert(engines, {pdf = fn, array = engineLib.GetPriceArray, pseen = engineLib.GetPriceSeen});
                elseif nLog then
                    nLog.AddMessage("Auctioneer", "Market Pricing", N_WARNING, "Missing PDF", "Auctioneer engine '"..engineLib.GetName().."' does not have a GetItemPDF() function. This check will be removed in the near future in favor of faster calls. Implement this function.");
                end
            end
        end

        -- Run through all of the stat modules and get the PDFs
        local c, oldPdfMax, total = 0, #pdfList, 0;
        local convergedFallback = nil;
        for _, engine in ipairs(engines) do
            local i, min, max, area = engine.pdf(saneLink, serverKey);

            if type(i) == 'number' then
                -- This is a fallback
                if convergedFallback == nil or (type(convergedFallback) == 'number' and abs(convergedFallback - i) < FALLBACK_ERROR * convergedFallback / 10000) then
                    convergedFallback = i;
                else
                    convergedFallback = false;      -- Cannot converge on fallback pricing
                end

            elseif i then -- type should be "function"
                total = total + (area or 1);                                -- Add total area, assume 1 if not supplied
                c = c + 1;
                pdfList[c] =  i; -- pdfList[++c] = i;
                if min < lowerLimit then lowerLimit = min; end
                if max > upperLimit then upperLimit = max; end

				if engine.pseen then
					local _, s = engine.pseen(saneLink, serverKey)
					if s and s > seen then
						seen = s
					end
				elseif engine.array then
					local priceArray = engine.array(saneLink, serverKey)
					if priceArray then
						local s = priceArray.seen
						if s and s > seen then
							seen = s
						end
					end
				end
			end
        end

        -- Clean out extras if needed
        for i = c+1, oldPdfMax do
            pdfList[i] = nil;
        end

        if #pdfList == 0 and convergedFallback then
            if nLog then nLog.AddMessage("Auctioneer", "Market Pricing", N_WARNING, "Fallback Pricing Used", "Fallback pricing used due to no available PDFs on item "..itemLink); end
            return convergedFallback, 1, 1;
        end


        if not (lowerLimit > INFN and upperLimit < INFP) then
			error("Invalid bounds detected while pricing "..(GetItemInfo(itemLink) or itemLink)..": "..tostring(lowerLimit).." to "..tostring(upperLimit))
		end


        -- Determine the totals from the PDFs
        local delta = (upperLimit - lowerLimit) * .01;

        if #pdfList == 0 or delta < EPSILON or total < EPSILON then
            return;                 -- No PDFs available for this item
        end

        local limit = total * confidence;
        local midpoint, lastMidpoint = 0, 0;

        -- Now find the 50% point
        repeat
            lastMidpoint = midpoint;
            total = 0;

            if not(delta > 0) then
				error("Infinite loop detected during market pricing for "..(GetItemInfo(itemLink) or itemLink))
			end

            for x = lowerLimit, upperLimit, delta do
                for i = 1, #pdfList do
                    local val = pdfList[i](x);
                    total = total + val * delta;
                end

                if total > limit then
                    midpoint = x;
                    break;
                end
            end

            delta = delta * IMPROVEMENT_FACTOR;


            if midpoint ~= midpoint or midpoint == 0 then
                if nLog and midpoint ~= midpoint then
                    nLog.AddMessage("Auctioneer", "Market Pricing", N_WARNING, "Unable To Calculate", "A NaN value was detected while processing the midpoint for PDF of "..(GetItemInfo(itemLink) or itemLink).."... Giving up.");
                elseif nLog then
                    nLog.AddMessage("Auctioneer", "Market Pricing", N_NOTICE, "Unable To Calculate", "A zero total was detected while processing the midpoint for PDF of "..(GetItemInfo(itemLink) or itemLink).."... Giving up.");
                end

                if convergedFallback then
                    if nLog then
                        nLog.AddMessage("Auctioneer", "Market Pricing", N_WARNING, "Fallback Pricing Used", "Fallback pricing used due to NaN/Zero total for item "..itemLink);
                    end
                    return convergedFallback, 1, 1;
                end
                return;                 -- Cannot calculate: NaN
            end

        until abs(midpoint - lastMidpoint)/midpoint < ERROR;

        if midpoint and midpoint > 0 then
            midpoint = floor(midpoint + 0.5);   -- Round to nearest copper

            -- Cache before finishing up
			cache[serverKey][cacheSig] = {midpoint, seen, #pdfList}

            return midpoint, seen, #pdfList;
        else
            if nLog then
                nLog.AddMessage("Auctioneer", "Market Pricing", N_WARNING, "Unable To Calculate", "No midpoint was detected for item "..(GetItemInfo(itemLink) or itemLink).."... Giving up.");
            end
            return;
        end

    end

	-- Clear the cache of Stats engines (called if a new module is registered)
	function private.ClearEngineCache()
		wipe(engines)
	end

    -- Clears the results cache for AucAdvanced.API.GetMarketValue()
    function lib.ClearMarketCache()
		wipe(cache)
    end
end

function lib.ClearItem(itemLink, serverKey)
	local saneLink = SanitizeLink(itemLink)
	local modules = AucAdvanced.GetAllModules("ClearItem")
	for pos, engineLib in ipairs(modules) do
		engineLib.ClearItem(saneLink, serverKey)
	end
	lib.ClearMarketCache()
end

--[[ AucAdvanced.API.IsKeyword(testword [, keyword])
	Determine whether testword is equal to or an alias of keyword
	Returns the keyword if it matches, nil otherwise
	For case-insensitive keywords, tries both unmodified and lowercase
	Note: default cases must be handled separately
--]]
do
	-- allowable keywords (so far): ALL, faction, server
	local keywords = { -- entry: alias = keyword,
		ALL = "ALL",
		faction = "faction",
		server = "server",
		realm = "server",
	}
	-- todo: functions to add new keywords, and to add new aliases for keywords
	function lib.IsKeyword(testword, keyword)
		if type(testword) ~= "string" then return end
		local key = keywords[testword] or keywords[testword:lower()] -- try unmodified and lowercased
		if key then
			if not keyword or keyword == key then
				return key
			end
		end
	end
end

function lib.ClearData(command)
	local serverKey

	-- split command into keyword and extra parts
	local keyword, extra = "server", "" -- default
	if type(command) == "string" then
		local _, ind, key = strfind(command, "(%S+)")
		if key then
			key = lib.IsKeyword(key)
			if key then
				keyword = key -- recognised keyword
				extra = strtrim(strsub(command, ind+1))
			else
				extra = strtrim(command) -- try to resolve whole command (as a realm name or serverKey)
			end
		end
	elseif command then -- only valid types are string or nil
		error("Unrecognised parameter type to ClearData: "..type(command)..":"..tostring(command))
	end

	-- At this point keyword should be one of the strings in the following if-block
	-- extra should be a string, where 'no extra information' is denoted by ""
	if keyword == "ALL" then
		if extra == "" then serverKey = "ALL" end
	elseif keyword == "server" then
		if extra == "" then
			serverKey = Resources.ServerKey
		else
			serverKey = ResolveServerKey(extra)
		end
	elseif keyword == "faction" then
	-- for compatibility we should still process 'faction' keyword, but factions are now irrelevant to serverKeys
		if extra == "" or AucAdvanced.IsFaction(extra) then
			-- previously this would have cleared the current or specified faction on the current server,
			-- but with combined AuctionHouses we should just clear the current server.
			serverKey = Resources.ServerKey
		else
			-- see if extra contains a valid serverKey
			serverKey = ResolveServerKey(extra)
		end
	end

	if serverKey then
		local modules = AucAdvanced.GetAllModules("ClearData")
		for pos, lib in ipairs(modules) do
			lib.ClearData(serverKey)
		end
		lib.ClearMarketCache()
	else
		lib.Print("Auctioneer: Unrecognized keyword or server for ClearData {{"..command.."}}")
	end
end

do --[[ Algorithm Functions ]]--

	local lastAlgorithm, lastLink, lastKey, lastPrice, lastSeen
	local lastNumber, lastNumberLink
	function private.ResetAlgorithms()
		lastLink = nil -- only need to nil this one entry to prevent any cache match
	end

	--[[
		price, seen = AucAdvanced.API.GetAlgorithmValue(algorithm, itemLink, serverKey)
		algorithm is the Name of a module which has a pricing function
		(pricing functions are GetPriceSeen, GetPriceArray, GetPrice)
	--]]
	function lib.GetAlgorithmValue(algorithm, itemLink, serverKey)
		local price, seen
		local module = AucAdvanced.GetModule(algorithm)
		if not module then return end
		serverKey = ResolveServerKey(serverKey)
		if not serverKey then return end
		if type(itemLink) == "number" then
			if itemLink == lastNumber then -- last number cache, to reduce spamming of GetItemInfo
				itemLink = lastNumberLink
			else
				local _, i = GetItemInfo(itemLink)
				lastNumber = itemLink
				itemLink = i
				lastNumberLink = i
			end
		end
		if not itemLink then return end
		local saneLink = SanitizeLink(itemLink)

		if saneLink == lastLink and algorithm == lastAlgorithm and serverKey == lastKey then -- last item cache
			return lastPrice, lastSeen
		end

		local pricefunc = module.GetPriceSeen
		if pricefunc then
			price, seen = pricefunc(saneLink, serverKey)
		else
			pricefunc = module.GetPriceArray
			if pricefunc then
				local array = pricefunc(saneLink, serverKey)
				if array then
					price = array.price
					seen = array.seen
				end
			else
				pricefunc = module.GetPrice
				if pricefunc then
					price = pricefunc(saneLink, serverKey)
				end
			end
		end
		if pricefunc then
			lastAlgorithm, lastLink, lastKey = algorithm, saneLink, serverKey
			lastPrice, lastSeen = price, seen
			return price, seen
		end
	end

	function lib.GetAlgorithms(itemLink)
		local saneLink, getAll
		if itemLink then
			if itemLink == "ALL" then
				getAll = true
			else
				saneLink = SanitizeLink(itemLink)
			end
		end
		local engines, display = {}, {}
		local modules = AucAdvanced.GetAllModules()
		for pos, engineLib in ipairs(modules) do
			if engineLib.GetPrice or engineLib.GetPriceArray or engineLib.GetPriceSeen then
				if getAll or not engineLib.IsValidAlgorithm or engineLib.IsValidAlgorithm(saneLink) then
					tinsert(engines, engineLib.GetName())
					tinsert(display, engineLib.GetLocalName()) -- localized 'display' names in a parallel table
				end
			end
		end
		return engines, display
	end

	function lib.IsValidAlgorithm(algorithm, itemLink)
		local module = AucAdvanced.GetModule(algorithm)
		if module and (module.GetPrice or module.GetPriceArray or module.GetPriceSeen) then
			if module.IsValidAlgorithm then
				return module.IsValidAlgorithm(SanitizeLink(itemLink))
			end
			return true
		end
		return false
	end
end -- of Algorithm functions

--[[ resultsTable = AucAdvanced.API.QueryImage(queryTable, serverKey, reserved, ...)
	'queryTable' specifies the query to perform
	'serverKey' defaults to the current faction
	'reserved' must always be nil
	The working code can be viewed in CoreScan.lua for more details.
--]]
lib.QueryImage = AucAdvanced.Scan.QueryImage

-- unpackedTable = AucAdvanced.API.UnpackImageItem(imageItem)
-- imageItem is one of the values (subtables) in the table returned by QueryImage or GetImageCopy
lib.UnpackImageItem = AucAdvanced.Scan.UnpackImageItem

-- scanStatsTable = AucAdvanced.API.GetScanStats(serverKey)
-- Timestamps: scanstats.LastScan, scanstats.LastFullScan, scanstats.ImageUpdated
-- Scan statistics subtables: scanstats[0] (last scan), scanstats[1], scanstats[2] (two scans prior to last scan)
lib.GetScanStats = AucAdvanced.Scan.GetScanStats

-- imageTable = AucAdvanced.API.GetImageCopy(serverKey)
-- Generates an independent copy of the current scan data image for the specified serverKey
lib.GetImageCopy = AucAdvanced.Scan.GetImageCopy

-- AucAdvanced.API.CompatibilityMode(mode, lock)
-- Set scan compatibility modes, to help avoid having Auctioneer interfere with other AddOns using the AuctionHouse API
lib.CompatibilityMode = AucAdvanced.Scan.CompatibilityMode

function lib.ListUpdate()
	if lib.IsBlocked() then return end
	AucAdvanced.SendProcessorMessage("listupdate")
end

function lib.BlockUpdate(block, propagate)
	local blocked
	if block == true then
		blocked = true
		private.isBlocked = true
		AuctionFrameBrowse:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
	else
		blocked = false
		private.isBlocked = nil
		AuctionFrameBrowse:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
	end

	if (propagate) then
		AucAdvanced.SendProcessorMessage("blockupdate", blocked)
	end
end

function lib.IsBlocked()
	return private.isBlocked == true
end


--[[Progress bars that are usable by any addon.
name = string - unique bar name
value =  0-100   the % the bar should be filled
show =  boolean  true will keep bar displayed, false will hide the bar and free it for use by another addon
text =  string - the text to display on the bar
options = table containing formatting commands.
	options.barColor = { R,G,B, A}   red, green, blue, alpha values.
	options.textColor = { R,G,B, A}   red, green, blue, alpha values.

value, text, color, and options are all optional variables
]]
local ProgressBarFrames = {}
local ActiveProgressBars = {}
-- generate new bars as needed
local function newBar()
	local bar = CreateFrame("STATUSBAR", nil, UIParent, "TextStatusBar")
	bar:SetWidth(300)
	bar:SetHeight(18)
	bar:SetBackdrop({
				bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
				tile=1, tileSize=10, edgeSize=10,
				insets={left=1, right=1, top=1, bottom=1}
			})

	bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	bar:SetStatusBarColor(0.6,0,0,0.6)
	bar:SetMinMaxValues(0,100)
	bar:SetValue(50)
	bar:Hide()

	bar.text = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	bar.text:SetPoint("CENTER", bar, "CENTER")
	bar.text:SetJustifyH("CENTER")
	bar.text:SetJustifyV("CENTER")
	bar.text:SetTextColor(1,1,1)

	tinsert(ProgressBarFrames, bar)
	local newID = #ProgressBarFrames

	if newID > 1 then
		-- attach to previous bar
		bar:SetPoint("BOTTOM", ProgressBarFrames[newID-1], "TOP", 0, 0)
	end
	return newID
end
-- create 1 bar to start for anchoring
newBar()
-- handles the rendering
local function renderBars(ID, name, value, text, options)
	local self = ProgressBarFrames[ID]
	if not self then assert("No bar found available for ID", ID, name, text) end

	-- reset bars that are not in use to defaults
	if self and not name then
		self:Hide()
		self.text:SetText("")
		self:SetStatusBarColor(0.6, 0, 0, 0.6) --light red color
		self.text:SetTextColor(1, 1, 1, 1)
		return
	end

	self:Show()
	--update progress
	if value then
		self:SetValue(value)
	end
	--change bars text if desired
	if text then
		self.text:SetText(text)
	end
	--[[options is a table that contains, "tweaks" ie text or bar color changes
	Nothing below this line will be processed unless an options table is passed]]
	if not options then return end

	--change bars color
	local barColor = options.barColor
	if barColor then
		local r, g, b, a = barColor[1],barColor[2], barColor[3], barColor[4]
		if r and g and b then
			a = a or 0.6
			self:SetStatusBarColor(r, g, b, a)
		end
	end
	--change text color
	local textColor = options.textColor
	if textColor then
		local r, g, b, a = textColor[1],textColor[2], textColor[3], textColor[4]
		if r and g and b then
			a = a or 1
			self.text:SetTextColor(r, g, b, a)
		end
	end
end
--main entry point. Handles which bar will be assigned and recycling bars
function lib.ProgressBars(name, value, show, text, options)
	-- reanchor first bar so we can display even if AH is closed
	if AuctionFrame and AuctionFrame:IsShown() then
		ProgressBarFrames[1]:ClearAllPoints()
		ProgressBarFrames[1]:SetPoint("TOPRIGHT", AuctionFrame, "TOPRIGHT", -5, 5)
	else
		ProgressBarFrames[1]:ClearAllPoints()
		ProgressBarFrames[1]:SetPoint("CENTER", UIParent, "CENTER", 0, 250)
	end

	if type(name) ~= "string" then return end
	if value and type(value) ~= "number" then return end
	if options and type(options) ~= "table" then options = nil end

	local ID = ActiveProgressBars[name]
	if show then
		if ID then -- this is a live bar; update the data table
			local barData = ActiveProgressBars[ID]
			assert(barData[1] == name) -- ### debug
			if value then barData[2] = value end
			if text then barData[3] = text end
			if options then barData[4] = options end
		else -- initialize data table for new bar
			-- get an available bar
			local test = #ActiveProgressBars + 1
			if ProgressBarFrames[test] then
				ID = test
			else
				ID = newBar()
			end
			ActiveProgressBars[ID] = {name, value, text, options}
			ActiveProgressBars[name] = ID
		end
		renderBars(ID, name, value, text, options)
	elseif ID then
		tremove(ActiveProgressBars, ID)
		ActiveProgressBars[name] = nil
		-- move down and re-render higher bars
		for renderID = 1, #ActiveProgressBars + 1 do
			-- first reset/hide every bar
			renderBars(renderID)
			-- then if it is in use re-render from the data table
			local barData = ActiveProgressBars[renderID]
			if barData then
				ActiveProgressBars[barData[1]] = renderID -- update 'name' lookup entry
				renderBars(renderID, barData[1], barData[2], barData[3], barData[4])
			end
		end
	end
end

--[[ Market matcher APIs ]]--

local matcherCurList
local matcherNameLookup
local matcherOrderedEngines
local matcherDropdown
local matcherSelected = 1
function private.ResetMatchers(event, setting)
	if not setting or setting:sub(1, 7) == "profile" then
		matcherCurList = nil
		matcherNameLookup = nil
		matcherOrderedEngines = nil
		matcherDropdown = nil
	end
end

local function RebuildMatcherListLookup()
	matcherCurList = GetSetting("core.matcher.matcherlist")
	if not matcherCurList then
		matcherCurList = {}

		-- Caution: may trigger a call to GetMatcherDropdownList. todo: handle any resulting function re-entry better
		AucAdvanced.Settings.SetSetting("core.matcher.matcherlist", matcherCurList)
	end
	local modules = AucAdvanced.GetAllModules(nil, "Match")
	matcherNameLookup = {}
	for index, engine in ipairs(modules) do
		local name = engine.GetName()
		if type(engine.GetMatchArray) == "function" then
			matcherNameLookup[name] = engine
			local insert = true
			for _, listName in ipairs(matcherCurList) do
				if listName == name then
					insert = false
					break
				end
			end
			if insert then
				AucAdvanced.Print("Auctioneer: New matcher found: "..name)
				tinsert(matcherCurList, name)
			end
		else
			debugPrint("Auctioneer engine '"..name.."' does not have a GetMatchArray() function.", "CoreAPI", "Missing GetMatchArray", "Warning")
		end
	end
end

local function GetMatcherList()
	if not matcherCurList then
		RebuildMatcherListLookup()
	end
	return matcherCurList
end

local function GetMatcherLookup()
	if not matcherNameLookup then
		RebuildMatcherListLookup()
	end
	return matcherNameLookup
end

local function GetMatcherEngines()
	if not matcherOrderedEngines then
		local lookup = GetMatcherLookup()
		local matcherlist = GetMatcherList()
		matcherOrderedEngines = {}
		for index, name in ipairs(matcherlist) do
			local engine = lookup[name]
			if engine then
				tinsert(matcherOrderedEngines, engine)
			end
		end
	end
	return matcherOrderedEngines
end

-- Matcher functions used by CoreSettings for Matcher dropdown list

function libinternal.GetMatcherDropdownList()
	if not matcherDropdown then
		local matcherlist = GetMatcherList()
		matcherDropdown = {}
		for index, name in ipairs(matcherlist) do
			tinsert(matcherDropdown, {index, index..": "..name})
		end
	end
	return matcherDropdown
end

function libinternal.MatcherSetter(setting, value)
	local matcherlist = GetSetting("core.matcher.matcherlist") -- work from the actual saved setting, not matcherCurList (which has probably been reset)
	if not matcherlist then return end
	if setting == "matcher.select" then
		if type(value) == "number" and value >= 1 and value <= #matcherlist then
			matcherSelected = value
			return true
		end
	end
	if not matcherlist[matcherSelected] then
		matcherSelected = 1
		return
	end
	private.ResetMatchers()
	if setting == "matcher.up" then
		local newpos = matcherSelected - 1
		if newpos >= 1 then
			matcherlist[newpos], matcherlist[matcherSelected] = matcherlist[matcherSelected], matcherlist[newpos]
			matcherSelected = newpos
			return true
		end
	elseif setting == "matcher.down" then
		local newpos = matcherSelected + 1
		if newpos <= #matcherlist then
			matcherlist[newpos], matcherlist[matcherSelected] = matcherlist[matcherSelected], matcherlist[newpos]
			matcherSelected = newpos
			return true
		end
	elseif setting == "matcher.delete" then
		tremove(matcherlist, matcherSelected)
		local n = #matcherlist
		if n > 0 and matcherSelected > n then
			matcherSelected = n
		end
		return true
	end
end

function libinternal.MatcherGetter(setting)
	if setting == "matcher.select" then
		return matcherSelected
	end
end

--[[ GetBestMatch(link, algorithm, serverKey)
	Determine base price from algorithm, then pass through all matchers to get the matched price
	Parameters:
		link: full (hyperlink-style) itemLink
		algorithm: "market" or price<number> or algorithm<string, as used by GetAlgorithmVale>
		serverKey: optional serverKey
	Returns:
		price: final price after all matching
		nil: (obsolete)
		count: number of matchers contributing an adjustment to the price
		diff: averaged difference from original price. todo: is performing an average here appropriate?
		matchString: formatted string (including '\n' characters) describing what the matchers have done
--]]
function lib.GetBestMatch(itemLink, algorithm, serverKey)
	local price
	local saneLink = SanitizeLink(itemLink)
	if algorithm == "market" then
		price = lib.GetMarketValue(saneLink, serverKey)
	elseif type(algorithm) == "number" then
		price = algorithm
	else
		price = lib.GetAlgorithmValue(algorithm, saneLink, serverKey)
	end
	if not price then return end

	local matchers = GetMatcherEngines()
	local originalPrice = price
	local count, infoString = 0, ""

	for index = 1, #matchers do
		local matcher = matchers[index]
		local matchArray = matcher.GetMatchArray(saneLink, price, serverKey, originalPrice)
		if matchArray then
			price = matchArray.value
			count = count + 1
			if matchArray.returnstring then
				infoString = infoString.."\n"..matchArray.returnstring -- using two .. is faster than calling strjoin
			end
		end
	end

	if price > 0 then
		return price, nil, count, price - originalPrice, infoString
	end
end

-- Returns the number of installed matchers
-- Normally only used to check if number of matchers is > 0
-- Note: count will include matchers that are installed but disabled
function lib.GetNumMatchers()
	return #(GetMatcherEngines())
end

-- Additional Matcher functions for compatibility

-- Returns an ordered list of matcher names
-- Matchers are installed, and if itemLink was provided, are valid for that item
-- Note: matchers may not be enabled, or may not actually have data for that item
function lib.GetMatchers(itemLink)
	local saneLink = SanitizeLink(itemLink)
	local matchers = GetMatcherEngines()
	local retlist = {}
	for index, matcher in ipairs(matchers) do
		if not saneLink or not matcher.IsValidMatcher or matcher.IsValidMatcher(saneLink) then
			tinsert(retlist, matcher.GetName())
		end
	end
	return retlist
end

-- Checks that the itemLink is valid for the specified matcher
-- Obsolete, as all matchers should return nil from GetMatchArray if they cannot handle the item
-- However may still be useful for external modules to obtain a matcher lib from the name
function lib.IsValidMatcher(matcher, itemLink)
	if type(matcher) == "table" then -- if provided with a table, get the name
		matcher = matcher.GetName and matcher.GetName()
	end
	matcher = GetMatcherLookup()[matcher] -- validate name and get the matcher lib
	if not matcher then return end
	local saneLink = SanitizeLink(itemLink)
	if not saneLink or not matcher.IsValidMatcher or matcher.IsValidMatcher(saneLink) then
		return matcher
	end
end

-- Allows external modules to request individual matcher values using matcher's name
function lib.GetMatcherValue(matcher, itemLink, price, serverKey, originalPrice)
	if type(matcher) == "table" then
		matcher = matcher.GetName and matcher.GetName()
	end
	matcher = GetMatcherLookup()[matcher]
	if not matcher then return end
	local saneLink = SanitizeLink(itemLink)
	local matchArray = matcher.GetMatchArray(saneLink, price, serverKey, originalPrice)
	if not matchArray then
		matchArray = {
			value = price,
			diff = 0,
		}
	end
	return matchArray.value, matchArray
end


-- Auctioneer Signature (sig) functions

-- Creates an AucAdvanced signature from an item or battlepet link
function lib.GetSigFromLink(link)
	local sig
	local ptype = type(link)
	if ptype == "number" then
		return ("%d"):format(link), "item"
	elseif ptype ~= "string" then
		return
	end
	local header,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14 = strsplit(":", link, 15)
	if not s1 then
		return
	end
	local lType = header:sub(-4)
	if lType == "item" then
		-- sig format: itemID:suffix:factor:enchant:bonus1:...:bonusX {any trailing ":0" are ommitted}
		-- s1 = itemID, s2 = enchant, s3,s4,s5,s6 = gems, s7 = suffix, s8 = uniqueID(factor), s9 = level, s10 = specID, s11 = upgrades, s12 = instance
		-- s13 = bonusIDcount, s14 = tail (including bonusIDs)
		-- some entries are not used: gems, level, upgrades, instance
		-- for compatibility with old or partial links, test for nils

		local bonus = private.GetBonuses(s13, s14)
		if s2 == "" then s2 = "0" end -- HYBRID6 code, review after Legion

		if s8 and s7 ~= "0" and s7 ~= "" then -- suffix
			local factor = "0"
			if s7:byte(1) == 45 then -- look for '-' to see if it is a negative number
				local nseed = tonumber(s8) -- seed
				if nseed then
					factor = ("%d"):format(bitand(nseed, 65535)) -- here format is faster than tostring
				end
			end
			if bonus then
				sig = s1..":"..s7..":"..factor..":"..s2..":"..bonus
			elseif s2 ~= "0" then -- enchant
				-- concat is slightly faster than using strjoin with this many parameters, and far faster than format
				sig = s1..":"..s7..":"..factor..":"..s2
			elseif factor ~= "0" then
				sig = s1..":"..s7..":"..factor
			else
				sig = s1..":"..s7
			end
		else
			if bonus then -- (if bonus then s13 exists, therefore s2 must exist)
				sig = s1..":0:0:"..s2..":"..bonus
			elseif s2 and s2 ~= "0" then
				sig = s1..":0:0:"..s2
			else
				sig = s1
			end
		end
		return sig, "item"
	elseif lType == "epet" then -- last 4 characters of battlepet
		-- sig format: "P":speciesID:level:quality:health:power:speed
		-- s1 = speciesID, s2 = level, s3 = quality, s4 = health, s5 = power, s6 = speed
		-- if any are missing then the link is broken - check that the last one exists
		-- all should always be non-zero, so just rebuild with the battlepet sig "P" marker
		if s7 then -- although s7 is not used, it should exist (contains battlepetID and tail)
			-- strjoin starts to become efficient with this many parameters
			return strjoin(":", "P", s1, s2, s3, s4, s5, s6), "battlepet"
		end
	end
end

-- Creates an item or battlepet link from an AucAdvanced signature
-- Due to the lossy nature of sigs, the link created will not be exactly the same as the link originally used to generate the sig
function lib.GetLinkFromSig(sig)
	if sig:byte(1) == 80 then -- "P" is battlepet tag
		local _, speciesID, level, quality, health, power, speed = strsplit(":", sig)
		if not speed then return end -- incomplete link
		local speciesID = tonumber(speciesID)
		if not speciesID then return end
		local qual = tonumber(quality)
		local qual_col
		if qual == -1 then
			qual_col = NORMAL_FONT_COLOR_CODE
		else
			qual_col = ITEM_QUALITY_COLORS[qual] -- "|cffxxxxxx"
		end
		if not qual_col then return end
		local name = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
		if not name then return end
		local petlink = format("%s|Hbattlepet:%s:%s:%s:%s:%s:%s:0|h[%s]|h|r", qual_col.hex, speciesID, level, quality, health, power, speed, name)
		return petlink, name, "battlepet"
	else
		local itemID, suffix, factor, enchant, tail = strsplit(":", sig, 5)
		local bonus = "0"
		if tail then -- sig includes bonus info, reconstruct the counter
			local _, count = tail:gsub(":", ":")
			bonus = (count + 1) .. ":" .. tail
		end
		local itemstring = format("item:%s:%s:0:0:0:0:%s:%s:80:0:0:0:%s", itemID, enchant or "0", suffix or "0", factor or "0", bonus)
		local name, link = GetItemInfo(itemstring)
		if link then
			return SanitizeLink(link), name, "item" -- name is ignored by most calls
		end
	end
end

-- Decodes an AucAdvanced signature into numerical values
-- Can be compared to the return values from DecodeLink
-- The first return value is the linkType
-- Subsequent return values have different meanings depending on the linkType
function lib.DecodeSig(sig)
	if type(sig) ~= "string" then return end
	if sig:byte(1) == 80 then -- "P" is battlepet tag
		local _, speciesID, level, quality, health, power, speed = strsplit(":", sig)
		speciesID = tonumber(speciesID)
		if not speciesID or speciesID == 0 then return end
		level = tonumber(level) or 0 -- 0 signifies unknown level
		quality = tonumber(quality) or -1 -- -1 signifies unknown quality
		health = tonumber(health) or 0
		power = tonumber(power) or 0
		speed = tonumber(speed) or 0
		return "battlepet", speciesID, level, quality, health, power, speed
	else
		-- should be an item sig
		local itemID, suffix, factor, enchant, bonus = strsplit(":", sig, 5)
		itemID = tonumber(itemID)
		if not itemID or itemID == 0 then return end
		suffix = tonumber(suffix) or 0
		factor = tonumber(factor) or 0
		enchant = tonumber(enchant) or 0
		-- bonus may be a string or nil

		-- linkType,itemId, suffix,factor,enchant,seed, gem1,gem2,gem3,gemBonus, bonuses(string)
		-- (to match return values we need to pad with 0s, we can fake 'seed' with factor)
		return "item",itemID, suffix,factor,enchant,factor, 0,0,0,0, bonus
	end
end

-- Auctioneer StoreKey functions

-- Store keys are for use in saved variable storage structures
-- returns id, property, linktype (all strings)
-- note that id will be a string containing a plain number for all link types
-- the property string contains different internal markers for different link types
-- most Stat modules pack all properties for the same id into a single string
-- if petBand is a number it will be used to compress the petLevel such that pets of a similar level get the same key
function lib.GetStoreKeyFromLink(link, petBand)
	local header,s1,s2,s3,s4,s5,s6,s7,s8 = strsplit(":", link)
	local lType = header:sub(-4)
	if lType == "item" then
		if s7 and s7 ~= "0" and s7 ~= "" then -- s7 = suffix
			if s7:byte(1) == 45 then -- look for '-' to see if it is a negative number
				local factor = tonumber(s8) -- s8 = seed
				if factor then
					factor = bitand(factor, 65535)
					if factor ~= 0 then
						-- the following construction appears to be faster than just using a single, more complicated, format call
						return s1, s7.."x"..format("%d", factor), "item" -- "itemId", "suffix..x..factor", linktype
					end
				end
			end
			return s1, s7, "item" -- "itemId", "suffix", linktype
		end
		return s1, "0", "item" -- "itemId", "suffix", linktype
	elseif lType == "epet" then -- last 4 characters of "battlepet"
		-- check that caller wants pet keys
		-- also check valid quality (-1 represents 'unknown' and so is not valid for store key)
		if petBand and s3 and s3 ~= "-1" and s3 ~= "" then
			local level = tonumber(s2) -- level
			if not level or level < 1 then return end
			if petBand > 1 then
				level = ceil(level / petBand)
			end
			return s1, format("%d", level).."p"..s3, "battlepet" -- "speciesID", "compressedLevel..p..quality", linktype
		end
	end
end

-- Generate Store Key as above, but from a sig
function lib.GetStoreKeyFromSig(sig, petBand) -- not used anywhere, consider deprecating
	local s1,s2,s3,s4 = strsplit(":", sig)
	if s1 == "P" then -- battlepet sig
		if petBand and s4 and s4 ~= "-1" then
			local level = tonumber(s3) -- level
			if not level or level < 1 then return end
			if petBand > 1 then
				level = ceil(level / petBand)
			end
			return s2, format("%d", level).."p"..s4, "battlepet" -- "speciesID", "compressedLevel..p..quality", linktype
		end
	else -- item sig
		if s3 and s3 ~= "0" then -- factor
			return s1, s2.."x"..s3, "item" -- "itemId", "suffix..x..factor", linktype
		elseif s2 then
			return s1, s2, "item" -- "itemId", "suffix", linktype
		else
			return s1, "0", "item" -- "itemId", "suffix", linktype
		end
	end
end

do -- Store key style 'B'
	-- returns id, property, linktype (all strings)
	-- items:
	--    id will be a string containing a plain number
	--    property will be a string, which may be "0", a negative suffix, or a set of bonusIDs (separated by ':' if more than one)
	--    *Note* old-style positive suffixes are considered invalid links, and will cause a nil return. However, suffixes from bonusIDs are positive
	-- battlepets:
	--    id will be a string of format "P"..number
	--    property will be a string of format number.."p"..number
	--    if petBand is a number it will be used to compress the petLevel such that pets of a similar level get the same key
	--    if petBand is nil, function will return nil for all battlepets
	local lastLink, lastPetband, lastID, lastProperty, lastLinktype
	function lib.GetStoreKeyFromLinkB(link, petBand)
		-- check if link is in last call cache
		if link == lastLink then
			if lastLinktype == "item" then
				return lastID, lastProperty, lastLinktype
			elseif lastLinktype == "battlepet" then
				-- only check petBand for battlepets (actually unlikely to match as most Stat modules use different petBands)
				if petBand == lastPetband then
					return lastID, lastProperty, lastLinktype
				end
			end
		end
		-- otherwise analyze link
		local header,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14 = strsplit(":", link, 15)
		if not s1 then return end
		local lType = header:sub(-4)
		if lType == "item" then
			if s7 and s7 ~= "0" and s7 ~= "" then -- s7 = suffix
				if s7:byte(1) == 45 then -- look for '-' to see if it is a negative number
					lastLink, lastID, lastProperty, lastLinktype = link, s1, s7, "item" -- link, itemId, suffix, linktype
					return lastID, lastProperty, lastLinktype
				end
				-- if suffix is not 0 and not negative, then link is corrupt - will return nil
			else
				local bonuses = private.GetBonuses(s13, s14)
				if bonuses then
					local property = lib.GetBonusIDPropertyB(bonuses)
					if property then
						lastLink, lastID, lastProperty, lastLinktype = link, s1, property, "item" -- link, itemID, bonusIDproperty, linktype
						return lastID, lastProperty, lastLinktype
					end
				end
				lastLink, lastID, lastProperty, lastLinktype = link, s1, "0", "item" -- itemID, 'suffix', linktype
				return lastID, lastProperty, lastLinktype
			end
		elseif lType == "epet" then -- last 4 characters of "battlepet"
			-- check that caller wants pet keys
			-- also check valid quality (-1 represents 'unknown' and so is not valid for store key)
			if petBand and s3 and s3 ~= "-1" and s3 ~= "" then
				local level = tonumber(s2) -- level
				if not level or level < 1 then return end
				if petBand > 1 then
					level = ceil(level / petBand)
				end
				-- link, petBand, "P"..speciesID, compressedLevel.."p"..quality, linktype (lastPetband is only recorded for battlepets, as it's ignored by other type(s))
				lastLink, lastPetband, lastID, lastProperty, lastLinktype = link, petBand, "P"..s1, format("%d", level).."p"..s3, "battlepet"
				return lastID, lastProperty, lastLinktype
			end
		end
	end
end

do -- Auctioneer bonusID handling functions
	local bonusIDPatterns, ParseTail = AucAdvanced.GetBonusIDStringTools()
	local LookupSuffix, LookupStat, LookupTier, LookupStage = {}, {}, {}, {}
	local LookupWarforged, LookupSocket, LookupTertiary = {}, {}, {}
	local LookupTierB = {} -- used by GetBonusIDPropertyB

	function private.InitBonusIDHandlers()
		private.InitBonusIDHandlers = nil
		-- Build Lookups
		LookupSuffix = Data.BonusSuffixMap
		for _, x in ipairs(Data.BonusPrimaryStatList) do
			local y = tostring(x)
			LookupStat[y] = y
		end
		for _, x in ipairs(Data.BonusWarforgedList) do
			local y = tostring(x)
			LookupWarforged[y] = y
		end
		for _, x in ipairs(Data.BonusSocketedList) do
			local y = tostring(x)
			LookupSocket[y] = y
		end
		for _, x in ipairs(Data.BonusTertiaryStatList) do
			local y = tostring(x)
			LookupTertiary[y] = y
		end

		for _, x in ipairs(Data.BonusTierList) do
			local y = tostring(x)
			LookupTier[y] = y
			LookupTierB[y] = y
		end
		for _, x in ipairs(Data.BonusCraftedStageList) do
			local y = tostring(x)
			LookupStage[y] = y
			if y ~= "525" then -- special exception: do not include Stage 1 (basic item) in this table
				LookupTierB[y] = y
			end
		end
	end

	function private.GetBonuses(s13, s14) -- expects the s13 and s14 results from strsplit, see above
		if not s14 or s14 == "" or s13 == "" or s13 == 0 then return end
		-- s13 contains count of bonusIDs, s14 contains tail of string starting with bonusIDs plus other stuff after
		-- Refer to LibAucsplitBonus.lua in Tiphelper for more info
		local pattern = bonusIDPatterns[s13]
		if pattern then -- for small numbers of bonusIDs we can look up a pattern to save time
			return s14:match(pattern)
		else
			return ParseTail(s13, s14)
		end
	end

	-- Function to identify bonusIDs representing suffixes, and to return a normlized version of that suffix
	-- All variants of a particular suffix are mapped to a single value (e.g. all bonusIDs representing "of the Fireflash" return "29")
	-- The parameter 'bonus' must be a string containing a single bonusID, not the full 'bonuses' string
	function lib.GetNormalizedBonusIDSuffix(bonus)
		return LookupSuffix[bonus]
	end

	-- Generate a signature for a set of bonusIDs, contained in bonuses string
	-- Intended for comparison operations, such as QueryImage
	-- optional include table specifies which types of bonusID to include in the sig:
	--    suffix : normalize suffix
	--    primary : primary stat
	--    tier : upgrade tiers (dropped items)
	--    stage : upgrade stages (crafted items, includes Stage 1)
	--    stage2 : upgrade stages (crafted items, excludes Stage 1)
	--    warforged
	--    socket
	--    minor : minor stats (Leech, Avoidance, etc.)
	local defaultinclude = {
		suffix = true,
		primary = true,
		tier = true,
		stage = true,
		warforged = true,
		socket = true,
		minor = true,
	}
	local compile = {}
	function lib.GetBonusIDSig(bonuses, include)
		local suffix, primary, tier, stage, warforged, socket, minor
		if type(bonuses) ~= "string" then return end
		if type(include) ~= "table" then
			include = defaultinclude
		end

		-- parse the bonuses string into the various locals
		for bonus in bonuses:gmatch("%d+") do
			local x = LookupStat[bonus]
			if x then
				if include.primary then primary = x end
			else
				x = LookupTier[bonus]
				if x then
					if include.tier then tier = x end
				else
					x = LookupStage[bonus]
					if x then
						if include.stage then stage = x
						elseif include.stage2 then
							if x ~= "525" then stage = x end
						end
					else
						x = LookupWarforged[bonus]
						if x then
							if include.warforged then warforged = x end
						else
							x = LookupSocket[bonus]
							if x then
								if include.socket then socket = x end
							else
								x = LookupTertiary[bonus]
								if x then
									if include.minor then minor = x end
								else
									x = lib.GetNormalizedBonusIDSuffix(bonus)
									if x then
										if include.suffix then suffix = x
										else suffix = bonus end
									end
								end
							end
						end
					end
				end
			end
		end
		-- compile bonusIDs in a specific order
		local n = 0
		if suffix then
			n = n + 1
			compile[n] = suffix
		end
		if primary then
			n = n + 1
			compile[n] = primary
		end
		if tier then
			n = n + 1
			compile[n] = tier
		end
		if stage then
			n = n + 1
			compile[n] = stage
		end
		if warforged then
			n = n + 1
			compile[n] = warforged
		end
		if socket then
			n = n + 1
			compile[n] = socket
		end
		if minor then
			n = n + 1
			compile[n] = minor
		end

		if n > 0 then
			return tconcat(compile, ":", 1, n)
		end
	end

	-- Generate a 'property' string for a type B StoreKey from the bonuses string
	-- Primarily used in GetStoreKeyFromLinkB
	-- Exported for use by other modules, could be used as a sort of sig to identify "similar" items
	function lib.GetBonusIDPropertyB(bonuses)
		local property, suffix, stat, tier, warforged
		if type(bonuses) ~= "string" then return end

		-- parse the bonuses string to pick out suffix, stat, tier and/or warforged entries
		for bonus in bonuses:gmatch("%d+") do
			local x = LookupTierB[bonus]
			if x then
				tier = x
			else
				x = LookupStat[bonus]
				if x then
					stat = x
				else
					x = LookupWarforged[bonus]
					if x then
						warforged = x
					else
						x = lib.GetNormalizedBonusIDSuffix(bonus)
						if x then
							suffix = x
						end
					end
				end
			end
		end

		-- compile the property string in a specific order: suffix, stat, tier, warforged
		-- from experimentation, the most common combinations are: suffix, suffix + stat, tier, tier + warforged
		if suffix then
			property = suffix
		end
		if stat then
			if property then
				property = property..":"..stat
			else
				property = stat
			end
		end
		if tier then
			if property then
				property = property..":"..tier
			else
				property = "0"..tier -- tag "optional" bonusIDs with a leading 0
			end
		end
		if warforged then
			if property then
				property = property..":"..warforged
			else
				property = "0"..warforged -- tag "optional" bonusIDs with a leading 0
			end
		end

		return property
	end

end -- end bonusID functions

-- Timer functions

-- Wrapper around C_Timer.After with parameter checks
function lib.TimerCallback(duration, callback)
	if type(duration) ~= "number" or type(callback) ~= "function" then return end
	return C_Timer.After(duration, callback)
end


-------------------------------------------------------------------------------
-- Statistical devices created by Matthew 'Shirik' Del Buono
-- For Auctioneer
-------------------------------------------------------------------------------
local pi = math.pi
local sqrtpi = math.sqrt(pi)
local sqrtpiinv = 1 / sqrtpi
local sqrt2pi = math.sqrt(2 * pi)
local exp = math.exp
local bellCurveMeta = {
	__index = {
		SetParameters = function(self, mean, stddev, area)
			if stddev == 0 then
				error("Standard deviation cannot be zero")
			elseif stddev ~= stddev then
				error("Standard deviation must be a real number")
			end

			--need to prevent obsurdly small stddevs like 1e-11, as they cause freeze-ups
			if stddev < 0.1 then
				stddev = 0.1
			end

			area = area or 1 -- area is an optional parameter, defaulting to 1
			self.area = area
			self.mean = mean
			self.stddev = stddev
			self.param1 = area / (stddev * sqrt2pi)
			self.param2 = 2 * stddev^2
		end
	},

	-- Simple bell curve call
	__call = function(self, x)
		return self.param1 * exp(-(x - self.mean)^2 / self.param2)
	end
}
-------------------------------------------------------------------------------
-- Creates a bell curve object that can then be manipulated to pass
-- as a PDF function. This is a recyclable object -- the mean and
-- standard deviation can be updated as necessary so that it does not have
-- to be regenerated
--
-- Note: This creates a bell curve with a standard deviation of 1 and
-- mean of 0. You will probably want to update it to your own desired
-- values by calling return:SetParameters(mean, stddev, area)
-------------------------------------------------------------------------------
function lib.GenerateBellCurve()
    return setmetatable({mean=0, stddev=1, param1=sqrtpiinv, param2=2, area=1}, bellCurveMeta)
end

-- Dumps out market pricing information for debugging. Only handles bell curves for now.
function lib.DumpMarketPrice(itemLink, serverKey)
	local modules = AucAdvanced.GetAllModules(nil, "Stat")
	for pos, engineLib in ipairs(modules) do
		local success, result = pcall(engineLib.GetItemPDF, itemLink, serverKey)
		if success then
			if getmetatable(result) == bellCurveMeta then
				print(engineLib.GetName()..": Mean = "..result.mean..", Standard Deviation = "..result.stddev..", Area = "..result.area)
			else
				print(engineLib.GetName() .. ": Non-BellCurve PDF: " .. tostring(result))
			end
		else
			print(engineLib.GetName() .. ": Reported error: " .. tostring(result))
		end
	end
end

--[[===========================================================================
--|| Deprecation Alert Functions
--||=========================================================================]]
do
    local SOURCE_PATTERN = "([^\\/:]+:%d+): in function `([^\"']+)[\"']";
    local seenCalls = {};
    local uid = 0;

    -------------------------------------------------------------------------------
    -- Shows a deprecation alert. Indicates that a deprecated function has
    -- been called and provides a stack trace that can be used to help
    -- find the culprit.
    -- @param replacementName (Optional) The displayable name of the replacement function
    -- @param comments (Optional) Any extra text to display
    -------------------------------------------------------------------------------
    function lib.ShowDeprecationAlert(replacementName, comments)
        local caller, source, functionName =
            debugstack(3):match(SOURCE_PATTERN),        -- Keep in mind this will be truncated to only the first in the tuple
            debugstack(2):match(SOURCE_PATTERN);        -- This will give us both the source and the function name

        functionName = functionName .. "()";

        -- Check for this source & caller combination
        seenCalls[source] = seenCalls[source] or {};
        if not seenCalls[source][caller] then
            -- Not warned yet, so warn them!
            seenCalls[source][caller]=true
            -- Display it
            AucAdvanced.Print(
                "Auctioneer: "..
                functionName .. " has been deprecated and was called by |cFF9999FF"..caller:match("^(.+)%.[lLxX][uUmM][aAlL]:").."|r. "..
                (replacementName and ("Please use "..replacementName.." instead. ") or "")..
                (comments or "")
            );
	        geterrorhandler()(
	            "Deprecated function call occurred in Auctioneer API:\n     {{{Deprecated Function:}}} "..functionName..
	                "\n     {{{Source Module:}}} "..source:match("^(.+)%.[lLxX][uUmM][aAlL]:")..
	                "\n     {{{Calling Module:}}} "..caller:match("^(.+)%.[lLxX][uUmM][aAlL]:")..
	                "\n     {{{Available Replacement:}}} "..(replacementName or "None")..
	                (comments and "\n\n"..comments or "")
			)
		end



    end

end


AucAdvanced.RegisterRevision("$URL: Auc-Advanced/CoreAPI.lua $", "$Rev: 6420 $")
AucAdvanced.CoreFileCheckOut("CoreAPI")
