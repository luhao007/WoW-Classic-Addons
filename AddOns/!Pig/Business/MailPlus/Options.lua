local addonName, addonTable = ...;
local fmod=math.fmod
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGLine=Create.PIGLine
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGDiyBut=Create.PIGDiyBut
local PIGDiyTex=Create.PIGDiyTex
------
local Data=addonTable.Data
local BusinessInfo=addonTable.BusinessInfo
local fuFrame,fuFrameBut = BusinessInfo.fuFrame,BusinessInfo.fuFrameBut
local GetContainerNumSlots = GetContainerNumSlots or C_Container and C_Container.GetContainerNumSlots
local GetContainerItemInfo = GetContainerItemInfo or C_Container and C_Container.GetContainerItemInfo
local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded

local GnName = MINIMAP_TRACKING_MAILBOX.."助手"
------------
local PIG_OPEN_ALL_MAIL_MIN_DELAY=1
function BusinessInfo.MailPlusOptions()
	PIG_OPEN_ALL_MAIL_MIN_DELAY=PIGA["MailPlus"]["OpenAllCD"]
	fuFrame.MailPlus_line = PIGLine(fuFrame,"TOP",-(fuFrame.dangeH*fuFrame.GNNUM))
	fuFrame.GNNUM=fuFrame.GNNUM+2
	------
	local Tooltip = {GnName,"增强你的邮箱界面，方便你查看邮箱物品/发送邮件"};
	fuFrame.MailPlus = PIGCheckbutton(fuFrame,{"TOPLEFT",fuFrame.MailPlus_line,"TOPLEFT",20,-30},Tooltip)
	fuFrame.MailPlus:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["MailPlus"]["Open"]=true;
			BusinessInfo.MailPlus_ADDUI()
			fuFrame:Update_Set()
		else
			PIGA["MailPlus"]["Open"]=false;
			PIG_OptionsUI.RLUI:Show()
		end
	end);
	fuFrame.MailPlus.ScanSliderT = PIGFontString(fuFrame.MailPlus,{"LEFT",fuFrame.MailPlus.Text,"RIGHT",40,0},"批量取件间隔/s")
	fuFrame.MailPlus.ScanSlider = PIGSlider(fuFrame.MailPlus,{"LEFT",fuFrame.MailPlus.ScanSliderT,"RIGHT",0,0},{0.15,1,0.01})
	fuFrame.MailPlus.ScanSlider.Slider:HookScript("OnValueChanged", function(self, arg1)
		PIG_OPEN_ALL_MAIL_MIN_DELAY=arg1
		PIGA["MailPlus"]["OpenAllCD"]=arg1
	end)
	fuFrame.BagOpen = PIGCheckbutton(fuFrame,{"TOPLEFT",fuFrame.MailPlus,"BOTTOMLEFT",0,-20},{"发件时保持背包开启"})
	fuFrame.BagOpen:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["MailPlus"]["BagOpen"]=true;
		else
			PIGA["MailPlus"]["BagOpen"]=false
		end
	end);
	--------
	function fuFrame:Update_Set()
		self.MailPlus:SetChecked(PIGA["MailPlus"]["Open"])
		self.MailPlus.ScanSlider:PIGSetValue(PIGA["MailPlus"]["OpenAllCD"])
		self.BagOpen:SetChecked(PIGA["MailPlus"]["BagOpen"])
	end
	fuFrame:HookScript("OnShow", function (self)
		fuFrame:Update_Set()
	end);
	BusinessInfo.MailPlus_ADDUI()
end
function BusinessInfo.MailPlus_ADDUI()
	if not PIGA["MailPlus"]["Open"] then return end
	if SendMailFrame.coll then return end
	hooksecurefunc("MailFrameTab_OnClick", function(self, tabID)
		if tabID == 1 then
			MailFrame:SetWidth(338)
		elseif tabID == 2 then
			if SendMailFrame.pigopen then
				if not PIGA["MailPlus"]["BagOpen"] then CloseAllBags() end
				MailFrame:SetWidth(705)
			end
		end
	end)
	----
	local boxitemdata = {["boxbutNum"]=64,["meihang"]=8}
	local function ClearBut(lyID)
		if lyID==2 or lyID==3 then
			InboxFrame.ItemBox.PrevPageBut:Disable();
			InboxFrame.ItemBox.NextPageBut:Disable();
			for i=1,boxitemdata.boxbutNum do
				local itemBut=InboxFrame.ItemBox.ButList[i]
				itemBut:Hide()
				itemBut.TimeLeft:Hide()
				itemBut.wasReturned:Hide()
				itemBut.Num:SetText("")
				itemBut.LV:SetText("");
				itemBut:SetScript("OnEnter", nil);
				itemBut:SetScript("OnClick", nil)
			end
		end
	end
	local function SetTooltipFrom(FROMname,MONEY,wasReturned)
		local TimeLeft = MONEY
		if ( TimeLeft >= 1 ) then
			TimeLeft = GREEN_FONT_COLOR_CODE..format(DAYS_ABBR, floor(TimeLeft)).." "..FONT_COLOR_CODE_CLOSE;
		else
			TimeLeft = RED_FONT_COLOR_CODE..SecondsToTime(floor(TimeLeft * 24 * 60 * 60))..FONT_COLOR_CODE_CLOSE;
		end
		GameTooltip:AddLine(FROM..GREEN_FONT_COLOR_CODE..FROMname..FONT_COLOR_CODE_CLOSE..", "..TIME_REMAINING..TimeLeft)
		GameTooltip:AddLine(wasReturned and "|cffFF0000退回邮件，到期将被删除|r")
	end
	local mailData = {}
	local function Show_ItemList()
		if not InboxFrame:IsShown() then return end
		local lyID=InboxFrame.PIG_Select
		ClearBut(lyID)
		wipe(mailData)
		mailData[1],mailData[2],mailData[3] = {},{},0
		local numItems, totalItems = GetInboxNumItems();
		for i=1, numItems do
			local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, itemCount, wasRead, wasReturned, textCreated, canReply, isGM = GetInboxHeaderInfo(i);
			if (itemCount and CODAmount == 0) then
				for n=1,ATTACHMENTS_MAX_RECEIVE do
					local ItemLink=GetInboxItemLink(i, n);
					if ItemLink then
						local _, itemID, _, count = GetInboxItem(i, n);
						table.insert(mailData[1], {ItemLink,count,i, n,sender,daysLeft,itemID,wasReturned});
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
					local itemBut=InboxFrame.ItemBox.ButList[i]
					itemBut:Show()
					local itemName,itemLink,itemQuality,itemLevel,itemMinLevel,itemType,itemSubType,itemStackCount,itemEquipLoc,itemTexture,sellPrice,classID=GetItemInfo(mailData[1][dangqian][1]);
					if not itemLink then
						C_Timer.After(0.6,function() Show_ItemList() end)
						return
					end
					SetItemButtonTexture(itemBut, itemTexture)
					itemBut.wasReturned:SetShown(mailData[1][i][8])
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
						SetTooltipFrom(mailData[1][i][5],TimeLeft,mailData[1][i][8])
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
					local itemBut=InboxFrame.ItemBox.ButList[i]
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
	InboxFrame.itembut = PIGButton(InboxFrame,{"LEFT", InboxFrame.mulubut, "RIGHT", 10, 1.6},{SizePointData[1],SizePointData[2]},ITEMS,nil,nil,nil,nil,0)
	InboxFrame.moneybut = PIGButton(InboxFrame,{"LEFT", InboxFrame.itembut, "RIGHT", 10, 1.6},{SizePointData[1],SizePointData[2]},MONEY,nil,nil,nil,nil,0)
	if not ElvUI and not NDui then
		InboxFrame.mulubut:PIGHighlight()
		InboxFrame.itembut:PIGHighlight()
		InboxFrame.moneybut:PIGHighlight()
	end
	InboxFrame.Delbut = PIGDiyBut(InboxFrame,{"TOPRIGHT",InboxFrame,"TOPRIGHT",-64,-30},{25,nil,25,nil,"bags-button-autosort-up"})

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
		StaticPopup_Show("MAIL_PLUS_DELNONEMAIL");
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
	InboxFrame.ItemBox.ButList={}
	for i=1,boxitemdata.boxbutNum do
		local itemBut
		if PIG_MaxTocversion() then
			itemBut = CreateFrame("Button", nil, InboxFrame.ItemBox);
			itemBut:SetHighlightTexture(130718);
			itemBut.icon = itemBut:CreateTexture()
			itemBut.icon:SetAllPoints(itemBut)
		else
			itemBut = CreateFrame("ItemButton", nil, InboxFrame.ItemBox);
			itemBut.NormalTexture:Hide()
		end
		InboxFrame.ItemBox.ButList[i]=itemBut
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
				itemBut:SetPoint("TOPLEFT",InboxFrame.ItemBox.ButList[i-boxitemdata.meihang],"BOTTOMLEFT",0,-2);
			else
				itemBut:SetPoint("LEFT",InboxFrame.ItemBox.ButList[i-1],"RIGHT",3,0);
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
		itemBut.wasReturned=PIGDiyTex(itemBut,{"TOPLEFT",itemBut,"TOPLEFT",0,0},{16,16})
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
	SendMailFrame.pigopen=true
	local line_W1,line_W2,collW,collY, hang_Height,collhang_NUM = 206,174,20,20,20,15
	SendMailFrame.line1 = SendMailFrame:CreateTexture()
	SendMailFrame.line1:SetTexture("interface/taxiframe/ui-taxi-line.blp")
	SendMailFrame.line1:SetSize(330,28);
	SendMailFrame.line1:SetRotation(math.rad(90), {x=0.5, y=0.5})
	SendMailFrame.line1:SetPoint("LEFT", line_W1-152, 16);
	SendMailFrame.line2 = SendMailFrame:CreateTexture()
	SendMailFrame.line2:SetTexture("interface/taxiframe/ui-taxi-line.blp")
	SendMailFrame.line2:SetSize(330,28);
	SendMailFrame.line2:SetRotation(math.rad(90), {x=0.5, y=0.5})
	SendMailFrame.line2:SetPoint("LEFT", line_W1+line_W2-149, 16);
	----
	SendMailFrame.recipients=PIGFrame(SendMailFrame,{"LEFT",SendMailFrame,"LEFT",line_W1+15,17},{line_W2,314})
	if ElvUI or NDui then SendMailFrame.recipients:PIGSetBackdrop(0,1) end
	SendMailFrame.tishi=PIGDiyTex(SendMailFrame,{"BOTTOMLEFT",SendMailFrame.recipients,"TOPLEFT",4,4},{18,18,26,26,616343})
	PIGEnter(SendMailFrame.tishi,L["LIB_TIPS"]..": ","\124cff00ff001、发送过的玩家将自动加入近期列表\n"..
	"2、玩家名"..KEY_BUTTON1..":设为收件人，"..KEY_BUTTON2..":删除(本人角色删除请到信息统计功能)\124r");
	SendMailFrame.recipients.benrenjuese = PIGCheckbutton(SendMailFrame.recipients,{"LEFT",SendMailFrame.tishi,"RIGHT",2,0},{"本人"},nil,nil,nil,0)
	SendMailFrame.recipients.qitajuese = PIGCheckbutton(SendMailFrame.recipients,{"LEFT", SendMailFrame.recipients.benrenjuese.Text, "RIGHT", 10, 0},{"近期"},nil,nil,nil,0)
	SendMailFrame.recipients.selectID=1
	function SendMailFrame.recipients.xuanzelianxiren()
		SendMailFrame.recipients.qitajuese:SetChecked(false)
		SendMailFrame.recipients.benrenjuese:SetChecked(false)
		if SendMailFrame.recipients.selectID==2 then
			SendMailFrame.recipients.qitajuese:SetChecked(true)
		elseif SendMailFrame.recipients.selectID==1 then
			SendMailFrame.recipients.benrenjuese:SetChecked(true)
		end
		SendMailFrame.recipients.Update_hang(SendMailFrame.recipients.Scroll)
	end
	SendMailFrame.recipients.benrenjuese:HookScript("OnClick", function ()
		SendMailFrame.recipients.selectID=1
		SendMailFrame.recipients.xuanzelianxiren()
	end);
	SendMailFrame.recipients.qitajuese:HookScript("OnClick", function ()
		SendMailFrame.recipients.selectID=2
		SendMailFrame.recipients.xuanzelianxiren()
	end);
	SendMailFrame.recipients.Scroll = CreateFrame("ScrollFrame",nil,SendMailFrame.recipients, "FauxScrollFrameTemplate");  
	SendMailFrame.recipients.Scroll:SetPoint("TOPLEFT",SendMailFrame.recipients,"TOPLEFT",0,0);
	SendMailFrame.recipients.Scroll:SetPoint("BOTTOMRIGHT",SendMailFrame.recipients,"BOTTOMRIGHT",-17,0);
	SendMailFrame.recipients.Scroll.ScrollBar:SetScale(0.7)
	SendMailFrame.recipients.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, SendMailFrame.recipients.Update_hang)
	end)
	SendMailFrame.recipients.butList={}
	for i = 1, collhang_NUM do
		local colBut = CreateFrame("Button", nil, SendMailFrame.recipients,"BackdropTemplate");
		SendMailFrame.recipients.butList[i]=colBut
		colBut:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
		colBut:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
		colBut:SetSize(line_W2-2, hang_Height);
		if i==1 then
			colBut:SetPoint("TOPLEFT",SendMailFrame.recipients.Scroll,"TOPLEFT",1,0);
		else
			colBut:SetPoint("TOP",SendMailFrame.recipients.butList[i-1],"BOTTOM",0,-1);
		end
		colBut:RegisterForClicks("LeftButtonUp","RightButtonUp")
		colBut.highlight = colBut:CreateTexture(nil, "HIGHLIGHT");
		colBut.highlight:SetTexture("interface/helpframe/helpframebutton-highlight.blp");
		colBut.highlight:SetTexCoord(0.00,0.00,0.00,0.58,1.00,0.00,1.00,0.58);
		colBut.highlight:SetAllPoints(colBut)
		colBut.highlight:SetBlendMode("ADD")
		colBut.highlight:SetColorTexture(0.5, 0.5, 0.5, 0.1)
		colBut.highlight1 = colBut:CreateTexture();
		colBut.highlight1:SetTexture("interface/helpframe/helpframebutton-highlight.blp");
		colBut.highlight1:SetTexCoord(0.00,0.00,0.00,0.58,1.00,0.00,1.00,0.58);
		colBut.highlight1:SetAllPoints(colBut)
		colBut.highlight1:SetBlendMode("ADD")
		colBut.highlight1:Hide()
		colBut.Race = colBut:CreateTexture();
		colBut.Race:SetPoint("LEFT", colBut, "LEFT", 0,0);
		colBut.Race:SetSize(hang_Height-2,hang_Height-2);
		colBut.Class = colBut:CreateTexture();
		colBut.Class:SetTexture("interface/glues/charactercreate/ui-charactercreate-classes.blp")
		colBut.Class:SetPoint("LEFT", colBut.Race, "RIGHT", 1,0);
		colBut.Class:SetSize(hang_Height-2,hang_Height-2);
		colBut.level = PIGFontString(colBut,{"LEFT", colBut.Class, "RIGHT", 1, 0},1)
		colBut.level:SetTextColor(1,0.843,0, 1);
		colBut.name = PIGFontString(colBut,{"LEFT", colBut.level, "LEFT", 1,0},"","OUTLINE",13)
		colBut.name:SetWidth(line_W2);
		colBut.name:SetJustifyH("LEFT");
		-- colBut:SetScript("OnEnter", function(self)
		-- 	self.highlight:Show()
		-- end);
		-- colBut:SetScript("OnLeave", function(self)
		-- 	self.highlight:Hide()
		-- end);
		colBut:SetScript("OnClick", function (self,button)
			if button=="LeftButton" then
				SendMailNameEditBox:SetText(self.Sendname)
			else
				if SendMailFrame.recipients.selectID==2 then
					table.remove(PIGA["MailPlus"]["Coll"],self:GetID())
					SendMailFrame.recipients.Update_hang(SendMailFrame.recipients.Scroll)
				end
			end
		end);
	end
	function SendMailFrame.recipients.Update_hang(self)
		for i = 1, collhang_NUM do
			SendMailFrame.recipients.butList[i]:Hide()
	    end
	    local linData={}
	    if SendMailFrame.recipients.selectID==2 then
			linData=PIGA["MailPlus"]["Coll"]
		elseif SendMailFrame.recipients.selectID==1 then
			local PlayerData = PIGA["StatsInfo"]["Players"]
			for nameserver,data in pairs(PlayerData) do
				local name, server = strsplit("-", nameserver);
				if name~=PIG_OptionsUI.Name and PIG_OptionsUI.Realm==server then
					table.insert(linData,{name,data})
				end
			end
		end
		local zongshuNum=#linData
		FauxScrollFrame_Update(self, zongshuNum, collhang_NUM, hang_Height);
		local offset = FauxScrollFrame_GetOffset(self);
	    for i = 1, collhang_NUM do
			local AHdangqianH = i+offset;
			if linData[AHdangqianH] then
				local listFGV = SendMailFrame.recipients.butList[i]
				listFGV:Show()
				listFGV:SetID(AHdangqianH);
				if SendMailFrame.recipients.selectID==2 then
					listFGV.Race:Hide()
					listFGV.Class:Hide()
					listFGV.level:Hide()
					listFGV.Sendname=linData[AHdangqianH]
					listFGV.name:SetText(linData[AHdangqianH])
					listFGV.name:SetPoint("LEFT", listFGV, "LEFT", 4,0);
					listFGV.name:SetTextColor(1,1,1,1);
				elseif SendMailFrame.recipients.selectID==1 then
					listFGV.Sendname=linData[AHdangqianH][1]
					listFGV.name:SetText(linData[AHdangqianH][1])
					listFGV.Race:Show()
					listFGV.Class:Show()
					listFGV.level:Show()
					listFGV.Race:SetAtlas(linData[AHdangqianH][2][3]);
					local className, classFile, classID = PIGGetClassInfo(linData[AHdangqianH][2][4])
					listFGV.Class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFile]));
					listFGV.level:SetText("("..linData[AHdangqianH][2][5]..")");
					listFGV.name:SetPoint("LEFT", listFGV.level, "RIGHT", 2,0);
					local color = PIG_CLASS_COLORS[classFile];
					listFGV.name:SetTextColor(color.r, color.g, color.b, 1);	
				end
			end
		end
	end
	SendMailFrame.recipients.lianxuMode = PIGCheckbutton(SendMailFrame.recipients,{"BOTTOMLEFT",SendMailFrame.recipients,"TOPLEFT",60,34},{"连寄","发件箱未关闭情况下会自动填入上一次收件人"},nil,nil,nil,0)
	SendMailFrame.recipients.lianxuMode:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["MailPlus"]["lianxuMode"]=true;
		else
			PIGA["MailPlus"]["lianxuMode"]=false;
		end
	end);
	SendMailFrame.recipients.MoneyEdit = PIGCheckbutton(SendMailFrame.recipients,{"LEFT",SendMailFrame.recipients.lianxuMode.Text,"RIGHT",6,0},{"自动标题","邮寄金币时自动填入标题"},nil,nil,nil,0)
	SendMailFrame.recipients.MoneyEdit:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["MailPlus"]["MoneyEdit"]=true;
		else
			PIGA["MailPlus"]["MoneyEdit"]=false;
		end
		SendMailFrame.recipients._MoneyEdit()
	end);
	function SendMailFrame.recipients._MoneyEdit()
		hooksecurefunc("MoneyInputFrame_OnTextChanged", function()
			if not PIGA["MailPlus"]["MoneyEdit"] then return end
			if not SendMailSubjectEditBox.yishoudong then
				if not HasSendMailItem(1) then
					SendMailSubjectEditBox:SetText(GetCoinText(MoneyInputFrame_GetCopper(SendMailMoney)))
				end
			end
		end)
		SendMailSubjectEditBox:HookScript("OnEditFocusGained", function(self) 
			if not PIGA["MailPlus"]["MoneyEdit"] then return end
			self.yishoudong=true
		end);
		SendMailFrame:HookScript("OnShow", function (self)
			if not PIGA["MailPlus"]["MoneyEdit"] then return end
			SendMailSubjectEditBox.yishoudong=false
		end);
	end
	SendMailFrame.recipients._MoneyEdit()
	SendMailFrame.recipients.ALTbatch = PIGCheckbutton(SendMailFrame.recipients,{"LEFT",SendMailFrame.recipients.MoneyEdit.Text,"RIGHT",6,0},{"快速邮寄","左键批量选择/右键单选\n选择时按住ALT则快速邮寄"},nil,nil,nil,0)
	SendMailFrame.recipients.ALTbatch:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["MailPlus"]["ALTbatch"]=true;
		else
			PIGA["MailPlus"]["ALTbatch"]=false;
		end
	end);
	SendMailFrame.recipients:HookScript("OnShow", function (self)
		for i=#PIGA["MailPlus"]["Coll"],51,-1 do
			table.remove(PIGA["MailPlus"]["Coll"],i)
		end
		self.xuanzelianxiren()
		self.MoneyEdit:SetChecked(PIGA["MailPlus"]["MoneyEdit"])
		self.ALTbatch:SetChecked(PIGA["MailPlus"]["ALTbatch"])
		self.lianxuMode:SetChecked(PIGA["MailPlus"]["lianxuMode"])
		self.Update_hang(self.Scroll)
	end);
	--
	local bagData=Data.bagData
	local lixianNum,meihang,BagdangeW=(#bagData["bagID"])*MAX_CONTAINER_ITEMS,10,20
	local function But_Click(self)
		if BankFrame.GetActiveBankType then
			C_Container.UseContainerItem(self.BagID, self.SlotID, nil, BankFrame:GetActiveBankType(), false);
		else
			C_Container.UseContainerItem(self.BagID, self.SlotID, nil, false);
		end
	end
	local function PIG_allbagSet(DQitemID)
		for i=1,lixianNum do
			local itemBut = SendMailFrame.ItemList.butList[i]
			if itemBut:IsShown() then
				local itemID=PIGGetContainerItemInfo(itemBut.BagID, itemBut.SlotID)
				if itemID then
					if DQitemID==itemID then
						But_Click(itemBut)
					end
				end
			end
		end
	end
	SendMailFrame.ItemList=PIGFrame(SendMailFrame)
	SendMailFrame.ItemList:SetPoint("TOPLEFT",SendMailFrame,"TOPLEFT",line_W1+line_W2+18,-82);
	SendMailFrame.ItemList:SetPoint("BOTTOMLEFT",SendMailFrame,"BOTTOMLEFT",line_W1+line_W2+18,116);
	SendMailFrame.ItemList:SetWidth(300);
	if ElvUI or NDui then SendMailFrame.ItemList:PIGSetBackdrop(0,1) end
	--
	SendMailFrame.ItemList.Delbut = Create.PIGDiyBut(SendMailFrame.ItemList,{"TOPRIGHT",SendMailFrame.ItemList,"TOPRIGHT",-4,24},{20,nil,20,nil,"common-icon-undo"})
	SendMailFrame.ItemList.Delbut:Disable()
	PIGEnter(SendMailFrame.ItemList.Delbut,"清空已选")
	SendMailFrame.ItemList.Delbut:SetScript("OnClick", function (self,button)
		for i=1, ATTACHMENTS_MAX_SEND do
			ClickSendMailItemButton(SendMailFrame.SendMailAttachments[i]:GetID(), true);
		end
	end);
	local NewItemTypeLsit = PIGCopyTable(Data.ItemTypeLsit)
	table.insert(NewItemTypeLsit,1,{130716,"all",ALL})
	SendMailFrame.ItemList.typeList={}
	SendMailFrame.ItemList.filtrate="all"
	for ib=#NewItemTypeLsit,1,-1 do
		local savebut = PIGDiyBut(SendMailFrame.ItemList,nil,{20,20,23,23,NewItemTypeLsit[ib][1]})
		SendMailFrame.ItemList.typeList[ib]=savebut
		savebut.classData=NewItemTypeLsit[ib][2]
		if ib==#NewItemTypeLsit then
			savebut:SetPoint("RIGHT",SendMailFrame.ItemList.Delbut,"LEFT",-10,1);
		else
			savebut:SetPoint("RIGHT",SendMailFrame.ItemList.typeList[ib+1],"LEFT",-6,0);
		end
		PIGEnter(savebut,savebut,"\124cff00FF00"..NewItemTypeLsit[ib][3].."\124r")
		savebut:RegisterForClicks("LeftButtonUp","RightButtonUp")
		savebut.Down = savebut:CreateTexture(nil, "OVERLAY");
		savebut.Down:SetTexture(130839);
		savebut.Down:SetAllPoints(savebut)
		savebut.Down:Hide();
		savebut:SetScript("OnMouseDown", function (self)
			self.Down:Show();
		end);
		savebut:SetScript("OnMouseUp", function (self)
			self.Down:Hide();
		end);
		savebut.Height = savebut:CreateTexture(nil, "OVERLAY");
		savebut.Height:SetTexture(902180);--130724
		savebut.Height:SetPoint("TOPLEFT",savebut,"TOPLEFT",-10,11);
		savebut.Height:SetPoint("BOTTOMRIGHT",savebut,"BOTTOMRIGHT",11,-10);
		savebut.Height:Hide()
		savebut:SetScript("OnClick", function (self)
			for k,v in pairs(SendMailFrame.ItemList.typeList) do
				v.Height:Hide()
			end
			self.Height:Show()
			SendMailFrame.ItemList.filtrate=self.classData
			SendMailFrame.ItemList.Updata_Items()
		end);
		if ib==1 then savebut.Height:Show() end
	end
	--
	SendMailFrame.ItemList.butList={}
	if PIG_MaxTocversion() then
		SendMailFrame.ItemList.ButTemplate="ItemButtonTemplate"
	else
		SendMailFrame.ItemList.ButTemplate="EnchantingItemButtonAnimTemplate"
	end
	for i=1,lixianNum do
		local itemBut = CreateFrame("ItemButton", nil, SendMailFrame.ItemList,SendMailFrame.ItemList.ButTemplate);
		SendMailFrame.ItemList.butList[i]=itemBut
		itemBut:SetScale(0.77)
		if i==1 then
			itemBut:SetPoint("TOPLEFT",SendMailFrame.ItemList,"TOPLEFT",3,-4);
		else
			local yushu=fmod(i-1,meihang)
			if yushu==0 then
				if i==101 then
					itemBut:SetPoint("TOPLEFT",SendMailFrame.ItemList.butList[i-meihang],"BOTTOMLEFT",154,-1.2);
				else
					itemBut:SetPoint("TOPLEFT",SendMailFrame.ItemList.butList[i-meihang],"BOTTOMLEFT",0,-1.2);
				end
			else
				itemBut:SetPoint("LEFT",SendMailFrame.ItemList.butList[i-1],"RIGHT",1.6,0);
			end
		end
		itemBut:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:SetBagItem(self.BagID, self.SlotID);
			GameTooltip:Show();
		end);
		itemBut:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		itemBut.LV = PIGFontString(itemBut,{"TOPLEFT", itemBut, "TOPLEFT", 0,0},"","OUTLINE",15)
		itemBut.selectTex = itemBut:CreateTexture(nil,"OVERLAY");
		itemBut.selectTex:SetAtlas("ui-lfg-readymark-raid")
		itemBut.selectTex:SetSize(24,24);
		itemBut.selectTex:SetPoint("CENTER", 0, 0);
		itemBut.selectTex:Hide()
		itemBut:SetScript("OnClick", function (self,button)
			if button=="LeftButton" then
				if IsShiftKeyDown() then
					local editBox = ChatEdit_ChooseBoxForSend();
					local hasText = editBox:GetText()..self.itemLink
					if editBox:HasFocus() then
						editBox:SetText(hasText);
					else
						ChatEdit_ActivateChat(editBox)
						editBox:SetText(hasText);
					end
				else
					But_Click(self)
					local DQitemID=PIGGetContainerItemInfo(self.BagID, self.SlotID)
					PIG_allbagSet(DQitemID)
					if IsAltKeyDown() and PIGA["MailPlus"]["ALTbatch"] then
						SendMailMailButton_OnClick(SendMailMailButton)
					end
				end
			else
				But_Click(self)
				if IsAltKeyDown() and PIGA["MailPlus"]["ALTbatch"] then
					SendMailMailButton_OnClick(SendMailMailButton)
				end
			end
		end)
	end
	function SendMailFrame.ItemList.Updata_Items()
		for i=1,lixianNum do
			SendMailFrame.ItemList.butList[i]:Hide()
		end
		SendMailFrame.ItemList.Delbut:Disable()
		SendMailFrame.ItemList.index=0
		for bag=1,#bagData["bagID"] do
			for slot=1,GetContainerNumSlots(bagData["bagID"][bag]) do
				local itemID, itemLink, icon, stackCount, quality, noValue, lootable, locked, isBound=PIGGetContainerItemInfo(bagData["bagID"][bag], slot);
				if itemID and not isBound then
					local pigmail_additemS = {false,0}
					if SendMailFrame.ItemList.filtrate=="all" then
						pigmail_additemS[1]=true
					else
						local classID, subclassID = select(6, GetItemInfoInstant(itemLink))
						for ibi=1,#SendMailFrame.ItemList.filtrate do
							if SendMailFrame.ItemList.filtrate[ibi][2] then
								if classID==SendMailFrame.ItemList.filtrate[ibi][1] and subclassID==SendMailFrame.ItemList.filtrate[ibi][2] then
									pigmail_additemS[1]=true
								end
							else
								if classID==SendMailFrame.ItemList.filtrate[ibi][1] then
									pigmail_additemS[1]=true
								end
							end
						end
					end
					if pigmail_additemS[1] then
						SendMailFrame.ItemList.index=SendMailFrame.ItemList.index+1
						local itemBut=SendMailFrame.ItemList.butList[SendMailFrame.ItemList.index]
						itemBut:Show()
						if locked then
							itemBut.icon:SetDesaturated(true)
							itemBut.selectTex:Show()
							SendMailFrame.ItemList.Delbut:Enable()
						else
							itemBut.icon:SetDesaturated(false)
							itemBut.selectTex:Hide()
						end
						itemBut.BagID=bagData["bagID"][bag]
						itemBut.SlotID=slot
						SetItemButtonTexture(itemBut, icon)
						if stackCount>1 then
							itemBut.Count:SetText(stackCount)
							itemBut.Count:Show()
						else
							itemBut.Count:SetText("")
						end
						if PIGA["BagBank"]["wupinLV"] then
							if classID==2 or classID==4 then
								local effectiveILvl = GetDetailedItemLevelInfo(itemLink)	
								if effectiveILvl and effectiveILvl>0 then
									itemBut.LV:SetText(effectiveILvl)
									local quality = C_Item.GetItemQualityByID(itemLink)
									local r, g, b, hex = GetItemQualityColor(quality)
									itemBut.LV:SetTextColor(r, g, b, 1);
								end
							end
						end
					end
				end
			end
		end
	end
	SendMailFrame.ItemList:HookScript("OnShow", function (self)
		self.Updata_Items()
	end);
	SendMailFrame.ItemList:RegisterEvent("BAG_UPDATE");
	SendMailFrame.ItemList:SetScript("OnEvent", function(self,event,arg1,arg2)
		if event=="BAG_UPDATE" then
			if self:IsShown() and arg1~=-2 then
				if arg1>=0 and arg1<=bagData["bagIDMax"] then
					self.Updata_Items()
				end
			end
		end
	end)
	local function SaveSendName()
		if PIGA["MailPlus"]["lianxuMode"] then
			if SendMailFrame.PreviousName then
				SendMailNameEditBox:SetText(SendMailFrame.PreviousName);
			end
		end
		for i=1,#PIGA["MailPlus"]["Coll"] do
			if SendMailFrame.PreviousName==PIGA["MailPlus"]["Coll"][i] then
				return
			end
		end
		local PlayerData = PIGA["StatsInfo"]["Players"]
		for nameserver,data in pairs(PlayerData) do
			local name, server = strsplit("-", nameserver);
			if SendMailFrame.PreviousName==name then
				return
			end
		end
		table.insert(PIGA["MailPlus"]["Coll"],1,SendMailFrame.PreviousName)
		SendMailFrame.recipients.Update_hang(SendMailFrame.recipients.Scroll)
	end
	hooksecurefunc("SendMailFrame_SendMail", function()
		SendMailFrame.PreviousName=SendMailNameEditBox:GetText()
	end)
	MailFrame:HookScript("OnEvent", function (self,event)
		if event == "MAIL_SEND_SUCCESS" then
			C_Timer.After(0.1,SaveSendName)
		elseif event == "MAIL_SEND_INFO_UPDATE" then
			SendMailFrame.ItemList.Updata_Items()
		end
	end)
	hooksecurefunc("SendMailFrame_Update", function()
		SendMailHorizontalBarLeft:ClearAllPoints();
		SendMailHorizontalBarLeft2:ClearAllPoints();
		SendMailSubjectEditBox:SetWidth(156)
		SendMailSubjectEditBoxMiddle:SetWidth(154)
		SendStationeryBackgroundRight:ClearAllPoints();
		if PIG_MaxTocversion() then
			SendMailSubjectEditBox:SetPoint("TOPLEFT", "SendMailNameEditBox", "BOTTOMLEFT", -34,0);
			MailEditBox:SetSize(line_W1-2,174)
			MailEditBox:SetPoint("TOPLEFT", "SendMailFrame", "TOPLEFT", 10,-86);
			SendStationeryBackgroundLeft:SetAllPoints(MailEditBox)
			MailEditBoxScrollBar:SetScale(0.6)
			MailEditBoxScrollBar.Background:Hide()
			MailEditBoxScrollBar.Background:ClearAllPoints();
			MailEditBoxScrollBar:SetPoint("TOPLEFT", MailEditBox, "TOPRIGHT", -24,4);
			MailEditBoxScrollBar:SetPoint("BOTTOMLEFT", MailEditBox, "BOTTOMRIGHT", -24,-4);
		else
			if ElvUI then
				SendMailSubjectEditBox:SetPoint("TOPLEFT", "SendMailNameEditBox", "BOTTOMLEFT", -30,-6);
			else
				SendMailSubjectEditBox:SetPoint("TOPLEFT", "SendMailNameEditBox", "BOTTOMLEFT", -64,0);
			end
			SendMailScrollFrame:SetSize(line_W1-2,174)
			SendMailScrollFrame:SetPoint("TOPLEFT", "SendMailFrame", "TOPLEFT", 10,-86);
			SendStationeryBackgroundLeft:SetAllPoints(SendMailScrollFrame)
			SendMailScrollFrame.ScrollBar:SetScale(0.8)
			SendMailScrollFrame.ScrollBar:SetPoint("TOPLEFT", SendMailScrollFrame, "TOPRIGHT", -10,0);
			SendMailScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", SendMailScrollFrame, "BOTTOMRIGHT", -10,-0);
		end
		for i=1, ATTACHMENTS_MAX_SEND do
			SendMailFrame.SendMailAttachments[i]:SetScale(0.8)
			SendMailFrame.SendMailAttachments[i]:Show();
			if i>6 then
				SendMailFrame.SendMailAttachments[i]:SetPoint("TOPLEFT", "SendMailFrame", "BOTTOMLEFT", (i-7)*42+16,268);
			else
				SendMailFrame.SendMailAttachments[i]:SetPoint("TOPLEFT", "SendMailFrame", "BOTTOMLEFT", (i-1)*42+16,308);
			end
		end
		SendMailMoneyButton:SetPoint("BOTTOMLEFT", "SendMailFrame", "BOTTOMLEFT", 20,150);
		SendMailSendMoneyButton:SetPoint("TOPLEFT","SendMailMoney","TOPRIGHT",-184,-26)
		SendMailCODButton:ClearAllPoints();
		SendMailCODButton:SetPoint("LEFT","SendMailSendMoneyButtonText","RIGHT",10,0)
		SendMailCostMoneyFrame:ClearAllPoints();
		SendMailCostMoneyFrame:SetPoint("BOTTOMLEFT", "SendMailFrame", "BOTTOMLEFT", 270,96)
		SendMailCancelButton:SetPoint("BOTTOMRIGHT", "SendMailFrame", "BOTTOMRIGHT", 110,92)
	end)
end