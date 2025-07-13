local addonName, addonTable = ...;

local Data={
	["Countdown"]={--倒计时语音
		{"1","AI"},
	},
	["QuestEnd"]={--任务完成
		{"任务完成","AI"},
	},
	["FollowMsg"]={--有关注消息
		{"有关注消息","AI"},
	},
	["HardcoreDeaths"]={--硬核吃席
		{"吃大席","AI"},
	},
	["GDKP_Start"]={--金团助手物品开拍
		{"有物品开拍","AI"},
	},
	["GDKP_End"]={--金团助手拍卖结束
		{"拍卖结束","AI"},
	},
}
local function AddFun(extData)
	local AudioList=addonTable.AudioList
	if AudioList.Ext then
		for k,v in pairs(AudioList.Data) do
			for ix=1,#extData[k] do
				table.insert(AudioList.Data[k],extData[k][ix])
			end
		end
	else
		AudioList.Ext=true
		for k,v in pairs(AudioList.Data) do
			AudioList.Data[k]=extData[k]
		end
	end
end
addonTable.AudioList= {
	["Ext"]=false,
	["Data"]=Data,
	["AddFun"]=AddFun,
}