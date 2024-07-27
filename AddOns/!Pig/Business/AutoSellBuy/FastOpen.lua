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
local UseContainerItem =C_Container.UseContainerItem
-- 
local bagIDMax= addonTable.Data.bagData["bagIDMax"]
local gongnengName = "开启"
local buticon=136058
local BusinessInfo=addonTable.BusinessInfo
local GnName,GnUI,GnIcon,FrameLevel = unpack(BusinessInfo.AutoSellBuyData)

function BusinessInfo.FastOpen()
	local PIGUseKeyDown=Fun.PIGUseKeyDown
	local fujiF,fujiTabBut=PIGOptionsList_R(AutoSellBuy_UI.F,"开",60,"Left")
	BusinessInfo.ADDScroll(fujiF,gongnengName,"Open",18,PIGA["AutoSellBuy"]["Open_List"],{false,"AutoSellBuy","Open_List"})
	local OpenItemKey = CreateFrame("Button","OpenItemKey",UIParent, "SecureActionButtonTemplate");
	PIGUseKeyDown(OpenItemKey)
	OpenItemKey:SetAttribute("type", "item")
	local function zhixingClick(self,button)
		if button=="LeftButton" then
			if InCombatLockdown() then
				PIGinfotip:TryDisplayMessage("请在脱战后使用")
			else
				local shujuy =PIGA["AutoSellBuy"]["Open_List"]
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
					PIGinfotip:TryDisplayMessage("没有需"..gongnengName.."物品")
				else
					PIGinfotip:TryDisplayMessage(gongnengName.."目录为空,"..KEY_BUTTON2.."设置")
				end	
			end
		end
	end
	OpenItemKey:HookScript("PreClick",  function (self,button)
		zhixingClick(self,button)
	end);
	---
	QuickButUI.ButList[10]=function()
		if PIGA["QuickBut"]["Open"] and PIGA["AutoSellBuy"]["Open"] and PIGA["AutoSellBuy"]["Open_QkBut"] then
			local QkButUI = "QkBut_FastOpen"
			if _G[QkButUI] then return end
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF"..gongnengName.."指定物品|r\n"..KEY_BUTTON2.."-|cff00FFFF打开"..GnName.."|r"
			local QkBut=PIGQuickBut(QkButUI,QuickTooltip,buticon,nil,FrameLevel,"SecureActionButtonTemplate")
			QkBut:SetAttribute("type", "item")
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
	fujiF.Open_Tishi = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-6},{"提示"..gongnengName, "有可"..gongnengName.."物品将会在"..L["ACTION_TABNAME2"].."按钮提示"})
	fujiF.Open_Tishi:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"]["Open_Tishi"]=true;
		else
			PIGA["AutoSellBuy"]["Open_Tishi"]=false;
		end
	end);
	fujiF.Open_Tishi:SetChecked(PIGA["AutoSellBuy"]["Open_Tishi"])
	fujiF.QkBut = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",140,-6},{"添加到"..L["ACTION_TABNAME2"], "在"..L["ACTION_TABNAME2"].."增加一个快捷使用按钮"})
	fujiF.QkBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"]["Open_QkBut"]=true;
			QuickButUI.ButList[10]()
			self.RL:Hide()
		else
			PIGA["AutoSellBuy"]["Open_QkBut"]=false;
			self.RL:Show()
		end
	end);
	fujiF.QkBut:SetChecked(PIGA["AutoSellBuy"]["Open_QkBut"])

	fujiF.QkBut.RL = PIGButton(fujiF.QkBut,{"LEFT",fujiF.QkBut.Text,"RIGHT",4,0},{60,20},"重载UI")
	fujiF.QkBut.RL:Hide()
	fujiF.QkBut.RL:SetScript("OnClick", function (self)
		ReloadUI()
	end)
	--
	fujiF.fuzhiCDM = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",60,-32},{90,22},"创建"..gongnengName.."宏");
	PIGEnter(fujiF.fuzhiCDM,"注意:","|cffFF0000当你更改<按下按键时施法>请更新一次宏|r")
	local hongName = "PIGOpen"
	fujiF.fuzhiCDM:HookScript("OnShow", function (self)
		local macroSlot = GetMacroIndexByName(hongName)
		if macroSlot>0 then
			self:SetText("更新"..gongnengName.."宏");
		else
			self:SetText("创建"..gongnengName.."宏");
		end
	end)
	local function ADD_kaiqiHong()
		local hongNR = [=[/click OpenItemKey]=]
		local UseKeyDown =GetCVar("ActionButtonUseKeyDown")
		if UseKeyDown=="0" then
			hongNR = [=[/click OpenItemKey LeftButton 0]=]
		elseif UseKeyDown=="1" then
			hongNR = [=[/click OpenItemKey LeftButton 1]=]
		end
		local macroSlot = GetMacroIndexByName(hongName)
		if macroSlot>0 then
			EditMacro(macroSlot, nil, buticon, hongNR)
			PIGinfotip:TryDisplayMessage("已更新"..gongnengName.."宏");
		else
			local global, perChar = GetNumMacros()
			if global<120 then
				CreateMacro(hongName, buticon, hongNR, nil)
				fujiF.fuzhiCDM:SetText("更新"..gongnengName.."宏");
			else
				PIGinfotip:TryDisplayMessage(L["LIB_MACROERR"]);
				return
			end
		end
	end
	fujiF.fuzhiCDM:HookScript("OnClick",  function (self)
		if self:GetText()=="创建"..gongnengName.."宏" then
			StaticPopup_Show("ADD_OPEN_HONG");
		else
			ADD_kaiqiHong()
		end	
	end)
	StaticPopupDialogs["ADD_OPEN_HONG"] = {
		text = "将创建一个"..gongnengName.."宏，请拖拽到动作条使用\n\n确定创建吗？\n\n|cffFF0000当你更改<按下按键时施法>请更新一次宏|r",
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			ADD_kaiqiHong()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
end