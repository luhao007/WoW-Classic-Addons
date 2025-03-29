local AB, _, T = OPie.ActionBook:compatible(2,14), ...
local ORI, EV, L = OPie.UI, T.Evie, T.L
assert(AB and ORI and EV and L and 1, 'Incompatible library bundle')

local COMPAT = select(4,GetBuildInfo())
local PRE_ELEVEN_TRACKING = COMPAT == 40400

if COMPAT > 3e4 then -- OPieTracking
	local function generateColor(c, n)
		local hue, v, s = (15+(c-1)*360/n) % 360, 1, 0.85
		local h, f = math.floor(hue/60) % 6, (hue/60) % 1
		local p, q, t = v - v*s, v - v*f*s, v - v*s + v*f*s

		if h == 0 then return v, t, p
		elseif h == 1 then return q, v, p
		elseif h == 2 then return p, v, t
		elseif h == 3 then return p, q, v
		elseif h == 4 then return t, p, v
		elseif h == 5 then return v, p, q
		end
	end
	
	local function GetTrackingInfo(...)
		if PRE_ELEVEN_TRACKING then
			return C_Minimap.GetTrackingInfo(...)
		end
		local ti = C_Minimap.GetTrackingInfo(...)
		if ti then
			return ti.name, ti.texture, ti.active, ti.type, ti.subType, ti.spellID
		end
	end
	
	local collectionData = {}
	local function setTracking(id)
		C_Minimap.SetTracking(id, not select(3, GetTrackingInfo(id)))
	end
	local function hint(k)
		local name, tex, on = GetTrackingInfo(k)
		return not not name, on and 1 or 0, tex, name, 0,0,0
	end
	local trackerActions = setmetatable({}, {__index=function(t, k)
		t[k] = AB:CreateActionSlot(hint, k, "func", setTracking, k)
		return t[k]
	end})
	local function preClick(selfId, _, updatedId)
		if selfId ~= updatedId then return end
		local n = C_Minimap.GetNumTrackingTypes()
		if n ~= #collectionData then
			for i=1,n do
				local token = "OPbTR" .. i
				collectionData[i], collectionData[token] = token, trackerActions[i]
				ORI:SetDisplayOptions(token, nil, nil, generateColor(i,n))
			end
			for i=n+1,#collectionData do
				collectionData[i], collectionData[collectionData[i] or i] = nil
			end
			AB:UpdateActionSlot(selfId, collectionData)
		end
	end
	local col = AB:CreateActionSlot(nil,nil, "collection", collectionData)
	OPie:SetRing("OPieTracking", col, {name=L"Minimap Tracking", hotkey="ALT-F"})
	AB:AddObserver("internal.collection.preopen", preClick, col)
	function EV.PLAYER_ENTERING_WORLD()
		return "remove", preClick(col, nil, col)
	end
end