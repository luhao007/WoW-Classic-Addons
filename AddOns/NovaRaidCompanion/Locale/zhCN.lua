local L = LibStub("AceLocale-3.0"):NewLocale("NovaRaidCompanion", "zhCN");
if (not L) then
	return;
end

L["second"] = "秒"; --Second (singular).
L["seconds"] = "秒"; --Seconds (plural).
L["minute"] = "分"; --Minute (singular).
L["minutes"] = "分"; --Minutes (plural).
L["hour"] = "小时"; --Hour (singular).
L["hours"] = "小时"; --Hours (plural).
L["day"] = "天"; --Day (singular).
L["days"] = "天"; --Days (plural).
L["secondMedium"] = "秒"; --Second (singular).
L["secondsMedium"] = "秒"; --Seconds (plural).
L["minuteMedium"] = "分"; --Minute (singular).
L["minutesMedium"] = "分"; --Minutes (plural).
L["hourMedium"] = "小时"; --Hour (singular).
L["hoursMedium"] = "小时"; --Hours (plural).
L["dayMedium"] = "天"; --Day (singular).L["days"] = "天"; --Days (plural).
L["daysMedium"] = "天"; --Days (plural).
L["secondShort"] = "秒"; --Used in short timers like 1m30s (single letter only, usually the first letter of seconds).
L["minuteShort"] = "分"; --Used in short timers like 1m30s (single letter only, usually the first letter of minutes).
L["hourShort"] = "小时"; --Used in short timers like 1h30m (single letter only, usually the first letter of hours).
L["dayShort"] = "天"; --Used in short timers like 1d8h (single letter only, usually the first letter of days).
L["startsIn"] = "将于 %s 后开始"; --"Starts in 1hour".
L["endsIn"] = "将于 %s 后结束"; --"Ends in 1hour".
L["versionOutOfDate"] = "Nova Raid Companion 插件已过期,请前往 https://www.curseforge.com/wow/addons/nova-raid-companion 或在 twitch 上更新.";
L["Options"] = "设置";
L["None"] = "无。";
L["Layout"] = "布局";
L["Drink"] = "喝水";
L["Food"] = "进食";
L["Refreshment"] = "进食饮水";
L["<- Back"] = "<- 返回";
L["Mob Spawn Time"] = "重生时间";

L["None found"] = "未找到";
L["Reputation"] = "声望";
L["logEntryTooltip"] = "左键查看记录 %s.\n右键重命名.";
L["logEntryFrameTitle"] = "重命名记录为 %s";
L["renamedLogEntry"] = "将日志 %s 重命名为 %s";
L["clearedLogEntryName"] = "已清除记录 %s";
L["tradeFilterTooltip"] = "|cFFFFFF00输入以下任意:|r\n|cFF9CD6DE你角色的名字.\n其他玩家名字或物品名字.\n金币数量.";
L["deleteInstanceConfirm"] = "从副本记录中删除 %s 信息?"
L["noRaidsRecordedYet"] = "无任何副本记录,需要一次副本活动。";
L["Boss Journal"] = "首领信息"
L["Config"] = "配置"
L["Lockouts"] = "进度"
L["Trades"] = "交易";
L["All Trades"] = "所有交易";
L["tradesForSingleRaid"] = " %s 副本活动期间的交易 (%s 记录)";
L["Set"] = "设置";
L["Reset"] = "重置";
L["Clear"] = "清除";
L["Filter"] = "过滤器";
L["Groups"] = "队伍";
L["sortByGroupsTooltip"] = "按队伍排序?";
L["Gave"] = "给";
L["Received"] = "获得";
L["to"] = "给";
L["from"] = "从";
L["for"] = "为";
L["with"] = "和";
L["on"] = "开";
L["at"] = "在";
L["Enchant"] = "附魔";
L["Enchanted"] = "附魔";
L["Gold"] = "金币";
L["gold"] = "金币";
L["silver"] = "银";
L["copper"] = "铜";
L["Warning"] = "警告";
L["Reminder"] = "提醒";
L["Item"] = "物品";
L["Items"] = "物品";
L["Less"] = "简易";
L["More"] = "详细";
L["Raid Log"] = "团队日志";
L["Deaths"] = "死亡";
L["Total Deaths"] = "总死亡数";
L["Boss"] = "首领";
L["Bosses"] = "首领";
L["On Bosses"] = "首领死亡";
L["On Trash"] = "小怪死亡";
L["Loot Count"] = "拾取数";
L["Total Loot"] = "总拾取";
L["Trash"] = "小怪";
L["Loot"] = "拾取";
L["3D Model"] = "3D 模型";
L["Buff Snapshot"] = "增益";
L["Raid"] = "团队";
L["Consumes"] = "消耗品";
L["Raid"] = "团队";
L["Start of first boss to end of last boss"] = "从第一个首领到最后一个首领";
L["From first trash kill"] = "从击杀第一个小怪开始";
L["Inside"] = "内";
L["Mobs"] = "怪物数";
L["Wipe"] = "失败";
L["Wiped"] = "失败";
L["Wipes"] = "击杀失败";
L["Kill"] = "击杀";
L["No encounters recorded."] = "无记录。";
L["Entered"] = "进本时间";
L["Left"] = "剩下";
L["First trash"] = "第一个小怪";
L["Still inside"] = "在副本内";
L["Duration"] = "当";
L["Time spent in combat"] = "战斗时长";
L["Kills"] = "击杀";
L["Total"] = "总共";
L["During Bosses"] = "在首领战";
L["During Trash"] = "在小怪战";
L["Other NPCs"] = "其他 NPC";
L["hit"] = "命中"; --Illidan Stormrage Aura of Dread hit You 1000 Shadow. 
L["Talent Snapshot for"] = "天赋";
L["No talents found"] = "未找到天赋";
L["Click to view talents"] = "点击查看天赋";
L["traded with"] = "与交易";
L["No trades matching current filter"] = "没有交易符合当前过滤器";
L["No trades recorded yet"] = "没有任何交易记录";
L["Boss model not found"] = "未找到首领模式";
L["Class"] = "职业";
L["Health"] = "Health";
L["Type"] = "种类";
L["Raid Lockouts This Char"] = "此角色副本进度";
L["Raid Lockouts (Including Alts)"] = "副本进度 (包含小号)";
L["Your durability is at"] = "你的耐久度：";
L["Summoning"] = "正在召唤"; --Summoning player to location, click!
L["click!"] = "请点门!";	--Summoning player to location, click!
L["Healthstones"] = "治疗石";
L["Ready"] = "准备";
L["Target Spawn Time Frame"] = "目标重生时间";
L["Spawned"] = "生成";
L["Hold Shift To Drag"] = "按住Shift可拖拉移动";
L["Cast on"] = "施放"; --Spell cast on player.
L["Current active soulstones"] = "目前绑定的灵魂石";
L["left"] = "剩余"; --As in time left.
L["Cast by"] = "施法者为";
L["NRC Raid Cooldowns Frame"] = "NRC团队冷却窗口";
L["Soulstone"] = "灵魂石";
L["cast on"] = "施放在";
L["Bottom"] = "下";
L["Top"] = "上";
L["Start Test Cooldowns"] = "开始冷却测试";
L["Stop Test"] = "停止测试";
L["Crits"] = "暴击"; --Used to show plural of critical hits in aoe etc like (5 Crits).

L["came online"] = "上线";
L["went offline"] = "离线";
L["has reincarnated"] = "已投胎";
L["Interrupt"] = "打断";
L["Total"] = "总和";
L["All Bosses and Trash"] = "所有首领及小怪";
L["Item Use"] = "物品使用";
L["Item Usage"] = "物品使用";
L["Usage"] = "使用";
L["Last Boss Encounter"] = "最近一场首领战斗";
L["Count View"] = "数量监控";
L["Timeline View"] = "时间轴监控";
L["Events Shown"] = "事件显示";
L["Players Shown"] = "玩家显示";
L["Custom Spells"] = "自定义技能";
L["inputValidSpellID"] = "输入一个有效的技能 ID 查看事件.";
L["inputLowerSpellIDRemove"] = "输入一个有效的技能 ID 来删除.";
L["inputLowerSpellID"] = "输入一个较小有效的技能 ID .";
L["spellIDAlreadyCustomSpell"] = "技能 ID %s 已经是一个自定义技能.";
L["spellIDNotCustomSpell"] = "技能 ID %s 未找到作为自定义技能."
L["noSpellFoundWithID"] = "未找到技能 %s ID";
L["notValidSpell"] = "未找到技能 ID %s, 这是一个有效的技能吗?";
L["addedCustomScrollingSpell"] = "添加自定义技能: %s %s";
L["removedScrollingCustomSpellID"] = "在自定义技能中删除了 ID %s %s%s ";
L["has died"] = "已经死亡";
L["Threat"] = "仇恨";
L["Drag Me"] = "拉我";
L["Multiple Boss Drop"] = "多个首领掉落";
L["All Players"] = "所有玩家";

--Raid status window column names, make sure they fit in the colum size (left click minimap button to check).
L["Flask"] = "药剂";
L["Food"] = "食物";
L["Scroll"] = "卷轴";
L["Int"] = "智力";
L["Fort"] = "耐力";
L["Spirit"] = "精神";
L["Shadow"] = "暗抗";
L["Motw"] = "野性";
L["Pal"] = "祝福";
L["Durability"] = "耐久";
L["Shadow"] = "暗抗";
L["Fire"] = "火抗";
L["Nature"] = "自抗";
L["Frost"] = "冰抗";
L["Arcane"] = "奥抗";
L["Holy"] = "神圣抗";
L["Weapon"] = "附魔";
L["Talents"] = "天赋";
L["Armor"] = "护甲";

L["Scrolls"] = "卷轴";
L["Racials"] = "种族技能";
L["Interrupts"] = "打断";

L["noWeaponsEquipped"] = "你没有装备武器!";
L["noOffhandEquipped"] = "你没有装备副手武器!";
L["noRangedEquipped"] = "你没有装备远程武器!";

L["attuneWarning"] = "拾取 %s 到任务物品 %s.";
L["The Cudgel of Kar'desh"] = "The Cudgel of Kar'desh";
L["Earthen Signet"] = "土灵徽记";
L["Blazing Signet"] = "灿烂徽记";
L["The Vials of Eternity"] = "The Vials of Eternity";
L["Vashj's Vial Remnant"] = "瓦丝琪的水瓶残余";
L["Kael's Vial Remnant"] = "瓦丝琪的水瓶残余";
L["An Artifact From the Past"] = "An Artifact From the Past";
L["Time-Phased Phylactery"] = "时光护符匣";
L["alarCostumeMissing"] = "Missing Ashtongue Cowl costume for Black Temple attunment, click it now!"

L["Raid Lockouts"] = "副本进度";
L["noCurrentRaidLockouts"] = "目前无副本进度.";
L["noAltLockouts"] = "目前无副本进度(小号).";
L["holdShitForAltLockouts"] = "按住 Shift 显示小号副本进度.";
L["leftClickMinimapButton"] = "点击左键|r 打开团队状态";
L["rightClickMinimapButton"] = "点击右键|r 打开团队记录";
L["shiftLeftClickMinimapButton"] = "Shift+点击左键|r 打开交易记录";
L["shiftRightClickMinimapButton"] = "Shift+点击右键|r 打开设置";

L["Merged"] = "合并";
L["mergedDesc"] = "合并 %s 冷却时间?(如果您想在不需要鼠标悬停的情况下查看玩家的冷却时间，请取消此选项)";
L["Frame"] = "窗口";
L["List"] = "清单";
L["frameDesc"] = "你想在那个窗口显示 %s 冷却时间?";
L["Merge All"] = "合并全部";
L["Unmerge All"] = "分离全部";

L["Rebirth"] = "复生";
L["Innervate"] = "激活";
L["Tranquility"] = "宁静";
L["Misdirection"] = "误导";
L["ToT"] = "ToT"; --Tricks abbreviation.
L["Tricks"] = "嫁祸";
L["Tricks of the Trade"] = "嫁祸诀窍";
L["Evocation"] = "唤醒";
L["IceBlock"] = "寒冰护体";
L["Invisibility"] = "隐形";
L["Divine Intervention"] = "神圣干涉";
L["Divine Shield"] = "圣盾术";
L["Lay on Hands"] = "圣疗术";
L["Blessing of Protection"] = "保护祝福";
L["Fear Ward"] = "防护恐惧结界";
L["Shadowfiend"] = "暗影魔";
L["Psychic Scream"] = "心灵尖啸";
L["Power Infusion"] = "能量灌注";
L["Pain Suppression"] = "痛苦压制";
L["Blind"] = "致盲";
L["Vanish"] = "消失";
L["Evasion"] = "闪避";
L["Distract"] = "扰乱";
L["Earth Elemental"] = "土元素";
L["Reincarnation"] = "复生";
L["Bloodlust"] = "嗜血";
L["Heroism"] = "英勇";
L["Mana Tide"] = "法力之潮";
L["Soulstone"] = "灵魂石";
L["Soulshatter"] = "灵魂碎裂";
L["Death Coil"] = "死亡缠绕";
L["Ritual of Souls"] = "召唤餐桌";
L["Challenging Shout"] = "挑战怒吼";
L["Intimidating Shout"] = "破胆怒吼";
L["Mocking Blow"] = "惩戒痛击";
L["Recklessness"] = "鲁莽诅咒";
L["ShieldWall"] = "盾墙";

--Wrath.
L["Army of the Dead"] = "亡者大军";
L["Icebound Fortitude"] = "冰封之韧";
L["Anti-Magic Zone"] = "反魔法领域";
L["Divine Sacrifice"] = "神圣牺牲";
L["Divine Hymn"] = "神圣赞美诗";
L["Hymn of Hope"] = "希望圣歌";
L["Tricks of the Trade"] = "嫁祸诀窍";
L["Bladestorm"] = "利刃风暴";
L["Shattering Throw"] = "碎裂投掷";
L["Unholy Frenzy"] = "狂乱";

--Options
L["mainTextDesc"] = "注意：这是一个处于早期新的团队插件，计划在我有时间的时候提供更多的团队助手功能。";

L["showRaidCooldownsTitle"] = "启用";
L["showRaidCooldownsDesc"] = "加入团队时，显示团队成员的副本冷却记录(按住Shift可移动)。";

L["showRaidCooldownsInRaidTitle"] = "团队中";
L["showRaidCooldownsInRaidDesc"] = "当在团队副本时显示?";

L["showRaidCooldownsInPartyTitle"] = "队伍中";
L["showRaidCooldownsInPartyDesc"] = "当在一起5人队伍时显示?";

L["showRaidCooldownsInBGTitle"] = "战场中";
L["showRaidCooldownsInBGDesc"] = "当在战场中显示?";

L["ktNoWeaponsWarningTitle"] = "凯尔萨斯武器警告";
L["ktNoWeaponsWarningDesc"] = "如果你在和凯尔萨斯战斗中没有装备武器，在屏幕中间及聊天框内显示警告。";

L["mergeRaidCooldownsTitle"] = "合并副本进度清单";
L["mergeRaidCooldownsDesc"] = "团队冷却列表可以一次显示所有跟踪冷却技能的角色，或者您可以启用此合并列表选项，以便它只显示冷却技能，您必须将鼠标悬停在它们上以显示每个角色的冷却时间。";

L["raidCooldownNumTypeTitle"] = "冷却显示类型";
L["raidCooldownNumTypeDesc"] = "您是否只想显示已准备好多少冷却时间?\n或者你想显示就绪和总数 1/3?"

L["raidCooldownSpellsHeaderDesc"] = "要追踪的职业冷却";

L["raidCooldownsBackdropAlphaTitle"] = "背景透明度";
L["raidCooldownsBackdropAlphaDesc"] = "你喜欢背景多少透明度?";

L["raidCooldownsBorderAlphaTitle"] = "边框透明度";
L["raidCooldownsBorderpAlphaDesc"] = "你喜欢边框多少透明度?";

L["raidCooldownsTextDesc"] = "按住Shift去拖动副本进度窗口。";

L["resetFramesTitle"] = "重置窗口";
L["resetFramesDesc"] = "重置所有窗口到屏幕中间及恢复预设大小。";

L["resetFramesMsg"] = "正在重置所有窗口的位置及大小。";

L["showMobSpawnedTimeTitle"] = "小怪重生时间";
L["showMobSpawnedTimeDesc"] = "显示当你监控一个小怪时，它需要多长时间刷新?(一个新奇的功能，但对于某些事情可能很有趣)";

--Raid cooldowns.
L["raidCooldownRebirthTitle"] = "复生";
L["raidCooldownRebirthDesc"] = "显示团队冷却时间?";

L["raidCooldownInnervateTitle"] = "激活";
L["raidCooldownInnervateDesc"] = "显示团队冷却时间?";

L["raidCooldownTranquilityTitle"] = "宁静";
L["raidCooldownTranquilityDesc"] = "显示团队冷却时间?";

L["raidCooldownMisdirectionTitle"] = "误导";
L["raidCooldownMisdirectionDesc"] = "显示团队冷却时间?";

L["raidCooldownEvocationTitle"] = "唤醒";
L["raidCooldownEvocationDesc"] = "显示团队冷却时间?";

L["raidCooldownIceBlockTitle"] = "寒冰屏障";
L["raidCooldownIceBlockDesc"] = "显示团队冷却时间?";

L["raidCooldownInvisibilityTitle"] = "隐形术";
L["raidCooldownInvisibilityDesc"] = "显示团队冷却时间?";

L["raidCooldownDivineInterventionTitle"] = "神圣干涉";
L["raidCooldownDivineInterventionDesc"] = "显示团队冷却时间?";

L["raidCooldownDivineShieldTitle"] = "圣盾术";
L["raidCooldownDivineShieldDesc"] = "显示团队冷却时间?";

L["raidCooldownLayonHandsTitle"] = "圣疗术";
L["raidCooldownLayonHandsDesc"] = "显示团队冷却时间?";

L["raidCooldownFearWardTitle"] = "防护恐惧结界";
L["raidCooldownFearWardDesc"] = "显示团队冷却时间?";

L["raidCooldownShadowfiendTitle"] = "暗影魔";
L["raidCooldownShadowfiendDesc"] = "显示团队冷却时间?";

L["raidCooldownPsychicScreamTitle"] = "心灵尖啸";
L["raidCooldownPsychicScreamDesc"] = "显示团队冷却时间?";

L["raidCooldownBlindTitle"] = "致盲";
L["raidCooldownBlindDesc"] = "显示团队冷却时间?";

L["raidCooldownVanishTitle"] = "消失";
L["raidCooldownVanishDesc"] = "显示团队冷却时间?";

L["raidCooldownEvasionTitle"] = "闪避";
L["raidCooldownEvasionDesc"] = "显示团队冷却时间?";

L["raidCooldownDistractTitle"] = "扰乱";
L["raidCooldownDistractDesc"] = "显示团队冷却时间?";

L["raidCooldownEarthElementalTitle"] = "土元素";
L["raidCooldownEarthElementalDesc"] = "显示团队冷却时间?";

L["raidCooldownReincarnationTitle"] = "复生";
L["raidCooldownReincarnationDesc"] = "显示团队冷却时间?";

L["raidCooldownHeroismTitle"] = "英勇";
L["raidCooldownHeroismDesc"] = "显示团队冷却时间?";

L["raidCooldownBloodlustTitle"] = "嗜血";
L["raidCooldownBloodlustDesc"] = "显示团队冷却时间?";

L["raidCooldownSoulstoneTitle"] = "灵魂石";
L["raidCooldownSoulstoneDesc"] = "显示团队冷却时间?";

L["raidCooldownSoulshatterTitle"] = "灵魂碎裂";
L["raidCooldownSoulshatterDesc"] = "显示团队冷却时间?";

L["raidCooldownDeathCoilTitle"] = "死亡缠绕";
L["raidCooldownDeathCoilDesc"] = "显示团队冷却时间?";

L["raidCooldownRitualofSoulsTitle"] = "召唤餐桌";
L["raidCooldownRitualofSoulsDesc"] = "显示团队冷却时间?";

L["raidCooldownChallengingShoutTitle"] = "挑战怒吼";
L["raidCooldownChallengingShoutDesc"] = "显示团队冷却时间?";

L["raidCooldownIntimidatingShoutTitle"] = "破胆怒吼";
L["raidCooldownIntimidatingShoutDesc"] = "显示团队冷却时间?";

L["raidCooldownMockingBlowTitle"] = "惩戒痛击";
L["raidCooldownMockingBlowDesc"] = "显示团队冷却时间?";

L["raidCooldownRecklessnessTitle"] = "鲁莽诅咒";
L["raidCooldownRecklessnessDesc"] = "显示团队冷却时间?";

L["raidCooldownShieldWallTitle"] = "盾墙";
L["raidCooldownShieldWallDesc"] = "显示团队冷却时间?";

L["raidCooldownsSoulstonesTitle"] = "已绑定灵魂石";
L["raidCooldownsSoulstonesDesc"] = "显示谁绑定了灵魂石?";

L["raidCooldownNeckBuffsTitle"] = "项链增益";
L["raidCooldownNeckBuffsDesc"] = "显示增益冷却时间?这将显示您队伍中的所有玩家,无论是什么级别。";

L["acidGeyserWarningTitle"] = "Acid geyser warning";
L["acidGeyserWarningDesc"] = "Warn in /say and middle of screen when a Underbog Colossus targets you with Acid Geyser?";

L["minimapButtonTitle"] = "显示小地图按钮";
L["minimapButtonDesc"] = "显示小地图按钮?";

L["raidStatusTextDesc"] = "按住Shift去拖动副本状态窗口。";

L["raidStatusFlaskTitle"] = "药剂";
L["raidStatusFlaskDesc"] = "在状态检查器上显示?";

L["raidStatusFoodTitle"]= "食物";
L["raidStatusFoodDesc"]= "在状态检查器上显示?";

L["raidStatusScrollTitle"]= "卷轴";
L["raidStatusScrollDesc"]= "在状态检查器上显示?";

L["raidStatusIntTitle"]= "智力";
L["raidStatusIntDesc"]= "在状态检查器上显示?";

L["raidStatusFortTitle"]= "耐力";
L["raidStatusFortDesc"]= "在状态检查器上显示?";

L["raidStatusSpiritTitle"]= "精神";
L["raidStatusSpiritDesc"]= "在状态检查器上显示?";

L["raidStatusShadowTitle"]= "暗抗增益";
L["raidStatusShadowDesc"]= "在状态检查器上显示?";

L["raidStatusMotwTitle"]= "野性印记";
L["raidStatusMotwDesc"]= "在状态检查器上显示?";

L["raidStatusPalTitle"]= "祝福";
L["raidStatusPalDesc"]= "在状态检查器上显示?";

L["raidStatusDuraTitle"]= "耐久度";
L["raidStatusDuraDesc"]= "在状态检查器上显示?";

L["raidCooldownNecksHeaderDesc"] = "项链增益冷却追踪";

L["raidCooldownNeckSPTitle"] = "+34 法术能量";
L["raidCooldownNeckSPDesc"] = "Show party members cooldown for |cFF0070DD[Eye of the Night]|r (+34 Spell Power) necklace buff?";

L["raidCooldownNeckCritTitle"] = "+2% 法术暴击";
L["raidCooldownNeckCritDesc"] = "Show party members cooldown for |cFF0070DD[Chain of the Twilight Owl]|r (+2% Crit) necklace buff?";

L["raidCooldownNeckCritRatingTitle"] = "+28 暴击等级";
L["raidCooldownNeckCritRatingDesc"] = "Show party members cooldown for |cFF0070DD[Braided Eternium Chain]|r (+28 Crit Rating) necklace buff?";

L["raidCooldownNeckStamTitle"] = "+20 耐力";
L["raidCooldownNeckStamDesc"] = "Show party members cooldown for |cFF0070DD[Thick Felsteel Necklace]|r (+20 Stam) necklace buff?";

L["raidCooldownNeckHP5Title"] = "+6 5秒回血";
L["raidCooldownNeckHP5Desc"] = "Show party members cooldown for |cFF0070DD[Living Ruby Pendant]|r (+6 Health Per 5) necklace buff?";

L["raidCooldownNeckStatsTitle"] = "+10 属性";
L["raidCooldownNeckStatsDesc"] = "Show party members cooldown for |cFF0070DD[Embrace of the Dawn]|r (+10 Stats) necklace buff?";

L["raidCooldownsNecksRaidOnlyTitle"] = "只在团队追踪项链";
L["raidCooldownsNecksRaidOnlyDesc"] = "仅当您在团队中时显示增益冷却时间,并在队伍时隐藏?";

L["Eating"] = "食用中"; --This can't be longer than 6 characters to fit in the raid status column.
L["Food"] = "食物";

L["raidStatusShowReadyCheckTitle"] = "在团队确认时显示";
L["raidStatusShowReadyCheckDesc"] = "启动就绪检查时自动显示状态框?";

L["raidStatusHideCombatTitle"] = "战斗中隐藏";
L["raidStatusHideCombatDesc"] = "任何战斗开始时自动隐藏团队状态框?";

L["raidStatusColumsHeaderDesc"] = "显示(列)";

L["deleteEntry"] = "删除项";
L["deleteInstance"] = "已删除的副本项 %s (%s).";
L["deleteInstanceError"] = "删除 %s 出错.";

L["logDungeonsTitle"] = "记录地下城";
L["logDungeonsDesc"] = "还记录地下城？如果您只想记录团本，请关闭此功能.";

L["logRaidsTitle"] = "记录团本";
L["logRaidsDesc"] = "记录所有 10/25/40 人团本.";

L["raidStatusShadowResTitle"] = "暗影抗性";
L["raidStatusShadowResDesc"] = "Display a Shadow Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusFireResTitle"] = "火焰抗性";
L["raidStatusFireResDesc"] = "Display a Fire Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusNatureResTitle"] = "自然抗性";
L["raidStatusNatureResDesc"] = "Display a Nature Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusFrostResTitle"] = "冰霜抗性";
L["raidStatusFrostResDesc"] = "Display a Frost Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusArcaneResTitle"] = "奥法抗性";
L["raidStatusArcaneResDesc"] = "Display a Arcane Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusWeaponEnchantsTitle"] = "武器附魔";
L["raidStatusWeaponEnchantsDesc"] = "Display a Weapon Enchants (oils/stones etc) column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusTalentsTitle"] = "天赋";
L["raidStatusTalentsDesc"] = "Display a Talents column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusExpandAlwaysTitle"] = "总是显示更多";
L["raidStatusExpandAlwaysDesc"] = "Do you want to always show more when opening the raid status frame? So you don't need to click the More button.";

L["raidStatusExpandHeaderDesc"] = "更多";
L["raidStatusExpandTextDesc"] = "These are displayed when you click the \"More\" button on the raid status frame. To see raid members extra stats they must have NRC installed or the Nova Raid Companion Addon Helper weakaura at |cFF3CE13Fhttps://wago.io/sof4ehBA6|r";

L["raidStatusExpandTooltip"] = "|cFFFFFF00Click to show more data like spell resistances.|r\n|cFF9CD6DEGroup members without NRC must have the NRC Helper\nweakaura at https://wago.io/sof4ehBA6 to see more data.|r";

L["healthstoneMsgTitle"] = "治疗石信息";
L["healthstoneMsgDesc"] = "Show a msg in /say when you cast healthstones so people help click? This shows what rank you're casting also.";

L["summonMsgTitle"] = "召唤信息";
L["summonMsgDesc"] = "Show a msg in group chat when you start summoning so people help click and so other locks can see who you're summong so as not to summon the same person?";

L["summonStoneMsgTitle"] = "集合石信息";
L["summonStoneMsgDesc"] = "Show a msg in group chat when you use a summoning stone so people help click and so other people in raid can see who you're summong so as not to summon the same person?";

L["duraWarningTitle"] = "耐久度警告";
L["duraWarningDesc"] = "Show a durability warning in the chat window if you enter a raid with low armor durability?";

L["dataOptionsTextDesc"] = "资料合并及记录存储选项"

L["maxRecordsKeptTitle"] = "团队记录资料库大小";
L["maxRecordsKeptDesc"] = "Maximum amount of raids to keep in the database, increasing this to a large number may increase load time when opening the log window.";

L["maxRecordsShownTitle"] = "日志中显示副本记录";
L["maxRecordsShownDesc"] = "副本日志中显示的最大副本数量?如果您只想查看一定数量但仍保存更多数量的数据，则可以将其设置为低于保存的记录。";

L["maxTradesKeptTitle"] = "交易记录资料库大小";
L["maxTradesKeptDesc"] = "Maximum amount of trades to keep in the database, increasing this to a very large number may caus lag when opening the trade log.";

L["maxTradesShownTitle"] = "显示交易记录";
L["maxTradesShownDesc"] = "Maximum amount of trades to show in the trade log? You can set this lower than records kept if you only want to view a certain amount but still keep higher amouns of data.";
L["showMoneyTradedChatTitle"] = "在聊天回复金币交易";
L["showMoneyTradedChatDesc"] = "Show in trade when you give or receive gold from someone in the chat window? (Helps keep tack of who you have paid or received gold from in boost groups). |cFFFF0000WARNING: If you have Nova Instance Tracker installed already displaying trades in chat this won't work so you don't get duplicate msgs.|r";

L["attunementWarningsTitle"] = "任务物品提示";
L["attunementWarningsDesc"] = "在首领死亡后提示拾取任务物品?";

L["sortRaidStatusByGroupsColorTitle"] = "团队着色";
L["sortRaidStatusByGroupsColorDesc"] = "If you enable sort by groups on the raid status window this will colorize them.";

L["sortRaidStatusByGroupsColorBackgroundTitle"] = "团队背景着色";
L["sortRaidStatusByGroupsColorBackgroundDesc"] = "If you enable sort by groups and have colored enabled this will also color the background for the group.";


L["shadowNeckBTWarning"] = "你仍装备着暗抗项链。";

L["pvpTrinketWarning"] = "你装备了PVP饰品。";

L["raidCooldownManaTideTitle"] = "法力之潮";
L["raidCooldownManaTideDesc"] = "显示团队冷却时间?";

L["raidCooldownPainSuppressionTitle"] = "痛苦压制";
L["raidCooldownPainSuppressionDesc"] = "显示团队冷却时间?";

L["raidCooldownPowerInfusionTitle"] = "能量灌注";
L["raidCooldownPowerInfusionDesc"] = "显示团队冷却时间?";

L["raidCooldownBlessingofProtectionTitle"] = "保护祝福";
L["raidCooldownBlessingofProtectionDesc"] = "显示团队冷却时间?";

L["soulstoneMsgSayTitle"] = "灵魂石(说)";
L["soulstoneMsgSayDesc"] = "当你对某人施放灵魂石时，在 /say 通报消息?";

L["soulstoneMsgGroupTitle"] = "灵魂石(团队)";
L["soulstoneMsgGroupDesc"] = "当你对某人施放灵魂石时，在团队中通报消息?";

L["showInspectTalentsTitle"] = "显示天赋"
L["inspectTalentsCheckBoxTooltip"] = "是否在你观察其他人时显示天赋窗口？";

L["cooldownFrameCountTitle"] = "冷却清单";
L["cooldownFrameCountDesc"] = "How many seperate cooldown lists do you want? You can have multiple lists to put in different places and assign different cooldowns to each list. Assign each spell to a list below, click Test to show all you have enabled.";

L["testRaidCooldownsDesc"] = "Test the cooldown frames for 30 seconds so you can configure them or hold shift to drag them. Change any options here while the test runs to see what it looks like.";

L["raidStatusScaleTitle"] = "团队状态窗口大小";
L["raidStatusScaleDesc"] = "Set the raid status window size scale here.";

L["holdShitForExtraInfo"] = "按住Shift显示更多信息";

L["timeStampFormatTitle"] = "时间格式";
L["timeStampFormatDesc"] = "Set which timestamp format to use, 12 hour (1:23pm) or 24 hour (13:23). For things like the 3 day raid reset cycle when you hold shift on the minimap button.";

L["Completed quest"] = "你已经 |cFF00C800完成了|r 这个任务";
L["Not completed quest"] = "你还 |cFFFF2222没有完成|r 这个任务";

L["raidCooldownsGrowthDirectionTitle"] = "增长方向";
L["raidCooldownsGrowthDirectionDesc"] = "Which way do you want the list to grow?"

L["raidCooldownsNumTypeTitle"] = "显示冷却准备就绪";
L["raidCooldownsNumTypeDesc"] = "Do you want to display only how many cooldowns are ready?\nOr do you want to display ready and total like 1/3?"

L["raidCooldownsScaleTitle"] = "大小";
L["raidCooldownsScaleDesc"] = "How big do you want the cooldown list to be?";

L["raidCooldownsBorderTypeTitle"] = "外框样式";
L["raidCooldownsBorderTypeDesc"] = "What type of border do you want around the frames?"

L["raidCooldownsSoulstonesPositionTitle"] = "灵魂石位置";
L["raidCooldownsSoulstonesPositionDesc"] = "Where do you want active soulstones to show?"

L["meTransferedThreatMD"] = "%s 仇恨被误导给 %s."; --These are a little different for different places.
L["otherTransferedThreatMD"] = "%s 误导 %s 仇恨给 %s."; --These are a little different for different places.
L["meTransferedThreatTricks"] = "%s 仇恨转移到 %s."; --These are a little different for different places.
L["otherTransferedThreatTricks"] = "%s 仇恨 %s 转移到 %s."; --These are a little different for different places.

L["meCastSpellOn"] = "施放 %s 在 %s"; --Capitalize these properly if translating.
L["otherCastSpellOn"] = "%s 施放 %s 在 %s"; --Capitalize these properly if translating.
L["spellCastOn"] = "%s 施放在 %s";

L["mdSendMyCastGroupTitle"] = "我误导的队友";
L["mdSendMyCastGroupDesc"] = "Show my misdirection casts in group chat?";

L["mdSendMyCastSayTitle"] = "我施放误导 /说";
L["mdSendMyCastSayDesc"] = "Show my misdirection casts in /say? Only works in instances.";

L["mdSendOtherCastGroupTitle"] = "显示误导的队友";
L["mdSendOtherCastGroupDesc"] = "Show other players misdirection casts in group chat? You should only use this if no other hunters in the raid have an addon showing their MD.";

L["mdSendMyThreatGroupTitle"] = "我误导转移了多少仇恨";
L["mdSendMyThreatGroupDesc"] = "Show how much misdirection threat I transfered to the tank in group chat?";

L["mdSendMyThreatSayTitle"] = "我仇恨到 /说";
L["mdSendMyThreatSayDesc"] = "Show how much misdirection threat I transfered to the tank in /say? Only works in instances.";

L["mdSendOthersThreatGroupTitle"] = "其他人转移仇恨";
L["mdSendOthersThreatGroupDesc"] = "Show how much misdirection threat other players transfered to the tank in group chat? You should only use this if no other hunters in the raid have an addon showing their threat transfer.";

L["mdSendOthersThreatSayTitle"] = "其他仇恨 /说";
L["mdSendOthersThreatSayDesc"] = "Show how much misdirection threat other players transfered to the tank in /say? You should only use this if no other hunters in the raid have an addon showing their threat transfer. Only works in instances.";

L["mdShowMySelfTitle"] = "我的仇恨转移";
L["mdShowMySelfDesc"] = "Show how much misdirection I transfered to the tank in your chat window so only you can see?";

L["mdShowOthersSelfTitle"] = "其他人仇恨转移";
L["mdShowOthersSelfDesc"] = "Show how much misdirection other players transfered to the tank in your chat window so only you can see?";

L["mdShowSpellsTitle"] = "显示使用的技能伤害";
L["mdShowSpellsDesc"] = "Print to your chat window which spells were used during the misdirection? Only you see this msg.";

L["mdShowSpellsOtherTitle"] = "显示使用的伤害技能";
L["mdShowSpellsOtherDesc"] = "Print to your chat window which spells were used by other hunters during the misdirection? Only you see this msg.";
					
L["mdSendTargetTitle"] = "密语目标";
L["mdSendTargetDesc"] = "Send threat amount tranfered from your misdirection to the target via whisper?";

L["mdMyTextDesc"] = "显示你的误导转移给坦克仇恨选项.";
L["mdOtherTextDesc"] = "显示您队伍中的其他猎人误导转移到坦克仇恨的选项。在启用发送到团队聊天并创建重复消息的选项时，请注意.";
L["mdLastTextDesc"] = "There's also a /lastmd command to show group chat the spells used for the last misdirection, you can do /lastmd to show last used, /lastmd <name> to show last by name, and /lastmd list to show who has a md recorded to pick from.";
L["raidCooldownsDisableMouseTitle"] = "禁用鼠标悬停";
L["raidCooldownsDisableMouseDesc"] = "This will disable empty cooldown lists from showing when you mouseover them while they have no cooldowns showing, this means you will need to click the test button to move them instead.";

L["raidCooldownsSortOrderTitle"] = "排序方式";
L["raidCooldownsSortOrderDesc"] = "How would you like the cooldowns bars to be sorted?";																 

L["autoCombatLogTitle"] = "自动开启战斗记录";
L["autoCombatLogDesc"]= "Turn on combat logging whenever you enter a raid so it can used for sites like warcraft logs.";

L["cauldronMsgTitle"] = "施放大锅提示";
L["cauldronMsgDesc"] = "Put a msg in /say when you drop a cauldron in raid?";

L["sreMainTextDesc"] = "滚动到下方来新增自定义技能。"
L["sreCustomSpellsHeaderDesc"] = "自定义追踪技能";

L["sreLineFrameScaleTitle"] = "信息大小";
L["sreLineFrameScaleDesc"] = "How big do you want the text and icons to be?";

L["sreScrollHeightTitle"] = "滚动高度";
L["sreScrollHeightDesc"] = "How far do you want the messages to scroll (Unlock the frames or cick test before setting this so you can see the height).";

L["sreEnabledTitle"] = "启动";
L["sreEnabledDesc"] = "Enable or disable scrolling raid events being shown on your screen.";

L["sreEnabledEverywhereTitle"] = "任何地方";
L["sreEnabledEverywhereDesc"] = "Enabled everywhere including outside of raids (Except Arena/Battlegounrds, they have own config option).";

L["sreEnabledRaidTitle"] = "地下城与团队";
L["sreEnabledRaidDesc"] = "Enabled inside raids and dungeons.";

L["sreEnabledPvPTitle"] = "PvP 区域";
L["sreEnabledPvPDesc"] = "Enabled in battlegrounds and arenas.";

L["sreGroupMembersTitle"] = "团队成员施法";
L["sreGroupMembersDesc"] = "Show group members spells? You can tick the \"All Players Spells\" if you want to see players even not in your group.";

L["sreShowSelfTitle"] = "我的技能";
L["sreShowSelfDesc"] = "Show spells that I cast also.";

L["sreShowSelfRaidOnlyTitle"] = "只在团队中显示我的技能";
L["sreShowSelfRaidOnlyDesc"] = "Show spells that I cast also only when inside raids/dungeons, this is here so you have the module enabled anywhere and not see your own spells out in the open world.";

L["sreAllPlayersTitle"] = "所有玩家的技能";
L["sreAllPlayersDesc"] = "Show players not in your group casting spells in the world? Requires \"Everywhere\" to also be enabled.";

L["sreNpcsTitle"] = "NPC";
L["sreNpcsDesc"] = "Show NPC spells being cast? You can add custom spells below.";

L["sreNpcsRaidOnlyTitle"] = "只在副本中显示NPC技能";
L["sreNpcsRaidOnlyDesc"] = "Show NPC spells being cast on when inside a raids/dungeons.";

L["sreGrowthDirectionTitle"] = "文字滚动方向";
L["sreGrowthDirectionDesc"] = "Which direction do you want the msgs to scroll?";

L["sreAddRaidCooldownsToSpellListTitle"] = "新增团队冷卻";
L["sreAddRaidCooldownsToSpellListDesc"] = "Add all your enabled spells from the Raid Cooldowns tracker?";

L["sreShowCooldownResetTitle"] = "重置冷却倒数";
L["sreShowCooldownResetDesc"] = "If you have the Raid Cooldowns tracker enabled you can also enable this option to show when those cooldowns reset and come off cooldown.";

L["sreShowInterruptsTitle"] = "打断";
L["sreShowInterruptsDesc"] = "Show all interrupts (Intterupts will show no matter the source, overriding Group/Mine/NPCs settings).";

L["sreShowCauldronsTitle"] = "大锅";
L["sreShowCauldronsDesc"] = "Cauldrons being placed on the group for you to pick up potions.";

L["sreShowSoulstoneResTitle"] = "使用灵魂石";
L["sreShowSoulstoneResDesc"] = "Show when a player uses a soulstone to resurrect.";

L["sreShowManaPotionsTitle"] = "法力药水";
L["sreShowManaPotionsDesc"]	= "Show Mana potion usage. Includes Dark Runes and Dreamless Sleep potions.";

L["sreShowHealthPotionsTitle"] = "治疗药水";
L["sreShowHealthPotionsDesc"] = "Show Health potion usage.";

L["sreShowDpsPotionsTitle"] = "暴发及防护药水";
L["sreShowDpsPotionsDesc"] = "Show dps and armor/protection option usage. This includes things like destruction/haste/ironshield/invisibilty potions.";

L["sreShowMagePortalsTitle"] = "法师传送门";
L["sreShowMagePortalsDesc"]	= "Show mage portal casts, be tricked no more by those pesky mages!";

L["sreShowResurrectionsTitle"] = "复活";
L["sreShowResurrectionsDesc"] = "Show players resurrecting others.";

L["sreShowMisdirectionTitle"] = "误导仇恨";
L["sreShowMisdirectionDesc"] = "Show how much threat a hunter misdirect sends to the tank.";

L["sreShowSpellNameTitle"] = "显示技能名称";
L["sreShowSpellNameDesc"] = "Show spell name in the text shown.";

L["sreOnlineStatusTitle"] = "上线/离线 状态";
L["sreOnlineStatusDesc"] = "Show group members coming online and going offline..";

L["sreAlignmentTitle"] = "文字对齐";
L["sreAlignmentDesc"] = "Grow msgs from the left, middle, or right?";

L["sreAnimationSpeedTitle"] = "滚动动画速度";
L["sreAnimationSpeedDesc"] = "How fast do you want the events to scroll by?";

L["sreAddSpellTitle"] = "新增自定义技能 ID";
L["sreAddSpellDesc"] = "Add a custom spell here, input the spell ID for which spell you want to see cast. You can get the spell ID for any spell by searching for it on wowhead and looking at the number in the website URL.";

L["sreRemoveSpellTitle"] = "移除自定义技能 ID";
L["sreRemoveSpellDesc"] = "Remove a custom spell here, input the spell ID to remove here.";

L["You can't delete log entries while inside an instance."] = "您无法删除日志目录.";

L["consumesEncounterTooltip"] = "选择要显示的内容";
L["consumesPlayersTooltip"] = "选择一名成员或者所有成员.";
L["consumesViewTooltip"] = "查看时间轴及总数";

L["itemUseShowConsumesTooltip"] = "显示消耗品";
L["itemUseShowScrollsTooltip"] = "显示卷轴";
L["itemUseShowInterruptsTooltip"] = "显示打断\n(重复的打断图标等级不同)";
L["itemUseShowRacialsTooltip"] = "显示种族";
L["itemUseShowFoodTooltip"] = "显示食物";

L["autoSunwellPortalTitle"] = "太阳之井传送";
L["autoSunwellPortalDesc"] = "Auto take the Sunwell teleport when you talk to NPC, this takes the furtherest portal.";

L["Taking Sunwell teleport."] = "太阳之井自动传送。";

L["lockAllFramesTitle"] = "锁定所有窗口";
L["lockAllFramesDesc"] = "Lock and Unlock all frames so you can move them around (You can also type /nrc lock and /nrc unlock).";

L["testAllFramesTitle"] = "测试所有窗口";
L["testAllFramesDesc"] = "Run a 30 second test on all frames with your current settings.";

L["resetAllFramesTitle"] = "重置所有窗口";
L["resetAllFramesDesc"] = "Reset all frames back to default position.";

L["raidManaMainTextDesc"] = "简易监控团队所有治疗的蓝量。";

L["raidManaEnabledTitle"] = "启用";
L["raidManaEnabledDesc"] = "Enable the raid mana module.";

L["raidManaEnabledEverywhereTitle"] = "所有地方";
L["raidManaEnabledEverywhereDesc"] = "Enabled everywhere including outside of raids (Except Arena/Battlegounrds, they have own config option).";

L["raidManaEnabledRaidTitle"] = "团本/地下城";
L["raidManaEnabledRaidDesc"] = "Enabled inside raids and dungeons.";

L["raidManaEnabledPvPTitle"] = "PvP";
L["raidManaEnabledPvPDesc"] = "Enabled in battlegrounds and arenas.";

L["raidManaAverageTitle"] = "竞技场蓝量";
L["raidManaAverageDesc"] = "Show the average mana of all players shown if more than one player is shown.";

L["raidManaShowSelfTitle"] = "显示我的蓝量";
L["raidManaShowSelfDesc"] = "Show my own mana too if I am a healer or on an enabled class below?";

L["raidManaScaleTitle"] = "窗口大小";
L["raidManaScaleDesc"] = "How big do you want the raid mana frame to be?";

L["raidManaGrowthDirectionTitle"] = "增长方向";
L["raidManaGrowthDirectionDesc"] = "Which direction do you want the list to grow?";

L["raidManaBackdropAlphaTitle"] = "背景透明度";
L["raidManaBackdropAlphaDesc"] = "How transparent do you want the background to be?";

L["raidManaBorderAlphaTitle"] = "边框透明度";
L["raidManaBorderAlphaDesc"] = "How transparent do you want the border to be?";

L["raidManaUpdateIntervalTitle"] = "更新间隔";
L["raidManaUpdateIntervalDesc"] = "How fast do you want the frame to update, every 0.1 to 1 second.";

L["raidManaSortOrderTitle"] = "排序方式";
L["raidManaSortOrderDesc"] = "Pick how you would like to sort the mana display.";

L["raidManaFontTitle"] = "姓名字体";
L["raidManaFontDesc"] = "Font used to display player names. Warning: Fonts have different widths and some fonts may not fit correctly in these small frames trying to fit a lot of info.";

L["raidManaFontNumbersTitle"] = "数字字体";
L["raidManaFontNumbersDesc"] = "Font used to display percentage numbers. Warning: Fonts have different widths and some fonts may not fit correctly in these small frames trying to fit a lot of info.";

L["raidManaResurrectionTitle"] = "显示复活";
L["raidManaResurrectionDesc"] = "Show when a healer is casting resurrect beside their name.";

L["raidManaResurrectionDirTitle"] = "复活方向";
L["raidManaResurrectionDirDesc"] = "Which side of the frame to display resurrections, \"Auto\" means it will show right or left depending on what side of your UI you have the frame on.";

L["raidManaHealersTitle"] = "显示所有治疗";
L["raidManaHealersDesc"] = "Show mana for all healers in this raid, this uses NRC talent detection to find real healers for accuracy. You may need to be in range of a player at least once during a raid so their talents can be detected for them to show as a healer.";

L["raidManaDruidDesc"] = "显示团队所有德鲁伊的蓝量?";
L["raidManaHunterDesc"] = "显示团队所有猎人的蓝量?";
L["raidManaMageDesc"] = "显示团队所有法师的蓝量?";
L["raidManaPaladinDesc"] = "显示团队所有圣骑士的蓝量?";
L["Start Frames Test"] = "窗口测试";
L["Stop Frames Test"] = "停住窗口测试";
L["raidManaPriestDesc"] = "显示团队所有牧師的蓝量?";
L["raidManaShamanDesc"] = "显示团队所有萨满的蓝量?";
L["raidManaWarlockDesc"] = "显示团队所有术士的蓝量?";

L["raidCooldownsFontTitle"] = "姓名字体";
L["raidCooldownsFontDesc"] = "Font used to display player/cooldown names. Warning: Fonts have different widths and some fonts may not fit correctly in these small frames trying to fit a lot of info.";

L["raidCooldownsFontNumbersTitle"] = "数字字体";
L["raidCooldownsFontNumbersDesc"] = "Font used to display cooldowns ready numbers. Warning: Fonts have different widths and some fonts may not fit correctly in these small frames trying to fit a lot of info.";

L["checkMetaGemTitle"] = "检查宝石";
L["checkMetaGemDesc"] = "如果你的宝石沒有启用，出现警告信息?";

L["raidCooldownsFontSizeTitle"] = "字体大小";
L["raidCooldownsFontSizeDesc"] = "How big do you want the font to be?";

L["raidCooldownsWidthTitle"] = "宽度";
L["raidCooldownsWidthDesc"] = "How wide do you want each bar to be?";

L["raidCooldownsHeightTitle"] = "高度";
L["raidCooldownsHeightDesc"] = "How high do you want each bar to be?";

L["raidManaFontSizeTitle"] = "字体大小";
L["raidManaFontSizeDesc"] = "How big do you want the font to be?";

L["raidManaWidthTitle"] = "宽度";
L["raidManaWidthDesc"] = "How wide do you want each bar to be?";

L["raidManaHeightTitle"] = "高度";
L["raidManaHeightDesc"] = "How high do you want each bar to be?";

L["raidCooldownsFontOutlineTitle"] = "字体轮廓";
L["raidCooldownsFontOutlineDesc"] = "Do you want raid cooldowns font to have an outline?";

L["sreFontOutlineTitle"] = "字体轮廓";
L["sreFontOutlineDesc"] = "Do you want scrolling events font to have an outline?";

L["raidManaFontOutlineTitle"] = "字体轮廓";
L["raidManaFontOutlineDesc"] = "Do you want raid mana font to have an outline?";

L["Thick Outline"] = "粗轮廓";
L["Thin Outline"] = "细轮廓";

L["sreFontTitle"] = "字体";

L["raidStatusFontTitle"] = "字体";
L["raidStatusFontSizeTitle"] = "字体大小";

L["raidStatusFadeReadyCheckTitle"] = "完成检查就绪后隐藏";
L["raidStatusFadeReadyCheckDesc"] = "如果每个人都准备好了，在就绪检查完成几秒钟后淡出团队状态框？";

L["tricksSendMyCastGroupTitle"] = "副本中嫁祸目标";
L["tricksSendMyCastGroupDesc"] = "Show my tricks casts in group chat?";

L["tricksSendMyCastSayTitle"] = "副本中嫁祸到 /说";
L["tricksSendMyCastSayDesc"] = "Show my tricks of the trade casts in /say? Only works in instances.";

L["tricksSendOtherCastGroupTitle"] = "其他队友嫁祸";
L["tricksSendOtherCastGroupDesc"] = "Show other players tricks casts in group chat? You should only use this if no other rogues in the raid have an addon showing their tricks.";

L["tricksSendMyThreatGroupTitle"] = "我嫁祸到目标";
L["tricksSendMyThreatGroupDesc"] = "Show how much misdirection threat I transfered to the tank in group chat?";

L["tricksSendMyThreatSayTitle"] = "我嫁祸到 /说";
L["tricksSendMyThreatSayDesc"] = "Show how much misdirection threat I transfered to the tank in /say? Only works in instances.";

L["tricksSendOthersThreatGroupTitle"] = "队伍中的嫁祸";
L["tricksSendOthersThreatGroupDesc"] = "Show how much tricks threat other rogues transfered in group chat?";

L["tricksSendOthersThreatSayTitle"] = "其他嫁祸到 /说";
L["tricksSendOthersThreatSayDesc"] = "Show how much tricks threat other players transfered in /say?";

L["tricksShowMySelfTitle"] = "显示我的嫁祸转移";
L["tricksShowMySelfDesc"] = "Show how much threat I transfered in your chat window so only you can see?";

L["tricksShowOthersSelfTitle"] = "其他的嫁祸转移";
L["tricksShowOthersSelfDesc"] = "Show how much tricks other rogues transfered to the tank in your chat window so only you can see?";

L["tricksShowSpellsTitle"] = "显示使用的伤害技能";
L["tricksShowSpellsDesc"] = "Print to your chat window which spells were used during the tricks? Only you see this msg, it may be a bit spammy.";

L["tricksShowSpellsOtherTitle"] = "显示其他人的伤害技能";
L["tricksShowSpellsOtherDesc"] = "Print to your chat window which spells were used by other rogues during their tricks? Only you see this msg, it may be a bit spammy.";
		
L["tricksSendTargetTitle"] = "密语嫁祸目标";
L["tricksSendTargetDesc"] = "Send threat amount transfered from your threat to the target via whisper?";

L["tricksMyTextDesc"] = "显示你的嫁祸转移了多少仇恨";
L["tricksOtherTextDesc"] = "显示你队伍内其他人嫁祸转移了多少仇恨";
L["tricksLastTextDesc"] = "There's also a /lasttricks command to show group chat the spells used for the last tricks, you can do /lasttricks to show last used, /lasttricks <name> to show last by name, and /lasttricks list to show who has a tricks recorded to pick from.";
L["tricksDamageTextDesc"] = "显示你的技能对你提高 15% 增益后造成多少额外伤害.";

L["tricksSendDamageGroupTitle"] = "我增加了多少伤害";
L["tricksSendDamageGroupDesc"] = "Show group chat how much extra damage your tricks target did with your buff.";

L["tricksSendDamageGroupOtherTitle"] = "其他人增加了多少伤害";
L["tricksSendDamageGroupOtherDesc"] = "Show group chat how much extra damage other rogues tricks did with their buff.";

L["tricksSendDamageWhisperTitle"] = "对密语目标造成了多少伤害";
L["tricksSendDamageWhisperDesc"] = "Whisper to your tricks target how much extra damage they did with your buff.";

L["tricksSendDamagePrintTitle"] = "你的伤害";
L["tricksSendDamagePrintDesc"] = "Print to chat window the extra damage your tricks target did with your buff.";

L["tricksSendDamagePrintOtherTitle"] = "其他人的伤害";
L["tricksSendDamagePrintOtherDesc"] = "Print to chat window the extra damage other rogues tricks did with their buff to anyone in the raid.";

L["tricksOtherRoguesMineGainedTitle"] = "我的队伍提供给我的增益获得了多少额外伤害";
L["tricksOtherRoguesMineGainedDesc"] = "If a rogue casts tricks on me then print how much damage I gained? Works for all classes.";

L["tricksOnlyWhenDamageTitle"] = "伤害显示 > 0";
L["tricksOnlyWhenDamageDesc"] = "仅在伤害大于0时显示 ";

L["otherTransferedDamageMyTricks"] = "%s 在我嫁祸期间获得了 %s 额外伤害.";
L["otherTransferedDamageOtherTricks"] = "%s 从 %s 获得了 %s 额外伤害.";
L["meTransferedThreatTricksWhisper"] = "你在我的嫁祸期间获得了 %s 额外伤害";
L["otherTransferedDamageTricksMine"] = "你从 %s 嫁祸期间获得了 %s 额外伤害";
