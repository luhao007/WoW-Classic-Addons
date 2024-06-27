local _, T = ...
local PC = T.OPieCore

local S = {
	{"set-gamepad-mode", "PadSupportMode", {"camstick", "movestick", "cursor", "none"}, {camstick="freelook", movestick="freelook1", cursor="cursor", none="none"}},
	{"set-gamepad-switch", "PSOpenSwitchMode", {"always", "padinput", "off"}, {always=2, padinput=1, off=0}},
	{"set-gamepad-restore", "PSRestoreOnClose", {"on", "off"}, {on=true, off=false}},
	{"set-gamepad-thaw", "PSThawDuration", min=0, max=math.huge},
	{"set-gamepad-thaw-hold", "PSThawHold", min=0, max=1},
}
local function printOptionHint(ii)
	local s = "|cffffff00/opie " .. ii[1] .. " "
	local cv, oa, om = PC:GetOption(ii[2]), ii[3], ii[4]
	for i=1, oa and #oa or 0 do
		s = s .. (i == 1 and "|cffb0b0b0{|r" or "|cffb0b0b0|||r") .. (cv == om[oa[i]] and "|cf00dd00d" or "|cf0f0f0f0") .. oa[i] .. "|r"
	end
	if oa then
		s = s .. "|cffb0b0b0}|r"
	else
		s = s .. "|cf00dd00d" .. cv .. "|r"
	end
	print(s)
end

for i=1,#S do
	local ii = S[i]
	T.AddSlashSuffix(function(args)
		local _q, r = args:match("^%s*(%S+)%s?(.*)$")
		local rn, om = r and tonumber(r), ii[4]
		if om and om[r] ~= nil or (om == nil and rn and rn >= ii.min and rn <= ii.max) then
			PC:SetOption(ii[2], om == nil and rn or om[r])
		else
			printOptionHint(ii)
		end
	end, ii[1])
end

T.AddSlashSuffix(function()
	local zc, oc = "|cf00dd00d", "|cf0f0f0f0"
	if GetCVarBool("GamePadEnable") then
		zc, oc = oc, zc
	end
	print("|cffffff00" .. SLASH_CONSOLE1 .. " GamePadEnable |cffb0b0b0{|r" .. zc .. "0|r|cffb0b0b0|||r" .. oc .. "1|r|cffb0b0b0}")
	for i=1,#S do
		printOptionHint(S[i])
	end
end, "show-gamepad-config")