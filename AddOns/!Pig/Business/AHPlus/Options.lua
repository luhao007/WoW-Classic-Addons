local addonName, addonTable = ...;
local L=addonTable.locale
local Create=addonTable.Create
local PIGSlider=Create.PIGSlider
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
local PIGQuickBut=Create.PIGQuickBut
------
local BusinessInfo=addonTable.BusinessInfo
local fuFrame,fuFrameBut = BusinessInfo.fuFrame,BusinessInfo.fuFrameBut
local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant

local GnName= "拍卖助手"
BusinessInfo.AHPlusData={}
------------
function BusinessInfo.AHPlusOptions()
	fuFrame.GNNUM=fuFrame.GNNUM+3
	local AHPlus_tooltip="在拍卖行界面增加一个缓存单价按钮，时光徽章界面显示历史价格";
	if PIG_MaxTocversion(40000) then
		AHPlus_tooltip="在拍卖行浏览列表显示一口价，和涨跌百分比。界面增加一个缓存单价按钮，时光徽章界面显示历史价格";
	end
	fuFrame.AHPlus =PIGCheckbutton(fuFrame,{"TOPLEFT",fuFrame,"TOPLEFT",20,-20},{GnName, AHPlus_tooltip})
	fuFrame.AHPlus:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["Open"]=true;
			BusinessInfo.AHPlus_ADDUI()
		else
			PIGA["AHPlus"]["Open"]=false;
			PIG_OptionsUI.RLUI:Show()
		end
		fuFrame:ShowChecked()
	end);
	--扫描间隔
	fuFrame.AHPlus.ScanSliderT = PIGFontString(fuFrame.AHPlus,{"LEFT",fuFrame.AHPlus.Text,"RIGHT",20,0},"扫描间隔")
	local Scaninfo = {1,10,1}
	BusinessInfo.AHPlusData.ScanCD=PIGA["AHPlus"]["ScanTimeCD"]
	fuFrame.AHPlus.ScanSlider = PIGSlider(fuFrame.AHPlus,{"LEFT",fuFrame.AHPlus.ScanSliderT,"RIGHT",10,0},Scaninfo)
	fuFrame.AHPlus.ScanSlider.Slider:HookScript("OnValueChanged", function(self, arg1)
		PIGA["AHPlus"]["ScanTimeCD"]=arg1
		BusinessInfo.AHPlusData.ScanCD=arg1
	end)
	fuFrame.AHPlus.AHtooltip =PIGCheckbutton(fuFrame.AHPlus,{"TOPLEFT",fuFrame.AHPlus,"BOTTOMLEFT",0,-20},{"鼠标提示拍卖价钱","在物品的鼠标提示上显示拍卖缓存价钱"})
	fuFrame.AHPlus.AHtooltip:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AHPlus"]["AHtooltip"]=true;
		else
			PIGA["AHPlus"]["AHtooltip"]=false;
		end
	end);
	if PIG_MaxTocversion(40000) then
		fuFrame.AHPlus.AHUIoff =PIGCheckbutton(fuFrame.AHPlus,{"LEFT",fuFrame.AHPlus.AHtooltip,"RIGHT",220,0},{"禁止专业面板关闭","拍卖界面打开时禁止系统的专业面板自动关闭功能"})
		fuFrame.AHPlus.AHUIoff:SetScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA["AHPlus"]["AHUIoff"]=true;
				BusinessInfo.AHUIoff()
			else
				PIGA["AHPlus"]["AHUIoff"]=false;
				PIG_OptionsUI.RLUI:Show()
			end
		end);
		fuFrame.AHPlus.QuicAuc =PIGCheckbutton(fuFrame.AHPlus,{"TOPLEFT",fuFrame.AHPlus.AHtooltip,"BOTTOMLEFT",0,-20},{"鼠标右键快速拍卖","鼠标右键背包物品快速拍卖"})
		fuFrame.AHPlus.QuicAuc:SetScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA["AHPlus"]["QuicAuc"]=true;
				BusinessInfo.QuicAuc()
			else
				PIGA["AHPlus"]["QuicAuc"]=false;
				PIG_OptionsUI.RLUI:Show()
			end
		end);
		GameTooltip:HookScript("OnTooltipSetItem", function(self)
			local _, itemlink = self:GetItem()
			if itemlink then
				local itemID = GetItemInfoInstant(itemlink) 
				BusinessInfo.SetTooltipOfflineG(itemID,self)
			end
		end)
	else
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
			BusinessInfo.SetTooltipOfflineG(data.id,tooltip)
		end)
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
			if self.AHPlus.AHUIoff then self.AHPlus.AHUIoff:Enable() end
			if self.AHPlus.QuicAuc then self.AHPlus.QuicAuc:Enable() end
		else
			self.AHPlus.AHtooltip:Disable()
			if self.AHPlus.AHUIoff then self.AHPlus.AHUIoff:Disable() end
			if self.AHPlus.QuicAuc then self.AHPlus.QuicAuc:Disable() end
		end
	end
	fuFrame:HookScript("OnShow", function (self)
		self.AHPlus:SetChecked(PIGA["AHPlus"]["Open"])
		self.AHPlus.AHtooltip:SetChecked(PIGA["AHPlus"]["AHtooltip"])
		self.AHPlus.ScanSlider:PIGSetValue(PIGA["AHPlus"]["ScanTimeCD"])
		if self.AHPlus.AHUIoff then self.AHPlus.AHUIoff:SetChecked(PIGA["AHPlus"]["AHUIoff"]) end
		if self.AHPlus.QuicAuc then
			self.AHPlus.QuicAuc:SetChecked(PIGA["AHPlus"]["QuicAuc"])
		end
		fuFrame:ShowChecked()
	end);
	BusinessInfo.AHPlus_ADDUI()
end
