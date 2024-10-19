local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGButton=Create.PIGButton
----
local FramePlusfun=addonTable.FramePlusfun
------
function FramePlusfun.AddonList()
	if not PIGA["FramePlus"]["AddonList"] then return end
	local maxsize = 100
	local oldWww = AddonList:GetWidth()
	AddonList:SetWidth(oldWww+maxsize)
	if AddonList.ScrollBox then
		local oldBoxWww = AddonList.ScrollBox:GetWidth()
		AddonList.ScrollBox:SetWidth(oldBoxWww+maxsize)
		hooksecurefunc("AddonList_InitButton", function(button, elementData)
			button.Title:SetWidth(220+maxsize)
		end)
	else
		local oldBoxWww = AddonListScrollFrame:GetWidth()
		AddonListScrollFrame:SetWidth(oldBoxWww+maxsize)
		for i=1, MAX_ADDONS_DISPLAYED do
			_G["AddonListEntry"..i.."Title"]:SetWidth(220+maxsize)
		end
	end
	--local pigbut = PIGButton(AddonList,{"TOPLEFT", AddonList, "TOPLEFT", 160, -30},{80,22},"PIG测试",nil,nil,nil,nil,0)
end