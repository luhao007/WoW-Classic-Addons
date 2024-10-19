local core = BankStack
local Debug = core.Debug

local announce = core.announce

local sorted_bag_groups = {}
local function print_groups(groups)
	for group in pairs(groups) do
		table.insert(sorted_bag_groups, group)
	end
	table.sort(sorted_bag_groups)
	for _,group in ipairs(sorted_bag_groups) do
		announce(0, "-"..group..": "..string.join(", ", unpack(groups[group])), 1, 1, 1)
	end
	wipe(sorted_bag_groups)
end

local options = {
	name = "Config", desc = "Basic settings", type = "group", order = 10,
	get = function(info) return core.db[info[#info]] end,
	set = function(info, value) core.db[info[#info]] = value end,
	args = {
		verbosity = {
			name = "Verbosity", desc = "Talkativitinessism", type = "range", min = 0, max = 2, step = 1,
			descStyle = "inline",
		},
		junk = {
			name = "Junk", desc = "Move junk to the end", type = "select",
			descStyle = "inline",
			values = {
				[0] = "No",
				[1] = "End of your items",
				[2] = "Back of your bags",
			},
		},
		conjured = {
			name = "Conjured", desc = "Move conjured items to the end", type = "toggle",
			descStyle = "inline",
		},
		soulbound = {
			name = "Soulbound", desc = "Move soulbound items to the front", type = "toggle",
			descStyle = "inline",
		},
		reverse = {
			name = "Reverse", desc = "Reverse the sort", type = "toggle",
			descStyle = "inline",
		},
		backfill = {
			name = "Backfill", desc = "Fill starting at the back of your bags", type = "toggle",
			descStyle = "inline",
		},
	},
	plugins = {},
}
core.options = options

local bag_slot_pattern = "^(-?[%d]+)%s*(%d*)$"

local ignore_options = {
	name = "Ignore", desc = "Slots to ignore", type = "group", order = 20,
	args = {
		inherit = {
			name = "Inherit Blizzard",
			desc = "Respect the built-in \"ignore this bag\" checkboxes from the default UI",
			type = "toggle",
			get = function() return core.db.ignore_blizzard end,
			set = function(info, value) core.db.ignore_blizzard = value end,
		},
		list = {
			name = "List", desc = "List all ignored slots", type = "execute", order = 1,
			func = function()
				for ignored,_ in pairs(core.db.ignore_bags) do
					core.announce(0, "Ignoring bag: "..ignored, 1, 1, 1)
				end
				for ignored,_ in pairs(core.db.ignore) do
					local bag, slot = core.decode_bagslot(ignored)
					core.announce(0, "Ignoring: "..bag.." "..slot, 1, 1, 1)
				end
			end,
		},
		add = {
			name = "Add", desc = "Add an ignore", type = "input", order = 2,
			get = false,
			set = function(info, v)
				local bag, slot = v:match(bag_slot_pattern)
				bag = tonumber(bag)
				slot = tonumber(slot)
				if bag and slot then
					local bagslot = core.encode_bagslot(bag, slot)
					core.db.ignore[bagslot] = true
					core.announce(0, "bag:"..bag.." slot:"..slot.." ignored.", 1, 1, 1)
				elseif bag then
					core.db.ignore_bags[bag] = true
					core.announce(0, "bag:"..bag.." ignored.", 1, 1, 1)
				end
			end,
			usage = "[bag] [slot] (see http://wowwiki.com/BagID)",
			validate = function(info, v)
				-- "and true or false" because returning a string counts as false
				return v:match(bag_slot_pattern) and true or false
			end,
		},
		remove = {
			name = "Remove", desc = "Remove an ignore", type = "input", order = 3,
			get = false,
			set = function(info, v)
				local bag, slot = v:match(bag_slot_pattern)
				bag = tonumber(bag)
				slot = tonumber(slot)
				if bag and slot then
					local bagslot = core.encode_bagslot(bag, slot)
					core.db.ignore[bagslot] = nil
					announce(0, "bag:"..bag.." slot:"..slot.." no longer ignored.", 1, 1, 1)
				elseif bag then
					core.db.ignore_bags[bag] = nil
					announce(0, "bag:"..bag.." no longer ignored.", 1, 1, 1)
				end
			end,
			usage = "[bag] [slot] (see http://wowwiki.com/BagID)",
			validate = function(info, v)
				-- "and true or false" because returning a string counts as false
				return v:match(bag_slot_pattern) and true or false
			end,
		},
	},
}
local group_options = {
	name = "Groups", desc = "Bag groups", type = "group", order = 30,
	args = {
		list = {
			name = "List", desc = "List all groups", type = "execute", order = 1,
			func = function()
				announce(0, "Built in groups:", 1, 1, 1)
				print_groups(core.groups)
				announce(0, "Custom groups:", 1, 1, 1)
				print_groups(core.db.groups)
			end,
		},
		add = {
			name = "Add", desc = "Add a group (see http://wowwiki.com/BagID)", type = "input", order = 2,
			get = false,
			set = function(info, v)
				local group, action = string.match(v, "^([^%s]+) (.*)$")
				if not core.db.groups[group] then
					core.db.groups[group] = {}
				end
				local bags = wipe(core.db.groups[group])
				-- Populate with the new group:
				for maybe_bagid in string.gmatch(action, "[^%s,]+") do
					local bag = tonumber(maybe_bagid)
					if core.is_valid_bag(bag) or core.is_guild_bank_bag(bag) then
						table.insert(bags, bag)
					else
						announce(0, maybe_bagid.." was not a valid bag id.", 1, 0, 0)
					end
				end
				announce(0, "Added group: "..group.." ("..string.join(", ", unpack(bags))..")", 1, 1, 1)
			end,
			usage = "[name] [bagid],[bagid],[bagid]",
			validate = function(_, v) return string.match(v, "^[^%s]+ [-%d%s,]+$") and true or false end,
		},
		remove = {
			name = "Remove", desc = "Remove a group", type = "input", order = 3,
			get = false,
			set = function(info, v)
				core.db.groups[v] = nil
				announce(0, v .. " removed.", 1, 1, 1)
			end,
			usage = "[name]",
		}
	},
}

local help_options = {
	name = "BankStack Help", type="group",
	args = {
		header = { name = "BankStack: Things in your bags, they move", type = "header", order = 10, },
		commands = {
			type = "description", order = 20,
			name = "/bankstack -- this menu.\n"..
				"/sort -- rearrange your bags\n"..
				"/sort bank -- rearrange your bank\n"..
				"/stack -- fills stacks in your bank from your bags\n"..
				"/stack bank bags -- fills stacks in your bags from your bank\n"..
				"/compress -- merges stacks in your bags\n"..
				"/compress bank -- merges stacks in your bank\n"..
				"/fill -- fills empty slots in your bank from your bags",
		},
	},
}

local keybindings = {
	['BUTTON1'] = "Left Click",
	['ALT-BUTTON1'] = "Alt Left Click",
	['CTRL-BUTTON1'] = "Ctrl Left Click",
	['ALT-CTRL-BUTTON1'] = "Ctrl Alt Left Click",
	['SHIFT-BUTTON1'] = "Shift Left Click",
	['ALT-SHIFT-BUTTON1'] = "Alt Shift Left Click",
	['CTRL-SHIFT-BUTTON1'] = "Ctrl Shift Left Click",
	['ALT-CTRL-SHIFT-BUTTON1'] = "Ctrl Alt Shift Left Click",
}

local launcher_options = {
	name = "Click assignments", desc = "Modified left-clicks only",
	type = "group",
	get = function(info)
		local k = info[#info]
		for b, a in pairs(core.db.fubar_keybinds) do
			if a == k then
				return b
			end
		end
	end,
	set = function(info, v)
		-- clear current binding
		local k = info[#info]
		for b, a in pairs(core.db.fubar_keybinds) do
			if a == k then
				core.db.fubar_keybinds[b] = false
			end
		end
		-- set new binding
		if keybindings[v] then
			core.db.fubar_keybinds[v] = k
		end
	end,
	args = {
		help = {
			type = "description", order = 1,
			name = "BankStack contains a LibDataBroker-1.1 launcher, which can be shown by display addons such as "..
				"StatBlockCore, Fortress, ButtonBin, Broker2FuBar, and others, which can be used as a quick way to "..
				"sort your bags.",
		},

		sortbags = {name = "Sort Bags", desc = "Modified left-clicks only", type = "select", values = keybindings, order = 10,},
		sortbank = {name = "Sort Bank", desc = "Modified left-clicks only", type = "select", values = keybindings, order = 20,},
		stackbank = {name = "Stack to Bank", desc = "Modified left-clicks only", type = "select", values = keybindings, order = 30,},
		stackbags = {name = "Stack to Bags", desc = "Modified left-clicks only", type = "select", values = keybindings, order = 40,},
		compressbags = {name = "Compress Bags", desc = "Modified left-clicks only", type = "select", values = keybindings, order = 50,},
		compressbank = {name = "Compress Bank", desc = "Modified left-clicks only", type = "select", values = keybindings, order = 60,},
	},
}

local advanced_options = {
	name = "Advanced", desc = "Advanced settings", type = "group", order = 100,
	get = function(info) return core.db[info[#info]] end,
	set = function(info, value) core.db[info[#info]] = value end,
	args = {
		conservative_guild = {
			name = "Cautious guild",
			desc = "If this option is enabled, only one move at a time will be made. This is slower, but is nearly certain to work. If you turn this off, I make no promises.",
			descStyle = "inline",
			type = "toggle",
		},
		timing = {
			name = "Timing", inline = true, type = "group",
			args = {
				desc = {
					type = "description", order = 0,
					name = "How long to wait during sorting. If you run into problems with Blizzard throttling moves, especially in the guild bank, you can adjust these settings.",
				},
				stutter_duration = {
					name = "Stutter Interval", type = "range",
					desc = "How long to spend moving items before pausing to avoid the game noticably stuttering",
					min = 0, max = 1, step = 0.05,
					order = 10,
				},
				stutter_delay = {
					name = "Stutter Delay", type = "range",
					desc = "How long to wait after the stutter interval before starting to move items again",
					min = 0, max = 1, step = 0.05,
					order = 20,
				},
				processing_delay = {
					name = "Processing Delay", type = "range",
					desc = "How long to wait while a move operation is pending. Lower values might make sorting faster, but will use more CPU time.",
					min = 0, max = 1, step = 0.05,
					order = 30,
				},
				processing_delay_guild = {
					name = "Processing Delay (Guild)", type = "range",
					desc = "How long to wait while a move operation is pending if it involves the guild bank.",
					min = 0, max = 1, step = 0.05,
					order = 40,
				},
			},
		}
	},
}

core.setup_config = function()
	local acreg = LibStub("AceConfigRegistry-3.0")
	acreg:RegisterOptionsTable("BankStack", options)
	acreg:RegisterOptionsTable("BankStack Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(core.db_object))
	acreg:RegisterOptionsTable("BankStack Help", help_options)
	acreg:RegisterOptionsTable("BankStack Launcher", launcher_options)
	acreg:RegisterOptionsTable("BankStack Advanced", advanced_options)
	acreg:RegisterOptionsTable("BankStack Groups", group_options)
	acreg:RegisterOptionsTable("BankStack Ignore", ignore_options)

	local acdia = LibStub("AceConfigDialog-3.0")
	acdia:AddToBlizOptions("BankStack", "BankStack")
	acdia:AddToBlizOptions("BankStack Ignore", "Ignore", "BankStack")
	acdia:AddToBlizOptions("BankStack Groups", "Groups", "BankStack")
	acdia:AddToBlizOptions("BankStack Launcher", "Launcher", "BankStack")
	acdia:AddToBlizOptions("BankStack Advanced", "Advanced", "BankStack")
	acdia:AddToBlizOptions("BankStack Profiles", "Profiles", "BankStack")
	acdia:AddToBlizOptions("BankStack Help", "Help", "BankStack")
end

SLASH_BANKSTACKCONFIG1 = "/bankstack"
SlashCmdList["BANKSTACKCONFIG"] = function(arg)
	-- I'm not sure why the doubled-"BankStack" is necessary here...
	InterfaceOptionsFrame_OpenToCategory(LibStub("AceConfigDialog-3.0").BlizOptions.BankStack.BankStack.frame)
	--LibStub("AceConfigDialog-3.0"):Open("BankStack")
end
