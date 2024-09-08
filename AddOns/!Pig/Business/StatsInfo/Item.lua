local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local fmod=math.fmod
local match = _G.string.match
--
local Create=addonTable.Create
local PIGLine=Create.PIGLine
local PIGFrame=Create.PIGFrame
local PIGCloseBut = Create.PIGCloseBut
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGTabBut=Create.PIGTabBut
------

local Data=addonTable.Data
local TalentData=Data.TalentData
local InvSlot=Data.InvSlot
local bagData=Data.bagData
local Fun=addonTable.Fun
local lixian_chakan=Fun.lixian_chakan
local GetEquipmTXT=Fun.GetEquipmTXT
local GetRuneData=Fun.GetRuneData
local GetItemLinkJJ=Fun.GetItemLinkJJ
local HY_ItemLinkJJ=Fun.HY_ItemLinkJJ

--------
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemLink=C_Container.GetContainerItemLink
local GetItemInfo=GetItemInfo or C_Item and C_Item.GetItemInfo
-----------

local BusinessInfo=addonTable.BusinessInfo
local morenitem={["BAG"]={},["BANK"]={},["MAIL"]={},["C"]={},["T"]={},["G"]={},["R"]={},["GUILD"]={}}
local function zairumorenpeizhi(peizhiV)
	local NewpeizhiV=peizhiV or {}
	for k,v in pairs(morenitem) do
		NewpeizhiV[k]=NewpeizhiV[k] or v
	end
	return NewpeizhiV
end
function BusinessInfo.Item()
	local BagdangeW=bagData.ItemWH-10
	
	local StatsInfo = StatsInfo_UI
	PIGA["StatsInfo"]["Items"][StatsInfo.allname]=zairumorenpeizhi(PIGA["StatsInfo"]["Items"][StatsInfo.allname])
	local fujiF,fujiTabBut=PIGOptionsList_R(StatsInfo.F,"物\n品",StatsInfo.butW,"Left")
	---
	fujiF.PList=PIGFrame(fujiF)
	fujiF.PList:SetWidth(190)
	fujiF.PList:SetPoint("TOPLEFT",fujiF,"TOPLEFT",0,0);
	fujiF.PList:SetPoint("BOTTOMLEFT",fujiF,"BOTTOMLEFT",0,0);
	fujiF.PList.lineRR = PIGLine(fujiF.PList,"R")
	fujiF.SelectName=nil
	---
	local lixianNum,meihang=(#bagData["bankID"])*MAX_CONTAINER_ITEMS+bagData["bankmun"],20
	local hang_Height,hang_NUM  = 18, 12;
	local function gengxin_List(self)
		if not fujiF:IsVisible() then return end
		for id = 1, hang_NUM, 1 do
			local fujik = _G["PIG_ItemPList_"..id]
			fujik:Hide();
			fujik.highlight1:Hide();
			fujik.nameDQ:Hide()
		end
		local cdmulu={};
		local PlayerData = PIGA["StatsInfo"]["Players"]
		local PlayerSH = PIGA["StatsInfo"]["PlayerSH"]
		if PlayerData[StatsInfo.allname] and not PlayerSH[StatsInfo.allname] then
			local dangqianC=PlayerData[StatsInfo.allname]
			table.insert(cdmulu,{StatsInfo.allname,dangqianC[1],dangqianC[2],dangqianC[3],dangqianC[4],dangqianC[5],true})
		end
	   	for k,v in pairs(PlayerData) do
	   		if k~=StatsInfo.allname and PlayerData[k] and not PlayerSH[k] then
	   			table.insert(cdmulu,{k,v[1],v[2],v[3],v[4],v[5]})
	   		end
	   	end
	   	
		local ItemsNum = #cdmulu;
		if ItemsNum>0 then
		    FauxScrollFrame_Update(self, ItemsNum, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(self);
		    for id = 1, hang_NUM do
				local dangqian = id+offset;
				if cdmulu[dangqian] then
					local fujik = _G["PIG_ItemPList_"..id]
					fujik:Show();
					if cdmulu[dangqian][1]==StatsInfo.allname then
						fujik.guanchaC:Hide();
					else
						fujik.guanchaC:Show();
					end
					if fujiF.SelectName==cdmulu[dangqian][1] then
						fujik.highlight1:Show();
					end
					if cdmulu[dangqian][2]=="Alliance" then
						fujik.Faction:SetTexCoord(0,0.5,0,1);
					elseif cdmulu[dangqian][2]=="Horde" then
						fujik.Faction:SetTexCoord(0.5,1,0,1);
					end
					fujik.Race:SetAtlas(cdmulu[dangqian][4]);
					local className, classFile, classID = GetClassInfo(cdmulu[dangqian][5])
					fujik.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
					fujik.level:SetText(cdmulu[dangqian][6]);
					if cdmulu[dangqian][7] then
						fujik.nameDQ:Show()
					end
					fujik.name:SetText(cdmulu[dangqian][1]);
					fujik.allname=cdmulu[dangqian][1]
					local color = PIG_CLASS_COLORS[classFile];
					fujik.name:SetTextColor(color.r, color.g, color.b, 1);

				end
			end
		end
	end
	local toptablist = {{"BANK","银行"},{"BAG","背包"},{"MAIL","邮箱"}}
	local function Show_itemList(But,itemTexture,itemLink,itemStackCount,shuliang,classID)
		SetItemButtonTexture(But, itemTexture)
		But:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:SetHyperlink(itemLink)
			GameTooltip:Show();
		end);
		But:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		But:SetScript("OnMouseUp", function ()
			if IsShiftKeyDown() then
				local editBox = ChatEdit_ChooseBoxForSend();
				local hasText = editBox:GetText()..itemLink
				if editBox:HasFocus() then
					editBox:SetText(hasText);
				else
					ChatEdit_ActivateChat(editBox)
					editBox:SetText(hasText);
				end
			end
		end)
		if itemStackCount>1 then
			But.Num:SetText(shuliang)
		end
		if PIGA["BagBank"]["wupinLV"] then
			if classID==2 or classID==4 then
				local effectiveILvl = GetDetailedItemLevelInfo(itemLink)	
				if effectiveILvl and effectiveILvl>0 then
					But.LV:SetText(effectiveILvl)
					local quality = C_Item.GetItemQualityByID(itemLink)
					local r, g, b, hex = GetItemQualityColor(quality)
					But.LV:SetTextColor(r, g, b, 1);
				end
			end
		end
	end
	local function huancunwupinData(But,itemlin,shuliang)
		if itemlin then
			local Linktxt=HY_ItemLinkJJ(itemlin)
			local itemName,itemLink,itemQuality,itemLevel,itemMinLevel,itemType,itemSubType,itemStackCount,itemEquipLoc,itemTexture,sellPrice,classID=GetItemInfo(Linktxt);
			if itemLink then
				Show_itemList(But,itemTexture,itemLink,itemStackCount,shuliang,classID)
			else
				if But:IsVisible() and But.zhixingnum<5 then
					C_Timer.After(0.1,function()
						But.zhixingnum=But.zhixingnum+1
						huancunwupinData(But,itemlin,shuliang)
					end)
				end
			end
		end
	end
	local function Show_ItemInfo()
		local ListBOT = {fujiF.ItemList.TOP:GetChildren()}
		for xvb=1, #ListBOT, 1 do
			ListBOT[xvb]:NotSelected()
		end
		ListBOT[fujiF.ItemSelect]:Selected()
		for i=1,lixianNum do
			local itemBut=_G["lixian_Bag_item"..i]
			itemBut:Hide()
			itemBut.Num:SetText("")
			itemBut.LV:SetText("");
		end
		if fujiF.SelectName then
			fujiF.ItemList.err:Hide()
			fujiF.ItemList.BOTTOM:Show()
			local lixiandata=PIGA["StatsInfo"]["Items"][fujiF.SelectName][toptablist[fujiF.ItemSelect][1]] or {}
			for i=1,#lixiandata do
				local itemBut=_G["lixian_Bag_item"..i]
				itemBut:Show()
				itemBut.zhixingnum=0
				huancunwupinData(itemBut,lixiandata[i][1],lixiandata[i][2])
			end
		else
			fujiF.ItemList.err:Show()
			fujiF.ItemList.BOTTOM:Hide()
		end
	end
	fujiF.PList.Scroll = CreateFrame("ScrollFrame",nil,fujiF.PList, "FauxScrollFrameTemplate");  
	fujiF.PList.Scroll:SetPoint("TOPLEFT",fujiF.PList,"TOPLEFT",2,-2);
	fujiF.PList.Scroll:SetPoint("BOTTOMRIGHT",fujiF.PList,"BOTTOMRIGHT",-20,2);
	fujiF.PList.Scroll.ScrollBar:SetScale(0.8)
	fujiF.PList.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, gengxin_List)
	end)
	for id = 1, hang_NUM, 1 do
		local hang = CreateFrame("Button", "PIG_ItemPList_"..id, fujiF.PList);
		hang:SetSize(fujiF.PList:GetWidth()-4,hang_Height*2+4);
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.PList.Scroll, "TOPLEFT", 0, -2);
		else
			hang:SetPoint("TOPLEFT", _G["PIG_ItemPList_"..id-1], "BOTTOMLEFT", 0, -2);
		end
		if id~=hang_NUM then
			hang.line = PIGLine(hang,"BOT",0,nil,nil,{0.3,0.3,0.3,0.6})
		end
		hang.highlight = hang:CreateTexture();
		hang.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
		hang.highlight:SetBlendMode("ADD")
		hang.highlight:SetPoint("TOPLEFT", hang, "TOPLEFT", 0,0);
		hang.highlight:SetPoint("BOTTOMRIGHT", hang, "BOTTOMRIGHT", 0,0);
		hang.highlight:SetAlpha(0.4);
		hang.highlight:SetDrawLayer("BORDER", -2)
		hang.highlight:Hide();
		hang.highlight1 = hang:CreateTexture();
		hang.highlight1:SetTexture("interface/buttons/ui-listbox-highlight.blp");
		hang.highlight1:SetDrawLayer("BORDER", -1)
		hang.highlight1:SetPoint("TOPLEFT", hang, "TOPLEFT", 0,0);
		hang.highlight1:SetPoint("BOTTOMRIGHT", hang, "BOTTOMRIGHT", 0,0);
		hang.highlight1:SetAlpha(0.9);
		hang.highlight1:Hide();
		hang.Faction = hang:CreateTexture();
		hang.Faction:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
		hang.Faction:SetPoint("TOPLEFT", hang, "TOPLEFT", 0,-2);
		hang.Faction:SetSize(hang_Height,hang_Height);
		hang.Race = hang:CreateTexture();
		hang.Race:SetTexture("Interface/Glues/CharacterCreate/CharacterCreateIcons")
		hang.Race:SetPoint("LEFT", hang.Faction, "RIGHT", 1,0);
		hang.Race:SetSize(hang_Height,hang_Height);
		hang.Class = hang:CreateTexture();
		hang.Class:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
		hang.Class:SetPoint("LEFT", hang.Race, "RIGHT", 1,0);
		hang.Class:SetSize(hang_Height,hang_Height);
		hang.level = PIGFontString(hang,{"LEFT", hang.Class, "RIGHT", 2, 0},1,"OUTLINE")
		hang.level:SetTextColor(1,0.843,0, 1);
		hang.nameDQ = hang:CreateTexture();
		hang.nameDQ:SetTexture("interface/common/indicator-green.blp")
		hang.nameDQ:SetPoint("LEFT", hang.level, "RIGHT", 1,0);
		hang.nameDQ:SetSize(hang_Height+2,hang_Height+2);
		hang.guanchaC = CreateFrame("Button",nil, hang);
		hang.guanchaC:SetSize(hang_Height,hang_Height);
		hang.guanchaC:SetPoint("TOPRIGHT", hang, "TOPRIGHT", -15,-2);
		hang.guanchaC:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		hang.guanchaC.tex = hang.guanchaC:CreateTexture();
		hang.guanchaC.tex:SetTexture(133122)
		hang.guanchaC.tex:SetPoint("CENTER", hang.guanchaC, "CENTER", 0,0);
		hang.guanchaC.tex:SetSize(hang_Height,hang_Height);
		hang.guanchaC:HookScript("OnMouseDown", function (self)
			self.tex:SetPoint("CENTER", hang.guanchaC, "CENTER", 1.5,-1.5);
		end);
		hang.guanchaC:HookScript("OnMouseUp", function (self)
			self.tex:SetPoint("CENTER", hang.guanchaC, "CENTER", 0,0);
		end);
		hang.guanchaC:SetScript("OnClick", function (self)
			PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
			lixian_chakan(hang.allname,PIGA["StatsInfo"]["Players"][hang.allname],PIGA["StatsInfo"]["Items"][hang.allname])
		end)
		hang.name = PIGFontString(hang,{"TOPLEFT", hang.Faction, "BOTTOMLEFT", 0, -2},nil,"OUTLINE")
		hang:SetScript("OnEnter", function (self)
			if not self.highlight1:IsShown() then
				self.highlight:Show();
			end
		end);
		hang:SetScript("OnLeave", function (self)
			self.highlight:Hide();
		end);
		hang:SetScript("OnClick", function (self)
			PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
			fujiF.SelectName=hang.allname
			for v=1,hang_NUM do
				local fujix = _G["PIG_ItemPList_"..v]
				fujix.highlight1:Hide();
				fujix.highlight:Hide();
			end
			self.highlight1:Show();
			Show_ItemInfo()
		end)
	end
	-------
	fujiF.ItemList=PIGFrame(fujiF)
	fujiF.ItemList:SetPoint("TOPLEFT",fujiF.PList,"TOPRIGHT",0,0);
	fujiF.ItemList:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",0,0);
	fujiF.ItemList.err = PIGFontString(fujiF.ItemList,{"CENTER", 0,60},"请在左侧列表选择要查看角色","OUTLINE")
	fujiF.ItemList.err:SetTextColor(0, 1, 0, 1);
	fujiF.ItemList.TOP=PIGFrame(fujiF.ItemList)
	fujiF.ItemList.TOP:SetPoint("TOPLEFT",fujiF.ItemList,"TOPLEFT",0,0);
	fujiF.ItemList.TOP:SetPoint("TOPRIGHT",fujiF.ItemList,"TOPRIGHT",0,0);
	fujiF.ItemList.TOP:SetHeight(24)
	fujiF.ItemSelect=1
	for ibut=1,#toptablist do
		local TabBut = PIGTabBut(fujiF.ItemList.TOP,{"TOPLEFT",fujiF.ItemList.TOP,"TOPLEFT",20,-3},{60,22},toptablist[ibut][2])
		if ibut==1 then
			TabBut:Selected()
			TabBut:SetPoint("TOPLEFT",fujiF.ItemList.TOP,"TOPLEFT",20,-3);
		else
			TabBut:SetPoint("TOPLEFT",fujiF.ItemList.TOP,"TOPLEFT",20+(ibut*80-80),-3);
		end
		TabBut:HookScript("OnClick", function(self)
			fujiF.ItemSelect=ibut
			Show_ItemInfo()
		end)
	end
	fujiF.ItemList.BOTTOM=PIGFrame(fujiF.ItemList)
	fujiF.ItemList.BOTTOM:SetPoint("TOPLEFT",fujiF.ItemList.TOP,"BOTTOMLEFT",2,0);
	fujiF.ItemList.BOTTOM:SetPoint("BOTTOMRIGHT",fujiF.ItemList,"BOTTOMRIGHT",-3,3);
	fujiF.ItemList.BOTTOM:PIGSetBackdrop(0)
	-- 
	for i=1,lixianNum do
		local itemBut
		if tocversion<100000 then
			itemBut = CreateFrame("Button", "lixian_Bag_item"..i, fujiF.ItemList.BOTTOM);
			itemBut:SetHighlightTexture(130718);
			itemBut.icon = itemBut:CreateTexture()
			itemBut.icon:SetAllPoints(itemBut)
		else
			itemBut = CreateFrame("ItemButton", "lixian_Bag_item"..i, fujiF.ItemList.BOTTOM);
		end
		itemBut:SetSize(BagdangeW,BagdangeW);
		itemBut:Hide()
		if i==1 then
			itemBut:SetPoint("TOPLEFT",fujiF.ItemList.BOTTOM,"TOPLEFT",3,-4);
		else
			local yushu=fmod(i-1,meihang)
			if yushu==0 then
				itemBut:SetPoint("TOPLEFT",_G["lixian_Bag_item"..(i-meihang)],"BOTTOMLEFT",0,-2);
			else
				itemBut:SetPoint("LEFT",_G["lixian_Bag_item"..(i-1)],"RIGHT",1,0);
			end
		end
		itemBut.LV = PIGFontString(itemBut,{"TOPLEFT", itemBut, "TOPLEFT", 0,0},nil,"OUTLINE")
		itemBut.Num =PIGFontString(itemBut,{"BOTTOMRIGHT", itemBut, "BOTTOMRIGHT", -4,2},nil,"OUTLINE")
		itemBut.Num:SetTextColor(1, 1, 1, 1);
	end
	--
	fujiF:HookScript("OnShow", function(self)
		local ListBOT = {fujiF.ItemList.TOP:GetChildren()}
		for xvbb=1, #ListBOT, 1 do
			if xvbb==1 then
				ListBOT[xvbb]:Selected()
				fujiF.ItemSelect=1
			else
				ListBOT[xvbb]:NotSelected()
			end
		end
		gengxin_List(self.PList.Scroll);
		Show_ItemInfo()
	end)
	----
	function StatsInfo:BagLixian()
		if self:IsShown() then
			self:Hide()
		else
			fujiF.SelectName=StatsInfo.allname
			self:Show()
			Create.Show_TabBut_R(self.F,fujiF,fujiTabBut)
			gengxin_List(fujiF.PList.Scroll);
			fujiF.ItemSelect=1
			Show_ItemInfo()
		end
	end
	--------------
	local function SAVE_C()
		if InCombatLockdown() then return end
		PIGA["StatsInfo"]["Items"][StatsInfo.allname]["C"] = GetEquipmTXT()
		PIGA["StatsInfo"]["Items"][StatsInfo.allname]["T"] = TalentData.GetTianfuTXT()
		PIGA["StatsInfo"]["Items"][StatsInfo.allname]["G"] = TalentData.GetGlyphTXT()
		PIGA["StatsInfo"]["Items"][StatsInfo.allname]["R"] = GetRuneData()
	end
	local function SAVE_item_data(bagID, slot,wupinshujuinfo)
		local XitemLink,XitemCount,XitemID
		local ItemInfo= C_Container.GetContainerItemInfo(bagID, slot);
		if ItemInfo then
			XitemLink=ItemInfo.hyperlink
			XitemCount=ItemInfo.stackCount
			XitemID=ItemInfo.itemID
			local XitemLink = GetItemLinkJJ(XitemLink)
			table.insert(wupinshujuinfo, {XitemLink,XitemCount,XitemID});
		end
	end
	local function SAVE_BAG()
		if InCombatLockdown() then return end
		local wupinshujuinfo = {}
		for bag=1,#bagData["bagID"] do
			for slot=1,GetContainerNumSlots(bagData["bagID"][bag]) do
				SAVE_item_data(bagData["bagID"][bag], slot, wupinshujuinfo)
			end
		end
		PIGA["StatsInfo"]["Items"][StatsInfo.allname]["BAG"] = wupinshujuinfo
	end
	local function SAVE_BANK()
		if InCombatLockdown() then return end
		if BankFrame:IsShown() then
			local wupinshujuinfo = {}
			local BANKgezishu=0
			for f=1,#bagData["bankID"] do
				if f==1 then
					BANKgezishu=bagData["bankmun"]
				else
					BANKgezishu=GetContainerNumSlots(bagData["bankID"][f])
				end
				for slot=1,BANKgezishu do
					SAVE_item_data(bagData["bankID"][f], slot,wupinshujuinfo)
				end
			end
			PIGA["StatsInfo"]["Items"][StatsInfo.allname]["BANK"] = wupinshujuinfo
		end
	end
	local function SAVE_GUILDBANK_item_data(bagID, slot,wupinshujuinfo)
		local itemLink = GetGuildBankItemLink(bagID, slot)
		if itemLink then
			local texture, itemCount= GetGuildBankItemInfo(bagID, slot)
			local itemID = GetItemInfoInstant(itemLink) 
			local itemLink = itemLink:match("\124H(item:[%-0-9:]+)\124h");
			table.insert(wupinshujuinfo, {itemLink,itemCount,itemID});
		end
	end
	local function SAVE_GUILDBANK()
		if InCombatLockdown() then return end
		if GuildBankFrame and GuildBankFrame:IsShown() then
			local wupinshujuinfo = {}
			for i=1,6 do
				local name, icon, isViewable = GetGuildBankTabInfo(i)
				if isViewable then
					for slot=1,98 do
						SAVE_GUILDBANK_item_data(i,slot,wupinshujuinfo)
					end
				end
			end
			PIGA["StatsInfo"]["Items"][StatsInfo.allname]["GUILD"] = wupinshujuinfo
		end
	end
	local function SAVE_MAIL()
		local mailData = {}
		for i=1, GetInboxNumItems() do
			local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, itemCount, wasRead, wasReturned, textCreated, canReply, isGM = GetInboxHeaderInfo(i);
			if (itemCount and CODAmount == 0) then
				for n=1,ATTACHMENTS_MAX_RECEIVE do
					local ItemLink=GetInboxItemLink(i, n);
					if ItemLink then
						local XitemLink = ItemLink:match("\124H(item:[%-0-9:]+)\124h");
						local name, XitemID, itemTexture, count, quality, canUse = GetInboxItem(i, n);				
						table.insert(mailData, {XitemLink,count,XitemID});
					end
				end
			end
		end
		PIGA["StatsInfo"]["Items"][StatsInfo.allname]["MAIL"]=mailData
	end
	function MailFrame_OnShow(self)
		self:RegisterEvent("MAIL_INBOX_UPDATE");
		self:RegisterEvent("ITEM_PUSH");
		SAVE_MAIL()
	end
	MailFrame:HookScript("OnHide", function(self,event,arg1,arg2)
		fujiF:UnregisterEvent("MAIL_INBOX_UPDATE");
		fujiF:UnregisterEvent("ITEM_PUSH");
	end)
	----
	fujiF:RegisterEvent("PLAYER_ENTERING_WORLD")
	fujiF:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	fujiF:RegisterEvent("PLAYER_TALENT_UPDATE")
	fujiF:RegisterEvent("BANKFRAME_OPENED")
	fujiF:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
	fujiF:RegisterEvent("MAIL_SHOW");
	if tocversion>20000 then fujiF:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED") end
	fujiF:SetScript("OnEvent", function(self,event,arg1,arg2)
		--print(event,arg1,arg2)
		if event == "MAIL_SHOW" then
			MailFrame_OnShow(self)
		end
		if event == "ITEM_PUSH" or event == "MAIL_INBOX_UPDATE" then
			SAVE_MAIL()
		end
		if event=="PLAYER_ENTERING_WORLD" then
			if arg1 or arg2 then
				--print("加载UI")
				C_Timer.After(3, function()
					SAVE_C()
					SAVE_BAG()
					self:RegisterEvent("BAG_UPDATE")
				end)
			else
				--print("进出副本")
			end
		end
		if event=="PLAYER_EQUIPMENT_CHANGED" or event=="PLAYER_TALENT_UPDATE" then
			SAVE_C()
		end
		if event=="BAG_UPDATE" then
			if arg1~=-2 then
				if arg1>=0 and arg1<=bagData["bagIDMax"] then
					SAVE_BAG()
				else
					SAVE_BANK()
				end
			end
		end
		if event=="BANKFRAME_OPENED" then
			SAVE_BANK()
		end
		if event=="PLAYERBANKSLOTS_CHANGED" then
			SAVE_BANK()
		end
		if event=="GUILDBANKBAGSLOTS_CHANGED" then
			SAVE_GUILDBANK()
		end
	end)
end
