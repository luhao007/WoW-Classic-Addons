local _, addonTable = ...;
local L=addonTable.locale
local Data=addonTable.Data
local Quality = Data.Quality
--
local Fun=addonTable.Fun

local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGDiyBut=Create.PIGDiyBut
local PIGLine=Create.PIGLine
local PIGModbutton=Create.PIGModbutton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
--
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local IsUsableItem=IsUsableItem or C_Item and C_Item.IsUsableItem
local bagIDMax= addonTable.Data.bagData["bagIDMax"]
---
local BusinessInfo=addonTable.BusinessInfo
local GnName,GnUI,GnIcon,FrameLevel = unpack(BusinessInfo.AutoSellBuyData)
local Width,Height,biaotiH  = 300, 550, 21;
--父框架
function BusinessInfo.AutoSellBuy_ADDUI()
	if not PIGA["AutoSellBuy"]["Open"] then return end
	if _G[GnUI] then return end	
	PIGModbutton(GnName,GnIcon,GnUI,FrameLevel)

	local SellBuy=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,100},{Width, Height},GnUI,true)
	SellBuy:PIGSetBackdrop()
	SellBuy:PIGClose()
	SellBuy:PIGSetMovable()
	SellBuy:SetFrameLevel(FrameLevel)
	--标题
	SellBuy.biaoti = PIGFontString(SellBuy,{"TOP", SellBuy, "TOP", 0, -4},GnName)
	PIGLine(SellBuy,"TOP",-biaotiH)
	--内容显示
	SellBuy.F=PIGOptionsList_RF(SellBuy,biaotiH,"Left")
	--
	BusinessInfo.AutoSell()
	BusinessInfo.AutoBuy()
	BusinessInfo.FastDrop()
	BusinessInfo.FastOpen()
	BusinessInfo.FastFen()
	BusinessInfo.FastXuan()
	BusinessInfo.FastSave()
end
function BusinessInfo.ADDScroll(fuFrame,text,hangName,hang_NUM,Config1)
	local Config0
	if hangName=="Buy" or hangName=="Save" or hangName=="Take" then
		Config0=PIGA_Per["AutoSellBuy"][hangName.."_List"]
	else
		Config0=PIGA["AutoSellBuy"][hangName.."_List"]
	end
	local FiltraConfig0 = PIGA["AutoSellBuy"][hangName.."_Lsit_Filtra"]
	local Width,hang_Height,addBag_hang_NUM = fuFrame:GetWidth()-12,24,19

	local function IsItemExist(Conf,idx)
		for ix=1,#Conf do
			if idx==Conf[ix][1] then
				return true
			end
		end
		return false
	end
	local function InsertItemData(itemID,itemLink,itemTexture,itemStackCount,ly)
		local itemLink=Fun.GetItemLinkJJ(itemLink)
		if fuFrame.List.addList.lx=="filtra" and ly~="Cursor" then
			if IsItemExist(FiltraConfig0,itemID) then
				PIG_OptionsUI:ErrorMsg("物品已在排除列表","R");
				return false
			end
			table.insert(FiltraConfig0,1,{itemID,itemLink,itemTexture,itemStackCount,itemStackCount,false})
		else
			if IsItemExist(Config0,itemID) then
				PIG_OptionsUI:ErrorMsg("物品已在"..text.."列表","R");
				return false
			end
			table.insert(Config0,1,{itemID,itemLink,itemTexture,itemStackCount,itemStackCount,false})
		end
		fuFrame.UpdateListHang()
		fuFrame.UpdateListHang_addBag()
	end
	local function IsItemMay(add,itemLink,quality,sellPrice,classID,subclassID,bag,slot)
		if hangName=="Sell" then
			if sellPrice and sellPrice>0 then
				if bag=="Cursor" then return true end	
				if fuFrame.List.addList.lx=="filtra" then
					if quality>0 then
						return false, "排除列表只支持灰色物品"
					else
						return true
					end
				else
					return true
				end				
			else
				return false,"物品无法售卖"
			end
		elseif hangName=="Buy" then
			if add then
				return true
			else
				if classID==0 or classID==5 or classID==6 or classID==7 or classID==15 then
					return true
				else
					return false,"非消费品"
				end
			end
		elseif hangName=="Diuqi" then
			if add then
				return true
			else
				if quality<3 then
					return true
				else
					return false,"高品质物品"
				end
			end
		elseif hangName=="Open" then
			if add then
				return true
			else
				local lootable = bag and slot and select(7, PIGGetContainerItemInfo(bag,slot))
				local usable, noMana = IsUsableItem(itemLink)
				if usable or lootable then
					return true
				else
					return false,"物品无法开启/使用"
				end
			end
		elseif hangName=="Fen" then
			if quality>1 and classID==2 or classID==4 then
				return true
			else
				return false,"物品无法分解"
			end
		elseif hangName=="Xuan" then
			if quality>0 and classID==7 and subclassID==7 then
				return true
			else
				return false,"物品无法选矿"
			end
		else
			return true
		end
	end
	--------
	fuFrame.List = PIGFrame(fuFrame,{"BOTTOM", fuFrame, "BOTTOM", 0, 6},{Width, hang_Height*hang_NUM+6})
	fuFrame.List:PIGSetBackdrop()
	fuFrame.List.chu = PIGButton(fuFrame,{"BOTTOMLEFT",fuFrame.List,"TOPLEFT",0,4},{44,20},"导出");
	fuFrame.List.chu:SetScript("OnClick", function(self)
		Fun.Config_CHU(self,Config0)
	end)
	fuFrame.List.ru = PIGButton(fuFrame,{"LEFT",fuFrame.List.chu,"RIGHT",4,0},{44,20},"导入");
	fuFrame.List.ru:SetScript("OnClick", function(self)
		Fun.Config_RU(self,Config1)
	end)
	fuFrame.List.biaoti = PIGFontString(fuFrame.List,{"BOTTOM", fuFrame.List, "TOP", 0, 6},"\124cff00FF00↓"..text.."列表↓\124r")
	fuFrame.List.addBag = PIGButton(fuFrame,{"BOTTOMRIGHT",fuFrame.List,"TOPRIGHT",0,4},{44,20},"添加");
	fuFrame.List.addBag:HookScript("OnClick",  function (self)
		fuFrame.addList_ShowFun("addBag","添加背包物品")
	end)
	fuFrame.List.Clearbut = PIGButton(fuFrame.List,{"RIGHT",fuFrame.List.addBag,"LEFT",-4,0},{44,20},"清空")
	fuFrame.List.Clearbut:SetScript("OnClick", function (self)
		if self.F:IsShown() then
			self.F:Hide()
		else
			self.F:Show()
		end	
	end);
	fuFrame.List.Clearbut.F=PIGFrame(fuFrame,{"TOP",fuFrame,"TOP",0,-60},{Width-20,160})
	fuFrame.List.Clearbut.F:PIGSetBackdrop(1)
	fuFrame.List.Clearbut.F:SetFrameLevel(fuFrame.List.Clearbut:GetFrameLevel()+10)
	fuFrame.List.Clearbut.F:Hide()
	fuFrame.List.Clearbut.F.biaoti = PIGFontString(fuFrame.List.Clearbut.F,{"TOP", fuFrame.List.Clearbut.F, "TOP", 0, -30},"确定清空\124cff00FF00↓"..text.."列表↓\124r吗?")
	fuFrame.List.Clearbut.F.yes = PIGButton(fuFrame.List.Clearbut.F,{"TOP", fuFrame.List.Clearbut.F, "TOP", -60, -100},{60,24},"确定")
	fuFrame.List.Clearbut.F.yes:SetScript("OnClick", function (self)
		for ivv=#Config0,1,-1 do
			table.remove(Config0, ivv);
		end
		fuFrame.UpdateListHang()
		fuFrame.UpdateListHang_addBag()
		fuFrame.List.Clearbut.F:Hide()
	end);
	fuFrame.List.Clearbut.F.no = PIGButton(fuFrame.List.Clearbut.F,{"TOP", fuFrame.List.Clearbut.F, "TOP", 60, -100},{60,24},"取消")
	fuFrame.List.Clearbut.F.no:SetScript("OnClick", function (self)
		fuFrame.List.Clearbut.F:Hide()
	end);
		
	if hangName=="Sell" then
		fuFrame.List.filtra = PIGButton(fuFrame.List,{"BOTTOMRIGHT",fuFrame.List.addBag,"TOPRIGHT",0,4},{44,20},"排除")
		fuFrame.List.filtra:SetScript("OnClick", function (self)
			fuFrame.addList_ShowFun("filtra","卖出排除物品")
		end);
	end

	fuFrame.List.addList = PIGFrame(fuFrame.List,{"TOPLEFT", fuFrame, "TOPRIGHT", 2, biaotiH})
	fuFrame.List.addList:SetPoint("BOTTOMRIGHT", fuFrame, "BOTTOMRIGHT", Width, 0);
	fuFrame.List.addList:PIGSetBackdrop()
	fuFrame.List.addList:PIGClose()
	fuFrame.List.addList:Hide()
	fuFrame:HookScript("OnHide", function(self)
		self.List.addList:Hide()
	end)
	fuFrame.List.addList.biaoti = PIGFontString(fuFrame.List.addList,{"TOP", fuFrame.List.addList, "TOP", 0, -4})
	PIGLine(fuFrame.List.addList,"TOP",-biaotiH)
	---
	fuFrame.List.addList.filtraTips = PIGFontString(fuFrame.List.addList,{"TOP", fuFrame.List.addList, "TOP", 0, -28},"下方列表|c"..Quality[0]["HEX"].."灰色|r物品将不会被自动卖出")
	fuFrame.List.addList.filtraTips:SetTextColor(0, 1, 0, 1); 
	fuFrame.List.addList.ButList={}
	local QualityMinMax = {1,4}
	if hangName=="Diuqi" then
		QualityMinMax[1],QualityMinMax[2]=0,2
	elseif hangName=="Fen" then
		QualityMinMax[1],QualityMinMax[2]=2,4
	end
	for i=QualityMinMax[1],QualityMinMax[2] do
		local text ={Quality[i]["Name"],nil}
		local Checkbut =PIGCheckbutton(fuFrame.List.addList,nil,text)
		fuFrame.List.addList.ButList[i]=Checkbut
		fuFrame.List.addList.ButList[i].Check=true	
		if i==QualityMinMax[1] then
			Checkbut:SetPoint("TOPLEFT", fuFrame.List.addList, "TOPLEFT", 6, -26);
		else
			Checkbut:SetPoint("LEFT", fuFrame.List.addList.ButList[i-1], "RIGHT", 50, 0);
		end
		Checkbut:SetChecked(true)
		Checkbut:SetScript("OnClick", function (self)
			if self:GetChecked() then
				fuFrame.List.addList.ButList[i].Check=true
			else
				fuFrame.List.addList.ButList[i].Check=false
			end
			fuFrame.UpdateListHang_addBag()
		end);
	end
	fuFrame.List.addList.addall = PIGButton(fuFrame.List.addList,{"TOPLEFT", fuFrame.List.addList, "TOPLEFT", 6, -52},{80,22});
	fuFrame.List.addList.addall:SetScript("OnClick", function()
		if fuFrame.List.addList.lx=="filtra" then
			local FiltraConfig = PIGA["AutoSellBuy"][hangName.."_Lsit_Filtra"]
			for ivv=#FiltraConfig,1,-1 do
				table.remove(FiltraConfig, ivv);
			end
		else
			local bagshujuy =fuFrame.addItemData
			local ItemsNum = #bagshujuy;
			for ix=1,ItemsNum do
				if not IsItemExist(Config0,bagshujuy[ix][1]) then
					table.insert(Config0, {bagshujuy[ix][1],Fun.GetItemLinkJJ(bagshujuy[ix][2]),bagshujuy[ix][3],bagshujuy[ix][4],bagshujuy[ix][5]});
				end
			end
		end
		fuFrame.UpdateListHang()
		fuFrame.UpdateListHang_addBag()
	end)
	fuFrame.List.addList.EditBoxT = PIGFontString(fuFrame.List.addList,{"LEFT", fuFrame.List.addList.addall, "RIGHT", 16, 0},"物品ID")
	fuFrame.List.addList.EditBox = CreateFrame("EditBox", nil, fuFrame.List.addList, "InputBoxInstructionsTemplate");
	fuFrame.List.addList.EditBox:SetSize(80,20);
	fuFrame.List.addList.EditBox:SetPoint("LEFT", fuFrame.List.addList.EditBoxT, "RIGHT", 6, 0);
	fuFrame.List.addList.EditBox:SetAutoFocus(false);
	fuFrame.List.addList.EditBox:SetMaxLetters(10)
	fuFrame.List.addList.EditBox:SetNumeric(true)
	fuFrame.List.addList.EditBox.addbut = PIGButton(fuFrame.List.addList.EditBox,{"LEFT", fuFrame.List.addList.EditBox, "RIGHT", 2, 0},{42,20},"添加");
	fuFrame.List.addList.EditBox.addbut:Hide()
	fuFrame.List.addList.EditBox:SetScript("OnTextChanged", function(self) if self:GetNumber()>0 then self.addbut:Show() else self.addbut:Hide() end end)
	fuFrame.List.addList.EditBox.addbut:SetScript("OnClick", function(self)
		local fujie = self:GetParent()
		local NewVVV = fujie:GetNumber()
		if NewVVV>0 then
			GetItemInfo(NewVVV)
			local function GetIteminfoX()
				local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,itemStackCount, itemEquipLoc, itemTexture,sellPrice,classID,subclassID= GetItemInfo(NewVVV)
				if itemLink then
					local jieguo,errtishi = IsItemMay(true,itemLink,itemQuality,sellPrice,classID,subclassID)
					if jieguo then
						InsertItemData(NewVVV,itemLink,itemTexture,itemStackCount)
					else
						PIG_OptionsUI:ErrorMsg(errtishi,"R") 
					end	
				end
			end
			C_Timer.After(0.2,GetIteminfoX)
		end
		fujie:SetText("")
		fujie:ClearFocus()
		self:Hide()
	end)
	fuFrame.List.addList.NR = PIGFrame(fuFrame.List.addList,{"TOPLEFT", fuFrame.List.addList, "TOPLEFT", 6, -80})
	fuFrame.List.addList.NR:SetPoint("BOTTOMRIGHT", fuFrame.List.addList, "BOTTOMRIGHT", -6, 6);
	fuFrame.List.addList.NR:PIGSetBackdrop()
	fuFrame.List.addList.NR.Scroll = CreateFrame("ScrollFrame",nil,fuFrame.List.addList.NR, "FauxScrollFrameTemplate");  
	fuFrame.List.addList.NR.Scroll:SetPoint("TOPLEFT",fuFrame.List.addList.NR,"TOPLEFT",0,-2);
	fuFrame.List.addList.NR.Scroll:SetPoint("BOTTOMRIGHT",fuFrame.List.addList.NR,"BOTTOMRIGHT",-19,2);
	fuFrame.List.addList.NR.Scroll.ScrollBar:SetScale(0.8);
	fuFrame.List.addList.NR.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fuFrame.UpdateListHang_addBag)
	end)
	fuFrame.List.addList.NR.ButList={}
	for id = 1, addBag_hang_NUM do
		local hang = CreateFrame("Frame", nil, fuFrame.List.addList.NR);
		fuFrame.List.addList.NR.ButList[id]=hang--hangName.."addList"..id
		hang:SetSize(Width-40, hang_Height);
		if id==1 then
			hang:SetPoint("TOP",fuFrame.List.addList.NR.Scroll,"TOP",0,-2);
		else
			hang:SetPoint("TOP",fuFrame.List.addList.NR.ButList[id-1],"BOTTOM",0,0);
		end
		if id~=addBag_hang_NUM then
			PIGLine(hang,"BOT",nil,nil,{2,-2},{0.3,0.3,0.3,0.5})
		end
		hang.check = PIGDiyBut(hang,{"LEFT", hang, "LEFT", 2,0},{hang_Height-4});
		hang.icon = hang:CreateTexture(nil, "BORDER");
		hang.icon:SetSize(hang_Height-1,hang_Height-1);
		hang.icon:SetPoint("LEFT", hang.check, "RIGHT", 0,0);
		hang.link = PIGFontString(hang,{"LEFT", hang.icon, "RIGHT", 4,0})
		function hang:ShowInfoFun(itemLink)
			self.itemLink=itemLink
			local ItemLevel = GetDetailedItemLevelInfo(itemLink)
			local ItemLevel=ItemLevel or "*"
			self.link:SetText(ItemLevel..itemLink);	
		end
	end
	function fuFrame.UpdateListHang_addBag()
		if not fuFrame.List.addList:IsShown() then return end
		local Scroll = fuFrame.List.addList.NR.Scroll
		for id = 1, addBag_hang_NUM do
			local hang =fuFrame.List.addList.NR.ButList[id]
			hang:Hide()
			hang.check:SetScript("OnClick", nil);
	    end
	    local bagshujuy = {}
		if fuFrame.List.addList.lx=="filtra" then
			for _,butx in pairs(fuFrame.List.addList.ButList) do
				butx:Hide()
			end
			fuFrame.List.addList.filtraTips:Show()
			fuFrame.List.addList.addall:SetText("清空排除")
			bagshujuy=PIGA["AutoSellBuy"][hangName.."_Lsit_Filtra"]
		else
			for _,butx in pairs(fuFrame.List.addList.ButList) do
				butx:Show()
			end
			fuFrame.List.addList.filtraTips:Hide()
			fuFrame.List.addList.addall:SetText("添加以下")
			for bag=0,bagIDMax do
				local NumSlots=GetContainerNumSlots(bag)
				for slot=1,NumSlots do
					local itemID, itemLink, icon, _,quality = PIGGetContainerItemInfo(bag, slot)
					if itemID and itemID~=6948 then
						if fuFrame.List.addList.ButList[quality] and fuFrame.List.addList.ButList[quality].Check and not IsItemExist(bagshujuy,itemID) then
							local itemStackCount, itemEquipLoc, itemTexture,sellPrice,classID,subclassID= select(8, GetItemInfo(itemLink))
							local jieguo = IsItemMay(false,itemLink,quality,sellPrice,classID,subclassID,bag, slot)
							if jieguo then
								local ItemLevel = GetDetailedItemLevelInfo(itemLink)
								table.insert(bagshujuy,{itemID,itemLink,icon,itemStackCount,itemStackCount,false,ItemLevel})
							end
						end
					end
				end
			end
		end
 		---
 		fuFrame.addItemData=bagshujuy
		local ItemsNum = #bagshujuy;
		for i=1,ItemsNum do
			if IsItemExist(Config0,bagshujuy[i][1]) then
				bagshujuy[i][6]=true
			end
		end	
	    FauxScrollFrame_Update(Scroll, ItemsNum, addBag_hang_NUM, hang_Height);
	    local offset = FauxScrollFrame_GetOffset(Scroll);
	    for id = 1, addBag_hang_NUM do
	    	local dangqianH = id+offset;
	    	if bagshujuy[dangqianH] then
	    		local hang =fuFrame.List.addList.NR.ButList[id]
	    		hang:Show();
	    		hang.check:SetID(dangqianH);
		    	hang.icon:SetTexture(bagshujuy[dangqianH][3]);
		    	hang.itemID=bagshujuy[dangqianH][1]
				Fun.HY_ShowItemLink(hang,bagshujuy[dangqianH][1],bagshujuy[dangqianH][2])
				if fuFrame.List.addList.lx=="filtra" then
					hang.check.icon:SetSize(hang_Height-9,hang_Height-9);
					hang.check.icon:SetTexture("interface/common/voicechat-muted.blp");
					hang.check:Show()
					hang:SetScript("OnMouseUp", function (self)
						GameTooltip:ClearLines();
						GameTooltip:Hide()
					end);
					hang.check:SetScript("OnClick", function (self)
						table.remove(FiltraConfig0, self:GetID());
						fuFrame.UpdateListHang_addBag()
					end);
				else
					hang.check.icon:SetSize(hang_Height-1,hang_Height-1);
					hang.check.icon:SetTexture("interface/buttons/ui-checkbox-check.blp");
					hang.check:SetShown(bagshujuy[dangqianH][6])
					hang:SetScript("OnMouseUp", function (self)
						GameTooltip:ClearLines();
						GameTooltip:Hide()
						local ItemLinkJJ = Fun.GetItemLinkJJ(bagshujuy[dangqianH][2])
						for g=1,#Config0 do
							if ItemLinkJJ==Config0[g][2] then
								table.remove(Config0, g);
								fuFrame.UpdateListHang();
								fuFrame.UpdateListHang_addBag()
								return
							end
						end
						table.insert(Config0, {bagshujuy[dangqianH][1],ItemLinkJJ,bagshujuy[dangqianH][3],bagshujuy[dangqianH][4],bagshujuy[dangqianH][5]});
						fuFrame.UpdateListHang();
						fuFrame.UpdateListHang_addBag()
					end);
				end
	    	end
	    end
	end
	function fuFrame.addList_ShowFun(lx,txt1)
		fuFrame.List.addList.biaoti:SetText(txt1)
		if fuFrame.List.addList:IsShown() and fuFrame.List.addList.lx==lx then
			fuFrame.List.addList:Hide()
		else
			fuFrame.List.addList.lx=lx
			fuFrame.List.addList:Show()
			fuFrame.UpdateListHang_addBag(lx,txt1)
		end
	end
	--
	fuFrame.List.Scroll = CreateFrame("ScrollFrame",nil,fuFrame.List, "FauxScrollFrameTemplate");  
	fuFrame.List.Scroll:SetPoint("TOPLEFT",fuFrame.List,"TOPLEFT",0,-2);
	fuFrame.List.Scroll:SetPoint("BOTTOMRIGHT",fuFrame.List,"BOTTOMRIGHT",-19,2);
	fuFrame.List.Scroll.ScrollBar:SetScale(0.8)
	fuFrame.List.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fuFrame.UpdateListHang)
	end)
	fuFrame.List.ButList={}
	for id = 1, hang_NUM do
		local hang = CreateFrame("Frame", nil, fuFrame.List);
		fuFrame.List.ButList[id]=hang
		hang:SetSize(Width-19, hang_Height);
		if id==1 then
			hang:SetPoint("TOP",fuFrame.List.Scroll,"TOP",0,-2);
		else
			hang:SetPoint("TOP",fuFrame.List.ButList[id-1],"BOTTOM",0,0);
		end
		if id~=hang_NUM then
			PIGLine(hang,"BOT",nil,nil,{2,-2},{0.3,0.3,0.3,0.5})
		end
		hang.del = PIGDiyBut(hang,{"LEFT", hang, "LEFT", 4,0},{hang_Height-6});
		hang.del:SetScript("OnClick", function (self)
			table.remove(Config0, self:GetID());
			fuFrame.UpdateListHang();
			fuFrame.UpdateListHang_addBag()
		end);
		hang.item = CreateFrame("Frame", nil, hang);
		hang.item:SetSize(Width-94,hang_Height);
		hang.item:SetPoint("LEFT",hang.del,"RIGHT",2,0);
		hang.item.icon = hang.item:CreateTexture(nil, "BORDER");
		hang.item.icon:SetSize(hang_Height-1,hang_Height-1);
		hang.item.icon:SetPoint("LEFT", hang.item, "LEFT", 0,0);
		hang.item.link = PIGFontString(hang,{"LEFT", hang.item, "LEFT", hang_Height+4,0})
		function hang.item:ShowInfoFun(itemLink)
			self.itemLink=itemLink
			local ItemLevel = GetDetailedItemLevelInfo(itemLink)
			local ItemLevel=ItemLevel or "*"
			self.link:SetText(ItemLevel..itemLink);	
		end
		hang.item:SetScript("OnMouseDown", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
			GameTooltip:SetHyperlink(self.itemLink)
			GameTooltip:Show() 
		end);
		hang.item:SetScript("OnMouseUp", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		hang:SetScript("OnMouseDown", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
			GameTooltip:SetHyperlink(self.itemLink)
			GameTooltip:Show()
		end);
		if hangName=="Buy" then
			hang.Cont = CreateFrame('EditBox', nil, hang,"InputBoxInstructionsTemplate");
			hang.Cont:SetHeight(28);
			hang.Cont:SetPoint("RIGHT", hang, "RIGHT", 0,0);
			hang.Cont:SetPoint("LEFT", hang.item, "RIGHT", 0,0);
			hang.Cont:SetFontObject(ChatFontNormal);
			hang.Cont:SetAutoFocus(false);
			hang.Cont:SetMaxLetters(5)
			hang.Cont:SetNumeric()
			hang.Cont:SetTextColor(0.6, 0.6, 0.6, 1);
			hang.Cont:SetTextInsets(0, 6, 0, 0)
			hang.Cont:SetJustifyH("RIGHT")
			hang.Cont:SetScript("OnEditFocusGained", function(self) 
				self:SetTextColor(1, 1, 1, 1);
			end);
			hang.Cont:SetScript("OnEscapePressed", function(self) 
				self:ClearFocus() 
			end);
			hang.Cont:SetScript("OnEnterPressed", function(self) 
				self:ClearFocus() 
			end);
			hang.Cont:SetScript("OnEditFocusLost", function(self)
				self:SetTextColor(0.6, 0.6, 0.6, 1);
				local NWEdanjiaV=self:GetNumber();
		 		self:SetText(NWEdanjiaV);
		 		local bianjiID=self:GetParent().del:GetID()
				Config0[bianjiID][4]=NWEdanjiaV;
				fuFrame.UpdateListHang();
			end);
		end
	end
	function fuFrame.UpdateListHang()
		local Scroll = fuFrame.List.Scroll
		for id = 1, hang_NUM do
			fuFrame.List.ButList[id]:Hide();
	    end
	    local ItemsNum = #Config0;
		if ItemsNum>0 then
		    FauxScrollFrame_Update(Scroll, ItemsNum, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(Scroll);
		    for id = 1, hang_NUM do
		    	local dangqianH = id+offset;
		    	if Config0[dangqianH] then
		    		local hang = fuFrame.List.ButList[id]
		    		hang:Show();
			    	hang.item.icon:SetTexture(Config0[dangqianH][3]);
					hang.item.itemID=Config0[dangqianH][1]
					Fun.HY_ShowItemLink(hang.item,Config0[dangqianH][1],Config0[dangqianH][2])
					hang.del:SetID(dangqianH);
					if hangName=="Buy" then
						hang.Cont:Show();
						hang.Cont:SetText(Config0[dangqianH][4]);
					end
				end
			end
		end
	end
	--
	fuFrame.List.ADD = CreateFrame("Frame",nil,fuFrame.List);  
	fuFrame.List.ADD:SetPoint("TOPLEFT",fuFrame.List,"TOPLEFT",0,0);
	fuFrame.List.ADD:SetPoint("BOTTOMRIGHT",fuFrame.List,"BOTTOMRIGHT",0,0);
	---
	--fuFrame.List:RegisterEvent("ITEM_LOCK_CHANGED");
	--fuFrame.List:RegisterEvent("ITEM_UNLOCKED");
	fuFrame.List:RegisterEvent("CURSOR_CHANGED");
	fuFrame.List:SetScript("OnEvent",function (self,event,arg1,arg2)
		if self:IsVisible() then
			if arg1==false then
				self.ADD:SetFrameLevel(FrameLevel+8);
			elseif arg1==true and arg2==1 or arg2==5 then
				--print(CursorHasItem())
				self.ADD:SetFrameLevel(FrameLevel);
			end
		end
	end);
	local function zhixingbaocun(self)
		local chazhaowupinID,chazhaowupinlink
		local NewType, itemID, Itemlink= GetCursorInfo()
		if NewType=="item" then
			chazhaowupinID=itemID
			chazhaowupinlink=Itemlink
		elseif NewType=="merchant" then
			chazhaowupinID=GetMerchantItemID(itemID)
			chazhaowupinlink=GetMerchantItemLink(itemID)
		end
		if not chazhaowupinlink then fuFrame.List.ADD:SetFrameLevel(FrameLevel); ClearCursor(); return end
		local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,itemStackCount, itemEquipLoc, itemTexture,sellPrice,classID= GetItemInfo(chazhaowupinlink) 
		local jieguo,errtishi = IsItemMay(true,itemLink,itemQuality,sellPrice,classID,subclassID,"Cursor")
		if jieguo then
			InsertItemData(chazhaowupinID,itemLink,itemTexture,itemStackCount,"Cursor")
		else
			PIG_OptionsUI:ErrorMsg(errtishi,"R") 
		end	
		chazhaowupinID = nil
		chazhaowupinlink = nil
		ClearCursor();
	end
	fuFrame.List:SetScript("OnHide", function (self)
		self.ADD:SetFrameLevel(FrameLevel)
	end)
	fuFrame.List.ADD:SetScript("OnReceiveDrag", function (self)
		zhixingbaocun(self)
		self:SetFrameLevel(FrameLevel);
	end)
	fuFrame.List.ADD:SetScript("OnMouseUp", function (self)
		zhixingbaocun(self)
		self:SetFrameLevel(FrameLevel);
	end);
	fuFrame.List:SetScript("OnShow", function()
		fuFrame.UpdateListHang();
	end)
end