-- [[ Namespaces ]] --
local _, addon = ...;
local options = addon.Options;
options.Credits = {};
local credits = options.Credits;
tinsert(options.OptionsTables, credits);

local OrderPP = addon.InjectOptions.AutoOrderPlusPlus;

function credits.RegisterOptionsTable()
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addon.Metadata.Prefix .. "_Credits", options.OptionsTable.args.Credits);
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addon.Metadata.Prefix .. "_Credits", addon.L["Credits"], addon.Metadata.Title);
end

function credits.PostLoad()
    local specialThanks = addon.Credits.GetSpecialThanksAsTable();
    for i, specialTnx in next, specialThanks do
        addon.InjectOptions:AddTable("Credits.args.SpecialThanks.args", "Name" .. i, {
            order = OrderPP(), type = "description", width = "full",
            name = specialTnx,
            fontSize = "medium"
        });
    end

    local donations = addon.Credits.GetDonationsAsTable();
    for i, donation in next, donations do
        addon.InjectOptions:AddTable("Credits.args.Donations.args", "Name" .. i, {
            order = OrderPP(), type = "description", width = "full",
            name = donation,
            fontSize = "medium"
        });
    end

    local localizations = addon.Credits.GetLocalizationsAsTable();
    for i, localization in next, localizations do
        addon.InjectOptions:AddTable("Credits.args.Localizations.args", "Name" .. i, {
            order = OrderPP(), type = "description", width = "full",
            name = localization,
            fontSize = "medium"
        });
    end
end

options.OptionsTable.args["Credits"] = {
    type = "group",
    name = addon.L["Credits"],
    args = {
        SpecialThanks = {
            order = 1, type = "group", inline = true,
            name = addon.L["Special thanks"],
            args = { --[[ Automatically generated ]] }
        },
        Donations = {
            order = 2, type = "group", inline = true,
            name = addon.L["Donations"],
            args = { --[[ Automatically generated ]] }
        },
        Localizations = {
            order = 3, type = "group", inline = true,
            name = addon.L["Localizations"],
            args = { --[[ Automatically generated ]] }
        }
    }
};