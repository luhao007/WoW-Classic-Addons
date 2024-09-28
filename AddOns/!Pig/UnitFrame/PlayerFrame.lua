local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create = addonTable.Create
local PIGFontString=Create.PIGFontString
---
local UnitFramefun=addonTable.UnitFramefun
-------------
local function HpMp_Update()
	if not PIGA["UnitFrame"]["PlayerFrame"]["HPFF"] then return end
	local HP = UnitHealth("player");	
	local HPmax = UnitHealthMax("player");
	PlayerFrame.ziji.HP:SetText(HP..'/'..HPmax);
	if HPmax>0 then
		PlayerFrame.ziji.Baifenbi:SetText(math.floor(((HP/HPmax)*100)).."%");
	end
	local MP = UnitPower("player");	
	local MPmax = UnitPowerMax("player");
	PlayerFrame.ziji.MP:SetText(MP..'/'..MPmax);
end
local function HpMp_Update_W()
	if not PIGA["UnitFrame"]["PlayerFrame"]["HPFF"] then return end
	if UnitHealthMax("player")>99999 or UnitPowerMax("player")>99999 then
		PlayerFrame.ziji:SetWidth(120);
	elseif UnitHealthMax("player")>9999 or UnitPowerMax("player")>9999 then
		PlayerFrame.ziji:SetWidth(100);
	elseif UnitHealthMax("player")>999 or UnitPowerMax("player")>999 then
		PlayerFrame.ziji:SetWidth(90);
	end
	local powerType = UnitPowerType("player")
	local info = PowerBarColor[powerType]
	if info.r==0 and info.g==0 and info.b==1 then
		PlayerFrame.ziji.MP:SetTextColor(info.r, 0.7, info.b ,1)
	else
		PlayerFrame.ziji.MP:SetTextColor(info.r, info.g, info.b ,1)
	end
end
local function HideHPMPTT()
	local function shuaxintoumingdu(toumingdu)
		if tocversion<100000 then
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
	if tocversion<100000 then
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
local function Naijiu_Update()
	if not PIGA["UnitFrame"]["PlayerFrame"]["Plus"] then return end
	local zhuangbeinaijiuhezhi={0,0};
	for id = 1, 19, 1 do
		local current, maximum = GetInventoryItemDurability(id);
		if current~=nil then
			zhuangbeinaijiuhezhi[1]=zhuangbeinaijiuhezhi[1]+current;
			zhuangbeinaijiuhezhi[2]=zhuangbeinaijiuhezhi[2]+maximum;
		end
	end
	if zhuangbeinaijiuhezhi[1]>0 and zhuangbeinaijiuhezhi[2]>0 then
		local naijiubaifenbi=floor(zhuangbeinaijiuhezhi[1]/zhuangbeinaijiuhezhi[2]*100);
		PlayerFrame.naijiu:SetText(naijiubaifenbi.."%");
		if naijiubaifenbi>79 then
			PlayerFrame.naijiu:SetTextColor(0,1,0, 1);
		elseif  naijiubaifenbi>59 then
			PlayerFrame.naijiu:SetTextColor(1,215/255,0, 1);
		elseif  naijiubaifenbi>39 then
			PlayerFrame.naijiu:SetTextColor(1,140/255,0, 1);
		elseif  naijiubaifenbi>19 then
			PlayerFrame.naijiu:SetTextColor(1,69/255,0, 1);
		else
			PlayerFrame.naijiu:SetTextColor(1,0,0, 1);
		end
	else
		PlayerFrame.naijiu:SetText("N/A");
	end
end
local function Loot_Update()
	if not PIGA["UnitFrame"]["PlayerFrame"]["Loot"] then return end
	if tocversion<50000 then
		if IsInGroup() then 
			local lootmethod, _, _ = GetLootMethod();
			if lootmethod=="freeforall" then 
				PlayerFrame.lootF.loot:SetText("自\n由");
			elseif lootmethod=="roundrobin" then 
				PlayerFrame.lootF.loot:SetText("轮\n流");	
			elseif lootmethod=="master" then 
				PlayerFrame.lootF.loot:SetText("队\n长");	
			elseif lootmethod=="group" then 
				PlayerFrame.lootF.loot:SetText("队\n伍");	
			elseif lootmethod=="needbeforegreed" then 
				PlayerFrame.lootF.loot:SetText("需\n求");
			elseif lootmethod=="personalloot" then
				PlayerFrame.lootF.loot:SetText("个\n人");
			end
		else
			PlayerFrame.lootF.loot:SetText("未\n组\n队");
		end
	else
		local specID = GetLootSpecialization()--当前拾取专精
		if specID>0 then
			local _, name = GetSpecializationInfoByID(specID)
			PlayerFrame.lootF.loot:SetText(name);
		else
			local specIndex = GetSpecialization()--当前专精
			if specIndex==5 then
				PlayerFrame.lootF.loot:SetText("无\n*");
			else
				local _, name = GetSpecializationInfo(specIndex)
				PlayerFrame.lootF.loot:SetText(name.."\n*");
			end
		end
	end
end
---		
function UnitFramefun.Zishen()
	if PIGA["UnitFrame"]["PlayerFrame"]["Plus"] and not PlayerFrame.ICON then
		--角色耐久
		PlayerFrame.ICON = PlayerFrame:CreateTexture(nil, "OVERLAY");
		PlayerFrame.ICON:SetTexture("interface/minimap/tracking/repair.blp");
		PlayerFrame.ICON:SetSize(16,16);
		PlayerFrame.ICON:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 20, 4);
		PlayerFrame.naijiu = PIGFontString(PlayerFrame,{"TOPLEFT", PlayerFrame.ICON, "TOPRIGHT", -1, -1},"??%", "OUTLINE")
		Naijiu_Update()
		--角色移速
		PlayerFrame.yisuF=CreateFrame("Frame",nil,PlayerFrame);
		PlayerFrame.yisuF:SetPoint("LEFT", PlayerFrame.naijiu, "RIGHT", 8, 0);
		PlayerFrame.yisuF:SetSize(49,18);
		PlayerFrame.yisuF.Tex = PlayerFrame.yisuF:CreateTexture("Frame_Texture_UI", "ARTWORK");
		PlayerFrame.yisuF.Tex:SetTexture("interface/icons/ability_rogue_sprint.blp");
		PlayerFrame.yisuF.Tex:SetSize(13,13);
		PlayerFrame.yisuF.Tex:SetPoint("LEFT", PlayerFrame.yisuF, "LEFT", 0, 0);
		PlayerFrame.yisuT = PIGFontString(PlayerFrame,{"LEFT", PlayerFrame.yisuF.Tex, "RIGHT", 0, 0},"", "OUTLINE")
		PlayerFrame.yisuT:SetTextColor(1,1,1,1);
		PlayerFrame.yisuF:SetScript("OnUpdate", function ()
			local currentSpeed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed("player");
			PlayerFrame.yisuT:SetText(Round(((currentSpeed/7)*100))..'%')
		end)
	end

	if PIGA["UnitFrame"]["PlayerFrame"]["Loot"] and not PlayerFrame.lootF then
		--拾取方式
		PlayerFrame.lootF = CreateFrame("Button", nil, PlayerFrame);
		PlayerFrame.lootF:SetSize(25,80);
		if tocversion<100000 then
			PlayerFrame.lootF:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 16, -20);
		else
			PlayerFrame.lootF:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 1, -20);
		end
		PlayerFrame.lootF:SetFrameLevel(PlayerFrame:GetFrameLevel()+4)
		PlayerFrame.lootF.loot = PIGFontString(PlayerFrame.lootF,nil,"", "OUTLINE")
		PlayerFrame.lootF.loot:SetPoint("TOPLEFT", PlayerFrame.lootF, "TOPLEFT", 0, 0);
		PlayerFrame.lootF.loot:SetPoint("BOTTOMRIGHT", PlayerFrame.lootF, "BOTTOMRIGHT", 0, 0);
		PlayerFrame.lootF.loot:SetTextColor(0, 1, 0, 1);
		PlayerFrame.lootF.loot:SetJustifyV("TOP")--垂直对齐
		PlayerFrame.lootF.specIndex=1
		Loot_Update()
		PlayerFrame.lootF:SetScript("OnClick", function (self)
			if tocversion<50000 then
				local lootmethod, _, _ = GetLootMethod();
				if lootmethod=="freeforall" then
					SetLootMethod("master","player")
					return
				elseif lootmethod=="master" then
					SetLootMethod("freeforall")
					return
				end
				SetLootMethod("freeforall")
			else
				local numSpecializations = GetNumSpecializations()--总专精数
				local specID = GetLootSpecialization()
				if specID==0 then
					self.specIndex = 1
					local specID, name = GetSpecializationInfo(self.specIndex)
					SetLootSpecialization(specID)
				else
					self.specIndex = self.specIndex+1
					if self.specIndex>numSpecializations then
						SetLootSpecialization(0)
						self.specIndex = 0
					else
						local specID, name = GetSpecializationInfo(self.specIndex)
						SetLootSpecialization(specID)
					end	
				end
				Loot_Update()
			end
		end);
	end
	if PIGA["UnitFrame"]["PlayerFrame"]["HPFF"] and not PlayerFrame.ziji then
		--人物血量蓝量信息
		PlayerFrame.ziji = CreateFrame("Frame", nil, PlayerFrame,"BackdropTemplate");
		PlayerFrame.ziji:SetBackdrop({bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
							tile = true, tileSize = 0, edgeSize = 8, insets = { left = 1, right = 1, top = 1, bottom = 1 }});
		PlayerFrame.ziji:SetBackdropBorderColor(0, 1, 1, 0.4);
		PlayerFrame.ziji:SetWidth(70);
		if tocversion<100000 then
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
				if tocversion<100000 then
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
			if tocversion<100000 then
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

		PlayerFrame.ziji.MP = PIGFontString(PlayerFrame.ziji,{"TOP", PlayerFrame.ziji.HP, "BOTTOM", 0, 0},"", "OUTLINE")--魔法值
		HideHPMPTT()
		HpMp_Update_W()
		HpMp_Update()
	end
	------
	PlayerFrame:RegisterUnitEvent("UNIT_HEALTH","player");
	PlayerFrame:RegisterUnitEvent("UNIT_MAXHEALTH","player");
	PlayerFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT","player");
	PlayerFrame:RegisterUnitEvent("UNIT_MAXPOWER","player");

	PlayerFrame:RegisterEvent("UPDATE_INVENTORY_DURABILITY");--耐久变化
	PlayerFrame:RegisterEvent("CONFIRM_XP_LOSS");--虚弱复活
	PlayerFrame:RegisterEvent("UPDATE_INVENTORY_ALERTS");--耐久图标变化或其他
	if tocversion<50000 then
		PlayerFrame:RegisterEvent("GROUP_ROSTER_UPDATE");
		PlayerFrame:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");--战利品方法改变时触发
	else
		PlayerFrame:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED");
	end
	PlayerFrame:HookScript("OnEvent", function (self,event)
		if event=="PLAYER_ENTERING_WORLD" then
			Naijiu_Update()
			Loot_Update()
			HpMp_Update_W()
			HpMp_Update()
		end
		if event=="UNIT_HEALTH" or event=="UNIT_POWER_FREQUENT" or event=="UNIT_MAXHEALTH" or event=="UNIT_MAXPOWER" then
			HpMp_Update()
		end
		if event=="UNIT_MAXHEALTH" or event=="UNIT_MAXPOWER" then
			HpMp_Update_W()
		end
		if event=="UPDATE_INVENTORY_DURABILITY" or event=="CONFIRM_XP_LOSS" or event=="UPDATE_INVENTORY_ALERTS" then
			Naijiu_Update()
		end
		if event=="PLAYER_LOOT_SPEC_UPDATED" or event=="GROUP_ROSTER_UPDATE" or event=="PARTY_LOOT_METHOD_CHANGED" then
			Loot_Update()
		end
	end)
end