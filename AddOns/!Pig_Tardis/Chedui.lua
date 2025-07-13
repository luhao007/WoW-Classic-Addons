local addonName, addonTable = ...;
local Create, Data, Fun, L= unpack(PIG)
---------------------------
local PIGEnter=Create.PIGEnter
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGQuickBut=Create.PIGQuickBut
local PIGSetFont=Create.PIGSetFont
-- ------------------
local TardisInfo=addonTable.TardisInfo
function TardisInfo.Chedui(Activate)
	-- if not PIGA["Tardis"]["Chedui"]["Open"] then return end
	-- local GnName,GnUI,GnIcon,FrameLevel = unpack(TardisInfo.uidata)
	-- local InvF=_G[GnUI]
	-- local fujiF,fujiTabBut=PIGOptionsList_R(InvF.F,L["TARDIS_CHEDUI"],80,"Bot")
	-- if Activate then
	-- 	fujiF:Show()
	-- 	fujiTabBut:Selected()
	-- end
	-- fujiF.xxx = PIGFontString(fujiF,{"CENTER", fujiF, "CENTER", 0,10},L["TARDIS_CHEDUI"].."已停止运营...", "OUTLINE",20);
end