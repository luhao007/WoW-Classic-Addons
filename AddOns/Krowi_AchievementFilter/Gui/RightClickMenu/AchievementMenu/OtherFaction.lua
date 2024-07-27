local _, addon = ...;
local section = {};
tinsert(addon.Gui.RightClickMenu.AchievementMenu:GetLastSection().Sections, section);

function section:CheckAdd(achievement)
    return achievement.OtherFactionAchievementId;
end

function section:Add(menu, achievement)
	local faction = addon.L["Neutral"];
	if addon.Faction.IsAlliance then
		faction = addon.L["Horde"];
	elseif addon.Faction.IsHorde then
		faction = addon.L["Alliance"];
	end
	menu:AddTitle(addon.L["Other faction"] .. " (" .. faction .. ")");
	addon.Gui.RightClickMenu.AchievementMenu:AddGoToAchievementLine(menu, achievement.OtherFactionAchievementId);
end