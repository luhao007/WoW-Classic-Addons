local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")
local L = LibStub("AceLocale-3.0"):GetLocale("AskMrRobotClassic", true)
local AceGUI = LibStub("AceGUI-3.0")

local _frameJunk
local _lblAction
local _lblBank
local _btnBank
local _panelContent

local _canDisenchant = false
local _isScrapOpen = false
local _isMerchantOpen = false
local _isBankOpen = false

--
-- Scan a bag for the specified item, returning the first exact match found
--
local function scanBag(bagId, matchItem, usedItems)

	local numSlots = GetContainerNumSlots(bagId)
    
    if not usedItems[bagId] then
        usedItems[bagId] = {}
    end

    local bestMatchDiffs = 1000000
    local bestMatch = nil
    local threshold

    for slotId = 1, numSlots do
        if not usedItems[bagId][slotId] then
            local _, itemCount, _, _, _, _, itemLink = GetContainerItemInfo(bagId, slotId)
            if itemLink ~= nil then
                local itemData = Amr.Serializer.ParseItemLink(itemLink)
                if itemData ~= nil then                    
                    -- see if it matches
                    local diffs = Amr.CountItemDifferences(matchItem, itemData)
                    if diffs == 0 then
                        usedItems[bagId][slotId] = true
                        itemData.bagId = bagId
                        itemData.slotId = slotId
                        return itemData
                    elseif diffs < 10000 then                        
                        threshold = 10000

                        if diffs < threshold and diffs < bestMatchDiffs then
                            -- closest match we could find
                            bestMatchDiffs = diffs
                            itemData.bagId = bagId
                            itemData.slotId = slotId
                            bestMatch = itemData
                        end
                    end
                end
            end
        end
    end

    -- if we couldn't get a perfect match, take the best match that might have some small differences like
    -- an old school enchant or upgrade ID that didn't load    
    if bestMatch then
        usedItems[bestMatch.bagId][bestMatch.slotId] = true
        return bestMatch
    else
        return nil
    end
end

--
-- Find a matching item in the player's bags
--
local function findMatchingBagItem(item, usedItems)

    local matchItem = scanBag(BACKPACK_CONTAINER, item, usedItems) -- backpack
    if not matchItem then
        for bagId = 1, NUM_BAG_SLOTS do
            matchItem = scanBag(bagId, item, usedItems)
            if matchItem then break end
        end
    end
    
    return matchItem
end


--
-- item actions
--
local _deSpellName = GetSpellInfo(13262);
local _deMacro = "/stopmacro [combat][btn:2]\n/stopcasting\n/cast %s\n/use %s %s";

local function onItemPreClick(widget)

    local item = widget:GetUserData("itemData")
    
    if item and _canDisenchant and (not _isScrapOpen and not _isMerchantOpen) then
        -- only way i can find to disenchant and item on click is to call a macro, gross but works
        local matchItem = findMatchingBagItem(item, {})
        if matchItem then
            widget:SetMacroText(_deMacro:format(_deSpellName, matchItem.bagId, matchItem.slotId))
        else
            widget:SetMacroText(nil)
            Amr:Print(L.JunkItemNotFound)
        end
    else
        widget:SetMacroText(nil)
    end
end

local function onItemClick(widget)
    
    local item = widget:GetUserData("itemData")
    if not item then return end

    local action = nil
    if _isScrapOpen then
        action = "scrap"
    elseif _isMerchantOpen then
        action = "sell"
    elseif _canDisenchant then
        action = "disenchant"
    end

    if not action then return end

    local matchItem = findMatchingBagItem(item, {})
    if matchItem then
        if action == "scrap" then
            UseContainerItem(matchItem.bagId, matchItem.slotId)
        elseif action == "sell" then
            UseContainerItem(matchItem.bagId, matchItem.slotId)
        end

        -- note for disenchant, the macro has handled the action, this will simply remove the item from the list

        -- re-render the list with this item removed;
        -- AceGUI doesn't give a good way to remove a ui element from a container and re-render, 
        -- so we sort of hack it and modify the collection of children directly, 
        -- avoids the expensive logic of finding and matching all the items when the list changes as a user sells stuff
        local scroll = widget.parent.parent
        local newChildren = {}
        for i = 1, #scroll.children do
            local child = scroll.children[i]
            if child ~= widget.parent then
                table.insert(newChildren, child)
            end
        end
        scroll.children = newChildren

        -- dispose the item just removed, then re-render the list
        widget.parent:Release()
        widget.parent.parent:DoLayout()
    else
        Amr:Print(L.JunkItemNotFound)
    end
end


--
-- bank withdraw stuff
--
local _bankUsedBagSlots = nil
local finishBankWithdraw
local doBankWithdraw

finishBankWithdraw = function()

    local done = true

    if _isBankOpen and _bankUsedBagSlots then
        for bagId,v in pairs(_bankUsedBagSlots) do
            for slotId,v in pairs(v) do
                local _, _, _, _, _, _, itemLink = GetContainerItemInfo(bagId, slotId)
                if not itemLink then
                    done = false
                    break
                end
            end
            if not done then break end
        end
    end

    if not done then
        -- wait a second and try again
        Amr.Wait(1, function()
            doBankWithdraw()
        end)
    else

        -- reset state
        _bankUsedBagSlots = nil
        _btnBank:SetDisabled(not _isBankOpen)

        -- re-render the junk list
        Amr:RefreshJunkUi()
    end
end

doBankWithdraw = function()
    if not _isBankOpen then return end

    local data = Amr.db.char.JunkData
    if not data.Junk then return end
    
    -- disable button while processing
    _btnBank:SetDisabled(true)

    local bagList = {}
	table.insert(bagList, BANK_CONTAINER)
	for bagId = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		table.insert(bagList, bagId)
	end

    local usedItems = {}
    _bankUsedBagSlots = {}

    for i,item in ipairs(data.Junk) do
        -- stop immediately if the bank is closed
        if not _isBankOpen then 
            finishBankWithdraw()
            return
        end

        -- check if already in bags
        local matchItem = findMatchingBagItem(item, usedItems)
        if not matchItem then
            -- find it in the bank
            for j = 1, #bagList do
                matchItem = scanBag(bagList[j], item, usedItems)
                if matchItem then break end
            end
        else
            matchItem = nil
        end

        if matchItem then            
            -- move it to the player's bags if there is space
            local bagId, slotId = Amr.FindFirstEmptyBagSlot(_bankUsedBagSlots)
            if bagId then
                UseContainerItem(matchItem.bagId, matchItem.slotId)
            else
                -- no more empty bag slots
                break
            end
        end
    end

    -- wait a second and see if all the moves actually finished
    Amr.Wait(1, function()
        finishBankWithdraw()
    end)
end

local function onBankClick()
    if not _frameJunk or not _isBankOpen then return end

	doBankWithdraw()
end


local function onJunkFrameClose(widget)
	AceGUI:Release(widget)
    _frameJunk = nil
    _lblAction = nil
    _lblBank = nil
    _btnBank = nil
    _panelContent = nil
end

function Amr:HideJunkWindow()
	if not _frameJunk then return end
	_frameJunk:Hide()
end

function Amr:ShowJunkWindow()

    if InCombatLockdown() then return end
    
	if not _frameJunk then
		_frameJunk = AceGUI:Create("AmrUiFrame")
		_frameJunk:SetStatusTable(Amr.db.profile.junkWindow) -- window position is remembered in db
		_frameJunk:SetCallback("OnClose", onJunkFrameClose)
		_frameJunk:SetLayout("None")
		_frameJunk:SetWidth(400)
		_frameJunk:SetHeight(700)
		_frameJunk:SetBorderColor(Amr.Colors.BorderBlue)
		_frameJunk:SetBackgroundColor(Amr.Colors.Bg)
		
		if Amr.db.profile.options.uiScale ~= 1 then
			local scale = tonumber(Amr.db.profile.options.uiScale)
			_frameJunk:SetScale(scale)
		end
		
		local lbl = AceGUI:Create("AmrUiLabel")
		_frameJunk:AddChild(lbl)
		lbl:SetWidth(300)
		lbl:SetFont(Amr.CreateFont("Bold", 28, Amr.Colors.White))
		lbl:SetText(L.JunkTitle)
		lbl:SetWordWrap(false)
		lbl:SetJustifyH("CENTER")
		lbl:SetPoint("TOP", _frameJunk.content, "TOP", 0, 30)		
		lbl:SetCallback("OnMouseDown", function(widget) _frameJunk:StartMove() end)
		lbl:SetCallback("OnMouseUp", function(widget) _frameJunk:EndMove() end)
        
        _lblAction = AceGUI:Create("AmrUiLabel")
        _frameJunk:AddChild(_lblAction)
        _lblAction:SetWidth(380)
        _lblAction:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.TextTan))
        _lblAction:SetText(" ")
        _lblAction:SetWordWrap(false)
        _lblAction:SetPoint("TOPLEFT", _frameJunk.content, "TOPLEFT", 0, -10)

        _btnBank = AceGUI:Create("AmrUiButton")
        _frameJunk:AddChild(_btnBank)
        _btnBank:SetText(L.JunkButtonBank)
        _btnBank:SetBackgroundColor(Amr.Colors.Green)
        _btnBank:SetFont(Amr.CreateFont("Bold", 14, Amr.Colors.White))
        _btnBank:SetWidth(180)
        _btnBank:SetHeight(26)
        _btnBank:SetDisabled(true)
        _btnBank:SetCallback("OnClick", onBankClick)
        _btnBank:SetPoint("BOTTOMLEFT", _frameJunk.content, "BOTTOMLEFT")

        _lblBank = AceGUI:Create("AmrUiLabel")
        _frameJunk:AddChild(_lblBank)
        _lblBank:SetWidth(380)
        _lblBank:SetFont(Amr.CreateFont("Bold", 15, Amr.Colors.TextHeaderActive))
        _lblBank:SetText(L.JunkBankText(0))
        _lblBank:SetPoint("BOTTOMLEFT", _btnBank.frame, "TOPLEFT", 0, 10)

        local line = AceGUI:Create("AmrUiPanel")
        _frameJunk:AddChild(line)
        line:SetHeight(1)
        line:SetBackgroundColor(Amr.Colors.White)
        line:SetPoint("TOPLEFT", _frameJunk.content, "TOPLEFT", 0, -30)
        line:SetPoint("TOPRIGHT", _frameJunk.content, "TOPRIGHT", 0, -30)

        line = AceGUI:Create("AmrUiPanel")
        _frameJunk:AddChild(line)
        line:SetHeight(1)
        line:SetBackgroundColor(Amr.Colors.White)
        line:SetPoint("TOPLEFT", _frameJunk.content, "BOTTOMLEFT", 0, 60)
        line:SetPoint("TOPRIGHT", _frameJunk.content, "BOTTOMRIGHT", 0, 60)

        _panelContent = AceGUI:Create("AmrUiPanel")
		_panelContent:SetLayout("None")
		_panelContent:SetTransparent()
		_frameJunk:AddChild(_panelContent)
		_panelContent:SetPoint("TOPLEFT", _frameJunk.content, "TOPLEFT", 0, -31)
        _panelContent:SetPoint("BOTTOMRIGHT", _frameJunk.content, "BOTTOMRIGHT", 0, 60)
        

		Amr:RefreshJunkUi()
	else
		_frameJunk:Show()
		Amr:RefreshJunkUi()
	end
	
	_frameJunk:Raise()
end

local function canDisenchant()


    --[[
    local prof1, prof2 = GetProfessions();
    local profs = {}
    table.insert(profs, prof1)
    table.insert(profs, prof2)
    for i,prof in ipairs(profs) do
        if prof then
            local _, _, skillLevel, _, _, _, skillLine = GetProfessionInfo(prof);
            if Amr.ProfessionSkillLineToName[skillLine] == "Enchanting" and skillLevel > 0 then
                return true
            end
        end
    end

    return false
    ]]

    -- professions are a pain in classic... just return true for now
    return true
end

--
-- Find a matching item that is not in the player's inventory (bank or equipped)
--
local function findMatchingNonBagItem(matchItem, usedItems)

    -- check equipped
    local equippedBagId = -1000
    if not usedItems[equippedBagId] then
        usedItems[equippedBagId] = {}
    end

	for slotNum = 1, #Amr.SlotIds do
        local slotId = Amr.SlotIds[slotNum]
        if not usedItems[equippedBagId][slotId] then
            local itemLink = GetInventoryItemLink("player", slotId)
            if itemLink then
                local itemData = Amr.ParseItemLink(itemLink)
                if itemData then
                    -- see if it matches
                    if Amr.CountItemDifferences(matchItem, itemData) == 0 then
                        usedItems[equippedBagId][slotId] = true
                        itemData.bagId = bagId
                        itemData.slotId = slotId
                        return itemData
                    end
                end
            end
        end
    end
    
    -- check bank data
    local bestMatchDiffs = 100000
    local bestMatch = nil
    local threshold

    if Amr.db.char.BankItems then
        for bagId, v in pairs(Amr.db.char.BankItems) do            
            if not usedItems[bagId] then
                usedItems[bagId] = {}
            end

            for i, itemData in ipairs(v) do
                if itemData and not usedItems[bagId][i] then
                    -- see if it matches
                    local diffs = Amr.CountItemDifferences(matchItem, itemData)
                    if diffs == 0 then
                        usedItems[bagId][i] = true
                        itemData.bagId = bagId
                        itemData.slotId = i
                        return itemData
                    elseif diffs < 10000 then                        
                        threshold = 10000

                        if diffs < threshold and diffs < bestMatchDiffs then
                            -- closest match we could find
                            bestMatchDiffs = diffs
                            itemData.bagId = bagId
                            itemData.slotId = i
                            bestMatch = itemData
                        end
                    end
                end
            end
        end
    end

    -- if we couldn't get a perfect match, take the best match that might have some small differences like
    -- an old school enchant or upgrade ID that didn't load    
    if bestMatch then
        usedItems[bestMatch.bagId][bestMatch.slotId] = true
        return bestMatch
    else
        return nil
    end
end

local function renderItem(item, itemLink, scroll)

    local panel = AceGUI:Create("AmrUiPanel")
	scroll:AddChild(panel)
	panel:SetLayout("None")
	panel:SetTransparent()
	panel:SetWidth(380)
	panel:SetHeight(40)

    -- ilvl label
    local lblIlvl = AceGUI:Create("AmrUiLabel")
    panel:AddChild(lblIlvl)
    lblIlvl:SetPoint("LEFT", panel.content, "LEFT", 0, 0) 
    lblIlvl:SetWidth(35)
    lblIlvl:SetFont(Amr.CreateFont("Italic", 13, Amr.Colors.TextTan))		

    -- icon
    local icon = AceGUI:Create("AmrUiIcon")
    panel:AddChild(icon)
    icon:SetBorderWidth(1)
    icon:SetIconBorderColor(Amr.Colors.White)
    icon:SetWidth(28)
    icon:SetHeight(28)
    icon:SetPoint("LEFT", lblIlvl.frame, "RIGHT", 0, 0)

    -- item name/link label
    local lblItem = AceGUI:Create("AmrUiTextButton")
    panel:AddChild(lblItem)
    lblItem:SetPoint("LEFT", icon.frame, "RIGHT", 0, 0) 
    lblItem:SetWordWrap(false)
    lblItem:SetJustifyH("LEFT")
    lblItem:SetWidth(300)
    lblItem:SetHeight(28)
    lblItem:SetFont(Amr.CreateFont("Regular", 13, Amr.Colors.White))		
    lblItem:SetHoverBackgroundColor(Amr.Colors.Black, 0.3)
    lblItem:SetTextPadding(0, 0, 0, 5)
    lblItem:SetCallback("PreClick", onItemPreClick)
    lblItem:SetCallback("OnClick", onItemClick)
    lblItem:SetUserData("itemData", item)

    -- fill the name/ilvl labels, which may require asynchronous loading of item information			
    if itemLink then
        local gameItem = Item:CreateFromItemLink(itemLink)
        if gameItem then
            local q = gameItem:GetItemQuality()
            lblItem:SetFont(Amr.CreateFont("Regular", 13, Amr.Colors.Qualities[q] or Amr.Colors.White))
            lblItem:SetHoverFont(Amr.CreateFont("Regular", 13, Amr.Colors.Qualities[q] or Amr.Colors.White))
            lblItem:SetText(gameItem:GetItemName())
            lblIlvl:SetText(gameItem:GetCurrentItemLevel())
            icon:SetIconBorderColor(Amr.Colors.Qualities[q] or Amr.Colors.White)
            icon:SetIcon(gameItem:GetItemIcon())
            Amr:SetItemTooltip(lblItem, gameItem:GetItemLink(), "ANCHOR_BOTTOMRIGHT", 0, 30)
        end
    end

end

--
-- Just updates state without re-rendering the list of junk
--
function Amr:SetJunkUiState()

    -- don't do anything if the window is not open
    if not _frameJunk then return end

    -- cache whether the player can disenchant whenever the ui is refreshed
    _canDisenchant = canDisenchant()

    -- update action label
    if _isScrapOpen then
        _lblAction:SetText(L.JunkScrap)
    elseif _isMerchantOpen then
        _lblAction:SetText(L.JunkVendor)
    elseif _canDisenchant then
        _lblAction:SetText(L.JunkDisenchant)
    else
        _lblAction:SetText(" ")
    end

    -- update bank button state
    _btnBank:SetDisabled(not _isBankOpen)
end

--
-- Refresh the entire UI, including re-rendering the junk list
--
function Amr:RefreshJunkUi()

    -- don't do anything if the window is not open
    if not _frameJunk then return end

    Amr:SetJunkUiState()

    -- clear out any previous data
	_panelContent:ReleaseChildren()

    local data = Amr.db.char.JunkData

    if not data or not data.Junk or #data.Junk <= 0 then
		local lbl = AceGUI:Create("AmrUiLabel")
		_panelContent:AddChild(lbl)
		lbl:SetFont(Amr.CreateFont("Italic", 16, Amr.Colors.TextGray))
		lbl:SetText(L.JunkEmpty)
        lbl:SetPoint("TOPLEFT", _panelContent.content, "TOPLEFT", 0, -10)
        _lblBank:SetVisible(false)
        _btnBank:SetVisible(false)
    else

        _panelContent:SetLayout("Fill")
			
        local scroll = AceGUI:Create("AmrUiScrollFrame")
        scroll:SetLayout("List")
        _panelContent:AddChild(scroll)

        -- render items currently in the player's inventory
        local usedItems = {}
        local bankCount = 0
        local missingCount = 0

        -- if we have any "keep" items, those are exact duplicates of ones to be junked, 
        -- be sure to "reserve" those first
        if data.Keep then
            for uniqueId, item in pairs(data.Keep) do
                -- check if an exact match is in the player's bank data or equipped
                local matchItem = findMatchingNonBagItem(item, usedItems)

                -- if not, find one in the player's bags
                if not matchItem then
                    matchItem = findMatchingBagItem(item, usedItems)
                end

                if not matchItem then
                    -- abort, player's data must be out of sync
                    local lbl = AceGUI:Create("AmrUiLabel")
                    _panelContent:AddChild(lbl)
                    lbl:SetWidth(380)
                    lbl:SetFont(Amr.CreateFont("Italic", 13, Amr.Colors.TextGray))
                    lbl:SetText(L.JunkOutOfSync)
                    lbl:SetPoint("TOPLEFT", _panelContent.content, "TOPLEFT", 0, -10)

                    _lblBank:SetVisible(false)
                    _btnBank:SetVisible(false)

                    return
                end
            end
        end

        -- now render any junk items in the player's bags, and a count of how many are elsewhere (usually bank)
        for i, item in ipairs(data.Junk) do
            local matchItem = findMatchingBagItem(item, usedItems)
            if matchItem then
                local itemLink = Amr.CreateItemLink(matchItem)
                renderItem(matchItem, itemLink, scroll)
            else
                -- see if it is in the bank or equipped
                matchItem = findMatchingNonBagItem(item, usedItems)
                if matchItem then
                    bankCount = bankCount + 1
                else
                    missingCount = missingCount + 1
                end
            end
        end

        _lblBank:SetText(L.JunkBankText(bankCount))
        _lblBank:SetVisible(bankCount > 0)
        _btnBank:SetVisible(bankCount > 0)
    end
end

Amr:AddEventHandler("MERCHANT_SHOW", function() 
	_isMerchantOpen = true
	if Amr.db.profile.options.junkVendor and Amr.db.char.JunkData and Amr.db.char.JunkData.Junk and #Amr.db.char.JunkData.Junk > 0 then
        Amr:ShowJunkWindow()
    else
        Amr:SetJunkUiState()
	end
end)

Amr:AddEventHandler("MERCHANT_CLOSED", function() 
	_isMerchantOpen = false
	if Amr.db.profile.options.junkVendor then
        Amr:HideJunkWindow()
    else
        Amr:SetJunkUiState()
	end
end)

Amr:AddEventHandler("BANKFRAME_OPENED", function() 
    _isBankOpen = true
    Amr:SetJunkUiState()
end)

Amr:AddEventHandler("BANKFRAME_CLOSED", function() 
    _isBankOpen = false
    Amr:SetJunkUiState()
end)
