local _, addonTable = ...;
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGFontString=Create.PIGFontString
---
local Data=addonTable.Data
local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
---------------
local FramePlusfun=addonTable.FramePlusfun
function FramePlusfun.Roll()
	if PIG_MaxTocversion(60000,true) then return end
	if not PIGA["FramePlus"]["Roll"] then return end
	if ElvUI or NDui then return end
	UIParent:UnregisterEvent("START_LOOT_ROLL")
	UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")
	local ActionW = ActionButton1:GetWidth()+2
	local UIname,itemhangW,itemhangH = "PIG_RollLsitUI",260,ActionW
	Data.UILayout[UIname]={"CENTER","CENTER",400,50}
	FramePlusfun.RollListUIname=UIname
	local RollFFF = PIGFrame(UIParent,nil,{itemhangW,12},UIname)
	RollFFF:Hide();
	Create.PIG_SetPoint(UIname)
	RollFFF:SetScale(PIGA["FramePlus"]["RollScale"])
	RollFFF.yidong = PIGButton(RollFFF,{"LEFT",RollFFF,"LEFT",0,0},{26,12},"移动")
	RollFFF.yidong:PIGSetBackdrop()
	Create.PIGSetMovable(RollFFF.yidong,RollFFF)
	RollFFF.yidong:NoClickText()
	RollFFF.yidong.Text:SetFont(ChatFontNormal:GetFont(), 9);
	RollFFF.yidong.Text:SetTextColor(0.6, 0.6, 0.6, 0.9);
	--
	RollFFF.Debug_off = PIGButton(RollFFF,{"LEFT", RollFFF.yidong,"RIGHT",40,0},{100,18},"关闭测试模式")
	RollFFF.Debug_off:Hide()
	RollFFF.Debug_off:SetScript("OnClick", function (self)
		RollFFF:RollDebugUI_OFF()
	end)
	---
	RollFFF.butList={}
	RollFFF.rollFrames = {};
	RollFFF.reservedSize = 100;
	local function GroupLootContainer_CalcMaxIndex(self)
		local maxIdx = 0;
		for k, v in pairs(self.rollFrames) do
			maxIdx = max(maxIdx, k);
		end
		self.maxIndex = maxIdx;
	end
	GroupLootContainer_CalcMaxIndex(RollFFF)
	local function GroupLootContainer_Update(self)
		local lastIdx = nil;
		for i=1, self.maxIndex do
			local frame = self.rollFrames[i];
			if ( frame ) then
				frame:ClearAllPoints();
				frame:SetPoint("TOP",self,"BOTTOM",0,-(itemhangH*(i-1)));
				lastIdx = i;
			end
		end
		if ( lastIdx ) then
			self:Show();
		else
			self:Hide();
		end
	end
	local function GroupLootContainer_RemoveFrame(self, frame)
		local idx = nil;
		for k, v in pairs(self.rollFrames) do
			if ( v == frame ) then
				idx = k;
				break;
			end
		end
		if ( idx ) then
			self.rollFrames[idx] = nil;
			if ( idx == self.maxIndex ) then
				GroupLootContainer_CalcMaxIndex(self);
			end
		end
		frame:Hide();
		GroupLootContainer_Update(self);
	end
	local Texwidth,Texheight = 500,500
	local zhiyeicon="interface/glues/charactercreate/ui-charactercreate-classes.blp"
	local function Enter_Leave(uiitem)
		uiitem:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
			GameTooltip:AddLine(self.tooltipText..PLAYER)
			for kn,vn in pairs(self:GetParent().PlayersList[self:GetID()]) do
				local left,right,top,bottom=unpack(CLASS_ICON_TCOORDS[vn[2]])
				local color = PIG_CLASS_COLORS[vn[2]];
				local left=left*Texwidth
				local right=right*Texwidth
				local top=top*Texheight
				local bottom=bottom*Texheight
				local ttgghh = "|T"..zhiyeicon..":14:14:0:0:"..Texwidth..":"..Texheight..":"..left..":"..right..":"..top..":"..bottom.."|t"
				local ttgghh=ttgghh.." |c"..color.colorStr..vn[1].."|r"
				GameTooltip:AddLine(ttgghh)
			end
			GameTooltip:Show();
		end);
		uiitem:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide()
		end);
	end
	local function PIG_RemoveFrame(frame)
		local left = GetLootRollTimeLeft(frame.rollID);
		if left<=0 then GroupLootContainer_RemoveFrame(RollFFF, frame) return end
	end
	local function SETbutEnableDisable(but,nooff)
		if nooff then
			GroupLootFrame_EnableLootButton(but.Need)
			GroupLootFrame_EnableLootButton(but.Greed)
			GroupLootFrame_EnableLootButton(but.De)
			GroupLootFrame_EnableLootButton(but.Pass)
		else
			GroupLootFrame_DisableLootButton(but.Need)
			GroupLootFrame_DisableLootButton(but.Greed)
			GroupLootFrame_DisableLootButton(but.De)
			GroupLootFrame_DisableLootButton(but.Pass)
		end
	end
	local function add_hang(id)
		local itemhang = PIGFrame(RollFFF,nil,{itemhangW,itemhangH})
		itemhang.butlist={}
		itemhang:Hide()
		itemhang.icon = CreateFrame("Button", nil, itemhang);
		itemhang.icon:SetSize(itemhangH-4,itemhangH-4);
		itemhang.icon:SetPoint("LEFT",itemhang, "LEFT", 0, 0);
		itemhang.icon.tex = itemhang.icon:CreateTexture();
		itemhang.icon.tex:SetPoint("CENTER", 0,0);
		itemhang.icon.tex:SetSize(itemhangH-4,itemhangH-4);
		itemhang.icon.hasItem = 1
		itemhang.icon:SetScript("OnEnter", function (self)
			if RollFFF.ceshi then return end
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
			GameTooltip:SetLootRollItem(self:GetParent().rollID);
			GameTooltip:Show();
			CursorUpdate(self);
		end);
		itemhang.icon:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide()
			ResetCursor();
		end);
		itemhang.icon:SetScript("OnUpdate", function (self)
			if ( GameTooltip:IsOwned(self) ) then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:SetLootRollItem(self:GetParent().rollID);
			end
			CursorOnUpdate(self);
		end);
		itemhang.icon:SetScript("OnClick", function(self)
			if ( IsModifiedClick() ) then
				HandleModifiedItemClick(GetLootRollItemLink(self:GetParent().rollID));
			end
		end)
		itemhang.icon.lv = PIGFontString(itemhang.icon,{"TOPLEFT", itemhang.icon, "TOPLEFT", 0, 1},"","OUTLINE")
		itemhang.icon.Count = PIGFontString(itemhang.icon,{"BOTTOMRIGHT", itemhang.icon, "BOTTOMRIGHT", 1, 1},1,"OUTLINE")

		itemhang.Timer = CreateFrame("StatusBar", nil, itemhang);
		itemhang.Timer:SetStatusBarTexture("interface/raidframe/raid-bar-hp-fill.blp")
		itemhang.Timer:SetStatusBarColor(0, 1, 0 ,1);
		itemhang.Timer:SetSize(itemhangW-itemhangH+2,8);
		itemhang.Timer:SetPoint("BOTTOMLEFT", itemhang.icon, "BOTTOMRIGHT", 2, 0);
		itemhang.Timer:SetMinMaxValues(0, 60000)
		itemhang.Timer:SetScript("OnUpdate", function (self, elapsed)
			if RollFFF.ceshi then return end
			PIG_RemoveFrame(self:GetParent())
			GroupLootFrame_OnUpdate(self, elapsed);
		end);
		itemhang.Timer.BACKGROUND = itemhang.Timer:CreateTexture(nil, "BACKGROUND");
		itemhang.Timer.BACKGROUND:SetTexture("interface/characterframe/ui-party-background.blp")
		itemhang.Timer.BACKGROUND:SetAllPoints(itemhang.Timer)
		itemhang.Timer.BACKGROUND:SetColorTexture(0, 0, 0, 0.6)

		itemhang.Need = CreateFrame("Button", nil, itemhang,"LootRollButtonTemplate",LOOT_ROLL_TYPE_NEED);
		itemhang.Need:SetNormalTexture("Interface/Buttons/UI-GroupLoot-Dice-Up")
		itemhang.Need:SetPushedTexture("Interface/Buttons/UI-GroupLoot-Dice-Down")
		itemhang.Need:SetHighlightTexture("Interface/Buttons/UI-GroupLoot-Dice-Highlight")
		itemhang.Need:SetDisabledTexture("Interface/Buttons/UI-GroupLoot-Dice-Highlight")
		itemhang.Need:GetDisabledTexture():SetAlpha(0.6)
		itemhang.Need:SetSize(itemhangH-10,itemhangH-9);
		itemhang.Need:SetPoint("BOTTOMLEFT", itemhang.Timer, "TOPLEFT", 0, -4);
		itemhang.Need.tooltipText=NEED;
		itemhang.Need.Count = PIGFontString(itemhang.Need,{"TOPRIGHT", itemhang.Need, "TOPRIGHT", 1, 2},0,"OUTLINE",12)
		itemhang.Need.Count:SetTextColor(1, 0, 0, 1);
		Enter_Leave(itemhang.Need)
		itemhang.butlist[LOOT_ROLL_TYPE_NEED]=itemhang.Need

		itemhang.Greed = CreateFrame("Button", nil, itemhang,"LootRollButtonTemplate",LOOT_ROLL_TYPE_GREED);
		itemhang.Greed:SetNormalTexture("Interface/Buttons/UI-GroupLoot-Coin-Up")
		itemhang.Greed:SetPushedTexture("Interface/Buttons/UI-GroupLoot-Coin-Down")
		itemhang.Greed:SetHighlightTexture("Interface/Buttons/UI-GroupLoot-Coin-Highlight")
		itemhang.Greed:SetDisabledTexture("Interface/Buttons/UI-GroupLoot-Coin-Highlight")
		itemhang.Greed:GetDisabledTexture():SetAlpha(0.6)
		itemhang.Greed:SetSize(itemhangH-10,itemhangH-9);
		itemhang.Greed:SetPoint("BOTTOMLEFT", itemhang.Need, "BOTTOMRIGHT", 1, -1);
		itemhang.Greed.tooltipText=GREED;
		itemhang.Greed.Count = PIGFontString(itemhang.Greed,{"TOPRIGHT", itemhang.Greed, "TOPRIGHT", 1, 2},0,"OUTLINE",12)
		itemhang.Greed.Count:SetTextColor(0, 1, 0.6, 1);
		Enter_Leave(itemhang.Greed)
		itemhang.butlist[LOOT_ROLL_TYPE_GREED]=itemhang.Greed

		itemhang.name = PIGFontString(itemhang,{"BOTTOMLEFT", itemhang.Greed, "BOTTOMRIGHT", 0, 8},nil,"OUTLINE")
		itemhang.Pass = CreateFrame("Button", nil, itemhang,"LootRollButtonTemplate",LOOT_ROLL_TYPE_PASS);
		itemhang.Pass:SetNormalTexture("Interface/Buttons/UI-GroupLoot-pass-Up")
		itemhang.Pass:SetPushedTexture("Interface/Buttons/UI-GroupLoot-pass-Down")
		itemhang.Pass:SetHighlightTexture("Interface/Buttons/UI-GroupLoot-pass-Highlight")
		itemhang.Pass:SetDisabledTexture("Interface/Buttons/UI-GroupLoot-pass-Up")
		itemhang.Pass:GetDisabledTexture():SetAlpha(0.6)
		itemhang.Pass:SetSize(itemhangH-13,itemhangH-13);
		itemhang.Pass:SetPoint("BOTTOMRIGHT", itemhang.Timer, "TOPRIGHT", 0, 0);
		itemhang.Pass.tooltipText=PASS;
		itemhang.Pass.Count = PIGFontString(itemhang.Pass,{"TOPRIGHT", itemhang.Pass, "TOPRIGHT", 1, 2},0,"OUTLINE",12)
		itemhang.Pass.Count:SetTextColor(1, 1, 1, 1);
		Enter_Leave(itemhang.Pass)
		itemhang.butlist[LOOT_ROLL_TYPE_PASS]=itemhang.Pass
		itemhang.Pass:SetScript("OnClick", function(self)
			RollOnLoot(self:GetParent().rollID, self:GetID());
		end)

		itemhang.De = CreateFrame("Button", nil, itemhang,"LootRollButtonTemplate",LOOT_ROLL_TYPE_DISENCHANT);
		itemhang.De:SetNormalTexture("Interface/Buttons/UI-GroupLoot-de-Up")
		itemhang.De:SetPushedTexture("Interface/Buttons/UI-GroupLoot-de-Down")
		itemhang.De:SetHighlightTexture("Interface/Buttons/UI-GroupLoot-de-Highlight")
		itemhang.De:SetDisabledTexture("Interface/Buttons/UI-GroupLoot-de-Highlight")
		itemhang.De:GetDisabledTexture():SetAlpha(0.6)
		itemhang.De:SetSize(itemhangH-11,itemhangH-11);
		itemhang.De:SetPoint("BOTTOMRIGHT",itemhang.Pass, "BOTTOMLEFT", -1, -3);
		itemhang.De.tooltipText=ROLL_DISENCHANT;
		itemhang.De.Count = PIGFontString(itemhang.De,{"TOPRIGHT", itemhang.De, "TOPRIGHT", 1, 2},0,"OUTLINE",12)
		itemhang.De.Count:SetTextColor(1, 1, 0.6, 1);
		Enter_Leave(itemhang.De)
		itemhang.butlist[LOOT_ROLL_TYPE_DISENCHANT]=itemhang.De
		itemhang.De:Hide()
	
		itemhang:SetScript("OnShow", function(self)
			if RollFFF.ceshi then return end
			local texture, name, count, quality, bindOnPickUp, canNeed, canGreed, canDisenchant, reasonNeed, reasonGreed, reasonDisenchant, deSkillRequired = GetLootRollItemInfo(self.rollID);
			if (name == nil) then
				GroupLootContainer_RemoveFrame(RollFFF, self);
				return;
			end
			self.icon.tex:SetTexture(texture);
			local itemLink = GetLootRollItemLink(self.rollID)
			local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = GetItemInfoInstant(itemLink) 
			if classID==2 or classID==4 then
				local effectiveILvl = GetDetailedItemLevelInfo(itemLink)
				self.icon.lv:SetText(effectiveILvl);
				local r, g, b = GetItemQualityColor(quality);
				self.icon.lv:SetTextColor(r, g, b, 1);
				self.name:SetText(itemSubType..itemLink)
			else
				self.name:SetText(itemLink)
			end
			if ( count > 1 ) then
				self.icon.Count:SetText(count);
				self.icon.Count:Show();
			else
				self.icon.Count:Hide();
			end
			if ( canNeed ) then
				GroupLootFrame_EnableLootButton(self.Need);
				self.Need.reason = nil;
			else
				GroupLootFrame_DisableLootButton(self.Need);
				self.Need.reason = _G["LOOT_ROLL_INELIGIBLE_REASON"..reasonNeed];
			end
			if ( canGreed) then
				GroupLootFrame_EnableLootButton(self.Greed);
				self.Greed.reason = nil;
			else
				GroupLootFrame_DisableLootButton(self.Greed);
				self.Greed.reason = _G["LOOT_ROLL_INELIGIBLE_REASON"..reasonGreed];
			end
		end)
		itemhang:RegisterEvent("CANCEL_LOOT_ROLL");
		itemhang:HookScript("OnEvent", function(self, event, arg1)
			if ( arg1 == self.rollID ) then
				--GroupLootContainer_RemoveFrame(RollFFF, self);
				--StaticPopup_Hide("CONFIRM_LOOT_ROLL", self.rollID);
			end
		end)
		RollFFF.butList[id]=itemhang	
		return itemhang
	end
	local function GroupLootContainer_AddFrame(self, frame)
		local idx = self.maxIndex + 1;
		for i=1, self.maxIndex do
			if ( not self.rollFrames[i] ) then
				idx = i;
				break;
			end
		end
		self.rollFrames[idx] = frame;
		if ( idx > self.maxIndex ) then
			self.maxIndex = idx;
		end
		GroupLootContainer_Update(self);
		frame:Show();
	end
	local rollTypelist = {LOOT_ROLL_TYPE_PASS,LOOT_ROLL_TYPE_NEED,LOOT_ROLL_TYPE_GREED,LOOT_ROLL_TYPE_DISENCHANT}
	local function initialize_button(frame,id,rollTime)
		frame.rollID = id;
		frame.rollTime = rollTime;
		frame.PlayersList={}
		for i=1,#rollTypelist do
			frame.PlayersList[rollTypelist[i]]={}
		end
		frame.Need.Count:SetText(0)
		frame.Greed.Count:SetText(0)
		frame.Pass.Count:SetText(0)
		frame.Timer:SetMinMaxValues(0, rollTime);
		SETbutEnableDisable(frame,true)
		GroupLootContainer_AddFrame(RollFFF, frame);
	end
	local function GroupLootFrame_OpenNewFrame(id, rollTime)
		local yiyouBUTnum = #RollFFF.butList
		for i=1,yiyouBUTnum do
			local frameXX = RollFFF.butList[i]
			if ( not frameXX:IsShown() ) then
				initialize_button(frameXX, id, rollTime)
				return
			end
		end
		initialize_button(add_hang(yiyouBUTnum+1), id, rollTime)
	end
	---------
	local function GetrollTypeNumAll(frame)
		local yirollplayerall = 0
		for i=1,#rollTypelist do
			local yirollplayer = 0
			for k,v in pairs(frame.PlayersList[rollTypelist[i]]) do
				yirollplayer=yirollplayer+1
				yirollplayerall=yirollplayerall+1
			end
			frame.butlist[rollTypelist[i]].Count:SetText(yirollplayer)
		end
		return yirollplayerall
	end
	local function UpdateRollBut(historyIndex, playerIndex,chushiV)
		local rollID, itemLink, numPlayers, isDone, winnerIdx = C_LootHistory.GetItem(historyIndex);
		for k, frame in pairs(RollFFF.rollFrames) do
			if frame.rollID == rollID then
				local name, class, rollType, roll, isWinner = C_LootHistory.GetPlayerInfo(historyIndex, playerIndex);
				if rollType then
					frame.PlayersList[rollType][playerIndex]={name, class}
					if name==PIG_OptionsUI.Name or name==PIG_OptionsUI.AllName then
						SETbutEnableDisable(frame,false)
					end
				end
				if GetrollTypeNumAll(frame)<numPlayers then
					if chushiV then
						PIG_RemoveFrame(frame)
					end
					frame:Show()
					return
				end
				GroupLootContainer_RemoveFrame(RollFFF, frame);
				return
			end
		end
	end
	local function GetItemhistoryIndex(requestedRollID)
		local numItems = C_LootHistory.GetNumItems();
		for i=1, numItems do
			local rollID, itemLink, numPlayers, isDone, winnerIdx = C_LootHistory.GetItem(i);
			if ( requestedRollID == rollID ) then
				if numPlayers and numPlayers>0 then
					return i,numPlayers
				end
			end
		end
		return 0,0
	end
	local function PIGSetLootRollIDs()
		local pendingLootRollIDs = GetActiveLootRollIDs();
		for i=1, #pendingLootRollIDs do
			GroupLootFrame_OpenNewFrame(pendingLootRollIDs[i], GetLootRollTimeLeft(pendingLootRollIDs[i]));
			local historyIndex, numPlayers=GetItemhistoryIndex(pendingLootRollIDs[i])
			if historyIndex>0 and numPlayers>0 then
				for playerIndex=1,numPlayers do
					UpdateRollBut(historyIndex, playerIndex,true)
				end
			end
		end
	end
	RollFFF:RegisterEvent("PLAYER_ENTERING_WORLD")
	RollFFF:RegisterEvent("START_LOOT_ROLL")
	--RollFFF:RegisterEvent("LOOT_ROLLS_COMPLETE")
	--RollFFF:RegisterEvent("LOOT_HISTORY_ROLL_COMPLETE")
	RollFFF:RegisterEvent("LOOT_HISTORY_ROLL_CHANGED")
	RollFFF:SetScript("OnEvent", function(self, event, arg1, arg2) 
		if ( event == "PLAYER_ENTERING_WORLD" ) then
			PIGSetLootRollIDs()
			for iggg=1, NUM_GROUP_LOOT_FRAMES do
				_G["GroupLootFrame"..iggg]:Hide()
			end
		elseif event == "START_LOOT_ROLL" then
			GroupLootFrame_OpenNewFrame(arg1, arg2);
		elseif event == "LOOT_HISTORY_ROLL_CHANGED" then
			UpdateRollBut(arg1, arg2)
		elseif event == "LOOT_ROLLS_COMPLETE" or event == "LOOT_HISTORY_ROLL_COMPLETE" then
			
		end
	end)
	--
	--LootHistoryFrame:SetWidth(210)
	local xffggghhh = {13262,7734,22691,11122}
	local function RollGetDebugUIItems()
		for i=1,#xffggghhh do
			GetItemInfo(xffggghhh[i])
		end
		for i=1,#xffggghhh do
			local itemName,itemLink=GetItemInfo(xffggghhh[i])
			if not itemName  then
				C_Timer.After(0.4,RollGetDebugUIItems)
				return
			end
		end
		for i=1,#xffggghhh do
				if not RollFFF.butList[i] then add_hang(i) end
				local itembut=RollFFF.butList[i]
				SETbutEnableDisable(RollFFF.butList[i],false)
				itembut.PlayersList={}
				for i=1,#rollTypelist do
					itembut.PlayersList[rollTypelist[i]]={}
				end
				itembut.Need.Count:SetText(0)
				itembut.Greed.Count:SetText(0)
				itembut.Pass.Count:SetText(0)
				itembut.Timer:SetValue(i*14000);
				local itemName,itemLink,itemQuality,itemLevel,itemMinLevel,itemType,itemSubType,itemStackCount,itemEquipLoc,itemTexture,sellPrice,classID = GetItemInfo(xffggghhh[i])
				itembut.icon.link=itemLink
				itembut.icon.tex:SetTexture(itemTexture)
				if classID==2 or classID==4 then
					local effectiveILvl = GetDetailedItemLevelInfo(itemLink)
					itembut.icon.lv:SetText(effectiveILvl);
					local r, g, b = GetItemQualityColor(itemQuality);
					itembut.icon.lv:SetTextColor(r, g, b, 1);
					itembut.name:SetText(itemSubType..itemLink)
				else
					itembut.name:SetText(itemLink)
				end
				itembut.icon.Count:SetTextColor(1, 1, 1, 1)
				itembut.icon.Count:SetText(8)
				itembut:ClearAllPoints();
				itembut:SetPoint("TOP",RollFFF,"BOTTOM",0,-(itemhangH*(i-1)));
				itembut:Show()
		end
	end
	function FramePlusfun.RollDebugUI(Scale)
		RollFFF:SetScale(PIGA["FramePlus"]["RollScale"])
		if not RollFFF:IsShown() then
			RollFFF.ceshi=true
			RollFFF:Show()
			RollFFF.Debug_off:Show()
			RollGetDebugUIItems()
		end
	end
	function RollFFF:RollDebugUI_OFF()
		for k,v in pairs(self.butList) do
			v:Hide()
		end
		self:Hide()
		self.ceshi=false
		self.Debug_off:Hide()
		PIGSetLootRollIDs()
	end
	function FramePlusfun.RollCZ()
		Create.PIG_ResPoint(UIname)
		RollFFF:SetScale(PIGA["FramePlus"]["RollScale"])
	end
end
