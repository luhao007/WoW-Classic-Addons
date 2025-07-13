local addonName, addonTable = ...;
local Url="Interface/AddOns/"..addonName.."/Audio/"
local AudioList = {
	["Countdown"]={--倒计时语音
		{"倒计时语音(露露)",Url.."Countdown"},
	},
	["QuestEnd"]={--任务完成
		{"任务完成(露露)",Url.."QuestEnd_1.ogg"},
		{"工作完成(露露)",Url.."QuestEnd_2.ogg"},
		{"Bingo(露露)",Url.."QuestEnd_3.ogg"},
	},
	["FollowMsg"]={--有关注消息
		{"有关注消息(露露)",Url.."FollowMsg_1.ogg"},
	},
	["HardcoreDeaths"]={--硬核吃席
		{"吃大席喽(露露)",Url.."HardcoreDeaths_1.ogg"},
		{"吃席咯(露露)",Url.."HardcoreDeaths_2.ogg"},
		{"吃席啦1(露露)",Url.."HardcoreDeaths_3.ogg"},
		{"吃席啦2(露露)",Url.."HardcoreDeaths_4.ogg"},
		{"开席(露露)",Url.."HardcoreDeaths_5.ogg"},
	},
	["GDKP_Start"]={--金团助手物品开拍
		{"有物品开拍(露露)",Url.."GDKP_Start_1.ogg"},
	},
	["GDKP_End"]={--金团助手拍卖结束
		{"拍卖结束(露露)",Url.."GDKP_End_1.ogg"},
	},
}
addonTable.AudioList=AudioList