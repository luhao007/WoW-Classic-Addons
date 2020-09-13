-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- SecureMacroActionButton UI Element Class.
-- A secure macro action button builds on top of WoW's `SecureActionButtonTemplate` to allow executing scripts which
-- addon buttons would otherwise be forbidden from running. It is a subclass of the @{ActionButton} class.
-- @classmod SecureMacroActionButton

local _, TSM = ...
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local SecureMacroActionButton = TSM.Include("LibTSMClass").DefineClass("SecureMacroActionButton", TSM.UI.ActionButton)
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(SecureMacroActionButton)
TSM.UI.SecureMacroActionButton = SecureMacroActionButton



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function SecureMacroActionButton.__init(self, name)
	self.__super:__init(name, true)
	local frame = self:_GetBaseFrame()
	frame:SetAttribute("type1", "macro")
	frame:SetAttribute("macrotext1", "")
end

function SecureMacroActionButton.Release(self)
	local frame = self:_GetBaseFrame()
	ScriptWrapper.Clear(frame, "PreClick")
	frame:SetAttribute("macrotext1", "")
	self.__super:Release()
end

--- Registers a script handler.
-- @tparam SecureMacroActionButton self The secure macro action button object
-- @tparam string script The script to register for (supported scripts: `PreClick`)
-- @tparam function handler The script handler which will be called with the secure macro action button object followed
-- by any arguments to the script
-- @treturn SecureMacroActionButton The secure macro action button object
function SecureMacroActionButton.SetScript(self, script, handler)
	if script == "PreClick" or script == "PostClick" then
		self.__super.__super:SetScript(script, handler)
	else
		error("Unknown SecureActionButton script: "..tostring(script))
	end
	return self
end

--- Sets the macro text which clicking the button executes.
-- @tparam SecureMacroActionButton self The secure macro action button object
-- @tparam string text THe macro text
-- @treturn SecureMacroActionButton The secure macro action button object
function SecureMacroActionButton.SetMacroText(self, text)
	self:_GetBaseFrame():SetAttribute("macrotext1", text)
	return self
end
