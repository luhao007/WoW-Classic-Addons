--[[
	Auctioneer
	Version: 8.2.6430 (SwimmingSeadragon)
	Revision: $Id: CoreModule.lua 6430 2019-09-22 00:20:05Z none $
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
	Auctioneer Core Module Support

	This code helps maintain internal integrity of Auctioneer.
	Creates a set of objects and namespaces, restricted to the Core files, for cross-Core-file communication

	Allows Core files access to a module, for event messages
	Each file receives it's own 'module' into which it can install Processor and other event handlers
	These are merged into a single Core module to avoid cluttering the system with extra modules
	Note: the individual file 'modules' are not retained after load time, and should not be permanently stored by the Core files
	In the case of multi-file mode, each file does receive its own module, so it may add any event handler it needs without any chance of clashing

	Allows Core files access to internal storage for direct cross-file access
	Used for messages outside of the Processor system, typically where a specific call order is required, or for very closely related Core files
	In most cases the Core file should specify the name of the internal subspace, and will be given access to that subspace
	The Core files that require access to the internal storage for other files will call with the accessInternal (5th) parameter set to an identifying string
	In the case of multi-file mode, the same Internal table will be shared by a group of Core files

	Core files may also request a Private table for their own internal use
	In the case of multi-file mode, the same Private table will be shared by a group of Core files

	Supports splitting a Core 'file' over several sub-files, giving each access to the same module, internal and private objects
--]]


if not AucAdvanced then return end
AucAdvanced.CoreFileCheckIn("CoreModule")
local lib = AucAdvanced
local Debug = lib.Debug

local _, internal = ...
local internalLib = {}
internal.CoreModule = internalLib

local modules = {}
local access_names = {}

-- Variables to support multi-file mode
local mKey, mModName, mIntName, mPrivate
-- This is an initial creation function.  Create and return items once.  Expect the caller to store that value for use.
function lib.GetCoreModule(moduleName, internalName, hasPrivate, multiFile, accessInternal)
	local mod, int, priv, multi, access
	Debug.DebugPrint(format("GetCoreModule called with parameters\nModule=%s, Internal=%s, Private=%s, Multifile=%s, Access=%s",
			tostringall(moduleName, internalName, hasPrivate, multiFile, accessInternal)),
		"Core",
		"GetCoreModule info "..tostring(moduleName or accessInternal or multiFile or internalName or "Unknown"),
		nil,
		Debug.Level.Info)

	if multiFile and multiFile == mKey then
		multi = 2 -- 2nd or later file in multifile, use previous values if they exist,
					-- or create new ones and record if they don't exist yet
					-- but fail out if names do not match
	else
		mKey, mModName, mIntName, mPrivate = nil, nil, nil, nil
		if multiFile then
			multi = 1 -- 1st file in multifile, create new values and record them for next file
			mKey = multiFile
		end
	end

	-- moduleName must be unique, so each file can receive its own module
	-- moduleName is used for error-checking and debugging, but has no use outside CoreModule
	if moduleName then
		if multi then
			-- a group of files should be using the same moduleName, but we need the modules to be unique
			if mModName ~= nil and mModName ~= moduleName then
				return
			end
			local index = 1
			local uniqueName = moduleName .. index
			while modules[uniqueName] do
				index = index + 1
				uniqueName = moduleName .. index
			end

			mModName = moduleName
			mod = {}
			modules[uniqueName] = mod
		elseif modules[moduleName] then
			return
		else
			mod = {}
			modules[moduleName] = mod
		end
	end


	if internalName then
		int = internal[internalName]
		if int then -- only permitted if 2nd or later file, plus name must match previous
			if multi ~= 2 or mIntName ~= internalName then
				return
			end
		else
			int = {}
			internal[internalName] = int
			if multi then
				mIntName = internalName
			end
		end
	end

	if hasPrivate then
		if multi == 2 and mPrivate then
			priv = mPrivate
		else
			priv = {}
			if multi then
				mPrivate = priv
			end
		end
	end

	if accessInternal then
		tinsert(access_names, accessInternal) -- record for debug
		access = internal
	end

	return mod, int, priv, access
end

--[[ CoreModule
	A dummy module representing the core of Auc-Advanced
	Used to catch messages and pass them on to elements of the core
--]]
local coremoduleInternal = {}
local coremodule = {}


local function HasOnlyFunctions(tbl)
	for _, elem in pairs(tbl) do
		if not type(elem)=="function" then
			return false
		end
	end
	return true
end

-- called from CoreMain's private OnLoad function
function internalLib.CoreModuleOnLoad(addon)
	internalLib.CoreModuleOnLoad = nil
	local tcheck = {}
	local ncheck = {}
	for mdl, core in pairs(modules) do
		for elem, dat in pairs(core) do
			local tp = type(dat)
			if (tp=="table" and HasOnlyFunctions(dat)) then tp="nestedfunction" end
			if ((not tcheck[elem]) or tcheck[elem]==tp) then
				if not tcheck[elem] then
					tcheck[elem] = tp
					ncheck[elem] = mdl
				end
				if (tp=="table") then
					if not coremodule[elem] then coremodule[elem] = {} end
					local ts = coremodule[elem]
					for x, y in pairs(dat) do
						ts[x] = y
					end
				elseif (tp=="nestedfunction") then
					if not coremoduleInternal[elem] then coremoduleInternal[elem] = {} end
					local fns = coremoduleInternal[elem]
					for fName, fCode in pairs(dat) do
						if not fns[fName] then fns[fName] = {} end
						local fs = fns[fName]
						if not coremodule[elem] then coremodule[elem] = {} end
						if not coremodule[elem][fName] then
							local f = elem
							coremodule[elem][fName]=function(...)
								for i=1,#fs do
									local fn = fs[i]
									fn(...)
								end
							end
						end
						table.insert(fs, fCode)
					end
				elseif (tp=="function") then
					if not coremoduleInternal[elem] then coremoduleInternal[elem] = {} end
					local fs = coremoduleInternal[elem]

					if not coremodule[elem] then
						local f = elem
						coremodule[elem]=function(...)
							for i=1,#fs do
								local fn = fs[i]
								fn(...)
							end
						end
					end
					table.insert(fs, dat)
				end
			else
				if nLog then
					nLog.AddMessage("Auctioneer", "CoreModule", N_WARNING, "CoreModule did not match expected layout",
						("For %s, Baseline %s has type %s while %s has type %s"):format(
							elem, ncheck[elem] or "??", tcheck[elem] or "??",
							mdl, tp))
				end
			end
		end
	end

	-- install as a Module
	AucAdvanced.NewModule("Util", "CoreModule", coremodule, true)

	-- do OnLoad
	if coremodule.OnLoad then
		coremodule.OnLoad(addon)
	end
end

function internalLib.CoreFinalCall()
	lib.GetCoreModule = nil
end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/CoreModule.lua $", "$Rev: 6430 $")
AucAdvanced.CoreFileCheckOut("CoreModule")
