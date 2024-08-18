local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
-------
local GetItemCooldown=C_Container.GetItemCooldown
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemLink = C_Container.GetContainerItemLink
local IsCurrentSpell=IsCurrentSpell or C_Spell and C_Spell.IsCurrentSpell
local GetSpellBookItemInfo=GetSpellBookItemInfo or C_SpellBook and C_SpellBook.GetSpellBookItemInfo
local PIGbookType
if tocversion<50000 then
	PIGbookType=BOOKTYPE_SPELL
else
	PIGbookType=Enum.SpellBookSpellBank.Player
end
-----
_G.BINDING_HEADER_PIG = addonName
local ActionFun={}
----------
local suijizuoqi = [=[/run C_MountJournal.SummonByID(0)]=]
local function UseKeyDownUP(fuji)
	if tocversion<100000 then
		fuji:RegisterForClicks("AnyUp");
	else
		local UseKeyDown =GetCVar("ActionButtonUseKeyDown")
		if UseKeyDown=="0" then
			fuji:RegisterForClicks("AnyUp");
		elseif UseKeyDown=="1" then
			fuji:RegisterForClicks("AnyDown")
		end
	end
	-- SetBinding("CTRL-SHIFT-ALT-Q", "CLICK fuji:Button31")
	-- fuji:RegisterForClicks("AnyUp", "Button31Down")
	-- fuji:SetAttribute("type31", "")
	-- fuji:WrapScript(fuji, "OnClick", [=[
	-- 	print(button, down)
	--     -- fuji, button, down
	--     if (button == "Button31" and down) then
	--         return "LeftButton"
	--     end
	-- ]=])
end
function ActionFun.PIGUseKeyDown(fuji)
	UseKeyDownUP(fuji)
	fuji:RegisterEvent("CVAR_UPDATE");
	fuji:HookScript("OnEvent", function(self,event,arg1)
		if event=="CVAR_UPDATE" then
			if arg1=="ActionButtonUseKeyDown" then
				UseKeyDownUP(self)
			end
		end
	end)
end
addonTable.Fun.PIGUseKeyDown=ActionFun.PIGUseKeyDown
function ActionFun.Update_Attribute(self)
	local Type=self.Type
	if Type then
		self:SetAttribute("type", Type)	
		local SimID=self.SimID
		if Type=="spell" then
			self:SetAttribute(Type, SimID)
		elseif Type=="item" then
			self:SetAttribute(Type, SimID)
		elseif Type=="macro" then
			self:SetAttribute(Type, SimID)
		elseif Type=="companion" then
			self:SetAttribute("type", "spell")	
			self:SetAttribute("spell", SimID)
		elseif Type=="mount" then
			if SimID==268435455 then
				self:SetAttribute("type", "macro")
				self:SetAttribute("macrotext", suijizuoqi)
			else
				self:SetAttribute("type", "spell")	
				self:SetAttribute("spell", SimID)
			end
		elseif Type=="equipmentset" then
			local eqid=C_EquipmentSet.GetEquipmentSetID(self.SimID)
			if eqid then
				self:SetAttribute("type", "macro");
				self:SetAttribute("macrotext", "/equipset "..SimID);
			else
				self:SetAttribute("type", nil);
				self.Type=nil
			end
		end
	end
end
--更新Icon状态
local function Update_spell_Icon(SimID)
	local isTrue = SpellIsSelfBuff(SimID)
	if isTrue then
		if tocversion>90000 then
			local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,spellId= C_UnitAuras.GetPlayerAuraBySpellID(SimID)
			if spellId then
				if duration==0 then
					return 136116
				end
			end
		else
			for x=1,BUFF_MAX_DISPLAY do--有此状态
				local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,spellId=UnitBuff("player",x,"PLAYER")
				if spellId then
					if spellId==SimID then
						if duration==0 then
							return 136116
						end
					end
				else
					break
				end
			end
		end
	end
	local icon = GetSpellTexture(SimID)
	return icon
end
local function PIGGetItemIcon(SimID)
	if SimID and C_Item and C_Item.GetItemIconByID then
		local icon = C_Item.GetItemIconByID(SimID)
		if icon then return icon end
	end
	return 134400
end
function ActionFun.Update_Icon(self)
	local Type=self.Type
	if Type then
		local SimID=self.SimID
		if Type=="spell" then
			self.icon:SetTexture(Update_spell_Icon(SimID))
		elseif Type=="item" then
			self.icon:SetTexture(PIGGetItemIcon(SimID));
		elseif Type=="macro" then
			local name, icon,body = GetMacroInfo(SimID)
			self.icon:SetTexture(icon)
		elseif Type=="companion" then
			local spellId=self.SimID_3
			self.icon:SetTexture(GetSpellTexture(spellId))
		elseif Type=="mount" then
			local spellId=self.SimID_3
			self.icon:SetTexture(GetSpellTexture(spellId))
		elseif Type=="equipmentset" then
			local equdi = C_EquipmentSet.GetEquipmentSetID(SimID)
			if equdi then
				local name,icon = C_EquipmentSet.GetEquipmentSetInfo(equdi)
				self.icon:SetTexture(icon)
			end
		end
		self.icon:Show();
	else
		self.icon:Hide();
	end
end
function ActionFun.Update_Cooldown(self)
	local Type=self.Type
	if Type then
		local SimID=self.SimID
		if Type=="spell" then
			local start, duration, enabled = GetSpellCooldown(SimID);
			if enabled==0 then
			else
				self.cooldown:SetCooldown(start, duration);
			end
		elseif Type=="item" then
			local ItemID = GetItemInfoInstant(SimID)
			local start, duration, enabled = GetItemCooldown(ItemID)
			if enabled~=0 and start and duration then
				self.cooldown:SetCooldown(start, duration);
			end
		elseif Type=="macro" then
			local hongSpellID = GetMacroSpell(SimID)
			if hongSpellID then
				local start, duration, enabled = GetSpellCooldown(hongSpellID);
				if enabled==0 then
				else
					self.cooldown:SetCooldown(start, duration);
				end
			else
				local ItemName, ItemLink = GetMacroItem(SimID);
				if ItemName then
					local ItemID = GetItemInfoInstant(ItemLink)
					local start, duration, enabled = GetItemCooldown(ItemID);
					if enabled==0 then
					else
						self.cooldown:SetCooldown(start, duration);
					end
				end
			end
		end
	end
end
function ActionFun.Update_Count(self)
	local Type=self.Type
	self.Name:SetText();
	if Type then
		local SimID=self.SimID
		if Type=="spell" then
			local SPhuafei=IsConsumableSpell(SimID)
			if SPhuafei then
				local jiengncailiao = GetSpellCount(SimID)
				if jiengncailiao>0 then
		            self.Count:SetText(jiengncailiao)
		        else
		        	self.Count:SetText("|cffff0000"..jiengncailiao.."|r")
		        end
		    else
				self.Count:SetText()
		    end
		elseif Type=="item" then
			local _,dalei,xiaolei = GetItemInfoInstant(SimID)
			local Ccount = GetItemCount(SimID, false, true) or GetItemCount(SimID)
			if dalei=="消耗品" then
				if Ccount>0 then
					self.Count:SetText(Ccount);
				else
					self.Count:SetText("|cffff0000"..Ccount.."|r");
				end
			else
				if Ccount>1 then
					self.Count:SetText(Ccount);
				end
			end
		elseif Type=="macro" then
			local name, icon, body, isLocal = GetMacroInfo(SimID)
			self.Name:SetText(name);
			local hongSpellID = GetMacroSpell(SimID)
			if hongSpellID then
				local SPhuafei=IsConsumableSpell(hongSpellID)
				if SPhuafei then
					self.Name:SetText();
					local jiengncailiao = GetSpellCount(hongSpellID)
					if jiengncailiao>0 then
			            self.Count:SetText(jiengncailiao)
			        else
			        	self.Count:SetText("|cffff0000"..jiengncailiao.."|r")
			        end
			    else
					self.Count:SetText()
			    end
			else
				local ItemName, ItemLink = GetMacroItem(SimID);
				if ItemName then
					local ItemID = GetItemInfoInstant(ItemLink)
					local Ccount = GetItemCount(ItemID, false, true) or GetItemCount(ItemID)
					local _,dalei,xiaolei = GetItemInfoInstant(ItemID)
					if dalei=="消耗品" then
						self.Name:SetText();
						if Ccount>0 then
							self.Count:SetText(Ccount);
						else
							self.Count:SetText("|cffff0000"..Ccount.."|r");
						end
					else
						if Ccount>1 then
							self.Count:SetText(Ccount);
						end
					end
				end
			end
		elseif Type=="equipmentset" then
			self.Name:SetText(self.SimID)
		end
	end
end
function ActionFun.Update_bukeyong(self)
	local Type=self.Type
	if Type then
		local SimID=self.SimID
		if Type=="spell" then
			if not IsPlayerSpell(SimID) then
				self.icon:SetVertexColor(0.5, 0.5, 0.5) 
				return 
			end
			local usable, noMana = IsUsableSpell(SimID)	
			if not usable then
				self.icon:SetVertexColor(0.5, 0.5, 0.5) 
				return 
			end
		elseif Type=="item" then
			local Ccount = GetItemCount(SimID, false, true) or GetItemCount(SimID)
			if Ccount==0 then
				self.icon:SetVertexColor(0.5, 0.5, 0.5);
				return
			end
			local usable, noMana = IsUsableItem(SimID)
			if not usable then 
				self.icon:SetVertexColor(0.5, 0.5, 0.5);
				return
			end
		elseif Type=="macro" then
			local Name, Icon, Body = GetMacroInfo(SimID);
			local TrimBody = strtrim(Body or "");
			if TrimBody=="" then
				self.icon:SetVertexColor(0.5, 0.5, 0.5);
				return
			end
			local hongSpellID = GetMacroSpell(SimID)
			if hongSpellID then
				local usable, noMana = IsUsableSpell(hongSpellID)	
				if not usable then
					self.icon:SetVertexColor(0.5, 0.5, 0.5) 
					return 
				end
			else
				local ItemName, ItemLink = GetMacroItem(SimID);
				if ItemName then
					local usable, noMana = IsUsableItem(ItemName)
					if not usable then 
						self.icon:SetVertexColor(0.5, 0.5, 0.5);
						return
					end
				end
			end
		elseif Type=="companion" then
			local spellID=self.SimID_3
			local usable, noMana = IsUsableSpell(spellID)
			if not usable then
				self.icon:SetVertexColor(0.5, 0.5, 0.5) 
				return 
			end
		elseif Type=="mount" then
			local spellID=self.SimID_3
			if SimID==268435455 then
				local usable, noMana = IsUsableSpell(spellID)
				if not usable then
					self.icon:SetVertexColor(0.5, 0.5, 0.5) 
					return 
				end
			else	
				local mountID = C_MountJournal.GetMountFromSpell(spellID)
				local isUsable, useError = C_MountJournal.GetMountUsabilityByID(mountID, true)
				if not isUsable then
					self.icon:SetVertexColor(0.5, 0.5, 0.5) 
					return 
				end
			end
		end
		self.icon:SetVertexColor(1, 1, 1);
	end
end
--更新使用状态
function ActionFun.Update_State(self)
	local Type=self.Type
	if Type then
		local SimID=self.SimID
		if Type=="spell" then
			if SimID and IsCurrentSpell(SimID) then--进入队列
				self:SetChecked(true)
				return
			end
			self:SetChecked(false)
		elseif Type=="item" then
			if SimID and IsCurrentItem(SimID) then
				self:SetChecked(true)
				return
			end	
			self:SetChecked(false)
		elseif Type=="macro" then
			local hongSpellID = GetMacroSpell(SimID)
			if hongSpellID then
				if SimID and IsCurrentSpell(hongSpellID) then--进入队列
					self:SetChecked(true)
					return
				end
			else
				local ItemName, ItemLink = GetMacroItem(SimID);
				if ItemName then
					local ItemID = GetItemInfoInstant(ItemLink)
					if SimID and IsCurrentItem(ItemID) then
						self:SetChecked(true)
						return
					end
				end
			end
			self:SetChecked(false)
		elseif Type=="companion" then
			local spellID=self.SimID_3
			if SimID and IsCurrentSpell(spellID) then
				self:SetChecked(true)
				return
			end
			self:SetChecked(false)
		elseif Type=="mount" then
			if SimID==268435455 then
				local numMounts = C_MountJournal.GetNumMounts()
				for i=1,numMounts do
					local name, spellID= C_MountJournal.GetDisplayedMountInfo(i)
					if SimID and IsCurrentSpell(spellID) then
						self:SetChecked(true)
						return
					end
				end
				self:SetChecked(false)
			else
				local spellID=self.SimID_3
				if SimID and IsCurrentSpell(spellID) then
					self:SetChecked(true)
					return
				end
				self:SetChecked(false)
			end
		end	
	end
	self:SetChecked(false)
end
function ActionFun.Update_PostClick(self)
	local Type=self.Type
	if Type then
		local SimID=self.SimID
		if Type=="spell" then
			if not IsPlayerSpell(SimID) then self:SetChecked(false) end
			local usable, noMana = IsUsableSpell(SimID)	
			if not usable then self:SetChecked(false) end
		elseif Type=="item" then
			local usable, noMana = IsUsableItem(SimID)
			if not usable then self:SetChecked(false) end
		elseif Type=="macro" then
			local Name, Icon, Body = GetMacroInfo(SimID);
			local TrimBody = strtrim(Body or "");
			if TrimBody=="" then
				self:SetChecked(false)
			end
		elseif Type=="companion" then
			local usable, noMana = IsUsableSpell(self.SimID_3)	
			if not usable then self:SetChecked(false) end
		elseif Type=="mount" then
			local usable, noMana = IsUsableSpell(self.SimID_3)	
			if not usable then self:SetChecked(false) end
		end
	else
		self:SetChecked(false)
	end
end
--初始加载
function ActionFun.loadingButInfo(self,dataY)
	self:RegisterForDrag("LeftButton")
	local butInfo = PIGA_Per[dataY]["ActionData"][self.action]
	if butInfo then
		self.Type=butInfo[1]
		self.SimID=butInfo[2]
		self.SimID_3=butInfo[3]
		ActionFun.Update_Attribute(self)
		ActionFun.Update_Icon(self)
		ActionFun.Update_Cooldown(self)
		ActionFun.Update_Count(self)
		ActionFun.Update_bukeyong(self)
		ActionFun.Update_State(self)
		ActionFun.Update_Equipment(self,dataY)
	else
		if dataY=="QuickBut" then return end
		local Showvalue = GetCVar("alwaysShowActionBars")
		if Showvalue=="0" then
			self:Hide()
		end
	end
end
--鼠标悬浮
local function OnEnter_Spell(Type,SimID)
	if IsSpellKnown(SimID) then
		if GetProfessions then
			for _, i in pairs{GetProfessions()} do
				local offset, numSlots = select(3, GetSpellTabInfo(i))
				for j = offset+1, offset+numSlots do
					local _, _ ,spellID=GetSpellBookItemName(j, PIGbookType)
					if SimID==spellID then
						local _,jibiex= GetSpellBookItemName(j, PIGbookType)
						GameTooltipTextRight1:Show()
						GameTooltip:SetSpellBookItem(j, PIGbookType);
						GameTooltipTextRight1:SetText(jibiex)
						GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5, 1);
						GameTooltip:Show();
						return
					end
				end
			end
		else
			for i = 1, GetNumSpellTabs() do
				local _, _, offset, numSlots = GetSpellTabInfo(i)
				for j = offset+1, offset+numSlots do
					local bookspellID=0
					if tocversion<50000 then
						local _,spellID= GetSpellBookItemInfo(j, PIGbookType)
						bookspellID=spellID
					else
						local spellBookItemInfo = C_SpellBook.GetSpellBookItemInfo(j, PIGbookType)
						bookspellID = spellBookItemInfo.spellID
					end
					if SimID==bookspellID then
						local _,jibiex= GetSpellBookItemName(j, PIGbookType)
						GameTooltipTextRight1:Show()
						GameTooltip:SetSpellBookItem(j, PIGbookType);
						GameTooltipTextRight1:SetText(jibiex)
						GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5, 1);
						GameTooltip:Show();
						return
					end
				end
			end
		end
	else
		GameTooltip:SetHyperlink(Type..":"..SimID)
		GameTooltip:Show();
	end
end
local function OnEnter_Item(Type,SimID,ItemID)
	if SimID then
		for Bagid=0,4,1 do
			local numberOfSlots = GetContainerNumSlots(Bagid);
			for caowei=1,numberOfSlots,1 do
				if GetContainerItemLink(Bagid, caowei)==SimID then
					GameTooltip:SetBagItem(Bagid,caowei);
					GameTooltip:Show();
					return
				end
			end
		end
		GameTooltip:SetHyperlink(SimID)
		GameTooltip:Show();
	end
end
local function OnEnter_Companion(Type,SimID,spellID)
	if C_MountJournal then
		local numMounts = C_MountJournal.GetNumMounts()--GetNumCompanions("MOUNT")
		for i=1,numMounts do
			local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected= C_MountJournal.GetDisplayedMountInfo(i)-- = GetCompanionInfo("MOUNT", i)
			if spellID then
				if SimID==spellID then
					GameTooltip:SetHyperlink("spell:"..spellID)
					GameTooltip:Show();
					return
				end
			end
		end
	end
	GameTooltip:SetHyperlink("spell:"..spellID)
	GameTooltip:Show();
end
local function OnEnter_equipmentset(Type,SimID)
	GameTooltip:SetEquipmentSet(SimID);
	GameTooltip:Show();
end
function ActionFun.Update_OnEnter(self,dataY)
	local butInfo = PIGA_Per[dataY]["ActionData"][self.action]
	if butInfo then
		local Type=self.Type
		if Type then
			local SimID=self.SimID
			if Type=="spell" then
				OnEnter_Spell(Type,SimID)
			elseif Type=="item" then
				OnEnter_Item(Type,SimID,butInfo[3])
			elseif Type=="companion" or Type=="mount" then
				OnEnter_Companion(Type,SimID,butInfo[3])
			elseif Type=="macro" then
				local hongSpellID = GetMacroSpell(SimID)
				if hongSpellID then
					OnEnter_Spell(Type,hongSpellID)
				else
					local _, ItemLink = GetMacroItem(SimID);
					if ItemLink then
						OnEnter_Item(Type,ItemLink,butInfo[3])
					else
						local name, icon, body, isLocal = GetMacroInfo(SimID)
						GameTooltip:SetText(name,1, 1, 1, 1)
						GameTooltip:Show();
					end
				end
			elseif Type=="equipmentset" then
				OnEnter_equipmentset(Type,SimID)
			end
		end
	end
end
---处理光标
local function Cursor_Loot(self,oldType,dataY)
	self.Type=nil
	PIGA_Per[dataY]["ActionData"][self.action]=nil
	--self.icon:SetTexture();
	self.Count:SetText()
	self.Name:SetText()
	self.cooldown:Hide()
	if not InCombatLockdown() then
		local oldSimID= self.SimID
		if oldType=="spell" then
			PickupSpell(oldSimID)
		elseif oldType=="item" then
			PickupItem(oldSimID)
		elseif oldType=="macro" then
			PickupMacro(oldSimID)
		elseif oldType=="companion" or oldType=="mount" then
			if oldSimID==268435455 then
				C_MountJournal.Pickup(0)
			else
				local numMounts = C_MountJournal.GetNumMounts()
				for i=1,numMounts do
					local name, spellID= C_MountJournal.GetDisplayedMountInfo(i)
					if name==oldSimID then
						C_MountJournal.Pickup(i)
						break
					end
				end
			end
		elseif oldType=="equipmentset" then
			C_EquipmentSet.PickupEquipmentSet(C_EquipmentSet.GetEquipmentSetID(oldSimID))
		end
	end
end
local function Cursor_FZ(self,NewType,canshu1,canshu2,canshu3,dataY)
	--print(NewType,canshu1,canshu2,canshu3,dataY)
	self.Type=NewType
	if NewType=="spell" then
		self.SimID=canshu3
		PIGA_Per[dataY]["ActionData"][self.action]={NewType,canshu3}
	elseif NewType=="item" then
		self.SimID=canshu2
		self.ItemID=canshu1
		PIGA_Per[dataY]["ActionData"][self.action]={NewType,canshu2,canshu1}
	elseif NewType=="macro" then
		self.SimID=canshu1
		local name, icon, body = GetMacroInfo(canshu1)
		PIGA_Per[dataY]["ActionData"][self.action]={NewType,canshu1,name,body}
	elseif NewType=="companion" or NewType=="mount" then
		if canshu1==268435455 then
			self.SimID=268435455
	    	self.SimID_3=150544
			PIGA_Per[dataY]["ActionData"][self.action]={NewType,268435455,150544}
		else
			local name, spellID= C_MountJournal.GetDisplayedMountInfo(canshu1)
	    	self.SimID=name
	    	self.SimID_3=spellID
			PIGA_Per[dataY]["ActionData"][self.action]={NewType,name,spellID}
		end
	elseif NewType=="equipmentset" then
		self.SimID=canshu1
		PIGA_Per[dataY]["ActionData"][self.action]={NewType,canshu1}
	end
	if InCombatLockdown() then return end
	self:Show()
end
function ActionFun.Cursor_Fun(self,Script,dataY)
	local oldType= self.Type
	local NewType, canshu1, canshu2, canshu3= GetCursorInfo()
	--print(NewType, canshu1, canshu2, canshu3)
	ClearCursor();
	if Script=="OnDragStart" then
		if oldType then
			Cursor_Loot(self,oldType,dataY)
		end
	end
	if Script=="OnReceiveDrag" then
		if oldType then
			Cursor_Loot(self,oldType,dataY)
		end
		if NewType then
			if NewType=="companion" or NewType=="mount" then
				if canshu1==268435455 then
					self:SetAttribute("type", "macro")
					self:SetAttribute("macrotext", suijizuoqi)
				else
					local name= C_MountJournal.GetDisplayedMountInfo(canshu1)
					self:SetAttribute("type", "spell")
					self:SetAttribute("spell", name)
				end
			elseif NewType=="equipmentset" then
				self:SetAttribute("type", "macro");
				self:SetAttribute("macrotext", "/equipset "..canshu1);
			end
			Cursor_FZ(self,NewType,canshu1,canshu2,canshu3,dataY)
		end
	end
	if Script=="OnMouseUp" then
		if NewType then
			if InCombatLockdown() then return end
			self:Disable()
			if oldType then
				Cursor_Loot(self,oldType,dataY)
			end
			if NewType=="spell" then
				self:SetAttribute("type", NewType)
				self:SetAttribute(NewType, canshu3)
			elseif NewType=="item" then
				self:SetAttribute("type", NewType)
				self:SetAttribute(NewType, canshu2)
			elseif NewType=="macro" then
				self:SetAttribute("type", NewType)
				self:SetAttribute(NewType, canshu1)
			elseif NewType=="companion" or NewType=="mount" then
				if canshu1==268435455 then
					self:SetAttribute("type", "macro")
					self:SetAttribute("macrotext", suijizuoqi)
				else
					local name= C_MountJournal.GetDisplayedMountInfo(canshu1)
					self:SetAttribute("type", "spell")
					self:SetAttribute("spell", name)
				end
			elseif NewType=="equipmentset" then
				self:SetAttribute("type", "macro");
				self:SetAttribute("macrotext", "/equipset "..canshu1);
			end
			Cursor_FZ(self,NewType,canshu1,canshu2,canshu3,dataY)
			self:Enable()
		end
	end
end
---
local function IncBetween(Val, Low, High)
	return Val >= Low and Val <= High;
end
function ActionFun.Update_Macro(self,PigMacroDeleted,PigMacroCount,dataY)
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED");
	 	return PigMacroDeleted,PigMacroCount 
	end
	local OldInfo =PIGA_Per[dataY]["ActionData"][self.action]
	local OldIndex =OldInfo[2]
	local OldName =OldInfo[3]
	local OldBody = OldInfo[4]

	local TrimBody = strtrim(OldBody or "");--去除空格
	local AccMacros, CharMacros = GetNumMacros();
	local BodyIndex = 0;
	--未变
	local Name, Icon, Body = GetMacroInfo(OldIndex);
	if (TrimBody == strtrim(Body or "") and OldName == Name) then
		self.icon:SetTexture(Icon);
		return PigMacroDeleted,PigMacroCount
	end
	--删除重新定位
	if (IncBetween(OldIndex - 1, 1, AccMacros) or IncBetween(OldIndex - 1, MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + CharMacros)) then
		local Name, Icon, Body = GetMacroInfo(OldIndex - 1);
		if (TrimBody == strtrim(Body or "") and OldName == Name) then
			PIGA_Per[dataY]["ActionData"][self.action][1]="macro"
			PIGA_Per[dataY]["ActionData"][self.action][2]=OldIndex-1
			self.Type="macro"
			self.SimID=OldIndex-1
			self.icon:SetTexture(Icon);
			self.Name:SetText(Name);
			self:SetAttribute("macro", OldIndex-1);
			return PigMacroDeleted,PigMacroCount				
		end
	end
	--增加重新定位
	if (IncBetween(OldIndex + 1, 1, AccMacros) or IncBetween(OldIndex + 1, MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + CharMacros)) then
		local Name, Icon, Body = GetMacroInfo(OldIndex + 1);
		if (TrimBody == strtrim(Body or "") and OldName == Name) then
			PIGA_Per[dataY]["ActionData"][self.action][1]="macro"
			PIGA_Per[dataY]["ActionData"][self.action][2]=OldIndex+1
			self.Type="macro"
			self.SimID=OldIndex+1
			self.icon:SetTexture(Icon);
			self.Name:SetText(Name);
			self:SetAttribute("macro", OldIndex+1);
			return PigMacroDeleted,PigMacroCount
		end
	end
	--其他宏改名后搜索相同宏位置
	for i = 1, AccMacros do
		local Name, Icon, Body = GetMacroInfo(i);
		local Body = strtrim(Body or "");
		if (TrimBody == Body and OldName == Name) then
			PIGA_Per[dataY]["ActionData"][self.action][1]="macro"
			PIGA_Per[dataY]["ActionData"][self.action][2]=i
			self.Type="macro"
			self.SimID=i
			self.icon:SetTexture(Icon);	
			self.Name:SetText(Name);
			BodyIndex = i;
			self:SetAttribute("macro", i);
			return PigMacroDeleted,PigMacroCount
		end
	
		if (TrimBody == Body and Body ~= nil and Body ~= "") then
			BodyIndex = i;
		end
	end
	--搜索角色宏
	for i = MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + CharMacros do
		local Name, Icon, Body = GetMacroInfo(i);
		local Body = strtrim(Body or "");
		if (TrimBody == Body and OldName == Name) then
			PIGA_Per[dataY]["ActionData"][self.action][1]="macro"
			PIGA_Per[dataY]["ActionData"][self.action][2]=i
			self.Type="macro"
			self.SimID=i
			self.icon:SetTexture(Icon);	
			self.Name:SetText(Name);
			self:SetAttribute("macro", i);
			return PigMacroDeleted,PigMacroCount
		end
		if (TrimBody == Body and Body ~= nil and Body ~= "") then
			BodyIndex = i;
		end
	end
	--无删除未找到名称和内容均相同的
	if PigMacroDeleted==false then
		--有相同body
		if (BodyIndex ~= 0) then 
			PIGA_Per[dataY]["ActionData"][self.action][2]=BodyIndex
			self.Type="macro"
			self.SimID=BodyIndex
			local Name, Icon, Body = GetMacroInfo(BodyIndex);
			PIGA_Per[dataY]["ActionData"][self.action][3]=Name
			self.icon:SetTexture(Icon);	
			self.Name:SetText(Name);
			self:SetAttribute("macro", BodyIndex);
			return PigMacroDeleted,PigMacroCount
		end
		--有相同Name
		local Name, Icon, Body = GetMacroInfo(OldIndex);
		if (OldName == Name) then
			PIGA_Per[dataY]["ActionData"][self.action][4]=Body
			self.icon:SetTexture(Icon);
			return PigMacroDeleted,PigMacroCount
		end
	end
	--有删除
	if PigMacroDeleted==true then
		PIGA_Per[dataY]["ActionData"][self.action]=nil
		self.Type=nil
		self.icon:SetTexture();
		self.Count:SetText();
		self.Name:SetText();
		self.cooldown:Hide()
		self:SetAttribute("type", nil);
		local Showvalue = GetCVar("alwaysShowActionBars")
		if Showvalue=="1" then
			self:Show();
		else
			self:Hide();
		end
		PigMacroDeleted = false;
		PigMacroCount = AccMacros + CharMacros;
	end
	return PigMacroDeleted,PigMacroCount
end
addonTable.ActionFun=ActionFun
--装备套装
function ActionFun.Update_Equipment(self,dataY)
	if self.Type=="equipmentset" then
		local eqid=C_EquipmentSet.GetEquipmentSetID(self.SimID)
		if eqid then

		else
			self.Type=nil
			PIGA_Per[dataY]["ActionData"][self.action]=nil
		end
		ActionFun.Update_Attribute(self)
		ActionFun.Update_Icon(self)
		ActionFun.Update_Count(self)
		ActionFun.Update_State(self)
	end
end
---
addonTable.Fun.ActionFun=ActionFun