local addonName, addonTable = ...;
local TardisInfo=addonTable.TardisInfo
function TardisInfo.Farm(Activate)
	if not PIGA["Tardis"]["Farm"]["Open"] then return end
	local Create, Data, Fun, L= unpack(PIG)
	local PIGFrame=Create.PIGFrame
	local PIGEnter=Create.PIGEnter
	local PIGLine=Create.PIGLine
	local PIGButton = Create.PIGButton
	local PIGDiyTex = Create.PIGDiyTex
	local PIGOptionsList_R=Create.PIGOptionsList_R
	local PIGFontString=Create.PIGFontString
	local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
	local InvF=_G[GnUI]
	local pindao,hang_Height,hang_NUM,xuanzhongBG=InvF.pindao,InvF.hang_Height,InvF.hang_NUM,InvF.xuanzhongBG
	local GetPIGID=Fun.GetPIGID
	local gnindexID=3
	local GetInfoMsg=Data.Tardis.GetMsg[gnindexID]
	local shenqingMSG_T = Data.Tardis.SqMsg[gnindexID]
	local shenqingMSG_V = Data.Tardis.ver[gnindexID]
	local qianzhui=Data.Tardis.qianzhui[gnindexID]
	local shenqingMSG = shenqingMSG_T..shenqingMSG_V;
	local tihuankuohao=Fun.tihuankuohao
	----
	local fujiF,fujiTabBut=PIGOptionsList_R(InvF.F,L["TARDIS_FARM"],80,"Bot")
	if Activate then fujiF:Show() fujiTabBut:Selected() end
	----------------------------------
	fujiF.JieshouInfoList={};
	fujiF.yishenqingList={}
	fujiF.GetBut=TardisInfo.GetInfoBut(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",180,-30},30,2)
	fujiF.GetBut.ButName=L["TARDIS_FARM"]
	fujiF.GetBut:HookScript("OnClick", function (self)
		if self.yanchiNerMsg then
			self.Highlight:Hide()
			self.yanchiNerMsg=false
			fujiF.filtrateData()
			fujiF.Update_hang()
			self:daojishiCDFUN()
		else
			InvF:PIGSendAddonMsg("Farm",fujiF,gnindexID)
			self:CZdaojishi()
		end
	end);
	fujiF.GetBut.daojishiJG=PIGA["Tardis"]["Farm"]["DaojishiCD"]
	function fujiF.GetBut.Update_DataHang()
		fujiF.GetBut.yanchiNerMsg=false	
		fujiF.filtrateData()
		fujiF.Update_hang()
	end
	-------------
	fujiF.nr=PIGFrame(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",4,-60})
	fujiF.nr:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", -4, 4);
	fujiF.nr:PIGSetBackdrop()
	local biaotiName={{"",0},{"LV",6},{"目的地",40},{"司机",240},{"乘客",360},{"详情",460},{"操作",800}}
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
	fujiF.ButList={}
	local function hang_EnterLeave(hangui,setui)
		hangui:HookScript("OnEnter", function ()
			setui:SetBackdropColor(unpack(xuanzhongBG[2]));
		end);
		hangui:HookScript("OnLeave", function ()
			setui:SetBackdropColor(unpack(xuanzhongBG[1]));
		end);
	end
	for i=1, hang_NUM, 1 do
		local hangui = CreateFrame("Frame", nil, fujiF.nr,"BackdropTemplate");
		fujiF.ButList[i]=hangui
		hangui:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
		hangui:SetBackdropColor(unpack(xuanzhongBG[1]));
		hangui:SetSize(hang_Width-8,hang_Height);
		hang_EnterLeave(hangui,hangui)
		if i==1 then
			hangui:SetPoint("TOPLEFT", fujiF.nr.Scroll, "TOPLEFT", 0, 0);
		else
			hangui:SetPoint("TOPLEFT", fujiF.ButList[i-1], "BOTTOMLEFT", 0, -1.4);
		end
		hangui:Hide()
		hangui.Leixing = PIGFontString(hangui,{"LEFT", hangui, "LEFT", biaotiName[1][2], 0})
		hangui.LvMinMax = PIGFontString(hangui,{"LEFT", hangui, "LEFT", biaotiName[2][2]-4, 0})

		hangui.Mudidi = PIGFontString(hangui,{"LEFT", hangui, "LEFT", biaotiName[3][2], 0})
		hangui.Mudidi:SetSize(200,hang_Height);
		hangui.Mudidi:SetJustifyH("LEFT");
		
		hangui.Name = CreateFrame("Frame", nil, hangui);
		hangui.Name:SetSize(120,hang_Height);
		hangui.Name:SetPoint("LEFT", hangui, "LEFT", biaotiName[4][2], 0);
		hang_EnterLeave(hangui.Name,hangui)
		hangui.Name.T = PIGFontString(hangui.Name)
		hangui.Name.T:SetAllPoints(hangui.Name)
		hangui.Name.T:SetJustifyH("LEFT");
		hangui.Name:SetScript("OnMouseUp", function(self,button)
			local allname = self:GetParent().allname
			if button=="LeftButton" then
				local editBox = ChatEdit_ChooseBoxForSend();
				local hasText = editBox:GetText()
				if editBox:HasFocus() then
					editBox:SetText("/WHISPER " ..allname.." ".. hasText);
				else
					ChatEdit_ActivateChat(editBox)
					editBox:SetText("/WHISPER " ..allname.." ".. hasText);
				end
			elseif button=="RightButton" then
				Fun.FasongYCqingqiu(allname)
			end
		end)
		hangui.Chengke = CreateFrame("Frame", nil, hangui);
		hangui.Chengke:SetSize(hang_Height*4,hang_Height);
		hangui.Chengke:SetPoint("LEFT", hangui, "LEFT", biaotiName[5][2], 0);
		hangui.Chengke.T = PIGFontString(hangui.Chengke)
		hangui.Chengke.T:SetPoint("LEFT", hangui.Chengke, "LEFT", 0, 0);
		hangui.Chengke.Partybut={}
		for Partyi=1,4 do
			local Partybutton=PIGDiyTex(hangui.Chengke,nil,{hang_Height-2,hang_Height-2,hang_Height-1,hang_Height-1,"ArtifactsFX-YellowRing"}, nil, "BORDER")
			if Partyi==1 then
				Partybutton:SetPoint("LEFT", hangui.Chengke, "LEFT", 0, 0);
			else
				Partybutton:SetPoint("LEFT", hangui.Chengke.Partybut[Partyi-1], "RIGHT", 0, 0);
			end
			Partybutton.icon:SetAlpha(0.4)
			Partybutton.T = PIGFontString(Partybutton,{"CENTER", 1, 0.8},"","OUTLINE",nil,nil,"ARTWORK")
			hangui.Chengke.Partybut[Partyi]=Partybutton
		end
		hangui.info = CreateFrame("Frame", nil, hangui);
		hangui.info:SetSize(334,hang_Height);
		hangui.info:SetPoint("LEFT", hangui, "LEFT", biaotiName[6][2], 0);
		hang_EnterLeave(hangui.info,hangui)
		hangui.info.T = PIGFontString(hangui.info)
		hangui.info.T:SetTextColor(0,250/255,154/255, 1);
		hangui.info.T:SetAllPoints(hangui.info)
		hangui.info.T:SetJustifyH("LEFT");
		
		hangui.miyu = PIGButton(hangui,{"LEFT", hangui, "LEFT", biaotiName[7][2]-4, 0},{58,hang_Height-6},"")
		hangui.miyu.Text:SetFont(ChatFontNormal:GetFont(), 12);
		hang_EnterLeave(hangui.miyu,hangui)
		hangui.miyu:SetScript("OnClick", function(self)
			local allname = self:GetParent().allname
			local qingqiuleve = UnitLevel("player")
			if self:GetText()==WHISPER then
				local qingqiuMSG = "[!Pig] "..qingqiuleve.."级,申请上车";	
				SendChatMessage(qingqiuMSG, "WHISPER", nil, allname);
			elseif self:GetText()=="申请上车" then
				local qingqiuMSG = shenqingMSG.."#"..qingqiuleve;
				PIGSendAddonMessage(InvF.Biaotou,qingqiuMSG,"WHISPER", allname)	
			end
			fujiF.yishenqingList[allname]=true
			self:Disable()
			self:SetText("已发送");
		end)
	end
	---
	function fujiF.filtrateData()
		fujiF.New_InfoList = {};
		local ItemsNum = #fujiF.JieshouInfoList;
		if ItemsNum>0 then
			for x=1,ItemsNum do
				local class,Level,raceId,Auto_inv,fubenid,LVminmax,GroupLv,DanjiaTxt,NdataT = strsplit("^", fujiF.JieshouInfoList[x][1]);
				local min,max =  strsplit("#", LVminmax);
				local zuxinxi =  {strsplit("#", GroupLv)};
				local danjiaTT = ""
				if DanjiaTxt=="-" then
					danjiaTT="<0-0>0G,"
				else
					local danjiadata =  {strsplit("#", DanjiaTxt)};
					for k1,v1 in pairs(danjiadata) do
						local min,max,ggg =  strsplit("@", v1);
						danjiaTT=danjiaTT.."<"..min.."-"..max..">"..ggg.."G,"
					end
				end
				table.insert(fujiF.New_InfoList,{false,fujiF.JieshouInfoList[x][2],class,Level,raceId,Auto_inv,tonumber(fubenid),{tonumber(min),tonumber(max)},zuxinxi,danjiaTT,NdataT})
			end
		end
	end
	function fujiF.Update_hang()
		fujiF.GetBut.jindutishi:SetText("上次获取:刚刚");
		for i = 1, hang_NUM do
			local hangui = fujiF.ButList[i]
			hangui:Hide()	
			hangui.miyu:Disable()
			hangui.Chengke.T:Hide()
			for Partyi=1,4 do
				hangui.Chengke.Partybut[Partyi]:Hide()
			end
			hangui.info.T:SetText("你不满足司机设置的等级要求");
			hangui.miyu:SetText("条件不符");
		end
		local ItemsData = fujiF.New_InfoList;
		local ItemsNum = #ItemsData;
		if ItemsNum>0 then
			fujiF.GetBut.err:SetText("");
			local playerLV=UnitLevel("player")
		    FauxScrollFrame_Update(fujiF.nr.Scroll, ItemsNum, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(fujiF.nr.Scroll);
		    for i = 1, hang_NUM do
		    	local dangqian = i+offset;
		    	if ItemsData[dangqian] then
					local hangui = fujiF.ButList[i]
					hangui:Show()
					hangui.miyu:SetID(dangqian)
					hangui.allname=ItemsData[dangqian][2]
					hangui.LvMinMax:SetText(ItemsData[dangqian][8][1].."-"..ItemsData[dangqian][8][2]);
					local LevelOk = playerLV>=ItemsData[dangqian][8][1] and playerLV<=ItemsData[dangqian][8][2]
					if LevelOk then
						hangui.LvMinMax:SetTextColor(0, 1, 0, 0.9)
					else
						hangui.LvMinMax:SetTextColor(1, 0, 0, 1)
					end
					local WJname,WJserver= strsplit("-", ItemsData[dangqian][2]);
					if WJserver and WJserver~="" then
						hangui.Name.T:SetText(WJname.."(*)");
					else
						hangui.Name.T:SetText(ItemsData[dangqian][2]);
					end
					local _, classFilename=PIGGetClassInfo(ItemsData[dangqian][3])
					local rrr, yyy, bbb = GetClassColor(classFilename);
					hangui.Name.T:SetTextColor(rrr, yyy, bbb,1)
					if ItemsData[dangqian][7] then
						local activityInfo = C_LFGList.GetActivityInfoTable(ItemsData[dangqian][7]);
						hangui.Mudidi:SetText(activityInfo and activityInfo.fullName or NONE);
					end
					if LevelOk then
						local IsRaid,Party1,Party2,Party3,Party4 =  unpack(ItemsData[dangqian][9]);
						if IsRaid=="R" then
							hangui.Chengke.T:Show()
							hangui.Chengke.T:SetText(Party2.."/"..Party1)
							if tonumber(Party2)==tonumber(Party1) then
								hangui.Chengke.T:SetTextColor(1,0,0,1);
							else
								hangui.Chengke.T:SetTextColor(0,0.8,0,0.9);
							end
						else
							local party9 = {Party1,Party2,Party3,Party4}
							for Partyi=1,4 do
								hangui.Chengke.Partybut[Partyi]:Show()
								if party9[Partyi]=="-" then
									hangui.Chengke.Partybut[Partyi].icon:SetDesaturated(true)
									hangui.Chengke.Partybut[Partyi].T:SetTextColor(0.5,0.5,0.5,0.5);
									hangui.Chengke.Partybut[Partyi].T:SetText("")
								else
									hangui.Chengke.Partybut[Partyi].icon:SetDesaturated(false)
									hangui.Chengke.Partybut[Partyi].T:SetTextColor(0,0.8,0,0.8);
									hangui.Chengke.Partybut[Partyi].T:SetText(party9[Partyi])
								end
							end
						end
						hangui.info.T:SetText(ItemsData[dangqian][10]..ItemsData[dangqian][11]);
						PIGEnter(hangui.info,"详情","|cff00FF00车票价格:|r\n|cffFFFFFF"..ItemsData[dangqian][10].."|r\n|cff00FF00车队介绍:|r\n|cffFFFFFF"..ItemsData[dangqian][11].."|r")
						if fujiF.yishenqingList[ItemsData[dangqian][2]] then
							hangui.miyu:SetText("已发送");
						else
							if ItemsData[dangqian][2]==PIG_OptionsUI.Name then
								hangui.miyu:SetText("自己");
							else
								hangui.miyu:Enable()
								if ItemsData[dangqian][6]=="Y" then
									hangui.miyu:SetText("申请上车");
								else
									hangui.miyu:SetText(WHISPER);
								end
							end
						end
					end
				end
			end
		else
			fujiF.GetBut.err:SetText("未获取到"..L["TARDIS_FARM"].."信息，请稍后再试!");
		end
	end
	------
	fujiF:RegisterEvent("CHAT_MSG_ADDON");
	fujiF:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5,_,_,_,arg9)
		if event=="CHAT_MSG_ADDON" and arg1 == InvF.Biaotou and arg3 == "WHISPER" then
			local newqianzhui = arg2:sub(1,2)
			if newqianzhui==qianzhui then
				if arg2:match(shenqingMSG_T) then
				else
					table.insert(fujiF.JieshouInfoList, {arg2:sub(3,-1),arg5})
					if fujiF.GetBut.yanchiNerMsg==false then
						fujiF.GetBut:NewMsgadd()
					end
				end
			end
		end
	end)
end