local addonName, addonTable = ...;
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
local Data=addonTable.Data
local InvSlot=Data.InvSlot
--创建界面背景
function Create.CharacterBG(fuji,Isname)
	local texname = nil
	if Isname then texname="PIG_tex"..fuji:GetName() end
	fuji.Bg = fuji:CreateTexture(Isname and texname.."Bg", "BACKGROUND");
	fuji.Bg:SetTexture("interface/framegeneral/ui-background-rock.blp");
	fuji.Bg:SetPoint("TOPLEFT", fuji, "TOPLEFT",14,-13);
	fuji.Bg:SetPoint("BOTTOMRIGHT", fuji, "BOTTOMRIGHT", -3,5);
	fuji.Bg:SetDrawLayer("BACKGROUND", -1)

	fuji.topbg = fuji:CreateTexture(Isname and texname.."topbg", "BACKGROUND");
	fuji.topbg:SetTexture(374157);
	fuji.topbg:SetPoint("TOPLEFT", fuji, "TOPLEFT",68, -13);
	fuji.topbg:SetPoint("TOPRIGHT", fuji, "TOPRIGHT",-24, -13);
	fuji.topbg:SetTexCoord(0,0.2890625,0,0.421875,1.359809994697571,0.2890625,1.359809994697571,0.421875);
	fuji.topbg:SetHeight(20);
	fuji.TOPLEFT = fuji:CreateTexture(Isname and texname.."TOPLEFT", "BORDER");
	fuji.TOPLEFT:SetTexture("interface/framegeneral/ui-frame.blp");
	fuji.TOPLEFT:SetPoint("TOPLEFT", fuji, "TOPLEFT",0, 0);
	fuji.TOPLEFT:SetTexCoord(0.0078125,0.0078125,0.0078125,0.6171875,0.6171875,0.0078125,0.6171875,0.6171875);
	fuji.TOPLEFT:SetSize(78,78);
	fuji.TOPRIGHT = fuji:CreateTexture(Isname and texname.."TOPRIGHT", "BORDER");
	fuji.TOPRIGHT:SetTexture(374156);
	fuji.TOPRIGHT:SetPoint("TOPRIGHT", fuji, "TOPRIGHT",0, -10);
	fuji.TOPRIGHT:SetTexCoord(0.6328125,0.0078125,0.6328125,0.265625,0.890625,0.0078125,0.890625,0.265625);
	fuji.TOPRIGHT:SetSize(33,33);
	fuji.TOP = fuji:CreateTexture(Isname and texname.."TOP", "BORDER");
	fuji.TOP:SetTexture(374157);
	fuji.TOP:SetPoint("TOPLEFT", fuji.TOPLEFT, "TOPRIGHT",0, -10);
	fuji.TOP:SetPoint("BOTTOMRIGHT", fuji.TOPRIGHT, "BOTTOMLEFT", 0, 5);
	fuji.TOP:SetTexCoord(0,0.4375,0,0.65625,1.08637285232544,0.4375,1.08637285232544,0.65625);
	fuji.BOTTOMLEFT = fuji:CreateTexture(Isname and texname.."BOTTOMLEFT", "BORDER");
	fuji.BOTTOMLEFT:SetTexture(374156);
	fuji.BOTTOMLEFT:SetPoint("BOTTOMLEFT", fuji, "BOTTOMLEFT",8, 0);
	fuji.BOTTOMLEFT:SetTexCoord(0.0078125,0.6328125,0.0078125,0.7421875,0.1171875,0.6328125,0.1171875,0.7421875);
	fuji.BOTTOMLEFT:SetSize(14,14);

	fuji.BOTTOMRIGHT = fuji:CreateTexture(Isname and texname.."BOTTOMRIGHT", "BORDER");
	fuji.BOTTOMRIGHT:SetTexture(374156);
	fuji.BOTTOMRIGHT:SetPoint("BOTTOMRIGHT", fuji, "BOTTOMRIGHT",0, 0);
	fuji.BOTTOMRIGHT:SetTexCoord(0.1328125,0.8984375,0.1328125,0.984375,0.21875,0.8984375,0.21875,0.984375);
	fuji.BOTTOMRIGHT:SetSize(11,11);

	fuji.LEFT = fuji:CreateTexture(Isname and texname.."LEFT", "BORDER");
	fuji.LEFT:SetTexture(374153);
	fuji.LEFT:SetTexCoord(0.359375,0,0.359375,1.42187488079071,0.609375,0,0.609375,1.42187488079071);
	fuji.LEFT:SetPoint("TOPLEFT", fuji.TOPLEFT, "BOTTOMLEFT",8, 0);
	fuji.LEFT:SetPoint("BOTTOMLEFT", fuji.BOTTOMLEFT, "TOPLEFT", 0, 0);
	fuji.LEFT:SetWidth(16);

	fuji.RIGHT = fuji:CreateTexture(Isname and texname.."RIGHT", "BORDER");
	fuji.RIGHT:SetTexture(374153);
	fuji.RIGHT:SetTexCoord(0.171875,0,0.171875,1.5703125,0.328125,0,0.328125,1.5703125);
	fuji.RIGHT:SetPoint("TOPRIGHT", fuji.TOPRIGHT, "BOTTOMRIGHT",0.8, 0);
	fuji.RIGHT:SetPoint("BOTTOMRIGHT", fuji.BOTTOMRIGHT, "TOPRIGHT", 0, 0);
	fuji.RIGHT:SetWidth(10);

	fuji.BOTTOM = fuji:CreateTexture(Isname and texname.."BOTTOM", "BORDER");
	fuji.BOTTOM:SetTexture(374157);
	fuji.BOTTOM:SetTexCoord(0,0.203125,0,0.2734375,1.425781607627869,0.203125,1.425781607627869,0.2734375);
	fuji.BOTTOM:SetPoint("BOTTOMLEFT", fuji.BOTTOMLEFT, "BOTTOMRIGHT",0, -0);
	fuji.BOTTOM:SetPoint("BOTTOMRIGHT", fuji.BOTTOMRIGHT, "BOTTOMLEFT", 0, 0);
	fuji.BOTTOM:SetHeight(9);
end
--创建背包银行界面背景
function Create.BagBankFrameBG(fuji,Isname)
	if ElvUI then
	else
		Create.CharacterBG(fuji,Isname)		
		fuji.portrait = fuji:CreateTexture(nil,"BACKGROUND");
		fuji.portrait:SetSize(60,60);
		fuji.portrait:SetPoint("TOPLEFT",fuji,"TOPLEFT",8.5,-4);
		local Mkuandu,Mgaodu = 8,22
		fuji.moneyframe = CreateFrame("Frame", nil, fuji);
		fuji.moneyframe:SetSize(160,Mgaodu);
		fuji.moneyframe:SetPoint("BOTTOMRIGHT", fuji, "BOTTOMRIGHT", -8, 7)
		fuji.moneyframe_R = fuji:CreateTexture(nil, "BORDER");
		fuji.moneyframe_R:SetTexture("interface/common/moneyframe.blp");
		fuji.moneyframe_R:SetTexCoord(0,0.05,0,0.31);
		fuji.moneyframe_R:SetSize(Mkuandu,Mgaodu);
		fuji.moneyframe_R:SetPoint("RIGHT", fuji.moneyframe, "RIGHT", 0, 0)
		fuji.moneyframe_l = fuji:CreateTexture(nil, "BORDER");
		fuji.moneyframe_l:SetTexture("interface/common/moneyframe.blp");
		fuji.moneyframe_l:SetTexCoord(0.95,1,0,0.31);
		fuji.moneyframe_l:SetSize(Mkuandu,Mgaodu);
		fuji.moneyframe_l:SetPoint("LEFT", fuji.moneyframe, "LEFT", 0, 0)
		fuji.moneyframe_C = fuji:CreateTexture(nil, "BORDER");
		fuji.moneyframe_C:SetTexture("interface/common/moneyframe.blp");
		fuji.moneyframe_C:SetTexCoord(0.1,0.9,0.314,0.621);
		fuji.moneyframe_C:SetPoint("TOPLEFT", fuji.moneyframe_l, "TOPRIGHT", 0, 0)
		fuji.moneyframe_C:SetPoint("BOTTOMRIGHT", fuji.moneyframe_R, "BOTTOMLEFT", 0, 0)
	end
end
--创建角色信息界面
function Create.CharacterFrame(fuji,UIName,FrameLevel)
	local frameX = CreateFrame("Frame", UIName, fuji)
	frameX:SetSize(384,512);
	frameX:SetFrameLevel(FrameLevel)
	frameX:Hide()
	tinsert(UISpecialFrames,UIName);
	Create.PIGSetMovable(frameX)
	if ElvUI or NDui then
		frameX._BG = PIGFrame(frameX)
		frameX._BG:SetFrameLevel(FrameLevel-2)
		Create.add_CloseUI(nil,frameX)
		frameX.Close:SetPoint("TOPRIGHT",frameX,"TOPRIGHT",-35,-15);
		if ElvUI then
			frameX._BG:PIGSetBackdrop(0.5)
			frameX._BG:SetPoint("TOPLEFT",frameX,"TOPLEFT",16,-13);
			frameX._BG:SetPoint("BOTTOMRIGHT",frameX,"BOTTOMRIGHT",-33,74);
			frameX._BG:PIGSetBackdrop(0.8)
		elseif NDui then
			frameX._BG:PIGSetBackdrop(0.5)
			frameX._BG:SetPoint("TOPLEFT",frameX,"TOPLEFT",16,-15);
			frameX._BG:SetPoint("BOTTOMRIGHT",frameX,"BOTTOMRIGHT",-34,72);
		end
	else
	    frameX.Portrait_BG = frameX:CreateTexture(nil, "BACKGROUND");
		frameX.Portrait_BG:SetTexture("interface/buttons/iconborder-glowring.blp");
		frameX.Portrait_BG:SetSize(60,60);
		frameX.Portrait_BG:SetPoint("TOPLEFT",frameX,"TOPLEFT",9,-7);
		frameX.Portrait_BG:SetDrawLayer("BACKGROUND", -2)
		frameX.Portrait_BGmask = frameX:CreateMaskTexture()
		frameX.Portrait_BGmask:SetAllPoints(frameX.Portrait_BG)
		frameX.Portrait_BGmask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		frameX.Portrait_BG:AddMaskTexture(frameX.Portrait_BGmask)
		frameX.Portrait = frameX:CreateTexture(nil, "BACKGROUND");
		frameX.Portrait:SetSize(60,60);
	    frameX.Portrait:SetPoint("TOPLEFT", frameX, "TOPLEFT", 8, -7);
		frameX.Close = CreateFrame("Button",nil,frameX, "UIPanelCloseButton");
	    frameX.Close:SetPoint("CENTER", frameX, "TOPRIGHT", -44, -25);
		frameX._BackdropL1 = frameX:CreateTexture(nil, "BORDER");
	    frameX._BackdropL1:SetTexture("Interface/PaperDollInfoFrame/UI-Character-CharacterTab-L1");
	    frameX._BackdropL1:SetSize(256,256);
	    frameX._BackdropL1:SetPoint("TOPLEFT");
	    frameX._BackdropR1 = frameX:CreateTexture(nil, "BORDER");
	    frameX._BackdropR1:SetTexture("Interface/PaperDollInfoFrame/UI-Character-CharacterTab-R1");
	    frameX._BackdropR1:SetSize(128,256);
	    frameX._BackdropR1:SetPoint("TOPLEFT",256,0);
	    frameX._BackdropB1 = frameX:CreateTexture(nil, "BORDER");
	    frameX._BackdropB1:SetTexture("Interface/PaperDollInfoFrame/UI-Character-CharacterTab-BottomLeft");
	    frameX._BackdropB1:SetSize(256,256);
	    frameX._BackdropB1:SetPoint("TOPLEFT",0,-256);
	    frameX._BackdropBr = frameX:CreateTexture(nil, "BORDER");
	    frameX._BackdropBr:SetTexture("Interface/PaperDollInfoFrame/UI-Character-CharacterTab-BottomRight");
	    frameX._BackdropBr:SetSize(128,256);
	    frameX._BackdropBr:SetPoint("TOPLEFT",256,-256);
	end
	--
	frameX.TitleText = PIGFontString(frameX,nil,nil,nil,nil,"OVERLAY")
	frameX.TitleText:SetTextColor(1, 1, 1, 1)
	frameX.LevelText = PIGFontString(frameX,nil,nil,nil,nil,"OVERLAY")
	frameX.TitleText:SetPoint("TOP", frameX, "TOP",8, -17);
	frameX.LevelText:SetPoint("TOP", frameX, "TOP",8, -38)
	frameX.tishi = CreateFrame("Frame", nil, frameX)
    frameX.tishi:SetSize(200,150);
    frameX.tishi:SetPoint("CENTER", frameX, "CENTER", 0, 30);
    frameX.tishi:SetFrameLevel(frameX:GetFrameLevel()+3)
    frameX.tishi.t = PIGFontString(frameX.tishi,{"CENTER", frameX.tishi, "CENTER",-4, 20})
	----
	frameX.PaperDollItemsFrame = CreateFrame("Frame", nil, frameX)
	frameX.PaperDollItemsFrame:SetPoint("TOPLEFT",frameX,"TOPLEFT",17,-70)
	frameX.PaperDollItemsFrame:SetPoint("BOTTOMRIGHT",frameX,"BOTTOMRIGHT",-36,80)
	local uiWidth=CharacterHeadSlot:GetWidth()
	frameX.ItemList={}
	for i=1,#InvSlot["CID"] do
		local item = CreateFrame("ItemButton", nil, frameX.PaperDollItemsFrame);
		frameX.ItemList[InvSlot["CID"][i]]=item
		item:SetSize(uiWidth,uiWidth);
		if ElvUI or NDui then
			item.NormalTexture:SetAlpha(0)
			item.icon:SetTexCoord(0.08,0.92,0.08,0.92)
		end
		if i<17 then
			if i==1 then
				item:SetPoint("TOPLEFT",frameX.PaperDollItemsFrame,"TOPLEFT",5,-4);
			elseif i==9 then
				item:SetPoint("TOPLEFT",frameX.PaperDollItemsFrame,"TOPLEFT",290,-4);
			else
				item:SetPoint("TOP", frameX.ItemList[InvSlot["CID"][i-1]], "BOTTOM", 0, -4);
			end
		else
			if i==17 then
				item:SetPoint("TOPLEFT",frameX.PaperDollItemsFrame,"BOTTOMLEFT",106,47);
			else
				item:SetPoint("LEFT", frameX.ItemList[InvSlot["CID"][i-1]], "RIGHT", 4, 0);
			end
		end
		item.ZLV = PIGFontString(item,{"TOPLEFT", item, "TOPLEFT", -2, 1},nil,"OUTLINE",15)
		item.ZLV:SetDrawLayer("OVERLAY", 7)
		item.ranse = item:CreateTexture(nil, "OVERLAY");
	    item.ranse:SetTexture("Interface/Buttons/UI-ActionButton-Border");
	    item.ranse:SetBlendMode("ADD");
	    item.ranse:SetSize(uiWidth*1.74,uiWidth*1.74);
	    item.ranse:SetPoint("CENTER", item, "CENTER", 0, 0);
	    item.ranse:Hide()
	end
	---装备列表
	Create.PIGItemListUI(frameX)
	----重置远程UI数据
	function frameX:CZ_yuancheng_Data(gongneng)
		frameX.PlayerData = {}
		frameX.allmsg=""
		frameX.LevelText:SetText("|cffFFFF00正在获取目标信息...|r");
		frameX.tishi.t:SetText("["..addonName.."]\n"..gongneng..INSPECT)
		if not ElvUI and not NDui then
			frameX.Portrait:SetTexture(130899)
			frameX.Portrait:SetTexCoord(0,1,0,1);
		end
		for i=1,#InvSlot["CID"] do
			local fujiframe = frameX.ItemList[InvSlot["CID"][i]]
			fujiframe.ZLV:SetText("")
			fujiframe.ranse:Hide()
			local invSlotId,SlotTexture = GetInventorySlotInfo(InvSlot["Name"][InvSlot["CID"][i]][1])
			fujiframe.icon:SetTexture(SlotTexture)
			fujiframe:SetScript("OnEnter", nil);
			fujiframe:SetScript("OnLeave", function ()
				GameTooltip:ClearLines();
				GameTooltip:Hide() 
			end);
		end
		frameX.ZBLsit:CZ_ItemList()
		frameX:Show()
	end
	function frameX:Update_ShowItem_List(zbData,laiyuan)
		for k,v in pairs(zbData) do
			local _,itemLink = GetItemInfo(v) 
			if not itemLink and self.ZBLsit<5 then
				C_Timer.After(0.1,function()
					self.ZBLsit.ShowItemNum=self.ZBLsit.ShowItemNum+1
					self:Update_ShowItem_List(zbData,laiyuan)
				end)
				return
			end
		end
		local NewzbData = {}
		for k,v in pairs(zbData) do
			local _,itemLink = GetItemInfo(v) 
			NewzbData[k]=itemLink
		end
		for k,v in pairs(NewzbData) do
			local invFff = self.ItemList[k]
			local itemName,itemLink,itemQuality,itemLevel,itemMinLevel,itemType,itemSubType,itemStackCount,itemEquipLoc,itemTexture= GetItemInfo(v)
			SetItemButtonTexture(invFff, itemTexture);
			invFff:SetScript("OnEnter", function (self)
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:SetHyperlink(itemLink)
				GameTooltip:Show();
			end);
			if k~=4 and k~=19 then
				if PIGA["FramePlus"]["Character_ItemLevel"] then
					if itemLevel and itemLevel>0 then
						invFff.ZLV:SetText(itemLevel)
						local r, g, b, hex = GetItemQualityColor(itemQuality)
						invFff.ZLV:SetTextColor(r, g, b, 1);
					end
				end
				if PIGA["FramePlus"]["Character_ItemColor"] then
				    if itemQuality and itemQuality>1 then
				        local r, g, b = GetItemQualityColor(itemQuality);
				        invFff.ranse:SetVertexColor(r, g, b);
						invFff.ranse:Show()
					end
				end
			end
		end
		self.ZBLsit:Update_ItemList(laiyuan,NewzbData)
	end
	return frameX
end
--创建背包银行界面
function Create.BagBankFrame(fuji,Point,UIName,data,FrameLevel)
	local WH={data["meihang"]*(data["ButW"])+8,200}
	local frameX
	if ElvUI or NDui then
		frameX = PIGFrame(fuji,Point,WH,UIName,true)
		frameX:PIGSetBackdrop()
		frameX:PIGSetMovable()
		frameX:PIGClose()
		local TitleText = PIGFontString(frameX,{"TOP", frameX, "TOP",0, -6},nil,nil,nil,UIName.."TitleText")
		TitleText:SetTextColor(1, 1, 1, 1)
		frameX.moneyframe = CreateFrame("Frame", nil, frameX);
		frameX.moneyframe:SetSize(160,22);
		frameX.moneyframe:SetPoint("BOTTOMRIGHT", frameX, "BOTTOMRIGHT", -8, 7)
	else
		if PIG_MaxTocversion() then
			frameX = CreateFrame("Frame", UIName, fuji,"BackdropTemplate")
			Create.BagBankFrameBG(frameX)
			frameX.Close = CreateFrame("Button",nil,frameX, "UIPanelCloseButton");  
			frameX.Close:SetSize(32,32);
			frameX.Close:SetPoint("TOPRIGHT", frameX, "TOPRIGHT", 4.8, -6);
		else
			frameX = CreateFrame("Frame", UIName, fuji,"PortraitFrameFlatTemplate")
		end
		frameX:Hide()
		tinsert(UISpecialFrames,UIName);
		if WH then
			frameX:SetSize(WH[1],WH[2]);
		end
		if Point then
			frameX:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
		end
		Create.PIGSetMovable(frameX)
		--
		frameX.portrait=frameX.portrait or frameX.PortraitContainer and frameX.PortraitContainer.portrait
		SetPortraitToTexture(frameX.portrait, 130899)
	end
	frameX:SetScale(data["suofang"])
	frameX.wupin = CreateFrame("Frame", nil, frameX,"BackdropTemplate")
	if PIG_MaxTocversion() then
		frameX.wupin:SetBackdrop( { bgFile = "interface/framegeneral/ui-background-marble.blp" });
		if ElvUI or NDui then
			frameX.wupin:SetBackdropColor(0, 0, 0, 0.3);
			frameX.wupin:SetPoint("TOPLEFT", frameX, "TOPLEFT",6, -56);
			frameX.wupin:SetPoint("BOTTOMRIGHT", frameX, "BOTTOMRIGHT", -6, 29);
		else
			frameX.wupin:SetPoint("TOPLEFT", frameX, "TOPLEFT",17, -66);
			frameX.wupin:SetPoint("BOTTOMRIGHT", frameX, "BOTTOMRIGHT", -5, 29);
		end
	else
		frameX.wupin:SetPoint("TOPLEFT", frameX, "TOPLEFT",6, -56);
		frameX.wupin:SetPoint("BOTTOMRIGHT", frameX, "BOTTOMRIGHT", -6, 29);
	end
	frameX.wupin:EnableMouse(true)
	frameX:SetUserPlaced(false)
	if FrameLevel then
		frameX:SetFrameLevel(FrameLevel)
	end
	frameX.meihang=data["meihang"]
	frameX.suofang=data["suofang"]
	return frameX
end
--暴雪浏览界面标题
function Create.PIGBrowseBiaoti(fuji)
	local TexC = fuji:CreateTexture(nil, "BORDER");
	TexC:SetTexture("interface/friendsframe/whoframe-columntabs.blp");
	TexC:SetTexCoord(0.08,0.00,0.08,0.59,0.91,0.00,0.91,0.59);
	TexC:SetPoint("TOPLEFT",fuji,"TOPLEFT",5,0);
	TexC:SetPoint("BOTTOMRIGHT",fuji,"BOTTOMRIGHT",-5,0);
	local TexL = fuji:CreateTexture(nil, "BORDER");
	TexL:SetTexture("interface/friendsframe/whoframe-columntabs.blp");
	TexL:SetTexCoord(0.00,0.00,0.00,0.59,0.08,0.00,0.08,0.59);
	TexL:SetPoint("TOPRIGHT",TexC,"TOPLEFT",0,0);
	TexL:SetPoint("BOTTOMRIGHT",TexC,"BOTTOMLEFT",0,0);
	TexL:SetWidth(5)
	local TexR = fuji:CreateTexture(nil, "BORDER");
	TexR:SetTexture("interface/friendsframe/whoframe-columntabs.blp");
	TexR:SetTexCoord(0.91,0.00,0.91,0.59,0.97,0.00,0.97,0.59);
	TexR:SetPoint("TOPLEFT",TexC,"TOPRIGHT",0,0);
	TexR:SetPoint("BOTTOMLEFT",TexC,"BOTTOMRIGHT",0,0);
	TexR:SetWidth(5)
	return TexC,TexL,TexR
end