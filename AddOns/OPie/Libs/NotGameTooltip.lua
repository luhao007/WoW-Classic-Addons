local _, T = ...

local suf, tn = 1 repeat
	tn, suf = "NotGameTooltip" .. suf, suf + 1
until _G[tn] == nil

-- External addons: please treat this as you would treat _G.GameTooltip
local tip = CreateFrame("GameTooltip", tn, UIParent, "GameTooltipTemplate")
tip.LIKE_GLOBAL_GAMETOOLTIP = true
tip.shoppingTooltips = tip.shoppingTooltips or GameTooltip.shoppingTooltips -- Classic.
tip:SetScript("OnUpdate", GameTooltip_OnUpdate)
T.NotGameTooltip = tip

do -- Avoid showing both at the same time
	local skipHide
	tip:SetScript("OnShow", function(self)
		if GameTooltip:IsForbidden() then
			return
		end
		skipHide = true
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetText(" ")
		GameTooltip:Hide()
		-- GameTooltip's OnShow is deferred, so skipHide can't be cleared here
	end)
	local tw = CreateFrame("Frame", nil, GameTooltip)
	tw:SetScript("OnShow", function()
		if skipHide then
			skipHide = false
		else
			tip:Hide()
		end
	end)
end