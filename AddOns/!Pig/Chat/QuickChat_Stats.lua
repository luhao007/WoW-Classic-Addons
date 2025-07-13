local _, addonTable = ...;
local L=addonTable.locale
-------------------------------------------
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGFontString=Create.PIGFontString
local Fun=addonTable.Fun
local PIGGetRaceAtlas=Fun.PIGGetRaceAtlas
local FasongYCqingqiu=Fun.FasongYCqingqiu
local Data=addonTable.Data
---
local QuickChatfun=addonTable.QuickChatfun
function QuickChatfun.QuickBut_Stats()
	local fuFrame=QuickChatfun.TabButUI
	local fuWidth = fuFrame.Width
	local Width,Height = fuWidth,fuWidth
	local ziframe = {fuFrame:GetChildren()}
	if PIGA["Chat"]["QuickChat_style"]==1 then
		fuFrame.playerStats = CreateFrame("Button",nil,fuFrame, "TruncatedButtonTemplate"); 
	elseif PIGA["Chat"]["QuickChat_style"]==2 then
		fuFrame.playerStats = CreateFrame("Button",nil,fuFrame, "UIMenuButtonStretchTemplate"); 
	end
	fuFrame.playerStats:SetSize(Width,Height);
	fuFrame.playerStats:SetFrameStrata("LOW")
	fuFrame.playerStats:SetPoint("LEFT",fuFrame,"LEFT",#ziframe*Width,0);
	fuFrame.playerStats:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	fuFrame.playerStats.Tex = fuFrame.playerStats:CreateTexture(nil);
	fuFrame.playerStats.Tex:SetTexture(666623)
	fuFrame.playerStats.Tex:SetSize(Width,Height+2);
	fuFrame.playerStats.Tex:SetPoint("CENTER",fuFrame.playerStats,"CENTER",0,-2);
	fuFrame.playerStats:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",1,-3);
	end);
	fuFrame.playerStats:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER",0,-2);
	end);
	PIGEnter(fuFrame.playerStats,"|cff00FFff"..KEY_BUTTON1.."-|r|cffFFFF00"..CHAT_ANNOUNCE..PAPERDOLL_SIDEBAR_STATS.."\n|cff00FFff"..KEY_BUTTON2.."-|r|cffFFFF00"..PARTY.."/"..RAID_MEMBERS..INFO.."|r")
	fuFrame.playerStats:HookScript("OnEnter", function (self)	
		fuFrame:PIGEnterAlpha()
	end);
	fuFrame.playerStats:HookScript("OnLeave", function (self)
		fuFrame:PIGLeaveAlpha()
	end);
	local TalentData=addonTable.Data.TalentData
	fuFrame.playerStats:SetScript("OnClick", function(self, event)
		if event=="LeftButton" then
			local shuxintxt = TalentData.Player_Stats()
			local editBoxXX = ChatEdit_ChooseBoxForSend()
	        ChatEdit_ActivateChat(editBoxXX)
			editBoxXX:Insert(shuxintxt)
		else
			if fuFrame.playerStats.RF:IsShown() then
				fuFrame.playerStats.RF:Hide()
			else
				fuFrame.playerStats.RF:Show()
			end
		end
	end);
	---
	local greenTexture = "interface/common/indicator-green.blp"
	local xuanzhongBG = {{0.2, 0.2, 0.2, 0.2},{0.4, 0.8, 0.8, 0.1}}
	local OptionsW,OptionsH,uifu = 200,400,fuFrame.playerStats.RF
	local UIname,hang_Height = "PIG_PlayerStatsUI",20
	fuFrame.playerStats.RF=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,0},{OptionsW*MAX_PARTY_MEMBERS,OptionsH},UIname,true)
	local uifu = fuFrame.playerStats.RF
	uifu:PIGSetBackdrop()
	uifu:PIGClose()
	uifu:PIGSetMovableNoSave()
	uifu.ButLsit={}
	uifu.biaoti = PIGFontString(uifu,{"TOP", uifu, "TOP", 0, -2},"成员信息")
	for id = 1, MAX_PARTY_MEMBERS, 1 do
		local playerbut=PIGFrame(uifu,{"BOTTOMLEFT",uifu,"BOTTOMLEFT",OptionsW*(id-1),0},{OptionsW,OptionsH-20})
		playerbut:PIGSetBackdrop(0,0.6,nil,{1,1,0})
		playerbut:HookScript("OnEnter", function (self)
			self:SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		playerbut:HookScript("OnLeave", function (self)
			self:SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		uifu.ButLsit[id]=playerbut
		playerbut.Faction = playerbut:CreateTexture();
		playerbut.Faction:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
		playerbut.Faction:SetPoint("TOPLEFT", playerbut, "TOPLEFT", 6,-6);
		playerbut.Faction:SetSize(hang_Height,hang_Height);
		playerbut.Race = playerbut:CreateTexture();
		playerbut.Race:SetPoint("LEFT", playerbut.Faction, "RIGHT", 1,0);
		playerbut.Race:SetSize(hang_Height,hang_Height);
		playerbut.Class = playerbut:CreateTexture();
		playerbut.Class:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
		playerbut.Class:SetPoint("LEFT", playerbut.Race, "RIGHT", 1,0);
		playerbut.Class:SetSize(hang_Height,hang_Height);
		playerbut.level = PIGFontString(playerbut,{"LEFT", playerbut.Class, "RIGHT", 2, 0},1)
		playerbut.level:SetTextColor(1,0.843,0, 1);
		playerbut.name = PIGFontString(playerbut,{"LEFT", playerbut.level, "RIGHT", 0, 0})

		playerbut.Role = playerbut:CreateTexture();
		playerbut.Role:SetSize(hang_Height+16,hang_Height+16);
		playerbut.Role:SetPoint("TOP", playerbut, "TOP", 0, -60);
		playerbut.Role:SetAlpha(0.9);

		playerbut.item = CreateFrame("Button",nil,playerbut);
		playerbut.item:SetPoint("TOPLEFT", playerbut.Faction, "BOTTOMLEFT", 0,-6);
		playerbut.item:SetSize(hang_Height,hang_Height);
		playerbut.item:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		playerbut.item.icon = playerbut.item:CreateTexture();
		playerbut.item.icon:SetSize(hang_Height,hang_Height);
		playerbut.item.icon:SetPoint("CENTER", playerbut.item, "CENTER", 0, 0);
		playerbut.item.icon:SetAlpha(0.9);
		playerbut.item.icon:SetTexture(133122);
		playerbut.item:HookScript("OnMouseDown", function(self)
			self.icon:SetPoint("CENTER", self, "CENTER",1.5, -1.5);
		end); 
		playerbut.item:HookScript("OnMouseUp", function(self)
			self.icon:SetPoint("CENTER", self, "CENTER",0, 0);
		end); 
		playerbut.item:HookScript("OnClick", function(self)
			FasongYCqingqiu(self:GetParent().allname)
		end); 
		playerbut.iLvl = PIGFontString(playerbut,{"LEFT", playerbut.item, "RIGHT",1, 0});
		playerbut.iLvl:SetTextColor(0,0.98,0.6, 1);
		playerbut.numcc=0
		function playerbut:Update_data(allname)
			if PIG_OptionsUI.talentData[allname] and PIG_OptionsUI.talentData[allname]["I"] then
				self.iLvl:SetText(PIG_OptionsUI.talentData[allname]["I"][5]) 
				self.numcc=0
			else
				self.numcc=self.numcc+1
				if self.numcc<5 then
					C_Timer.After(1,function() self:Update_data(allname) end)
				else
					self.numcc=0
				end
			end
		end
		playerbut.tianfuF = PIGFrame(playerbut,{"TOPLEFT", playerbut, "TOPLEFT", 20, -80},{100,hang_Height});
		playerbut.tianfuF.zhutex = playerbut.tianfuF:CreateTexture();
		playerbut.tianfuF.zhutex:SetSize(hang_Height,hang_Height);
		playerbut.tianfuF.zhutex:SetPoint("LEFT",playerbut.tianfuF, "LEFT",0, 0);
		playerbut.tianfuF.zhutex:SetAlpha(0.9);
		playerbut.tianfuF.zhu = PIGFontString(playerbut.tianfuF,{"LEFT",playerbut.tianfuF.zhutex, "RIGHT",0, 0});
		playerbut.tianfuF.zhu:SetJustifyH("LEFT");
		playerbut.tianfuF.futex = playerbut.tianfuF:CreateTexture();
		playerbut.tianfuF.futex:SetSize(hang_Height,hang_Height);
		playerbut.tianfuF.futex:SetPoint("LEFT",playerbut.tianfuF.zhu, "RIGHT",2, 0);
		playerbut.tianfuF.futex:SetAlpha(0.9);
		playerbut.tianfuF.fu = PIGFontString(playerbut.tianfuF,{"LEFT",playerbut.tianfuF.futex, "RIGHT",0, 0});
		playerbut.tianfuF.fu:SetJustifyH("LEFT");
		-- playerbut.tianfuF:HookScript("OnEnter", function (self)
		-- 	self:GetParent():GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		-- 	if self.tftisp1 then
		-- 		GameTooltip:ClearLines();
		-- 		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
		-- 		local tishineirrr = "|T"..greenTexture..":13:13|t|T"..self.tftisp1[2]..":0|t"..self.tftisp1[1].." |cffFFFFFF"..self.tftisp1[3].."|r"
		-- 		if self.tftisp2 then
		-- 			tishineirrr =tishineirrr.."\n    |T"..self.tftisp2[2]..":0|t"..self.tftisp2[1].." |cffFFFFFF"..self.tftisp2[3].."|r"
		-- 		end
		-- 		GameTooltip:AddLine(tishineirrr)
		-- 		GameTooltip:Show();
		-- 	end
		-- end);
		-- playerbut.tianfuF:HookScript("OnLeave", function (self)
		-- 	self:GetParent():GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		-- 	GameTooltip:ClearLines();
		-- 	GameTooltip:Hide();
		-- end);

		playerbut.model = CreateFrame("PlayerModel", nil, playerbut);
		playerbut.model:SetSize(OptionsW,OptionsH-100);
		playerbut.model:SetPoint("BOTTOM",playerbut,"BOTTOM",0,0);
	end
	function Update_List()
		for id = 1, MAX_PARTY_MEMBERS, 1 do
			local playerbut = uifu.ButLsit[id]
			local unit = "Party"..id
			--local unit = "player"
			playerbut.model:RefreshUnit()
			if UnitExists(unit) then
				playerbut.Faction:Show()
				playerbut.Race:Show()
				playerbut.Class:Show()
				playerbut.Role:Show()
				playerbut.item:Show()
				local allname = GetUnitName(unit, true) or UNKNOWNOBJECT
				FasongYCqingqiu(allname,5)
				playerbut.allname=allname
				playerbut.model:SetUnit(unit)
				local englishFaction= UnitFactionGroup(unit)
				if englishFaction=="Alliance" then
					playerbut.Faction:SetTexCoord(0,0.5,0,1);
				elseif englishFaction=="Horde" then
					playerbut.Faction:SetTexCoord(0.5,1,0,1);
				end
				local raceName, raceFile, raceID = UnitRace(unit)
				local gender = UnitSex(unit) or 2
				local race_icon = PIGGetRaceAtlas(raceFile,gender)
				playerbut.Race:SetAtlas(race_icon);
				local className, classFile, classId = UnitClass(unit)
				playerbut.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
				local level = UnitLevel(unit) or "??"
				playerbut.level:SetText("("..level..")");
				local color = PIG_CLASS_COLORS[classFile];
				playerbut.name:SetTextColor(color.r, color.g, color.b, 1);
				playerbut.name:SetText(allname)
				local Role = UnitGroupRolesAssigned(unit)
				playerbut.Role:SetAtlas(PIGGetIconForRole(Role));
				playerbut:Update_data(allname)
			else
				playerbut.Faction:Hide()
				playerbut.Race:Hide()
				playerbut.Class:Hide()
				playerbut.Role:Hide()
				playerbut.item:Hide()
				playerbut.level:SetText("");
				playerbut.name:SetText("")
				playerbut.iLvl:SetText("")
			end
		end
	end
	uifu:SetScript("OnShow", function (self)
		Update_List()
	end)
	uifu:RegisterEvent("GROUP_ROSTER_UPDATE")
	uifu:HookScript("OnEvent",function(self, event,arg1)
		if not self:IsShown() then return end
		C_Timer.After(0.2,function()
			Update_List()
		end)
	end)
end