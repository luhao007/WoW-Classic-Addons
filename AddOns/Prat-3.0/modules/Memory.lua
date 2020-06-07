---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2006-2020  Prat Development Team
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

Prat:AddModuleToLoad(function()
  local function dbg(...) end

  --[===[@debug@
  function dbg(...) Prat:PrintLiteral(...) end

  --@end-debug@]===]

  local PRAT_MODULE = Prat:RequestModuleName("Memory")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0", "AceEvent-3.0")

  -- define localized strings
  local PL = module.PL


  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
      frames = { ["*"] = {} },
      types = {},
      autoload = false
    }
  })

  --[===[@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["module_name"] = "Memory",
    ["module_desc"] = "Support saveing the Blizzard chat settings to your profile so they can be synced accross all your charactaers",
    module_info = "|cffff8888THIS MODULE IS EXPERIMENTAL|r \n\n This module allows you to load/save all your chat settings and frame layout. These settings can be loaded on any of your characters",
    autoload_name =  "Load Settings Automaticallys",
    autoload_desc = "Automatically load the saved settings when you log in",
    load_name = "Load Settings",
    load_desc = "Load tthe chat frame/tabs from the last save",
    save_name = "Save Settings",
    save_desc = "Save the currect chat frame/tab configuration",
    msg_nosettings = "No stored settings",
    msg_settingsloaded = "Settings Loaded",
    command_header_name = "Commands",
    options_header_name = "Options"
  })
  --@end-debug@]===]

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --@non-debug@
do
    local L


L = {
	["Memory"] = {
		["autoload_desc"] = "Automatically load the saved settings when you log in",
		["autoload_name"] = "Load Settings Automaticallys",
		["command_header_name"] = "Commands",
		["load_desc"] = "Load tthe chat frame/tabs from the last save",
		["load_name"] = "Load Settings",
		["module_desc"] = "Support saveing the Blizzard chat settings to your profile so they can be synced accross all your charactaers",
		["module_info"] = [=[|cffff8888THIS MODULE IS EXPERIMENTAL|r 

 This module allows you to load/save all your chat settings and frame layout. These settings can be loaded on any of your characters]=],
		["module_name"] = "Memory",
		["msg_nosettings"] = "No stored settings",
		["msg_settingsloaded"] = "Settings Loaded",
		["options_header_name"] = "Options",
		["save_desc"] = "Save the currect chat frame/tab configuration",
		["save_name"] = "Save Settings",
	}
}

PL:AddLocale(PRAT_MODULE, "enUS", L)



L = {
	["Memory"] = {
		--[[Translation missing --]]
		["autoload_desc"] = "Automatically load the saved settings when you log in",
		--[[Translation missing --]]
		["autoload_name"] = "Load Settings Automaticallys",
		--[[Translation missing --]]
		["command_header_name"] = "Commands",
		--[[Translation missing --]]
		["load_desc"] = "Load tthe chat frame/tabs from the last save",
		--[[Translation missing --]]
		["load_name"] = "Load Settings",
		--[[Translation missing --]]
		["module_desc"] = "Support saveing the Blizzard chat settings to your profile so they can be synced accross all your charactaers",
		--[[Translation missing --]]
		["module_info"] = [=[|cffff8888THIS MODULE IS EXPERIMENTAL|r 

 This module allows you to load/save all your chat settings and frame layout. These settings can be loaded on any of your characters]=],
		--[[Translation missing --]]
		["module_name"] = "Memory",
		--[[Translation missing --]]
		["msg_nosettings"] = "No stored settings",
		--[[Translation missing --]]
		["msg_settingsloaded"] = "Settings Loaded",
		--[[Translation missing --]]
		["options_header_name"] = "Options",
		--[[Translation missing --]]
		["save_desc"] = "Save the currect chat frame/tab configuration",
		--[[Translation missing --]]
		["save_name"] = "Save Settings",
	}
}

PL:AddLocale(PRAT_MODULE, "itIT", L)



L = {
	["Memory"] = {
		--[[Translation missing --]]
		["autoload_desc"] = "Automatically load the saved settings when you log in",
		--[[Translation missing --]]
		["autoload_name"] = "Load Settings Automaticallys",
		--[[Translation missing --]]
		["command_header_name"] = "Commands",
		--[[Translation missing --]]
		["load_desc"] = "Load tthe chat frame/tabs from the last save",
		--[[Translation missing --]]
		["load_name"] = "Load Settings",
		--[[Translation missing --]]
		["module_desc"] = "Support saveing the Blizzard chat settings to your profile so they can be synced accross all your charactaers",
		--[[Translation missing --]]
		["module_info"] = [=[|cffff8888THIS MODULE IS EXPERIMENTAL|r 

 This module allows you to load/save all your chat settings and frame layout. These settings can be loaded on any of your characters]=],
		--[[Translation missing --]]
		["module_name"] = "Memory",
		--[[Translation missing --]]
		["msg_nosettings"] = "No stored settings",
		--[[Translation missing --]]
		["msg_settingsloaded"] = "Settings Loaded",
		--[[Translation missing --]]
		["options_header_name"] = "Options",
		--[[Translation missing --]]
		["save_desc"] = "Save the currect chat frame/tab configuration",
		--[[Translation missing --]]
		["save_name"] = "Save Settings",
	}
}

PL:AddLocale(PRAT_MODULE, "ptBR", L)



L = {
	["Memory"] = {
		--[[Translation missing --]]
		["autoload_desc"] = "Automatically load the saved settings when you log in",
		--[[Translation missing --]]
		["autoload_name"] = "Load Settings Automaticallys",
		--[[Translation missing --]]
		["command_header_name"] = "Commands",
		--[[Translation missing --]]
		["load_desc"] = "Load tthe chat frame/tabs from the last save",
		--[[Translation missing --]]
		["load_name"] = "Load Settings",
		--[[Translation missing --]]
		["module_desc"] = "Support saveing the Blizzard chat settings to your profile so they can be synced accross all your charactaers",
		--[[Translation missing --]]
		["module_info"] = [=[|cffff8888THIS MODULE IS EXPERIMENTAL|r 

 This module allows you to load/save all your chat settings and frame layout. These settings can be loaded on any of your characters]=],
		--[[Translation missing --]]
		["module_name"] = "Memory",
		--[[Translation missing --]]
		["msg_nosettings"] = "No stored settings",
		--[[Translation missing --]]
		["msg_settingsloaded"] = "Settings Loaded",
		--[[Translation missing --]]
		["options_header_name"] = "Options",
		--[[Translation missing --]]
		["save_desc"] = "Save the currect chat frame/tab configuration",
		--[[Translation missing --]]
		["save_name"] = "Save Settings",
	}
}

PL:AddLocale(PRAT_MODULE, "frFR", L)



L = {
	["Memory"] = {
		["autoload_desc"] = "Ladet die gespeicherten Einstellungen automatisch, wenn du dich anmeldest",
		["autoload_name"] = "Einstellungen automatisch laden",
		["command_header_name"] = "Befehle",
		["load_desc"] = "Ladet den Chat-Rahmen/Registerkarten aus der letzten Speicherung",
		["load_name"] = "Einstellungen laden",
		["module_desc"] = "Unterstützt das Speichern der Blizzard-Chat Einstellungen in deinem Profil, damit sie für alle deine Charaktere synchronisiert werden können",
		["module_info"] = "DIESES MODUL IST EXPERIMENTELL = Du kannst deine Chat-Einstellungen in deinem Konto synchronisieren",
		["module_name"] = "Erinnerung",
		["msg_nosettings"] = "Keine gespeicherten Einstellungen",
		["msg_settingsloaded"] = "Einstellungen geladen",
		["options_header_name"] = "Optionen",
		["save_desc"] = "Speichert die aktuelle Konfiguration des Chat-Rahmens/Registerkarte",
		["save_name"] = "Einstellungen speichern",
	}
}

PL:AddLocale(PRAT_MODULE, "deDE", L)



L = {
	["Memory"] = {
		["autoload_desc"] = "로그인시 저장된 설정을 자동으로 불러옵니다.",
		["autoload_name"] = "자동 설정 불러오기",
		["command_header_name"] = "명령어",
		["load_desc"] = "마지막 저장에서 채팅 프레임/탭을 불러옴",
		["load_name"] = "불러오기 설정",
		["module_desc"] = "블리자드 채팅 설정을 프로필에 저장하여 모든 캐릭터와 동기화 할 수 있도록 지원",
		["module_info"] = "|cffff8888이 모듈은 실험적입니다.|r 이 모듈을 사용하면 모든 채팅 설정 및 프레임 모양을 불러오기/저장할 수 있습니다. 이 설정은 모든 캐릭터에서 불러오기 할 수 있습니다.",
		["module_name"] = "메모리",
		["msg_nosettings"] = "저장된 설정 없음",
		["msg_settingsloaded"] = "설정 불러옴",
		["options_header_name"] = "옵션",
		["save_desc"] = "정확한 채팅 프레임/탭 구성을 저장",
		["save_name"] = "저장 설정",
	}
}

PL:AddLocale(PRAT_MODULE, "koKR",  L)


L = {
	["Memory"] = {
		--[[Translation missing --]]
		["autoload_desc"] = "Automatically load the saved settings when you log in",
		--[[Translation missing --]]
		["autoload_name"] = "Load Settings Automaticallys",
		--[[Translation missing --]]
		["command_header_name"] = "Commands",
		--[[Translation missing --]]
		["load_desc"] = "Load tthe chat frame/tabs from the last save",
		--[[Translation missing --]]
		["load_name"] = "Load Settings",
		--[[Translation missing --]]
		["module_desc"] = "Support saveing the Blizzard chat settings to your profile so they can be synced accross all your charactaers",
		--[[Translation missing --]]
		["module_info"] = [=[|cffff8888THIS MODULE IS EXPERIMENTAL|r 

 This module allows you to load/save all your chat settings and frame layout. These settings can be loaded on any of your characters]=],
		--[[Translation missing --]]
		["module_name"] = "Memory",
		--[[Translation missing --]]
		["msg_nosettings"] = "No stored settings",
		--[[Translation missing --]]
		["msg_settingsloaded"] = "Settings Loaded",
		--[[Translation missing --]]
		["options_header_name"] = "Options",
		--[[Translation missing --]]
		["save_desc"] = "Save the currect chat frame/tab configuration",
		--[[Translation missing --]]
		["save_name"] = "Save Settings",
	}
}

PL:AddLocale(PRAT_MODULE, "esMX",  L)


L = {
	["Memory"] = {
		--[[Translation missing --]]
		["autoload_desc"] = "Automatically load the saved settings when you log in",
		--[[Translation missing --]]
		["autoload_name"] = "Load Settings Automaticallys",
		--[[Translation missing --]]
		["command_header_name"] = "Commands",
		--[[Translation missing --]]
		["load_desc"] = "Load tthe chat frame/tabs from the last save",
		--[[Translation missing --]]
		["load_name"] = "Load Settings",
		--[[Translation missing --]]
		["module_desc"] = "Support saveing the Blizzard chat settings to your profile so they can be synced accross all your charactaers",
		--[[Translation missing --]]
		["module_info"] = [=[|cffff8888THIS MODULE IS EXPERIMENTAL|r 

 This module allows you to load/save all your chat settings and frame layout. These settings can be loaded on any of your characters]=],
		--[[Translation missing --]]
		["module_name"] = "Memory",
		--[[Translation missing --]]
		["msg_nosettings"] = "No stored settings",
		--[[Translation missing --]]
		["msg_settingsloaded"] = "Settings Loaded",
		--[[Translation missing --]]
		["options_header_name"] = "Options",
		--[[Translation missing --]]
		["save_desc"] = "Save the currect chat frame/tab configuration",
		--[[Translation missing --]]
		["save_name"] = "Save Settings",
	}
}

PL:AddLocale(PRAT_MODULE, "ruRU",  L)


L = {
	["Memory"] = {
		--[[Translation missing --]]
		["autoload_desc"] = "Automatically load the saved settings when you log in",
		--[[Translation missing --]]
		["autoload_name"] = "Load Settings Automaticallys",
		--[[Translation missing --]]
		["command_header_name"] = "Commands",
		--[[Translation missing --]]
		["load_desc"] = "Load tthe chat frame/tabs from the last save",
		--[[Translation missing --]]
		["load_name"] = "Load Settings",
		--[[Translation missing --]]
		["module_desc"] = "Support saveing the Blizzard chat settings to your profile so they can be synced accross all your charactaers",
		--[[Translation missing --]]
		["module_info"] = [=[|cffff8888THIS MODULE IS EXPERIMENTAL|r 

 This module allows you to load/save all your chat settings and frame layout. These settings can be loaded on any of your characters]=],
		--[[Translation missing --]]
		["module_name"] = "Memory",
		--[[Translation missing --]]
		["msg_nosettings"] = "No stored settings",
		--[[Translation missing --]]
		["msg_settingsloaded"] = "Settings Loaded",
		--[[Translation missing --]]
		["options_header_name"] = "Options",
		--[[Translation missing --]]
		["save_desc"] = "Save the currect chat frame/tab configuration",
		--[[Translation missing --]]
		["save_name"] = "Save Settings",
	}
}

PL:AddLocale(PRAT_MODULE, "zhCN",  L)


L = {
	["Memory"] = {
		--[[Translation missing --]]
		["autoload_desc"] = "Automatically load the saved settings when you log in",
		--[[Translation missing --]]
		["autoload_name"] = "Load Settings Automaticallys",
		--[[Translation missing --]]
		["command_header_name"] = "Commands",
		--[[Translation missing --]]
		["load_desc"] = "Load tthe chat frame/tabs from the last save",
		--[[Translation missing --]]
		["load_name"] = "Load Settings",
		--[[Translation missing --]]
		["module_desc"] = "Support saveing the Blizzard chat settings to your profile so they can be synced accross all your charactaers",
		--[[Translation missing --]]
		["module_info"] = [=[|cffff8888THIS MODULE IS EXPERIMENTAL|r 

 This module allows you to load/save all your chat settings and frame layout. These settings can be loaded on any of your characters]=],
		--[[Translation missing --]]
		["module_name"] = "Memory",
		--[[Translation missing --]]
		["msg_nosettings"] = "No stored settings",
		--[[Translation missing --]]
		["msg_settingsloaded"] = "Settings Loaded",
		--[[Translation missing --]]
		["options_header_name"] = "Options",
		--[[Translation missing --]]
		["save_desc"] = "Save the currect chat frame/tab configuration",
		--[[Translation missing --]]
		["save_name"] = "Save Settings",
	}
}

PL:AddLocale(PRAT_MODULE, "esES",  L)


L = {
	["Memory"] = {
		--[[Translation missing --]]
		["autoload_desc"] = "Automatically load the saved settings when you log in",
		--[[Translation missing --]]
		["autoload_name"] = "Load Settings Automaticallys",
		--[[Translation missing --]]
		["command_header_name"] = "Commands",
		--[[Translation missing --]]
		["load_desc"] = "Load tthe chat frame/tabs from the last save",
		--[[Translation missing --]]
		["load_name"] = "Load Settings",
		--[[Translation missing --]]
		["module_desc"] = "Support saveing the Blizzard chat settings to your profile so they can be synced accross all your charactaers",
		--[[Translation missing --]]
		["module_info"] = [=[|cffff8888THIS MODULE IS EXPERIMENTAL|r 

 This module allows you to load/save all your chat settings and frame layout. These settings can be loaded on any of your characters]=],
		--[[Translation missing --]]
		["module_name"] = "Memory",
		--[[Translation missing --]]
		["msg_nosettings"] = "No stored settings",
		--[[Translation missing --]]
		["msg_settingsloaded"] = "Settings Loaded",
		--[[Translation missing --]]
		["options_header_name"] = "Options",
		--[[Translation missing --]]
		["save_desc"] = "Save the currect chat frame/tab configuration",
		--[[Translation missing --]]
		["save_name"] = "Save Settings",
	}
}

PL:AddLocale(PRAT_MODULE, "zhTW",  L)
end
--@end-non-debug@

  local toggleOption = {
    name = function(info) return info.handler.PL[info[#info] .. "_name"] end,
    desc = function(info) return info.handler.PL[info[#info] .. "_desc"] end,
    type = "toggle",
  }

  Prat:SetModuleOptions(module.name, {
    name = PL.module_name,
    desc = PL.module_desc,
    type = "group",
    args = {
      info = {
        name = PL.module_info,
        type = "description",
      },
      command_header = {
        name = PL.command_header_name,
        type = "header",
        order = 190,
      },
      save = {
        name = PL.save_name,
        desc = PL.save_desc,
        type = "execute",
        order = 191,
        func = "SaveSettings"
      },
      load = {
        name = PL.load_name,
        desc = PL.load_desc,
        type = "execute",
        order = 190,
        func = "LoadSettings"
      },
      options_header = {
        name = PL.options_header_name,
        type = "header",
        order = 195,
      },
      autoload = {
        name = PL.autoload_name,
        desc = PL.autoload_desc,
        type = "toggle",
        order = 200,
      }
    }
  })

  Prat:SetModuleInit(module.name,
    function(self)
      self:RegisterEvent("PLAYER_ENTERING_WORLD")
    end)

  function module:PLAYER_ENTERING_WORLD()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self.ready = true
    if self.needaLoading then
      self:LoadSettings()
    end
  end

  function module:OnModuleEnable()
    self.db.RegisterCallback(self, "OnProfileShutdown")

    if self.db.profile.autoload and next(self.db.profile.frames) then
      if not self.ready then
        self.needsLoading = true
      else
        self:LoadSettings()
      end
    end
  end

  function module:OnProfileShutdown()
    -- Some blizzard tables were connected to the profile, but now we need to give the profile its own copy
    if self.db.profile.types == getmetatable(ChatTypeInfo).__index then
      self.db.profile.types = CopyTable(self.db.profile.types)
    end
  end

  function module:SaveSettings()
    local db = self.db.profile

    for i = 1,NUM_CHAT_WINDOWS do
        self:SaveSettingsForFrame(i)
    end

    db.types = getmetatable(ChatTypeInfo).__index

    self:Output("Settings Saved")
  end

  function module:SaveSettingsForFrame(frameId)
    local db = self.db.profile.frames[frameId]

    local name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(frameId)
    db.name, db.fontSize, db.r, db.g, db.b, db.alpha, db.shown, db.locked, db.docked, db.uninteractable =
      name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable

    db.messages = { GetChatWindowMessages(frameId) }
    db.channels = { GetChatWindowChannels(frameId) }

    local width, height = GetChatWindowSavedDimensions(frameId);
    local point, xOffset, yOffset = GetChatWindowSavedPosition(frameId)

    db.point, db.xOffset, db.yOffset, db.width, db.height =
      point, xOffset, yOffset, width, height
  end

  function module:LoadSettingsForFrame(frameId)
    local db = self.db.profile.frames[frameId]

    -- Restore FloatingChatFrame
    SetChatWindowName(frameId, db.name)
    SetChatWindowSize(frameId, db.fontSize)
    SetChatWindowColor(frameId, db.r, db.g, db.b)
    SetChatWindowAlpha(frameId, db.alpha)
    SetChatWindowDocked(frameId, db.docked)
    SetChatWindowLocked(frameId, db.locked)
    SetChatWindowUninteractable(frameId, db.uninteractable)
    SetChatWindowSavedDimensions(frameId, db.width, db.height)
    if db.point then
      SetChatWindowSavedPosition(frameId, db.point, db.xOffset, db.yOffset)
    end
    SetChatWindowShown(frameId, db.shown)
    FloatingChatFrame_Update(frameId, 1)

    -- Restore ChatFrame
    local f = Chat_GetChatFrame(frameId)
    ChatFrame_RemoveAllMessageGroups(f)
    for _, v in ipairs(db.messages) do
      ChatFrame_AddMessageGroup(f, v);
    end

    ChatFrame_RemoveAllChannels(f)
    for _, v in ipairs(db.channels) do
      ChatFrame_AddChannel(f, v)
    end

    ChatFrame_ReceiveAllPrivateMessages(f)
  end

  function module:LoadSettings()
    self.needsLoading = nil
    local db = self.db.profile

    if not next(db.frames) then
      self:Output(PL.msg_nosettings)
    end

    for k,v in pairs(db.frames) do
      self:LoadSettingsForFrame(k)
    end

    for k,v in pairs(db.types) do
      ChangeChatColor(k, v.r, v.g, v.b)
    end

    self:Output(PL.msg_settingsloaded)
  end
end)

