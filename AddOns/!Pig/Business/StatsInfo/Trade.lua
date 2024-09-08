local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
--
local Fun=addonTable.Fun
local Create=addonTable.Create
local PIGLine=Create.PIGLine
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGCloseBut = Create.PIGCloseBut
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGTabBut=Create.PIGTabBut
------
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.Trade()
	local StatsInfo = StatsInfo_UI
	local PlayerData = PIGA["StatsInfo"]["Players"]
	for k,v in pairs(PlayerData) do
		PIGA["StatsInfo"]["TradeData"][k]=PIGA["StatsInfo"]["TradeData"][k] or {}
		local shujuyaun=PIGA["StatsInfo"]["TradeData"][k]
		if #shujuyaun>0 then
			if #shujuyaun[1]>0 then
				for ii=#shujuyaun[1], 1, -1 do
						local dangqianday=floor(GetServerTime()/60/60/24);
						local jiluday=shujuyaun[1][ii];
						if (dangqianday-jiluday)>30 then
							table.remove(shujuyaun[1],ii);
							table.remove(shujuyaun[2],ii);
						end
				end
			else
					
			end
		end
   	end

	local fujiF,fujiTabBut=PIGOptionsList_R(StatsInfo.F,"交\n易",StatsInfo.butW,"Left")
	---
	fujiF.PList=PIGFrame(fujiF)
	fujiF.PList:PIGSetBackdrop(0)
	fujiF.PList:SetWidth(190)
	fujiF.PList:SetPoint("TOPLEFT",fujiF,"TOPLEFT",0,0);
	fujiF.PList:SetPoint("BOTTOMLEFT",fujiF,"BOTTOMLEFT",0,0);
	fujiF.SelectName=nil
	---
	local P_hang_Height,P_hang_NUM  = 18, 12;
	fujiF.PList.Scroll = CreateFrame("ScrollFrame",nil,fujiF.PList, "FauxScrollFrameTemplate");  
	fujiF.PList.Scroll:SetPoint("TOPLEFT",fujiF.PList,"TOPLEFT",2,-2);
	fujiF.PList.Scroll:SetPoint("BOTTOMRIGHT",fujiF.PList,"BOTTOMRIGHT",-20,2);
	fujiF.PList.Scroll.ScrollBar:SetScale(0.8)
	fujiF.PList.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, P_hang_Height, fujiF.gengxin_List)
	end)
	for id = 1, P_hang_NUM, 1 do
		local hang = CreateFrame("Button", "PIG_TradeListP_"..id, fujiF.PList);
		hang:SetSize(fujiF.PList:GetWidth()-4,P_hang_Height*2+4);
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.PList.Scroll, "TOPLEFT", 0, -2);
		else
			hang:SetPoint("TOPLEFT", _G["PIG_TradeListP_"..id-1], "BOTTOMLEFT", 0, -2);
		end
		if id~=P_hang_NUM then
			hang.line = PIGLine(hang,"BOT",0,nil,nil,{0.3,0.3,0.3,0.6})
		end
		hang.highlight = hang:CreateTexture();
		hang.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
		hang.highlight:SetBlendMode("ADD")
		hang.highlight:SetPoint("TOPLEFT", hang, "TOPLEFT", 0,0);
		hang.highlight:SetPoint("BOTTOMRIGHT", hang, "BOTTOMRIGHT", 0,0);
		hang.highlight:SetAlpha(0.4);
		hang.highlight:SetDrawLayer("BORDER", -2)
		hang.highlight:Hide();
		hang.highlight1 = hang:CreateTexture();
		hang.highlight1:SetTexture("interface/buttons/ui-listbox-highlight.blp");
		hang.highlight1:SetDrawLayer("BORDER", -1)
		hang.highlight1:SetPoint("TOPLEFT", hang, "TOPLEFT", 0,0);
		hang.highlight1:SetPoint("BOTTOMRIGHT", hang, "BOTTOMRIGHT", 0,0);
		hang.highlight1:SetAlpha(0.9);
		hang.highlight1:Hide();
		hang.Faction = hang:CreateTexture();
		hang.Faction:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
		hang.Faction:SetPoint("TOPLEFT", hang, "TOPLEFT", 0,-2);
		hang.Faction:SetSize(P_hang_Height,P_hang_Height);
		hang.Race = hang:CreateTexture();
		hang.Race:SetTexture("Interface/Glues/CharacterCreate/CharacterCreateIcons")
		hang.Race:SetPoint("LEFT", hang.Faction, "RIGHT", 1,0);
		hang.Race:SetSize(P_hang_Height,P_hang_Height);
		hang.Class = hang:CreateTexture();
		hang.Class:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
		hang.Class:SetPoint("LEFT", hang.Race, "RIGHT", 1,0);
		hang.Class:SetSize(P_hang_Height,P_hang_Height);
		hang.level = PIGFontString(hang,{"LEFT", hang.Class, "RIGHT", 2, 0},1,"OUTLINE")
		hang.level:SetTextColor(1,0.843,0, 1);
		hang.nameDQ = hang:CreateTexture();
		hang.nameDQ:SetTexture("interface/common/indicator-green.blp")
		hang.nameDQ:SetPoint("LEFT", hang.level, "RIGHT", 1,0);
		hang.nameDQ:SetSize(P_hang_Height+2,P_hang_Height+2);
		hang.name = PIGFontString(hang,{"TOPLEFT", hang.Faction, "BOTTOMLEFT", 0, -2},nil,"OUTLINE")
		hang:SetScript("OnEnter", function (self)
			if not self.highlight1:IsShown() then
				self.highlight:Show();
			end
		end);
		hang:SetScript("OnLeave", function (self)
			self.highlight:Hide();
		end);
		hang:SetScript("OnClick", function (self)
			PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
			fujiF.SelectName=hang.allname
			fujiF.SelectTime=1
			for v=1,P_hang_NUM do
				local fujix = _G["PIG_TradeListP_"..v]
				fujix.highlight1:Hide();
				fujix.highlight:Hide();
			end
			self.highlight1:Show();
			fujiF.TradeList.err:Hide();
			fujiF.gengxin_List_Time(fujiF.TimeList.Scroll,true)
			fujiF.gengxin_List_NR(fujiF.TradeList.Scroll,true)
		end)
	end
	function fujiF.gengxin_List(self)
		if not fujiF:IsVisible() then return end
		for id = 1, P_hang_NUM, 1 do
			local fujik = _G["PIG_TradeListP_"..id]
			fujik:Hide();
			fujik.highlight1:Hide();
			fujik.nameDQ:Hide()
		end
		local cdmulu={};
		local PlayerData = PIGA["StatsInfo"]["Players"]
		local PlayerSH = PIGA["StatsInfo"]["PlayerSH"]
		if PlayerData[StatsInfo.allname] and not PlayerSH[StatsInfo.allname] then
			local dangqianC=PlayerData[StatsInfo.allname]
			table.insert(cdmulu,{StatsInfo.allname,dangqianC[1],dangqianC[2],dangqianC[3],dangqianC[4],dangqianC[5],true})
		end
	   	for k,v in pairs(PlayerData) do
	   		if k~=StatsInfo.allname and PlayerData[k] and not PlayerSH[k] then
	   			table.insert(cdmulu,{k,v[1],v[2],v[3],v[4],v[5]})
	   		end
	   	end
		local ItemsNum = #cdmulu;
		if ItemsNum>0 then
		    FauxScrollFrame_Update(self, ItemsNum, P_hang_NUM, P_hang_Height);
		    local offset = FauxScrollFrame_GetOffset(self);
		    for id = 1, P_hang_NUM do
				local dangqian = id+offset;
				if cdmulu[dangqian] then
					local fujik = _G["PIG_TradeListP_"..id]
					fujik:Show();
					if fujiF.SelectName==cdmulu[dangqian][1] then
						fujik.highlight1:Show();
					end
					if cdmulu[dangqian][2]=="Alliance" then
						fujik.Faction:SetTexCoord(0,0.5,0,1);
					elseif cdmulu[dangqian][2]=="Horde" then
						fujik.Faction:SetTexCoord(0.5,1,0,1);
					end
					fujik.Race:SetAtlas(cdmulu[dangqian][4]);
					local className, classFile, classID = GetClassInfo(cdmulu[dangqian][5])
					fujik.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
					fujik.level:SetText(cdmulu[dangqian][6]);
					if cdmulu[dangqian][7] then
						fujik.nameDQ:Show()
					end
					fujik.name:SetText(cdmulu[dangqian][1]);
					fujik.allname=cdmulu[dangqian][1]
					local color = PIG_CLASS_COLORS[classFile];
					fujik.name:SetTextColor(color.r, color.g, color.b, 1);
				end
			end
		end
	end
	--日期列表
	fujiF.TimeList=PIGFrame(fujiF)
	fujiF.TimeList:SetWidth(106)
	fujiF.TimeList:PIGSetBackdrop(0)
	fujiF.TimeList:SetPoint("TOPLEFT",fujiF.PList,"TOPRIGHT",2,0);
	fujiF.TimeList:SetPoint("BOTTOMLEFT",fujiF.PList,"BOTTOMRIGHT",0,0);
	fujiF.SelectTime=nil
	local T_hang_Height,T_hang_NUM  = 24, 21;
	fujiF.TimeList.Scroll = CreateFrame("ScrollFrame",nil,fujiF.TimeList, "FauxScrollFrameTemplate");  
	fujiF.TimeList.Scroll:SetPoint("TOPLEFT",fujiF.TimeList,"TOPLEFT",0,-2);
	fujiF.TimeList.Scroll:SetPoint("BOTTOMRIGHT",fujiF.TimeList,"BOTTOMRIGHT",-25,2);
	fujiF.TimeList.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, T_hang_Height, fujiF.gengxin_List_Time)
	end)
	for i=1, T_hang_NUM, 1 do
		local listbut = CreateFrame("Button", "PIG_TradeListTime_"..i,fujiF.TimeList);
		listbut:SetSize(fujiF.TimeList:GetWidth()-4,T_hang_Height);
		if i==1 then
			listbut:SetPoint("TOPLEFT", fujiF.TimeList.Scroll, "TOPLEFT", 0, 0);
		else
			listbut:SetPoint("TOPLEFT", _G["PIG_TradeListTime_"..(i-1)], "BOTTOMLEFT", 0, 0);
		end
		listbut:Hide()
		listbut.highlight = listbut:CreateTexture();
		listbut.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
		listbut.highlight:SetBlendMode("ADD")
		listbut.highlight:SetPoint("TOPLEFT", listbut, "TOPLEFT", 2,0);
		listbut.highlight:SetPoint("BOTTOMRIGHT", listbut, "BOTTOMRIGHT", -2,0);
		listbut.highlight:SetAlpha(0.4);
		listbut.highlight:Hide();
		listbut.highlight1 = listbut:CreateTexture();
		listbut.highlight1:SetTexture("interface/buttons/ui-listbox-highlight.blp");
		listbut.highlight1:SetPoint("TOPLEFT", listbut, "TOPLEFT", 2,0);
		listbut.highlight1:SetPoint("BOTTOMRIGHT", listbut, "BOTTOMRIGHT", -2,0);
		listbut.highlight1:SetAlpha(0.9);
		listbut.highlight1:Hide();
		listbut.Title = PIGFontString(listbut,{"LEFT", listbut, "LEFT", 6, 0})
		listbut.Title:SetTextColor(0,250/255,154/255, 1);
		listbut:SetScript("OnEnter", function (self)
			if not self.highlight1:IsShown() then
				self.Title:SetTextColor(1,1,1,1);
				self.highlight:Show();
			end
		end);
		listbut:SetScript("OnLeave", function (self)
			if not self.highlight1:IsShown() then
				self.Title:SetTextColor(0,250/255,154/255,1);	
			end
			self.highlight:Hide();
		end);
		listbut:SetScript("OnClick", function (self)
			for v=1,T_hang_NUM do
				local fujix = _G["PIG_TradeListTime_"..v]
				fujix.highlight1:Hide();
				fujix.highlight:Hide();
				fujix.Title:SetTextColor(0,250/255,154/255,1);
			end
			self.Title:SetTextColor(1,1,1,1);
			self.highlight1:Show();
			fujiF.SelectTime=self:GetID()
			fujiF.gengxin_List_NR(fujiF.TradeList.Scroll,true)
		end)
	end
	function fujiF.gengxin_List_Time(self,chushi)
		for i = 1, T_hang_NUM do
			local fuji = _G["PIG_TradeListTime_"..i]
			fuji:Hide()
			fuji.Title:SetText("");
			fuji.Title:SetTextColor(0,250/255,154/255, 1);
			fuji.highlight1:Hide();
		end
		if not fujiF.SelectName then return end
		local shujuyuanPR=PIGA["StatsInfo"]["TradeData"][fujiF.SelectName]
		if shujuyuanPR then
			if shujuyuanPR[1] then
				local shujuData = shujuyuanPR[1];
				local ItemsNum = #shujuData;
				if ItemsNum>0 then
					if chushi then fujiF.SelectTime=ItemsNum end
				    FauxScrollFrame_Update(self, ItemsNum, T_hang_NUM, T_hang_Height);
				    local offset = FauxScrollFrame_GetOffset(self);
				    for i = 1, T_hang_NUM do
						local dangqian = (ItemsNum+1)-i-offset;
						if dangqian>0 then
							local fuji = _G["PIG_TradeListTime_"..i]
							fuji:Show()
							fuji:SetID(dangqian)
							fuji.Title:SetText(date("%Y-%m-%d",shujuData[dangqian]*86400));
							if dangqian==fujiF.SelectTime then
								fuji.Title:SetTextColor(1,1,1, 1);
								fuji.highlight1:Show();
							end
						end
					end
				end
			end
		end
	end
	-------
	fujiF.TradeList=PIGFrame(fujiF)
	fujiF.TradeList:PIGSetBackdrop(0)
	fujiF.TradeList:SetPoint("TOPLEFT",fujiF.TimeList,"TOPRIGHT",2,0);
	fujiF.TradeList:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",0,0);
	fujiF.TradeList.err = PIGFontString(fujiF.TradeList,{"CENTER", 0,60},"请在左侧列表选择要查看角色","OUTLINE")
	fujiF.TradeList.err:SetTextColor(0, 1, 0, 1);
	local N_hang_Height,N_hang_NUM  = 40, 12;
	fujiF.TradeList.Scroll = CreateFrame("ScrollFrame",nil,fujiF.TradeList, "FauxScrollFrameTemplate");  
	fujiF.TradeList.Scroll:SetPoint("TOPLEFT",fujiF.TradeList,"TOPLEFT",0,-2);
	fujiF.TradeList.Scroll:SetPoint("BOTTOMRIGHT",fujiF.TradeList,"BOTTOMRIGHT",-25,26);
	fujiF.TradeList.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, N_hang_Height, fujiF.gengxin_List_NR)
	end)
	for i=1, N_hang_NUM, 1 do
		local listbut = CreateFrame("Button", "PIG_TradeListNR_"..i,fujiF.TradeList,"BackdropTemplate");
		listbut:SetSize(fujiF.TradeList:GetWidth()-4,N_hang_Height);
		if i==1 then
			listbut:SetPoint("TOPLEFT", fujiF.TradeList.Scroll, "TOPLEFT", 1, 0);
		else
			listbut:SetPoint("TOPLEFT", _G["PIG_TradeListNR_"..(i-1)], "BOTTOMLEFT", 0, 0);
		end
		local tmp1,tmp2 = math.modf(i/2)
		if tmp2==0 then
			listbut:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
			listbut:SetBackdropColor(0.7, 0.7, 0.7, 0.1);
		end
		listbut:Hide()
		listbut.highlight = listbut:CreateTexture(nil, "BORDER");
		listbut.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
		listbut.highlight:SetBlendMode("ADD")
		listbut.highlight:SetPoint("TOPLEFT", listbut, "TOPLEFT", 2,0);
		listbut.highlight:SetPoint("BOTTOMRIGHT", listbut, "BOTTOMRIGHT", -2,0);
		listbut.highlight:SetAlpha(0.4);
		listbut.highlight:Hide();
		listbut.highlight1 = listbut:CreateTexture(nil, "BORDER");
		listbut.highlight1:SetTexture("interface/buttons/ui-listbox-highlight.blp");
		listbut.highlight1:SetPoint("TOPLEFT", listbut, "TOPLEFT", 2,0);
		listbut.highlight1:SetPoint("BOTTOMRIGHT", listbut, "BOTTOMRIGHT", -2,0);
		listbut.highlight1:SetAlpha(0.9);
		listbut.highlight1:Hide();
		listbut:SetScript("OnEnter", function (self)
			if not self.highlight1:IsShown() then
				self.highlight:Show();
			end
		end);
		listbut:SetScript("OnLeave", function (self)
			self.highlight:Hide();
		end);
		listbut:SetScript("OnClick", function (self)
			for v=1,N_hang_NUM do
				local fujix = _G["PIG_TradeListNR_"..v]
				fujix.highlight1:Hide();
				fujix.highlight:Hide();
			end
			self.highlight1:Show();
		end)
		listbut.Title = PIGFontString(listbut,{"TOPLEFT", listbut, "TOPLEFT", 6, -N_hang_Height*0.5+8})
		listbut.Title:SetTextColor(0.9, 0.9, 0.9, 0.9);
		listbut.Race = listbut:CreateTexture();
		listbut.Race:SetTexture("Interface/Glues/CharacterCreate/CharacterCreateIcons")
		listbut.Race:SetPoint("TOPLEFT", listbut, "TOPLEFT", 46, -2);
		listbut.Race:SetSize(N_hang_Height*0.5-2,N_hang_Height*0.5-2);
		listbut.Class = listbut:CreateTexture();
		listbut.Class:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
		listbut.Class:SetPoint("LEFT", listbut.Race, "RIGHT", 1,0);
		listbut.Class:SetSize(N_hang_Height*0.5-2,N_hang_Height*0.5-2);
		listbut.level = PIGFontString(listbut,{"LEFT", listbut.Class, "RIGHT", 2, 0},1,"OUTLINE")
		listbut.level:SetTextColor(1,0.843,0,1);
		listbut.Name = PIGFontString(listbut,{"LEFT", listbut.level, "RIGHT", 0, 0})
		listbut.MapName = PIGFontString(listbut,{"TOPLEFT", listbut.Race, "BOTTOMLEFT", 0, -3})
		listbut.MapName:SetTextColor(0.6,0.6,0.6,1);
		listbut.jiaochuP = PIGFontString(listbut,{"TOPLEFT", listbut, "TOPLEFT", 220, -2},"交出:")
		listbut.jiaochuP:SetTextColor(1,0,0,1);
		listbut.MoneyP = PIGFontString(listbut,{"TOPRIGHT", listbut, "TOPRIGHT", -30, 0})
		listbut.MoneyP:SetTextColor(1,0,0,1);
		listbut.shoudaoP = PIGFontString(listbut,{"TOPLEFT", listbut, "TOPLEFT", 220, -N_hang_Height*0.5-2},"收到:")
		listbut.shoudaoP:SetTextColor(0,1,0,1);
		listbut.MoneyT = PIGFontString(listbut,{"TOPRIGHT", listbut, "TOPRIGHT", -30, -N_hang_Height*0.5-2})
		listbut.MoneyT:SetTextColor(0,1,0,1);
		listbut.itembuttons={}
		for butid=1,12 do
			local xitembut = CreateFrame("Button",nil,listbut)
			xitembut:SetSize(N_hang_Height*0.5-2,N_hang_Height*0.5-2)
			listbut.itembuttons[butid]=xitembut
			xitembut:HookScript("OnEnter", function (self)
				local jifiameUI=self:GetParent()
				if not jifiameUI.highlight1:IsShown() then
					jifiameUI.highlight:Show();
				end
			end);
			xitembut:HookScript("OnLeave", function (self)
				local jifiameUI=self:GetParent()
				jifiameUI.highlight:Hide();
				GameTooltip:ClearLines();
				GameTooltip:Hide() 
			end);
			if butid<7 then
				if butid==1 then
					xitembut:SetPoint("LEFT", listbut.jiaochuP, "RIGHT", 4,-1);
				else
					xitembut:SetPoint("LEFT", listbut.jiaochuP, "RIGHT", (N_hang_Height*0.5)*(butid-1)+4,-1);
				end
			else
				if butid==7 then
					xitembut:SetPoint("LEFT", listbut.shoudaoP, "RIGHT", 4,-1);
				else
					xitembut:SetPoint("LEFT", listbut.shoudaoP, "RIGHT", (N_hang_Height*0.5)*(butid-7)+4,-1);
				end
			end
			xitembut.numItems = PIGFontString(xitembut,{"BOTTOMRIGHT", xitembut, "BOTTOMRIGHT", 0, 0},nil,"OUTLINE",12)
			xitembut.numItems:SetTextColor(1, 1, 1, 1);
		end
	end
	fujiF.TradeList.hejiF=PIGFrame(fujiF.TradeList,{"BOTTOMLEFT",fujiF.TradeList,"BOTTOMLEFT",0,0})
	fujiF.TradeList.hejiF:SetPoint("BOTTOMRIGHT",fujiF.TradeList,"BOTTOMRIGHT",0,0);
	fujiF.TradeList.hejiF:PIGSetBackdrop(0)
	fujiF.TradeList.hejiF:SetHeight(26)
	fujiF.TradeList.hejiF.JiluNumT = PIGFontString(fujiF.TradeList.hejiF,{"BOTTOMLEFT",fujiF.TradeList.hejiF,"BOTTOMLEFT",10,7},"当日交易成功总数:")
	fujiF.TradeList.hejiF.JiluNum = PIGFontString(fujiF.TradeList.hejiF,{"LEFT",fujiF.TradeList.hejiF.JiluNumT,"RIGHT",2,0},0)
	fujiF.TradeList.hejiF.JiluNum:SetTextColor(1, 1, 1, 1);
	fujiF.TradeList.hejiF.DELtimeall=PIGButton(fujiF.TradeList.hejiF,{"BOTTOMRIGHT",fujiF.TradeList.hejiF,"BOTTOMRIGHT",-65,2},{60,20},DELETE)
	fujiF.TradeList.hejiF.DELtimeall:Disable()
	fujiF.TradeList.hejiF.DELtimeall:SetScript("OnClick", function(self, button)
		StaticPopup_Show ("PIGTRADELISTTIMENR_DEL");
	end)
	StaticPopupDialogs["PIGTRADELISTTIMENR_DEL"] = {
		text = "此操作将\124cffff0000删除\124r选择日期所有交易记录，\n确定删除?",
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			if fujiF.SelectName and PIGA["StatsInfo"]["TradeData"][fujiF.SelectName][1] then
				table.remove(PIGA["StatsInfo"]["TradeData"][fujiF.SelectName][1],fujiF.SelectTime);
				table.remove(PIGA["StatsInfo"]["TradeData"][fujiF.SelectName][2],fujiF.SelectTime);
				fujiF.gengxin_List_Time(fujiF.TimeList.Scroll,true)
				fujiF.gengxin_List_NR(fujiF.TradeList.Scroll,true)
			end
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	function fujiF.gengxin_List_NR(self,chushi)
		fujiF.TradeList.hejiF.DELtimeall:Disable()
		for i = 1, N_hang_NUM do
			local fuji = _G["PIG_TradeListNR_"..i]
			fuji:Hide()
			fuji.Title:SetText("");
			fuji.highlight1:Hide();
		end
		if fujiF.SelectName and fujiF.SelectTime then
			local playerData=PIGA["StatsInfo"]["TradeData"][fujiF.SelectName]
			if playerData and playerData[2] then
				local shujuData = playerData[2][fujiF.SelectTime]
				if shujuData then
					local ItemsNum = #shujuData;
					fujiF.TradeList.hejiF.DELtimeall:Enable()
					fujiF.TradeList.hejiF.JiluNum:SetText(ItemsNum)
				    FauxScrollFrame_Update(self, ItemsNum, N_hang_NUM, N_hang_Height);
				    local offset = FauxScrollFrame_GetOffset(self);
				    for i = 1, N_hang_NUM do
						local dangqian = (ItemsNum+1)-i-offset;
						if shujuData[dangqian] then
							local fuji = _G["PIG_TradeListNR_"..i]
							fuji:Show()
							fuji.Title:SetText(date("%H:%M",shujuData[dangqian]["Time"]));
							fuji.Race:SetAtlas(shujuData[dangqian]["Race"]);
							local className, classFile, classID = GetClassInfo(shujuData[dangqian]["Class"])
							fuji.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
							fuji.level:SetText(shujuData[dangqian]["Level"]);
							local color = PIG_CLASS_COLORS[classFile];
							fuji.Name:SetText(shujuData[dangqian]["Name"])
							fuji.Name:SetTextColor(color.r, color.g, color.b, 1);
							fuji.MapName:SetText(shujuData[dangqian]["Map"])
							if shujuData[dangqian]["MoneyP"]>0 then
								fuji.MoneyP:SetText(GetMoneyString(shujuData[dangqian]["MoneyP"]))
							end
							if shujuData[dangqian]["MoneyT"]>0 then
								fuji.MoneyT:SetText(GetMoneyString(shujuData[dangqian]["MoneyT"]))
							end
							for butid=1,6 do
								if shujuData[dangqian]["ItemP"][butid]~=NONE then
									local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = GetItemInfoInstant(shujuData[dangqian]["ItemP"][butid][1]) 
									fuji.itembuttons[butid]:SetNormalTexture(icon)
									fuji.itembuttons[butid].numItems:SetText(shujuData[dangqian]["ItemP"][butid][2])
									fuji.itembuttons[butid]:HookScript("OnEnter", function (self)
										GameTooltip:ClearLines();
										GameTooltip:SetOwner(self, "ANCHOR_LEFT",0,0);
										GameTooltip:SetHyperlink(shujuData[dangqian]["ItemP"][butid][1])
										GameTooltip:Show();
									end);
								end
							end
							for butid=1,6 do
								if shujuData[dangqian]["ItemT"][butid]~=NONE then
									local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = GetItemInfoInstant(shujuData[dangqian]["ItemT"][butid][1]) 
									fuji.itembuttons[butid+6]:SetNormalTexture(icon)
									fuji.itembuttons[butid+6].numItems:SetText(shujuData[dangqian]["ItemT"][butid][2])
									fuji.itembuttons[butid+6]:HookScript("OnEnter", function (self)
										GameTooltip:ClearLines();
										GameTooltip:SetOwner(self, "ANCHOR_LEFT",0,0);
										GameTooltip:SetHyperlink(shujuData[dangqian]["ItemT"][butid][1])
										GameTooltip:Show();
									end);
								end
							end
							---
						end
					end
				end
			end
		end
	end
	--
	fujiF:HookScript("OnShow", function(self)
		fujiF.gengxin_List(self.PList.Scroll);
	end)
	----
	local function ISTimeDay(DQday,timelist)
		for d=#timelist, 1, -1 do
			if timelist[d]==DQday then
				return true,d
			end
		end
		return false
	end
	local IsFriend=Fun.IsFriend
	fujiF:RegisterEvent("UI_INFO_MESSAGE");
	fujiF:SetScript("OnEvent", function(self,event,arg1,arg2)
		if event=="UI_INFO_MESSAGE" then
			if arg2==ERR_TRADE_COMPLETE then
				local xiaoxiTime=GetServerTime()
				local MapName=GetZoneText().."-"..GetSubZoneText()
				local TradeDATA={
					["Time"]=xiaoxiTime,["Map"]=MapName,["Name"]=TradeFrame.PIG_Data.Name,
					["Race"]=TradeFrame.PIG_Data.Race,["Class"]=TradeFrame.PIG_Data.Class,["Level"]=TradeFrame.PIG_Data.Level,
					["MoneyP"]=TradeFrame.PIG_Data.MoneyP,["MoneyT"]=TradeFrame.PIG_Data.MoneyT,
					["ItemP"]=TradeFrame.PIG_Data.ItemP,["ItemT"]=TradeFrame.PIG_Data.ItemT
				}
				local YYDAY=floor(xiaoxiTime/60/60/24)
				local shujuyuanPR=PIGA["StatsInfo"]["TradeData"][StatsInfo.allname]
				if #shujuyuanPR>0 then
					local cunzai,xuhao=ISTimeDay(YYDAY,shujuyuanPR[1])
					if cunzai then
						table.insert(shujuyuanPR[2][xuhao], TradeDATA);
					else
						--print(cunzai,xuhao)
						table.insert(shujuyuanPR[1], YYDAY);
						table.insert(shujuyuanPR[2], {TradeDATA});
					end
				else
					PIGA["StatsInfo"]["TradeData"][StatsInfo.allname]={{YYDAY},{{TradeDATA}}}
				end
				
				local FSmsgT = {"",""}
				if TradeFrame.PIG_Data.MoneyP>0 then
					FSmsgT[1]=FSmsgT[1]..(TradeFrame.PIG_Data.MoneyP*0.0001).."G"
				end
				for i=1,6 do
					if TradeFrame.PIG_Data.ItemP[i]~=NONE then
						FSmsgT[1]=FSmsgT[1]..TradeFrame.PIG_Data.ItemP[i][1]
						if TradeFrame.PIG_Data.ItemP[i][2]>1 then
							FSmsgT[1]=FSmsgT[1].."×"..TradeFrame.PIG_Data.ItemP[i][2]
						end
					end
				end
				if FSmsgT[1]~="" then FSmsgT[1]="交出"..FSmsgT[1] end
				if TradeFrame.PIG_Data.MoneyT>0 then
					FSmsgT[2]=FSmsgT[2]..(TradeFrame.PIG_Data.MoneyT*0.0001).."G"
				end
				for i=1,6 do
					if TradeFrame.PIG_Data.ItemT[i]~=NONE then
						FSmsgT[2]=FSmsgT[2]..TradeFrame.PIG_Data.ItemT[i][1]
						if TradeFrame.PIG_Data.ItemT[i][2]>1 then
							FSmsgT[2]=FSmsgT[2].."×"..TradeFrame.PIG_Data.ItemT[i][2]
						end
					end
				end
				if FSmsgT[2]~="" and FSmsgT[1]~="" then
					FSmsgT[2]=",收到"..FSmsgT[2]
				elseif FSmsgT[2]~="" then
					FSmsgT[2]="收到"..FSmsgT[2]
				end
				if FSmsgT[1]~="" or FSmsgT[2]~="" then
					local msgT = "!Pig:与<"..TradeFrame.PIG_Data.Name..">交易成功,"..FSmsgT[1]..FSmsgT[2]
					if PIGA["StatsInfo"]["TradeTongGao"] then
						if not IsFriend(TradeFrame.PIG_Data.Name) then
							if PIGA["StatsInfo"]["TradeTongGaoChannel"]=="WHISPER" then
								SendChatMessage(msgT, "WHISPER", nil, TradeFrame.PIG_Data.Name);
							else
								if HasLFGRestrictions() then
									SendChatMessage(msgT, "INSTANCE_CHAT");
								elseif IsInRaid() then
									SendChatMessage(msgT, "RAID");
								elseif IsInGroup() then
									SendChatMessage(msgT, "PARTY");
								end
								return
							end
						end
					end
					if IsAddOnLoaded(L.extLsit[2]) and PIGA["GDKP"]["Rsetting"]["tradetonggao"] then
						SendChatMessage(msgT, "RAID");
					end
				end
				-- 
			end
		end
	end)
end
