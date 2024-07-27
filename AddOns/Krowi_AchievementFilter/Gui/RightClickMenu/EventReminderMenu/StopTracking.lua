local _, addon = ...;
local menuUtil = addon.Gui.MenuUtil;
local section = {};
tinsert(addon.Gui.RightClickMenu.EventReminderMenu.Sections, section);

function section:CheckAdd()
    return true;
end

local function GetTypeAsString(type)
    local eventType = addon.Objects.EventType;
    for typeAsString, typeAsValue in next, eventType do
        if type == typeAsValue then
            return typeAsString;
        end
    end
end

function section:Add(menu, event)
    menuUtil:CreateButtonAndAdd(
        menu,
        addon.L["Stop tracking"],
		function()
            local typeAsString = GetTypeAsString(event.Type);
			addon.Options.db.profile.EventReminders[typeAsString .. "Events"][event.Id] = false;
            if event.LinkedEventIds then
                for _, id in next, event.LinkedEventIds do
                    addon.Options.db.profile.EventReminders[typeAsString .. "Events"][id] = false;
                end
            end
            addon.Gui.EventReminderSideButtonSystem:Refresh();
		end
	);
end