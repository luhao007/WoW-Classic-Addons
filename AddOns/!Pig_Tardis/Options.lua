local addonName, addonTable = ...;
local Create, Data, Fun, L, Default, Default_Per= unpack(PIG)
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGButton = Create.PIGButton
local PIGOptionsList=Create.PIGOptionsList
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGModCheckbutton=Create.PIGModCheckbutton
local PIGQuickBut=Create.PIGQuickBut

------
local TardisInfo = {}
addonTable.TardisInfo=TardisInfo
------------
local QuickBut_ID=13
local GnName,GnUI,GnIcon,FrameLevel = L["PIGaddonList"][addonName],"PIG_TardisUI",136011,30
TardisInfo.uidata={GnName,GnUI,GnIcon,FrameLevel,QuickBut_ID}
local fuFrame,fuFrameBut,Tooltip = unpack(Data.Ext[L.extLsit[1]])
if not fuFrame.OpenMode then return end
fuFrame.extaddonT:Hide()
local QuickButUI=_G[Data.QuickButUIname]
TardisInfo.fuFrame,TardisInfo.fuFrameBut=fuFrame,fuFrameBut
---
function TardisInfo.ADD_Options()
	fuFrame.Open = PIGModCheckbutton(fuFrame,{GnName,Tooltip},{"TOPLEFT",fuFrame,"TOPLEFT",20,-20})
	fuFrame.Open:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Tardis"]["Open"]=true;
			fuFrame.SetListF:Show()
			TardisInfo.ADD_UI()
		else
			PIGA["Tardis"]["Open"]=false;
			fuFrame.SetListF:Hide()
			PIG_OptionsUI.RLUI:Show()
		end
		QuickButUI.ButList[QuickBut_ID]()
		QuickButUI.ButList[QuickBut_ID+1]()
	end);
	fuFrame.Open.QKBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Tardis"]["AddBut"]=true
			QuickButUI.ButList[QuickBut_ID]()
		else
			PIGA["Tardis"]["AddBut"]=false
			PIG_OptionsUI.RLUI:Show();
		end
	end);
	QuickButUI.ButList[QuickBut_ID]=function()	
		if PIGA["QuickBut"]["Open"] and PIGA["Tardis"]["Open"] and PIGA["Tardis"]["AddBut"] then
			if QuickButUI.TardisOpen then return end
			QuickButUI.TardisOpen=true
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF打开"..GnName.."|r\n"..KEY_BUTTON2.."-|cff00FFFF"..SETTINGS.."|r"
			local QkBut=PIGQuickBut(nil,QuickTooltip,GnIcon,GnUI,FrameLevel)
			QkBut:HookScript("OnClick", function(self,button)
				if button=="RightButton" then
					if PIG_OptionsUI:IsShown() then
						PIG_OptionsUI:Hide()
					else
						PIG_OptionsUI:Show()
						Create.Show_TabBut(fuFrame,fuFrameBut)
					end
				end
			end);
		end
	end
	---重置配置
	fuFrame.CZ = PIGButton(fuFrame,{"TOPRIGHT",fuFrame,"TOPRIGHT",-20,-20},{60,22},"重置");  
	fuFrame.CZ:SetScript("OnClick", function ()
		StaticPopup_Show ("HUIFU_INVITE_INFO");
	end);
	StaticPopupDialogs["HUIFU_INVITE_INFO"] = {
		text = "此操作将\124cffff0000重置\124r"..GnName.."所有配置，需重载界面。\n确定重置?",
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			PIGA["Tardis"] = Default["Tardis"];
			PIGA["Tardis"]["Open"] = true;
			ReloadUI()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	---------
	fuFrame.SetListline = PIGLine(fuFrame,"TOP",-66)
	fuFrame.SetListF = PIGFrame(fuFrame)
	fuFrame.SetListF:SetPoint("TOPLEFT",fuFrame.SetListline,"BOTTOMLEFT",0,0);
	fuFrame.SetListF:SetPoint("BOTTOMRIGHT",fuFrame,"BOTTOMRIGHT",0,0);
	--
	local shelistx = {
		-- {"Chedui",L["TARDIS_CHEDUI"]},
		-- {"Houche",L["TARDIS_HOUCHE"]},
		{"Farm",L["TARDIS_CHETOU"]},
		{"Plane",L["TARDIS_PLANE"]},
		{"Yell",L["TARDIS_YELL"]},
	}
	local function ADD_setckbut(peizhiV,txtV)
		local SetListBut = PIGCheckbutton_R(fuFrame.SetListF,{ENABLE..txtV})
		SetListBut:SetScript("OnClick", function (self)
			if self:GetChecked() then
				PIGA["Tardis"][peizhiV]["Open"]=true
			else
				PIGA["Tardis"][peizhiV]["Open"]=false
			end
			PIG_OptionsUI.RLUI:Show()
		end);
		SetListBut:HookScript("OnShow", function (self)
			self:SetChecked(PIGA["Tardis"][peizhiV]["Open"])
		end);
	end
	for i=1,#shelistx do
		ADD_setckbut(shelistx[i][1],shelistx[i][2])
	end
	-- if PIG_MaxTocversion() then
	-- 	fuFrame.SetListF.cheduiLanguage = PIGFrame(fuFrame.SetListF)
	-- 	fuFrame.SetListF.cheduiLanguage:SetPoint("BOTTOMLEFT",fuFrame.SetListF,"BOTTOMLEFT",0,0);
	-- 	fuFrame.SetListF.cheduiLanguage:SetPoint("BOTTOMRIGHT",fuFrame.SetListF,"BOTTOMRIGHT",0,0);
	-- 	fuFrame.SetListF.cheduiLanguage:SetHeight(260);
	-- 	local enabled = C_LFGList.GetLanguageSearchFilter();
	-- 	-- local languages = C_LFGList.GetAvailableLanguageSearchFilter();--系统过滤器选择列表
	-- 	-- for k,v in pairs(languages) do
	-- 	-- 	enabled[k] = true;
	-- 	-- end
	-- 	local defaults = C_LFGList.GetDefaultLanguageSearchFilter();--默认过滤
	-- 	for k,v in pairs(defaults) do
	-- 		enabled[k] = true;
	-- 	end
	-- 	enabled["enUS"] = true;
	-- 	enabled["zhTW"] = true;
	-- 	enabled["zhCN"] = true;
	-- 	C_LFGList.SaveLanguageSearchFilter(enabled)
	-- 	for k,v in pairs(enabled) do
	-- 		local text = _G["LFG_LIST_LANGUAGE_"..string.upper(k)];
	-- 		local langua = PIGCheckbutton_R(fuFrame.SetListF.cheduiLanguage,{text,text})
	-- 		langua:Disable()
	-- 		langua:SetChecked(v)
	-- 		langua:SetScript("OnClick", function (self)
	-- 			self:SetChecked(true)
	-- 		end);
	-- 	end
	-- end
	TardisInfo.ADD_UI()
end
--======
fuFrame:HookScript("OnShow", function (self)
	if PIGA["Ver"][addonName] and PIG_OptionsUI:GetVer_NUM(addonName)<PIGA["Ver"][addonName] then
		self.UpdateVer:Show()
	end
	self.Open:SetChecked(PIGA["Tardis"]["Open"])
	self.Open.QKBut:SetChecked(PIGA["Tardis"]["AddBut"])
	if PIGA["Tardis"]["Open"] then
		self.SetListF:Show()
	else
		self.SetListF:Hide()
	end
end);
--===================================
fuFrame:RegisterEvent("ADDON_LOADED")   
fuFrame:RegisterEvent("PLAYER_LOGIN");
fuFrame:RegisterEvent("CHAT_MSG_ADDON"); 
fuFrame:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5)
	if event=="CHAT_MSG_ADDON" then
		PIG_OptionsUI.GetExtVerInfo(self,addonName,PIG_OptionsUI:GetVer_NUM(addonName), arg1, arg2, arg3, arg4, arg5)
	elseif event=="PLAYER_LOGIN" then
		PIGA["Ver"][addonName]=PIGA["Ver"][addonName] or 0
		if PIGA["Ver"][addonName]>PIG_OptionsUI:GetVer_NUM(addonName) then
			self.yiGenxing=true;
		else
			PIG_OptionsUI.SendExtVerInfo(addonName.."#U#"..PIG_OptionsUI:GetVer_NUM(addonName))
		end
	elseif event=="ADDON_LOADED" and arg1 == addonName then
		self:UnregisterEvent("ADDON_LOADED")
		addonTable.Load_Config()
		PIG_OptionsUI:SetVer_EXT(arg1,self)
		TardisInfo.ADD_Options()
	end
end)
-------
function PIGCompartmentClick_Tardis()
end
function PIGCompartmentEnter_Tardis(addonName, menuButtonFrame)
	GameTooltip:ClearLines();
	GameTooltip:SetOwner(menuButtonFrame, "ANCHOR_BOTTOMLEFT",-2,16);
	GameTooltip:AddLine("|cffFF00FF"..addonName.."|r-"..PIGGetAddOnMetadata(addonName, "Version"))
	GameTooltip:Show();	
end
function PIGCompartmentLeave_Tardis(addonName, menuButtonFrame)
	GameTooltip:ClearLines();
	GameTooltip:Hide() 
end