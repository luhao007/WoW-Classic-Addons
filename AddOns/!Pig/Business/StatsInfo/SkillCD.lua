local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Fun=addonTable.Fun
local Create=addonTable.Create
local PIGLine=Create.PIGLine
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
--------
local BusinessInfo=addonTable.BusinessInfo
local disp_time=Fun.disp_time
---
local SkillIcon={
	[1]=136249,--裁缝
	[2]=136240,--炼金
	[3]=134071,--珠宝加工
	[4]=237171,--铭文
	[5]=135811,--采矿熔炼
}
local SkillData={
	["event"]="TRADE_SKILL_UPDATE",
	["SkillID"]={},
	["ItemID"]={},
}
if tocversion<20000 then
	SkillData.SkillID={
		--[3275]={1},--绷带测试
		[18560]={1},[11480]={2},
		[11479]={2},[17187]={2},
		[17559]={2},[17560]={2},
		[17561]={2},[17562]={2},
		[17563]={2},[17564]={2},
		[17565]={2},[17566]={2},
		[25146]={2},
	};
	SkillData.ItemID={
		{19566,132836,15846},{13399,133651,11020},
		{21935,135863,17716},{26265,134249,21540},
	};
elseif tocversion<30000 then
	SkillData.SkillID={
		--裁缝
		[26751]={1},
		[31373]={1},
		[36686]={1},
		--炼金
		[32766]={2},
		[32765]={2},
		[29688]={2},
		[28566]={2},
		[28567]={2},
		[28568]={2},
		[28569]={2},
		[28580]={2},
		[28581]={2},
		[28582]={2},
		[28583]={2},
		[28584]={2},
		[28585]={2},
		--珠宝加工
		[47280]={3},
	};
	SkillData.ItemID={
		--筛盐器
		{19566,132836,15846},--spell,icon,item
	};
elseif tocversion<40000 then
	SkillData.SkillID={
		--裁缝
		[56005]={1},--冰川背包
		[56002]={1},--乌纹
		[56001]={1},--月影
		[56003]={1},--法纹
		--炼金
		[60893]={2},
		[66663]={2},
		[66662]={2},
		[66658]={2},
		[66664]={2},
		[53774]={2},
		[53775]={2},
		[53776]={2},
		[53781]={2},
		[53777]={2},
		[53782]={2},
		[53773]={2},
		[53771]={2},
		[53779]={2},
		[53780]={2},
		[53783]={2},
		[53784]={2},
		--珠宝加工
		[47280]={3},
		[62242]={3},
		--铭文
		[61177]={4},
		--采矿
		[55208]={5},--泰坦精钢锭
	};
	SkillData.ItemID={
		--筛盐器
		{19566,132836,15846},
	};
else
	SkillData.event="TRADE_SKILL_LIST_UPDATE";
	SkillData.SkillID={

	};
	SkillData.ItemID={
		
	};
end
function BusinessInfo.SkillCD()
	local StatsInfo = StatsInfo_UI
	PIGA["StatsInfo"]["SkillCD"][StatsInfo.allname]=PIGA["StatsInfo"]["SkillCD"][StatsInfo.allname] or {}
	local fujiF,fujiTabBut=PIGOptionsList_R(StatsInfo.F,"专\n业",StatsInfo.butW,"Left")
	---
	local function xieru_SkillCD()	
		local CDxinxi=PIGA["StatsInfo"]["SkillCD"][StatsInfo.allname]
		for k,v in pairs(SkillData.SkillID) do
			local nametxt =PIGGetSpellInfo(k)
			CDxinxi[nametxt]=CDxinxi[nametxt] or {"spell",false,v[1],nil,k,nil}
			if IsPlayerSpell(k) then
				CDxinxi[nametxt][2]=true
			end
		end
		-- for k,v in pairs(SkillData.ItemID) do
		-- 	print(k,v)
		-- end
	end
	local function Get_SkillCD()
		if tocversion<100000 then
			local CDxinxi=PIGA["StatsInfo"]["SkillCD"][StatsInfo.allname]
			for j=1,GetNumTradeSkills() do
				local Skillname= GetTradeSkillInfo(j);
				local cd = GetTradeSkillCooldown(j);
				--print(Skillname,cd)
				if CDxinxi[Skillname] then
					if cd then
						CDxinxi[Skillname][4]=cd
						CDxinxi[Skillname][6]=GetTime()
					else
						CDxinxi[Skillname][4]=0
						CDxinxi[Skillname][6]=GetTime()
					end
				end
			end
		else
			-- local prof1, prof2, archaeology, fishing, cooking = GetProfessions()
			-- local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof1)
			-- --print(name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset)
			-- for _, id in pairs(C_TradeSkillUI.GetAllRecipeIDs()) do
			-- 	local recipeInfo = C_TradeSkillUI.GetRecipeInfo(id)
			-- 	for k,v in pairs(recipeInfo) do
			-- 		print(k,v)
			-- 	end
			-- 	--print(recipeInfo.recipeID, recipeInfo.name)
			-- end
		end
		-- for Bagid=0,4,1 do
		-- 	local numberOfSlots = GetContainerNumSlots(Bagid);
		-- 	for i=1,numberOfSlots,1 do
		-- 		for ii=1,#Pig_ItemID,1 do
		-- 			if GetContainerItemID(Bagid, i)==Pig_ItemID[ii][3] then--有物品
		-- 				local Itemxinxi={Pig_ItemID[ii][1],Pig_ItemID[ii][2],Pig_ItemID[ii][3]};
		-- 				table.insert(yixueSkill,Itemxinxi)
		-- 			end
		-- 		end
		-- 	end
		-- end	
	end
	---------
	local hang_Height,hang_NUM  = 20.6, 21;
	fujiF.lineC = PIGLine(fujiF,"C",nil,nil,nil,{0,0,0,0.5})
	fujiF.SkillCD=PIGFrame(fujiF)
	fujiF.SkillCD:SetPoint("TOPLEFT",fujiF,"TOPLEFT",4,-2);
	fujiF.SkillCD:SetPoint("BOTTOMRIGHT",fujiF.lineC,"BOTTOMLEFT",-4,2);
	fujiF.SkillCD.title = PIGFontString(fujiF.SkillCD,{"TOP", fujiF.SkillCD, "TOP", 0, -2},"冷却中的"..TRADE_SKILLS..SKILL)
	fujiF.SkillCD.title:SetTextColor(0, 1, 0, 1);
	fujiF.SkillCD.lineTOP = PIGLine(fujiF.SkillCD,"TOP",-20,nil,nil,{0.3,0.3,0.3,0.3})
	fujiF.SkillCD.lineBOT = PIGLine(fujiF.SkillCD,"BOT",20,nil,nil,{0.3,0.3,0.3,0.3})
	fujiF.SkillCD.tishi = PIGFontString(fujiF.SkillCD,{"BOTTOM",fujiF.SkillCD,"BOTTOM",10,4},"\124cff00ff00第一次使用时请打开专业面板获取一次CD！\124r","OUTLINE",13)
	fujiF.SkillCD.tishiTex = fujiF.SkillCD:CreateTexture(nil, "ARTWORK");
	fujiF.SkillCD.tishiTex:SetTexture("interface/common/help-i.blp");
	fujiF.SkillCD.tishiTex:SetPoint("RIGHT", fujiF.SkillCD.tishi, "LEFT", 0, 0);
	fujiF.SkillCD.tishiTex:SetSize(26,26);
	local function gengxin_SkillCD(self)
		if not fujiF:IsVisible() then return end
		for id = 1, hang_NUM, 1 do
			_G["PIG_SkillCD_"..id]:Hide();
		end
		local cdmulu={};
		local PlayerData = PIGA["StatsInfo"]["Players"]  	
	   	for k,v in pairs(PlayerData) do
	   		local SkillData  = PIGA["StatsInfo"]["SkillCD"][k]
	   		table.insert(cdmulu,{"juese",k,v[1],v[2],v[3],v[4],v[5]})
	   		local youshujucunzai=false
	   		for kk,vv in pairs(SkillData) do
	   			if vv[2] then
	   				youshujucunzai=true
	   				table.insert(cdmulu,{vv[1],vv[2],kk,vv[3],vv[4],vv[5],vv[6]})
	   			end
	   		end
	   		if not youshujucunzai then
	   			table.remove(cdmulu,#cdmulu)
		   	end
	   	end
		local ItemsNum = #cdmulu;
		if ItemsNum>0 then
		    FauxScrollFrame_Update(self, ItemsNum, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(self);
		    for id = 1, hang_NUM do
				local dangqian = id+offset;
				if cdmulu[dangqian] then
					local fujik = _G["PIG_SkillCD_"..id]
					fujik:Show();
					if cdmulu[dangqian][1]=="juese" then
						fujik.Faction:Show();
						fujik.Class:Show();
						fujik.Class:SetWidth(hang_Height-2);
						if cdmulu[dangqian][3]=="Alliance" then
							fujik.Faction:SetTexCoord(0,0.5,0,1);
						elseif cdmulu[dangqian][3]=="Horde" then
							fujik.Faction:SetTexCoord(0.5,1,0,1);
						end
						fujik.Race:SetAtlas(cdmulu[dangqian][5]);
						local className, classFile, classID = GetClassInfo(cdmulu[dangqian][6])
						fujik.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
						fujik.name:SetText(cdmulu[dangqian][2].."\124cffFFD700("..cdmulu[dangqian][7]..")|r");
						local color = PIG_CLASS_COLORS[classFile];
						fujik.name:SetTextColor(color.r, color.g, color.b, 1);
					else
						fujik.Faction:Hide();
						fujik.Class:Hide();
						fujik.Class:SetWidth(0.01);
						fujik.Race:SetTexCoord(0,1,0,1);
						fujik.Race:SetTexture(SkillIcon[cdmulu[dangqian][4]])
						fujik.name:SetTextColor(1, 1, 1, 1);
						local nametxt =cdmulu[dangqian][3]
						if cdmulu[dangqian][5] and cdmulu[dangqian][7] then
							local shengyu=cdmulu[dangqian][7]+cdmulu[dangqian][5]-GetTime();
							if shengyu>0 then
								nametxt=nametxt.." "..disp_time(shengyu)
							else
								nametxt=nametxt.." |cFF00FF00新CD！|r";
							end
						else
							nametxt=nametxt.." |cFF00FF00未知！|r";
						end
						fujik.name:SetText(nametxt);
					end
				end
			end
		end
	end
	------
	fujiF.SkillCD.Scroll = CreateFrame("ScrollFrame",nil,fujiF.SkillCD, "FauxScrollFrameTemplate");  
	fujiF.SkillCD.Scroll:SetPoint("TOPLEFT",fujiF.SkillCD.lineTOP,"BOTTOMLEFT",4,-4);
	fujiF.SkillCD.Scroll:SetPoint("BOTTOMRIGHT",fujiF.SkillCD.lineBOT,"BOTTOMRIGHT",-20,2);
	fujiF.SkillCD.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, gengxin_SkillCD)
	end)
	for id = 1, hang_NUM, 1 do
		local hang = CreateFrame("Frame", "PIG_SkillCD_"..id, fujiF.SkillCD);
		hang:SetSize(fujiF.SkillCD:GetWidth()-18,hang_Height);
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.SkillCD.Scroll, "TOPLEFT", 0, -2);
		else
			hang:SetPoint("TOPLEFT", _G["PIG_SkillCD_"..id-1], "BOTTOMLEFT", 0, -1);
		end
		hang.Faction = hang:CreateTexture();
		hang.Faction:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
		hang.Faction:SetPoint("LEFT", hang, "LEFT", 0,0);
		hang.Faction:SetSize(hang_Height-2,hang_Height-2);
		hang.Race = hang:CreateTexture();
		hang.Race:SetTexture("Interface/Glues/CharacterCreate/CharacterCreateIcons")
		hang.Race:SetPoint("LEFT", hang.Faction, "RIGHT", 1,0);
		hang.Race:SetSize(hang_Height-2,hang_Height-2);
		hang.Class = hang:CreateTexture();
		hang.Class:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
		hang.Class:SetPoint("LEFT", hang.Race, "RIGHT", 1,0);
		hang.Class:SetSize(hang_Height-2,hang_Height-2);
		hang.name = PIGFontString(hang,{"LEFT", hang.Class, "RIGHT", 2, 0})
	end
	---
	fujiF.shiguang=PIGFrame(fujiF)
	fujiF.shiguang:SetPoint("TOPRIGHT",fujiF,"TOPRIGHT",-4,-2);
	fujiF.shiguang:SetPoint("BOTTOMLEFT",fujiF.lineC,"BOTTOMRIGHT",4,2);
	fujiF.shiguang.title = PIGFontString(fujiF.shiguang,{"TOP", fujiF.shiguang, "TOP", 0, -2},TOKEN_FILTER_LABEL)
	fujiF.shiguang.title:SetTextColor(0, 1, 0, 1);
	fujiF.shiguang.lineTOP = PIGLine(fujiF.shiguang,"TOP",-20,nil,nil,{0.3,0.3,0.3,0.3})
	local allhangshu = 48
	for i = 1, allhangshu do
		local shiguangG = PIGFontString(fujiF.shiguang,nil,"",nil,14,"shiguangG_"..i)
		if i==1 then
			shiguangG:SetPoint("TOPLEFT",fujiF.shiguang.lineTOP,"BOTTOMLEFT",4,-4);
		elseif i==25 then
			shiguangG:SetPoint("TOPLEFT",fujiF.shiguang.lineTOP,"BOTTOMLEFT",200,-4);
		else
			shiguangG:SetPoint("TOPLEFT",_G["shiguangG_"..(i-1)],"BOTTOMLEFT",0,-5);
		end
		shiguangG:SetJustifyH("LEFT");
	end
	local function Update_huizhangG()
		local lishihuizhangG = PIGA["AHPlus"].Tokens
		local SHUJUNUM = #lishihuizhangG
		local shujukaishiid = 0
		if SHUJUNUM>allhangshu then
			shujukaishiid=SHUJUNUM-allhangshu
		end
		for i = 1, allhangshu do
			local shujuid = i+shujukaishiid
			if lishihuizhangG[shujuid] then
				local tiem1 = date("%Y-%m-%d %H:%M",lishihuizhangG[shujuid][1])
				local jinbiV = lishihuizhangG[shujuid][2] or 0
				local jinbiV = (jinbiV/10000)
				_G["shiguangG_"..i]:SetText("|cffEEEEEE"..tiem1..":|r|cffFFFF00"..jinbiV.."G|r")
			end
		end
	end
	--
	fujiF:HookScript("OnShow", function(self)
		gengxin_SkillCD(self.SkillCD.Scroll);
		Update_huizhangG()
	end)
	fujiF:RegisterEvent("PLAYER_ENTERING_WORLD")
	fujiF:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED","player");              
	fujiF:RegisterEvent(SkillData.event)
	fujiF:SetScript("OnEvent", function(self,event,arg1,_,arg3)
		if event=="PLAYER_ENTERING_WORLD" then
			C_Timer.After(1,xieru_SkillCD)
		end
		if event==SkillData.event then
			C_Timer.After(1,Get_SkillCD)
		end
		if event=="UNIT_SPELLCAST_SUCCEEDED" then
			for k,v in pairs(SkillData.SkillID) do
				if arg3==k then
					C_Timer.After(0.8, function()
						local nametxt =PIGGetSpellInfo(arg3)
						local start, duration = PIGGetSpellCooldown(arg3);
						PIGA["StatsInfo"]["SkillCD"][StatsInfo.allname][nametxt][2]=true
						PIGA["StatsInfo"]["SkillCD"][StatsInfo.allname][nametxt][4]=duration
						PIGA["StatsInfo"]["SkillCD"][StatsInfo.allname][nametxt][6]=start
						gengxin_SkillCD(self.SkillCD.Scroll);
					end)
					return
				end
			end
		end
	end)
end
