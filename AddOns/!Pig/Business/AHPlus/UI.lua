local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
---
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGEnter=Create.PIGEnter
local PIGLine=Create.PIGLine
local PIGFontString=Create.PIGFontString
local PIGCheckbutton=Create.PIGCheckbutton
local Data=addonTable.Data
local BusinessInfo=addonTable.BusinessInfo
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
--------------
function BusinessInfo.ADD_qushi(fujiui,tishiOpen)
	local qushi=PIGFrame(fujiui)
	qushi:SetSize(328,204);
	if tishiOpen then
		qushi:PIGSetBackdrop(1,nil,nil,nil,0)
		qushi:Hide()
		qushi:SetFrameStrata("HIGH")
		qushi.itemName = PIGFontString(qushi,{"TOPLEFT", qushi, "TOPLEFT",8, -6},nil,"OUTLINE")
	end
	local HeightX,WidthX = qushi:GetHeight()-44,8
	qushi.qushiBUT={}
	for i=1,40 do
		local zhuzhuangX=PIGFrame(qushi,{"BOTTOMLEFT", qushi, "BOTTOMLEFT",WidthX*(i-1), 0},{WidthX,HeightX})
		if i==1 then
			zhuzhuangX:SetPoint("BOTTOMLEFT", qushi, "BOTTOMLEFT",4, 4);
		else
			zhuzhuangX:SetPoint("BOTTOMLEFT", qushi, "BOTTOMLEFT",(WidthX)*(i-1)+4, 4);
		end
		zhuzhuangX:PIGSetBackdrop(1,1,{0.2, 0.8, 0.8})
		zhuzhuangX:Hide()
		qushi.qushiBUT[i]=zhuzhuangX
	end
	function qushi.qushitu(Data,itemName)
		for i=1,40 do
			qushi.qushiBUT[i]:Hide()
		end
		if tishiOpen then
			qushi.itemName:SetText(itemName)
		else
			HeightX = qushi:GetHeight()-20
		end
		local PIG_qushidata_V = {["maxG"]=1,["maxG2"]=1,["endnum"]=1,["minVV"]=0.04}
		if #Data>40 then PIG_qushidata_V.endnum=(#Data-40) end
		local sortnum = {}
		for i=#Data,PIG_qushidata_V.endnum,-1 do
			local jiageVV =Data[i]
			table.insert(sortnum,jiageVV[1])
			if jiageVV then
				if jiageVV[1]>PIG_qushidata_V.maxG then
					PIG_qushidata_V.maxG=jiageVV[1]
				end
				if jiageVV[1]<PIG_qushidata_V.maxG and jiageVV[1]>PIG_qushidata_V.maxG2 then
					PIG_qushidata_V.maxG2=jiageVV[1]
				end

			end
		end
		table.sort(sortnum)
		PIG_qushidata_V.maxG=sortnum[#sortnum]
		for i=(#sortnum-1),1,-1 do
			if sortnum[i]<PIG_qushidata_V.maxG then
				PIG_qushidata_V.maxG2=sortnum[i]
				break
			end
		end
		if (PIG_qushidata_V.maxG/PIG_qushidata_V.maxG2)>2 then
			PIG_qushidata_V.maxG=PIG_qushidata_V.maxG2*2
		end
		local butidindex = 0
		for i=#Data,PIG_qushidata_V.endnum,-1 do
			if Data[i] then
				local danqianV = Data[i][1]
				butidindex=butidindex+1
				qushi.qushiBUT[butidindex]:Show()
				if danqianV>PIG_qushidata_V.maxG then
					danqianV=PIG_qushidata_V.maxG
				end
				local PIG_qushizuidabaifenbi = danqianV/PIG_qushidata_V.maxG
				if PIG_qushizuidabaifenbi<PIG_qushidata_V.minVV then
					qushi.qushiBUT[i]:SetHeight(PIG_qushidata_V.minVV*HeightX)
				else
					qushi.qushiBUT[i]:SetHeight(PIG_qushizuidabaifenbi*HeightX)
				end
			end
		end
	end
	if tishiOpen then
		local iconWH = 20
		local tishi = CreateFrame("Frame", nil, fujiui);
		tishi:SetSize(iconWH,iconWH);
		tishi.Tex = tishi:CreateTexture(nil, "BORDER");
		tishi.Tex:SetTexture("interface/common/help-i.blp");
		tishi.Tex:SetSize(iconWH+8,iconWH+8);
		tishi.Tex:SetPoint("CENTER");
		local tishitxt = "1、缓存价格以后才能显示涨跌百分比\n2、100%表示当前价格和最后次缓存价格一样\n3、80%表示当前价格是最后次缓存价格80%(即便宜了20%)\n4、120%表示当前价格是最后次缓存价格120%(即贵了20%)"
		PIGEnter(tishi,"提示：",tishitxt)
		return qushi,tishi
	else
		return qushi
	end
end
--
function BusinessInfo.huoquhuizhangjiageG()
	local marketPrice = C_WowTokenPublic.GetCurrentMarketPrice();
	if marketPrice and marketPrice>0 then
		local hzlishiGG = PIGA["AHPlus"]["Tokens"]
		local hzlishiGGNum = #hzlishiGG
		if hzlishiGGNum>0 then
			if hzlishiGGNum>50 then
				local kaishiwb = hzlishiGGNum-50
				for i=kaishiwb,1,-1 do
					table.remove(PIGA["AHPlus"]["Tokens"],i)
				end
			end
			local OldmarketPrice = PIGA["AHPlus"]["Tokens"][#PIGA["AHPlus"]["Tokens"]][2] or 0
			if OldmarketPrice~=marketPrice then
				table.insert(PIGA["AHPlus"]["Tokens"],{GetServerTime(),marketPrice})
			end
		else
			table.insert(PIGA["AHPlus"]["Tokens"],{GetServerTime(),marketPrice})
		end
	end
end
local function zhixingdianjiFUn(framef)
	framef:HookScript("PreClick",  function (self,button)
		if button=="RightButton" and not IsShiftKeyDown() and not IsControlKeyDown() and not IsAltKeyDown() then
			local itemID=PIGGetContainerItemInfo(self:GetParent():GetID(), self:GetID())
			if itemID then
				if IsAddOnLoaded("Blizzard_AuctionUI") then AuctionFrameTab_OnClick(AuctionFrameTab3) end
			end
		end
	end);
end
function BusinessInfo.QuicAuc()
	if tocversion<50000 then
		if PIGA["AHPlus"]["QuicAuc"] then
			if NDui then
				local NDui_BagName,slotnum = Data.NDui_BagName[1],Data.NDui_BagName[2]
				for f=1,slotnum do
					local framef = _G[NDui_BagName..f]
					if framef then
						zhixingdianjiFUn(framef)
					end
				end
			else
				local ElvUI_BagName = Data.ElvUI_BagName
				for f=1,NUM_CONTAINER_FRAMES do
					for ff=1,36 do
						if ElvUI then
							for ei=1,#ElvUI_BagName do
								local bagff = _G[ElvUI_BagName[ei]..f.."Slot"..ff]
								if bagff then
									zhixingdianjiFUn(bagff)
								end
							end
						else
							if _G["ContainerFrame"..f.."Item"..ff] then
								zhixingdianjiFUn(_G["ContainerFrame"..f.."Item"..ff])
							end
						end
					end
				end
			end
		end
	end
end
----------------------------------
local AuctionFramejiazai = CreateFrame("FRAME")
AuctionFramejiazai:RegisterEvent("TOKEN_MARKET_PRICE_UPDATED")
AuctionFramejiazai:RegisterEvent("TOKEN_DISTRIBUTIONS_UPDATED")
AuctionFramejiazai:SetScript("OnEvent", function(self, event, arg1)
	if event=="ADDON_LOADED" then
		if arg1 == "Blizzard_AuctionHouseUI" then
			BusinessInfo.AHPlus_Mainline()
			self:UnregisterEvent("ADDON_LOADED")
		elseif arg1 == "Blizzard_AuctionUI" then
			BusinessInfo.AHPlus_Vanilla()
			self:UnregisterEvent("ADDON_LOADED")
		end
	end
	if event=="TOKEN_MARKET_PRICE_UPDATED" or event=="TOKEN_DISTRIBUTIONS_UPDATED" then
		BusinessInfo.huoquhuizhangjiageG()
	end
end)
------------
function BusinessInfo.AHPlus_ADDUI()
	if PIGA["AHPlus"]["Open"] then
		BusinessInfo.huoquhuizhangjiageG()
		BusinessInfo.QuicAuc()
		if IsAddOnLoaded("Blizzard_AuctionHouseUI") then
			BusinessInfo.AHPlus_Mainline()
		elseif IsAddOnLoaded("Blizzard_AuctionUI") then
			BusinessInfo.AHPlus_Vanilla()
		else
			AuctionFramejiazai:RegisterEvent("ADDON_LOADED")
		end
	end
end