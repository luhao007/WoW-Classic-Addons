local addonName, addonTable = ...;
local GDKPInfo=addonTable.GDKPInfo
function GDKPInfo.ADD_History(RaidR)
	local Create, Data, Fun, L, Default, Default_Per= unpack(PIG)
	-----
	local PIGFrame=Create.PIGFrame
	local PIGButton = Create.PIGButton
	local PIGLine=Create.PIGLine
	local PIGEnter=Create.PIGEnter
	local PIGSlider = Create.PIGSlider
	local PIGCheckbutton=Create.PIGCheckbutton
	local PIGOptionsList_R=Create.PIGOptionsList_R
	local PIGOptionsList_RF=Create.PIGOptionsList_RF
	local PIGQuickBut=Create.PIGQuickBut
	local Show_TabBut_R=Create.Show_TabBut_R
	local PIGFontString=Create.PIGFontString
	local PIGSetFont=Create.PIGSetFont
	local GnName,GnUI,GnIcon,FrameLevel = unpack(GDKPInfo.uidata)
	local LeftmenuV=GDKPInfo.LeftmenuV
	local buzhuzhize=GDKPInfo.buzhuzhize
	local History=PIGFrame(RaidR,{"TOPLEFT",RaidR,"TOPLEFT",6,-26})
	History:SetPoint("BOTTOMRIGHT",RaidR,"BOTTOMRIGHT",-6,52);
	History:PIGSetBackdrop(1)
	History:PIGClose()
	History:SetFrameLevel(FrameLevel+33)
	History:Hide()
	function RaidR.ShowHideHistory(self)
		if not History.yizhuce then History.zhuceshijian(self) end
		if History:IsShown() then
			History:Hide()
		else
			History:Show()
		end
	end
	function History.zhuceshijian(self)
		History:HookScript("OnShow", function ()
			self:Selected()
		end);
		History:HookScript("OnHide", function ()
			self:NotSelected()
		end);
		History.yizhuce=true
	end
	-------------
	History.xuanzhongID=0;
	local hang_Height,hang_NUM  = 30.8, 15;
	History.list=PIGFrame(History,{"TOPLEFT",History,"TOPLEFT",6,-20})
	History.list:SetPoint("BOTTOMRIGHT",History,"BOTTOMLEFT",200,6);
	History.list:PIGSetBackdrop(1)
	History.list.biaoti = PIGFontString(History.list,{"BOTTOM",History.list,"TOP",-20,2},"\124cffFFFF00历史活动目录\124r","OUTLINE");
	--删除历史记录
	StaticPopupDialogs["DEL_HISTORY"] = {
		text = "确定\124cffff0000清空\124r\n开团助手所有历史记录吗?",
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			PIGA["GDKP"]["History"]={};
			History.xuanzhongID=0;
			RaidR.Update_History()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	History.qingkong = PIGButton(History,{"LEFT",History.list.biaoti,"RIGHT",4,0},{40,20},"清空"); 
	History.qingkong:SetScale(0.88)
	History.qingkong:SetScript("OnClick", function ()
		StaticPopup_Show ("DEL_HISTORY");
	end);
	--目录
	History.list.Scroll = CreateFrame("ScrollFrame",nil,History.list, "FauxScrollFrameTemplate");  
	History.list.Scroll:SetPoint("TOPLEFT",History.list,"TOPLEFT",0,-2);
	History.list.Scroll:SetPoint("BOTTOMRIGHT",History.list,"BOTTOMRIGHT",-19,2);
	History.list.Scroll.ScrollBar:SetScale(0.8);
	History.list.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, RaidR.Update_History)
	end)
	History.list.ButList={}
	local list_WW = History.list:GetWidth()
	for id = 1, hang_NUM do
		local mululist = CreateFrame("Button",nil,History.list, "TruncatedButtonTemplate");
		History.list.ButList[id]=mululist
		mululist:SetSize(list_WW-22, hang_Height);
		if id==1 then
			mululist:SetPoint("TOP",History.list.Scroll,"TOP",2,0);
		else
			mululist:SetPoint("TOP",History.list.ButList[id-1],"BOTTOM",0,0);
		end
		if id~=hang_NUM then PIGLine(mululist,"BOT",nil,nil,nil,{0.3,0.3,0.3,0.3}) end
		mululist.highlight = mululist:CreateTexture();
		mululist.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
		mululist.highlight:SetBlendMode("ADD")
		mululist.highlight:SetPoint("LEFT", mululist, "LEFT", 2,0);
		mululist.highlight:SetSize(list_WW-6,hang_Height);
		mululist.highlight:SetAlpha(0.4);
		mululist.highlight:Hide();
		mululist.xuanzhong = mululist:CreateTexture();
		mululist.xuanzhong:SetTexture("interface/buttons/ui-listbox-highlight.blp");
		mululist.xuanzhong:SetPoint("LEFT", mululist, "LEFT", 2,0);
		mululist.xuanzhong:SetSize(list_WW-6,hang_Height);
		mululist.xuanzhong:SetAlpha(0.9);
		mululist.xuanzhong:Hide();
		mululist:SetScript("OnEnter", function (self)
			if not self.xuanzhong:IsShown() then
				self.highlight:Show();
			end
		end);
		mululist:SetScript("OnLeave", function (self)
			self.highlight:Hide();
		end);
		-- -----
		mululist.NO = PIGFontString(mululist,{"LEFT",mululist,"LEFT",4,0},"","OUTLINE",16);
		mululist.NO:SetTextColor(1, 1, 1, 0.5);
		mululist.name = PIGFontString(mululist,{"LEFT",mululist,"LEFT",26,7},"","OUTLINE",13);
		mululist.name:SetTextColor(1, 0.843, 0, 1);
		mululist.name:SetSize(list_WW-25,hang_Height*0.5);
		mululist.name:SetJustifyH("LEFT")
		mululist.time = PIGFontString(mululist,{"LEFT",mululist,"LEFT",26,-7},"","OUTLINE",13);
		mululist.time:SetTextColor(0, 1, 0.6, 1);

		mululist:SetScript("OnMouseDown", function (self)
			self.NO:SetPoint("LEFT",self,"LEFT",5.5,-1.5);
		end);
		mululist:SetScript("OnMouseUp", function (self)
			self.NO:SetPoint("LEFT",self,"LEFT",4,0);
		end);
		mululist:SetScript("OnClick", function (self)
			History.xuanzhongID=self:GetID();
			RaidR.Update_History()
		end);
	end
	History.list:SetScript("OnShow", function (self)
		RaidR.Update_History()
	end);
	----
	function RaidR.Update_History()
		if not History:IsShown() then return end
		self=History.list.Scroll
		History.qingkong:Disable();
		History.nr:Hide()
		for id = 1, hang_NUM do
			History.list.ButList[id]:Hide();
		end
		local shujuyuan = PIGA["GDKP"]["History"]
		local ItemsNum = #shujuyuan;
		if ItemsNum>0 then
			History.qingkong:Enable();
			FauxScrollFrame_Update(self, ItemsNum, hang_NUM, hang_Height);
			local offset = FauxScrollFrame_GetOffset(self);
			for id = 1, hang_NUM do
				local dangqian = (ItemsNum+1)-id-offset;
				if shujuyuan[dangqian] then
					local fameX = History.list.ButList[id]
					fameX:Show();
					fameX:SetID(dangqian)
					fameX.NO:SetText(dangqian);
					local biaotixinxi=shujuyuan[dangqian].Biaoti
					fameX.name:SetText(biaotixinxi[2]..biaotixinxi[3]);
					fameX.time:SetText(date("%Y-%m-%d %H:%M",biaotixinxi[1]));
					if History.xuanzhongID==dangqian then
						fameX.xuanzhong:Show()
						fameX.name:SetTextColor(1, 1, 1, 1);
						fameX.time:SetTextColor(0.117647, 0.5647, 1, 1);
					else
						fameX.xuanzhong:Hide()
						fameX.name:SetTextColor(1, 0.843, 0, 1);
						fameX.time:SetTextColor(0, 1, 0.6, 1);
					end
				end
			end
			History.nrgengxin_heji()
		end
	end
	-----活动详情-----------
	local nr_hang_Height,nr_hang_Num = 22.9,17
	History.nr=PIGFrame(History,{"TOPLEFT",History.list,"TOPRIGHT",6,0})
	History.nr:SetPoint("BOTTOMRIGHT",History,"BOTTOMRIGHT",-6,6);
	History.nr:PIGSetBackdrop(1)
	History.nr.biaoti = PIGFontString(History.nr,{"BOTTOM",History.nr,"TOP",0,2},"\124cffFFFF00活动内容\124r","OUTLINE");
	History.F=PIGOptionsList_RF(History.nr,26,nil,{6,6,46})
	------
	local function add_TABScroll(fujif,tabname)
		fujif.Scroll = CreateFrame("ScrollFrame",nil,fujif, "FauxScrollFrameTemplate");  
		fujif.Scroll:SetPoint("TOPLEFT",fujif,"TOPLEFT",0,-2);
		fujif.Scroll:SetPoint("BOTTOMRIGHT",fujif,"BOTTOMRIGHT",-19,2);
		fujif.Scroll.ScrollBar:SetScale(0.8);
		fujif.Scroll:SetScript("OnVerticalScroll", function(self, offset)
		    FauxScrollFrame_OnVerticalScroll(self, offset, nr_hang_Height, fujif.gengxinList)
		end)
		fujif.ButList={}
		for id = 1, nr_hang_Num do
			local nrhang= CreateFrame("Frame", nil, fujif.Scroll:GetParent());
			fujif.ButList[id]=nrhang
			nrhang:SetSize(fujif:GetWidth()-22, nr_hang_Height);
			if id==1 then
				nrhang:SetPoint("TOP",fujif.Scroll,"TOP",3,0);
			else
				nrhang:SetPoint("TOP",fujif.ButList[id-1],"BOTTOM",0,0);
			end
			if id~=nr_hang_Num then PIGLine(nrhang,"BOT",nil,nil,nil,{0.3,0.3,0.3,0.3}) end
			--
			nrhang.tx1= CreateFrame("Frame", nil, nrhang);
			nrhang.tx1:SetSize(240, nr_hang_Height);
			nrhang.tx1:SetPoint("LEFT",nrhang,"LEFT",10,0);
			nrhang.tx1.t = PIGFontString(nrhang.tx1,{"LEFT",nrhang.tx1,"LEFT",0,0},"","OUTLINE");
			if tabname=="Jiangli" or tabname=="Fakuan" then
				nrhang.tx1.t:SetTextColor(0, 1, 1, 1);
			else
				nrhang.tx1:SetScript("OnMouseDown", function (self,button)
					if button=="LeftButton" then
						GameTooltip:ClearLines();
						GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
						GameTooltip:SetHyperlink(self.t:GetText());
					end
				end);
				nrhang.tx1:SetScript("OnMouseUp", function (self,button)
					GameTooltip:ClearLines();GameTooltip:Hide()
				end);
			end
			nrhang.tx2 = PIGFontString(nrhang,{"RIGHT",nrhang,"RIGHT",-220,0},"","OUTLINE");
			nrhang.tx2:SetTextColor(1, 1, 1, 1);
			nrhang.tx3 = PIGFontString(nrhang,{"LEFT",nrhang,"LEFT",380,0},"","OUTLINE");
			function nrhang:ShowInfoFun(itemLinkD)
				self.tx1.t:SetText(itemLinkD);
			end
		end
		fujif:SetScript("OnShow", function (self)
			self.gengxinList()
		end)
		function fujif.gengxinList()
			self=fujif.Scroll
			for id = 1, nr_hang_Num do
				local fameX = fujif.ButList[id]
				fameX:Hide()
				fameX.tx1.t:SetText("");
				fameX.tx2:SetText("");
				fameX.tx3:SetText("");
			end
			if History.xuanzhongID>0 then
				local TabDataList ={["Data"]={},["Num"]=0,["Data1"]={},["Data2"]={}}
				if tabname=="Jiangli" then
					local infoData = PIGA["GDKP"]["History"][History.xuanzhongID].Players
					for p=1,8 do
						for pp=1,#infoData[p] do
							local gerenData = infoData[p][pp]
							for g=1,#LeftmenuV do
								if gerenData[4]==LeftmenuV[g] then
									if gerenData[5] then
										local bili = gerenData[6]*0.01
										local biliG = zongshouru*bili
										table.insert(TabDataList.Data,{buzhuzhize[g].."补助",biliG,gerenData[1]})
									else
										table.insert(TabDataList.Data,{buzhuzhize[g].."补助",gerenData[6],gerenData[1]})
									end
								end
							end
						end
					end
				elseif tabname=="Tops" then
					local sortedKeys,topsList=RaidR.GetTopData(PIGA["GDKP"]["History"][History.xuanzhongID].ItemList)
					TabDataList.Data=sortedKeys
					TabDataList.Data1=topsList
					TabDataList.Data2 = PIGA["GDKP"]["History"][History.xuanzhongID][tabname]
				else
					TabDataList.Data = PIGA["GDKP"]["History"][History.xuanzhongID][tabname]
				end
				TabDataList.Num=#TabDataList.Data
			    FauxScrollFrame_Update(self, TabDataList.Num, nr_hang_Num, nr_hang_Height);
			    local offset = FauxScrollFrame_GetOffset(self);
				for id = 1, nr_hang_Num do
					local dangqian = id+offset;
					if TabDataList.Data[dangqian] then
						local fameX = fujif.ButList[id]
						fameX:Show()
						if tabname=="ItemList" then
							fameX.itemID=TabDataList.Data[dangqian][11]
							Fun.HY_ShowItemLink(fameX,TabDataList.Data[dangqian][11],TabDataList.Data[dangqian][2])
							fameX.tx2:SetText(TabDataList.Data[dangqian][9].."\124cffFFFF00 G\124r");
							fameX.tx3:SetText(TabDataList.Data[dangqian][8]);
						elseif tabname=="Jiangli" or tabname=="Fakuan" then
							fameX.tx1.t:SetText(TabDataList.Data[dangqian][1]);
							if TabDataList.Data[dangqian][4] then
								fameX.tx2:SetText(TabDataList.Data[dangqian][2].."(欠"..TabDataList.Data[dangqian][4]..")\124cffFFFF00 G\124r");
							else
								fameX.tx2:SetText(TabDataList.Data[dangqian][2].."\124cffFFFF00 G\124r");
							end
							fameX.tx3:SetText(TabDataList.Data[dangqian][3]);
						elseif tabname=="Tops" then
							fameX.tx1.t:SetText(TabDataList.Data[dangqian]);
							fameX.tx2:SetText(TabDataList.Data1[TabDataList.Data[dangqian]].."\124cffFFFF00 G\124r");
							if TabDataList.Data2 and TabDataList.Data2[TabDataList.Data[dangqian]] then
								fameX.tx3:SetText(TabDataList.Data2[TabDataList.Data[dangqian]][1]);
							end
						end
					end
				end
			end
		end
	end
	local itemF,itemTabBut=PIGOptionsList_R(History.F,"拾取记录",80)
	itemF:Show()
	itemTabBut:Selected()
	add_TABScroll(itemF,"ItemList")
	----
	add_TABScroll(PIGOptionsList_R(History.F,"补助/奖励",80),"Jiangli")
	----
	add_TABScroll(PIGOptionsList_R(History.F,"罚款/其他",80),"Fakuan")
	---
	add_TABScroll(PIGOptionsList_R(History.F,"消费榜",80),"Tops")
	----
	local renyaunF=PIGOptionsList_R(History.F,"人员信息",80)
	local duiwuW,duiwuH = 130,28;
	local jiangeW,jiangeH,juesejiangeH = 13,0,6;
	renyaunF.duiwuList={}
	for p=1,8 do
		local duiwuF = CreateFrame("Frame", nil, renyaunF);
		renyaunF.duiwuList[p]=duiwuF
		duiwuF:SetSize(duiwuW,duiwuH*5+juesejiangeH*4);
		if p==1 then
			duiwuF:SetPoint("TOPLEFT",renyaunF,"TOPLEFT",12,-18);
		end
		if p>1 and p<5 then
			duiwuF:SetPoint("LEFT",renyaunF.duiwuList[p-1],"RIGHT",jiangeW,jiangeH);
		end
		if p==5 then
			duiwuF:SetPoint("TOP",renyaunF.duiwuList[1],"BOTTOM",0,-24);
		end
		if p>5 then
			duiwuF:SetPoint("LEFT",renyaunF.duiwuList[p-1],"RIGHT",jiangeW,jiangeH);
		end
		duiwuF.PList={}
		for pp=1,5 do
			local playerF = PIGButton(duiwuF,nil,{duiwuW,duiwuH});
			duiwuF.PList[pp]=playerF
			PIGSetFont(playerF.Text,14,"OUTLINE")
			if pp==1 then
				playerF:SetPoint("TOP",duiwuF,"TOP",0,0);
			else
				playerF:SetPoint("TOP",duiwuF.PList[pp-1],"BOTTOM",0,-juesejiangeH);
			end
		end
	end
	function renyaunF.gengxinList()
		for p=1,8 do
			for pp=1,5 do
				local pff = renyaunF.duiwuList[p].PList[pp]
				pff:Hide();
				pff:SetText(NONE);
			end
	    end
	    local shujuyuan = PIGA["GDKP"]["History"][History.xuanzhongID].Players
		local ItemsNum = #shujuyuan;
		for p=1,ItemsNum do
			for pp=1,#shujuyuan[p] do
				if shujuyuan[p][pp] then
			   		local pff = renyaunF.duiwuList[p].PList[pp]
			   		pff:Show();
			   		local wanjianame=shujuyuan[p][pp][1]
			   		local wanjiaName, fuwiqiName = strsplit("-", wanjianame);
			   		if fuwiqiName then
						pff:SetText(wanjiaName.."(*)");
					else
						pff:SetText(wanjiaName);
					end
					local color = PIG_CLASS_COLORS[shujuyuan[p][pp][2]]
					pff.Text:SetTextColor(color.r, color.g, color.b,1);
			   	end
			end
		end
	end
	renyaunF:SetScript("OnShow", function (self)
		self.gengxinList()
	end)
	--汇总
	History.nr.heji_1 = PIGFontString(History.nr,{"TOPLEFT",History.F,"BOTTOMLEFT",2,-5},"\124cffFFFF00物品收入/G：\124r","OUTLINE");
	History.nr.heji_1V = PIGFontString(History.nr,{"LEFT",History.nr.heji_1,"RIGHT",0,0},0,"OUTLINE");
	History.nr.heji_1V:SetTextColor(1, 1, 1, 1);
	History.nr.heji_2 = PIGFontString(History.nr,{"TOPLEFT",History.nr.heji_1,"BOTTOMLEFT",0,-5},"\124cffFFFF00罚款收入/G：\124r","OUTLINE");
	History.nr.heji_2V = PIGFontString(History.nr,{"LEFT",History.nr.heji_2,"RIGHT",0,0},0,"OUTLINE");
	History.nr.heji_2V:SetTextColor(1, 1, 1, 1);

	History.nr.heji_3 = PIGFontString(History.nr,{"TOPLEFT",History.F,"BOTTOMLEFT",150,-5},"\124cffFFFF00补助支出/G：\124r","OUTLINE");
	History.nr.heji_3V = PIGFontString(History.nr,{"LEFT",History.nr.heji_3,"RIGHT",0,0},0,"OUTLINE");
	History.nr.heji_3V:SetTextColor(1, 1, 1, 1);
	History.nr.heji_4 = PIGFontString(History.nr,{"TOPLEFT",History.nr.heji_3,"BOTTOMLEFT",0,-5},"\124cffFFFF00奖励支出/G：\124r","OUTLINE");
	History.nr.heji_4V = PIGFontString(History.nr,{"LEFT",History.nr.heji_4,"RIGHT",0,0},0,"OUTLINE");
	History.nr.heji_4V:SetTextColor(1, 1, 1, 1);

	History.nr.heji_5 = PIGFontString(History.nr,{"TOPLEFT",History.F,"BOTTOMLEFT",300,-5},"\124cffFFFF00总收入/G：\124r","OUTLINE");
	History.nr.heji_5V = PIGFontString(History.nr,{"LEFT",History.nr.heji_5,"RIGHT",0,0},0,"OUTLINE");
	History.nr.heji_5V:SetTextColor(1, 1, 1, 1);
	History.nr.heji_6 = PIGFontString(History.nr,{"TOPLEFT",History.nr.heji_5,"BOTTOMLEFT",0,-5},"\124cffFFFF00净收入/G：\124r","OUTLINE");
	History.nr.heji_6V = PIGFontString(History.nr,{"LEFT",History.nr.heji_6,"RIGHT",0,0},0,"OUTLINE");
	History.nr.heji_6V:SetTextColor(1, 1, 1, 1);

	History.nr.heji_7 = PIGFontString(History.nr,{"TOPLEFT",History.F,"BOTTOMLEFT",450,-5},"\124cffFFFF00人均/G：\124r","OUTLINE");
	History.nr.heji_7V = PIGFontString(History.nr,{"LEFT",History.nr.heji_7,"RIGHT",0,0},0,"OUTLINE");
	History.nr.heji_7V:SetTextColor(1, 1, 1, 1);

	History.nr.Del = PIGButton(History.nr,{"TOPLEFT",History.nr.heji_7,"BOTTOMLEFT",0,-4},{50,20},"删除"); 
	History.nr.Del:SetScript("OnClick", function (self)
		if History.xuanzhongID>0 then
			StaticPopup_Show ("DEL_HISTORYBENCI");
		end
	end);
	StaticPopupDialogs["DEL_HISTORYBENCI"] = {
		text = "删除此历史记录吗？\n",
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			table.remove(PIGA["GDKP"]["History"], History.xuanzhongID);
			History.xuanzhongID=0
			RaidR.Update_History()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	History.nr.tiqu = PIGButton(History.nr,{"LEFT",History.nr.Del,"RIGHT",20,0},{50,20},"提取"); 
	History.nr.tiqu:SetScript("OnClick", function (self)
		if History.xuanzhongID>0 then
			StaticPopup_Show ("TIQU_HISTORYINFO");
		end
	end);
	local function daorubuzhufakuanSET(Old_Data,NewdataX,simoren)
		if #Old_Data>0 then
			for p=1,#NewdataX do
				NewdataX[p][2]=0
				NewdataX[p][3]=NONE
				NewdataX[p][4]=simoren
				for ii=1,#Old_Data do
					if NewdataX[p][1]==Old_Data[ii][1] then
						NewdataX[p][2]=Old_Data[ii][2]
						NewdataX[p][3]=Old_Data[ii][3]
						NewdataX[p][4]=Old_Data[ii][4]
						break
					end
				end
			end
		end
	end
	StaticPopupDialogs["TIQU_HISTORYINFO"] = {
		text = "提取此历史记录到当前吗？\n\n\124cffff0000当前已有记录将会被覆盖\124r\n\124cffff0000已提取的历史记录将会被删除\124r",
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			local Old_Data = PIGA["GDKP"]["History"][History.xuanzhongID];
			PIGA["GDKP"]["instanceName"] =PIGCopyTable(Old_Data.Biaoti)
			PIGA["GDKP"]["ItemList"] =PIGCopyTable(Old_Data.ItemList)
			PIGA["GDKP"]["Raidinfo"] =PIGCopyTable(Old_Data.Players)
			daorubuzhufakuanSET(Old_Data.Jiangli,PIGA["GDKP"]["jiangli"],false)
			daorubuzhufakuanSET(Old_Data.Fakuan,PIGA["GDKP"]["fakuan"],0)
			PIGA["GDKP"]["Dongjie"] = true;
			table.remove(PIGA["GDKP"]["History"], History.xuanzhongID);
			History.xuanzhongID=0
			RaidR.Update_DqName()
			RaidR:Update_DongjieBUT()
			RaidR.Update_Item()
			RaidR.Update_Buzhu_TND()
			RaidR.Update_Buzhu_QITA()
			RaidR.Update_Fakuan()
			RaidR.Update_FenG()
			RaidR.Update_History()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	local function HistoryUpdateGinfo()
		local Old_Data = PIGA["GDKP"]["History"][History.xuanzhongID];
		--物品收入
		local Wupin_shouru=0;
		local dataX = Old_Data.ItemList
		for xx = 1, #dataX do
			Wupin_shouru=Wupin_shouru+dataX[xx][9]+dataX[xx][14];
		end
		History.nr.heji_1V:SetText(Wupin_shouru);
		--罚款+其他收入
		local fakuan_shouru=0;
		local dataX = Old_Data.Fakuan
		for xx = 1, #dataX do
			if dataX[xx][3]~=NONE then
				fakuan_shouru=fakuan_shouru+dataX[xx][2]+dataX[xx][4];
			end
		end
		History.nr.heji_2V:SetText(fakuan_shouru);
		--总收入
		local Zshouru=Wupin_shouru+fakuan_shouru;
		History.nr.heji_5V:SetText(Zshouru);
		--补助支出
		local Buzhu_shouru=0;
		local dataX = Old_Data.Players
		for p=1,#dataX do
			for pp=1,#dataX[p] do
				if dataX[p][pp][4] then
					if dataX[p][pp][5] then--百分比补助
						Buzhu_shouru=Buzhu_shouru+Zshouru*(dataX[p][pp][6]*0.01);
					else
						Buzhu_shouru=Buzhu_shouru+dataX[p][pp][6];
					end
				end
			end
		end
		History.nr.heji_3V:SetText(Buzhu_shouru);
		--奖励支出
		local jiangli_shouru=0;
		local dataX = Old_Data.Jiangli
		for xx = 1, #dataX do
			if dataX[xx][3]~=NONE then
				if dataX[xx][4] then--百分比补助
					jiangli_shouru=jiangli_shouru+Zshouru*(dataX[xx][2]*0.01);
				else
					jiangli_shouru=jiangli_shouru+dataX[xx][2]
				end
			end
		end
		History.nr.heji_4V:SetText(jiangli_shouru);
		---
		local Jshouru=Zshouru-Buzhu_shouru-jiangli_shouru;
		History.nr.heji_6V:SetText(Jshouru);
		--人数
		local infoData = Old_Data.Players
		local Historyrenyuanxinxi= 0
		for p=1,8 do
			local duinum = #infoData[p]
			if duinum>0 then
				Historyrenyuanxinxi=Historyrenyuanxinxi+duinum
			end
		end
		if Historyrenyuanxinxi>0 then
			History.nr.heji_7V:SetText(floor(Jshouru/Historyrenyuanxinxi));
		else
			History.nr.heji_7V:SetText(0);
		end
	end
	function History.nrgengxin_heji()
		if History.xuanzhongID>0 then
			History.nr:Show()
			HistoryUpdateGinfo()
		else
			History.nr:Hide()
		end
	end
end