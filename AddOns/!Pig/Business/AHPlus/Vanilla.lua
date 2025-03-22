local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local gsub = _G.string.gsub
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGButton=Create.PIGButton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGBrowseBiaoti=Create.PIGBrowseBiaoti
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont
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
local function Add_GGGF(fujiF,Point,width,hang_Height,Color)
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

function BusinessInfo.AHPlus_Vanilla(baocunnum)
	if not PIGA["AHPlus"]["Open"] or AuctionFrameBrowse.piglist then return end
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
	----------
	if not ITEM_QUALITY_COLORS["-1"] then
		local color = CreateColor(1, 1, 1, 1)
		ITEM_QUALITY_COLORS["-1"]={r = 1, g = 1, b = 1, hex = color:GenerateHexColorMarkup(), color = color}
	end
	local function exactMatchFun()
		if not PIGA["AHPlus"]["exactMatch"] then return end
		local OLD_QueryAuctionItems = QueryAuctionItems	
		QueryAuctionItems = function(...)
			local text, minLevel, maxLevel, page, usable, rarity, allxiazai, exactMatch, filterData =...
			if PIGA["AHPlus"]["exactMatch"] then exactMatch = true end
			return OLD_QueryAuctionItems(text, minLevel, maxLevel, page, usable, rarity, allxiazai, exactMatch, filterData)
		end
	end
	exactMatchFun()
	AuctionFrameBrowse.exact =PIGCheckbutton(AuctionFrameBrowse,nil,{AH_EXACT_MATCH,AH_EXACT_MATCH_TOOLTIP},nil,nil,nil,0)
	if ElvUI and AuctionFrame.backdrop then
		AuctionFrameBrowse.exact:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",530,-4);
	else
		AuctionFrameBrowse.exact:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",530,-14);
	end
	AuctionFrameBrowse.exact.Text:SetTextColor(0, 1, 0, 0.8);
	AuctionFrameBrowse.exact:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["exactMatch"]=true
			exactMatchFun()
		else
			PIGA["AHPlus"]["exactMatch"]=false
		end
	end);
	----
	local AH_TIME = TIME_LABEL:gsub(":","")
	local AH_TIME = AH_TIME:gsub("：","")
	local biaotiLsit = {"BrowseQualitySort","Browse_biaoti_Count","BrowseLevelSort","Browse_biaoti_unitbid","BrowseCurrentBidSort","BrowseUpDown","BrowseDurationSort","BrowseHighBidderSort"}
	local biaotiLsitW = {190,46,38,170,170,54,100,100}
	local biaotiLsitArrow={true,false,true,true,true,false,true,true}
	local biaotiLsitName = {"",ACTION_SPELL_AURA_APPLIED_DOSE,"",AUCTION_SORT_HEADER_UNIT_BID_PRICE,AUCTION_SORT_HEADER_UNIT_BUYOUT_PRICE,"涨跌","",""}
	local hang_Height,hang_NUM ,anniuH,suoxiaozhi,FontSise = 25, 14, 18, 58, 13.2
	local shengyuTime = {[1]="|cffFF0000<30m|r",[2]="|cffFFFF0030m~2H|r",[3]="|cff00FF002H~12H|r",[4]="|cff00FF00>12H|r",}
	local Funlist={}
	local function SetFrameMoneyFont(uiname)
		local BuyoutFrameMoney = _G[uiname..""];
		local BuyoutFrameMoneyGold = _G[uiname.."GoldButton"];
		local BuyoutFrameMoneySilver = _G[uiname.."SilverButton"];
		local BuyoutFrameMoneyCopper = _G[uiname.."CopperButton"];
		BuyoutFrameMoney:SetHeight(hang_Height)
		BuyoutFrameMoneyGold:SetHeight(hang_Height)
		BuyoutFrameMoneySilver:SetHeight(hang_Height)
		BuyoutFrameMoneyCopper:SetHeight(hang_Height)
		local BuyoutFrameMoneyGoldText = _G[uiname.."GoldButtonText"];
		local BuyoutFrameMoneySilverText = _G[uiname.."SilverButtonText"];
		local BuyoutFrameMoneyCopperText = _G[uiname.."CopperButtonText"];
		PIGSetFont(BuyoutFrameMoneySilverText,FontSise)
		PIGSetFont(BuyoutFrameMoneyCopperText,FontSise)
		PIGSetFont(BuyoutFrameMoneyGoldText,FontSise)
	end
	--调整原版UI
	SetCVar("auctionSortByBuyoutPrice", "1");
	SetCVar("auctionSortByUnitPrice", "1");
	-- NUM_AUCTION_ITEMS_PER_PAGE = 100;
	NUM_BROWSE_TO_DISPLAY = 12;
	BrowseNameText:ClearAllPoints();
	BrowseNameText:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",598,-40);
	BrowseLevelText:ClearAllPoints();
	BrowseLevelText:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",70,-40);

	local BrowseDropDown=BrowseDropDown or BrowseDropdown
	BrowseDropDown:SetPoint("TOPLEFT",BrowseLevelText,"BOTTOMRIGHT",5,4);

	local BrowseIsUsable=IsUsableCheckButton or BrowseIsUsableText
	BrowseIsUsable:ClearAllPoints();
	BrowseIsUsable:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",290,-35);

	--  ShowOnPlayerCheckButton=ShowOnPlayerCheckButton or BrowseShowOnCharacterText--预览效果
	-- 	ShowOnPlayerCheckButton:ClearAllPoints();
	-- 	ShowOnPlayerCheckButton:SetPoint("LEFT",IsUsableCheckButton,"RIGHT",70,0);
	if BrowseResetButton then--重置按钮
		BrowseResetButton:ClearAllPoints();
		BrowseResetButton:SetPoint("LEFT",BrowseNameText,"RIGHT",4,0);
	end
	BrowseSearchButton:ClearAllPoints();
	BrowseSearchButton:SetPoint("LEFT",BrowseName,"RIGHT",4,0);
	BrowseSearchCountText:ClearAllPoints();
	BrowseSearchCountText:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",400,-38);
	BrowsePrevPageButton:ClearAllPoints();
	BrowsePrevPageButton:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",450,-60);
	BrowsePrevPageButton:SetScale(0.88);
	BrowseNextPageButton:ClearAllPoints();
	BrowseNextPageButton:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",620,-60);
	BrowseNextPageButton:SetScale(0.88);
	if BrowsePriceOptionsButtonFrame then--设置单价展示
		BrowsePriceOptionsButtonFrame:Hide()
		hooksecurefunc("AuctionFrameFilter_OnClick", function()
			BrowsePriceOptionsButtonFrame:Hide()
		end)
	end
	---
	AuctionFrameBrowse.bgtex = CreateFrame("Frame", nil, AuctionFrameBrowse,"BackdropTemplate")
	if ElvUI and AuctionFrameBrowse.LeftBackground then
		AuctionFrameBrowse.LeftBackground:SetPoint("BOTTOMRIGHT",AuctionFrameBrowse,"BOTTOMRIGHT",-636,33.61);
	else
		AuctionFrameBrowse.bgtex:SetBackdrop({bgFile = "interface/framegeneral/ui-background-rock.blp"});
		AuctionFrameBrowse.bgtex:SetBackdropColor(0.4, 0.4, 0.4, 1);
		AuctionFrameBrowse.bgtex.fengeline = AuctionFrameBrowse.bgtex:CreateTexture(nil, "BORDER");
		AuctionFrameBrowse.bgtex.fengeline:SetTexture("interface/dialogframe/ui-dialogbox-divider.blp");
		AuctionFrameBrowse.bgtex.fengeline:SetRotation(math.rad(-90),{x=0,y=0})
		AuctionFrameBrowse.bgtex.fengeline:SetSize(408,24);
		AuctionFrameBrowse.bgtex.fengeline:SetPoint("TOPLEFT",AuctionFrameBrowse.bgtex,"TOPLEFT",-20,26);
	end
	AuctionFrameBrowse.bgtex:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",180-suoxiaozhi,-104);
	AuctionFrameBrowse.bgtex:SetPoint("BOTTOMRIGHT",AuctionFrameBrowse,"BOTTOMRIGHT",70,38);
	BrowseScrollFrame:SetPoint("TOPRIGHT",AuctionFrameBrowse.bgtex,"TOPRIGHT",-28,0);
	BrowseScrollFrame:SetPoint("BOTTOMLEFT",AuctionFrameBrowse.bgtex,"BOTTOMLEFT",0,0);
	--
	AuctionFrameBrowse.qushiUI=PIGFrame(AuctionFrameBrowse)
	AuctionFrameBrowse.qushiUI:SetSize(328,204);
	AuctionFrameBrowse.qushiUI:PIGSetBackdrop(1,nil,nil,nil,0)
	AuctionFrameBrowse.qushiUI:SetFrameStrata("HIGH")
	AuctionFrameBrowse.qushiUI.qushiF=BusinessInfo.ADD_qushi(AuctionFrameBrowse.qushiUI,true)
	AuctionFrameBrowse.qushiUI.qushiF:SetPoint("TOPLEFT", AuctionFrameBrowse.qushiUI, "TOPLEFT",4, -24);
	AuctionFrameBrowse.qushiUI.qushiF:SetPoint("BOTTOMRIGHT", AuctionFrameBrowse.qushiUI, "BOTTOMRIGHT",-4, 4);

	--标题
	local function Set_ArrowPoint(but,Sort)
		local existingSortColumn, existingSortReverse = GetAuctionSort("list", 1);
		if existingSortColumn==Sort then
			but.Arrow:Show()
			if existingSortReverse then
				but.Arrow:SetTexCoord(0, 0.5625, 1, 0);
			else
				but.Arrow:SetTexCoord(0, 0.5625, 0, 1);
			end
		else
			but.Arrow:Hide()
		end
	end
	hooksecurefunc("AuctionFrameBrowse_UpdateArrows", function()
		SortButton_UpdateArrow(BrowseCurrentBidSort, "list", "unitprice");
		Set_ArrowPoint(BrowseCurrentBidSort,"unitprice")
		Set_ArrowPoint(Browse_biaoti_unitbid,"unitbid")
	end)
	BrowseSearchButton:HookScript("OnUpdate", function(self,event,arg1)
		if ( CanSendAuctionQuery("list") ) then
			Browse_biaoti_unitbid:Enable();
		else
			Browse_biaoti_unitbid:Disable();
		end
	end);
	for i=1,#biaotiLsit do
		local biaotiBut = _G[biaotiLsit[i]]
		if not biaotiBut then
			biaotiBut = CreateFrame("Button",biaotiLsit[i],AuctionFrameBrowse,"AuctionSortButtonTemplate");
		end
		biaotiBut:SetSize(biaotiLsitW[i]+2,19);
		biaotiBut:ClearAllPoints();
		if biaotiLsitName[i]~="" then
			biaotiBut:SetText(biaotiLsitName[i]);
		end
		if i==4 then
			biaotiBut:HookScript("OnClick", function (self)
				local existingSortColumn, existingSortReverse = GetAuctionSort("list", 1);
				SortAuctionClearSort("list");
				if existingSortColumn=="unitbid" then
					if existingSortReverse then
						SortAuctionSetSort("list", "unitbid", false);
					else
						SortAuctionSetSort("list", "unitbid", true);
					end
				else
					SortAuctionSetSort("list", "unitbid", false);
				end
				AuctionFrameBrowse_Search();
			end)
		end
		if not biaotiLsitArrow[i] then
			_G[biaotiLsit[i].."Arrow"]:Hide() biaotiBut:Disable(); 
			if i==6 then
				AuctionFrameBrowse.qushitishi:SetPoint("RIGHT",biaotiBut,"RIGHT",1,-1);
			end
		end
		if i==1 then
			biaotiBut:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",122,-82);
		elseif i==7 then
			biaotiBut:SetPoint("LEFT",_G[biaotiLsit[i-1]],"RIGHT",30,0);
		else
			biaotiBut:SetPoint("LEFT",_G[biaotiLsit[i-1]],"RIGHT",0,0);
		end
		if ElvUI and AuctionFrame.backdrop or NDui then
			_G[biaotiLsit[i].."Left"]:Hide()
			_G[biaotiLsit[i].."Middle"]:Hide()
			_G[biaotiLsit[i].."Right"]:Hide()
		end
	end
	hooksecurefunc("AuctionFrameFilters_UpdateCategories", function(forceSelectionIntoView)	
		BrowseFilterScrollFrame:ClearAllPoints();
		BrowseFilterScrollFrame:SetPoint("TOPRIGHT",AuctionFrameBrowse,"TOPLEFT",158-suoxiaozhi,-105);
		local hasScrollBar = #OPEN_FILTER_LIST > NUM_FILTERS_TO_DISPLAY;
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
	for i=1, NUM_BROWSE_TO_DISPLAY do
		local button = _G["BrowseButton"..i];
		if not button then
			button = CreateFrame("Button","BrowseButton"..i, AuctionFrameBrowse, "BrowseButtonTemplate", i);
			button:SetPoint("TOPLEFT",_G["BrowseButton"..(i-1)],"BOTTOMLEFT",0,0);
		end
		button:SetHeight(hang_Height)
		local buttonLeft = _G["BrowseButton"..i.."Left"];
		buttonLeft:ClearAllPoints();
		local buttonRight = _G["BrowseButton"..i.."Right"];
		buttonRight:ClearAllPoints();
		if i~=hang_NUM then
			button.line = button:CreateLine()
			button.line:SetColorTexture(1,1,1,0.2)
			button.line:SetThickness(1);
			button.line:SetStartPoint("BOTTOMLEFT",0,0)
			button.line:SetEndPoint("BOTTOMRIGHT",0,0)
		end
		if i==1 then
			button:SetPoint("TOPLEFT", BrowseScrollFrame, "TOPLEFT", 4, -2);
		end
		local buttonItem = _G["BrowseButton"..i.."Item"];
		local buttonName = _G["BrowseButton"..i.."Name"];
		local buttonLevel = _G["BrowseButton"..i.."Level"];
		local itemCount = _G["BrowseButton"..i.."ItemCount"];
		local buttonClosingTime = _G["BrowseButton"..i.."ClosingTime"];
		local buttonHighBidder = _G["BrowseButton"..i.."HighBidder"];
		SetFrameMoneyFont("BrowseButton"..i.."MoneyFrame")
		SetFrameMoneyFont("BrowseButton"..i.."BuyoutFrameMoney")
		_G["BrowseButton"..i.."BuyoutFrameText"]:Hide()
		_G["BrowseButton"..i.."ClosingTimeText"]:SetAllPoints(buttonClosingTime)
		buttonItem:SetScale((hang_Height-4)/32)
		buttonItem:ClearAllPoints();
		buttonItem:SetPoint("LEFT", button, "LEFT", 0, 0);
		
		buttonName:SetSize(biaotiLsitW[1]-hang_Height+6,hang_Height)
		buttonName:ClearAllPoints();
		buttonName:SetPoint("LEFT", buttonItem, "RIGHT", 2, 0);
		itemCount:SetTextColor(0, 1, 1, 1);
		itemCount:SetSize(biaotiLsitW[2],hang_Height)
		buttonLevel:SetSize(biaotiLsitW[3],hang_Height)
		buttonLevel:SetPoint("TOPLEFT", button, "TOPLEFT", biaotiLsitW[1]+biaotiLsitW[2], 0);

		buttonClosingTime:SetSize(biaotiLsitW[7],hang_Height)
		buttonClosingTime:SetPoint("TOPLEFT", button, "TOPLEFT", biaotiLsitW[1]+biaotiLsitW[2]+biaotiLsitW[3]+biaotiLsitW[4]+biaotiLsitW[5]+biaotiLsitW[6]+42, 0);
		buttonHighBidder:SetSize(biaotiLsitW[8],hang_Height)
		buttonHighBidder:SetPoint("TOPLEFT", button, "TOPLEFT", biaotiLsitW[1]+biaotiLsitW[2]+biaotiLsitW[3]+biaotiLsitW[4]+biaotiLsitW[5]+biaotiLsitW[6]+biaotiLsitW[7]+42, 0);
		
		button.UpDown = CreateFrame("Frame", "BrowseButton"..i.."UpDown", button)
		button.UpDown:SetSize(biaotiLsitW[6]-4,hang_Height);
		button.UpDown:SetPoint("RIGHT", button, "RIGHT", -6,0);
		button.UpDown.Text = PIGFontString(button.UpDown,nil,nil,"OUTLINE")
		button.UpDown.Text:SetJustifyH("RIGHT");
		button.UpDown.Text:SetAllPoints(button.UpDown)
		PIGSetFont(buttonName,FontSise)
		PIGSetFont(itemCount,FontSise)
		itemCount:SetScale(32/(hang_Height-4))
		PIGSetFont(buttonLevel,FontSise)

		PIGSetFont(_G["BrowseButton"..i.."ClosingTimeText"],FontSise)
		PIGSetFont(_G["BrowseButton"..i.."HighBidderName"],FontSise)
		PIGSetFont(button.UpDown.Text,FontSise)
		button.UpDown:HookScript("OnEnter", function(self)
			self:GetParent():LockHighlight();
			local AHdangqianH = FauxScrollFrame_GetOffset(BrowseScrollFrame)+i;
			local name, texture, count, quality = GetAuctionItemInfo("list", AHdangqianH);
			if name then
				if PIGA["AHPlus"]["CacheData"][Pig_OptionsUI.Realm][name] then
					local jiagGGG = PIGA["AHPlus"]["CacheData"][Pig_OptionsUI.Realm][name][2]
					AuctionFrameBrowse.qushiUI:Show()
					AuctionFrameBrowse.qushiUI:SetPoint("TOPRIGHT",self,"TOPLEFT",8,1);
					local r, g, b,hex = GetItemQualityColor(quality)
					AuctionFrameBrowse.qushiUI.qushiF.qushitu(jiagGGG,"|c"..hex..name.."|r")
				end
			end
		end);
		button.UpDown:HookScript("OnLeave", function(self)
			self:GetParent():UnlockHighlight();
			AuctionFrameBrowse.qushiUI:Hide()
		end);
		button:HookScript("OnMouseUp", function (self,button)
			if button=="RightButton" then
				local AHdangqianH = FauxScrollFrame_GetOffset(BrowseScrollFrame)+i;
				local name, texture, count, quality = GetAuctionItemInfo("list", AHdangqianH);
				if name then
					local r, g, b,hex = GetItemQualityColor(quality)
					local hejiinfo = PIGA["AHPlus"]["Coll"]
					for kk=1,#hejiinfo do
						if hejiinfo[kk][1]==name then
							PIGTopMsg:add("<|c"..hex..name.."|r>已存在","R")
							return
						end
					end
					table.insert(PIGA["AHPlus"]["Coll"],{name,texture,quality})
					PIGTopMsg:add("<|c"..hex..name.."|r>已加入关注")
					Funlist:Gengxinlistcoll()
				end
			end
		end);
	end
	hooksecurefunc("AuctionFrameBrowse_Update", function()
		_G[biaotiLsit[5]]:SetWidth(biaotiLsitW[5]+2);
		local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
		if ( totalAuctions > NUM_AUCTION_ITEMS_PER_PAGE ) then
			FauxScrollFrame_Update(BrowseScrollFrame, numBatchAuctions, NUM_BROWSE_TO_DISPLAY, AUCTIONS_BUTTON_HEIGHT);
		end
		BrowseSearchCountText:Show();
		local itemsMin = AuctionFrameBrowse.page * NUM_AUCTION_ITEMS_PER_PAGE + 1;
		local itemsMax = itemsMin + numBatchAuctions - 1;
		BrowseSearchCountText:SetFormattedText(NUMBER_OF_RESULTS_TEMPLATE, itemsMin, itemsMax, totalAuctions);
		for i=1, NUM_BROWSE_TO_DISPLAY do
			local button = _G["BrowseButton"..i];
			button:SetWidth(625+suoxiaozhi-8);
			local buttonHighlight = _G["BrowseButton"..i.."Highlight"];
			buttonHighlight:ClearAllPoints();
			buttonHighlight:SetPoint("TOPLEFT", button, "TOPLEFT", 0, -1);
			buttonHighlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, -1);
			local buttonName = _G["BrowseButton"..i.."Name"];
			local itemCount = _G["BrowseButton"..i.."ItemCount"];
			itemCount:ClearAllPoints();
			itemCount:SetPoint("LEFT", buttonName, "RIGHT", -14, 0);
			if not itemCount:IsShown() then
				itemCount:Show()
				itemCount:SetText(1)
			end
			local MoneyFrame = _G["BrowseButton"..i.."MoneyFrame"];
			MoneyFrame:SetSize(biaotiLsitW[4],hang_Height)
			MoneyFrame:ClearAllPoints();
			MoneyFrame:SetPoint("TOPLEFT", button, "TOPLEFT", biaotiLsitW[1]+biaotiLsitW[2]+biaotiLsitW[3], 0);
			local BuyoutFrame = _G["BrowseButton"..i.."BuyoutFrame"];
			BuyoutFrame:SetSize(biaotiLsitW[5],hang_Height)
			BuyoutFrame:ClearAllPoints();
			BuyoutFrame:SetPoint("TOPLEFT", button, "TOPLEFT", biaotiLsitW[1]+biaotiLsitW[2]+biaotiLsitW[3]+biaotiLsitW[4], 0);
			_G["BrowseButton"..i.."YourBidText"]:Hide()
			_G["BrowseButton"..i.."MoneyFrameCopperButton"]:SetPoint("RIGHT", _G["BrowseButton"..i.."MoneyFrame"], "RIGHT", 0, -2);
			_G["BrowseButton"..i.."BuyoutFrameMoneyCopperButton"]:SetPoint("RIGHT", _G["BrowseButton"..i.."BuyoutFrameMoney"], "RIGHT", 0, -2);
			local buttonClosingTime = _G["BrowseButton"..i.."ClosingTimeText"];
			local AHdangqianH = FauxScrollFrame_GetOffset(BrowseScrollFrame)+i;
			local timeleft = GetAuctionItemTimeLeft("list", AHdangqianH)
			buttonClosingTime:SetText(shengyuTime[timeleft]);
			local name, texture, count, quality, canUse, level, levelColHeader, minBid, minIncrement, buyoutPrice = GetAuctionItemInfo("list", AHdangqianH);
			button.UpDown.Text:SetText("--");
			button.UpDown.Text:SetTextColor(0.5, 0.5, 0.5, 0.5);
			if buyoutPrice>0 then
				local xianjiaV = buyoutPrice/count
				if PIGA["AHPlus"]["CacheData"][Pig_OptionsUI.Realm][name] then
					local OldMoneyG = PIGA["AHPlus"]["CacheData"][Pig_OptionsUI.Realm][name][2]
					if AHdangqianH==1 then
						local existingSortColumn, existingSortReverse = GetAuctionSort("list", 1);
						if existingSortColumn=="unitprice" and existingSortReverse==false then
							local OldGGGV = OldMoneyG[#OldMoneyG]
							if xianjiaV~=OldGGGV[1] and GetServerTime()-OldGGGV[2]>300 then
								table.insert(PIGA["AHPlus"]["CacheData"][Pig_OptionsUI.Realm][name][2],{xianjiaV,GetServerTime()})
							end
						end
					end
				else
					local itemLink = GetAuctionItemLink("list", AHdangqianH)
					local itemLinkJJ = Fun.GetItemLinkJJ(itemLink)
					PIGA["AHPlus"]["CacheData"][Pig_OptionsUI.Realm][name]={itemLinkJJ,{{xianjiaV,GetServerTime()}}}
				end
				if PIGA["AHPlus"]["CacheData"][Pig_OptionsUI.Realm][name] then
					local OldMoneyG = PIGA["AHPlus"]["CacheData"][Pig_OptionsUI.Realm][name][2]
					local OldGGGV = OldMoneyG[#OldMoneyG]				
					if #OldMoneyG>1 then
						local baifenbi = (xianjiaV/OldGGGV[1])*100+0.5
						local baifenbi = floor(baifenbi)
						button.UpDown.Text:SetText(baifenbi.."%");
						if baifenbi<100 then
							button.UpDown.Text:SetTextColor(0, 1, 0, 1);
						elseif baifenbi>100 then
							button.UpDown.Text:SetTextColor(1, 0, 0, 1);
						else
							button.UpDown.Text:SetTextColor(1, 1, 1, 1);
						end
					end
				end
			end
		end
	end)
	local function ShowHide_OT(vvv)
		_G[biaotiLsit[2]]:SetShown(vvv)
		_G[biaotiLsit[4]]:SetShown(vvv)
		_G[biaotiLsit[6]]:SetShown(vvv)
		AuctionFrameBrowse.ShowHideOT:SetShown(vvv)
		AuctionFrameBrowse.qushitishi:SetShown(vvv)
		local extshowVV = false
		if vvv==true and AuctionFrameBrowse.ShowHideOT.open then
			AuctionFrameBrowse.coll.list:Hide()
			extshowVV=true
		end
		_G[biaotiLsit[7]]:SetShown(extshowVV)
		_G[biaotiLsit[8]]:SetShown(extshowVV)
		for i=1, NUM_BROWSE_TO_DISPLAY do
			_G["BrowseButton"..i.."ClosingTime"]:SetShown(extshowVV)
			_G["BrowseButton"..i.."HighBidder"]:SetShown(extshowVV)
		end
	end
	local function ShowHide_OT_1()
		_G[biaotiLsit[7]]:SetShown(AuctionFrameBrowse.ShowHideOT.open)
		_G[biaotiLsit[8]]:SetShown(AuctionFrameBrowse.ShowHideOT.open)
	end
	AuctionFrameBrowse.ShowHideOT = PIGButton(AuctionFrameBrowse,{"TOPRIGHT",AuctionFrameBrowse,"TOPRIGHT",70,-80},{28,21},"+",nil,nil,nil,nil,0);
	AuctionFrameBrowse.ShowHideOT.open=false
	AuctionFrameBrowse.ShowHideOT:SetScript("OnClick", function(self)
		if AuctionFrameBrowse.ShowHideOT.open then
			AuctionFrameBrowse.ShowHideOT.open=false	
		else
			AuctionFrameBrowse.ShowHideOT.open=true	
		end
		ShowHide_OT(true)
	end)

	---缓存==================
	AuctionFrameBrowse.History = PIGButton(AuctionFrameBrowse,{"TOPRIGHT",AuctionFrameBrowse,"TOPRIGHT",10,-12},{90,20},"缓存价格",nil,nil,nil,nil,0);
	if ElvUI and AuctionFrame.backdrop then
		AuctionFrameBrowse.History:SetPoint("TOPRIGHT",AuctionFrameBrowse,"TOPRIGHT",10,-1);
	end
	AuctionFrameBrowse.History:HookScript("OnShow",function(self)
		local canQuery,canQueryAll = CanSendAuctionQuery()
		if canQueryAll then
			self:Enable()
		else
			self:Disable()
		end
	end)
	---
	AuctionFrameBrowse.huancunUI = CreateFrame("Frame", nil, AuctionFrameBrowse,"BackdropTemplate");
	local HCUI = AuctionFrameBrowse.huancunUI
	HCUI:SetBackdrop({bgFile = "interface/characterframe/ui-party-background.blp",edgeFile = "Interface/Tooltips/UI-Tooltip-Border",edgeSize = 13,});
	HCUI:SetBackdropBorderColor(0, 1, 1, 0.9);
	HCUI:SetPoint("TOPLEFT",AuctionFrameBrowse,"TOPLEFT",14,-34);
	HCUI:SetPoint("BOTTOMRIGHT",AuctionFrameBrowse,"BOTTOMRIGHT",70,12);
	HCUI:SetFrameLevel(520)
	HCUI:EnableMouse(true)
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
	---
	local meiyenum = 50
	HCUI.auctions = {}
	HCUI.auctionsLin = {}
	HCUI.ItemLoadList = {}
	local function OpenScanFun(v)
		if v then
			AuctionFrameBrowse:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE");
		else
			AuctionFrameBrowse:RegisterEvent("AUCTION_ITEM_LIST_UPDATE");
		end
	end
	local function au_SetValue()
		HCUI.jishuID=HCUI.jishuID+1
		HCUI.jindu.t2:SetText(HCUI.jishuID);
		HCUI.jindu:SetValue(HCUI.jishuID);
	end
	local function Save_Data_End()
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
		local AH_data = PIGA["AHPlus"]["CacheData"][Pig_OptionsUI.Realm]
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
			local ItemLink=GetAuctionItemLink("list", index)
			local xianzaidanjia =buyoutPrice/count
			HCUI.auctionsLin[index]={name,xianzaidanjia,ItemLink}
			au_SetValue()
		else
			au_SetValue()
		end
	end
	local function againGetItem_G()
		if not HCUI:IsShown() then return end
		for k,v in pairs(HCUI.ItemLoadList) do
			local name, texture, count, quality, canUse, level, levelColHeader, minBid, minIncrement, buyoutPrice,bidAmount, highBidder, bidderFullName, owner, ownerFullName, saleStatus, itemId, hasAllInfo=GetAuctionItemInfo("list", k);
			if hasAllInfo then
				HCUI.zaicijishu=HCUI.zaicijishu+1
				SauctionsLinData(name,buyoutPrice,count,k)
				HCUI.ItemLoadList[k] = nil
				if HCUI.zaicijishu>=meiyenum then
					break
				end
			end
		end
		if next(HCUI.ItemLoadList) then
			HCUI.zaicijishu=0
			C_Timer.After(HCUI.ScanCD,againGetItem_G)
		else
			C_Timer.After(0.4,Save_Data_End)
		end
	end
	local function Update_GetItem_G(self,sss)
		if self.jishiqitime>HCUI.ScanCD then
			self.jishiqitime=0
			if HCUI.AuctionsNum==0 then
				self:Hide()
				Save_Data_End()
				return
			end
			local kaishi = HCUI.kaishi+1
			local jieshu = kaishi+meiyenum-1
			if jieshu>HCUI.AuctionsNum then
				jieshu = HCUI.AuctionsNum
			end
			HCUI.kaishi=jieshu
			for index=kaishi,jieshu do
				if HCUI.ItemLoadList[index] then
					local name, texture, count, quality, canUse, level, levelColHeader, minBid, minIncrement, buyoutPrice,bidAmount, highBidder, bidderFullName, owner, ownerFullName, saleStatus, itemId, hasAllInfo=GetAuctionItemInfo("list", index);
					if hasAllInfo then
						SauctionsLinData(name,buyoutPrice,count,index)
						HCUI.ItemLoadList[index] = nil
					end
				end
			end
			if jieshu>=HCUI.AuctionsNum then
				self:Hide()
				if next(HCUI.ItemLoadList) then
					HCUI.zaicijishu=0
					againGetItem_G()
				else
					Save_Data_End()
				end
			end
		else
			self.jishiqitime = self.jishiqitime + sss;
		end
	end
	local function Update_GetItems(self,sss)
		if self.jishiqitime>1 then
			self.jishiqitime=0		
			if HCUI.SMend then
				self:Hide()
				wipe(HCUI.auctions)
				wipe(HCUI.auctionsLin)
				wipe(HCUI.ItemLoadList)
				HCUI.jindu.tbiaoti:SetText("正在获取价格...");
				local AuctionsNum = GetNumAuctionItems("list");
				HCUI.jindu.t3:SetText(AuctionsNum);
				HCUI.jindu:SetMinMaxValues(0, AuctionsNum)
				for i=1,AuctionsNum do
					HCUI.ItemLoadList[i]=true
				end
				HCUI.AuctionsNum=AuctionsNum
				HCUI.ScanCD=BusinessInfo.AHPlusData.ScanCD*0.0001
				HCUI.UpdateF:HookScript("OnUpdate",Update_GetItem_G)
				self:Show()
			else
				local AuctionsNum = GetNumAuctionItems("list");
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
	end
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
		HCUI.jishuID = 0
		HCUI.AuctionsNum=0
		HCUI.kaishi=0
		HCUI.SMend=nil
		OpenScanFun(true)
		HCUI.UpdateF.jishiqitime=0
		HCUI.UpdateF:HookScript("OnUpdate",Update_GetItems)
		HCUI.UpdateF:Show()
		QueryAuctionItems("", nil, nil, 0, nil, nil, true, false, nil)--查询全部
	end)
	local baocunnum=baocunnum-1
	function HCUI:DEL_OLDdata()
		for k,v in pairs(PIGA["AHPlus"]["CacheData"][Pig_OptionsUI.Realm]) do
			local itemDataL = v[2]
			local ItemsNum = #itemDataL;
			if ItemsNum>baocunnum then
				for ivb=(ItemsNum-baocunnum),1,-1 do
					table.remove(itemDataL,ivb)
				end
			end
		end
	end
	function HCUI.UiFameHide()
		HCUI.UpdateF:Hide()
		HCUI:Hide();
		HCUI.close:Hide();
		OpenScanFun(nil)
	end

	---时光徽章
	BrowseWowTokenResults.qushibut = PIGButton(BrowseWowTokenResults,{"CENTER",BrowseWowTokenResults,"CENTER",3,10},{80,24},"历史价格",nil,nil,nil,nil,0)
	BrowseWowTokenResults.qushibut:HookScript("OnClick",function(self)
		if StatsInfo_UI then
			if StatsInfo_UI:IsShown() then
				StatsInfo_UI:Hide()
			else
				AuctionFrame:Hide()
				StatsInfo_UI:Show()
				Create.Show_TabBut_R(StatsInfo_UI.F,StatsInfo_UI.timetab[1],StatsInfo_UI.timetab[2])
			end
		else
			PIGTopMsg:add("请打开"..addonName..SETTINGS.."→"..L["BUSINESS_TABNAME"].."→"..INFO..STATISTICS)
		end
	end)
	BrowseWowTokenResults:HookScript("OnShow",function(self)
		ShowHide_OT(false)
	end)
	BrowseWowTokenResults:HookScript("OnHide",function(self)
		ShowHide_OT(true)
	end)

	--关注------------------------
	local collW,collY = 22,22
	AuctionFrameBrowse.coll = CreateFrame("Button",nil,AuctionFrameBrowse);
	local coll=AuctionFrameBrowse.coll
	coll:SetSize(collW,collY);
	coll:SetPoint("TOPRIGHT",AuctionFrameBrowse,"TOPRIGHT",44,-36);
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
		colllistitem.icon:SetSize(hang_Height-2,hang_Height-2);
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
		AuctionFrameBrowse.ShowHideOT.open=false
		ShowHide_OT(true)
		gengxinlistcoll(self.Scroll)
	end);
	function Funlist:Gengxinlistcoll()
		gengxinlistcoll(coll.list.Scroll)	
	end

	---拍卖页==============================
	AuctionFrameAuctions.SellList=PIGFrame(AuctionFrameAuctions,{"TOPLEFT",AuctionFrameAuctions,"TOPLEFT",216,-222})
	AuctionFrameAuctions.SellList:SetPoint("BOTTOMRIGHT",AuctionFrameAuctions,"BOTTOMRIGHT",66,38);
	AuctionFrameAuctions.SellList:PIGSetBackdrop(nil,nil,nil,nil,0)
	AuctionFrameAuctions.SellList:PIGClose()

	local SellListF=AuctionFrameAuctions.SellList
	SellListF:SetFrameLevel(10)
	SellListF:EnableMouse(true)
	SellListF:Hide()
	SellListF.tishibut = PIGButton(SellListF,{"CENTER", SellListF, "CENTER", 0,10},{80,24},LFG_LIST_SEARCH_AGAIN,nil,nil,nil,nil,0)
	SellListF.tishibut_txt = PIGFontString(SellListF,{"BOTTOM", SellListF.tishibut, "TOP", 0,8},nil,"OUTLINE")
	--
	local spellhangnum, hang_Height1= 5,hang_Height+4
	local SellxulieID = {"",ACTION_SPELL_AURA_APPLIED_DOSE,biaotiLsitName[4],biaotiLsitName[5],AH_TIME,AUCTION_CREATOR}
	local SellxulieID_www = {40,42,170,150,80,118}
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
	local function SetAHPriceFun()
		local BiddanjiaGG=SellListF.BidV
		local buyoutdanjiaGG=SellListF.buyoutV
		if not BiddanjiaGG or not buyoutdanjiaGG then return end
		local jianshaozhiV = 1
		if SellListF.owner==Pig_OptionsUI.Name then jianshaozhiV=0 end
		local StackSize = AuctionsStackSizeEntry:GetNumber()
		local NumStacks = AuctionsNumStacksEntry:GetNumber()
		local priceType =UIDropDownMenu_GetSelectedValue(PriceDropDown)
		if ( StackSize >= 0 ) then
			if priceType == 1 then
				local BiddanjiaGG = math.floor(BiddanjiaGG+0.5)-jianshaozhiV
				local buyoutdanjiaGG = math.floor(buyoutdanjiaGG+0.5)-jianshaozhiV
				if PIGA["AHPlus"]["yajingbiao"] then
					MoneyInputFrame_SetCopper(StartPrice, BiddanjiaGG);
				else
					MoneyInputFrame_SetCopper(StartPrice, buyoutdanjiaGG);
				end
				MoneyInputFrame_SetCopper(BuyoutPrice, buyoutdanjiaGG);
			else
				local ZBiddanjiaGG = StackSize*BiddanjiaGG
				local ZbuyoutdanjiaGG = StackSize*buyoutdanjiaGG
				local ZBiddanjiaGG = math.floor(ZBiddanjiaGG)-jianshaozhiV
				local ZbuyoutdanjiaGG = math.floor(ZbuyoutdanjiaGG)-jianshaozhiV
				if PIGA["AHPlus"]["yajingbiao"] then
					MoneyInputFrame_SetCopper(StartPrice, ZBiddanjiaGG);
				else
					MoneyInputFrame_SetCopper(StartPrice, ZbuyoutdanjiaGG);
				end
				MoneyInputFrame_SetCopper(BuyoutPrice, ZbuyoutdanjiaGG);
			end
			UpdateDeposit()
		end
	end
	local function ClearSpelllist(name)
		AuctionsItemButton.IsSearchOK=true
		SellListF.tishibut:Hide()
		if name then
			SellListF.tishibut_txt:SetText(SEARCHING);
		else
			SellListF.tishibut_txt:SetText("没有放入拍卖物品！") 
		end
		for i = 1, spellhangnum do
		   	local listFGV = _G["SellList_item_"..i]
		   	listFGV:Hide()
		   	listFGV.yajia.hang_count=nil
			listFGV.yajia.hang_minBid=nil
			listFGV.yajia.hang_buyoutPrice=nil
		end
		SellListF:Show()
	end
	local function gengxinSpelllist()
		local danqianitem = GetAuctionSellItemInfo();
		local numBatchAuctions = GetNumAuctionItems("list");
		if numBatchAuctions>0 then
			for i = 1, spellhangnum do
				local listFGV = _G["SellList_item_"..i]
				local name, _, count, _, _, _, _, minBid, _, buyoutPrice, _, _, _, owner =  GetAuctionItemInfo("list", i);
				if danqianitem~=name then return end	
				local BiddanjiaGG = minBid/count
				local buyoutdanjiaGG = buyoutPrice/count
				if i==1 then
					AuctionsItemButton.IsSearchOK=nil
					SellListF.tishibut_txt:SetText("");
		   			if PIGA["AHPlus"]["autoya"] then
		   				SellListF.BidV=BiddanjiaGG
		   				SellListF.buyoutV=buyoutdanjiaGG
		   				SellListF.ownerV=owner
		   				SetAHPriceFun() 
		   			end
		   		end
				listFGV.yajia.hang_minBid=BiddanjiaGG
				listFGV.yajia.hang_buyoutPrice=buyoutdanjiaGG
				listFGV.yajia.hang_owner=owner
		   		Update_GGG(listFGV.biddanjia,BiddanjiaGG)
				Update_GGG(listFGV.yikoudanjia,buyoutdanjiaGG)
				listFGV.count:SetText(count);
				listFGV.chushouzhe:SetText(owner);
				local timeleft = GetAuctionItemTimeLeft("list", i)
				listFGV.TimeLeft:SetText(shengyuTime[timeleft]);
				listFGV:Show()
			end
		end
	end
	local function Query_Search(name)
		if not name then return end
		SortAuctionSetSort("list","unitprice", false)
		AuctionFrameBrowse_Reset(BrowseResetButton)
		local name=name or AuctionsItemButton.OldName
		BrowseName:SetText('"'..name..'"')
		AuctionFrameBrowse_Search()
		if SellListF.ahTicker then SellListF.ahTicker:Cancel() end
		SellListF.ahTicker=C_Timer.NewTimer(6,function()
			if AuctionsItemButton.IsSearchOK then
				SellListF.tishibut:Show()
				SellListF.tishibut_txt:SetText(LFG_LIST_SEARCH_FAILED);
			end
		end)
	end
	SellListF.tishibut:SetScript("OnClick", function (self)
		local name = GetAuctionSellItemInfo();
		ClearSpelllist(name)
		Query_Search(name)
	end);
	SellListF:RegisterEvent("AUCTION_ITEM_LIST_UPDATE");
	SellListF:HookScript("OnEvent",function(self,event,arg1,arg2)
		if AuctionsItemButton:IsShown() then
			gengxinSpelllist()
		end
	end)
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
		listFitem.yajia = PIGButton(listFitem,{"LEFT", listFitem, "LEFT", 0,0},{SellxulieID_www[1],22},"压",nil,nil,nil,nil,0)
		listFitem.yajia:SetScript("OnClick", function(self, button)
			SellListF.BidV=self.hang_minBid
		   	SellListF.buyoutV=self.hang_buyoutPrice
		   	SellListF.ownerV=self.hang_owner
			SetAHPriceFun()
		end)
		---
		listFitem.count = PIGFontString(listFitem,{"LEFT", listFitem.yajia, "RIGHT", 0,0},nil,"OUTLINE",13)
		listFitem.count:SetWidth(SellxulieID_www[2]);
		listFitem.count:SetTextColor(0, 1, 1, 1);
		--
		listFitem.biddanjia=Add_GGGF(listFitem,listFitem.count,SellxulieID_www[3],hang_Height1,{1, 1, 1, 1})
		listFitem.yikoudanjia=Add_GGGF(listFitem,listFitem.biddanjia,SellxulieID_www[4],hang_Height1,{0, 1, 1, 1})
		---
		listFitem.TimeLeft = PIGFontString(listFitem,{"LEFT", listFitem.yikoudanjia, "RIGHT", 0,0},nil,"OUTLINE",13)
		listFitem.TimeLeft:SetWidth(SellxulieID_www[5]);
		--
		listFitem.chushouzhe = PIGFontString(listFitem,{"LEFT", listFitem.TimeLeft, "RIGHT", 2,0},nil,"OUTLINE",13)
		listFitem.chushouzhe:SetWidth(SellxulieID_www[6]);
		listFitem.chushouzhe:SetJustifyH("LEFT");
	end
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
	AuctionsStackSizeEntry:HookScript("OnCursorChanged", function (self)
		SetAHPriceFun()
	end);
	--每个/每组
	if not PriceDropDown then
		AuctionFrameAuctions.priceType=1
		local xialaDropDown = CreateFrame("Frame", "PriceDropDown", AuctionFrameAuctions,"UIDropDownMenuTemplate");
		
		xialaDropDown:ClearAllPoints();
		xialaDropDown:SetPoint("TOPLEFT",AuctionFrameAuctions,"TOPLEFT",70,-174);
		
		local function xialaDropDown_OnClick(self)
			if ( AuctionFrameAuctions.priceType ~= self.value ) then
				AuctionFrameAuctions.priceType = self.value;
				UIDropDownMenu_SetSelectedValue(xialaDropDown, self.value);
				SetAHPriceFun()
			end
		end
		local function xialaDropDown_Initialize()
			local info = UIDropDownMenu_CreateInfo();
			info.text = AUCTION_PRICE_PER_ITEM;
			info.value = 1;
			info.checked =AuctionFrameAuctions.priceType==1;
			info.func = xialaDropDown_OnClick;
			UIDropDownMenu_AddButton(info);
			info.text = AUCTION_PRICE_PER_STACK;
			info.value = 2;
			info.checked = AuctionFrameAuctions.priceType==2;
			info.func = xialaDropDown_OnClick;
			UIDropDownMenu_AddButton(info);
		end
		UIDropDownMenu_Initialize(xialaDropDown, xialaDropDown_Initialize);
		xialaDropDown:SetScript("OnShow", function (self)
			UIDropDownMenu_SetSelectedValue(self, AuctionFrameAuctions.priceType);
		end);
	end
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
	AuctionsShortAuctionButtonText:SetPoint("LEFT",AuctionsShortAuctionButton,"RIGHT",0,0);
	AuctionsMediumAuctionButton:ClearAllPoints();
	AuctionsMediumAuctionButton:SetPoint("LEFT",AuctionsShortAuctionButtonText,"RIGHT",2,0);
	AuctionsMediumAuctionButton:SetHitRectInsets(0,-36,0,0);
	AuctionsMediumAuctionButtonText:SetPoint("LEFT",AuctionsMediumAuctionButton,"RIGHT",0,0);
	AuctionsLongAuctionButton:ClearAllPoints();
	AuctionsLongAuctionButton:SetPoint("LEFT",AuctionsMediumAuctionButtonText,"RIGHT",2,0);
	AuctionsLongAuctionButton:SetHitRectInsets(0,-36,0,0);
	AuctionsLongAuctionButtonText:SetPoint("LEFT",AuctionsLongAuctionButton,"RIGHT",0,0);

	--压价按钮
	AuctionFrameAuctions.autoya =PIGCheckbutton(AuctionFrameAuctions,{"TOPLEFT",AuctionFrameAuctions,"TOPLEFT",24,-286},{"自动压","选中后拍卖物品时将根据现售最低价自动压价"},nil,nil,nil,0)
	AuctionFrameAuctions.autoya.Text:SetTextColor(0, 1, 0, 0.8);
	AuctionFrameAuctions.autoya:SetChecked(PIGA["AHPlus"]["autoya"])
	AuctionFrameAuctions.autoya:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["autoya"]=true
		else
			PIGA["AHPlus"]["autoya"]=false
		end
	end);
	
	AuctionFrameAuctions.yajingbiao =PIGCheckbutton(AuctionFrameAuctions,{"LEFT",AuctionFrameAuctions.autoya.Text,"RIGHT",1,0},{"压竞标","选中后压一口价同时压竞标价"},nil,nil,nil,0)
	AuctionFrameAuctions.yajingbiao.Text:SetTextColor(0, 1, 0, 0.8);
	AuctionFrameAuctions.yajingbiao:SetChecked(PIGA["AHPlus"]["yajingbiao"])
	AuctionFrameAuctions.yajingbiao:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["yajingbiao"]=true
		else
			PIGA["AHPlus"]["yajingbiao"]=false
		end
	end);
	AuctionFrameAuctions.Showcankao = PIGButton(AuctionFrameAuctions,{"LEFT",AuctionFrameAuctions.yajingbiao.Text,"RIGHT",1,0},{46,20},"在售",nil,nil,nil,nil,0)
	AuctionFrameAuctions.Showcankao:SetScript("OnClick", function (self)
		if SellListF:IsShown() then
			SellListF:Hide()
		else
			local name = GetAuctionSellItemInfo();
			ClearSpelllist(name)
			Query_Search(name)
		end
	end);

	AuctionFrameAuctions.oldaucG =PIGCheckbutton(AuctionFrameAuctions,{"BOTTOMLEFT",AuctionFrameAuctions,"BOTTOMLEFT",230,15},{"记住本次拍卖价格","本次卖出相同物品使用前一次设置拍卖价格,而不是压已有的最低价。\n(只在本次打开拍卖界面期间生效)"},nil,nil,nil,0)
	if ElvUI and AuctionFrame.backdrop then
		AuctionFrameAuctions.oldaucG:SetPoint("BOTTOMLEFT",AuctionFrameAuctions,"BOTTOMLEFT",230,9);
	end
	AuctionFrameAuctions.oldaucG.Text:SetTextColor(0, 1, 0, 0.8);
	AuctionFrameAuctions.oldaucG:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["oldaucG"]=true
		else
			PIGA["AHPlus"]["oldaucG"]=false
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
	AuctionFrameAuctions.DurationCheck =PIGCheckbutton(AuctionFrameAuctions,{"BOTTOMLEFT",AuctionFrameAuctions,"BOTTOMLEFT",380,15},{SAVE..AUCTION_DURATION,SAVE..AUCTION_DURATION..SETTINGS},nil,nil,nil,0)
	AuctionFrameAuctions.DurationCheck.Text:SetTextColor(0, 1, 0, 0.8);
	if ElvUI and AuctionFrame.backdrop then
		AuctionFrameAuctions.DurationCheck:SetPoint("BOTTOMLEFT",AuctionFrameAuctions,"BOTTOMLEFT",380,9);
	end
	AuctionFrameAuctions.DurationCheck:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["SaveDuration"]=true
			PIGA["AHPlus"]["SaveDuration_V"]=AuctionFrameAuctions.duration
		else
			PIGA["AHPlus"]["SaveDuration"]=false
		end
	end);
	if PIGA["AHPlus"]["SaveDuration"] then AuctionsRadioButton_OnClick(PIGA["AHPlus"]["SaveDuration_V"]) end
	hooksecurefunc("AuctionsRadioButton_OnClick", function(id)
		if PIGA["AHPlus"]["SaveDuration"] then PIGA["AHPlus"]["SaveDuration_V"]=AuctionFrameAuctions.duration end
	end)
	AuctionsCreateAuctionButton:HookScript("OnClick", function(self)
		if AuctionsItemButton.OldName then
			AuctionsItemButton.OldGlist[AuctionsItemButton.OldName]={LAST_ITEM_START_BID,LAST_ITEM_BUYOUT}
		end
	end);
	AuctionsItemButton:HookScript("OnEvent",function(self,event,arg1,arg2)
		if event=="NEW_AUCTION_UPDATE" then
			AuctionsItemButtonCount:Hide();
			AuctionsStackSizeEntry:Hide();
			AuctionsStackSizeMaxButton:Hide();
			AuctionsNumStacksEntry:Hide();
			AuctionsNumStacksMaxButton:Hide();
			PriceDropDown:Hide();
			local name, texture, count, quality, canUse, price, pricePerUnit, stackCount, totalCount, itemID = GetAuctionSellItemInfo();
			ClearSpelllist(name)
			if name==AuctionsItemButton.OldName then
			else
				if PIGA["AHPlus"]["oldaucG"] and AuctionsItemButton.OldGlist[name] then
					PIGTopMsg:add("<"..name..">存在本次历史卖价,不再查询")
					SetAHPriceFun(AuctionsItemButton.OldGlist[name][1],AuctionsItemButton.OldGlist[name][2],nil,true)
				else
					Query_Search(name)
				end
			end
			if (C_WowTokenPublic.IsAuctionableWowToken(itemID)) then
			else
				if ( totalCount > 1 ) then
					AuctionsStackSizeEntry:Show();
					AuctionsStackSizeMaxButton:Show();
					AuctionsNumStacksEntry:Show();
					AuctionsNumStacksMaxButton:Show();
					PriceDropDown:Show();
					UpdateMaximumButtons();
				end
			end
			AuctionsItemButton.OldName=name
		end
	end)
	--浏览页
	AuctionFrameBrowse:HookScript("OnShow",function(self)
		self.exact:SetChecked(PIGA["AHPlus"]["exactMatch"])
		self.coll.list:Show()
		HCUI.UiFameHide()
	end)
	AuctionFrameBrowse:HookScript("OnHide",HCUI.UiFameHide)
	--拍卖页
	AuctionFrameAuctions:HookScript("OnShow",function(self)
		self.oldaucG:SetChecked(PIGA["AHPlus"]["oldaucG"])
		self.DurationCheck:SetChecked(PIGA["AHPlus"]["SaveDuration"])
	end)
	AuctionFrameAuctions:HookScript("OnHide",function()
		SellListF:Hide()
	end)
	----拍卖行
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
	AuctionFrame:HookScript("OnShow",function(self)
		for k,v in pairs(CVarName) do
			local OLDcannn = GetCVar(k)
			if OLDcannn then
				OLD_CVarName[k]=OLDcannn
			end
		end
		for k,v in pairs(CVarName) do
			SetCVar(k, v)
		end
		SortAuctionSetSort("list","unitprice", false)
		SetSelectedAuctionItem("list", 0);
		AuctionsItemButton.OldGlist={}
	end)
	AuctionFrame:HookScript("OnHide", function(self)
		AuctionsItemButton.OldName=nil
		for k,v in pairs(OLD_CVarName) do
			SetCVar(k, v)
		end
	end);
end