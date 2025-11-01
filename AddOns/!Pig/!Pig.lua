----<本插件初始为猪猪加油定制插件,现已公开分享>---562314----
local addonName, addonTable = ...;
local L=addonTable.locale
local Data=addonTable.Data
SLASH_RELOAD1 = '/rl'
SlashCmdList["RELOAD"] = ReloadUI
SLASH_PIG1 = "/pig"
SLASH_PIG2 = "/pig"
SLASH_PIG3 = "/PIG"
SlashCmdList["PIG"] = function()
	PIG_OptionsUI:Show();
end
addonTable.ShareDB={}
_G.PIG = {addonTable.Create,addonTable.Data,addonTable.Fun,L,addonTable.Default,addonTable.Default_Per,addonTable.AudioList,addonTable.ShareDB}
--===============================
EventUtil.ContinueOnAddOnLoaded(addonName, function()
	addonTable.Load_Config()
	PIG_OptionsUI:SetVer_EXT(addonName)
end)
local PIGUI = CreateFrame("Frame")        
PIGUI:RegisterEvent("PLAYER_LOGIN");
PIGUI:SetScript("OnEvent",function(self, event, arg1)
	addonTable.ShareConfig()
	addonTable.Get_PlayerRealmData()
	addonTable.UpdateMiniButPoint()
	addonTable.CVars()
	--
	addonTable.Map()
	addonTable.CombatPlus()
	addonTable.Common()
	addonTable.ActionBar()
	addonTable.TooltipPlus()
	addonTable.FramePlus()
	addonTable.UnitFrame()
	addonTable.Business()
	addonTable.BagBank()
	addonTable.Chat()
	addonTable.PigLayout()
	--
	_G[Data.QuickButUIname]:Add()
	addonTable.CollectMiniMapBut()
	------------------------------
	if not PIGA["Other"]["PigLoad"] then
		PIG_print(L["ABOUT_LOAD"]..L["ABOUT_REMINDER"])
	end  
end)