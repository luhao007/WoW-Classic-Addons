local _, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
--
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGButton = Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList=Create.PIGOptionsList
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGFontStringBG=Create.PIGFontStringBG
local PIGEnter=Create.PIGEnter
local add_Bar=Create.add_Bar
local CombatPlusfun=addonTable.CombatPlusfun
-------------------------
local function ADD_HPMPBarUI(fujiSetUI,setV)
	if not PIGA["CombatPlus"]["HPMPBar"]["Open"] then return end
	if HPMPBar_UI then return end
	local HPMPBar = CreateFrame("Button", "HPMPBar_UI", UIParent, "SecureUnitButtonTemplate,SecureHandlerStateTemplate")
	HPMPBar:SetHeight(1);
	HPMPBar:SetPoint("CENTER", UIParent, "CENTER", PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"], PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"]);
	HPMPBar:EnableMouse(false)
	HPMPBar:SetAttribute("_onstate-combatYN","if newstate == 'show' then self:Show(); else self:Hide(); end")
	function HPMPBar.Set_CombatShowHide()
		if PIGA["CombatPlus"]["HPMPBar"]["CombatShow"] then
			RegisterStateDriver(HPMPBar, "combatYN", "[combat] show; hide");
		else
			RegisterStateDriver(HPMPBar, "combatYN", "[] show; hide");
		end
	end
	HPMPBar.Set_CombatShowHide()
	------------------------
	local _, classId = UnitClassBase("player");
	HPMPBar.classId=classId
	local function add_HPMPBar(fuji,ly)
		local Bar=add_Bar(fuji,ly)
		fuji.next=Bar
		Bar:RegisterEvent("PLAYER_ENTERING_WORLD");
		return Bar
	end
	if PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"] then
		if HPMPBar.classId== 4 or HPMPBar.classId== 6 or HPMPBar.classId== 11 then
			HPMPBar.Fuziyuan=add_HPMPBar(HPMPBar,HPMPBar.classId)
			HPMPBar.Fuziyuan.butListID={}
			HPMPBar.FuStyle={}
			HPMPBar.FuStyle[HPMPBar.classId] = PIGA["CombatPlus"]["HPMPBar"]["FuStyle"][HPMPBar.classId] or 1
			if HPMPBar.classId == 4 or HPMPBar.classId== 11 then--盗贼
				for index=1,MAX_COMBO_POINTS,1 do			
					local Points = CreateFrame("Frame", nil, HPMPBar.Fuziyuan,"BackdropTemplate")
					Points.tex  = Points:CreateTexture();
					Points.tex:SetAtlas("ClassOverlay-ComboPoint-Off")
					HPMPBar.Fuziyuan.butListID[index]=Points
				end
				HPMPBar.Fuziyuan:RegisterEvent("UNIT_POWER_UPDATE");
				HPMPBar.Fuziyuan:HookScript("OnEvent", function(self, event, arg1, arg2)
					local comboPoints = GetComboPoints("player", "target");
					if HPMPBar.FuStyle[HPMPBar.classId]==1 then
						HPMPBar.Fuziyuan:PIGBackdropColor(HPMPBar.Fuziyuan.butListID)
						for ix=1,comboPoints do
							HPMPBar.Fuziyuan.butListID[ix]:SetBackdropColor(1, 0, 0, 0.9);
						end
					else
						for ix=1,MAX_COMBO_POINTS do
							HPMPBar.Fuziyuan.butListID[ix].tex:SetAtlas("ClassOverlay-ComboPoint-Off")
						end
						for ix=1,comboPoints do
							HPMPBar.Fuziyuan.butListID[ix].tex:SetAtlas("ClassOverlay-ComboPoint")
						end					
					end
					if ( comboPoints == MAX_COMBO_POINTS ) then
						--displayType = "crit";
					end
				end)
			elseif HPMPBar.classId== 6 then--死亡骑士
				local RuneTypeColor = {
					[1]={1,40/255,40/255},
					[2]={0,191/255,1},
					[3]={30/255,255/255,100/255},
					[4]={1,20/255,147/255},
				}
				local Runeindex = {1,2,5,6,3,4}
				local function UpdateRuneType(index)
					local runeType = GetRuneType(index)
					HPMPBar.Fuziyuan.Runebut[index]:SetStatusBarColor(RuneTypeColor[runeType][1],RuneTypeColor[runeType][2],RuneTypeColor[runeType][3],1);
				end	
				local function RuneButton_OnUpdate (self)
					local start, duration, runeReady = GetRuneCooldown(self:GetID())
					if start==nil or runeReady then
						self:SetValue(10);
						self:SetAlpha(1);
						self:SetScript("OnUpdate", nil);
					else
						self:SetValue(GetTime()-start);
					end
				end
				local function UpdateRuneCooldown(index,added)
					if added then
						HPMPBar.Fuziyuan.Runebut[index]:SetAlpha(1);
						HPMPBar.Fuziyuan.Runebut[index]:SetScript("OnUpdate", nil);
					else
						HPMPBar.Fuziyuan.Runebut[index]:SetAlpha(0.7);
						HPMPBar.Fuziyuan.Runebut[index]:SetScript("OnUpdate", RuneButton_OnUpdate);
					end
				end
				local function UpdateRunesAll()
					for index=1,6 do
						UpdateRuneType(index)
						UpdateRuneCooldown(index,false)
					end
				end
				HPMPBar.Fuziyuan.Runebut={}
				for index=1,6,1 do
					local RuneBut = CreateFrame("Frame", nil, HPMPBar.Fuziyuan,"BackdropTemplate")
					RuneBut:SetBackdrop({edgeFile = Create.edgeFile, edgeSize = 8,})
					if index==1 then
						RuneBut:SetPoint("LEFT",HPMPBar.Fuziyuan,"LEFT",0,0);
					else
						RuneBut:SetPoint("LEFT",HPMPBar.Fuziyuan.butListID[index-1],"RIGHT",-1,0);
					end
					HPMPBar.Fuziyuan.butListID[index]=RuneBut
					RuneBut.bar = CreateFrame("StatusBar", nil, RuneBut,nil,Runeindex[index]);
					RuneBut.bar:SetStatusBarTexture("interface/chatframe/chatframebackground.blp")
					RuneBut.bar:SetPoint("TOPLEFT",RuneBut,"TOPLEFT",0,0);
					RuneBut.bar:SetPoint("BOTTOMRIGHT",RuneBut,"BOTTOMRIGHT",0,0);
					RuneBut.bar:SetFrameLevel(RuneBut:GetFrameLevel()-1)
					RuneBut.bar:SetMinMaxValues(0, 10)
					HPMPBar.Fuziyuan.Runebut[Runeindex[index]]=RuneBut.bar
				end
				HPMPBar.Fuziyuan:PIGBackdropBorderColor(HPMPBar.Fuziyuan.butListID)
				HPMPBar.Fuziyuan:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
				HPMPBar.Fuziyuan:RegisterEvent("RUNE_TYPE_UPDATE");
				HPMPBar.Fuziyuan:RegisterEvent("RUNE_POWER_UPDATE");
				HPMPBar.Fuziyuan:RegisterEvent("PLAYER_REGEN_DISABLED")
				HPMPBar.Fuziyuan:HookScript("OnEvent", function(self, event, arg1, arg2)
					if event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_ENTERING_WORLD" or event =="PLAYER_REGEN_DISABLED" then
						UpdateRunesAll();
					elseif ( event == "RUNE_TYPE_UPDATE") then
						UpdateRuneType(arg1)
					elseif ( event == "RUNE_POWER_UPDATE") then
						UpdateRuneCooldown(arg1, arg2);
					end
				end)
			end
		end
	end
	if PIGA["CombatPlus"]["HPMPBar"]["HpShow"] then
		HPMPBar.HPBar=add_HPMPBar(HPMPBar)
		if tocversion<90000 then
			HPMPBar.HPBar:RegisterUnitEvent("UNIT_HEALTH_FREQUENT","player");
		else
			HPMPBar.HPBar:RegisterUnitEvent("UNIT_HEALTH","player");
		end
		if setV then
			HPMPBar.HPBar:Update_MaxValues(UnitHealthMax("player")) 
			HPMPBar.HPBar:Update_Values(UnitHealth("player"))
		end
		hooksecurefunc(HPMPBar.HPBar, "Set_BarFont", function()	
			HPMPBar.HPBar:Update_MaxValues(UnitHealthMax("player"))
			HPMPBar.HPBar:Update_Values(UnitHealth("player"))
		end)
		HPMPBar.HPBar:PIGStatusBarColort(0, 1, 0 ,1)
		HPMPBar.HPBar:RegisterUnitEvent("UNIT_MAXHEALTH","player");
		HPMPBar.HPBar:SetScript("OnEvent", function (self,event)
			if event=="PLAYER_ENTERING_WORLD" then
				self:Update_MaxValues(UnitHealthMax("player")) 
				self:Update_Values(UnitHealth("player"))
			elseif event=="UNIT_MAXHEALTH" then
				self:Update_MaxValues(UnitHealthMax("player"))
			elseif event=="UNIT_HEALTH_FREQUENT" or event=="UNIT_HEALTH" then
				self:Update_Values(UnitHealth("player"))
			end
		end)
	end
	if PIGA["CombatPlus"]["HPMPBar"]["MpShow"] then
		HPMPBar.MPBar=add_HPMPBar(HPMPBar)
		function HPMPBar.MPBar:Update_PowerType()
			local powerType = UnitPowerType("player")
			local info = PowerBarColor[powerType]
			self:PIGStatusBarColort(info.r, info.g, info.b ,1)
		end
		if setV then
			HPMPBar.MPBar:Update_MaxValues(UnitPowerMax("player"))
			HPMPBar.MPBar:Update_Values(UnitPower("player"))
			HPMPBar.MPBar:Update_PowerType()
		end
		hooksecurefunc(HPMPBar.MPBar, "Set_BarFont", function()	
			HPMPBar.MPBar:Update_MaxValues(UnitPowerMax("player"))
			HPMPBar.MPBar:Update_Values(UnitPower("player"))
		end)
		HPMPBar.MPBar:RegisterEvent("UNIT_DISPLAYPOWER");
		HPMPBar.MPBar:RegisterUnitEvent("UNIT_POWER_FREQUENT","player");
		HPMPBar.MPBar:RegisterUnitEvent("UNIT_MAXPOWER","player");
		HPMPBar.MPBar:SetScript("OnEvent", function (self,event)
			if event=="PLAYER_ENTERING_WORLD" then
				self:Update_MaxValues(UnitPowerMax("player"))
				self:Update_Values(UnitPower("player"))
				self:Update_PowerType()
			elseif event=="UNIT_MAXPOWER" then
				self:Update_MaxValues(UnitPowerMax("player"))
			elseif event=="UNIT_POWER_FREQUENT" then
				self:Update_Values(UnitPower("player"))
			elseif event == "UNIT_DISPLAYPOWER" then
				self:Update_MaxValues(UnitPowerMax("player"))
				self:Update_PowerType()
			end
		end)
	end
	HPMPBar.Showshuzhi=PIGA["CombatPlus"]["HPMPBar"]["Showshuzhi"]
	---
	function HPMPBar.Set_StatusBarTex()
		if HPMPBar.HPBar then HPMPBar.HPBar:PIGStatusBarTexture(PIGA["CombatPlus"]["HPMPBar"]["BarTex"]) end
		if HPMPBar.MPBar then HPMPBar.MPBar:PIGStatusBarTexture(PIGA["CombatPlus"]["HPMPBar"]["BarTex"]) end
		if HPMPBar.Fuziyuan then
			HPMPBar.Fuziyuan:PIGStatusBarTexture(HPMPBar.Fuziyuan.butListID,PIGA["CombatPlus"]["HPMPBar"]["BarTex"])
			if HPMPBar.classId==4 or HPMPBar.classId==11 then
				if HPMPBar.FuStyle[HPMPBar.classId]==1 then
					HPMPBar.Fuziyuan:PIGBackdropBorderColor(HPMPBar.Fuziyuan.butListID)
					for index=1,5 do
						HPMPBar.Fuziyuan.butListID[index].tex:Hide()
					end
				else
					for index=1,5 do
						HPMPBar.Fuziyuan.butListID[index]:SetBackdropColor(1, 1, 1, 0);
						HPMPBar.Fuziyuan.butListID[index]:SetBackdropBorderColor(1, 1, 1, 0)
						HPMPBar.Fuziyuan.butListID[index].tex:Show()
						HPMPBar.Fuziyuan.butListID[index].tex:SetPoint("BOTTOM",HPMPBar.Fuziyuan.butListID[index],"BOTTOM",0,1);
					end
				end
			end
		end
	end
	function HPMPBar.Set_StatusBarWH()
		local www = PIGA["CombatPlus"]["HPMPBar"]["BarW"] or 150
		HPMPBar:SetWidth(www);
		local hhh = PIGA["CombatPlus"]["HPMPBar"]["BarH"] or 12
		local ziframe = {HPMPBar:GetChildren()}
		for k,v in pairs(ziframe) do
			v.Plus=v.Plus or 0
			v:SetHeight(hhh+v.Plus)
		end
		if HPMPBar.Fuziyuan then
			if HPMPBar.classId==4 or HPMPBar.classId==11 then
				local xxww = www*0.2
				for index=1,5 do
					HPMPBar.Fuziyuan.butListID[index]:SetSize(xxww,hhh);
					if index==1 then
						HPMPBar.Fuziyuan.butListID[index]:SetPoint("LEFT",HPMPBar.Fuziyuan,"LEFT",0,0);
					else
						HPMPBar.Fuziyuan.butListID[index]:SetPoint("LEFT",HPMPBar.Fuziyuan.butListID[index-1],"RIGHT",0,0);
					end
				end
				if HPMPBar.FuStyle[HPMPBar.classId]==2 then
					for index=1,5 do
						HPMPBar.Fuziyuan.butListID[index].tex:SetSize(hhh+4,hhh+4);
					end
				end
			elseif HPMPBar.classId==6 then
				local Runewww=www/6
				for index=1,6 do
					if HPMPBar.Fuziyuan.butListID[index] then
						HPMPBar.Fuziyuan.butListID[index]:SetHeight(hhh);
						if index==1 then
							HPMPBar.Fuziyuan.butListID[index]:SetWidth(Runewww);
						else
							HPMPBar.Fuziyuan.butListID[index]:SetWidth(Runewww+1);
						end
					end
				end
			end
		end
	end
	function HPMPBar.Set_BarFontAll()
		local ziframe = {HPMPBar:GetChildren()}
		for k,v in pairs(ziframe) do
			v:Set_BarFont()
		end
	end
	HPMPBar.Set_StatusBarTex()
	HPMPBar.Set_StatusBarWH()
	HPMPBar.Set_BarFontAll()
	---
	fujiSetUI.BarTex=PIGDownMenu(fujiSetUI,{"TOPLEFT",fujiSetUI,"TOPLEFT",60,-20},{150,24})
	fujiSetUI.BarTex.T = PIGFontString(fujiSetUI.BarTex,{"RIGHT",fujiSetUI.BarTex,"LEFT",-4,0},TEXTURES_SUBHEADER)
	function fujiSetUI.BarTex:PIGDownMenu_Update_But()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,HPMPBar.BarTexNum,1 do
		    info.text, info.arg1 = TEXTURES_SUBHEADER..i, i
		    info.checked = i==PIGA["CombatPlus"]["HPMPBar"]["BarTex"]
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiSetUI.BarTex:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		PIGA["CombatPlus"]["HPMPBar"]["BarTex"]=arg1
		HPMPBar.Set_StatusBarTex()
		PIGCloseDropDownMenus()
	end
	fujiSetUI.CombatShow =PIGCheckbutton(fujiSetUI,{"LEFT",fujiSetUI.BarTex,"LEFT",200,0},{"脱战后隐藏","脱战后隐藏血量资源条"})
	fujiSetUI.CombatShow:SetScript("OnClick", function (self)
		if InCombatLockdown() then PIGTopMsg:add(ERR_NOT_IN_COMBAT) return end
		if self:GetChecked() then
			PIGA["CombatPlus"]["HPMPBar"]["CombatShow"]=true;
		else
			PIGA["CombatPlus"]["HPMPBar"]["CombatShow"]=false;
		end
		HPMPBar.Set_CombatShowHide()
	end);
	--
	local function Set_WHXY()
		HPMPBar:SetPoint("CENTER", UIParent, "CENTER", PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"], PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"]);
	end
	local WowWidth=floor(GetScreenWidth()*0.5);
	local xiayiinfo = {-WowWidth,WowWidth,1}
	fujiSetUI.SliderX = PIGSlider(fujiSetUI,{"TOPLEFT",fujiSetUI,"TOPLEFT",60,-70},xiayiinfo)
	fujiSetUI.SliderX.T = PIGFontString(fujiSetUI.SliderX,{"RIGHT",fujiSetUI.SliderX,"LEFT",0,0},"X偏移")
	fujiSetUI.SliderX.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIGTopMsg:add(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"]=arg1;
		Set_WHXY()
	end)
	local WowHeight=floor(GetScreenHeight()*0.5);
	local xiayiinfo = {-WowHeight,WowHeight,1}
	fujiSetUI.SliderY = PIGSlider(fujiSetUI,{"LEFT",fujiSetUI.SliderX,"RIGHT",100,0},xiayiinfo)
	fujiSetUI.SliderY.T = PIGFontString(fujiSetUI.SliderY,{"RIGHT",fujiSetUI.SliderY,"LEFT",0,0},"Y偏移")
	fujiSetUI.SliderY.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIGTopMsg:add(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"]=arg1;
		Set_WHXY()
	end)
	fujiSetUI.CZBUT = PIGButton(fujiSetUI,{"LEFT",fujiSetUI.SliderY,"RIGHT",60,0},{80,24},"重置位置")
	fujiSetUI.CZBUT:SetScript("OnClick", function ()
		if InCombatLockdown() then PIGTopMsg:add(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"]=addonTable.Default["CombatPlus"]["HPMPBar"]["Xpianyi"]
		PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"]=addonTable.Default["CombatPlus"]["HPMPBar"]["Ypianyi"]
		fujiSetUI.SliderX:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"])
		fujiSetUI.SliderY:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"])
		Set_WHXY()
	end)

	local xiayiinfo = {100,400,1}
	fujiSetUI.BarW = PIGSlider(fujiSetUI,{"TOPLEFT",fujiSetUI,"TOPLEFT",60,-140},xiayiinfo)
	fujiSetUI.BarW.T = PIGFontString(fujiSetUI.BarW,{"RIGHT",fujiSetUI.BarW,"LEFT",0,0},"宽度")
	fujiSetUI.BarW.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIGTopMsg:add(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["BarW"]=arg1;
		HPMPBar.Set_StatusBarWH()
	end)
	local xiayiinfo = {10,60,1}
	fujiSetUI.BarH = PIGSlider(fujiSetUI,{"LEFT",fujiSetUI.BarW,"RIGHT",100,0},xiayiinfo)
	fujiSetUI.BarH.T = PIGFontString(fujiSetUI.BarH,{"RIGHT",fujiSetUI.BarH,"LEFT",0,0},"高度")
	fujiSetUI.BarH.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIGTopMsg:add(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["BarH"]=arg1;
		HPMPBar.Set_StatusBarWH()
	end)
	fujiSetUI.CZSize = PIGButton(fujiSetUI,{"LEFT",fujiSetUI.BarH,"RIGHT",60,0},{80,24},"默认大小")
	fujiSetUI.CZSize:SetScript("OnClick", function ()
		if InCombatLockdown() then PIGTopMsg:add(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["BarW"]=addonTable.Default["CombatPlus"]["HPMPBar"]["BarW"]
		PIGA["CombatPlus"]["HPMPBar"]["BarH"]=addonTable.Default["CombatPlus"]["HPMPBar"]["BarH"]
		fujiSetUI.BarW:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["BarW"])
		fujiSetUI.BarH:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["BarH"])
		HPMPBar.Set_StatusBarWH()
	end)
	fujiSetUI.Showshuzhi =PIGCheckbutton(fujiSetUI,{"TOPLEFT",fujiSetUI,"TOPLEFT",20,-240},{"显示数值","显示血量/资源数值"})
	fujiSetUI.Showshuzhi:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CombatPlus"]["HPMPBar"]["Showshuzhi"]=true;
			HPMPBar.Showshuzhi=true
		else
			PIGA["CombatPlus"]["HPMPBar"]["Showshuzhi"]=false;
			HPMPBar.Showshuzhi=false
		end
		HPMPBar.Set_BarFontAll()
	end);
	local xiayiinfo = {10,26,1}
	fujiSetUI.FontSize = PIGSlider(fujiSetUI,{"LEFT",fujiSetUI.Showshuzhi,"LEFT",210,0},xiayiinfo)
	fujiSetUI.FontSize.T = PIGFontString(fujiSetUI.FontSize,{"RIGHT",fujiSetUI.FontSize,"LEFT",-10,0},"字体大小")
	fujiSetUI.FontSize.Slider:HookScript("OnValueChanged", function(self, arg1)
		if InCombatLockdown() then PIGTopMsg:add(ERR_NOT_IN_COMBAT) return end
		PIGA["CombatPlus"]["HPMPBar"]["FontSize"]=arg1;
		HPMPBar.Set_BarFontAll()
	end)

	fujiSetUI.HpShow =PIGCheckbutton(fujiSetUI,{"TOPLEFT",fujiSetUI.Showshuzhi,"TOPLEFT",0,-40},{"显示血量条","个人资源条显示血量"})
	fujiSetUI.HpShow:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CombatPlus"]["HPMPBar"]["HpShow"]=true;
		else
			PIGA["CombatPlus"]["HPMPBar"]["HpShow"]=false;
		end
		Pig_Options_RLtishi_UI:Show()
	end);
	fujiSetUI.MpShow =PIGCheckbutton(fujiSetUI,{"TOPLEFT",fujiSetUI.HpShow,"TOPLEFT",0,-40},{"显示资源条","个人资源条显示资源"})
	fujiSetUI.MpShow:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CombatPlus"]["HPMPBar"]["MpShow"]=true;
		else
			PIGA["CombatPlus"]["HPMPBar"]["MpShow"]=false;
		end
		Pig_Options_RLtishi_UI:Show()
	end);
	if HPMPBar.classId==4 or HPMPBar.classId==6 or HPMPBar.classId==11 then
		fujiSetUI.Fuziyuan =PIGCheckbutton(fujiSetUI,{"TOPLEFT",fujiSetUI.MpShow,"TOPLEFT",0,-40},{"显示特殊资源条","个人资源条显示特殊资源(连击点/符文/其他)"})
		fujiSetUI.Fuziyuan:SetScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"]=true;
			else
				PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"]=false;
			end
			Pig_Options_RLtishi_UI:Show()
		end);
		if PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"]  then
			fujiSetUI.Fuziyuan.style=PIGDownMenu(fujiSetUI.Fuziyuan,{"LEFT",fujiSetUI.Fuziyuan.Text,"RIGHT",2,0},{80,24})
			fujiSetUI.Fuziyuan.style.listtex=1
			if HPMPBar.classId==4 or HPMPBar.classId==11 then
				fujiSetUI.Fuziyuan.style.listtex=2
			end
			function fujiSetUI.Fuziyuan.style:PIGDownMenu_Update_But()
				local info = {}
				info.func = self.PIGDownMenu_SetValue
				for i=1,fujiSetUI.Fuziyuan.style.listtex,1 do
				    info.text, info.arg1 = TEXTURES_SUBHEADER..i, i
				   	info.checked = i==HPMPBar.FuStyle[HPMPBar.classId]
					self:PIGDownMenu_AddButton(info)
				end
			end
			function fujiSetUI.Fuziyuan.style:PIGDownMenu_SetValue(value,arg1,arg2)
				if InCombatLockdown() then PIGTopMsg:add(ERR_NOT_IN_COMBAT) return end
				self:PIGDownMenu_SetText(value)
				HPMPBar.FuStyle[HPMPBar.classId]=arg1
				PIGA["CombatPlus"]["HPMPBar"]["FuStyle"][HPMPBar.classId]=arg1
				HPMPBar.Set_StatusBarTex()
				HPMPBar.Set_StatusBarWH()
				PIGCloseDropDownMenus()
			end
		end
	end
	fujiSetUI:HookScript("OnShow", function (self)
		self.Showshuzhi:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["Showshuzhi"]);
		self.CombatShow:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["CombatShow"]);
		self.FontSize:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["FontSize"])
		self.BarW:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["BarW"])
		self.BarH:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["BarH"])
		self.SliderX:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Xpianyi"])
		self.SliderY:PIGSetValue(PIGA["CombatPlus"]["HPMPBar"]["Ypianyi"])
		self.BarTex:PIGDownMenu_SetText(TEXTURES_SUBHEADER..PIGA["CombatPlus"]["HPMPBar"]["BarTex"])
		self.HpShow:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["HpShow"]);
		self.MpShow:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["MpShow"]);
		if self.Fuziyuan then
			self.Fuziyuan:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["Fuziyuan"]);
			if self.Fuziyuan.style then
				self.Fuziyuan.style:PIGDownMenu_SetText(TEXTURES_SUBHEADER..HPMPBar.FuStyle[HPMPBar.classId])
			end
		end
	end);
end
function CombatPlusfun.HPMPBar()
	if tocversion<50000 then
		local CombatPlusF,CombatPlustabbut =PIGOptionsList_R(CombatPlusfun.RTabFrame,L["COMBAT_TABNAME3"],100)
		CombatPlusF.Open = PIGCheckbutton_R(CombatPlusF,{"启用个人资源条","在屏幕上显示个人资源条"})
		CombatPlusF.Open:SetScript("OnClick", function (self)
			if self:GetChecked() then			
				PIGA["CombatPlus"]["HPMPBar"]["Open"]=true;
				ADD_HPMPBarUI(CombatPlusF.SetF,true)
				CombatPlusF.SetF:Show()
			else
				PIGA["CombatPlus"]["HPMPBar"]["Open"]=false;
				CombatPlusF.SetF:Hide()
				Pig_Options_RLtishi_UI:Show()
			end
		end)
		CombatPlusF:HookScript("OnShow", function (self)
			self.Open:SetChecked(PIGA["CombatPlus"]["HPMPBar"]["Open"]);
			self.SetF:SetShown(PIGA["CombatPlus"]["HPMPBar"]["Open"])
		end)
		CombatPlusF.SetF = PIGFrame(CombatPlusF,{"TOPLEFT", CombatPlusF, "TOPLEFT", 0, -60})
		CombatPlusF.SetF:SetPoint("BOTTOMRIGHT",CombatPlusF,"BOTTOMRIGHT",0,0);
		CombatPlusF.SetF:PIGSetBackdrop(0)
		----
		ADD_HPMPBarUI(CombatPlusF.SetF)
	end
end