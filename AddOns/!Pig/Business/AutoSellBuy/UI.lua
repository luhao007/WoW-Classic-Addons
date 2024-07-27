local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Data=addonTable.Data
local Fun=addonTable.Fun
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGCloseBut=Create.PIGCloseBut
local PIGLine=Create.PIGLine
local PIGModbutton=Create.PIGModbutton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGModCheckbutton=Create.PIGModCheckbutton
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
--
local GetContainerNumSlots = C_Container.GetContainerNumSlots
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
	BusinessInfo.FastDiuqi()
	BusinessInfo.AutoSell()
	BusinessInfo.AutoBuy()
	BusinessInfo.FastOpen()
	BusinessInfo.FastFen()
	BusinessInfo.FastSave()
	BusinessInfo.FastTake()
end
function BusinessInfo.ADDScroll(fuFrame,text,hangName,hang_NUM,Config0,Config1)
	local Width = fuFrame:GetWidth()-12;
	local hang_Height = 24
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
	fuFrame.List.biaoti = PIGFontString(fuFrame.List,{"LEFT", fuFrame.List.ru, "RIGHT", 4, 0},"\124cffFFFF00"..text.."列表\124r\124cff00FF00(拖拽到此)\124r")
	fuFrame.List.bagbut = PIGButton(fuFrame,{"BOTTOMRIGHT",fuFrame.List,"TOPRIGHT",0,4},{44,20},"添加");
	fuFrame.List.bagbut:HookScript("OnClick",  function (self)
		if self.List:IsShown() then
			self.List:Hide()
		else
			self.List:Show()
		end	
	end)
	local addBag_W,addBag_hang_NUM = 240,19
	fuFrame.List.bagbut.List = PIGFrame(fuFrame.List.bagbut,{"TOPLEFT", fuFrame, "TOPRIGHT", 2, biaotiH})
	fuFrame.List.bagbut.List:SetPoint("BOTTOMRIGHT", fuFrame, "BOTTOMRIGHT", addBag_W, 0);
	fuFrame.List.bagbut.List:PIGSetBackdrop()
	fuFrame.List.bagbut.List:PIGClose()
	fuFrame.List.bagbut.List:Hide()
	fuFrame.List.bagbut.List.biaoti = PIGFontString(fuFrame.List.bagbut.List,{"TOP", fuFrame.List.bagbut.List, "TOP", 0, -4},"添加背包物品")

	PIGLine(fuFrame.List.bagbut.List,"TOP",-biaotiH)
	---
	fuFrame.List.bagbut.List.xuanzhong={}
	local Quality = Data.Quality
	for i=0,bagIDMax do
		fuFrame.List.bagbut.List.xuanzhong[i]=true
		local text ={Quality[i]["Name"],Quality[i]["Name"]}
		local Checkbut =PIGCheckbutton(fuFrame.List.bagbut.List,nil,text)
		if i<3 then
			if i==0 then
				Checkbut:SetPoint("TOPLEFT", fuFrame.List.bagbut.List, "TOPLEFT", 6, -26);
			else
				Checkbut:SetPoint("TOPLEFT", fuFrame.List.bagbut.List, "TOPLEFT", 6+i*70, -26);
			end
		else
			if i==3 then
				Checkbut:SetPoint("TOPLEFT", fuFrame.List.bagbut.List, "TOPLEFT", 6, -54);
			else
				Checkbut:SetPoint("TOPLEFT", fuFrame.List.bagbut.List, "TOPLEFT", 6+(i-3)*70, -54);
			end
		end
		Checkbut:SetChecked(true)
		Checkbut:SetScript("OnClick", function (self)
			if self:GetChecked() then
				fuFrame.List.bagbut.List.xuanzhong[i]=true
			else
				fuFrame.List.bagbut.List.xuanzhong[i]=false
			end
			fuFrame.gengxin_addBag()
		end);
	end
	fuFrame.List.bagbut.List.addall = PIGButton(fuFrame.List.bagbut.List,{"TOPLEFT", fuFrame.List.bagbut.List, "TOPLEFT", 142, -52},{80,22},"添加以下");
	fuFrame.List.bagbut.List.addall:SetScript("OnClick", function()
		for bag=0,bagIDMax do			
			local xx=GetContainerNumSlots(bag)
			for slot=1,xx do
				local itemID, itemLink, icon, _,quality = PIGGetContainerIDlink(bag, slot)
				if itemID then
					if itemID~=6948 then
						if fuFrame.List.bagbut.List.xuanzhong[quality] then
							if not fuFrame.panduancunzai(itemID) then
								local itemStackCount= select(8, GetItemInfo(itemLink))
								table.insert(Config0,{itemID,itemLink,icon,itemStackCount,itemStackCount})
							end
						end
					end
				end
			end
		end
		fuFrame.gengxinHang();
		fuFrame.gengxin_addBag()
	end)
	function fuFrame.panduancunzai(idx)
		for ix=1,#Config0 do
			if idx==Config0[ix][1] then
				return true
			end
		end
		return false
	end
	fuFrame.List.bagbut.List.NR = PIGFrame(fuFrame.List.bagbut.List,{"TOPLEFT", fuFrame.List.bagbut.List, "TOPLEFT", 6, -80})
	fuFrame.List.bagbut.List.NR:SetPoint("BOTTOMRIGHT", fuFrame.List.bagbut.List, "BOTTOMRIGHT", -6, 6);
	fuFrame.List.bagbut.List.NR:PIGSetBackdrop()
	fuFrame.List.bagbut.List.NR.Scroll = CreateFrame("ScrollFrame",nil,fuFrame.List.bagbut.List.NR, "FauxScrollFrameTemplate");  
	fuFrame.List.bagbut.List.NR.Scroll:SetPoint("TOPLEFT",fuFrame.List.bagbut.List.NR,"TOPLEFT",0,-2);
	fuFrame.List.bagbut.List.NR.Scroll:SetPoint("BOTTOMRIGHT",fuFrame.List.bagbut.List.NR,"BOTTOMRIGHT",-25,2);
	fuFrame.List.bagbut.List.NR.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fuFrame.gengxin_addBag)
	end)
	for id = 1, addBag_hang_NUM do
		local hang = CreateFrame("Frame", hangName.."addbaghang"..id, fuFrame.List.bagbut.List.NR);
		hang:SetSize(addBag_W-40, hang_Height);
		if id==1 then
			hang:SetPoint("TOP",fuFrame.List.bagbut.List.NR.Scroll,"TOP",0,-2);
		else
			hang:SetPoint("TOP",_G[hangName.."addbaghang"..(id-1)],"BOTTOM",0,0);
		end
		if id~=addBag_hang_NUM then
			PIGLine(hang,"BOT",nil,nil,{2,-2},{0.3,0.3,0.3,0.5})
		end
		hang.check = hang:CreateTexture()
		hang.check:SetTexture("interface/buttons/ui-checkbox-check.bl");
		hang.check:SetSize(hang_Height,hang_Height);
		hang.check:SetPoint("LEFT", hang, "LEFT", 0,0);
		hang.icon = hang:CreateTexture(nil, "BORDER");
		hang.icon:SetSize(hang_Height-1,hang_Height-1);
		hang.icon:SetPoint("LEFT", hang.check, "RIGHT", 0,0);
		hang.link = PIGFontString(hang,{"LEFT", hang.icon, "RIGHT", 4,0})
	end
	function fuFrame.gengxin_addBag()
		if not fuFrame.List.bagbut.List:IsShown() then return end
		local Scroll = fuFrame.List.bagbut.List.NR.Scroll
		for id = 1, addBag_hang_NUM do
			_G[hangName.."addbaghang"..id]:Hide();
	    end
	    local bagshujuy = {}
		for bag=0,bagIDMax do			
			local xx=GetContainerNumSlots(bag)
			for slot=1,xx do
				local itemID, itemLink, icon, _,quality = PIGGetContainerIDlink(bag, slot)
				if itemID then
					if itemID~=6948 then
						if fuFrame.List.bagbut.List.xuanzhong[quality] then
							local itemStackCount= select(8, GetItemInfo(itemLink))
							table.insert(bagshujuy,{itemID,itemLink,icon,itemStackCount,itemStackCount,false})
						end
					end
				end
			end
		end
		local ItemsNum = #bagshujuy;
		local shujuy =Config0
		for i=1,ItemsNum do
			for ii=1,#shujuy do
				if shujuy[ii][2]==bagshujuy[i][2] then	
					bagshujuy[i][6]=true
				end
			end
		end	
	    FauxScrollFrame_Update(Scroll, ItemsNum, addBag_hang_NUM, hang_Height);
	    local offset = FauxScrollFrame_GetOffset(Scroll);
	    for id = 1, addBag_hang_NUM do
	    	local dangqianH = id+offset;
	    	if bagshujuy[dangqianH] then
	    		local hang = _G[hangName.."addbaghang"..id]
	    		hang:Show();
		    	hang.icon:SetTexture(bagshujuy[dangqianH][3]);
				hang.link:SetText(bagshujuy[dangqianH][2]);
				if bagshujuy[dangqianH][6] then
					hang.check:Show()
				else
					hang.check:Hide()
				end
				hang:SetScript("OnMouseDown", function (self)
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
					GameTooltip:SetHyperlink(bagshujuy[dangqianH][2])
				end);
				hang:SetScript("OnMouseUp", function (self)
					GameTooltip:ClearLines();
					GameTooltip:Hide() 
					local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,itemStackCount, itemEquipLoc, itemTexture,sellPrice,classID= GetItemInfo(bagshujuy[dangqianH][2])
					if hangName=="Sell" then
						if sellPrice==0 then
							PIGinfotip:TryDisplayMessage("物品无法售卖") 
							ClearCursor();
							return 
						end
					end
					if hangName=="Fen" then
						if itemQuality<2 or classID~=2 and classID~=4 then
							PIGinfotip:TryDisplayMessage("物品无法分解")
							ClearCursor();
							return 
						end
					end
					for g=1,#Config0 do
						if bagshujuy[dangqianH][2]==Config0[g][2] then
							table.remove(Config0, g);
							fuFrame.gengxinHang();
							fuFrame.gengxin_addBag()
							return
						end
					end
					table.insert(Config0, {bagshujuy[dangqianH][1],bagshujuy[dangqianH][2],bagshujuy[dangqianH][3],bagshujuy[dangqianH][4],bagshujuy[dangqianH][5]});
					fuFrame.gengxinHang();
					fuFrame.gengxin_addBag()
				end);
	    	end
	    end
	end
	fuFrame:HookScript("OnHide", function (self)
		self.List.bagbut.List:Hide()
	end)
	fuFrame.List.bagbut.List:HookScript("OnShow", function (self)
		fuFrame.gengxin_addBag()
	end)
	--
	fuFrame.List.Scroll = CreateFrame("ScrollFrame",nil,fuFrame.List, "FauxScrollFrameTemplate");  
	fuFrame.List.Scroll:SetPoint("TOPLEFT",fuFrame.List,"TOPLEFT",0,-2);
	fuFrame.List.Scroll:SetPoint("BOTTOMRIGHT",fuFrame.List,"BOTTOMRIGHT",-25,2);
	fuFrame.List.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fuFrame.gengxinHang)
	end)
	for id = 1, hang_NUM do
		local hang = CreateFrame("Frame", hangName.."hang"..id, fuFrame.List);
		hang:SetSize(Width-36, hang_Height);
		if id==1 then
			hang:SetPoint("TOP",fuFrame.List.Scroll,"TOP",0,-2);
		else
			hang:SetPoint("TOP",_G[hangName.."hang"..(id-1)],"BOTTOM",0,0);
		end
		if id~=hang_NUM then
			PIGLine(hang,"BOT",nil,nil,{2,-2},{0.3,0.3,0.3,0.5})
		end
		hang.del = PIGCloseBut(hang,{"LEFT", hang, "LEFT", 0,0});
		hang.del:SetScript("OnClick", function (self)
			table.remove(Config0, self:GetID());
			fuFrame.gengxinHang();
			fuFrame.gengxin_addBag()
		end);
		hang.item = CreateFrame("Frame", nil, hang);
		hang.item:SetSize(Width-70,hang_Height);
		hang.item:SetPoint("LEFT",hang,"LEFT",hang_Height,0);
		hang.item.icon = hang.item:CreateTexture(nil, "BORDER");
		hang.item.icon:SetSize(hang_Height-1,hang_Height-1);
		hang.item.icon:SetPoint("LEFT", hang.item, "LEFT", 0,0);
		hang.item.link = PIGFontString(hang,{"LEFT", hang.item, "LEFT", hang_Height+4,0})
		if hangName=="Buy" then
			hang.item:SetWidth(Width-70-36);
			hang.Cont = CreateFrame('EditBox', nil, hang,"InputBoxInstructionsTemplate");
			hang.Cont:SetSize(36,28);
			hang.Cont:SetPoint("RIGHT", hang, "RIGHT", 0,0);
			hang.Cont:SetFontObject(ChatFontNormal);
			hang.Cont:SetAutoFocus(false);
			hang.Cont:SetMaxLetters(4)
			hang.Cont:SetNumeric()
			hang.Cont:SetTextColor(0.6, 0.6, 0.6, 1);
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
				fuFrame.gengxinHang();
			end);
		end
	end
	function fuFrame.gengxinHang()
		local Scroll = fuFrame.List.Scroll
		for id = 1, hang_NUM do
			_G[hangName.."hang"..id]:Hide();
	    end
	    local shujuy =Config0
	    local ItemsNum = #shujuy;
		if ItemsNum>0 then
		    FauxScrollFrame_Update(Scroll, ItemsNum, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(Scroll);
		    for id = 1, hang_NUM do
		    	local dangqianH = id+offset;
		    	if shujuy[dangqianH] then
		    		local hang = _G[hangName.."hang"..id]
		    		hang:Show();
			    	hang.item.icon:SetTexture(shujuy[dangqianH][3]);
					hang.item.link:SetText(shujuy[dangqianH][2]);
					hang.item:SetScript("OnMouseDown", function (self)
						GameTooltip:ClearLines();
						GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
						GameTooltip:SetHyperlink(shujuy[dangqianH][2])
					end);
					hang.item:SetScript("OnMouseUp", function ()
						GameTooltip:ClearLines();
						GameTooltip:Hide() 
					end);
					hang.del:SetID(dangqianH);
					if hangName=="Buy" then
						if shujuy[dangqianH][5]==1 then
							hang.Cont:Disable();
						else
							hang.Cont:Enable();
						end
						hang.Cont:Show();
						hang.Cont:SetText(shujuy[dangqianH][4]);
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
			elseif arg1==true  and arg2==1 or arg2==5 then
				print(CursorHasItem())
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
			if hangName=="Sell" then
				if sellPrice==0 then
					PIGinfotip:TryDisplayMessage("物品无法售卖") 
					ClearCursor();
					return 
				end
			end
			if hangName=="Fen" then
				if itemQuality<2 or classID~=2 and classID~=4 then
					PIGinfotip:TryDisplayMessage("物品无法分解")
					ClearCursor();
					return 
				end
			end
			for i=1,#Config0 do
				if itemLink==Config0[i][2] then
					PIGinfotip:TryDisplayMessage("物品已在目录内");
					ClearCursor();
					return
				end			
			end
			table.insert(Config0, {chazhaowupinID,itemLink,itemTexture,itemStackCount,itemStackCount});
			ClearCursor();
			fuFrame.gengxinHang();
			fuFrame.gengxin_addBag()
			chazhaowupinID = nil
			chazhaowupinlink = nil
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
		fuFrame.gengxinHang();
	end)
	--
	function fuFrame.qingkong()
		for i=#Config0,1,-1 do
			table.remove(Config0, i);
		end
		fuFrame.gengxinHang()
		fuFrame.gengxin_addBag()
	end
end