local addonName, addonTable = ...;
local gsub = _G.string.gsub
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGButton=Create.PIGButton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGFontString=Create.PIGFontString
local PIGItemListUI=Create.PIGItemListUI
local PIGSetFont=Create.PIGSetFont
----
local Data=addonTable.Data
local InvSlot=Data.InvSlot
local EngravingSlot=Data.EngravingSlot
local TalentData=Data.TalentData
local FramePlusfun=addonTable.FramePlusfun
local FasongYCqingqiu=addonTable.Fun.FasongYCqingqiu
----
local GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID = C_Container.GetContainerItemID
local PickupContainerItem =C_Container.PickupContainerItem
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
local GetItemQualityColor=GetItemQualityColor or C_Item and C_Item.GetItemQualityColor
local GetDetailedItemLevelInfo=GetDetailedItemLevelInfo or C_Item and C_Item.GetDetailedItemLevelInfo
local GetCoinTextureString= GetCoinTextureString or  C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString
---自身角色和观察目标信息---------------
if not InspectTalentFrameSpentPoints then InspectTalentFrameSpentPoints = CreateFrame("Frame") end
local XWidth, XHeight =CharacterHeadSlot:GetWidth(),CharacterHeadSlot:GetHeight()
-----------------------
local function Update_Level_V(framef,unit,ZBID)
	framef.ZLV:SetText("");
	local itemLink = GetInventoryItemLink(unit, ZBID)
	if itemLink then
		local quality = GetInventoryItemQuality(unit, ZBID)
		if quality then
			local effectiveILvl = GetDetailedItemLevelInfo(itemLink)
			framef.ZLV:SetText(effectiveILvl);
			local r, g, b = GetItemQualityColor(quality)
			framef.ZLV:SetTextColor(r, g, b, 1);
		end
	end
end
local function Update_ranse_V(framef,unit,ZBID)
	framef.ranse:Hide()
	local quality = GetInventoryItemQuality(unit, ZBID)
    if quality and quality>1 then
        local r, g, b = GetItemQualityColor(quality);
        framef.ranse:SetVertexColor(r, g, b);
		framef.ranse:Show()
	end
end
local function Update_Data_ALL(laiyuan)--刷新数据
	local LYname=""
	if laiyuan==PaperDollFrame then
		LYname="Character"
	elseif laiyuan==InspectFrame then
		LYname ="Inspect"
	end
	if LYname=="" then return end
	if laiyuan==PaperDollFrame then
		if PIGA["FramePlus"]["Character_Durability"] then
			for inv = 1, #InvSlot["ID"] do
				if InvSlot["Name"][InvSlot["ID"][inv]][4] then
					local Frameu=_G[LYname..InvSlot["Name"][InvSlot["ID"][inv]][3].."Slot"].naijiuV
					Frameu:SetText("");
					local current, maximum = GetInventoryItemDurability(InvSlot["ID"][inv]);
					if maximum then
						local naijiubaifenbi=floor(current/maximum*100);
						Frameu:SetText(naijiubaifenbi.."%");
						if naijiubaifenbi>79 then
							Frameu:SetTextColor(0,1,0, 1);
						elseif  naijiubaifenbi>59 then
							Frameu:SetTextColor(1,215/255,0, 1);
						elseif  naijiubaifenbi>39 then
							Frameu:SetTextColor(1,140/255,0, 1);
						elseif  naijiubaifenbi>19 then
							Frameu:SetTextColor(1,69/255,0, 1);
						else
							Frameu:SetTextColor(1,0,0, 1);
						end
					end
				end
			end
		end
	end
	local duixiang="player"
	if laiyuan==InspectFrame then
		duixiang=InspectFrame.unit
	end
	if PIGA["FramePlus"]["Character_ItemLevel"] then
		for inv = 1, #InvSlot["ID"] do
			if InvSlot["ID"][inv]~=0 and InvSlot["ID"][inv]~=4 and InvSlot["ID"][inv]~=19 then
				local framef=_G[LYname..InvSlot["Name"][InvSlot["ID"][inv]][3].."Slot"]
				Update_Level_V(framef,duixiang, InvSlot["ID"][inv])
			end
		end
	end
	if PIGA["FramePlus"]["Character_ItemColor"] then
		for inv = 1, #InvSlot["ID"] do
			local framef=_G[LYname..InvSlot["Name"][InvSlot["ID"][inv]][3].."Slot"]
			Update_ranse_V(framef,duixiang,InvSlot["ID"][inv])
		end
	end
	if PIGA["FramePlus"]["Character_ItemList"] then
		if laiyuan==PaperDollFrame then
			laiyuan.ZBLsit:Update_Player("player")
			laiyuan.ZBLsit:Update_ItemList("player")
		else
			laiyuan.ZBLsit:Update_Player(InspectFrame.unit)
			laiyuan.ZBLsit_C:Update_Player("player")
			laiyuan.ZBLsit:Update_ItemList(InspectFrame.unit)
			laiyuan.ZBLsit_C:Update_ItemList("player")
		end
	end
end
local function ADD_UI_Puls(laiyuan)
	local LYname=""
	if laiyuan==PaperDollFrame then
		LYname="Character"
	elseif laiyuan==InspectFrame then
		LYname ="Inspect"
	end
	if LYname=="" then return end
	for inv = 1, #InvSlot["ID"] do
		local framef=_G[LYname..InvSlot["Name"][InvSlot["ID"][inv]][3].."Slot"]
		---
		if PIGA["FramePlus"]["Character_Durability"] then
			if not framef.naijiuV then
				framef.naijiuV = PIGFontString(framef,{"BOTTOMRIGHT", framef, "BOTTOMRIGHT", 2, 0},nil,"OUTLINE",13)
				framef.naijiuV:SetDrawLayer("OVERLAY", 7)
			end
		end
		--
		if PIGA["FramePlus"]["Character_ItemLevel"] then
			if not framef.ZLV then
				framef.ZLV = PIGFontString(framef,{"TOPLEFT", framef, "TOPLEFT", -2, 1},nil,"OUTLINE",15)
				framef.ZLV:SetDrawLayer("OVERLAY", 7)
			end
		end
		---
		if PIGA["FramePlus"]["Character_ItemColor"] then
			if not framef.ranse then
				framef.ranse = framef:CreateTexture(nil, "OVERLAY");
				framef.ranse:SetTexture("Interface/Buttons/UI-ActionButton-Border");
				framef.ranse:SetBlendMode("ADD");
				if InvSlot["ID"][inv]==0 then
					framef.ranse:SetSize(XWidth*1.4, XHeight*1.4);
				else
					framef.ranse:SetSize(XWidth*1.8, XHeight*1.8);
				end
				framef.ranse:SetPoint("CENTER", framef, "CENTER", 0, 0);
				framef.ranse:Hide()
			end
		end
	end
	---	
	if PIGA["FramePlus"]["Character_ItemList"] then
		if C_Engraving and C_Engraving.IsEngravingEnabled() then
			hooksecurefunc("ToggleEngravingFrame", function()
				FramePlusfun.UpdatePoint(PaperDollFrame)
			end)
		end
		PIGItemListUI(laiyuan)
	end
end
local function Load_addonsFun(FrameX)
	ADD_UI_Puls(FrameX)
	FrameX:HookScript("OnShow", function(self,event,arg1)
		if PIG_MaxTocversion(20000) then
			FasongYCqingqiu(InspectNameText:GetText(),4)
		elseif PIG_MaxTocversion() then
			FasongYCqingqiu(InspectNameText:GetText(),3)
		end
		if _G[Data.LongInspectUIUIname] then
			_G[Data.LongInspectUIUIname]:Hide()
		end
	end)
	FrameX:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
	FrameX:HookScript("OnEvent", function(self,event,arg1)
		if event=="INSPECT_READY" then
			if self.unit then
				local GUID=UnitGUID(self.unit)
				if arg1==GUID then 
					Update_Data_ALL(self)
				end
			end
		elseif event=="PLAYER_EQUIPMENT_CHANGED" then
			if arg1==self.unit then
				Update_Data_ALL(self)
			end
		end
	end)
end
function FramePlusfun.Character_ADD()
	ADD_UI_Puls(PaperDollFrame)
	PaperDollFrame:HookScript("OnShow",function()
		Update_Data_ALL(PaperDollFrame)
	end)
	PaperDollFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
	PaperDollFrame:HookScript("OnEvent", function(self,event,arg1)
		if event=="PLAYER_EQUIPMENT_CHANGED" or event=="PLAYER_AVG_ITEM_LEVEL_UPDATE" then
			if PaperDollFrame:IsVisible() then
				Update_Data_ALL(PaperDollFrame)
			end
		end
	end);
	--观察
	if IsAddOnLoaded("Blizzard_InspectUI") then
		Load_addonsFun(InspectFrame)
	else
		if PIGA["FramePlus"]["Character_ItemLevel"] or PIGA["FramePlus"]["Character_ItemColor"] or PIGA["FramePlus"]["Character_ItemList"] then
			local InspectPIG = CreateFrame("Frame")
			InspectPIG:RegisterEvent("ADDON_LOADED")
			InspectPIG:HookScript("OnEvent", function(self,event,arg1)
				if event=="ADDON_LOADED" and arg1=="Blizzard_InspectUI" then
					self:UnregisterEvent("ADDON_LOADED");
					Load_addonsFun(InspectFrame)
				end
			end)
		end
	end
end
---人物界面属性==========================
local function Character_xiuliG()--修理费用
	if PaperDollFrame.xiuli then return end
	PaperDollFrame.xiuli = CreateFrame("Frame",nil,PaperDollFrame);  
	PaperDollFrame.xiuli:SetSize(110,20);
	if PIG_MaxTocversion(40000) then
		PaperDollFrame.xiuli:SetPoint("BOTTOMLEFT", PaperDollFrame, "BOTTOMLEFT", 22, 88);
	elseif PIG_MaxTocversion() then
		if ElvUI then
			PaperDollFrame.xiuli:SetPoint("TOPLEFT", PaperDollFrame, "TOPLEFT", 8, -42);
		else
			PaperDollFrame.xiuli:SetPoint("BOTTOMLEFT", PaperDollFrame, "BOTTOMLEFT", 6,10);
		end
	else
		PaperDollFrame.xiuli:SetPoint("BOTTOMLEFT", PaperDollFrame, "BOTTOMLEFT", 8, 8);
	end
	PaperDollFrame.xiuli:SetFrameLevel(10)
	PaperDollFrame.xiuli.ICON = PaperDollFrame.xiuli:CreateTexture(nil, "OVERLAY");
	PaperDollFrame.xiuli.ICON:SetTexture("interface/minimap/tracking/repair.blp");
	PaperDollFrame.xiuli.ICON:SetSize(20,20);
	PaperDollFrame.xiuli.ICON:SetPoint("LEFT", PaperDollFrame.xiuli, "LEFT", 0, 0);
	PaperDollFrame.xiuli.G = PIGFontString(PaperDollFrame.xiuli,{"LEFT", PaperDollFrame.xiuli.ICON, "RIGHT", 0, 0},nil,nil,13)
	local naijiubuweiID=Data.InvSlot.Name
	local xiuliinfo = {
		["invnum"]=0,
		["myTicker"]=nil,
		["repaircost"]=0,
		["solt"]={},
		["xuhaoID"]=1,
	}
	for k,v in pairs(naijiubuweiID) do
		if v[4] then
			table.insert(xiuliinfo.solt,k)
		end
	end
	xiuliinfo.invnum=#xiuliinfo.solt
	local function GetInventoryrepaircost(i)
		if not PaperDollFrame:IsVisible() then if xiuliinfo.myTicker then xiuliinfo.myTicker:Cancel() end return end
		local solt=xiuliinfo.solt[i]
		if PIG_MaxTocversion() then 
			PIG_TooltipUI:ClearLines();
			local hasItem,_,repairCost = PIG_TooltipUI:SetInventoryItem("player", solt)
			xiuliinfo.repaircost=xiuliinfo.repaircost+repairCost
		else
			local dataxxx = C_TooltipInfo.GetInventoryItem("player", solt)
			if dataxxx and dataxxx.repairCost then
				xiuliinfo.repaircost=xiuliinfo.repaircost+dataxxx.repairCost
			end
		end
		if i>=xiuliinfo.invnum then
			if xiuliinfo.repaircost>10000 then
				local linshiG=xiuliinfo.repaircost*0.01
				local linshiG=floor(linshiG+0.5)
				xiuliinfo.repaircost=linshiG*100
			end
			PaperDollFrame.xiuli.G:SetText(GetCoinTextureString(xiuliinfo.repaircost))
		end
		xiuliinfo.xuhaoID=xiuliinfo.xuhaoID+1
	end
	PaperDollFrame:HookScript("OnShow",function (self,event)
		if xiuliinfo.myTicker then xiuliinfo.myTicker:Cancel() end
		xiuliinfo.repaircost=0
		xiuliinfo.xuhaoID=1
		xiuliinfo.myTicker = C_Timer.NewTicker(0.01, function() GetInventoryrepaircost(xiuliinfo.xuhaoID) end, xiuliinfo.invnum)
	end)
	PaperDollFrame:HookScript("OnHide", function(self)
		if xiuliinfo.myTicker then xiuliinfo.myTicker:Cancel() end
	end);
end
local function Character_Mingzhong()--命中说明
	if PIG_MaxTocversion(40000,true) then return end
	if PaperDollFrame.MingZhong then return end
	PaperDollFrame.MingZhong = CreateFrame("Button",nil,PaperDollFrame, "UIPanelInfoButton");  
	PaperDollFrame.MingZhong:SetSize(16,16);
	PaperDollFrame.MingZhong:SetPoint("BOTTOMLEFT", PaperDollFrame, "BOTTOMLEFT", 315, 89);
	PaperDollFrame.MingZhong:SetFrameLevel(6)
	PaperDollFrame.MingZhong.texture:SetPoint("BOTTOMRIGHT", PaperDollFrame.MingZhong, "BOTTOMRIGHT", 0, 0);
	--物理
	PaperDollFrame.MingZhong.Wl = PIGFrame(PaperDollFrame.MingZhong);
	PaperDollFrame.MingZhong.Wl:PIGSetBackdrop(1);
	PaperDollFrame.MingZhong.Wl:SetWidth(200);
	if PIG_MaxTocversion(40000) then
		PaperDollFrame.MingZhong.Wl:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT",-31,-15);
		PaperDollFrame.MingZhong.Wl:SetPoint("BOTTOMLEFT", PaperDollFrame, "BOTTOMRIGHT",0,75);
	else
		PaperDollFrame.MingZhong.Wl:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT",1,-2);
		PaperDollFrame.MingZhong.Wl:SetPoint("BOTTOMLEFT", PaperDollFrame, "BOTTOMRIGHT",0,3);
	end
	PaperDollFrame.MingZhong.Wl:Hide()

	PaperDollFrame.MingZhong.Wl.title1 = PIGFontString(PaperDollFrame.MingZhong.Wl,{"TOPLEFT", PaperDollFrame.MingZhong.Wl, "TOPLEFT", 4, -6},"关于物理命中");
	local mingzhongshuomingTXT
	if PIG_MaxTocversion(20000) then
		mingzhongshuomingTXT=
		"同级:基础命中率95%(5%)\n骷髅BOSS:基础命中率92%(8%)\n"..
		"双持惩罚:基础命中率-19%\n\n"..
		"|cffFFD700例外情况：|r\n"..
		"|cffFF8C00当<目标的防御等级>减去<玩家武器技能>大于10,装备或天赋上所提供的命中会被无视1%。这将导致在对抗骷髅BOSS时需要额外1%的命中，即需要9%的命中而不是8%.|r\n"..
		"武器技能和防御等级计算公式当前级别*5；60级角色对抗骷髅BOSS情况:5*63-5*60>10\n\n"..
		"|cffFFD700种族武器专精：|r\n"..
		"人类的剑/双手剑/锤/双手锤与兽人的斧/双手斧武器技能提高5点，会产生效果："..
		"会使武器技能和BOSS防御等级差值不大于10，不需要额外1%命中，再加上5点武器技能本身提供的1%命中，此时你将只需要6%命中即可。但武器技能的作用还不止于此，也会大量降低你的普攻偏斜。"
	elseif PIG_MaxTocversion(30000) then
		mingzhongshuomingTXT=
		"同级:基础命中率95%(5%)\n骷髅BOSS:基础命中率91.4%(9%)\n"..
		"双持惩罚:基础命中率减去19%\n"..
		"|cffFFD700命中等级：|r\n"..
		"|cffFF8C00TBC1%命中≈15.8命中等级。|r\n"..
		"9%命中：9*15.8≈143命中等级\n"..
		"双持职业\n需要28*15.8≈443点命中等级\n"..
		"|cffFFD700职业差异：|r\n"..
		"猎人，武器战以及猫德这些DPS职业都只需要9%的命中，就可以保证技能和平A全部命中\n"..
		"盗贼/狂暴战/增强萨,天赋自带5%/5%/6%的命中，双持的时候需要23%/23%/22%的命中\n"..
		"不过狂暴战/增强萨达到9%命中之后，暴击收益更高，只需堆到9%保证技能命中后尽量堆暴击，盗贼因为天赋回能尽量堆满命中\n"..
		"坦克:达到9%技能全命中后优先考虑生存属性"
	elseif PIG_MaxTocversion(40000) then
		mingzhongshuomingTXT=
		"|cff00FF00WLK%1命中需要≈32.8命中等级|r\n"..
		"|cffFF8C00命中率需求:|r\n"..
		"|cff00FF00同级:5% (8*32.8≈164命中等级)|r\n"..
		"|cff00FF00骷髅BOSS:8% (8*32.8≈263命中等级)|r\n"..
		"|cff00FF00双持:27% (27*32.8≈919命中等级)|r\n"..
		"|cffFF8C00职业差异：|r\n"..
		"|cff00FF00猎人，武器战以及猫德这些DPS职业都只需要8%的命中，就可以保证技能和平A全部命中\n"..
		"盗贼/狂暴战/增强萨,天赋自带5%/5%/6%的命中，双持的时候需要22%/22%/21%的命中\n"..
		"不过狂暴战/增强萨达到8%命中之后，暴击收益更高，只需堆到8%保证技能命中后尽量堆暴击，盗贼因为天赋回能尽量堆满命中\n"..
		"坦克:达到8%技能全命中后优先考虑生存属性|r"
	end
	PaperDollFrame.MingZhong.Wl.title2 = PIGFontString(PaperDollFrame.MingZhong.Wl,{"TOPLEFT", PaperDollFrame.MingZhong.Wl.title1, "BOTTOMLEFT", 0, 0},mingzhongshuomingTXT,nil,13);
	PaperDollFrame.MingZhong.Wl.title2:SetWidth(192);
	PaperDollFrame.MingZhong.Wl.title2:SetJustifyH("LEFT");
	local tixhsss2 = "|cffFFFF00骷髅BOSS默认高玩家3级|r\n面板统计命中不包含天赋加成"
	PaperDollFrame.MingZhong.Wl.title3 = PIGFontString(PaperDollFrame.MingZhong.Wl,{"TOPLEFT", PaperDollFrame.MingZhong.Wl.title2, "BOTTOMLEFT", 0, -6},tixhsss2,nil,13)
	PaperDollFrame.MingZhong.Wl.title3:SetJustifyH("LEFT");
	--法术
	PaperDollFrame.MingZhong.Fs = PIGFrame(PaperDollFrame.MingZhong);
	PaperDollFrame.MingZhong.Fs:PIGSetBackdrop(1);
	PaperDollFrame.MingZhong.Fs:SetWidth(200);
	PaperDollFrame.MingZhong.Fs:SetPoint("TOPLEFT", PaperDollFrame.MingZhong.Wl, "TOPRIGHT",1,0);
	PaperDollFrame.MingZhong.Fs:SetPoint("BOTTOMLEFT", PaperDollFrame.MingZhong.Wl, "BOTTOMRIGHT",0,0);
	PaperDollFrame.MingZhong.Fs:Hide()
	PaperDollFrame.MingZhong.Fs.title1 = PIGFontString(PaperDollFrame.MingZhong.Fs,{"TOPLEFT", PaperDollFrame.MingZhong.Fs, "TOPLEFT", 6, -6},"关于法系命中(抵抗)");
	local FSmingzhongshuomingTXT
	if PIG_MaxTocversion(20000) then
		FSmingzhongshuomingTXT=
		"|cffFF8C00注意:法术命中上限是99%|r\n同级:基础命中率96%(3%)\n骷髅BOSS:基础命中率83%(16%)\n"
	elseif PIG_MaxTocversion(30000) then
		FSmingzhongshuomingTXT=
		"|cffFF8C00注意:法术命中上限是99%|r\n同级:基础命中率96%(3%)\n骷髅BOSS:基础命中率83%(16%)\n"..
		"TBC法系命中率\n1%≈12.6法系命中等级"
	elseif PIG_MaxTocversion(40000) then
		FSmingzhongshuomingTXT=
		"|cff00FF00WLK1%法系命中率≈26.2法系命中等级|r\n"..
		"|cffFF8C00命中率需求:|r\n"..
		"|cff00FF00同级:4% (8*32.8≈164命中等级)|r\n"..
		"|cff00FF00骷髅BOSS:17% (17*26.2≈446命中等级)|r\n"..
		"有德国人时需要16*26.2≈420命中等级"
	end
	PaperDollFrame.MingZhong.Fs.title10 = PIGFontString(PaperDollFrame.MingZhong.Fs,{"TOPLEFT", PaperDollFrame.MingZhong.Fs.title1, "BOTTOMLEFT", 0, -4},FSmingzhongshuomingTXT,nil,13);
	PaperDollFrame.MingZhong.Fs.title10:SetWidth(192);
	PaperDollFrame.MingZhong.Fs.title10:SetJustifyH("LEFT");
	PaperDollFrame.MingZhong.Fs.title3 = PIGFontString(PaperDollFrame.MingZhong.Fs,{"TOPLEFT", PaperDollFrame.MingZhong.Fs.title10, "BOTTOMLEFT", 0, -10},tixhsss2,nil,13);
	PaperDollFrame.MingZhong.Fs.title3:SetJustifyH("LEFT");
	PaperDollFrame.MingZhong:SetScript("OnEnter", function() PaperDollFrame.MingZhong.Wl:Show() PaperDollFrame.MingZhong.Fs:Show() end );
	PaperDollFrame.MingZhong:SetScript("OnLeave", function() PaperDollFrame.MingZhong.Wl:Hide() PaperDollFrame.MingZhong.Fs:Hide() end );
end
---装备管理
local PIG_EquipmentData = {};
local anniushu=	MAX_EQUIPMENT_SETS_PER_PLAYER
local zhuangbeixilieID=Data.InvSlot.Name
local NumTexCoord = {
	{0.04,0.21,0,0.32},
	{0.326,0.43,0,0.32},
	{0.546,0.694,0,0.32},
	{0.80,0.95,0,0.32},
	{0.04,0.21,0.33,0.66},
	{0.3,0.45,0.33,0.66},
	{0.546,0.71,0.33,0.66},
	{0.80,0.95,0.33,0.66},
	{0.04,0.21,0.66,0.99},
	{0.3,0.45,0.66,0.99},
}
local function Equip_Save(id)
	local wupinshujuinfo = {}
	for inv = 1, 19 do
		local zhutisolt = _G["Character"..zhuangbeixilieID[inv][3].."Slot"]
		wupinshujuinfo[inv]={zhutisolt.ignored,""}
	end
	for inv = 1, 19 do
		if not wupinshujuinfo[inv][1] then
			local itemLink = GetInventoryItemLink("player", inv)
			if itemLink then
				wupinshujuinfo[inv][2]=itemLink
			end
		end
	end
	if PIGA_Per["QuickBut"]["EquipList"][id] then
		PIGA_Per["QuickBut"]["EquipList"][id][2] = wupinshujuinfo
	else
		PIGA_Per["QuickBut"]["EquipList"][id] = {"配装"..(id-1),wupinshujuinfo}
	end
	PIG_OptionsUI:ErrorMsg("当前装备已保存到"..(id-1).."号配装")
end
local function Equip_Use(id)
	if InCombatLockdown() then PIG_OptionsUI:ErrorMsg("战斗中无法切换") return end
	local wupinshujuinfo =PIGA_Per["QuickBut"]["EquipList"][id]
	if wupinshujuinfo and wupinshujuinfo[2] then
		PIG_EquipmentData.hejilist={}
		local ItemList =wupinshujuinfo[2]
		for k,v in pairs(ItemList) do
			if v[1] then
			else
				if v[2]~="" then
					C_Item.EquipItemByName(v[2], k)
				else
					local itemLink = GetInventoryItemLink("player", k)
					if itemLink then--存在取下
						if k==17 then--是副手
							if ItemList[16][2] then--主手存在
								local fffffID =C_Item.GetItemInventoryTypeByID(ItemList[16][2])
								if fffffID~=17 then--主手类型
									table.insert(PIG_EquipmentData.hejilist,k)
								end
							end
						else
							table.insert(PIG_EquipmentData.hejilist,k)
						end	
					end
				end
			end
		end
		if #PIG_EquipmentData.hejilist>0 then
			PIG_EquipmentData.konggekaishi=0
			PIG_EquipmentData.konggelist={}
			for bagID=0,4 do
				local numberOfFreeSlots, bagType = GetContainerNumFreeSlots(bagID)
				if numberOfFreeSlots>0 and bagType==0 then
					for ff=1,GetContainerNumSlots(bagID) do
						if GetContainerItemID(bagID, ff) then
						else
							table.insert(PIG_EquipmentData.konggelist,{bagID,ff})
							PIG_EquipmentData.konggekaishi=PIG_EquipmentData.konggekaishi+1
							if PIG_EquipmentData.konggekaishi==#PIG_EquipmentData.hejilist then
								break
							end
						end
					end
				end
				if PIG_EquipmentData.konggekaishi==#PIG_EquipmentData.hejilist then
					break
				end
			end
			for inv = 1, #PIG_EquipmentData.konggelist do
				local isLocked2 = IsInventoryItemLocked(PIG_EquipmentData.hejilist[inv])
				if not isLocked2 then
					PickupInventoryItem(PIG_EquipmentData.hejilist[inv])
					PickupContainerItem(PIG_EquipmentData.konggelist[inv][1], PIG_EquipmentData.konggelist[inv][2])
				end
			end
			if #PIG_EquipmentData.konggelist<#PIG_EquipmentData.hejilist then
				PIG_OptionsUI:ErrorMsg("更换"..(id-1).."号配装失败(背包剩余空间不足)")
				return
			end
		end
		PIG_OptionsUI:ErrorMsg("更换"..(id-1).."号配装成功")
		for inv = 1, 19 do
			local zhutisolt = _G["Character"..zhuangbeixilieID[inv][3].."Slot"]
			if ItemList[inv][1] then
				zhutisolt.ignored=true
			else
				zhutisolt.ignored=nil
			end
			PaperDollItemSlotButton_Update(zhutisolt)
		end
	else
		PIG_OptionsUI:ErrorMsg((id-1).."号配装尚未保存","R")
	end
end
_G[Data.QuickButUIname].EquipmentPIG={
	["NumTexCoord"]=NumTexCoord,
	["Equip_Save"]=Equip_Save,
	["Equip_Use"]=Equip_Use,
}
local function add_AutoEquip(ManageEquip)
	ManageEquip:Show()
	local CONTAINER_BAG_OFFSET= 30
	local itemTable = itemTable or {}
	local itemDisplayTable = {}
	local VERTICAL_FLYOUTS = { [16] = true, [17] = true, [18] = true }
	local PDFITEMFLYOUT_MAXITEMS = 23;
	local PDFITEMFLYOUT_ITEMS_PER_ROW = 5;
	local PDFITEMFLYOUT_BORDERWIDTH = 3;
	local PDFITEM_HEIGHT = 37;
	local PDFITEM_YOFFSET = -5;
	local PDFITEM_WIDTH = 37;
	local PDFITEM_XOFFSET = 4;
	local PDFITEMFLYOUT_HEIGHT = 43;
	local PDFITEMFLYOUT_ONESLOT_LEFT_COORDS = { 0, 0.09765625, 0.5546875, 0.77734375 }
	local PDFITEMFLYOUT_ONESLOT_LEFTWIDTH = 25;
	local PDFITEMFLYOUT_ONEROW_HEIGHT = 54;
	local PDFITEMFLYOUT_ONESLOT_RIGHT_COORDS = { 0.41796875, 0.51171875, 0.5546875, 0.77734375 }
	local PDFITEMFLYOUT_ONESLOT_RIGHTWIDTH = 24;
	local PDFITEMFLYOUT_UNIGNORESLOT_LOCATION = 0xFFFFFFFD;
	local PDFITEMFLYOUT_FIRST_SPECIAL_LOCATION = PDFITEMFLYOUT_UNIGNORESLOT_LOCATION
	local PDFITEMFLYOUT_ONEROW_LEFT_COORDS = { 0, 0.16796875, 0.5546875, 0.77734375 }
	local PDFITEMFLYOUT_ONEROW_LEFT_WIDTH = 43;
	local PDFITEMFLYOUT_ONEROW_RIGHT_COORDS = { 0.328125, 0.51171875, 0.5546875, 0.77734375 }
	local PDFITEMFLYOUT_ONEROW_RIGHT_WIDTH = 47;
	local PDFITEMFLYOUT_ONEROW_CENTER_COORDS = { 0.16796875, 0.328125, 0.5546875, 0.77734375 }
	local PDFITEMFLYOUT_ONEROW_CENTER_WIDTH = 41;
	local PDFITEMFLYOUT_IGNORESLOT_LOCATION = 0xFFFFFFFE;
	local PDFITEMFLYOUT_PLACEINBAGS_LOCATION = 0xFFFFFFFF;
	local EQUIPMENTMANAGER_INVENTORYSLOTS = {};
	local EQUIPMENTMANAGER_BAGSLOTS = {};
	local _isAtBank = false;
	local SLOT_LOCKED = -1;
	local SLOT_EMPTY = -2;
	local EQUIP_ITEM = 1;
	local UNEQUIP_ITEM = 2;
	local SWAP_ITEM = 3;
	for i = KEYRING_CONTAINER, NUM_BAG_SLOTS do
		EQUIPMENTMANAGER_BAGSLOTS[i] = {};
	end
	---------
	local function _createFlyoutBG (buttonAnchor)
		local numBGs = buttonAnchor["numBGs"];
		numBGs = numBGs + 1;
		local texture = buttonAnchor:CreateTexture(nil, nil, "PaperDollFrameFlyoutTexture");
		buttonAnchor["bg" .. numBGs] = texture;
		buttonAnchor["numBGs"] = numBGs;
		return texture;
	end
	local function EquipmentManager_UnpackLocation (location)
		if ( location < 0 ) then
			return false, false, false, 0;
		end
		local player = (bit.band(location, ITEM_INVENTORY_LOCATION_PLAYER) ~= 0);
		local bank = (bit.band(location, ITEM_INVENTORY_LOCATION_BANK) ~= 0);
		local bags = (bit.band(location, ITEM_INVENTORY_LOCATION_BAGS) ~= 0);
		if ( player ) then
			location = location - ITEM_INVENTORY_LOCATION_PLAYER;
		elseif ( bank ) then
			location = location - ITEM_INVENTORY_LOCATION_BANK;
		end
		if ( bags ) then
			location = location - ITEM_INVENTORY_LOCATION_BAGS;
			local bag = bit.rshift(location, ITEM_INVENTORY_BAG_BIT_OFFSET);
			local slot = location - bit.lshift(bag, ITEM_INVENTORY_BAG_BIT_OFFSET);	
			
			if ( bank ) then
				bag = bag + ITEM_INVENTORY_BANK_BAG_OFFSET;
			end
			return player, bank, bags, slot, bag
		else
			return player, bank, bags, location
		end
	end
	local function EquipmentManager_EquipItemByLocation (location, invSlot)
		local player, bank, bags, slot, bag = EquipmentManager_UnpackLocation(location);
		ClearCursor();	
		if ( not bags and slot == invSlot ) then		
			return nil;
		end
		local currentItemID = GetInventoryItemID("player", invSlot);
		local action = {};
		action.type = (currentItemID and SWAP_ITEM) or EQUIP_ITEM;
		action.invSlot = invSlot;
		action.player = player;
		action.bank = bank;
		action.bags = bags;
		action.slot = slot;
		action.bag = bag;
		return action;
	end
	local function EquipmentManager_UpdateFreeBagSpace ()
		local bagSlots = EQUIPMENTMANAGER_BAGSLOTS;
		for i = BANK_CONTAINER, NUM_BAG_SLOTS + GetNumBankSlots() do
			local _, bagType = GetContainerNumFreeSlots(i);
			local freeSlots = C_Container.GetContainerFreeSlots(i);
			if ( freeSlots ) then
				if (not bagSlots[i]) then
					bagSlots[i] = {};
				end
				for index, flag in next, bagSlots[i] do
					if (flag == SLOT_EMPTY) then
						bagSlots[i][index] = nil;
					end
				end
				for index, slot in ipairs(freeSlots) do
					if ( bagSlots[i] and not bagSlots[i][slot] and bagType == 0 ) then
						bagSlots[i][slot] = SLOT_EMPTY;
					end
				end
			else
				bagSlots[i] = nil;
			end
		end
	end
	local function EquipmentManager_EquipContainerItem (action)
		ClearCursor();
		PickupContainerItem(action.bag, action.slot);
		if ( not CursorHasItem() ) then
			return false;
		end
		if ( not CursorCanGoInSlot(action.invSlot) ) then
			return false;
		elseif ( IsInventoryItemLocked(action.invSlot) ) then
			return false;
		end
		PickupInventoryItem(action.invSlot);
		EQUIPMENTMANAGER_BAGSLOTS[action.bag][action.slot] = action.invSlot;
		EQUIPMENTMANAGER_INVENTORYSLOTS[action.invSlot] = SLOT_LOCKED;
		return true;
	end
	local function EquipmentManager_EquipInventoryItem (action)
		ClearCursor();
		PickupInventoryItem(action.slot);
		if ( not CursorCanGoInSlot(action.invSlot) ) then
			return false;
		elseif ( IsInventoryItemLocked(action.invSlot) ) then
			return false;
		end
		PickupInventoryItem(action.invSlot);
		EQUIPMENTMANAGER_INVENTORYSLOTS[action.slot] = SLOT_LOCKED;
		EQUIPMENTMANAGER_INVENTORYSLOTS[action.invSlot] = SLOT_LOCKED;
		return true;
	end
	local function EquipmentManager_PutItemInInventory (action)
		if ( not CursorHasItem() ) then
			return;
		end	
		EquipmentManager_UpdateFreeBagSpace();
		local bagSlots = EQUIPMENTMANAGER_BAGSLOTS;
		local firstSlot;
		for slot, flag in next, bagSlots[0] do
			if ( flag == SLOT_EMPTY ) then
				firstSlot = min(firstSlot or slot, slot);
			end
		end
		if ( firstSlot ) then
			if ( action ) then
				action.bag = 0;
				action.slot = firstSlot;
			end
			bagSlots[0][firstSlot] = SLOT_LOCKED;
			PutItemInBackpack();
			return true;
		end
		for bag = 1, NUM_BAG_SLOTS do
			if ( bagSlots[bag] ) then
				for slot, flag in next, bagSlots[bag] do
					if ( flag == SLOT_EMPTY ) then
						firstSlot = min(firstSlot or slot, slot);
					end
				end
				if ( firstSlot ) then
					bagSlots[bag][firstSlot] = SLOT_LOCKED;
					PutItemInBag(bag+CONTAINER_BAG_OFFSET);
					if ( action ) then
						action.bag = bag;
						action.slot = firstSlot;
					end
					return true;
				end
			end
		end
		if ( _isAtBank ) then
			for slot, flag in next, bagSlots[BANK_CONTAINER] do
				if ( flag == SLOT_EMPTY ) then
					firstSlot = min(firstSlot or slot, slot);
				end
			end
			if ( firstSlot ) then
				bagSlots[BANK_CONTAINER][firstSlot] = SLOT_LOCKED;
				PickupInventoryItem(firstSlot + BANK_CONTAINER_INVENTORY_OFFSET);
				if ( action ) then
					action.bag = BANK_CONTAINER;
					action.slot = firstSlot;
				end
				return true;
			else
				for bag = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + GetNumBankSlots() do
					if ( bagSlots[bag] ) then
						for slot, flag in next, bagSlots[bag] do
							if ( flag == SLOT_EMPTY ) then
								firstSlot = min(firstSlot or slot, slot);
							end
						end
						if ( firstSlot ) then
							bagSlots[bag][firstSlot] = SLOT_LOCKED;
							PickupContainerItem(bag, firstSlot);
							
							if ( action ) then
								action.bag = bag;
								action.slot = firstSlot;
							end
							return true;
						end
					end
				end
			end
		end
		ClearCursor();
		UIErrorsFrame:AddMessage(ERR_EQUIPMENT_MANAGER_BAGS_FULL, 1.0, 0.1, 0.1, 1.0);
	end
	local function EquipmentManager_RunAction (action)
		if ( UnitAffectingCombat("player") and not INVSLOTS_EQUIPABLE_IN_COMBAT[action.invSlot] ) then
			return true;
		end
		action.run = true;
		if ( action.type == EQUIP_ITEM or action.type == SWAP_ITEM ) then
			if ( not action.bags ) then
				return EquipmentManager_EquipInventoryItem(action);
			else
				local hasItem = action.invSlot and GetInventoryItemID("player", action.invSlot);
				local pending = EquipmentManager_EquipContainerItem(action);
				if ( pending and not hasItem ) then
					EQUIPMENTMANAGER_BAGSLOTS[action.bag][action.slot] = SLOT_EMPTY;
				end
				return pending;
			end
		elseif ( action.type == UNEQUIP_ITEM ) then
			ClearCursor();
			if ( IsInventoryItemLocked(action.invSlot) ) then
				return;
			else
				PickupInventoryItem(action.invSlot);
				return EquipmentManager_PutItemInInventory(action);
			end
		end
	end
	local function EquipmentManager_UnequipItemInSlot (invSlot)		
		local itemID = GetInventoryItemID("player", invSlot);
		if ( not itemID ) then
			return nil;
		end
		local action = {};
		action.type = UNEQUIP_ITEM;
		action.invSlot = invSlot;
		return action;
	end
	hooksecurefunc("PaperDollItemSlotButton_Update", function(self)
		if ( self.ignored and self.ignoreTexture ) then
			self.ignoreTexture:Show();
		elseif ( self.ignoreTexture ) then
			self.ignoreTexture:Hide();
		end
	end)
	local function PaperDollFrameItemFlyoutButton_OnClick (self)
		if ( self.location == PDFITEMFLYOUT_IGNORESLOT_LOCATION ) then
			local slot = PaperDollFrameItemFlyout.button;
			C_EquipmentSet.IgnoreSlotForSave(slot:GetID());
			slot.ignored = true;
			PaperDollItemSlotButton_Update(slot);
			PIG_EquipmentData.PaperDollFrameItemFlyout_Show(slot);
		elseif ( self.location == PDFITEMFLYOUT_UNIGNORESLOT_LOCATION ) then
			local slot = PaperDollFrameItemFlyout.button;
			C_EquipmentSet.UnignoreSlotForSave(slot:GetID());
			slot.ignored = nil;
			PaperDollItemSlotButton_Update(slot);
			PIG_EquipmentData.PaperDollFrameItemFlyout_Show(slot);
		elseif ( self.location == PDFITEMFLYOUT_PLACEINBAGS_LOCATION ) then
			if ( UnitAffectingCombat("player") and not INVSLOTS_EQUIPABLE_IN_COMBAT[PaperDollFrameItemFlyout.button:GetID()] ) then
				UIErrorsFrame:AddMessage(ERR_CLIENT_LOCKED_OUT, 1.0, 0.1, 0.1, 1.0);
				return;
			end
			local action = EquipmentManager_UnequipItemInSlot(PaperDollFrameItemFlyout.button:GetID());
			EquipmentManager_RunAction(action);
		elseif ( self.location ) then
			if ( UnitAffectingCombat("player") and not INVSLOTS_EQUIPABLE_IN_COMBAT[PaperDollFrameItemFlyout.button:GetID()] ) then
				UIErrorsFrame:AddMessage(ERR_CLIENT_LOCKED_OUT, 1.0, 0.1, 0.1, 1.0);
				return;
			end
			local action = EquipmentManager_EquipItemByLocation(self.location, self.id);
			EquipmentManager_RunAction(action);
		end
		if ( PaperDollFrameItemFlyout.button.popoutButton.flyoutLocked ) then
			PaperDollFrameItemFlyout_Hide();
		end
		PaperDollFrameItemFlyout:Hide()
	end
	local function PaperDollFrameItemFlyout_CreateButton()
		local buttons = PaperDollFrameItemFlyout.buttons;
		local buttonAnchor = PaperDollFrameItemFlyoutButtons;	
		local numButtons = #buttons;
		local button = CreateFrame("BUTTON", "PaperDollFrameItemFlyoutButtons" .. numButtons + 1, buttonAnchor, "PIGpopoutButton_Flyout_ButtonTemplate");
		button:HookScript("OnEnter", function(self)
			if self.UpdateTooltip then self.UpdateTooltip(); end
			PaperDollFrameItemFlyout.FlyoutButShow=nil 
		end);
		button:HookScript("OnLeave", function()
			GameTooltip:Hide();ResetCursor();
			PaperDollFrameItemFlyout.FlyoutButShow=true
			PaperDollFrameItemFlyout.showTimer=0.2
		end);
		button:HookScript("OnClick", PaperDollFrameItemFlyoutButton_OnClick);
		local pos = numButtons/PDFITEMFLYOUT_ITEMS_PER_ROW;
		if ( math.floor(pos) == pos ) then
			button:SetPoint("TOPLEFT", buttonAnchor, "TOPLEFT", PDFITEMFLYOUT_BORDERWIDTH, -PDFITEMFLYOUT_BORDERWIDTH - (PDFITEM_HEIGHT - PDFITEM_YOFFSET)* pos);
		else
			button:SetPoint("TOPLEFT", buttons[numButtons], "TOPRIGHT", PDFITEM_XOFFSET, 0);
		end
		tinsert(buttons, button);
		return button
	end
	local function EquipmentManager_GetItemInfoByLocation (location)
		local player, bank, bags, slot, bag = EquipmentManager_UnpackLocation(location);
		if ( not player and not bank and not bags ) then -- Invalid location
			return;
		end
		local id, name, textureName, count, durability, maxDurability, invType, locked, start, duration, enable, setTooltip, gem1, gem2, gem3, _;
		if ( not bags ) then -- and (player or bank) 
			id = GetInventoryItemID("player", slot);
			name, _, _, _, _, _, _, _, invType, textureName = GetItemInfo(id);
			if ( textureName ) then
				count = GetInventoryItemCount("player", slot);
				durability, maxDurability = GetInventoryItemDurability(slot);
				start, duration, enable = GetInventoryItemCooldown("player", slot);
			end
			setTooltip = function () GameTooltip:SetInventoryItem("player", slot) end;
			gem1, gem2, gem3 = GetInventoryItemGems(slot);
		else -- bags
			id = C_Container.GetContainerItemID(bag, slot);
			name, _, _, _, _, _, _, _, invType = GetItemInfo(id);
			local info = C_Container.GetContainerItemInfo(bag, slot);
			local itemID, itemLink, icon, stackCount, quality, noValue, lootable, locked=PIGGetContainerItemInfo(bag, slot)
			textureName = icon;
			count = stackCount;
			start, duration, enable = C_Container.GetContainerItemCooldown(bag, slot);
			durability, maxDurability = C_Container.GetContainerItemDurability(bag, slot);
			setTooltip = function () GameTooltip:SetBagItem(bag, slot); end;
			gem1, gem2, gem3 = C_Container.GetContainerItemGems(bag, slot);
		end
		return id, name, textureName, count, durability, maxDurability, invType, locked, start, duration, enable, setTooltip, gem1, gem2, gem3;
	end
	local function PaperDollFrameItemFlyout_DisplaySpecialButton (button, paperDollItemSlot)
		local location = button.location;
		if ( location == PDFITEMFLYOUT_IGNORESLOT_LOCATION ) then
			SetItemButtonTexture(button, "Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Opaque");
			SetItemButtonCount(button, nil);
			button.UpdateTooltip = 
				function () 
					GameTooltip:SetOwner(PaperDollFrameItemFlyoutButtons, "ANCHOR_RIGHT", 6, -PaperDollFrameItemFlyoutButtons:GetHeight() - 6);
					GameTooltip:SetText(EQUIPMENT_MANAGER_IGNORE_SLOT, 1.0, 1.0, 1.0); 
					if ( SHOW_NEWBIE_TIPS == "1" ) then
						GameTooltip:AddLine(NEWBIE_TOOLTIP_EQUIPMENT_MANAGER_IGNORE_SLOT, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
					end
					GameTooltip:Show();
				end;
			SetItemButtonTextureVertexColor(button, 1.0, 1.0, 1.0);
			SetItemButtonNormalTextureVertexColor(button, 1.0, 1.0, 1.0);
		elseif ( location == PDFITEMFLYOUT_UNIGNORESLOT_LOCATION ) then
			SetItemButtonTexture(button, "Interface\\PaperDollInfoFrame\\UI-GearManager-Undo");
			SetItemButtonCount(button, nil);
			button.UpdateTooltip = 
				function () 
					GameTooltip:SetOwner(PaperDollFrameItemFlyoutButtons, "ANCHOR_RIGHT", 6, -PaperDollFrameItemFlyoutButtons:GetHeight() - 6); 
					GameTooltip:SetText(EQUIPMENT_MANAGER_UNIGNORE_SLOT, 1.0, 1.0, 1.0); 
					if ( SHOW_NEWBIE_TIPS == "1" ) then
						GameTooltip:AddLine(NEWBIE_TOOLTIP_EQUIPMENT_MANAGER_UNIGNORE_SLOT, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
					end
					GameTooltip:Show();
				end;
			SetItemButtonTextureVertexColor(button, 1.0, 1.0, 1.0);
			SetItemButtonNormalTextureVertexColor(button, 1.0, 1.0, 1.0);		
		elseif ( location == PDFITEMFLYOUT_PLACEINBAGS_LOCATION ) then
			SetItemButtonTexture(button, "Interface\\PaperDollInfoFrame\\UI-GearManager-ItemIntoBag");
			SetItemButtonCount(button, nil);
			button.UpdateTooltip = 
				function () 
					GameTooltip:SetOwner(PaperDollFrameItemFlyoutButtons, "ANCHOR_RIGHT", 6, -PaperDollFrameItemFlyoutButtons:GetHeight() - 6);
					GameTooltip:SetText(EQUIPMENT_MANAGER_PLACE_IN_BAGS, 1.0, 1.0, 1.0); 
					if ( SHOW_NEWBIE_TIPS == "1" ) then
						GameTooltip:AddLine(NEWBIE_TOOLTIP_EQUIPMENT_MANAGER_PLACE_IN_BAGS, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
					end
					GameTooltip:Show();
				end;
			SetItemButtonTextureVertexColor(button, 1.0, 1.0, 1.0);
			SetItemButtonNormalTextureVertexColor(button, 1.0, 1.0, 1.0);	
		end
		if ( button:IsMouseOver() and button.UpdateTooltip ) then
			button.UpdateTooltip();
		end
	end
	local function PaperDollFrameItemFlyout_DisplayButton (button, paperDollItemSlot)
		local location = button.location;
		if ( not location ) then
			return;
		end
		if ( location >= PDFITEMFLYOUT_FIRST_SPECIAL_LOCATION ) then
			PaperDollFrameItemFlyout_DisplaySpecialButton(button, paperDollItemSlot);
			return;
		end
		local id, name, textureName, count, durability, maxDurability, invType, locked, start, duration, enable, setTooltip = EquipmentManager_GetItemInfoByLocation(location);
		local broken = ( maxDurability and durability == 0 );
		if ( textureName ) then
			SetItemButtonTexture(button, textureName);
			SetItemButtonCount(button, count);
			if ( broken ) then
				SetItemButtonTextureVertexColor(button, 0.9, 0, 0);
				SetItemButtonNormalTextureVertexColor(button, 0.9, 0, 0);
			else
				SetItemButtonTextureVertexColor(button, 1.0, 1.0, 1.0);
				SetItemButtonNormalTextureVertexColor(button, 1.0, 1.0, 1.0);
			end
			-- CooldownFrame_SetTimer(button.cooldown, start, duration, enable);
			button.UpdateTooltip = function () GameTooltip:SetOwner(PaperDollFrameItemFlyoutButtons, "ANCHOR_RIGHT", 6, -PaperDollFrameItemFlyoutButtons:GetHeight() - 6); setTooltip(); end;
			if ( button:IsMouseOver() ) then
				button.UpdateTooltip();
			end
		else
			textureName = paperDollItemSlot.backgroundTextureName;
			if ( paperDollItemSlot.checkRelic and UnitHasRelicSlot("player") ) then
				textureName = "Interface\\Paperdoll\\UI-PaperDoll-Slot-Relic.blp";
			end
			SetItemButtonTexture(button, textureName);
			SetItemButtonCount(button, 0);
			SetItemButtonTextureVertexColor(button, 1.0, 1.0, 1.0);
			SetItemButtonNormalTextureVertexColor(button, 1.0, 1.0, 1.0);
			button.cooldown:Hide();
			button.UpdateTooltip = nil;
		end
	end
	function PIG_EquipmentData.PaperDollFrameItemFlyout_Show(paperDollItemSlot)
		local id = paperDollItemSlot:GetID();
		local flyout = PaperDollFrameItemFlyout;
		local buttons = flyout.buttons;
		local buttonAnchor = flyout.buttonFrame;
		if ( flyout.button and flyout.button ~= paperDollItemSlot ) then
			local popoutButton = flyout.button.popoutButton;
			if ( popoutButton.flyoutLocked ) then
				popoutButton.flyoutLocked = false;
				PaperDollFrameItemPopoutButton_SetReversed(popoutButton, false);
			end
		end
		for k in next, itemDisplayTable do
			itemDisplayTable[k] = nil;
		end
		for k in next, itemTable do
			itemTable[k] = nil;
		end
		GetInventoryItemsForSlot(id, itemTable);
		for location, itemID in next, itemTable do
			if ( location - id == ITEM_INVENTORY_LOCATION_PLAYER ) then -- Remove the currently equipped item from the list
				itemTable[location] = nil;
			else
				tinsert(itemDisplayTable, location);
			end
		end
		table.sort(itemDisplayTable); -- Sort by location. This ends up as: inventory, backpack, bags, bank, and bank bags.
		local numItems = #itemDisplayTable;
		for i = PDFITEMFLYOUT_MAXITEMS + 1, numItems do
			itemDisplayTable[i] = nil;
		end
		numItems = min(numItems, PDFITEMFLYOUT_MAXITEMS);
		if ( not paperDollItemSlot.ignored ) then
			tinsert(itemDisplayTable, 1, PDFITEMFLYOUT_IGNORESLOT_LOCATION);
		else
			tinsert(itemDisplayTable, 1, PDFITEMFLYOUT_UNIGNORESLOT_LOCATION);
		end
		numItems = numItems + 1;
		if ( paperDollItemSlot.hasItem ) then
			tinsert(itemDisplayTable, 1, PDFITEMFLYOUT_PLACEINBAGS_LOCATION);
			numItems = numItems + 1;
		end
		while #buttons < numItems do -- Create any buttons we need.
			PaperDollFrameItemFlyout_CreateButton();
		end
		if ( numItems == 0 ) then
			flyout:Hide();
			return;
		end
		for i, button in ipairs(buttons) do
			if ( i <= numItems ) then
				button.id = id;
				button.location = itemDisplayTable[i];
				button:Show();
				PaperDollFrameItemFlyout_DisplayButton(button, paperDollItemSlot);
			else
				button:Hide();
			end
		end
		flyout:ClearAllPoints();
		flyout:SetFrameLevel(paperDollItemSlot:GetFrameLevel() - 1);
		flyout.button = paperDollItemSlot;
		flyout:SetPoint("TOPLEFT", paperDollItemSlot, "TOPLEFT", -PDFITEMFLYOUT_BORDERWIDTH, PDFITEMFLYOUT_BORDERWIDTH);
		local horizontalItems = min(numItems, PDFITEMFLYOUT_ITEMS_PER_ROW);
		if ( paperDollItemSlot.verticalFlyout ) then
			buttonAnchor:SetPoint("TOPLEFT", paperDollItemSlot.popoutButton, "BOTTOMLEFT", -3, 0);
		else
			buttonAnchor:SetPoint("TOPLEFT", paperDollItemSlot.popoutButton, "TOPRIGHT", 0, 3);
		end
		buttonAnchor:SetWidth((horizontalItems * PDFITEM_WIDTH) + ((horizontalItems - 1) * PDFITEM_XOFFSET) + PDFITEMFLYOUT_BORDERWIDTH);
		buttonAnchor:SetHeight(PDFITEMFLYOUT_HEIGHT + (math.floor((numItems - 1)/PDFITEMFLYOUT_ITEMS_PER_ROW) * (PDFITEM_HEIGHT - PDFITEM_YOFFSET)));
		if ( flyout.numItems ~= numItems ) then
			local texturesUsed = 0;
			if ( numItems == 1 ) then
				local bgTex, lastBGTex;
				bgTex = buttonAnchor.bg1;
				bgTex:ClearAllPoints();
				bgTex:SetTexCoord(unpack(PDFITEMFLYOUT_ONESLOT_LEFT_COORDS));
				bgTex:SetWidth(PDFITEMFLYOUT_ONESLOT_LEFTWIDTH);
				bgTex:SetHeight(PDFITEMFLYOUT_ONEROW_HEIGHT);
				bgTex:SetPoint("TOPLEFT", -5, 4);
				bgTex:Show();
				texturesUsed = texturesUsed + 1;
				lastBGTex = bgTex;
				
				bgTex = buttonAnchor.bg2 or _createFlyoutBG(buttonAnchor);
				bgTex:ClearAllPoints();
				bgTex:SetTexCoord(unpack(PDFITEMFLYOUT_ONESLOT_RIGHT_COORDS));
				bgTex:SetWidth(PDFITEMFLYOUT_ONESLOT_RIGHTWIDTH);
				bgTex:SetHeight(PDFITEMFLYOUT_ONEROW_HEIGHT);
				bgTex:SetPoint("TOPLEFT", lastBGTex, "TOPRIGHT");
				bgTex:Show();
				texturesUsed = texturesUsed + 1;
				lastBGTex = bgTex;
			elseif ( numItems <= PDFITEMFLYOUT_ITEMS_PER_ROW ) then
				local bgTex, lastBGTex;
				bgTex = buttonAnchor.bg1;
				bgTex:ClearAllPoints();
				bgTex:SetTexCoord(unpack(PDFITEMFLYOUT_ONEROW_LEFT_COORDS));
				bgTex:SetWidth(PDFITEMFLYOUT_ONEROW_LEFT_WIDTH);
				bgTex:SetHeight(PDFITEMFLYOUT_ONEROW_HEIGHT);
				bgTex:SetPoint("TOPLEFT", -5, 4);
				bgTex:Show();
				texturesUsed = texturesUsed + 1;
				lastBGTex = bgTex;
				for i = texturesUsed + 1, numItems - 1 do
					bgTex = buttonAnchor["bg"..i] or _createFlyoutBG(buttonAnchor);
					bgTex:ClearAllPoints();
					bgTex:SetTexCoord(unpack(PDFITEMFLYOUT_ONEROW_CENTER_COORDS));
					bgTex:SetWidth(PDFITEMFLYOUT_ONEROW_CENTER_WIDTH);
					bgTex:SetHeight(PDFITEMFLYOUT_ONEROW_HEIGHT);
					bgTex:SetPoint("TOPLEFT", lastBGTex, "TOPRIGHT");
					bgTex:Show();
					texturesUsed = texturesUsed + 1;
					lastBGTex = bgTex;
				end
				bgTex = buttonAnchor["bg"..numItems] or _createFlyoutBG(buttonAnchor);
				bgTex:ClearAllPoints();
				bgTex:SetTexCoord(unpack(PDFITEMFLYOUT_ONEROW_RIGHT_COORDS));
				bgTex:SetWidth(PDFITEMFLYOUT_ONEROW_RIGHT_WIDTH);
				bgTex:SetHeight(PDFITEMFLYOUT_ONEROW_HEIGHT);
				bgTex:SetPoint("TOPLEFT", lastBGTex, "TOPRIGHT");
				bgTex:Show();
				texturesUsed = texturesUsed + 1;
			elseif ( numItems > PDFITEMFLYOUT_ITEMS_PER_ROW ) then
				local numRows = math.ceil(numItems/PDFITEMFLYOUT_ITEMS_PER_ROW);
				local bgTex, lastBGTex;
				bgTex = buttonAnchor.bg1;
				bgTex:ClearAllPoints();
				bgTex:SetTexCoord(unpack(PDFITEMFLYOUT_MULTIROW_TOP_COORDS));
				bgTex:SetWidth(PDFITEMFLYOUT_MULTIROW_WIDTH);
				bgTex:SetHeight(PDFITEMFLYOUT_MULTIROW_TOP_HEIGHT);
				bgTex:SetPoint("TOPLEFT", -5, 4);
				bgTex:Show();
				texturesUsed = texturesUsed + 1;
				lastBGTex = bgTex;
				for i = 2, numRows - 1 do -- Middle rows
					bgTex = buttonAnchor["bg"..i] or _createFlyoutBG(buttonAnchor);
					bgTex:ClearAllPoints();
					bgTex:SetTexCoord(unpack(PDFITEMFLYOUT_MULTIROW_MIDDLE_COORDS));
					bgTex:SetWidth(PDFITEMFLYOUT_MULTIROW_WIDTH);
					bgTex:SetHeight(PDFITEMFLYOUT_MULTIROW_MIDDLE_HEIGHT);
					bgTex:SetPoint("TOPLEFT", lastBGTex, "BOTTOMLEFT");
					bgTex:Show();
					texturesUsed = texturesUsed + 1;
					lastBGTex = bgTex;
				end
				bgTex = buttonAnchor["bg"..numRows] or _createFlyoutBG(buttonAnchor);
				bgTex:ClearAllPoints();
				bgTex:SetTexCoord(unpack(PDFITEMFLYOUT_MULTIROW_BOTTOM_COORDS));
				bgTex:SetWidth(PDFITEMFLYOUT_MULTIROW_WIDTH);
				bgTex:SetHeight(PDFITEMFLYOUT_MULTIROW_BOTTOM_HEIGHT);
				bgTex:SetPoint("TOPLEFT", lastBGTex, "BOTTOMLEFT");
				bgTex:Show();
				texturesUsed = texturesUsed + 1;
				lastBGTex = bgTex;
			end
			for i = texturesUsed + 1, buttonAnchor["numBGs"] do
				buttonAnchor["bg" .. i]:Hide();
			end
			flyout.numItems = numItems;
		end
		flyout:Show();
	end
	local function PIG_popoutButton_OnEnter(self)
		if not GearManagerToggleButton.F:IsShown() then return end
		self.popoutButton:GetNormalTexture():SetDesaturated(false)
		PIG_EquipmentData.PaperDollFrameItemFlyout_Show(self);
		PaperDollFrameItemFlyout.FlyoutButShow=nil
	end
	local function PIG_popoutButton_OnLeave(self)
		self.popoutButton:GetNormalTexture():SetDesaturated(true)
		PaperDollFrameItemFlyout.FlyoutButShow=true
		PaperDollFrameItemFlyout.showTimer=0.2
	end
	local function PIG_popoutButton_OnUpdate(self, elapsed)
		if not self.FlyoutButShow then return end
		if self.FlyoutButShow then
			if self.showTimer<= 0 then
				self:Hide();
				self.FlyoutButShow = nil;
			else
				self.showTimer = self.showTimer - elapsed;	
			end
		end
	end
	local function PIG_popoutButton_OnLoad(self)
		local slotName = self:GetName();
		local id, textureName, checkRelic = GetInventorySlotInfo(strsub(slotName,10));
		self:SetID(id);
		self.verticalFlyout = VERTICAL_FLYOUTS[id];
		local popoutButton = self.popoutButton;
		if ( popoutButton ) then
			if ( self.verticalFlyout ) then
				popoutButton:SetSize(38,16);
				popoutButton:GetNormalTexture():SetTexCoord(0.15625, 0.84375, 0.5, 0);
				popoutButton:GetHighlightTexture():SetTexCoord(0.15625, 0.84375, 1, 0.5);
				popoutButton:ClearAllPoints();
				popoutButton:SetPoint("TOP", self, "BOTTOM", 0, 4);
			else
				popoutButton:SetSize(16,38);
				popoutButton:GetNormalTexture():SetTexCoord(0.15625, 0.5, 0.84375, 0.5, 0.15625, 0, 0.84375, 0);
				popoutButton:GetHighlightTexture():SetTexCoord(0.15625, 1, 0.84375, 1, 0.15625, 0.5, 0.84375, 0.5);
				popoutButton:ClearAllPoints();
				popoutButton:SetPoint("LEFT", self, "RIGHT", -6, 0);
			end
		end
	end
	for inv = 1, 19 do
		local zhutisolt = _G["Character"..zhuangbeixilieID[inv][3].."Slot"]
		zhutisolt:HookScript("OnEnter", PIG_popoutButton_OnEnter);
		zhutisolt:HookScript("OnLeave", PIG_popoutButton_OnLeave);
		zhutisolt.popoutButton = CreateFrame("Button",nil,zhutisolt);
		zhutisolt.popoutButton:SetNormalTexture("Interface/PaperDollInfoFrame/UI-GearManager-FlyoutButton")
		zhutisolt.popoutButton:SetHighlightTexture("Interface/PaperDollInfoFrame/UI-GearManager-FlyoutButton");
		zhutisolt.popoutButton:GetNormalTexture():SetDesaturated(true)
		zhutisolt.popoutButton:Hide()
		zhutisolt.popoutButton:HookScript("OnEnter", function() PIG_popoutButton_OnEnter(zhutisolt) end);
		zhutisolt.popoutButton:HookScript("OnLeave", function() PIG_popoutButton_OnLeave(zhutisolt) end);
		zhutisolt.ignoreTexture = zhutisolt:CreateTexture(nil,"OVERLAY");
		zhutisolt.ignoreTexture:SetTexture("Interface/PaperDollInfoFrame/UI-GearManager-LeaveItem-Transparent");
		zhutisolt.ignoreTexture:SetSize(40,40);
		zhutisolt.ignoreTexture:SetPoint("CENTER", 0, 0);
		zhutisolt.ignoreTexture:Hide()
		PIG_popoutButton_OnLoad(zhutisolt)
	end
	local flyout = CreateFrame("Frame", "PaperDollFrameItemFlyout", PaperDollFrame);
	flyout:SetSize(43,43);
	flyout:Hide()
	flyout:SetFrameStrata("HIGH")
	flyout.buttons = {};
	flyout:HookScript("OnUpdate", PIG_popoutButton_OnUpdate);
	flyout:HookScript("OnHide", function(self)
		PaperDollFrameItemFlyout.FlyoutButShow=true
		PaperDollFrameItemFlyout.showTimer=0.1
    end)
	flyout.Highlight = flyout:CreateTexture(nil,"ARTWORK");
	flyout.Highlight:SetTexture("Interface/PaperDollInfoFrame/UI-GearManager-ItemButton-Highlight");
	flyout.Highlight:SetSize(50,50);
	flyout.Highlight:SetPoint("LEFT", -4, 0);
	flyout.Highlight:SetTexCoord(0,0.78125,0,0.78125)
	
	local parentButtons = CreateFrame("Frame", "PaperDollFrameItemFlyoutButtons", flyout);
	parentButtons:SetPoint("TOPLEFT", flyout, "TOPRIGHT", 0, 0);
	parentButtons.bg1 = parentButtons:CreateTexture(nil,"BACKGROUND");
	parentButtons.bg1:SetTexture("Interface/PaperDollInfoFrame/UI-GearManager-Flyout");
	parentButtons.bg1:SetPoint("LEFT", -5, 4);
	parentButtons.numBGs = 1;
	parentButtons:HookScript("OnEnter", function() 
		PaperDollFrameItemFlyout.FlyoutButShow=nil 
	end);
	parentButtons:HookScript("OnLeave", function() 
		PaperDollFrameItemFlyout.FlyoutButShow=true
		PaperDollFrameItemFlyout.showTimer=0.2
	end);
	flyout.buttonFrame=parentButtons
	--
	GearManagerToggleButton=ManageEquip
	PaperDollFrame:HookScript("OnHide", function()
		ManageEquip.F:Hide()
    end)
	ManageEquip.F.EquipBut = PIGButton(ManageEquip.F,nil,nil,nil,nil,nil,nil,nil,0);
	ManageEquip.F.EquipBut:SetSize(80,24);
	ManageEquip.F.EquipBut:SetPoint("TOPLEFT", ManageEquip.F, "TOPLEFT", 10, -16);
	ManageEquip.F.EquipBut:SetText(EQUIPSET_EQUIP);
	ManageEquip.F.EquipBut:Disable();
	ManageEquip.F.EquipBut:HookScript("OnClick", function (self)
		Equip_Use(ManageEquip.xuanzhongID)
	end);
	ManageEquip.F.SaveBut = PIGButton(ManageEquip.F,nil,nil,nil,nil,nil,nil,nil,0);
	ManageEquip.F.SaveBut:SetSize(80,24);
	ManageEquip.F.SaveBut:SetPoint("LEFT", ManageEquip.F.EquipBut, "RIGHT", 10, 0);
	ManageEquip.F.SaveBut:SetText(SAVE);
	ManageEquip.F.SaveBut:Disable();
	ManageEquip.F.SaveBut:HookScript("OnClick", function (self)
		Equip_Save(ManageEquip.xuanzhongID)
		ManageEquip.Update_hang()
	end);
	--装备
	local list_WW,hang_Height = 176,31
	local function save_Equipdata(self)
		local shangjiF=self:GetParent()
		local eeerrr=shangjiF.E:GetText()
		if eeerrr=="" then
			PIGA_Per["QuickBut"]["EquipList"][shangjiF:GetID()]=nil
		else
			if PIGA_Per["QuickBut"]["EquipList"][shangjiF:GetID()] then
				PIGA_Per["QuickBut"]["EquipList"][shangjiF:GetID()][1]=eeerrr
			else
				PIGA_Per["QuickBut"]["EquipList"][shangjiF:GetID()]={eeerrr,nil}
			end
		end
 		ManageEquip.Update_hang()
	end
	ManageEquip.F.EquipF = PIGFrame(ManageEquip.F);
	ManageEquip.F.EquipF:SetSize(list_WW,anniushu*hang_Height);
	ManageEquip.F.EquipF:SetPoint("BOTTOMLEFT", ManageEquip.F, "BOTTOMLEFT", 7, 2);
	ManageEquip.F.EquipF.ButList={}
	for id = anniushu,1,-1  do
		local list = CreateFrame("Button",nil,ManageEquip.F.EquipF, "TruncatedButtonTemplate",id);
		ManageEquip.F.EquipF.ButList[id]=list 
		list:SetSize(list_WW, hang_Height);
		if id==anniushu then
			list:SetPoint("BOTTOM",ManageEquip.F.EquipF,"BOTTOM",0,0);
		else
			list:SetPoint("BOTTOM",ManageEquip.F.EquipF.ButList[id+1],"TOP",0,0);
		end
		PIGLine(list,"TOP",nil,nil,nil,{0.3,0.3,0.3,0.3})
		list.highlight = list:CreateTexture(nil, "BORDER");
		list.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
		list.highlight:SetBlendMode("ADD")
		list.highlight:SetPoint("LEFT", list, "LEFT", 2,0);
		list.highlight:SetSize(list_WW-3,hang_Height);
		list.highlight:SetAlpha(0.4);
		list.highlight:Hide();
		list.xuanzhong = list:CreateTexture(nil, "BORDER");
		list.xuanzhong:SetTexture("interface/buttons/ui-listbox-highlight.blp");
		list.xuanzhong:SetPoint("LEFT", list, "LEFT", 2,0);
		list.xuanzhong:SetSize(list_WW-3,hang_Height);
		list.xuanzhong:SetAlpha(0.9);
		list.xuanzhong:Hide();
		list:HookScript("OnEnter", function (self)
			if not self.xuanzhong:IsShown() then
				self.highlight:Show();
			end
		end);
		list:HookScript("OnLeave", function (self)
			self.highlight:Hide();
		end);
		list:HookScript("OnClick", function (self)
			ManageEquip.F.EquipBut:Enable();
			ManageEquip.F.SaveBut:Enable();
			ManageEquip.xuanzhongID=self:GetID();
			ManageEquip.Update_hang()
		end);
		list.xuhao = list:CreateTexture();
		list.xuhao:SetSize(hang_Height-3,hang_Height-3);
		list.xuhao:SetPoint("LEFT", list, "LEFT", 0,0);
		list.xuhao:SetTexture("interface/timer/bigtimernumbers.blp");
		list.xuhao:SetTexCoord(NumTexCoord[id][1],NumTexCoord[id][2],NumTexCoord[id][3],NumTexCoord[id][4]);
		list.name = PIGFontString(list,{"LEFT",list.xuhao,"RIGHT",6,0},EMPTY,"OUTLINE");
		list.name:SetTextColor(1, 0.843, 0, 1);
		list.name:SetSize(list_WW-hang_Height,hang_Height);
		list.name:SetJustifyH("LEFT")

		list.E = CreateFrame("EditBox", nil, list, "InputBoxInstructionsTemplate");
		list.E:SetSize(list_WW-60,hang_Height);
		list.E:SetPoint("LEFT",list.xuhao,"RIGHT",6,0);
		PIGSetFont(list.E, 14, "OUTLINE")
		list.E:SetMaxLetters(8)
		list.E:Hide()
		list.E:HookScript("OnEscapePressed", function(self) 
			ManageEquip.Update_hang()
		end);
		list.E:HookScript("OnEnterPressed", function(self)
	 		save_Equipdata(self)
		end);
		list.B = CreateFrame("Button",nil,list, "TruncatedButtonTemplate");
		list.B:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		list.B:SetSize(hang_Height-10,hang_Height-4);
		list.B:SetPoint("RIGHT", list, "RIGHT", 0,0);
		list.B.Texture = list.B:CreateTexture();
		list.B.Texture:SetTexture("interface/buttons/ui-guildbutton-publicnote-up.blp");
		list.B.Texture:SetPoint("CENTER");
		list.B.Texture:SetSize(hang_Height-12,hang_Height-10);
		list.B:HookScript("OnMouseDown", function (self)
			self.Texture:SetPoint("CENTER",-1.5,-1.5);
		end);
		list.B:HookScript("OnMouseUp", function (self)
			self.Texture:SetPoint("CENTER");
		end);
		list.B:HookScript("OnClick", function (self)
			ManageEquip.Update_hang()
			local shangjiF=self:GetParent()
			shangjiF.name:Hide()
			shangjiF.B:Hide()
			shangjiF.E:Show()
			shangjiF.Q:Show()
			if shangjiF.name:GetText()==EMPTY then
				shangjiF.E:SetText("");
			else
				shangjiF.E:SetText(shangjiF.name:GetText());
			end
		end);
		list.Q = CreateFrame("Button",nil,list, "TruncatedButtonTemplate");
		list.Q:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		list.Q:SetSize(hang_Height-10,hang_Height-4);
		list.Q:SetPoint("RIGHT", list, "RIGHT", 0,0);
		list.Q:Hide();
		list.Q.Texture = list.Q:CreateTexture();
		list.Q.Texture:SetTexture("interface/raidframe/readycheck-ready.blp");
		list.Q.Texture:SetPoint("CENTER");
		list.Q.Texture:SetSize(hang_Height-11,hang_Height-11);
		list.Q:HookScript("OnMouseDown", function (self)
			self.Texture:SetPoint("CENTER",-1.5,-1.5);
		end);
		list.Q:HookScript("OnMouseUp", function (self)
			self.Texture:SetPoint("CENTER");
		end);
		list.Q:HookScript("OnClick", function (self)
			save_Equipdata(self)
		end);
	end
	ManageEquip.F.EquipF:HookScript("OnShow", function(self)
		for inv = 1, 19 do
			local zhutisolt = _G["Character"..zhuangbeixilieID[inv][3].."Slot"]
			zhutisolt.popoutButton:Show()
		end
		ManageEquip.Update_hang()
	end)
	ManageEquip.F.EquipF:HookScript("OnHide", function(self)
		for inv = 1, 19 do
			local zhutisolt = _G["Character"..zhuangbeixilieID[inv][3].."Slot"]
			zhutisolt.popoutButton:Hide()
			zhutisolt.ignoreTexture:Hide()
			zhutisolt.ignored = nil;
		end
		flyout:Hide()
	end)
	function ManageEquip.Update_hang()
		if not ManageEquip.F:IsVisible() then return end
		for id = 1, anniushu do
			local hang = ManageEquip.F.EquipF.ButList[id]
			hang.E:Hide()
			hang.Q:Hide()
			hang.B:Show()
			hang.name:Show()
			hang.name:SetTextColor(0.8, 0.8, 0.8, 0.8);
			hang.name:SetText(EMPTY);
			local hangitem = PIGA_Per["QuickBut"]["EquipList"][id]
			if hangitem then
				if hangitem[1] and hangitem[2] then
					hang.name:SetText(hangitem[1]);
					hang.name:SetTextColor(1, 1, 1, 1);
				end	
			end
			if ManageEquip.xuanzhongID==id then
				hang.xuanzhong:Show()
			else
				hang.xuanzhong:Hide()
			end
		end
	end
end
function FramePlusfun.Character_Shuxing()
	if not PIGA["FramePlus"]["Character_Shuxing"] then return end
	if PIG_MaxTocversion(30000) then
		if PaperDollFrame.pigBGF then return end
		local CharacterFW = {384,570,2}
		if C_Engraving and C_Engraving.IsEngravingEnabled() then CharacterFW[3]=3 end
		PaperDollFrame:ClearAllPoints();
		PaperDollFrame:SetPoint("TOPLEFT", CharacterFrame,"TOPLEFT", 0, 0);
		PaperDollFrame:SetPoint("BOTTOMLEFT", CharacterFrame,"BOTTOMLEFT", 0, 0);
		PaperDollFrame:SetWidth(CharacterFW[2])
		--处理系统
		local wllist = {PaperDollFrame:GetRegions()}
		for k,v in pairs(wllist) do
			if not v:GetName() then v:Hide() end
		end
		---NEWBG
		PaperDollFrame.pigBGF = CreateFrame("Frame",nil,PaperDollFrame)
		PaperDollFrame.pigBGF:SetFrameLevel(1)
		PaperDollFrame.pigBGF:SetSize(CharacterFW[2]-33,439);
		PaperDollFrame.pigBGF:SetPoint("TOPLEFT",PaperDollFrame,"TOPLEFT",1,-3);
		if ElvUI or NDui then
			PaperDollFrame.InsetL=PIGFrame(PaperDollFrame)
			CharacterModelFrame.InsetR=PIGFrame(CharacterModelFrame)
			if NDui then 
				PaperDollFrame.InsetRBG=PIGFrame(PaperDollFrame)
				PaperDollFrame.InsetRBG:PIGSetBackdrop(0.6)
				PaperDollFrame.InsetRBG:SetSize(CharacterFW[2]-382,424.3);
				PaperDollFrame.InsetRBG:SetPoint("TOPRIGHT",PaperDollFrame,"TOPRIGHT",-34,-15);
			end
			PaperDollFrame.InsetR=PIGFrame(PaperDollFrame)
		else
			Create.CharacterBG(PaperDollFrame.pigBGF)
			PaperDollFrame.InsetL = CreateFrame("Frame",nil,PaperDollFrame,"InsetFrameTemplate")
			CharacterModelFrame.InsetR = CreateFrame("Frame",nil,CharacterModelFrame,"InsetFrameTemplate")	
			PaperDollFrame.InsetR = CreateFrame("Frame",nil,PaperDollFrame,"InsetFrameTemplate")		
		end
		PaperDollFrame.InsetL:SetSize(328,365);
		PaperDollFrame.InsetL:SetPoint("TOPLEFT",PaperDollFrame,"TOPLEFT",18,-68);
		CharacterModelFrame.InsetR:SetFrameLevel(CharacterModelFrame:GetFrameLevel())
		CharacterModelFrame.InsetR:SetPoint("TOPLEFT",CharacterModelFrame,"TOPLEFT",-6,7);
		CharacterModelFrame.InsetR:SetPoint("BOTTOMRIGHT",CharacterModelFrame,"BOTTOMRIGHT",6,0);
		CharacterModelFrame:SetHeight(319);
		PaperDollFrame.InsetR:SetSize(CharacterFW[2]-384,365);
		PaperDollFrame.InsetR:SetPoint("TOPRIGHT",PaperDollFrame,"TOPRIGHT",-36,-68);
		PaperDollFrame.InsetR.TabList={}
		--创建TAB
		local function add_SidebarTab(id)
			local TabBut = CreateFrame("Button",nil,PaperDollFrame.InsetR);
			PaperDollFrame.InsetR.TabList[id]=TabBut
			TabBut:SetSize(28,28);
			if id==1 then
				TabBut:SetPoint("BOTTOMLEFT",PaperDollFrame.InsetR,"TOPLEFT",20,-2);
			else
				TabBut:SetPoint("LEFT",PaperDollFrame.InsetR.TabList[id-1],"RIGHT",10,0);
				TabBut:Hide()
			end
			TabBut.TabBg = TabBut:CreateTexture(nil, "BACKGROUND");
			TabBut.TabBg:SetTexture("Interface/PaperDollInfoFrame/PaperDollSidebarTabs");
			TabBut.TabBg:SetPoint("TOPLEFT", -12, 9);
			TabBut.TabBg:SetPoint("BOTTOMRIGHT", 8.6, -2);
			TabBut.TabBg:SetTexCoord(0.01562500,0.79687500,0.61328125,0.78125000)
			TabBut.Hider = TabBut:CreateTexture(nil, "OVERLAY");
			TabBut.Hider:SetTexture("Interface/PaperDollInfoFrame/PaperDollSidebarTabs");
			TabBut.Hider:SetSize(34,19);
			TabBut.Hider:SetPoint("BOTTOM", 0, 0);
			TabBut.Hider:SetTexCoord(0.01562500,0.54687500,0.11328125,0.18750000)
			TabBut.Icon = TabBut:CreateTexture(nil, "ARTWORK");
			TabBut.Icon:SetPoint("TOPLEFT", 2, -2);
			TabBut.Icon:SetPoint("BOTTOMRIGHT", -2, 1);
			if id==1 then
				TabBut.Icon:SetTexCoord(0.1, 0.9, 0.12, 0.92)
			elseif id==2 then
				TabBut.Icon:SetTexture("Interface/PaperDollInfoFrame/PaperDollSidebarTabs");
				TabBut.Icon:SetTexCoord(0.07562500, 0.50125000, 0.47875000, 0.60546875)
			end
			TabBut.Highlight = TabBut:CreateTexture(nil, "HIGHLIGHT");
			TabBut.Highlight:SetTexture("Interface/PaperDollInfoFrame/PaperDollSidebarTabs");
			TabBut.Highlight:SetPoint("TOPLEFT", 0, 0);
			TabBut.Highlight:SetPoint("BOTTOMRIGHT", 0, 0);
			TabBut.Highlight:SetTexCoord(0.01562500,0.50000000,0.19531250,0.31640625)
			TabBut:HookScript("OnClick", function(self)
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
				PaperDollFrame.InsetR:SetSidebarTab(id)
			end)
			TabBut.F = CreateFrame("Frame",nil,TabBut)
			TabBut.F:SetAllPoints(PaperDollFrame.InsetR)
			function TabBut:Show_UI() TabBut.F:Show() end
			function TabBut:Hide_UI() TabBut.F:Hide() end
		end
		for i=1,CharacterFW[3] do
			add_SidebarTab(i)
		end
		function PaperDollFrame.InsetR:SetSidebarTab(tabid)
			for ix=1,CharacterFW[3] do
				local tabx =self.TabList[ix]
				tabx.Hider:Show();
				tabx.Highlight:Show();
				tabx.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.61328125, 0.78125000);
				tabx.TabBg:SetDesaturated(true)
				tabx.Icon:SetDesaturated(true)
				tabx:Hide_UI()
			end
			self.TabList[tabid].Hider:Hide();
			self.TabList[tabid].Highlight:Hide();
			self.TabList[tabid].TabBg:SetTexCoord(0.01562500, 0.79687500, 0.78906250, 0.95703125);
			self.TabList[tabid].TabBg:SetDesaturated(false)
			self.TabList[tabid].Icon:SetDesaturated(false)
			self.TabList[tabid]:Show_UI()
		end
		--个人属性
		local shuxingF = PaperDollFrame.InsetR.TabList[1].F
		shuxingF.topJU=0
		local UIffWW,suofangV =shuxingF:GetWidth(),0.86
		local function add_biaoti(pane,Title,Point)
			local Point=Point or {"TOP", pane,"TOP",0, 0}
			if NDui or ElvUI then
				local biaoti = PIGFrame(pane,Point,{UIffWW-6,27})
				biaoti:PIGSetBackdrop(0.2,0.8)
				biaoti:SetPoint(unpack(Point));
				biaoti:SetScale(suofangV)
				biaoti.Title = PIGFontString(biaoti,{"CENTER", biaoti, "CENTER", 0, 0},Title)
				biaoti.Title:SetTextColor(1, 1, 1, 1)
				return biaoti
			else
				local biaoti = CreateFrame("Frame",nil,pane,"CharacterStatFrameCategoryTemplate")
				biaoti:SetPoint(unpack(Point));
				biaoti:SetScale(suofangV)
				biaoti.Title:SetText(Title)
				return biaoti
			end
		end
		local function add_Category_biaoti(pane,H,Title,Point)
			local CategoryF = PIGFrame(shuxingF.fuji,Point,{UIffWW,H})
			CategoryF.biaoti = add_biaoti(CategoryF,Title,Point)
			return CategoryF
		end
		local function add_Category_hang(pane,uiname,Label,tooltip,Point)
			local hang = CreateFrame("Frame",uiname,pane,"StatFrameTemplate")
			hang:SetWidth(UIffWW-40)
			hang:SetPoint(unpack(Point));
			hang.Label:SetText(Label)
			hang.tooltip = tooltip
			return hang
		end
		local function add_Category_hangBG(pane)
			pane.Background = pane:CreateTexture(nil, "BACKGROUND");
			pane.Background:SetAtlas("UI-Character-Info-ItemLevel-Bounce");
			pane.Background:SetAllPoints(pane)
			pane.Background:SetAlpha(0.3)
		end
		shuxingF.InsetRScroll = CreateFrame("ScrollFrame",nil,shuxingF, "UIPanelScrollFrameTemplate"); 
		shuxingF.InsetRScroll:SetPoint("TOPLEFT",shuxingF,"TOPLEFT",0,-4);
		shuxingF.InsetRScroll:SetSize(UIffWW-15,359);
		shuxingF.InsetRScroll.ScrollBar:SetScale(0.8)
		shuxingF.InsetRScroll.ScrollBar:SetPoint("TOPLEFT", shuxingF.InsetRScroll,"TOPRIGHT",0, -14);
		shuxingF.InsetRScroll.ScrollBar:SetPoint("BOTTOMLEFT", shuxingF.InsetRScroll,"BOTTOMRIGHT",0, 16);
		if NDui then
			shuxingF.topJU=4
			local B = unpack(NDui)
			B.ReskinScroll(shuxingF.InsetRScroll.ScrollBar)
		elseif ElvUI then
			shuxingF.topJU=4
			local E= unpack(ElvUI)
			local S = E:GetModule('Skins')
			S:HandleScrollBar(shuxingF.InsetRScroll.ScrollBar)
		end
		shuxingF.fuji = CreateFrame("Frame", nil, shuxingF)
		shuxingF.fuji:SetWidth(UIffWW-12)
		shuxingF.fuji:SetHeight(30) 
		shuxingF.InsetRScroll:SetScrollChild(shuxingF.fuji)
		shuxingF.fuji.ItemLevelCategory =add_biaoti(shuxingF.fuji,STAT_AVERAGE_ITEM_LEVEL,{"TOP", 0, -2})
		shuxingF.fuji.ItemLevelFrame = CreateFrame("Frame",nil,shuxingF.fuji)
		shuxingF.fuji.ItemLevelFrame:SetPoint("TOP", shuxingF.fuji.ItemLevelCategory,"BOTTOM",0, 4-shuxingF.topJU);
		shuxingF.fuji.ItemLevelFrame:SetSize(UIffWW-10, 28)
		add_Category_hangBG(shuxingF.fuji.ItemLevelFrame)
		shuxingF.fuji.ItemLevelFrame.Value=PIGFontString(shuxingF.fuji.ItemLevelFrame,{"CENTER",shuxingF.fuji.ItemLevelFrame,"CENTER",0,0},nil,nil,16)
		--属性
		shuxingF.fuji.AttributesCategory =add_biaoti(shuxingF.fuji,PLAYERSTAT_BASE_STATS,{"TOP", shuxingF.fuji.ItemLevelFrame,"BOTTOM",0, 0})
		CharacterAttributesFrame:SetParent(shuxingF.fuji)
		local regionsss = {CharacterAttributesFrame:GetRegions()}
		for _,v in pairs(regionsss) do
			v:Hide()
		end
		CharacterStatFrame1:ClearAllPoints();
		CharacterStatFrame1:SetPoint("TOP", shuxingF.fuji.AttributesCategory,"BOTTOM",0, 0);
		for ixc=1,5 do
			_G["CharacterStatFrame"..ixc]:SetWidth(UIffWW-40)
		end
		CharacterArmorFrame:SetWidth(UIffWW-40)
		CharacterArmorFrame.Label:SetText(STAT_ARMOR..":")
		add_Category_hangBG(CharacterStatFrame2)
		add_Category_hangBG(CharacterStatFrame4)
		add_Category_hangBG(CharacterArmorFrame)
		---近战
		shuxingF.fuji.CategoryF_1=add_Category_biaoti(shuxingF.fuji,86,PLAYERSTAT_MELEE_COMBAT)
		CharacterAttackFrame:ClearAllPoints();
		CharacterAttackFrame:SetPoint("TOP", shuxingF.fuji.CategoryF_1.biaoti,"BOTTOM",0, -shuxingF.topJU);
		CharacterAttackFrame:SetWidth(UIffWW-40)
		CharacterAttackFrame.Label:SetText(STAT_HIT_CHANCE..":")
		CharacterAttackPowerFrame:SetWidth(UIffWW-40)
		CharacterAttackPowerFrame:SetPoint("TOPLEFT", CharacterAttackFrame,"BOTTOMLEFT",0, 0);
		CharacterDamageFrame:SetWidth(UIffWW-40)
		add_Category_hang(shuxingF.fuji.CategoryF_1,"CharacterCategory1_1",CRIT_CHANCE..":",ITEM_MOD_CRIT_MELEE_RATING_SHORT,{"TOP", CharacterDamageFrame,"BOTTOM",0, 0})
		add_Category_hangBG(CharacterAttackPowerFrame)
		add_Category_hangBG(CharacterCategory1_1)
		--远程
		shuxingF.fuji.CategoryF_2=add_Category_biaoti(shuxingF.fuji,86,PLAYERSTAT_RANGED_COMBAT)
		CharacterRangedAttackFrame:ClearAllPoints();
		CharacterRangedAttackFrame:SetPoint("TOP", shuxingF.fuji.CategoryF_2.biaoti,"BOTTOM",0, -shuxingF.topJU);
		CharacterRangedAttackFrame:SetWidth(UIffWW-40)
		CharacterRangedAttackFrame.Label:SetText(STAT_HIT_CHANCE..":")
		CharacterRangedAttackPowerFrame:SetWidth(UIffWW-40)
		CharacterRangedAttackPowerFrame:SetPoint("TOPLEFT", CharacterRangedAttackFrame,"BOTTOMLEFT",0, 0);
		CharacterRangedDamageFrame:SetWidth(UIffWW-40)
		add_Category_hang(shuxingF.fuji.CategoryF_2,"CharacterCategory2_1",CRIT_CHANCE..":",ITEM_MOD_CRIT_RANGED_RATING_SHORT,{"TOP", CharacterRangedDamageFrame,"BOTTOM",0, 0})
		add_Category_hangBG(CharacterRangedAttackPowerFrame)
		add_Category_hangBG(CharacterCategory2_1)
		--法系
		shuxingF.fuji.CategoryF_3=add_Category_biaoti(shuxingF.fuji,100,PLAYERSTAT_SPELL_COMBAT)
		add_Category_hang(shuxingF.fuji.CategoryF_3,"CharacterCategory3_1",STAT_HIT_CHANCE..":",ITEM_MOD_HIT_SPELL_RATING_SHORT,{"TOP", shuxingF.fuji.CategoryF_3.biaoti,"BOTTOM",0, -shuxingF.topJU})
		add_Category_hang(shuxingF.fuji.CategoryF_3,"CharacterCategory3_2",CRIT_CHANCE..":",ITEM_MOD_CRIT_SPELL_RATING_SHORT,{"TOP", CharacterCategory3_1,"BOTTOM",0, 0})
		add_Category_hang(shuxingF.fuji.CategoryF_3,"CharacterCategory3_3",STAT_SPELLDAMAGE..":",STAT_SPELLDAMAGE_TOOLTIP,{"TOP", CharacterCategory3_2,"BOTTOM",0, 0})
		add_Category_hang(shuxingF.fuji.CategoryF_3,"CharacterCategory3_4",STAT_SPELLHEALING..":",STAT_SPELLHEALING_TOOLTIP,{"TOP", CharacterCategory3_3,"BOTTOM",0, 0})
		add_Category_hang(shuxingF.fuji.CategoryF_3,"CharacterCategory3_5",ITEM_MOD_MANA_REGENERATION_SHORT..":",ITEM_MOD_MANA_REGENERATION_SHORT,{"TOP", CharacterCategory3_4,"BOTTOM",0, 0})
		add_Category_hangBG(CharacterCategory3_2)
		add_Category_hangBG(CharacterCategory3_4)
		--防御
		shuxingF.fuji.CategoryF_4=add_Category_biaoti(shuxingF.fuji,90,PLAYERSTAT_DEFENSES)
		add_Category_hang(shuxingF.fuji.CategoryF_4,"CharacterCategory4_1",DODGE_CHANCE..":",DODGE_CHANCE,{"TOP", shuxingF.fuji.CategoryF_4.biaoti,"BOTTOM",0, -shuxingF.topJU})
		add_Category_hang(shuxingF.fuji.CategoryF_4,"CharacterCategory4_2",PARRY_CHANCE..":",PARRY_CHANCE,{"TOP", CharacterCategory4_1,"BOTTOM",0, 0})
		add_Category_hang(shuxingF.fuji.CategoryF_4,"CharacterCategory4_3",BLOCK_CHANCE..":",BLOCK_CHANCE,{"TOP", CharacterCategory4_2,"BOTTOM",0, 0})
		if GetLocale() == "zhCN" then
			shuxingF.fuji.CategoryF_4.tishineir="物伤减免"
		elseif GetLocale() == "zhTW" then
			shuxingF.fuji.CategoryF_4.tishineir="物傷減免"
		else
			shuxingF.fuji.CategoryF_4.tishineir="ArmorDerate"
		end
		local xuyaoxttx = shuxingF.fuji.CategoryF_4.tishineir
		add_Category_hang(shuxingF.fuji.CategoryF_4,"CharacterCategory4_4",xuyaoxttx..":",xuyaoxttx,{"TOP", CharacterCategory4_3,"BOTTOM",0, 0})
		add_Category_hang(shuxingF.fuji.CategoryF_4,"CharacterCategory4_5",DEFENSE..":",DEFENSE,{"TOP", CharacterCategory4_4,"BOTTOM",0, 0})
		add_Category_hangBG(CharacterCategory4_2)
		add_Category_hangBG(CharacterCategory4_4)
		-----------
		local function CharacterSetText(teui,text)
			_G[teui:GetName().."StatText"]:SetText(text);
		end
		local function Round(num)    
		    local mult = 10^(2);
		    return math.floor(num * mult + 0.5) / mult;
		end
		local function PIG_GetSpellCritChance()
			local holySchool = 2
		    local minCrit = GetSpellCritChance(holySchool);
			local spellTishi=RESISTANCE_TYPE1..CRIT_CHANCE..": "..Round(minCrit)
			for i=(holySchool+1), 7 do
				local spellCrit = GetSpellCritChance(i);
				spellTishi=spellTishi.."\n".._G["RESISTANCE_TYPE"..(i-1)]..CRIT_CHANCE..": "..Round(spellCrit)
				minCrit = max(minCrit, spellCrit);
			end
			return minCrit,spellTishi
		end
		local function PIG_GetSpellBonusDamage()
			local holySchool = 2
		    local minCrit = GetSpellBonusDamage(holySchool);
			local spellTishi=RESISTANCE_TYPE1..STAT_SPELLDAMAGE..": "..Round(minCrit)
			for i=(holySchool+1), 7 do
				local spellCrit = GetSpellBonusDamage(i);
				spellTishi=spellTishi.."\n".._G["RESISTANCE_TYPE"..(i-1)]..STAT_SPELLDAMAGE..": "..Round(spellCrit)
				minCrit = max(minCrit, spellCrit);
			end
			return minCrit,spellTishi
		end
		local function PaperDollFrameUP()
			if shuxingF:IsVisible() then
				local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = GetAverageItemLevel();
				shuxingF.fuji.ItemLevelFrame.Value:SetText(string.format("%.2f",avgItemLevelEquipped).." / "..string.format("%.2f",avgItemLevel))
				local HitModifierV=GetHitModifier()
				CharacterSetText(CharacterAttackFrame,HitModifierV.."%")
				CharacterAttackFrame.tooltip2=format(CR_HIT_MELEE_TOOLTIP, UnitLevel("player"),HitModifierV);
				CharacterSetText(CharacterCategory1_1,Round(GetCritChance()).."%")
				CharacterCategory1_1.tooltip2=format(CHANCE_TO_CRIT, GetCritChance());
				---
				CharacterSetText(CharacterRangedAttackFrame,Round(HitModifierV).."%")
				CharacterRangedAttackFrame.tooltip2=format(CR_HIT_RANGED_TOOLTIP, UnitLevel("player"),HitModifierV);
				local RangedCritChanceV=GetRangedCritChance()
				CharacterSetText(CharacterCategory2_1,Round(RangedCritChanceV).."%")
				CharacterCategory2_1.tooltip2=format(CHANCE_TO_CRIT, RangedCritChanceV);
				--
				local SpellHitModifierV=GetSpellHitModifier() or 0.0001
				if PIG_MaxTocversion(20000,true) then
					SpellHitModifierV=GetSpellHitModifier()/7
				end
				CharacterSetText(CharacterCategory3_1,Round(SpellHitModifierV).."%")
				CharacterCategory3_1.tooltip2=format(CR_HIT_SPELL_TOOLTIP, UnitLevel("player"),SpellHitModifierV);
				local CritChanceV,CritChancetooltip = PIG_GetSpellCritChance()
				CharacterSetText(CharacterCategory3_2,Round(CritChanceV).."%")
				CharacterCategory3_2.tooltip2=CritChancetooltip
				local BonusDamageV,BonusDamagetooltip = PIG_GetSpellBonusDamage()
				CharacterSetText(CharacterCategory3_3,Round(BonusDamageV))
				CharacterCategory3_3.tooltip2=BonusDamagetooltip
				local SpellBonusHealingV=GetSpellBonusHealing()
				CharacterSetText(CharacterCategory3_4,Round(SpellBonusHealingV))
				CharacterCategory3_4.tooltip2=STAT_SPELLHEALING..": "..Round(SpellBonusHealingV)
				
				local powerType, powerToken = UnitPowerType("player");
				if (powerToken == "ENERGY") then
					local basePowerRegen, castingPowerRegen = GetPowerRegen()
					CharacterCategory3_5.Label:SetText(STAT_ENERGY_REGEN..":")
					CharacterSetText(CharacterCategory3_5,Round(basePowerRegen*2).."/2s")

					CharacterCategory3_5.tooltip = STAT_ENERGY_REGEN
					CharacterCategory3_5.tooltip2 = STAT_ENERGY_REGEN..Round(basePowerRegen*2).."/2s";
				else
					local base, casting = GetManaRegen()--精神2秒回蓝
					CharacterCategory3_5.Label:SetText(ITEM_MOD_MANA_REGENERATION_SHORT..":")
					CharacterSetText(CharacterCategory3_5,Round(base*2).."/2s")
					CharacterCategory3_5.tooltip2=ITEM_MOD_MANA_REGENERATION_SHORT..Round(casting*2).."/2s\n"..BINDING_NAME_STOPCASTING.."5s"..ITEM_MOD_MANA_REGENERATION_SHORT..Round(base*2).."/2s"
				end
				--
				local DodgeChanceV = GetDodgeChance()
				CharacterSetText(CharacterCategory4_1,Round(DodgeChanceV).."%")
				CharacterCategory4_1.tooltip2=DODGE_CHANCE..": "..Round(DodgeChanceV).."%"
				local ParryChanceV = GetParryChance()
				CharacterSetText(CharacterCategory4_2,Round(ParryChanceV).."%")
				CharacterCategory4_2.tooltip2=PARRY_CHANCE..": "..Round(ParryChanceV).."%"
				local BlockChanceV = GetBlockChance()
				CharacterSetText(CharacterCategory4_3,Round(BlockChanceV).."%")
				CharacterCategory4_3.tooltip2=BLOCK_CHANCE..": "..Round(BlockChanceV).."%"
				local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
				local playerLevel = UnitLevel("player");
				local armorReduction = effectiveArmor/((85 * playerLevel) + 400);
				local armorReduction = 100 * (armorReduction/(armorReduction + 1));
				local tooltip2txt=format(ARMOR_TOOLTIP, playerLevel, armorReduction)
				CharacterSetText(CharacterCategory4_4,Round(armorReduction).."%")
				local playerLevel = UnitLevel("player")+3;
				local armorReduction = effectiveArmor/((85 * playerLevel) + 400);
				local armorReduction = 100 * (armorReduction/(armorReduction + 1));
				local tooltip2txt=tooltip2txt.."\n"..format(ARMOR_TOOLTIP, playerLevel, armorReduction);
				CharacterCategory4_4.tooltip2=tooltip2txt
				-- local  baseDefense, armorDefense = UnitDefense("player");
				-- print(UnitDefense("player"))
				for skillIndex = 1, GetNumSkillLines() do
					local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier,skillMaxRank, 
					isAbandonable, stepCost, rankCost, minLevel, skillCostType,skillDescription = GetSkillLineInfo(skillIndex)
					if not isHeader and skillName==DEFENSE then
						CharacterSetText(CharacterCategory4_5,(skillRank+skillModifier).."/"..(skillMaxRank+skillModifier))
						CharacterCategory4_5.tooltip2=skillDescription
						break
					end
				end
			end
		end;
		local function shunxu_paixie(xuhao)
			shuxingF.fuji.CategoryF_1:ClearAllPoints();
			shuxingF.fuji.CategoryF_2:ClearAllPoints();
			shuxingF.fuji.CategoryF_3:ClearAllPoints();
			shuxingF.fuji.CategoryF_4:ClearAllPoints();
			if xuhao==1 then
				shuxingF.fuji.CategoryF_1:SetPoint("TOP", CharacterArmorFrame,"BOTTOM",0, -shuxingF.topJU)
				shuxingF.fuji.CategoryF_2:SetPoint("TOP", shuxingF.fuji.CategoryF_1,"BOTTOM",0, 0)
				shuxingF.fuji.CategoryF_3:SetPoint("TOP", shuxingF.fuji.CategoryF_2,"BOTTOM",0, 0)
				shuxingF.fuji.CategoryF_4:SetPoint("TOP", shuxingF.fuji.CategoryF_3,"BOTTOM",0, 0)
			elseif xuhao==2 then
				shuxingF.fuji.CategoryF_2:SetPoint("TOP", CharacterArmorFrame,"BOTTOM",0, -shuxingF.topJU)
				shuxingF.fuji.CategoryF_1:SetPoint("TOP", shuxingF.fuji.CategoryF_2,"BOTTOM",0, 0)
				shuxingF.fuji.CategoryF_3:SetPoint("TOP", shuxingF.fuji.CategoryF_1,"BOTTOM",0, 0)
				shuxingF.fuji.CategoryF_4:SetPoint("TOP", shuxingF.fuji.CategoryF_3,"BOTTOM",0, 0)
			elseif xuhao==3 then
				shuxingF.fuji.CategoryF_3:SetPoint("TOP", CharacterArmorFrame,"BOTTOM",0, -shuxingF.topJU)
				shuxingF.fuji.CategoryF_1:SetPoint("TOP", shuxingF.fuji.CategoryF_3,"BOTTOM",0, 0)
				shuxingF.fuji.CategoryF_2:SetPoint("TOP", shuxingF.fuji.CategoryF_1,"BOTTOM",0, 0)
				shuxingF.fuji.CategoryF_4:SetPoint("TOP", shuxingF.fuji.CategoryF_2,"BOTTOM",0, 0)
			end
		end
		local _, classId = UnitClassBase("player");--1战士/2圣骑士/3猎人/4盗贼/5牧师/6死亡骑士/7萨满祭司/8法师/9术士/10武僧/11德鲁伊/12恶魔猎手
		local function Update_Point_P()
			if classId == 3 then
				shunxu_paixie(2)
			elseif classId ==5 or classId ==7 or classId ==8 or classId ==9 then
				shunxu_paixie(3)	
			else
				shunxu_paixie(1)
			end
		end
		PaperDollFrame:HookScript("OnShow", function()
			if CharacterFrame.backdrop then CharacterFrame.backdrop:SetPoint("BOTTOMRIGHT", PaperDollFrame.pigBGF,"BOTTOMRIGHT", 0, 0);end
			CharacterFrameCloseButton:SetPoint("CENTER",CharacterFrame,"TOPRIGHT",142,-25)
			PaperDollFrame.InsetR:SetSidebarTab(1)
			SetPortraitTexture(PaperDollFrame.InsetR.TabList[1].Icon, "player");
			Update_Point_P()
			PaperDollFrameUP()
		end)
		PaperDollFrame:HookScript("OnHide", function()
			if CharacterFrame.backdrop then CharacterFrame.backdrop:SetPoint("BOTTOMRIGHT", CharacterFrame,"BOTTOMRIGHT", -32, 76);end
			CharacterFrameCloseButton:SetPoint("CENTER",CharacterFrame,"TOPRIGHT",-44,-25)
		end)
		PaperDollFrame:RegisterEvent("UNIT_AURA");--获得BUFF时
		PaperDollFrame:RegisterEvent("UNIT_DISPLAYPOWER");--当单位的魔法类型改变时触发，例如德鲁伊变形
		PaperDollFrame:RegisterEvent("CHARACTER_POINTS_CHANGED");--分配天赋点触发
		PaperDollFrame:RegisterEvent("LEARNED_SPELL_IN_TAB");--学习新法术触发
		PaperDollFrame:HookScript("OnEvent", function(self,event,arg1)
			PaperDollFrameUP()
		end);
		--2装备管理
		add_AutoEquip(PaperDollFrame.InsetR.TabList[2])
		--3探索符文
		if C_Engraving and C_Engraving.IsEngravingEnabled() then
			hooksecurefunc("ToggleEngravingFrame", function()
				EngravingFrame:Hide()
				RuneFrameControlButton:Hide()
			end)
			PaperDollFrame:HookScript("OnShow", function()
				PaperDollFrame_OnHide()
			end)
			local function add_fuwenUICZ()
				local SidebarTab = PaperDollFrame.InsetR.TabList[3]
				SidebarTab:Show()
				SidebarTab.Icon:SetTexture(134419)
				SidebarTab.Icon:SetTexCoord(0.06,0.94,0.07,0.94)
				SidebarTab:HookScript("OnClick", function(self)
					EngravingFrame:Show();
				end)
				SidebarTab.Scroll = CreateFrame("ScrollFrame",nil,SidebarTab, "UIPanelScrollFrameTemplate"); 
				SidebarTab.Scroll.ScrollBar:SetScale(0.8)
				SidebarTab.Scroll:SetPoint("TOPLEFT",PaperDollFrame.InsetR,"TOPLEFT",0,-2);
				SidebarTab.Scroll:SetPoint("BOTTOMRIGHT",PaperDollFrame.InsetR,"BOTTOMRIGHT",-18,2);
				SidebarTab.F:SetWidth(SidebarTab.Scroll:GetWidth()+8)
				SidebarTab.F:SetHeight(10) 
				SidebarTab.Scroll:SetScrollChild(SidebarTab.F)
				SidebarTab.F.numallT = PIGFontString(SidebarTab.F,{"TOP",SidebarTab.F,"TOP", -20, -3},RUNES..COLLECTED)
				SidebarTab.F.numall = PIGFontString(SidebarTab.F,{"LEFT",SidebarTab.F.numallT,"RIGHT", 1, 0})
				local FFWW,fWhangH,buweifuwenNum = SidebarTab.F:GetWidth()-8,48,10
				SidebarTab.F.fuwenSlotS = {}
				SidebarTab.F.ButList={}
				for Slot=1,19 do
					if EngravingSlot[Slot] then
						local fuwenF = PIGFrame(SidebarTab.F,{"TOP",SidebarTab.F,"TOP",0,-fWhangH*(#SidebarTab.F.fuwenSlotS)-19},{FFWW,fWhangH})
						SidebarTab.F.ButList[Slot]={}
						table.insert(SidebarTab.F.fuwenSlotS,{fuwenF,Slot})
						fuwenF:PIGSetBackdrop(0,0.6,nil,{0.2, 0.2, 0.2})
						fuwenF.biaoti = PIGFontString(fuwenF,{"TOPLEFT", fuwenF, "TOPLEFT", 1, -10},InvSlot.Name[Slot][2])
						fuwenF.num= PIGFontString(fuwenF,{"TOPLEFT", fuwenF.biaoti, "BOTTOMLEFT", 2, 0})
						for ir=1,buweifuwenNum do
							local RuneBut = CreateFrame("Button",nil,fuwenF);
							SidebarTab.F.ButList[Slot][ir]=RuneBut
							RuneBut:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
							RuneBut:SetSize(fWhangH*0.5-2,fWhangH*0.5-2);
							RuneBut.xuanzhong = RuneBut:CreateTexture(nil, "OVERLAY");
							RuneBut.xuanzhong:SetTexture(130724);
							RuneBut.xuanzhong:SetBlendMode("ADD");
							RuneBut.xuanzhong:SetAllPoints(RuneBut)
							RuneBut.xuanzhong:Hide()
							if ir==1 then
								RuneBut:SetPoint("TOPLEFT",fuwenF,"TOPLEFT",34,-2);
							elseif ir==6 then
								RuneBut:SetPoint("TOPLEFT",SidebarTab.F.ButList[Slot][ir-5],"BOTTOMLEFT",0,-1);
							else
								RuneBut:SetPoint("LEFT",SidebarTab.F.ButList[Slot][ir-1],"RIGHT",5,0);
							end
							RuneBut:HookScript("OnLeave", function()
								GameTooltip:ClearLines();
								GameTooltip:Hide() 
							end);
							RuneBut:SetScript("OnEnter", function (self)
								GameTooltip:ClearLines();
								GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
								GameTooltip:SetEngravingRune(self.skillLineAbilityID);
								GameTooltip:Show();
							end);
							RuneBut:HookScript("OnClick", function(self)
								EngravingFrameSpell_OnClick(self)
								UseInventoryItem(Slot)
							end);
						end
					end				
				end
				local function SetnumTextColor(TextUI,known,max)
					if known==max then
						TextUI:SetTextColor(0, 1, 0, 1)
					elseif known==0 then
						TextUI:SetTextColor(1, 0, 0, 1)
					else
						TextUI:SetTextColor(1, 1, 0, 1)
					end
				end
				local function Engraving_UpdateRuneList()
					for Slot=1,19 do
						if EngravingSlot[Slot] then
							for ir=1,buweifuwenNum do
								local RuneBut = SidebarTab.F.ButList[Slot][ir]
								RuneBut:Hide()
								RuneBut.xuanzhong:Hide()
							end
						end
					end
					C_Engraving.ClearExclusiveCategoryFilter();
					C_Engraving.EnableEquippedFilter(false);
					local known, max = C_Engraving.GetNumRunesKnown();
					SidebarTab.F.numall:SetText(known.."/"..max);
					SetnumTextColor(SidebarTab.F.numall,known,max)
					for i=1,#SidebarTab.F.fuwenSlotS do
						local infosole = SidebarTab.F.fuwenSlotS[i][2]
						if infosole==12 then
							infosole = 11
						end
						local known, max = C_Engraving.GetNumRunesKnown(infosole);
						SidebarTab.F.fuwenSlotS[i][1].num:SetText(known.."/"..max);
						SetnumTextColor(SidebarTab.F.fuwenSlotS[i][1].num,known,max)
					end
					local categories = C_Engraving.GetRuneCategories(true, true);
					for _, category in ipairs(categories) do
						local BUTxuhao = 1
						local runes = C_Engraving.GetRunesForCategory(category, true);
						for _, rune in ipairs(runes) do
							local RuneBut = SidebarTab.F.ButList[rune.equipmentSlot][BUTxuhao]
							BUTxuhao=BUTxuhao+1
							RuneBut:Show()
							RuneBut:SetAlpha(0.6)
							RuneBut.skillLineAbilityID=rune.skillLineAbilityID
							RuneBut:SetNormalTexture(rune.iconTexture);
							local engravingInfo = C_Engraving.GetRuneForEquipmentSlot(category);
							if engravingInfo then
								if engravingInfo.skillLineAbilityID==RuneBut.skillLineAbilityID then
									RuneBut.xuanzhong:Show()
									RuneBut:SetAlpha(1)
								end
							end
						end
					end
				end
				EngravingFrame:HookScript("OnShow", function(self,event)
					self:SetAlpha(0.00001)
					self:SetPoint("TOPLEFT",CharacterFrame,"TOPRIGHT",-234,-70);
					Engraving_UpdateRuneList()
				end)
				EngravingFrame:RegisterEvent("RUNE_UPDATED");
				EngravingFrame:RegisterEvent("REPLACE_ENCHANT");
				EngravingFrame:HookScript("OnEvent", function(self,event)
					if self:IsVisible() then
						if event=="REPLACE_ENCHANT" then
							StaticPopup_OnClick(StaticPopup1, 1) 
							StaticPopup1:Hide()
						else
							Engraving_UpdateRuneList()
						end
					end
				end)
			end
			if IsAddOnLoaded("Blizzard_EngravingUI") then
				add_fuwenUICZ()
			else	
				local fujianjiazai = CreateFrame("FRAME")
				fujianjiazai:RegisterEvent("ADDON_LOADED")
				fujianjiazai:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_EngravingUI" then
						self:UnregisterEvent("ADDON_LOADED")
						add_fuwenUICZ()
					end
				end)
			end
		end
		HideUIPanel(CharacterFrame);
	elseif PIG_MaxTocversion(40000) then
		if NDui then return end
		local kaiqiq=GetCVar("equipmentManager")
		if kaiqiq=="0" then
			SetCVar("equipmentManager","1")
			PIG_OptionsUI:ErrorMsg("已打开装备管理功能")
		end
		local function Update_SizePoint()
			GearManagerDialog:SetSize(200, 430)
			GearManagerDialogEquipSet:SetWidth(60)
			GearManagerDialogEquipSet:ClearAllPoints();
			GearManagerDialogEquipSet:SetPoint("TOPLEFT", GearManagerDialog, "TOPLEFT", 10, -30);
			GearManagerDialogSaveSet:SetWidth(50)
			GearManagerDialogSaveSet:ClearAllPoints();
			GearManagerDialogSaveSet:SetPoint("LEFT", GearManagerDialogEquipSet, "RIGHT", 8, 0);
			GearManagerDialogDeleteSet:SetWidth(50)
			GearManagerDialogDeleteSet:ClearAllPoints();
			GearManagerDialogDeleteSet:SetPoint("LEFT", GearManagerDialogSaveSet, "RIGHT", 8, 0);
			GearManagerDialogPopup:ClearAllPoints();
			GearManagerDialogPopup:SetPoint("TOPLEFT", GearManagerDialog, "TOPRIGHT", 0, 0);
		end
		hooksecurefunc("GearManagagerDialogPopup_AdjustAnchors", function()
			GearManagerDialogPopup:ClearAllPoints();
			GearManagerDialogPopup:SetPoint("TOPLEFT", GearManagerDialog, "TOPRIGHT", -8, 0);
		end)
		GearManagerDialog:HookScript("OnShow", function()
			Update_SizePoint()
		end)
		for i = 1, MAX_EQUIPMENT_SETS_PER_PLAYER do
			local button = _G["GearSetButton" .. i]
			button:SetSize(30, 30)
			if ( i == 1 ) then
				button:SetPoint("TOPLEFT", GearManagerDialog, "TOPLEFT", 16, -62);
			else
				button:SetPoint("TOPLEFT", _G["GearSetButton"..(i-1)], "BOTTOMLEFT", 0, -6);
			end
			button.text:ClearAllPoints();
			button.text:SetPoint("LEFT", button, "RIGHT", 4, 0);
			button.text:SetWidth(140)
			button.text:SetJustifyH("LEFT")
			button.icon:SetSize(30, 30)
			local regions = {button:GetRegions()}
			for _,vv in pairs(regions) do
				if not vv:GetName() then
					vv:SetSize(36, 36)
				end
			end
		end
	elseif PIG_MaxTocversion() then
		PaperDollFrame:HookScript("OnShow", function()
			CharacterFrame:Expand()
		end)
	end
	Character_Mingzhong()
	Character_xiuliG()
end
function FramePlusfun.UpdatePoint(fuji)
	if not fuji then return end
	if fuji.ZBLsit then
		FramePlusfun.C_PointData={-1,0,fuji}
		if PIG_MaxTocversion(50000) then
			if ElvUI then
				FramePlusfun.C_PointData[1],FramePlusfun.C_PointData[2]=-33,-12
			elseif NDui then
				if NDuiStatPanel and NDuiStatPanel:IsShown() then
					FramePlusfun.C_PointData[3]=NDuiStatPanel
					FramePlusfun.C_PointData[1],FramePlusfun.C_PointData[2]=2,1
				else
					FramePlusfun.C_PointData[1],FramePlusfun.C_PointData[2]=-36,-15
				end
			else
				FramePlusfun.C_PointData[1],FramePlusfun.C_PointData[2]=-34,-12.6
			end

		end
		if fuji:GetName()==Data.LongInspectUIUIname  then
			FramePlusfun.C_PointData[1],FramePlusfun.C_PointData[2]=-34,-12.6
		end
		fuji.ZBLsit:SetPoint("TOPLEFT", FramePlusfun.C_PointData[3], "TOPRIGHT",FramePlusfun.C_PointData[1],FramePlusfun.C_PointData[2])
	end
end
