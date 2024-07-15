local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local fmod=math.fmod
local gsub = _G.string.gsub
local PIGLine=Create.PIGLine
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGCloseBut = Create.PIGCloseBut
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
--------
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.Admin()
	local StatsInfo = StatsInfo_UI
	local fujiF,fujiTabBut=PIGOptionsList_R(StatsInfo.F,"角\n色",StatsInfo.butW,"Left")
	---
	local hang_Height,hang_NUM,UIWWW  = 24, 17,fujiF:GetWidth()*0.5;
	fujiF.Admin=PIGFrame(fujiF)
	fujiF.Admin:SetPoint("TOPLEFT",fujiF,"TOPLEFT",2,-2);
	fujiF.Admin:SetPoint("BOTTOMLEFT",fujiF,"BOTTOMLEFT",0,2);
	fujiF.Admin:SetWidth(UIWWW-20)
	fujiF.Admin.title = PIGFontString(fujiF.Admin,{"TOPLEFT", fujiF.Admin, "TOPLEFT", 4, -4},SHOW..CHARACTER)
	fujiF.Admin.title:SetTextColor(0, 1, 0, 1);
	fujiF.Admin.lineTOP = PIGLine(fujiF.Admin,"TOP",-24,nil,nil,{0.3,0.3,0.3,0.8})

	local function gengxin_List(self)
		if not fujiF:IsVisible() then return end
		for id = 1, hang_NUM, 1 do
			local fujik = _G["PIG_Admin_"..id]
			fujik:Hide();
			fujik.nameDQ:Hide()
		end
		local cdmulu={};
		local PlayerData = PIGA["StatsInfo"]["Players"]
		local PlayerSH = PIGA["StatsInfo"]["PlayerSH"]	
	   	if PlayerData[StatsInfo.allname] and not PlayerSH[StatsInfo.allname] then
	   		local dangqianC=PlayerData[StatsInfo.allname]
	   		table.insert(cdmulu,{StatsInfo.allname,dangqianC,true})
	   	end
   		for k,v in pairs(PlayerData) do
	   		if k~=StatsInfo.allname and PlayerData[k] and not PlayerSH[k] then
	   			table.insert(cdmulu,{k,v})
	   		end
	   	end
		local ItemsNum = #cdmulu;
		if ItemsNum>0 then
		    FauxScrollFrame_Update(self, ItemsNum, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(self);
		    for id = 1, hang_NUM do
				local dangqian = id+offset;
				if cdmulu[dangqian] then
					local fujik = _G["PIG_Admin_"..id]
					fujik:Show();
					fujik.allname=cdmulu[dangqian][1]
					fujik.name:SetText(cdmulu[dangqian][1]);
					if cdmulu[dangqian][2][1]=="Alliance" then
						fujik.Faction:SetTexCoord(0,0.5,0,1);
					elseif cdmulu[dangqian][2][1]=="Horde" then
						fujik.Faction:SetTexCoord(0.5,1,0,1);
					end
					fujik.Race:SetAtlas(cdmulu[dangqian][2][3]);
					local className, classFile, classID = GetClassInfo(cdmulu[dangqian][2][4])
					fujik.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
					fujik.level:SetText("("..cdmulu[dangqian][2][5]..")");
					local color = PIG_CLASS_COLORS[classFile];
					fujik.name:SetTextColor(color.r, color.g, color.b, 1);
					if cdmulu[dangqian][3] then
						fujik.nameDQ:Show()
					end	
				end
			end
		end
	end
	fujiF.Admin.Scroll = CreateFrame("ScrollFrame",nil,fujiF.Admin, "FauxScrollFrameTemplate");  
	fujiF.Admin.Scroll:SetPoint("TOPLEFT",fujiF.Admin.lineTOP,"BOTTOMLEFT",2,-2);
	fujiF.Admin.Scroll:SetPoint("BOTTOMRIGHT",fujiF.Admin,"BOTTOMRIGHT",-20,2);
	fujiF.Admin.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, gengxin_List)
	end)
	for id = 1, hang_NUM, 1 do
		local hang = CreateFrame("Frame", "PIG_Admin_"..id, fujiF.Admin);
		hang:SetSize(fujiF.Admin:GetWidth()-18,hang_Height+4);
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.Admin.Scroll, "TOPLEFT", 0, 0);
		else
			hang:SetPoint("TOPLEFT", _G["PIG_Admin_"..id-1], "BOTTOMLEFT", 0, 0);
		end
		if id~=hang_NUM then
			hang.line = PIGLine(hang,"BOT",0,nil,nil,{0.3,0.3,0.3,0.6})
		end
		hang.Faction = hang:CreateTexture();
		hang.Faction:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
		hang.Faction:SetPoint("LEFT", hang, "LEFT", 0,0);
		hang.Faction:SetSize(hang_Height,hang_Height);
		hang.Race = hang:CreateTexture();
		hang.Race:SetTexture("Interface/Glues/CharacterCreate/CharacterCreateIcons")
		hang.Race:SetPoint("LEFT", hang.Faction, "RIGHT", 1,0);
		hang.Race:SetSize(hang_Height,hang_Height);
		hang.Class = hang:CreateTexture();
		hang.Class:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
		hang.Class:SetPoint("LEFT", hang.Race, "RIGHT", 1,0);
		hang.Class:SetSize(hang_Height,hang_Height);
		hang.level = PIGFontString(hang,{"LEFT", hang.Class, "RIGHT", 2, 0},1)
		hang.level:SetTextColor(1,0.843,0, 1);
		hang.name = PIGFontString(hang,{"LEFT", hang.level, "RIGHT", 0, 0})
		hang.nameDQ = hang:CreateTexture();
		hang.nameDQ:SetTexture("interface/common/indicator-green.blp")
		hang.nameDQ:SetPoint("LEFT", hang.name, "RIGHT", 1,0);
		hang.nameDQ:SetSize(hang_Height-2,hang_Height-2);
		hang.del=PIGCloseBut(hang,{"RIGHT", hang, "RIGHT", 0,0},{hang_Height,hang_Height})
		hang.del:SetScript("OnClick", function (self)
			local wanjianame = self:GetParent().allname
			fujiF.caozuoshuaxin("del",wanjianame)
		end);
		hang.hide = PIGButton(hang,{"RIGHT", hang.del, "LEFT", -8,0},{hang_Height*2,hang_Height-4},HIDE);
		hang.hide:SetScript("OnClick", function (self)
			local wanjianame = self:GetParent().allname
			fujiF.caozuoshuaxin("hide",wanjianame)
		end);
	end
	-----
	fujiF.Admin_Hide=PIGFrame(fujiF)
	fujiF.Admin_Hide:SetPoint("TOPRIGHT",fujiF,"TOPRIGHT",-2,-2);
	fujiF.Admin_Hide:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",0,2);
	fujiF.Admin_Hide:SetWidth(UIWWW-20)
	fujiF.Admin_Hide.title = PIGFontString(fujiF.Admin_Hide,{"TOPLEFT", fujiF.Admin_Hide, "TOPLEFT", 4, -4},HIDE..CHARACTER.."(此列表角色只是未显示，数据并未删除)")
	fujiF.Admin_Hide.title:SetTextColor(1, 0.2, 0, 1);
	fujiF.Admin_Hide.lineTOP = PIGLine(fujiF.Admin_Hide,"TOP",-24,nil,nil,{0.3,0.3,0.3,0.8})
	local function gengxin_List_Hide(self)
		if not fujiF:IsVisible() then return end
		for id = 1, hang_NUM, 1 do
			local fujik=_G["PIG_Admin_Hide_"..id]
			fujik:Hide();
			fujik.nameDQ:Hide()
		end
		local cdmulu={};
		local PlayerData = PIGA["StatsInfo"]["Players"]
		local PlayerSH = PIGA["StatsInfo"]["PlayerSH"]
	   	if PlayerSH[StatsInfo.allname] then
	   		local dangqianC=PlayerData[StatsInfo.allname]
	   		table.insert(cdmulu,{StatsInfo.allname,dangqianC,true})
	   	end
   		for k,v in pairs(PlayerData) do
	   		if k~=StatsInfo.allname and PlayerSH[k] then
	   			table.insert(cdmulu,{k,v})
	   		end
	   	end
		local ItemsNum = #cdmulu;
		if ItemsNum>0 then
		    FauxScrollFrame_Update(self, ItemsNum, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(self);
		    for id = 1, hang_NUM do
				local dangqian = id+offset;
				if cdmulu[dangqian] then
					local fujik = _G["PIG_Admin_Hide_"..id]
					fujik:Show();
					fujik.allname=cdmulu[dangqian][1]
					fujik.name:SetText(cdmulu[dangqian][1]);
					if cdmulu[dangqian][2][1]=="Alliance" then
						fujik.Faction:SetTexCoord(0,0.5,0,1);
					elseif cdmulu[dangqian][2][1]=="Horde" then
						fujik.Faction:SetTexCoord(0.5,1,0,1);
					end
					fujik.Race:SetAtlas(cdmulu[dangqian][2][3]);
					local className, classFile, classID = GetClassInfo(cdmulu[dangqian][2][4])
					fujik.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
					fujik.level:SetText("("..cdmulu[dangqian][2][5]..")");
					local color = PIG_CLASS_COLORS[classFile];
					fujik.name:SetTextColor(color.r, color.g, color.b, 1);
					if cdmulu[dangqian][3] then
						fujik.nameDQ:Show()
					end	
				end
			end
		end
	end
	fujiF.Admin_Hide.Scroll = CreateFrame("ScrollFrame",nil,fujiF.Admin_Hide, "FauxScrollFrameTemplate");  
	fujiF.Admin_Hide.Scroll:SetPoint("TOPLEFT",fujiF.Admin_Hide.lineTOP,"BOTTOMLEFT",2,-2);
	fujiF.Admin_Hide.Scroll:SetPoint("BOTTOMRIGHT",fujiF.Admin_Hide,"BOTTOMRIGHT",-20,2);
	fujiF.Admin_Hide.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, gengxin_List_Hide)
	end)
	for id = 1, hang_NUM, 1 do
		local hang = CreateFrame("Frame", "PIG_Admin_Hide_"..id, fujiF.Admin_Hide);
		hang:SetSize(fujiF.Admin_Hide:GetWidth()-18,hang_Height+4);
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.Admin_Hide.Scroll, "TOPLEFT", 0, 0);
		else
			hang:SetPoint("TOPLEFT", _G["PIG_Admin_Hide_"..id-1], "BOTTOMLEFT", 0, 0);
		end
		if id~=hang_NUM then
			hang.line = PIGLine(hang,"BOT",0,nil,nil,{0.3,0.3,0.3,0.6})
		end
		hang.Faction = hang:CreateTexture();
		hang.Faction:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
		hang.Faction:SetPoint("LEFT", hang, "LEFT", 0,0);
		hang.Faction:SetSize(hang_Height,hang_Height);
		hang.Race = hang:CreateTexture();
		hang.Race:SetTexture("Interface/Glues/CharacterCreate/CharacterCreateIcons")
		hang.Race:SetPoint("LEFT", hang.Faction, "RIGHT", 1,0);
		hang.Race:SetSize(hang_Height,hang_Height);
		hang.Class = hang:CreateTexture();
		hang.Class:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
		hang.Class:SetPoint("LEFT", hang.Race, "RIGHT", 1,0);
		hang.Class:SetSize(hang_Height,hang_Height);
		hang.level = PIGFontString(hang,{"LEFT", hang.Class, "RIGHT", 2, 0},1)
		hang.level:SetTextColor(1,0.843,0, 1);
		hang.name = PIGFontString(hang,{"LEFT", hang.level, "RIGHT", 0, 0})
		hang.nameDQ = hang:CreateTexture();
		hang.nameDQ:SetTexture("interface/common/indicator-green.blp")
		hang.nameDQ:SetPoint("LEFT", hang.name, "RIGHT", 1,0);
		hang.nameDQ:SetSize(hang_Height-2,hang_Height-2);
		hang.del=PIGCloseBut(hang,{"RIGHT", hang, "RIGHT", 0,0},{hang_Height,hang_Height})
		hang.del:SetScript("OnClick", function (self)
			local wanjianame = self:GetParent().allname
			fujiF.caozuoshuaxin("del",wanjianame)
		end);
		hang.hide = PIGButton(hang,{"RIGHT", hang.del, "LEFT", -8,0},{hang_Height*2,hang_Height-4},SHOW);
		hang.hide:SetScript("OnClick", function (self)
			local wanjianame = self:GetParent().allname
			fujiF.caozuoshuaxin("show",wanjianame)
		end);
	end
	------------
	function fujiF.caozuoshuaxin(ly,name)
		if ly=="del" then
			PIGA["StatsInfo"]["Players"][name]=nil
			PIGA["StatsInfo"]["Token"][name]=nil
			PIGA["StatsInfo"]["SkillCD"][name]=nil
			PIGA["StatsInfo"]["FubenCD"][name]=nil
			PIGA["StatsInfo"]["Items"][name]=nil
			PIGA["StatsInfo"]["PlayerSH"][name]=nil
		elseif ly=="hide" then
			PIGA["StatsInfo"]["PlayerSH"][name]=true
		elseif ly=="show" then
			PIGA["StatsInfo"]["PlayerSH"][name]=nil
		end
		gengxin_List(fujiF.Admin.Scroll);
		gengxin_List_Hide(fujiF.Admin_Hide.Scroll);
	end
	fujiF:HookScript("OnShow", function(self)
		gengxin_List(self.Admin.Scroll);
		gengxin_List_Hide(self.Admin_Hide.Scroll);
	end)
end
