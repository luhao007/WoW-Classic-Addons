local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
--=======================
MerchantFrame:HookScript("OnShow",function (self,event)
	if PIGA["Interaction"]["AutoRepair"] then
		if CanMerchantRepair() then --NPC是否可以修理
			local cost = GetRepairAllCost()--修理金额
			if cost > 0 then
				if tocversion>19999 and PIGA["Interaction"]["AutoRepair_GUILD"] and IsInGuild() then
					local PIGguildMoney = GetGuildBankWithdrawMoney()--玩家的公会提取额度
					if PIGguildMoney > GetGuildBankMoney() then --公会金额小于提取金额
						PIGguildMoney = GetGuildBankMoney()
					end
					if PIGguildMoney >= cost and CanGuildBankRepair() then
						RepairAllItems(true);
						PIG_print("本次修理花费：" .. GetCoinTextureString(cost).."[公会]");	
						return
					end
				end
				----
				local money = GetMoney()--自身金钱
				if money >= cost then
					RepairAllItems()
					PIG_print("本次修理花费：" .. GetCoinTextureString(cost));
				else
					PIG_print("自动修理失败：你没有足够的钱");
				end
			end
		end
	end
end)