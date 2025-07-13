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
local function panduandianjichu()
	for i=1, UIDROPDOWNMENU_MAXLEVELS do
		if PIG_DropDown[i]:IsMouseOver() then
			return true
		end
	end
	return false
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
	if i == 1 then
		PIGDownList:HookScript("OnHide", function(self)
			for i=2,UIDROPDOWNMENU_MAXLEVELS do
				PIG_DropDown[i]:Hide()
			end
		end)
	else
		PIGDownList:SetFrameLevel(i*10)
		PIGDownList.extFlist={}
		for ix=1,5 do
			local erjiF = CreateFrame("Frame", nil, PIGDownList,"BackdropTemplate");
			erjiF:SetBackdrop(Create.Backdropinfo)
			erjiF:SetBackdropColor(0.1, 0.1, 0.1, 1);
			erjiF:SetBackdropBorderColor(0, 0, 0, 1);
			if ix==1 then
				erjiF:SetPoint("TOPLEFT",PIGDownList,"TOPRIGHT",0,0);
				erjiF:SetPoint("BOTTOMLEFT",PIGDownList,"BOTTOMRIGHT",0,0);
			else
				erjiF:SetPoint("TOPLEFT",PIGDownList.extFlist[ix-1],"TOPRIGHT",0,0);
				erjiF:SetPoint("BOTTOMLEFT",PIGDownList.extFlist[ix-1],"BOTTOMRIGHT",0,0);
			end
			erjiF:Hide()
			erjiF.maxWidth=0
			PIGDownList.extFlist[ix]=erjiF
		end
	end
	PIGDownList.ButList={}
	for ii=1,listshumu do
		local CheckBut = CreateFrame("CheckButton", nil, PIGDownList);
		PIGDownList.ButList[ii]=CheckBut
		CheckBut:SetHeight(ButHeight);
		if ii==1 then
			CheckBut:SetPoint("TOPLEFT",PIGDownList,"TOPLEFT",4,-4);
			CheckBut:SetPoint("TOPRIGHT",PIGDownList,"TOPRIGHT",-4,-4);
		else
			CheckBut:SetPoint("TOPLEFT",PIGDownList.ButList[ii-1],"BOTTOMLEFT",0,0);
			CheckBut:SetPoint("TOPRIGHT",PIGDownList.ButList[ii-1],"BOTTOMRIGHT",0,0);
		end
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
			local fujilist = self:GetParent()
			local xialaMenu = fujilist.dropdown
			if xialaMenu.EasyMenu=="DJEasyMenu" or self.notCheckable then
				self.Text:SetPoint("LEFT", 5, -1);
			else
				self.Text:SetPoint("LEFT", 19, -1);
			end
		end);
		CheckBut:HookScript("OnMouseUp", function (self)
			local fujilist = self:GetParent()
			local xialaMenu = fujilist.dropdown
			if xialaMenu.EasyMenu=="DJEasyMenu" or self.notCheckable then
				self.Text:SetPoint("LEFT", 4, 0);
			else
				self.Text:SetPoint("LEFT", 18, 0);
			end
		end);
		CheckBut:HookScript("OnEnter", function (self)
			local fujilist = self:GetParent()
			PIGDownMenu_StopCounting(fujilist)
			if self.hasArrow then
				local newi = i+1
				local ListFff = PIG_DropDown[newi]
				ListFff.maxWidth = 0;
				ListFff.numButtons = 0;
				ListFff:SetPoint("TOPLEFT",self, "TOPRIGHT", 2,6);
				for ii=1,listshumu do
					PIG_DropDown[newi].ButList[ii]:Hide()
				end
				if i==1 then
					for igh=1,5 do
						ListFff.extFlist[igh]:Hide()
						ListFff.extFlist[igh].maxWidth=0
					end
				end
				local xialaMenu = fujilist.dropdown
				xialaMenu:PIGDownMenu_Update_But(newi,self.menuList)
				ListFff:Show()
			end
		end)
		CheckBut:HookScript("OnLeave", function (self)
			PIGDownMenu_StartCounting(self:GetParent())
		end)
		CheckBut:HookScript("OnClick", function (self)
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
			self.func(PIG_DropDown[1].dropdown,self.value,self.arg1,self.arg2,self.checked)
		end);
	end
end
--------------
function Create.PIGDownMenu(fuF,Point,SizeWH,EasyMenu,UIname)
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
		DownMenu.Button:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		DownMenu.Button:SetSize(Height,Height);
		DownMenu.Button:SetPoint("RIGHT",DownMenu,"RIGHT",0,0);
		DownMenu.Button.UpTex = DownMenu.Button:CreateTexture();
		DownMenu.Button.UpTex:SetAtlas("NPE_ArrowDown")
		DownMenu.Button.UpTex:SetSize(Height-3,Height+6);
		DownMenu.Button.UpTex:SetPoint("CENTER", 0, -1);
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
	DownMenu.Button:RegisterForClicks("LeftButtonUp","RightButtonUp");
	local function zhixing_Show(fujiFrame)
		local xialaMenu = PIG_DropDown[1].dropdown
		if PIG_DropDown[1]:IsShown() and xialaMenu==fujiFrame then
			PIG_DropDown[1]:Hide()
		else
			for g=1,UIDROPDOWNMENU_MAXLEVELS do
				PIG_DropDown[g]:Hide()
				for gg=1,listshumu do
					PIG_DropDown[g].ButList[gg]:Hide()
				end
			end
			PIG_DropDown[1].showTimer = UIDROPDOWNMENU_SHOW_TIME;
			PIG_DropDown[1].isCounting = 1;
			PIG_DropDown[1].maxWidth = 0;
			PIG_DropDown[1].numButtons = 0;
			PIG_DropDown[1]:ClearAllPoints();
			if fujiFrame.EasyMenu=="EasyMenu" or fujiFrame.EasyMenu=="DJEasyMenu" then
				PIG_DropDown[1]:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
			else
				PIG_DropDown[1]:SetPoint("TOPLEFT",fujiFrame, "BOTTOMLEFT", 0,0);
			end
			fujiFrame:PIGDownMenu_Update_But()
			PIG_DropDown[1]:Show()
		end
	end
	DownMenu.Button:HookScript("OnClick", function(self, button)
		local fujiFrame = self:GetParent()
		if button=="LeftButton" then
			if fujiFrame.EasyMenu~="DJEasyMenu" then
				zhixing_Show(fujiFrame)
			end
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
	function DownMenu:PIGDownMenu_AddButton(info, level)
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
		CheckBut.func=info.func or function() end
		CheckBut:SetChecked(info.checked);
		if self.EasyMenu=="DJEasyMenu" or info.notCheckable then
			CheckBut.Check:Hide();
			CheckBut.UnCheck:Hide();
			CheckBut.Text:SetPoint("LEFT", 4, 0);
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

		CheckBut.isNotRadio=info.isNotRadio
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
		local width = CheckBut.Text:GetStringWidth()
		if index<51 then
			if width>listFrame.maxWidth then
				listFrame.maxWidth=width
			end
			listFrame:SetHeight(index*ButHeight+10)
			listFrame:SetWidth(listFrame.maxWidth+ButHeight+26)
		else
			listFrame:SetHeight(50*ButHeight+10)
			if level > 1 then
				local function ShowEXT_UI(index,id,maxnum)
					if width>listFrame.extFlist[id].maxWidth then
						listFrame.extFlist[id].maxWidth=width
					end
					listFrame.extFlist[id]:Show()
					listFrame.extFlist[id]:SetWidth(listFrame.extFlist[id].maxWidth+ButHeight+26)
					if index==(maxnum-50) then
						CheckBut:ClearAllPoints();
						CheckBut:SetPoint("TOPLEFT", listFrame.extFlist[id],"TOPLEFT",4,-4);
						CheckBut:SetPoint("TOPRIGHT", listFrame.extFlist[id],"TOPRIGHT",4,-4);
					end
				end
				if index<101 then
					ShowEXT_UI(index,1,101)
				elseif index<151 then
					ShowEXT_UI(index,2,151)
				elseif index<201 then
					ShowEXT_UI(index,3,201)
				elseif index<251 then
					ShowEXT_UI(index,4,251)
				elseif index<301 then
					ShowEXT_UI(index,5,301)
				end
			end
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