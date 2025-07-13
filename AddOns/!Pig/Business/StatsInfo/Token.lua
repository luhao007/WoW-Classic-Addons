local addonName, addonTable = ...;
local L=addonTable.locale
local Create=addonTable.Create
local fmod=math.fmod
local gsub = _G.string.gsub
local PIGLine=Create.PIGLine
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
--------
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.Token(StatsInfo)
	local fujiF,fujiTabBut=PIGOptionsList_R(StatsInfo.F,"货\n币",StatsInfo.butW,"Left")
	---
	local hang_Height,hang_NUM,numButtons  = StatsInfo.hang_Height, 11, 26;
	fujiF.NR=PIGFrame(fujiF)
	fujiF.NR:SetPoint("TOPLEFT",fujiF,"TOPLEFT",4,-40);
	fujiF.NR:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",-4,4);
	fujiF.NR:PIGSetBackdrop(0)
	fujiF.NR.title = PIGFontString(fujiF.NR,{"BOTTOMLEFT", fujiF.NR, "TOPLEFT", 4, 22},ICON_TAG_RAID_TARGET_STAR3..TOTAL..": ")
	fujiF.NR.title:SetTextColor(0, 1, 0, 1);
	fujiF.NR.ALLG = PIGFontString(fujiF.NR,{"LEFT", fujiF.NR.title, "RIGHT", 0, 0},0)
	fujiF.NR.ALLG:SetTextColor(1, 1, 1, 1);
	fujiF.NR.ServerALLG = PIGFontString(fujiF.NR,{"TOPLEFT", fujiF.NR.title, "BOTTOMLEFT", 0, -2},0)
	fujiF.NR.ServerALLG:SetTextColor(1, 1, 1, 1);

	fujiF.NR.Scroll = CreateFrame("ScrollFrame",nil,fujiF.NR, "FauxScrollFrameTemplate");  
	fujiF.NR.Scroll:SetPoint("TOPLEFT",fujiF.NR,"TOPLEFT",2,-2);
	fujiF.NR.Scroll:SetPoint("BOTTOMRIGHT",fujiF.NR,"BOTTOMRIGHT",-19,2);
	fujiF.NR.Scroll:SetScale(0.8);
	fujiF.NR.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fujiF.NR.Update_hang)
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
		hang.Tokens = CreateFrame("Frame", nil, hang);
		hang.Tokens:SetPoint("LEFT", hang.Class, "RIGHT", 186,0);
		hang.Tokens:SetSize(hang_Height,hang_Height);
		hang.Tokens.listbut={}
		for but=1,numButtons do
			local TokenBut = CreateFrame("Button",nil,hang.Tokens);
			hang.Tokens.listbut[but]=TokenBut
			TokenBut:SetSize(hang_Height,hang_Height);
			if but~=1 then
				TokenBut.Tex = TokenBut:CreateTexture();
				TokenBut.Tex:SetPoint("CENTER",0,0);
				TokenBut.Tex:SetSize(hang_Height,hang_Height);
				if but==2 then
					TokenBut:SetPoint("LEFT", hang.Tokens, "LEFT", 48,0);
				elseif but==11 then
					TokenBut:SetPoint("TOPLEFT", hang.Tokens.listbut[1], "BOTTOMLEFT", 0,-1);
				else
					TokenBut:SetPoint("LEFT", hang.Tokens.listbut[but-1], "RIGHT", 48,0);
				end	
				TokenBut.num = PIGFontString(TokenBut,{"RIGHT", TokenBut, "LEFT", -2, 0},0)
			else
				TokenBut:SetPoint("RIGHT", hang.Tokens, "LEFT", 0,0);
				TokenBut.num = PIGFontString(TokenBut,{"RIGHT", TokenBut, "RIGHT", -2, 0},0)
			end
			TokenBut.num:SetTextColor(1, 1, 1, 1);
		end
	end
	fujiF.NR:HookScript("OnShow", function(self)
		self.Update_hang();
	end)
	function fujiF.NR.Update_hang()
		if not fujiF:IsVisible() then return end
		for id = 1, hang_NUM, 1 do
			local hang = fujiF.NR.listbut[id]
			hang:Hide();
			hang.nameDQ:Hide()
			for but=1,numButtons do
				local paizibut = hang.Tokens.listbut[but]
				paizibut:Hide()
			end
		end
		local cdmulu={};
		local jibihejiV={["all"]=0,["saverall"]={},["hejitxt"]=""}
		local PlayerData = PIGA["StatsInfo"]["Players"]
		local PlayerSH = PIGA["StatsInfo"]["PlayerSH"]
		if PlayerData[StatsInfo.allname] and not PlayerSH[StatsInfo.allname] then
			local dangqianC=PlayerData[StatsInfo.allname]
			local Money  = PIGA["StatsInfo"]["Token"][StatsInfo.allname]["Money"]
   			jibihejiV.all=jibihejiV.all+Money
   			local _, fuwuqiXC = strsplit("-", StatsInfo.allname);
   			if fuwuqiXC and fuwuqiXC~="" then
				jibihejiV.saverall[fuwuqiXC]=jibihejiV.saverall[fuwuqiXC] or 0
   				jibihejiV.saverall[fuwuqiXC]=jibihejiV.saverall[fuwuqiXC]+Money
   			end
   			local Tokens  = PIGA["StatsInfo"]["Token"][StatsInfo.allname]["Tokens"]
			table.insert(cdmulu,{StatsInfo.allname,dangqianC[1],dangqianC[2],dangqianC[3],dangqianC[4],dangqianC[5],{Money,Tokens},true})
		end
	   	for k,v in pairs(PlayerData) do
	   		if k~=StatsInfo.allname and PlayerData[k] and not PlayerSH[k] then
	   			local Money  = PIGA["StatsInfo"]["Token"][k]["Money"]
	   			local Tokens  = PIGA["StatsInfo"]["Token"][k]["Tokens"]
	   			jibihejiV.all=jibihejiV.all+Money
	   			local _, fuwuqiXC = strsplit("-", k);
	   			if fuwuqiXC and fuwuqiXC~="" and Money>100 then
					jibihejiV.saverall[fuwuqiXC]=jibihejiV.saverall[fuwuqiXC] or 0
	   				jibihejiV.saverall[fuwuqiXC]=jibihejiV.saverall[fuwuqiXC]+Money
	   			end
	   			table.insert(cdmulu,{k,v[1],v[2],v[3],v[4],v[5],{Money,Tokens}})
	   		end
	   	end

	   	fujiF.NR.ALLG:SetText(GetMoneyString(jibihejiV.all))
	   	jibihejiV.hejitxt_seerver=""
	   	for k,v in pairs(jibihejiV.saverall) do
	   		if v>9999 then
	   			local v=floor(v/10000)*10000
	   			jibihejiV.hejitxt_seerver=jibihejiV.hejitxt_seerver..k..GetMoneyString(v)..", "
	   		end
	   	end
	   	fujiF.NR.ServerALLG:SetText(jibihejiV.hejitxt_seerver)
		local ItemsNum = #cdmulu;
		if ItemsNum>0 then
			local ScrollUI=fujiF.NR.Scroll
		    FauxScrollFrame_Update(ScrollUI, ItemsNum, hang_NUM, hang_Height);
		    local offset = FauxScrollFrame_GetOffset(ScrollUI);
		    for id = 1, hang_NUM do
				local dangqian = id+offset;
				if cdmulu[dangqian] then
					local hang = fujiF.NR.listbut[id]
					hang:Show();
					if cdmulu[dangqian][2]=="Alliance" then
						hang.Faction:SetTexCoord(0,0.5,0,1);
					elseif cdmulu[dangqian][2]=="Horde" then
						hang.Faction:SetTexCoord(0.5,1,0,1);
					end
					hang.Race:SetAtlas(cdmulu[dangqian][4]);
					local className, classFile, classID = PIGGetClassInfo(cdmulu[dangqian][5])
					hang.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
					hang.level:SetText(cdmulu[dangqian][6]);
					if cdmulu[dangqian][8] then
						hang.nameDQ:Show()
					end
					hang.name:SetText(cdmulu[dangqian][1]);
					local color = PIG_CLASS_COLORS[classFile];
					hang.name:SetTextColor(color.r, color.g, color.b, 1);
					local paizibut = hang.Tokens.listbut[1]
					paizibut:Show()
					paizibut.num:SetText(GetMoneyString(cdmulu[dangqian][7][1]))
					--
					local paiziD = cdmulu[dangqian][7][2]
					paizibut.butindex = 1
					for but=1,#paiziD do
						if paiziD[but][2]>0 then
							paizibut.butindex=paizibut.butindex+1
							local paizibut = hang.Tokens.listbut[paizibut.butindex]
							paizibut:Show()
							if paiziD[but][1]==136998 or paiziD[but][1]==137000 then
								paizibut.Tex:SetTexCoord(0.07,0.59,0,0.58);
							end
							paizibut.Tex:SetTexture(paiziD[but][1])
							paizibut.num:SetText(paiziD[but][2])
							paizibut:SetScript("OnEnter", function (self)
								GameTooltip:ClearLines();
								GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
								-- GameTooltip:SetCurrencyTokenByID(paiziD[but][3])
								GameTooltip:SetText(paiziD[but][4]);
								GameTooltip:Show();
							end);
							paizibut:SetScript("OnLeave", function ()
								GameTooltip:ClearLines();
								GameTooltip:Hide() 
							end);
						end
					end
				end
			end
		end
	end
	---
	local function PIGGetMoney()
		PIGA["StatsInfo"]["Token"][StatsInfo.allname]["Money"]=GetMoney()
	end
	local function GetTokenInfo()
		local TokensInfo = {}
		if PIG_MaxTocversion(100000) then
			local currencyListSize = numButtons
			for index=1,currencyListSize do
				local name, isHeader, isExpanded, isUnused, isWatched, count, icon, maxQuantity, maxEarnable, quantityEarned, isTradeable, itemID = GetCurrencyListInfo(index)
				if name and name ~= "" then
					if not isHeader and not isUnused then
						table.insert(TokensInfo,{icon,count,itemID,C_CurrencyInfo.GetCurrencyListLink(index)})
						--print(name, isHeader, isExpanded, isUnused, isWatched, count, icon, maxQuantity, maxEarnable, quantityEarned, isTradeable, itemID)
					end
				end
			end
		else
			local currencyListSize = C_CurrencyInfo.GetCurrencyListSize()
			for index=1,currencyListSize do
				local xinxiji = C_CurrencyInfo.GetCurrencyListInfo(index)	
				if xinxiji and xinxiji.iconFileID then
					if not xinxiji.isHeader and not xinxiji.isTypeUnused then
						table.insert(TokensInfo,{xinxiji.iconFileID,xinxiji.quantity,"",C_CurrencyInfo.GetCurrencyListLink(index)})
					end
				end
			end
		end
		PIGA["StatsInfo"]["Token"][StatsInfo.allname]["Tokens"]=TokensInfo
	end
	local function jiazaiTokenInfo()
		C_Timer.After(1,PIGGetMoney)
		C_Timer.After(1,GetTokenInfo)
		fujiF:RegisterEvent("PLAYER_MONEY")
		fujiF:RegisterEvent("PLAYER_MONEY")
	end
	C_Timer.After(2,jiazaiTokenInfo)
	fujiF:RegisterEvent("PLAYER_ENTERING_WORLD")       
	fujiF:SetScript("OnEvent", function(self,event,arg1)
		if event=="PLAYER_ENTERING_WORLD" then
			C_Timer.After(1,jiazaiTokenInfo)
		elseif event=="PLAYER_MONEY" then
			PIGGetMoney()
		end
	end)
end
