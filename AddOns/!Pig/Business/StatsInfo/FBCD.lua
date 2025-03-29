local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Fun=addonTable.Fun
local Create=addonTable.Create
local PIGLine=Create.PIGLine
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGDiyBut=Create.PIGDiyBut
local PIGDownMenu=Create.PIGDownMenu
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
--------
local BusinessInfo=addonTable.BusinessInfo
local disp_time=Fun.disp_time
function BusinessInfo.FBCD()
	local StatsInfo = StatsInfo_UI
	local fujiF,fujiTabBut=PIGOptionsList_R(StatsInfo.F,"副\n本",StatsInfo.butW,"Left")
	fujiF:Show()
	fujiTabBut:Selected()
	PIGA["StatsInfo"]["InstancesCD"]["Mode"]=PIGA["StatsInfo"]["InstancesCD"]["Mode"] or 1
	fujiF.SetMode = PIGDiyBut(fujiF,{"TOPLEFT", fujiF, "TOPLEFT", 10, -6},{20,20,23,23,"MagePortalAlliance"})
	fujiF.SetMode:SetScript("OnClick", function ()
		StaticPopup_Show("STATSINFOINSTANCESCDMODE");
	end);
	if PIGA["StatsInfo"]["InstancesCD"]["Mode"]==1 then
		fujiF.SetMode.tisptxt="切换为旧版记录模式？\n需要重载界面"
	else
		fujiF.SetMode:SetPoint("TOPLEFT", fujiF, "TOPLEFT", 10, 0);
		fujiF.SetMode.tisptxt="切换为新版记录模式？\n需要重载界面"
	end
	PIGEnter(fujiF.SetMode,fujiF.SetMode.tisptxt)
	StaticPopupDialogs["STATSINFOINSTANCESCDMODE"] = {
		text = fujiF.SetMode.tisptxt,
		button1 = YES,
		button2 = NO,
		OnAccept = function(self,arg1)
			if PIGA["StatsInfo"]["InstancesCD"]["Mode"]==1 then
				PIGA["StatsInfo"]["InstancesCD"]["Mode"]=2
			else
				PIGA["StatsInfo"]["InstancesCD"]["Mode"]=1
			end
			ReloadUI()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}

	---
	local OldMode = tocversion>49999 or PIGA["StatsInfo"]["InstancesCD"]["Mode"]==2
	local function Get_InstancesCD()
		local numInstances = GetNumSavedInstances();
		PIGA["StatsInfo"]["InstancesCD"][StatsInfo.allname]=PIGA["StatsInfo"]["InstancesCD"][StatsInfo.allname] or {}
		local InstancesCDinfo={};
		for id = 1, numInstances, 1 do				
			local name, lockoutId, reset, difficultyId, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress, extendDisabled, instanceId = GetSavedInstanceInfo(id)
			--local bossName, fileDataID, isKilled, unknown4 = GetSavedInstanceEncounterInfo(id, 5)
			--print(GetSavedInstanceEncounterInfo(id, 5))
			InstancesCDinfo[name]=InstancesCDinfo[name] or {}
			InstancesCDinfo[name][difficultyId]={reset+GetServerTime(), numEncounters, encounterProgress}
		end
		PIGA["StatsInfo"]["InstancesCD"][StatsInfo.allname]=InstancesCDinfo
	end
	fujiF:HookScript("OnShow", function(self)
		self.Update_List();
	end)
	fujiF:RegisterEvent("PLAYER_ENTERING_WORLD")       
	fujiF:RegisterEvent("UPDATE_INSTANCE_INFO");
	fujiF:SetScript("OnEvent", function(self,event)
		if event=="PLAYER_ENTERING_WORLD" then
			RequestRaidInfo()
		elseif event=="UPDATE_INSTANCE_INFO" then
			C_Timer.After(1,Get_InstancesCD)
		end
	end)
	if OldMode then
		local hang_Height,hang_NUM  = 20.8, 22;
		local function add_hang(fujik,txttshi)
			fujik.title = PIGFontString(fujik,{"BOTTOM", fujik, "TOP", 0, 2},"冷却中的"..txttshi)
			fujik.title:SetTextColor(0, 1, 0, 1);
			fujik.Scroll = CreateFrame("ScrollFrame",nil,fujik, "FauxScrollFrameTemplate");  
			fujik.Scroll:SetPoint("TOPLEFT",fujik,"TOPLEFT",4,-4);
			fujik.Scroll:SetPoint("BOTTOMRIGHT",fujik,"BOTTOMRIGHT",-24,2);
			fujik.Scroll:SetScale(0.8);
			fujik.Scroll:SetScript("OnVerticalScroll", function(self, offset)
			    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fujik.Update_List)
			end)
			fujik.butlist={}
			for id = 1, hang_NUM, 1 do
				local hang = CreateFrame("Frame", nil, fujik);
				fujik.butlist[id]=hang
				hang:SetSize(fujik:GetWidth()-18,hang_Height);
				if id==1 then
					hang:SetPoint("TOPLEFT", fujik.Scroll, "TOPLEFT", 0, -1);
				else
					hang:SetPoint("TOPLEFT", fujik.butlist[id-1], "BOTTOMLEFT", 0, -1);
				end
				hang.Faction = hang:CreateTexture();
				hang.Faction:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
				hang.Faction:SetPoint("LEFT", hang, "LEFT", 0,0);
				hang.Faction:SetSize(hang_Height-2,hang_Height-2);
				hang.Race = hang:CreateTexture();
				hang.Race:SetPoint("LEFT", hang.Faction, "RIGHT", 1,0);
				hang.Race:SetSize(hang_Height-2,hang_Height-2);
				hang.Class = hang:CreateTexture();
				hang.Class:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
				hang.Class:SetPoint("LEFT", hang.Race, "RIGHT", 1,0);
				hang.Class:SetSize(hang_Height-2,hang_Height-2);
				hang.name = PIGFontString(hang,{"LEFT", hang.Class, "RIGHT", 2, 0})
			end
		end
		---
		local banWWW=fujiF:GetWidth()*0.5-6
		fujiF.partyCD=PIGFrame(fujiF)
		fujiF.partyCD:PIGSetBackdrop(0)
		fujiF.partyCD:SetWidth(banWWW)
		fujiF.partyCD:SetPoint("TOPLEFT",fujiF,"TOPLEFT",4,-20);
		fujiF.partyCD:SetPoint("BOTTOMLEFT",fujiF,"BOTTOMLEFT",4,0);
		add_hang(fujiF.partyCD,DUNGEONS)
		fujiF.raidCD=PIGFrame(fujiF)
		fujiF.raidCD:PIGSetBackdrop(0)
		fujiF.raidCD:SetWidth(banWWW)
		fujiF.raidCD:SetPoint("TOPRIGHT",fujiF,"TOPRIGHT",-4,-20);
		fujiF.raidCD:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",-4,0);
		add_hang(fujiF.raidCD,GUILD_INTEREST_RAID)
		--
		local function Show_hang(fujiui,cdmulu)
	   		for id = 1, hang_NUM, 1 do
				fujiui.butlist[id]:Hide();
			end
	   		local ItemsNum = #cdmulu;
			FauxScrollFrame_Update(fujiui.Scroll, ItemsNum, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(fujiui.Scroll);
		    for id = 1, hang_NUM do
				local dangqian = id+offset;
				if cdmulu[dangqian] then
					local fujik = fujiui.butlist[id]
					fujik:Show();
					if cdmulu[dangqian][1]=="juese" then
						fujik.Faction:Show();
						fujik.Race:Show();
						fujik.Class:Show();
						fujik.Race:SetWidth(hang_Height-2);
						fujik.Class:SetWidth(hang_Height-2);
						if cdmulu[dangqian][3]=="Alliance" then
							fujik.Faction:SetTexCoord(0,0.5,0,1);
						elseif cdmulu[dangqian][3]=="Horde" then
							fujik.Faction:SetTexCoord(0.5,1,0,1);
						end
						fujik.Race:SetAtlas(cdmulu[dangqian][5]);
						local className, classFile, classID = PIGGetClassInfo(cdmulu[dangqian][6])
						fujik.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
						fujik.name:SetText(cdmulu[dangqian][2].."\124cffFFD700("..cdmulu[dangqian][7]..")\124r");
						local color = PIG_CLASS_COLORS[classFile];
						fujik.name:SetTextColor(color.r, color.g, color.b, 1);
					else
						fujik.Faction:Hide();
						fujik.Race:Hide();
						fujik.Class:Hide();
						fujik.Race:SetWidth(0.01);
						fujik.Class:SetWidth(0.01);
						fujik.name:SetTextColor(1, 1, 1, 1);
						fujik.name:SetText(cdmulu[dangqian][1].."\124cff66FF11["..cdmulu[dangqian][2].."]\124r".." "..disp_time(cdmulu[dangqian][3]-GetServerTime()));
					end
				end
			end
	   	end
		function fujiF.Update_List()
			if not fujiF:IsVisible() then return end
		   	local cdmulu={{},{}};
		   	local PlayerData = PIGA["StatsInfo"]["Players"]
		   	for k,v in pairs(PlayerData) do
		   		fujiF.raidyou=false
	   			fujiF.partyyou=false
		   		local fubenData  = PIGA["StatsInfo"]["InstancesCD"][k]
				if fubenData then
					for funame,CDdata in pairs(fubenData) do
						for difficultyId,dataX in pairs(CDdata) do
							if GetServerTime()<dataX[1] then
								local name, groupType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID, isLFR, minPlayers, maxPlayers = GetDifficultyInfo(difficultyId)
								if groupType=="raid" then
									if not fujiF.raidyou then
										table.insert(cdmulu[2],{"juese",k,v[1],v[2],v[3],v[4],v[5]})
										fujiF.raidyou=true
									end
									table.insert(cdmulu[2],{funame,name,dataX[1]})
								elseif groupType=="party" then
									if not fujiF.partyyou then
										table.insert(cdmulu[1],{"juese",k,v[1],v[2],v[3],v[4],v[5]})
										fujiF.partyyou=true
									end
									table.insert(cdmulu[1],{funame,name,dataX[1]})
								end
							end
						end
					end
				end
		   	end
		   	Show_hang(fujiF.partyCD,cdmulu[1])
			Show_hang(fujiF.raidCD,cdmulu[2])
		end
	else
		local hang_Height,hang_NUM,nrpianyi,nrjiange,lienum= 19.4, 11,200,60,11
		local insList_DUNGEONS = {}
		local insList_RAIDS = {}
		local function morenRecords(fubenlist)
			local jiludata = {}
			for k,v in pairs(fubenlist) do
				jiludata[v]=true
			end
			return jiludata
		end
		if tocversion<20000 then
			local raid60 = {836,838,839,840,842,843,841}
			table.insert(insList_RAIDS,{"["..RAIDS.."]-"..EXPANSION_NAME0,raid60})
			PIGA["StatsInfo"]["InstancesCD"]["Records"]=PIGA["StatsInfo"]["InstancesCD"]["Records"] or morenRecords(raid60)
		elseif tocversion<30000 then
			table.insert(insList_RAIDS,{"["..RAIDS.."]-"..EXPANSION_NAME0,{836,838,839,840,842,843,841}})
			table.insert(insList_DUNGEONS,{"["..DUNGEONS.."]-"..EXPANSION_NAME1,{903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918}})
			local tbcid = {844,845,846,847,848,849,850,851,852}
			table.insert(insList_RAIDS,{"["..RAIDS.."]-"..EXPANSION_NAME1,tbcid})
			PIGA["StatsInfo"]["InstancesCD"]["Records"]=PIGA["StatsInfo"]["InstancesCD"]["Records"] or morenRecords(tbcid)
		elseif tocversion<40000 then
			table.insert(insList_RAIDS,{"["..RAIDS.."]-"..EXPANSION_NAME0,{836,839,840,842,843}})
			table.insert(insList_DUNGEONS,{"["..DUNGEONS.."]-"..EXPANSION_NAME1,{903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918}})
			table.insert(insList_RAIDS,{"["..RAIDS.."]-"..EXPANSION_NAME1,{844,845,846,847,848,849,850,851,852}})
			table.insert(insList_DUNGEONS,{"["..DUNGEONS.."]-"..EXPANSION_NAME2,{1121,1122,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1133}})
			local wlkid = {1095,841,1101,1102,1156,1106,1100,1110}
			table.insert(insList_RAIDS,{"["..RAIDS.."]-"..EXPANSION_NAME2,wlkid})
			PIGA["StatsInfo"]["InstancesCD"]["Records"]=PIGA["StatsInfo"]["InstancesCD"]["Records"] or morenRecords(wlkid)
		elseif tocversion<50000 then
			table.insert(insList_DUNGEONS,{"["..DUNGEONS.."]-"..EXPANSION_NAME3,{}})
			table.insert(insList_RAIDS,{"["..RAIDS.."]-"..EXPANSION_NAME3,{}})
			PIGA["StatsInfo"]["InstancesCD"]["Records"]=PIGA["StatsInfo"]["InstancesCD"]["Records"] or {}
		else
			table.insert(insList_DUNGEONS,{"["..DUNGEONS.."]-"..EXPANSION_NAME10,{}})
			local dangqianid={1601,1600,1602,1505,1506,1504}
			table.insert(insList_RAIDS,{"["..RAIDS.."]-"..EXPANSION_NAME10,dangqianid})
			PIGA["StatsInfo"]["InstancesCD"]["Records"]=PIGA["StatsInfo"]["InstancesCD"]["Records"] or morenRecords(wlkid)
		end
		local insList = {}
		for i=1,#insList_DUNGEONS do
			table.insert(insList,insList_DUNGEONS[i])
		end
		for i=1,#insList_RAIDS do
			table.insert(insList,insList_RAIDS[i])
		end
		local biaotiName = {
			[836]="ZUL",[837]="黑上",[838]="黑龙MM",[839]="MC",[840]="BWL",[842]="废墟",[843]="TAQ",[841]="NAXX",
			[1100]="TOC",[1110]="ICC",[1106]="ULD",[1102]="EoE",[1101]="OS",[1095]="宝库",[1156]="黑龙MM",
			[852]="SW",[851]="ZAM",[850]="BT",[849]="HS",[848]="DS",[847]="FB",[846]="GLR",[845]="MSLD",[844]="KLZ",
		}
		---
		fujiF.Setfuben = PIGDownMenu(fujiF,{"TOPLEFT", fujiF, "TOPLEFT", 40, -6},{140,22})
		fujiF.Setfuben:PIGDownMenu_SetText("选择监控副本")
		function fujiF.Setfuben:PIGDownMenu_Update_But(level, menuList)
			local info = {}
			if (level or 1) == 1 then
				for i=1,#insList,1 do
					info.func = nil
					info.notCheckable=true
				    info.text = insList[i][1]
				    info.menuList, info.hasArrow = insList[i][2], true
					self:PIGDownMenu_AddButton(info)
				end
			else
				info.func = self.PIGDownMenu_SetValue
				if #menuList>0 then
					for ii=1, #menuList do
						info.isNotRadio=true
						local activityInfo = C_LFGList.GetActivityInfoTable(menuList[ii]);
						local kuozhanname = biaotiName[menuList[ii]] and "("..biaotiName[menuList[ii]]..")" or ""
						info.text, info.arg1= activityInfo.fullName..kuozhanname,menuList[ii]
						info.checked = PIGA["StatsInfo"]["InstancesCD"]["Records"][menuList[ii]]
						self:PIGDownMenu_AddButton(info, level)
					end
				else
					info.func = nil
					info.notCheckable=true
				    info.text = NONE
					self:PIGDownMenu_AddButton(info, level)
				end
			end
		end
		function fujiF.Setfuben:PIGDownMenu_SetValue(value,arg1,arg2,checked)
			if checked then
				self.hejinum=0
				for k,v in pairs(PIGA["StatsInfo"]["InstancesCD"]["Records"]) do
					self.hejinum=self.hejinum+1
				end
				if self.hejinum==lienum then PIGTopMsg:add("监控位已满，请取消一些") return end
				PIGA["StatsInfo"]["InstancesCD"]["Records"][arg1]=checked
			else
				PIGA["StatsInfo"]["InstancesCD"]["Records"][arg1]=nil
			end
			fujiF.Update_List()
			PIGCloseDropDownMenus()
		end
		----
		fujiF.NR=PIGFrame(fujiF)
		fujiF.NR:SetPoint("TOPLEFT",fujiF,"TOPLEFT",4,-32);
		fujiF.NR:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",-4,4);
		fujiF.NR:PIGSetBackdrop(0)
		fujiF.NR.biaotilist={}
		for i=1,lienum do
			fujiF.NR.biaotilist[i]= PIGFontString(fujiF.NR,{"BOTTOMLEFT", fujiF.NR, "TOPLEFT", nrjiange*(i-1)+nrpianyi-19, 2},"",nil,13)
			fujiF.NR.biaotilist[i]:SetWidth(60)
		end
		fujiF.NR.Scroll = CreateFrame("ScrollFrame",nil,fujiF.NR, "FauxScrollFrameTemplate");  
		fujiF.NR.Scroll:SetPoint("TOPLEFT",fujiF.NR,"TOPLEFT",2,-2);
		fujiF.NR.Scroll:SetPoint("BOTTOMRIGHT",fujiF.NR,"BOTTOMRIGHT",-24,2);
		fujiF.NR.Scroll:SetScale(0.8);
		fujiF.NR.Scroll:SetScript("OnVerticalScroll", function(self, offset)
		    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fujiF.Update_List)
		end)
		fujiF.NR.listbut={}
		for id = 1, hang_NUM, 1 do
			local hang = CreateFrame("Frame", nil, fujiF.NR);
			fujiF.NR.listbut[id]=hang
			hang:SetSize(fujiF.NR:GetWidth()-18,hang_Height*2+4);
			if id==1 then
				hang:SetPoint("TOPLEFT", fujiF.NR.Scroll, "TOPLEFT", 0, 0);
			else
				hang:SetPoint("TOPLEFT", fujiF.NR.listbut[id-1], "BOTTOMLEFT", 0, 0);
			end
			if id~=hang_NUM then
				hang.line = PIGLine(hang,"BOT",0,nil,nil,{0.5,0.5,0.5,0.2})
			end
			hang.Faction = hang:CreateTexture();
			hang.Faction:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
			hang.Faction:SetPoint("TOPLEFT", hang, "TOPLEFT", 0,-2);
			hang.Faction:SetSize(hang_Height,hang_Height);
			hang.Race = hang:CreateTexture();
			hang.Race:SetPoint("LEFT", hang.Faction, "RIGHT", 1,0);
			hang.Race:SetSize(hang_Height,hang_Height);
			hang.Class = hang:CreateTexture();
			hang.Class:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
			hang.Class:SetPoint("LEFT", hang.Race, "RIGHT", 1,0);
			hang.Class:SetSize(hang_Height,hang_Height);
			hang.level = PIGFontString(hang,{"LEFT", hang.Class, "RIGHT", 2, 0},1)
			hang.level:SetTextColor(1,0.843,0, 1);
			hang.nameDQ = hang:CreateTexture();
			hang.nameDQ:SetTexture("interface/common/indicator-green.blp")
			hang.nameDQ:SetPoint("LEFT", hang.level, "RIGHT", 1,0);
			hang.nameDQ:SetSize(hang_Height,hang_Height);
			hang.name = PIGFontString(hang,{"TOPLEFT", hang.Faction, "BOTTOMLEFT", 0, -2})
			hang.mode1 = PIGFontString(hang,{"TOPLEFT", hang, "TOPLEFT", nrpianyi-40,-1.6},RAID_DIFFICULTY1)
			hang.mode1:SetTextColor(0,1,0,1);
			hang.mode2 = PIGFontString(hang,{"TOPLEFT", hang.mode1, "BOTTOMLEFT", 0, -8},RAID_DIFFICULTY2)
			hang.mode2:SetTextColor(1,1,0,1);
			hang.TimeCDBut={}
			for butID=1,lienum do
				local CDbutTop = PIGDiyBut(hang,nil,{hang_Height,hang_Height})
				local CDbutDown = PIGDiyBut(hang,nil,{hang_Height,hang_Height})
				CDbutTop.jindu=PIGFontString(CDbutTop,{"LEFT",CDbutTop, "RIGHT", -2, 0},"01/01")
				CDbutDown.jindu=PIGFontString(CDbutDown,{"LEFT",CDbutDown, "RIGHT", -2, 0},"01/01")
				hang.TimeCDBut[butID]={CDbutTop,CDbutDown}
			end
			function hang:resetCDlie(but,Atlas,xxx,yyy)
				but:Hide()
				but.jindu:SetText("")
				but.icon:SetAtlas(Atlas)
				but.dfpiayiV_X=xxx
				but.errpiayiV_X=xxx-hang_Height*0.5
				but.dfpiayiV_Y=yyy
				if tocversion<20000 then
					but:SetPoint("LEFT", self, "LEFT", xxx, 0);
				else
					but:SetPoint("TOPLEFT", self, "TOPLEFT", xxx, yyy);
				end
			end
			function hang:UpdataCDlie(but,min,max)
				but:Show()
				if min<max then	
					but.icon:SetAtlas("DungeonSkull")
					but.jindu:SetText(min.."/"..max)
					if tocversion<20000 then
						but:SetPoint("LEFT", self, "LEFT", but.errpiayiV_X, 0);
					else
						but:SetPoint("TOPLEFT", self, "TOPLEFT", but.errpiayiV_X, but.dfpiayiV_Y);
					end
				end
			end
			function hang:SetInstancesCD(CDdata,JKdata)
				for butID=1,lienum do
					self:resetCDlie(self.TimeCDBut[butID][1],"common-icon-checkmark",(butID-1)*nrjiange+nrpianyi,0)
					self:resetCDlie(self.TimeCDBut[butID][2],"common-icon-checkmark-yellow",(butID-1)*nrjiange+nrpianyi,-hang_Height-2)
				end 
				--print(GetDifficultyInfo(9))
				if CDdata then
					for butID=1,#JKdata do
						if CDdata[JKdata[butID][2]] then
							for difficultyId,dataX in pairs(CDdata[JKdata[butID][2]]) do
								if GetServerTime()<dataX[1] then
									local name, groupType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID, isLFR, minPlayers, maxPlayers = GetDifficultyInfo(difficultyId)
									if groupType=="raid" then
										if name==RAID_DIFFICULTY1 or name==RAID_DIFFICULTY3 then
											self.mode1:SetText(RAID_DIFFICULTY1); self.mode2:SetText(RAID_DIFFICULTY2)
											self:UpdataCDlie(self.TimeCDBut[butID][1],dataX[3],dataX[2])
										elseif name==RAID_DIFFICULTY2 or name==RAID_DIFFICULTY4 then
											self.mode1:SetText(RAID_DIFFICULTY1); self.mode2:SetText(RAID_DIFFICULTY2)
											self:UpdataCDlie(self.TimeCDBut[butID][2],dataX[3],dataX[2])
										elseif name==RAID_DIFFICULTY_40PLAYER then
											self:UpdataCDlie(self.TimeCDBut[butID][1],dataX[3],dataX[2])
										end
									elseif groupType=="party" then

									end
								end
							end
						end
					end
				end
			end
		end
		function fujiF.Update_List()
			if not fujiF:IsVisible() then return end
			for i=1,lienum do
				fujiF.NR.biaotilist[i]:SetText("")
			end
			local insList_biaoti = {}
			for i=#insList_RAIDS,1,-1 do
				for ii=#insList_RAIDS[i][2],1,-1 do
					if PIGA["StatsInfo"]["InstancesCD"]["Records"][insList_RAIDS[i][2][ii]] then
						local activityInfo = C_LFGList.GetActivityInfoTable(insList_RAIDS[i][2][ii]);
						if tocversion<50000 then
							table.insert(insList_biaoti,{biaotiName[insList_RAIDS[i][2][ii]],activityInfo.shortName})
						else
							table.insert(insList_biaoti,{biaotiName[insList_RAIDS[i][2][ii]],activityInfo.fullName})
						end
					end
				end
			end
			for i=#insList_DUNGEONS,1,-1 do
				for ii=#insList_DUNGEONS[i][2],1,-1 do
					if PIGA["StatsInfo"]["InstancesCD"]["Records"][insList_DUNGEONS[i][2][ii]] then
						local activityInfo = C_LFGList.GetActivityInfoTable(insList_DUNGEONS[i][2][ii]);
						if tocversion<50000 then
							table.insert(insList_biaoti,{biaotiName[insList_DUNGEONS[i][2][ii]],activityInfo.shortName})
						else
							table.insert(insList_biaoti,{biaotiName[insList_DUNGEONS[i][2][ii]],activityInfo.fullName})
						end
					end
				end
			end
			for i=1,#insList_biaoti do
				fujiF.NR.biaotilist[i]:SetText(insList_biaoti[i][1] or insList_biaoti[i][2])
			end
			local self=fujiF.NR.Scroll
			for id = 1, hang_NUM, 1 do
				local fujik = fujiF.NR.listbut[id]
				fujik:Hide();
				fujik.nameDQ:Hide()
				fujik.mode1:SetText("")
				fujik.mode2:SetText("")
			end
			Get_InstancesCD()
			local cdmulu={};
			local PlayerData = PIGA["StatsInfo"]["Players"]
			local PlayerSH = PIGA["StatsInfo"]["PlayerSH"]
			local InstancesCD=PIGA["StatsInfo"]["InstancesCD"]
			if PlayerData[StatsInfo.allname] and not PlayerSH[StatsInfo.allname] then
				local dangqianC=PlayerData[StatsInfo.allname]
				table.insert(cdmulu,{StatsInfo.allname,dangqianC[1],dangqianC[2],dangqianC[3],dangqianC[4],dangqianC[5],InstancesCD[StatsInfo.allname],true})
			end
		   	for k,v in pairs(PlayerData) do
		   		if k~=StatsInfo.allname and PlayerData[k] and not PlayerSH[k] then
		   			table.insert(cdmulu,{k,v[1],v[2],v[3],v[4],v[5],InstancesCD[k]})
		   		end
		   	end
			local ItemsNum = #cdmulu;
			if ItemsNum>0 then
			    FauxScrollFrame_Update(self, ItemsNum, hang_NUM, hang_Height);
			    local offset = FauxScrollFrame_GetOffset(self);
			    for id = 1, hang_NUM do
					local dangqian = id+offset;
					if cdmulu[dangqian] then
						local fujik = fujiF.NR.listbut[id]
						fujik:Show();
						if cdmulu[dangqian][2]=="Alliance" then
							fujik.Faction:SetTexCoord(0,0.5,0,1);
						elseif cdmulu[dangqian][2]=="Horde" then
							fujik.Faction:SetTexCoord(0.5,1,0,1);
						end
						fujik.Race:SetAtlas(cdmulu[dangqian][4]);
						local className, classFile, classID = PIGGetClassInfo(cdmulu[dangqian][5])
						fujik.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
						fujik.level:SetText(cdmulu[dangqian][6]);
						if cdmulu[dangqian][8] then
							fujik.nameDQ:Show()
						end
						fujik.name:SetText(cdmulu[dangqian][1]);
						local color = PIG_CLASS_COLORS[classFile];
						fujik.name:SetTextColor(color.r, color.g, color.b, 1);
						fujik:SetInstancesCD(cdmulu[dangqian][7],insList_biaoti)
					end
				end
			end
		end
		------
	end
end
