local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
-----
local Create=addonTable.Create
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont
local Data=addonTable.Data
--------
local function AddExtOptionsUI(ExtID,Tooltip,Disable)
	local fuFrame,fuFrameBut = PIGOptionsList(L["PIGaddonList"][L.extLsit[ExtID]],"EXT")
	if Disable then
		fuFrame.errtishi = PIGFontString(fuFrame,{"TOP", fuFrame, "TOP", 0,-140},"<"..L["PIGaddonList"][L.extLsit[ExtID]]..">模块已停止维护","OUTLINE",18);
		fuFrame.errtishi:SetTextColor(1, 0, 0, 1);
		return
	end
	fuFrame.errtishi = PIGFontString(fuFrame,{"TOP", fuFrame, "TOP", 0,-140},"没有安装<"..L["PIGaddonList"][L.extLsit[ExtID]]..">模块","OUTLINE",18);
	fuFrame.errtishi:SetTextColor(1, 0, 0, 1);
	fuFrame.errtishi1 = PIGFontString(fuFrame,{"TOP", fuFrame, "TOP", 0,-180},L["PIGaddonList"][L.extLsit[ExtID]]..": "..Tooltip);
	fuFrame.errtishi1:SetTextColor(0, 1, 0, 1);

	local addname_ot = CreateFrame("EditBox", nil, fuFrame, "InputBoxInstructionsTemplate");
	addname_ot:SetSize(120,30);
	addname_ot:SetPoint("TOPLEFT",fuFrame,"TOPLEFT",20,-430);
	PIGSetFont(addname_ot, 15, "OUTLINE");
	addname_ot:SetAutoFocus(false);
	addname_ot:SetText(L["ABOUT_OTHERADDON_LIST"][ExtID][1]);
	function addname_ot:SetTextpig()
		self:SetText(L["ABOUT_OTHERADDON_LIST"][ExtID][1]);
	end
	addname_ot:SetScript("OnEditFocusGained", function(self) self:HighlightText() end);
	addname_ot:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
	addname_ot:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);
	local pigaddname = PIGFontString(addname_ot,{"LEFT",addname_ot,"RIGHT",10,0},L["ABOUT_OTHERADDONS_DOWN"],"OUTLINE",15)

	local UpdateURLtxt = PIGFontString(addname_ot,{"TOPLEFT",addname_ot,"BOTTOMLEFT",0,-6},L["ABOUT_UPDATEADD"],"OUTLINE",15)
	local UpdateURL = CreateFrame("EditBox", nil, addname_ot, "InputBoxInstructionsTemplate");
	UpdateURL:SetSize(500,30);
	UpdateURL:SetPoint("LEFT",UpdateURLtxt,"RIGHT",0,0);
	PIGSetFont(UpdateURL, 16, "OUTLINE");
	UpdateURL:SetAutoFocus(false);
	UpdateURL:SetText(L["ABOUT_OTHERADDON_LIST"][ExtID][3]);
	function UpdateURL:SetTextpig()
		self:SetText(L["ABOUT_OTHERADDON_LIST"][ExtID][3]);
	end
	UpdateURL:SetScript("OnEditFocusGained", function(self) self:HighlightText() end);
	UpdateURL:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
	UpdateURL:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);

	Data.Ext[L.extLsit[ExtID]]={fuFrame,fuFrameBut,Tooltip,function() fuFrame.errtishi:Hide() fuFrame.errtishi1:Hide() addname_ot:Hide() end}
end
AddExtOptionsUI(1,"组队增强功能，查找队伍或车队/找队员/换位面/便捷喊话（智能邀请回复）")
AddExtOptionsUI(2,"拾取记录，快速拍卖/出价，补助/罚款记录，分G助手等功能")
AddExtOptionsUI(3,"地下城探险日志",true)