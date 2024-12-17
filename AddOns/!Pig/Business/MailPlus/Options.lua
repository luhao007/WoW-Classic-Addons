local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local fmod=math.fmod
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGQuickBut=Create.PIGQuickBut
local PIGLine=Create.PIGLine
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
------
local BusinessInfo=addonTable.BusinessInfo
local Data=addonTable.Data
local fuFrame,fuFrameBut = BusinessInfo.fuFrame,BusinessInfo.fuFrameBut

local GnName,GnUI,GnIcon,FrameLevel = MINIMAP_TRACKING_MAILBOX.."助手","MailPlus_UI",134939,10
BusinessInfo.MailPlusData={GnName,GnUI,GnIcon,FrameLevel}
------------
local PIG_OPEN_ALL_MAIL_MIN_DELAY=1
function BusinessInfo.MailPlusOptions()
	PIG_OPEN_ALL_MAIL_MIN_DELAY=PIGA["MailPlus"]["OpenAllCD"]
	fuFrame.MailPlus_line = PIGLine(fuFrame,"TOP",-(fuFrame.dangeH*fuFrame.GNNUM))
	fuFrame.GNNUM=fuFrame.GNNUM+2
	------
	local Tooltip = {GnName,"增强你的邮箱界面，方便你查看邮箱物品"};
	fuFrame.MailPlus = PIGCheckbutton(fuFrame,{"TOPLEFT",fuFrame.MailPlus_line,"TOPLEFT",20,-30},Tooltip)
	fuFrame.MailPlus:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["MailPlus"]["Open"]=true;
			BusinessInfo.MailPlus_ADDUI()
		else
			PIGA["MailPlus"]["Open"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
	end);
	fuFrame.MailPlus.ScanSliderT = PIGFontString(fuFrame.MailPlus,{"LEFT",fuFrame.MailPlus.Text,"RIGHT",40,0},"批量取件间隔/s")
	fuFrame.MailPlus.ScanSlider = PIGSlider(fuFrame.MailPlus,{"LEFT",fuFrame.MailPlus.ScanSliderT,"RIGHT",0,0},{0.15,1,0.01})
	fuFrame.MailPlus.ScanSlider.Slider:HookScript("OnValueChanged", function(self, arg1)
		PIG_OPEN_ALL_MAIL_MIN_DELAY=arg1
		PIGA["MailPlus"]["OpenAllCD"]=arg1
	end)
	--------
	fuFrame:HookScript("OnShow", function (self)
		self.MailPlus:SetChecked(PIGA["MailPlus"]["Open"])
		self.MailPlus.ScanSlider:PIGSetValue(PIGA["MailPlus"]["OpenAllCD"])
	end);
	BusinessInfo.MailPlus_ADDUI()
end
function BusinessInfo.MailPlus_ADDUI()
	if not PIGA["MailPlus"]["Open"] then return end
	----
	local boxitemdata = {["boxbutNum"]=64,["meihang"]=8}
	local function ClearBut(lyID)
		if lyID==2 or lyID==3 then
			InboxFrame.ItemBox.PrevPageBut:Disable();
			InboxFrame.ItemBox.NextPageBut:Disable();
			for i=1,boxitemdata.boxbutNum do
				local itemBut=_G["Mail_InboxBut_"..i]
				itemBut:Hide()
				itemBut.TimeLeft:Hide()
				itemBut.Num:SetText("")
				itemBut.LV:SetText("");
				itemBut:SetScript("OnEnter", nil);
				itemBut:SetScript("OnClick", nil)
			end
		end
	end
	local function SetTooltipFrom(FROMname,MONEY)
		local TimeLeft = MONEY
		if ( TimeLeft >= 1 ) then
			TimeLeft = GREEN_FONT_COLOR_CODE..format(DAYS_ABBR, floor(TimeLeft)).." "..FONT_COLOR_CODE_CLOSE;
		else
			TimeLeft = RED_FONT_COLOR_CODE..SecondsToTime(floor(TimeLeft * 24 * 60 * 60))..FONT_COLOR_CODE_CLOSE;
		end
		GameTooltip:AddLine(FROM..GREEN_FONT_COLOR_CODE..FROMname..FONT_COLOR_CODE_CLOSE..", "..TIME_REMAINING..TimeLeft)
	end
	local function Show_ItemList()
		if not InboxFrame:IsShown() then return end
		local lyID=InboxFrame.PIG_Select
		ClearBut(lyID)
		local mailData = {{},{},0}
		local numItems, totalItems = GetInboxNumItems();
		for i=1, numItems do
			local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, itemCount, wasRead, wasReturned, textCreated, canReply, isGM = GetInboxHeaderInfo(i);
			if (itemCount and CODAmount == 0) then
				for n=1,ATTACHMENTS_MAX_RECEIVE do
					local ItemLink=GetInboxItemLink(i, n);
					if ItemLink then
						local _, itemID, _, count = GetInboxItem(i, n);
						table.insert(mailData[1], {ItemLink,count,i, n,sender,daysLeft,itemID});
					end
				end
			end
			if (money>0 and CODAmount == 0) then
				mailData[3]=mailData[3]+money
				table.insert(mailData[2], {money,i,sender,daysLeft});
			end
		end
		if not InboxFrame.PIG_MoneyG then
			InboxFrame.PIG_MoneyG=mailData[3] or 0
		end
		if lyID==2 then
			local zongshunum = 1
			if #mailData[1]>1 then
				zongshunum=#mailData[1]
			end
			local zongyeshu = math.ceil(zongshunum/boxitemdata.boxbutNum)
			InboxFrame.ItemBox.yema:SetText(InboxFrame.ItemBox.pageNum.."/"..zongyeshu)
			local kaishixulie=1+(InboxFrame.ItemBox.pageNum-1)*boxitemdata.boxbutNum
			local jieshuxulie=InboxFrame.ItemBox.pageNum*boxitemdata.boxbutNum
			if kaishixulie>boxitemdata.boxbutNum then
				InboxFrame.ItemBox.PrevPageBut:Enable()
			end
			if jieshuxulie<zongshunum then
				InboxFrame.ItemBox.NextPageBut:Enable()
			end
			for i=1,boxitemdata.boxbutNum do
				local dangqian = i+kaishixulie-1
				if mailData[1][dangqian] then
					local itemBut=_G["Mail_InboxBut_"..i]
					itemBut:Show()
					local itemName,itemLink,itemQuality,itemLevel,itemMinLevel,itemType,itemSubType,itemStackCount,itemEquipLoc,itemTexture,sellPrice,classID=GetItemInfo(mailData[1][dangqian][1]);
					if not itemLink then
						C_Timer.After(0.6,function() Show_ItemList() end)
						return
					end
					SetItemButtonTexture(itemBut, itemTexture)
					local TimeLeft=mailData[1][i][6]
					if TimeLeft<3 then
						itemBut.TimeLeft:Show()
					end
					if itemStackCount>1 then
						itemBut.Num:SetText(mailData[1][dangqian][2])
					end
					if classID==2 or classID==4 then
						local effectiveILvl = GetDetailedItemLevelInfo(itemLink)	
						if effectiveILvl and effectiveILvl>0 then
							itemBut.LV:SetText(effectiveILvl)
							local quality = C_Item.GetItemQualityByID(itemLink)
							local r, g, b, hex = GetItemQualityColor(quality)
							itemBut.LV:SetTextColor(r, g, b, 1);
						end
					end
					itemBut:SetScript("OnEnter", function (self)
						GameTooltip:ClearLines();
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
						GameTooltip:SetInboxItem(mailData[1][dangqian][3], mailData[1][dangqian][4]);
						SetTooltipFrom(mailData[1][i][5],TimeLeft)
						GameTooltip:Show();
					end);
					itemBut:SetScript("OnClick", function ()
						if IsShiftKeyDown() then
							local editBox = ChatEdit_ChooseBoxForSend();
							local hasText = editBox:GetText()..itemLink
							if editBox:HasFocus() then
								editBox:SetText(hasText);
							else
								ChatEdit_ActivateChat(editBox)
								editBox:SetText(hasText);
							end
						elseif IsControlKeyDown() then
							HandleModifiedItemClick(itemLink);
						elseif IsAltKeyDown() then
							InboxFrame.OnekeyTake:StartOpening(3,mailData[1][dangqian][7])
						else
							TakeInboxItem(mailData[1][dangqian][3], mailData[1][dangqian][4]);
						end
					end)
				end
			end
		elseif lyID==3 then
			for i=1,boxitemdata.boxbutNum do
				if mailData[2][i] then
					local itemBut=_G["Mail_InboxBut_"..i]
					itemBut:Show()
					if mailData[2][i][4]<3 then
						itemBut.TimeLeft:Show()
					end
					if mailData[2][i][1]<100 then
						SetItemButtonTexture(itemBut, 133789)
						itemBut.Num:SetText(mailData[2][i][1])
					elseif mailData[2][i][1]<10000 then
						SetItemButtonTexture(itemBut, 133787)
						itemBut.Num:SetText(floor(mailData[2][i][1]*0.01))
					else
						SetItemButtonTexture(itemBut, 133784)
						itemBut.Num:SetText(floor(mailData[2][i][1]*0.0001))
					end
					itemBut:SetScript("OnEnter", function (self)
						GameTooltip:ClearLines();
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
						SetTooltipMoney(GameTooltip, mailData[2][i][1]);
						SetTooltipFrom(mailData[2][i][3],mailData[2][i][4])
						GameTooltip:Show();
					end);
					itemBut:SetScript("OnClick", function ()
						TakeInboxMoney(mailData[2][i][2]);
					end)
				end
			end
			InboxFrame.ItemBox.quchuMV:SetText(GetMoneyString(InboxFrame.PIG_MoneyG-mailData[3]).." (|cff00FF00剩:|r"..GetMoneyString(mailData[3])..")")
		end
	end

	--移动游戏已满提示
	InboxTooMuchMail:ClearAllPoints();
	InboxTooMuchMail:SetPoint("TOP",InboxFrame,"TOP",0,-50);
	----TAB---
	local SizePointData = {60,25,60,-30}
	InboxFrame.mulubut = PIGButton(InboxFrame,{"TOPLEFT", InboxFrame, "TOPLEFT", SizePointData[3], SizePointData[4]},{SizePointData[1],SizePointData[2]},"目录",nil,nil,nil,nil,0)
	InboxFrame.itembut = PIGButton(InboxFrame,{"LEFT", InboxFrame.mulubut, "RIGHT", 10, 0},{SizePointData[1],SizePointData[2]},ITEMS,nil,nil,nil,nil,0)
	InboxFrame.moneybut = PIGButton(InboxFrame,{"LEFT", InboxFrame.itembut, "RIGHT", 10, 0},{SizePointData[1],SizePointData[2]},MONEY,nil,nil,nil,nil,0)
	if not ElvUI and not NDui then
		InboxFrame.mulubut:PIGHighlight()
		InboxFrame.itembut:PIGHighlight()
		InboxFrame.moneybut:PIGHighlight()
	end
	InboxFrame.Delbut = Create.PIGDiyBut(InboxFrame,{"TOPRIGHT",InboxFrame,"TOPRIGHT",-64,-30},{25,nil,25,nil,"bags-button-autosort-up"})

	local isTrialOrVeteran = GameLimitedMode_IsActive();
	InboxFrame.mulubut:SetShown(not isTrialOrVeteran);
	InboxFrame.itembut:SetShown(not isTrialOrVeteran);
	InboxFrame.moneybut:SetShown(not isTrialOrVeteran);
	InboxFrame.Delbut:SetShown(not isTrialOrVeteran);

	InboxFrame.mulubut:HookScript("OnClick", function (self)
		InboxFrame.PIG_Select=1
		InboxFrame:Show_tabList()
	end);
	InboxFrame.itembut:HookScript("OnClick", function (self)
		InboxFrame.PIG_Select=2
		InboxFrame:Show_tabList()
	end);
	InboxFrame.moneybut:HookScript("OnClick", function (self)
		InboxFrame.PIG_Select=3
		InboxFrame:Show_tabList()
	end);
	InboxFrame.Delbut:SetScript("OnClick", function (self)
		StaticPopup_Show ("MAIL_PLUS_DELNONEMAIL");
	end);
	function InboxFrame:Show_tabList(id)
		for i=1,INBOXITEMS_TO_DISPLAY do
			_G["MailItem"..i]:Hide()
		end
		InboxPrevPageButton:Hide()
		InboxNextPageButton:Hide()
		OpenAllMail:Hide()
		InboxFrame.OpenSelect:Hide()
		InboxFrame.OpenAH:Hide()
		InboxFrame.ItemBox:Hide()
		InboxFrame.ItemBox.PrevPageBut:Hide()
		InboxFrame.ItemBox.NextPageBut:Hide()
		InboxFrame.ItemBox.yema:Hide()
		InboxFrame.ItemBox.quchuM:Hide()
		InboxFrame.ItemBox.quchuMV:Hide()
		InboxFrame.ItemBox.QuMoney:Hide()
		InboxFrame.ItemBox.piliangtis:Hide()
		InboxFrame.mulubut:Selected(false)
		InboxFrame.itembut:Selected(false)
		InboxFrame.moneybut:Selected(false)

		if InboxFrame.PIG_Select==1 then
			InboxFrame.mulubut:Selected(true)
			for i=1,INBOXITEMS_TO_DISPLAY do
				_G["MailItem"..i]:Show()
			end
			InboxPrevPageButton:Show()
			InboxNextPageButton:Show()
			OpenAllMail:Show()
			InboxFrame.OpenSelect:Show()
			InboxFrame.OpenAH:Show()
		elseif InboxFrame.PIG_Select==2 then
			InboxFrame.itembut:Selected(true)
			Show_ItemList()
			InboxFrame.ItemBox.PrevPageBut:Show()
			InboxFrame.ItemBox.NextPageBut:Show()
			InboxFrame.ItemBox.yema:Show()
			InboxFrame.ItemBox:Show()
			InboxFrame.ItemBox.piliangtis:Show()
		elseif InboxFrame.PIG_Select==3 then
			InboxFrame.moneybut:Selected(true)
			Show_ItemList()
			InboxFrame.ItemBox:Show()
			InboxFrame.ItemBox.quchuM:Show()
			InboxFrame.ItemBox.quchuMV:Show()
			InboxFrame.ItemBox.QuMoney:Show()
		end
	end
	StaticPopupDialogs["MAIL_PLUS_DELNONEMAIL"] = {
		text = "此操作将|cffff0000清理所有不包含附件(已读)|r的邮件。\n确定清理吗?",
		button1 = YES,
		button2 = NO,
		OnAccept = function() InboxFrame.OnekeyTake:StartOpening(1) end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	---bot--
	_G["MailItem1"]:SetPoint("TOPLEFT",InboxFrame,"TOPLEFT",40,-78);
	for i=1, INBOXITEMS_TO_DISPLAY do
		local hang = _G["MailItem"..i];
		hang:SetScale(0.92)
		hang.SelectCheck=PIGCheckbutton(hang,{"RIGHT",hang,"LEFT",-4,0},nil,{20},nil,nil,0)
		hang.SelectCheck:SetScript("OnClick", function (self)
			local button = self:GetParent().Button
			if self:GetChecked() then
				InboxFrame.OnekeyTake.Openindex[button.index]=true
			else
				InboxFrame.OnekeyTake.Openindex[button.index]=false;
			end
			for _,vvv in pairs(InboxFrame.OnekeyTake.Openindex) do
				if vvv then
					InboxFrame.OpenSelect:Enable();
					return
				end
			end
			InboxFrame.OpenSelect:Disable();
		end);
	end
	local function Reset_Checked()
		local numItems, totalItems = GetInboxNumItems();
		local index = ((InboxFrame.pageNum - 1) * INBOXITEMS_TO_DISPLAY) + 1;
		for i=1, INBOXITEMS_TO_DISPLAY do
			local button = _G["MailItem"..i].SelectCheck
			if ( index <= numItems ) then
				button:Show();
				if InboxFrame.OnekeyTake.Openindex[index] then
					button:SetChecked(true)
				else
					button:SetChecked(false)
				end
			else
				button:Hide();
			end
			index = index + 1;
		end
	end
	hooksecurefunc("InboxFrame_Update", function()
		Reset_Checked()
	end)
	OpenAllMail:SetSize(84,24);
	OpenAllMail:SetPoint("CENTER",InboxFrame,"BOTTOM",-25,108);
	InboxPrevPageButton:SetPoint("CENTER",InboxFrame,"BOTTOMLEFT",30,108);
	InboxNextPageButton:SetPoint("CENTER",InboxFrame,"BOTTOMLEFT",305,108);
	InboxFrame.OpenSelect = PIGButton(InboxFrame,{"CENTER",InboxFrame,"BOTTOM",-110,136},{84,24},UNWRAP..CHOOSE,nil,nil,nil,nil,0)
	InboxFrame.OpenSelect:HookScript("OnClick", function (self)
		InboxFrame.OnekeyTake:StartOpening(4)
	end);
	InboxFrame.OpenAH = PIGButton(InboxFrame,{"CENTER",InboxFrame,"BOTTOM",60,136},{84,24},UNWRAP..AUCTIONS,nil,nil,nil,nil,0)
	InboxFrame.OpenAH:HookScript("OnClick", function (self)
		InboxFrame.OnekeyTake:StartOpening(5)
	end);

	-----
	InboxFrame.ItemBox = CreateFrame("Frame", nil, InboxFrame);
	InboxFrame.ItemBox:SetSize(384,512);
	InboxFrame.ItemBox:SetPoint("TOPLEFT", InboxFrame, "TOPLEFT", 0, 0);
	InboxFrame.ItemBox.pageNum=1
	for i=1,boxitemdata.boxbutNum do
		local itemBut
		if tocversion<100000 then
			itemBut = CreateFrame("Button", "Mail_InboxBut_"..i, InboxFrame.ItemBox);
			itemBut:SetHighlightTexture(130718);
			itemBut.icon = itemBut:CreateTexture()
			itemBut.icon:SetAllPoints(itemBut)
		else
			itemBut = CreateFrame("ItemButton", "Mail_InboxBut_"..i, InboxFrame.ItemBox);
			itemBut.NormalTexture:Hide()
		end
		itemBut:SetSize(36,36);
		itemBut:Hide()
		itemBut:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		if i==1 then
			itemBut:SetPoint("TOPLEFT",InboxFrame.ItemBox,"TOPLEFT",12,-70);
		else
			local yushu=fmod(i-1,boxitemdata.meihang)
			if yushu==0 then
				itemBut:SetPoint("TOPLEFT",_G["Mail_InboxBut_"..(i-boxitemdata.meihang)],"BOTTOMLEFT",0,-2);
			else
				itemBut:SetPoint("LEFT",_G["Mail_InboxBut_"..(i-1)],"RIGHT",3,0);
			end
		end
		itemBut.TimeLeft = itemBut:CreateTexture(nil, "OVERLAY");
		itemBut.TimeLeft:SetTexture("interface/helpframe/helpicon-reportlag.blp");
		itemBut.TimeLeft:SetSize(28,28);
		itemBut.TimeLeft:SetPoint("TOPRIGHT", itemBut, "TOPRIGHT", 6,6);
		itemBut.LV = PIGFontString(itemBut,{"TOPLEFT", itemBut, "TOPLEFT", 0,1},nil,"OUTLINE")
		itemBut.Num =PIGFontString(itemBut,{"BOTTOMRIGHT", itemBut, "BOTTOMRIGHT", 1,2},nil,"OUTLINE")
		itemBut.Num:SetTextColor(1, 1, 1, 1);
		itemBut.Num:SetSize(40,14);
		itemBut.Num:SetJustifyH("RIGHT")
	end
	InboxFrame.ItemBox.PrevPageBut = CreateFrame("Button",nil,InboxFrame.ItemBox);
	InboxFrame.ItemBox.PrevPageBut:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Up")
	InboxFrame.ItemBox.PrevPageBut:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Down")
	InboxFrame.ItemBox.PrevPageBut:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Disabled")
	InboxFrame.ItemBox.PrevPageBut:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight");
	InboxFrame.ItemBox.PrevPageBut:SetSize(32,32);
	InboxFrame.ItemBox.PrevPageBut:SetPoint("BOTTOMLEFT", InboxFrame.ItemBox, "BOTTOMLEFT", 30, 96);
	InboxFrame.ItemBox.PrevPageBut:HookScript("OnClick", function (self)
		InboxFrame.ItemBox.pageNum=InboxFrame.ItemBox.pageNum-1
		Show_ItemList()
	end);
	PIGFontString(InboxFrame.ItemBox.PrevPageBut,{"LEFT", InboxFrame.ItemBox.PrevPageBut, "RIGHT", 0, 0},PREV,"OUTLINE")
	InboxFrame.ItemBox.yema=PIGFontString(InboxFrame.ItemBox,{"BOTTOM", InboxFrame.ItemBox, "BOTTOM", -20, 105},"1/1","OUTLINE")
	InboxFrame.ItemBox.NextPageBut = CreateFrame("Button",nil,InboxFrame.ItemBox);
	InboxFrame.ItemBox.NextPageBut:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Up")
	InboxFrame.ItemBox.NextPageBut:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Down")
	InboxFrame.ItemBox.NextPageBut:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Disabled")
	InboxFrame.ItemBox.NextPageBut:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight");
	InboxFrame.ItemBox.NextPageBut:SetSize(32,32);
	InboxFrame.ItemBox.NextPageBut:SetPoint("BOTTOMRIGHT", InboxFrame.ItemBox, "BOTTOMRIGHT", -80, 96);
	InboxFrame.ItemBox.NextPageBut:HookScript("OnClick", function (self)
		InboxFrame.ItemBox.pageNum=InboxFrame.ItemBox.pageNum+1
		Show_ItemList()
	end);
	PIGFontString(InboxFrame.ItemBox.NextPageBut,{"RIGHT", InboxFrame.ItemBox.NextPageBut, "LEFT", 0, 0},NEXT,"OUTLINE")
	InboxFrame.ItemBox.piliangtis =PIGFontString(InboxFrame.ItemBox,{"BOTTOM", InboxFrame.ItemBox, "BOTTOM", -24, 124},"按住ALT键可批量取出相同物品","OUTLINE")
	InboxFrame.ItemBox.piliangtis:SetTextColor(0, 1, 1, 1);
	InboxFrame.ItemBox.quchuM =PIGFontString(InboxFrame.ItemBox,{"BOTTOMLEFT", InboxFrame.ItemBox, "BOTTOMLEFT", 10,108},"本次取:","OUTLINE")
	InboxFrame.ItemBox.quchuMV =PIGFontString(InboxFrame.ItemBox,{"LEFT", InboxFrame.ItemBox.quchuM, "RIGHT", 4,0},0,"OUTLINE")
	InboxFrame.ItemBox.quchuMV:SetTextColor(1, 1, 1, 1);
	InboxFrame.ItemBox.QuMoney =PIGButton(InboxFrame.ItemBox,{"BOTTOMRIGHT", InboxFrame.ItemBox, "BOTTOMRIGHT", -58,104},{74,24},GUILDCONTROL_OPTION16,nil,nil,nil,nil,0)
	InboxFrame.ItemBox.QuMoney:SetScript("OnClick", function (self)
		InboxFrame.OnekeyTake:StartOpening(2)
	end)
	---
	InboxFrame.OnekeyTake = CreateFrame("Frame",nil,InboxFrame)
	function InboxFrame.OnekeyTake:Reset()	
		self.timeUntilNextRetrieval = nil;
		self.blacklistedItemIDs = nil;
		self.QuchuMode= nil;
		self.QuItemID= nil;
		self.attachmentIndex = ATTACHMENTS_MAX;
		InboxFrame.OnekeyTake.Openindex={}
		Reset_Checked()
		InboxFrame.OpenSelect:Disable();
	end
	function InboxFrame.OnekeyTake:StartOpening(MODE,itemID)
		self.QuchuMode=MODE
		self.QuItemID=itemID
		self.mailIndex = GetInboxNumItems()
		InboxFrame.mulubut:Disable();
		InboxFrame.itembut:Disable();
		InboxFrame.moneybut:Disable();
		InboxFrame.Delbut:Disable();
		InboxFrame.OpenSelect:Disable();
		InboxFrame.OpenAH:Disable();
		InboxFrame.ItemBox.QuMoney:Disable();
		InboxFrame.OpenSelect:SetText(OPEN_ALL_MAIL_BUTTON_OPENING);
		InboxFrame.OpenAH:SetText(OPEN_ALL_MAIL_BUTTON_OPENING);
		InboxFrame.ItemBox.QuMoney:SetText(OPEN_ALL_MAIL_BUTTON_OPENING);
		self:RegisterEvent("MAIL_FAILED");
		self:AdvanceAndProcessNextItem();
	end
	function InboxFrame.OnekeyTake:StopOpening()
		self:Reset();
		InboxFrame.mulubut:Enable();
		InboxFrame.itembut:Enable();
		InboxFrame.moneybut:Enable();
		InboxFrame.Delbut:Enable();
		InboxFrame.OpenAH:Enable();
		InboxFrame.ItemBox.QuMoney:Enable();
		InboxFrame.OpenSelect:SetText(UNWRAP..CHOOSE);
		InboxFrame.OpenAH:SetText(UNWRAP..AUCTIONS);
		InboxFrame.ItemBox.QuMoney:SetText(GUILDCONTROL_OPTION16);
		self:UnregisterEvent("MAIL_FAILED");
	end
	function InboxFrame.OnekeyTake:AdvanceToNextItem()
		if ( self.mailIndex <1 ) then
			return false;
		end
		if self.attachmentIndex>0 then
			local _, _, sender, _, money, CODAmount, daysLeft, itemCount, wasRead, _, _, _, isGM = GetInboxHeaderInfo(self.mailIndex);
			local hasCOD = CODAmount and CODAmount > 0;
			if not hasCOD then
				--local hasMoney = C_Mail.HasInboxMoney(self.mailIndex)
				--local hasItem = HasInboxItem(self.mailIndex, self.attachmentIndex);
				local itemID = select(2, GetInboxItem(self.mailIndex, self.attachmentIndex));
				if self.QuchuMode==1 then--清理空邮件
					if InboxItemCanDelete(self.mailIndex) then	
						if wasRead and money==0 and not itemCount then
							return true;
						end
					end
				elseif self.QuchuMode==2 then--取金币
					if money>0 then return true end
				elseif self.QuchuMode==3 then--批量取相同物品	
					if itemID and itemID==self.QuItemID and not self:IsItemBlacklisted(itemID) then
						return true;
					else
						self.attachmentIndex = self.attachmentIndex - 1;
						if ( self.attachmentIndex>0 ) then
							return self:AdvanceToNextItem();
						end
					end	
				elseif self.QuchuMode==4 then--取选中邮件
					if self.Openindex[self.mailIndex] then
						if money>0 then
							return true 
						else
							if itemID and not self:IsItemBlacklisted(itemID) then
								return true;
							else
								self.attachmentIndex = self.attachmentIndex - 1;
								if ( self.attachmentIndex>0 ) then
									return self:AdvanceToNextItem();
								end
							end
						end
					end
				elseif self.QuchuMode==5 then--取拍卖行邮件
					local invoiceType, itemName, playerName, bid, buyout, deposit, consignment = GetInboxInvoiceInfo(self.mailIndex)
					local AHfrom = sender==BLACK_MARKET_AUCTION_HOUSE or sender==FACTION_ALLIANCE..BUTTON_LAG_AUCTIONHOUSE or sender==FACTION_HORDE..BUTTON_LAG_AUCTIONHOUSE 
					if invoiceType or AHfrom then
						if money>0 then
							return true 
						else
							if itemID and not self:IsItemBlacklisted(itemID) then
								return true;
							else
								self.attachmentIndex = self.attachmentIndex - 1;
								if ( self.attachmentIndex>0 ) then
									return self:AdvanceToNextItem();
								end
							end
						end
					end
				end
			end
		end
		self.mailIndex = self.mailIndex - 1;
		self.attachmentIndex = ATTACHMENTS_MAX_RECEIVE;
		return self:AdvanceToNextItem();
	end
	function InboxFrame.OnekeyTake:AdvanceAndProcessNextItem()
		if ( CalculateTotalNumberOfFreeBagSlots() == 0 ) then
			self:StopOpening();
			return;
		end
		if self:AdvanceToNextItem() then
			self:ProcessNextItem();
		else
			self:StopOpening();
		end
	end
	function InboxFrame.OnekeyTake:ProcessNextItem()
		local _, _, _, _, money, CODAmount, daysLeft, itemCount, wasRead, _, _, _, isGM = GetInboxHeaderInfo(self.mailIndex);
		if CODAmount and CODAmount > 0 then
			self.mailIndex = self.mailIndex - 1;
			self:AdvanceAndProcessNextItem();
			return;
		end
		if self.QuchuMode==1 then
			--print("清理空邮件:"..self.mailIndex)
			DeleteInboxItem(self.mailIndex);
			self.timeUntilNextRetrieval = PIG_OPEN_ALL_MAIL_MIN_DELAY;
			self.mailIndex = self.mailIndex - 1;
		elseif self.QuchuMode==2 then
			if ( money > 0 ) then
				--print("拿取金币:"..self.mailIndex)
				TakeInboxMoney(self.mailIndex);
				self.timeUntilNextRetrieval = PIG_OPEN_ALL_MAIL_MIN_DELAY;
				self.mailIndex = self.mailIndex - 1;
			else
				self.mailIndex = self.mailIndex - 1;
				self:AdvanceAndProcessNextItem();
			end
		elseif self.QuchuMode==3 then
			if ( itemCount and itemCount > 0 ) then
				--print("拿取指定物品:"..self.mailIndex, self.attachmentIndex)
				TakeInboxItem(self.mailIndex, self.attachmentIndex);
				self.timeUntilNextRetrieval = PIG_OPEN_ALL_MAIL_MIN_DELAY;
				self.attachmentIndex = self.attachmentIndex - 1;
			else
				self.mailIndex = self.mailIndex - 1;
				self:AdvanceAndProcessNextItem();
			end
		elseif self.QuchuMode==4 then
			if ( money > 0 ) then
				TakeInboxMoney(self.mailIndex);
				self.timeUntilNextRetrieval = PIG_OPEN_ALL_MAIL_MIN_DELAY;
			elseif ( itemCount and itemCount > 0 ) then
				TakeInboxItem(self.mailIndex, self.attachmentIndex);
				self.timeUntilNextRetrieval = PIG_OPEN_ALL_MAIL_MIN_DELAY;
				self.attachmentIndex = self.attachmentIndex - 1;
			else
				self.mailIndex = self.mailIndex - 1;
				self:AdvanceAndProcessNextItem();
			end
		elseif self.QuchuMode==5 then
			if ( money > 0 ) then
				TakeInboxMoney(self.mailIndex);
				self.timeUntilNextRetrieval = PIG_OPEN_ALL_MAIL_MIN_DELAY;
			elseif ( itemCount and itemCount > 0 ) then
				TakeInboxItem(self.mailIndex, self.attachmentIndex);
				self.timeUntilNextRetrieval = PIG_OPEN_ALL_MAIL_MIN_DELAY;
				self.attachmentIndex = self.attachmentIndex - 1;
			else
				self.mailIndex = self.mailIndex - 1;
				self:AdvanceAndProcessNextItem();
			end
		end
	end
	function InboxFrame.OnekeyTake:AddBlacklistedItem(itemID)
		if ( not self.blacklistedItemIDs ) then
			self.blacklistedItemIDs = {};
		end
		self.blacklistedItemIDs[itemID] = true;
	end
	function InboxFrame.OnekeyTake:IsItemBlacklisted(itemID)
		return self.blacklistedItemIDs and self.blacklistedItemIDs[itemID];
	end
	InboxFrame.OnekeyTake:SetScript("OnUpdate", function(self,dt)
		if ( self.timeUntilNextRetrieval ) then
			self.timeUntilNextRetrieval = self.timeUntilNextRetrieval - dt;
			if ( self.timeUntilNextRetrieval <= 0 ) then
				if C_Mail.IsCommandPending() then
					self.timeUntilNextRetrieval = PIG_OPEN_ALL_MAIL_MIN_DELAY;
				else
					self.timeUntilNextRetrieval = nil;
					self:AdvanceAndProcessNextItem();
				end
			end
		end
	end)
	InboxFrame.OnekeyTake:SetScript("OnEvent", function(self,event, ...)
		if ( event == "MAIL_FAILED" ) then
			local itemID = ...;
			if ( itemID ) then
				self:AddBlacklistedItem(itemID);
			end
		end
	end)
	-----
	InboxFrame:SetScript("OnHide", function(self)
		self.OnekeyTake:StopOpening();
	end)
	InboxFrame:HookScript("OnShow", function (self)
		InboxFrame.OnekeyTake:Reset()
		InboxFrame.PIG_Select=1
		InboxFrame.PIG_MoneyG=nil
		InboxFrame:Show_tabList()
	end);
	MailFrame:HookScript("OnEvent", function(self,event)
		if event == "MAIL_INBOX_UPDATE" then
			Show_ItemList()
		end
	end)
	---发件页===================
	local collW,collY,collhang_Width, hang_Height = 20,20,200,20
	SendMailFrame.coll = CreateFrame("Button",nil,SendMailFrame);
	local coll=SendMailFrame.coll
	coll:SetSize(collW,collY);
	coll:SetPoint("TOPRIGHT",SendMailFrame,"TOPRIGHT",-86,0);
	coll:SetFrameLevel(coll:GetFrameLevel()+500)
	coll.TexC = coll:CreateTexture();
	coll.TexC:SetTexture("interface/common/friendship-heart.blp");
	coll.TexC:SetSize(collW*1.64,collY*1.5);
	coll.TexC:SetPoint("CENTER",coll,"CENTER",0,-2);
	coll:SetScript("OnMouseDown", function (self)
		self.TexC:SetPoint("CENTER",coll,"CENTER",1.5,-3.5);
	end);
	coll:SetScript("OnMouseUp", function (self)
		self.TexC:SetPoint("CENTER",coll,"CENTER",0,-2);
	end);
	coll:SetScript("OnClick", function (self)
		if self.list:IsShown() then
			self.list:Hide()
		else
			self.list:Show()
		end
	end);
	coll.list=PIGFrame(coll,{"TOPLEFT",SendMailFrame,"TOPRIGHT",-46,0},{collhang_Width,424})
	coll.list:PIGSetBackdrop(nil,nil,nil,nil,0)
	coll.list:PIGClose()
	coll.list.xuanzelaiyuan=1
	if NDui and NDuiMailBoxScrollFrame then
		coll.list.yijiazai=false
		coll.list:HookScript("OnShow", function (self)
			local NDuilist=NDuiMailBoxScrollFrame:GetParent()
			if NDuilist:IsShown() then
				self:SetPoint("TOPLEFT",NDuilist,"TOPRIGHT",2,1);
			else
				self:SetPoint("TOPLEFT",SendMailFrame,"TOPRIGHT",-43,1);
			end
			if not coll.list.yijiazai then
				NDuilist:HookScript("OnShow", function (self)
					coll.list:SetPoint("TOPLEFT",NDuilist,"TOPRIGHT",2,1);
				end)
				NDuilist:HookScript("OnHide", function (self)
					coll.list:SetPoint("TOPLEFT",SendMailFrame,"TOPRIGHT",-43,1);
				end)
			end
		end);
	end
	coll.list.lineT = PIGLine(coll.list,"TOP",-52,nil,{2,-2},{0.6,0.6,0.6,0.6})
	coll.list.lineB = PIGLine(coll.list,"BOT",80,nil,{2,-2},{0.6,0.6,0.6,0.6})
	coll.list.title = PIGFontString(coll.list,{"TOP", coll.list, "TOP", -2, -6},"通讯录","OUTLINE")
	coll.list.tishi = CreateFrame("Frame", nil, coll.list);
	coll.list.tishi:SetSize(20,20);
	coll.list.tishi:SetPoint("TOPLEFT",coll.list,"TOPLEFT",5,-5);
	coll.list.tishi.Texture = coll.list.tishi:CreateTexture(nil, "BORDER");
	coll.list.tishi.Texture:SetTexture("interface/common/help-i.blp");
	coll.list.tishi.Texture:SetSize(30,30);
	coll.list.tishi.Texture:SetPoint("CENTER");
	coll.list.tishiNR= "\124cff00ff001、发送过的玩家将自动加入通讯录。\n"..
	"2、通讯录玩家名"..KEY_BUTTON1..":选择发件人，"..KEY_BUTTON2..":删除。\124r\n"..
	"\124cff00ff003、本人角色删除请到信息统计功能\124r"
	PIGEnter(coll.list.tishi,L["LIB_TIPS"]..": ",coll.list.tishiNR);
	coll.list.benrenjuese = PIGCheckbutton(coll.list,{"TOPLEFT",coll.list,"TOPLEFT",20,-30},{"本人"},nil,nil,nil,0)
	coll.list.qitajuese = PIGCheckbutton(coll.list,{"LEFT", coll.list.benrenjuese.Text, "RIGHT", 30, 0},{"其他"},nil,nil,nil,0)
	local function xuanzelianxiren()
		coll.list.qitajuese:SetChecked(false)
		coll.list.benrenjuese:SetChecked(false)
		if coll.list.xuanzelaiyuan==2 then
			coll.list.qitajuese:SetChecked(true)
		elseif coll.list.xuanzelaiyuan==1 then
			coll.list.benrenjuese:SetChecked(true)
		end
		coll.list.gengxinlistcoll(coll.list.Scroll)
	end
	coll.list.benrenjuese:HookScript("OnClick", function ()
		coll.list.xuanzelaiyuan=1
		xuanzelianxiren()
	end);
	coll.list.qitajuese:HookScript("OnClick", function ()
		coll.list.xuanzelaiyuan=2
		xuanzelianxiren()
	end);
	--
	local collhang_NUM = 14
	function coll.list.gengxinlistcoll(self)
		for i = 1, collhang_NUM do
			local listFGV = _G["Mail_colllistName"..i]
			listFGV:Hide()
			listFGV.Faction:Hide()
			listFGV.Race:Hide()
			listFGV.Class:Hide()
			listFGV.level:Hide()
			listFGV.name:SetTextColor(1, 1, 1, 1);
	    end
	    local lianxirendatainfo={}
	    if coll.list.xuanzelaiyuan==2 then
			lianxirendatainfo=PIGA["MailPlus"]["Coll"]
		elseif coll.list.xuanzelaiyuan==1 then
			local PlayerData = PIGA["StatsInfo"]["Players"]
			for nameserver,data in pairs(PlayerData) do
				local name, server = strsplit("-", nameserver);
				if name~=Pig_OptionsUI.Name and Pig_OptionsUI.Realm==server then
					table.insert(lianxirendatainfo,{name,data})
				end
			end
		end
		local zongshuNum=#lianxirendatainfo
		if zongshuNum>0 then
			FauxScrollFrame_Update(self, zongshuNum, collhang_NUM, hang_Height);
			local offset = FauxScrollFrame_GetOffset(self);
		    for i = 1, collhang_NUM do
				local AHdangqianH = i+offset;
				if lianxirendatainfo[AHdangqianH] then
					local listFGV = _G["Mail_colllistName"..i]
					listFGV:Show()
					listFGV:SetID(AHdangqianH);
					if coll.list.xuanzelaiyuan==2 then
						listFGV.Sendname=lianxirendatainfo[AHdangqianH]
						listFGV.name:SetText(lianxirendatainfo[AHdangqianH])
						listFGV.name:SetPoint("LEFT", listFGV, "LEFT", 4,0);
					elseif coll.list.xuanzelaiyuan==1 then
						listFGV.Sendname=lianxirendatainfo[AHdangqianH][1]
						listFGV.name:SetText(lianxirendatainfo[AHdangqianH][1])
						listFGV.Faction:Show()
						listFGV.Race:Show()
						listFGV.Class:Show()
						listFGV.level:Show()
						if lianxirendatainfo[AHdangqianH][2][1]=="Alliance" then
							listFGV.Faction:SetTexCoord(0,0.5,0,1);
						elseif lianxirendatainfo[AHdangqianH][2][1]=="Horde" then
							listFGV.Faction:SetTexCoord(0.5,1,0,1);
						end
						listFGV.Race:SetAtlas(lianxirendatainfo[AHdangqianH][2][3]);
						local className, classFile, classID = GetClassInfo(lianxirendatainfo[AHdangqianH][2][4])
						listFGV.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
						listFGV.level:SetText("("..lianxirendatainfo[AHdangqianH][2][5]..")");
						listFGV.name:SetPoint("LEFT", listFGV.level, "RIGHT", 2,0);
						local color = PIG_CLASS_COLORS[classFile];
						listFGV.name:SetTextColor(color.r, color.g, color.b, 1);	
					end
				end
			end
		end
	end
	coll.list.Scroll = CreateFrame("ScrollFrame",nil,coll.list, "FauxScrollFrameTemplate");  
	coll.list.Scroll:SetPoint("TOPLEFT",coll.list,"TOPLEFT",0,-54);
	coll.list.Scroll:SetPoint("BOTTOMRIGHT",coll.list,"BOTTOMRIGHT",-22,80);
	coll.list.Scroll.ScrollBar:SetScale(0.8)
	coll.list.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, coll.list.gengxinlistcoll)
	end)
	if NDui then
		local B = unpack(NDui)
		B.ReskinScroll(coll.list.Scroll.ScrollBar)
	elseif ElvUI then
		local E= unpack(ElvUI)
		local S = E:GetModule('Skins')
		S:HandleScrollBar(coll.list.Scroll.ScrollBar)
	end
	for i = 1, collhang_NUM do
		local colBut = CreateFrame("Button", "Mail_colllistName"..i, coll.list);
		colBut:SetSize(collhang_Width-26, hang_Height);
		if i==1 then
			colBut:SetPoint("TOP",coll.list.Scroll,"TOP",5,0);
		else
			colBut:SetPoint("TOP",_G["Mail_colllistName"..(i-1)],"BOTTOM",0,-1.5);
		end
		colBut:RegisterForClicks("LeftButtonUp","RightButtonUp")
		colBut.xuanzhong = colBut:CreateTexture(nil, "BORDER");
		colBut.xuanzhong:SetTexture("interface/helpframe/helpframebutton-highlight.blp");
		colBut.xuanzhong:SetTexCoord(0.00,0.00,0.00,0.58,1.00,0.00,1.00,0.58);
		colBut.xuanzhong:SetAllPoints(colBut)
		colBut.xuanzhong:SetBlendMode("ADD")
		colBut.xuanzhong:Hide()
		if i~=collhang_NUM then
			colBut.line = colBut:CreateLine()
			colBut.line:SetColorTexture(0.6,0.6,0.6,0.2)
			colBut.line:SetThickness(1);
			colBut.line:SetStartPoint("BOTTOMLEFT",0,0)
			colBut.line:SetEndPoint("BOTTOMRIGHT",0,0)
		end
		colBut.Faction = colBut:CreateTexture();
		colBut.Faction:SetTexture("interface/glues/charactercreate/ui-charactercreate-factions.blp");
		colBut.Faction:SetPoint("LEFT", colBut, "LEFT", 0,0);
		colBut.Faction:SetSize(hang_Height-2,hang_Height-2);
		colBut.Race = colBut:CreateTexture();
		colBut.Race:SetTexture("Interface/Glues/CharacterCreate/CharacterCreateIcons")
		colBut.Race:SetPoint("LEFT", colBut.Faction, "RIGHT", 1,0);
		colBut.Race:SetSize(hang_Height-2,hang_Height-2);
		colBut.Class = colBut:CreateTexture();
		colBut.Class:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
		colBut.Class:SetPoint("LEFT", colBut.Race, "RIGHT", 1,0);
		colBut.Class:SetSize(hang_Height-2,hang_Height-2);
		colBut.level = PIGFontString(colBut,{"LEFT", colBut.Class, "RIGHT", 2, 0},1)
		colBut.level:SetTextColor(1,0.843,0, 1);
		colBut.name = PIGFontString(colBut,{"LEFT", colBut.level, "LEFT", 2,0},"nil","OUTLINE",13)
		colBut.name:SetWidth(collhang_Width);
		colBut.name:SetJustifyH("LEFT");
		colBut:SetScript("OnEnter", function(self)
			self.xuanzhong:Show()
		end);
		colBut:SetScript("OnLeave", function(self)
			self.xuanzhong:Hide()
		end);
		colBut:SetScript("OnClick", function (self,button)
			if button=="LeftButton" then
				SendMailNameEditBox:SetText(self.Sendname)
			else
				if coll.list.xuanzelaiyuan==2 then
					table.remove(PIGA["MailPlus"]["Coll"],self:GetID())
					coll.list.gengxinlistcoll(coll.list.Scroll)
				end
			end
		end);
	end
	-----
	local function MailPlus_MoneyEdit()
		if PIGA["MailPlus"]["MoneyEdit"] then
			hooksecurefunc("MoneyInputFrame_OnTextChanged", function()
				if not SendMailSubjectEditBox.yishoudong then
					if not HasSendMailItem(1) then
						SendMailSubjectEditBox:SetText(GetCoinText(MoneyInputFrame_GetCopper(SendMailMoney)))
					end
				end
			end)
			SendMailSubjectEditBox:HookScript("OnEditFocusGained", function(self) 
				self.yishoudong=true
			end);
			SendMailFrame:HookScript("OnShow", function (self)
				SendMailSubjectEditBox.yishoudong=false
			end);		
		end
	end
	MailPlus_MoneyEdit()
	coll.list.MailPlus_MoneyEdit = PIGCheckbutton(coll.list,{"BOTTOMLEFT",coll.list,"BOTTOMLEFT",6,6},{"自动填写标题","邮寄金币当标题为空时自定填写标题"},nil,nil,nil,0)
	coll.list.MailPlus_MoneyEdit:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["MailPlus"]["MoneyEdit"]=true;
			MailPlus_MoneyEdit()
		else
			PIGA["MailPlus"]["MoneyEdit"]=false;
		end
	end);
	local NDui_BagName,slotnum = Data.NDui_BagName[1],Data.NDui_BagName[2]
	local function GetBagIDFun(self)
		if self.GetBagID then
			return self:GetBagID()
		else
			return self:GetParent():GetID()
		end
	end
	local function PIG_UseContainerItem(self)
		if BankFrame.GetActiveBankType then
			C_Container.UseContainerItem(GetBagIDFun(self), self:GetID(), nil, BankFrame:GetActiveBankType(), BankFrame:IsShown() and BankFrame.selectedTab == 2);
		else
			C_Container.UseContainerItem(GetBagIDFun(self), self:GetID(), nil, BankFrame:IsShown() and (BankFrame.selectedTab == 2));
		end
	end
	local function zhixingpiliangFun(framef)
		framef:HookScript("PreClick",  function (self,button)
			if SendMailFrame:IsVisible() and IsAltKeyDown() then
				if button == "LeftButton" then
					PIG_UseContainerItem(self)
					SendMailMailButton_OnClick(SendMailMailButton)
				else
					local DQitemID=PIGGetContainerItemInfo(GetBagIDFun(self), self:GetID())
					if DQitemID then
						PIG_UseContainerItem(self)
						if GetCVar("combinedBags")=="1" and ContainerFrameCombinedBags then
							local butnum =#ContainerFrameCombinedBags.Items
							for ff=1,butnum do
								local framef = ContainerFrameCombinedBags.Items[ff]
								local itemID=PIGGetContainerItemInfo(GetBagIDFun(framef), framef:GetID())
								if itemID then
									if DQitemID==itemID then
										PIG_UseContainerItem(framef)
									end
								end
							end
						else
							for bagx=1,NUM_CONTAINER_FRAMES do
								local ContainerF = _G["ContainerFrame"..bagx]
								if ContainerF then
									if ContainerF.Items then
										local butnum =#ContainerF.Items
										for ff=1,butnum do
											local framef = ContainerF.Items[ff]
											local itemID=PIGGetContainerItemInfo(GetBagIDFun(framef), framef:GetID())
											if itemID then
												if DQitemID==itemID then
													PIG_UseContainerItem(framef)
												end
											end
										end
									else
										for solt=1,MAX_CONTAINER_ITEMS do
											local framef=_G["ContainerFrame"..bagx.."Item"..solt]
											if framef then
												local itemID=PIGGetContainerItemInfo(GetBagIDFun(framef), framef:GetID())
												if itemID then
													if DQitemID==itemID then
														PIG_UseContainerItem(framef)
													end
												end
											end
										end
									end
								end
							end
						end
						if NDui then
							for f=1,slotnum do
								local framef = _G[NDui_BagName..f]
								if framef then
									local itemID=PIGGetContainerItemInfo(GetBagIDFun(framef), framef:GetID())
									if itemID then
										if DQitemID==itemID then
											PIG_UseContainerItem(framef)
										end
									end
								end
							end
						end
					end
				end
			end
		end);
	end
	local function MailPlus_ALTbatch(self)
		if PIGA["MailPlus"]["ALTbatch"] then
			if self.yijiazaiALT then return end
			self.yijiazaiALT=true
			if ContainerFrameCombinedBags and ContainerFrameCombinedBags.Items then
				local butnum =#ContainerFrameCombinedBags.Items
				for ff=1,butnum do
					zhixingpiliangFun(ContainerFrameCombinedBags.Items[ff])
				end
			end
			for bagx=1,NUM_CONTAINER_FRAMES do
				local ContainerF = _G["ContainerFrame"..bagx]
				if ContainerF then
					if ContainerF.Items then
						if ContainerF and ContainerF.Items then
							local butnum =#ContainerF.Items
							for ff=1,butnum do
								zhixingpiliangFun(ContainerF.Items[ff])
							end
						end
					else
						for solt=1,MAX_CONTAINER_ITEMS do
							if _G["ContainerFrame"..bagx.."Item"..solt] then
								zhixingpiliangFun(_G["ContainerFrame"..bagx.."Item"..solt])
							end
						end
					end
				end
			end
			if NDui then
				for f=1,slotnum do
					if _G[NDui_BagName..f] then
						zhixingpiliangFun(_G[NDui_BagName..f])
					end
				end
			end
			if ElvUI then
				local ElvUI_BagName = Data.ElvUI_BagName
				for f=1,NUM_CONTAINER_FRAMES do
					for ff=1,MAX_CONTAINER_ITEMS do
						for ei=1,#ElvUI_BagName do
							local bagff = _G[ElvUI_BagName[ei]..f.."Slot"..ff]
							if bagff then
								zhixingpiliangFun(bagff)
							end
						end
					end
				end
			end
		end
	end
	SendMailFrame:HookScript("OnShow", function (self)
		MailPlus_ALTbatch(self)
	end);
	coll.list.MailPlus_ALTbatch = PIGCheckbutton(coll.list,{"BOTTOMLEFT",coll.list.MailPlus_MoneyEdit,"TOPLEFT",0,6},{"ALT+左键快速/右键批量","按住ALT+左键点击背包物品快速邮寄\nALT+右键选择背包相同物品\n此功能只适配原始/PIG/NDui/ElvUI背包"},nil,nil,nil,0)
	coll.list.MailPlus_ALTbatch:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["MailPlus"]["ALTbatch"]=true;
			MailPlus_ALTbatch(SendMailFrame)
		else
			PIGA["MailPlus"]["ALTbatch"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
	end);
	coll.list.MailPlus_lianxuMode = PIGCheckbutton(coll.list,{"BOTTOMLEFT",coll.list.MailPlus_ALTbatch,"TOPLEFT",0,6},{"连寄模式","发件箱未关闭情况下会自动填入上一次收件人"},nil,nil,nil,0)
	coll.list.MailPlus_lianxuMode:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["MailPlus"]["lianxuMode"]=true;
		else
			PIGA["MailPlus"]["lianxuMode"]=false;
		end
	end);
	MailFrame:HookScript("OnEvent", function (self,event)
		if PIGA["MailPlus"]["lianxuMode"] then
			if ( event == "MAIL_SEND_SUCCESS" ) then
				if SendMailFrame.PreviousName then
					SendMailNameEditBox:SetText(SendMailFrame.PreviousName);
				end
			end
		end
	end)
	--------
	coll.list:HookScript("OnShow", function (self)
		self.MailPlus_MoneyEdit:SetChecked(PIGA["MailPlus"]["MoneyEdit"])
		self.MailPlus_ALTbatch:SetChecked(PIGA["MailPlus"]["ALTbatch"])
		self.MailPlus_lianxuMode:SetChecked(PIGA["MailPlus"]["lianxuMode"])
		xuanzelianxiren()
		self.gengxinlistcoll(coll.list.Scroll)
	end);
	hooksecurefunc("SendMailFrame_SendMail", function()
		local fjname = SendMailNameEditBox:GetText()
		if fjname~="" and fjname~=" " then
			if PIGA["MailPlus"]["lianxuMode"] then
				SendMailFrame.PreviousName=fjname
			end
			for i=1,#PIGA["MailPlus"]["Coll"] do
				if fjname==PIGA["MailPlus"]["Coll"][i] then
					return
				end
			end
			local PlayerData = PIGA["StatsInfo"]["Players"]
			for nameserver,data in pairs(PlayerData) do
				local name, server = strsplit("-", nameserver);
				if fjname==name then
					return
				end
			end
			table.insert(PIGA["MailPlus"]["Coll"],fjname)
			coll.list.gengxinlistcoll(coll.list.Scroll)
		end
	end)
end