Prat:AddModuleToLoad(function()
  local PRAT_MODULE = Prat:RequestModuleName("Search")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE)

  local PL = module.PL

  --[===[@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    module_name = "Search",
    module_desc = "Adds the ability to search the chatframes.",
    module_info = "This module adds the /find commands to search the chat history\n\nUsage:\n\n /find <text>",
    err_tooshort = "Search term is too short",
    err_notfound = "Not Found",
    find_results = "Find Results:",
    bnet_removed = "<BNET REMOVED>",
  })
  --@end-debug@]===]

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/
  --@non-debug@
 do
     local L


L = {
	["Search"] = {
		["bnet_removed"] = "<BNET REMOVED>",
		["err_notfound"] = "Not Found",
		["err_tooshort"] = "Search term is too short",
		["find_results"] = "Find Results:",
		["module_desc"] = "Adds the ability to search the chatframes.",
		["module_info"] = [=[This module adds the /find commands to search the chat history

Usage:

 /find <text>]=],
		["module_name"] = "Search",
	}
}


   PL:AddLocale(PRAT_MODULE, "enUS",L)


L = {
	["Search"] = {
		--[[Translation missing --]]
		["bnet_removed"] = "<BNET REMOVED>",
		--[[Translation missing --]]
		["err_notfound"] = "Not Found",
		--[[Translation missing --]]
		["err_tooshort"] = "Search term is too short",
		["find_results"] = "Résultats trouvés :",
		--[[Translation missing --]]
		["module_desc"] = "Adds the ability to search the chatframes.",
		--[[Translation missing --]]
		["module_info"] = [=[This module adds the /find commands to search the chat history

Usage:

 /find <text>]=],
		--[[Translation missing --]]
		["module_name"] = "Search",
	}
}


   PL:AddLocale(PRAT_MODULE, "frFR",L)


L = {
	["Search"] = {
		--[[Translation missing --]]
		["bnet_removed"] = "<BNET REMOVED>",
		["err_notfound"] = "Nicht gefunden",
		["err_tooshort"] = "Suchbegriff ist zu kurz",
		["find_results"] = "Gefundene Ergebnisse:",
		["module_desc"] = [=[Aktiviert die Suchfunktion in Chatfenstern.

Suche]=],
		["module_info"] = [=[Aktiviert die Textbefehle /find und /findall, um die Chathistorie zu durchsuchen

Benutzung:

/find <text>

/findall <text>

Suche]=],
		["module_name"] = "Suche",
	}
}


   PL:AddLocale(PRAT_MODULE, "deDE",L)


L = {
	["Search"] = {
		--[[Translation missing --]]
		["bnet_removed"] = "<BNET REMOVED>",
		["err_notfound"] = "찾을 수 없음",
		["err_tooshort"] = "검색 구문이 너무 짧습니다",
		["find_results"] = "검색 결과:",
		["module_desc"] = "대화창 검색 기능을 추가합니다.",
		["module_info"] = [=[이 모듈은 대화 기록을 검색하는 /find 와 /findall 명령어를 추가합니다

사용법:

/find <문자열>

/findall <문자열>]=],
		["module_name"] = "검색",
	}
}


   PL:AddLocale(PRAT_MODULE, "koKR",L)


L = {
	["Search"] = {
		--[[Translation missing --]]
		["bnet_removed"] = "<BNET REMOVED>",
		--[[Translation missing --]]
		["err_notfound"] = "Not Found",
		--[[Translation missing --]]
		["err_tooshort"] = "Search term is too short",
		--[[Translation missing --]]
		["find_results"] = "Find Results:",
		--[[Translation missing --]]
		["module_desc"] = "Adds the ability to search the chatframes.",
		--[[Translation missing --]]
		["module_info"] = [=[This module adds the /find commands to search the chat history

Usage:

 /find <text>]=],
		--[[Translation missing --]]
		["module_name"] = "Search",
	}
}


   PL:AddLocale(PRAT_MODULE, "esMX",L)


L = {
	["Search"] = {
		--[[Translation missing --]]
		["bnet_removed"] = "<BNET REMOVED>",
		["err_notfound"] = "Не Найденно",
		["err_tooshort"] = "Критерий поиска слишком короток",
		["find_results"] = "Найти Результаты:",
		["module_desc"] = "Добавляет возможность поиска текста в чате.",
		["module_info"] = [=[Этот модуль добавляет команды /find и /findall для поиска в истории чата

Использование:

/find <текст>

/findall <текст>]=],
		["module_name"] = "Поиск",
	}
}


   PL:AddLocale(PRAT_MODULE, "ruRU",L)


L = {
	["Search"] = {
		--[[Translation missing --]]
		["bnet_removed"] = "<BNET REMOVED>",
		["err_notfound"] = "没找到",
		["err_tooshort"] = "搜索文字太短",
		["find_results"] = "查找结果：",
		["module_desc"] = "增加搜索聊天框的能力",
		["module_info"] = [=[此模块增加 /find 和 /findall 命令搜索聊天历史

用法:

 /find <文字>

 /findall <文字>]=],
		["module_name"] = "搜索",
	}
}


   PL:AddLocale(PRAT_MODULE, "zhCN",L)


L = {
	["Search"] = {
		--[[Translation missing --]]
		["bnet_removed"] = "<BNET REMOVED>",
		["err_notfound"] = "No encontrado",
		["err_tooshort"] = "Termino de búsqueda demasiado corto",
		--[[Translation missing --]]
		["find_results"] = "Find Results:",
		--[[Translation missing --]]
		["module_desc"] = "Adds the ability to search the chatframes.",
		--[[Translation missing --]]
		["module_info"] = [=[This module adds the /find commands to search the chat history

Usage:

 /find <text>]=],
		--[[Translation missing --]]
		["module_name"] = "Search",
	}
}


   PL:AddLocale(PRAT_MODULE, "esES",L)


L = {
	["Search"] = {
		--[[Translation missing --]]
		["bnet_removed"] = "<BNET REMOVED>",
		["err_notfound"] = "找不到",
		["err_tooshort"] = "尋找物品太短",
		["find_results"] = "找到結果:",
		--[[Translation missing --]]
		["module_desc"] = "Adds the ability to search the chatframes.",
		--[[Translation missing --]]
		["module_info"] = [=[This module adds the /find commands to search the chat history

Usage:

 /find <text>]=],
		["module_name"] = "尋找",
	}
}


   PL:AddLocale(PRAT_MODULE, "zhTW",L)

 end
 --@end-non-debug@




  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
    }
  })


  Prat:SetModuleOptions(module.name, {
    name = PL.module_name,
    desc = PL.module_desc,
    type = "group",
    args = {
      info = {
        name = PL.module_info,
        type = "description",
      }
    }
  })


  SLASH_FIND1 = "/find"
  SlashCmdList["FIND"] = function(msg) module:Find(msg, true) end

  local foundlines = {}
  local scrapelines = {}

  local function out(frame, msg)
    frame:AddMessage(msg)
  end

  function module:Find(word, all, frame)
    if not self.db.profile.on then
      return
    end

    if frame == nil then
      frame = SELECTED_CHAT_FRAME
    end

    if not word then return end

    if #word <= 1 then
      frame:ScrollToBottom()
      out(frame, PL.err_tooshort)
      return
    end

    if frame:GetNumMessages() == 0 then
      out(frame, PL.err_notfound)
      return
    end

    self.lastsearch = word

    self:ScrapeFrame(frame, nil, true)

    for _, v in ipairs(scrapelines) do
      if v.message and v.message:find(word) then
        if all then
          table.insert(foundlines, v)
        else
          return
        end
      end
    end

    self.lastsearch = nil

    frame:ScrollToBottom()

    if all and #foundlines > 0 then
      out(frame, PL.find_results)

      Prat.loading = true -- prevent double timestamp
      for _, v in ipairs(foundlines) do
        frame:AddMessage(v.message:gsub("|K.-|k", PL.bnet_removed), v.r, v.g, v.b)
      end
      Prat.loading = nil
    else
      out(frame, PL.err_notfound)
    end

    wipe(foundlines)
  end

  function module:ScrapeFrame(frame)
    wipe(scrapelines)

    for _, v in ipairs(frame.historyBuffer.elements) do
      if v.message then
        table.insert(scrapelines, v)
      end
    end
  end

  return
end) -- Prat:AddModuleToLoad