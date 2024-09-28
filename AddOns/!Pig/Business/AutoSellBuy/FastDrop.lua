local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGLine=Create.PIGLine
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGQuickBut=Create.PIGQuickBut
local Show_TabBut_R=Create.Show_TabBut_R
--
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID = C_Container.GetContainerItemID
local GetContainerItemLink = C_Container.GetContainerItemLink
local PickupContainerItem =C_Container.PickupContainerItem
local UseContainerItem =C_Container.UseContainerItem
local bagIDMax= addonTable.Data.bagData["bagIDMax"]
-------
local BusinessInfo=addonTable.BusinessInfo
local GnName,GnUI,GnIcon,FrameLevel = unpack(BusinessInfo.AutoSellBuyData)
local gongnengName = "丢弃"
local function shifoucunzai(beibaoInfo,dataX)
	for x=1,#beibaoInfo do
		for k=1,#dataX do
			if beibaoInfo[x]==dataX[k][1] then
				return true
			end
		end
	end
	return false
end
function Pig_DelItem() end
function BusinessInfo.FastDrop()
	local fujiF,fujiTabBut=PIGOptionsList_R(AutoSellBuy_UI.F,"丢",50,"Left")
	fujiF:Show()
	fujiTabBut:Selected()
	local gongnengNameE = "Diuqi"
	BusinessInfo.ADDScroll(fujiF,gongnengName,gongnengNameE,17,{false,"AutoSellBuy",gongnengNameE.."_List"})
	QuickButUI.ButList[9]=function()	
		if PIGA["QuickBut"]["Open"] and PIGA["AutoSellBuy"]["Open"] and PIGA["AutoSellBuy"]["AddBut"] then
			local QkButUI = "QkBut_AutoSellBuy"
			if _G[QkButUI] then return end
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF"..gongnengName.."指定物品|r\n"..KEY_BUTTON2.."-|cff00FFFF打开"..GnName.."|r"
			local QkBut=PIGQuickBut(QkButUI,QuickTooltip,135725,nil,FrameLevel)
			QkBut:SetScript("OnClick", function(self,button)
				if button=="LeftButton" then
					PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
					Pig_DelItem()
				else
					if AutoSellBuy_UI:IsShown() then
						AutoSellBuy_UI:Hide();
					else
						AutoSellBuy_UI:Show()
						Show_TabBut_R(AutoSellBuy_UI.F,fujiF,fujiTabBut)
					end
				end
			end);
		end
	end
	----
	fujiF.Bindings = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-10},{76,20},KEY_BINDING);
	fujiF.Bindings:SetScript("OnClick", function (self)
		Settings.OpenToCategory(Settings.KEYBINDINGS_CATEGORY_ID, addonName);
	end)
	local QkButAction=CreateFrame("Button","QkBut_AutoSellBuy_Del",UIParent, "SecureActionButtonTemplate");
	QkButAction:SetAttribute("type1", "macro");
	QkButAction:SetAttribute("macrotext", [=[/run Pig_DelItem()]=]);
	_G["BINDING_NAME_CLICK QkBut_AutoSellBuy_Del:LeftButton"]= "PIG"..gongnengName
	---
	fujiF.fuzhiCDM = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",160,-10},{110,20},"复制"..gongnengName.."指令");
	fujiF.fuzhiCDM:SetScript("OnClick", function(event, button)
		StaticPopup_Show ("AUTOSELLBUY_DROP");
	end)
	StaticPopupDialogs["AUTOSELLBUY_DROP"] = {
		text = "因暴雪API改动，无法自动"..gongnengName.."/一次"..gongnengName.."多个物品。\n可以复制此指令到已有的宏尾部。这样在使用宏时将执行一次动作",
		button1 = "知道了",
		OnAccept = function()
			editBoxXX = ChatEdit_ChooseBoxForSend()
			ChatEdit_ActivateChat(editBoxXX)
			editBoxXX:Insert("/run Pig_DelItem()")
			editBoxXX:HighlightText()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	---
	fujiF.runFun = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",100,-46},{90,22},"执行"..gongnengName);
	fujiF.runFun:SetScript("OnClick", function(event, button)
		Pig_DelItem()
	end)
	-----
	Pig_DelItem=function()
		local dataX = PIGA["AutoSellBuy"][gongnengNameE.."_List"]
		if #dataX>0 then
			for bag=0,bagIDMax do
				local xx=GetContainerNumSlots(bag) 
				for slot=1,xx do
					for k=1,#dataX do
						local itemID=GetContainerItemID(bag, slot)
						if itemID==dataX[k][1] then
							PickupContainerItem(bag, slot);
							DeleteCursorItem(bag, slot);
							return
						end
					end
				end 
			end
		else
			PIGinfotip:TryDisplayMessage(gongnengName.."目录为空,"..KEY_BUTTON2.."设置");
		end
	end
end