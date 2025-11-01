--[===[ File
This file contains the debug class used throughout Titan Panel and plugins.

This file is loaded first so NO other Titan routines are to be used.

The intent is a simple, flexible debug framework to enable:
- a consistent output
- enable / disable across an arbitrary scope - across addons; single addon; or partial addon
- enable / disable rather than comment out
--]===]

Titan_Debug = {}

local text_color = "1DA6C5" -- light blue
local head_color = "f2e699" -- yellow gold
local err_color = "ff2020"  -- red

local function Encode(color, text)
    -- Color the string using WoW encoding
    local res = ""
    local c = tostring(color)
    local t = tostring(text)
    if (c and t) then
        res = "|cff" .. c .. t .. "|r"
    else
        if (t) then
            res = tostring(t)
        else
            -- return blank string
        end
    end

    return res
end

---Simple debug to output plugin/Titan, the topic, and info
---@param who string
---@param topic string
---@param str string
function Titan_Debug.Out(who, topic, str)

    if Titan_Debug[who]
    and Titan_Debug[who][topic]
    and Titan_Debug[who][topic] == true
    then
        local msg = ""
            .. Encode(head_color,
                date("%H:%M:%S")
                .. " <" .. tostring(who) .. ""
                .. " : " .. tostring(topic) .. ">"
                )
            .. Encode(text_color,
                " " .. str .. ""
                )

        _G["DEFAULT_CHAT_FRAME"]:AddMessage(msg)
    else
        -- silently proceed
    end
end

-- For debug across Titan Panel
-- Keep two levels deep, to use .Out !!!
-- Titan_Debug.<plugin or 'titan'>.<debug topic>
--
Titan_Debug.titan = {}
Titan_Debug.titan.bars_setup = false
Titan_Debug.titan.events = false
Titan_Debug.titan.ldb_setup = false
Titan_Debug.titan.menu = false
Titan_Debug.titan.p_e_w = false  -- player entering world
Titan_Debug.titan.plugin_text = false
Titan_Debug.titan.plugin_register = false
Titan_Debug.titan.plugin_register_deep = false
Titan_Debug.titan.plugin_drag_drop = false
Titan_Debug.titan.profile = false
Titan_Debug.titan.movable = false
Titan_Debug.titan.startup = false
Titan_Debug.titan.tool_tips = false
