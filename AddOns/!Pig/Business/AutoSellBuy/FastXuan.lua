local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Fun=addonTable.Fun
local Create=addonTable.Create
local PIGButton = Create.PIGButton
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGEnter=Create.PIGEnter
local PIGQuickBut=Create.PIGQuickBut
local PIGCheckbutton=Create.PIGCheckbutton
local Show_TabBut_R=Create.Show_TabBut_R
--
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID = C_Container.GetContainerItemID
local GetContainerItemLink = C_Container.GetContainerItemLink
local PickupContainerItem =C_Container.PickupContainerItem
local bagIDMax= addonTable.Data.bagData["bagIDMax"]
-- 
local BusinessInfo=addonTable.BusinessInfo
local GnName,GnUI,GnIcon,FrameLevel = unpack(BusinessInfo.AutoSellBuyData)
local hang_Height,hang_NUM  = 24, 17;
BusinessInfo.Xuanbuticon=134081
local gongnengName = "选矿"

function BusinessInfo.FastXuan()
	local PIGUseKeyDown=Fun.PIGUseKeyDown
	local fujiF,fujiTabBut=PIGOptionsList_R(AutoSellBuy_UI.F,"选",50,"Left")
	BusinessInfo.ADDScroll(fujiF,gongnengName,"Xuan",18,PIGA["AutoSellBuy"]["Xuan_List"],{false,"AutoSellBuy","Xuan_List"})
	local DestroyMacro = "/cast %s\n/use %d %d"
	local XuanItemKey = CreateFrame("Button","XuanItemKey",UIParent, "SecureActionButtonTemplate");
	PIGUseKeyDown(XuanItemKey)
	XuanItemKey:SetAttribute("type", "macro")
	local function zhixingClick(self,button)
		if not IsPlayerSpell(31252) then PIGinfotip:TryDisplayMessage("你尚未学会"..gongnengName.."技能") return end
		if InCombatLockdown() then
			PIGinfotip:TryDisplayMessage("请在脱战后使用")
		else
			self:SetAttribute("macrotext", " ")
			if button=="LeftButton" then
				local shujuy =PIGA["AutoSellBuy"]["Xuan_List"]
				if #shujuy>0 then
					for bag=0,bagIDMax do			
						local xx=GetContainerNumSlots(bag)
						for slot=1,xx do
							local itemID=GetContainerItemID(bag, slot)
							for k=1,#shujuy do
								if itemID==shujuy[k][1] then
									local Xuanspellname = PIGGetSpellInfo(31252)
									self:SetAttribute("macrotext", string.format(DestroyMacro, Xuanspellname, bag, slot))
									return
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
	XuanItemKey:HookScript("PreClick",  function (self,button)
		zhixingClick(self,button)
	end);
	---
	local QkButUI = "QkBut_FastXuan"
	QuickButUI.ButList[12]=function()
		if PIGA["QuickBut"]["Open"] and PIGA["AutoSellBuy"]["Open"] and PIGA["AutoSellBuy"]["Xuan_QkBut"] then
			if _G[QkButUI] then return end
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF"..gongnengName.."指定物品|r\n"..KEY_BUTTON2.."-|cff00FFFF打开"..GnName.."|r"
			local QkBut=PIGQuickBut(QkButUI,QuickTooltip,BusinessInfo.Xuanbuticon,nil,FrameLevel,"SecureActionButtonTemplate")
			QkBut:SetAttribute("type", "macro")
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
	fujiF.Xuan_Tishi = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-6},{"提示"..gongnengName, "有可"..gongnengName.."物品将会在"..L["ACTION_TABNAME2"].."按钮提示"})
	fujiF.Xuan_Tishi:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"]["Xuan_Tishi"]=true;
		else
			PIGA["AutoSellBuy"]["Xuan_Tishi"]=false;
		end
	end);
	fujiF.Xuan_Tishi:SetChecked(PIGA["AutoSellBuy"]["Xuan_Tishi"])
	fujiF.QkBut = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",140,-6},{"添加到"..L["ACTION_TABNAME2"], "在"..L["ACTION_TABNAME2"].."增加一个快捷使用按钮"})
	fujiF.QkBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"]["Xuan_QkBut"]=true;
			QuickButUI.ButList[12]()
			self.RL:Hide()
		else
			PIGA["AutoSellBuy"]["Xuan_QkBut"]=false;
			self.RL:Show()
		end
	end);
	fujiF.QkBut:SetChecked(PIGA["AutoSellBuy"]["Xuan_QkBut"])

	fujiF.QkBut.RL = PIGButton(fujiF.QkBut,{"LEFT",fujiF.QkBut.Text,"RIGHT",4,0},{60,20},"重载UI")
	fujiF.QkBut.RL:Hide()
	fujiF.QkBut.RL:SetScript("OnClick", function (self)
		ReloadUI()
	end)
	
	fujiF.fuzhiCDM = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",60,-32},{90,22},"创建"..gongnengName.."宏");
	PIGEnter(fujiF.fuzhiCDM,"注意:","|cffFF0000当你更改<按下按键时施法>请更新一次宏|r")
	local hongName = "PIGXuan"
	fujiF.fuzhiCDM:HookScript("OnShow", function (self)
		local macroSlot = GetMacroIndexByName(hongName)
		if macroSlot>0 then
			self:SetText("更新"..gongnengName.."宏");
		else
			self:SetText("创建"..gongnengName.."宏");
		end
	end)
	local function ADD_kaiqiHong()
		local hongNR = [=[/click XuanItemKey]=]
		local UseKeyDown =GetCVar("ActionButtonUseKeyDown")
		if UseKeyDown=="0" then
			hongNR = [=[/click XuanItemKey LeftButton 0]=]
		elseif UseKeyDown=="1" then
			hongNR = [=[/click XuanItemKey LeftButton 1]=]
		end
		local macroSlot = GetMacroIndexByName(hongName)
		if macroSlot>0 then
			EditMacro(macroSlot, nil, BusinessInfo.Xuanbuticon, hongNR)
			PIGinfotip:TryDisplayMessage("已更新"..gongnengName.."宏");
		else
			local global, perChar = GetNumMacros()
			if global<120 then
				CreateMacro(hongName, BusinessInfo.Xuanbuticon, hongNR, nil)
				fujiF.fuzhiCDM:SetText("更新"..gongnengName.."宏");
			else
				PIGinfotip:TryDisplayMessage(L["LIB_MACROERR"]);
				return
			end
		end
	end
	fujiF.fuzhiCDM:SetScript("OnClick",  function (self)
		if self:GetText()=="创建"..gongnengName.."宏" then
			StaticPopup_Show("ADD_Xuan_HONG");
		else
			ADD_kaiqiHong()
		end	
	end)
	StaticPopupDialogs["ADD_Xuan_HONG"] = {
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