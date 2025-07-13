local addonName, addonTable = ...;
local Url="Interface/AddOns/"..addonName.."/Audio/"
local AudioList = {
	["Countdown"]={--倒计时语音
		{"倒计时语音(饽饽)",Url.."Countdown"},
	},
	["QuestEnd"]={--任务完成
		{"任务完成(饽饽)",Url.."QuestEnd_1.ogg"},
	},
	["FollowMsg"]={--有关注消息
		{"有关注消息(饽饽)",Url.."FollowMsg_1.ogg"},
	},
	["HardcoreDeaths"]={--硬核吃席
		{"吃大席(饽饽)",Url.."HardcoreDeaths_1.ogg"},
	},
	["GDKP_Start"]={--金团助手物品开拍
		{"有物品开拍(饽饽)",Url.."GDKP_Start_1.ogg"},
	},
	["GDKP_End"]={--金团助手拍卖结束
		{"拍卖结束(饽饽)",Url.."GDKP_End_1.ogg"},
	},
}
addonTable.AudioList=AudioList
