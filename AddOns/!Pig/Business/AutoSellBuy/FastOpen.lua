local _, addonTable = ...;
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.FastOpen()
	local L=addonTable.locale
	local Data=addonTable.Data
	local Fun=addonTable.Fun
	local PIGUseKeyDown=Fun.PIGUseKeyDown
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
	--
	local GnName,GnUI,GnIcon,FrameLevel = unpack(BusinessInfo.AutoSellBuyData)
	local _GN,_GNE = "开启","Open"
	local BindingName = GnUI.."_".._GNE
	local fujiF,fujiTabBut=PIGOptionsList_R(_G[GnUI].F,"开",50,"Left")
	BusinessInfo.ADDScroll(fujiF,_GN,_GNE,17,{false,"AutoSellBuy",_GNE.."_List"})
	------
	fujiF.Bindings = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-10},{76,20},KEY_BINDING);
	fujiF.Bindings:SetScript("OnClick", function (self)
		Settings.OpenToCategory(Settings.KEYBINDINGS_CATEGORY_ID, addonName);
	end)
	local QkButAction=CreateFrame("Button",BindingName,UIParent, "SecureActionButtonTemplate");
	QkButAction:SetAttribute("type1", "item")
	PIGUseKeyDown(QkButAction)
	_G["BINDING_NAME_CLICK "..BindingName..":LeftButton"]= "PIG"..GnName.._GN
	local function zhixingClick(self,button)
		if button=="LeftButton" then
			if InCombatLockdown() then
				PIG_OptionsUI:ErrorMsg(ERR_NOT_IN_COMBAT)
			else
				local shujuy =PIGA["AutoSellBuy"][_GNE.."_List"]
				if #shujuy>0 then
					for bag=0,bagIDMax do			
						local bganum=GetContainerNumSlots(bag)
						for slot=1,bganum do	
							local itemID=GetContainerItemID(bag, slot)
							if itemID then
								for k=1,#shujuy do
									if itemID==shujuy[k][1] then
										local itemLink = GetContainerItemLink(bag, slot);
										self:SetAttribute("item1", itemLink)
										return
									end
								end
							end
						end
					end
					PIG_OptionsUI:ErrorMsg("没有需".._GN.."物品")
				else
					PIG_OptionsUI:ErrorMsg(_GN.."目录为空,"..KEY_BUTTON2.."设置")
				end	
			end
		end
	end
	QkButAction:HookScript("PreClick",  function (self,button)
		zhixingClick(self,button)
	end);
	---
	local QuickButUI=_G[Data.QuickButUIname]
	fujiF.QkBut = PIGCheckbutton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-44},{"添加".._GN.."到"..L["ACTION_TABNAME2"], "在"..L["ACTION_TABNAME2"].."增加一个快捷使用按钮"})
	fujiF.QkBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["AutoSellBuy"][_GNE.."_QkBut"]=true;
			QuickButUI.ButList[10]()
			self.RL:Hide()
		else
			PIGA["AutoSellBuy"][_GNE.."_QkBut"]=false;
			self.RL:Show()
		end
	end);
	fujiF.QkBut.RL = PIGButton(fujiF.QkBut,{"LEFT",fujiF.QkBut.Text,"RIGHT",4,0},{60,20},"重载UI")
	fujiF.QkBut.RL:Hide()
	fujiF.QkBut.RL:SetScript("OnClick", function (self)
		ReloadUI()
	end)
	fujiF:HookScript("OnShow", function (self)
		self.QkBut:SetChecked(PIGA["AutoSellBuy"][_GNE.."_QkBut"])
	end);
	QuickButUI.ButList[10]=function()
		if PIGA["QuickBut"]["Open"] and PIGA["AutoSellBuy"]["Open"] and PIGA["AutoSellBuy"][_GNE.."_QkBut"] then
			if QuickButUI[_GNE] then return end
			QuickButUI[_GNE]=true
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF".._GN.."指定物品|r\n"..KEY_BUTTON2.."-|cff00FFFF打开"..GnName.."|r"
			local QkBut=PIGQuickBut(nil,QuickTooltip,136058,nil,FrameLevel,"SecureActionButtonTemplate")
			QkBut:SetAttribute("type1", "item")
			PIGUseKeyDown(QkBut)
			QkBut:HookScript("PreClick",  function (self,button)
				zhixingClick(self,button)
			end);
			QkBut:HookScript("OnClick", function(self,button)
				if button=="RightButton" then
					if _G[GnUI]:IsShown() then
						_G[GnUI]:Hide();
					else
						_G[GnUI]:Show();
						Show_TabBut_R(_G[GnUI].F,fujiF,fujiTabBut)
					end
				end
			end);
		end
	end
end