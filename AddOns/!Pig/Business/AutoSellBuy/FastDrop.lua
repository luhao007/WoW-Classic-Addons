local _, addonTable = ...;
local BusinessInfo=addonTable.BusinessInfo
function Pig_DelItem() end
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
function BusinessInfo.FastDrop(QuickButUI_index)
	local L=addonTable.locale
	local Data=addonTable.Data
	local Create=addonTable.Create
	local PIGButton = Create.PIGButton
	local PIGCheckbutton=Create.PIGCheckbutton
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
	---
	local GnName,GnUI,GnIcon,FrameLevel = unpack(BusinessInfo.AutoSellBuyData)
	local _GN,_GNE = "丢弃","Diuqi"
	local BindingName = GnUI.."_".._GNE
	local fujiF,fujiTabBut=PIGOptionsList_R(_G[GnUI].F,"丢",50,"Left")
	fujiF:Show()
	fujiTabBut:Selected()
	BusinessInfo.ADDScroll(fujiF,_GN,_GNE,17,{false,"AutoSellBuy",_GNE.."_List"})
	----
	fujiF.Bindings = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-10},{76,20},KEY_BINDING);
	fujiF.Bindings:SetScript("OnClick", function (self)
		Settings.OpenToCategory(Settings.KEYBINDINGS_CATEGORY_ID, addonName);
	end)
	local QkButAction=CreateFrame("Button",BindingName,UIParent, "SecureActionButtonTemplate");
	QkButAction:SetAttribute("type1", "macro");
	QkButAction:SetAttribute("macrotext", [=[/run Pig_DelItem()]=]);
	_G["BINDING_NAME_CLICK "..BindingName..":LeftButton"]= "PIG"..GnName.._GN
	---
	fujiF.fuzhiCDM = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",160,-10},{110,20},"复制".._GN.."指令");
	fujiF.fuzhiCDM:SetScript("OnClick", function(event, button)
		StaticPopup_Show ("AUTOSELLBUY_DROP");
	end)
	StaticPopupDialogs["AUTOSELLBUY_DROP"] = {
		text = "因暴雪API改动，无法自动".._GN.."/一次".._GN.."多个物品。\n可以复制此指令到已有的宏尾部。这样在使用宏时将执行一次动作",
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
	fujiF.runFun = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",100,-46},{90,22},"执行".._GN);
	fujiF.runFun:SetScript("OnClick", function(event, button)
		Pig_DelItem()
	end)
	-----
	Pig_DelItem=function(ly)
		local dataX = PIGA["AutoSellBuy"][_GNE.."_List"]
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
			if ly==1 then
				PIG_OptionsUI:ErrorMsg(_GN.."目录为空,"..KEY_BUTTON2.."设置");
			else
				PIG_OptionsUI:ErrorMsg(_GN.."目录为空");
			end
		end
	end
	local QuickButUI=_G[Data.QuickButUIname]
	QuickButUI.ButList[QuickButUI_index]=function()	
		if PIGA["QuickBut"]["Open"] and PIGA["AutoSellBuy"]["Open"] and PIGA["AutoSellBuy"]["AddBut"] then
			if QuickButUI[_GNE] then return end
			QuickButUI[_GNE]=true
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF".._GN.."指定物品|r\n"..KEY_BUTTON2.."-|cff00FFFF打开"..GnName.."|r"
			local QkBut=PIGQuickBut(nil,QuickTooltip,134152,nil,FrameLevel)----133799
			QkBut:SetScript("OnClick", function(self,button)
				if button=="LeftButton" then
					PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
					Pig_DelItem(1)
				else
					if _G[GnUI]:IsShown() then
						_G[GnUI]:Hide();
					else
						_G[GnUI]:Show()
						Show_TabBut_R(_G[GnUI].F,fujiF,fujiTabBut)
					end
				end
			end);
		end
	end
end