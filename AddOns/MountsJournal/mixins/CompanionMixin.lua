local addon, L = ...
local util = MountsJournalUtil
local petRandomIcon = "Interface/AddOns/MountsJournal/textures/INV_Pet_Achievement_CaptureAPetFromEachFamily_Battle" -- select(3, GetSpellInfo(243819))


MJSetPetMixin = util.createFromEventsMixin()


function MJSetPetMixin:onLoad()
	self.mounts = MountsJournal
	self.journal = MountsJournalFrame

	self:SetScript("OnEnter", function(self)
		self.highlight:Show()
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:SetText(L["Summonable Battle Pet"])
		local description
		if self.id ~= nil then
			if type(self.id) == "number" then
				description = self.id == 1 and PET_JOURNAL_SUMMON_RANDOM_FAVORITE_PET or L["Summon Random Battle Pet"]
			else
				description = self.name
			end
		else
			description = L["No Battle Pet"]
		end
		GameTooltip:AddLine(description, 1, 1, 1, false)
		GameTooltip:Show()
	end)
	self:SetScript("OnLeave", function(self)
		self.highlight:Hide()
		GameTooltip:Hide()
	end)
end


function MJSetPetMixin:onEvent(event, ...) self[event](self, ...) end


function MJSetPetMixin:onShow()
	self:SetScript("OnShow", nil)
	C_Timer.After(0, function()
		self:SetScript("OnShow", self.refresh)
		self:updatePetForMount()
		self:refresh()
		self:on("MOUNT_SELECT", self.refresh)
		self:on("UPDATE_PROFILE", self.refresh)
		self:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
	end)
end


function MJSetPetMixin:onClick()
	if not self.petSelectionList then
		self.petSelectionList = CreateFrame("FRAME", nil, self, "MJCompanionsPanel")
	end
	self.petSelectionList:SetShown(not self.petSelectionList:IsShown())
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end


function MJSetPetMixin:refresh()
	local spellID = self.journal.selectedSpellID
	local petID = self.journal.petForMount[spellID]
	self.id = petID

	if not petID then
		self.infoFrame:Hide()
	elseif type(petID) == "number" then
		self.infoFrame.icon:SetTexture(petRandomIcon)
		self.infoFrame.favorite:SetShown(petID == 1)
		self.infoFrame:Show()
	else
		local _,_,_,_,_,_, favorite, name, icon = C_PetJournal.GetPetInfoByPetID(petID)

		if icon then
			self.name = name
			self.infoFrame.icon:SetTexture(icon)
			self.infoFrame.favorite:SetShown(favorite)
			self.infoFrame:Show()
		else
			self.journal.petForMount[spellID] = nil
			self.infoFrame:Hide()
			self.id = nil
		end
	end
end


function MJSetPetMixin:updatePetForMount()
	local _, owned = C_PetJournal.GetNumPets()
	if not self.owned or self.owned > owned then
		local petForMount, needUpdate = self.mounts.defProfile.petForMount

		for spellID, petID in pairs(petForMount) do
			if type(petID) == "string" and not C_PetJournal.GetPetInfoByPetID(petID) then
				needUpdate = true
				petForMount[spellID] = nil
			end
		end
		for _, profile in pairs(self.mounts.profiles) do
			for spellID, petID in pairs(profile.petForMount) do
				if type(petID) == "string" and not C_PetJournal.GetPetInfoByPetID(petID) then
					needUpdate = true
					profile.petForMount[spellID] = nil
				end
			end
		end

		if needUpdate then
			self.journal:updateMountsList()
		end
	end
	self.owned = owned
end
MJSetPetMixin.PET_JOURNAL_LIST_UPDATE = MJSetPetMixin.updatePetForMount


MJCompanionsPanelMixin = util.createFromEventsMixin()


function MJCompanionsPanelMixin:onEvent(event, ...) self[event](self, ...) end


function MJCompanionsPanelMixin:onLoad()
	self.util = MountsJournalUtil
	self.mounts = MountsJournal
	self.journal = MountsJournalFrame

	self:SetWidth(250)
	self:SetPoint("TOPLEFT", self.journal.bgFrame, "TOPRIGHT")
	self:SetPoint("BOTTOMLEFT", self.journal.bgFrame, "BOTTOMRIGHT")

	self.randomFavoritePet.infoFrame.favorite:Show()
	self.randomFavoritePet.infoFrame.icon:SetTexture(petRandomIcon)
	self.randomFavoritePet.name:SetWidth(180)
	self.randomFavoritePet.name:SetText(PET_JOURNAL_SUMMON_RANDOM_FAVORITE_PET)
	self.randomPet.infoFrame.icon:SetTexture(petRandomIcon)
	self.randomPet.name:SetWidth(180)
	self.randomPet.name:SetText(L["Summon Random Battle Pet"])
	self.noPet.infoFrame.icon:SetTexture("Interface/PaperDoll/UI-Backpack-EmptySlot")
	self.noPet.name:SetWidth(180)
	self.noPet.name:SetText(L["No Battle Pet"])

	self.petList = MountsJournal.pets.list

	self.searchBox:SetScript("OnTextChanged", function(searchBox)
		SearchBoxTemplate_OnTextChanged(searchBox)
		self:updateFilters()
	end)

	self.view = CreateScrollBoxListLinearView()
	self.view:SetElementInitializer("MJPetListButton", function(...)
		self:initButton(...)
	end)
	self.scrollBox = self.petListFrame.scrollBox
	ScrollUtil.InitScrollBoxListWithScrollBar(self.scrollBox, self.petListFrame.scrollBar, self.view)

	self.companionOptionsMenu = LibStub("LibSFDropDown-1.5"):SetMixin({})
	self.companionOptionsMenu:ddHideWhenButtonHidden(self)
	self.companionOptionsMenu:ddSetInitFunc(function(...) self:companionOptionsMenu_Init(...) end)
	self.companionOptionsMenu:ddSetDisplayMode(addon)

	self.scrollBox:RegisterCallback("OnDataRangeChanged", function()
		self.companionOptionsMenu:ddOnHide()
	end)

	self:on("MOUNT_SELECT", self.Hide)
end


function MJCompanionsPanelMixin:onShow()
	self:SetScript("OnShow", nil)
	C_Timer.After(0, function()
		self:SetScript("OnShow", function(self)
			if self.needSort then
				self:petListSort()
			else
				self:updateScrollPetList()
			end
			self:scrollToSelectedPet()
			self:on("UPDATE_PROFILE", self.updateScrollPetList)
		end)
		self:petListUpdate()
		self:scrollToSelectedPet()
		self:on("UPDATE_PROFILE", self.updateScrollPetList)
		self:on("PET_LIST_UPDATE", self.petListUpdate)
	end)
end


function MJCompanionsPanelMixin:onHide()
	self:off("UPDATE_PROFILE", self.updateScrollPetList)
	self:Hide()
end


function MJCompanionsPanelMixin:showCompanionOptionsMenu(btn)
	if not btn.id or type(btn.id) == "number" then
		self.companionOptionsMenu:ddCloseMenus()
	else
		self.companionOptionsMenu:ddToggle(1, btn.id, btn, 37, 0)
	end
end


function MJCompanionsPanelMixin:companionOptionsMenu_Init(btn, level, petID)
	local _,_,_,_,_,_, isFavorite = C_PetJournal.GetPetInfoByPetID(petID)
	local isRevoked = C_PetJournal.PetIsRevoked(petID)
	local isLockedForConvert = C_PetJournal.PetIsLockedForConvert(petID)
	local active = C_PetJournal.IsCurrentlySummoned(petID)
	local info = {}
	info.notCheckable = true

	if not (isRevoked or isLockedForConvert) then
		info.disabled = not C_PetJournal.PetIsSummonable(petID)
		if active then
			info.text = PET_DISMISS
			info.func = function() C_PetJournal.DismissSummonedPet(petID) end
		else
			info.text = BATTLE_PET_SUMMON
			info.func = function() C_PetJournal.SummonPetByGUID(petID) end
		end
		btn:ddAddButton(info, level)

		info.disabled = nil

		if isFavorite then
			info.text = BATTLE_PET_UNFAVORITE
			info.func = function()
				C_PetJournal.SetFavorite(petID, 0)
				self:GetParent():refresh()
			end
		else
			info.text = BATTLE_PET_FAVORITE
			info.func = function()
				C_PetJournal.SetFavorite(petID, 1)
				self:GetParent():refresh()
			end
		end
		btn:ddAddButton(info, level)
	end

	info.func = nil
	info.text = CANCEL
	btn:ddAddButton(info, level)
end


function MJCompanionsPanelMixin:scrollToSelectedPet()
	local selectedPetID = self.journal.petForMount[self.journal.selectedSpellID]
	self.scrollBox:ScrollToElementDataByPredicate(function(data)
		return data.petID == selectedPetID
	end)
end


function MJCompanionsPanelMixin:selectButtonClick(id)
	self.journal.petForMount[self.journal.selectedSpellID] = id
	self.journal:updateMountsList()
	self:GetParent():refresh()
	self:Hide()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end


function MJCompanionsPanelMixin:initButton(btn, data)
	local selectedPetID = self.journal.petForMount[self.journal.selectedSpellID]
	local _, customName, level, _,_,_, favorite, name, icon, _, creatureID = C_PetJournal.GetPetInfoByPetID(data.petID)

	btn.id = data.petID
	btn.creatureID = creatureID
	btn.selectedTexture:SetShown(data.petID == selectedPetID)
	btn.name:SetText(name)
	btn.infoFrame.icon:SetTexture(icon)
	btn.infoFrame.favorite:SetShown(favorite)
end


function MJCompanionsPanelMixin:petListUpdate()
	self.needSort = true
	if self:IsVisible() then
		self:petListSort()
	end
end


function MJCompanionsPanelMixin:petListSort()
	local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
	sort(self.petList, function(p1, p2)
		if p1 == p2 then return false end
		local _,_,_,_,_,_, favorite1, name1 = GetPetInfoByPetID(p1)
		local _,_,_,_,_,_, favorite2, name2 = GetPetInfoByPetID(p2)

		if favorite1 and not favorite2 then return true
		elseif not favorite1 and favorite2 then return false end

		if name1 < name2 then return true
		elseif name1 > name2 then return false end

		return p1 < p2
	end)

	self.needSort = false
	self:updateFilters()
end


function MJCompanionsPanelMixin:updateScrollPetList()
	self.scrollBox:SetDataProvider(self.dataProvider, ScrollBoxConstants.RetainScrollPosition)
end


function MJCompanionsPanelMixin:updateFilters()
	local text = self.util.cleanText(self.searchBox:GetText())
	local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
	local numPets = 0
	self.dataProvider = CreateDataProvider()

	for i = 1, #self.petList do
		local petID = self.petList[i]
		local _,_,_,_,_,_,_, name = GetPetInfoByPetID(petID)

		if #text == 0
		or name:lower():find(text, 1, true)
		then
			numPets = numPets + 1
			self.dataProvider:Insert({index = numPets, petID = petID})
		end
	end

	self:updateScrollPetList()
end