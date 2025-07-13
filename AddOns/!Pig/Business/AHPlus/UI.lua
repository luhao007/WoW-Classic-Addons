local _, addonTable = ...;
local L=addonTable.locale
---
local Fun=addonTable.Fun
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGFontString=Create.PIGFontString
local PIGCheckbutton=Create.PIGCheckbutton
local Data=addonTable.Data
local BusinessInfo=addonTable.BusinessInfo
local GetItemInfo=GetItemInfo or C_Item and C_Item.GetItemInfo
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
local baocunnum = 40
--------------
function BusinessInfo.GetCacheDataG(name)
	local cfdata=PIGA["AHPlus"]["CacheData"]
	if cfdata[PIG_OptionsUI.Realm] then
		if name then
			if cfdata[PIG_OptionsUI.Realm][name] and cfdata[PIG_OptionsUI.Realm][name][2] and cfdata[PIG_OptionsUI.Realm][name][3] then
				return cfdata[PIG_OptionsUI.Realm][name][2]
			end
		else
			return cfdata[PIG_OptionsUI.Realm]
		end
	else
		if name then
			if cfdata[name] and cfdata[name][2] and cfdata[name][3] then
				return cfdata[name][2]
			end
		else
			return cfdata
		end
	end
end
function BusinessInfo.DEL_OLDdata()
	local NewData=BusinessInfo.GetCacheDataG()
	for k,v in pairs(NewData) do
		if v[2] and v[3] then
			local itemDataL = v[2]
			local ItemsNum = #itemDataL;
			if ItemsNum>baocunnum then
				for ivb=(ItemsNum-baocunnum),1,-1 do
					table.remove(itemDataL,ivb)
				end
			end
		else
			NewData[k]=nil
		end
	end
end
function BusinessInfo.ADD_Newdata(name,xianjiaV,itemLink,itemID)
	local NewData=BusinessInfo.GetCacheDataG()
	if NewData[name] and NewData[name][2] and NewData[name][3] then
		table.insert(NewData[name][2],{xianjiaV,GetServerTime()})
	else
		local itemLinkJJ = Fun.GetItemLinkJJ(itemLink)
		NewData[name]={itemLinkJJ,{{xianjiaV,GetServerTime()}},itemID}
	end
end
function BusinessInfo.SetTooltipOfflineG(ItemInfo,tooltip)
	if PIGA["AHPlus"]["Open"] and PIGA["AHPlus"]["AHtooltip"] then
		if ItemInfo and tooltip == GameTooltip then
			local itemName,_,_,_,_,_,_,_,_,_,_,_,_,bindType= GetItemInfo(ItemInfo)
			if itemName and bindType~=1 and bindType~=4 then
				local NameData = BusinessInfo.GetCacheDataG(itemName)
				if NameData then
					local DataNum=#NameData
					local jiluTime = NameData[DataNum][2] or 1660000000
					local jiluTime = date("%m-%d %H:%M",jiluTime)
					tooltip:AddDoubleLine("拍卖("..jiluTime.."):",GetMoneyString(NameData[DataNum][1]),0,1,1,0,1,1)
				else
					tooltip:AddDoubleLine("拍卖(尚未缓存)","",0,1,1,0,1,1)
				end
			end
		end
	end
end
function BusinessInfo.ADD_qushi(fujiui,tishi,num)
	local Nbaocunnum=num or baocunnum
	local qushi=PIGFrame(fujiui)
	qushi:SetPoint("TOPLEFT", fujiui, "TOPLEFT",0, -10);
	qushi:SetPoint("BOTTOMRIGHT", fujiui, "BOTTOMRIGHT",0, 1);
	if tishi then
		qushi.itemName = PIGFontString(qushi,{"TOPLEFT", qushi, "TOPLEFT",6, 18},nil,"OUTLINE")
		local ParentUI = fujiui:GetParent()
		local iconWH = 20
		ParentUI.qushitishi = CreateFrame("Frame", nil, ParentUI);
		ParentUI.qushitishi:SetSize(iconWH,iconWH);
		ParentUI.qushitishi.Tex = ParentUI.qushitishi:CreateTexture(nil, "BORDER");
		ParentUI.qushitishi.Tex:SetTexture("interface/common/help-i.blp");
		ParentUI.qushitishi.Tex:SetSize(iconWH+8,iconWH+8);
		ParentUI.qushitishi.Tex:SetPoint("CENTER");
		local tishitxt = "1、缓存价格以后才能显示涨跌百分比\n2、100%表示当前价格和最后次缓存价格一样\n3、80%表示当前价格是最后次缓存价格80%(即便宜了20%)\n4、120%表示当前价格是最后次缓存价格120%(即贵了20%)"
		PIGEnter(ParentUI.qushitishi,"提示：",tishitxt)
	end
	local WidthX =7.9
	qushi.qushiButList={}
	for i=1,Nbaocunnum do
		local zhuzhuangX=PIGFrame(qushi,{"BOTTOMLEFT", qushi, "BOTTOMLEFT",WidthX*(i-1), 0},{WidthX,10})
		if i==1 then
			zhuzhuangX:SetPoint("BOTTOMLEFT", qushi, "BOTTOMLEFT",1, 0);
		else
			zhuzhuangX:SetPoint("BOTTOMLEFT", qushi, "BOTTOMLEFT",(WidthX)*(i-1)+1, 0);
		end
		zhuzhuangX:PIGSetBackdrop(1,1,{0.2, 0.8, 0.8})
		zhuzhuangX:Hide()
		qushi.qushiButList[i]=zhuzhuangX
	end
	function qushi.qushitu(Data,itemName)
		local NewHeightX = qushi:GetHeight()
		for i=1,Nbaocunnum do
			qushi.qushiButList[i]:Hide()
		end
		if itemName then
			qushi.itemName:SetText(itemName)
		end
		local PIG_qushidata_V = {["maxG"]=1,["maxG2"]=1,["endnum"]=1,["minVV"]=0.04}
		if #Data>Nbaocunnum then PIG_qushidata_V.endnum=(#Data-(Nbaocunnum-1)) end
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
		if #sortnum>1 then
			PIG_qushidata_V.maxG=sortnum[#sortnum]
		end
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
		for i=1,#Data,PIG_qushidata_V.endnum do
			if Data[i] then
				local danqianV = Data[i][1]
				butidindex=butidindex+1
				qushi.qushiButList[butidindex]:Show()
				if danqianV>PIG_qushidata_V.maxG then
					danqianV=PIG_qushidata_V.maxG
				end
				local PIG_qushizuidabaifenbi = danqianV/PIG_qushidata_V.maxG
				if PIG_qushizuidabaifenbi<PIG_qushidata_V.minVV then
					qushi.qushiButList[butidindex]:SetHeight(PIG_qushidata_V.minVV*NewHeightX)
				else
					qushi.qushiButList[butidindex]:SetHeight(PIG_qushizuidabaifenbi*NewHeightX)	
				end
			end
		end
	end
	return qushi
end
----
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
	if PIG_MaxTocversion() then
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
--
local AuctionFramejiazai = CreateFrame("Frame")
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
end)
------------
function BusinessInfo.AHPlus_ADDUI()
	if PIGA["AHPlus"]["Open"] then
		BusinessInfo.QuicAuc()
		if PIG_MaxTocversion(90000) then--9.2.7暗影国度跨服务器包括宝石、草药、合剂、消耗品等。不过，武器和盔甲这类非商品类物品仍然只能在单个服务器内交易，并不会跨服共享
			PIGA["AHPlus"]["CacheData"][PIG_OptionsUI.Realm]=PIGA["AHPlus"]["CacheData"][PIG_OptionsUI.Realm] or {}
		end
		if IsAddOnLoaded("Blizzard_AuctionHouseUI") then
			BusinessInfo.AHPlus_Mainline()
		elseif IsAddOnLoaded("Blizzard_AuctionUI") then
			BusinessInfo.AHPlus_Vanilla()
		else
			AuctionFramejiazai:RegisterEvent("ADDON_LOADED")
		end
	end
end