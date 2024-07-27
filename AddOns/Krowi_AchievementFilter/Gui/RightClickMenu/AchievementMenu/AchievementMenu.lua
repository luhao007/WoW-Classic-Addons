local _, addon = ...;
addon.Gui.RightClickMenu.AchievementMenu = {
	Sections = {}
};
local achievementMenu = addon.Gui.RightClickMenu.AchievementMenu;

local rightClickMenu = LibStub("Krowi_Menu-1.0");
function achievementMenu:AddGoToAchievementLine(menu, id, nameSuffix)
	nameSuffix = nameSuffix or "";
	local _, name = addon.GetAchievementInfo(id);
	local disabled;
	if not addon.Data.Achievements[id] then -- Catch missing achievements from the addon to prevent errors
		name = name .. " (" .. addon.L["Missing"] .. ")";
		disabled = true;
	end
	menu:AddFull({
		Text = name .. nameSuffix,
		Func = function()
			KrowiAF_SelectAchievementFromID(id);
			rightClickMenu:Close();
		end,
		Disabled = disabled
	});
end

function achievementMenu:AddGoToAchievementWithCategoryLine(menu, achievement, category)
	menu:AddFull({
		Text = category:GetPath(),
		Func = function()
			KrowiAF_SelectAchievementWithCategory(achievement, category);
			rightClickMenu:Close();
		end
	});
end

local function AddClearWatch(menu, achievement)
	if achievement.IsWatched then
		menu:AddFull({
			Text = addon.L["Remove from Watch List"]:K_ReplaceVars
			{
				watchList = addon.L["Watch List"]
			},
			Func = function()
				addon.ClearWatchAchievement(achievement);
				rightClickMenu:Close();
			end
		});
	else
		menu:AddFull({
			Text = addon.L["Add to Watch List"]:K_ReplaceVars
			{
				watchList = addon.L["Watch List"]
			},
			Func = function()
				addon.WatchAchievement(achievement);
				rightClickMenu:Close();
			end
		});
	end
end

local function AddIncludeExclude(menu, achievement)
	if achievement.IsExcluded then
		menu:AddFull({Text = addon.L["Include"], Func = function()
			addon.IncludeAchievement(achievement);
			rightClickMenu:Close();
		end});
	else
		menu:AddFull({Text = addon.L["Exclude"], Func = function()
			addon.ExcludeAchievement(achievement);
			rightClickMenu:Close();
		end});
	end
end

local function AddMore(achievement)
	local more = addon.Objects.MenuItem:New(addon.L["More"]);

	AddClearWatch(more, achievement);
	AddIncludeExclude(more, achievement);

	rightClickMenu:Add(more);
end

function achievementMenu:Open(achievement, anchor, offsetX, offsetY, point, relativePoint, frameStrata, frameLevel)
	-- Reset menu
	rightClickMenu:Clear();

	-- Always add header
	local _, name = addon.GetAchievementInfo(achievement.Id);
	rightClickMenu:AddTitle(name);

	for _, section in next, self.Sections do
		if section:CheckAdd(achievement) then
			section:Add(rightClickMenu, achievement);
		end
	end

	-- Extra menu defined at the achievement self including pet battles
	if addon.Data.RightClickMenuExtras[achievement.Id] ~= nil then
		rightClickMenu:Add(addon.Data.RightClickMenuExtras[achievement.Id]);
	end

	addon.Plugins:AddRightClickMenuItems(rightClickMenu, achievement);

	AddMore(achievement);

	rightClickMenu:Open(anchor, offsetX, offsetY, point, relativePoint, frameStrata, frameLevel);
end

function achievementMenu:GetLastSection()
	local sections = self.Sections;
	return sections[#sections];
end