local addonName, addonTable = ...;
local Locale= GetLocale()
local Create = addonTable.Create
local L=addonTable.locale
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont
----------------------------------------
local EnableAddOn=EnableAddOn or C_AddOns and C_AddOns.EnableAddOn
local fuFrame = PIGOptionsList("语音","BOT")
------
local audioName ={"Bobo","Rurutia","Sakura"}
local audioLsit ={}
for i=1,#audioName do
	audioLsit[i]=L.pigname..audioName[i].."Audio"
end
local LocaleLsit = {
	[audioLsit[1]]="饽饽语音包",
	[audioLsit[2]]="露露语音包",
	[audioLsit[3]]="樱雪语音包",
}
if Locale == "zhTW" then
	LocaleLsit[audioLsit[1]]="餑餑語音包"
	LocaleLsit[audioLsit[2]]="露露語音包"
	LocaleLsit[audioLsit[3]]="櫻雪語音包"
elseif Locale == "enUS" then
	LocaleLsit[audioLsit[1]]="BoboAudio"
	LocaleLsit[audioLsit[2]]="RurutiaAudio"
	LocaleLsit[audioLsit[3]]="SakuraAudio"
end
local ADDONS_DOWN_1 = "网易DD(dd.163.com)|cff00FFFF插件库|r"..SEARCH
local AUDIO_Data={
	[audioLsit[1]]={
		["tooltip"]="......",
		["down_1"]=ADDONS_DOWN_1,
	},
	[audioLsit[2]]={
		["tooltip"]="......",
		["down_1"]=ADDONS_DOWN_1,	
	},
	[audioLsit[3]]={
		["tooltip"]="......",
		["down_1"]=ADDONS_DOWN_1,
	},
}
local function add_audioLsitFrame(self,audioID,topV)
	local audioName=audioLsit[audioID]
	local datax=AUDIO_Data[audioName]
	local addnameF=PIGFrame(self,nil,{1,14})
	addnameF:SetPoint("TOPLEFT",self,"TOPLEFT",30,topV);
	addnameF.addnameT = PIGFontString(addnameF,{"LEFT",addnameF,"RIGHT",0,0},"|cff00FFFF"..LocaleLsit[audioName].."|r","OUTLINE",16)
	addnameF.Ver = PIGFontString(addnameF,{"LEFT", addnameF.addnameT, "RIGHT", 0,0},"","OUTLINE",16);
	addnameF.Ver:SetTextColor(0, 1, 0, 1);
	addnameF.err = PIGFontString(addnameF,{"LEFT",addnameF.Ver,"RIGHT",4,0},"","OUTLINE",16)
	addnameF.errbut = PIGButton(addnameF,{"LEFT", addnameF.err, "RIGHT", 0,0},{120,22},"点击启用并重载");
	addnameF.errbut:SetScript("OnClick", function (self)
		EnableAddOn(audioName)
		ReloadUI();
	end)
	addnameF.introduce = PIGFontString(addnameF,{"TOPLEFT", addnameF.addnameT, "BOTTOMLEFT", 0,-10},"音色: "..datax.tooltip,"OUTLINE");
	addnameF.introduce:SetTextColor(0, 1, 0, 1);
	addnameF.UpdateF=PIGFrame(addnameF,{"TOPLEFT",addnameF.introduce,"BOTTOMLEFT",0,-40},{100,10})
	addnameF.UpdateF:SetPoint("TOPLEFT",addnameF.introduce,"BOTTOMLEFT",0,0);
	addnameF.UpdateF.T2 = PIGFontString(addnameF.UpdateF,{"TOPLEFT",addnameF.UpdateF,"BOTTOMLEFT",0,0},datax.down_1,"OUTLINE")
	addnameF.UpdateF.T2:SetTextColor(1, 1, 1, 1);
	addnameF.UpdateF.T2E = CreateFrame("EditBox", nil, addnameF.UpdateF, "InputBoxInstructionsTemplate");
	addnameF.UpdateF.T2E:SetSize(160,20);
	addnameF.UpdateF.T2E:SetPoint("LEFT",addnameF.UpdateF.T2,"RIGHT",4,0);
	PIGSetFont(addnameF.UpdateF.T2E, 15, "OUTLINE");
	addnameF.UpdateF.T2E:SetAutoFocus(false);
	addnameF.UpdateF.T2E:SetTextColor(0, 1, 1, 1);
	function addnameF.UpdateF.T2E:SetTextpig()
		self:SetText(audioName);
	end
	addnameF.UpdateF.T2E:SetTextpig()
	addnameF.UpdateF.T2E:SetScript("OnEditFocusGained", function(self) self:HighlightText() end);
	addnameF.UpdateF.T2E:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
	addnameF.UpdateF.T2E:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);
	addnameF:HookScript("OnShow", function(self)
		self.UpdateF:Hide()
		self.errbut:Hide()
		self.Ver:SetText("");
		self.err:SetTextColor(1, 0, 0, 1);
		local name, title, notes, loadable,reason=PIGGetAddOnInfo(audioName)
		if loadable then
			self.Ver:SetText(PIG_OptionsUI:GetVer_TXT(audioName,"audio"));
			if PIGA["Ver"][audioName]>PIG_OptionsUI:GetVer_NUM(audioName,"audio") then
				self.err:SetText("<已过期>");
				self.UpdateF:Show()
			else
				self.err:SetTextColor(0, 1, 0, 1);
				self.err:SetText("<已加载>");
			end
		else
			if reason=="MISSING" then
				self.err:SetText("<未安装>");
				self.UpdateF:Show()
			elseif reason=="DISABLED" then
				self.err:SetText("<未启用>");
				self.errbut:Show()
			else
				self.err:SetText(reason);
			end
		end
	end)
end
for i=1,#audioName do
	add_audioLsitFrame(fuFrame,i,-100*(i-1)+-30)
end