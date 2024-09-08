local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local sub = _G.string.sub
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGButton=Create.PIGButton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGBrowseBiaoti=Create.PIGBrowseBiaoti
local PIGFontString=Create.PIGFontString
---
local Fun=addonTable.Fun
local BusinessInfo=addonTable.BusinessInfo
---------------------------------
local function Update_GGG(self,GGG)
	self:Hide();
	self.T:Hide();
	self.Y:Hide();
	self.G:Hide();
	self.TV:SetText();
	self.YV:SetText();
	self.GV:SetText();
	if GGG>0 then
		self:Show();
		local copper = floor(GGG % 100+0.5)
		self.TV:SetText(copper);
		self.T:Show();
		local silver = floor(GGG / 100) % 100
		local gold = floor(GGG / 10000)	
		if silver>0 or gold>0 then
			self.YV:SetText(silver);
			self.Y:Show();
		end
		if gold>0 then
			self.GV:SetText(gold);
			self.G:Show();
		end
	end
end
function BusinessInfo.AHPlus_Vanilla()
	if not PIGA["AHPlus"]["Open"] or AuctionFrameBrowse.piglist then return end
	PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm]=PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm] or {}

	local function AHPlus_AHUIoff(Frame)
		if not PIGA["AHPlus"]["AHUIoff"] then return end
		AuctionFrame:HookScript("OnShow", function(self)
			UIPanelWindows[Frame].width = 20
		end);
		AuctionFrame:HookScript("OnHide", function(self)
			UIPanelWindows[Frame].width = 713
		end);
	end
	if IsAddOnLoaded("Blizzard_TradeSkillUI") then
		AHPlus_AHUIoff("TradeSkillFrame")
	else
		local zhuanyeFrame = CreateFrame("FRAME")
		zhuanyeFrame:RegisterEvent("ADDON_LOADED")
		zhuanyeFrame:SetScript("OnEvent", function(self, event, arg1)
			if arg1 == "Blizzard_TradeSkillUI" then
				AHPlus_AHUIoff("TradeSkillFrame")
				zhuanyeFrame:UnregisterEvent("ADDON_LOADED")
			end
		end)
	end
	-- 
	if IsAddOnLoaded("Blizzard_CraftUI") then
		AHPlus_AHUIoff("CraftFrame")
	else
		local fumoFrame = CreateFrame("FRAME")
		fumoFrame:RegisterEvent("ADDON_LOADED")
		fumoFrame:SetScript("OnEvent", function(self, event, arg1)
			if arg1 == "Blizzard_CraftUI" then
				AHPlus_AHUIoff("CraftFrame")
				fumoFrame:UnregisterEvent("ADDON_LOADED")
			end
		end)
	end

	local color = CreateColor(1, 1, 1, 1)
	--ITEM_QUALITY_COLORS["-1"]={r = 1, g = 1, b = 1, hex = color:GenerateHexColorMarkup(), color = color}
	-- local OLD_QueryAuctionItems = QueryAuctionItems	
	-- QueryAuctionItems = function(...)
	-- 	local text, minLevel, maxLevel, page, usable, rarity, allxiazai, exactMatch, filterData =...
	-- 	if PIGA["AHPlus"]["exactMatch"] or AuctionFrame.maichuxunjia then
	-- 		local exactMatch = true
	-- 		return OLD_QueryAuctionItems(text, minLevel, maxLevel, page, usable, rarity, allxiazai, exactMatch, filterData)
	-- 	else
	-- 		return OLD_QueryAuctionItems(text, minLevel, maxLevel, page, usable, rarity, allxiazai, exactMatch, filterData)
	-- 	end
	-- end
	-- AuctionFrameBrowse.exact =PIGCheckbutton(AuctionFrameBrowse,nil,{AH_EXACT_MATCH,AH_EXACT_MATCH_TOOLTIP})
	-- if ElvUI and AuctionFrame.backdrop then
	-- 	AuctionFrameBrowse.exact:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",530,-4);
	-- else
	-- 	AuctionFrameBrowse.exact:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",530,-16);
	-- end
	-- AuctionFrameBrowse.exact:SetSize(15,15);
	-- AuctionFrameBrowse.exact.Text:SetTextColor(0, 1, 0, 0.8);
	-- AuctionFrameBrowse.exact:SetScript("OnClick", function (self)
	-- 	if self:GetChecked() then
	-- 		PIGA["AHPlus"]["exactMatch"]=true
	-- 	else
	-- 		PIGA["AHPlus"]["exactMatch"]=false
	-- 	end
	-- end);
	----
	local AH_TIME = TIME_LABEL:sub(1,-2)
	local AH_BIDDANJIA = AUCTION_TOOLTIP_BID_PREFIX:sub(1,-4)
	local AH_BUYDANJIA = AUCTION_TOOLTIP_BUYOUT_PREFIX:sub(1,-4)
	local xulieID = {RARITY,ACTION_SPELL_AURA_APPLIED_DOSE,"Lv",AH_TIME,BUYOUT,BID..AUCTION_BROWSE_UNIT_PRICE_SORT,AH_BUYDANJIA,"涨跌",AUCTION_CREATOR}
	local paixuID = {"quality","_3","level","duration","buyout","unitbid","unitprice","_8","seller"}
	local xulieID_www = {170,44,38,58,111,111,111,43,100}
	local hang_Height,hang_NUM ,anniuH = 20, 14,18;
	local shengyuTime = {[1]="|cffFF0000<30m|r",[2]="|cffFFFF0030m~2H|r",[3]="|cff00FF002H~12H|r",[4]="|cff00FF00>12H|r",}
	--调整原版UI
	local suoxiaozhi = 58
	local function SetBlizzardUI(tmV)
		hooksecurefunc("AuctionFrameFilters_UpdateCategories", function(forceSelectionIntoView)	
			BrowseFilterScrollFrame:ClearAllPoints();
			BrowseFilterScrollFrame:SetPoint("TOPRIGHT",AuctionFrameBrowse,"TOPLEFT",158-suoxiaozhi,-105);
			local hasScrollBar = #OPEN_FILTER_LIST > NUM_FILTERS_TO_DISPLAY;
			local offset = FauxScrollFrame_GetOffset(BrowseFilterScrollFrame);
			local dataIndex = offset;
			for i = 1, NUM_FILTERS_TO_DISPLAY do
				local button = AuctionFrameBrowse.FilterButtons[i];
				if i == 1 then 
					button:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",16,-105);
				end
				button:SetWidth(hasScrollBar and 140-suoxiaozhi or 160-suoxiaozhi);
				if button.Text:GetText()==TOKEN_FILTER_LABEL then
					button.Text:SetText(ITEM_QUALITY8_DESC)
				end
			end	
		end)
		BrowseNameText:ClearAllPoints();
		BrowseNameText:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",540,-40);
		BrowseLevelText:ClearAllPoints();
		BrowseLevelText:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",80,-40);
		if BrowseIsUsableText then--可用物品--60
			BrowseIsUsableText:ClearAllPoints();
			BrowseIsUsableText:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",300,-40);
		end
		if BrowseShowOnCharacterText then--预览效果--60
			BrowseShowOnCharacterText:ClearAllPoints();
			BrowseShowOnCharacterText:SetPoint("LEFT",BrowseIsUsableText,"RIGHT",40,0);
		end
		if ShowOnPlayerCheckButton then--预览效果WLK
			ShowOnPlayerCheckButton:ClearAllPoints();
			ShowOnPlayerCheckButton:SetPoint("LEFT",IsUsableCheckButton,"RIGHT",70,0);
		end
		if BrowsePriceOptionsButtonFrame then--设置单价展示
			BrowsePriceOptionsButtonFrame:Hide()
			hooksecurefunc("AuctionFrameFilter_OnClick", function()
				BrowsePriceOptionsButtonFrame:Hide()
			end)
		end
		BrowseSearchButton:ClearAllPoints();
		BrowseSearchButton:SetPoint("LEFT",BrowseName,"RIGHT",4,0);
		BrowsePrevPageButton:ClearAllPoints();
		BrowsePrevPageButton:SetPoint("BOTTOMLEFT",AuctionFrameBrowse,"BOTTOMLEFT",220,12);
		BrowsePrevPageButton:SetScale(0.88);
		BrowsePrevPageButton:Show();
		BrowseNextPageButton:ClearAllPoints();
		BrowseNextPageButton:SetPoint("LEFT",BrowsePrevPageButton,"RIGHT",120,0);
		BrowseNextPageButton:SetScale(0.88);
		BrowseNextPageButton:Show();
		if BrowseBidPrice then
			BrowseBidPrice:ClearAllPoints();
			BrowseBidPrice:SetPoint("LEFT",BrowseNextPageButton,"RIGHT",40,0);
		end
		if BrowseBuyoutPrice then
			BrowseBuyoutPrice:ClearAllPoints();
			BrowseBuyoutPrice:SetPoint("TOPRIGHT",BrowseBuyoutButton,"BOTTOMRIGHT",8,-4);
		end
		if BrowseResetButton then
			BrowseResetButton:ClearAllPoints();
			BrowseResetButton:SetPoint("LEFT",BrowseNameText,"RIGHT",4,0);
		end
		BrowseQualitySort:SetAlpha(tmV);
	 	BrowseLevelSort:SetAlpha(tmV);
		BrowseDurationSort:SetAlpha(tmV);
		BrowseHighBidderSort:SetAlpha(tmV);
		BrowseCurrentBidSort:SetAlpha(tmV);
		--拍卖页
		--堆叠数量
		AuctionsStackSizeEntry:ClearAllPoints();
		AuctionsStackSizeEntry:SetPoint("TOPLEFT",AuctionFrameAuctions,"TOPLEFT",33,-154);
		AuctionsStackSizeMaxButton:SetWidth(40);
		AuctionsStackSizeMaxButton:SetPoint("LEFT",AuctionsStackSizeEntry,"RIGHT",-10,0);
		--堆叠组数
		AuctionsNumStacksEntry:ClearAllPoints();
		AuctionsNumStacksEntry:SetPoint("LEFT",AuctionsStackSizeEntry,"RIGHT",40,0);
		AuctionsNumStacksMaxButton:SetWidth(40);
		AuctionsNumStacksMaxButton:SetPoint("LEFT",AuctionsNumStacksEntry,"RIGHT",-10,0);
		--每个/每组
		UIDropDownMenu_SetWidth(PriceDropDown, 100)
		PriceDropDown:ClearAllPoints();
		PriceDropDown:SetPoint("TOPLEFT",AuctionFrameAuctions,"TOPLEFT",70,-174);
		--价格
		StartPrice:ClearAllPoints();
		StartPrice:SetPoint("TOPLEFT",AuctionFrameAuctions,"TOPLEFT",33,-214);
		BuyoutPrice:ClearAllPoints();
		BuyoutPrice:SetPoint("TOPLEFT",StartPrice,"BOTTOMLEFT",0,-20);
		--错误提示
		AuctionsBuyoutErrorText:ClearAllPoints();
		AuctionsBuyoutErrorText:SetPoint("TOPLEFT",BuyoutPrice,"BOTTOMLEFT",-15,-4);
		--时限
		AuctionsDurationText:ClearAllPoints();
		AuctionsDurationText:SetPoint("TOPLEFT",AuctionFrameAuctions,"TOPLEFT",28,-310);
		AuctionsShortAuctionButton:ClearAllPoints();
		AuctionsShortAuctionButton:SetPoint("TOPLEFT",AuctionsDurationText,"BOTTOMLEFT",0,0);
		AuctionsShortAuctionButton:SetHitRectInsets(0,-36,0,0);
		AuctionsShortAuctionButtonText:SetText("12时");
		AuctionsMediumAuctionButton:ClearAllPoints();
		AuctionsMediumAuctionButton:SetPoint("LEFT",AuctionsShortAuctionButtonText,"RIGHT",10,0);
		AuctionsMediumAuctionButton:SetHitRectInsets(0,-36,0,0);
		AuctionsMediumAuctionButtonText:SetText("24时");
		AuctionsLongAuctionButton:ClearAllPoints();
		AuctionsLongAuctionButton:SetPoint("LEFT",AuctionsMediumAuctionButtonText,"RIGHT",10,0);
		AuctionsLongAuctionButton:SetHitRectInsets(0,-36,0,0);
		AuctionsLongAuctionButtonText:SetText("48时");
	end
	SetBlizzardUI(0)
	AuctionFrameBrowse.piglist = CreateFrame("Frame", nil, AuctionFrameBrowse,"BackdropTemplate")
	local listF=AuctionFrameBrowse.piglist
	--ADD浏览页
	local function PIG_AuctionFrame_OnClickSortColumn(sortTable, sortColumn)
		if BrowsePriceOptionsButtonFrame then--设置单价展示
			BrowsePriceOptionsButtonFrame:Hide()
		end
		for i=1,#xulieID do
			local Buttonxx =_G["piglist_biaoti_"..paixuID[i]]
			Buttonxx.Arrow:Hide()
		end
		if sortColumn then
			SortAuctionItems(sortTable, sortColumn);
		else
			sortColumn="unitprice"
			SortAuctionClearSort(sortTable) 
			for i = 1, hang_NUM do
				_G["piglist_item_"..i]:Hide()
		    end
			SortAuctionSetSort(sortTable,sortColumn, false)
			SetSelectedAuctionItem(sortTable, 0);
			listF.tishi:SetText(BROWSE_SEARCH_TEXT);
	    end
	    local sorted = IsAuctionSortReversed(sortTable, sortColumn)
	    local butArrow = _G["piglist_biaoti_"..sortColumn].Arrow
		butArrow:Show()
		if (sorted) then
			butArrow:SetTexCoord(0, 0.5625, 1, 0);
		else
			butArrow:SetTexCoord(0, 0.5625, 0, 1);
		end
	end
	listF:SetBackdrop( { bgFile = "interface/characterframe/ui-party-background.blp", });
	listF:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",180-suoxiaozhi,-104);
	listF:SetPoint("BOTTOMRIGHT",AuctionFrameBrowse,"BOTTOMRIGHT",70,38);
	listF:SetFrameLevel(10)
	listF:EnableMouse(true)
	if not ElvUI and not NDui then
		listF.fengeline = listF:CreateTexture(nil, "BORDER");
		listF.fengeline:SetTexture("interface/dialogframe/ui-dialogbox-divider.blp");
		listF.fengeline:SetRotation(math.rad(-90),{x=0,y=0})
		listF.fengeline:SetSize(408,24);
		listF.fengeline:SetPoint("TOPLEFT",listF,"TOPLEFT",-20,26);
	end
	listF.tishi = PIGFontString(listF,{"CENTER", listF, "CENTER", 0,100},BROWSE_SEARCH_TEXT,"OUTLINE")
	---
	for i=1,#xulieID do
		local Buttonxx = CreateFrame("Button","piglist_biaoti_"..paixuID[i],listF,"AuctionSortButtonTemplate");
		Buttonxx:SetSize(xulieID_www[i]+2,anniuH);
		if i>4 and i<8 then
			_G["piglist_biaoti_"..paixuID[i].."Text"]:SetPoint("LEFT",Buttonxx,"LEFT",30,0);
		end
		if ElvUI and AuctionFrame.backdrop or NDui then
			_G["piglist_biaoti_"..paixuID[i].."Left"]:Hide()
			_G["piglist_biaoti_"..paixuID[i].."Middle"]:Hide()
			_G["piglist_biaoti_"..paixuID[i].."Right"]:Hide()
		end
		Buttonxx.sortType=paixuID[i]
		if xulieID[i]==RARITY then
			Buttonxx:SetPoint("BOTTOMLEFT",listF,"TOPLEFT",0,4);
			Buttonxx.ShowHide = PIGButton(Buttonxx,{"RIGHT",Buttonxx,"LEFT",-2,0},{70,20},AUCTION_CREATOR,nil,nil,nil,nil,0)
			Buttonxx.ShowHide:SetFrameLevel(Buttonxx:GetFrameLevel()+5)
			Buttonxx.ShowHide:SetScript("OnClick", function(self)
				if _G["piglist_biaoti_"..paixuID[9]]:IsShown() then
					_G["piglist_biaoti_"..paixuID[9]]:Hide()
					AuctionFrameBrowse.chushouzheF:Hide()
					for ixc=1,hang_NUM do
						local listFGV = _G["piglist_item_"..ixc].chushouzhe:Hide()
					end
				else
					AuctionFrameBrowse.coll.list:Hide()
					_G["piglist_biaoti_"..paixuID[9]]:Show()
					AuctionFrameBrowse.chushouzheF:Show()
					for ixc=1,hang_NUM do
						local listFGV = _G["piglist_item_"..ixc].chushouzhe:Show()
					end
				end
			end)
		elseif xulieID[i]==AUCTION_CREATOR then
			Buttonxx:Hide()
			Buttonxx:SetPoint("LEFT",_G["piglist_biaoti_"..(paixuID[i-1])],"RIGHT",26,0);
		else
			Buttonxx:SetPoint("LEFT",_G["piglist_biaoti_"..(paixuID[i-1])],"RIGHT",-2,0);
		end
		Buttonxx:SetText(xulieID[i]);
		if i==2 or xulieID[i]=="涨跌" then
			Buttonxx:Disable()
			if xulieID[i]=="涨跌" then
				Buttonxx:SetMotionScriptsWhileDisabled(true)
				Buttonxx:SetScript("OnEnter", function (self)
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
					GameTooltip:AddLine("提示：")
					GameTooltip:AddLine("1、缓存价格以后才能显示涨跌百分比")
					GameTooltip:AddLine("2、100%表示此物品价格和上次缓存价格一样")
					GameTooltip:AddLine("3、80%表示此物品价格是缓存价格80%(即表示便宜了20%)")
					GameTooltip:AddLine("4、120%表示此物品价格是缓存价格120%(即表示贵了20%)")
					GameTooltip:Show();
				end);
				Buttonxx:SetScript("OnLeave", function (self)
					GameTooltip:ClearLines();
					GameTooltip:Hide()
				end);
			end
		else
			Buttonxx:SetScript("OnClick", function (self)
				if self.sortType~="" then
					PIG_AuctionFrame_OnClickSortColumn("list", self.sortType)
				end
			end)
		end
	end
	----
	local function gengxinlist(self)
		BrowseBidButton:Disable();
		BrowseBuyoutButton:Disable();
		local numBatchAuctions=listF.numBatchAuctions
		local totalAuctions=listF.totalAuctions
		if numBatchAuctions>0 then
			listF.tishi:SetText("");
			BrowseNextPageButton:Show();
			BrowsePrevPageButton:Show();
			BrowseSearchCountText:ClearAllPoints();
			BrowseSearchCountText:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",330,-64);
			BrowseSearchCountText:Show();
			local kaishiV = NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page+1
			local jieshuV = NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page+numBatchAuctions
			if jieshuV>totalAuctions then
				BrowseSearchCountText:SetText("当前"..kaishiV.."-"..totalAuctions.."(总"..totalAuctions..")");
			else
				BrowseSearchCountText:SetText("当前"..kaishiV.."-"..jieshuV.."(总"..totalAuctions..")");
			end
			FauxScrollFrame_Update(self, numBatchAuctions, hang_NUM, hang_Height);
			local offset = FauxScrollFrame_GetOffset(self);
		    for i = 1, hang_NUM do
		    	local listFGV = _G["piglist_item_"..i]
				local AHdangqianH = i+offset;
				local name, texture, count, quality, canUse, level, levelColHeader, minBid, minIncrement, buyoutPrice, bidAmount, 
	   			highBidder, bidderFullName, owner, ownerFullName, saleStatus, itemId, hasAllInfo =  GetAuctionItemInfo("list", AHdangqianH);
	   			if name then
	   				listFGV:SetID(AHdangqianH)
	   				listFGV:Show()
	   				local Index = GetSelectedAuctionItem("list");
    				if Index == AHdangqianH then
    					listFGV.xuanzhong:Show()
    					local ownerName;
						if (not ownerFullName) then
							ownerName = owner;
						else
							ownerName = ownerFullName
						end
						--一口价
    					if ( buyoutPrice > 0 and buyoutPrice >= minBid ) then
							local canBuyout = 1;
							if ( GetMoney() < buyoutPrice ) then
								if ( not highBidder or GetMoney()+bidAmount < buyoutPrice ) then
									canBuyout = nil;
								end
							end
							if ( canBuyout and (ownerName ~= Pig_OptionsUI.Name) ) then
								BrowseBuyoutButton:Enable();
								AuctionFrame.buyoutPrice = buyoutPrice;
							end
							if BrowseBuyoutPrice then
								MoneyFrame_Update(BrowseBuyoutPrice, buyoutPrice);
								BrowseBuyoutPrice:Show();
							end
						else
							AuctionFrame.buyoutPrice = nil;
							if BrowseBuyoutPrice then
								BrowseBuyoutPrice:Hide();
							end
						end
						---竞拍
						if ( bidAmount == 0 ) then
							displayedPrice = minBid;
							requiredBid = minBid;
						else
							displayedPrice = bidAmount;
							requiredBid = bidAmount + minIncrement ;
						end
						if ( requiredBid >= MAXIMUM_BID_PRICE ) then
							buyoutPrice = requiredBid;
						end
						MoneyInputFrame_SetCopper(BrowseBidPrice, requiredBid);
						if ( not highBidder and ownerName ~= Pig_OptionsUI.Name and GetMoney() >= MoneyInputFrame_GetCopper(BrowseBidPrice) and MoneyInputFrame_GetCopper(BrowseBidPrice) <= MAXIMUM_BID_PRICE ) then
							BrowseBidButton:Enable();
						end
				    else
				        listFGV.xuanzhong:Hide()
    				end
					listFGV.itemicon.tex:SetTexture(texture);
					local r, g, b, hex = GetItemQualityColor(quality)
					listFGV.itemlink.t:SetText(name);
					listFGV.itemlink.quality=quality
					listFGV.itemlink.t:SetTextColor(r, g, b, 1);
					if ( levelColHeader == "REQ_LEVEL_ABBR" and level > UnitLevel("player") ) then
						listFGV.lv:SetText(RED_FONT_COLOR_CODE..level..FONT_COLOR_CODE_CLOSE);
					else
						listFGV.lv:SetText(level);
					end
					listFGV.count:SetText(count);
					listFGV.chushouzhe:SetText(owner);
					local timeleft = GetAuctionItemTimeLeft("list", AHdangqianH)
					listFGV.TimeLeft:SetText(shengyuTime[timeleft]);
					Update_GGG(listFGV.yikou,buyoutPrice)
					Update_GGG(listFGV.biddanjia,minBid/count)
					Update_GGG(listFGV.yikoudanjia,buyoutPrice/count)
					listFGV.zhangdie:SetText("-");
					listFGV.zhangdie:SetTextColor(1, 1, 1, 1);
					if buyoutPrice>0 then
						local xianjiaV = buyoutPrice/count
						if PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm][name] then
							local jiagGGG = PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm][name][2]
							local newggg = jiagGGG[#jiagGGG][1]
							local baifenbi = (xianjiaV/newggg)*100+0.5
							local baifenbi = floor(baifenbi)
							listFGV.zhangdie:SetText(baifenbi.."%");
							if baifenbi<100 then
								listFGV.zhangdie:SetTextColor(0, 1, 0, 1);
							elseif baifenbi>100 then
								listFGV.zhangdie:SetTextColor(1, 0, 0, 1);
							end
							if xianjiaV<newggg and GetServerTime()-jiagGGG[#jiagGGG][2]>3600 then
								table.insert(PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm][name][2],{xianjiaV,GetServerTime()})
	   						end
						else
							local itemLink = GetAuctionItemLink("list", AHdangqianH)
							local itemLinkJJ = Fun.GetItemLinkJJ(itemLink)
							PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm][name]={itemLinkJJ,{{xianjiaV,GetServerTime()}}}
						end
	   				end
	   			else
	   				listFGV:Hide()
	   			end
			end
		else
			for i = 1, hang_NUM do
		    	_G["piglist_item_"..i]:Hide()
		    end
			listF.tishi:SetText(BROWSE_NO_RESULTS);
			SetSelectedAuctionItem("list", 0);
		end
	end
	listF.Scroll = CreateFrame("ScrollFrame",nil,listF, "FauxScrollFrameTemplate");  
	listF.Scroll:SetPoint("TOPLEFT",listF,"TOPLEFT",0,-2);
	listF.Scroll:SetPoint("BOTTOMRIGHT",listF,"BOTTOMRIGHT",-25,2);
	listF.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, gengxinlist)
	end)
	BrowseScrollFrame:HookScript("OnVerticalScroll", function(self, offset)
		BrowseNextPageButton:Show();
		BrowsePrevPageButton:Show();
		BrowseSearchCountText:Show();
	end)
	--创建行
	local function zhixinghuanjie(frame,fujiF,Tooltip)
		frame:HookScript("OnEnter", function()
			fujiF.xuanzhong:Show()
			if Tooltip then
				local Itemlink=GetAuctionItemLink("list", fujiF:GetID())
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(frame, "ANCHOR_RIGHT",0,0);
				GameTooltip:SetHyperlink(Itemlink)
				GameTooltip:Show();
			end
		end);
		frame:HookScript("OnLeave", function()
			local Index = GetSelectedAuctionItem("list");
		    if (Index ~= fujiF:GetID()) then
				fujiF.xuanzhong:Hide()
			end
			if Tooltip then
				GameTooltip:ClearLines();
				GameTooltip:Hide()
			end
		end);
		frame:SetScript("OnClick", function ()
			SetSelectedAuctionItem("list", fujiF:GetID())
			gengxinlist(listF.Scroll)
		end);
		if frame==fujiF.itemlink or frame==fujiF.itemicon then
			frame:SetScript("OnMouseUp", function (self,button)
				GameTooltip:ClearLines();
				GameTooltip:Hide()
				local Itemlink=GetAuctionItemLink("list", fujiF:GetID())
				local name=fujiF.itemlink.t:GetText()
				if button=="LeftButton" then
					if IsShiftKeyDown() then
						local editBox = ChatEdit_ChooseBoxForSend();
						if editBox:HasFocus() then			
							local hasText = editBox:GetText()..Itemlink
							editBox:SetText(hasText);
						else
							BrowseName:SetText(name)
						end
					elseif IsControlKeyDown() then
						DressUpItemLink(Itemlink)
					end
				else
					local hejiinfo = PIGA["AHPlus"]["Coll"]
					for kk=1,#hejiinfo do
						if hejiinfo[kk][1]==name then
							PIGinfotip:TryDisplayMessage("<"..name..">|cffFFFF00已存在")
							return
						end
					end
					table.insert(PIGA["AHPlus"]["Coll"],{name,fujiF.itemicon.tex:GetTexture(),fujiF.itemlink.quality})
					PIGinfotip:TryDisplayMessage("<"..name..">|cffFFFF00已加入关注")
					listF:Gengxinlistcoll()
				end
			end);
		end
	end
	local function chuangjianjinbiF(fujiF,Point,width,hang_Height,Color)
		local frame = CreateFrame("Frame", nil, fujiF);
		frame:SetSize(width, hang_Height);
		frame:SetPoint("LEFT", Point, "RIGHT", 0,0);
		frame.T = frame:CreateTexture(nil, "BORDER");
		frame.T:SetTexture("interface/moneyframe/ui-coppericon.blp");
		frame.T:SetPoint("RIGHT",frame,"RIGHT",-6,0);
		frame.T:SetSize(12,14);
		frame.TV = PIGFontString(frame,{"RIGHT", frame.T, "LEFT", 2,0},nil,"OUTLINE",13)
		frame.TV:SetJustifyH("RIGHT");
		frame.Y = frame:CreateTexture(nil, "BORDER");
		frame.Y:SetTexture("interface/moneyframe/ui-silvericon.blp");
		frame.Y:SetPoint("RIGHT",frame.T,"LEFT",-15,0);
		frame.Y:SetSize(12,14);
		frame.YV = PIGFontString(frame,{"RIGHT", frame.Y, "LEFT", 2,0},nil,"OUTLINE",13)
		frame.YV:SetJustifyH("RIGHT");
		frame.G = frame:CreateTexture(nil, "BORDER");
		frame.G:SetTexture("interface/moneyframe/ui-goldicon.blp");
		frame.G:SetPoint("RIGHT",frame.Y,"LEFT",-15,0);
		frame.G:SetSize(12,14);
		frame.GV = PIGFontString(frame,{"RIGHT", frame.G, "LEFT", 2,0},nil,"OUTLINE",13)
		frame.GV:SetJustifyH("RIGHT");
		if Color then
			frame.TV:SetTextColor(Color[1], Color[2], Color[3], Color[4]);
			frame.YV:SetTextColor(Color[1], Color[2], Color[3], Color[4]);
			frame.GV:SetTextColor(Color[1], Color[2], Color[3], Color[4]);
		end
		return frame
	end
	local hang_Width =listF.Scroll:GetWidth()
	for i = 1, hang_NUM do
		local listFitem = CreateFrame("Button", "piglist_item_"..i, listF);
		listFitem:SetSize(hang_Width, hang_Height);
		if i==1 then
			listFitem:SetPoint("TOP",listF.Scroll,"TOP",0,0);
		else
			listFitem:SetPoint("TOP",_G["piglist_item_"..(i-1)],"BOTTOM",0,-1.5);
		end
		listFitem:Hide()
		zhixinghuanjie(listFitem,listFitem)
		listFitem.xuanzhong = listFitem:CreateTexture(nil, "BORDER");
		listFitem.xuanzhong:SetTexture("interface/helpframe/helpframebutton-highlight.blp");
		listFitem.xuanzhong:SetTexCoord(0.00,0.00,0.00,0.58,1.00,0.00,1.00,0.58);
		listFitem.xuanzhong:SetAllPoints(listFitem)
		listFitem.xuanzhong:SetBlendMode("ADD")
		listFitem.xuanzhong:Hide()
		if i~=hang_NUM then
			listFitem.line = listFitem:CreateLine()
			listFitem.line:SetColorTexture(1,1,1,0.2)
			listFitem.line:SetThickness(1);
			listFitem.line:SetStartPoint("BOTTOMLEFT",0,0)
			listFitem.line:SetEndPoint("BOTTOMRIGHT",0,0)
		end
		listFitem.itemicon = CreateFrame("Button", nil, listFitem);
		listFitem.itemicon:SetSize(hang_Height,hang_Height);
		listFitem.itemicon:SetPoint("LEFT",listFitem,"LEFT",2,0);
		zhixinghuanjie(listFitem.itemicon,listFitem,true)
		listFitem.itemicon.tex = listFitem.itemicon:CreateTexture(nil, "BORDER");
		listFitem.itemicon.tex:SetAllPoints(listFitem.itemicon)

		listFitem.itemlink = CreateFrame("Button", nil, listFitem);
		listFitem.itemlink:SetSize(xulieID_www[1]-hang_Height,hang_Height);
		listFitem.itemlink:SetPoint("LEFT", listFitem.itemicon, "RIGHT", 0,0);
		zhixinghuanjie(listFitem.itemlink,listFitem)

		listFitem.itemlink.t = PIGFontString(listFitem.itemlink,nil,nil,"OUTLINE",13)
		listFitem.itemlink.t:SetAllPoints(listFitem.itemlink)
		listFitem.itemlink.t:SetJustifyH("LEFT");
		--
		listFitem.count = PIGFontString(listFitem,{"LEFT", listFitem.itemlink, "RIGHT", 0,0},nil,"OUTLINE",13)
		listFitem.count:SetWidth(xulieID_www[3]);
		listFitem.count:SetJustifyH("CENTER");
		listFitem.count:SetTextColor(0, 1, 1, 1);
		---
		listFitem.lv = PIGFontString(listFitem,{"LEFT", listFitem.count, "RIGHT", 0,0},nil,"OUTLINE",13)
		listFitem.lv:SetWidth(xulieID_www[2]);
		listFitem.lv:SetJustifyH("CENTER");
		listFitem.lv:SetTextColor(1, 1, 1, 1);
		--
		listFitem.TimeLeft = PIGFontString(listFitem,{"LEFT", listFitem.lv, "RIGHT", 0,0},nil,"OUTLINE",13)
		listFitem.TimeLeft:SetWidth(xulieID_www[4]);
		listFitem.TimeLeft:SetJustifyH("CENTER");
		--
		listFitem.yikou=chuangjianjinbiF(listFitem,listFitem.TimeLeft,xulieID_www[5],hang_Height,{1, 1, 0.2, 1})
		listFitem.biddanjia=chuangjianjinbiF(listFitem,listFitem.yikou,xulieID_www[6],hang_Height,{1, 1, 1, 1})
		listFitem.yikoudanjia=chuangjianjinbiF(listFitem,listFitem.biddanjia,xulieID_www[7],hang_Height,{0, 1, 1, 1})
		--
		listFitem.zhangdie = PIGFontString(listFitem,{"LEFT", listFitem.yikoudanjia, "RIGHT", -2,0},nil,"OUTLINE",13)
		listFitem.zhangdie:SetWidth(xulieID_www[8]);
		listFitem.zhangdie:SetJustifyH("RIGHT");
		----
		listFitem.chushouzhe = PIGFontString(listFitem,{"LEFT", listFitem.zhangdie, "RIGHT", 28,0},nil,"OUTLINE",13)
		listFitem.chushouzhe:SetWidth(xulieID_www[9]);
		listFitem.chushouzhe:SetJustifyH("LEFT");
		listFitem.chushouzhe:Hide();
	end
	AuctionFrameBrowse.chushouzheF=PIGFrame(AuctionFrameBrowse,{"TOPLEFT",AuctionFrameBrowse,"TOPRIGHT",74,-100})
	AuctionFrameBrowse.chushouzheF:SetPoint("BOTTOMLEFT",AuctionFrameBrowse,"BOTTOMRIGHT",74,36);
	AuctionFrameBrowse.chushouzheF:PIGSetBackdrop(nil,0.2)
	AuctionFrameBrowse.chushouzheF:SetWidth(100)
	AuctionFrameBrowse.chushouzheF:Hide()
	
	---缓存价格
	AuctionFrameBrowse.History = PIGButton(AuctionFrameBrowse,{"TOPRIGHT",AuctionFrameBrowse,"TOPRIGHT",10,-12.4},{90,19},"缓存价格",nil,nil,nil,nil,0);
	if ElvUI and AuctionFrame.backdrop then
		AuctionFrameBrowse.History:SetPoint("TOPRIGHT",AuctionFrameBrowse,"TOPRIGHT",10,-4);
	elseif NDui then
		AuctionFrameBrowse.History:SetPoint("TOPRIGHT",AuctionFrameBrowse,"TOPRIGHT",10,-10);
	end
	---
	AuctionFrameBrowse.huancunUI = CreateFrame("Frame", nil, AuctionFrameBrowse,"BackdropTemplate");
	local HCUI = AuctionFrameBrowse.huancunUI
	HCUI:SetBackdrop({bgFile = "interface/characterframe/ui-party-background.blp",edgeFile = "Interface/Tooltips/UI-Tooltip-Border",edgeSize = 13,});
	HCUI:SetBackdropBorderColor(0, 1, 1, 0.9);
	HCUI:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",14,-34);
	HCUI:SetPoint("BOTTOMRIGHT",AuctionFrameBrowse,"BOTTOMRIGHT",70,12);
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
	---
	AuctionFrameBrowse.History:HookScript("OnShow",function(self)
		local canQuery,canQueryAll = CanSendAuctionQuery()
		if canQueryAll then
			self:Enable()
		else
			self:Disable()
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
		if name and name~="" and name~=" " and buyoutPrice>0 then
			local xianzaidanjia =buyoutPrice/count
			if HCUI.auctions[name] then
				if HCUI.auctions[name][2] then
	   				if xianzaidanjia<HCUI.auctions[name][2][1] then
	   					HCUI.auctions[name][2][1]=xianzaidanjia
	   				end
	   			end
			else
				local itemLinkJJ = Fun.GetItemLinkJJ(itemLink)
				HCUI.auctions[name]={itemLinkJJ,{xianzaidanjia,GetServerTime()}}
			end
		end
		HCUI.jishuID=HCUI.jishuID+1
		HCUI.jindu:SetValue(HCUI.jishuID);
	end
	local function huancunData_H(index)
		local name, texture, count, quality, canUse, level, levelColHeader, minBid, minIncrement, buyoutPrice,bidAmount, highBidder, bidderFullName, owner, ownerFullName, saleStatus, itemId, hasAllInfo =  GetAuctionItemInfo("list", index);
		local ItemLink=GetAuctionItemLink("list", index)
		if not hasAllInfo then
			if itemId and itemId>0 then
				HCUI.yicunchu=false
				local itemf = Item:CreateFromItemID(itemId)
				itemf.index=index
				HCUI.ItemLoadList[itemf] = true
				itemf:ContinueOnItemLoad(function()
					HCUI.ItemLoadList[itemf] = nil
					local name, texture, count, quality, canUse, level, levelColHeader, minBid, minIncrement, buyoutPrice,bidAmount, highBidder, bidderFullName, owner, ownerFullName, saleStatus, itemId, hasAllInfo =  GetAuctionItemInfo("list", itemf.index);
					local ItemLink=GetAuctionItemLink("list", index)
					HCUI.jindu.t2:SetText(itemf.index);
					HCUI.jindu.tname:SetText(name);
					GetBuyoutPriceG(name,count,buyoutPrice,ItemLink)
					if not next(HCUI.ItemLoadList) then
						HCUI.yicunchu=true
					end
				end)
			else
				HCUI.jishuID=HCUI.jishuID+1
				HCUI.jindu:SetValue(HCUI.jishuID);
			end
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
		for i = 1, HCUI.ItemListNum do
			C_Timer.After(i*HCUI.ScanCD,function()
				huancunData_H(i)
				if i==HCUI.ItemListNum then
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
				local _, AuctionsNum = GetNumAuctionItems("list");
				if AuctionsNum>100000 then
					HCUI.ScanCD=BusinessInfo.AHPlusData.ScanCD+0.001
				else
					HCUI.ScanCD=BusinessInfo.AHPlusData.ScanCD
				end
				HCUI.ItemListNum = AuctionsNum
				HCUI.jindu.t3:SetText(AuctionsNum);
				HCUI.jindu:SetMinMaxValues(0, AuctionsNum)
				GetItemsData()
			else
				local _, AuctionsNum = GetNumAuctionItems("list");
				HCUI.jindu.t2:SetText(AuctionsNum);
				HCUI.jindu.t3:SetText(AuctionsNum);
				local canQuery,canQueryAll = CanSendAuctionQuery()	
				if canQuery then
					HCUI.SMend=true
				end
			end
		else
			self.jishiqitime = self.jishiqitime + sss;
		end
	end)
	AuctionFrameBrowse.History:HookScript("OnClick", function(self, button)
		self:Disable()
		HCUI:DEL_OLDdata()
		AuctionFrameBrowse_Reset(BrowseResetButton)
		HCUI:Show();
		HCUI.close:Hide();
		HCUI.jindu.tbiaoti:SetText("正在扫描物品...");
		HCUI.jindu:SetMinMaxValues(0, 100)
		HCUI.jindu:SetValue(100);
		HCUI.jindu.t2:SetText(0);
		HCUI.jindu.t3:SetText(0);
		HCUI.jindu.tname:SetText("");
		HCUI.jishuID = 0
		HCUI.yicunchu=nil
		HCUI.SMend=nil
		HCUI.UpdateF.jishiqitime=1
		HCUI.UpdateF:Show()
		QueryAuctionItems("", nil, nil, 0, nil, nil, true, false, nil)--查询全部
	end)
	local baocunnum = 40
	function HCUI:DEL_OLDdata()
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
	function HCUI.showhide()
		HCUI.UpdateF:Hide()
		HCUI:Hide();
		HCUI.close:Hide();
	end
	AuctionFrameBrowse:HookScript("OnShow",HCUI.showhide)
	AuctionFrameBrowse:HookScript("OnHide",HCUI.showhide)
	---时光徽章
	for i = 1, 33 do
		local huizhangG = PIGFontString(BrowseWowTokenResults,nil,nil,"OUTLINE",13,"huizhangG_"..i)
		if i==1 then
			huizhangG:SetPoint("TOPLEFT",BrowseWowTokenResults,"TOPLEFT",2,0);
		elseif i==19 then
			huizhangG:SetPoint("TOPRIGHT",BrowseWowTokenResults,"TOPRIGHT",-4,-50);
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
	BrowseWowTokenResults:HookScript("OnShow",function(self)
		AuctionFrameBrowse.piglist:Hide()
		_G["piglist_biaoti_"..(paixuID[1])].ShowHide:Hide()
		--self:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",188-suoxiaozhi,-103);
		Update_huizhangG()
	end)
	BrowseWowTokenResults:HookScript("OnHide",function(self)
		AuctionFrameBrowse.piglist:Show()
		_G["piglist_biaoti_"..(paixuID[1])].ShowHide:Show()
	end)
	AuctionFrameBrowse:HookScript("OnEvent",function(self,event,arg1,arg2)
		if event=="AUCTION_ITEM_LIST_UPDATE" then
			local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
			listF.numBatchAuctions=numBatchAuctions
			listF.totalAuctions=totalAuctions
			gengxinlist(listF.Scroll)
		end
	end)
	------
	local CVarName={
		["UnitNameNPC"]="0",
		["nameplateShowOnlyNames"]="1",
		["nameplateShowFriends"]="0",
		["UnitNameFriendlyPlayerName"]="0",
		["UnitNameFriendlyPetName"]="0",
		["UnitNameFriendlyGuardianName"]="0",
		["UnitNameFriendlyTotemName"]="0",
		["UnitNameFriendlyMinionName"]="0",
	}
	local OLD_CVarName={}
	local function Save_SettCVar()
		for k,v in pairs(CVarName) do
			local OLDcannn = GetCVar(k)
			if OLDcannn then
				OLD_CVarName[k]=OLDcannn
			end
		end
		for k,v in pairs(CVarName) do
			SetCVar(k, v)
		end
	end
	local function Huifu_SettCVar()
		for k,v in pairs(OLD_CVarName) do
			SetCVar(k, v)
		end
	end
	AuctionFrame:HookScript("OnShow",function(self)
		Save_SettCVar()
		--AuctionFrameBrowse.exact:SetChecked(PIGA["AHPlus"]["exactMatch"])
		PIG_AuctionFrame_OnClickSortColumn("list")
	end)
	AuctionFrame:HookScript("OnHide", function(self)
		Huifu_SettCVar()
	end);

	--关注------------------------
	local collW,collY = 24,24
	AuctionFrameBrowse.coll = CreateFrame("Button",nil,AuctionFrameBrowse);
	local coll=AuctionFrameBrowse.coll
	coll:SetSize(collW,collY);
	coll:SetPoint("LEFT",BrowseSearchButton,"RIGHT",20,8);
	coll.TexC = coll:CreateTexture(nil, "BORDER");
	coll.TexC:SetTexture("interface/common/friendship-heart.blp");
	coll.TexC:SetSize(collW*1.64,collY*1.5);
	coll.TexC:SetPoint("CENTER",coll,"CENTER",0,-2);
	coll:SetScript("OnMouseDown", function (self)
		self.TexC:SetPoint("CENTER",coll,"CENTER",1.5,-3.5);
	end);
	coll:SetScript("OnMouseUp", function (self)
		self.TexC:SetPoint("CENTER",coll,"CENTER",0,-2);
	end);
	coll:SetScript("OnClick", function (self)
		if self.list:IsShown() then
			self.list:Hide()
		else
			self.list:Show()
		end
	end);
	coll.list=PIGFrame(coll,{"TOPLEFT",AuctionFrameBrowse,"TOPRIGHT",72,-12},{200,426})
	if ElvUI and AuctionFrame.backdrop then
		coll.list:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPRIGHT",75,0);
	elseif NDui then
		coll.list:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPRIGHT",76,-10);
	end
	coll.list:PIGSetBackdrop(nil,nil,nil,nil,0)
	coll.list:PIGClose()
	coll.list:Hide()
	coll.list:EnableMouse(true)
	coll.list:SetToplevel(true)
	coll.list.title = PIGFontString(coll.list,{"TOP", coll.list, "TOP", -2, -6},"关注列表","OUTLINE")
	coll.list.tishi = CreateFrame("Frame", nil, coll.list);
	coll.list.tishi:SetSize(20,20);
	coll.list.tishi:SetPoint("TOPLEFT",coll.list,"TOPLEFT",5,-5);
	coll.list.tishi.Texture = coll.list.tishi:CreateTexture(nil, "BORDER");
	coll.list.tishi.Texture:SetTexture("interface/common/help-i.blp");
	coll.list.tishi.Texture:SetSize(30,30);
	coll.list.tishi.Texture:SetPoint("CENTER");
	PIGEnter(coll.list.tishi,L["LIB_TIPS"]..": ","\124cff00ff001、在浏览列表"..KEY_BUTTON2.."物品名可加入关注。\n2、关注列表物品"..KEY_BUTTON1.."搜索，"..KEY_BUTTON2.."删除。\124r");
	--
	local collhang_NUM = 18
	local function gengxinlistcoll(self)
		for i = 1, collhang_NUM do
			_G["colllistitem_"..i]:Hide()
	    end
	    local datainfo=PIGA["AHPlus"]["Coll"]
		local zongshuNum=#datainfo
		if zongshuNum>0 then
			FauxScrollFrame_Update(self, zongshuNum, collhang_NUM, hang_Height);
			local offset = FauxScrollFrame_GetOffset(self);
		    for i = 1, collhang_NUM do
				local AHdangqianH = i+offset;
				if datainfo[AHdangqianH] then
					local listFGV = _G["colllistitem_"..i]
					listFGV:Show()
					listFGV.icon:SetTexture(datainfo[AHdangqianH][2])
					listFGV.link:SetText(datainfo[AHdangqianH][1])
					local r, g, b = GetItemQualityColor(datainfo[AHdangqianH][3])
					listFGV.link:SetTextColor(r, g, b, 1);
					listFGV:SetID(AHdangqianH);
				end
			end
		end
	end
	coll.list.Scroll = CreateFrame("ScrollFrame",nil,coll.list, "FauxScrollFrameTemplate");  
	coll.list.Scroll:SetPoint("TOPLEFT",coll.list,"TOPLEFT",0,-32);
	coll.list.Scroll:SetPoint("BOTTOMRIGHT",coll.list,"BOTTOMRIGHT",-26,4);
	coll.list.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, gengxinlistcoll)
	end)
	--创建行
	local collhang_Width =coll.list.Scroll:GetWidth()
	for i = 1, collhang_NUM do
		local colllistitem = CreateFrame("Button", "colllistitem_"..i, coll.list);
		colllistitem:SetSize(collhang_Width, hang_Height);
		if i==1 then
			colllistitem:SetPoint("TOP",coll.list.Scroll,"TOP",5,0);
		else
			colllistitem:SetPoint("TOP",_G["colllistitem_"..(i-1)],"BOTTOM",0,-1.5);
		end
		colllistitem:RegisterForClicks("LeftButtonUp","RightButtonUp")
		colllistitem:Hide()
		colllistitem.xuanzhong = colllistitem:CreateTexture(nil, "BORDER");
		colllistitem.xuanzhong:SetTexture("interface/helpframe/helpframebutton-highlight.blp");
		colllistitem.xuanzhong:SetTexCoord(0.00,0.00,0.00,0.58,1.00,0.00,1.00,0.58);
		colllistitem.xuanzhong:SetAllPoints(colllistitem)
		colllistitem.xuanzhong:SetBlendMode("ADD")
		colllistitem.xuanzhong:Hide()
		if i~=collhang_NUM then
			colllistitem.line = colllistitem:CreateLine()
			colllistitem.line:SetColorTexture(1,1,1,0.2)
			colllistitem.line:SetThickness(1);
			colllistitem.line:SetStartPoint("BOTTOMLEFT",0,0)
			colllistitem.line:SetEndPoint("BOTTOMRIGHT",0,0)
		end
		colllistitem.icon = colllistitem:CreateTexture(nil, "BORDER");
		colllistitem.icon:SetSize(hang_Height,hang_Height);
		colllistitem.icon:SetPoint("LEFT", colllistitem, "LEFT", 0,0);
		colllistitem.link = PIGFontString(colllistitem,{"LEFT", colllistitem.icon, "RIGHT", 0,0},nil,"OUTLINE",13)
		colllistitem.link:SetWidth(colllistitem:GetWidth()-hang_Height);
		colllistitem.link:SetJustifyH("LEFT");
		colllistitem:SetScript("OnEnter", function(self)
			self.xuanzhong:Show()
		end);
		colllistitem:SetScript("OnLeave", function(self)
			self.xuanzhong:Hide()
		end);
		colllistitem:SetScript("OnClick", function (self,button)
			local caozuoID = self:GetID()
			if button=="LeftButton" then
				AuctionFrameBrowse_Reset(BrowseResetButton)
				local datakey=PIGA["AHPlus"]["Coll"][caozuoID][1]
				BrowseName:SetText('"'..datakey..'"')
				AuctionFrameBrowse_Search()
			else
				table.remove(PIGA["AHPlus"]["Coll"],caozuoID)
				gengxinlistcoll(coll.list.Scroll)
			end
		end);
	end
	coll.list:SetScript("OnShow", function (self)
		_G["piglist_biaoti_"..paixuID[9]]:Hide()
		AuctionFrameBrowse.chushouzheF:Hide()
		for i=1,hang_NUM do
			local listFGV = _G["piglist_item_"..i].chushouzhe:Hide()
		end
		gengxinlistcoll(self.Scroll)
	end);
	function listF:Gengxinlistcoll()
		gengxinlistcoll(coll.list.Scroll)	
	end
	AuctionFrameBrowse:HookScript("OnShow",function(self)
		self.coll.list:Show()
	end)

	---拍卖页==============================
	AuctionFrameAuctions.RepeatQuery =PIGCheckbutton(AuctionFrameAuctions,nil,{"相同物品不重复查询","卖出物品与上次物品相同时不重复查询物品售价，这样可以防止触发系统的查询CD，加快你的上架速度。\n如果需要每次上架都查询最新价格请关闭此选项(可能导致拍卖延迟)"})
	if ElvUI and AuctionFrame.backdrop then
		AuctionFrameAuctions.RepeatQuery:SetPoint("BOTTOMLEFT",AuctionFrameAuctions,"BOTTOMLEFT",230,10);
	else
		AuctionFrameAuctions.RepeatQuery:SetPoint("BOTTOMLEFT",AuctionFrameAuctions,"BOTTOMLEFT",230,18);
	end
	AuctionFrameAuctions.RepeatQuery:SetSize(15,15);
	AuctionFrameAuctions.RepeatQuery.Text:SetTextColor(0, 1, 0, 0.8);
	AuctionFrameAuctions.RepeatQuery:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["RepeatQuery"]=true
		else
			PIGA["AHPlus"]["RepeatQuery"]=false
		end
	end);
	AuctionFrameAuctions.RepeatQuery:SetChecked(PIGA["AHPlus"]["RepeatQuery"])
	AuctionFrameAuctions.SellList=PIGFrame(AuctionFrameAuctions,{"TOPLEFT",AuctionFrameAuctions,"TOPLEFT",216,-222})
	AuctionFrameAuctions.SellList:SetPoint("BOTTOMRIGHT",AuctionFrameAuctions,"BOTTOMRIGHT",66,38);
	AuctionFrameAuctions.SellList:PIGSetBackdrop(nil,nil,nil,nil,0)
	AuctionFrameAuctions.SellList:PIGClose()

	local SellListF=AuctionFrameAuctions.SellList
	SellListF:SetFrameLevel(10)
	SellListF:EnableMouse(true)
	SellListF:Hide()
	SellListF.tishi = PIGFontString(SellListF,{"CENTER", SellListF, "CENTER", 0,0},"没有此物品在售卖，无参考价！","OUTLINE")
	--
	local SellxulieID = {"",ACTION_SPELL_AURA_APPLIED_DOSE,BUYOUT,BID..AUCTION_BROWSE_UNIT_PRICE_SORT,AH_BUYDANJIA,AH_TIME,AUCTION_CREATOR}
	local SellxulieID_www = {30,42,106,106,106,60,134}
	for i=1,#SellxulieID do
		local Buttonxx = CreateFrame("Button","SellList_biaoti_"..i,SellListF);
		Buttonxx:SetSize(SellxulieID_www[i],anniuH);
		if i==1 then
			Buttonxx:SetPoint("TOPLEFT",SellListF,"TOPLEFT",3,-3);
		else
			Buttonxx:SetPoint("LEFT",_G["SellList_biaoti_"..(i-1)],"RIGHT",0,0);
		end
		if ElvUI and AuctionFrame.backdrop or NDui then
		else
			Buttonxx.TexC = Buttonxx:CreateTexture(nil, "BORDER");
			Buttonxx.TexC:SetTexture("interface/friendsframe/whoframe-columntabs.blp");
			Buttonxx.TexC:SetTexCoord(0.08,0.00,0.08,0.59,0.91,0.00,0.91,0.59);
			Buttonxx.TexC:SetPoint("TOPLEFT",Buttonxx,"TOPLEFT",2,0);
			Buttonxx.TexC:SetPoint("BOTTOMRIGHT",Buttonxx,"BOTTOMRIGHT",-0.8,0);
			Buttonxx.TexL = Buttonxx:CreateTexture(nil, "BORDER");
			Buttonxx.TexL:SetTexture("interface/friendsframe/whoframe-columntabs.blp");
			Buttonxx.TexL:SetTexCoord(0.00,0.00,0.00,0.59,0.08,0.00,0.08,0.59);
			Buttonxx.TexL:SetPoint("TOPRIGHT",Buttonxx.TexC,"TOPLEFT",0,0);
			Buttonxx.TexL:SetPoint("BOTTOMRIGHT",Buttonxx.TexC,"BOTTOMLEFT",0,0);
			Buttonxx.TexL:SetWidth(2)
			Buttonxx.TexR = Buttonxx:CreateTexture(nil, "BORDER");
			Buttonxx.TexR:SetTexture("interface/friendsframe/whoframe-columntabs.blp");
			Buttonxx.TexR:SetTexCoord(0.91,0.00,0.91,0.59,0.97,0.00,0.97,0.59);
			Buttonxx.TexR:SetPoint("TOPLEFT",Buttonxx.TexC,"TOPRIGHT",0,0);
			Buttonxx.TexR:SetPoint("BOTTOMLEFT",Buttonxx.TexC,"BOTTOMRIGHT",0,0);
			Buttonxx.TexR:SetWidth(2)
		end
		Buttonxx.title = PIGFontString(Buttonxx)
		Buttonxx.title:SetText(SellxulieID[i]);
		Buttonxx.title:SetTextColor(1, 1, 1, 1)
		if i>2 and i<6 then
			Buttonxx.title:SetPoint("RIGHT", Buttonxx, "RIGHT", -8, 0);
		else
			Buttonxx.title:SetPoint("LEFT", Buttonxx, "LEFT", 6, 0);
		end
	end
	local function yajiaFUN(count,minBid,buyoutPrice)
		local BiddanjiaGG = math.floor(minBid/count)
		local buyoutdanjiaGG = math.floor(buyoutPrice/count)
		local priceType =UIDropDownMenu_GetSelectedValue(PriceDropDown) or 2
		local stackSize = AuctionsStackSizeEntry:GetNumber()
		if ( stackSize >= 0 ) then
			if priceType == 1 then
				if owner~=Pig_OptionsUI.Name then
					if PIGA["AHPlus"]["yajingbiao"] then
						MoneyInputFrame_SetCopper(StartPrice, BiddanjiaGG-1);
					else
						MoneyInputFrame_SetCopper(StartPrice, buyoutdanjiaGG-1);
					end
					MoneyInputFrame_SetCopper(BuyoutPrice, buyoutdanjiaGG-1);
				else
					MoneyInputFrame_SetCopper(StartPrice, BiddanjiaGG);
					MoneyInputFrame_SetCopper(BuyoutPrice, buyoutdanjiaGG);
				end
			else
				local ZBiddanjiaGG = stackSize*BiddanjiaGG
				local ZbuyoutdanjiaGG = stackSize*buyoutdanjiaGG
				if owner~=Pig_OptionsUI.Name then
					if PIGA["AHPlus"]["yajingbiao"] then
						MoneyInputFrame_SetCopper(StartPrice, ZBiddanjiaGG-1);
					else
						MoneyInputFrame_SetCopper(StartPrice, ZbuyoutdanjiaGG-1);
					end
					MoneyInputFrame_SetCopper(BuyoutPrice, ZbuyoutdanjiaGG-1);
				else
					MoneyInputFrame_SetCopper(StartPrice, ZBiddanjiaGG);
					MoneyInputFrame_SetCopper(BuyoutPrice, ZbuyoutdanjiaGG);
				end
			end
			UpdateDeposit()
		end
	end
	AuctionsStackSizeEntry:HookScript("OnTextChanged",  function (self)
		local self1=_G["SellList_item_1"].yajia
		local count=self1.hang_count
		local minBid=self1.hang_minBid
		local buyoutPrice=self1.hang_buyoutPrice
		if count and minBid and buyoutPrice then
			yajiaFUN(count,minBid,buyoutPrice)
		end
	end);
	local spellhangnum, hang_Height1= 6,hang_Height+4
	local function gengxinSpelllist()
		for i = 1, spellhangnum do
		   	local listFGV = _G["SellList_item_"..i]
		   	listFGV:Hide()
		   	listFGV.yajia.hang_count=count
			listFGV.yajia.hang_minBid=minBid
			listFGV.yajia.hang_buyoutPrice=buyoutPrice
		end
		local chushouwupinname = GetAuctionSellItemInfo();
		if not chushouwupinname then
			SellListF.tishi:SetText("没有放入拍卖物品！");
			return
		end
		SellListF.tishi:SetText("没有此物品在售，无参考价！");
		local numBatchAuctions = GetNumAuctionItems("list");
		if numBatchAuctions>0 then
			SellListF.tishi:SetText("");
			for i = 1, spellhangnum do
				local listFGV = _G["SellList_item_"..i]
				local name, texture, count, quality, canUse, level, levelColHeader, minBid, minIncrement, buyoutPrice, bidAmount, 
	   			highBidder, bidderFullName, owner =  GetAuctionItemInfo("list", i);
				if name then
					if i==1 then
						if PIGA["AHPlus"]["autoya"] then yajiaFUN(count,minBid,buyoutPrice) end
			   			if chushouwupinname~=name then
							SellListF.tishi:SetText(LFG_LIST_SEARCH_FAILED);
							break
			   			end
			   		end
			   		listFGV.yajia.hang_count=count
					listFGV.yajia.hang_minBid=minBid
					listFGV.yajia.hang_buyoutPrice=buyoutPrice
			   		Update_GGG(listFGV.biddanjia,minBid/count)
					Update_GGG(listFGV.yikou,buyoutPrice)
					Update_GGG(listFGV.yikoudanjia,buyoutPrice/count)
					listFGV.count:SetText(count);
					listFGV.chushouzhe:SetText(owner);
					local timeleft = GetAuctionItemTimeLeft("list", i)
					listFGV.TimeLeft:SetText(shengyuTime[timeleft]);
					listFGV:Show()
		   		end
			end
		end
		SellListF:Show()
	end
	local hang_Width1 =SellListF:GetWidth()-10
	for i = 1, spellhangnum do
		local listFitem = CreateFrame("Button", "SellList_item_"..i, SellListF);
		listFitem:SetSize(hang_Width1, hang_Height1);
		if i==1 then
			listFitem:SetPoint("TOP",SellListF,"TOP",0,-28);
		else
			listFitem:SetPoint("TOP",_G["SellList_item_"..(i-1)],"BOTTOM",0,-2);
		end
		listFitem:Hide()
	
		listFitem.line = listFitem:CreateLine()
		listFitem.line:SetColorTexture(1,1,1,0.2)
		listFitem.line:SetThickness(1);
		listFitem.line:SetStartPoint("TOPLEFT",0,0)
		listFitem.line:SetEndPoint("TOPRIGHT",0,0)

		listFitem.yajia = CreateFrame("Button",nil,listFitem, "UIPanelButtonTemplate");
		listFitem.yajia:SetSize(SellxulieID_www[1],22);
		listFitem.yajia:SetPoint("LEFT", listFitem, "LEFT", 0,0);
		listFitem.yajia:SetText("压");
		listFitem.yajia:SetScript("OnClick", function(self, button)
			local count=self.hang_count
			local minBid=self.hang_minBid
			local buyoutPrice=self.hang_buyoutPrice
			yajiaFUN(count,minBid,buyoutPrice)
		end)
		---
		listFitem.count = PIGFontString(listFitem,{"LEFT", listFitem.yajia, "RIGHT", 0,0},nil,"OUTLINE",13)
		listFitem.count:SetWidth(SellxulieID_www[2]);
		listFitem.count:SetTextColor(0, 1, 1, 1);
		--
		listFitem.yikou=chuangjianjinbiF(listFitem,listFitem.count,SellxulieID_www[3],hang_Height1)
		listFitem.biddanjia=chuangjianjinbiF(listFitem,listFitem.yikou,SellxulieID_www[4],hang_Height1,{1, 1, 1, 1})
		listFitem.yikoudanjia=chuangjianjinbiF(listFitem,listFitem.biddanjia,SellxulieID_www[5],hang_Height1,{0, 1, 1, 1})
		---
		listFitem.TimeLeft = PIGFontString(listFitem,{"LEFT", listFitem.yikoudanjia, "RIGHT", 0,0},nil,"OUTLINE",13)
		listFitem.TimeLeft:SetWidth(SellxulieID_www[6]);
		--
		listFitem.chushouzhe = PIGFontString(listFitem,{"LEFT", listFitem.TimeLeft, "RIGHT", 2,0},nil,"OUTLINE",13)
		listFitem.chushouzhe:SetWidth(SellxulieID_www[7]);
		listFitem.chushouzhe:SetJustifyH("LEFT");
	end
	AuctionFrameAuctions:HookScript("OnHide",function()
		SellListF:Hide()
	end)
	AuctionFrame:HookScript("OnHide",function()
		AuctionsItemButton.OLDname=nil
	end)
		
	--压价按钮
	AuctionFrameAuctions.autoya =PIGCheckbutton(AuctionFrameAuctions,{"TOPLEFT",AuctionFrameAuctions,"TOPLEFT",24,-286},{"自动压","选中后拍卖物品时将根据现售最低价自动压价"})
	AuctionFrameAuctions.autoya.Text:SetTextColor(0, 1, 0, 0.8);
	AuctionFrameAuctions.autoya:SetChecked(PIGA["AHPlus"]["autoya"])
	AuctionFrameAuctions.autoya:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["autoya"]=true
		else
			PIGA["AHPlus"]["autoya"]=false
		end
	end);
	
	AuctionFrameAuctions.yajingbiao =PIGCheckbutton(AuctionFrameAuctions,{"LEFT",AuctionFrameAuctions.autoya.Text,"RIGHT",4,0},{"压竞标","选中后压一口价同时压竞标价"})
	AuctionFrameAuctions.yajingbiao.Text:SetTextColor(0, 1, 0, 0.8);
	AuctionFrameAuctions.yajingbiao:SetChecked(PIGA["AHPlus"]["yajingbiao"])
	AuctionFrameAuctions.yajingbiao:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["yajingbiao"]=true
		else
			PIGA["AHPlus"]["yajingbiao"]=false
		end
	end);
	
	AuctionFrameAuctions.Showcankao = PIGButton(AuctionFrameAuctions,{"LEFT",AuctionFrameAuctions.yajingbiao.Text,"RIGHT",4,0},{46,20},"在售",nil,nil,nil,nil,0)
	AuctionFrameAuctions.Showcankao:SetScript("OnClick", function (self)
		if SellListF:IsShown() then
			SellListF:Hide()
		else
			SellListF:Show()
			C_Timer.After(0.2,gengxinSpelllist)
		end
	end);
	AuctionsCreateAuctionButton:HookScript("OnUpdate", function(self)
		local canQuery,canQueryAll = CanSendAuctionQuery()
		if canQuery then
			self:Enable()
		else
			self:Disable()
		end
	end)
	AuctionsItemButton:HookScript("OnEvent",function(self,event,arg1,arg2)
		if event=="NEW_AUCTION_UPDATE" then
			AuctionsItemButtonCount:Hide();
			local name, texture, count, quality, canUse, price, pricePerUnit, stackCount, totalCount, itemID = GetAuctionSellItemInfo();
			if name then
				SortAuctionSetSort("list","unitprice", false)
				AuctionFrameBrowse_Reset(BrowseResetButton)
				BrowseName:SetText('"'..name..'"')
				if AuctionsItemButton.OLDname==name and PIGA["AHPlus"]["RepeatQuery"] then
				else
					AuctionFrameBrowse_Search()--用系统搜索函数
				end
				AuctionsItemButton.OLDname=name
				if (C_WowTokenPublic.IsAuctionableWowToken(itemID)) then
				else
					if ( totalCount > 1 ) then
						AuctionsStackSizeEntry:Show();
						AuctionsStackSizeMaxButton:Show();
						AuctionsNumStacksEntry:Show();
						AuctionsNumStacksMaxButton:Show();
						PriceDropDown:Show();
						UpdateMaximumButtons();
					else	
						AuctionsStackSizeEntry:Hide();
						AuctionsStackSizeMaxButton:Hide();
						AuctionsNumStacksEntry:Hide();
						AuctionsNumStacksMaxButton:Hide();
					end
				end
				C_Timer.After(0.6,gengxinSpelllist)
			else
				AuctionsStackSizeEntry:Hide();
				AuctionsStackSizeMaxButton:Hide();
				AuctionsNumStacksEntry:Hide();
				AuctionsNumStacksMaxButton:Hide();
				SellListF:Hide()
			end
		end
	end)
	-----
end