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
---
local QuickChatfun=addonTable.QuickChatfun
function QuickChatfun.QuickBut_Stats()
	local fuFrame=QuickChatFFF_UI
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
	local Apphang_Height = 40
	fuFrame.playerStats.RF=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,0},{OptionsW*MAX_PARTY_MEMBERS,OptionsH},"Pig_playerStatsUI",true)
	local uifu = fuFrame.playerStats.RF
	uifu:PIGSetBackdrop()
	uifu:PIGClose()
	uifu:PIGSetMovable()
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
		playerbut.name = PIGFontString(playerbut,{"TOP", playerbut, "TOP", 0, -2},"")
		playerbut.Level = PIGFontString(playerbut,{"TOP", playerbut.name, "BOTTOM", 0, -2},"1")
		playerbut.Role = playerbut:CreateTexture();
		playerbut.Role:SetSize(30,30);
		playerbut.Role:SetPoint("TOPLEFT", playerbut, "TOPLEFT", 20, -40);
		playerbut.Role:SetAlpha(0.9);
		playerbut.item = CreateFrame("Button",nil,playerbut);
		playerbut.item:SetPoint("LEFT",playerbut.Role, "RIGHT",6, 0);
		playerbut.item:SetSize(27,27);
		playerbut.item:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		playerbut.item.icon = playerbut.item:CreateTexture();
		playerbut.item.icon:SetSize(27,27);
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
		playerbut.tianfuF = PIGFrame(playerbut,{"TOPLEFT", playerbut, "TOPLEFT", 20, -80},{100,Apphang_Height});

		playerbut.tianfuF.zhutex = playerbut.tianfuF:CreateTexture();
		playerbut.tianfuF.zhutex:SetSize(Apphang_Height-6,Apphang_Height-6);
		playerbut.tianfuF.zhutex:SetPoint("LEFT",playerbut.tianfuF, "LEFT",0, 0);
		playerbut.tianfuF.zhutex:SetAlpha(0.9);
		playerbut.tianfuF.zhu = PIGFontString(playerbut.tianfuF,{"LEFT",playerbut.tianfuF.zhutex, "RIGHT",0, 0});
		playerbut.tianfuF.zhu:SetJustifyH("LEFT");
		playerbut.tianfuF.futex = playerbut.tianfuF:CreateTexture();
		playerbut.tianfuF.futex:SetSize(Apphang_Height-6,Apphang_Height-6);
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
		--playerbut.model:SetUnit("Party"..id)
		playerbut.model:SetUnit("player")
	end
	function Update_List()
		for id = 1, MAX_PARTY_MEMBERS, 1 do
			local butmode = uifu.ButLsit[id]
			local unit = "Party"..id
			local unit = "player"
			butmode.model:RefreshUnit()
			if UnitExists(unit) then
				local className, classFile, classId = UnitClass(unit)
				local level = UnitLevel(unit)
				local raceName, raceFile, raceID = UnitRace(unit)
				local color = PIG_CLASS_COLORS[classFile];
				local allname = GetUnitName(unit, true)
				butmode.allname=allname
				butmode.name:SetText(allname)
				butmode.name:SetTextColor(color.r,color.g, color.b, 1);
				butmode.Level:SetText(LEVEL..level.." "..raceName..className)
				butmode.Level:SetTextColor(color.r,color.g, color.b, 1);
				local Role = UnitGroupRolesAssigned(unit)
				butmode.Role:SetAtlas(PIGGetIconForRole(Role));
			else

			end
		end
	end
	uifu:SetScript("OnShow", function (self)
		Update_List()
	end)
	uifu:RegisterEvent("GROUP_ROSTER_UPDATE")
	uifu:RegisterEvent("PLAYER_ENTERING_WORLD")
	uifu:HookScript("OnEvent",function(self, event,arg1,_,_,_,arg5)
		C_Timer.After(0.8,function()
			Update_List()
		end)
	end)
end