local addonName, addonTable = ...;
local L=addonTable.locale
---
local Create=addonTable.Create
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList=Create.PIGOptionsList
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGFontStringBG=Create.PIGFontStringBG
local PIGEnter=Create.PIGEnter
---
local ActionBarfun={}
addonTable.ActionBarfun=ActionBarfun
local fuFrame,fuFrameBut = PIGOptionsList(L["ACTION_TABNAME"],"TOP")
--
local RTabFrame =Create.PIGOptionsList_RF(fuFrame)
ActionBarfun.fuFrame=fuFrame
ActionBarfun.fuFrameBut=fuFrameBut
ActionBarfun.RTabFrame=RTabFrame
--
local ActionF,Actiontabbut =PIGOptionsList_R(RTabFrame,L["ACTION_TABNAME1"],70)
ActionF:Show()
Actiontabbut:Selected()
--------
local function ActionBar_Ranse()
	if not PIGA["ActionBar"]["Ranse"] then return end
	if ActionButton_UpdateRangeIndicator then
		hooksecurefunc("ActionButton_UpdateRangeIndicator", function(self, checksRange, inRange)
			if self.action == nil then return end
			local isUsable, notEnoughMana = IsUsableAction(self.action)
			local act_icon=self.icon or _G[self:GetName().."Icon"]
			if ( checksRange and not inRange ) then
				act_icon:SetVertexColor(0.5, 0.1, 0.1)
			elseif isUsable ~= true or notEnoughMana == true then
				act_icon:SetVertexColor(0.4, 0.4, 0.4)
			else
				act_icon:SetVertexColor(1, 1, 1)
			end
		end)
	else
		hooksecurefunc("ActionButton_OnUpdate", function(self, elapsed)
			if self.rangeTimer == TOOLTIP_UPDATE_TIME and self.action then
				local range = false
				local act_icon=self.icon or _G[self:GetName().."Icon"]
				if IsActionInRange(self.action) == false and act_icon then 
					_G[self:GetName().."Icon"]:SetVertexColor(0.5, 0.1, 0.1)
					range = true
				end;
				if self.range ~= range and range == false then
					ActionButton_UpdateUsable(self)
				end;
				self.range = range
			end
		end)
	end
end
ActionF.Ranse=PIGCheckbutton_R(ActionF,{"技能范围着色","根据技能范围染色动作条按键颜色"})
ActionF.Ranse:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["ActionBar"]["Ranse"]=true;
		ActionBar_Ranse()
	else
		PIGA["ActionBar"]["Ranse"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
end);
local function ActionCD()
	if PIGA["ActionBar"]["ActionCD"] then
		SetCVar("countdownForCooldowns","1")
	else
		SetCVar("countdownForCooldowns","0")
	end
end
ActionF.Cooldowns=PIGCheckbutton_R(ActionF,{"显示冷却时间","显示动作条技能物品冷却时间"})
ActionF.Cooldowns:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["ActionBar"]["ActionCD"]=true;
	else
		PIGA["ActionBar"]["ActionCD"]=false;
	end
	ActionCD()
end);

if PIG_MaxTocversion(20000) then
	function ActionBarfun.ActionBar_Cailiao()
		if not PIGA["ActionBar"]["Cailiao"] then return end
		local function update_Count(text)
    		local xxxx = GetInventoryItemCount("player", 18)
	        if xxxx>1 then
	            text:SetText(xxxx)
	        else
	        	if GetInventoryItemTexture("player", 18) then
	            	text:SetText("1")
	            else
					text:SetText("|cffff00000|r")
	            end
	        end
        end
	    hooksecurefunc("ActionButton_UpdateCount", function(actionButton)
		    local action = actionButton.action
		    if ( HasAction(action) ) then
		    	local actiontype,spellID = GetActionInfo(action)
		    	if actiontype=="spell" and spellID==2764 or spellID==2567 then
		    		update_Count(actionButton.Count)
		   		else
				    if IsConsumableAction(action) then
				        local xxxx = GetActionCount(action)
				        local text = actionButton.Count
				        if xxxx>0 then
				            text:SetText(xxxx)
				        else
				            text:SetText("|cffff00000|r")
				        end
				    end
				end
			end
		end)
		local FrameUI = CreateFrame("Frame")
		FrameUI:RegisterEvent("PLAYER_ENTERING_WORLD");
		FrameUI:RegisterEvent("UNIT_INVENTORY_CHANGED");
		FrameUI:HookScript("OnEvent", function(self,event)
			if event == "UNIT_INVENTORY_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
				for k, frame in pairs(ActionBarButtonEventsFrame.frames) do
					local action = frame.action;
					if ( HasAction(action) ) then
						local actiontype,spellID = GetActionInfo(action)
				    	if actiontype=="spell" and spellID==2764 or spellID==2567 then
					        update_Count(frame.Count)
				   		end
				   	end
				end
			end
		end);
	end
	ActionF.Cailiao=PIGCheckbutton_R(ActionF,{"显示施法材料数量","在动作条上显示需要施法材料技能材料数量"})
	ActionF.Cailiao:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["ActionBar"]["Cailiao"]=true;
			ActionBarfun.ActionBar_Cailiao()
		else
			PIGA["ActionBar"]["Cailiao"]=false;
			PIG_OptionsUI.RLUI:Show()
		end
	end)
end
---
local function ActionBar_PetTishi()
	if not PIGA["ActionBar"]["PetTishi"] then return end
	local PetActionBarFrame=PetActionBarFrame or PetActionBar
	if PetActionBarFrame.yijiazai then return end
	PetActionBarFrame.yijiazai=true
	local _, classId = UnitClassBase("player");
	--职业编号1战士/2圣骑士/3猎人/4盗贼/5牧师/6死亡骑士/7萨满祭司/8法师/9术士/10武僧/11德鲁伊/12恶魔猎手
	if classId==3 or classId==9 then
		local chaofengjinengName={}
		if classId==3 then
			local spname= PIGGetSpellInfo(2649)
			table.insert(chaofengjinengName,spname)
		elseif classId==9 then
			if PIG_MaxTocversion() then
				local spname= PIGGetSpellInfo(3716)
				local spname1= PIGGetSpellInfo(33698)
				--local spname2= PIGGetSpellInfo(17735)
				table.insert(chaofengjinengName,spname)
				table.insert(chaofengjinengName,spname1)
				--table.insert(chaofengjinengName,spname2)
			else
				local spname= PIGGetSpellInfo(112042)
				table.insert(chaofengjinengName,spname)
			end
		end

		local Width,Height = 30,30;
		local tishibiaoti="|cff00FFFF"..addonName..L["ADDON_NAME"]..L["LIB_TIPS"]..": "
		local PETtips = CreateFrame("Frame", nil, PetActionBarFrame);
		PETtips:SetPoint("BOTTOM", PetActionBarFrame, "TOP", 0, 10);
		PETtips:SetSize(Width,Height);
		PETtips.Icon = PETtips:CreateTexture(nil, "ARTWORK");
		PETtips.Icon:SetTexture("interface/common/help-i.blp");
		if PIG_MaxTocversion() then
			PETtips.Icon:SetSize(Width*1.6,Height*1.6);
		else
			PETtips.Icon:SetSize(Width*1.2,Height*1.2);
		end
		PETtips.Icon:SetPoint("CENTER");
		PETtips:Hide()
		PETtips:RegisterEvent("PLAYER_ENTERING_WORLD")
		PETtips:RegisterEvent("PET_BAR_UPDATE")
		PETtips:RegisterUnitEvent("UNIT_AURA","pet");
		PETtips:SetScript("OnEvent",function(self,event)
			local hasUI, isHunterPet = HasPetUI()
			if hasUI then
				for x=4, 7 do
					for xx=1,#chaofengjinengName do
						local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(x);
						if name==chaofengjinengName[xx] then
							local inInstance = IsInInstance();
							if inInstance then
								if autoCastEnabled or texture==136222 then
									self:Show()
									self:SetPoint("BOTTOM", _G["PetActionButton"..x], "TOP", 0, 0);
									PIGEnter(self,tishibiaoti,"|cffFFFF00副本内开启宠物嘲讽可能干扰坦克仇恨！|r")
								else
									self:Hide()
								end
							else
								if not autoCastEnabled and texture==236295 then
									self:Show()
									self:SetPoint("BOTTOM", _G["PetActionButton"..x], "TOP", 0, 0);
									PIGEnter(self,tishibiaoti,"|cffFFFF00野外关闭宠物嘲讽可能造成宠物仇恨匮乏！|r")
								else
									self:Hide()
								end
							end
							return
						end
					end
				end
			end
		end)	
	end
end
local Pettooltip = "宠物动作条嘲讽技能上方增加一个提示按钮，副本内提示关闭宠物嘲讽/副本外提示开启！\r|cffFFff00（只对有宠物职业生效）|r";
ActionF.PetTishi=PIGCheckbutton_R(ActionF,{"宠物动作条嘲讽提示",Pettooltip})
ActionF.PetTishi:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["ActionBar"]["PetTishi"]=true;
		ActionBar_PetTishi()
	else
		PIGA["ActionBar"]["PetTishi"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
end)
--进入战斗时自动切换到1号动作栏
local zidongfanyeFFFF = CreateFrame("Frame")
zidongfanyeFFFF:HookScript("OnEvent", function()
	ChangeActionBarPage(1);
end)
local function ActionBar_AutoFanye()
	if PIGA["ActionBar"]["AutoFanye"] then
		zidongfanyeFFFF:RegisterEvent("PLAYER_REGEN_DISABLED");
	else
		zidongfanyeFFFF:UnregisterEvent("PLAYER_REGEN_DISABLED");
	end
end
ActionF.AutoFanye=PIGCheckbutton_R(ActionF,{"进战斗时切换1动作栏","进入战斗后自动切换到1号动作栏"})
ActionF.AutoFanye:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["ActionBar"]["AutoFanye"]=true;
	else
		PIGA["ActionBar"]["AutoFanye"]=false;
	end
	ActionBar_AutoFanye()
end)
if PIG_MaxTocversion() then
	local function xianshitutentiao()
		if InCombatLockdown() then return end
		MultiCastActionBarFrame_Update(MultiCastActionBarFrame)
		if ( HasMultiCastActionBar() ) then
			ShowMultiCastActionBar();
			LockMultiCastActionBar();
		else
			UnlockMultiCastActionBar();
			HideMultiCastActionBar();
		end
	end
	function ActionBarfun.xiufuShowAction()
		if PIGA["ActionBar"]["xiufuShowAction"] then
			local Showvalue = GetCVar("alwaysShowActionBars")
			if Showvalue=="0" then
				SetCVar("alwaysShowActionBars", "1")
				SetCVar("alwaysShowActionBars", "0")
			elseif Showvalue=="1" then
				SetCVar("alwaysShowActionBars", "0")
				SetCVar("alwaysShowActionBars", "1")
			end
			if MultiCastActionBarFrame then
				MultiCastActionBarFrame:HookScript("OnEvent", function (self,event)
					if event=="PLAYER_ENTERING_WORLD" then
						C_Timer.After(0.1,xianshitutentiao)
						C_Timer.After(0.3,xianshitutentiao)
						C_Timer.After(0.5,xianshitutentiao)
					end
				end)
			end
		end
	end
	ActionF.xiufuShowAction=PIGCheckbutton_R(ActionF,{"修复系统动作条BUG","1.修复萨满图腾条第一次登录不会正确显示问题\n2.修复系统设置当总是显示动作条关闭时，偶尔系统还是会显示空白动作条的问题"})
	ActionF.xiufuShowAction:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["ActionBar"]["xiufuShowAction"]=true;
		else
			PIGA["ActionBar"]["xiufuShowAction"]=false;
		end
		ActionBarfun.xiufuShowAction()
	end)
end

---=======
ActionF:HookScript("OnShow", function(self)
	self.Ranse:SetChecked(PIGA["ActionBar"]["Ranse"])
	if GetCVar("countdownForCooldowns")=="1" then
		self.Cooldowns:SetChecked(true);
	elseif GetCVar("countdownForCooldowns")=="0" then
		self.Cooldowns:SetChecked(false);
	end
	if self.Cailiao then
		self.Cailiao:SetChecked(PIGA["ActionBar"]["Cailiao"])
	end
	self.PetTishi:SetChecked(PIGA["ActionBar"]["PetTishi"])
	self.AutoFanye:SetChecked(PIGA["ActionBar"]["AutoFanye"])
	if self.xiufuShowAction then
		self.xiufuShowAction:SetChecked(PIGA["ActionBar"]["xiufuShowAction"])
	end		
end)
----------------
addonTable.ActionBar = function()
	ActionBar_Ranse()
	ActionCD()
	if ActionBarfun.ActionBar_Cailiao then ActionBarfun.ActionBar_Cailiao() end
	ActionBar_PetTishi()
	ActionBar_AutoFanye()
	if ActionBarfun.xiufuShowAction then ActionBarfun.xiufuShowAction() end
	if ActionBarfun.Pig_Action then ActionBarfun.Pig_Action() end
end