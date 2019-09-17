--[[
	Auctioneer - Scan Finish module
	Version: 8.2.6345 (SwimmingSeadragon)
	Revision: $Id: ScanFinish.lua 6345 2019-09-13 05:07:31Z none $
	URL: http://auctioneeraddon.com/

	This is an Auctioneer module that adds a few event functionalities
	to Auctioneer when a successful scan is completed.

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


local libType, libName = "Util", "ScanFinish"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local aucPrint,decode,_,_,replicate,empty,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()

local strAucClassicPath
local AddOnName = ...
AddOnName = AddOnName:lower()
if AddOnName == "auc-util-scanfinish" then
	strAucClassicPath = "Interface\\AddOns\\Auc-Util-ScanFinish\\ScanComplete.mp3"
elseif AddOnName == "auc-advanced" then -- embedded
	strAucClassicPath = "Interface\\AddOns\\Auc-Advanced\\Modules\\Auc-Util-ScanFinish\\ScanComplete.mp3"
else -- unknown
	return
end

local blnDebug
local strPrevSound

lib.Processors = {
	scanfinish = function(callbackType, ...)
		if not get("util.scanfinish.activated") then
			return
		end
		private.ScanFinish(...)
	end,

	scanstart = function(callbackType, ...)
		if not get("util.scanfinish.activated") then
			return
		end
		private.ScanStart(...)
	end,

	config = function(callbackType, ...)
		if private.SetupConfigGui then private.SetupConfigGui(...) end
	end,

	configchanged = function(callbackType, ...)
		private.ConfigChanged(...)
	end,
}

function lib.OnLoad()
	--aucPrint("Auctioneer: {{"..libType..":"..libName.."}} loaded!")
	default("util.scanfinish.activated", true)
	default("util.scanfinish.shutdown", false)
	default("util.scanfinish.logout", false)
	default("util.scanfinish.soundpath", "AuctioneerClassic")
	default("util.scanfinish.message", "So many auctions... so little time")
	default("util.scanfinish.messagechannel", "none")
	default("util.scanfinish.emote", "none")
	default("util.scanfinish.debug", false)

	blnDebug = get("util.scanfinish.debug")
	strPrevSound = get("util.scanfinish.soundpath")
end

function private.ScanStart(scanSize, querysig, query)
	if (scanSize ~= "Full") then return end
	private.AlertShutdownOrLogOff()
end


function private.ScanFinish(scanSize, querysig, query, wasComplete)
	if (scanSize ~= "Full") then return end
	if (not wasComplete) then return end
	private.PerformFinishEvents()
end

function private.PerformFinishEvents()
	--Sound
	private.PlayCompleteSound()

	--Message
	if get("util.scanfinish.messagechannel") == "none" then
		--don't do anything
	elseif get("util.scanfinish.messagechannel") == "GENERAL" then
		SendChatMessage(get("util.scanfinish.message"),"CHANNEL",nil,GetChannelName("General"))
	else
		SendChatMessage(get("util.scanfinish.message"),get("util.scanfinish.messagechannel"))
	end

	--Emote
	if not (get("util.scanfinish.emote") == "none") then
		DoEmote(get("util.scanfinish.emote"))
	end

	--Shutdown or Logoff
	if (get("util.scanfinish.shutdown")) then
		aucPrint("AucAdvanced: {{"..libName.."}} Shutting Down!!")
		if not blnDebug then
			Quit()
		end
	elseif (get("util.scanfinish.logout")) then
		aucPrint("AucAdvanced: {{"..libName.."}} Logging Out!")
		if not blnDebug then
			Logout()
		end
	end
end

function private.AlertShutdownOrLogOff()
	if (get("util.scanfinish.shutdown")) then
		PlaySound(PlaySoundKitID and "TellMessage" or SOUNDKIT.TELL_MESSAGE) -- HYBRID73
		aucPrint("AucAdvanced: {{"..libName.."}} |cffff3300Reminder|r: Shutdown is enabled. World of Warcraft will be shut down once the current scan successfully completes.")
	elseif (get("util.scanfinish.logout")) then
		PlaySound(PlaySoundKitID and "TellMessage" or SOUNDKIT.TELL_MESSAGE) -- HYBRID73
		aucPrint("AucAdvanced: {{"..libName.."}} |cffff3300Reminder|r: LogOut is enabled. This character will be logged off once the current scan successfully completes.")
	end
end


-- Conversion table for PlaySound change -- HYBRID73
local lookupSound
if SOUNDKIT then
	lookupSound = {
		["QUESTCOMPLETED"] = 619, -- not in SOUNDKIT
		["LEVELUP"] = 888, -- not in SOUNDKIT
		["AuctionWindowOpen"] = SOUNDKIT.AUCTION_WINDOW_OPEN,
		["AuctionWindowClose"] = SOUNDKIT.AUCTION_WINDOW_CLOSE,
		["ReadyCheck"] = SOUNDKIT.READY_CHECK,
		["RaidWarning"] = SOUNDKIT.RAID_WARNING,
		["LOOTWINDOWCOINSOUND"] = SOUNDKIT.LOOT_WINDOW_COIN_SOUND,
	}
else
	lookupSound = {}
end

function private.PlayCompleteSound()
	local strConfiguredSoundPath = get("util.scanfinish.soundpath")
	if strConfiguredSoundPath and strConfiguredSoundPath ~= "none" then
		if blnDebug then
			aucPrint("AucAdvanced: {{"..libName.."}} You are listening to "..strConfiguredSoundPath)
		end
		if strConfiguredSoundPath == "AuctioneerClassic" then
			PlaySoundFile(strAucClassicPath)
		else
			PlaySound(lookupSound[strConfiguredSoundPath] or strConfiguredSoundPath) -- HYBRID73
		end
	end
end

--Config UI functions
function private.SetupConfigGui(gui)
	private.SetupConfigGui = nil
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id = gui:AddTab(libName, libType.." Modules")

	gui:AddHelp(id, "what is scanfinish",
		"What is ScanFinish?",
		"ScanFinish is an Auctioneer module that will execute one or more useful events once Auctioneer has completed a Full scan successfully."
		)

	gui:AddControl(id, "Header",	 0,	libName.." options")
	gui:AddControl(id, "Checkbox",   0, 1, "util.scanfinish.activated", "Allow the execution of the events below once a successful full scan completes")
	gui:AddTip(id, "Selecting this option will enable Auctioneer to perform the events below once Auctioneer has completed a scan successfully. \n\nUncheck this to disable all events.")

	gui:AddControl(id, "Subhead",	0,	"Sound & Emote")
	gui:AddControl(id, "Selectbox",  0, 3, {
		{"none", "None (do not play a sound)"},
		{"AuctioneerClassic", "Auctioneer Classic"},
		{"QUESTCOMPLETED","Quest Completed"},
		{"LEVELUP","Level Up"},
		{"AuctionWindowOpen","Auction House Open"},
		{"AuctionWindowClose","Auction House Close"},
		{"ReadyCheck","Raid Ready Check"},
		{"RaidWarning","Raid Warning"},
		{"LOOTWINDOWCOINSOUND","Coin"},
	}, "util.scanfinish.soundpath")
	gui:AddTip(id, "Selecting one of these sounds will cause Auctioneer to play that sound once Auctioneer has completed a scan successfully. \n\nBy selecting None, no sound will be played.")

	gui:AddControl(id, "Selectbox",  0, 3, {
		{"none"	  , "None (do not emote)"},
		{"APOLOGIZE" , "Apologize"},
		{"APPLAUD"   , "Applaud"},
		{"BRB"	   , "BRB"},
		{"CACKLE"	, "Cackle"},
		{"CHICKEN"   , "Chicken"},
		{"DANCE"	 , "Dance"},
		{"FAREWELL"  , "Farewell"},
		{"FLIRT"	 , "Flirt"},
		{"GLOAT"	 , "Gloat"},
		{"JOKE"	  , "Silly"},
		{"SLEEP"	 , "Sleep"},
		{"VICTORY"   , "Victory"},
		{"YAWN"	  , "Yawn"},

	}, "util.scanfinish.emote")
	gui:AddTip(id, "Selecting one of these emotes will cause your character to perform the selected emote once Auctioneer has completed a scan successfully.\n\nBy selecting None, no emote will be performed.")

	gui:AddControl(id, "Subhead",	0,	"Message")
	gui:AddControl(id, "Text",	   0, 1, "util.scanfinish.message", "Message text:")
	gui:AddTip(id, "Enter the message text of what you wish your character to say as well as choosing a channel below. \n\nThis will not execute slash commands.")
	gui:AddControl(id, "Selectbox",  0, 3, {
		{"none", "None (do not send message)"},
		{"SAY", "Say (/s)"},
		{"PARTY","Party (/p)"},
		{"RAID","Raid (/r)"},
		{"GUILD","Guild (/g)"},
		{"YELL","Yell (/y)"},
		{"EMOTE","Emote (/em)"},
		{"GENERAL","General"},
	}, "util.scanfinish.messagechannel")
	gui:AddTip(id, "Selecting one of these channels will cause your character to say the message text into the selected channel once Auctioneer has completed a scan successfully. \n\nBy choosing Emote, your character will use the text above as a custom emote. \n\nBy selecting None, no message will be sent.")


	gui:AddControl(id, "Subhead",	0,	"Shutdown or Log Out")
	gui:AddControl(id, "Checkbox",   0, 1, "util.scanfinish.shutdown", "Shutdown World of Warcraft")
	gui:AddTip(id, "Selecting this option will cause Auctioneer to shut down World of Warcraft completely once Auctioneer has completed a scan successfully.")
	gui:AddControl(id, "Checkbox",   0, 1, "util.scanfinish.logout", "Log Out the current character")
	gui:AddTip(id, "Selecting this option will cause Auctioneer to log out to the character select screen once Auctioneer has completed a scan successfully. \n\nIf Shutdown is enabled, selecting this will have no effect")


	--Debug switch via gui. Currently not exposed to the end user
	-- gui:AddControl(id, "Subhead",	0,	"")
	-- gui:AddControl(id, "Checkbox",   0, 1, "util.scanfinish.debug", "Show Debug Information for this session")


end

function private.ConfigChanged(fullsetting, value, setting, module, base)
	if module == "scanfinish" then -- only respond to own changes
		--Debug switch via gui. Currently not exposed to the end user
		blnDebug = get("util.scanfinish.debug")
		if blnDebug then
			aucPrint("  Debug:Configuration Changed")
			if not get("util.scanfinish.activated") then
				aucPrint("  Debug:Updating ScanFinish:Deactivated")
			elseif AucAdvanced.Scan.IsScanning() then
				aucPrint("  Debug:Updating ScanFinish with Scan in progress")
			end
		end

		local strCurSound = get("util.scanfinish.soundpath")
		if strPrevSound ~= strCurSound then
			private.PlayCompleteSound()
			strPrevSound = strCurSound
		end
	elseif base == "profile" then
		-- profile change: just re-sync strPrevSound
		strPrevSound = get("util.scanfinish.soundpath")
	end
end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-ScanFinish/ScanFinish.lua $", "$Rev: 6345 $")
