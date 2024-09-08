local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create, Data, Fun, L, Default, Default_Per= unpack(PIG)
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGButton = Create.PIGButton
local PIGOptionsList=Create.PIGOptionsList
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGModCheckbutton=Create.PIGModCheckbutton
local PIGQuickBut=Create.PIGQuickBut

local SendAddonMessage = SendAddonMessage or C_ChatInfo and C_ChatInfo.SendAddonMessage
------
local TardisInfo = {}
addonTable.TardisInfo=TardisInfo
------------
local GnName,GnUI,GnIcon,FrameLevel = L["PIGaddonList"][addonName],"Tardis_UI",132327,30
TardisInfo.uidata={GnName,GnUI,GnIcon,FrameLevel}
local fuFrame,fuFrameBut = PIGOptionsList(GnName,"EXT")
TardisInfo.fuFrame,TardisInfo.fuFrameBut=fuFrame,fuFrameBut
function TardisInfo.ADD_Options()
	local Tooltip = "!Pig组队增强功能，可查找队伍/车队/位面信息，喊话功能（支持自动邀请回复）"
	fuFrame.Open = PIGModCheckbutton(fuFrame,{GnName,Tooltip},{"TOPLEFT",fuFrame,"TOPLEFT",20,-20})
	fuFrame.Open:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Tardis"]["Open"]=true;
			fuFrame.SetListF:Show()
			TardisInfo.ADD_UI()
		else
			PIGA["Tardis"]["Open"]=false;
			fuFrame.SetListF:Hide()
			Pig_Options_RLtishi_UI:Show()
		end
		QuickButUI.ButList[13]()
	end);
	fuFrame.Open.QKBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Tardis"]["AddBut"]=true
			QuickButUI.ButList[13]()
		else
			PIGA["Tardis"]["AddBut"]=false
			Pig_Options_RLtishi_UI:Show();
		end
	end);
	QuickButUI.ButList[13]=function()	
		if PIGA["QuickBut"]["Open"] and PIGA["Tardis"]["Open"] and PIGA["Tardis"]["AddBut"] then
			local QkButUI = "QkBut_Invite"
			if _G[QkButUI] then return end
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF打开"..GnName.."|r\n"..KEY_BUTTON2.."-|cff00FFFF"..SETTINGS.."|r"
			local QkBut=PIGQuickBut(QkButUI,QuickTooltip,GnIcon,GnUI,FrameLevel)
			QkBut:HookScript("OnClick", function(self,button)
				if button=="RightButton" then
					if Pig_OptionsUI:IsShown() then
						Pig_OptionsUI:Hide()
					else
						Pig_OptionsUI:Show()
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
	---------========
	fuFrame.SetListline = PIGLine(fuFrame,"TOP",-66)
	fuFrame.SetListF = PIGFrame(fuFrame)
	fuFrame.SetListF:SetPoint("TOPLEFT",fuFrame.SetListline,"BOTTOMLEFT",0,0);
	fuFrame.SetListF:SetPoint("BOTTOMRIGHT",fuFrame,"BOTTOMRIGHT",0,0);
	--
	local shelistx = {
		-- {"Chedui",L["TARDIS_CHEDUI"]},
		-- {"Houche",L["TARDIS_HOUCHE"]},
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
			Pig_Options_RLtishi_UI:Show()
		end);
		SetListBut:HookScript("OnShow", function (self)
			self:SetChecked(PIGA["Tardis"][peizhiV]["Open"])
		end);
	end
	for i=1,#shelistx do
		ADD_setckbut(shelistx[i][1],shelistx[i][2])
	end
	if tocversion<100000 and tocversion>30000 then
		fuFrame.SetListF.cheduiLanguage = PIGFrame(fuFrame.SetListF)
		fuFrame.SetListF.cheduiLanguage:SetPoint("BOTTOMLEFT",fuFrame.SetListF,"BOTTOMLEFT",0,0);
		fuFrame.SetListF.cheduiLanguage:SetPoint("BOTTOMRIGHT",fuFrame.SetListF,"BOTTOMRIGHT",0,0);
		fuFrame.SetListF.cheduiLanguage:SetHeight(260);
		local enabled = C_LFGList.GetLanguageSearchFilter();
		-- local languages = C_LFGList.GetAvailableLanguageSearchFilter();--系统过滤器选择列表
		-- for k,v in pairs(languages) do
		-- 	enabled[k] = true;
		-- end
		local defaults = C_LFGList.GetDefaultLanguageSearchFilter();--默认过滤
		for k,v in pairs(defaults) do
			enabled[k] = true;
		end
		enabled["enUS"] = true;
		enabled["zhTW"] = true;
		enabled["zhCN"] = true;
		C_LFGList.SaveLanguageSearchFilter(enabled)
		for k,v in pairs(enabled) do
			local text = _G["LFG_LIST_LANGUAGE_"..string.upper(k)];
			local langua = PIGCheckbutton_R(fuFrame.SetListF.cheduiLanguage,{text,text})
			langua:Disable()
			langua:SetChecked(v)
			langua:SetScript("OnClick", function (self)
				self:SetChecked(true)
			end);
		end
	end
	---
end
--======
fuFrame:HookScript("OnShow", function (self)
	if self.VersionID<PIGA["Ver"][addonName] then
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
local GetExtVer=Pig_OptionsUI.GetExtVer
local SendMessage=Pig_OptionsUI.SendMessage
fuFrame.VersionID=0
fuFrame.GetVer=addonName.."#U#0"
fuFrame.FasVer=addonName.."#D#0"
fuFrame:RegisterEvent("ADDON_LOADED")   
fuFrame:RegisterEvent("PLAYER_LOGIN");
fuFrame:RegisterEvent("CHAT_MSG_ADDON"); 
fuFrame:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5)
	if event=="ADDON_LOADED" and arg1 == addonName then
		self:UnregisterEvent("ADDON_LOADED")
		addonTable.Load_Config()
		Pig_OptionsUI:SetVer_EXT(arg1,self)
	end
	if event=="PLAYER_LOGIN" then
		PIGA["Ver"][addonName]=PIGA["Ver"][addonName] or 0
		fuFrame.GetVer=addonName.."#U#"..self.VersionID;
		fuFrame.FasVer=addonName.."#D#"..self.VersionID;
		if PIGA["Ver"][addonName]>self.VersionID then
			self.yiGenxing=true;
		else
			SendMessage(fuFrame.GetVer)
		end
		TardisInfo.ADD_Options()
		TardisInfo.ADD_UI()
		QuickButUI.ButList[13]()
	end
	if event=="CHAT_MSG_ADDON" then
		GetExtVer(self,addonName,self.VersionID, fuFrame.FasVer, arg1, arg2, arg4)
	end 
end)
-------
function PIGCompartmentClick_Tardis()
end
function PIGCompartmentEnter_Tardis(addonName, menuButtonFrame)
	GameTooltip:ClearLines();
	GameTooltip:SetOwner(menuButtonFrame, "ANCHOR_BOTTOMLEFT",-2,16);
	GameTooltip:AddLine("|cffFF00FF"..addonName.."|r-"..GetAddOnMetadata(addonName, "Version"))
	GameTooltip:Show();	
end
function PIGCompartmentLeave_Tardis(addonName, menuButtonFrame)
	GameTooltip:ClearLines();
	GameTooltip:Hide() 
end