--[[
	Auctioneer
	Version: 8.2.6430 (SwimmingSeadragon)
	Revision: $Id: DataPostDeposit.lua 6430 2019-09-22 00:20:05Z none $
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

	Install Deposit Cost special data to the core AucAdvanced.Data table

	Deposit Cost for certain TradeSkill reagents has an extra fee (intended as a deterrent to selling lots of small stacks)
	Affected items broadly follow some rules, i.e. tradeskill items in certain classes
	However there are a number of exceptions that must be maintained as a database

	Implemented as a separate file containg raw data, for ease of maintenance
	Auctioneer modules will normally compile the raw data into a more useable format, {usually during "gameactive" event - NYI}
--]]

if not AucAdvanced then return end
local data = AucAdvanced.Data -- add to existing data table (created in CoreManifest)
if not data then return end

-- All items in these subclasses do not have the extra fee
data.DepositExcludedSubclasses = {
	1, -- Engineering Parts
	4, -- Jewelcrafting
	10, -- Elemental
	11, -- Other
	16, -- Inscription
}

-- These itemIDs are in a subclass that would normally have the extra fee, but are exceptions that do not have the extra fee
-- (When updating this table keep it in order, to help spot duplicates)
data.DepositItemIDExceptions = {
	2775, --Silver Ore
	2776, --Gold Ore
	2842, --Silver Bar
	3577, --Gold Bar
	6037, --Truesilver Bar
	7286, --Black Whelp Scale
	7911, --Truesilver Ore
	23426, --Khorium Ore
	23427, --Eternium Ore
	23448, --Felsteel Bar
	41163, --Titanium Bar
	51950, --Pyrium Bar
	52183, --Pyrite Ore
	74248, --Sha Crystal
	124444, --Infernal Brimstone
	128304, --Yseralline Seed
	152877, --Veiled Crystal
}

data.DepositCalcDataDebugVersion = 2


