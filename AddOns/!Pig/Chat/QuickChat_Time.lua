local _, addonTable = ...;
local L=addonTable.locale
-------------------------------------------
local Create=addonTable.Create
local PIGEnter=Create.PIGEnter
local QuickChatfun=addonTable.QuickChatfun
function QuickChatfun.QuickBut_Time()
	if not PIGA["CombatPlus"]["Biaoji"]["Open"] then return end
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
	fuFrame.jiuweidaojishi:SetScript("OnClick", function(self, event)
		if event=="LeftButton" then
			DoReadyCheck()
		else
			if PIGbiaoji_UI then PIGbiaoji_UI.daojishiBUT:Click() end
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