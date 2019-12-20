--[[
Copyright 2019 João Cardoso
MutexDelay is distributed under the terms of the GNU General Public License (Version 3).

As a special exception, the copyright holders of this library give you permission to embed it
with independent modules to produce an addon, regardless of the license terms of these
independent modules, and to copy and distribute the resulting software under terms of your
choice, provided that you also meet, for each embedded independent module, the terms and
conditions of the license of that module. Permission is not granted to modify this library.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

This file is part of MutexDelay.
--]]

local Lib = LibStub:NewLibrary('MutexDelay-1.0', 1)
if Lib then
  Lib.timers = Lib.timers or {}
else return end


--[[ API ]]--

function Lib:Delay(time, method, ...)
  local timers = Lib.timers[self] or {}
  if not timers[method] then
		C_Timer.After(time, function()
      local args = timers[method]
      timers[method] = nil
			self[method](self, unpack(args))
		end)

    timers[method] = {...}
	end

  Lib.timers[self] = timers
end

function Lib:Delaying(method)
	return Lib.timers[self] and Lib.timers[self][method]
end

function Lib:Embed(object)
  object.Delay = Lib.Delay
  object.Delaying = Lib.Delaying
end
