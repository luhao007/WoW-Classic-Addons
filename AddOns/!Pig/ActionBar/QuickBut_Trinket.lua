local addonName, addonTable = ...;
local L=addonTable.locale
--------
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGDiyBut=Create.PIGDiyBut
local PIGButton=Create.PIGButton
local PIGQuickBut=Create.PIGQuickBut
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGDownMenu=Create.PIGDownMenu
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
--==============================
local Data=addonTable.Data
local bagID=Data.bagData["bagID"]
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID = C_Container.GetContainerItemID
local UseContainerItem=C_Container.UseContainerItem
local PickupContainerItem =C_Container.PickupContainerItem
local GetContainerItemCooldown=GetContainerItemCooldown or C_Container and C_Container.GetContainerItemCooldown
local GetContainerItemLink = GetContainerItemLink or C_Container and C_Container.GetContainerItemLink
local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
local GetItemSpell=GetItemSpell or C_Item and C_Item.GetItemSpell
-----
local QuickButUIname=Data.QuickButUIname
local QuickButUI=_G[QuickButUIname]
--
QuickButUI.ButList[3]=function()
	if not PIGA["QuickBut"]["Open"] or not PIGA["QuickBut"]["Trinket"] then return end
	if PIG_TrinketSetUI then return end
	-------
	local TrinkeWW,TrinkeHH = 300,400
	local TrinketSetUI=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,100},{TrinkeWW,TrinkeHH},"PIG_TrinketSetUI",true)
	TrinketSetUI:PIGSetBackdrop()
	TrinketSetUI:PIGSetMovableNoSave()
	TrinketSetUI:PIGClose()
	TrinketSetUI:Hide()
	QuickButUI.yidong:HookScript("OnMouseUp", function (self,Button)
		if Button=="LeftButton" and not PIGA["QuickBut"]["TrinketFenli"] then
			if TrinketSetUI:IsShown() then
				TrinketSetUI:Hide()
			else
				TrinketSetUI:Show()
			end
		end
	end);
	QuickButUI.yidong:HookScript("OnEnter", function ()
		if not PIGA["QuickBut"]["TrinketFenli"] then
			GameTooltip:AddLine(KEY_BUTTON1.."-|cff00FFff"..SETTINGS..INVTYPE_TRINKET..MODE.."|r")
			GameTooltip:Show();
		end
	end);
	local RTabFrame =Create.PIGOptionsList_RF(TrinketSetUI)
	local fujiF,fujiBut =PIGOptionsList_R(RTabFrame,SWITCH..MODE,90)
	fujiF:Show()
	fujiBut:Selected()
	fujiF.TrinketMode=PIGA_Per["QuickBut"]["TrinketMode"]
	fujiF.mode1 = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-5},{TRACKER_SORT_MANUAL..MODE},{16,16})
	fujiF.mode1:SetScript("OnClick", function (self)
		PIGA_Per["QuickBut"]["TrinketMode"]=1
		fujiF:Update_Set()
	end)
	fujiF.mode1.F=PIGFrame(fujiF.mode1,{"TOPLEFT",fujiF,"TOPLEFT",0,-24})
	fujiF.mode1.F:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", 0, 0);
	fujiF.mode1.F:PIGSetBackdrop()
	fujiF.mode2 = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",160,-5},{SELF_CAST_AUTO..MODE},{16,16})
	fujiF.mode2:SetScript("OnClick", function (self)
		PIGA_Per["QuickBut"]["TrinketMode"]=2
		fujiF:Update_Set()
	end)
	fujiF.mode2.F=PIGFrame(fujiF.mode2,{"TOPLEFT",fujiF,"TOPLEFT",0,-24})
	fujiF.mode2.F:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", 0, 0);
	fujiF.mode2.F:PIGSetBackdrop()

	local tishiNR = "1、此模式下"..INVTYPE_TRINKET..SWITCH..TRACKER_SORT_MANUAL..NPE_CONTROLS..
					"\n\n2、"..LEAVING_COMBAT..":\n"..string.rep(" ", 6)..KEY_BUTTON1..SWITCH.."上"..INVTYPE_TRINKET.."\n"..string.rep(" ", 6)..KEY_BUTTON2..SWITCH.."下"..INVTYPE_TRINKET..
					"\n\n3、"..AT_WAR.."点击加入队列,\n"..string.rep(" ", 6)..LEAVING_COMBAT..SWITCH..INVTYPE_TRINKET..
					"\n\n4、"..KEY_BUTTON2.."取消队列中饰品"
	fujiF.mode1.F.tip = PIGFontString(fujiF.mode1.F,{"TOPLEFT",fujiF.mode1.F,"TOPLEFT",10,-13},tishiNR)
	fujiF.mode1.F.tip:SetJustifyH("LEFT")
	fujiF.LockTrinket=PIGA_Per["QuickBut"]["LockTrinket"]
	fujiF.mode2.F.tip = PIGFontString(fujiF.mode2.F,{"TOPLEFT",fujiF.mode2.F,"TOPLEFT",10,-4},"选中"..CHAT_JOIN..SELF_CAST_AUTO..SWITCH..SOCIAL_QUEUE_TOOLTIP_HEADER.."(CD后脱战切换)")
	fujiF.mode2.F.locksp1 = PIGCheckbutton(fujiF.mode2.F,{"TOPLEFT",fujiF.mode2.F,"TOPLEFT",10,-30},{LOCK.."上"..INVTYPE_TRINKET},{14,14})
	fujiF.mode2.F.locksp1:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA_Per["QuickBut"]["LockTrinket"]=1
		else
			PIGA_Per["QuickBut"]["LockTrinket"]=0
		end
		fujiF:Update_Set()
		fujiF.mode2.F.List.Update_hang()
	end)
	fujiF.mode2.F.locksp2 = PIGCheckbutton(fujiF.mode2.F,{"LEFT",fujiF.mode2.F.locksp1.Text,"RIGHT",20,0},{LOCK.."下"..INVTYPE_TRINKET},{14,14})
	fujiF.mode2.F.locksp2:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA_Per["QuickBut"]["LockTrinket"]=2
		else
			PIGA_Per["QuickBut"]["LockTrinket"]=0
		end
		fujiF:Update_Set()
		fujiF.mode2.F.List.Update_hang()
	end)
	local hang_Height,hang_NUM  = 26, 11;
	fujiF.mode2.F.List=PIGFrame(fujiF.mode2.F,{"TOPLEFT",fujiF.mode2.F,"TOPLEFT",0,-50})
	fujiF.mode2.F.List:SetPoint("BOTTOMRIGHT",fujiF.mode2.F,"BOTTOMRIGHT",-16,0);
	fujiF.mode2.F.List:PIGSetBackdrop()
	fujiF.mode2.F.List.Scroll = CreateFrame("ScrollFrame",nil,fujiF.mode2.F.List, "FauxScrollFrameTemplate");  
	fujiF.mode2.F.List.Scroll:SetPoint("TOPLEFT",fujiF.mode2.F.List,"TOPLEFT",0,0);
	fujiF.mode2.F.List.Scroll:SetPoint("BOTTOMRIGHT",fujiF.mode2.F.List,"BOTTOMRIGHT",-3,0);
	fujiF.mode2.F.List.Scroll.ScrollBar:SetScale(0.8);
	fujiF.mode2.F.List.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fujiF.mode2.F.List.Update_hang)
	end)
	fujiF.mode2.F.List.ButList={}
	for id = 1, hang_NUM do
		local hang = CreateFrame("Button", nil, fujiF.mode2.F.List,nil,id);
		fujiF.mode2.F.List.ButList[id]=hang
		hang:SetSize(fujiF.mode2.F.List:GetWidth(), hang_Height);
		if id==1 then
			hang:SetPoint("TOPLEFT",fujiF.mode2.F.List.Scroll,"TOPLEFT",0,-1);
		else
			hang:SetPoint("TOP",fujiF.mode2.F.List.ButList[id-1],"BOTTOM",0,-1);
		end
		hang.highlight = hang:CreateTexture();
		hang.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
		hang.highlight:SetBlendMode("ADD")
		hang.highlight:SetAllPoints(hang)
		hang.highlight:SetAlpha(0.2);
		hang.check = hang:CreateTexture()
		hang.check:SetTexture("interface/buttons/ui-checkbox-check.bl");
		hang.check:SetSize(hang_Height-6,hang_Height-2);
		hang.check:SetPoint("LEFT", hang, "LEFT", 0,0);
		hang.icon = hang:CreateTexture(nil, "BORDER");
		hang.icon:SetSize(hang_Height-2,hang_Height-2);
		hang.icon:SetPoint("LEFT", hang.check, "RIGHT", 0,0);
		hang.link = PIGFontString(hang,{"LEFT", hang.icon, "RIGHT", 4,0})
		hang:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_LEFT",TrinkeWW);
			GameTooltip:SetHyperlink(fujiF.AllTrinketLsit[self.itemID][2])
			GameTooltip:Show();
			local tooltip, anchorFrame, shoppingTooltip1, shoppingTooltip2 = GameTooltip_InitializeComparisonTooltips(GameTooltip);
			shoppingTooltip1:Hide()
			shoppingTooltip2:Hide()
		end);
		hang:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		hang:SetScript("OnMouseUp", function (self,button)
			for ib=#PIGA_Per["QuickBut"]["TrinketList"],1,-1 do
				if self.itemID==PIGA_Per["QuickBut"]["TrinketList"][ib] then
					table.remove(PIGA_Per["QuickBut"]["TrinketList"],ib)
					fujiF.mode2.F.List.Update_hang()
					return
				end
			end
			table.insert(PIGA_Per["QuickBut"]["TrinketList"],self.itemID)
			fujiF.mode2.F.List.Update_hang()
		end);
		hang.DOWN = PIGDiyBut(hang,{"RIGHT", hang, "RIGHT", 0,0},{hang_Height-2,nil,nil,nil,"NPE_ArrowDown"})
		hang.DOWN:SetScript("OnClick", function (self)
			local fujik = self:GetParent()
			fujiF.mode2.F.List.UpdateUpDwan(fujik.itemID,"+")
		end);
		hang.UP = PIGDiyBut(hang,{"RIGHT", hang.DOWN, "LEFT", -1,0},{hang_Height-2,nil,nil,nil,"NPE_ArrowUp"})
		hang.UP:SetScript("OnClick", function (self)
			local fujik = self:GetParent()
			fujiF.mode2.F.List.UpdateUpDwan(fujik.itemID,"-")
		end);
	end
	fujiF.mode2.F.List:SetScript("OnShow", function (self)
		self.Update_hang()
	end)
	fujiF.AllTrinketLsit={}
	fujiF.SortTrinketLsit={}
	fujiF.NextTrinketLsit={}
	fujiF.SelectedNum=0
	--获取身上饰品
	local function GetPlaterTrinketSlotId(datax,invSlotId)
		local itemID= GetInventoryItemID("player", invSlotId)
		if itemID then
			local ItemLink= GetInventoryItemLink("player", invSlotId)
			local icon= GetInventoryItemTexture("player", invSlotId)
			datax[itemID]={icon,ItemLink}
		end
	end
	local function GetPlaterTrinket(datax)
		GetPlaterTrinketSlotId(datax,13)
		GetPlaterTrinketSlotId(datax,14)
	end
	--获取背包饰品
	local function GetBagTrinket(datax)
		for bag=1,#bagID do
			for slot = 1, C_Container.GetContainerNumSlots(bagID[bag]) do
				local ItemLink = GetContainerItemLink(bagID[bag], slot);
				if ItemLink then
					local itemID, itemType, itemSubType, itemEquipLoc, icon= GetItemInfoInstant(ItemLink)
					if itemEquipLoc=="INVTYPE_TRINKET" then
						datax[itemID]={icon,ItemLink,bagID[bag], slot}
					end
				end
			end
		end
	end
	local function GetPlaterBagTrinket()
	    wipe(fujiF.AllTrinketLsit)
		GetPlaterTrinket(fujiF.AllTrinketLsit)
		GetBagTrinket(fujiF.AllTrinketLsit)
	end
	local function SortTrinketList()
		wipe(fujiF.SortTrinketLsit)
		wipe(fujiF.NextTrinketLsit)
		for i=1,#PIGA_Per["QuickBut"]["TrinketList"] do
			for k,v in pairs(fujiF.AllTrinketLsit) do
				if k==PIGA_Per["QuickBut"]["TrinketList"][i] then
					table.insert(fujiF.SortTrinketLsit,k)
					if v[3] and v[4] then
						table.insert(fujiF.NextTrinketLsit,{k,v[3],v[4]})
					end
					fujiF.AllTrinketLsit[k][3]=true
				end
			end
		end
		fujiF.SelectedNum=#fujiF.SortTrinketLsit
		for k,v in pairs(fujiF.AllTrinketLsit) do
			if not fujiF.AllTrinketLsit[k][3] then
				table.insert(fujiF.SortTrinketLsit,k)
			end
		end
	end
	function fujiF.mode2.F.List.UpdateUpDwan(itemID,caozuo)
		local jiluweizhi = {0,{}}
		for i=1,#PIGA_Per["QuickBut"]["TrinketList"] do
			if itemID==PIGA_Per["QuickBut"]["TrinketList"][i] then
				jiluweizhi[1]=i
				jiluweizhi[2]=PIGA_Per["QuickBut"]["TrinketList"][i]
				table.remove(PIGA_Per["QuickBut"]["TrinketList"],i)
			end
		end
		if caozuo=="-" then
			table.insert(PIGA_Per["QuickBut"]["TrinketList"],jiluweizhi[1]-1,jiluweizhi[2])
		elseif caozuo=="+" then
			table.insert(PIGA_Per["QuickBut"]["TrinketList"],jiluweizhi[1]+1,jiluweizhi[2])
		end
		fujiF.mode2.F.List.Update_hang()
	end
	function fujiF.mode2.F.List.Update_hang()
		local Scroll = fujiF.mode2.F.List.Scroll
		for id = 1, hang_NUM do
			fujiF.mode2.F.List.ButList[id]:Hide();
	    end
		GetPlaterBagTrinket()
		SortTrinketList()
		local ItemsNum = #fujiF.SortTrinketLsit
	    FauxScrollFrame_Update(Scroll, ItemsNum, hang_NUM, hang_Height);
	    local offset = FauxScrollFrame_GetOffset(Scroll);
	    for id = 1, hang_NUM do
			local dangqianH = id+offset;
			if fujiF.SortTrinketLsit[dangqianH] then
	    		local hang = fujiF.mode2.F.List.ButList[id]
	    		hang:Show();
		    	hang.icon:SetTexture(fujiF.AllTrinketLsit[fujiF.SortTrinketLsit[dangqianH]][1]);
				hang.link:SetText(fujiF.AllTrinketLsit[fujiF.SortTrinketLsit[dangqianH]][2]);
				hang.itemID=fujiF.SortTrinketLsit[dangqianH]
				if fujiF.AllTrinketLsit[fujiF.SortTrinketLsit[dangqianH]][3] then
					hang.icon:SetDesaturated(false)
					hang.check:Show()
					hang.UP:Show()
					hang.DOWN:Show()
					if dangqianH==1 then
		    			hang.UP:Disable()
		    		else
		    			hang.UP:Enable()
		    		end
		    		if dangqianH==fujiF.SelectedNum then
		    			hang.DOWN:Disable()
		    		else
		    			hang.DOWN:Enable()
		    		end
				else
					hang.icon:SetDesaturated(true)
					hang.check:Hide()
					hang.UP:Hide()
					hang.DOWN:Hide()
				end
			end
		end
	end
	fujiF:SetScript("OnShow", function (self)
		self:Update_Set()
	end)
	function fujiF:Update_Set()
		self.mode1:SetChecked(false)
		self.mode2:SetChecked(false)
		self.mode1.F:Hide()
		self.mode2.F:Hide()
		self.TrinketMode=PIGA_Per["QuickBut"]["TrinketMode"]
		if PIGA_Per["QuickBut"]["TrinketMode"]==1 then
			self.mode1:SetChecked(true)
			self.mode1.F:Show()
		elseif PIGA_Per["QuickBut"]["TrinketMode"]==2 then
			self.mode2:SetChecked(true)
			self.mode2.F:Show()
		end
		self.LockTrinket=PIGA_Per["QuickBut"]["LockTrinket"]
		self.mode2.F.locksp1:SetChecked(false)
		self.mode2.F.locksp2:SetChecked(false)
		self.mode2.F.locksp1:SetChecked(PIGA_Per["QuickBut"]["LockTrinket"]==1)
		self.mode2.F.locksp2:SetChecked(PIGA_Per["QuickBut"]["LockTrinket"]==2)
	end
	--设置
	local SetfujiF =PIGOptionsList_R(RTabFrame,SETTINGS,70)
	SetfujiF.Bindings = PIGButton(SetfujiF,{"TOPLEFT",SetfujiF,"TOPLEFT",20,-20},{76,20},KEY_BINDING);
	SetfujiF.Bindings:SetScript("OnClick", function (self)
		Settings.OpenToCategory(Settings.KEYBINDINGS_CATEGORY_ID, addonName);
	end)
	SetfujiF.Fenli = PIGCheckbutton(SetfujiF,{"TOPLEFT",SetfujiF,"TOPLEFT",20,-60},{UNDOCK_WINDOW.."(需"..RELOADUI..")","分离"..INVTYPE_TRINKET..VIDEO_OPTIONS_WINDOWED})
	SetfujiF.Fenli:SetScript("OnClick", function (self)
		StaticPopup_Show("PIGQKTRINKETFENLIMODE",nil,nil,self:GetChecked());
	end)
	StaticPopupDialogs["PIGQKTRINKETFENLIMODE"] = {
		text = "此操作将"..RELOADUI.."?",
		button1 = YES,
		button2 = NO,
		OnAccept = function(self,data)
			PIGA["QuickBut"]["TrinketFenli"]=data
			C_UI.Reload()
		end,
		OnCancel = function()
			SetfujiF.Fenli:SetChecked(PIGA["QuickBut"]["TrinketFenli"])
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	SetfujiF.PailieT = PIGFontString(SetfujiF,{"TOPLEFT",SetfujiF.Fenli,"BOTTOMLEFT",10,-20},"分离后排序方向")
	local pailieList = {"横","竖"}
	SetfujiF.Pailie=PIGDownMenu(SetfujiF,{"LEFT",SetfujiF.PailieT,"RIGHT",2,0},{46,nil})
	function SetfujiF.Pailie:PIGDownMenu_Update_But()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#pailieList,1 do
		    info.text, info.arg1 = pailieList[i], i
		    info.checked = i==PIGA["QuickBut"]["TrinketFenliPailie"]
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function SetfujiF.Pailie:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		PIGA["QuickBut"]["TrinketFenliPailie"]=arg1
		if fujiF.UpdataFenliPailie then fujiF.UpdataFenliPailie() end
		PIGCloseDropDownMenus()
	end
	SetfujiF.Scale_t = PIGFontString(SetfujiF,{"TOPLEFT",SetfujiF.PailieT,"BOTTOMLEFT",0,-20},"缩放:")
	local xiayiinfo = {0.8,1.8,0.01,{["Right"]="%"}}
	SetfujiF.Scale = PIGSlider(SetfujiF,{"LEFT",SetfujiF.Scale_t,"RIGHT",10,0},xiayiinfo)
	SetfujiF.Scale.Slider:HookScript("OnValueChanged", function(self, arg1)
		PIGA["QuickBut"]["TrinketScale"]=arg1;
		if fujiF.UpdataFenliScale then fujiF.UpdataFenliScale() end
	end)
	SetfujiF.lock = PIGCheckbutton(SetfujiF,{"TOPLEFT",SetfujiF.Scale_t,"BOTTOMLEFT",0,-20},{LOCK_FRAME,LOCK_FOCUS_FRAME})
	SetfujiF.lock:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["QuickBut"]["TrinketFenlilock"]=true
		else
			PIGA["QuickBut"]["TrinketFenlilock"]=false
		end
		if fujiF.UpdataFenliScale then fujiF.UpdataFenliScale() end
	end)
	SetfujiF.CZBUT = PIGButton(SetfujiF,{"TOPLEFT",SetfujiF.lock,"BOTTOMLEFT",0,-20},{80,24},"重置位置")
	SetfujiF.CZBUT:SetScript("OnClick", function ()
		PIGA["QuickBut"]["TrinketScale"]=1
		SetfujiF.Scale:PIGSetValue(1)
		if fujiF.UpdataFenliCZ then fujiF.UpdataFenliCZ() end
	end)
	SetfujiF:SetScript("OnShow", function (self)
		SetfujiF.PailieT:SetShown(PIGA["QuickBut"]["TrinketFenli"])
		SetfujiF.Scale_t:SetShown(PIGA["QuickBut"]["TrinketFenli"])
		SetfujiF.Pailie:SetShown(PIGA["QuickBut"]["TrinketFenli"])
		SetfujiF.lock:SetShown(PIGA["QuickBut"]["TrinketFenli"])
		SetfujiF.Scale:SetShown(PIGA["QuickBut"]["TrinketFenli"])
		SetfujiF.CZBUT:SetShown(PIGA["QuickBut"]["TrinketFenli"])
		if PIGA["QuickBut"]["TrinketFenli"] then
			SetfujiF.Fenli:SetChecked(PIGA["QuickBut"]["TrinketFenli"])
			SetfujiF.Pailie:PIGDownMenu_SetText(pailieList[PIGA["QuickBut"]["TrinketFenliPailie"]])
			SetfujiF.lock:SetChecked(PIGA["QuickBut"]["TrinketFenlilock"])
			SetfujiF.Scale:PIGSetValue(PIGA["QuickBut"]["TrinketScale"])
		end
	end)
	--饰品切换界面
	local Icon,anniushu,butW=136528,20,QuickButUI:GetHeight()
	local TrinketSelectF = PIGFrame(UIParent)
	TrinketSelectF:SetScale(PIGA["QuickBut"]["bili"]);
	TrinketSelectF:PIGSetBackdrop(1)
	TrinketSelectF:SetFrameLevel(QuickButUI:GetFrameLevel()+4)
	TrinketSelectF:Hide()
	function TrinketSelectF:OnEnterShow(TrinketUI)
		TrinketUI:HookScript("OnEnter", function()
			TrinketSelectF:Show()
		end)
	end
	function TrinketSelectF:OnLeaveHide(TrinketUI)
		TrinketUI:HookScript("OnLeave", function()
			TrinketSelectF:Hide()
		end)
	end
	TrinketSelectF:OnEnterShow(TrinketSelectF)
	TrinketSelectF:OnLeaveHide(TrinketSelectF)
	TrinketSelectF.ButList={}
	for i=1,anniushu do
		local hangBut = CreateFrame("Button", nil, TrinketSelectF,nil,i)
		TrinketSelectF.ButList[i]=hangBut
		local tmp1,tmp2 = math.modf(i/2)
		if i==1 then
		elseif tmp2==0 then
			hangBut:SetPoint("LEFT",TrinketSelectF.ButList[i-1],"RIGHT",1,0);
		else
			hangBut:SetPoint("TOPLEFT",TrinketSelectF.ButList[i-2],"BOTTOMLEFT",0,-1);
		end
		hangBut:SetHighlightTexture(130718);
		hangBut:SetSize(butW, butW)
		hangBut.Cooldown = CreateFrame("Frame", nil, hangBut);
		hangBut.Cooldown:SetAllPoints()
		hangBut.Cooldown.N = CreateFrame("Cooldown", nil, hangBut.Cooldown, "CooldownFrameTemplate")
		hangBut.Cooldown.N:SetAllPoints()
		hangBut:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		hangBut:SetScript("OnEnter", function(self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(TrinketSelectF, "ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT",TrinketSelectF,"BOTTOMRIGHT",2,2);
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
		TrinketSelectF:OnEnterShow(hangBut)
		TrinketSelectF:OnLeaveHide(hangBut)
		hangBut:HookScript("OnClick", function(self,button)
			if button=="LeftButton" then
				if InCombatLockdown() then
					if PIGA_Per["QuickBut"]["TrinketMode"]==2 then
						PIG_OptionsUI:ErrorMsg("当前处于自动模式", "R")
						return
					end
					TrinketSelectF.LeftTrinket.NextList={self.bagID,self.slot,self.itemicon}
					TrinketSelectF.LeftTrinket:NextListFun()
				else
					PickupContainerItem(self.bagID,self.slot)
					PickupInventoryItem(TrinketSelectF.LeftTrinket.Inventoryslot)
				end
			else
				if InCombatLockdown() then
					if PIGA_Per["QuickBut"]["TrinketMode"]==2 then
						PIG_OptionsUI:ErrorMsg("当前处于自动模式", "R")
						return
					end
					TrinketSelectF.RightTrinket.NextList={self.bagID,self.slot,self.itemicon}
					TrinketSelectF.RightTrinket:NextListFun()
				else
					PickupContainerItem(self.bagID,self.slot)
					PickupInventoryItem(TrinketSelectF.RightTrinket.Inventoryslot)
				end
			end
			TrinketSelectF:Hide()
		end);
	end
	TrinketSelectF.DQList={}
	function TrinketSelectF:UpdatePointsSize()
		for i=1,anniushu do
			self.ButList[i]:Hide()
		end
		GetPlaterBagTrinket()	
		wipe(self.DQList)
		for k,v in pairs(fujiF.AllTrinketLsit) do
			if v[3] and v[4] then
				table.insert(self.DQList,{k,v[1],v[2],v[3],v[4]})
			end
		end
		for i=1,anniushu do
			if self.DQList[i] then
				local fujikj = self.ButList[i]
				fujikj:Show()
				fujikj.bagID=self.DQList[i][4]
				fujikj.slot=self.DQList[i][5]
				fujikj.itemicon=self.DQList[i][2]
				fujikj:SetNormalTexture(self.DQList[i][2]);
				local startTime, duration, enable = GetContainerItemCooldown(self.DQList[i][4], self.DQList[i][5])
				fujikj.Cooldown.N:SetCooldown(startTime, duration);
			end
		end
		local lieshuNUM = math.ceil(#self.DQList*0.5)
		self:SetSize((butW+1)*2+3, (butW+1)*lieshuNUM+6)
	end
	TrinketSelectF:HookScript("OnShow", function(self)
		self:UpdatePointsSize()
	end)
	--创建饰品切换按钮
	local GnUI = "PIG_QkBut_AutoTrinket"
	local AutoTrinket=PIGQuickBut(GnUI,TRINKET0SLOT_UNIQUE,Icon,nil,nil,"SecureActionButtonTemplate")--UseInventoryItem(13)
	TrinketSelectF.LeftTrinket=AutoTrinket
	local AutoTrinket1=PIGQuickBut(GnUI.."1",TRINKET1SLOT_UNIQUE,Icon,nil,nil,"SecureActionButtonTemplate")
	TrinketSelectF.RightTrinket=AutoTrinket1
	addonTable.Fun.ActionFun.PIGUseKeyDown(AutoTrinket)
	addonTable.Fun.ActionFun.PIGUseKeyDown(AutoTrinket1)
	AutoTrinket:SetAttribute("type1", "macro");
	AutoTrinket:SetAttribute("macrotext", [=[/use 13]=]);
	AutoTrinket1:SetAttribute("type1", "macro");
	AutoTrinket1:SetAttribute("macrotext", [=[/use 14]=]);
	_G["BINDING_NAME_CLICK PIG_QkBut_AutoTrinket:LeftButton"]= "PIG"..L["ACTION_TABNAME2"]..TRINKET0SLOT_UNIQUE
	_G["BINDING_NAME_CLICK PIG_QkBut_AutoTrinket1:LeftButton"]= "PIG"..L["ACTION_TABNAME2"]..TRINKET1SLOT_UNIQUE
	local function add_Button(fujiUI,slotID)
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
			GameTooltip:SetOwner(TrinketSelectF, "ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT",TrinketSelectF,"BOTTOMRIGHT",2,2);
			GameTooltip:SetInventoryItem("player",slotID)
			GameTooltip:Show();
		end)
		fujiUI:SetScript("OnLeave", function()
			GameTooltip:ClearLines();
			GameTooltip:Hide()
		end)
		TrinketSelectF:OnEnterShow(fujiUI)
		TrinketSelectF:OnLeaveHide(fujiUI)
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
		function fujiUI:Update_Cooldown()
			local start, duration, enable = GetInventoryItemCooldown("player", slotID)
			CooldownFrame_Set(fujiUI.Cooldown.N, start, duration, enable)
		end
		fujiUI:SetanniuIcon()
		fujiUI:Update_Cooldown()
	end
	add_Button(AutoTrinket,13)
	add_Button(AutoTrinket1,14)
	function fujiF.Update_TrinketSelectF(BottomUI)
		local WowHeight=GetScreenHeight();
		local offset1 = BottomUI:GetBottom();
		if offset1>(WowHeight*0.5) then
			TrinketSelectF.ButList[1]:SetPoint("TOPLEFT",TrinketSelectF,"TOPLEFT",2,-4);
			TrinketSelectF:SetPoint("TOPLEFT",AutoTrinket,"BOTTOMLEFT",-2,1);
		else
			TrinketSelectF.ButList[1]:SetPoint("TOPLEFT",TrinketSelectF,"TOPLEFT",2,-2);
			TrinketSelectF:SetPoint("BOTTOMLEFT",AutoTrinket,"TOPLEFT",-2,-1);
		end
	end
	--已在队列
	-- local function IsDuilieFun(bag,slot)
	-- 	if AutoTrinket.NextList then
	-- 		if AutoTrinket.NextList[1]==bag and AutoTrinket.NextList[2]==slot then
	-- 			return true
	-- 		end
	-- 	end
	-- 	if AutoTrinket1.NextList then
	-- 		if AutoTrinket1.NextList[1]==bag and AutoTrinket1.NextList[2]==slot then
	-- 			return true
	-- 		end
	-- 	end
	-- 	return false
	-- end
 	local function _fun_PickupContainer(bagID, slot, invSlotId)
 		if bagID and slot and invSlotId then
 			local ItemID = C_Container.GetContainerItemID(bagID, slot)
 			if ItemID then
 				local _, _, _, itemEquipLoc= GetItemInfoInstant(ItemID)
				if itemEquipLoc=="INVTYPE_TRINKET" then
					PickupContainerItem(bagID, slot)
					PickupInventoryItem(invSlotId)
				end
			end
		end
	end
	local function AutoSwitchingTrinket_1(invSlotId,NewTrinketData)
		local Invstart, Invduration, Invenable = GetInventoryItemCooldown("player", invSlotId)
		--start - 冷却时间的开始时间，如果没有冷却时间（或槽中没有物品），则为 0
		--duration - 冷却时间的持续时间（不是剩余时间）。如果物品没有使用/冷却时间或插槽为空，则为 0。
		--enable- 返回 1 或 0。如果库存物品能够有冷却时间，则为 1，如果不能，则为 0。
 		if Invenable==0 or Invenable==1 and (Invstart+Invduration-GetTime())>30 then
 			local ItemLink= GetInventoryItemLink("player", invSlotId)
			for i=1,#NewTrinketData do
				local _, spellID = GetItemSpell(NewTrinketData[i][1])
				if spellID then
					local start, duration, enable = C_Container.GetItemCooldown(NewTrinketData[i][1])
					if enable==1 and (start+duration-GetTime())<32 then
						_fun_PickupContainer(NewTrinketData[i][2], NewTrinketData[i][3], invSlotId)
						return
					elseif enable==0 then
						_fun_PickupContainer(NewTrinketData[i][2], NewTrinketData[i][3], invSlotId)
						return
					end
				else
					_fun_PickupContainer(NewTrinketData[i][2], NewTrinketData[i][3], invSlotId)
					return
				end
			end
		end
	end
	function TrinketSelectF:AutoSwitchingTrinket()
		wipe(fujiF.NextTrinketLsit)
		GetPlaterBagTrinket()
		SortTrinketList()
		if fujiF.LockTrinket==1 then
			local id_13 = GetInventoryItemID("player", 13)
			for ix=#fujiF.NextTrinketLsit,1,-1 do
				if id_13==fujiF.NextTrinketLsit[ix][1] then
					table.remove(fujiF.NextTrinketLsit,ix)
					break
				end
			end
		elseif fujiF.LockTrinket==2 then
			local id_14 = GetInventoryItemID("player", 14)
			for ix=#fujiF.NextTrinketLsit,1,-1 do
				if id_14==fujiF.NextTrinketLsit[ix][1] then
					table.remove(fujiF.NextTrinketLsit,ix)
					break
				end
			end
		end
		if fujiF.LockTrinket==1 then
			AutoSwitchingTrinket_1(14,fujiF.NextTrinketLsit)
		elseif fujiF.LockTrinket==2 then
			AutoSwitchingTrinket_1(13,fujiF.NextTrinketLsit)
		else
			AutoSwitchingTrinket_1(13,fujiF.NextTrinketLsit)
			AutoSwitchingTrinket_1(14,fujiF.NextTrinketLsit)
		end
	end
	-------------
	TrinketSelectF:RegisterEvent("PLAYER_ENTERING_WORLD");
	TrinketSelectF:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");--更换装备
	TrinketSelectF:RegisterEvent("PLAYER_REGEN_ENABLED");
	TrinketSelectF:RegisterUnitEvent("UNIT_SPELLCAST_START","player");
	TrinketSelectF:RegisterUnitEvent("UNIT_SPELLCAST_STOP","player");
	TrinketSelectF:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	TrinketSelectF:HookScript("OnEvent", function(self,event,arg1,_,arg3)
		if event=="PLAYER_ENTERING_WORLD" or event=="PLAYER_EQUIPMENT_CHANGED" then
			AutoTrinket:SetanniuIcon()
			AutoTrinket1:SetanniuIcon()
			AutoTrinket:Update_Cooldown()
			AutoTrinket1:Update_Cooldown()
		elseif event=="PLAYER_REGEN_ENABLED" then
			if InCombatLockdown() then return end
			if fujiF.TrinketMode==1 then
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
			elseif fujiF.TrinketMode==2 then
				self:AutoSwitchingTrinket()
			end
		elseif event=="SPELL_UPDATE_COOLDOWN" then
			C_Timer.After(0.01, function()
				AutoTrinket:Update_Cooldown()
				AutoTrinket1:Update_Cooldown()
			end)
		end
	end);
	--分离模式
	if PIGA["QuickBut"]["TrinketFenli"] then
		local UIname= "PIG_QuickTrinketUI"
		Data.UILayout[UIname]={"BOTTOM","BOTTOM",-200,200}
		local FenliUI=PIGFrame(UIParent,nil,nil,UIname)
		Create.PIG_SetPoint(UIname)
		FenliUI.yidong=PIGFrame(FenliUI)
		FenliUI.yidong:PIGSetBackdrop()
		FenliUI.yidong:PIGSetMovable(FenliUI)
		FenliUI.yidong:SetScript("OnEnter", function (self)
			self:SetBackdropBorderColor(0,0.8,1, 0.9);
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
			GameTooltip:AddLine(L["LIB_TIPS"])
			GameTooltip:AddLine(KEY_BUTTON1.."拖拽-|cff00FFff"..TUTORIAL_TITLE2.."|r")	
			GameTooltip:AddLine(KEY_BUTTON1.."-|cff00FFff"..SETTINGS..INVTYPE_TRINKET..MODE.."|r")
			GameTooltip:Show();
		end);
		FenliUI.yidong:SetScript("OnLeave", function (self)
			self:SetBackdropBorderColor(0, 0, 0, 1);
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end)
		FenliUI.yidong:SetScript("OnMouseUp", function (self,Button)
			if TrinketSetUI:IsShown() then
				TrinketSetUI:Hide()
			else
				TrinketSetUI:Show()
			end
		end);
		FenliUI.yidong.t = PIGFontString(FenliUI.yidong,nil,nil,nil,9)
		FenliUI.yidong.t:SetAllPoints(FenliUI.yidong)
		FenliUI.yidong.t:SetTextColor(0.8, 0.8, 0.8, 0.8)
		FenliUI.nr=PIGFrame(FenliUI)
		FenliUI.nr:PIGSetBackdrop()
		AutoTrinket:SetParent(FenliUI.nr)
		AutoTrinket1:SetParent(FenliUI.nr)
		function fujiF.UpdataFenliPailie()
			FenliUI.yidong:ClearAllPoints();
			FenliUI.nr:ClearAllPoints();
			AutoTrinket:ClearAllPoints();
			AutoTrinket1:ClearAllPoints();
			if PIGA["QuickBut"]["TrinketFenliPailie"]==1 then
				FenliUI:SetSize(butW*2+14,butW);
				FenliUI.yidong.t:SetText("拖\n动");
				FenliUI.yidong:SetWidth(12);
				FenliUI.yidong:SetPoint("TOPLEFT",FenliUI,"TOPLEFT",0,0)
				FenliUI.yidong:SetPoint("BOTTOMLEFT", FenliUI, "BOTTOMLEFT", 0, 0);
				FenliUI.nr:SetPoint("TOPLEFT",FenliUI.yidong,"TOPRIGHT",1,0)
				FenliUI.nr:SetPoint("BOTTOMRIGHT", FenliUI, "BOTTOMRIGHT", 0, 0);
				AutoTrinket:SetPoint("LEFT",FenliUI.nr,"LEFT",1,0);
				AutoTrinket1:SetPoint("LEFT",AutoTrinket,"RIGHT",1,0);
			elseif PIGA["QuickBut"]["TrinketFenliPailie"]==2 then
				FenliUI:SetSize(butW,butW*2+14);
				FenliUI.yidong.t:SetText("拖动");
				FenliUI.yidong:SetHeight(12);
				FenliUI.yidong:SetPoint("TOPLEFT",FenliUI,"TOPLEFT",0,0)
				FenliUI.yidong:SetPoint("TOPRIGHT", FenliUI, "TOPRIGHT", 0, 0);
				FenliUI.nr:SetPoint("TOPLEFT",FenliUI.yidong,"BOTTOMLEFT",0,-1)
				FenliUI.nr:SetPoint("BOTTOMRIGHT", FenliUI, "BOTTOMRIGHT", 0, 0);
				AutoTrinket:SetPoint("TOP",FenliUI.nr,"TOP",0,-1);
				AutoTrinket1:SetPoint("TOP",AutoTrinket,"BOTTOM",0,-1);
			end
		end
		function fujiF.UpdataFenliScale()
			if PIGA["QuickBut"]["TrinketFenlilock"] then
				FenliUI.yidong:RegisterForDrag("")
			else
				FenliUI.yidong:RegisterForDrag("LeftButton")
			end
			--FenliUI.yidong:SetShown(PIGA["QuickBut"]["TrinketFenlilock"])
			FenliUI:SetScale(PIGA["QuickBut"]["TrinketScale"]);
		end
		function fujiF.UpdataFenliCZ()
			Create.PIG_ResPoint(UIname)
			FenliUI:SetScale(PIGA["QuickBut"]["TrinketScale"]);
		end
		fujiF.UpdataFenliScale()
		fujiF.UpdataFenliPailie()
		fujiF.Update_TrinketSelectF(FenliUI)
	else
		fujiF.Update_TrinketSelectF(QuickButUI)
	end
end