local addonName, addonTable = ...;
local Create = addonTable.Create
----
local BarTexList = {
	{TEXTURES_SUBHEADER.."1","interface/buttons/greyscaleramp64.blp"},
	{TEXTURES_SUBHEADER.."2","interface/targetingframe/ui-statusbar.blp"},
	{TEXTURES_SUBHEADER.."3","interface/targetingframe/ui-statusbar-glow.blp"},
	{TEXTURES_SUBHEADER.."4","interface/chatframe/chatframebackground.blp"},
};
local BorderColorX = {0.65, 0.65, 0.65, 1}
local BGColorX = {0, 0, 0, 0.4}
function Create.add_Bar(fuji,ly,Point,WH)
	local zitix=ChatFontNormal:GetFont()
	--local zitix=TextStatusBarText:GetFont()
	local BarHT
	if ly==4 or ly==6 or ly==11 then
		BarHT = CreateFrame("Frame", nil, fuji)
		BarHT:SetPoint("TOPLEFT",fuji,"TOPLEFT",0,0);
		BarHT:SetPoint("TOPRIGHT",fuji,"TOPRIGHT",0,0);
		function BarHT:PIGBackdropBorderColor(butlist)
			for ix=1,#butlist do
				butlist[ix]:SetBackdropBorderColor(unpack(BorderColorX))
			end
		end
		function BarHT:PIGBackdropColor(butlist,ColorX)
			for ix=1,#butlist do
				butlist[ix]:SetBackdropColor(unpack(ColorX or BGColorX))
			end
		end
		function BarHT:PIGStatusBarTexture(butlist,TexID)
			for ix=1,#butlist do
				if ly==4 or ly==11 then
					butlist[ix]:SetBackdrop({bgFile = BarTexList[TexID][2],edgeFile = Create.edgeFile, edgeSize = 8})
					butlist[ix]:SetBackdropColor(1, 0, 0, 0);
				elseif ly==6 then
					butlist[ix].bar:SetStatusBarTexture(BarTexList[TexID][2])
				end
			end
		end
		function BarHT:Set_BarFont() end
		if ly==6 then
			BarHT.bg = BarHT:CreateTexture(nil, "BACKGROUND");
			BarHT.bg:SetTexture("interface/chatframe/chatframebackground.blp");
			BarHT.bg:SetPoint("TOPLEFT",BarHT,"TOPLEFT",0,0);
			BarHT.bg:SetPoint("BOTTOMRIGHT",BarHT,"BOTTOMRIGHT",0,0);
			BarHT.bg:SetColorTexture(unpack(BGColorX))
		end
	else
		if ly=="DIY" then
			BarHT = CreateFrame("Frame")
			if Point then
				BarHT:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
			end
			BarHT:SetSize(WH[1],WH[2]);
			BarHT.spellicon = BarHT:CreateTexture();
			BarHT.spellicon:SetPoint("BOTTOM",BarHT,"BOTTOM",0,0);
			BarHT.spellicon:SetSize(WH[1],WH[1]);
			BarHT.spellicon:SetTexCoord(0.1,0.9,0.1,0.9);
			BarHT.Bar = BarHT:CreateTexture(nil, "BACKGROUND");
			BarHT.Bar:SetTexture(BarTexList[PIGA["CombatPlus"]["HPMPBar"]["BarTex"]][2]);
			BarHT.Bar:SetPoint("TOPLEFT",BarHT,"TOPLEFT",0,0);
			BarHT.Bar:SetPoint("BOTTOMRIGHT",BarHT.spellicon,"TOPRIGHT",0,0);
			BarHT.Border = CreateFrame("Frame", nil, BarHT,"BackdropTemplate")
			BarHT.Border:SetBackdrop({edgeFile = Create.edgeFile, edgeSize = 6})
			BarHT.Border:SetBackdropBorderColor(unpack(BorderColorX))
			BarHT.Border:SetPoint("TOPLEFT",BarHT,"TOPLEFT",0,0);
			BarHT.Border:SetPoint("BOTTOMRIGHT",BarHT,"BOTTOMRIGHT",0,0);
			BarHT.Border:SetFrameLevel(5)
			BarHT.V = BarHT:CreateFontString();
			BarHT.V:SetFont(zitix, 12,"OUTLINE")
			BarHT.V:SetPoint("LEFT",BarHT,"RIGHT",0,0);
		else
			BarHT = CreateFrame("StatusBar", nil, fuji);
			BarHT:SetStatusBarTexture(BarTexList[PIGA["CombatPlus"]["HPMPBar"]["BarTex"]][2])
			if fuji.next then
				BarHT:SetPoint("TOPLEFT",fuji.next,"BOTTOMLEFT",0,1);
				BarHT:SetPoint("TOPRIGHT",fuji.next,"BOTTOMRIGHT",0,1);
			else
				BarHT:SetPoint("TOPLEFT",fuji,"TOPLEFT",0,0);
				BarHT:SetPoint("TOPRIGHT",fuji,"TOPRIGHT",0,0);
			end
			BarHT.bg = BarHT:CreateTexture(nil, "BACKGROUND");
			BarHT.bg:SetTexture("interface/chatframe/chatframebackground.blp");
			BarHT.bg:SetPoint("TOPLEFT",BarHT,"TOPLEFT",0,0);
			BarHT.bg:SetPoint("BOTTOMRIGHT",BarHT,"BOTTOMRIGHT",0,0);
			BarHT.bg:SetColorTexture(unpack(BGColorX))
			BarHT.Border = CreateFrame("Frame", nil, BarHT,"BackdropTemplate")
			BarHT.Border:SetBackdrop({edgeFile = Create.edgeFile, edgeSize = 8})
			BarHT.Border:SetBackdropBorderColor(unpack(BorderColorX))
			BarHT.Border:SetPoint("TOPLEFT",BarHT,"TOPLEFT",0,0);
			BarHT.Border:SetPoint("BOTTOMRIGHT",BarHT,"BOTTOMRIGHT",0,0);
			BarHT.xiaxian = BarHT:CreateFontString();
			BarHT.V = BarHT:CreateFontString();
			BarHT.maxV = BarHT:CreateFontString();
			BarHT.xiaxian:SetPoint("CENTER",BarHT,"CENTER",0,0.8);
			BarHT.V:SetPoint("RIGHT",BarHT.xiaxian,"LEFT",0,0);
			BarHT.maxV:SetPoint("LEFT",BarHT.xiaxian,"RIGHT",0,0);
			function BarHT:PIGStatusBarColort(r,g,b,a)
				self:SetStatusBarColor(r,g,b,a);
			end
			function BarHT:Set_BarFont()
				self.xiaxian:SetFont(zitix, PIGA["CombatPlus"]["HPMPBar"]["FontSize"],"OUTLINE")
				self.V:SetFont(zitix, PIGA["CombatPlus"]["HPMPBar"]["FontSize"],"OUTLINE")
				self.maxV:SetFont(zitix, PIGA["CombatPlus"]["HPMPBar"]["FontSize"],"OUTLINE")
				if fuji.Showshuzhi then
					self.xiaxian:Show()
					self.maxV:Show()
					self.V:Show()
				else
					self.xiaxian:Hide()
					self.maxV:Hide()
					self.V:Hide()
				end
			end
			BarHT:Set_BarFont()
			BarHT.xiaxian:SetText("/")
			function BarHT:PIGStatusBarTexture(TexID)
				self:SetStatusBarTexture(BarTexList[TexID][2])
			end
			function BarHT:Update_MaxValues(HPMAX) 
				local HPMAX = HPMAX or 1
				self:SetMinMaxValues(0, HPMAX)
				if fuji.Showshuzhi then
					self.maxV:SetText(HPMAX);
				end
			end
			function BarHT:Update_Values(HP)
				local HP = HP or 1
				self:SetValue(HP);
				if fuji.Showshuzhi then
					self.V:SetText(HP);
				end
			end
		end
	end
	fuji.BarTexNum=#BarTexList
	return BarHT
end