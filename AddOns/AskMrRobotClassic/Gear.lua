local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")
local L = LibStub("AceLocale-3.0"):GetLocale("AskMrRobotClassic", true)
local AceGUI = LibStub("AceGUI-3.0")

local _cboSetups
local _panelGear
local _activeSetupId

local function getSetupById(id)
	if not id then
		id = _activeSetupId
	end
	local setup
	for i,s in ipairs(Amr.db.char.GearSetups) do
		if s.Id == id then
			setup = s
			break
		end
	end
	return setup
end

-- Returns a number indicating how different two items are (0 means the same, higher means more different)
local function countItemDifferences(item1, item2)
	-- both nil, the same
	if not item1 and not item2 then 
		return 0 
	end 
	
	-- one nil and other not, or different id, totally different
	if (not item1 and item2) or (item1 and not item2) or item1.id ~= item2.id then 
		return 100000 
	end
	
    -- different versions of same item (id + bonus ids + suffix + drop level, constitutes a different physical drop)
    if Amr.GetItemUniqueId(item1, true, true) ~= Amr.GetItemUniqueId(item2, true, true) then
		return 10000
    end
    
    -- different upgrade levels of the same item
    if item1.upgradeId ~= item2.upgradeId then
        return 1000
	end
	
	-- a change that requires reforging is considered more different than a change that does not;
	-- it is assumed that item1 is how we want the item to be in the end, and item2 is how it currently is
	local aztReforges = 0
	local aztSelects = 0

    -- different gems
    local gemDiffs = 0
    for i = 1, 3 do
        if item1.gemIds[i] ~= item2.gemIds[i] then
            gemDiffs = gemDiffs + 1
        end
    end
    
	-- different enchants
    local enchantDiff = 0
    if item1.enchantId ~= item2.enchantId then
        enchantDiff = 1
    end
    
    return aztReforges + aztSelects + gemDiffs + enchantDiff
end

-- given a table of items (keyed or indexed doesn't matter) find closest match to item, or nil if none are a match
local function findMatchingItemFromTable(item, list, bestItem, bestDiff, bestLoc, usedItems, tableType)
	if not list then return nil end
	
	local found = false
	for k,listItem in pairs(list) do		
		if listItem then
			local diff = countItemDifferences(item, listItem)
			if diff < bestDiff then
				-- each physical item can only be used once, the usedItems table has items we can't use in this search
				local key = string.format("%s_%s", tableType, k)
				if not usedItems[key] then
					bestItem = listItem
					bestDiff = diff
					bestLoc = key
					found = true
				end
			end
			if found then break end
		end
	end
	
	return bestItem, bestDiff, bestLoc
end

-- search the player's equipped gear, bag, and bank for an item that best matches the specified item
function Amr:FindMatchingItem(item, player, usedItems)
	if not item then return nil end

	local equipped = player.Equipped and player.Equipped[player.ActiveSpec] or nil
	local bestItem, bestDiff, bestLoc = findMatchingItemFromTable(item, equipped, nil, 100000, nil, usedItems, "equip")
	bestItem, bestDiff, bestLoc = findMatchingItemFromTable(item, player.BagItems, bestItem, bestDiff, bestLoc, usedItems, "bag")
	if player.BankItems then
		bestItem, bestDiff, bestLoc = findMatchingItemFromTable(item, player.BankItems, bestItem, bestDiff, bestLoc, usedItems, "bank")		
	end	

	if bestDiff >= 100000 then
		return nil, 100000
	else
		usedItems[bestLoc] = true
		return bestItem, bestDiff
	end
end

local function renderEmptyGear(container)

	local panelBlank = AceGUI:Create("AmrUiPanel")
	panelBlank:SetLayout("None")
	panelBlank:SetBackgroundColor(Amr.Colors.Black, 0.4)
	container:AddChild(panelBlank)
	panelBlank:SetPoint("TOPLEFT", container.content, "TOPLEFT", 6, 0)
	panelBlank:SetPoint("BOTTOMRIGHT", container.content, "BOTTOMRIGHT")
	
	local lbl = AceGUI:Create("AmrUiLabel")
	panelBlank:AddChild(lbl)
	lbl:SetText(L.GearBlank)
	lbl:SetWidth(700)
	lbl:SetJustifyH("MIDDLE")
	lbl:SetFont(Amr.CreateFont("Italic", 16, Amr.Colors.TextTan))		
	lbl:SetPoint("BOTTOM", panelBlank.content, "CENTER", 0, 20)
	
	local lbl2 = AceGUI:Create("AmrUiLabel")
	panelBlank:AddChild(lbl2)
	lbl2:SetText(L.GearBlank2)
	lbl2:SetWidth(700)
	lbl2:SetJustifyH("MIDDLE")
	lbl2:SetFont(Amr.CreateFont("Italic", 16, Amr.Colors.TextTan))		
	lbl2:SetPoint("TOP", lbl.frame, "CENTER", 0, -20)
end

-- helper to create a widget for showing a socket
local function createSocketWidget(panelMods, prevWidget, prevIsSocket, isEquipped)

	-- highlight for socket that doesn't match
	local socketBorder = AceGUI:Create("AmrUiPanel")
	panelMods:AddChild(socketBorder)
	if not prevIsSocket then
		socketBorder:SetPoint("LEFT", prevWidget.frame, "RIGHT", 30, 0)
	else
		socketBorder:SetPoint("LEFT", prevWidget.frame, "RIGHT", 2, 0)
	end
	socketBorder:SetLayout("None")
	socketBorder:SetBackgroundColor(Amr.Colors.Black, isEquipped and 0 or 1)
	socketBorder:SetWidth(26)
	socketBorder:SetHeight(26)
	if isEquipped then
		socketBorder:SetAlpha(0.3)
	end					

	local socketBg = AceGUI:Create("AmrUiIcon")
	socketBorder:AddChild(socketBg)
	socketBg:SetPoint("TOPLEFT", socketBorder.content, "TOPLEFT", 1, -1)
	socketBg:SetLayout("None")
	socketBg:SetBorderWidth(2)
	socketBg:SetIconBorderColor(Amr.Colors.Green, isEquipped and 0 or 1)
	socketBg:SetWidth(24)
	socketBg:SetHeight(24)

	local socketIcon = AceGUI:Create("AmrUiIcon")
	socketBg:AddChild(socketIcon)
	socketIcon:SetPoint("CENTER", socketBg.content, "CENTER")
	socketIcon:SetBorderWidth(1)
	socketIcon:SetIconBorderColor(Amr.Colors.White)
	socketIcon:SetWidth(18)
	socketIcon:SetHeight(18)
	
	return socketBorder, socketIcon
end

local function renderGear(setupId, container)

	-- release all children that were previously rendered, we gonna redo it now
	container:ReleaseChildren()

	local player = Amr:ExportCharacter()

	local gear
	local spec
	local setupIndex
	for i, setup in ipairs(Amr.db.char.GearSetups) do
		if setup.Id == setupId then
			setupIndex = i
			gear = setup.Gear
			spec = setup.SpecSlot
			break
		end
	end

	local equipped = player.Equipped[player.ActiveSpec]
		
	if not gear then
		-- no gear has been imported for this spec so show a message
		renderEmptyGear(container)
	else
		local panelGear = AceGUI:Create("AmrUiPanel")
		panelGear:SetLayout("None")
		panelGear:SetBackgroundColor(Amr.Colors.Black, 0.3)
		container:AddChild(panelGear)
		panelGear:SetPoint("TOPLEFT", container.content, "TOPLEFT", 6, 0)
		panelGear:SetPoint("BOTTOMRIGHT", container.content, "BOTTOMRIGHT", -300, 0)
		
		local panelMods = AceGUI:Create("AmrUiPanel")
		panelMods:SetLayout("None")
		panelMods:SetBackgroundColor(Amr.Colors.Black, 0.3)
		container:AddChild(panelMods)
		panelMods:SetPoint("TOPLEFT", panelGear.frame, "TOPRIGHT", 15, 0)
		panelMods:SetPoint("BOTTOMRIGHT", container.content, "BOTTOMRIGHT")
		
		-- spec icon
		local icon = AceGUI:Create("AmrUiIcon")	
		icon:SetIconBorderColor(Amr.Colors.Classes[player.Class])
		icon:SetWidth(48)
		icon:SetHeight(48)

		--[[
		local iconSpec
		if player.SubSpecs and player.SubSpecs[spec] then
			iconSpec = player.SubSpecs[spec]
		else
			iconSpec = player.Specs[spec]
		end
		]]

		--icon:SetIcon("Interface\\Icons\\" .. Amr.SpecIcons[iconSpec])
		icon:SetIcon("Interface\\Icons\\" .. Amr.ClassIcons[player.Class])		
		panelGear:AddChild(icon)
		icon:SetPoint("TOPLEFT", panelGear.content, "TOPLEFT", 10, -10)
		
		local btnEquip = AceGUI:Create("AmrUiButton")
		--btnEquip:SetText(L.GearButtonEquip(L.SpecsShort[player.Specs[spec]]))
		btnEquip:SetText(L.GearButtonEquip2)
		btnEquip:SetBackgroundColor(Amr.Colors.Green)
		btnEquip:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.White))
		btnEquip:SetWidth(300)
		btnEquip:SetHeight(26)
		btnEquip:SetCallback("OnClick", function(widget)
			Amr:EquipGearSet(setupIndex)
		end)
		panelGear:AddChild(btnEquip)
		btnEquip:SetPoint("LEFT", icon.frame, "RIGHT", 40, 0)
		btnEquip:SetPoint("RIGHT", panelGear.content, "RIGHT", -40, 0)
		
		-- each physical item can only be used once, this tracks ones we have already used
		local usedItems = {}
		
		-- gear list
		local prevElem = icon
		for slotNum = 1, #Amr.SlotIds do
			local slotId = Amr.SlotIds[slotNum]
			
			local equippedItem = equipped and equipped[slotId] or nil
			--local equippedItemLink = equipped and equipped.link or nil
			local optimalItem = gear[slotId]			
			local optimalItemLink = Amr.CreateItemLink(optimalItem)
			
			-- see if item is currently equipped, is false if don't have any item for that slot (e.g. OH for a 2-hander)
			local isEquipped = false			
			if equippedItem and optimalItem and Amr.GetItemUniqueId(equippedItem, false, true) == Amr.GetItemUniqueId(optimalItem, false, true) then
				isEquipped = true
			end

			-- find the item in the player's inventory that best matches what the optimization wants to use
			local matchItem = Amr:FindMatchingItem(optimalItem, player, usedItems)
			
			-- slot label
			local lbl = AceGUI:Create("AmrUiLabel")
			panelGear:AddChild(lbl)
			lbl:SetPoint("TOPLEFT", prevElem.frame, "BOTTOMLEFT", 0, -12) 
			lbl:SetText(Amr.SlotDisplayText[slotId])
			lbl:SetWidth(85)
			lbl:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.White))		
			prevElem = lbl
			
			-- ilvl label
			local lblIlvl = AceGUI:Create("AmrUiLabel")
			panelGear:AddChild(lblIlvl)
			lblIlvl:SetPoint("TOPLEFT", lbl.frame, "TOPRIGHT", 0, 0) 
			lblIlvl:SetWidth(45)
			lblIlvl:SetFont(Amr.CreateFont("Italic", 14, Amr.Colors.TextTan))		
			
			-- equipped label
			local lblEquipped = AceGUI:Create("AmrUiLabel")
			panelGear:AddChild(lblEquipped)
			lblEquipped:SetPoint("TOPLEFT", lblIlvl.frame, "TOPRIGHT", 0, 0) 
			lblEquipped:SetWidth(20)
			lblEquipped:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.White))
			lblEquipped:SetText(isEquipped and "E" or "")
			
			-- item name/link label
			local lblItem = AceGUI:Create("AmrUiLabel")
			panelGear:AddChild(lblItem)
			lblItem:SetPoint("TOPLEFT", lblEquipped.frame, "TOPRIGHT", 0, 0) 
			lblItem:SetWordWrap(false)
			lblItem:SetWidth(345)
			lblItem:SetFont(Amr.CreateFont(isEquipped and "Regular" or "Bold", isEquipped and 14 or 15, Amr.Colors.White))		
			
			-- fill the name/ilvl labels, which may require asynchronous loading of item information			
			if optimalItemLink then
				local gameItem = Item:CreateFromItemLink(optimalItemLink)
				if gameItem then
					local q = gameItem:GetItemQuality()
					if q == 6 then
						-- for artifacts, we consider it equipped if the item id alone matches
						if equippedItem and equippedItem.id == optimalItem.id then
							isEquipped = true
						end
						lblEquipped:SetText(isEquipped and "E" or "")
					end

					lblItem:SetFont(Amr.CreateFont(isEquipped and "Regular" or "Bold", isEquipped and 14 or 15, Amr.Colors.Qualities[q] or Amr.Colors.White))
					lblItem:SetText(gameItem:GetItemName())
					lblIlvl:SetText(gameItem:GetCurrentItemLevel())
					Amr:SetItemTooltip(lblItem, gameItem:GetItemLink(), "ANCHOR_TOPRIGHT")
				end
			end
						
			-- modifications
			if optimalItem then

				-- gems
				local prevSocket = nil

				for i = 1, #optimalItem.gemIds do
					-- we rely on the fact that the gear sets coming back from the site will almost always have all sockets filled,
					-- because it's a pain to get the actual number of sockets on an item from within the game
					local g = optimalItem.gemIds[i]
					if g == 0 then break end

					local isGemEquipped = matchItem and matchItem.gemIds and matchItem.gemIds[i] == g
					
					local socketBorder, socketIcon = createSocketWidget(panelMods, prevSocket or lblItem, prevSocket, isGemEquipped)
					
					-- get icon for optimized gem
					local gameItem = Item:CreateFromItemID(g)
					if gameItem then
						socketIcon:SetIcon(gameItem:GetItemIcon())
						Amr:SetItemTooltip(socketIcon, gameItem:GetItemLink(), "ANCHOR_TOPRIGHT")
					end
					
					prevSocket = socketBorder
				end

				-- enchant
				if optimalItem.enchantId and optimalItem.enchantId ~= 0 then
					local isEnchantEquipped = matchItem and matchItem.enchantId and matchItem.enchantId == optimalItem.enchantId

					local lblEnchant = AceGUI:Create("AmrUiLabel")
					panelMods:AddChild(lblEnchant)
					lblEnchant:SetPoint("TOPLEFT", lblItem.frame, "TOPRIGHT", 130, 0)
					lblEnchant:SetWordWrap(false)
					lblEnchant:SetWidth(170)
					lblEnchant:SetFont(Amr.CreateFont(isEnchantEquipped and "Regular" or "Bold", 14, isEnchantEquipped and Amr.Colors.TextGray or Amr.Colors.White))
					
					local enchInfo = Amr.db.char.ExtraEnchantData[optimalItem.enchantId]
					if enchInfo then
						lblEnchant:SetText(enchInfo.text)
						
						local gameItem = Item:CreateFromItemID(enchInfo.itemId)
						if gameItem then
							Amr:SetItemTooltip(lblEnchant, gameItem:GetItemLink(), "ANCHOR_TOPRIGHT")
						end
					end
					
				end
			end
			
			prevElem = lbl
		end
	end
end

local function onSetupChange(widget, eventName, value)
	_activeSetupId = value
	renderGear(_activeSetupId, _panelGear)
end

local function onImportClick(widget)
	Amr:ShowImportWindow()
end

function Amr:PickFirstSetupForSpec()
	local specSlot = 1 --GetSpecialization()
	for i, setup in ipairs(Amr.db.char.GearSetups) do
		if setup.SpecSlot == specSlot then
			_activeSetupId = setup.Id
			break
		end
	end
end

function Amr:GetActiveSetupId()
	return _activeSetupId
end

function Amr:SetActiveSetupId(setupId)
	_activeSetupId = setupId
end

function Amr:GetActiveSetupLabel()
	if not _activeSetupId then
		return nil
	end
	local setup = getSetupById(_activeSetupId)
	if not setup then
		return nil
	else
		return setup.Label
	end
end

-- renders the main UI for the Gear tab
function Amr:RenderTabGear(container)

	local btnImport = AceGUI:Create("AmrUiButton")
	btnImport:SetText(L.GearButtonImportText)
	btnImport:SetBackgroundColor(Amr.Colors.Orange)
	btnImport:SetFont(Amr.CreateFont("Bold", 16, Amr.Colors.White))
	btnImport:SetWidth(120)
	btnImport:SetHeight(26)
	btnImport:SetCallback("OnClick", onImportClick)
	container:AddChild(btnImport)	
	btnImport:SetPoint("TOPLEFT", container.content, "TOPLEFT", 0, -81)
	
	local lbl = AceGUI:Create("AmrUiLabel")
	container:AddChild(lbl)
	lbl:SetText(L.GearImportNote)
	lbl:SetWidth(100)
	lbl:SetFont(Amr.CreateFont("Italic", 12, Amr.Colors.TextTan))
	lbl:SetJustifyH("MIDDLE")
	lbl:SetPoint("TOP", btnImport.frame, "BOTTOM", 0, -5)
	
	local lbl2 = AceGUI:Create("AmrUiLabel")
	container:AddChild(lbl2)
	lbl2:SetText(L.GearTipTitle)
	lbl2:SetWidth(140)
	lbl2:SetFont(Amr.CreateFont("Italic", 20, Amr.Colors.Text))
	lbl2:SetJustifyH("MIDDLE")
	lbl2:SetPoint("TOP", lbl.frame, "BOTTOM", 0, -50)
	
	lbl = AceGUI:Create("AmrUiLabel")
	container:AddChild(lbl)
	lbl:SetText(L.GearTipText)
	lbl:SetWidth(140)
	lbl:SetFont(Amr.CreateFont("Italic", 12, Amr.Colors.Text))
	lbl:SetJustifyH("MIDDLE")
	lbl:SetPoint("TOP", lbl2.frame, "BOTTOM", 0, -5)
	
	lbl2 = AceGUI:Create("AmrUiLabel")
	container:AddChild(lbl2)
	lbl2:SetText(L.GearTipCommands)
	lbl2:SetWidth(130)
	lbl2:SetFont(Amr.CreateFont("Italic", 12, Amr.Colors.Text))
	lbl2:SetPoint("TOP", lbl.frame, "BOTTOM", 10, -5)
	
	_cboSetups = AceGUI:Create("AmrUiDropDown")
	_cboSetups:SetWidth(300)	
	container:AddChild(_cboSetups)
	_cboSetups:SetPoint("TOPLEFT", container.content, "TOPLEFT", 150, -27.5)
	
	_panelGear = AceGUI:Create("AmrUiPanel")
	_panelGear:SetLayout("None")
	_panelGear:SetBackgroundColor(Amr.Colors.Bg)
	container:AddChild(_panelGear)
	_panelGear:SetPoint("TOPLEFT", container.content, "TOPLEFT", 144, -58)
	_panelGear:SetPoint("BOTTOMRIGHT", container.content, "BOTTOMRIGHT")
	
	local btnShop = AceGUI:Create("AmrUiButton")
	container:AddChild(btnShop)
	btnShop:SetText(L.GearButtonShop)
	btnShop:SetBackgroundColor(Amr.Colors.Blue)
	btnShop:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.White))
	btnShop:SetWidth(200)
	btnShop:SetHeight(26)
	btnShop:SetCallback("OnClick", function(widget) Amr:ShowShopWindow() end)
	btnShop:SetPoint("TOPRIGHT", container.content, "TOPRIGHT", -42, -25)

	local btnJunk = AceGUI:Create("AmrUiButton")
	container:AddChild(btnJunk)
	btnJunk:SetText(L.GearButtonJunk)
	btnJunk:SetBackgroundColor(Amr.Colors.Blue)
	btnJunk:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.White))
	btnJunk:SetWidth(200)
	btnJunk:SetHeight(26)
	btnJunk:SetCallback("OnClick", function(widget) Amr:ShowJunkWindow() end)
	btnJunk:SetPoint("CENTER", btnShop.frame, "CENTER", 0, 36)

	-- pick a default tab based on player's current spec if none is already specified
	if not _activeSetupId then
		Amr:PickFirstSetupForSpec()
	end

	Amr:RefreshGearDisplay()

	-- set event on dropdown after UI has been initially rendered
	_cboSetups:SetCallback("OnChange", onSetupChange)
end

function Amr:ReleaseTabGear()
	_cboSetups = nil
	_panelGear = nil
end

-- refresh display of the current gear tab
function Amr:RefreshGearDisplay()

	if not _panelGear then
		return
	end

	-- fill the gear setup picker
	local setupList = {}
	for i, setup in ipairs(Amr.db.char.GearSetups) do
		table.insert(setupList, { text = setup.Label, value = setup.Id })
	end
	_cboSetups:SetItems(setupList)

	-- set selected value
	local prev = _activeSetupId
	_cboSetups:SelectItem(_activeSetupId)

	if prev == _activeSetupId then
		-- selecting will trigger the change event if it changed; if it didn't change, do a render now
		renderGear(_activeSetupId, _panelGear)
	end
end


------------------------------------------------------------------------------------------------
-- Gear Set Management
------------------------------------------------------------------------------------------------
local _waitingForSpec = 0
local _pendingGearOps = nil
local _currentGearOp = nil
local _itemLockAction = nil
local _gearOpPasses = 0
local _gearOpWaiting = nil

local beginEquipGearSet, processCurrentGearOp, nextGearOp

-- find the first empty slot in the player's backpack+bags
local function findFirstEmptyBagSlot(usedBagSlots)
	
	local bagIds = {}
	table.insert(bagIds, BACKPACK_CONTAINER)
	for bagId = 1, NUM_BAG_SLOTS do
		table.insert(bagIds, bagId)
	end
	
	for i, bagId in ipairs(bagIds) do
		local numSlots = C_Container.GetContainerNumSlots(bagId)
		for slotId = 1, numSlots do
			if not usedBagSlots or not usedBagSlots[bagId] or not usedBagSlots[bagId][slotId] then
				local itemLink = C_Container.GetContainerItemLink(bagId, slotId)
				if not itemLink then
					-- this prevents repeated calls to this from returning the same bag slot if desired
					if usedBagSlots then
						if not usedBagSlots[bagId] then
							usedBagSlots[bagId] = {}
						end
						usedBagSlots[bagId][slotId] = true
					end

					return bagId, slotId
				end
			end
		end
	end
	
	return nil, nil
end



-- scan a bag for the best matching item
local function scanBagForItem(item, bagId, bestItem, bestDiff, bestLink)
	local numSlots = C_Container.GetContainerNumSlots(bagId)
	--local loc = ItemLocation.CreateEmpty()
	local blizzItem
	for slotId = 1, numSlots do
		local itemLink = C_Container.GetContainerItemLink(bagId, slotId)
        -- we skip any stackable item, as far as we know, there is no equippable gear that can be stacked
		if itemLink then
			local bagItem = Amr.ParseItemLink(itemLink)
			if bagItem ~= nil then

				blizzItem = Item:CreateFromBagAndSlot(bagId, slotId)

				-- seems to be of the form Item-1147-0-4000000XXXXXXXXX, so we take just the last 9 digits
				bagItem.guid = blizzItem:GetItemGUID()
				if bagItem.guid and strlen(bagItem.guid) > 9 then
					bagItem.guid = strsub(bagItem.guid, -9)
				end

				-- see if this is an azerite item and read azerite power ids
				--[[loc:SetBagAndSlot(bagId, slotId)
				if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(loc) then
					local powers = Amr.ReadAzeritePowers(loc)
					if powers then
						bagItem.azerite = powers
					end
				end]]

				local diff = countItemDifferences(item, bagItem)
				if diff < bestDiff then
					bestItem = { bag = bagId, slot = slotId }
					bestDiff = diff
					bestLink = itemLink
				end
            end
		end
	end
	return bestItem, bestDiff, bestLink
end

-- find the item in the player's inventory that best matches the current gear op item, favoring stuff already equipped, then in bags, then in bank
local function findCurrentGearOpItem()

	local item = _currentGearOp.items[_currentGearOp.nextSlot]

	local bestItem = nil
	local bestLink = nil
	local bestDiff = 10000
	
	-- inventory
	bestItem, bestDiff, bestLink = scanBagForItem(item, BACKPACK_CONTAINER, bestItem, bestDiff, bestLink)
	for bagId = 1, NUM_BAG_SLOTS do
		bestItem, bestDiff, bestLink = scanBagForItem(item, bagId, bestItem, bestDiff, bestLink)
	end

	-- with new approach, the item to use should never be equipped, should be in bags at this point
	--[[
	-- equipped items, but skip slots we have just equipped (to avoid e.g. just moving 2 of the same item back and forth between mh oh weapon slots)
	for slotNum = 1, #Amr.SlotIds do
		local slotId = Amr.SlotIds[slotNum]
		if _currentGearOp.slotsRemaining[slotId] then
			local itemLink = GetInventoryItemLink("player", slotId)
			if itemLink then
				local invItem = Amr.ParseItemLink(itemLink)
				if invItem then
					local diff = countItemDifferences(item, invItem)
					if diff < bestDiff then
						bestItem = { slot = slotId }
						bestDiff = diff
						bestLink = itemLink
					end
				end
			end
		end
	end
	]]

	-- bank
	if bestDiff > 0 then
		bestItem, bestDiff, bestLink = scanBagForItem(item, BANK_CONTAINER, bestItem, bestDiff, bestLink)
		for bagId = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
			bestItem, bestDiff, bestLink = scanBagForItem(item, bagId, bestItem, bestDiff, bestLink)
		end
	end

	return bestItem, bestDiff, bestLink
end

local function createAmrEquipmentSet()
	
	-- clear any currently ignored slots, ignore shirt and tabard
    C_EquipmentSet.ClearIgnoredSlotsForSave()
    C_EquipmentSet.IgnoreSlotForSave(INVSLOT_BODY) -- shirt
    C_EquipmentSet.IgnoreSlotForSave(INVSLOT_TABARD)
		
	-- for now use icon of the spec
	--local _, specName, _, setIcon = GetSpecializationInfo(GetSpecialization())
	
	local setIcon = nil
	local item = Amr.ParseItemLink(GetInventoryItemLink("player", INVSLOT_MAINHAND))
	if not item then
		item = Amr.ParseItemLink(GetInventoryItemLink("player", INVSLOT_OFFHAND))
	end
	if item then
		local itemObj = Item:CreateFromItemID(item.id)
		if itemObj then
			setIcon = itemObj:GetItemIcon()
		end
	end
	if not setIcon then
		local _, clsEn = UnitClass("player")
		setIcon = Amr.ClassIcons[clsEn]
	end

	local setup = getSetupById(_activeSetupId)
	local setname = setup.Label -- "AMR " .. specName
	local setid = C_EquipmentSet.GetEquipmentSetID(setname)
	if setid then
		local oldName, oldIcon = C_EquipmentSet.GetEquipmentSetInfo(setid)
		setIcon = oldIcon
		C_EquipmentSet.SaveEquipmentSet(setid, setIcon)
	else
		C_EquipmentSet.CreateEquipmentSet(setname, setIcon)
	end
end

-- on completion, create an equipment manager set if desired
local function onEquipGearSetComplete()
	if Amr.db.profile.options.disableEm then return end
	
	-- create an equipment manager set
	createAmrEquipmentSet()

	-- need to call it twice because on first load the WoW equipment manager just doesn't work
	Amr.Wait(1, function()
		createAmrEquipmentSet()
	end)
end

-- stop any currently in-progress gear swapping operation and clean up
local function disposeGearOp()
	_pendingGearOps = nil
	_currentGearOp = nil
	_itemLockAction = nil
	_gearOpPasses = 0
	_gearOpWaiting = nil

	-- make sure the gear tab is still in sync
	Amr:RefreshGearDisplay()
end

-- initialize a gear op to start running it
local function initializeGearOp(op, setupId, pos)
	op.pos = pos
	op.setupId = setupId

	-- fill the remaining slot list and set the starting slot
	op.nextSlot = nil
	op.slotsRemaining = {}	
	op.isWaiting = false
	for slotId, item in pairs(op.items) do
		op.slotsRemaining[slotId] = true
		if not op.nextSlot then
			op.nextSlot = slotId
		end			
	end
end

function processCurrentGearOp()
	if not _currentGearOp then return end

	if _currentGearOp.remove then
		-- remove the next item

		-- check if the slot is already empty
		local itemLink = GetInventoryItemLink("player", _currentGearOp.nextSlot)
		if not itemLink then
			nextGearOp()
			return
		end

		-- find first empty bag slot
		local invBag, invSlot = findFirstEmptyBagSlot()
		if not invBag then
			-- stop if bags are too full
			Amr:Print(L.GearEquipErrorBagFull)
			disposeGearOp()
			return
		end

		PickupInventoryItem(_currentGearOp.nextSlot)
		C_Container.PickupContainerItem(invBag, invSlot)

		-- set an action to happen on ITEM_UNLOCKED, triggered by ClearCursor
		_itemLockAction = {
			bagId = invBag,
			slotId = invSlot,
			isRemove = true			
		}

		ClearCursor()
		-- wait for remove to complete
	else
		-- equip the next item
		
		local bestItem, bestDiff, bestLink = findCurrentGearOpItem()
		
		_itemLockAction = nil
		ClearCursor()
	
		if not bestItem then
			-- stop if we can't find an item
			Amr:Print(L.GearEquipErrorNotFound)
			Amr:Print(L.GearEquipErrorNotFound2)
			disposeGearOp()
			
		elseif bestItem and bestItem.bag and (bestItem.bag == BANK_CONTAINER or bestItem.bag >= NUM_BAG_SLOTS + 1 and bestItem.bag <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) then
			-- find first empty bag slot
			local invBag, invSlot = findFirstEmptyBagSlot()
			if not invBag then
				-- stop if bags are too full
				Amr:Print(L.GearEquipErrorBagFull)
				disposeGearOp()
				return
			end
	
			-- move from bank to bag
			C_Container.PickupContainerItem(bestItem.bag, bestItem.slot)
			C_Container.PickupContainerItem(invBag, invSlot)
	
			-- set an action to happen on ITEM_UNLOCKED, triggered by ClearCursor
			_itemLockAction = {
				bagId = invBag,
				slotId = invSlot,
				isBank = true			
			}
			
			ClearCursor()			
			-- now we need to wait for game event to continue and try this item again after it is in our bag and unlocked

		elseif (bestItem.bag or bestItem.bag == 0) and not Amr:CanEquip(bestItem.bag, bestItem.slot) then
			-- if an item is not soulbound, then warn the user and quit
			Amr:Print(L.GearEquipErrorSoulbound(bestLink))
			disposeGearOp()

		else

			--print("equipping " .. bestLink .. " in slot " .. _currentGearOp.nextSlot)

			-- an item in the player's bags or already equipped, equip it
			if bestItem.bag then
				C_Container.PickupContainerItem(bestItem.bag, bestItem.slot)
			else
				_gearOpWaiting.inventory[bestItem.slot] = true
				PickupInventoryItem(bestItem.slot)
			end
			_gearOpWaiting.inventory[_currentGearOp.nextSlot] = true
			PickupInventoryItem(_currentGearOp.nextSlot)

			-- don't wait for now, do all equips at once
			--[[
			-- set an action to happen on ITEM_UNLOCKED, triggered by ClearCursor
			_itemLockAction = {
				bagId = bestItem.bag,
				slotId = bestItem.slot,
				invSlot = _currentGearOp.nextSlot,
				isEquip = true
			}
			]]

			ClearCursor()			
			nextGearOp()			
		end

	end
end

-- when a gear op completes successfully, this will advance to the next op or finish
function nextGearOp()
	if not _currentGearOp then return end

	local setupId = _currentGearOp.setupId
	local pos = _currentGearOp.pos
	local passes = _gearOpPasses	

	-- mark the slot as done and move to the next
	if _currentGearOp.nextSlot then
		_currentGearOp.slotsRemaining[_currentGearOp.nextSlot] = nil
		_currentGearOp.nextSlot = nil
		for slotId, item in pairs(_currentGearOp.items) do
			if _currentGearOp.slotsRemaining[slotId] then
				_currentGearOp.nextSlot = slotId
				break
			end
		end
	end

	if not _currentGearOp.nextSlot then
		-- see if anything is still in progress and we want to wait for it before continuing		
		local inProgress = not Amr.IsEmpty(_gearOpWaiting.inventory)

		if (_currentGearOp.wait or _currentGearOp.remove) and inProgress then
			-- this will cause the item unlock handler to call nextGearOp again when all in-progress swaps have unlocked related slots
			_currentGearOp.isWaiting = true
		else
			_currentGearOp = _pendingGearOps[pos + 1]
			if _currentGearOp then
				-- we have another op, do it
				initializeGearOp(_currentGearOp, setupId, pos + 1)
				processCurrentGearOp()
			else
				-- we are done
				disposeGearOp()

				-- this will check if not all items were swapped, and either finish up, try again, or abort if have tried too many times
				beginEquipGearSet(setupId, passes + 1)
			end
		end
	else
		-- do the next item
		processCurrentGearOp()
	end

end

local function handleItemUnlocked(bagId, slotId)

	-- mark anything that is waiting as unlocked if it is no longer locked
	if _currentGearOp and _gearOpWaiting then
		for i,s in ipairs(Amr.SlotIds) do
			if not IsInventoryItemLocked(s) then
				_gearOpWaiting.inventory[s] = nil
			end
		end
	end

	if _itemLockAction then
		if _itemLockAction.isRemove then
			-- waiting for a specific remove op to finish before continuing
			if bagId == _itemLockAction.bagId and slotId == _itemLockAction.slotId then
				_itemLockAction = nil
				nextGearOp()
			end
		elseif _itemLockAction.isBank then
			-- waiting for an item to move from bank into inventory, then reprocess the current op
			if bagId == _itemLockAction.bagId and slotId == _itemLockAction.slotId then
				_itemLockAction = nil
				processCurrentGearOp()
			end

		elseif _itemLockAction.isEquip then
			-- this is not currently used... we do all equips at once usually, but could go back to this if it causes problems

			-- waiting for a specific equip op to finish
			
			-- inventory slot we're swapping to is still locked, can't continue yet
			if IsInventoryItemLocked(_itemLockAction.invSlot) then return end

			if _itemLockAction.bagId then
				local _, _, locked = C_Container.GetContainerItemInfo(_itemLockAction.bagId, _itemLockAction.slotId)
				-- the bag slot we're swapping from is still locked, can't continue yet
				if locked then return end
			else
				-- inventory slot we're swapping from is still locked, can't continue yet
				if IsInventoryItemLocked(_itemLockAction.slotId) then return end
			end
			
			_itemLockAction = nil
			nextGearOp()
		else
			-- unknown... shouldn't happen
			_itemLockAction = nil
		end
	else
		
		-- not waiting on a specific action, check if we are waiting for all locked slots to open up and they are done
		if _currentGearOp and _gearOpWaiting and _currentGearOp.isWaiting and Amr.IsEmpty(_gearOpWaiting.inventory) then
			nextGearOp()
		end	
	end
	
end

local function shuffle(tbl)
	local size = #tbl
	for i = size, 1, -1 do
		local rand = math.random(size)
		tbl[i], tbl[rand] = tbl[rand], tbl[i]
	end
	return tbl
end

--[[
local _ohFirst = {
    [20] = true, -- PaladinProtection
    [32] = true, -- WarlockDemonology
    [36] = true -- WarriorProtection
}
]]

function beginEquipGearSet(setupId, passes)

	local setup = getSetupById(setupId)
	
	if not setup or not setup.Gear then 
		Amr:Print(L.GearEquipErrorEmpty)
		return
	end

	local gear = setup.Gear
	local spec = setup.SpecSlot

	-- ensure all our stored data is up to date	
	local player = Amr:ExportCharacter()
	local doOhFirst = false -- _ohFirst[player.Specs[spec]]

	local itemsToEquip = {
		legendaries = {},
		weapons = {},
		mh = {},
		oh = {},
		rings = {},
		trinkets = {},
		others = {},
		blanks = {}
	}
	local remaining = 0
	local usedItems = {}

	-- check for items that need to be equipped, do in a random order to try and defeat any unique constraint issues we might hit
	local slots = {}
	for i,s in ipairs(Amr.SlotIds) do
		table.insert(slots, s)
	end
	shuffle(slots)

	for i,slotId in ipairs(slots) do

		-- we do stuff in batches that avoids most unique conflicts
		local list = itemsToEquip.others
		if slotId == 16 then
			list = itemsToEquip.mh
		elseif slotId == 17 then
			list = itemsToEquip.oh
		elseif slotId == 11 or slotId == 12 then
			list = itemsToEquip.rings
		elseif slotId == 13 or slotId == 14 then
			list = itemsToEquip.trinkets
		end

		local old = player.Equipped[spec][slotId]
		local new = gear[slotId]
		local prevRemaining = remaining
		if new then
			-- if the new thing is an artifact, only match the item id
			local newItem = Item:CreateFromItemID(new.id)
			local quality = newItem and newItem:GetItemQuality() or 0
			if quality == 6 then
				if not old or new.id ~= old.id then
					list[slotId] = new
					if list == itemsToEquip.mh or list == itemsToEquip.oh then
						itemsToEquip.weapons[slotId] = {}
					end
					remaining = remaining + 1
				end
			else

				-- find the best matching item anywhere in the player's gear
				local bestItem, bestDiff = Amr:FindMatchingItem(new, player, usedItems)
				new = bestItem

				local diff = countItemDifferences(new, old)				

				if diff > 0 then	
					list[slotId] = new
					if list == itemsToEquip.mh or list == itemsToEquip.oh then
						itemsToEquip.weapons[slotId] = {}
					end
					remaining = remaining + 1
				end
			end
		elseif old then
			-- need to remove this item
			itemsToEquip.blanks[slotId] = {}
			remaining = remaining + 1
		end

		if remaining > prevRemaining then
			-- if we need to swap this slot, see if the old item is a legendary, add a step to remove those first to avoid conflicts
			if old then
				local oldItem = Item:CreateFromItemID(old.id)
				if oldItem and oldItem:GetItemQuality() == 5 then				
					itemsToEquip.legendaries[slotId] = {}
				end
			end
		end
	end
	
	if remaining > 0 then

		if passes < 5 then
			_pendingGearOps = {}

			if not Amr.IsEmpty(itemsToEquip.blanks) then				
				-- if gear set wants slots to be blank, do that first
				table.insert(_pendingGearOps, { items = itemsToEquip.blanks, remove = true, label = "blanks" }) 
			end			
			if not Amr.IsEmpty(itemsToEquip.weapons) then
				-- change weapons first: remove both, wait, then equip each weapon one by one, waiting after each
				table.insert(_pendingGearOps, { items = itemsToEquip.weapons, remove = true, label = "remove weapons" })
				local thisWeapon = doOhFirst and itemsToEquip.oh or itemsToEquip.mh
				if not Amr.IsEmpty(thisWeapon) then
					table.insert(_pendingGearOps, { items = thisWeapon, wait = true, label = "equip weapon 1" })
				end
				thisWeapon = doOhFirst and itemsToEquip.mh or itemsToEquip.oh
				if not Amr.IsEmpty(thisWeapon) then
					table.insert(_pendingGearOps, { items = thisWeapon, wait = true, label = "equip weapon 2" })
				end
			end
			if not Amr.IsEmpty(itemsToEquip.legendaries) then 
				-- remove any legendaries, wait
				table.insert(_pendingGearOps, { items = itemsToEquip.legendaries, remove = true, label = "remove legendaries" }) 
			end
			if not Amr.IsEmpty(itemsToEquip.rings) then 
				-- remove both rings, wait, then equip new ones
				table.insert(_pendingGearOps, { items = itemsToEquip.rings, remove = true, label = "remove rings" })
				table.insert(_pendingGearOps, { items = itemsToEquip.rings, wait = true, label = "equip rings" })
			end
			if not Amr.IsEmpty(itemsToEquip.trinkets) then 
				-- remove both trinkets, wait, then equip new ones
				table.insert(_pendingGearOps, { items = itemsToEquip.trinkets, remove = true, label = "remove trinkets" })
				table.insert(_pendingGearOps, { items = itemsToEquip.trinkets, wait = true, label = "equip trinkets" })
			end
			if not Amr.IsEmpty(itemsToEquip.others) then 
				-- equip all other items, wait for completion
				table.insert(_pendingGearOps, { items = itemsToEquip.others, wait = true, label = "equip others" }) 
			end

			if #_pendingGearOps > 0 then			
				-- make the last operation wait no matter what, before this gets called again to check if everything succeeded
				_pendingGearOps[#_pendingGearOps].wait = true

				if not _gearOpWaiting then
					_gearOpWaiting = { inventory = {} }
				end

				_gearOpPasses = passes
				_currentGearOp = _pendingGearOps[1]
				initializeGearOp(_currentGearOp, setupId, 1)

				processCurrentGearOp()
			else
				-- TODO: print message that gear set couldn't be equipped
			end
			
		else
			-- TODO: print message that gear set couldn't be equipped
		end

	else
		onEquipGearSetComplete()
	end	
end

--[[
local function onActiveTalentGroupChanged()

	local auto = Amr.db.profile.options.autoGear
	local currentSpec = GetSpecialization()
	local waitingSpec = _waitingForSpec
	_waitingForSpec = 0
	
	-- when spec changes, change active setup to first one for this spec (does nothing if they have no setups for this spec)
	if _activeSetupId then
		local currentSetup = getSetupById(_activeSetupId)
		if currentSetup.SpecSlot ~= currentSpec then
			Amr:PickFirstSetupForSpec()
		end
	end

	if currentSpec == waitingSpec or auto then
		-- spec is what we want, now equip the gear but after a short delay because the game auto-swaps artifact weapons
		Amr.Wait(2, function()
			beginEquipGearSet(_activeSetupId, 0)
		end)
	end
end
]]

-- activate the specified spec and then equip the saved gear set
function Amr:EquipGearSet(setupIndex)
	
	-- if no argument, then cycle
	if not setupIndex then
		if not _activeSetupId then
			Amr:PickFirstSetupForSpec()
		end
		for i,setup in ipairs(Amr.db.char.GearSetups) do
			if setup.Id == _activeSetupId then
				setupIndex = i
				break
			end
		end
		if not setupIndex then
			setupIndex = 1
		else
			setupIndex = setupIndex + 1
		end
	end

	setupIndex = tonumber(setupIndex)

	if setupIndex > #Amr.db.char.GearSetups then
		setupIndex = 1
	end

	if UnitAffectingCombat("player") then
		Amr:Print(L.GearEquipErrorCombat)
		return
	end
	
	_activeSetupId = Amr.db.char.GearSetups[setupIndex].Id
	Amr:RefreshGearDisplay()

	local setup = Amr.db.char.GearSetups[setupIndex]

	--[[
	local currentSpec = GetSpecialization()
	if currentSpec ~= setup.SpecSlot then
		_waitingForSpec = setup.SpecSlot
		SetSpecialization(setup.SpecSlot)
	else
	]]
		-- spec is what we want, now equip the gear
		beginEquipGearSet(_activeSetupId, 0)
	--end
end

-- moves any gear in bags to the bank if not part of a gear set
function Amr:CleanBags()
	-- TODO: implement
end

--[[
local function testfunc(message)
	print(strsub(message, 13))
end
]]

function Amr:InitializeGear()
	--Amr:AddEventHandler("ACTIVE_TALENT_GROUP_CHANGED", onActiveTalentGroupChanged)

	--Amr:AddEventHandler("CHAT_MSG_CHANNEL", testfunc)
	
	Amr:AddEventHandler("UNIT_INVENTORY_CHANGED", function(unitID)
		if unitID and unitID ~= "player" then return end
		
		-- don't update during a gear operation, wait until it is totally finished
		if _pendingGearOps then return end

		Amr:RefreshGearDisplay()
	end)

	Amr:AddEventHandler("ITEM_UNLOCKED", handleItemUnlocked)
end


-- export some local methods we need elsewhere
Amr.CountItemDifferences = countItemDifferences
Amr.FindFirstEmptyBagSlot = findFirstEmptyBagSlot
