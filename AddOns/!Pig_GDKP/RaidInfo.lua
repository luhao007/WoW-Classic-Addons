local addonName, addonTable = ...;
local GDKPInfo=addonTable.GDKPInfo
function GDKPInfo.ADD_RaidInfo(RaidR)
	local Create, Data, Fun, L, Default, Default_Per= unpack(PIG)
	-----
	local PIGFrame=Create.PIGFrame
	local PIGButton = Create.PIGButton
	local PIGLine=Create.PIGLine
	local PIGEnter=Create.PIGEnter
	local PIGSlider = Create.PIGSlider
	local PIGCheckbutton=Create.PIGCheckbutton
	local PIGOptionsList_R=Create.PIGOptionsList_R
	local PIGQuickBut=Create.PIGQuickBut
	local Show_TabBut_R=Create.Show_TabBut_R
	local PIGFontString=Create.PIGFontString
	local PIGSetFont=Create.PIGSetFont
	local GnName,GnUI,GnIcon,FrameLevel = unpack(GDKPInfo.uidata)
	-----
	local fujiF=PIGOptionsList_R(RaidR.F,"人员信息",80)
	function RaidR.IsNameInRiad(seekname)
		local RplayerData = PIGA["GDKP"]["Raidinfo"]
		for p=1,#RplayerData do
			for pp=1,#RplayerData[p] do
				if seekname==RplayerData[p][pp][1] then
					return p,pp
				end
			end
		end
		return nil
	end
	----
	local iconWH,cl_iconH,cl_Name=22,24,Data.cl_Name
	--底部提示
	fujiF.yedibuF = PIGLine(fujiF,"BOT",31)
	fujiF.tishi = CreateFrame("Frame", nil, fujiF);
	fujiF.tishi:SetSize(iconWH,iconWH);
	fujiF.tishi:SetPoint("TOPLEFT",fujiF.yedibuF,"BOTTOMLEFT",10,-4);
	fujiF.tishi.Tex = fujiF.tishi:CreateTexture(nil, "BORDER");
	fujiF.tishi.Tex:SetTexture("interface/common/help-i.blp");
	fujiF.tishi.Tex:SetSize(iconWH+8,iconWH+8);
	fujiF.tishi.Tex:SetPoint("CENTER");
	fujiF.tishi.t = PIGFontString(fujiF.tishi,{"LEFT", fujiF.tishi, "RIGHT", 0,0.6},"玩家名可点击,"..KEY_BUTTON1.."-\124cff00ff00设置补助类型\124r,"..KEY_BUTTON2.."-\124cff00ff00设置分G比例。\124r","OUTLINE");
	--职业图标================================
	--全部
	fujiF.All = CreateFrame("Frame", nil, fujiF);
	fujiF.All:SetSize(cl_iconH*2, cl_iconH);
	fujiF.All:SetPoint("TOPLEFT",fujiF,"TOPLEFT",10,-13);
	fujiF.All.Tex = fujiF.All:CreateTexture(nil, "BORDER");
	fujiF.All.Tex:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
	fujiF.All.Tex:SetPoint("LEFT", fujiF.All, "LEFT", 0,0);
	fujiF.All.Tex:SetSize(cl_iconH-2,cl_iconH-2);
	local englishFaction, _ = UnitFactionGroup("player")
	if englishFaction=="Alliance" then
		fujiF.All.Tex:SetTexCoord(0,0.5,0,1);
	elseif englishFaction=="Horde" then
		fujiF.All.Tex:SetTexCoord(0.5,1,0,1);
	end
	fujiF.All.Num = PIGFontString(fujiF.All,{"LEFT", fujiF.All.Tex, "RIGHT", 1,0},0,"OUTLINE");
	fujiF.All.Num:SetTextColor(1, 1, 1, 1);

	--分职业
	fujiF.classButList={}
	for id=1,#cl_Name do
		local classes = CreateFrame("Frame", nil, fujiF);
		fujiF.classButList[id]=classes
		classes:SetSize(cl_iconH*2-5, cl_iconH);
		if id==1 then
			classes:SetPoint("LEFT",fujiF.All,"RIGHT",2,0);
		else
			classes:SetPoint("LEFT",fujiF.classButList[id-1],"RIGHT",0,0);
		end
		classes.Tex = classes:CreateTexture(nil, "BORDER");
		classes.Tex:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
		classes.Tex:SetPoint("LEFT", classes, "LEFT", 0,0);
		classes.Tex:SetSize(cl_iconH-2,cl_iconH-2);
		classes.Tex:SetTexCoord(unpack(CLASS_ICON_TCOORDS[cl_Name[id][1]]));
		classes.Num = PIGFontString(classes,{"LEFT", classes.Tex, "RIGHT", 0,0},0,"OUTLINE");
		classes.Num:SetTextColor(1, 1, 1, 1);
	end
	---职责补助分类
	local zhizeIcon=Data.zhizeIcon
	local LeftmenuName={"设为<|cff00FF00"..TANK.."|r>补助","设为<|cff00FF00"..HEALS.."|r>补助","设为<|cff00FF00"..DAMAGE.."|r>补助","撤销补助"}
	local LeftmenuV=GDKPInfo.LeftmenuV
	fujiF.RRButList={}
	for id=1,#zhizeIcon do
		local zhize = CreateFrame("Frame", nil, fujiF); 
		fujiF.RRButList[id]=zhize
		zhize:SetSize(cl_iconH*2-4, cl_iconH);
		if id==1 then
			if PIG_MaxTocversion() then
				zhize:SetPoint("LEFT",fujiF.classButList[#cl_Name],"RIGHT",10,0);
			else
				zhize:SetPoint("TOPLEFT",fujiF.yedibuF,"BOTTOMLEFT",460,-2);
			end
		else
			zhize:SetPoint("LEFT",fujiF.RRButList[id-1],"RIGHT",0,0);
		end
		zhize.Tex = zhize:CreateTexture(nil, "BORDER");
		zhize.Tex:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
		zhize.Tex:SetTexCoord(zhizeIcon[id][1],zhizeIcon[id][2],zhizeIcon[id][3],zhizeIcon[id][4]);
		zhize.Tex:SetSize(cl_iconH,cl_iconH);
		zhize.Tex:SetPoint("LEFT", zhize, "LEFT", 0,0);
		zhize.Num = PIGFontString(zhize,{"LEFT", zhize.Tex, "RIGHT", 0,0},0,"OUTLINE");
		zhize.Num:SetTextColor(1, 1, 1, 1);
	end
	--分G比例
	local RightmenuName={"设为<|cff00FF00双倍|r>工资","设为<|cff00FF000.5倍|r>工资","设为<|cff00FF00不分G|r>","恢复<|cff00FF001倍|r>"}
	local RightmenuV=GDKPInfo.RightmenuV
	local fenGbiliIcon=GDKPInfo.fenGbiliIcon
	local fenGbiliIconCaiqie = {{0,1,0,1},{0,1,0,1},{0,1,0,1}}
	fujiF.RRfenGButList={}
	for id=1,(#RightmenuV-1) do
		local fenG = CreateFrame("Frame", nil, fujiF); 
		fujiF.RRfenGButList[id]=fenG
		fenG:SetSize(cl_iconH*2-4, cl_iconH);
		if id==1 then
			fenG:SetPoint("LEFT",fujiF.RRButList[#zhizeIcon],"RIGHT",10,0);
		else
			fenG:SetPoint("LEFT",fujiF.RRfenGButList[id-1],"RIGHT",0,0);
		end
		fenG.Tex = fenG:CreateTexture(nil, "BORDER");
		fenG.Tex:SetTexture(fenGbiliIcon[id]);
		fenG.Tex:SetSize(cl_iconH,cl_iconH);
		fenG.Tex:SetPoint("LEFT", fenG, "LEFT", 0,0);
		fenG.Num = PIGFontString(fenG,{"LEFT", fenG.Tex, "RIGHT", 0,0},0,"OUTLINE");
		fenG.Num:SetTextColor(1, 1, 1, 1);
	end
	--获取队伍信息=================================
	function RaidR:GetRiadPlayerInfo()
		local renyuanData={{},{},{},{},{},{},{},{}};
		for p=1,MAX_RAID_MEMBERS do
			local name, _, subgroup, _, _, fileName = GetRaidRosterInfo(p);
			if name~=nil then
				local renyuaninfo={
					name,--1玩家名
					fileName,--2职业
					1,--3分G比例
					nil,--4补助类型
					false,--5固定值/百分比
					0,--6补助金额
					false,--7需要邮寄
					false,--8已邮寄
					false,--9已交易
				};
				table.insert(renyuanData[subgroup],renyuaninfo);
			end
		end
		--更新已有人员数据
		local xianyoushuju = PIGA["GDKP"]["Raidinfo"]
		for x=1,#renyuanData do
			for xx=1,#renyuanData[x] do
				for p=1,#xianyoushuju do
					for pp=1,#xianyoushuju[p] do
						if renyuanData[x][xx][1]==xianyoushuju[p][pp][1] then
							for k=3,#renyuanData[x][xx] do
								renyuanData[x][xx][k]=xianyoushuju[p][pp][k];
							end
						end
					end
				end
			end
		end
		PIGA["GDKP"]["Raidinfo"]=renyuanData;
	end
	--显示刷新
	function RaidR:RaidInfoShow()
		if fujiF:IsShown() then
			for p=1, 8 do
				for pp=1, 5 do
					fujiF.RRRaidButList[p].ButList[pp]:Hide();
				end
			end
			----
			local classes_Shu={0,0,0,0,0,0,0,0,0,0,0,0,0,0};
			local classes_zongShu=0;
			local buzhurenshu={0,0,0,0,0};
			local fenGbilishu={0,0,0,0,0};
			local infoData = PIGA["GDKP"]["Raidinfo"]
			for p=1, #infoData do
				for pp=1, #infoData[p] do
					if infoData[p][pp] then
						classes_zongShu=classes_zongShu+1;
						local fujibut = fujiF.RRRaidButList[p].ButList[pp]
						fujibut:Show();
						local zhiye = infoData[p][pp][2]
						for mm=1,#cl_Name do
							if zhiye==cl_Name[mm] then
								classes_Shu[mm]=classes_Shu[mm]+1;
							end
						end
						-- 
						local AllName = infoData[p][pp][1]
						fujibut.AllName=AllName
						local name,server = strsplit("-", AllName);
						if server then
							fujibut.Text:SetText(name.."(*)")
						else
							fujibut.Text:SetText(name)
						end
						local color = PIG_CLASS_COLORS[zhiye]
						fujibut.color=color
						fujibut.Text:SetTextColor(color.r, color.g, color.b,1);
						local buzhuLEI = infoData[p][pp][4]
						if buzhuLEI then
							fujibut.zhizeIcon:Show()
							for g=1,#LeftmenuV do
								if buzhuLEI==LeftmenuV[g] then
									buzhurenshu[g]=buzhurenshu[g]+1;
									fujibut.zhizeIcon:SetTexCoord(zhizeIcon[g][1],zhizeIcon[g][2],zhizeIcon[g][3],zhizeIcon[g][4]);
								end
							end
						else
							fujibut.zhizeIcon:Hide()
						end
						local fenGLEI = infoData[p][pp][3]
						if fenGLEI==1 then
							fujibut.fenGbili:Hide()
						else
							fujibut.fenGbili:Show()
							for g=1,#RightmenuV do
								if fenGLEI==RightmenuV[g] then
									fenGbilishu[g]=fenGbilishu[g]+1;
									fujibut.fenGbili:SetTexture(fenGbiliIcon[g]);
								end
							end
						end
					end
				end
			end
			for j=1,#cl_Name do
				fujiF.classButList[j].Num:SetText(classes_Shu[j]);
			end
			for j=1,#zhizeIcon do
				fujiF.RRButList[j].Num:SetText(buzhurenshu[j]);
			end
			for j=1,(#RightmenuV-1) do
				fujiF.RRfenGButList[j].Num:SetText(fenGbilishu[j])
			end
			fujiF.All.Num:SetText(classes_zongShu);
		end
	end

	--创建队伍角色框架=============================
	local duiwu_Width,duiwu_Height=180,28;
	local jiangeW,jiangeH=20,0;
	fujiF.RRRaidButList={}
	for p=1,8 do
		local DuiwuF = CreateFrame("Frame", nil, fujiF);
		fujiF.RRRaidButList[p]=DuiwuF
		DuiwuF:SetSize(duiwu_Width,duiwu_Height*5+24);
		if p==1 then
			DuiwuF:SetPoint("TOPLEFT",fujiF,"TOPLEFT",14,-60);
		end
		if p>1 and p<5 then
			DuiwuF:SetPoint("LEFT",fujiF.RRRaidButList[p-1],"RIGHT",jiangeW,jiangeH);
		end
		if p==5 then
			DuiwuF:SetPoint("TOP",fujiF.RRRaidButList[1],"BOTTOM",0,-20);
		end
		if p>5 then
			DuiwuF:SetPoint("LEFT",fujiF.RRRaidButList[p-1],"RIGHT",jiangeW,jiangeH);
		end
		DuiwuF.ButList={}
		for pp=1,5 do
			local DuiwuF_P = PIGButton(DuiwuF,nil,{duiwu_Width,duiwu_Height});
			DuiwuF.ButList[pp]=DuiwuF_P
			if pp==1 then
				DuiwuF_P:SetPoint("TOP",DuiwuF,"TOP",0,0);
			else
				DuiwuF_P:SetPoint("TOP",DuiwuF.ButList[pp-1],"BOTTOM",0,-6);
			end
			PIGSetFont(DuiwuF_P.Text,14,"OUTLINE")
			DuiwuF_P.BG = DuiwuF_P:CreateTexture(nil, "BORDER");
			DuiwuF_P.BG:SetTexture("Interface/DialogFrame/UI-DialogBox-Background");
			DuiwuF_P.BG:SetColorTexture(1, 1, 1, 0.1)
			DuiwuF_P.BG:SetSize(duiwu_Width,duiwu_Height);
			DuiwuF_P.BG:SetPoint("CENTER");
			DuiwuF_P.zhizeIcon = DuiwuF_P:CreateTexture(nil, "ARTWORK");
			DuiwuF_P.zhizeIcon:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
			DuiwuF_P.zhizeIcon:SetSize(duiwu_Height-6,duiwu_Height-6);
			DuiwuF_P.zhizeIcon:SetPoint("LEFT", DuiwuF_P, "LEFT", 2,0);
			DuiwuF_P.fenGbili = DuiwuF_P:CreateTexture(nil, "ARTWORK");
			DuiwuF_P.fenGbili:SetSize(duiwu_Height-7,duiwu_Height-7);
			DuiwuF_P.fenGbili:SetPoint("RIGHT", DuiwuF_P, "RIGHT", -2,-0.6);
			DuiwuF_P:HookScript("OnMouseDown", function (self)
				self.zhizeIcon:SetPoint("LEFT",self,"LEFT",3,-1);
				self.fenGbili:SetPoint("RIGHT", self, "RIGHT", -0.5,-2.1);
			end);
			DuiwuF_P:HookScript("OnMouseUp", function (self)
				self.zhizeIcon:SetPoint("LEFT",self,"LEFT",2,0);
				self.fenGbili:SetPoint("RIGHT", self, "RIGHT", -2,-0.6);
			end);
			DuiwuF_P:HookScript("OnClick", function (self,button)
				if fujiF.playerClick:IsShown() then
					fujiF.playerClick:Hide();
				else
					fujiF.playerClick.xiaoshidaojishi = 1.5;
					fujiF.playerClick.zhengzaixianshi = true;
					fujiF.playerClick.ShowFun(self,button)
				end
			end);
		end
	end

	-- 设置/坦克/治疗/输出补助
	local ClickCaidanW,ClickCaidanH,MenuNum = 140,24,4
	fujiF.playerClick = PIGFrame(fujiF,nil,{ClickCaidanW,(ClickCaidanH+4)*MenuNum+50});
	fujiF.playerClick:SetFrameLevel(FrameLevel+40)
	fujiF.playerClick:PIGSetBackdrop(1)
	fujiF.playerClick:EnableMouse(true)
	fujiF.playerClick:Hide();
	fujiF.playerClick.Name = PIGFontString(fujiF.playerClick,{"TOP",fujiF.playerClick,"TOP", 0, -4});
	fujiF.playerClick.xiaoshidaojishi = 0;
	fujiF.playerClick.zhengzaixianshi = nil;
	fujiF.playerClick:HookScript("OnUpdate", function(self, ssss)
		if fujiF.playerClick.zhengzaixianshi==nil then
			return;
		else
			if fujiF.playerClick.zhengzaixianshi==true then
				if fujiF.playerClick.xiaoshidaojishi<= 0 then
					fujiF.playerClick:Hide();
					fujiF.playerClick.zhengzaixianshi = nil;
				else
					fujiF.playerClick.xiaoshidaojishi = fujiF.playerClick.xiaoshidaojishi - ssss;	
				end
			end
		end
	end)
	fujiF.playerClick:HookScript("OnEnter", function()
		fujiF.playerClick.zhengzaixianshi = nil;
	end)
	fujiF.playerClick:HookScript("OnLeave", function()
		fujiF.playerClick.xiaoshidaojishi = 1.5;
		fujiF.playerClick.zhengzaixianshi = true;
	end)
	fujiF.playerClick.XX = PIGButton(fujiF.playerClick,{"BOTTOM",fujiF.playerClick,"BOTTOM", 0, 4},{ClickCaidanW,ClickCaidanH},"取消");
	fujiF.playerClick.XX.Text:SetTextColor(1, 1, 1, 1);
	fujiF.playerClick.XX:HookScript("OnClick", function ()
		fujiF.playerClick:Hide();
	end);
	fujiF.playerClick.XX:HookScript("OnEnter", function()
		fujiF.playerClick.zhengzaixianshi = nil;
	end)
	fujiF.playerClick.XX:HookScript("OnLeave", function()
		fujiF.playerClick.xiaoshidaojishi = 1.5;
		fujiF.playerClick.zhengzaixianshi = true;
	end)
	-----
	for i=1,MenuNum do
		local ClickMenu = PIGButton(fujiF.playerClick,nil,{ClickCaidanW,ClickCaidanH},nil,"playerClickMenu_"..i,i);
		ClickMenu.Text:SetTextColor(1, 1, 1, 1);
		if i==1 then
			ClickMenu:SetPoint("TOP",fujiF.playerClick,"TOP", 0, -24);
		else
			ClickMenu:SetPoint("TOP",_G["playerClickMenu_"..(i-1)],"BOTTOM", 0, -4);
		end
		ClickMenu:HookScript("OnEnter", function (self)
			fujiF.playerClick.zhengzaixianshi = nil;
		end);
		ClickMenu:HookScript("OnLeave", function (self)
			fujiF.playerClick.xiaoshidaojishi = 1.5;
			fujiF.playerClick.zhengzaixianshi = true;
		end);
		ClickMenu:HookScript("OnClick", function (self,button)
			fujiF.playerClick.ClickMenuFun(self,button)
		end);
		if i<MenuNum then
			ClickMenu.icon = ClickMenu:CreateTexture(nil, "ARTWORK");
			ClickMenu.icon:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
			ClickMenu.icon:SetTexCoord(zhizeIcon[i][1],zhizeIcon[i][2],zhizeIcon[i][3],zhizeIcon[i][4]);
			ClickMenu.icon:SetSize(ClickCaidanH-2,ClickCaidanH-2);
			ClickMenu.icon:SetPoint("LEFT", ClickMenu, "LEFT", 4,0);
			ClickMenu.Text:SetPoint("LEFT",ClickMenu.icon,"RIGHT", 0, 0);
			ClickMenu:HookScript("OnMouseDown", function(self)
				if self:IsEnabled() then
					self.Text:SetPoint("LEFT",ClickMenu.icon,"RIGHT", 1.5, -1.5);
				end
			end);
			ClickMenu:HookScript("OnMouseUp", function(self)
				if self:IsEnabled() then
					self.Text:SetPoint("LEFT",ClickMenu.icon,"RIGHT", 0, 0);
				end
			end);
		end
	end
	--菜单函数
	function fujiF.playerClick.ClickMenuFun(pbut)
		local p,pp=RaidR.IsNameInRiad(fujiF.playerClick.AllName)
		if p then 
			local MenuID = pbut:GetID()
			if fujiF.playerClick.button=="LeftButton" then
				PIGA["GDKP"]["Raidinfo"][p][pp][4]=LeftmenuV[MenuID]
			else
				PIGA["GDKP"]["Raidinfo"][p][pp][3]=RightmenuV[MenuID]
			end
		end
		fujiF.playerClick:Hide()
		RaidR:RaidInfoShow()
	end
	--显示菜单
	function fujiF.playerClick.ShowFun(pbut,button)
		fujiF.playerClick:ClearAllPoints();
		fujiF.playerClick:SetPoint("TOP",pbut,"BOTTOM",0,4);
		fujiF.playerClick:Show();
		fujiF.playerClick.AllName=pbut.AllName
		fujiF.playerClick.Name:SetText(pbut.Text:GetText());
		local color = pbut.color
		fujiF.playerClick.Name:SetTextColor(color.r, color.g, color.b,1);
		fujiF.playerClick.button=button
		if button=="LeftButton" then
			for g=1,MenuNum do
				local fujibut = _G["playerClickMenu_"..g]
				fujibut:SetText(LeftmenuName[g])
				if g<MenuNum then
					fujibut.icon:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
					fujibut.icon:SetTexCoord(zhizeIcon[g][1],zhizeIcon[g][2],zhizeIcon[g][3],zhizeIcon[g][4]);
				end
			end
		else
			for g=1,MenuNum do
				local fujibut = _G["playerClickMenu_"..g]
				fujibut:SetText(RightmenuName[g])
				if g<MenuNum then
					fujibut.icon:SetTexture(fenGbiliIcon[g]);
					fujibut.icon:SetTexCoord(fenGbiliIconCaiqie[g][1],fenGbiliIconCaiqie[g][2],fenGbiliIconCaiqie[g][3],fenGbiliIconCaiqie[g][4]);
				end
			end
		end
	end
	fujiF:HookScript("OnHide", function (self)
		self.playerClick:Hide();
	end)
	--显示刷新
	fujiF:SetScript("OnShow", function (self)
		RaidR:RaidInfoShow()
	end)
	--=========================
	fujiF:RegisterEvent("GROUP_ROSTER_UPDATE")
	fujiF:RegisterEvent("PLAYER_ENTERING_WORLD")
	fujiF:HookScript("OnEvent",function(self, event,arg1,_,_,_,arg5)
		RaidR:Update_DongjieBUT()
		if not PIGA["GDKP"]["Dongjie"] then
			C_Timer.After(0.8,function()
				RaidR:GetRiadPlayerInfo()
				RaidR:RaidInfoShow()
				RaidR.PlayerList:PlayerList_UP()
			end)
		end
	end)
end