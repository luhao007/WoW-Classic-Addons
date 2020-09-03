local WP_TargetName
local WP_MouseoverName

local WP_ShowPrintOnClick = true
local _G = getfenv(0)


SLASH_WP_Commands1 = "/wcl"
SlashCmdList["WP_Commands"] = function(msg)
	print "WCLPlayerScore Version 1.6"
end

hooksecurefunc("ChatFrame_OnHyperlinkShow", function(chatFrame, link, text, button)
if (IsModifiedClick("CHATLINK")) then
  if (link and button) then

    local args = {};
    for v in string.gmatch(link, "[^:]+") do
      table.insert(args, v);
    end
		if (args[1] and args[1] == "player") then
			args[2] = Ambiguate(args[2], "short")
			WP_TargetName = args[2]
			if WP_ShowPrintOnClick == true then
				if WP_Database[WP_TargetName] and WP_Database[WP_TargetName] ~= "" then
					DEFAULT_CHAT_FRAME:AddMessage('WCL评分 ' .. WP_TargetName .. ': ' .. WP_Database[WP_TargetName], 255, 209, 0)
				end
			end
		end
	end
end
end)

hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)

	WP_TargetName = dropdownMenu.name

	if (UIDROPDOWNMENU_MENU_LEVEL > 1) then
	return
	end
	if WP_Database[WP_TargetName] and WP_Database[WP_TargetName] ~= "" then
		local info = UIDropDownMenu_CreateInfo()
		info.text = 'WCL评分: ' .. WP_Database[WP_TargetName]
		info.owner = which
		info.notCheckable = 1
		info.func = nil
		info.value = "WP_MenuButton"
		UIDropDownMenu_AddButton(info)
	end
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    local _, unit = self:GetUnit()

    if UnitExists(unit) then
		WP_MouseoverName = UnitName(unit)

		if WP_Database[WP_MouseoverName] and WP_Database[WP_MouseoverName] ~= "" then
			GameTooltip:AddLine("                          ")
			GameTooltip:AddLine("|cFFFFFF00WCL 评分 " .. WP_Database[WP_MouseoverName], 255, 209, 0)

			GameTooltip:Show()
		end
	end
end)

local Addon_EventFrame = CreateFrame("Frame")
Addon_EventFrame:RegisterEvent("ADDON_LOADED")
Addon_EventFrame:SetScript("OnEvent",
	function(self, event, addon)
		if addon == "WclPlayerScore" then
			WP_Database = WP_Database or {}
		end
end)


local Chat_EventFrame = CreateFrame("Frame")
Chat_EventFrame:RegisterEvent("CHAT_MSG_SYSTEM")
Chat_EventFrame:SetScript("OnEvent",
	function(self, event, message)
	local name

	name = Deformat(message, _G.WHO_LIST_FORMAT)
	if name then
		if WP_Database[name] and WP_Database[name] ~= "" then
			print("|cFFFFFF00WCL 评分 " .. name .. ":" .. WP_Database[name] )
		end
	end
end)


-- a dictionary of format to match entity
local FORMAT_SEQUENCES = {
    ["s"] = ".+",
    ["c"] = ".",
    ["%d*d"] = "%%-?%%d+",
    ["[fg]"] = "%%-?%%d+%%.?%%d*",
    ["%%%.%d[fg]"] = "%%-?%%d+%%.?%%d*",
}

-- a set of format sequences that are string-based, i.e. not numbers.
local STRING_BASED_SEQUENCES = {
    ["s"] = true,
    ["c"] = true,
}

local cache = setmetatable({}, {__mode='k'})
-- generate the deformat function for the pattern, or fetch from the cache.
local function get_deformat_function(pattern)
    local func = cache[pattern]
    if func then
        return func
    end

    -- escape the pattern, so that string.match can use it properly
    local unpattern = '^' .. pattern:gsub("([%(%)%.%*%+%-%[%]%?%^%$%%])", "%%%1") .. '$'

    -- a dictionary of index-to-boolean representing whether the index is a number rather than a string.
    local number_indexes = {}

    -- (if the pattern is a numbered format,) a dictionary of index-to-real index.
    local index_translation = nil

    -- the highest found index, also the number of indexes found.
	local highest_index
    if not pattern:find("%%1%$") then
        -- not a numbered format

        local i = 0
        while true do
            i = i + 1
            local first_index
            local first_sequence
            for sequence in pairs(FORMAT_SEQUENCES) do
                local index = unpattern:find("%%%%" .. sequence)
                if index and (not first_index or index < first_index) then
                    first_index = index
                    first_sequence = sequence
                end
            end
            if not first_index then
                break
            end
            unpattern = unpattern:gsub("%%%%" .. first_sequence, "(" .. FORMAT_SEQUENCES[first_sequence] .. ")", 1)
            number_indexes[i] = not STRING_BASED_SEQUENCES[first_sequence]
        end

        highest_index = i - 1
    else
        -- a numbered format

        local i = 0
		while true do
		    i = i + 1
			local found_sequence
            for sequence in pairs(FORMAT_SEQUENCES) do
				if unpattern:find("%%%%" .. i .. "%%%$" .. sequence) then
					found_sequence = sequence
					break
				end
			end
			if not found_sequence then
				break
			end
			unpattern = unpattern:gsub("%%%%" .. i .. "%%%$" .. found_sequence, "(" .. FORMAT_SEQUENCES[found_sequence] .. ")", 1)
			number_indexes[i] = not STRING_BASED_SEQUENCES[found_sequence]
		end
        highest_index = i - 1

		i = 0
		index_translation = {}
		pattern:gsub("%%(%d)%$", function(w)
		    i = i + 1
		    index_translation[i] = tonumber(w)
		end)
    end

    if highest_index == 0 then
        cache[pattern] = do_nothing
    else
        --[=[
            -- resultant function looks something like this:
            local unpattern = ...
            return function(text)
                local a1, a2 = text:match(unpattern)
                if not a1 then
                    return nil, nil
                end
                return a1+0, a2
            end

            -- or if it were a numbered pattern,
            local unpattern = ...
            return function(text)
                local a2, a1 = text:match(unpattern)
                if not a1 then
                    return nil, nil
                end
                return a1+0, a2
            end
        ]=]

        local t = {}
        t[#t+1] = [=[
            return function(text)
                local ]=]

        for i = 1, highest_index do
            if i ~= 1 then
                t[#t+1] = ", "
            end
            t[#t+1] = "a"
            if not index_translation then
                t[#t+1] = i
            else
                t[#t+1] = index_translation[i]
            end
        end

        t[#t+1] = [=[ = text:match(]=]
        t[#t+1] = ("%q"):format(unpattern)
        t[#t+1] = [=[)
                if not a1 then
                    return ]=]

        for i = 1, highest_index do
            if i ~= 1 then
                t[#t+1] = ", "
            end
            t[#t+1] = "nil"
        end

        t[#t+1] = "\n"
        t[#t+1] = [=[
                end
                ]=]

        t[#t+1] = "return "
        for i = 1, highest_index do
            if i ~= 1 then
                t[#t+1] = ", "
            end
            t[#t+1] = "a"
            t[#t+1] = i
            if number_indexes[i] then
                t[#t+1] = "+0"
            end
        end
        t[#t+1] = "\n"
        t[#t+1] = [=[
            end
        ]=]

        t = table.concat(t, "")

        -- print(t)

        cache[pattern] = assert(loadstring(t))()
    end

    return cache[pattern]
end

function Deformat(text, pattern)
    if type(text) ~= "string" then
        error(("Argument #1 to `Deformat' must be a string, got %s (%s)."):format(type(text), text), 2)
    elseif type(pattern) ~= "string" then
        error(("Argument #2 to `Deformat' must be a string, got %s (%s)."):format(type(pattern), pattern), 2)
    end

    return get_deformat_function(pattern)(text)
end


