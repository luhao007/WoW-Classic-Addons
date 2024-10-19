local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Fun=addonTable.Fun
local Create=addonTable.Create
local PIGButton = Create.PIGButton
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGEnter=Create.PIGEnter
local PIGQuickBut=Create.PIGQuickBut
local Show_TabBut_R=Create.Show_TabBut_R
local PIGCheckbutton=Create.PIGCheckbutton
--
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID = C_Container.GetContainerItemID
local GetContainerItemLink = C_Container.GetContainerItemLink
local PickupContainerItem =C_Container.PickupContainerItem
-- 
local bagIDMax= addonTable.Data.bagData["bagIDMax"]
local BusinessInfo=addonTable.BusinessInfo
local GnName,GnUI,GnIcon,FrameLevel = unpack(BusinessInfo.AutoSellBuyData)
local OpenData = {"开启",136058}

function BusinessInfo.FastOpen()
	local PIGUseKeyDown=Fun.PIGUseKeyDown
	local gongnengNameE = "Open"
	local hongName = "PIG"..gongnengNameE
	local fujiF,fujiTabBut=PIGOptionsList_R(AutoSellBuy_UI.F,"开",50,"Left")
	BusinessInfo.ADDScroll(fujiF,OpenData[1],gongnengNameE,17,{false,"AutoSellBuy",gongnengNameE.."_List"})
	------
	fujiF.Bindings = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-10},{76,20},KEY_BINDING);
	fujiF.Bindings:SetScript("OnClick", function (self)
		Settings.OpenToCategory(Settings.KEYBINDINGS_CATEGORY_ID, addonName);
	end)
	local QkButAction=CreateFrame("Button","QkBut_AutoSellBuy_"..gongnengNameE,UIParent, "SecureActionButtonTemplate");
	QkButAction:SetAttribute("type1", "item")
	PIGUseKeyDown(QkButAction)
	_G["BINDING_NAME_CLICK QkBut_AutoSellBuy_"..gongnengNameE..":LeftButton"]= "PIG"..OpenData[1]
	local function zhixingClick(self,button)
		if button=="LeftButton" then
			if InCombatLockdown() then
				PIGinfotip:TryDisplayMessage(ERR_NOT_IN_COMBAT)
			else
				local shujuy =PIGA["AutoSellBuy"][gongnengNameE.."_List"]
				if #shujuy>0 then
					for bag=0,bagIDMax do			
						local bganum=GetContainerNumSlots(bag)
						for slot=1,bganum do	
							local itemID=GetContainerItemID(bag, slot)
							if itemID then
								for k=1,#shujuy do
									if itemID==shujuy[k][1] then
										local itemLink = GetContainerItemLink(bag, slot);
										self:SetAttribute("item", itemLink)
										return
									end
								end
							end
						end
					end
					PIGinfotip:TryDisplayMessage("没有需"..OpenData[1].."物品")
				else
					PIGinfotip:TryDisplayMessage(OpenData[1].."目录为空,"..KEY_BUTTON2.."设置")
				end	
			end
		end
	end
	QkButAction:HookScript("PreClick",  function (self,button)
		zhixingClick(self,button)
	end);
	--宏-----
	if tocversion<50000 then
		fujiF.fuzhiCDM = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",160,-10},{100,20},CALENDAR_CREATE..OpenData[1]..MACRO);
		fujiF.fuzhiCDM:HookScript("OnClick",  function (self)
			local macroSlot = GetMacroIndexByName(hongName)
			if macroSlot>0 then
				PIGinfotip:TryDisplayMessage(OpenData[1]..MACRO.."已存在");
			else
				StaticPopup_Show("AUTOSELLBUY_"..OpenData[1]);
			end	
		end)
		local hongNR = [=[/click QkBut_AutoSellBuy_Open LeftButton]=]
		StaticPopupDialogs["AUTOSELLBUY_"..OpenData[1]] = {
			text = CALENDAR_CREATE..OpenData[1]..MACRO.."\n\n确定创建吗？",
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				local global, perChar = GetNumMacros()
				if global<120 then
					CreateMacro(hongName, OpenData[2], hongNR, nil)
					PIGinfotip:TryDisplayMessage("已"..CALENDAR_CREATE..OpenData[1]..MACRO);
				else
					PIGinfotip:TryDisplayMessage(L["LIB_MACROERR"]);
					return
				end
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
	else
		local macroSlot = GetMacroIndexByName(hongName)
		if macroSlot>0 then
			DeleteMacro(hongName)
		end
	end
	---
	fujiF.QkBut = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-44},{"添加"..OpenData[1].."到"..L["ACTION_TABNAME2"], "在"..L["ACTION_TABNAME2"].."增加一个快捷使用按钮"})
	fujiF.QkBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"][gongnengNameE.."_QkBut"]=true;
			QuickButUI.ButList[10]()
			self.RL:Hide()
		else
			PIGA["AutoSellBuy"][gongnengNameE.."_QkBut"]=false;
			self.RL:Show()
		end
	end);
	fujiF.QkBut.RL = PIGButton(fujiF.QkBut,{"LEFT",fujiF.QkBut.Text,"RIGHT",4,0},{60,20},"重载UI")
	fujiF.QkBut.RL:Hide()
	fujiF.QkBut.RL:SetScript("OnClick", function (self)
		ReloadUI()
	end)
	fujiF:HookScript("OnShow", function (self)
		self.QkBut:SetChecked(PIGA["AutoSellBuy"][gongnengNameE.."_QkBut"])
	end);
	QuickButUI.ButList[10]=function()
		if PIGA["QuickBut"]["Open"] and PIGA["AutoSellBuy"]["Open"] and PIGA["AutoSellBuy"][gongnengNameE.."_QkBut"] then
			local QkButUI = "QkBut_Fast"..gongnengNameE
			if _G[QkButUI] then return end
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF"..OpenData[1].."指定物品|r\n"..KEY_BUTTON2.."-|cff00FFFF打开"..GnName.."|r"
			local QkBut=PIGQuickBut(QkButUI,QuickTooltip,OpenData[2],nil,FrameLevel,"SecureActionButtonTemplate")
			QkBut:SetAttribute("type1", "item")
			PIGUseKeyDown(QkBut)
			QkBut:HookScript("PreClick",  function (self,button)
				zhixingClick(self,button)
			end);
			QkBut:HookScript("OnClick", function(self,button)
				if button=="RightButton" then
					if AutoSellBuy_UI:IsShown() then
						AutoSellBuy_UI:Hide();
					else
						AutoSellBuy_UI:Show();
						Show_TabBut_R(AutoSellBuy_UI.F,fujiF,fujiTabBut)
					end
				end
			end);
		end
	end
end