--- LibTSMClass Library
-- Allows for OOP in lua through the implementation of classes. Many features of proper classes are supported including
-- inhertiance, polymorphism, and virtual methods.
-- @author TradeSkillMaster Team (admin@tradeskillmaster.com)
-- @license MIT
-- @module LibTSMClass

local Lib = {}
local private = { classInfo = {}, instInfo = {}, constructTbl = nil }
-- Set the keys as weak so that instances of classes can be GC'd (classes are never GC'd)
setmetatable(private.instInfo, { __mode = "k" })
local SPECIAL_PROPERTIES = {
	__init = true,
	__tostring = true,
	__dump = true,
	__class = true,
	__isa = true,
	__super = true,
	__name = true,
	__as = true,
}
local RESERVED_KEYS = {
	__super = true,
	__isa = true,
	__class = true,
	__name = true,
	__as = true,
}
local DEFAULT_INST_FIELDS = {
	__init = function(self)
		-- do nothing
	end,
	__tostring = function(self)
		return private.instInfo[self].str
	end,
	__dump = function(self)
		return private.InstDump(self)
	end,
}



-- ============================================================================
-- Public Library Functions
-- ============================================================================

function Lib.DefineClass(name, superclass, ...)
	if type(name) ~= "string" then
		error("Invalid class name: "..tostring(name), 2)
	end
	local abstract = false
	for i = 1, select('#', ...) do
		local modifier = select(i, ...)
		if modifier == "ABSTRACT" then
			abstract = true
		else
			error("Invalid modifier: "..tostring(modifier), 2)
		end
	end

	local class = setmetatable({}, private.CLASS_MT)
	private.classInfo[class] = {
		name = name,
		static = {},
		superStatic = {},
		superclass = superclass,
		abstract = abstract,
		isStaticReference = false,
	}
	while superclass do
		for key, value in pairs(private.classInfo[superclass].static) do
			if not private.classInfo[class].superStatic[key] then
				private.classInfo[class].superStatic[key] = { class = superclass, value = value }
			end
		end
		private.classInfo[superclass].subclassed = true
		superclass = superclass.__super
	end
	return class
end

function Lib.ConstructWithTable(tbl, class, ...)
	private.constructTbl = tbl
	local inst = class(...)
	assert(not private.constructTbl and inst == tbl, "Internal error!")
	return inst
end



-- ============================================================================
-- Instance Metatable
-- ============================================================================

private.INST_MT = {
	__newindex = function(self, key, value)
		if RESERVED_KEYS[key] then
			error("Can't set reserved key: "..tostring(key), 2)
		end
		if private.classInfo[self.__class].static[key] ~= nil then
			private.classInfo[self.__class].static[key] = value
		elseif not private.instInfo[self].hasSuperclass then
			-- we just set this directly on the instance table for better performance
			rawset(self, key, value)
		else
			private.instInfo[self].fields[key] = value
		end
	end,
	__index = function(self, key)
		-- This method is super optimized since it's used for every class instance access, meaning function calls and
		-- table lookup is kept to an absolute minimum, at the expense of readability and code reuse.
		local instInfo = private.instInfo[self]

		-- check if this key is an instance field first, since this is the most common case
		local res = instInfo.fields[key]
		if res ~= nil then
			instInfo.currentClass = nil
			return res
		end

		-- check if it's the special __super field or __as method
		if key == "__super" then
			if not instInfo.hasSuperclass then
				error("The class of this instance has no superclass.", 2)
			end
			-- The class of the current class method we are in, or nil if we're not in a class method.
			local methodClass = instInfo.methodClass
			-- We can only access the superclass within a class method and will use the class which defined that method
			-- as the base class to jump to the superclass of, regardless of what class the instance actually is.
			if not methodClass then
				error("The superclass can only be referenced within a class method.", 2)
			end
			return private.InstAs(self, private.classInfo[instInfo.currentClass or methodClass].superclass)
		elseif key == "__as" then
			return private.InstAs
		end

		-- reset the current class since we're not continuing the __super chain
		local class = instInfo.currentClass or instInfo.class
		instInfo.currentClass = nil

		-- check if this is a static key
		local classInfo = private.classInfo[class]
		res = classInfo.static[key]
		if res ~= nil then
			return res
		end

		-- check if it's a static field in the superclass
		local superStaticRes = classInfo.superStatic[key]
		if superStaticRes then
			res = superStaticRes.value
			return res
		end

		-- check if this field has a default value
		res = DEFAULT_INST_FIELDS[key]
		if res ~= nil then
			return res
		end

		return nil
	end,
	__tostring = function(self)
		return self:__tostring()
	end,
	__metatable = false,
}



-- ============================================================================
-- Class Metatable
-- ============================================================================

private.CLASS_MT = {
	__newindex = function(self, key, value)
		local classInfo = private.classInfo[self]
		if classInfo.subclassed then
			error("Can't modify classes after they are subclassed", 2)
		end
		if classInfo.static[key] then
			error("Can't modify or override static members", 2)
		end
		if RESERVED_KEYS[key] then
			error("Reserved word: "..tostring(key), 2)
		end
		local isMethod = type(value) == "function"
		if classInfo.isStaticReference then
			-- we are defining a static class function, not a class method
			assert(isMethod)
			classInfo.isStaticReference = false
			isMethod = false
		end
		if isMethod then
			-- We wrap class methods so that within them, the instance appears to be of the defining class
			classInfo.static[key] = function(inst, ...)
				local instInfo = private.instInfo[inst]
				if not instInfo.isClassLookup[self] then
					error(format("Attempt to call class method on non-object (%s)!", tostring(inst)), 2)
				end
				if not instInfo.hasSuperclass then
					-- don't need to worry about methodClass so just call the function directly
					return value(inst, ...)
				else
					local prevMethodClass = instInfo.methodClass
					instInfo.methodClass = self
					return private.InstMethodReturnHelper(prevMethodClass, instInfo, value(inst, ...))
				end
			end
		else
			classInfo.static[key] = value
		end
	end,
	__index = function(self, key)
		local classInfo = private.classInfo[self]
		assert(not classInfo.isStaticReference)
		-- check if it's the special __isa method which all classes implicitly have
		if key == "__isa" then
			return private.ClassIsA
		elseif key == "__name" then
			return classInfo.name
		elseif key == "__super" then
			return classInfo.superclass
		elseif key == "__static" then
			classInfo.isStaticReference = true
			return self
		elseif classInfo.static[key] ~= nil then
			return classInfo.static[key]
		end
		error(format("Invalid static class key (%s)", tostring(key)), 2)
	end,
	__tostring = function(self)
		return "class:"..private.classInfo[self].name
	end,
	__call = function(self, ...)
		if private.classInfo[self].abstract then
			error("Attempting to instantiate an abstract class!", 2)
		end
		-- Create a new instance of this class
		local inst = private.constructTbl or {}
		local instStr = strmatch(tostring(inst), "table:[^0-9a-fA-F]*([0-9a-fA-F]+)")
		setmetatable(inst, private.INST_MT)
		local hasSuperclass = private.classInfo[self].superclass and true or false
		private.instInfo[inst] = {
			class = self,
			fields = {
				__class = self,
				__isa = private.InstIsA,
			},
			str = private.classInfo[self].name..":"..instStr,
			isClassLookup = {},
			hasSuperclass = hasSuperclass,
			currentClass = nil,
		}
		if not hasSuperclass then
			-- set the static members directly on this object for better performance
			for key, value in pairs(private.classInfo[self].static) do
				if not SPECIAL_PROPERTIES[key] then
					rawset(inst, key, value)
				end
			end
		end
		local c = self
		while c do
			private.instInfo[inst].isClassLookup[c] = true
			c = private.classInfo[c].superclass
		end
		if private.constructTbl then
			-- re-set all the object attributes through the proper metamethod
			for k, v in pairs(inst) do
				rawset(inst, k, nil)
				inst[k] = v
			end
			private.constructTbl = nil
		end
		if select("#", inst:__init(...)) > 0 then
			error("__init must not return any values", 2)
		end
		return inst
	end,
	__metatable = false,
}



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.InstMethodReturnHelper(class, instInfo, ...)
	-- reset methodClass now that the function returned
	instInfo.methodClass = class
	return ...
end

function private.InstIsA(inst, targetClass)
	return private.instInfo[inst].isClassLookup[targetClass]
end

function private.InstAs(inst, targetClass)
	local instInfo = private.instInfo[inst]
	instInfo.currentClass = targetClass
	if not targetClass then
		error(format("Requested class does not exist!"), 2)
	elseif not instInfo.isClassLookup[targetClass] then
		error(format("Object is not an instance of the requested class (%s)!", tostring(targetClass)), 2)
	end
	-- For classes with no superclass, we don't go through the __index metamethod, so can't use __as
	if not instInfo.hasSuperclass then
		error("The class of this instance has no superclass.", 2)
	end
	-- We can only access the superclass within a class method.
	if not instInfo.methodClass then
		error("The superclass can only be referenced within a class method.", 2)
	end
	return inst
end

function private.ClassIsA(class, targetClass)
	while class do
		if class == targetClass then return true end
		class = class.__super
	end
end

function private.InstDump(inst)
	local instInfo = private.instInfo[inst]
	local tbl = instInfo.hasSuperclass and instInfo.fields or inst
	print(instInfo.str.." {")
	for key, value in pairs(tbl) do
		local valueStr = nil
		if type(value) == "table" then
			if private.classInfo[value] or private.instInfo[value] then
				-- this is a class or instance of a class
				valueStr = tostring(value)
			elseif next(value) then
				valueStr = "{ ... }"
			else
				valueStr = "{}"
			end
		elseif type(value) == "string" or type(value) == "number" or type(value) == "boolean" then
			valueStr = tostring(value)
		end
		if valueStr then
			print(format("  |cff88ccff%s|r=%s", tostring(key), valueStr))
		end
	end
	print("}")
end



-- ============================================================================
-- Initialization Code
-- ============================================================================

do
	-- register with LibStub
	local libStubTbl = LibStub:NewLibrary("LibTSMClass", 1)
	if libStubTbl then
		for k, v in pairs(Lib) do
			libStubTbl[k] = v
		end
	end

	-- register with TSM
	local addonName, addonTable = ...
	if addonName == "TradeSkillMaster" then
		local tsmModuleTbl = addonTable.Init("LibTSMClass")
		for k, v in pairs(Lib) do
			tsmModuleTbl[k] = v
		end
	end
end
