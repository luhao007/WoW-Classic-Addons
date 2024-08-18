local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
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
local Data=addonTable.Data
local bagID=Data.bagData["bagID"]
local buticon=136058
local gongnengName = "存储"
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.FastSave()
	local fujiF,fujiTabBut=PIGOptionsList_R(AutoSellBuy_UI.F,"存",60,"Left")
	PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-9},"|cff00FFFF(角色配置)|r")
	fujiF.qingkogn = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",120,-6},{80,22},"清空目录");
	fujiF.qingkogn:SetScript("OnClick", function()
		fujiF.qingkong()
	end)
	BusinessInfo.ADDScroll(fujiF,gongnengName,"Save",19,PIGA_Per["AutoSellBuy"]["Save_List"],{true,"AutoSellBuy","Save_List"})
	BankSlotsFrame.cun = PIGButton(BankSlotsFrame,{"TOPRIGHT",BankSlotsFrame,"TOPRIGHT",-260,-30},{40,22},gongnengName);
	if tocversion<100000 then BankSlotsFrame.cun:SetPoint("TOPRIGHT",BankSlotsFrame,"TOPRIGHT",-108,-40) end
	PIGEnter(BankSlotsFrame.cun,KEY_BUTTON1.."-\124cff00FFFF一键"..gongnengName.."预设物品\124r\n"..KEY_BUTTON2.."-\124cff00FFFF设置一键"..gongnengName.."的物品\124r")  
	BankSlotsFrame.cun:SetScript("OnClick", function (self,button)
		if button=="LeftButton" then
			fujiF.cunchu()
		else
			AutoSellBuy_UI:Show()
			Show_TabBut_R(AutoSellBuy_UI.F,fujiF,fujiTabBut)
		end
	end)
	function fujiF.cunchu()
		local shujuy=PIGA_Per["AutoSellBuy"]["Save_List"]
		for bag=1,#bagID do
			local bganum=GetContainerNumSlots(bagID[bag])
			for slot=1,bganum do	
				local itemID=GetContainerItemID(bagID[bag], slot)
				if itemID then
					for k=1,#shujuy do
						if itemID==shujuy[k][1] then
							UseContainerItem(bagID[bag], slot);
						end
					end
				end
			end
		end
	end
end