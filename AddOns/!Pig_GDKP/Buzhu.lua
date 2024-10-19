local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create, Data, Fun, L, Default, Default_Per= unpack(PIG)
-----
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
local PIGSlider = Create.PIGSlider
local PIGDiyBut=Create.PIGDiyBut
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGQuickBut=Create.PIGQuickBut
local Show_TabBut_R=Create.Show_TabBut_R
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont
-- ----------
local GDKPInfo=addonTable.GDKPInfo

function GDKPInfo.ADD_Buzhu(RaidR)
	local GnName,GnUI,GnIcon,FrameLevel = unpack(GDKPInfo.uidata)
	local iconWH,hang_Height,hang_NUM,lineTOP  =  GDKPInfo.iconWH,GDKPInfo.hang_Height,GDKPInfo.hang_NUM,GDKPInfo.lineTOP
	local RaidR=_G[GnUI]
	local fujiF=PIGOptionsList_R(RaidR.F,"补助/奖励",80)
	--------------
	fujiF.line = PIGLine(fujiF,"C",-3)
	local zhizeIcon=Data.zhizeIcon
	local LeftmenuV=GDKPInfo.LeftmenuV
	local buzhuzhize = GDKPInfo.buzhuzhize
	local buzhuName = buzhuzhize[1].."/"..buzhuzhize[2].."/"..buzhuzhize[3]
	local guolvlist = {{"全部","all"},{buzhuzhize[1],LeftmenuV[1]},{buzhuzhize[2],LeftmenuV[2]},{buzhuzhize[3],LeftmenuV[3]}} 
	fujiF.buzhu_TND = PIGFrame(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",0,0});  
	fujiF.buzhu_TND:SetPoint("BOTTOMRIGHT",fujiF.line,"BOTTOMLEFT",0,0);
	fujiF.buzhu_TND.guangbaoBut = CreateFrame("Button",nil,fujiF.buzhu_TND);  
	fujiF.buzhu_TND.guangbaoBut:SetSize(iconWH,iconWH);
	fujiF.buzhu_TND.guangbaoBut:SetPoint("TOPLEFT", fujiF.buzhu_TND, "TOPLEFT", 6,-4);
	fujiF.buzhu_TND.guangbaoBut:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
	fujiF.buzhu_TND.guangbaoBut.Tex = fujiF.buzhu_TND.guangbaoBut:CreateTexture(nil, "BORDER");
	fujiF.buzhu_TND.guangbaoBut.Tex:SetTexture(130979);
	fujiF.buzhu_TND.guangbaoBut.Tex:SetPoint("CENTER",4,0);
	fujiF.buzhu_TND.guangbaoBut.Tex:SetSize(iconWH,iconWH);
	PIGEnter(fujiF.buzhu_TND.guangbaoBut,"播报"..buzhuName.."补助明细")
	fujiF.buzhu_TND.guangbaoBut:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",2.5,-1.5);
	end);
	fujiF.buzhu_TND.guangbaoBut:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER",4,0);
	end);
    local function bobaoxini(idx)
    	local dataX = PIGA["GDKP"]["Raidinfo"]
		for p=1,#dataX do
			for pp=1,#dataX[p] do
				if dataX[p][pp][4] then
					if dataX[p][pp][4]==LeftmenuV[idx] then
						PIGSendChatRaidParty("["..guolvlist[idx+1][1].."补助]支出"..dataX[p][pp][6].."G<"..dataX[p][pp][1]..">")
					end
				end
			end
		end
	end
	fujiF.buzhu_TND.guangbaoBut:SetScript("OnClick", function()
		local guolvzhiName = guolvlist[fujiF.buzhu_TND.ShowGuolv.value][1]
	    local guolvzhiV = guolvlist[fujiF.buzhu_TND.ShowGuolv.value][2]
	    if guolvzhiV=="all" then
			bobaoxini(1)
			bobaoxini(2)
			bobaoxini(3)
		else
			bobaoxini(fujiF.buzhu_TND.ShowGuolv.value-1)
		end
	end)
	--标题
	local biaotiList = {{"补助玩家",90},{"值/百分比",220},{"补助/G",330}}
	for id = 1, #biaotiList, 1 do
		local biaoti = PIGFontString(fujiF.buzhu_TND,{"TOPLEFT", fujiF.buzhu_TND, "TOPLEFT", biaotiList[id][2],-7},biaotiList[id][1],nil,nil,"buzhu_TND_biaoti_"..id);
		biaoti:SetTextColor(1, 1, 0, 1);
	end
	--显示过滤----------
	fujiF.buzhu_TND.ShowGuolv=PIGDownMenu(fujiF.buzhu_TND,{"RIGHT", buzhu_TND_biaoti_1, "LEFT", 0,0},{62,24})
	fujiF.buzhu_TND.ShowGuolv.value = 1
	function fujiF.buzhu_TND.ShowGuolv:PIGDownMenu_Update_But(self)
		local info = self:PIGDownMenu_CreateInfo()
		info.func = self.PIGDownMenu_SetValue
		for i=1,#guolvlist,1 do
		    info.text, info.arg1, info.arg2 = guolvlist[i][1],guolvlist[i][2], i
		    info.checked = i==self.value
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.buzhu_TND.ShowGuolv:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		self.value=arg2
		RaidR.Update_Buzhu_TND()
		PIGCloseDropDownMenus()
	end
	fujiF.buzhu_TND.hejiV = PIGFontString(fujiF.buzhu_TND,{"LEFT", buzhu_TND_biaoti_1, "RIGHT", 4,0},0);
	fujiF.buzhu_TND.hejiV:SetTextColor(1, 1, 1, 1)

	local function shiqujiaodian(self,bianji)
		if bianji then
			self.V:Hide();
			self.B:Hide();
			self.Q:Show();
			self.E:Show();
		else
			self.V:Show();
			self.B:Show();
			self.Q:Hide();
			self.E:Hide();
		end
	end
	fujiF.buzhu_TND.TOPline = PIGLine(fujiF.buzhu_TND,"TOP",-lineTOP)
	fujiF.buzhu_TND.Scroll = CreateFrame("ScrollFrame",nil,fujiF.buzhu_TND, "FauxScrollFrameTemplate");  
	fujiF.buzhu_TND.Scroll:SetPoint("TOPLEFT",fujiF.buzhu_TND.TOPline,"BOTTOMLEFT",0,-1);
	fujiF.buzhu_TND.Scroll:SetPoint("BOTTOMRIGHT",fujiF.buzhu_TND,"BOTTOMRIGHT",-24,1);
	fujiF.buzhu_TND.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, RaidR.Update_Buzhu_TND)
	end)
	function RaidR.Update_Buzhu_TND()
		if not fujiF.buzhu_TND:IsShown() then return end
		local Pself=fujiF.buzhu_TND.Scroll
		for i = 1, hang_NUM do
			_G["BZbuzhuhang_"..i]:Hide()
	    end
	    local buzhutiquxinxi={};
	    local dataX = PIGA["GDKP"]["Raidinfo"]
	    local guolvzhiV = guolvlist[fujiF.buzhu_TND.ShowGuolv.value][2]
	    if guolvzhiV=="all" then
			for p=1,#dataX do
				for pp=1,#dataX[p] do
					if dataX[p][pp][4] then
						table.insert(buzhutiquxinxi,dataX[p][pp]);
					end
				end
			end
		else
			for p=1,#dataX do
				for pp=1,#dataX[p] do
					if dataX[p][pp][4] then
						if dataX[p][pp][4]==guolvzhiV then
							table.insert(buzhutiquxinxi,dataX[p][pp]);
						end
					end
				end
			end
		end
		fujiF.buzhu_TND.buzhutiquxinxi=buzhutiquxinxi
		local ItemsNum=#buzhutiquxinxi
		fujiF.buzhu_TND.hejiV:SetText(ItemsNum)
	    FauxScrollFrame_Update(Pself, ItemsNum, hang_NUM, hang_Height);
		local offset = FauxScrollFrame_GetOffset(Pself);
		for i = 1, hang_NUM do
			local dangqian = i+offset;
			if buzhutiquxinxi[dangqian] then
				local fameX = _G["BZbuzhuhang_"..i]
				fameX:Show();
				local zhiyecc = buzhutiquxinxi[dangqian][2]
				local buzhuLEI = buzhutiquxinxi[dangqian][4]
				for g=1,#LeftmenuV do
					if buzhuLEI==LeftmenuV[g] then
						fameX.buzhuLX:SetTexCoord(zhizeIcon[g][1],zhizeIcon[g][2],zhizeIcon[g][3],zhizeIcon[g][4]);
					end
				end
				local AllName = buzhutiquxinxi[dangqian][1]
				fameX.AllName=AllName
				local name,server = strsplit("-", AllName);
				if server then
					fameX.name:SetText(name.."(*)")
				else
					fameX.name:SetText(name);
				end
				local color = RAID_CLASS_COLORS[zhiyecc]
				fameX.name:SetTextColor(color.r, color.g, color.b,1);
				if buzhutiquxinxi[dangqian][5] then
					fameX.G.baifen:SetText("%")
					fameX.fenGleixing:SetText("百分比")
					fameX.fenGleixing.Text:SetTextColor(1, 0, 0, 1);
				else
					fameX.G.baifen:SetText("")
					fameX.fenGleixing:SetText("固定值")
					fameX.fenGleixing.Text:SetTextColor(0, 1, 0, 1);
				end
				shiqujiaodian(fameX.G)
				fameX.G.V:SetText(buzhutiquxinxi[dangqian][6]);
			end
		end
		RaidR:UpdateGinfo()
	end
	for id = 1, hang_NUM do
		local hang = CreateFrame("Frame", "BZbuzhuhang_"..id, fujiF.buzhu_TND);
		hang:SetSize(fujiF.buzhu_TND:GetWidth()-25, hang_Height);
		if id==1 then
			hang:SetPoint("TOP",fujiF.buzhu_TND.Scroll,"TOP",0,0);
		else
			hang:SetPoint("TOP",_G["BZbuzhuhang_"..(id-1)],"BOTTOM",0,0);
		end
		if id~=hang_NUM then PIGLine(hang,"BOT",nil,nil,nil,{0.3,0.3,0.3,0.3}) end
		hang.buzhuLX = hang:CreateTexture(nil, "BORDER");
		hang.buzhuLX:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
		hang.buzhuLX:SetPoint("LEFT", hang, "LEFT", 4,0);
		hang.buzhuLX:SetSize(hang_Height-4,hang_Height-4);
		hang.name = PIGFontString(hang,{"LEFT", hang.buzhuLX, "RIGHT", 0, 0},"","OUTLINE");
		--
		hang.fenGleixing = CreateFrame("Button",nil,hang, "TruncatedButtonTemplate");
		hang.fenGleixing:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		hang.fenGleixing:SetSize(66,hang_Height-4);
		hang.fenGleixing:SetPoint("LEFT", hang, "LEFT", biaotiList[2][2],0);
		PIGSetFont(hang.fenGleixing.Text,14,"OUTLINE")
		hang.fenGleixing:SetScript("OnClick", function (self)
			local shangjiFF=self:GetParent()
	 		local bianjiName=shangjiFF.AllName
			local dataX = PIGA["GDKP"]["Raidinfo"]
			for e=1,#dataX do
				for ee=1,#dataX[e] do
					if dataX[e][ee][1]==bianjiName then
						dataX[e][ee][6]=0
						if dataX[e][ee][5] then
							dataX[e][ee][5]=false
						else
							dataX[e][ee][5]=true
						end
						break
					end
				end
			end
			RaidR.Update_Buzhu_TND()
		end);
		--
		hang.G = CreateFrame("Frame", nil, hang);
		hang.G:SetSize(58, hang_Height);
		hang.G:SetPoint("RIGHT", hang, "RIGHT", -34,0);
		hang.G.baifen = PIGFontString(hang.G,{"RIGHT", hang.G, "RIGHT", 0,0});
		hang.G.baifen:SetTextColor(1, 1, 1, 1);
		hang.G.V = PIGFontString(hang.G,{"RIGHT", hang.G.baifen, "LEFT", 0,0});
		hang.G.V:SetTextColor(1, 1, 1, 1);
		hang.G.E = CreateFrame("EditBox", nil, hang.G, "InputBoxInstructionsTemplate");
		hang.G.E:SetSize(54,hang_Height);
		hang.G.E:SetPoint("RIGHT", hang.G, "RIGHT", 0,0);
		PIGSetFont(hang.G.E,14,"OUTLINE")
		hang.G.E:SetMaxLetters(6)
		hang.G.E:SetNumeric(true)
		hang.G.E:SetScript("OnEscapePressed", function(self) 
			shiqujiaodian(self:GetParent())
		end);
		hang.G.E:SetScript("OnEnterPressed", function(self)
			local shangjiF=self:GetParent()
	 		local BuzhuNewV=self:GetNumber();
	 		shangjiF.V:SetText(BuzhuNewV);
	 		local shangjiFF=shangjiF:GetParent()
	 		local bianjiName=shangjiFF.AllName
	 		local dataX = PIGA["GDKP"]["Raidinfo"]
			for e=1,#dataX do
				for ee=1,#dataX[e] do
					if dataX[e][ee][1]==bianjiName then
						dataX[e][ee][6]=BuzhuNewV;
					end
				end
			end
			RaidR.Update_Buzhu_TND()
		end);
		hang.G.B = CreateFrame("Button",nil,hang.G, "TruncatedButtonTemplate");
		hang.G.B:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		hang.G.B:SetSize(hang_Height-7,hang_Height-7);
		hang.G.B:SetPoint("LEFT", hang.G, "RIGHT", 0,0);
		hang.G.B.Texture = hang.G.B:CreateTexture(nil, "BORDER");
		hang.G.B.Texture:SetTexture("interface/buttons/ui-guildbutton-publicnote-up.blp");
		hang.G.B.Texture:SetPoint("CENTER");
		hang.G.B.Texture:SetSize(hang_Height-12,hang_Height-10);
		hang.G.B:SetScript("OnMouseDown", function (self)
			self.Texture:SetPoint("CENTER",-1.5,-1.5);
		end);
		hang.G.B:SetScript("OnMouseUp", function (self)
			self.Texture:SetPoint("CENTER");
		end);
		hang.G.B:SetScript("OnClick", function (self)
			for xx=1,hang_NUM do
				shiqujiaodian(_G["BZbuzhuhang_"..xx].G)
			end
			local shangjiF=self:GetParent()
			shiqujiaodian(shangjiF,true)
			shangjiF.E:SetText(shangjiF.V:GetText());
		end);
		hang.G.Q = PIGButton(hang.G, {"LEFT", hang.G, "RIGHT", 1,0},{36,20},"确定");
		hang.G.Q:SetScale(0.88)
		hang.G.Q:Hide();
		hang.G.Q:SetScript("OnClick", function (self)
			local shangjiF=self:GetParent()
	 		local BuzhuNewV=shangjiF.E:GetNumber();
	 		shangjiF.V:SetText(BuzhuNewV);
	 		local shangjiFF=shangjiF:GetParent()
	 		local bianjiName=shangjiFF.AllName
	 		local dataX = PIGA["GDKP"]["Raidinfo"]
			for e=1,#dataX do
				for ee=1,#dataX[e] do
					if dataX[e][ee][1]==bianjiName then
						dataX[e][ee][6]=BuzhuNewV;
					end
				end
			end
			RaidR.Update_Buzhu_TND()
		end);
	end
	fujiF.buzhu_TND:SetScript("OnShow", function (self)
		self.ShowGuolv:PIGDownMenu_SetText(guolvlist[self.ShowGuolv.value][1])
		RaidR.Update_Buzhu_TND()
	end)
	---
	fujiF.buzhu_TND.yedibuF = PIGLine(fujiF.buzhu_TND,"BOT",lineTOP)
	fujiF.buzhu_TND.tishi = CreateFrame("Frame", nil, fujiF.buzhu_TND);
	fujiF.buzhu_TND.tishi:SetSize(iconWH,iconWH);
	fujiF.buzhu_TND.tishi:SetPoint("TOPLEFT",fujiF.buzhu_TND.yedibuF,"BOTTOMLEFT",6,-4);
	fujiF.buzhu_TND.tishi.Tex = fujiF.buzhu_TND.tishi:CreateTexture(nil, "BORDER");
	fujiF.buzhu_TND.tishi.Tex:SetTexture("interface/common/help-i.blp");
	fujiF.buzhu_TND.tishi.Tex:SetSize(iconWH+8,iconWH+8);
	fujiF.buzhu_TND.tishi.Tex:SetPoint("CENTER");
	PIGEnter(fujiF.buzhu_TND.tishi,"\124cff00ff00补助人员请在人员信息界面设置\124r")
	local LeftmenuV = LeftmenuV
	local function huoquguolvshujuD(buzhuVleixing)
		local dataX = PIGA["GDKP"]["Raidinfo"]
	    local guolvzhiName = guolvlist[fujiF.buzhu_TND.ShowGuolv.value][1]
	    local guolvzhiV = guolvlist[fujiF.buzhu_TND.ShowGuolv.value][2]
    	for p=1,#dataX do
			for pp=1,#dataX[p] do
				if dataX[p][pp][4] then
					if guolvzhiV=="all" then
						if buzhuVleixing=="V" then
							dataX[p][pp][5]=false
						elseif buzhuVleixing=="%" then
							dataX[p][pp][5]=true
						end
						dataX[p][pp][6]=0
					else
						if dataX[p][pp][4]==guolvzhiV then
							if buzhuVleixing=="V" then
								dataX[p][pp][5]=false
							elseif buzhuVleixing=="%" then
								dataX[p][pp][5]=true
							end
							dataX[p][pp][6]=0
						end
					end
				end
			end
		end
	end
	fujiF.buzhu_TND.guding = PIGButton(fujiF.buzhu_TND,{"TOPLEFT",fujiF.buzhu_TND.yedibuF,"BOTTOMLEFT",30,-4},{126,22},"批量转值/百分比");
	fujiF.buzhu_TND.guding:SetScript("OnClick", function (self)
		if self.bafenbi then
			self.bafenbi=false
			huoquguolvshujuD("V")
		else
			self.bafenbi=true
			huoquguolvshujuD("%")
		end
		RaidR.Update_Buzhu_TND()
	end);
	fujiF.buzhu_TND.piliangBut = PIGButton(fujiF.buzhu_TND,{"TOPRIGHT",fujiF.buzhu_TND.yedibuF,"BOTTOMRIGHT",-10,-4},{72,22},"批量设置");
	fujiF.buzhu_TND.piliangBut:SetScale(0.94)
	fujiF.buzhu_TND.piliangBut:SetScript("OnClick", function (self)
		local BuzhuNewV = self.E:GetNumber();
		self.E:ClearFocus()
		local dataX = PIGA["GDKP"]["Raidinfo"]
	    local guolvzhiName = guolvlist[fujiF.buzhu_TND.ShowGuolv.value][1]
	    local guolvzhiV = guolvlist[fujiF.buzhu_TND.ShowGuolv.value][2]
    	for p=1,#dataX do
			for pp=1,#dataX[p] do
				if dataX[p][pp][4] then
					if guolvzhiV=="all" then
						dataX[p][pp][6]=BuzhuNewV
					else
						if dataX[p][pp][4]==guolvzhiV then
							dataX[p][pp][6]=BuzhuNewV
						end
					end
				end
			end
		end
		RaidR.Update_Buzhu_TND()
	end);
	fujiF.buzhu_TND.piliangBut.E = CreateFrame("EditBox", nil, fujiF.buzhu_TND.piliangBut, "InputBoxInstructionsTemplate");
	fujiF.buzhu_TND.piliangBut.E:SetSize(60,20);
	fujiF.buzhu_TND.piliangBut.E:SetPoint("RIGHT",fujiF.buzhu_TND.piliangBut,"LEFT",-4,0);
	PIGSetFont(fujiF.buzhu_TND.piliangBut.E,14,"OUTLINE")
	fujiF.buzhu_TND.piliangBut.E:SetMaxLetters(6)
	fujiF.buzhu_TND.piliangBut.E:SetAutoFocus(false)
	fujiF.buzhu_TND.piliangBut.E:SetNumeric(true)
	fujiF.buzhu_TND.piliangBut.E:SetTextColor(0.6, 0.6, 0.6, 0.8); 
	fujiF.buzhu_TND.piliangBut.E:SetText(100);
	fujiF.buzhu_TND.piliangBut.E:SetScript("OnEscapePressed", function(self)
		self:ClearFocus() 
	end);
	fujiF.buzhu_TND.piliangBut.E:SetScript("OnEditFocusGained", function(self)
		self:SetTextColor(1, 1, 1, 1); 
	end)
	fujiF.buzhu_TND.piliangBut.E:SetScript("OnEnterPressed", function(self)  
		self:ClearFocus() 
	end);
	fujiF.buzhu_TND.piliangBut.E:SetScript("OnEditFocusLost", function(self) 
		self:SetTextColor(0.5, 0.5, 0.5, 0.8);
	end)


	---奖励补助==========
	fujiF.buzhu_QITA = PIGFrame(fujiF,{"TOPLEFT",fujiF.line,"TOPRIGHT",0,0});  
	fujiF.buzhu_QITA:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",0,0);
	fujiF.buzhu_QITA.yedibuF = PIGLine(fujiF.buzhu_QITA,"BOT",lineTOP)
	fujiF.buzhu_QITA.guangbaoBut = CreateFrame("Button",nil,fujiF.buzhu_QITA);  
	fujiF.buzhu_QITA.guangbaoBut:SetSize(iconWH,iconWH);
	fujiF.buzhu_QITA.guangbaoBut:SetPoint("TOPLEFT", fujiF.buzhu_QITA, "TOPLEFT", 6,-4);
	fujiF.buzhu_QITA.guangbaoBut:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
	fujiF.buzhu_QITA.guangbaoBut.Tex = fujiF.buzhu_QITA.guangbaoBut:CreateTexture(nil, "BORDER");
	fujiF.buzhu_QITA.guangbaoBut.Tex:SetTexture(130979);
	fujiF.buzhu_QITA.guangbaoBut.Tex:SetPoint("CENTER",4,0);
	fujiF.buzhu_QITA.guangbaoBut.Tex:SetSize(iconWH,iconWH);
	PIGEnter(fujiF.buzhu_QITA.guangbaoBut,"播报奖励明细")
	fujiF.buzhu_QITA.guangbaoBut:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",2.5,-1.5);
	end);
	fujiF.buzhu_QITA.guangbaoBut:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER",4,0);
	end);
	fujiF.buzhu_QITA.guangbaoBut:SetScript("OnClick", function()
		local dataX = PIGA["GDKP"]["jiangli"]
    	for p=1,#dataX do
			if dataX[p][3]~="N/A" then
				PIGSendChatRaidParty("["..dataX[p][1].."]支出"..dataX[p][2].."G<"..dataX[p][3]..">")
			end
		end
	end)
	--标题
	local biaotiList1 = {{"奖励项目",30},{"值/百分比",140},{"奖励/G",214},{"奖励人",290}}
	for id = 1, #biaotiList1, 1 do
		local biaoti = PIGFontString(fujiF.buzhu_QITA,{"TOPLEFT", fujiF.buzhu_QITA, "TOPLEFT", biaotiList1[id][2],-7},biaotiList1[id][1],nil,nil,"buzhu_QITA_biaoti_"..id);
		biaoti:SetTextColor(1, 1, 0, 1);
	end
	fujiF.buzhu_QITA.tishi = CreateFrame("Frame", nil, fujiF.buzhu_QITA);
	fujiF.buzhu_QITA.tishi:SetSize(iconWH-2,iconWH-2);
	fujiF.buzhu_QITA.tishi:SetPoint("LEFT",buzhu_QITA_biaoti_4,"RIGHT",1,0);
	fujiF.buzhu_QITA.tishi.Tex = fujiF.buzhu_QITA.tishi:CreateTexture(nil, "BORDER");
	fujiF.buzhu_QITA.tishi.Tex:SetTexture("interface/friendsframe/reportspamicon.blp");
	fujiF.buzhu_QITA.tishi.Tex:SetSize(iconWH+6,iconWH+6);
	fujiF.buzhu_QITA.tishi.Tex:SetPoint("TOPLEFT",1,-3);
	PIGEnter(fujiF.buzhu_QITA.tishi,"\124cffff0000注意: 未选择奖励人的项目不会计入奖励支出\124r")
	--添加项目-----
	fujiF.buzhu_QITA.Add = PIGButton(fujiF.buzhu_QITA, {"LEFT",buzhu_QITA_biaoti_1,"RIGHT",2,0},{20,20},"+");
	PIGSetFont(fujiF.buzhu_QITA.Add.Text,20,"OUTLINE")
	fujiF.buzhu_QITA.Add:SetScript("OnClick", function (self)
		if self.F:IsShown() then
			self.F:Hide();
		else
			fujiF.buzhu_QITA.SaveBut.F:Hide();
			self.F:Show();
		end
	end);
	fujiF.buzhu_QITA.Add.F = PIGFrame(fujiF.buzhu_QITA.Add,{"TOPLEFT",fujiF.buzhu_QITA,"TOPLEFT",80,-34});
	fujiF.buzhu_QITA.Add.F:SetPoint("BOTTOMRIGHT",fujiF.buzhu_QITA,"BOTTOMRIGHT",-6,36);
	fujiF.buzhu_QITA.Add.F:PIGSetBackdrop(1)
	fujiF.buzhu_QITA.Add.F:PIGClose()
	fujiF.buzhu_QITA.Add.F:SetFrameLevel(fujiF.buzhu_QITA.Add:GetFrameLevel()+10);
	fujiF.buzhu_QITA.Add.F:EnableMouse(true);
	fujiF.buzhu_QITA.Add.F:Hide();
	fujiF.buzhu_QITA:HookScript("OnHide", function (self)
		self.Add.F:Hide()
	end)
	fujiF.buzhu_QITA.Add.F.biaoti = PIGFontString(fujiF.buzhu_QITA.Add.F,{"TOP",fujiF.buzhu_QITA.Add.F,"TOP",0,-6},"添加奖励事件","OUTLINE",16);
	fujiF.buzhu_QITA.Add.F.shijianNameT = PIGFontString(fujiF.buzhu_QITA.Add.F,{"TOP",fujiF.buzhu_QITA.Add.F,"TOP",0,-50},"事件名称","OUTLINE",15);
	fujiF.buzhu_QITA.Add.F.shijianNameT:SetTextColor(0,1,0, 1);

	fujiF.buzhu_QITA.Add.F.shijianName = CreateFrame("EditBox", nil, fujiF.buzhu_QITA.Add.F, "InputBoxInstructionsTemplate");
	fujiF.buzhu_QITA.Add.F.shijianName:SetSize(200,34);
	fujiF.buzhu_QITA.Add.F.shijianName:SetPoint("TOP",fujiF.buzhu_QITA.Add.F.shijianNameT,"BOTTOM",0,-10);
	PIGSetFont(fujiF.buzhu_QITA.Add.F.shijianName,14,"OUTLINE")
	fujiF.buzhu_QITA.Add.F.shijianName:SetMaxLetters(30)
	fujiF.buzhu_QITA.Add.F.shijianName:SetAutoFocus(false);
	fujiF.buzhu_QITA.Add.F.shijianName:SetScript("OnEscapePressed", function(self) 
		self:ClearFocus() 
	end);
	fujiF.buzhu_QITA.Add.F.err = PIGFontString(fujiF.buzhu_QITA.Add.F,{"TOP",fujiF.buzhu_QITA.Add.F.shijianName,"BOTTOM",0,-10},"","OUTLINE",16);
	fujiF.buzhu_QITA.Add.F.err:SetTextColor(1,0,0, 1);
	fujiF.buzhu_QITA.Add.F.YES = PIGButton(fujiF.buzhu_QITA.Add.F, {"TOP",fujiF.buzhu_QITA.Add.F,"TOP",-60,-150},{80,24},"添加"); 
	fujiF.buzhu_QITA.Add.F.YES:SetScript("OnClick", function (self)
		local fuji = self:GetParent()
		local huoquV=fuji.shijianName:GetText();
		if huoquV==nil then
			fuji.err:SetText("添加失败：事件不能为空");
			return
		end
		local huoquV=huoquV:gsub(" ","")
		if  huoquV=="" or huoquV==" " then
			fuji.err:SetText("添加失败：事件不能为空");
			return
		end
			for i=1,#PIGA["GDKP"]["jiangli"] do
				if huoquV==PIGA["GDKP"]["jiangli"][i][1] then
					fuji.err:SetText("添加失败：已存在同名事件");
					return
				end
			end
			local qitashouruinfo={huoquV,0,"N/A",false};
			table.insert(PIGA["GDKP"]["jiangli"],qitashouruinfo);
			fuji:Hide();
			RaidR.Update_Buzhu_QITA()
	end);
	fujiF.buzhu_QITA.Add.F.NO = PIGButton(fujiF.buzhu_QITA.Add.F, {"TOP",fujiF.buzhu_QITA.Add.F,"TOP",60,-150},{80,24},"取消"); 
	fujiF.buzhu_QITA.Add.F.NO:SetScript("OnClick", function (self)
		local fuji = self:GetParent()
		fuji:Hide();
		fuji.err:SetText("");
	end);
	------
	fujiF.buzhu_QITA.TOPline = PIGLine(fujiF.buzhu_QITA,"TOP",-lineTOP)
	fujiF.buzhu_QITA.Scroll = CreateFrame("ScrollFrame",nil,fujiF.buzhu_QITA, "FauxScrollFrameTemplate");  
	fujiF.buzhu_QITA.Scroll:SetPoint("TOPLEFT",fujiF.buzhu_QITA.TOPline,"BOTTOMLEFT",0,-1);
	fujiF.buzhu_QITA.Scroll:SetPoint("BOTTOMRIGHT",fujiF.buzhu_QITA,"BOTTOMRIGHT",-24,1);
	fujiF.buzhu_QITA.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, RaidR.Update_Buzhu_QITA)
	end)
	function RaidR.Update_Buzhu_QITA()
		if not fujiF.buzhu_QITA:IsShown() then return end
		local self = fujiF.buzhu_QITA.Scroll
		for i = 1, hang_NUM do
			_G["QTfakuanhang_"..i]:Hide()
	    end
		local dataX = PIGA["GDKP"]["jiangli"]
		local ItemsNum=#dataX
		FauxScrollFrame_Update(self, ItemsNum, hang_NUM, hang_Height);
		local offset = FauxScrollFrame_GetOffset(self);
		for i = 1, hang_NUM do
			local dangqian = i+offset;
			if dataX[dangqian] then
				local fameX = _G["QTfakuanhang_"..i]
				fameX:Show();
				fameX.del:SetID(dangqian);
				fameX.jianglixiang:SetText(dataX[dangqian][1])
				fameX.fenGleixing:SetID(dangqian);
				if dataX[dangqian][4] then
					fameX.G.baifen:SetText("%")
					fameX.fenGleixing:SetText("百分比")
					fameX.fenGleixing.Text:SetTextColor(1, 0, 0, 1);
				else
					fameX.G.baifen:SetText("")
					fameX.fenGleixing:SetText("固定值")
					fameX.fenGleixing.Text:SetTextColor(0, 1, 0, 1);
				end
				shiqujiaodian(fameX.G)
				fameX.G.E:SetID(dangqian);
				fameX.G.Q:SetID(dangqian);
				fameX.G.V:SetText(dataX[dangqian][2])
				fameX.JiangliRen:SetID(dangqian);
				local AllName = dataX[dangqian][3]
				if AllName=="N/A" then
					fameX.JiangliRen:SetText("\124cffff0000        "..NONE.."\124r");
				else
					local name,server = strsplit("-", AllName);
					if server then
						fameX.JiangliRen:SetText(name.."(*)")
					else
						fameX.JiangliRen:SetText(name);
					end
					-- local color = RAID_CLASS_COLORS[zhiyecc]
					-- fameX.JiangliRen:SetTextColor(color.r, color.g, color.b,1);
				end
			end
		end
		RaidR:UpdateGinfo()
	end
	for id = 1, hang_NUM do
		local hang = CreateFrame("Frame", "QTfakuanhang_"..id, fujiF.buzhu_QITA);
		hang:SetSize(fujiF.buzhu_QITA:GetWidth()-25, hang_Height);
		if id==1 then
			hang:SetPoint("TOP",fujiF.buzhu_QITA.Scroll,"TOP",0,0);
		else
			hang:SetPoint("TOP",_G["QTfakuanhang_"..(id-1)],"BOTTOM",0,0);
		end
		if id~=hang_NUM then PIGLine(hang,"BOT",nil,nil,nil,{0.3,0.3,0.3,0.3}) end
		hang.del = PIGDiyBut(hang,{"LEFT", hang, "LEFT", 0,0},{hang_Height-8})
		hang.del:SetScript("OnClick", function (self)
			local dataX = PIGA["GDKP"]["jiangli"]
	    	for p=1,#dataX do
				table.remove(dataX,self:GetID())
				RaidR.Update_Buzhu_QITA()
				return
			end
		end);
		hang.jianglixiang = PIGFontString(hang,{"LEFT", hang.del, "RIGHT", 0,0});
		hang.jianglixiang:SetTextColor(0, 1, 1, 1);
		hang.fenGleixing = CreateFrame("Button",nil,hang, "TruncatedButtonTemplate");
		hang.fenGleixing:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		hang.fenGleixing:SetSize(66,hang_Height-4);
		hang.fenGleixing:SetPoint("LEFT", hang, "LEFT", biaotiList1[2][2]-10,0);
		PIGSetFont(hang.fenGleixing.Text,14,"OUTLINE")
		hang.fenGleixing:SetScript("OnClick", function (self)
			local dataX = PIGA["GDKP"]["jiangli"]
			dataX[self:GetID()][2]=0
    		if dataX[self:GetID()][4] then
				dataX[self:GetID()][4]=false
			else
				dataX[self:GetID()][4]=true
			end
			RaidR.Update_Buzhu_QITA()
		end);
		--
		hang.G = CreateFrame("Frame", nil, hang);
		hang.G:SetSize(58, hang_Height);
		hang.G:SetPoint("LEFT", hang, "LEFT", biaotiList1[3][2]-26,0);
		hang.G.baifen = PIGFontString(hang.G,{"RIGHT", hang.G, "RIGHT", 0,0});
		hang.G.baifen:SetTextColor(1, 1, 1, 1);
		hang.G.V = PIGFontString(hang.G,{"RIGHT", hang.G.baifen, "LEFT", 0,0});
		hang.G.V:SetTextColor(1, 1, 1, 1);
		hang.G.E = CreateFrame("EditBox", nil, hang.G, "InputBoxInstructionsTemplate");
		hang.G.E:SetSize(54,hang_Height);
		hang.G.E:SetPoint("RIGHT", hang.G, "RIGHT", 0,0);
		PIGSetFont(hang.G.E,14,"OUTLINE")
		hang.G.E:SetMaxLetters(6)
		hang.G.E:SetNumeric(true)
		hang.G.E:SetScript("OnEscapePressed", function(self) 
			shiqujiaodian(self:GetParent())
		end);
		hang.G.E:SetScript("OnEnterPressed", function(self)
	 		PIGA["GDKP"]["jiangli"][self:GetID()][2]=self:GetNumber()
			RaidR.Update_Buzhu_QITA()
		end);
		hang.G.B = CreateFrame("Button",nil,hang.G, "TruncatedButtonTemplate");
		hang.G.B:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		hang.G.B:SetSize(hang_Height-7,hang_Height-7);
		hang.G.B:SetPoint("LEFT", hang.G, "RIGHT", 0,0);
		hang.G.B.Texture = hang.G.B:CreateTexture(nil, "BORDER");
		hang.G.B.Texture:SetTexture("interface/buttons/ui-guildbutton-publicnote-up.blp");
		hang.G.B.Texture:SetPoint("CENTER");
		hang.G.B.Texture:SetSize(hang_Height-12,hang_Height-10);
		hang.G.B:SetScript("OnMouseDown", function (self)
			self.Texture:SetPoint("CENTER",-1.5,-1.5);
		end);
		hang.G.B:SetScript("OnMouseUp", function (self)
			self.Texture:SetPoint("CENTER");
		end);
		hang.G.B:SetScript("OnClick", function (self)
			for xx=1,hang_NUM do
				shiqujiaodian(_G["QTfakuanhang_"..xx].G)
			end
			local shangjiF=self:GetParent()
			shiqujiaodian(shangjiF,true)
			shangjiF.E:SetText(shangjiF.V:GetText());
		end);
		hang.G.Q = PIGButton(hang.G, {"LEFT", hang.G, "RIGHT", 1,0},{36,20},"确定");
		hang.G.Q:SetScale(0.88)
		hang.G.Q:Hide();
		hang.G.Q:SetScript("OnClick", function (self)
			local shangjiF=self:GetParent()
	 		PIGA["GDKP"]["jiangli"][self:GetID()][2]=shangjiF.E:GetNumber()
			RaidR.Update_Buzhu_QITA()
		end);
		hang.JiangliRen = CreateFrame("Button", nil, hang, "TruncatedButtonTemplate");
		hang.JiangliRen:SetHighlightTexture("interface/paperdollinfoframe/ui-character-tab-highlight.blp");
		hang.JiangliRen:SetSize(118,hang_Height);
		hang.JiangliRen:SetPoint("RIGHT", hang, "RIGHT", 6,0);
		PIGSetFont(hang.JiangliRen.Text,14,"OUTLINE")
		hang.JiangliRen.Text:SetJustifyH("LEFT")
		hang.JiangliRen.Text:SetTextColor(0,1,0, 1);
		hang.JiangliRen:SetScript("OnClick", function (self)
			if RaidR.PlayerList:IsShown() then
				RaidR.PlayerList:Hide() 
			else
				RaidR.PlayerList:Showtishi("JiangliRen",self:GetID())
			end
		end);
	end
	fujiF.buzhu_QITA:SetScript("OnShow", function (self)
		RaidR.Update_Buzhu_QITA()
	end)

	local function huoqujiangliD(buzhuVleixing)
		local dataX = PIGA["GDKP"]["jiangli"]
    	for p=1,#dataX do
			if buzhuVleixing=="V" then
				dataX[p][4]=false
			elseif buzhuVleixing=="%" then
				dataX[p][4]=true
			end
			dataX[p][2]=0
		end
	end
	fujiF.buzhu_QITA.guding = PIGButton(fujiF.buzhu_QITA,{"TOPLEFT",fujiF.buzhu_QITA.yedibuF,"BOTTOMLEFT",30,-4},{126,22},"批量转值/百分比");
	fujiF.buzhu_QITA.guding:SetScript("OnClick", function (self)
		if self.bafenbi then
			self.bafenbi=false
			huoqujiangliD("V")
		else
			self.bafenbi=true
			huoqujiangliD("%")
		end
		RaidR.Update_Buzhu_QITA()
	end);
	--导入奖励设置----------
	fujiF.buzhu_QITA.daoruBut=PIGDownMenu(fujiF.buzhu_TND,{"TOPRIGHT",fujiF.buzhu_QITA.yedibuF,"BOTTOMRIGHT",-10,-4},{60,22})
	fujiF.buzhu_QITA.daoruBut:PIGDownMenu_SetText("导入")
	function fujiF.buzhu_QITA.daoruBut:PIGDownMenu_Update_But(self)
		local info = self:PIGDownMenu_CreateInfo()
		info.func = self.PIGDownMenu_SetValue
		local ziding = PIGA["GDKP"]["jiangli_config"]
		for k,v in pairs(ziding) do
			info.text, info.arg1 = k,v
			info.notCheckable = true;
			self:PIGDownMenu_AddButton(info)
		end
	end
	function fujiF.buzhu_QITA.daoruBut:PIGDownMenu_SetValue(value,arg1,arg2)
		local ziding = PIGA["GDKP"]["jiangli_config"][value]
		local dataX = PIGA["GDKP"]["jiangli"]
		for p=1,#dataX do
			dataX[p][2]=0
			dataX[p][4]=false
			local bzname = dataX[p][1]
			if ziding[bzname] then
				dataX[p][2]=ziding[bzname][1]
				dataX[p][4]=ziding[bzname][2]
			end
		end
		RaidR.Update_Buzhu_QITA()
		PIGCloseDropDownMenus()
	end

	fujiF.buzhu_QITA.SaveBut = PIGButton(fujiF.buzhu_QITA,{"RIGHT",fujiF.buzhu_QITA.daoruBut,"LEFT",-10,0},{106,22},"保存奖励设置");
	fujiF.buzhu_QITA.SaveBut:SetScript("OnClick", function (self)
		if self.F:IsShown() then
			self.F:Hide();
		else
			fujiF.buzhu_QITA.SaveBut.F:qingkong()
			self.F:Show();
		end
	end);

	fujiF.buzhu_QITA.SaveBut.F = PIGFrame(fujiF.buzhu_QITA.SaveBut,{"TOPLEFT",fujiF.buzhu_QITA,"TOPLEFT",80,-34});
	fujiF.buzhu_QITA.SaveBut.F:SetPoint("BOTTOMRIGHT",fujiF.buzhu_QITA,"BOTTOMRIGHT",-6,36);
	fujiF.buzhu_QITA.SaveBut.F:PIGSetBackdrop(1)
	fujiF.buzhu_QITA.SaveBut.F:PIGClose()
	fujiF.buzhu_QITA.SaveBut.F:SetFrameLevel(fujiF.buzhu_QITA.SaveBut:GetFrameLevel()+10);
	fujiF.buzhu_QITA.SaveBut.F:EnableMouse(true);
	fujiF.buzhu_QITA.SaveBut.F:Hide();
	fujiF.buzhu_QITA:HookScript("OnHide", function (self)
		self.SaveBut.F:Hide()
	end)
	fujiF.buzhu_QITA.SaveBut.F.biaoti = PIGFontString(fujiF.buzhu_QITA.SaveBut.F,{"TOP",fujiF.buzhu_QITA.SaveBut.F,"TOP",0,-6},"保存奖励设置","OUTLINE",16);
	fujiF.buzhu_QITA.SaveBut.F.shijianNameT = PIGFontString(fujiF.buzhu_QITA.SaveBut.F,{"TOP",fujiF.buzhu_QITA.SaveBut.F,"TOP",-80,-50},"设置名称","OUTLINE",15);
	fujiF.buzhu_QITA.SaveBut.F.shijianNameT:SetTextColor(0,1,0, 1);

	fujiF.buzhu_QITA.SaveBut.F.oldName=PIGDownMenu(fujiF.buzhu_QITA.SaveBut.F,{"LEFT",fujiF.buzhu_QITA.SaveBut.F.shijianNameT,"RIGHT",10,0},{120,22})
	fujiF.buzhu_QITA.SaveBut.F.oldName:PIGDownMenu_SetText("选择已有设置")
	function fujiF.buzhu_QITA.SaveBut.F.oldName:PIGDownMenu_Update_But(self)
		local info = self:PIGDownMenu_CreateInfo()
		info.func = self.PIGDownMenu_SetValue
		local ziding = PIGA["GDKP"]["jiangli_config"]
		for k,v in pairs(ziding) do
			info.text, info.arg1 = k,v
			info.notCheckable = true;
			self:PIGDownMenu_AddButton(info)
		end
	end
	function fujiF.buzhu_QITA.SaveBut.F.oldName:PIGDownMenu_SetValue(value,arg1,arg2)
		fujiF.buzhu_QITA.SaveBut.F.shijianName:SetText(value)
		fujiF.buzhu_QITA.SaveBut.F.YES:SetText("覆盖")
		fujiF.buzhu_QITA.SaveBut.F.del:Show()
		RaidR.Update_Buzhu_QITA()
		PIGCloseDropDownMenus()
	end

	fujiF.buzhu_QITA.SaveBut.F.shijianName = CreateFrame("EditBox", nil, fujiF.buzhu_QITA.SaveBut.F, "InputBoxInstructionsTemplate");
	fujiF.buzhu_QITA.SaveBut.F.shijianName:SetSize(200,34);
	fujiF.buzhu_QITA.SaveBut.F.shijianName:SetPoint("TOP",fujiF.buzhu_QITA.SaveBut.F,"TOP",0,-80);
	PIGSetFont(fujiF.buzhu_QITA.SaveBut.F.shijianName,14,"OUTLINE")
	fujiF.buzhu_QITA.SaveBut.F.shijianName:SetMaxLetters(30)
	fujiF.buzhu_QITA.SaveBut.F.shijianName:SetAutoFocus(false);
	fujiF.buzhu_QITA.SaveBut.F.shijianName:SetScript("OnEscapePressed", function(self) 
		self:ClearFocus() 
	end);
	fujiF.buzhu_QITA.SaveBut.F.err = PIGFontString(fujiF.buzhu_QITA.SaveBut.F,{"TOP",fujiF.buzhu_QITA.SaveBut.F.shijianName,"BOTTOM",0,-10},"","OUTLINE",16);
	fujiF.buzhu_QITA.SaveBut.F.err:SetTextColor(1,0,0, 1);
	fujiF.buzhu_QITA.SaveBut.F.YES = PIGButton(fujiF.buzhu_QITA.SaveBut.F, {"TOP",fujiF.buzhu_QITA.SaveBut.F,"TOP",-60,-150},{80,24},"保存"); 
	fujiF.buzhu_QITA.SaveBut.F.YES:SetScript("OnClick", function (self)
		local fuji = self:GetParent()
		local huoquV=fuji.shijianName:GetText();
		if huoquV==nil then
			fuji.err:SetText("添加失败：设置名不能为空");
			return
		end
		local huoquV=huoquV:gsub(" ","")
		if huoquV=="" or huoquV==" " then
			fuji.err:SetText("添加失败：设置名不能为空");
			return
		end
		if self:GetText()=="保存" then
			local ziding = PIGA["GDKP"]["jiangli_config"]
			for k,v in pairs(ziding) do
				if huoquV==k then
					fuji.err:SetText("添加失败：已存在同名设置");
					return
				end
			end
		end
		local lindata = {}
		local dataX = PIGA["GDKP"]["jiangli"]
		for p=1,#dataX do
			if dataX[p][2]>0 then
				lindata[dataX[p][1]]={dataX[p][2],dataX[p][4]}
			end
		end
		PIGA["GDKP"]["jiangli_config"][huoquV]=lindata
		fujiF.buzhu_QITA.SaveBut.F:qingkong()
		fuji:Hide()
		RaidR.Update_Buzhu_QITA()
	end);
	fujiF.buzhu_QITA.SaveBut.F.NO = PIGButton(fujiF.buzhu_QITA.SaveBut.F, {"TOP",fujiF.buzhu_QITA.SaveBut.F,"TOP",60,-150},{80,24},"取消"); 
	fujiF.buzhu_QITA.SaveBut.F.NO:SetScript("OnClick", function (self)
		fujiF.buzhu_QITA.SaveBut.F:qingkong()
		fujiF.buzhu_QITA.SaveBut.F:Hide()
	end);
	fujiF.buzhu_QITA.SaveBut.F.del = PIGButton(fujiF.buzhu_QITA.SaveBut.F, {"TOP",fujiF.buzhu_QITA.SaveBut.F,"TOP",0,-240},{80,24},"删除"); 
	fujiF.buzhu_QITA.SaveBut.F.del:Hide()
	fujiF.buzhu_QITA.SaveBut.F.del:SetScript("OnClick", function (self)
		local huoquV=fujiF.buzhu_QITA.SaveBut.F.shijianName:GetText();
		PIGA["GDKP"]["jiangli_config"][huoquV]=nil
		fujiF.buzhu_QITA.SaveBut.F:qingkong()
		RaidR.Update_Buzhu_QITA()
	end);
	function fujiF.buzhu_QITA.SaveBut.F:qingkong()
		fujiF.buzhu_QITA.Add.F:Hide()
		self.del:Hide()
		self.YES:SetText("保存")
		self.shijianName:SetText("")
		self.err:SetText("");
	end
end