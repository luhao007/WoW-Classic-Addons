if select(4, GetBuildInfo()) < 9e4 then return end
local _, T = ...

local S = {
	{"set-gamepad-mode", "PadSupportMode", {"stick", "cursor", "none"}, {stick="freelook", cursor="cursor", none="none"}},
	{"set-gamepad-switch", "PSSwitchOnOpen", {"on", "off"}, {on=true, off=false}},
	{"set-gamepad-restore", "PSRestoreOnClose", {"on", "off"}, {on=true, off=false}},
	{"set-gamepad-thaw", "PSThawDuration", min=0, max=math.huge},
	{"set-gamepad-thaw-hold", "PSThawHold", min=0, max=1},
}
local function printOptionHint(ii)
	local s =  "|cffffff00/opie " .. ii[1] .. " "
	local cv, oa, om = OneRingLib:GetOption(ii[2]), ii[3], ii[4]
	for i=1, oa and #oa or 0 do
		s = s .. (i == 1 and "|cffb0b0b0{|r" or "|cffb0b0b0|||r") .. (cv == om[oa[i]] and "|cf00dd00d" or "|cfff0f0f0") .. oa[i] .. "|r"
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
			OneRingLib:SetOption(ii[2], om == nil and rn or om[r])
		else
			printOptionHint(ii)
		end
	end, ii[1])
end

T.AddSlashSuffix(function()
	for i=1,#S do
		printOptionHint(S[i])
	end
end, "show-gamepad-config")