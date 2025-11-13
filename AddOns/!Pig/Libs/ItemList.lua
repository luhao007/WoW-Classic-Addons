local addonName, addonTable = ...;
local L=addonTable.locale
local match = _G.string.match
local find = _G.string.find
--
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
local BackdropColor=Create.BackdropColor
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
local PIGDiyTex=Create.PIGDiyTex
---
local Data=addonTable.Data
local InvSlot=Data.InvSlot
local EnchantItemID=Data.EnchantItemID
local EnchantSpellID=Data.EnchantSpellID
local EnchantSlot=Data.EnchantSlot
local EngravingSlot=Data.EngravingSlot
local EnchantSlotID=Data.EnchantSlotID
local TalentData=Data.TalentData
--
local Fun=addonTable.Fun
local GetRuneData=Fun.GetRuneData
local _GetItemLevel=Fun._GetItemLevel
local _GetAverageItemLevel=Fun._GetAverageItemLevel
local _Get_GEM_EMPTY_SOCKET=Fun._Get_GEM_EMPTY_SOCKET
local GetItemStats=GetItemStats or C_Item and C_Item.GetItemStats
local GetItemGem=GetItemGem or C_Item and C_Item.GetItemGem
local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
local GetDetailedItemLevelInfo=GetDetailedItemLevelInfo or C_Item and C_Item.GetDetailedItemLevelInfo
local GetSpecialization = GetSpecialization or C_SpecializationInfo and C_SpecializationInfo.GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo or C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo
-------------
local ListWWWHHH = {206,425,18,36,6}--3hangH,Gembut/4buweiW/5宝石+附魔+符文数
--宝石槽位信息
local function _GetGemSocket(Link)
	local datax = {}
    local statsg = GetItemStats(Link)
    if statsg then
	    for key, num in pairs(statsg) do
	        if (key:match("EMPTY_SOCKET_")) then
	            for i = 1, num do
	                table.insert(datax, key)
	            end
	        end
	    end
	end
    return datax
end
local function Update_GemBut(itemLink,id,GemBut,nulltishi)
	local _, GemitemLink = GetItemGem(itemLink, id)
	if not GemitemLink and GemBut.getnum<10 then
		GemBut.getnum=GemBut.getnum+1
		if GemBut.EgetnInfoC then GemBut.EgetnInfoC:Cancel() end
		GemBut.EgetnInfoC=C_Timer.NewTimer(0.2,function()
			Update_GemBut(itemLink,id,GemBut,nulltishi)
		end)
	else
		if GemitemLink then
			GemBut.icon:SetDesaturated(false)
	       	local _, _, quality, _, _, _, _, _, _, texture = GetItemInfo(GemitemLink)
	       	local r, g, b = GetItemQualityColor(quality or 0)
	       	GemBut.icon:SetTexture(texture)
	    	GemBut:SetBackdropBorderColor(r, g, b, 1);
	    else
	    	GemBut.icon:SetDesaturated(true)
	    	GemBut:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	    	if nulltishi==55655 then
	    		local name, texture = PIGGetSpellInfo(55655)
	    		GemBut.icon:SetTexture(texture)
		    else
		    	GemBut.icon:SetTexture(_Get_GEM_EMPTY_SOCKET(nulltishi))
		    end
	  	end
	    GemBut:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
			if GemitemLink then
				GameTooltip:SetHyperlink(GemitemLink)
			else
				if nulltishi==55655 then
					GameTooltip:SetSpellByID(55655)
					GameTooltip:AddLine("|cff00FFFF["..addonName.."]:|r|cffFF0000"..WAISTSLOT.."未打孔|r")
				else
					GameTooltip:AddLine(_G[nulltishi])
				end
			end
			GameTooltip:Show();
		end);
	end
end
local function Update_GemListInfo(framef,itemLink)
	local GemDatax=_GetGemSocket(itemLink)
	if PIG_MaxTocversion() and PIG_MaxTocversion(29999,true) and Slot==6 then table.insert(GemDatax,55655) end
    local baoshiNUM=#GemDatax
    framef.GemNums=framef.GemNums+baoshiNUM
	for Gemid=1,baoshiNUM do
		local Gemui = framef.ButGem[Gemid]
		Gemui:SetWidth(ListWWWHHH[3])
		Gemui:SetAlpha(1)
		Gemui.getnum=0
		Update_GemBut(itemLink,Gemid,Gemui,GemDatax[Gemid])
	end
end
--附魔信息
local function PIGGetEnchantID(itemLink)
	local fumoid = itemLink:match("|?c?f?f?%x*|?Hitem:?%d+:?(%d*):?")
	if fumoid and fumoid~="" and fumoid~=" " then
		return tonumber(fumoid)
	end
	return 0
end
local function Update_EnchantInfo(EnchantBut,fumoid)
	local Newdata = {}
	if type(EnchantItemID[fumoid])=="table" then
		Newdata.ItemID=EnchantItemID[fumoid][1]
		Newdata.laiyuan=" 数据提供: "..EnchantItemID[fumoid][2]
	else
		Newdata.ItemID=EnchantItemID[fumoid]
		Newdata.laiyuan=""
	end
	GetItemInfo(Newdata.ItemID)
	local _, ItemLink, quality, _, _, _, _, _, _, texture = GetItemInfo(Newdata.ItemID)
	if ItemLink then
		EnchantBut.icon:SetTexture(texture)
		local r, g, b = GetItemQualityColor(quality or 0)
		EnchantBut:SetBackdropBorderColor(r, g, b, 1);
		EnchantBut:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
			if ItemLink then
				GameTooltip:SetHyperlink(ItemLink)
				GameTooltip:AddLine(ENCHANTS.."ID:"..fumoid..Newdata.laiyuan)
			else
				GameTooltip:AddLine("|cff00FFFF["..addonName.."]:|r"..ENCHANTS.."ID:"..fumoid..ENCHANTS..INFO..UNKNOWN)
			end

			GameTooltip:Show();
		end);
		EnchantBut:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
	else
		EnchantBut.getnum=EnchantBut.getnum+1
		if EnchantBut:GetParent():GetParent():GetParent():IsShown() then
			if EnchantBut.getnum<5 then
				if EnchantBut.EnchantInfo then EnchantBut.EnchantInfo:Cancel() end
				EnchantBut.EnchantInfo=C_Timer.NewTimer(0.2,function()
					Update_EnchantInfo(EnchantBut,fumoid)
				end)
			end
		end
	end
end
--符文
local function Show_fuwenBut(fuwenIcon,fwshuju)
	if fwshuju then				
		fuwenIcon:SetBackdropBorderColor(0, 1, 1, 0.8);
		fuwenIcon.icon:SetTexture(fwshuju[1])
		fuwenIcon.icon:SetDesaturated(false)
		fuwenIcon:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
			GameTooltip:SetEngravingRune(fwshuju[2]);
			GameTooltip:Show();
		end);
	end
end
local function Show_fuwenBut_yanchi(Parent,hangUI,fuwenIcon,k)
	if PIG_OptionsUI.talentData[Parent.cName] and PIG_OptionsUI.talentData[Parent.cName]["R"] and PIG_OptionsUI.talentData[Parent.cName]["R"][2][k] then
		Show_fuwenBut(fuwenIcon,PIG_OptionsUI.talentData[Parent.cName]["R"][2][k])
	else
		if Parent.fuwenBut_yanchi then Parent.fuwenBut_yanchi:Cancel() end
		Parent.fuwenBut_yanchi=C_Timer.NewTimer(0.3,function()
			Show_fuwenBut_yanchi(Parent,hangUI,fuwenIcon,k)
		end)
	end
end

--------------
local function Update_ItemLevel(unit,SlotID,SlotBut)
	local Parent=SlotBut:GetParent()
    local ItemDX = _GetItemLevel(unit,SlotID,SlotBut)
    if ItemDX == "RETRIEVING" and Parent.SlotOKs[SlotID].TooltipCount < 10 then
    	--print("RETRIEVING",unit,SlotID,itemLink,SlotBut,Parent.SlotOKs[SlotID].TooltipCount)
        C_Timer.After(0.05, function()
        	Parent.SlotOKs[SlotID].TooltipCount = Parent.SlotOKs[SlotID].TooltipCount + 1
        	Update_ItemLevel(unit,SlotID,SlotBut)
        end)
    else
    	Parent.SlotOKs[SlotID].laodnd=nil
    	if ItemDX then
    		local itemLevel,taodata=unpack(ItemDX)
    		Parent.SlotOKs[SlotID].tao=taodata
    		SlotBut.iLv=itemLevel
    		SlotBut.itemlink.lv:SetText(itemLevel)
    		local width = SlotBut.itemlink.t:GetStringWidth()+SlotBut.itemlink.lv:GetStringWidth()
			SlotBut.itemlink:SetWidth(width);
			SlotBut.hangMaxW = width+SlotBut.GemNums*(ListWWWHHH[3]+1)+ListWWWHHH[4]+18
			if SlotBut.hangMaxW>Parent.hangMaxW then
				Parent.hangMaxW=SlotBut.hangMaxW
			end
			Parent:SetWidth(Parent.hangMaxW)
		end
    end
end
local function Update_SlotButton(SlotBut,SlotID,zbData)
	local Parent=SlotBut:GetParent()
	local unit=Parent.unit
	local itemLink
	if unit=="lx" or unit=="yc" then
		itemLink=zbData[SlotID]
	else
		local itemId, unknown = GetInventoryItemID(unit, SlotID)
		if itemId then
			itemLink=GetInventoryItemLink(unit, SlotID)
		    if not itemLink and Parent.SlotOKs[SlotID].itemCount < 10 then
		    	Parent.SlotOKs[SlotID].itemCount = Parent.SlotOKs[SlotID].itemCount + 1
		        C_Timer.After(0.05, function()
		        	Update_SlotButton(SlotBut,SlotID,zbData)
		        end)
		        return
		    end
		end
	end
	if itemLink then
		SlotBut.itemLink=itemLink
		SlotBut.unittype=unit
		SlotBut.itemlink.t:SetText(itemLink)
		SlotBut.t:SetTextColor(0, 1, 1, 0.8);
		SlotBut:SetBackdropBorderColor(0, 1, 1, 0.5)
		Update_GemListInfo(SlotBut,itemLink)
		local fumoid = PIGGetEnchantID(itemLink)
		local Enchantui=SlotBut.ButGem[5]
		if fumoid>0 then
			SlotBut.GemNums=SlotBut.GemNums+1
			Enchantui:SetWidth(ListWWWHHH[3])
			Enchantui:SetAlpha(1)
			Enchantui.icon:SetDesaturated(false)
			if EnchantItemID[fumoid] then
				Enchantui.getnum=0
				Update_EnchantInfo(Enchantui,fumoid)
			elseif EnchantSpellID[fumoid] then
				local name, texture = PIGGetSpellInfo(EnchantSpellID[fumoid])
				Enchantui.icon:SetTexture(texture or 134400)
				Enchantui:SetBackdropBorderColor(1, 0.843, 0, 0.8);
				Enchantui:SetScript("OnEnter", function (self)
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
					if texture then
						GameTooltip:SetSpellByID(EnchantSpellID[fumoid])
					else
						GameTooltip:AddLine("附魔法术"..EnchantSpellID[fumoid].."已移除")
					end
					GameTooltip:Show();
				end);
			elseif EnchantSlotID[fumoid] then
				local itemID, itemType, itemSubType, itemEquipLoc = GetItemInfoInstant(itemLink)
				local EnchantSpell = EnchantSlotID[fumoid][itemEquipLoc]
				local name, texture = PIGGetSpellInfo(EnchantSpell)
				Enchantui.icon:SetTexture(texture)
				Enchantui:SetBackdropBorderColor(1, 0.843, 0, 0.8);
				Enchantui:SetScript("OnEnter", function (self)
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
					GameTooltip:SetSpellByID(EnchantSpell)
					GameTooltip:Show();
				end);
			else
				Enchantui.icon:SetTexture(136244)
				Enchantui:SetBackdropBorderColor(1, 0.843, 0, 0.8);
				Enchantui:SetScript("OnEnter", function (self)
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
					GameTooltip:AddLine(ENCHANTS.."ID:"..fumoid)
					GameTooltip:AddLine(UNKNOWN..ENCHANTS..INFO)
					GameTooltip:Show();
				end);
			end
		else
			if EnchantSlot[SlotID] then
				SlotBut.GemNums=SlotBut.GemNums+1
				local itemID, itemType, itemSubType, itemEquipLoc = GetItemInfoInstant(itemLink)
				if SlotID==17 and itemEquipLoc=="INVTYPE_HOLDABLE" then 
				else
					Enchantui:SetWidth(ListWWWHHH[3])
					Enchantui:SetAlpha(1)
					Enchantui.icon:SetDesaturated(true)
					Enchantui:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
					Enchantui.icon:SetTexture(136244)
					Enchantui:SetScript("OnEnter", function (self)
						GameTooltip:ClearLines();
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
						GameTooltip:AddLine("|cff00FFFF["..addonName.."]:|r|cffFF0000"..InvSlot["Name"][SlotID][2]..NONE..ENCHANTS.."|r")
						GameTooltip:Show();
					end);
				end
			end
		end
		if C_Engraving and C_Engraving.IsEngravingEnabled() then
			if EngravingSlot[SlotID] then
				local fuwenIcon=fujikk.ButGem[6]
				fuwenIcon:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
				fuwenIcon:SetWidth(ListWWWHHH[3])
				fuwenIcon:SetAlpha(1)
				fuwenIcon.icon:SetDesaturated(true)
				fuwenIcon.icon:SetTexture(134419)
				fuwenIcon:SetScript("OnEnter", function (self)
						GameTooltip:ClearLines();
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
						GameTooltip:AddLine("|cff00FFFF["..addonName.."]:|r|cffFF0000"..InvSlot["Name"][SlotID][2]..NONE..RUNES.."|r")
						GameTooltip:Show();
					end);
				if unit=="player" or unit=="lx" then
					if fuwen[SlotID] then
						fujikk.dataxInfo.fuwenNum=1
						Show_fuwenBut(fuwenIcon,fuwen[SlotID])
					end
				else
					if Parent.fuwenBut_yanchi then Parent.fuwenBut_yanchi:Cancel() end
					Parent.fuwenBut_yanchi=C_Timer.NewTimer(0.3,function()
						Show_fuwenBut_yanchi(Parent,fujikk,fuwenIcon,SlotID)
					end)
				end
			end
		end
		local itemID, itemType, itemSubType, itemEquipLoc = GetItemInfoInstant(itemLink)
   		SlotBut.itemEquipLoc=itemEquipLoc
   		Parent.SlotOKs[SlotID].TooltipCount=0
		Update_ItemLevel(unit,SlotID,SlotBut)
	else
		Parent.SlotOKs[SlotID].laodnd=nil
	end
end
local function Update_LevelTaozhuang(Parent)
	for SlotID,SlotBut in pairs(Parent.ListHang) do
		if Parent.SlotOKs[SlotID].laodnd and Parent.TaoListCount<6 then
			Parent.TaoListCount=Parent.TaoListCount+1
			C_Timer.After(0.1, function()
				Update_LevelTaozhuang(Parent)
			end)
			return
		end
	end
	local unit=Parent.unit
	if GetAverageItemLevel and unit=="player" then
		local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = GetAverageItemLevel();
		Parent.pingjunLV_V:SetText(string.format("%.2f",avgItemLevelEquipped))
	elseif _G[Data.LongInspectUIUIname].ZBLsit.itemLV then
		Parent.pingjunLV_V:SetText(string.format("%.2f",_G[Data.LongInspectUIUIname].ZBLsit.itemLV))
	else
		Parent.pingjunLV_V:SetText(_GetAverageItemLevel(Parent))
	end
	local taodata=Fun.Update_ListTaoName(Parent)
	local taozhuangNum = #taodata
	for tid=1,taozhuangNum do
		local taoui = Parent.ListTao[tid]
		if taodata[tid][3]==0 then
			taoui:SetText(string.format(BOSS_BANNER_LOOT_SET,taodata[tid][1].."("..taodata[tid][2].."/??)"))
		else
			taoui:SetText(string.format(BOSS_BANNER_LOOT_SET,taodata[tid][1].."("..taodata[tid][2].."/"..taodata[tid][3]..")"))
		end
		local r, g, b =GetItemQualityColor(taodata[tid][4] or 0)
		taoui:SetTextColor(r, g, b,1);
		local taoui_width = taoui:GetStringWidth()+4
		if taoui_width>Parent.hangMaxW then
			Parent.hangMaxW=taoui_width
		end
	end
	if taozhuangNum>1 then
		Parent:SetHeight(ListWWWHHH[2]+(taozhuangNum-1)*(ListWWWHHH[3]-3))
	end
end
local function UpdateItems_Inventory(Parent,zbData)	
	if not Parent:IsVisible() then return end
	Parent.hangMaxW=ListWWWHHH[1]
	if not Parent.SlotOKs then Parent.SlotOKs = {} else wipe(Parent.SlotOKs) end
	for SlotID,SlotBut in pairs(Parent.ListHang) do
		Parent.SlotOKs[SlotID]={laodnd=true,itemCount=0,TooltipCount=0,iLv=0,tao=nil}
		Update_SlotButton(SlotBut,SlotID,zbData)
	end
	Parent.TaoListCount=0
	C_Timer.After(0.4, function()
		Update_LevelTaozhuang(Parent)
	end)
end
------
local function add_ItemList(fujik,miaodian,ZBLsit_C,TalentUI)
	if GearManagerDialog then GearManagerDialog:SetFrameLevel(10) end
	local PointXY = {-1,1}
	if PIG_MaxTocversion(20000) and fujik==PaperDollFrame then
		PointXY[1]=-34
		PointXY[2]=-13
	end
	local ZBLsit = PIGFrame(fujik,{"TOPLEFT", fujik, "TOPRIGHT",PointXY[1],PointXY[2]},{ListWWWHHH[1],ListWWWHHH[2]},nil,nil,nil,{["ElvUI"]={2,0,2,0},["NDui"]={0,0,0,0}});
	ZBLsit.classes = ZBLsit:CreateTexture();
	ZBLsit.classes:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
	if NDui then
		ZBLsit:PIGSetBackdrop(0.5);
		ZBLsit.LeftJG,ZBLsit.TopJG=4,3 
	else
		ZBLsit:PIGSetBackdrop(0.8);
		ZBLsit.LeftJG,ZBLsit.TopJG=6,6
	end
	ZBLsit.classes:SetPoint("TOPLEFT",ZBLsit,"TOPLEFT",ZBLsit.LeftJG,-ZBLsit.TopJG);
	ZBLsit.classes:SetSize(20,20);
	ZBLsit.WJname = PIGFontString(ZBLsit,{"LEFT",ZBLsit.classes,"RIGHT",0,0},"","OUTLINE",15);

	ZBLsit.pingjunLV = PIGFontString(ZBLsit,{"TOPLEFT",ZBLsit,"TOPLEFT",ZBLsit.LeftJG,-24-ZBLsit.TopJG},STAT_AVERAGE_ITEM_LEVEL..":","OUTLINE");
	ZBLsit.pingjunLV_V = PIGFontString(ZBLsit,{"LEFT",ZBLsit.pingjunLV,"RIGHT",0,0},"--","OUTLINE");
	ZBLsit.pingjunLV_V:SetTextColor(1,1,1,1);

	ZBLsit.talentBut = CreateFrame("Button", nil, ZBLsit);
	ZBLsit.talentBut:SetPoint("TOPRIGHT",ZBLsit,"TOPRIGHT",-3,-22-ZBLsit.TopJG);
	ZBLsit.talentBut:SetSize(90,ListWWWHHH[3]);
	ZBLsit.talentBut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
	ZBLsit.talentBut.talentIcon = ZBLsit.talentBut:CreateTexture();
	ZBLsit.talentBut.talentIcon:SetPoint("BOTTOMRIGHT",ZBLsit.talentBut,"BOTTOMRIGHT",-2,0);
	ZBLsit.talentBut.talentIcon:SetSize(ListWWWHHH[3],ListWWWHHH[3]);

	ZBLsit.talentBut.talent_1v = PIGFontString(ZBLsit.talentBut,{"RIGHT",ZBLsit.talentBut.talentIcon,"LEFT",0,0},"","OUTLINE");
	ZBLsit.talentBut.talent_1v:SetTextColor(1,1,1,1);
	ZBLsit.talentBut.talent_1 = PIGFontString(ZBLsit.talentBut,{"RIGHT",ZBLsit.talentBut.talent_1v,"LEFT",0,0},SPECIALIZATION..":","OUTLINE");

	PIGLine(ZBLsit,"TOP",-43-ZBLsit.TopJG,nil,{1,-1},{0.2,0.2,0.2,0.9})
	ZBLsit.ListHang={}
	for i=1,#InvSlot["ID"] do
		local clsit = PIGFrame(ZBLsit,nil,{ListWWWHHH[4],ListWWWHHH[3]});
		ZBLsit.ListHang[InvSlot["ID"][i]]=clsit
		clsit.Slot=InvSlot["ID"][i]
		clsit:PIGSetBackdrop(0)
		if i==1 then
			if C_Engraving and C_Engraving and C_Engraving.IsEngravingEnabled() then
				clsit:SetPoint("TOPLEFT",ZBLsit,"TOPLEFT",ListWWWHHH[3]+ZBLsit.LeftJG+3,-52);
			else
				clsit:SetPoint("TOPLEFT",ZBLsit,"TOPLEFT",ZBLsit.LeftJG,-52);
			end
		else
			if PIG_MaxTocversion(50000) then
				clsit:SetPoint("TOPLEFT",ZBLsit.ListHang[InvSlot["ID"][i-1]],"BOTTOMLEFT",0,-2);
			else
				clsit:SetPoint("TOPLEFT",ZBLsit.ListHang[InvSlot["ID"][i-1]],"BOTTOMLEFT",0,-3.4);
			end
		end
		clsit.t = PIGFontString(clsit,{"CENTER",0.4,0.6},InvSlot["Name"][InvSlot["ID"][i]][2],"OUTLINE",12)
		clsit.itemlink = CreateFrame("Button", nil, clsit)
		clsit.itemlink:SetPoint("LEFT",clsit,"RIGHT",2,0);
		clsit.itemlink:SetSize(100,ListWWWHHH[3]);
		clsit.itemlink.lv = PIGFontString(clsit.itemlink,{"LEFT",clsit.itemlink,"LEFT",0,0},"","OUTLINE")
		clsit.itemlink.lv:SetTextColor(1, 1, 1, 1);
		clsit.itemlink.t = PIGFontString(clsit.itemlink,{"LEFT",clsit.itemlink.lv,"RIGHT",0,0},"","OUTLINE")
		clsit.itemlink:SetScript("OnLeave", function (self)
			GameTooltip:ClearLines();
			GameTooltip:Hide()
			clsit.t:SetTextColor(0, 1, 1, 0.8);
			clsit:SetBackdropColor(unpack(BackdropColor))
		end);
		clsit.itemlink:SetScript("OnEnter", function (self)	
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
			local fujikx = self:GetParent()
			if fujikx.unittype=="yc" or fujikx.unittype=="lx" then
				GameTooltip:SetHyperlink(fujikx.itemLink)
			else
				if fujikx.unittype and fujikx.Slot then
					GameTooltip:SetInventoryItem(fujikx.unittype, fujikx.Slot)
				end
			end
			clsit:SetBackdropColor(0, 1, 1, 0.5)
			clsit.t:SetTextColor(1, 1, 0.8, 1);
			GameTooltip:Show();
		end);
		clsit.itemlink:SetScript("OnDoubleClick", function(self)
            ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
            ChatEdit_InsertLink(self:GetParent().itemLink)
        end)
		clsit.ButGem={}
		for Gemid=1,ListWWWHHH[5] do
			local Gembut = CreateFrame("Frame", nil, clsit,"BackdropTemplate");
			clsit.ButGem[Gemid]=Gembut
			Gembut:SetBackdrop({edgeFile = "Interface/AddOns/"..addonName.."/Libs/Pig_Border.blp", edgeSize = 10});
			Gembut:SetBackdropBorderColor(0, 0, 0, 1);
			Gembut:SetSize(ListWWWHHH[3],ListWWWHHH[3]);
			if Gemid==1 then
				Gembut:SetPoint("LEFT",clsit.itemlink,"RIGHT",0,-1);
			elseif Gemid==6 then
				Gembut:SetPoint("RIGHT",clsit,"LEFT",-2.4,-1);
			else
				Gembut:SetPoint("LEFT",clsit.ButGem[Gemid-1],"RIGHT",1,0);
			end
			Gembut.icon = Gembut:CreateTexture();
			Gembut.icon:SetPoint("TOPLEFT",Gembut,"TOPLEFT",2,-2);
			Gembut.icon:SetPoint("BOTTOMRIGHT",Gembut,"BOTTOMRIGHT",-2,2);
			Gembut:SetScript("OnLeave", function ()
				GameTooltip:ClearLines();
				GameTooltip:Hide() 
			end);
		end
		function clsit:CZ_ItemListHang()
			self:SetBackdropBorderColor(0.5, 0.5, 0.5,0.5)--部位边框
			self.t:SetTextColor(0.5, 0.5, 0.5,0.8);--部位名
			self.unittype=nil
			self.itemLink=nil
			self.GemNums=0
			self.itemlink:SetWidth(0.1);--link宽
			self.itemlink.lv:SetText(" ")--物品等级
			self.itemlink.t:SetText(" ")--物品link
			for Gemid=1,ListWWWHHH[5] do
				local Gemui = clsit.ButGem[Gemid]
				Gemui:SetWidth(0.01)
				Gemui:SetAlpha(0)
				Gemui:SetBackdropBorderColor(0, 0, 0, 1);
			end
		end
	end
	local Dibuline=PIGLine(ZBLsit,"TOP",-391-ZBLsit.TopJG,nil,{1,-1},{0.2,0.2,0.2,0.9})
	ZBLsit.ListTao={}
	for tid=1,6 do
		local taozhuant = PIGFontString(ZBLsit,nil,"","OUTLINE");
		ZBLsit.ListTao[tid]=taozhuant
		if tid==1 then
			taozhuant:SetPoint("TOPLEFT",Dibuline,"BOTTOMLEFT",ZBLsit.LeftJG-3,-4);
		else
			taozhuant:SetPoint("TOPLEFT",ZBLsit.ListTao[tid-1],"BOTTOMLEFT",0,-1);
		end
	end
	if ZBLsit_C then
		ZBLsit:SetPoint("TOPLEFT", miaodian, "TOPRIGHT",-2,0);
	end
	if TalentUI then
		TalentData.add_TalentUI(ZBLsit)
	end
	--
	ZBLsit.allstats={}
	function ZBLsit:CZ_ItemList()
		if self.TalentF then self.TalentF:Hide() self.TalentF:CZ_TianfuUI() end
		local Parent=self:GetParent()
		self.WJname:SetText(_G[Data.LongInspectUIUIname].fullnameX)
		self.pingjunLV_V:SetText("--")
		_G[Data.LongInspectUIUIname].ZBLsit.itemLV=nil
		self.classes:SetTexCoord(0,0,0,0);
		self.talentBut.talent_1v:SetText("--")
		self.talentBut.talentIcon:SetTexture(132222);
		self.talentBut:SetScript("OnClick", nil)
		local ListName = self:GetName()
		for i = 1, #InvSlot["ID"] do
			ZBLsit.ListHang[InvSlot["ID"][i]]:CZ_ItemListHang()
		end
		for tid=1,4 do
			local taoui = ZBLsit.ListTao[tid]
			taoui:SetTextColor(0.5, 0.5, 0.5, 1);
			if tid==1 then
				taoui:SetText(string.format(BOSS_BANNER_LOOT_SET,NONE))
			else
				taoui:SetText("")
			end
		end
		self:SetHeight(ListWWWHHH[2])
	end
	function ZBLsit:Update_Player(unit,ycdata)
		self:CZ_ItemList()	
		local jichuxinxi={
			["Talent"]={},
			["OpenTF"]=function() end,
		}
		if unit=="lx" then
			self.cName=_G[Data.LongInspectUIUIname].fullnameX
			jichuxinxi.Talent=TalentData.GetTianfuIcon_YC(self.zhiye,self.cName,unit)
			jichuxinxi.OpenTF=function()
				PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
				if self.TalentF:IsVisible() then
					self.TalentF:Hide()
				else
					self.TalentF:Show_TianfuUI(unit)
				end
			end
		elseif unit=="yc" then
			self.cName=_G[Data.LongInspectUIUIname].fullnameX
			jichuxinxi.Talent=TalentData.GetTianfuIcon_YC(self.zhiye,self.cName)
			jichuxinxi.OpenTF=function()
				PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
				if self.TalentF:IsVisible() then
					self.TalentF:Hide()
				else
					self.TalentF:Show_TianfuUI(unit)
				end
			end
		else
			local IS_guacha=false
			if unit~="player" and self:GetParent():GetParent():GetName()=="InspectFrame" then
				IS_guacha=true
			end
			local cName=GetUnitName(unit, true)
			local Level=UnitLevel(unit)
			local className, classFilename, classId = UnitClass(unit)
			self.cName=cName
			self.level=Level
			self.zhiyeID=classId
			self.zhiye=classFilename
			jichuxinxi.Talent=TalentData.GetTianfuIcon(IS_guacha,classFilename,unit)
			jichuxinxi.OpenTF=function()
				if PIG_MaxTocversion(60000) then
					if IS_guacha then
						PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
						if self.TalentF:IsVisible() then
							self.TalentF:Hide()
						else
							self.TalentF:Show_TianfuUI("Inspect")
						end
					else
						if PIG_MaxTocversion(20000) then
							PlayerTalentFrame_LoadUI();
							if ( PlayerTalentFrame:IsShown() ) then
								HideUIPanel(PlayerTalentFrame);
							else
								ShowUIPanel(PlayerTalentFrame);
							end
						else
							TalentFrame_LoadUI();
							if ( PlayerTalentFrame:IsShown() ) then
								HideUIPanel(PlayerTalentFrame);
							else
								ShowUIPanel(PlayerTalentFrame);
							end
						end
					end
				elseif PIG_MaxTocversion(110000,true) then
					if IS_guacha then
						if InCombatLockdown() then
							PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
							PIG_OptionsUI:ErrorMsg("请专心战斗");
						else
							if InspectPaperDollFrameTalentsButtonMixin then
								InspectPaperDollFrameTalentsButtonMixin:OnClick()
							else
								InspectFrameTab3:Click()
							end
						end
					else
						if PlayerSpellsMicroButtonMixin then
							PlayerSpellsMicroButtonMixin:OnClick()
						else
							TalentMicroButton:Click()
						end
					end
				end
			end
		end
		self.WJname:SetText(self.cName.."|cffFFFF22 ("..self.level..")|r")
		if self.zhiye~="--" then
			self.classes:SetTexCoord(unpack(CLASS_ICON_TCOORDS[self.zhiye]));
			local color = PIG_CLASS_COLORS[self.zhiye];
			self.WJname:SetTextColor(color.r, color.g, color.b,1);
		end
		--天赋
		self.talentBut.talent_1v:SetText(jichuxinxi.Talent[1])
		self.talentBut.talentIcon:SetTexture(jichuxinxi.Talent[2]);
		self.talentBut:SetScript("OnClick", function (self)
			jichuxinxi.OpenTF()
		end)
	end
	function ZBLsit:Update_ItemList(unit,zbData)
		self.unit=unit
		UpdateItems_Inventory(self,zbData)		
	end
	ZBLsit:HookScript("OnHide", function(self)
		if self.allstats_Ticker then self.allstats_Ticker:Cancel() end
	end);
	if GetAverageItemLevel then
		ZBLsit:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE");
		ZBLsit:HookScript("OnEvent", function(self,event,arg1)
			if self.unit=="player" then
				local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = GetAverageItemLevel();
				self.pingjunLV_V:SetText(string.format("%.2f",avgItemLevelEquipped))
			end
		end)
	end
	return ZBLsit
end
function Create.PIGItemListUI(laiyuan)
	if laiyuan.ZBLsit then return end	
	if laiyuan==PaperDollFrame then
		laiyuan.ZBLsit = add_ItemList(laiyuan,laiyuan)
	elseif laiyuan==InspectFrame then
		laiyuan.ZBLsit = add_ItemList(InspectPaperDollFrame,InspectPaperDollFrame,nil,true)
		laiyuan.ZBLsit_C = add_ItemList(InspectPaperDollFrame,laiyuan.ZBLsit,true,true)
	elseif laiyuan==_G[Data.LongInspectUIUIname] then
		laiyuan.ZBLsit = add_ItemList(laiyuan,laiyuan,nil,true)
	end
end
-- hooksecurefunc("NotifyInspect", function(unit)
-- 	print(unit)
-- end)