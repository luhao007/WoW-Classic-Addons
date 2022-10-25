---------------------------
---Nova Raid Companion DB--
---------------------------

---NOTE: Some tables here contain some of the same data as others, it's done for lookup speed reasons.
---Better to use slightly more ram with table storage than losing fps.

--Load classic DB, some of the empty tables need to exist here to be compataible with other expansions.

local addonName, NRC = ...;
if (not NRC.isClassic) then
	return;
end
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");

NRC.companionCreatures = {
	--Classic.
	[9662] = "Sprite Darter Hatchling",
	[7392] = "Prairie Chicken",
	[8376] = "Mechanical Chicken",
	[15699] = "Tranquil Mechanical Yeti",
	[9657] = "Lil' Smoky",
	[9656] = "Tiny Walking Bomb",
	[12419] = "Lifelike Toad",
	[2671] = "Mechanical Squirrel",
	[7544] = "Crimson Whelpling",
	[7543] = "Dark Whelpling",
	[7545] = "Emerald Whelpling",
	[15429] = "Disgusting Oozeling",
	[7391] = "Hyacinth Macaw",
	[7383] = "Black Tabby",
	[10598] = "Smolderweb Hatchling",
	[10259] = "Worg Pup",
	[7387] = "Green Wing Macaw",
	[7380] = "Siamese",
	[7394] = "Ancona Chicken",
	[7390] = "Cockatiel",
	[7389] = "Senegal",
	[7565] = "Black Kingsnake",
	[7562] = "Brown Snake",
	[7567] = "Crimson Snake",
	[7395] = "Cockroach",
	[14421] = "Brown Prairie Dog",
	[7560] = "Snowshoe Rabbit",
	[7555] = "Hawk Owl",
	[7553] = "Great Horned Owl",
	[7385] = "Bombay",
	[7384] = "Cornish Rex",
	[7382] = "Orange Tabby",
	[7381] = "Silver Tabby",
	[7386] = "White Kitten",
	[16085] = "Peddlefeet",
	[16548] = "Mr. Wiggles",
	[16549] = "Whiskers the Rat",
	[16547] = "Speedy",
	[16701] = "Spirit of Summer",
	[15706] = "Winter Reindeer",
	[15710] = "Tiny Snowman",
	[15705] = "Winter's Little Helper",
	[15698] = "Father Winter's Helper",
	[7550] = "Wood Frog",
	[7549] = "Tree Frog",
	[14878] = "Jubling",
	[11327] = "Zergling",
	[11326] = "Mini Diablo <Lord of Terror>",
	[11325] = "Panda Cub",
	[23713] = "Hippogryph Hatchling",
	[15186] = "Murky",
	[16456] = "Poley",
	[14756] = "Tiny Red Dragon",
	[14755] = "Tiny Green Dragon",
	[15361] = "Murki",
	[16069] = "Gurky",
	[16445] = "Terky", --On wowhead for classic, but WOTLK I think?
	[3619] = "Ghost Saber", --Combat compnaion spawned from an item.
	[17255] = "Hippogryph Hatchling",
	[47687] = "Winna's Kitten", --Felwood quest.
	[15661] = "Baby Shark",
	[9936] = "Corrupted Kitten",
	[17254] = "White Tiger Cub", --Not ingame?
	--[999999999] = "Snapjaw", --Turtle Egg (Albino), never made it into game? No ID found.
}

NRC.critterCreatures = {
	[7186] = "A",
	[3300] = "Adder",
	[15475] = "Beetle",
	[10716] = "Belfry Bat",
	[3835] = "Biletoad",
	[2110] = "Black Rat",
	[1932] = "Black Sheep",
	[5740] = "Caged Chicken",
	[5741] = "Caged Rabbit",
	[5743] = "Caged Sheep",
	[5739] = "Caged Squirrel",
	[5742] = "Caged Toad",
	[6368] = "Cat",
	[620] = "Chicken",
	[15066] = "Cleo",
	[13338] = "Core Rat",
	[2442] = "Cow",
	[6827] = "Crab",
	[12299] = "Cured Deer",
	[12297] = "Cured Gazelle",
	[13016] = "Deeprun Rat",
	[883] = "Deer",
	[3444] = "Dig Rat",
	[9658] = "Distract Test",
	[10582] = "Dog",
	[8963] = "Effsee",
	[13017] = "Enthralled Deeprun Rat",
	[5866] = "Equipment Squirrel",
	[5868] = "Evil Squirrel",
	[14892] = "Fang",
	[890] = "Fawn",
	[9699] = "Fire Beetle",
	[1352] = "Fluffy",
	[13321] = "Frog",
	[4166] = "Gazelle",
	[2848] = "Glyx Brewright",
	[5951] = "Hare",
	[385] = "Horse",
	[6653] = "Huge Toad",
	[10780] = "Infected Deer",
	[10779] = "Infected Squirrel",
	[15010] = "Jungle Toad",
	[10541] = "Krakle's Thermometer",
	[15065] = "Lady",
	[16068] = "Larva",
	[9700] = "Lava Crab",
	[16030] = "Maggot",
	[5867] = "Maximum Squirrel",
	[4953] = "Moccasin",
	[6271] = "Mouse",
	[16998] = "Mr. Bigglesworth",
	[12383] = "Nibbles",
	[7208] = "Noarm",
	[582] = "Old Blanchy",
	[9600] = "Parrot",
	[7898] = "Pirate treasure trigger mob",
	[10461] = "Plagued Insect",
	[10536] = "Plagued Maggot",
	[10441] = "Plagued Rat",
	[10510] = "Plagued Slime",
	[12120] = "Plagueland Termite",
	[16479] = "Polymorph Clone",
	[16369] = "Polymorphed Chicken",
	[16779] = "Polymorphed Cow",
	[16373] = "Polymorphed Rat",
	[16372] = "Polymorphed Sheep",
	[2620] = "Prairie Dog",
	[721] = "Rabbit",
	[2098] = "Ram",
	[4075] = "Rat",
	[8881] = "Riding Ram",
	[4076] = "Roach",
	[11776] = "Salome",
	[6145] = "School of Fish",
	[15476] = "Scorpion",
	[1933] = "Sheep",
	[14361] = "Shen'dralar Wisp",
	[12298] = "Sickly Deer",
	[12296] = "Sickly Gazelle",
	[2914] = "Snake",
	[14881] = "Spider",
	[15072] = "Spike",
	[1412] = "Squirrel",
	[5689] = "Steed",
	[10685] = "Swine",
	[10017] = "Tainted Cockroach",
	[10016] = "Tainted Rat",
	[18078] = "The Evil Rabbit",
	[14886] = "The Good Rabbit",
	[1420] = "Toad",
	[14681] = "Transporter Malfunction",
	[15219] = "Trick - Critter",
	[15071] = "Underfoot",
	[12152] = "Voice of Elune",
	[1262] = "White Ram",
	[14801] = "Wild Polymorph Target",
	[3681] = "Wisp",
	[12861] = "Wisp (Ghost Visual Only)",
};

--Other NPC's to ignore, player pets that have a creature guid, so it doesn't add to creature death counts.
NRC.ignoredCreatures = {
	[23226] = "Illidari Elite",
	[23420] = "Essence of Anger",
	[20062] = "Grand Astromancer Capernian",
	[21271] = "Infinity Blades",
	[20060] = "Lord Sanguinar",
	[20063] = "Master Engineer Telonicus",
	[20064] = "Thaladred the Darkener",
	[19668] = "Shadowfiend",
	[510] = "Water Elemental",
	[19833] = "Venomous Snake", --Snake trap.
	[19921] = "Viper", --Snake trap.
	[1964] = "Treant",
	[15438] = "Greater Fire Elemental",
	[15352] = "Greater Earth Elemental",
	[21160] = "Conjured Water Elemental",
	[17299] = "Crashin' Thrashin' Robot",
	[25305] = "Dancing Flames",
	[24780] = "Field Repair Bot 110G",
	[18846] = "Furious Mr. Pinchy",
	[19405] = "Steam Tonk",
	[15368] = "Tonk Mine",
	[11859] = "Doomguard",
	[14337] = "Field Repair Bot 74A",
};

--Some data taken from from retail EJ_GetCreatureInfo() with adjustments, some extra data manually added, mapped to encounterID.
--JournalEncounterCreature.ID, name, description, displayInfo, iconImage, uiModelSceneID, expansion, zoneID.
NRC.encounters = {
	--Ony.
	[1084] = {"3948", "Onyxia", "", 8570, 1379025, 9, 1, 249},
	--MC.
	[663] = {"3733", "Lucifron", "", 13031, 1378993, 9, 1, 409},
	[664] = {"3734", "Magmadar", "", 10193, 1378995, 9, 1, 409},
	[665] = {"3735", "Gehennas", "", 13030, 1378976, 9, 1, 409},
	[666] = {"3736", "Garr", "", 12110, 1378975, 9, 1, 409},
	[667] = {"3737", "Shazzrah", "", 13032, 1379013, 9, 1, 409},
	[668] = {"3738", "Baron Geddon", "", 12129, 1378966, 9, 1, 409},
	[669] = {"3740", "Sulfuron Harbinger", "", 13030, 1379015, 9, 1, 409},
	[670] = {"3741", "Golemagg the Incinerator", "", 11986, 1378978, 9, 1, 409},
	[671] = {"3742", "Majordomo Executus", "", 12029, 1378998, 9, 1, 409},
	[672] = {"3745", "Ragnaros", "", 11121, 522261, 225, 1, 409},
	--BWL.
	[610] = {"3746", "Razorgore the Untamed", "", 10115, 1379008, 9, 1, 469},
	[611] = {"3747", "Vaelastrasz the Corrupt", "", 13992, 1379022, 9, 1, 469},
	[612] = {"3748", "Broodlord Lashlayer", "", 14308, 1378968, 9, 1, 469},
	[613] = {"3749", "Firemaw", "", 6377, 1378973, 9, 1, 469},
	[614] = {"3750", "Ebonroc", "", 6377, 1378971, 9, 1, 469},
	[615] = {"3751", "Flamegor", "", 6377, 1378974, 9, 1, 469},
	[616] = {"3752", "Chromaggus", "", 14367, 1378969, 9, 1, 469},
	[617] = {"3753", "Nefarian", "", 11380, 1379001, 9, 1, 469},
	--AQ20.
	[718] = {"3754", "Kurinnaxx", "", 15742, 1385749, 9, 1, 509},
	[719] = {"3755", "General Rajaxx", "", 15376, 1385734, 9, 1, 509},
	[720] = {"3756", "Moam", "", 15392, 1385755, 9, 1, 509},
	[721] = {"3757", "Buru the Gorger", "", 15654, 1385723, 9, 1, 509},
	[722] = {"3758", "Ayamiss the Hunter", "", 15431, 1385718, 9, 1, 509},
	[723] = {"3760", "Ossirian the Unscarred", "", 15432, 1385759, 9, 1, 509},
	--AQ40.
	[709] = {"3761", "The Prophet Skeram", "", 15345, 1385769, 9, 1, 531},
	[710] = {"3770", "Lord Kri", "", 15656, 1390436, 9, 1, 531},
	[711] = {"3762", "Battleguard Sartura", "", 15583, 1385720, 9, 1, 531},
	[712] = {"3766", "Fankriss the Unyielding", "", 15743, 1385728, 9, 1, 531},
	[713] = {"3771", "Viscidus", "", 15686, 1385771, 9, 1, 531},
	[714] = {"3767", "Princess Huhuran", "", 15739, 1385761, 9, 1, 531},
	[715] = {"3772", "Emperor Vek'lor", "", 15778, 1390437, 66, 1, 531},
	[716] = {"3774", "Ouro", "", 15509, 1385760, 87, 1, 531},
	[717] = {"3775", "C'Thun", "", 15556, 1385726, 9, 1, 531},
	--ZG (Could be diff encounterIDs on retail? Needs testing on classic).
	[1178] = {"601", "High Priest Venoxis", "", 37788, 522236, 9, 1, 309},
	[1179] = {"602", "Bloodlord Mandokir", "", 37816, 522209, 9, 1, 309},
	[788] = {"603", "Gri'lek", "", 8390, 522230, 9, 1, 309},
	[788] = {"604", "Hazza'rah", "", 37832, 522233, 9, 1, 309},
	[788] = {"605", "Renataki", "", 37830, 522263, 9, 1, 309},
	[788] = {"606", "Wushoolay", "", 37831, 522279, 9, 1, 309},
	[1180] = {"607", "High Priestess Kilnara", "", 37805, 522238, 9, 1, 309},
	[1181] = {"616", "Zanzil", "", 37813, 522280, 9, 1, 309},
	[1182] = {"617", "Jin'do the Godbreaker", "", 37789, 522243, 9, 1, 309},
	--Naxx (Should be diff encounterIDs on retail (wrath)? Needs testing on classic).
	[1107] = {"3853", "Anub'Rekhan", "", 15931, 1378964, 9, 1, 533},
	[1110] = {"3854", "Grand Widow Faerlina", "", 15940, 1378980, 9, 1, 533},
	[1116] = {"3855", "Maexxna", "", 15928, 1378994, 9, 1, 533},
	[1117] = {"3856", "Noth the Plaguebringer", "", 16590, 1379004, 9, 1, 533},
	[1112] = {"3857", "Heigan the Unclean", "", 16309, 1378984, 9, 1, 533},
	[1115] = {"3858", "Loatheb", "", 16110, 1378991, 9, 1, 533},
	[1113] = {"3860", "Instructor Razuvious", "", 16582, 1378988, 9, 1, 533},
	[1109] = {"3861", "Gothik the Harvester", "", 16279, 1378979, 9, 1, 533},
	[1121] = {"3863", "Baron Rivendare", "", 10729, 1385732, 9, 1, 533},
	[1118] = {"3866", "Patchwerk", "", 16174, 1379005, 9, 1, 533},
	[1111] = {"3867", "Grobbulus", "", 16035, 1378981, 9, 1, 533},
	[1108] = {"3868", "Gluth", "", 16064, 1378977, 9, 1, 533},
	[1120] = {"3869", "Thaddius", "", 16137, 1379019, 64, 1, 533},
	[1119] = {"3870", "Sapphiron", "", 16033, 1379010, 9, 1, 533},
	[1114] = {"3871", "Kel'Thuzad", "", 15945, 1378989, 9, 1, 533},
};

--Data from EJ_GetInstanceByIndex, some modifications and mapped to instanceID.
--name, description, bgImage, loreImage, buttonImage1, buttonImage2, dungeonAreaMapID.
NRC.instanceTextures = {
	--Classic dungs.
	[227] = {"Blackfathom Deeps", "Once dedicated to the night elves' goddess Elune, Blackfathom Deeps was thought to have been destroyed during the Sundering, lost beneath the ocean. Millennia later, members of the Twilight's Hammer cult were drawn to the temple by whispers and foul dreams. After sacrificing untold numbers of innocents, the cult was rewarded with a new task: to protect one of the Old Gods' most cherished creatures, a pet that is still in need of nurturing before he can unleash his dark powers on the world.", 608156, 608234, 608195, 136325, 221},
	[228] = {"Blackrock Depths", "The smoldering Blackrock Depths are home to the Dark Iron dwarves and their emperor, Dagran Thaurissan. Like his predecessors, he serves under the iron rule of Ragnaros the Firelord, a merciless being summoned into the world centuries ago. The presence of chaotic elementals has attracted Twilight's Hammer cultists to the mountain domain. Along with Ragnaros' servants, they have pushed the dwarves toward increasingly destructive ends that could soon spell doom for all of Azeroth.", 608157, 608235, 608196, 136326, 242},
	[63] = {"Deadmines", "It is said the Deadmines' gold deposits once accounted for a third of Stormwind's treasure reserves. Amid the chaos of the First War, the mines were abandoned and later thought to be haunted, leaving them relatively untouched until the Defias Brotherhood--a group of former laborers turned brigands--claimed the labyrinth as a base of operations for its subversive activities against Stormwind.", 522336, 526404, 522352, 136332, 291},
	[230] = {"Dire Maul", "Built thousands of years ago to house the kaldorei's arcane secrets, the formerly great city of Eldre'Thalas now lies in ruin, writhing with warped, twisted forces. Competing covens once fought for control of Dire Maul's corrupted energy, but they have since settled into uneasy truces, choosing to exploit the power within their own territories rather than continue to battle over the entire complex.", 608161, 608239, 608200, 136333, 240},
	[231] = {"Gnomeregan", "Built deep within the mountains of Dun Morogh, the wondrous city of Gnomeregan was a testament to the gnomes' intelligence and industry. But when the capital was invaded by troggs, the gnomish high tinker was betrayed by his advisor Sicco Thermaplugg. As a result, Gnomeregan was irradiated, and most of its inhabitants slain. The surviving gnomes fled, vowing to return someday and retake their home.", 608163, 608241, 608202, 136336, 226},
	[229] = {"Lower Blackrock Spire", "This imposing fortress, carved into the fiery core of Blackrock Mountain, represented the might of the Dark Iron clan for centuries. More recently, the black dragon Nefarian and his spawn seized the keep's upper spire and ignited a brutal war against the dwarves. The draconic armies have since allied with Warchief Rend Blackhand and his false Horde. This combined force lords over the spire, conducting horrific experiments to bolster its ranks while plotting the meddlesome Dark Irons' downfall.", 608158, 608236, 608197, 136327, 252},
	[232] = {"Maraudon", "According to legend, Zaetar, son of Cenarius, and the earth elemental princess Theradras begot the barbaric centaur race. Shortly after the centaur's creation, the ruthless creatures murdered their father. The grief-stricken Theradras is said to have trapped her lover's spirit within Maraudon, corrupting the region. Now, vicious centaur ghosts and twisted elemental minions roam every corner of the sprawling caves.", 608170, 608248, 608209, 136345, 280},
	[389] = {"Ragefire Chasm", "Ragefire Chasm extends deep below the city of Orgrimmar. Barbaric troggs and devious Searing Blade cultists once plagued the volcanic caves, but now a new threat has emerged: dark shaman. Although Warchief Garrosh Hellscream recently called on a number of shaman to use the elements as weapons against the Alliance, the chasm's current inhabitants appear to be renegades. Reports have surfaced that these shadowy figures are amassing a blistering army that could wreak havoc if unleashed upon Orgrimmar.", 608172, 608250, 608211, 136350, 213},
	[233] = {"Razorfen Downs", "Legends state that where the demigod Agamaggan fell, his blood gave rise to great masses of thorny vines. Recently, scouts have reported seeing undead milling about the region, engendering fears that the dreaded Scourge may be moving to conquer Kalimdor.", 608173, 608251, 608212, 136352, 300},
	[234] = {"Razorfen Kraul", "Legends state that where the demigod Agamaggan fell, his blood gave rise to great masses of thorny vines. Many quilboar have taken up residence in the largest cluster of giant thorns, the Razorfen, which they revere as Agamaggan's resting place.", 608174, 608252, 608213, 136353, 301},
	[311] = {"Scarlet Halls", "The Crusade's fiercest warriors, those who have held their ground and fought to defend the monastery throughout these dark times, are rapidly preparing an army within the Scarlet Halls. These soldiers are bound by their hatred of the unliving, and they are willing to sacrifice everything for their order's righteous cause.", 643259, 643265, 643262, 643268, 431},
	[316] = {"Scarlet Monastery", "The Crusade's fanatical leaders direct their followers from the Scarlet Cathedral, at the heart of the monastery grounds. This heavily guarded location functions as the order's headquarters, and some of the most zealous and intolerant crusaders roam the halls of this once-hallowed place.", 608175, 608253, 608214, 136354, 435},
	[246] = {"Scholomance", "Individuals seeking to master the powers of undeath know well of Scholomance, the infamous school of necromancy located in the dark and foreboding crypts beneath Caer Darrow. In recent years, several of the instructors have changed, but the institution remains under the control of Darkmaster Gandling, a particularly sadistic and insidious practitioner of necromantic magic.", 608176, 608254, 608215, 136355, 476},
	[64] = {"Shadowfang Keep", "Looming over Pyrewood Village from the southern bluffs of Silverpine Forest, Shadowfang Keep casts a shadow as dark as its legacy. Sinister forces occupy these ruins, formerly the dwelling of the mad archmage Arugal's worgen. The restless shade of Baron Silverlaine lingers, while Lord Godfrey and his cabal of erstwhile Gilnean noblemen plot against their enemies both living and undead.", 522342, 526410, 522358, 136357, 310},
	[236] = {"Stratholme", "Stratholme was once the jewel of northern Lordaeron, but today it is remembered for its harrowing fall to ruin. It was here that Prince Arthas turned his back on the noble paladin Uther Lightbringer, slaughtering countless residents believed to be infected with the horrific plague of undeath. Ever since, cursed Stratholme has been marred by death, betrayal, and hopelessness.", 608177, 608255, 608216, 136359, 317},
	[238] = {"The Stockade", "Stormwind Stockade is a closely guarded prison built beneath the canals of Stormwind City. Warden Thelwater keeps watch over the stockade and the highly dangerous criminals who call it home. Recently, the inmates revolted, overthrowing their guards and plunging the prison into a state of pandemonium.", 608184, 608262, 608223, 136358, 225},
	[237] = {"The Temple of Atal'hakkar", "Thousands of years ago, the Gurubashi empire was plunged into a civil war by a powerful sect of priests, the Atal'ai, who sought to summon to Azeroth an avatar of their god of blood, Hakkar the Soulflayer. The Gurubashi people exiled the Atal'ai to the Swamp of Sorrows, where the priests built the Temple of Atal'Hakkar. Ysera, Aspect of the green dragonflight, sank the temple beneath the swamp and assigned wardens to ensure that the summoning rituals never be performed again.", 608178, 608256, 608217, 136360, 220},
	[239] = {"Uldaman", "Uldaman is an ancient titan vault buried deep within the earth. It is said the titans sealed away a failed experiment there and then moved on to a new project, related to the genesis of the dwarves. Tales of a fabled treasure containing great knowledge have enticed would-be treasure hunters to dig deeper into the secrets of Uldaman, a task made perilous by the presence of stone defenders, savage troggs, Dark Iron invaders, and other dangers lurking in the lost city.", 608186, 608264, 608225, 136363, 230},
	[240] = {"Wailing Caverns", "Years ago, the famed druid Naralex and his followers descended into the shadowy Wailing Caverns, named for the mournful cry one hears when steam bursts from the cave system's fissures. Naralex planned to use the underground springs to restore lushness to the arid Barrens. But upon entering the Emerald Dream, he saw his vision of regrowth turn into a waking nightmare, one that has plagued the caverns ever since.", 608190, 608313, 608229, 136364, 279},
	[241] = {"Zul'Farrak", "Zul'Farrak was once the shining jewel of Tanaris, ferociously protected by the cunning Sandfury tribe. Despite the trolls' tenacity, this isolated group was forced to surrender much of its territory throughout history. Now, it appears that Zul'Farrak's inhabitants are creating a horrific army of undead trolls to conquer the surrounding region. Other disturbing rumors tell of an ancient creature sleeping within the city--one that, if awakened, will rain death and destruction across Tanaris.", 608191, 608267, 608230, 136368, 219},
	--Classic raids.
	[7249] = {"Onyxia's Lair", "", 1396463, 1396508, 1396589, 329121, 0},
	[409] = {"Molten Core", "", 1396460, 1396505, 1396586, 136346, 0, 1},
	[469] = {"Blackwing Lair", "", 1396454, 1396499, 1396580, 136329, 0, 2},
	[309] = {"Zul'Gurub", "Zul'Gurub was the capital of the Gurubashi jungle trolls, a tribe that once controlled the vast jungles of the south. It was here that Jin'do the Hexxer summoned the savage loa Hakkar the Soulflayer into Azeroth. Of late, these efforts have begun anew amid an alliance between the Gurubashi and Zandalar trolls that seeks to establish a unified troll empire.", 522348, 526416, 522364, 136369, 337, 3},
	[509] = {"Ruins of Ahn'Qiraj", "", 1396465, 1396510, 1396591, 136320, 0, 4},
	[531] = {"Temple of Ahn'Qiraj", "", 1396467, 1396512, 1396593, 136321, 0, 5},
	[533] = {"Naxxramas", "", 1396461, 1396506, 1396587, 136347, 0, 6},
};

--Trash and boss lists taken from wowhead and refined.
NRC.zones = {
	--Classic dungeons.
	[33] = {
		name = L["Shadowfang Keep"],
		type = "dungeon",
		expansion = "classic",
	},
	[48] = {
		name = L["Blackfathom Deeps"],
		type = "dungeon",
		expansion = "classic",
	},
	[230] = {
		name = L["Blackrock Depths"],
		type = "dungeon",
		expansion = "classic",
	},
	[229] = {
		name = L["Blackrock Spire"],
		type = "dungeon",
		expansion = "classic",
	},
	[429] = {
		name = L["Dire Maul"],
		type = "dungeon",
		expansion = "classic",
	},
	[90] = {
		name = L["Gnomeregan"],
		type = "dungeon",
		expansion = "classic",
	},
	[349] = {
		name = L["Maraudon"],
		type = "dungeon",
		expansion = "classic",
	},
	[389] = {
		name = L["Ragefire Chasm"],
		type = "dungeon",
		expansion = "classic",
	},
	[129] = {
		name = L["Razorfen Downs"],
		type = "dungeon",
		expansion = "classic",
	},
	[47] = {
		name = L["Razorfen Kraul"],
		type = "dungeon",
		expansion = "classic",
	},
	[1004] = {
		name = L["Scarlet Monastery"],
		type = "dungeon",
		expansion = "classic",
	},
	[1007] = {
		name = L["Scholomance"],
		type = "dungeon",
		expansion = "classic",
	},
	[329] = {
		name = L["Stratholme"],
		type = "dungeon",
		expansion = "classic",
	},
	[36] = {
		name = L["The Deadmines"],
		type = "dungeon",
		expansion = "classic",
	},
	[34] = {
		name = L["The Stockade"],
		type = "dungeon",
		expansion = "classic",
	},
	[109] = {
		name = L["The Temple of Atal'Hakkar"],
		type = "dungeon",
		expansion = "classic",
	},
	[70] = {
		name = L["Uldaman"],
		type = "dungeon",
		expansion = "classic",
	},
	[43] = {
		name = L["Wailing Caverns"],
		type = "dungeon",
		expansion = "classic",
	},
	[209] = {
		name = L["Zul'Farrak"],
		type = "dungeon",
		expansion = "classic",
	},
	--Classic raids.
	[249] = {
		name = L["Onyxia's Lair"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
	[309] = {
		name = L["Zul'gurub"],
		type = "raid",
		expansion = "classic",
	},
	[409] = {
		name = L["Molten Core"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
	[469] = {
		name = L["Blackwing Lair"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
		maxPlayers = 40,
	},
	[509] = {
		name = L["Ruins of Ahn'Qiraj"],
		type = "raid",
		expansion = "classic",
	},
	[531] = {
		name = L["Temple of Ahn'Qiraj"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
	[533] = {
		name = L["Naxxramas"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
};

NRC.flasks = {
	--Classic flasks.
	[17628] = {
		name = "Flask of Supreme Power",
		icon = 134821,
		desc = "+70 Spell Power",
	},
	[17626] = {
		name = "Flask of the Titans",
		icon = 134842,
		desc = "+400 HP",
	},
	[17627] = {
		name = "Flask of Distilled Wisdom",
		icon = 134877,
		desc = "+65 Int",
		maxRank = true,
	},
	[17629] = {
		name = "Flask of Chromatic Resistance",
		icon = 134828,
		desc = "+25 All Resistances",
	},
};

NRC.battleElixirs = {
	
};

NRC.guardianElixirs = {
	
};

NRC.foods = {
	
};

NRC.scrolls = {
	[12174] = {
		name = "Scroll of Agility IV",
		icon = 135879,
		desc = "+17 Agility",
		order = 1,
		itemID = 10309,
		itemIcon = 134938,
		quality = 1,
	},
	[12179] = {
		name = "Scroll of Strength IV",
		icon = 136101,
		desc = "+17 Strength",
		order = 2,
		itemID = 10310,
		itemIcon = 134938,
		quality = 1,
	},
	[12175] = {
		name = "Scroll of Protection IV",
		icon = 132341,
		desc = "+240 Armor",
		order = 3,
		itemID = 10305,
		itemIcon = 134943,
		quality = 1,
	},
	[12176] = {
		name = "Scroll of Intellect IV",
		icon = 135932,
		desc = "+16 Intellect",
		order = 4,
		itemID = 10308,
		itemIcon = 134937,
		quality = 1,
	},
	[12177] = {
		name = "Scroll of Spirit IV",
		icon = 136126,
		desc = "+15 Spirit",
		order = 5,
		itemID = 10306,
		itemIcon = 134937,
		quality = 1,
	},
	[12178] = {
		name = "Scroll of Stamina IV",
		icon = 136112,
		desc = "+16 Stamina",
		order = 6,
		itemID = 10307,
		itemIcon = 134943,
		quality = 1,
	},
};

--Spell cast IDs not item IDs.
NRC.trackedConsumes = {

}

NRC.racials = {
	
}

NRC.interrupts = {
	--Id = threat.
	[1766] = {
		name = "Kick",
		icon = 132219,
		rank = 1,
	};
	[1767] = {
		name = "Kick",
		icon = 132219,
		rank = 2,
	};
	[1768] = {
		name = "Kick",
		icon = 132219,
		rank = 3,
	};
	[1769] = {
		name = "Kick",
		icon = 132219,
		rank = 4,
	};
	[8042] = {
		name = "Earth Shock",
		icon = 136026,
		rank = 1,
	};
	[8044] = {
		name = "Earth Shock",
		icon = 136026,
		rank = 2,
	};
	[8045] = {
		name = "Earth Shock",
		icon = 136026,
		rank = 3,
	};
	[8046] = {
		name = "Earth Shock",
		icon = 136026,
		rank = 4,
	};
	[10412] = {
		name = "Earth Shock",
		icon = 136026,
		rank = 5,
	};
	[10413] = {
		name = "Earth Shock",
		icon = 136026,
		rank = 6,
	};
	[10414] = {
		name = "Earth Shock",
		icon = 136026,
		rank = 7,
	};
	[2139] = {
		name = "Counterspell",
		icon = 135856,
	};
	[6552] = {
		name = "Pummel",
		icon = 132938,
		rank = 1,
	};
	[6554] = {
		name = "Pummel",
		icon = 132938,
		rank = 2,
	};
	[16979] = {
		name = "Feral Charge",
		icon = 132183,
	};
	[19244] = {
		name = "Spell Lock",
		icon = 136174,
		rank = 1,
	};
	[119647] = {
		name = "Spell Lock",
		icon = 136174,
		rank = 2,
	};
	[15487] = {
		name = "Silence",
		icon = 136164,
	};
};

NRC.trackedItems = {};
for k, v in pairs(NRC.scrolls) do
	NRC.trackedItems[k] = v;
end
for k, v in pairs(NRC.racials) do
	NRC.trackedItems[k] = v;
end
for k, v in pairs(NRC.battleElixirs) do
	NRC.trackedItems[k] = v;
end
for k, v in pairs(NRC.guardianElixirs) do
	NRC.trackedItems[k] = v;
end
for k, v in pairs(NRC.flasks) do
	NRC.trackedItems[k] = v;
end
for k, v in pairs(NRC.interrupts) do
	NRC.trackedItems[k] = v;
end
for k, v in pairs(NRC.trackedConsumes) do
	NRC.trackedItems[k] = v;
end
--for k, v in pairs(NRC.foods) do
--	NRC.trackedItems[k] = v;
--end

--Loot data here is taken from AtlasLoot with permission of the dev Lag123.
--HP data from wowhead but I also record when bosses are targeted incase any data is wrong or Blizzard change things.
NRC.npcs = {
	--UNFINISHED FOR CLASSIC.
	--Ragefire chasm.
	[11520] = {
		name = "Taragaman the Hungerer",
		encounterID = 0,
		instanceID = 0,
		hp = 1869,
		type = "Humanoid",
		loot = {
		
		},
	},
	[11517] = {
		name = "Oggleflint <Ragefire Chieftain>",
		encounterID = 0,
		instanceID = 0,
		hp = 1424,
		type = "Humanoid",
		loot = {

		},
	},
	[11518] = {
		name = "Jergosh the Invoker",
		encounterID = 0,
		instanceID = 0,
		hp = 1382,
		type = "Humanoid",
		loot = {

		},
	},
	[11519] = {
		name = "Bazzalan",
		encounterID = 0,
		instanceID = 0,
		hp = 1513,
		type = "Humanoid",
	},
}

NRC.ignoredLoot = {
	--Badges etc.
};

NRC.distractingShot = {
	--Id = threat.
	[20736] = 110,
	[14274] = 160,
	[15629] = 250,
	[15630] = 350,
	[15631] = 465,
	[15632] = 600,
};

NRC.resurrectionSpells = {
	[2006] = {
		name = "Resurrection", --Priest Rank 1.
		icon = 135955,
	},
	[2010] = {
		name = "Resurrection", --Priest Rank 2.
		icon = 135955,
	},
	[10880] = {
		name = "Resurrection", --Priest Rank 3.
		icon = 135955,
	},
	[10881] = {
		name = "Resurrection", --Priest Rank 4.
		icon = 135955,
	},
	[20770] = {
		name = "Resurrection", --Priest Rank 5.
		icon = 135955,
	},
	[2008] = {
		name = "Ancestral Spirit", --Shaman rank 1.
		icon = 136077,
	},
	[20609] = {
		name = "Ancestral Spirit", --Shaman rank 2.
		icon = 136077,
	},
	[20610] = {
		name = "Ancestral Spirit", --Shaman rank 3.
		icon = 136077,
	},
	[20776] = {
		name = "Ancestral Spirit", --Shaman rank 4.
		icon = 136077,
	},
	[20777] = {
		name = "Ancestral Spirit", --Shaman rank 5.
		icon = 136077,
	},
	[7328] = {
		name = "Redemption", --Paladin rank 1.
		icon = 135955,
	},
	[10322] = {
		name = "Redemption", --Paladin rank 2.
		icon = 135955,
	},
	[10324] = {
		name = "Redemption", --Paladin rank 3.
		icon = 135955,
	},
	[20772] = {
		name = "Redemption", --Paladin rank 4.
		icon = 135955,
	},
	[20773] = {
		name = "Redemption", --Paladin rank 5.
		icon = 135955,
	},
	[20484] = {
		name = "Rebirth", --Rank 1.
		icon = 136080,
	},
	[20739] = {
		name = "Rebirth", --Rank 2.
		icon = 136080,
	},
	[20742] = {
		name = "Rebirth", --Rank 3.
		icon = 136080,
	},
	[20747] = {
		name = "Rebirth", --Rank 4.
		icon = 136080,
	},
	[20748] = {
		name = "Rebirth", --Rank 5.
		icon = 136080,
	},
};

NRC.magePortals = {
	[11417] = {
		name = "Portal: Orgrimmar",
		icon = 135744,
	},
	[10059] = {
		name = "Portal: Stormwind",
		icon = 135748,
	},
	[11420] = {
		name = "Portal: Thunder Bluff",
		icon = 135750,
	},
	[11419] = {
		name = "Portal: Darnassus",
		icon = 135741,
	},
	[11416] = {
		name = "Portal: Ironforge",
		icon = 135743,
	},
	[11418] = {
		name = "Portal: Undercity",
		icon = 135751,
	},
};

NRC.healthstones = {
	
};
		
NRC.dpsPotions = {
	
};

NRC.manaPotions = {
	[17531] = {
		spellName = "Major Mana Potion",
		icon = 134856,
	},
	[22729] = {
		spellName = "Major Rejuvenation Potion",
		icon = 134827,
	},
	[28504] = {
		spellName = "Major Dreamless Sleep Potion",
		icon = 134764,
	},
	[16666] = {
		spellName = "Demonic Rune",
		icon = 134417,
	},
	[27869] = {
		spellName = "Dark Rune",
		icon = 136192,
	},
};

NRC.healingPotions = {
	[17534] = {
		spellName = "Major Healing Potion",
		icon = 134834,
	},
	[22729] = {
		spellName = "Major Rejuvenation Potion",
		icon = 134827,
	},
	[28504] = {
		spellName = "Major Dreamless Sleep Potion",
		icon = 134764,
	},
};

NRC.tempEnchants = {
	--Mapped to enchantID not spellID.
	[2713] = {
		name = "Adamantite Sharpening Stone",
		icon = 135254,
		desc = "Increase sharp weapon damage by 12 and add 14 melee critical strike rating for 1 hour.",
		maxRank = true,
	},
	[2955] = {
		name = "Adamantite Weightstone",
		icon = 135261,
		desc = "Increase blunt weapon damage by 12 and add 14 critical hit rating for 1 hour.",
		maxRank = true,
	},
	[2640] = {
		name = "Anesthetic Poison",
		icon = 136093,
		desc = "Each strike has a 20% chance of poisoning the enemy which instantly inflicts 134 to 172 Nature damage, but causes no additional threat.",
		maxRank = true,
	},
	[3265] = {
		name = "Blessed Weapon Coating",
		icon = 134723,
		desc = "Chance to regain 165 mana on each spell cast. Only functions on the Isle of Quel'Danas.",
		maxRank = true,
	},
	[2685] = {
		name = "Blessed Wizard Oil",
		icon = 134806,
		desc = "Increases spell damage against undead by up to 60.",
		maxRank = true,
	},
	[2629] = {
		name = "Brilliant Mana Oil",
		icon = 134722,
		desc = "Restores 12 mana to the caster every 5 seconds and increases the effect of healing spells by up to 25.",
		maxRank = true,
	},
	[2628] = {
		name = "Brilliant Wizard Oil",
		icon = 134727,
		desc = "Increases spell damage by up to 36 and increases spell critical strike rating by 14.",
		maxRank = true,
	},
	[13] = {
		name = "Coarse Sharpening Stone",
		icon = 135249,
		desc = "Increase sharp weapon damage by 3 for 1 hour.",
	},
	[20] = {
		name = "Coarse Weightstone",
		icon = 135256,
		desc = "Increase the damage of a blunt weapon by 3 for 1 hour.",
	},
	[2684] = {
		name = "Consecrated Sharpening Stone",
		icon = 135249,
		desc = "Increases attack power against undead by 100.",
		maxRank = true,
	},
	[22] = {
		name = "Crippling Poison",
		icon = 132274,
		desc = "Each strike has a 30% chance of poisoning the enemy, slowing their movement speed by 50% for 12 sec.",
	},
	[603] = {
		name = "Crippling Poison II",
		icon = 132274,
		desc = "Each strike has a 30% chance of poisoning the enemy, slowing their movement speed by 70% for 12 sec.",
		maxRank = true,
	},
	[7] = {
		name = "Deadly Poison",
		icon = 132290,
		desc = "Each strike has a 30% chance of poisoning the enemy for 36 Nature damage over 12 sec. Stacks up to 5 times on a single target.",
	},
	[8] = {
		name = "Deadly Poison II",
		icon = 132290,
		desc = "Each strike has a 30% chance of poisoning the enemy for 52 Nature damage over 12 sec. Stacks up to 5 times on a single target.",
	},
	[626] = {
		name = "Deadly Poison III",
		icon = 132290,
		desc = "Each strike has a 30% chance of poisoning the enemy for 80 Nature damage over 12 sec. Stacks up to 5 times on a single target.",
	},
	[627] = {
		name = "Deadly Poison IV",
		icon = 132290,
		desc = "Each strike has a 30% chance of poisoning the enemy for 108 Nature damage over 12 sec. Stacks up to 5 times on a single target.",
	},
	[2630] = {
		name = "Deadly Poison V",
		icon = 132290,
		desc = "Each strike has a 30% chance of poisoning the enemy for 136 Nature damage over 12 sec.  Stacks up to 5 times on a single target.",
	},
	[2642] = {
		name = "Deadly Poison VI",
		icon = 132290,
		desc = "Each strike has a 30% chance of poisoning the enemy for 144 Nature damage over 12 sec. Stacks up to 5 times on a single target.",
	},
	[2643] = {
		name = "Deadly Poison VII",
		icon = 132290,
		desc = "Each strike has a 30% chance of poisoning the enemy for 180 Nature damage over 12 sec. Stacks up to 5 times on a single target.",
		maxRank = true,
	},
	[1643] = {
		name = "Dense Sharpening Stone",
		icon = 135252,
		desc = "Increase sharp weapon damage by 8 for 1 hour.",
	},
	[1703] = {
		name = "Dense Weightstone",
		icon = 135259,
		desc = "Increase the damage of a blunt weapon by 8 for 1 hour.",
	},
	[2506] = {
		name = "Elemental Sharpening Stone",
		icon = 135228,
		desc = "Increase the critical strike rating on a melee weapon by 28 for 1 hour.",
		maxRank = true,
	},
	[2712] = {
		name = "Fel Sharpening Stone",
		icon = 135253,
		desc = "Increase sharp weapon damage by 12 for 1 hour.",
	},
	[2954] = {
		name = "Fel Weightstone",
		icon = 135260,
		desc = "Increase blunt weapon damage by 12 for 1 hour.",
	},
	[26] = {
		name = "Frost Oil",
		icon = 134800,
		desc = "10% chance of casting Frostbolt at the opponent when it hits.",
	},
	--[[[2791] = {
		name = "Greater Rune of Warding",
		icon = 134423,
		desc = "Enchant chest armor so it has a 25% chance per hit of giving you 400 points of physical damage absorption. 90 sec cooldown.",
		maxRank = true,
	},
	[2720] = {
		name = "Greater Ward of Shielding",
		icon = 134426,
		desc = "Applies the Greater Ward of Shielding to your shield.  This ward absorbs up to 4000 points of damage before it fails.",
		maxRank = true,
	},]]
	[14] = {
		name = "Heavy Sharpening Stone",
		icon = 135250,
		desc = "Increase sharp weapon damage by 4 for 1 hour.",
	},
	[21] = {
		name = "Heavy Weightstone",
		icon = 135257,
		desc = "Increase the damage of a blunt weapon by 4 for 1 hour.",
	},
	[323] = {
		name = "Instant Poison",
		icon = 132273,
		desc = "Each strike has a 20% chance of poisoning the enemy which instantly inflicts 19 to 25 Nature damage.",
	},
	[324] = {
		name = "Instant Poison II",
		icon = 132273,
		desc = "Each strike has a 20% chance of poisoning the enemy which instantly inflicts 30 to 38 Nature damage.",
	},
	[325] = {
		name = "Instant Poison III",
		icon = 132273,
		desc = "Each strike has a 20% chance of poisoning the enemy which instantly inflicts 44 to 56 Nature damage.",
	},
	[623] = {
		name = "Instant Poison IV",
		icon = 132273,
		desc = "Each strike has a 20% chance of poisoning the enemy which instantly inflicts 67 to 85 Nature damage.",
	},
	[624] = {
		name = "Instant Poison V",
		icon = 132273,
		desc = "Each strike has a 20% chance of poisoning the enemy which instantly inflicts 92 to 118 Nature damage.",
	},
	[625] = {
		name = "Instant Poison VI",
		icon = 132273,
		desc = "Each strike has a 20% chance of poisoning the enemy which instantly inflicts 112 to 148 Nature damage.",
	},
	[2641] = {
		name = "Instant Poison VII",
		icon = 132273,
		desc = "Each strike has a 20% chance of poisoning the enemy which instantly inflicts 146 to 194 Nature damage.",
		maxRank = true,
	},
	[2625] = {
		name = "Lesser Mana Oil",
		icon = 134879,
		desc = "While applied to target weapon it restores 8 mana to the caster every 5 seconds.",
	},
	--[[[2781] = {
		name = "Lesser Rune of Warding",
		icon = 134424,
		desc = "Enchant chest armor so it has a 25% chance per hit of giving you 200 points of physical damage absorption. 90 sec cooldown.",
	},
	[2719] = {
		name = "Lesser Ward of Shielding",
		icon = 134425,
		desc = "Applies the Lesser Ward of Shielding to your shield.  This ward absorbs up to 1000 points of damage before it fails.",
	},]]
	[2626] = {
		name = "Lesser Wizard Oil",
		icon = 134725,
		desc = "While applied to target weapon it increases spell damage by up to 16.",
	},
	[35] = {
		name = "Mind-numbing Poison",
		icon = 136066,
		desc = "Each strike has a 20% chance of poisoning the enemy, increasing their casting time by 40% for 10 sec.",
	},
	[23] = {
		name = "Mind-numbing Poison II",
		icon = 136066,
		desc = "Each strike has a 20% chance of poisoning the enemy, increasing their casting time by 50% for 12 sec.",
	},
	[643] = {
		name = "Mind-numbing Poison III",
		icon = 136066,
		desc = "Each strike has a 20% chance of poisoning the enemy, increasing their casting time by 60% for 14 sec.",
		maxRank = true,
	},
	[2624] = {
		name = "Minor Mana Oil",
		icon = 134878,
		desc = "While applied to target weapon it restores 4 mana to the caster every 5 seconds.",
	},
	[2623] = {
		name = "Minor Wizard Oil",
		icon = 134711,
		desc = "While applied to target weapon it increases spell damage by up to 8.",
	},
	[3266] = {
		name = "Righteous Weapon Coating",
		icon = 134723,
		desc = "While applied to target weapon, wielder has a chance to gain 300 attack power on every melee or ranged attack for 10 sec. Only functions on the Isle of Quel'Danas.",
		maxRank = true,
	},
	[40] = {
		name = "Rough Sharpening Stone",
		icon = 135248,
		desc = "Increase sharp weapon damage by 2 for 1 hour.",
	},
	[19] = {
		name = "Rough Weightstone",
		icon = 135255,
		desc = "Increase the damage of a blunt weapon by 2 for 1 hour.",
	},
	[25] = {
		name = "Shadow Oil",
		icon = 134803,
		desc = "15% chance of casting Shadow Bolt (Rank 3) at the opponent when it hits.",
	},
	[483] = {
		name = "Solid Sharpening Stone",
		icon = 135251,
		desc = "Increase sharp weapon damage by 6 for 1 hour.",
	},
	[484] = {
		name = "Solid Weightstone",
		icon = 135258,
		desc = "Increase the damage of a blunt weapon by 6 for 1 hour.",
	},
	[2677] = {
		name = "Superior Mana Oil",
		icon = 134723,
		desc = "Restores 14 mana to the caster every 5 seconds.",
		maxRank = true,
	},
	[2678] = {
		name = "Superior Wizard Oil",
		icon = 134767,
		desc = "Increases spell damage by up to 42.",
		maxRank = true,
	},
	[2627] = {
		name = "Wizard Oil",
		icon = 134726,
		desc = "Increases spell damage by up to 24.",
	},
	[703] = {
		name = "Wound Poison",
		icon = 134197,
		desc = "Each strike has a 30% chance of poisoning the enemy, causing 17 Nature damage and reducing all healing effects used on them by 10% for 15 sec.",
	},
	[704] = {
		name = "Wound Poison II",
		icon = 134197,
		desc = "Each strike has a 30% chance of poisoning the enemy, causing 25 Nature damage and reducing all healing effects used on them by 10% for 15 sec.",
	},
	[705] = {
		name = "Wound Poison III",
		icon = 134197,
		desc = "Each strike has a 30% chance of poisoning the enemy, causing 38 Nature damage and reducing all healing effects used on them by 10% for 15 sec.",
	},
	[706] = {
		name = "Wound Poison IV",
		icon = 134197,
		desc = "Each strike has a 30% chance of poisoning the enemy, causing 53 Nature damage and reducing all healing effects used on them by 10% for 15 sec.",
	},
	[2644] = {
		name = "Wound Poison V",
		icon = 134197,
		desc = "Each strike has a 30% chance of poisoning the enemy, causing 65 Nature damage and reducing all healing effects used on them by 10% for 15 sec",
		maxRank = true,
	},
	--Shaman self weapon enchants.
	[15] = {
		name = "Flametongue Weapon 1",
		icon = 135814,
		desc = "Each hit causes 6 to 18 additional Fire damage, based on the speed of the weapon.",
	},
	[4] = {
		name = "Flametongue Weapon 2",
		icon = 135814,
		desc = "Each hit causes 9 to 26 additional Fire damage, based on the speed of the weapon.",
	},
	[3] = {
		name = "Flametongue Weapon 3",
		icon = 135814,
		desc = "Each hit causes 22 to 69 additional Fire damage, based on the speed of the weapon.",
	},
	[523] = {
		name = "Flametongue Weapon 4",
		icon = 135814,
		desc = "Each hit causes 6 to 18 additional Fire damage, based on the speed of the weapon.",
	},
	[1665] = {
		name = "Flametongue Weapon 5",
		icon = 135814,
		desc = "Each hit causes 31 to 95 additional Fire damage, based on the speed of the weapon.",
	},
	[1666] = {
		name = "Flametongue Weapon 6",
		icon = 135814,
		desc = "Each hit causes 40 to 124 additional Fire damage, based on the speed of the weapon.",
	},
	[2634] = {
		name = "Flametongue Weapon 7",
		icon = 135814,
		desc = "Each hit causes 46 to 140 additional Fire damage, based on the speed of the weapon.",
		maxRank = true,
	},
	[2] = {
		name = "Frostbrand Weapon 1",
		icon = 135847,
		desc = "Each hit has a chance of causing 48 additional Frost damage and slowing the target's movement speed by 25% for 8 sec.",
	},
	[12] = {
		name = "Frostbrand Weapon 2",
		icon = 135847,
		desc = "Each hit has a chance of causing 77 additional Frost damage and slowing the target's movement speed by 25% for 8 sec.",
	},
	[524] = {
		name = "Frostbrand Weapon 3",
		icon = 135847,
		desc = "Each hit has a chance of causing 124 additional Frost damage and slowing the target's movement speed by 25% for 8 sec.",
	},
	[1667] = {
		name = "Frostbrand Weapon 4",
		icon = 135847,
		desc = "Each hit has a chance of causing 166 additional Frost damage and slowing the target's movement speed by 25% for 8 sec.",
	},
	[1668] = {
		name = "Frostbrand Weapon 5",
		icon = 135847,
		desc = "Each hit has a chance of causing 215 additional Frost damage and slowing the target's movement speed by 25% for 8 sec.",
	},
	[2635] = {
		name = "Frostbrand Weapon 6",
		icon = 135847,
		desc = "Each hit has a chance of causing 246 additional Frost damage and slowing the target's movement speed by 25% for 8 sec.",
		maxRank = true,
	},
	[29] = {
		name = "Rockbiter Weapon 1",
		icon = 136086,
		desc = "Increase weapon damage per second by 2.",
	},
	[6] = {
		name = "Rockbiter Weapon 2",
		icon = 136086,
		desc = "Increase weapon damage per second by 4.",
	},
	[1] = {
		name = "Rockbiter Weapon 3",
		icon = 136086,
		desc = "Increase weapon damage per second by 6.",
	},
	[503] = {
		name = "Rockbiter Weapon 4",
		icon = 136086,
		desc = "Increase weapon damage per second by 9.",
	},
	[1663] = {
		name = "Rockbiter Weapon 5",
		icon = 136086,
		desc = "Increase weapon damage per second by 15.",
	},
	[683] = {
		name = "Rockbiter Weapon 6",
		icon = 136086,
		desc = "Increase weapon damage per second by 28.",
	},
	[1664] = {
		name = "Rockbiter Weapon 7",
		icon = 136086,
		desc = "Increase weapon damage per second by 40.",
	},
	[2632] = {
		name = "Rockbiter Weapon 8",
		icon = 136086,
		desc = "Increase weapon damage per second by 49.",
	},
	[2633] = {
		name = "Rockbiter Weapon 9",
		icon = 136086,
		desc = "Increase weapon damage per second by 62.",
		maxRank = true,
	},
	[283] = {
		name = "Windfury Weapon 1",
		icon = 136018,
		desc = "Each hit has a 20% chance of dealing additional damage equal to two extra attacks with 104 extra attack power.",
	},
	[284] = {
		name = "Windfury Weapon 2",
		icon = 136018,
		desc = "Each hit has a 20% chance of dealing additional damage equal to two extra attacks with 222 extra attack power.",
	},
	[525] = {
		name = "Windfury Weapon 3",
		icon = 136018,
		desc = "Each hit has a 20% chance of dealing additional damage equal to two extra attacks with 316 extra attack power.",
	},
	[1669] = {
		name = "Windfury Weapon 4",
		icon = 136018,
		desc = "Each hit has a 20% chance of dealing additional damage equal to two extra attacks with 433 extra attack power.",
	},
	[2636] = {
		name = "Windfury Weapon 5",
		icon = 136018,
		desc = "Each hit has a 20% chance of dealing additional damage equal to two extra attacks with 475 extra attack power.",
		maxRank = true,
	},
};

--For use with our local talent db, resto and holy works for multiple classes.
NRC.healingSpecs = {
	["Restoration"] = true,
	["Holy"] = true,
	["Discipline"] = true,
};

---These buff tables below are wiped after being loaded locally in RaidStatus.
---They are just loaded here first for expansion seperation reasons.

--The maxRank settings here need fixing for classic if I ever get around to making this addon work properly classic era.

NRC.int = {
	[1459] = {
		name = "Arcane Intellect",
		icon = 135932,
		desc = "+2 Int",
		rank = 1,
	},
	[1460] = {
		name = "Arcane Intellect",
		icon = 135932,
		desc = "+7 Int",
		rank = 2,
	},
	[1461] = {
		name = "Arcane Intellect",
		icon = 135932,
		desc = "+15 Int",
		rank = 3,
	},
	[10156] = {
		name = "Arcane Intellect",
		icon = 135932,
		desc = "+22 Int",
		rank = 4,
	},
	[10157] = {
		name = "Arcane Intellect",
		icon = 135932,
		desc = "+31 Int",
		rank = 5,
	},
	[27126] = {
		name = "Arcane Intellect",
		icon = 135932,
		desc = "+40 Int",
		rank = 6,
		maxRank = true,
	},
	[23028] = {
		name = "Arcane Brilliance",
		icon = 135869,
		desc = "+31 Int",
		rank = 1,
	},
	[27127] = {
		name = "Arcane Brilliance",
		icon = 135869,
		desc = "+40 Int",
		rank = 2,
		maxRank = true,
	},
	[46302] = { --Sunwell zone buff doesn't stack with int, but is overwritten by fort..
		name = "K'iru's Song of Victory",
		icon = 135981,
		desc = "+40 Int",
		rank = 1,
		maxRank = true,
	},
};

NRC.fort = {
	[1243] = {
		name = "Power Word: Fortitude",
		icon = 135987,
		desc = "+3 Stam",
		rank = 1,
	},
	[1244] = {
		name = "Power Word: Fortitude",
		icon = 135987,
		desc = "+8 Stam",
		rank = 2,
	},
	[1245] = {
		name = "Power Word: Fortitude",
		icon = 135987,
		desc = "+20 Stam",
		rank = 3,
	},
	[2791] = {
		name = "Power Word: Fortitude",
		icon = 135987,
		desc = "+32 Stam",
		rank = 4,
	},
	[10937] = {
		name = "Power Word: Fortitude",
		icon = 135987,
		desc = "+43 Stam",
		rank = 5,
	},
	[10938] = {
		name = "Power Word: Fortitude",
		icon = 135987,
		desc = "+54 Stam",
		rank = 6,
	},
	[25389] = {
		name = "Power Word: Fortitude",
		icon = 135987,
		desc = "+79 Stam",
		rank = 7,
		maxRank = true,
	},
	[21562] = {
		name = "Prayer of Fortitude",
		icon = 135941,
		desc = "+43 Stam",
		rank = 1,
	},
	[21564] = {
		name = "Prayer of Fortitude",
		icon = 135941,
		desc = "+54 Stam",
		rank = 2,
	},
	[25392] = {
		name = "Prayer of Fortitude",
		icon = 135941,
		desc = "+79 Stam",
		rank = 3,
		maxRank = true,
	},
};

NRC.spirit = {
	[14752] = {
		name = "Divine Spirit",
		icon = 135898,
		desc = "+17 Spirit",
		rank = 1,
	},
	[14818] = {
		name = "Divine Spirit",
		icon = 135898,
		desc = "+17 Spirit",
		rank = 2,
	},
	[14819] = {
		name = "Divine Spirit",
		icon = 135898,
		desc = "+33 Spirit",
		rank = 3,
	},
	[27841] = {
		name = "Divine Spirit",
		icon = 135898,
		desc = "+40 Spirit",
		rank = 4,
	},
	[25312] = {
		name = "Divine Spirit",
		icon = 135898,
		desc = "+50 Spirit",
		rank = 5,
		maxRank = true,
	},
	[27681] = {
		name = "Prayer of Spirit",
		icon = 135946,
		desc = "+40 Spirit",
		rank = 1,
	},
	[32999] = {
		name = "Prayer of Spirit",
		icon = 135946,
		desc = "+50 Spirit",
		rank = 2,
		maxRank = true,
	},
};

NRC.shadow = {
	[976] = {
		name = "Shadow Protection",
		icon = 136121,
		desc = "+30 Shadow Resistance",
		rank = 1,
	},
	[10957] = {
		name = "Shadow Protection",
		icon = 136121,
		desc = "+45 Shadow Resistance",
		rank = 2,
	},
	[10958] = {
		name = "Shadow Protection",
		icon = 136121,
		desc = "+60 Shadow Resistance",
		rank = 3,
	},
	[25433] = {
		name = "Shadow Protection",
		icon = 136121,
		desc = "+70 Shadow Resistance",
		rank = 4,
		maxRank = true,
	},
	[27683] = {
		name = "Prayer of Shadow Protection",
		icon = 135945,
		desc = "+60 Shadow Resistance",
		rank = 1,
	},
	[39374] = {
		name = "Prayer of Shadow Protection",
		icon = 135945,
		desc = "+70 Shadow Resistance",
		rank = 2,
		maxRank = true,
	},
};


NRC.motw = {
	[1126] = {
		name = "Mark of the Wild",
		icon = 136078,
		desc = "+25 Armor",
		rank = 1,
	},
	[5232] = {
		name = "Mark of the Wild",
		icon = 136078,
		desc = "+2 Stats, +65 Armor",
		rank = 2,
	},
	[6756] = {
		name = "Mark of the Wild",
		icon = 136078,
		desc = "+4 Stats, +105 Armor",
		rank = 3,
	},
	[5234] = {
		name = "Mark of the Wild",
		icon = 136078,
		desc = "+6 Stats, +150 Armor, +5 Resistances",
		rank = 4,
	},
	[8907] = {
		name = "Mark of the Wild",
		icon = 136078,
		desc = "+8 Stats, +195 Armor, +10 Resistances",
		rank = 5,
	},
	[9884] = {
		name = "Mark of the Wild",
		icon = 136078,
		desc = "+10 Stats, +240 Armor, +15 Resistances",
		rank = 6,
	},
	[9885] = {
		name = "Mark of the Wild",
		icon = 136078,
		desc = "+12 Stats, +285 Armor, +20 Resistances",
		rank = 7,
	},
	[26990] = {
		name = "Mark of the Wild",
		icon = 136078,
		desc = "+14 Stats, +350 Armor, +25 Resistances",
		rank = 8,
		maxRank = true,
	},
	[21849] = {
		name = "Gift of the Wild",
		icon = 136038,
		desc = "+10 Stats, +240 Armor, +15 Resistances",
		rank = 1,
	},
	[21850] = {
		name = "Gift of the Wild",
		icon = 136038,
		desc = "+12 Stats, +285 Armor, +20 Resistances",
		rank = 2,
	},
	[26991] = {
		name = "Gift of the Wild",
		icon = 136038,
		desc = "+14 Stats, +350 Armor, +25 Resistances",
		rank = 3,
		maxRank = true,
	},
};

NRC.pal = {
	--Salv.
	[1038] = {
		name = "Blessing of Salvation",
		icon = 135967,
		desc = "-30% Threat",
		maxRank = true,
		order = 1,
	},
	[25895] = {
		name = "Greater Blessing of Salvation",
		icon = 135910,
		desc = "-30% Threat",
		maxRank = true,
		order = 1,
	},
	--Kings.
	[20217] = {
		name = "Blessing of Kings",
		icon = 135995,
		desc = "+10% Stats",
		maxRank = true,
		order = 2,
	},
	[25898] = {
		name = "Greater Blessing of Kings",
		icon = 135993,
		desc = "+10% Stats",
		maxRank = true,
		order = 2,
	},
	--Might.
	[19740] = {
		name = "Blessing of Might",
		icon = 135906,
		desc = "+20 Attack Power",
		rank = 1,
		order = 3,
	},
	[19834] = {
		name = "Blessing of Might",
		icon = 135906,
		desc = "+35 Attack Power",
		rank = 2,
		order = 3,
	},
	[19835] = {
		name = "Blessing of Might",
		icon = 135906,
		desc = "+55 Attack Power",
		rank = 3,
		order = 3,
	},
	[19836] = {
		name = "Blessing of Might",
		icon = 135906,
		desc = "+85 Attack Power",
		rank = 4,
		order = 3,
	},
	[19837] = {
		name = "Blessing of Might",
		icon = 135906,
		desc = "+115 Attack Power",
		rank = 5,
		order = 3,
	},
	[19838] = {
		name = "Blessing of Might",
		icon = 135906,
		desc = "+155 Attack Power",
		rank = 6,
		order = 3,
	},
	[25291] = {
		name = "Blessing of Might",
		icon = 135906,
		desc = "+185 Attack Power",
		rank = 7,
		order = 3,
	},
	[27140] = {
		name = "Blessing of Might",
		icon = 135906,
		desc = "+220 Attack Power",
		rank = 8,
		maxRank = true,
		order = 3,
	},
	[25782] = {
		name = "Greater Blessing of Might",
		icon = 135908,
		desc = "+155 Attack Power",
		rank = 1,
		order = 3,
	},
	[25916] = {
		name = "Greater Blessing of Might",
		icon = 135908,
		desc = "+185 Attack Power",
		rank = 2,
		order = 3,
	},
	[27141] = {
		name = "Greater Blessing of Might",
		icon = 135908,
		desc = "+220 Attack Power",
		rank = 3,
		maxRank = true,
		order = 3,
	},
	--Wisdom.
	[19742] = {
		name = "Blessing of Wisdom",
		icon = 135970,
		desc = "+10 MP5",
		rank = 1,
		order = 4,
	},
	[19850] = {
		name = "Blessing of Wisdom",
		icon = 135970,
		desc = "+15 MP5",
		rank = 2,
		order = 4,
	},
	[19852] = {
		name = "Blessing of Wisdom",
		icon = 135970,
		desc = "+20 MP5",
		rank = 3,
		order = 4,
	},
	[19853] = {
		name = "Blessing of Wisdom",
		icon = 135970,
		desc = "+25 MP5",
		rank = 4,
		order = 4,
	},
	[19854] = {
		name = "Blessing of Wisdom",
		icon = 135970,
		desc = "+30 MP5",
		rank = 5,
		order = 4,
	},
	[25290] = {
		name = "Blessing of Wisdom",
		icon = 135970,
		desc = "+33 MP5",
		rank = 6,
		order = 4,
	},
	[27142] = {
		name = "Blessing of Wisdom",
		icon = 135970,
		desc = "+41 MP5",
		rank = 7,
		maxRank = true,
		order = 4,
	},
	[25894] = {
		name = "Greater Blessing of Wisdom",
		icon = 135912,
		desc = "+30 MP5",
		rank = 1,
		order = 4,
	},
	[25918] = {
		name = "Greater Blessing of Wisdom",
		icon = 135912,
		desc = "+33 MP5",
		rank = 2,
		order = 4,
	},
	[27143] = {
		name = "Greater Blessing of Wisdom",
		icon = 135912,
		desc = "+41 MP5",
		rank = 3,
		maxRank = true,
		order = 4,
	},
	--Light.
	[19977] = {
		name = "Blessing of Light",
		icon = 135943,
		desc = "+210 Holy Light, +60 Flash of Light",
		rank = 1,
		order = 5,
	},
	[19977] = {
		name = "Blessing of Light",
		icon = 135943,
		desc = "+300 Holy Light, +85 Flash of Light",
		rank = 2,
		order = 5,
	},
	[19977] = {
		name = "Blessing of Light",
		icon = 135943,
		desc = "+400 Holy Light, +115 Flash of Light",
		rank = 3,
		order = 5,
	},
	[19977] = {
		name = "Blessing of Light",
		icon = 135943,
		desc = "+580 Holy Light, +185 Flash of Light",
		rank = 4,
		maxRank = true,
		order = 5,
	},
	[25890] = {
		name = "Greater Blessing of Light",
		icon = 135909,
		desc = "+400 Holy Light, +115 Flash of Light",
		rank = 1,
		order = 5,
	},
	[27145] = {
		name = "Greater Blessing of Light",
		icon = 135909,
		desc = "+580 Holy Light, +185 Flash of Light",
		rank = 2,
		maxRank = true,
		order = 5,
	},
	--Sanctuary.
	[20911] = {
		name = "Blessing of Sanctuary",
		icon = 136051,
		desc = "-10 Damage Taken, +14 Shield Block Damage",
		rank = 1,
		order = 6,
	},
	[20912] = {
		name = "Blessing of Sanctuary",
		icon = 136051,
		desc = "-14 Damage Taken, +21 Shield Block Damage",
		rank = 2,
		order = 6,
	},
	[20913] = {
		name = "Blessing of Sanctuary",
		icon = 136051,
		desc = "-19 Damage Taken, +28 Shield Block Damage",
		rank = 3,
		order = 6,
	},
	[20914] = {
		name = "Blessing of Sanctuary",
		icon = 136051,
		desc = "-24 Damage Taken, +35 Shield Block Damage",
		rank = 4,
		order = 6,
	},
	[27168] = {
		name = "Blessing of Sanctuary",
		icon = 136051,
		desc = "-80 Damage Taken, +46 Shield Block Damage",
		rank = 5,
		maxRank = true,
		order = 6,
	},
	[25899] = {
		name = "Greater Blessing of Sanctuary",
		icon = 135911,
		desc = "-24 Damage Taken, +35 Shield Block Damage",
		rank = 1,
		order = 6,
	},
	[27169] = {
		name = "Greater Blessing of Sanctuary",
		icon = 135911,
		desc = "-80 Damage Taken, +46 Shield Block Damage",
		rank = 2,
		maxRank = true,
		order = 6,
	},
};

--for k, v in pairs(NRC.critterCreatures2) do
--	if (not NRC.critterCreatures[k]) then
--		print("[" .. k .. "] = \"" .. v .. "\",");
--	end
--end


--[[NRC.encounters = {
	-------------
	---Classic---
	-------------
	
	--MC.
	[663] = {
		[1] = 3733,
		[2] = "Lucifron",
		[3] = "",
		[4] = 13031,
		[5] = 1378993,
		[6] = 9,
	},
	[664] = {
		[1] = 3734,
		[2] = "Magmadar",
		[3] = "",
		[4] = 10193,
		[5] = 1378995,
		[6] = 9,
	},
	[665] = {
		[1] = 3735,
		[2] = "Gehennas",
		[3] = "",
		[4] = 13030,
		[5] = 1378976,
		[6] = 9,
	},
	[666] = {
		[1] = 3736,
		[2] = "Garr",
		[3] = "",
		[4] = 12110,
		[5] = 1378975,
		[6] = 9,
	},
	[667] = {
		[1] = 3737,
		[2] = "Shazzrah",
		[3] = "",
		[4] = 13032,
		[5] = 1379013,
		[6] = 9,
	},
	[668] = {
		[1] = 3738,
		[2] = "Baron Geddon",
		[3] = "",
		[4] = 12129,
		[5] = 1378966,
		[6] = 9,
	},
	[669] = {
		[1] = 3740,
		[2] = "Sulfuron Harbinger",
		[3] = "",
		[4] = 13030,
		[5] = 1379015,
		[6] = 9,
	},
	[670] = {
		[1] = 3741,
		[2] = "Golemagg the Incinerator",
		[3] = "",
		[4] = 11986,
		[5] = 1378978,
		[6] = 9,
	},
	[671] = {
		[1] = 3742,
		[2] = "Majordomo Executus",
		[3] = "",
		[4] = 12029,
		[5] = 1378998,
		[6] = 9,
	},
	[672] = {
		[1] = 3745,
		[2] = "Ragnaros",
		[3] = "",
		[4] = 11121,
		[5] = 522261,
		[6] = 225,
	},
	--BWL.
	[610] = {
		[1] = 3746,
		[2] = "Razorgore the Untamed",
		[3] = "",
		[4] = 10115,
		[5] = 1379008,
		[6] = 9,
	},
	[611] = {
		[1] = 3747,
		[2] = "Vaelastrasz the Corrupt",
		[3] = "",
		[4] = 13992,
		[5] = 1379022,
		[6] = 9,
	},
	[612] = {
		[1] = 3748,
		[2] = "Broodlord Lashlayer",
		[3] = "",
		[4] = 14308,
		[5] = 1378968,
		[6] = 9,
	},
	[613] = {
		[1] = 3749,
		[2] = "Firemaw",
		[3] = "",
		[4] = 6377,
		[5] = 1378973,
		[6] = 9,
	},
	[614] = {
		[1] = 3750,
		[2] = "Ebonroc",
		[3] = "",
		[4] = 6377,
		[5] = 1378971,
		[6] = 9,
	},
	[615] = {
		[1] = 3751,
		[2] = "Flamegor",
		[3] = "",
		[4] = 6377,
		[5] = 1378974,
		[6] = 9,
	},
	[616] = {
		[1] = 3752,
		[2] = "Chromaggus",
		[3] = "",
		[4] = 14367,
		[5] = 1378969,
		[6] = 9,
	},
	[617] = {
		[1] = 3753,
		[2] = "Nefarian",
		[3] = "",
		[4] = 11380,
		[5] = 1379001,
		[6] = 9,
	},
	--AQ20.
	[718] = {
		[1] = 3754,
		[2] = "Kurinnaxx",
		[3] = "",
		[4] = 15742,
		[5] = 1385749,
		[6] = 9,
	},
	[719] = {
		[1] = 3755,
		[2] = "General Rajaxx",
		[3] = "",
		[4] = 15376,
		[5] = 1385734,
		[6] = 9,
	},
	[720] = {
		[1] = 3756,
		[2] = "Moam",
		[3] = "",
		[4] = 15392,
		[5] = 1385755,
		[6] = 9,
	},
	[721] = {
		[1] = 3757,
		[2] = "Buru the Gorger",
		[3] = "",
		[4] = 15654,
		[5] = 1385723,
		[6] = 9,
	},
	[722] = {
		[1] = 3758,
		[2] = "Ayamiss the Hunter",
		[3] = "",
		[4] = 15431,
		[5] = 1385718,
		[6] = 9,
	},
	[723] = {
		[1] = 3760,
		[2] = "Ossirian the Unscarred",
		[3] = "",
		[4] = 15432,
		[5] = 1385759,
		[6] = 9,
	},
	--AQ40.
	[709] = {
		[1] = 3761,
		[2] = "The Prophet Skeram",
		[3] = "",
		[4] = 15345,
		[5] = 1385769,
		[6] = 9,
	},
	[710] = {
		[1] = 3770,
		[2] = "Lord Kri",
		[3] = "",
		[4] = 15656,
		[5] = 1390436,
		[6] = 9,
	},
	[711] = {
		[1] = 3762,
		[2] = "Battleguard Sartura",
		[3] = "",
		[4] = 15583,
		[5] = 1385720,
		[6] = 9,
	},
	[712] = {
		[1] = 3766,
		[2] = "Fankriss the Unyielding",
		[3] = "",
		[4] = 15743,
		[5] = 1385728,
		[6] = 9,
	},
	[713] = {
		[1] = 3771,
		[2] = "Viscidus",
		[3] = "",
		[4] = 15686,
		[5] = 1385771,
		[6] = 9,
	},
	[714] = {
		[1] = 3767,
		[2] = "Princess Huhuran",
		[3] = "",
		[4] = 15739,
		[5] = 1385761,
		[6] = 9,
	},
	[715] = {
		[1] = 3772,
		[2] = "Emperor Vek'lor",
		[3] = "",
		[4] = 15778,
		[5] = 1390437,
		[6] = 66,
	},
	[716] = {
		[1] = 3774,
		[2] = "Ouro",
		[3] = "",
		[4] = 15509,
		[5] = 1385760,
		[6] = 87,
	},
	[717] = {
		[1] = 3775,
		[2] = "C'Thun",
		[3] = "",
		[4] = 15556,
		[5] = 1385726,
		[6] = 9,
	},
	--ZG (Could be diff encounterIDs on retail? Needs testing on classic).
	[1178] = {
		[1] = 601,
		[2] = "High Priest Venoxis",
		[3] = "",
		[4] = 37788,
		[5] = 522236,
		[6] = 9,
	},
	[1179] = {
		[1] = 602,
		[2] = "Bloodlord Mandokir",
		[3] = "",
		[4] = 37816,
		[5] = 522209,
		[6] = 9,
	},
	[788] = {
		[1] = 603,
		[2] = "Gri'lek",
		[3] = "",
		[4] = 8390,
		[5] = 522230,
		[6] = 9,
	},
	[788] = {
		[1] = 604,
		[2] = "Hazza'rah",
		[3] = "",
		[4] = 37832,
		[5] = 522233,
		[6] = 9,
	},
	[788] = {
		[1] = 605,
		[2] = "Renataki",
		[3] = "",
		[4] = 37830,
		[5] = 522263,
		[6] = 9,
	},
	[788] = {
		[1] = 606,
		[2] = "Wushoolay",
		[3] = "",
		[4] = 37831,
		[5] = 522279,
		[6] = 9,
	},
	[1180] = {
		[1] = 607,
		[2] = "High Priestess Kilnara",
		[3] = "",
		[4] = 37805,
		[5] = 522238,
		[6] = 9,
	},
	[1181] = {
		[1] = 616,
		[2] = "Zanzil",
		[3] = "",
		[4] = 37813,
		[5] = 522280,
		[6] = 9,
	},
	[1182] = {
		[1] = 617,
		[2] = "Jin'do the Godbreaker",
		[3] = "",
		[4] = 37789,
		[5] = 522243,
		[6] = 9,
	},
	--Naxx (Should be diff encounterIDs on retail (wrath)? Needs testing on classic).
	[1107] = {
		[1] = 3853,
		[2] = "Anub'Rekhan",
		[3] = "",
		[4] = 15931,
		[5] = 1378964,
		[6] = 9,
	},
	[1110] = {
		[1] = 3854,
		[2] = "Grand Widow Faerlina",
		[3] = "",
		[4] = 15940,
		[5] = 1378980,
		[6] = 9,
	},
	[1116] = {
		[1] = 3855,
		[2] = "Maexxna",
		[3] = "",
		[4] = 15928,
		[5] = 1378994,
		[6] = 9,
	},
	[1117] = {
		[1] = 3856,
		[2] = "Noth the Plaguebringer",
		[3] = "",
		[4] = 16590,
		[5] = 1379004,
		[6] = 9,
	},
	[1112] = {
		[1] = 3857,
		[2] = "Heigan the Unclean",
		[3] = "",
		[4] = 16309,
		[5] = 1378984,
		[6] = 9,
	},
	[1115] = {
		[1] = 3858,
		[2] = "Loatheb",
		[3] = "",
		[4] = 16110,
		[5] = 1378991,
		[6] = 9,
	},
	[1113] = {
		[1] = 3860,
		[2] = "Instructor Razuvious",
		[3] = "",
		[4] = 16582,
		[5] = 1378988,
		[6] = 9,
	},
	[1109] = {
		[1] = 3861,
		[2] = "Gothik the Harvester",
		[3] = "",
		[4] = 16279,
		[5] = 1378979,
		[6] = 9,
	},
	[1121] = {
		[1] = 3863,
		[2] = "Baron Rivendare",
		[3] = "",
		[4] = 10729,
		[5] = 1385732,
		[6] = 9,
	},
	[1118] = {
		[1] = 3866,
		[2] = "Patchwerk",
		[3] = "",
		[4] = 16174,
		[5] = 1379005,
		[6] = 9,
	},
	[1111] = {
		[1] = 3867,
		[2] = "Grobbulus",
		[3] = "",
		[4] = 16035,
		[5] = 1378981,
		[6] = 9,
	},
	[1108] = {
		[1] = 3868,
		[2] = "Gluth",
		[3] = "",
		[4] = 16064,
		[5] = 1378977,
		[6] = 9,
	},
	[1120] = {
		[1] = 3869,
		[2] = "Thaddius",
		[3] = "",
		[4] = 16137,
		[5] = 1379019,
		[6] = 64,
	},
	[1119] = {
		[1] = 3870,
		[2] = "Sapphiron",
		[3] = "",
		[4] = 16033,
		[5] = 1379010,
		[6] = 9,
	},
	[1114] = {
		[1] = 3871,
		[2] = "Kel'Thuzad",
		[3] = "",
		[4] = 15945,
		[5] = 1378989,
		[6] = 9,
	},]]
	
	---------
	---TBC---
	---------
	
	--Kara.
	--[[[0] = { --Use Rokad the Ravager data for this.
		[1] = 3778, --On second thought just ignore these mini-bosses.
		[2] = "Servant's Quarters",
		[3] = "",
		[4] = 16054,
		[5] = 1385766,
		[6] = 9,
	},]]
	--[[[652] = {
		[1] = 3780,
		[2] = "Attumen the Huntsman",
		[3] = "",
		[4] = 16416,
		[5] = 1378965,
		[6] = 9,
	},
	[653] = {
		[1] = 3781,
		[2] = "Moroes",
		[3] = "",
		[4] = 16540,
		[5] = 1378999,
		[6] = 9,
	},
	[654] = {
		[1] = 3782,
		[2] = "Maiden of Virtue",
		[3] = "",
		[4] = 16198,
		[5] = 1378997,
		[6] = 67,
	},
	[655] = {
		[1] = 3783,
		[2] = "The Big Bad Wolf",
		[3] = "",
		[4] = 17053,
		[5] = 1385758,
		[6] = 9,
	},
	[656] = {
		[1] = 3787,
		[2] = "The Curator",
		[3] = "",
		[4] = 16958,
		[5] = 1379020,
		[6] = 9,
	},
	[658] = {
		[1] = 3789,
		[2] = "Shade of Aran",
		[3] = "",
		[4] = 16621,
		[5] = 1379012,
		[6] = 9,
	},
	[657] = {
		[1] = 3790,
		[2] = "Terestian Illhoof",
		[3] = "",
		[4] = 11343,
		[5] = 1379017,
		[6] = 9,
	},
	[659] = {
		[1] = 3791,
		[2] = "Netherspite",
		[3] = "",
		[4] = 15363,
		[5] = 1379002,
		[6] = 9,
	},
	[660] = {
		[1] = 3792,
		[2] = "Echo of Medivh",
		[3] = "",
		[4] = 18720,
		[5] = 1385725,
		[6] = 9,
	},
	[661] = {
		[1] = 3793,
		[2] = "Prince Malchezaar",
		[3] = "",
		[4] = 19274,
		[5] = 1379006,
		[6] = 9,
	},
	--Gruul's lair.
	[649] = {
		[1] = 3794,
		[2] = "High King Maulgar",
		[3] = "",
		[4] = 18649,
		[5] = 1378985,
		[6] = 9,
	},
	[650] = {
		[1] = 3799,
		[2] = "Gruul the Dragonkiller",
		[3] = "",
		[4] = 18698,
		[5] = 1378982,
		[6] = 9,
	},
	--Magtheridon's lair.
	[651] = {
		[1] = 3801,
		[2] = "Magtheridon",
		[3] = "",
		[4] = 18527,
		[5] = 1378996,
		[6] = 9,
	},
	--SSC.
	[623] = {
		[1] = 3802,
		[2] = "Hydross the Unstable",
		[3] = "",
		[4] = 20162,
		[5] = 1385741,
		[6] = 9,
	},
	[624] = {
		[1] = 3803,
		[2] = "The Lurker Below",
		[3] = "",
		[4] = 20216,
		[5] = 1385768,
		[6] = 88,
	},
	[625] = {
		[1] = 3805,
		[2] = "Leotheras the Blind",
		[3] = "",
		[4] = 20514,
		[5] = 1385751,
		[6] = 9,
	},
	[626] = {
		[1] = 3809,
		[2] = "Fathom-Lord Karathress",
		[3] = "",
		[4] = 20662,
		[5] = 1385729,
		[6] = 9,
	},
	[627] = {
		[1] = 3810,
		[2] = "Morogrim Tidewalker",
		[3] = "",
		[4] = 20739,
		[5] = 1385756,
		[6] = 9,
	},
	[628] = {
		[1] = 3811,
		[2] = "Lady Vashj",
		[3] = "",
		[4] = 20748,
		[5] = 1385750,
		[6] = 9,
	},
	--The eye.
	[730] = {
		[1] = 3812,
		[2] = "Al'ar",
		[3] = "",
		[4] = 18945,
		[5] = 1385712,
		[6] = 9,
	},
	[731] = {
		[1] = 3813,
		[2] = "Void Reaver",
		[3] = "",
		[4] = 18951,
		[5] = 1385772,
		[6] = 9,
	},
	[732] = {
		[1] = 3814,
		[2] = "High Astromancer Solarian",
		[3] = "",
		[4] = 18239,
		[5] = 1385739,
		[6] = 9,
	},
	[733] = {
		[1] = 3818,
		[2] = "Kael'thas Sunstrider",
		[3] = "",
		[4] = 20023,
		[5] = 607669,
		[6] = 9,
	},
	--Hyjal.
	[618] = {
		[1] = 3820,
		[2] = "Rage Winterchill",
		[3] = "",
		[4] = 17444,
		[5] = 1385762,
		[6] = 9,
	},
	[619] = {
		[1] = 3821,
		[2] = "Anetheron",
		[3] = "",
		[4] = 21069,
		[5] = 1385714,
		[6] = 9,
	},
	[620] = {
		[1] = 3822,
		[2] = "Kaz'rogal",
		[3] = "",
		[4] = 17886,
		[5] = 1385745,
		[6] = 9,
	},
	[621] = {
		[1] = 3823,
		[2] = "Azgalor",
		[3] = "",
		[4] = 18526,
		[5] = 1385719,
		[6] = 9,
	},
	[622] = {
		[1] = 3824,
		[2] = "Archimonde",
		[3] = "",
		[4] = 20939,
		[5] = 1385716,
		[6] = 9,
	},
	--Black temple.
	[601] = {
		[1] = 3825,
		[2] = "High Warlord Naj'entus",
		[3] = "",
		[4] = 21174,
		[5] = 1378986,
		[6] = 9,
	},
	[602] = {
		[1] = 3826,
		[2] = "Supremus",
		[3] = "",
		[4] = 21145,
		[5] = 1379016,
		[6] = 9,
	},
	[603] = {
		[1] = 3827,
		[2] = "Shade of Akama",
		[3] = "",
		[4] = 21357,
		[5] = 1379011,
		[6] = 9,
	},
	[604] = {
		[1] = 3848,
		[2] = "Teron Gorefiend",
		[3] = "",
		[4] = 21262,
		[5] = 1379018,
		[6] = 9,
	},
	[605] = {
		[1] = 3829,
		[2] = "Gurtogg Bloodboil",
		[3] = "",
		[4] = 21443,
		[5] = 1378983,
		[6] = 9,
	},
	[606] = {
		[1] = 3832,
		[2] = "Essence of Suffering",
		[3] = "",
		[4] = 21483,
		[5] = 1385764,
		[6] = 9,
	},
	[607] = {
		[1] = 3833,
		[2] = "Mother Shahraz",
		[3] = "",
		[4] = 21252,
		[5] = 1379000,
		[6] = 9,
	},
	[608] = {
		[1] = 3834,
		[2] = "Gathios the Shatterer",
		[3] = "",
		[4] = 21416,
		[5] = 1385743,
		[6] = 9,
	},
	[609] = {
		[1] = 3838,
		[2] = "Illidan Stormrage",
		[3] = "",
		[4] = 21135,
		[5] = 1378987,
		[6] = 9,
	},
	--Sunwell.
	[724] = {
		[1] = 3839,
		[2] = "Kalecgos",
		[3] = "",
		[4] = 23345,
		[5] = 1385744,
		[6] = 9,
	},
	[725] = {
		[1] = 3841,
		[2] = "Brutallus",
		[3] = "",
		[4] = 22711,
		[5] = 1385722,
		[6] = 9,
	},
	[726] = {
		[1] = 3842,
		[2] = "Felmyst",
		[3] = "",
		[4] = 22838,
		[5] = 1385730,
		[6] = 9,
	},
	[727] = {
		[1] = 3844,
		[2] = "Grand Warlock Alythess",
		[3] = "",
		[4] = 23334,
		[5] = 1390438,
		[6] = 9,
	},
	[728] = {
		[1] = 3845,
		[2] = "M'uru",
		[3] = "",
		[4] = 23404,
		[5] = 1385757,
		[6] = 9,
	},
	[729] = {
		[1] = 3847,
		[2] = "Kil'jaeden",
		[3] = "",
		[4] = 23200,
		[5] = 1385746,
		[6] = 89,
	},
	--Zul'aman (These encounterIDs may need updating they seem too high, they could be different in tbc than retail).
	[1189] = {
		[1] = 618,
		[2] = "Akil'zon",
		[3] = "",
		[4] = 21630,
		[5] = 522190,
		[6] = 9,
	},
	[1190] = {
		[1] = 619,
		[2] = "Nalorakk",
		[3] = "",
		[4] = 21631,
		[5] = 522254,
		[6] = 9,
	},
	[1191] = {
		[1] = 620,
		[2] = "Jan'alai",
		[3] = "",
		[4] = 21633,
		[5] = 522242,
		[6] = 9,
	},
	[1192] = {
		[1] = 621,
		[2] = "Halazzi",
		[3] = "",
		[4] = 21632,
		[5] = 522231,
		[6] = 9,
	},
	[1193] = {
		[1] = 622,
		[2] = "Hex Lord Malacrass",
		[3] = "",
		[4] = 22332,
		[5] = 522235,
		[6] = 9,
	},
	[1194] = {
		[1] = 623,
		[2] = "Daakara",
		[3] = "",
		[4] = 38118,
		[5] = 522217,
		[6] = 9,
	},]]
	
	-----------
	---Wrath---
	-----------
	
	--Vault of Archavon.
	--[[[1126] = {
		[1] = 3849,
		[2] = "Archavon the Stone Watcher",
		[3] = "",
		[4] = 26967,
		[5] = 1385715,
		[6] = 64,
	},
	[1127] = {
		[1] = 3850,
		[2] = "Emalon the Storm Watcher",
		[3] = "",
		[4] = 27108,
		[5] = 1385727,
		[6] = 64,
	},
	[1128] = {
		[1] = 3851,
		[2] = "Koralon the Flame Watcher",
		[3] = "",
		[4] = 29524,
		[5] = 1385748,
		[6] = 64,
	},
	[1129] = {
		[1] = 3852,
		[2] = "Toravon the Ice Watcher",
		[3] = "",
		[4] = 31089,
		[5] = 1385767,
		[6] = 65,
	},
	--Naxx.
	[1107] = {
		[1] = 3853,
		[2] = "Anub'Rekhan",
		[3] = "",
		[4] = 15931,
		[5] = 1378964,
		[6] = 9,
	},
	[1110] = {
		[1] = 3854,
		[2] = "Grand Widow Faerlina",
		[3] = "",
		[4] = 15940,
		[5] = 1378980,
		[6] = 9,
	},
	[1116] = {
		[1] = 3855,
		[2] = "Maexxna",
		[3] = "",
		[4] = 15928,
		[5] = 1378994,
		[6] = 9,
	},
	[1117] = {
		[1] = 3856,
		[2] = "Noth the Plaguebringer",
		[3] = "",
		[4] = 16590,
		[5] = 1379004,
		[6] = 9,
	},
	[1112] = {
		[1] = 3857,
		[2] = "Heigan the Unclean",
		[3] = "",
		[4] = 16309,
		[5] = 1378984,
		[6] = 9,
	},
	[1115] = {
		[1] = 3858,
		[2] = "Loatheb",
		[3] = "",
		[4] = 16110,
		[5] = 1378991,
		[6] = 9,
	},
	[1113] = {
		[1] = 3860,
		[2] = "Instructor Razuvious",
		[3] = "",
		[4] = 16582,
		[5] = 1378988,
		[6] = 9,
	},
	[1109] = {
		[1] = 3861,
		[2] = "Gothik the Harvester",
		[3] = "",
		[4] = 16279,
		[5] = 1378979,
		[6] = 9,
	},
	[1121] = {
		[1] = 3863,
		[2] = "Baron Rivendare",
		[3] = "",
		[4] = 10729,
		[5] = 1385732,
		[6] = 9,
	},
	[1118] = {
		[1] = 3866,
		[2] = "Patchwerk",
		[3] = "",
		[4] = 16174,
		[5] = 1379005,
		[6] = 9,
	},
	[1111] = {
		[1] = 3867,
		[2] = "Grobbulus",
		[3] = "",
		[4] = 16035,
		[5] = 1378981,
		[6] = 9,
	},
	[1108] = {
		[1] = 3868,
		[2] = "Gluth",
		[3] = "",
		[4] = 16064,
		[5] = 1378977,
		[6] = 9,
	},
	[1120] = {
		[1] = 3869,
		[2] = "Thaddius",
		[3] = "",
		[4] = 16137,
		[5] = 1379019,
		[6] = 64,
	},
	[1119] = {
		[1] = 3870,
		[2] = "Sapphiron",
		[3] = "",
		[4] = 16033,
		[5] = 1379010,
		[6] = 9,
	},
	[1114] = {
		[1] = 3871,
		[2] = "Kel'Thuzad",
		[3] = "",
		[4] = 15945,
		[5] = 1378989,
		[6] = 9,
	},
	--Obsidian sanctum.
	[1090] = {
		[1] = 3875,
		[2] = "Sartharion",
		[3] = "",
		[4] = 27035,
		[5] = 1385765,
		[6] = 9,
	},
	--Eye of eternity.
	[1094] = {
		[1] = 3876,
		[2] = "Malygos",
		[3] = "",
		[4] = 26752,
		[5] = 1385753,
		[6] = 9,
	},
	--Ulduar.
	[1132] = {
		[1] = 3928,
		[2] = "Flame Leviathan",
		[3] = "",
		[4] = 28875,
		[5] = 1385731,
		[6] = 9,
	},
	[1136] = {
		[1] = 3929,
		[2] = "Ignis the Furnace Master",
		[3] = "",
		[4] = 29185,
		[5] = 1385742,
		[6] = 64,
	},
	[1139] = {
		[1] = 3930,
		[2] = "Razorscale",
		[3] = "",
		[4] = 28787,
		[5] = 1385763,
		[6] = 9,
	},
	[1142] = {
		[1] = 3931,
		[2] = "XT-002 Deconstructor",
		[3] = "",
		[4] = 28611,
		[5] = 1385773,
		[6] = 9,
	},
	[1140] = {
		[1] = 3933,
		[2] = "Steelbreaker",
		[3] = "",
		[4] = 28344,
		[5] = 1390439,
		[6] = 65,
	},
	[1137] = {
		[1] = 3935,
		[2] = "Kologarn",
		[3] = "",
		[4] = 28638,
		[5] = 1385747,
		[6] = 90,
	},
	[1131] = {
		[1] = 3936,
		[2] = "Auriaya",
		[3] = "",
		[4] = 28651,
		[5] = 1385717,
		[6] = 67,
	},
	[1135] = {
		[1] = 3937,
		[2] = "Hodir",
		[3] = "",
		[4] = 28743,
		[5] = 1385740,
		[6] = 65,
	},
	[1141] = {
		[1] = 3939,
		[2] = "Thorim",
		[3] = "",
		[4] = 28977,
		[5] = 1385770,
		[6] = 65,
	},
	[1133] = {
		[1] = 3941,
		[2] = "Freya",
		[3] = "",
		[4] = 28777,
		[5] = 1385733,
		[6] = 67,
	},
	[1138] = {
		[1] = 3944,
		[2] = "Mimiron",
		[3] = "",
		[4] = 28578,
		[5] = 1385754,
		[6] = 9,
	},
	[1134] = {
		[1] = 3945,
		[2] = "General Vezax",
		[3] = "",
		[4] = 28548,
		[5] = 1385735,
		[6] = 9,
	},
	[1143] = {
		[1] = 3946,
		[2] = "Yogg-Saron",
		[3] = "",
		[4] = 28817,
		[5] = 1385774,
		[6] = 9,
	},
	[1130] = {
		[1] = 3947,
		[2] = "Algalon the Observer",
		[3] = "",
		[4] = 28641,
		[5] = 1385713,
		[6] = 9,
	},
	--Trial of the crusader.
	[1088] = {
		[1] = 3878,
		[2] = "Gormok the Impaler",
		[3] = "",
		[4] = 29614,
		[5] = 1390440,
		[6] = 9,
	},
	[1087] = {
		[1] = 3881,
		[2] = "Lord Jaraxxus",
		[3] = "",
		[4] = 29615,
		[5] = 1385752,
		[6] = 9,
	},
	[1086] = {
		[1] = 3907,
		[2] = "Birana Stormhoof",
		[3] = "",
		[4] = 29781,
		[5] = 1390441,
		[6] = 9,
	},
	[1089] = {
		[1] = 3911,
		[2] = "Fjola Lightbane",
		[3] = "",
		[4] = 29240,
		[5] = 1390443,
		[6] = 9,
	},
	[1085] = {
		[1] = 3912,
		[2] = "Anub'arak",
		[3] = "",
		[4] = 29268,
		[5] = 607542,
		[6] = 9,
	},
	--Onyxia.
	[1084] = {
		[1] = 3948,
		[2] = "Onyxia",
		[3] = "",
		[4] = 8570,
		[5] = 1379025,
		[6] = 9,
	},
	--ICC.
	[1101] = {
		[1] = 3913,
		[2] = "Lord Marrowgar",
		[3] = "",
		[4] = 31119,
		[5] = 1378992,
		[6] = 9,
	},
	[1100] = {
		[1] = 3914,
		[2] = "Lady Deathwhisper",
		[3] = "",
		[4] = 30893,
		[5] = 1378990,
		[6] = 9,
	},
	[1099] = {
		[1] = 3915,
		[2] = "High Overlord Saurfang",
		[3] = "",
		[4] = 30416,
		[5] = 1385737,
		[6] = 9,
	},
	[1096] = {
		[1] = 3917,
		[2] = "Deathbringer Saurfang",
		[3] = "",
		[4] = 30790,
		[5] = 1378970,
		[6] = 9,
	},
	[1097] = {
		[1] = 3918,
		[2] = "Festergut",
		[3] = "",
		[4] = 31006,
		[5] = 1378972,
		[6] = 66,
	},
	[1104] = {
		[1] = 3919,
		[2] = "Rotface",
		[3] = "",
		[4] = 31005,
		[5] = 1379009,
		[6] = 66,
	},
	[1102] = {
		[1] = 3920,
		[2] = "Professor Putricide",
		[3] = "",
		[4] = 30881,
		[5] = 1379007,
		[6] = 9,
	},
	[1095] = {
		[1] = 3922,
		[2] = "Prince Valanar",
		[3] = "",
		[4] = 30858,
		[5] = 1385721,
		[6] = 9,
	},
	[1103] = {
		[1] = 3924,
		[2] = "Blood-Queen Lana'thel",
		[3] = "",
		[4] = 31165,
		[5] = 1378967,
		[6] = 9,
	},
	[1098] = {
		[1] = 3925,
		[2] = "Valithria Dreamwalker",
		[3] = "",
		[4] = 30318,
		[5] = 1379023,
		[6] = 9,
	},
	[1105] = {
		[1] = 3926,
		[2] = "Sindragosa",
		[3] = "",
		[4] = 30362,
		[5] = 1379014,
		[6] = 9,
	},
	[1106] = {
		[1] = 3927,
		[2] = "The Lich King",
		[3] = "",
		[4] = 30721,
		[5] = 607688,
		[6] = 9,
	},
	--Ruby sanctum.
	[1150] = {
		[1] = 3949,
		[2] = "Halion",
		[3] = "",
		[4] = 31952,
		[5] = 1385738,
		[6] = 9,
	},]]
	
	----------
	---Cata---
	----------
	
	--Baradin hold.
	--[[[1033] = {
		[1] = 463,
		[2] = "Argaloth",
		[3] = "",
		[4] = 35426,
		[5] = 522198,
		[6] = 9,
	},
	[1250] = {
		[1] = 464,
		[2] = "Occu'thar",
		[3] = "",
		[4] = 37876,
		[5] = 523207,
		[6] = 9,
	},
	[1332] = {
		[1] = 896,
		[2] = "Alizabal",
		[3] = "",
		[4] = 21252,
		[5] = 571742,
		[6] = 9,
	},	
	--Blackwing descent.
	[1027] = {
		[1] = 591,
		[2] = "Magmatron", --Omnotron defense system.
		[3] = "",
		[4] = 32685,
		[5] = 522250,
		[6] = 9,
	},
	[1024] = {
		[1] = 593,
		[2] = "Magmaw",
		[3] = "",
		[4] = 37993,
		[5] = 522251,
		[6] = 9,
	},
	[1022] = {
		[1] = 594,
		[2] = "Atramedes",
		[3] = "",
		[4] = 34547,
		[5] = 522202,
		[6] = 9,
	},
	[1023] = {
		[1] = 595,
		[2] = "Chimaeron",
		[3] = "",
		[4] = 33308,
		[5] = 522211,
		[6] = 9,
	},
	[1025] = {
		[1] = 596,
		[2] = "Maloriak",
		[3] = "",
		[4] = 33186,
		[5] = 522252,
		[6] = 9,
	},
	[1026] = {
		[1] = 600,
		[2] = "Nefarian",
		[3] = "",
		[4] = 32716,
		[5] = 522255,
		[6] = 9,
	},
	--The bastion of twilight.
	[1030] = {
		[1] = 559,
		[2] = "Halfus Wyrmbreaker",
		[3] = "",
		[4] = 34816,
		[5] = 522232,
		[6] = 66,
	},
	[1032] = {
		[1] = 561,
		[2] = "Theralion",
		[3] = "",
		[4] = 34813,
		[5] = 522274,
		[6] = 9,
	},
	[1028] = {
		[1] = 565,
		[2] = "Feludius",
		[3] = "Ascendant Councillor of Water",
		[4] = 34822,
		[5] = 522224,
		[6] = 9,
	},
	[1029] = {
		[1] = 587,
		[2] = "Cho'gall",
		[3] = "",
		[4] = 34576,
		[5] = 522212,
		[6] = 9,
	},
	--Throne of the four winds.
	[1035] = {
		[1] = 556,
		[2] = "Anshal",
		[3] = "Lord of the West Wind",
		[4] = 35233,
		[5] = 522196,
		[6] = 9,
	},
	[1034] = {
		[1] = 558,
		[2] = "Al'akir",
		[3] = "",
		[4] = 35248,
		[5] = 522191,
		[6] = 9,
	},
	--Firelands.
	[1197] = {
		[1] = 624,
		[2] = "Beth'tilac",
		[3] = "",
		[4] = 38227,
		[5] = 522208,
		[6] = 9,
	},
	[1204] = {
		[1] = 625,
		[2] = "Lord Rhyolith",
		[3] = "",
		[4] = 38414,
		[5] = 522248,
		[6] = 9,
	},
	[1206] = {
		[1] = 626,
		[2] = "Alysrazor",
		[3] = "",
		[4] = 38446,
		[5] = 522193,
		[6] = 9,
	},
	[1205] = {
		[1] = 627,
		[2] = "Shannox",
		[3] = "",
		[4] = 38448,
		[5] = 522268,
		[6] = 9,
	},
	[1200] = {
		[1] = 770,
		[2] = "Baleroc",
		[3] = "",
		[4] = 38621,
		[5] = 522204,
		[6] = 9,
	},
	[1185] = {
		[1] = 628,
		[2] = "Majordomo Staghelm",
		[3] = "",
		[4] = 37953,
		[5] = 522223,
		[6] = 9,
	},
	[1203] = {
		[1] = 629,
		[2] = "Ragnaros",
		[3] = "",
		[4] = 37875,
		[5] = 522261,
		[6] = 280,
	},
	--Dragon soul.
	[1292] = {
		[1] = 881,
		[2] = "Morchok",
		[3] = "",
		[4] = 39094,
		[5] = 536058,
		[6] = 9,
	},
	[1294] = {
		[1] = 867,
		[2] = "Warlord Zon'ozz",
		[3] = "",
		[4] = 39138,
		[5] = 536061,
		[6] = 9,
	},
	[1295] = {
		[1] = 876,
		[2] = "Yor'sahj the Unsleeping",
		[3] = "",
		[4] = 39101,
		[5] = 536062,
		[6] = 9,
	},
	[1296] = {
		[1] = 856,
		[2] = "Hagara the Stormbinder",
		[3] = "",
		[4] = 39318,
		[5] = 536057,
		[6] = 9,
	},
	[1297] = {
		[1] = 875,
		[2] = "Ultraxion",
		[3] = "",
		[4] = 39099,
		[5] = 571750,
		[6] = 9,
	},
	[1298] = {
		[1] = 877,
		[2] = "Warmaster Blackhorn",
		[3] = "",
		[4] = 39399,
		[5] = 571752,
		[6] = 9,
	},
	[1291] = {
		[1] = 855,
		[2] = "Deathwing",
		[3] = "",
		[4] = 35268,
		[5] = 536056,
		[6] = 9,
	},
	[1299] = {
		[1] = 905,
		[2] = "Deathwing",
		[3] = "",
		[4] = 40087,
		[5] = 536055,
		[6] = 9,
	},]]
--};