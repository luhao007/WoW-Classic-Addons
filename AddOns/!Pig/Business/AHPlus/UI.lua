local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
-----
local PIGButton=Create.PIGButton
local PIGLine=Create.PIGLine
local PIGCheckbutton=Create.PIGCheckbutton
local Data=addonTable.Data
local BusinessInfo=addonTable.BusinessInfo
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded

function BusinessInfo.huoquhuizhangjiageG()
	local marketPrice = C_WowTokenPublic.GetCurrentMarketPrice();
	if marketPrice and marketPrice>0 then
		local hzlishiGG = PIGA["AHPlus"]["Tokens"]
		local hzlishiGGNum = #hzlishiGG
		if hzlishiGGNum>0 then
			if hzlishiGGNum>50 then
				local kaishiwb = hzlishiGGNum-50
				for i=kaishiwb,1,-1 do
					table.remove(PIGA["AHPlus"]["Tokens"],i)
				end
			end
			local OldmarketPrice = PIGA["AHPlus"]["Tokens"][#PIGA["AHPlus"]["Tokens"]][2] or 0
			if OldmarketPrice~=marketPrice then
				table.insert(PIGA["AHPlus"]["Tokens"],{GetServerTime(),marketPrice})
			end
		else
			table.insert(PIGA["AHPlus"]["Tokens"],{GetServerTime(),marketPrice})
		end
	end
end
local function zhixingdianjiFUn(framef)
	framef:HookScript("PreClick",  function (self,button)
		if button=="RightButton" and not IsShiftKeyDown() and not IsControlKeyDown() and not IsAltKeyDown() then
			local itemID=PIGGetContainerItemInfo(self:GetParent():GetID(), self:GetID())
			if itemID then
				if IsAddOnLoaded("Blizzard_AuctionUI") then AuctionFrameTab_OnClick(AuctionFrameTab3) end
			end
		end
	end);
end
function BusinessInfo.QuicAuc()
	if tocversion<50000 then
		if PIGA["AHPlus"]["QuicAuc"] then
			if NDui then
				local NDui_BagName,slotnum = Data.NDui_BagName[1],Data.NDui_BagName[2]
				for f=1,slotnum do
					local framef = _G[NDui_BagName..f]
					if framef then
						zhixingdianjiFUn(framef)
					end
				end
			else
				local bagidbianhao = Data.ElvUI_BagName
				for f=1,6 do
					for ff=1,36 do
						if ElvUI then
							if _G[bagidbianhao[f].."Slot"..ff] then
								zhixingdianjiFUn(_G[bagidbianhao[f].."Slot"..ff])
							end
						else
							if _G["ContainerFrame"..f.."Item"..ff] then
								zhixingdianjiFUn(_G["ContainerFrame"..f.."Item"..ff])
							end
						end
					end
				end
			end
		end
	end
end
----------------------------------
local AuctionFramejiazai = CreateFrame("FRAME")
AuctionFramejiazai:RegisterEvent("TOKEN_MARKET_PRICE_UPDATED")
AuctionFramejiazai:RegisterEvent("TOKEN_DISTRIBUTIONS_UPDATED")
AuctionFramejiazai:SetScript("OnEvent", function(self, event, arg1)
	if event=="ADDON_LOADED" then
		if arg1 == "Blizzard_AuctionHouseUI" then
			BusinessInfo.AHPlus_Mainline()
			self:UnregisterEvent("ADDON_LOADED")
		elseif arg1 == "Blizzard_AuctionUI" then
			BusinessInfo.AHPlus_Vanilla()
			self:UnregisterEvent("ADDON_LOADED")
		end
	end
	if event=="TOKEN_MARKET_PRICE_UPDATED" or event=="TOKEN_DISTRIBUTIONS_UPDATED" then
		BusinessInfo.huoquhuizhangjiageG()
	end
end)
------------
function BusinessInfo.AHPlus_ADDUI()
	if PIGA["AHPlus"]["Open"] then
		BusinessInfo.huoquhuizhangjiageG()
		BusinessInfo.QuicAuc()
		if IsAddOnLoaded("Blizzard_AuctionHouseUI") then
			BusinessInfo.AHPlus_Mainline()
		elseif IsAddOnLoaded("Blizzard_AuctionUI") then
			BusinessInfo.AHPlus_Vanilla()
		else
			AuctionFramejiazai:RegisterEvent("ADDON_LOADED")
		end
	end
end