local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create = addonTable.Create
local PIGFontString=Create.PIGFontString
--
local Fun=addonTable.Fun
local FasongYCqingqiu=Fun.FasongYCqingqiu
------------------------------
local UnitFramefun=addonTable.UnitFramefun
local function zhiyetubiao_Click(unit,button)
	if not InCombatLockdown() and UnitPlayerControlled(unit) and UnitIsConnected(unit) then
		--local canInspect = CanInspect(unit)
		--1 = Compare Achievements,比较成就28码
		--2 = Trade, 交易，8 码
		--3 = Duel, 决斗，7 码
		--4 = Follow, 跟随，28 码
		--5 = Pet-battle Duel,宠物战斗决斗，7 码
		local inRange = CheckInteractDistance(unit, 1)
		if inRange then
			if button=="LeftButton" then
				if tocversion<50000 then
					InspectUnit(unit); --10.0会造成天赋配置无法复制
				end
			elseif button=="RightButton" then
				InitiateTrade(unit);
			end
		else
			local cName=GetUnitName(unit, true)
			FasongYCqingqiu(cName)
		end
	end
end
UnitFramefun.zhiyetubiao_Click=zhiyetubiao_Click
function UnitFramefun.Mubiao()
	if PIGA["UnitFrame"]["TargetFrame"]["Plus"] and not UFP_Targetzhiyetubiao then
		if tocversion<20000 then
			--目标血量
			-- hooksecurefunc("TargetFrame_CheckClassification",function(self,lock)--银鹰标志
			-- 	if not lock and UnitClassification(self.unit)=="rareelite" then
			-- 		self.borderTexture:SetTexture("Interface/TargetingFrame/UI-TargetingFrame-Rare-Elite");
			-- 	end
			-- end);
			local function SetupStatusBarText(bar,parent)
				local text=parent:CreateFontString(nil,"OVERLAY","TextStatusBarText")
				local left=parent:CreateFontString(nil,"OVERLAY","TextStatusBarText")
				local right=parent:CreateFontString(nil,"OVERLAY","TextStatusBarText");

				text:SetPoint("CENTER",bar,"CENTER");
				left:SetPoint("LEFT",bar,"LEFT",2,0);
				right:SetPoint("RIGHT",bar,"RIGHT",-2,0);
				bar.TextString,bar.LeftText,bar.RightText=text,left,right;
			end
			SetupStatusBarText(TargetFrameHealthBar,TargetFrameTextureFrame);
			SetupStatusBarText(TargetFrameManaBar,TargetFrameTextureFrame);

			TargetHealthDB = TargetHealthDB or { version=1, forcePercentages=false }
			TargetHealthDB.forcePercentages = true
			local function HealthBar_Update(statusbar, unit)
			    if ( not statusbar or statusbar.lockValues ) then
			        return;
			    end
			    if ( unit == statusbar.unit ) then
			        TargetHealthDB.maxValue = UnitHealthMax(unit);
			        statusbar.showPercentage = false;
			        statusbar.forceHideText = false;
			        if ( TargetHealthDB.maxValue == 0 ) then
			            TargetHealthDB.maxValue = 1;
			            statusbar.forceHideText = true;
			        elseif ( TargetHealthDB.maxValue == 100 and not ShouldKnowUnitHealth(unit) ) then
			            if TargetHealthDB.forcePercentages then
			                statusbar.showPercentage = true;
			            end
			        end
			    end
			    TextStatusBar_UpdateTextString(statusbar);
			end
			hooksecurefunc("UnitFrameHealthBar_Update", HealthBar_Update)
		elseif tocversion<30000 then
			TargetHealthDB = TargetHealthDB or { version=1, forcePercentages=false }
			TargetHealthDB.forcePercentages = true
			local function HealthBar_Update(statusbar, unit)
			    if ( not statusbar or statusbar.lockValues ) then
			        return;
			    end
			    if ( unit == statusbar.unit ) then
			        TargetHealthDB.maxValue = UnitHealthMax(unit);
			        statusbar.showPercentage = false;
			        statusbar.forceHideText = false;
			        if ( TargetHealthDB.maxValue == 0 ) then
			            TargetHealthDB.maxValue = 1;
			            statusbar.forceHideText = true;
			        elseif ( TargetHealthDB.maxValue == 100 and not ShouldKnowUnitHealth(unit) ) then
			            if TargetHealthDB.forcePercentages then
			                statusbar.showPercentage = true;
			            end
			        end
			    end
			    TextStatusBar_UpdateTextString(statusbar);
			end
			hooksecurefunc("UnitFrameHealthBar_Update", HealthBar_Update)
		end
		---目标职业图标
		TargetFrame.zhiyetubiao = CreateFrame("Button", "UFP_Targetzhiyetubiao", TargetFrame);
		TargetFrame.zhiyetubiao:SetSize(32,32);
		TargetFrame.zhiyetubiao:ClearAllPoints();
		TargetFrame.zhiyetubiao:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 119, 3);
		TargetFrame.zhiyetubiao:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");
		TargetFrame.zhiyetubiao:Hide()
		if tocversion<50000 then
			TargetFrame.zhiyetubiao:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 119, 3);
		else
			TargetFrame.zhiyetubiao:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 144, 4);
			TargetFrame.zhiyetubiao:SetFrameLevel(505)
		end

		TargetFrame.zhiyetubiao.Border = TargetFrame.zhiyetubiao:CreateTexture(nil, "OVERLAY");
		TargetFrame.zhiyetubiao.Border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder");
		TargetFrame.zhiyetubiao.Border:SetSize(54,54);
		TargetFrame.zhiyetubiao.Border:ClearAllPoints();
		TargetFrame.zhiyetubiao.Border:SetPoint("CENTER", 11, -12);

		TargetFrame.zhiyetubiao.Icon = TargetFrame.zhiyetubiao:CreateTexture(nil, "ARTWORK");
		TargetFrame.zhiyetubiao.Icon:SetSize(24,24);
		TargetFrame.zhiyetubiao.Icon:ClearAllPoints();
		TargetFrame.zhiyetubiao.Icon:SetPoint("CENTER",1,-1);
		--点击功能：左交易/右观察
		Fun.ActionFun.PIGUseKeyDown(TargetFrame.zhiyetubiao)
		TargetFrame.zhiyetubiao:HookScript("OnClick", function (self,button)
			zhiyetubiao_Click(TargetFrame.unit,button)
		end);

		--目标种族/生物类型
		TargetFrame.mubiaoLX = CreateFrame("Frame", nil, TargetFrame);
		TargetFrame.mubiaoLX:SetSize(68,18);
		if tocversion<50000 then
			TargetFrame.mubiaoLX:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 52, -3);
		else
			TargetFrame.mubiaoLX:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 64, -3);
		end
		TargetFrame.mubiaoLX.title = PIGFontString(TargetFrame.mubiaoLX,{"RIGHT", TargetFrame.mubiaoLX, "RIGHT", 0, 0},"", "OUTLINE",14.4)
		TargetFrame.mubiaoLX.title:SetTextColor(0,1,1,1);
		--
		TargetFrame:HookScript("OnEvent", function (self,event)
			if event=="PLAYER_ENTERING_WORLD" or event=="PLAYER_TARGET_CHANGED" then
				--职业图标
				if UnitIsPlayer("target") then --判断是否为玩家
					local raceText = UnitRace("target");	
					TargetFrame.mubiaoLX.title:SetText(raceText);
					local IconCoord = CLASS_ICON_TCOORDS[select(2,UnitClass("target"))];
					if IconCoord then
						TargetFrame.zhiyetubiao.Icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles");
						TargetFrame.zhiyetubiao.Icon:SetTexCoord(unpack(IconCoord));--切出子区域
					end
					TargetFrame.zhiyetubiao:Show()
				else
					local creatureType = UnitCreatureType("target")
					TargetFrame.mubiaoLX.title:SetText(creatureType);
					TargetFrame.zhiyetubiao:Hide()
				end;
			end
		end);
		--目标生命百分比
		TargetFrame.mubiaoHP=CreateFrame("Frame",nil,TargetFrame);
		if tocversion<50000 then
			TargetFrame.mubiaoHP:SetPoint("RIGHT",TargetFrame,"LEFT",5,-2);
		else
			TargetFrame.mubiaoHP:SetPoint("RIGHT",TargetFrame,"LEFT",24,-2);
		end
		TargetFrame.mubiaoHP:SetSize(49,22);
		TargetFrame.mubiaoHP.title = PIGFontString(TargetFrame.mubiaoHP,{"TOPRIGHT", TargetFrame.mubiaoHP, "TOPRIGHT", 0, 0},"", "OUTLINE",13)
		TargetFrame.mubiaoHP.title:SetTextColor(1, 1, 0.47,1);
		----------------------
		TargetFrame:HookScript("OnEvent", function (self,event,arg1)
			if event=="PLAYER_ENTERING_WORLD" or event=="PLAYER_TARGET_CHANGED" or event=="UNIT_HEALTH" or event=="UNIT_AURA" then
				local mubiaoH = UnitHealth("target")
				local mubiaoHmax = UnitHealthMax("target")
				local mubiaobaifenbi = math.ceil((mubiaoH/mubiaoHmax)*100);--目标血量百分比
				if mubiaoHmax>0 then
					TargetFrame.mubiaoHP.title:SetText(mubiaobaifenbi..'%');
				else
					TargetFrame.mubiaoHP.title:SetText('??%');
				end
			end
		end)
	end
	--目标仇恨百分比
	if PIGA["UnitFrame"]["TargetFrame"]["Chouhen"] then
		if TargetFrame.threatNumericIndicator then
			SetCVar("threatShowNumeric", "1")
			TargetFrame:HookScript("OnEvent", function (self,event,arg1)
				if event=="PLAYER_ENTERING_WORLD" or event=="PLAYER_TARGET_CHANGED" or event=="UNIT_THREAT_LIST_UPDATE" or event=="UNIT_THREAT_SITUATION_UPDATE" then
					if tocversion<100000 then
						TargetFrame.threatNumericIndicator:SetPoint("BOTTOM", TargetFrame, "TOP", -86, -22);
					else
						TargetFrame.threatNumericIndicator:SetPoint("BOTTOM", TargetFrame, "TOP", -68, -24);
					end
				end
			end)
		else
			if not TargetFrame.mubiaoCHbaifenbi then
				TargetFrame.mubiaoCHbaifenbi=CreateFrame("Frame",nil,TargetFrame);
				TargetFrame.mubiaoCHbaifenbi:SetPoint("TOPLEFT",TargetFrame,"TOPLEFT",7,0);
				TargetFrame.mubiaoCHbaifenbi:SetSize(49,22);
				TargetFrame.mubiaoCHbaifenbi:Hide();
				TargetFrame.mubiaoCHbaifenbi.Background=TargetFrame.mubiaoCHbaifenbi:CreateTexture(nil,"BACKGROUND");
				TargetFrame.mubiaoCHbaifenbi.Background:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
				TargetFrame.mubiaoCHbaifenbi.Background:SetPoint("TOP",0,-3);
				TargetFrame.mubiaoCHbaifenbi.Background:SetSize(37,18);
				TargetFrame.mubiaoCHbaifenbi.border=TargetFrame.mubiaoCHbaifenbi:CreateTexture(nil,"ARTWORK");
				TargetFrame.mubiaoCHbaifenbi.border:SetTexture("Interface\\TargetingFrame\\NumericThreatBorder");
				TargetFrame.mubiaoCHbaifenbi.border:SetTexCoord(0,0.765625,0,0.5625);
				TargetFrame.mubiaoCHbaifenbi.border:SetAllPoints(TargetFrame.mubiaoCHbaifenbi);
				TargetFrame.mubiaoCHbaifenbi.title = PIGFontString(TargetFrame.mubiaoCHbaifenbi,{"CENTER", TargetFrame.mubiaoCHbaifenbi, "CENTER", 1, -1.4},"", "OUTLINE",13)
				TargetFrame.mubiaoCHbaifenbi.title:SetTextColor(1,1,1,1);
				--仇恨高亮背景
				TargetFrame.mubiaoCHbaifenbi_REDALL=TargetFrame:CreateTexture(nil,"BACKGROUND");
				TargetFrame.mubiaoCHbaifenbi_REDALL:SetTexture("interface/targetingframe/ui-targetingframe-flash.blp");
				if tocversion<20000 then
					TargetFrame.mubiaoCHbaifenbi_REDALL:SetTexCoord(0.09,1,0,0.194);
					TargetFrame.mubiaoCHbaifenbi_REDALL:SetPoint("TOPLEFT",TargetFrameTextureFrame,"TOPLEFT",0,0);
					TargetFrame.mubiaoCHbaifenbi_REDALL:SetPoint("BOTTOMRIGHT",TargetFrameTextureFrame,"BOTTOMRIGHT",0,0);
				elseif tocversion<30000 then
					TargetFrame.mubiaoCHbaifenbi_REDALL:SetPoint("TOPLEFT",TargetFrameTextureFrame,"TOPLEFT",-23,0);
				else
					TargetFrame.mubiaoCHbaifenbi_REDALL:SetTexCoord(0.09,1,0,0.194);
					TargetFrame.mubiaoCHbaifenbi_REDALL:SetPoint("TOPLEFT",TargetFrameTextureFrame,"TOPLEFT",0,0);
					TargetFrame.mubiaoCHbaifenbi_REDALL:SetPoint("BOTTOMRIGHT",TargetFrameTextureFrame,"BOTTOMRIGHT",0,0);
				end
				TargetFrame.mubiaoCHbaifenbi_REDALL:SetVertexColor(1,0,0);
				TargetFrame.mubiaoCHbaifenbi_REDALL:Hide();
				---
				-- local YuanshiW=TargetFrame.nameBackground:GetWidth();
				-- TargetFrame.nameBackground:ClearAllPoints();
				-- TargetFrame.nameBackground:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 7, -22);
				--
				TargetFrame:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE","target");--怪物仇恨列表目录改变
				TargetFrame:HookScript("OnEvent", function (self,event,arg1)
					if event=="PLAYER_TARGET_CHANGED" or event=="UNIT_THREAT_LIST_UPDATE" then
						if not (UnitIsPlayer("target")) and UnitCanAttack("player", "target") then --不是玩家/可攻击		
							local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")
							if threatpct==nil then --进度条
								--self.nameBackground:SetWidth(YuanshiW);
								TargetFrame.mubiaoCHbaifenbi.title:SetText('0%');
							else
								--self.nameBackground:SetWidth(YuanshiW*(threatpct/100));
								if isTanking then
									TargetFrame.mubiaoCHbaifenbi.title:SetText('Tank');
								else
									TargetFrame.mubiaoCHbaifenbi.title:SetText(math.ceil(threatpct)..'%');
								end	
							end
							if status==0 then --进度条/百分比材质颜色
								TargetFrame.mubiaoCHbaifenbi_REDALL:Hide();
								--self.nameBackground:SetVertexColor(0.69, 0.69, 0.69);
								TargetFrame.mubiaoCHbaifenbi:Show();
								TargetFrame.mubiaoCHbaifenbi.Background:SetVertexColor(0.69, 0.69, 0.69);
							elseif status==1 then
								TargetFrame.mubiaoCHbaifenbi_REDALL:Hide();
								--self.nameBackground:SetVertexColor(1, 1, 0.47);
								TargetFrame.mubiaoCHbaifenbi:Show();
								TargetFrame.mubiaoCHbaifenbi.Background:SetVertexColor(1, 1, 0.47);
							elseif status==2 then
								TargetFrame.mubiaoCHbaifenbi_REDALL:Show();
								--self.nameBackground:SetVertexColor(1, 0.6, 0);
								TargetFrame.mubiaoCHbaifenbi:Show();
								TargetFrame.mubiaoCHbaifenbi.Background:SetVertexColor(1, 0.6, 0);
								--PlaySoundFile("sound/item/weapons/sword1h/m1hswordhitmetalshieldcrit.ogg", "Master")
							elseif status==3 then
								TargetFrame.mubiaoCHbaifenbi_REDALL:Show();
								--self.nameBackground:SetVertexColor(1, 0, 0);
								TargetFrame.mubiaoCHbaifenbi:Show();
								TargetFrame.mubiaoCHbaifenbi.Background:SetVertexColor(1, 0, 0);
								--PlaySoundFile("sound/item/weapons/sword1h/m1hswordhitmetalshieldcrit.ogg", "Master")		
							elseif status==nil then
								TargetFrame.mubiaoCHbaifenbi_REDALL:Hide();
								if ( not UnitPlayerControlled(self.unit) and UnitIsTapDenied(self.unit) ) then
									--self.nameBackground:SetVertexColor(0.5, 0.5, 0.5);
									if ( self.portrait ) then
										self.portrait:SetVertexColor(0.5, 0.5, 0.5);
									end
								else
									--self.nameBackground:SetVertexColor(UnitSelectionColor(self.unit));
									if ( self.portrait ) then
										self.portrait:SetVertexColor(1.0, 1.0, 1.0);
									end
								end
								TargetFrame.mubiaoCHbaifenbi:Hide();
							end
						else
							--self.nameBackground:SetWidth(YuanshiW);
							TargetFrame.mubiaoCHbaifenbi_REDALL:Hide();
							TargetFrame.mubiaoCHbaifenbi:Hide();
						end
					end
				end)
			end
		end
	end
	-----目标的目标的目标
	if PIGA["UnitFrame"]["TargetFrame"]["ToToToT"] and not TargetFrameToT_ToT then	
		SetCVar("showTargetOfTarget","1")
		local unitMubiao = "targettargettarget"
		local fuF=TargetFrameToT
		fuF.TTT = CreateFrame("Button", "TargetFrameToT_ToT", fuF, "TargetofTargetFrameTemplate");
		fuF.TTT:SetFrameLevel(fuF:GetFrameLevel() + 5);
		fuF.TTT:ClearAllPoints();
		fuF.TTT:SetPoint("TOPRIGHT", fuF, "BOTTOMRIGHT", 69, 4);
		fuF.TTT:UnregisterAllEvents()
		fuF.TTT:SetScript("OnShow", nil)
		fuF.TTT:SetScript("OnHide", nil)
		fuF.TTT:SetScript("OnUpdate", nil)
		
		if tocversion<50000 then
			fuF.TTT.healthbar =  _G["TargetFrameToT_ToTHealthBar"]
			fuF.TTT.manabar =  _G["TargetFrameToT_ToTManaBar"]
			fuF.TTT.portrait =_G["TargetFrameToT_ToTPortrait"]
			fuF.TTT.name = _G["TargetFrameToT_ToTTextureFrameName"]
			fuF.TTT.deadText = _G["TargetFrameToT_ToTTextureFrameDeadText"]
			fuF.TTT.unconsciousText = _G["TargetFrameToT_ToTTextureFrameUnconsciousText"]
			fuF.TTT.healthbar.unit=unitMubiao
			fuF.TTT.healthbar.unitFrame=fuF.TTT
			fuF.TTT.manabar.unit=unitMubiao
			fuF.TTT.manabar.unitFrame=fuF.TTT
		else
			fuF.TTT.HealthBar.unit=unitMubiao
			fuF.TTT.HealthBar.unitFrame=fuF.TTT
			fuF.TTT.ManaBar.unit=unitMubiao
			fuF.TTT.ManaBar.unitFrame=fuF.TTT
		end
		fuF.TTT.unit=unitMubiao
		fuF.TTT:SetAttribute("*type1", "target")
		fuF.TTT:SetAttribute("unit", unitMubiao)
		RegisterUnitWatch(fuF.TTT)

		function fuF.TTT:CheckDead()
			if ((UnitHealth(self.unit) <= 0) and UnitIsConnected(self.unit)) then
				local unitIsUnconscious = UnitIsUnconscious(self.unit);
				self.HealthBar.UnconsciousText:SetShown(unitIsUnconscious);
				self.HealthBar.DeadText:SetShown(not unitIsUnconscious);
			else
				self.HealthBar.DeadText:Hide();
				self.HealthBar.UnconsciousText:Hide();
			end
		end
		function TargetFrame_CheckDead (self)
			if ( (UnitHealth(self.unit) <= 0) and UnitIsConnected(self.unit) ) then
				if ( UnitIsUnconscious(self.unit) ) then
					self.unconsciousText:Show();
					self.deadText:Hide();
				else
					self.unconsciousText:Hide();
					self.deadText:Show();
				end
			else
				self.deadText:Hide();
				self.unconsciousText:Hide();
			end
		end
		function TargetofTargetHealthCheck(self)
			if ( UnitIsPlayer(self.unit) ) then
				local unitHPMin, unitHPMax, unitCurrHP;
				unitHPMin, unitHPMax = self.healthbar:GetMinMaxValues();
				unitCurrHP = self.healthbar:GetValue();
				self.unitHPPercent = unitCurrHP / unitHPMax;
				if ( UnitIsDead(self.unit) ) then
					self.portrait:SetVertexColor(0.35, 0.35, 0.35, 1.0);
				elseif ( UnitIsGhost(self.unit) ) then
					self.portrait:SetVertexColor(0.2, 0.2, 0.75, 1.0);
				elseif ( (self.unitHPPercent > 0) and (self.unitHPPercent <= 0.2) ) then
					self.portrait:SetVertexColor(1.0, 0.0, 0.0);
				else
					self.portrait:SetVertexColor(1.0, 1.0, 1.0, 1.0);
				end
			else
				self.portrait:SetVertexColor(1.0, 1.0, 1.0, 1.0);
			end
		end
		function fuF.TTT:HealthCheck()
			if (UnitIsPlayer(self.unit)) then
				local _, unitHPMax = self.HealthBar:GetMinMaxValues();
				local unitCurrHP = self.HealthBar:GetValue();
				self.unitHPPercent = unitCurrHP / unitHPMax;
				if (UnitIsDead(self.unit)) then
					self.Portrait:SetVertexColor(0.35, 0.35, 0.35, 1.0);
				elseif (UnitIsGhost(self.unit)) then
					self.Portrait:SetVertexColor(0.2, 0.2, 0.75, 1.0);
				elseif ((self.unitHPPercent > 0) and (self.unitHPPercent <= 0.2)) then
					self.Portrait:SetVertexColor(1.0, 0.0, 0.0);
				else
					self.Portrait:SetVertexColor(1.0, 1.0, 1.0, 1.0);
				end
			end
		end
		-- if InCombatLockdown() then
		-- 	fuF.TTT:RegisterEvent("PLAYER_REGEN_ENABLED");
		-- end
		--fuF.TTT:RegisterEvent("UNIT_HEALTH");
		fuF.TTT:RegisterUnitEvent("UNIT_HEALTH",unitMubiao);
		fuF.TTT:RegisterUnitEvent("UNIT_TARGET","target");
		fuF.TTT:RegisterUnitEvent("UNIT_TARGET","targettarget");
		fuF.TTT:RegisterUnitEvent("UNIT_AURA", unit);
		fuF.TTT:RegisterUnitEvent("UNIT_TARGET",unitMubiao);
		fuF.TTT:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE",unitMubiao);
		fuF.TTT:SetScript("OnEvent", function (self,event,arg1)
			local TTTname = UnitName(self.unit)
			if tocversion<50000 then
				self.name:SetText(TTTname);
				SetPortraitTexture(self.portrait, self.unit)
				TargetofTargetHealthCheck(self)
				TargetFrame_CheckDead(self);
				UnitFrameHealthBar_Update(self.healthbar, self.unit);
				UnitFrameManaBar_Update(self.manabar, self.unit);
			else
				self.Name:SetText(TTTname);
				SetPortraitTexture(self.Portrait, self.unit)
				self:HealthCheck()
				self:CheckDead()
				UnitFrameHealthBar_Update(self.HealthBar, self.unit);
				UnitFrameManaBar_Update(self.ManaBar, self.unit);
			end
			-- if event=="PLAYER_REGEN_ENABLED" then
			-- 	self:UnregisterEvent("PLAYER_REGEN_ENABLED");
			-- end
		end)
		if tocversion<50000 then
			fuF.TTT.healthbar:RegisterUnitEvent("UNIT_HEALTH",unitMubiao);
			fuF.TTT.healthbar:RegisterUnitEvent("UNIT_MAXHEALTH",unitMubiao);
			fuF.TTT.manabar:RegisterUnitEvent("UNIT_POWER_FREQUENT",unitMubiao);
			fuF.TTT.manabar:RegisterUnitEvent("UNIT_MAXPOWER",unitMubiao);
			fuF.TTT.healthbar:HookScript("OnEvent", function (self,event)
				UnitFrameHealthBar_Update(self, unitMubiao);
			end)
			fuF.TTT.manabar:HookScript("OnEvent", function (self,event)
				UnitFrameManaBar_Update(self, unitMubiao);
			end)
		else
			fuF.TTT.HealthBar:RegisterUnitEvent("UNIT_HEALTH",unitMubiao);
			fuF.TTT.HealthBar:RegisterUnitEvent("UNIT_MAXHEALTH",unitMubiao);
			fuF.TTT.ManaBar:RegisterUnitEvent("UNIT_POWER_FREQUENT",unitMubiao);
			fuF.TTT.ManaBar:RegisterUnitEvent("UNIT_MAXPOWER",unitMubiao);
			fuF.TTT.HealthBar:HookScript("OnEvent", function (self,event)
				UnitFrameHealthBar_Update(self, unitMubiao);
			end)
			fuF.TTT.ManaBar:HookScript("OnEvent", function (self,event)
				UnitFrameManaBar_Update(self, unitMubiao);
			end)
		end
	end
	--
	if PIGA["UnitFrame"]["TargetFrame"]["Yisu"] and not TargetFrame.yisuF then
		TargetFrame.yisuF=CreateFrame("Frame",nil,TargetFrame);
		TargetFrame.yisuF:SetSize(49,18);
		if tocversion<50000 then
			TargetFrame.yisuF:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 192, -58);
			TargetFrame.yisuF:SetFrameLevel(9)
		else
			TargetFrame.yisuF:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 206, -38);
			TargetFrame.yisuF:SetFrameLevel(505)
		end
		TargetFrame.yisuF.Tex = TargetFrame.yisuF:CreateTexture("Frame_Texture_UI", "ARTWORK");
		TargetFrame.yisuF.Tex:SetTexture("interface/icons/ability_rogue_sprint.blp");
		TargetFrame.yisuF.Tex:SetSize(16,16);
		TargetFrame.yisuF.Tex:SetPoint("LEFT", TargetFrame.yisuF, "LEFT", 0, 0);
		TargetFrame.yisuT = PIGFontString(TargetFrame.yisuF,{"LEFT", TargetFrame.yisuF.Tex, "RIGHT", 0, 0},"", "OUTLINE")
		TargetFrame.yisuT:SetTextColor(1,1,1,1);
		TargetFrame.yisuF:HookScript("OnUpdate", function ()
			local currentSpeed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed("target");
			TargetFrame.yisuT:SetText(Round(((currentSpeed/7)*100))..'%')
		end)
	end
end