local addonName, addonTable = ...;
local L=addonTable.locale
--------
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGQuickBut=Create.PIGQuickBut
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGFontString=Create.PIGFontString
--==============================
local Data=addonTable.Data
local bagID=Data.bagData["bagID"]
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID = C_Container.GetContainerItemID
local UseContainerItem=C_Container.UseContainerItem
local PickupContainerItem =C_Container.PickupContainerItem
local GetContainerItemCooldown=C_Container.GetContainerItemCooldown
local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
local GetItemSpell=GetItemSpell or C_Item and C_Item.GetItemSpell
-----
local QuickButUIname=Data.QuickButUIname
local QuickButUI=_G[QuickButUIname]
local UIname= "PIG_QuickTrinketUI"
Data.QuickTrinketUIname=UIname
--
local function QuickButSet_OnEnter(TrinketUI,ShowUI)
	TrinketUI:HookScript("OnEnter", function(self)
		ShowUI:Show()
	end)
end
local function QuickButSet_OnLeave(TrinketUI,ShowUI)
	TrinketUI:HookScript("OnLeave", function()
		ShowUI:Hide()
	end)
end
local function add_Button(fujiUI,butW,slotID,ShowUI)
	fujiUI.Inventoryslot=slotID
	fujiUI.Cooldown = CreateFrame("Frame", nil, fujiUI);
	fujiUI.Cooldown:SetAllPoints()
	fujiUI.Cooldown.N = CreateFrame("Cooldown", nil, fujiUI.Cooldown, "CooldownFrameTemplate")
	fujiUI.Cooldown.N:SetAllPoints()

	fujiUI.START = fujiUI:CreateTexture(nil, "OVERLAY");
	fujiUI.START:SetTexture(130724);
	fujiUI.START:SetBlendMode("ADD");
	fujiUI.START:SetAllPoints(fujiUI)
	fujiUI.START:Hide();
	fujiUI.NextBut = fujiUI:CreateTexture(nil, "OVERLAY");
	fujiUI.NextBut:Hide();
	fujiUI.NextBut:SetPoint("TOPLEFT", 0, 0);
	fujiUI.NextBut:SetSize(butW*0.5, butW*0.5)
	fujiUI:HookScript("OnClick", function(self,button)
		if button=="RightButton" then
			self.NextList=nil
			self:NextListFun()
		end
	end)
	fujiUI:SetScript("OnEnter", function(self)
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(ShowUI, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT",ShowUI,"BOTTOMRIGHT",0,0);
		GameTooltip:SetInventoryItem("player",slotID)
		GameTooltip:Show();
	end)
	fujiUI:SetScript("OnLeave", function()
		GameTooltip:ClearLines();
		GameTooltip:Hide()
	end)
	QuickButSet_OnEnter(fujiUI,ShowUI)
	QuickButSet_OnLeave(fujiUI,ShowUI)
	function fujiUI:NextListFun()
		self.NextBut:Hide()
		if self.NextList then
			self.NextBut:Show()
			self.NextBut:SetTexture(self.NextList[3]);
		end
	end
	function fujiUI:SetanniuIcon()
		local Icon = GetInventoryItemTexture('player', slotID) or 136528
		self:SetNormalTexture(Icon)
	end
end
QuickButUI.ButList[3]=function()
	if not PIGA["QuickBut"]["Open"] or not PIGA["QuickBut"]["Trinket"] then return end
	if QuickButUI.TrinketOpen then return end
	QuickButUI.TrinketOpen=true
	-------
	local GnUI = "PIG_QkBut_AutoTrinket"
	_G[QuickButUI.TrinketAutoMode].GET_shipinxuanzhongL()
	local Icon,anniushu=136528,20
	local AutoTrinket=PIGQuickBut(GnUI,TRINKET0SLOT_UNIQUE,Icon,nil,nil,"SecureActionButtonTemplate")--UseInventoryItem(13)
	local butW = AutoTrinket:GetHeight()
	local AutoTrinket1=PIGQuickBut(GnUI.."1",TRINKET1SLOT_UNIQUE,Icon,nil,nil,"SecureActionButtonTemplate")
	local AutoTrinketList = PIGFrame(AutoTrinket)
	AutoTrinketList:PIGSetBackdrop(1)
	addonTable.Fun.ActionFun.PIGUseKeyDown(AutoTrinket)
	addonTable.Fun.ActionFun.PIGUseKeyDown(AutoTrinket1)
	AutoTrinket:SetAttribute("type1", "macro");
	AutoTrinket:SetAttribute("macrotext", [=[/use 13]=]);
	AutoTrinket1:SetAttribute("type1", "macro");
	AutoTrinket1:SetAttribute("macrotext", [=[/use 14]=]);
	QuickButSet_OnEnter(AutoTrinketList,AutoTrinketList)
	QuickButSet_OnLeave(AutoTrinketList,AutoTrinketList)

	add_Button(AutoTrinket,butW,13,AutoTrinketList)
	add_Button(AutoTrinket1,butW,14,AutoTrinketList)
	AutoTrinketList.ButList={}
	for i=1,anniushu do
		local hangBut = CreateFrame("Button", nil, AutoTrinketList,nil,i)
		AutoTrinketList.ButList[i]=hangBut
		hangBut:SetHighlightTexture(130718);
		hangBut:SetSize(butW, butW)
		hangBut.Cooldown = CreateFrame("Frame", nil, hangBut);
		hangBut.Cooldown:SetAllPoints()
		hangBut.Cooldown.N = CreateFrame("Cooldown", nil, hangBut.Cooldown, "CooldownFrameTemplate")
		hangBut.Cooldown.N:SetAllPoints()
		hangBut:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		hangBut:SetScript("OnEnter", function(self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(AutoTrinketList, "ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT",AutoTrinketList,"BOTTOMRIGHT",0,0);
			GameTooltip:SetBagItem(self.bagID, self.slot)
			GameTooltip:Show();
			if GameTooltip_HideShoppingTooltips then
				GameTooltip_HideShoppingTooltips(GameTooltip);
			else
				local tooltip, anchorFrame, shoppingTooltip1, shoppingTooltip2 = GameTooltip_InitializeComparisonTooltips(GameTooltip);
				shoppingTooltip1:Hide()
				shoppingTooltip2:Hide()
			end
		end)
		hangBut:SetScript("OnLeave", function()
			GameTooltip:ClearLines();
			GameTooltip:Hide()
		end)
		QuickButSet_OnEnter(hangBut,AutoTrinketList)
		QuickButSet_OnLeave(hangBut,AutoTrinketList)
		hangBut:HookScript("OnClick", function(self,button)
			if button=="LeftButton" then
				if InCombatLockdown() then
					AutoTrinket.NextList={self.bagID,self.slot,self.itemicon}
					AutoTrinket:NextListFun()
				else
					PickupContainerItem(self.bagID,self.slot)
					PickupInventoryItem(AutoTrinket.Inventoryslot)
				end
			else
				if InCombatLockdown() then
					AutoTrinket1.NextList={self.bagID,self.slot,self.itemicon}
					AutoTrinket1:NextListFun()
				else
					PickupContainerItem(self.bagID,self.slot)
					PickupInventoryItem(AutoTrinket1.Inventoryslot)
				end
			end
			AutoTrinketList:Hide()
		end);
	end
	_G["BINDING_NAME_CLICK PIG_QkBut_AutoTrinket:LeftButton"]= "PIG"..L["ACTION_TABNAME2"]..TRINKET0SLOT_UNIQUE
	_G["BINDING_NAME_CLICK PIG_QkBut_AutoTrinket1:LeftButton"]= "PIG"..L["ACTION_TABNAME2"]..TRINKET1SLOT_UNIQUE
	--已在队列
	local function IsDuilieFun(bag,slot)
		if AutoTrinket.NextList then
			if AutoTrinket.NextList[1]==bag and AutoTrinket.NextList[2]==slot then
				return true
			end
		end
		if AutoTrinket1.NextList then
			if AutoTrinket1.NextList[1]==bag and AutoTrinket1.NextList[2]==slot then
				return true
			end
		end
		return false
	end
	AutoTrinket:SetanniuIcon()
	AutoTrinket1:SetanniuIcon()
	local function Update_Cooldown()
		local start, duration, enable = GetInventoryItemCooldown("player", 13)
		CooldownFrame_Set(AutoTrinket.Cooldown.N, start, duration, enable);
		local start, duration, enable = GetInventoryItemCooldown("player", 14)
 		CooldownFrame_Set(AutoTrinket1.Cooldown.N, start, duration, enable);
	end
 	local function tiqukeyihuanbagslot(xiajiID,InventoryID)
		for bag=1,#bagID do
			for slot = 1, C_Container.GetContainerNumSlots(bagID[bag]) do
				local ItemID = C_Container.GetContainerItemID(bagID[bag], slot);
				if ItemID then
					--local itemID, itemType, itemSubType, itemEquipLoc= GetItemInfoInstant(ItemID)
					--if itemEquipLoc=="INVTYPE_TRINKET" then
						if xiajiID==ItemID then
							PickupContainerItem(bagID[bag], slot)
							PickupInventoryItem(InventoryID)
							return
						end
					--end
				end
			end
		end
	end
	local function zhixingqiehuanFun_1(InventoryID,NewTrinketL)					
		local Invstart, Invduration, Invenable = GetInventoryItemCooldown("player", InventoryID)
		--start - 冷却时间的开始时间，如果没有冷却时间（或槽中没有物品），则为 0
		--duration - 冷却时间的持续时间（不是剩余时间）。如果物品没有使用/冷却时间或插槽为空，则为 0。
		--enable- 返回 1 或 0。如果库存物品能够有冷却时间，则为 1，如果不能，则为 0。
 		if Invenable==0 or Invenable==1 and Invduration>30 then
			for i=1,#NewTrinketL do
				local _, spellID = GetItemSpell(NewTrinketL[i])
				if spellID then
					local start, duration, enable = C_Container.GetItemCooldown(NewTrinketL[i])
					if Invenable==0 then
						if start+duration-GetTime()<32 then
							tiqukeyihuanbagslot(NewTrinketL[i],InventoryID)
							return
						end
					else
						if duration==0 then
							tiqukeyihuanbagslot(NewTrinketL[i],InventoryID)
							return
						end
					end
				else
					tiqukeyihuanbagslot(NewTrinketL[i],InventoryID)
					return
				end
			end
		end
	end
	local function zhixingqiehuanFun()
		local NewTrinketL = {}
		local id_13 = GetInventoryItemID("player", 13)
		local id_14 = GetInventoryItemID("player", 14)
		for i=1,#_G[QuickButUI.TrinketAutoMode].NextList do
			if _G[QuickButUI.TrinketAutoMode].NextList[i]~=id_13 and _G[QuickButUI.TrinketAutoMode].NextList[i]~=id_14 then
				table.insert(NewTrinketL,_G[QuickButUI.TrinketAutoMode].NextList[i])
			end
		end
		zhixingqiehuanFun_1(13,NewTrinketL)
		zhixingqiehuanFun_1(14,NewTrinketL)
	end
	AutoTrinketList:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");--更换装备
	AutoTrinketList:RegisterEvent("PLAYER_REGEN_ENABLED");
	AutoTrinketList:RegisterEvent("PLAYER_ENTERING_WORLD");
	AutoTrinketList:RegisterUnitEvent("UNIT_SPELLCAST_START","player");
	AutoTrinketList:RegisterUnitEvent("UNIT_SPELLCAST_STOP","player");
	AutoTrinketList:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	AutoTrinketList:HookScript("OnEvent", function(self,event,arg1,_,arg3)
		if event=="PLAYER_ENTERING_WORLD" or event=="PLAYER_EQUIPMENT_CHANGED" then
			AutoTrinket:SetanniuIcon()
			AutoTrinket1:SetanniuIcon()
			Update_Cooldown()
		elseif event=="PLAYER_REGEN_ENABLED" then
			if not InCombatLockdown() then
				if _G[QuickButUI.TrinketAutoMode].TrinketMode==1 then
					if AutoTrinket.NextList then
						PickupContainerItem(AutoTrinket.NextList[1],AutoTrinket.NextList[2])
						PickupInventoryItem(13)
						AutoTrinket.NextList=nil
						AutoTrinket:NextListFun()
					end
					if AutoTrinket1.NextList then
						PickupContainerItem(AutoTrinket1.NextList[1],AutoTrinket1.NextList[2])
						PickupInventoryItem(14)
						AutoTrinket1.NextList=nil
						AutoTrinket1:NextListFun()
					end
				elseif _G[QuickButUI.TrinketAutoMode].TrinketMode==2 then
					zhixingqiehuanFun()
				end
			end
		elseif event=="SPELL_UPDATE_COOLDOWN" then
			C_Timer.After(0.01, Update_Cooldown);
		end
	end);
	if PIGA["QuickBut"]["TrinketFenli"] then
		local ActionW = QuickButUI:GetHeight()
		Data.UILayout[UIname]={"BOTTOM","BOTTOM",-200,200}
		local QuickTrinket=PIGFrame(UIParent,nil,nil,UIname)
		Create.PIG_SetPoint(UIname)
		QuickTrinket:SetScale(PIGA["QuickBut"]["TrinketScale"]);
		QuickTrinket.yidong=PIGFrame(QuickTrinket)
		QuickTrinket.yidong:PIGSetBackdrop()
		QuickTrinket.yidong:PIGSetMovable(QuickTrinket)
		QuickTrinket.yidong:SetShown(not PIGA["QuickBut"]["TrinketFenlilock"])
		QuickTrinket.yidong:SetScript("OnEnter", function (self)
			self:SetBackdropBorderColor(0,0.8,1, 0.9);
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
			GameTooltip:AddLine(KEY_BUTTON1.."-|cff00FFff"..SWITCH..MODE.."|r\n"..KEY_BUTTON2.."-|cff00FFff"..SETTINGS..MODE.."|r\nShift+"..KEY_BUTTON2.."-|cff00FFff"..SETTINGS.."|r\n"..KEY_BUTTON1.."拖拽-|cff00FFff"..TUTORIAL_TITLE2.."|r")
			GameTooltip:Show();
		end);
		QuickTrinket.yidong:SetScript("OnLeave", function (self)
			self:SetBackdropBorderColor(0, 0, 0, 1);
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end)
		QuickTrinket.yidong:SetScript("OnMouseUp", function (self,Button)
			_G[QuickButUI.TrinketAutoMode]:yidongButClick(self,Button)
		end);
		QuickTrinket.yidong.t = PIGFontString(QuickTrinket.yidong,nil,nil,nil,9)
		QuickTrinket.yidong.t:SetAllPoints(QuickTrinket.yidong)
		_G[QuickButUI.TrinketAutoMode]:SetyidongButText(QuickTrinket.yidong)
		QuickTrinket.nr=PIGFrame(QuickTrinket)
		QuickTrinket.nr:PIGSetBackdrop()
		AutoTrinket:SetParent(QuickTrinket.nr)
		AutoTrinket1:SetParent(QuickTrinket.nr)
		function QuickTrinket.UpdataPailie()
			QuickTrinket.yidong:ClearAllPoints();
			QuickTrinket.nr:ClearAllPoints();
			AutoTrinket:ClearAllPoints();
			AutoTrinket1:ClearAllPoints();
			if PIGA["QuickBut"]["TrinketFenliPailie"]==1 then
				QuickTrinket:SetSize(ActionW*2+14,ActionW);
				QuickTrinket.yidong:SetWidth(12);
				QuickTrinket.yidong:SetPoint("TOPLEFT",QuickTrinket,"TOPLEFT",0,0)
				QuickTrinket.yidong:SetPoint("BOTTOMLEFT", QuickTrinket, "BOTTOMLEFT", 0, 0);
				QuickTrinket.nr:SetPoint("TOPLEFT",QuickTrinket.yidong,"TOPRIGHT",1,0)
				QuickTrinket.nr:SetPoint("BOTTOMRIGHT", QuickTrinket, "BOTTOMRIGHT", 0, 0);
				AutoTrinket:SetPoint("LEFT",QuickTrinket.nr,"LEFT",1,0);
				AutoTrinket1:SetPoint("LEFT",AutoTrinket,"RIGHT",1,0);
			elseif PIGA["QuickBut"]["TrinketFenliPailie"]==2 then
				QuickTrinket:SetSize(ActionW,ActionW*2+14);
				QuickTrinket.yidong:SetHeight(12);
				QuickTrinket.yidong:SetPoint("TOPLEFT",QuickTrinket,"TOPLEFT",0,0)
				QuickTrinket.yidong:SetPoint("TOPRIGHT", QuickTrinket, "TOPRIGHT", 0, 0);
				QuickTrinket.nr:SetPoint("TOPLEFT",QuickTrinket.yidong,"BOTTOMLEFT",0,-1)
				QuickTrinket.nr:SetPoint("BOTTOMRIGHT", QuickTrinket, "BOTTOMRIGHT", 0, 0);
				AutoTrinket:SetPoint("TOP",QuickTrinket.nr,"TOP",0,-1);
				AutoTrinket1:SetPoint("TOP",AutoTrinket,"BOTTOM",0,-1);
			end
		end
		QuickTrinket.UpdataPailie()
	end
	---
	local function Getweizhiinfo()
		if PIGA["QuickBut"]["TrinketFenli"] and PIGA["QuickBut"]["TrinketFenliPailie"]==2 then
			local WowWidth=GetScreenWidth();
			local offset = AutoTrinket:GetRight()
			if offset>(WowWidth*0.5) then
				return {"TOPRIGHT","TOPLEFT",0,0},{"TOPRIGHT","TOPRIGHT",-2,0},{"RIGHT","LEFT",-2,0},{"TOPLEFT","BOTTOMLEFT",0,-2}
			else
				return {"TOPLEFT","TOPRIGHT",0,0},{"TOPLEFT","TOPLEFT",2,0},{"LEFT","RIGHT",2,0},{"TOPLEFT","BOTTOMLEFT",0,-2}
			end
		else
			local WowHeight=GetScreenHeight();
			local offset1 = AutoTrinket:GetBottom();
			if offset1>(WowHeight*0.5) then
				return {"TOPLEFT","BOTTOMLEFT",0,0},{"TOPLEFT","TOPLEFT",0,-2},{"TOP","BOTTOM",0,-2},{"LEFT","RIGHT",2,0}
			else
				return {"BOTTOMLEFT","TOPLEFT",0,0},{"BOTTOMLEFT","BOTTOMLEFT",0,2},{"BOTTOM","TOP",0,2},{"LEFT","RIGHT",2,0}
			end
		end
		return {"BOTTOMLEFT","TOPLEFT",0,0}
	end
	local function UpDatePoints(self)
		local beibaoshipinList = {}
		for bag=1,#bagID do
			for slot = 1, C_Container.GetContainerNumSlots(bagID[bag]) do
				local ItemID = C_Container.GetContainerItemID(bagID[bag], slot);
				if ItemID then
					local itemID, itemType, itemSubType, itemEquipLoc, icon= GetItemInfoInstant(ItemID)
					if itemEquipLoc=="INVTYPE_TRINKET" then
						if not IsDuilieFun(bagID[bag], slot) then
							table.insert(beibaoshipinList,{icon,bagID[bag],slot})
						end
					end
				end
			end
		end
		for i=1,anniushu do
			local fujikj = AutoTrinketList.ButList[i]
			if beibaoshipinList[i] then
				fujikj.bagID=beibaoshipinList[i][2]
				fujikj.slot=beibaoshipinList[i][3]
				fujikj.itemicon=beibaoshipinList[i][1]
				fujikj:Show()
				fujikj:SetNormalTexture(beibaoshipinList[i][1]);
				local startTime, duration, enable = GetContainerItemCooldown(beibaoshipinList[i][2], beibaoshipinList[i][3])
				fujikj.Cooldown.N:SetCooldown(startTime, duration);
			else
				fujikj:Hide()
			end
		end
		local lieshuNUM = math.ceil(#beibaoshipinList*0.5)
		if PIGA["QuickBut"]["TrinketFenli"] and PIGA["QuickBut"]["TrinketFenliPailie"]==2 then
			AutoTrinketList:SetSize((butW+2)*lieshuNUM+2,butW*2+2)
		else
			AutoTrinketList:SetSize(butW*2+2, (butW+2)*lieshuNUM+2)
		end
		--------------
		AutoTrinketList:ClearAllPoints();
		local zhuuiP,anniuUI_1,anniuNext,anniuhuan = Getweizhiinfo()
		for i=1,anniushu do
			local fujikj = AutoTrinketList.ButList[i]
			fujikj:ClearAllPoints();
			if i==1 then
				fujikj:SetPoint(anniuUI_1[1],AutoTrinketList,anniuUI_1[2],anniuUI_1[3],anniuUI_1[4]);
			elseif i==(lieshuNUM+1) then
				fujikj:SetPoint(anniuhuan[1],AutoTrinketList.ButList[1],anniuhuan[2],anniuhuan[3],anniuhuan[4]);
			else
				fujikj:SetPoint(anniuNext[1],AutoTrinketList.ButList[i-1],anniuNext[2],anniuNext[3],anniuNext[4]);
			end
		end
		AutoTrinketList:SetPoint(zhuuiP[1],AutoTrinket,zhuuiP[2],zhuuiP[3],zhuuiP[4]);
		AutoTrinketList:Show()
	end
	AutoTrinket:HookScript("OnEnter", function()
		UpDatePoints()
	end)
	AutoTrinket1:HookScript("OnEnter", function()
		UpDatePoints()
	end)
end