-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Texture UI Element Class.
-- This is a simple, light-weight element which is used to display a texture. It is a subclass of the @{Element} class.
-- @classmod Texture

local _, TSM = ...
local Texture = TSM.Include("LibTSMClass").DefineClass("Texture", TSM.UI.Element)
local Color = TSM.Include("Util.Color")
local Theme = TSM.Include("Util.Theme")
local ItemInfo = TSM.Include("Service.ItemInfo")
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(Texture)
TSM.UI.Texture = Texture
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Texture.__init(self)
	local texture = UIParent:CreateTexture()
	-- hook SetParent/GetParent since textures can't have a nil parent
	texture._oldSetParent = texture.SetParent
	texture.SetParent = private.SetParent
	texture.GetParent = private.GetParent
	self.__super:__init(texture)
	self._texture = nil
end

function Texture.Release(self)
	self._texture = nil
	self.__super:Release()
end

--- Sets the texture.
-- @tparam Texture self The texture object
-- @tparam ?string|number texture Either a texture pack string, itemString, WoW file id, or theme color key
-- @treturn Texture The texture object
function Texture.SetTexture(self, texture)
	self._texture = texture
	return self
end

--- Sets the texture and size based on a texture pack string.
-- @tparam Texture self The texture object
-- @tparam string texturePack A texture pack string
-- @treturn Texture The texture object
function Texture.SetTextureAndSize(self, texturePack)
	self:SetTexture(texturePack)
	self:SetSize(TSM.UI.TexturePacks.GetSize(texturePack))
	return self
end

function Texture.Draw(self)
	self.__super:Draw()

	local texture = self:_GetBaseFrame()
	texture:SetTexture(nil)
	texture:SetTexCoord(0, 1, 0, 1)
	texture:SetVertexColor(1, 1, 1, 1)

	if type(self._texture) == "string" and TSM.UI.TexturePacks.IsValid(self._texture) then
		-- this is a texture pack
		TSM.UI.TexturePacks.SetTexture(texture, self._texture)
	elseif type(self._texture) == "string" and strmatch(self._texture, "^[ip]:%d+") then
		-- this is an itemString
		texture:SetTexture(ItemInfo.GetTexture(self._texture))
	elseif type(self._texture) == "string" then
		-- this is a theme color key
		texture:SetColorTexture(Theme.GetColor(self._texture):GetFractionalRGBA())
	elseif type(self._texture) == "number" then
		-- this is a wow file id
		texture:SetTexture(self._texture)
	elseif Color.IsInstance(self._texture) then
		texture:SetColorTexture(self._texture:GetFractionalRGBA())
	else
		error("Invalid texture: "..tostring(self._texture))
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.SetParent(self, parent)
	self._parent = parent
	if parent then
		self:Show()
	else
		self:Hide()
	end
	self:_oldSetParent(parent or UIParent)
end

function private.GetParent(self)
	return self._parent
end
