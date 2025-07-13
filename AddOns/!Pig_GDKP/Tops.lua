local addonName, addonTable = ...;
local GDKPInfo=addonTable.GDKPInfo
function GDKPInfo.ADD_Tops(RaidR)
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
	local PIGOptionsList_R=Create.PIGOptionsList_R
	local PIGQuickBut=Create.PIGQuickBut
	local Show_TabBut_R=Create.Show_TabBut_R
	local PIGFontString=Create.PIGFontString
	local PIGSetFont=Create.PIGSetFont
	local GnName,GnUI,GnIcon,FrameLevel = unpack(GDKPInfo.uidata)
	local iconWH,hang_Height,hang_NUM,lineTOP  =  GDKPInfo.iconWH,GDKPInfo.hang_Height,GDKPInfo.hang_NUM,GDKPInfo.lineTOP
	
	local tabname = "消费榜"
	local fujiF=PIGOptionsList_R(RaidR.F,tabname,80)
	----
	fujiF.boxF = PIGFrame(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",0,0});  
	fujiF.boxF:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",0,0);
	fujiF.boxF.yedibuF = PIGLine(fujiF.boxF,"BOT",lineTOP)
	fujiF.boxF.guangbaoBut = CreateFrame("Button",nil,fujiF.boxF);  
	fujiF.boxF.guangbaoBut:SetSize(iconWH,iconWH);
	fujiF.boxF.guangbaoBut:SetPoint("TOPLEFT", fujiF.boxF, "TOPLEFT", 6,-4);
	fujiF.boxF.guangbaoBut:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
	fujiF.boxF.guangbaoBut.Tex = fujiF.boxF.guangbaoBut:CreateTexture(nil, "BORDER");
	fujiF.boxF.guangbaoBut.Tex:SetTexture(130979);
	fujiF.boxF.guangbaoBut.Tex:SetPoint("CENTER",4,0);
	fujiF.boxF.guangbaoBut.Tex:SetSize(iconWH,iconWH);
	PIGEnter(fujiF.boxF.guangbaoBut,"播报"..tabname.."明细")
	fujiF.boxF.guangbaoBut:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",2.5,-1.5);
	end);
	fujiF.boxF.guangbaoBut:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER",4,0);
	end);
	fujiF.boxF.guangbaoBut:SetScript("OnClick", function(self)
		PIGSendChatRaidParty("=====消费榜=====")
		self.SendCD=0.1
		local sortedKeys,topsList=RaidR.GetTopData()
		for id = 1, hang_NUM do
			if sortedKeys[id] then
				if topsList[sortedKeys[id]]>0 then
					self.SendCD=self.SendCD+0.02
					C_Timer.After(self.SendCD,function()
						PIGSendChatRaidParty(id.." <"..sortedKeys[id].."> 消费"..topsList[sortedKeys[id]].."G")
					end)
				end
			end
		end
	end)
	--标题
	local fakuanbiaoti = {{"老板名",30},{"消费额/G",260},{"推荐提成",490},{"推荐人",620}}
	for id = 1, #fakuanbiaoti, 1 do
		local biaoti = PIGFontString(fujiF.boxF,{"TOPLEFT", fujiF.boxF, "TOPLEFT", fakuanbiaoti[id][2],-7},fakuanbiaoti[id][1]);
		biaoti:SetTextColor(1, 1, 0, 1);
	end
	fujiF.boxF.tishi = CreateFrame("Frame", nil, fujiF.boxF);
	fujiF.boxF.tishi:SetSize(iconWH-2,iconWH-2);
	fujiF.boxF.tishi:SetPoint("TOPLEFT", fujiF.boxF, "TOPLEFT", fakuanbiaoti[4][2]+44,-5);
	fujiF.boxF.tishi.Tex = fujiF.boxF.tishi:CreateTexture(nil, "BORDER");
	fujiF.boxF.tishi.Tex:SetTexture("interface/friendsframe/reportspamicon.blp");
	fujiF.boxF.tishi.Tex:SetSize(iconWH+6,iconWH+6);
	fujiF.boxF.tishi.Tex:SetPoint("TOPLEFT",1,-3);
	PIGEnter(fujiF.boxF.tishi,"\124cffff0000注意: 未选择推荐人的项目不会计入支出项目内\124r")
	------
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
	fujiF.boxF.TOPline = PIGLine(fujiF.boxF,"TOP",-lineTOP)
	fujiF.boxF.Scroll = CreateFrame("ScrollFrame",nil,fujiF.boxF, "FauxScrollFrameTemplate");  
	fujiF.boxF.Scroll:SetPoint("TOPLEFT",fujiF.boxF.TOPline,"BOTTOMLEFT",0,-1);
	fujiF.boxF.Scroll:SetPoint("BOTTOMRIGHT",fujiF.boxF,"BOTTOMRIGHT",-24,lineTOP);
	fujiF.boxF.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, RaidR.Update_Tops)
	end)
	fujiF.boxF.butList={}
	for id = 1, hang_NUM do
		local hang = CreateFrame("Frame", nil, fujiF.boxF);
		fujiF.boxF.butList[id]=hang
		hang:SetSize(fujiF.boxF:GetWidth()-25, hang_Height);
		if id==1 then
			hang:SetPoint("TOP",fujiF.boxF.Scroll,"TOP",0,0);
		else
			hang:SetPoint("TOP",fujiF.boxF.butList[id-1],"BOTTOM",0,0);
		end
		if id~=hang_NUM then PIGLine(hang,"BOT",nil,nil,nil,{0.3,0.3,0.3,0.3}) end
		hang.bossname = PIGFontString(hang,{"LEFT", hang, "LEFT", 10,0});
		--
		hang.G = PIGFontString(hang,{"LEFT", hang, "LEFT", fakuanbiaoti[2][2]-4,0});
		hang.G:SetTextColor(0, 1, 1, 1);
		hang.G:SetSize(60, hang_Height);
		hang.G:SetJustifyH("RIGHT")

		hang.ticheng = CreateFrame("Frame", nil, hang);
		hang.ticheng:SetSize(58, hang_Height);
		hang.ticheng:SetPoint("LEFT", hang, "LEFT", fakuanbiaoti[3][2],0);
		hang.ticheng.baifen = PIGFontString(hang.ticheng,{"RIGHT", hang.ticheng, "RIGHT", 0,0});
		hang.ticheng.baifen:SetTextColor(1, 1, 1, 1);
		hang.ticheng.V = PIGFontString(hang.ticheng,{"RIGHT", hang.ticheng.baifen, "LEFT", 0,0});
		hang.ticheng.V:SetTextColor(1, 0, 0, 1);
		hang.ticheng.E = CreateFrame("EditBox", nil, hang.ticheng, "InputBoxInstructionsTemplate");
		hang.ticheng.E:SetSize(54,hang_Height);
		hang.ticheng.E:SetPoint("RIGHT", hang.ticheng, "RIGHT", 0,0);
		PIGSetFont(hang.ticheng.E,14,"OUTLINE")
		hang.ticheng.E:SetMaxLetters(6)
		hang.ticheng.E:SetNumeric(true)
		hang.ticheng.E:SetScript("OnEscapePressed", function(self) 
			shiqujiaodian(self:GetParent())
		end);
		hang.ticheng.E:SetScript("OnEnterPressed", function(self)
	 		PIGA["GDKP"]["Tops"][self:GetParent():GetParent().bossallname][2]=self:GetNumber()
			RaidR.Update_Tops()
		end);
		hang.ticheng.B = CreateFrame("Button",nil,hang.ticheng, "TruncatedButtonTemplate");
		hang.ticheng.B:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		hang.ticheng.B:SetSize(hang_Height-7,hang_Height-7);
		hang.ticheng.B:SetPoint("LEFT", hang.ticheng, "RIGHT", 0,0);
		hang.ticheng.B.Texture = hang.ticheng.B:CreateTexture(nil, "BORDER");
		hang.ticheng.B.Texture:SetTexture("interface/buttons/ui-guildbutton-publicnote-up.blp");
		hang.ticheng.B.Texture:SetPoint("CENTER");
		hang.ticheng.B.Texture:SetSize(hang_Height-12,hang_Height-10);
		hang.ticheng.B:SetScript("OnMouseDown", function (self)
			self.Texture:SetPoint("CENTER",-1.5,-1.5);
		end);
		hang.ticheng.B:SetScript("OnMouseUp", function (self)
			self.Texture:SetPoint("CENTER");
		end);
		hang.ticheng.B:SetScript("OnClick", function (self)
			for qq=1,hang_NUM do
				shiqujiaodian(fujiF.boxF.butList[qq].ticheng)
			end
			local shangjiF=self:GetParent()
			shiqujiaodian(shangjiF,true)
			if PIGA["GDKP"]["Tops"][shangjiF:GetParent().bossallname] then
				shangjiF.E:SetText(PIGA["GDKP"]["Tops"][shangjiF:GetParent().bossallname][2]);
			else
				shangjiF.E:SetText(0)
			end
		end);
		hang.ticheng.Q = PIGButton(hang.ticheng, {"LEFT", hang.ticheng, "RIGHT", 1,0},{36,20},"确定");
		hang.ticheng.Q:SetScale(0.88)
		hang.ticheng.Q:Hide();
		hang.ticheng.Q:SetScript("OnClick", function (self)
			local shangjiF=self:GetParent()
	 		PIGA["GDKP"]["Tops"][shangjiF:GetParent().bossallname][2]=shangjiF.E:GetNumber()
			RaidR.Update_Tops()
		end);
		hang.JiangliRen = CreateFrame("Button", nil, hang, "TruncatedButtonTemplate");
		hang.JiangliRen:SetHighlightTexture("interface/paperdollinfoframe/ui-character-tab-highlight.blp");
		hang.JiangliRen:SetSize(170,hang_Height);
		hang.JiangliRen:SetPoint("LEFT", hang, "LEFT", fakuanbiaoti[4][2]-4,0);
		PIGSetFont(hang.JiangliRen.Text,14,"OUTLINE")
		hang.JiangliRen.Text:SetJustifyH("LEFT")
		hang.JiangliRen.Text:SetTextColor(0,1,0, 1);
		hang.JiangliRen:SetScript("OnClick", function (self)
			if RaidR.PlayerList:IsShown() then
				RaidR.PlayerList:Hide() 
			else
				RaidR.PlayerList:Showtishi("TichengRen",self:GetParent().bossallname)
			end
		end);
	end
	fujiF.boxF:SetScript("OnShow", function (self)
		RaidR.Update_Tops()
	end)
	local function GetBossfileName(name)
		local p,pp=RaidR.IsNameInRiad(name)
		if p then 
			return PIGA["GDKP"]["Raidinfo"][p][pp][2]
		end
		return NONE
	end
	function RaidR.GetTopData(dataly)
		local topsList = {}
	    local RRItemList =  dataly or PIGA["GDKP"]["ItemList"]
		for x=1,#RRItemList do
			if RRItemList[x][8]~=NONE then--有出价
				topsList[RRItemList[x][8]]=topsList[RRItemList[x][8]] or 0
				topsList[RRItemList[x][8]]=topsList[RRItemList[x][8]]+RRItemList[x][9]+RRItemList[x][14]
			end
		end
		local sortedKeys = {}
		for key, _ in pairs(topsList) do
		    table.insert(sortedKeys, key)
		end
		table.sort(sortedKeys, function(a, b)
		    return topsList[a] > topsList[b]
		end)
		return sortedKeys,topsList
	end
	function RaidR.Update_Tops()
		if not fujiF.boxF:IsShown() then return end
		local self = fujiF.boxF.Scroll
		for id = 1, hang_NUM do
			fujiF.boxF.butList[id]:Hide()
	    end
	    local sortedKeys,topsList=RaidR.GetTopData()
		local ItemsNum=#sortedKeys
		FauxScrollFrame_Update(self, ItemsNum, hang_NUM, hang_Height);
		local offset = FauxScrollFrame_GetOffset(self);
		for id = 1, hang_NUM do
			local dangqian = id+offset;
			if sortedKeys[dangqian] then
				local hang = fujiF.boxF.butList[id]
				hang:Show();
				hang.bossname:SetText(sortedKeys[dangqian]);
				hang.bossallname=sortedKeys[dangqian]
				local color = PIG_CLASS_COLORS[GetBossfileName(sortedKeys[dangqian])]
				hang.bossname:SetTextColor(color.r, color.g, color.b,1);
				hang.G:SetText(topsList[sortedKeys[dangqian]]);
				shiqujiaodian(hang.ticheng)
				if PIGA["GDKP"]["Tops"][sortedKeys[dangqian]] then
					hang.ticheng.B:Show()
					local tichengVV = floor(topsList[sortedKeys[dangqian]]*PIGA["GDKP"]["Tops"][sortedKeys[dangqian]][2]*0.01)
					hang.ticheng.V:SetText("|cff00FF00"..tichengVV.."|r("..PIGA["GDKP"]["Tops"][sortedKeys[dangqian]][2].."%)");
					hang.JiangliRen:SetText(PIGA["GDKP"]["Tops"][sortedKeys[dangqian]][1]);
				else
					hang.ticheng.V:SetText("");
					hang.ticheng.B:Hide()
					hang.JiangliRen:SetText("\124cffff0000        "..NONE.."\124r");
				end
			end
		end
		RaidR:UpdateGinfo()
	end
end