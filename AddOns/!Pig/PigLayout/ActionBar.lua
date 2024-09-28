local _, addonTable = ...;
----------------------------------------
local PigLayoutfun=addonTable.PigLayoutfun
function PigLayoutfun.ActionBar()
	if PigLayoutfun then return end
	local WWW,HHH=20,24
	local butList = {
		CharacterMicroButton,SpellbookMicroButton,TalentMicroButton,AchievementMicroButton,QuestLogMicroButton,
		SocialsMicroButton,CollectionsMicroButton,PVPMicroButton,LFGMicroButton,MainMenuMicroButton,HelpMicroButton
	}
	local butListTex = {
		{"UI-ChatIcon-App","SmallQuestBang","SmallQuestBang"},
		{"QuestNormal","SmallQuestBang","SmallQuestBang"},
		{"QuestNormal","SmallQuestBang","SmallQuestBang"},
		{"QuestNormal","SmallQuestBang","SmallQuestBang"},
		{"QuestNormal","SmallQuestBang","SmallQuestBang"},
		{"socialqueuing-icon-group","SmallQuestBang","SmallQuestBang"},
		{"QuestNormal","SmallQuestBang","SmallQuestBang"},
		{"QuestNormal","SmallQuestBang","SmallQuestBang"},
		{"socialqueuing-icon-eye","groupfinder-eye-frame","SmallQuestBang"},
		{"QuestNormal","SmallQuestBang","SmallQuestBang"},
		{"QuestNormal","SmallQuestBang","SmallQuestBang"},
	}

	--objecticonsatlas
	CharacterMicroButton:ClearAllPoints();
	CharacterMicroButton:SetPoint("TOP",UIParent,"TOP",-120,0);
	for i=1,#butList do
		local MicroBut = butList[i]
		MicroBut:SetHitRectInsets(0,0,0,0);
		MicroBut:SetSize(WWW,HHH);
		MicroBut:SetHighlightAtlas("bags-roundhighlight");
		MicroBut.Flash:SetPoint("TOPLEFT",MicroBut,"TOPLEFT",-2,5);
		MicroBut.Flash:SetSize(WWW*2.2,HHH*2.04);
		local NormalTex=MicroBut:GetNormalTexture()
		local PushedTex=MicroBut:GetPushedTexture()
		local DisabledTex=MicroBut:GetDisabledTexture()
		MicroBut.mask = MicroBut:CreateMaskTexture()
		if yuanxing then
			MicroBut.mask:SetAllPoints(NormalTex)
			MicroBut.mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")--圆形
		else
			MicroBut.mask:SetPoint("TOPLEFT",NormalTex,"TOPLEFT",-2,2);
			MicroBut.mask:SetPoint("BOTTOMRIGHT",NormalTex,"BOTTOMRIGHT",2,-2);
			MicroBut.mask:SetTexture("Interface/ChatFrame/UI-ChatIcon-HotS", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")--六边形
		end
		NormalTex:AddMaskTexture(MicroBut.mask)
		PushedTex:AddMaskTexture(MicroBut.mask)
		if DisabledTex then DisabledTex:AddMaskTexture(MicroBut.mask) end
		if MicroBut==CharacterMicroButton then
			MicroButtonPortrait:AddMaskTexture(MicroBut.mask)
			MicroButtonPortrait:SetScale(0.88)
			MicroButtonPortrait:SetPoint("TOP",MicroBut,"TOP",0,2);
			HelpOpenWebTicketButton:SetPoint("CENTER",MicroBut,"CENTER",-1,-WWW);
		elseif MicroBut==PVPMicroButton then
			MicroBut.texture:SetPoint("TOP",MicroBut,"TOP",6,-1);
		elseif MicroBut==MainMenuMicroButton then
			MainMenuBarPerformanceBar:SetPoint("TOPLEFT",MicroBut,"TOPLEFT",6,-6);
		end
		if MicroBut==LFGMicroButton then
			NormalTex:SetTexCoord(0.15,0.85,0.51,0.88)
			PushedTex:SetTexCoord(0.15,0.85,0.51,0.88)
			DisabledTex:SetTexCoord(0.15,0.85,0.51,0.88)
		else
			NormalTex:SetTexCoord(0.15,0.85,0.46,0.92)
			PushedTex:SetTexCoord(0.15,0.85,0.46,0.92)
			if DisabledTex then DisabledTex:SetTexCoord(0.15,0.85,0.46,0.92) end
		end
	end
	hooksecurefunc("UpdateMicroButtons", function()
		for i=2,#butList do
			butList[i]:SetPoint("BOTTOMLEFT",butList[i-1],"BOTTOMRIGHT",2,0);
		end
	end)
end


--===================================
-- local Texture1 = UIParent:CreateTexture();
-- --Texture1:SetTexture("Interface/AddOns/!Pig/UIMicroMenu2x.BLP");
-- Texture1:SetTexture("interface/hud/UIMicroMenu.BLP");
-- Texture1:SetSize(500,254);
-- Texture1:ClearAllPoints();
-- Texture1:SetPoint("CENTER", 11, -12);