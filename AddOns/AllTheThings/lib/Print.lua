-- Chat and Print functionality
local _, app = ...;

local print
	= print

app.print = function(...)
	print(app.L.SHORTTITLE, ...);
end
app.report = function(...)
	if ... then
		app.print(...);
	end
	app.print(app.Version..": "..app.L.PLEASE_REPORT_MESSAGE);
end
-- Consolidated debug-only print with preceding precise timestamp
local GetTimePreciseSec = GetTimePreciseSec;
local DEBUG_PRINT_LAST;
app.PrintDebug = function(...)
	DEBUG_PRINT_LAST = GetTimePreciseSec();
	if app.Debugging then print(DEBUG_PRINT_LAST,...) end
end
-- Consolidated debug-only print with precise frame duration since last successful print
app.PrintDebugPrior = function(...)
	if app.Debugging then
		local now = GetTimePreciseSec();
		if DEBUG_PRINT_LAST then
			local diff = now - DEBUG_PRINT_LAST;
			print(now,"<>",diff,"Stutter @", math.ceil(1 / diff), ...)
		else
			print(now,0,...)
		end
		DEBUG_PRINT_LAST = GetTimePreciseSec();
	end
end
app.PrintTable = function(t,depth)
	-- only allowing table prints when Debug print is active
	if not app.Debugging then return; end
	if t == nil then print("nil"); return; end
	if type(t) ~= "table" then print(type(t),t); return; end
	depth = depth or 0;
	if depth == 0 then app._PrintTable = {}; end
	local p = "";
	for i=1,depth,1 do
		p = p .. "-";
	end
	-- dont accidentally recursively print the same table
	if not app._PrintTable[t] then
		app._PrintTable[t] = true;
		print(p,tostring(t),"__type",t.__type," {");
		for k,v in pairs(t) do
			if type(v) == "table" then
				print(p,k,":");
				if k == "parent" or k == "sourceParent" then
					print("SKIPPED")
				elseif k == "g" then
					print("#",v and #v)
				else
					app.PrintTable(v,depth + 1);
				end
			else
				print(p,k,":",tostring(v))
			end
		end
		if getmetatable(t) then
			print(p,"__index:");
			app.PrintTable(getmetatable(t).__index, depth + 1);
		end
		print(p,"}");
	else
		print(p,tostring(t),"RECURSIVE");
	end
end