local addonName, addonTable = ...;
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGFontString=Create.PIGFontString
---
local gsub = _G.string.gsub
local match = _G.string.match
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
				local name = hangui.cells[2].Text:GetText()
				local data = C_TooltipInfo.GetItemKey(itemKey.itemID, itemKey.itemLevel, itemKey.itemSuffix,itemKey.battlePetSpeciesID)
				if name then
					if name:match("（") then
						newName = name:match("|cff%w%w%w%w%w%w(.-)（%w+）|r")
					else
						newName = name:match("|cff%w%w%w%w%w%w(.-)|r")
					end
					hangui.updown.Text:SetTextColor(0.5, 0.5, 0.5, 0.5);
					hangui.updown.Text:SetText("--");
					local NewData=BusinessInfo.GetCacheDataG(newName)
					if NewData then
						local NewDataNum = #NewData
						local OldGGGV_1 = NewData[NewDataNum]
						local baifenbi = (minPrice/OldGGGV_1[1])*100+0.5
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
						if minPrice~=OldGGGV_1[1] and GetServerTime()-OldGGGV_1[2]>300 then
							BusinessInfo.ADD_Newdata(newName,minPrice,data.hyperlink,itemKey.itemID)
						end
					else				
						BusinessInfo.ADD_Newdata(newName,minPrice,data.hyperlink,itemKey.itemID)
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
				if self.newName then
					local NewData=BusinessInfo.GetCacheDataG(self.newName)
					if NewData then
						AuctionHouseFrame.BrowseResultsFrame.qushiUI:Show()
						AuctionHouseFrame.BrowseResultsFrame.qushiUI:SetPoint("TOPRIGHT",self,"TOPLEFT",18,1);
						local Name = self:GetParent().cells[2].Text:GetText()
						AuctionHouseFrame.BrowseResultsFrame.qushiUI.qushiF.qushitu(NewData,Name)
					end
				end
			end);
			Mfuji.updown:HookScript("OnLeave", function(self)
				self:GetParent().HighlightTexture:Hide();
				AuctionHouseFrame.BrowseResultsFrame.qushiUI:Hide()
			end);
		end
		Show_hangdata(Mfuji)	
	end)
	AuctionHouseFrame.BrowseResultsFrame.qushiUI=PIGFrame(AuctionHouseFrame.BrowseResultsFrame)
	AuctionHouseFrame.BrowseResultsFrame.qushiUI:SetSize(328,204);
	AuctionHouseFrame.BrowseResultsFrame.qushiUI:PIGSetBackdrop(1,nil,nil,nil,0)
	AuctionHouseFrame.BrowseResultsFrame.qushiUI:SetFrameStrata("HIGH")
	AuctionHouseFrame.BrowseResultsFrame.qushiUI.qushiF=BusinessInfo.ADD_qushi(AuctionHouseFrame.BrowseResultsFrame.qushiUI,true)
	AuctionHouseFrame.BrowseResultsFrame.qushiUI.qushiF:SetPoint("TOPLEFT", AuctionHouseFrame.BrowseResultsFrame.qushiUI, "TOPLEFT",4, -24);
	AuctionHouseFrame.BrowseResultsFrame.qushiUI.qushiF:SetPoint("BOTTOMRIGHT", AuctionHouseFrame.BrowseResultsFrame.qushiUI, "BOTTOMRIGHT",-4, 4);
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
	local function Save_Data_End()
		for k,v in pairs(HCUI.auctionsLin) do
			if HCUI.auctions[v[1]] then
   				if v[2]<HCUI.auctions[v[1]][1] then
   					HCUI.auctions[v[1]][1]=v[2]
   				end
			else
				HCUI.auctions[v[1]]={v[2],v[3],v[4]}
			end
		end
		for k,v in pairs(HCUI.auctions) do
			BusinessInfo.ADD_Newdata(k,v[1],v[2],v[3])
		end
		HCUI.jindu.tbiaoti:SetText("价格缓存完毕");
		HCUI.close:Show();
		OpenScanFun(nil)
	end
	local function huancunData_End()
		if not HCUI:IsShown() then return end
		if HCUI.yicunchu==nil or HCUI.yicunchu==true or HCUI.cunchuNum>5 then
			HCUI.jindu.tbiaoti:SetText("价格缓存完毕,存储中...");
			C_Timer.After(0.4,Save_Data_End)
		else
			HCUI.cunchuNum=HCUI.cunchuNum+1
			C_Timer.After(0.1,huancunData_End)
		end
	end
	local function SauctionsLinData(name,buyoutPrice,count,index,itemID)
		if name and name~="" and name~=" " and buyoutPrice>0 then
			local ItemLink=C_AuctionHouse.GetReplicateItemLink(index)
			local xianjiaV =buyoutPrice/count
			HCUI.auctionsLin[index]={name,xianjiaV,ItemLink,itemID}
		end
		au_SetValue()
	end
	local meiyenum = 300
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
										SauctionsLinData(name,buyoutPrice,count,index, itemID)
									else
										HCUI.yicunchu=false
										local itemf = Item:CreateFromItemID(itemID)
										itemf.index=index
										HCUI.ItemLoadList[itemf] = true
										itemf:ContinueOnItemLoad(function()
											local name, texture, count, qualityID, usable, level, levelType, minBid, minIncrement, buyoutPrice, bidAmount, highBidder, bidderFullName, owner, ownerFullName, saleStatus, itemID, hasAllInfo = C_AuctionHouse.GetReplicateItemInfo(itemf.index)
											SauctionsLinData(name,buyoutPrice,count,itemf.index, itemID)
											HCUI.ItemLoadList[itemf] = nil
											if next(HCUI.ItemLoadList) ~= nil then
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
		BusinessInfo.DEL_OLDdata()
		AuctionHouseFrame.SearchBar.FilterButton:Reset()
		HCUI:Show();
		HCUI.close:Hide();
		HCUI.jindu.tbiaoti:SetText("正在扫描物品...");
		HCUI.jindu:SetMinMaxValues(0, 100)
		HCUI.jindu:SetValue(100);
		HCUI.jindu.t2:SetText(0);
		HCUI.jindu.t3:SetText(0);
		PIGA["AHPlus"]["DaojiTime"]=GetServerTime()
		HCUI.ScanCD=BusinessInfo.AHPlusData.ScanCD*0.0001
		HCUI.jishuID = 0
		HCUI.cunchuNum=0
		HCUI.yicunchu=nil
		HCUI.SMend=nil
		OpenScanFun(true)
		HCUI.UpdateF.jishiqitime=1
		HCUI.UpdateF:Show()
		C_AuctionHouse.ReplicateItems()
	end)
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
	AuctionHouseFrame.WoWTokenResults.qushibut = PIGButton(AuctionHouseFrame.WoWTokenResults,{"CENTER",AuctionHouseFrame.WoWTokenResults,"CENTER",3,-100},{80,24},"历史价格",nil,nil,nil,nil,0)
	AuctionHouseFrame.WoWTokenResults.qushibut:HookScript("OnClick",function(self)
		if BusinessInfo.StatsInfoUI then
			BusinessInfo.StatsInfoUI:TabShow(AuctionHouseFrame)
		else
			PIG_OptionsUI:ErrorMsg("请打开"..addonName..SETTINGS.."→"..L["BUSINESS_TABNAME"].."→"..INFO..STATISTICS)
		end
	end)
end