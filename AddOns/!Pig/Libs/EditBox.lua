local addonName, addonTable = ...;

local Create = addonTable.Create
-------------------
function Create.InitializeEditBox(EditUI,ShowTXT)
	EditUI:SetTextColor(0.5, 0.5, 0.5, 1);
	EditUI:SetScript("OnEditFocusGained", function(self) 
		self:SetTextColor(1, 1, 1, 1);
	end);
	EditUI:SetScript("OnEditFocusLost", function(self)
		self:SetTextColor(0.5, 0.5, 0.5, 1);
	end);
	EditUI:SetScript("OnEscapePressed", function(self) 
		self:ClearFocus()
	end);
	EditUI:SetScript("OnEnterPressed", function(self) 
		self:ClearFocus()
	end);
	if ShowTXT then EditUI:SetText(ShowTXT) end
end
function Create.IsEditBoxNumber(famsg,msglen,TextNum,TextErr,extbut)
	if msglen>250 then
		if extbut then extbut:Disable() end
		TextNum:SetText("|cffFF0000"..msglen.."|r/|cffFFFFFF250|r")
		TextErr:SetText("|cffFF0000字符超限，无法保存!|r");
		return false,msglen
	else
		if extbut then extbut:Enable() end
		TextNum:SetText("|cffFFFF00"..msglen.."|r/|cffFFFFFF250|r")
		TextErr:SetText();
	end
	return true,msglen
end
function Create.Update_SaveTempF(self,extEdit)
	self.SaveBut:Disable()
	self.error:SetText("")
	if extEdit and extEdit=="" then
		self.error:SetText("内容不能为空")
		return
	end
	local tpname = self.E:GetText():gsub(" ", "")
	if tpname=="" then
		self.error:SetText("模版名不能为空")
		return
	end
	for ixx=1,#PIGA["Tardis"]["Invite"]["YellTemp"] do
		if PIGA["Tardis"]["Invite"]["YellTemp"][ixx][1]==tpname then
			self.error:SetText("已存在同名模版,将覆盖")
			break
		end
	end
	self.SaveBut:Enable()
end