--[[
	Auctioneer
	Version: 8.2.6430 (SwimmingSeadragon)
	Revision: $Id: CoreFinal.lua 6430 2019-09-22 00:20:05Z none $
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

	CoreFinal is the last Core Auctioneer file to be loaded

	CoreFinal will:
		Finalize internal checking procedures initialized in CoreManifest and CoreModule
		Perform or trigger other load-time integrity checks

	About the ABORTLOAD flag
		CoreManifest, and certain other Core modules, will set the ABORTLOAD flag
		if they detect a critical problem during loading.
		CoreFinal performs or triggers checks that may set this flag
]]

local AucAdvanced = AucAdvanced
if not AucAdvanced then return end
AucAdvanced.CoreFileCheckIn("CoreFinal")
local _,_,_, internal = AucAdvanced.GetCoreModule(nil, nil, nil, nil, "CoreFinal") -- Request access to all internal storage

internal.CoreModule.CoreFinalCall()

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/CoreFinal.lua $", "$Rev: 6430 $")
AucAdvanced.CoreFileCheckOut("CoreFinal")
AucAdvanced.CoreFileCheckOut() -- calling with no filename to finalize check in/out process
if not AucAdvanced.ABORTLOAD then AucAdvanced.CORELOADED = time() end
