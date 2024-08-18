local _, addonTable = ...;
local find = _G.string.find
local gsub = _G.string.gsub
local _, _, _, tocversion = GetBuildInfo()
local FramePlusfun=addonTable.FramePlusfun
---------
local banbendata = {
	[0]=EXPANSION_NAME0,[1]=EXPANSION_NAME1,[2]=EXPANSION_NAME2,[3]=EXPANSION_NAME3,[4]=EXPANSION_NAME4,
	[5]=EXPANSION_NAME5,[6]=EXPANSION_NAME6,[7]=EXPANSION_NAME7,[8]=EXPANSION_NAME8,[8]=EXPANSION_NAME8,
	[9]=EXPANSION_NAME9,[10]=EXPANSION_NAME10,[11]=EXPANSION_NAME11,[99]="",
}

--物品卖价
local function ItemSell_Tooltip(self, data1, data2,laiyuan)
	if PIGA["Tooltip"]["ItemSell"] then
		--if not MerchantFrame:IsVisible() then
			local _, link = self:GetItem()
			if link then
				local itemSellG = select(11, GetItemInfo(link))
				if itemSellG and itemSellG > 0 then
					local stackCount = 1
					if laiyuan=="Bag" then
						local ItemInfo = C_Container.GetContainerItemInfo(data1, data2)
						stackCount=ItemInfo.stackCount or stackCount
					elseif laiyuan=="Quest" then
						local _, _, count = GetQuestItemInfo(data1, data2)
						stackCount=count or stackCount
					elseif laiyuan=="QuestLog" then
						local _, _, count = GetQuestLogRewardInfo(data2)
						stackCount=count or stackCount
					end
					if stackCount>1 then
						self:AddLine(SELL_PRICE..": |cffFFFFFF"..GetMoneyString(itemSellG*stackCount).."|r   ( 单价|cffFFFFFF"..GetMoneyString(itemSellG).."|r )")
					else
						self:AddLine(SELL_PRICE..": |cffFFFFFF"..GetMoneyString(itemSellG*stackCount).."|r")
					end
					self:Show()
				end
			end
		--end
	end
end
function FramePlusfun.Tooltip_ItemSell()
	--处理系统卖价
	local old_GameTooltip_OnTooltipAddMoney=GameTooltip_OnTooltipAddMoney
	if PIGA["Tooltip"]["ItemSell"] then
		GameTooltip_OnTooltipAddMoney=function(self, cost, maxcost)
			--禁用系统的卖家显示
		end
	else
		GameTooltip_OnTooltipAddMoney=old_GameTooltip_OnTooltipAddMoney
	end
end

local function Tooltip_ItemLV(self,link)
	if PIGA["Tooltip"]["ItemLevel"] then
		local effectiveILvl = GetDetailedItemLevelInfo(link)
		if effectiveILvl then
			if tocversion<50000 then
				local txtUI = _G[self:GetName().."TextLeft2"]
				local Oldtxt = txtUI:GetText()
	    		if Oldtxt and Oldtxt~=" " then
	    			txtUI:SetText('|cffffcf00'.."物品等级 "..effectiveILvl..'|r'.."\n"..Oldtxt)
	    			--txtUI:SetFormattedText('|cffffcf00'.."物品等级 "..effectiveILvl..'|r'.."\n"..Oldtxt)
	        		txtUI:SetSpacing(2)
	        	else
	        		txtUI:SetText('\n|cffffcf00'.."物品等级 "..effectiveILvl..'|r')
	        		--txtUI:SetFormattedText('\n|cffffcf00'.."物品等级 "..effectiveILvl..'|r')
	        		txtUI:SetSpacing(-10)
	        	end
	            local txtUI_r = _G[self:GetName().."TextRight2"]
				txtUI_r:SetSpacing(3)
				local Oldtxt2_r = txtUI_r:GetText()
				if Oldtxt2_r then
					txtUI_r:SetText(' '.."\n"..Oldtxt2_r)
					--txtUI_r:SetFormattedText(' '.."\n"..Oldtxt2_r)
				end
			else
				local classID=select(12, GetItemInfo(link))
	            if classID~=2 and classID~=4 and classID~=19 then
					local txtUI = _G[self:GetName().."TextLeft2"]
					local Oldtxt = txtUI:GetText()
	        		if Oldtxt and Oldtxt~=" " then
	        			txtUI:SetText('|cffffcf00'.."物品等级 "..effectiveILvl..'|r'.."\n"..Oldtxt)
	        			--txtUI:SetFormattedText('|cffffcf00'.."物品等级 "..effectiveILvl..'|r'.."\n"..Oldtxt)
	            		txtUI:SetSpacing(2)
	            	else
	            		txtUI:SetText('\n|cffffcf00'.."物品等级 "..effectiveILvl..'|r')
	            		--txtUI:SetFormattedText('\n|cffffcf00'.."物品等级 "..effectiveILvl..'|r')
	            		txtUI:SetSpacing(-10)
	            	end
	            	 local txtUI_r = _G[self:GetName().."TextRight2"]
					txtUI_r:SetSpacing(3)
					local Oldtxt2_r = txtUI_r:GetText()
					if Oldtxt2_r then
						txtUI_r:SetText(' '.."\n"..Oldtxt2_r)
						--txtUI_r:SetFormattedText(' '.."\n"..Oldtxt2_r)
					end
	           	end
			end
		end
	end
	if PIGA["Tooltip"]["ItemMaxCount"] or PIGA["Tooltip"]["IDinfo"] then
		local itemStackCount,_, _, _, _, _, _, expacID = select(8, GetItemInfo(link))
		if PIGA["Tooltip"]["ItemMaxCount"] then
			if itemStackCount and itemStackCount>1 then
			    self:AddLine("|cffffcf00最大堆叠|r "..itemStackCount)
			end
		end
		if PIGA["Tooltip"]["IDinfo"] then
			local itemID = GetItemInfoInstant(link)
			if itemID then
				local expacID = expacID or 99
			    self:AddDoubleLine("|cffd33c54ID:|r "..itemID,banbendata[expacID])    
			end
		end
	end
	self:Show()
end
function FramePlusfun.Tooltip()
	hooksecurefunc(GameTooltip, "SetBagItem", function(self, bag, slot)
		ItemSell_Tooltip(self, bag, slot,"Bag")
	end)
	hooksecurefunc(GameTooltip, "SetQuestItem", function(self, questType, index)
		ItemSell_Tooltip(self, questType, index,"Quest")
	end)
	hooksecurefunc(GameTooltip, "SetQuestLogItem", function(self, questType, index)
		ItemSell_Tooltip(self, questType, index,"QuestLog")
	end)
	FramePlusfun.Tooltip_ItemSell()
	if tocversion<100000 then
		if tocversion<50000 then
			hooksecurefunc("GameTooltip_ShowCompareItem", function(self, anchorFrame)
				if not PIGA["Tooltip"]["ItemLevel"] then return end
				local tooltip, anchorFrame, shoppingTooltip1, shoppingTooltip2 = GameTooltip_InitializeComparisonTooltips(self, anchorFrame);
				local _, link1 = shoppingTooltip1:GetItem()
				if link1 then
					local classID=select(12, GetItemInfo(link1))
					if classID==2 or classID==4 then
						local txtUI_1 = _G[shoppingTooltip1:GetName().."TextLeft3"]
						txtUI_1:SetSpacing(2)
						local Oldtxt1 = txtUI_1:GetText()
						local effectiveILvl1 = GetDetailedItemLevelInfo(link1)
						txtUI_1:SetText('|cffffcf00'.."物品等级 "..effectiveILvl1..'|r'.."\n"..Oldtxt1)
			            --txtUI_1:SetFormattedText('|cffffcf00'.."物品等级 "..effectiveILvl1..'|r'.."\n"..Oldtxt1)
			            txtUI_1:SetJustifyH("LEFT")
			            local txtUI_1_r = _G[shoppingTooltip1:GetName().."TextRight3"]
						txtUI_1_r:SetSpacing(2)
						local Oldtxt1_r = txtUI_1_r:GetText()
						if Oldtxt1_r then
							txtUI_1_r:SetText(' '.."\n"..Oldtxt1_r)
							--txtUI_1_r:SetFormattedText(' '.."\n"..Oldtxt1_r)
						end
			            shoppingTooltip1:Show()
			        end
				end
				local _, link2 = shoppingTooltip2:GetItem()
				if link2 then
					local classID=select(12, GetItemInfo(link2))
					if classID==2 or classID==4 then
						local txtUI_2 = _G[shoppingTooltip2:GetName().."TextLeft3"]
						txtUI_2:SetSpacing(2)
						local Oldtxt2 = txtUI_2:GetText()
						local effectiveILvl2 = GetDetailedItemLevelInfo(link2)
						txtUI_2:SetText('|cffffcf00'.."物品等级 "..effectiveILvl2..'|r'.."\n"..Oldtxt2)
			            --txtUI_2:SetFormattedText('|cffffcf00'.."物品等级 "..effectiveILvl2..'|r'.."\n"..Oldtxt2)
			            txtUI_2:SetJustifyH("LEFT")
			            local txtUI_2_r = _G[shoppingTooltip2:GetName().."TextRight3"]
						txtUI_2_r:SetSpacing(2)
						local Oldtxt2_r = txtUI_2_r:GetText()
						if Oldtxt2_r then
							txtUI_2_r:SetText(' '.."\n"..Oldtxt2_r)
							--txtUI_2_r:SetFormattedText(' '.."\n"..Oldtxt2_r)
						end
			            shoppingTooltip2:Show()
			        end
				end
			end)
			GameTooltip:HookScript("OnTooltipSetItem", function(self)
				local _, link = self:GetItem()
				if link then
					Tooltip_ItemLV(self,link)
				end
			end)
			--处理天赋
			hooksecurefunc(GameTooltip, "SetTalent", function(self,talentTree,tfID,inspect,pet,Group,...)
				local _, _, _, _, _, _, _, _, _, _, ctid, tID = GetTalentInfo(talentTree,tfID, inspect,pet,Group)
				if tID and tID>0 then
					self:AddDoubleLine("|cffd33c54TalentID:|r "..tID,"")
				elseif ctid and ctid>0 then
					self:AddDoubleLine("|cffd33c54TalentID:|r "..ctid,"")
				end
				self:Show()
			end)
			--处理技能
			GameTooltip:HookScript("OnTooltipSetSpell", function(self)
				if not PIGA["Tooltip"]["IDinfo"] then return end
				local _,id = self:GetSpell()
				if id then
					self:AddDoubleLine("|cffd33c54SpellID:|r "..id,"")
					self:Show()
				end
			end)
			---处理BUFF/DEBUFF
			local function UnitBuff_Tooltip(self, unit, index, filter)
				if not PIGA["Tooltip"]["IDinfo"] then return end
				local _, icon, count, debuffType, duration, expires, caster,_,_,spellID = UnitAura(unit, index, filter) 
			    if spellID then
			    	if caster then
				        local _, class = UnitClass(caster) 
				        local color = PIG_CLASS_COLORS[class];
				        local name = GetUnitName(caster, true)
				        self:AddDoubleLine("|cffd33c54SpellID:|r "..spellID.."\124r","来自: \124c"..color.colorStr..name.."\124r")
					else
						self:AddDoubleLine("|cffd33c54SpellID:|r "..spellID.."\124r","来自: \124cff48cba0未知\124r")
					end
					self:Show() 
			    end 
			end
			hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, unit, index, filter)
				UnitBuff_Tooltip(self, unit, index, filter)
			end)
			hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self, unit, index, filter)
				UnitBuff_Tooltip(self, unit, index, filter)
			end)
			hooksecurefunc(GameTooltip, "SetUnitAura", function(self, unit, index, filter)
				UnitBuff_Tooltip(self, unit, index, filter) 
			end)
			--处理聊天框物品
			hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
				if link:find("^spell:") then
					if PIGA["Tooltip"]["IDinfo"] then
						local id = link:gsub(":0","")
						local id = id:gsub("spell:","")
						ItemRefTooltip:AddDoubleLine("|cffd33c54SpellID:|r "..id,"")
						ItemRefTooltip:Show()
					end
				elseif link:find("^item:") then
					if tocversion<50000 then
						Tooltip_ItemLV(ItemRefTooltip,link)
					end
				end
			end)
		end
	else
		--处理物品
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(self, data)
			if not PIGA["Tooltip"]["ItemLevel"] and not PIGA["Tooltip"]["IDinfo"] then return end
			local ItemID = data["id"]
			if ItemID then
				Tooltip_ItemLV(self,ItemID)
			end
		end)
		-- TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(self, data)
		-- 	if (C_PetBattles.IsInBattle()) then
	 --            return
	 --        end
	 --        print(TooltipUtil.GetDisplayedUnit(self))
		-- end)
		--处理BUFF
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.UnitAura, function(self, data)
			if not PIGA["Tooltip"]["IDinfo"] then return end
			if data and data.id then
				self:AddDoubleLine("|cffd33c54ID:|r "..data.id,"")
				self:Show()
			end
		end)
		--处理技能
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(self)
			if not PIGA["Tooltip"]["IDinfo"] then return end
			local _,id = self:GetSpell()
			if id then
				self:AddDoubleLine("|cffd33c54ID:|r "..id,"")
				self:Show()
			end
		end)
		--处理宠物动作条技能
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.PetAction,  function(self)
			if not PIGA["Tooltip"]["IDinfo"] then return end
			local displayedName = _G[self:GetName().."TextLeft"..1]:GetText()
			if displayedName then
				local name, icon, castTime, minRange, maxRange, spellID = PIGGetSpellInfo(displayedName)
				if spellID then
					self:AddDoubleLine("|cffd33c54ID:|r "..spellID,"")
				end
			end
		end)
	end
end