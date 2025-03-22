-- An ItemSpec is the data representation for an item used by the sim.
-- It differs between sim versions and cannot have unexpected entries.
-- Using this data structure will make sure that only allowed keys are set
-- based on the client version it runs on.
--
-- To use: Create with CreateItemSpec() instead of manually creating a table.
-- It can be used like any normal table, but it will throw errors if setting invalid keys,
-- i.e. keys that are not defined in the respective protobufLayout that is chosen depending on the client version.
--
-- The helper functions ItemSpecMeta:FillFromItemLink(itemLink) and ItemSpecMeta:SetRuneSpellFromSlot(slotId, bagId)
-- should be all that is needed to setup an item.

local Env = select(2, ...)

-- Protobuf layouts. Strings are types for some weak type checking (on key creation only!)
local protobufLayout = {
    [WOW_PROJECT_CLASSIC] = {
        id = "number",            --"int"
        random_suffix = "number", --"int"
        enchant = "number",       --"int"
        rune = "number",          --"int"
    },
    [WOW_PROJECT_WRATH_CLASSIC] = {
        id = "number",      --"int"
        enchant = "number", --"int"
        gems = "table",     --"int[]"
    }
}

assert(protobufLayout[WOW_PROJECT_ID], "No ItemSpec structure defined for this client version!")

local ItemSpecMeta = { isItemSpec = true, _structure = protobufLayout[WOW_PROJECT_ID] }
ItemSpecMeta.__index = ItemSpecMeta

---Prevent adding keys not defined in the chosen layout or with wrong type.
---@param self table
---@param key any The key that is being added.
---@param value any The value that is being added.
function ItemSpecMeta.__newindex(self, key, value)
    assert(self._structure[key], "Tried adding an invalid key \"" .. key .. "\" to ItemSpec!")
    assert(value == nil or type(value) == self._structure[key],
        "Tried adding an invalid value type (" ..
        type(value) .. ") for key \"" .. key .. "\" to ItemSpec! Expected type: " .. self._structure[key])
    rawset(self, key, value)
end

---Fill values from an item link.
---@param itemLink string See https://wowpedia.fandom.com/wiki/ItemLink
function ItemSpecMeta:FillFromItemLink(itemLink)
    local _, itemId, enchantId, gemId1, gemId2, gemId3, gemId4, suffixId = strsplit(":", itemLink)

    self.id = tonumber(itemId)
    self.enchant = tonumber(enchantId)
    if self._structure.gems then
        self.gems = { tonumber(gemId1), tonumber(gemId2), tonumber(gemId3), tonumber(gemId4) }
    end
    if self._structure.random_suffix then
        self.random_suffix = tonumber(suffixId)
    end
end

---Set rune spell from an item in a slot, if item has a rune engraved.
---@param slotId integer
---@param bagId integer|nil If not nil check bag items instead of equipped items.
function ItemSpecMeta:SetRuneSpellFromSlot(slotId, bagId)
    if not self._structure.rune then return end
    self.rune = Env.GetEngravedRuneSpell(slotId, bagId)
end

---Create a new ItemSpec table.
local function CreateItemSpec()
    return setmetatable({}, ItemSpecMeta)
end

Env.CreateItemSpec = CreateItemSpec
