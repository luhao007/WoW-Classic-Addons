local addonName, addonTable = ...;
local L=addonTable.locale
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGSetFont=Create.PIGSetFont
--======================
function Create.About_Update(self,YY,Panel)
	self.Reminder = Create.PIGFontString(self,{"TOP",self,"TOP",0,YY},L["ABOUT_REMINDER"],"OUTLINE",16)
	self.UpdateURLtxt = Create.PIGFontString(self,{"TOPLEFT",self,"TOPLEFT",20,YY-30},L["ABOUT_UPDATEADD"],"OUTLINE",15)
	self.UpdateURL = CreateFrame("EditBox", nil, self, "InputBoxInstructionsTemplate");
	self.UpdateURL:SetSize(460,30);
	self.UpdateURL:SetPoint("LEFT",self.UpdateURLtxt,"RIGHT",0,0);
	PIGSetFont(self.UpdateURL, 16, "OUTLINE");
	self.UpdateURL:SetAutoFocus(false);
	self.UpdateURL:SetText(L["ABOUT_URL"]);
	function self.UpdateURL:SetTextpig()
		self:SetText(L["ABOUT_URL"]);
	end
	self.UpdateURL:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
	self.UpdateURL:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);

	self.Mail = Create.PIGFontString(self,{"TOPLEFT",self.UpdateURLtxt,"BOTTOMLEFT",0,-20},L["ABOUT_MAIL"],"OUTLINE",15)
	if Panel~="Panel" and GetLocale() == "zhCN" then
		self.ShowAuthor = PIGButton(self,{"LEFT",self.Mail,"RIGHT",10,0},{110,24},L["ADDON_AUTHOR"])
		self.ShowAuthor:SetScript("OnClick", function (self)
			Pig_OptionsUI:ShowAuthor()
		end);
	end

	self.Bili = Create.PIGFontString(self,{"TOPLEFT",self.Mail,"BOTTOMLEFT",0,-20},L["ABOUT_BILI"].."\n\n"..L["ABOUT_QQ"],"OUTLINE",15)
	self.Bili:SetJustifyH("LEFT")
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
		UpdateURL:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
		UpdateURL:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);	
	end
end
