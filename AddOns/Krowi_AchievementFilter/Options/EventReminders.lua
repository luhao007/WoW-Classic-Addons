-- [[ Namespaces ]] --
local _, addon = ...;
local options = addon.Options;
options.EventReminders = {};
local eventReminders = options.EventReminders;
tinsert(options.OptionsTables, eventReminders);

local OrderPP = addon.InjectOptions.AutoOrderPlusPlus;
local AdjustedWidth = addon.InjectOptions.AdjustedWidth;

function eventReminders.RegisterOptionsTable()
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addon.Metadata.Prefix .. "_EventReminders", options.OptionsTable.args.EventReminders);
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addon.Metadata.Prefix .. "_EventReminders", addon.L["Event Reminders"], addon.Metadata.Title);
end

local RefreshOptions; -- Assigned at the end of the file
function eventReminders.OnProfileChanged(db, newProfile)
    RefreshOptions();
end

function eventReminders.OnProfileCopied(db, sourceProfile)
    RefreshOptions();
end

function eventReminders.OnProfileReset(db)
    RefreshOptions();
end

local timeDisplaysLine1 = {
    addon.L["End Time"],
    addon.L["Time Left"]
};

local timeDisplaysLine2 = {
    addon.L["None"],
    addon.L["End Time"],
    addon.L["Time Left"]
};

local sideButtonsAnchor = {
    addon.L["Achievement Window"],
    addon.L["World Map"]
}

local growDirection = {
    addon.L["Up"],
    addon.L["Down"]
};

local startTimeAndEndTimeDateTimeFormats, startTimeAndEndTimeDateTimeValues = {}, {};

local function AddFormat(formats, values, format)
    tinsert(formats, format);
    tinsert(values, date(format, time()));
end

local function AddStartTimeAndEndTimeFormat(format)
    AddFormat(startTimeAndEndTimeDateTimeFormats, startTimeAndEndTimeDateTimeValues, format);
end

AddStartTimeAndEndTimeFormat(options.Defaults.profile.EventReminders.DateTimeFormat.StartTimeAndEndTime);
AddStartTimeAndEndTimeFormat(addon.L["%d/%m/%Y %I:%M %p"]);
AddStartTimeAndEndTimeFormat(addon.L["%m/%d/%Y %R"]);
AddStartTimeAndEndTimeFormat(addon.L["%m/%d/%Y %I:%M %p"]);
AddStartTimeAndEndTimeFormat(addon.L["%Y/%m/%d %R"]);
AddStartTimeAndEndTimeFormat(addon.L["%Y/%m/%d %I:%M %p"]);
AddStartTimeAndEndTimeFormat(addon.L["%c"]);
tinsert(startTimeAndEndTimeDateTimeValues, "Custom");
tinsert(startTimeAndEndTimeDateTimeFormats, addon.L["%m/%d/%Y %R"]);

local function TimeDisplayLine1Set(_, value)
    if addon.Options.db.profile.EventReminders.TimeDisplay.Line1 == value then return; end;
    addon.Options.db.profile.EventReminders.TimeDisplay.Line1 = value;
    addon.Gui.EventReminderSideButtonSystem:Refresh();
end

local function TimeDisplayLine2Set(_, value)
    if addon.Options.db.profile.EventReminders.TimeDisplay.Line2 == value then return; end;
    addon.Options.db.profile.EventReminders.TimeDisplay.Line2 = value;
    addon.Gui.EventReminderSideButtonSystem:Refresh();
end

local function SideButtonsAnchorSet(_, value)
    if addon.Options.db.profile.EventReminders.SideButtonsAnchor == value then return; end;
    addon.Options.db.profile.EventReminders.SideButtonsAnchor = value;
    addon.Gui.EventReminderSideButtonSystem:Reload();
end

local function PopUpsGrowDirectionSet(_, value)
    if addon.Options.db.profile.EventReminders.PopUps.GrowDirection == value then return; end;
    addon.Options.db.profile.EventReminders.PopUps.GrowDirection = value;
    addon.Gui.EventReminderAlertSystem:UpdateGrowDirection();
    AlertFrame:UpdateAnchors();
end

local function PopUpsSpacingSet(_, value)
    if addon.Options.db.profile.EventReminders.PopUps.Spacing == value then return; end;
    addon.Options.db.profile.EventReminders.PopUps.Spacing = value;
    addon.Gui.EventReminderAlertSystem:UpdateGrowDirection();
    AlertFrame:UpdateAnchors();
end

local function PopUpsOffsetXSet(_, value)
    if addon.Options.db.profile.EventReminders.PopUps.OffsetX == value then return; end;
    addon.Options.db.profile.EventReminders.PopUps.OffsetX = value;
    AlertFrame:ClearAllPoints();
    AlertFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", addon.Options.db.profile.EventReminders.PopUps.OffsetX, addon.Options.db.profile.EventReminders.PopUps.OffsetY);
end

local function PopUpsOffsetYSet(_, value)
    if addon.Options.db.profile.EventReminders.PopUps.OffsetY == value then return; end;
    addon.Options.db.profile.EventReminders.PopUps.OffsetY = value;
    AlertFrame:ClearAllPoints();
    AlertFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", addon.Options.db.profile.EventReminders.PopUps.OffsetX, addon.Options.db.profile.EventReminders.PopUps.OffsetY);
end

local function PopUpsShowPlaceholderFunc()
    local calendarEvents = addon.Data.CalendarEvents;    
    local showPopUpsWithTimeDataOnly = addon.Options.db.profile.EventReminders.PopUps.OnLogin.ShowOnlyWhenTimeDataIsAvailable or addon.Options.db.profile.EventReminders.PopUps.OnReload.ShowOnlyWhenTimeDataIsAvailable or addon.Options.db.profile.EventReminders.PopUps.OnEventStart.ShowOnlyWhenTimeDataIsAvailable;
    for i, event in next, calendarEvents do
        if i == 141 then -- Fake not active event
            if not showPopUpsWithTimeDataOnly or (showPopUpsWithTimeDataOnly and event.EventDetails and event.EventDetails.EndTime) then
                addon.Gui.EventReminderAlertSystem:AddAlert(event, 60);
            end
        elseif i == 181 then -- Fake not active event
            event.EventDetails = {EndTime = nil, Name = i .. " - " .. addon.L["Placeholder"]};
            if not showPopUpsWithTimeDataOnly or (showPopUpsWithTimeDataOnly and event.EventDetails and event.EventDetails.EndTime) then
                addon.Gui.EventReminderAlertSystem:AddAlert(event, 60);
            end
        else
            event.EventDetails = {EndTime = time() + 600010, Name = i .. " - " .. addon.L["Placeholder"]};
            addon.Gui.EventReminderAlertSystem:AddAlert(event, 60);
        end
    end
end

local function StartTimeAndEndTimePresetsGet()
    for i, format in next, startTimeAndEndTimeDateTimeFormats do
        if format == addon.Options.db.profile.EventReminders.DateTimeFormat.StartTimeAndEndTime then
            return i;
        end
    end
    return #startTimeAndEndTimeDateTimeFormats;
end

local function StartTimeAndEndTimeCustomSet(_, value)
    if addon.Options.db.profile.EventReminders.DateTimeFormat.StartTimeAndEndTime == value then return; end;
    addon.Options.db.profile.EventReminders.DateTimeFormat.StartTimeAndEndTime = value;
    addon.Gui.EventReminderSideButtonSystem:Refresh();
end

options.OptionsTable.args["EventReminders"] = {
    type = "group", childGroups = "tab",
    name = addon.L["Event Reminders"],
    args = {
        General = {
            order = OrderPP(), type = "group",
            name = addon.L["General"],
            args = {
                Style = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["Style"],
                    args = {
                        Compact = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(),
                            name = addon.L["Compact"],
                            desc = addon.L["Compact Desc"]:KAF_AddDefaultValueText("EventReminders.Compact"):K_AddReloadRequired(),
                            get = function() return addon.Options.db.profile.EventReminders.Compact; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.Compact = value; end
                        }
                    }
                },
                TimeDisplay = {
                    order = OrderPP(), type = "group",
                    name = addon.L["Time display"],
                    inline = true,
                    args = {
                        Line1 = {
                            order = OrderPP(), type = "select", width = AdjustedWidth(1.45),
                            name = addon.L["Line"] .. " 1",
                            desc = (""):KAF_AddDefaultValueText("EventReminders.TimeDisplay.Line1", timeDisplaysLine1),
                            values = timeDisplaysLine1,
                            get = function() return addon.Options.db.profile.EventReminders.TimeDisplay.Line1; end,
                            set = TimeDisplayLine1Set
                        },
                        Line2 = {
                            order = OrderPP(), type = "select", width = AdjustedWidth(1.45),
                            name = addon.L["Line"] .. " 2",
                            desc = (""):KAF_AddDefaultValueText("EventReminders.TimeDisplay.Line2", timeDisplaysLine2),
                            values = timeDisplaysLine2,
                            get = function() return addon.Options.db.profile.EventReminders.TimeDisplay.Line2; end,
                            set = TimeDisplayLine2Set,
                            disabled = function() return addon.Options.db.profile.EventReminders.Compact; end
                        }
                    }
                },
                Other = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["Other"],
                    args = {
                        RefreshInterval = {
                            order = OrderPP(), type = "range", width = AdjustedWidth(1.45),
                            name = addon.L["Refresh interval"],
                            desc = addon.L["Refresh interval Desc"]:KAF_AddDefaultValueText("EventReminders.RefreshInterval"),
                            min = 1, max = 3600, step = 1,
                            get = function() return addon.Options.db.profile.EventReminders.RefreshInterval; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.RefreshInterval = value; end
                        },
                        ShowPopUpsOnLoginDelay = {
                            order = OrderPP(), type = "range", width = AdjustedWidth(1.45),
                            name = addon.L["Login Delay"],
                            desc = addon.L["Show pop ups on login delay Desc"]:KAF_AddDefaultValueText("EventReminders.OnLoginDelay"),
                            min = 1, max = 600, step = 1,
                            get = function() return addon.Options.db.profile.EventReminders.OnLoginDelay; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.OnLoginDelay = value; end
                        },
                        SideButtonsAnchor = {
                            order = OrderPP(), type = "select", width = AdjustedWidth(1.45),
                            name = addon.L["Side Button Anchor"],
                            desc = addon.L["Side Button Anchor Desc"]:KAF_AddDefaultValueText("EventReminders.SideButtonsAnchor", sideButtonsAnchor),
                            values = sideButtonsAnchor,
                            get = function() return addon.Options.db.profile.EventReminders.SideButtonsAnchor; end,
                            set = SideButtonsAnchorSet,
                        }
                    }
                }
            }
        },
        PopUps = {
            order = OrderPP(), type = "group",
            name = addon.L["Pop ups"],
            args = {
                OnLogin = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["On Login"],
                    args = {
                        Show = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.7),
                            name = addon.L["Show"],
                            desc = addon.L["Show alertSystem on login Desc"]:K_ReplaceVars(addon.L["Pop ups"]):KAF_AddDefaultValueText("EventReminders.PopUps.OnLogin.Show"),
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.OnLogin.Show; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.PopUps.OnLogin.Show = value; end
                        },
                        ShowInInstances = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.75),
                            name = addon.L["In instances"],
                            desc = addon.L["Show alertSystem on login in instances Desc"]:K_ReplaceVars(addon.L["Pop ups"]):KAF_AddDefaultValueText("EventReminders.PopUps.OnLogin.ShowInInstances"),
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.OnLogin.ShowInInstances; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.PopUps.OnLogin.ShowInInstances = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.PopUps.OnLogin.Show end
                        },
                        ShowOnlyWhenTimeDataIsAvailable = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(1.45),
                            name = addon.L["Only when time data is available"],
                            desc = addon.L["Show alertSystem on login only when time data is available Desc"]:K_ReplaceVars(addon.L["Pop ups"]):KAF_AddDefaultValueText("EventReminders.PopUps.OnLogin.ShowOnlyWhenTimeDataIsAvailable"),
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.OnLogin.ShowOnlyWhenTimeDataIsAvailable; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.PopUps.OnLogin.ShowOnlyWhenTimeDataIsAvailable = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.PopUps.OnLogin.Show end
                        }
                    }
                },
                OnReload = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["On Reload"],
                    args = {
                        Show = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.7),
                            name = addon.L["Show"],
                            desc = addon.L["Show alertSystem on reload Desc"]:K_ReplaceVars(addon.L["Pop ups"]):KAF_AddDefaultValueText("EventReminders.PopUps.OnReload.Show"),
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.OnReload.Show; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.PopUps.OnReload.Show = value; end
                        },
                        ShowInInstances = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.75),
                            name = addon.L["In instances"],
                            desc = addon.L["Show alertSystem on reload in instances Desc"]:K_ReplaceVars(addon.L["Pop ups"]):KAF_AddDefaultValueText("EventReminders.PopUps.OnReload.ShowInInstances"),
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.OnReload.ShowInInstances; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.PopUps.OnReload.ShowInInstances = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.PopUps.OnReload.Show end
                        },
                        ShowOnlyWhenTimeDataIsAvailable = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(1.45),
                            name = addon.L["Only when time data is available"],
                            desc = addon.L["Show alertSystem on reload only when time data is available Desc"]:K_ReplaceVars(addon.L["Pop ups"]):KAF_AddDefaultValueText("EventReminders.PopUps.OnReload.ShowOnlyWhenTimeDataIsAvailable"),
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.OnReload.ShowOnlyWhenTimeDataIsAvailable; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.PopUps.OnReload.ShowOnlyWhenTimeDataIsAvailable = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.PopUps.OnReload.Show end
                        }
                    }
                },
                OnEventStart = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["On Event Start"],
                    args = {
                        Show = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.7),
                            name = addon.L["Show"],
                            desc = addon.L["Show alertSystem on event start Desc"]:K_ReplaceVars(addon.L["Pop ups"]):KAF_AddDefaultValueText("EventReminders.PopUps.OnEventStart.Show"),
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.OnEventStart.Show; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.PopUps.OnEventStart.Show = value; end
                        },
                        ShowInInstances = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.75),
                            name = addon.L["In instances"],
                            desc = addon.L["Show alertSystem on event start in instances Desc"]:K_ReplaceVars(addon.L["Pop ups"]):KAF_AddDefaultValueText("EventReminders.PopUps.OnEventStart.ShowInInstances"),
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.OnEventStart.ShowInInstances; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.PopUps.OnEventStart.ShowInInstances = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.PopUps.OnEventStart.Show end
                        },
                        ShowOnlyWhenTimeDataIsAvailable = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(1.45),
                            name = addon.L["Only when time data is available"],
                            desc = addon.L["Show alertSystem on event start only when time data is available Desc"]:K_ReplaceVars(addon.L["Pop ups"]):KAF_AddDefaultValueText("EventReminders.PopUps.OnEventStart.ShowOnlyWhenTimeDataIsAvailable"),
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.OnEventStart.ShowOnlyWhenTimeDataIsAvailable; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.PopUps.OnEventStart.ShowOnlyWhenTimeDataIsAvailable = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.PopUps.OnEventStart.Show end
                        }
                    }
                },
                Location = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["Location"],
                    args = {
                        GrowDirection = {
                            order = OrderPP(), type = "select", width = AdjustedWidth(1.45),
                            name = addon.L["Grow direction"],
                            desc = addon.L["Grow direction Desc"]:KAF_AddDefaultValueText("EventReminders.PopUps.GrowDirection", growDirection),
                            values = growDirection,
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.GrowDirection; end,
                            set = PopUpsGrowDirectionSet
                        },
                        Spacing = {
                            order = OrderPP(), type = "range", width = AdjustedWidth(1.45),
                            name = addon.L["Spacing"],
                            desc = addon.L["Spacing Desc"]:KAF_AddDefaultValueText("EventReminders.PopUps.Spacing"),
                            min = 0, max = 100, step = 1,
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.Spacing; end,
                            set = PopUpsSpacingSet
                        },
                        OffsetX = {
                            order = OrderPP(), type = "range", width = "full",
                            name = addon.L["XYZ offset"]:K_ReplaceVars("X"),
                            desc = addon.L["X offset Desc"]:KAF_AddDefaultValueText("EventReminders.PopUps.OffsetX"),
                            min = -2000, max = 2000, step = 1,
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.OffsetX; end,
                            set = PopUpsOffsetXSet
                        },
                        OffsetY = {
                            order = OrderPP(), type = "range", width = "full",
                            name = addon.L["XYZ offset"]:K_ReplaceVars("Y"),
                            desc = addon.L["Y offset Desc"]:KAF_AddDefaultValueText("EventReminders.PopUps.OffsetY"),
                            min = 0, max = 2000, step = 1,
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.OffsetY; end,
                            set = PopUpsOffsetYSet
                        },
                        ShowPlaceholder = {
                            order = OrderPP(), type = "execute", width = AdjustedWidth(),
                            name = addon.L["Show placeholders"],
                            desc = addon.L["Show placeholders Desc"],
                            func = PopUpsShowPlaceholderFunc
                        }
                    }
                },
                Other = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["Other"],
                    args = {
                        MaxAlerts = {
                            order = OrderPP(), type = "range", width = AdjustedWidth(1.45),
                            name = addon.L["Max number of alerts"],
                            desc = addon.L["Max number of alerts Desc"]:KAF_AddDefaultValueText("EventReminders.PopUps.MaxAlerts"),
                            min = 1, max = 100, step = 1,
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.MaxAlerts; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.PopUps.MaxAlerts = value; end
                        },
                        FadeDelay = {
                            order = OrderPP(), type = "range", width = AdjustedWidth(1.45),
                            name = addon.L["Fade delay"],
                            desc = addon.L["Fade delay Desc"]:KAF_AddDefaultValueText("EventReminders.PopUps.FadeDelay"),
                            min = 1, max = 120, step = 1,
                            get = function() return addon.Options.db.profile.EventReminders.PopUps.FadeDelay; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.PopUps.FadeDelay = value; end
                        }
                    }
                }
            }
        },
        ChatMessages = {
            order = OrderPP(), type = "group",
            name = addon.L["Chat messages"],
            args = {
                OnLogin = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["On Login"],
                    args = {
                        Show = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.7),
                            name = addon.L["Show"],
                            desc = addon.L["Show alertSystem on login Desc"]:K_ReplaceVars(addon.L["Chat messages"]):KAF_AddDefaultValueText("EventReminders.ChatMessages.OnLogin.Show"),
                            get = function() return addon.Options.db.profile.EventReminders.ChatMessages.OnLogin.Show; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.ChatMessages.OnLogin.Show = value; end
                        },
                        ShowInInstances = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.75),
                            name = addon.L["In instances"],
                            desc = addon.L["Show alertSystem on login in instances Desc"]:K_ReplaceVars(addon.L["Chat messages"]):KAF_AddDefaultValueText("EventReminders.ChatMessages.OnLogin.ShowInInstances"),
                            get = function() return addon.Options.db.profile.EventReminders.ChatMessages.OnLogin.ShowInInstances; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.ChatMessages.OnLogin.ShowInInstances = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.ChatMessages.OnLogin.Show end
                        },
                        ShowOnlyWhenTimeDataIsAvailable = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(1.45),
                            name = addon.L["Only when time data is available"],
                            desc = addon.L["Show alertSystem on login only when time data is available Desc"]:K_ReplaceVars(addon.L["Chat messages"]):KAF_AddDefaultValueText("EventReminders.ChatMessages.OnLogin.ShowOnlyWhenTimeDataIsAvailable"),
                            get = function() return addon.Options.db.profile.EventReminders.ChatMessages.OnLogin.ShowOnlyWhenTimeDataIsAvailable; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.ChatMessages.OnLogin.ShowOnlyWhenTimeDataIsAvailable = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.ChatMessages.OnLogin.Show end
                        }
                    }
                },
                OnReload = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["On Reload"],
                    args = {
                        Show = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.7),
                            name = addon.L["Show"],
                            desc = addon.L["Show alertSystem on reload Desc"]:K_ReplaceVars(addon.L["Chat messages"]):KAF_AddDefaultValueText("EventReminders.ChatMessages.OnReload.Show"),
                            get = function() return addon.Options.db.profile.EventReminders.ChatMessages.OnReload.Show; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.ChatMessages.OnReload.Show = value; end
                        },
                        ShowInInstances = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.75),
                            name = addon.L["In instances"],
                            desc = addon.L["Show alertSystem on reload in instances Desc"]:K_ReplaceVars(addon.L["Chat messages"]):KAF_AddDefaultValueText("EventReminders.ChatMessages.OnReload.ShowInInstances"),
                            get = function() return addon.Options.db.profile.EventReminders.ChatMessages.OnReload.ShowInInstances; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.ChatMessages.OnReload.ShowInInstances = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.ChatMessages.OnReload.Show end
                        },
                        ShowOnlyWhenTimeDataIsAvailable = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(1.45),
                            name = addon.L["Only when time data is available"],
                            desc = addon.L["Show alertSystem on reload only when time data is available Desc"]:K_ReplaceVars(addon.L["Chat messages"]):KAF_AddDefaultValueText("EventReminders.ChatMessages.OnReload.ShowOnlyWhenTimeDataIsAvailable"),
                            get = function() return addon.Options.db.profile.EventReminders.ChatMessages.OnReload.ShowOnlyWhenTimeDataIsAvailable; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.ChatMessages.OnReload.ShowOnlyWhenTimeDataIsAvailable = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.ChatMessages.OnReload.Show end
                        }
                    }
                },
                OnEventStart = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["On Event Start"],
                    args = {
                        Show = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.7),
                            name = addon.L["Show"],
                            desc = addon.L["Show alertSystem on event start Desc"]:K_ReplaceVars(addon.L["Chat messages"]):KAF_AddDefaultValueText("EventReminders.ChatMessages.OnEventStart.Show"),
                            get = function() return addon.Options.db.profile.EventReminders.ChatMessages.OnEventStart.Show; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.ChatMessages.OnEventStart.Show = value; end
                        },
                        ShowInInstances = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(0.75),
                            name = addon.L["In instances"],
                            desc = addon.L["Show alertSystem on event start in instances Desc"]:K_ReplaceVars(addon.L["Chat messages"]):KAF_AddDefaultValueText("EventReminders.ChatMessages.OnEventStart.ShowInInstances"),
                            get = function() return addon.Options.db.profile.EventReminders.ChatMessages.OnEventStart.ShowInInstances; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.ChatMessages.OnEventStart.ShowInInstances = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.ChatMessages.OnEventStart.Show end
                        },
                        ShowOnlyWhenTimeDataIsAvailable = {
                            order = OrderPP(), type = "toggle", width = AdjustedWidth(1.45),
                            name = addon.L["Only when time data is available"],
                            desc = addon.L["Show alertSystem on event start only when time data is available Desc"]:K_ReplaceVars(addon.L["Chat messages"]):KAF_AddDefaultValueText("EventReminders.ChatMessages.OnEventStart.ShowOnlyWhenTimeDataIsAvailable"),
                            get = function() return addon.Options.db.profile.EventReminders.ChatMessages.OnEventStart.ShowOnlyWhenTimeDataIsAvailable; end,
                            set = function(_, value) addon.Options.db.profile.EventReminders.ChatMessages.OnEventStart.ShowOnlyWhenTimeDataIsAvailable = value; end,
                            disabled = function() return not addon.Options.db.profile.EventReminders.ChatMessages.OnEventStart.Show end
                        }
                    }
                }
            }
        },
        CalendarEvents = {
            order = OrderPP(), type = "group", childGroups = "tab",
            name = addon.L["Calendar Events"],
            args = { --[[ Automatically generated ]] }
        },
        WorldEvents = {
            order = OrderPP(), type = "group", childGroups = "tab",
            name = addon.L["World Events"],
            args = { --[[ Automatically generated ]] }
        },
        DateTimeFormat = {
            order = OrderPP(), type = "group",
            name = addon.L["Date and Time format"],
            args = {
                StartTimeAndEndTime = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["Start Time"] .. " & " .. addon.L["End Time"],
                    args = {
                        Presets = {
                            order = OrderPP(), type = "select", width = AdjustedWidth(1.5),
                            name = addon.L["Presets"],
                            values = startTimeAndEndTimeDateTimeValues,
                            get = StartTimeAndEndTimePresetsGet,
                            set = function(_, value)
                                local custom = LibStub("AceConfigRegistry-3.0"):GetOptionsTable(addon.Metadata.Prefix .. "_EventReminders", "cmd", "KROWIAF-0.0").args.DateTimeFormat.args.StartTimeAndEndTime.args.Custom;
                                custom.set(nil, startTimeAndEndTimeDateTimeFormats[value]);
                            end
                        },
                        Custom = {
                            order = OrderPP(), type = "input", width = AdjustedWidth(1.5),
                            name = addon.L["Custom"],
                            get = function() return addon.Options.db.profile.EventReminders.DateTimeFormat.StartTimeAndEndTime; end,
                            set = StartTimeAndEndTimeCustomSet
                        }
                    }
                },
                DateTimeFormattingGuideLine = {
                    order = OrderPP(), type = "group", inline = true,
                    name = addon.L["Date and Time formatting guide"],
                    args = {
                        DateTimeFormattingGuide = {
                            order = OrderPP(), type = "description",
                            name = addon.L["Date and Time formatting guide Desc"]:K_ReplaceVars {
                                addon.L["Date and Time formatting guide Desc"],
                                a = string.format(addon.Util.Colors.Yellow, "%a"),
                                A = string.format(addon.Util.Colors.Yellow, "%A"),
                                b = string.format(addon.Util.Colors.Yellow, "%b"),
                                B = string.format(addon.Util.Colors.Yellow, "%B"),
                                c = string.format(addon.Util.Colors.Yellow, "%c"),
                                C = string.format(addon.Util.Colors.Yellow, "%C"),
                                d = string.format(addon.Util.Colors.Yellow, "%d"),
                                D = string.format(addon.Util.Colors.Yellow, "%D"),
                                e = string.format(addon.Util.Colors.Yellow, "%e"),
                                H = string.format(addon.Util.Colors.Yellow, "%H"),
                                I = string.format(addon.Util.Colors.Yellow, "%I"),
                                j = string.format(addon.Util.Colors.Yellow, "%j"),
                                k = string.format(addon.Util.Colors.Yellow, "%k"),
                                l = string.format(addon.Util.Colors.Yellow, "%l"),
                                m = string.format(addon.Util.Colors.Yellow, "%m"),
                                M = string.format(addon.Util.Colors.Yellow, "%M"),
                                p = string.format(addon.Util.Colors.Yellow, "%p"),
                                P = string.format(addon.Util.Colors.Yellow, "%P"),
                                R = string.format(addon.Util.Colors.Yellow, "%R"),
                                s = string.format(addon.Util.Colors.Yellow, "%s"),
                                S = string.format(addon.Util.Colors.Yellow, "%S"),
                                u = string.format(addon.Util.Colors.Yellow, "%u"),
                                U = string.format(addon.Util.Colors.Yellow, "%U"),
                                w = string.format(addon.Util.Colors.Yellow, "%w"),
                                W = string.format(addon.Util.Colors.Yellow, "%W"),
                                x = string.format(addon.Util.Colors.Yellow, "%x"),
                                X = string.format(addon.Util.Colors.Yellow, "%X"),
                                y = string.format(addon.Util.Colors.Yellow, "%y"),
                                Y = string.format(addon.Util.Colors.Yellow, "%Y"),
                                z = string.format(addon.Util.Colors.Yellow, "%z"),
                                Z = string.format(addon.Util.Colors.Yellow, "%Z")
                            }
                        }
                    }
                }
            }
        }
    }
};

function RefreshOptions()
    local profile = addon.Options.db.profile;
    TimeDisplayLine1Set(_, profile.EventReminders.TimeDisplay.Line1);
    TimeDisplayLine2Set(_, profile.EventReminders.TimeDisplay.Line2);
    SideButtonsAnchorSet(_, profile.EventReminders.SideButtonsAnchor);
    PopUpsGrowDirectionSet(_, profile.EventReminders.PopUps.GrowDirection);
    PopUpsSpacingSet(_, profile.EventReminders.PopUps.Spacing);
    PopUpsOffsetXSet(_, profile.EventReminders.PopUps.OffsetX);
    PopUpsOffsetYSet(_, profile.EventReminders.PopUps.OffsetY);
    addon.Gui.EventReminderSideButtonSystem:Refresh(); -- Dynamic stuff is handled by this one
    StartTimeAndEndTimeCustomSet(_, profile.EventReminders.DateTimeFormat.StartTimeAndEndTime);
end