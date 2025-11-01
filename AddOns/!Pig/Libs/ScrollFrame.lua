local addonName, addonTable = ...;
local L=addonTable.locale
local Create = addonTable.Create
local FontUrl=Create.FontUrl
local PIGSetFont=Create.PIGSetFont
-------------------
function Create.PIGScrollFrame(fujik,Point,WH,BarW)
	local BarW=BarW or 16
	local Scroll = CreateFrame("ScrollFrame",nil,fujik); 
	if Point then
		Scroll:SetPoint("TOPLEFT",fujik,"TOPLEFT",Point[1],Point[2]);
		Scroll:SetPoint("BOTTOMRIGHT",fujik,"BOTTOMRIGHT",Point[3],Point[4]);
	end
	if WH then
		Scroll:SetSize(WH[1],WH[2] or WH[1])
	end
	Scroll.ScrollChildFrame = CreateFrame("Frame", nil, Scroll);
	Scroll.ScrollBar = CreateFrame("Slider", nil, Scroll)
	Scroll.ScrollBar:SetPoint("TOPLEFT",Scroll,"TOPRIGHT",0,-BarW);
	Scroll.ScrollBar:SetPoint("BOTTOMLEFT",Scroll,"BOTTOMRIGHT",0,BarW);
	Scroll.ScrollBar:SetWidth(BarW)
	Scroll.ScrollBar.ScrollUpButton = CreateFrame("Button",nil,Scroll.ScrollBar,"UIPanelScrollUpButtonTemplate");
	Scroll.ScrollBar.ScrollUpButton:SetSize(BarW,BarW-2);
	Scroll.ScrollBar.ScrollUpButton:SetPoint("BOTTOM",Scroll.ScrollBar,"TOP",0,0);
	Scroll.ScrollBar.ScrollUpButton:SetNormalAtlas("NPE_ArrowUp")
	Scroll.ScrollBar.ScrollUpButton:SetPushedAtlas("NPE_ArrowUp")
	Scroll.ScrollBar.ScrollUpButton:SetDisabledAtlas("NPE_ArrowUp")
	Scroll.ScrollBar.ScrollUpButton:GetDisabledTexture():SetDesaturated(true)
	Scroll.ScrollBar.ScrollUpButton:SetHighlightAtlas("minimal-scrollbar-arrow-top-over")
	Scroll.ScrollBar.ScrollUpButton:GetNormalTexture():SetTexCoord(0,1,0.24,0.76)
	Scroll.ScrollBar.ScrollUpButton:GetPushedTexture():SetTexCoord(0,1,0.24,0.76)
	Scroll.ScrollBar.ScrollUpButton:GetDisabledTexture():SetTexCoord(0,1,0.24,0.76)
	Scroll.ScrollBar.ScrollUpButton:GetHighlightTexture():SetTexCoord(0,1,0,1)
	Scroll.ScrollBar.ScrollUpButton:SetScript("OnClick",UIPanelScrollBarScrollUpButton_OnClick)

	Scroll.ScrollBar.ScrollDownButton = CreateFrame("Button",nil,Scroll.ScrollBar,"UIPanelScrollDownButtonTemplate");
	Scroll.ScrollBar.ScrollDownButton:SetSize(BarW,BarW-2);
	Scroll.ScrollBar.ScrollDownButton:SetPoint("TOP",Scroll.ScrollBar,"BOTTOM",0,0);
	Scroll.ScrollBar.ScrollDownButton:SetNormalAtlas("NPE_ArrowDown")
	Scroll.ScrollBar.ScrollDownButton:SetPushedAtlas("NPE_ArrowDown")
	Scroll.ScrollBar.ScrollDownButton:SetDisabledAtlas("NPE_ArrowDown")
	Scroll.ScrollBar.ScrollDownButton:GetDisabledTexture():SetDesaturated(true)
	Scroll.ScrollBar.ScrollDownButton:SetHighlightAtlas("minimal-scrollbar-arrow-bottom-over")
	Scroll.ScrollBar.ScrollDownButton:GetNormalTexture():SetTexCoord(0,1,0.24,0.76)
	Scroll.ScrollBar.ScrollDownButton:GetPushedTexture():SetTexCoord(0,1,0.24,0.76)
	Scroll.ScrollBar.ScrollDownButton:GetDisabledTexture():SetTexCoord(0,1,0.24,0.76)
	Scroll.ScrollBar.ScrollDownButton:GetHighlightTexture():SetTexCoord(0,1,0,1)
	Scroll.ScrollBar.ScrollDownButton:SetScript("OnClick",UIPanelScrollBarScrollDownButton_OnClick)

	Scroll.ScrollBar.ThumbTexture = Scroll.ScrollBar:CreateTexture(nil, "ARTWORK");
	Scroll.ScrollBar.ThumbTexture:SetWidth(BarW);
	Scroll.ScrollBar.ThumbTexture:SetPoint("TOP",Scroll.ScrollBar,"TOP",0,0);
	Scroll.ScrollBar:SetThumbTexture(Scroll.ScrollBar.ThumbTexture);
	local thumbtop = Scroll.ScrollBar:CreateTexture(nil, "BORDER");
	thumbtop:SetAtlas("minimal-scrollbar-small-thumb-top", true);
	thumbtop:SetPoint("TOP",Scroll.ScrollBar.ThumbTexture,"TOP",0,0);
	local thumbtopHIGHLIGHT = Scroll.ScrollBar:CreateTexture(nil, "HIGHLIGHT");
	thumbtopHIGHLIGHT:SetAtlas("minimal-scrollbar-small-thumb-top-over", true);
	thumbtopHIGHLIGHT:SetPoint("TOP",Scroll.ScrollBar.ThumbTexture,"TOP",0,0);
	local thumbbottom = Scroll.ScrollBar:CreateTexture(nil, "BORDER");
	thumbbottom:SetAtlas("minimal-scrollbar-small-thumb-bottom", true);
	thumbbottom:SetPoint("BOTTOM",Scroll.ScrollBar.ThumbTexture,"BOTTOM",0,0);
	local thumbbottomHIGHLIGHT = Scroll.ScrollBar:CreateTexture(nil, "HIGHLIGHT");
	thumbbottomHIGHLIGHT:SetAtlas("minimal-scrollbar-small-thumb-bottom-over", true);
	thumbbottomHIGHLIGHT:SetPoint("BOTTOM",Scroll.ScrollBar.ThumbTexture,"BOTTOM",0,0);
	local thumbmiddle = Scroll.ScrollBar:CreateTexture(nil, "BORDER");
	thumbmiddle:SetAtlas("minimal-scrollbar-small-thumb-middle", true);
	thumbmiddle:SetPoint("TOPLEFT", thumbtop, "BOTTOMLEFT");
	thumbmiddle:SetPoint("BOTTOMRIGHT", thumbbottom, "TOPRIGHT");
	local thumbmiddleHIGHLIGHT = Scroll.ScrollBar:CreateTexture(nil, "HIGHLIGHT");
	thumbmiddleHIGHLIGHT:SetAtlas("minimal-scrollbar-small-thumb-middle-over", true);
	thumbmiddleHIGHLIGHT:SetPoint("TOPLEFT", thumbtop, "BOTTOMLEFT");
	thumbmiddleHIGHLIGHT:SetPoint("BOTTOMRIGHT", thumbbottom, "TOPRIGHT");

	local beginTexture = Scroll.ScrollBar:CreateTexture(nil, "ARTWORK");
	beginTexture:SetAtlas("minimal-scrollbar-track-top", true);
	beginTexture:SetPoint("TOP");
	local endTexture = Scroll.ScrollBar:CreateTexture(nil, "ARTWORK");
	endTexture:SetAtlas("minimal-scrollbar-track-bottom", true);
	endTexture:SetPoint("BOTTOM");
	local middleTexture = Scroll.ScrollBar:CreateTexture(nil, "ARTWORK");
	middleTexture:SetAtlas("!minimal-scrollbar-track-middle", true);
	middleTexture:SetPoint("TOPLEFT", beginTexture, "BOTTOMLEFT");
	middleTexture:SetPoint("BOTTOMRIGHT", endTexture, "TOPRIGHT");
	Scroll.ScrollBar:SetScript("OnValueChanged", function(self, value)
		UIPanelScrollBar_OnValueChanged(self, value)
	end)
	UIPanelScrollFrame_OnLoad(Scroll)
	function Scroll:UpdateThumbTexture(numItems, numToDisplay, buttonHeight)
	    local scrollBar = self.ScrollBar or self.scrollBar
	    if not scrollBar then return end
	    local thumb = scrollBar.ThumbTexture
	    if not thumb then return end
	    local trackHeight = self:GetHeight() - (scrollBar.ScrollUpButton and scrollBar.ScrollUpButton:GetHeight() or 0) - 
	                                      (scrollBar.ScrollDownButton and scrollBar.ScrollDownButton:GetHeight() or 0)
	    local contentHeight = numItems * buttonHeight
	    local viewHeight = numToDisplay * buttonHeight
	    local thumbHeight
	    if contentHeight > viewHeight then
	        thumbHeight = math.max(24, (viewHeight / contentHeight) * trackHeight)
	    else
	        thumbHeight = trackHeight
	    end
	    thumb:SetHeight(thumbHeight)
	end
	Scroll.ScrollBar.ThumbTexture:SetHeight(50)
	Scroll:SetScript("OnScrollRangeChanged", function(self, xrange, yrange)
		ScrollFrame_OnScrollRangeChanged(self, xrange, yrange)
	end)
	Scroll:SetScript("OnVerticalScroll", function(self, offset)
		ScrollFrame_OnVerticalScroll(self, offset)
	end)
	Scroll:SetScript("OnMouseWheel", function(self, delta)
		ScrollFrameTemplate_OnMouseWheel(self, delta);
	end)
	return Scroll
end