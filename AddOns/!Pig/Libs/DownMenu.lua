local addonName, addonTable = ...;
local Create = addonTable.Create
local FontUrl=Create.FontUrl
-----------------------
local ListName,List1Width,ButHeight="PIG_DropDownList",300,16
local listshumu = 300
PIG_DropDown={}
---
function PIGCloseDropDownMenus(level)
	if ( not level ) then
		level = 1;
	end
	for i=level, UIDROPDOWNMENU_MAXLEVELS do
		PIG_DropDown[i]:Hide();
	end
end
local function PIGDownMenu_StartCounting(frame)
	if ( frame.parent ) then
		PIGDownMenu_StartCounting(frame.parent);
	else
		frame.showTimer = UIDROPDOWNMENU_SHOW_TIME;
		frame.isCounting = 1;
	end
end
local function PIGDownMenu_StopCounting(frame)
	if ( frame.parent ) then
		PIGDownMenu_StopCounting(frame.parent);
	else
		frame.isCounting = nil;
	end
end
local function PIGDownMenu_OnUpdate(self, elapsed)
	if ( not self.showTimer or not self.isCounting ) then
		return;
	elseif ( self.showTimer < 0 ) then
		self:Hide()
		self.showTimer = nil;
		self.isCounting = nil;
	else
		self.showTimer = self.showTimer - elapsed;
	end
end
local function IsClickMouseOver()
	if not PIG_DropDown[1]:IsShown() then return false end
	local foci = GetMouseFoci();
	if not foci then return end
	for i=1, UIDROPDOWNMENU_MAXLEVELS do
		if i==1 then
			if PIG_DropDown[i].dropdown and foci[1]==PIG_DropDown[i].dropdown then
				return true
			elseif PIG_DropDown[i].dropdown and PIG_DropDown[i].dropdown.Button and foci[1]==PIG_DropDown[i].dropdown.Button then
				return true
			end
		end
		if foci[1]==PIG_DropDown[i] then
			return true
		end
		for ii=1,listshumu do
			if foci[1]==PIG_DropDown[i].ButList[ii] then
				return true
			end
		end
		for ixx=1,#PIG_DropDown[i].extFlist do
			if foci[1]==PIG_DropDown[i].extFlist[ixx] then
				return true
			end
		end
	end
	-- for i=1, UIDROPDOWNMENU_MAXLEVELS do
	-- 	if PIG_DropDown[i]:IsMouseOver() or i==1 and PIG_DropDown[1].dropdown and PIG_DropDown[1].dropdown:IsMouseOver() or i==1 and PIG_DropDown[1].dropdown and PIG_DropDown[1].dropdown.Button:IsMouseOver() then
	-- 		return true
	-- 	else
	-- 		for ixx=1,#PIG_DropDown[i].extFlist do
	-- 			if PIG_DropDown[i].extFlist[ixx]:IsMouseOver() then
	-- 				return true
	-- 			end
	-- 		end
	-- 	end
	-- end
	return false
end
local function Update_DownExtPoint(xialaMenu,ListFff,i,ckbut)
	if xialaMenu:PIGDownMenu_PointLR() then
		if i then ListFff:SetPoint("TOPRIGHT",PIG_DropDown[i], "TOPLEFT", 2,6); end
		for extFID=1,#ListFff.extFlist do
			ListFff.extFlist[extFID]:ClearAllPoints();
			if extFID==1 then
				ListFff.extFlist[extFID]:SetPoint("TOPRIGHT",ListFff,"TOPLEFT",2,0);
				ListFff.extFlist[extFID]:SetPoint("BOTTOMRIGHT",ListFff,"BOTTOMLEFT",2,0);
			else
				ListFff.extFlist[extFID]:SetPoint("TOPRIGHT",ListFff.extFlist[extFID-1],"TOPLEFT",2,0);
				ListFff.extFlist[extFID]:SetPoint("BOTTOMRIGHT",ListFff.extFlist[extFID-1],"BOTTOMLEFT",2,0);
			end
		end
	else
		if i then ListFff:SetPoint("TOPLEFT",ckbut, "TOPRIGHT", 2,6);end
		for extFID=1,#ListFff.extFlist do
			ListFff.extFlist[extFID]:ClearAllPoints();
			if extFID==1 then
				ListFff.extFlist[extFID]:SetPoint("TOPLEFT",ListFff,"TOPRIGHT",-2,0);
				ListFff.extFlist[extFID]:SetPoint("BOTTOMLEFT",ListFff,"BOTTOMRIGHT",-2,0);
			else
				ListFff.extFlist[extFID]:SetPoint("TOPLEFT",ListFff.extFlist[extFID-1],"TOPRIGHT",-2,0);
				ListFff.extFlist[extFID]:SetPoint("BOTTOMLEFT",ListFff.extFlist[extFID-1],"BOTTOMRIGHT",-2,0);
			end
		end
	end
end
----
for i=1,UIDROPDOWNMENU_MAXLEVELS do
	local PIGDownList = CreateFrame("Frame", nil, UIParent,"BackdropTemplate",i);
	PIG_DropDown[i]=PIGDownList
	PIGDownList:SetBackdrop(Create.Backdropinfo)
	PIGDownList:SetBackdropColor(0.1, 0.1, 0.1, 1);
	PIGDownList:SetBackdropBorderColor(0, 0, 0, 1);
	PIGDownList:Hide()
	PIGDownList:SetClampedToScreen(true)
	PIGDownList:SetFrameStrata("FULLSCREEN_DIALOG")
	PIGDownList:HookScript("OnEnter", function (self)
		PIGDownMenu_StopCounting(self)
	end)
	PIGDownList:HookScript("OnLeave", function (self)
		PIGDownMenu_StartCounting(self)
	end)
	PIGDownList:HookScript("OnUpdate", function(self, elapsed)
		PIGDownMenu_OnUpdate(self, elapsed)
	end)
	PIGDownList:SetFrameLevel(i*10)
	PIGDownList.extFlist={}
	PIGDownList:HookScript("OnHide", function(self)
		for g=1,UIDROPDOWNMENU_MAXLEVELS do
			PIG_DropDown[g]:Hide()
			for ixx=1,#PIG_DropDown[g].extFlist do
				PIG_DropDown[g].extFlist[ixx]:Hide()
			end
		end
	end)
	PIGDownList.ButList={}
	for ii=1,listshumu do
		local CheckBut = CreateFrame("CheckButton", nil, PIGDownList);
		PIGDownList.ButList[ii]=CheckBut
		CheckBut:SetHeight(ButHeight);
		CheckBut:Hide()
		CheckBut:SetFrameStrata("FULLSCREEN_DIALOG")

		CheckBut.Highlight = CheckBut:CreateTexture(nil, "HIGHLIGHT");
		CheckBut.Highlight:SetTexture("Interface/QuestFrame/UI-QuestTitleHighlight");
		CheckBut.Highlight:SetBlendMode("ADD")
		CheckBut.Highlight:SetAllPoints(CheckBut)

		CheckBut.Check = CheckBut:CreateTexture(nil, "BORDER");
		CheckBut.Check:SetTexture("Interface/Common/UI-DropDownRadioChecks");
		CheckBut.Check:SetSize(ButHeight,ButHeight);
		CheckBut.Check:SetPoint("LEFT", 0, 0);
		CheckBut.Check:Hide();
		CheckBut.UnCheck = CheckBut:CreateTexture(nil, "BORDER");
		CheckBut.UnCheck:SetTexture("Interface/Common/UI-DropDownRadioChecks");
		CheckBut.UnCheck:SetSize(ButHeight,ButHeight);
		CheckBut.UnCheck:SetPoint("LEFT", 0, 0);

		CheckBut.ExpandArrow = CheckBut:CreateTexture(nil, "BORDER");
		CheckBut.ExpandArrow:SetSize(ButHeight,ButHeight);
		CheckBut.ExpandArrow:SetPoint("RIGHT", 0, 0);
		CheckBut.ExpandArrow:Hide();

		CheckBut.Text = CheckBut:CreateFontString();
		CheckBut.Text:SetPoint("LEFT", 18, 0);
		CheckBut.Text:SetFont(FontUrl,14)
		CheckBut:HookScript("OnMouseDown", function (self)
			if self.isTitle then return end
			local fujilist = self:GetParent()
			local xialaMenu = fujilist.dropdown
			if xialaMenu.EasyMenu=="DJEasyMenu" or self.notCheckable then
				self.Text:SetPoint("LEFT", 5, -1);
			else
				self.Text:SetPoint("LEFT", 19, -1);
			end
		end);
		CheckBut:HookScript("OnMouseUp", function (self)
			if self.isTitle then return end
			local fujilist = self:GetParent()
			local xialaMenu = fujilist.dropdown
			if xialaMenu.EasyMenu=="DJEasyMenu" or self.notCheckable then
				self.Text:SetPoint("LEFT", 4, 0);
			else
				self.Text:SetPoint("LEFT", 18, 0);
			end
		end);
		CheckBut:HookScript("OnEnter", function (self)
			if self.isTitle then self.Highlight:Hide() return end
			local fujilist = self:GetParent()
			PIGDownMenu_StopCounting(fujilist)
			if self.hasArrow then
				local newi = i+1
				local ListFff = PIG_DropDown[newi]
				ListFff.maxWidth = 0;
				ListFff.numButtons = 0;
				ListFff.leftPoint=nil
				for iix=1,listshumu do
					ListFff.ButList[iix]:Hide()
				end
				for igh=1,#ListFff.extFlist do
					ListFff.extFlist[igh]:Hide()
					ListFff.extFlist[igh].maxWidth=0
					ListFff.extFlist[igh].numButtons = 0;
				end
				local xialaMenu = fujilist.dropdown
				xialaMenu:PIGDownMenu_Update_But(newi,self.menuList)
				ListFff:Show()
				ListFff:ClearAllPoints();
				Update_DownExtPoint(xialaMenu,ListFff,i,self)
			end
		end)
		CheckBut:HookScript("OnLeave", function (self)
			PIGDownMenu_StartCounting(self:GetParent())
		end)
		CheckBut:RegisterForClicks("LeftButtonUp","RightButtonUp")
		CheckBut:HookScript("OnClick", function (self,button)
			if self.isTitle then return end
			if self.isNotRadio then
				local xchecked = self:GetChecked()
				self.checked = xchecked
			else
				for v=1,listshumu do
					local FrameX = PIG_DropDown[i].ButList[v]
					FrameX:SetChecked(false)
				end
				self:SetChecked(true);
			end
			self.func(PIG_DropDown[1].dropdown,self.value,self.arg1,self.arg2,self.checked,button)
		end);
	end
end
EventRegistry:RegisterFrameEventAndCallback("GLOBAL_MOUSE_DOWN", function(buttonID, buttonName)
	if not IsClickMouseOver(buttonID, buttonName) then
		PIGCloseDropDownMenus()
	end
end);
--------------
local function Update_extFlistF(listFrame,Lid)
	if not listFrame.extFlist[Lid] then
		local erjiF = CreateFrame("Frame", nil, listFrame,"BackdropTemplate");
		erjiF:SetBackdrop(Create.Backdropinfo)
		erjiF:SetBackdropColor(0.1, 0.1, 0.1, 1);
		erjiF:SetBackdropBorderColor(0, 0, 0, 1);
		erjiF:HookScript("OnEnter", function (self)
			PIGDownMenu_StopCounting(listFrame)
		end)
		erjiF:HookScript("OnLeave", function (self)
			PIGDownMenu_StartCounting(listFrame)
		end)
		erjiF:SetFrameLevel(listFrame:GetFrameLevel())
		erjiF.maxWidth=0
		listFrame.extFlist[Lid]=erjiF
	end
	listFrame.extFlist[Lid]:Show()
end
function Create.PIGDownMenu(fuF,Point,SizeWH,EasyMenu,UIname,lie)
	local DownMenu = CreateFrame("Frame", UIname, fuF,"BackdropTemplate");
	DownMenu.EasyMenu=EasyMenu
	if EasyMenu=="EasyMenu" or EasyMenu=="DJEasyMenu" then	
		DownMenu:SetAllPoints(fuF)
		DownMenu.Button = CreateFrame("Button",nil,DownMenu, "TruncatedButtonTemplate");
		DownMenu.Button:SetAllPoints(DownMenu)
	else
		local Width,Height=SizeWH[1],SizeWH[2]
		local Height=Height or 24
		DownMenu:SetBackdrop(Create.Backdropinfo)
		DownMenu:SetBackdropColor(0.1, 0.1, 0.1, 1);
		DownMenu:SetBackdropBorderColor(0, 0, 0, 1);
		DownMenu:SetSize(Width,Height);
		DownMenu:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
		DownMenu:HookScript("OnHide", function(self)
			PIGCloseDropDownMenus()
		end)
		DownMenu.Button = CreateFrame("Button",nil,DownMenu);
		DownMenu.Button:SetSize(Height,Height);
		DownMenu.Button:SetPoint("RIGHT",DownMenu,"RIGHT",0,0);
		DownMenu.Button.UpTex = DownMenu.Button:CreateTexture();
		DownMenu.Button.UpTex:SetAtlas("NPE_ArrowDown")
		DownMenu.Button.UpTex:SetSize(Height-3,Height+6);
		DownMenu.Button.UpTex:SetPoint("CENTER", 0, -1);
		DownMenu.Button:SetHitRectInsets(-Width+Height,0,0,0)
		DownMenu.Button:HookScript("OnMouseDown", function(self)
			if self:IsEnabled() then
				self.UpTex:SetPoint("CENTER", 1.5, -2.5);
			end
		end);
		DownMenu.Button:HookScript("OnMouseUp", function(self)
			if self:IsEnabled() then
				self.UpTex:SetPoint("CENTER", 0, -1);
			end
		end);
		
		DownMenu.Text = DownMenu:CreateFontString();
		DownMenu.Text:SetWidth(Width-(Height+3));
		DownMenu.Text:SetPoint("RIGHT", DownMenu.Button, "LEFT", -2, 0);
		DownMenu.Text:SetFont(FontUrl,14)
		DownMenu.Text:SetJustifyH("RIGHT");
	end
	DownMenu.Button:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
	DownMenu.Button:RegisterForClicks("LeftButtonUp","RightButtonUp");
	local function zhixing_Show(fujiFrame)
		if fujiFrame.EasyMenu=="DJEasyMenu" then return end
		if PIG_DropDown[1]:IsShown() then
			PIG_DropDown[1]:Hide()
		else
			for g=1,UIDROPDOWNMENU_MAXLEVELS do
				PIG_DropDown[g]:Hide()
				PIG_DropDown[g].maxWidth = 0;
				PIG_DropDown[g].numButtons = 0;
				for gg=1,listshumu do
					PIG_DropDown[g].ButList[gg]:Hide()
				end
				for ixx=1,#PIG_DropDown[g].extFlist do
					PIG_DropDown[g].extFlist[ixx]:Hide()
					PIG_DropDown[g].extFlist[ixx].maxWidth = 0;
					PIG_DropDown[g].extFlist[ixx].numButtons = 0;
				end
			end		
			PIG_DropDown[1].showTimer = UIDROPDOWNMENU_SHOW_TIME;
			PIG_DropDown[1].isCounting = 1;
			PIG_DropDown[1]:ClearAllPoints();
			if fujiFrame.EasyMenu=="EasyMenu" or fujiFrame.EasyMenu=="DJEasyMenu" then
				PIG_DropDown[1]:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
			else
				PIG_DropDown[1]:SetPoint("TOPLEFT",fujiFrame, "BOTTOMLEFT", 0,0);
			end
			fujiFrame:PIGDownMenu_Update_But()
			if PIG_DropDown[1].numButtons>0 then
				PIG_DropDown[1]:Show()
				Update_DownExtPoint(fujiFrame,PIG_DropDown[1])
			end
		end
	end
	DownMenu.Button:HookScript("OnClick", function(self, button)
		local fujiFrame = self:GetParent()
		if button=="LeftButton" then
			zhixing_Show(fujiFrame)
		end
	end)
	function DownMenu:PIGDownMenu_SetText(Text)
		self.Text:SetText(Text)
	end
	function DownMenu:PIGDownMenu_GetText()	
		return self.Text:GetText()
	end
	function DownMenu:PIGDownMenu_GetValue()	
		return self.value,self.arg1,self.arg2
	end
	function DownMenu:PIGDownMenu_CreateInfo()
		self:PIGDownMenu_AddButton("null")
		return {}
	end
	function DownMenu:PIGDownMenu_PointLR()
		if PIG_DropDown[1]:IsVisible() then
			local offsetall = GetScreenWidth()
			local offsetrrr = PIG_DropDown[1]:GetRight();
			if offsetrrr then
				local hejiWWW=0
				for icc=2,UIDROPDOWNMENU_MAXLEVELS do
					if PIG_DropDown[icc]:IsShown() then
						hejiWWW=hejiWWW+PIG_DropDown[icc]:GetWidth()
						for wid=1,#PIG_DropDown[icc].extFlist do
							if PIG_DropDown[icc].extFlist[wid]:IsShown() then
								hejiWWW=hejiWWW+PIG_DropDown[icc].extFlist[wid]:GetWidth()
							end
						end
					end
				end
				return hejiWWW-(offsetall-offsetrrr)>0
			end
		end
		return false
	end
	function DownMenu:PIGDownMenu_AddButton(info, level,maxnum)
		if ( not level ) then
			level = 1;
		end
		local listFrame = PIG_DropDown[level];
		if info=="null" then 
			listFrame:SetHeight(1)
			return 
		end
		listFrame.dropdown = self;
		if level > 1 then
			listFrame.parent = PIG_DropDown[level-1]
		end
		local index = listFrame and (listFrame.numButtons + 1) or 1;
		listFrame.numButtons = index;
		local CheckBut=PIG_DropDown[level].ButList[index]
		CheckBut:Show()
		CheckBut.Text:SetText(info.text)
		CheckBut.value=info.text
		CheckBut.arg1=info.arg1
		CheckBut.arg2=info.arg2
		CheckBut.notCheckable=info.notCheckable
		CheckBut.isNotRadio=info.isNotRadio
		CheckBut.isTitle=info.isTitle
		CheckBut.func=info.func or function() end
		CheckBut:SetChecked(info.checked);
		CheckBut.Text:SetTextColor(1, 1, 1, 1);
		if self.EasyMenu=="DJEasyMenu" or info.notCheckable or info.isTitle then
			CheckBut.Check:Hide();
			CheckBut.UnCheck:Hide();
			CheckBut.Text:SetPoint("LEFT", 4, 0);
			if info.isTitle then
				CheckBut.Text:SetTextColor(1, 0.843, 0, 1);
			end
		else
			CheckBut.Text:SetPoint("LEFT", 18, 0);
			if info.checked then
				CheckBut.Check:Show();
				CheckBut.UnCheck:Hide();
			else
				CheckBut.Check:Hide();
				CheckBut.UnCheck:Show();
			end
		end
		if info.isNotRadio then
			CheckBut.Check:SetTexCoord(0.0, 0.5, 0.0, 0.5);
			CheckBut.UnCheck:SetTexCoord(0.5, 1.0, 0.0, 0.5);
		else
			CheckBut.Check:SetTexCoord(0.0, 0.5, 0.5, 1.0);
			CheckBut.UnCheck:SetTexCoord(0.5, 1.0, 0.5, 1.0);
		end
		CheckBut.hasArrow=info.hasArrow
		if self.EasyMenu=="EasyMenu" then
			CheckBut.icon=info.icon
			CheckBut.ExpandArrow:SetTexture(info.icon);
			CheckBut.ExpandArrow:Show();
		else
			CheckBut.ExpandArrow:SetTexture("Interface/ChatFrame/ChatFrameExpandArrow");
			if info.hasArrow then
				CheckBut.menuList=info.menuList
				CheckBut.ExpandArrow:Show();
			else
				CheckBut.ExpandArrow:Hide();
			end
		end
		if index==1 then
			CheckBut:SetPoint("TOPLEFT",listFrame,"TOPLEFT",4,-4);
			CheckBut:SetPoint("TOPRIGHT",listFrame,"TOPRIGHT",-4,-4);
		else
			CheckBut:SetPoint("TOPLEFT",listFrame.ButList[index-1],"BOTTOMLEFT",0,0);
			CheckBut:SetPoint("TOPRIGHT",listFrame.ButList[index-1],"BOTTOMRIGHT",0,0);
		end
		local width = CheckBut.Text:GetStringWidth()
		if index>40 then--菜单总数大于40，多列显示
			local lienum=math.ceil(listshumu/40)
			for leiID=2,lienum do
				local extFID=leiID-1
				if index>=extFID*40+1 and index<=leiID*40 then
					if index==extFID*40+1 then
						Update_extFlistF(listFrame,extFID,index,maxnum)
						CheckBut:ClearAllPoints();
						CheckBut:SetPoint("TOPLEFT", listFrame.extFlist[extFID],"TOPLEFT",4,-4);
						CheckBut:SetPoint("TOPRIGHT", listFrame.extFlist[extFID],"TOPRIGHT",4,-4);
					end
					if width>listFrame.extFlist[extFID].maxWidth then
						listFrame.extFlist[extFID].maxWidth=width
					end
					listFrame.extFlist[extFID]:SetWidth(listFrame.extFlist[extFID].maxWidth+ButHeight+26)
				end
			end
		else
			if width>listFrame.maxWidth then
				listFrame.maxWidth=width
			end
			listFrame:SetHeight(index*ButHeight+10)
			listFrame:SetWidth(listFrame.maxWidth+ButHeight+26)
		end
	end
	function DownMenu:Enable()
		self:SetBackdropBorderColor(0, 0, 0, 1);
		self.Text:SetTextColor(1, 1, 1, 1);
		self.Button:Enable()
		self.Button.UpTex:SetDesaturated(false)
	end
	function DownMenu:Disable()
		self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
		self.Text:SetTextColor(0.5, 0.5, 0.5, 1);
		self.Button:Disable()
		self.Button.UpTex:SetDesaturated(true)
	end
	function DownMenu:SetEnabled(bool)
		if bool then
			self:Enable()
		else
			self:Disable()
		end
	end
	return DownMenu
end