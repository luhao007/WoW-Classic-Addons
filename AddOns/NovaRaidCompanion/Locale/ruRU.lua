local L = LibStub("AceLocale-3.0"):NewLocale("NovaRaidCompanion", "ruRU");
if (not L) then
	return;
end

L["second"] = "сек"; --Second (singular).
L["seconds"] = "сек"; --Seconds (plural).
L["minute"] = "мин"; --Minute (singular).
L["minutes"] = "мин"; --Minutes (plural).
L["hour"] = "ч"; --Hour (singular).
L["hours"] = "ч"; --Hours (plural).
L["day"] = "д"; --Day (singular).
L["days"] = "д"; --Days (plural).
L["secondShort"] = "с"; --Used in short timers like 1m30s (single letter only, usually the first letter of seconds).
L["minuteShort"] = "м"; --Used in short timers like 1m30s (single letter only, usually the first letter of minutes).
L["hourShort"] = "ч"; --Used in short timers like 1h30m (single letter only, usually the first letter of hours).
L["dayShort"] = "д"; --Used in short timers like 1d8h (single letter only, usually the first letter of days).
L["startsIn"] = "Начнется через %s"; --"Starts in 1hour".
L["endsIn"] = "Закончится через %s"; --"Ends in 1hour".
L["versionOutOfDate"] = "Ваша версия аддона Nova Raid Companion устарела. Пожалуйста, обновите ее по ссылке https://www.curseforge.com/wow/addons/nova-raid-companion или через Twitch-клиент";
L["Options"] = "Настройки";
L["None"] = "None.";
L["Drink"] = "Питье";
L["Food"] = "Пища";
L["Refreshment"] = "Яства";

L["None found"] = "None found";
L["Reputation"] = "Reputation";
L["logEntryTooltip"] = "Left Click to view log %s.\nRight Click to rename.";
L["logEntryFrameTitle"] = "Rename log entry %s";
L["renamedLogEntry"] = "Renamed log entry %s to %s";
L["clearedLogEntryName"] = "Cleared set name for log entry %s";
L["tradeFilterTooltip"] = "|cFFFFFF00Enter any of the following:|r\n|cFF9CD6DEYour character name.\nOther player name or item name.\nGold amount.";
L["deleteInstanceConfirm"] = "Delete instance %s from the raid log?"
L["noRaidsRecordedYet"] = "No raids recorded yet, do a raid and check back here.";
L["Boss Journal"] = "Boss Journal"
L["Config"] = "Config"
L["Lockouts"] = "Lockouts"
L["Trades"] = "Trades";
L["All Trades"] = "All Trades";
L["tradesForSingleRaid"] = "Trades during %s raid (Log %s)";
L["Set"] = "Set";
L["Reset"] = "Reset";
L["Clear"] = "Clear";
L["Filter"] = "Filter";
L["Groups"] = "Groups";
L["sortByGroupsTooltip"] = "Sort by groups?";
L["Gave"] = "Gave";
L["Received"] = "Received";
L["to"] = "to";
L["from"] = "from";
L["for"] = "for";
L["with"] = "with";
L["on"] = "on";
L["at"] = "at";
L["Enchant"] = "Enchant";
L["Enchanted"] = "Enchanted";
L["Gold"] = "Gold";
L["gold"] = "gold";
L["silver"] = "silver";
L["copper"] = "copper";
L["Warning"] = "Warning";
L["Reminder"] = "Reminder";
L["Item"] = "Item";
L["Items"] = "Items";
L["Less"] = "Less";
L["More"] = "More";
L["Raid Log"] = "Raid Log";
L["Deaths"] = "Deaths";
L["Total Deaths"] = "Total Deaths";
L["Boss"] = "Boss";
L["Bosses"] = "Bosses";
L["On Bosses"] = "On Bosses";
L["On Trash"] = "On Trash";
L["Loot Count"] = "Loot Count";
L["Total Loot"] = "Total Loot";
L["Trash"] = "Trash";
L["Loot"] = "Loot";
L["3D Model"] = "3D Model";
L["Buff Snapshot"] = "Buff Snapshot";
L["Raid"] = "Raid";
L["Consumes"] = "Consumes";
L["Raid"] = "Raid";
L["Start of first boss to end of last boss"] = "Start of first boss to end of last boss";
L["From first trash kill"] = "From first trash kill";
L["Inside"] = "Inside";
L["Mobs"] = "Mobs";
L["Wipe"] = "Wipe";
L["Wiped"] = "Wiped";
L["Wipes"] = "Wipes";
L["Kill"] = "Kill";
L["No encounters recorded."] = "No encounters recorded.";
L["Entered"] = "Entered";
L["Left"] = "Left";
L["First trash"] = "First trash";
L["Still inside"] = "Still inside";
L["Duration"] = "Duration";
L["Time spent in combat"] = "Time spent in combat";
L["Kills"] = "Kills";
L["Total"] = "Total";
L["During Bosses"] = "During Bosses";
L["During Trash"] = "During Trash";
L["Other NPCs"] = "Other NPCs";
L["hit"] = "hit"; --Illidan Stormrage Aura of Dread hit You 1000 Shadow. 
L["Talent Snapshot for"] = "Talent Snapshot for";
L["No talents found"] = "No talents found";
L["Click to view talents"] = "Click to view talents";
L["traded with"] = "traded with";
L["No trades matching current filter"] = "No trades matching current filter";
L["No trades recorded yet"] = "No trades recorded yet";
L["Boss model not found"] = "Boss model not found";
L["Class"] = "Class";
L["Health"] = "Health";
L["Type"] = "Type";
L["Raid Lockouts (Including Alts)"] = "Raid Lockouts (Including Alts)";
L["Your durability is at"] = "Your durability is at";
L["Summoning"] = "Summoning"; --Summoning player to location, click!
L["click!"] = "click!";	--Summoning player to location, click!
L["Healthstones"] = "Healthstones";
L["Ready"] = "Ready";
L["Target Spawn Time Frame"] = "Target Spawn Time Frame";
L["Spawned"] = "Spawned";
L["Hold Shift To Drag"] = "Hold Shift To Drag";
L["Cast on"] = "Cast on"; --Spell cast on player.
L["Current active soulstones"] = "Current active soulstones";
L["left"] = "left"; --As in time left.
L["Cast by"] = "Cast by";
L["NRC Raid Cooldowns Frame"] = "NRC Raid Cooldowns Frame";

--Raid status window column names, make sure they fit in the colum size (left click minimap button to check).
L["Flask"] = "Flask";
L["Food"] = "Food";
L["Scroll"] = "Scroll";
L["Int"] = "Int";
L["Fort"] = "Fort";
L["Spirit"] = "Spirit";
L["Shadow"] = "Shadow";
L["Motw"] = "Motw";
L["Pal"] = "Pal";
L["Durability"] = "Durability";
L["Shadow"] = "Shadow";
L["Fire"] = "Fire";
L["Nature"] = "Nature";
L["Frost"] = "Frost";
L["Arcane"] = "Arcane";
L["Holy"] = "Holy";
L["Weapon"] = "Weapon";
L["Talents"] = "Talents";
L["Armor"] = "Armor";

L["noWeaponsEquipped"] = "You have no weapons equipped!";
L["noOffhandEquipped"] = "You have no offhand weapon equipped!";
L["noRangedEquipped"] = "You have no ranged weapon equipped!";

L["attuneWarning"] = "Loot %s for attunement quest %s.";
L["The Cudgel of Kar'desh"] = "The Cudgel of Kar'desh";
L["Earthen Signet"] = "Earthen Signet";
L["Blazing Signet"] = "Blazing Signet";
L["The Vials of Eternity"] = "The Vials of Eternity";
L["Vashj's Vial Remnant"] = "Vashj's Vial Remnant";
L["Kael's Vial Remnant"] = "Kael's Vial Remnant";
L["An Artifact From the Past"] = "An Artifact From the Past";
L["Time-Phased Phylactery"] = "Time-Phased Phylactery";
L["alarCostumeMissing"] = "Missing Ashtongue Cowl costume for Black Temple attunment, click it now!"

L["Raid Lockouts"] = "Raid Lockouts";
L["noCurrentRaidLockouts"] = "No Current raid Lockouts.";
L["noAltLockouts"] = "No Alt Lockouts Found.";
L["holdShitForAltLockouts"] = "Hold Shift For Alt Lockouts.";
L["leftClickMinimapButton"] = "Left-Click|r Open Raid Status";
L["rightClickMinimapButton"] = "Right-Click|r Open Raid Log";
L["shiftLeftClickMinimapButton"] = "Shift Left-Click|r Open Trade Log";
L["shiftRightClickMinimapButton"] = "Shift Right-Click|r Open Config";

--Options
L["mainTextDesc"] = "Note: This is a new addon in early stages, plans for more raid helpers as I get time.";

L["showRaidCooldownsTitle"] = "Enabled";
L["showRaidCooldownsDesc"] = "Show group raid cooldowns when you join a group (Hold shift to drag window).";

L["showRaidCooldownsInRaidTitle"] = "In Raid";
L["showRaidCooldownsInRaidDesc"] = "Show while in a raid group?";

L["showRaidCooldownsInPartyTitle"] = "In Party";
L["showRaidCooldownsInPartyDesc"] = "Show while in a 5 man party?";

L["showRaidCooldownsInBGTitle"] = "In Battlegrounds";
L["showRaidCooldownsInBGDesc"] = "Show while in battlegrounds?";

L["ktNoWeaponsWarningTitle"] = "KT No Weapons Warning";
L["ktNoWeaponsWarningDesc"] = "Show a warning in the middle of the screen and in chat if you start Kael'thas without any weapons on.";

L["mergeRaidCooldownsTitle"] = "Merge Cooldown List";
L["mergeRaidCooldownsDesc"] = "The raid cooldown list can show you all characters with tracked cooldowns at once OR you can enable this merge the list option so it only shows the cooldown spell names and you must hover over them to show each characters cooldowns.";

L["raidCooldownsNumTypeTitle"] = "Cooldowns Ready Display Type";
L["raidCooldownsNumTypeDesc"] = "Do you want to display only how many cooldowns are ready?\nOr do you want to display ready and total like 1/3?"

L["raidCooldownSpellsHeaderDesc"] = "Class Cooldowns To Track";

L["raidCooldownsBackdropAlphaTitle"] = "Backgound Transparency";
L["raidCooldownsBackdropAlphaDesc"] = "How transparent do you want the background to be?";

L["raidCooldownsBorderAlphaTitle"] = "Border Transparency";
L["raidCooldownsBorderpAlphaDesc"] = "How transparent do you want the border to be?";

L["raidCooldownsTextDesc"] = "Hold shift to drag the raid cooldowns frame.";

L["resetFramesTitle"] = "Reset Windows";
L["resetFramesDesc"] = "Reset all windows back to the middle of screen and sizes back to default.";

L["resetFramesMsg"] = "Resetting all window positions and size.";

L["showMobSpawnedTimeTitle"] = "Mob Spawned Time";
L["showMobSpawnedTimeDesc"] = "Show how long ago a mob spawned when you target it? (More of a novelty feature, but can be interesting for certain things)";

--Raid cooldowns.
L["raidCooldownRebirthTitle"] = "Rebirth";
L["raidCooldownRebirthDesc"] = "Show Rebirth raid cooldowns?";

L["raidCooldownInnervateTitle"] = "Innervate";
L["raidCooldownInnervateDesc"] = "Show Innervate raid cooldowns?";

L["raidCooldownTranquilityTitle"] = "Tranquility";
L["raidCooldownTranquilityDesc"] = "Show Tranquility raid cooldowns?";

L["raidCooldownMisdirectionTitle"] = "Misdirection";
L["raidCooldownMisdirectionDesc"] = "Show Misdirection raid cooldowns?";

L["raidCooldownEvocationTitle"] = "Evocation";
L["raidCooldownEvocationDesc"] = "Show Evocation raid cooldowns?";

L["raidCooldownIceBlockTitle"] = "Ice Block";
L["raidCooldownIceBlockDesc"] = "Show Ice Block raid cooldowns?";

L["raidCooldownInvisibilityTitle"] = "Invisibility";
L["raidCooldownInvisibilityDesc"] = "Show Invisibility raid cooldowns?";

L["raidCooldownDivineInterventionTitle"] = "Divine Intervention";
L["raidCooldownDivineInterventionDesc"] = "Show Divine Intervention raid cooldowns?";

L["raidCooldownDivineShieldTitle"] = "Divine Shield";
L["raidCooldownDivineShieldDesc"] = "Show Divine Shield raid cooldowns?";

L["raidCooldownLayonHandsTitle"] = "Lay on Hands";
L["raidCooldownLayonHandsDesc"] = "Show Lay on Hands raid cooldowns?";

L["raidCooldownFearWardTitle"] = "Fear Ward";
L["raidCooldownFearWardDesc"] = "Show Fear Ward raid cooldowns?";

L["raidCooldownShadowfiendTitle"] = "Shadowfiend";
L["raidCooldownShadowfiendDesc"] = "Show Shadowfiend raid cooldowns?";

L["raidCooldownPsychicScreamTitle"] = "Psychic Scream";
L["raidCooldownPsychicScreamDesc"] = "Show Psychic Scream raid cooldowns?";

L["raidCooldownBlindTitle"] = "Blind";
L["raidCooldownBlindDesc"] = "Show Blind raid cooldowns?";

L["raidCooldownVanishTitle"] = "Vanish";
L["raidCooldownVanishDesc"] = "Show Vanish raid cooldowns?";

L["raidCooldownEarthElementalTitle"] = "Earth Elemental";
L["raidCooldownEarthElementalDesc"] = "Show EarthElemental Totem raid cooldowns?";

L["raidCooldownReincarnationTitle"] = "Reincarnation";
L["raidCooldownReincarnationDesc"] = "Show Reincarnation raid cooldowns?";

L["raidCooldownHeroismTitle"] = "Heroism";
L["raidCooldownHeroismDesc"] = "Show Heroism raid cooldowns?";

L["raidCooldownBloodlustTitle"] = "Bloodlust";
L["raidCooldownBloodlustDesc"] = "Show Bloodlust raid cooldowns?";

L["raidCooldownSoulstoneTitle"] = "Soulstone";
L["raidCooldownSoulstoneDesc"] = "Show soulstone raid cooldowns?";

L["raidCooldownSoulshatterTitle"] = "Soulshatter";
L["raidCooldownSoulshatterDesc"] = "Show Soulshatter raid cooldowns?";

L["raidCooldownRitualofSoulsTitle"] = "Ritual of Souls";
L["raidCooldownRitualofSoulsDesc"] = "Show Ritual of Souls raid cooldowns?";

L["raidCooldownChallengingShoutTitle"] = "Challenging Shout";
L["raidCooldownChallengingShoutDesc"] = "Show Challenging Shout raid cooldowns?";

L["raidCooldownIntimidatingShoutTitle"] = "Intimidating Shout";
L["raidCooldownIntimidatingShoutDesc"] = "Show Intimidating Shout raid cooldowns?";

L["raidCooldownMockingBlowTitle"] = "Mocking Blow";
L["raidCooldownMockingBlowDesc"] = "Show Mocking Blow raid cooldowns?";

L["raidCooldownRecklessnessTitle"] = "Recklessness";
L["raidCooldownRecklessnessDesc"] = "Show Recklessness raid cooldowns?";

L["raidCooldownShieldWallTitle"] = "Shield Wall";
L["raidCooldownShieldWallDesc"] = "Show Shield Wall raid cooldowns?";

L["raidCooldownsSoulstonesTitle"] = "Active Soulstones";
L["raidCooldownsSoulstonesDesc"] = "Show extra frames to show who has a soulstone active on them?";

L["raidCooldownNeckBuffsTitle"] = "Neck Buffs";
L["raidCooldownNeckBuffsDesc"] = "Show jewelcrafting neck buff cooldowns? This will show all players in your party no matter what class.";

L["acidGeyserWarningTitle"] = "Acid Geyser Warning";
L["acidGeyserWarningDesc"] = "Warn in /say and middle of screen when a Underbog Colossus targets you with Acid Geyser?";

L["minimapButtonTitle"] = "Show Minimap Button";
L["minimapButtonDesc"] = "Show NRC button on the minimap?";

L["raidStatusTextDesc"] = "Hold shift to drag the raid status frame.";

L["raidStatusFlaskTitle"] = "Flask";
L["raidStatusFlaskDesc"] = "Display a Flasks column on the Raid Status tracker?";

L["raidStatusFoodTitle"]= "Food";
L["raidStatusFoodDesc"]= "Display a Food column on the Raid Status tracker?";

L["raidStatusScrollTitle"]= "Scroll";
L["raidStatusScrollDesc"]= "Display a Scrolls column on the Raid Status tracker?";

L["raidStatusIntTitle"]= "Int";
L["raidStatusIntDesc"]= "Display a Arcane Intellect column on the Raid Status tracker?";

L["raidStatusFortTitle"]= "Fort";
L["raidStatusFortDesc"]= "Display a Power Word: Fortitude column on the Raid Status tracker?";

L["raidStatusSpiritTitle"]= "Spirit";
L["raidStatusSpiritDesc"]= "Display a Prayer of Spirit column on the Raid Status tracker?";

L["raidStatusShadowTitle"]= "Shadow Buff";
L["raidStatusShadowDesc"]= "Display a Shadow Protection priest buff column on the Raid Status tracker?";

L["raidStatusMotwTitle"]= "Motw";
L["raidStatusMotwDesc"]= "Display a Mark of the Wild column on the Raid Status tracker?";

L["raidStatusPalTitle"]= "Paladin Blessings";
L["raidStatusPalDesc"]= "Display a Paladin Blessings column on the Raid Status tracker?";

L["raidStatusDuraTitle"]= "Durability";
L["raidStatusDuraDesc"]= "Display a Durability column on the Raid Status tracker?";

L["raidCooldownNecksHeaderDesc"] = "Neck Buff Cooldowns To Track";

L["raidCooldownNeckSPTitle"] = "+34 Spell Power";
L["raidCooldownNeckSPDesc"] = "Show party members cooldown for |cFF0070DD[Eye of the Night]|r (+34 Spell Power) necklace buff?";

L["raidCooldownNeckCritTitle"] = "+2% Crit";
L["raidCooldownNeckCritDesc"] = "Show party members cooldown for |cFF0070DD[Chain of the Twilight Owl]|r (+2% Crit) necklace buff?";

L["raidCooldownNeckCritRatingTitle"] = "+28 Crit Rating";
L["raidCooldownNeckCritRatingDesc"] = "Show party members cooldown for |cFF0070DD[Braided Eternium Chain]|r (+28 Crit Rating) necklace buff?";

L["raidCooldownNeckStamTitle"] = "+20 Stam";
L["raidCooldownNeckStamDesc"] = "Show party members cooldown for |cFF0070DD[Thick Felsteel Necklace]|r (+20 Stam) necklace buff?";

L["raidCooldownNeckHP5Title"] = "+6 HP5";
L["raidCooldownNeckHP5Desc"] = "Show party members cooldown for |cFF0070DD[Living Ruby Pendant]|r (+6 Health Per 5) necklace buff?";

L["raidCooldownNeckStatsTitle"] = "+10 Stats";
L["raidCooldownNeckStatsDesc"] = "Show party members cooldown for |cFF0070DD[Embrace of the Dawn]|r (+10 Stats) necklace buff?";

L["raidCooldownsNecksRaidOnlyTitle"] = "Necks In Raid Only";
L["raidCooldownsNecksRaidOnlyDesc"] = "Only show neck buff cooldowns when you're in a raid group and hide while in a party?";

L["Eating"] = "Eating"; --This can't be longer than 6 characters to fit in the raid status column.
L["Food"] = "Food";

L["raidStatusShowReadyCheckTitle"] = "Show On Readycheck";
L["raidStatusShowReadyCheckDesc"] = "Auto show the reaid status frame when a readycheck is started?";

L["raidStatusHideCombatTitle"] = "Hide In Combat";
L["raidStatusHideCombatDesc"] = "Auto hide the raid status frame when any combat starts?";

L["raidStatusColumsHeaderDesc"] = "Columns To Display";

L["deleteEntry"] = "Delete entry";
L["deleteInstance"] = "Deleted instance entry %s (%s).";
L["deleteInstanceError"] = "Error deleting instance entry %s.";

L["logDungeonsTitle"] = "Record Dungeons";
L["logDungeonsDesc"] = "Log dungeons also? Turn this off if you only want to record raids.";

L["logRaidsTitle"] = "Record Raids";
L["logRaidsDesc"] = "Log all 10/25/40 man raids.";

L["raidStatusShadowResTitle"] = "Shadow Res";
L["raidStatusShadowResDesc"] = "Display a Shadow Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusFireResTitle"] = "Fire Res";
L["raidStatusFireResDesc"] = "Display a Fire Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusNatureResTitle"] = "Nature Res";
L["raidStatusNatureResDesc"] = "Display a Nature Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusFrostResTitle"] = "Frost Res";
L["raidStatusFrostResDesc"] = "Display a Frost Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusArcaneResTitle"] = "Arcane Res";
L["raidStatusArcaneResDesc"] = "Display a Arcane Resistance column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusWeaponEnchantsTitle"] = "Weapon Enchants";
L["raidStatusWeaponEnchantsDesc"] = "Display a Weapon Enchants (oils/stones etc) column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusTalentsTitle"] = "Talents";
L["raidStatusTalentsDesc"] = "Display a Talents column on the Raid Status tracker? You need to click the \"More\" button on the raid status frame to see this.";

L["raidStatusExpandAlwaysTitle"] = "Always Show More";
L["raidStatusExpandAlwaysDesc"] = "Do you want to always show more when opening the raid status frame? So you don't need to click the More button.";

L["raidStatusExpandHeaderDesc"] = "More";
L["raidStatusExpandTextDesc"] = "These are displayed when you click the \"More\" button on the raid status frame. To see raid members extra stats they must have NRC installed or the Nova Raid Companion Addon Helper weakaura at |cFF3CE13Fhttps://wago.io/sof4ehBA6|r";

L["raidStatusExpandTooltip"] = "|cFFFFFF00Click to show more data like spell resistances.|r\n|cFF9CD6DEGroup members without NRC must have the NRC Helper\nweakaura at https://wago.io/sof4ehBA6 to see more data.|r";

L["healthstoneMsgTitle"] = "Healthstone Msg";
L["healthstoneMsgDesc"] = "Show a msg in /say when you cast healthstones so people help click? This shows what rank you're casting also.";

L["summonMsgTitle"] = "Summoning Msg";
L["summonMsgDesc"] = "Show a msg in group chat when you start summoning so people help click and so other locks can see who you're summong so as not to summon the same person?";

L["summonStoneMsgTitle"] = "Summon Stone Msg";
L["summonStoneMsgDesc"] = "Show a msg in group chat when you use a summoning stone so people help click and so other people in raid can see who you're summong so as not to summon the same person?";

L["duraWarningTitle"] = "Durability Warning";
L["duraWarningDesc"] = "Show a durability warning in the chat window if you enter a raid with low armor durability?";

L["dataOptionsTextDesc"] = "Data management and log recording options."

L["maxRecordsKeptTitle"] = "Raids Database Size";
L["maxRecordsKeptDesc"] = "Maximum amount of raids to keep in the database, increasing this to a large number may increase load time when opening the log window.";

L["maxTradesKeptTitle"] = "Trades Database Size";
L["maxTradesKeptDesc"] = "Maximum amount of trades to keep in the database, increasing this to a very large number may caus lag when opening the trade log.";

L["showMoneyTradedChatTitle"] = "Gold Traded In Chat";
L["showMoneyTradedChatDesc"] = "Show in trade when you give or receive gold from someone in the chat window? (Helps keep tack of who you have paid or received gold from in boost groups). |cFFFF0000WARNING: If you have Nova Instance Tracker installed already displaying trades in chat this won't work so you don't get duplicate msgs.|r";

L["attunementWarningsTitle"] = "Attunement Warnings";
L["attunementWarningsDesc"] = "Show a warning after a boss dies and you forget to loot an item for attunement quest?";

L["sortRaidStatusByGroupsColorTitle"] = "Colored Groups";
L["sortRaidStatusByGroupsColorDesc"] = "If you enable sort by groups on the raid status window this will colorize them.";

L["sortRaidStatusByGroupsColorBackgroundTitle"] = "Colored Groups Background";
L["sortRaidStatusByGroupsColorBackgroundDesc"] = "If you enable sort by groups and have colored enabled this will also color the background for the group.";

L["maxRecordsShownTitle"] = "Raids Shown In Log";
L["maxRecordsShownDesc"] = "Maximum amount of raids to show in the raid log? You can set this lower than records kept if you only want to view a certain amount but still keep higher amouns of data.";

L["maxTradesShownTitle"] = "Trades Shown In Log";
L["maxTradesShownDesc"] = "Maximum amount of trades to show in the trade log? You can set this lower than records kept if you only want to view a certain amount but still keep higher amouns of data.";