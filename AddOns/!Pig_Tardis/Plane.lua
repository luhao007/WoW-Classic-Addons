local addonName, addonTable = ...;
local TardisInfo=addonTable.TardisInfo
function TardisInfo.Plane(Activate)
	if not PIGA["Tardis"]["Plane"]["Open"] then return end
	local Create, Data, Fun, L= unpack(PIG)
	local sub = _G.string.sub 
	---------------------------
	local PIGFrame=Create.PIGFrame
	local PIGLine=Create.PIGLine
	local PIGButton = Create.PIGButton
	local PIGEnter = Create.PIGEnter
	local PIGCheckbutton=Create.PIGCheckbutton
	local PIGOptionsList_R=Create.PIGOptionsList_R
	local PIGFontString=Create.PIGFontString
	local PIGSetFont=Create.PIGSetFont
	-----------------
	local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
	local InvF=_G[GnUI]
	local pindao,hang_Height,hang_NUM,xuanzhongBG=InvF.pindao,InvF.hang_Height,InvF.hang_NUM,InvF.xuanzhongBG
	local GetPIGID=Fun.GetPIGID
	local gnindexID=4
	local GetInfoMsg=Data.Tardis.GetMsg[gnindexID]
	local shenqingMSG_T = Data.Tardis.SqMsg[gnindexID]
	local shenqingMSG_V = Data.Tardis.ver[gnindexID]
	local qianzhui=Data.Tardis.qianzhui[gnindexID]
	local shenqingMSG = shenqingMSG_T..shenqingMSG_V;
	-----
	local fujiF,fujiTabBut=PIGOptionsList_R(InvF.F,L["TARDIS_PLANE"],80,"Bot")
	if Activate then fujiF:Show() fujiTabBut:Selected() end
	-----------------
	fujiF.ZJbiaoti = PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-8},"你的位面:");
	fujiF.ZJbiaoti:SetTextColor(0, 0.98, 0.6, 1);
	fujiF.ZJPlaneID = PIGFontString(fujiF,{"LEFT", fujiF.ZJbiaoti, "RIGHT", 4, 0},"?");
	fujiF.ZJPlaneID:SetTextColor(1, 0, 0, 1);
	fujiF.ZJZoneID = PIGFontString(fujiF,{"LEFT", fujiF.ZJPlaneID, "RIGHT", 6, 0},"点击NPC获取");
	fujiF.ZJZoneID:SetTextColor(0.6, 0.6, 0.6, 1);
	-----
	fujiF.JieshouInfoList={};
	local CoolCDList = {{500,30},{400,60},{300,120},{200,180},{100,240}}
	local function GetCoolCD()
		for i=1,#CoolCDList do
			if PIGA["Tardis"]["Plane"]["HelpNum"]>CoolCDList[i][1] then
				return CoolCDList[i][2]
			end
		end
		return 300
	end
	fujiF.CoolCD=GetCoolCD()
	fujiF.GetBut=TardisInfo.GetInfoBut(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",180,-30},fujiF.CoolCD,2)
	fujiF.GetBut.ButName=L["TARDIS_PLANE"]
	fujiF.GetBut:HookScript("OnClick", function (self)
		if self.yanchiNerMsg then
			self.Highlight:Hide()
			self.yanchiNerMsg=false
			fujiF.filtrateData()
			fujiF.Update_hang()
			self:daojishiCDFUN()
		else
			if fujiF.ZJZoneID:GetText()=="点击NPC获取" then
				self.err:SetText("请点击任意NPC");
				return 
			end
			InvF:PIGSendAddonMsg("Plane",fujiF,gnindexID)
			self:CZdaojishi()
		end
	end);
	fujiF.GetBut.daojishiJG=PIGA["Tardis"]["Plane"]["DaojishiCD"]
	function fujiF.GetBut.Update_DataHang()
		fujiF.GetBut.yanchiNerMsg=false
		fujiF.filtrateData()
		fujiF.Update_hang()
	end
	-------------------------
	local Tooltip1= "|cffFFFF00当双方都打开此选项时可以直接申请组队，如只有一方打开则只能"..L["CHAT_WHISPER"].."申请对方组队|r";
	local Tooltip2 = "\n|cffFF0000关闭后其他玩家将不会自动接收你的申请\n(注意你在24小时内只能开关一次)|r"
	local Tooltip = Tooltip1..Tooltip2
	fujiF.AutoInvite =PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",420,-10},{"|cff00FF00自动接受"..L["TARDIS_PLANE"].."申请(未组队/未排本/未排战场时生效)|r",Tooltip})
	fujiF.AutoInvite.help = PIGFontString(fujiF.AutoInvite,{"TOPLEFT", fujiF.AutoInvite, "BOTTOMLEFT", 20, -4},"我为人人，人人为我。请不要做精致的利己主义者");
	fujiF.AutoInvite.help:SetTextColor(0, 1, 1, 1);
	fujiF.AutoInvite:SetScript("OnClick", function (self)
		if self:GetChecked() then
			local DaojishiCD = PIGA["Tardis"]["Plane"]["AutoInviteCD"]
			local shengyu = 86400-(GetServerTime()-DaojishiCD)
			if shengyu>0 then
				PIG_OptionsUI:ErrorMsg(L["TARDIS_PLANE"].."通道充能中...(剩余"..Fun.disp_time(shengyu).."分)","R")
				self:SetChecked(false)
				return 
			end
			PIGA["Tardis"]["Plane"]["AutoInvite"]=true;
		else
			StaticPopup_Show("OPEN_WEIMIANSHENQING");
		end
	end);
	StaticPopupDialogs["OPEN_WEIMIANSHENQING"] = {
		text = addonName..GnName.."-"..L["TARDIS_PLANE"].."：\n|cffFFFF00确定关闭自动接受玩家"..L["TARDIS_PLANE"].."申请吗？|r\n"..Tooltip2,
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function()
			PIGA["Tardis"]["Plane"]["AutoInvite"]=false;
			PIGA["Tardis"]["Plane"]["AutoInviteCD"]=GetServerTime();
		end,
		OnCancel = function()
			fujiF.AutoInvite:SetChecked(true)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	fujiF.AutoInvite.HelpTXT = PIGFontString(fujiF.AutoInvite,{"LEFT", fujiF.AutoInvite.Text, "RIGHT", 10, 0},"功德+");
	fujiF.AutoInvite.HelpNum = PIGFontString(fujiF.AutoInvite,{"LEFT", fujiF.AutoInvite.HelpTXT, "RIGHT", 2, 0},0);
	fujiF.AutoInvite.HelpNum:SetTextColor(0, 1, 0, 1);
	fujiF.AutoInvite.HelpFF=PIGFrame(fujiF.AutoInvite,{"LEFT", fujiF.AutoInvite.Text, "RIGHT", 10, 0},{90,16});
	fujiF.AutoInvite.HelpFF:SetScript("OnEnter", function (self)
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
		GameTooltip:AddLine("提示：")
		GameTooltip:AddLine("默认刷新CD为300秒")
		for i=#CoolCDList,1,-1 do
			GameTooltip:AddLine("功德>"..CoolCDList[i][1]..",刷新CD减少为"..CoolCDList[i][2].."秒")
		end
		GameTooltip:Show();
	end);
	fujiF.AutoInvite.HelpFF:SetScript("OnLeave", function ()
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end);
	-------------
	fujiF.nr=PIGFrame(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",4,-60})
	fujiF.nr:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", -4, 4);
	fujiF.nr:PIGSetBackdrop()
	local biaotiName={{L["TARDIS_PLANE"],20},{"区域ID",90},{"玩家名(|cffFF80FF点击"..L["CHAT_WHISPER"].."|r)",220},{"位置",420},{"自动接受申请",620},{"操作",740}}
	for i=1,#biaotiName do
		local biaoti=PIGFontString(fujiF.nr,{"TOPLEFT",fujiF.nr,"TOPLEFT",biaotiName[i][2],-5},biaotiName[i][1])
		biaoti:SetTextColor(1,1,0, 0.9);
	end
	fujiF.nr.line = PIGLine(fujiF.nr,"TOP",-24,nil,nil,{0.2,0.2,0.2,0.5})
	---
	local hang_Width = fujiF.nr:GetWidth();
	fujiF.nr.Scroll = CreateFrame("ScrollFrame",nil,fujiF.nr, "FauxScrollFrameTemplate");  
	fujiF.nr.Scroll:SetPoint("TOPLEFT",fujiF.nr,"TOPLEFT",2,-24);
	fujiF.nr.Scroll:SetPoint("BOTTOMRIGHT",fujiF.nr,"BOTTOMRIGHT",-20,2);
	fujiF.nr.Scroll.ScrollBar:SetScale(0.8);
	fujiF.nr.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fujiF.Update_hang)
	end)
	fujiF.nr.ButList={}
	for i=1, hang_NUM, 1 do
		local liebiao = CreateFrame("Frame", nil, fujiF.nr.Scroll:GetParent(),"BackdropTemplate");
		fujiF.nr.ButList[i]=liebiao
		liebiao:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
		liebiao:SetBackdropColor(unpack(xuanzhongBG[1]));
		liebiao:SetSize(hang_Width-4,hang_Height);
		if i==1 then
			liebiao:SetPoint("TOPLEFT", fujiF.nr.Scroll, "TOPLEFT", 0, 0);
		else
			liebiao:SetPoint("TOPLEFT", fujiF.nr.ButList[i-1], "BOTTOMLEFT", 0, -1.2);
		end
		liebiao:Hide()
		liebiao:HookScript("OnEnter", function (self)
			self:SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		liebiao:HookScript("OnLeave", function (self)
			self:SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		liebiao.Weimian = PIGFontString(liebiao,{"LEFT", liebiao, "LEFT",biaotiName[1][2], 0});
		liebiao.zoneID = PIGFontString(liebiao,{"LEFT", liebiao, "LEFT", biaotiName[2][2], 0});
		liebiao.zoneID:SetJustifyH("LEFT");

		liebiao.Name = CreateFrame("Frame", nil, liebiao);
		liebiao.Name:SetSize(120,hang_Height);
		liebiao.Name:SetPoint("LEFT", liebiao, "LEFT", biaotiName[3][2], 0);
		liebiao.Name:HookScript("OnEnter", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		liebiao.Name:HookScript("OnLeave", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		liebiao.Name.T = PIGFontString(liebiao,{"LEFT", liebiao.Name, "LEFT", 0, 0});
		liebiao.Name.T:SetTextColor(0,0.98,0.6, 1);
		liebiao.Name:SetScript("OnMouseUp", function(self,button)
			local wjName = self.T:GetText()
			if wjName==UNKNOWNOBJECT then return end
			local editBox = ChatEdit_ChooseBoxForSend();
			local hasText = editBox:GetText()
			if editBox:HasFocus() then
				editBox:SetText("/WHISPER " ..wjName.." ".. hasText);
			else
				ChatEdit_ActivateChat(editBox)
				editBox:SetText("/WHISPER " ..wjName.." ".. hasText);
			end
		end)
		liebiao.Weizhi = PIGFontString(liebiao,{"LEFT", liebiao, "LEFT", biaotiName[4][2], 0});
		liebiao.Weizhi:SetJustifyH("LEFT");

		liebiao.autoinv = PIGFontString(liebiao,{"LEFT", liebiao, "LEFT", biaotiName[5][2], 0});
		liebiao.autoinv:SetJustifyH("LEFT");

		liebiao.miyu = PIGButton(liebiao, {"LEFT", liebiao, "LEFT", biaotiName[6][2], 0},{86,18});
		PIGSetFont(liebiao.miyu.Text,12)
		liebiao.miyu:HookScript("OnEnter", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		liebiao.miyu:HookScript("OnLeave", function (self)
			self:GetParent():SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		liebiao.miyu:SetScript("OnClick", function(self)
			local wjName = self.wjName
			if self:GetText()==L["CHAT_WHISPER"] then
				local editBox = ChatEdit_ChooseBoxForSend();
				local hasText = editBox:GetText()
				if not editBox:HasFocus() then
					ChatEdit_ActivateChat(editBox)
				end
				editBox:SetText("/WHISPER " ..wjName.." "..hasText.."方便的话组我换个"..L["TARDIS_PLANE"].."，谢谢");
			elseif self:GetText()=="请求换"..L["TARDIS_PLANE"] then
				PIGSendAddonMessage(InvF.Biaotou,shenqingMSG,"WHISPER",wjName)
			end
			fujiF.JieshouInfoList[self:GetID()][3]=true
			fujiF.Update_hang()
		end)
	end
	----
	local zhuchengmapid = {}
	if PIG_MaxTocversion() then
		zhuchengmapid = {
			1454,--奥格
			-- 1456,--雷霆崖
			-- 1458,--幽暗城
			-- 1954,--银月城
			1453,--暴风城
			-- 1455,--铁炉堡
			-- 1457,--达纳苏斯
			-- 1947,--埃索达
			-- 125,--达拉然
			-- 126,--达拉然
		}
	else
		zhuchengmapid = {
			85,--奥格
			-- 88,--雷霆崖
			-- --1458,--幽暗城
			-- 110,--银月城
			84,--暴风城
			-- 87,--铁炉堡
			-- 89,--达纳苏斯
			-- 103,--埃索达
			-- 125,--达拉然
			-- 126,--达拉然
			-- 111,--沙塔斯
		}
	end
	local function IsMapIDzhucheng(MapID)
		for i=1,#zhuchengmapid do
			if MapID==zhuchengmapid[i] then
				return true
			end
		end
		return false
	end
	local function IsZoneIDRepeat(olddata,zoneID)
		for i=1,#olddata do
			if zoneID==olddata[i] then
				return true
			end
		end
		return false
	end
	local function updateInfoList(oldData, newIds)
	    local now = GetServerTime()
	    local halfHourAgo = now - 21600
	    local dataDict = {}
	    for _, entry in ipairs(oldData) do
	        local id = entry[1]
	        local time = entry[2]
	        dataDict[id] = time
	    end
	    for _, id in ipairs(newIds) do
	        dataDict[id] = now 
	    end
	    local newSet = {} 
	    for _, id in ipairs(newIds) do
	        newSet[id] = true
	    end
	    local result = {}
	    for id, time in pairs(dataDict) do
	        if newSet[id] then
	            table.insert(result, {id, time})
	        else
	            if time > halfHourAgo then
	                table.insert(result, {id, time})
	            end
	        end
	    end
	    table.sort(result, function(a, b)
	        return a[1] < b[1]
	    end)
	    return result
	end
	local function paixuxiaoda(element1, elemnet2)
	    return element1 < elemnet2
	end
	local function findExactOrClosest(idList, target)
	    if next(idList) == nil then 
	        return "≈", 0 
	    end
	    local closestIndex = 1
	    local minDiff = math.abs(idList[1] - target)
	    for i, id in ipairs(idList) do
	        if id == target then
	            return "", i
	        end
	        local diff = math.abs(id - target)
	        if diff < minDiff then
	            minDiff = diff
	            closestIndex = i
	        end
	    end
	    return "≈", closestIndex
	end
	function fujiF.filtrateData()
		fujiF.New_ZhuCzoneID = {};
		fujiF.New_WMindexID = {};
		for i=#PIGA["Tardis"]["Plane"]["InfoList"][PIG_OptionsUI.Realm],1,-1 do
			if type(PIGA["Tardis"]["Plane"]["InfoList"][PIG_OptionsUI.Realm][i][1])=="string" then
				table.remove(PIGA["Tardis"]["Plane"]["InfoList"][PIG_OptionsUI.Realm],i)
			end
		end
		local dqTime=GetServerTime()
		local PlanesNum = #fujiF.JieshouInfoList;
		if PlanesNum>0 then
			--提取奥格/暴风区域ID
			for i=1,PlanesNum do
				local zoneID, MapID = strsplit("^", fujiF.JieshouInfoList[i][1]);
				local zoneID, MapID = tonumber(zoneID), tonumber(MapID)
				if IsMapIDzhucheng(MapID) and not IsZoneIDRepeat(fujiF.New_ZhuCzoneID,zoneID) then
					table.insert(fujiF.New_ZhuCzoneID,zoneID)
				end
			end
			if #fujiF.New_ZhuCzoneID>0 then
				PIGA["Tardis"]["Plane"]["InfoList"][PIG_OptionsUI.Realm]=updateInfoList(PIGA["Tardis"]["Plane"]["InfoList"][PIG_OptionsUI.Realm], fujiF.New_ZhuCzoneID)
			end
		end
		--刷新存储的位面序列
		for i=1,#PIGA["Tardis"]["Plane"]["InfoList"][PIG_OptionsUI.Realm] do
			table.insert(fujiF.New_WMindexID,PIGA["Tardis"]["Plane"]["InfoList"][PIG_OptionsUI.Realm][i][1])
		end
		fujiF.GetBut.err:SetText("");
		local ZJExactly,ZJDQlayerID = findExactOrClosest(fujiF.New_WMindexID, fujiF.DQZoneID)
		fujiF.ZJPlaneID:SetText(ZJExactly..ZJDQlayerID)
		fujiF.NewZJPlaneID=ZJDQlayerID
	end
	function fujiF.Update_hang()
		fujiF.GetBut.jindutishi:SetText("上次获取:刚刚");
		for i = 1, hang_NUM do
			fujiF.nr.ButList[i]:Hide()	
		end
		local ItemsData = fujiF.JieshouInfoList;
		local PlanesNum = #ItemsData;
		if PlanesNum>0 then
			local ZJAutoInviteChecked = fujiF.AutoInvite:GetChecked()
		    FauxScrollFrame_Update(fujiF.nr.Scroll, PlanesNum, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(fujiF.nr.Scroll);
		    for i = 1, hang_NUM do
		    	local dangqian = i+offset;
		    	if ItemsData[dangqian] then
					local fujikk = fujiF.nr.ButList[i]	
					fujikk:Show()
					fujikk.Name.T:SetText(ItemsData[dangqian][2]);
					local zoneID, MapID, RestState, autoinv = strsplit("^", ItemsData[dangqian][1]);
					fujikk.zoneID:SetText(zoneID);
					local weizhi = C_Map.GetMapInfo(MapID).name
					fujikk.Weizhi:SetText(weizhi);
				    local Exactly,DQlayerID = findExactOrClosest(fujiF.New_WMindexID, tonumber(zoneID))
					fujikk.Weimian:SetText(Exactly..DQlayerID);
					fujikk.miyu:SetID(dangqian)
					fujikk.miyu.wjName=ItemsData[dangqian][2]		
					if autoinv=="Y" then
						fujikk.autoinv:SetText(YES)
					else
						fujikk.autoinv:SetText(NO);
					end
					fujikk.Weizhi:SetTextColor(0.5,0.5,0.5, 0.1);
					fujikk.zoneID:SetTextColor(0.5,0.5,0.5, 0.8);
					if ItemsData[dangqian][3] then
						fujikk.miyu:Disable()
						fujikk.miyu:SetText("已发送请求");
						fujikk.Weimian:SetTextColor(0.5,0.5,0.5, 0.9);
						fujikk.Name.T:SetTextColor(0.5,0.5,0.5, 0.9);
						fujikk.autoinv:SetTextColor(0.5,0.5,0.5, 0.9);
					else
						fujikk.Weimian:SetTextColor(1,0.1,0.1, 1);
						fujikk.Name.T:SetTextColor(0,0.98,0.6, 1);
						if autoinv=="Y" then
							fujikk.autoinv:SetTextColor(0, 1, 0, 0.9);
						else
							fujikk.autoinv:SetTextColor(1, 0, 0, 0.9);
						end
						if DQlayerID==fujiF.NewZJPlaneID then
							fujikk.miyu:Disable()
							fujikk.miyu:SetText("同"..L["TARDIS_PLANE"]);
						else
							fujikk.miyu:Enable()
							if autoinv=="Y" and ZJAutoInviteChecked then
								fujikk.miyu:SetText("请求换"..L["TARDIS_PLANE"]);
							else
								fujikk.miyu:SetText(L["CHAT_WHISPER"]);
							end
						end
					end
				end
			end
		else
			fujiF.GetBut.err:SetText("未获取到"..L["TARDIS_PLANE"].."信息，请稍后再试!");
		end
	end
	-----
	fujiF:HookScript("OnShow", function(self)
		self.AutoInvite:SetChecked(PIGA["Tardis"]["Plane"]["AutoInvite"]);
		self.AutoInvite.HelpNum:SetText(PIGA["Tardis"]["Plane"]["HelpNum"])
		self:UpdateZoneID()
	end);
	function fujiF:UpdateZoneID()
		if self.DQZoneID and self:IsShown() then
			self.ZJZoneID:SetText(self.DQZoneID);
			self.filtrateData()
		end
	end
	-------
	function fujiF:GetWeimianID()
		if UnitIsPlayer("target") then return end
		local inInstance =IsInInstance()
		if inInstance then return end
		local mubiaoGUID=UnitGUID("target")
		if mubiaoGUID then
			local unitType, _, serverID, instanceID, zoneID, npcID = strsplit("-", mubiaoGUID);
			if zoneID and unitType=="Creature" then
				self.DQZoneID=tonumber(zoneID)
				self:UpdateZoneID()
				local MapID=C_Map.GetBestMapForUnit("player")
				if MapID then
					self.WeimianInfo=self.DQZoneID.."^"..MapID
					if IsMapIDzhucheng(MapID) then
						local oldinfo = PIGA["Tardis"]["Plane"]["InfoList"][PIG_OptionsUI.Realm]
						for x=1,#oldinfo do
							if self.DQZoneID==oldinfo[x][1] then
								return
							end
						end
						table.insert(oldinfo,{self.DQZoneID,GetServerTime()})
					end
				end
			end
		end
	end
	---------
	local function IsRestingInGroup()
		if not IsResting() then return false end
		if IsInInstance() then return false end
		if IsInGroup(LE_PARTY_CATEGORY_HOME) then return false end
		local isActive = C_LFGList and C_LFGList.HasActiveEntryInfo();
		if ( isActive ) then
			if C_LFGList.GetActiveEntryInfo() then return false end
		end
		for i=1, NUM_LE_LFG_CATEGORYS do
			local mode, submode = GetLFGMode(i);
			if ( mode and submode ~= "noteleport" ) then
				return false
			end
		end
		if PIG_MaxTocversion() then
			for i=1, GetMaxBattlefieldID() do
				local status, mapName= GetBattlefieldStatus(i);
				if ( status and status ~= "none" ) then
					return false
				end
			end
		else
			if QueueStatusButton and QueueStatusButton:IsShown() then return false end
		end
		return true
	end
	local function fasongBendiMsg(self,waname)
		if not self.WeimianInfo then return end
		if waname == PIG_OptionsUI.Name or waname == PIG_OptionsUI.AllName then return end
		if IsRestingInGroup() then
			local kaiguanzhuangtai="Y^"
			if PIGA["Tardis"]["Plane"]["AutoInvite"] then
				kaiguanzhuangtai=kaiguanzhuangtai.."Y"
			else
				kaiguanzhuangtai=kaiguanzhuangtai.."N"
			end
			local SMessage="!L"..self.WeimianInfo.."^"..kaiguanzhuangtai
			PIGSendAddonMessage(InvF.Biaotou,SMessage,"WHISPER",waname)
		end
	end
	if PIG_MaxTocversion() then
		fujiF:RegisterEvent("CHAT_MSG_CHANNEL");
	end
	fujiF:RegisterEvent("CHAT_MSG_ADDON");
	fujiF:RegisterEvent("PLAYER_TARGET_CHANGED"); 
	fujiF:RegisterEvent("PLAYER_ENTERING_WORLD");   
	fujiF:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5,_,_,_,arg9)
		--print(event, arg1, arg2, arg3, arg4, arg5,_,_,_,arg9)
		if event=="PLAYER_ENTERING_WORLD" then
			PIGA["Tardis"]["Plane"]["InfoList"][PIG_OptionsUI.Realm]=PIGA["Tardis"]["Plane"]["InfoList"][PIG_OptionsUI.Realm] or {}
			self:GetWeimianID()
		elseif event=="PLAYER_TARGET_CHANGED" then
			self:GetWeimianID()
		elseif event=="CHAT_MSG_CHANNEL" then
			if arg1==GetInfoMsg and arg9==pindao then
				fasongBendiMsg(self,arg5)
			end
		elseif event=="CHAT_MSG_ADDON" and arg1 == InvF.Biaotou then
			if arg2==GetInfoMsg and arg3=="CHANNEL" then
				fasongBendiMsg(self,arg4)
			elseif arg3 == "WHISPER" then
				local newqianzhui = arg2:sub(1,2)
				if newqianzhui==qianzhui then
					if arg2:match(shenqingMSG_T) then
						if PIGA["Tardis"]["Plane"]["AutoInvite"] then
							if IsRestingInGroup() then
								local Nerarg2 = arg2:gsub(shenqingMSG_T,"")
								if tonumber(Nerarg2)<shenqingMSG_V then
									SendChatMessage(INVITE..FAILED..","..PET_BATTLE_COMBAT_LOG_YOUR..addonName..GAME_VERSION_LABEL..ADDON_INTERFACE_VERSION, "WHISPER", nil, arg5);
								else
									PIG_InviteUnit(arg5)
									PIGA["Tardis"]["Plane"]["HelpNum"]=PIGA["Tardis"]["Plane"]["HelpNum"]+1
									PIG_OptionsUI:ErrorMsg("功德+"..PIGA["Tardis"]["Plane"]["HelpNum"])
								end
							end
						end
					else
						local houzhui = arg2:sub(3,-1)
						table.insert(fujiF.JieshouInfoList, {houzhui,arg5})
						if fujiF.GetBut.yanchiNerMsg==false then
							fujiF.GetBut:NewMsgadd()
						end
					end
				end
			end
		end
	end)
end