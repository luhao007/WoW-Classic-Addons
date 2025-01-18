local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGFontString=Create.PIGFontString
---
local gsub = _G.string.gsub
local match = _G.string.match
local Fun=addonTable.Fun
local BusinessInfo=addonTable.BusinessInfo
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
----------------------------------
function BusinessInfo.AHPlus_Mainline()
	if not PIGA["AHPlus"]["Open"] or AuctionHouseFrame.History then return end
	local function Show_hangdata(hangui)
		local itemKey = hangui.rowData.itemKey
		local itemKeyInfo = C_AuctionHouse.GetItemKeyInfo(itemKey);
		if itemKeyInfo then
			local minPrice = hangui.rowData and hangui.rowData.minPrice
			if minPrice and minPrice>0 then
				local newName=nil
				local Name = hangui.cells[2].Text:GetText()
				if Name then
					if Name:match("（") then
						newName = Name:match("|cff%w%w%w%w%w%w(.-)（%w+）|r")
					else
						newName = Name:match("|cff%w%w%w%w%w%w(.-)|r")
					end
					hangui.updown.Text:SetTextColor(0.5, 0.5, 0.5, 0.5);
					hangui.updown.Text:SetText("--");
					if newName and PIGA["AHPlus"]["CacheData"][newName] then
						local OldMoneyG = PIGA["AHPlus"]["CacheData"][newName][2]
						local OldGGGV = OldMoneyG[#OldMoneyG]
						local baifenbi = (minPrice/OldGGGV[1])*100+0.5
						local baifenbi = floor(baifenbi)
						hangui.updown.Text:SetText(baifenbi.."%");
						hangui.updown.newName=newName
						if baifenbi<100 then
							hangui.updown.Text:SetTextColor(0, 1, 0, 1);
						elseif baifenbi>100 then
							hangui.updown.Text:SetTextColor(1, 0, 0, 1);
						else
							hangui.updown.Text:SetTextColor(1, 1, 1, 1);
						end
					end
				end
			end
		else
			C_Timer.After(0.01,function()
				Show_hangdata(hangui)
			end)
		end
	end
	hooksecurefunc(AuctionHouseFrame.BrowseResultsFrame.ItemList.ScrollBox, "OnViewInitializedFrame", function(frame, elementData)
		--local dataID = elementData:GetElementData()
		local Mfuji = elementData
		if not Mfuji.updown then
			Mfuji.updown = CreateFrame("Frame", nil, Mfuji);
			Mfuji.updown:SetSize(44,18);
			Mfuji.updown:SetPoint("LEFT",Mfuji,"LEFT",110,0);
			Mfuji.updown.Text = PIGFontString(Mfuji.updown,{"RIGHT",Mfuji.updown,"RIGHT",0,0})
			Mfuji.updown.Text:SetPoint("LEFT",Mfuji.updown,"LEFT",0,0);
			Mfuji.updown.Text:SetJustifyH("RIGHT");
			Mfuji.updown:HookScript("OnEnter", function(self)
				self:GetParent().HighlightTexture:Show();
				local name = self.newName
				if name then
					if PIGA["AHPlus"]["CacheData"][name] then
						local jiagGGG = PIGA["AHPlus"]["CacheData"][name][2]
						AuctionHouseFrame.BrowseResultsFrame.qushi:Show()
						AuctionHouseFrame.BrowseResultsFrame.qushi:SetPoint("TOPRIGHT",self,"TOPLEFT",18,1);
						local Name = self:GetParent().cells[2].Text:GetText()
						AuctionHouseFrame.BrowseResultsFrame.qushi.qushitu(jiagGGG,Name)
					end
				end
			end);
			Mfuji.updown:HookScript("OnLeave", function(self)
				self:GetParent().HighlightTexture:Hide();
				AuctionHouseFrame.BrowseResultsFrame.qushi:Hide()
			end);
		end
		Show_hangdata(Mfuji)	
	end)
	AuctionHouseFrame.BrowseResultsFrame.qushi,AuctionHouseFrame.BrowseResultsFrame.qushitishi=BusinessInfo.ADD_qushi(AuctionHouseFrame.BrowseResultsFrame,true)
	AuctionHouseFrame.BrowseResultsFrame.qushitishi:SetPoint("TOPLEFT",AuctionHouseFrame.BrowseResultsFrame,"TOPLEFT",128,-3);
	AuctionHouseFrame.BrowseResultsFrame.qushitishi:SetFrameLevel(510)

	---缓存----------
	AuctionHouseFrame.History = PIGButton(AuctionHouseFrame,{"TOPRIGHT",AuctionHouseFrame,"TOPRIGHT",-100,-1},{110,18},"缓存价格",nil,nil,nil,nil,0);
	AuctionHouseFrame.History:SetFrameLevel(510)
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

	AuctionHouseFrame.huancunUI = CreateFrame("Frame", nil, AuctionHouseFrame,"BackdropTemplate");
	local HCUI = AuctionHouseFrame.huancunUI
	HCUI:SetBackdrop({bgFile = "interface/characterframe/ui-party-background.blp",edgeFile = "Interface/Tooltips/UI-Tooltip-Border",edgeSize = 13,});
	HCUI:SetBackdropBorderColor(0, 1, 1, 0.9);
	HCUI:SetPoint("TOPLEFT",AuctionHouseFrame,"TOPLEFT",4,-22);
	HCUI:SetPoint("BOTTOMRIGHT",AuctionHouseFrame,"BOTTOMRIGHT",-4,28);
	HCUI:SetFrameLevel(520)
	HCUI:Hide();
	HCUI.close = PIGButton(HCUI,{"CENTER",HCUI,"CENTER",0,-40},{90,30},"关闭",nil,nil,nil,nil,0);
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
	HCUI.UpdateF = CreateFrame("Frame")
	HCUI.UpdateF:Hide()
	----
	HCUI.auctions = {}
	HCUI.auctionsLin = {}
	HCUI.ItemLoadList = {}
	local function OpenScanFun(v)
		if v then
			AuctionHouseFrame.BrowseResultsFrame:UnregisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED");
		else
			AuctionHouseFrame.BrowseResultsFrame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED");
		end
	end
	local function au_SetValue()
		HCUI.jishuID=HCUI.jishuID+1
		HCUI.jindu.t2:SetText(HCUI.jishuID);
		HCUI.jindu:SetValue(HCUI.jishuID);
	end
	local function Save_Data()
		local AH_data = PIGA["AHPlus"]["CacheData"]
		for k,v in pairs(HCUI.auctions) do
			if AH_data[k] then
				table.insert(AH_data[k][2],{v[1],GetServerTime()})
   			else
   				AH_data[k]={v[2],{{v[1],GetServerTime()}}}
   			end
		end
		HCUI.jindu.tbiaoti:SetText("价格缓存完毕");
		HCUI.close:Show();
		OpenScanFun(nil)
	end
	local function SauctionsLinData(name,buyoutPrice,count,index)
		if name and name~="" and name~=" " and buyoutPrice>0 then
			local ItemLink=C_AuctionHouse.GetReplicateItemLink(index)
			local xianzaidanjia =buyoutPrice/count
			HCUI.auctionsLin[index]={name,xianzaidanjia,ItemLink}
		end
		au_SetValue()
	end
	local meiyenum = 300
	local function huancunData_End()
		if not HCUI:IsShown() then return end
		if HCUI.yicunchu==nil or HCUI.yicunchu==true or HCUI.cunchuNum>5 then
			HCUI.jindu.tbiaoti:SetText("价格缓存完毕,存储中...");
			for k,v in pairs(HCUI.auctionsLin) do
				local name = v[1]
				local newGGG = v[2]
				if HCUI.auctions[name] then
	   				if newGGG<HCUI.auctions[name][1] then
	   					HCUI.auctions[name][1]=newGGG
	   				end
				else
					local itemLinkJJ = Fun.GetItemLinkJJ(v[3])
					HCUI.auctions[name]={newGGG,itemLinkJJ}
				end
			end
			C_Timer.After(0.4,Save_Data)
		else
			HCUI.cunchuNum=HCUI.cunchuNum+1
			C_Timer.After(0.1,huancunData_End)
		end
	end
	HCUI.UpdateF:HookScript("OnUpdate",function(self,sss)
		if self.jishiqitime>0.1 then
			self.jishiqitime=0
			if HCUI.SMend then
				self:Hide()
				HCUI.jindu.tbiaoti:SetText("物品扫描完毕,开始获取价格...");
				local numReplicateItems = C_AuctionHouse.GetNumReplicateItems()
				HCUI.jindu.t3:SetText(numReplicateItems);
				HCUI.jindu:SetMinMaxValues(0, numReplicateItems)
				HCUI.jindu.tbiaoti:SetText("正在缓存价格...");
				HCUI.ScanCD=BusinessInfo.AHPlusData.ScanCD
				wipe(HCUI.auctions)
				wipe(HCUI.auctionsLin)
				wipe(HCUI.ItemLoadList)
				if numReplicateItems>0 then
					local page=math.ceil(numReplicateItems/meiyenum)
					local numItems=numReplicateItems-1
					C_Timer.After(0.6,function()
						for ix=0,(page-1) do
							C_Timer.After(ix*HCUI.ScanCD,function()
								local kaishi = ix*meiyenum
								local jieshu = kaishi+meiyenum-1
								if jieshu>numItems then
									jieshu = numItems
								end
								for index=kaishi,jieshu do
									local name, texture, count, qualityID, usable, level, levelType, minBid, minIncrement, buyoutPrice, bidAmount, highBidder, bidderFullName, owner, ownerFullName, saleStatus, itemID, hasAllInfo = C_AuctionHouse.GetReplicateItemInfo(index)
									if hasAllInfo then
										SauctionsLinData(name,buyoutPrice,count,index)
									else
										HCUI.yicunchu=false
										local itemf = Item:CreateFromItemID(itemID)
										itemf.index=index
										HCUI.ItemLoadList[itemf] = true
										itemf:ContinueOnItemLoad(function()
											local name, texture, count, qualityID, usable, level, levelType, minBid, minIncrement, buyoutPrice = C_AuctionHouse.GetReplicateItemInfo(itemf.index)
											SauctionsLinData(name,buyoutPrice,count,itemf.index)
											HCUI.ItemLoadList[itemf] = nil
											if not next(HCUI.ItemLoadList) then
												HCUI.yicunchu=true
											end
										end)
									end
									if index>=numItems then
										huancunData_End()
									end
								end
							end)
						end
					end)
				else
					huancunData_End()
				end
			else
				local numReplicateItems = C_AuctionHouse.GetNumReplicateItems()
				HCUI.jindu.t2:SetText(numReplicateItems);
				HCUI.jindu.t3:SetText(numReplicateItems);
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
		PIGA["AHPlus"]["DaojiTime"]=GetServerTime()
		HCUI.ScanCD=BusinessInfo.AHPlusData.ScanCD
		HCUI.jishuID = 0
		HCUI.cunchuNum=0
		HCUI.yicunchu=nil
		HCUI.SMend=nil
		OpenScanFun(true)
		HCUI.UpdateF.jishiqitime=1
		HCUI.UpdateF:Show()
		C_AuctionHouse.ReplicateItems()
	end)
	local baocunnum = 40
	function AuctionHouseFrame.History:DEL_OLDdata()
		for k,v in pairs(PIGA["AHPlus"]["CacheData"]) do
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
	function HCUI.UiFameHide()
		HCUI.UpdateF:Hide()
		HCUI:Hide();
		HCUI.close:Hide();
		OpenScanFun(nil)
	end
	AuctionHouseFrame.BrowseResultsFrame:HookScript("OnShow",HCUI.UiFameHide)
	AuctionHouseFrame.BrowseResultsFrame:HookScript("OnHide",HCUI.UiFameHide)
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