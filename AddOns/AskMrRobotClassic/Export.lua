local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")
local L = LibStub("AceLocale-3.0"):GetLocale("AskMrRobotClassic", true)
local AceGUI = LibStub("AceGUI-3.0")

local _lastExport = nil
local _txt = nil

local function createLabel(container, text, width)
	local lbl = AceGUI:Create("AmrUiLabel")
	container:AddChild(lbl)
	lbl:SetWidth(width or 800)
	lbl:SetText(text)
	lbl:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.Text))
	return lbl
end

local function onSplashClose()
	Amr:HideCover()
	Amr.db.char.FirstUse = false
end

local function onTextChanged(widget)
	local val = _txt:GetText()
	if val == "overwolf-bib" then
		-- go to the gear tab, open import window, and show a cover
		Amr:ShowTab("Gear")
		Amr:ShowImportWindow(true)
	end
end

-- render a splash screen with first-time help
local function renderSplash(container)
	local panel = Amr:RenderCoverChrome(container, 700, 450)
	
	local lbl = createLabel(panel, L.ExportSplashTitle, 650)
	lbl:SetJustifyH("CENTER")
	lbl:SetFont(Amr.CreateFont("Bold", 24, Amr.Colors.TextHeaderActive))
	lbl:SetPoint("TOP", panel.content, "TOP", 0, -10)
	
	local lbl2 = createLabel(panel, L.ExportSplashSubtitle, 650)
	lbl2:SetJustifyH("CENTER")
	lbl2:SetFont(Amr.CreateFont("Bold", 18, Amr.Colors.TextTan))
	lbl2:SetPoint("TOP", lbl.frame, "BOTTOM", 0, -20)
	
	lbl = createLabel(panel, L.ExportSplash1, 650)
	lbl:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.Text))
	lbl:SetPoint("TOPLEFT", lbl2.frame, "BOTTOMLEFT", 0, -70)
	
	lbl2 = createLabel(panel, L.ExportSplash2, 650)
	lbl2:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.Text))
	lbl2:SetPoint("TOPLEFT", lbl.frame, "BOTTOMLEFT", 0, -15)
	
	local btn = AceGUI:Create("AmrUiButton")
	btn:SetText(L.ExportSplashClose)
	btn:SetBackgroundColor(Amr.Colors.Green)
	btn:SetFont(Amr.CreateFont("Bold", 16, Amr.Colors.White))
	btn:SetWidth(120)
	btn:SetHeight(28)
	btn:SetCallback("OnClick", onSplashClose)
	panel:AddChild(btn)
	btn:SetPoint("BOTTOM", panel.content, "BOTTOM", 0, 20)
end

-- renders the main UI for the Export tab
function Amr:RenderTabExport(container)

	local lbl = createLabel(container, L.ExportTitle)
	lbl:SetFont(Amr.CreateFont("Bold", 24, Amr.Colors.TextHeaderActive))
	lbl:SetPoint("TOPLEFT", container.content, "TOPLEFT", 0, -40)
	
	local lbl2 = createLabel(container, L.ExportHelp1)
	lbl2:SetPoint("TOPLEFT", lbl.frame, "BOTTOMLEFT", 0, -10)
	
	lbl = createLabel(container, L.ExportHelp2)
	lbl:SetPoint("TOPLEFT", lbl2.frame, "BOTTOMLEFT", 0, -10)
	
	lbl2 = createLabel(container, L.ExportHelp3)
	lbl2:SetPoint("TOPLEFT", lbl.frame, "BOTTOMLEFT", 0, -10)
	
	_txt = AceGUI:Create("AmrUiTextarea")
	_txt:SetWidth(800)
	_txt:SetHeight(300)
	_txt:SetFont(Amr.CreateFont("Regular", 12, Amr.Colors.Text))
	_txt:SetCallback("OnTextChanged", onTextChanged)
	container:AddChild(_txt)
	_txt:SetPoint("TOP", lbl2.frame, "BOTTOM", 0, -20)
	
	local data = self:ExportCharacter()	
	local txt = Amr.Serializer:SerializePlayerData(data, true)
	_txt:SetText(txt)
	_txt:SetFocus(true)
	
	-- update shopping list data
	Amr:UpdateShoppingData(data)
	
	-- show help splash if first time a user is using this
	if Amr.db.char.FirstUse then
		Amr:ShowCover(renderSplash)	
		AceGUI:ClearFocus()
	end
end

function Amr:ReleaseTabExport()
end

function Amr:GetExportText()
	return _txt:GetText()
end


-- use some local variables to deal with the fact that a user can close the bank before a scan completes
local _lastBankBagId = nil
local _lastBankSlotId = nil
local _bankOpen = false

local function scanBag(bagId, isBank, bagTable, bagItemsWithCount)

	local numSlots = C_Container.GetContainerNumSlots(bagId)
	--local loc = ItemLocation.CreateEmpty()
	local item
	for slotId = 1, numSlots do
		local itemInfo = C_Container.GetContainerItemInfo(bagId, slotId)
		if itemInfo then
			local itemData = Amr.Serializer.ParseItemLink(itemInfo.hyperlink)
			if itemData ~= nil then
				item = Item:CreateFromBagAndSlot(bagId, slotId)

				-- seems to be of the form Item-1147-0-4000000XXXXXXXXX, so we take just the last 9 digits
				itemData.guid = item:GetItemGUID()
				if itemData.guid and strlen(itemData.guid) > 9 then
					itemData.guid = strsub(itemData.guid, -9)
				end

				-- see if this is an azerite item and read azerite power ids
				--[[loc:SetBagAndSlot(bagId, slotId)
				if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(loc) then
					local powers = Amr.ReadAzeritePowers(loc)
					if powers then
						itemData.azerite = powers
					end
				end]]

				if isBank then
					_lastBankBagId = bagId
					_lastBankSlotId = slotId
				end
										
				table.insert(bagTable, itemData)
				
				-- all items and counts, used for e.g. shopping list and reagents, etc.
                if bagItemsWithCount then
                	if bagItemsWithCount[itemData.id] then
                		bagItemsWithCount[itemData.id] = bagItemsWithCount[itemData.id] + itemInfo.stackCount
                	else
                		bagItemsWithCount[itemData.id] = itemInfo.stackCount
                	end
                end
            end
		end
	end
end

-- cache the currently equipped gear for this spec
local function cacheEquipped()
	local data = Amr.Serializer:GetEquipped()
	
	Amr.db.char.Equipped[1] = data.Equipped[1]
end

local function scanBags()

	local bagItems = {}
	local itemsAndCounts = {}
	
	scanBag(BACKPACK_CONTAINER, false, bagItems, itemsAndCounts) -- backpack
	for bagId = 1, NUM_BAG_SLOTS do
		scanBag(bagId, false, bagItems, itemsAndCounts)
	end
	
	Amr.db.char.BagItems = bagItems
	Amr.db.char.BagItemsAndCounts = itemsAndCounts
end

-- scan the player's bank and save the contents, must be at the bank
local function scanBank()

	local bankItems = {}
	local itemsAndCounts = {}
	
	local bagList = {}
	table.insert(bagList, BANK_CONTAINER)
	for bagId = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		table.insert(bagList, bagId)
	end

	for i,bagId in ipairs(bagList) do
		local bagItems = {}
		local bagItemsAndCounts = {}
		scanBag(bagId, true, bagItems, bagItemsAndCounts)

		bankItems[bagId] = bagItems
		itemsAndCounts[bagId] = bagItemsAndCounts
	end
	
	-- see if the scan completed before the window closed, otherwise we don't overwrite with partial data
	if _bankOpen and _lastBankBagId then
		local itemLink = C_Container.GetContainerItemLink(_lastBankBagId, _lastBankSlotId)
		if itemLink then --still open
            Amr.db.char.BankItems = bankItems
            Amr.db.char.BankItemsAndCounts = itemsAndCounts
		end
	end
end

local function onBankOpened()
	_bankOpen = true
	scanBank()
end

local function onBankClosed()
	_bankOpen = false
end

-- if a bank bag is updated while the bank is open, re-scan that bag
local function onBankUpdated(bagID)
	if _bankOpen and (bagID == BANK_CONTAINER or (bagID >= NUM_BAG_SLOTS + 1 and bagID <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS)) then
		local bagItems = {}
		local bagItemsAndCounts = {}
		scanBag(bagID, true, bagItems, bagItemsAndCounts)

		-- see if the scan completed before the window closed, otherwise we don't overwrite with partial data
		if _bankOpen and _lastBankBagId == bagID then
			local itemLink = C_Container.GetContainerItemLink(_lastBankBagId, _lastBankSlotId)
			if itemLink then
				Amr.db.char.BankItems[bagID] = bagItems
				Amr.db.char.BankItemsAndCounts[bagID] = bagItemsAndCounts
			end
		end
	end
end

local function scanTalents()

	local tals = {}

	local numTabs = GetNumTalentTabs()
	for t = 1, numTabs do
		local numTalents = GetNumTalents(t)
		local treeTals = {}
		for i = 1, numTalents do
			local _, _, tier, column, rank = GetTalentInfo(t, i)
			if not treeTals[tier] then
				treeTals[tier] = {}
			end
			treeTals[tier][column] = rank
		end

		for t, byCol in Amr.spairs(treeTals) do
			for c, r in Amr.spairs(byCol) do
				table.insert(tals, r)
			end
		end
	end

	Amr.db.char.Talents[1] = table.concat(tals, "")
end

local function scanGlyphs()

	local glyphs = {}
	for i = 1, GetNumGlyphSockets() do
		local enabled, _, spellId = GetGlyphSocketInfo(i)
		if enabled then
			if spellId then
				table.insert(glyphs, spellId)
			end
		end
	end

	Amr.db.char.Glyphs[1] = glyphs
end

-- Returns a data object containing all information about the current player needed for an export:
-- gear, spec, reputations, bag, bank, and void storage items.
function Amr:ExportCharacter()
	
	-- get all necessary player data
	local data = Amr.Serializer:GetPlayerData()

	-- cache latest-seen equipped gear for current spec
	Amr.db.char.Equipped[1] = data.Equipped[1]

	-- scan current inventory just before export so that it is always fresh
	scanBags()
	
	-- scan current spec's talents just before exporting
	scanTalents()

	-- scan current spec's glyphs just before exporting
	scanGlyphs()

	data.Talents = Amr.db.char.Talents	
	data.Glyphs = Amr.db.char.Glyphs
	data.Equipped = Amr.db.char.Equipped	
	data.BagItems = Amr.db.char.BagItems

	-- flatten bank data (which is stored by bag for more efficient updating)
	data.BankItems = {}
	for k,v in pairs(Amr.db.char.BankItems) do
		for i,v2 in ipairs(v) do
			table.insert(data.BankItems, v2)
		end
	end
	
	return data
end

function Amr:InitializeExport()
	Amr:AddEventHandler("UNIT_INVENTORY_CHANGED", function(unitID)
		if unitID and unitID ~= "player" then return end
		cacheEquipped()
	end)
end

Amr:AddEventHandler("BANKFRAME_OPENED", onBankOpened)
Amr:AddEventHandler("BANKFRAME_CLOSED", onBankClosed)
Amr:AddEventHandler("BAG_UPDATE", onBankUpdated)

Amr:AddEventHandler("CHARACTER_POINTS_CHANGED", scanTalents)
Amr:AddEventHandler("GLYPH_ADDED", scanGlyphs)
Amr:AddEventHandler("GLYPH_UPDATED", scanGlyphs)
