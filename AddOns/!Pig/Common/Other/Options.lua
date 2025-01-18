local addonName, addonTable = ...;
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
---
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGFontString=Create.PIGFontString
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGModCheckbutton=Create.PIGModCheckbutton
---
local CommonInfo=addonTable.CommonInfo
CommonInfo.Otherfun={}
-----其他
local fujiF =PIGOptionsList_R(CommonInfo.NR,L["COMMON_TABNAME4"],70)

function CommonInfo.Otherfun.ErrorsHide()
	if PIGA["Other"]["ErrorsHide"] then
        UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	else
		UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
	end
end
fujiF.ErrorsHide = PIGCheckbutton_R(fujiF,{"隐藏错误红字提示","隐藏屏幕中间红字错误提示（不隐藏黄字提示）"})
fujiF.ErrorsHide:SetScript("OnClick", function (self)
    if self:GetChecked() then
        PIGA["Other"]["ErrorsHide"]=true;
    else
        PIGA["Other"]["ErrorsHide"]=false;
    end
    CommonInfo.Otherfun.ErrorsHide()
end)
fujiF.PigLoad = PIGCheckbutton_R(fujiF,{"隐藏载入提示","隐藏插件载入提示"})
fujiF.PigLoad:SetScript("OnClick", function (self)
    if self:GetChecked() then
        PIGA["Other"]["PigLoad"]=true;
    else
        PIGA["Other"]["PigLoad"]=false;
    end
end)
--AFK
fujiF.AFK_line = PIGLine(fujiF,"TOP",-420)
fujiF.AFK = PIGModCheckbutton(fujiF,{"离开屏保","启用离开屏保后,离开自动进入屏保功能"},{"TOPLEFT",fujiF.AFK_line,"TOPLEFT",20,-16})
fujiF.AFK:SetScript("OnClick", function (self)
    if self:GetChecked() then
        PIGA["Other"]["AFK"]["Open"]=true;
        CommonInfo.Otherfun.Pig_AFK()
        QuickButUI.ButList[19]()
    else
        PIGA["Other"]["AFK"]["Open"]=false
        Pig_Options_RLtishi_UI:Show()
    end
end)
fujiF.AFK.QKBut:SetScript("OnClick", function (self)
    if self:GetChecked() then
        PIGA["Other"]["AFK"]["QuickBut"]=true
        QuickButUI.ButList[19]()
    else
        PIGA["Other"]["AFK"]["QuickBut"]=false
        Pig_Options_RLtishi_UI:Show()
    end
end)

local function Set_TispTXT(txtui)
    local TispTXT = PIGA["Other"]["AFK"]["TispTXT"] or "临时离开，勿动!!!"
    txtui:SetText(TispTXT)
end
fujiF.AFK.TispTXTt = PIGFontString(fujiF.AFK,{"TOPLEFT", fujiF.AFK, "BOTTOMLEFT", 20,-10},"屏保提示:");
fujiF.AFK.TispTXT = CreateFrame("EditBox", nil, fujiF.AFK,"InputBoxInstructionsTemplate");
fujiF.AFK.TispTXT:SetSize(300,26);
fujiF.AFK.TispTXT:SetPoint("LEFT",fujiF.AFK.TispTXTt,"RIGHT",6,0);
fujiF.AFK.TispTXT:SetFontObject(ChatFontNormal);
fujiF.AFK.TispTXT:SetMaxLetters(20)
fujiF.AFK.TispTXT:SetAutoFocus(false);
fujiF.AFK.TispTXT:SetTextColor(0.7, 0.7, 0.7, 1);
fujiF.AFK.TispTXT:SetScript("OnEditFocusGained", function(self) 
    self:SetTextColor(1, 1, 1, 1);
end);
fujiF.AFK.TispTXT:SetScript("OnEditFocusLost", function(self)
    self:SetTextColor(0.7, 0.7, 0.7, 1);
    Set_TispTXT(self)
end);
fujiF.AFK.TispTXT:SetScript("OnEscapePressed", function(self) 
    self:ClearFocus()
end);
fujiF.AFK.TispTXT:SetScript("OnEnterPressed", function(self) 
    local TispTXT = self:GetText();
    if TispTXT=="" or TispTXT==" " then
        PIGA["Other"]["AFK"]["TispTXT"]=nil
    else
        PIGA["Other"]["AFK"]["TispTXT"]=TispTXT
    end
    CommonInfo.Otherfun.SetAFKTXT()
    self:ClearFocus()
end);
--
fujiF:HookScript("OnShow", function(self)
	self.ErrorsHide:SetChecked(PIGA["Other"]["ErrorsHide"]);
	self.PigLoad:SetChecked(PIGA["Other"]["PigLoad"]);
	self.AFK:SetChecked(PIGA["Other"]["AFK"]["Open"]);
	self.AFK.QKBut:SetChecked(PIGA["Other"]["AFK"]["QuickBut"]);
    Set_TispTXT(self.AFK.TispTXT)
end)
