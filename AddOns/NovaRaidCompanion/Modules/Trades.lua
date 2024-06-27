-----------------------------
---NovaRaidCompanion Trades--
-----------------------------
local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

local f = CreateFrame("Frame");
f:RegisterEvent("TRADE_SHOW");
--f:RegisterEvent("TRADE_CLOSED");
--f:RegisterEvent("PLAYER_TRADE_MONEY");
f:RegisterEvent("TRADE_MONEY_CHANGED");
f:RegisterEvent("TRADE_ACCEPT_UPDATE");
f:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED");
f:RegisterEvent("TRADE_TARGET_ITEM_CHANGED");
f:RegisterEvent("TRADE_REQUEST_CANCEL");
f:RegisterEvent("UI_INFO_MESSAGE");
f:RegisterEvent("UI_ERROR_MESSAGE");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
local playerMoney, targetMoney, tradeWho, tradeWhoClass, tradeWhoRealm, tradeWhoLevel, playerItems, targetItems,
		playerItemsEnchant, targetItemsEnchant = 0, 0, "", "", "", 0, {}, {}, {}, {};
local doTrade;
f:SetScript("OnEvent", function(self, event, ...)
	if (event == "TRADE_SHOW") then
		tradeWho, tradeWhoRealm = UnitName("npc");
		_, tradeWhoClass = UnitClass("npc");
	elseif (event == "TRADE_MONEY_CHANGED") then
		playerMoney = GetPlayerTradeMoney();
		targetMoney = GetTargetTradeMoney();
	elseif (event == "TRADE_ACCEPT_UPDATE") then
		playerMoney = GetPlayerTradeMoney();
		targetMoney = GetTargetTradeMoney();
	elseif (event == "TRADE_PLAYER_ITEM_CHANGED" or event == "TRADE_TARGET_ITEM_CHANGED") then
		NRC:updateTradeItems();
	elseif (event == "TRADE_REQUEST_CANCEL") then
		NRC:resetCurrentTradeData();
	elseif (event == "UI_INFO_MESSAGE" or event == "UI_ERROR_MESSAGE") then
		local type, msg = ...;
		if (msg == ERR_TRADE_BAG_FULL or msg == ERR_TRADE_TARGET_BAG_FULL or msg == ERR_TRADE_CANCELLED
				or msg == ERR_TRADE_TARGET_MAX_LIMIT_CATEGORY_COUNT_EXCEEDED_IS) then
			NRC:resetCurrentTradeData();
		elseif (msg == ERR_TRADE_COMPLETE) then
			NRC:doTrade();
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		NRC:trimTrades();
		f:UnregisterEvent("PLAYER_ENTERING_WORLD");
	end
end)

function NRC:updateTradeItems()
	playerItems = {};
	targetItems = {};
	playerItemsEnchant = {};
	targetItemsEnchant = {};
	local enchantSlot = MAX_TRADABLE_ITEMS + 1;
	for i = 1, MAX_TRADABLE_ITEMS do
		local name, texture, count, quality, enchant = GetTradePlayerItemInfo(i);
		local itemLink = GetTradePlayerItemLink(i);
		if (itemLink) then
			local t = {
				itemLink = itemLink,
				texture = texture,
			};
			if (count and count > 1) then
				t.count = count;
			end
			if (itemLink == "") then
				--Some items don't have an itemlink here it seems, record item name and quality instead.
				t.itemLink = nil;
				t.name = name;
				t.quality = quality;
			end
			tinsert(playerItems, t);
		end
		local name, texture, count, quality, isUsable, enchant = GetTradeTargetItemInfo(i);
		local itemLink = GetTradeTargetItemLink(i);
		if (itemLink) then
			local t = {
				itemLink = itemLink,
				texture = texture,
			};
			if (count and count > 1) then
				t.count = count;
			end
			if (itemLink == "") then
				t.itemLink = nil;
				t.name = name;
				t.quality = quality;
			end
			tinsert(targetItems, t);
		end
	end
	local name, texture, count, quality, enchant = GetTradePlayerItemInfo(enchantSlot);
	local itemLink = GetTradePlayerItemLink(enchantSlot);
	if (itemLink and enchant) then
		local t = {
			itemLink = itemLink,
			texture = texture,
			enchant = enchant,
		};
		if (itemLink == "") then
			t.itemLink = nil;
			t.name = name;
			t.quality = quality;
		end
		tinsert(playerItemsEnchant, t);
	end
	local name, texture, count, quality, isUsable, enchant = GetTradeTargetItemInfo(enchantSlot);
	local itemLink = GetTradeTargetItemLink(enchantSlot);
	if (itemLink and enchant) then
		local t = {
			itemLink = itemLink,
			texture = texture,
			enchant = enchant,
		};
		if (itemLink == "") then
			t.itemLink = nil;
			t.name = name;
			t.quality = quality;
		end
		tinsert(targetItemsEnchant, t);
	end
end

function NRC:doTrade()
	local traded, pMoney, tMoney, pItems, tItems, pItemsEnchant, tItemsEnchant;
	local _, _, _, classColorHex = GetClassColor(string.upper(tradeWhoClass));
	--Safeguard for weakauras/addons that like to overwrite and break the GetClassColor() function.
	if (not classColorHex and string.upper(tradeWhoClass) == "SHAMAN") then
		classColorHex = "ff0070dd";
	elseif (not classColorHex) then
		classColorHex = "ffffffff";
	end
	local NIT_Installed;
	if (NIT and NIT.db.global.showMoneyTradedChat) then
		NIT_Installed = true;
	end
	if (playerMoney > 0) then
		if (NRC.config.showMoneyTradedChat and not NIT_Installed) then
			NRC:print("|HNRCCustomLink:tradelog|h|cFF9CD6DE" .. L["Gave"] .. "|r|h |r" .. NRC:getCoinString(playerMoney)
					.. NRC.chatColor .. " |HNRCCustomLink:tradelog|h|cFF9CD6DE" .. L["to"] .. "|r |c"
					.. classColorHex .. tradeWho .. NRC.chatColor .. ".|h", nil, nil, true, true);
		end
		pMoney = playerMoney;
		traded = true;
	end
	if (targetMoney > 0) then
		if (NRC.config.showMoneyTradedChat and not NIT_Installed) then
			NRC:print("|HNRCCustomLink:tradelog|h|cFF9CD6DE" .. L["Received"] .. "|r|h |r" .. NRC:getCoinString(targetMoney)
					.. NRC.chatColor .. " |HNRCCustomLink:tradelog|h|cFF9CD6DE" .. L["from"] .. "|r |c"
					.. classColorHex .. tradeWho .. NRC.chatColor .. ".|h", nil, nil, true, true);
		end
		tMoney = targetMoney;
		traded = true;
	end
	if (next(playerItems)) then
		pItems = playerItems;
		traded = true;
	end
	if (next(targetItems)) then
		tItems = targetItems;
		traded = true;
	end
	if (next(playerItemsEnchant)) then
		pItemsEnchant = playerItemsEnchant;
		traded = true;
	end
	if (next(targetItemsEnchant)) then
		tItemsEnchant = targetItemsEnchant;
		traded = true;
	end
	local where = GetZoneText() or "";
	if (NRC.raid) then
		local instanceName = GetInstanceInfo();
		where = instanceName;
	end
	local _, meClass = UnitClass("player");
	if (traded) then
		local t = {
			me = UnitName("player"),
			meClass = meClass,
			playerMoney = pMoney,
			targetMoney = tMoney,
			tradeWho = tradeWho,
			tradeWhoClass = tradeWhoClass,
			where = where,
			time = GetServerTime(),
			playerItems = pItems;
			targetItems = tItems;
			playerItemsEnchant = pItemsEnchant;
			targetItemsEnchant = tItemsEnchant;
			--raid = NRC.lastRaidGroupInstanceID,
			raidID = NRC.lastRaidID,
		};
		tinsert(NRC.db.global.trades, 1, t);
	end
	NRC:resetCurrentTradeData();
	NRC:updateTradeFrame();
end

function NRC:resetCurrentTradeData()
	playerMoney, targetMoney, tradeWho, tradeWhoClass, tradeWhoRealm, tradeWhoLevel, playerItems, targetItems,
			playerItemsEnchant, targetItemsEnchant = 0, 0, "", "", "", 0, {}, {}, {}, {};
end

function NRC:trimTrades()
	local max = NRC.db.global.maxTradesKept;
	if (max > 1000) then
		max = 1000;
	end
	local trades = NRC.db.global.trades;
	for i, v in pairs(trades) do
		if (i > max) then
			table.remove(trades, i);
		end
	end
end