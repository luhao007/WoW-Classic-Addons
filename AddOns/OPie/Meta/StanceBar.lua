local COMPAT, _, T = select(4, GetBuildInfo()), ...
local EV, frame, pendingValue = T.Evie, COMPAT > 10e4 and StanceBar or StanceBarFrame, nil
local keeper, parent = CreateFrame("Frame"), frame:GetParent()
keeper:Hide()

local function SetStanceBarVisibility(_, hidden, ringID)
	if ringID ~= nil then return false end
	hidden = hidden ~= false
	if InCombatLockdown() then
		pendingValue = hidden
		return
	end
	frame:SetParent(hidden and keeper or parent)
	if hidden == false and frame:IsShown() then frame:Show() end
	pendingValue = nil
end

T.OPieCore:RegisterOption("HideStanceBar", false, SetStanceBarVisibility)
function EV:PLAYER_REGEN_ENABLED()
	if pendingValue ~= nil then
		SetStanceBarVisibility("HideStanceBar", pendingValue)
	end
end