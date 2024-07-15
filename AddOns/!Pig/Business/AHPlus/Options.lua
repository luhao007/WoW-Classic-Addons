local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGSlider=Create.PIGSlider
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
local PIGModCheckbutton=Create.PIGModCheckbutton
local PIGQuickBut=Create.PIGQuickBut
------
local BusinessInfo=addonTable.BusinessInfo
local fuFrame,fuFrameBut = BusinessInfo.fuFrame,BusinessInfo.fuFrameBut

local GnName,GnUI,GnIcon,FrameLevel = "拍卖助手","AutoSellBuy_UI",134409,20
BusinessInfo.AHPlusData={GnName,GnUI,GnIcon,FrameLevel}
------------
function BusinessInfo.AHPlusOptions()
	fuFrame.AH_line = PIGLine(fuFrame,"TOP",-(fuFrame.dangeH*fuFrame.GNNUM))
	fuFrame.GNNUM=fuFrame.GNNUM+3
	local AHPlus_tooltip="在拍卖行界面增加一个缓存单价按钮，时光徽章界面显示历史价格";
	if tocversion<50000 then
		AHPlus_tooltip="在拍卖行浏览列表显示一口价，和涨跌百分比。界面增加一个缓存单价按钮，时光徽章界面显示历史价格";
	end
	fuFrame.AHPlus =PIGCheckbutton(fuFrame,{"TOPLEFT",fuFrame.AH_line,"TOPLEFT",20,-30},{GnName, AHPlus_tooltip})
	fuFrame.AHPlus:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["Open"]=true;
			BusinessInfo.AHPlus_ADDUI()
		else
			PIGA["AHPlus"]["Open"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
		fuFrame:ShowChecked()
	end);
	--扫描间隔
	BusinessInfo.AHPlusData.ScanCD=PIGA["AHPlus"]["ScanCD"]
	fuFrame.AHPlus.ScanSliderT = PIGFontString(fuFrame.AHPlus,{"LEFT",fuFrame.AHPlus.Text,"RIGHT",20,0},"扫描间隔")
	local Scaninfo = {0.002,0.08,0.001}
	fuFrame.AHPlus.ScanSlider = PIGSlider(fuFrame.AHPlus,{"LEFT",fuFrame.AHPlus.ScanSliderT,"RIGHT",10,0},{100,14},Scaninfo)
	function fuFrame.AHPlus.ScanSlider:OnValueFun()
		local val = self:GetValue()
		local val = floor(val*1000+0.5)*0.001
		self.Text:SetText(val);
		PIGA["AHPlus"]["ScanCD"]=val
		BusinessInfo.AHPlusData.ScanCD=val
	end
	fuFrame.AHPlus.AHtooltip =PIGCheckbutton(fuFrame.AHPlus,{"TOPLEFT",fuFrame.AHPlus,"BOTTOMLEFT",0,-20},{"鼠标提示拍卖价钱","在物品的鼠标提示上显示拍卖缓存价钱"})
	fuFrame.AHPlus.AHtooltip:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["AHtooltip"]=true;
		else
			PIGA["AHPlus"]["AHtooltip"]=false;
		end
	end);
	fuFrame.AHPlus.AHUIoff =PIGCheckbutton(fuFrame.AHPlus,{"LEFT",fuFrame.AHPlus.AHtooltip,"RIGHT",220,0},{"禁止专业面板关闭","拍卖界面打开时禁止系统的专业面板自动关闭功能"})
	fuFrame.AHPlus.AHUIoff:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["AHUIoff"]=true;
			BusinessInfo.AHUIoff()
		else
			PIGA["AHPlus"]["AHUIoff"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
	end);
	if tocversion<50000 then
		fuFrame.AHPlus.QuicAuc =PIGCheckbutton(fuFrame.AHPlus,{"TOPLEFT",fuFrame.AHPlus.AHtooltip,"BOTTOMLEFT",0,-20},{"鼠标右键快速拍卖","鼠标右键背包物品快速拍卖"})
		fuFrame.AHPlus.QuicAuc:SetScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA["AHPlus"]["QuicAuc"]=true;
				BusinessInfo.QuicAuc()
			else
				PIGA["AHPlus"]["QuicAuc"]=false;
				Pig_Options_RLtishi_UI:Show()
			end
		end);
		GameTooltip:HookScript("OnTooltipSetItem", function(self)
			if PIGA["AHPlus"]["Open"] and PIGA["AHPlus"]["AHtooltip"] then
				local name, link = self:GetItem()
				if name and name~="" then
					local  bindType = select(14, GetItemInfo(link))
					if bindType~=1 and bindType~=4 then
						if PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm] and PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm][name] then
							local jiagelist = PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm][name][2]
							local jiagelistNum=#jiagelist
							local jiluTime = jiagelist[jiagelistNum][2] or 1660000000
							local jiluTime = date("%m-%d %H:%M",jiluTime)
							self:AddDoubleLine("拍卖("..jiluTime..")",GetMoneyString(jiagelist[jiagelistNum][1]),0,1,1,0,1,1)
						else
							self:AddDoubleLine("拍卖(尚未缓存)","",0,1,1,0,1,1)
						end
					end
				end
			end
		end)
	else
		-- TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
		-- 	if PIGA["AHPlus"]["Open"] and PIGA["AHPlus"]["AHtooltip"] then
		-- 		if tooltip == GameTooltip then	
		-- 			local ItemID = data["id"]
		-- 			if ItemID then
		-- 				local  bubangding = select(14, GetItemInfo(ItemID))--非绑定
		-- 				if bubangding~=1 and bubangding~=4 then
		-- 					if PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm] and PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm][ItemID] then
		-- 						local jiluTime = PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm][ItemID][3] or 1660000000
		-- 						local jiluTime = date("%m-%d %H:%M",jiluTime)
		-- 						tooltip:AddDoubleLine("拍卖("..jiluTime.."):",GetMoneyString(PIGA["AHPlus"]["DataList"][Pig_OptionsUI.Realm][ItemID][1]),0,1,1,0,1,1)
		-- 					else
		-- 						tooltip:AddDoubleLine("拍卖(尚未缓存)","",0,1,1,0,1,1)
		-- 					end
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end)
	end
	---
	fuFrame.AHPlus.CZ = PIGButton(fuFrame,{"TOPLEFT",fuFrame.AHPlus,"TOPLEFT",516,0},{60,22},"重置");  
	fuFrame.AHPlus.CZ:SetScript("OnClick", function ()
		StaticPopup_Show ("AH_CZQIANGKONGINFO");
	end);
	PIGEnter(fuFrame.AHPlus.CZ,"|cffFF0000重置|r"..GnName.."所有配置")
	StaticPopupDialogs["AH_CZQIANGKONGINFO"] = {
		text = "此操作将\124cffff0000重置\124r"..GnName.."所有配置，需重载界面。\n确定重置?",
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			PIGA["AHPlus"]=addonTable.Default["AHPlus"];
			PIGA["AHPlus"]["Open"] = true;
			ReloadUI()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	--------
	function fuFrame:ShowChecked()
		if self.AHPlus:GetChecked() then
			self.AHPlus.AHtooltip:Enable()
			self.AHPlus.AHUIoff:Enable()
			if self.AHPlus.QuicAuc then self.AHPlus.QuicAuc:Enable() end
		else
			self.AHPlus.AHtooltip:Disable()
			self.AHPlus.AHUIoff:Disable()
			if self.AHPlus.QuicAuc then self.AHPlus.QuicAuc:Disable() end
		end
	end
	fuFrame:HookScript("OnShow", function (self)
		self.AHPlus:SetChecked(PIGA["AHPlus"]["Open"])
		self.AHPlus.AHtooltip:SetChecked(PIGA["AHPlus"]["AHtooltip"])
		self.AHPlus.AHUIoff:SetChecked(PIGA["AHPlus"]["AHUIoff"])
		self.AHPlus.ScanSlider:PIGSetValue(PIGA["AHPlus"]["ScanCD"])
		if self.AHPlus.QuicAuc then
			self.AHPlus.QuicAuc:SetChecked(PIGA["AHPlus"]["QuicAuc"])
		end
		fuFrame:ShowChecked()
	end);
	BusinessInfo.AHPlus_ADDUI()
end
