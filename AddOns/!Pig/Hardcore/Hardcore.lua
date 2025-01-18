local addonName, addonTable = ...;

function addonTable.Hardcore()
	local active = C_GameRules.IsHardcoreActive()
	if not active then return end
	-- if not PIGA["HardcoreDeaths"]["Open"] then return end
	-- local gsub = _G.string.gsub
	-- local match = _G.string.match
	-- local sub = _G.string.sub
	-- local Create = addonTable.Create
	-- local PIGFrame=Create.PIGFrame
	-- local PIGFontString=Create.PIGFontString
	-- -- local PIGLine=Create.PIGLine
	-- -- local PIGButton=Create.PIGButton
	-- local PIGDiyBut=Create.PIGDiyBut
	-- local butW,butH = 24,24
	-- local ButUI=PIGDiyBut(UIParent,{"CENTER",UIParent,"CENTER",220,320},{butW,butH,butW,butH,136441})
	-- ButUI.icon:SetTexCoord(0.875,1.0,0.0,0.125)
	-- ButUI.msg=PIGFontString(ButUI,{"RIGHT", ButUI, "LEFT", 0, 0},"","OUTLINE",18)
	-- ButUI.msg:SetTextColor(1, 0, 0, 1);
	-- ButUI:SetScript("OnClick", function ()
	-- 	if HardcoreDeaths_UI:IsShown() then
	-- 		HardcoreDeaths_UI:Hide()
	-- 	else
	-- 		HardcoreDeaths_UI:Show()
	-- 	end
	-- end);
	-- -- if tocversion>20000 then return end
	-- -- print(HARDCORE_DEATHS)
	-- -- JoinPermanentChannel("hardcoredeaths", nil, DEFAULT_CHAT_FRAME:GetID(), 1);
	-- -- ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "hardcoredeaths")--订购一个聊天框以显示先前加入的聊天频道
	-- local itemhangW,itemhangH = 400,500
	-- local HardcoreDeaths = PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,60},{itemhangW,itemhangH},"HardcoreDeaths_UI",true)
	-- HardcoreDeaths:PIGSetBackdrop()
	-- HardcoreDeaths:PIGSetMovable()
	-- HardcoreDeaths.biaoti = PIGFontString(HardcoreDeaths,{"TOP", 0, -2},HARDCORE_DEATHS)
	-- --HardcoreDeaths.butList={}

	-- -----
	-- RaidWarningFrame:UnregisterEvent("HARDCORE_DEATHS");
	-- ButUI:RegisterEvent("HARDCORE_DEATHS");
	-- ButUI:HookScript("OnEvent", function(self, event, message)
	-- 	if ( event == "HARDCORE_DEATHS") then
	-- 		local kaishi, jieshu, wanjiaName = message:find("%[(.-)%]");
	-- 		local newmsg = message:sub(jieshu+1);
	-- 		local kaishi, jieshu, level= newmsg:find("(%d+)");
	-- 		local kaishi, jieshu, NPC = newmsg:find("被一个(.+)消灭了");
	-- 		local kaishi, jieshu, map = newmsg:find("地点位于(.+)！");
	-- 		print(wanjiaName, level, NPC,map)
	-- 		table.insert(PIGA["HardcoreDeaths"]["List"],{GetServerTime(),wanjiaName, level, NPC,map})
	-- 		ButUI.msg:SetText("["..level.."]"..wanjiaName)
	-- 	end
	-- end); 
end