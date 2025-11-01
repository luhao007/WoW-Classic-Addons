local addonName, addonTable = ...;
local L=addonTable.locale
local match = _G.string.match
local Create=addonTable.Create
local PIGEnter=Create.PIGEnter
local PIGFontString=Create.PIGFontString
--====================================
local InvSlot=addonTable.Data.InvSlot
local bagData=addonTable.Data.bagData
local BagBankfun=addonTable.BagBankfun
----
local wwc,hhc = 24,24
local BagdangeW=bagData.ItemWH
------
local Bag_Item_lv=BagBankfun.Bag_Item_lv
local Bank_Item_lv=BagBankfun.Bank_Item_lv
--================
function BagBankfun.Zhenghe(Rneirong,tabbut)
	if not PIGA["BagBank"]["Zhenghe"] or BagBankfun.yizhixingjiazai then return end
	BagBankfun.yizhixingjiazai=true
	--交易打开
	hooksecurefunc("TradeFrame_OnShow", function(self)
		if PIGA["BagBank"]["jiaoyiOpen"] then
			if(UnitExists("NPC"))then OpenAllBags() end
		end
	end);
	if ContainerFrameCombinedBags:IsShown() then CloseAllBags() end
	if GetCVar("combinedBags")=="0" then SetCVar("combinedBags","1") end
	ContainerFrameCombinedBags.meihang=PIGA["BagBank"]["BAGmeihangshu"]+BagBankfun.BAGmeihangshu
	ContainerFrameCombinedBags.suofang=PIGA["BagBank"]["BAGsuofangBili"]
	hooksecurefunc(ContainerFrameCombinedBags, "UpdateItems", function()	
		for i, itemButton in ContainerFrameCombinedBags:EnumerateValidItems() do
			BagBankfun.add_Itemslot_ZLV_ranse(itemButton,BagdangeW)--背包/银行包裹格子
			if PIGA["BagBank"]["JunkShow"] then
				local bagID = itemButton:GetBagID();
				local itemID, itemLink, icon, stackCount, quality=PIGGetContainerItemInfo(bagID, itemButton:GetID())
				itemButton.JunkIcon:Hide();
				if quality and quality==0 then
					itemButton.JunkIcon:Show();
				end
			end
		end
	end)
	function ContainerFrameCombinedBags:GetColumns()
		if self:IsCombinedBagContainer() then
			return self.meihang
		else
			return 4;
		end
	end
	--缩放
	hooksecurefunc("ContainerFrame_GenerateFrame", function(frame, size, id)
		ContainerFrameCombinedBags:SetScale(ContainerFrameCombinedBags.suofang)
	end)
	--调整系统整合背包搜索框
	hooksecurefunc(ContainerFrameCombinedBags, "SetSearchBoxPoint", function()
		BagItemSearchBox:SetWidth(160);
		BagItemSearchBox:SetPoint("TOPLEFT",ContainerFrameCombinedBags,"TOPLEFT",40,-37);
	end)
	---
	ContainerFrameCombinedBags.EqBut =BagBankfun.addEquipmentbut(ContainerFrameCombinedBags,{"TOPRIGHT",ContainerFrameCombinedBags,"TOPRIGHT",-52,-37})
	--
	ContainerFrameCombinedBags.Setings = BagBankfun.addSetbut(ContainerFrameCombinedBags,{"TOPRIGHT",ContainerFrameCombinedBags,"TOPRIGHT",-86,-38},Rneirong,tabbut)
	---
	ContainerFrameCombinedBags:RegisterEvent("AUCTION_HOUSE_SHOW")
	ContainerFrameCombinedBags:HookScript("OnEvent", function(self,event,arg1)
		if event=="AUCTION_HOUSE_SHOW" then
			if PIGA["BagBank"]["AHOpen"] then
				if (UnitExists("NPC")) then
					OpenAllBags()
				end
			end
		elseif event=="BAG_UPDATE" then
			if arg1>bagData["bagIDMax"] then
				if BankFrame:IsVisible() then
					Bag_Item_lv(nil, nil, arg1)
				end
			else
				if self:IsVisible() then
					Bag_Item_lv(ContainerFrameCombinedBags, nil, arg1)
				end
			end
		end
	end)

	hooksecurefunc("ContainerFrame_GenerateFrame", function(frame, size, id)
		if id<=bagData["bagIDMax"] then
			Bag_Item_lv(frame, size, id)
		end
	end)

	---系统银行========================
	BankPanel.AutoDepositFrame:SetWidth(190)
	BankPanel.AutoDepositFrame:SetPoint("BOTTOM", BankPanel.NineSlice, "BOTTOM", -258, 10);
	BankPanel.AutoDepositFrame.DepositButton:SetAllPoints(BankPanel.AutoDepositFrame)
	--处理Tab
	BankFrame.TabSystem:ClearAllPoints();
	BankFrame.TabSystem:SetPoint("BOTTOMRIGHT",BankFrame,"TOPRIGHT",-50,-2);
	local tabs=BankFrame.TabSystem.tabs
	local function PIG_SetTabSelct(tabID)
		for id=1,#tabs do
			tabs[id].Text:SetPoint("CENTER", tabs[id], "CENTER", 0, -4);
		end
		tabs[tabID].Text:SetPoint("CENTER", tabs[tabID], "CENTER", 0, 0);
	end
	local function UpdateTabInfo(id)
		local tab=tabs[id]
		tab.LeftActive:ClearAllPoints();
		tab.LeftActive:SetPoint("BOTTOMLEFT",tab,"BOTTOMLEFT",-6,-6);
		tab.LeftActive:SetAtlas("uiframe-activetab-right")
		tab.LeftActive:SetRotation(math.rad(180), {x=0.5, y=0.5})
		tab.MiddleActive:SetRotation(math.rad(180), {x=0.5, y=0.5})
		tab.RightActive:ClearAllPoints();
		tab.RightActive:SetPoint("BOTTOMRIGHT",tab,"BOTTOMRIGHT",0,-6);
		tab.RightActive:SetAtlas("uiframe-activetab-left")
		tab.RightActive:SetRotation(math.rad(180), {x=0.5, y=0.5})
		
		tab.Left:ClearAllPoints();
		tab.Left:SetPoint("BOTTOMLEFT",tab,"BOTTOMLEFT",-6,-3);
		tab.Left:SetAtlas("uiframe-tab-right")
		tab.Left:SetRotation(math.rad(180), {x=0.5, y=0.5})
		tab.Middle:SetRotation(math.rad(180), {x=0.5, y=0.5})
		tab.Right:ClearAllPoints();
		tab.Right:SetPoint("BOTTOMRIGHT",tab,"BOTTOMRIGHT",0,-3);
		tab.Right:SetAtlas("uiframe-tab-left")
		tab.Right:SetRotation(math.rad(180), {x=0.5, y=0.5})

		tab.LeftHighlight:SetAtlas("uiframe-tab-right")
		tab.LeftHighlight:SetRotation(math.rad(180), {x=0.5, y=0.5})
		tab.MiddleHighlight:SetRotation(math.rad(180), {x=0.5, y=0.5})
		tab.RightHighlight:SetAtlas("uiframe-tab-left")
		tab.RightHighlight:SetRotation(math.rad(180), {x=0.5, y=0.5})
		tab:HookScript("OnClick", function(self)
			PIG_SetTabSelct(id)
		end);
	end
	for id=1,#tabs do		
		UpdateTabInfo(id)
	end
	hooksecurefunc(BankFrame, "SetTab", function(self,tabID)
		PIG_SetTabSelct(tabID)
	end)
	--染色等级
	local function _zUpdateItems()
		for itemButton in BankPanel:EnumerateValidItems() do
			BagBankfun.add_Itemslot_ZLV_ranse(itemButton,BagdangeW)--银行格子
			Bank_Item_lv("retail",itemButton)
		end
	end
	hooksecurefunc(BankPanel, "GenerateItemSlotsForSelectedTab", function()
		_zUpdateItems()
	end)
	BankFrame:RegisterEvent("BAG_UPDATE_DELAYED")
	BankFrame:HookScript("OnEvent", function (self,event,arg1)
		if event=="BAG_UPDATE_DELAYED" then
			_zUpdateItems()
		end
	end)
end