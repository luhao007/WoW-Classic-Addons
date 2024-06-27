---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2006-2018  Prat Development Team
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

  local Prat = Prat

  local PRAT_MODULE = Prat:RequestModuleName("Frames")

  if PRAT_MODULE == nil then
    return
  end

  local mod = Prat:NewModule(PRAT_MODULE, "AceHook-3.0")

  local PL = mod.PL

  --[==[@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["Frames"] = true,
    ["Chat window frame parameter options"] = true,
    ["removeclamp_name"] = "Zero Clamp Size",
    ["removeclamp_desc"] = "Allow the chatframe to be moved flush with the edge of the screen",
    ["minchatwidth_name"] = "Set Minimum Width",
    ["minchatwidth_desc"] = "Sets the minimum width for all chat windows.",
    ["maxchatwidth_name"] = "Set Maximum Width",
    ["maxchatwidth_desc"] = "Sets the maximum width for all chat windows.",
    ["minchatheight_name"] = "Set Minimum Height",
    ["minchatheight_desc"] = "Sets the minimum height for all chat windows.",
    ["maxchatheight_name"] = "Set Maximum Height",
    ["maxchatheight_desc"] = "Sets the maximum height for all chat windows.",
    ["mainchatonload_name"] = "Force Main Chat Frame On Load",
    ["mainchatonload_desc"] = "Automatically select the first chat frame and make it active on load.",
    ["framealphastatic_name"] = "Static Chatframe Alpha",
    ["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
    ["defaultframealpha_name"] = "Default alpha on mouseover",
    ["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
  })
  --@end-debug@]==]

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/

  --@non-debug@
do
    local L


L = {
	["Frames"] = {
		["Chat window frame parameter options"] = true,
		["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
		["defaultframealpha_name"] = "Default alpha on mouseover",
		["framealpha_desc"] = "Conrols the transparency of the chatframe when you hover over it with your mouse.",
		["framealpha_name"] = "Set Chatframe Alpha",
		["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
		["framealphastatic_name"] = "Static Chatframe Alpha",
		["Frames"] = true,
		["mainchatonload_desc"] = "Automatically select the first chat frame and make it active on load.",
		["mainchatonload_name"] = "Force Main Chat Frame On Load",
		["maxchatheight_desc"] = "Sets the maximum height for all chat windows.",
		["maxchatheight_name"] = "Set Maximum Height",
		["maxchatwidth_desc"] = "Sets the maximum width for all chat windows.",
		["maxchatwidth_name"] = "Set Maximum Width",
		["minchatheight_desc"] = "Sets the minimum height for all chat windows.",
		["minchatheight_name"] = "Set Minimum Height",
		["minchatwidth_desc"] = "Sets the minimum width for all chat windows.",
		["minchatwidth_name"] = "Set Minimum Width",
		["rememberframepositions_desc"] = "Remember the chatframe positions, and restore them on load",
		["rememberframepositions_name"] = "Remember Positions",
		["removeclamp_desc"] = "Allow the chatframe to be moved flush with the edge of the screen",
		["removeclamp_name"] = "Zero Clamp Size",
	}
}

PL:AddLocale(PRAT_MODULE, "enUS", L)

L = {
	["Frames"] = {
		--[[Translation missing --]]
		["Chat window frame parameter options"] = "Chat window frame parameter options",
		--[[Translation missing --]]
		["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
		--[[Translation missing --]]
		["defaultframealpha_name"] = "Default alpha on mouseover",
		--[[Translation missing --]]
		["framealpha_desc"] = "Conrols the transparency of the chatframe when you hover over it with your mouse.",
		--[[Translation missing --]]
		["framealpha_name"] = "Set Chatframe Alpha",
		--[[Translation missing --]]
		["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
		--[[Translation missing --]]
		["framealphastatic_name"] = "Static Chatframe Alpha",
		--[[Translation missing --]]
		["Frames"] = "Frames",
		--[[Translation missing --]]
		["mainchatonload_desc"] = "Automatically select the first chat frame and make it active on load.",
		--[[Translation missing --]]
		["mainchatonload_name"] = "Force Main Chat Frame On Load",
		--[[Translation missing --]]
		["maxchatheight_desc"] = "Sets the maximum height for all chat windows.",
		--[[Translation missing --]]
		["maxchatheight_name"] = "Set Maximum Height",
		--[[Translation missing --]]
		["maxchatwidth_desc"] = "Sets the maximum width for all chat windows.",
		--[[Translation missing --]]
		["maxchatwidth_name"] = "Set Maximum Width",
		--[[Translation missing --]]
		["minchatheight_desc"] = "Sets the minimum height for all chat windows.",
		--[[Translation missing --]]
		["minchatheight_name"] = "Set Minimum Height",
		--[[Translation missing --]]
		["minchatwidth_desc"] = "Sets the minimum width for all chat windows.",
		--[[Translation missing --]]
		["minchatwidth_name"] = "Set Minimum Width",
		--[[Translation missing --]]
		["rememberframepositions_desc"] = "Remember the chatframe positions, and restore them on load",
		--[[Translation missing --]]
		["rememberframepositions_name"] = "Remember Positions",
		--[[Translation missing --]]
		["removeclamp_desc"] = "Allow the chatframe to be moved flush with the edge of the screen",
		--[[Translation missing --]]
		["removeclamp_name"] = "Zero Clamp Size",
	}
}

PL:AddLocale(PRAT_MODULE, "itIT", L)

L = {
	["Frames"] = {
		--[[Translation missing --]]
		["Chat window frame parameter options"] = "Chat window frame parameter options",
		--[[Translation missing --]]
		["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
		--[[Translation missing --]]
		["defaultframealpha_name"] = "Default alpha on mouseover",
		--[[Translation missing --]]
		["framealpha_desc"] = "Conrols the transparency of the chatframe when you hover over it with your mouse.",
		--[[Translation missing --]]
		["framealpha_name"] = "Set Chatframe Alpha",
		--[[Translation missing --]]
		["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
		--[[Translation missing --]]
		["framealphastatic_name"] = "Static Chatframe Alpha",
		--[[Translation missing --]]
		["Frames"] = "Frames",
		--[[Translation missing --]]
		["mainchatonload_desc"] = "Automatically select the first chat frame and make it active on load.",
		--[[Translation missing --]]
		["mainchatonload_name"] = "Force Main Chat Frame On Load",
		--[[Translation missing --]]
		["maxchatheight_desc"] = "Sets the maximum height for all chat windows.",
		--[[Translation missing --]]
		["maxchatheight_name"] = "Set Maximum Height",
		--[[Translation missing --]]
		["maxchatwidth_desc"] = "Sets the maximum width for all chat windows.",
		--[[Translation missing --]]
		["maxchatwidth_name"] = "Set Maximum Width",
		--[[Translation missing --]]
		["minchatheight_desc"] = "Sets the minimum height for all chat windows.",
		--[[Translation missing --]]
		["minchatheight_name"] = "Set Minimum Height",
		--[[Translation missing --]]
		["minchatwidth_desc"] = "Sets the minimum width for all chat windows.",
		--[[Translation missing --]]
		["minchatwidth_name"] = "Set Minimum Width",
		--[[Translation missing --]]
		["rememberframepositions_desc"] = "Remember the chatframe positions, and restore them on load",
		--[[Translation missing --]]
		["rememberframepositions_name"] = "Remember Positions",
		--[[Translation missing --]]
		["removeclamp_desc"] = "Allow the chatframe to be moved flush with the edge of the screen",
		--[[Translation missing --]]
		["removeclamp_name"] = "Zero Clamp Size",
	}
}

PL:AddLocale(PRAT_MODULE, "ptBR", L)

L = {
	["Frames"] = {
		["Chat window frame parameter options"] = "Options de la fenêtre de discussion",
		--[[Translation missing --]]
		["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
		--[[Translation missing --]]
		["defaultframealpha_name"] = "Default alpha on mouseover",
		["framealpha_desc"] = "Définit la transparence de la fenêtre de discussion quand la souris passe par dessus.",
		["framealpha_name"] = "Transparence",
		--[[Translation missing --]]
		["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
		--[[Translation missing --]]
		["framealphastatic_name"] = "Static Chatframe Alpha",
		["Frames"] = "Fenêtre",
		["mainchatonload_desc"] = "Sélectionne automatiquement la première fenêtre de discussion et la rend active lors du chargement.",
		--[[Translation missing --]]
		["mainchatonload_name"] = "Force Main Chat Frame On Load",
		["maxchatheight_desc"] = "Définit la hauteur maximale pour toutes les fenêtres de discussion.",
		["maxchatheight_name"] = "Hauteur maximale",
		["maxchatwidth_desc"] = "Définit la largeur maximale pour toutes les fenêtres de discussion.",
		["maxchatwidth_name"] = "Largeur maximale",
		["minchatheight_desc"] = "Définit la hauteur minimum pour toutes les fenêtres de discussion.",
		["minchatheight_name"] = "Hauteur minimum",
		["minchatwidth_desc"] = "Définit la largeur minimum pour toutes les fenêtres de discussion.",
		["minchatwidth_name"] = "Largeur minimum",
		--[[Translation missing --]]
		["rememberframepositions_desc"] = "Remember the chatframe positions, and restore them on load",
		--[[Translation missing --]]
		["rememberframepositions_name"] = "Remember Positions",
		--[[Translation missing --]]
		["removeclamp_desc"] = "Allow the chatframe to be moved flush with the edge of the screen",
		--[[Translation missing --]]
		["removeclamp_name"] = "Zero Clamp Size",
	}
}

PL:AddLocale(PRAT_MODULE, "frFR", L)

L = {
	["Frames"] = {
		["Chat window frame parameter options"] = "Optionen für Parameter des Chatfenster-Rahmens",
		["defaultframealpha_desc"] = "Legt die minimale Transparenz für den Chat fest, wenn du mit der Maus darüber fährst und die statische Chatfrahmen-Transparenzeinstellung deaktiviert ist UND die Standard Transparenz größer ist als die benutzerdefinierte Transparenz, die für das Chatfenster festgelegt ist.",
		["defaultframealpha_name"] = "Standard Transparenz beim darüber fahren mit der Maus",
		["framealpha_desc"] = "Steuert die Transparenz des Chatfensters, wenn du die Maus darüberlegst.",
		["framealpha_name"] = "Transparenz für Chatfenster einstellen",
		["framealphastatic_desc"] = "Stelle die Transparenz des Chatrahmens so ein, dass sie immer der konfigurierten Transparenz entspricht",
		["framealphastatic_name"] = "Statische Chatrahmen Transparenz",
		["Frames"] = "Fenster",
		["mainchatonload_desc"] = "Automatisch das erste Chatfenster auswählen und beim Laden aktivieren.",
		["mainchatonload_name"] = "Haupt-Chatfenster beim Laden erzwingen",
		["maxchatheight_desc"] = "Die maximale Höhe für alle Chatfenster einstellen.",
		["maxchatheight_name"] = "Maximale Höhe einstellen",
		["maxchatwidth_desc"] = "Die maximale Breite für alle Chatfenster einstellen.",
		["maxchatwidth_name"] = "Maximale Breite einstellen",
		["minchatheight_desc"] = "Die minimale Höhe für alle Chatfenster einstellen.",
		["minchatheight_name"] = "Minimale Höhe einstellen",
		["minchatwidth_desc"] = "Die minimale Breite für alle Chatfenster einstellen.",
		["minchatwidth_name"] = "Minimale Breite einstellen",
		["rememberframepositions_desc"] = "Merkt sich die Chatrahmen Positionen und stellt sie beim Laden wieder her",
		["rememberframepositions_name"] = "Positionen merken",
		["removeclamp_desc"] = "Das Verschieben des Chatfensters bündig zur Bildschirmkante zulassen",
		["removeclamp_name"] = "Klammergröße Null",
	}
}

PL:AddLocale(PRAT_MODULE, "deDE", L)

L = {
	["Frames"] = {
		["Chat window frame parameter options"] = "대화창 프레임 한도 옵션",
		--[[Translation missing --]]
		["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
		--[[Translation missing --]]
		["defaultframealpha_name"] = "Default alpha on mouseover",
		["framealpha_desc"] = "마우스를 올렸을 때 대화창의 투명도를 조절합니다.",
		["framealpha_name"] = "대화창 투명도 설정",
		--[[Translation missing --]]
		["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
		--[[Translation missing --]]
		["framealphastatic_name"] = "Static Chatframe Alpha",
		["Frames"] = "대화창 [Frames]",
		["mainchatonload_desc"] = "첫번째 대화창을 자동으로 선택하고 로드 시에 활성화 시킵니다.",
		["mainchatonload_name"] = "로드 시 주 대화창 강제 설정",
		["maxchatheight_desc"] = "모든 대화창의 최대 높이를 설정합니다.",
		["maxchatheight_name"] = "최대 높이 설정",
		["maxchatwidth_desc"] = "모든 대화창의 최대 너비를 설정합니다.",
		["maxchatwidth_name"] = "최대 너비 설정",
		["minchatheight_desc"] = "모든 대화창의 최소 높이를 설정합니다.",
		["minchatheight_name"] = "최소 높이 설정",
		["minchatwidth_desc"] = "모든 대화창의 최소 너비를 설정합니다.",
		["minchatwidth_name"] = "최소 너비 설정",
		["rememberframepositions_desc"] = "대화창 위치를 기억하고 로드 시마다 불러옵니다",
		["rememberframepositions_name"] = "위치 기억",
		["removeclamp_desc"] = "대화창이 화면 밖으로 나가지 않도록 방지합니다.",
		["removeclamp_name"] = "Zero 고정 크기",
	}
}

PL:AddLocale(PRAT_MODULE, "koKR", L)

L = {
	["Frames"] = {
		--[[Translation missing --]]
		["Chat window frame parameter options"] = "Chat window frame parameter options",
		--[[Translation missing --]]
		["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
		--[[Translation missing --]]
		["defaultframealpha_name"] = "Default alpha on mouseover",
		--[[Translation missing --]]
		["framealpha_desc"] = "Conrols the transparency of the chatframe when you hover over it with your mouse.",
		--[[Translation missing --]]
		["framealpha_name"] = "Set Chatframe Alpha",
		--[[Translation missing --]]
		["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
		--[[Translation missing --]]
		["framealphastatic_name"] = "Static Chatframe Alpha",
		--[[Translation missing --]]
		["Frames"] = "Frames",
		--[[Translation missing --]]
		["mainchatonload_desc"] = "Automatically select the first chat frame and make it active on load.",
		--[[Translation missing --]]
		["mainchatonload_name"] = "Force Main Chat Frame On Load",
		--[[Translation missing --]]
		["maxchatheight_desc"] = "Sets the maximum height for all chat windows.",
		--[[Translation missing --]]
		["maxchatheight_name"] = "Set Maximum Height",
		--[[Translation missing --]]
		["maxchatwidth_desc"] = "Sets the maximum width for all chat windows.",
		--[[Translation missing --]]
		["maxchatwidth_name"] = "Set Maximum Width",
		--[[Translation missing --]]
		["minchatheight_desc"] = "Sets the minimum height for all chat windows.",
		--[[Translation missing --]]
		["minchatheight_name"] = "Set Minimum Height",
		--[[Translation missing --]]
		["minchatwidth_desc"] = "Sets the minimum width for all chat windows.",
		--[[Translation missing --]]
		["minchatwidth_name"] = "Set Minimum Width",
		--[[Translation missing --]]
		["rememberframepositions_desc"] = "Remember the chatframe positions, and restore them on load",
		--[[Translation missing --]]
		["rememberframepositions_name"] = "Remember Positions",
		--[[Translation missing --]]
		["removeclamp_desc"] = "Allow the chatframe to be moved flush with the edge of the screen",
		--[[Translation missing --]]
		["removeclamp_name"] = "Zero Clamp Size",
	}
}

PL:AddLocale(PRAT_MODULE, "esMX", L)

L = {
	["Frames"] = {
		["Chat window frame parameter options"] = "Параметры окна чата",
		--[[Translation missing --]]
		["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
		--[[Translation missing --]]
		["defaultframealpha_name"] = "Default alpha on mouseover",
		["framealpha_desc"] = "Настройка прозрачности окна чата при наведении на него курсора мыши.",
		["framealpha_name"] = "Прозрачность окна чата",
		--[[Translation missing --]]
		["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
		--[[Translation missing --]]
		["framealphastatic_name"] = "Static Chatframe Alpha",
		["Frames"] = "Фреймы",
		["mainchatonload_desc"] = "Автоматически выбирает первое окно чата, и делает его активным при загрузке.",
		["mainchatonload_name"] = "Задействовать главное окно чата при загрузке",
		["maxchatheight_desc"] = "Устанавливает максимальную высоту для всех окон чата.",
		["maxchatheight_name"] = "Максимальная высоты",
		["maxchatwidth_desc"] = "Устанавливает максимальную ширину для всех окон чата.",
		["maxchatwidth_name"] = "Максимальная ширина",
		["minchatheight_desc"] = "Устанавливает минимальную высоту для всех окон чата.",
		["minchatheight_name"] = "Минимальная высоты",
		["minchatwidth_desc"] = "Устанавливает минимальную ширину для всех окон чата.",
		["minchatwidth_name"] = "Минимальная ширина",
		["rememberframepositions_desc"] = "Запомнить положение окна чата и восстановить при загрузке",
		["rememberframepositions_name"] = "Запомнить положение",
		["removeclamp_desc"] = "Позволить окну чата прижиматься вплотную к краю экрана",
		["removeclamp_name"] = "Вплотную к краю экрана",
	}
}

PL:AddLocale(PRAT_MODULE, "ruRU", L)

L = {
	["Frames"] = {
		["Chat window frame parameter options"] = "聊天窗口参数选项",
		--[[Translation missing --]]
		["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
		--[[Translation missing --]]
		["defaultframealpha_name"] = "Default alpha on mouseover",
		["framealpha_desc"] = "控制鼠标移过时聊天框架的透明度.",
		["framealpha_name"] = "设定聊天框架透明度",
		--[[Translation missing --]]
		["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
		--[[Translation missing --]]
		["framealphastatic_name"] = "Static Chatframe Alpha",
		["Frames"] = "框架",
		["mainchatonload_desc"] = "加载时自动选择并激活第1个聊天框架.",
		["mainchatonload_name"] = "加载时焦点于主聊天框架.",
		["maxchatheight_desc"] = "设定所有聊天窗口的最大高度.",
		["maxchatheight_name"] = "设定最大高度",
		["maxchatwidth_desc"] = "设定所有聊天窗口的最大宽度.",
		["maxchatwidth_name"] = "设定最大宽度",
		["minchatheight_desc"] = "设定所有聊天窗口的最小高度.",
		["minchatheight_name"] = "设定最小高度.",
		["minchatwidth_desc"] = "设定所有聊天窗口的最小宽度.",
		["minchatwidth_name"] = "设定最小宽度.",
		["rememberframepositions_desc"] = "记住聊天框的位置,在加载时恢复.",
		["rememberframepositions_name"] = "记住位置",
		["removeclamp_desc"] = "允许聊天框架移动至屏幕边缘齐平",
		["removeclamp_name"] = "零距离边缘固定",
	}
}

PL:AddLocale(PRAT_MODULE, "zhCN", L)

L = {
	["Frames"] = {
		--[[Translation missing --]]
		["Chat window frame parameter options"] = "Chat window frame parameter options",
		--[[Translation missing --]]
		["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
		--[[Translation missing --]]
		["defaultframealpha_name"] = "Default alpha on mouseover",
		--[[Translation missing --]]
		["framealpha_desc"] = "Conrols the transparency of the chatframe when you hover over it with your mouse.",
		--[[Translation missing --]]
		["framealpha_name"] = "Set Chatframe Alpha",
		--[[Translation missing --]]
		["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
		--[[Translation missing --]]
		["framealphastatic_name"] = "Static Chatframe Alpha",
		--[[Translation missing --]]
		["Frames"] = "Frames",
		--[[Translation missing --]]
		["mainchatonload_desc"] = "Automatically select the first chat frame and make it active on load.",
		--[[Translation missing --]]
		["mainchatonload_name"] = "Force Main Chat Frame On Load",
		--[[Translation missing --]]
		["maxchatheight_desc"] = "Sets the maximum height for all chat windows.",
		--[[Translation missing --]]
		["maxchatheight_name"] = "Set Maximum Height",
		--[[Translation missing --]]
		["maxchatwidth_desc"] = "Sets the maximum width for all chat windows.",
		--[[Translation missing --]]
		["maxchatwidth_name"] = "Set Maximum Width",
		--[[Translation missing --]]
		["minchatheight_desc"] = "Sets the minimum height for all chat windows.",
		--[[Translation missing --]]
		["minchatheight_name"] = "Set Minimum Height",
		--[[Translation missing --]]
		["minchatwidth_desc"] = "Sets the minimum width for all chat windows.",
		["minchatwidth_name"] = "Establecer ancho mínimo",
		--[[Translation missing --]]
		["rememberframepositions_desc"] = "Remember the chatframe positions, and restore them on load",
		--[[Translation missing --]]
		["rememberframepositions_name"] = "Remember Positions",
		--[[Translation missing --]]
		["removeclamp_desc"] = "Allow the chatframe to be moved flush with the edge of the screen",
		--[[Translation missing --]]
		["removeclamp_name"] = "Zero Clamp Size",
	}
}

PL:AddLocale(PRAT_MODULE, "esES",  L)

L = {
	["Frames"] = {
		["Chat window frame parameter options"] = "聊天視窗框架參數選項",
		--[[Translation missing --]]
		["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
		--[[Translation missing --]]
		["defaultframealpha_name"] = "Default alpha on mouseover",
		--[[Translation missing --]]
		["framealpha_desc"] = "Conrols the transparency of the chatframe when you hover over it with your mouse.",
		["framealpha_name"] = "設定聊天欄透明度",
		--[[Translation missing --]]
		["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
		--[[Translation missing --]]
		["framealphastatic_name"] = "Static Chatframe Alpha",
		["Frames"] = "框架",
		--[[Translation missing --]]
		["mainchatonload_desc"] = "Automatically select the first chat frame and make it active on load.",
		["mainchatonload_name"] = "強制主聊天框在載入",
		["maxchatheight_desc"] = "設定最大高度全部聊天視窗。",
		["maxchatheight_name"] = "設定最大高度",
		["maxchatwidth_desc"] = "設定最大寬度全部聊天視窗。",
		["maxchatwidth_name"] = "設定最大寬度",
		["minchatheight_desc"] = "設定對話視窗最小高度",
		["minchatheight_name"] = "設定最小高度",
		["minchatwidth_desc"] = "設定對話視窗最小寬度",
		["minchatwidth_name"] = "設定最小寬度",
		--[[Translation missing --]]
		["rememberframepositions_desc"] = "Remember the chatframe positions, and restore them on load",
		--[[Translation missing --]]
		["rememberframepositions_name"] = "Remember Positions",
		--[[Translation missing --]]
		["removeclamp_desc"] = "Allow the chatframe to be moved flush with the edge of the screen",
		--[[Translation missing --]]
		["removeclamp_name"] = "Zero Clamp Size",
	}
}

PL:AddLocale(PRAT_MODULE, "zhTW", L)
end
--@end-non-debug@



  -- We have to set the insets here before blizzard has a chance to move them
  for i = 1, NUM_CHAT_WINDOWS do
    local f = _G["ChatFrame" .. i]
    f:SetClampRectInsets(0, 0, 0, 0)
  end


  Prat:SetModuleDefaults(mod.name, {
    profile = {
      on = true,
      minchatwidth = 160,
      minchatwidthdefault = 160,
      maxchatwidth = 800,
      maxchatwidthdefault = 800,
      minchatheight = 120,
      minchatheightdefault = 120,
      maxchatheight = 600,
      maxchatheightdefault = 600,
      mainchatonload = true,
      removeclamp = true,
      framealphastatic = false,
      defaultframealpha = 0.25,
      framemetrics = {
        ['*'] = {
          width = 430,
          height = 120,
        }
      }
    }
  })

  do
    local frameoption = {
      name = function(info) return PL[info[#info] .. "_name"] end,
      desc = function(info) return PL[info[#info] .. "_desc"] end,
      type = "range",
      min = 25,
      max = 1024,
      step = 1
    }

    Prat:SetModuleOptions(mod.name, {
      name = PL["Frames"],
      desc = PL["Chat window frame parameter options"],
      type = "group",
      args = {
        minchatwidth = frameoption,
        maxchatwidth = frameoption,
        minchatheight = frameoption,
        maxchatheight = frameoption,
        removeclamp = {
          type = "toggle",
          order = 110,
          name = PL["removeclamp_name"],
          desc = PL["removeclamp_desc"],
        },
        framealphastatic = {
          type = "toggle",
          order = 130,
          name = PL.framealphastatic_name,
          desc = PL.framealphastatic_desc,
        },
        defaultframealpha = {
          name = PL["defaultframealpha_name"],
          desc = PL["defaultframealpha_desc"],
          type = "range",
          order = 140,
          min = 0.0,
          max = 1,
          step = 0.01,
        },
      }
    })
  end


  --[[------------------------------------------------
      Module Event Functions
  ------------------------------------------------]] --

  Prat:SetModuleInit(mod, function(self) mod:GetDefaults() end)

  function mod:OnModuleEnable()
    CHAT_FRAME_BUTTON_FRAME_MIN_ALPHA = 0
    self:ConfigureAllChatFrames(true)
    self:SecureHook("FCF_DockFrame")
    self:SecureHook("FCF_UnDockFrame")
    self:SecureHook("FloatingChatFrame_UpdateBackgroundAnchors")

    self:SecureHook("FCF_SetWindowAlpha")
    self:SecureHook("FCF_SetWindowColor")

    if not Prat.IsClassic then
      local prevClamp = ChatFrame1.SetClampRectInsets
      self:SecureHook(ChatFrame1, "SetClampRectInsets", function(frame, ...)
        if self.db.profile.on and self.db.profile.removeclamp then
          prevClamp(frame, 0, 0, 0, 0)
        end
      end)
    end
  end


  function mod:OnModuleDisable()
    CHAT_FRAME_BUTTON_FRAME_MIN_ALPHA = 0.2
    self:ConfigureAllChatFrames(false)
  end

  function mod:GetDescription()
    return PL["Chat window frame parameter options"]
  end


  function mod:FloatingChatFrame_UpdateBackgroundAnchors(frame)
    if self.db.profile.removeclamp then
      frame:SetClampRectInsets(0, 0, 0, 0)
    end
    Prat.Frames[frame:GetName()] = frame
    local m = Prat.Addon:GetModule("Font", true)
    if m then m:ConfigureAllChatFrames() end
  end
  function mod:FCF_DockFrame(frame, ...)
    if self.db.profile.removeclamp then
      frame:SetClampRectInsets(0, 0, 0, 0)
    end
    Prat.Frames[frame:GetName()] = frame
    local m = Prat.Addon:GetModule("Font", true)
    if m then m:ConfigureAllChatFrames() end
  end

  function mod:FCF_UnDockFrame(frame, ...)
    if self.db.profile.removeclamp then
      frame:SetClampRectInsets(0, 0, 0, 0)
    end
    Prat.Frames[frame:GetName()] = frame
    local m = Prat.Addon:GetModule("Font", true)
    if m then m:ConfigureAllChatFrames() end
  end

  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --

  -- make ChatFrame1 the selected chat frame
  function mod:AceEvent_FullyInitialized()
    if self.db.profile.mainchatonload then
      FCF_SelectDockFrame(ChatFrame1)
    end
  end

  -- set parameters for each chatframe
  function mod:ConfigureAllChatFrames(enabled)
    for _, v in pairs(Prat.Frames) do
      self:SetParameters(v, enabled)
    end
  end


  function mod:RecreateBackgroundTextures(frame)
    if frame.PratTextures then
      return
    end
    frame.PratTextures = {}
    for _, name in ipairs(CHAT_FRAME_TEXTURES) do
      local texture = _G[frame:GetName() .. name]
      local layer, sublevel = texture:GetDrawLayer()

      local newTexture = texture:GetParent():CreateTexture(nil, layer, nil, sublevel)
      for i = 1, texture:GetNumPoints() do
        newTexture:SetPoint(texture:GetPoint(i))
      end

      newTexture:SetTexture(texture:GetTexture())
      newTexture:SetTexCoord(texture:GetTexCoord())

      newTexture:SetSize(texture:GetSize())

      table.insert(frame.PratTextures, newTexture)
      texture:Hide()
    end
  end

  function mod:HidePratTextures(frame)
    if frame.PratTextures then
      for _, name in ipairs(CHAT_FRAME_TEXTURES) do
        local texture = _G[frame:GetName() .. name]
        texture:Show()
      end
      for _, texture in ipairs(frame.PratTextures) do
        texture:Hide()
      end
    end
  end

  function mod:RestorePratTextures(frame)
    if not frame.PratTextures then
      self:RecreateBackgroundTextures(frame)
    end

    for _, name in ipairs(CHAT_FRAME_TEXTURES) do
      local texture = _G[frame:GetName() .. name]
      texture:Hide()
    end
    local _, _, r, g, b, a = FCF_GetChatWindowInfo(frame:GetID())
    for _, texture in ipairs(frame.PratTextures) do
      texture:Show()
      texture:SetVertexColor(r, g, b)
      texture:SetAlpha(a)
    end
  end

  -- get the defaults for chat frame1 max/min width/height for use when disabling the module
  function mod:GetDefaults()
    local cf = _G["ChatFrame1"]
    local prof = self.db.profile

    local minwidthdefault, minheightdefault, maxwidthdefault, maxheightdefault
    if cf.GetResizeBounds then
      minwidthdefault, minheightdefault, maxwidthdefault, maxheightdefault = cf:GetResizeBounds()
    else
      minwidthdefault, minheightdefault = cf:GetMinResize()
      maxwidthdefault, maxheightdefault = cf:GetMaxResize()
    end

    prof.minchatwidthdefault = minwidthdefault
    prof.maxchatwidthdefault = maxwidthdefault
    prof.minchatheightdefault = minheightdefault
    prof.maxchatheightdefault = maxheightdefault

    prof.initialized = true
  end

  function mod:FCF_SetWindowColor(frame, r, g, b)
    if frame.PratTextures then
      for _, texture in ipairs(frame.PratTextures) do
        texture:SetVertexColor(r, g, b)
      end
    end
  end

  function mod:FCF_SetWindowAlpha(frame, a)
    local _, _, r, g, b, a = FCF_GetChatWindowInfo(frame:GetID())
    if frame.PratTextures then
      for _, texture in ipairs(frame.PratTextures) do
        texture:SetAlpha(a)
      end
    end
  end
  -- set the max/min width/height for a chatframe
  function mod:SetParameters(cf, enabled)
    local prof = self.db.profile

    local minWidth, minHeight, maxWidth, maxHeight
    if enabled then
      if prof.framealphastatic then
        self:RestorePratTextures(cf)
      else
        self:HidePratTextures(cf)
      end

      DEFAULT_CHATFRAME_ALPHA = prof.defaultframealpha

      minWidth, minHeight = prof.minchatwidth, prof.minchatheight
      maxWidth, maxHeight = prof.maxchatwidth, prof.maxchatheight

      if prof.removeclamp then
        if not Prat.IsClassic then
          cf:SetClampedToScreen(false)
        end
        cf:SetClampRectInsets(0, 0, 0, 0)
        if not Prat.IsClassic then
          EventRegistry:RegisterCallback("EditMode.Enter", function()
            cf:SetClampedToScreen(true)
            EventRegistry:UnregisterCallback("EditMode.Enter", cf)
          end, cf)
        end
      end

      if not Prat.IsClassic then
        cf.ScrollBar:SetAlpha(0)
      end
    else
      self:HidePratTextures(cf)
      DEFAULT_CHATFRAME_ALPHA = 0.25

      minWidth, minHeight = prof.minchatwidthdefault, prof.minchatheightdefault
      maxWidth, maxHeight = prof.maxchatwidthdefault, prof.maxchatheightdefault
    end

    if cf.SetResizeBounds then
      cf:SetResizeBounds(minWidth, minHeight, maxWidth, maxHeight)
    else
      cf:SetMinResize(minWidth, minHeight)
      cf:SetMaxResize(maxWidth, maxHeight)
    end
  end


  function mod:OnValueChanged()
    self:ConfigureAllChatFrames(true)
  end

  -- Frame position saving feature credit to Chatter

  function mod:SetChatWindowSavedPosition(id, point, xOffset, yOffset)
    local data = self.db.profile.framemetrics[id]
    data.point, data.xOffset, data.yOffset = point, xOffset, yOffset
  end

  function mod:GetChatWindowSavedPosition(id)
    local data = self.db.profile.framemetrics[id]
    if not data.point then
      data.point, data.xOffset, data.yOffset = self.hooks.GetChatWindowSavedPosition(id)
    end
    return data.point, data.xOffset, data.yOffset
  end

  function mod:SetChatWindowSavedDimensions(id, width, height)
    local data = self.db.profile.framemetrics[id]
    data.width, data.height = width, height
  end

  function mod:GetChatWindowSavedDimensions(id)
    local data = self.db.profile.framemetrics[id]
    if not data.width then
      data.width, data.height = self.hooks.GetChatWindowSavedDimensions(id)
    end
    return data.width, data.height
  end



  return
end) -- Prat:AddModuleToLoad
