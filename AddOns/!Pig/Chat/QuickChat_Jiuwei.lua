local _, addonTable = ...;
local L=addonTable.locale
-------------------------------------------
local Create=addonTable.Create
local PIGEnter=Create.PIGEnter
local QuickChatfun=addonTable.QuickChatfun
function QuickChatfun.QuickBut_jiuwei()
	local fuFrame=QuickChatFFF_UI
	local fuWidth = fuFrame.Width
	local Width,Height = fuWidth,fuWidth
	local ziframe = {fuFrame:GetChildren()}
	if PIGA["Chat"]["QuickChat_style"]==1 then
		fuFrame.jiuweidaojishi = CreateFrame("Button",nil,fuFrame, "TruncatedButtonTemplate"); 
	elseif PIGA["Chat"]["QuickChat_style"]==2 then
		fuFrame.jiuweidaojishi = CreateFrame("Button",nil,fuFrame, "UIMenuButtonStretchTemplate"); 
	end
	fuFrame.jiuweidaojishi:SetSize(Width,Height);
	fuFrame.jiuweidaojishi:SetFrameStrata("LOW")
	fuFrame.jiuweidaojishi:SetPoint("LEFT",fuFrame,"LEFT",#ziframe*Width,0);
	fuFrame.jiuweidaojishi:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	fuFrame.jiuweidaojishi.Tex = fuFrame.jiuweidaojishi:CreateTexture(nil);
	fuFrame.jiuweidaojishi.Tex:SetTexture("interface/pvpframe/icons/prestige-icon-3.blp")
	fuFrame.jiuweidaojishi.Tex:SetSize(Width-2,Height-5);
	fuFrame.jiuweidaojishi.Tex:SetPoint("CENTER",fuFrame.jiuweidaojishi,"CENTER",-0.4,0);
	fuFrame.jiuweidaojishi:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",2,-1);
	end);
	fuFrame.jiuweidaojishi:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER",-0.4,0);
	end);
	PIGEnter(fuFrame.jiuweidaojishi,"|cff00FFff"..KEY_BUTTON1.."-|r|cffFFFF00"..READY_CHECK.."\n|cff00FFff"..KEY_BUTTON2.."-|r|cffFFFF00"..L["CHAT_DAOSHU"].."|r")
	fuFrame.jiuweidaojishi:HookScript("OnEnter", function (self)	
		fuFrame:PIGEnterAlpha()
	end);
	fuFrame.jiuweidaojishi:HookScript("OnLeave", function (self)
		fuFrame:PIGLeaveAlpha()
	end);
	fuFrame.kaiguaidaojishi=5
	local function daojishikaiguai()
		if IsInRaid() then
			if fuFrame.kaiguaidaojishi==0 then
				
				SendChatMessage("***开始攻击***", "RAID_WARNING", nil);
			else
				SendChatMessage("***开怪倒计时："..fuFrame.kaiguaidaojishi.." ***", "RAID_WARNING", nil);
			end
		elseif IsInGroup() then
			if fuFrame.kaiguaidaojishi==0 then
				SendChatMessage("***开始攻击***", "PARTY", nil);
			else
				SendChatMessage("***开怪倒计时："..fuFrame.kaiguaidaojishi.." ***", "PARTY", nil);
			end
		end
		fuFrame.kaiguaidaojishi=fuFrame.kaiguaidaojishi-1
	end
	fuFrame.jiuweidaojishi:SetScript("OnClick", function(self, event)
		if event=="LeftButton" then
			DoReadyCheck()
		else
			--C_PartyInfo.DoCountdown(5)
			if self.daoshuTicker  then
				self.daoshuTicker:Cancel()
			end
			fuFrame.kaiguaidaojishi=5
			self.daoshuTicker = C_Timer.NewTicker(1, daojishikaiguai, 6)
		end
	end);
	fuFrame.jiuweidaojishi:RegisterEvent("PLAYER_ENTERING_WORLD")
	fuFrame.jiuweidaojishi:RegisterEvent("GROUP_ROSTER_UPDATE")
	fuFrame.jiuweidaojishi:SetScript("OnEvent", function(self,event)
		self.ShowHide=false
		if IsInRaid() then
			if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
				self.ShowHide=true
			end
		elseif IsInGroup() then
			self.ShowHide=true
		end
		self:SetShown(self.ShowHide)
	end);
end
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
			--PIGSendChatRaidParty()
		else
			PIGSendChatRaidParty("面包会有的")
		end
	end);
end