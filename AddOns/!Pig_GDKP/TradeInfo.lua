local addonName, addonTable = ...;
local GDKPInfo=addonTable.GDKPInfo
function GDKPInfo.ADD_Trade(RaidR)
	local Create, Data, Fun, L, Default, Default_Per= unpack(PIG)
	local PIGFrame=Create.PIGFrame
	local PIGLine=Create.PIGLine
	local PIGButton = Create.PIGButton
	local PIGFontString=Create.PIGFontString
	local PIGSetFont=Create.PIGSetFont
	-------
	local WidthF,D_Height,D_hangNUM = 260,18,10
	local PIGTradeF = PIGFrame(TradeFrame,{"TOPLEFT",TradeFrame,"TOPRIGHT",-3,0});
	RaidR.PIGTradeF=PIGTradeF
	PIGTradeF:SetPoint("BOTTOMLEFT",TradeFrame,"BOTTOMLEFT",-3,0);
	PIGTradeF:SetWidth(WidthF); 
	PIGTradeF:PIGSetBackdrop(nil,nil,nil,nil,0)
	PIGTradeF:SetFrameStrata("HIGH")
	PIGTradeF:SetFrameLevel(9)
	PIGTradeF:Hide()
	PIGTradeF.cancel = PIGButton(PIGTradeF,{"BOTTOM",PIGTradeF,"BOTTOM",0,20},{100,24},"不记录本次",nil,nil,nil,nil,0);
	PIGTradeF.cancel:HookScript("OnClick",function (self)
		PIGTradeF.Isjilu=false
		PIGTradeF:Hide()
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
		hang.ItemName = PIGFontString(hang,{"LEFT", hang, "LEFT", 0,0},"sdfsdfsdfsdfds");
		hang.ItemName:SetWidth(WidthF-100);
		hang.ItemName:SetJustifyH("LEFT")
		hang.qianV = PIGFontString(hang,{"RIGHT", hang, "RIGHT", -D_Height-14,0},0);
		hang.qianV:SetTextColor(0.8, 0.2, 0, 1);
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
	TradeFrame.ShowDebtUI = PIGButton(TradeFrame,{"TOPRIGHT",TradeFrame,"TOPRIGHT",-8,-26},{50,24},"清账",nil,nil,nil,nil,0);
	TradeFrame.ShowDebtUI:HookScript("OnClick",function (self)
		self:Hide()
		PIGTradeF:Show()
	end)
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
		if ly==1 then--记账
			self:SetListhangText("成交记账","成交人:","","记账/G","",false,false)
			self.ListF.benciT:SetText("交易完后/G: ")
			local Itemsnum = #self.linItems
			for id=1,Itemsnum do
				local hang=self.ListF.butlist[id]
				hang:Show();
				if self.linItems[id][2]>1 then
					hang.ItemName:SetText(self.linItems[id][1].."×"..self.linItems[id][2])
				else
					hang.ItemName:SetText(self.linItems[id][1])
				end
				hang.qianV:SetText(self.MoneyTV/Itemsnum)
			end
			self:Show()
		elseif ly==2 then--清账
			self:SetListhangText("欠款记账","欠款人:","选择欠款人","欠款/G","清账",true,true)	
			wipe(self.DebtbenciG)
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
			if self:GetItemsDebt(self.PlayerName) then
				self.DkPlayer:SetText(self.PlayerName.."(工资"..(PIGTradeF.fenGModeV*0.0001)..")")
				self.DebtbenciG.qianG=0
				self.DebtbenciG.benciG=self.MoneyPV
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
				self.ListF.benciT:SetText("扣除欠款实发/G: ")
				local shifaV=PIGTradeF.fenGModeV-self.DebtbenciG.qianG*10000
				if shifaV>=0 then
					self.ListF.benciG:SetText(shifaV*0.0001)
					--MoneyInputFrame_SetCopper(TradePlayerInputMoneyFrame, shifaV);
				else
					self.ListF.benciG:SetText("|cffFF0000"..(shifaV*0.0001).."资不抵债|r")
				end
				self:Show()
			else
				--MoneyInputFrame_SetCopper(TradePlayerInputMoneyFrame, PIGTradeF.fenGModeV);
			end
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
	PIGTradeF.jishu=0
	PIGTradeF:HookScript("OnEvent",function (self,event,arg1,arg2,arg3,arg4,arg5)
		if not PIGA["GDKP"]["Rsetting"]["jiaoyijilu"] then return end
		if event=="TRADE_CLOSED" then
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
		elseif event=="TRADE_MONEY_CHANGED" or event=="TRADE_PLAYER_ITEM_CHANGED" or event=="PLAYER_TRADE_MONEY" then
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
				if self.fenGModeV then
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