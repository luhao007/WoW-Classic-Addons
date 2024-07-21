local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
-------------
local FramePlusfun=addonTable.FramePlusfun
function FramePlusfun.Merchant()
	if not PIGA["FramePlus"]["Merchant"] then return end
	if MerchantItem13 then return end
	MerchantFrame:Hide()
	local www = MerchantFrame:GetWidth()
	MerchantFrame:SetWidth(www*2)
	MERCHANT_ITEMS_PER_PAGE=20
	local PIGiconqiege = {}
	if ElvUI then
		local E = unpack(ElvUI)
		PIGiconqiege.TexCoords=E.TexCoords
		PIGiconqiege.bordercolor= E.media.bordercolor
	end
	for i=13,20 do
		local itembut = CreateFrame("Frame", "MerchantItem"..i, MerchantFrame,"MerchantItemTemplate");
		if i==13 then
			itembut:SetPoint("TOPLEFT",MerchantItem11,"BOTTOMLEFT",0,-15);
		else
			local tmp1,tmp2 = math.modf(i/2)
			if tmp2==0 then
				itembut:SetPoint("TOPLEFT",_G["MerchantItem"..(i-1)],"TOPRIGHT",12,0);
			else
				itembut:SetPoint("TOPLEFT",_G["MerchantItem"..(i-2)],"BOTTOMLEFT",0,-15);
			end
		end
		if ElvUI then
			local item = _G['MerchantItem'..i]
			local button = _G['MerchantItem'..i..'ItemButton']
			local icon = _G['MerchantItem'..i..'ItemButtonIconTexture']
			local money = _G['MerchantItem'..i..'MoneyFrame']
			local nameFrame = _G['MerchantItem'..i..'NameFrame']
			local name = _G['MerchantItem'..i..'Name']
			local slot = _G['MerchantItem'..i..'SlotTexture']
			item:StripTextures(true)
			item:CreateBackdrop('Transparent')
			item.backdrop:Point('TOPLEFT', -1, 3)
			item.backdrop:Point('BOTTOMRIGHT', 2, -3)

			button:StripTextures()
			button:StyleButton()
			button:SetTemplate(nil, true)
			button:Size(40)
			button:Point('TOPLEFT', item, 'TOPLEFT', 4, -2)

			icon:SetTexCoord(unpack(PIGiconqiege.TexCoords))
			icon:SetInside()

			nameFrame:Point('LEFT', slot, 'RIGHT', -6, -17)

			name:Point('LEFT', slot, 'RIGHT', -4, 5)

			money:ClearAllPoints()
			money:Point('BOTTOMLEFT', button, 'BOTTOMRIGHT', 3, 0)

			for j = 1, 2 do
				local currencyItem = _G['MerchantItem'..i..'AltCurrencyFrameItem'..j]
				local currencyIcon = _G['MerchantItem'..i..'AltCurrencyFrameItem'..j..'Texture']

				currencyIcon.backdrop = CreateFrame('Frame', nil, currencyItem)
				currencyIcon.backdrop:SetTemplate()
				currencyIcon.backdrop:SetFrameLevel(currencyItem:GetFrameLevel())
				currencyIcon.backdrop:SetOutside(currencyIcon)

				currencyIcon:SetTexCoord(unpack(PIGiconqiege.TexCoords))
				currencyIcon:SetParent(currencyIcon.backdrop)
			end
		end
	end
	
	local function PIG_RepairButtons()
		MerchantPrevPageButton:ClearAllPoints();
		MerchantPrevPageButton:SetPoint("BOTTOMLEFT",MerchantFrame,"BOTTOMLEFT",www+12,38);
		MerchantNextPageButton:ClearAllPoints();
		MerchantNextPageButton:SetPoint("BOTTOMLEFT",MerchantFrame,"BOTTOMLEFT",www+280,38);
		MerchantPageText:ClearAllPoints();
		MerchantPageText:SetPoint("BOTTOMLEFT",MerchantFrame,"BOTTOMLEFT",www+110,47);
		if tocversion>100000 and tocversion<110000 then
			MerchantSellAllJunkButton:ClearAllPoints();
			if CanMerchantRepair()  then
				MerchantRepairAllButton:ClearAllPoints();
				MerchantRepairAllButton:SetPoint("BOTTOMLEFT",MerchantFrame,"BOTTOMLEFT",60,33);
				MerchantSellAllJunkButton:SetPoint("LEFT",MerchantGuildBankRepairButton,"RIGHT",8,0);
				if ( CanGuildBankRepair() ) then
					MerchantGuildBankRepairButton:Show();
				end
			else	
				MerchantSellAllJunkButton:SetPoint("BOTTOMLEFT",MerchantFrame,"BOTTOMLEFT",148,33);
			end
			MerchantBuyBackItem:ClearAllPoints();
			MerchantBuyBackItem:SetPoint("BOTTOMLEFT",MerchantFrame,"BOTTOMLEFT",208,33);
		elseif tocversion<50000 then
			MerchantBuyBackItem:ClearAllPoints();
			MerchantBuyBackItem:SetPoint("BOTTOMLEFT",MerchantFrame,"BOTTOMLEFT",174,33);
			if ElvUI then
				MerchantRepairAllButton:ClearAllPoints();
				MerchantRepairAllButton:SetPoint('BOTTOMLEFT', MerchantFrame, 'BOTTOMLEFT',100, 34)
			end
		end
	end
	local function PIG_MerchantInfo()
		MerchantItem1:ClearAllPoints();
		MerchantItem1:SetPoint("TOPLEFT",MerchantFrame,"TOPLEFT",11,-69);
		MerchantItem3:ClearAllPoints();
		MerchantItem3:SetPoint("TOPLEFT", MerchantItem1, "BOTTOMLEFT", 0, -15);
		MerchantItem5:ClearAllPoints();
		MerchantItem5:SetPoint("TOPLEFT", MerchantItem3, "BOTTOMLEFT", 0, -15);
		MerchantItem7:ClearAllPoints();
		MerchantItem7:SetPoint("TOPLEFT", MerchantItem5, "BOTTOMLEFT", 0, -15);
		MerchantItem9:ClearAllPoints();
		MerchantItem9:SetPoint("TOPLEFT", MerchantItem7, "BOTTOMLEFT", 0, -15);
		MerchantItem11:Show();
		MerchantItem12:Show();
		MerchantItem11:ClearAllPoints();
		MerchantItem11:SetPoint("TOPLEFT",MerchantFrame,"TOPLEFT",www+6,-69);
		for i=1,12 do
			_G["MerchantItem"..i]:Show()
		end
		for i=13,20 do
			_G["MerchantItem"..i]:Show()
		end
		if ElvUI then
			for i=13,20 do
				if PIGiconqiege.TexCoords then
					_G['MerchantItem'..i..'ItemButtonIconTexture']:SetTexCoord(unpack(PIGiconqiege.TexCoords))
				end
				local button = _G['MerchantItem'..i..'ItemButton']
				local name = _G['MerchantItem'..i..'Name']
				if button.link then
					local _, _, quality = GetItemInfo(button.link)
					if quality and quality > 1 then
						local r, g, b = GetItemQualityColor(quality)
						button:SetBackdropBorderColor(r, g, b)
						name:SetTextColor(r, g, b)
					else
						button:SetBackdropBorderColor(unpack(PIGiconqiege.bordercolor))
						name:SetTextColor(1, 1, 1)
					end
				else
					button:SetBackdropBorderColor(unpack(PIGiconqiege.bordercolor))
					name:SetTextColor(1, 1, 1)
				end
			end
		else
			for i=1,20 do
				local button = _G['MerchantItem'..i..'ItemButton']
				local name = _G['MerchantItem'..i..'Name']
				if button.link then
					local _, _, quality = GetItemInfo(button.link)
					if quality and quality > 1 then
						local r, g, b = GetItemQualityColor(quality)
						name:SetTextColor(r, g, b)
					else
						name:SetTextColor(1, 1, 1)
					end
				else
					name:SetTextColor(1, 1, 1)
				end
			end
		end
		PIG_RepairButtons()
	end
	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		if ElvUI then
			if ( MerchantFrame.selectedTab == 1 and CanMerchantRepair() ) then
				MerchantRepairAllButton:ClearAllPoints();
				MerchantRepairAllButton:SetPoint('BOTTOMLEFT', MerchantFrame, 'BOTTOMLEFT',100, 34)
			end
			for i=1,20 do
				_G["MerchantItem"..i]:Hide()
			end
			C_Timer.After(0.00001,PIG_MerchantInfo)
		else
			PIG_MerchantInfo()
		end
	end)
	----
	local function PIG_BuybackInfo()
		for i=13,20 do
			_G["MerchantItem"..i]:Hide()
		end
		MerchantItem1:ClearAllPoints();
		MerchantItem1:SetPoint("TOPLEFT",MerchantFrame,"TOPLEFT",11,-100);
		MerchantItem3:ClearAllPoints();
		MerchantItem3:SetPoint("LEFT",MerchantItem2,"RIGHT",14,0);
		MerchantItem5:ClearAllPoints();
		MerchantItem5:SetPoint("TOPLEFT", MerchantItem1, "BOTTOMLEFT", 0, -70);
		MerchantItem7:ClearAllPoints();
		MerchantItem7:SetPoint("LEFT",MerchantItem6,"RIGHT",14,0);
		MerchantItem9:ClearAllPoints();
		MerchantItem9:SetPoint("TOPLEFT", MerchantItem5, "BOTTOMLEFT", 0, -70);
		MerchantItem11:ClearAllPoints();
		MerchantItem11:SetPoint("LEFT",MerchantItem10,"RIGHT",14,0);
	end
	hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function()
		if ElvUI then
			C_Timer.After(0.00001,PIG_BuybackInfo)
		else
			PIG_BuybackInfo()
		end
	end)
end