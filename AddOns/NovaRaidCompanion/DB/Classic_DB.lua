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
	[48] = {"Blackfathom Deeps", "Once dedicated to the night elves' goddess Elune, Blackfathom Deeps was thought to have been destroyed during the Sundering, lost beneath the ocean. Millennia later, members of the Twilight's Hammer cult were drawn to the temple by whispers and foul dreams. After sacrificing untold numbers of innocents, the cult was rewarded with a new task: to protect one of the Old Gods' most cherished creatures, a pet that is still in need of nurturing before he can unleash his dark powers on the world.", 608156, 608234, 608195, 136325, 221},
	[230] = {"Blackrock Depths", "The smoldering Blackrock Depths are home to the Dark Iron dwarves and their emperor, Dagran Thaurissan. Like his predecessors, he serves under the iron rule of Ragnaros the Firelord, a merciless being summoned into the world centuries ago. The presence of chaotic elementals has attracted Twilight's Hammer cultists to the mountain domain. Along with Ragnaros' servants, they have pushed the dwarves toward increasingly destructive ends that could soon spell doom for all of Azeroth.", 608157, 608235, 608196, 136326, 242},
	[36] = {"Deadmines", "It is said the Deadmines' gold deposits once accounted for a third of Stormwind's treasure reserves. Amid the chaos of the First War, the mines were abandoned and later thought to be haunted, leaving them relatively untouched until the Defias Brotherhood--a group of former laborers turned brigands--claimed the labyrinth as a base of operations for its subversive activities against Stormwind.", 522336, 526404, 522352, 136332, 291},
	[429] = {"Dire Maul", "Built thousands of years ago to house the kaldorei's arcane secrets, the formerly great city of Eldre'Thalas now lies in ruin, writhing with warped, twisted forces. Competing covens once fought for control of Dire Maul's corrupted energy, but they have since settled into uneasy truces, choosing to exploit the power within their own territories rather than continue to battle over the entire complex.", 608161, 608239, 608200, 136333, 240},
	[90] = {"Gnomeregan", "Built deep within the mountains of Dun Morogh, the wondrous city of Gnomeregan was a testament to the gnomes' intelligence and industry. But when the capital was invaded by troggs, the gnomish high tinker was betrayed by his advisor Sicco Thermaplugg. As a result, Gnomeregan was irradiated, and most of its inhabitants slain. The surviving gnomes fled, vowing to return someday and retake their home.", 608163, 608241, 608202, 136336, 226},
	[229] = {"Lower Blackrock Spire", "This imposing fortress, carved into the fiery core of Blackrock Mountain, represented the might of the Dark Iron clan for centuries. More recently, the black dragon Nefarian and his spawn seized the keep's upper spire and ignited a brutal war against the dwarves. The draconic armies have since allied with Warchief Rend Blackhand and his false Horde. This combined force lords over the spire, conducting horrific experiments to bolster its ranks while plotting the meddlesome Dark Irons' downfall.", 608158, 608236, 608197, 136327, 252},
	[349] = {"Maraudon", "According to legend, Zaetar, son of Cenarius, and the earth elemental princess Theradras begot the barbaric centaur race. Shortly after the centaur's creation, the ruthless creatures murdered their father. The grief-stricken Theradras is said to have trapped her lover's spirit within Maraudon, corrupting the region. Now, vicious centaur ghosts and twisted elemental minions roam every corner of the sprawling caves.", 608170, 608248, 608209, 136345, 280},
	[389] = {"Ragefire Chasm", "Ragefire Chasm extends deep below the city of Orgrimmar. Barbaric troggs and devious Searing Blade cultists once plagued the volcanic caves, but now a new threat has emerged: dark shaman. Although Warchief Garrosh Hellscream recently called on a number of shaman to use the elements as weapons against the Alliance, the chasm's current inhabitants appear to be renegades. Reports have surfaced that these shadowy figures are amassing a blistering army that could wreak havoc if unleashed upon Orgrimmar.", 608172, 608250, 608211, 136350, 213},
	[129] = {"Razorfen Downs", "Legends state that where the demigod Agamaggan fell, his blood gave rise to great masses of thorny vines. Recently, scouts have reported seeing undead milling about the region, engendering fears that the dreaded Scourge may be moving to conquer Kalimdor.", 608173, 608251, 608212, 136352, 300},
	[47] = {"Razorfen Kraul", "Legends state that where the demigod Agamaggan fell, his blood gave rise to great masses of thorny vines. Many quilboar have taken up residence in the largest cluster of giant thorns, the Razorfen, which they revere as Agamaggan's resting place.", 608174, 608252, 608213, 136353, 301},
	[1001] = {"Scarlet Halls", "The Crusade's fiercest warriors, those who have held their ground and fought to defend the monastery throughout these dark times, are rapidly preparing an army within the Scarlet Halls. These soldiers are bound by their hatred of the unliving, and they are willing to sacrifice everything for their order's righteous cause.", 643259, 643265, 643262, 643268, 431},
	[1004] = {"Scarlet Monastery", "The Crusade's fanatical leaders direct their followers from the Scarlet Cathedral, at the heart of the monastery grounds. This heavily guarded location functions as the order's headquarters, and some of the most zealous and intolerant crusaders roam the halls of this once-hallowed place.", 608175, 608253, 608214, 136354, 435},
	[1007] = {"Scholomance", "Individuals seeking to master the powers of undeath know well of Scholomance, the infamous school of necromancy located in the dark and foreboding crypts beneath Caer Darrow. In recent years, several of the instructors have changed, but the institution remains under the control of Darkmaster Gandling, a particularly sadistic and insidious practitioner of necromantic magic.", 608176, 608254, 608215, 136355, 476},
	[33] = {"Shadowfang Keep", "Looming over Pyrewood Village from the southern bluffs of Silverpine Forest, Shadowfang Keep casts a shadow as dark as its legacy. Sinister forces occupy these ruins, formerly the dwelling of the mad archmage Arugal's worgen. The restless shade of Baron Silverlaine lingers, while Lord Godfrey and his cabal of erstwhile Gilnean noblemen plot against their enemies both living and undead.", 522342, 526410, 522358, 136357, 310},
	[329] = {"Stratholme", "Stratholme was once the jewel of northern Lordaeron, but today it is remembered for its harrowing fall to ruin. It was here that Prince Arthas turned his back on the noble paladin Uther Lightbringer, slaughtering countless residents believed to be infected with the horrific plague of undeath. Ever since, cursed Stratholme has been marred by death, betrayal, and hopelessness.", 608177, 608255, 608216, 136359, 317},
	[34] = {"The Stockade", "Stormwind Stockade is a closely guarded prison built beneath the canals of Stormwind City. Warden Thelwater keeps watch over the stockade and the highly dangerous criminals who call it home. Recently, the inmates revolted, overthrowing their guards and plunging the prison into a state of pandemonium.", 608184, 608262, 608223, 136358, 225},
	[109] = {"The Temple of Atal'hakkar", "Thousands of years ago, the Gurubashi empire was plunged into a civil war by a powerful sect of priests, the Atal'ai, who sought to summon to Azeroth an avatar of their god of blood, Hakkar the Soulflayer. The Gurubashi people exiled the Atal'ai to the Swamp of Sorrows, where the priests built the Temple of Atal'Hakkar. Ysera, Aspect of the green dragonflight, sank the temple beneath the swamp and assigned wardens to ensure that the summoning rituals never be performed again.", 608178, 608256, 608217, 136360, 220},
	[70] = {"Uldaman", "Uldaman is an ancient titan vault buried deep within the earth. It is said the titans sealed away a failed experiment there and then moved on to a new project, related to the genesis of the dwarves. Tales of a fabled treasure containing great knowledge have enticed would-be treasure hunters to dig deeper into the secrets of Uldaman, a task made perilous by the presence of stone defenders, savage troggs, Dark Iron invaders, and other dangers lurking in the lost city.", 608186, 608264, 608225, 136363, 230},
	[43] = {"Wailing Caverns", "Years ago, the famed druid Naralex and his followers descended into the shadowy Wailing Caverns, named for the mournful cry one hears when steam bursts from the cave system's fissures. Naralex planned to use the underground springs to restore lushness to the arid Barrens. But upon entering the Emerald Dream, he saw his vision of regrowth turn into a waking nightmare, one that has plagued the caverns ever since.", 608190, 608313, 608229, 136364, 279},
	[209] = {"Zul'Farrak", "Zul'Farrak was once the shining jewel of Tanaris, ferociously protected by the cunning Sandfury tribe. Despite the trolls' tenacity, this isolated group was forced to surrender much of its territory throughout history. Now, it appears that Zul'Farrak's inhabitants are creating a horrific army of undead trolls to conquer the surrounding region. Other disturbing rumors tell of an ancient creature sleeping within the city--one that, if awakened, will rain death and destruction across Tanaris.", 608191, 608267, 608230, 136368, 219},
	--Classic raids.
	[249] = {"Onyxia's Lair", "", 1396463, 1396508, 1396589, 329121, 0},
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
		maxRank = true,
	},
	[17626] = {
		name = "Flask of the Titans",
		icon = 134842,
		desc = "+400 HP",
		maxRank = true,
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
		maxRank = true,
	},
};

NRC.battleElixirs = {
	[2374] = {
		name = "Elixir of Minor Agility",
		icon = 134873,
		desc = "+4 Agility",
	},
	[2367] = {
		name = "Elixir of Lion's Strength",
		icon = 134838,
		desc = "+4 Strength",
	},
	[8212] = {
		name = "Elixir of Giant Growth",
		icon = 136101,
		desc = "+8 Strength",
		maxRankSodPhases = {1}, --8.
	},
	[3166] = {
		name = "Elixir of Wisdom",
		icon = 134721,
		desc = "+6 Intellect",
		maxRankSodPhases = {1}, --10.
	},
	[7844] = {
		name = "Elixir of Firepower",
		icon = 134813,
		desc = "Increase spell fire damage by up to 10",
		maxRankSodPhases = {1}, --18.
	},
	[3160] = {
		name = "Elixir of Lesser Agility",
		icon = 134873,
		desc = "+8 Agility",
		maxRankSodPhases = {1}, --18.
	},
	[3164] = {
		name = "Elixir of Ogre's Strength",
		icon = 134838,
		desc = "+8 Strength",
		maxRankSodPhases = {1}, --20.
	},
	[11328] = {
		name = "Elixir of Agility",
		icon = 134873,
		desc = "+15 Agility",
	},
	[17708] = {
		name = "Elixir of Frost Power",
		icon = 134714,
		desc = "Increase spell frost damage by up to 15",
		maxRankSodPhases = {2}, --28.
	},
	[11390] = {
		name = "Arcane Elixir",
		icon = 134810,
		desc = "Increase spell damage by up to 20",
		maxRankSodPhases = {2}, --37.
	},
	[11396] = {
		name = "Elixir of Greater Intellect",
		icon = 134721,
		desc = "+25 Intellect",
		maxRankSodPhases = {2}, --37.
	},
	[11405] = {
		name = "Elixir of Giants",
		icon = 134841,
		desc = "+25 Strength",
		maxRankSodPhases = {2}, --38.
	},
	[11334] = {
		name = "Elixir of Greater Agility",
		icon = 134873,
		desc = "+25 Agility",
		maxRankSodPhases = {2}, --38.
	},
	[11406] = {
		name = "Elixir of Demonslaying",
		icon = 135957,
		desc = "Increase attack power by 265 against demons",
		maxRank = true,
	},
	[26276] = {
		name = "Elixir of Greater Firepower",
		icon = 134840,
		desc = "Increase spell fire damage by up to 40",
		maxRank = true,
	},
	[11474] = {
		name = "Elixir of Shadow Power",
		icon = 134826,
		desc = "Increase spell shadow damage by up to 40",
		maxRank = true,
	},
	[24363] = {
		name = "Mageblood Potion",
		icon = 134825,
		desc = "+12 MP5",
		maxRank = true,
	},
	[17535] = {
		name = "Elixir of the Sages",
		icon = 134809,
		desc = "+18 Intellect, +18 Spirit",
		maxRank = true,
	},
	[10693] = {
		name = "Gizzard Gum",
		icon = 135818,
		desc = "+25 Spirit",
		maxRank = true,
	},
	[17537] = {
		name = "Elixir of Brute Force",
		icon = 134820,
		desc = "+18 Strength, +18 Stamina",
		maxRank = true,
	},
	[10669] = {
		name = "Ground Scorpok Assay",
		icon = 136036,
		desc = "+25 Agility",
		maxRank = true,
	},
	[10667] = {
		name = "R.O.I.D.S",
		icon = 136101,
		desc = "+25 Strength",
		maxRank = true,
	},
	[17038] = {
		name = "Winterfall Firewater",
		icon = 134872,
		desc = "Increase melee attack power by 35",
		maxRank = true,
	},
	[17538] = {
		name = "Elixir of the Mongoose",
		icon = 134812,
		desc = "+25 Agility and 2% Crit",
		maxRank = true,
	},
	[17539] = {
		name = "Greater Arcane Elixir",
		icon = 134805,
		desc = "Increase spell damage by up to 35",
		maxRank = true,
	},
};

NRC.guardianElixirs = {
	[3219] = {
		name = "Weak Troll's Blood Potion",
		icon = 134859,
		desc = "Regenerate 2 health every 5 seconds",
	},
	[3222] = {
		name = "Strong Troll's Blood Potion",
		icon = 134859,
		desc = "Regenerate 6 health every 5 seconds",
		maxRankSodPhases = {1}, --15.
	},
	[673] = {
		name = "Elixir of Minor Defense",
		icon = 134845,
		desc = "+50 Armor",
	},
	[2378] = {
		name = "Elixir of Minor Fortitude",
		icon = 134824,
		desc = "+27 Health",
	},
	[3220] = {
		name = "Elixir of Defense",
		icon = 134866,
		desc = "+150 Armor",
		maxRankSodPhases = {1}, --16.
	},
	[3693] = {
		name = "Elixir of Fortitude",
		icon = 134824,
		desc = "+120 Health",
		maxRankSodPhases = {1}, --25.
	},
	[3223] = {
		name = "Mighty Troll's Blood Potion",
		icon = 134859,
		desc = "Regenerate 12 health every 5 seconds",
		maxRankSodPhases = {2, 3}, --26.
	},
	[11349] = {
		name = "Elixir of Greater Defense",
		icon = 134866,
		desc = "+250 Armor",
		maxRankSodPhases = {2}, --29.
	},
	[11348] = {
		name = "Elixir of Superior Defense",
		icon = 134866,
		desc = "+450 Armor",
		maxRank = true,
	},
	[10668] = {
		name = "Lung Juice Cocktail",
		icon = 136075,
		desc = "+25 Stamina",
		maxRank = true,
	},
	[10692] = {
		name = "Cerebral Cortex Compound",
		icon = 135988,
		desc = "+25 Intellect",
		maxRank = true,
	},
	[24361] = {
		name = "Major Troll's Blood Potion",
		icon = 134859,
		desc = "Regenerate 20 health every 5 seconds",
		maxRank = true,
	},
};

NRC.zanza = {

};

NRC.foods = {
	--minlevel numbers are off.  "Food" may list minlevel 35, but one of the used by food items may have a minlevel 20.
	--"Well Fed" doesn't have any minlevel.
	[19705] = {
		name = "Well Fed",
		icon = 136000,
		desc = "+2 Spirit, +2 Stamina",
	},
	[19706] = {
		name = "Well Fed",
		icon = 136000,
		desc = "+4 Spirit, +4 Stamina",
	},
	[19708] = {
		name = "Well Fed",
		icon = 136000,
		desc = "+6 Spirit, +6 Stamina",
	},
	[19709] = {
		name = "Well Fed",
		icon = 136000,
		desc = "+8 Spirit, +8 Stamina",
		maxRankSodPhases = {1}, --20.
	},
	[19710] = {
		name = "Well Fed",
		icon = 136000,
		desc = "+12 Spirit, +12 Stamina",
	},
	[19711] = {
		name = "Well Fed",
		icon = 136000,
		desc = "+14 Spirit, +14 Stamina",
	},
	[24799] = {
		name = "Well Fed",
		icon = 136000,
		desc = "+20 Strength",
	},
	[24870] = {
		name = "Well Fed",
		icon = 136000,
		desc = "+25 percent Spirit of level, +25 percent Stamina of level",
	},
	[25694] = {
		name = "Well Fed",
		icon = 136000,
		desc = "+3 MP5",
	},
	[25941] = {
		name = "Well Fed",
		icon = 136000,
		desc = "+6 MP5",
	},
	[18191] = {
		name = "Increased Stamina",
		icon = 136000,
		desc = "+10 Stamina",
		maxRankSodPhases = {2}, --35.
	},
	[18192] = {
		name = "Increased Agility",
		icon = 136000,
		desc = "+10 Agility",
		maxRankSodPhases = {2}, --35.
	},
	[18193] = {
		name = "Increased Spirit",
		icon = 136000,
		desc = "+10 Spirit",
		maxRankSodPhases = {2}, --35.
	},
	[18222] = {
		name = "Health Regeneration",
		icon = 136000,
		desc = "Regenerate 6 Health every 5 seconds",
		maxRankSodPhases = {2}, --35.
	},
	[18194] = {
		name = "Mana Regeneration",
		icon = 136000,
		desc = "Regenerate 8 Mana every 5 seconds",
		maxRankSodPhases = {2}, --35.
	},
	[22730] = {
		name = "Increased Intellect",
		icon = 136000,
		desc = "+10 Intellect",
		maxRankSodPhases = {2}, --55.
	},--
};

--"Food" buffs used in RaidStatus to show player is currently eating buff food, these must match all foods above.
--Current expansion and 1 previous expansion.
NRC.eating = {
	[5004] = "Food", --2 stam 2 spirit.
	[5005] = "Food", --4 stam 4 spirit.
	[5006] = "Food", --6 stam 6 spirit.
	[5007] = "Food", --8 stam 8 spirit.
	[10256] = "Food", --12 stam 12 spirit.
	[10257] = "Food", --14 stam 14 spirit.
	[24800] = "Food", --20 strength.
	[18229] = "Food", --+10 Stamina, 35.
	[18230] = "Food", --+10 Agility, 35.
	[18231] = "Food", --+10 Spirit, 35.
	[18232] = "Food", --+6 Health every 5 seconds, 35.
	[18233] = "Food", --+8 Mana every 5 seconds, 35.
	[18234] = "Food", --+10 Stamina, 55, has level 35 equivalent.
	[22731] = "Food", --+Intellect, 55.
};

NRC.scrolls = {
	[8115] = {
		name = "Scroll of Agility",
		icon = 135879,
		desc = "+5 Agility",
		order = 19,
		itemID = 10309,
		itemIcon = 134938,
		quality = 1,
	},
	[8116] = {
		name = "Scroll of Agility II",
		icon = 135879,
		desc = "+9 Agility",
		order = 13,
		itemID = 10309,
		itemIcon = 134938,
		quality = 1,
		maxRankSodPhases = {1}, --25.
	},
	[8117] = {
		name = "Scroll of Agility III",
		icon = 135879,
		desc = "+13 Agility",
		order = 7,
		itemID = 10309,
		itemIcon = 134938,
		quality = 1,
		maxRankSodPhases = {2, 3}, --40.
	},
	[12174] = {
		name = "Scroll of Agility IV",
		icon = 135879,
		desc = "+17 Agility",
		order = 1,
		itemID = 10309,
		itemIcon = 134938,
		quality = 1,
		maxRank = true,
	},
	[8118] = {
		name = "Scroll of Strength",
		icon = 136101,
		desc = "+5 Strength",
		order = 20,
		itemID = 10310,
		itemIcon = 134938,
		quality = 1,
	},
	[8119] = {
		name = "Scroll of Strength II",
		icon = 136101,
		desc = "+9 Strength",
		order = 14,
		itemID = 10310,
		itemIcon = 134938,
		quality = 1,
		maxRankSodPhases = {1}, --25.
	},
	[8120] = {
		name = "Scroll of Strength III",
		icon = 136101,
		desc = "+13 Strength",
		order = 8,
		itemID = 10310,
		itemIcon = 134938,
		quality = 1,
		maxRankSodPhases = {2, 3}, --40.
	},
	[12179] = {
		name = "Scroll of Strength IV",
		icon = 136101,
		desc = "+17 Strength",
		order = 2,
		itemID = 10310,
		itemIcon = 134938,
		quality = 1,
		maxRank = true,
	},
	[8091] = {
		name = "Scroll of Protection",
		icon = 132341,
		desc = "+60 Armor",
		order = 21,
		itemID = 10305,
		itemIcon = 134943,
		quality = 1,
	},
	[8094] = {
		name = "Scroll of Protection II",
		icon = 132341,
		desc = "+120 Armor",
		order = 15,
		itemID = 10305,
		itemIcon = 134943,
		quality = 1,
		maxRankSodPhases = {1}, --15.
	},
	[8095] = {
		name = "Scroll of Protection III",
		icon = 132341,
		desc = "+180 Armor",
		order = 9,
		itemID = 10305,
		itemIcon = 134943,
		quality = 1,
		maxRankSodPhases = {2}, --30.
	},
	[12175] = {
		name = "Scroll of Protection IV",
		icon = 132341,
		desc = "+240 Armor",
		order = 3,
		itemID = 10305,
		itemIcon = 134943,
		quality = 1,
		maxRank = true,
	},
	[8096] = {
		name = "Scroll of Intellect",
		icon = 135932,
		desc = "+4 Intellect",
		order = 22,
		itemID = 10308,
		itemIcon = 134937,
		quality = 1,
	},
	[8097] = {
		name = "Scroll of Intellect II",
		icon = 135932,
		desc = "+8 Intellect",
		order = 16,
		itemID = 10308,
		itemIcon = 134937,
		quality = 1,
		maxRankSodPhases = {1}, --20.
	},
	[8098] = {
		name = "Scroll of Intellect III",
		icon = 135932,
		desc = "+12 Intellect",
		order = 10,
		itemID = 10308,
		itemIcon = 134937,
		quality = 1,
		maxRankSodPhases = {2}, --35.
	},
	[12176] = {
		name = "Scroll of Intellect IV",
		icon = 135932,
		desc = "+16 Intellect",
		order = 4,
		itemID = 10308,
		itemIcon = 134937,
		quality = 1,
		maxRank = true,
	},
	[8112] = {
		name = "Scroll of Spirit",
		icon = 136126,
		desc = "+3 Spirit",
		order = 23,
		itemID = 10306,
		itemIcon = 134937,
		quality = 1,
	},
	[8113] = {
		name = "Scroll of Spirit II",
		icon = 136126,
		desc = "+7 Spirit",
		order = 17,
		itemID = 10306,
		itemIcon = 134937,
		quality = 1,
		maxRankSodPhases = {1}, --15.
	},
	[8114] = {
		name = "Scroll of Spirit III",
		icon = 136126,
		desc = "+11 Spirit",
		order = 11,
		itemID = 10306,
		itemIcon = 134937,
		quality = 1,
		maxRankSodPhases = {2}, --30.
	},
	[12177] = {
		name = "Scroll of Spirit IV",
		icon = 136126,
		desc = "+15 Spirit",
		order = 5,
		itemID = 10306,
		itemIcon = 134937,
		quality = 1,
		maxRank = true,
	},
	[8099] = {
		name = "Scroll of Stamina",
		icon = 136112,
		desc = "+4 Stamina",
		order = 24,
		itemID = 10307,
		itemIcon = 134943,
		quality = 1,
	},
	[8100] = {
		name = "Scroll of Stamina II",
		icon = 136112,
		desc = "+8 Stamina",
		order = 18,
		itemID = 10307,
		itemIcon = 134943,
		quality = 1,
		maxRankSodPhases = {1}, --20.
	},
	[8101] = {
		name = "Scroll of Stamina III",
		icon = 136112,
		desc = "+12 Stamina",
		order = 12,
		itemID = 10307,
		itemIcon = 134943,
		quality = 1,
		maxRankSodPhases = {2}, --35.
	},
	[12178] = {
		name = "Scroll of Stamina IV",
		icon = 136112,
		desc = "+16 Stamina",
		order = 6,
		itemID = 10307,
		itemIcon = 134943,
		quality = 1,
		maxRank = true,
	},
};

--Spell cast IDs not item IDs.
NRC.trackedConsumes = {
	[22792] = {
		name = "Thornling Seed",
		icon = 132877,
		desc = "Plants a Thornling which attracts nearby enemies.",
		itemID = 18297,
		quality = 1,
	},
	--Engi.
	[44389] = {
		name = "Field Repair Bot 110G",
		icon = 133859,
		desc = "Unfolds into a Field Repair Bot that sells reagents and can repair damaged items.  After 10 minutes its internal motor fails.",
		itemID = 34113,
		quality = 1,
	},
	--Potions.
	[17530] = {
		name = "Superior Mana Potion",
		icon = 134854,
		desc = "Restores 900 to 1500 mana.",
		itemID = 13443,
		quality = 1,
	},
	[4042] = {
		name = "Superior Healing Potion",
		icon = 134833,
		desc = "Restores 700 to 900 health.",
		itemID = 3928,
		quality = 1,
	},
	[17531] = {
		name = "Major Mana Potion",
		icon = 134856,
		desc = "Restores 1350 to 2250 mana.",
		itemID = 13444,
		quality = 1,
	},
	[17534] = {
		name = "Major Healing Potion",
		icon = 134834,
		desc = "Restores 1050 to 1750 health.",
		itemID = 13446,
		quality = 1,
	},
	[17549] = {
		name = "Greater Arcane Protection Potion",
		icon = 134863,
		desc = "Absorbs 1950 to 3250 arcane damage. Last 1 hour.",
		itemID = 13461,
		quality = 1,
	},
	[17543] = {
		name = "Greater Fire Protection Potion",
		icon = 134804,
		desc = "Absorbs 1950 to 3250 fire damage. Last 1 hour.",
		itemID = 13457,
		quality = 1,
	},
	[17544] = {
		name = "Greater Frost Protection Potion",
		icon = 134800,
		desc = "Absorbs 1950 to 3250 frost damage. Last 1 hour.",
		itemID = 13456,
		quality = 1,
	},
	[17545] = {
		name = "Greater Holy Protection Potion",
		icon = 134720,
		desc = "Absorbs 1950 to 3250 holy damage. Last 1 hour.",
		itemID = 13460,
		quality = 1,
	},
	[17546] = {
		name = "Greater Nature Protection Potion",
		icon = 134802,
		desc = "Absorbs 1950 to 3250 nature damage. Last 1 hour.",
		itemID = 13458,
		quality = 1,
	},
	[17548] = {
		name = "Greater Shadow Protection Potion",
		icon = 134803,
		desc = "Absorbs 1950 to 3250 shadow damage.  Last 1 hour.",
		itemID = 13459,
		quality = 1,
	},
	[24360] = {
		name = "Greater Dreamless Sleep Potion",
		icon = 134863,
		desc = "Puts the imbiber in a dreamless sleep for 12 sec. During that time the imbiber heals 2100 health and 2100 mana.",
		itemID = 20002,
		quality = 1,
	},
	[7233] = {
		name = "Fire Protection Potion",
		icon = 134787,
		desc = "Absorbs 975 to 1625 fire damage. Last 1 hour.",
		itemID = 6049,
		quality = 1,
	},
	[7239] = {
		name = "Frost Protection Potion",
		icon = 134754,
		desc = "Absorbs 1350 to 2250 frost damage. Last 1 hour.",
		itemID = 6050,
		quality = 1,
	},
	[7245] = {
		name = "Holy Protection Potion",
		icon = 134720,
		desc = "Absorbs 300 to 500 holy damage. Last 1 hour.",
		itemID = 6051,
		quality = 1,
	},
	[7254] = {
		name = "Nature Protection Potion",
		icon = 134717,
		desc = "Absorbs 1350 to 2250 nature damage. Last 1 hour.",
		itemID = 6052,
		quality = 1,
	},
	[7242] = {
		name = "Shadow Protection Potion",
		icon = 134824,
		desc = "Absorbs 675 to 1125 shadow damage.  Last 1 hour.",
		itemID = 6048,
		quality = 1,
	},
	[15822] = {
		name = "Dreamless Sleep Potion",
		icon = 134863,
		desc = "Puts the imbiber in a dreamless sleep for 12 sec. During that time the imbiber heals 1200 health and 1200 mana.",
		itemID = 12190,
		quality = 1,
	},
	[11392] = {
		name = "Invisibility Potion",
		icon = 134805,
		desc = "Gives the imbiber invisibility for 18 sec. (10 Min Cooldown)",
		itemID = 9172,
		quality = 1,
	},
	[3680] = {
		name = "Lesser Invisibility Potion",
		icon = 134798,
		desc = "Gives the imbiber lesser invisibility for 15 sec. (10 Min Cooldown)",
		itemID = 3823,
		quality = 1,
	},
	[16666] = {
		name = "Demonic Rune",
		icon = 134417,
		desc = "Restores 900 to 1500 mana at the cost of 600 to 1000 life.",
		itemID = 12662,
		quality = 2,
	},
	[27869] = {
		name = "Dark Rune",
		icon = 136192,
		desc = "Restores 900 to 1500 mana at the cost of 600 to 1000 life.",
		itemID = 20520,
		quality = 2,
	},
	[11371] = {
		name = "Gift of Arthas",
		icon = 134808,
		desc = "+10 Shadow Resistnce, attacker has a 30% chance of being inflicted with disease that increases their damage taken by 8 for 3 min.",
		itemID = 9088,
		quality = 1,
	},
	[6615] = {
		name = "Free Action Potion",
		icon = 134715,
		desc = "Makes you immune to Stun and Movement Impairing effects for the next 30 sec.",
		itemID = 5634,
		quality = 1,
	},
	[3169] = {
		name = "Limited Invulnerability Potion",
		icon = 134842,
		desc = "Imbiber is immune to physical attacks for the next 6 sec.",
		itemID = 3387,
		quality = 1,
	},
	[11359] = {
		name = "Restorative Potion",
		icon = 134712,
		desc = "Removes 1 magic, curse, poison or disease effect on you every 5 seconds for 30 seconds.",
		itemID = 9030,
		quality = 1,
	},
	[17528] = {
		name = "Mighty Rage Potion",
		icon = 134821,
		desc = "Increases Rage by 45 to 70.",
		itemID = 13442,
		quality = 1,
	},
	[17540] = {
		name = "Greater Stoneshield Potion",
		icon = 134849,
		desc = "Increases armor by 2000 for 2 min.",
		itemID = 13455,
		quality = 1,
	},
	[24364] = {
		name = "Living Action Potion",
		icon = 134718,
		desc = "Makes you immune to Stun and Movement Impairing effects for the next 5 sec.  Also removes existing Stun and Movement Impairing effects.",
		itemID = 20008,
		quality = 1,
	},
};

NRC.racials = {
	[20572] = {
		name = "Blood Fury",
		icon = 135726,
		desc = "Increases attack power. Lasts 15 sec.",
	},
	[20549] = {
		name = "War Stomp",
		icon = 132368,
		desc = "Stuns up to 5 enemies within 8 yds for 2 sec.",
	},
	[20554] = {
		name = "Berserking",
		icon = 135727,
		desc = "Increases your attack and casting speed by 20% for 10 sec.",
	},
	[7744] = {
		name = "Will of the Forsaken",
		icon = 136187,
		desc = "Removes any Charm, Fear and Sleep effect. This effect shares a 45 sec cooldown with other similar effects.",
	},
	[20594] = {
		name = "Stoneform",
		icon = 136225,
		desc = "Removes all poison, disease and bleed effects and increases your armor by 10% for 8 sec.",
	},
	[20589] = {
		name = "Escape Artist",
		icon = 132309,
		desc = "Escape the effects of any immobilization or movement speed reduction effect.",
	},
	[20600] = {
		name = "Perception",
		icon = 136090,
		desc = "Dramatically increases stealth detection for 20 sec.",
	},
	[20580] = {
		name = "Shadowmeld",
		icon = 132089,
		desc = "Activate to slip into the shadows, reducing the chance for enemies to detect your presence. Lasts until cancelled or upon moving.",
	},
	[20577] = {
		name = "Cannibalize",
		icon = 132278,
		desc = "When activated, regenerates 7% of total health every 2 sec for 10 sec.",
	},
	[2481] = {
		name = "Find Treasure",
		icon = 135725,
		desc = "Allows the dwarf to sense nearby treasure, making it appear on the minimap.",
	},
};

NRC.interrupts = {
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
for k, v in pairs(NRC.foods) do
	NRC.trackedItems[k] = v;
end

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
	[27235] = {
		name = "Healthstone (0/2)",
		icon = 135230,
		spellName = "Healthstone",
	},
	[27236] = {
		name = "Healthstone (1/2)",
		icon = 135230,
		spellName = "Healthstone",
	},
	[27237] = {
		name = "Healthstone (2/2)",
		icon = 135230,
		spellName = "Healthstone",
	},
};
		
NRC.dpsPotions = {
	--Probably add lip/fap etc here?
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
	[26] = {
		name = "Frost Oil",
		icon = 134800,
		desc = "10% chance of casting Frostbolt at the opponent when it hits.",
	},
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
--
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
		maxRankSodPhases = {1}, --14.
	},
	[1461] = {
		name = "Arcane Intellect",
		icon = 135932,
		desc = "+15 Int",
		rank = 3,
		maxRankSodPhases = {2}, --28.
	},
	[10156] = {
		name = "Arcane Intellect",
		icon = 135932,
		desc = "+22 Int",
		rank = 4,
		maxRankSodPhases = {3}, --42.
	},
	[10157] = {
		name = "Arcane Intellect",
		icon = 135932,
		desc = "+31 Int",
		rank = 5,
		maxRank = true,
	},
	[23028] = {
		name = "Arcane Brilliance",
		icon = 135869,
		desc = "+31 Int",
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
		maxRankSodPhases = {1}, --24.
	},
	[2791] = {
		name = "Power Word: Fortitude",
		icon = 135987,
		desc = "+32 Stam",
		rank = 4,
		maxRankSodPhases = {2}, --36.
	},
	[10937] = {
		name = "Power Word: Fortitude",
		icon = 135987,
		desc = "+43 Stam",
		rank = 5,
		maxRankSodPhases = {3}, --48.
	},
	[10938] = {
		name = "Power Word: Fortitude",
		icon = 135987,
		desc = "+54 Stam",
		rank = 6,
		maxRank = true,
	},
	[21562] = {
		name = "Prayer of Fortitude",
		icon = 135941,
		desc = "+43 Stam",
		rank = 1,
		maxRankSodPhases = {3}, --48.
	},
	[21564] = {
		name = "Prayer of Fortitude",
		icon = 135941,
		desc = "+54 Stam",
		rank = 2,
		maxRank = true,
	},
};

NRC.spirit = {
	[14752] = {
		name = "Divine Spirit",
		icon = 135898,
		desc = "+17 Spirit",
		rank = 1,
		--Level 30 to get this as a talent.
	},
	[14818] = {
		name = "Divine Spirit",
		icon = 135898,
		desc = "+17 Spirit",
		rank = 2,
		maxRankSodPhases = {2}, --40.
	},
	[14819] = {
		name = "Divine Spirit",
		icon = 135898,
		desc = "+33 Spirit",
		rank = 3,
		maxRankSodPhases = {3}, --50.
	},
	[27841] = {
		name = "Divine Spirit",
		icon = 135898,
		desc = "+40 Spirit",
		rank = 4,
		maxRank = true,
	},
	[27681] = {
		name = "Prayer of Spirit",
		icon = 135946,
		desc = "+40 Spirit",
		rank = 1,
		maxRank = true,
	},
};

NRC.shadow = {
	[976] = {
		name = "Shadow Protection",
		icon = 136121,
		desc = "+30 Shadow Resistance",
		rank = 1,
		maxRankSodPhases = {2}, --30.
	},
	[10957] = {
		name = "Shadow Protection",
		icon = 136121,
		desc = "+45 Shadow Resistance",
		rank = 2,
		maxRankSodPhases = {3}, --42.
	},
	[10958] = {
		name = "Shadow Protection",
		icon = 136121,
		desc = "+60 Shadow Resistance",
		rank = 3,
		maxRank = true,
	},
	[27683] = {
		name = "Prayer of Shadow Protection",
		icon = 135945,
		desc = "+60 Shadow Resistance",
		rank = 1,
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
		maxRankSodPhases = {1}, --20.
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
		maxRankSodPhases = {2}, --40.
	},
	[9884] = {
		name = "Mark of the Wild",
		icon = 136078,
		desc = "+10 Stats, +240 Armor, +15 Resistances",
		rank = 6,
		maxRankSodPhases = {3}, --50.
	},
	[9885] = {
		name = "Mark of the Wild",
		icon = 136078,
		desc = "+12 Stats, +285 Armor, +20 Resistances",
		rank = 7,
		maxRank = true,
	},
	[21849] = {
		name = "Gift of the Wild",
		icon = 136038,
		desc = "+10 Stats, +240 Armor, +15 Resistances",
		rank = 1,
		maxRankSodPhases = {3}, --50.
	},
	[21850] = {
		name = "Gift of the Wild",
		icon = 136038,
		desc = "+12 Stats, +285 Armor, +20 Resistances",
		rank = 2,
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
		maxRankSodPhases = {1}, --22.
	},
	[19836] = {
		name = "Blessing of Might",
		icon = 135906,
		desc = "+85 Attack Power",
		rank = 4,
		order = 3,
		maxRankSodPhases = {2}, --32.
	},
	[19837] = {
		name = "Blessing of Might",
		icon = 135906,
		desc = "+115 Attack Power",
		rank = 5,
		order = 3,
		maxRankSodPhases = {3}, --42.
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
		maxRank = true,
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
		maxRank = true,
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
		maxRankSodPhases = {1}, --24.
	},
	[19852] = {
		name = "Blessing of Wisdom",
		icon = 135970,
		desc = "+20 MP5",
		rank = 3,
		order = 4,
		maxRankSodPhases = {2}, --34.
	},
	[19853] = {
		name = "Blessing of Wisdom",
		icon = 135970,
		desc = "+25 MP5",
		rank = 4,
		order = 4,
		maxRankSodPhases = {3}, --44.
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
		maxRank = true,
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
		maxRank = true,
	},
	--Light.
	[19977] = {
		name = "Blessing of Light",
		icon = 135943,
		desc = "+210 Holy Light, +60 Flash of Light",
		rank = 1,
		order = 5,
		maxRankSodPhases = {2}, --40.
	},
	[19977] = {
		name = "Blessing of Light",
		icon = 135943,
		desc = "+300 Holy Light, +85 Flash of Light",
		rank = 2,
		order = 5,
		maxRankSodPhases = {3}, --50.
	},
	[19977] = {
		name = "Blessing of Light",
		icon = 135943,
		desc = "+400 Holy Light, +115 Flash of Light",
		rank = 3,
		order = 5,
		maxRank = true,
	},
	[25890] = {
		name = "Greater Blessing of Light",
		icon = 135909,
		desc = "+400 Holy Light, +115 Flash of Light",
		rank = 1,
		order = 5,
		maxRank = true,
	},
	--Sanctuary.
	[20911] = {
		name = "Blessing of Sanctuary",
		icon = 136051,
		desc = "-10 Damage Taken, +14 Shield Block Damage",
		rank = 1,
		order = 6,
		--Level 30 talent.
	},
	[20912] = {
		name = "Blessing of Sanctuary",
		icon = 136051,
		desc = "-14 Damage Taken, +21 Shield Block Damage",
		rank = 2,
		order = 6,
		maxRankSodPhases = {2}, --40.
	},
	[20913] = {
		name = "Blessing of Sanctuary",
		icon = 136051,
		desc = "-19 Damage Taken, +28 Shield Block Damage",
		rank = 3,
		order = 6,
		maxRankSodPhases = {3}, --30.
	},
	[20914] = {
		name = "Blessing of Sanctuary",
		icon = 136051,
		desc = "-24 Damage Taken, +35 Shield Block Damage",
		rank = 4,
		order = 6,
		maxRank = true,
	},
	[25899] = {
		name = "Greater Blessing of Sanctuary",
		icon = 135911,
		desc = "-24 Damage Taken, +35 Shield Block Damage",
		rank = 1,
		order = 6,
		maxRank = true,
	},
};

NRC.worldBuffs = {
	--[16609] = "rend",
	--[22888] = "ony",
	--[24425] = "zan",
	--New spell ID's after hotfix 23/4/21.
	[355366] = {
		name = "Warchief's Blessing",
		icon = 135759,
		desc = "+300 Health, 15% Melee Haste, +10 MP5",
		order = 1,
		maxRank = true,
	},
	[355363] = {
		name = "Rallying Cry of the Dragonslayer",
		icon = 134153,
		desc = "+10% Crit Spells, +5% Crit Melee/Ranged, +140 AP",
		order = 2,
		maxRank = true,
	},
	[355365] = {
		name = "Spirit of Zandalar",
		icon = 132107,
		desc = "+10% Movement Speed, +15% Stats",
		order = 3,
		maxRank = true,
	},
	[23768] = {
		name = "Sayge's Dark Fortune of Damage",
		icon = 134334,
		desc = "+10% Damage",
		order = 4,
		maxRank = true,
	},
	[23769] = {
		name = "Sayge's Dark Fortune of Resistance",
		icon = 134334,
		desc = "+25 Resitances",
		order = 4,
		maxRank = true,
	},
	[23767] = {
		name = "Sayge's Dark Fortune of Armor",
		icon = 134334,
		desc = "+10% Armor",
		order = 4,
		maxRank = true,
	},
	[23766] = {
		name = "Sayge's Dark Fortune of Intelligence",
		icon = 134334,
		desc = "+10% Intelligence",
		order = 4,
		maxRank = true,
	},
	[23738] = {
		name = "Sayge's Dark Fortune of Spirit",
		icon = 134334,
		desc = "+10% Spirit",
		order = 4,
		maxRank = true,
	},
	[23737] = {
		name = "Sayge's Dark Fortune of Stamina",
		icon = 134334,
		desc = "+10% Stamina",
		order = 4,
		maxRank = true,
	},
	[23735] = {
		name = "Sayge's Dark Fortune of Strength",
		icon = 134334,
		desc = "+10% Strength",
		order = 4,
		maxRank = true,
	},
	[23736] = {
		name = "Sayge's Dark Fortune of Agility",
		icon = 134334,
		desc = "+10% Agility",
		order = 4,
		maxRank = true,
	},
	[22818] = {
		name = "Mol'dar's Moxie",
		icon = 136054,
		desc = "+15% Stamina",
		order = 5,
		maxRank = true,
	},
	[22817] = {
		name = "Fengus' Ferocity",
		icon = 136109,
		desc = "+200 AP",
		order = 6,
		maxRank = true,
	},
	[22820] = {
		name = "Slip'kik's Savvy",
		icon = 135930,
		desc = "+3% Spell Crit",
		order = 7,
		maxRank = true,
	},
	[15366] = {
		name = "Songflower Serenade",
		icon = 135934,
		desc = "+5% Crit, +15 Stats",
		order = 8,
		maxRank = true,
	},
	--We don't need these on the world buffs frame I think?
	--[[[8733] = "blackfathom", --Blessing of Blackfathom
	[29235] = "festivalFortitude", --Fire Festival Fortitude
	[29846] = "festivalFury", --Fire Festival Fury
	[29338] = "festivalFury", --Fire Festival Fury 2 diff types? aoe and single version possibly?
	[29175] = "ribbonDance", --Fire Festival Fortitude
	[29534] = "silithyst", --Traces of Silithyst]]
	--SoD.
	[430947] = {
		name = "Boon of Blackfathom",
		icon = 236403,
		desc = "+3% Spell Crit, +2% Melee/Ranged Crit, +25 SP, +20% Movement speed",
		order = 9,
		maxRank = true,
	},
	[430352] = {
		name = "Ashenvale Rallying Cry",
		icon = 136005,
		desc = "+5% Damage",
		order = 10,
		maxRank = true,
	},
	[438536] = {
		name = "Spark of Inspiration",
		icon = 236424,
		desc = "+4% Spell Crit, +42 SP, +10% Melee/Ranged Attack Speed",
		order = 11,
		maxRank = true,
	},--Why is there 2 the same? Horde and Alliance perhaps?
	[438537] = {
		name = "Spark of Inspiration",
		icon = 236424,
		desc = "+4% Spell Crit, +42 SP, +10% Melee/Ranged Attack Speed",
		order = 12,
		maxRank = true,
	},
	[446695] = {
		name = "Fervor of the Temple Explorer",
		icon = 236368,
		desc = "+5% Crit, +65 SP, +8% Stats",
		order = 13,
		maxRank = true,
	},
	[446698] = {
		name = "Fervor of the Temple Explorer",
		icon = 236368,
		desc = "+5% Crit, +65 SP, +8% Stats",
		order = 13,
		maxRank = true,
	},
	--For testing.
	--[[[10957] = {
		name = "Shadow Protection",
		icon = 136121,
		desc = "+45 Shadow Resistance",
		order = 30,
		maxRank = true,
	},
	[10937] = {
		name = "Power Word: Fortitude",
		icon = 135987,
		desc = "+43 Stam",
		order = 21,
		maxRank = true,
	},
	[10951] = {
		name = "Inner Fire",
		icon = 135926,
		desc = "Test 1",
		order = 32,
		maxRank = true,
	},
	[15473] = {
		name = "Shadowform",
		icon = 136200,
		desc = "+43 Stam",
		order = 33,
		maxRank = true,
	},]]
};

--for k, v in pairs(NRC.critterCreatures2) do
--	if (not NRC.critterCreatures[k]) then
--		print("[" .. k .. "] = \"" .. v .. "\",");
--	end
--end


--SoD specific stuff.
if (NRC.isSOD) then
	--mapped to enounterID - JournalEncounterCreature.ID, name, description, displayInfo, iconImage, uiModelSceneID, expansion, zoneID.
	--displayInfo (3d model scene, wowhead link button), iconImage (EJ display image with transparent background, only made for EJ bosses)
	--BFD raid.
	NRC.encounters[2694] = {"30", "Baron Aquanis", "", 110, 607552, 9, 1, 48};
	NRC.encounters[2697] = {"3155", "Ghamoo - Ra", "", 14661, 607613, 9, 1, 48}; -- Albino Snapjaw displayInfo
	NRC.encounters[2699] = {"3803", "Lady Sarevess", "", 4979, 607682, 9, 1, 48};
	NRC.encounters[2704] = {"1052", "Gelihast", "", 1773, 607609, 9, 1, 48};
	NRC.encounters[2710] = {"12822", "Lorgus Jett", "", 12822, 607701, 9, 1, 48};
	NRC.encounters[2825] = {"4939", "Twilight Lord Kelris", "", 4939, 607800, 9, 1, 48};
	NRC.encounters[2891] = {"1012", "Aku'mai", "", 2837, 607532, 9, 1, 48};
	
	--Gnomeregan raid.
	NRC.encounters[2925] = {"900", "Grubbis", "", 6533, 607628, 9, 1, 90};
	NRC.encounters[2928] = {"1236", "Viscous Fallout", "", 36529, 607808, 9, 1, 90};
	NRC.encounters[2899] = {"989", "Crowd Pummeler 9-60", "", 36560, 607572, 9, 1, 90};
	NRC.encounters[2927] = {"991", "Electrocutioner 6000", "", 36558, 607594, 9, 1, 90};
	NRC.encounters[2935] = {"2671", "Mechanical Menagerie", "", 117368, nil, 9, 1, 90};
	NRC.encounters[2940] = {"992", "Mekgineer Thermaplugg", "", 36563, 607714, 9, 1, 90};
	
	--Sunken Temple raid.
	NRC.encounters[2952] = {"0", "Atal’alrion", "", 7873, 1064178, 9, 1, 109}; --Mushlump close enough I guess...
	NRC.encounters[2953] = {"3771", "Festering Rot Slime", "", 15686, 1385771, 9, 1, 109};
	NRC.encounters[2957] = {"1027", "Jammal'an and Ogom", "", 6708, 607665, 9, 1, 109};
	--NRC.encounters[0] = {"0", "Ogom the Wretched", "", 6709, 607541, 9, 1, 109}; --Merged in to Jammal encounter?
	NRC.encounters[2954] = {"0", "The Atal'ai Defenders", "", 6709, 607541, 9, 1, 109}; --Antu'sul from ZF close enough texture?
	NRC.encounters[2959] = {"1032", "Shade of Eranikus", "", 7806, 607768, 9, 1, 109};
	NRC.encounters[2956] = {"1026", "Avatar of Hakkar", "", 8053, 607548, 9, 1, 109};
	NRC.encounters[2955] = {"1028", "Dreamscythe and Weaver", "", 7553, 608311, 9, 1, 109};
	NRC.encounters[2958] = {"1028", "Morphaz and Hazzas", "", 7533, 608311, 9, 1, 109};
    
    --Change Sod dungs to a raid.
    NRC.zones[48].type = "raid"; --BRD.
	NRC.zones[90].type = "raid"; --Gnomeregan.
	NRC.zones[109].type = "raid"; --Sunken Temple.
	
	--Add hunter kings buff to paladin table.
	NRC.pal[409583] = {
		name = "Heart of the Lion",
		icon = 132185,
		desc = "+10% Stats",
		maxRank = true,
		order = 2,
	};
	--Certain things like GetEffectivePlayerMaxLevel() are 60 at addon load time and are updated at logon so we need to delay certain db updates that require the phase.
	--Things had to be changed a little in Raidstatus.lua to work with this.
	function NRC:loadDelayedDatabaseUpdate()
		--Recheck the phase after PEW.
		if (NRC.isClassic and C_Engraving and C_Engraving.IsEngravingEnabled()) then
			local sodPhases = {[25]=1,[40]=2,[50]=3,[60]=4};
			NRC.sodPhase = sodPhases[(GetEffectivePlayerMaxLevel())];
		end
		--Add maxRank to tables for SoD phases.
		local tables = {NRC.flasks, NRC.battleElixirs, NRC.guardianElixirs, NRC.foods, NRC.scrolls, NRC.dpsPotions, NRC.healthPotions, NRC.manaPotions, NRC.tempEnchants, NRC.int, NRC.fort, NRC.spirit, NRC.shadow, NRC.motw, NRC.pal};
		local phase = NRC.sodPhase;
		for k, v in pairs(tables) do
			for _, data in pairs(v) do
				if (data.maxRankSodPhases) then
					for _, maxRankSodPhase in pairs(data.maxRankSodPhases) do
						if (maxRankSodPhase == phase) then
							data.maxRank = true;
							--print(data.name, data.rank)
						end
					end
				end
			end
		end
		NRC:logonUpdateRaidStatusDatabase();
	end
end