local addonName, addonTable = ...;
--===============================================
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
--
local QuickChatfun=addonTable.QuickChatfun
function QuickChatfun.QuickBut_Roll()
	local fuFrame=QuickChatFFF_UI
	local fuWidth = fuFrame.Width
	local Width,Height = fuWidth,fuWidth
	local ziframe = {fuFrame:GetChildren()}
	if PIGA["Chat"]["QuickChat_style"]==1 then
		fuFrame.ROLL = CreateFrame("Button",nil,fuFrame, "TruncatedButtonTemplate"); 
	elseif PIGA["Chat"]["QuickChat_style"]==2 then
		fuFrame.ROLL = CreateFrame("Button",nil,fuFrame, "UIMenuButtonStretchTemplate"); 
	end
	fuFrame.ROLL:SetSize(Width,Height);
	fuFrame.ROLL:SetFrameStrata("LOW")
	fuFrame.ROLL:SetPoint("LEFT",fuFrame,"LEFT",#ziframe*Width,0);
	fuFrame.ROLL:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	fuFrame.ROLL.Tex = fuFrame.ROLL:CreateTexture(nil, "BORDER");
	fuFrame.ROLL.Tex:SetTexture("interface/buttons/ui-grouploot-dice-up.blp");
	fuFrame.ROLL.Tex:SetPoint("CENTER",0,-1);
	fuFrame.ROLL.Tex:SetSize(Width-8,Height-4);
	fuFrame.ROLL:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",1,-2);
	end);
	fuFrame.ROLL:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER",0,-1);
	end);
	PIGEnter(fuFrame.ROLL,"|cff00FFff"..KEY_BUTTON1.."-|r|cffFFFF00Roll\n|cff00FFff"..KEY_BUTTON2.."-|r|cffFFFF00Roll"..GUILD_BANK_LOG.."|r");
	fuFrame.ROLL:HookScript("OnEnter", function (self)	
		fuFrame:PIGEnterAlpha()
	end);
	fuFrame.ROLL:HookScript("OnLeave", function (self)
		fuFrame:PIGLeaveAlpha()
	end);
	fuFrame.ROLL:SetScript("OnClick", function(self, but)
		if but=="RightButton" then
			ToggleLootHistoryFrame()
		else
			RandomRoll(1, 100)
		end
	end);
end