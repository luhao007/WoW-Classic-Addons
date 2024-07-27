local _, addon = ...;
local menuUtil = addon.Gui.MenuUtil;

KrowiAF_AchievementFrameFilterButtonModernMixin = CreateFromMixins(KrowiAF_AchievementFrameFilterButtonMixin);

do -- Mixin
    function KrowiAF_AchievementFrameFilterButtonModernMixin:OnLoad()
        WowStyle1FilterDropdownMixin.OnLoad(self);
        KrowiAF_AchievementFrameFilterButtonMixin.OnLoad(self);

        self:SetupMenu(function(owner, menu)
            menu:SetTag("MENU_ACHIEVEMENT_FILTER");

            owner:CreateMenu(menu);
        end);
    end

    function KrowiAF_AchievementFrameFilterButtonModernMixin:OnShow()
        WowStyle1FilterDropdownMixin.OnShow(self);
        KrowiAF_AchievementFrameFilterButtonMixin.OnShow();
    end
end

function KrowiAF_AchievementFrameFilterButtonModernMixin:CreateCheckbox(menu, text, filters, keys, checkTabs)
    menu:CreateCheckbox(
        self:GetCheckBoxStateText(text, filters, keys),
        function()
            return self:KeyIsTrue(filters, keys);
        end,
        function()
            self:OnCheckboxSelect(filters, keys, checkTabs);
        end
    );
end

function KrowiAF_AchievementFrameFilterButtonModernMixin:CreateRadio(menu, text, filters, keys, checkTabs)
    local button = menu:CreateRadio(
        text,
        function()
            return self:KeyEqualsText(text, filters, keys);
        end,
        function()
            self:OnRadioSelect(text, filters, keys, checkTabs);
        end
    );
    button:SetResponse(MenuResponse.Refresh);
end

do -- BuildVersionFilter
    function KrowiAF_AchievementFrameFilterButtonModernMixin:CreateMinorVersionGroup(majorGroup, filters, major, minor)
        return majorGroup:CreateCheckbox(
            major.Major .. "." .. minor.Minor .. ".x",
            function()
                return self:IsMinorVersionChecked(filters, minor);
            end,
            function()
                self:OnMinorVersionSelect(filters, minor);
            end
        );
    end

    function KrowiAF_AchievementFrameFilterButtonModernMixin:CreateMajorVersionGroup(version, filters, major)
        return version:CreateCheckbox(
            major.Major .. ".x.x",
            function()
                return self:IsMajorVersionChecked(filters, major);
            end,
            function()
                self:OnMajorVersionSelect(filters, major);
            end
        );
    end

    function KrowiAF_AchievementFrameFilterButtonModernMixin:CreateSelectDeselectAllVersions(version, filters)
        menuUtil:CreateDivider(version);
        local selectAll = version:CreateButton(
            addon.L["Select All"],
            function()
                self:OnAllVersionsSelect(filters, true);
            end
        );
        selectAll:SetResponse(MenuResponse.Refresh);
        local deselectAll = version:CreateButton(
            addon.L["Deselect All"],
            function()
                self:OnAllVersionsSelect(filters, false);
            end
        );
        deselectAll:SetResponse(MenuResponse.Refresh);
    end

    function KrowiAF_AchievementFrameFilterButtonModernMixin:CreateBuildVersionFilter(menu, filters)
        local version = menu:CreateButton(addon.L["Version"]);
        self:CreateBuildVersionFilterGroups(version, filters);
    end
end

function KrowiAF_AchievementFrameFilterButtonModernMixin:CreateSelectDeselectAllFactions(menu, text, filters, value)
    local selectAll = menu:CreateButton(
        text,
        function()
            self:SetFactionFilters(filters, value);
        end
    );
    selectAll:SetResponse(MenuResponse.Refresh);
end

function KrowiAF_AchievementFrameFilterButtonModernMixin:HelpShowTutorial(index)
    addon.Tutorials.FeaturesTutorial:ShowTutorial(index);
end