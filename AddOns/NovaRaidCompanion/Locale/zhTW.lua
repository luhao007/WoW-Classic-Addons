--Big thanks to VJ KOKUSHO for translating the TW version of this addon.

local L = LibStub("AceLocale-3.0"):NewLocale("NovaRaidCompanion", "zhTW");
if (not L) then
	return;
end

L["second"] = "秒"; --Second (singular).
L["seconds"] = "秒"; --Seconds (plural).
L["minute"] = "分"; --Minute (singular).
L["minutes"] = "分"; --Minutes (plural).
L["hour"] = "小時"; --Hour (singular).
L["hours"] = "小時"; --Hours (plural).
L["day"] = "天"; --Day (singular).
L["days"] = "天"; --Days (plural).
L["secondMedium"] = "秒"; --Second (singular).
L["secondsMedium"] = "秒"; --Seconds (plural).
L["minuteMedium"] = "分"; --Minute (singular).
L["minutesMedium"] = "分"; --Minutes (plural).
L["hourMedium"] = "小時"; --Hour (singular).
L["hoursMedium"] = "小時"; --Hours (plural).
L["dayMedium"] = "天"; --Day (singular).L["days"] = "天"; --Days (plural).
L["daysMedium"] = "天"; --Days (plural).
L["secondShort"] = "秒"; --Used in short timers like 1m30s (single letter only, usually the first letter of seconds).
L["minuteShort"] = "分"; --Used in short timers like 1m30s (single letter only, usually the first letter of minutes).
L["hourShort"] = "小時"; --Used in short timers like 1h30m (single letter only, usually the first letter of hours).
L["dayShort"] = "天"; --Used in short timers like 1d8h (single letter only, usually the first letter of days).
L["startsIn"] = "在 %s 後開始"; --"Starts in 1hour".
L["endsIn"] = "在 %s 後結束"; --"Ends in 1hour".
L["versionOutOfDate"] = "你的<NRC團隊夥伴>插件已經過期了，請上https://www.curseforge.com/wow/addons/nova-raid-companion 更新，或通過twitch客戶端更新。";
L["Options"] = " 設定";
L["None"] = "無";
L["Layout"] = "佈局";
L["Spells"] = "法術";
L["Drink"] = "喝水";
L["Food"] = "進食";
L["Refreshment"] = "使用餐點";

L["None found"] = "未找到";
L["Reputation"] = "聲望";
L["logEntryTooltip"] = "左鍵觀看記錄 %s.\n右鍵重新命名";
L["logEntryFrameTitle"] = "重新命名記錄 %s";
L["renamedLogEntry"] = "重新命名記錄 %s 為 %s";
L["clearedLogEntryName"] = "清除記錄 %s";
L["tradeFilterTooltip"] = "|cFFFFFF00Enter any of the following:|r\n|cFF9CD6DEYour character name.\nOther player name or item name.\nGold amount.";
L["deleteInstanceConfirm"] = "從副本記錄刪除 %s 事件？"
L["noRaidsRecordedYet"] = "還沒有任何出團記錄，請等等回來確認。";
L["Boss Journal"] = "首領日誌";
L["Config"] = "設定";
L["Lockouts"] = "進度";
L["Trades"] = "交易";
L["All Trades"] = "所有交易";
L["tradesForSingleRaid"] = "Trades during %s raid (Log %s)";
L["Set"] = "設定";
L["Reset"] = "重置";
L["Clear"] = "清理";
L["Filter"] = "過濾";
L["Groups"] = "團隊";
L["sortByGroupsTooltip"] = "依團隊排序？";
L["Gave"] = "給予";
L["Received"] = "獲得";
L["to"] = "給";
L["from"] = "從";
L["for"] = "for";
L["with"] = "with";
L["on"] = "on";
L["at"] = "at";
L["Enchant"] = "附魔";
L["Enchanted"] = "附魔";
L["Gold"] = "金";
L["gold"] = "金";
L["silver"] = "銀";
L["copper"] = "銅";
L["Warning"] = "警告";
L["Reminder"] = "提醒";
L["Item"] = "物品";
L["Items"] = "物品";
L["Less"] = "簡易";
L["More"] = "詳細";
L["Raid Log"] = "出團紀錄";
L["Deaths"] = "死亡";
L["Total Deaths"] = "總死亡數";
L["Boss"] = "首領";
L["Bosses"] = "首領";
L["On Bosses"] = "首領死亡";
L["On Trash"] = "小怪死亡";
L["Loot Count"] = "拾取數量";
L["Total Loot"] = "總拾取";
L["Trash"] = "小怪";
L["Loot"] = "拾取";
L["3D Model"] = "3D 模型";
L["Buff Snapshot"] = "增益快照";
L["Raid"] = "出團";
L["Consumes"] = "消耗品";
L["Raid"] = "出團";
L["Start of first boss to end of last boss"] = "從第一個首領到最後一個首領";
L["From first trash kill"] = "從擊殺第一個小怪開始";
L["Inside"] = "Inside";
L["Mobs"] = "怪物數";
L["Wipe"] = "失敗";
L["Wiped"] = "失敗";
L["Wipes"] = "擊殺失敗";
L["Kill"] = "擊殺";
L["No encounters recorded."] = "沒有記錄。";
L["Entered"] = "進本時間";
L["Left"] = "離開";
L["First trash"] = "第一個小怪";
L["Still inside"] = "仍在副本裡";
L["Duration"] = "當";
L["Time spent in combat"] = "戰鬥時長";
L["Kills"] = "擊殺";
L["Total"] = "總共";
L["During Bosses"] = "在首領戰";
L["During Trash"] = "在小怪戰";
L["Other NPCs"] = "其他NPC";
L["hit"] = "hit"; --Illidan Stormrage Aura of Dread hit You 1000 Shadow. 
L["Talent Snapshot for"] = "天賦快照";
L["No talents found"] = "沒有找到天賦";
L["Click to view talents"] = "點擊以觀看天賦";
L["traded with"] = "與交易";
L["No trades matching current filter"] = "沒有交易符合目前過濾器";
L["No trades recorded yet"] = "還沒有任何交易紀錄";
L["Boss model not found"] = "未找到首領模式";
L["Class"] = "職業";
L["Health"] = "Health";
L["Type"] = "種類";
L["Raid Lockouts This Char"] = "此角色副本進度";
L["Raid Lockouts (Including Alts)"] = "副本進度 (包括分身)";
L["Your durability is at"] = "你的耐久度達到";
L["Summoning"] = "正在招喚"; --Summoning player to location, click!
L["click!"] = "請點門!";	--Summoning player to location, click!
L["Healthstones"] = "治療石";
L["Ready"] = "準備好";
L["Target Spawn Time Frame"] = "Target Spawn Time Frame";
L["Spawned"] = "Spawned";
L["Hold Shift To Drag"] = "按住Shift可拖曳移動";
L["Cast on"] = "Cast on"; --Spell cast on player.
L["Current active soulstones"] = "目前綁定的靈魂石";
L["left"] = "剩餘"; --As in time left.
L["Cast by"] = "施法者為";
L["NRC Raid Cooldowns Frame"] = "NRC團隊冷卻視窗";
L["Soulstone"] = "靈魂石";
L["cast on"] = "施放在";
L["Bottom"] = "下";
L["Top"] = "上";
L["Start Test Cooldowns"] = "開始冷卻測試";
L["Stop Test"] = "停止測試";
L["Crits"] = "爆擊"; --Used to show plural of critical hits in aoe etc like (5 Crits).

L["came online"] = "上線";
L["went offline"] = "離線";
L["has reincarnated"] = "已投胎";
L["Interrupt"] = "打斷";
L["Total"] = "總和";
L["All Bosses and Trash"] = "所有首領及小怪";
L["Item Use"] = "物品使用";
L["Item Usage"] = "項目使用";
L["Usage"] = "使用";
L["Last Boss Encounter"] = "最近一場首領戰鬥";
L["Count View"] = "數量檢視";
L["Timeline View"] = "時間軸檢視";
L["Events Shown"] = "事件顯示";
L["Players Shown"] = "玩家顯示";
L["Custom Spells"] = "自訂法術";
L["inputValidSpellID"] = "請輸入有效的法術ID號碼俾以便於捲軸團隊活動。";
L["inputLowerSpellIDRemove"] = "請輸入有效的法術ID號碼以進行移除。";
L["inputLowerSpellID"] = "請輸入較低有效的法術ID。";
L["spellIDAlreadyCustomSpell"] = "法術ID %s 已經是自定義法術。";
L["spellIDNotCustomSpell"] = "沒有找到自定義法術的ID %s。";
L["noSpellFoundWithID"] = "沒有找到ID %s 的法術";
L["notValidSpell"] = "找不到法術ID %s，這是有效的法術嗎?";
L["addedCustomScrollingSpell"] = "增加了自定義捲軸法術：%s %s";
L["removedScrollingCustomSpellID"] = "移除自定義捲軸法術的ID%s %s%s。";
L["has died"] = "has died";
L["Threat"] = "仇恨";
L["Drag Me"] = "Drag Me";
L["Multiple Boss Drop"] = "Multiple Boss Drop";
L["All Players"] = "所有玩家";

--Raid status window column names, make sure they fit in the colum size (left click minimap button to check).
L["Flask"] = "藥劑";
L["Food"] = "食物";
L["Scroll"] = "卷軸";
L["Int"] = "智力";
L["Fort"] = "耐力";
L["Spirit"] = "精神";
L["Shadow"] = "暗影";
L["Motw"] = "爪子";
L["Pal"] = "祝福";
L["Durability"] = "耐久度";
L["Shadow"] = "暗抗";
L["Fire"] = "火炕";
L["Nature"] = "自抗";
L["Frost"] = "冰抗";
L["Arcane"] = "秘抗";
L["Holy"] = "神聖抗";
L["Weapon"] = "武器附魔";
L["Talents"] = "天賦";
L["Armor"] = "護甲";

L["Scrolls"] = "卷軸";
L["Racials"] = "種族技能";
L["Interrupts"] = "打斷";

L["noWeaponsEquipped"] = "你沒有裝備武器！";
L["noOffhandEquipped"] = "你沒有裝備副手武器！";
L["noRangedEquipped"] = "你沒有裝備遠程武器！";

L["attuneWarning"] = "拾取 %s 任務物品 %s。";
L["The Cudgel of Kar'desh"] = "卡德加的狼牙棒";
L["Earthen Signet"] = "大地之印";
L["Blazing Signet"] = "烈焰之印";
L["The Vials of Eternity"] = "永恆之藥劑瓶";
L["Vashj's Vial Remnant"] = "瓦斯琪之瓶殘骸";
L["Kael's Vial Remnant"] = "凱爾之瓶殘骸";
L["An Artifact From the Past"] = "過去的文物";
L["Time-Phased Phylactery"] = "時間相位護身符";
L["alarCostumeMissing"] = "缺少黑廟聲望的艾薩拉斗帽，現在就點擊吧！";
L["attuneWarningSeerOlum"] = "前往先知奧魯姆處取得黑廟聲望任務！";

L["Raid Lockouts"] = "副本進度";
L["noCurrentRaidLockouts"] = "目前沒有任何副本進度。";
L["noAltLockouts"] = "沒有找到分身副本進度。";
L["holdShitForAltLockouts"] = "按住Shift顯示分身副本進度。";
L["leftClickMinimapButton"] = "點擊左鍵|r 打開團隊狀態";
L["rightClickMinimapButton"] = "點擊右鍵|r 打開出團紀錄";
L["shiftLeftClickMinimapButton"] = "Shift+點擊左鍵|r 打開交易紀錄";
L["shiftRightClickMinimapButton"] = "Shift+點擊右鍵|r 打開設置";
L["controlLeftClickMinimapButton"] = "Ctrl+點擊左鍵|r 打開拾取紀錄";
L["Merged"] = "合併";
L["mergedDesc"] = "合併 %s 冷卻時間? (取消打勾如果你想看到玩家的冷卻時間而不需要滑鼠懸停)";
L["Frame"] = "視窗";
L["List"] = "清單";
L["frameDesc"] = "你想在哪個視窗顯示 %s 冷卻時間？";
L["Merge All"] = "合併全部";
L["Unmerge All"] = "分離全部";

L["Rebirth"] = "復生";
L["Innervate"] = "啟動";
L["Tranquility"] = "寧靜";
L["Misdirection"] = "誤導";
L["ToT"] = "ToT"; --Tricks abbreviation.
L["Tricks"] = "偷天";
L["Tricks of the Trade"] = "偷天換日";
L["Evocation"] = "喚醒";
L["IceBlock"] = "寒冰護體";
L["Invisibility"] = "隱形";
L["Divine Intervention"] = "神聖干涉";
L["Divine Shield"] = "聖盾術";
L["Divine Protection"] = "聖佑術";
L["Hand of Sacrifice"] = "犧牲聖禦";
L["Lay on Hands"] = "聖療術";
L["Blessing of Protection"] = "保護祝福";
L["Hand of Protection"] = "保護之手"; --
L["Fear Ward"] = "防護恐懼結界";							 
L["Shadowfiend"] = "暗影惡魔";
L["Psychic Scream"] = "心靈尖嘯";
L["Power Infusion"] = "能量注入";
L["Pain Suppression"] = "痛苦鎮壓";
L["Blind"] = "致盲";
L["Vanish"] = "消失";
L["Evasion"] = "閃避";
L["Distract"] = "擾亂";
L["Earth Elemental"] = "土元素";
L["Reincarnation"] = "復生";
L["Bloodlust"] = "嗜血術";
L["Heroism"] = "英勇";
L["Mana Tide"] = "法力之潮";
L["Soulstone"] = "靈魂石";
L["Soulshatter"] = "靈魂粉碎";
L["Death Coil"] = "死亡纏繞";
L["Ritual of Souls"] = "招喚餐桌";
L["Challenging Shout"] = "挑戰怒吼";
L["Intimidating Shout"] = "破膽怒吼";
L["Mocking Blow"] = "懲戒痛擊";
L["Recklessness"] = "魯莽詛咒";
L["Shield Wall"] = "盾牆";
--Wrath.
L["Army of the Dead"] = "亡靈大軍";
L["Icebound Fortitude"] = "冰錮堅韌";
L["Anti-Magic Zone"] = "反魔法力場";
L["Divine Sacrifice"] = "神性犧牲";
L["Divine Hymn"] = "神聖禮頌";
L["Hymn of Hope"] = "希望禮頌";
L["Tricks of the Trade"] = "偷天換日";
L["Bladestorm"] = "劍刃風暴";
L["Shattering Throw"] = "碎甲投擲";
L["Unholy Frenzy"] = "邪惡狂熱";
L["Vampiric Blood"] = "血族之裔";
L["Divine Guardian"] = "神性守護";
L["Hand of Salvation"] = "拯救聖禦";
L["Survival Instincts"] = "求生本能";
L["Anti-Magic Shell"] = "反魔法護罩";

--Options
L["mainTextDesc"] = "注意：這是一個處於早期階段的新插件，計劃在我有時間的時候提供更多的團隊助手功能。";

L["showRaidCooldownsTitle"] = "啟用";
L["showRaidCooldownsDesc"] = "加入團隊時，顯示團隊成員的副本冷卻紀錄（按住 shift 拖動窗口）。";

L["showRaidCooldownsInRaidTitle"] = "團隊中";
L["showRaidCooldownsInRaidDesc"] = "當在一個團本隊伍時顯示?";

L["showRaidCooldownsInPartyTitle"] = "隊伍中";
L["showRaidCooldownsInPartyDesc"] = "當在一起的5人小隊時顯示?";

L["showRaidCooldownsInBGTitle"] = "戰場中";
L["showRaidCooldownsInBGDesc"] = "當在戰場時顯示?";

L["ktNoWeaponsWarningTitle"] = "凱爾薩斯無武器警告";
L["ktNoWeaponsWarningDesc"] = "如果你在跟凱爾薩斯開戰時沒有裝備武器，在螢幕中間及聊天視窗顯示一個警告。";

L["mergeRaidCooldownsTitle"] = "合併團隊冷卻清單";
L["mergeRaidCooldownsDesc"] = "團隊冷卻清單可以同時顯示所有追蹤冷卻時間的角色，或者你可以啟用這個合併清單選項，這樣它只會顯示冷卻法術名稱，然後你必須將滑鼠游標移到上面才能顯示每一位角色的冷卻時間。";

L["raidCooldownNumTypeTitle"] = "冷卻時間結束顯示類型";
L["raidCooldownNumTypeDesc"] = "你想要只顯示多少冷卻時間可以冷卻？\n或者你想顯示已準備就緒和總數，像是 1/3?";

L["raidCooldownSpellsHeaderDesc"] = "要追蹤的職業冷卻時間";

L["raidCooldownsBackdropAlphaTitle"] = "背景透明度";
L["raidCooldownsBackdropAlphaDesc"] = "你希望背景有多透明?";

L["raidCooldownsBorderAlphaTitle"] = "邊框透明度";
L["raidCooldownsBorderpAlphaDesc"] = "你希望邊框有多透明?";

L["raidCooldownsTextDesc"] = "按住Shift去拖動副本進度視窗。";

L["resetFramesTitle"] = "重置視窗";
L["resetFramesDesc"] = "重置所有視窗到螢幕中間及恢復預設大小。";

L["resetFramesMsg"] = "正在重置所有視窗的位置及大小。";

L["showMobSpawnedTimeTitle"] = "小怪重生時間";
L["showMobSpawnedTimeDesc"] = "將滑鼠游標移至目標時顯示上次重生時間？ (較新穎的功能，但對某些情況很有趣)";

--Raid cooldowns.
L["raidCooldownsMainTextDesc"] = "向下滾動。";

L["raidCooldownRebirthTitle"] = "復生";
L["raidCooldownRebirthDesc"] = "顯示復生團隊冷卻時間？";

L["raidCooldownInnervateTitle"] = "啟動";
L["raidCooldownInnervateDesc"] = "顯示啟動團隊冷卻時間？";

L["raidCooldownTranquilityTitle"] = "寧靜";
L["raidCooldownTranquilityDesc"] = "顯示寧靜團隊冷卻時間？";

L["raidCooldownBarkskinTitle"] = "樹皮術";
L["raidCooldownBarkskinDesc"] = "顯示樹皮術團隊冷卻時間？";

L["raidCooldownMisdirectionTitle"] = "誤導";
L["raidCooldownMisdirectionDesc"] = "顯示誤導團隊冷卻時間？";

L["raidCooldownEvocationTitle"] = "喚醒";
L["raidCooldownEvocationDesc"] = "顯示喚醒團隊冷卻時間？";

L["raidCooldownIceBlockTitle"] = "寒冰屏障";
L["raidCooldownIceBlockDesc"] = "顯示寒冰屏障團隊冷卻時間？";

L["raidCooldownInvisibilityTitle"] = "隱形術";
L["raidCooldownInvisibilityDesc"] = "顯示隱形術團隊冷卻時間？";

L["raidCooldownDivineInterventionTitle"] = "神聖干涉";
L["raidCooldownDivineInterventionDesc"] = "顯示神聖干涉團隊冷卻時間？";

L["raidCooldownDivineShieldTitle"] = "聖盾術";
L["raidCooldownDivineShieldDesc"] = "顯示聖盾術團隊冷卻時間？";

L["raidCooldownLayonHandsTitle"] = "聖療術";
L["raidCooldownLayonHandsDesc"] = "顯示聖療術團隊冷卻時間？";

L["raidCooldownFearWardTitle"] = "防護恐懼結界";
L["raidCooldownFearWardDesc"] = "顯示防護恐懼結界團隊冷卻時間？";

L["raidCooldownShadowfiendTitle"] = "暗影惡魔";
L["raidCooldownShadowfiendDesc"] = "顯示暗影惡魔團隊冷卻時間？";

L["raidCooldownPsychicScreamTitle"] = "心靈尖嘯";
L["raidCooldownPsychicScreamDesc"] = "顯示心靈尖嘯團隊冷卻時間？";

L["raidCooldownBlindTitle"] = "致盲";
L["raidCooldownBlindDesc"] = "顯示致盲團隊冷卻時間？";

L["raidCooldownVanishTitle"] = "消失";
L["raidCooldownVanishDesc"] = "顯示消失團隊冷卻時間？";

L["raidCooldownEvasionTitle"] = "閃避";
L["raidCooldownEvasionDesc"] = "顯示閃避團隊冷卻時間？";

L["raidCooldownDistractTitle"] = "擾亂";
L["raidCooldownDistractDesc"] = "顯示擾亂團隊冷卻時間？";

L["raidCooldownEarthElementalTitle"] = "土元素";
L["raidCooldownEarthElementalDesc"] = "顯示土元素圖騰團隊冷卻時間？";

L["raidCooldownReincarnationTitle"] = "復生";
L["raidCooldownReincarnationDesc"] = "顯示復生團隊冷卻時間？";

L["raidCooldownHeroismTitle"] = "英勇";
L["raidCooldownHeroismDesc"] = "顯示英勇團隊冷卻時間？";

L["raidCooldownBloodlustTitle"] = "嗜血術";
L["raidCooldownBloodlustDesc"] = "顯示嗜血術團隊冷卻時間？";

L["raidCooldownSoulstoneTitle"] = "靈魂石";
L["raidCooldownSoulstoneDesc"] = "顯示靈魂石團隊冷卻時間？";

L["raidCooldownSoulshatterTitle"] = "靈魂粉碎";
L["raidCooldownSoulshatterDesc"] = "顯示靈魂粉碎團隊冷卻時間？";

L["raidCooldownDeathCoilTitle"] = "死亡纏繞";
L["raidCooldownDeathCoilDesc"] = "顯示死亡纏繞團隊冷卻時間？";

L["raidCooldownRitualofSoulsTitle"] = "招喚餐桌";
L["raidCooldownRitualofSoulsDesc"] = "顯示招喚餐桌團隊冷卻時間？";

L["raidCooldownChallengingShoutTitle"] = "挑戰怒吼";
L["raidCooldownChallengingShoutDesc"] = "顯示挑戰怒吼團隊冷卻時間？";

L["raidCooldownIntimidatingShoutTitle"] = "破膽怒吼";
L["raidCooldownIntimidatingShoutDesc"] = "顯示破膽怒吼團隊冷卻時間？";

L["raidCooldownMockingBlowTitle"] = "懲戒痛擊";
L["raidCooldownMockingBlowDesc"] = "顯示懲戒痛擊團隊冷卻時間？";

L["raidCooldownRecklessnessTitle"] = "魯莽詛咒";
L["raidCooldownRecklessnessDesc"] = "顯示魯莽詛咒團隊冷卻時間？";

L["raidCooldownShieldWallTitle"] = "盾牆";
L["raidCooldownShieldWallDesc"] = "顯示盾牆團隊冷卻時間？";

L["raidCooldownLastStandTitle"] = "破釜沉舟";
L["raidCooldownLastStandDesc"] = "顯示破釜沉舟團隊冷卻時間？";

L["raidCooldownsSoulstonesTitle"] = "已綁定靈魂石";
L["raidCooldownsSoulstonesDesc"] = "顯示額外框架以顯示誰身上有靈魂石？";

L["raidCooldownNeckBuffsTitle"] = "項鍊增益";
L["raidCooldownNeckBuffsDesc"] = "顯示珠寶製作項鍊增益冷卻時間？這會顯示你的隊伍中的所有玩家，無論職業如何。";

L["acidGeyserWarningTitle"] = "酸液噴泉警告";
L["acidGeyserWarningDesc"] = "當 Underbog Colossus 用酸液噴泉攻擊你的時候，在 /say 和螢幕中央警告？";

L["minimapButtonTitle"] = "顯示小地圖按鈕";
L["minimapButtonDesc"] = "在小地圖上顯示NRC按鈕？";

L["raidStatusTextDesc"] = "按住Shift去拖動副本狀態視窗。";

L["raidStatusFlaskTitle"] = "藥劑";
L["raidStatusFlaskDesc"] = "在副本狀態追蹤器上顯示藥劑欄位？";

L["raidStatusFoodTitle"]= "食物";
L["raidStatusFoodDesc"]= "在副本狀態追蹤器上顯示食物欄位？";

L["raidStatusScrollTitle"]= "卷軸";
L["raidStatusScrollDesc"]= "在副本狀態追蹤器上顯示卷軸欄位？";

L["raidStatusIntTitle"]= "智力";
L["raidStatusIntDesc"]= "在副本狀態追蹤器上顯示奧術智力欄位？";

L["raidStatusFortTitle"]= "耐力";
L["raidStatusFortDesc"]= "在副本狀態追蹤器上顯示力量之詞：堅韌欄位？";

L["raidStatusSpiritTitle"]= "精神";
L["raidStatusSpiritDesc"]= "在副本狀態追蹤器上顯示祈禱精神欄位？";

L["raidStatusShadowTitle"]= "暗抗增益";
L["raidStatusShadowDesc"]= "在副本狀態追蹤器上顯示暗影保護祭司增益欄位？";

L["raidStatusMotwTitle"]= "爪子";
L["raidStatusMotwDesc"]= "在副本狀態追蹤器上顯示野性印記欄位？";

L["raidStatusPalTitle"]= "祝福";
L["raidStatusPalDesc"]= "在副本狀態追蹤器上顯示聖騎士祝福欄位？";

L["raidStatusDuraTitle"]= "耐久度";
L["raidStatusDuraDesc"]= "在副本狀態追蹤器上顯示耐久度欄位？";

L["raidCooldownNecksHeaderDesc"] = "項鍊增益冷卻追蹤";

L["raidCooldownNeckSPTitle"] = "+34 法術能量";
L["raidCooldownNeckSPDesc"] = "顯示隊員的冷卻時間，|cFF0070DD[夜之眼]|r（+34 法術能量）項鍊增益？";
L["raidCooldownNeckCritTitle"] = "+2% 法術爆擊";
L["raidCooldownNeckCritDesc"] = "顯示小隊成員的 |cFF0070DD[暮光貓頭鷹項鍊]|r (+2% 爆擊) 項鍊增益效果的冷卻時間？";

L["raidCooldownNeckCritRatingTitle"] = "+28 爆擊等級";
L["raidCooldownNeckCritRatingDesc"] = "顯示小隊成員的 |cFF0070DD[編織永恆鏈]|r (+28 爆擊等級) 項鍊增益效果的冷卻時間？";

L["raidCooldownNeckStamTitle"] = "+20 耐力";
L["raidCooldownNeckStamDesc"] = "顯示小隊成員的 |cFF0070DD[厚重邪鋼項鍊]|r (+20 耐力) 項鍊增益效果的冷卻時間？";

L["raidCooldownNeckHP5Title"] = "+6 5秒回血";
L["raidCooldownNeckHP5Desc"] = "顯示小隊成員的 |cFF0070DD[活化紅寶石墜飾]|r (+6 生命值每 5 秒) 項鍊增益效果的冷卻時間？";

L["raidCooldownNeckStatsTitle"] = "+10 屬性";
L["raidCooldownNeckStatsDesc"] = "顯示小隊成員的 |cFF0070DD[黎明擁抱]|r (+10 屬性) 項鍊增益效果的冷卻時間？";

L["raidCooldownsNecksRaidOnlyTitle"] = "僅在團隊中追蹤項鍊";
L["raidCooldownsNecksRaidOnlyDesc"] = "僅在團隊中時顯示項鍊增益效果的冷卻時間，小隊中則隱藏？";

L["raidCooldownsShowDeadTitle"] = "顯示死亡";
L["raidCooldownsShowDeadDesc"] = "以紅色條和骷髏頭顯示死亡玩家，並將其冷卻時間視為尚未準備就緒。";

L["Eating"] = "食用中"; --This can't be longer than 6 characters to fit in the raid status column.
L["Food"] = "食物";

L["raidStatusShowReadyCheckTitle"] = "在團確時顯示";
L["raidStatusShowReadyCheckDesc"] = "當開始團確時自動顯示團狀態框架？";

L["raidStatusFadeReadyCheckTitle"] = "隱藏團確完成";
L["raidStatusFadeReadyCheckDesc"] = "如果每個人都準備好了，團確完成後幾秒鐘後淡出團隊狀態框架？";

L["raidStatusHideCombatTitle"] = "戰鬥中隱藏";
L["raidStatusHideCombatDesc"] = "當任何戰鬥開始時自動隱藏團隊狀態框架？";

L["raidStatusColumsHeaderDesc"] = "顯示項目";

L["deleteEntry"] = "刪除紀錄";
L["deleteInstance"] = "刪除事件紀錄 %s (%s)。";
L["deleteInstanceError"] = "刪除事件 %s 錯誤。";

L["logDungeonsTitle"] = "記錄地城";
L["logDungeonsDesc"] = "也記錄地城嗎？如果你只想要記錄團隊副本就關閉這個。";

L["logRaidsTitle"] = "記錄出團";
L["logRaidsDesc"] = "記錄所有 10/25/40 人團隊副本。";

L["raidStatusShadowResTitle"] = "暗影抗性";
L["raidStatusShadowResDesc"] = "在團隊狀態追蹤器上顯示暗影抗性欄位嗎？你需要點擊團隊狀態框架上的「更多」按鈕才能看到它。";

L["raidStatusFireResTitle"] = "火焰抗性";
L["raidStatusFireResDesc"] = "在團隊狀態追蹤器上顯示火焰抗性欄位嗎？你需要點擊團隊狀態框架上的「更多」按鈕才能看到它。";

L["raidStatusNatureResTitle"] = "自然抗性";
L["raidStatusNatureResDesc"] = "在團隊狀態追蹤器上顯示自然抗性欄位嗎？你需要點擊團隊狀態框架上的「更多」按鈕才能看到它。";

L["raidStatusFrostResTitle"] = "冰霜抗性";
L["raidStatusFrostResDesc"] = "在團隊狀態追蹤器上顯示冰霜抗性欄位嗎？你需要點擊團隊狀態框架上的「更多」按鈕才能看到它。";

L["raidStatusArcaneResTitle"] = "奧術抗性";
L["raidStatusArcaneResDesc"] = "在團隊狀態追蹤器上顯示奧術抗性欄位嗎？你需要點擊團隊狀態框架上的「更多」按鈕才能看到它。";

L["raidStatusWeaponEnchantsTitle"] = "武器附魔";
L["raidStatusWeaponEnchantsDesc"] = "在團隊狀態追蹤器上顯示武器附魔（油／石等）欄位嗎？你需要點擊團隊狀態框架上的「更多」按鈕才能看到它。";

L["raidStatusTalentsTitle"] = "天賦";
L["raidStatusTalentsDesc"] = "在團隊狀態追蹤器上顯示天賦欄位嗎？你需要點擊團隊狀態框架上的「更多」按鈕才能看到它。";

L["raidStatusExpandAlwaysTitle"] = "總是顯示更多";
L["raidStatusExpandAlwaysDesc"] = "你想在打開團隊狀態框架時總是顯示更多嗎？所以你不必點擊更多按鈕。";

L["raidStatusExpandHeaderDesc"] = "更多";
L["raidStatusExpandTextDesc"] = "當你點擊團隊狀態框架上的「更多」按鈕時會顯示這些。要看到團隊成員的額外數值，他們必須安裝 NRC 或在 |cFF3CE13Fhttps://wago.io/sof4ehBA6|r 上找到 Nova Raid Companion Addon Helper 弱效光環。";

L["raidStatusExpandTooltip"] = "|cFFFFFF00點擊顯示更多資料，如法術抗性。|r\n|cFF9CD6DE沒有 NRC 的小組成員必須擁有弱效光環：NRC Helper，在 https://wago.io/sof4ehBA6 了解詳情。|r";

L["healthstoneMsgTitle"] = "治療石訊息";
L["healthstoneMsgDesc"] = "當你施放治療石時，在 /say 中顯示訊息，以便人們幫忙點擊嗎？這還會顯示你所施放的等級。";

L["summonMsgTitle"] = "招喚訊息";
L["summonMsgDesc"] = "當你開始招喚時，在小組聊天中顯示訊息，以便人們幫忙點擊，其他術士也可以看到你正在招喚誰，這樣就不會招喚同一個人？";

L["summonStoneMsgTitle"] = "集合石訊息";
L["summonStoneMsgDesc"] = "當你使用召喚石時，在小組聊天中顯示訊息，以便人們幫忙點擊，團隊中的其他人可以看到你正在招喚誰，這樣就不會招喚同一個人？";

L["duraWarningTitle"] = "耐久度警告";
L["duraWarningDesc"] = "如果你在裝甲耐久度很低的情況下進入團隊副本，則在聊天視窗中顯示耐久度警告嗎？";

L["dataOptionsTextDesc"] = "資料合併及記錄儲存選項"

L["maxRecordsKeptTitle"] = "團隊紀錄資料庫大小";
L["maxRecordsKeptDesc"] = "資料庫中要保留的最大團隊副本數目，將其增加到大量數目可能會在打開記錄視窗時增加載入時間。";

L["maxRecordsShownTitle"] = "記錄中顯示的團隊副本";
L["maxRecordsShownDesc"] = "團隊副本記錄中要顯示的最大團隊副本數目？如果你只想要查看特定數量的團隊副本，但仍要保留更多資料，你可以將其設定為小於所保留的記錄數目。";
L["maxTradesKeptTitle"] = "交易紀錄資料庫大小";
L["maxTradesKeptDesc"] = "資料庫中要保留的最大交易數目，將其增加到非常大量的數目可能會在打開交易記錄時造成延遲。";

L["maxTradesShownTitle"] = "記錄中顯示的交易";
L["maxTradesShownDesc"] = "交易記錄中要顯示的最大交易數目？如果你只想要查看特定數量的交易，但仍要保留更多資料，你可以將其設定為小於所保留的記錄數目。";
L["showMoneyTradedChatTitle"] = "在聊天中回報金錢交易";
L["showMoneyTradedChatDesc"] = "在聊天視窗中顯示你從某人給予或收取金幣時交易嗎？（幫助你在提升小組中追蹤你已支付或收取金幣的人）。 |cFFFF0000警告：如果你已經安裝了 Nova Instance Tracker 且在聊天中顯示交易，這個功能將無法運作，這樣你就沒有重複的訊息了。|r";

L["attunementWarningsTitle"] = "任務物品提示";
L["attunementWarningsDesc"] = "在首領死亡後顯示提示時取任務物品?";

L["sortRaidStatusByGroupsColorTitle"] = "團隊上色";
L["sortRaidStatusByGroupsColorDesc"] = "如果你在團隊狀態視窗上啟用了依小組排序，則會為它們上色。";

L["sortRaidStatusByGroupsColorBackgroundTitle"] = "團隊背景上色";
L["sortRaidStatusByGroupsColorBackgroundDesc"] = "如果你啟用了依小組排序並已啟用彩色，這也會為小組背景上色。";

L["shadowNeckBTWarning"] = "你仍裝備著暗抗項鍊。";
L["pvpTrinketWarning"] = "你仍裝備PVP飾品。";
L["raidCooldownManaTideTitle"] = "法力之潮";
L["raidCooldownManaTideDesc"] = "顯示法力之潮團隊冷卻？";

L["raidCooldownPainSuppressionTitle"] = "痛苦鎮壓";
L["raidCooldownPainSuppressionDesc"] = "顯示痛苦鎮壓團隊冷卻？";

L["raidCooldownPowerInfusionTitle"] = "能量灌注";
L["raidCooldownPowerInfusionDesc"] = "顯示能量灌注團隊冷卻？";

L["raidCooldownBlessingofProtectionTitle"] = "保護祝福";
L["raidCooldownBlessingofProtectionDesc"] = "顯示保護祝福團隊冷卻？";

L["raidCooldownHandofProtectionTitle"] = "保護之手";
L["raidCooldownHandofProtectionDesc"] = "顯示保護之手團隊冷卻？";

L["raidCooldownDivineGuardianTitle"] = "神性守護";
L["raidCooldownDivineGuardianDesc"] = "顯示神性守護團隊冷卻？";

L["soulstoneMsgSayTitle"] = "靈魂石訊息（說）";
L["soulstoneMsgSayDesc"] = "在向某人施放靈魂石時在 /say 中顯示訊息？";

L["soulstoneMsgGroupTitle"] = "靈魂石訊息（小組）";
L["soulstoneMsgGroupDesc"] = "在向某人施放靈魂石時在小組聊天中顯示訊息？";

L["showInspectTalentsTitle"] = "顯示天賦觀察";
L["inspectTalentsCheckBoxTooltip"] = "在你觀察其他人時顯示 NRC 天賦視窗？";

L["cooldownFrameCountTitle"] = "多少冷卻清單";
L["cooldownFrameCountDesc"] = "你想有多少個別的冷卻清單？你可以建立多個清單以放在不同位置，並將不同的冷卻分配給每個清單。將每個法術分配給以下清單，按測試可顯示你已啟用的所有選項。";

L["testRaidCooldownsDesc"] = "測試冷卻計時框 30 秒，以便你可以設定或按住 Shift 來拖曳它們。在測試執行時變更這裡的任何選項以查看它的外觀。";

L["raidStatusScaleTitle"] = "團隊狀態視窗大小";
L["raidStatusScaleDesc"] = "在此處設定團隊狀態視窗大小比例。";

L["holdShitForExtraInfo"] = "按住 Shift 以顯示更多資訊";

L["timeStampFormatTitle"] = "時間格式";
L["timeStampFormatDesc"] = "設定要使用的時間戳格式，12 小時（下午 1:23）或 24 小時（下午 13:23）。例如，當你在小地圖按鈕上按住 Shift 時，像是 3 天的團隊重置週期。";

L["Completed quest"] = "你已經 |cFF00C800完成|r 這個任務。";
L["Not completed quest"] = "你 |cFFFF2222尚未完成|r 這個任務";

L["raidCooldownsGrowthDirectionTitle"] = "生長方向";
L["raidCooldownsGrowthDirectionDesc"] = "你想讓清單以哪種方式增長？";

L["raidCooldownsScaleTitle"] = "大小";
L["raidCooldownsScaleDesc"] = "你想讓冷卻清單有多大？";

L["raidCooldownsBorderTypeTitle"] = "外框樣式";
L["raidCooldownsBorderTypeDesc"] = "你想在計時框周圍設定哪種邊框？";

L["raidCooldownsSoulstonesPositionTitle"] = "靈魂石位置";
L["raidCooldownsSoulstonesPositionDesc"] = "你想在哪裡顯示已啟用的靈魂石？";

L["meTransferedThreatMD"] = "%s 仇恨被誤導到 %s。"; --These are a little different for different places.
L["otherTransferedThreatMD"] = "%s 誤導 %s 仇恨到 %s。"; --These are a little different for different places.
L["meTransferedThreatTricks"] = "%s 威脅轉嫁到 %s。"; --These are a little different for different places.
L["otherTransferedThreatTricks"] = "%s 轉嫁 %s 威脅到 %s。"; --These are a little different for different places.

L["meCastSpellOn"] = "對 %s 施放 %s"; --Capitalize these properly if translating.
L["otherCastSpellOn"] = "%s 對 %s 施放 %s"; --Capitalize these properly if translating.
L["spellCastOn"] = "在 %s 上施放 %s";

L["mdSendMyCastGroupTitle"] = "團隊回報我的誤導";
L["mdSendMyCastGroupDesc"] = "在小組聊天中顯示我的誤導施放？";

L["mdSendMyCastSayTitle"] = "/說 回報我的誤導";
L["mdSendMyCastSayDesc"] = "在 /say 中顯示我的誤導施放？僅在副本中有效。";

L["mdSendOtherCastGroupTitle"] = "回報隊友的誤導";
L["mdSendOtherCastGroupDesc"] = "在小組聊天中顯示其他玩家的誤導施放？你只能在你團隊的其他獵人沒有附加元件顯示他們的誤導時使用此選項。";

L["mdSendMyThreatGroupTitle"] = "團隊回報我的誤導仇恨";
L["mdSendMyThreatGroupDesc"] = "在小組聊天中顯示我的誤導仇恨轉移到坦克的數量？";

L["mdSendMyThreatSayTitle"] = "/說 回報我的誤導仇恨";
L["mdSendMyThreatSayDesc"] = "在 /say 中顯示我的誤導仇恨轉移到坦克的數量？僅在副本中有效。";

L["mdSendOthersThreatGroupTitle"] = "團隊回報隊友誤導仇恨";
L["mdSendOthersThreatGroupDesc"] = "在小組聊天中顯示其他玩家的誤導仇恨轉移到坦克的數量？你只能在你團隊的其他獵人沒有附加元件顯示他們的誤導仇恨轉移時使用此選項。";

L["mdSendOthersThreatSayTitle"] = "/說 回報隊友誤導仇恨";
L["mdSendOthersThreatSayDesc"] = "在 /say 中顯示其他玩家的誤導仇恨轉移到坦克的數量？你只能在你團隊的其他獵人沒有附加元件顯示他們的誤導仇恨轉移時使用此選項。僅在副本中有效。";

L["mdShowMySelfTitle"] = "顯示我的仇恨轉移";
L["mdShowMySelfDesc"] = "在你的聊天視窗中顯示誤導仇恨轉移到坦克的數量，讓只有你能看到？";

L["mdShowOthersSelfTitle"] = "顯示隊友的仇恨轉移";
L["mdShowOthersSelfDesc"] = "在你的聊天視窗中顯示其他玩家的誤導仇恨轉移到坦克的數量，讓只有你能看到？";

L["mdShowSpellsTitle"] = "顯示誤導時的傷害技能";
L["mdShowSpellsDesc"] = "在你的聊天視窗中列出誤導期間使用的法術？只有你能看到此訊息。";

L["mdShowSpellsOtherTitle"] = "顯示隊友誤導時的傷害技能";
L["mdShowSpellsOtherDesc"] = "在你的聊天視窗中列出其他獵人在誤導期間使用的法術？只有你能看到此訊息。";

L["mdSendTargetTitle"] = "密語目標轉移仇恨";
L["mdSendTargetDesc"] = "透過私語將從你的誤導轉移到目標的威脅值傳送給目標？";

L["mdMyTextDesc"] = "顯示選項讓你看到誤導仇恨轉移到坦克的情況。";
L["mdOtherTextDesc"] = "顯示選項讓你在團隊中看到其他獵人的誤導仇恨轉移到坦克的情況。";
L["mdLastTextDesc"] = "也有 /lastmd 指令讓你可以向小組聊天顯示上一次誤導使用的法術，你可以執行 /lastmd 來顯示上次使用，執行 /lastmd <name> 來按照名稱顯示最後使用，以及執行 /lastmd list 來顯示記錄有哪些可以選擇。";
L["raidCooldownsDisableMouseTitle"] = "關閉滑鼠提示";
L["raidCooldownsDisableMouseDesc"] = "這將停用沒有顯示冷卻的時間在滑鼠移動到上面時顯示的空白冷卻清單，這表示你必須點擊測試按鈕才能移動它們。";

L["raidCooldownsSortOrderTitle"] = "排序方式";
L["raidCooldownsSortOrderDesc"] = "你想如何排序冷卻計時列？";

L["autoCombatLogTitle"] = "自動開啟戰鬥紀錄";
L["autoCombatLogDesc"]= "在你進入團隊時開啟戰鬥記錄，以便它可以供戰役記錄等網站使用。";

L["cauldronMsgTitle"] = "施放大鍋提示";
L["cauldronMsgDesc"] = "在你團隊中放置大鍋時在 /say 中放一條訊息？";

L["sreMainTextDesc"] = "向下捲動來新增自訂法術。";
L["sreCustomSpellsHeaderDesc"] = "自訂追蹤法術";

L["sreLineFrameScaleTitle"] = "訊息大小";
L["sreLineFrameScaleDesc"] = "你想讓文字和圖示有多大？";

L["sreScrollHeightTitle"] = "滾動軸高度";
L["sreScrollHeightDesc"] = "你想讓訊息捲動多遠（在設定此選項之前先解鎖計時框或點選測試，以便你可以看到高度）。";

L["sreEnabledTitle"] = "啟動";
L["sreEnabledDesc"] = "啟用或停用在螢幕上顯示可捲動的團隊事件。";

L["sreEnabledEverywhereTitle"] = "任何地方";
L["sreEnabledEverywhereDesc"] = "啟用在任何地方，包括在團隊之外（競技場/戰場除外，它們有自己的設定選項）。";

L["sreEnabledRaidTitle"] = "地城與團隊";
L["sreEnabledRaidDesc"] = "啟用在團隊和地城之內。";

L["sreEnabledPvPTitle"] = "PvP 區域";
L["sreEnabledPvPDesc"] = "啟用在戰場和競技場中。";

L["sreGroupMembersTitle"] = "團隊成員施法";
L["sreGroupMembersDesc"] = "顯示小組成員的法術？你可以勾選「所有玩家的法術」如果你想看到甚至不在你小組中的玩家。";

L["sreShowSelfTitle"] = "我的法術";
L["sreShowSelfDesc"] = "也顯示我施放的法術。";

L["sreShowSelfRaidOnlyTitle"] = "只在團隊中顯是我的法術";
L["sreShowSelfRaidOnlyDesc"] = "在我的法術施放時在團隊/地城中才顯示這些法術，這個選項會讓你可以在任何地方啟用模組，而不會在開放世界中看到你自己的法術。";

L["sreAllPlayersTitle"] = "所有玩家的法術";
L["sreAllPlayersDesc"] = "顯示世界中不在你小組中的玩家施放的法術？需要「任何地方」也已啟用。";

L["sreNpcsTitle"] = "NPCs";
L["sreNpcsDesc"] = "顯示 NPC 施放的法術？你可以下方新增自訂法術。";

L["sreNpcsRaidOnlyTitle"] = "只在副本中顯示NPC法術";
L["sreNpcsRaidOnlyDesc"] = "在團隊/地城中施放時顯示 NPC 法術。";

L["sreGrowthDirectionTitle"] = "文字滾動方向";
L["sreGrowthDirectionDesc"] = "你想讓訊息往哪個方向捲動？";

L["sreAddRaidCooldownsToSpellListTitle"] = "新增團隊冷卻";
L["sreAddRaidCooldownsToSpellListDesc"] = "從團隊冷卻追蹤器中新增所有你已啟用的法術？";

L["sreShowCooldownResetTitle"] = "重置冷卻倒數";
L["sreShowCooldownResetDesc"] = "如果你啟用了團隊冷卻追蹤器，你也可以啟用此選項來顯示那些冷卻在重置和結束冷卻時間時。";

L["sreShowInterruptsTitle"] = "打斷";
L["sreShowInterruptsDesc"] = "顯示所有打斷（打斷會顯示無論來源，覆寫小組/我的/NPCs 設定）。";

L["sreShowCauldronsTitle"] = "大鍋";
L["sreShowCauldronsDesc"] = "放置在大鍋中的大鍋讓你可以拾取藥水。";

L["sreShowSoulstoneResTitle"] = "使用靈魂石";
L["sreShowSoulstoneResDesc"] = "顯示玩家使用靈魂石復活時。";

L["sreShowManaPotionsTitle"] = "法力藥水";
L["sreShowManaPotionsDesc"]	= "顯示法力藥水的使用。包括黑暗盧恩和無夢睡眠藥水。";

L["sreShowHealthPotionsTitle"] = "治療藥水";
L["sreShowHealthPotionsDesc"] = "顯示治療藥水的使用。";

L["sreShowDpsPotionsTitle"] = "爆發及防護藥水";
L["sreShowDpsPotionsDesc"] = "顯示爆發和護甲/防護藥水的使用。這包括毀滅/加速/鐵盾/隱形藥水。";

L["sreShowMagePortalsTitle"] = "法師傳送門";
L["sreShowMagePortalsDesc"]	= "顯示法師的傳送門，不再被那些煩人的法師騙了！";

L["sreShowResurrectionsTitle"] = "復活";
L["sreShowResurrectionsDesc"] = "顯示復活其他玩家的玩家。";

L["sreShowMisdirectionTitle"] = "誤導仇恨";
L["sreShowMisdirectionDesc"] = "顯示獵人的誤導將多少威脅傳送到坦克。";

L["sreShowSpellNameTitle"] = "顯示法術名稱";
L["sreShowSpellNameDesc"] = "在顯示的文字中顯示法術名稱。";

L["sreOnlineStatusTitle"] = "上線/離線 狀態";
L["sreOnlineStatusDesc"] = "顯示小組成員上線和離線的狀態。";

L["sreAlignmentTitle"] = "文字對齊";
L["sreAlignmentDesc"] = "從左，中間或右邊展開訊息？";

L["sreAnimationSpeedTitle"] = "滾動軸動畫速度";
L["sreAnimationSpeedDesc"] = "你想讓事件以多快的速度滾動？";

L["sreAddSpellTitle"] = "新增自訂法術ID";
L["sreAddSpellDesc"] = "在此處新增自訂法術，輸入你想看到施放的法術的圖示。你可以在魔獸世界頭輸入任何法術的名稱，查看網站網址中的數字來獲得法術的圖示。";

L["sreRemoveSpellTitle"] = "移除自訂法術ID";
L["sreRemoveSpellDesc"] = "在此處移除自訂法術，輸入你要移除的法術圖示。";

L["You can't delete log entries while inside an instance."] = "你無法刪除你正在進行的副本紀錄。";

L["consumesEncounterTooltip"] = "選擇顯示方式";
L["consumesPlayersTooltip"] = "選擇一個玩家或全部玩家。";
L["consumesViewTooltip"] = "查看使用時間軸或總計數";

L["itemUseShowConsumesTooltip"] = "顯示基本消耗品";
L["itemUseShowScrollsTooltip"] = "顯示卷軸";
L["itemUseShowInterruptsTooltip"] = "顯示中斷\n（重複中斷圖標是不同等級）";
L["itemUseShowRacialsTooltip"] = "顯示種族天賦";
L["itemUseShowFoodTooltip"] = "顯示食物";

L["autoSunwellPortalTitle"] = "太陽井傳送";
L["autoSunwellPortalDesc"] = "在與 NPC 交談時自動進行太陽井傳送，此操作將使用最遠的傳送門。";

L["Taking Sunwell teleport."] = "太陽井自動傳送。";

L["lockAllFramesTitle"] = "鎖定所有視窗";
L["lockAllFramesDesc"] = "鎖定和解鎖所有視窗，以便您可以移動它們（您也可以輸入 /nrc lock 和 /nrc unlock）。";

L["testAllFramesTitle"] = "測試所有視窗";
L["testAllFramesDesc"] = "使用您當前設定對所有框架執行 30 秒測試。";

L["resetAllFramesTitle"] = "重置所有視窗";
L["resetAllFramesDesc"] = "將所有視窗重置回預設位置。";

L["raidManaMainTextDesc"] = "簡單地監視所有出團補師的法力。";

L["raidManaEnabledTitle"] = "啟用";
L["raidManaEnabledDesc"] = "啟用團隊法力模組。";

L["raidManaEnabledEverywhereTitle"] = "所有地方";
L["raidManaEnabledEverywhereDesc"] = "啟用所有地方，包括團隊之外（競技場/戰場除外，它們有自己的設定選項）。";

L["raidManaEnabledRaidTitle"] = "團隊/地下城";
L["raidManaEnabledRaidDesc"] = "在團隊和地下城中啟用。";

L["raidManaEnabledPvPTitle"] = "PvP";
L["raidManaEnabledPvPDesc"] = "在戰場和競技場中啟用。";

L["raidManaAverageTitle"] = "團隊法力";
L["raidManaAverageDesc"] = "如果顯示多個玩家，則顯示所有顯示玩家的法力平均值。";

L["raidManaShowSelfTitle"] = "顯示我的法力";
L["raidManaShowSelfDesc"] = "如果我是治療者或在下面已啟用的職業，是否也要顯示我自己的法力？";

L["raidManaScaleTitle"] = "大小";
L["raidManaScaleDesc"] = "您希望團隊法力框架有多大？";

L["raidManaGrowthDirectionTitle"] = "生長方向";
L["raidManaGrowthDirectionDesc"] = "您希望列表哪個方向增長？";

L["raidManaBackdropAlphaTitle"] = "背景透明度";
L["raidManaBackdropAlphaDesc"] = "您希望背景多透明？";

L["raidManaBorderAlphaTitle"] = "邊框透明度";
L["raidManaBorderAlphaDesc"] = "您希望邊框多透明？";

L["raidManaUpdateIntervalTitle"] = "更新頻率";
L["raidManaUpdateIntervalDesc"] = "您希望框架多久更新一次，每 0.1 到 1 秒。";

L["raidManaSortOrderTitle"] = "排序方式";
L["raidManaSortOrderDesc"] = "選擇法力顯示的排序方式。";

L["raidManaFontTitle"] = "姓名字體";
L["raidManaFontDesc"] = "用於顯示玩家姓名的字體。警告：字體有不同的寬度，有些字體可能不適合這些小框架，試圖塞入大量資訊。";

L["raidManaFontNumbersTitle"] = "數字字體";
L["raidManaFontNumbersDesc"] = "用於顯示百分比數字的字體。警告：字體有不同的寬度，有些字體可能不適合這些小框架，試圖塞入大量資訊。";

L["raidManaResurrectionTitle"] = "顯示復活";
L["raidManaResurrectionDesc"] = "當治療者在他們的名字旁邊施放復活時顯示復活。";

L["raidManaResurrectionDirTitle"] = "復活方向";
L["raidManaResurrectionDirDesc"] = "在框架的哪一側顯示復活，\"自動\"表示它將根據框架位於您的 UI 哪一側來顯示在右側或左側。";

L["raidManaHealersTitle"] = "顯示所有補師";
L["raidManaHealersDesc"] = "顯示此團隊中所有治療者的法力，這使用 NRC 天賦檢測來尋找真正的治療者以提高準確性。您可能需要在團隊中至少與玩家在一定距離內，以便檢測到他們的才能並將他們顯示為治療者。";

L["raidManaDruidDesc"] = "顯示所有出團德魯伊的魔量?";
L["raidManaHunterDesc"] = "顯示所有出團獵人的魔量?";
L["raidManaMageDesc"] = "顯示所有出團法師的魔量?";
L["raidManaPaladinDesc"] = "顯示所有出團聖騎士的魔量?";
L["Start Frames Test"] = "測試視窗測試";
L["Stop Frames Test"] = "停止視窗測試";
L["raidManaPriestDesc"] = "顯示所有出團牧師的魔量?";
L["raidManaShamanDesc"] = "顯示所有出團薩滿的魔量?";
L["raidManaWarlockDesc"] = "顯示所有出團術士的魔量?";

L["raidCooldownsFontTitle"] = "姓名字體";
L["raidCooldownsFontDesc"] = "用來顯示玩家/冷卻時間名稱的字體。警告：字體寬度不一，有些字體可能無法正確顯示在嘗試塞入大量資訊的小框架當中。";

L["raidCooldownsFontNumbersTitle"] = "數字字體";
L["raidCooldownsFontNumbersDesc"] = "用來顯示冷卻時間就緒數字的字體。警告：字體寬度不一，有些字體可能無法正確顯示在嘗試塞入大量資訊的小框架當中。";

L["checkMetaGemTitle"] = "檢查變換寶石";
L["checkMetaGemDesc"] = "如果你的變換寶石沒有啟動，出現警告訊息?";

L["raidCooldownsFontSizeTitle"] = "字體大小";
L["raidCooldownsFontSizeDesc"] = "你想讓字體多大?";

L["raidCooldownsWidthTitle"] = "寬度";
L["raidCooldownsWidthDesc"] = "你想讓每個條棒有多寬?";

L["raidCooldownsHeightTitle"] = "高度";
L["raidCooldownsHeightDesc"] = "你想讓每個條棒有多高?";

L["raidCooldownsPaddingTitle"] = "填充";
L["raidCooldownsPaddingDesc"] = "你想讓每個條棒之間有多少空間?";
L["raidManaFontSizeTitle"] = "字體大小";
L["raidManaFontSizeDesc"] = "你想讓字體多大?";

L["raidManaWidthTitle"] = "寬度";
L["raidManaWidthDesc"] = "你想讓每個條棒有多寬?";

L["raidManaHeightTitle"] = "高度";
L["raidManaHeightDesc"] = "你想讓每個條棒有多高?";

L["raidManaPaddingTitle"] = "填充";
L["raidManaPaddingDesc"] = "你想讓每個條棒之間有多少空間?";

L["raidCooldownsFontOutlineTitle"] = "字體邊框";
L["raidCooldownsFontOutlineDesc"] = "你想讓團隊冷卻時間字體有外框嗎?";

L["sreFontOutlineTitle"] = "字體邊框";
L["sreFontOutlineDesc"] = "你想讓捲動事件字體有外框嗎?";

L["raidManaFontOutlineTitle"] = "字體邊框";
L["raidManaFontOutlineDesc"] = "你想讓團隊法力字體有外框嗎?";

L["Thick Outline"] = "粗邊框";
L["Thin Outline"] = "細邊框";

L["sreFontTitle"] = "字體";
L["raidStatusFontTitle"] = "字體";
L["raidStatusFontDesc"] = "團隊狀態字體。警告：字體寬度不一，有些字體可能無法正確顯示在嘗試塞入大量資訊的小框架當中，請視情況調整大小。";

L["raidStatusFontSizeTitle"] = "字體大小";
L["raidStatusFontSizeDesc"] = "你想讓字體多大?";

L["raidStatusFontOutlineTitle"] = "字體邊框";
L["raidStatusFontOutlineDesc"] = "你想讓團隊狀態字體有外框嗎?";

L["tricksSendMyCastGroupTitle"] = "團頻回報我的偷天";
L["tricksSendMyCastGroupDesc"] = "在團隊聊天中顯示我的偷天施法嗎?";

L["tricksSendMyCastSayTitle"] = "/說 回報我的偷天";
L["tricksSendMyCastSayDesc"] = "在/say中顯示我的轉移偷天施法嗎? 僅在副本中有效。";

L["tricksSendOtherCastGroupTitle"] = "回報隊友偷天";
L["tricksSendOtherCastGroupDesc"] = "在團隊聊天中顯示其他玩家的偷天施法嗎? 你只能在團隊中沒有其他盜賊有顯示他們偷天的插件時使用這個功能。";

L["tricksSendMyThreatGroupTitle"] = "團頻回報我的偷天仇恨";
L["tricksSendMyThreatGroupDesc"] = "在團隊聊天中顯示我轉移給坦克多少偷天仇恨?";

L["tricksSendMyThreatSayTitle"] = "/說 回報我的偷天仇恨";
L["tricksSendMyThreatSayDesc"] = "在/say中顯示我轉移多少偷天仇恨? 僅在副本中有效。";

L["tricksSendOthersThreatGroupTitle"] = "回報隊友偷天仇恨";
L["tricksSendOthersThreatGroupDesc"] = "在團隊聊天中顯示其他盜賊轉移多少偷天仇恨?";

L["tricksSendOthersThreatSayTitle"] = "/說 回報隊友偷天仇恨";
L["tricksSendOthersThreatSayDesc"] = "在/say中顯示其他玩家轉移多少偷天仇恨?";

L["tricksShowMySelfTitle"] = "顯示偷天仇恨";
L["tricksShowMySelfDesc"] = "在你的聊天視窗中顯示你轉移了多少仇恨，以便只有你看得見嗎?";

L["tricksShowOthersSelfTitle"] = "顯示隊友偷天仇恨";
L["tricksShowOthersSelfDesc"] = "在你的聊天視窗中顯示其他盜賊轉移給坦克多少偷天仇恨，以便只有你看得見嗎?";

L["tricksShowSpellsTitle"] = "顯示偷天時使用的傷害技能";
L["tricksShowSpellsDesc"] = "在你的聊天視窗中印出在偷天期間使用了哪些法術? 只有你會看見這條訊息，可能會有點洗版。";

L["tricksShowSpellsOtherTitle"] = "顯示隊友偷天時使用的傷害技能";
L["tricksShowSpellsOtherDesc"] = "在你的聊天視窗中印出其他盜賊在他們的偷天期間使用了哪些法術? 只有你會看見這條訊息，可能會有點洗版。";

L["tricksSendTargetTitle"] = "密語轉移仇恨的目標";
L["tricksSendTargetDesc"] = "透過密語將你轉移到目標的仇恨量發送出去嗎?";

L["tricksMyTextDesc"] = "顯示你的偷天轉移了多少仇恨的選項。";
L["tricksOtherTextDesc"] = "顯示隊友的偷天轉移了多少仇恨的選項。";
L["tricksLastTextDesc"] = "還有一個 /lasttricks 指令，可以在團隊聊天中顯示最後一次偷天使用的法術，你可以使用 /lasttricks 顯示最後一次使用的，/lasttricks <name> 顯示某人最後一次使用的，以及 /lasttricks list 顯示有記錄的偷天提供選擇。";L["tricksDamageTextDesc"] = "顯示你的15%增傷目標得到多少額外傷害的選項。.";

L["tricksSendDamageGroupTitle"] = "團頻回報你偷天的額外傷害";
L["tricksSendDamageGroupDesc"] = "團頻回報你偷天的目標多了多少額外傷害。";

L["tricksSendDamageGroupOtherTitle"] = "回報隊友偷天的額外傷害";
L["tricksSendDamageGroupOtherDesc"] = "團頻回報隊友的偷天目標增加了多少額外傷害。";

L["tricksSendDamageWhisperTitle"] = "密語傷害給偷天目標";
L["tricksSendDamageWhisperDesc"] = "密語你的偷天目標他增加了多少額外傷害。";

L["tricksSendDamagePrintTitle"] = "顯示你的額外傷害";
L["tricksSendDamagePrintDesc"] = "列印聊天視窗裡面你使用花招目標造成的傷害";

L["tricksSendDamagePrintOtherTitle"] = "顯示隊友的額外傷害";
L["tricksSendDamagePrintOtherDesc"] = "列印聊天視窗裡面其他盜賊的花招在團隊中造成的傷害";

L["tricksOtherRoguesMineGainedTitle"] = "顯示我從其他盜賊得到的額外傷害";
L["tricksOtherRoguesMineGainedDesc"] = "如果盜賊對我施放花招，則列印我能增加多少傷害？適用於所有職業。";

L["tricksOnlyWhenDamageTitle"] = "傷害大於0顯示";
L["tricksOnlyWhenDamageDesc"] = "僅在傷害大於 0 時顯示訊息。";

L["otherTransferedDamageMyTricks"] = "%s 從我的偷天得到 %s 額外傷害。";
L["otherTransferedDamageOtherTricks"] = "%s 得到 %s 額外傷害，從 %s 的偷天。";
L["meTransferedThreatTricksWhisper"] = "你獲得 %s 額外傷害從我的偷天換日。";
L["otherTransferedDamageTricksMine"] = "你獲得 %s 額外傷害，從 %s 的偷天換日。";

--Wrath cooldowns.
L["raidCooldownArmyoftheDeadTitle"] = "亡靈大軍";
L["raidCooldownArmyoftheDeadDesc"] = "顯示亡靈大軍團隊冷卻時間嗎？";

L["raidCooldownIceboundFortitudeTitle"] = "冰錮堅韌";
L["raidCooldownIceboundFortitudeDesc"] = "顯示冰錮堅韌團隊冷卻時間嗎？";

L["raidCooldownAntiMagicZoneTitle"] = "反魔法力場";
L["raidCooldownAntiMagicZoneDesc"] = "顯示反魔法力場團隊冷卻時間嗎？";

L["raidCooldownAntiMagicShellTitle"] = "反魔法護罩";
L["raidCooldownAntiMagicShieldDesc"] = "顯示反魔法護盾團隊冷卻時間嗎？";

L["raidCooldownSurvivalInstinctsTitle"] = "求生本能";
L["raidCooldownSurvivalInstinctsDesc"] = "顯示求生本能團隊冷卻時間嗎？";
L["raidCooldownUnholyFrenzyTitle"] = "邪惡狂熱";
L["raidCooldownUnholyFrenzyDesc"] = "顯示邪惡狂熱團隊冷卻時間嗎？";

L["raidCooldownVampiricBloodTitle"] = "血族之裔";
L["raidCooldownVampiricBloodDesc"] = "顯示血族之裔團隊冷卻時間嗎？";

L["raidCooldownDivineSacrificeTitle"] = "神性犧牲";
L["raidCooldownDivineSacrificeDesc"] = "顯示神性犧牲團隊冷卻時間嗎？";

L["raidCooldownAuraMasteryTitle"] = "精通光環";
L["raidCooldownAuraMasteryDesc"] = "顯示精通光環團隊冷卻時間嗎？";

L["raidCooldownDivineProtectionTitle"] = "聖佑術";
L["raidCooldownDivineProtectionDesc"] = "顯示聖佑術團隊冷卻時間嗎？";

L["raidCooldownHandofSacrificeTitle"] = "犧牲聖禦";
L["raidCooldownHandofSacrificeDesc"] = "顯示犧牲聖禦團隊冷卻時間嗎？";

L["raidCooldownHandofSalvationTitle"] = "拯救聖禦";
L["raidCooldownHandofSalvationDesc"] = "顯示拯救聖禦團隊冷卻時間嗎？";
L["raidCooldownDivineHymnTitle"] = "神聖禮頌";
L["raidCooldownDivineHymnDesc"] = "顯示神聖禮頌團隊冷卻時間嗎？";

L["raidCooldownHymnofHopeTitle"] = "希望禮頌";
L["raidCooldownHymnofHopeDesc"] = "顯示希望禮頌團隊冷卻時間嗎？";

L["raidCooldownGuardianSpiritTitle"] = "守護聖靈";
L["raidCooldownGuardianSpiritDesc"] = "顯示守護聖靈團隊冷卻時間嗎？";

L["raidCooldownTricksoftheTradeTitle"] = "偷天換日";
L["raidCooldownTricksoftheTradeDesc"] = "顯示偷天換日團隊冷卻時間嗎？";

L["raidCooldownBladestormTitle"] = "劍刃風暴";
L["raidCooldownBladestormDesc"] = "顯示劍刃風暴團隊冷卻時間嗎？";

L["raidCooldownShatteringThrowTitle"] = "碎甲投擲";
L["raidCooldownShatteringThrowDesc"] = "顯示碎甲投擲團隊冷卻時間嗎？";

L["lowAmmoWarning"] = "低彈藥 (%s).";

L["lowAmmoCheckTitle"] = "低彈藥確認";
L["lowAmmoCheckDesc"] = "當彈藥不足時警告您，計算您裝備的任何彈藥，並在聊天視窗中警告您，並有 15 分鐘的警告冷卻時間。";

L["lowAmmoCheckThresholdTitle"] = "低彈藥數值";
L["lowAmmoCheckThresholdDesc"] = "彈藥少於多少才該警告？";

L["exportTypeTooltip"] = "輸出格式";

L["changeLootEntry"] = "設定戰利品掠奪者 %s";
L["renamedLootEntry"] = "當時改為 %s 給 %s 從 %s";
L["clearedLootEntry"] = "已清除戰利品覆蓋項目 %s";
L["mapTradesToLootTooltip"] = "嘗試自動顯示在戰役期間與您交易物品的掠奪者。\n(僅在您是掠奪者時才有效)\n滑鼠右鍵按一下項目來編輯覆蓋項目。";

L["raidCooldownsClicksHeaderDesc"] = "點擊設定";
L["raidCooldownsClickWhisperCastOnMe"] = "請對我施放 %s ！";
L["raidCooldownsClickGroupChatReady"] = "%s 的 %s 已經準備好。";
L["raidCooldownsClickGroupChatNotReady"] = "%s 的 %s 還有 %s 冷卻。";
L["cooldownNotReadyMsg"] = "%s 的 %s 還沒準備好，剩餘 %s 時間。";
L["selfOnlyCooldownMsg"] = "你無法要求這個技能， 這只能施放於自己。";

L["raidCooldownsClickOption2"] = "密語要求施放於我";
L["raidCooldownsClickOption3"] = "回報團隊冷卻時間";

L["raidCooldownsLeftClickTitle"] = "點擊左鍵";
L["raidCooldownsLeftClickDesc"] = "選擇當您左鍵單擊顯示玩家名稱的冷卻條時會發生什麼（未合併的冷卻條或合併時的工具提示）。";

L["raidCooldownsRightClickTitle"] = "點擊右鍵";
L["raidCooldownsRightClickDesc"] = "選擇當您右鍵單擊顯示玩家名稱的冷卻條時會發生什麼（未合併的冷卻條或合併時的工具提示）。";

L["raidCooldownsShiftLeftClickTitle"] = "Shift+點擊左鍵";
L["raidCooldownsShiftLeftClickDesc"] = "選擇當您Shift+單擊左鍵顯示玩家名稱的冷卻條時會發生什麼（未合併的冷卻條或合併時的工具提示）。";

L["raidCooldownsShiftRightClickTitle"] = "Shift+點擊右鍵";
L["raidCooldownsShiftRightClickDesc"] = "選擇當您Shift+點擊右鍵顯示玩家名稱的冷卻條時會發生什麼（未合併的冷卻條或合併時的工具提示）。";
L["Do Nothing"] = "不做任何事";
L["customExportStringFrameTitle"] = "自訂匯出字串架構";
L["customExportStringFrameHeader"] = "標頭：";
L["customExportStringFrameText"] = "戰利品字串：";
L["customExportStringFrameHeaderTooltip"] = "標頭是字串的第一行。\n有些試算表使用它來告訴他們\n將事物置於何種順序。\n如果您願意，可以將其留空。";
L["customExportStringFrameStringTooltip"] = "每個戰利品線的樣式格式。\n使用下面的代碼來構建您的字串。";

L["releaseWarningTitle"] = "放魂警告";
L["releaseWarningDesc"] = "在您於團隊頭目遭遇中死亡時顯示警告，以不放魂至遭遇結束，以便您的冷卻時間重設。";

L["showTrainsetTitle"] = "火車警告";
L["showTrainsetDesc"] = "當有人在您的團隊中使用火車集時顯示/說訊息，當您不在團隊中時也會輸出至您自己";

L["autoInvTitle"] = "自動邀請";
L["autoInvDesc"] = "自動邀請密語您關鍵字的玩家。";

L["autoInvKeywordTitle"] = "自動邀請關鍵字";
L["autoInvKeywordDesc"] = "設定自動邀請的關鍵字。";

L["tradeExportItemsTypeTooltip"] = "您想要如何顯示項目？";

L["dispelledCast"] = "驅散 %s 從 %s";

L["dispelsMainTextDesc"] = "用於攻擊性驅散和激怒效果（包括寧神射擊）的聊天消息。";
L["dispelsMainText2Desc"] = "注意：請記住，如果您安裝了 Nova世界增益監控，它也有驅散消息選項，如果您啟用了這些選項，這些選項可能與其中一些敵方玩家選項有相同的作用。";

L["dispelsFriendlyPlayersTitle"] = "友方玩家";
L["dispelsFriendlyPlayersDesc"] = "當友方玩家施放時顯示驅散。";

L["dispelsEnemyPlayersTitle"] = "敵方玩家";
L["dispelsEnemyPlayersDesc"] = "當友方玩家施放時顯示驅散。";

L["dispelsCreaturesTitle"] = "其他生物或NPC";
L["dispelsCreaturesDesc"] = "當生物/npc 施放時顯示驅散。";

L["dispelsTranqOnlyTitle"] = "只顯示寧神射擊";
L["dispelsTranqOnlyDesc"] = "只顯示獵人的寧神射擊，其他職業的驅散無法使用。這是在假設您只想追蹤寧神射擊的激怒驅散，而您的其他角色則不然。";

L["dispelsMyCastGroupTitle"] = "在團隊聊天回報";
L["dispelsMyCastGroupDesc"] = "在團隊聊天中張貼我的驅散和激怒效果解除？";

L["dispelsMyCastSayTitle"] = "用/說 /say 回報";
L["dispelsMyCastSayDesc"] = "在/say 中張貼我的驅散和激怒效果解除？如果不在副本中，它將改為列印到聊天視窗。";

L["dispelsMyCastPrintTitle"] = "在自己聊天視窗顯示";
L["dispelsMyCastPrintDesc"] = "將我的驅散列印到我自己的聊天視窗？";

L["dispelsMyCastRaidTitle"] = "在我的團隊回報";
L["dispelsMyCastRaidDesc"] = "在戰場或競技場啟用我的驅散訊息";

L["dispelsMyCastWorldTitle"] = "野外區散回報";
L["dispelsMyCastWorldDesc"] = "當不在團本或地城中啟用我的驅散訊息? 僅適用於 /說 和 螢幕顯示，以避免垃圾訊息。";

L["dispelsMyCastPvpTitle"] = "我的PVP事件";
L["dispelsMyCastPvpDesc"] = "Enable my dispel msgs inside battlegrounds and arena? Only works for /say and print so as not to spam group chat.";

L["dispelsOtherCastGroupTitle"] = "群組回報友方驅散";
L["dispelsOtherCastGroupDesc"] = "在團隊聊天中張貼其他友方玩家的驅散和激怒效果解除？僅在團隊和地下城中有效。";

L["dispelsOtherCastSayTitle"] = "/說 回報友方驅散";
L["dispelsOtherCastSayDesc"] = "在/say 中張貼其他友方玩家的驅散和激怒效果解除？僅在團隊和地下城中有效。";

L["dispelsOtherCastPrintTitle"] = "螢幕顯示友方驅散";
L["dispelsOtherCastPrintDesc"] = "將其他友方玩家的驅散列印到我自己的聊天視窗？";

L["dispelsOtherCastRaidTitle"] = "其他隊友驅散";
L["dispelsOtherCastRaidDesc"] = "在戰場和競技場中啟用其他玩家的驅散訊息？";

L["dispelsOtherCastWorldTitle"] = "野外其他隊友驅散";
L["dispelsOtherCastWorldDesc"] = "當不在團隊或地城中時，在外部世界中啟用其他玩家的驅散訊息？僅適用於/說和列印，以免發送垃圾訊息。";

L["dispelsOtherCastPvpTitle"] = "其他PVP事件";
L["dispelsOtherCastPvpDesc"] = "在戰場和競技場中啟用其他玩家的驅散訊息？僅適用於/說和列印，以免發送垃圾訊息。";

L["hunterDistractingShotGroupTitle"] = "誤導射擊團隊";
L["hunterDistractingShotGroupDesc"] = "將您的誤導射擊施放和目標顯示在團隊聊天中？";

L["hunterDistractingShotSayTitle"] = "誤導射擊說";
L["hunterDistractingShotSayDesc"] = "將您的誤導射擊施放和目標顯示在/say 中？";

L["hunterDistractingShotYellTitle"] = "誤導射擊吶喊";
L["hunterDistractingShotYellDesc"] = "將您的誤導射擊施放和目標顯示在/yell中？這將覆蓋/say，因此您不會同時發送兩者。";

L["sreShowDispelsTitle"] = "進攻驅散";
L["sreShowDispelsDesc"] = "顯示所有驅散（無論來源如何，驅散都會顯示，覆蓋團隊/我的/ NPC 設置）。";


L["raidCooldownChallengingRoarTitle"] = "挑戰咆哮";
L["raidCooldownChallengingRoarDesc"] = "顯示挑戰咆哮團隊冷卻時間？";

L["raidCooldownStarfallTitle"] = "星殞術";
L["raidCooldownStarfallDesc"] = "顯示星殞術團隊冷卻時間？";

L["raidCooldownFireElementalTitle"] = "火元素";
L["raidCooldownFireElementalDesc"] = "顯示火元素團隊冷卻時間？";										  

L["feastLeaderMsgTitle"] = "宴席通報";
L["feastLeaderMsgDesc"] = "當你是rl或是助手時放宴席時會通報。";

L["feastLeaderChannelTitle"] = "宴席頻道";
L["feastLeaderChannelDesc"] = "你想要在哪個頻道通報宴席。";

L["repairLeaderMsgTitle"] = "修裝訊息";
L["repairLeaderMsgDesc"] = "如果你是rl或是助手時，施放修理機器時通報?";
L["repairLeaderChannelTitle"] = "修裝訊息頻道";
L["repairLeaderChannelDesc"] = "你想要在哪個頻道通報修理機器。";

L["Buff Durations"] = "增益持續時間";
L["buffDurationsTooltip"] = "顯示增益持續時間「滑動」效果？";

L["raidStatusLowDurationTimeTitle"] = "增益持續時間低";
L["raidStatusLowDurationTimeDesc"] = "當增益低於此秒數時，增益會變黃色以警告您持續時間較短。";

--
L["Sources"] = "施放來源"
L["My Offensive Dispel Casts"] = "我的攻擊性驅散施放"
L["Other Players/Creatures Offensive Dispel Casts"] = "其他玩家/生物的攻擊性驅散施放"
--
L["Gold Given"] = "給予金錢"
L["Gold Received"] = "收到金錢"
L["Items Given"] = "給予物品"
L["Items Received"] = "收到物品"
L["Enchants"] = "附魔"


