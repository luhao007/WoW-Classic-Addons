local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
----------
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGDownMenu=Create.PIGDownMenu
local PIGQuickBut=Create.PIGQuickBut
local PIGLine=Create.PIGLine
local PIGSlider = Create.PIGSlider
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
--------------
local Fun=addonTable.Fun
local ActionFun=Fun.ActionFun
local PIGUseKeyDown=ActionFun.PIGUseKeyDown
local Update_Attribute=ActionFun.Update_Attribute
local Update_Icon=ActionFun.Update_Icon
local Update_Cooldown=ActionFun.Update_Cooldown
local Update_Count=ActionFun.Update_Count
local Update_bukeyong=ActionFun.Update_bukeyong
local Update_State=ActionFun.Update_State
local Update_PostClick=ActionFun.Update_PostClick
local loadingButInfo=ActionFun.loadingButInfo
local Update_OnEnter=ActionFun.Update_OnEnter
local Cursor_Fun=ActionFun.Cursor_Fun
local Update_Macro=ActionFun.Update_Macro
----
local GetItemInfoInstant= GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
local PIGbookType
if tocversion<50000 then
	PIGbookType=BOOKTYPE_SPELL
else
	PIGbookType=Enum.SpellBookSpellBank.Player
end
---功能动作条===========
local ActionBarfun=addonTable.ActionBarfun
local fuFrame=ActionBarfun.fuFrame
local fuFrameBut=ActionBarfun.fuFrameBut
local RTabFrame=ActionBarfun.RTabFrame
local QuickButF,QuickButTabBut =PIGOptionsList_R(RTabFrame,L["ACTION_TABNAME2"],100)
ActionBarfun.QuickButF=QuickButF
--
QuickButF.Open=PIGCheckbutton_R(QuickButF,{L["ACTION_TABNAME2"],"在屏幕上创建一条"..L["ACTION_TABNAME2"].."，以便快捷使用某些功能。\n你可以自定义需要显示的按钮"})
QuickButF.Open:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Open"]=true;
		QuickButUI:Add()
	else
		PIGA["QuickBut"]["Open"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end)
--
local function QuickButFLock()
	if QuickButUI.yidong then
		if PIGA["QuickBut"]["Lock"] then
			QuickButUI.yidong:Hide()
		else
			QuickButUI.yidong:Show()
		end
	end
end
QuickButF.Lock=PIGCheckbutton(QuickButF,{"LEFT",QuickButF.Open,"RIGHT",130,0},{LOCK_FRAME,LOCK_FOCUS_FRAME})
QuickButF.Lock:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Lock"]=true
	else
		PIGA["QuickBut"]["Lock"]=false;
	end
	QuickButFLock()
end)
--
QuickButF.suofang_t = PIGFontString(QuickButF,{"LEFT",QuickButF.Lock,"RIGHT",110,2},"缩放:")
local xiayiinfo = {0.8,1.4,0.1}
QuickButF.suofang = PIGSlider(QuickButF,{"LEFT",QuickButF.suofang_t,"RIGHT",10,0},{100,14},xiayiinfo)
function QuickButF.suofang:OnValueFun()
	local Hval = self:GetValue()
	local Hval = floor(Hval*10+0.5)*0.1
	self.Text:SetText(Hval);
	PIGA["QuickBut"]["bili"]=Hval;
	QuickButUI:SetScale(Hval);
end
--
local QuickButPoint = {"BOTTOM",UIParent,"BOTTOM",200,200}
QuickButF.CZBUT = PIGButton(QuickButF,{"TOPRIGHT",QuickButF,"TOPRIGHT",-10,-20},{80,24},"重置位置")
QuickButF.CZBUT:SetScript("OnClick", function ()
	if tocversion<100000 then
		QuickButUI:PIGResPoint(QuickButPoint)
	else
		QuickButUI:PIGResPoint(QuickButPoint,-200,90)
	end
end)
QuickButF:HookScript("OnShow", function(self)
	self.Open:SetChecked(PIGA["QuickBut"]["Open"])
	self.Lock:SetChecked(PIGA["QuickBut"]["Lock"])
	self.suofang:PIGSetValue(PIGA["QuickBut"]["bili"])
end)
--
QuickButF.Modline = PIGLine(QuickButF,"TOP",-66)
QuickButF.ModF = PIGFrame(QuickButF)
QuickButF.ModF:SetPoint("TOPLEFT",QuickButF.Modline,"BOTTOMLEFT",0,0);
QuickButF.ModF:SetPoint("BOTTOMRIGHT",QuickButF,"BOTTOMRIGHT",0,30);
local BGbroadcast_tooltip = {string.format(L["ACTION_ADDQUICKBUT"],BATTLEFIELDS..BATTLENET_BROADCAST),string.format(L["ACTION_ADDQUICKBUTTIS"],BATTLEFIELDS..BATTLENET_BROADCAST).."\n注意:战况广播按钮战场外不显示"}
QuickButF.ModF.BGbroadcast=PIGCheckbutton_R(QuickButF.ModF,BGbroadcast_tooltip,true)
QuickButF.ModF.BGbroadcast:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["BGbroadcast"]=true;
		QuickButUI.ButList[2]()
	else
		PIGA["QuickBut"]["BGbroadcast"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end)
local newText=Fun.Delmaohaobiaodain(MODIFIERS_COLON)
local tishineiQKButTrinket = INVTYPE_TRINKET..newText
QuickButF.ModF.QKButTrinket = PIGCheckbutton_R(QuickButF.ModF,{string.format(L["ACTION_ADDQUICKBUT"],tishineiQKButTrinket),string.format(L["ACTION_ADDQUICKBUTTIS"],tishineiQKButTrinket)},true)
QuickButF.ModF.QKButTrinket:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Trinket"]=true
		QuickButUI.ButList[3]()
	else
		PIGA["QuickBut"]["Trinket"]=false
		Pig_Options_RLtishi_UI:Show();
	end
end)
QuickButF.ModF.QKButTrinket_1 = PIGCheckbutton_R(QuickButF.ModF,{nil,nil},true)
QuickButF.ModF.QKButTrinket_1:Hide()
local function TrinketFenli()
	if PIGA["QuickBut"]["TrinketFenli"] then
		QuickButF.ModF.QKButTrinket.Fenli.lock:Enable()
		QuickButF.ModF.QKButTrinket.Fenli.suofang:Enable()
	else
		QuickButF.ModF.QKButTrinket.Fenli.lock:Disable();
		QuickButF.ModF.QKButTrinket.Fenli.suofang:Disable()
	end
end
QuickButF.ModF.QKButTrinket.Fenli = PIGCheckbutton(QuickButF.ModF.QKButTrinket,{"TOPLEFT",QuickButF.ModF.QKButTrinket,"BOTTOMLEFT",30,-16},{UNDOCK_WINDOW,"分离"..INVTYPE_TRINKET..newText..VIDEO_OPTIONS_WINDOWED})
QuickButF.ModF.QKButTrinket.Fenli:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["TrinketFenli"]=true
		Pig_Options_RLtishi_UI:Show();
	else
		PIGA["QuickBut"]["TrinketFenli"]=false
		Pig_Options_RLtishi_UI:Show();
	end
end)
local pailieList = {"横","竖"}
QuickButF.ModF.QKButTrinket.Fenli.pailie=PIGDownMenu(QuickButF.ModF.QKButTrinket.Fenli,{"LEFT",QuickButF.ModF.QKButTrinket.Fenli.Text,"RIGHT",2,0},{46,nil})
function QuickButF.ModF.QKButTrinket.Fenli.pailie:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#pailieList,1 do
	    info.text, info.arg1 = pailieList[i], i
	    info.checked = i==PIGA["QuickBut"]["TrinketFenliPailie"]
		QuickButF.ModF.QKButTrinket.Fenli.pailie:PIGDownMenu_AddButton(info)
	end 
end
function QuickButF.ModF.QKButTrinket.Fenli.pailie:PIGDownMenu_SetValue(value,arg1,arg2)
	QuickButF.ModF.QKButTrinket.Fenli.pailie:PIGDownMenu_SetText(value)
	PIGA["QuickBut"]["TrinketFenliPailie"]=arg1
	if QuickTrinketUI then QuickTrinketUI.UpdataPailie() end
	PIGCloseDropDownMenus()
end
QuickButF.ModF.QKButTrinket.Fenli.lock = PIGCheckbutton(QuickButF.ModF.QKButTrinket.Fenli,{"LEFT",QuickButF.ModF.QKButTrinket.Fenli.pailie,"RIGHT",20,0},{LOCK_FRAME,LOCK_FOCUS_FRAME})
QuickButF.ModF.QKButTrinket.Fenli.lock:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["TrinketFenlilock"]=true
	else
		PIGA["QuickBut"]["TrinketFenlilock"]=false
	end
	if QuickTrinketUI then
		if PIGA["QuickBut"]["TrinketFenlilock"] then
			QuickTrinketUI.yidong:Hide()
		else
			QuickTrinketUI.yidong:Show();
		end
	end
end)
QuickButF.ModF.QKButTrinket.Fenli.suofang_t = PIGFontString(QuickButF.ModF.QKButTrinket.Fenli,{"LEFT",QuickButF.ModF.QKButTrinket.Fenli.lock.Text,"RIGHT",20,2},"缩放:")
local xiayiinfo = {0.8,1.8,0.1}
QuickButF.ModF.QKButTrinket.Fenli.suofang = PIGSlider(QuickButF.ModF.QKButTrinket.Fenli,{"LEFT",QuickButF.ModF.QKButTrinket.Fenli.suofang_t,"RIGHT",10,0},{100,14},xiayiinfo)
function QuickButF.ModF.QKButTrinket.Fenli.suofang:OnValueFun()
	local Hval = self:GetValue()
	local Hval = floor(Hval*10+0.5)*0.1
	self.Text:SetText(Hval);
	PIGA["QuickBut"]["TrinketScale"]=Hval;
	if QuickTrinketUI then QuickTrinketUI:SetScale(Hval) end
end
----
QuickButF.ModF.QKButTrinket.AutoMode = PIGButton(QuickButF.ModF.QKButTrinket,{"LEFT",QuickButF.ModF.QKButTrinket.Text,"RIGHT",30,0},{76,20},SWITCH..MODE);
local TrinkeWW,TrinkeHH = 300,400
local TrinketAutoMode=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,0},{TrinkeWW,TrinkeHH},"TrinketAutoModeUI",true)
TrinketAutoMode:PIGSetBackdrop()
TrinketAutoMode:PIGClose()
TrinketAutoMode:PIGSetMovable()
TrinketAutoMode:Hide()
TrinketAutoMode.t = PIGFontString(TrinketAutoMode,{"TOP",TrinketAutoMode,"TOP",0,-3},INVTYPE_TRINKET..SWITCH..MODE)
TrinketAutoMode.nr=PIGFrame(TrinketAutoMode,{"TOPLEFT",TrinketAutoMode,"TOPLEFT",3,-20})
TrinketAutoMode.nr:SetPoint("BOTTOMRIGHT", TrinketAutoMode, "BOTTOMRIGHT", -3, 3);
TrinketAutoMode.nr:PIGSetBackdrop()
TrinketAutoMode.nr.mode1 = PIGCheckbutton(TrinketAutoMode.nr,{"TOPLEFT",TrinketAutoMode.nr,"TOPLEFT",10,-6},{TRACKER_SORT_MANUAL..MODE})
TrinketAutoMode.nr.mode1:SetScript("OnClick", function (self)
	PIGA_Per["QuickBut"]["TrinketMode"]=1
	TrinketAutoMode:SetCheckbut()
end)
TrinketAutoMode.nr.mode1.F=PIGFrame(TrinketAutoMode.nr.mode1,{"TOPLEFT",TrinketAutoMode.nr,"TOPLEFT",0,-28})
TrinketAutoMode.nr.mode1.F:SetPoint("BOTTOMRIGHT", TrinketAutoMode.nr, "BOTTOMRIGHT", 0, 0);
TrinketAutoMode.nr.mode1.F:Hide()
local tishiNR = "1、此模式下"..INVTYPE_TRINKET..SWITCH..TRACKER_SORT_MANUAL..NPE_CONTROLS..
				"\n\n2、"..LEAVING_COMBAT..":\n"..string.rep(" ", 6)..KEY_BUTTON1..SWITCH.."上"..INVTYPE_TRINKET.."\n"..string.rep(" ", 6)..KEY_BUTTON2..SWITCH.."下"..INVTYPE_TRINKET..
				"\n\n3、"..AT_WAR.."点击加入队列,\n"..string.rep(" ", 6)..LEAVING_COMBAT..SWITCH..INVTYPE_TRINKET..
				"\n\n4、"..KEY_BUTTON2.."取消队列中饰品"
TrinketAutoMode.nr.mode1.F.tip = PIGFontString(TrinketAutoMode.nr.mode1.F,{"TOPLEFT",TrinketAutoMode.nr.mode1.F,"TOPLEFT",10,-13},tishiNR)
TrinketAutoMode.nr.mode1.F.tip:SetJustifyH("LEFT")
TrinketAutoMode.nr.mode2 = PIGCheckbutton(TrinketAutoMode.nr,{"LEFT",TrinketAutoMode.nr.mode1.Text,"RIGHT",10,0},{SELF_CAST_AUTO..MODE})
TrinketAutoMode.nr.mode2:SetScript("OnClick", function (self)
	PIGA_Per["QuickBut"]["TrinketMode"]=2
	TrinketAutoMode:SetCheckbut()
end)
TrinketAutoMode.nr.mode2.F=PIGFrame(TrinketAutoMode.nr.mode2,{"TOPLEFT",TrinketAutoMode.nr,"TOPLEFT",0,-28})
TrinketAutoMode.nr.mode2.F:SetPoint("BOTTOMRIGHT", TrinketAutoMode.nr, "BOTTOMRIGHT", 0, 0);
TrinketAutoMode.nr.mode2.F:Hide()
TrinketAutoMode.nr.mode2.F.tip = PIGFontString(TrinketAutoMode.nr.mode2.F,{"TOPLEFT",TrinketAutoMode.nr.mode2.F,"TOPLEFT",10,-4},"点击"..CHAT_JOIN..SELF_CAST_AUTO..SWITCH..SOCIAL_QUEUE_TOOLTIP_HEADER.."(CD后脱战切换)")
local hang_Height,hang_NUM  = 26.4, 12;
TrinketAutoMode.nr.mode2.F.S=PIGFrame(TrinketAutoMode.nr.mode2.F,{"TOPLEFT",TrinketAutoMode.nr.mode2.F,"TOPLEFT",4,-24})
TrinketAutoMode.nr.mode2.F.S:PIGSetBackdrop()
TrinketAutoMode.nr.mode2.F.S:SetPoint("TOPLEFT",TrinketAutoMode.nr.mode2.F,"TOPLEFT",4,-24);
TrinketAutoMode.nr.mode2.F.S:SetPoint("BOTTOMRIGHT",TrinketAutoMode.nr.mode2.F,"BOTTOMRIGHT",-17,5);
TrinketAutoMode.nr.mode2.F.S.Scroll = CreateFrame("ScrollFrame",nil,TrinketAutoMode.nr.mode2.F.S, "FauxScrollFrameTemplate");  
TrinketAutoMode.nr.mode2.F.S.Scroll:SetPoint("TOPLEFT",TrinketAutoMode.nr.mode2.F.S,"TOPLEFT",0,0);
TrinketAutoMode.nr.mode2.F.S.Scroll:SetPoint("BOTTOMRIGHT",TrinketAutoMode.nr.mode2.F.S,"BOTTOMRIGHT",-3,0);
TrinketAutoMode.nr.mode2.F.S.Scroll.ScrollBar:SetScale(0.8);
TrinketAutoMode.nr.mode2.F.S.Scroll:SetScript("OnVerticalScroll", function(self, offset)
    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, TrinketAutoMode.nr.mode2.F.S.gengxinhang)
end)
local function add_updwonbut(fujiUI,Normal,Pushed,Disabled)
	local but = CreateFrame("Button",nil,fujiUI, "TruncatedButtonTemplate");
	but:SetNormalTexture(Normal)
	but:SetPushedTexture(Pushed)
	but:SetDisabledTexture(Disabled)
	but:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
	but:SetSize(hang_Height-8,hang_Height-2);
	but:GetNormalTexture():SetPoint("TOPLEFT", but, "TOPLEFT", -4,4);
	but:GetNormalTexture():SetPoint("BOTTOMRIGHT", but, "BOTTOMRIGHT", 4,-4);
	but:GetPushedTexture():SetPoint("TOPLEFT", but, "TOPLEFT", -4,4);
	but:GetPushedTexture():SetPoint("BOTTOMRIGHT", but, "BOTTOMRIGHT", 4,-4);
	but:GetDisabledTexture():SetPoint("TOPLEFT", but, "TOPLEFT", -4,4);
	but:GetDisabledTexture():SetPoint("BOTTOMRIGHT", but, "BOTTOMRIGHT", 4,-4);
	return but
end
local Data=addonTable.Data
local bagID=Data.bagData["bagID"]
local GetContainerItemLink = C_Container.GetContainerItemLink
local function GET13_14item(dangqianData,invSlotId)
	local itemID= GetInventoryItemID("player", invSlotId)
	if itemID then
		local ItemLink= GetInventoryItemLink("player", invSlotId)
		local icon= GetInventoryItemTexture("player", invSlotId)
		table.insert(dangqianData,{icon,itemID,ItemLink})
	end
end
local function GET_shipinxuanzhongL()
	TrinketAutoMode.TrinketMode=PIGA_Per["QuickBut"]["TrinketMode"]
	local dangqianData = {}
	GET13_14item(dangqianData,13)
	GET13_14item(dangqianData,14)
	for bag=1,#bagID do
		for slot = 1, C_Container.GetContainerNumSlots(bagID[bag]) do
			local ItemLink = GetContainerItemLink(bagID[bag], slot);
			if ItemLink then
				local itemID, itemType, itemSubType, itemEquipLoc, icon= GetItemInfoInstant(ItemLink)
				if itemEquipLoc=="INVTYPE_TRINKET" then
					table.insert(dangqianData,{icon,itemID,ItemLink})
				end
			end
		end
	end
	local NewData = {{},{}}
	for i=1,#PIGA_Per["QuickBut"]["TrinketList"] do
		for ii=#dangqianData,1,-1 do
			if dangqianData[ii][2]==PIGA_Per["QuickBut"]["TrinketList"][i] then
				table.insert(NewData[1],dangqianData[ii][2])
				table.insert(NewData[2],dangqianData[ii])
				table.remove(dangqianData,ii)
			end
		end
	end
	PIGA_Per["QuickBut"]["TrinketList"]=NewData[1]
	TrinketAutoModeUI.NextList=NewData[1]
	return NewData[1],NewData[2],dangqianData
end
TrinketAutoModeUI.GET_shipinxuanzhongL=GET_shipinxuanzhongL
local function SET_xuelie_UPdwan(itemID,caozuo)
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
	TrinketAutoMode.nr.mode2.F.S.gengxinhang(TrinketAutoMode.nr.mode2.F.S.Scroll)
end
for id = 1, hang_NUM do
	local hang = CreateFrame("Button", "TrinketAutohang_"..id, TrinketAutoMode.nr.mode2.F.S,nil,id);
	hang:SetSize(TrinkeWW-70, hang_Height);
	if id==1 then
		hang:SetPoint("TOPLEFT",TrinketAutoMode.nr.mode2.F.S.Scroll,"TOPLEFT",0,-1);
	else
		hang:SetPoint("TOP",_G["TrinketAutohang_"..(id-1)],"BOTTOM",0,0);
	end
	if id~=hang_NUM then
		PIGLine(hang,"BOT",nil,nil,{2,40},{0.3,0.3,0.3,0.5})
	end
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
		GameTooltip:SetHyperlink(self.linkD)
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
				TrinketAutoMode.nr.mode2.F.S.gengxinhang(TrinketAutoMode.nr.mode2.F.S.Scroll)
				return
			end
		end
		table.insert(PIGA_Per["QuickBut"]["TrinketList"],self.itemID)
		TrinketAutoMode.nr.mode2.F.S.gengxinhang(TrinketAutoMode.nr.mode2.F.S.Scroll)
	end);
	hang.UP = add_updwonbut(hang,130857,130855,130854)
	hang.UP:SetPoint("LEFT", hang, "RIGHT", 0,0);
	hang.UP:SetScript("OnClick", function (self)
		local fujik = self:GetParent()
		SET_xuelie_UPdwan(fujik.itemID,"-")
	end);
	hang.DOWN = add_updwonbut(hang,130853,130851,130850)
	hang.DOWN:SetPoint("LEFT", hang.UP, "RIGHT", 0,0);
	hang.DOWN:SetScript("OnClick", function (self)
		local fujik = self:GetParent()
		SET_xuelie_UPdwan(fujik.itemID,"+")
	end);
end
function TrinketAutoMode.nr.mode2.F.S.gengxinhang(self)
	if not TrinketAutoMode.nr.mode2.F.S:IsVisible() then return end
	local Scroll = self
	for id = 1, hang_NUM do
		_G["TrinketAutohang_"..id]:Hide();
    end
	local TrinketMode,yixuanzhong,baguodata =GET_shipinxuanzhongL()
	local bagshujuy={}
	local duilieNUM = #yixuanzhong
	for i=1,duilieNUM do
		table.insert(bagshujuy,yixuanzhong[i])
	end
	for i=1,#baguodata do
		table.insert(bagshujuy,baguodata[i])
	end
	local ItemsNum = #bagshujuy;
    FauxScrollFrame_Update(Scroll, ItemsNum, hang_NUM, hang_Height);
    local offset = FauxScrollFrame_GetOffset(Scroll);
    for id = 1, hang_NUM do
    	local dangqianH = id+offset;
    	if bagshujuy[dangqianH] then
    		local hang = _G["TrinketAutohang_"..id]
    		hang:Show();
	    	hang.icon:SetTexture(bagshujuy[dangqianH][1]);
			hang.link:SetText(bagshujuy[dangqianH][3]);
			hang.linkD=bagshujuy[dangqianH][3]
			hang.itemID=bagshujuy[dangqianH][2]
			if dangqianH<=duilieNUM then
				hang.icon:SetDesaturated(false)
				hang.check:Show()
				hang.UP:Show()
				hang.DOWN:Show()
				if dangqianH==1 then
	    			hang.UP:Disable()
	    		else
	    			hang.UP:Enable()
	    		end
	    		if dangqianH==duilieNUM then
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
TrinketAutoMode.nr.mode2.F:SetScript("OnShow", function (self)
	self.S.gengxinhang(self.S.Scroll)
end)
---
TrinketAutoMode:SetScript("OnShow", function (self)
	TrinketAutoMode:SetCheckbut()
end)
function TrinketAutoMode:SetCheckbut()
	if not TrinketAutoMode:IsShown() then return end
	TrinketAutoMode.nr.mode1:SetChecked(false)
	TrinketAutoMode.nr.mode2:SetChecked(false)
	TrinketAutoMode.nr.mode1.F:Hide()
	TrinketAutoMode.nr.mode2.F:Hide()
	if PIGA_Per["QuickBut"]["TrinketMode"]==1 then
		TrinketAutoMode.nr.mode1:SetChecked(true)
		TrinketAutoMode.nr.mode1.F:Show()
	elseif PIGA_Per["QuickBut"]["TrinketMode"]==2 then
		TrinketAutoMode.nr.mode2:SetChecked(true)
		TrinketAutoMode.nr.mode2.F:Show()
	end
	TrinketAutoMode.TrinketMode=PIGA_Per["QuickBut"]["TrinketMode"]
	if PIGA["QuickBut"]["TrinketFenli"] then
		TrinketAutoMode:SetyidongButText(QuickTrinketUI.yidong)
	else
		TrinketAutoMode:SetyidongButText(QuickButUI.yidong)
	end
end
function TrinketAutoMode:SetyidongButText(yidongUI)
	if PIGA_Per["QuickBut"]["TrinketMode"]==1 then
		yidongUI.t:SetText(TRACKER_SORT_MANUAL)
		yidongUI.t:SetTextColor(0.8, 0.8, 0.8, 0.8)
	elseif PIGA_Per["QuickBut"]["TrinketMode"]==2 then
		yidongUI.t:SetText(SELF_CAST_AUTO)
		yidongUI.t:SetTextColor(0.1, 0.8, 0.8, 0.9)
	end
end
function TrinketAutoMode:yidongButClick(yidongUI,Button)
	if Button=="LeftButton" then
		if PIGA_Per["QuickBut"]["TrinketMode"]==1 then
			PIGA_Per["QuickBut"]["TrinketMode"]=2
			TrinketAutoModeUI.TrinketMode=2
			PIGinfotip:TryDisplayMessage(TRACKER_SORT_MANUAL..MODE, YELLOW_FONT_COLOR:GetRGB())
		elseif PIGA_Per["QuickBut"]["TrinketMode"]==2 then
			PIGA_Per["QuickBut"]["TrinketMode"]=1
			TrinketAutoMode.TrinketMode=1
			PIGinfotip:TryDisplayMessage(SELF_CAST_AUTO..MODE, YELLOW_FONT_COLOR:GetRGB())
		end
		TrinketAutoMode:SetyidongButText(yidongUI)
		TrinketAutoMode:SetCheckbut()
	else
		if IsShiftKeyDown() then
			QuickButUI:yidongRightBut()
		else
			if TrinketAutoMode:IsShown() then
				TrinketAutoMode:Hide()
			else
				TrinketAutoMode:Show()
			end
		end
	end
end
QuickButF.ModF.QKButTrinket.AutoMode:SetScript("OnClick", function (self)
	if TrinketAutoMode:IsShown() then
		TrinketAutoMode:Hide()
	else
		Pig_OptionsUI:Hide()
		TrinketAutoMode:Show()
	end
end)
--
if tocversion<20000 and C_Engraving and C_Engraving.IsEngravingEnabled() then
	QuickButF.ModF.QKButRune = PIGCheckbutton_R(QuickButF.ModF,{string.format(L["ACTION_ADDQUICKBUT"],RUNES..newText),string.format(L["ACTION_ADDQUICKBUTTIS"],RUNES..newText)},true)
	QuickButF.ModF.QKButRune:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["QuickBut"]["Rune"]=true
			QuickButUI.ButList[4]()
		else
			PIGA["QuickBut"]["Rune"]=false
			Pig_Options_RLtishi_UI:Show();
		end
	end)
	QuickButF.ModF.QKButRune.RuneShow = PIGCheckbutton(QuickButF.ModF.QKButRune,{"LEFT",QuickButF.ModF.QKButRune.Text,"RIGHT",20,0},{SHOW.."当前使用的符文"})
	QuickButF.ModF.QKButRune.RuneShow:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["QuickBut"]["RuneShow"]=true
			if AutoRuneListUI then AutoRuneListUI:GetParent():UpDatePoints(true) end
		else
			PIGA["QuickBut"]["RuneShow"]=false
			if AutoRuneListUI then AutoRuneListUI:Hide() end
		end
	end)
end
----
QuickButF.ModF.QKButEquip = PIGCheckbutton_R(QuickButF.ModF,{string.format(L["ACTION_ADDQUICKBUT"],EQUIPMENT_MANAGER),string.format(L["ACTION_ADDQUICKBUTTIS"],EQUIPMENT_MANAGER)},true)
QuickButF.ModF.QKButEquip:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Equip"]=true
		QuickButUI.ButList[5]()
	else
		PIGA["QuickBut"]["Equip"]=false
		Pig_Options_RLtishi_UI:Show();
	end
end)
local Lushi_tooltip = {string.format(L["ACTION_ADDQUICKBUT"],TUTORIAL_TITLE31.."/"..TRADE_SKILLS),string.format(L["ACTION_ADDQUICKBUTTIS"],TUTORIAL_TITLE31.."/"..TRADE_SKILLS)}
QuickButF.ModF.Lushi=PIGCheckbutton_R(QuickButF.ModF,Lushi_tooltip,true)
QuickButF.ModF.Lushi:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Lushi"]=true;
		QuickButUI.ButList[6]()
	else
		PIGA["QuickBut"]["Lushi"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end)
QuickButF.ModF.Spell=PIGCheckbutton_R(QuickButF.ModF,{string.format(L["ACTION_ADDQUICKBUT"],CLASS..BINDING_HEADER_ACTIONBAR),string.format(L["ACTION_ADDQUICKBUTTIS"],CLASS..BINDING_HEADER_ACTIONBAR)},true)
QuickButF.ModF.Spell:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["QuickBut"]["Spell"]=true;
		QuickButUI.ButList[7]()
	else
		PIGA["QuickBut"]["Spell"]=false;
		Pig_Options_RLtishi_UI:Show()
	end
end)
QuickButF.ModF:HookScript("OnShow", function(self)
	self.Lushi:SetChecked(PIGA["QuickBut"]["Lushi"])
	self.Spell:SetChecked(PIGA["QuickBut"]["Spell"])
	self.BGbroadcast:SetChecked(PIGA["QuickBut"]["BGbroadcast"])
	if self.QKButRune then
		self.QKButRune:SetChecked(PIGA["QuickBut"]["Rune"])
		self.QKButRune.RuneShow:SetChecked(PIGA["QuickBut"]["RuneShow"])
	end
	self.QKButEquip:SetChecked(PIGA["QuickBut"]["Equip"])
	self.QKButTrinket:SetChecked(PIGA["QuickBut"]["Trinket"])
	self.QKButTrinket.Fenli:SetChecked(PIGA["QuickBut"]["TrinketFenli"])
	self.QKButTrinket.Fenli.pailie:PIGDownMenu_SetText(pailieList[PIGA["QuickBut"]["TrinketFenliPailie"]])
	self.QKButTrinket.Fenli.lock:SetChecked(PIGA["QuickBut"]["TrinketFenlilock"])
	self.QKButTrinket.Fenli.suofang:PIGSetValue(PIGA["QuickBut"]["TrinketScale"])
	TrinketFenli()
end)
QuickButF.ModF.CZBUT = PIGButton(QuickButF.ModF,{"BOTTOMLEFT",QuickButF.ModF,"BOTTOMLEFT",20,-20},{76,20},"重置配置");  
QuickButF.ModF.CZBUT:SetScript("OnClick", function ()
	StaticPopup_Show ("CHONGZHI_QUICKBUT");
end);
StaticPopupDialogs["CHONGZHI_QUICKBUT"] = {
	text = "此操作将|cffff0000重置|r"..L["ACTION_TABNAME2"].."配置。\n确定重置?",
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		PIGA["QuickBut"] = addonTable.Default["QuickBut"];
		PIGA_Per["QuickBut"] = addonTable.Default_Per["QuickBut"];
		Pig_Options_RLtishi_UI:Show()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}
---
QuickButUI.ButList[1]=function()
	if not PIGA["QuickBut"]["Open"] or QuickButUI.yidong then
		return
	end
	QuickButUI:SetPoint(unpack(QuickButPoint))
	QuickButUI:SetScale(PIGA["QuickBut"]["bili"]);
	QuickButUI.yidong=PIGFrame(QuickButUI,{"TOPLEFT",QuickButUI,"TOPLEFT",0,0})
	QuickButUI.yidong:SetPoint("BOTTOMLEFT", QuickButUI, "BOTTOMLEFT", 0, 0);
	QuickButUI.yidong:SetWidth(13);
	if PIGA["QuickBut"]["Lock"] then
		QuickButUI.yidong:Hide()
	end
	QuickButUI.yidong:PIGSetBackdrop()
	QuickButUI.yidong:PIGSetMovable(QuickButUI)
	function QuickButUI:yidongRightBut()
		if Pig_OptionsUI:IsShown() then
			Pig_OptionsUI:Hide()
		else
			Pig_OptionsUI:Show()
			Create.Show_TabBut(fuFrame,fuFrameBut)
			Create.Show_TabBut_R(RTabFrame,QuickButF,QuickButTabBut)
		end
	end
	QuickButUI.yidong:SetScript("OnMouseUp", function (self,Button)
		if PIGA["QuickBut"]["Trinket"] and not PIGA["QuickBut"]["TrinketFenli"] then
			TrinketAutoModeUI:yidongButClick(self,Button)
		else
			if Button=="RightButton" then QuickButUI:yidongRightBut() end
		end
	end);
	QuickButUI.yidong:SetScript("OnEnter", function (self)
		self:SetBackdropBorderColor(0,0.8,1, 0.9);
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
		if PIGA["QuickBut"]["Trinket"] and not PIGA["QuickBut"]["TrinketFenli"] then
			GameTooltip:AddLine(KEY_BUTTON1.."-|cff00FFff"..SWITCH..MODE.."|r\n"..KEY_BUTTON2.."-|cff00FFff"..SETTINGS..MODE.."|r\nShift+"..KEY_BUTTON2.."-|cff00FFff"..SETTINGS.."|r\n"..KEY_BUTTON1.."拖拽-|cff00FFff"..TUTORIAL_TITLE2.."|r")
		else
			GameTooltip:AddLine(KEY_BUTTON1.."-|cff00FFff"..TUTORIAL_TITLE2.."|r,"..KEY_BUTTON2.."-|cff00FFff"..SETTINGS.."|r")	
		end
		GameTooltip:Show();
	end);
	QuickButUI.yidong:SetScript("OnLeave", function (self)
		self:SetBackdropBorderColor(0, 0, 0, 1);
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end)
	QuickButUI.yidong.t = PIGFontString(QuickButUI.yidong,nil,"拖\n动",nil,9)
	QuickButUI.yidong.t:SetAllPoints(QuickButUI.yidong)
	QuickButUI.yidong.t:SetTextColor(0.8, 0.8, 0.8, 0.8)
	if not PIGA["QuickBut"]["TrinketFenli"] then TrinketAutoModeUI:SetyidongButText(QuickButUI.yidong) end
	QuickButUI.nr=PIGFrame(QuickButUI,{"TOPLEFT",QuickButUI.yidong,"TOPRIGHT",1,0})
	QuickButUI.nr:PIGSetBackdrop()
	QuickButUI.nr:SetPoint("BOTTOMRIGHT", QuickButUI, "BOTTOMRIGHT", 0, 0);
end
--战场通告
QuickButUI.ButList[2]=function()
	if PIGA["QuickBut"]["Open"] and PIGA["QuickBut"]["BGbroadcast"] then
		local GnUI = "BGbroadcast_UI"
		if _G[GnUI] then return end
		local GnIcon="interface/battlefieldframe/battleground-alliance.blp"
		local englishFaction, _ = UnitFactionGroup("player")
		--if englishFaction=="Alliance" then
		if englishFaction=="Horde" then
			GnIcon="interface/battlefieldframe/battleground-horde.blp"
		end	
		-- 
		local Tooltip = KEY_BUTTON1.."-|cff00FFFF通报当前位置来犯人,(来几人就点几次)\r|r"..KEY_BUTTON2.."-|cff00FFFF报告位置安全|r"
		local BGanniu=PIGQuickBut(GnUI,Tooltip,GnIcon)
		
		BGanniu:RegisterEvent("PLAYER_ENTERING_WORLD")
		BGanniu:HookScript("OnEvent", function (self, event)
			if event=="PLAYER_ENTERING_WORLD" then
				local inInstance, instanceType =IsInInstance()
				if instanceType=="pvp" then
					BGanniu.yincang=nil
				else
					BGanniu.yincang=true
				end
				QuickButUI:GengxinWidth()
			end
		end)
		BGanniu:SetScript("OnClick", function (self, event)
			local inInstance, instanceType = IsInInstance();
			if instanceType=="pvp" then
				if event=="RightButton" then
					SendChatMessage(GetMinimapZoneText().."已安全，机动人员请机动支援！", "instance_chat") 
				else
					if not direnshuliangpig or not hanhuaTimejiange or GetTime()-hanhuaTimejiange>10 then
						direnshuliangpig=0;
					end;
					hanhuaTimejiange=GetTime(); direnshuliangpig=direnshuliangpig+1; SendChatMessage(GetMinimapZoneText().."有"..direnshuliangpig.."个敌人来袭，请求支援！", "instance_chat"); 
				end
			else
				PIGinfotip:TryDisplayMessage("请在战场内使用")
			end
		end);
	end
end
--炉石专业按钮----
QuickButUI.ButList[6]=function()
	if PIGA["QuickBut"]["Open"] and PIGA["QuickBut"]["Lushi"] then
		local GnUI = "General_UI"
		if _G[GnUI] then return end
		local Icon=134414
		local Tooltip = KEY_BUTTON1.."-|cff00FFFF使用炉石\r|r"..KEY_BUTTON2.."-|cff00FFFF专业技能|r"
		local General=PIGQuickBut(GnUI,Tooltip,Icon,nil,nil,"SecureActionButtonTemplate")
		PIGUseKeyDown(General)
		General.Cooldown = CreateFrame("Frame", nil, General);
		General.Cooldown:SetAllPoints()
		General.Cooldown.N = CreateFrame("Cooldown", nil, General.Cooldown, "CooldownFrameTemplate")
		General.Cooldown.N:SetAllPoints()

		General.START = General:CreateTexture(nil, "OVERLAY");
		General.START:SetTexture(130724);
		General.START:SetBlendMode("ADD");
		General.START:SetAllPoints(General)
		General.START:Hide();

		local GetItemCount=GetItemCount or C_Item and C_Item.GetItemCount
		local IsUsableSpell=IsUsableSpell or C_Spell and C_Spell.IsSpellUsable
		local GetItemCooldown=C_Container.GetItemCooldown
		local function gengxinlushiCD()
			if General.lushiitemID then
				local start, duration= GetItemCooldown(General.lushiitemID)
				if start and duration then
		 			General.Cooldown.N:SetCooldown(start, duration);
		 		end
		 	end
	 	end
	 	local function add_skilldata(buttt,Skill_List,spellID,spellName)
	 		for x=1, #Skill_List do
				if spellName==Skill_List[x] then
					buttt:SetAttribute("type2", "spell");
					buttt:SetAttribute("spell", spellID);
					return true
				end
			end
			return false
		end
		local lushiList = {184871}--玩具
		local function PIGPlayerHasHearthstone()
			for i=1,#lushiList do
				local HasToy = PlayerHasToy(lushiList[i])
				if HasToy then
					return lushiList[i]
				end
			end
			return 6948
		end
		local function Skill_Button_Genxin()
			if InCombatLockdown() then return end
			local lushiitemID = PIGPlayerHasHearthstone()
			local lushiName, SpellID = GetItemSpell(lushiitemID)
			if lushiName and SpellID then
				General.lushiitemID=lushiitemID
				General.lushiSpellID=SpellID
				General:SetAttribute("type1", "item");
				General:SetAttribute("item", lushiName);
				General:SetNormalTexture(GetItemIcon(lushiitemID))
				gengxinlushiCD()
			end
			local Skill_List = addonTable.FramePlusfun.Skill_List
			if tocversion<50000 then
				local _, _, tabOffset, numEntries = GetSpellTabInfo(1)
				for j=tabOffset + 1, tabOffset + numEntries do
					local spellName, _ ,spellID=GetSpellBookItemName(j, PIGbookType)
					if add_skilldata(General,Skill_List,spellID,spellName) then return end
				end
			else
				for _, i in pairs{GetProfessions()} do
					local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(i)
					local offset, numSlots = skillLineInfo.itemIndexOffset, skillLineInfo.numSpellBookItems
					for j = offset+1, offset+numSlots do
						local name = C_SpellBook.GetSpellBookItemName(j, Enum.SpellBookSpellBank.Player)
						local spellID = select(2,C_SpellBook.GetSpellBookItemType(j, Enum.SpellBookSpellBank.Player))
						if add_skilldata(General,Skill_List,spellID,name) then return end
					end
				end
			end
		end
		General.lushijisuq=0
		Skill_Button_Genxin()
		General:RegisterUnitEvent("UNIT_SPELLCAST_START","player");
		General:RegisterUnitEvent("UNIT_SPELLCAST_STOP","player");
		General:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		General:SetScript("OnEvent", function(self,event,arg1,_,arg3)
			if arg3==self.lushiSpellID then 
				if event=="UNIT_SPELLCAST_START" then
			 		self.START:Show();
			 	end
			 	if event=="UNIT_SPELLCAST_STOP" then
			 		self.START:Hide();
				end	
		 	end
			if event=="SPELL_UPDATE_COOLDOWN" then
				C_Timer.After(0.01, gengxinlushiCD);
			end
		end)	
	end
end
--职业技能----
local Item_Spell_List ={{},{}}
if tocversion<50000 then
	Item_Spell_List[1] ={18984,18986,7148,18587,18232,18660};--空间撕裂器-永望镇/安全传送器-加基森/起搏器/起搏器XL
	local _, classId = UnitClassBase("player");--1战士/2圣骑士/3猎人/4盗贼/5牧师/6死亡骑士/7萨满祭司/8法师/9术士/10武僧/11德鲁伊/12恶魔猎手
	if classId==3 then --3猎人
		Item_Spell_List[2] ={1002,6197,982,2641,1462,1515,883};
		if tocversion>30000 then
			table.insert(Item_Spell_List[2],62757);	
		else
			table.insert(Item_Spell_List[2],5149);
		end
	elseif classId==4 then--盗贼
		Item_Spell_List[2] ={2842};
	elseif classId==8 then --法师
		local englishFaction, _ = UnitFactionGroup("player")
		if englishFaction=="Alliance" then
			Item_Spell_List[2] ={3561,10059,3562,11416,3565,11419};			
		elseif englishFaction=="Horde" then
			Item_Spell_List[2] ={3567,11417,3566,11420,3563,11418};
		end
		if tocversion>20000 then
			if englishFaction=="Alliance" then
				local tbcchuansong = {32271,32266,49359,49360,33690,33691};	
				for ik=1,#tbcchuansong do
					table.insert(Item_Spell_List[2],tbcchuansong[ik]);			
				end
			elseif englishFaction=="Horde" then
				local tbcchuansong = {32272,32267,49358,49361,35715,35717};
				for ik=1,#tbcchuansong do
					table.insert(Item_Spell_List[2],tbcchuansong[ik]);			
				end
			end
		end
		if tocversion>30000 then
			local tbcchuansong ={53140,53142};
			for ik=1,#tbcchuansong do
				table.insert(Item_Spell_List[2],tbcchuansong[ik]);			
			end			
		end
	else

	end
	for i=1,#Item_Spell_List[1] do
		local item = Item:CreateFromItemID(Item_Spell_List[1][i])
		item:ContinueOnItemLoad(function()
			local Link = item:GetItemLink()
		end)
	end
end
local PIGCloseBut=Create.PIGCloseBut
QuickButUI.ButList[7]=function()
	local PigMacroEventCount_QK =0;
	local PigMacroDeleted_QK = false;
	local PigMacroCount_QK=0
	if PIGA["QuickBut"]["Open"] and PIGA["QuickBut"]["Spell"] then
		local GnUI = "Zhushou_UI"
		if _G[GnUI] then return end
		local Icon,ActionID=131146, 400
		local wupinlinrongqi = {}
		local wupinlinrongqicishunum = 0
		local function GetItemInfo_xa_1()
			for i=1,#Item_Spell_List[1] do
				local itemName,itemLink = GetItemInfo(Item_Spell_List[1][i])
				wupinlinrongqi[i]=itemLink
			end
		end
		local function GetItemInfo_xa_2()
			for i=1,#wupinlinrongqi do
				local butid = ActionID+i
				local itemLink=wupinlinrongqi[i]
				if itemLink and not PIGA_Per["QuickBut"]["ActionData"][butid] then
					PIGA_Per["QuickBut"]["ActionData"][butid]={"item",itemLink,Item_Spell_List[1][i]}
				end
			end
		end
		local function GetItemInfo_xa()
			GetItemInfo_xa_1()
			for i=1,#wupinlinrongqi do
				if not wupinlinrongqi[i] and wupinlinrongqicishunum<10 then
					wupinlinrongqicishunum=wupinlinrongqicishunum+1
					return C_Timer.After(0.1,GetItemInfo_xa_1)
				end
			end
			if not InCombatLockdown() then GetItemInfo_xa_2() end
		end
		GetItemInfo_xa()
		local Itemnum = #Item_Spell_List[1]
		for i=1,#Item_Spell_List[2] do
			local butid = ActionID+i+Itemnum
			if not PIGA_Per["QuickBut"]["ActionData"][butid] then
				PIGA_Per["QuickBut"]["ActionData"][butid]={"spell",Item_Spell_List[2][i]}
			end
		end
		local Tooltip = KEY_BUTTON1.."-|cff00FFFF展开职业辅助技能栏|r\n"..KEY_BUTTON2.."-|cff00FFFF打开Recount/Details插件记录面板|r"
		local Zhushou=PIGQuickBut(GnUI,Tooltip,Icon,nil,nil,"SecureHandlerClickTemplate")
		Zhushou.Close = Zhushou:CreateTexture(nil,"ARTWORK");
		Zhushou.Close:SetDrawLayer("ARTWORK", 7)
		if tocversion<50000 then
			Zhushou.Close:SetTexture("interface/buttons/jumpuparrow.blp");
			Zhushou.Close:SetSize(16,18);
			Zhushou.Close:SetPoint("RIGHT",1.4,0);
		else
			Zhushou.Close:SetAtlas("UI-HUD-ActionBar-Flyout-Mouseover");
			Zhushou.Close:SetSize(16,8);
			Zhushou.Close:SetPoint("TOP",0,0);
		end
		local IconTEX=Zhushou:GetNormalTexture()
		local IconCoord = CLASS_ICON_TCOORDS[select(2,UnitClass("player"))];
		IconTEX:SetTexCoord(unpack(IconCoord));
		---内容页----
		local butW = ActionButton1:GetWidth()
		local gaoNum,kuanNum = 10,2
		local Zhushou_List = CreateFrame("Frame", "Zhushou_List_UI", UIParent,"BackdropTemplate,SecureHandlerShowHideTemplate");
		Zhushou_List:SetBackdrop(Create.Backdropinfo)
		Zhushou_List:SetBackdropColor(Create.BackdropColor[1], Create.BackdropColor[2], Create.BackdropColor[3], Create.BackdropColor[4]);
		Zhushou_List:SetBackdropBorderColor(Create.BackdropBorderColor[1], Create.BackdropBorderColor[2], Create.BackdropBorderColor[3], Create.BackdropBorderColor[4]);
		Zhushou_List:SetSize((butW+6)*kuanNum+6,(butW+6)*gaoNum+6);
		Zhushou_List:SetScale(PIGA["QuickBut"]["bili"]);
		Zhushou_List:Hide();
		Zhushou_List:SetFrameLevel(33)
		Zhushou_List:SetScale(0.8)
		--
		local WowHeight=GetScreenHeight();
		local offset = Zhushou:GetBottom();
		Zhushou_List:ClearAllPoints()
		if offset>(WowHeight*0.5) then
			Zhushou_List:SetPoint("TOP", Zhushou, "BOTTOM", 0, -4);
		else
			Zhushou_List:SetPoint("BOTTOM", Zhushou, "TOP", 0, 4);
		end
		--
		Zhushou_List:HookScript("OnShow",function(self)
			SetClampedTextureRotation(Zhushou.Close,180);
		end)
		Zhushou_List:HookScript("OnHide",function(self)
			SetClampedTextureRotation(Zhushou.Close,0);
		end)
		Zhushou:SetAttribute("_onclick",[=[
			if button == "LeftButton" then
				local ref=self:GetFrameRef("frame1")
				if ref:IsShown() then
					ref:Hide();
				else
					ref:Show();
				end
			end
		]=])
		Zhushou:RegisterForClicks("AnyUp");
		Zhushou:SetFrameRef("frame1", Zhushou_List);
		Zhushou:HookScript("OnClick",function(self,button)
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
			if button == "RightButton" then
				if Recount then
					if Recount.MainWindow:IsShown() then
						Recount.MainWindow:Hide()
					else
						Recount.MainWindow:Show()
						Recount:RefreshMainWindow()
					end
				elseif DetailsBaseFrame1 then
					for i=1,10 do
						if not _G["DetailsBaseFrame"..i] then break end
						if _G["DetailsBaseFrame"..i]:IsShown() then
							_G["DetailsBaseFrame"..i]:Hide()
						else
							_G["DetailsBaseFrame"..i]:Show()
						end
					end
				else
					PIGinfotip:TryDisplayMessage("未安装Recount/Details");
				end
			end
		end)
		---
		for i=1,gaoNum*kuanNum do
			local zhushoubut = CreateFrame("CheckButton", "Zhushou_List_"..i, Zhushou_List, "SecureActionButtonTemplate,ActionButtonTemplate,SecureHandlerDragTemplate,SecureHandlerMouseUpDownTemplate")
			zhushoubut:SetSize(butW, butW)
			zhushoubut.NormalTexture:SetAlpha(0.4);
			zhushoubut.cooldown:SetSwipeColor(0, 0, 0, 0.8);
			if i==1 then
				zhushoubut:SetPoint("BOTTOMLEFT",Zhushou_List,"BOTTOMLEFT",6,6);
			else
				local num1,num2=math.modf(i/2)
				if num2~=0 then
					zhushoubut:SetPoint("BOTTOMLEFT",_G["Zhushou_List_"..(i-2)],"TOPLEFT",0,6);
				else
					zhushoubut:SetPoint("LEFT",_G["Zhushou_List_"..(i-1)],"RIGHT",6,0);
				end
			end
	 		local ActionID = ActionID+i
	 		zhushoubut.action=ActionID
			zhushoubut:SetAttribute("action", ActionID)
			--
			PIGUseKeyDown(zhushoubut)
			loadingButInfo(zhushoubut,"QuickBut")
			--
			zhushoubut:HookScript("PostClick", function(self)
				Update_PostClick(self)
			end);
			zhushoubut:HookScript("OnShow", function (self)
				Update_Icon(self)
				Update_Cooldown(self)
				Update_Count(self)
				Update_bukeyong(self)
			end)
			--
			zhushoubut:HookScript("OnMouseUp", function (self)
				Cursor_Fun(self,"OnMouseUp","QuickBut")
				Update_Icon(self)
				Update_Cooldown(self)
				Update_Count(self)
			end);
			----
			zhushoubut:SetAttribute("_ondragstart",[=[
				self:SetAttribute("type", nil)
			]=])
			zhushoubut:HookScript("OnDragStart", function (self)
				Cursor_Fun(self,"OnDragStart","QuickBut")
				Update_Icon(self)
				Update_Cooldown(self)
				Update_Count(self)
			end)
			--
			zhushoubut:SetAttribute("_onreceivedrag",[=[
				local leibie, spellID = ...
				if kind=="spell" then
					self:SetAttribute("type", kind)
					self:SetAttribute(kind, spellID)
				elseif kind=="item" then
					self:SetAttribute("type", kind)
					self:SetAttribute(kind, leibie)
				elseif kind=="macro" then
					self:SetAttribute("type", kind)
					self:SetAttribute(kind, value)
				end
			]=])
			zhushoubut:HookScript("OnReceiveDrag", function (self)
				Cursor_Fun(self,"OnReceiveDrag","QuickBut")
				Update_Icon(self)
				Update_Cooldown(self)
				Update_Count(self)
			end);
			----
			zhushoubut:SetScript("OnEnter", function (self)
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_NONE");
				GameTooltip:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-100,140);
				Update_OnEnter(self,"QuickBut")
			end)
			zhushoubut:SetScript("OnLeave", function ()
				GameTooltip:ClearLines();
				GameTooltip:Hide() 
			end);
			--
			zhushoubut:RegisterEvent("TRADE_SKILL_CLOSE")
			if tocversion>90000 then
			else
				zhushoubut:RegisterEvent("CRAFT_CLOSE")
			end
			PIGUseKeyDown(zhushoubut)
			zhushoubut:RegisterEvent("UPDATE_MACROS");
			--zhushoubut:RegisterEvent("EXECUTE_CHAT_LINE");
			zhushoubut:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
			zhushoubut:RegisterEvent("ACTIONBAR_UPDATE_STATE");
			zhushoubut:RegisterUnitEvent("UNIT_AURA","player");
			zhushoubut:RegisterEvent("BAG_UPDATE");
			zhushoubut:RegisterEvent("AREA_POIS_UPDATED");
			zhushoubut:HookScript("OnEvent", function(self,event,arg1,arg2,arg3)
				if Zhushou_List:IsShown() then
					if event=="PLAYER_REGEN_ENABLED" then
						PigMacroDeleted_QK,PigMacroCount_QK=Update_Macro(self,PigMacroDeleted_QK,PigMacroCount_QK,"QuickBut")
						self:UnregisterEvent("PLAYER_REGEN_ENABLED");
					end
					if event=="BAG_UPDATE" then
						Update_Count(self)
					end
					if event=="ACTIONBAR_UPDATE_COOLDOWN" then
						Update_Cooldown(self)
						Update_bukeyong(self)
					end
					if event=="ACTIONBAR_UPDATE_STATE" or event=="TRADE_SKILL_CLOSE" or event=="CRAFT_CLOSE" or event=="UNIT_AURA" or event=="EXECUTE_CHAT_LINE" then
						Update_State(self)
						Update_Icon(self)
					end
					if event=="UPDATE_MACROS" or event=="PLAYER_REGEN_ENABLED" then
						PigMacroEventCount_QK=PigMacroEventCount_QK+1;
						if self.Type=="macro" then
							if PigMacroEventCount_QK>5 then
								local AccMacros, CharMacros = GetNumMacros();
								if PigMacroCount_QK==0 then
									PigMacroCount_QK = AccMacros + CharMacros;
								elseif (PigMacroCount_QK > AccMacros + CharMacros) then
									PigMacroDeleted_QK = true;
								end
								PigMacroDeleted_QK,PigMacroCount_QK=Update_Macro(self,PigMacroDeleted_QK,PigMacroCount_QK,"QuickBut")
							end
						end
						Update_Icon(self)
						Update_Count(self)
					end
					if event=="AREA_POIS_UPDATED" then
						Update_bukeyong(self)
					end
				end
			end)
		end
	end
end