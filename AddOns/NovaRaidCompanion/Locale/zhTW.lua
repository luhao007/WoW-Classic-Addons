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
L["inputValidSpellID"] = "Please input a valid spell ID number for scrolling raid events.";
L["inputLowerSpellIDRemove"] = "Please input valid spell ID number to remove.";
L["inputLowerSpellID"] = "Please input a lower valid spell ID.";
L["spellIDAlreadyCustomSpell"] = "Spell ID %s is already a custom spell.";
L["spellIDNotCustomSpell"] = "Spell ID %s was not found as a custom spell."
L["noSpellFoundWithID"] = "No spell found with ID %s";
L["notValidSpell"] = "Could not find spell ID %s, is this a valid spell?";
L["addedCustomScrollingSpell"] = "Added custom scrolling spell: %s %s";
L["removedScrollingCustomSpellID"] = "Removed ID%s %s%s from custom scrolling spells.";
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
L["The Cudgel of Kar'desh"] = "The Cudgel of Kar'desh";
L["Earthen Signet"] = "Earthen Signet";
L["Blazing Signet"] = "Blazing Signet";
L["The Vials of Eternity"] = "The Vials of Eternity";
L["Vashj's Vial Remnant"] = "Vashj's Vial Remnant";
L["Kael's Vial Remnant"] = "Kael's Vial Remnant";
L["An Artifact From the Past"] = "An Artifact From the Past";
L["Time-Phased Phylactery"] = "Time-Phased Phylactery";
L["alarCostumeMissing"] = "Missing Ashtongue Cowl costume for Black Temple attunment, click it now!"
L["attuneWarningSeerOlum"] = "Pick up Black Temple attune quest from Seer Olum!"

L["Raid Lockouts"] = "副本進度";
L["noCurrentRaidLockouts"] = "目前沒有任何副本進度。";
L["noAltLockouts"] = "沒有找到分身副本進度。";
L["holdShitForAltLockouts"] = "按住Shift顯示分身副本進度。";
L["leftClickMinimapButton"] = "點擊左鍵|r 打開團隊狀態";
L["rightClickMinimapButton"] = "點擊右鍵|r 打開出團紀錄";
L["shiftLeftClickMinimapButton"] = "Shift+點擊左鍵|r 打開交易紀錄";
L["shiftRightClickMinimapButton"] = "Shift+點擊右鍵|r 打開設置";
L["Merged"] = "合併";
L["mergedDesc"] = "Merge %s cooldowns? (Untick this if you want to see player cooldowns without needing mouseover)";
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
L["ShieldWall"] = "盾牆";
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

L["mergeRaidCooldownsTitle"] = "合併副本進度清單";
L["mergeRaidCooldownsDesc"] = "The raid cooldown list can show you all characters with tracked cooldowns at once OR you can enable this merge the list option so it only shows the cooldown spell names and you must hover over them to show each characters cooldowns.";

L["raidCooldownNumTypeTitle"] = "冷卻完成顯示類型";
L["raidCooldownNumTypeDesc"] = "Do you want to display only how many cooldowns are ready?\nOr do you want to display ready and total like 1/3?"

L["raidCooldownSpellsHeaderDesc"] = "要追蹤的職業冷卻";

L["raidCooldownsBackdropAlphaTitle"] = "背景透明度";
L["raidCooldownsBackdropAlphaDesc"] = "How transparent do you want the background to be?";

L["raidCooldownsBorderAlphaTitle"] = "邊框透明度";
L["raidCooldownsBorderpAlphaDesc"] = "How transparent do you want the border to be?";

L["raidCooldownsTextDesc"] = "按住Shift去拖動副本進度視窗。";

L["resetFramesTitle"] = "重置視窗";
L["resetFramesDesc"] = "重置所有視窗到螢幕中間及恢復預設大小。";

L["resetFramesMsg"] = "正在重置所有視窗的位置及大小。";

L["showMobSpawnedTimeTitle"] = "小怪重生時間";
L["showMobSpawnedTimeDesc"] = "Show how long ago a mob spawned when you target it? (More of a novelty feature, but can be interesting for certain things)";

--Raid cooldowns.
L["raidCooldownsMainTextDesc"] = "向下滾動。";

L["raidCooldownRebirthTitle"] = "復生";
L["raidCooldownRebirthDesc"] = "Show Rebirth raid cooldowns?";

L["raidCooldownInnervateTitle"] = "啟動";
L["raidCooldownInnervateDesc"] = "Show Innervate raid cooldowns?";

L["raidCooldownTranquilityTitle"] = "寧靜";
L["raidCooldownTranquilityDesc"] = "Show Tranquility raid cooldowns?";

L["raidCooldownMisdirectionTitle"] = "誤導";
L["raidCooldownMisdirectionDesc"] = "Show Misdirection raid cooldowns?";

L["raidCooldownEvocationTitle"] = "喚醒";
L["raidCooldownEvocationDesc"] = "Show Evocation raid cooldowns?";

L["raidCooldownIceBlockTitle"] = "寒冰屏障";
L["raidCooldownIceBlockDesc"] = "Show Ice Block raid cooldowns?";

L["raidCooldownInvisibilityTitle"] = "隱形術";
L["raidCooldownInvisibilityDesc"] = "Show Invisibility raid cooldowns?";

L["raidCooldownDivineInterventionTitle"] = "神聖干涉";
L["raidCooldownDivineInterventionDesc"] = "Show Divine Intervention raid cooldowns?";

L["raidCooldownDivineShieldTitle"] = "聖盾術";
L["raidCooldownDivineShieldDesc"] = "Show Divine Shield raid cooldowns?";

L["raidCooldownLayonHandsTitle"] = "聖療術";
L["raidCooldownLayonHandsDesc"] = "Show Lay on Hands raid cooldowns?";

L["raidCooldownFearWardTitle"] = "防護恐懼結界";
L["raidCooldownFearWardDesc"] = "Show Fear Ward raid cooldowns?";

L["raidCooldownShadowfiendTitle"] = "暗影惡魔";
L["raidCooldownShadowfiendDesc"] = "Show Shadowfiend raid cooldowns?";

L["raidCooldownPsychicScreamTitle"] = "心靈尖嘯";
L["raidCooldownPsychicScreamDesc"] = "Show Psychic Scream raid cooldowns?";

L["raidCooldownBlindTitle"] = "致盲";
L["raidCooldownBlindDesc"] = "Show Blind raid cooldowns?";

L["raidCooldownVanishTitle"] = "消失";
L["raidCooldownVanishDesc"] = "Show Vanish raid cooldowns?";

L["raidCooldownEvasionTitle"] = "閃避";
L["raidCooldownEvasionDesc"] = "Show Evasion raid cooldowns?";

L["raidCooldownDistractTitle"] = "擾亂";
L["raidCooldownDistractDesc"] = "Show Distract raid cooldowns?";

L["raidCooldownEarthElementalTitle"] = "土元素";
L["raidCooldownEarthElementalDesc"] = "Show EarthElemental Totem raid cooldowns?";

L["raidCooldownReincarnationTitle"] = "復生";
L["raidCooldownReincarnationDesc"] = "Show Reincarnation raid cooldowns?";

L["raidCooldownHeroismTitle"] = "英勇";
L["raidCooldownHeroismDesc"] = "Show Heroism raid cooldowns?";

L["raidCooldownBloodlustTitle"] = "嗜血術";
L["raidCooldownBloodlustDesc"] = "Show Bloodlust raid cooldowns?";

L["raidCooldownSoulstoneTitle"] = "靈魂石";
L["raidCooldownSoulstoneDesc"] = "Show soulstone raid cooldowns?";

L["raidCooldownSoulshatterTitle"] = "靈魂粉碎";
L["raidCooldownSoulshatterDesc"] = "Show Soulshatter raid cooldowns?";

L["raidCooldownDeathCoilTitle"] = "死亡纏繞";
L["raidCooldownDeathCoilDesc"] = "Show Death Coil raid cooldowns?";

L["raidCooldownRitualofSoulsTitle"] = "招喚餐桌";
L["raidCooldownRitualofSoulsDesc"] = "Show Ritual of Souls raid cooldowns?";

L["raidCooldownChallengingShoutTitle"] = "挑戰怒吼";
L["raidCooldownChallengingShoutDesc"] = "Show Challenging Shout raid cooldowns?";

L["raidCooldownIntimidatingShoutTitle"] = "破膽怒吼";
L["raidCooldownIntimidatingShoutDesc"] = "Show Intimidating Shout raid cooldowns?";

L["raidCooldownMockingBlowTitle"] = "懲戒痛擊";
L["raidCooldownMockingBlowDesc"] = "Show Mocking Blow raid cooldowns?";

L["raidCooldownRecklessnessTitle"] = "魯莽詛咒";
L["raidCooldownRecklessnessDesc"] = "Show Recklessness raid cooldowns?";

L["raidCooldownShieldWallTitle"] = "盾牆";
L["raidCooldownShieldWallDesc"] = "Show Shield Wall raid cooldowns?";

L["raidCooldownsSoulstonesTitle"] = "已綁定靈魂石";
L["raidCooldownsSoulstonesDesc"] = "Show extra frames to show who has a soulstone active on them?";

L["raidCooldownNeckBuffsTitle"] = "項鍊增益";
L["raidCooldownNeckBuffsDesc"] = "Show jewelcrafting neck buff cooldowns? This will show all players in your party no matter what class.";

L["acidGeyserWarningTitle"] = "酸液噴泉警告";
L["acidGeyserWarningDesc"] = "Warn in /say and middle of screen when a Underbog Colossus targets you with Acid Geyser?";

L["minimapButtonTitle"] = "顯示小地圖按鈕";
L["minimapButtonDesc"] = "Show NRC button on the minimap?";

L["raidStatusTextDesc"] = "按住Shift去拖動副本狀態視窗。";

L["raidStatusFlaskTitle"] = "藥劑";
L["raidStatusFlaskDesc"] = "Display a Flasks column on the Raid Status tracker?";

L["raidStatusFoodTitle"]= "食物";
L["raidStatusFoodDesc"]= "Display a Food column on the Raid Status tracker?";

L["raidStatusScrollTitle"]= "卷軸";
L["raidStatusScrollDesc"]= "Display a Scrolls column on the Raid Status tracker?";

L["raidStatusIntTitle"]= "智力";
L["raidStatusIntDesc"]= "Display a Arcane Intellect column on the Raid Status tracker?";

L["raidStatusFortTitle"]= "耐力";
L["raidStatusFortDesc"]= "Display a Power Word: Fortitude column on the Raid Status tracker?";

L["raidStatusSpiritTitle"]= "精神";
L["raidStatusSpiritDesc"]= "Display a Prayer of Spirit column on the Raid Status tracker?";

L["raidStatusShadowTitle"]= "暗抗增益";
L["raidStatusShadowDesc"]= "Display a Shadow Protection priest buff column on the Raid Status tracker?";

L["raidStatusMotwTitle"]= "爪子";
L["raidStatusMotwDesc"]= "Display a Mark of the Wild column on the Raid Status tracker?";

L["raidStatusPalTitle"]= "祝福";
L["raidStatusPalDesc"]= "Display a Paladin Blessings column on the Raid Status tracker?";

L["raidStatusDuraTitle"]= "耐久度";
L["raidStatusDuraDesc"]= "Display a Durability column on the Raid Status tracker?";

L["raidCooldownNecksHeaderDesc"] = "項鍊增益冷卻追蹤";

L["raidCooldownNeckSPTitle"] = "+34 法術能量";
L["raidCooldownNeckSPDesc"] = "Show party members cooldown for |cFF0070DD[Eye of the Night]|r (+34 Spell Power) necklace buff?";

L["raidCooldownNeckCritTitle"] = "+2% 法術爆擊";
L["raidCooldownNeckCritDesc"] = "Show party members cooldown for |cFF0070DD[Chain of the Twilight Owl]|r (+2% Crit) necklace buff?";

L["raidCooldownNeckCritRatingTitle"] = "+28 爆擊等級";
L["raidCooldownNeckCritRatingDesc"] = "Show party members cooldown for |cFF0070DD[Braided Eternium Chain]|r (+28 Crit Rating) necklace buff?";

L["raidCooldownNeckStamTitle"] = "+20 耐力";
L["raidCooldownNeckStamDesc"] = "Show party members cooldown for |cFF0070DD[Thick Felsteel Necklace]|r (+20 Stam) necklace buff?";

L["raidCooldownNeckHP5Title"] = "+6 5秒回血";
L["raidCooldownNeckHP5Desc"] = "Show party members cooldown for |cFF0070DD[Living Ruby Pendant]|r (+6 Health Per 5) necklace buff?";

L["raidCooldownNeckStatsTitle"] = "+10 屬性";
L["raidCooldownNeckStatsDesc"] = "Show party members cooldown for |cFF0070DD[Embrace of the Dawn]|r (+10 Stats) necklace buff?";

L["raidCooldownsNecksRaidOnlyTitle"] = "只在團隊追蹤項鍊";
L["raidCooldownsNecksRaidOnlyDesc"] = "Only show neck buff cooldowns when you're in a raid group and hide while in a party?";

L["Eating"] = "食用中"; --This can't be longer than 6 characters to fit in the raid status column.
L["Food"] = "食物";

L["raidStatusShowReadyCheckTitle"] = "在團確時顯示";
L["raidStatusShowReadyCheckDesc"] = "Auto show the reaid status frame when a readycheck is started?";

L["raidStatusFadeReadyCheckTitle"] = "隱藏團確完成";
L["raidStatusFadeReadyCheckDesc"] = "如果每個人都準備好了，在就團確完成幾秒鐘後淡出團隊狀態框？";

L["raidStatusHideCombatTitle"] = "戰鬥中隱藏";
L["raidStatusHideCombatDesc"] = "Auto hide the raid status frame when any combat starts?";

L["raidStatusColumsHeaderDesc"] = "顯示項目";

L["deleteEntry"] = "刪除紀錄";
L["deleteInstance"] = "刪除事件紀錄 %s (%s)。";
L["deleteInstanceError"] = "刪除事件 %s 錯誤。";

L["logDungeonsTitle"] = "記錄地城";
L["logDungeonsDesc"] = "Log dungeons also? Turn this off if you only want to record raids.";

L["logRaidsTitle"] = "記錄出團";
L["logRaidsDesc"] = "Log all 10/25/40 man raids.";

L["raidStatusShadowResTitle"] = "暗影抗性";
L["raidStatusShadowResDesc"] = "Display a Shadow Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusFireResTitle"] = "火焰抗性";
L["raidStatusFireResDesc"] = "Display a Fire Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusNatureResTitle"] = "自然抗性";
L["raidStatusNatureResDesc"] = "Display a Nature Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusFrostResTitle"] = "冰霜抗性";
L["raidStatusFrostResDesc"] = "Display a Frost Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusArcaneResTitle"] = "祕法抗性";
L["raidStatusArcaneResDesc"] = "Display a Arcane Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusWeaponEnchantsTitle"] = "武器附魔";
L["raidStatusWeaponEnchantsDesc"] = "Display a Weapon Enchants (oils/stones etc) column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusTalentsTitle"] = "天賦";
L["raidStatusTalentsDesc"] = "Display a Talents column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusExpandAlwaysTitle"] = "總是顯示更多";
L["raidStatusExpandAlwaysDesc"] = "Do you want to always show more when opening the raid status frame? So you don't need to click the More button.";

L["raidStatusExpandHeaderDesc"] = "更多";
L["raidStatusExpandTextDesc"] = "These are displayed when you click the \"More\" button on the raid status frame. To see raid members extra stats they must have NRC installed or the Nova Raid Companion Addon Helper weakaura at |cFF3CE13Fhttps://wago.io/sof4ehBA6|r";

L["raidStatusExpandTooltip"] = "|cFFFFFF00Click to show more data like spell resistances.|r\n|cFF9CD6DEGroup members without NRC must have the NRC Helper\nweakaura at https://wago.io/sof4ehBA6 to see more data.|r";

L["healthstoneMsgTitle"] = "治療石訊息";
L["healthstoneMsgDesc"] = "Show a msg in /say when you cast healthstones so people help click? This shows what rank you're casting also.";

L["summonMsgTitle"] = "招喚訊息";
L["summonMsgDesc"] = "Show a msg in group chat when you start summoning so people help click and so other locks can see who you're summong so as not to summon the same person?";

L["summonStoneMsgTitle"] = "集合石訊息";
L["summonStoneMsgDesc"] = "Show a msg in group chat when you use a summoning stone so people help click and so other people in raid can see who you're summong so as not to summon the same person?";

L["duraWarningTitle"] = "耐久度警告";
L["duraWarningDesc"] = "Show a durability warning in the chat window if you enter a raid with low armor durability?";

L["dataOptionsTextDesc"] = "資料合併及記錄儲存選項"

L["maxRecordsKeptTitle"] = "團隊紀錄資料庫大小";
L["maxRecordsKeptDesc"] = "Maximum amount of raids to keep in the database, increasing this to a large number may increase load time when opening the log window.";

L["maxRecordsShownTitle"] = "Raids Shown In Log";
L["maxRecordsShownDesc"] = "Maximum amount of raids to show in the raid log? You can set this lower than records kept if you only want to view a certain amount but still keep higher amouns of data.";
L["maxTradesKeptTitle"] = "交易紀錄資料庫大小";
L["maxTradesKeptDesc"] = "Maximum amount of trades to keep in the database, increasing this to a very large number may caus lag when opening the trade log.";

L["maxTradesShownTitle"] = "Trades Shown In Log";
L["maxTradesShownDesc"] = "Maximum amount of trades to show in the trade log? You can set this lower than records kept if you only want to view a certain amount but still keep higher amouns of data.";
L["showMoneyTradedChatTitle"] = "在聊天回報金錢交易";
L["showMoneyTradedChatDesc"] = "Show in trade when you give or receive gold from someone in the chat window? (Helps keep tack of who you have paid or received gold from in boost groups). |cFFFF0000WARNING: If you have Nova Instance Tracker installed already displaying trades in chat this won't work so you don't get duplicate msgs.|r";

L["attunementWarningsTitle"] = "任務物品提示";
L["attunementWarningsDesc"] = "在首領死亡後顯示提示時取任務物品?";

L["sortRaidStatusByGroupsColorTitle"] = "團隊上色";
L["sortRaidStatusByGroupsColorDesc"] = "If you enable sort by groups on the raid status window this will colorize them.";

L["sortRaidStatusByGroupsColorBackgroundTitle"] = "團隊背景上色";
L["sortRaidStatusByGroupsColorBackgroundDesc"] = "If you enable sort by groups and have colored enabled this will also color the background for the group.";


L["shadowNeckBTWarning"] = "你仍裝備著暗抗項鍊。";
L["pvpTrinketWarning"] = "你仍裝備PVP飾品。";
L["raidCooldownManaTideTitle"] = "法力之潮";
L["raidCooldownManaTideDesc"] = "Show Mana Tide raid cooldowns?";

L["raidCooldownPainSuppressionTitle"] = "痛苦鎮壓";
L["raidCooldownPainSuppressionDesc"] = "Show Pain Suppression raid cooldowns?";

L["raidCooldownPowerInfusionTitle"] = "能量灌注";
L["raidCooldownPowerInfusionDesc"] = "Show Power Infusion raid cooldowns?";

L["raidCooldownBlessingofProtectionTitle"] = "保護祝福";
L["raidCooldownBlessingofProtectionDesc"] = "Show Blessing of Protection raid cooldowns?";

L["raidCooldownHandofProtectionTitle"] = "保護之手";
L["raidCooldownHandofProtectionDesc"] = "Show Hand of Protection raid cooldowns?";

L["soulstoneMsgSayTitle"] = "靈魂石訊息(說)";
L["soulstoneMsgSayDesc"] = "Show a msg in /say when you cast a soulstone on someone?";

L["soulstoneMsgGroupTitle"] = "靈魂石訊息(團隊)";
L["soulstoneMsgGroupDesc"] = "Show a msg in group chat when you cast a soulstone on someone?";

L["showInspectTalentsTitle"] = "顯示天賦觀察"
L["inspectTalentsCheckBoxTooltip"] = "是否在你觀察其他人時顯示NRC天賦視窗？";

L["cooldownFrameCountTitle"] = "多少冷卻清單";
L["cooldownFrameCountDesc"] = "How many seperate cooldown lists do you want? You can have multiple lists to put in different places and assign different cooldowns to each list. Assign each spell to a list below, click Test to show all you have enabled.";

L["testRaidCooldownsDesc"] = "Test the cooldown frames for 30 seconds so you can configure them or hold shift to drag them. Change any options here while the test runs to see what it looks like.";

L["raidStatusScaleTitle"] = "團隊狀態視窗大小";
L["raidStatusScaleDesc"] = "Set the raid status window size scale here.";

L["holdShitForExtraInfo"] = "按住Shift顯示更多資訊";

L["timeStampFormatTitle"] = "時間格式";
L["timeStampFormatDesc"] = "Set which timestamp format to use, 12 hour (1:23pm) or 24 hour (13:23). For things like the 3 day raid reset cycle when you hold shift on the minimap button.";

L["Completed quest"] = "你已經 |cFF00C800完成|r 這個任務。";
L["Not completed quest"] = "You have |cFFFF2222not completed|r this quest";

L["raidCooldownsGrowthDirectionTitle"] = "生長方向";
L["raidCooldownsGrowthDirectionDesc"] = "Which way do you want the list to grow?"

L["raidCooldownsScaleTitle"] = "大小";
L["raidCooldownsScaleDesc"] = "How big do you want the cooldown list to be?";

L["raidCooldownsBorderTypeTitle"] = "外框樣式";
L["raidCooldownsBorderTypeDesc"] = "What type of border do you want around the frames?"

L["raidCooldownsSoulstonesPositionTitle"] = "靈魂石位置";
L["raidCooldownsSoulstonesPositionDesc"] = "Where do you want active soulstones to show?"

L["meTransferedThreatMD"] = "%s 仇恨被誤導到 %s."; --These are a little different for different places.
L["otherTransferedThreatMD"] = "%s 誤導 %s 仇恨到 %s."; --These are a little different for different places.
L["meTransferedThreatTricks"] = "%s threat tricked to %s."; --These are a little different for different places.
L["otherTransferedThreatTricks"] = "%s tricked %s threat to %s."; --These are a little different for different places.

L["meCastSpellOn"] = "施放 %s 在 %s"; --Capitalize these properly if translating.
L["otherCastSpellOn"] = "%s 施放 %s 在 %s"; --Capitalize these properly if translating.
L["spellCastOn"] = "%s 施放在 %s";

L["mdSendMyCastGroupTitle"] = "團隊回報我的誤導";
L["mdSendMyCastGroupDesc"] = "Show my misdirection casts in group chat?";

L["mdSendMyCastSayTitle"] = "/說 回報我的誤導";
L["mdSendMyCastSayDesc"] = "Show my misdirection casts in /say? Only works in instances.";

L["mdSendOtherCastGroupTitle"] = "回報隊友的誤導";
L["mdSendOtherCastGroupDesc"] = "Show other players misdirection casts in group chat? You should only use this if no other hunters in the raid have an addon showing their MD.";

L["mdSendMyThreatGroupTitle"] = "團隊回報我的誤導仇恨";
L["mdSendMyThreatGroupDesc"] = "Show how much misdirection threat I transfered to the tank in group chat?";

L["mdSendMyThreatSayTitle"] = "/說 回報我的誤導仇恨";
L["mdSendMyThreatSayDesc"] = "Show how much misdirection threat I transfered to the tank in /say? Only works in instances.";

L["mdSendOthersThreatGroupTitle"] = "團隊回報隊友誤導仇恨";
L["mdSendOthersThreatGroupDesc"] = "Show how much misdirection threat other players transfered to the tank in group chat? You should only use this if no other hunters in the raid have an addon showing their threat transfer.";

L["mdSendOthersThreatSayTitle"] = "/說 回報隊友誤導仇恨";
L["mdSendOthersThreatSayDesc"] = "Show how much misdirection threat other players transfered to the tank in /say? You should only use this if no other hunters in the raid have an addon showing their threat transfer. Only works in instances.";

L["mdShowMySelfTitle"] = "顯示我的仇恨轉移";
L["mdShowMySelfDesc"] = "Show how much misdirection I transfered to the tank in your chat window so only you can see?";

L["mdShowOthersSelfTitle"] = "顯示隊友的仇恨轉移";
L["mdShowOthersSelfDesc"] = "Show how much misdirection other players transfered to the tank in your chat window so only you can see?";

L["mdShowSpellsTitle"] = "顯示誤導時的傷害技能";
L["mdShowSpellsDesc"] = "Print to your chat window which spells were used during the misdirection? Only you see this msg.";

L["mdShowSpellsOtherTitle"] = "顯示隊友誤導時的傷害技能";
L["mdShowSpellsOtherDesc"] = "Print to your chat window which spells were used by other hunters during the misdirection? Only you see this msg.";
					
L["mdSendTargetTitle"] = "密語目標轉移仇恨";
L["mdSendTargetDesc"] = "Send threat amount tranfered from your misdirection to the target via whisper?";

L["mdMyTextDesc"] = "顯示您的誤導仇恨轉移到坦克的選項。";
L["mdOtherTextDesc"] = "顯示團隊中的其他獵人誤導仇恨到坦克的選項。";
L["mdLastTextDesc"] = "There's also a /lastmd command to show group chat the spells used for the last misdirection, you can do /lastmd to show last used, /lastmd <name> to show last by name, and /lastmd list to show who has a md recorded to pick from.";
L["raidCooldownsDisableMouseTitle"] = "關閉滑鼠提示";
L["raidCooldownsDisableMouseDesc"] = "This will disable empty cooldown lists from showing when you mouseover them while they have no cooldowns showing, this means you will need to click the test button to move them instead.";

L["raidCooldownsSortOrderTitle"] = "排序方式";
L["raidCooldownsSortOrderDesc"] = "How would you like the cooldowns bars to be sorted?";																 

L["autoCombatLogTitle"] = "自動開啟戰鬥紀錄";
L["autoCombatLogDesc"]= "Turn on combat logging whenever you enter a raid so it can used for sites like warcraft logs.";

L["cauldronMsgTitle"] = "施放大鍋提示";
L["cauldronMsgDesc"] = "Put a msg in /say when you drop a cauldron in raid?";

L["sreMainTextDesc"] = "捲到下方來新增自訂法術。"
L["sreCustomSpellsHeaderDesc"] = "自訂追蹤法術";

L["sreLineFrameScaleTitle"] = "訊息大小";
L["sreLineFrameScaleDesc"] = "How big do you want the text and icons to be?";

L["sreScrollHeightTitle"] = "滾動軸高度";
L["sreScrollHeightDesc"] = "How far do you want the messages to scroll (Unlock the frames or cick test before setting this so you can see the height).";

L["sreEnabledTitle"] = "啟動";
L["sreEnabledDesc"] = "Enable or disable scrolling raid events being shown on your screen.";

L["sreEnabledEverywhereTitle"] = "任何地方";
L["sreEnabledEverywhereDesc"] = "Enabled everywhere including outside of raids (Except Arena/Battlegounrds, they have own config option).";

L["sreEnabledRaidTitle"] = "地城與團隊";
L["sreEnabledRaidDesc"] = "Enabled inside raids and dungeons.";

L["sreEnabledPvPTitle"] = "PvP 區域";
L["sreEnabledPvPDesc"] = "Enabled in battlegrounds and arenas.";

L["sreGroupMembersTitle"] = "團隊成員施法";
L["sreGroupMembersDesc"] = "Show group members spells? You can tick the \"All Players Spells\" if you want to see players even not in your group.";

L["sreShowSelfTitle"] = "我的法術";
L["sreShowSelfDesc"] = "Show spells that I cast also.";

L["sreShowSelfRaidOnlyTitle"] = "只在團隊中顯是我的法術";
L["sreShowSelfRaidOnlyDesc"] = "Show spells that I cast also only when inside raids/dungeons, this is here so you have the module enabled anywhere and not see your own spells out in the open world.";

L["sreAllPlayersTitle"] = "所有玩家的法術";
L["sreAllPlayersDesc"] = "Show players not in your group casting spells in the world? Requires \"Everywhere\" to also be enabled.";

L["sreNpcsTitle"] = "NPCs";
L["sreNpcsDesc"] = "Show NPC spells being cast? You can add custom spells below.";

L["sreNpcsRaidOnlyTitle"] = "只在副本中顯示NPC法術";
L["sreNpcsRaidOnlyDesc"] = "Show NPC spells being cast on when inside a raids/dungeons.";

L["sreGrowthDirectionTitle"] = "文字滾動方向";
L["sreGrowthDirectionDesc"] = "Which direction do you want the msgs to scroll?";

L["sreAddRaidCooldownsToSpellListTitle"] = "新增團隊冷卻";
L["sreAddRaidCooldownsToSpellListDesc"] = "Add all your enabled spells from the Raid Cooldowns tracker?";

L["sreShowCooldownResetTitle"] = "重置冷卻倒數";
L["sreShowCooldownResetDesc"] = "If you have the Raid Cooldowns tracker enabled you can also enable this option to show when those cooldowns reset and come off cooldown.";

L["sreShowInterruptsTitle"] = "打斷";
L["sreShowInterruptsDesc"] = "Show all interrupts (Intterupts will show no matter the source, overriding Group/Mine/NPCs settings).";

L["sreShowCauldronsTitle"] = "大鍋";
L["sreShowCauldronsDesc"] = "Cauldrons being placed on the group for you to pick up potions.";

L["sreShowSoulstoneResTitle"] = "使用靈魂石";
L["sreShowSoulstoneResDesc"] = "Show when a player uses a soulstone to resurrect.";

L["sreShowManaPotionsTitle"] = "法力藥水";
L["sreShowManaPotionsDesc"]	= "Show Mana potion usage. Includes Dark Runes and Dreamless Sleep potions.";

L["sreShowHealthPotionsTitle"] = "治療藥水";
L["sreShowHealthPotionsDesc"] = "Show Health potion usage.";

L["sreShowDpsPotionsTitle"] = "爆發及防護藥水";
L["sreShowDpsPotionsDesc"] = "Show dps and armor/protection option usage. This includes things like destruction/haste/ironshield/invisibilty potions.";

L["sreShowMagePortalsTitle"] = "法師傳送門";
L["sreShowMagePortalsDesc"]	= "Show mage portal casts, be tricked no more by those pesky mages!";

L["sreShowResurrectionsTitle"] = "復活";
L["sreShowResurrectionsDesc"] = "Show players resurrecting others.";

L["sreShowMisdirectionTitle"] = "誤導仇恨";
L["sreShowMisdirectionDesc"] = "Show how much threat a hunter misdirect sends to the tank.";

L["sreShowSpellNameTitle"] = "顯示法術名稱";
L["sreShowSpellNameDesc"] = "Show spell name in the text shown.";

L["sreOnlineStatusTitle"] = "上線/離線 狀態";
L["sreOnlineStatusDesc"] = "Show group members coming online and going offline..";

L["sreAlignmentTitle"] = "文字對齊";
L["sreAlignmentDesc"] = "Grow msgs from the left, middle, or right?";

L["sreAnimationSpeedTitle"] = "滾動軸動畫速度";
L["sreAnimationSpeedDesc"] = "How fast do you want the events to scroll by?";

L["sreAddSpellTitle"] = "新增自訂法術ID";
L["sreAddSpellDesc"] = "Add a custom spell here, input the spell ID for which spell you want to see cast. You can get the spell ID for any spell by searching for it on wowhead and looking at the number in the website URL.";

L["sreRemoveSpellTitle"] = "移除自訂法術ID";
L["sreRemoveSpellDesc"] = "Remove a custom spell here, input the spell ID to remove here.";

L["You can't delete log entries while inside an instance."] = "你無法刪除你正在進行的副本紀錄。";

L["consumesEncounterTooltip"] = "選擇顯示方式";
L["consumesPlayersTooltip"] = "選擇一個玩家或全部玩家。";
L["consumesViewTooltip"] = "View a timeline of usage or a total count";

L["itemUseShowConsumesTooltip"] = "顯示基本消耗品";
L["itemUseShowScrollsTooltip"] = "顯示卷軸";
L["itemUseShowInterruptsTooltip"] = "Show interrupts\n(Duplicate interrupt icons are different ranks)";
L["itemUseShowRacialsTooltip"] = "顯示種族";
L["itemUseShowFoodTooltip"] = "顯示食物";

L["autoSunwellPortalTitle"] = "太陽井傳送";
L["autoSunwellPortalDesc"] = "Auto take the Sunwell teleport when you talk to NPC, this takes the furtherest portal.";

L["Taking Sunwell teleport."] = "太陽井自動傳送。";

L["lockAllFramesTitle"] = "鎖定所有視窗";
L["lockAllFramesDesc"] = "Lock and Unlock all frames so you can move them around (You can also type /nrc lock and /nrc unlock).";

L["testAllFramesTitle"] = "測試所有視窗";
L["testAllFramesDesc"] = "Run a 30 second test on all frames with your current settings.";

L["resetAllFramesTitle"] = "重置所有視窗";
L["resetAllFramesDesc"] = "Reset all frames back to default position.";

L["raidManaMainTextDesc"] = "簡易監看所有出團補師的魔量。";

L["raidManaEnabledTitle"] = "啟用";
L["raidManaEnabledDesc"] = "Enable the raid mana module.";

L["raidManaEnabledEverywhereTitle"] = "所有地方";
L["raidManaEnabledEverywhereDesc"] = "Enabled everywhere including outside of raids (Except Arena/Battlegounrds, they have own config option).";

L["raidManaEnabledRaidTitle"] = "團本/地城";
L["raidManaEnabledRaidDesc"] = "Enabled inside raids and dungeons.";

L["raidManaEnabledPvPTitle"] = "PvP";
L["raidManaEnabledPvPDesc"] = "Enabled in battlegrounds and arenas.";

L["raidManaAverageTitle"] = "競技場魔量";
L["raidManaAverageDesc"] = "Show the average mana of all players shown if more than one player is shown.";

L["raidManaShowSelfTitle"] = "顯示我的魔量";
L["raidManaShowSelfDesc"] = "Show my own mana too if I am a healer or on an enabled class below?";

L["raidManaScaleTitle"] = "大小";
L["raidManaScaleDesc"] = "How big do you want the raid mana frame to be?";

L["raidManaGrowthDirectionTitle"] = "生長方向";
L["raidManaGrowthDirectionDesc"] = "Which direction do you want the list to grow?";

L["raidManaBackdropAlphaTitle"] = "背景透明度";
L["raidManaBackdropAlphaDesc"] = "How transparent do you want the background to be?";

L["raidManaBorderAlphaTitle"] = "邊框透明度";
L["raidManaBorderAlphaDesc"] = "How transparent do you want the border to be?";

L["raidManaUpdateIntervalTitle"] = "Update Interval";
L["raidManaUpdateIntervalDesc"] = "How fast do you want the frame to update, every 0.1 to 1 second.";

L["raidManaSortOrderTitle"] = "排序方式";
L["raidManaSortOrderDesc"] = "Pick how you would like to sort the mana display.";

L["raidManaFontTitle"] = "姓名字體";
L["raidManaFontDesc"] = "Font used to display player names. Warning: Fonts have different widths and some fonts may not fit correctly in these small frames trying to fit a lot of info.";

L["raidManaFontNumbersTitle"] = "數字字體";
L["raidManaFontNumbersDesc"] = "Font used to display percentage numbers. Warning: Fonts have different widths and some fonts may not fit correctly in these small frames trying to fit a lot of info.";

L["raidManaResurrectionTitle"] = "顯示復活";
L["raidManaResurrectionDesc"] = "Show when a healer is casting resurrect beside their name.";

L["raidManaResurrectionDirTitle"] = "復活方向";
L["raidManaResurrectionDirDesc"] = "Which side of the frame to display resurrections, \"Auto\" means it will show right or left depending on what side of your UI you have the frame on.";

L["raidManaHealersTitle"] = "顯示所有補師";
L["raidManaHealersDesc"] = "Show mana for all healers in this raid, this uses NRC talent detection to find real healers for accuracy. You may need to be in range of a player at least once during a raid so their talents can be detected for them to show as a healer.";

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
L["raidCooldownsFontDesc"] = "Font used to display player/cooldown names. Warning: Fonts have different widths and some fonts may not fit correctly in these small frames trying to fit a lot of info.";

L["raidCooldownsFontNumbersTitle"] = "數字字體";
L["raidCooldownsFontNumbersDesc"] = "Font used to display cooldowns ready numbers. Warning: Fonts have different widths and some fonts may not fit correctly in these small frames trying to fit a lot of info.";

L["checkMetaGemTitle"] = "檢查變換寶石";
L["checkMetaGemDesc"] = "如果你的變換寶石沒有啟動，出現警告訊息?";

L["raidCooldownsFontSizeTitle"] = "字體大小";
L["raidCooldownsFontSizeDesc"] = "How big do you want the font to be?";

L["raidCooldownsWidthTitle"] = "寬度";
L["raidCooldownsWidthDesc"] = "How wide do you want each bar to be?";

L["raidCooldownsHeightTitle"] = "高度";
L["raidCooldownsHeightDesc"] = "How high do you want each bar to be?";

L["raidManaFontSizeTitle"] = "字體大小";
L["raidManaFontSizeDesc"] = "How big do you want the font to be?";

L["raidManaWidthTitle"] = "寬度";
L["raidManaWidthDesc"] = "How wide do you want each bar to be?";

L["raidManaHeightTitle"] = "高度";
L["raidManaHeightDesc"] = "How high do you want each bar to be?";

L["raidCooldownsFontOutlineTitle"] = "字體邊框";
L["raidCooldownsFontOutlineDesc"] = "Do you want raid cooldowns font to have an outline?";

L["sreFontOutlineTitle"] = "字體邊框";
L["sreFontOutlineDesc"] = "Do you want scrolling events font to have an outline?";

L["raidManaFontOutlineTitle"] = "字體邊框";
L["raidManaFontOutlineDesc"] = "Do you want raid mana font to have an outline?";

L["Thick Outline"] = "粗邊框";
L["Thin Outline"] = "細邊框";

L["sreFontTitle"] = "字體";								
L["raidStatusFontTitle"] = "字體";
L["raidStatusFontDesc"] = "Raid status font. Warning: Fonts have different widths and some fonts may not fit correctly in these small frames trying to fit a lot of info, adjust dont dize if you need to.";

L["raidStatusFontSizeTitle"] = "字體大小";
L["raidStatusFontSizeDesc"] = "How big do you want the font to be?";

L["raidStatusFontOutlineTitle"] = "字體邊框";
L["raidStatusFontOutlineDesc"] = "Do you want raid status font to have an outline?";

L["tricksSendMyCastGroupTitle"] = "團頻回報我的偷天";
L["tricksSendMyCastGroupDesc"] = "Show my tricks casts in group chat?";

L["tricksSendMyCastSayTitle"] = "/說 回報我的偷天";
L["tricksSendMyCastSayDesc"] = "Show my tricks of the trade casts in /say? Only works in instances.";

L["tricksSendOtherCastGroupTitle"] = "回報隊友偷天";
L["tricksSendOtherCastGroupDesc"] = "Show other players tricks casts in group chat? You should only use this if no other rogues in the raid have an addon showing their tricks.";

L["tricksSendMyThreatGroupTitle"] = "團頻回報我的偷天仇恨";
L["tricksSendMyThreatGroupDesc"] = "Show how much tricks threat I transfered to the tank in group chat?";

L["tricksSendMyThreatSayTitle"] = "/說 回報我的偷天仇恨";
L["tricksSendMyThreatSayDesc"] = "Show how much tricks threat I transfered in /say? Only works in instances.";

L["tricksSendOthersThreatGroupTitle"] = "回報隊友偷天仇恨";
L["tricksSendOthersThreatGroupDesc"] = "Show how much tricks threat other rogues transfered in group chat?";

L["tricksSendOthersThreatSayTitle"] = "/說 回報隊友偷天仇恨";
L["tricksSendOthersThreatSayDesc"] = "Show how much tricks threat other players transfered in /say?";

L["tricksShowMySelfTitle"] = "顯示偷天仇恨";
L["tricksShowMySelfDesc"] = "Show how much threat I transfered in your chat window so only you can see?";

L["tricksShowOthersSelfTitle"] = "顯示隊友偷天仇恨";
L["tricksShowOthersSelfDesc"] = "Show how much tricks other rogues transfered to the tank in your chat window so only you can see?";

L["tricksShowSpellsTitle"] = "顯示偷天時使用的傷害技能";
L["tricksShowSpellsDesc"] = "Print to your chat window which spells were used during the tricks? Only you see this msg, it may be a bit spammy.";

L["tricksShowSpellsOtherTitle"] = "顯示隊友偷天時使用的傷害技能";
L["tricksShowSpellsOtherDesc"] = "Print to your chat window which spells were used by other rogues during their tricks? Only you see this msg, it may be a bit spammy.";
		
L["tricksSendTargetTitle"] = "密語轉移仇恨的目標";
L["tricksSendTargetDesc"] = "Send threat amount transfered from your threat to the target via whisper?";

L["tricksMyTextDesc"] = "顯示你的偷天轉移了多少仇恨的選項。";
L["tricksOtherTextDesc"] = "顯示隊友的偷天轉移了多少仇恨的選項。";
L["tricksLastTextDesc"] = "There's also a /lasttricks command to show group chat the spells used for the last tricks, you can do /lasttricks to show last used, /lasttricks <name> to show last by name, and /lasttricks list to show who has a tricks recorded to pick from.";
L["tricksDamageTextDesc"] = "顯示你的15%增傷目標得到多少額外傷害的選項。.";

L["tricksSendDamageGroupTitle"] = "團頻回報你偷天的額外傷害";
L["tricksSendDamageGroupDesc"] = "團頻回報你偷天的目標多了多少額外傷害。";

L["tricksSendDamageGroupOtherTitle"] = "回報隊友偷天的額外傷害";
L["tricksSendDamageGroupOtherDesc"] = "團頻回報隊友的偷天目標增加了多少額外傷害。";

L["tricksSendDamageWhisperTitle"] = "密語傷害給偷天目標";
L["tricksSendDamageWhisperDesc"] = "密語你的偷天目標他增加了多少額外傷害。";

L["tricksSendDamagePrintTitle"] = "顯示你的額外傷害";
L["tricksSendDamagePrintDesc"] = "Print to chat window the extra damage your tricks target did with your buff.";

L["tricksSendDamagePrintOtherTitle"] = "顯示隊友的額外傷害";
L["tricksSendDamagePrintOtherDesc"] = "Print to chat window the extra damage other rogues tricks did with their buff to anyone in the raid.";

L["tricksOtherRoguesMineGainedTitle"] = "顯示我從其他盜賊得到的額外傷害";
L["tricksOtherRoguesMineGainedDesc"] = "If a rogue casts tricks on me then print how much damage I gained? Works for all classes.";

L["tricksOnlyWhenDamageTitle"] = "傷害大於0顯示";
L["tricksOnlyWhenDamageDesc"] = "Only show msgs when damage is greater than 0.";

L["otherTransferedDamageMyTricks"] = "%s 從我的偷天得到 %s 額外傷害。";
L["otherTransferedDamageOtherTricks"] = "%s 得到 %s 額外傷害，從 %s 的偷天。";
L["meTransferedThreatTricksWhisper"] = "你獲得 %s 額外傷害從我的偷天換日。";
L["otherTransferedDamageTricksMine"] = "你獲得 %s 額外傷害，從 %s 的偷天換日。";

--Wrath cooldowns.
L["raidCooldownArmyoftheDeadTitle"] = "亡靈大軍";
L["raidCooldownArmyoftheDeadDesc"] = "Show Army of the Dead raid cooldowns?";

L["raidCooldownIceboundFortitudeTitle"] = "冰錮堅韌";
L["raidCooldownIceboundFortitudeDesc"] = "Show Icebound Fortitude raid cooldowns?";

L["raidCooldownAntiMagicZoneTitle"] = "反魔法力場";
L["raidCooldownAntiMagicZoneDesc"] = "Show Anti Magic Zone raid cooldowns?";

L["raidCooldownUnholyFrenzyTitle"] = "邪惡狂熱";
L["raidCooldownUnholyFrenzyDesc"] = "Show Unholy Frenzy raid cooldowns?";

L["raidCooldownDivineSacrificeTitle"] = "神性犧牲";
L["raidCooldownDivineSacrificeDesc"] = "Show Divine Sacrifice raid cooldowns?";

L["raidCooldownAuraMasteryTitle"] = "精通光環";
L["raidCooldownAuraMasteryDesc"] = "Show Aura Mastery raid cooldowns?";

L["raidCooldownDivineHymnTitle"] = "神聖禮頌";
L["raidCooldownDivineHymnDesc"] = "Show Divine Hymn raid cooldowns?";

L["raidCooldownHymnofHopeTitle"] = "希望禮頌";
L["raidCooldownHymnofHopeDesc"] = "Show Hymn of Hope raid cooldowns?";

L["raidCooldownGuardianSpiritTitle"] = "守護聖靈";
L["raidCooldownGuardianSpiritDesc"] = "Show Guardian Spirit raid cooldowns?";

L["raidCooldownTricksoftheTradeTitle"] = "偷天換日";
L["raidCooldownTricksoftheTradeDesc"] = "Show Tricks of the Trade raid cooldowns?";

L["raidCooldownBladestormTitle"] = "劍刃風暴";
L["raidCooldownBladestormDesc"] = "Show Bladestorm raid cooldowns?";

L["raidCooldownShatteringThrowTitle"] = "碎甲投擲";
L["raidCooldownShatteringThrowDesc"] = "Show Shattering Throw raid cooldowns?";											  

L["lowAmmoWarning"] = "低彈藥 (%s).";

L["lowAmmoCheckTitle"] = "低彈藥確認";
L["lowAmmoCheckDesc"] = "Wanrs you if you are running low on ammo, counts whatever ammo you have equipped and will warn you in chat with a 15min warning cooldown.";

L["lowAmmoCheckThresholdTitle"] = "低彈藥數值";
L["lowAmmoCheckThresholdDesc"] = "Below how much ammo should you get a warning?";

L["exportTypeTooltip"] = "輸出格式";

L["changeLootEntry"] = "Set looter for entry %s";
L["renamedLootEntry"] = "改變時取 %s 給 %s 從 %s";
L["clearedLootEntry"] = "Cleared loot override entry %s";
L["mapTradesToLootTooltip"] = "Attempt to automatically show who looted\nas the person you traded the item to during raid.\n(Only works if you were the person looting)\nRight clicking an entry to edit overrides this."

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
