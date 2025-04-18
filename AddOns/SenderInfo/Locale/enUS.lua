local L = LibStub("AceLocale-3.0"):NewLocale("SenderInfo", "enUS");
if (not L) then
	return;
end

L["测试标题"] = "测试标题";
L["测试描述"] = "测试描述";

L["开启"] = "开启";
L["关闭"] = "关闭";

L["开关提示1"] = "[SenderInfo]插件 ==> %s";
L["开关提示2"] = "[SenderInfo]插件 推广模式 ==> %s 感谢支持!";


L["插件提示0"] = "[SenderInfo]作者: 大力力 - 范克瑞斯";
L["插件提示1"] = "[SenderInfo]插件加载完毕 宏命令 /sinfo  打开配置界面  /sinfop 快捷开关功能";
L["插件提示2"] = "[SenderInfo](必须)插件依赖 alaTalentEmu (天赋模拟器) 否则无法使用!!";
L["插件提示3"] = "[SenderInfo](选装)如果安装 WCLPlayerScore-WotLK-CN 可以得到WCL评分信息!!";
L["插件提示4"] = "[SenderInfo]反馈Q群:469058815   [提示信息仅供参考]";

L["预览"] = "预览:";

L["依赖天赋模拟器提示"] = "|Cffff0000 检测到本地未安装 alaTalentEmu (天赋模拟器) 初始化失败 请安装!!|r";
L["依赖天赋模拟器提示2"] = "|Cffff0000 SenderInfo  聊天者信息显示插件 依赖于 TalentEmu 插件 否则无法使用 | 检测到本地未安装 alaTalentEmu (天赋模拟器) 请安装!!|r";
L["未准备就绪"] = "|Cffff0000 SenderInfo  聊天者信息显示插件 未准备就绪 !!|r";


L["天赋字符串1全部"] 		= "[%s][%s级%s%s]%s ";
L["天赋字符串2无级"] 		= "[%s][%s%s]%s ";
L["天赋字符串3无点"] 		= "[%s][%s级%s%s] "
L["天赋字符串4无级无点"] 	= "[%s][%s%s] ";

L["装备评分"] 	= " |cff%sGS:|r |cff%s%s|r"
L["平均装等"] 	= " |cff%s装等:|r |cff%s%s|r";


L["开关标题"] = "开启";
L["开关描述"] = "开关插件";

L["推广后缀"] = " 【信息由插件 [SenderInfo] 提供】";
L["推广标题"] = "推广";
L["推广描述"] = "开启后 所有提示信息会带上\n[SenderInfo]";

L["具体天赋加点提示标题"] = "天赋加点";
L["具体天赋加点提示描述"] = "开启后 显示具体天赋加点情况";

L["显示等级标题"] = "等级";
L["显示等级描述"] = "开启后 显示具体等级";

L["显示职业颜色标题"] = "职业颜色";
L["显示职业颜色描述"] = "开启后 显示职业颜色 否则黄色";

L["天赋提示预览1"] = "[大力力][80等级 神圣 圣骑士] (54/17/0)";
L["天赋提示预览2"] = "[大力力][80等级 神圣 圣骑士]";
L["天赋提示预览3"] = "[大力力][神圣 圣骑士] (54/17/0)";
L["天赋提示预览4"] = "[大力力][神圣 圣骑士]";

L["职业颜色1"] = "|cfffff000%s|r";
L["职业颜色2"] = "|cffE884B0%s|r";

L["平均装等显示"] = " |cfffff000装等:|r |cffFF8000213|r";
L["GS显示"] = "  |cfffff000GS:|r |cff1EFF004321|r";
L["WCL显示"] = "  |cFFFF8000 xx全明星第x奶骑 |r  |cFFA335EE NAX:xx% |r";


L["显示装等标题"] = "装等";
L["显示装等描述"] = "开启后 显示装等 否则不显示";


L["显示GS标题"] = "GS";
L["显示GS描述"] = "得到装备评分 仅供参考";
L["显示WCL标题"] = "WCL评分";
L["显示WCL描述"] = "显示WCL描述 需要本地安装 WCLPlayerScore-WotLK-CN ";


L["显示的信息在系统频道标题"] = "显示在系统频道";
L["显示的信息在系统频道描述"] = "否则 会以私聊的形式回发给私聊者";

L["提示间隔标题"] = "提示间隔(秒)";
L["提示间隔描述"] = "防止同一目标反复私聊, 反复提示信息的 最小提示间隔";

L["是否开启发送自己信息标题"] = "开启发送自己的信息";
L["是否开启发送自己信息描述"] = "开启后 通过特定触发内容 可以将自己的信息发送到指定频道";


L["发送自己信息标题"] = "触发内容:";
L["发送自己信息描述"] = "发送对应文本即可触发   会将自己的信息发送到对应的频道";
L["发送自己信息用法"] = "一般来说用 1";

L["自己信息私聊发送提示"] = "!!可以通过在对应的频道发送指定消息内容 然后发送自己的信息!!";
L["自己信息私聊发送标题"] = "私聊";
L["自己信息私聊发送描述"] = "自己信息可以通过私聊频道发送";
L["自己信息队伍发送标题"] = "队伍";
L["自己信息队伍发送描述"] = "自己信息可以通过队伍频道发送";
L["自己信息团队发送标题"] = "团队";
L["自己信息团队发送描述"] = "自己信息可以通过团队频道发送";
L["自己信息公会发送标题"] = "公会";
L["自己信息公会发送描述"] = "自己信息可以通过公会频道发送";


L["开团助手标题"] = "小助手";
L["开团助手描述"] = "开启后收到的信息会被归纳 弹出一个窗口 可以快速的邀请组队 \n 如果设置了条件 则条件满足时自动打开小助手  否则任何情况下都会自动打开小助手 \n 你也可以手动打开小助手 \n 具体根据自己的实际需求 合理的配置";
L["开团助手界面宽度标题"] = "助手界面宽度";
L["开团助手界面宽度描述"] = "调整助手界面宽度 根据自己需求挑战";

L["缩小后自动打开时间标题"] = "缩小后自动打开时间";
L["缩小后自动打开时间描述"] = "如果小助手被缩小了 这个时候有新消息来 如果时间超过了设置时间则会自动打开 \n 0秒 = 立即打开  9999秒 = 不打开";


L["加入通知标题"] = "加入通知";
L["加入通知描述"] = "新加入的队员进行 信息通知";
L["仅队长通知标题"] = "仅队长通知";
L["仅队长通知描述"] = "如果你不是队长/团长不会进行通知";

L["寻求组队标题"] = "寻求组队/队伍查找器";
L["寻求组队描述"] = "(小助手自动打开条件)\n 如果你当前处于 寻求组队中/队伍查找器 开着的时候 会自动打开小助手";

L["队长时打开助手标题"] = "队长/团长/助手";
L["队长时打开助手描述"] = "(小助手自动打开条件)\n  如果你是 队长/团长/助手 时 收到消息会自动打开小助手 ";

L["手动打开助手标题"] = "手动打开小助手";
L["手动打开助手描述"] = "小助手被打开时 会搜集所有消息 否则只能通过自动打开条件才会手动打开";


L["重置小助手位置标题"] = "重置小助手位置";
L["重置小助手位置描述"] = "小助手的位置现在可以随意拖动并且会保存 下次打开也会在这个位置! \n 但是如果你把他拖到屏幕外了就无法拖动回来了 如果你看不到小助手 可以试试重置他的位置重新打开";


L["快速回复提示"] = "自定义快速回复内容  可在小助手中快速回复目标指定消息内容 \n 修改后需要重载插件 /rl 或者 /reload"
L["快速回复标题"] = "快速回复"
L["快速回复描述"] = "小助手中可以快速回复目标指定消息内容"
L["快速回复用法"] = "指定消息内容 在小助手中可以快捷回复"

L["战斗中自动缩小标题"] = "战斗中自动缩小";
L["战斗中自动缩小描述"] = "如果触发战斗将会自动缩小 小助手 战斗结束后自动打开 (前提是有信息)";


L["装等着色等级标题"] = "装等着色设置"
L["装等着色等级设置描述"] = "如果<设置的等级将会以此颜色着色";

L["白色"] = "白色"
L["绿色"] = "绿色"
L["蓝色"] = "蓝色"
L["紫色"] = "紫色"