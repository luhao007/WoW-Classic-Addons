-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local TooltipScanning = TSM.Init("Service.TooltipScanning")
local ItemString = TSM.Include("Util.ItemString")
local Container = TSM.Include("Util.Container")
local private = {
	tooltip = nil
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function TooltipScanning.IsSoulbound(bag, slot)
	local itemId = Container.GetItemID(bag, slot)
	if not itemId then
		-- No item in this slot
		return true, false, false
	elseif itemId == ItemString.ToId(ItemString.GetPetCage()) then
		-- Battle pets are never soulbound
		return true, false, false
	end

	local info = private.SetContainerItem(bag, slot)
	if TSM.IsWowClassic() and private.tooltip:NumLines() < 1 then
		-- The tooltip didn't fully load yet
		return false, nil, nil
	end

	local isBOP, isBOA = false, false
	for i, text in private.TooltipLineIterator(info) do
		if text == PROFESSIONS_MODIFIED_CRAFTING_REAGENT_BASIC then
			break
		elseif (text == ITEM_BIND_ON_PICKUP and i < 4) or text == ITEM_SOULBOUND or text == ITEM_BIND_QUEST then
			isBOP = true
			break
		elseif (text == ITEM_ACCOUNTBOUND or text == ITEM_BIND_TO_ACCOUNT or text == ITEM_BIND_TO_BNETACCOUNT or text == ITEM_BNETACCOUNTBOUND) then
			isBOA = true
			break
		end
	end

	return true, isBOP, isBOA
end

function TooltipScanning.HasUsedCharges(bag, slot)
	assert(TSM.IsWowClassic())
	local itemId = Container.GetItemID(bag, slot)
	if not itemId then
		-- No item in this slot
		return false
	elseif itemId == ItemString.ToId(ItemString.GetPetCage()) then
		-- Battle pets never have charges
		return false
	end

	-- Check if the item has max charges
	local info = private.SetItemId(itemId)
	local maxCharges = private.ScanTooltipCharges(info)
	if not maxCharges then
		return false
	end

	-- Check if there are used charges on the container item
	info = private.SetContainerItem(bag, slot)
	if maxCharges and private.ScanTooltipCharges(info) ~= maxCharges then
		return true
	end
	return false
end

function TooltipScanning.GetInboxMaxUnique(index, num)
	num = num or 1

	local speciesId, info = nil, nil
	if TSM.IsWowClassic() then
		speciesId = private.SetInboxItem(index, num)
	else
		info = private.SetInboxItem(index, num)
		speciesId = info.battlePetSpeciesID
	end
	if speciesId and speciesId > 0 then
		-- No max for battle pets
		return 0
	end

	for _, text in private.TooltipLineIterator(info) do
		if text == PROFESSIONS_MODIFIED_CRAFTING_REAGENT_BASIC then
			return 0
		elseif text == ITEM_UNIQUE then
			return 1
		else
			local match = strmatch(text, "^"..ITEM_UNIQUE.." %((%d+)%)$")
			if match then
				return tonumber(match)
			end
		end
	end

	return 0
end

function TooltipScanning.GetInboxBattlePetInfo(index, attachIndex)
	if TSM.IsWowClassic() then
		return private.SetInboxItem(index, attachIndex)
	else
		local info = private.SetInboxItem(index, attachIndex)
		return info.battlePetSpeciesID, info.battlePetLevel, info.battlePetBreedQuality, info.battlePetMaxHealth, info.battlePetPower, info.battlePetSpeed
	end
end

function TooltipScanning.GetBuildBankBattlePetInfo(tab, slot)
	if TSM.IsWowClassic() then
		return private.SetGuildBankItem(tab, slot)
	else
		local info = private.SetGuildBankItem(tab, slot)
		return info.battlePetSpeciesID, info.battlePetLevel, info.battlePetBreedQuality
	end
end




-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.SetContainerItem(bag, slot)
	private.PrepareTooltip()
	if TSM.IsWowClassic() then
		if bag == BANK_CONTAINER then
			private.tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
		elseif bag == REAGENTBANK_CONTAINER then
			private.tooltip:SetInventoryItem("player", ReagentBankButtonIDToInvSlotID(slot))
		else
			private.tooltip:SetBagItem(bag, slot)
		end
	else
		local info = nil
		if bag == BANK_CONTAINER then
			info = C_TooltipInfo.GetInventoryItem("player", BankButtonIDToInvSlotID(slot), true)
		elseif bag == REAGENTBANK_CONTAINER then
			info = C_TooltipInfo.GetInventoryItem("player", ReagentBankButtonIDToInvSlotID(slot), true)
		else
			info = C_TooltipInfo.GetBagItem(bag, slot)
		end
		TooltipUtil.SurfaceArgs(info)
		return info
	end
end

function private.SetItemId(itemId)
	private.PrepareTooltip()
	if TSM.IsWowClassic() then
		private.tooltip:SetItemByID(itemId)
	else
		local info =  C_TooltipInfo.GetItemByID(itemId)
		TooltipUtil.SurfaceArgs(info)
		return info
	end
end

function private.SetInboxItem(index, attachIndex)
	private.PrepareTooltip()
	if TSM.IsWowClassic() then
		return select(2, private.tooltip:SetInboxItem(index, attachIndex))
	else
		local info = C_TooltipInfo.GetInboxItem(index, attachIndex)
		TooltipUtil.SurfaceArgs(info)
		return info
	end
end

function private.SetGuildBankItem(tab, slot)
	private.PrepareTooltip()
	if TSM.IsWowClassic() then
		return private.tooltip:SetGuildBankItem(tab, slot)
	else
		local info = C_TooltipInfo.GetGuildBankItem(tab, slot)
		TooltipUtil.SurfaceArgs(info)
		return info
	end
end

function private.PrepareTooltip()
	if not TSM.IsWowClassic() then
		return
	end
	private.tooltip = private.tooltip or CreateFrame("GameTooltip", "TSMScanTooltip", UIParent, "GameTooltipTemplate")
	private.tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	private.tooltip:ClearLines()
end

function private.ScanTooltipCharges(info)
	for _, text in private.TooltipLineIterator(info) do
		if text == PROFESSIONS_MODIFIED_CRAFTING_REAGENT_BASIC then
			return false
		end
		local num = strmatch(text, "%d+")
		local chargesStr = gsub(ITEM_SPELL_CHARGES, "%%d", "%%d+")
		if strfind(chargesStr, ":") then
			if num == 1 then
				chargesStr = gsub(chargesStr, "\1244(.+):.+;", "%1")
			else
				chargesStr = gsub(chargesStr, "\1244.+:(.+);", "%1")
			end
		end
		local maxCharges = strmatch(text, "^"..chargesStr.."$")
		if maxCharges then
			return maxCharges
		end
	end
	return false
end

function private.TooltipLineIterator(info)
	if TSM.IsWowClassic() then
		assert(not info)
		return private.TooltipLineIteratorHelper, nil, 1
	else
		assert(info)
		return private.TooltipLineIteratorHelper, info, 1
	end
end

function private.TooltipLineIteratorHelper(info, index)
	while true do
		index = index + 1
		local numLines = TSM.IsWowClassic() and private.tooltip:NumLines() or #info.lines
		if index > numLines then
			return
		end
		local text = nil
		if TSM.IsWowClassic() then
			local tooltipText = _G["TSMScanTooltipTextLeft"..index]
			text = strtrim(tooltipText and tooltipText:GetText() or "")
		else
			TooltipUtil.SurfaceArgs(info.lines[index])
			text = info.lines[index].leftText
		end
		if text and text ~= "" then
			return index, text
		end
	end
end
