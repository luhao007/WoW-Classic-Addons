local addonName, addonTable = ...;
local L=addonTable.locale
local Fun=addonTable.Fun
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
--------
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.Time(StatsInfo)
	local fujiF,fujiTabBut=PIGOptionsList_R(StatsInfo.F,"时\n光",StatsInfo.butW,"Left")
	BusinessInfo.StatsInfoUI=StatsInfo
	function StatsInfo:TabShow(lyui)
		if self then
			if self:IsShown() then
				self:Hide()
			else
				lyui:Hide()
				self:Show()
				Create.Show_TabBut_R(self.F,fujiF,fujiTabBut)
			end
		else
			PIG_OptionsUI:ErrorMsg("请打开"..addonName..SETTINGS.."→"..L["BUSINESS_TABNAME"].."→"..INFO..STATISTICS)
		end
	end
	---
	fujiF.nr=PIGFrame(fujiF)
	fujiF.nr:SetPoint("TOPLEFT",fujiF,"TOPLEFT",4,-4);
	fujiF.nr:SetPoint("TOPRIGHT",fujiF,"TOPRIGHT",-4,-4);
	fujiF.nr:SetHeight(200)
	fujiF.nr:PIGSetBackdrop(0)
	local hang_NUMLS=36
	fujiF.nr.butlist={}
	for id = 1, hang_NUMLS, 1 do
		local hang = PIGFrame(fujiF,nil,{10,14})
		fujiF.nr.butlist[id]=hang
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.nr, "TOPLEFT", 4, -4);
		elseif id==13 then
			hang:SetPoint("TOPLEFT",fujiF.nr.butlist[1],"TOPLEFT",280,0);
		elseif id==25 then
			hang:SetPoint("TOPLEFT",fujiF.nr.butlist[1],"TOPLEFT",570,0);
		else
			hang:SetPoint("TOPLEFT", fujiF.nr.butlist[id-1], "BOTTOMLEFT", 0, -2);
		end
		hang.time = PIGFontString(hang,{"LEFT", hang, "LEFT", 0, 0},nil,"OUTLINE")
		hang.time:SetTextColor(1, 1, 1, 1); 
		hang.GG = PIGFontString(hang,{"LEFT", hang.time, "RIGHT", 2, 0},nil,"OUTLINE")
	end
	------
	fujiF.timeF=PIGFrame(fujiF)
	fujiF.timeF:SetPoint("TOPLEFT",fujiF.nr,"BOTTOMLEFT",0,-10);
	fujiF.timeF:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",0,0);
	fujiF.timeF:PIGSetBackdrop(0)
	fujiF.timeF.qushiF=BusinessInfo.ADD_qushi(fujiF.timeF,nil,108)
	----
	local function Update_huizhangG()
		local hzlishiGG = PIGA["StatsInfo"]["Times"]
		for id = 1, hang_NUMLS, 1 do
			if hzlishiGG[id] then
				local hang = fujiF.nr.butlist[id]
				local jinbiV = hzlishiGG[id][1]
				local jinbiV = jinbiV*0.0001+0.5
				local jinbiV = floor(jinbiV)*10000
				hang.time:SetText(date("%Y-%m-%d %H:%M",hzlishiGG[id][2]))
				hang.GG:SetText(GetMoneyString(jinbiV))
			end
		end
		local hzlishiGG_11 ={min=0,data={}}
		for i=1,#hzlishiGG do
			if hzlishiGG_11.min>0 then
				if hzlishiGG[i][1]<hzlishiGG_11.min then hzlishiGG_11.min=hzlishiGG[i][1] end
			else
				hzlishiGG_11.min=hzlishiGG[i][1]
			end
		end
		for i=1,#hzlishiGG do
			hzlishiGG_11.data[i]={}
			local xxxxcc = hzlishiGG[i][1]-(hzlishiGG_11.min*0.6)
			hzlishiGG_11.data[i][1]=xxxxcc
		end
		fujiF.timeF.qushiF.qushitu(hzlishiGG_11.data)
	end
	fujiF:HookScript("OnShow", function(self)
		Update_huizhangG()
	end)
	----------------------------------
	local function AddWowTokenG(hzlishiGG,marketPrice)
		table.insert(hzlishiGG,{marketPrice,GetServerTime()})
	end
	local function GetWowTokenG()
		local marketPrice = C_WowTokenPublic.GetCurrentMarketPrice();
		if marketPrice and marketPrice>0 then
			local hzlishiGG = PIGA["StatsInfo"]["Times"]
			local hzlishiGGNum = #hzlishiGG
			if hzlishiGGNum>0 then
				if hzlishiGGNum>108 then
					local kaishiwb = hzlishiGGNum-108
					for i=kaishiwb,1,-1 do
						table.remove(hzlishiGG,i)
					end
				end
				local OldmarketPrice = hzlishiGG[#hzlishiGG][1]
				if OldmarketPrice~=marketPrice then
					AddWowTokenG(hzlishiGG,marketPrice)
				end
			else
				AddWowTokenG(hzlishiGG,marketPrice)
			end
		end
	end
	local function Update_GetWowTokenG()
		if not InCombatLockdown() then
			GetWowTokenG()
		end
		C_Timer.After(60,Update_GetWowTokenG)
	end
	C_Timer.After(6,Update_GetWowTokenG)
	fujiF:RegisterEvent("TOKEN_MARKET_PRICE_UPDATED")
	fujiF:RegisterEvent("TOKEN_DISTRIBUTIONS_UPDATED")
	fujiF:SetScript("OnEvent", function(self, event, arg1)
		GetWowTokenG()
	end)
end
