local addonName, addonTable = ...;
local TardisInfo=addonTable.TardisInfo
function TardisInfo.Yell(Activate)
	if not PIGA["Tardis"]["Yell"]["Open"] then return end
	local Create, Data, Fun, L= unpack(PIG)
	local PIGFrame=Create.PIGFrame
	local PIGEnter=Create.PIGEnter
	local PIGButton = Create.PIGButton
	local PIGDownMenu=Create.PIGDownMenu
	local PIGCheckbutton=Create.PIGCheckbutton
	local PIGOptionsList_R=Create.PIGOptionsList_R
	local PIGFontString=Create.PIGFontString
	local PIGQuickBut=Create.PIGQuickBut
	local PIGSetFont=Create.PIGSetFont
	local PigSetEditBoxData=Create.InitializeEditBox
	local IsEditBoxNumber=Create.IsEditBoxNumber
	------------------------
	local ConvertToRaid=ConvertToRaid or C_PartyInfo and C_PartyInfo.ConvertToRaid
	local GetContainerItemLink=GetContainerItemLink or C_Container and C_Container.GetContainerItemLink
	local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
	local sub = _G.string.sub
	local gsub = _G.string.gsub
	local match = _G.string.match
	local GetPindaoList=Fun.GetPindaoList
	local GetYellPindao=Fun.GetYellPindao
	local Key_fenge=Fun.Key_fenge
	local Get_famsg=Fun.Get_famsg
	local cl_Name=Data.cl_Name
	local cl_Name_Role=Data.cl_Name_Role
	local zhizeAtlas=Data.zhizeAtlas
	local MSGsuijizifu=Data.MSGsuijizifu
	---
	local InvF=_G[GnUI]
	local fujiF,fujiTabBut=PIGOptionsList_R(InvF.F,L["TARDIS_YELL"],80,"Bot")
	if Activate then fujiF:Show() fujiTabBut:Selected() end
	--=====================
	fujiF.topF = PIGFrame(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",4,-4});
	fujiF.topF:SetPoint("TOPRIGHT", fujiF, "TOPRIGHT", -4, -4);
	fujiF.topF:SetHeight(310)
	fujiF.topF:PIGSetBackdrop(0)

	--人数限制
	fujiF.topF.playerNum = PIGFontString(fujiF.topF,{"BOTTOMLEFT",fujiF.topF,"BOTTOMLEFT", 10,10},"当前人数:");
	fujiF.topF.playerNumV = PIGFontString(fujiF.topF,{"LEFT",fujiF.topF.playerNum,"RIGHT",4,0},0);
	fujiF.topF.playerNumV:SetTextColor(0, 1, 0, 1);
	fujiF.topF.playerNumxie = PIGFontString(fujiF.topF,{"LEFT", fujiF.topF.playerNumV, "RIGHT", 2,0},"/");

	fujiF.topF.playerNumV_max = CreateFrame("EditBox", nil, fujiF.topF,"InputBoxInstructionsTemplate");
	fujiF.topF.playerNumV_max:SetSize(40,26);
	fujiF.topF.playerNumV_max:SetPoint("LEFT",fujiF.topF.playerNumxie,"RIGHT",6,0);
	fujiF.topF.playerNumV_max:SetFontObject(ChatFontNormal);
	fujiF.topF.playerNumV_max:SetMaxLetters(2)
	fujiF.topF.playerNumV_max:SetAutoFocus(false);
	fujiF.topF.playerNumV_max:SetNumeric(true)
	PIGEnter(fujiF.topF.playerNumV_max,"1.限制最大邀请人数\n2.到达指定人数后将关闭自动邀请")
	PigSetEditBoxData(fujiF.topF.playerNumV_max,PIGA["Tardis"]["Yell"]["MaxPlayerNum"])
	fujiF.topF.playerNumV_max:HookScript("OnEditFocusGained", function(self) 
		self:HighlightText()
	end);
	fujiF.topF.playerNumV_max:HookScript("OnTextChanged", function(self)
		PIGA["Tardis"]["Yell"]["MaxPlayerNum"]=self:GetNumber()
	end);
	fujiF.topF.tishitxt1 = PIGFontString(fujiF.topF,{"LEFT",fujiF.topF.playerNumV_max,"RIGHT",20,0},"|cff00FF00提示: 触发优先级从上到下，同时触发2条以上规则优先执行上方规则|r");
	---条件
	local tiaojianList = {true,true,false,false,false}
	local tiaojianNUM = #tiaojianList
	fujiF.roleKeyTable={}
	local function SaveKeyTXT(lb,modeID)
		local Newtxt=PIGA["Tardis"]["Yell"]["Conditions"][modeID][lb]
		local Newtxt = Newtxt:gsub(" ", "")
		local Newtxt = Newtxt:gsub("，", ",")
		fujiF.roleKeyTable[modeID] = Key_fenge(Newtxt, ",", true)
	end
	local function add_ModeUI(fujiK,modeID,autoInv)
		fujiF.roleKeyTable[modeID]={}
		if modeID==1 then
			PIGA["Tardis"]["Yell"]["Conditions"][modeID]=PIGA["Tardis"]["Yell"]["Conditions"][modeID] or {["Open"]=false}
		else
			PIGA["Tardis"]["Yell"]["Conditions"][modeID]=PIGA["Tardis"]["Yell"]["Conditions"][modeID] or {["Open"]=false,["TJ"]="",["HF"]=""}
		end
		local tisptxt = {}
		if modeID==1 then
			tisptxt[1] = modeID..".密语为进组暗号则: |cff00FF00邀请入队|r"
			tisptxt[2] = "密语内容为进组暗号直接邀请"
		else
			tisptxt[1] = modeID..".如果密语包含:"
			if autoInv then
				tisptxt[2] = "当检测到密语包含特定关键字，则邀请对方加入队伍"
			else
				tisptxt[2] = "当检测到密语包含特定关键字，则回复预设内容"
			end
		end
		local modeUI = PIGCheckbutton(fujiK,{"TOPLEFT",fujiK,"TOPLEFT",10,-10},tisptxt)
		modeUI:SetScript("OnClick", function(self)
			if self:GetChecked() then
				PIGA["Tardis"]["Yell"]["Conditions"][modeID]["Open"]=true;
			else
				PIGA["Tardis"]["Yell"]["Conditions"][modeID]["Open"]=false;
			end
		end);
		modeUI:HookScript("OnShow", function(self)
			self:SetChecked(PIGA["Tardis"]["Yell"]["Conditions"][modeID]["Open"])
		end);
		if modeID>1 then
			SaveKeyTXT("TJ",modeID)
			modeUI:SetPoint("TOPLEFT",fujiK,"TOPLEFT",10,-60*(modeID-1)+10);
			modeUI.TJ = CreateFrame("EditBox", nil, modeUI,"InputBoxInstructionsTemplate");
			modeUI.TJ:SetHeight(26);
			modeUI.TJ:SetPoint("LEFT",modeUI.Text,"RIGHT",10,0);
			modeUI.TJ:SetPoint("RIGHT",fujiK,"RIGHT",-10,0);
			modeUI.TJ:SetFontObject(ChatFontNormal);
			modeUI.TJ:SetMaxLetters(200)
			modeUI.TJ:SetAutoFocus(false);
			modeUI.TJ.Instructions:SetText(L["CHAT_KEYWORD_TI"]);
			PigSetEditBoxData(modeUI.TJ,PIGA["Tardis"]["Yell"]["Conditions"][modeID]["TJ"])
			modeUI.TJ:HookScript("OnEnterPressed", function(self) 
				PIGA["Tardis"]["Yell"]["Conditions"][modeID]["TJ"]=self:GetText();
				SaveKeyTXT("TJ",modeID)
			end);
			if autoInv then
				modeUI.zhixingt = PIGFontString(modeUI,{"TOPLEFT",modeUI,"BOTTOMLEFT",20,-8},"则: |cff00FF00邀请入队|r");
			else
				modeUI.zhixingt = PIGFontString(modeUI,{"TOPLEFT",modeUI,"BOTTOMLEFT",20,-8},"则: |cff00FF00回复|r");
				modeUI.HF = CreateFrame("EditBox", nil, modeUI,"InputBoxInstructionsTemplate");
				modeUI.HF:SetHeight(26);
				modeUI.HF:SetPoint("LEFT",modeUI.zhixingt,"RIGHT",10,0);
				modeUI.HF:SetPoint("RIGHT",fujiK,"RIGHT",-10,0);
				modeUI.HF:SetFontObject(ChatFontNormal);
				modeUI.HF:SetMaxLetters(200)
				modeUI.HF:SetAutoFocus(false)
				modeUI.HF.Instructions:SetText("输入回复内容");
				PigSetEditBoxData(modeUI.HF,PIGA["Tardis"]["Yell"]["Conditions"][modeID]["HF"])
				modeUI.HF:HookScript("OnEnterPressed", function(self) 
					PIGA["Tardis"]["Yell"]["Conditions"][modeID]["HF"]=self:GetText();
				end);
			end
		end
		return modeUI
	end
	for i=1,tiaojianNUM do
		add_ModeUI(fujiF.topF,i,tiaojianList[i])
	end

	---底部设置===================
	fujiF.botF = PIGFrame(fujiF,{"TOPLEFT",fujiF.topF,"BOTTOMLEFT",0,-6});
	fujiF.botF:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", -4, 4);
	fujiF.botF:PIGSetBackdrop(0)
	--喊话内容
	fujiF.botF.YellF = PIGFrame(fujiF.botF,{"TOPLEFT", fujiF.botF, "TOPLEFT", 4,-22});
	fujiF.botF.YellF:SetPoint("BOTTOMLEFT", fujiF.botF, "BOTTOMLEFT", -200, 4);
	fujiF.botF.YellF:SetWidth(300)
	fujiF.botF.YellF:PIGSetBackdrop()
	fujiF.botF.YellF.biaoti = PIGFontString(fujiF.botF.YellF,{"BOTTOMLEFT", fujiF.botF.YellF, "TOPLEFT", 2,4},"喊话内容");
	fujiF.botF.YellF.biaoti:SetTextColor(0, 1, 0, 1);
	fujiF.botF.YellF.zifulenNum = PIGFontString(fujiF.botF.YellF,{"BOTTOMLEFT", fujiF.botF.YellF.biaoti, "BOTTOMRIGHT", 4,0});
	fujiF.botF.YellF.zifulenErr = PIGFontString(fujiF.botF.YellF,{"LEFT", fujiF.botF.YellF.zifulenNum, "RIGHT", 0,0});
	fujiF.botF.YellF.Instruction = PIGFontString(fujiF.botF.YellF,{"TOPLEFT", fujiF.botF.YellF, "TOPLEFT", 2,-2},"在此输入喊话内容");
	fujiF.botF.YellF.Instruction:SetTextColor(0.4, 0.4, 0.4, 1);
	fujiF.botF.YellF.E = CreateFrame("EditBox", nil, fujiF.botF.YellF);
	fujiF.botF.YellF.E:SetPoint("TOPLEFT", fujiF.botF.YellF, "TOPLEFT", 4,-2);
	fujiF.botF.YellF.E:SetPoint("BOTTOMRIGHT", fujiF.botF.YellF, "BOTTOMRIGHT", -4,2);
	fujiF.botF.YellF.E:SetFontObject(ChatFontNormal);
	fujiF.botF.YellF.E:SetAutoFocus(false);
	fujiF.botF.YellF.E:SetMultiLine(true)
	fujiF.botF.YellF.E:SetMaxLetters(255);
	PigSetEditBoxData(fujiF.botF.YellF.E,PIGA["Tardis"]["Yell"]["YellMsg"])
	fujiF.botF.YellF.E:HookScript("OnTextChanged", function(self)
		if #self:GetText()>0 then
			fujiF.botF.YellF.Instruction:Hide()
		else
			fujiF.botF.YellF.Instruction:Show()
		end
		local famsg,msglen = Get_famsg("yell",self:GetText(),PIGA["Tardis"]["Yell"]["CMD_Msg"],PIGA["Tardis"]["Yell"]["CMD"])
		if IsEditBoxNumber(famsg,msglen,fujiF.botF.YellF.zifulenNum,fujiF.botF.YellF.zifulenErr) then
			PIGA["Tardis"]["Yell"]["YellMsg"]=self:GetText()
		end
	end);
	if ContainerFrameItemButton_OnModifiedClick then
		hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
			if button=="LeftButton" and IsShiftKeyDown() then
		        local itemLink = GetContainerItemLink(self:GetParent():GetID(), self:GetID())
		        if itemLink and fujiF.botF.YellF.E:IsVisible() then
		            fujiF.botF.YellF.E:Insert(itemLink)
		        end
			end
		end)
	else
		hooksecurefunc(ContainerFrameItemButtonMixin, "OnClick", function(self,button)
			if button=="LeftButton" and IsShiftKeyDown() then
		        local itemLink = GetContainerItemLink(self:GetParent():GetID(), self:GetID())
		        if itemLink and fujiF.botF.YellF.E:IsVisible() then
		            fujiF.botF.YellF.E:Insert(itemLink)
		        end
			end
		end)
	end
	fujiF.botF.YellF.SaveYellTemp = PIGButton(fujiF.botF.YellF,{"TOPRIGHT",fujiF.botF.YellF,"TOPRIGHT",110,0.4},{100,19},"保存为模板");
	fujiF.botF.YellF.SaveYellTemp:SetScript("OnClick", function (self)
		if self.F:IsShown() then
			self.F:Hide()
		else
			self.F:Show()
		end
	end)
	fujiF.botF.YellF.SaveYellTemp.F = PIGFrame(fujiF.botF.YellF.SaveYellTemp,{"BOTTOM",fujiF.botF.YellF.SaveYellTemp,"TOP",0,1});
	fujiF.botF.YellF.SaveYellTemp.F:SetSize(250,160)
	fujiF.botF.YellF.SaveYellTemp.F:PIGSetBackdrop(1)
	fujiF.botF.YellF.SaveYellTemp.F:SetFrameLevel(fujiF.botF.YellF.SaveYellTemp.F:GetFrameLevel()+5)
	fujiF.botF.YellF.SaveYellTemp.F:Hide()
	fujiF.botF.YellF.SaveYellTemp.F.TT = PIGFontString(fujiF.botF.YellF.SaveYellTemp.F,{"TOP", fujiF.botF.YellF.SaveYellTemp.F, "TOP", 0,-6},"保存当前喊话为模板", "OUTLINE");
	fujiF.botF.YellF.SaveYellTemp.F.Name = PIGFontString(fujiF.botF.YellF.SaveYellTemp.F,{"TOPLEFT", fujiF.botF.YellF.SaveYellTemp.F, "TOPLEFT", 6,-50},"模版名:", "OUTLINE");
	fujiF.botF.YellF.SaveYellTemp.F.E = CreateFrame("EditBox", nil, fujiF.botF.YellF.SaveYellTemp.F, "InputBoxInstructionsTemplate");
	fujiF.botF.YellF.SaveYellTemp.F.E:SetSize(180,20);
	fujiF.botF.YellF.SaveYellTemp.F.E:SetMaxLetters(20)
	fujiF.botF.YellF.SaveYellTemp.F.E:SetPoint("LEFT", fujiF.botF.YellF.SaveYellTemp.F.Name, "RIGHT", 4,0);
	PIGSetFont(fujiF.botF.YellF.SaveYellTemp.F.E,14,"OUTLINE")
	fujiF.botF.YellF.SaveYellTemp.F.E:HookScript("OnShow", function(self)
		Create.Update_SaveTempF(fujiF.botF.YellF.SaveYellTemp.F,fujiF.botF.YellF.E:GetText():gsub(" ", ""))
	end)
	fujiF.botF.YellF.SaveYellTemp.F.E:HookScript("OnTextChanged", function(self)
		Create.Update_SaveTempF(fujiF.botF.YellF.SaveYellTemp.F,fujiF.botF.YellF.E:GetText():gsub(" ", ""))
	end)
	fujiF.botF.YellF.SaveYellTemp.F.error = PIGFontString(fujiF.botF.YellF.SaveYellTemp.F,{"TOPLEFT", fujiF.botF.YellF.SaveYellTemp.F.E, "BOTTOMLEFT", 6,-2},"", "OUTLINE");
	fujiF.botF.YellF.SaveYellTemp.F.error:SetTextColor(1, 0, 0, 1)
	fujiF.botF.YellF.SaveYellTemp.F.SaveBut=PIGButton(fujiF.botF.YellF.SaveYellTemp.F,{"BOTTOM",fujiF.botF.YellF.SaveYellTemp.F,"BOTTOM", -50,30},{50,24},"保存")
	fujiF.botF.YellF.SaveYellTemp.F.SaveBut:SetScript("OnClick", function (self)
		for ixx=1,#PIGA["Tardis"]["Yell"]["YellTemp"] do
			if PIGA["Tardis"]["Yell"]["YellTemp"][ixx][1]==fujiF.botF.YellF.SaveYellTemp.F.E:GetText() then
				PIGA["Tardis"]["Yell"]["YellTemp"][ixx][2]=fujiF.botF.YellF.E:GetText()
				fujiF.botF.YellF.SaveYellTemp.F:Hide()
				return
			end
		end
		table.insert(PIGA["Tardis"]["Yell"]["YellTemp"],{fujiF.botF.YellF.SaveYellTemp.F.E:GetText(),fujiF.botF.YellF.E:GetText()})
		fujiF.botF.YellF.SaveYellTemp.F:Hide()
	end)
	fujiF.botF.YellF.SaveYellTemp.F.OffBut=PIGButton(fujiF.botF.YellF.SaveYellTemp.F,{"BOTTOM",fujiF.botF.YellF.SaveYellTemp.F,"BOTTOM", 50,30},{50,24},CANCEL)
	fujiF.botF.YellF.SaveYellTemp.F.OffBut:SetScript("OnClick", function (self)
		fujiF.botF.YellF.SaveYellTemp.F:Hide()
	end)
	--喊话模板
	fujiF.botF.YellF.YellTemp=PIGDownMenu(fujiF.botF.YellF,{"TOPLEFT",fujiF.botF.YellF.SaveYellTemp,"BOTTOMLEFT",0,-4},{100,22})
	fujiF.botF.YellF.YellTemp:PIGDownMenu_SetText("喊话模板")
	function fujiF.botF.YellF.YellTemp:PIGDownMenu_Update_But()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for ixx=1,#PIGA["Tardis"]["Yell"]["YellTemp"] do
			info.text, info.arg1 = PIGA["Tardis"]["Yell"]["YellTemp"][ixx][1], PIGA["Tardis"]["Yell"]["YellTemp"][ixx][2]
		    info.notCheckable = true;
		    self:PIGDownMenu_AddButton(info)
		end
	end
	function fujiF.botF.YellF.YellTemp:PIGDownMenu_SetValue(value,arg1,arg2,checked,button)
		if button=="LeftButton" then
			fujiF.botF.YellF.E:SetText(arg1)
		else
			for ixx=#PIGA["Tardis"]["Yell"]["YellTemp"],1,-1 do
				if value == PIGA["Tardis"]["Yell"]["YellTemp"][ixx][1] then
					table.remove(PIGA["Tardis"]["Yell"]["YellTemp"],ixx)
					break
			   	end
			end
		end
		PIGCloseDropDownMenus()
	end
	--指令邀请
	local invtisp = "喊话内容附加进组暗号，玩家回复暗号将触发自动回复\n|cffFF0000需开启《自动回复/邀请》|r"
	fujiF.botF.jinzuCMD_inv = PIGCheckbutton(fujiF.botF,{"TOPLEFT",fujiF.botF.YellF.YellTemp,"BOTTOMLEFT",0,-8},{"喊话",invtisp})
	fujiF.botF.jinzuCMD_inv:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Tardis"]["Yell"]["CMD_Msg"]=true;
		else
			PIGA["Tardis"]["Yell"]["CMD_Msg"]=false;
		end
		local famsg,msglen = Get_famsg("yell",fujiF.botF.YellF.E:GetText(),PIGA["Tardis"]["Yell"]["CMD_Msg"],PIGA["Tardis"]["Yell"]["CMD"])
		IsEditBoxNumber(famsg,msglen,fujiF.botF.YellF.zifulenNum,fujiF.botF.YellF.zifulenErr)
	end);
	--进组指令
	fujiF.botF.jinzuCMDE_T = PIGFontString(fujiF.botF,{"LEFT",fujiF.botF.jinzuCMD_inv.Text,"RIGHT",0,0},"进组暗号");
	fujiF.botF.jinzuCMDE = CreateFrame("EditBox", nil, fujiF.botF,"InputBoxInstructionsTemplate");
	fujiF.botF.jinzuCMDE:SetSize(60,26);
	fujiF.botF.jinzuCMDE:SetPoint("LEFT",fujiF.botF.jinzuCMDE_T,"RIGHT",6,0);
	fujiF.botF.jinzuCMDE:SetFontObject(ChatFontNormal);
	fujiF.botF.jinzuCMDE:SetMaxLetters(6)
	fujiF.botF.jinzuCMDE:SetAutoFocus(false);
	PigSetEditBoxData(fujiF.botF.jinzuCMDE,PIGA["Tardis"]["Yell"]["CMD"])
	fujiF.botF.jinzuCMDE:HookScript("OnEditFocusGained", function(self) 
		self:HighlightText()
	end);
	fujiF.botF.jinzuCMDE:HookScript("OnTextChanged", function(self)
		PIGA["Tardis"]["Yell"]["CMD"]=self:GetText()
	end);
	--功能动作条按钮
	local QuickButUI=_G[Data.QuickButUIname]
	fujiF.botF.ShowDesktopBut = PIGCheckbutton(fujiF.botF,{"TOPLEFT",fujiF.botF.jinzuCMD_inv,"BOTTOMLEFT",0,-8},{"功能动作条按钮","添加喊话按钮到功能动作条\n此功能需要先开启功能动作条"})
	fujiF.botF.ShowDesktopBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Tardis"]["Yell"]["ShowDesktopBut"]=true;
		else
			PIGA["Tardis"]["Yell"]["ShowDesktopBut"]=false;
		end
		QuickButUI.ButList[TardisInfo.uidata[5]+1]()
	end);
	function fujiF.botF.UpdateDesktopButCD(time,cdt)
		if fujiF.botF.ShowDesktopBut.ButUI then
			fujiF.botF.ShowDesktopBut.ButUI.Cooldown:SetCooldown(time,cdt)
		end
	end
	function fujiF.botF.UpdateDesktopButONOFF(on)
		if fujiF.botF.ShowDesktopBut.ButUI then
			if on then
				fujiF.botF.ShowDesktopBut.ButUI.AutoYaoqing.Tex:SetTexture("interface/common/indicator-green.blp")
			else
				fujiF.botF.ShowDesktopBut.ButUI.AutoYaoqing.Tex:SetTexture("interface/common/indicator-gray.blp")
			end
		end
	end
	QuickButUI.ButList[TardisInfo.uidata[5]+1]=function()
		if not PIGA["QuickBut"]["Open"] or not PIGA["Tardis"]["Open"] then return end
		if PIGA["Tardis"]["Yell"]["ShowDesktopBut"] then
			if fujiF.botF.ShowDesktopBut.ButUI then
				fujiF.botF.ShowDesktopBut.ButUI.yincang=nil
				local fujiww = QuickButUI.nr:GetHeight()
				fujiF.botF.ShowDesktopBut.ButUI:Show()
				fujiF.botF.ShowDesktopBut.ButUI:SetWidth(fujiww)
				QuickButUI:UpdateWidth()
				return 
			end
			local WWHH = 24
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF"..L["TARDIS_YELL"].."|r\n"..KEY_BUTTON2.."-|cff00FFFF"..SETTINGS.."|r"
			local QkBut=PIGQuickBut(nil,QuickTooltip,132351)
			fujiF.botF.ShowDesktopBut.ButUI=QkBut
			QkBut.Cooldown = CreateFrame("Cooldown",nil, QkBut, "CooldownFrameTemplate")
			QkBut.Cooldown:SetAllPoints()
			QkBut:HookScript("OnClick", function (self,button)
				if button=="LeftButton" then
					if self.Cooldown:GetCooldownDuration()>0 then
						PIG_OptionsUI:ErrorMsg(ERR_CHAT_THROTTLED);
					else
						fujiF.Kaishi_Yell(self)
					end	
				else
					if InvF:IsShown() then
						InvF:Hide()
					else
						InvF:Show()
						Create.Show_TabBut_R(InvF.F,fujiF,fujiTabBut)
					end
				end
			end);
			local WowHeight=GetScreenHeight();
			local function YaoqingSetPoint(self)		
				local offset1 = QkBut:GetBottom();
				self:ClearAllPoints();
				if offset1>(WowHeight*0.5) then
					self:SetPoint("TOP",QkBut,"BOTTOM",0,-2);
				else
					self:SetPoint("BOTTOM",QkBut,"TOP",0,2);
				end
			end
			QkBut.AutoYaoqing = CreateFrame("Button",nil,QkBut);
			QuickButUI.yidong:HookScript("OnDragStop",function(self)
				YaoqingSetPoint(QkBut.AutoYaoqing)	
			end)
			YaoqingSetPoint(QkBut.AutoYaoqing)	
			QkBut.AutoYaoqing:SetSize(WWHH,WWHH);
			QkBut.AutoYaoqing.Tex = QkBut.AutoYaoqing:CreateTexture(nil, "BORDER");
			if PIG_OptionsUI.AutoInvite.Yell then
				QkBut.AutoYaoqing.Tex:SetTexture("interface/common/indicator-green.blp");
			else
				QkBut.AutoYaoqing.Tex:SetTexture("interface/common/indicator-gray.blp");
			end
			QkBut.AutoYaoqing.Tex:SetPoint("CENTER",0,-1);
			QkBut.AutoYaoqing.Tex:SetSize(WWHH,WWHH);
			QkBut.AutoYaoqing:SetScript("OnEnter", function (self)
				GameTooltip:ClearLines();
				local offset1 = QkBut:GetBottom();
				if offset1>(WowHeight*0.5) then
					GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT",-20,0);
				else
					GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
				end
				if PIG_OptionsUI.AutoInvite.Yell then
					GameTooltip:AddLine("自动回复/邀请:|cff00ff00"..ENABLE.."|r")
					GameTooltip:AddLine("|cff00FFff"..KEY_BUTTON1.."-|r|cffFFFF00"..CLOSE.."|r")
				else
					GameTooltip:AddLine("自动回复/邀请:|cffff0000"..CLOSE.."|r")
					GameTooltip:AddLine("|cff00FFff"..KEY_BUTTON1.."-|r|cffFFFF00"..ENABLE.."|r")
				end
				GameTooltip:Show();
			end);
			QkBut.AutoYaoqing:SetScript("OnLeave", function ()
				GameTooltip:ClearLines();
				GameTooltip:Hide() 
			end);
			QkBut.AutoYaoqing:SetScript("OnClick", function (self)
				PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
				fujiF:StartAutoInviteFun()
				GameTooltip:Hide() 
			end)
		else
			if fujiF.botF.ShowDesktopBut.ButUI then
				fujiF.botF.ShowDesktopBut.ButUI:Hide()
				fujiF.botF.ShowDesktopBut.ButUI:SetWidth(0.0001)
				fujiF.botF.ShowDesktopBut.ButUI.yincang=true
				QuickButUI:UpdateWidth()
			end
		end
	end
	QuickButUI.ButList[TardisInfo.uidata[5]+1]()
	--喊话按钮
	fujiF.botF.yellbut = PIGButton(fujiF.botF,{"BOTTOMLEFT",fujiF.botF.YellF,"BOTTOMRIGHT",4,10},{100,25},SEND_LABEL..L["TARDIS_YELL"]);
	fujiF.botF.yellbut:SetScript("OnClick", function (self)
		fujiF.Kaishi_Yell()
	end);
	--喊话频道
	fujiF.botF.Yell_CHANNEL=PIGDownMenu(fujiF.botF,{"LEFT",fujiF.botF.yellbut,"RIGHT",4,0},{70,25})
	fujiF.botF.Yell_CHANNEL:PIGDownMenu_SetText(CHANNEL)
	function fujiF.botF.Yell_CHANNEL:PIGDownMenu_Update_But()
		fujiF.PindaoList=GetPindaoList()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#fujiF.PindaoList,1 do
		    info.text, info.arg1 = fujiF.PindaoList[i][1], fujiF.PindaoList[i][2]
		    info.checked = PIGA["Tardis"]["Yell"]["Yell_CHANNEL"][fujiF.PindaoList[i][2]]
		    info.isNotRadio=true
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.botF.Yell_CHANNEL:PIGDownMenu_SetValue(value,arg1,arg2,checked)
		PIGA["Tardis"]["Yell"]["Yell_CHANNEL"][arg1]=checked
		PIGCloseDropDownMenus()
	end
	fujiF.botF:HookScript("OnShow", function(self)
		self.YellF.E:SetText(PIGA["Tardis"]["Yell"]["YellMsg"])
		self.jinzuCMD_inv:SetChecked(PIGA["Tardis"]["Yell"]["CMD_Msg"])
		self.ShowDesktopBut:SetChecked(PIGA["Tardis"]["Yell"]["ShowDesktopBut"])
	end);
	---
	fujiF.Yell_CD=10
	fujiF.PindaoList={}
	local function hanhuadaojishiTime()
		if fujiF.hanhuadaojishi>0 then
			fujiF.botF.yellbut:SetText(ON_COOLDOWN.."("..fujiF.hanhuadaojishi..")");
			C_Timer.After(1,hanhuadaojishiTime)
			fujiF.hanhuadaojishi=fujiF.hanhuadaojishi-1
		else
			fujiF.botF.yellbut:Enable() 
			fujiF.botF.yellbut:SetText(SEND_LABEL..L["TARDIS_YELL"]);
		end
	end
	function fujiF.Kaishi_Yell()
		local yellpindaolist =GetYellPindao(fujiF.PindaoList,PIGA["Tardis"]["Yell"]["Yell_CHANNEL"])
		local keyongshu = #yellpindaolist
		if keyongshu>0 then
			local famsg =Get_famsg("yell",PIGA["Tardis"]["Yell"]["YellMsg"],PIGA["Tardis"]["Yell"]["CMD_Msg"],PIGA["Tardis"]["Yell"]["CMD"])
			for x=1,#yellpindaolist do
				local suijishu=random(1, 8)
				local famsg = famsg..MSGsuijizifu[suijishu]
				SendChatMessage(famsg,yellpindaolist[x][1],nil,yellpindaolist[x][2])
			end
			fujiF.hanhuadaojishi=fujiF.Yell_CD*keyongshu
			fujiF.botF.yellbut:Disable();
			fujiF.botF.yellbut:SetText(L["TARDIS_YELL"].."("..fujiF.hanhuadaojishi..")");
			fujiF.botF.UpdateDesktopButCD(GetTime(), fujiF.Yell_CD*keyongshu)
			hanhuadaojishiTime()
		else
			PIG_OptionsUI:ErrorMsg("请先选择喊话频道");
		end
	end

	----自动邀请
	fujiF.botF.AutoYaoqing = PIGButton(fujiF.botF,{"BOTTOMLEFT",fujiF.botF,"BOTTOMLEFT",520,15},{130,24},"自动回复/邀请"); 
	PIGEnter(fujiF.botF.AutoYaoqing,"根据预设条件邀请或回复，达到预设人数将停止邀请")
	fujiF.botF.AutoYaoqing.Text:SetPoint("CENTER",fujiF.botF.AutoYaoqing,"CENTER",8,0);
	fujiF.botF.AutoYaoqing.Text:SetTextColor(0, 1, 1, 1);
	fujiF.botF.AutoYaoqing.Tex = fujiF.botF.AutoYaoqing:CreateTexture(nil, "BORDER");
	fujiF.botF.AutoYaoqing.Tex:SetTexture("interface/common/indicator-gray.blp");
	fujiF.botF.AutoYaoqing.Tex:SetPoint("RIGHT",fujiF.botF.AutoYaoqing.Text,"LEFT",0,-1);
	fujiF.botF.AutoYaoqing.Tex:SetSize(23,23);
	fujiF.botF.AutoYaoqing:HookScript("OnMouseDown", function(self)
		if self:IsEnabled() then
			self.Text:SetPoint("CENTER",fujiF.botF.AutoYaoqing,"CENTER",9.5,-1.5);
		end
	end);
	fujiF.botF.AutoYaoqing:HookScript("OnMouseUp", function(self)
		if self:IsEnabled() then
			self.Text:SetPoint("CENTER",fujiF.botF.AutoYaoqing,"CENTER",8,0);
		end
	end);
	fujiF.botF.AutoYaoqing:SetScript("OnClick", function (self)
		fujiF:StartAutoInviteFun()
	end)
	--根据指令邀请
	local function OFF_autoInvite(msg)
		PIG_OptionsUI.AutoInvite.Yell=nil;
		fujiF.botF.UpdateDesktopButONOFF(false)
		fujiF.botF.AutoYaoqing.Tex:SetTexture("interface/common/indicator-gray.blp");
		fujiF:UnregisterEvent("CHAT_MSG_WHISPER");
		fujiF:UnregisterEvent("CHAT_MSG_SYSTEM");
		PIG_OptionsUI:ErrorMsg(msg);
	end
	--判断是否是队长/团长/助理
	function fujiF.Is_GroupLeader(laiyuan)
		if IsInGroup() then
			local isLeader = UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME);
			local isTrue = UnitIsGroupAssistant("player", LE_PARTY_CATEGORY_HOME);
			if not isLeader and not isTrue then
				if laiyuan~="event" then
					OFF_autoInvite("你不是队长/团长/助理,自动邀请已关闭")
				end
				return false
			end
		end
		return true
	end
	function fujiF.Is_RaidNumOK(laiyuan)
		local numGroupMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		if numGroupMembers>=fujiF.topF.playerNumV_max:GetNumber() then
			if laiyuan~="event" then
				OFF_autoInvite("已达目标人数,自动邀请已关闭")
			end
			return false
		end
		return true,numGroupMembers
	end
	function fujiF:StartAutoInviteFun()
		if PIG_OptionsUI:IsAutoInviteOpen("Yell") then
			return	
		end
		if PIG_OptionsUI.AutoInvite.Yell then
			OFF_autoInvite("已|cffFF0000关闭|r自动邀请")
		else
			if self.Is_GroupLeader() and self.Is_RaidNumOK() then
				PIG_OptionsUI.AutoInvite.Yell=true
				self:RegisterEvent("CHAT_MSG_WHISPER");
				self:RegisterEvent("CHAT_MSG_SYSTEM")
				self.botF.AutoYaoqing.Tex:SetTexture("interface/common/indicator-green.blp");
				self.botF.UpdateDesktopButONOFF(true)
				PIG_OptionsUI:ErrorMsg("已|cff00FF00开启|r自动邀请");
			end
		end
	end
	--------
	local function PIG_Invite_Fun(Pname)
		local numGroupMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		if numGroupMembers==5 and not IsInRaid(LE_PARTY_CATEGORY_HOME) then
			ConvertToRaid()
		end
		PIG_InviteUnit(Pname)
	end
	--添加临时会话人，60秒后无沟通则删除
	function fujiF:AddCommunication(name)
	    self.TemporaryPlayer[name] = GetTime()
	    if self.PlayerTimers[name] then
	        self.PlayerTimers[name]:Cancel()
	    end
	    self.PlayerTimers[name] = C_Timer.NewTimer(60, function()
	        if self.TemporaryPlayer[name] then
	           self.TemporaryPlayer[name] = nil
	        end
	    end)
	end
	--获取当前人员/人数
	function fujiF:_GetNumGroupMembers()
		if not self.topF.playerNumV:IsShown() then return end
		self.topF.playerNumV:SetText(GetNumGroupMembers(LE_PARTY_CATEGORY_HOME));
	end
	-----------
	local Err_already=ERR_ALREADY_IN_GROUP_S:gsub("%%s","")
	fujiF:RegisterEvent("PLAYER_ENTERING_WORLD")
	fujiF:RegisterEvent("GROUP_ROSTER_UPDATE")
	fujiF:HookScript("OnEvent",function(self,event,arg1,arg2,_,_,arg5,_,_,_,_,_,_,arg12)
		if event=="PLAYER_ENTERING_WORLD" then
			C_Timer.After(3,function()
				self.PindaoList=GetPindaoList()
			end)
		elseif event=="GROUP_ROSTER_UPDATE" then
			C_Timer.After(0.4,function()
				self:_GetNumGroupMembers()
				self.Is_GroupLeader("event")
				self.Is_RaidNumOK("event")
			end)
		elseif PIG_OptionsUI.AutoInvite.Yell then
			if arg1:match("[!Pig]") then return end
			if event=="CHAT_MSG_SYSTEM" then
				if arg1:match(Err_already) then
					local errPlayer=arg1:gsub(Err_already,"")
					if errPlayer and errPlayer~="" then
						SendChatMessage("[!Pig] 你已有队伍，请退组后再M", "WHISPER", nil, errPlayer);
					end
				end
			elseif event=="CHAT_MSG_WHISPER" then		
				for tjID=1,tiaojianNUM do
					if PIGA["Tardis"]["Yell"]["Conditions"][tjID]["Open"] then
						if tjID==1 then
							if arg1==PIGA["Tardis"]["Yell"]["CMD"] then
								PIG_Invite_Fun(arg2)
							end
						else
							for _,key in pairs(fujiF.roleKeyTable[tjID]) do
								if arg1:match(key) then
									if tjID==2 then
										PIG_Invite_Fun(arg2)
									else
										SendChatMessage("[!Pig] "..PIGA["Tardis"]["Yell"]["Conditions"][tjID]["HF"], "WHISPER", nil, arg2);
									end
									return
								end
							end
						end
					end
				end
			end
		end
	end)
end