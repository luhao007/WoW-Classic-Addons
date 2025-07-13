local addonName, addonTable = ...;
local Create, Data, Fun, L, Default, Default_Per,AudioList= unpack(PIG)
local PIGOptionsList=Create.PIGOptionsList
local PIGModbutton=Create.PIGModbutton
-------------------
local fuFrame = CreateFrame("Frame")
fuFrame:RegisterEvent("ADDON_LOADED")   
fuFrame:RegisterEvent("PLAYER_LOGIN");
fuFrame:RegisterEvent("CHAT_MSG_ADDON"); 
fuFrame:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5)
    if event=="CHAT_MSG_ADDON" then
		PIG_OptionsUI.GetExtVerInfo(self,addonName,PIG_OptionsUI:GetVer_NUM(addonName,"audio"), arg1, arg2, arg3, arg4, arg5)
	elseif event=="PLAYER_LOGIN" then
		PIGA["Ver"][addonName]=PIGA["Ver"][addonName] or 0
		if PIGA["Ver"][addonName]>PIG_OptionsUI:GetVer_NUM(addonName,"audio") then
			self.yiGenxing=true;
		else	
			PIG_OptionsUI.SendExtVerInfo(addonName.."#U#"..PIG_OptionsUI:GetVer_NUM(addonName,"audio"))
		end
	elseif event=="ADDON_LOADED" and arg1 == addonName then
		self:UnregisterEvent("ADDON_LOADED")
		AudioList.AddFun(addonTable.AudioList)
		PIG_OptionsUI:SetVer_EXT(arg1,"audio")
    end
end)