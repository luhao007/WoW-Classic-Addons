local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Fun=addonTable.Fun
local Create=addonTable.Create
local PIGLine=Create.PIGLine
local PIGFrame=Create.PIGFrame
local PIGCloseBut = Create.PIGCloseBut
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
--------
local BusinessInfo=addonTable.BusinessInfo
local disp_time=Fun.disp_time
function BusinessInfo.FBCD()
	local StatsInfo = StatsInfo_UI
	PIGA["StatsInfo"]["FubenCD"][StatsInfo.allname]=PIGA["StatsInfo"]["FubenCD"][StatsInfo.allname] or {}
	local fujiF,fujiTabBut=PIGOptionsList_R(StatsInfo.F,"副\n本",StatsInfo.butW,"Left")
	fujiF:Show()
	fujiTabBut:Selected()
	----
	local hang_Height,hang_NUM  = 20.6, 22;
	local function Get_FubenCD()
		local fubenCDinfo={{},{}};
		local numInstances = GetNumSavedInstances();
		if numInstances>0 then
			for id = 1, numInstances, 1 do				
				local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(id)
				--print(name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress)
				if isRaid then
					table.insert(fubenCDinfo[2],{"raid",name,difficultyName,GetTime(),reset})
				else
					table.insert(fubenCDinfo[1],{"party",name,difficultyName,GetTime(),reset})
				end
			end
		end
		PIGA["StatsInfo"]["FubenCD"][StatsInfo.allname]=fubenCDinfo
	end
	--
	local function gengxin_partyCD(self)
		if not fujiF:IsVisible() then return end
		for id = 1, hang_NUM, 1 do
			_G["PIG_partyCD_"..id]:Hide();
		end
	   	local cdmulu={};
	   	local PlayerData = PIGA["StatsInfo"]["Players"]
	   	for k,v in pairs(PlayerData) do
	   		local PartyData  = PIGA["StatsInfo"]["FubenCD"][k][1]
	   		if #PartyData>0 then
	   			table.insert(cdmulu,{"juese",k,v[1],v[2],v[3],v[4],v[5]})
		   		for nn=1,#PartyData do
		   			table.insert(cdmulu,PartyData[nn])
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
					local fujik = _G["PIG_partyCD_"..id]
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
						local className, classFile, classID = GetClassInfo(cdmulu[dangqian][6])
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
						local nametxt = cdmulu[dangqian][2].."\124cff66FF11["..cdmulu[dangqian][3].."]\124r"
						local shengyu=cdmulu[dangqian][4]+cdmulu[dangqian][5]-GetTime();
						if shengyu>0 then
							nametxt=nametxt.." "..disp_time(shengyu)
						else
							nametxt=nametxt.."|cFF00FF00 新CD！|r";
						end
						fujik.name:SetText(nametxt);
					end
				end
			end
		end
	end
	--=======
	fujiF.lineC = PIGLine(fujiF,"C",nil,nil,nil,{0,0,0,0.5})
	fujiF.partyCD=PIGFrame(fujiF)
	fujiF.partyCD:SetPoint("TOPLEFT",fujiF,"TOPLEFT",4,-2);
	fujiF.partyCD:SetPoint("BOTTOMRIGHT",fujiF.lineC,"BOTTOMLEFT",-4,2);
	fujiF.partyCD.title = PIGFontString(fujiF.partyCD,{"TOP", fujiF.partyCD, "TOP", 0, -2},"冷却中的"..DUNGEONS)
	fujiF.partyCD.title:SetTextColor(0, 1, 0, 1);
	fujiF.partyCD.lineTOP = PIGLine(fujiF.partyCD,"TOP",-20,nil,nil,{0.3,0.3,0.3,0.3})
	------
	fujiF.partyCD.Scroll = CreateFrame("ScrollFrame",nil,fujiF.partyCD, "FauxScrollFrameTemplate");  
	fujiF.partyCD.Scroll:SetPoint("TOPLEFT",fujiF.partyCD.lineTOP,"BOTTOMLEFT",4,-4);
	fujiF.partyCD.Scroll:SetPoint("BOTTOMRIGHT",fujiF.partyCD,"BOTTOMRIGHT",-20,2);
	fujiF.partyCD.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, gengxin_partyCD)
	end)
	for id = 1, hang_NUM, 1 do
		local hang = CreateFrame("Frame", "PIG_partyCD_"..id, fujiF.partyCD);
		hang:SetSize(fujiF.partyCD:GetWidth()-18,hang_Height);
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.partyCD.Scroll, "TOPLEFT", 0, -1);
		else
			hang:SetPoint("TOPLEFT", _G["PIG_partyCD_"..id-1], "BOTTOMLEFT", 0, -1);
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
	--
	local function gengxin_raidCD(self)
		if not fujiF:IsVisible() then return end
		for id = 1, hang_NUM, 1 do
			_G["PIG_raidCD_"..id]:Hide();
		end
	   	local cdmulu={};
	   	local PlayerData = PIGA["StatsInfo"]["Players"]
	   	for k,v in pairs(PlayerData) do
	   		local raidData  = PIGA["StatsInfo"]["FubenCD"][k][2]
	   		if #raidData>0 then
	   			table.insert(cdmulu,{"juese",k,v[1],v[2],v[3],v[4],v[5]})
		   		for nn=1,#raidData do
		   			table.insert(cdmulu,raidData[nn])
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
					local fujik = _G["PIG_raidCD_"..id]
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
						local className, classFile, classID = GetClassInfo(cdmulu[dangqian][6])
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
						local nametxt = cdmulu[dangqian][2].."\124cff66FF11["..cdmulu[dangqian][3].."]\124r"
						local shengyu=cdmulu[dangqian][4]+cdmulu[dangqian][5]-GetTime();
						if shengyu>0 then
							nametxt=nametxt.." "..disp_time(shengyu)
						else
							nametxt=nametxt.."|cFF00FF00 新CD！|r";
						end
						fujik.name:SetText(nametxt);
					end
				end
			end
		end
	end
	fujiF.raidCD=PIGFrame(fujiF)
	fujiF.raidCD:SetPoint("TOPRIGHT",fujiF,"TOPRIGHT",-4,-2);
	fujiF.raidCD:SetPoint("BOTTOMLEFT",fujiF.lineC,"BOTTOMRIGHT",4,2);
	fujiF.raidCD.title = PIGFontString(fujiF.raidCD,{"TOP", fujiF.raidCD, "TOP", 0, -2},"冷却中的"..GUILD_INTEREST_RAID)
	fujiF.raidCD.title:SetTextColor(0, 1, 0, 1);
	fujiF.raidCD.lineTOP = PIGLine(fujiF.raidCD,"TOP",-20,nil,nil,{0.3,0.3,0.3,0.3})
	fujiF.raidCD.Scroll = CreateFrame("ScrollFrame",nil,fujiF.raidCD, "FauxScrollFrameTemplate");  
	fujiF.raidCD.Scroll:SetPoint("TOPLEFT",fujiF.raidCD.lineTOP,"BOTTOMLEFT",4,-4);
	fujiF.raidCD.Scroll:SetPoint("BOTTOMRIGHT",fujiF.raidCD,"BOTTOMRIGHT",-20,2);
	fujiF.raidCD.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, gengxin_raidCD)
	end)
	for id = 1, hang_NUM, 1 do
		local hang = CreateFrame("Frame", "PIG_raidCD_"..id, fujiF.raidCD);
		hang:SetSize(fujiF.raidCD:GetWidth()-18,hang_Height);
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.raidCD.Scroll, "TOPLEFT", 0, -1);
		else
			hang:SetPoint("TOPLEFT", _G["PIG_raidCD_"..id-1], "BOTTOMLEFT", 0, -1);
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
	fujiF:HookScript("OnShow", function(self)
		gengxin_partyCD(self.partyCD.Scroll);
		gengxin_raidCD(self.raidCD.Scroll)
		RequestRaidInfo()
	end)
	-------
	C_Timer.After(2,Get_FubenCD)          
	fujiF:RegisterEvent("UPDATE_INSTANCE_INFO");
	fujiF:SetScript("OnEvent", function(self,event,arg1)
		Get_FubenCD()
		gengxin_partyCD(self.partyCD.Scroll);
		gengxin_raidCD(self.raidCD.Scroll)
	end)
end
