local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create, Data, Fun, L= unpack(PIG)
local sub = _G.string.sub 
---------------------------
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGButton = Create.PIGButton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont
-----------------
local TardisInfo=addonTable.TardisInfo
local xuanzhongBG = {{0.2, 0.2, 0.2, 0.2},{0.4, 0.8, 0.8, 0.2}}
function TardisInfo.Plane(Activate)
	if not PIGA["Tardis"]["Plane"]["Open"] then return end
	local InviteUnit=InviteUnit or C_PartyInfo and C_PartyInfo.InviteUnit
	local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
	local GetPIGID=Fun.GetPIGID
	local disp_time=Fun.disp_time
	local Biaotou=Data.Tardis[1][1]
	local GetInfoMsg=Data.Tardis[2][3]
	local shenqingMSG_T = "!LSQHWM_";
	local shenqingMSG_V = 6.57;
	local shenqingMSG = shenqingMSG_T..shenqingMSG_V;
	C_ChatInfo.RegisterAddonMessagePrefix(Biaotou)
	-----
	local InvF=_G[GnUI]
	local pindao=InvF.pindao
	local hang_Height,hang_NUM=InvF.hang_Height,InvF.hang_NUM
	local fujiF,fujiTabBut=PIGOptionsList_R(InvF.F,L["TARDIS_PLANE"],80,"Bot")
	if Activate then
		fujiF:Show()
		fujiTabBut:Selected()
	end
	-----------------
	fujiF.zijiweimian = PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-8},"你的区域ID:");
	fujiF.zijiweimian:SetTextColor(0, 0.98, 0.6, 1);
	fujiF.ZJweimianID = PIGFontString(fujiF,{"LEFT", fujiF.zijiweimian, "RIGHT", 0, 0},"点击NPC获取");
	fujiF.ZJweimianID:SetTextColor(1, 1, 1, 1);
	-----
	fujiF.JieshouInfoList={};
	fujiF.GetBut=TardisInfo.GetInfoBut(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",180,-30},300,2)
	fujiF.GetBut:HookScript("OnClick", function (self)
		if fujiF.ZJweimianID:GetText()=="点击NPC获取" then
			self.err:SetText("请点击任意NPC");
			return 
		end
		self.PIGID=GetPIGID(pindao)
		if self.PIGID==0 then
			self.err:SetText("请先加入"..pindao.."频道");
			return
		end
		if tocversion<40000 then
			SendChatMessage(GetInfoMsg,"CHANNEL",nil,self.PIGID)
		else
			C_ChatInfo.SendAddonMessage(Biaotou,GetInfoMsg,"CHANNEL",self.PIGID)
		end
		self:CZdaojishi()
		PIGA["Tardis"]["Plane"]["DaojishiCD"]=GetServerTime();
		fujiF.JieshouInfoList={};
	end);
	fujiF.GetBut.daojishiJG=PIGA["Tardis"]["Plane"]["DaojishiCD"]
	function fujiF.GetBut.gengxin_hang()
		fujiF.gengxinhang(fujiF.nr.Scroll)
	end
	-------------------------
	local Tooltip1= "|cffFFFF00当双方都打开此选项时可以直接申请组队，如只有一方打开则只能"..L["CHAT_WHISPER"].."申请对方组队|r";
	local Tooltip2 = "\n|cffFF0000关闭后其他玩家将不会自动接收你的申请\n(注意你在24小时内只能开关一次)|r"
	local Tooltip = Tooltip1..Tooltip2
	fujiF.AutoInvite =PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",420,-10},{"|cff00FF00自动接受"..L["TARDIS_PLANE"].."申请(只在主城生效)|r",Tooltip})
	fujiF.AutoInvite.help = PIGFontString(fujiF.AutoInvite,{"TOPLEFT", fujiF.AutoInvite, "BOTTOMLEFT", 20, -4},"我为人人，人人为我。请不要做精致的利己主义者");
	fujiF.AutoInvite.help:SetTextColor(0, 1, 1, 1);
	fujiF.AutoInvite:SetScript("OnClick", function (self)
		if self:GetChecked() then
			local DaojishiCD = PIGA["Tardis"]["Plane"]["AutoInviteCD"]
			local shengyu = 86400-(GetServerTime()-DaojishiCD)
			if shengyu>0 then
				PIGinfotip:TryDisplayMessage(L["TARDIS_PLANE"].."通道充能中...(剩余"..disp_time(shengyu).."分)",1,0,0)
				self:SetChecked(false)
				return 
			end
			PIGA["Tardis"]["Plane"]["AutoInvite"]=true;
		else
			StaticPopup_Show("OPEN_WEIMIANSHENQING");
		end
	end);
	fujiF.AutoInvite:SetChecked(PIGA["Tardis"]["Plane"]["AutoInvite"]);

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
	fujiF.AutoInvite.HelpTXT = PIGFontString(fujiF.AutoInvite,{"LEFT", fujiF.AutoInvite.Text, "RIGHT", 40, 0},"助人为乐+");
	fujiF.AutoInvite.HelpNum = PIGFontString(fujiF.AutoInvite,{"LEFT", fujiF.AutoInvite.HelpTXT, "RIGHT", 2, 0},0);
	fujiF.AutoInvite.HelpNum:SetTextColor(0, 1, 0, 1);
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
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fujiF.gengxinhang)
	end)
	for i=1, hang_NUM, 1 do
		local liebiao = CreateFrame("Frame", "WeimianList_"..i, fujiF.nr.Scroll:GetParent(),"BackdropTemplate");
		liebiao:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
		liebiao:SetBackdropColor(unpack(xuanzhongBG[1]));
		liebiao:SetSize(hang_Width-4,hang_Height);
		if i==1 then
			liebiao:SetPoint("TOPLEFT", fujiF.nr.Scroll, "TOPLEFT", 0, 0);
		else
			liebiao:SetPoint("TOPLEFT", _G["WeimianList_"..(i-1)], "BOTTOMLEFT", 0, -1.2);
		end
		liebiao:Hide()
		liebiao:HookScript("OnEnter", function (self)
			self:SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		liebiao:HookScript("OnLeave", function (self)
			self:SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
		liebiao.Weimian = PIGFontString(liebiao,{"LEFT", liebiao, "LEFT",biaotiName[1][2], 0});
		liebiao.Weimian:SetTextColor(0,0.98,0.6, 1);
		liebiao.zoneID = PIGFontString(liebiao,{"LEFT", liebiao, "LEFT", biaotiName[2][2], 0});
		liebiao.zoneID:SetTextColor(0.9,0.9,0.9, 0.9);
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
		liebiao.Weizhi:SetTextColor(0.6,0.6,0.6, 0.1);
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
				if editBox:HasFocus() then
					editBox:SetText("/WHISPER " ..wjName.." "..hasText.."方便的话组我换个"..L["TARDIS_PLANE"].."，谢谢");
				else
					ChatEdit_ActivateChat(editBox)
					editBox:SetText("/WHISPER " ..wjName.." "..hasText.."方便的话组我换个"..L["TARDIS_PLANE"].."，谢谢");
				end
			elseif self:GetText()=="请求换"..L["TARDIS_PLANE"] then
				--SendChatMessage("方便的话组我换个"..L["TARDIS_PLANE"].."，谢谢", "WHISPER", nil, wjName);
				C_ChatInfo.SendAddonMessage(Biaotou,shenqingMSG,"WHISPER",wjName)
			end
			fujiF.JieshouInfoList[self:GetID()][3]=true
			fujiF.gengxinhang(fujiF.nr.Scroll)
		end)
	end
	-----
	local function panduanweimianID(weimianbianhao,zoneID)
		local zuixiaozhiweimian={nil,"?"}
		for x=1,#weimianbianhao do	
			local ChazhiV=0
			local ChazhiV=zoneID-weimianbianhao[x]
			if ChazhiV<0 then
				ChazhiV=weimianbianhao[x]-zoneID
			end
			if ChazhiV<100 then
				if zuixiaozhiweimian[1] then
					if ChazhiV<zuixiaozhiweimian[1] then
						zuixiaozhiweimian[1]=ChazhiV
						zuixiaozhiweimian[2]=x
						return zuixiaozhiweimian[2]
					end
				else
			    	zuixiaozhiweimian[1]=ChazhiV
			    	zuixiaozhiweimian[2]=x
			    	return zuixiaozhiweimian[2]
			    end
			end
	    end
	    return zuixiaozhiweimian[2]
	end
	local zhuchengmapid = {}
	if tocversion<40000 then
		zhuchengmapid = {
			1454,--奥格
			1456,--雷霆崖
			1458,--幽暗城
			1954,--银月城
			1453,--暴风城
			1455,--铁炉堡
			1457,--达纳苏斯
			1947,--埃索达
			125,--达拉然
			126,--达拉然
		}
	else
		zhuchengmapid = {
			85,--奥格
			88,--雷霆崖
			--1458,--幽暗城
			110,--银月城
			84,--暴风城
			87,--铁炉堡
			89,--达纳苏斯
			103,--埃索达
			125,--达拉然
			126,--达拉然
			111,--沙塔斯
		}
	end
	local function panduanISzhucheng(MapID)
		for i=1,#zhuchengmapid do
			if tonumber(MapID)==zhuchengmapid[i] then
				return true
			end
		end
		return false
	end
	local function paixuxiaoda(element1, elemnet2)
	    return element1 < elemnet2
	end
	------------
	function fujiF.gengxinhang(self)
		fujiF.GetBut.jindutishi:SetText("上次获取:刚刚");
		for i = 1, hang_NUM do
			_G["WeimianList_"..i]:Hide()	
		end
		local dqTime=GetServerTime()
		local ItemsNum = #fujiF.JieshouInfoList;
		if ItemsNum>0 then
			fujiF.GetBut.err:SetText("");
			local oldshuju = PIGA["Tardis"]["Plane"]["InfoList"][Pig_OptionsUI.Realm]
			for x=#oldshuju,1,-1 do
				if oldshuju[x] then
					if oldshuju[x][2] then
						local libaiji=date("%w",dqTime)
						local yiguoquTime=dqTime-oldshuju[x][2]
						if yiguoquTime and yiguoquTime>604800 then
							table.remove(oldshuju,x);
						else
							if libaiji=="4" then
								if yiguoquTime>86400 then
									table.remove(oldshuju,x);
								end
							elseif libaiji=="5" then
								if yiguoquTime>172800 then
									table.remove(oldshuju,x);
								end
							elseif libaiji=="6" then
								if yiguoquTime>259200 then
									table.remove(oldshuju,x);
								end
							elseif libaiji=="7" then
								if yiguoquTime>345600 then
									table.remove(oldshuju,x);
								end
							elseif libaiji=="1" then
								if yiguoquTime>432000 then
									table.remove(oldshuju,x);
								end
							elseif libaiji=="2" then
								if yiguoquTime>518400 then
									table.remove(oldshuju,x);
								end
							-- elseif libaiji=="3" then
							-- 	if yiguoquTime>604800 then
							-- 		table.remove(oldshuju,x);
							-- 	end
							end
						end
					end
				end
			end
			local New_InfoList = {};
			for x=1,ItemsNum do
				local zoneID, MapID = strsplit("^", fujiF.JieshouInfoList[x][1]);
				if panduanISzhucheng(MapID) then
					table.insert(New_InfoList,fujiF.JieshouInfoList[x])
				end
				local MapIDx=C_Map.GetBestMapForUnit("player")
				if tonumber(MapID)==1453 or tonumber(MapID)==1454 then
					local PIG_WB_inshipaixu_you=true
					for xx=1,#oldshuju do
						if zoneID==oldshuju[xx][1] then
							PIG_WB_inshipaixu_you=false
							break
						end
					end
					if PIG_WB_inshipaixu_you then
						table.insert(oldshuju,{zoneID,dqTime})
					end
				end
			end

			---
			local weimianbianhao={}
			for x=1,#oldshuju do
				table.insert(weimianbianhao,tonumber(oldshuju[x][1]))
			end
			table.sort(weimianbianhao, paixuxiaoda)
			local ZJweimianjeishou = fujiF.AutoInvite:GetChecked()
		    local ZJweimianID = panduanweimianID(weimianbianhao,tonumber(fujiF.DQweimianID))

		    FauxScrollFrame_Update(self, #New_InfoList, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(self);
		    for i = 1, hang_NUM do
		    	local dangqian = i+offset;
		    	if New_InfoList[dangqian] then
					local fujikk = _G["WeimianList_"..i]	
					fujikk:Show()
					fujikk.Name.T:SetText(New_InfoList[dangqian][2]);
					local zoneID, MapID, RestState, autoinv = strsplit("^", New_InfoList[dangqian][1]);
					fujikk.zoneID:SetText(zoneID);
					local weizhi = C_Map.GetMapInfo(MapID).name
					fujikk.Weizhi:SetText(weizhi);
					--
				    local weimianID = panduanweimianID(weimianbianhao,tonumber(zoneID))
					fujikk.Weimian:SetText(weimianID);
					fujikk.miyu:SetID(dangqian)
					fujikk.miyu.wjName=New_InfoList[dangqian][2]
					-- fujikk.miyu:Show()
					-- fujikk.Weimian:SetTextColor(0,0.98,0.6, 1);
					-- fujikk.Name.T:SetTextColor(0,0.98,0.6, 1);
					-- fujikk.autoinv:SetTextColor(0,0.98,0.6, 1);
					if autoinv=="Y" then
						fujikk.autoinv:SetText("|cff00FF00"..YES.."|r")
					else
						fujikk.autoinv:SetText("|cffFF0000"..NO.."|r");
					end
					if New_InfoList[dangqian][3] then
						fujikk.miyu:Disable()
						fujikk.miyu:SetText("已发送请求");
					else
						if weimianID~="?" and weimianID==ZJweimianID then
							fujikk.miyu:Disable()
							fujikk.miyu:SetText("同"..L["TARDIS_PLANE"]);
						else
							fujikk.miyu:Enable()
							if autoinv=="Y" and ZJweimianjeishou then
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
		self.AutoInvite.HelpNum:SetText(PIGA["Tardis"]["Plane"]["HelpNum"])
		if self.DQweimianID then
			self.ZJweimianID:SetText(self.DQweimianID);
		else
			self.ZJweimianID:SetText("点击NPC获取");
		end
	end);
	-------
	local function GetWeimianID(self)
		if UnitIsPlayer("target") then return end
		local inInstance =IsInInstance()
		if inInstance then return end
		local mubiaoGUID=UnitGUID("target")
		if mubiaoGUID then
			local unitType, _, serverID, instanceID, zoneID, npcID = strsplit("-", mubiaoGUID);
			if zoneID then
				self.DQweimianID=zoneID
				if self:IsShown() then
					self.ZJweimianID:SetText(zoneID);
					fujiF.GetBut.err:SetText("");
				end
				local MapID=C_Map.GetBestMapForUnit("player")
				if MapID then
					self.WeimianInfo=zoneID.."^"..MapID
					if MapID==1453 or MapID==1454 then
						local oldinfo = PIGA["Tardis"]["Plane"]["InfoList"][Pig_OptionsUI.Realm]
						for x=1,#oldinfo do
							if zoneID==oldinfo[x][1] then
								return
							end
						end
						table.insert(oldinfo,{zoneID,GetServerTime()})
					end
				end
			end
		end
	end
	---------
	local function fasongBendiMsg(self,waname)
		if waname == Pig_OptionsUI.Name or waname == Pig_OptionsUI.AllName then return end
		if not self.WeimianInfo then return end
		local inInstance=IsInInstance()
		if inInstance then return end
		local kaiguanzhuangtai = ""
		local exhaustionID = GetRestState()
		if exhaustionID==1 then--休息
			kaiguanzhuangtai=kaiguanzhuangtai.."Y^"
		elseif exhaustionID==2 then
			kaiguanzhuangtai=kaiguanzhuangtai.."N^"
		end
		if PIGA["Tardis"]["Plane"]["AutoInvite"] then
			kaiguanzhuangtai=kaiguanzhuangtai.."Y"
		else
			kaiguanzhuangtai=kaiguanzhuangtai.."N"
		end
		local SMessage="!L"..self.WeimianInfo.."^"..kaiguanzhuangtai
		C_ChatInfo.SendAddonMessage(Biaotou,SMessage,"WHISPER",waname)
	end
	fujiF:RegisterEvent("CHAT_MSG_CHANNEL");
	fujiF:RegisterEvent("CHAT_MSG_ADDON");
	fujiF:RegisterEvent("PLAYER_TARGET_CHANGED"); 
	fujiF:RegisterEvent("PLAYER_ENTERING_WORLD");   
	fujiF:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5,_,_,_,arg9)
		if event=="PLAYER_ENTERING_WORLD" then
			PIGA["Tardis"]["Plane"]["InfoList"][Pig_OptionsUI.Realm]=PIGA["Tardis"]["Plane"]["InfoList"][Pig_OptionsUI.Realm] or {}
			GetWeimianID(self)
		end
		if event=="PLAYER_TARGET_CHANGED" then
			GetWeimianID(self)
		end
		if event=="CHAT_MSG_CHANNEL" then
			if arg1==GetInfoMsg and arg9==pindao then
				local waname = arg2
				if tocversion<20000 then
					waname = arg5
				end
				fasongBendiMsg(self,waname)
			end
		end
		if event=="CHAT_MSG_ADDON" and arg1 == Biaotou then
			if arg2==GetInfoMsg and arg3=="CHANNEL" then
				fasongBendiMsg(self,arg4)
			elseif arg3 == "WHISPER" then
				local qianzhui = arg2:sub(1,2)
				if qianzhui=="!L" then
					local waname = arg4
					if tocversion<20000 then
						waname = arg5
					end
					if arg2:match(shenqingMSG_T) then
						if PIGA["Tardis"]["Plane"]["AutoInvite"] then
							local inInstance, instanceType =IsInInstance()
							local zuduizhong =IsInGroup(LE_PARTY_CATEGORY_HOME);
							if not inInstance and not zuduizhong and not MiniMapLFGFrame:IsShown() then
								local Nerarg2 = arg2:gsub(shenqingMSG_T,"")
								if tonumber(Nerarg2)<shenqingMSG_V then
									SendChatMessage(INVITE..FAILED..","..addonName..GAME_VERSION_LABEL..ADDON_INTERFACE_VERSION, "WHISPER", nil, waname);
								else
									InviteUnit(waname)
									PIGA["Tardis"]["Plane"]["HelpNum"]=PIGA["Tardis"]["Plane"]["HelpNum"]+1
									PIGinfotip:TryDisplayMessage("助人为乐+"..PIGA["Tardis"]["Plane"]["HelpNum"])
								end
							end
						end
					else
						local houzhui = arg2:sub(3,-1)
						table.insert(fujiF.JieshouInfoList, {houzhui,waname})
					end
				end
			end
		end
	end)
end