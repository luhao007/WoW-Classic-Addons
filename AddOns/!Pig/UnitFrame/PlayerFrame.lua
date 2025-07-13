local _, addonTable = ...;
local Create = addonTable.Create
local PIGFontString=Create.PIGFontString
---
local UnitFramefun=addonTable.UnitFramefun
-------------
local floor=math.floor
local function Update_Hp()
	if PlayerFrame.ziji then
		local HP = UnitHealth("player");	
		local HPmax = UnitHealthMax("player");
		PlayerFrame.ziji.HP:SetText(HP..'/'..HPmax);
		if HPmax>0 then
			PlayerFrame.ziji.Baifenbi:SetText(floor(((HP/HPmax)*100)).."%");
		end
	end
end
local function Update_Mp()
	if PlayerFrame.ziji then
		local MP = UnitPower("player");	
		local MPmax = UnitPowerMax("player");
		PlayerFrame.ziji.MP:SetText(MP..'/'..MPmax);
	end
end
local function Update_MaxHp()
	if PlayerFrame.ziji then
		Update_Hp()
		local HPmax = UnitHealthMax("player")
		if HPmax>999999 then
			PlayerFrame.ziji:SetWidth(126);
		elseif HPmax>99999 then
			PlayerFrame.ziji:SetWidth(110);
		elseif HPmax>9999 then
			PlayerFrame.ziji:SetWidth(96);
		else
			PlayerFrame.ziji:SetWidth(80);
		end
	end
end
local function Update_MaxMp()
	if PlayerFrame.ziji then
		Update_Mp()
		local powerType = UnitPowerType("player")
		local info = PowerBarColor[powerType]
		if info.r==0 and info.g==0 and info.b==1 then
			PlayerFrame.ziji.MP:SetTextColor(info.r, 0.7, info.b ,1)
		else
			PlayerFrame.ziji.MP:SetTextColor(info.r, info.g, info.b ,1)
		end
	end
end
local function HideHPMPTT()
	local function shuaxintoumingdu(toumingdu)
		if PIG_MaxTocversion() then
			PlayerFrameHealthBarText:SetAlpha(toumingdu);
			PlayerFrameManaBarText:SetAlpha(toumingdu);
			PetFrameHealthBarText:SetAlpha(toumingdu);
			PetFrameManaBarText:SetAlpha(toumingdu);
		else
			PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.HealthBarText:SetAlpha(toumingdu);
			PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.ManaBarText:SetAlpha(toumingdu);
			PetFrameHealthBar.TextString:SetAlpha(toumingdu);
			PetFrameManaBar.TextString:SetAlpha(toumingdu);
			if PlayerFrameAlternateManaBarText then
				PlayerFrameAlternateManaBarText:SetAlpha(toumingdu);
			end
		end
	end
	shuaxintoumingdu(0.1)
	local function xianHPMP() 
		shuaxintoumingdu(1)
	end
	local function yinHPMP()
		shuaxintoumingdu(0.1)
	end
	PetFrameHealthBar:HookScript("OnEnter", xianHPMP) 
	PetFrameHealthBar:HookScript("OnLeave", yinHPMP)
	PetFrameManaBar:HookScript("OnEnter", xianHPMP)
	PetFrameManaBar:HookScript("OnLeave", yinHPMP)
	if PIG_MaxTocversion() then
		PlayerFrameHealthBar:HookScript("OnEnter",xianHPMP);
		PlayerFrameManaBar:HookScript("OnEnter", xianHPMP)
		PlayerFrameHealthBar:HookScript("OnLeave", yinHPMP)
		PlayerFrameManaBar:HookScript("OnLeave", yinHPMP)
	else
		PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.HealthBar:HookScript("OnEnter",xianHPMP);
		PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.HealthBar:HookScript("OnLeave", yinHPMP)
		PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar:HookScript("OnEnter", xianHPMP)
		PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar:HookScript("OnLeave", yinHPMP)
		if PlayerFrameAlternateManaBar then 
			PlayerFrameAlternateManaBar:HookScript("OnEnter", xianHPMP)
			PlayerFrameAlternateManaBar:HookScript("OnLeave", yinHPMP)
		end
	end
end
------	
function UnitFramefun.Zishen()
	if PIGA["UnitFrame"]["PlayerFrame"]["Plus"] then
	end
	if PIGA["UnitFrame"]["PlayerFrame"]["Loot"] then
	end
	if PIGA["UnitFrame"]["PlayerFrame"]["HPFF"] then
		if not PlayerFrame.ziji then
			--人物血量蓝量信息
			PlayerFrame.ziji = CreateFrame("Frame", nil, PlayerFrame,"BackdropTemplate");
			PlayerFrame.ziji:SetBackdrop({bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
								tile = true, tileSize = 0, edgeSize = 10, insets = { left = 1, right = 1, top = 1, bottom = 1 }});
			PlayerFrame.ziji:SetBackdropBorderColor(1, 1, 1, 0.6);
			PlayerFrame.ziji:SetWidth(70);
			if PIG_MaxTocversion() then
				PlayerFrame.ziji:SetPoint("TOPLEFT", PlayerFrame, "TOPRIGHT", -4, -20);
				PlayerFrame.ziji:SetPoint("BOTTOMLEFT", PlayerFrame, "BOTTOMRIGHT", -4, 32);
			else
				PlayerFrame.ziji:SetPoint("TOPLEFT", PlayerFrame, "TOPRIGHT", -20, -26);
				PlayerFrame.ziji:SetPoint("BOTTOMLEFT", PlayerFrame, "BOTTOMRIGHT", -20, 26);
			end
			if not NDui and not ElvUI then
				local function Update_TargetFrame()
					local point, relativeTo, relativePoint, xOfs, yOfs = TargetFrame:GetPoint()
					local xOfs=xOfs or 250
					local yOfs=yOfs or -4
					if PIG_MaxTocversion() then
						if floor(xOfs+0.5)==250 and floor(yOfs+0.5)==-4 then
							TargetFrame:ClearAllPoints();
							TargetFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 350, -4);
						end
					else
						local data = EDIT_MODE_CLASSIC_SYSTEM_MAP
						local oldxOfs=data[Enum.EditModeSystem.UnitFrame][Enum.EditModeUnitFrameSystemIndices.Target].anchorInfo.offsetX
						local oldyOfs=data[Enum.EditModeSystem.UnitFrame][Enum.EditModeUnitFrameSystemIndices.Target].anchorInfo.offsetY
						if floor(xOfs+0.5)==oldxOfs and floor(yOfs+0.5)==oldyOfs then
							TargetFrame:ClearAllPoints();
							TargetFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 350, -4);
						end
					end
				end
				TargetFrame:HookScript("OnEvent", function(self,event,arg1)
					if event=="PLAYER_ENTERING_WORLD" then
						Update_TargetFrame()
					end
				end); 
				if PIG_MaxTocversion() then
					hooksecurefunc("UIParent_UpdateTopFramePositions", function()
						Update_TargetFrame()
					end)
				else
					hooksecurefunc(TargetFrame, "AnchorSelectionFrame", function(self)
						if self.systemIndex == Enum.EditModeUnitFrameSystemIndices.Target then
							Update_TargetFrame()
						end
					end)
				end
			end
			--血量
			PlayerFrame.ziji.HP = PIGFontString(PlayerFrame.ziji,{"CENTER", PlayerFrame.ziji, "CENTER", 0, 0},"", "OUTLINE",15)
			PlayerFrame.ziji.HP:SetTextColor(0,1,0,1);

			PlayerFrame.ziji.Baifenbi = PIGFontString(PlayerFrame.ziji,{"BOTTOM", PlayerFrame.ziji.HP, "TOP", 0, 0},"", "OUTLINE")--血量百分比
			PlayerFrame.ziji.Baifenbi:SetTextColor(1,0.82,0,1);

			PlayerFrame.ziji.MP = PIGFontString(PlayerFrame.ziji,{"TOP", PlayerFrame.ziji.HP, "BOTTOM", 0, 0},"", "OUTLINE",13)--魔法值
			HideHPMPTT()
			Update_MaxHp()
			Update_MaxMp()
			PlayerFrame:RegisterUnitEvent("UNIT_HEALTH","player");
			PlayerFrame:RegisterUnitEvent("UNIT_MAXHEALTH","player");
			PlayerFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT","player");
			PlayerFrame:RegisterUnitEvent("UNIT_MAXPOWER","player");
			PlayerFrame:RegisterUnitEvent("UNIT_DISPLAYPOWER","player");
		end
	end
	------
	PlayerFrame:HookScript("OnEvent", function (self,event)
		if event=="UNIT_HEALTH" then
			Update_Hp()
		elseif event=="UNIT_POWER_FREQUENT" then
			Update_Mp()
		elseif event=="UNIT_MAXHEALTH" then
			Update_MaxHp()
		elseif event=="UNIT_MAXPOWER" or event == "UNIT_DISPLAYPOWER" then
			Update_MaxMp()
		elseif event=="PLAYER_ENTERING_WORLD" then
			Update_MaxHp()
			Update_MaxMp()	
		end
	end)
end