local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGLine=Create.PIGLine
local PIGCloseBut=Create.PIGCloseBut
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
function BusinessInfo.FastDiuqi()
	local fujiF,fujiTabBut=PIGOptionsList_R(AutoSellBuy_UI.F,"丢",60,"Left")
	fujiF:Show()
	fujiTabBut:Selected()
	BusinessInfo.ADDScroll(fujiF,gongnengName,"Diuqi",17,PIGA["AutoSellBuy"]["Diuqi_List"],{false,"AutoSellBuy","Diuqi_List"})
	QuickButUI.ButList[9]=function()	
		if PIGA["QuickBut"]["Open"] and PIGA["AutoSellBuy"]["Open"] and PIGA["AutoSellBuy"]["AddBut"] then
			local QkButUI = "QkBut_AutoSellBuy"
			if _G[QkButUI] then return end
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF"..gongnengName.."指定物品|r\n"..KEY_BUTTON2.."-|cff00FFFF打开"..GnName.."|r"
			local QkBut=PIGQuickBut(QkButUI,QuickTooltip,134409,nil,FrameLevel)
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
	local zidongkaishidiuqiFFF = CreateFrame("Frame");
	zidongkaishidiuqiFFF:RegisterEvent("BAG_UPDATE");
	zidongkaishidiuqiFFF:SetScript("OnEvent", function(self,event,arg1)
		if PIGA["AutoSellBuy"]["Diuqi_Tishi"] or PIGA["AutoSellBuy"]["Open_Tishi"] or PIGA["AutoSellBuy"]["Fen_Tishi"] then
			local beibaoInfo = {}
			for bag=0,bagIDMax do
				local bnum=GetContainerNumSlots(bag)
				for slot=1,bnum do
					local itemID=GetContainerItemID(bag,slot)
					if itemID then
						table.insert(beibaoInfo,itemID)
					end
				end
			end
			C_Timer.After(1,function()
				if QkBut_AutoSellBuy then
					if shifoucunzai(beibaoInfo,PIGA["AutoSellBuy"]["Diuqi_List"]) then
						QkBut_AutoSellBuy.Height:Show()
					else
						QkBut_AutoSellBuy.Height:Hide()
					end
				end
				if QkBut_FastOpen then
					if shifoucunzai(beibaoInfo,PIGA["AutoSellBuy"]["Open_List"]) then
						QkBut_FastOpen.Height:Show()
					else
						QkBut_FastOpen.Height:Hide()
					end
				end
				if QkBut_FastFen then
					if shifoucunzai(beibaoInfo,PIGA["AutoSellBuy"]["Fen_List"]) then
						QkBut_FastFen.Height:Show()
					else
						QkBut_FastFen.Height:Hide()
					end
				end
			end)
		end
	end);
	----
	fujiF.tishidiuqi = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-10},{"提示"..gongnengName, "有可"..gongnengName.."物品将会在"..L["ACTION_TABNAME2"].."按钮提示"})
	fujiF.tishidiuqi:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"]["Diuqi_Tishi"]=true;
		else
			PIGA["AutoSellBuy"]["Diuqi_Tishi"]=false;
		end
	end);
	---
	StaticPopupDialogs["FUZHIXIAOHUIZHILING"] = {
		text = "因暴雪API改动，无法自动"..gongnengName.."。\n新建一个宏并复制指令到宏内，拖动到技能条使用。\n或者复制到已有的宏尾部。这样在使用宏时将执行一次动作",
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
	fujiF.fuzhiCDM = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",160,-10},{110,22},"复制"..gongnengName.."指令");
	fujiF.fuzhiCDM:SetScript("OnClick", function(event, button)
		StaticPopup_Show ("FUZHIXIAOHUIZHILING");
	end)
	fujiF.yijianxiaohui = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",100,-46},{100,22},"手动"..gongnengName);
	fujiF.yijianxiaohui:SetScript("OnClick", function(event, button)
		Pig_DelItem()
	end)
	-----
	fujiF.tishidiuqi:SetChecked(PIGA["AutoSellBuy"]["Diuqi_Tishi"]);
end
----------
function Pig_DelItem()
	if QkBut_AutoSellBuy then
		QkBut_AutoSellBuy.Height:Hide();
	end
	local dataX = PIGA["AutoSellBuy"]["Diuqi_List"]
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