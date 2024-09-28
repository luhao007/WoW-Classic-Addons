local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
---
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGEnter=Create.PIGEnter
local PIGLine=Create.PIGLine
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGDownMenu=Create.PIGDownMenu
--
local ClassFile_Name=addonTable.Data.ClassFile_Name
----
local CommonInfo=addonTable.CommonInfo
CommonInfo.Commonfun={}
----常用
local fujiF,fujiTabBut =PIGOptionsList_R(CommonInfo.NR,L["COMMON_TABNAME"],70)
fujiF:Show()
fujiTabBut:Selected()
---任务提示音
fujiF.QuestsEnd =PIGCheckbutton_R(fujiF,{"任务完成提示音","任务完成提示音"},true)
fujiF.QuestsEnd:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Common"]["QuestsEnd"]=true;	
	else
		PIGA["Common"]["QuestsEnd"]=false;
	end
	CommonInfo.Commonfun.QuestsEnd()
end);
fujiF.QuestsEnd.xiala=PIGDownMenu(fujiF.QuestsEnd,{"LEFT",fujiF.QuestsEnd.Text, "RIGHT", 4,0},{180,24})
function fujiF.QuestsEnd.xiala:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#CommonInfo.AudioList,1 do
	    info.text, info.arg1 = CommonInfo.AudioList[i][1], i
	    info.checked = i==PIGA["Common"]["QuestsEndAudio"]
		fujiF.QuestsEnd.xiala:PIGDownMenu_AddButton(info)
	end 
end
function fujiF.QuestsEnd.xiala:PIGDownMenu_SetValue(value,arg1)
	fujiF.QuestsEnd.xiala:PIGDownMenu_SetText(value)
	PIGA["Common"]["QuestsEndAudio"]=arg1
	PIGCloseDropDownMenus()
end
fujiF.QuestsEnd.PlayBut = CreateFrame("Button",nil,fujiF.QuestsEnd);
fujiF.QuestsEnd.PlayBut:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
fujiF.QuestsEnd.PlayBut:SetSize(24,24);
fujiF.QuestsEnd.PlayBut:SetPoint("LEFT",fujiF.QuestsEnd.xiala,"RIGHT",8,0);
fujiF.QuestsEnd.PlayBut.UpTex = fujiF.QuestsEnd.PlayBut:CreateTexture();
fujiF.QuestsEnd.PlayBut.UpTex:SetAtlas("chatframe-button-icon-speaker-on")
fujiF.QuestsEnd.PlayBut.UpTex:SetSize(24,24);
fujiF.QuestsEnd.PlayBut.UpTex:SetPoint("CENTER", 0, 0);
fujiF.QuestsEnd.PlayBut:HookScript("OnMouseDown", function(self)
	if self:IsEnabled() then
		self.UpTex:SetPoint("CENTER", 1.5, -1.5);
	end
end);
fujiF.QuestsEnd.PlayBut:HookScript("OnMouseUp", function(self)
	if self:IsEnabled() then
		self.UpTex:SetPoint("CENTER", 0, 0);
	end
end);
fujiF.QuestsEnd.PlayBut:SetScript("OnClick", function()
	PlaySoundFile(CommonInfo.AudioList[PIGA["Common"]["QuestsEndAudio"]][2], "Master")
end)
----
if tocversion<20000 then
	local classColorTable = {r=0,g=0.44,b=0.87}
	local colorF = CreateFrame("Frame")
	colorF:RegisterEvent("ADDON_LOADED")
	colorF:SetScript("OnEvent", function(self, event, arg1)
	    if arg1 == addonName then
	    	if PIGA["Common"]["SHAMAN_Color"] then
			    PIG_CLASS_COLORS["SHAMAN"] = {
			        r = 0,
	                g = 0.44,
	                b = 0.87,
	                colorStr = "ff0070DD",
			    }
				if not CUSTOM_CLASS_COLORS then
					CUSTOM_CLASS_COLORS = {}
					local ybtable = {}
					function ybtable:RegisterCallback(method, handler)
					end
					function ybtable:UnregisterCallback(method, handler)
					end
					function ybtable:GetClassToken(className)
					    return className and classTokens[className]
					end
					function ybtable:ColorTextByClassToken(text, className)
					    return self:ColorTextByClass(text, self:GetClassToken(className))
					end
					function ybtable:ColorTextByClass(text, class)
					    local color = CUSTOM_CLASS_COLORS[class]
					    if color then
					        color = CreateColor(color.r, color.g, color.b)
					        return color:WrapTextInColorCode(text)
					    end
					end
					setmetatable(CUSTOM_CLASS_COLORS, { __index = ybtable })
					for k,v in pairs(RAID_CLASS_COLORS) do
						if k=="SHAMAN" then
							CUSTOM_CLASS_COLORS[k] = {
				                r = 0,
				                g = 0.44,
				                b = 0.87,
				                colorStr = "ff0070DD",
				            }
						else
					        CUSTOM_CLASS_COLORS[k] = {
				                r = v.r,
				                g = v.g,
				                b = v.b,
				                colorStr = v.colorStr,
				            }
				        end
					end
				end
				local old_GetColoredName=GetColoredName
				GetColoredName=function(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
					if ( arg12 and arg12 ~= "" ) then
						local localizedClass, englishClass, localizedRace, englishRace, sex = GetPlayerInfoByGUID(arg12)
						if ( englishClass ) then
							if englishClass=="SHAMAN" then
								local chatType = strsub(event, 10);
								if ( strsub(chatType, 1, 7) == "WHISPER" ) then
									chatType = "WHISPER";
								end
								if ( strsub(chatType, 1, 7) == "CHANNEL" ) then
									chatType = "CHANNEL"..arg8;
								end
								local info = ChatTypeInfo[chatType];
								if (chatType == "GUILD") then
									arg2 = Ambiguate(arg2, "guild")
								else
									arg2 = Ambiguate(arg2, "none")
								end
								if ( info and info.colorNameByClass ) then
									return string.format("\124cff%.2x%.2x%.2x", classColorTable.r*255, classColorTable.g*255, classColorTable.b*255)..arg2.."\124r"
								end
							else
								old_GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
							end
						end
					end
					return old_GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
				end
				hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
		        	local unitIsConnected = UnitIsConnected(frame.unit);
					local unitIsDead = unitIsConnected and UnitIsDead(frame.unit);
					local unitIsPlayer = UnitIsPlayer(frame.unit) or UnitIsPlayer(frame.displayedUnit);
					if ( not unitIsConnected or (unitIsDead and not unitIsPlayer) ) then
					else
						local localizedClass, englishClass = UnitClass(frame.unit);
						if englishClass=="SHAMAN" then
							if ( (frame.optionTable.allowClassColorsForNPCs or UnitIsPlayer(frame.unit)) and frame.optionTable.useClassColors ) then
								frame.healthBar:SetStatusBarColor(classColorTable.r, classColorTable.g, classColorTable.b);
								if (frame.optionTable.colorHealthWithExtendedColors) then
									frame.selectionHighlight:SetVertexColor(classColorTable.r, classColorTable.g, classColorTable.b);
								end
							end
						end
			        end
			    end)
			end
		    self:UnregisterEvent("ADDON_LOADED")
		end
	end)
	fujiF.SHAMAN_Color =PIGCheckbutton_R(fujiF,{"修改"..ClassFile_Name["SHAMAN"]..CLASS_COLORS,"修改"..ClassFile_Name["SHAMAN"]..CLASS_COLORS.."为正式服颜色"},true)
	fujiF.SHAMAN_Color:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Common"]["SHAMAN_Color"]=true;	
		else
			PIGA["Common"]["SHAMAN_Color"]=false;
		end
		Pig_Options_RLtishi_UI:Show()
	end);
else
	fujiF.SetFocus = PIGCheckbutton_R(fujiF,{"快速设置焦点","按后方设置的快捷键后点击头像快速设置焦点"},true)
	fujiF.SetFocus:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Common"]["SetFocus"]=true;
			CommonInfo.Commonfun.SetFocus()
		else
			PIGA["Common"]["SetFocus"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
	end);
	fujiF.SetFocus.xiala=PIGDownMenu(fujiF.SetFocus,{"LEFT",fujiF.SetFocus.Text, "RIGHT", 4,0},{150,24})
	function fujiF.SetFocus.xiala:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		local SetKeyList = CommonInfo.SetKeyList
		for i=1,#SetKeyList,1 do
		    info.text, info.arg1, info.arg2 = SetKeyList[i][1], SetKeyList[i][2]
		    info.checked = SetKeyList[i][2]==PIGA["Common"]["SetFocusKEY"]
			fujiF.SetFocus.xiala:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.SetFocus.xiala:PIGDownMenu_SetValue(value,arg1)
		if InCombatLockdown() then PIG_print("战斗中无法更改按键") return end
		fujiF.SetFocus.xiala:PIGDownMenu_SetText(value)
		PIGA["Common"]["SetFocusKEY"]=arg1
		CommonInfo.Commonfun.SetFocus()
		CommonInfo.Commonfun.ClearFocus()
		PIGCloseDropDownMenus()
	end
	fujiF.SetFocus.Mouse =PIGCheckbutton(fujiF.SetFocus,{"LEFT",fujiF.SetFocus.xiala,"RIGHT",10,0},{"包含角色模型","在角色模型上点击设置的快捷键也可设为焦点"})
	fujiF.SetFocus.Mouse:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Common"]["SetFocusMouse"]=true;
		else
			PIGA["Common"]["SetFocusMouse"]=false;
		end
		CommonInfo.Commonfun.SetFocus()
	end);
	fujiF.ClearFocus =PIGCheckbutton_R(fujiF,{"快速清除焦点","在焦点头像点击已设置焦点快捷键可快速清除焦点"},true)
	fujiF.ClearFocus:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Common"]["ClearFocus"]=true;
		else
			PIGA["Common"]["ClearFocus"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
		CommonInfo.Commonfun.ClearFocus()
	end);
end
function CommonInfo.Commonfun.AutoCVars()
	if PIGA["Common"]["AutoCVars"] then
		SetCVar("lootUnderMouse", "1")
		SetCVar("chatClassColorOverride", "0")
		SetCVar("instantQuestText", "1")
	end
end
fujiF.AutoCVars =PIGCheckbutton_R(fujiF,{SELF_CAST_AUTO..SETTINGS..BASE_SETTINGS_TAB.."CVars",SELF_CAST_AUTO..SETTINGS..BASE_SETTINGS_TAB.."CVars\n1."..LOOT_UNDER_MOUSE_TEXT.."\n2.聊天栏"..SHOW_CLASS_COLOR.."\n3."..SHOW_QUEST_FADING_TEXT..""},true)
fujiF.AutoCVars:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Common"]["AutoCVars"]=true;	
	else
		PIGA["Common"]["AutoCVars"]=false;
	end
	CommonInfo.Commonfun.AutoCVars()
end);
function CommonInfo.Commonfun.AutoLoot()
	if PIGA["Common"]["AutoLoot"] then
		SetCVar("autoLootDefault", "1")
		if fujiF.AutoLoot.FastLoot then fujiF.AutoLoot.FastLoot:Enable() end
	else
		SetCVar("autoLootDefault", "0")
		if fujiF.AutoLoot.FastLoot then fujiF.AutoLoot.FastLoot:Disable() end
	end
end
fujiF.AutoLoot =PIGCheckbutton_R(fujiF,{ENABLE..AUTO_LOOT_DEFAULT_TEXT,ENABLE..AUTO_LOOT_DEFAULT_TEXT},true)
fujiF.AutoLoot:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Common"]["AutoLoot"]=true;	
	else
		PIGA["Common"]["AutoLoot"]=false;
	end
	CommonInfo.Commonfun.AutoLoot()
	CommonInfo.Commonfun.FastLoot()
end);
if tocversion<50000 then
	fujiF.AutoLoot.FastLoot = PIGCheckbutton(fujiF.AutoLoot,{"LEFT",fujiF.AutoLoot.Text,"RIGHT",20,0},{"加快拾取速度","在开启自动拾取时加快你的拾取速度(在队长分配不起作用)"})
	fujiF.AutoLoot.FastLoot:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Common"]["FastLoot"]=true;
		else
			PIGA["Common"]["FastLoot"]=false;
		end
		CommonInfo.Commonfun.FastLoot()
	end)
end
---性能优化---
fujiF.xingnengF=PIGFrame(fujiF,{"BOTTOMLEFT", fujiF, "BOTTOMLEFT", 0, 60})
fujiF.xingnengF:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", 0, 60);
fujiF.xingnengF:SetHeight(160)
PIGLine(fujiF.xingnengF,"TOP",0,nil,{0,-340})
PIGLine(fujiF.xingnengF,"TOP",0,nil,{340,0})
fujiF.xingnengF.biaoti = PIGFontString(fujiF.xingnengF,{"TOP",fujiF.xingnengF,"TOP",0,7},"性能优化");
---关闭新版字体
fujiF.xingnengF.offnewfont =PIGCheckbutton_R(fujiF.xingnengF,{"关闭Slug字体特效","关闭10.0之后增加的Slug字体特效。一种新的字体渲染引擎，主要为了改善浮动信息以及姓名板名字效果。但是此功能会导致额外加载时间，某些情况还会导致第一次进战斗卡顿一下"},true)
fujiF.xingnengF.offnewfont:HookScript("OnClick", function (self)
	if self:GetChecked() then
		SetCVar("UseSlug","0")
		PIGA["Common"]["Offnewfont"]=true
	else
		SetCVar("UseSlug","1")
		PIGA["Common"]["Offnewfont"]=false
	end
end);
-----战斗日志
local Opentiaojian = {[1]="只在"..GUILD_CHALLENGE_TYPE2.."记录",[2]="只在"..DUNGEONS.."记录",[3]="只在"..DUNGEONS.."/"..GUILD_CHALLENGE_TYPE2.."记录"}
function CommonInfo.Commonfun.CombatLog_tjian()
	if PIGA["Common"]["AutoCombatLogTJ"]==4 then PIGA["Common"]["AutoCombatLogTJ"]=1 end
end
--桌面提示
local WCL = PIGFrame(UIParent,{"TOP",UIParent,"TOP",0,0},{54,20},"WCL_OpenUI")
WCL:PIGSetMovable()
WCL:Hide()
WCL.Tex = WCL:CreateTexture(nil, "BORDER");
WCL.Tex:SetTexture("interface/common/indicator-gray.blp");
WCL.Tex:SetPoint("LEFT",WCL,"LEFT",0,-1);
WCL.Tex:SetSize(18,18);
WCL.t = PIGFontString(WCL,{"LEFT",WCL,"LEFT",18,0},"WCL","OUTLINE")
function WCL:Update_Time()
	if ( LoggingCombat() ) then
		self.Tex:SetTexture("interface/common/indicator-green.blp");
	else
		self.Tex:SetTexture("interface/common/indicator-gray.blp");
	end
end
local function CombatLog_Open()
	if ( not LoggingCombat() ) then
		LoggingCombat(true) 
		--PIGinfotip:TryDisplayMessage(START..COMBAT_LOG)
		DEFAULT_CHAT_FRAME:AddMessage(COMBATLOGENABLED, 1, 1, 0, 1);
	end
	WCL:Update_Time()
end
local function CombatLog_Stop()
	if ( LoggingCombat() ) then
		LoggingCombat(false) 
		--PIGinfotip:TryDisplayMessage(DISABLE..COMBAT_LOG)
		DEFAULT_CHAT_FRAME:AddMessage(COMBATLOGDISABLED, 1, 1, 0, 1);
	end
	WCL:Update_Time()
end
local function AutoCombatLog()
	if GetCVar("advancedCombatLogging")=="1" then
		if PIGA["Common"]["AutoCombatLog"] then	
			local name, instanceType, difficultyID, difficultyName, maxPlayers = GetInstanceInfo()
			if PIGA["Common"]["AutoCombatLogTJ"]==3 then
				if instanceType=="party" or instanceType=="raid" then
					CombatLog_Open()
				else
					CombatLog_Stop()
				end
				return
			elseif PIGA["Common"]["AutoCombatLogTJ"]==1 then
				if instanceType=="raid" or maxPlayers>5 then
					CombatLog_Open()
				else
					CombatLog_Stop()
				end
				return
			elseif PIGA["Common"]["AutoCombatLogTJ"]==2 then
				if instanceType=="party" then
					CombatLog_Open()
				else
					CombatLog_Stop()
				end
				return
			end
			CombatLog_Stop()
		end
	else
		CombatLog_Stop()
	end
end
local function WCL_Show()
	if PIGA["Common"]["AutoCombatLog"] and GetCVar("advancedCombatLogging")=="1" then
		WCL:Show()
	else
		WCL:Hide()
	end
end
local function CombatLog_Set()
	WCL_Show()
	if ( LoggingCombat() ) then
		fujiF.xingnengF.CombatLog.Opentj.on:SetText("正在记录")
		fujiF.xingnengF.CombatLog.Opentj.on:SetTextColor(0, 1, 0, 1)
	else
		fujiF.xingnengF.CombatLog.Opentj.on:SetText("未记录")
		fujiF.xingnengF.CombatLog.Opentj.on:SetTextColor(1, 0, 0, 1)
	end
end
local function gengxinONOFF()
	fujiF.xingnengF.Advanced_CombatLog:SetChecked(false);
	fujiF.xingnengF.CombatLog:SetChecked(PIGA["Common"]["AutoCombatLog"]);
	fujiF.xingnengF.CombatLog.Opentj:PIGDownMenu_SetText(Opentiaojian[PIGA["Common"]["AutoCombatLogTJ"]])
	fujiF.xingnengF.CombatLog:Disable()
	if GetCVar("advancedCombatLogging")=="1" then
		fujiF.xingnengF.Advanced_CombatLog:SetChecked(true);
		fujiF.xingnengF.CombatLog:Enable()
	end
	CombatLog_Set()
end
fujiF.xingnengF.Advanced_CombatLog =PIGCheckbutton_R(fujiF.xingnengF,{ENABLE..ADVANCED_COMBAT_LOGGING,ENABLE..ADVANCED_COMBAT_LOGGING},true)
fujiF.xingnengF.Advanced_CombatLog.tt = PIGFontString(fujiF.xingnengF.Advanced_CombatLog,{"LEFT",fujiF.xingnengF.Advanced_CombatLog.Text,"RIGHT",2,0},"《"..ENABLE..ADVANCED_COMBAT_LOGGING.."才可自动记录WCL》");
fujiF.xingnengF.Advanced_CombatLog.tt:SetTextColor(1, 0, 0, 1)
fujiF.xingnengF.Advanced_CombatLog:SetScript("OnClick", function (self)
	if self:GetChecked() then
		SetCVar("advancedCombatLogging", "1")
	else
		SetCVar("advancedCombatLogging", "0")
	end
	AutoCombatLog()
	C_Timer.After(1,gengxinONOFF)
end);
fujiF.xingnengF.CombatLog =PIGCheckbutton_R(fujiF.xingnengF,{"自动"..START.."WCL"..COMBAT_LOG,"根据预设条件自动"..START..COMBAT_LOG},true)
fujiF.xingnengF.CombatLog:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Common"]["AutoCombatLog"]=true
	else
		PIGA["Common"]["AutoCombatLog"]=false
	end
	AutoCombatLog()
	C_Timer.After(1,gengxinONOFF)
end);
fujiF.xingnengF.CombatLog.Opentj=PIGDownMenu(fujiF.xingnengF.CombatLog,{"LEFT",fujiF.xingnengF.CombatLog.Text,"RIGHT",4,0},{210,nil})
fujiF.xingnengF.CombatLog.Opentj.tt = PIGFontString(fujiF.xingnengF.CombatLog.Opentj,{"LEFT",fujiF.xingnengF.CombatLog.Opentj,"RIGHT",10,0},"当前状态:");
fujiF.xingnengF.CombatLog.Opentj.on = PIGFontString(fujiF.xingnengF.CombatLog.Opentj,{"LEFT",fujiF.xingnengF.CombatLog.Opentj.tt,"RIGHT",4,0},"","OUTLINE",15);
function fujiF.xingnengF.CombatLog.Opentj:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#Opentiaojian,1 do
	    info.text, info.arg1 = Opentiaojian[i], i
	    info.checked = i==PIGA["Common"]["AutoCombatLogTJ"]
		fujiF.xingnengF.CombatLog.Opentj:PIGDownMenu_AddButton(info)
	end 
end
function fujiF.xingnengF.CombatLog.Opentj:PIGDownMenu_SetValue(value,arg1,arg2)
	fujiF.xingnengF.CombatLog.Opentj:PIGDownMenu_SetText(value)
	PIGA["Common"]["AutoCombatLogTJ"]=arg1
	PIGCloseDropDownMenus()
	AutoCombatLog()
	C_Timer.After(1,gengxinONOFF)
end
fujiF.xingnengF.CombatLog.tishiP=PIGButton(fujiF.xingnengF.CombatLog,{"LEFT",fujiF.xingnengF.CombatLog,"RIGHT",520,0},{50,20},"重置")
PIGEnter(fujiF.xingnengF.CombatLog.tishiP,"|cffFF0000重置|r桌面提示图标的位置")
fujiF.xingnengF.CombatLog.tishiP:SetScript("OnClick", function ()
	WCL:ClearAllPoints();
	WCL:SetPoint("TOP",UIParent,"TOP",0,0);
end);
--系统设置---------
fujiF.xitongF=PIGFrame(fujiF,{"BOTTOMLEFT", fujiF, "BOTTOMLEFT", 0, 0})
fujiF.xitongF:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", 0, 0);
fujiF.xitongF:SetHeight(60)
PIGLine(fujiF.xitongF,"TOP",0,nil,{0,-340})
PIGLine(fujiF.xitongF,"TOP",0,nil,{340,0})
fujiF.xitongF.ScaleT = PIGFontString(fujiF.xitongF,{"TOP",fujiF.xitongF,"TOP",0,7},SYSTEMOPTIONS_MENU..SETTINGS);
--UI缩放
fujiF.xitongF.Scale =PIGCheckbutton(fujiF.xitongF,{"TOPLEFT",fujiF.xitongF,"TOPLEFT",20,-20},{UI_SCALE,USE_UISCALE})
fujiF.xitongF.Scale:SetScript("OnClick", function (self)
	if self:GetChecked() then
		SetCVar("useUIScale","1")
	else
		SetCVar("useUIScale","0")
	end
end);
fujiF.xitongF.ScaleSlider = PIGSlider(fujiF.xitongF,{"LEFT",fujiF.xitongF.Scale.Text,"RIGHT",10,0}, {0.65, 1.15, 0.01,{["Right"]="%"}})
fujiF.xitongF.ScaleSlider.Slider:HookScript("OnValueChanged", function(self, arg1)
	if InCombatLockdown() then PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT) return end
	SetCVar("uiscale",arg1)
end)
--主音量
fujiF.xitongF.Volume =PIGFontString(fujiF.xitongF,{"TOPLEFT",fujiF.xitongF,"TOPLEFT",340,-20},MASTER_VOLUME)
fujiF.xitongF.Volume:SetTextColor(1, 1, 1, 1)
fujiF.xitongF.VolumeSlider = PIGSlider(fujiF.xitongF,{"LEFT",fujiF.xitongF.Volume,"RIGHT",10,0},{0, 1, 0.01,{["Right"]="%"}})
fujiF.xitongF.VolumeSlider.Slider:HookScript("OnValueChanged", function(self, arg1)
	SetCVar("Sound_MasterVolume",arg1)
end)
--
fujiF:HookScript("OnShow", function (self)
	self.QuestsEnd:SetChecked(PIGA["Common"]["QuestsEnd"]);
	self.QuestsEnd.xiala:PIGDownMenu_SetText(CommonInfo.AudioList[PIGA["Common"]["QuestsEndAudio"]][1])
	if tocversion<20000 then
		self.SHAMAN_Color:SetChecked(PIGA["Common"]["SHAMAN_Color"]);
	else
		self.SetFocus:SetChecked(PIGA["Common"]["SetFocus"]);
		self.SetFocus.xiala:PIGDownMenu_SetText(CommonInfo.SetKeyListName[PIGA["Common"]["SetFocusKEY"]])
		self.SetFocus.Mouse:SetChecked(PIGA["Common"]["SetFocusMouse"]);
		self.ClearFocus:SetChecked(PIGA["Common"]["ClearFocus"]);
	end	
	self.AutoCVars:SetChecked(PIGA["Common"]["AutoCVars"]);
	self.AutoLoot:SetChecked(PIGA["Common"]["AutoLoot"]);
	if self.AutoLoot.FastLoot then
		self.AutoLoot.FastLoot:SetChecked(PIGA["Common"]["FastLoot"]);
	end
	if PIGA["Common"]["Offnewfont"] then
		SetCVar("UseSlug","0")
		self.xingnengF.offnewfont:SetChecked(true)
	end
	--
	gengxinONOFF()
	self.xitongF.Scale:SetChecked(GetCVarBool("useUIScale"));
	self.xitongF.ScaleSlider:PIGSetValue(GetCVar("uiscale"))
	self.xitongF.VolumeSlider:PIGSetValue(GetCVar("Sound_MasterVolume"))
end);
---
fujiF:RegisterEvent("PLAYER_ENTERING_WORLD");
fujiF:SetScript("OnEvent",function (self,event,arg1,arg2)
	if event=="PLAYER_ENTERING_WORLD" then
		AutoCombatLog()
		WCL_Show()
	end
end)