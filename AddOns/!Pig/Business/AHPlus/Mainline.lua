local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGButton=Create.PIGButton
local PIGFontString=Create.PIGFontString
---
local Fun=addonTable.Fun
local BusinessInfo=addonTable.BusinessInfo
----------------------------------
function BusinessInfo.AHPlus_Mainline()
	if not PIGA["AHPlus"]["Open"] or AuctionHouseFrame.History then return end
	PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm]=PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm] or {}
	---缓存
	AuctionHouseFrame.History = PIGButton(AuctionHouseFrame,{"TOPRIGHT",AuctionHouseFrame,"TOPRIGHT",-100,-1},{110,18},"缓存价格",nil,nil,nil,nil,0);
	AuctionHouseFrame.History:SetFrameLevel(510)
	AuctionHouseFrame.huancunUI = CreateFrame("Frame", nil, AuctionHouseFrame,"BackdropTemplate");
	local HCUI = AuctionHouseFrame.huancunUI
	HCUI:SetBackdrop({bgFile = "interface/characterframe/ui-party-background.blp",edgeFile = "Interface/Tooltips/UI-Tooltip-Border",edgeSize = 13,});
	HCUI:SetBackdropBorderColor(0, 1, 1, 0.9);
	HCUI:SetPoint("TOPLEFT",AuctionHouseFrame,"TOPLEFT",4,-22);
	HCUI:SetPoint("BOTTOMRIGHT",AuctionHouseFrame,"BOTTOMRIGHT",-4,28);
	HCUI:SetFrameLevel(520)
	HCUI:Hide();
	HCUI.close = CreateFrame("Button",nil,HCUI, "UIPanelButtonTemplate");
	HCUI.close:SetSize(90,30);
	HCUI.close:SetPoint("CENTER",HCUI,"CENTER",0,-40);
	HCUI.close:SetText("关闭");
	HCUI.close:Hide();
	HCUI.close:HookScript("OnClick",function(self)
		HCUI:Hide()
	end)

	local jinduW,jinduH = 300,20
	HCUI.jindu = CreateFrame("StatusBar", nil, HCUI);
	HCUI.jindu:SetStatusBarTexture("interface/raidframe/raid-bar-hp-fill.blp")
	HCUI.jindu:SetStatusBarColor(0, 1, 0 ,1);
	HCUI.jindu:SetSize(jinduW,jinduH);
	HCUI.jindu:SetPoint("CENTER",HCUI,"CENTER",0,40);
	HCUI.jindu:SetMinMaxValues(0, 100)
	HCUI.jindu.BACKGROUND = HCUI.jindu:CreateTexture(nil, "BACKGROUND");
	HCUI.jindu.BACKGROUND:SetTexture("interface/characterframe/ui-party-background.blp")
	HCUI.jindu.BACKGROUND:SetAllPoints(HCUI.jindu)
	HCUI.jindu.BACKGROUND:SetColorTexture(1, 1, 1, 0.4)
	HCUI.jindu.t1 = PIGFontString(HCUI.jindu,{"CENTER",HCUI.jindu,"CENTER",0,0},"/","OUTLINE",13)
	HCUI.jindu.t2 = PIGFontString(HCUI.jindu,{"RIGHT",HCUI.jindu.t1,"LEFT",0,0},0,"OUTLINE",13)
	HCUI.jindu.t3 = PIGFontString(HCUI.jindu,{"LEFT",HCUI.jindu.t1,"RIGHT",0,0},0,"OUTLINE",13)
	HCUI.jindu.tbiaoti = PIGFontString(HCUI.jindu,{"BOTTOM",HCUI.jindu,"TOP",0,2},"正在扫描物品...","OUTLINE",13)
	HCUI.jindu.tname = PIGFontString(HCUI.jindu,{"TOP",HCUI.jindu,"BOTTOM",0,-2},"","OUTLINE",13)
	HCUI.UpdateF = CreateFrame("Frame")
	HCUI.UpdateF:Hide()
	----
	AuctionHouseFrame.History:HookScript("OnUpdate", function(self)
		local daojishitt = 900-(GetServerTime()-PIGA["AHPlus"]["DaojiTime"])
		if daojishitt<0 then
			self:Enable()
			self:SetText("缓存价格");
		else
			self:Disable()
			self:SetText("缓存价格("..daojishitt..")");
		end
	end)
	HCUI.auctions = {}
	HCUI.ItemLoadList = {}
	local function Save_Data()
		local shujuyuan = PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm]
		for k,v in pairs(HCUI.auctions) do
			if shujuyuan[k] then
				table.insert(shujuyuan[k][2],v[2])
   			else
   				shujuyuan[k]={v[1],{v[2]}}
   			end
		end
		HCUI.jindu.tbiaoti:SetText("价格缓存完毕");
		HCUI.jindu.tname:SetText("");
		HCUI.close:Show();
	end
	local function huancunData_End()
		if HCUI.yicunchu==nil then
			HCUI.jindu.tbiaoti:SetText("价格获取完毕,存储中...");
			C_Timer.After(0.6,Save_Data)
		else
			if HCUI.yicunchu then
				HCUI.jindu.tbiaoti:SetText("价格获取完毕,存储中...");
				C_Timer.After(0.6,Save_Data)
			else
				C_Timer.After(0.1,huancunData_End)
			end
		end
	end
	local function GetBuyoutPriceG(name,count,buyoutPrice,itemLink)
		if not HCUI.auctions[name] then
			local itemLinkJJ = Fun.GetItemLinkJJ(itemLink)
			HCUI.auctions[name]={itemLinkJJ,{buyoutPrice/count,GetServerTime()}}
		end
		HCUI.jishuID=HCUI.jishuID+1
		HCUI.jindu:SetValue(HCUI.jishuID);
	end
	local function huancunData_H(index)
		local name, texture, count, qualityID, usable, level, levelType, minBid, minIncrement, buyoutPrice, bidAmount, highBidder, bidderFullName, owner, ownerFullName, saleStatus, itemID, hasAllInfo = C_AuctionHouse.GetReplicateItemInfo(index)
		local ItemLink=C_AuctionHouse.GetReplicateItemLink(index)
		if not hasAllInfo then
			HCUI.yicunchu=false
			local item = Item:CreateFromItemID(itemID) -- itemID
			HCUI.ItemLoadList[item] = true
			item:ContinueOnItemLoad(function()
				HCUI.ItemLoadList[item] = nil
				local name, texture, count, qualityID, usable, level, levelType, minBid, minIncrement, buyoutPrice, bidAmount, highBidder, bidderFullName, owner, ownerFullName, saleStatus, itemID, hasAllInfo = C_AuctionHouse.GetReplicateItemInfo(index)
				local ItemLink=C_AuctionHouse.GetReplicateItemLink(index)
				HCUI.jindu.t2:SetText(index);
				HCUI.jindu.tname:SetText(name);
				GetBuyoutPriceG(name,count,buyoutPrice,ItemLink)
				if not next(HCUI.ItemLoadList) then
					HCUI.yicunchu=true
				end
			end)
		else
			HCUI.jindu.t2:SetText(index);
			HCUI.jindu.tname:SetText(name);
			GetBuyoutPriceG(name,count,buyoutPrice,ItemLink)
		end
	end
	local function GetItemsData()
		HCUI.jindu.tbiaoti:SetText("正在获取价格...");
		wipe(HCUI.auctions)
		wipe(HCUI.ItemLoadList)
		for i = 0, HCUI.ItemListNum-1 do
			C_Timer.After(i*HCUI.ScanCD,function()
				huancunData_H(i)
				if i==(HCUI.ItemListNum-1) then
					huancunData_End()
				end
			end)
		end
	end
	HCUI.UpdateF:HookScript("OnUpdate",function(self,sss)
		if self.jishiqitime>0.1 then
			self.jishiqitime=0
			if HCUI.SMend then
				self:Hide()
				HCUI.jindu.tbiaoti:SetText("物品扫描完毕,开始获取价格...");
				HCUI.ItemListNum = C_AuctionHouse.GetNumReplicateItems()
				HCUI.jindu.t3:SetText(HCUI.ItemListNum);
				HCUI.jindu:SetMinMaxValues(0, HCUI.ItemListNum)
				GetItemsData()
			else
				local AuctionsNum = C_AuctionHouse.GetNumReplicateItems()
				HCUI.jindu.t2:SetText(AuctionsNum);
				HCUI.jindu.t3:SetText(AuctionsNum);
			end
		else
			self.jishiqitime = self.jishiqitime + sss;
		end
	end)
	AuctionHouseFrame.History:HookScript("OnClick", function(self, button)
		self:Disable()
		AuctionHouseFrame.History:DEL_OLDdata()
		AuctionHouseFrame.SearchBar.FilterButton:Reset()
		HCUI:Show();
		HCUI.close:Hide();
		HCUI.jindu.tbiaoti:SetText("正在扫描物品...");
		HCUI.jindu:SetMinMaxValues(0, 100)
		HCUI.jindu:SetValue(100);
		HCUI.jindu.t2:SetText(0);
		HCUI.jindu.t3:SetText(0);
		HCUI.jindu.tname:SetText("");
		PIGA["AHPlus"]["DaojiTime"]=GetServerTime()
		HCUI.ScanCD=BusinessInfo.AHPlusData.ScanCD
		HCUI.jishuID = 0
		HCUI.yicunchu=nil
		HCUI.SMend=nil
		HCUI.UpdateF.jishiqitime=1
		HCUI.UpdateF:Show()
		C_AuctionHouse.ReplicateItems()
	end)
	local baocunnum = 40
	function AuctionHouseFrame.History:DEL_OLDdata()
		for k,v in pairs(PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm]) do
			local itemDataL = v[2]
			local ItemsNum = #itemDataL;
			if ItemsNum>baocunnum then
				for ivb=(ItemsNum-baocunnum),1,-1 do
					table.remove(itemDataL,ivb)
				end
			end
		end
	end
	HCUI.UpdateF:RegisterEvent("REPLICATE_ITEM_LIST_UPDATE")
	HCUI.UpdateF:HookScript("OnEvent",function(self,event)
		if event == "REPLICATE_ITEM_LIST_UPDATE" then
			if not HCUI.SMend then
				HCUI.SMend=true
			end
		end
	end)
	function HCUI.showhide()
		HCUI.UpdateF:Hide()
		HCUI:Hide();
		HCUI.close:Hide();
	end
	AuctionHouseFrame:HookScript("OnShow",HCUI.showhide)
	AuctionHouseFrame:HookScript("OnHide",HCUI.showhide)
	---------------------
	for i = 1, 33 do
		local huizhangG = PIGFontString(AuctionHouseFrame.WoWTokenResults,nil,nil,nil,13,"huizhangG_"..i)
		if i==1 then
			huizhangG:SetPoint("TOPLEFT",AuctionHouseFrame.WoWTokenResults,"TOPLEFT",6,-8);
		elseif i==4 then
			huizhangG:SetPoint("TOPLEFT",AuctionHouseFrame.WoWTokenResults,"TOPLEFT",6,-150);
		elseif i==19 then
			huizhangG:SetPoint("TOPRIGHT",AuctionHouseFrame.WoWTokenResults,"TOPRIGHT",-6,-150);
		else
			huizhangG:SetPoint("TOPLEFT",_G["huizhangG_"..(i-1)],"BOTTOMLEFT",0,-4);
		end
		huizhangG:SetJustifyH("LEFT");
	end
	local function Update_huizhangG()
		local lishihuizhangG = PIGA["AHPlus"]["Tokens"]
		local SHUJUNUM = #lishihuizhangG
		local shujukaishiid = 0
		if SHUJUNUM>33 then
			shujukaishiid=SHUJUNUM-33
		end
		for i = 1, 33 do
			local shujuid = i+shujukaishiid
			if lishihuizhangG[shujuid] then
				local tiem1 = date("%Y-%m-%d %H:%M",lishihuizhangG[shujuid][1])
				local jinbiV = lishihuizhangG[shujuid][2] or 0
				local jinbiV = (jinbiV/10000)
				_G["huizhangG_"..i]:SetText(tiem1.."：|cffFFFF00"..jinbiV.."G|r")
			end
		end
	end
	AuctionHouseFrame.WoWTokenResults:HookScript("OnShow",function(self)
		Update_huizhangG()
	end)
	---
end