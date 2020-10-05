local _, T = ...

local AB = assert(T.ActionBook:compatible(2, 21), "A compatible version of ActionBook is required")
local EV, L = T.Evie, T.L

local LDB
local function checkLDB()
	LDB = LibStub and LibStub:GetLibrary("LibDataBroker-1.1", 1)
end

do -- action handler
	local nameMap = {}
	local function call(obj, btn)
		obj:OnClick(btn)
	end
	local function describeBroker(name)
		local obj = (LDB or checkLDB() or LDB) and LDB:GetDataObjectByName(name)
		return "Launcher", obj and obj.label or name, obj and obj.icon or "Interface/Icons/INV_Misc_QuestionMark", obj
	end
	local function brokerHint(obj)
		if not obj then return end
		return true, 0, obj.icon, obj.label or obj.text, 0,0,0, obj.OnTooltipShow, nil, obj
	end
	local function createBroker(name, rightClick)
		if type(name) ~= "string" or not (LDB or checkLDB() or LDB) then return end
		local pname = name .. "#" .. (rightClick and "R" or "L")
		if not nameMap[pname] then
			local obj = LDB:GetDataObjectByName(name)
			if not obj then return end
			nameMap[pname] = AB:CreateActionSlot(brokerHint, obj, "func", call, obj, rightClick and "RightButton" or "LeftButton")
		end
		return nameMap[pname]
	end
	AB:RegisterActionType("opie.databroker.launcher", createBroker, describeBroker, {"clickUsingRightButton"})
end
do -- category
	local waiting = true
	local function hasLaunchers()
		for _, o in LDB:DataObjectIterator() do
			if o.type == "launcher" then return true end
		end
	end
	local function onRegister()
		if waiting and hasLaunchers() then
			waiting = nil
			AB:AugmentCategory("DataBroker", function(_, add)
				for name, obj in LDB:DataObjectIterator() do
					if obj.type == "launcher" then
						add("opie.databroker.launcher", name)
					end
				end
			end)
		elseif not waiting then
			AB:NotifyObservers("opie.databroker.launcher")
		end
	end
	function EV.ADDON_LOADED()
		if LDB or checkLDB() or LDB then
			onRegister()
			if waiting then
				LDB.RegisterCallback("opie.databroker.launcher", "LibDataBroker_DataObjectCreated", onRegister)
			end
			return "remove"
		end
	end
end
T.ActionBook._CreateSimpleEditorPanel("opie.databroker.launcher", {"clickUsingRightButton", clickUsingRightButton=L"Simulate a right-click"})