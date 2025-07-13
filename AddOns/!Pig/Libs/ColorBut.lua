local addonName, addonTable = ...;
local Create = addonTable.Create
-----------------------
function Create.ColorBut(fuF,Point,WH)
	local but
	if ColorSwatchMixin then
		but = CreateFrame("Button", nil, fuF, "ColorSwatchTemplate")
	else
		but = CreateFrame("Button", nil, fuF, "BackdropTemplate")
		but:SetBackdrop({
			bgFile = Create.bgFile, tile = true, tileSize = 0,
			edgeFile = Create.edgeFile, edgeSize = 8, 
			insets = { left = 0, right = 0, top = 0, bottom = 0 }});
		but:SetBackdropBorderColor(1, 1, 1, 1);
	end
	but:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
	but:SetSize(WH[1],WH[2]);
	function but:ShowButColor(newR, newG, newB, newA)
		if oldversion then
			self:SetBackdropColor(newR, newG, newB, newA);
		else
			self.Color:SetVertexColor(newR, newG, newB, newA)
		end
	end
	function but:PIGSetValue(newR, newG, newB, newA)
	end
	local function PIGGetAlpha()
		if ColorPickerFrame and ColorPickerFrame.GetColorAlpha then
			return ColorPickerFrame:GetColorAlpha()
		elseif OpacitySliderFrame and OpacitySliderFrame.GetValue then
			return OpacitySliderFrame:GetValue()
		else
			return 1
		end
	end
	function but.swatchFunc()
		local newR, newG, newB = ColorPickerFrame:GetColorRGB()
		local newA = PIGGetAlpha()
		but:ShowButColor(newR, newG, newB, newA)
		but:PIGSetValue(newR, newG, newB, newA)
	end
	function but.cancelFunc(restore)
		local newR, newG, newB, newA = restore.r, restore.g, restore.b, ColorPickerFrame.opacity
		but:ShowButColor(newR, newG, newB, newA)
		but:PIGSetValue(newR, newG, newB, newA)
	end
	but:SetScript("OnClick", function (self)
		self:PIGinitialize()
		local miyumorenColor=self.pezhiV or self.morenColor
		local info={}
		info.r, info.g, info.b, info.opacity = unpack(miyumorenColor)
		info.hasOpacity = true
		info.swatchFunc=self.swatchFunc
		info.opacityFunc=self.opacityFunc or self.swatchFunc
		info.cancelFunc=self.cancelFunc
		if oldversion then
			OpenColorPicker(info)
		else
			ColorPickerFrame:SetupColorPickerAndShow(info);
		end
	end);
	return but
end