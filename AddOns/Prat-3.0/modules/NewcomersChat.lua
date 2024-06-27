--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2023  Prat Development Team
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to:
--
-- Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor,
-- Boston, MA  02110-1301, USA.
--
--
-------------------------------------------------------------------------------

if Prat.IsClassic then
  return
end

Prat:AddModuleToLoad(function()

  local PRAT_MODULE = Prat:RequestModuleName("NewcomersChat")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE)

  -- define localized strings
  local PL = module.PL

  --[==[@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["NewcomersChat"] = "Newcomers Chat",
    ["module_desc"] = "Configure icons and text indicating guides and newcomers from and in the Newcomers channel",
    ["As Newcomer"] = "As Newcomer",
    ["As Guide"] = "As Guide",
    ["Newcomer Icon"] = "Newcomer Icon",
    ["Guide Icon"] = "Guide Icon",
    ["Guide Label"] = "Guide Label",
    ["In newcomers chat"] = "In newcomers chat",
    ["In normal chat"] = "In normal chat",
    ["Guide"] = "Guide",
  })
  --@end-debug@]==]

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/
  --@non-debug@
  do
      local L


L = {
	["NewcomersChat"] = {
		["As Guide"] = true,
		["As Newcomer"] = true,
		["Guide"] = true,
		["Guide Icon"] = true,
		["Guide Label"] = true,
		["In newcomers chat"] = true,
		["In normal chat"] = true,
		["module_desc"] = "Configure icons and text indicating guides and newcomers from and in the Newcomers channel",
		["Newcomer Icon"] = true,
		["NewcomersChat"] = "Newcomers Chat",
	}
}


    PL:AddLocale(PRAT_MODULE, "enUS",L)



L = {
	["NewcomersChat"] = {
		--[[Translation missing --]]
		["As Guide"] = "As Guide",
		--[[Translation missing --]]
		["As Newcomer"] = "As Newcomer",
		--[[Translation missing --]]
		["Guide"] = "Guide",
		--[[Translation missing --]]
		["Guide Icon"] = "Guide Icon",
		--[[Translation missing --]]
		["Guide Label"] = "Guide Label",
		--[[Translation missing --]]
		["In newcomers chat"] = "In newcomers chat",
		--[[Translation missing --]]
		["In normal chat"] = "In normal chat",
		--[[Translation missing --]]
		["module_desc"] = "Configure icons and text indicating guides and newcomers from and in the Newcomers channel",
		--[[Translation missing --]]
		["Newcomer Icon"] = "Newcomer Icon",
		--[[Translation missing --]]
		["NewcomersChat"] = "Newcomers Chat",
	}
}


    PL:AddLocale(PRAT_MODULE, "frFR",L)



L = {
	["NewcomersChat"] = {
		["As Guide"] = "As Mentor",
		["As Newcomer"] = "Als Neuling",
		["Guide"] = "Mentor",
		["Guide Icon"] = "Mentor Icon",
		["Guide Label"] = "Mentor Label",
		["In newcomers chat"] = "Im Neulings-Chat",
		["In normal chat"] = "Im normalen Chat",
		["module_desc"] = "Konfiguriert Symbole und Texte, die auf Mentor und Neulinge, von und im Neulingskanal hinweisen",
		["Newcomer Icon"] = "Neulingssymbol",
		["NewcomersChat"] = "Neulings-Chat",
	}
}


    PL:AddLocale(PRAT_MODULE, "deDE",L)



L = {
	["NewcomersChat"] = {
		--[[Translation missing --]]
		["As Guide"] = "As Guide",
		--[[Translation missing --]]
		["As Newcomer"] = "As Newcomer",
		--[[Translation missing --]]
		["Guide"] = "Guide",
		--[[Translation missing --]]
		["Guide Icon"] = "Guide Icon",
		--[[Translation missing --]]
		["Guide Label"] = "Guide Label",
		--[[Translation missing --]]
		["In newcomers chat"] = "In newcomers chat",
		--[[Translation missing --]]
		["In normal chat"] = "In normal chat",
		--[[Translation missing --]]
		["module_desc"] = "Configure icons and text indicating guides and newcomers from and in the Newcomers channel",
		--[[Translation missing --]]
		["Newcomer Icon"] = "Newcomer Icon",
		--[[Translation missing --]]
		["NewcomersChat"] = "Newcomers Chat",
	}
}


    PL:AddLocale(PRAT_MODULE, "koKR",L)



L = {
	["NewcomersChat"] = {
		--[[Translation missing --]]
		["As Guide"] = "As Guide",
		--[[Translation missing --]]
		["As Newcomer"] = "As Newcomer",
		--[[Translation missing --]]
		["Guide"] = "Guide",
		--[[Translation missing --]]
		["Guide Icon"] = "Guide Icon",
		--[[Translation missing --]]
		["Guide Label"] = "Guide Label",
		--[[Translation missing --]]
		["In newcomers chat"] = "In newcomers chat",
		--[[Translation missing --]]
		["In normal chat"] = "In normal chat",
		--[[Translation missing --]]
		["module_desc"] = "Configure icons and text indicating guides and newcomers from and in the Newcomers channel",
		--[[Translation missing --]]
		["Newcomer Icon"] = "Newcomer Icon",
		--[[Translation missing --]]
		["NewcomersChat"] = "Newcomers Chat",
	}
}


    PL:AddLocale(PRAT_MODULE, "esMX",L)



L = {
	["NewcomersChat"] = {
		--[[Translation missing --]]
		["As Guide"] = "As Guide",
		--[[Translation missing --]]
		["As Newcomer"] = "As Newcomer",
		--[[Translation missing --]]
		["Guide"] = "Guide",
		--[[Translation missing --]]
		["Guide Icon"] = "Guide Icon",
		--[[Translation missing --]]
		["Guide Label"] = "Guide Label",
		--[[Translation missing --]]
		["In newcomers chat"] = "In newcomers chat",
		--[[Translation missing --]]
		["In normal chat"] = "In normal chat",
		--[[Translation missing --]]
		["module_desc"] = "Configure icons and text indicating guides and newcomers from and in the Newcomers channel",
		--[[Translation missing --]]
		["Newcomer Icon"] = "Newcomer Icon",
		--[[Translation missing --]]
		["NewcomersChat"] = "Newcomers Chat",
	}
}


    PL:AddLocale(PRAT_MODULE, "ruRU",L)



L = {
	["NewcomersChat"] = {
		--[[Translation missing --]]
		["As Guide"] = "As Guide",
		--[[Translation missing --]]
		["As Newcomer"] = "As Newcomer",
		--[[Translation missing --]]
		["Guide"] = "Guide",
		--[[Translation missing --]]
		["Guide Icon"] = "Guide Icon",
		--[[Translation missing --]]
		["Guide Label"] = "Guide Label",
		--[[Translation missing --]]
		["In newcomers chat"] = "In newcomers chat",
		--[[Translation missing --]]
		["In normal chat"] = "In normal chat",
		--[[Translation missing --]]
		["module_desc"] = "Configure icons and text indicating guides and newcomers from and in the Newcomers channel",
		--[[Translation missing --]]
		["Newcomer Icon"] = "Newcomer Icon",
		--[[Translation missing --]]
		["NewcomersChat"] = "Newcomers Chat",
	}
}


    PL:AddLocale(PRAT_MODULE, "zhCN",L)



L = {
	["NewcomersChat"] = {
		--[[Translation missing --]]
		["As Guide"] = "As Guide",
		--[[Translation missing --]]
		["As Newcomer"] = "As Newcomer",
		--[[Translation missing --]]
		["Guide"] = "Guide",
		--[[Translation missing --]]
		["Guide Icon"] = "Guide Icon",
		--[[Translation missing --]]
		["Guide Label"] = "Guide Label",
		--[[Translation missing --]]
		["In newcomers chat"] = "In newcomers chat",
		--[[Translation missing --]]
		["In normal chat"] = "In normal chat",
		--[[Translation missing --]]
		["module_desc"] = "Configure icons and text indicating guides and newcomers from and in the Newcomers channel",
		--[[Translation missing --]]
		["Newcomer Icon"] = "Newcomer Icon",
		--[[Translation missing --]]
		["NewcomersChat"] = "Newcomers Chat",
	}
}


    PL:AddLocale(PRAT_MODULE, "esES",L)



L = {
	["NewcomersChat"] = {
		--[[Translation missing --]]
		["As Guide"] = "As Guide",
		--[[Translation missing --]]
		["As Newcomer"] = "As Newcomer",
		--[[Translation missing --]]
		["Guide"] = "Guide",
		--[[Translation missing --]]
		["Guide Icon"] = "Guide Icon",
		--[[Translation missing --]]
		["Guide Label"] = "Guide Label",
		--[[Translation missing --]]
		["In newcomers chat"] = "In newcomers chat",
		--[[Translation missing --]]
		["In normal chat"] = "In normal chat",
		--[[Translation missing --]]
		["module_desc"] = "Configure icons and text indicating guides and newcomers from and in the Newcomers channel",
		--[[Translation missing --]]
		["Newcomer Icon"] = "Newcomer Icon",
		--[[Translation missing --]]
		["NewcomersChat"] = "Newcomers Chat",
	}
}


    PL:AddLocale(PRAT_MODULE, "zhTW",L)


  end
  --@end-non-debug@

  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
      asNewcomer = {
        newcomerIcon = {
          inNewcomersChat = false,
          inNormalChat = false
        },
        guideIcon = {
          inNewcomersChat = true,
          inNormalChat = false
        },
        guideLabel = {
          inNewcomersChat = true,
          inNormalChat = false
        },
      },
      asGuide = {
        newcomerIcon = {
          inNewcomersChat = true,
          inNormalChat = true
        },
        guideIcon = {
          inNewcomersChat = true,
          inNormalChat = false
        },
        guideLabel = {
          inNewcomersChat = true,
          inNormalChat = false
        },
      },
    },
  })

  local function GetBundle(name, description, order)
    return {
      name = name or "",
      desc = description or "",
      type = "group",
      inline = true,
      order = order,
      args = {
        inNewcomersChat = {
          name = PL["In newcomers chat"],
          type = "toggle",
          order = 10,
        },
        inNormalChat = {
          name = PL["In normal chat"],
          type = "toggle",
          order = 20,
        },
      }
    }
  end
  local function GetTab(name, description)
    return {
      name = name or "",
      desc = description or "",
      type = "group",
      args = {
        newcomerIcon = GetBundle(PL["Newcomer Icon"], nil, 10),
        guideIcon = GetBundle(PL["Guide Icon"], nil, 20),
        guideLabel = GetBundle(PL["Guide Label"], nil, 30),
      },
    }
  end

  module.pluginopts = {}
  Prat:SetModuleOptions(module, {
    name = PL["NewcomersChat"],
    desc = PL["module_desc"],
    type = "group",
    plugins = module.pluginopts,
    childGroups = "tab",
    get = function(info)
      return module.db.profile[info[#info-2]][info[#info-1]][info[#info]]
    end,
    set = function(info, value)
      module.db.profile[info[#info-2]][info[#info-1]][info[#info]] = value
    end,
    args = {
      asNewcomer = GetTab(PL["As Newcomer"]),
      asGuide = GetTab(PL["As Guide"]),
    }
  })

  function module:OnModuleEnable()
    Prat.RegisterChatEvent(self, "Prat_FrameMessage")
  end

  function module:OnModuleDisable()
    Prat.UnregisterAllChatEvents(self)
  end

  local GUIDE_ICON = "|A:newplayerchat-chaticon-guide:0:0:0:0|a"
  local GUIDE_TEXT = "|cff81b558" .. PL["Guide"] .. "|r"
  local NEWCOMER_ICON = "|A:newplayerchat-chaticon-newcomer:0:0:0:0|a"

  function module:ApplySettings(settings, senderStatus, message)
    message.FLAG = ""

    local ruleSet = C_ChatInfo.GetChannelRulesetForChannelID(message.ARGS[7])
    if ruleSet == Enum.ChatChannelRuleset.Mentor then
      if senderStatus == "GUIDE" then
        if settings.guideIcon.inNewcomersChat then
          message.FLAG = GUIDE_ICON
        end
        if settings.guideLabel.inNewcomersChat then
          message.FLAG = message.FLAG .. GUIDE_TEXT
        end
        if settings.guideIcon.inNewcomersChat or settings.guideLabel.inNewcomersChat then
          message.FLAG = message.FLAG .. " "
        end
      elseif senderStatus == "NEWCOMER" then
        if settings.newcomerIcon.inNewcomersChat then
          message.FLAG = NEWCOMER_ICON
        end
      end

    else
      if senderStatus == "GUIDE" then
        if settings.guideIcon.inNormalChat then
          message.FLAG = GUIDE_ICON
        end
        if settings.guideLabel.inNormalChat then
          message.FLAG = message.FLAG .. GUIDE_TEXT
        end
        if settings.guideIcon.inNormalChat or settings.guideLabel.inNormalChat then
          message.FLAG = message.FLAG .. " "
        end
      elseif senderStatus == "NEWCOMER" then
        if settings.newcomerIcon.inNormalChat then
          message.FLAG = NEWCOMER_ICON
        end
      end
    end
  end

  function module:Prat_FrameMessage(info, message, frame, event)
    local arg6 = message.ARGS[6] or ""

    if arg6 ~= "GUIDE" and arg6 ~= "NEWCOMER" then
      return
    end

    if IsActivePlayerGuide() then
      self:ApplySettings(self.db.profile.asGuide, arg6, message)
    elseif C_PlayerMentorship.IsActivePlayerConsideredNewcomer() then
      self:ApplySettings(self.db.profile.asNewcomer, arg6, message)
    end
  end

  return
end) -- Prat:AddModuleToLoad
