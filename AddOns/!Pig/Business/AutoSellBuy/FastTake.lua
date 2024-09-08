local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Data=addonTable.Data
local Create=addonTable.Create
local PIGButton = Create.PIGButton
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGEnter=Create.PIGEnter
local PIGQuickBut=Create.PIGQuickBut
local Show_TabBut_R=Create.Show_TabBut_R
local PIGCheckbutton=Create.PIGCheckbutton
local PIGFontString=Create.PIGFontString
--
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemID = C_Container.GetContainerItemID
local GetContainerItemLink = C_Container.GetContainerItemLink
local PickupContainerItem =C_Container.PickupContainerItem
local UseContainerItem =C_Container.UseContainerItem
-- 
local bankID=Data.bagData["bankID"]
local buticon=136058
local gongnengName = "取出"
local BusinessInfo=addonTable.BusinessInfo

function BusinessInfo.FastTake()
	local fujiF,fujiTabBut=PIGOptionsList_R(AutoSellBuy_UI.F,"取",50,"Left")
	PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-9},"|cff00FFFF(角色配置)|r")
	fujiF.qingkogn = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",120,-6},{80,22},"清空目录");
	fujiF.qingkogn:SetScript("OnClick", function()
		fujiF.qingkong()
	end)
	BusinessInfo.ADDScroll(fujiF,gongnengName,"Take",19,PIGA_Per["AutoSellBuy"]["Take_List"],{true,"AutoSellBuy","Take_List"})
	--一键存/取
	BankSlotsFrame.qu = PIGButton(BankSlotsFrame,{"TOPRIGHT",BankSlotsFrame,"TOPRIGHT",-200,-30},{40,22},gongnengName);
	if tocversion<100000 then BankSlotsFrame.qu:SetPoint("TOPRIGHT",BankSlotsFrame,"TOPRIGHT",-48,-40) end
	PIGEnter(BankSlotsFrame.qu,KEY_BUTTON1.."-\124cff00FFFF一键"..gongnengName.."预设物品\124r\n"..KEY_BUTTON2.."-\124cff00FFFF设置一键"..gongnengName.."的物品\124r")  
	BankSlotsFrame.qu:SetScript("OnClick", function (self,button)
		if button=="LeftButton" then
			fujiF.qu()
		else
			AutoSellBuy_UI:Show()
			Show_TabBut_R(AutoSellBuy_UI.F,fujiF,fujiTabBut)
		end
	end)
	function fujiF.qu()
		local shujuy=PIGA_Per["AutoSellBuy"]["Take_List"]
		for bag=1,#bankID do	
			local bganum=GetContainerNumSlots(bankID[bag])
			for slot=1,bganum do	
				local itemID=GetContainerItemID(bankID[bag], slot)
				if itemID then
					for k=1,#shujuy do
						if itemID==shujuy[k][1] then
							UseContainerItem(bankID[bag], slot);
						end
					end
				end
			end
		end
	end
	-- ReagentBankFrame.qucailiao = PIGButton(ReagentBankFrame,{"TOPRIGHT",ReagentBankFrame,"TOPRIGHT",-40,-30},{80,22},gongnengName.."材料");
	-- PIGEnter(ReagentBankFrame.qucailiao,KEY_BUTTON1.."-一键"..gongnengName.."预设材料\n"..KEY_BUTTON2.."-设置一键"..gongnengName.."的材料")  
	-- ReagentBankFrame.qucailiao:SetScript("OnClick", function (self,button)
	-- 	if button=="LeftButton" then
	-- 		fujiF.qucailiao()
	-- 	else
	-- 		AutoSellBuy_UI:Show()
	-- 		Show_TabBut_R(AutoSellBuy_UI.F,fujiF,fujiTabBut)
	-- 	end
	-- end)
	function fujiF.qucailiao()
		local shujuy=PIGA_Per["AutoSellBuy"]["Take_List"]
		print(ReagentBankFrame.numRow*ReagentBankFrame.numColumn*ReagentBankFrame.numSubColumn)
			local numRow = ReagentBankFrame.numRow;
			local numColumn = ReagentBankFrame.numColumn;
			local numSubColumn = ReagentBankFrame.numSubColumn;
			local id = 1;
			for column = 1, numColumn do
				for subColumn = 1, numSubColumn do
					for row = 0, numRow-1 do
						local button = _G["ReagentBankFrameItem"..id]
						local container = button:GetParent():GetID();
						local buttonID = button:GetID();
						local info = C_Container.GetContainerItemInfo(container, buttonID);
						print(container, buttonID)
						id = id + 1;
					end
				end
			end
			-- if( button.isBag ) then
			-- 	container = Enum.BagIndex.Bankbag;
			-- end
			-- local texture = button.icon;
			-- local inventoryID = button:GetInventorySlot();
			-- local textureName = GetInventoryItemTexture("player",inventoryID);
			-- local info = C_Container.GetContainerItemInfo(container, buttonID);
			-- local quality = info and info.quality;
			-- local isFiltered = info and info.isFiltered;
			-- local itemID = info and info.itemID;
			-- local isBound = info and info.isBound;


		-- for bag=1,#bankID do	
		-- 	local bganum=GetContainerNumSlots(bankID[bag])
		-- 	for slot=1,bganum do	
		-- 		local itemID=GetContainerItemID(bankID[bag], slot)
		-- 		if itemID then
		-- 			for k=1,#shujuy do
		-- 				if itemID==shujuy[k][1] then
		-- 					UseContainerItem(bankID[bag], slot);
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end
	end
end