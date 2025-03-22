--记录交易信息------
local addonName, addonTable = ...;
local PIGGetRaceAtlas=addonTable.Fun.PIGGetRaceAtlas
-- TradeFrame:RegisterEvent("TRADE_CLOSED");
-- TradeFrame:RegisterEvent("TRADE_SHOW");
-- TradeFrame:RegisterEvent("TRADE_UPDATE");
-- TradeFrame:RegisterEvent("TRADE_TARGET_ITEM_CHANGED");--目标交易窗物品发生更改
-- TradeFrame:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED");--自己交易窗物品发生更改
-- TradeFrame:RegisterEvent("TRADE_ACCEPT_UPDATE");--当玩家和目标接受按钮的状态更改时触发。
-- TradeFrame:RegisterEvent("TRADE_POTENTIAL_BIND_ENCHANT");--附魔绑定
-- TradeFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED");
-- TradeFrame:RegisterEvent("UI_INFO_MESSAGE");--交易信息
local initialData={
	["Name"]=NONE,
	["All_Name"]=NONE,
	["Race"]=NONE,
	["Class"]=NONE,
	["Level"]=NONE,
	["MoneyT"]=0,
	["MoneyP"]=0,
	["ItemT"]={[1]=NONE,[2]=NONE,[3]=NONE,[4]=NONE,[5]=NONE,[6]=NONE},
	["ItemP"]={[1]=NONE,[2]=NONE,[3]=NONE,[4]=NONE,[5]=NONE,[6]=NONE},
}
local function initial_data(self)
	self.PIG_Data["Name"]=initialData["Name"]
	self.PIG_Data["All_Name"]=initialData["All_Name"]
	self.PIG_Data["Race"]=initialData["Race"]
	self.PIG_Data["Class"]=initialData["Class"]
	self.PIG_Data["Level"]=initialData["Level"]
	self.PIG_Data["MoneyT"]=initialData["MoneyT"]
	self.PIG_Data["MoneyP"]=initialData["MoneyP"]
	self.PIG_Data["ItemT"]={[1]=initialData["ItemT"][1],[2]=initialData["ItemT"][2],[3]=initialData["ItemT"][3],[4]=initialData["ItemT"][4],[5]=initialData["ItemT"][5],[6]=initialData["ItemT"][6]}
	self.PIG_Data["ItemP"]={[1]=initialData["ItemP"][1],[2]=initialData["ItemP"][2],[3]=initialData["ItemP"][3],[4]=initialData["ItemP"][4],[5]=initialData["ItemP"][5],[6]=initialData["ItemP"][6]}
end
TradeFrame.PIG_Data={}
initial_data(TradeFrame)
TradeFrame:HookScript("OnEvent",function (self,event,arg1,arg2,arg3,arg4,arg5)
	--print(event)
	if event=="TRADE_CLOSED" or event=="GET_ITEM_INFO_RECEIVED" then
		--initial_data(self)
	else
		initial_data(self)
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
		if self.PIG_Data.Name:match("-") then
			self.PIG_Data.All_Name=self.PIG_Data.Name
		else
			self.PIG_Data.All_Name=self.PIG_Data.Name.."-"..Pig_OptionsUI.Realm
		end
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