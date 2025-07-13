local addonName, addonTable = ...;
--
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGFontString=Create.PIGFontString
local BackdropColor=Create.BackdropColor
local PIGEnter=Create.PIGEnter
----
local Fun=addonTable.Fun
local yasuo_NumberString=Fun.yasuo_NumberString
local jieya_NumberString=Fun.jieya_NumberString
local ALA=addonTable.ALA
local TalentData=addonTable.Data.TalentData
local GetSpecialization = GetSpecialization or C_SpecializationInfo and C_SpecializationInfo.GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo or C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo
--------
local function max_tianfudianshu(level)
	if PIG_MaxTocversion(40000) then
		return max(level-9,0)
	elseif PIG_MaxTocversion(50000) then
		local shengyuV=0
		if level>9 then shengyuV=shengyuV+1 end
		if level>10 then shengyuV=shengyuV+1 end
		if level>11 and level<81  then 
			local QshengyuV=floor((level-11)*0.5)
			shengyuV=shengyuV+max(QshengyuV,0)
		elseif level>80 then
			local QshengyuV=floor((80-11)*0.5)
			shengyuV=shengyuV+max(QshengyuV,0)

			shengyuV=shengyuV+max(level-80,0)
		end
		return shengyuV
	else
		return 0
	end
end
-----------
local function shezhitishi(tishiUI,txtui)
	local GlyphFF = PIGFrame(tishiUI);
	GlyphFF:SetAllPoints(txtui)
	GlyphFF:SetScript("OnEnter", function (self)
		local xxxx = txtui:GetText()
		if xxxx and xxxx~=NONE then
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
			GameTooltip:SetHyperlink(xxxx)
			GameTooltip:Show();
		end
	end);
	GlyphFF:SetScript("OnLeave", function ()
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end);
end
local function Show_Glyphinfo(self,fwid,from)
	local fujiui=self:GetParent()
	if from=="lx" then
		if PIGA["StatsInfo"] and PIGA["StatsInfo"]["Items"] and PIGA["StatsInfo"]["Items"][fujiui.cName] then
			local fwDataall ={TalentData.HY_GlyphTXT(PIGA["StatsInfo"]["Items"][fujiui.cName]["G"])}
			local fwData = fwDataall[fwid]
			if fwData then
				for i=1,TalentData.GLYPH_NUM do
					if fwData[i] then
						local link = GetSpellLink(fwData[i])
						if link and link~="" then
							self.Glyph["Glyph"..i]:SetText(link)
						end
					end
				end
			end
		end
	else
		if PIG_OptionsUI.talentData[fujiui.cName] and PIG_OptionsUI.talentData[fujiui.cName]["G"] then
			local fwData = PIG_OptionsUI.talentData[fujiui.cName]["G"][fwid+1]
			if fwData then
				for i=1,TalentData.GLYPH_NUM do
					if fwData[i] then
						local link = GetSpellLink(fwData[i])
						if link and link~="" then
							self.Glyph["Glyph"..i]:SetText(link)
						end
					end
				end
			end
		else
			C_Timer.After(0.6,function() Show_Glyphinfo(self,fwid) end)
		end
	end
end
function TalentData.add_TalentUI(frameX)
	frameX.TalentF = PIGFrame(frameX,{"TOPLEFT", frameX, "TOPRIGHT", -3, 0},{TalentData.tianfuW+140,TalentData.tianfuH});
	frameX.TalentF:PIGSetBackdrop(1,nil,nil,nil,0);
	frameX.TalentF:SetFrameLevel(frameX.TalentF:GetFrameLevel()+6)
	frameX.TalentF:Hide()
	frameX.TalentF:PIGClose()
	frameX.TalentF.L_TOPLEFT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.L_TOPLEFT:SetSize(TalentData.tianfuW/3,TalentData.tianfuH-104);
	frameX.TalentF.L_TOPLEFT:SetPoint("TOPLEFT", frameX.TalentF, "TOPLEFT",4, -24);
	frameX.TalentF.L_TOPRIGHT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.L_TOPRIGHT:SetPoint("TOPLEFT", frameX.TalentF.L_TOPLEFT, "TOPRIGHT",0, 0);
	frameX.TalentF.L_TOPRIGHT:SetPoint("BOTTOMLEFT", frameX.TalentF.L_TOPLEFT, "BOTTOMRIGHT",0, 0);
	frameX.TalentF.L_BOTTOMLEFT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.L_BOTTOMLEFT:SetPoint("TOPLEFT", frameX.TalentF.L_TOPLEFT, "BOTTOMLEFT",0, 0);
	frameX.TalentF.L_BOTTOMLEFT:SetPoint("TOPRIGHT", frameX.TalentF.L_TOPLEFT, "BOTTOMRIGHT",0, 0);
	frameX.TalentF.L_BOTTOMRIGHT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.L_BOTTOMRIGHT:SetPoint("TOPLEFT", frameX.TalentF.L_BOTTOMLEFT, "TOPRIGHT",0, 0);
	---
	frameX.TalentF.C_TOPLEFT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.C_TOPLEFT:SetWidth(TalentData.tianfuW/3);
	frameX.TalentF.C_TOPLEFT:SetPoint("TOPLEFT", frameX.TalentF.L_TOPRIGHT, "TOPRIGHT",-20, 0);
	frameX.TalentF.C_TOPLEFT:SetPoint("BOTTOMLEFT", frameX.TalentF.L_TOPRIGHT, "BOTTOMRIGHT",-20, 0);
	frameX.TalentF.C_TOPRIGHT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.C_TOPRIGHT:SetPoint("TOPLEFT", frameX.TalentF.C_TOPLEFT, "TOPRIGHT",0, 0);
	frameX.TalentF.C_TOPRIGHT:SetPoint("BOTTOMLEFT", frameX.TalentF.C_TOPLEFT, "BOTTOMRIGHT",0, 0);
	frameX.TalentF.C_BOTTOMLEFT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.C_BOTTOMLEFT:SetPoint("TOPLEFT", frameX.TalentF.C_TOPLEFT, "BOTTOMLEFT",0, 0);
	frameX.TalentF.C_BOTTOMLEFT:SetPoint("TOPRIGHT", frameX.TalentF.C_TOPLEFT, "BOTTOMRIGHT",0, 0);
	frameX.TalentF.C_BOTTOMRIGHT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.C_BOTTOMRIGHT:SetPoint("TOPLEFT", frameX.TalentF.C_BOTTOMLEFT, "TOPRIGHT",0, 0);
	---
	frameX.TalentF.R_TOPLEFT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.R_TOPLEFT:SetWidth(TalentData.tianfuW/3);
	frameX.TalentF.R_TOPLEFT:SetPoint("TOPLEFT", frameX.TalentF.C_TOPRIGHT, "TOPRIGHT",-20, 0);
	frameX.TalentF.R_TOPLEFT:SetPoint("BOTTOMLEFT", frameX.TalentF.C_TOPRIGHT, "BOTTOMRIGHT",-20, 0);
	frameX.TalentF.R_TOPRIGHT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.R_TOPRIGHT:SetPoint("TOPLEFT", frameX.TalentF.R_TOPLEFT, "TOPRIGHT",0, 0);
	frameX.TalentF.R_TOPRIGHT:SetPoint("BOTTOMLEFT", frameX.TalentF.R_TOPLEFT, "BOTTOMRIGHT",0, 0);
	frameX.TalentF.R_BOTTOMLEFT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.R_BOTTOMLEFT:SetPoint("TOPLEFT", frameX.TalentF.R_TOPLEFT, "BOTTOMLEFT",0, 0);
	frameX.TalentF.R_BOTTOMLEFT:SetPoint("TOPRIGHT", frameX.TalentF.R_TOPLEFT, "BOTTOMRIGHT",0, 0);
	frameX.TalentF.R_BOTTOMRIGHT = frameX.TalentF:CreateTexture(nil, "BORDER");
	frameX.TalentF.R_BOTTOMRIGHT:SetPoint("TOPLEFT", frameX.TalentF.R_BOTTOMLEFT, "TOPRIGHT",0, 0);
	--
	frameX.TalentF.futianfu = PIGButton(frameX.TalentF,{"TOPLEFT", frameX.TalentF, "TOPLEFT", 20,-2},{80,20},nil,nil,nil,nil,nil,0)
	frameX.TalentF.futianfu:HookScript("OnClick", function(self)
		self.xianshi2()
	end)
	--
	frameX.TalentF.biaoti = PIGFontString(frameX.TalentF,{"TOP", frameX.TalentF, "TOP", -20,-6})
	frameX.TalentF.biaoti1 = PIGFontString(frameX.TalentF,{"LEFT", frameX.TalentF.biaoti, "RIGHT", 0,0})
	--
	frameX.TalentF.ButListDian={}
	for ixx=1,3 do
		frameX.TalentF.ButListDian[ixx]=PIGFontString(frameX.TalentF,{"TOPLEFT", frameX.TalentF, "TOPLEFT", 214*(ixx-1)+84,-27});
	end
	if PIG_MaxTocversion(30000,true) and PIG_MaxTocversion(50000) then 
		frameX.TalentF.Glyph = PIGFrame(frameX.TalentF,{"BOTTOMLEFT", frameX.TalentF, "TOPLEFT", 0, 1},{TalentData.tianfuW+140,34});
		frameX.TalentF.Glyph:PIGSetBackdrop(1);

		frameX.TalentF.Glyph.biaoti2 = PIGFontString(frameX.TalentF.Glyph,{"BOTTOMLEFT", frameX.TalentF.Glyph, "BOTTOMLEFT", 4,2},MINOR_GLYPH..": ");
		frameX.TalentF.Glyph.Glyph2 = PIGFontString(frameX.TalentF.Glyph,{"LEFT", frameX.TalentF.Glyph.biaoti2, "RIGHT", 0,0});
		frameX.TalentF.Glyph.Glyph3 = PIGFontString(frameX.TalentF.Glyph,{"LEFT", frameX.TalentF.Glyph.biaoti2, "RIGHT", 180,0});
		frameX.TalentF.Glyph.Glyph5 = PIGFontString(frameX.TalentF.Glyph,{"LEFT", frameX.TalentF.Glyph.biaoti2, "RIGHT", 360,0});

		frameX.TalentF.Glyph.biaoti1 = PIGFontString(frameX.TalentF.Glyph,{"BOTTOMLEFT", frameX.TalentF.Glyph.biaoti2, "TOPLEFT", 0,2},MAJOR_GLYPH..": ");
		frameX.TalentF.Glyph.Glyph1 = PIGFontString(frameX.TalentF.Glyph,{"LEFT", frameX.TalentF.Glyph.biaoti1, "RIGHT", 0,0});
		frameX.TalentF.Glyph.Glyph4 = PIGFontString(frameX.TalentF.Glyph,{"LEFT", frameX.TalentF.Glyph.biaoti1, "RIGHT", 180,0});
		frameX.TalentF.Glyph.Glyph6 = PIGFontString(frameX.TalentF.Glyph,{"LEFT", frameX.TalentF.Glyph.biaoti1, "RIGHT", 360,0});

		shezhitishi(frameX.TalentF.Glyph,frameX.TalentF.Glyph.Glyph1)
		shezhitishi(frameX.TalentF.Glyph,frameX.TalentF.Glyph.Glyph2)
		shezhitishi(frameX.TalentF.Glyph,frameX.TalentF.Glyph.Glyph3)
		shezhitishi(frameX.TalentF.Glyph,frameX.TalentF.Glyph.Glyph4)
		shezhitishi(frameX.TalentF.Glyph,frameX.TalentF.Glyph.Glyph5)
		shezhitishi(frameX.TalentF.Glyph,frameX.TalentF.Glyph.Glyph6)
		if PIG_MaxTocversion(40000,true) then
			frameX.TalentF.Glyph:SetHeight(50)
			frameX.TalentF.Glyph.biaoti3 = PIGFontString(frameX.TalentF.Glyph,{"BOTTOMLEFT", frameX.TalentF.Glyph.biaoti1, "TOPLEFT", 0,2},PRIME_GLYPH..": ");
			frameX.TalentF.Glyph.Glyph7 = PIGFontString(frameX.TalentF.Glyph,{"LEFT", frameX.TalentF.Glyph.biaoti3, "RIGHT", 0,0});
			frameX.TalentF.Glyph.Glyph8 = PIGFontString(frameX.TalentF.Glyph,{"LEFT", frameX.TalentF.Glyph.biaoti3, "RIGHT", 180,0});
			frameX.TalentF.Glyph.Glyph9 = PIGFontString(frameX.TalentF.Glyph,{"LEFT", frameX.TalentF.Glyph.biaoti3, "RIGHT", 360,0});
			shezhitishi(frameX.TalentF.Glyph,frameX.TalentF.Glyph.Glyph7)
			shezhitishi(frameX.TalentF.Glyph,frameX.TalentF.Glyph.Glyph8)
			shezhitishi(frameX.TalentF.Glyph,frameX.TalentF.Glyph.Glyph9)
		end
	end
	---
	local tianfuB= 30
	frameX.TalentF.ButList={}
	for i=1,3 do
		frameX.TalentF.ButList[i]={}
		for ii=1,TalentData.PIGtianfuhangshu do
			frameX.TalentF.ButList[i][ii]={}
			for iii=1,4 do
				local tianfuBUT = CreateFrame("Button", nil, frameX.TalentF);
				frameX.TalentF.ButList[i][ii][iii]=tianfuBUT
				tianfuBUT:SetHighlightTexture(130718);
				tianfuBUT:SetSize(tianfuB,tianfuB);
				if i==1 then
					if ii==1 then
						if iii==1 then
							tianfuBUT:SetPoint("TOPLEFT",frameX.TalentF,"TOPLEFT",20,-46);
						else
							tianfuBUT:SetPoint("LEFT", frameX.TalentF.ButList[i][ii][iii-1], "RIGHT", 20, 0);
						end
					else
						if iii==1 then
							tianfuBUT:SetPoint("TOP",frameX.TalentF.ButList[i][ii-1][iii],"BOTTOM", 0, -18);
						else
							tianfuBUT:SetPoint("LEFT", frameX.TalentF.ButList[i][ii][iii-1], "RIGHT", 20, 0);
						end
					end
				elseif i==2 then
					if ii==1 then
						if iii==1 then
							tianfuBUT:SetPoint("TOPLEFT",frameX.TalentF,"TOPLEFT",236,-46);
						else
							tianfuBUT:SetPoint("LEFT", frameX.TalentF.ButList[i][ii][iii-1], "RIGHT", 20, 0);
						end
					else
						if iii==1 then
							tianfuBUT:SetPoint("TOP",frameX.TalentF.ButList[i][ii-1][iii],"BOTTOM", 0, -18);
						else
							tianfuBUT:SetPoint("LEFT", frameX.TalentF.ButList[i][ii][iii-1], "RIGHT", 20, 0);
						end
					end
				elseif i==3 then
					if ii==1 then
						if iii==1 then
							tianfuBUT:SetPoint("TOPLEFT",frameX.TalentF,"TOPLEFT",444,-46);
						else
							tianfuBUT:SetPoint("LEFT", frameX.TalentF.ButList[i][ii][iii-1], "RIGHT", 20, 0);
						end
					else
						if iii==1 then
							tianfuBUT:SetPoint("TOP",frameX.TalentF.ButList[i][ii-1][iii],"BOTTOM", 0, -18);
						else
							tianfuBUT:SetPoint("LEFT", frameX.TalentF.ButList[i][ii][iii-1], "RIGHT", 20, 0);
						end
					end
				end
				tianfuBUT.Border = tianfuBUT:CreateTexture(nil, "BORDER");
				tianfuBUT.Border:SetTexture(130841);
				tianfuBUT.Border:SetPoint("TOPLEFT",tianfuBUT,"TOPLEFT",-10,10);
				tianfuBUT.Border:SetPoint("BOTTOMRIGHT",tianfuBUT,"BOTTOMRIGHT",10,-10);
				tianfuBUT.Icon = tianfuBUT:CreateTexture(nil, "BORDER");
				tianfuBUT.Icon:SetPoint("TOPLEFT",tianfuBUT,"TOPLEFT",0,0);
				tianfuBUT.Icon:SetPoint("BOTTOMRIGHT",tianfuBUT,"BOTTOMRIGHT",0,0);
				tianfuBUT.dianshuBG = tianfuBUT:CreateTexture(nil, "ARTWORK");
				tianfuBUT.dianshuBG:SetTexture("interface/talentframe/talentframe-rankborder.blp");
				tianfuBUT.dianshuBG:SetSize(tianfuB*1.74,tianfuB);
				tianfuBUT.dianshuBG:SetPoint("BOTTOMRIGHT",tianfuBUT,"BOTTOMRIGHT",25,-14);
				tianfuBUT.dianshu = PIGFontString(tianfuBUT,{"CENTER", tianfuBUT.dianshuBG, "CENTER", 1,1},nil,nil,12)
			end
		end
	end
	function frameX.TalentF:CZ_Tianfu()
		self:Hide()
		self.futianfu:Hide()
		self.biaoti:SetText();
		self.biaoti1:SetText();
		--
		self.L_TOPLEFT:SetTexture("");
		self.L_TOPRIGHT:SetTexture("");
		self.L_BOTTOMLEFT:SetTexture("");
		self.L_BOTTOMRIGHT:SetTexture("");
		--
		self.C_TOPLEFT:SetTexture("");
		self.C_TOPRIGHT:SetTexture("");
		self.C_BOTTOMLEFT:SetTexture("");
		self.C_BOTTOMRIGHT:SetTexture("");
		--
		self.R_TOPLEFT:SetTexture("");
		self.R_TOPRIGHT:SetTexture("");
		self.R_BOTTOMLEFT:SetTexture("");
		self.R_BOTTOMRIGHT:SetTexture("");
		for i=1,3 do
			self.ButListDian[i]:SetText("");
			for ii=1,TalentData.PIGtianfuhangshu do
				for iii=1,4 do
					self.ButList[i][ii][iii]:Hide();
				end
			end
		end
	end
	function frameX.TalentF:ShowTianfuInfo(zhiye,level,tfData,fwid,from)
		if not tfData then return end
		local tianfudata = {["xulie"]=0,[1]=0,[2]=0,[3]=0}
		local xnum = #tfData
		local TFinfo = {}
		for i=1,xnum do
			TFinfo[i]=tfData:sub(i,i)
		end
		for i=1,3 do
			for ii=1,TalentData.PIGtianfuhangshu do
				for iii=1,4 do
					local tianfuF =frameX.TalentF.ButList[i][ii][iii]
					if TalentData.tianfuID[zhiye][i][ii][iii] then
						tianfudata.xulie=tianfudata.xulie+1
						local huoqudianshu=tonumber(TFinfo[tianfudata.xulie])
						local huoqudianshu=huoqudianshu or 0
						tianfudata[i]=tianfudata[i]+huoqudianshu
						tianfuF.dianshu.yijiadian=huoqudianshu
						tianfuF.dianshu:SetText(huoqudianshu.."/"..(#TalentData.tianfuID[zhiye][i][ii][iii]));
						if huoqudianshu==#TalentData.tianfuID[zhiye][i][ii][iii] then
							tianfuF.dianshu:SetTextColor(1, 1, 0, 1);
						else
							tianfuF.dianshu:SetTextColor(0, 1, 0, 1);
						end
						if PIG_MaxTocversion(40000) then
							tianfuF.Icon:SetTexture(GetSpellTexture(TalentData.tianfuID[zhiye][i][ii][iii][1]))
						else
							tianfuF.Icon:SetTexture(TalentData.tianfuID_ICON[zhiye][i][ii][iii])
						end
						tianfuF.dianshu:Show()
						tianfuF.dianshuBG:Show()
						tianfuF:Show();
						if huoqudianshu>0 then
							tianfuF.Icon:SetDesaturated(false)
							tianfuF:SetScript("OnEnter", function (self)
								GameTooltip:ClearLines();
								GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
								if PIG_MaxTocversion(40000) then
									GameTooltip:SetHyperlink("spell:"..TalentData.tianfuID[zhiye][i][ii][iii][huoqudianshu])
								else
									GameTooltip:SetHyperlink("talent:"..TalentData.tianfuID[zhiye][i][ii][iii][huoqudianshu])
								end
								GameTooltip:Show();
							end);
						else
							tianfuF.Icon:SetDesaturated(true)
							tianfuF:SetScript("OnEnter", function (self)
								GameTooltip:ClearLines();
								GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
								if PIG_MaxTocversion(40000) then
									GameTooltip:SetHyperlink("spell:"..TalentData.tianfuID[zhiye][i][ii][iii][1])
								else
									GameTooltip:SetHyperlink("talent:"..TalentData.tianfuID[zhiye][i][ii][iii][1])
								end
								GameTooltip:Show();
							end);
						end
						tianfuF:SetScript("OnLeave", function ()
							GameTooltip:ClearLines();
							GameTooltip:Hide() 
						end);

					else
						tianfuF:Hide();
					end
				end
			end
			frameX.TalentF.ButListDian[i]:SetText(TalentData.tianfuTabName[zhiye][i].."("..tianfudata[i]..")");
		end
		local yiyongzongdianshu=tianfudata[1]+tianfudata[2]+tianfudata[3]
		--
		local zongdianshu = max_tianfudianshu(tonumber(level))
		self.biaoti:SetText("当前可用点数"..zongdianshu);
		self.biaoti1:SetText("(已分配"..yiyongzongdianshu..")");
		local shengyu = zongdianshu-yiyongzongdianshu
		for i=1,3 do
			for ii=1,TalentData.PIGtianfuhangshu do
				for iii=1,4 do
					local tianfuF = frameX.TalentF.ButList[i][ii][iii]
					if TalentData.tianfuID[zhiye][i][ii][iii] then
						if tianfuF.dianshu.yijiadian==0 then
							tianfuF.dianshu:Hide()
							tianfuF.dianshuBG:Hide()
						end
					end
				end
			end
		end
		---
		if PIG_MaxTocversion(30000,true) and PIG_MaxTocversion(50000) then
			for i=1,TalentData.GLYPH_NUM do
				self.Glyph["Glyph"..i]:SetTextColor(0.5, 0.5, 0.5, 1);
				self.Glyph["Glyph"..i]:SetText(NONE)
			end
			Show_Glyphinfo(self,fwid,from)
		end
	end
	function frameX.TalentF:Show_Tianfu(datayuan)
		local fujiui=self:GetParent()
		local cName=fujiui.cName
		local level=fujiui.level
		local zhiye=fujiui.zhiye
		self.L_TOPLEFT:SetTexture(TalentData.tianfuBG[zhiye][3]);
		self.L_TOPRIGHT:SetTexture(TalentData.tianfuBG[zhiye][4]);
		self.L_BOTTOMLEFT:SetTexture(TalentData.tianfuBG[zhiye][1]);
		self.L_BOTTOMRIGHT:SetTexture(TalentData.tianfuBG[zhiye][2]);
		--
		self.C_TOPLEFT:SetTexture(TalentData.tianfuBG[zhiye][7]);
		self.C_TOPRIGHT:SetTexture(TalentData.tianfuBG[zhiye][8]);
		self.C_BOTTOMLEFT:SetTexture(TalentData.tianfuBG[zhiye][5]);
		self.C_BOTTOMRIGHT:SetTexture(TalentData.tianfuBG[zhiye][6]);
		---
		self.R_TOPLEFT:SetTexture(TalentData.tianfuBG[zhiye][11]);
		self.R_TOPRIGHT:SetTexture(TalentData.tianfuBG[zhiye][12]);
		self.R_BOTTOMLEFT:SetTexture(TalentData.tianfuBG[zhiye][9]);
		self.R_BOTTOMRIGHT:SetTexture(TalentData.tianfuBG[zhiye][10]);
		local tfinfo,tfinfo2= "","";
		if datayuan then
			if datayuan=="lx" then
				if PIGA["StatsInfo"] and PIGA["StatsInfo"]["Items"] and PIGA["StatsInfo"]["Items"][cName] then
					local Xtfinfo,Xtfinfo2 =TalentData.HY_TianfuTXT(PIGA["StatsInfo"]["Items"][cName]["T"])
					tfinfo,tfinfo2= Xtfinfo,Xtfinfo2
				end
			else
				local Xtfinfo,Xtfinfo2= strsplit("&", datayuan);
				tfinfo,tfinfo2= Xtfinfo,Xtfinfo2
			end
		else
			if PIG_OptionsUI.talentData[cName] then
				tfinfo,tfinfo2= PIG_OptionsUI.talentData[cName]["T"][2],PIG_OptionsUI.talentData[cName]["T"][3]
			end
		end
		self:ShowTianfuInfo(zhiye,level,tfinfo,1,datayuan)
		if tfinfo2 then
			self.futianfu:Show()
			self.futianfu:SetID(1)
			if self.futianfu:GetID()==0 or self.futianfu:GetID()==1 then
				self.futianfu:SetText(TALENT_SPEC_SECONDARY)
			else
				self.futianfu:SetText(TALENT_SPEC_PRIMARY)
			end
			self.futianfu.xianshi2=function()
				if self.futianfu:GetID()==0 or self.futianfu:GetID()==1 then
					self.futianfu:SetID(2)
					self.futianfu:SetText(TALENT_SPEC_PRIMARY)
					self:ShowTianfuInfo(zhiye,level,tfinfo2,2,datayuan)
				else
					self.futianfu:SetID(1)
					self.futianfu:SetText(TALENT_SPEC_SECONDARY)
					self:ShowTianfuInfo(zhiye,level,tfinfo,1,datayuan)
				end
			end
		else
			self.futianfu:Hide()
		end
	end
end
---
function TalentData.SAVE_Player()
	local Info = ""
	local level = UnitLevel("player")
	local gender = UnitSex("player")
	local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = GetAverageItemLevel();
	local Info = Info..PIG_OptionsUI.ClassData.classId.."-"..PIG_OptionsUI.RaceData.raceId.."-"..level.."-"..(floor(avgItemLevelEquipped*100+0.5)/100).."-"..gender
	return Info
end
--
local function PIGGetNumTalentGroups()
	return 1
end
local function PIGGetActiveTalentGroup()
	return 1
end
local GetNumTalentGroups=GetNumTalentGroups or PIGGetNumTalentGroups
local GetActiveTalentGroup=GetActiveTalentGroup or PIGGetActiveTalentGroup
function TalentData.GetTianfuIcon(guancha,zhiye)
	local zuidazhi = {"--",132222,0}
	local index = GetActiveTalentGroup(guancha,false)
	if PIG_MaxTocversion(40000) then
		local numTabs = GetNumTalentTabs(guancha)
		for ti=1,numTabs do
			local itemlistTalentmax = {["pointsSpent"]=0,["name"]=zuidazhi[1],["icon"]=zuidazhi[2]}
			local _, name, _, icon, pointsSpent, background, previewPointsSpent = GetTalentTabInfo(ti,guancha,false,index);
			itemlistTalentmax.pointsSpent=pointsSpent or 0
			itemlistTalentmax.name=name
			itemlistTalentmax.icon=icon
			if itemlistTalentmax.pointsSpent>zuidazhi[3] then
				zuidazhi={itemlistTalentmax.name, itemlistTalentmax.icon or tianfuTabIcon[zhiye][ti] or zuidazhi[2], itemlistTalentmax.pointsSpent}
			end
		end
	elseif PIG_MaxTocversion(50000) then
		local masteryIndex = GetPrimaryTalentTree();
		if masteryIndex then
			local _, name, _, icon, pointsSpent, background, previewPointsSpent = GetTalentTabInfo(masteryIndex,guancha,false,index);
			zuidazhi[1]=name
			zuidazhi[2]=icon
		end
	end
	return zuidazhi
end
function TalentData.GetTianfuIcon_YC(zhiye,namex,from,tfData)
	local zuidazhi = {{"--",132222,""},{"--",132222,""}}
	local tfTXTData={"",""}
	if from=="Houche" then
		tfTXTData[1],tfTXTData[2] =TalentData.HY_TianfuTXT(tfData)
	elseif from=="lx" then
		if PIGA["StatsInfo"] and PIGA["StatsInfo"]["Items"] and PIGA["StatsInfo"]["Items"][namex] then
			tfTXTData[1],tfTXTData[2] =TalentData.HY_TianfuTXT(PIGA["StatsInfo"]["Items"][namex]["T"])
		end
	elseif PIG_OptionsUI.talentData[namex] and PIG_OptionsUI.talentData[namex]["T"] then
		tfTXTData[1] =PIG_OptionsUI.talentData[namex]["T"][2]
		tfTXTData[2] =PIG_OptionsUI.talentData[namex]["T"][3]
	end
	for id=1,#tfTXTData do
		if tfTXTData[id]~="" then
			local xnum = #tfTXTData[id]
			local TFinfo = {}
			for i=1,xnum do
				TFinfo[i]=tfTXTData[id]:sub(i,i)
			end
			local tianfudata = {["xulie"]=0,["zuidaV"]=0,["zuidaID"]=0,[1]=0,[2]=0,[3]=0}
			for i=1,3 do
				for ii=1,TalentData.PIGtianfuhangshu do
					for iii=1,4 do
						if TalentData.tianfuID[zhiye][i][ii][iii] then
							tianfudata.xulie=tianfudata.xulie+1
							local huoqudianshu=tonumber(TFinfo[tianfudata.xulie]) or 0
							tianfudata[i]=tianfudata[i]+huoqudianshu
						end
					end
				end
				if i==3 then
					zuidazhi[id][3]=zuidazhi[id][3]..tianfudata[i]
				else
					zuidazhi[id][3]=zuidazhi[id][3]..tianfudata[i].."-"
				end
				if tianfudata[i]>tianfudata.zuidaV then
					tianfudata.zuidaV=tianfudata[i]
					tianfudata.zuidaID=i
				end	
			end
			if tianfudata.zuidaID>0 then
				zuidazhi[id][1]=TalentData.tianfuTabName[zhiye][tianfudata.zuidaID]
				zuidazhi[id][2]=TalentData.tianfuTabIcon[zhiye][tianfudata.zuidaID]
			end
		end
	end
	return unpack(zuidazhi)
end
local function GetTianfuData(activeGroup,guancha)
	local numTabs = GetNumTalentTabs(guancha)
	local linshiData = {}
	for i=1,numTabs do
		linshiData[i]={}
		for ii=1,TalentData.PIGtianfuhangshu do
			linshiData[i][ii]={}
			for iii=1,4 do
				linshiData[i][ii][iii]="-"
			end
		end
	end
	for i=1,numTabs do
		for ii=1,MAX_NUM_TALENTS do
			local name, iconTexture, tier, column, rank = GetTalentInfo(i, ii, guancha,false,activeGroup)
			if name then
				linshiData[i][tier][column]=rank
			end
		end
	end
	local youxiaozhi = {}
	for i=1,numTabs do
		for ii=1,TalentData.PIGtianfuhangshu do
			for iii=1,4 do
				if linshiData[i][ii][iii]~="-" then
					table.insert(youxiaozhi,linshiData[i][ii][iii])
				end
			end
		end
	end
	local txt = ""
	for i=1,#youxiaozhi do
		txt=txt..youxiaozhi[i]
	end
	return txt
end
function TalentData.GetTianfuNum(guancha)
	local txt = ""
	if PIG_MaxTocversion(50000) then
		local numGroup = GetNumTalentGroups(guancha, false)
		local activeGroup = GetActiveTalentGroup(guancha, false)	
		local code1=GetTianfuData(activeGroup,guancha)
		txt = code1
		if numGroup>1 then
			if activeGroup==1 then
				txt = txt.."&"..GetTianfuData(2,guancha)
			elseif activeGroup==2 then
				txt = txt.."&"..GetTianfuData(1,guancha)
			end
		end
	elseif PIG_MaxTocversion(100000) then
	 -- local currentSpec = C_SpecializationInfo.GetSpecialization()
		 -- TFInfo=TFInfo..currentSpec.."-"
		 -- for i=1,MAX_TALENT_TIERS do
		 -- 	local tierAvailable, selectedTalent, tierUnlockLevel = GetTalentTierInfo(i, 1, false, "player")
		 -- 	if i==MAX_TALENT_TIERS then
		 -- 		TFInfo=TFInfo..selectedTalent
		 -- 	else
		 -- 		TFInfo=TFInfo..selectedTalent.."-"
		 -- 	end
		 -- end
	else
		-- local currentSpec = C_SpecializationInfo.GetSpecialization()
		-- TFInfo=TFInfo..currentSpec.."-"
		-- local exportStream = ExportUtil.MakeExportDataStream();
		-- local configID = C_ClassTalents.GetActiveConfigID()
		-- local currentSpecID = currentSpec
		-- local configInfo = C_Traits.GetConfigInfo(configID)
		-- local treeInfo = C_Traits.GetTreeInfo(configInfo.ID,configInfo.treeIDs[1]);
		-- local treeHash = C_Traits.GetTreeHash(treeInfo.ID);
		-- local serializationVersion = C_Traits.GetLoadoutSerializationVersion()
		-- ClassTalentFrame.TalentsTab:WriteLoadoutHeader(exportStream, serializationVersion, currentSpecID, treeHash);
		-- ClassTalentFrame.TalentsTab:WriteLoadoutContent(exportStream, configID, treeInfo.ID);
		-- local tianinfo=exportStream:GetExportString() or ""
	end
	return txt
end
function TalentData.GetTianfuTXT(guancha)
	local numTxt12 = TalentData.GetTianfuNum(guancha)
	return yasuo_NumberString(numTxt12)
end
function TalentData.HY_TianfuTXT(txt)
	local txt = txt or ""
	local txt = jieya_NumberString(txt)
	local list = {strsplit("&", txt)}
	return unpack(list)
end
---雕文
local function GetGlyphData(activeGroup)
	local data = {};
	for index = 1, TalentData.GLYPH_NUM do
		local enabled, glyphType, glyphTooltipIndex, glyphSpell, iconFilename = GetGlyphSocketInfo(index, activeGroup);
		if glyphSpell ~= nil then
			data[index] = glyphSpell
		end
	end
	local code = "";
	for index = 1, TalentData.GLYPH_NUM do
		local val = data[index] or "";
		if index==TalentData.GLYPH_NUM then
			code = code ..val;
		else
			code = code .. val..":";
		end
	end
	return code
end
function TalentData.GetGlyphNum()
	local txt = ""
	if PIG_MaxTocversion(30000,true) and PIG_MaxTocversion(50000) then
		local numGroup = GetNumTalentGroups(false, false)
		local activeGroup = GetActiveTalentGroup(false, false)
		local code1 =GetGlyphData(activeGroup);
		if numGroup == 1 then
			txt = code1
		elseif numGroup > 1 then
			local code2=""
			if activeGroup==1 then
				code2 =GetGlyphData(2);
			elseif activeGroup==2 then
				code2 =GetGlyphData(1);
			end
			txt = code1.."&"..code2
		end
	end
	return txt
end
function TalentData.GetGlyphTXT()
	local numTxt12 = TalentData.GetGlyphNum()
	return yasuo_NumberString(numTxt12)
end
function TalentData.HY_GlyphTXT(txt)
	local txt = txt or ""
	local txt = jieya_NumberString(txt)
	local data = {}
	local list = {strsplit("&", txt)}
	for i=1,#list do
		data[i] = {}
		local spid = {strsplit(":", list[i])}
		for ii=1,#spid do
			data[i][ii]=spid[ii]
		end
	end
	return unpack(data)
end
---通告属性=================
--1坦克/2治疗/3法系DPS/4近战物理DPS/5远程物理DPS
local TalentTabRole = {
	["DEATHKNIGHT"]={["鲜血"]=1,["冰霜"]=4,["邪恶"]=4},
	["DRUID"] ={["平衡"]=3,["野性战斗"]=4,["恢复"]=2},
	["EVOKER"] = {["恩护"]=2,["湮灭"]=3,["增辉"]=3}, 
	["HUNTER"] ={["野兽控制"]=5,["射击"]=5,["生存"]=5},
	["MAGE"] ={["奥术"]=3,["火焰"]=3,["冰霜"]=3},
	["PALADIN"] ={["神圣"]=2,["防护"]=1,["惩戒"]=4},
	["PRIEST"] ={["戒律"]=2,["神圣"]=2,["暗影"]=3},
	["ROGUE"] ={["刺杀"]=4,["战斗"]=4,["敏锐"]=4},
	["SHAMAN"] ={["元素"]=3,["增强"]=4,["恢复"]=2},
	["WARLOCK"] ={["痛苦"]=3,["恶魔学识"]=3,["毁灭"]=3},
	["WARRIOR"] ={["武器"]=4,["狂怒"]=4,["防护"]=1},
	["MONK"] = {["酒仙"]=1,["织雾"]=2,["踏风"]=4},
	["DEMONHUNTER"] = {["浩劫"]=4,["复仇"]=1},
	
};
local TalentIDRole = {
	["DEATHKNIGHT"]={[250]=1,[251]=4,[252]=4},
	["DRUID"] ={[102]=3,[103]=4,[104]=1,[105]=2},
	["EVOKER"] = {[1467]=2,[1468]=3,[1473]=3}, 
	["HUNTER"] ={[253]=5,[254]=5,[255]=5},
	["MAGE"] ={[62]=3,[63]=3,[64]=3},
	["PALADIN"] ={[65]=2,[66]=1,[70]=4},
	["PRIEST"] ={[256]=2,[257]=2,[258]=3},
	["ROGUE"] ={[259]=4,[260]=4,[261]=4},
	["SHAMAN"] ={[262]=3,[263]=4,[264]=2},
	["WARLOCK"] ={[265]=3,[266]=3,[267]=3},
	["WARRIOR"] ={[71]=4,[72]=4,[73]=1},
	["MONK"] = {[268]=1,[270]=2,[269]=4},
	["DEMONHUNTER"] = {[577]=4,[581]=1},
	
};
local function Player_Stats_1(activeGroup,guancha)
	local txt = ""
	local zuidazhi = {"--",0,""}
	local numTabs = GetNumTalentTabs(guancha)
	for i=1,numTabs do
		local _, name, _, icon, pointsSpent, background, previewPointsSpent = GetTalentTabInfo(i,guancha,false,activeGroup);
		if i==numTabs then
			zuidazhi[3]=zuidazhi[3]..pointsSpent
		else
			zuidazhi[3]=zuidazhi[3]..pointsSpent.."-"
		end
		if pointsSpent>zuidazhi[2] then
			zuidazhi[1]=name
			zuidazhi[2]=pointsSpent
		end
	end
	return zuidazhi[1],zuidazhi[3]
end
local function PIG_GetSpellCritChance()
	local holySchool = 2
    local minCrit = GetSpellCritChance(holySchool);
	for i=(holySchool+1), 7 do
		local spellCrit = GetSpellCritChance(i);
		minCrit = max(minCrit, spellCrit);
	end
	return minCrit
end
local function PIG_GetSpellBonusDamage()--法术伤害加成
	local holySchool = 2
    local minCrit = GetSpellBonusDamage(holySchool);
	for i=(holySchool+1), 7 do
		local spellCrit = GetSpellBonusDamage(i);
		minCrit = max(minCrit, spellCrit);
	end
	return minCrit
end
Fun.PIG_GetSpellBonusDamage=PIG_GetSpellBonusDamage
local function GetStatsData(role)
	local shuxing = ""	
	if role==1 then
		local base, effectiveArmor, armor, bonusArmor= UnitArmor("player");
		local dodgeChance = GetDodgeChance()
		local base, modifier = UnitDefense("player");
		local DefenseTXT = DEFENSE..base+modifier.." "
		local dodgeChance = GetDodgeChance()
		local dodgeChanceTXT=DODGE..string.format("%.2f",dodgeChance).."% "
		local parryChance = GetParryChance()
		local parryChanceTXT=PARRY..string.format("%.2f",parryChance).."% "
		local blockChance = GetBlockChance()
		local blockChanceTXT=BLOCK..string.format("%.2f",blockChance).."%"
		shuxing=shuxing..ARMOR..armor.." "..DefenseTXT..dodgeChanceTXT..parryChanceTXT..blockChanceTXT
	elseif role==2 then
		local SpellBonusHealingV=GetSpellBonusHealing()--法术治疗加成
		shuxing=shuxing..STAT_SPELLHEALING..SpellBonusHealingV.." "
		--local rating = GetCombatRating(CR_HASTE_SPELL);--加速等级
		local ratingBonus = GetCombatRatingBonus(20);--CR_HASTE_SPELL加速百分比
		shuxing=shuxing..RAID_BUFF_4..string.format("%.2f",ratingBonus).."% "
		local powerType, powerToken = UnitPowerType("player");
		if (powerToken == "ENERGY") then
			--local basePowerRegen, castingPowerRegen = GetPowerRegen()
			--shuxing=shuxing..STAT_ENERGY_REGEN..":"..floor((basePowerRegen*5)).."/5s"..MANA_REGEN_COMBAT..floor((castingPowerRegen*5)).."/5s"
		else
			local base, casting = GetManaRegen()--精神2秒回蓝
			shuxing=shuxing..MANA_REGEN..floor((base*5)).."/5s "..MANA_REGEN_COMBAT..floor((casting*5)).."/5s"
		end
	elseif role==3 then
		local BonusDamageV = PIG_GetSpellBonusDamage()--法术伤害加成
		shuxing=shuxing..STAT_SPELLDAMAGE..BonusDamageV.." "
		local SpellHitModifierV=GetSpellHitModifier() or 0--法术命中几率
		if SpellHitModifierV>0 then
			SpellHitModifierV=SpellHitModifierV/7
		end
		local ratingBonus = GetCombatRatingBonus(8);--CR_HIT_SPELL
		shuxing=shuxing..PLAYERSTAT_SPELL_COMBAT..ACTION_RANGE_DAMAGE..string.format("%.2f",SpellHitModifierV+ratingBonus).."% "
		local CritChanceV = PIG_GetSpellCritChance()--法术暴击几率
		--local ratingBonus = GetCombatRatingBonus(CR_CRIT_SPELL);
		shuxing=shuxing..PLAYERSTAT_SPELL_COMBAT..RAID_BUFF_6..string.format("%.2f",CritChanceV).."% "
		local ratingBonus = GetCombatRatingBonus(20);--CR_HASTE_SPELL加速百分比
		shuxing=shuxing..RAID_BUFF_4..string.format("%.2f",ratingBonus).."%"
	elseif role==4 then--近战属性
		if PIG_MaxTocversion() then
			local base, posBuff, negBuff = UnitAttackPower("player");
			local effective = base + posBuff + negBuff
			shuxing=shuxing..MELEE..ATTACK_POWER..effective.." "
			local HitModifierV=GetHitModifier()--命中百分比
			local ratingBonus = GetCombatRatingBonus(6);--CR_HIT_MELEE
			shuxing=shuxing..MELEE..ACTION_RANGE_DAMAGE..string.format("%.2f",HitModifierV+ratingBonus).."% "
			local CritChanceV=GetCritChance()--暴击率百分比
			shuxing=shuxing..MELEE..RAID_BUFF_6..string.format("%.2f",CritChanceV).."% "
			local armorPen = GetArmorPenetration()--返回由于护甲穿透而忽略的物理攻击忽略的目标护甲的百分比
			shuxing=shuxing..ARMOR..SPELL_PENETRATION..string.format("%.2f",armorPen).."%"
		else
			local base, posBuff, negBuff = UnitAttackPower("player");
			local effective = base + posBuff + negBuff
			shuxing=shuxing..MELEE..ATTACK_POWER..effective.." "
			local CritChanceV=GetCritChance()--暴击率百分比
			shuxing=shuxing..MELEE..RAID_BUFF_6..string.format("%.2f",CritChanceV).."% "
		end
	elseif role==5 then--远程属性
		local attackPower, posBuff, negBuff = UnitRangedAttackPower("player")
		local effective = attackPower + posBuff + negBuff
		shuxing=shuxing..RANGED..ATTACK_POWER..effective.." "
		local HitModifierV=GetHitModifier()--命中百分比
		local ratingBonus = GetCombatRatingBonus(7);--CR_HIT_MELEE
		shuxing=shuxing..RANGED..ACTION_RANGE_DAMAGE..string.format("%.2f",HitModifierV+ratingBonus).."% "
		local RangedCritChanceV=GetRangedCritChance()--暴击率
		shuxing=shuxing..RANGED..RAID_BUFF_6..string.format("%.2f",RangedCritChanceV).."% "
		local armorPen = GetArmorPenetration()--返回由于护甲穿透而忽略的物理攻击忽略的目标护甲的百分比
		shuxing=shuxing..ARMOR..SPELL_PENETRATION..string.format("%.2f",armorPen).."%"
	else
		shuxing=ERR_LFG_ROLE_CHECK_FAILED
	end	
	return shuxing
end
local function Player_Stats_2(tianfuID)
	local classFilename, classId = UnitClassBase("player");
	local role=TalentIDRole[classFilename][tianfuID]
	return GetStatsData(role)
end
function TalentData.Player_Stats()
	local Info = "装等"
	local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = GetAverageItemLevel();
	local Info = Info..string.format("%.1f",avgItemLevelEquipped)
	if PIG_MaxTocversion(50000) then
		local tianfutxt = " "..TALENT
		local numGroup = GetNumTalentGroups(false, false)
		local activeGroup = GetActiveTalentGroup(false, false)
		local zhutianfu1,zhutianfu2=Player_Stats_1(activeGroup,false)
		tianfutxt = tianfutxt..zhutianfu1..zhutianfu2
		if numGroup>1 then
			if activeGroup==1 then
				local futianfu1,futianfu2=Player_Stats_1(2,false)
				tianfutxt = tianfutxt.."/"..futianfu1..futianfu2
			elseif activeGroup==2 then
				local futianfu1,futianfu2=Player_Stats_1(1,false)
				tianfutxt = tianfutxt.."/"..futianfu1..futianfu2
			end
		end
		Info =Info..tianfutxt.." "..Player_Stats_2(zhutianfu1)
	else
		local specIndex = GetSpecialization()--当前专精
		local specId, name, description, icon = GetSpecializationInfo(specIndex)
		local name=name ~= "" and name or NONE
		Info =Info.." "..SPECIALIZATION..":"..name.." "..Player_Stats_2(specId)
	end
	return Info
end