--[[
	Auctioneer
	Version: 8.2.6430 (SwimmingSeadragon)
	Revision: $Id: CoreServers.lua 6430 2019-09-22 00:20:05Z none $
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

--[[
	Maintain a database of known servers and serverKeys

	Realm names can be in a compact form, with all spaces and dashes stripped out.
	This is the format provided by GetAutoCompleteRealms, which we use for detecting connected realms

	Standard Realm names can easily be converted to compact form by gsub("[ %-]", "") -- note the space character after the first square bracket
	Maintain a lookup table to allow Compact form to be converted to Standard form

	Saved variable: AucAdvancedServers
		ConnectedRealmTables {serverKey = RealmList}, RealmList is a copy of the table provided by GetAutoCompleteRealms
		ExpandedNames {CompactName = ExpandedName}, entries only exist where ExpandedName is different from CompactName
		KnownRealms {CompactName = serverKey}
		KnownServerKeys {serverKey = timestamp}, records time of last login to each serverKey
		ConvertedServerKeys {oldServerKey = {infotable}} -- info about any serverKey changes, mainly for debug

	Connected Realms will be represented by a serverKey of format '#'..CompactRealmName
	where CompactRealmName is one of the realms from the connected realm set, typically the one first logged into
	This means that it is possible for the serverKey for a given realm to change due to new realm connections,
	(though we shall attempt to avoid having to do a rename whenever possible)
	Situations this may occur:
	When a non-connected realm joins a connected realm, and the user has data for the non-connected realm
	When two sets of connected realms join together, and the user has data for both sets

	Additionally, if the user deletes the AucAdvanced save file (including all serverKey data) but not the Stat save files,
	we should attempt to match serverKey with the Stat files, so as to avoid leaving orphaned data in the Stat save files.

--]]

local AucAdvanced = AucAdvanced
if not AucAdvanced then return end
AucAdvanced.CoreFileCheckIn("CoreServers")
local coremodule, internalLib, _, internal = AucAdvanced.GetCoreModule("CoreServers", "Servers", nil, nil, "CoreServers") -- needs access to the base internal table
if not (coremodule and internal) then return end

local Const = AucAdvanced.Const
local Resources = AucAdvanced.Resources

local FullRealmName, CompactRealmName = Const.PlayerRealm, Const.CompactRealm

local ConnectedRealmTables, ExpandedNames, KnownRealms, KnownServerKeys -- local references to saved variables

local cacheKnown = {} -- cache to lookup/validate serverKeys
local splitcache = {}
local displaycache = {}
local localizedfactions = {
	-- the following entries are placeholders
	["Alliance"] = "Alliance",
	["Horde"] = "Horde",
	["Neutral"] = "Neutral",
}

-- notify modules (primarily Stats) that a serverKey has been renamed
-- modules should move oldKey to newKey in their database; if newKey is nil, modules should just delete oldKey
-- if a module has data for both oldKey and newKey it should either merge them, or archive or discard one set
local function SendServerKeyChange(oldKey, newKey)
	local modules = AucAdvanced.GetAllModules("ChangeServerKey")
	for _, module in ipairs(modules) do
		module.ChangeServerKey(oldKey, newKey)
	end
end

-- helper function: compile a lookup table of serverKeys known to other modules
local function GetModuleServerKeys()
	local modules = AucAdvanced.GetAllModules("GetServerKeyList")
	local compile = {}
	for _, module in ipairs(modules) do
		local modulelist = module.GetServerKeyList()
		if modulelist then
			for _, key in ipairs(modulelist) do
				compile[key] = true
			end
		end
	end
	return compile
end

-- helper function: called if we are on a connected realm and it is not recorded, or is recorded incorrectly
local function ResolveConnectedRealms(sessionKey, sessionConnected, moduleKeys, oldCompactName)

	-- [ADV-719] test
	if not sessionKey and oldCompactName then
		local testkey = "#"..oldCompactName
		if moduleKeys[testkey] then
			-- we've found some data, but testkey is an invalid serverKey
			-- fudge sessionKey so the following sections will work on this data
			sessionKey = testkey
		end
	end
	-- end [ADV-719] test

	if not next(ConnectedRealmTables) then -- empty table, no previous connected realms seen
		local newServerKey

		-- look for an exisiting connected serverKey from one of the modules
		for _, realm in ipairs(sessionConnected) do
			local testKey = "#"..realm
			if moduleKeys[testKey] then
				newServerKey = testKey
				break
			end
		end

		if not newServerKey then -- default
			newServerKey = "#"..CompactRealmName
		end
		ConnectedRealmTables[newServerKey] = sessionConnected
		KnownRealms[CompactRealmName] = newServerKey

		-- handle if there is non-connected serverKey for current realm - i.e. realm has just been connected
		if sessionKey then
			SendServerKeyChange(sessionKey, newServerKey)
		end
		return newServerKey
	end

	local lookupRealms, foundKeys = {}, {}
	for _, realmName in ipairs(sessionConnected) do
		lookupRealms[realmName] = true
	end
	for serverKey, connectedTable in pairs(ConnectedRealmTables) do
		for pos, realmName in ipairs(connectedTable) do
			if lookupRealms[realmName] then
				tinsert(foundKeys, (serverKey:gsub("%-", ""))) -- [ADV-719] ensure found serverKey has '-' chars stripped
				break
			end
		end
	end

	if #foundKeys == 0 then
		-- this connected realm has not been seen before by CoreServers
		local newServerKey

		-- look for an exisiting connected serverKey from one of the modules
		for _, realm in ipairs(sessionConnected) do
			local testKey = "#"..realm
			if moduleKeys[testKey] then
				newServerKey = testKey
				break
			end
		end

		if not newServerKey then -- default
			newServerKey = "#"..CompactRealmName
		end
		ConnectedRealmTables[newServerKey] = sessionConnected
		KnownRealms[CompactRealmName] = newServerKey

		-- handle if there is non-connected serverKey for current realm - i.e. realm has just been connected
		if sessionKey then
			SendServerKeyChange(sessionKey, newServerKey)
		end
		return newServerKey
	elseif #foundKeys == 1 then
		-- another realm in this set has been seen before, and we already have a master key for it
		local newServerKey = foundKeys[1]
		ConnectedRealmTables[newServerKey] = sessionConnected -- refresh the saved copy of the table
		KnownRealms[CompactRealmName] = newServerKey
		if sessionKey then
			SendServerKeyChange(sessionKey, newServerKey)
		end
		return newServerKey
	else
		-- found keys > 1, probably due to two sets of connected realms getting connected together
		-- we need to choose which key will be the new master, the others will get discarded
		-- we could come up with a complicated way of choosing the best key,
		-- but this situation is likely to be extremely rare, so for now we'll just use the first one...
		local newServerKey = foundKeys[1]
		ConnectedRealmTables[newServerKey] = sessionConnected -- save new connected table
		for i = 2, #foundKeys do
			ConnectedRealmTables[foundKeys[i]] = nil
		end

		KnownRealms[CompactRealmName] = newServerKey
		if sessionKey then
			SendServerKeyChange(sessionKey, newServerKey)
		end

		for _, realmName in ipairs(sessionConnected) do
			local known = KnownRealms[realmName]
			if known and known ~= newServerKey then
				KnownRealms[realmName] = newServerKey
				SendServerKeyChange(known, newServerKey)
			end
		end

		return newServerKey
	end
end

local function FixNonConnectedRealm(sessionKey, moduleKeys)
	-- [ADV-719] GetAutoCompleteRealms was changed to return {} for non-connected realms,
	-- causing CoreServers to treat them as connected. We need to revert any changes caused by this
	local testKey = "#"..FullRealmName:gsub(" ", "") -- construct the 'bad' realm name, as it would have been before [ADV-719]
	assert(sessionKey ~= testKey) -- ###
	if KnownServerKeys[testKey] then
		-- found an entry for the 'bad' serverKey, start deleting or converting bad data
		KnownServerKeys[testKey] = nil
		ConnectedRealmTables[testKey] = nil
		if not moduleKeys[sessionKey] then
			-- only convert stat data if the correct key is not present
			-- todo: should probably check/convert this on a per module basis
			SendServerKeyChange(testKey, sessionKey)
		end
		if not AucAdvancedServers.ConvertedServerKeys then
			AucAdvancedServers.ConvertedServerKeys = {}
		end
		AucAdvancedServers.ConvertedServerKeys[testKey] = {
			old = testKey,
			new = sessionKey,
			timestamp = time(),
			reason = "NonConnectedFix",
		}
	end
end

function internalLib.Activate()
	internalLib.Activate = nil -- no longer needed after activation

	if FullRealmName ~= CompactRealmName then
		ExpandedNames[CompactRealmName] = FullRealmName
		AucAdvancedServers.ExpandedNames = ExpandedNames -- attach to save structure, if not already attached
	end
	local sessionConnected = GetAutoCompleteRealms()
	if not sessionConnected or not next(sessionConnected) then -- GetAutoCompleteRealms returns non-connected realms as {}; previously it returned nil
		sessionConnected = false
	end

	local sessionKey = KnownRealms[CompactRealmName] -- may be nil
	local moduleKeys = GetModuleServerKeys() -- may be empty table

	if not sessionConnected then
		--if not sessionKey then -- ### temporarily we will always run this block to force fix incorrect entries [ADV-719]
			sessionKey = CompactRealmName
			KnownRealms[CompactRealmName] = sessionKey
		--end
		-- previously GetAutoCompleteRealms returned nil for non-connected realms, but has recently started returning {} instead
		-- this caused CoreServers to incorrectly treat non-connected realms as connected [ADV-719]
		FixNonConnectedRealm(sessionKey, moduleKeys) -- check if we need to correct previous errors
	else -- handle connected realm
		local needsCheck = false

		-- [ADV-719] Previously our compact realm names only removed ' ' chars. We now also remove '-' chars.
		-- Construct previous cname to see if it has changed
		local oldCompactName = FullRealmName:gsub(" ", "")
		if oldCompactName == CompactRealmName then
			oldCompactName = nil
		end

		sort(sessionConnected) -- we need it in the same order every time
		if not ConnectedRealmTables then
			ConnectedRealmTables = {}
			AucAdvancedServers.ConnectedRealmTables = ConnectedRealmTables
			needsCheck = true
		elseif not sessionKey then
			needsCheck = true
		else
			-- Check that this exact sessionConnected table is already in ConnectedRealmTables
			local savedConnectedRealms = ConnectedRealmTables[sessionKey]
			if not savedConnectedRealms or #savedConnectedRealms ~= #sessionConnected then
				needsCheck = true
			else
				for i = 1, #sessionConnected do
					if sessionConnected[i] ~= savedConnectedRealms[i] then
						needsCheck = true
						break
					end
				end
			end
		end
		if needsCheck then
			sessionKey = ResolveConnectedRealms(sessionKey, sessionConnected, moduleKeys, oldCompactName)
		end

		if oldCompactName and KnownRealms[oldCompactName] then
			-- [ADV-719] Remove invalid entries if we used names that contained a '-' char
			-- ResolveConnectedRealms should have taken care of any data conversion
			KnownRealms[oldCompactName] = nil
			local oldServerKey = "#"..oldCompactName
			KnownServerKeys[oldServerKey] = nil
			ConnectedRealmTables[oldServerKey] = nil

			if not AucAdvancedServers.ConvertedServerKeys then
				AucAdvancedServers.ConvertedServerKeys = {}
			end
			AucAdvancedServers.ConvertedServerKeys[oldServerKey] = {
				old = oldServerKey,
				new = sessionKey,
				timestamp = time(),
				reason = "DashNameFix",
			}
		end

	end

	KnownServerKeys[sessionKey] = time() -- record login time

	-- install to CoreResource (using SetResource, as nothing should write directly to Resources!)
	internal.Resources.SetResource("ServerKey", sessionKey)
	internal.Resources.SetResource("ConnectedRealms", sessionConnected)

	-- populate cacheKnown
	for key in pairs(KnownServerKeys) do
		cacheKnown[key] = key
	end
	for key in pairs(moduleKeys) do
		cacheKnown[key] = key
	end
	for realm, key in pairs(KnownRealms) do
		cacheKnown[realm] = key
	end
	for compact, expanded in pairs(ExpandedNames) do
		cacheKnown[expanded] = cacheKnown[compact]
	end
	if Resources.PlayerFaction == "Alliance" or Resources.PlayerFaction == "Horde" then
		-- ensure we can recognise old style home serverKey
		cacheKnown[Resources.ServerKeyHome] = sessionKey
	end

	-- issue serverkey message for compatibility
	AucAdvanced.SendProcessorMessage("serverkey",sessionKey)
end

local function OnLoadRunOnce()
	OnLoadRunOnce = nil

	-- Saved Variables
	if not AucAdvancedServers or AucAdvancedServers.Version ~= 1 then
		AucAdvancedServers = {
			KnownRealms = {},
			KnownServerKeys = {},
			Version = 1,
			Timestamp = time(),
		}
	end
	ConnectedRealmTables = AucAdvancedServers.ConnectedRealmTables -- may be nil!
	ExpandedNames = AucAdvancedServers.ExpandedNames or {}
	KnownRealms = AucAdvancedServers.KnownRealms
	KnownServerKeys = AucAdvancedServers.KnownServerKeys

	local L = AucAdvanced.localizations
	localizedfactions.Alliance = L"ADV_Interface_FactionAlliance"
	localizedfactions.Horde = L"ADV_Interface_FactionHorde"
	localizedfactions.Neutral = L"ADV_Interface_FactionNeutral"

	wipe(splitcache)
end
function coremodule.OnLoad(addon)
	if addon == "auc-advanced" and OnLoadRunOnce then
		OnLoadRunOnce()
	end
end

--[[ Export functions ]]--

local function ResolveServerKey(testKey)
	if not testKey then -- default
		return Resources.ServerKey
	end
	local serverKey = cacheKnown[testKey]
	if serverKey then -- cached
		return serverKey
	end
	local compactKey = testKey:gsub("[ %-]", "")
	serverKey = cacheKnown[compactKey]
	if serverKey then -- testKey is expanded version of a known compact name
		cacheKnown[testKey] = serverKey
		return serverKey
	end
	if compactKey:byte(1) == 35 then -- '#'
		local trimKey2 = compactKey:sub(2)
		serverKey = cacheKnown[trimKey2]
		if serverKey then
			cacheKnown[testKey] = serverKey
			return serverKey
		end
	end

	-- temporary code for old compact keys, having spaces removed but not dashes - pre-[ADV-719] -- ### to be removed
	compactKey = testKey:gsub(" ", "")
	serverKey = cacheKnown[compactKey]
	if serverKey then
		cacheKnown[testKey] = serverKey
		return serverKey
	end
	if compactKey:byte(1) == 35 then -- '#'
		local trimKey2 = compactKey:sub(2)
		serverKey = cacheKnown[trimKey2]
		if serverKey then
			cacheKnown[testKey] = serverKey
			return serverKey
		end
	end


	-- check for old-style serverKey
	local realm, faction = strmatch(compactKey, "^(.+)%-(%u%l+)$")
	if localizedfactions[faction] then
		serverKey = cacheKnown[realm]
		if serverKey then
			cacheKnown[testKey] = serverKey
			return serverKey
		end
	end
end

local function GetServerKeyList(useTable)
	local list
	if useTable then
		list = useTable
		wipe(list)
	else
		list = {}
	end

	for key in pairs(KnownServerKeys) do
		tinsert(list, key)
	end

	list:sort()

	return list
end

local rltab = {}
local function GetRealmList(serverKey, useTable, expanded)
	serverKey = ResolveServerKey(serverKey)
	if not serverKey then return end
	local list = type(useTable) == "table" and useTable or rltab
	wipe(list)

	local connected = ConnectedRealmTables[serverKey]
	if not connected then
		-- it's a valid serverKey and it's not connected, so serverKey should be the compact realm name
		if expanded then
			serverKey = ExpandedNames[serverKey] or serverKey
		end
		tinsert(list, serverKey)
		return list
	end

	for _, realm in ipairs(connected) do
		if expanded then
			realm = ExpandedNames[realm] or realm
		end
		tinsert(list, realm)
	end
	return list
end

local function GetExpandedRealmName(realmName)
	return ExpandedNames[realmName] or realmName
end

local function GetServerKeyText(serverKey)
	-- return displayable text
	local displayKey = displaycache[serverKey]
	if not displayKey then
		displayKey = ResolveServerKey(serverKey)
		if not displayKey then return end

		local isConnected = false
		if displayKey:byte(1) == 35 then -- '#'
			displayKey = displayKey:sub(2)
			isConnected = true
		end
		displayKey = ExpandedNames[displayKey] or displayKey
		if isConnected then
			displayKey = displayKey .. " (#)"
		end

		displaycache[serverKey] = displayKey
	end
	return displayKey
end

local function SplitServerKey(serverKey)
	local split = splitcache[serverKey]
	if not split then
		if type(serverKey) ~= "string" then return end

		-- old style serverKey behaviour
		local realm, faction = strmatch(serverKey, "^(.+)%-(%u%l+)$")
		local transfaction = localizedfactions[faction]
		if not transfaction then
			-- deal with new style serverKey if we are passed one
			local newKey = ResolveServerKey(serverKey)
			if not newKey then return end
			if newKey:byte(1) == 35 then -- '#'
				newKey = newKey:sub(2)
			end
			realm = ExpandedNames[newKey] or newKey
			faction = Resources.PlayerFaction -- fake it
			transfaction = localizedfactions[faction]
		end
		split = {realm, faction, realm.." - "..transfaction}
		splitcache[serverKey] = split
	end
	return split[1], split[2], split[3]
end

--[[ Exports ]]--

-- serverKey = AucAdvanced.ResolveServerKey(providedServerKey)
-- attempt to find a valid serverKey from providedServerKey. Returns nil if not recognised
-- calling with nil serverKey will return home serverKey as default
AucAdvanced.ResolveServerKey = ResolveServerKey

-- list = AucAdvanced.GetServerKeyList([useTable])
-- returns list of serverKeys known by the CoreServers
-- if useTable is provided it will be populated with the list
-- if useTable is not provided, caller must not store or modify the returned table object
AucAdvanced.GetServerKeyList = GetServerKeyList

-- list = AucAdvanced.GetRealmList(serverKey [, useTable [, expanded]])
-- returns list of realm names associated with serverKey. returns nil for invalid serverKey
-- if useTable is provided it will be populated with the list
-- if useTable is not provided, caller must not store or modify the returned table object
-- if expanded is true, GetRealmList will return expanded realm names (where known), otherwise compact names are returned
AucAdvanced.GetRealmList = GetRealmList

-- text = AucAdvanced.GetExpandedRealmName(realmName)
-- attempt to find expanded realm name from a compact realm name. If not found, just returns realmName
AucAdvanced.GetExpandedRealmName = GetExpandedRealmName

-- text = AucAdvanced.GetServerKeyText(serverKey)
-- return printable text version of serverKey. Returns nil if invalid serverKey
AucAdvanced.GetServerKeyText = GetServerKeyText

-- realm, faction, text = AucAdvanced.SplitServerKey(serverKey)
-- backward-compatible function - avoid using in new code
AucAdvanced.SplitServerKey = SplitServerKey


AucAdvanced.RegisterRevision("$URL: Auc-Advanced/CoreServers.lua $", "$Rev: 6430 $")
AucAdvanced.CoreFileCheckOut("CoreServers")
