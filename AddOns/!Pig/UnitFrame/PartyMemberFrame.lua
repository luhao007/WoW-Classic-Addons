local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create = addonTable.Create
local PIGFontString=Create.PIGFontString
local UnitFramefun=addonTable.UnitFramefun
--=======================================
local UFP_MAX_PARTY_BUFFS = 16;
local UFP_MAX_PARTY_DEBUFFS = 8;
local UFP_MAX_PARTY_PET_DEBUFFS = 4;
----------------
local UnitAura=UnitAura or function(unitToken, index, filter)
	local auraData = C_UnitAuras.GetAuraDataByIndex(unitToken, index, filter);
	if not auraData then
		return nil;
	end
	return AuraUtil.UnpackAuraData(auraData);
end
local UnitBuff=UnitBuff or function(unitToken, index, filter)
	local auraData = C_UnitAuras.GetBuffDataByIndex(unitToken, index, filter);
	if not auraData then
		return nil;
	end
	return AuraUtil.UnpackAuraData(auraData);
end
local UnitDebuff= UnitDebuff or function(unitToken, index, filter)
	local auraData = C_UnitAuras.GetDebuffDataByIndex(unitToken, index, filter);
	if not auraData then
		return nil;
	end
	return AuraUtil.UnpackAuraData(auraData);
end
--职业图标
local function Update_zhiye(Party,id)
	if IsInRaid() then return end
    local _,class = UnitClass(id)
	if class then
		local coords = CLASS_ICON_TCOORDS[class];
		Party.Icon:SetTexCoord(unpack(coords));
		local Role = UnitGroupRolesAssigned(id)
		Party.role.Icon:SetAtlas(PIGGetIconForRole(Role, false));
		if tocversion>100000 then
			local pfujiui = Party:GetParent()
			pfujiui.PartyMemberOverlay.RoleIcon:Hide()
			pfujiui.Name:SetWidth(170)
		end
	end
end
--队友等级
local function Update_Level(Party,id)
	if IsInRaid() then return end
	local LevelLL=UnitLevel(id)
    if LevelLL then
    	if LevelLL >= 1 then
			Party.title:SetText(LevelLL);
		else
			Party.title:SetText("?");
		end
	end
end
--队友血量
local function Update_HP(Party,id)
	if IsInRaid() then return end
	local mubiaoHmax = UnitHealthMax(id)
	local mubiaoH = UnitHealth(id)
	if mubiaoHmax>0 then
		Party.title:SetText(mubiaoH..'/'..mubiaoHmax);
	else
		Party.title:SetText('?/?');
	end
end
--显示BUFF
local function Update_BUFF(Party,id)
	if IsInRaid() then return end
	for j = 1, UFP_MAX_PARTY_BUFFS, 1 do
		local _, icon = UnitBuff(id, j);
		local IconUI = _G[Party.."Buff"..j].Icon
		if icon then
			IconUI:SetTexture(icon);
			IconUI:SetAlpha(1);
		else
			IconUI:SetAlpha(0);
		end
	end
end
local function Update_Debuff(Party,id)
	if IsInRaid() then return end
	if tocversion<100000 then
	else
		for j = 1, UFP_MAX_PARTY_DEBUFFS, 1 do
			local _, icon = UnitDebuff(id, j);
			local IconUI = _G[Party.."Debuff"..j].Icon
			if icon then
				IconUI:SetTexture(icon);
				IconUI:SetAlpha(1);
			else
				IconUI:SetAlpha(0);
			end
		end
	end
end
----队友目标
local function Update_mubiao(Party,id)
	if IsInRaid() then return end
	local PartymubiaiT=id.."target"
	local partytargetname = GetUnitName(PartymubiaiT, true)
	if partytargetname then 
		local diduiORyoushan = UnitIsEnemy(PartymubiaiT,"player")
		if diduiORyoushan then
			Party.title:SetTextColor(1, 0, 0);
		else
			Party.title:SetTextColor(0, 1, 0);
		end
		if UnitIsDead(PartymubiaiT) then
			Party.title:SetText(partytargetname.."(死亡)");
		else
			local duiyoumubiaobaifenbi = math.floor((UnitHealth(PartymubiaiT)/UnitHealthMax(PartymubiaiT))*100);
			Party.title:SetText(partytargetname.."("..duiyoumubiaobaifenbi.."%)");
		end
	else
		Party.title:SetText("");
	end
end
----创建扩展信息框架
local duiyouFrameReg = CreateFrame("Frame");
----------------
local function yanchizhixingsuoyou()
	if IsInRaid() then return end
	local numSubgroupMembers = GetNumSubgroupMembers()
	for id = 1, numSubgroupMembers, 1 do
		local Party=_G["PartyMemberFrame"..id] or PartyFrame and PartyFrame["MemberFrame"..id]
		if Party and Party.zhiye and Party.Level then
			Update_zhiye(Party.zhiye,"party"..id)
			Update_Level(Party.Level,"party"..id) 
		end
		if Party.HP then Update_HP(Party.HP,"party"..id) end
		if PIGA["UnitFrame"]["PartyMemberFrame"]["Buff"] then
			Update_BUFF("Party"..id,"party"..id)
		 	Update_Debuff("Party"..id,"party"..id)
		end
		if Party.mubiao then Update_mubiao(Party.mubiao,"party"..id) end
	end
end
------------------
duiyouFrameReg:RegisterEvent("PLAYER_ENTERING_WORLD")
duiyouFrameReg:RegisterEvent("GROUP_ROSTER_UPDATE");
duiyouFrameReg:SetScript("OnEvent", function(self,event,arg1)
	C_Timer.After(0.2,yanchizhixingsuoyou)
	C_Timer.After(0.8,yanchizhixingsuoyou)	
end)
-----
local zhiyetubiao_Click=UnitFramefun.zhiyetubiao_Click
local function PartyMember_Plus()
	if not PIGA["UnitFrame"]["PartyMemberFrame"]["Plus"] then return end
	if duiyouFrameReg.Plus then return end
	duiyouFrameReg.Plus=true
	for id = 1, MAX_PARTY_MEMBERS, 1 do
		local Party=_G["PartyMemberFrame"..id] or PartyFrame and PartyFrame["MemberFrame"..id]
		----队友职业图标
		if not Party.zhiye then		
			Party.zhiye = CreateFrame("Button", nil, Party);
			Party.zhiye:SetFrameLevel(5)
			Party.zhiye:SetSize(28,28);
			if tocversion<100000 then
				Party.zhiye:SetPoint("BOTTOMLEFT", Party, "TOPLEFT", 22, -18);
			else
				Party.zhiye:SetPoint("BOTTOMLEFT", Party, "TOPLEFT", 17, -16);
			end
			Party.zhiye:SetHighlightTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight");

			Party.zhiye.Border = Party.zhiye:CreateTexture(nil, "OVERLAY");
			Party.zhiye.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
			Party.zhiye.Border:SetSize(46,46);
			Party.zhiye.Border:SetPoint("CENTER", Party.zhiye, "CENTER", 10, -10);

			Party.zhiye.Icon = Party.zhiye:CreateTexture();
			Party.zhiye.Icon:SetSize(17,17);
			Party.zhiye.Icon:SetPoint("CENTER");
			Party.zhiye.Icon:SetTexture("Interface/GLUES/CHARACTERCREATE/UI-CHARACTERCREATE-CLASSES")

			--队友职业图标点击功能：左交易/右观察
			Party.zhiye:RegisterForClicks("LeftButtonUp", "RightButtonUp");
			Party.zhiye:HookScript("OnClick", function (self,button)
				zhiyetubiao_Click(self:GetParent().unit,button)
			end);
			Party.zhiye.role = CreateFrame("Button", nil, Party.zhiye);
			Party.zhiye.role:SetSize(20,20);
			Party.zhiye.role:SetPoint("TOP", Party.zhiye, "BOTTOM", -1, -15);
			Party.zhiye.role.Icon = Party.zhiye.role:CreateTexture();
			Party.zhiye.role.Icon:SetSize(20,20);
			Party.zhiye.role.Icon:SetPoint("CENTER");
		end
		--队友等级
		if not Party.Level then	
			Party.Level = CreateFrame("Frame", nil, Party);
			Party.Level:SetSize(20,18);
			Party.Level:SetPoint("TOPRIGHT", Party, "BOTTOMLEFT", 14, 11);
		    Party.Level.title = PIGFontString(Party.Level,{"TOPRIGHT", Party.Level, "TOPRIGHT", 0, 0},"", "OUTLINE")
		    Party.Level.title:SetTextColor(1, 0.82, 0);
		    Party.Level:RegisterUnitEvent("UNIT_LEVEL", "party"..id);
		    Party.Level:HookScript("OnEvent", function(self,event,arg1)
				Update_Level(self,arg1,true)
			end)
		end
	end
end
local function PartyMember_HPFF()
	if not PIGA["UnitFrame"]["PartyMemberFrame"]["HPFF"] then return end
	if duiyouFrameReg.HPFF then return end
	duiyouFrameReg.HPFF=true
	for id = 1, MAX_PARTY_MEMBERS, 1 do
		local Party=_G["PartyMemberFrame"..id] or PartyFrame and PartyFrame["MemberFrame"..id]
	    ---队友血量扩展显示框架
	    if not Party.HP then
			Party.HP = CreateFrame("Frame", nil, Party,"BackdropTemplate");
			Party.HP:SetSize(90,22);
			Party.HP:SetBackdrop({ bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 10, 
			insets = { left = 2, right = 2, top = 2, bottom = 2 }});
			Party.HP:SetBackdropColor(0, 0, 0, 0.6);
			Party.HP:SetBackdropBorderColor(0.8, 0.8, 0.8, 0.9);
			if tocversion<100000 then
				Party.HP:SetPoint("TOPLEFT", Party, "TOPRIGHT", -11, -10);
			else
				Party.HP:SetWidth(100);
				Party.HP:SetPoint("TOPLEFT", Party, "TOPRIGHT", -3, -17.6);
			end
			Party.HP.title = PIGFontString(Party.HP,{"CENTER", Party.HP, "CENTER", 0, 0},"", "OUTLINE", 13.6)
			Party.HP.title:SetTextColor(0,1,0,1);
			Party.HP:RegisterUnitEvent("UNIT_HEALTH", "party"..id);--HP改变时
			Party.HP:RegisterUnitEvent("UNIT_MAXHEALTH", "party"..id);--最大HP改变时
			Party.HP:HookScript("OnEvent", function(self,event,arg1)
				Update_HP(self,arg1,true)
			end)
		end
		--位面图标移位
		if Party.notPresentIcon then
			Party.notPresentIcon:ClearAllPoints()
			Party.notPresentIcon:SetPoint("LEFT",Party.HP,"RIGHT",0,0);
		elseif Party.NotPresentIcon then
			Party.NotPresentIcon:ClearAllPoints()
			Party.NotPresentIcon:SetPoint("LEFT",Party.HP,"RIGHT",0,0);
		end
	end
	local function HideHPMPTT()
		for id=1,MAX_PARTY_MEMBERS do
			if not PartyMemberFrame1 and not PartyFrame then C_Timer.After(3,HideHPMPTT) return end
			local Party=_G["PartyMemberFrame"..id] or PartyFrame and PartyFrame["MemberFrame"..id]
			local healthbar=Party.healthbar or Party.HealthBar
			local manabar=Party.manabar or Party.ManaBar
			healthbar.TextString:SetAlpha(0.1);
			manabar.TextString:SetAlpha(0.1);
			local function xianHPMP() 
				healthbar.TextString:SetAlpha(1);
				manabar.TextString:SetAlpha(1);		
			end
			local function yinHPMP()
				healthbar.TextString:SetAlpha(0.1);
				manabar.TextString:SetAlpha(0.1);
			end
			healthbar:HookScript("OnEnter",xianHPMP);
			manabar:HookScript("OnEnter", xianHPMP)
			healthbar:HookScript("OnLeave", yinHPMP)
			manabar:HookScript("OnLeave", yinHPMP)
		end
	end
	if tocversion>50000 then C_Timer.After(3,HideHPMPTT) end
end
local function PartyMember_Buff()
	if not PIGA["UnitFrame"]["PartyMemberFrame"]["Buff"] then return end
	if duiyouFrameReg.Buff then return end
	duiyouFrameReg.Buff=true
	--隐藏系统自带队友buff鼠标提示
	if tocversion<100000 then
		hooksecurefunc("PartyMemberBuffTooltip_Update", function(self)
		    PartyMemberBuffTooltip:Hide();
		end)
	else
		hooksecurefunc(PartyMemberBuffTooltip, "UpdateTooltip", function(self)
			self:Hide();
		end)
	end
	for id = 1, MAX_PARTY_MEMBERS, 1 do
		local Party=_G["PartyMemberFrame"..id] or PartyFrame and PartyFrame["MemberFrame"..id]
		--队友buff常驻显示
		for j = 1, UFP_MAX_PARTY_BUFFS, 1 do  --BUFF
			if not _G["Party"..id.."Buff"..j] then
				local buff = CreateFrame("Button", "Party"..id.."Buff"..j, Party);
				buff:SetSize(15,15);
				if j == 1 then
					if tocversion<100000 then
		           		buff:SetPoint("TOPLEFT", Party, "TOPLEFT", 48, -32);
		           	else
						buff:SetPoint("TOPLEFT", Party, "TOPLEFT", 40, -39);
		           	end
		            buff:RegisterUnitEvent("UNIT_AURA","party"..id);--获得BUFF时
		            buff:HookScript("OnEvent", function(self,event,arg1)
						Update_BUFF("Party"..id,arg1,true)
					end)
		        else
		            buff:SetPoint("LEFT", _G["Party"..id.."Buff"..(j-1)], "RIGHT", 2, 0);
		        end
				buff.Icon = buff:CreateTexture(nil, "ARTWORK");
		        buff.Icon:SetAllPoints(buff)
				
				buff:EnableMouse(true);
		        buff:SetScript("OnEnter",function(self)
		        	GameTooltip:ClearLines();
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		            GameTooltip:SetUnitBuff(Party.unit, j);
		        end)
		        buff:SetScript("OnLeave",function()
		            GameTooltip:Hide();
		        end)
		    end
	    end
	    --改动系统DEBUFF位置
	    if tocversion<100000 then
	    	_G["PartyMemberFrame"..id.."Debuff1"]:ClearAllPoints();
			_G["PartyMemberFrame"..id.."Debuff1"]:SetPoint("TOPRIGHT", _G["PartyMemberFrame"..id], "TOPRIGHT", 50, 8);
	    else
		    for j = 1, UFP_MAX_PARTY_DEBUFFS, 1 do  --DEBUFF
				if not _G["Party"..id.."Debuff"..j] then
					local debuff = CreateFrame("Button", "Party"..id.."Debuff"..j, Party);
					debuff:SetSize(15,15);
					if j == 1 then
						debuff:SetPoint("BOTTOMLEFT", Party, "TOPLEFT", 122, -16);
			            debuff:RegisterUnitEvent("UNIT_AURA","party"..id);--获得debuff时
			            debuff:HookScript("OnEvent", function(self,event,arg1)
							Update_Debuff("Party"..id,arg1,true)
						end)
			        else
			            debuff:SetPoint("LEFT", _G["Party"..id.."Debuff"..(j-1)], "RIGHT", 2, 0);
			        end
					debuff.Icon = debuff:CreateTexture(nil, "ARTWORK");
			        debuff.Icon:SetAllPoints(debuff)
					
					debuff:EnableMouse(true);
			        debuff:SetScript("OnEnter",function(self)
			        	GameTooltip:ClearLines();
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			            GameTooltip:SetUnitDebuff(Party.unit, j);
			        end)
			        debuff:SetScript("OnLeave",function()
			            GameTooltip:Hide();
			        end)
			    end
		    end
		end
	end
end
local function PartyMember_ToToT()
	if not PIGA["UnitFrame"]["PartyMemberFrame"]["ToToT"] then return end
	if duiyouFrameReg.ToToT then return end
	duiyouFrameReg.ToToT=true
	for id = 1, MAX_PARTY_MEMBERS, 1 do
		local Party=_G["PartyMemberFrame"..id] or PartyFrame and PartyFrame["MemberFrame"..id]
	    --队友目标
	    if Party and not Party.mubiao then
			Party.mubiao = CreateFrame("Button", "PartyMemberFrame"..id.."ToToT", Party,"SecureUnitButtonTemplate",id)
			Party.mubiao:SetSize(100,22);
			Party.mubiao:SetPoint("LEFT", Party.HP, "RIGHT", 4, -0);
			Party.mubiao:RegisterForClicks("AnyUp")
			Party.mubiao:RegisterForDrag("LeftButton")
			Party.mubiao:SetAttribute("*type1", "target")
			Party.mubiao:SetAttribute("unit", "party"..id.."target")
		    Party.mubiao.title = PIGFontString(Party.mubiao,{"LEFT", Party.mubiao, "LEFT", 0, 0},"", "OUTLINE")
		    Party.mubiao.title:SetTextColor(1, 0.82, 0);
		    Party.mubiao:RegisterUnitEvent("UNIT_TARGET","party"..id);
		    Party.mubiao:RegisterUnitEvent("UNIT_HEALTH", "party"..id.."target");
			Party.mubiao:RegisterUnitEvent("UNIT_MAXHEALTH", "party"..id.."target");
		    Party.mubiao:HookScript("OnEvent", function(self,event,arg1)
				Update_mubiao(self,"party"..id)
			end)
			RegisterUnitWatch(Party.mubiao)
		end
	end
end
function UnitFramefun.Duiyou()
	PartyMember_Plus()
	PartyMember_HPFF()
	PartyMember_Buff()
	PartyMember_ToToT()
end