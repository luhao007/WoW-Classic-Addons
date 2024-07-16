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
	if not PIGA["FramePlus"]["Roll"] then return end
	-- UIParent:UnregisterEvent("START_LOOT_ROLL")
	-- UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")
	-- local itemhangW,itemhangH = 240,30
	-- local RollFFF = PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",220,20},{itemhangW,12})
	-- RollFFF.yidong = PIGFrame(RollFFF,{"LEFT",RollFFF,"LEFT",0,0},{26,12})
	-- RollFFF.yidong:PIGSetBackdrop()
	-- RollFFF.yidong:PIGSetMovable(RollFFF)
	-- RollFFF.yidong.t = PIGFontString(RollFFF.yidong,{"LEFT", RollFFF.yidong, "LEFT", 0, 0}," 移动",nil,9)
	-- RollFFF.yidong.t:SetTextColor(0.6, 0.6, 0.6, 0.9);
	-- RollFFF.butList={}

	-- local function add_hang(id)
	-- 	local item = PIGFrame(RollFFF,nil,{itemhangW,itemhangH})
	-- 	item.icon = CreateFrame("Button", nil, item);
	-- 	item.icon:SetSize(itemhangH-4,itemhangH-4);
	-- 	item.icon:SetPoint("LEFT",item, "LEFT", 0, 0);
	-- 	item.icon.tex = item.icon:CreateTexture();
	-- 	item.icon.tex:SetPoint("CENTER", 0,0);
	-- 	item.icon.tex:SetSize(itemhangH-4,itemhangH-4);
	-- 	item.icon:SetScript("OnEnter", function (self)
	-- 		GameTooltip:ClearLines();
	-- 		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
	-- 		GameTooltip:SetHyperlink(self.link);
	-- 		GameTooltip:Show();
	-- 	end);
	-- 	item.icon:SetScript("OnLeave", function ()
	-- 		GameTooltip:ClearLines();
	-- 		GameTooltip:Hide() 
	-- 	end);
	-- 	item.Need = CreateFrame("Button", nil, item,"LootRollButtonTemplate",1);
	-- 	item.Need:SetNormalTexture("Interface/Buttons/UI-GroupLoot-Dice-Up")
	-- 	item.Need:SetPushedTexture("Interface/Buttons/UI-GroupLoot-Dice-Down")
	-- 	item.Need:SetHighlightTexture("Interface/Buttons/UI-GroupLoot-Dice-Highlight")
	-- 	item.Need:SetSize(itemhangH-10,itemhangH-8);
	-- 	item.Need:SetPoint("TOPLEFT", item.icon, "TOPRIGHT", 2, 1);
	-- 	item.Greed = CreateFrame("Button", nil, item,"LootRollButtonTemplate",2);
	-- 	item.Greed:SetNormalTexture("Interface/Buttons/UI-GroupLoot-Coin-Up")
	-- 	item.Greed:SetPushedTexture("Interface/Buttons/UI-GroupLoot-Coin-Down")
	-- 	item.Greed:SetHighlightTexture("Interface/Buttons/UI-GroupLoot-Coin-Highlight")
	-- 	item.Greed:SetSize(itemhangH-10,itemhangH-8);
	-- 	item.Greed:SetPoint("LEFT",item.Need, "RIGHT", 2, -1);
	-- 	item.name = PIGFontString(item,{"TOPLEFT", item.Greed, "TOPRIGHT", 0, -1},nil,"OUTLINE")
	-- 	item.Pass = CreateFrame("Button", nil, item,"LootRollButtonTemplate",0);
	-- 	item.Pass:SetNormalTexture("Interface/Buttons/UI-GroupLoot-pass-Up")
	-- 	item.Pass:SetPushedTexture("Interface/Buttons/UI-GroupLoot-pass-Down")
	-- 	item.Pass:SetHighlightTexture("Interface/Buttons/UI-GroupLoot-pass-Highlight")
	-- 	item.Pass:SetSize(itemhangH-12,itemhangH-12);
	-- 	item.Pass:SetPoint("TOPRIGHT", item, "TOPRIGHT", 0, -1);
	-- 	item.jinduW = PIGFrame(item,{"BOTTOMLEFT", item.icon, "BOTTOMRIGHT", 2, 0},{itemhangW-itemhangH+2,8})
	-- 	item.jinduW:PIGSetBackdrop(1,nil,{0.08, 0.08, 0.08, 0.5})
	-- 	RollFFF.butList[id]=item
	-- end
	-- for i=1,10 do
	-- 	add_hang(i)
	-- end
	-- for i=1,6 do
	-- 	if not RollFFF.butList[i] then add_hang(i) end
	-- 	local itemName,itemLink,itemQuality,itemLevel,itemMinLevel,itemType,itemSubType,itemStackCount,itemEquipLoc,itemTexture = GetItemInfo(13262)
	-- 	RollFFF.butList[i].icon.link=itemLink
	-- 	RollFFF.butList[i].icon.tex:SetTexture(itemTexture)
	-- 	RollFFF.butList[i].name:SetText(itemLink)
	-- 	RollFFF.butList[i]:ClearAllPoints();
	-- 	RollFFF.butList[i]:SetPoint("TOP",RollFFF,"BOTTOM",0,-(itemhangH*(i-1)));
	-- end
	-- --LootFrame:Show()
	-- ----------
	-- RollFFF:RegisterEvent("START_LOOT_ROLL")
	-- RollFFF:RegisterEvent("LOOT_HISTORY_ROLL_CHANGED")
	-- RollFFF:SetScript("OnEvent", function(self, event, ...) 
	-- 	--if event == "LOOT_HISTORY_ROLL_CHANGED" then return LOOT_HISTORY_ROLL_CHANGED(...)else return START_LOOT_ROLL(...) end end)
	-- end)



end
