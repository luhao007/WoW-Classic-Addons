local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
local Create=addonTable.Create
local PIGEnter=Create.PIGEnter
local PIGFontString=Create.PIGFontString
local BagBankfun=addonTable.BagBankfun
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemLink=C_Container.GetContainerItemLink
local bagData=addonTable.Data.bagData
--刷新背包LV
local function shuaxin_LV(framef, id, slot)
	if not framef.ZLV then return end
	framef.ZLV:SetText();
	local itemLink = GetContainerItemLink(id, slot)
	if itemLink then
		local _,_,itemQuality,_,_,_,_,_,_,_,_,classID = GetItemInfo(itemLink);
		if itemQuality then
			if classID==2 or classID==4 then
				local effectiveILvl = GetDetailedItemLevelInfo(itemLink)
				framef.ZLV:SetText(effectiveILvl);
				local r, g, b = GetItemQualityColor(itemQuality);
				framef.ZLV:SetTextColor(r, g, b, 1);
			end
		end
	end
end
local function shuaxin_ranse(framef,id,slot)
	if not framef.ranse then return end
	framef.ranse:Hide()
	local itemLink = GetContainerItemLink(id, slot)
	if itemLink then
		local _,_,itemQuality,_,_,_,_,_,_,_,_,classID = GetItemInfo(itemLink);
		if itemQuality and itemQuality>1 then
			if classID==2 or classID==4 then
           		local r, g, b = GetItemQualityColor(itemQuality);
	            framef.ranse:SetVertexColor(r, g, b);
				framef.ranse:Show()
			end
		end
	end
end
--银行背包LV
function BagBankfun.Bag_Item_lv(frame, size, id)
	if not PIGA["BagBank"]["wupinLV"] then return end
	if tocversion<100000 then
		if id==-2 then return end
		if frame and size then
			local fujiFF=frame:GetName()
			for slot =1, size do
				local framef = _G[fujiFF.."Item"..size+1-slot]
				shuaxin_LV(framef, id, slot)
			end
		else
			local Fid=IsBagOpen(id)
			if Fid then
				local baogeshu=GetContainerNumSlots(id)
				for slot =1, baogeshu do
					local framef = _G["ContainerFrame"..Fid.."Item"..baogeshu+1-slot]
					shuaxin_LV(framef, id, slot)
				end
			end
		end
	else
		if frame and size==0 and id==0 then
			for bagi=1,#bagData["bagID"] do
				local baogeshu=GetContainerNumSlots(bagData["bagID"][bagi])
				if bagData["bagID"][bagi]==0 and not IsAccountSecured() then baogeshu=baogeshu+4 end
				for slot =1, baogeshu do
					local framef = _G["ContainerFrame"..bagi.."Item"..(baogeshu+1-slot)]
					shuaxin_LV(framef,bagData["bagID"][bagi], slot)
				end
			end
		else
			local Fid=id+1
			if Fid then
				local baogeshu=GetContainerNumSlots(id)
				if id==0 and not IsAccountSecured() then baogeshu=baogeshu+4 end
				for slot =1, baogeshu do
					local framef = _G["ContainerFrame"..Fid.."Item"..(baogeshu+1-slot)]
					shuaxin_LV(framef, id, slot)
				end
			end
		end
	end
end
--刷新背包染色
function BagBankfun.Bag_Item_Ranse(frame, size, id)
	if not PIGA["BagBank"]["wupinRanse"] then return end
	if tocversion<100000 then
		if id==-2 then return end
		if frame and size then
			local fujiFF=frame:GetName()
			for slot =1, size do
				local framef=_G[fujiFF.."Item"..size+1-slot]
				shuaxin_ranse(framef,id,slot)
			end
		else
			local Fid=IsBagOpen(id)
			if Fid then
				local baogeshu=GetContainerNumSlots(id)
				for slot =1, baogeshu do
					local framef=_G["ContainerFrame"..Fid.."Item"..baogeshu+1-slot];
					shuaxin_ranse(framef,id,slot)
				end
			end
		end
	else
		if frame and size==0 and id==0 then
			for bagi=1,#bagData["bagID"] do
				local baogeshu=GetContainerNumSlots(bagData["bagID"][bagi])
				if bagData["bagID"][bagi]==0 and not IsAccountSecured() then baogeshu=baogeshu+4 end
				for slot =1, baogeshu do
					local framef = _G["ContainerFrame"..bagi.."Item"..(baogeshu+1-slot)]
					shuaxin_ranse(framef,bagData["bagID"][bagi], slot)
				end
			end
		else
			local Fid=id+1
			if Fid then
				local baogeshu=GetContainerNumSlots(id)
				if id==0 and not IsAccountSecured() then baogeshu=baogeshu+4 end
				for slot =1, baogeshu do
					local framef = _G["ContainerFrame"..Fid.."Item"..(baogeshu+1-slot)]
					shuaxin_ranse(framef, id, slot)
				end
			end
		end
	end
end
---
function BagBankfun.xuanzhuangsanjiao(self,open)
	if open then
		self:SetRotation(-3.1415926, {x=0.4, y=0.5})
	else
		self:SetRotation(0, {x=0.4, y=0.5})
	end
end
----
local function jisuanBANKzongshu(id)
	local bankzongshu = bagData["bankmun"]
	if id>bagData["bankID"][2] then
		local qianzhibag = id-bagData["bankID"][2]
		for i=bagData["bankID"][2],id-1 do
			local shangnum = GetContainerNumSlots(i)
			bankzongshu=bankzongshu+shangnum
		end
	end
	return bankzongshu
end
function BagBankfun.jisuanBANKkonmgyu(id)
	local shang_allshu=jisuanBANKzongshu(id)
	local qishihang=ceil(bagData["bankmun"]/BankFrame.meihang)--行数
	local qishikongyu=qishihang*BankFrame.meihang-bagData["bankmun"]--空余
	if id==bagData["bankID"][2] then
		return qishihang,qishikongyu
	else
		local hangShu=ceil(shang_allshu/BankFrame.meihang)
		local kongyu=hangShu*BankFrame.meihang-shang_allshu
		return hangShu,kongyu
	end
end
--银行格子LV
function BagBankfun.Bank_Item_lv(frame, size, id)
	if not PIGA["BagBank"]["wupinLV"] then return end
	if id then
		if id<=bagData["bankmun"] then
			local framef=_G["BankFrameItem"..id];
			shuaxin_LV(framef, -1, id)
		end
	else
		for ig=1,bagData["bankmun"] do
			local framef=_G["BankFrameItem"..ig];
			shuaxin_LV(framef, -1, ig)
		end
	end
end
--银行格子染色
function BagBankfun.Bank_Item_ranse(frame, size, id)
	if not PIGA["BagBank"]["wupinRanse"] then return end
	if id then
		if id<=bagData["bankmun"] then
			local framef=_G["BankFrameItem"..id];
			shuaxin_ranse(framef, -1, id)
		end
	else
		for ig=1,bagData["bankmun"] do
			local framef=_G["BankFrameItem"..ig];
			shuaxin_ranse(framef, -1, ig)
		end
	end
end
function BagBankfun.Update_BankFrame_Height(BagdangeW)
	local banbagzongshu=bagData["bankmun"]
	for i=2,#bagData["bankID"] do
		banbagzongshu=banbagzongshu+GetContainerNumSlots(bagData["bankID"][i])
	end
	local hangShuALL=ceil(banbagzongshu/BankFrame.meihang)
	local hangallgao=hangShuALL*BagdangeW
	if tocversion<100000 then
		BankFrame:SetWidth(BagdangeW*BankFrame.meihang+36)
		BankFrame:SetHeight(hangallgao+106);
	else
		if hangallgao+106>BANK_PANELS[1].size.y then
			BankFrame:SetHeight(hangallgao+106);
		else
			BankFrame:SetHeight(BANK_PANELS[1].size.y);
		end
	end
end
-------
function BagBankfun.add_Itemslot_ZLV_ranse(famrr,BagdangeW)		
	if not famrr.ZLV then
		famrr.ZLV = PIGFontString(famrr,{"TOPRIGHT", famrr, "TOPRIGHT", -1, -1},nil,"OUTLINE",15)
		famrr.ZLV:SetDrawLayer("OVERLAY", 7)
	end
	if not famrr.ranse then
		famrr.ranse = famrr:CreateTexture(nil, "OVERLAY");
	    famrr.ranse:SetTexture("Interface\\Buttons\\UI-ActionButton-Border");
	    famrr.ranse:SetBlendMode("ADD");
	    famrr.ranse:SetSize(BagdangeW*1.63, BagdangeW*1.63);
	    famrr.ranse:SetPoint("CENTER", famrr, "CENTER", 0, 0);
	    famrr.ranse:Hide()
	end
end