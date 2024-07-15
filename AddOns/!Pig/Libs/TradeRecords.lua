--记录交易信息------
local addonName, addonTable = ...;
local PIGGetRaceAtlas=addonTable.Fun.PIGGetRaceAtlas
local PIG_Data={
	["Name"]=NONE,
	["Race"]=NONE,
	["Class"]=NONE,
	["Level"]=NONE,
	["MoneyT"]=0,
	["MoneyP"]=0,
	["ItemT"]={[1]=NONE,[2]=NONE,[3]=NONE,[4]=NONE,[5]=NONE,[6]=NONE},
	["ItemP"]={[1]=NONE,[2]=NONE,[3]=NONE,[4]=NONE,[5]=NONE,[6]=NONE},
}
-- TradeFrame:RegisterEvent("TRADE_CLOSED");
-- TradeFrame:RegisterEvent("TRADE_SHOW");
-- TradeFrame:RegisterEvent("TRADE_UPDATE");
-- TradeFrame:RegisterEvent("TRADE_TARGET_ITEM_CHANGED");--目标交易窗物品发生更改
-- TradeFrame:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED");--自己交易窗物品发生更改
-- TradeFrame:RegisterEvent("TRADE_ACCEPT_UPDATE");--当玩家和目标接受按钮的状态更改时触发。
-- TradeFrame:RegisterEvent("TRADE_POTENTIAL_BIND_ENCHANT");--附魔绑定
-- TradeFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED");
-- TradeFrame:RegisterEvent("UI_INFO_MESSAGE");--交易信息
TradeFrame:HookScript("OnEvent",function (self,event,arg1,arg2,arg3,arg4,arg5)
	--print(event)
	if event=="TRADE_CLOSED" or event=="GET_ITEM_INFO_RECEIVED" then
		--TradeFrame.PIG_Data=PIG_Data
	else
		TradeFrame.PIG_Data=PIG_Data
		if UnitExists("NPC") then
			local _, raceFile, raceID = UnitRace("NPC")
			local gender = UnitSex("NPC")
			local race_icon = PIGGetRaceAtlas(raceFile,gender)
			local _, _, classId =UnitClass("NPC")
			local Level = UnitLevel("NPC")
			self.PIG_Data.Race=race_icon
			self.PIG_Data.Class=classId
			self.PIG_Data.Level=Level
		end
		self.PIG_Data.Name=GetUnitName("NPC", true) or self.PIG_Data.Name
		self.PIG_Data.MoneyT=GetTargetTradeMoney();
		self.PIG_Data.MoneyP=GetPlayerTradeMoney();
		for i=1, MAX_TRADE_ITEMS, 1 do
			local TargetItemlink=GetTradeTargetItemLink(i)
			if TargetItemlink then
				local name, texture, numItems, quality, enchantment, canLoseTransmog, isBound = GetTradeTargetItemInfo(i);
				self.PIG_Data.ItemT[i]={TargetItemlink,numItems}
			else
				self.PIG_Data.ItemT[i]=NONE
			end
			local PlayerItemLink=GetTradePlayerItemLink(i)
			if PlayerItemLink then
				local name, texture, numItems, quality, enchantment, canLoseTransmog, isBound = GetTradePlayerItemInfo(i);
				self.PIG_Data.ItemP[i]={PlayerItemLink,numItems}
			else
				self.PIG_Data.ItemP[i]=NONE
			end 
		end
	end
end)