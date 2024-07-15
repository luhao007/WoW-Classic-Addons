local _, addonTable = ...;
------------
local CommonInfo=addonTable.CommonInfo
---快速焦点
local UnitFrame = {
	["Blizzard"]={
		"PlayerFrame","PetFrame","TargetFrame", "TargetFrameToT",
		"PartyMemberFrame1","PartyMemberFrame2","PartyMemberFrame3","PartyMemberFrame4",
		"PartyMemberFrame1PetFrame","PartyMemberFrame2PetFrame","PartyMemberFrame3PetFrame","PartyMemberFrame4PetFrame",
	},
	--
	["ElvUI"]={
		"ElvUF_Player","ElvUF_Target","ElvUF_TargetTarget",
		"ElvUF_PartyGroup1UnitButton1","ElvUF_PartyGroup1UnitButton2","ElvUF_PartyGroup1UnitButton3","ElvUF_PartyGroup1UnitButton4","ElvUF_PartyGroup1UnitButton5",
	},
}
CommonInfo.SetKeyList = {
	{"SHIFT+"..KEY_BUTTON1,"shift"},
	{"CTRL+"..KEY_BUTTON1,"ctrl"},
	{"ALT+"..KEY_BUTTON1,"alt"},
}
CommonInfo.SetKeyListName = {
	["shift"]="SHIFT+"..KEY_BUTTON1,
	["ctrl"]="CTRL+"..KEY_BUTTON1,
	["alt"]="ALT+"..KEY_BUTTON1,
}
local FrameyanchiNUM = {}
local function zhixingshezhiFocus(Frame)
	if _G[Frame] then
		if not InCombatLockdown() then
			local gonegnengKEY = PIGA["Common"]["SetFocusKEY"].."-type1"
			_G[Frame]:SetAttribute(gonegnengKEY,"macro")
			_G[Frame]:SetAttribute("macrotext","/focus mouseover")
		end
	else
		FrameyanchiNUM[Frame]=FrameyanchiNUM[Frame] or 1
		if FrameyanchiNUM[Frame]<10 then
			C_Timer.After(0.1,function()
				FrameyanchiNUM[Frame]=FrameyanchiNUM[Frame]+1
				zhixingshezhiFocus(Frame)
			end)
		end
	end
end
local function zhixingshezhiFocus1()
	if PIGA["Common"]["SetFocusMouse"] then 
		if not PIG_MouseoverFocuser then
			local MF = CreateFrame("CheckButton", "PIG_MouseoverFocuser", UIParent, "SecureActionButtonTemplate")	
		end
		PIG_MouseoverFocuser:SetAttribute("type1","macro")
		PIG_MouseoverFocuser:SetAttribute("macrotext","/focus mouseover")
		SetOverrideBindingClick(PIG_MouseoverFocuser,true,PIGA["Common"]["SetFocusKEY"].."-BUTTON1","PIG_MouseoverFocuser")
	else
		if PIG_MouseoverFocuser then
			PIG_MouseoverFocuser:SetAttribute("type1",nil)
		end
	end
end
local function SET_BlizzardUnit()
	if not IsAddOnLoaded("Blizzard_RaidUI") then return end
	for k,v in pairs(UnitFrame.Blizzard) do
		zhixingshezhiFocus(v)
	end
	for i=1, 40 do
		zhixingshezhiFocus("CompactRaidFrame"..i)
	end
	for groupIndex=1, 8 do
		for i=1,5 do
			zhixingshezhiFocus("CompactRaidGroup"..groupIndex.."Member"..i)
		end
	end
end
local function SET_ElvUIUnit_1(id)
	for groupIndex=1, 8 do
		for i=1,40 do
			zhixingshezhiFocus("ElvUF_Raid"..id.."Group"..groupIndex.."UnitButton"..i)
		end
	end
end
local function SET_ElvUIUnit()
	if not IsAddOnLoaded("ElvUI") then return end
	for k,v in pairs(UnitFrame.ElvUI) do
		zhixingshezhiFocus(v)
	end
	SET_ElvUIUnit_1(1)
	SET_ElvUIUnit_1(2)
	SET_ElvUIUnit_1(3)
end
function CommonInfo.Commonfun.SetFocus()
	if not PIGA["Common"]["SetFocus"] then return end
	zhixingshezhiFocus1()
	SET_BlizzardUnit()
	SET_ElvUIUnit()
	hooksecurefunc("CompactRaidGroup_GenerateForGroup", function(groupIndex)
		SET_BlizzardUnit()
		SET_ElvUIUnit()
	end)
end
--清除
local function zhixingClearFocus(Frame)
	if _G[Frame] then
		if not InCombatLockdown() then
			local gonegnengKEY = PIGA["Common"]["SetFocusKEY"].."-type1"
			_G[Frame]:SetAttribute(gonegnengKEY,"macro")
			_G[Frame]:SetAttribute("macrotext","/clearfocus")
		end
	else
		C_Timer.After(0.1,function()
			zhixingClearFocus(Frame)
		end)
	end
end
function CommonInfo.Commonfun.ClearFocus()
	if not PIGA["Common"]["ClearFocus"] then return end
	zhixingClearFocus("FocusFrame")
	if ElvUI then zhixingClearFocus("ElvUF_Focus") end
	if NDui then zhixingClearFocus("oUF_Focus") end
end