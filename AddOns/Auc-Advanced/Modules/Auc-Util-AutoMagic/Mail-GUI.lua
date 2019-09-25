--[[
	Auctioneer - AutoMagic Utility module
	Version: 8.2.6424 (SwimmingSeadragon)
	Revision: $Id: Mail-GUI.lua 6424 2019-09-22 00:20:05Z none $
	URL: http://auctioneeraddon.com/

	AutoMagic is an Auctioneer module which automates mundane tasks for you.

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]
if not AucAdvanced then return end

local lib = AucAdvanced.Modules.Util.AutoMagic
if not lib then return end
local print,decode,_,_,replicate,empty,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()
local AppraiserValue, DisenchantValue, ProspectValue, VendorValue, bestmethod, bestvalue, runstop, _

---------------------------------------------------------
-- Mail Interface
---------------------------------------------------------
lib.ammailgui = CreateFrame("Frame", "", UIParent); lib.ammailgui:Hide()
function lib.makeMailGUI()
	-- Set frame visuals
	-- [name of frame]:SetPoint("[relative to point on my frame]","[frame we want to be relative to]","[point on relative frame]",-left/+right, -down/+up)
	lib.ammailgui:ClearAllPoints()
	lib.ammailgui:SetPoint("CENTER", UIParent, "BOTTOMLEFT", get("util.automagic.ammailguix"), get("util.automagic.ammailguiy"))

	--Don't need to recreate duplicate frames on each mail box open.
	if lib.ammailgui.Drag then return end

	lib.ammailgui:SetFrameStrata("DIALOG")
	lib.ammailgui:SetHeight(75)
	lib.ammailgui:SetWidth(320)
	lib.ammailgui:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 9, right = 9, top = 9, bottom = 9 }
	})
	lib.ammailgui:SetBackdropColor(0,0,0, 0.8)
	lib.ammailgui:EnableMouse(true)
	lib.ammailgui:SetMovable(true)
	lib.ammailgui:SetClampedToScreen(true)

	-- Make highlightable drag bar
	lib.ammailgui.Drag = CreateFrame("Button", "", lib.ammailgui)
	lib.ammailgui.Drag:SetPoint("TOPLEFT", lib.ammailgui, "TOPLEFT", 10,-5)
	lib.ammailgui.Drag:SetPoint("TOPRIGHT", lib.ammailgui, "TOPRIGHT", -10,-5)
	lib.ammailgui.Drag:SetHeight(6)
	lib.ammailgui.Drag:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
	lib.ammailgui.Drag:SetScript("OnMouseDown", function() lib.ammailgui:StartMoving() end)
	lib.ammailgui.Drag:SetScript("OnMouseUp", function() lib.ammailgui:StopMovingOrSizing() end)
	lib.ammailgui.Drag:SetScript("OnEnter", function() lib.buttonTooltips( lib.ammailgui.Drag, "Click and drag to reposition window.") end)
	lib.ammailgui.Drag:SetScript("OnLeave", function() GameTooltip:Hide() end)

	-- Text Header
	lib.mguiheader = lib.ammailgui:CreateFontString(one, "OVERLAY", "NumberFontNormalYellow")
	lib.mguiheader:SetText("AutoMagic: Mail Loader")
	lib.mguiheader:SetJustifyH("CENTER")
	lib.mguiheader:SetWidth(200)
	lib.mguiheader:SetHeight(10)
	lib.mguiheader:SetPoint("TOPLEFT",  lib.ammailgui, "TOPLEFT", 0, 0)
	lib.mguiheader:SetPoint("TOPRIGHT", lib.ammailgui, "TOPRIGHT", 0, 0)
	lib.ammailgui.mguiheader = lib.mguiheader


	--Hide mail window
	lib.ammailgui.closeButton = CreateFrame("Button", nil, lib.ammailgui, "UIPanelCloseButton")
	lib.ammailgui.closeButton:SetScript("OnClick", function() lib.ammailgui:Hide() end)
	lib.ammailgui.closeButton:SetPoint("TOPRIGHT", lib.ammailgui, "TOPRIGHT", 0,0)

	-- [name of frame]:SetPoint("[relative to point on my frame]","[frame we want to be relative to]","[point on relative frame]",-left/+right, -down/+up)


	lib.mguibtmrules = lib.ammailgui:CreateFontString(two, "OVERLAY", "NumberFontNormalYellow")
	lib.mguibtmrules:SetText("SUI/IS Rule:")
	lib.mguibtmrules:SetJustifyH("LEFT")
	lib.mguibtmrules:SetWidth(101)
	lib.mguibtmrules:SetHeight(10)
	lib.mguibtmrules:SetPoint("TOPLEFT",  lib.ammailgui, "TOPLEFT", 18, -16)
	lib.ammailgui.mguibtmrules = lib.mguibtmrules


	lib.mguimailfor = lib.ammailgui:CreateFontString(three, "OVERLAY", "NumberFontNormalYellow")
	lib.mguimailfor:SetText("Misc:")
	lib.mguimailfor:SetJustifyH("LEFT")
	lib.mguimailfor:SetWidth(101)
	lib.mguimailfor:SetHeight(10)
	lib.mguimailfor:SetPoint("TOPLEFT",  lib.mguibtmrules, "TOPRIGHT", 25, 0)
	--lib.mguimailfor:SetPoint("TOPRIGHT", lib.ammailgui.loadprospect, "BOTTOMRIGHT", 0, 0)
	lib.ammailgui.mguimailfor = lib.mguimailfor


	lib.createMailButton("Disenchant", "Add all items tagged \nfor DE to the mail.", function() lib.scanBags(lib.disenchantAction) end )
	lib.createMailButton("Gems", "Add all Gems to the mail.", function() lib.scanBags(lib.gemAction) end )
	lib.createMailButton("Herbs", "Add all items classified \nas herbs to the mail", function() lib.scanBags(lib.herbAction) end )
	lib.createMailButton("Prospect", "Add all items tagged \nfor Prospect to the mail.", function() lib.scanBags(lib.prospectAction) end )
	lib.createMailButton("Chant Mats", "Add all Enchanting mats \nto the mail.", function() lib.scanBags(lib.dematAction) end )
	lib.createMailButton("Pigments", "Add all Pigments \nto the mail.", function() lib.scanBags(lib.pigmentAction) end )

	--Lets make the Reason code based buttons a  different color Blue for SUI rule based, Green for default lists
	do
		local function buttonrecolor(button, green)
			button:SetNormalTexture("Interface\\GLUES\\Common\\Glue-Panel-Button-Up-Blue")
			button:SetPushedTexture("Interface\\GLUES\\Common\\Glue-Panel-Button-Down-Blue")
			button:SetHighlightTexture("Interface\\GLUES\\Common\\Glue-Panel-Button-Highlight-Blue")

			local tex = button:GetNormalTexture()
			tex:SetTexCoord(0,.56,.1,.56)
			if green then
				tex:SetVertexColor(0,1,0,1)
			end
		end

		buttonrecolor(lib.ammailgui.Button1)
		buttonrecolor(lib.ammailgui.Button2, true)
		buttonrecolor(lib.ammailgui.Button3, true)
		buttonrecolor(lib.ammailgui.Button4)
		buttonrecolor(lib.ammailgui.Button5, true)
		buttonrecolor(lib.ammailgui.Button6, true)
	end

--[[Create  CustomMailerFrame]]

	lib.CustomMailerFrame = CreateFrame("Frame", "", UIParent)
	local frame = lib.CustomMailerFrame
	frame:Hide()

	frame:SetFrameStrata("HIGH")
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/ChatBubble-Background",
		edgeFile = "Interface/Tooltips/ChatBubble-BackDrop",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 32, right = 32, top = 32, bottom = 32 }
	})
	frame:SetBackdropColor(0,0,0, 1)

	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:SetWidth(640)
	frame:SetHeight(450)

	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame.Drag = CreateFrame("Button", nil, frame)
	frame.Drag:SetPoint("TOPLEFT", frame, "TOPLEFT", 10,-5)
	frame.Drag:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10,-5)
	frame.Drag:SetHeight(6)
	frame.Drag:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")

	frame.Drag:SetScript("OnMouseDown", function() frame:StartMoving() end)
	frame.Drag:SetScript("OnMouseUp", function() frame:StopMovingOrSizing() end)

	frame.DragBottom = CreateFrame("Button",nil, frame)
	frame.DragBottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10,5)
	frame.DragBottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10,5)
	frame.DragBottom:SetHeight(6)
	frame.DragBottom:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")

	frame.DragBottom:SetScript("OnMouseDown", function() frame:StartMoving() end)
	frame.DragBottom:SetScript("OnMouseUp", function() frame:StopMovingOrSizing() end)


	local	title = frame:CreateFontString(aamCustomMailertitle, "OVERLAY", "GameFontNormalLarge")
	title:SetText("AutoMagic: Custom Mailer Setup")
	title:SetJustifyH("CENTER")
	title:SetWidth(300)
	title:SetHeight(10)
	title:SetPoint("TOPLEFT",  frame, "TOPLEFT", 0, -17)
	frame.title = title

	--Close Button
	frame.closeButton = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.closeButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -530, 10)
	frame.closeButton:SetText("Close")
	frame.closeButton:SetScript("OnClick",  function() frame:Hide() end)

	local SelectBox = LibStub:GetLibrary("SelectBox")
	local ScrollSheet = LibStub:GetLibrary("ScrollSheet")

	function frame.slotclear()
		frame.slot:SetNormalTexture(nil)
		frame.slot.help:SetText("Drop item into box")
		frame.slot.workingItem = nil
		frame.addButton:Disable()
		frame.removeButton:Disable()
		lib.MailListUpdate()
	end
	function frame.slotadd(itemID, add)
		if not itemID then frame.slotclear() return end
		local _, itemLink, _, _, _, _, _, _, _, itemTexture = GetItemInfo(itemID)
		frame.slot:SetNormalTexture(itemTexture)
		frame.slot.help:SetText(itemLink)
		frame.slot.workingItem = itemID
		if add then
			frame.addButton:Enable()
			frame.removeButton:Disable()
		else
			frame.addButton:Disable()
			frame.removeButton:Enable()
		end
		lib.MailListUpdate()
	end

	frame.resultlist = CreateFrame("Frame", nil, frame)
	frame.resultlist:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})

	frame.resultlist:SetBackdropColor(0, 0, 0.0, 0.5)
	frame.resultlist:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 270, 400)
	frame.resultlist:SetPoint("TOPRIGHT", frame, "TOPLEFT",630, 0)
	frame.resultlist:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10)

	frame.resultlist.sheet = ScrollSheet:Create(frame.resultlist, {
		{ ('Item'), "TOOLTIP", 170 },
		{ "Item ID", "NUMBER", 170 },
		{"", "TEXT", 0.001 }, --metadata thats not used in visual display
	})
	frame.resultlist.sheet.enableselect = true

	--After we have finished creating the scrollsheet and all saved settings have been applied set our event processor
	function frame.resultlist.sheet.Processor(callback, self, button, column, row, order, curDir, ...)
		if (callback == "OnEnterCell")  then
		--	lib.ASCOnEnter(button, row, column)
		elseif (callback == "OnLeaveCell") then
			GameTooltip:Hide()
		elseif (callback == "OnClickCell") then
			local itemID = frame.resultlist.sheet:GetSelection()[2]
			frame.slotadd(itemID)
		elseif (callback == "OnMouseDownCell") then
		--	lib.ASCSelect()
		end
	end
	--use our custom sort method not scrollsheets
	frame.resultlist.sheet.CustomSort = lib.CustomSort

	--parse saved buttons into the scrollframe format for display
	function lib.MailListUpdate()
		local settings = frame.buttonList.SavedButtons
		local selection = frame.buttonList.sheet:GetSelection()[1]
		--parse
		local B, D = {},{}
		for button, dataTable in pairs(settings) do
			table.insert(B, {button})
			if selection == button then
				D = dataTable
			end
		end
		if selection then
			frame.workingname:SetText("|Cff00ffff Items Mailed by|r |Cffff0000"..selection:upper())
			frame.removeListButton:Enable()
		else
			frame.workingname:SetText("|Cff00ffff Select a Button from the LEFT list")
			frame.removeListButton:Disable()
		end
		--update and render scrollframes
		frame.buttonList.sheet:SetData(B)
		frame.resultlist.sheet:SetData(D)

		frame.buttonList.sheet:Render()
		frame.resultlist.sheet:Render()
	end
	--Edit box for changing/creating lists
	frame.listEditBox = CreateFrame("EditBox", "", frame, "InputBoxTemplate")
	frame.listEditBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	frame.listEditBox:SetAutoFocus(true)
	frame.listEditBox:Hide()
	frame.listEditBox:SetHeight(15)
	frame.listEditBox:SetFrameStrata("DIALOG")
	frame.listEditBox:SetWidth(30)
	frame.listEditBox:SetScript("OnEscapePressed", function(self) self:Hide() end)
	frame.listEditBox:SetScript("OnEnterPressed", function(self)
						local sheet = frame.buttonList.sheet
						local Old = frame.listEditBox.OrigText
						local text = self:GetText()
						local settings = frame.buttonList.SavedButtons

						if not settings[text] then
							--if new line or hidden we will have a nil. So add a new entry to the data
							if Old == nil then
								settings[text] = {}
								lib.createMailButton(text, "Add all items on this \list to the mail.", lib.customAction)
							else
								for i, name in pairs(sheet.data) do
									if name == Old then
										sheet.data[i] = self:GetText()
										settings[text] = settings[Old]
										settings[Old] = nil
										break
									end
								end
							end
						else
							print("Button Name "..text.." already exists")
						end
						lib.MailListUpdate()
						frame.listEditBox:Hide()
					end)


	--Frame for displaying the lists
	frame.buttonList = CreateFrame("Frame", nil, frame)
	frame.buttonList:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})

	frame.buttonList:SetBackdropColor(0, 0, 0.0, 0.5)
	frame.buttonList:SetWidth(140)
	frame.buttonList:SetHeight(250)
	frame.buttonList:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 30)

	frame.buttonList.sheet = ScrollSheet:Create(frame.buttonList, {
--~ 		{ ('Add'), "TEXT", 30 },
		{ ('Button Name'), "TOOLTIP", 100 },
		{"", "TEXT", 0.001 }, --metadata thats not used in visual display
	})
	frame.buttonList.sheet.enableselect = true

	frame.listEditBox:SetParent(frame.buttonList.sheet.content)

	frame.buttonList.SavedButtons = get("util.automagic.SavedMailButtons")
	if not frame.buttonList.SavedButtons then
		frame.buttonList.SavedButtons = {}
		SavedButtons = set("util.automagic.SavedMailButtons", frame.buttonList.SavedButtons)
	end

	--After we have finished creating the scrollsheet and all saved settings have been applied set our event processor
	function frame.buttonList.sheet.Processor(callback, self, button, column, row, order, curDir, ...)
		if (callback == "OnEnterCell")  then
		--	lib.ASCOnEnter(button, row, column)
		elseif (callback == "OnLeaveCell") then
			GameTooltip:Hide()
		elseif (callback == "OnClickCell") then
			local clickedFrame = self.rows[row][column]
			local text = clickedFrame:GetText()

			lib.MailListUpdate()
			if not clickedFrame:IsVisible() then text = nil end --Old data is still in the frames, just hidden

			if IsShiftKeyDown() then
				frame.listEditBox:ClearAllPoints()
				frame.listEditBox:SetAllPoints(clickedFrame)
				frame.listEditBox:ClearFocus() --clear focus then set so we highlight current text
				frame.listEditBox:Show()
				frame.listEditBox:SetFocus()
				frame.listEditBox.OrigText = text

				if not text then text = "" end
				frame.listEditBox:SetText(text)
			end
		elseif (callback == "OnMouseDownCell") then

		end
	end

	frame.buttonList.help = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.buttonList.help:ClearAllPoints()
	frame.buttonList.help:SetPoint("LEFT", frame.buttonList, "TOPRIGHT", 0, -90)
	frame.buttonList.help:SetText("|Cff00ffff To add a|r \n|CffffffffNEW Button|r \n|Cffffff00SHIFT click|r|Cff00ffff on any empty spot in the |Cffffff00LEFT |Cff00fffflist\n\n\n To |CffffffffEDIT |Cff00ffff the name of a button just |Cffffff00SHIFT click|r|Cff00ffff on it in the |Cffffff00LEFT |Cff00fffflist \n\n\n  |CffFF0000BUTTON NAMES WILL NOT UPDATE TILL RELOAD")
	frame.buttonList.help:SetWidth(120)


	--Itemicon/slot
	frame.slot = CreateFrame("Button", "autoMagicSlotFrame", frame, "PopupButtonTemplate")
	frame.slot:SetPoint("TOPLEFT", frame, "TOPLEFT", 23, -50)
	frame.slot:SetWidth(38)
	frame.slot:SetHeight(38)
	frame.slot:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square.blp")
		function frame.slotIconDrop(self, data, ...)
			local objtype, itemID = GetCursorInfo()
			ClearCursor()
			if objtype == "item" then
				frame.slotadd(itemID, true)
			else
				frame.slotclear()
			end
		end
	frame.slot:SetScript("OnClick", frame.slotIconDrop)
	frame.slot:SetScript("OnReceiveDrag", frame.slotIconDrop)

	frame.slot.help = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.slot.help:SetPoint("LEFT", frame.slot, "RIGHT", 2, 7)
	frame.slot.help:SetText(("Drop item into box")) --"Drop item into box to search."
	frame.slot.help:SetWidth(100)

	frame.workingname = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.workingname:SetPoint("BOTTOM", frame.resultlist, "TOP", 0, 0)
	frame.workingname:SetText("|Cff00ffff")
	frame.workingname:SetWidth(200)


	frame.removeListButton = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.removeListButton:SetPoint("BOTTOM", frame.buttonList, "TOP", 0, 0)
	frame.removeListButton:SetWidth(160)
	frame.removeListButton:SetText("Remove selected list")
	frame.removeListButton:Disable()
	frame.removeListButton:SetScript("OnClick",  function()
					local settings = frame.buttonList.SavedButtons
					local buttonName = frame.buttonList.sheet:GetSelection()[1]
					if settings and buttonName then
						settings[buttonName] = nil
					end
					lib.MailListUpdate()
				end)

	frame.addButton = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.addButton:SetPoint("TOPLEFT", frame.slot, "BOTTOMLEFT", 0,-10)
	frame.addButton:SetText(("Add"))
	frame.addButton:Disable()
	frame.addButton:SetScript("OnClick",  function()
					local itemID = frame.slot.workingItem
					local settings = frame.buttonList.SavedButtons
					local selection = frame.buttonList.sheet:GetSelection()[1]
					if itemID and settings and selection then
						local _, itemLink = GetItemInfo(itemID)
						local exists
						for i, data in pairs(settings[selection]) do
							if data[2] == itemID then
								exists = true
								break
							end
						end
						if not exists then
							table.insert(settings[selection], {itemLink, itemID})
						else
							print(itemLink, "already on list")
						end
					end
					frame.slotclear()
				end)
	frame.addButton:SetScript("OnEnter", function() lib.buttonTooltips( frame.addButton, "Click to add Item to this list.") end)
	frame.addButton:SetScript("OnLeave", function() GameTooltip:Hide() end)


	frame.removeButton = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
	frame.removeButton:SetPoint("LEFT", frame.addButton, "RIGHT", 0, 0)
	frame.removeButton:SetText("Remove")
	frame.removeButton:Disable()
	frame.removeButton:SetScript("OnClick", function(self)
		local settings = frame.buttonList.SavedButtons
		local buttonName = frame.buttonList.sheet:GetSelection()[1]
		local selection = frame.resultlist.sheet:GetSelection()[1]

		--parse
		for button, dataTable in pairs(settings) do
			for i, data in pairs(dataTable) do
				if selection == data[1] then
					print(data[1])
					table.remove(dataTable, i)
					break
				end

			end
		end
		frame.slotclear()
	end)

	--create buttons
	for buttonName in pairs(frame.buttonList.SavedButtons) do
		lib.createMailButton(buttonName, "Add all items on this \list to the mail.", lib.customAction)
	end


	--Add Config button to mail window
	lib.ammailgui.configureButton = CreateFrame("Button", nil, lib.ammailgui)
	lib.ammailgui.configureButton:SetPoint("TOPLEFT", lib.ammailgui, "TOPLEFT", -15,0)
	lib.ammailgui.configureButton:SetHeight(30)
	lib.ammailgui.configureButton:SetWidth(30)
	lib.ammailgui.configureButton:SetNormalTexture("Interface\\GossipFrame\\HealerGossipIcon")
	lib.ammailgui.configureButton:SetHighlightTexture("Interface\\GossipFrame\\BinderGossipIcon")


	lib.ammailgui.configureButton:SetScript("OnClick", function()
											if frame:IsVisible() then
												frame:Hide()
											else
												frame:Show()
											end
										end)
	lib.ammailgui.configureButton:SetScript("OnEnter", function(self)
								GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
								GameTooltip:SetText("Click to add new mail buttons")
							end)
	lib.ammailgui.configureButton:SetScript("OnLeave", function() GameTooltip:Hide() end)


	lib.MailListUpdate()

end


lib.ammailgui.ButtonCount = 1
lib.ammailgui.ButtonRow = 1
lib.ammailgui.ButtonTotal = 1
function lib.createMailButton(name, tooltip, click)
	--if we have finished a row start a new one
	if lib.ammailgui.ButtonCount > 3 then
		lib.ammailgui.ButtonRow = lib.ammailgui.ButtonRow + 1
		lib.ammailgui.ButtonCount = 1
	end
	local total = lib.ammailgui.ButtonTotal
	local buttonRef = "Button"..total

	lib.ammailgui[buttonRef]= CreateFrame("Button", "", lib.ammailgui, "OptionsButtonTemplate")
	lib.ammailgui[buttonRef]:SetText(name)
	lib.ammailgui[buttonRef]:SetScript("OnEnter", function() lib.buttonTooltips( lib.ammailgui[buttonRef], tooltip) end)
	lib.ammailgui[buttonRef]:SetScript("OnLeave", function() GameTooltip:Hide() end)
	lib.ammailgui[buttonRef]:SetScript("OnClick", click)


	if lib.ammailgui.ButtonCount == 1 then --anchor to starting point
		local spacer = -24
		if lib.ammailgui.ButtonTotal == 1 then spacer = -28 end --first row is padded more
		lib.ammailgui[buttonRef]:SetPoint("TOPLEFT", lib.ammailgui, "TOPLEFT", 10, spacer * lib.ammailgui.ButtonRow)
	else
		local prevButton =  "Button"..total-1
		lib.ammailgui[buttonRef]:SetPoint("LEFT", lib.ammailgui[prevButton], "RIGHT", 10, 0)
	end

	--set frame height for player added buttons
	if lib.ammailgui.ButtonRow > 2 then
		local width = 24 * (lib.ammailgui.ButtonRow -2)
		lib.ammailgui:SetHeight(75 + width)
	end

	lib.ammailgui.ButtonTotal = lib.ammailgui.ButtonTotal + 1
	lib.ammailgui.ButtonCount = lib.ammailgui.ButtonCount + 1
end




AucAdvanced.RegisterRevision("$URL: Auc-Advanced/Modules/Auc-Util-AutoMagic/Mail-GUI.lua $", "$Rev: 6424 $")
