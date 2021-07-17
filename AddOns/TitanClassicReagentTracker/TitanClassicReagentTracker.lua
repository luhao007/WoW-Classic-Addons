-- **************************************************************************
-- * TitanClassicReagentTracker.lua
-- *
-- * By: Initial fork of Titan Reagent by L'ombra. Retrofitted for WoW Classic by Farwalker & cliaz
-- **************************************************************************

-- ******************************** Constants *******************************
local _G = getfenv(0);
local TITAN_REAGENTTRACKER_ID = "ReagentTracker"

-- ******************************** Variables *******************************
local L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true)

local debug = false -- setting this to true will enable a lot of debug messages being output on the wow screen
local playerClass = select(2, UnitClass("player"))
local possessed = {}    -- store spells that the player knows here
-- note: look at addon.registry to see variables saved between restarts

local _, addon = ...

local spells = addon.spells[playerClass]    -- generate a list of all possible spells that a player's Class can know, and associated reagents
if not spells then return end   -- don't continue addon load if there are no reagents associated to our character class
-- ******************************** Functions *******************************



--[[
-- **************************************************************************
-- NAME : newReagent(parent, i)
-- DESC : Creates a Button Frame to display a reagent in Titan Panel 
-- VARS : parent = the addon,
        : i = button ID
-- **************************************************************************
--]]
local function newReagent(parent, i)
	
	local btn = CreateFrame("Button", "TitanPanelReagentTrackerReagent"..i, parent, "TitanPanelChildButtonTemplate")
	btn:SetSize(16, 16)
	btn:SetPoint("LEFT")
	btn:SetPushedTextOffset(0, 0)
	
	local icon = btn:CreateTexture()
	icon:SetSize(16, 16)
	icon:SetPoint("LEFT")
	btn:SetNormalTexture(icon)
	btn.icon = icon
	
	local text = btn:CreateFontString(nil, nil, "GameFontHighlightSmall")
	text:SetPoint("LEFT", icon, "RIGHT", 2, 1)
	text:SetJustifyH("LEFT")
	btn:SetFontString(text)
	
	return btn
end


local function onUpdate(self, elapsed)
	if self.refreshReagents then
		self:RefreshReagents()
		self.refreshReagents = false
	end
	self:UpdateButton()
	TitanPanelButton_UpdateTooltip(self)
	self:SetScript("OnUpdate", nil)
end

-- create a frame to handle all the things
-- this actually seems to be what drives the functions / logic in the addon
-- without it, nothing works
addon = CreateFrame("Button", "TitanPanelReagentTrackerButton", CreateFrame("Frame", nil, UIParent), "TitanPanelButtonTemplate")
addon:SetSize(16, 16)
addon:SetPushedTextOffset(0, 0)

-- tell the addon which events from the game it should be aware of
addon:RegisterEvent("PLAYER_LOGIN")
addon:RegisterEvent("LEARNED_SPELL_IN_TAB")
addon:RegisterEvent("MERCHANT_SHOW")

-- tell the addon what to do on each event
addon:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
		self:RefreshReagents()
		self:UpdateButton()
		TitanPanelButton_UpdateTooltip(self)
        self:RegisterEvent("BAG_UPDATE")
    elseif event == "MERCHANT_SHOW" then    -- handle a merchant window opening. this is to autobuy reagents
        self:BuyReagents()
        self:UpdateButton()
        TitanPanelButton_UpdateTooltip(self)
        self:RegisterEvent("BAG_UPDATE")
	else
		-- update on next frame to prevent redundant CPU processing from event spamming
		self.refreshReagents = event == "LEARNED_SPELL_IN_TAB"
		self:SetScript("OnUpdate", onUpdate)
		return
	end
end)

local text = addon:CreateFontString(nil, nil, "GameFontNormalSmall")
text:SetPoint("LEFT", 0, 1)
text:SetText("Reagent Tracker")
addon:SetFontString(text)
addon.label = text


addon.registry = {
    id = TITAN_REAGENTTRACKER_ID,
	version = GetAddOnMetadata("TitanReagentTracker", "Version"),   -- the the value of Version variable from the .toc
	menuText = "Reagent Tracker",
	tooltipTitle = "Reagent Tracker Info", 
	tooltipTextFunction = "TitanPanelReagentTracker_GetTooltipText",
	savedVariables = {
        ShowSpellIcons = false, -- variable used throughout the addon to determine whether to show spell or reagent icons
	}
}


--[[
-- **************************************************************************
-- NAME : N/A
-- DESC : create a button for every spell / reagent in the spell array, to be shown in titan panel horizontally
--      : Save these buttons and their settings in titan variables so that they persist across relaunch
--      : also create a list in the possessed array, which we'll use to store reagent information later
-- VARS : parent = the addon, i = button ID
-- **************************************************************************
--]]
local buttons = {}
for i = 1, #spells do
    buttons[i] = newReagent(addon, i)
    -- create variables in the addon.registry so that they can be set later by the user
    addon.registry.savedVariables["TrackReagent"..i] = (i == 1)
    addon.registry.savedVariables["BuyReagent"..i] = (i == 1)   -- Without first creating the variables in the addon.registry
                                                                -- for later use, the variables won't be saved across game reload
    addon.registry.savedVariables["Reagent"..i.."OneStack"] = (i == 1)         
    addon.registry.savedVariables["Reagent"..i.."TwoStack"] = (i == 1)         
    addon.registry.savedVariables["Reagent"..i.."ThreeStack"] = (i == 1) 
    addon.registry.savedVariables["Reagent"..i.."NoStacks"] = (i == 1)                                                            
	possessed[i] = {}
end


local queryTooltip = CreateFrame("GameTooltip", "TitanReagentTrackerTooltip", nil, "GameTooltipTemplate")
queryTooltip:SetOwner(UIParent, "ANCHOR_NONE")
queryTooltip:SetScript("OnTooltipSetItem", function(self)
	if TitanReagentTrackerTooltipTextLeft1:GetText() ~= RETRIEVING_ITEM_INFO then
		addon:RefreshReagents()
		addon:UpdateButton()
		TitanPanelButton_UpdateTooltip(addon)
	end
end)


--[[
-- **************************************************************************
-- NAME : RefreshReagents()
-- DESC : Build a list of reagents for spells that a player knows
-- **************************************************************************
--]]
function addon:RefreshReagents()
	for i, buff in ipairs(spells) do
		local possessed = possessed[i]
        wipe(possessed) -- TODO: wtf is this doing? Potentially remove, but haven't fully tested.
        
        -- for every spell, get the reagent info
		for index, spell in ipairs(buff.spells) do
			local reagentID = buff.reagent
			local reagentName = GetItemInfo(reagentID)
            if not reagentName then
				queryTooltip:SetHyperlink("item:"..reagentID)
			return
			end
			
            -- if we know the spell, track the reagent. The way this works is that it only loads reagents for 
            -- spells that you know into the tracking table, and as you learn more it shows more. The old implementation 
            -- would load all possible ones, and grey out ones that you didn't know yet.
			if IsSpellKnown(spell) then
                possessed.reagentName = reagentName
			    possessed.reagentIcon = GetItemIcon(reagentID)
                possessed.spellIcon = GetSpellTexture(spell)
            end
		end
	end
end


--[[
-- **************************************************************************
-- NAME : UpdateButton()
-- DESC : Check if any reagents are being tracked, and if so, generates the icon / text / values to be shown
--      : in the titan panel window. if no reagents tracked, hides all buttons
-- **************************************************************************
--]]
function addon:UpdateButton()
	local tracking
	local totalWidth = 0
	local offset = 0
	for i, buff in pairs(possessed) do
		local button = buttons[i]
		local nextButton = buttons[i + 1]
		local nextAnchor = "LEFT"
		local nextOffset = 0

        -- show/hide reagent trackers
		if buff.reagentName and TitanGetVar(TITAN_REAGENTTRACKER_ID, "TrackReagent"..i) then
			local icon = button.icon
			button:Show()
			-- display spell or reagent icon
			if TitanGetVar(TITAN_REAGENTTRACKER_ID, "ShowSpellIcons") then
				icon:SetTexture(buff.spellIcon)
			else
				icon:SetTexture(buff.reagentIcon)
			end
			
			-- current number of reagents
			button:SetText(GetItemCount(buff.reagentName))
            
            -- if there is another spell / button left in the array, change the anchor position for it and set 
            -- an appropriate offset
			if nextButton then
				nextAnchor = "RIGHT"
				nextOffset = 6
			end
			
            button:SetWidth(icon:GetWidth() + button:GetTextWidth())    -- set the button width based off of
                                                                        -- icon size and text size. 
			totalWidth = totalWidth + button:GetWidth() -- add up all widths of buttons
			
            offset = offset + 1 -- without this, the titan panel segment for this addon becomes too small, and the next 
                                -- titan panel segment encroaches onto this addon
			tracking = true
		else
			button:Hide()
		end
		
		-- fix offset to next reagent tracker
		if nextButton then
			nextButton:SetPoint("LEFT", button, nextAnchor, nextOffset, 0)
		end
	end
	
    -- show addon label (Reagent Tracker) if no tracking is enabled
	local none = self.label
	if tracking then
		none:Hide()
	else
		none:Show()
		totalWidth = none:GetWidth() + 8
	end
	
	-- adjust width so other plugins are properly offset
	self:SetWidth(totalWidth + ((offset - 1) * 8))
end

--[[
-- **************************************************************************
-- NAME : TitanPanelRightClickMenu_PrepareReagentTrackerMenu()
-- DESC : Create the values to be displayed in the right click -> drop down menu of the addon
-- **************************************************************************
--]]
function TitanPanelRightClickMenu_PrepareReagentTrackerMenu()
    local info
    
    -- level 3  
    if _G["L_UIDROPDOWNMENU_MENU_LEVEL"] == 3 then
        for index, buff in ipairs(possessed) do
            local info1 = {};
            local info2 = {};
            local info3 = {};
            local info4 = {};
            local reagent = buff.reagentName
            if reagent then
                if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == reagent.." Options" then    -- make sure it only builds buttons for the right reagent
                    -- Button for One Stack
                    info1.text = "Buy 1 stack of "..reagent
                    info1.value = "Buy 1 stack of "..reagent
                    info1.checked = TitanGetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."OneStack")
                    info1.func = function()
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."OneStack", true);
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."TwoStack", false);
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."ThreeStack", false);    
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."NoStacks", false);              
                    end

                    -- Button for Two Stacks
                    info2.text = "Buy 2 stacks of "..reagent
                    info2.value = "Buy 2 stacks of "..reagent
                    info2.checked = TitanGetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."TwoStack")
                    info2.func = function()
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."OneStack", false);
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."TwoStack", true);
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."ThreeStack", false);
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."NoStacks", false);              
                    end

                    -- Button for Three Stacks
                    info3.text = "Buy 3 stacks of "..reagent
                    info3.value = "Buy 3 stacks of "..reagent
                    info3.checked = TitanGetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."ThreeStack")
                    info3.func = function()
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."OneStack", false);
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."TwoStack", false);
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."ThreeStack", true);
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."NoStacks", false);              
                    end

                    -- Button to not autobuy any stacks
                    info4.text = "Do not autobuy "..reagent
                    info4.value = "Do not autobuy "..reagent
                    info4.checked = TitanGetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."NoStacks")
                    info4.func = function()
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."OneStack", false);
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."TwoStack", false);
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."ThreeStack", false);
                        TitanSetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."NoStacks", true);              
                    end
                    
                    -- add all buttons
                    L_UIDropDownMenu_AddButton(info1, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
                    L_UIDropDownMenu_AddButton(info2, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
                    L_UIDropDownMenu_AddButton(info3, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
                    L_UIDropDownMenu_AddButton(info4, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);
                end
            end
        end
        return
    end
    -- /level 3


	-- level 2
	if _G["L_UIDROPDOWNMENU_MENU_LEVEL"] == 2 then
		if _G["L_UIDROPDOWNMENU_MENU_VALUE"] == "Autobuy Options" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_OPTIONS"], _G["L_UIDROPDOWNMENU_MENU_LEVEL"])
            
            for index, buff in ipairs(possessed) do
                info = {};
                local reagent = buff.reagentName
                if reagent then
                    info.text = reagent.." Options"
                    info.value = reagent.." Options"
                    info.notCheckable = true
                    info.hasArrow = 1;
                    info.keepShownOnClick = 1

                    L_UIDropDownMenu_AddButton(info, _G["L_UIDROPDOWNMENU_MENU_LEVEL"]);

                end
            end
		end
		return
	end
    -- /level 2
	
	-- level 1
    TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_REAGENTTRACKER_ID].menuText)
	
    info = {};
	info.notCheckable = true
	info.text = "Autobuy Options";
	info.value = "Autobuy Options";
	info.hasArrow = 1;
    L_UIDropDownMenu_AddButton(info);
    TitanPanelRightClickMenu_AddSpacer();
    
	-- add menu entry for each possessed spell
    for index, buff in ipairs(possessed) do
        info = {};
		local reagent = buff.reagentName
		if reagent then
			info.text = "Track "..reagent
			info.value = "TrackReagent"..index
			info.checked = TitanGetVar(TITAN_REAGENTTRACKER_ID, "TrackReagent"..index)
			info.keepShownOnClick = 1
			info.func = function()
                TitanToggleVar(TITAN_REAGENTTRACKER_ID, "TrackReagent"..index); -- just a note on TitanToggleVar. It 'toggles' the variable
                                                                                -- between '1' and '', instead of true/false. Can be problematic
				addon:UpdateButton();
			end
            L_UIDropDownMenu_AddButton(info);
		end
	end

    TitanPanelRightClickMenu_AddSpacer()

    -- if we're currently showing spell icons, display the "show reagent icons" text
	if TitanGetVar(TITAN_REAGENTTRACKER_ID, "ShowSpellIcons") then
		TitanPanelRightClickMenu_AddCommand("Show Reagent Icons", TITAN_REAGENTTRACKER_ID,"TitanPanelReagentTrackerSpellIcon_Toggle");
	else    -- if not, display "show spell icons" text
		TitanPanelRightClickMenu_AddCommand("Show Spell Icons", TITAN_REAGENTTRACKER_ID,"TitanPanelReagentTrackerSpellIcon_Toggle");
	end

	TitanPanelRightClickMenu_AddSpacer()
	
	TitanPanelRightClickMenu_AddCommand("Hide", TITAN_REAGENTTRACKER_ID, TITAN_PANEL_MENU_FUNC_HIDE);
    -- /level 1

end

--[[
-- **************************************************************************
-- NAME : TitanPanelReagentTrackerSpellIcon_Toggle()
-- DESC : Toggles between showing spell icons and reagent icons
-- **************************************************************************
--]]
function TitanPanelReagentTrackerSpellIcon_Toggle()
	TitanToggleVar(TITAN_REAGENTTRACKER_ID, "ShowSpellIcons")
	addon:UpdateButton()
end


--[[
-- **************************************************************************
-- NAME : TitanPanelReagentTracker_GetTooltipText()
-- DESC : Generate a mouseover text with a summary of all the tracked reagents, and their amounts
--      : when the mouse is over the titan panel section where Reagent Tracker is
-- **************************************************************************
--]]
function TitanPanelReagentTracker_GetTooltipText()
	local tooltipText = " "
	
	-- generate the reagent name and count for info in tooltip
	for index, buff in ipairs(possessed) do
        local reagent = buff.reagentName
		if reagent and TitanGetVar(TITAN_REAGENTTRACKER_ID, "TrackReagent"..index) then
			tooltipText = format("%s\n%s\t%s", tooltipText, reagent, GetItemCount(reagent))
		end
	end
	
	if #tooltipText > 1 then
		return tooltipText
	else
		return " \nNo reagents tracked for known spells."
	end
end

--[[
-- **************************************************************************
-- NAME : BuyReagents()
-- DESC : Buy the reagents from the vendor
--      : this will buy up to a single stack of items that are tracked as reagents for spells a player knows
-- **************************************************************************
--]]
function addon:BuyReagents()
   local shoppingCart = {};    -- list of items to buy
   local tableIndex = 1 -- because LUA handles tables poorly, deciding that a table/list which has 2 sequential nil values in it
                        -- has no values after those nils, we have to use a manual counter to correctly store items in a list
    
    -- print list of all reagents that the addon has determined that the player needs, based on spells he/she knows
    if debug == true then
        DEFAULT_CHAT_FRAME:AddMessage("Player knows spells requiring the following reagents:");
        for i, buff in ipairs(possessed) do
            if buff.reagentName ~= nil then
                DEFAULT_CHAT_FRAME:AddMessage("|cffeda55f - "..buff.reagentName);
            end
        end
        DEFAULT_CHAT_FRAME:AddMessage("\n");
    end

    -- first up, let's fill our shopping cart
    -- for every spell we have
    --for i = 1, table.getn(possessed) do   -- TODO: remove and test
    for index, buff in ipairs(possessed) do
        -- if the option is set to autobuy the reagent for this spell
        if TitanGetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."OneStack") or TitanGetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."TwoStack") or TitanGetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."ThreeStack") then
            if debug == true then DEFAULT_CHAT_FRAME:AddMessage("|cffeda55fReagent = "..buff.reagentName) end
            local totalCountOfReagent = 0
            local desiredCountOfReagent = 0
            local maxStackOfReagent = 0
            if buff.reagentName ~= nil then
                -- the 8th variable returned by GetItemInfo() is the itemStackCount; the max an item will stack to
                -- it should never be nil
                _, _, _, _, _, _, _, maxStackOfReagent = GetItemInfo(buff.reagentName)    -- get the max a stack of this reagent can be
                                                                                                -- just so that we buy one stack only
                

                -- bugfix for Issue #7 from Nihlolino, where GetItemInfo() returns a nil value for max item stack size, and subsequent 
                -- arithmetic on a nil value fails. This shouldn't need to exist. A reagent can't stack to nil. 
                if totalCountOfReagent ~= nil and maxStackOfReagent ~= nil then
                    if debug == true then DEFAULT_CHAT_FRAME:AddMessage("totalCountOfReagent = "..totalCountOfReagent.." and desiredCountOfReagent = "..desiredCountOfReagent) end
                    -- cater for buying multiple stacks of reagents
                    if TitanGetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."OneStack") then
                        desiredCountOfReagent = maxStackOfReagent * 1 
                    elseif TitanGetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."TwoStack") then
                        desiredCountOfReagent = maxStackOfReagent * 2
                    elseif TitanGetVar(TITAN_REAGENTTRACKER_ID, "Reagent"..index.."ThreeStack") then
                        desiredCountOfReagent = maxStackOfReagent * 3
                    end   
                end
                            
            end                                                                                        

            if debug == true then 
                if buff.reagentName ~= nil then
                    DEFAULT_CHAT_FRAME:AddMessage("Aiming to buy "..desiredCountOfReagent.." of "..buff.reagentName);
                    DEFAULT_CHAT_FRAME:AddMessage("Searching for "..buff.reagentName.." in bags");
                end
            end
            -- First up, go add up all the units of this reagent we have
            -- this is in case they have multiple half used stacks
            if buff.reagentName ~= nil then
                -- for every bag slot
                for bagID = 0, 4 do
                    -- for even item slot in that bag
                    for slot = 1, GetContainerNumSlots(bagID) do
                        -- get the item name and quantity of each item in that slot
                        local bagItemName, bagItemCount = getItemNameItemCountFromBag(bagID, slot);
                                        
                        if bagItemName ~= nil and bagItemCount ~= nil then
                            -- if the ItemName returned from the bag slot matches a reagent we're tracking
                            if bagItemName == buff.reagentName then
                                totalCountOfReagent = totalCountOfReagent + bagItemCount    -- add up how many of that reagent we have
                            end
                        end
                    end
                end
                if debug == true then DEFAULT_CHAT_FRAME:AddMessage("Found "..totalCountOfReagent.." "..buff.reagentName.." in bags") end 
                -- enclosing the entire reagent count vs desired reagent comparison in a not-nil if statement for Nihlolino's reported bug
                -- this shouldn't need to exist. A reagent can't stack to nil. 
                if totalCountOfReagent ~= nil and desiredCountOfReagent ~= nil and maxStackOfReagent ~= nil then
                    if totalCountOfReagent >= desiredCountOfReagent then
                        -- we got enough not gonna buy any more
                        if debug == true then DEFAULT_CHAT_FRAME:AddMessage("Have enough "..buff.reagentName.." in bags. Not buying any more.\n\n") end
                    elseif totalCountOfReagent < desiredCountOfReagent then
                        -- we don't have enough, let's buy some more
                        shoppingCart[tableIndex] = {buff.reagentName, desiredCountOfReagent-totalCountOfReagent, maxStackOfReagent}
                        tableIndex = tableIndex+1
                        if debug == true then DEFAULT_CHAT_FRAME:AddMessage("Added "..desiredCountOfReagent-totalCountOfReagent.." of "..possessed[index].reagentName.." to cart.") end
                    end
                end
            end
        end
    end
 
    -- this is where we do the actual shopping
    -- at this point, shoppingCart looks like this:
    -- shoppingCart[x][1] = the reagent name
    -- shoppingCart[x][2] = how many reagents to buy
    -- shoppingCart[x][3] = max the reagent will stack to. Required for github issue #9
    
    -- for each item in shoppingCart
    for i = 1, table.getn(shoppingCart) do
        -- pass the Reagent name and the required count to the buying function
        if shoppingCart[i][1] ~= nil and shoppingCart[i][2] ~= nil and shoppingCart[i][3] ~= nil then
            if debug == true then DEFAULT_CHAT_FRAME:AddMessage("Trying to buy "..shoppingCart[i][1]) end
            buyItemFromVendor(shoppingCart[i][1], shoppingCart[i][2], shoppingCart[i][3])
        end
	end	
end

--[[
-- **************************************************************************
-- NAME : buyItemFromVendor(itemName, purchaseCount)
-- DESC : Buy a quantity of an item from a vendor
--      : the logic is a inelegant: iterate through every item the vendor has, compare it to what we want, 
--      : and if it matches buy the desired amount
-- VAR  : itemName = name of the item (reagent)
--      : purchaseCount = amount of item to buy
-- **************************************************************************
--]]
function buyItemFromVendor(itemName, purchaseCount, maxStackSize)
    -- check for each of the merchant's items to see if it's what we want
    for index = 0, GetMerchantNumItems() do
        local name, texture, price, quantity = GetMerchantItemInfo(index)
        -- if the merchant's item name matches the name of the item in the shopping cart
        if name == itemName then
            -- buy the item that we're currently looking at, and the amount
            if debug == true then DEFAULT_CHAT_FRAME:AddMessage("Vendor has "..itemName..", calling Blizzard API to buy "..purchaseCount) end
            
            -- Github issue #9: Blizzard does not support buying of multiple stacks in one API call.
            -- break down the purchasing into <= single stack purchases
            while (purchaseCount / maxStackSize) > 1 do
                if debug == true then DEFAULT_CHAT_FRAME:AddMessage("Buying "..maxStackSize..", "..purchaseCount-maxStackSize.." remaining") end
                BuyMerchantItem(index, maxStackSize)
                purchaseCount = purchaseCount - maxStackSize
            end
            if purchaseCount <= maxStackSize then
                if debug == true then DEFAULT_CHAT_FRAME:AddMessage("Buying "..purchaseCount..", "..purchaseCount-purchaseCount.." remaining") end
                BuyMerchantItem(index, purchaseCount)
            end
        end
    end
end



--[[
-- **************************************************************************
-- NAME : getItemNameItemCountFromBag(bagNumber, slotNumber)
-- DESC : gets the item name and count of item for a bag slot
        : This is used (with other logic) to get a total sum of all of a single reagent in a player's bag
-- VAR  : bagNumber = which bag slot is being checked
--      : slotNumber = which slot (within a bag) is being checked
-- **************************************************************************
--]]
function getItemNameItemCountFromBag(bagNumber, slotNumber)    
    -- get the count and link of the item in this bag slot
    local _, itemCount, _, _, _, _, itemLink = GetContainerItemInfo(bagNumber, slotNumber);
    local itemName
    
    -- if an item is actually there, get the name of the item, instead of the link
    if itemCount ~= nil and itemLink ~= nil then 
        itemName = GetItemInfo(itemLink)
    end
    
	if itemName ~= nil then
		return itemName, itemCount;
	else
		return "", itemCount;
	end
end
