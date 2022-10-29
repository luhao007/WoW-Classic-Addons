-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Graph UI Element Class.
-- The graph element allows for generating line graphs. It is a subclass of the @{Element} class.
-- @classmod Graph

local _, TSM = ...
local Math = TSM.Include("Util.Math")
local Theme = TSM.Include("Util.Theme")
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local Graph = TSM.Include("LibTSMClass").DefineClass("Graph", TSM.UI.Element)
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(Graph)
TSM.UI.Graph = Graph
local private = {}
local PLOT_X_LABEL_WIDTH = 48
local PLOT_X_LABEL_HEIGHT = 16
local PLOT_X_LABEL_MARGIN = 6
local PLOT_Y_LABEL_WIDTH = 48
local PLOT_Y_LABEL_HEIGHT = 16
local PLOT_Y_LABEL_MARGIN = 4
local PLOT_HIGHLIGHT_TEXT_WIDTH = 80
local PLOT_HIGHLIGHT_TEXT_HEIGHT = 16
local PLOT_X_EXTRA_HIT_RECT = 4
local PLOT_Y_MARGIN = 4
local LINE_THICKNESS = 1
local LINE_THICKNESS_RATIO = 16
local PLOT_MIN_X_LINE_SPACING = PLOT_X_LABEL_WIDTH * 1.5 + 8
local PLOT_MIN_Y_LINE_SPACING = PLOT_Y_LABEL_HEIGHT * 1.5 + 8
local HOVER_LINE_THICKNESS = 1
local MAX_FILL_ALPHA = 0.5
local SELECTION_ALPHA = 0.2
local MAX_PLOT_POINTS = 300



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Graph.__init(self)
	local frame = UIElements.CreateFrame(self, "Frame", nil, nil, BackdropTemplateMixin and "BackdropTemplate" or nil)

	self.__super:__init(frame)

	frame:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })

	frame.plot = CreateFrame("Frame", nil, frame, nil)
	frame.plot:SetPoint("BOTTOMLEFT", PLOT_Y_LABEL_WIDTH, PLOT_X_LABEL_HEIGHT)
	frame.plot:SetPoint("TOPRIGHT", -PLOT_X_EXTRA_HIT_RECT, -PLOT_HIGHLIGHT_TEXT_HEIGHT - PLOT_Y_MARGIN)
	frame.plot:SetHitRectInsets(-PLOT_X_EXTRA_HIT_RECT, -PLOT_X_EXTRA_HIT_RECT, 0, 0)
	frame.plot:EnableMouse(true)
	ScriptWrapper.Set(frame.plot, "OnEnter", private.PlotFrameOnEnter, self)
	ScriptWrapper.Set(frame.plot, "OnLeave", private.PlotFrameOnLeave, self)
	ScriptWrapper.Set(frame.plot, "OnMouseDown", private.PlotFrameOnMouseDown, self)
	ScriptWrapper.Set(frame.plot, "OnMouseUp", private.PlotFrameOnMouseUp, self)

	frame.plot.dot = frame.plot:CreateTexture(nil, "ARTWORK", nil, 3)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.plot.dot, "uiFrames.HighlightDot")

	frame.plot.hoverLine = frame.plot:CreateTexture(nil, "ARTWORK", nil, 2)
	frame.plot.hoverLine:SetWidth(HOVER_LINE_THICKNESS)
	frame.plot.hoverLine:Hide()

	frame.plot.hoverText = frame.plot:CreateFontString()
	frame.plot.hoverText:SetSize(PLOT_HIGHLIGHT_TEXT_WIDTH, PLOT_HIGHLIGHT_TEXT_HEIGHT)
	frame.plot.hoverText:Hide()

	frame.plot.selectionBox = frame.plot:CreateTexture(nil, "ARTWORK", nil, 2)
	frame.plot.selectionBox:Hide()

	self._usedTextures = {}
	self._freeTextures = {}
	self._usedFontStrings = {}
	self._freeFontStrings = {}
	self._xValuesFiltered = {}
	self._yLookup = {}
	self._yValueFunc = nil
	self._xFormatFunc = nil
	self._yFormatFunc = nil
	self._xStepFunc = nil
	self._yStepFunc = nil
	self._xMin = nil
	self._xMax = nil
	self._yMin = nil
	self._yMax = nil
	self._isMouseOver = false
	self._selectionStartX = nil
	self._zoomStart = nil
	self._zoomEnd = nil
	self._onZoomChanged = nil
	self._onHoverUpdate = nil
end

function Graph.Release(self)
	self:_ReleaseAllTextures()
	self:_ReleaseAllFontStrings()
	wipe(self._xValuesFiltered)
	wipe(self._yLookup)
	self._yValueFunc = nil
	self._xFormatFunc = nil
	self._yFormatFunc = nil
	self._xStepFunc = nil
	self._yStepFunc = nil
	self._xMin = nil
	self._xMax = nil
	self._yMin = nil
	self._yMax = nil
	self._isMouseOver = false
	self._selectionStartX = nil
	self._zoomStart = nil
	self._zoomEnd = nil
	self._onZoomChanged = nil
	self._onHoverUpdate = nil
	self.__super:Release()
end

--- Sets the step size of the axes.
-- @tparam Graph self The graph object
-- @tparam function x A function which gets the next x-axis step value
-- @tparam function y A function which gets the next y-axis step value
-- @treturn Graph The graph object
function Graph.SetAxisStepFunctions(self, x, y)
	self._xStepFunc = x
	self._yStepFunc = y
	return self
end

function Graph.SetXRange(self, xMin, xMax, stepInterval)
	assert(xMin <= xMax)
	self._xMin = xMin
	self._xMax = xMax
	self._xStepInterval = stepInterval
	self._zoomStart = xMin
	self._zoomEnd = xMax
	return self
end

function Graph.SetZoom(self, zoomStart, zoomEnd)
	self._zoomStart = zoomStart
	self._zoomEnd = zoomEnd
	return self
end

function Graph.GetZoom(self)
	return self._zoomStart, self._zoomEnd
end

function Graph.GetXRange(self)
	local yMin, yMax = nil, nil
	for _, x in ipairs(self._xValuesFiltered) do
		local y = self._yValueFunc(x)
		yMin = min(yMin or math.huge, y)
		yMax = max(yMax or -math.huge, y)
	end
	return self._xMin, self._xMax
end

function Graph.GetYRange(self)
	local yMin, yMax = nil, nil
	for _, x in ipairs(self._xValuesFiltered) do
		local y = self._yValueFunc(x)
		yMin = min(yMin or math.huge, y)
		yMax = max(yMax or -math.huge, y)
	end
	return yMin, yMax
end

function Graph.SetYValueFunction(self, func)
	self._yValueFunc = func
	return self
end

--- Sets functions for formatting values.
-- @tparam Graph self The graph object
-- @tparam function xFormatFunc A function which is passed an x value and returns a formatted string
-- @tparam function yFormatFunc A function which is passed a y value and returns a formatted string
-- @treturn Graph The graph object
function Graph.SetFormatFunctions(self, xFormatFunc, yFormatFunc)
	self._xFormatFunc = xFormatFunc
	self._yFormatFunc = yFormatFunc
	return self
end

--- Registers a script handler.
-- @tparam ScrollingTable self The graph object
-- @tparam string script The script to register for (supported scripts: `OnZoomChanged`)
-- @tparam function handler The script handler which will be called with the graph object followed by any
-- arguments to the script
-- @treturn Graph The graph object
function Graph.SetScript(self, script, handler)
	if script == "OnZoomChanged" then
		self._onZoomChanged = handler
	elseif script == "OnHoverUpdate" then
		self._onHoverUpdate = handler
	else
		error("Unknown Graph script: "..tostring(script))
	end
	return self
end

function Graph.Draw(self)
	self.__super:Draw()
	self:_ReleaseAllTextures()
	self:_ReleaseAllFontStrings()
	local frame = self:_GetBaseFrame()
	frame:SetBackdropColor(Theme.GetColor("PRIMARY_BG"):GetFractionalRGBA())
	local plot = frame.plot
	plot.hoverText:SetFont(Theme.GetFont("TABLE_TABLE1"):GetWowFont())
	plot.hoverText:SetTextColor(Theme.GetColor("INDICATOR_ALT"):GetFractionalRGBA())

	local plotWidth = plot:GetWidth()
	local plotHeight = plot:GetHeight()

	-- update the filtered set of x values to show and the bounds of the plot data
	self:_PopulateFilteredData(plotWidth)

	-- calculate the min and max y values which should be shown
	self._yMin, self._yMax = self._yStepFunc("RANGE", self._yMin, self._yMax, floor(plotHeight / PLOT_MIN_Y_LINE_SPACING))
	if Math.IsNan(self._yMax) then
		-- this happens when we're resizing the application frame
		return
	end

	-- draw the y axis lines and labels
	local prevYAxisOffset = -math.huge
	local yAxisValue = self._yMin
	while yAxisValue <= self._yMax do
		local yAxisOffset = Math.Scale(yAxisValue, self._yMin, self._yMax, 0, plotHeight)
		if not prevYAxisOffset or (yAxisOffset - prevYAxisOffset) >= PLOT_MIN_Y_LINE_SPACING then
			self:_DrawYAxisLine(yAxisOffset, yAxisValue, plotWidth, plotHeight)
			prevYAxisOffset = yAxisOffset
		end
		yAxisValue = self._yStepFunc("NEXT", yAxisValue, self._yMax)
	end

	-- draw the x axis lines and labels
	local xSuggestedStep = Math.Scale(PLOT_MIN_X_LINE_SPACING, 0, plotWidth, 0, self._zoomEnd - self._zoomStart)
	local prevXAxisOffset = -math.huge
	local xAxisValue = self._xStepFunc(self._zoomStart, xSuggestedStep)
	while xAxisValue <= self._zoomEnd do
		local xAxisOffset = Math.Scale(xAxisValue, self._zoomStart, self._zoomEnd, 0, plotWidth)
		if not prevXAxisOffset or (xAxisOffset - prevXAxisOffset) > PLOT_MIN_X_LINE_SPACING then
			self:_DrawXAxisLine(xAxisOffset, xAxisValue, plotWidth, plotHeight, xSuggestedStep)
			prevXAxisOffset = xAxisOffset
		end
		xAxisValue = self._xStepFunc(xAxisValue, xSuggestedStep)
	end

	-- draw all the lines
	local color = nil
	if self._isMouseOver or self._selectionStartX then
		color = Theme.GetColor("INDICATOR_ALT")
	elseif self._yLookup[self._xValuesFiltered[1]] <= self._yLookup[self._xValuesFiltered[#self._xValuesFiltered]] then
		color = Theme.GetFeedbackColor("GREEN")
	else
		color = Theme.GetFeedbackColor("RED")
	end
	local xPrev, yPrev = nil, nil
	for _, x in ipairs(self._xValuesFiltered) do
		local y = self._yLookup[x]
		local xCoord = Math.Scale(x, self._zoomStart, self._zoomEnd, 0, plotWidth)
		local yCoord = Math.Scale(y, self._yMin, self._yMax, 0, plotHeight)
		if xPrev then
			self:_DrawFillLine(xPrev, yPrev, xCoord, yCoord, LINE_THICKNESS, plotHeight, color)
		end
		xPrev = xCoord
		yPrev = yCoord
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Graph._PopulateFilteredData(self, plotWidth)
	wipe(self._xValuesFiltered)
	wipe(self._yLookup)
	self._yMin = math.huge
	self._yMax = -math.huge
	local minStep = Math.Ceil((self._zoomEnd - self._zoomStart) / min(plotWidth / 3, MAX_PLOT_POINTS), self._xStepInterval)
	local x = self._zoomStart
	while x <= self._zoomEnd do
		local prevX = self._xValuesFiltered[#self._xValuesFiltered]
		if not prevX or x == self._zoomEnd or (x - prevX > minStep and self._zoomEnd - x > minStep) then
			-- this is either the first / last point or a middle point which is sufficiently far from the previous and last points
			tinsert(self._xValuesFiltered, x)
			local y = self._yValueFunc(x)
			self._yMin = min(self._yMin, y)
			self._yMax = max(self._yMax, y)
			self._yLookup[x] = y
		end
		if x == self._zoomEnd then
			break
		end
		x = min(x + minStep, self._zoomEnd)
	end
end

function Graph._DrawYAxisLine(self, yOffset, yValue, plotWidth, plotHeight, ySuggestedStep)
	local line = self:_AcquireLine("ARTWORK")
	local thickness = LINE_THICKNESS
	local textureHeight = thickness * LINE_THICKNESS_RATIO
	-- trim the texture a bit on the left/right since it's not completely filled to the edges which is noticeable on long lines
	line:SetTexCoord(0.1, 1, 0.1, 0, 0.9, 1, 0.9, 0)
	line:SetPoint("BOTTOMLEFT", 0 - thickness / 2, yOffset - textureHeight / 2)
	line:SetPoint("TOPRIGHT", line:GetParent(), "BOTTOMLEFT", plotWidth + thickness / 2, yOffset + textureHeight / 2)
	line:SetVertexColor(Theme.GetColor("ACTIVE_BG"):GetFractionalRGBA())
	line:SetDrawLayer("BACKGROUND", 0)
	local text = self:_AcquireFontString(Theme.GetFont("TABLE_TABLE1"))
	text:SetJustifyH("RIGHT")
	local textYOffset = 0
	if PLOT_Y_LABEL_HEIGHT / 2 > yOffset then
		text:SetJustifyV("BOTTOM")
		textYOffset = max(PLOT_Y_LABEL_HEIGHT / 2 - yOffset, 0)
	elseif yOffset + PLOT_Y_LABEL_HEIGHT / 2 > plotHeight then
		text:SetJustifyV("TOP")
		textYOffset = plotHeight - yOffset - PLOT_Y_LABEL_HEIGHT / 2
	else
		text:SetJustifyV("MIDDLE")
	end
	text:SetPoint("RIGHT", line, "LEFT", -PLOT_Y_LABEL_MARGIN, textYOffset)
	text:SetSize(PLOT_Y_LABEL_WIDTH, PLOT_Y_LABEL_HEIGHT)
	text:SetText(self._yFormatFunc(yValue, ySuggestedStep))
end

function Graph._DrawXAxisLine(self, xOffset, xValue, plotWidth, plotHeight, xSuggestedStep)
	local line = self:_AcquireLine("ARTWORK")
	local thickness = LINE_THICKNESS
	local textureHeight = thickness * LINE_THICKNESS_RATIO
	-- trim the texture a bit on the left/right since it's not completely filled to the edges which is noticeable on long lines
	line:SetTexCoord(0.9, 1, 0.1, 1, 0.9, 0, 0.1, 0)
	line:SetPoint("BOTTOMLEFT", xOffset - textureHeight / 2, thickness / 2)
	line:SetPoint("TOPRIGHT", line:GetParent(), "BOTTOMLEFT", xOffset + textureHeight / 2, plotHeight + thickness / 2)
	line:SetVertexColor(Theme.GetColor("ACTIVE_BG"):GetFractionalRGBA())
	line:SetDrawLayer("BACKGROUND", 0)
	local text = self:_AcquireFontString(Theme.GetFont("BODY_BODY3_MEDIUM"))
	text:ClearAllPoints()
	text:SetJustifyV("TOP")
	local textXOffset = 0
	if PLOT_X_LABEL_WIDTH / 2 > xOffset then
		text:SetJustifyH("LEFT")
		textXOffset = max(PLOT_X_LABEL_WIDTH / 2 - xOffset, 0)
	elseif xOffset + PLOT_X_LABEL_WIDTH / 2 > plotWidth then
		text:SetJustifyH("RIGHT")
		textXOffset = plotWidth - xOffset - PLOT_X_LABEL_WIDTH / 2
	else
		text:SetJustifyH("CENTER")
	end
	text:SetPoint("TOP", line, "BOTTOM", textXOffset, -PLOT_X_LABEL_MARGIN)
	text:SetSize(PLOT_X_LABEL_WIDTH, PLOT_X_LABEL_HEIGHT)
	text:SetText(self._xFormatFunc(xValue, xSuggestedStep))
end

function Graph._DrawFillLine(self, xFrom, yFrom, xTo, yTo, thickness, plotHeight, color)
	assert(xFrom <= xTo)
	local line = self:_AcquireLine("ARTWORK")
	local textureHeight = thickness * LINE_THICKNESS_RATIO
	local xDiff = xTo - xFrom
	local yDiff = yTo - yFrom
	local length = sqrt(xDiff * xDiff + yDiff * yDiff)
	local sinValue = -yDiff / length
	local cosValue = xDiff / length
	local sinCosValue = sinValue * cosValue
	local aspectRatio = length / textureHeight
	local invAspectRatio = textureHeight / length

	-- calculate and set tex coords
	local LLx, LLy, ULx, ULy, URx, URy, LRx, LRy = nil, nil, nil, nil, nil, nil, nil, nil
	if yDiff >= 0 then
		LLx = invAspectRatio * sinCosValue
		LLy = sinValue * sinValue
		LRy = aspectRatio * sinCosValue
		LRx = 1 - LLy
		ULx = LLy
		ULy = 1 - LRy
		URx = 1 - LLx
		URy = LRx
	else
		LLx = sinValue * sinValue
		LLy = -aspectRatio * sinCosValue
		LRx = 1 + invAspectRatio * sinCosValue
		LRy = LLx
		ULx = 1 - LRx
		ULy = 1 - LLx
		URy = 1 - LLy
		URx = ULy
	end
	line:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)

	-- calculate and set texture anchors
	local xCenter = (xFrom + xTo) / 2
	local yCenter = (yFrom + yTo) / 2
	local halfWidth = (xDiff + invAspectRatio * abs(yDiff) + thickness) / 2
	local halfHeight = (abs(yDiff) + invAspectRatio * xDiff + thickness) / 2
	line:SetPoint("BOTTOMLEFT", xCenter - halfWidth, yCenter - halfHeight)
	line:SetPoint("TOPRIGHT", line:GetParent(), "BOTTOMLEFT", xCenter + halfWidth, yCenter + halfHeight)

	local minY = min(yFrom, yTo)
	local maxY = max(yFrom, yTo)
	local r, g, b, a = color:GetFractionalRGBA()
	local barMaxAlpha = Math.Scale(minY, 0, plotHeight, 0, MAX_FILL_ALPHA * a)
	local topMaxAlpha = Math.Scale(maxY, 0, plotHeight, 0, MAX_FILL_ALPHA * a)
	line:SetVertexColor(r, g, b, a)

	local fillTop = self:_AcquireTexture("ARTWORK", -1)
	fillTop:SetTexture("Interface\\AddOns\\TradeSkillMaster\\Media\\triangle")
	if yFrom < yTo then
		fillTop:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	else
		fillTop:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
	end
	if TSM.IsWowClassic() then
		fillTop:SetGradientAlpha("VERTICAL", r, g, b, barMaxAlpha, r, g, b, topMaxAlpha)
	else
		-- TODO: Create the ColorMixin objects from our color object
		fillTop:SetGradient("VERTICAL", CreateColor(r, g, b, barMaxAlpha), CreateColor(r, g, b, topMaxAlpha))
	end
	fillTop:SetPoint("BOTTOMLEFT", xFrom, minY)
	fillTop:SetPoint("TOPRIGHT", fillTop:GetParent(), "BOTTOMLEFT", xTo, maxY)

	local fillBar = self:_AcquireTexture("ARTWORK", -1)
	fillBar:SetTexture("Interface\\Buttons\\WHITE8X8")
	if TSM.IsWowClassic() then
		fillBar:SetGradientAlpha("VERTICAL", r, g, b, 0, r, g, b, barMaxAlpha)
	else
		-- TODO: Create the ColorMixin objects from our color object
		fillBar:SetGradient("VERTICAL", CreateColor(r, g, b, 0), CreateColor(r, g, b, barMaxAlpha))
	end
	fillBar:SetPoint("BOTTOMLEFT", xFrom, 0)
	fillBar:SetPoint("TOPRIGHT", fillBar:GetParent(), "BOTTOMLEFT", xTo, minY)

	return line
end

function Graph._AcquireLine(self, layer, subLayer)
	local line = self:_AcquireTexture(layer, subLayer)
	line:SetTexture("Interface\\AddOns\\TradeSkillMaster\\Media\\line.tga")
	return line
end

function Graph._AcquireTexture(self, layer, subLayer)
	local plot = self:_GetBaseFrame().plot
	local result = tremove(self._freeTextures) or plot:CreateTexture()
	tinsert(self._usedTextures, result)
	result:SetParent(plot)
	result:Show()
	result:SetDrawLayer(layer, subLayer)
	return result
end

function Graph._ReleaseAllTextures(self)
	while #self._usedTextures > 0 do
		local texture = tremove(self._usedTextures)
		texture:SetTexture(nil)
		texture:SetVertexColor(0, 0, 0, 0)
		texture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		texture:SetWidth(0)
		texture:SetHeight(0)
		texture:ClearAllPoints()
		texture:Hide()
		tinsert(self._freeTextures, texture)
	end
end

function Graph._AcquireFontString(self, font)
	local plot = self:_GetBaseFrame().plot
	local result = tremove(self._freeFontStrings) or plot:CreateFontString()
	tinsert(self._usedFontStrings, result)
	result:SetParent(plot)
	result:Show()
	result:SetFont(font:GetWowFont())
	result:SetTextColor(Theme.GetColor("TEXT"):GetFractionalRGBA())
	return result
end

function Graph._ReleaseAllFontStrings(self)
	while #self._usedFontStrings > 0 do
		local fontString = tremove(self._usedFontStrings)
		fontString:SetWidth(0)
		fontString:SetHeight(0)
		fontString:ClearAllPoints()
		fontString:Hide()
		tinsert(self._freeFontStrings, fontString)
	end
end

function Graph._GetCursorClosestPoint(self)
	local plotFrame = self:_GetBaseFrame().plot
	local xPos = GetCursorPosition() / plotFrame:GetEffectiveScale()
	local fromMin = plotFrame:GetLeft()
	local fromMax = plotFrame:GetRight()
	-- Convert the cursor position to be relative to the plotted x values
	xPos = Math.Scale(Math.Bound(xPos, fromMin, fromMax), fromMin, fromMax, self._zoomStart, self._zoomEnd)
	-- Find the closest point to the cursor (based on the x distance)
	local closestX, closestY = nil, nil
	for _, x in ipairs(self._xValuesFiltered) do
		local y = self._yLookup[x]
		local xDist = abs(x - xPos)
		if not closestX or xDist < abs(closestX - xPos) then
			closestX = x
			closestY = y
		end
	end
	assert(closestY)
	return closestX, closestY
end

function Graph._XValueToPlotCoord(self, xValue)
	local plotFrame = self:_GetBaseFrame().plot
	return Math.Scale(xValue, self._zoomStart, self._zoomEnd, 0, plotFrame:GetWidth())
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.PlotFrameOnEnter(self)
	self._isMouseOver = true
	self:Draw()
	local plotFrame = self:_GetBaseFrame().plot
	ScriptWrapper.Set(plotFrame, "OnUpdate", private.PlotFrameOnUpdate, self)
end

function private.PlotFrameOnLeave(self)
	self._isMouseOver = false
end

function private.PlotFrameOnUpdate(self)
	local plotFrame = self:_GetBaseFrame().plot
	local closestX, closestY = self:_GetCursorClosestPoint()
	local xCoord = self:_XValueToPlotCoord(closestX)
	local yCoord = Math.Scale(closestY, self._yMin, self._yMax, 0, plotFrame:GetHeight())

	if self._isMouseOver then
		plotFrame.dot:Show()
		plotFrame.dot:ClearAllPoints()
		plotFrame.dot:SetPoint("CENTER", plotFrame, "BOTTOMLEFT", xCoord, yCoord)

		plotFrame.hoverLine:Show()
		plotFrame.hoverLine:SetColorTexture(Theme.GetColor("INDICATOR_ALT"):GetFractionalRGBA())
		plotFrame.hoverLine:ClearAllPoints()
		plotFrame.hoverLine:SetPoint("TOP", plotFrame, "TOPLEFT", xCoord, 0)
		plotFrame.hoverLine:SetPoint("BOTTOM", plotFrame, "BOTTOMLEFT", xCoord, 0)

		plotFrame.hoverText:Show()
		plotFrame.hoverText:SetWidth(1000)
		plotFrame.hoverText:SetText(self._yFormatFunc(closestY, nil, true))
		local textWidth = plotFrame.hoverText:GetStringWidth()
		plotFrame.hoverText:SetWidth(textWidth)
		plotFrame.hoverText:ClearAllPoints()
		if xCoord - textWidth / 2 < 0 then
			plotFrame.hoverText:SetPoint("BOTTOMLEFT", plotFrame, "TOPLEFT", 0, PLOT_Y_MARGIN)
		elseif textWidth / 2 + xCoord > plotFrame:GetWidth() then
			plotFrame.hoverText:SetPoint("BOTTOMRIGHT", plotFrame, "TOPRIGHT", 0, PLOT_Y_MARGIN)
		else
			plotFrame.hoverText:SetPoint("BOTTOM", plotFrame, "TOPLEFT", xCoord, PLOT_Y_MARGIN)
		end
	else
		plotFrame.dot:Hide()
		plotFrame.hoverLine:Hide()
		plotFrame.hoverText:Hide()
	end

	if self._selectionStartX then
		local startXCoord = self:_XValueToPlotCoord(self._selectionStartX)
		local selectionMinX = min(startXCoord, xCoord)
		local selectionMaxX = max(startXCoord, xCoord)
		plotFrame.selectionBox:Show()
		local r, g, b, a = Theme.GetColor("INDICATOR_ALT"):GetFractionalRGBA()
		assert(a == 1)
		plotFrame.selectionBox:SetColorTexture(r, g, b, SELECTION_ALPHA)
		plotFrame.selectionBox:ClearAllPoints()
		plotFrame.selectionBox:SetPoint("TOPLEFT", plotFrame, selectionMinX, 0)
		plotFrame.selectionBox:SetPoint("BOTTOMRIGHT", plotFrame, "BOTTOMLEFT", selectionMaxX, 0)
	else
		plotFrame.selectionBox:Hide()
	end

	local isHovered = self._isMouseOver or self._selectionStartX
	if not isHovered then
		self:Draw()
		ScriptWrapper.Clear(plotFrame, "OnUpdate")
	end
	if self._onHoverUpdate then
		self:_onHoverUpdate(isHovered and closestX or nil)
	end
end

function private.PlotFrameOnMouseDown(self, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	assert(self._isMouseOver)
	self._selectionStartX = self:_GetCursorClosestPoint()
end

function private.PlotFrameOnMouseUp(self, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	local currentX = self:_GetCursorClosestPoint()
	local startX = min(self._selectionStartX, currentX)
	local endX = max(self._selectionStartX, currentX)
	self._selectionStartX = nil
	local plotFrame = self:_GetBaseFrame().plot
	plotFrame.selectionBox:Hide()

	if startX ~= endX and (startX ~= self._zoomStart or endX ~= self._zoomEnd) then
		self._zoomStart = startX
		self._zoomEnd = endX
		self:Draw()
		if self._onZoomChanged then
			self:_onZoomChanged()
		end
	end
end
