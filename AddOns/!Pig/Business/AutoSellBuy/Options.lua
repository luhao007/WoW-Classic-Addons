local _, addonTable = ...;
local L=addonTable.locale
local Data=addonTable.Data
local Create=addonTable.Create
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
local PIGModCheckbutton=Create.PIGModCheckbutton
------
local BusinessInfo=addonTable.BusinessInfo
local fuFrame,fuFrameBut = BusinessInfo.fuFrame,BusinessInfo.fuFrameBut
local GnName,GnUI,GnIcon,FrameLevel = "售卖助手","PIG_AutoSellBuy",136453,20
BusinessInfo.AutoSellBuyData={GnName,GnUI,GnIcon,FrameLevel}
------------
function BusinessInfo.AutoSellBuyOptions()
	fuFrame.AutoSellBuy_line = PIGLine(fuFrame,"TOP",-(fuFrame.dangeH*fuFrame.GNNUM))
	fuFrame.GNNUM=fuFrame.GNNUM+2
	local QuickButUI=_G[Data.QuickButUIname]
	local QuickButUI_index=10
	local function QuickButUI_addFun()
		QuickButUI.ButList[QuickButUI_index]()
		QuickButUI.ButList[QuickButUI_index+1]()
		QuickButUI.ButList[QuickButUI_index+2]()
		QuickButUI.ButList[QuickButUI_index+3]()
	end
	local Tooltip = {GnName,"包含一键丢弃/自动卖出/自动购买/快捷开箱盒蚌/快捷分解,一键拿取存储物品到银行"};
	fuFrame.AutoSellBuy = PIGModCheckbutton(fuFrame,Tooltip,{"TOPLEFT",fuFrame.AutoSellBuy_line,"TOPLEFT",20,-30})
	fuFrame.AutoSellBuy:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"]["Open"]=true;
			BusinessInfo.AutoSellBuy_ADDUI()
		else
			PIGA["AutoSellBuy"]["Open"]=false;
			PIG_OptionsUI.RLUI:Show()
		end
		QuickButUI_addFun()
		
	end);
	fuFrame.AutoSellBuy.QKBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"]["AddBut"]=true
			QuickButUI_addFun()
		else
			PIGA["AutoSellBuy"]["AddBut"]=false
			PIG_OptionsUI.RLUI:Show();
		end
	end);
	fuFrame.AutoSellBuy.CZ = Create.PIGButton(fuFrame.AutoSellBuy,{"LEFT",fuFrame.AutoSellBuy.QKBut,"RIGHT",260,0},{60,22},"重置");  
	fuFrame.AutoSellBuy.CZ:SetScript("OnClick", function (self,button)
		StaticPopup_Show ("AUTOSELLBUY_CZQIANGKONGINFO");
	end);
	PIGEnter(fuFrame.AutoSellBuy.CZ,"|cffff0000重置|r"..GnName.."所有配置")
	StaticPopupDialogs["AUTOSELLBUY_CZQIANGKONGINFO"] = {
		text = "此操作将\124cffff0000重置\124r"..GnName.."所有配置，需重载界面。\n确定重置?",
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			PIGA["AutoSellBuy"]=addonTable.Default["AutoSellBuy"];
			PIGA_Per["AutoSellBuy"]=addonTable.Default["AutoSellBuy"];
			PIGA["AutoSellBuy"]["Open"] = true;
			ReloadUI()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	--------
	fuFrame:HookScript("OnShow", function (self)
		self.AutoSellBuy:SetChecked(PIGA["AutoSellBuy"]["Open"])
		self.AutoSellBuy.QKBut:SetChecked(PIGA["AutoSellBuy"]["AddBut"])
	end);
	BusinessInfo.AutoSellBuy_ADDUI(QuickButUI_index)
end
