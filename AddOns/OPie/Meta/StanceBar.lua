local TEN = select(4, GetBuildInfo()) >= 10e4
local frame, _, T = TEN and StanceBar or StanceBarFrame, ...
local keeper, parent, EV, pendingValue = CreateFrame("Frame"), frame:GetParent(), T.Evie
keeper:Hide()

local function SetStanceBarVisibility(_, hidden, id)
	if hidden == nil then hidden = true end
	if id ~= nil then return false end
	if InCombatLockdown() then
		pendingValue = hidden
	else
		frame:SetParent(hidden and keeper or parent)
		if hidden == false and frame:IsShown() then frame:Show() end
		pendingValue = nil
	end
end

T.OPieCore:RegisterOption("HideStanceBar", false, SetStanceBarVisibility)
function EV:PLAYER_REGEN_ENABLED()
	if pendingValue ~= nil then
		SetStanceBarVisibility("HideStanceBar", pendingValue)
	end
end