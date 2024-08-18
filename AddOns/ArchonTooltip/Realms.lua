---@type string
local AddonName = ...

---@class Private
local Private = select(2, ...)

table.insert(Private.LoginFnQueue, function()
    Private.Realms[4372] = { name = "Atiesh", slug = "atiesh", region = "US", database = "US" }
    Private.Realms[4373] = { name = "Myzrael", slug = "myzrael", region = "US", database = "US" }
    Private.Realms[4374] = { name = "OldBlanchy", slug = "old-blanchy", region = "US", database = "US" }
    Private.Realms[4376] = { name = "Azuresong", slug = "azuresong", region = "US", database = "US" }
    Private.Realms[4384] = { name = "Mankrik", slug = "mankrik", region = "US", database = "US" }
    Private.Realms[4385] = { name = "Pagle", slug = "pagle", region = "US", database = "US" }
    Private.Realms[4386] = { name = "DeviateDelight", slug = "deviate-delight", region = "US", database = "US" }
    Private.Realms[4387] = { name = "Ashkandi", slug = "ashkandi", region = "US", database = "US" }
    Private.Realms[4388] = { name = "Westfall", slug = "westfall", region = "US", database = "US" }
    Private.Realms[4395] = { name = "Whitemane", slug = "whitemane", region = "US", database = "US" }
    Private.Realms[4396] = { name = "Fairbanks", slug = "fairbanks", region = "US", database = "US" }
    Private.Realms[4397] = { name = "Blaumeux", slug = "blaumeux", region = "US", database = "US" }
    Private.Realms[4398] = { name = "Bigglesworth", slug = "bigglesworth", region = "US", database = "US" }
    Private.Realms[4399] = { name = "Kurinnaxx", slug = "kurinnaxx", region = "US", database = "US" }
    Private.Realms[4406] = { name = "Herod", slug = "herod", region = "US", database = "US" }
    Private.Realms[4407] = { name = "Thalnos", slug = "thalnos", region = "US", database = "US" }
    Private.Realms[4408] = { name = "Faerlina", slug = "faerlina", region = "US", database = "US" }
    Private.Realms[4409] = { name = "Stalagg", slug = "stalagg", region = "US", database = "US" }
    Private.Realms[4410] = { name = "Skeram", slug = "skeram", region = "US", database = "US" }
    Private.Realms[4417] = { name = "소금평원", slug = "소금-평원", region = "KR", database = "KR" }
    Private.Realms[4419] = { name = "로크홀라", slug = "로크홀라", region = "KR", database = "KR" }
    Private.Realms[4420] = { name = "얼음피", slug = "얼음피", region = "KR", database = "KR" }
    Private.Realms[4421] = { name = "라그나로스", slug = "라그나로스", region = "KR", database = "KR" }
    Private.Realms[4440] = { name = "Everlook", slug = "everlook", region = "EU", database = "EU" }
    Private.Realms[4441] = { name = "Auberdine", slug = "auberdine", region = "EU", database = "EU" }
    Private.Realms[4442] = { name = "Lakeshire", slug = "lakeshire", region = "EU", database = "EU" }
    Private.Realms[4452] = { name = "Chromie", slug = "хроми", region = "EU", database = "EU" }
    Private.Realms[4453] = { name = "PyrewoodVillage", slug = "pyrewood-village", region = "EU", database = "EU" }
    Private.Realms[4454] = { name = "MirageRaceway", slug = "mirage-raceway", region = "EU", database = "EU" }
    Private.Realms[4455] = { name = "Razorfen", slug = "razorfen", region = "EU", database = "EU" }
    Private.Realms[4456] = { name = "NethergardeKeep", slug = "nethergarde-keep", region = "EU", database = "EU" }
    Private.Realms[4463] = { name = "Lucifron", slug = "lucifron", region = "EU", database = "EU" }
    Private.Realms[4464] = { name = "Sulfuron", slug = "sulfuron", region = "EU", database = "EU" }
    Private.Realms[4465] = { name = "Golemagg", slug = "golemagg", region = "EU", database = "EU" }
    Private.Realms[4466] = { name = "Patchwerk", slug = "patchwerk", region = "EU", database = "EU" }
    Private.Realms[4467] = { name = "Firemaw", slug = "firemaw", region = "EU", database = "EU" }
    Private.Realms[4474] = { name = "Flamegor", slug = "пламегор", region = "EU", database = "EU" }
    Private.Realms[4475] = { name = "Shazzrah", slug = "shazzrah", region = "EU", database = "EU" }
    Private.Realms[4476] = { name = "Gehennas", slug = "gehennas", region = "EU", database = "EU" }
    Private.Realms[4477] = { name = "Venoxis", slug = "venoxis", region = "EU", database = "EU" }
    Private.Realms[4478] = { name = "Razorgore", slug = "razorgore", region = "EU", database = "EU" }
    Private.Realms[4485] = { name = "瑪拉頓", slug = "瑪拉頓", region = "TW", database = "TW" }
    Private.Realms[4487] = { name = "伊弗斯", slug = "伊弗斯", region = "TW", database = "TW" }
    Private.Realms[4488] = { name = "烏蘇雷", slug = "烏蘇雷", region = "TW", database = "TW" }
    Private.Realms[4489] = { name = "札里克", slug = "札里克", region = "TW", database = "TW" }
    Private.Realms[4497] = { name = "碧玉矿洞", slug = "碧玉矿洞", region = "CN", database = "5042" }
    Private.Realms[4498] = { name = "寒脊山小径", slug = "寒脊山小径", region = "CN", database = "5041" }
    Private.Realms[4499] = { name = "埃提耶什", slug = "埃提耶什", region = "CN", database = "5155" }
    Private.Realms[4500] = { name = "龙之召唤", slug = "龙之召唤", region = "CN", database = "5143" }
    Private.Realms[4501] = { name = "加丁", slug = "加丁", region = "CN", database = "5141" }
    Private.Realms[4509] = { name = "哈霍兰", slug = "哈霍兰", region = "CN", database = "5044" }
    Private.Realms[4510] = { name = "奥罗", slug = "奥罗", region = "CN", database = "5039" }
    Private.Realms[4511] = { name = "沙尔图拉", slug = "沙尔图拉", region = "CN", database = "5040" }
    Private.Realms[4512] = { name = "莫格莱尼", slug = "莫格莱尼", region = "CN", database = "5111" }
    Private.Realms[4513] = { name = "希尔盖", slug = "希尔盖", region = "CN", database = "5153" }
    Private.Realms[4520] = { name = "匕首岭", slug = "匕首岭", region = "CN", database = "5046" }
    Private.Realms[4521] = { name = "厄运之槌", slug = "厄运之槌", region = "CN", database = "5150" }
    Private.Realms[4522] = { name = "雷霆之击", slug = "雷霆之击", region = "CN", database = "5144" }
    Private.Realms[4523] = { name = "法尔班克斯", slug = "法尔班克斯", region = "CN", database = "5128" }
    Private.Realms[4524] = { name = "赫洛德", slug = "赫洛德", region = "CN", database = "5140" }
    Private.Realms[4531] = { name = "布鲁", slug = "布鲁", region = "CN", database = "5048" }
    Private.Realms[4532] = { name = "范克瑞斯", slug = "范克瑞斯", region = "CN", database = "5049" }
    Private.Realms[4533] = { name = "维希度斯", slug = "维希度斯", region = "CN", database = "5045" }
    Private.Realms[4534] = { name = "帕奇维克", slug = "帕奇维克", region = "CN", database = "5085" }
    Private.Realms[4535] = { name = "比格沃斯", slug = "比格沃斯", region = "CN", database = "5083" }
    Private.Realms[4647] = { name = "Grobbulus", slug = "grobbulus", region = "US", database = "US" }
    Private.Realms[4648] = { name = "BloodsailBuccaneers", slug = "bloodsail-buccaneers", region = "US", database = "US" }
    Private.Realms[4667] = { name = "Remulos", slug = "remulos", region = "US", database = "US" }
    Private.Realms[4669] = { name = "arugal", slug = "arugal", region = "US", database = "US" }
    Private.Realms[4670] = { name = "Yojamba", slug = "yojamba", region = "US", database = "US" }
    Private.Realms[4675] = { name = "辛迪加", slug = "辛迪加", region = "CN", database = "5043" }
    Private.Realms[4676] = { name = "ZandalarTribe", slug = "zandalar-tribe", region = "EU", database = "EU" }
    Private.Realms[4678] = { name = "HydraxianWaterlords", slug = "hydraxian-waterlords", region = "EU", database = "EU" }
    Private.Realms[4695] = { name = "Rattlegore", slug = "rattlegore", region = "US", database = "US" }
    Private.Realms[4696] = { name = "Smolderweb", slug = "smolderweb", region = "US", database = "US" }
    Private.Realms[4698] = { name = "Incendius", slug = "incendius", region = "US", database = "US" }
    Private.Realms[4699] = { name = "Kromcrush", slug = "kromcrush", region = "US", database = "US" }
    Private.Realms[4700] = { name = "Kirtonos", slug = "kirtonos", region = "US", database = "US" }
    Private.Realms[4701] = { name = "Mograine", slug = "mograine", region = "EU", database = "EU" }
    Private.Realms[4702] = { name = "Gandling", slug = "gandling", region = "EU", database = "EU" }
    Private.Realms[4703] = { name = "Amnennar", slug = "amnennar", region = "EU", database = "EU" }
    Private.Realms[4704] = { name = "Wyrmthalak", slug = "змейталак", region = "EU", database = "EU" }
    Private.Realms[4705] = { name = "Stonespine", slug = "stonespine", region = "EU", database = "EU" }
    Private.Realms[4706] = { name = "Flamelash", slug = "flamelash", region = "EU", database = "EU" }
    Private.Realms[4707] = { name = "霜语", slug = "霜语", region = "CN", database = "5114" }
    Private.Realms[4708] = { name = "水晶之牙", slug = "水晶之牙", region = "CN", database = "5135" }
    Private.Realms[4709] = { name = "维克洛尔", slug = "维克洛尔", region = "CN", database = "5134" }
    Private.Realms[4710] = { name = "维克尼拉斯", slug = "维克尼拉斯", region = "CN", database = "5138" }
    Private.Realms[4711] = { name = "巴罗夫", slug = "巴罗夫", region = "CN", database = "5142" }
    Private.Realms[4712] = { name = "比斯巨兽", slug = "比斯巨兽", region = "CN", database = "5131" }
    Private.Realms[4714] = { name = "Thunderfury", slug = "thunderfury", region = "US", database = "US" }
    Private.Realms[4715] = { name = "Anathema", slug = "anathema", region = "US", database = "US" }
    Private.Realms[4716] = { name = "ArcaniteReaper", slug = "arcanite-reaper", region = "US", database = "US" }
    Private.Realms[4725] = { name = "Skyfury", slug = "skyfury", region = "US", database = "US" }
    Private.Realms[4726] = { name = "Sulfuras", slug = "sulfuras", region = "US", database = "US" }
    Private.Realms[4727] = { name = "Windseeker", slug = "windseeker", region = "US", database = "US" }
    Private.Realms[4728] = { name = "Benediction", slug = "benediction", region = "US", database = "US" }
    Private.Realms[4729] = { name = "Netherwind", slug = "netherwind", region = "US", database = "US" }
    Private.Realms[4731] = { name = "Earthfury", slug = "earthfury", region = "US", database = "US" }
    Private.Realms[4732] = { name = "Heartseeker", slug = "heartseeker", region = "US", database = "US" }
    Private.Realms[4737] = { name = "Sul'thraze", slug = "sulthraze", region = "US", database = "US" }
    Private.Realms[4738] = { name = "Maladath", slug = "maladath", region = "US", database = "US" }
    Private.Realms[4739] = { name = "Felstriker", slug = "felstriker", region = "US", database = "US" }
    Private.Realms[4741] = { name = "Noggenfogger", slug = "noggenfogger", region = "EU", database = "EU" }
    Private.Realms[4742] = { name = "Ashbringer", slug = "ashbringer", region = "EU", database = "EU" }
    Private.Realms[4743] = { name = "Skullflame", slug = "skullflame", region = "EU", database = "EU" }
    Private.Realms[4744] = { name = "Finkle", slug = "finkle", region = "EU", database = "EU" }
    Private.Realms[4745] = { name = "Transcendence", slug = "transcendence", region = "EU", database = "EU" }
    Private.Realms[4746] = { name = "Bloodfang", slug = "bloodfang", region = "EU", database = "EU" }
    Private.Realms[4749] = { name = "Earthshaker", slug = "earthshaker", region = "EU", database = "EU" }
    Private.Realms[4751] = { name = "Dragonfang", slug = "dragonfang", region = "EU", database = "EU" }
    Private.Realms[4754] = { name = "Rhokdelar", slug = "рокделар", region = "EU", database = "EU" }
    Private.Realms[4755] = { name = "Dreadmist", slug = "dreadmist", region = "EU", database = "EU" }
    Private.Realms[4756] = { name = "Dragon'sCall", slug = "dragons-call", region = "EU", database = "EU" }
    Private.Realms[4757] = { name = "TenStorms", slug = "ten-storms", region = "EU", database = "EU" }
    Private.Realms[4758] = { name = "Judgement", slug = "judgement", region = "EU", database = "EU" }
    Private.Realms[4759] = { name = "Celebras", slug = "celebras", region = "EU", database = "EU" }
    Private.Realms[4763] = { name = "Heartstriker", slug = "heartstriker", region = "EU", database = "EU" }
    Private.Realms[4766] = { name = "HarbingerOfDoom", slug = "вестник-рока", region = "EU", database = "EU" }
    Private.Realms[4767] = { name = "诺格弗格", slug = "诺格弗格", region = "CN", database = "5119" }
    Private.Realms[4768] = { name = "毁灭之刃", slug = "毁灭之刃", region = "CN", database = "5117" }
    Private.Realms[4769] = { name = "黑曜石之锋", slug = "黑曜石之锋", region = "CN", database = "5173" }
    Private.Realms[4770] = { name = "萨弗拉斯", slug = "萨弗拉斯", region = "CN", database = "5107" }
    Private.Realms[4771] = { name = "伦鲁迪洛尔", slug = "伦鲁迪洛尔", region = "CN", database = "5148" }
    Private.Realms[4772] = { name = "灰烬使者", slug = "灰烬使者", region = "CN", database = "5087" }
    Private.Realms[4773] = { name = "怀特迈恩", slug = "怀特迈恩", region = "CN", database = "5152" }
    Private.Realms[4774] = { name = "奥金斧", slug = "奥金斧", region = "CN", database = "5147" }
    Private.Realms[4775] = { name = "骨火", slug = "骨火", region = "CN", database = "5110" }
    Private.Realms[4776] = { name = "末日之刃", slug = "末日之刃", region = "CN", database = "5137" }
    Private.Realms[4777] = { name = "震地者", slug = "震地者", region = "CN", database = "5122" }
    Private.Realms[4778] = { name = "祈福", slug = "祈福", region = "CN", database = "5136" }
    Private.Realms[4779] = { name = "辛洛斯", slug = "辛洛斯", region = "CN", database = "5126" }
    Private.Realms[4780] = { name = "觅心者", slug = "觅心者", region = "CN", database = "5118" }
    Private.Realms[4781] = { name = "狮心", slug = "狮心", region = "CN", database = "5124" }
    Private.Realms[4782] = { name = "审判", slug = "审判", region = "CN", database = "5120" }
    Private.Realms[4783] = { name = "无尽风暴", slug = "无尽风暴", region = "CN", database = "5115" }
    Private.Realms[4784] = { name = "巨龙追猎者", slug = "巨龙追猎者", region = "CN", database = "5129" }
    Private.Realms[4785] = { name = "灵风", slug = "灵风", region = "CN", database = "5132" }
    Private.Realms[4786] = { name = "卓越", slug = "卓越", region = "CN", database = "5104" }
    Private.Realms[4787] = { name = "狂野之刃", slug = "狂野之刃", region = "CN", database = "5127" }
    Private.Realms[4788] = { name = "巨人追猎者", slug = "巨人追猎者", region = "CN", database = "5154" }
    Private.Realms[4789] = { name = "秩序之源", slug = "秩序之源", region = "CN", database = "5146" }
    Private.Realms[4790] = { name = "奎尔塞拉", slug = "奎尔塞拉", region = "CN", database = "5139" }
    Private.Realms[4791] = { name = "碧空之歌", slug = "碧空之歌", region = "CN", database = "5106" }
    Private.Realms[4795] = { name = "Angerforge", slug = "angerforge", region = "US", database = "US" }
    Private.Realms[4800] = { name = "Eranikus", slug = "eranikus", region = "US", database = "US" }
    Private.Realms[4801] = { name = "Loatheb", slug = "loatheb", region = "US", database = "US" }
    Private.Realms[4811] = { name = "Giantstalker", slug = "giantstalker", region = "EU", database = "EU" }
    Private.Realms[4813] = { name = "Mandokir", slug = "mandokir", region = "EU", database = "EU" }
    Private.Realms[4815] = { name = "Thekal", slug = "thekal", region = "EU", database = "EU" }
    Private.Realms[4816] = { name = "Jin'do", slug = "jindo", region = "EU", database = "EU" }
    Private.Realms[4818] = { name = "艾隆纳亚", slug = "艾隆纳亚", region = "CN", database = "5109" }
    Private.Realms[4819] = { name = "席瓦莱恩", slug = "席瓦莱恩", region = "CN", database = "5145" }
    Private.Realms[4820] = { name = "火锤", slug = "火锤", region = "CN", database = "5157" }
    Private.Realms[4821] = { name = "沙顶 ", slug = "沙顶 ", region = "CN", database = "5130" }
    Private.Realms[4822] = { name = "德姆塞卡尔", slug = "德姆塞卡尔", region = "CN", database = "5113" }
    Private.Realms[4824] = { name = "怒炉", slug = "怒炉", region = "CN", database = "5116" }
    Private.Realms[4827] = { name = "无畏", slug = "无畏", region = "CN", database = "5158" }
    Private.Realms[4829] = { name = "安娜丝塔丽", slug = "安娜丝塔丽", region = "CN", database = "5133" }
    Private.Realms[4832] = { name = "雷德", slug = "雷德", region = "CN", database = "5112" }
    Private.Realms[4833] = { name = "曼多基尔", slug = "曼多基尔", region = "CN", database = "5123" }
    Private.Realms[4834] = { name = "娅尔罗", slug = "娅尔罗", region = "CN", database = "5105" }
    Private.Realms[4837] = { name = "范沃森", slug = "范沃森", region = "CN", database = "5160" }
    Private.Realms[4839] = { name = "힐스브래드", slug = "힐스브래드", region = "KR", database = "KR" }
    Private.Realms[4840] = { name = "서리한", slug = "서리한", region = "KR", database = "KR" }
    Private.Realms[4847] = { name = "光芒", slug = "光芒", region = "CN", database = "5159" }
    Private.Realms[4913] = { name = "寒冰之王", slug = "寒冰之王", region = "CN", database = "5170" }
    Private.Realms[4920] = { name = "龙牙", slug = "龙牙", region = "CN", database = "5169" }
    Private.Realms[4924] = { name = "法琳娜", slug = "法琳娜", region = "CN", database = "5162" }
    Private.Realms[4925] = { name = "湖畔镇", slug = "湖畔镇", region = "CN", database = "5164" }
    Private.Realms[4926] = { name = "克罗米", slug = "克罗米", region = "CN", database = "5165" }
    Private.Realms[4938] = { name = "无敌", slug = "无敌", region = "CN", database = "5188" }
    Private.Realms[4939] = { name = "冰封王座", slug = "冰封王座", region = "CN", database = "5189" }
    Private.Realms[4940] = { name = "巫妖王", slug = "巫妖王", region = "CN", database = "5190" }
    Private.Realms[4941] = { name = "银色北伐军", slug = "银色北伐军", region = "CN", database = "5199" }
    Private.Realms[4942] = { name = "吉安娜", slug = "吉安娜", region = "CN", database = "5207" }
    Private.Realms[4943] = { name = "死亡猎手", slug = "死亡猎手", region = "CN", database = "5208" }
    Private.Realms[4945] = { name = "红玉圣殿", slug = "红玉圣殿", region = "CN", database = "5209" }
    Private.Realms[5740] = { name = "阿拉希盆地", slug = "阿拉希盆地", region = "TW", database = "TW" }
    Private.Realms[5741] = { name = "魚人", slug = "魚人", region = "TW", database = "TW" }
    Private.Realms[5742] = { name = "古雷曼格", slug = "古雷曼格", region = "TW", database = "TW" }
    Private.Realms[5743] = { name = "逐風者", slug = "逐風者", region = "TW", database = "TW" }
    Private.Realms[5744] = { name = "木喉要塞", slug = "木喉要塞", region = "TW", database = "TW" }
    Private.Realms[5813] = { name = "WildGrowth", slug = "wild-growth", region = "US", database = "US_10222" }
    Private.Realms[5814] = { name = "LoneWolf", slug = "lone-wolf", region = "US", database = "US_10221" }
    Private.Realms[5815] = { name = "LivingFlame", slug = "living-flame", region = "US", database = "US_10220" }
    Private.Realms[5816] = { name = "CrusaderStrike", slug = "crusader-strike", region = "US", database = "US_10218" }
    Private.Realms[5817] = { name = "Penance(AU)", slug = "penance-au", region = "US", database = "US_10223" }
    Private.Realms[5818] = { name = "Shadowstrike(AU)", slug = "shadowstrike-au", region = "US", database = "US_10224" }
    Private.Realms[5819] = { name = "LavaLash", slug = "lava-lash", region = "US", database = "US_10219" }
    Private.Realms[5820] = { name = "ChaosBolt", slug = "chaos-bolt", region = "US", database = "US_10238" }
    Private.Realms[5823] = { name = "급속성장", slug = "급속-성장", region = "KR", database = "KR_10233" }
    Private.Realms[5824] = { name = "고독한늑대", slug = "고독한-늑대", region = "KR", database = "KR_10232" }
    Private.Realms[5825] = { name = "WildGrowth", slug = "wild-growth", region = "EU", database = "EU_10229" }
    Private.Realms[5826] = { name = "LoneWolf", slug = "lone-wolf", region = "EU", database = "EU_10228" }
    Private.Realms[5827] = { name = "LivingFlame", slug = "living-flame", region = "EU", database = "EU_10227" }
    Private.Realms[5828] = { name = "CrusaderStrike", slug = "crusader-strike", region = "EU", database = "EU_10225" }
    Private.Realms[5829] = { name = "PenanceRu", slug = "исповедь", region = "EU", database = "EU_10230" }
    Private.Realms[5830] = { name = "ShadowstrikeRu", slug = "удар-тьмы", region = "EU", database = "EU_10231" }
    Private.Realms[5831] = { name = "LavaLash", slug = "lava-lash", region = "EU", database = "EU_10226" }
    Private.Realms[5832] = { name = "ChaosBolt", slug = "chaos-bolt", region = "EU", database = "EU_10239" }
    Private.Realms[5842] = { name = "野性痊癒", slug = "野性痊癒", region = "TW", database = "TW_10237" }
    Private.Realms[5843] = { name = "孤狼", slug = "孤狼", region = "TW", database = "TW_10236" }
    Private.Realms[5844] = { name = "生命烈焰", slug = "生命烈焰", region = "TW", database = "TW_10235" }
    Private.Realms[5845] = { name = "十字軍聖擊", slug = "十字軍聖擊", region = "TW", database = "TW_10234" }

    local realmId = GetRealmID()
    local realm = Private.Realms[realmId]
    local normalizedRealmName = GetNormalizedRealmName()

    if not realm and not IsOnTournamentRealm() and not IsTestBuild() and string.find(normalizedRealmName, "Dungeons") == nil then
    	print(format(Private.L.UnknownRealm, AddonName, normalizedRealmName, realmId))
      	-- best we can do to recover
       	Private.CurrentRealm = {
       	    name = GetRealmName(),
       	    slug = normalizedRealmName,
       	    region = GetCurrentRegionName(),
       	    database = realmId,
       	}
    else
       	Private.CurrentRealm = realm
    end
end)