--[[
	This code created by doeiqts@gmail.com for review by the auctioneer team.
	If you have any questions please feel free to contact me at the above address.
	SearcherConverter.lua used as a template in creating this code.

	Auctioneer - Search UI - Searcher Smelting
	Version: 1.0.0 (doeiqts)
	URL: http://auctioneeraddon.com/

	This is a plugin module for the SearchUI that assists in searching by refined paramaters

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
-- Create a new instance of our lib with our parent
if not AucSearchUI then return end
local lib, parent, private = AucSearchUI.NewSearcher("Smelting")
if not lib then return end

local get, set, default, Const, resources = parent.GetSearchLocals()
lib.tabname = "Smelting"

-- Build a table to do all our work
-- findSmeltable[itemID] = {conversionID, yield, checkstring}
-- Note: ItemSuggest uses a copy of this code; if you change it here, change it in ItemSuggest as well!
local findSmeltable = {}
local smeltMinLevels = {}
do
	-- Set our constants
	-- Motes/Primals
	local PAIR = 22451
	local MAIR = 22572
	local PEARTH= 22452
	local MEARTH = 22573
	local PFIRE = 21884
	local MFIRE = 22574
	local PLIFE = 21886
	local MLIFE = 22575
	local PMANA = 22457
	local MMANA = 22576
	local PSHADOW = 22456
	local MSHADOW = 22577
	local PWATER = 21885
	local MWATER = 22578
	-- Ores/Bars/Reagents
	local COPPERORE = 2770
	local COPPERBAR = 2840
	local TINORE = 2771
	local TINBAR = 3576
	local BRONZEBAR = 2841
	local SILVERORE = 2775
	local SILVERBAR = 2842
	local IRONORE = 2772
	local IRONBAR = 3575
	local GOLDORE = 2776
	local GOLDBAR = 3577
	local STEELBAR = 3859
	local MITHRILORE = 3858
	local MITHRILBAR = 3860
	local TRUESILVERORE = 7911
	local TRUESILVERBAR = 6037
	local THORIUMORE = 10620
	local THORIUMBAR = 12359
	local DARKIRONORE = 11370
	local DARKIRONBAR = 11371
	local DREAMDUST = 11176
	local ETHORIUMBAR = 12655
	local FELIRONORE = 23424
	local FELIRONBAR = 23445
	local ELEMENTIUMINGOT = 18562
	local ARCANITEBAR = 12360
	local FIERYCORE = 17010
	local ELEMENTALFLUX = 18567
	local EELEMENTIUMBAR = 17771
	local ADAMANTITEORE = 23425
	local ADAMANTITEBAR = 23446
	local ETERNIUMORE = 23427
	local ETERNIUMBAR = 23447
	local FELSTEELBAR = 23448
	local COBALTORE = 36909
	local COBALTBAR = 36916
	local KHORIUMORE = 23426
	local KHORIUMBAR = 23449
	local HADAMANTITEBAR = 23573
	local SARONITEORE = 36912
	local SARONITEBAR = 36913
	local OBSIDIUMORE = 53038
	local OBSIDIUMBAR = 54849
	local TITANIUMORE = 36910
	local TITANIUMBAR = 41163
	local ETERNALFIRE = 36860
	local ETERNALEARTH = 35624
	local ETERNALSHADOW = 35627
	local TITANSTEELBAR = 37663
	local ELEMENTIUMORE = 52185
	local ELEMENTIUMBAR = 52186
	local VOLATILEEARTH = 52327
	local HELEMENTIUMBAR = 53039
	local PYRITEORE = 52183
	local PYRIUMBAR = 51950
	local HARDENEDKHORIUM = 35128


	-- Temporary tables to help build the working table
	-- To add new smeltables, edit these tables


	local primal2mote = {
		[PEARTH] = MEARTH,
		[PFIRE] = MFIRE,
	}
	local ore2bar = {
		[COPPERORE] = COPPERBAR,
		[TINORE] = TINBAR,
		[IRONORE] = IRONBAR,
		[SILVERORE] = SILVERBAR,
		[GOLDORE] = GOLDBAR,
		[MITHRILORE] = MITHRILBAR,
		[TRUESILVERORE] = TRUESILVERBAR,
		[THORIUMORE] = THORIUMBAR,
		[COBALTORE] = COBALTBAR,
	}
	local twoore2bar = {
		[FELIRONORE] = FELIRONBAR,
		[ADAMANTITEORE] = ADAMANTITEBAR,
		[ETERNIUMORE] = ETERNIUMBAR,
		[KHORIUMORE] = KHORIUMBAR,
		[SARONITEORE] = SARONITEBAR,
		[OBSIDIUMORE] = OBSIDIUMBAR,
		[TITANIUMORE] = TITANIUMBAR,
		[ELEMENTIUMORE] = ELEMENTIUMBAR,
		[PYRITEORE] = PYRIUMBAR,
	}

	-- Table to filter by mining level
	smeltMinLevels = {
		[COPPERORE] = 1,
		[TINORE] = 50,
		[IRONORE] = 100,
		[SILVERORE] = 65,
		[GOLDORE] = 115,
		[MITHRILORE] = 150,
		[TRUESILVERORE] = 165,
		[THORIUMORE] = 230,
		[COBALTORE] = 350,
		[FELIRONORE] = 275,
		[ADAMANTITEORE] = 325,
		[ETERNIUMORE] = 350,
		[KHORIUMORE] = 375,
		[SARONITEORE] = 400,
		[OBSIDIUMORE] = 425,
		[TITANIUMORE] = 450,
		[ELEMENTIUMORE] = 475,
		[PYRITEORE] = 525,
		[COPPERBAR] = 50,
		[TINBAR] = 50,
		[IRONBAR] = 125,
		[THORIUMBAR] = 250,
		[DREAMDUST] = 250,
		[FELIRONBAR] = 350,
		[ETERNIUMBAR] = 350,
		[ADAMANTITEBAR] = 375,
		[TITANIUMBAR] = 450,
		[ETERNALFIRE] = 450,
		[ETERNALEARTH] = 450,
		[ETERNALSHADOW] = 450,
		[ELEMENTIUMBAR] = 500,
		[VOLATILEEARTH] = 500,
		[DARKIRONORE] = 230,
		[ELEMENTIUMINGOT] = 300,
		[ARCANITEBAR] = 300,
		[FIERYCORE] = 300,
		[ELEMENTALFLUX] = 300,
		[KHORIUMBAR] = 375,
		[HADAMANTITEBAR] = 375,
		[PEARTH] = 300,
		[PFIRE] = 300,
	}

	-- Build the working table
	for id, idto in pairs (primal2mote) do
		findSmeltable[id] = {idto, 10, "smelting.enablePrimal"}
	end
	for id, idto in pairs (ore2bar) do
		findSmeltable[id] = {idto, 1, "smelting.enableOre"}
	end
	for id, idto in pairs (twoore2bar) do
		findSmeltable[id] = {idto, .5, "smelting.enableOre"}
	end
	-- Manually add the mutli items to the table
	findSmeltable[COPPERBAR] = {BRONZEBAR, 1, "smelting.enableMulti"}
	findSmeltable[TINBAR] = {BRONZEBAR, 1, "smelting.enableMulti"}
	findSmeltable[IRONBAR] = {STEELBAR, .95, "smelting.enableMulti"} -- using 95% to make up for Coal costs
	findSmeltable[THORIUMBAR] = {ETHORIUMBAR, .5, "smelting.enableMulti"}
	findSmeltable[DREAMDUST] = {ETHORIUMBAR, 1/6, "smelting.enableMulti"}
	findSmeltable[FELIRONBAR] = {FELSTEELBAR, 1/6, "smelting.enableMulti"}
	findSmeltable[ETERNIUMBAR] = {FELSTEELBAR, .25, "smelting.enableMulti"}
	findSmeltable[ADAMANTITEBAR] = {HADAMANTITEBAR, .1, "smelting.enableMulti"}
	findSmeltable[TITANIUMBAR] = {TITANSTEELBAR, 1/12, "smelting.enableMulti"}
	findSmeltable[ETERNALFIRE] = {TITANSTEELBAR, .25, "smelting.enableMulti"}
	findSmeltable[ETERNALEARTH] = {TITANSTEELBAR, .25, "smelting.enableMulti"}
	findSmeltable[ETERNALSHADOW] = {TITANSTEELBAR, .25, "smelting.enableMulti"}
	findSmeltable[ELEMENTIUMBAR] = {HELEMENTIUMBAR, 1/20, "smelting.enableMulti"}
	findSmeltable[VOLATILEEARTH] = {HELEMENTIUMBAR, 1/8, "smelting.enableMulti"}
	-- Manually add Dark Iron Bar
	findSmeltable[DARKIRONORE] = {DARKIRONBAR, 1/8, "smelting.enableDarkIron"}
	-- Manually add Enchanted Elementium Bar
	findSmeltable[ELEMENTIUMINGOT] = {EELEMENTIUMBAR, .25, "smelting.enableEElementium"}
	findSmeltable[ARCANITEBAR] = {EELEMENTIUMBAR, 1/40, "smelting.enableEElementium"}
	findSmeltable[FIERYCORE] = {EELEMENTIUMBAR, .25, "smelting.enableEElementium"}
	findSmeltable[ELEMENTALFLUX] = {EELEMENTIUMBAR, 1/12, "smelting.enableEElementium"}
	-- Manually add Hardened Khorium
	findSmeltable[KHORIUMBAR] = {HARDENEDKHORIUM, 1/6, "smelting.enableHKhorium"}
	findSmeltable[HADAMANTITEBAR] = {HARDENEDKHORIUM, 1/2, "smelting.enableHKhorium"}
end
-- export the table for other addons to reference
resources.SearcherSmeltingLookupTable = findSmeltable

default("smelting.profit.min", 1)
default("smelting.profit.pct", 50)
default("smelting.level.custom", false)
default("smelting.level.min", 0)
default("smelting.level.max", Const.MAXSKILLLEVEL)
default("smelting.adjust.brokerage", true)
default("smelting.adjust.deposit", true)
default("smelting.adjust.deplength", 48)
default("smelting.adjust.listings", 3)
default("smelting.allow.bid", true)
default("smelting.allow.buy", true)
default("smelting.maxprice", 10000000)
default("smelting.maxprice.enable", false)
default("smelting.enableOre", true)
default("smelting.enableMulti", true)
default("smelting.enablePrimal", false)
default("smelting.enableDarkIron", false)
default("smelting.enableEElementium", false)
default("smelting.enableHKhorium", false)
default("smelting.model", "market")

function private.doValidation()
	if not resources.isValidPriceModel(get("smelting.model")) then
		message("Smelting Searcher Warning!\nCurrent price model setting ("..get("smelting.model")..") is not valid. Select a new price model")
	else
		private.doValidation = nil
	end
end

-- This function is automatically called from AucSearchUI.NotifyCallbacks
function lib.Processor(event, subevent)
	if event == "selecttab" then
		if subevent == lib.tabname and private.doValidation then
			private.doValidation()
		end
	end
end

-- This function is automatically called when we need to create our search parameters
function lib:MakeGuiConfig(gui)
	-- Get our tab and populate it with our controls
	local id = gui:AddTab(lib.tabname, "Searchers")

	-- Add the help
	gui:AddSearcher("Smelting", "Search for items which can be smelted into other items for profit (ores, motes, etc)", 100)
	gui:AddHelp(id, "smelting searcher",
		"What does this searcher do?",
		"This searcher provides the ability to search for items that can be smelted to another item which is worth more money.")

	gui:AddControl(id, "Header",     0,      "Smelting search criteria")
	local last = gui:GetLast(id)

	gui:AddControl(id, "MoneyFramePinned",  0, 1, "smelting.profit.min", 1, Const.MAXBIDPRICE, "Minimum Profit")
	gui:AddControl(id, "Slider",            0, 1, "smelting.profit.pct", 1, 100, .5, "Min Discount: %0.01f%%")
	gui:AddControl(id, "Checkbox",          0, 1, "smelting.level.custom", "Use custom levels")
	gui:AddControl(id, "Slider",            0, 2, "smelting.level.min", 0, Const.MAXSKILLLEVEL, 25, "Minimum skill: %s")
	gui:AddControl(id, "Slider",            0, 2, "smelting.level.max", 25, Const.MAXSKILLLEVEL, 25, "Maximum skill: %s")

	gui:AddControl(id, "Subhead",           0,   "Include in search")
	gui:AddControl(id, "Checkbox",          0, 1, "smelting.enableOre", "Ore > Bar")
	gui:AddControl(id, "Checkbox",          0, 1, "smelting.enableMulti", "Multi > Bar")
	gui:AddTip(id, "Look for multiple items that can combine into Bars. (Copper Bar + Tin Bar > Bronze Bar, etc)")
	gui:AddControl(id, "Checkbox",          0, 1, "smelting.enablePrimal", "Primal > Mote")
	gui:AddControl(id, "Checkbox",          0, 1, "smelting.enableDarkIron", "Dark Iron Bar reagents")
	gui:AddTip(id, "Learned through quest. (The Spectral Chalice)")
	gui:AddControl(id, "Checkbox",          0, 1, "smelting.enableEElementium", "Enchanted Elementium Bar reagents")
	gui:AddTip(id, "Learned through drop. (Goblin's Guide to Elementium)")
	gui:AddControl(id, "Checkbox",          0, 1, "smelting.enableHKhorium", "Hardened Khorium reagents")
	gui:AddTip(id, "Learned through drop. (Study of Advanced Smelting)")

	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",          0.42, 1, "smelting.allow.bid", "Allow Bids")
	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",          0.56, 1,  "smelting.allow.buy", "Allow Buyouts")
	gui:AddControl(id, "Checkbox",          0.42, 1, "smelting.maxprice.enable", "Enable individual maximum price:")
	gui:AddTip(id, "Limit the maximum amount you want to spend with the Converter searcher")
	gui:AddControl(id, "MoneyFramePinned",  0.42, 2, "smelting.maxprice", 1, Const.MAXBIDPRICE, "Maximum Price for Converter")

	gui:AddControl(id, "Subhead",           0.42,    "Price Valuation Method:")
	gui:AddControl(id, "Selectbox",         0.42, 1, resources.selectorPriceModels, "smelting.model")
	gui:AddTip(id, "The pricing model that is used to work out the calculated value of items at the Auction House.")

	gui:AddControl(id, "Subhead",           0.42,    "Fees Adjustment")
	gui:AddControl(id, "Checkbox",          0.42, 1, "smelting.adjust.brokerage", "Subtract auction fees")
	gui:AddControl(id, "Checkbox",          0.42, 1, "smelting.adjust.deposit", "Subtract deposit cost")
	gui:AddControl(id, "Selectbox",         0.42, 1, resources.selectorAuctionLength, "smelting.adjust.deplength")
	gui:AddControl(id, "Slider",            0.42, 1, "smelting.adjust.listings", 1, 10, .1, "Ave relistings: %0.1fx")

	gui:SetLast(id, last)
end

function lib.Search (item)
	local smelt = findSmeltable[item[Const.ITEMID]]
	if not smelt then
		return false, "Item not smeltable"
	end

	local newID, yield, test = unpack(smelt)
	if not get(test) then
		return false, "Category disabled"
	end

	-- Must set skill level manually! Otherwise defaults to all skill levels.
	-- Possibly fix this in future?
	local minskill, maxskill
	if get("smelting.level.custom") then
		minskill = get("smelting.level.min")
		maxskill = get("smelting.level.max")
	else
		minskill = 0
		maxskill = Const.MAXSKILLLEVEL
	end
	local skillneeded = smeltMinLevels[item[Const.ITEMID]]
	if (skillneeded < minskill) or (skillneeded > maxskill) then
		return false, "Skill not high enough to smelt"
	end

	local bidprice, buyprice = item[Const.PRICE], item[Const.BUYOUT]
	local maxprice = get("smelting.maxprice.enable") and get("smelting.maxprice")
	if buyprice <= 0 or not get("smelting.allow.buy") or (maxprice and buyprice > maxprice) then
		buyprice = nil
	end
	if not get("smelting.allow.bid") or (maxprice and bidprice > maxprice) then
		bidprice = nil
	end
	if not (bidprice or buyprice) then
		return false, "Does not meet bid/buy requirements"
	end

	local market = resources.GetPrice(get("smelting.model"), newID)
	if not market then
		return false, "No market price"
	end
	local count = item[Const.COUNT] * yield
	market = market * count

	--adjust for brokerage/deposit costs
	if get("smelting.adjust.brokerage") then
		market = market * resources.CutAdjust
	end
	if get("smelting.adjust.deposit") then
		-- note: GetDepositCost can handle numerical itemIDs instead of links
		local amount = AucAdvanced.Post.GetDepositCost(newID, get("smelting.adjust.deplength"), market, 0, count)
		if amount then
			market = market - amount * get("smelting.adjust.listings")
		end
	end

	local value = min (market*(100-get("smelting.profit.pct"))/100, market-get("smelting.profit.min"))
	if buyprice and buyprice <= value then
		return "buy", market
	elseif bidprice and bidprice <= value then
		return "bid", market
	end
	return false, "Not enough profit"
end