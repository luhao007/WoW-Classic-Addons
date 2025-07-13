--记录交易信息------
local addonName, addonTable = ...;
local PIGGetRaceAtlas=addonTable.Fun.PIGGetRaceAtlas
TradeFrame.PIG_Data={}
-- TradeFrame:RegisterEvent("TRADE_CLOSED");
-- TradeFrame:RegisterEvent("TRADE_SHOW");
-- TradeFrame:RegisterEvent("TRADE_UPDATE");
-- TradeFrame:RegisterEvent("TRADE_TARGET_ITEM_CHANGED");--目标交易窗物品发生更改
-- TradeFrame:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED");--自己交易窗物品发生更改
-- TradeFrame:RegisterEvent("TRADE_ACCEPT_UPDATE");--当玩家和目标接受按钮的状态更改时触发。
-- TradeFrame:RegisterEvent("TRADE_POTENTIAL_BIND_ENCHANT");--附魔绑定
-- TradeFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED");
-- TradeFrame:RegisterEvent("PLAYER_TRADE_MONEY");
-- TradeFrame:RegisterEvent("TRADE_MONEY_CHANGED");
TradeFrame:HookScript("OnEvent",function (self,event)
	if event=="TRADE_CLOSED" or event=="GET_ITEM_INFO_RECEIVED" then
		
	else
		if not UnitExists("NPC") then return end
		wipe(self.PIG_Data)
		self.PIG_Data.ItemT={[1]=NONE,[2]=NONE,[3]=NONE,[4]=NONE,[5]=NONE,[6]=NONE}
		self.PIG_Data.ItemP={[1]=NONE,[2]=NONE,[3]=NONE,[4]=NONE,[5]=NONE,[6]=NONE}
		local _, raceFile = UnitRace("NPC")
		local gender = UnitSex("NPC")
		local race_icon = PIGGetRaceAtlas(raceFile,gender or 2)
		local _, _, classId =UnitClass("NPC")
		local Level = UnitLevel("NPC")
		self.PIG_Data.Race=race_icon
		self.PIG_Data.Class=classId or 1
		self.PIG_Data.Level=Level or 1
		self.PIG_Data.Name=GetUnitName("NPC", true)
		if self.PIG_Data.Name:match("-") then
			self.PIG_Data.All_Name=self.PIG_Data.Name
		else
			self.PIG_Data.All_Name=self.PIG_Data.Name.."-"..PIG_OptionsUI.Realm
		end
		self.PIG_Data.MoneyT=GetTargetTradeMoney();
		self.PIG_Data.MoneyP=GetPlayerTradeMoney();
		for i=1, MAX_TRADE_ITEMS, 1 do
			local TargetItemlink=GetTradeTargetItemLink(i)
			if TargetItemlink then
				local name, texture, numItems, quality, enchantment, canLoseTransmog, isBound = GetTradeTargetItemInfo(i);
				self.PIG_Data.ItemT[i]={TargetItemlink,numItems}
			end
			local PlayerItemLink=GetTradePlayerItemLink(i)
			if PlayerItemLink then
				local name, texture, numItems, quality, enchantment, canLoseTransmog, isBound = GetTradePlayerItemInfo(i);
				self.PIG_Data.ItemP[i]={PlayerItemLink,numItems}
			end 
		end
	end
end)