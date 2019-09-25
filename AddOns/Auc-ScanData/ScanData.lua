--[[
	Auctioneer - ScanData
	Version: 8.2.6365 (SwimmingSeadragon)
	Revision: $Id: ScanData.lua 6365 2019-09-22 00:20:05Z none $
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
--]]
if not AucAdvanced then return end

local libType, libName = "Util", "ScanData"
local AddOnName = ...
local lib,parent,private = AucAdvanced.NewModule(libType, libName, nil, nil, AddOnName)
if not lib then return end

local DATABASE_VERSION = 1.4
local INTERFACE_VERSION = "A" -- must match CoreScan's SCANDATA_VERSION

local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill,_TRANS = AucAdvanced.GetModuleLocals()

private.distributionCache = {}
private.worthCache = {}

local Const = AucAdvanced.Const
local Resources = AucAdvanced.Resources
local QueryImage = AucAdvanced.API.QueryImage
local PriceCalcLevel = AucAdvanced.Modules.Util.PriceLevel and AucAdvanced.Modules.Util.PriceLevel.CalcLevel
local ResolveServerKey = AucAdvanced.ResolveServerKey

local CONST_LINK, CONST_FLAG = Const.LINK, Const.FLAG

local type = type
local pairs = pairs
local format = format
local floor = floor
local tostring, strjoin = tostring, strjoin
local tinsert, tremove, tconcat, unpack, wipe = tinsert, tremove, table.concat, unpack, wipe

local colorDist = {
	exact = { red=0, orange=0, yellow=0, green=0, blue=0 },
	suffix = { red=0, orange=0, yellow=0, green=0, blue=0 },
	base = { red=0, orange=0, yellow=0, green=0, blue=0 },
    stack = { },
	all = { red=0, orange=0, yellow=0, green=0, blue=0 },
}

--[[ MODULE FUNCTIONS ]]--

lib.Processors = {}
function lib.Processors.scanstats()
	wipe(private.distributionCache)
	wipe(private.worthCache)
end

local tmp = {}
function lib.Colored(doIt, counts, alt, shorten)
	local n=0
	if (counts.blue > 0) then
		n=n+1
		if shorten and counts.blue>=1000 then
			tmp[n] = format("|cff3399ff%dk|r", floor(counts.blue/1000+0.5))
		else
			tmp[n] = format("|cff3399ff%d|r", counts.blue)
		end
	end
	if (counts.green > 0) then
		n=n+1
		if shorten and counts.green>=1000 then
			tmp[n] = format("|cff33ff44%dk|r", floor(counts.green/1000+0.5))
		else
			tmp[n] = format("|cff33ff44%d|r", counts.green)
		end
	end
	if (counts.yellow > 0) then
		n=n+1
		if shorten and counts.yellow>=1000 then
			tmp[n] = format("|cffffff00%dk|r", floor(counts.yellow/1000+0.5))
		else
			tmp[n] = format("|cffffff00%d|r", counts.yellow)
		end
	end
	if (counts.orange > 0) then
		n=n+1
		if shorten and counts.orange>=1000 then
			tmp[n] = format("|cffff9900%dk|r", floor(counts.orange/1000+0.5))
		else
			tmp[n] = format("|cffff9900%d|r", counts.orange)
		end
	end
	if (counts.red > 0) then
		n=n+1
		if shorten and counts.red>=1000 then
			tmp[n] = format("|cffff0000%dk|r", floor(counts.red/1000+0.5))
		else
			tmp[n] = format("|cffff0000%d|r", counts.red)
		end
	end
	local text = tconcat(tmp, " / ", 1, n)
	if alt then
		if text and text ~= "" then
			text = "( "..text.." )"
		else
			text = alt
		end
	end
	return text
end

local query = {} -- resuable table
function lib.GetImageCounts(hyperlink, maxPrice, items, serverKey)
	if type(hyperlink) == "number" then
		query.itemId = hyperlink
		query.suffix = 0
		query.factor = 0
	else
		local linkType, id, suffix, factor = decode(hyperlink)
		if linkType == "item" then
			query.itemId = id
			query.suffix = suffix
			query.factor = factor
			query.speciesID = nil
			query.quality = nil
			query.minItemLevel = nil
			query.maxItemLevel = nil
		elseif linkType == "battlepet" then
			query.speciesID = id
			query.quality = factor
			query.minItemLevel = suffix
			query.maxItemLevel = suffix
			query.itemId = 82800
			query.suffix = nil
			query.factor = nil
		else
			return
		end
	end
	local image = QueryImage(query, serverKey)

	local totalBid, totalBuy = 0, 0

	for i=1, #image do
		local item = image[i]
		local count = item[Const.COUNT]
		local bid = item[Const.PRICE]
		local buy = item[Const.BUYOUT]

		local matched = false
		if maxPrice then
			if buy > 0 and buy <= maxPrice then
				totalBuy = totalBuy + count
				matched = true
			elseif bid <= maxPrice then
				totalBid = totalBid + count
				matched = true
			end
		else
			if buy > 0 then
				totalBuy = totalBuy + count
				matched = true
			else
				totalBid = totalBid + count
				matched = true
			end
		end
		if items and matched then
			tinsert(items, item)
		end
	end

	return totalBuy, totalBid
end

local query1 = {} -- only 1 field itemId
function private.GetPetDistribution(hyperlink, serverKey, iSpeciesId, iLevel, iQuality)
	-- in future it may be possible to merge this function back into GetDistribution
	iSpeciesId = tostring(iSpeciesId) -- we're going to be comparing this to strings
	local sig = serverKey..iSpeciesId.."^"..iLevel.."^"..iQuality -- we're sharing a cache with items, so use different dividers
	if private.distributionCache[sig] then return unpack(private.distributionCache[sig]) end

	local exact, suffix, base, myColors = 0,0,0,{}
	for k,v in pairs(colorDist) do
		myColors[k] = {}
		for c,n in pairs(v) do
			myColors[k][c] = 0
		end
	end

	query1.itemId = 82800
	local image = QueryImage(query1, serverKey)
	local sigTemplate = serverKey..iSpeciesId.."^%d^%d" -- different dividers than for item sigs
	for i=1, #image do
		local item = image[i]
		local vLink = item[Const.LINK]
		local _, vSpeciesId = strsplit(":", vLink)
		if vSpeciesId == iSpeciesId then
			local vLevel = item[Const.ILEVEL]
			local vQuality = item[Const.QUALITY]
			-- Pet Cages are not stackable so count is always 1

			local vColor
			if (PriceCalcLevel) then
				local _
				local vBid = item[Const.PRICE]
				local vBuy = item[Const.BUYOUT]
				local vSig = sigTemplate:format(vLevel, vQuality)
				_,_,_,_,_, vColor, private.worthCache[vSig] = PriceCalcLevel(vLink, 1, vBid, vBuy, private.worthCache[vSig], serverKey)
			end

			if (vQuality == iQuality) then
				if (vLevel == iLevel) then
					exact = exact + 1
					if (vColor) then
						myColors.exact[vColor] = myColors.exact[vColor] + 1
					end
				else
					suffix = suffix + 1
					if (vColor) then
						-- keeping this as .suffix, even though it actually represents a match in quality
						myColors.suffix[vColor] = myColors.suffix[vColor] + 1
					end
				end
			else
				base = base + 1
				if (vColor) then
					myColors.base[vColor] = myColors.base[vColor] + 1
				end
			end
			if (vColor) then
				myColors.all[vColor] = myColors.all[vColor] + 1
				-- Set up colours per stack size as well
				-- todo: Pet Cages don't stack, do we really need to do this? kept for now as cloned from GetDistribution
				if not myColors.stack[1] then myColors.stack[1] =  { red=0, orange=0, yellow=0, green=0, blue=0 } end
				myColors.stack[1][vColor] = myColors.stack[1][vColor] + 1
			end
		end
	end

	private.distributionCache[sig] = {exact, suffix, base, myColors}
	return exact, suffix, base, myColors
end
function lib.GetDistribution(hyperlink, serverKey)
	serverKey = serverKey or Resources.ServerKey
	local iType, iID, iSuffix, iFactor = decode(hyperlink)
	if iType == "battlepet" then
		return private.GetPetDistribution(hyperlink, serverKey, iID, iSuffix, iFactor)
	elseif iType ~= "item" then
		return
	end
	local sig = serverKey..iID..":"..iSuffix..":"..iFactor
	if private.distributionCache[sig] then return unpack(private.distributionCache[sig]) end

	local exact, suffix, base, myColors = 0,0,0,{}
	for k,v in pairs(colorDist) do
		myColors[k] = {}
		for c,n in pairs(v) do
			myColors[k][c] = 0
		end
	end

	query1.itemId = iID
	local image = QueryImage(query1, serverKey)
	local sigTemplate = serverKey..iID..":%d:%d"
	for i=1, #image do
		local item = image[i]
		local vSuffix = item[Const.SUFFIX]
		local vFactor = item[Const.FACTOR]
		local vCount = item[Const.COUNT]

		local vColor
		if (PriceCalcLevel) then
			local _
			local vLink = item[Const.LINK]
			local vBid = item[Const.PRICE]
			local vBuy = item[Const.BUYOUT]
			local vSig = sigTemplate:format(vSuffix, vFactor)
			_,_,_,_,_, vColor, private.worthCache[vSig] = PriceCalcLevel(vLink, vCount, vBid, vBuy, private.worthCache[vSig], serverKey)
		end

		if (vSuffix == iSuffix) then
			if (vFactor == iFactor) then
				exact = exact + vCount
				if (vColor) then
					myColors.exact[vColor] = myColors.exact[vColor] + vCount
				end
			else
				suffix = suffix + vCount
				if (vColor) then
					myColors.suffix[vColor] = myColors.suffix[vColor] + vCount
				end
			end
		else
			base = base + vCount
			if (vColor) then
				myColors.base[vColor] = myColors.base[vColor] + vCount
			end
		end
		if (vColor) then
			myColors.all[vColor] = myColors.all[vColor] + vCount
			-- Set up colours per stack size as well.
			if not myColors.stack[vCount] then myColors.stack[vCount] =  { red=0, orange=0, yellow=0, green=0, blue=0 } end
			myColors.stack[vCount][vColor] = myColors.stack[vCount][vColor] + vCount
		end
	end

	private.distributionCache[sig] = {exact, suffix, base, myColors}
	return exact, suffix, base, myColors
end

function lib.Processors.itemtooltip(callbackType, tooltip, hyperlink, serverKey, quantity, decoded, additional, order)
	if not get("scandata.tooltip.display") then return  end

	tooltip:SetColor(0.3, 0.9, 0.8)

	local doColor = true
	local exact, suffix, base, dist = lib.GetDistribution(hyperlink, serverKey)
	if not exact then return end

	if base+suffix+exact <= 0 then
		tooltip:AddLine("No matches in image.")
	else
		if get("scandata.tooltip.modifier") and IsShiftKeyDown() then
			tooltip:AddLine("Items in image:")
			if (exact > 0) then
				tooltip:AddLine("  |cffddeeff"..exact.."|r exact "..lib.Colored(doColor, dist.exact, "matches"))
			end
			if (suffix > 0) then
				tooltip:AddLine("  |cffddeeff"..suffix.."|r suffix "..lib.Colored(doColor, dist.suffix, "matches"))
			end
			if (base > 0) then
				tooltip:AddLine("  |cffddeeff"..base.."|r base "..lib.Colored(doColor, dist.base, "matches"))
			end
			if (dist.stack) then
				for stackSize, stackColor in pairs(dist.stack) do
					tooltip:AddLine("  Stacks of "..stackSize.."  "..lib.Colored(doColor, stackColor, "in image"))
				end
			end
		else
			if (suffix+base > 0) then
				tooltip:AddLine("|cffddeeff"..exact.." +"..(suffix+base).."|r matches "..lib.Colored(doColor, dist.all, "in image"))
			else
				tooltip:AddLine("|cffddeeff"..exact.."|r matches "..lib.Colored(doColor, dist.exact, "in image"))
			end
		end
	end
end
lib.Processors.battlepettooltip = lib.Processors.itemtooltip

--[[ DATABASE FUNCTIONS ]]--
function lib.GetAddOnInfo()
	return private.isLoaded, INTERFACE_VERSION
end

private.dataCache = {}
function lib.GetScanData(serverKey)
	if not private.isLoaded then
		return nil, "Not Loaded"
	end
	serverKey = ResolveServerKey(serverKey)
	if not serverKey then
		debugPrint("AucScanData: invalid serverKey passed to GetScanData", "ScanData", "Invalid serverKey", "Error")
		return nil, "Invalid serverKey"
	end

	local cache = private.dataCache[serverKey]
	if cache then return cache end

	local livedata = serverKey == Resources.ServerKey -- 'live' data can be changed by scanning
	local scandata = AucScanData.scans[serverKey]
	if scandata then
		if not livedata then
			-- Copy scandata info into a clone table and call Unpack on that
			-- The original does not get unpacked, so does not need repacking
			local clone = {
				image = scandata.image, -- will be overwritten by unpack
				ropes = scandata.ropes, -- will be deleted by unpack
				scanstats = replicate(scandata.scanstats)
			}
			scandata = clone
		end
	else -- no scandata for this serverKey
		if not livedata then
			-- don't create new scandata if not 'live'
			return nil, "No Data"
		end
		scandata = {image = {}, scanstats = {ImageUpdated = time()}}
		AucScanData.scans[serverKey] = scandata
	end

	private.Unpack(scandata)
	private.dataCache[serverKey] = scandata
	return scandata
end

function lib.ClearScanData(command)
	local report, serverKey
	if not private.isLoaded then return end

	local keyword, extra = "server", "" -- default
	if type(command) == "string" then
		local _, ind, key = strfind(command, "(%S+)")
		if key then
			key = AucAdvanced.API.IsKeyword(key)
			if key then
				keyword = key -- recognised keyword
				extra = strtrim(strsub(command, ind+1))
			else
				extra = strtrim(command) -- processor will try to resolve whole command
			end
		end
	elseif command then -- only valid types are string or nil
		error("Unrecognised parameter type to ClearScanData: "..type(command)..":"..tostring(command))
	end

	if keyword == "ALL" then
		if extra == "" then
			wipe(AucScanData.scans)
			AucScanData.old = nil
			report = "All realms"
		end
	else
		if keyword == "server" then
			if extra == "" then extra = Resources.ServerKey end
		elseif keyword == "faction" then -- for backward compatibility; factions are no longer used in the database
			extra = Resources.ServerKey
		end
		if AucScanData.scans[extra] then
			AucScanData.scans[extra] = nil
			report = extra
			serverKey = extra
		else
			local resolve = ResolveServerKey(extra)
			if resolve and AucScanData.scans[resolve] then
				AucScanData.scans[resolve] = nil
				report = resolve.."("..extra..")"
				serverKey = resolve
			end
		end
	end

	wipe(private.dataCache)
	lib.GetScanData() -- force create home serverKey (if needed) and put back in cache
	if report then
		aucPrint("Auctioneer: ScanData cleared for {{"..report.."}}.")
		local clearstats = {
			source = "clear",
			clearType = "scandata",
			clearRequest = command,
			clearReport = report,
			serverKey = serverKey,
		}
		AucAdvanced.SendProcessorMessage("scanstats", clearstats) -- notify modules to flush caches
	else
		aucPrint("Auctioneer: Unable to clear ScanData for {{"..command.."}}")
	end
end

function private.Unpack(scandata)
	if type(scandata.scanstats) ~= "table" then
		scandata.scanstats = {ImageUpdated = time()}
	end
	if scandata.image == "rope" then
		scandata.image = {}
		for pos, rope in ipairs(scandata.ropes) do
			local loader, err = loadstring(rope)
			if loader then
				local test, items = pcall(loader)
				if test then
					for pos, item in ipairs(items) do
						if item[CONST_LINK] and item[CONST_FLAG] then -- limited integrity check
							tinsert(scandata.image, item)
						end
					end
					err = nil
				else
					err = items
				end
			end
			if err then
				aucPrint("Error loading scan image: {{", err, "}}")
				-- if we get an error from any rope, assume the whole packed image is corrupt
				scandata.image = {}
				scandata.scanstats.ImageUpdated = time()
				break
			end
		end
	elseif type(scandata.image) ~= "table" then
		scandata.image = {}
		scandata.scanstats.ImageUpdated = time()
	end
	scandata.ropes = nil
end

local function LookForOldData()
	if not AucScanData.old then
		LookForOldData = nil
		return
	end

	local serverKey, realm, faction = Resources.ServerKey, Const.PlayerRealm, Resources.PlayerFaction
	if not serverKey or faction == "Neutral" then return end -- wait for later event

	LookForOldData = nil

	local realmdata = AucScanData.old[realm]
	if not realmdata then return end

	if not AucScanData.scans[serverKey] then
		local scandata = realmdata[faction] or realmdata[Resources.OpposingFaction] -- prefer home faction, but use opposing if no home data
		if scandata then
			AucScanData.scans[serverKey] = scandata
		end
	end

	AucScanData.old[realm] = nil
end

local function OnLoadRunOnce()
	OnLoadRunOnce = nil
	aucPrint("Auctioneer: {{ScanData}} loaded.")
	private.UpgradeDB()
	if LookForOldData then LookForOldData() end
	private.isLoaded = private.isLoaded or Resources.Active
	lib.GetScanData() -- force unpack of home data
end
function lib.OnLoad()
	if OnLoadRunOnce then OnLoadRunOnce() end
end
-- backup in case Auc-ScanData got loaded early (normally it would be loaded after this event)
lib.Processors.gameactive = function()
	wipe(private.dataCache)
	if LookForOldData then LookForOldData() end
	private.isLoaded = true
	lib.GetScanData() -- force unpack of home data
end
-- Special handling for when a Neutral player character chooses a faction
if Resources.PlayerFaction == "Neutral" then
	lib.Processors.factionselect = lib.Processors.gameactive
end

function private.UpgradeDB()
	private.UpgradeDB = nil

	local savedScanData = AucScanData
	if savedScanData and savedScanData.Version == DATABASE_VERSION then
		if type(savedScanData.scans) ~= "table" then savedScanData.scans = {} end
		if savedScanData.old then
			if not savedScanData.old.expires or time() > savedScanData.old.expires then
				savedScanData.old = nil
			end
		end
		return
	end

	-- Reset AucScanData; if we want to keep anything from before, we will copy it from savedScanData in the block below
	AucScanData = {Version = DATABASE_VERSION, scans = {}}

	if savedScanData then
		if savedScanData.Version == 1.3 then
			-- 1.4 uses a different structure and new style combined serverKeys
			-- conversion from old to new is handled by LookForOldData on login to each server
			aucPrint("Auc-ScanData is upgrading database version 1.3 to 1.4")
			local oldscans = savedScanData.scans
			if type(oldscans) == "table" and next(oldscans) then
				oldscans.expires = time() + 604800 -- keep old data for 1 week
				AucScanData.old = oldscans
			end
		else -- Unknown version
			aucPrint("Auc-ScanData database error: unknown version, resetting database")
		end
	end
end

function lib.OnUnload()
	local StringRope = LibStub:GetLibrary("StringRope")
	local rope = StringRope:New(-1)

	local maxLen = 2^20

	local now = time()
	local maxTime = 2592000 -- 60 * 60 * 24 * 30 -- 30 days

	if not (AucScanData and AucScanData.scans) then return end

	-- Convert all image data to loadstring strings
	for serverKey, scandata in pairs(AucScanData.scans) do
		local scanstats = scandata.scanstats
		local timestamp = scanstats and scanstats.ImageUpdated
		if not timestamp or (now - timestamp) > maxTime then
			AucScanData.scans[serverKey] = nil
		elseif type(scandata.image) == "table" then
			scandata.ropes = {}
			rope:Add("return {")
			local fCount = #scandata.image
			for i = 1, fCount do
				local item = scandata.image[i]
				if item and type(item) == "table" then
					rope:Add("{")
					local pos = 1
					while item[pos] or item[pos+1] or item[pos+2] or item[pos+3] do
						local v = item[pos]
						if v == nil then
							rope:Add("nil,")
						else
							local t = type(v)
							if t == "string" then
								rope:Add(("%q,"):format(v))
							elseif t == "number" then
								rope:Add(v..",")
							elseif t == "boolean" then
								rope:Add(tostring(v)..",")
							else
								rope:Add("nil--[["..t.."]],")
							end
						end
						pos = pos + 1
					end
					rope:Add("},")
				elseif item == nil then
					rope:Add("nil,")
				else
					rope:Add("nil--[["..type(item).."]],")
				end
				if rope.len and rope.len > maxLen then
					rope:Add("}");
					tinsert(scandata.ropes, rope:Get())
					rope:Clear()
					rope:Add("return {")
				end
			end
			rope:Add("}")
			scandata.image = "rope"
			tinsert(scandata.ropes, rope:Get())
			rope:Clear()
		elseif scandata.image ~= "rope" then
			AucScanData.scans[serverKey] = nil
		end
	end

	private.isLoaded = false
end

-- Support GetServerKeyList and ChangeServerKey, even though we load too late for CoreServers to use them at startup
function lib.GetServerKeyList()
	local list
	if not (AucScanData and AucScanData.scans) then return end
	for serverKey in pairs(AucScanData.scans) do
		if not list then list = {} end
		tinsert(list, serverKey)
	end
	return list
end
function ChangeServerKey(oldKey, newKey)
	if not (oldKey and AucScanData and AucScanData.scans) then return end
	local oldData = AucScanData.scans[oldKey]
	AucScanData.scans[oldKey] = nil
	if oldData and newKey then
		AucScanData.scans[newKey] = oldData
	end
end

AucAdvanced.RegisterRevision("$URL: Auc-ScanData/ScanData.lua $", "$Rev: 6365 $")
