local addonName, addonTable = ...;
local sub = _G.string.sub
local gsub = _G.string.gsub
local match = _G.string.match
local _, _, _, tocversion = GetBuildInfo()
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGFontString=Create.PIGFontString
local PIGItemListUI=Create.PIGItemListUI
-------------
local Data=addonTable.Data
local TalentData=Data.TalentData
local InvSlot=Data.InvSlot
local Fun=addonTable.Fun
local jieya_NumberString=Fun.jieya_NumberString
local GetEquipmTXT=Fun.GetEquipmTXT
local HY_EquipmTXT=Fun.HY_EquipmTXT
local GetRuneTXT=Fun.GetRuneTXT
local HY_RuneTXT=Fun.HY_RuneTXT
---
local ALA_tiquMsg=addonTable.ALA.ALA_tiquMsg
--------
local function PIG_ClassInfo(id)
	if tocversion<20000 then
		local className, classFile=GetClassInfo(id)
		return className, classFile
	else
		local classInfo=C_CreatureInfo.GetClassInfo(id)
		return classInfo["className"],classInfo["classFile"]
	end
end
--暴雪角色装备界面+装备列表
local function ADD_CharacterFrame(fuji,Point,laiyuan,FrameLevel)
	local frameX
	if ElvUI or NDui then
		frameX = PIGFrame(fuji,Point,{340,419},laiyuan,true)
		if tocversion<80000 then
			if ElvUI then
				frameX:SetSize(336,419);
			elseif NDui then
				frameX:SetSize(334,419);
			end
		end
		if Point then
			if ElvUI then
				frameX:SetPoint(Point[1],Point[2],Point[3],Point[4]+12,Point[5]-13);
			else
				frameX:SetPoint(Point[1],Point[2],Point[3],Point[4]+15,Point[5]-14);
			end
		end
		frameX:PIGSetBackdrop(0.88)
		frameX:PIGSetMovable()
		frameX:SetUserPlaced(false)
		frameX:SetScript("OnDragStop",function()
			frameX:StopMovingOrSizing()
			frameX:SetUserPlaced(false) 
		end)
		frameX:PIGClose();
		frameX.TitleText = PIGFontString(frameX,{"TOP", frameX, "TOP",8, -8},"")
		frameX.LevelText = PIGFontString(frameX,{"TOP", frameX, "TOP",8, -34},"")
		frameX.InspectPaperDoll = CreateFrame("Frame", nil, frameX)
		frameX.InspectPaperDoll:SetPoint("TOPLEFT",frameX,"TOPLEFT",2,-56)
		frameX.InspectPaperDoll:SetPoint("BOTTOMRIGHT",frameX,"BOTTOMRIGHT",-6,4)
	else
		if tocversion<80000 then
			frameX = CreateFrame("Frame", laiyuan, fuji)
			frameX:SetSize(384,512);
			if Point then
				frameX:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
			end
			frameX:SetMovable(true)	
			frameX:SetUserPlaced(false) 
		    frameX.Portrait_BG = frameX:CreateTexture(nil, "BACKGROUND");
			frameX.Portrait_BG:SetTexture("interface/buttons/iconborder-glowring.blp");
			frameX.Portrait_BG:SetSize(60,60);
			frameX.Portrait_BG:SetPoint("TOPLEFT",frameX,"TOPLEFT",9,-7.8);
			frameX.Portrait_BG:SetDrawLayer("BACKGROUND", -2)
			frameX.Portrait_BGmask = frameX:CreateMaskTexture()
			frameX.Portrait_BGmask:SetAllPoints(frameX.Portrait_BG)
			frameX.Portrait_BGmask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
			frameX.Portrait_BG:AddMaskTexture(frameX.Portrait_BGmask)
			frameX.Portrait = frameX:CreateTexture(nil, "BACKGROUND");
			frameX.Portrait:SetSize(60,60);
		    frameX.Portrait:SetPoint("TOPLEFT", frameX, "TOPLEFT", 8, -7);
		    frameX.InspectName = CreateFrame("Frame", nil, frameX)
		    frameX.InspectName:SetSize(180,16);
		    frameX.InspectName:SetPoint("TOP", frameX, "TOP", 8, -17);
		    frameX.InspectName:SetFrameLevel(frameX.InspectName:GetFrameLevel()+2)
			frameX.InspectName:EnableMouse(true)
			frameX.InspectName:RegisterForDrag("LeftButton")
			frameX.InspectName:SetScript("OnDragStart",function(self)
				frameX:StartMoving()
			end)
			frameX.InspectName:SetScript("OnDragStop",function(self)
				frameX:StopMovingOrSizing()
				frameX:SetUserPlaced(false) 
			end)
			frameX.InspectName:SetClampedToScreen(true)
		   	frameX.TitleText = PIGFontString(frameX.InspectName,{"CENTER", frameX.InspectName, "CENTER",0, 0},"")
			frameX.LevelText = PIGFontString(frameX.InspectName,{"TOP", frameX, "TOP",8, -40},"")
			frameX.Close = CreateFrame("Button",nil,frameX, "UIPanelCloseButton");
		    frameX.Close:SetPoint("CENTER", frameX, "TOPRIGHT", -44, -25);
		   
			frameX.InspectPaperDoll = CreateFrame("Frame", nil, frameX)
			frameX.InspectPaperDoll:SetAllPoints(frameX)
			frameX.InspectPaperDoll.L1 = frameX.InspectPaperDoll:CreateTexture(nil, "BORDER");
		    frameX.InspectPaperDoll.L1:SetTexture("Interface/PaperDollInfoFrame/UI-Character-CharacterTab-L1");
		    frameX.InspectPaperDoll.L1:SetSize(256,256);
		    frameX.InspectPaperDoll.L1:SetPoint("TOPLEFT");
		    frameX.InspectPaperDoll.R1 = frameX.InspectPaperDoll:CreateTexture(nil, "BORDER");
		    frameX.InspectPaperDoll.R1:SetTexture("Interface/PaperDollInfoFrame/UI-Character-CharacterTab-R1");
		    frameX.InspectPaperDoll.R1:SetSize(128,256);
		    frameX.InspectPaperDoll.R1:SetPoint("TOPLEFT",256,0);
		    frameX.InspectPaperDoll.B1 = frameX.InspectPaperDoll:CreateTexture(nil, "BORDER");
		    frameX.InspectPaperDoll.B1:SetTexture("Interface/PaperDollInfoFrame/UI-Character-CharacterTab-BottomLeft");
		    frameX.InspectPaperDoll.B1:SetSize(256,256);
		    frameX.InspectPaperDoll.B1:SetPoint("TOPLEFT",0,-256);
		    frameX.InspectPaperDoll.Br = frameX.InspectPaperDoll:CreateTexture(nil, "BORDER");
		    frameX.InspectPaperDoll.Br:SetTexture("Interface/PaperDollInfoFrame/UI-Character-CharacterTab-BottomRight");
		    frameX.InspectPaperDoll.Br:SetSize(128,256);
		    frameX.InspectPaperDoll.Br:SetPoint("TOPLEFT",256,-256);
		else
			frameX = CreateFrame("Frame", laiyuan, fuji,"ButtonFrameTemplate")
			frameX:SetSize(338,424);
			if Point then
				frameX:SetPoint(Point[1],Point[2],Point[3],Point[4]+16,Point[5]-12);
			end
			frameX.Inset:SetPoint("BOTTOMRIGHT", frameX, "BOTTOMRIGHT", -6, 4);
			frameX.InspectPaperDoll = frameX.Inset
			frameX.Portrait=_G[laiyuan.."Portrait"]
			frameX.TitleText = frameX.TitleContainer.TitleText
			frameX.LevelText = PIGFontString(frameX.TitleContainer,{"TOP", frameX, "TOP",8, -30},"")	
		end
		frameX:Hide()
		tinsert(UISpecialFrames,laiyuan);
	end
	--
	frameX.TitleText:SetTextColor(1, 1, 1, 1)
	frameX.tishi = CreateFrame("Frame", nil, frameX)
    frameX.tishi:SetSize(200,150);
    if tocversion<80000 then
    	frameX.tishi:SetPoint("CENTER", frameX, "CENTER", 0, 30);
    else
    	frameX.tishi:SetPoint("CENTER", frameX, "CENTER", 10, 30);
    end	
    frameX.tishi:SetFrameLevel(frameX:GetFrameLevel()+3)
    frameX.tishi.t = PIGFontString(frameX.tishi,{"CENTER", frameX.tishi, "CENTER",-4, 20})
	---
	if FrameLevel then
		frameX:SetFrameLevel(FrameLevel)
	end
	--
	frameX.InspectPaperDoll.Items = CreateFrame("Frame", nil, frameX.InspectPaperDoll)
	frameX.InspectPaperDoll.Items:SetPoint("TOPLEFT",frameX.InspectPaperDoll,"TOPLEFT",0,0)
	frameX.InspectPaperDoll.Items:SetPoint("BOTTOMRIGHT",frameX.InspectPaperDoll,"BOTTOMRIGHT",0,0)
	
	local uiWidth=CharacterHeadSlot:GetWidth()
	for i=1,#InvSlot["CID"] do
		local item
		if tocversion<100000 then
			item = CreateFrame("Button", laiyuan.."_item_"..InvSlot["CID"][i], frameX.InspectPaperDoll.Items);
			item:SetHighlightTexture(130718);
			item.icon = item:CreateTexture()
			item.icon:SetAllPoints(item)
		else
			item = CreateFrame("ItemButton", laiyuan.."_item_"..InvSlot["CID"][i], frameX.InspectPaperDoll.Items);
		end
		item:SetSize(uiWidth,uiWidth);
		item.Frame = item:CreateTexture(nil, "BACKGROUND")
		if ElvUI or NDui then
			item.icon:SetTexCoord(0.08,0.92,0.08,0.92)
			--item.NormalTexture:SetAlpha(0)
			item.Frame:SetTexture("");
		else
			item.Frame:SetTexture("Interface/CharacterFrame/Char-Paperdoll-Parts");
		end
		item.Frame:SetDrawLayer("BACKGROUND", -1)
		if i<17 then
			item.Frame:SetSize(uiWidth*1.3,uiWidth*1.26);
			if i<9 then 
				item.Frame:SetTexCoord(0.20703125,0.39843750,0.59375000,0.93750000)
				item.Frame:SetPoint("TOPLEFT",item,"TOPLEFT",-4.4,2);
			end
			if i>8 and i<17 then
				item.Frame:SetTexCoord(0.00390625,0.19921875,0.59375000,0.93750000)
				item.Frame:SetPoint("TOPRIGHT",item,"TOPRIGHT",4,2);
			end
			if i==1 then
				if tocversion<80000 then
					if ElvUI or NDui then
						item:SetPoint("TOPLEFT",frameX.InspectPaperDoll.Items,"TOPLEFT",4,-4);
					else
						item:SetPoint("TOPLEFT",frameX.InspectPaperDoll.Items,"TOPLEFT",21,-74);
					end
				else
					item:SetPoint("TOPLEFT",frameX.InspectPaperDoll.Items,"TOPLEFT",6,-4);
				end
			elseif i==9 then
				if tocversion<80000 then
					if ElvUI or NDui then
						item:SetPoint("TOPLEFT",frameX.InspectPaperDoll.Items,"TOPLEFT",290,-4);
					else
						item:SetPoint("TOPLEFT",frameX.InspectPaperDoll.Items,"TOPLEFT",306,-74);
					end
				else
					item:SetPoint("TOPLEFT",frameX.InspectPaperDoll.Items,"TOPLEFT",290,-4);
				end
			else
				item:SetPoint("TOP", _G[laiyuan.."_item_"..(InvSlot["CID"][i-1])], "BOTTOM", 0, -4);
			end
		else
			item.Frame:SetSize(uiWidth*1.16,uiWidth*1.42);
			item.Frame:SetTexCoord(0.67187500,0.83593750,0.00781250,0.42187500)
			item.Frame:SetPoint("TOPLEFT",item,"TOPLEFT",-4,8);
			if i==17 then
				if tocversion<80000 then
					if ElvUI or NDui then
						item:SetPoint("TOPLEFT",frameX.InspectPaperDoll.Items,"BOTTOMLEFT",104,44);
					else
						item:SetPoint("TOPLEFT",frameX.InspectPaperDoll.Items,"BOTTOMLEFT",122,127);
					end
				else
					item:SetPoint("TOPLEFT",frameX.InspectPaperDoll.Items,"BOTTOMLEFT",122,49);
				end
			else
				item:SetPoint("LEFT", _G[laiyuan.."_item_"..(InvSlot["CID"][i-1])], "RIGHT", 4, 0);
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
	PIGItemListUI(frameX)
	return frameX
end
--------------------------------------------
local SendAddonMessage = C_ChatInfo and C_ChatInfo.SendAddonMessage or SendAddonMessage;
local pig_PREFIX="!Pig-YCIN";
local ala_PREFIX = "ATEADD"
local td_PREFIX = "tdInspect"
local YCinfo_GET_MSG = {"!GETALL","!GETT-","!GETG-","!GETR-","!GETI-"};
local RegisterAddonMessagePrefix = C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix or RegisterAddonMessagePrefix;
local IsAddonMessagePrefixRegistered = C_ChatInfo and C_ChatInfo.IsAddonMessagePrefixRegistered or IsAddonMessagePrefixRegistered;
RegisterAddonMessagePrefix(pig_PREFIX)
---------------
local function Update_ShowItem_List(zbData,laiyuan)
	for k,v in pairs(zbData) do
		local _,itemLink = GetItemInfo(v) 
		if not itemLink and yuanchengCFrame.ZBLsit<5 then
			C_Timer.After(0.1,function()
				yuanchengCFrame.ZBLsit.ShowItemNum=yuanchengCFrame.ZBLsit.ShowItemNum+1
				Update_ShowItem_List(zbData,laiyuan)
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
		local invFff = _G["yuanchengCFrame_item_"..k]
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
	yuanchengCFrame.ZBLsit:Update_ItemList(laiyuan,NewzbData)
end
local function Update_ShowItem(itemstxt,laiyuan)
	local zbData = {}
	if not itemstxt then return end
	for k,v in pairs(itemstxt) do
		zbData[k]=v
	end
	for k,v in pairs(zbData) do
		GetItemInfo(v)
	end
	C_Timer.After(0.1,function()
		yuanchengCFrame.ZBLsit.ShowItemNum=0
		Update_ShowItem_List(zbData,laiyuan)
	end)
end
Fun.Update_ShowItem=Update_ShowItem
local function Update_ShowPlayer(Player,lyfrome)
	local class,race,level,itemLV = unpack(Player)
	local className, classFile = PIG_ClassInfo(class)
	local raceName = "  "
	if tonumber(race)>0 then
		local raceInfo = C_CreatureInfo.GetRaceInfo(race)
		raceName=raceInfo["raceName"]
	end
	yuanchengCFrame.LevelText:SetText(LEVEL..level.." "..raceName.." "..className);
	if not ElvUI and not NDui then
		yuanchengCFrame.Portrait:SetTexture("interface/targetingframe/ui-classes-circles.blp")
		local coords = CLASS_ICON_TCOORDS[classFile]
		yuanchengCFrame.Portrait:SetTexCoord(unpack(coords));
	end
	yuanchengCFrame.ZBLsit.level=level
	yuanchengCFrame.ZBLsit.zhiyeID=class
	yuanchengCFrame.ZBLsit.zhiye=classFile
	yuanchengCFrame.ZBLsit.itemLV=itemLV
	yuanchengCFrame.ZBLsit:Update_Player(lyfrome)
end
Fun.Update_ShowPlayer=Update_ShowPlayer
--处理获取信息
local function PIG_FormatData(msgx,nameX)
	local jiequkaishi = 1
	local datalist= {}  	  
	for i = 1, #msgx do  
	    local kshi, jieshu, msgx1 = msgx:find("(#[^#]+)", jiequkaishi) 
	    if kshi then
	    	jiequkaishi=jieshu+1
	   		table.insert(datalist, msgx1)  
	    end  
	end
	local yxwjinfo = {}
	for i=1,#datalist do
		local xinximsg = datalist[i]
		local qianzhui = xinximsg:sub(1, 2)
		if qianzhui == "#P" then
			yxwjinfo[1] = {strsplit("-", xinximsg:sub(3, -1))};
		elseif qianzhui == "#T" then
			local Tianfu,Tianfu2 =TalentData.HY_TianfuTXT(xinximsg:sub(3, -1))
			Pig_OptionsUI.talentData[nameX]["T"]={GetServerTime(),Tianfu,Tianfu2}
		elseif qianzhui == "#G" then
			local fwData,fwData2=TalentData.HY_GlyphTXT(xinximsg:sub(3, -1))
			Pig_OptionsUI.talentData[nameX]["G"]={GetServerTime(),fwData,fwData2}
		elseif qianzhui == "#R" then
			local fwData=HY_RuneTXT(xinximsg:sub(3, -1))
			Pig_OptionsUI.talentData[nameX]["R"]={GetServerTime(),fwData}
		elseif qianzhui == "#E" then
			yxwjinfo[2]=HY_EquipmTXT(xinximsg:sub(3, -1))
		end
	end
	Update_ShowPlayer(yxwjinfo[1],"yc")
	Update_ShowItem(yxwjinfo[2],"yc")
end
local function PIG_tiquMsg(msgx,nameX)
	if yuanchengCFrame:IsShown() and yuanchengCFrame.fullnameX==nameX then
		local qianzhui = msgx:sub(1, 2)
		if qianzhui == "!P" then
			if not msgx:match("@") then
				yuanchengCFrame.fanhuiYN=true
				local allnum = msgx:sub(3, 3)
				local danqian = msgx:sub(4, 4)
				if danqian=="1" then
					yuanchengCFrame.allmsg=msgx:sub(5, -1)
				else
					yuanchengCFrame.allmsg=yuanchengCFrame.allmsg..msgx:sub(5, -1)
				end
				if allnum==danqian then
					PIG_FormatData(yuanchengCFrame.allmsg,nameX)
				end
			end
		end
	end
	if InspectFrame and InspectFrame:IsShown() and InspectNameText:GetText()==nameX or Tardis_UI and Tardis_UI:IsShown() then--观察/时空
		local qianzhui = msgx:sub(1, 3)
		if qianzhui == "!T-" or qianzhui == "!G-" or qianzhui == "!R-" then
			local leixing = msgx:sub(2, 2)	
			if leixing == "T" then
				yuanchengCFrame.fanhuiYN_TF=true
				local Tianfu,Tianfu2 =TalentData.HY_TianfuTXT(msgx:sub(4, -1))
				Pig_OptionsUI.talentData[nameX][leixing]={GetServerTime(),Tianfu,Tianfu2}
			end
			if leixing == "G" then
				yuanchengCFrame.fanhuiYN_GG=true
				local dwData,dwData2=TalentData.HY_GlyphTXT(msgx:sub(4, -1))
				Pig_OptionsUI.talentData[nameX][leixing]={GetServerTime(),dwData,dwData2}
			end
			if leixing == "R" then
				yuanchengCFrame.fanhuiYN_RR=true
				local fwData=HY_RuneTXT(msgx:sub(4, -1))
				Pig_OptionsUI.talentData[nameX][leixing]={GetServerTime(),fwData}
			end
			if leixing == "I" then
				yuanchengCFrame.fanhuiYN_II=true
				local fwData=HY_RuneTXT(msgx:sub(4, -1))
				Pig_OptionsUI.talentData[nameX][leixing]={GetServerTime(),fwData}
			end
		end
	end
end
--没有获取到目标信息
local function alaGet_Fun_1()
	if not yuanchengCFrame.fanhuiYN then
		SendAddonMessage(ala_PREFIX, "!Q32TGE", "WHISPER", yuanchengCFrame.fullnameX);
	end
end
local function alaGet_Fun_2()
	if not yuanchengCFrame.fanhuiYN then
		SendAddonMessage(ala_PREFIX, "_q_tal", "WHISPER", yuanchengCFrame.fullnameX);
		SendAddonMessage(ala_PREFIX, "_q_equ", "WHISPER", yuanchengCFrame.fullnameX);		
	end
end
local function ycNull_Fun()
	if not yuanchengCFrame.fanhuiYN then
		yuanchengCFrame.LevelText:SetText("|cffFF0000获取失败\n目标未安装!Pig插件或版本过期|r");
	end
end
local function GetDATA_YN()
	if yuanchengCFrame.alaGet_1 then yuanchengCFrame.alaGet_1:Cancel() end
	yuanchengCFrame.alaGet_1=C_Timer.NewTimer(1,alaGet_Fun_1)
	if yuanchengCFrame.alaGet_2 then yuanchengCFrame.alaGet_2:Cancel() end
	yuanchengCFrame.alaGet_2=C_Timer.NewTimer(2,alaGet_Fun_2)
	if yuanchengCFrame.ycNull then yuanchengCFrame.ycNull:Cancel() end
	yuanchengCFrame.ycNull=C_Timer.NewTimer(3,ycNull_Fun)
end
local function GetDATA_YN_TF(fullnameX)
	if yuanchengCFrame.alaGet_TF then yuanchengCFrame.alaGet_TF:Cancel() end
	yuanchengCFrame.alaGet_TF=C_Timer.NewTimer(0.8,function()
		if not yuanchengCFrame.fanhuiYN_TF then
			SendAddonMessage(ala_PREFIX, "!Q32T", "WHISPER", fullnameX);
		end
	end)
end
local function GetDATA_YN_GG(fullnameX)
	if yuanchengCFrame.alaGet_GG then yuanchengCFrame.alaGet_GG:Cancel() end
	yuanchengCFrame.alaGet_GG=C_Timer.NewTimer(0.8,function()
		if not yuanchengCFrame.fanhuiYN_GG then
			SendAddonMessage(ala_PREFIX, "!Q32G", "WHISPER", fullnameX);
		end
	end)
end
local function GetDATA_YN_RR(fullnameX)
	if yuanchengCFrame.alaGet_RR then yuanchengCFrame.alaGet_RR:Cancel() end
	yuanchengCFrame.alaGet_RR=C_Timer.NewTimer(0.8,function()
		if not yuanchengCFrame.fanhuiYN_RR then
			SendAddonMessage(ala_PREFIX, "!Q32R", "WHISPER", fullnameX);
		end
	end)
end
----重置远程UI数据
local function CZ_yuancheng_Data(gongneng)
	yuanchengCFrame.PlayerData = {}
	yuanchengCFrame.allmsg=""
	yuanchengCFrame.LevelText:SetText("|cffFFFF00正在获取目标信息...|r");
	yuanchengCFrame.tishi.t:SetText("!Pig\n"..gongneng..INSPECT)
	if not ElvUI and not NDui then
		yuanchengCFrame.Portrait:SetTexture(130899)
		yuanchengCFrame.Portrait:SetTexCoord(0,1,0,1);
	end
	for i=1,#InvSlot["CID"] do
		local fujiframe = _G["yuanchengCFrame_item_"..InvSlot["CID"][i]]
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
	yuanchengCFrame.ZBLsit:CZ_ItemList()
	yuanchengCFrame:Show()
end
local function FasongYCqingqiu(fullnameX,iidd)
	Pig_OptionsUI.talentData[fullnameX]=Pig_OptionsUI.talentData[fullnameX] or {}
	local iidd=iidd or 1
	if iidd==1 then
		if InspectFrame and InspectFrame:IsShown() then InspectFrame:Hide() end
		yuanchengCFrame.fanhuiYN=false
		SendAddonMessage(pig_PREFIX,YCinfo_GET_MSG[iidd], "WHISPER", fullnameX)
		yuanchengCFrame.TitleText:SetText(fullnameX);
		yuanchengCFrame.fullnameX=fullnameX
		GetDATA_YN()
		CZ_yuancheng_Data(INVTYPE_RANGED)
	elseif iidd==2 then--只请求天赋信息
		if not Pig_OptionsUI.talentData[fullnameX]["T"] or GetServerTime()-Pig_OptionsUI.talentData[fullnameX]["T"][1]>10 then
			yuanchengCFrame.fanhuiYN_TF=false
			SendAddonMessage(pig_PREFIX,YCinfo_GET_MSG[iidd], "WHISPER", fullnameX)
			GetDATA_YN_TF(fullnameX)
		end
	elseif iidd==3 then--只请求雕文信息
		if not Pig_OptionsUI.talentData[fullnameX]["G"] or GetServerTime()-Pig_OptionsUI.talentData[fullnameX]["G"][1]>10 then
			yuanchengCFrame.fanhuiYN_GG=false
			SendAddonMessage(pig_PREFIX,YCinfo_GET_MSG[iidd], "WHISPER", fullnameX)
			GetDATA_YN_GG(fullnameX)
		end
	elseif iidd==4 then--只请求符文信息
		if not Pig_OptionsUI.talentData[fullnameX]["R"] or GetServerTime()-Pig_OptionsUI.talentData[fullnameX]["R"][1]>10 then
			yuanchengCFrame.fanhuiYN_RR=false
			SendAddonMessage(pig_PREFIX,YCinfo_GET_MSG[iidd], "WHISPER", fullnameX)
			GetDATA_YN_RR(fullnameX)
		end
	elseif iidd==5 then--只请求角色信息
		if not Pig_OptionsUI.talentData[fullnameX]["I"] or GetServerTime()-Pig_OptionsUI.talentData[fullnameX]["I"][1]>10 then
			yuanchengCFrame.fanhuiYN_II=false
			SendAddonMessage(pig_PREFIX,YCinfo_GET_MSG[iidd], "WHISPER", fullnameX)
		end
	end
end
Fun.FasongYCqingqiu=FasongYCqingqiu
-----
local function lixian_chakan(fullnameX,renwu,itemdata)
	if InspectFrame and InspectFrame:IsShown() then InspectFrame:Hide() end
	yuanchengCFrame.TitleText:SetText(fullnameX);
	yuanchengCFrame.fullnameX=fullnameX
	CZ_yuancheng_Data(FRIENDS_LIST_OFFLINE)
	Update_ShowPlayer({renwu[4],renwu[2],renwu[5]},"lx")
	local zbtxtlist=HY_EquipmTXT(PIGA["StatsInfo"]["Items"][fullnameX]["C"])
	Update_ShowItem(zbtxtlist,"lx")
end
Fun.lixian_chakan=lixian_chakan
------------------------------------
local fengeLEN = 240
local yuanchangchakanFFF = CreateFrame("Frame")
yuanchangchakanFFF:RegisterEvent("PLAYER_LOGIN")
yuanchangchakanFFF:SetScript("OnEvent",function(self, event, arg1, arg2, _, arg4, arg5,_,_,_,arg9)
	if event=="PLAYER_LOGIN" then
		ADD_CharacterFrame(UIParent,{"TOPLEFT",UIParent,"TOPLEFT",0, -104},"yuanchengCFrame",99)
		C_Timer.After(3,function()
			if not IsAddonMessagePrefixRegistered(ala_PREFIX) then
				RegisterAddonMessagePrefix(ala_PREFIX)
			end
			if not IsAddonMessagePrefixRegistered(td_PREFIX) then
				RegisterAddonMessagePrefix(td_PREFIX)
			end
		end)
		self:RegisterEvent("CHAT_MSG_ADDON")
		Pig_OptionsUI.talentData={}
	end
	if event=="CHAT_MSG_ADDON" then
		if arg1 == pig_PREFIX then
			if arg2==YCinfo_GET_MSG[1] then
				local Player =TalentData.SAVE_Player()
				local Tianfu =TalentData.GetTianfuTXT()
				local Glyph =TalentData.GetGlyphTXT()
				local Rune =GetRuneTXT()
				local Items =GetEquipmTXT()
				local infoall = "#P"..Player.."#T"..Tianfu.."#G"..Glyph.."#R"..Rune.."#E"..Items
				local msglen = strlen(infoall)
				if msglen>fengeLEN then
					local fasongcishu = math.ceil(msglen/fengeLEN)
					for ic=1,fasongcishu do
						local jiequK = (ic-1)*fengeLEN+1
						local jiequJ = ic*fengeLEN
						if ic==fasongcishu then
							jiequJ = -1
						end
						local NewMsg1 = infoall:sub(jiequK,jiequJ)
						SendAddonMessage(pig_PREFIX, "!P"..fasongcishu..ic..NewMsg1, "WHISPER", arg5)
					end		
				else
					SendAddonMessage(pig_PREFIX, "!P11"..infoall, "WHISPER", arg5)
				end
			elseif arg2==YCinfo_GET_MSG[2] then
				local info =TalentData.GetTianfuTXT()
				SendAddonMessage(pig_PREFIX, "!T-"..info, "WHISPER", arg5)
			elseif arg2==YCinfo_GET_MSG[3] then
				local info =TalentData.GetGlyphTXT()
				SendAddonMessage(pig_PREFIX, "!G-"..info, "WHISPER", arg5)
			elseif arg2==YCinfo_GET_MSG[4] then
				local info =GetRuneTXT()
				SendAddonMessage(pig_PREFIX, "!R-"..info, "WHISPER", arg5)
			elseif arg2==YCinfo_GET_MSG[5] then
				local Player =TalentData.SAVE_Player()
				SendAddonMessage(pig_PREFIX, "!I-"..Player, "WHISPER", arg5)
			else
				PIG_tiquMsg(arg2,arg5)
			end
		elseif arg1==ala_PREFIX then
			ALA_tiquMsg(arg2,arg5)
		elseif arg1==td_PREFIX then
			--TD_tiquMsg(arg2,arg5)
		end
	end
end)