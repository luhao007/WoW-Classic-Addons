local addonName, addonTable = ...;
local GDKPInfo=addonTable.GDKPInfo
function GDKPInfo.ADD_Trade(RaidR)
	local Create, Data, Fun, L, Default, Default_Per= unpack(PIG)
	local PIGFrame=Create.PIGFrame
	local PIGLine=Create.PIGLine
	local PIGButton = Create.PIGButton
	local PIGFontString=Create.PIGFontString
	local PIGSetFont=Create.PIGSetFont
	local PIGDiyBut=Create.PIGDiyBut
	local bagData=Data.bagData
	local GetContainerNumSlots = GetContainerNumSlots or C_Container and C_Container.GetContainerNumSlots
	---
	local WidthF,D_Height,D_hangNUM = 260,18,10
	local PIGTradeF = PIGFrame(TradeFrame,{"TOPLEFT",TradeFrame,"TOPRIGHT",-3,0},nil,nil,nil,nil,{["ElvUI"]={2,0,2,1},["NDui"]={2,1,2,0}});
	RaidR.PIGTradeF=PIGTradeF
	PIGTradeF:PIGSetPoint({"BOTTOMLEFT",TradeFrame,"BOTTOMRIGHT",-3,-1})
	PIGTradeF:SetWidth(WidthF); 
	PIGTradeF:PIGSetBackdrop()
	PIGTradeF:SetFrameLevel(TradeFrame:GetFrameLevel()+5)
	PIGTradeF:Hide()
	TradeFrame.ShowDebtUI = PIGButton(TradeFrame,{"TOPRIGHT",TradeFrame,"TOPRIGHT",-4,-26},{30,24},"账",nil,nil,nil,nil,0);
	TradeFrame.ShowDebtUI:HookScript("OnClick",function (self)
		self:Hide()
		PIGTradeF:Show()
	end)
	PIGTradeF.cancel = PIGButton(PIGTradeF,{"BOTTOM",PIGTradeF,"BOTTOM",0,20},{100,24},"不记录本次",nil,nil,nil,nil,0);
	PIGTradeF.cancel:HookScript("OnClick",function (self)
		PIGTradeF.Isjilu=false
		PIGTradeF:Hide()
	end)
	PIGTradeF.debtModeBut = PIGButton(PIGTradeF,{"TOPRIGHT",PIGTradeF,"TOPRIGHT",-4,-38},{80,22},"记录欠账",nil,nil,nil,nil,0);
	PIGTradeF.debtMode=false
	PIGTradeF.debtModeBut:HookScript("OnClick",function (self)
		PIGTradeF.debtMode=true
		PIGTradeF.debtModeBut:Hide()
		PIGTradeF.ListF.biaotilist[2]:SetText("欠款/G")
		for id = 1, D_hangNUM do
			PIGTradeF.ListF.butlist[id].qianV.Left:Show()
			PIGTradeF.ListF.butlist[id].qianV.Right:Show()
			PIGTradeF.ListF.butlist[id].qianV.Middle:Show()
			PIGTradeF.ListF.butlist[id].qianV:SetTextColor(1, 0, 0, 1)
		end
	end)
	
	PIGTradeF.biaoti = PIGFontString(PIGTradeF,{"TOPLEFT", PIGTradeF, "TOPLEFT", 10,-4},L.pigname..L["PIGaddonList"][addonName]);
	PIGTradeF.biaoti:SetTextColor(0, 1, 0, 1);
	PIGTradeF.biaoti1 = PIGFontString(PIGTradeF,{"LEFT", PIGTradeF.biaoti, "RIGHT", 4,0});
	PIGTradeF.biaoti1:SetTextColor(1, 0, 1, 1);
	PIGTradeF.DkPlayerT = PIGFontString(PIGTradeF,{"TOPLEFT", PIGTradeF.biaoti, "BOTTOMLEFT", 0,-10});
	PIGTradeF.DkPlayer = PIGFontString(PIGTradeF,{"LEFT", PIGTradeF.DkPlayerT, "RIGHT", 0,0},"");
	PIGTradeF.DkPlayer:SetTextColor(1, 1, 1, 1);
	PIGTradeF.SetPlayer = PIGButton(PIGTradeF,{"LEFT",PIGTradeF.DkPlayer,"RIGHT",4,1},{100,22},nil,nil,nil,nil,nil,0);
	PIGTradeF.SetPlayer:HookScript("OnClick",function (self)
		RaidR.PlayerList:Showtishi("DebtRen")
	end)
	PIGTradeF.ListF = PIGFrame(PIGTradeF,{"TOPLEFT",PIGTradeF,"TOPLEFT",6,-80});
	PIGTradeF.ListF:SetPoint("TOPRIGHT",PIGTradeF,"TOPRIGHT",-6,-80);
	PIGTradeF.ListF:SetHeight((D_Height+2)*D_hangNUM);
	local D_biaoti = {"账目名","",""}
	PIGTradeF.ListF.biaotilist = {}
	for id = 1, #D_biaoti, 1 do
		local biaoti = PIGFontString(PIGTradeF.ListF,nil,D_biaoti[id]);
		PIGTradeF.ListF.biaotilist[id]=biaoti
		if id==1 then
			biaoti:SetPoint("BOTTOMLEFT", PIGTradeF.ListF, "TOPLEFT", 4,2);
		elseif id==2 then
			biaoti:SetPoint("BOTTOMRIGHT", PIGTradeF.ListF, "TOPRIGHT", -D_Height-18,2);
			biaoti:SetTextColor(1, 0, 0, 1);
		else
			biaoti:SetPoint("BOTTOMRIGHT", PIGTradeF.ListF, "TOPRIGHT", 0,2);
			biaoti:SetTextColor(1, 1, 0, 1);
		end
	end
	PIGTradeF.ListF.butlist = {}
	for id = 1, D_hangNUM do
		local hang = CreateFrame("Frame", nil, PIGTradeF.ListF);
		PIGTradeF.ListF.butlist[id]=hang
		hang:SetSize(WidthF-20, D_Height);
		if id==1 then
			hang:SetPoint("TOPLEFT",PIGTradeF.ListF,"TOPLEFT",0,0);
		else
			hang:SetPoint("TOP",PIGTradeF.ListF.butlist[id-1],"BOTTOM",0,-2);
		end
		PIGLine(hang,"TOP",nil,nil,nil,{0.3,0.3,0.3,0.3})
		hang.ItemName = PIGFontString(hang,{"LEFT", hang, "LEFT", 0,0});
		hang.ItemName:SetWidth(WidthF-100);
		hang.ItemName:SetJustifyH("LEFT")
		hang.qianV = CreateFrame("EditBox", nil, hang, "InputBoxInstructionsTemplate");
		hang.qianV:SetSize(66,D_Height);
		hang.qianV:SetPoint("RIGHT", hang, "RIGHT", -D_Height-10,0);
		PIGSetFont(hang.qianV,14,"OUTLINE")
		hang.qianV:SetMaxLetters(7)
		hang.qianV:SetAutoFocus(false)
		hang.qianV:SetNumeric(true)
		hang.qianV:SetJustifyH("RIGHT");
		hang.wancheng = hang:CreateTexture();
		hang.wancheng:SetTexture("interface/raidframe/readycheck-ready.blp");
		hang.wancheng:SetSize(D_Height,D_Height-4);
		hang.wancheng:SetPoint("RIGHT", hang, "RIGHT", 0,0);
	end
	PIGTradeF.ListF.DqianT = PIGFontString(PIGTradeF.ListF,{"TOPLEFT", PIGTradeF.ListF, "BOTTOMLEFT", 10,-10},"玩家总欠款/G: ");
	PIGTradeF.ListF.DqianT:SetTextColor(1, 1, 0, 1)
	PIGTradeF.ListF.DqianG = PIGFontString(PIGTradeF.ListF,{"LEFT", PIGTradeF.ListF.DqianT, "RIGHT", 2,0},"0");
	PIGTradeF.ListF.DqianG:SetTextColor(1, 0, 0, 1)
	PIGTradeF.ListF.benciT = PIGFontString(PIGTradeF.ListF,{"TOPLEFT", PIGTradeF.ListF.DqianT, "BOTTOMLEFT", 0,-6});
	PIGTradeF.ListF.benciT:SetTextColor(0, 1, 0, 1);
	PIGTradeF.ListF.benciG = PIGFontString(PIGTradeF.ListF,{"LEFT", PIGTradeF.ListF.benciT, "RIGHT", 2,0},"0");
	PIGTradeF.ListF.benciG:SetTextColor(0, 1, 0, 1);
	PIGTradeF.ListF.TradeBut = PIGButton(PIGTradeF.ListF,{"LEFT",PIGTradeF.ListF.benciG,"RIGHT",4,0},{50,22},"支付",nil,nil,nil,nil,0);
	PIGTradeF.ListF.TradeBut:HookScript("OnClick",function (self)
		--MoneyInputFrame_SetCopper(TradePlayerInputMoneyFrame, self.zhifuGV*10000);
		local playerTradeMoney = GetPlayerTradeMoney()
        if playerTradeMoney > 0 then
            ClearCursor()
            PickupTradeMoney(playerTradeMoney)
            ClearCursor()
        end
		local zhifuGV = self.zhifuGV*10000
        if GetMoney() >= zhifuGV then
        	ClearCursor()
            PickupPlayerMoney(zhifuGV)
            _G["TradePlayerItem1ItemButton"]:Click()
        else
        	PIG_OptionsUI:ErrorMsg(ERR_NOT_ENOUGH_MONEY, "R")
        	return
        end
		C_Timer.After(0.2,function() AcceptTrade() end)
	end)
	----快捷放置物品
	PIGTradeF.ChatItemT = PIGFontString(PIGTradeF,{"TOPLEFT", PIGTradeF.ListF, "BOTTOMLEFT", 4,-60},"最近物品(左键放置/右键删除):");
	local ChathangH,butNum=30,6
	PIGTradeF.ItemButList = {}
	PIGTradeF.ChatItems_Cache = {}
	PIGTradeF.ChatItems_Show={}
	for id = 1, butNum do
		local hangxx = PIGDiyBut(PIGTradeF,nil,{ChathangH})
		PIGTradeF.ItemButList[id]=hangxx
		if id==1 then
			hangxx:SetPoint("TOPLEFT", PIGTradeF.ListF, "BOTTOMLEFT", 4,-76);
		else
			hangxx:SetPoint("LEFT",PIGTradeF.ItemButList[id-1],"RIGHT",2,0);
		end
		hangxx:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
			GameTooltip:SetHyperlink(self.itemLink);
			GameTooltip:Show();
			if GameTooltip_HideShoppingTooltips then
				GameTooltip_HideShoppingTooltips(GameTooltip);
			else
				local tooltip, anchorFrame, shoppingTooltip1, shoppingTooltip2 = GameTooltip_InitializeComparisonTooltips(GameTooltip);
				shoppingTooltip1:Hide()
				shoppingTooltip2:Hide()
			end
		end);
		hangxx:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		hangxx:SetScript("OnClick", function (self,Button)
			if Button=="LeftButton" then
				if BankFrame.GetActiveBankType then
					C_Container.UseContainerItem(self.bagID, self.slotID, nil, BankFrame:GetActiveBankType(), BankFrame:IsShown() and BankFrame.selectedTab == 2);
				else
					C_Container.UseContainerItem(self.bagID, self.slotID, nil, BankFrame:IsShown() and (BankFrame.selectedTab == 2));
				end
				for ixx=#PIGTradeF.ChatItems_Cache,1,-1 do
					if self.itemID==PIGTradeF.ChatItems_Cache[ixx][2] then
						table.remove(PIGTradeF.ChatItems_Cache,ixx)
						PIGTradeF:UpdateItems()
						return true
					end
				end
			else
				for ixx=#PIGTradeF.ChatItems_Cache,1,-1 do
					if self.itemID==PIGTradeF.ChatItems_Cache[ixx][2] then
						table.remove(PIGTradeF.ChatItems_Cache,ixx)
						PIGTradeF:UpdateItems()
						return true
					end
				end
			end	
		end)	
	end
	function PIGTradeF:DelOlddata()
		local timexx=GetServerTime()
		for ix=#self.ChatItems_Cache,1,-1 do
			if (timexx-self.ChatItems_Cache[ix][1])>600 then
				table.remove(self.ChatItems_Cache,ix)
			end
		end
	end
	function PIGTradeF:IsItemExist(itemID)
		for i=1,#self.ChatItems_Show do
			if itemID==self.ChatItems_Show[i][1] then
				return true
			end
		end
		return false
	end
	function PIGTradeF:IsItembag(bagitemID)
		for ix=#self.ChatItems_Cache,1,-1 do
			if bagitemID==self.ChatItems_Cache[ix][2] then
				return true
			end
		end
		return false
	end
	
	function PIGTradeF:UpdateItems()
		for id = 1, butNum do
			self.ItemButList[id]:Hide()
		end
		self:DelOlddata()
		wipe(self.ChatItems_Show)
		for bag=1,#bagData["bagID"] do
			for slot=1,GetContainerNumSlots(bagData["bagID"][bag]) do
				local itemID, itemLink, icon, stackCount=PIGGetContainerItemInfo(bagData["bagID"][bag], slot)
				if itemID and not self:IsItemExist(itemID) then
					if self:IsItembag(itemID) then
						table.insert(self.ChatItems_Show,{itemID,bagData["bagID"][bag], slot,itemLink, icon})
					end
				end
			end
		end
		for id=1,#self.ChatItems_Show do
			if self.ItemButList[id] then
				self.ItemButList[id]:Show()
				self.ItemButList[id].itemID=self.ChatItems_Show[id][1]
				self.ItemButList[id].bagID=self.ChatItems_Show[id][2]
				self.ItemButList[id].slotID=self.ChatItems_Show[id][3]
				self.ItemButList[id].itemLink=self.ChatItems_Show[id][4]
				self.ItemButList[id].icon:SetTexture(self.ChatItems_Show[id][5])
			end
		end
	end
	--记账
	PIGTradeF.DebtbenciG = {}
	PIGTradeF.DebtDataList = {}
	function PIGTradeF:GetItemsDebt(TName)
		wipe(self.DebtDataList)
		local RRItemList = PIGA["GDKP"]["ItemList"]
		for x=1,#RRItemList do
			if RRItemList[x][8]==TName and RRItemList[x][14]>0 then
				table.insert(self.DebtDataList,{"ItemList",x,RRItemList[x][2],RRItemList[x][14],RRItemList[x][3]})
			end
		end
		local fakuanDataX = PIGA["GDKP"]["fakuan"]
		for x=1,#fakuanDataX do
			if fakuanDataX[x][3]==TName and fakuanDataX[x][4]>0 then
				table.insert(self.DebtDataList,{"fakuan",x,fakuanDataX[x][1],fakuanDataX[x][4]})
			end
		end
		return #self.DebtDataList>0
	end
	local function IsGDKPItem(itemLink_P)
		local itemID_P = GetItemInfoInstant(itemLink_P[1]) 
		local RRItemList = PIGA["GDKP"]["ItemList"]
		for x=1,#RRItemList do
			if itemID_P==RRItemList[x][11] and itemLink_P[2]==RRItemList[x][3] and RRItemList[x][8]==NONE and RRItemList[x][9]==0 and RRItemList[x][14]==0 then
				return true,x
			end
		end
		return false
	end
	function PIGTradeF:SetListhangText(txt1,txt2,txt3,txt4,txt5,show1,show2)
		self.biaoti1:SetText(txt1)
		self.DkPlayerT:SetText(txt2)
		self.SetPlayer:SetText(txt3)
		self.ListF.biaotilist[2]:SetText(txt4)
		self.ListF.biaotilist[3]:SetText(txt5)
		self.SetPlayer:SetShown(show2)
		self.ListF.DqianT:SetShown(show1)
		self.ListF.DqianG:SetShown(show1)
		self.ListF.benciT:SetShown(show1)
		self.ListF.benciG:SetShown(show1)
	end
	function PIGTradeF:Update_hang(ly)
		self.debtMode=false
		self.debtModeBut:Hide()
		self.ListF.TradeBut:Hide()
		for id = 1, D_hangNUM do
			self.ListF.butlist[id].qianV:SetText(0)
			self.ListF.butlist[id].qianV.Left:Hide()
			self.ListF.butlist[id].qianV.Right:Hide()
			self.ListF.butlist[id].qianV.Middle:Hide()
			self.ListF.butlist[id].qianV:SetTextColor(0.5, 0.5, 0.5, 1)
		end
		if ly==1 then--记账
			self:UpdateItems()
			self.debtModeBut:Show()
			self:SetListhangText("成交记账","成交人:","","记账/G","",false,false)
			self.ListF.benciT:SetText("交易完后/G: ")
			local Itemsnum = #self.linItems
			for id=1,Itemsnum do
				local hang=self.ListF.butlist[id]
				hang:Show();
				hang.itemLinkP=self.linItems[id][1]
				if self.linItems[id][2]>1 then
					hang.ItemName:SetText(self.linItems[id][1].."×"..self.linItems[id][2])
				else
					hang.ItemName:SetText(self.linItems[id][1])
				end
				hang.qianV:SetText(self.MoneyTV/Itemsnum)
			end
			self:Show()
		elseif ly==2 then--清账
			self:SetListhangText("欠款明细","欠款人:","选择欠款人","欠款/G","清账",true,true)	
			wipe(self.DebtbenciG)
			--需要处理
			if self:GetItemsDebt(self.PlayerName) then
				self.DebtbenciG.qianG=0
				self.DebtbenciG.benciG=self.MoneyTV
				for id=1,#self.DebtDataList do
					self.DebtbenciG.qianG=self.DebtbenciG.qianG+self.DebtDataList[id][4]
					local hang=self.ListF.butlist[id]
					hang:Show();
					if self.DebtDataList[id][1]=="ItemList" then
						local _,itemLink = GetItemInfo(Fun.HY_ItemLinkJJ(self.DebtDataList[id][3]))
						if self.DebtDataList[id][5]>1 then
							hang.ItemName:SetText(itemLink.."×"..self.DebtDataList[id][5])
						else
							hang.ItemName:SetText(itemLink)
						end
					elseif self.DebtDataList[id][1]=="fakuan" then
						hang.ItemName:SetText(self.DebtDataList[id][3])
					end
					hang.qianV:SetText(self.DebtDataList[id][4])
					self.DebtbenciG.benciG=self.DebtbenciG.benciG-self.DebtDataList[id][4]
					if self.DebtbenciG.benciG>=0 then
						hang.wancheng:Show()
					end
				end
				self.ListF.DqianG:SetText(self.DebtbenciG.qianG)
				self.ListF.benciT:SetText("交易完后/G: ")
				if self.DebtbenciG.benciG==0 then
					self.ListF.benciG:SetTextColor(0, 1, 1, 1);
					self.ListF.benciG:SetText("清账")
				elseif self.DebtbenciG.benciG>0 then
					self.ListF.benciG:SetTextColor(0, 1, 0, 1);
					self.ListF.benciG:SetText("余出"..self.DebtbenciG.benciG)
				else
					self.ListF.benciG:SetTextColor(1, 0, 0, 1);
					self.ListF.benciG:SetText("尚欠"..(-self.DebtbenciG.benciG))
				end
				self:Show()
			else
				TradeFrame.ShowDebtUI:Show()
			end
		elseif ly==3 then--发薪
			self:SetListhangText("发放工资","领薪人:","","欠款/G","",true,false)
			wipe(self.DebtbenciG)
			self.DkPlayer:SetText(self.PlayerName.."(工资"..(PIGTradeF.fenGModeV*0.0001)..")")
			self.DebtbenciG.qianG=0
			self.DebtbenciG.benciG=self.MoneyTV
			self.ListF.benciT:SetText("扣除欠款实发/G: ")
			if self:GetItemsDebt(self.PlayerName) then--存在欠款	
				for id=1,#self.DebtDataList do
					self.DebtbenciG.qianG=self.DebtbenciG.qianG+self.DebtDataList[id][4]
					local hang=self.ListF.butlist[id]
					hang:Show();
					if self.DebtDataList[id][1]=="ItemList" then
						local _,itemLink = GetItemInfo(Fun.HY_ItemLinkJJ(self.DebtDataList[id][3]))
						if self.DebtDataList[id][5]>1 then
							hang.ItemName:SetText(itemLink.."×"..self.DebtDataList[id][5])
						else
							hang.ItemName:SetText(itemLink)
						end
					elseif self.DebtDataList[id][1]=="fakuan" then
						hang.ItemName:SetText(self.DebtDataList[id][3])
					end
					hang.qianV:SetText(self.DebtDataList[id][4])
					self.DebtbenciG.benciG=self.DebtbenciG.benciG-self.DebtDataList[id][4]
					if self.DebtbenciG.benciG>=0 then
						hang.wancheng:Show()
					end
				end
				local shifaV=PIGTradeF.fenGModeV-self.DebtbenciG.qianG*10000
				if shifaV>=0 then
					self.ListF.benciG:SetText(shifaV*0.0001)
					if shifaV>0 then
						--self.ListF.TradeBut.zhifuGV=shifaV*0.0001;
						--self.ListF.TradeBut:Show() 
					end
				else
					self.ListF.benciG:SetText("|cffFF0000"..(shifaV*0.0001).."资不抵债|r")
				end
			else
				self.ListF.benciG:SetText(PIGTradeF.fenGModeV*0.0001)
				--self.ListF.TradeBut.zhifuGV=PIGTradeF.fenGModeV*0.0001
				--self.ListF.TradeBut:Show()
			end
			self.ListF.DqianG:SetText(self.DebtbenciG.qianG)
			self:Show()
		end
	end
	function PIGTradeF:Update_Show(ly)
		local p,pp=RaidR.IsNameInRiad(self.PlayerName)
		if p then 
			self.DkPlayer:SetText(self.PlayerName)
			for id = 1, D_hangNUM do
				local hang=self.ListF.butlist[id]
				hang:Hide()
				hang.wancheng:Hide()
			end
			self:Update_hang(ly)
		end
	end
	function PIGTradeF.updataDebtRen(lyname,ly)
		PIGTradeF.PlayerName=lyname
		PIGTradeF.MoneyTV=GetTargetTradeMoney()*0.0001
		PIGTradeF:Update_Show(ly)
	end
	hooksecurefunc("MoneyInputFrame_OnTextChanged", function(self)
		if self==TradePlayerInputMoneyFrameGold or self==TradePlayerInputMoneyFrameSilver or self==TradePlayerInputMoneyFrameCopper then
			if self.fenGModeV then
				PIGTradeF.MoneyPV = GetPlayerTradeMoney()*0.0001
				PIGTradeF:Update_Show(3)
			end
		end
	end)
	PIGTradeF.linItems={}
	PIGTradeF:RegisterEvent("TRADE_SHOW");
	PIGTradeF:RegisterEvent("TRADE_CLOSED");
	PIGTradeF:RegisterEvent("UI_INFO_MESSAGE");
	PIGTradeF:RegisterEvent("UI_ERROR_MESSAGE");
	PIGTradeF:RegisterEvent("TRADE_MONEY_CHANGED");
	PIGTradeF:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED");
	PIGTradeF:RegisterEvent("CHAT_MSG_RAID");
	PIGTradeF:RegisterEvent("CHAT_MSG_RAID_LEADER");
	PIGTradeF:RegisterEvent("CHAT_MSG_RAID_WARNING");
	PIGTradeF.jishu=0
	PIGTradeF:HookScript("OnEvent",function (self,event,arg1,arg2,arg3,arg4,arg5)
		if not PIGA["GDKP"]["Rsetting"]["jiaoyijilu"] then return end
		if event=="CHAT_MSG_RAID" or event=="CHAT_MSG_RAID_LEADER" or event=="CHAT_MSG_RAID_WARNING" then
			if PIG_OptionsUI.Name~=arg5 then return end
			if arg1:match("Hitem:") then		
				for word in arg1:gmatch("|(Hitem:.-)|h") do
					local itemID, itemType, itemSubType, itemEquipLoc = GetItemInfoInstant(word)
					table.insert(self.ChatItems_Cache,{GetServerTime(),itemID})
				end	
			end
		elseif event=="TRADE_CLOSED" then
			C_Timer.After(0.1,function()
				self.fenGModeV=nil
			end)
		elseif event=="TRADE_SHOW" then
			self:Hide()
			TradeFrame.ShowDebtUI:Hide()
			wipe(self.linItems)
			self.Isjilu=true
			if self.fenGModeV then
				PIGTradeF.PlayerName=GetUnitName("NPC", true)
				PIGTradeF.MoneyPV = 0
				self:Update_Show(3)
			else
				self.updataDebtRen(GetUnitName("NPC", true),2)
			end
		elseif event=="TRADE_MONEY_CHANGED" or event=="TRADE_PLAYER_ITEM_CHANGED" then
			if not self.Isjilu then return end
			if self.fenGModeV then return end
			wipe(self.linItems)
			self.MoneyTV=GetTargetTradeMoney()*0.0001
			for i=1, MAX_TRADE_ITEMS, 1 do
				local PlayerItemLink=GetTradePlayerItemLink(i)
				if PlayerItemLink then
					local _, _, numItems = GetTradePlayerItemInfo(i);
					local itemLink_P= {PlayerItemLink,numItems}
					if IsGDKPItem(itemLink_P) then
						table.insert(self.linItems,itemLink_P)
					end
				end 
			end
			if #self.linItems>0 then--有金团助手物品交出	
				self:Update_Show(1)
			else
				self:Update_Show(2)
			end
		elseif event=="UI_INFO_MESSAGE" then
			if arg2==ERR_TRADE_COMPLETE then
				if not self.Isjilu then return end
				if self.fenGModeV then--分G
					local shifaV=PIGTradeF.fenGModeV-self.DebtbenciG.qianG*10000
					if shifaV>=0 then
						local RRItemList = PIGA["GDKP"]["ItemList"]
						local fakuanDataX = PIGA["GDKP"]["fakuan"]
						for id=1,#self.DebtDataList do
							if self.DebtDataList[id][1]=="ItemList" then
								local itemdataC =RRItemList[self.DebtDataList[id][2]]
								itemdataC[9]=itemdataC[9]+itemdataC[14]
								itemdataC[14]=0
							elseif self.DebtDataList[id][1]=="fakuan" then
								local itemdataC =fakuanDataX[self.DebtDataList[id][2]]
								itemdataC[2]=itemdataC[2]+itemdataC[4]
								itemdataC[4]=0
							end
						end
						RaidR.Update_Item();
					end
					--记录玩家已交易
					local infoData = PIGA["GDKP"]["Raidinfo"]
					for p=1,8 do
						for pp=1,#infoData[p] do
							if infoData[p][pp][1]==PIGTradeF.PlayerName then
								infoData[p][pp][9]=true
								RaidR.Update_FenG()
								return
							end
						end
					end
				else
					if #self.linItems>0 and self.MoneyTV>0 then--有物品交出和金币收入	
						--屏蔽交易产生的拾取记录		
						RaidR.shiqulinshiStop=true
						C_Timer.After(0.2,function()
							RaidR.shiqulinshiStop=nil
						end)
						local Itemsnum = #self.linItems
						local danjianG = self.MoneyTV/Itemsnum
						local RRItemList = PIGA["GDKP"]["ItemList"]
						for id=1,Itemsnum do
							local isok,indexx =IsGDKPItem(self.linItems[id])
							if isok then
								RRItemList[indexx][8]=PIGTradeF.PlayerName or NONE;
								RRItemList[indexx][9]=danjianG;
								RRItemList[indexx][10]=GetServerTime();
							end
						end
						RaidR.Update_Item();
					elseif #self.linItems>0 and self.MoneyTV==0 and PIGTradeF.debtMode then--有物品交出和无金币收入/欠款模式
						local Itemsnum = #self.linItems
						local RRItemList = PIGA["GDKP"]["ItemList"]
						for id=1,Itemsnum do
							local isok,indexx =IsGDKPItem(self.linItems[id])
							if isok then
								local danjianG = self.ListF.butlist[id].qianV:GetNumber()
								RRItemList[indexx][8]=PIGTradeF.PlayerName or NONE;
								RRItemList[indexx][14]=danjianG;
								RRItemList[indexx][10]=GetServerTime();
							end
						end
						RaidR.Update_Item();
					elseif self.MoneyTV>0 then--只有金币收入
						local RRItemList = PIGA["GDKP"]["ItemList"]
						local fakuanDataX = PIGA["GDKP"]["fakuan"]
						for id=1,#self.DebtDataList do
							if self.DebtDataList[id][1]=="ItemList" then
								local itemdataC =RRItemList[self.DebtDataList[id][2]]
								if self.MoneyTV-itemdataC[14]>=0 then
									self.MoneyTV=self.MoneyTV-itemdataC[14]
									itemdataC[9]=itemdataC[9]+itemdataC[14]
									itemdataC[14]=0
								else
									itemdataC[9]=itemdataC[9]+self.MoneyTV
									itemdataC[14]=itemdataC[14]-self.MoneyTV
								end
							elseif self.DebtDataList[id][1]=="fakuan" then
								local itemdataC =fakuanDataX[self.DebtDataList[id][2]]
								if self.MoneyTV-itemdataC[4]>=0 then
									self.MoneyTV=self.MoneyTV-itemdataC[4]
									itemdataC[2]=itemdataC[2]+itemdataC[4]
									itemdataC[4]=0
								else
									itemdataC[2]=itemdataC[2]+self.MoneyTV
									itemdataC[4]=itemdataC[4]-self.MoneyTV
								end
							end
						end
						RaidR.Update_Item();
					end
				end
			end
			if Fun.IsErrTrade(arg2) then
				self.fenGModeV=nil
			end
		elseif event=="UI_ERROR_MESSAGE" then
			if Fun.IsErrTrade(arg2) then
				self.fenGModeV=nil
			end
		end
	end)
end