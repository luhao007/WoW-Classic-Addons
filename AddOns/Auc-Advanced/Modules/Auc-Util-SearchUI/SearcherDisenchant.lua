--[[
	Auctioneer - Search UI - Searcher Disenchant
	Version: 8.2.6415 (SwimmingSeadragon)
	Revision: $Id: SearcherDisenchant.lua 6415 2019-09-13 05:07:31Z none $
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
local lib, parent, private = AucSearchUI.NewSearcher("Disenchant")
if not lib then return end
--local print,decode,_,_,replicate,empty,_,_,_,debugPrint,fill = AucAdvanced.GetModuleLocals()
local get, set, default, Const, resources = parent.GetSearchLocals()
lib.tabname = "Disenchant"

-- Set our defaults
default("disenchant.profit.min", 1)
default("disenchant.profit.pct", 50)
default("disenchant.level.custom", false)
default("disenchant.level.min", 0)
default("disenchant.level.max", Const.MAXSKILLLEVEL)
default("disenchant.adjust.brokerage", true)
default("disenchant.adjust.deposit", true)
default("disenchant.adjust.listings", 3)
default("disenchant.allow.bid", true)
default("disenchant.allow.buy", true)
default("disenchant.maxprice", 10000000)
default("disenchant.maxprice.enable", false)
default("disenchant.model", "Enchantrix")

function private.doValidation()
	if not resources.isEnchantrixLoaded then
		message("Disenchant Searcher Warning!\nEnchantrix not detected\nThis searcher will not function until Enchantrix is loaded")
	elseif not resources.isValidPriceModel(get("disenchant.model")) then
		message("Disenchant Searcher Warning!\nCurrent price model setting ("..get("disenchant.model")..") is not valid. Select a new price model")
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
	gui:AddSearcher("Disenchant", "Search for items which can be disenchanted for profit", 100)
	gui:AddHelp(id, "disenchant searcher",
		"What does this searcher do?",
		"This searcher provides the ability to search for items that are able to be disenchanted into reagents that on average will have a greater value than the purchase price of the given item.")

	gui:AddControl(id, "Header",     0,      "Disenchant search criteria")

	local last = gui:GetLast(id)

	gui:AddControl(id, "MoneyFramePinned",  0, 1, "disenchant.profit.min", 1, Const.MAXBIDPRICE, "Minimum Profit")
	gui:AddControl(id, "Slider",            0, 1, "disenchant.profit.pct", 1, 100, .5, "Min Discount: %0.01f%%")
	gui:AddControl(id, "Checkbox",          0, 1, "disenchant.level.custom", "Use custom levels")
	gui:AddControl(id, "Slider",            0, 2, "disenchant.level.min", 0, Const.MAXSKILLLEVEL, 25, "Minimum skill: %s")
	gui:AddControl(id, "Slider",            0, 2, "disenchant.level.max", 25, Const.MAXSKILLLEVEL, 25, "Maximum skill: %s")
	gui:AddControl(id, "Subhead",           0, "Note:")
	gui:AddControl(id, "Note",              0, 1, 290, 30, "The \"Pct\" Column is \% of DE Value")

	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",          0.42, 1, "disenchant.allow.bid", "Allow Bids")
	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",          0.56, 1, "disenchant.allow.buy", "Allow Buyouts")
	gui:AddControl(id, "Checkbox",          0.42, 1, "disenchant.maxprice.enable", "Enable individual maximum price:")
	gui:AddTip(id, "Limit the maximum amount you want to spend with the Disenchant searcher")
	gui:AddControl(id, "MoneyFramePinned",  0.42, 2, "disenchant.maxprice", 1, Const.MAXBIDPRICE, "Maximum Price for Disenchant")

	gui:AddControl(id, "Subhead",           0.42,    "Price Valuation Method:")
	gui:AddControl(id, "Selectbox",         0.42, 1, resources.selectorPriceModelsEnx, "disenchant.model")
	gui:AddTip(id, "The pricing model that is used to work out the calculated value of items at the Auction House.")

	gui:AddControl(id, "Subhead",           0.42,    "Fees Adjustment")
	gui:AddControl(id, "Checkbox",          0.42, 1, "disenchant.adjust.brokerage", "Subtract auction fees")
	gui:AddControl(id, "Checkbox",          0.42, 1, "disenchant.adjust.deposit", "Subtract deposit")
	gui:AddControl(id, "Slider",            0.42, 1, "disenchant.adjust.listings", 1, 10, .1, "Ave relistings: %0.1fx")
end

function lib.Search(item)
	if not resources.isEnchantrixLoaded then
		return false, "Enchantrix not detected"
	end

	local itemQuality = item[Const.QUALITY]
	if itemQuality <= 1 then
		return false, "Item quality too low"
	end

	local bidprice, buyprice = item[Const.PRICE], item[Const.BUYOUT]
	local maxprice = get("disenchant.maxprice.enable") and get("disenchant.maxprice")
	if buyprice <= 0 or not get("disenchant.allow.buy") or (maxprice and buyprice > maxprice) then
		buyprice = nil
	end
	if not get("disenchant.allow.bid") or (maxprice and bidprice > maxprice) then
		bidprice = nil
	end
	if not (bidprice or buyprice) then
		return false, "Does not meet bid/buy requirements"
	end

	local minskill, maxskill
	if get("disenchant.level.custom") then
		minskill = get("disenchant.level.min")
		maxskill = get("disenchant.level.max")
	else
		minskill = 0
		maxskill = Enchantrix.Util.GetUserEnchantingSkill()
	end
	local skillneeded = Enchantrix.Util.DisenchantSkillRequiredForItemLevel(item[Const.ILEVEL], itemQuality)
	if (skillneeded < minskill) or (skillneeded > maxskill) then
		return false, "Skill not high enough to disenchant"
	end

	local data = Enchantrix.Storage.GetItemDisenchants(item[Const.LINK])	-- was Const.ITEMID
	if not data then
		return false, "Item not Disenchantable"
	end

	local total = data.total
	local market = 0
	if total and total[1] > 0 then
		local totalNumber, totalQuantity = unpack(total)
		local model = get("disenchant.model")
		local GetPrice = resources.lookupPriceModel[model]
		for result, resData in pairs(data) do
			if result ~= "total" then
				local resNumber, resYield = unpack(resData)
				local price = GetPrice(model, result)
				if price then
					market = market + price * resYield / totalNumber
				end
			end
		end
	end
	if market <= 0 then
		return false, "No price found"
	end

	--adjust for brokerage costs
	if get("disenchant.adjust.brokerage") then
		market = market * resources.CutAdjust
	end
	--adjust for deposit costs
	-- ### todo : to rework this better we really need to know what size stacks the results will be posted in,
	-- ### we know that deposit will be 20% of cost of 1 item in the stack,
	-- ### so for a stack of 10 the deposit will be stackprice * 0.1 * 0.2
	-- ### in future we should use the AucAdvanced.Post.GetDepositCost call
	if get("disenchant.adjust.deposit") then
		market = market - (market * 0.02 * get("disenchant.adjust.listings"))
	end

	-- check amount of profit
	local value = min (market*(100-get("disenchant.profit.pct"))/100, market-get("disenchant.profit.min"))
	if buyprice and buyprice <= value then
		return "buy", market
	elseif bidprice and bidprice <= value then
		return "bid", market
	end
	return false, "Not enough profit"
end

AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-SearchUI/SearcherDisenchant.lua $", "$Rev: 6415 $")
