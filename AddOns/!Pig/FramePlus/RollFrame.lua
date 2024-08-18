local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGButton=Create.PIGButton
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
---------------
local FramePlusfun=addonTable.FramePlusfun
function FramePlusfun.Roll()
	local tocversion=9999999
	if tocversion>50000 then return end
	if not PIGA["FramePlus"]["Roll"] then return end
	-- UIParent:UnregisterEvent("START_LOOT_ROLL")
	-- UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")
	local itemhangW,itemhangH = 240,30
	local RollFFF = PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",220,20},{itemhangW,12},"PIG_Roll_LsitUI")
	RollFFF:Hide();
	RollFFF.yidong = PIGFrame(RollFFF,{"LEFT",RollFFF,"LEFT",0,0},{26,12})
	RollFFF.yidong:PIGSetBackdrop()
	RollFFF.yidong:PIGSetMovable(RollFFF)
	RollFFF.yidong.t = PIGFontString(RollFFF.yidong,{"LEFT", RollFFF.yidong, "LEFT", 0, 0}," 移动",nil,9)
	RollFFF.yidong.t:SetTextColor(0.6, 0.6, 0.6, 0.9);
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
			for ipx=1,#self.Players do
				local left,right,top,bottom=unpack(CLASS_ICON_TCOORDS[self.Players[ipx][2]])
				local color = PIG_CLASS_COLORS[self.Players[ipx][2]];
				local left=left*Texwidth
				local right=right*Texwidth
				local top=top*Texheight
				local bottom=bottom*Texheight
				local ttgghh = "|T"..zhiyeicon..":14:14:0:0:"..Texwidth..":"..Texheight..":"..left..":"..right..":"..top..":"..bottom.."|t"
				local ttgghh=ttgghh.." |c"..color.colorStr..self.Players[ipx][1].."|r"
				GameTooltip:AddLine(ttgghh)
			end
			GameTooltip:Show();
		end);
		uiitem:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide()
		end);
	end
	local function add_hang(id)
		local item = PIGFrame(RollFFF,nil,{itemhangW,itemhangH})
		item:Hide()
		item.icon = CreateFrame("Button", nil, item);
		item.icon:SetSize(itemhangH-4,itemhangH-4);
		item.icon:SetPoint("LEFT",item, "LEFT", 0, 0);
		item.icon.tex = item.icon:CreateTexture();
		item.icon.tex:SetPoint("CENTER", 0,0);
		item.icon.tex:SetSize(itemhangH-4,itemhangH-4);
		item.icon.hasItem = 1
		item.icon:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
			GameTooltip:SetLootRollItem(self:GetParent().rollID);
			GameTooltip:Show();
			CursorUpdate(self);
		end);
		item.icon:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide()
			ResetCursor();
		end);
		item.icon:SetScript("OnUpdate", function (self)
			if ( GameTooltip:IsOwned(self) ) then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:SetLootRollItem(self:GetParent().rollID);
			end
			CursorOnUpdate(self);
		end);
		item.icon:SetScript("OnClick", function(self)
			if ( IsModifiedClick() ) then
				HandleModifiedItemClick(GetLootRollItemLink(self:GetParent().rollID));
			end
		end)
		item.icon.lv = PIGFontString(item.icon,{"TOPLEFT", item.icon, "TOPLEFT", 0, 1},"","OUTLINE",12)
		item.icon.Count = PIGFontString(item.icon,{"BOTTOMRIGHT", item.icon, "BOTTOMRIGHT", 1, 1},1,"OUTLINE",12)
		item.Need = CreateFrame("Button", nil, item,"LootRollButtonTemplate",1);
		item.Need:SetNormalTexture("Interface/Buttons/UI-GroupLoot-Dice-Up")
		item.Need:SetPushedTexture("Interface/Buttons/UI-GroupLoot-Dice-Down")
		item.Need:SetHighlightTexture("Interface/Buttons/UI-GroupLoot-Dice-Highlight")
		item.Need:SetSize(itemhangH-10,itemhangH-9);
		item.Need:SetPoint("TOPLEFT", item.icon, "TOPRIGHT", 2, 1);
		item.Need.tooltipText=NEED;
		item.Need.Count = PIGFontString(item.Need,{"TOPRIGHT", item.Need, "TOPRIGHT", 1, 2},0,"OUTLINE",12)
		item.Need.Count:SetTextColor(1, 0, 0, 1);
		Enter_Leave(item.Need)
		item.Greed = CreateFrame("Button", nil, item,"LootRollButtonTemplate",2);
		item.Greed:SetNormalTexture("Interface/Buttons/UI-GroupLoot-Coin-Up")
		item.Greed:SetPushedTexture("Interface/Buttons/UI-GroupLoot-Coin-Down")
		item.Greed:SetHighlightTexture("Interface/Buttons/UI-GroupLoot-Coin-Highlight")
		item.Greed:SetSize(itemhangH-10,itemhangH-9);
		item.Greed:SetPoint("LEFT",item.Need, "RIGHT", 2, -1);
		item.Greed.tooltipText=GREED;
		item.Greed.Count = PIGFontString(item.Greed,{"TOPRIGHT", item.Greed, "TOPRIGHT", 1, 2},0,"OUTLINE",12)
		item.Greed.Count:SetTextColor(0, 1, 0.6, 1);
		Enter_Leave(item.Greed)
		item.name = PIGFontString(item,{"TOPLEFT", item.Greed, "TOPRIGHT", 0, -1},nil,"OUTLINE")
		item.Pass = CreateFrame("Button", nil, item,"LootRollButtonTemplate",0);
		item.Pass:SetNormalTexture("Interface/Buttons/UI-GroupLoot-pass-Up")
		item.Pass:SetPushedTexture("Interface/Buttons/UI-GroupLoot-pass-Down")
		item.Pass:SetHighlightTexture("Interface/Buttons/UI-GroupLoot-pass-Highlight")
		item.Pass:SetSize(itemhangH-12,itemhangH-12);
		item.Pass:SetPoint("TOPRIGHT", item, "TOPRIGHT", 0, -1);
		item.Pass.tooltipText=PASS;
		item.Pass.Count = PIGFontString(item.Pass,{"TOPRIGHT", item.Pass, "TOPRIGHT", 1, 2},0,"OUTLINE",12)
		item.Pass.Count:SetTextColor(1, 1, 1, 1);
		Enter_Leave(item.Pass)
		item.Pass:SetScript("OnClick", function(self, button)
			RollOnLoot(self:GetParent().rollID, self:GetID());
		end)
		item.Timer = CreateFrame("StatusBar", nil, item);
		item.Timer:SetStatusBarTexture("interface/raidframe/raid-bar-hp-fill.blp")
		item.Timer:SetStatusBarColor(0, 1, 0 ,1);
		item.Timer:SetSize(itemhangW-itemhangH+2,8);
		item.Timer:SetPoint("BOTTOMLEFT", item.icon, "BOTTOMRIGHT", 2, 0);
		item.Timer:SetMinMaxValues(0, 60000)
		item.Timer:SetScript("OnUpdate", function (self, elapsed)
			if item.ceshi then return end
			GroupLootFrame_OnUpdate(self, elapsed);
		end);
		item.Timer.BACKGROUND = item.Timer:CreateTexture(nil, "BACKGROUND");
		item.Timer.BACKGROUND:SetTexture("interface/characterframe/ui-party-background.blp")
		item.Timer.BACKGROUND:SetAllPoints(item.Timer)
		item.Timer.BACKGROUND:SetColorTexture(0, 0, 0, 0.5)
		RollFFF.butList[id]=item
		item:SetScript("OnShow", function(self)
			if item.ceshi then return end
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
		return item
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
	local function initialize_button(frame,id,rollTime)
		frame.rollID = id;
		frame.rollTime = rollTime;
		frame.PlayersList={}
		frame.Need.Players={}
		frame.Greed.Players={}
		frame.Pass.Players={}
		frame.Need.Count:SetText(0)
		frame.Greed.Count:SetText(0)
		frame.Pass.Count:SetText(0)
		frame.Timer:SetMinMaxValues(0, rollTime);
		GroupLootContainer_AddFrame(RollFFF, frame);
	end
	local function GroupLootFrame_OpenNewFrame(id, rollTime)
		local yiyouBUTnum = #RollFFF.butList
		for i=1,yiyouBUTnum do
			local frameXX = RollFFF.butList[i]
			if ( not frameXX:IsShown() ) then
				initialize_button(frameXX,id, rollTime)
				return
			end
		end
		initialize_button(add_hang(yiyouBUTnum+1),id, rollTime)
	end
	---------
	RollFFF:RegisterEvent("PLAYER_ENTERING_WORLD")
	RollFFF:RegisterEvent("START_LOOT_ROLL")
	RollFFF:RegisterEvent("LOOT_ROLLS_COMPLETE")
	RollFFF:RegisterEvent("LOOT_HISTORY_ROLL_CHANGED")
	RollFFF:RegisterEvent("CANCEL_LOOT_ROLL");
	RollFFF:SetScript("OnEvent", function(self, event, arg1, arg2, arg3) 
		if ( event == "PLAYER_ENTERING_WORLD" ) then
			local pendingLootRollIDs = GetActiveLootRollIDs();
			for i=1, #pendingLootRollIDs do
				GroupLootFrame_OpenNewFrame(pendingLootRollIDs[i], GetLootRollTimeLeft(pendingLootRollIDs[i]));
			end
		elseif event == "START_LOOT_ROLL" then
			GroupLootFrame_OpenNewFrame(arg1, arg2);
		elseif ( event == "LOOT_HISTORY_ROLL_CHANGED" or event == "CANCEL_LOOT_ROLL" or event == "LOOT_ROLLS_COMPLETE") then
			local rollID, itemLink, numPlayers, isDone, winnerIdx = C_LootHistory.GetItem(arg1);
			for k, v in pairs(self.rollFrames) do
				local frame = v
				if frame.rollID == rollID then
					local name, class, rollType, roll, isWinner = C_LootHistory.GetPlayerInfo(arg1, arg2);
					frame.PlayersList[arg2]=rollType
					if rollType==1 then
						table.insert(frame.Need.Players,{name,class})
						frame.Need.Count:SetText(#frame.Need.Players)
					elseif rollType==2 then
						table.insert(frame.Greed.Players,{name,class})
						frame.Greed.Count:SetText(#frame.Greed.Players)
					elseif rollType==3 then
						table.insert(frame.Pass.Players,{name,class})
						frame.Pass.Count:SetText(#frame.Pass.Players)
					end
					for pid=1,numPlayers do
						print(numPlayers,pid,frame.PlayersList[pid])
						if not frame.PlayersList[pid] then
							frame:Show()
							return
						end
					end
					print(event,"执行删除")
					GroupLootContainer_RemoveFrame(RollFFF, frame);
					return
				end
			end
		end
	end)
	-- local xffggghhh = {22589,14237,3302,7441,13262,13262,13262}
	-- for i=1,NUM_GROUP_LOOT_FRAMES do
	-- 	if not RollFFF.butList[i] then add_hang(i) end
	-- 	local itembut=RollFFF.butList[i]
	-- 	itembut.ceshi=true
	-- 	itembut.Timer:SetValue(i*9000);
	-- 	local itemName,itemLink,itemQuality,itemLevel,itemMinLevel,itemType,itemSubType,itemStackCount,itemEquipLoc,itemTexture,sellPrice,classID,subclassID = GetItemInfo(xffggghhh[i])
	-- 	itembut.icon.link=itemLink
	-- 	itembut.icon.tex:SetTexture(itemTexture)
	-- 	print(itemType,itemSubType,itemEquipLoc)
	-- 	if classID==2 or classID==4 then
	-- 		local effectiveILvl = GetDetailedItemLevelInfo(itemLink)
	-- 		itembut.icon.lv:SetText(effectiveILvl);
	-- 		local r, g, b = GetItemQualityColor(itemQuality);
	-- 		itembut.icon.lv:SetTextColor(r, g, b, 1);
	-- 		itembut.name:SetText(itemSubType..itemLink)
	-- 	else
	-- 		itembut.name:SetText(itemLink)
	-- 	end
	-- 	itembut.icon.Count:SetTextColor(1, 1, 1, 1)
	-- 	itembut.icon.Count:SetText(8)
	-- 	itembut:ClearAllPoints();
	-- 	itembut:SetPoint("TOP",RollFFF,"BOTTOM",0,-(itemhangH*(i-1)));
	-- 	itembut:Show()
	-- end
	-- RollFFF:Show()
end
