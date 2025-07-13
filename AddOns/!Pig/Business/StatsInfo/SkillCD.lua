local addonName, addonTable = ...;
local L=addonTable.locale
local Fun=addonTable.Fun
local Create=addonTable.Create
local PIGLine=Create.PIGLine
local PIGFrame=Create.PIGFrame
local PIGTabBut = Create.PIGTabBut
local PIGCheckbutton=Create.PIGCheckbutton
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
--------
local match = _G.string.match
local Data=addonTable.Data
local BusinessInfo=addonTable.BusinessInfo
local disp_time=Fun.disp_time
local GetContainerNumSlots =GetContainerNumSlots or C_Container and C_Container.GetContainerNumSlots
local GetContainerItemID=GetContainerItemID or C_Container and C_Container.GetContainerItemID
local GetContainerItemCooldown=GetContainerItemCooldown or C_Container and C_Container.GetContainerItemCooldown
local GetSpellInfo=GetSpellInfo or C_Spell and C_Spell.GetSpellInfo
local GetItemNameByID=GetItemNameByID or C_Item and C_Item.GetItemNameByID
---
function BusinessInfo.SkillCD(StatsInfo)
	local fujiF,fujiTabBut=PIGOptionsList_R(StatsInfo.F,"专\n业",StatsInfo.butW,"Left")
	fujiF.guolvtype=1
	local guolvname = {"有CD角色","所有角色","已学专业角色","未学专业角色"}
	fujiF.guolvtypeButlist={}
	for i=1,#guolvname do
		local ExistCDbut = PIGTabBut(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",120*i,-6},{100,22},guolvname[i])
		fujiF.guolvtypeButlist[i]=ExistCDbut
		if i==1 then ExistCDbut:Selected() end
		ExistCDbut:SetScript("OnClick", function (self)
			for xx=1,#guolvname do
				fujiF.guolvtypeButlist[xx]:NotSelected()
			end
			self:Selected()
			fujiF.guolvtype=i
			fujiF.NR.Update_List()
		end);
	end
	---
	local playerSkill={}
	local Skill_Learned={}
	local Spell_ItemID={
		[19566]=15846,--筛盐器
		[55208]=37663,--熔炼泰坦精钢
		[18560]=14342,--月布
		[11480]=20761,--转化秘银
		[56005]=41600,--冰川背包
		[56002]=41593,--乌纹布
		[56001]=41594,--月影布
		[56003]=41595,--法纹布
		[60893]=38351,--诺森德炼金研究
		[17187]=20761,--转化：奥金
		[32766]=20761,--转化：天火钻石
		[66663]=20761,--转化：巨锆石
		[47280]=35945,--闪亮的玻璃
		[62242]=44943,--冰冻棱柱
		
	}
	local SpellItemID={[19566]=15846}
	local Skill_list = {
	    [1] = {IsCD = {}, spellid = 2018, icon = 136241}, -- 锻造
	    [2] = {IsCD = {}, spellid = 2108, icon = 133611}, -- 制皮
	    [3] = {IsCD = {}, spellid = 2259, icon = 136240}, -- 炼金术
	    [4] = {IsCD = {}, spellid = 2575, icon = 136248}, -- 采矿
	    [5] = {IsCD = {}, spellid = 3908, icon = 136249}, -- 裁缝
	    [6] = {IsCD = {}, spellid = 4036, icon = 136243}, -- 工程学
	    [7] = {IsCD = {}, spellid = 7411, icon = 136244}, -- 附魔
	    [8] = {IsCD = {}, spellid = 8613, icon = 134366}, -- 剥皮
	    [9] = {IsCD = {}, spellid = 13614, icon = 136246}, -- 草药学
	    [10] = {IsCD = {}, spellid = 25229, icon = 134071}, -- 珠宝加工
	    [11] = {IsCD = {}, spellid = 45357, icon = 237171}, -- 铭文
	}
	-- 测试
	-- SpellItemID[6405]=5462
	-- table.insert(Skill_list[5].IsCD,6405)

	-- {13399,133651,11020},--培植种子
	-- {21935,135863,17716},--雪王9000型
	-- {26265,134249,21540},--制造艾露恩之石
	if PIG_MaxTocversion(20000) then
		table.insert(Skill_list[2].IsCD,19566)
		table.insert(Skill_list[3].IsCD,{11480,11479,17187,17559,17560,17561,17562,17563,17564,17565,17566,25146})
		table.insert(Skill_list[5].IsCD,18560)
	elseif PIG_MaxTocversion(30000) then
		table.insert(Skill_list[2].IsCD,19566)
		table.insert(Skill_list[3].IsCD,{32766,32765,29688,28566,28567,28568,28569,28580,28581,28582,28583,28584,28585})
		table.insert(Skill_list[5].IsCD,26751)
		table.insert(Skill_list[5].IsCD,31373)
		table.insert(Skill_list[5].IsCD,36686)
		table.insert(Skill_list[10].IsCD,47280)
	elseif PIG_MaxTocversion(40000) then
		table.insert(Skill_list[2].IsCD,19566)
		table.insert(Skill_list[3].IsCD,60893)
		table.insert(Skill_list[3].IsCD,{66663,66662,66658,66664,53774,53775,53776,53781,53777,53782,53773,53771,53779,53780,53783,53784})
		table.insert(Skill_list[4].IsCD,55208)
		table.insert(Skill_list[5].IsCD,56005)
		table.insert(Skill_list[5].IsCD,56002)
		table.insert(Skill_list[5].IsCD,56001)
		table.insert(Skill_list[5].IsCD,56003)
		table.insert(Skill_list[10].IsCD,47280)
		table.insert(Skill_list[10].IsCD,62242)
		table.insert(Skill_list[11].IsCD,61177)
	else
		Skill_list[9].spellid=13617
	end
	for k,v in pairs(Skill_list) do
		local Skillname=PIGGetSpellInfo(v.spellid)
		v.name=Skillname
	end
	local function GetSkillNameID(ItemName)
		for i=1,#Skill_list do
			for ix=1,#Skill_list[i].IsCD do
				if type(Skill_list[i].IsCD[ix])=="table" then
					for cdid=1,#Skill_list[i].IsCD[ix] do
						local Skillname=PIGGetSpellInfo(Skill_list[i].IsCD[ix][cdid])
						if ItemName==Skillname then
							return Skill_list[i].IsCD[ix][cdid]
						end
					end
				else
					local Skillname=PIGGetSpellInfo(Skill_list[i].IsCD[ix])
					if ItemName==Skillname then
						return Skill_list[i].IsCD[ix]
					end
				end
			end
		end
		return false
	end
	local function GetBagItemSpellCD(SpellID,ItemID)
		for Bagid=0,NUM_BAG_SLOTS,1 do
			local numberOfSlots = GetContainerNumSlots(Bagid);
			for Slots=1,numberOfSlots,1 do
				if GetContainerItemID(Bagid, Slots)==ItemID then
					local startTime, duration, enable=GetContainerItemCooldown(Bagid, Slots)
					--print(ItemID,disp_time(startTime+duration-GetTime()))
					if startTime > 0 and duration > 0 then
						PIGA["StatsInfo"]["SkillData"][StatsInfo.allname][0][SpellID]=startTime+duration
					else
						PIGA["StatsInfo"]["SkillData"][StatsInfo.allname][0][SpellID]=0
					end
					return
				end
			end
		end
	end
	local function GetBagItemCD()
		for k,v in pairs(SpellItemID) do
			GetBagItemSpellCD(k,v)
		end
	end
	local function GetSkillIndex(name)
		if name then
			for i=1,#Skill_list do
				if Skill_list[i].name==name then
					return i
				end
			end
		end
		return 0
	end
	local function Update_SkillData()
		table.clear(playerSkill)
		playerSkill[0]={}
		for i=1,2 do
			Skill_Learned[i]=Skill_Learned[i] or {}
			local SkillId=GetSkillIndex(Skill_Learned[i][1])
			if SkillId>0 then
				playerSkill[i]={SkillId,Skill_list[SkillId].IsCD,Skill_Learned[i][2],Skill_Learned[i][3]}
			else
				playerSkill[i]={SkillId,{},Skill_Learned[i][2],Skill_Learned[i][3]}
			end
		end
		for i=1,2 do
			if #playerSkill[i][2]>0 then
				for ix=1,#playerSkill[i][2] do
					if type(playerSkill[i][2][ix])=="table" then
						for ixx=1,#playerSkill[i][2][ix] do
							table.insert(fujiF.CDspellID,playerSkill[i][2][ix][ixx])
						end
					else
						table.insert(fujiF.CDspellID,playerSkill[i][2][ix])
					end
				end
			end
		end
		--提取旧的数据剔除失效
		local olddata=PIGA["StatsInfo"]["SkillData"][StatsInfo.allname][0] or {}
		for i=1,2 do
			local dfCDdata = playerSkill[i][2]
			for ix=1,#dfCDdata do
				if type(dfCDdata[ix])=="table" then--共享CD专业技能
					for cdid=1,#dfCDdata[ix] do
						playerSkill[0][dfCDdata[ix][cdid]]=olddata[dfCDdata[ix][cdid]]
					end
				else
					playerSkill[0][dfCDdata[ix]]=olddata[dfCDdata[ix]]
				end
			end
		end
		PIGA["StatsInfo"]["SkillData"][StatsInfo.allname]=playerSkill
	end
	local function GetPlayerSkillInfo()
		table.clear(Skill_Learned)
		if PIG_MaxTocversion(40000) then
			for skillIndex = 1, GetNumSkillLines() do
				local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier,skillMaxRank, isAbandonable= GetSkillLineInfo(skillIndex)
				if isAbandonable then
					if not Skill_Learned[1] then
						Skill_Learned[1]={skillName, skillRank,skillMaxRank}
					elseif not Skill_Learned[2] then
						Skill_Learned[2]={skillName, skillRank,skillMaxRank}
						break
					end
				end
			end
		else
			local prof1, prof2, archaeology, fishing, cooking = GetProfessions()
			if prof1 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier = GetProfessionInfo(prof1)
				Skill_Learned[1]={name,skillLevel, maxSkillLevel}
			end
			if prof2 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier = GetProfessionInfo(prof2)
				Skill_Learned[2]={name,skillLevel, maxSkillLevel}
			end
		end
		table.clear(fujiF.CDspellID)
		Update_SkillData()	
	end
	local function GetSkillname(SpellID)
		local Skillname=PIGGetSpellInfo(SpellID)
		if Skillname:match("转化") then Skillname="转化" end
		if Skillname:match("炼金研究") then Skillname="炼金研究" end
		return Skillname
	end
	local function GetCDSpellID(CDdataX,SpellID)
		if type(SpellID)=="table" then--是多个技能共享CD
			for cdid=1,#SpellID do
				if CDdataX[SpellID[cdid]] then
					return SpellID[cdid],GetSkillname(SpellID[cdid])
				end
			end
			return SpellID[1],GetSkillname(SpellID[1])
		else
			return SpellID,GetSkillname(SpellID)
		end
	end
	----
	local hang_Height,hang_NUM,numButtons  = StatsInfo.hang_Height, 11, 6;
	fujiF.NR=PIGFrame(fujiF)
	fujiF.NR:SetPoint("TOPLEFT",fujiF,"TOPLEFT",4,-40);
	fujiF.NR:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",-4,4);
	fujiF.NR:PIGSetBackdrop(0)
	fujiF.NR.Scroll = CreateFrame("ScrollFrame",nil,fujiF.NR, "FauxScrollFrameTemplate");  
	fujiF.NR.Scroll:SetPoint("TOPLEFT",fujiF.NR,"TOPLEFT",2,-2);
	fujiF.NR.Scroll:SetPoint("BOTTOMRIGHT",fujiF.NR,"BOTTOMRIGHT",-19,2);
	fujiF.NR.Scroll:SetScale(0.8);
	fujiF.NR.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fujiF.NR.Update_List)
	end)
	fujiF.NR.listbut={}
	for id = 1, hang_NUM, 1 do
		local hang = CreateFrame("Frame", nil, fujiF.NR);
		fujiF.NR.listbut[id]=hang
		hang:SetSize(fujiF.NR:GetWidth()-18,hang_Height*2+4);
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.NR, "TOPLEFT", 0, 0);
		else
			hang:SetPoint("TOPLEFT", fujiF.NR.listbut[id-1], "BOTTOMLEFT", 0, 0);
		end
		if id~=hang_NUM then
			hang.line = PIGLine(hang,"BOT",0,nil,nil,{0.5,0.5,0.5,0.2})
		end
		hang.Faction = hang:CreateTexture();
		hang.Faction:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
		hang.Faction:SetPoint("TOPLEFT", hang, "TOPLEFT", 3,-2);
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
		hang.SkillBut={}
		for ixx=1,2 do
			local hangSkill = CreateFrame("Frame", nil, hang);
			hang.SkillBut[ixx]=hangSkill
			if ixx==1 then
				hangSkill:SetPoint("TOPLEFT", hang, "TOPLEFT", 160,-1.6);
			else
				hangSkill:SetPoint("TOPLEFT", hang.SkillBut[ixx-1], "BOTTOMLEFT", 0, -1);
			end
			hangSkill:SetSize(hang_Height,hang_Height);
			hangSkill.icon = hangSkill:CreateTexture();
			hangSkill.icon:SetPoint("LEFT", hangSkill, "LEFT", 0,0);
			hangSkill.icon:SetSize(hang_Height,hang_Height);
			hangSkill.name = PIGFontString(hangSkill,{"LEFT",hangSkill.icon, "RIGHT", 0, 0})
		end
		hang.TimeCDBut={}
		for butID=1,numButtons do
			hang.TimeCDBut[butID]={}
			local CDbut = hang:CreateTexture();
			hang.TimeCDBut[butID].icon=CDbut
			CDbut:SetPoint("TOPLEFT", hang, "TOPLEFT", (butID-1)*106+240,-3);
			CDbut:SetSize(hang_Height,hang_Height);
			CDbut:SetTexture(134400);
			hang.TimeCDBut[butID].name=PIGFontString(hang,{"LEFT",CDbut, "RIGHT", 0, 0})
			hang.TimeCDBut[butID].cd = PIGFontString(hang,{"TOPLEFT",CDbut, "BOTTOMLEFT", 0, -2})
		end
		function hang.SetSkillIconName(dataT)
			for ixx=1,2 do
				local hangSkill=hang.SkillBut[ixx]
				hangSkill.icon:SetTexture(134400);
				hangSkill.name:SetText("|cffa4a4a4"..UNKNOWN.."|r");
			end
			for butID=1,numButtons do
				local CDbut=hang.TimeCDBut[butID]
				CDbut.icon:Hide()
				CDbut.name:SetText("");
				CDbut.cd:SetText("");
			end
			if dataT then
				local NewCDdata = {}
				for ixx=1,2 do
					if dataT[ixx] then
						local hangSkill=hang.SkillBut[ixx]
						if dataT[ixx][1]>0 then
							hangSkill.icon:SetTexture(Skill_list[dataT[ixx][1]].icon);
							local NewTxtminmax=""
							if dataT[ixx][3] and dataT[ixx][4] then
								if dataT[ixx][3]<dataT[ixx][4] then
									NewTxtminmax="|cff808080"..dataT[ixx][3].."/"..dataT[ixx][4].."|r"
								else
									NewTxtminmax="|cff00ff00"..dataT[ixx][3].."/"..dataT[ixx][4].."|r"
								end
							else
								NewTxtminmax="|cffa4a4a4??/??|r"
							end
							hangSkill.name:SetText(NewTxtminmax);--Skill_list[dataT[ixx][1]].name..NewTxtminmax
							for cdid=1,#dataT[ixx][2] do
								table.insert(NewCDdata,dataT[ixx][2][cdid])
							end
						else
							hangSkill.icon:SetTexture(130775);
							hangSkill.icon:SetDesaturated(true)
							hangSkill.name:SetText("|cffa4a4a4"..TRADE_SKILLS_UNLEARNED_TAB.."|r");
						end
					end
				end
				for butID=1,numButtons do
					local hangCDdata=NewCDdata[butID]--预制的CD信息
					if hangCDdata then
						local CDdataX=dataT[0] or {}
						local CDbut=hang.TimeCDBut[butID]
						local SpellID,Skillname=GetCDSpellID(CDdataX,hangCDdata)
						CDbut.icon:Show()
						if Spell_ItemID[SpellID] then
							CDbut.icon:SetTexture(C_Item.GetItemIconByID(Spell_ItemID[SpellID]));
						else
							CDbut.icon:SetTexture(134400);
						end
						if CDdataX[SpellID] then
							CDbut.icon:SetDesaturated(false)
							CDbut.name:SetText(Skillname);
							if CDdataX[SpellID] then
								if CDdataX[SpellID]>0 then
									CDbut.cd:SetText(disp_time(CDdataX[SpellID]-GetTime()));
								else
									CDbut.cd:SetText("|cff00ff00已就绪|r");
								end
							else
								CDbut.cd:SetText("|cffff0000CD"..UNKNOWN.."|r");
							end
						else
							CDbut.icon:SetDesaturated(true)
							CDbut.name:SetText("|cffa4a4a4"..Skillname.."|r");
							CDbut.cd:SetText("|cffa4a4a4N/A|r");
						end
					end
				end
			end
		end
	end
	fujiF.NR:HookScript("OnShow", function(self)
		self.Update_List();
	end)
	local function IsExistCD(dataT)
		if fujiF.guolvtype==2 then
			return true
		elseif fujiF.guolvtype==1 then
			if dataT and dataT[0] then
				for k1,v1 in pairs(dataT[0]) do
					return true
				end
				return false
			end
			return false
		elseif fujiF.guolvtype==3 then
			if dataT then
				for ixx=1,2 do
					if dataT[ixx] and dataT[ixx][1]>0 then
						return true
					end
				end
				return false
			end
			return false
		elseif fujiF.guolvtype==4 then
			if dataT then
				for ixx=1,2 do
					if dataT[ixx] and dataT[ixx][1]>0 then
						return false
					end
				end
				return true
			end
			return true
		end
	end
	function fujiF.NR.Update_List()
		if not fujiF:IsVisible() then return end
		local self=fujiF.NR.Scroll
		for id = 1, hang_NUM, 1 do
			local fujik = fujiF.NR.listbut[id]
			fujik:Hide();
			fujik.nameDQ:Hide()
		end
		local cdmulu={};
		local PlayerData = PIGA["StatsInfo"]["Players"]
		local PlayerSH = PIGA["StatsInfo"]["PlayerSH"]
		local SkillData=PIGA["StatsInfo"]["SkillData"]
		if PlayerData[StatsInfo.allname] and not PlayerSH[StatsInfo.allname] then
			local dangqianC=PlayerData[StatsInfo.allname]
			if IsExistCD(SkillData[StatsInfo.allname]) then
				table.insert(cdmulu,{StatsInfo.allname,dangqianC[1],dangqianC[2],dangqianC[3],dangqianC[4],dangqianC[5],SkillData[StatsInfo.allname],true})
			end
		end
	   	for k,v in pairs(PlayerData) do
	   		if k~=StatsInfo.allname and PlayerData[k] and not PlayerSH[k] then
	   			if IsExistCD(SkillData[k]) then
	   				table.insert(cdmulu,{k,v[1],v[2],v[3],v[4],v[5],SkillData[k]})
	   			end
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
					fujik.SetSkillIconName(cdmulu[dangqian][7])
				end
			end
		end
	end
	--
	fujiF:RegisterEvent("PLAYER_ENTERING_WORLD")
	fujiF:RegisterEvent("SKILL_LINES_CHANGED")
	fujiF:RegisterEvent("BAG_UPDATE_COOLDOWN")
	fujiF:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED","player"); 
	if PIG_MaxTocversion() then         
		fujiF:RegisterEvent("TRADE_SKILL_UPDATE")
	else
		fujiF:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
	end
	fujiF.CDspellID={}
	fujiF:SetScript("OnEvent", function(self,event,arg1,arg2,arg3)
		-- print(event,arg1,arg2,arg3)
		if event=="PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			C_Timer.After(0.4,GetPlayerSkillInfo)
			C_Timer.After(1,GetBagItemCD)
		elseif event=="SKILL_LINES_CHANGED" then
			C_Timer.After(0.1,GetPlayerSkillInfo)
		elseif event=="BAG_UPDATE_COOLDOWN" then
			C_Timer.After(0.1,GetBagItemCD)
		elseif event=="TRADE_SKILL_UPDATE" then
			for j=1,GetNumTradeSkills() do
				local Skillname,skillType= GetTradeSkillInfo(j);
				if skillType~= "header" then
					local SpellID= GetSkillNameID(Skillname)
					if SpellID then
						local Cooldown = GetTradeSkillCooldown(j);
						if Cooldown and Cooldown>0 then
							PIGA["StatsInfo"]["SkillData"][StatsInfo.allname][0][SpellID]=Cooldown+GetTime()
						else
							PIGA["StatsInfo"]["SkillData"][StatsInfo.allname][0][SpellID]=0
						end
					end
				end
			end
		elseif event=="TRADE_SKILL_LIST_UPDATE" then
				-- C_Timer.After(0.1,function()
				-- 	-- local prof1, prof2, archaeology, fishing, cooking = GetProfessions()
				-- 	-- print()
				-- 	-- local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier = GetProfessionInfo(prof1)
				-- 	-- --print(name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier)
				-- 	-- for _, id in pairs(C_TradeSkillUI.GetAllRecipeIDs()) do
				-- 	-- 	local recipeInfo = C_TradeSkillUI.GetRecipeInfo(id)
				-- 	-- 	for k,v in pairs(recipeInfo) do
				-- 	-- 		print(k,v)
				-- 	-- 	end
				-- 	-- 	--print(recipeInfo.recipeID, recipeInfo.name)
				-- 	-- end
				-- end)
		elseif event=="UNIT_SPELLCAST_SUCCEEDED" then
			C_Timer.After(0.1,function()
				for ix=1,#fujiF.CDspellID do
					if arg3==fujiF.CDspellID[ix] then
						if SpellItemID[arg3] then
							
						else
							local startTime, duration = PIGGetSpellCooldown(arg3);
							if startTime > 0 and duration > 0 then
								PIGA["StatsInfo"]["SkillData"][StatsInfo.allname][0][arg3]=startTime+duration
							end
						end
						break
					end
				end
			end)
		end
	end)
end
