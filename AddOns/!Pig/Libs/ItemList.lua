local addonName, addonTable = ...;
local L=addonTable.locale
local match = _G.string.match
local find = _G.string.find
--
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
local BackdropColor=Create.BackdropColor
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
local PIGDiyTex=Create.PIGDiyTex
---
local Data=addonTable.Data
local InvSlot=Data.InvSlot
local EnchantItemID=Data.EnchantItemID
local EnchantSpellID=Data.EnchantSpellID
local EnchantSlot=Data.EnchantSlot
local EngravingSlot=Data.EngravingSlot
local EnchantSlotID=Data.EnchantSlotID
local TalentData=Data.TalentData
--
local Fun=addonTable.Fun
local GetRuneData=Fun.GetRuneData
local GetItemStats=GetItemStats or C_Item and C_Item.GetItemStats
local GetItemGem=GetItemGem or C_Item and C_Item.GetItemGem
local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
local GetDetailedItemLevelInfo=GetDetailedItemLevelInfo or C_Item and C_Item.GetDetailedItemLevelInfo
local GetSpecialization = GetSpecialization or C_SpecializationInfo and C_SpecializationInfo.GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo or C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo
-------------
local ListWWWHHH = {206,425,18,36,6}--3Gembut/4buweiW/5宝石+附魔+符文数
--获取宝石槽位信息add
local function PIGGetGemList(Link)
	local baoshiinfo = {}
	if Link then
	    local statsg = GetItemStats(Link)
	    if statsg then
		    for key, num in pairs(statsg) do
		        if (key:match("EMPTY_SOCKET_")) then
		            for i = 1, num do
		                table.insert(baoshiinfo, _G[key])
		            end
		        end
		    end
		end
	end
    return baoshiinfo
end
local function ShowGemBut(Gemse,GemitemLink,nulltishi)
	if GemitemLink then
		Gemse.icon:SetDesaturated(false)
       	local _, _, quality, _, _, _, _, _, _, texture = GetItemInfo(GemitemLink)
       	local r, g, b = GetItemQualityColor(quality or 0)
       	Gemse.icon:SetTexture(texture)
    	Gemse:SetBackdropBorderColor(r, g, b, 1);
    else
    	Gemse.icon:SetDesaturated(true)
    	Gemse:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
    	if nulltishi==55655 then
    		local name, texture = PIGGetSpellInfo(55655)
    		Gemse.icon:SetTexture(texture)
	    else
	    	Gemse.icon:SetTexture(134071)
	    end
  	end
    Gemse:SetScript("OnEnter", function (self)
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
		if GemitemLink then
			GameTooltip:SetHyperlink(GemitemLink)
		else
			if nulltishi==55655 then
				GameTooltip:SetSpellByID(55655)
				GameTooltip:AddLine("|cff00FFFF["..addonName.."]:|r|cffFF0000"..WAISTSLOT.."未打孔|r")
			else
				GameTooltip:AddLine(nulltishi)
			end
		end
		GameTooltip:Show();
	end);
	Gemse:SetScript("OnLeave", function ()
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end);
end
local function PIG_SetGemInfo(Gemse,id,nulltishi,duixiang,Slot,itemLink)
	local _, GemitemLink = GetItemGem(itemLink, id)
	if GemitemLink then
		ShowGemBut(Gemse,GemitemLink)
	else
		Gemse.getnum=Gemse.getnum+1
		if Gemse:GetParent():GetParent():GetParent():IsShown() then
			if Gemse.getnum<5 then
				if Gemse.ItemGem then Gemse.ItemGem:Cancel() end
				Gemse.ItemGem=C_Timer.NewTimer(0.2,function()
					PIG_SetGemInfo(Gemse,id,nulltishi,duixiang,Slot,itemLink)
				end)
			else
				ShowGemBut(Gemse,GemitemLink,nulltishi)
			end
		end
	end
end
--显示附魔物品信息
local function PIGGetEnchantID(itemLink)
	local fumoid = itemLink:match("|?c?f?f?%x*|?Hitem:?%d+:?(%d*):?")
	if fumoid and fumoid~="" and fumoid~=" " then
		return tonumber(fumoid)
	end
	return 0
end
local function ShowEnchantInfo(EnchantBut,fumoid)
	local Newdata = {}
	if type(EnchantItemID[fumoid])=="table" then
		Newdata.ItemID=EnchantItemID[fumoid][1]
		Newdata.laiyuan=" 数据提供: "..EnchantItemID[fumoid][2]
	else
		Newdata.ItemID=EnchantItemID[fumoid]
		Newdata.laiyuan=""
	end
	GetItemInfo(Newdata.ItemID)
	local _, ItemLink, quality, _, _, _, _, _, _, texture = GetItemInfo(Newdata.ItemID)
	if ItemLink then
		EnchantBut.icon:SetTexture(texture)
		local r, g, b = GetItemQualityColor(quality or 0)
		EnchantBut:SetBackdropBorderColor(r, g, b, 1);
		EnchantBut:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
			if ItemLink then
				GameTooltip:SetHyperlink(ItemLink)
				GameTooltip:AddLine(ENCHANTS.."ID:"..fumoid..Newdata.laiyuan)
			else
				GameTooltip:AddLine("|cff00FFFF["..addonName.."]:|r"..ENCHANTS.."ID:"..fumoid..ENCHANTS..INFO..UNKNOWN)
			end

			GameTooltip:Show();
		end);
		EnchantBut:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
	else
		EnchantBut.getnum=EnchantBut.getnum+1
		if EnchantBut:GetParent():GetParent():GetParent():IsShown() then
			if EnchantBut.getnum<5 then
				if EnchantBut.EnchantInfo then EnchantBut.EnchantInfo:Cancel() end
				EnchantBut.EnchantInfo=C_Timer.NewTimer(0.2,function()
					ShowEnchantInfo(EnchantBut,fumoid)
				end)
			end
		end
	end
end
--显示符文
local function Show_fuwenBut(fuwenIcon,fwshuju)
	if fwshuju then				
		fuwenIcon:SetBackdropBorderColor(0, 1, 1, 0.8);
		fuwenIcon.icon:SetTexture(fwshuju[1])
		fuwenIcon.icon:SetDesaturated(false)
		fuwenIcon:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
			GameTooltip:SetEngravingRune(fwshuju[2]);
			GameTooltip:Show();
		end);
	end
end
local function Show_fuwenBut_yanchi(Parent,hangUI,fuwenIcon,k)
	if PIG_OptionsUI.talentData[Parent.cName] and PIG_OptionsUI.talentData[Parent.cName]["R"] and PIG_OptionsUI.talentData[Parent.cName]["R"][2][k] then
		Show_fuwenBut(fuwenIcon,PIG_OptionsUI.talentData[Parent.cName]["R"][2][k])
	else
		if Parent.fuwenBut_yanchi then Parent.fuwenBut_yanchi:Cancel() end
		Parent.fuwenBut_yanchi=C_Timer.NewTimer(0.3,function()
			Show_fuwenBut_yanchi(Parent,hangUI,fuwenIcon,k)
		end)
	end
end
---
local function GetNewWidthhang(Parent,fujikk)
	local width = fujikk.itemlink.t:GetStringWidth()+fujikk.itemlink.lv:GetStringWidth()
	fujikk.itemlink:SetWidth(width);
	local fangkuangNUM=fujikk.dataxInfo.baoshiNUM+fujikk.dataxInfo.fumoNum+fujikk.dataxInfo.fuwenNum
	fujikk.dataxInfo.hangWWWW = width+fangkuangNUM*(ListWWWHHH[3]+1)+ListWWWHHH[4]+18
	if fujikk.dataxInfo.hangWWWW>Parent.ALLWWWW then
		Parent.ALLWWWW=fujikk.dataxInfo.hangWWWW
	end
	return Parent.ALLWWWW
end
--获取物品套装
local function GettaozhuangInfo(dainfo,taoname,dangqian,zongshu,quality)
	local cunzaitaoz = true
	for ivv=1,#dainfo do
		if taoname==dainfo[ivv][1] then
			cunzaitaoz = false
			dainfo[ivv][2]=dainfo[ivv][2]+1
			dainfo[ivv][3]=zongshu
			break
		end
	end
	if cunzaitaoz then
		table.insert(dainfo,{taoname,1,zongshu,quality})
	end
	return dainfo
end
local function PIGGetTaozhuang(statsg)
	local taozhuainfo = {}
	for iv=1,#statsg do
		local newText=statsg[iv][1]:gsub("（","(");
		local newText=newText:gsub("）",")");
		local kaishi,jieshu,taoname,dangqian,zongshu = newText:find("(.+)%((%d)/(%d)%)")
		if taoname and dangqian and zongshu then
			if zongshu=="0" then
				return taozhuainfo
			else
				taozhuainfo = GettaozhuangInfo(taozhuainfo,taoname,dangqian,zongshu,statsg[iv][2])
			end
		end
	end
	return taozhuainfo
end
local function PIGGetItemStats(Parent,soltlink)
	if not Parent:IsVisible() then return end	
	if PIG_MaxTocversion() then
		PIG_TooltipUI:ClearLines();
		PIG_TooltipUI:SetHyperlink(soltlink)
		local quality = C_Item.GetItemQualityByID(soltlink) or 1
	    local hangname = PIG_TooltipUI:GetName()
	    local txtNum = PIG_TooltipUI:NumLines()
	    if txtNum then
	    	for g = 2, txtNum do
		    	local text = _G[hangname.."TextLeft" .. g]:GetText() or ""
		    	--local r, g, b = _G[hangname.."TextLeft" .. g]:GetTextColor()
		    	tinsert(Parent.allstats, {text,quality})
		    end
		end
	else
		local tooltipData = C_TooltipInfo.GetHyperlink(soltlink)
		local quality = C_Item.GetItemQualityByID(soltlink) or 1
		for _, line in ipairs(tooltipData.lines) do
		    tinsert(Parent.allstats, {line.leftText,quality})
		end
	end
end
local function ShowItemTaozhuang(Parent,datax)
	if Parent.taozhuangTicker then Parent.taozhuangTicker:Cancel() end
	Parent.taozhuangTicker=C_Timer.NewTimer(0.2,function()
		Parent.xuhaoID = 0
		wipe(Parent.allstats)
		for k,v in pairs(datax) do
			if PIG_MaxTocversion() then
				PIG_TooltipUI:ClearLines();
				PIG_TooltipUI:SetHyperlink(v)
			else
				C_TooltipInfo.GetHyperlink(v)
			end
		end
		for k,v in pairs(datax) do
			C_Timer.After(0.04*Parent.xuhaoID,function()
				PIGGetItemStats(Parent,v)
			end)
			Parent.xuhaoID=Parent.xuhaoID+1
		end
		Parent.xuhaoID=Parent.xuhaoID+1
		C_Timer.After(0.04*Parent.xuhaoID,function()
			if not Parent:IsVisible() then return end
			local taozhuang = PIGGetTaozhuang(Parent.allstats)
			local taozhuangNum = #taozhuang
			for tid=1,taozhuangNum do
				local taoui = Parent.ListTao[tid]--_G[Parent:GetName().."_".."tao_"..tid]
				taoui:SetText(string.format(BOSS_BANNER_LOOT_SET,taozhuang[tid][1].."("..taozhuang[tid][2].."/"..taozhuang[tid][3]..")"))
				local r, g, b =GetItemQualityColor(taozhuang[tid][4] or 0)
				taoui:SetTextColor(r, g, b,1);
				local taoui_width = taoui:GetStringWidth()+4
				if taoui_width>Parent.ALLWWWW then
					Parent.ALLWWWW=taoui_width
				end
			end
			if taozhuangNum>1 then
				Parent:SetHeight(ListWWWHHH[2]+(taozhuangNum-1)*(ListWWWHHH[3]-3))
			end
		end)
	end)
end
local function ShowItemList(Parent,unit,datax,fuwen)
	Parent.zhuangbeiInfo = {["allleve"]=0,["wuqixiuzhengV"]=""}
	Parent.ALLWWWW=ListWWWHHH[1]
	for k,v in pairs(datax) do
		if k~=4 and k~=19 then
			local itemLink=datax[k]
			if itemLink then
				local fujikk = Parent.ListHang[k]
				fujikk.dataxInfo = {["hangWWWW"]=0,["fumoNum"]=0,["fuwenNum"]=1}
				fujikk.t:SetTextColor(0, 1, 1, 0.8);
				fujikk:SetBackdropBorderColor(0, 1, 1, 0.5)
				local effectiveILvl, isPreview, baseILvl = GetDetailedItemLevelInfo(itemLink)
				if k~=16 and k~=17 and k~=18 then
					local effectiveILvl=effectiveILvl or 0
					Parent.zhuangbeiInfo.allleve=Parent.zhuangbeiInfo.allleve+effectiveILvl
				end
				fujikk.itemlink.lv:SetText(effectiveILvl)
				fujikk.itemlink.lv:SetTextColor(1, 1, 1, 1);
				fujikk.itemlink.t:SetText(itemLink)
				---	
				fujikk.itemlink:SetScript("OnEnter", function (self)
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
					if unit=="yc" or unit=="lx" then
						GameTooltip:SetHyperlink(itemLink)
					else
						GameTooltip:SetInventoryItem(unit, k)
					end
					fujikk:SetBackdropColor(0, 1, 1, 0.5)
					fujikk.t:SetTextColor(1, 1, 0.8, 1);
					GameTooltip:Show();
				end);
				fujikk.itemlink:SetScript("OnDoubleClick", function(self)
	                ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
	                ChatEdit_InsertLink(itemLink)
	            end)
	        	---
				local baoshiinfo=PIGGetGemList(itemLink)
				if PIG_MaxTocversion() and PIG_MaxTocversion(29999,true) and k==6 then table.insert(baoshiinfo,55655) end
			    local baoshiNUM=#baoshiinfo
			    fujikk.dataxInfo.baoshiNUM=baoshiNUM
				for Gemid=1,baoshiNUM do
					local Gemui = fujikk.ButGem[Gemid]
					Gemui:SetWidth(ListWWWHHH[3])
					Gemui:SetAlpha(1)
					Gemui.getnum=0
					PIG_SetGemInfo(Gemui,Gemid,baoshiinfo[Gemid],unit,k,itemLink)
				end
				---
				local fumoid = PIGGetEnchantID(itemLink)
				local Enchantui=fujikk.ButGem[5]
				if fumoid>0 then
					fujikk.dataxInfo.fumoNum=1
					Enchantui:SetWidth(ListWWWHHH[3])
					Enchantui:SetAlpha(1)
					Enchantui.icon:SetDesaturated(false)
					if EnchantItemID[fumoid] then
						Enchantui.getnum=0
						ShowEnchantInfo(Enchantui,fumoid)
					elseif EnchantSpellID[fumoid] then
						local name, texture = PIGGetSpellInfo(EnchantSpellID[fumoid])
						Enchantui.icon:SetTexture(texture)
						Enchantui:SetBackdropBorderColor(1, 0.843, 0, 0.8);
						Enchantui:SetScript("OnEnter", function (self)
							GameTooltip:ClearLines();
							GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
							GameTooltip:SetSpellByID(EnchantSpellID[fumoid])
							GameTooltip:Show();
						end);
					elseif EnchantSlotID[fumoid] then
						local itemID, itemType, itemSubType, itemEquipLoc = GetItemInfoInstant(itemLink)
						local EnchantSpell = EnchantSlotID[fumoid][itemEquipLoc]
						local name, texture = PIGGetSpellInfo(EnchantSpell)
						Enchantui.icon:SetTexture(texture)
						Enchantui:SetBackdropBorderColor(1, 0.843, 0, 0.8);
						Enchantui:SetScript("OnEnter", function (self)
							GameTooltip:ClearLines();
							GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
							GameTooltip:SetSpellByID(EnchantSpell)
							GameTooltip:Show();
						end);
					else
						Enchantui.icon:SetTexture(136244)
						Enchantui:SetBackdropBorderColor(1, 0.843, 0, 0.8);
						Enchantui:SetScript("OnEnter", function (self)
							GameTooltip:ClearLines();
							GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
							GameTooltip:AddLine(ENCHANTS.."ID:"..fumoid)
							GameTooltip:AddLine(UNKNOWN..ENCHANTS..INFO)
							GameTooltip:Show();
						end);
					end
				else
					if EnchantSlot[k] then
						fujikk.dataxInfo.fumoNum=1
						local itemID, itemType, itemSubType, itemEquipLoc = GetItemInfoInstant(itemLink)
						if k==17 and itemEquipLoc=="INVTYPE_HOLDABLE" then 
						else
							Enchantui:SetWidth(ListWWWHHH[3])
							Enchantui:SetAlpha(1)
							Enchantui.icon:SetDesaturated(true)
							Enchantui:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
							Enchantui.icon:SetTexture(136244)
							Enchantui:SetScript("OnEnter", function (self)
								GameTooltip:ClearLines();
								GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
								GameTooltip:AddLine("|cff00FFFF["..addonName.."]:|r|cffFF0000"..InvSlot["Name"][k][2]..NONE..ENCHANTS.."|r")
								GameTooltip:Show();
							end);
						end
					end
				end
				---
				if C_Engraving and C_Engraving.IsEngravingEnabled() then
					if EngravingSlot[k] then
						local fuwenIcon=fujikk.ButGem[6]
						fuwenIcon:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
						fuwenIcon:SetWidth(ListWWWHHH[3])
						fuwenIcon:SetAlpha(1)
						fuwenIcon.icon:SetDesaturated(true)
						fuwenIcon.icon:SetTexture(134419)
						fuwenIcon:SetScript("OnEnter", function (self)
								GameTooltip:ClearLines();
								GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
								GameTooltip:AddLine("|cff00FFFF["..addonName.."]:|r|cffFF0000"..InvSlot["Name"][k][2]..NONE..RUNES.."|r")
								GameTooltip:Show();
							end);
						if unit=="player" or unit=="lx" then
							if fuwen[k] then
								fujikk.dataxInfo.fuwenNum=1
								Show_fuwenBut(fuwenIcon,fuwen[k])
							end
						else
							if Parent.fuwenBut_yanchi then Parent.fuwenBut_yanchi:Cancel() end
							Parent.fuwenBut_yanchi=C_Timer.NewTimer(0.3,function()
								Show_fuwenBut_yanchi(Parent,fujikk,fuwenIcon,k)
							end)
						end
					end
				end
				Parent.ALLWWWW = GetNewWidthhang(Parent,fujikk)
			end
		end
	end
	--装等
	if GetAverageItemLevel and unit=="player" then
		local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = GetAverageItemLevel();
		Parent.pingjunLV_V:SetText(string.format("%.2f",avgItemLevelEquipped))
	elseif _G[Data.LongInspectUIUIname].ZBLsit.itemLV then
		Parent.pingjunLV_V:SetText(string.format("%.2f",_G[Data.LongInspectUIUIname].ZBLsit.itemLV))
	else
		local wuqiLV={{0,"null"},{0,"null"},{0,"null"}}
		if datax[16] then
			wuqiLV[1][1] = GetDetailedItemLevelInfo(datax[16])
			local itemID, itemType, itemSubType, itemEquipLoc = GetItemInfoInstant(datax[16])
			wuqiLV[1][2]=itemEquipLoc
		end
		if datax[17] then
			wuqiLV[2][1] = GetDetailedItemLevelInfo(datax[17])
			local itemID, itemType, itemSubType, itemEquipLoc = GetItemInfoInstant(datax[17])
			wuqiLV[2][2]=itemEquipLoc
		end
		--INVTYPE_2HWEAPON--双手
		--INVTYPE_WEAPONMAINHAND--主手
		--INVTYPE_SHIELD--副手
		--INVTYPE_WEAPON--单手
		if PIG_MaxTocversion() then
			if datax[18] then wuqiLV[3][1] = GetDetailedItemLevelInfo(datax[18]) end
			--新计算方式(主+副手/远程*2取其大者)
			if wuqiLV[1][1]>0 or wuqiLV[2][1]>0 or wuqiLV[3][1]>0 then
				if wuqiLV[1][2] == "INVTYPE_2HWEAPON" and wuqiLV[2][2] == "INVTYPE_2HWEAPON" then--泰坦之握双持双手
					local zuizhongwuqiLV = wuqiLV[1][1]+wuqiLV[2][1]
					Parent.zhuangbeiInfo.allleve = Parent.zhuangbeiInfo.allleve + zuizhongwuqiLV
				else
					if wuqiLV[1][2] == "INVTYPE_2HWEAPON" then--单双手武器
						local zuizhongwuqiLV = 0
						if Parent.zhiyeID==3 then
							local wuqizuidaV = max(wuqiLV[1][1],wuqiLV[3][1])
							zuizhongwuqiLV = wuqizuidaV*2
						else
							zuizhongwuqiLV = wuqiLV[1][1]*2
						end
						Parent.zhuangbeiInfo.allleve = Parent.zhuangbeiInfo.allleve + zuizhongwuqiLV
					else
						local zuizhongwuqiLV = 0
						if Parent.zhiyeID==3 then
							if wuqiLV[3][1]>wuqiLV[1][1] and wuqiLV[3][1]>wuqiLV[2][1] then
								zuizhongwuqiLV = wuqiLV[3][1]*2
							else
								zuizhongwuqiLV = wuqiLV[1][1]+wuqiLV[2][1]
							end
						else
							zuizhongwuqiLV = wuqiLV[1][1]+wuqiLV[2][1]
						end
						Parent.zhuangbeiInfo.allleve = Parent.zhuangbeiInfo.allleve + zuizhongwuqiLV
					end
				end
				if wuqiLV[1][2] == "INVTYPE_2HWEAPON" then--双手武器
					if wuqiLV[3][1]==0 then
						Parent.zhuangbeiInfo.wuqixiuzhengV=Parent.zhuangbeiInfo.wuqixiuzhengV.."-"
					end
				else
					if wuqiLV[1][1]==0 and wuqiLV[2][1]==0 then--缺主副手
						Parent.zhuangbeiInfo.wuqixiuzhengV=Parent.zhuangbeiInfo.wuqixiuzhengV.."--"
					elseif wuqiLV[1][1]==0 and wuqiLV[3][1]==0 then--缺主+远程
						Parent.zhuangbeiInfo.wuqixiuzhengV=Parent.zhuangbeiInfo.wuqixiuzhengV.."--"
					elseif wuqiLV[2][1]==0 and wuqiLV[3][1]==0 then--缺副+远程
						Parent.zhuangbeiInfo.wuqixiuzhengV=Parent.zhuangbeiInfo.wuqixiuzhengV.."--"
					elseif wuqiLV[1][1]==0 or wuqiLV[2][1]==0 or wuqiLV[3][1]==0 then--三槽缺1
						Parent.zhuangbeiInfo.wuqixiuzhengV=Parent.zhuangbeiInfo.wuqixiuzhengV.."-"
					end
				end
			end
		else
			if wuqiLV[1][2] == "INVTYPE_RANGED" or wuqiLV[1][2] == "INVTYPE_RANGEDRIGHT" or wuqiLV[1][2] == "INVTYPE_2HWEAPON" then--远程/双手武器
				Parent.zhuangbeiInfo.allleve = Parent.zhuangbeiInfo.allleve + wuqiLV[1][1]+wuqiLV[1][1]
			else
				Parent.zhuangbeiInfo.allleve = Parent.zhuangbeiInfo.allleve + wuqiLV[1][1]+wuqiLV[2][1]
			end
		end
		local pingjunLvl = Parent.zhuangbeiInfo.allleve/16
		Parent.pingjunLV_V:SetText(string.format("%.2f",pingjunLvl).."|cffFF0000"..Parent.zhuangbeiInfo.wuqixiuzhengV.."|r")
	end
	--调整UI宽度
	local biaotiwidth1 = Parent.pingjunLV:GetStringWidth()+Parent.pingjunLV_V:GetStringWidth()
	local biaotiwidth2 = Parent.talent_1:GetStringWidth()+Parent.talent_1v:GetStringWidth()
	local biaotiwidth = biaotiwidth1+biaotiwidth2+ListWWWHHH[3]+14
	if biaotiwidth>Parent.ALLWWWW then
		Parent.ALLWWWW=biaotiwidth
	end
	Parent:SetWidth(Parent.ALLWWWW)
end
--获取装备信息
local function GetItemMuluData(Parent,unit,ItemData)
	local fuweninfo={}
	if unit=="player" then
		fuweninfo=GetRuneData()
	elseif unit=="lx" then
		if PIGA["StatsInfo"]["Items"][Parent.cName] and PIGA["StatsInfo"]["Items"][Parent.cName]["R"] then
			fuweninfo=PIGA["StatsInfo"]["Items"][Parent.cName]["R"]
		end
	end
	ShowItemList(Parent,unit,ItemData,fuweninfo)
	ShowItemTaozhuang(Parent,ItemData)
end
------
local function add_ItemList(fujik,miaodian,ziji)
	if GearManagerDialog then GearManagerDialog:SetFrameLevel(10) end
	local ZBLsit = PIGFrame(fujik,nil,{ListWWWHHH[1],ListWWWHHH[2]});
	ZBLsit.classes = ZBLsit:CreateTexture();
	ZBLsit.classes:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
	if NDui then
		ZBLsit:PIGSetBackdrop(0.5,nil,nil,nil,0);
		ZBLsit.LeftJG,ZBLsit.TopJG=4,3 
	else
		ZBLsit:PIGSetBackdrop(0.88,nil,nil,nil,0);
		ZBLsit.LeftJG,ZBLsit.TopJG=6,6
	end
	ZBLsit.classes:SetPoint("TOPLEFT",ZBLsit,"TOPLEFT",ZBLsit.LeftJG,-ZBLsit.TopJG);
	ZBLsit.classes:SetSize(20,20);
	ZBLsit.WJname = PIGFontString(ZBLsit,{"LEFT",ZBLsit.classes,"RIGHT",0,0},"","OUTLINE",15);

	ZBLsit.pingjunLV = PIGFontString(ZBLsit,{"TOPLEFT",ZBLsit,"TOPLEFT",ZBLsit.LeftJG,-24-ZBLsit.TopJG},STAT_AVERAGE_ITEM_LEVEL..":","OUTLINE");
	ZBLsit.pingjunLV_V = PIGFontString(ZBLsit,{"LEFT",ZBLsit.pingjunLV,"RIGHT",0,0},"--","OUTLINE");
	ZBLsit.pingjunLV_V:SetTextColor(1,1,1,1);
	ZBLsit.talentBut = CreateFrame("Button", nil, ZBLsit);
	ZBLsit.talentBut:SetPoint("TOPRIGHT",ZBLsit,"TOPRIGHT",-3,-20-ZBLsit.TopJG);
	ZBLsit.talentBut:SetSize(90,ListWWWHHH[3]+6);
	ZBLsit.talenthilight = ZBLsit.talentBut:CreateTexture(nil,"HIGHLIGHT");
	ZBLsit.talenthilight:SetTexture("interface/paperdollinfoframe/ui-character-tab-highlight.blp");
	ZBLsit.talenthilight:SetPoint("TOPLEFT",ZBLsit.talentBut,"TOPLEFT",-2,6);
	ZBLsit.talenthilight:SetPoint("BOTTOMRIGHT",ZBLsit.talentBut,"BOTTOMRIGHT",4,-6);
	ZBLsit.talenthilight:SetBlendMode("ADD")
	ZBLsit.talentTex = ZBLsit:CreateTexture();
	ZBLsit.talentTex:SetPoint("TOPRIGHT",ZBLsit,"TOPRIGHT",-ZBLsit.LeftJG,-22-ZBLsit.TopJG);
	ZBLsit.talentTex:SetSize(ListWWWHHH[3],ListWWWHHH[3]);
	ZBLsit.talent_1v = PIGFontString(ZBLsit,{"RIGHT",ZBLsit.talentTex,"LEFT",0,0},"","OUTLINE");
	ZBLsit.talent_1v:SetTextColor(1,1,1,1);
	ZBLsit.talent_1 = PIGFontString(ZBLsit,{"RIGHT",ZBLsit.talent_1v,"LEFT",0,0},SPECIALIZATION..":","OUTLINE");
	PIGLine(ZBLsit,"TOP",-43-ZBLsit.TopJG,nil,{1,-1},{0.2,0.2,0.2,0.9})
	ZBLsit.ListHang={}
	for i=1,#InvSlot["ID"] do
		local clsit = PIGFrame(ZBLsit,nil,{ListWWWHHH[4],ListWWWHHH[3]});
		ZBLsit.ListHang[InvSlot["ID"][i]]=clsit
		clsit:PIGSetBackdrop(0)
		if i==1 then
			if C_Engraving and C_Engraving and C_Engraving.IsEngravingEnabled() then
				clsit:SetPoint("TOPLEFT",ZBLsit,"TOPLEFT",ListWWWHHH[3]+ZBLsit.LeftJG+3,-54);
			else
				clsit:SetPoint("TOPLEFT",ZBLsit,"TOPLEFT",ZBLsit.LeftJG,-54);
			end
		else
			if PIG_MaxTocversion(50000) then
				clsit:SetPoint("TOPLEFT",ZBLsit.ListHang[InvSlot["ID"][i-1]],"BOTTOMLEFT",0,-2);
			else
				clsit:SetPoint("TOPLEFT",ZBLsit.ListHang[InvSlot["ID"][i-1]],"BOTTOMLEFT",0,-3.2);
			end
		end
		clsit.t = PIGFontString(clsit,{"CENTER",0.4,0.6},InvSlot["Name"][InvSlot["ID"][i]][2],"OUTLINE",12)
		clsit.itemlink = CreateFrame("Button", nil, clsit)
		clsit.itemlink:SetPoint("LEFT",clsit,"RIGHT",2,0);
		clsit.itemlink:SetSize(100,ListWWWHHH[3]);
		clsit.itemlink.lv = PIGFontString(clsit.itemlink,{"LEFT",clsit.itemlink,"LEFT",0,0},"","OUTLINE")
		clsit.itemlink.t = PIGFontString(clsit.itemlink,{"LEFT",clsit.itemlink.lv,"RIGHT",0,0},"","OUTLINE")
		clsit.itemlink:SetScript("OnLeave", function (self)
			GameTooltip:ClearLines();
			GameTooltip:Hide()
			clsit.t:SetTextColor(0, 1, 1, 0.8);
			clsit:SetBackdropColor(unpack(BackdropColor))
		end);
		clsit.ButGem={}
		for Gemid=1,ListWWWHHH[5] do
			local Gembut = CreateFrame("Frame", nil, clsit,"BackdropTemplate");
			clsit.ButGem[Gemid]=Gembut
			Gembut:SetBackdrop({edgeFile = "Interface/AddOns/"..addonName.."/Libs/Pig_Border.blp", edgeSize = 10});
			Gembut:SetBackdropBorderColor(0, 0, 0, 1);
			Gembut:SetSize(ListWWWHHH[3],ListWWWHHH[3]);
			if Gemid==1 then
				Gembut:SetPoint("LEFT",clsit.itemlink,"RIGHT",0,-1);
			elseif Gemid==6 then
				Gembut:SetPoint("RIGHT",clsit,"LEFT",-2.4,-1);
			else
				Gembut:SetPoint("LEFT",clsit.ButGem[Gemid-1],"RIGHT",1,0);
			end
			Gembut.icon = Gembut:CreateTexture();
			Gembut.icon:SetPoint("TOPLEFT",Gembut,"TOPLEFT",2,-2);
			Gembut.icon:SetPoint("BOTTOMRIGHT",Gembut,"BOTTOMRIGHT",-2,2);
			Gembut:SetScript("OnLeave", function ()
				GameTooltip:ClearLines();
				GameTooltip:Hide() 
			end);
		end
		function clsit:CZ_ItemListHang()
			self:SetBackdropBorderColor(0.5, 0.5, 0.5,0.5)--部位边框
			self.t:SetTextColor(0.5, 0.5, 0.5,0.8);--部位名
			self.itemlink.cunzai=nil
			self.itemlink:SetWidth(0.1);--link宽
			self.itemlink.lv:SetText(" ")--物品等级
			self.itemlink.t:SetText(" ")--物品link
			for Gemid=1,ListWWWHHH[5] do
				local Gemui = clsit.ButGem[Gemid]
				Gemui:SetWidth(0.01)
				Gemui:SetAlpha(0)
				Gemui:SetBackdropBorderColor(0, 0, 0, 1);
			end
			self.itemlink:SetScript("OnEnter",nil);
			self.itemlink:SetScript("OnDoubleClick",nil)
		end
	end
	local Dibuline=PIGLine(ZBLsit,"TOP",-391-ZBLsit.TopJG,nil,{1,-1},{0.2,0.2,0.2,0.9})
	ZBLsit.ListTao={}
	for tid=1,6 do
		local taozhuant = PIGFontString(ZBLsit,nil,"","OUTLINE");
		ZBLsit.ListTao[tid]=taozhuant
		if tid==1 then
			taozhuant:SetPoint("TOPLEFT",Dibuline,"BOTTOMLEFT",ZBLsit.LeftJG-3,-4);
		else
			taozhuant:SetPoint("TOPLEFT",ZBLsit.ListTao[tid-1],"BOTTOMLEFT",0,-1);
		end
	end
	if ziji then
		ZBLsit:SetPoint("TOPLEFT", fujik.ZBLsit, "TOPRIGHT",-1,0);
		TalentData.add_TalentUI(ZBLsit)
	end
	--
	ZBLsit.allstats={}
	function ZBLsit:CZ_ItemList()
		if self.TalentF then self.TalentF:Hide() self.TalentF:CZ_Tianfu() end
		local Parent=self:GetParent()
		addonTable.FramePlusfun.UpdatePoint(Parent)
		self.WJname:SetText(_G[Data.LongInspectUIUIname].fullnameX)
		self.pingjunLV_V:SetText("--")
		_G[Data.LongInspectUIUIname].ZBLsit.itemLV=nil
		self.classes:SetTexCoord(0,0,0,0);
		self.talent_1v:SetText("--")
		self.talentTex:SetTexture(132222);
		self.talentBut:SetScript("OnClick", nil)
		local ListName = self:GetName()
		for i = 1, #InvSlot["ID"] do
			ZBLsit.ListHang[InvSlot["ID"][i]]:CZ_ItemListHang()
		end
		for tid=1,4 do
			local taoui = ZBLsit.ListTao[tid]
			taoui:SetTextColor(0.5, 0.5, 0.5, 1);
			if tid==1 then
				taoui:SetText(string.format(BOSS_BANNER_LOOT_SET,NONE))
			else
				taoui:SetText("")
			end
		end
		self:SetHeight(ListWWWHHH[2])
	end
	function ZBLsit:Update_Player(unit,ycdata)
		self:CZ_ItemList()	
		local jichuxinxi={
			["Talent"]={},
			["OpenTF"]=function() end,
		}
		if unit=="lx" then
			self.cName=_G[Data.LongInspectUIUIname].fullnameX
			jichuxinxi.Talent=TalentData.GetTianfuIcon_YC(self.zhiye,self.cName,"lx")
			jichuxinxi.OpenTF=function()
				PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
				if self.TalentF:IsVisible() then
					self.TalentF:Hide()
				else
					self.TalentF:Show()
					self.TalentF:Show_Tianfu(unit)
				end
			end
		elseif unit=="yc" then
			self.cName=_G[Data.LongInspectUIUIname].fullnameX
			jichuxinxi.Talent=TalentData.GetTianfuIcon_YC(self.zhiye,self.cName)
			jichuxinxi.OpenTF=function()
				PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
				if self.TalentF:IsVisible() then
					self.TalentF:Hide()
				else
					self.TalentF:Show()
					self.TalentF:Show_Tianfu()
				end
			end
		else
			local IS_guacha=false
			if unit~="player" and self:GetParent():GetName()=="InspectFrame" then
				IS_guacha=true
			end
			local cName=GetUnitName(unit, true)
			local Level=UnitLevel(unit)
			local className, classFilename, classId = UnitClass(unit)
			self.cName=cName
			self.level=Level
			self.zhiyeID=classId
			self.zhiye=classFilename
			if PIG_MaxTocversion(50000) then
				jichuxinxi.Talent=TalentData.GetTianfuIcon(IS_guacha,classFilename)
				jichuxinxi.OpenTF=function()
					if IS_guacha then
						PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
						if self.TalentF:IsVisible() then
							self.TalentF:Hide()
						else
							self.TalentF:Show()
							self.TalentF:Show_Tianfu(TalentData.GetTianfuNum(true))
						end
					else
						if PIG_MaxTocversion(20000) then
							PlayerTalentFrame_LoadUI();
							if ( PlayerTalentFrame:IsShown() ) then
								HideUIPanel(PlayerTalentFrame);
							else
								ShowUIPanel(PlayerTalentFrame);
							end
						else
							TalentFrame_LoadUI();
							if ( PlayerTalentFrame:IsShown() ) then
								HideUIPanel(PlayerTalentFrame);
							else
								ShowUIPanel(PlayerTalentFrame);
							end
						end
					end
				end
			else
				if IS_guacha then
					local specID = GetInspectSpecialization(unit)
					local id, name, description, icon = GetSpecializationInfoByID(specID)
					jichuxinxi.Talent={name ~= "" and name or NONE, icon or 132222, 1}
				else
					local specIndex = GetSpecialization()--当前专精
					local id, name, description, icon = GetSpecializationInfo(specIndex)
					jichuxinxi.Talent={name ~= "" and name or NONE, icon or 132222, 1}
				end
				jichuxinxi.OpenTF=function()
					if IS_guacha then
						if InCombatLockdown() then
							PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
							PIG_OptionsUI:ErrorMsg("请专心战斗");
						else
							if InspectPaperDollFrameTalentsButtonMixin then
								InspectPaperDollFrameTalentsButtonMixin:OnClick()
							else
								InspectFrameTab3:Click()
							end
						end
					else
						if PlayerSpellsMicroButtonMixin then
							PlayerSpellsMicroButtonMixin:OnClick()
						else
							TalentMicroButton:Click()
						end
					end
				end
			end
		end
		self.WJname:SetText(self.cName.."|cffFFFF22 ("..self.level..")|r")
		if self.zhiye~="--" then
			self.classes:SetTexCoord(unpack(CLASS_ICON_TCOORDS[self.zhiye]));
			local color = PIG_CLASS_COLORS[self.zhiye];
			self.WJname:SetTextColor(color.r, color.g, color.b,1);
		end
		--天赋
		self.talent_1v:SetText(jichuxinxi.Talent[1])
		self.talentTex:SetTexture(jichuxinxi.Talent[2]);
		self.talentBut:SetScript("OnClick", function (self)
			jichuxinxi.OpenTF()
		end)
	end
	local function PIG_GetInventoryItem(Parent,unit)
		if not Parent:IsVisible() then return end
		local ItemData = {}
		for Slot = 1, 18 do
			local itemId = GetInventoryItemID(unit, Slot)
			if itemId then
				local itemLink=GetInventoryItemLink(unit, Slot)
				if itemLink then
					ItemData[Slot]=itemLink
				else
					ItemData[Slot]="-"
				end
			end
		end
		for k,v in pairs(ItemData) do
			if v=="-" then
				if Parent.zhixinghuoqucishu<5 then
					Parent.zhixinghuoqucishu=Parent.zhixinghuoqucishu+1
					if Parent.GetItemInfoX then Parent.GetItemInfoX:Cancel() end
					Parent.GetItemInfoX=C_Timer.NewTimer(0.2,function()
						PIG_GetInventoryItem(Parent,unit)
					end)
					return
				end
			end
		end
		GetItemMuluData(Parent,unit,ItemData)
	end
	function ZBLsit:Update_ItemList(unit,zbData)
		self.unit=unit
		if unit=="lx" or unit=="yc" then
			GetItemMuluData(self,unit,zbData)
		else
			self.zhixinghuoqucishu=0
			PIG_GetInventoryItem(self,unit)
		end		
	end
	ZBLsit:HookScript("OnHide", function(self)
		if self.allstats_Ticker then self.allstats_Ticker:Cancel() end
	end);
	if GetAverageItemLevel then
		ZBLsit:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE");
		ZBLsit:HookScript("OnEvent", function(self,event,arg1)
			if self.unit=="player" then
				local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = GetAverageItemLevel();
				self.pingjunLV_V:SetText(string.format("%.2f",avgItemLevelEquipped))
			end
		end)
	end
	return ZBLsit
end
function Create.PIGItemListUI(laiyuan)
	if laiyuan.ZBLsit then return end	
	if laiyuan==PaperDollFrame then
		laiyuan.ZBLsit = add_ItemList(laiyuan,laiyuan)
	elseif laiyuan==InspectFrame then
		laiyuan.ZBLsit = add_ItemList(laiyuan,laiyuan,true)
		laiyuan.ZBLsit_C = add_ItemList(laiyuan,laiyuan.ZBLsit)
	elseif laiyuan==_G[Data.LongInspectUIUIname] then
		laiyuan.ZBLsit = add_ItemList(laiyuan,laiyuan,true)
	end
end
-- hooksecurefunc("NotifyInspect", function(unit)
-- 	print(unit)
-- end)