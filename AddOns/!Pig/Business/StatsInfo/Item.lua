local addonName, addonTable = ...;
local L=addonTable.locale
local fmod=math.fmod
local match = _G.string.match
--
local Create=addonTable.Create
local PIGLine=Create.PIGLine
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
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
local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
-----------
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.Item(StatsInfo)
	local BagdangeW=bagData.ItemWH-10
	local fujiF,fujiTabBut=PIGOptionsList_R(StatsInfo.F,"物\n品",StatsInfo.butW,"Left")
	---
	fujiF.List=PIGFrame(fujiF)
	fujiF.List:SetWidth(190)
	fujiF.List:PIGSetBackdrop(0)
	fujiF.List:SetPoint("TOPLEFT",fujiF,"TOPLEFT",0,0);
	fujiF.List:SetPoint("BOTTOMLEFT",fujiF,"BOTTOMLEFT",0,0);
	fujiF.SelectName=nil
	---
	local lixianNum,meihang=(#bagData["bankID"])*MAX_CONTAINER_ITEMS+bagData["bankmun"],20
	local hang_Height,hang_NUM  = StatsInfo.hang_Height-2.9, 14;
	local toptablist = {{"BANK","银行"},{"BAG","背包"},{"MAIL","邮箱"}}
	local function Show_ItemInfo()
		local ListBOT = {fujiF.ItemList.TOP:GetChildren()}
		for xvb=1, #ListBOT, 1 do
			ListBOT[xvb]:NotSelected()
		end
		ListBOT[fujiF.ItemSelect]:Selected()
		for i=1,lixianNum do
			local itemBut=fujiF.ItemList.BOTTOM.listbut[i]
			itemBut:Hide()
			itemBut.Num:Hide()
			itemBut.LV:SetText("");
		end
		if fujiF.SelectName then
			fujiF.ItemList.err:Hide()
			fujiF.ItemList.BOTTOM:Show()
			local lixiandata=PIGA["StatsInfo"]["Items"][fujiF.SelectName] and PIGA["StatsInfo"]["Items"][fujiF.SelectName][toptablist[fujiF.ItemSelect][1]] or {}
			for i=1,#lixiandata do
				local itemBut=fujiF.ItemList.BOTTOM.listbut[i]
				itemBut:Show()
				itemBut.Num:SetText(lixiandata[i][2])
				itemBut.itemID=lixiandata[i][3]
				Fun.HY_ShowItemLink(itemBut,lixiandata[i][3],lixiandata[i][1])
			end
		else
			fujiF.ItemList.err:Show()
			fujiF.ItemList.BOTTOM:Hide()
		end
	end
	fujiF.List.Scroll = CreateFrame("ScrollFrame",nil,fujiF.List, "FauxScrollFrameTemplate");  
	fujiF.List.Scroll:SetPoint("TOPLEFT",fujiF.List,"TOPLEFT",2,-2);
	fujiF.List.Scroll:SetPoint("BOTTOMRIGHT",fujiF.List,"BOTTOMRIGHT",-19,2);
	fujiF.List.Scroll.ScrollBar:SetScale(0.8)
	fujiF.List.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fujiF.Update_hang)
	end)
	fujiF.List.listbut={}
	for id = 1, hang_NUM, 1 do
		local hang = CreateFrame("Button", nil, fujiF.List);
		fujiF.List.listbut[id]=hang
		hang:SetSize(fujiF.List:GetWidth()-4,hang_Height*2+4);
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.List, "TOPLEFT", 0, 0);
		else
			hang:SetPoint("TOPLEFT", fujiF.List.listbut[id-1], "BOTTOMLEFT", 0, 0);
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
		hang.Faction:SetPoint("TOPLEFT", hang, "TOPLEFT", 3,-2);
		hang.Faction:SetSize(hang_Height,hang_Height);
		hang.Race = hang:CreateTexture();
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
		hang.name = PIGFontString(hang,{"TOPLEFT", hang.Faction, "BOTTOMLEFT", 0, -1},nil,"OUTLINE")
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
				local fujix = fujiF.List.listbut[v]
				fujix.highlight1:Hide();
				fujix.highlight:Hide();
			end
			self.highlight1:Show();
			Show_ItemInfo()
		end)
	end
	-------
	fujiF.ItemList=PIGFrame(fujiF)
	fujiF.ItemList:SetPoint("TOPLEFT",fujiF.List,"TOPRIGHT",0,0);
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
	fujiF.ItemList.BOTTOM.listbut={}
	for i=1,lixianNum do
		local itemBut
		if PIG_MaxTocversion(100000) then
			itemBut = CreateFrame("Button", nil, fujiF.ItemList.BOTTOM);
			itemBut:SetHighlightTexture(130718);
			itemBut.icon = itemBut:CreateTexture()
			itemBut.icon:SetAllPoints(itemBut)
		else
			itemBut = CreateFrame("ItemButton", nil, fujiF.ItemList.BOTTOM);
		end
		fujiF.ItemList.BOTTOM.listbut[i]=itemBut
		itemBut:SetSize(BagdangeW,BagdangeW);
		itemBut:Hide()
		if i==1 then
			itemBut:SetPoint("TOPLEFT",fujiF.ItemList.BOTTOM,"TOPLEFT",3,-4);
		else
			local yushu=fmod(i-1,meihang)
			if yushu==0 then
				itemBut:SetPoint("TOPLEFT",fujiF.ItemList.BOTTOM.listbut[i-meihang],"BOTTOMLEFT",0,-2);
			else
				itemBut:SetPoint("LEFT",fujiF.ItemList.BOTTOM.listbut[i-1],"RIGHT",1,0);
			end
		end
		itemBut.LV = PIGFontString(itemBut,{"TOPLEFT", itemBut, "TOPLEFT", 0,0},nil,"OUTLINE")
		itemBut.Num =PIGFontString(itemBut,{"BOTTOMRIGHT", itemBut, "BOTTOMRIGHT", -4,2},nil,"OUTLINE")
		itemBut.Num:SetTextColor(1, 1, 1, 1);
		function itemBut:ShowInfoFun(itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID)
			self.itemLink=itemLink
			SetItemButtonTexture(self, itemTexture)
			if itemStackCount>1 then itemBut.Num:Show() end
			if PIGA["BagBank"]["wupinLV"] then
				if classID==2 or classID==4 then
					local effectiveILvl = GetDetailedItemLevelInfo(itemLink)	
					if effectiveILvl and effectiveILvl>0 then
						self.LV:SetText(effectiveILvl)
						local quality = C_Item.GetItemQualityByID(itemLink)
						local r, g, b, hex = GetItemQualityColor(quality)
						self.LV:SetTextColor(r, g, b, 1);
					end
				end
			end
		end
		itemBut:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:SetHyperlink(self.itemLink)
			GameTooltip:Show();
		end);
		itemBut:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		itemBut:SetScript("OnMouseUp", function (self)
			if IsShiftKeyDown() then
				local editBox = ChatEdit_ChooseBoxForSend();
				local hasText = editBox:GetText()..self.itemLink
				if editBox:HasFocus() then
					editBox:SetText(hasText);
				else
					ChatEdit_ActivateChat(editBox)
					editBox:SetText(hasText);
				end
			end
		end)
	end
	----
	function StatsInfo:BagLixian()
		if self:IsShown() then
			self:Hide()
		else
			fujiF.SelectName=StatsInfo.allname
			self:Show()
			Create.Show_TabBut_R(self.F,fujiF,fujiTabBut)
			fujiF.Update_hang();
			fujiF.ItemSelect=1
			Show_ItemInfo()
		end
	end
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
		fujiF.Update_hang();
		Show_ItemInfo()
	end)
	function fujiF.Update_hang()
		if not fujiF:IsVisible() then return end
		for id = 1, hang_NUM, 1 do
			local fujik = fujiF.List.listbut[id]
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
			local ScrollUI=fujiF.List.Scroll
		    FauxScrollFrame_Update(ScrollUI, ItemsNum, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(ScrollUI);
		    for id = 1, hang_NUM do
				local dangqian = id+offset;
				if cdmulu[dangqian] then
					local fujik = fujiF.List.listbut[id]
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
					local className, classFile, classID = PIGGetClassInfo(cdmulu[dangqian][5])
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
		local itemID, itemLink, icon, stackCount=PIGGetContainerItemInfo(bagID, slot)
		if itemID then
			local XitemLink = GetItemLinkJJ(itemLink)
			table.insert(wupinshujuinfo, {XitemLink,stackCount,itemID});
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
		if BankFrame:IsShown() or NDui_BackpackBank and NDui_BackpackBank:IsShown() then
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
			local XitemLink = GetItemLinkJJ(itemLink)
			table.insert(wupinshujuinfo, {XitemLink,itemCount,itemID});
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
					local itemLink=GetInboxItemLink(i, n);
					if itemLink then
						local XitemLink = GetItemLinkJJ(itemLink)
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
	fujiF:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
	fujiF:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
	fujiF:RegisterEvent("MAIL_SHOW");
	if PIG_MaxTocversion(20000) then fujiF:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED") end
	fujiF:SetScript("OnEvent", function(self,event,arg1,arg2)
		if event == "MAIL_SHOW" then
			MailFrame_OnShow(self)
		elseif event == "ITEM_PUSH" or event == "MAIL_INBOX_UPDATE" then
			SAVE_MAIL()
		elseif event=="PLAYER_ENTERING_WORLD" then
			if arg1 or arg2 then
				C_Timer.After(2, function()
					SAVE_C()
					SAVE_BAG()
					self:RegisterEvent("BAG_UPDATE")
				end)
			end
		elseif event=="PLAYER_EQUIPMENT_CHANGED" or event=="PLAYER_TALENT_UPDATE" then
			SAVE_C()
		elseif event=="BAG_UPDATE" then
			if InCombatLockdown() then return end
			if arg1~=-2 then
				if arg1>=0 and arg1<=bagData["bagIDMax"] then
					SAVE_BAG()
				else
					SAVE_BANK()
				end
			end
		elseif event=="PLAYER_INTERACTION_MANAGER_FRAME_SHOW" and arg1==8 then
			SAVE_BANK()
		elseif event=="PLAYERBANKSLOTS_CHANGED" then
			SAVE_BANK()
		elseif event=="GUILDBANKBAGSLOTS_CHANGED" then
			SAVE_GUILDBANK()
		end
	end)
end
