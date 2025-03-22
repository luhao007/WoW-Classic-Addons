local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L =addonTable.locale
if GetLocale() == "enUS" then
L["ADDON_NAME"] = "Toolbox";
L["ADDON_AUTHOR"]="Contact Author";
--About
L["ABOUT_TABNAME"] = "About";
L["ABOUT_UPDATETIPS"] = "The AddOn has expired. Please check the update address in AddOn About";
L["ABOUT_LOAD"] = "Loading succeeded /pig or mini map button setting";
L["ABOUT_REMINDER"]="|cff00FF00(See Plugin About menu for updates)|r"
L["ABOUT_UPDATEADD"]="Update: "
L["ABOUT_MAIL"]="Feedback: "
L["ABOUT_MEDIA"]="Use tutorial: "
--error
L["ERROR_CLEAR"] = "clear";
L["ERROR_PREVIOUS"] = "previous";
L["ERROR_NEXT"] = "next";
L["ERROR_EMPTY"] = "No errors occur";
L["ERROR_CURRENT"] = "current";
L["ERROR_OLD"] = "old";
L["ERROR_ADDON"] = "addon";
L["ERROR_ERROR1"] = "Try to invoke the protection function";
L["ERROR_ERROR2"] = "The macro attempts to invoke the protection function";
---lib
L["LIB_MACROERR"] = "The number of your macros has reached 120, please delete some and try again";
L["LIB_TIPS"] = "Tips";
--OptionsUI
L["OPTUI_SET"] = "Setting";
L["OPTUI_RLUI"] = "ReloadUI";
L["OPTUI_RLUITIPS"] = "*The configuration has changed. \nReload the UI to apply the new configuration*";
L["OPTUI_ERRORTIPS"] = "***Addon loading failed. Please try again***";
--Debug
L["DEBUG_TABNAME"] = "Debug";
L["DEBUG_BUTNAME"] = "Memory CPU usage";
L["DEBUG_CPUUSAGE"] = "CPU usage";
L["DEBUG_CPUUSAGETIPS"] = "Enable CPU usage monitoring only when necessary\nThis function consumes system performance\n"..string.format(ERR_USE_LOCKED_WITH_ITEM_S,RELOADUI);
L["DEBUG_COLLECT"] = "collect";
L["DEBUG_COLLECTTIPS"] = "|cff00FFffThis function causes all execution of the plug-in to stop until the recall process is complete\nToo many addons can take more than a few seconds, which causes the game to freeze temporarily\nWith the exception of plug-in development and debugging, manual calls are not required in most cases,\nand LUA's automatic memory management mechanism operates periodically|r";
L["DEBUG_ADDNUM"] = "AddOn";
L["DEBUG_ADD"] = "AddOn";
L["DEBUG_MEMORY"] = "memory";
L["DEBUG_ERRORLOG"] = "Error log";
L["DEBUG_OPENERRORLOGCMD"] = "Open log cmd：";
L["DEBUG_ERRORCHECK"] = "test";
L["DEBUG_ERRORTOOLTIP"] = "Button prompt in minimap when error occurs (shows a red X)\nAnd it won't store the BugSack plugin's mini map icon";
L["DEBUG_SCRIPTTOOLTIP"] = "Turn on the LUA error prompt function that comes with the game.  Do not turn it on unless you debug the AddOn";
L["DEBUG_TAINTLOG"] = "Taint log";
L["DEBUG_TAINT0"] = "Nothing is recorded";
L["DEBUG_TAINT1"] = "Records the blocked operations";
L["DEBUG_TAINT2"] = "Records blocked operations/global variables";
L["DEBUG_TAINT11"] = "Records blocked operations/global variables/entries(PTR/Beta)";
L["DEBUG_GETGUIDBUT"] = "Get Target GUID";
L["DEBUG_CONFIG"] = "Debug "..L["CONFIG_TABNAME"];
L["DEBUG_CONFIGTIPS"] = "This configuration disables all functions by default,\nFor debugging addons";
--Config
L["CONFIG_TABNAME"] = "Config";
L["CONFIG_DIYTIPS"] = "Customization: Please contact the author";
L["CONFIG_LOADTIPS"] = "This action |cff00ff00loads|r the Settings for |cff00ff00<%s>|r. The saved data will be |cffff0000cleared|r. Need to reload the interface, is loaded?";
L["CONFIG_ERRTIPS"] = "1、If you run into problems, load the addon "..CHAT_DEFAULT.." configuration here.\n2、If the problem is still unresolved,\nPlease submit questions via the feedback on the about.";
L["CONFIG_DAORU"] = "Import";
L["CONFIG_IMPORT"] = "Enter the string you want to import below and click the Import button";
L["CONFIG_DERIVE"] = "Copy the bottom string and paste it to where you want to import it";
L["CONFIG_DERIVERL"] = "Import and reload";
L["CONFIG_DERIVEERROR"] = "Import failed, unrecognized string";
--
L["TARDIS_TABNAME"] = "Tardis";
L["TARDIS_CHEDUI"] = "Motorcade";
L["TARDIS_HOUCHE"] = "Waiting";
L["TARDIS_PLANE"] = "Layer";
L["TARDIS_YELL"] = "Yell";
L["TARDIS_RECEIVEDATA"] = "Receiving data...";
L["TARDIS_LFG_JOIN"] = "Join PIG CHANNEL";
L["TARDIS_LFG_LEAVE"] = "Already joined PIG";
end