local addonName, addonTable = ...;
local L=addonTable.locale
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGSetFont=Create.PIGSetFont
--======================
local Aboutdata={
	["Mail"] = "xdfxjf1004@hotmail.com",
	["URL"] = "https://www.curseforge.com/wow/addons/pig",
	["Media"] = "|cffFF00FF哔哩哔哩/抖音|r搜",
	["Author"] = "geligasi",
	["Other"]="QQ群|cff00FFFF27397148|r 2群|cff00FFFF117883385|r YY频道|cff00FFFF113213|r"
}
local function Add_EditBox(fuUI,Point,biaoti,txt,WWW)
	local WWW=WWW or 460
	local EditButBT = Create.PIGFontString(fuUI,Point,biaoti,"OUTLINE",15)
	local EditBut = CreateFrame("EditBox", nil, fuUI, "InputBoxInstructionsTemplate");
	EditBut:SetSize(WWW,30);
	EditBut:SetPoint("LEFT",EditButBT,"RIGHT",4,0);
	PIGSetFont(EditBut, 16, "OUTLINE");
	EditBut:SetTextInsets(6, 0, 0, 0)
	EditBut:SetAutoFocus(false);
	EditBut:HookScript("OnShow", function(self)
		self:SetText(txt);
	end); 
	function EditBut:SetTextpig()
		self:SetText(txt);
	end
	EditBut:SetScript("OnEditFocusGained", function(self) self:HighlightText() end);
	EditBut:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
	EditBut:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);
	return EditButBT,EditBut
end
function Create.About_Update(txtUI,YY,Panel,data)
	local data=data or Aboutdata
	txtUI.Reminder = Create.PIGFontString(txtUI,{"TOP",txtUI,"TOP",0,YY},L["ABOUT_REMINDER"],"OUTLINE",16)
	Add_EditBox(txtUI,{"TOPLEFT",txtUI,"TOPLEFT",20,YY-30},L["ABOUT_UPDATEADD"],data.URL)
	Add_EditBox(txtUI,{"TOPLEFT",txtUI,"TOPLEFT",20,YY-70},L["ABOUT_MAIL"],data.Mail)
	Add_EditBox(txtUI,{"TOPLEFT",txtUI,"TOPLEFT",20,YY-110},L["ABOUT_MEDIA"]..data.Media,data.Author,280)
	if Panel~="Panel" and GetLocale() == "zhCN" then
		txtUI.ShowAuthor = PIGButton(txtUI,{"TOPLEFT",txtUI,"TOPLEFT",20,YY-150},{110,24},L["ADDON_AUTHOR"])
		txtUI.ShowAuthor:SetScript("OnClick", function (self)
			local fujiUI=txtUI:GetParent():GetParent():GetParent():GetParent()
			fujiUI:ShowAuthor()
		end);
		if data.Other then
			txtUI.Other = Create.PIGFontString(txtUI,{"LEFT",txtUI.ShowAuthor,"RIGHT",20,0},data.Other,"OUTLINE",15)
			txtUI.Other:SetJustifyH("LEFT")
		end
	end
end
function Create.About_Thanks(self,YY)
	self.tks = Create.PIGFontString(self,{"TOP",self,"TOP",0,YY},L["ABOUT_OTHERADDONS"],"OUTLINE",16)
	for i=1,#L["ABOUT_OTHERADDON_LIST"] do
		local addname_ot = CreateFrame("EditBox", nil, self, "InputBoxInstructionsTemplate");
		addname_ot:SetSize(120,30);
		if i==1 then
			addname_ot:SetPoint("TOPLEFT",self,"TOPLEFT",20,YY-30);
		else
			addname_ot:SetPoint("TOPLEFT",self,"TOPLEFT",20,YY-70*(i-1)-30);
		end
		PIGSetFont(addname_ot, 15, "OUTLINE");
		addname_ot:SetAutoFocus(false);
		addname_ot:SetText(L["ABOUT_OTHERADDON_LIST"][i][1]);
		function addname_ot:SetTextpig()
			self:SetText(L["ABOUT_OTHERADDON_LIST"][i][1]);
		end
		addname_ot:SetScript("OnEditFocusGained", function(self) self:HighlightText() end);
		addname_ot:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
		addname_ot:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);
		local pigaddname = Create.PIGFontString(self,{"LEFT",addname_ot,"RIGHT",10,0},L["ABOUT_OTHERADDON_LIST"][i][2]..L["ABOUT_OTHERADDONS_DOWN"],"OUTLINE",15)

		local UpdateURLtxt = Create.PIGFontString(self,{"TOPLEFT",addname_ot,"BOTTOMLEFT",0,-6},L["ABOUT_UPDATEADD"],"OUTLINE",15)
		local UpdateURL = CreateFrame("EditBox", nil, self, "InputBoxInstructionsTemplate");
		UpdateURL:SetSize(500,30);
		UpdateURL:SetPoint("LEFT",UpdateURLtxt,"RIGHT",0,0);
		PIGSetFont(UpdateURL, 16, "OUTLINE");
		UpdateURL:SetAutoFocus(false);
		UpdateURL:SetText(L["ABOUT_OTHERADDON_LIST"][i][3]);
		function UpdateURL:SetTextpig()
			self:SetText(L["ABOUT_OTHERADDON_LIST"][i][3]);
		end
		UpdateURL:SetScript("OnEditFocusGained", function(self) self:HighlightText() end);
		UpdateURL:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
		UpdateURL:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);	
	end
end
