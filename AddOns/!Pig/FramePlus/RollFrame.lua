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
	-- local RollFFF = PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",220,20},{itemhangW,60})
	-- RollFFF:PIGSetBackdrop(0.1)
	-- RollFFF.butList={}

	-- local function add_hang(id)
	-- 	local item = PIGFrame(RollFFF,nil,{itemhangW,itemhangH-4})
	-- 	item.icon = CreateFrame("Button", nil, item);
	-- 	item.icon:SetSize(itemhangH,itemhangH);
	-- 	item.icon:SetPoint("LEFT",item, "LEFT", 0, 0);
	-- 	item.icon.tex = item.icon:CreateTexture();
	-- 	item.icon.tex:SetPoint("CENTER", 0,0);
	-- 	item.icon.tex:SetSize(itemhangH,itemhangH);
	-- 	item.name = PIGFontString(item,{"TOPLEFT", item.icon, "TOPRIGHT", 2, -3},nil,"OUTLINE")
	-- 	item.jinduW = PIGFrame(item,{"BOTTOMLEFT", item.icon, "BOTTOMRIGHT", 2, 2},{itemhangW-itemhangH-2,8})
	-- 	item.jinduW:PIGSetBackdrop(1,nil,{0.08, 0.08, 0.08, 0.5})
	-- 	RollFFF.butList[id]=item
	-- end
	-- for i=1,10 do
	-- 	add_hang(i)
	-- end
	-- for i=1,6 do
	-- 	if not RollFFF.butList[i] then add_hang(i) end
	-- 	local itemName,itemLink,itemQuality,itemLevel,itemMinLevel,itemType,itemSubType,itemStackCount,itemEquipLoc,itemTexture = GetItemInfo(6408)
	-- 	RollFFF.butList[i].icon.tex:SetTexture(itemTexture)
	-- 	RollFFF.butList[i].name:SetText(itemLink)
	-- 	RollFFF.butList[i]:ClearAllPoints();
	-- 	RollFFF.butList[i]:SetPoint("TOP",RollFFF,"TOP",0,-(itemhangH*(i-1)));
	-- end
	-- ----------
	-- RollFFF:RegisterEvent("START_LOOT_ROLL")
	-- RollFFF:RegisterEvent("LOOT_HISTORY_ROLL_CHANGED")
	-- RollFFF:SetScript("OnEvent", function(self, event, ...) 
	-- 	--if event == "LOOT_HISTORY_ROLL_CHANGED" then return LOOT_HISTORY_ROLL_CHANGED(...)else return START_LOOT_ROLL(...) end end)
	-- end)



end
