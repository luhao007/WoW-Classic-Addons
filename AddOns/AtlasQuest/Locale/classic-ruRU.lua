--[[

	AtlasQuest, a World of Warcraft addon.
	Email me at mystery8@gmail.com

	This file is part of AtlasQuest.

	AtlasQuest is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	AtlasQuest is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with AtlasQuest; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]


------------  CLASSIC / VANILLA  ------------

-- 66  = default.  Nothing shown.

-- 1  = Blackrock Depths
-- 2  = Blackwing Lair
-- 3  = Lower Blackrock Spire
-- 4  = Upper Blackrock Spire
-- 5  = Deadmines
-- 6  = Gnomeregan
-- 7  = Scarlet Monastery: Library
-- 8  = Scarlet Monastery: Armory
-- 9  = Scarlet Monastery: Cathedral
-- 10 = Scarlet Monastery: Graveyard
-- 11 = Scholomance
-- 12 = Shadowfang Keep
-- 13 = The Stockade
-- 14 = Stratholme
-- 15 = Sunken Temple
-- 16 = Uldaman

-- 17 = Blackfathom Deeps
-- 18 = Dire Maul East
-- 19 = Dire Maul North
-- 20 = Dire Maul West
-- 21 = Maraudon
-- 22 = Ragefire Chasm
-- 23 = Razorfen Downs
-- 24 = Razorfen Kraul
-- 25 = Wailing Caverns
-- 26 = Zul'Farrak

-- 27 = Molten Core
-- 28 = Onyxia's Lair
-- 29 = Zul'Gurub
-- 30 = The Ruins of Ahn'Qiraj
-- 31 = The Temple of Ahn'Qiraj
-- 32 = Naxxramas (level 60)

-- 33 = Alterac Valley
-- 34 = Arathi Basin
-- 35 = Warsong Gulch

-- 36 = Four Dragons
-- 37 = Azuregos
-- 38 = Highlord Kruul




if ( GetLocale() == "ruRU" ) then


---------------
--- COLOURS ---
---------------

local GREY = "|cff999999";
local RED = "|cffff0000";
local ATLAS_RED = "|cffcc3333";
local WHITE = "|cffFFFFFF";
local GREEN = "|cff66cc33";
local PURPLE = "|cff9F3FFF";
local BLUE = "|cff0070dd";
local ORANGE = "|cffFF8400";
local DARKYELLOW = "|cffcc9933";  -- Atlas uses this color for some things.
local YELLOW = "|cffFFd200";   -- Ingame Yellow




--------------- INST1 - Blackrock Depths ---------------

Inst1Caption = "Глубины Черной горы"
Inst1QAA = "14 заданий"
Inst1QAH = "18 заданий"

--Quest 1 Alliance
Inst1Quest1 = "1. Наследие Черного Железа"
Inst1Quest1_Level = "52"
Inst1Quest1_Attain = "48"
Inst1Quest1_Aim = "Убейте Финия Темностроя и добудьте великий молот, Железный Друг. Отнесите Железного Друга в святилище Тауриссана и вложите его в руки статуи Франклорна Искусника."
Inst1Quest1_Location = "Франклорн Искусник (Черная гора)"
Inst1Quest1_Note = "Франклорн находится в средине горы, над своей могилой, в здании около камня призыва. Вы должны быть мертвы, чтобы увидеть его! Он также дает предыдущее задание в цепочке.\nФиний Темнострой находится около "..YELLOW.."[9]"..WHITE..". Вы найдете Святилище рядом с ареной "..YELLOW.."[7]"..WHITE.."."
Inst1Quest1_Prequest = "Наследие Черного Железа"
Inst1Quest1_Folgequest = "Нет"
--
Inst1Quest1name1 = "Ключ Тенегорна"

--Quest 2 Alliance
Inst1Quest2 = "2. Риббли Крутипроб" -- 4136
Inst1Quest2_Level = "53"
Inst1Quest2_Attain = "48"
Inst1Quest2_Aim = "Принесите голову Риббли Юке Крутипроб в Пылающие степи."
Inst1Quest2_Location = "Юка Крутипроб (Пылающие степи - Пламенеющий стяг; "..YELLOW.."65,22"..WHITE..")"
Inst1Quest2_Note = "Вы получите предшествующее задание у Юрбы Крутипроба (Танарис - Порт Картеля; "..YELLOW.."67,23"..WHITE..").\nРиббли находится около "..YELLOW.."[15]"..WHITE.."."
Inst1Quest2_Prequest = "Юка Крутипроб" -- 4324
Inst1Quest2_Folgequest = "Нет"
Inst1Quest2PreQuest = "true"
--
Inst1Quest2name1 = "Сапоги Озлобления"
Inst1Quest2name2 = "Наплеч кары"
Inst1Quest2name3 = "Стальноосколочная броня"

--Quest 3 Alliance
Inst1Quest3 = "3. Приворотное зелье" -- 4201
Inst1Quest3_Level = "54"
Inst1Quest3_Attain = "50"
Inst1Quest3_Aim = "Принесите 4 листа крови Грома, 10 огромных серебряных слитков и наполненный сосуд Нагмары госпоже Нагмаре в Глубины Черной горы."
Inst1Quest3_Location = "Госпожа Нагмара (Глубины Черной горы, таверна)"
Inst1Quest3_Note = "Получить огромные серебряные слитки можно с Гигантов в Азшаре. Листки крови Грома легко можно найти у травников или на Аукционе. И последнее, сосуд можно наполнить в кратере Го-Лакка (Кратер Ун'Горо; "..YELLOW.."31,50"..WHITE..").\nПосле выполнения задания, вы можете использоать черный ход вместо сражения с Фалангой."
Inst1Quest3_Prequest = "Нет"
Inst1Quest3_Folgequest = "Нет"
--
Inst1Quest3name1 = "Кандалы"
Inst1Quest3name2 = "Пояс-хлыст Нагмары"

--Quest 4 Alliance
Inst1Quest4 = "4. Чарли Пьянодых" -- 4126
Inst1Quest4_Level = "55"
Inst1Quest4_Attain = "50"
Inst1Quest4_Aim = "Найдите украденный рецепт Громоваров и верните его Рагнару Громовару в Каранос."
Inst1Quest4_Location = "Рагнар Грозовар  (Дун Морог - Каранос; "..YELLOW.."46,52"..WHITE..")"
Inst1Quest4_Note = "Вы возьмете предшествующее задание у Енохи Грозовара (Выжженные земли - Крепость стражей Пустоты; "..YELLOW.."61,18"..WHITE..").\nВы получите рецепт с охранников, которые появятся, если вы уничтожите эль "..YELLOW.."[15]"..WHITE.."."
Inst1Quest4_Prequest = "Рагнар Грозовар" -- 4128
Inst1Quest4_Folgequest = "Нет"
Inst1Quest4PreQuest = "true"
--
Inst1Quest4name1 = "Темное дворфийское пиво"
Inst1Quest4name2 = "Палка молниеносного удара"
Inst1Quest4name3 = "Расчленитель"

--Quest 5 Alliance  
Inst1Quest5 = "5. Подчинитель Пирон"
Inst1Quest5_Level = "52"
Inst1Quest5_Attain = "48"
Inst1Quest5_Aim = "Убейте подчинителя Пирона и вернитесь к Джалинде Тирлипуньке."
Inst1Quest5_Location = "Джалинда Тирлипунька (Пылающие степи  - Дозор Моргана; "..YELLOW.."85,69"..WHITE..")"
Inst1Quest5_Note = "Овермастер Пайрон - огненный элементал за пределами инстанса. Он сидел "..YELLOW.."[24]"..WHITE.." на карте глубин Черной горы и "..YELLOW.."[1]"..WHITE.." на карте входа в Черную гору."
Inst1Quest5_Prequest = "Нет"
Inst1Quest5_Folgequest = "Опалитель!"
-- No Rewards for this quest

--Quest 6 Alliance
Inst1Quest6 = "6. Опалитель!" -- 4263
Inst1Quest6_Level = "56"
Inst1Quest6_Attain = "48"
Inst1Quest6_Aim = "Отыщите и уничтожьте лорда Опалителя в глубинах Черной горы!"
Inst1Quest6_Location = "Джалинда Тирлипунька (Пылающие степи - Дозор Моргана; "..YELLOW.."85,69"..WHITE..")"
Inst1Quest6_Note = "Вы возьмете предшествующее задание также у Джалинды Тирлипуньки. Вы найдете лорда Опалителя около "..YELLOW.."[10]"..WHITE.."."
Inst1Quest6_Prequest = "Подчинитель Пирон" -- 4262
Inst1Quest6_Folgequest = "Нет"
Inst1Quest6FQuest = "true"
--
Inst1Quest6name1 = "Солнечная накидка"
Inst1Quest6name2 = "Сумрачные перчатки"
Inst1Quest6name3 = "Наручи демона склепа"
Inst1Quest6name4 = "Стойкий поясок"

--Quest 7 Alliance
Inst1Quest7 = "7. Сердце горы" -- 4123
Inst1Quest7_Level = "55"
Inst1Quest7_Attain = "50"
Inst1Quest7_Aim = "Принесите сердце горы Максворту Суперблеску в Пылающие степи."
Inst1Quest7_Location = "Максворт Суперблеск (Пылающие степи - Пламенеющий стяг; "..YELLOW.."65,23"..WHITE..")"
Inst1Quest7_Note = "Вы найдете Сердце около "..YELLOW.."[8]"..WHITE.." в сейфе. Вы возьмете ключ от сейфа у сторожа Стиллгисс. Он появляется после открытия всех маленьких сейфов."
Inst1Quest7_Prequest = "Нет"
Inst1Quest7_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 8 Alliance
Inst1Quest8 = "8. Хороший товар" -- 4286
Inst1Quest8_Level = "56"
Inst1Quest8_Attain = "50"
Inst1Quest8_Aim = "Отправьтесь в глубины Черной горы и принесите 20 поясных сумок дворфов Черного Железа. По выполнении задания вернуться к Орелиусу. Предположительно поясные сумки можно отобрать у дворфов Черного Железа в глубинах Черной горы."
Inst1Quest8_Location = "Орелиус (Пылающие степи - Дозор Моргана; "..YELLOW.."84,68"..WHITE..")"
Inst1Quest8_Note = "Сумки падают со всех дворфов."
Inst1Quest8_Prequest = "Нет"
Inst1Quest8_Folgequest = "Нет"
--
Inst1Quest8name1 = "Закопченная сума-жестянка"

--Quest 9 Alliance
Inst1Quest9 = "9. Вкус пламени" -- 4024
Inst1Quest9_Level = "58"
Inst1Quest9_Attain = "52"
Inst1Quest9_Aim = "Отправьтесь в глубины Черной горы и убейте Бейл'Гора. "..YELLOW.."[11]"..WHITE.." Отнесите пойманную сущность Огня Цирусу Раскаивателю."
Inst1Quest9_Location = "Цирус Раскаиватель (Пылающие Степи "..YELLOW.."94,31"..WHITE..")"
Inst1Quest9_Note = "Задание начинает Каларан Ветрорез (Тлеющее ущелье; 39,38).\nБейл'Гор "..YELLOW.."[11]"..WHITE.."."
Inst1Quest9_Prequest = "Неугасимое пламя -> Вкус пламени" -- 3442 -> 4022
Inst1Quest9_Folgequest = "Нет"
Inst1Quest9PreQuest = "true"
--
Inst1Quest9name1 = "Накидка Глинистой кожи"
Inst1Quest9name2 = "Наплеч из шкуры змея"
Inst1Quest9name3 = "Вальконийский кушак"

--Quest 10 Alliance
Inst1Quest10 = "10. Каран Могучий Молот" -- 4341
Inst1Quest10_Level = "59"
Inst1Quest10_Attain = "50"
Inst1Quest10_Aim = "Пойдите в Глубины Черной горы и найдите Карана Могучего Молота.\nКороль упомянул, что Каран сидит там в плену – может, стоит поискать темницу."
Inst1Quest10_Location = "Король Магни Бронзобород (Стальгорн; "..YELLOW.."39,55"..WHITE..")"
Inst1Quest10_Note = "Предшествующее задание начинается у Королевского историка Аркессонуса (Стальгорн; "..YELLOW.."38,55"..WHITE.."). Каран Могучий Молот находится около "..YELLOW.."[2]"..WHITE.."."
Inst1Quest10_Prequest = "Дымящиеся руины Тауриссана" -- 3701
Inst1Quest10_Folgequest = "Недобрые вести"
Inst1Quest10PreQuest = "true"
-- No Rewards for this quest

--Quest 11 Alliance
Inst1Quest11 = "11. Королевский сюрприз" -- 4362
Inst1Quest11_Level = "59"
Inst1Quest11_Attain = "51"
Inst1Quest11_Aim = "Вернитесь в Глубины Черной горы и освободите принцессу Мойру Бронзобород от злобного императора Даграна Тауриссана."
Inst1Quest11_Location = "Король Магни Бронзобород (Стальгорн; "..YELLOW.."39,55"..WHITE..")"
Inst1Quest11_Note = "Принцесса Мойра Бронзобород находится около "..YELLOW.."[21]"..WHITE..". Во время боя она может лечить Даграна. Постарайтесь по возможности сбивать ей заклинание, но торопитесь, так она не должна умереть или вы провалите задание! После того как поговорите с ней, вы должны вернуться к Магни Бронзобороду."
Inst1Quest11_Prequest = "Судьба королевства" -- 4361
Inst1Quest11_Folgequest = "Нет" -- 4363
Inst1Quest11FQuest = "true"
--
Inst1Quest11name1 = "Воля Магни"
Inst1Quest11name2 = "Поющий камень Стальгорна"

--Quest 12 Alliance
Inst1Quest12 = "12. Сродство с недрами" -- 7848
Inst1Quest12_Level = "60"
Inst1Quest12_Attain = "55"
Inst1Quest12_Aim = "Отправляйтесь через портал, ведущий к Огненным Недрам в Глубинах Черной горы и добудьте осколок из Огненных Недр. Принесите его Лотосу Хранителю Портала в Черной горе."
Inst1Quest12_Location = "Лотос Хранитель Портала (Черная гора; "..YELLOW.."[2] на карте Входа"..WHITE..")"
Inst1Quest12_Note = "После выполнения задания вы сможете использовать камень ряом с Лотосом Хранителем Портала, чтобы войти в Расплавленные недра.\nВы найдете фрагмент ядра около "..YELLOW.."[23]"..WHITE..", сосем близко от портала в Расплавленные недра."
Inst1Quest12_Prequest = "Нет"
Inst1Quest12_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 13 Alliance
Inst1Quest13 = "13. Вызов" -- 9015
Inst1Quest13_Level = "60"
Inst1Quest13_Attain = "60"
Inst1Quest13_Aim = "Войдите в Зал Правосудия в Глубинах Черной горы, выслушайте приговор верховного судьи Мрачнокамня и вонзите знамя Вызова в центр круга. Убейте Телдрена и его гладиаторов, после чего вернитесь к Антиону Хармону в Восточные Чумные земли с первой частью амулета Лорда Вальтхалака."
Inst1Quest13_Location = "Фалрин Садовник (Забытый город (Запад); "..YELLOW.."[1] Бибилиотека"..WHITE..")"
Inst1Quest13_Note = "Предыдущие задания отличаются для каждого класса."
Inst1Quest13_Prequest = "Чары подстрекателя" -- 8950
Inst1Quest13_Folgequest = "(Классовые задания)"
-- No Rewards for this quest

--Quest 14 Alliance
Inst1Quest14 = "14. Призрачный кубок" -- 4083
Inst1Quest14_Level = "55"
Inst1Quest14_Attain = "40"
Inst1Quest14_Aim = "Драгоценные камни не издают ни звука, когда они падают в глубь чаши..."
Inst1Quest14_Location = "Мрак'нел (Глубины Черной горы; "..YELLOW.."[18]"..WHITE..")"
Inst1Quest14_Note = "Только шахтеры с навыком 230 или выше могут получить это задание, чтобы научиться выплавлять черное железо. Материалы для чаши: 2 [Звездный Рубин], 20 [Золотой слиток], 10 [Слиток истинного серебра]. После этого, если у Вас есть [Руда черного железа] Вы можете отнести ее к Черной Кузни "..YELLOW.."[22]"..WHITE.." и выплавить ее."
Inst1Quest14_Prequest = "Нет"
Inst1Quest14_Folgequest = "Нет"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst1Quest1_HORDE = Inst1Quest1
Inst1Quest1_HORDE_Level = Inst1Quest1_Level
Inst1Quest1_HORDE_Attain = Inst1Quest1_Attain
Inst1Quest1_HORDE_Aim = Inst1Quest1_Aim
Inst1Quest1_HORDE_Location = Inst1Quest1_Location
Inst1Quest1_HORDE_Note = Inst1Quest1_Note
Inst1Quest1_HORDE_Prequest = Inst1Quest1_Prequest
Inst1Quest1_HORDE_Folgequest = Inst1Quest1_Folgequest
--
Inst1Quest1name1_HORDE = Inst1Quest1name1

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst1Quest2_HORDE = Inst1Quest2
Inst1Quest2_HORDE_Level = Inst1Quest2_Level
Inst1Quest2_HORDE_Attain = Inst1Quest2_Attain
Inst1Quest2_HORDE_Aim = Inst1Quest2_Aim
Inst1Quest2_HORDE_Location = Inst1Quest2_Location
Inst1Quest2_HORDE_Note = Inst1Quest2_Note
Inst1Quest2_HORDE_Prequest = Inst1Quest2_Prequest
Inst1Quest2_HORDE_Folgequest = Inst1Quest2_Folgequest
Inst1Quest2PreQuest_HORDE = Inst1Quest2PreQuest
--
Inst1Quest2name1_HORDE = Inst1Quest2name1
Inst1Quest2name2_HORDE = Inst1Quest2name2
Inst1Quest2name3_HORDE = Inst1Quest2name3

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst1Quest3_HORDE = Inst1Quest3
Inst1Quest3_HORDE_Level = Inst1Quest3_Level
Inst1Quest3_HORDE_Attain = Inst1Quest3_Attain
Inst1Quest3_HORDE_Aim = Inst1Quest3_Aim
Inst1Quest3_HORDE_Location = Inst1Quest3_Location
Inst1Quest3_HORDE_Note = Inst1Quest3_Note
Inst1Quest3_HORDE_Prequest = Inst1Quest3_Prequest
Inst1Quest3_HORDE_Folgequest = Inst1Quest3_Folgequest
--
Inst1Quest3name1_HORDE = Inst1Quest3name1
Inst1Quest3name2_HORDE = Inst1Quest3name2

--Quest 4 Horde
Inst1Quest4_HORDE = "4. Украденный рецепт громоварского" -- 4143
Inst1Quest4_HORDE_Level = "55"
Inst1Quest4_HORDE_Attain = "50"
Inst1Quest4_HORDE_Aim = "Принесите рецепт светлого громоварского Вивиан Лягроб в Каргат."
Inst1Quest4_HORDE_Location = "Темный маг Вивиан Лягроб (Бесплодные земли - Каргат; "..YELLOW.."2,47"..WHITE..")"
Inst1Quest4_HORDE_Note = "Вы получите предшествующее задание у аптекаря Зинга в Подгороде - Район Фармацевтов ("..YELLOW.."50,68"..WHITE..").\nВы получите рецепт у одного из охранников, которые появятся, если вы уничтожите эль "..YELLOW.."[15]"..WHITE.."."
Inst1Quest4_HORDE_Prequest = "Вивиан Лягроб" -- 4133
Inst1Quest4_HORDE_Folgequest = "Нет"
Inst1Quest4PreQuest_HORDE = "true"
--
Inst1Quest4name1_HORDE = "Наилучшее лечебное зелье"
Inst1Quest4name2_HORDE = "Сильное зелье маны"
Inst1Quest4name3_HORDE = "Палка молниеносного удара"
Inst1Quest4name4_HORDE = "Расчленитель"

--Quest 5 Horde  (same as Quest 7 Alliance)
Inst1Quest5_HORDE = "5. Сердце горы"
Inst1Quest5_HORDE_Level = Inst1Quest7_Level
Inst1Quest5_HORDE_Attain = Inst1Quest7_Attain
Inst1Quest5_HORDE_Aim = Inst1Quest7_Aim
Inst1Quest5_HORDE_Location = Inst1Quest7_Location
Inst1Quest5_HORDE_Note = Inst1Quest7_Note
Inst1Quest5_HORDE_Prequest = Inst1Quest7_Prequest
Inst1Quest5_HORDE_Folgequest = Inst1Quest7_Folgequest
-- No Rewards for this quest

--Quest 6 Horde
Inst1Quest6_HORDE = "6. УНИЧТОЖИТЬ НА МЕСТЕ:Дворфы Черного Железа" -- 4081
Inst1Quest6_HORDE_Level = "52"
Inst1Quest6_HORDE_Attain = "48"
Inst1Quest6_HORDE_Aim = "Отправляйтесь в Глубины Черной горы и уничтожьте подлых агрессоров! По приказу полководца Клинозуба уничтожьте 15 охранников, 10 надсмотрщиков и 5 пехотинцев из клана Ярости Горна. Вернитесь сразу по выполнении задания."
Inst1Quest6_HORDE_Location = "Доска объявлений (Бесплодные земли - Каргат; "..YELLOW.."3,47"..WHITE..")"
Inst1Quest6_HORDE_Note = "Вы найдете дворфов в первой части Глубин Черной горы.\nВы найдете полководца Клинозуба в Каргате на вершине башни (Бесплодные земли, "..YELLOW.."5,47"..WHITE..")."
Inst1Quest6_HORDE_Prequest = "Нет"
Inst1Quest6_HORDE_Folgequest = "УНИЧТОЖИТЬ НА МЕСТЕ:Высокопоставленные чины Черного Железа" -- 4082
-- No Rewards for this quest

--Quest 7 Horde
Inst1Quest7_HORDE = "7. УНИЧТОЖИТЬ НА МЕСТЕ:Высокопоставленные чины Черного Железа" -- 4082
Inst1Quest7_HORDE_Level = "54"
Inst1Quest7_HORDE_Attain = "49"
Inst1Quest7_HORDE_Aim = "Отправляйтесь в Глубины Черной горы и уничтожьте подлых агрессоров! По приказу полководца Клинозуба уничтожьте 10 медиков, 10 солдат и 10 офицеров из клана Ярости Горна. Вернитесь сразу по выполнении задания."
Inst1Quest7_HORDE_Location = "Доска объявлений (Бесплодные земли - Каргат; "..YELLOW.."3,47"..WHITE..")"
Inst1Quest7_HORDE_Note = "Вы найдете дворфов около Бейл'Гор "..YELLOW.."[11]"..WHITE..". Вы найдете полководца Клинозуба в Каргате на вершине башни (Бесплодные земли, "..YELLOW.."5,47"..WHITE..").\n Последующее задание начинается у Лекслорта (Бесплодные земли - Каргат; "..YELLOW.."5,47"..WHITE.."). Вы найдете Грарка в Пылающих степях ("..YELLOW.."38,35"..WHITE.."). Вы должны опустить его ХП ниже 50%, чтобы начать задание сопровождения."
Inst1Quest7_HORDE_Prequest = "УНИЧТОЖИТЬ НА МЕСТЕ: Дворфы Черного Железа" -- 4081
Inst1Quest7_HORDE_Folgequest = "Грарк Лоркруб -> Опасное положение (Задание сопровождения)" -- 4122 -> 4121
Inst1Quest7FQuest_HORDE = "true"
-- No Rewards for this quest

--Quest 8 Horde
Inst1Quest8_HORDE = "8. Операция:смерть Кузне Гнева" -- 4132
Inst1Quest8_HORDE_Level = "58"
Inst1Quest8_HORDE_Attain = "54"
Inst1Quest8_HORDE_Aim = "Отправляйтесь в Глубины Черной горы и убейте генерала Кузню Гнева. Вернитесь к полководцу Клинозубу по выполнении задания."
Inst1Quest8_HORDE_Location = "Полководец Клинозуб (Бесплодные земли - Каргат; "..YELLOW.."5,47"..WHITE..")"
Inst1Quest8_HORDE_Note = "Вы найдете генерала Кузню Гнева около "..YELLOW.."[13]"..WHITE..". Он зовет подкрепление когда ХП ниже 30%!"
Inst1Quest8_HORDE_Prequest = "Опасное положение" -- 4121
Inst1Quest8_HORDE_Folgequest = "Нет"
Inst1Quest8FQuest_HORDE = "true"
--
Inst1Quest8name1_HORDE = "Медальон Завоевателя"

--Quest 9 Horde
Inst1Quest9_HORDE = "9. Восстание машин" -- 4063
Inst1Quest9_HORDE_Level = "58"
Inst1Quest9_HORDE_Attain = "52"
Inst1Quest9_HORDE_Aim = "Найдите и убейте повелителя големов Аргелмаха. Принесите его голову Лотвилу. Также соберите 10 невредимых ядер стихий с беспощадных големов и созданий-завоевателей, охраняющих Аргелмаха."
Inst1Quest9_HORDE_Location = "Лотвиль Вериатус (Бесплодные земли; "..YELLOW.."25,44"..WHITE..")"
Inst1Quest9_HORDE_Note = "Вы возьмете предшествуещее задание у  Верховной Жрицы Теодоры Мальвадании (Бесплодные земли - Каргат; "..YELLOW.."3,47"..WHITE..").\nВы найдете Аргелмаха около "..YELLOW.."[14]"..WHITE.."."
Inst1Quest9_HORDE_Prequest = "Восстание машин" -- 4062
Inst1Quest9_HORDE_Folgequest = "Нет"
Inst1Quest9PreQuest_HORDE = "true"
--
Inst1Quest9name1_HORDE = "Лазурный лунный нарамник"
Inst1Quest9name2_HORDE = "Пелерина Заклинателя Дождя"
Inst1Quest9name3_HORDE = "Базальтовая чешуйчатая броня"
Inst1Quest9name4_HORDE = "Лавовые рукавицы"

--Quest 10 Horde  (same as Quest 9 Alliance)
Inst1Quest10_HORDE = "10. Вкус пламени"
Inst1Quest10_HORDE_Level = Inst1Quest9_Level
Inst1Quest10_HORDE_Attain = Inst1Quest9_Attain
Inst1Quest10_HORDE_Aim = Inst1Quest9_Aim
Inst1Quest10_HORDE_Location = Inst1Quest9_Location
Inst1Quest10_HORDE_Note = Inst1Quest9_Note
Inst1Quest10_HORDE_Prequest = Inst1Quest9_Prequest
Inst1Quest10_HORDE_Folgequest = Inst1Quest9_Folgequest
Inst1Quest10PreQuest_HORDE = Inst1Quest9PreQuest
--
Inst1Quest10name1_HORDE = Inst1Quest9name1
Inst1Quest10name2_HORDE = Inst1Quest9name2
Inst1Quest10name3_HORDE = Inst1Quest9name3

--Quest 11 Horde
Inst1Quest11_HORDE = "11. Дисгармония пламени"
Inst1Quest11_HORDE_Level = "52"
Inst1Quest11_HORDE_Attain = "48"
Inst1Quest11_HORDE_Aim = "Отправьтесь в карьер у Черной горы и уничтожьте Подчинителя Пирона. По выполнению вернитесь к Громосерду."
Inst1Quest11_HORDE_Location = "Громосерд  (Бесплодные земли  - Каргат; "..YELLOW.."3,48"..WHITE..")"
Inst1Quest11_HORDE_Note = "Подчинитель Пирон огненный элементаль. "..YELLOW.."[24]"..WHITE.."Локация Тлеющее ущелье."..YELLOW.."[1]"..WHITE.."Возле  Глубин Черной горы."
Inst1Quest11_HORDE_Prequest = "Нет"
Inst1Quest11_HORDE_Folgequest = "Дисгармония пламени"
-- No Rewards for this quest

--Quest 12 Horde
Inst1Quest12_HORDE = "12 Дисгармония пламени" -- 3907
Inst1Quest12_HORDE_Level = "56"
Inst1Quest12_HORDE_Attain = "48"
Inst1Quest12_HORDE_Aim = "Ступайте в глубины Черной горы и выследите лорда Опалителя. Убейте его и принесите Громосерду все, что может дать какую-то информацию."
Inst1Quest12_HORDE_Location = "Громосерд (Бесплодные земли - Каргат; "..YELLOW.."3,48"..WHITE..")"
Inst1Quest12_HORDE_Note = "Вы получите предыдущее задание у Громосерда тоже.\nВы найдете Лорда Опалителя около "..YELLOW.."[10]"..WHITE.."."
Inst1Quest12_HORDE_Prequest = "Дисгармония пламени" -- 3906
Inst1Quest12_HORDE_Folgequest = "Нет"
Inst1Quest12FQuest_HORDE = "true"
--
Inst1Quest12name1_HORDE = "Солнечная накидка"
Inst1Quest12name2_HORDE = "Сумрачные перчатки"
Inst1Quest12name3_HORDE = "Наручи демона склепа"
Inst1Quest12name4_HORDE = "Стойкий поясок"

--Quest 13 Horde
Inst1Quest13_HORDE = "13. Последний элемент" -- 7201
Inst1Quest13_HORDE_Level = "54"
Inst1Quest13_HORDE_Attain = "48"
Inst1Quest13_HORDE_Aim = "Отправляйтесь в Глубины Черной горы и добудьте 10 мер сущности Стихий. Стоит начать поиски с големов и их создателей. Вивиан Лягроб также бормотала что-то про элементалей."
Inst1Quest13_HORDE_Location = "Темный маг Вивиана Лягроб (Бесплодные земли - Каргат; "..YELLOW.."2,47"..WHITE..")"
Inst1Quest13_HORDE_Note = "Вы получите предшествующее задание у Громосерда (Бесплодные земли - Каргат; "..YELLOW.."3,48"..WHITE..").\n С каждого элементаля может выпасть сущность стихий"
Inst1Quest13_HORDE_Prequest = "Нет"
Inst1Quest13_HORDE_Folgequest = "Нет"
Inst1Quest13PreQuest_HORDE = "true"
--
Inst1Quest13name1_HORDE = "Печать Лаграва"

--Quest 14 Horde
Inst1Quest14_HORDE = "14. Командир Гор'шак" -- 3981
Inst1Quest14_HORDE_Level = "52"
Inst1Quest14_HORDE_Attain = "48"
Inst1Quest14_HORDE_Aim = "Найдите командира Гор'шака в Глубинах Черной горы.\nСудя по рисунку в записке, искать следует в темнице где-то вроде того."
Inst1Quest14_HORDE_Location = "Гамалав Стрелок (Бесплодные земли - Каргат; "..YELLOW.."5,47"..WHITE..")"
Inst1Quest14_HORDE_Note = "Вы получите предшествующее задание у Громосерда (Бесплодные земли - Каргат; "..YELLOW.."3,48"..WHITE..").\nВы найдете командира Гор'шака около "..YELLOW.."[3]"..WHITE..". Ключ, чтобы открыть камеру, пдает с Веровного Дознавателя Герштаны "..YELLOW.."[5]"..WHITE..". Если вы поговорите с ним, начнется следующее задание и появятся враги."
Inst1Quest14_HORDE_Prequest = "Дисгармония пламени" -- 3906
Inst1Quest14_HORDE_Folgequest = "Что происходит?" -- 3982
Inst1Quest14PreQuest_HORDE = "true"

--Quest 15 Horde
Inst1Quest15_HORDE = "15. Спасение принцессы" -- 4003
Inst1Quest15_HORDE_Level = "59"
Inst1Quest15_HORDE_Attain = "50"
Inst1Quest15_HORDE_Aim = "Убейте императора Даграна Тауриссана и освободите принцессу Мойру Бронзобород от его черного заклятия."
Inst1Quest15_HORDE_Location = "Тралл (Оргриммар; "..YELLOW.."31,37"..WHITE..")"
Inst1Quest15_HORDE_Note = "После того, как вы поговорите с Караном Могучим Молотом и Траллом, вы получите это задание.\nВы найдете императора Даграна Тауриссана около "..YELLOW.."[21]"..WHITE..". Во время боя принцесса может лечить Даграна. Постарайтесь по возможности сбивать ей заклинание, но торопитесь, так она не должна умереть или вы провалите задание! (Награда за Спасенная принцесса)"
Inst1Quest15_HORDE_Prequest = "Командир Гор'шак -> Восточные королевства" -- 3981 -> 4002
Inst1Quest15_HORDE_Folgequest = "Спасенная принцесса" -- 4004
Inst1Quest15FQuest_HORDE = "true"
--
Inst1Quest15name1_HORDE = "Решимость Тралла"
Inst1Quest15name2_HORDE = "Око Оргриммара"

--Quest 16 Horde  (same as Quest 12 Alliance)
Inst1Quest16_HORDE = "16. Сродство с недрами"
Inst1Quest16_HORDE_Level = Inst1Quest12_Level
Inst1Quest16_HORDE_Attain = Inst1Quest12_Attain
Inst1Quest16_HORDE_Aim = Inst1Quest12_Aim
Inst1Quest16_HORDE_Location = Inst1Quest12_Location
Inst1Quest16_HORDE_Note = Inst1Quest12_Note
Inst1Quest16_HORDE_Prequest = Inst1Quest12_Prequest
Inst1Quest16_HORDE_Folgequest = Inst1Quest12_Folgequest
-- No Rewards for this quest

--Quest 17 Horde  (same as Quest 13 Alliance)
Inst1Quest17_HORDE = "17. Вызов"
Inst1Quest17_HORDE_Level = Inst1Quest13_Level
Inst1Quest17_HORDE_Attain = Inst1Quest13_Attain
Inst1Quest17_HORDE_Aim = Inst1Quest13_Aim
Inst1Quest17_HORDE_Location = Inst1Quest13_Location
Inst1Quest17_HORDE_Note = Inst1Quest13_Note
Inst1Quest17_HORDE_Prequest = Inst1Quest13_Prequest
Inst1Quest17_HORDE_Folgequest = Inst1Quest13_Folgequest
-- No Rewards for this quest

--Quest 18 Horde  (same as Quest 14 Alliance)
Inst1Quest18_HORDE = "18. Призрачный кубок"
Inst1Quest18_HORDE_Level = Inst1Quest14_Level
Inst1Quest18_HORDE_Attain = Inst1Quest14_Attain
Inst1Quest18_HORDE_Aim = Inst1Quest14_Aim
Inst1Quest18_HORDE_Location = Inst1Quest14_Location
Inst1Quest18_HORDE_Note = Inst1Quest14_Note
Inst1Quest18_HORDE_Prequest = Inst1Quest14_Prequest
Inst1Quest18_HORDE_Folgequest = Inst1Quest14_Folgequest
-- No Rewards for this quest



--------------- INST2 - Blackwing Lair ---------------

Inst2Caption = "Логово Крыла Тьмы"
Inst2QAA = "3 задания"
Inst2QAH = "3 задания"

--Quest 1 Alliance
Inst2Quest1 = "1. Поражение Нефария" -- 8730
Inst2Quest1_Level = "60"
Inst2Quest1_Attain = "60"
Inst2Quest1_Aim = "Убейте Нефариана и добудьте осколок красного скипетра. Верните осколок красного скипетра Анахроносу в Пещеры Времени в Танарис. На выполнение задания у Вас есть 5 часов."
Inst2Quest1_Location = "Валестраз Порочный (Логово Крыла Тьмы; "..YELLOW.."[2]"..WHITE..")"
Inst2Quest1_Note = "Только один игрок может получить осколок. Анахронос (Танарис - Пещеры Времени; "..YELLOW.."65,49"..WHITE..")"
Inst2Quest1_Prequest = "Создание драконов" -- 8555
Inst2Quest1_Folgequest = "Армия Калимдора (Необходимо выполнить цепочки заданий Зеленого и Голубого скипетра)"  -- 8742
--
Inst2Quest1name1 = "Поножи, инкрустированные ониксом"
Inst2Quest1name2 = "Амулет Барьера Теней"

--Quest 2 Alliance
Inst2Quest2 = "2. Владыка Черной горы" -- 7781
Inst2Quest2_Level = "60"
Inst2Quest2_Attain = "60"
Inst2Quest2_Aim = "Отнесите голову Нефариана Верховному лорду Болвару Фордрагону в Штормград."
Inst2Quest2_Location = "Голова Нефариана (добывается с Нефариана; "..YELLOW.."[9]"..WHITE..")"
Inst2Quest2_Note = "Верховный лорд Болвар Фордрагон находится (Штормград - Крепость Штормграда; "..YELLOW.."78,20"..WHITE.."). Далее Вас посылают к Фельдмаршалу Афрасиаби (Штормград - Аллея героев; "..YELLOW.."67,72"..WHITE..") для получения награды."
Inst2Quest2_Prequest = "Нет"
Inst2Quest2_Folgequest = "Владыка Черной горы" -- 7782
--
Inst2Quest2name1 = "Медальон великого драконоборца"
Inst2Quest2name2 = "Сфера великого драконоборца"
Inst2Quest2name3 = "Кольцо великого драконоборца"

--Quest 3 Alliance
Inst2Quest3 = "3. Кто будет избран?" -- 8288
Inst2Quest3_Level = "60"
Inst2Quest3_Attain = "60"
Inst2Quest3_Aim = "Принесите голову предводителя драконов Разящего Бича Баристольфу из Зыбучих Песков в Крепость Кенария в Силитусе."
Inst2Quest3_Location = "Голова предводителя драконидов Разящего Бича (добывается с Предводителя драконов Разящего Бича; "..YELLOW.."[3]"..WHITE..")"
Inst2Quest3_Note = "Только один игрок может получить голову."
Inst2Quest3_Prequest = "Что ждет нас завтра" -- 8286
Inst2Quest3_Folgequest = "Путь праведника" -- 8301
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst2Quest1_HORDE = Inst2Quest1
Inst2Quest1_HORDE_Level = Inst2Quest1_Level
Inst2Quest1_HORDE_Attain = Inst2Quest1_Attain
Inst2Quest1_HORDE_Aim = Inst2Quest1_Aim
Inst2Quest1_HORDE_Location = Inst2Quest1_Location
Inst2Quest1_HORDE_Note = Inst2Quest1_Note
Inst2Quest1_HORDE_Prequest = Inst2Quest1_Prequest
Inst2Quest1_HORDE_Folgequest = Inst2Quest1_Folgequest
--
Inst2Quest1name1_HORDE = Inst2Quest1name1
Inst2Quest1name2_HORDE = Inst2Quest1name2

--Quest 2 Horde
Inst2Quest2_HORDE = "2. Владыка Черной горы" -- 7783
Inst2Quest2_HORDE_Level = "60"
Inst2Quest2_HORDE_Attain = "60"
Inst2Quest2_HORDE_Aim = "Отнесите голову Нефариана Траллу в Оргриммар."
Inst2Quest2_HORDE_Location = "Голова Нефариана (добывается с Нефариана; "..YELLOW.."[9]"..WHITE..")"
Inst2Quest2_HORDE_Note = "Далее Вас посылают к Верховному правителю Саурфангу (Оргриммар - Аллея Силы; "..YELLOW.."51,76"..WHITE..") для получения награды."
Inst2Quest2_HORDE_Prequest = "Нет"
Inst2Quest2_HORDE_Folgequest = "Владыка Черной горы" -- 7784
--
Inst2Quest2name1_HORDE = "Медальон великого драконоборца"
Inst2Quest2name2_HORDE = "Сфера великого драконоборца"
Inst2Quest2name3_HORDE = "Кольцо великого драконоборца"

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst2Quest3_HORDE = Inst2Quest3
Inst2Quest3_HORDE_Level = Inst2Quest3_Level
Inst2Quest3_HORDE_Attain = Inst2Quest3_Attain
Inst2Quest3_HORDE_Aim = Inst2Quest3_Aim
Inst2Quest3_HORDE_Location = Inst2Quest3_Location
Inst2Quest3_HORDE_Note = Inst2Quest3_Note
Inst2Quest3_HORDE_Prequest = Inst2Quest3_Prequest
Inst2Quest3_HORDE_Folgequest = Inst2Quest3_Folgequest
-- No Rewards for this quest



--------------- INST3 - Lower Blackrock Spire ---------------

Inst3Caption = "Низина Черной горы"
Inst3QAA = "14 заданий"
Inst3QAH = "14 заданий"

--Quest 1 Alliance
Inst3Quest1 = "1. Последние таблички"
Inst3Quest1_Level = "58"
Inst3Quest1_Attain = "40"
Inst3Quest1_Aim = "Принесите пятую и шестую таблички Мошару геологу Железному Башмаку в Танарисе."
Inst3Quest1_Location = "Геолог Железный Башмак (Танарис - Порт Картеля; "..YELLOW.."66,23"..WHITE..")"
Inst3Quest1_Note = "Вы найдете таблички около "..YELLOW.."[4]"..WHITE.." и "..YELLOW.."[5]"..WHITE..".\nНаграда переводит на 'Сопротивление Йекинье'. вы найдете Йе'кинья около геолога Железного Башмака."
Inst3Quest1_Prequest = "Утраченные таблички Мошару" -- 5065
Inst3Quest1_Folgequest = "Сопротивление Йекинье" -- 8181
Inst3Quest1PreQuest = "true"
--
Inst3Quest1name1 = "Выцветший плащ Хаккари"
Inst3Quest1name2 = "Потрепанная накидка Хаккари"

--Quest 2 Alliance
Inst3Quest2 = "2. Редкие звери Киблера" -- 4729
Inst3Quest2_Level = "59"
Inst3Quest2_Attain = "55"
Inst3Quest2_Aim = "Отправьтесь на пик Черной горы и отыщите там щенков воргов легиона Кровавого Топора. Посадите маленьких тварей в клетку и отнесите Киблеру."
Inst3Quest2_Location = "Киблер (Пылающие степи - Пламенеющий стяг; "..YELLOW.."65,22"..WHITE..")"
Inst3Quest2_Note = "Вы найдете щенков ворга около "..YELLOW.."[10]"..WHITE.."."
Inst3Quest2_Prequest = "Нет"
Inst3Quest2_Folgequest = "Нет"
--
Inst3Quest2name1 = "Клетка для ворга"

--Quest 3 Alliance
Inst3Quest3 = "3. Товар на любителя" -- 4862
Inst3Quest3_Level = "59"
Inst3Quest3_Attain = "55"
Inst3Quest3_Aim = "Отправьтесь на пик Черной горы и принесите Киблеру 15 яиц скального паука.\nСудя по всему, яйца надо искать недалеко от пауков."
Inst3Quest3_Location = "Киблер (Пылающие степи - Пламенеющий стяг; "..YELLOW.."65,22"..WHITE..")"
Inst3Quest3_Note = "Вы найдете яйца пауков около "..YELLOW.."[6]"..WHITE.."."
Inst3Quest3_Prequest = "Нет"
Inst3Quest3_Folgequest = "Нет"
--
Inst3Quest3name1 = "Клетка Огнепаутинки"

--Quest 4 Alliance
Inst3Quest4 = "4. Материнское молоко" -- 4866
Inst3Quest4_Level = "60"
Inst3Quest4_Attain = "55"
Inst3Quest4_Aim = "Найдите в самом сердце пика Черной горы мать Дымную Паутину. Сражайтесь с ней, пока она не введет вам свой яд. Скорее всего ее также придется убить. Когда яд будет в вас, вернитесь к Джону-Оборванцу, чтобы он смог добыть яд."
Inst3Quest4_Location = "Джон-Оборванец (Пылающие степи - Пламенеющий стяг; "..YELLOW.."65,23"..WHITE..")"
Inst3Quest4_Note = "Мать Дымная Паутина находится около "..YELLOW.."[6]"..WHITE..". Яд также поражает ближаиших игроков. Если яд вылечить, вы провалите задание."
Inst3Quest4_Prequest = "Нет"
Inst3Quest4_Folgequest = "Нет"
--
Inst3Quest4name1 = "Неупиваемая чаша Джона-Оборванца"

--Quest 5 Alliance
Inst3Quest5 = "5. Устранение опасности" -- 4701
Inst3Quest5_Level = "59"
Inst3Quest5_Attain = "55"
Inst3Quest5_Aim = "Отправьтесь на пик Черной горы и уничтожьте источник опасности. Хелендис кричит вам вслед одно имя: Халикон. Именно его упоминали орки в связи с воргами."
Inst3Quest5_Location = "Хелендис Речной Мыс (Пылающие степи - Дозор Моргана; "..YELLOW.."5,47"..WHITE..")"
Inst3Quest5_Note = "Вы найдете Халикон около "..YELLOW.."[10]"..WHITE.."."
Inst3Quest5_Prequest = "Нет"
Inst3Quest5_Folgequest = "Нет"
--
Inst3Quest5name1 = "Асторийские одеяния"
Inst3Quest5name2 = "Звероловецкий жакет"
Inst3Quest5name3 = "Кираса из нефритовой чешуи"

--Quest 6 Alliance
Inst3Quest6 = "6. Аррок Смертный Вопль" -- 4867
Inst3Quest6_Level = "60"
Inst3Quest6_Attain = "55"
Inst3Quest6_Aim = "Прочитайте записку Вароша. Принесите Варошу его амулет."
Inst3Quest6_Location = "Варош (Вершина Черной горы; "..YELLOW.."[2]"..WHITE..")"
Inst3Quest6_Note = "Чтобы получить амулет Вароша нужно вызвать и убить Аррока Смертного Вопля "..YELLOW.."[8]"..WHITE..". Для Вызова понадобится Копье и голова вождя Омокка "..YELLOW.."[3]"..WHITE..". Копье находится около "..YELLOW.."[2]"..WHITE..". Во время Вызова появляется несколько волн огров, перед тем как Вас атакует Аррок Смертный Вопль. Вы можете использовать Копье в бою, чтобы наносить урон ограм."
Inst3Quest6_Prequest = "Нет"
Inst3Quest6_Folgequest = "Нет"
--
Inst3Quest6name1 = "Оберег-призма"

--Quest 7 Alliance
Inst3Quest7 = "7. Вещи Блестяшки" -- 5001
Inst3Quest7_Level = "59"
Inst3Quest7_Attain = "55"
Inst3Quest7_Aim = "Найдите вещи Блестяшки и верните их владелице. Удачи!"
Inst3Quest7_Location = "Блестяшка (Вершина Черной горы; "..YELLOW.."[1] "..WHITE.."и"..YELLOW.." [2]"..WHITE..")"
Inst3Quest7_Note = "Вы найдете вещи Блестяшки по пути к Матери Дымной Паутине около "..YELLOW.."[10]"..WHITE..".\nМаксвелл находится около (Пылающие степи - Дозор Моргана; "..YELLOW.."84,58"..WHITE..")."
Inst3Quest7_Prequest = "Нет"
Inst3Quest7_Folgequest = "Донесение Максвелла" -- 5002
-- No Rewards for this quest

--Quest 8 Alliance
Inst3Quest8 = "8. Миссия Максвелла" -- 5081
Inst3Quest8_Level = "60"
Inst3Quest8_Attain = "55"
Inst3Quest8_Aim = "Отправляйтесь на пик Черной горы и устраните воеводу Вуна, вождя Омокка и повелителя Змейталака. По выполнении задания вернитесь к маршалу Максвеллу."
Inst3Quest8_Location = "Маршал Максвелл (Пылающие степи - Дозор Моргана; "..YELLOW.."84,58"..WHITE..")"
Inst3Quest8_Note = "Вы найдете воеводу Вуна около "..YELLOW.."[5]"..WHITE..", вождя Омокка около "..YELLOW.."[3]"..WHITE.." и повелителя Змейталака около "..YELLOW.."[11]"..WHITE.."."
Inst3Quest8_Prequest = "Донесение Максвелла" -- 5002
Inst3Quest8_Folgequest = "Нет"
Inst3Quest8FQuest = "true"
--
Inst3Quest8name1 = "Оковы Вурмталака"
Inst3Quest8name2 = "Тесьма-фиксатор Омокка"
Inst3Quest8name3 = "Намордник Халикон"
Inst3Quest8name4 = "Пояс Вос'гаджин"
Inst3Quest8name5 = "Поганые захваты Вуна"

--Quest 9 Alliance
Inst3Quest9 = "9. Печать Вознесения" -- 4742
Inst3Quest9_Level = "60"
Inst3Quest9_Attain = "57"
Inst3Quest9_Aim = "Найдите самоцвет Тлеющего Терновника, самоцвет Черной Вершины и самоцвет Кровавого Топора. Верните их Ваелану вместе с простой печатью Вознесения./nКамни могут быть у трех генералов: у воеводы Вуна из клана Тлеющего Терновника, у вождя Омокка из клана Черной Вершины и у повелителя Змейталака из клана Кровавого Топора."
Inst3Quest9_Location = "Ваелан (Вершина Черной горы; "..YELLOW.."[1]"..WHITE..")"
Inst3Quest9_Note = "Вы получите самоцвет Черной вершины с вождя Омокка "..YELLOW.."[3]"..WHITE..", самоцвет Тлеющего Терновника с воеводы Вуна около "..YELLOW.."[5]"..WHITE.." самоцвет Кровавого Топора с повелителя Змейталака около "..YELLOW.."[11]"..WHITE..". Простая печать Вознесения может упасть с любого врага в Низине Черной горы. Если вы закончите эту цепочку заданий, то получите ключ к Вершине Черной горы."
Inst3Quest9_Prequest = "Нет"
Inst3Quest9_Folgequest = "Печать Вознесения" -- 4743
-- No Rewards for this quest

--Quest 10 Alliance
Inst3Quest10 = "10. Приказ генерала Драккисата" -- 5089
Inst3Quest10_Level = "60"
Inst3Quest10_Attain = "55"
Inst3Quest10_Aim = "Отнесите приказ генерала Драккисата маршалу Максвеллу в Пылающие степи."
Inst3Quest10_Location = "Приказ генерала Драккисата (добывается с повелителя Змейталака; "..YELLOW.."[11]"..WHITE..")"
Inst3Quest10_Note = "Маршал Максвелл находится в Пылающие степи - Дозор Моргана; ("..YELLOW.."84,58"..WHITE..")."
Inst3Quest10_Prequest = "Нет"
Inst3Quest10_Folgequest = "Кончина генерала Драккисата ("..YELLOW.."Вершина Черной горы"..WHITE..")" -- 5102
-- No Rewards for this quest

--Quest 11 Alliance
Inst3Quest11 = "11. Левая часть амулета Лорда Вальтхалака" -- 8966
Inst3Quest11_Level = "60"
Inst3Quest11_Attain = "58"
Inst3Quest11_Aim = "Вызвать дух Мора Серого Копыта с помощью жаровни Призыва, прикончить его и забрать недостающую часть амулета Лорда Вальтхалака. Вернуться к Бодли в Черную гору, отдать ему левую часть амулета Вальтхалака и жаровню Призыва."
Inst3Quest11_Location = "Бодли (Черная гора; "..YELLOW.."[D] на карте входа"..WHITE..")"
Inst3Quest11_Note = "Чтобы увидеть Бодли нужен Спектральный сканер иных измерений. Вы получите его за задание 'В поисках Антиона'.\n\nМор Серое Копыто призывается около "..YELLOW.."[9]"..WHITE.."."
Inst3Quest11_Prequest = "Важная составляющая заклинания" -- 8962
Inst3Quest11_Folgequest = "Я вижу в твоем будущем остров Алькац..." -- 8970
Inst3Quest11PreQuest = "true"
-- No Rewards for this quest

--Quest 12 Alliance
Inst3Quest12 = "12. Правая часть амулета Лорда Вальтхалака" -- 8989
Inst3Quest12_Level = "60"
Inst3Quest12_Attain = "58"
Inst3Quest12_Aim = "Вызвать дух Мора Серого Копыта с помощью жаровни Призыва, прикончить его и забрать недостающую часть амулета Лорда Вальтхалака. Вернуться к Бодли в Черную гору, отдать ему восстановленный амулет и жаровню Призыва."
Inst3Quest12_Location = "Бодли (Черная гора; "..YELLOW.."[D] на карте входа"..WHITE..")"
Inst3Quest12_Note = "Чтобы увидеть Бодли нужен Спектральный сканер иных измерений. Вы получите его за задание 'В поисках Антиона'.\n\nМор Серое Копыто призывается около "..YELLOW.."[9]"..WHITE.."."
Inst3Quest12_Prequest = "Еще одна важная составляющая заклинания" -- 8986
Inst3Quest12_Folgequest = "Последние приготовления ("..YELLOW.."Вершина Черной горы"..WHITE..")" -- 8994
Inst3Quest12PreQuest = "true"
-- No Rewards for this quest

--Quest 13 Alliance
Inst3Quest13 = "13. Змеекамень Пленяющей Духов" -- 5306
Inst3Quest13_Level = "60"
Inst3Quest13_Attain = "50"
Inst3Quest13_Aim = "Отправляйтесь на Пик Черной горы, убейте Темную охотницу Вос'гаджин. Заберите у нее змеекамень и принесите Килраму."
Inst3Quest13_Location = "Килрам (Зимние Ключи - Круговзор; "..YELLOW.."61,37"..WHITE..")"
Inst3Quest13_Note = "Задание для кузнецов. Темная охотница Вос'гаджин около "..YELLOW.."[7]"..WHITE.."."
Inst3Quest13_Prequest = "Нет"
Inst3Quest13_Folgequest = "Нет"
--
Inst3Quest13name1 = "Чертеж: Лезвие Рассвета"

--Quest 14 Alliance
Inst3Quest14 = "14. Смерть в огне" -- 5103
Inst3Quest14_Level = "60"
Inst3Quest14_Attain = "60"
Inst3Quest14_Aim = "Наверняка в этом мире есть кто-то, кто знает, что делать с этими рукавицами."
Inst3Quest14_Location = "Человеческие останки (Низина Черной горы; "..YELLOW.."[9]"..WHITE..")"
Inst3Quest14_Note = "Задание для кузнецов. Обязательно возьмите Неопалимые латные рукавицы вблизи с Человеческими останками около "..YELLOW.."[11]"..WHITE..". Отнесите их Малифою Черномолоту (Зимние Ключи - Круговзор; "..YELLOW.."61,39"..WHITE.."). Награды перечислены для следующего задания."
Inst3Quest14_Prequest = "Нет"
Inst3Quest14_Folgequest = "Огненные латные рукавицы" -- 5124
--
Inst3Quest14name1 = "Чертеж: огненные латные рукавицы"
Inst3Quest14name2 = "Огненные латные рукавицы"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst3Quest1_HORDE = Inst3Quest1
Inst3Quest1_HORDE_Level = Inst3Quest1_Level
Inst3Quest1_HORDE_Attain = Inst3Quest1_Attain
Inst3Quest1_HORDE_Aim = Inst3Quest1_Aim
Inst3Quest1_HORDE_Location = Inst3Quest1_Location
Inst3Quest1_HORDE_Note = Inst3Quest1_Note
Inst3Quest1_HORDE_Prequest = Inst3Quest1_Prequest
Inst3Quest1_HORDE_Folgequest = Inst3Quest1_Folgequest
Inst3Quest1PreQuest_HORDE = Inst3Quest1PreQuest
--
Inst3Quest1name1_HORDE = Inst3Quest1name1
Inst3Quest1name2_HORDE = Inst3Quest1name2

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst3Quest2_HORDE = Inst3Quest2
Inst3Quest2_HORDE_Level = Inst3Quest2_Level
Inst3Quest2_HORDE_Attain = Inst3Quest2_Attain
Inst3Quest2_HORDE_Aim = Inst3Quest2_Aim
Inst3Quest2_HORDE_Location = Inst3Quest2_Location
Inst3Quest2_HORDE_Note = Inst3Quest2_Note
Inst3Quest2_HORDE_Prequest = Inst3Quest2_Prequest
Inst3Quest2_HORDE_Folgequest = Inst3Quest2_Folgequest
--
Inst3Quest2name1_HORDE = Inst3Quest2name1

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst3Quest3_HORDE = Inst3Quest3
Inst3Quest3_HORDE_Level = Inst3Quest3_Level
Inst3Quest3_HORDE_Attain = Inst3Quest3_Attain
Inst3Quest3_HORDE_Aim = Inst3Quest3_Aim
Inst3Quest3_HORDE_Location = Inst3Quest3_Location
Inst3Quest3_HORDE_Note = Inst3Quest3_Note
Inst3Quest3_HORDE_Prequest = Inst3Quest3_Prequest
Inst3Quest3_HORDE_Folgequest = Inst3Quest3_Folgequest
--
Inst3Quest3name1_HORDE = Inst3Quest3name1

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst3Quest4_HORDE = Inst3Quest4
Inst3Quest4_HORDE_Level = Inst3Quest4_Level
Inst3Quest4_HORDE_Attain = Inst3Quest4_Attain
Inst3Quest4_HORDE_Aim = Inst3Quest4_Aim
Inst3Quest4_HORDE_Location = Inst3Quest4_Location
Inst3Quest4_HORDE_Note = Inst3Quest4_Note
Inst3Quest4_HORDE_Prequest = Inst3Quest4_Prequest
Inst3Quest4_HORDE_Folgequest = Inst3Quest4_Folgequest
--
Inst3Quest4name1_HORDE = Inst3Quest4name1

--Quest 5 Horde
Inst3Quest5_HORDE = "5. Праматерь стаи" -- 4724
Inst3Quest5_HORDE_Level = "59"
Inst3Quest5_HORDE_Attain = "55"
Inst3Quest5_HORDE_Aim = "Убейте Халикон, праматерь стаи воргов Кровавого Топора."
Inst3Quest5_HORDE_Location = "Галамав Стрелок (Бесплодные земли - Каргат; "..YELLOW.."5,47"..WHITE..")"
Inst3Quest5_HORDE_Note = "Вы найдете Халикон около "..YELLOW.."[10]"..WHITE.."."
Inst3Quest5_HORDE_Prequest = "Нет"
Inst3Quest5_HORDE_Folgequest = "Нет"
--
Inst3Quest5name1_HORDE = "Асторийские одеяния"
Inst3Quest5name2_HORDE = "Звероловецкий жакет"
Inst3Quest5name3_HORDE = "Кираса из нефритовой чешуи"

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst3Quest6_HORDE = Inst3Quest6
Inst3Quest6_HORDE_Level = Inst3Quest6_Level
Inst3Quest6_HORDE_Attain = Inst3Quest6_Attain
Inst3Quest6_HORDE_Aim = Inst3Quest6_Aim
Inst3Quest6_HORDE_Location = Inst3Quest6_Location
Inst3Quest6_HORDE_Note = Inst3Quest6_Note
Inst3Quest6_HORDE_Prequest = Inst3Quest6_Prequest
Inst3Quest6_HORDE_Folgequest = Inst3Quest6_Folgequest
--
Inst3Quest6name1_HORDE = Inst3Quest6name1

--Quest 7 Horde
Inst3Quest7_HORDE = "7. Агент Блестяшка" -- 4981
Inst3Quest7_HORDE_Level = "59"
Inst3Quest7_HORDE_Attain = "55"
Inst3Quest7_HORDE_Aim = "Отправьтесь к пику Черной горы и выясните, что сталось с Блестяшкой."
Inst3Quest7_HORDE_Location = "Лекслорт (Бесплодные земли - Каргат; "..YELLOW.."5,47"..WHITE..")"
Inst3Quest7_HORDE_Note = "Вы найдете Блестяшку около "..YELLOW.."[1] "..WHITE.."и "..YELLOW.."[2]"..WHITE.."."
Inst3Quest7_HORDE_Prequest = "Нет"
Inst3Quest7_HORDE_Folgequest = "Вещи Блестяшки" -- 4982
-- No Rewards for this quest

--Quest 8 Horde
Inst3Quest8_HORDE = "8. Вещи Блестяшки" -- 4982
Inst3Quest8_HORDE_Level = "59"
Inst3Quest8_HORDE_Attain = "55"
Inst3Quest8_HORDE_Aim = "Найдите вещи Блестяшки и верните их владелице. Блестяшка сказала, что она спрятала свое оборудование где-то на нижнем ярусе подземелья."
Inst3Quest8_HORDE_Location = "Блестяшка (Вершина Черной горы; "..YELLOW.."[3]"..WHITE..")"
Inst3Quest8_HORDE_Note = "Вы найдете вещи Блестяшки по пути к Матери Дымной Паутине около "..YELLOW.."[6]"..WHITE..".\nНаграда отправляет к 'По данным разведки'."
Inst3Quest8_HORDE_Prequest = "Агент Блестяшка" -- 4982
Inst3Quest8_HORDE_Folgequest = "По данным разведки" -- 4983
Inst3Quest8FQuest_HORDE = "true"
--
Inst3Quest8name1_HORDE = "Перчатки Вольного ветра"
Inst3Quest8name2_HORDE = "Ремень морской заставы"

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst3Quest9_HORDE = Inst3Quest9
Inst3Quest9_HORDE_Level = Inst3Quest9_Level
Inst3Quest9_HORDE_Attain = Inst3Quest9_Attain
Inst3Quest9_HORDE_Aim = Inst3Quest9_Aim
Inst3Quest9_HORDE_Location = Inst3Quest9_Location
Inst3Quest9_HORDE_Note = Inst3Quest9_Note
Inst3Quest9_HORDE_Prequest = Inst3Quest9_Prequest
Inst3Quest9_HORDE_Folgequest = Inst3Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde
Inst3Quest10_HORDE = "10. Приказ полководца" -- 4903
Inst3Quest10_HORDE_Level = "60"
Inst3Quest10_HORDE_Attain = "55"
Inst3Quest10_HORDE_Aim = "Убейте вождя Омокка, воеводу Вуна и повелителя Змейталака. Найденные при них важные бумаги Черной горы доставьте полководцу Клинозубу в Каргат."
Inst3Quest10_HORDE_Location = "Полководец Клинозуб (Бесплодные земли - Каргат; "..YELLOW.."65,22"..WHITE..")"
Inst3Quest10_HORDE_Note = "Подготовка к Ониксии.\nВождь Омокк находится около "..YELLOW.."[3]"..WHITE..", воевода Вун находится около "..YELLOW.."[5]"..WHITE.." и повелитель Змейталака "..YELLOW.."[11]"..WHITE..". Важные бумаги Черной горы могут остаться после одного из этих 3 боссов."
Inst3Quest10_HORDE_Prequest = "Нет"
Inst3Quest10_HORDE_Folgequest = "Мудрость Эйтригга -> За Орду! ("..YELLOW.."Вершина Черной горы"..WHITE..")" -- 4941 -> 4974
--
Inst3Quest10name1_HORDE = "Оковы Вурмталака"
Inst3Quest10name2_HORDE = "Тесьма-фиксатор Омокка"
Inst3Quest10name3_HORDE = "Намордник Халикон"
Inst3Quest10name4_HORDE = "Пояс Вос'гаджин"
Inst3Quest10name5_HORDE = "Поганые захваты Вуна"

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst3Quest11_HORDE = Inst3Quest11
Inst3Quest11_HORDE_Level = Inst3Quest11_Level
Inst3Quest11_HORDE_Attain = Inst3Quest11_Attain
Inst3Quest11_HORDE_Aim = Inst3Quest11_Aim
Inst3Quest11_HORDE_Location = Inst3Quest11_Location
Inst3Quest11_HORDE_Note = Inst3Quest11_Note
Inst3Quest11_HORDE_Prequest = Inst3Quest11_Prequest
Inst3Quest11_HORDE_Folgequest = Inst3Quest11_Folgequest
Inst3Quest11PreQuest_HORDE = Inst3Quest11PreQuest
-- No Rewards for this quest

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst3Quest12_HORDE = Inst3Quest12
Inst3Quest12_HORDE_Level = Inst3Quest12_Level
Inst3Quest12_HORDE_Attain = Inst3Quest12_Attain
Inst3Quest12_HORDE_Aim = Inst3Quest12_Aim
Inst3Quest12_HORDE_Location = Inst3Quest12_Location
Inst3Quest12_HORDE_Note = Inst3Quest12_Note
Inst3Quest12_HORDE_Prequest = Inst3Quest12_Prequest
Inst3Quest12_HORDE_Folgequest = Inst3Quest12_Folgequest
Inst3Quest12PreQuest_HORDE = Inst3Quest12PreQuest
-- No Rewards for this quest

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst3Quest13_HORDE = Inst3Quest13
Inst3Quest13_HORDE_Level = Inst3Quest13_Level
Inst3Quest13_HORDE_Attain = Inst3Quest13_Attain
Inst3Quest13_HORDE_Aim = Inst3Quest13_Aim
Inst3Quest13_HORDE_Location = Inst3Quest13_Location
Inst3Quest13_HORDE_Note = Inst3Quest13_Note
Inst3Quest13_HORDE_Prequest = Inst3Quest13_Prequest
Inst3Quest13_HORDE_Folgequest = Inst3Quest13_Folgequest
--
Inst3Quest13name1_HORDE = Inst3Quest13name1

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst3Quest14_HORDE = Inst3Quest14
Inst3Quest14_HORDE_Level = Inst3Quest14_Level
Inst3Quest14_HORDE_Attain = Inst3Quest14_Attain
Inst3Quest14_HORDE_Aim = Inst3Quest14_Aim
Inst3Quest14_HORDE_Location = Inst3Quest14_Location
Inst3Quest14_HORDE_Note = Inst3Quest14_Note
Inst3Quest14_HORDE_Prequest = Inst3Quest14_Prequest
Inst3Quest14_HORDE_Folgequest = Inst3Quest14_Folgequest
--
Inst3Quest14name1_HORDE = Inst3Quest14name1
Inst3Quest14name2_HORDE = Inst3Quest14name2



--------------- INST4 - Upper Blackrock Spire ---------------

Inst4Caption = "Низина Черной горы"
Inst4QAA = "11 заданий"
Inst4QAH = "13 заданий"

--Quest 1 Alliance
Inst4Quest1 = "1. Матрона-защитница" -- 5160
Inst4Quest1_Level = "60"
Inst4Quest1_Attain = "57"
Inst4Quest1_Aim = "Дойдите до Зимних Ключей и найдите Халех. Отдайте ей пластину чешуи Ауби."
Inst4Quest1_Location = "Ауби (Вершина Черной горы; "..YELLOW.."[6]"..WHITE..")"
Inst4Quest1_Note = "Вы найдете Ауби в комнате за Ареной около "..YELLOW.."[6]"..WHITE..".\nХалех находится в Зимних Ключах ("..YELLOW.."54,51"..WHITE.."). Используйте знак-портал в конце пещеры, чтобы добраться до нее."
Inst4Quest1_Prequest = "Нет"
Inst4Quest1_Folgequest = "Гнев синих драконов" -- 5161
-- No Rewards for this quest

--Quest 2 Alliance
Inst4Quest2 = "2. Айс Вентурон, к вашим услугам!" -- 5047
Inst4Quest2_Level = "60"
Inst4Quest2_Attain = "55"
Inst4Quest2_Aim = "Переговорите с Малифоем Черномолотом в Круговзоре."
Inst4Quest2_Location = "Айс Вентурон (Вершина Черной горы; "..YELLOW.."[7]"..WHITE..")"
Inst4Quest2_Note = "Айс Вентурон появляется после свежевания Зверя. Вы найдете Малифоя в (Зимние Ключи - Круговзор; "..YELLOW.."61,38"..WHITE..")."
Inst4Quest2_Prequest = "Нет"
Inst4Quest2_Folgequest = "Поножи Тайны, Шапка Алого Ученого и Кираса кровавой жажды" -- 5063, 5067, 5068
-- No Rewards for this quest

--Quest 3 Alliance
Inst4Quest3 = "3. Заморозка яйца" -- 4734
Inst4Quest3_Level = "60"
Inst4Quest3_Attain = "57"
Inst4Quest3_Aim = "Испытайте прототип яйцехладоскопа на одном из яиц в Гнездовье."
Inst4Quest3_Location = "Тинки Кипеллер (Пылающие степи - Пламенеющий стяг; "..YELLOW.."65,24"..WHITE..")"
Inst4Quest3_Note = "Вы найдете яйца в комнате Отца Пламени около "..YELLOW.."[2]"..WHITE.."."
Inst4Quest3_Prequest = "Сущность детеныша дракона -> Тинки Кипеллер" -- 4726 -> 4907
Inst4Quest3_Folgequest = "Сбор яиц и Леонид Барталомей -> Рассветный гамбит ("..YELLOW.."Некроситет"..WHITE..")" -- 4735 and 5522 -> 4771
Inst4Quest3PreQuest = "true"
--
Inst4Quest3name1 = "Яйцехладоскоп"

--Quest 4 Alliance
Inst4Quest4 = "4. Око Углевзора" -- 6821
Inst4Quest4_Level = "60"
Inst4Quest4_Attain = "56"
Inst4Quest4_Aim = "Принесите око Углевзора герцогу Гидраксису в Азшару."
Inst4Quest4_Location = "Герцог Гидраксис (Азшара; "..YELLOW.."79,73"..WHITE..")"
Inst4Quest4_Note = "Вы найдете Пиростража Углевзора около "..YELLOW.."[1]"..WHITE.."."
Inst4Quest4_Prequest = "Отравленная вода, Буря в пустыне" -- 6804, 6805
Inst4Quest4_Folgequest = "Огненные Недра" -- 6822
Inst4Quest4PreQuest = "true"
-- No Rewards for this quest

--Quest 5 Alliance
Inst4Quest5 = "5. Кончина генерала Драккисата" -- 5102
Inst4Quest5_Level = "60"
Inst4Quest5_Attain = "55"
Inst4Quest5_Aim = "Отправьтесь на пик Черной горы и устраните генерала Драккисата. По выполнении задания вернитесь к маршалу Максвеллу."
Inst4Quest5_Location = "Маршал Максвелл (Пылающие степи - Дозор Моргана; "..YELLOW.."82,68"..WHITE..")"
Inst4Quest5_Note = "Вы найдете генерала Драккисата около "..YELLOW.."[8]"..WHITE.."."
Inst4Quest5_Prequest = "Приказ генерала Драккисата ("..YELLOW.."Низина Черной горы"..WHITE..")" -- 5089
Inst4Quest5_Folgequest = "Нет"
Inst4Quest5PreQuest = "true"
--
Inst4Quest5name1 = "Знак Тирании"
Inst4Quest5name2 = "Глаз Зверя"
Inst4Quest5name3 = "Пластита Чернорука"

--Quest 6 Alliance
Inst4Quest6 = "6. Пряжка Роковой оснастки" -- 4764
Inst4Quest6_Level = "60"
Inst4Quest6_Attain = "57"
Inst4Quest6_Aim = "Принесите пряжку Роковой оснастки Майре Светлое Крыло в Пылающие степи."
Inst4Quest6_Location = "Майра Светлое Крыло (Пылающие степи - Дозор Моргана; "..YELLOW.."84,69"..WHITE..")"
Inst4Quest6_Note = "Вы возьмете предшествующее задание у графа Ремингтона Риджвелла (Штормград - Крепость Штормграда; "..YELLOW.."76.9, 47.4"..WHITE..").\n\nПряжка Роковой оснастки находится около "..YELLOW.."[2]"..WHITE.." с сундуке."
Inst4Quest6_Prequest = "Майра Светлое Крыло" -- 4766
Inst4Quest6_Folgequest = "Доставить Риджвеллу" -- 4765
Inst4Quest6PreQuest = "true"
--
Inst4Quest6name1 = "Быстроступные ботфорты"
Inst4Quest6name2 = "Боевые наручи мгновенного удара"

--Quest 7 Alliance
Inst4Quest7 = "7. Амулет Пламени дракона" -- 6502
Inst4Quest7_Level = "60"
Inst4Quest7_Attain = "50"
Inst4Quest7_Aim = "Добудьте кровь могучего черного дракона генерала Драккисата, которого можно найти сидящим на троне в залах Вознесения в Пике Черной горы."
Inst4Quest7_Location = "Хале (Зимние Ключи; "..YELLOW.."54,51"..WHITE..")"
Inst4Quest7_Note = "Последний из цепочки заданий на доступ к Логову Ониксии для Альянса\nГенерал Драккисат "..YELLOW.."[8]"..WHITE.."."
Inst4Quest7_Prequest = "Око дракона" -- 6501
Inst4Quest7_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 8 Alliance
Inst4Quest8 = "8. Последние приготовления" -- 8994
Inst4Quest8_Level = "60"
Inst4Quest8_Attain = "58"
Inst4Quest8_Aim = "Соберите 40 наручей Черной горы и разыщите склянку великой силы. Отнесите все это Бодли в Черную Скалу."
Inst4Quest8_Location = "Бодли (Черная гора; "..YELLOW.."[D] на карте входа"..WHITE..")"
Inst4Quest8_Note = "Чтобы увидеть Бодли нужен Спектральный сканер иных измерений. Вы получите его за задание 'В поисках Антиона'. Боевые наручи Черной горы добываются с противников, у которых написано Чернорук в имени. Настой великой силы создается алхимиками."
Inst4Quest8_Prequest = "Правая часть амулета Лорда Вальтхалака ("..YELLOW.."Вершина Черной горы"..WHITE..")" -- 8989
Inst4Quest8_Folgequest = "Моя вина, Лорд Вальтхалак" -- 8995
Inst4Quest8PreQuest = "true"
-- No Rewards for this quest

--Quest 9 Alliance
Inst4Quest9 = "10. Моя вина, Лорд Вальтхалак" -- 8995
Inst4Quest9_Level = "60"
Inst4Quest9_Attain = "58"
Inst4Quest9_Aim = "Вызвать Лорда Вальтхалака с помощью жаровни Призыва. Убить его и использовать амулет. Потом вернуть амулет духу Вальтхалака."
Inst4Quest9_Location = "Бодли (Черная гора; "..YELLOW.."[D] на карте входа"..WHITE..")"
Inst4Quest9_Note = "Чтобы увидеть Бодли нужен Спектральный сканер иных измерений. Вы получите его за задание 'В поисках Антиона'. Лорд Вальтхалак вызывается около "..YELLOW.."[8]"..WHITE..". Награды перечислены для 'Возвращение к Бодли'."
Inst4Quest9_Prequest = "Последние приготовления" -- 8994
Inst4Quest9_Folgequest = "Возвращение к Бодли" -- 8996
Inst4Quest9FQuest = "true"
--
Inst4Quest9name1 = "Жаровня Вызова"
Inst4Quest9name2 = "Жаровня Вызова: инструкция пользователя"

--Quest 10 Alliance
Inst4Quest10 = "11. Демонова кузня" -- 5127
Inst4Quest10_Level = "60"
Inst4Quest10_Attain = "55"
Inst4Quest10_Aim = "Отправляйтесь на пик Черной горы и найдите Горалука Треснувшую Наковальню. Убейте его, а потом воткните в труп окровавленную пику. Таким образом пика вытянет его душу и окрасится ей. Кроме того, вам нужно найти заготовку рунической кирасы. Отнесите пику и кирасу Лораксу в Зимних Ключах."
Inst4Quest10_Location = "Лоракс (Зимние Ключи; "..YELLOW.."64,74"..WHITE..")"
Inst4Quest10_Note = "Задание для кузнецов. Горалук Треснувшая Наковальня около "..YELLOW.."[5]"..WHITE.."."
Inst4Quest10_Prequest = "Нет"
Inst4Quest10_Folgequest = "Нет"
--
Inst4Quest10name1 = "Чертеж: выкованная демоном кираса"
Inst4Quest10name2 = "Эликсир истребления демонов"
Inst4Quest10name3 = "Сумка Поцелуя демона"

--Quest 11 Alliance
Inst4Quest11 = "11. Сбор яиц"
Inst4Quest11_Level = "60"
Inst4Quest11_Attain = "57"
Inst4Quest11_Aim = "Принесите 8 драконьих яиц и устройство-коллекционер Тинки Кипеллер в Пламенеющий Стяг в Пылающих степях."
Inst4Quest11_Location = "Тинки Кипеллер(Пылающие степи - Flame Crest; "..YELLOW.."65,24"..WHITE..")"
Inst4Quest11_Note = "Вы найдете яйца в комнате Отца Пламени "..YELLOW.."[2]"..WHITE.."."
Inst4Quest11_Prequest = "Заморозка яйца"
Inst4Quest11_Folgequest = "Леонид Барталомей Чтимый  -> Рассветный гамбит ("..YELLOW.."Некроситет"..WHITE..")"
Inst4Quest11PreQuest = "true"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst4Quest1_HORDE = Inst4Quest1
Inst4Quest1_HORDE_Level = Inst4Quest1_Level
Inst4Quest1_HORDE_Attain = Inst4Quest1_Attain
Inst4Quest1_HORDE_Aim = Inst4Quest1_Aim
Inst4Quest1_HORDE_Location = Inst4Quest1_Location
Inst4Quest1_HORDE_Note = Inst4Quest1_Note
Inst4Quest1_HORDE_Prequest = Inst4Quest1_Prequest
Inst4Quest1_HORDE_Folgequest = Inst4Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst4Quest2_HORDE = Inst4Quest2
Inst4Quest2_HORDE_Level = Inst4Quest2_Level
Inst4Quest2_HORDE_Attain = Inst4Quest2_Attain
Inst4Quest2_HORDE_Aim = Inst4Quest2_Aim
Inst4Quest2_HORDE_Location = Inst4Quest2_Location
Inst4Quest2_HORDE_Note = Inst4Quest2_Note
Inst4Quest2_HORDE_Prequest = Inst4Quest2_Prequest
Inst4Quest2_HORDE_Folgequest = Inst4Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst4Quest3_HORDE = Inst4Quest3
Inst4Quest3_HORDE_Level = Inst4Quest3_Level
Inst4Quest3_HORDE_Attain = Inst4Quest3_Attain
Inst4Quest3_HORDE_Aim = Inst4Quest3_Aim
Inst4Quest3_HORDE_Location = Inst4Quest3_Location
Inst4Quest3_HORDE_Note = Inst4Quest3_Note
Inst4Quest3_HORDE_Prequest = Inst4Quest3_Prequest
Inst4Quest3_HORDE_Folgequest = Inst4Quest3_Folgequest
Inst4Quest3PreQuest_HORDE = Inst4Quest3PreQuest
--
Inst4Quest3name1_HORDE = Inst4Quest3name1

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst4Quest4_HORDE = Inst4Quest4
Inst4Quest4_HORDE_Level = Inst4Quest4_Level
Inst4Quest4_HORDE_Attain = Inst4Quest4_Attain
Inst4Quest4_HORDE_Aim = Inst4Quest4_Aim
Inst4Quest4_HORDE_Location = Inst4Quest4_Location
Inst4Quest4_HORDE_Note = Inst4Quest4_Note
Inst4Quest4_HORDE_Prequest = Inst4Quest4_Prequest
Inst4Quest4_HORDE_Folgequest = Inst4Quest4_Folgequest
Inst4Quest4PreQuest_HORDE = Inst4Quest4PreQuest
-- No Rewards for this quest

--Quest 5 Horde
Inst4Quest5_HORDE = "5. Табличка Темнокамня" -- 4768
Inst4Quest5_HORDE_Level = "60"
Inst4Quest5_HORDE_Attain = "57"
Inst4Quest5_HORDE_Aim = "Принесите табличку Темного Камня тенемагу Вивиан Лягроб в Каргат."
Inst4Quest5_HORDE_Location = "Темный маг Вивиана Лягроб (Бесплодные земли - Каргат; "..YELLOW.."2,47"..WHITE..")"
Inst4Quest5_HORDE_Note = "Вы получите предшествующее задание у аптекаря Зинга в Подгороде - Район Фармацевтов ("..YELLOW.."50,68"..WHITE..").\n\nThe Табличка Темнокамня находится около "..YELLOW.."[2]"..WHITE.." в сундуке."
Inst4Quest5_HORDE_Prequest = "Вивиан Лягроб и табличка Темнокамня" -- 4769
Inst4Quest5_HORDE_Folgequest = "Нет"
Inst4Quest5PreQuest_HORDE = "true"
--
Inst4Quest5name1_HORDE = "Быстроступные ботфорты"
Inst4Quest5name2_HORDE = "Боевые наручи мгновенного удара"

--Quest 6 Horde
Inst4Quest6_HORDE = "6. За Орду!" -- 4974
Inst4Quest6_HORDE_Level = "60"
Inst4Quest6_HORDE_Attain = "55"
Inst4Quest6_HORDE_Aim = "Отправляйтесь в Пик Черной горы и убейте вождя Ренда Чернорука. Принесите его голову в Оргриммар."
Inst4Quest6_HORDE_Location = "Тралл (Оргриммар; "..YELLOW.."31,38"..WHITE..")"
Inst4Quest6_HORDE_Note = "Задание для подготовки к Ониксии. Вы найдете вождя Ренда Чернорука около "..YELLOW.."[5]"..WHITE.."."
Inst4Quest6_HORDE_Prequest = "Приказ полководца -> Мудрость Эйтригга" -- 4903 -> 4941
Inst4Quest6_HORDE_Folgequest = "Что принес ветер" -- 6566
Inst4Quest6PreQuest_HORDE = "true"
--
Inst4Quest6name1_HORDE = "Знак Тирании"
Inst4Quest6name2_HORDE = "Глаз Зверя"
Inst4Quest6name3_HORDE = "Пластита Чернорука"

--Quest 7 Horde
Inst4Quest7_HORDE = "7. Иллюзии ока" -- 6569
Inst4Quest7_HORDE_Level = "60"
Inst4Quest7_HORDE_Attain = "55"
Inst4Quest7_HORDE_Aim = "Отправляйтесь на пик Черной горы и добудьте 20 глаз черных драконидов. По выполнении задания вернитесь к Миранде Колдунье."
Inst4Quest7_HORDE_Location = "Миранда Колдунья (Западные Чумные земли; "..YELLOW.."50,77"..WHITE..")"
Inst4Quest7_HORDE_Note = "Глаза падают с драконидов."
Inst4Quest7_HORDE_Prequest = "Что принес ветер -> Мастерица обмана" -- 6566 -> 6568
Inst4Quest7_HORDE_Folgequest = "Огнебор" -- 6570
Inst4Quest7FQuest_HORDE = "true"
-- No Rewards for this quest

--Quest 8 Horde
Inst4Quest8_HORDE = "8. Кровь могучего черного дракона" -- 6602
Inst4Quest8_HORDE_Level = "60"
Inst4Quest8_HORDE_Attain = "55"
Inst4Quest8_HORDE_Aim = "Отправляйтесь к пику Черной горы и убейте генерала Драккисата. Соберите его кровь и вернитесь к Рексару."
Inst4Quest8_HORDE_Location = "Рексар (Пустоши - Деревня Ночных охотников; "..YELLOW.."25,71"..WHITE..")"
Inst4Quest8_HORDE_Note = "Последняя часть на пути к Ониксии. Вы найдете генерала Драккисата около "..YELLOW.."[8]"..WHITE.."."
Inst4Quest8_HORDE_Prequest = "Огнебор -> Вознесение" -- 6570 -> 6601
Inst4Quest8_HORDE_Folgequest = "Нет"
Inst4Quest8FQuest_HORDE = "true"
--
Inst4Quest8name1_HORDE = "Амулет Пламени дракона"

--Quest 9 Horde  (same as Quest 7 Alliance)
Inst4Quest9_HORDE = "9. Приказ Чернорука"
Inst4Quest9_HORDE_Level = Inst4Quest7_Level
Inst4Quest9_HORDE_Attain = Inst4Quest7_Attain
Inst4Quest9_HORDE_Aim = Inst4Quest7_Aim
Inst4Quest9_HORDE_Location = Inst4Quest7_Location
Inst4Quest9_HORDE_Note = Inst4Quest7_Note
Inst4Quest9_HORDE_Prequest = Inst4Quest7_Prequest
Inst4Quest9_HORDE_Folgequest = Inst4Quest7_Folgequest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 8 Alliance)
Inst4Quest10_HORDE = "10. Последние приготовления"
Inst4Quest10_HORDE_Level = Inst4Quest8_Level
Inst4Quest10_HORDE_Attain = Inst4Quest8_Attain
Inst4Quest10_HORDE_Aim = Inst4Quest8_Aim
Inst4Quest10_HORDE_Location = Inst4Quest8_Location
Inst4Quest10_HORDE_Note = Inst4Quest8_Note
Inst4Quest10_HORDE_Prequest = Inst4Quest8_Prequest
Inst4Quest10_HORDE_Folgequest = Inst4Quest8_Folgequest
-- No Rewards for this quest

--Quest 11 Horde  (same as Quest 9 Alliance)
Inst4Quest11_HORDE = "11. Моя вина, Лорд Вальтхалак"
Inst4Quest11_HORDE_Level = Inst4Quest9_Level
Inst4Quest11_HORDE_Attain = Inst4Quest9_Attain
Inst4Quest11_HORDE_Aim = Inst4Quest9_Aim
Inst4Quest11_HORDE_Location = Inst4Quest9_Location
Inst4Quest11_HORDE_Note = Inst4Quest9_Note
Inst4Quest11_HORDE_Prequest = Inst4Quest9_Prequest
Inst4Quest11_HORDE_Folgequest = Inst4Quest9_Folgequest
--
Inst4Quest11name1_HORDE = Inst4Quest9name1
Inst4Quest11name2_HORDE = Inst4Quest9name2

--Quest 12 Horde  (same as Quest 10 Alliance)
Inst4Quest12_HORDE = "12. Демонова кузня"
Inst4Quest12_HORDE_Level = Inst4Quest10_Level
Inst4Quest12_HORDE_Attain = Inst4Quest10_Attain
Inst4Quest12_HORDE_Aim = Inst4Quest10_Aim
Inst4Quest12_HORDE_Location = Inst4Quest10_Location
Inst4Quest12_HORDE_Note = Inst4Quest10_Note
Inst4Quest12_HORDE_Prequest = Inst4Quest10_Prequest
Inst4Quest12_HORDE_Folgequest = Inst4Quest10_Folgequest
--
Inst4Quest12name1_HORDE = Inst4Quest10name1
Inst4Quest12name2_HORDE = Inst4Quest10name2
Inst4Quest12name3_HORDE = Inst4Quest10name3

--Quest 13 Horde  (same as Quest 11 Alliance)
Inst4Quest13_HORDE = "13. Сбор яиц"
Inst4Quest13_HORDE_Level = Inst4Quest11_Level
Inst4Quest13_HORDE_Attain = Inst4Quest11_Attain
Inst4Quest13_HORDE_Aim = Inst4Quest11_Aim
Inst4Quest13_HORDE_Location = Inst4Quest11_Location
Inst4Quest13_HORDE_Note = Inst4Quest11_Note
Inst4Quest13_HORDE_Prequest = Inst4Quest11_Prequest
Inst4Quest13_HORDE_Folgequest = Inst4Quest11_Folgequest
Inst4Quest13PreQuest_HORDE = Inst4Quest11PreQuest
-- No Rewards for this quest



--------------- INST5 - Deadmines ---------------

Inst5Caption = "Мертвые копи"
Inst5QAA = "7 заданий" 
Inst5QAH = "Нет заданий" 

--Quest 1 Alliance
Inst5Quest1 = "1. Красные шелковые банданы" -- 214
Inst5Quest1_Level = "17"
Inst5Quest1_Attain = "14"
Inst5Quest1_Aim = "Принесите 10 красных шелковых бандан разведчице Риэле к башне на Сторожевом холме."
Inst5Quest1_Location = "Разведчица Риэла (Западный Край - Сторожевой холм; "..YELLOW.."56, 47"..WHITE..")"
Inst5Quest1_Note = "Вы можете получить красные шелковые банданы с шахтеров в Мертвых копях или в городе, где находится подземелье. Задание становится доступным после выполнения цепочки заданий Братства Справедливости до стадии когда вам нужно убить Эдвина Ван Клифа."
Inst5Quest1_Prequest = "Братство Справедливости (id = 155)" -- 155
Inst5Quest1_Folgequest = "Нет"
Inst5Quest1PreQuest = "true"
--
Inst5Quest1name1 = "Твердый клинок"
Inst5Quest1name2 = "Резной кинжал"
Inst5Quest1name3 = "Пронзающий топор"

--Quest 2 Alliance
Inst5Quest2 = "2. Сбор воспоминаний" -- 168
Inst5Quest2_Level = "18"
Inst5Quest2_Attain = "14"
Inst5Quest2_Aim = "Добудьте 4 карточки Союза шахтеров и верните их Вилдеру Крапивцу в Штормград."
Inst5Quest2_Location = "Чертополох Дикий (Штормград - Квартал дворфов; "..YELLOW.."65, 21"..WHITE.." )"
Inst5Quest2_Note = "Карточки падают с нежити снаружи подземелья в зоне около "..YELLOW.."[3]"..WHITE.." на карте входа."
Inst5Quest2_Prequest = "Нет"
Inst5Quest2_Folgequest = "Нет"
--
Inst5Quest2name1 = "Сапоги проходчика"
Inst5Quest2name2 = "Пыльные шахтерские перчатки"

--Quest 3 Alliance
Inst5Quest3 = "3. О, брат мой..." -- 167
Inst5Quest3_Level = "20"
Inst5Quest3_Attain = "15"
Inst5Quest3_Aim = "Принесите значок Лиги Исследователей, принадлежавший Вилдеру Крапивцу, в Штормград."
Inst5Quest3_Location = "Вилдер Крапивец (Штормград - Квартал дворфов; "..YELLOW.."65,21"..WHITE.." )"
Inst5Quest3_Note = "Вилдер Крапивец находится снаружи подземелья"
Inst5Quest3_Prequest = "Нет"
Inst5Quest3_Folgequest = "Нет"
--
Inst5Quest3name1 = "Месть горняка"

--Quest 4 Alliance
Inst5Quest4 = "4. Битва под землей" -- 2040
Inst5Quest4_Level = "20"
Inst5Quest4_Attain = "15"
Inst5Quest4_Aim = "Принесите Шони Молшунье в Штормград зубчатый спрек-механизм гномов из Мертвых копей."
Inst5Quest4_Location = "Шони Молшунья (Штормград - Квартал дворфов; "..YELLOW.."55,12"..WHITE.." )"
Inst5Quest4_Note = "Предшествующее задание можно взять у Гноарна (Стальгорн - Город механиков; "..YELLOW.."69,50"..WHITE..").\nЗубчатый спрек-механизм гномов добывается с Крошшера Снида "..YELLOW.."[3]"..WHITE.."."
Inst5Quest4_Prequest = "Разговор с Шони" -- 2041
Inst5Quest4_Folgequest = "Нет"
Inst5Quest4PreQuest = "true"
--
Inst5Quest4name1 = "Снежные рукавицы"
Inst5Quest4name2 = "Соболий жезл"

--Quest 5 Alliance
Inst5Quest5 = "5. Братство Справедливости" -- 166
Inst5Quest5_Level = "22"
Inst5Quest5_Attain = "14"
Inst5Quest5_Aim = "Убейте Эдвина ван Клифа и принесите его голову Гриану Камнегриву."
Inst5Quest5_Location = "Гриан Камнегрив (Западный край - Сторожевой холм; "..YELLOW.."56,47"..WHITE..")"
Inst5Quest5_Note = "Вы начинаете линейку у Гриана Камнегрива (Западный Край - Сторожевой холм; "..YELLOW.."56,47"..WHITE..").\nЭдвин Ван Клиф это последний босс в Мертвых копях. Вы найдете его на верхней палубе корабля "..YELLOW.."[6]"..WHITE.."."
Inst5Quest5_Prequest = "Братство справедливости" -- 155
Inst5Quest5_Folgequest = "Нет"
Inst5Quest5PreQuest = "true"
--
Inst5Quest5name1 = "Шоссы Западного Края"
Inst5Quest5name2 = "Мундир Западного Края"
Inst5Quest5name3 = "Посох Западного Края"

--Quest 6 Alliance
Inst5Quest6 = "6. Испытание доблести" -- 1654
Inst5Quest6_Level = "22"
Inst5Quest6_Attain = "20"
Inst5Quest6_Aim = "Возьмите список Джордана, добудьте немного древесины белокаменного дуба, партию очищенной руды Бэйлора, кузнечный молот Джордана и самоцвет Кора и отдайте их Джордану Стилвеллу в Стальгорне."
Inst5Quest6_Location = "Джордан Стилвелл (Дун Морог - Вход в Стальгорн; "..YELLOW.."52,36"..WHITE..")"
Inst5Quest6_Note = "Задание для паладинов: Чтобы увидеть заметки щелкните на "..YELLOW.."[Информация: Испытание доблести]"..WHITE.."."
Inst5Quest6_Page = {2, "Только паладины могут получить это задание!\n1. Вы получите древесину белокаменного дуба у гоблинов-лесорубов в "..YELLOW.."[Мертвые копи]"..WHITE..".\n2. Для получения партии очищенной руды Бэйлора вы должны поговорить с Бэйлором Каменной Дланью (Озеро Модан - Телсамар; 35,44 ). Он даст вам задание 'Партия руды Бэйлора'. Вы найдете руду Джордана за деревом около 71,21\n3. Вы получите кузнечный молот Джордана в "..YELLOW.."[Крепость Темного Клыка]"..WHITE.." около "..YELLOW.."[3]"..WHITE..".\n4. Для получения самоцвета Кора Вам нужно пойти к Тандрису Ветропряду (Темные берега - Аубердин; 37,40) и выполнить задание 'Поиск самоцвета Кора'. Для этого задания, вам нужно убивать Провидзев и Жриц Непроглядной пучины перед "..YELLOW.."[Непроглядная пучина]"..WHITE..". С них добывается Оскверненный самоцвет Кора. Тандрис Ветропряд очистит его для Вас.", };
Inst5Quest6_Prequest = "Фолиант Отваги -> Испытание доблести" -- 1651 -> 1653
Inst5Quest6_Folgequest = "Испытание доблести" -- 1806
Inst5Quest6PreQuest = "true"
--
Inst5Quest6name1 = "Боевая перчатка Веригана"

--Quest 7 Alliance
Inst5Quest7 = "7. Неотправленное письмо" -- 373
Inst5Quest7_Level = "22"
Inst5Quest7_Attain = "16"
Inst5Quest7_Aim = "Доставьте письмо городскому архитектору Баросу Алекстону в Штормград."
Inst5Quest7_Location = "Неотосланное письмо (добывается с Эдвин ван Клиф; "..YELLOW.."[6]"..WHITE..")"
Inst5Quest7_Note = "Барос Алекстон находится в Штормград, рядом с Соборной площадью около "..YELLOW.."49,30"..WHITE.."."
Inst5Quest7_Prequest = "Нет"
Inst5Quest7_Folgequest = "Базиль Тредд" -- 389
-- No Rewards for this quest



--------------- INST6 - Gnomeregan ---------------

Inst6Caption = "Гномреган"
Inst6QAA = "11 заданий"
Inst6QAH = "6 заданий"

--Quest 1 Alliance
Inst6Quest1 = "1. Промыть мозг Техботу" -- 2922
Inst6Quest1_Level = "26"
Inst6Quest1_Attain = "20"
Inst6Quest1_Aim = "Принесите ядро памяти Техбота мехмастеру Замыкальцу в Стальгорн."
Inst6Quest1_Location = "Мехмастер Замыкалец (Стальгорн - Город механиков; "..YELLOW.."69,50"..WHITE..")"
Inst6Quest1_Note = "Вы возьмете предшествующее задание у брата Сарно (Штормград - Соборная площадь; "..YELLOW.."40, 30"..WHITE..").\nВы найдете Техбота перед входом в подземелье около черного входа."
Inst6Quest1_Prequest = "Мехмастер Замыкалец" -- 2923
Inst6Quest1_Folgequest = "Нет"
Inst6Quest1PreQuest = "true"
-- No Rewards for this quest

--Quest 2 Alliance
Inst6Quest2 = "2. Новая формула" -- 2926
Inst6Quest2_Level = "27"
Inst6Quest2_Attain = "20"
Inst6Quest2_Aim = "Соберите радиоактивный осадок, оставляемый облученными захватчиками и облученными погромщиками в пустую освинцованную склянку для проб. Принесите наполненную склянку Оззи Триггервольту в Каранос."
Inst6Quest2_Location = "Оззи Триггервольт (Дун Морог - Каранос; "..YELLOW.."45,49"..WHITE..")"
Inst6Quest2_Note = "Вы возьмете предшествующее задание у Гноарна (Стальгорн - Город механиков; "..YELLOW.."69,50"..WHITE..").\nЧтобы собрать осадок используйте фиал на "..RED.."живых"..WHITE.." Облученный захватчиках или Облученных погромщиках."
Inst6Quest2_Prequest = "На другой день" -- 2927
Inst6Quest2_Folgequest = "Сильное зеленое свечение" -- 2962
Inst6Quest2PreQuest = "true"
-- No Rewards for this quest

--Quest 3 Alliance
Inst6Quest3 = "3. Сильное зеленое свечение" -- 2962
Inst6Quest3_Level = "30"
Inst6Quest3_Attain = "20"
Inst6Quest3_Aim = "Отправляйтесь в Гномреган и принесите высокорадиоактивные образцы. Внимание: отходы нестабильны и довольно быстро разрушаются.\nВерните Оззи тяжелую освинцованную склянку для проб, когда задача будет выполнена."
Inst6Quest3_Location = "Оззи Триггервольт (Дун Морог - Каранос; "..YELLOW.."45,49"..WHITE..")"
Inst6Quest3_Note = "Чтобы собрать образцы используйте фиал на "..RED.."живых"..WHITE.." Облученных слизях или ужасах."
Inst6Quest3_Prequest = "Новая формула" -- 2926
Inst6Quest3_Folgequest = "Нет"
Inst6Quest3FQuest = "true"
-- No Rewards for this quest

--Quest 4 Alliance
Inst6Quest4 = "4. Сооружение автогиробуророек" -- 2928
Inst6Quest4_Level = "30"
Inst6Quest4_Attain = "20"
Inst6Quest4_Aim = "Принесите Шони в Штормград 24 горсти механических внутренностей роботов."
Inst6Quest4_Location = "Шони Молшунья (Штормград - Квартал дворфов; "..YELLOW.."55, 12"..WHITE..")"
Inst6Quest4_Note = "Внутренности падают со всех роботов."
Inst6Quest4_Prequest = "Нет"
Inst6Quest4_Folgequest = "Нет"
--
Inst6Quest4name1 = "Обезоруживающий инструмент Шони"
Inst6Quest4name2 = "Полуперчатки Нерешительности"

--Quest 5 Alliance
Inst6Quest5 = "5. Базовый элемент" -- 2924
Inst6Quest5_Level = "30"
Inst6Quest5_Attain = "24"
Inst6Quest5_Aim = "Принесите 12 базовых элементов Клацморту Гайкокруту в Стальгорн."
Inst6Quest5_Location = "Клацморт Гайкокрут (Стальгорн - Город механиков; "..YELLOW.."68,46"..WHITE..")"
Inst6Quest5_Note = "Вы возьмете предшествующее задание у Матиля (Дарнасс - Терраса Воинов; "..YELLOW.."59,45"..WHITE.."). Предшествующее задание только указывает на задание и необязательно, чтобы взять это.\nБазовые элементы собираются со всех машин, разбросанных по подземелью."
Inst6Quest5_Prequest = "Базовые элементы Клацморта" -- 2925
Inst6Quest5_Folgequest = "Нет"
Inst6Quest5PreQuest = "true"
-- No Rewards for this quest

--Quest 6 Alliance
Inst6Quest6 = "6. Спасение данных" -- 2930
Inst6Quest6_Level = "30"
Inst6Quest6_Attain = "25"
Inst6Quest6_Aim = "Принесите радужную перфокарту главному механику Чугунотрубзу в Стальгорн."
Inst6Quest6_Location = "Главный механик Чугонотрубз (Стальгорн - Город механиков; "..YELLOW.."69,48"..WHITE..")"
Inst6Quest6_Note = "Вы получите предшествующее задание у Гаксима Ржавошиппи (Когтистые горы; "..YELLOW.."59,67"..WHITE.."). Предшествующее задание только указывает на задание и необязательно, чтобы взять это.\nПустая карта добывается случайно. Вы найдете первый терминал около черного входа, перед входом в подземелье. 3005-B находится около "..YELLOW.."[3]"..WHITE..", 3005-C около "..YELLOW.."[5]"..WHITE.." и 3005-D находится около "..YELLOW.."[8]"..WHITE.."."
Inst6Quest6_Prequest = "Поручение Чугонотрубза" -- 2931
Inst6Quest6_Folgequest = "Нет"
Inst6Quest6PreQuest = "true"
--
Inst6Quest6name1 = "Накидка ремонтника"
Inst6Quest6name2 = "Трубомолот махника"

--Quest 7 Alliance
Inst6Quest7 = "7. Катавасия" -- 2904
Inst6Quest7_Level = "30"
Inst6Quest7_Attain = "24"
Inst6Quest7_Aim = "Отведите Керноби к Часовому ходу. Затем отправляйтесь с донесением к Скути в Пиратскую бухту."
Inst6Quest7_Location = "Керноби (Гномреган; "..YELLOW.."[3]"..WHITE..")"
Inst6Quest7_Note = "Задание сопровождения! Вы найдете Скути в Тернистой долине - Пиратская бухта ("..YELLOW.."27,77"..WHITE..")."
Inst6Quest7_Prequest = "Нет"
Inst6Quest7_Folgequest = "Нет"
--
Inst6Quest7name1 = "Огнесварные наручи"
Inst6Quest7name2 = "Волшебнокрылое оплечье"

--Quest 8 Alliance
Inst6Quest8 = "8. Великое предательство" -- 2929
Inst6Quest8_Level = "35"
Inst6Quest8_Attain = "25"
Inst6Quest8_Aim = "Отправляйтесь в Гномреган и убейте Анжинера Термоштепселя. Вернитесь к главному механику Меггакруту."
Inst6Quest8_Location = "Главный Механик Меггакрут (Стальгорн - Город механиков; "..YELLOW.."68,48"..WHITE..")"
Inst6Quest8_Note = "Вы найдете Термоштепселя около "..YELLOW.."[6]"..WHITE..". Он - последний босс в Гномрегане.\nВо время боя вы должны обезвредить колонны нажатием кнопок на боковой поверхности."
Inst6Quest8_Prequest = "Нет"
Inst6Quest8_Folgequest = "Нет"
--
Inst6Quest8name1 = "Одеяния Сивинада"
Inst6Quest8name2 = "Шаровары бегуна"
Inst6Quest8name3 = "Двойные усиленные поножи"

--Quest 9 Alliance
Inst6Quest9 = "9. Кольцо, покрытое грязью" -- 2945
Inst6Quest9_Level = "34"
Inst6Quest9_Attain = "28"
Inst6Quest9_Aim = "Придумайте, как отчистить кольцо, покрытое грязью."
Inst6Quest9_Location = "Покрытое грязью кольцо (случайная добыча в Гномрегане)"
Inst6Quest9_Note = "Кольцо может быть очищено в Чистере 5200 около "..YELLOW.."[2]"..WHITE.."."
Inst6Quest9_Prequest = "Нет"
Inst6Quest9_Folgequest = "Возвращение кольца" -- 2947
-- No Rewards for this quest

--Quest 10 Alliance
Inst6Quest10 = "10. Возвращение кольца" -- 2947
Inst6Quest10_Level = "34"
Inst6Quest10_Attain = "28"
Inst6Quest10_Aim = "Вы можеть оставить кольцо себе, а можете попытаться найти того, чьи инициалы выгравированы на внутренней стороне кольца."
Inst6Quest10_Location = "Сверкающее золотое кольцо (награда за задание 'Кольцо, покрытое грязью')"
Inst6Quest10_Note = "Отнесите Талвашу дель Кисселью (Стальгорн - Палаты Магии; "..YELLOW.."36,3"..WHITE.."). Усиление кольца не является обязательным."
Inst6Quest10_Prequest = "Кольцо, покрытое грязью" -- 2945
Inst6Quest10_Folgequest = "Гномское усовершенствование" -- 2948
Inst6Quest10FQuest = "true"
--
Inst6Quest10name1 = "Сверкающее золотое кольцо"

--Quest 11 Alliance
Inst6Quest11 = "11. Чистер 5200!"
Inst6Quest11_Level = "30"
Inst6Quest11_Attain = "25"
Inst6Quest11_Aim = "Опустите покрытый грязью предмет и три серебряные монеты в Чистер 5200"
Inst6Quest11_Location = "Чистер 5200 (Гномеранг - Чистая комната "..YELLOW.."[2]"..WHITE..")"
Inst6Quest11_Note = "Вы можете повторить этот квест для всех предметов, инкрустированных грязью."
Inst6Quest11_Prequest = "Нет"
Inst6Quest11_Folgequest = "Нет"
--
Inst6Quest11name1 = "Коробка, упакованная Чистером"


--Quest 1 Horde
Inst6Quest1_HORDE = "1. Поехалиии!" -- 2843
Inst6Quest1_HORDE_Level = "35"
Inst6Quest1_HORDE_Attain = "20"
Inst6Quest1_HORDE_Aim = "Дождитесь, пока Скути настроит гоблинский импульсный повторитель."
Inst6Quest1_HORDE_Location = "Скути (Тернистая долина - Пиратская бухта; "..YELLOW.."27,77"..WHITE..")"
Inst6Quest1_HORDE_Note = "Вы получите предшествующее задание у Совика (Оргриммар - Аллея Чести; "..YELLOW.."75,25"..WHITE..").\nПосле выполнения этого задания вы сможете использовать телепортатор в Пиратской бухте."
Inst6Quest1_HORDE_Prequest = "Главный инженер Скути" -- 2842
Inst6Quest1_HORDE_Folgequest = "Нет"
Inst6Quest1PreQuest_HORDE = "true"
--
Inst6Quest1name1_HORDE = "Гоблинский импульсный повторитель"

--Quest 2 Horde  (same as Quest 7 Alliance)
Inst6Quest2_HORDE = "2. Катавасия"
Inst6Quest2_HORDE_Level = Inst6Quest7_Level
Inst6Quest2_HORDE_Attain = Inst6Quest7_Attain
Inst6Quest2_HORDE_Aim = Inst6Quest7_Aim
Inst6Quest2_HORDE_Location = Inst6Quest7_Location
Inst6Quest2_HORDE_Note = Inst6Quest7_Note
Inst6Quest2_HORDE_Prequest = Inst6Quest7_Prequest
Inst6Quest2_HORDE_Folgequest = Inst6Quest7_Folgequest
--
Inst6Quest2name1_HORDE = Inst6Quest7name1
Inst6Quest2name2_HORDE = Inst6Quest7name2

--Quest 3 Horde
Inst6Quest3_HORDE = "3. Техновойны" -- 2841
Inst6Quest3_HORDE_Level = "35"
Inst6Quest3_HORDE_Attain = "25"
Inst6Quest3_HORDE_Aim = "Добудьте в Гномрегане чертежи боевой машины и код от сейфа Термоштепселя в Гномрегане и принесите их Ноггу в Оргриммар."
Inst6Quest3_HORDE_Location = "Ногг (Оргриммар - Аллея Чести; "..YELLOW.."75,25"..WHITE..")"
Inst6Quest3_HORDE_Note = "Вы найдете Термоштепселя около "..YELLOW.."[6]"..WHITE..". Он - последний босс в Гномрегане.\nВо время боя вы должны обезвредить колонны нажатием кнопок на боковой поверхности."
Inst6Quest3_HORDE_Prequest = "Нет"
Inst6Quest3_HORDE_Folgequest = "Нет"
--
Inst6Quest3name1_HORDE = "Одеяния Сивинада"
Inst6Quest3name2_HORDE = "Шаровары бегуна"
Inst6Quest3name3_HORDE = "Двойные усиленные поножи"

--Quest 4 Horde  (same as Quest 9 Alliance)
Inst6Quest4_HORDE = "4. Кольцо, покрытое грязью"
Inst6Quest4_HORDE_Level = Inst6Quest9_Level
Inst6Quest4_HORDE_Attain = Inst6Quest9_Attain
Inst6Quest4_HORDE_Aim = Inst6Quest9_Aim
Inst6Quest4_HORDE_Location = Inst6Quest9_Location
Inst6Quest4_HORDE_Note = Inst6Quest9_Note
Inst6Quest4_HORDE_Prequest = Inst6Quest9_Prequest
Inst6Quest4_HORDE_Folgequest = Inst6Quest9_Folgequest
-- No Rewards for this quest

--Quest 5 Horde
Inst6Quest5_HORDE = "5. Возвращение кольца" -- 2949
Inst6Quest5_HORDE_Level = Inst6Quest10_Level
Inst6Quest5_HORDE_Attain = Inst6Quest10_Attain
Inst6Quest5_HORDE_Aim = Inst6Quest10_Aim
Inst6Quest5_HORDE_Location = Inst6Quest10_Location
Inst6Quest5_HORDE_Note = "Отнесите Ноггу (Оргриммар - Аллея Чести; "..YELLOW.."75,25"..WHITE.."). Усиление кольца не является обязательным."
Inst6Quest5_HORDE_Prequest = Inst6Quest10_Prequest
Inst6Quest5_HORDE_Folgequest = "Переделка кольца" -- 2950
Inst6Quest5FQuest_HORDE = "true"
--
Inst6Quest5name1_HORDE = "Сверкающее золотое кольцо"

--Quest 6 Horde
Inst6Quest6_HORDE = "4. Кольцо, покрытое грязью"
Inst6Quest6_HORDE_Level = Inst6Quest11_Level
Inst6Quest6_HORDE_Attain = Inst6Quest11_Attain
Inst6Quest6_HORDE_Aim = Inst6Quest11_Aim
Inst6Quest6_HORDE_Location = Inst6Quest11_Location
Inst6Quest6_HORDE_Note = Inst6Quest11_Note
Inst6Quest6_HORDE_Prequest = Inst6Quest11_Prequest
Inst6Quest6_HORDE_Folgequest = Inst6Quest11_Folgequest
--
Inst6Quest6name1_HORDE = "Коробка, упакованная Чистером"



--------------- INST7 - Scarlet Monastery: Library ---------------

Inst7Caption = "МАО: Библиотека"
Inst7QAA = "3 задания"
Inst7QAH = "5 заданий"

--Quest 1 Alliance
Inst7Quest1 = "1. Мифология Титанов"
Inst7Quest1_Level = "38"
Inst7Quest1_Attain = "28"
Inst7Quest1_Aim = "Добудьте Мифологию Титанов из монастыря и принесите ее библиотекарю Мае Белокожке в Стальгорн."
Inst7Quest1_Location = "Библиотекарь Мае Белокожка (Стальгорн - Зал исследователей; "..YELLOW.."74,12"..WHITE..")"
Inst7Quest1_Note = "Книга лежит на полу на левой стороне коридоров, ведущих к Чародею Доану ("..YELLOW.."[2]"..WHITE..")."
Inst7Quest1_Prequest = "Нет"
Inst7Quest1_Folgequest = "Нет"
--
Inst7Quest1name1 = "Амулет Лиги Исследователей"

--Quest 2 Alliance
Inst7Quest2 = "2. Обряды силы (Маг)"
Inst7Quest2_Level = "40"
Inst7Quest2_Attain = "30"
Inst7Quest2_Aim = "Принесите книгу Обряды силы Табете в Пыльную трясину."
Inst7Quest2_Location = "Табета (Пылевые топи; "..YELLOW.."43,57"..WHITE..")"
Inst7Quest2_Note = "Задание для магов. Вы найдете книгу в последнем коридоре ведущему к чародею Доану ("..YELLOW.."[2]"..WHITE..").\n\nThe rewards listed are for the followup."
Inst7Quest2_Prequest = "Волшебное слово" --1950
Inst7Quest2_Folgequest = "Магический жезл" -- 1952
Inst7Quest2PreQuest = "true"
--
Inst7Quest2name1 = "Жезл Ледяной ярости"
Inst7Quest2name2 = "Жезл силы Пустоты"
Inst7Quest2name3 = "Жезл Бущующего пламени"

--Quest 3 Alliance
Inst7Quest3 = "3. Во имя Света!" -- 1053
Inst7Quest3_Level = "40"
Inst7Quest3_Attain = "34"
Inst7Quest3_Aim = "Убейте верховного инквизитора Вайтмейн, командира Могрейна из Алого ордена, воителя Ирода из Алого ордена и псаря Локси, после этого вернитесь с докладом к Ролею Благочестивому в Южнобережье."
Inst7Quest3_Location = "Ролей Благочестивый (Предгорья Хилсбрада - Южнобережье; "..YELLOW.."51,58"..WHITE..")"
Inst7Quest3_Note = "Вы найдете Верховного инквизитора Вайтмейн и Командира Могрейна из Алого ордена в "..YELLOW.."МАО: Собор [2]"..WHITE..", Герода в"..YELLOW.."МАО: Оружейная [1]"..WHITE.." и псаря Локси в "..YELLOW.."МАО: Библиотека [1]"..WHITE.."."
Inst7Quest3_Prequest = "Брат Антон -> Путями Алого ордена"
Inst7Quest3_Folgequest = "Нет"
Inst7Quest3PreQuest = "true"
--
Inst7Quest3name1 = "Меч безмятежности"
Inst7Quest3name2 = "Костекус"
Inst7Quest3name3 = "Черная угроза"
Inst7Quest3name4 = "Сфера Лорики"


--Quest 1 Horde
Inst7Quest1_HORDE = "1. Сердца Доблести" -- 1113
Inst7Quest1_HORDE_Level = "33"
Inst7Quest1_HORDE_Attain = "30"
Inst7Quest1_HORDE_Aim = "Опытный аптекарь Фаранелл из Подгорода просит принести ему 20 сердец Доблести."
Inst7Quest1_HORDE_Location = "Опытный аптекарь Фаранелл (Подгород - Район Фармацевтов; "..YELLOW.."48,69"..WHITE..")"
Inst7Quest1_HORDE_Note = "Сердца Доблести можно выбить со всех мобов в Алом Монастыре, включая людей вне подземелья."
Inst7Quest1_HORDE_Prequest = "Груды гуано ("..YELLOW.."[Лабиринты Иглошкурых]"..WHITE..")" -- 1109
Inst7Quest1_HORDE_Folgequest = "Нет"
Inst7Quest1PreQuest_HORDE = "true"
-- No Rewards for this quest

--Quest 2 Horde
Inst7Quest2_HORDE = "2. Испытание знаний" -- 1160
Inst7Quest2_HORDE_Level = "36"
Inst7Quest2_HORDE_Attain = "25"
Inst7Quest2_HORDE_Aim = "Найдите книгу Истоки угрозы нежити и отнесите ее Парквелу Финталласу в Подгород."
Inst7Quest2_HORDE_Location = "Парквел Финталлас (Подгород - Район Фармацевтов; "..YELLOW.."57,65"..WHITE..")"
Inst7Quest2_HORDE_Note = "Цепочка начинается у Дорна Вольного Ловчего (Тысяча Игл; "..YELLOW.."53,41"..WHITE.."). Вы можете найти книгу в Библиотеке Алого Монастыря."
Inst7Quest2_HORDE_Prequest = "Испытание веры -> Испытание знаний"
Inst7Quest2_HORDE_Folgequest = "Испытание знаний" -- 6628
Inst7Quest2PreQuest_HORDE = "true"
--
Inst7Quest2name1_HORDE = "Молот Буреветра"
Inst7Quest2name2_HORDE = "Танцующее пламя"

--Quest 3 Horde
Inst7Quest3_HORDE = "3. Компендиум павших"
Inst7Quest3_HORDE_Level = "38"
Inst7Quest3_HORDE_Attain = "28"
Inst7Quest3_HORDE_Aim = "Добудьте Компендиум павших из монастыря в Тирисфальских лесах и возвращайтесь к Ведуну Искателю Истины в Громовой Утес."
Inst7Quest3_HORDE_Location = "Ведун Искатель Истины (Громовой утес; "..YELLOW.."34,47"..WHITE..")"
Inst7Quest3_HORDE_Note = "Вы найдете книгу в библиотечной секции Алого Монастыря. ВНИМАНИЕ! Нежить не может взять это задание."
Inst7Quest3_HORDE_Prequest = "Нет"
Inst7Quest3_HORDE_Folgequest = "Нет"
--
Inst7Quest3name1_HORDE = "Погибельная защита"
Inst7Quest3name2_HORDE = "Кулачный щит Камнесилы"
Inst7Quest3name3_HORDE = "Сфера Омеги"

--Quest 4 Horde  (same as Quest 2 Alliance)
Inst7Quest4_HORDE = "4. Обряды силы (Маг)"
Inst7Quest4_HORDE_Level = Inst7Quest2_Level
Inst7Quest4_HORDE_Attain = Inst7Quest2_Attain
Inst7Quest4_HORDE_Aim = Inst7Quest2_Aim
Inst7Quest4_HORDE_Location = Inst7Quest2_Location
Inst7Quest4_HORDE_Note = Inst7Quest2_Note
Inst7Quest4_HORDE_Prequest = Inst7Quest2_Prequest
Inst7Quest4_HORDE_Folgequest = Inst7Quest2_Folgequest
Inst7Quest4PreQuest_HORDE = Inst7Quest2_PreQuest
--
Inst7Quest4name1_HORDE = Inst7Quest2name1
Inst7Quest4name2_HORDE = Inst7Quest2name2
Inst7Quest4name3_HORDE = Inst7Quest2name3

--Quest 5 Horde
Inst7Quest5_HORDE = "5. В монастырь Алого ордена"
Inst7Quest5_HORDE_Level = "42"
Inst7Quest5_HORDE_Attain = "33"
Inst7Quest5_HORDE_Aim = "Убейте верховного инквизитора Вайтмейн, командира Могрейна из Алого ордена, воителя Ирода из Алого ордена и псаря Локси. Затем возвращайтесь к Вариматасу в Подгород."
Inst7Quest5_HORDE_Location = "Вариматас (Подгород - Королевский квартал; "..YELLOW.."56,92"..WHITE..")"
Inst7Quest5_HORDE_Note = "Вы найдете Верховного инквизитора Вайтмейн и Командира Могрейна из Алого ордена в "..YELLOW.."МАО: Собор [2]"..WHITE..", Герода в"..YELLOW.."МАО: Оружейная [1]"..WHITE.." и псаря Локси в "..YELLOW.."МАО: Библиотека [1]"..WHITE.."."
Inst7Quest5_HORDE_Prequest = "Нет"
Inst7Quest5_HORDE_Folgequest = "Нет"
--
Inst7Quest5name1_HORDE = "Меч Омена"
Inst7Quest5name2_HORDE = "Пророческая палка"
Inst7Quest5name3_HORDE = "Ожерелье Драконьей Крови"



--------------- INST8 - Scarlet Monastery: Armory ---------------

Inst8Caption = "МАО: Оружейная"
Inst8QAA = "1 задание"
Inst8QAH = "2 задания"

--Quest 1 Alliance
Inst8Quest1 = "1. Во имя Света!"
Inst8Quest1_Level = Inst7Quest3_Level
Inst8Quest1_Attain = Inst7Quest3_Attain
Inst8Quest1_Aim = Inst7Quest3_Aim
Inst8Quest1_Location = Inst7Quest3_Location
Inst8Quest1_Note = Inst7Quest3_Note
Inst8Quest1_Prequest = Inst7Quest3_Prequest
Inst8Quest1_Folgequest = "Нет"
Inst8Quest1PreQuest = "true"
--   
Inst8Quest1name1 = "Меч безмятежности"
Inst8Quest1name2 = "Костекус"
Inst8Quest1name3 = "Черная угроза"
Inst8Quest1name4 = "Сфера Лорики"

--Quest 1 Horde
Inst8Quest1_HORDE = Inst7Quest1_HORDE
Inst8Quest1_HORDE_Level = Inst7Quest1_HORDE_Level
Inst8Quest1_HORDE_Attain = Inst7Quest1_HORDE_Attain
Inst8Quest1_HORDE_Aim = Inst7Quest1_HORDE_Aim
Inst8Quest1_HORDE_Location = Inst7Quest1_HORDE_Location
Inst8Quest1_HORDE_Note = Inst7Quest1_HORDE_Note 
Inst8Quest1_HORDE_Prequest = Inst7Quest1_HORDE_Prequest
Inst8Quest1_HORDE_Folgequest = "Нет"
Inst8Quest1PreQuest_HORDE = "true"
-- No Rewards for this quest

--Quest 2 Horde
Inst8Quest2_HORDE = "2. В монастырь Алого ордена"
Inst8Quest2_HORDE_Level = "42"
Inst8Quest2_HORDE_Attain = "33"
Inst8Quest2_HORDE_Aim = Inst7Quest5_HORDE_Aim 
Inst8Quest2_HORDE_Location = Inst7Quest5_HORDE_Location
Inst8Quest2_HORDE_Note = Inst7Quest5_HORDE_Note
Inst8Quest2_HORDE_Prequest = "Нет"
Inst8Quest2_HORDE_Folgequest = "Нет"
--
Inst8Quest2name1_HORDE = Inst7Quest5name1_HORDE
Inst8Quest2name2_HORDE = Inst7Quest5name2_HORDE
Inst8Quest2name3_HORDE = Inst7Quest5name3_HORDE



--------------- INST9 - Scarlet Monastery: Cathedral ---------------

Inst9Caption = "МАО: Собор"
Inst9QAA = "1 задание"
Inst9QAH = "2 задания"

--Quest 1 Alliance
Inst9Quest1 = "1. Во имя Света!"
Inst9Quest1_Level = Inst7Quest3_Level
Inst9Quest1_Attain = Inst7Quest3_Attain
Inst9Quest1_Aim = Inst7Quest3_Aim
Inst9Quest1_Location = Inst7Quest3_Location
Inst9Quest1_Note = Inst7Quest3_Note
Inst9Quest1_Prequest = Inst7Quest3_Prequest
Inst9Quest1_Folgequest = "Нет"
Inst9Quest1PreQuest = "true"
--   
Inst9Quest1name1 = "Меч безмятежности"
Inst9Quest1name2 = "Костекус"
Inst9Quest1name3 = "Черная угроза"
Inst9Quest1name4 = "Сфера Лорики"

--Quest 1 Horde
Inst9Quest1_HORDE = Inst7Quest1_HORDE
Inst9Quest1_HORDE_Level = Inst7Quest1_HORDE_Level
Inst9Quest1_HORDE_Attain = Inst7Quest1_HORDE_Attain
Inst9Quest1_HORDE_Aim = Inst7Quest1_HORDE_Aim
Inst9Quest1_HORDE_Location = Inst7Quest1_HORDE_Location
Inst9Quest1_HORDE_Note = Inst7Quest1_HORDE_Note 
Inst9Quest1_HORDE_Prequest = Inst7Quest1_HORDE_Prequest
Inst9Quest1_HORDE_Folgequest = "Нет"
Inst9Quest1PreQuest_HORDE = "true"
-- No Rewards for this quest

--Quest 2 Horde
Inst9Quest2_HORDE = "2. В монастырь Алого ордена"
Inst9Quest2_HORDE_Level = "42"
Inst9Quest2_HORDE_Attain = "33"
Inst9Quest2_HORDE_Aim = Inst7Quest5_HORDE_Aim 
Inst9Quest2_HORDE_Location = Inst7Quest5_HORDE_Location
Inst9Quest2_HORDE_Note = Inst7Quest5_HORDE_Note
Inst9Quest2_HORDE_Prequest = "Нет"
Inst9Quest2_HORDE_Folgequest = "Нет"
--
Inst9Quest2name1_HORDE = Inst7Quest5name1_HORDE
Inst9Quest2name2_HORDE = Inst7Quest5name2_HORDE
Inst9Quest2name3_HORDE = Inst7Quest5name3_HORDE



--------------- INST10 - Scarlet Monastery: Graveyard ---------------

Inst10Caption = "МАО: Кладбище"
Inst10QAA = "Нет заданий"
Inst10QAH = "2 задания"


--Quest 1 Horde
Inst10Quest1_HORDE = "1. Месть Воррела"
Inst10Quest1_HORDE_Level = "33"
Inst10Quest1_HORDE_Attain = "25"
Inst10Quest1_HORDE_Aim = "Верните обручальное кольцо Воррела Сенгутца Монике Сенгутц в Мельнице Таррен."
Inst10Quest1_HORDE_Location = "Воррел Сенгутц (МАО - Кладбище; "..YELLOW.."[1]"..WHITE..")"
Inst10Quest1_HORDE_Note = "Вы можете найти Vorrel Sengutz в начале секции кладбища Алого Монастыря. Нэнси Вишас, которая сбрасывает кольцо, необходимое для этого квеста, можно найти в доме в Альтеракских горах. ("..YELLOW.."31,32"..WHITE..")."
Inst10Quest1_HORDE_Prequest = "Нет"
Inst10Quest1_HORDE_Folgequest = "Нет"
--
Inst10Quest1name1_HORDE = "Сапоги Воррела"
Inst10Quest1name2_HORDE = "Оплечье горя"
Inst10Quest1name3_HORDE = "Накидка Неумолимой стали"

--Quest 2 Horde
Inst10Quest2_HORDE = Inst7Quest1_HORDE
Inst10Quest2_HORDE_Level = Inst7Quest1_HORDE_Level
Inst10Quest2_HORDE_Attain = Inst7Quest1_HORDE_Attain
Inst10Quest2_HORDE_Aim = Inst7Quest1_HORDE_Aim
Inst10Quest2_HORDE_Location = Inst7Quest1_HORDE_Location
Inst10Quest2_HORDE_Note = Inst7Quest1_HORDE_Note 
Inst10Quest2_HORDE_Prequest = Inst7Quest1_HORDE_Prequest
Inst10Quest2_HORDE_Folgequest = "Нет"
Inst10Quest2PreQuest_HORDE = "true"
-- No Rewards for this quest



--------------- INST11 - Scholomance ---------------

Inst11Caption = "Некроситет"
Inst11QAA = "11 заданий"
Inst11QAH = "12 заданий"

--Quest 1 Alliance
Inst11Quest1 = "1. Зачумленные детеныши дракона"
Inst11Quest1_Level = "58"
Inst11Quest1_Attain = "55"
Inst11Quest1_Aim = "Убейте 20 зачумленных детенышей дракона, затем возвращайтесь к Бетине Биггльцинк в Часовню Последней Надежды."
Inst11Quest1_Location = "Бетина Биггльцинк (Восточные Чумные земли - Часовня Последней Надежды; "..YELLOW.."81,59"..WHITE..")"
Inst11Quest1_Note = "Зачумленные детеныши дракона находятся по пути к Громоклину в большой комнате."
Inst11Quest1_Prequest = "Нет"
Inst11Quest1_Folgequest = "Здоровая чешуя дракона" -- 5582
-- No Rewards for this quest

--Quest 2 Alliance
Inst11Quest2 = "2. Здоровая чешуя дракона" -- 5582
Inst11Quest2_Level = "58"
Inst11Quest2_Attain = "55"
Inst11Quest2_Aim = "Отнесите здоровую чешую дракона Бетине Биггльцинк в Часовню Последней Надежды в Восточные Чумные земли."
Inst11Quest2_Location = "Здоровая чешуя дракона (случайно добывается в Некроситете)"
Inst11Quest2_Note = "Здоровая чешуя дракона добывается с зачумленных детенышей дракона (8% шанс). Вы найдете Бетину Биггльцинк в Восточные Чумные земли - Часовня Последней Надежды ("..YELLOW.."81,59"..WHITE..")."
Inst11Quest2_Prequest = "Зачумленные детеныши дракона" -- 5529
Inst11Quest2_Folgequest = "Нет"
Inst11Quest2FQuest = "true"
-- No Rewards for this quest

--Quest 3 Alliance
Inst11Quest3 = "3. Доктор Теолен Крастинов – Мясник"
Inst11Quest3_Level = "60"
Inst11Quest3_Attain = "55"
Inst11Quest3_Aim = "Найдите в Некроситете доктора Теолена Крастинова. Убейте его, затем сожгите останки Евы и Люсьена Саркофф. Выполнив задание, возвращайтесь к Еве Саркофф."
Inst11Quest3_Location = "Ева Саркофф (Западные Чумные земли - Каэр Дарроу; "..YELLOW.."70,73"..WHITE..")"
Inst11Quest3_Note = "Вы найдете доктора Теолена Крастинова, останки Евы и останки Люсьена Саркофф около "..YELLOW.."[9]"..WHITE.."."
Inst11Quest3_Prequest = "Нет"
Inst11Quest3_Folgequest = "Мешок ужасов Крастинова" -- 5515
-- No Rewards for this quest

--Quest 4 Alliance
Inst11Quest4 = "4. Мешок ужасов Крастинова"
Inst11Quest4_Level = "60"
Inst11Quest4_Attain = "55"
Inst11Quest4_Aim = "Найдите в Некроситете Джандис Барову и уничтожьте ее. Заберите мешок ужасов Крастинова. Отнесите мешок Еве Саркофф."
Inst11Quest4_Location = "Ева Саркофф (Западные Чумные земли - Каэр Дарроу; "..YELLOW.."70,73"..WHITE..")"
Inst11Quest4_Note = "Вы найдете Джандис Баров около "..YELLOW.."[3]"..WHITE.."."
Inst11Quest4_Prequest = "Доктор Теолен Крастинов – Мясник" -- 5382
Inst11Quest4_Folgequest = "Киртонос Глашатай" -- 5384
Inst11Quest4FQuest = "true"
-- No Rewards for this quest

--Quest 5 Alliance
Inst11Quest5 = "5. Киртонос Глашатай"
Inst11Quest5_Level = "60"
Inst11Quest5_Attain = "55"
Inst11Quest5_Aim = "Вернитесь в Некроситет с кровью невинных. Найдите балкон и вылейте кровь в жаровню. На зов явится Киртонос. Сражайтесь как герой, не сдавайтесь! Уничтожьте Киртоноса и возвращайтесь к Еве Саркофф."
Inst11Quest5_Location = "Ева Саркофф (Западные Чумные земли - Каэр Дарроу; "..YELLOW.."70,73"..WHITE..")"
Inst11Quest5_Note = "Жаровня находится около "..YELLOW.."[2]"..WHITE.."."
Inst11Quest5_Prequest = "Мешок ужасов Крастинова" -- 5515
Inst11Quest5_Folgequest = "Рас Ледяной Шепот – человек" -- 5461
Inst11Quest5FQuest = "true"
--
Inst11Quest5name1 = "Сущность привидения"
Inst11Quest5name2 = "Роза Пенелопы"
Inst11Quest5name3 = "Песня Мираха"

--Quest 6 Alliance
Inst11Quest6 = "6. Рас Ледяной Шепот – лич"
Inst11Quest6_Level = "60"
Inst11Quest6_Attain = "57"
Inst11Quest6_Aim = "Отыщите в Некроситете Раса Ледяного Шепота. Найдя его, воспользуйтесь Книгой Души против его посмертного облика. Если удастся превратить Раса в смертного, убейте его и заберите человеческую голову Раса Ледяного Шепота. Отнесите голову мировому судье Мардуку."
Inst11Quest6_Location = "Мировой судья Мардук (Западные Чумные земли - Каэр Дарроу; "..YELLOW.."70,73"..WHITE..")"
Inst11Quest6_Note = "Вы сможете найти Раса Леденой Шепот около "..YELLOW.."[7]"..WHITE.."."
Inst11Quest6_Prequest = "Рас Ледяной Шепот – человек - >  Книга Души" -- 5461 -> 5465
Inst11Quest6_Folgequest = "Нет"
Inst11Quest6PreQuest = "true"
--
Inst11Quest6name1 = "Сильностраж Дарроушира"
Inst11Quest6name2 = "Боевой клинок Каэр Дарроу"
Inst11Quest6name3 = "Корона Каэр Дарроу"
Inst11Quest6name4 = "Пика Дэрроу"

--Quest 7 Alliance
Inst11Quest7 = "7. Сокровище Баровых"
Inst11Quest7_Level = "60"
Inst11Quest7_Attain = "52"
Inst11Quest7_Aim = "Отправляйтесь в Некроситет и добудьте сокровище семьи Баровых. Оно состоит из четырех документов: на Каэр Дарроу, на Брилл, на Мельницу Таррен и на Южнобережье. После выполнения задания вернитесь к Вэлдону Барову."
Inst11Quest7_Location = "Велдон Баров (Западные Чумные земли - Лагерь Промозглого Ветра; "..YELLOW.."43,83"..WHITE..")"
Inst11Quest7_Note = "Вы найдете Документы на Каэр Дарроу около "..YELLOW.."[12]"..WHITE..", Документы на Брилл около "..YELLOW.."[7]"..WHITE..", Документы на мельницу Таррен около "..YELLOW.."[4]"..WHITE.." и Документы на Южнобережье около "..YELLOW.."[1]"..WHITE.."."
Inst11Quest7_Prequest = "Нет"
Inst11Quest7_Folgequest = "Последний из Баровых" -- 5344
--
Inst11Quest7name1 = "Набатный колокол рода Баровых"

--Quest 8 Alliance
Inst11Quest8 = "8. Рассветный гамбит"
Inst11Quest8_Level = "60"
Inst11Quest8_Attain = "57"
Inst11Quest8_Aim = "Отнесите рассветный гамбит в Демонстрационную комнату в Некроситете. Уничтожьте Вектуса и возвращайтесь к Бетине Биггльцинк."
Inst11Quest8_Location = "Бетина Биггльцинк (Восточные Чумные земли - Часовня Последней Надежды; "..YELLOW.."81,59"..WHITE..")"
Inst11Quest8_Note = "Сущность детеныша дракона начинается у Тинки Кипеллера (Пылающие степи - Пламенеющий стяг; "..YELLOW.."65,23"..WHITE.."). Демонстрационная комната находится около "..YELLOW.."[6]"..WHITE.."."
Inst11Quest8_Prequest = "Сущность детеныша дракона - > Бетина Биггльцинк" -- 4726 -> 5531
Inst11Quest8_Folgequest = "Нет"
Inst11Quest8PreQuest = "true"
--
Inst11Quest8name1 = "Ветрожнец"
Inst11Quest8name2 = "Танцующее серебро"

--Quest 9 Alliance
Inst11Quest9 = "9. Доставка беса (Чернокнижник)"
Inst11Quest9_Level = "60"
Inst11Quest9_Attain = "60"
Inst11Quest9_Aim = "Отнесите беса в бутылке в алхимическую лабораторию Некроситета. После создания пергамента верните бутылку Горзиеки Дикоглазу."
Inst11Quest9_Location = "Горзиеки Дикоглаз (Пылающие степи; "..YELLOW.."12,31"..WHITE..")"
Inst11Quest9_Note = "Задание для чернокнижников: Вы найдете алхимическую лабораторию около "..YELLOW.."[7]"..WHITE.."."
Inst11Quest9_Prequest = "Мор'зул Вестник Крови - > Зоротианская звездная пыль" -- 7562 -> 7625
Inst11Quest9_Folgequest = "Зоротианский конь погибели ("..YELLOW.."Забытый город (Запад)"..WHITE..")" -- 7631
Inst11Quest9PreQuest = "true"
-- No Rewards for this quest

--Quest 10 Alliance
Inst11Quest10 = "10. Левая часть амулета Лорда Вальтхалака"
Inst11Quest10_Level = "60"
Inst11Quest10_Attain = "58"
Inst11Quest10_Aim = "С помощью жаровни Призыва вызвать дух Кормока и убить его. Вернуться к Бодли в Черную гору, отдать ему левую часть амулета Лорда Вальтхалака и жаровню Призыва."
Inst11Quest10_Location = "Бодли (Черная гора; "..YELLOW.."[D] на карте входа"..WHITE..")"
Inst11Quest10_Note = "Чтобы увидеть Бодли нужен Спектральный сканер иных измерений. Вы получите его за задание 'В поисках Антиона'.\n\nКормок вызывается около "..YELLOW.."[7]"..WHITE.."."
Inst11Quest10_Prequest = "Важная составляющая заклинания" -- 8965
Inst11Quest10_Folgequest = "Я вижу в твоем будущем остров Алькац..." -- 8970
Inst11Quest10PreQuest = "true"
-- No Rewards for this quest

--Quest 11 Alliance
Inst11Quest11 = "11. Правая часть амулета Лорда Вальтхалака"
Inst11Quest11_Level = "60"
Inst11Quest11_Attain = "58"
Inst11Quest11_Aim = "С помощью жаровни Призыва вызвать дух Кормока и убить его. Вернуться к Бодли в Черную гору, отдать ему восстановленный амулет и жаровню Призыва."
Inst11Quest11_Location = "Бодли (Черная гора; "..YELLOW.."[D] на карте входа"..WHITE..")"
Inst11Quest11_Note = "Чтобы увидеть Бодли нужен Спектральный сканер иных измерений. Вы получите его за задание 'В поисках Антиона'.\n\nКормок вызывается около "..YELLOW.."[7]"..WHITE.."."
Inst11Quest11_Prequest = "Еще одна важная составляющая заклинания" -- 8988
Inst11Quest11_Folgequest = "Последние приготовления ("..YELLOW.."Вершина Черной горы"..WHITE..")" -- 8994
Inst11Quest11PreQuest = "true"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst11Quest1_HORDE = Inst11Quest1
Inst11Quest1_HORDE_Level = Inst11Quest1_Level
Inst11Quest1_HORDE_Attain = Inst11Quest1_Attain
Inst11Quest1_HORDE_Aim = Inst11Quest1_Aim
Inst11Quest1_HORDE_Location = Inst11Quest1_Location
Inst11Quest1_HORDE_Note = Inst11Quest1_Note
Inst11Quest1_HORDE_Prequest = Inst11Quest1_Prequest
Inst11Quest1_HORDE_Folgequest = Inst11Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst11Quest2_HORDE = Inst11Quest2
Inst11Quest2_HORDE_Level = Inst11Quest2_Level
Inst11Quest2_HORDE_Attain = Inst11Quest2_Attain
Inst11Quest2_HORDE_Aim = Inst11Quest2_Aim
Inst11Quest2_HORDE_Location = Inst11Quest2_Location
Inst11Quest2_HORDE_Note = Inst11Quest2_Note
Inst11Quest2_HORDE_Prequest = Inst11Quest2_Prequest
Inst11Quest2_HORDE_Folgequest = Inst11Quest2_Folgequest
Inst11Quest2FQuest_HORDE = Inst11Quest2FQuest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst11Quest3_HORDE = Inst11Quest3
Inst11Quest3_HORDE_Level = Inst11Quest3_Level
Inst11Quest3_HORDE_Attain = Inst11Quest3_Attain
Inst11Quest3_HORDE_Aim = Inst11Quest3_Aim
Inst11Quest3_HORDE_Location = Inst11Quest3_Location
Inst11Quest3_HORDE_Note = Inst11Quest3_Note
Inst11Quest3_HORDE_Prequest = Inst11Quest3_Prequest
Inst11Quest3_HORDE_Folgequest = Inst11Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst11Quest4_HORDE = Inst11Quest4
Inst11Quest4_HORDE_Level = Inst11Quest4_Level
Inst11Quest4_HORDE_Attain = Inst11Quest4_Attain
Inst11Quest4_HORDE_Aim = Inst11Quest4_Aim
Inst11Quest4_HORDE_Location = Inst11Quest4_Location
Inst11Quest4_HORDE_Note = Inst11Quest4_Note
Inst11Quest4_HORDE_Prequest = Inst11Quest4_Prequest
Inst11Quest4_HORDE_Folgequest = Inst11Quest4_Folgequest
Inst11Quest4FQuest_HORDE = Inst11Quest4FQuest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst11Quest5_HORDE = Inst11Quest5
Inst11Quest5_HORDE_Level = Inst11Quest5_Level
Inst11Quest5_HORDE_Attain = Inst11Quest5_Attain
Inst11Quest5_HORDE_Aim = Inst11Quest5_Aim
Inst11Quest5_HORDE_Location = Inst11Quest5_Location
Inst11Quest5_HORDE_Note = Inst11Quest5_Note
Inst11Quest5_HORDE_Prequest = Inst11Quest5_Prequest
Inst11Quest5_HORDE_Folgequest = Inst11Quest5_Folgequest
Inst11Quest5FQuest_HORDE = Inst11Quest5FQuest
--
Inst11Quest5name1_HORDE = Inst11Quest5name1
Inst11Quest5name2_HORDE = Inst11Quest5name2
Inst11Quest5name3_HORDE = Inst11Quest5name3

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst11Quest6_HORDE = Inst11Quest6
Inst11Quest6_HORDE_Level = Inst11Quest6_Level
Inst11Quest6_HORDE_Attain = Inst11Quest6_Attain
Inst11Quest6_HORDE_Aim = Inst11Quest6_Aim
Inst11Quest6_HORDE_Location = Inst11Quest6_Location
Inst11Quest6_HORDE_Note = Inst11Quest6_Note
Inst11Quest6_HORDE_Prequest = Inst11Quest6_Prequest
Inst11Quest6_HORDE_Folgequest = Inst11Quest6_Folgequest
Inst11Quest6PreQuest_HORDE = Inst11Quest6PreQuest
--
Inst11Quest6name1_HORDE = Inst11Quest6name1
Inst11Quest6name2_HORDE = Inst11Quest6name2
Inst11Quest6name3_HORDE = Inst11Quest6name3
Inst11Quest6name4_HORDE = Inst11Quest6name4

--Quest 7 Horde
Inst11Quest7_HORDE = "7. Сокровище Баровых"
Inst11Quest7_HORDE_Level = "60"
Inst11Quest7_HORDE_Attain = "52"
Inst11Quest7_HORDE_Aim = "Отправляйтесь в Некроситет и добудьте сокровище семьи Баровых. Оно состоит из четырех документов: на Каэр Дарроу, на Брилл, на Мельницу Таррен и на Южнобережье. После выполнения задания вернитесь к Алексию Барову."
Inst11Quest7_HORDE_Location = "Алексий Баров (Западные Чумные земли; "..YELLOW.."28,57"..WHITE..")"
Inst11Quest7_HORDE_Note = "Вы найдете Документы на Каэр Дарроу около "..YELLOW.."[12]"..WHITE..", Документы на Брилл около "..YELLOW.."[7]"..WHITE..", Документы на мельницу Таррен около "..YELLOW.."[4]"..WHITE.." и Документы на Южнобережье около "..YELLOW.."[1]"..WHITE.."."
Inst11Quest7_HORDE_Prequest = "Нет"
Inst11Quest7_HORDE_Folgequest = "Последний из Баровых" -- 5342
--
Inst11Quest7name1_HORDE = "Набатный колокол рода Баровых"

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst11Quest8_HORDE = Inst11Quest8
Inst11Quest8_HORDE_Level = Inst11Quest8_Level
Inst11Quest8_HORDE_Attain = Inst11Quest8_Attain
Inst11Quest8_HORDE_Aim = Inst11Quest8_Aim
Inst11Quest8_HORDE_Location = Inst11Quest8_Location
Inst11Quest8_HORDE_Note = Inst11Quest8_Note
Inst11Quest8_HORDE_Prequest = Inst11Quest8_Prequest
Inst11Quest8_HORDE_Folgequest = Inst11Quest8_Folgequest
Inst11Quest8PreQuest_HORDE = Inst11Quest8PreQuest
--
Inst11Quest8name1_HORDE = Inst11Quest8name1
Inst11Quest8name2_HORDE = Inst11Quest8name2

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst11Quest9_HORDE = Inst11Quest9
Inst11Quest9_HORDE_Level = Inst11Quest9_Level
Inst11Quest9_HORDE_Attain = Inst11Quest9_Attain
Inst11Quest9_HORDE_Aim = Inst11Quest9_Aim
Inst11Quest9_HORDE_Location = Inst11Quest9_Location
Inst11Quest9_HORDE_Note = Inst11Quest9_Note
Inst11Quest9_HORDE_Prequest = Inst11Quest9_Prequest
Inst11Quest9_HORDE_Folgequest = Inst11Quest9_Folgequest
Inst11Quest9PreQuest_HORDE = Inst11Quest9PreQuest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst11Quest10_HORDE = Inst11Quest10
Inst11Quest10_HORDE_Level = Inst11Quest10_Level
Inst11Quest10_HORDE_Attain = Inst11Quest10_Attain
Inst11Quest10_HORDE_Aim = Inst11Quest10_Aim
Inst11Quest10_HORDE_Location = Inst11Quest10_Location
Inst11Quest10_HORDE_Note = Inst11Quest10_Note
Inst11Quest10_HORDE_Prequest = Inst11Quest10_Prequest
Inst11Quest10_HORDE_Folgequest = Inst11Quest10_Folgequest
Inst11Quest10PreQuest_HORDE = Inst11Quest10PreQuest
-- No Rewards for this quest

--Quest 11 Horde
Inst11Quest11_HORDE = "11. Угроза Темного Губителя (Шаман)"
Inst11Quest11_HORDE_Level = "60"
Inst11Quest11_HORDE_Attain = "58"
Inst11Quest11_HORDE_Aim = "Используйте кристальный предсказатель в Главном склепе в Некроситете. Сразитесь с духами. Когда появится Темный Терзатель, убейте его. Принесите голову Темного Терзателя Сагорну Гривастому Страннику на Аллею Мудрости Оргриммара"
Inst11Quest11_HORDE_Location = "Сагорн Крестстридер (Оргриммар - Алея Мудрости; "..YELLOW.."38.6, 36.2"..WHITE..")"
Inst11Quest11_HORDE_Note = "Этот квест доступен только для шаманов. Преквест получен из того же NPC.\n\nDeath Knight Темный Похититель вызван  "..YELLOW.."[5]"..WHITE.."."
Inst11Quest11_HORDE_Prequest = "Существенная помощь"
Inst11Quest11_HORDE_Folgequest = "Нет"
Inst11Quest11PreQuest_HORDE = "true"
--
Inst11Quest11name1_HORDE = "Шлем Небесной Ярости"

--Quest 12 Horde  (same as Quest 11 Alliance)
Inst11Quest12_HORDE = "12. Правая часть амулета Лорда Вальтхалака"
Inst11Quest12_HORDE_Level = Inst11Quest11_Level
Inst11Quest12_HORDE_Attain = Inst11Quest11_Attain
Inst11Quest12_HORDE_Aim = Inst11Quest11_Aim
Inst11Quest12_HORDE_Location = Inst11Quest11_Location
Inst11Quest12_HORDE_Note = Inst11Quest11_Note
Inst11Quest12_HORDE_Prequest = Inst11Quest11_Prequest
Inst11Quest12_HORDE_Folgequest = Inst11Quest11_Folgequest
Inst11Quest12PreQuest_HORDE = Inst11Quest11PreQuest
-- No Rewards for this quest



--------------- INST12 - Shadowfang Keep ---------------

Inst12Caption = "Крепость Темного Клыка"
Inst12QAA = "2 задания"
Inst12QAH = "4 задания"

--Quest 1 Alliance
Inst12Quest1 = "1. Испытание доблести (Паладин)"
Inst12Quest1_Level = "22"
Inst12Quest1_Attain = "20"
Inst12Quest1_Aim = "Возьмите список Джордана, добудьте немного древесины белокаменного дуба, партию очищенной руды Бэйлора, кузнечный молот Джордана и самоцвет Кора и отдайте их Джордану Стилвеллу в Стальгорне."
Inst12Quest1_Location = "Джордан Стилвелл (Дун Морог - Вход в Стальгорн; "..YELLOW.."52,36"..WHITE..")"
Inst12Quest1_Note = "Задание для паладинов: Чтобы увидеть заметки щелкните на "..YELLOW.."[Информация: Испытание доблести]"..WHITE.."."
Inst12Quest1_Page = {2, "Только паладины могут получить это задание!\n\n1. Вы получите древесину белокаменного дуба у гоблинов-лесорубов в "..YELLOW.."[Мертвые копи]"..WHITE.." около "..YELLOW.."[3]"..WHITE..".\n\n2. Для получения партии очищенной руды Бэйлора вы должны поговорить с Бэйлором Каменной Дланью (Озеро Модан - Телсамар; "..YELLOW.."35,44"..WHITE.."). Он даст вам задание 'Партия руды Бэйлора'. Вы найдете руду Джордана за деревом около "..YELLOW.."71,21"..WHITE.."\n\n3. Вы получите кузнечный молот Джордана в "..YELLOW.."[Крепость Темного Клыка]"..WHITE.." около "..YELLOW.."[3]"..WHITE..".\n\n4. Для получения самоцвета Кора Вам нужно пойти к Тандрису Ветропряду (Темные берега - Аубердин; "..YELLOW.."37,40"..WHITE..") и выполнить задание 'Поиск самоцвета Кора'. Для этого задания, вам нужно убивать Провидзев и Жриц Непроглядной пучины перед "..YELLOW.."[Непроглядная пучина]"..WHITE..". С них добывается Оскверненный самоцвет Кора. Тандрис Ветропряд очистит его для Вас.", };
Inst12Quest1_Prequest = "Фолиант Отваги -> Испытание доблести" -- 1651 -> 1653
Inst12Quest1_Folgequest = "Испытание доблести" -- 1806
Inst12Quest1PreQuest = "true"
--
Inst12Quest1name1 = "Боевая перчатка Веригана"

--Quest 2 Alliance
Inst12Quest2 = "2. Шар Соран'рука (Чернокнижник)"
Inst12Quest2_Level = "25"
Inst12Quest2_Attain = "20"
Inst12Quest2_Aim = "Соберите 3 фрагмента Соран'рука и 1 большой фрагмент Соран'рука и принесите их Доану Кархану в Степи."
Inst12Quest2_Location = "Доан Кархан (Степи; "..YELLOW.."49,57"..WHITE..")"
Inst12Quest2_Note = "Задание для чернокнижников: Вы возьмете 3 фрагмента Соран'рука с Сумеречных Прислужников в "..YELLOW.."[Непроглядная пучина]"..WHITE..". Вы возьмете большой фрагмент Соран'рука в "..YELLOW.."[Крепость Темного Клыка]"..WHITE.." у Темных Душ Темного Клыка."
Inst12Quest2_Prequest = "Нет"
Inst12Quest2_Folgequest = "Нет"
--
Inst12Quest2name1 = "Сфера Соран'рука"
Inst12Quest2name2 = "Посох Соран'рука"



--Quest 1 Horde
Inst12Quest1_HORDE = "1. Пропавшие стражи смерти"
Inst12Quest1_HORDE_Level = "25"
Inst12Quest1_HORDE_Attain = "18"
Inst12Quest1_HORDE_Aim = "Найдите стражей смерти Адаманта и Винсента."
Inst12Quest1_HORDE_Location = "Верховный палач Хадрек (Серебряный бор - Гробница; "..YELLOW.."43,40"..WHITE..")"
Inst12Quest1_HORDE_Note = "Вы найдете стража смерти Адаманта около "..YELLOW.."[1]"..WHITE..". Страж смерти Винсент находится справа когда вы войдете во внутренний двор около "..YELLOW.."[3]"..WHITE.."."
Inst12Quest1_HORDE_Prequest = "Нет"
Inst12Quest1_HORDE_Folgequest = "Нет"
--
Inst12Quest1name1_HORDE = "Призрачное оплечье"

--Quest 2 Horde
Inst12Quest2_HORDE = "2. Книга Ура"
Inst12Quest2_HORDE_Level = "26"
Inst12Quest2_HORDE_Attain = "16"
Inst12Quest2_HORDE_Aim = "Принесите книгу Ура хранителю Бел'дугуру в Район Фармацевтов в Подгород."
Inst12Quest2_HORDE_Location = "Хранитель Бел'дугур (Подгород - Район Фармацевтов; "..YELLOW.."53,54"..WHITE..")"
Inst12Quest2_HORDE_Note = "Вы найдете книгу около "..YELLOW.."[11]"..WHITE.." слева, когда вы войдете в комнату."
Inst12Quest2_HORDE_Prequest = "Нет"
Inst12Quest2_HORDE_Folgequest = "Нет"
--
Inst12Quest2name1_HORDE = "Серые сапоги"
Inst12Quest2name2_HORDE = "Наручи со стальными застежками"

--Quest 3 Horde
Inst12Quest3_HORDE = "3. Смерть Аругалу!"
Inst12Quest3_HORDE_Level = "27"
Inst12Quest3_HORDE_Attain = "18"
Inst12Quest3_HORDE_Aim = "Убейте Аругала и принесите его голову Далару Ткачу Рассвета в Гробницу."
Inst12Quest3_HORDE_Location = "Далар Ткач Рассвета (Серебряный бор - Гробница; "..YELLOW.."44,39"..WHITE..")"
Inst12Quest3_HORDE_Note = "Вы найдете Архимага Аругала около "..YELLOW.."[13]"..WHITE.."."
Inst12Quest3_HORDE_Prequest = "Нет"
Inst12Quest3_HORDE_Folgequest = "Нет"
--
Inst12Quest3name1_HORDE = "Печать Сильваны"

--Quest 4 Horde  (same as Quest 2 Alliance)
Inst12Quest4_HORDE = "4. Шар Соран'рука (Чернокнижник)"
Inst12Quest4_HORDE_Level = Inst12Quest2_Level
Inst12Quest4_HORDE_Attain = Inst12Quest2_Attain
Inst12Quest4_HORDE_Aim = Inst12Quest2_Aim
Inst12Quest4_HORDE_Location = Inst12Quest2_Location
Inst12Quest4_HORDE_Note = Inst12Quest2_Note
Inst12Quest4_HORDE_Prequest = Inst12Quest2_Prequest
Inst12Quest4_HORDE_Folgequest = Inst12Quest2_Folgequest
--
Inst12Quest4name1_HORDE = Inst12Quest2name1
Inst12Quest4name2_HORDE = Inst12Quest2name1



--------------- INST13 - The Stockade ---------------

Inst13Caption = "Тюрьма"
Inst13QAA = "6 заданий"
Inst13QAH = "Нет заданий"

--Quest 1 Alliance
Inst13Quest1 = "1. Что происходит?"
Inst13Quest1_Level = "25"
Inst13Quest1_Attain = "22"
Inst13Quest1_Aim = "Принесите голову Таргорра Ужасного стражнику Бертону в Приозерье."
Inst13Quest1_Location = "Стражник Бертон (Красногорье - Приозерье; "..YELLOW.."26,46"..WHITE..")"
Inst13Quest1_Note = "Вы найдете Таргорра около "..YELLOW.."[1]"..WHITE.."."
Inst13Quest1_Prequest = "Нет"
Inst13Quest1_Folgequest = "Нет"
--
Inst13Quest1name1 = "Длинный меч Люцина"
Inst13Quest1name2 = "Упрочненный посох из корня"

--Quest 2 Alliance
Inst13Quest2 = "2. Преступление и наказание"
Inst13Quest2_Level = "26"
Inst13Quest2_Attain = "22"
Inst13Quest2_Aim = "Принесите советнику Миллстайпу руку Декстрена Варда."
Inst13Quest2_Location = "Миллстайп (Сумеречный лес - Темнолесье; "..YELLOW.."72,47"..WHITE..")"
Inst13Quest2_Note = "Вы найдете Декстрена около "..YELLOW.."[5]"..WHITE.."."
Inst13Quest2_Prequest = "Нет"
Inst13Quest2_Folgequest = "Нет"
--
Inst13Quest2name1 = "Сапоги посла"
Inst13Quest2name2 = "Кольчужные поножи Темнолесья"

--Quest 3 Alliance
Inst13Quest3 = "3. Подавление бунта"
Inst13Quest3_Level = "26"
Inst13Quest3_Attain = "22"
Inst13Quest3_Aim = "Тюремщик Телвотер просит вас убить в тюрьме 10 узников из Братства Справедливости, 8 каторжников из Братства Справедливости и 8 мятежников из Братства Справедливости."
Inst13Quest3_Location = "Тюремщик Телвотер (Штормград - Тюрьма Штормграда; "..YELLOW.."41,58"..WHITE..")"
Inst13Quest3_Note = ""
Inst13Quest3_Prequest = "Нет"
Inst13Quest3_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 4 Alliance
Inst13Quest4 = "4. Цвет крови"
Inst13Quest4_Level = "26"
Inst13Quest4_Attain = "22"
Inst13Quest4_Aim = "Принесите Никове Раскол 10 красных шерстяных бандан."
Inst13Quest4_Location = "Никовия Раскол (Штормград - Старый город; "..YELLOW.."73,46"..WHITE..")"
Inst13Quest4_Note = "Со всех бандитов внутри Тюрьмы могут упасть красные шерстяные банданы."
Inst13Quest4_Prequest = "Нет"
Inst13Quest4_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 5 Alliance
Inst13Quest5 = "5. Успокоить Гневливого"
Inst13Quest5_Level = "27"
Inst13Quest5_Attain = "22"
Inst13Quest5_Aim = "Принесите голову Кама Гневливого Мотли Гармасону в Дун Модр."
Inst13Quest5_Location = "Мотли Каменщик (Болотина - Дун Модр; "..YELLOW.."49,18"..WHITE..")"
Inst13Quest5_Note = "Предшествующее задание также можно взять у Мотли. Вы найдете Кама Гневливого около "..YELLOW.."[2]"..WHITE.."."
Inst13Quest5_Prequest = "Война с Черным Железом" -- 303
Inst13Quest5_Folgequest = "Нет"
Inst13Quest5PreQuest = "true"
--
Inst13Quest5name1 = "Пояс Опоры"
Inst13Quest5name2 = "Головокрушитель"

--Quest 6 Alliance
Inst13Quest6 = "6. Бунтовщики в тюрьме"
Inst13Quest6_Level = "29"
Inst13Quest6_Attain = "16"
Inst13Quest6_Aim = "Убейте Базиля Тредда и принесите его голову Телвотеру в тюрьму Штормграда."
Inst13Quest6_Location = "Тюремщик Телвотер (Штормград - Тюрьма Штормграда; "..YELLOW.."41,58"..WHITE..")"
Inst13Quest6_Note = "Для более детальной информации о предшествующем задании смотрите "..YELLOW.."[Мертвые копи, Братство справедливости]"..WHITE..".\nВы найдете Базиля Тредда около "..YELLOW.."[4]"..WHITE.."."
Inst13Quest6_Prequest = "Братство Справедливости -> Базиль Тредд" -- 65 -> 389
Inst13Quest6_Folgequest = "Таинственный посетитель" -- 392
Inst13Quest6PreQuest = "true"
-- No Rewards for this quest



--------------- INST14 - Stratholme ---------------

Inst14Caption = "Стратхольм"
Inst14QAA = "18 заданий"
Inst14QAH = "9 заданий"

--Quest 1 Alliance
Inst14Quest1 = "1. Плоть не лжет"
Inst14Quest1_Level = "60"
Inst14Quest1_Attain = "55"
Inst14Quest1_Aim = "Принесите 10 препаратов чумной плоти из Стратхольма Бетине Биггльцинк. Предположительно, сойдут ткани любой твари из Стратхольма."
Inst14Quest1_Location = "Бетина Биггльцинк (Восточные Чумные земли - Часовня Последней Надежды; "..YELLOW.."81,59"..WHITE..")"
Inst14Quest1_Note = "Сбольшинства существ в Стратхольме падают препараты чумной плоти, но шанс очень мал."
Inst14Quest1_Prequest = "Нет"
Inst14Quest1_Folgequest = "Вирус чумы" -- 5213
-- No Rewards for this quest

--Quest 2 Alliance
Inst14Quest2 = "2. Вирус чумы"
Inst14Quest2_Level = "60"
Inst14Quest2_Attain = "55"
Inst14Quest2_Aim = "Отправляйтесь в Стратхольм и исследуйте зиккураты. Доставьте сведения о Плети Бетине Биггльцинк."
Inst14Quest2_Location = "Бетина Биггльцинк (Восточные Чумные земли - Часовня Последней Надежды; "..YELLOW.."81,59"..WHITE..")"
Inst14Quest2_Note = "Сведения о плети находятся в одной из 3 Башен, которые вы найдете около "..YELLOW.."[15]"..WHITE..", "..YELLOW.."[16]"..WHITE.." и "..YELLOW.."[17]"..WHITE.."."
Inst14Quest2_Prequest = "Плоть не лжет" -- 5212
Inst14Quest2_Folgequest = "Нет"
Inst14Quest2FQuest = "true"
--
Inst14Quest2name1 = "Печать Рассвета"
Inst14Quest2name2 = "Руна Рассвета"

--Quest 3 Alliance
Inst14Quest3 = "3. Святая вода"
Inst14Quest3_Level = "60"
Inst14Quest3_Attain = "55"
Inst14Quest3_Aim = "Отправляйтесь на север, в Стратхольм. Обыщите брошенные ящики с припасами и соберите 5 мер святой воды Стратхольма. Возвращайтесь к Леониду Барталомею Чтимому, как только воды будет достаточно."
Inst14Quest3_Location = "Леонид Барталомей Чтимый (Восточные Чумные земли - Часовня Последней Надежды; "..YELLOW.."80,58"..WHITE..")"
Inst14Quest3_Note = "Вы найдете святую воду в ящиках по всему Стратхольму. При открытии некоторых появятся насекомые и атакуют Вас."
Inst14Quest3_Prequest = "Нет"
Inst14Quest3_Folgequest = "Нет"
--
Inst14Quest3name1 = "Наилучшее лечебное зелье"
Inst14Quest3name2 = "Сильное зелье маны"
Inst14Quest3name3 = "Корона Покаяния"
Inst14Quest3name4 = "Кольцо Покаяния"

--Quest 4 Alliance
Inst14Quest4 = "4. Великий Фрас Сиаби"
Inst14Quest4_Level = "60"
Inst14Quest4_Attain = "55"
Inst14Quest4_Aim = "Найдите табачную лавку Фраса Сиаби в Стратхольме, отыщите в ней пачку лучшего табака Сиаби и принесите ее Дымку ЛаРу."
Inst14Quest4_Location = "Дымок ЛаРу (Восточные Чумные земли - Часовня Последней Надежды; "..YELLOW.."80,58"..WHITE..")"
Inst14Quest4_Note = "Вы найдете табачную лавку около "..YELLOW.."[1]"..WHITE..". Фрас Сиаби появится когда вы откроете коробку."
Inst14Quest4_Prequest = "Нет"
Inst14Quest4_Folgequest = "Нет"
--
Inst14Quest4name1 = "Воспламенитель Дымка"

--Quest 5 Alliance
Inst14Quest5 = "5. Завет надежды"
Inst14Quest5_Level = "60"
Inst14Quest5_Attain = "55"
Inst14Quest5_Aim = "Стреляйте в призрачных и неупокоенных горожан на улицах Стратхольма из бластера Эгана. Когда душа вырвется из призрачной оболочки, выстрелите в нее еще раз, и она обретет свободу.\nОсвободите 15 неупокоенных душ и возвращайтесь к Эгану."
Inst14Quest5_Location = "Эган (Восточные Чумные земли; "..YELLOW.."14,33"..WHITE..")"
Inst14Quest5_Note = "Вы возьмете предшествующее задание у управляющего Алена (Восточные Чумные земли - Часовня Последней Надежды; "..YELLOW.."79,63"..WHITE.."). Призраки и неупокоенные бродят по улицам Стратхольма."
Inst14Quest5_Prequest = "Мятущиеся души" -- 5281
Inst14Quest5_Folgequest = "Нет"
Inst14Quest5PreQuest = "true"
--
Inst14Quest5name1 = "Завет надежды"

--Quest 6 Alliance
Inst14Quest6 = "6. Символ семейной любви"
Inst14Quest6_Level = "60"
Inst14Quest6_Attain = "52"
Inst14Quest6_Aim = "Отправляйтесь в Стратхольм в северную часть Чумных земель. Найдите в Бастионе Алого ордена картину Символ семейной любви, спрятанную за другой, изображающей две луны нашего мира.\nОтнесите картину Тириону Фордрингу."
Inst14Quest6_Location = "Художница Ренфри (Западные Чумные земли - Каэр Дарроу; "..YELLOW.."65,75"..WHITE..")"
Inst14Quest6_Note = "Вы возьмете предшествующее задание у Тириона Фордринга (Западные Чумные земли; "..YELLOW.."7,43"..WHITE.."). Вы сможете найти картину около "..YELLOW.."[10]"..WHITE.."."
Inst14Quest6_Prequest = "Искупление - > Символ семейной любви" -- 5742 -> 5846
Inst14Quest6_Folgequest = "Найти Миранду" -- 5861
Inst14Quest6PreQuest = "true"
-- No Rewards for this quest

--Quest 7 Alliance
Inst14Quest7 = "7. Дар Менетила"
Inst14Quest7_Level = "60"
Inst14Quest7_Attain = "57"
Inst14Quest7_Aim = "Отправляйтесь в Стратхольм и отыщите Дар Менетила. Положите книгу Воспоминаний на оскверненную землю."
Inst14Quest7_Location = "Леонид Барталомей Чтимый (Восточные Чумные земли - Часовня Последней Надежды; "..YELLOW.."80,58"..WHITE..")"
Inst14Quest7_Note = "Вы возьмете предшествующее задание у мирового судьи Мардука (Западные Чумные земли - Каэр Дарроу; "..YELLOW.."70,73"..WHITE.."). Вы найдете знак около "..YELLOW.."[19]"..WHITE..". Смотрите также: "..YELLOW.."[Рас Снегошепот – лич]"..WHITE.." в Некроситете."
Inst14Quest7_Prequest = "Рас Ледяной Шепот – человек - > Рас Ледяной Шепот – гибель" -- 5461 -> 5462
Inst14Quest7_Folgequest = "Дар Менетила" -- 5464
Inst14Quest7PreQuest = "true"
-- No Rewards for this quest

--Quest 8 Alliance
Inst14Quest8 = "8. Слова Аурия"
Inst14Quest8_Level = "60"
Inst14Quest8_Attain = "56"
Inst14Quest8_Aim = "Убейте барона."
Inst14Quest8_Location = "Аурий (Стратхольм; "..YELLOW.."[13]"..WHITE..")"
Inst14Quest8_Note = "Чтобы начать выполнение задания вы должны отдать Аурию [Медальон Веры]. Вы получите медальон из сундука. В первой комнате крепости (до того как дороги разойдутся). После того, как вы отдадите Аурию медальон, он поможет вашей группе сражаться против Барона "..YELLOW.."[15]"..WHITE..". После убийства Барона вы должны снова поговорить с Аурием, чтобы получить награду."
Inst14Quest8_Prequest = "Нет"
Inst14Quest8_Folgequest = "Нет"
--
Inst14Quest8name1 = "Воля Мученика"
Inst14Quest8name2 = "Кровь Мученика"

--Quest 9 Alliance
Inst14Quest9 = "9. Архивариус"
Inst14Quest9_Level = "60"
Inst14Quest9_Attain = "55"
Inst14Quest9_Aim = "Отправляйтесь в Стратхольм и отыщите архивариуса Галфорда из Алого ордена. Убейте его и сожгите архив Алых."
Inst14Quest9_Location = "Герцог Николас Зверенхофф (Восточные Чумные земли - Часовня Последней Надежды; "..YELLOW.."81,59"..WHITE..")"
Inst14Quest9_Note = "Вы найдете архив и архивариуса около "..YELLOW.."[10]"..WHITE.."."
Inst14Quest9_Prequest = "Нет"
Inst14Quest9_Folgequest = "Ошеломляющая истина" -- 5262
-- No Rewards for this quest

--Quest 10 Alliance
Inst14Quest10 = "10. шеломляющая истина"
Inst14Quest10_Level = "60"
Inst14Quest10_Attain = "55"
Inst14Quest10_Aim = "Отнесите голову Бальназара герцогу Николасу Зверенхоффу в Восточные Чумные земли."
Inst14Quest10_Location = "Бальназар (Стратхольм; "..YELLOW.."[11]"..WHITE..")"
Inst14Quest10_Note = "Вы найдете герцога Николаса Зверенхоффа в Восточные Чумные земли - Часовня Последней Надежды ("..YELLOW.."81,59"..WHITE..")."
Inst14Quest10_Prequest = "Архивариус" -- 5251
Inst14Quest10_Folgequest = "Быстрее, выше, сильнее" -- 5263
Inst14Quest10FQuest = "true"
-- No Rewards for this quest

--Quest 11 Alliance
Inst14Quest11 = "11. Быстрее, выше, сильнее"
Inst14Quest11_Level = "60"
Inst14Quest11_Attain = "55"
Inst14Quest11_Aim = "Отправляйтесь в Стратхольм и убейте барона Ривендера. Принесите его голову герцогу Николасу Зверенхоффу."
Inst14Quest11_Location = "Герцог Николас Зверенхофф (Восточные Чумные земли - Часовня Последней Надежды; "..YELLOW.."81,59"..WHITE..")"
Inst14Quest11_Note = "Вы можете найти барона около "..YELLOW.."[19]"..WHITE.."."
Inst14Quest11_Prequest = "Ошеломляющая истина" -- 5262
Inst14Quest11_Folgequest = "Лорд Максвелл Тиросс -> Серебряный Оплот"
Inst14Quest11FQuest = "true"
--
Inst14Quest11name1 = "Серебряный Мститель"
Inst14Quest11name2 = "Защитный щит Серебряного Рассвета"
Inst14Quest11name3 = "Серебряный рыцарь"

--Quest 12 Alliance
Inst14Quest12 = "12. Просьба мертвеца"
Inst14Quest12_Level = "60"
Inst14Quest12_Attain = "58"
Inst14Quest12_Aim = "Отправляйтесь в Стратхольм и спасите Исиду Хармон от Барона Ривендера."
Inst14Quest12_Location = "Антион Хармон (Восточные Чумные земли - Стратхольм)"
Inst14Quest12_Note = "Антион стоит перед порталом в Стратхольм. Вам нужен Спектральный сканер иных измерений, чтобы увидеть его. Он дается за предыдущее задание. Цепочка заданий начинается со Справедливого вознаграждения. Делиана в Стальгорне ("..YELLOW.."43,52"..WHITE..") для Альянса, Моквар в Оргриммаре ("..YELLOW.."38,37"..WHITE..") для Орды.\nЭто печальный '45-ти минутный' забег на Барона."
Inst14Quest12_Prequest = "В поисках Антиона" -- 8929
Inst14Quest12_Folgequest = "Доказательство жизни" -- 8946
Inst14Quest12PreQuest = "true"
-- No Rewards for this quest

--Quest 13 Alliance
Inst14Quest13 = "13. Левая часть амулета Лорда Вальтхалака"
Inst14Quest13_Level = "60"
Inst14Quest13_Attain = "58"
Inst14Quest13_Aim = "Вызвать духов Джариен и Сотоса с помощью жаровни Призыва и убить их обоих. Вернуться к Бодли в Черную гору, отдать ему левую часть амулета Лорда Вальтхалака и жаровню Призыва."
Inst14Quest13_Location = "Бодли (Черная гора; "..YELLOW.."[D] на карте входа"..WHITE..")"
Inst14Quest13_Note = "Чтобы увидеть Бодли нужен Спектральный сканер иных измерений. Вы получите его за задание 'В поисках Антиона'.\n\nДжариен и Сотос вызываются около "..YELLOW.."[11]"..WHITE.."."
Inst14Quest13_Prequest = "Важная составляющая заклинания" -- 8964
Inst14Quest13_Folgequest = "Я вижу в твоем будущем остров Алькац..." -- 8970
Inst14Quest13PreQuest = "true"
-- No Rewards for this quest

--Quest 14 Alliance
Inst14Quest14 = "14. Правая часть амулета Лорда Вальтхалака"
Inst14Quest14_Level = "60"
Inst14Quest14_Attain = "58"
Inst14Quest14_Aim = "Вызвать духов Джариен и Сотоса с помощью жаровни Призыва и убить их обоих. Вернуться к Бодли в Черную гору, отдать ему восстановленный амулет и жаровню Призыва."
Inst14Quest14_Location = "Бодли (Черная гора; "..YELLOW.."[D] на карте входа"..WHITE..")"
Inst14Quest14_Note = "Чтобы увидеть Бодли нужен Спектральный сканер иных измерений. Вы получите его за задание 'В поисках Антиона'.\n\nДжариен и Сотос вызываются около "..YELLOW.."[11]"..WHITE.."."
Inst14Quest14_Prequest = "Еще одна важная составляющая заклинания" -- 8987
Inst14Quest14_Folgequest = "Последние приготовления ("..YELLOW.."Вершина Черной горы"..WHITE..")" -- 8994
Inst14Quest14PreQuest = "true"
-- No Rewards for this quest

--Quest 15 Alliance
Inst14Quest15 = "15. Атиеш, большой посох Стража"
Inst14Quest15_Level = "60"
Inst14Quest15_Attain = "60"
Inst14Quest15_Aim = "Анахронос из Пещер Времени, что в Танарисе, просит вас отнести Атиеш, большой посох Стража, в Стратхольм и установить его на освященную землю. Одолейте силу, которая исторгнется из посоха, и вернитесь к Анахроносу."
Inst14Quest15_Location = "Анахронос (Танарис - Пещеры Времени; "..YELLOW.."65,49"..WHITE..")"
Inst14Quest15_Note = "Атиеш вызывается около "..YELLOW.."[2]"..WHITE.."."
Inst14Quest15_Prequest = "Основа Атиеша -> Атиеш, оскверненный посох" -- 9250 -> 9251
Inst14Quest15_Folgequest = "Нет"
Inst14Quest15PreQuest = "true"
--
Inst14Quest15name1 = "Атиеш, большой посох Стража"
Inst14Quest15name2 = "Атиеш, большой посох Стража"
Inst14Quest15name3 = "Атиеш, большой посох Стража"
Inst14Quest15name4 = "Атиеш, большой посох Стража"

--Quest 16 Alliance
Inst14Quest16 = "16. Порча (Кузнечное дело)"
Inst14Quest16_Level = "60"
Inst14Quest16_Attain = "50"
Inst14Quest16_Aim = "Найдите в Стратхольме оружейника Черной Стражи и уничтожьте его. Возьмите его Знак Черной Стражи и принесите Сирилу Плетебою."
Inst14Quest16_Location = "Сирил Плетебой (Зимние Ключи - Круговзор; "..YELLOW.."61,37"..WHITE..")"
Inst14Quest16_Note = "Задание для кузнецов: Оружейник Черной Стражи вызывается около "..YELLOW.."[15]"..WHITE.."."
Inst14Quest16_Prequest = "Нет"
Inst14Quest16_Folgequest = "Нет"
--
Inst14Quest16name1 = "Чертеж: пылающая рапира"

--Quest 17 Alliance
Inst14Quest17 = "17. Секрет безмятежности (Кузнечное дело)"
Inst14Quest17_Level = "60"
Inst14Quest17_Attain = "50"
Inst14Quest17_Aim = "Отправляйтесь в Стратхольм и убейте Молотобойца из Багрового легиона. Возьмите его фартук и возвращайтесь к Лилит."
Inst14Quest17_Location = "Лилит Гибкая (Зимние Ключи - Круговзор; "..YELLOW.."61,37"..WHITE..")"
Inst14Quest17_Note = "Задание для кузнецов: Молотобоец из Багрового Легиона вызывается около "..YELLOW.."[8]"..WHITE.."."
Inst14Quest17_Prequest = "Нет"
Inst14Quest17_Folgequest = "Нет"
--
Inst14Quest17name1 = "Чертеж: зачарованный боевой молот"

--Quest 18 Alliance
Inst14Quest18 = "18. Баланс Света и Тени (Жрец)"
Inst14Quest18_Level = "60"
Inst14Quest18_Attain = "60"
Inst14Quest18_Aim = "Спасите жизни 50 крестьян прежде, чем 15 из них будут убиты. Поговорите с Эрис Тайнопламень по выполнении задания."
Inst14Quest18_Location = "Эрис Хейвенфайр (Восточные Чумные земли; "..YELLOW.."17.6, 14.0"..WHITE..")"
Inst14Quest18_Note = "Чтобы увидеть Эрис Хейвенфайр и получить этот квест и преквест, вам нужен Глаз Божественности (приходит из Тайника Повелителя Огня "..YELLOW.."[Огненые недра]"..WHITE..").\n\nThis награда за квест, в сочетании с Око Божественности и Око Тени (капли от демонов в Зимних Веснах или Взорванных Землях) образуют Благословение, посох эпического жреца."
Inst14Quest18_Prequest = "Предупреждение"
Inst14Quest18_Folgequest = "Нет"
Inst14Quest18PreQuest = "true"
--
Inst14Quest18name1 = "Расщепитель Нордрассила"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst14Quest1_HORDE = Inst14Quest1
Inst14Quest1_HORDE_Level = Inst14Quest1_Level
Inst14Quest1_HORDE_Attain = Inst14Quest1_Attain
Inst14Quest1_HORDE_Aim = Inst14Quest1_Aim
Inst14Quest1_HORDE_Location = Inst14Quest1_Location
Inst14Quest1_HORDE_Note = Inst14Quest1_Note
Inst14Quest1_HORDE_Prequest = Inst14Quest1_Prequest
Inst14Quest1_HORDE_Folgequest = Inst14Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst14Quest2_HORDE = Inst14Quest2
Inst14Quest2_HORDE_Level = Inst14Quest2_Level
Inst14Quest2_HORDE_Attain = Inst14Quest2_Attain
Inst14Quest2_HORDE_Aim = Inst14Quest2_Aim
Inst14Quest2_HORDE_Location = Inst14Quest2_Location
Inst14Quest2_HORDE_Note = Inst14Quest2_Note
Inst14Quest2_HORDE_Prequest = Inst14Quest2_Prequest
Inst14Quest2_HORDE_Folgequest = Inst14Quest2_Folgequest
Inst14Quest2FQuest_HORDE = Inst14Quest2FQuest
--
Inst14Quest2name1_HORDE = Inst14Quest2name1
Inst14Quest2name2_HORDE = Inst14Quest2name2

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst14Quest3_HORDE = Inst14Quest3
Inst14Quest3_HORDE_Level = Inst14Quest3_Level
Inst14Quest3_HORDE_Attain = Inst14Quest3_Attain
Inst14Quest3_HORDE_Aim = Inst14Quest3_Aim
Inst14Quest3_HORDE_Location = Inst14Quest3_Location
Inst14Quest3_HORDE_Note = Inst14Quest3_Note
Inst14Quest3_HORDE_Prequest = Inst14Quest3_Prequest
Inst14Quest3_HORDE_Folgequest = Inst14Quest3_Folgequest
--
Inst14Quest3name1_HORDE = Inst14Quest3name1
Inst14Quest3name2_HORDE = Inst14Quest3name2
Inst14Quest3name3_HORDE = Inst14Quest3name3
Inst14Quest3name4_HORDE = Inst14Quest3name4

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst14Quest4_HORDE = Inst14Quest4
Inst14Quest4_HORDE_Level = Inst14Quest4_Level
Inst14Quest4_HORDE_Attain = Inst14Quest4_Attain
Inst14Quest4_HORDE_Aim = Inst14Quest4_Aim
Inst14Quest4_HORDE_Location = Inst14Quest4_Location
Inst14Quest4_HORDE_Note = Inst14Quest4_Note
Inst14Quest4_HORDE_Prequest = Inst14Quest4_Prequest
Inst14Quest4_HORDE_Folgequest = Inst14Quest4_Folgequest
--
Inst14Quest4name1_HORDE = Inst14Quest4name1

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst14Quest5_HORDE = Inst14Quest5
Inst14Quest5_HORDE_Level = Inst14Quest5_Level
Inst14Quest5_HORDE_Attain = Inst14Quest5_Attain
Inst14Quest5_HORDE_Aim = Inst14Quest5_Aim
Inst14Quest5_HORDE_Location = Inst14Quest5_Location
Inst14Quest5_HORDE_Note = Inst14Quest5_Note
Inst14Quest5_HORDE_Prequest = Inst14Quest5_Prequest
Inst14Quest5_HORDE_Folgequest = Inst14Quest5_Folgequest
Inst14Quest5PreQuest_HORDE = Inst14Quest5PreQuest
--
Inst14Quest5name1_HORDE = Inst14Quest5name1

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst14Quest6_HORDE = Inst14Quest6
Inst14Quest6_HORDE_Level = Inst14Quest6_Level
Inst14Quest6_HORDE_Attain = Inst14Quest6_Attain
Inst14Quest6_HORDE_Aim = Inst14Quest6_Aim
Inst14Quest6_HORDE_Location = Inst14Quest6_Location
Inst14Quest6_HORDE_Note = Inst14Quest6_Note
Inst14Quest6_HORDE_Prequest = Inst14Quest6_Prequest
Inst14Quest6_HORDE_Folgequest = Inst14Quest6_Folgequest
Inst14Quest6PreQuest_HORDE = Inst14Quest6PreQuest
-- No Rewards for this quest

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst14Quest7_HORDE = Inst14Quest7
Inst14Quest7_HORDE_Level = Inst14Quest7_Level
Inst14Quest7_HORDE_Attain = Inst14Quest7_Attain
Inst14Quest7_HORDE_Aim = Inst14Quest7_Aim
Inst14Quest7_HORDE_Location = Inst14Quest7_Location
Inst14Quest7_HORDE_Note = Inst14Quest7_Note
Inst14Quest7_HORDE_Prequest = Inst14Quest7_Prequest
Inst14Quest7_HORDE_Folgequest = Inst14Quest7_Folgequest
Inst14Quest7PreQuest_HORDE = Inst14Quest7PreQuest
-- No Rewards for this quest

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst14Quest8_HORDE = Inst14Quest8
Inst14Quest8_HORDE_Level = Inst14Quest8_Level
Inst14Quest8_HORDE_Attain = Inst14Quest8_Attain
Inst14Quest8_HORDE_Aim = Inst14Quest8_Aim
Inst14Quest8_HORDE_Location = Inst14Quest8_Location
Inst14Quest8_HORDE_Note = Inst14Quest8_Note
Inst14Quest8_HORDE_Prequest = Inst14Quest8_Prequest
Inst14Quest8_HORDE_Folgequest = Inst14Quest8_Folgequest
--
Inst14Quest8name1_HORDE = Inst14Quest8name1
Inst14Quest8name2_HORDE = Inst14Quest8name2

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst14Quest9_HORDE = Inst14Quest9
Inst14Quest9_HORDE_Level = Inst14Quest9_Level
Inst14Quest9_HORDE_Attain = Inst14Quest9_Attain
Inst14Quest9_HORDE_Aim = Inst14Quest9_Aim
Inst14Quest9_HORDE_Location = Inst14Quest9_Location
Inst14Quest9_HORDE_Note = Inst14Quest9_Note
Inst14Quest9_HORDE_Prequest = Inst14Quest9_Prequest
Inst14Quest9_HORDE_Folgequest = Inst14Quest9_Folgequest
-- No Rewards for this quest

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst14Quest10_HORDE = Inst14Quest10
Inst14Quest10_HORDE_Level = Inst14Quest10_Level
Inst14Quest10_HORDE_Attain = Inst14Quest10_Attain
Inst14Quest10_HORDE_Aim = Inst14Quest10_Aim
Inst14Quest10_HORDE_Location = Inst14Quest10_Location
Inst14Quest10_HORDE_Note = Inst14Quest10_Note
Inst14Quest10_HORDE_Prequest = Inst14Quest10_Prequest
Inst14Quest10_HORDE_Folgequest = Inst14Quest10_Folgequest
Inst14Quest10FQuest_HORDE = Inst14Quest10FQuest
-- No Rewards for this quest

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst14Quest11_HORDE = Inst14Quest11
Inst14Quest11_HORDE_Level = Inst14Quest11_Level
Inst14Quest11_HORDE_Attain = Inst14Quest11_Attain
Inst14Quest11_HORDE_Aim = Inst14Quest11_Aim
Inst14Quest11_HORDE_Location = Inst14Quest11_Location
Inst14Quest11_HORDE_Note = Inst14Quest11_Note
Inst14Quest11_HORDE_Prequest = Inst14Quest11_Prequest
Inst14Quest11_HORDE_Folgequest = Inst14Quest11_Folgequest
Inst14Quest11FQuest_HORDE = Inst14Quest11FQuest
--
Inst14Quest11name1_HORDE = Inst14Quest11name1
Inst14Quest11name2_HORDE = Inst14Quest11name2
Inst14Quest11name3_HORDE = Inst14Quest11name3

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst14Quest12_HORDE = Inst14Quest12
Inst14Quest12_HORDE_Level = Inst14Quest12_Level
Inst14Quest12_HORDE_Attain = Inst14Quest12_Attain
Inst14Quest12_HORDE_Aim = Inst14Quest12_Aim
Inst14Quest12_HORDE_Location = Inst14Quest12_Location
Inst14Quest12_HORDE_Note = Inst14Quest12_Note
Inst14Quest12_HORDE_Prequest = Inst14Quest12_Prequest
Inst14Quest12_HORDE_Folgequest = Inst14Quest12_Folgequest
Inst14Quest12PreQuest_HORDE = Inst14Quest12PreQuest
-- No Rewards for this quest

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst14Quest13_HORDE = Inst14Quest13
Inst14Quest13_HORDE_Level = Inst14Quest13_Level
Inst14Quest13_HORDE_Attain = Inst14Quest13_Attain
Inst14Quest13_HORDE_Aim = Inst14Quest13_Aim
Inst14Quest13_HORDE_Location = Inst14Quest13_Location
Inst14Quest13_HORDE_Note = Inst14Quest13_Note
Inst14Quest13_HORDE_Prequest = Inst14Quest13_Prequest
Inst14Quest13_HORDE_Folgequest = Inst14Quest13_Folgequest
Inst14Quest13PreQuest_HORDE = Inst14Quest13PreQuest
-- No Rewards for this quest

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst14Quest14_HORDE = Inst14Quest14
Inst14Quest14_HORDE_Level = Inst14Quest14_Level
Inst14Quest14_HORDE_Attain = Inst14Quest14_Attain
Inst14Quest14_HORDE_Aim = Inst14Quest14_Aim
Inst14Quest14_HORDE_Location = Inst14Quest14_Location
Inst14Quest14_HORDE_Note = Inst14Quest14_Note
Inst14Quest14_HORDE_Prequest = Inst14Quest14_Prequest
Inst14Quest14_HORDE_Folgequest = Inst14Quest14_Folgequest
Inst14Quest14PreQuest_HORDE = Inst14Quest14PreQuest
-- No Rewards for this quest

--Quest 15 Horde  (same as Quest 15 Alliance)
Inst14Quest15_HORDE = Inst14Quest15
Inst14Quest15_HORDE_Level = Inst14Quest15_Level
Inst14Quest15_HORDE_Attain = Inst14Quest15_Attain
Inst14Quest15_HORDE_Aim = Inst14Quest15_Aim
Inst14Quest15_HORDE_Location = Inst14Quest15_Location
Inst14Quest15_HORDE_Note = Inst14Quest15_Note
Inst14Quest15_HORDE_Prequest = Inst14Quest15_Prequest
Inst14Quest15_HORDE_Folgequest = Inst14Quest15_Folgequest
Inst14Quest15PreQuest_HORDE = Inst14Quest15PreQuest
--
Inst14Quest15name1_HORDE = Inst14Quest15name1
Inst14Quest15name2_HORDE = Inst14Quest15name2
Inst14Quest15name3_HORDE = Inst14Quest15name3
Inst14Quest15name4_HORDE = Inst14Quest15name4

--Quest 16 Horde  (same as Quest 16 Alliance)
Inst14Quest16_HORDE = Inst14Quest16
Inst14Quest16_HORDE_Level = Inst14Quest16_Level
Inst14Quest16_HORDE_Attain = Inst14Quest16_Attain
Inst14Quest16_HORDE_Aim = Inst14Quest16_Aim
Inst14Quest16_HORDE_Location = Inst14Quest16_Location
Inst14Quest16_HORDE_Note = Inst14Quest16_Note
Inst14Quest16_HORDE_Prequest = Inst14Quest16_Prequest
Inst14Quest16_HORDE_Folgequest = Inst14Quest16_Folgequest
--
Inst14Quest16name1_HORDE = Inst14Quest16name1

--Quest 17 Horde  (same as Quest 17 Alliance)
Inst14Quest17_HORDE = Inst14Quest17
Inst14Quest17_HORDE_Level = Inst14Quest17_Level
Inst14Quest17_HORDE_Attain = Inst14Quest17_Attain
Inst14Quest17_HORDE_Aim = Inst14Quest17_Aim
Inst14Quest17_HORDE_Location = Inst14Quest17_Location
Inst14Quest17_HORDE_Note = Inst14Quest17_Note
Inst14Quest17_HORDE_Prequest = Inst14Quest17_Prequest
Inst14Quest17_HORDE_Folgequest = Inst14Quest17_Folgequest
--
Inst14Quest17name1_HORDE = Inst14Quest17name1

--Quest 18 Horde
Inst14Quest18_HORDE = "18. Рамштайн"
Inst14Quest18_HORDE_Level = "60"
Inst14Quest18_HORDE_Attain = "56"
Inst14Quest18_HORDE_Aim = "Отправляйтесь в Стратхольм и убейте Рамштайна Ненасытного. Принесите его голову Натаносу в качестве сувенира."
Inst14Quest18_HORDE_Location = "Натанос Гниль (Восточные Чумные земли; "..YELLOW.."26,74"..WHITE..")"
Inst14Quest18_HORDE_Note = "Вы возьмете предшествующее задание также у Натаноса Гнили. Вы найдете Рамштайна около "..YELLOW.."[18]"..WHITE.."."
Inst14Quest18_HORDE_Prequest = "Охота на cледопытов -> Проклятый Тенекрыл" -- 6133 -> 6135
Inst14Quest18_HORDE_Folgequest = "Нет"
Inst14Quest18PreQuest_HORDE = "true"
--
Inst14Quest18name1_HORDE = "Королевская печать Алексиса"
Inst14Quest18name2_HORDE = "Обруч Стихий"

--Quest 19 Horde  (same as Quest 18 Alliance)
Inst14Quest19_HORDE = "19. Баланс Света и Тени (Жрец)"
Inst14Quest19_HORDE_Level = Inst14Quest18_Level
Inst14Quest19_HORDE_Attain = Inst14Quest18_Attain
Inst14Quest19_HORDE_Aim = Inst14Quest18_Aim
Inst14Quest19_HORDE_Location = Inst14Quest18_Location
Inst14Quest19_HORDE_Note = Inst14Quest18_Note
Inst14Quest19_HORDE_Prequest = Inst14Quest18_Prequest
Inst14Quest19_HORDE_Folgequest = Inst14Quest18_Folgequest
Inst14Quest19PreQuest_HORDE = Inst14Quest18PreQuest
--
Inst14Quest19name1_HORDE = Inst14Quest18name1



--------------- INST15 - Sunken Temple ---------------

Inst15Caption = "Затонувший храм"
Inst15QAA = "16 заданий"
Inst15QAH = "16 заданий"

--Quest 1 Alliance
Inst15Quest1 = "1. В Храме Атал'Хаккара"
Inst15Quest1_Level = "50"
Inst15Quest1_Attain = "38"
Inst15Quest1_Aim = "Соберите 10 табличек Атал'ай для Брохана Бочкопуза из Штормграда."
Inst15Quest1_Location = "Брохан Бочкопуз (Штормград - Квартал дворфов; "..YELLOW.."64,20"..WHITE..")"
Inst15Quest1_Note = "Серия предшествующих заданий начинается у того же НИП и имеет несколько этапов.\n\nВы сможете найти таблички по всему Храму, и внутри и снаружи подземелья."
Inst15Quest1_Prequest = "В поисках Храма -> Рапсодия о болоте" -- 1448 -> 1469
Inst15Quest1_Folgequest = "Нет"
Inst15Quest1PreQuest = "true"
--
Inst15Quest1name1 = "Талисман-хранитель"

--Quest 2 Alliance
Inst15Quest2 = "2. Затонувший храм"
Inst15Quest2_Level = "51"
Inst15Quest2_Attain = "46"
Inst15Quest2_Aim = "Найдите Марвона Клепальщика в Танарисе. "
Inst15Quest2_Location = "Ангелас Лунный Бриз (Фералас - Крепость Оперенной Луны; "..YELLOW.."31,45"..WHITE..")"
Inst15Quest2_Note = "Вы найдете искателя Марвон Клепальщик "..YELLOW.."52,45"..WHITE.."."
Inst15Quest2_Prequest = "Нет"
Inst15Quest2_Folgequest = "Круглый камень"
-- No Rewards for this quest

--Quest 3 Alliance
Inst15Quest3 = "3. Во глубине болот"
Inst15Quest3_Level = "51"
Inst15Quest3_Attain = "46"
Inst15Quest3_Aim = "Найдите алтарь Хаккара в затонувшем храме на Болоте Печали."
Inst15Quest3_Location = "Марвон Клепальщик (Танарис; "..YELLOW.."52,45"..WHITE..")"
Inst15Quest3_Note = "Алтарь находится около "..YELLOW.."[1]"..WHITE.."."
Inst15Quest3_Prequest = "Круглый камень"
Inst15Quest3_Folgequest = "Нет"
Inst15Quest3PreQuest = "true"
-- No Rewards for this quest

--Quest 4 Alliance
Inst15Quest4 = "4. Тайна камня"
Inst15Quest4_Level = "51"
Inst15Quest4_Attain = "46"
Inst15Quest4_Aim = "Отправляйтесь в затонувший храм и узнайте, что скрывается в круге статуй."
Inst15Quest4_Location = "Марвон Клепальщик (Танарис; "..YELLOW.."52,45"..WHITE..")"
Inst15Quest4_Note = "Вы найдете статуи около "..YELLOW.."[1]"..WHITE..". Смотрите по карте порядок их активации"
Inst15Quest4_Prequest = "Круглый камень"
Inst15Quest4_Folgequest = "Нет"
Inst15Quest4PreQuest = "true"
--
Inst15Quest4name1 = "Урна Хаккари"

--Quest 5 Alliance
Inst15Quest5 = "5. Туман зла" -- 4143
Inst15Quest5_Level = "52"
Inst15Quest5_Attain = "47"
Inst15Quest5_Aim = "Соберите 5 образцов тумана Аталаи и принесите их Муиджину в Кратер Ун'Горо."
Inst15Quest5_Location = "Греган Пивоплюй (Фералас; "..YELLOW.."45,25"..WHITE..")"
Inst15Quest5_Note = "Предшествующее задание 'Майджин и Ларион' начинается у Майджина (Кратер Ун'Горо - Укрытие Маршалла; "..YELLOW.."42,9"..WHITE.."). Вы возьмете образцы тумана с Глубинных скрытней, Мракочервей или слизнюков в Храме."
Inst15Quest5_Prequest = "Майджин и Ларион -> Визит к Грегану" -- 4141 -> 4142
Inst15Quest5_Folgequest = "Нет"
Inst15Quest5PreQuest = "true"
-- No Rewards for this quest

--Quest 6 Alliance
Inst15Quest6 = "6. Бог Хаккар"
Inst15Quest6_Level = "53"
Inst15Quest6_Attain = "40"
Inst15Quest6_Aim = "Отнесите заполненное яйцо Хаккара Йе'кинье в Танарис."
Inst15Quest6_Location = "Йе'кинья (Танарис - Порт Картеля; "..YELLOW.."66,22"..WHITE..")"
Inst15Quest6_Note = "Цепочка заданий начинается с 'Духи крикунов' у того же НИП (См. "..YELLOW.."[Зул'Фаррак]"..WHITE..").\nВы должны задействовать Яйцо около "..YELLOW.."[3]"..WHITE.." чтобы начать призыв. Когда он начнется, появятся враги и атакуют Вас. С некоторых их них добывается Кровь Хаккара. С этой кровью вы можете убрать факелы вокруг круга. После этого появится Аватара Хаккара. Вы убьете ее и получите Сущность Хаккара Которую используете, чтобы наполнить яйцо."
Inst15Quest6_Prequest = "Духи крикунов -> Древнее яйцо" -- 3520 -> 4787
Inst15Quest6_Folgequest = "Нет"
Inst15Quest6PreQuest = "true"
--
Inst15Quest6name1 = "Шлем Авангарда"
Inst15Quest6name2 = "Кортик Жизнесилы"
Inst15Quest6name3 = "Драгоценный венец"

--Quest 7 Alliance
Inst15Quest7 = "7. Джаммал'ан Пророк"
Inst15Quest7_Level = "53"
Inst15Quest7_Attain = "38"
Inst15Quest7_Aim = "Принесите изгнаннику Атал'ай из Внутренних земель голову Джаммал'ана."
Inst15Quest7_Location = "Изгнанник Атал'ай (Внутренние земли; "..YELLOW.."33,75"..WHITE..")"
Inst15Quest7_Note = "Вы найдете Джаммал'ана около "..YELLOW.."[4]"..WHITE.."."
Inst15Quest7_Prequest = "Нет"
Inst15Quest7_Folgequest = "Нет"
--
Inst15Quest7name1 = "Поножи Странника дождя"
Inst15Quest7name2 = "Шлем Изгнания"

--Quest 8 Alliance
Inst15Quest8 = "8. Сущность Эраникуса"
Inst15Quest8_Level = "55"
Inst15Quest8_Attain = "48"
Inst15Quest8_Aim = "Поместите сущность Эраникуса в купель сущности в его логове в затонувшем храме."
Inst15Quest8_Location = "Сущность Эраникуса (добывается с Тени Эраникуса; "..YELLOW.."[6]"..WHITE..")"
Inst15Quest8_Note = "Вы найдете Купель сущности рядом с местом где находится Тень Эраникуса около "..YELLOW.."[6]"..WHITE.."."
Inst15Quest8_Prequest = "Нет"
Inst15Quest8_Folgequest = "Нет"
--
Inst15Quest8name1 = "Скованная Сущность Эраникуса"

--Quest 9 Alliance
Inst15Quest9 = "9. Тролли Пера(Чернокнижник)"
Inst15Quest9_Level = "52"
Inst15Quest9_Attain = "50"
Inst15Quest9_Aim = "Принесите 6 вудуистских перьев троллей из затонувшего храма."
Inst15Quest9_Location = "Бесенок (Оскверненный лес; "..YELLOW.."42,45"..WHITE..")"
Inst15Quest9_Note = "Задание для чернокнижников: Перо добывается с каждого из названных троллей на выступах с видом на большую комнату с отверстием в центре."
Inst15Quest9_Prequest = "Просьба беса -> Бросовый материал" -- 8419 -> 8421
Inst15Quest9_Folgequest = "Нет"
Inst15Quest9PreQuest = "true"
--
Inst15Quest9name1 = "Жнец душ"
Inst15Quest9name2 = "Осколок Бездны"
Inst15Quest9name3 = "Одеяния служения"

--Quest 10 Alliance
Inst15Quest10 = "10. Вудуистские перья(Воин)"
Inst15Quest10_Level = "52"
Inst15Quest10_Attain = "50"
Inst15Quest10_Aim = "Принесите вудуистские перья павшему герою Орды, забрав их у троллей в Затонувшем Храме."
Inst15Quest10_Location = "Павший герой Орды (Болото Печали; "..YELLOW.."34,66"..WHITE..")"
Inst15Quest10_Note = "Задание для воинов: Перо добывается с каждого из названных троллей на выступах с видом на большую комнату с отверстием в центре."
Inst15Quest10_Prequest = "Неупокоенный дух -> Война против Приверженцев Тени" -- 8417 -> 8424
Inst15Quest10_Folgequest = "Нет"
Inst15Quest10PreQuest = "true"
--
Inst15Quest10name1 = "Щиток Ярости"
Inst15Quest10name2 = "Алмазная фляжка"
Inst15Quest10name3 = "Остростальные наплечники"

--Quest 11 Alliance
Inst15Quest11 = "11. Лучший ингредиент(Друид)"
Inst15Quest11_Level = "52"
Inst15Quest11_Attain = "50"
Inst15Quest11_Aim = "Возьмите гнилую лозу у стража на дне затонувшего храма и вернитесь к Землепроходцу Торве."
Inst15Quest11_Location = "Землепроходец Торва (Кратер Ун'Горо; "..YELLOW.."72,76"..WHITE..")"
Inst15Quest11_Note = "Задание для друидов: Гнилая лоза добывается с Атал'алариона, который вызывается около "..YELLOW.."[1]"..WHITE.." активизируя статуи в порядке, указанном на карте."
Inst15Quest11_Prequest = "Землепроходец Торва -> Испытание яда" -- 9063 -> 9051
Inst15Quest11_Folgequest = "Нет"
Inst15Quest11PreQuest = "true"
--
Inst15Quest11name1 = "Седая шкура"
Inst15Quest11name2 = "Облачение Леса"
Inst15Quest11name3 = "Посох Лунной тени"

--Quest 12 Alliance
Inst15Quest12 = "12. Зеленый дракон(Охотник)"
Inst15Quest12_Level = "52"
Inst15Quest12_Attain = "50"
Inst15Quest12_Aim = "Принесите зуб Морфаза Огтинку в Азшару. Огтинк обитает среди скал в северо-востоку от руин Эльдарата."
Inst15Quest12_Location = "Огтинк (Азшара; "..YELLOW.."42,43"..WHITE..")"
Inst15Quest12_Note = "Задание для охотников: Морфаз около "..YELLOW.."[5]"..WHITE.."."
Inst15Quest12_Prequest = "Талисман охотника -> Охота на волношлепа" -- 8151 -> 8231
Inst15Quest12_Folgequest = "Нет"
Inst15Quest12PreQuest = "true"
--
Inst15Quest12name1 = "Охотничье копье"
Inst15Quest12name2 = "Глаз девизавра"
Inst15Quest12name3 = "Зуб девизавра"

--Quest 13 Alliance
Inst15Quest13 = "13. Уничтожить Морфаза(Маг)"
Inst15Quest13_Level = "52"
Inst15Quest13_Attain = "50"
Inst15Quest13_Aim = "Добудьте кристалл тайной магии из брюха Морфаза и принесите его верховному магу Ксилему."
Inst15Quest13_Location = "Верховный маг Ксилем (Азшара; "..YELLOW.."29,40"..WHITE..")"
Inst15Quest13_Note = "Задание для магов: Морфаз около "..YELLOW.."[5]"..WHITE.."."
Inst15Quest13_Prequest = "Волшебная пыль -> Кораллы сирен" -- 8251 -> 8252
Inst15Quest13_Folgequest = "Нет"
Inst15Quest13PreQuest = "true"
--
Inst15Quest13name1 = "Ледовый шип"
Inst15Quest13name2 = "Подвеска из чародейного кристалла"
Inst15Quest13name3 = "Огненный рубин"

--Quest 14 Alliance
Inst15Quest14 = "14. Кровь Морфаза(Жрец)"
Inst15Quest14_Level = "52"
Inst15Quest14_Attain = "50"
Inst15Quest14_Aim = "Убейте Морфаза в затонувшем Храме Атал'Хаккара и принесите его кровь Грете Замшелому Копыту в Оскверненный лес. Вход в храм сокрыт на Болоте Печали."
Inst15Quest14_Location = "Огтинк (Азшара; "..YELLOW.."42,43"..WHITE..")"
Inst15Quest14_Note = "Задание для жрецов: Морфаз около "..YELLOW.."[5]"..WHITE..". Грета Замшелое Копыто находится в Оскверненном лесу - Изумрудное святилище ("..YELLOW.."51,82"..WHITE..")."
Inst15Quest14_Prequest = "Помощь Кенарию -> Лимфа нежити" -- 8254 -> 8256
Inst15Quest14_Folgequest = "Нет"
Inst15Quest14PreQuest = "true"
--
Inst15Quest14name1 = "Благословенные четки"
Inst15Quest14name2 = "Горепосох"
Inst15Quest14name3 = "Обруч Надежды"

--Quest 15 Alliance
Inst15Quest15 = "15. Лазурный ключ(Разбойник)"
Inst15Quest15_Level = "52"
Inst15Quest15_Attain = "50"
Inst15Quest15_Aim = "Принесите лазурный ключ лорду Черному Ворону."
Inst15Quest15_Location = "Верховный маг Ксилем (Азшара; "..YELLOW.."29,40"..WHITE..")"
Inst15Quest15_Note = "Задание для разбойников: Лазурный ключ добывается с Морфаз около "..YELLOW.."[5]"..WHITE..". Лорд Джорах Черный Ворон находится в Альтеракских горах - Поместье Черного Ворона ("..YELLOW.."86,79"..WHITE..")."
Inst15Quest15_Prequest = "Приглашение -> Зашифрованные фрагменты" -- 8233 -> 8235
Inst15Quest15_Folgequest = "Нет"
Inst15Quest15PreQuest = "true"
--
Inst15Quest15name1 = "Эбеновая маска"
Inst15Quest15name2 = "Сапоги шелеста шагов"
Inst15Quest15name3 = "Пелерина из сумеречницы"

--Quest 16 Alliance
Inst15Quest16 = "16. Создание камня силы(Паладин)"
Inst15Quest16_Level = "52"
Inst15Quest16_Attain = "50"
Inst15Quest16_Aim = "Принесите вудуистские перья Ашламу Неутомимому."
Inst15Quest16_Location = "Командир Ашлам Неутомимый (Западные Чумные земли - Лагерь Промозглого Ветра; "..YELLOW.."43,85"..WHITE..")"
Inst15Quest16_Note = "Задание для паладинов: Перо добывается с каждого из названных троллей на выступах с видом на большую комнату с отверстием в центре."
Inst15Quest16_Prequest = "Бездействующие камни Плети" -- 8416
Inst15Quest16_Folgequest = "Нет"
Inst15Quest16PreQuest = "true"
--
Inst15Quest16name1 = "Священный камень силы"
Inst15Quest16name2 = "Клинок из светлостали"
Inst15Quest16name3 = "Освященная сфера"
Inst15Quest16name4 = "Рыцарский перстень"


--Quest 1 Horde
Inst15Quest1_HORDE = "1. Храм Атал'Хаккара"
Inst15Quest1_HORDE_Level = "50"
Inst15Quest1_HORDE_Attain = "38"
Inst15Quest1_HORDE_Aim = "Соберите 20 фетишей Хаккара и принесите их Фел'зерулу в Каменор."
Inst15Quest1_HORDE_Location = "Фел'зерул (Болото Печали - Каменор; "..YELLOW.."47,54"..WHITE..")"
Inst15Quest1_HORDE_Note = "Фетиши падают со всех врагов."
Inst15Quest1_HORDE_Prequest = "Озеро Слез -> Возвращение к Фел'зерулу" -- 1424 -> 1444
Inst15Quest1_HORDE_Folgequest = "Нет"
Inst15Quest1PreQuest_HORDE = "true"
--
Inst15Quest1name1_HORDE = "Талисман-хранитель"

--Quest 2 Horde
Inst15Quest2_HORDE = "2. Затонувший храм"
Inst15Quest2_HORDE_Level = "51"
Inst15Quest2_HORDE_Attain = "46"
Inst15Quest2_HORDE_Aim = "Найдите Марвона Клепальщика в Танарисе"
Inst15Quest2_HORDE_Location = "Знахарь Узер'и (Фералас; "..YELLOW.."74,43"..WHITE..")"
Inst15Quest2_HORDE_Note = "Вы найдете искателя Марвон Клепальщик "..YELLOW.."52,45"..WHITE.."."
Inst15Quest2_HORDE_Prequest = "Нет"
Inst15Quest2_HORDE_Folgequest = "Круглый камень"
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst15Quest3_HORDE = Inst15Quest3
Inst15Quest3_HORDE_Level = Inst15Quest3_Level
Inst15Quest3_HORDE_Attain = Inst15Quest3_Attain
Inst15Quest3_HORDE_Aim = Inst15Quest3_Aim
Inst15Quest3_HORDE_Location = Inst15Quest3_Location
Inst15Quest3_HORDE_Note = Inst15Quest3_Note
Inst15Quest3_HORDE_Prequest = Inst15Quest3_Prequest
Inst15Quest3_HORDE_Folgequest = Inst15Quest3_Folgequest
Inst15Quest3PreQuest_HORDE = Inst15Quest3PreQuest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst15Quest4_HORDE = Inst15Quest4
Inst15Quest4_HORDE_Level = Inst15Quest4_Level
Inst15Quest4_HORDE_Attain = Inst15Quest4_Attain
Inst15Quest4_HORDE_Aim = Inst15Quest4_Aim
Inst15Quest4_HORDE_Location = Inst15Quest4_Location
Inst15Quest4_HORDE_Note = Inst15Quest4_Note
Inst15Quest4_HORDE_Prequest = Inst15Quest4_Prequest
Inst15Quest4_HORDE_Folgequest = Inst15Quest4_Folgequest
Inst15Quest4PreQuest_HORDE = Inst15Quest4PreQuest
--
Inst15Quest4name1_HORDE = Inst15Quest4name1

--Quest 5 Horde
Inst15Quest5_HORDE = "5. Питание для шокера"
Inst15Quest5_HORDE_Level = "52"
Inst15Quest5_HORDE_Attain = "47"
Inst15Quest5_HORDE_Aim = "Доставьте незаряженный шокер и 5 образцов тумана Аталаи Лариону в Укрытие Маршалла"
Inst15Quest5_HORDE_Location = "Лив Быстрочин (Степи; "..YELLOW.."62,38"..WHITE..")"
Inst15Quest5_HORDE_Note = "Предшествующее задание 'Ларион и Майджин' начинается у Лариона (Кратер Ун'Горо; "..YELLOW.."45,8"..WHITE.."). Вы возьмете образцы тумана с Глубинных скрытней, Мракочервей или слизнюков в Храме."
Inst15Quest5_HORDE_Prequest = "Ларион и Майджин -> Мастерская Марвона" -- 4145 -> 4147
Inst15Quest5_HORDE_Folgequest = "Нет"
Inst15Quest5PreQuest_HORDE = "true"

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst15Quest6_HORDE = Inst15Quest6
Inst15Quest6_HORDE_Level = Inst15Quest6_Level
Inst15Quest6_HORDE_Attain = Inst15Quest6_Attain
Inst15Quest6_HORDE_Aim = Inst15Quest6_Aim
Inst15Quest6_HORDE_Location = Inst15Quest6_Location
Inst15Quest6_HORDE_Note = Inst15Quest6_Note
Inst15Quest6_HORDE_Prequest = Inst15Quest6_Prequest
Inst15Quest6_HORDE_Folgequest = Inst15Quest6_Folgequest
Inst15Quest6PreQuest_HORDE = Inst15Quest6PreQuest
--
Inst15Quest6name1_HORDE = Inst15Quest6name1
Inst15Quest6name2_HORDE = Inst15Quest6name2
Inst15Quest6name3_HORDE = Inst15Quest6name3

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst15Quest7_HORDE = Inst15Quest7
Inst15Quest7_HORDE_Level = Inst15Quest7_Level
Inst15Quest7_HORDE_Attain = Inst15Quest7_Attain
Inst15Quest7_HORDE_Aim = Inst15Quest7_Aim
Inst15Quest7_HORDE_Location = Inst15Quest7_Location
Inst15Quest7_HORDE_Note = Inst15Quest7_Note
Inst15Quest7_HORDE_Prequest = Inst15Quest7_Prequest
Inst15Quest7_HORDE_Folgequest = Inst15Quest7_Folgequest
--
Inst15Quest7name1_HORDE = Inst15Quest7name1
Inst15Quest7name2_HORDE = Inst15Quest7name2

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst15Quest8_HORDE = Inst15Quest8
Inst15Quest8_HORDE_Level = Inst15Quest8_Level
Inst15Quest8_HORDE_Attain = Inst15Quest8_Attain
Inst15Quest8_HORDE_Aim = Inst15Quest8_Aim
Inst15Quest8_HORDE_Location = Inst15Quest8_Location
Inst15Quest8_HORDE_Note = Inst15Quest8_Note
Inst15Quest8_HORDE_Prequest = Inst15Quest8_Prequest
Inst15Quest8_HORDE_Folgequest = Inst15Quest8_Folgequest
--
Inst15Quest8name1_HORDE = Inst15Quest8name1

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst15Quest9_HORDE = Inst15Quest9
Inst15Quest9_HORDE_Level = Inst15Quest9_Level
Inst15Quest9_HORDE_Attain = Inst15Quest9_Attain
Inst15Quest9_HORDE_Aim = Inst15Quest9_Aim
Inst15Quest9_HORDE_Location = Inst15Quest9_Location
Inst15Quest9_HORDE_Note = Inst15Quest9_Note
Inst15Quest9_HORDE_Prequest = Inst15Quest9_Prequest
Inst15Quest9_HORDE_Folgequest = Inst15Quest9_Folgequest
Inst15Quest9PreQuest_HORDE = Inst15Quest9PreQuest
--
Inst15Quest9name1_HORDE = Inst15Quest9name1
Inst15Quest9name2_HORDE = Inst15Quest9name2
Inst15Quest9name3_HORDE = Inst15Quest9name3

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst15Quest10_HORDE = Inst15Quest10
Inst15Quest10_HORDE_Level = Inst15Quest10_Level
Inst15Quest10_HORDE_Attain = Inst15Quest10_Attain
Inst15Quest10_HORDE_Aim = Inst15Quest10_Aim
Inst15Quest10_HORDE_Location = Inst15Quest10_Location
Inst15Quest10_HORDE_Note = Inst15Quest10_Note
Inst15Quest10_HORDE_Prequest = Inst15Quest10_Prequest
Inst15Quest10_HORDE_Folgequest = Inst15Quest10_Folgequest
Inst15Quest10PreQuest_HORDE = Inst15Quest10PreQuest
--
Inst15Quest10name1_HORDE = Inst15Quest10name1
Inst15Quest10name2_HORDE = Inst15Quest10name2
Inst15Quest10name3_HORDE = Inst15Quest10name3

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst15Quest11_HORDE = Inst15Quest11
Inst15Quest11_HORDE_Level = Inst15Quest11_Level
Inst15Quest11_HORDE_Attain = Inst15Quest11_Attain
Inst15Quest11_HORDE_Aim = Inst15Quest11_Aim
Inst15Quest11_HORDE_Location = Inst15Quest11_Location
Inst15Quest11_HORDE_Note = Inst15Quest11_Note
Inst15Quest11_HORDE_Prequest = Inst15Quest11_Prequest
Inst15Quest11_HORDE_Folgequest = Inst15Quest11_Folgequest
Inst15Quest11PreQuest_HORDE = Inst15Quest11PreQuest
--
Inst15Quest11name1_HORDE = Inst15Quest11name1
Inst15Quest11name2_HORDE = Inst15Quest11name2
Inst15Quest11name3_HORDE = Inst15Quest11name3

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst15Quest12_HORDE = Inst15Quest12
Inst15Quest12_HORDE_Level = Inst15Quest12_Level
Inst15Quest12_HORDE_Attain = Inst15Quest12_Attain
Inst15Quest12_HORDE_Aim = Inst15Quest12_Aim
Inst15Quest12_HORDE_Location = Inst15Quest12_Location
Inst15Quest12_HORDE_Note = Inst15Quest12_Note
Inst15Quest12_HORDE_Prequest = Inst15Quest12_Prequest
Inst15Quest12_HORDE_Folgequest = Inst15Quest12_Folgequest
Inst15Quest12PreQuest_HORDE = Inst15Quest12PreQuest
--
Inst15Quest12name1_HORDE = Inst15Quest12name1
Inst15Quest12name2_HORDE = Inst15Quest12name2
Inst15Quest12name3_HORDE = Inst15Quest12name3

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst15Quest13_HORDE = Inst15Quest13
Inst15Quest13_HORDE_Level = Inst15Quest13_Level
Inst15Quest13_HORDE_Attain = Inst15Quest13_Attain
Inst15Quest13_HORDE_Aim = Inst15Quest13_Aim
Inst15Quest13_HORDE_Location = Inst15Quest13_Location
Inst15Quest13_HORDE_Note = Inst15Quest13_Note
Inst15Quest13_HORDE_Prequest = Inst15Quest13_Prequest
Inst15Quest13_HORDE_Folgequest = Inst15Quest13_Folgequest
Inst15Quest13PreQuest_HORDE = Inst15Quest13PreQuest
--
Inst15Quest13name1_HORDE = Inst15Quest13name1
Inst15Quest13name2_HORDE = Inst15Quest13name2
Inst15Quest13name3_HORDE = Inst15Quest13name3

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst15Quest14_HORDE = Inst15Quest14
Inst15Quest14_HORDE_Level = Inst15Quest14_Level
Inst15Quest14_HORDE_Attain = Inst15Quest14_Attain
Inst15Quest14_HORDE_Aim = Inst15Quest14_Aim
Inst15Quest14_HORDE_Location = Inst15Quest14_Location
Inst15Quest14_HORDE_Note = Inst15Quest14_Note
Inst15Quest14_HORDE_Prequest = Inst15Quest14_Prequest
Inst15Quest14_HORDE_Folgequest = Inst15Quest14_Folgequest
Inst15Quest14PreQuest_HORDE = Inst15Quest14PreQuest
--
Inst15Quest14name1_HORDE = Inst15Quest14name1
Inst15Quest14name2_HORDE = Inst15Quest14name2
Inst15Quest14name3_HORDE = Inst15Quest14name3

--Quest 15 Horde  (same as Quest 15 Alliance)
Inst15Quest15_HORDE = Inst15Quest15
Inst15Quest15_HORDE_Level = Inst15Quest15_Level
Inst15Quest15_HORDE_Attain = Inst15Quest15_Attain
Inst15Quest15_HORDE_Aim = Inst15Quest15_Aim
Inst15Quest15_HORDE_Location = Inst15Quest15_Location
Inst15Quest15_HORDE_Note = Inst15Quest15_Note
Inst15Quest15_HORDE_Prequest = Inst15Quest15_Prequest
Inst15Quest15_HORDE_Folgequest = Inst15Quest15_Folgequest
Inst15Quest15PreQuest_HORDE = Inst15Quest15PreQuest
--
Inst15Quest15name1_HORDE = Inst15Quest15name1
Inst15Quest15name2_HORDE = Inst15Quest15name2
Inst15Quest15name3_HORDE = Inst15Quest15name3

--Quest 16 Horde  (same as Quest 16 Alliance)
Inst15Quest16_HORDE = Inst15Quest16
Inst15Quest16_HORDE_Level = Inst15Quest16_Level
Inst15Quest16_HORDE_Attain = Inst15Quest16_Attain
Inst15Quest16_HORDE_Aim = Inst15Quest16_Aim
Inst15Quest16_HORDE_Location = Inst15Quest16_Location
Inst15Quest16_HORDE_Note = Inst15Quest16_Note
Inst15Quest16_HORDE_Prequest = Inst15Quest16_Prequest
Inst15Quest16_HORDE_Folgequest = Inst15Quest16_Folgequest
Inst15Quest16PreQuest_HORDE = Inst15Quest16PreQuest
--
Inst15Quest16name1_HORDE = Inst15Quest16name1
Inst15Quest16name2_HORDE = Inst15Quest16name2
Inst15Quest16name3_HORDE = Inst15Quest16name3



--------------- INST16 - Uldaman ---------------

Inst16Caption = "Ульдаман"
Inst16QAA = "17 заданий"
Inst16QAH = "11 заданий"

--Quest 1 Alliance
Inst16Quest1 = "1. Предвестник надежды" -- 721
Inst16Quest1_Level = "35"
Inst16Quest1_Attain = "35"
Inst16Quest1_Aim = "Найдите Греза Тяжелоступа в Ульдамане."
Inst16Quest1_Location = "Геолог Ржанец (Бесплодные земли; "..YELLOW.."53,43"..WHITE..")"
Inst16Quest1_Note = "Предшествующее задание начинается с Мятой карты (Бесплодные земли; "..YELLOW.."53,33"..WHITE..").\nВы найдете Тяжелоступа Греза перед тем как вы войдете в подземелье."
Inst16Quest1_Prequest = "Предвестник надежды" -- 720
Inst16Quest1_Folgequest = "Амулет Тайн" -- 722
Inst16Quest1PreQuest = "true"
-- No Rewards for this quest

--Quest 2 Alliance
Inst16Quest2 = "2. Амулет Тайн"
Inst16Quest2_Level = "40"
Inst16Quest2_Attain = "35"
Inst16Quest2_Aim = "Найдите амулет Тяжелоступа и верните его ему в Ульдаман."
Inst16Quest2_Location = "Тяжелоступ Грез (Ульдаман)."
Inst16Quest2_Note = "Амулет добывается из Магрегана Чернотени."
Inst16Quest2_Prequest = "Предвестник надежды" -- 721
Inst16Quest2_Folgequest = "Клятва верности" -- 723
Inst16Quest2FQuest = "true"
-- No Rewards for this quest

--Quest 3 Alliance
Inst16Quest3 = "3. Утерянные таблички Воли" -- 1139
Inst16Quest3_Level = "45"
Inst16Quest3_Attain = "35"
Inst16Quest3_Aim = "Найдите табличку Воли и принесите ее советнику Белграму в Стальгорн."
Inst16Quest3_Location = "Советник Белгрум (Стальгорн - Зал исследователей; "..YELLOW.."77,10"..WHITE..")"
Inst16Quest3_Note = "Табличка находится около "..YELLOW.."[8]"..WHITE.."."
Inst16Quest3_Prequest = "Амулет Тайн -> Посланник Зла" -- 722 -> 762
Inst16Quest3_Folgequest = "Нет"
Inst16Quest3FQuest = "true"
--
Inst16Quest3name1 = "Медаль за отвагу"

--Quest 4 Alliance
Inst16Quest4 = "4. Камни Силы" -- 2418
Inst16Quest4_Level = "36"
Inst16Quest4_Attain = "30"
Inst16Quest4_Aim = "Принесите 8 дентриевых силовых камней и 8 энелиевых силовых камней Ригглфаззу в Бесплодные земли."
Inst16Quest4_Location = "Ригглфазз (Бесплодные земли; "..YELLOW.."42,52"..WHITE..")"
Inst16Quest4_Note = "Камни можно найти на любом враге из клана Тенегорна перед и внутри подземелья."
Inst16Quest4_Prequest = "Нет"
Inst16Quest4_Folgequest = "Нет"
--
Inst16Quest4name1 = "Заряженный круглый камень"
Inst16Quest4name2 = "Дюрациновые наручи"
Inst16Quest4name3 = "Долговечные сапоги"

--Quest 5 Alliance
Inst16Quest5 = "5. Судьба Эгмонда" -- 704
Inst16Quest5_Level = "38"
Inst16Quest5_Attain = "30"
Inst16Quest5_Aim = "Принесите 4 резные каменные урны геологу Сталекруту в Лок Модан."
Inst16Quest5_Location = "Геолог Сталекрут (Лок Модан - Раскопки Сталекрута; "..YELLOW.."65,65"..WHITE..")"
Inst16Quest5_Note = "Предшествующее задание начинается у геолога Грозовой Вершины (Стальгорн - Зал исследователей; "..YELLOW.."74,12"..WHITE..").\nУрны расбросаны по пещерам перед подземельем."
Inst16Quest5_Prequest = "Вы нужны Сталекруту! -> Мурдалок" -- 707 -> 739
Inst16Quest5_Folgequest = "Нет"
Inst16Quest5PreQuest = "true"
--
Inst16Quest5name1 = "Перчатки геолога"

--Quest 6 Alliance
Inst16Quest6 = "6. Лекарство от судьбы" -- 709
Inst16Quest6_Level = "40"
Inst16Quest6_Attain = "30"
Inst16Quest6_Aim = "Принесите табличку Рьюн'эха Тельдарину Заблудшему."
Inst16Quest6_Location = "Тельдарин Заблудший (Бесплодные земли; "..YELLOW.."51,76"..WHITE..")"
Inst16Quest6_Note = "Табличка находится на севере пещер, в восточном конце туннеля, перед подземельем."
Inst16Quest6_Prequest = "Нет"
Inst16Quest6_Folgequest = "В Стальгорн за книгой Йагина" -- 727
--
Inst16Quest6name1 = "Одеяние Вестника рока"

--Quest 7 Alliance
Inst16Quest7 = "7. Потерянные дворфы" -- 2398
Inst16Quest7_Level = "40"
Inst16Quest7_Attain = "35"
Inst16Quest7_Aim = "Найдите Бейлога в Ульдамане."
Inst16Quest7_Location = "Геолог Грозовая Вершина (Стальгорн - Зал исследователей; "..YELLOW.."75,12"..WHITE..")"
Inst16Quest7_Note = "Бейлог находится около "..YELLOW.."[1]"..WHITE.."."
Inst16Quest7_Prequest = "Нет"
Inst16Quest7_Folgequest = "Потайной чертог" -- 2240
-- No Rewards for this quest

--Quest 8 Alliance
Inst16Quest8 = "8. Потайной чертог" -- 2240
Inst16Quest8_Level = "40"
Inst16Quest8_Attain = "35"
Inst16Quest8_Aim = "Прочитайте журнал Бейлога, исследуйте потайной чертог и потом доложите об увиденном геологу Грозовой Вершине."
Inst16Quest8_Location = "Бейлог (Ульдаман; "..YELLOW.."[1]"..WHITE..")"
Inst16Quest8_Note = "Тайная комната находится около "..YELLOW.."[4]"..WHITE..". Чтобы открыть тайную комнату вам понадобится Стержень Тсола с Ревелоша "..YELLOW.."[3]"..WHITE.." и Медальон Гни'кив из сундука Баэлога "..YELLOW.."[1]"..WHITE..". Соберите из этих предметов Доисторический посох. Посох используется в Комнате Карты между "..YELLOW.."[3] и [4]"..WHITE.." для вызова Иронаи. После того как убьете её, забегите в комнату откуда она пришла, чтобы выполнить задание."
Inst16Quest8_Prequest = "Потерянные дворфы" -- 2398
Inst16Quest8_Folgequest = "Нет"
Inst16Quest8FQuest = "true"
--
Inst16Quest8name1 = "Дворфийский натиск"
Inst16Quest8name2 = "Путеводная звезда Лиги исследователей"

--Quest 9 Alliance
Inst16Quest9 = "9. Рассыпавшееся ожерелье" -- 2198
Inst16Quest9_Level = "41"
Inst16Quest9_Attain = "37"
Inst16Quest9_Aim = "Найдите создателя ожерелья, чтобы узнать, чего оно стоит."
Inst16Quest9_Location = "Рассыпавшееся ожерелье (добывается случайно в Ульдамане)"
Inst16Quest9_Note = "Принесите ожерелье Талвашу де Кисселю (Стальгорн - Палаты Магии; "..YELLOW.."36,3"..WHITE..")."
Inst16Quest9_Prequest = "Нет"
Inst16Quest9_Folgequest = "Мудрость за деньги" -- 2199
-- No Rewards for this quest

--Quest 10 Alliance
Inst16Quest10 = "10. Назад в Ульдаман" -- 2200
Inst16Quest10_Level = "42"
Inst16Quest10_Attain = "37"
Inst16Quest10_Aim = "Выясните, где именно в Ульдамане находится ожерелье Талваша. Убитый паладин, о котором он упоминал, был последним владельцем этого ожерелья."
Inst16Quest10_Location = "Талваш дель Киссель (Стальгорн - Палаты магии; "..YELLOW.."36,3"..WHITE..")"
Inst16Quest10_Note = "Паладин находится около "..YELLOW.."[2]"..WHITE.."."
Inst16Quest10_Prequest = "Мудрость за деньги" -- 2199
Inst16Quest10_Folgequest = "Время собирать камни" -- 2201
Inst16Quest10FQuest = "true"
-- No Rewards for this quest

--Quest 11 Alliance
Inst16Quest11 = "11. Время собирать камни" -- 2201
Inst16Quest11_Level = "43"
Inst16Quest11_Attain = "37"
Inst16Quest11_Aim = "Найдите рубин, сапфир, и топаз, которые спрятаны в разных местах Ульдамана. Когда найдете, свяжитесь с Талвашем дель Кисселем, используя фиал Видения, который он предоставил."
Inst16Quest11_Location = "Останки паладина (Ульдаман; "..YELLOW.."[2]"..WHITE..")"
Inst16Quest11_Note = "Камни находятся около "..YELLOW.."[1]"..WHITE.." в урне, "..YELLOW.."[8]"..WHITE.." из тайника клана Теневого горна, и "..YELLOW.."[9]"..WHITE.." с Гримлока. Обратите внимание, что когда вы откроете тайник, появятся несколько мобов и атакуют Вас.\nИспользуйте Чашу прорицания Талваша, чтобы сдать задание и продожить дальше."
Inst16Quest11_Prequest = "Назад в Ульдаман" -- 2200
Inst16Quest11_Folgequest = "Восстановление ожерелья" -- 2204
Inst16Quest11FQuest = "true"
-- No Rewards for this quest

--Quest 12 Alliance
Inst16Quest12 = "12. Восстановление ожерелья" -- 2204
Inst16Quest12_Level = "44"
Inst16Quest12_Attain = "37"
Inst16Quest12_Aim = "Добудьте источник энергии из самого мощного волшебного создания, которое найдете в Ульдамане и доставьте его Талвашу дель Кисселю в Стальгорн."
Inst16Quest12_Location = "Гадальная чаша Талваша"
Inst16Quest12_Note = "Источник силы сломанного ожерелья добывается с Архедаса "..YELLOW.."[10]"..WHITE.."."
Inst16Quest12_Prequest = "Время собирать камни" -- 2201
Inst16Quest12_Folgequest = "Нет"
--
Inst16Quest12name1 = "Ожерелье Усиления Талваш"
Inst16Quest12FQuest = "true"

--Quest 13 Alliance
Inst16Quest13 = "13. В Ульдаман за реактивом" -- 17
Inst16Quest13_Level = "42"
Inst16Quest13_Attain = "38"
Inst16Quest13_Aim = "Принесите 12 грибов-малиновиков Гхаку Целителю в Телcамар."
Inst16Quest13_Location = "Гхак Целитель (Лок Модан - Телсамар; "..YELLOW.."37,49"..WHITE..")"
Inst16Quest13_Note = "Грибы есть по всему подземелью. Травники могут видеть их на миникарте, если включен Поиск трав и они взяли задание."
Inst16Quest13_Prequest = "Пробежка по Бесплодным землям"  -- 2500
Inst16Quest13_Folgequest = "Нет"
Inst16Quest13PreQuest = "true"
--
Inst16Quest13name1 = "Приводящее в сознание зелье"

--Quest 14 Alliance
Inst16Quest14 = "14. Возвращенные сокровища" -- 1360
Inst16Quest14_Level = "43"
Inst16Quest14_Attain = "33"
Inst16Quest14_Aim = "Достаньте сокровище Крома Крепкорука из сундука в северном зале Ульдамана и принесите ему в Стальгорн."
Inst16Quest14_Location = "Кром Крепкорук (Стальгорн - Зал исследователей; "..YELLOW.."74,9"..WHITE..")"
Inst16Quest14_Note = "Вы найдете сокровище перед тем как войдете в подземелье. Оно на севере пещер, в юговосточном конце тоннеля."
Inst16Quest14_Prequest = "Нет"
Inst16Quest14_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 15 Alliance
Inst16Quest15 = "15. Платиновые диски" -- 2278 -> 2439
Inst16Quest15_Level = "47"
Inst16Quest15_Attain = "40"
Inst16Quest15_Aim = "Поговорите с каменным Стражем и запомните все, что он передаст вам. Когда он закончит свой пересказ событий древности, активируйте диски Норганнона. -> Отнесите миниатюрную копию дисков Норганнона в Лигу Исследователей в Стальгорне."
Inst16Quest15_Location = "Диски Нограннона (Ульдаман; "..YELLOW.."[11]"..WHITE..")"
Inst16Quest15_Note = "После получения задания, поговорите с каменным стражем слева от дисков.  Потом снова используйте платиновые диски, чтобы получить миниатюрную копию, которую вы должны принести старшему исследователю Магелласу в Стальгорн - Зал исследователей ("..YELLOW.."69,18"..WHITE.."). Здесь есть другая линейка, которая называется Посмотрим что произойдет и начинается у историка Карника Стальгорн - Зал исследователей."
Inst16Quest15_Prequest = "Нет"
Inst16Quest15_Folgequest = "Ульдумские чудеса" -- 2963
--
Inst16Quest15name1 = "Сума из мягкой кожи"
Inst16Quest15name2 = "Наилучшее лечебное зелье"
Inst16Quest15name3 = "Сильное зелье маны"

--Quest 16 Alliance
Inst16Quest16 = "16. Сила Ульдамана" -- 1956
Inst16Quest16_Level = "40"
Inst16Quest16_Attain = "35"
Inst16Quest16_Aim = "Добудьте обсидиановый источник силы и принесите его Табете в Пылевые топи."
Inst16Quest16_Location = "Табета (Пылевые топи; "..YELLOW.."46,57"..WHITE..")"
Inst16Quest16_Note = "Задание для магов: \nОбсидиановый источник силы добывается из Обсидианового стража около "..YELLOW.."[5]"..WHITE.."."
Inst16Quest16_Prequest = "Поединок с демоном" -- 1955
Inst16Quest16_Folgequest = "Волнолов маны" -- 1957
Inst16Quest16PreQuest = "true"
-- No Rewards for this quest

--Quest 17 Alliance
Inst16Quest17 = "17. Индарилиевая руда"
Inst16Quest17_Level = "42"
Inst16Quest17_Attain = "29"
Inst16Quest17_Aim = "Принесите 4 руды Индуриума Поззику в тысячу игл."
Inst16Quest17_Location = "Поззик(Тысяча Игл - Мираж Рейсвей; "..YELLOW.."80.1, 75.9"..WHITE..")"
Inst16Quest17_Note = "Это повторяемый квест после выполнения преквестов. Это не дает никакой репутации или опыта, только небольшая сумма денег. Руду Индуриума можно добывать в Ульдамане или покупать у других игроков.."
Inst16Quest17_Prequest = "Сохранение схемы -> Пейс Риззл"
Inst16Quest17_Folgequest = "Нет"
Inst16Quest17PreQuest = "true"
-- No Rewards for this quest



--Quest 1 Horde  (same as Quest 4 Alliance)
Inst16Quest1_HORDE = "1. Силовые камни"
Inst16Quest1_HORDE_Level = Inst16Quest4_Level
Inst16Quest1_HORDE_Attain = Inst16Quest4_Attain
Inst16Quest1_HORDE_Aim = Inst16Quest4_Aim
Inst16Quest1_HORDE_Location = Inst16Quest4_Location
Inst16Quest1_HORDE_Note = Inst16Quest4_Note
Inst16Quest1_HORDE_Prequest = Inst16Quest4_Prequest
Inst16Quest1_HORDE_Folgequest = Inst16Quest4_Folgequest
--
Inst16Quest1name1_HORDE = Inst16Quest4name1
Inst16Quest1name2_HORDE = Inst16Quest4name2
Inst16Quest1name3_HORDE = Inst16Quest4name3

--Quest 2 Horde  (same as Quest 6 Alliance - different followup)
Inst16Quest2_HORDE = "2. Лекарство от судьбы"
Inst16Quest2_HORDE_Level = Inst16Quest6_Level
Inst16Quest2_HORDE_Attain = Inst16Quest6_Attain
Inst16Quest2_HORDE_Aim = Inst16Quest6_Aim
Inst16Quest2_HORDE_Location = Inst16Quest6_Location
Inst16Quest2_HORDE_Note = Inst16Quest6_Note
Inst16Quest2_HORDE_Prequest = Inst16Quest6_Prequest
Inst16Quest2_HORDE_Folgequest = "В Подгород за книгой Йагина"
--
Inst16Quest2name1_HORDE = Inst16Quest6name1

--Quest 3 Horde
Inst16Quest3_HORDE = "3. Пропавшее ожерелье" -- 2283
Inst16Quest3_HORDE_Level = "41"
Inst16Quest3_HORDE_Attain = "37"
Inst16Quest3_HORDE_Aim = "Найдите на раскопках Ульдамана драгоценное ожерелье (возможно, поврежденное) и принесите его в Оргриммар Драну Дрофферсу."
Inst16Quest3_HORDE_Location = "Дран Дрофферс (Оргриммар - Волок; "..YELLOW.."59,36"..WHITE..")"
Inst16Quest3_HORDE_Note = "Ожерелье добывается в подземелье случайно."
Inst16Quest3_HORDE_Prequest = "Нет"
Inst16Quest3_HORDE_Folgequest = "Пропавшее ожерелье, этап 2" -- 2284
-- No Rewards for this quest

--Quest 4 Horde
Inst16Quest4_HORDE = "4. Пропавшее ожерелье, этап 2" -- 2284
Inst16Quest4_HORDE_Level = "41"
Inst16Quest4_HORDE_Attain = "37"
Inst16Quest4_HORDE_Aim = "Разыщите ключ к местонахождению самоцветов в глубинах Ульдамана."
Inst16Quest4_HORDE_Location = "Дран Дрофферс (Оргриммар - Волок; "..YELLOW.."59,36"..WHITE..")"
Inst16Quest4_HORDE_Note = "Паладин находится около "..YELLOW.."[2]"..WHITE.."."
Inst16Quest4_HORDE_Prequest = "Пропавшее ожерелье" -- 2283
Inst16Quest4_HORDE_Folgequest = "Трудности перевода" -- 2318
Inst16Quest4FQuest_HORDE = "true"
-- No Rewards for this quest

--Quest 5 Horde
Inst16Quest5_HORDE = "5. Трудности перевода" -- 2318, 2338
Inst16Quest5_HORDE_Level = "42"
Inst16Quest5_HORDE_Attain = "37"
Inst16Quest5_HORDE_Aim = "Найдите кого-нибудь, кто сможет перевести для Вас дневник паладина. Ближайший к вам такой умелец, скорее всего, найдется в Каргате, форпосте в Бесплодных Землях."
Inst16Quest5_HORDE_Location = "Останки паладина (Ульдаман; "..YELLOW.."[2]"..WHITE..")"
Inst16Quest5_HORDE_Note = "Переводчик Джаркал Замшелый Клык находится в Каргате (Бесплодные земли; "..YELLOW.."2,46"..WHITE..")."
Inst16Quest5_HORDE_Prequest = "Пропавшее ожерелье, этап 2" -- 2284
Inst16Quest5_HORDE_Folgequest = "Найти самоцветы и источник энергии" -- 2339
Inst16Quest5FQuest_HORDE = "true"
-- No Rewards for this quest

--Quest 6 Horde
Inst16Quest6_HORDE = "6. Найти самоцветы и источник энергии" -- 2339
Inst16Quest6_HORDE_Level = "44"
Inst16Quest6_HORDE_Attain = "37"
Inst16Quest6_HORDE_Aim = "Добудьте все три самоцвета и источник энергии для ожерелья из Ульдамана и принесите их Джаркалу Замшелому Клыку в Каргат. Джаркал считает, что источник энергии можно найти у самой сильной твари в Ульдамане."
Inst16Quest6_HORDE_Location = "Джаркал Замшелый Клык (Бесплодные земли - Каргат; "..YELLOW.."2,46"..WHITE..")"
Inst16Quest6_HORDE_Note = "Самоцветы находятся около "..YELLOW.."[1]"..WHITE.." в урне, "..YELLOW.."[8]"..WHITE.." из тайника клана Тенегорна, и "..YELLOW.."[9]"..WHITE.." с Гримлока. Обратите внимание, что когда вы откроете тайник, появятся несколько мобов и атакуют Вас. Источник энергии сломанного ожерелья добывается с Архедаса "..YELLOW.."[10]"..WHITE.."."
Inst16Quest6_HORDE_Prequest = "Трудности перевода" -- 2338
Inst16Quest6_HORDE_Folgequest = "Принести самоцветы" -- 2340
Inst16Quest6FQuest_HORDE = "true"
--
Inst16Quest6name1_HORDE = "Ожерелье Усиления Джаркала"

--Quest 7 Horde
Inst16Quest7_HORDE = "7. В Ульдаман за реактивом" -- 2202
Inst16Quest7_HORDE_Level = "42"
Inst16Quest7_HORDE_Attain = "36"
Inst16Quest7_HORDE_Aim = "Принести 12 грибов-малиновиков Джаркалу Замшелому Клыку в Каргат."
Inst16Quest7_HORDE_Location = "Джаркал Замшелый Клык (Бесплодные земли - Каргат; "..YELLOW.."2,69"..WHITE..")"
Inst16Quest7_HORDE_Note = "Предшествующее задание вы также возьмете в Каргате.\nШляпки есть по всему подземелью. Травники могут видеть их на миникарте, если включен Поиск трав и они взяли задание. Предыдущее задание дает этот же NPC."
Inst16Quest7_HORDE_Prequest = "Пробежка по Бесплодным землям" -- 2258
Inst16Quest7_HORDE_Folgequest = "Пробежка по Бесплодным землям-2"  -- 2203
Inst16Quest7PreQuest_HORDE = "true"
--
Inst16Quest7name1_HORDE = "Приводящее в сознание зелье"

--Quest 8 Horde
Inst16Quest8_HORDE = "8. Возвращенные сокровища" -- 2342
Inst16Quest8_HORDE_Level = "43"
Inst16Quest8_HORDE_Attain = "33"
Inst16Quest8_HORDE_Aim = "Принесите Патрику Гарретту в Подгород фамильное сокровище из сундука в Южном зале Ульдамана."
Inst16Quest8_HORDE_Location = "Патрик Гаррет (Подгород; "..YELLOW.."72,48"..WHITE..")"
Inst16Quest8_HORDE_Note = "Вы найдете сокровище перед тем как войдете в подземелье. Оно на севере пещер, в юговосточном конце тоннеля."
Inst16Quest8_HORDE_Prequest = "Нет"
Inst16Quest8_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 9 Horde
Inst16Quest9_HORDE = "9. Платиновые диски" -- 2278 -> 2440
Inst16Quest9_HORDE_Level = "47"
Inst16Quest9_HORDE_Attain = "40"
Inst16Quest9_HORDE_Aim = "Поговорите с каменным Стражем и запомните все, что он передаст вам. Когда он закончит свой пересказ событий древности, активируйте диски Норганнона. -> Отнесите миниатюрную копию дисков Норганнона кому-то из мудрецов с Громового Утеса."
Inst16Quest9_HORDE_Location = "Диски Нограннона (Ульдаман; "..YELLOW.."[11]"..WHITE..")"
Inst16Quest9_HORDE_Note = "После получения задания, поговорите с каменным стражем слева от дисков.  Потом снова используйте платиновые диски, чтобы получить миниатюрную копию, которую вы должны принести ведуну Искателю Истины в Громовой Утес ("..YELLOW.."34,46"..WHITE..")"
Inst16Quest9_HORDE_Prequest = "Нет"
Inst16Quest9_HORDE_Folgequest = "Ульдумские чудеса" -- 2965
--
Inst16Quest9name1_HORDE = "Сума из мягкой кожи"
Inst16Quest9name2_HORDE = "Наилучшее лечебное зелье"
Inst16Quest9name3_HORDE = "Сильное зелье маны"

--Quest 10 Horde  (same as Quest 4 Alliance)
Inst16Quest10_HORDE = "10. Сила Ульдамана(Маг)"
Inst16Quest10_HORDE_Level = Inst16Quest16_Level
Inst16Quest10_HORDE_Attain = Inst16Quest16_Attain
Inst16Quest10_HORDE_Aim = Inst16Quest16_Aim
Inst16Quest10_HORDE_Location = Inst16Quest16_Location
Inst16Quest10_HORDE_Note = Inst16Quest16_Note
Inst16Quest10_HORDE_Prequest = Inst16Quest16_Prequest
Inst16Quest10_HORDE_Folgequest = Inst16Quest16_Folgequest
Inst16Quest10PreQuest_HORDE = Inst16Quest16PreQuest
-- No Rewards for this quest

--Quest 11 Horde  (same as Quest 17 Alliance)
Inst16Quest11_HORDE = "11. Индарилиевая руда"
Inst16Quest11_HORDE_Level = Inst16Quest17_Level
Inst16Quest11_HORDE_Attain = Inst16Quest17_Attain
Inst16Quest11_HORDE_Aim = Inst16Quest17_Aim
Inst16Quest11_HORDE_Location = Inst16Quest17_Location
Inst16Quest11_HORDE_Note = Inst16Quest17_Note
Inst16Quest11_HORDE_Prequest = Inst16Quest17_Prequest
Inst16Quest11_HORDE_Folgequest = Inst16Quest17_Folgequest
Inst16Quest11PreQuest_HORDE = Inst16Quest17PreQuest
-- No Rewards for this quest



--------------- INST17 - Blackfathom Deeps ---------------

Inst17Caption = "Непроглядная пучина"
Inst17QAA = "6 заданий"
Inst17QAH = "5 заданий"

--Quest 1 Alliance
Inst17Quest1 = "1. Знание в пучине" -- 971
Inst17Quest1_Level = "23"
Inst17Quest1_Attain = "19"
Inst17Quest1_Aim = "Принесите манускрипт Лоргалиса Геррику Костохвату в Заброшенный грот в Стальгорне."
Inst17Quest1_Location = "Геррик Костохват (Стальгорн - Заброшеный Грот; "..YELLOW.."50,5"..WHITE..")"
Inst17Quest1_Note = "Вы найдете манускрипт около "..YELLOW.."[2]"..WHITE.." в воде."
Inst17Quest1_Prequest = "Нет"
Inst17Quest1_Folgequest = "Нет"
--
Inst17Quest1name1 = "Кольцо воодушевления"

--Quest 2 Alliance
Inst17Quest2 = "2. Исследование порчи" -- 1275
Inst17Quest2_Level = "24"
Inst17Quest2_Attain = "18"
Inst17Quest2_Aim = "Гершал Шепот Ночи в Аубердине хочет, чтобы вы принесли ему 8 оскверненных стволов мозга."
Inst17Quest2_Location = "Гершал Шепот Ночи (Темные Берега - Аубердин; "..YELLOW.."38,43"..WHITE..")"
Inst17Quest2_Note = "Предшествующее задание выполняется по желанию. Вы получите его от Аргоса Шепот Ночи (Штормград - Парк; "..YELLOW.."21,55"..WHITE.."). \n\nСо всех наг перед и внутри Непроглядной пучины можно получить сволы мозга."
Inst17Quest2_Prequest = "Проблема за морем" -- 3765
Inst17Quest2_Folgequest = "Нет"
Inst17Quest2PreQuest = "true"
--
Inst17Quest2name1 = "Жучиные застежки"
Inst17Quest2name2 = "Накидка прелата"

--Quest 3 Alliance
Inst17Quest3 = "3. В поисках Талрида" -- 1198
Inst17Quest3_Level = "24"
Inst17Quest3_Attain = "18"
Inst17Quest3_Aim = "Найдите стража Талрида из ордена Серебряного Рассвета в Непроглядной Пучине."
Inst17Quest3_Location = "Рассветный дозорный Шедласс (Дарнасс - Терраса ремесленников; "..YELLOW.."55,24"..WHITE..")"
Inst17Quest3_Note = "Вы найдете стража Талрида из ордена Серебряного Рассвета около "..YELLOW.."[4]"..WHITE.."."
Inst17Quest3_Prequest = "Нет"
Inst17Quest3_Folgequest = "Злодейство в Непроглядной Пучине" -- 1200
-- No Rewards for this quest

--Quest 4 Alliance
Inst17Quest4 = "4. Злодейство в Непроглядной Пучине" -- 1200
Inst17Quest4_Level = "27"
Inst17Quest4_Attain = "18"
Inst17Quest4_Aim = "Принесите голову Повелителя сумрака Келриса Рассветному дозорному Селгорму в Дарнас."
Inst17Quest4_Location = "Страж Талрид из ордена Серебряного Рассвета (Непроглядная пучина; "..YELLOW.."[4]"..WHITE..")"
Inst17Quest4_Note = "Лорд Сумерек Келрис находится около "..YELLOW.."[8]"..WHITE..". Вы найдете Рассветного дозорного Селгорма в Дарнассе - Терраса Ремесленников ("..YELLOW.."55,24"..WHITE.."). \n\nВНИМАНИЕ! Если вы включите огни позади Лорда Келриса, появятся враги и атакуют Вас."
Inst17Quest4_Prequest = "В поисках Талрида" -- 1198
Inst17Quest4_Folgequest = "Нет"
Inst17Quest4FQuest = "true"
--
Inst17Quest4name1 = "Надгробный скипетр"
Inst17Quest4name2 = "Арктический кулачный щит"

--Quest 5 Alliance
Inst17Quest5 = "5. Наступление сумерек" -- 1199
Inst17Quest5_Level = "25"
Inst17Quest5_Attain = "20"
Inst17Quest5_Aim = "Принесите 10 подвесок Сумерек стражу Менадосу из ордена Серебряного Рассвета в Дарнас."
Inst17Quest5_Location = "Страж Менадос из ордена Серебряного рассвета (Дарнасс - Терраса ремесленников; "..YELLOW.."55,23"..WHITE..")"
Inst17Quest5_Note = "Из любого сумеречного противника падают подвески."
Inst17Quest5_Prequest = "Нет"
Inst17Quest5_Folgequest = "Нет"
--
Inst17Quest5name1 = "Ореольные сапоги"
Inst17Quest5name2 = "Ремень Сердца Древа"

--Quest 6 Alliance
Inst17Quest6 = "6. Шар Соран'рука(Чернокнижник)" -- 1740
Inst17Quest6_Level = "25"
Inst17Quest6_Attain = "20"
Inst17Quest6_Aim = "Соберите 3 фрагмента Соран'рука и 1 большой фрагмент Соран'рука и принесите их Доану Кархану в Степи."
Inst17Quest6_Location = "Доан Кархан (Степи; "..YELLOW.."49,57"..WHITE..")"
Inst17Quest6_Note = "Задание для чернокнижников: Вы возьмете 3 фрагмента Соран'рука с Сумеречных Прислужников в "..YELLOW.."[Непроглядная пучина]"..WHITE..". Вы возьмете большой фрагмент Соран'рука в "..YELLOW.."[Крепость Темного Клыка]"..WHITE.." у Темных Душ Темного Клыка."
Inst17Quest6_Prequest = "Нет"
Inst17Quest6_Folgequest = "Нет"
--
Inst17Quest6name1 = "Сфера Соран'рука"
Inst17Quest6name2 = "Посох Соран'рука"


--Quest 1 Horde
Inst17Quest1_HORDE = "1. Сущность Аку'май" -- 6563
Inst17Quest1_HORDE_Level = "22"
Inst17Quest1_HORDE_Attain = "17"
Inst17Quest1_HORDE_Aim = "Принесите 20 сапфиров Аку'май Дже'неу Санкри в Ясеневый лес."
Inst17Quest1_HORDE_Location = "Дже'неу Санкри (Ясеневый лес - Застава Зорам'гар; "..YELLOW.."11,33"..WHITE..")"
Inst17Quest1_HORDE_Note = "Вы получите предшествующее задание 'Угроза из Глубин' у Цунамана (Когтистые горы - Приют у Солнечного камня; "..YELLOW.."47,64"..WHITE.."). Сапфиры можно найти в пещерах перед подземельем."
Inst17Quest1_HORDE_Prequest = "Угроза из Глубин" -- 6562
Inst17Quest1_HORDE_Folgequest = "Нет"
Inst17Quest1PreQuest_HORDE = "true"
-- No Rewards for this quest

--Quest 2 Horde
Inst17Quest2_HORDE = "2. Верность Древним богам" -- 6564 -> 6565
Inst17Quest2_HORDE_Level = "22"
Inst17Quest2_HORDE_Attain = "17"
Inst17Quest2_HORDE_Aim = "Принесите отсыревшую записку Дже'неу Санкри в Ясеневый лес. -> Убейте Лоргуса Джетта в Непроглядной Пучине и вернитесь к Дже'неу Санкри в Ясеневый лес."
Inst17Quest2_HORDE_Location = "Отсыревшая записка (добывается - см. заметки)"
Inst17Quest2_HORDE_Note = "Вы получите Отсыревшую записку с Жриц прилива из Непроглядной Пучины (5% шанс выпадения). Потом принесите ее Дже'неу Санкри (Ясеневый лес - Застава Зорам'гар; "..YELLOW.."11,33"..WHITE.."). Лоргус Джетт находится около "..YELLOW.."[6]"..WHITE.."."
Inst17Quest2_HORDE_Prequest = "Нет"
Inst17Quest2_HORDE_Folgequest = "Нет"
--
Inst17Quest2name1_HORDE = "Кольцо Кулака"
Inst17Quest2name2_HORDE = "Оплечье Гнедого"

--Quest 3 Horde
Inst17Quest3_HORDE = "3. Среди руин" -- 6921
Inst17Quest3_HORDE_Level = "27"
Inst17Quest3_HORDE_Attain = "21"
Inst17Quest3_HORDE_Aim = "Принесите глубинный сердечник Дже'неу Санкри в форт Зорам'гар в Ясеневый лес."
Inst17Quest3_HORDE_Location = "Дже'неу Санкри (Ясеневый лес - Застава Зорам'гар; "..YELLOW.."11,33"..WHITE..")"
Inst17Quest3_HORDE_Note = "Вы найдете глубинный сердечник около "..YELLOW.."[7]"..WHITE.." под водой. Когда вы поднимите сердечник появится барон Акванис и атакует Вас. С него добывается предмет, который вы должны принести Дже'неу Санкри."
Inst17Quest3_HORDE_Prequest = "Нет"
Inst17Quest3_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 4 Horde
Inst17Quest4_HORDE = "4. Злодейство в Непроглядной Пучине" -- 6561
Inst17Quest4_HORDE_Level = "27"
Inst17Quest4_HORDE_Attain = "18"
Inst17Quest4_HORDE_Aim = "Принесите голову Повелителя сумрака Келриса Башане Руническому Тотему в Громовой Утес."
Inst17Quest4_HORDE_Location = "Страж Талрид из ордена Серебряного Рассвета (Непроглядная пучина; "..YELLOW.."[4]"..WHITE..")"
Inst17Quest4_HORDE_Note = "Лорд Сумерек Келрис находится около "..YELLOW.."[8]"..WHITE..". Вы найдете Башана Рунического Тотема в Громовом Утесе - Вершина Старейшин ("..YELLOW.."55,24"..WHITE.."). \n\nВНИМАНИЕ! Если вы включите огни позади Лорда Келриса, появятся враги и атакуют Вас."
Inst17Quest4_HORDE_Prequest = "Нет"
Inst17Quest4_HORDE_Folgequest = "Нет"
--
Inst17Quest4name1_HORDE = "Надгробный скипетр"
Inst17Quest4name2_HORDE = "Арктический кулачный щит"

--Quest 5 Horde  (same as Quest 6 Alliance)
Inst17Quest5_HORDE = "5. Шар Соран'рука"
Inst17Quest5_HORDE_Level = Inst17Quest6_Level
Inst17Quest5_HORDE_Attain = Inst17Quest6_Attain
Inst17Quest5_HORDE_Aim = Inst17Quest6_Aim
Inst17Quest5_HORDE_Location = Inst17Quest6_Location
Inst17Quest5_HORDE_Note = Inst17Quest6_Note
Inst17Quest5_HORDE_Prequest = Inst17Quest6_Prequest
Inst17Quest5_HORDE_Folgequest = Inst17Quest6_Folgequest
--
Inst17Quest5name1_HORDE = Inst17Quest6name1
Inst17Quest5name2_HORDE = Inst17Quest6name2



--------------- INST18 - Dire Maul East ---------------

Inst18Caption = "Забытый город (Восток))"
Inst18QAA = "6 заданий"
Inst18QAH = "6 заданий"

--Quest 1 Alliance
Inst18Quest1 = "1. Пузиллин и старейшина Аж'Тордин"
Inst18Quest1_Level = "58"
Inst18Quest1_Attain = "54"
Inst18Quest1_Aim = "Отправляйтесь в Забытый Город и отыщите беса Пузиллина. Любыми доступными средствами убедите Пузиллина отдать вам книгу заклинаний Аж'Тордина. Если добудете книгу, вернитесь к Аж'Тордину в павильон Лорисс в Фераласе."
Inst18Quest1_Location = "Аж'Тордин (Фералас; "..YELLOW.."76,37"..WHITE..")"
Inst18Quest1_Note = "Пузиллин находится в Забытом городе "..YELLOW.."(Восток)"..WHITE.." около "..YELLOW.."[1]"..WHITE..". Он убегает когда вы поговорите с ним, но останавливается и сражается около "..YELLOW.."[2]"..WHITE..". С него добывается Ключ Полумесяца, используемый в Забытом городе Север и Запад."
Inst18Quest1_Prequest = "Нет"
Inst18Quest1_Folgequest = "Нет"
--
Inst18Quest1name1 = "Подвижные сапоги"
Inst18Quest1name2 = "Меч спринтера"

--Quest 2 Alliance
Inst18Quest2 = "2. Сеть Лефтендрис"
Inst18Quest2_Level = "57"
Inst18Quest2_Attain = "54"
Inst18Quest2_Aim = "Принесите сеть Лефтендрис Латроникусу Лунному Копью в Крепость Оперенной Луны в Фераласе."
Inst18Quest2_Location = "Латроникус Лунное Копье (Фералас - Крепость Оперенной Луны; "..YELLOW.."30,46"..WHITE..")"
Inst18Quest2_Note = "Лефтендрис находится в Забытом городе "..YELLOW.."(Восток)"..WHITE.." около "..YELLOW.."[3]"..WHITE..". Предшествующее задание идет от Курьера Удар Молота в Стальгорне. Он бродит по всему городу."
Inst18Quest2_Prequest = "Крепость Оперенной Луны" -- 7494
Inst18Quest2_Folgequest = "Нет"
Inst18Quest2PreQuest = "true"
--
Inst18Quest2name1 = "Мастер-прядильщик"

--Quest 3 Alliance
Inst18Quest3 = "3. Осколки сквернита"
Inst18Quest3_Level = "60"
Inst18Quest3_Attain = "56"
Inst18Quest3_Aim = "Отыщите Сквернит в Забытом Городе и подберите его осколок. Есть шанс, что вам удастся его добыть, только убив Алззина Перевертня. Крепко заприте осколок в реликварии Чистоты, затем верните его Рабину Сатурне в Ночную Гавань в Лунной поляне."
Inst18Quest3_Location = "Рабин Сатурна (Лунная поляна - Ночная гавань; "..YELLOW.."51,44"..WHITE..")"
Inst18Quest3_Note = "Вы найдете Алззина Вертоградаря в "..YELLOW.."Восточной"..WHITE.." части Забытого города около "..YELLOW.."[5]"..WHITE..". Реликварий находится в Силитусе около "..YELLOW.."62,54"..WHITE..". Предществующее задание также идет от Рабина Сатурна."
Inst18Quest3_Prequest = "Реликварий Чистоты" -- 5527
Inst18Quest3_Folgequest = "Нет"
Inst18Quest3PreQuest = "true"
--
Inst18Quest3name1 = "Щит Милли"
Inst18Quest3name2 = "Словарь Милли"

--Quest 4 Alliance
Inst18Quest4 = "4. Левая часть амулета Лорда Вальтхалака"
Inst18Quest4_Level = "60"
Inst18Quest4_Attain = "58"
Inst18Quest4_Aim = "С помощью жаровни Призыва вызвать дух Изалиен и убить ее. Вернуться к Бодли в Черную гору, отдать ему левую часть амулета Лорда Вальтхалака и жаровню Призыва."
Inst18Quest4_Location = "Бодли (Черная гора; "..YELLOW.."[D] на карте входа"..WHITE..")"
Inst18Quest4_Note = "Чтобы увидеть Бодли нужен Спектральный сканер иных измерений. Вы получите его за задание 'В поисках Антиона'.\n\nИзалиен вызывается около "..YELLOW.."[5]"..WHITE.."."
Inst18Quest4_Prequest = "Важная составляющая заклинания" -- 8963
Inst18Quest4_Folgequest = "Я вижу в твоем будущем остров Алькац..." -- 8970
Inst18Quest4PreQuest = "true"
-- No Rewards for this quest

--Quest 5 Alliance
Inst18Quest5 = "5. Правая часть амулета Лорда Вальтхалака"
Inst18Quest5_Level = "60"
Inst18Quest5_Attain = "58"
Inst18Quest5_Aim = "С помощью жаровни Призыва вызвать дух Изалиен и убить ее. Вернуться к Бодли в Черную гору, отдать ему восстановленный амулет и жаровню Призыва."
Inst18Quest5_Location = "Бодли (Черная гора; "..YELLOW.."[D] на карте входа"..WHITE..")"
Inst18Quest5_Note = "Чтобы увидеть Бодли нужен Спектральный сканер иных измерений. Вы получите его за задание 'В поисках Антиона'.\n\nИзалиен вызывается около "..YELLOW.."[5]"..WHITE.."."
Inst18Quest5_Prequest = "Еще одна важная составляющая заклинания" -- 8985
Inst18Quest5_Folgequest = "Последние приготовления ("..YELLOW.."Вершина Черной горы"..WHITE..")" -- 8994
Inst18Quest5PreQuest = "true"
-- No Rewards for this quest

--Quest 6 Alliance
Inst18Quest6 = "6. Тюремные кандалы (Чернокнижник)"
Inst18Quest6_Level = "60"
Inst18Quest6_Attain = "60"
Inst18Quest6_Aim = "Отправляйтесь в Забытый Город, что в Фераласе и добудьте 15 порций крови сатиров из племени Исчадий Природы, что живут в Квартале Криводревов. Вернитесь к Дайо из Гниющего шрама по выполнении поручения."
Inst18Quest6_Location = "Дайо Дряхлый (Выжженные земли - Гниющий шрам; "..YELLOW.."34,50"..WHITE..")"
Inst18Quest6_Note = "Задание для чернокнижников: Это вместе с другими заданиями для чернокнижников начинает Дайо Дряхлый на заклинание Ритуал Рока. Самый простой способ добраться до 'Сатиров из племени Буйного Нрава' это войти в Забытый Город (Восток) через 'заднюю дверь' в Павильон Лорисс (Фералас; "..YELLOW.."77,37"..WHITE.."). Вам понадобится Серповидный ключ."
Inst18Quest6_Prequest = "Нет"
Inst18Quest6_Folgequest = "Нет"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst18Quest1_HORDE = Inst18Quest1
Inst18Quest1_HORDE_Level = Inst18Quest1_Level
Inst18Quest1_HORDE_Attain = Inst18Quest1_Attain
Inst18Quest1_HORDE_Aim = Inst18Quest1_Aim
Inst18Quest1_HORDE_Location = Inst18Quest1_Location
Inst18Quest1_HORDE_Note = Inst18Quest1_Note
Inst18Quest1_HORDE_Prequest = Inst18Quest1_Prequest
Inst18Quest1_HORDE_Folgequest = Inst18Quest1_Folgequest
--
Inst18Quest1name1_HORDE = Inst18Quest1name1
Inst18Quest1name2_HORDE = Inst18Quest1name2

--Quest 2 Horde
Inst18Quest2_HORDE = "2. Сеть Лефтендрис"
Inst18Quest2_HORDE_Level = "57"
Inst18Quest2_HORDE_Attain = "54"
Inst18Quest2_HORDE_Aim = "Принесите сеть Лефтендрис Тало Терновому Копыту в Лагере Мохаче в Фераласе."
Inst18Quest2_HORDE_Location = "Тало Терновое Копыто (Фералас - Лагерь Мохаче; "..YELLOW.."76,43"..WHITE..")"
Inst18Quest2_HORDE_Note = "Лефтендрис находится в Забытом городе "..YELLOW.."(Восток)"..WHITE.." около "..YELLOW.."[3]"..WHITE..". Предшествеющее задание идет от Военного глашатая Горлача в Оргриммаре. Он бродит по всему городу."
Inst18Quest2_HORDE_Prequest = "Лагерь Мохаче" -- 7492
Inst18Quest2_HORDE_Folgequest = "Нет"
Inst18Quest2PreQuest_HORDE = "true"
--
Inst18Quest2name1_HORDE = "Мастер-прядильщик"

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst18Quest3_HORDE = Inst18Quest3
Inst18Quest3_HORDE_Level = Inst18Quest3_Level
Inst18Quest3_HORDE_Attain = Inst18Quest3_Attain
Inst18Quest3_HORDE_Aim = Inst18Quest3_Aim
Inst18Quest3_HORDE_Location = Inst18Quest3_Location
Inst18Quest3_HORDE_Note = Inst18Quest3_Note
Inst18Quest3_HORDE_Prequest = Inst18Quest3_Prequest
Inst18Quest3_HORDE_Folgequest = Inst18Quest3_Folgequest
--
Inst18Quest3name1_HORDE = Inst18Quest3name1
Inst18Quest3name2_HORDE = Inst18Quest3name2

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst18Quest4_HORDE = Inst18Quest4
Inst18Quest4_HORDE_Level = Inst18Quest4_Level
Inst18Quest4_HORDE_Attain = Inst18Quest4_Attain
Inst18Quest4_HORDE_Aim = Inst18Quest4_Aim
Inst18Quest4_HORDE_Location = Inst18Quest4_Location
Inst18Quest4_HORDE_Note = Inst18Quest4_Note
Inst18Quest4_HORDE_Prequest = Inst18Quest4_Prequest
Inst18Quest4_HORDE_Folgequest = Inst18Quest4_Folgequest
Inst18Quest4PreQuest_HORDE = Inst18Quest4PreQuest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst18Quest5_HORDE = Inst18Quest5
Inst18Quest5_HORDE_Level = Inst18Quest5_Level
Inst18Quest5_HORDE_Attain = Inst18Quest5_Attain
Inst18Quest5_HORDE_Aim = Inst18Quest5_Aim
Inst18Quest5_HORDE_Location = Inst18Quest5_Location
Inst18Quest5_HORDE_Note = Inst18Quest5_Note
Inst18Quest5_HORDE_Prequest = Inst18Quest5_Prequest
Inst18Quest5_HORDE_Folgequest = Inst18Quest5_Folgequest
Inst18Quest5PreQuest_HORDE = Inst18Quest5PreQuest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst18Quest6_HORDE = Inst18Quest6
Inst18Quest6_HORDE_Level = Inst18Quest6_Level
Inst18Quest6_HORDE_Attain = Inst18Quest6_Attain
Inst18Quest6_HORDE_Aim = Inst18Quest6_Aim
Inst18Quest6_HORDE_Location = Inst18Quest6_Location
Inst18Quest6_HORDE_Note = Inst18Quest6_Note
Inst18Quest6_HORDE_Prequest = Inst18Quest6_Prequest
Inst18Quest6_HORDE_Folgequest = Inst18Quest6_Folgequest
-- No Rewards for this quest



--------------- INST19 - Dire Maul North ---------------

Inst19Caption = "Забытый город (Север)"
Inst19QAA = "5 заданий"
Inst19QAH = "5 заданий"

--Quest 1 Alliance
Inst19Quest1 = "1.Сломанная западня"
Inst19Quest1_Level = "60"
Inst19Quest1_Attain = "56"
Inst19Quest1_Aim = "Отремонтировать западню."
Inst19Quest1_Location = "Сломанная западня (Забытый город; "..YELLOW.."Север"..WHITE..")"
Inst19Quest1_Note = "Повторяемое задание. Для ремонта западни нужно использовать [Ториевое устройство] и [Масло льда]."
Inst19Quest1_Prequest = "Нет"
Inst19Quest1_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 2 Alliance
Inst19Quest2 = "2. Броня огров Гордока"
Inst19Quest2_Level = "60"
Inst19Quest2_Attain = "56"
Inst19Quest2_Aim = "Принесите 4 рулона рунической ткани, 8 кусков грубой кожи, 2 мотка рунной нити и огрскую дубильную кислоту Уззлу Наперстяку. Он прикован в секторе Гордока в Забытом Городе."
Inst19Quest2_Location = "Уззл Наперстяк (Забытый город; "..YELLOW.."Север, [4]"..WHITE..")"
Inst19Quest2_Note = "Повторяемое задание. Вы найдете огрскую дубильную кислоту около "..YELLOW.."[4] (сверху)"..WHITE.."."
Inst19Quest2_Prequest = "Нет"
Inst19Quest2_Folgequest = "Нет"
--
Inst19Quest2name1 = "Броня огров Гордока"

--Quest 3 Alliance
Inst19Quest3 = "3. Освободите Нотта!"
Inst19Quest3_Level = "60"
Inst19Quest3_Attain = "60"
Inst19Quest3_Aim = "Найдите Ключ от оков Гордока для Уззла Наперстяка."
Inst19Quest3_Location = "Уззл Наперстяк (Забытый город; "..YELLOW.."Север, [4]"..WHITE..")"
Inst19Quest3_Note = "Повторяемое задание. Ключ может выпасть из любого охранника."
Inst19Quest3_Prequest = "Нет"
Inst19Quest3_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 4 Alliance
Inst19Quest4 = "4. Неоконченное дело Гордоков"
Inst19Quest4_Level = "60"
Inst19Quest4_Attain = "56"
Inst19Quest4_Aim = "Добудьте латную рукавицу Мощи Гордока и вернитесь с ней к капитану Давигрому в Забытом Городе. По словам Давигрома, в старых байках говорится, что Тортелдрин – страшный эльф, называющий себя принцем, – похитил эту рукавицу у одного из королей Гордоков."
Inst19Quest4_Location = "Капитан Давигром (Забытый город; "..YELLOW.."Север, [5]"..WHITE..")"
Inst19Quest4_Note = "Принц находится в Забытом городе "..YELLOW.."Запад"..WHITE.." около "..YELLOW.."[7]"..WHITE..". Рукавица в сундуке прямо рядом с ним. Вы можете взять это задание только после Захода почести и с баффом 'Король Гордока'."
Inst19Quest4_Prequest = "Нет"
Inst19Quest4_Folgequest = "Нет"
--
Inst19Quest4name1 = "Повязки Гордока"
Inst19Quest4name2 = "Перчатки Гордока"
Inst19Quest4name3 = "Рукавицы Гордока"
Inst19Quest4name4 = "Боевые рукавицы Гордока"

--Quest 5 Alliance
Inst19Quest5 = "5. Лучшее пойло Гордока"
Inst19Quest5_Level = "60"
Inst19Quest5_Attain = "60"
Inst19Quest5_Aim = "Бесплатная выпивка."
Inst19Quest5_Location = "Стомпер Криг (Забытый город; "..YELLOW.."Север, [2]"..WHITE..")"
Inst19Quest5_Note = "Просто поговорите с NPC, чтобы принять и завершить квест одновременно."
Inst19Quest5_Prequest = "Нет"
Inst19Quest5_Folgequest = "Нет"
--
Inst19Quest5name1 = "Зеленый грог Гордока"
Inst19Quest5name2 = "Убойное пойло Крига"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst19Quest1_HORDE = Inst19Quest1
Inst19Quest1_HORDE_Level = Inst19Quest1_Level
Inst19Quest1_HORDE_Attain = Inst19Quest1_Attain
Inst19Quest1_HORDE_Aim = Inst19Quest1_Aim
Inst19Quest1_HORDE_Location = Inst19Quest1_Location
Inst19Quest1_HORDE_Note = Inst19Quest1_Note
Inst19Quest1_HORDE_Prequest = Inst19Quest1_Prequest
Inst19Quest1_HORDE_Folgequest = Inst19Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst19Quest2_HORDE = Inst19Quest2
Inst19Quest2_HORDE_Level = Inst19Quest2_Level
Inst19Quest2_HORDE_Attain = Inst19Quest2_Attain
Inst19Quest2_HORDE_Aim = Inst19Quest2_Aim
Inst19Quest2_HORDE_Location = Inst19Quest2_Location
Inst19Quest2_HORDE_Note = Inst19Quest2_Note
Inst19Quest2_HORDE_Prequest = Inst19Quest2_Prequest
Inst19Quest2_HORDE_Folgequest = Inst19Quest2_Folgequest
--
Inst19Quest2name1_HORDE = Inst19Quest2name1

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst19Quest3_HORDE = Inst19Quest3
Inst19Quest3_HORDE_Level = Inst19Quest3_Level
Inst19Quest3_HORDE_Attain = Inst19Quest3_Attain
Inst19Quest3_HORDE_Aim = Inst19Quest3_Aim
Inst19Quest3_HORDE_Location = Inst19Quest3_Location
Inst19Quest3_HORDE_Note = Inst19Quest3_Note
Inst19Quest3_HORDE_Prequest = Inst19Quest3_Prequest
Inst19Quest3_HORDE_Folgequest = Inst19Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst19Quest4_HORDE = Inst19Quest4
Inst19Quest4_HORDE_Level = Inst19Quest4_Level
Inst19Quest4_HORDE_Attain = Inst19Quest4_Attain
Inst19Quest4_HORDE_Aim = Inst19Quest4_Aim
Inst19Quest4_HORDE_Location = Inst19Quest4_Location
Inst19Quest4_HORDE_Note = Inst19Quest4_Note
Inst19Quest4_HORDE_Prequest = Inst19Quest4_Prequest
Inst19Quest4_HORDE_Folgequest = Inst19Quest4_Folgequest
--
Inst19Quest4name1_HORDE = Inst19Quest4name1
Inst19Quest4name2_HORDE = Inst19Quest4name2
Inst19Quest4name3_HORDE = Inst19Quest4name3
Inst19Quest4name4_HORDE = Inst19Quest4name4

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst19Quest5_HORDE = Inst19Quest5
Inst19Quest5_HORDE_Level = Inst19Quest5_Level
Inst19Quest5_HORDE_Attain = Inst19Quest5_Attain
Inst19Quest5_HORDE_Aim = Inst19Quest5_Aim
Inst19Quest5_HORDE_Location = Inst19Quest5_Location
Inst19Quest5_HORDE_Note = Inst19Quest5_Note
Inst19Quest5_HORDE_Prequest = Inst19Quest5_Prequest
Inst19Quest5_HORDE_Folgequest = Inst19Quest5_Folgequest
--
Inst19Quest5name1_HORDE = Inst19Quest5name1
Inst19Quest5name2_HORDE = Inst19Quest5name2



--------------- INST20 - Dire Maul West ---------------

Inst20Caption = "Забытый город (Запад)"
Inst20QAA = "17 заданий"
Inst20QAH = "17 заданий"

--Quest 1 Alliance
Inst20Quest1 = "1. Эльфийские легенды"
Inst20Quest1_Level = "60"
Inst20Quest1_Attain = "54"
Inst20Quest1_Aim = "Попытайтесь найти в Забытом Городе Кариэля Винтхалуса. Вернитесь в крепость Оперенной Луны к школяру Рунному Шипу и сообщите ей все, что вам удалось узнать."
Inst20Quest1_Location = "Школяр Рунный Шип (Фералас - Крепость Оперенной Луны; "..YELLOW.."31,43"..WHITE..")"
Inst20Quest1_Note = "Вы найдете Кариэля Винтхалуса в "..YELLOW.."Библиотека (Запад)"..WHITE.."."
Inst20Quest1_Prequest = "Нет"
Inst20Quest1_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 2 Alliance
Inst20Quest2 = "2. Древнее безумие"
Inst20Quest2_Level = "60"
Inst20Quest2_Attain = "56"
Inst20Quest2_Aim = "Перебейте стражей, которые охраняют 5 столпов, снабжающих энергией Тюрьму Бессмер'тера. После того как столпы угаснут, силовое поле, удерживающее Бессмер'тера, рассеется.\nВойдите в Тюрьму Бессмер'тера и уничтожьте злого демона, который находится внутри. И, наконец, сразитесь с принцем Тортелдрином в Читальне. Если задание будет выполнено успешно, вернитесь во двор, к прародительнице Шен\'дралар."
Inst20Quest2_Location = "Прародительница Шен'дралар (Забытый город; "..YELLOW.."Запад, [1] (сверху)"..WHITE..")"
Inst20Quest2_Note = "Столпы помечены как "..BLUE.."[B]"..WHITE..". Бессмер'тер находится около "..YELLOW.."[6]"..WHITE..", Принц Тортелдрин находится около "..YELLOW.."[7]"..WHITE.."."
Inst20Quest2_Prequest = "Нет"
Inst20Quest2_Folgequest = "Сокровище Шен'дралар" -- 7877
-- No Rewards for this quest

--Quest 3 Alliance
Inst20Quest3 = "3. Сокровище Шен'дралар"
Inst20Quest3_Level = "60"
Inst20Quest3_Attain = "56"
Inst20Quest3_Aim = "Вернитесь в Читальню и найдите сокровище Шен'дралар. Получите свою награду!"
Inst20Quest3_Location = "Прародительница Шен'дралар (Забытый город; "..YELLOW.."Запад, [1]"..WHITE..")"
Inst20Quest3_Note = "Вы найдете Сокровище под ступеньками "..YELLOW.."[7]"..WHITE.."."
Inst20Quest3_Prequest = "Древнее безумие" -- 7461
Inst20Quest3_Folgequest = "Нет"
Inst20Quest3FQuest = "true"
--
Inst20Quest3name1 = "Осоковые сапоги"
Inst20Quest3name2 = "Шлем Заднелеса"
Inst20Quest3name3 = "Костекрушитель"

--Quest 4 Alliance
Inst20Quest4 = "4. Зоротианский конь погибели(Чернокнижник)"
Inst20Quest4_Level = "60"
Inst20Quest4_Attain = "60"
Inst20Quest4_Aim = "Прочтите инструкции Мор'зула. Призовите зоротианского коня погибели, одолейте его и подчините его дух."
Inst20Quest4_Location = "Мор'зул Вестник Крови (Пылающие степи; "..YELLOW.."12,31"..WHITE..")"
Inst20Quest4_Note = "Задание для чернокнижников: Окончательное задание на эпического коня чернокнижников. Сначала вы должны отключить все Пилоны, отмеченные "..BLUE.."[B]"..WHITE.." и убить Бессмер'тера около "..YELLOW.."[6]"..WHITE..". После этого, вы можете начать ритуал призыва. Обязательно иметь свыше 20 готовых Осколков душ и одного чернокнижника специально назначенного для поддержания колокола, свечи и колеса. Стражники ужаса могу быть подчинены. После завершения ритуала, поговорите с Духом коня погибели, чтобы закончить задание."
Inst20Quest4_Prequest = "Доставка беса ("..YELLOW.."Некроситет"..WHITE..")" -- 7629
Inst20Quest4_Folgequest = "Нет"
Inst20Quest4PreQuest = "true"
-- No Rewards for this quest

--Quest 5 Alliance
Inst20Quest5 = "5. Изумрудный Сон(Друид)"
Inst20Quest5_Level = "60"
Inst20Quest5_Attain = "54"
Inst20Quest5_Aim = "Верните книгу законным владельцам."
Inst20Quest5_Location = "Изумрудный Сон (случайная добыча с боссов во всех частях Забытого города)"
Inst20Quest5_Note = "Задание для друидов: Вы относите книгу Сказителю Явону к "..YELLOW.."1' Библиотеке"..WHITE.."."
Inst20Quest5_Prequest = "Нет"
Inst20Quest5_Folgequest = "Нет"
--
Inst20Quest5name1 = "Королевская печать Эльдре'Таласа"

--Quest 6 Alliance
Inst20Quest6 = "6. Величайшая гонка охотников(Охотник)"
Inst20Quest6_Level = "60"
Inst20Quest6_Attain = "54"
Inst20Quest6_Aim = "Верните книгу законным владельцам."
Inst20Quest6_Location = "Величайшая гонка охотников (случайная добыча с боссов во всех частях Забытого города)"
Inst20Quest6_Note = "Задание для охотников: Вы относите книгу Сказительнице Микос к "..YELLOW.."1' Библиотеке"..WHITE.."."
Inst20Quest6_Prequest = "Нет"
Inst20Quest6_Folgequest = "Нет"
--
Inst20Quest6name1 = "Королевская печать Эльдре'Таласа"

--Quest 7 Alliance
Inst20Quest7 = "7. Поваренная книга чародея(Маг)"
Inst20Quest7_Level = "60"
Inst20Quest7_Attain = "54"
Inst20Quest7_Aim = "Верните книгу законным владельцам."
Inst20Quest7_Location = "Поваренная книга чародея (случайная добыча с боссов во всех частях Забытого города)"
Inst20Quest7_Note = "Задание для магов: Вы относите книгу Сказителю Килдрату к "..YELLOW.."1' Библиотеке"..WHITE.."."
Inst20Quest7_Prequest = "Нет"
Inst20Quest7_Folgequest = "Нет"
--
Inst20Quest7name1 = "Королевская печать Эльдре'Таласа"

--Quest 8 Alliance
Inst20Quest8 = "8. Свет и как его раскачать(Паладин)"
Inst20Quest8_Level = "60"
Inst20Quest8_Attain = "54"
Inst20Quest8_Aim = "Верните книгу законным владельцам."
Inst20Quest8_Location = "Свет и как его раскачать (случайная добыча с боссов во всех частях Забытого города)"
Inst20Quest8_Note = "Задание для паладинов: Вы относите книгу Сказительнице Микос к "..YELLOW.."1' Библиотеке"..WHITE.."."
Inst20Quest8_Prequest = "Нет"
Inst20Quest8_Folgequest = "Нет"
--
Inst20Quest8name1 = "Королевская печать Эльдре'Таласа"

--Quest 9 Alliance
Inst20Quest9 = "9. Святая Болонья: О чем не говорит Свет(Жрец)"
Inst20Quest9_Level = "60"
Inst20Quest9_Attain = "54"
Inst20Quest9_Aim = "Верните книгу законным владельцам."
Inst20Quest9_Location = "Святая Болонья: О чем не говорит Свет (случайная добыча с боссов во всех частях Забытого города)"
Inst20Quest9_Note = "Задание для жрецов: Вы относите книгу Сказителю Явону к "..YELLOW.."1' Библиотеке"..WHITE.."."
Inst20Quest9_Prequest = "Нет"
Inst20Quest9_Folgequest = "Нет"
--
Inst20Quest9name1 = "Королевская печать Эльдре'Таласа"

--Quest 10 Alliance
Inst20Quest10 = "10. Гарона: Исследование уловок и предательства(Разбойник)"
Inst20Quest10_Level = "60"
Inst20Quest10_Attain = "54"
Inst20Quest10_Aim = "Верните книгу законным владельцам."
Inst20Quest10_Location = "Гарона: Исследование уловок и предательства (случайная добыча с боссов во всех частях Забытого города)"
Inst20Quest10_Note = "Задание для разбойников: Вы относите книгу Сказителю Килдрату к "..YELLOW.."1' Библиотеке"..WHITE.."."
Inst20Quest10_Prequest = "Нет"
Inst20Quest10_Folgequest = "Нет"
--
Inst20Quest10name1 = "Королевская печать Эльдре'Таласа"

--Quest 11 Alliance
Inst20Quest11 = "11. Ледяной шок и вы(Шаман)"
Inst20Quest11_Level = "60"
Inst20Quest11_Attain = "54"
Inst20Quest11_Aim = "Верните книгу законным владельцам."
Inst20Quest11_Location = "Ледяной шок и вы (случайная добыча с боссов во всех частях Забытого города)"
Inst20Quest11_Note = "Задание для шаманов: Вы относите книгу Сказителю Явону к "..YELLOW.."1' Библиотеке"..WHITE.."."
Inst20Quest11_Prequest = "Нет"
Inst20Quest11_Folgequest = "Нет"
--
Inst20Quest11name1 = "Королевская печать Эльдре'Таласа"

--Quest 12 Alliance
Inst20Quest12 = "12. Укрощая тени(Чернокнижник)"
Inst20Quest12_Level = "60"
Inst20Quest12_Attain = "54"
Inst20Quest12_Aim = "Верните книгу законным владельцам."
Inst20Quest12_Location = "Укрощая тени (случайная добыча с боссов во всех частях Забытого города)"
Inst20Quest12_Note = "Задание для чернокнижников: Вы относите книгу Сказительнице Микос к "..YELLOW.."1' Библиотеке"..WHITE.."."
Inst20Quest12_Prequest = "Нет"
Inst20Quest12_Folgequest = "Нет"
--
Inst20Quest12name1 = "Королевская печать Эльдре'Таласа"

--Quest 13 Alliance
Inst20Quest13 = "13. Кодекс Обороны(Воин)"
Inst20Quest13_Level = "60"
Inst20Quest13_Attain = "54"
Inst20Quest13_Aim = "Верните книгу законным владельцам."
Inst20Quest13_Location = "Кодекс Обороны (случайная добыча с боссов во всех частях Забытого города)"
Inst20Quest13_Note = "Задание для воинов: Вы относите книгу Сказителю Килдрату к "..YELLOW.."1' Библиотеке"..WHITE.."."
Inst20Quest13_Prequest = "Нет"
Inst20Quest13_Folgequest = "Нет"
--
Inst20Quest13name1 = "Королевская печать Эльдре'Таласа"

--Quest 14 Alliance
Inst20Quest14 = "14. Манускрипт Средоточия"
Inst20Quest14_Level = "60"
Inst20Quest14_Attain = "54"
Inst20Quest14_Aim = "Принесите сказителю Лидросу в Забытом Городе Манускрипт Средоточия, 1 безупречный черный алмаз, 4 больших сверкающих осколка и 2 образца шкуры тени, чтобы получить магический знак сосредоточения."
Inst20Quest14_Location = "Сказитель Лидрос (Забытый город (Запад); "..YELLOW.."[1'] Библиотека"..WHITE..")"
Inst20Quest14_Note = "Задание Эльфийские легенды должно быть завершено, прежде чем вы сможете получить это."
Inst20Quest14_Page = {2, "Манускрипт случайно добывается в Забытом городе и передается, так что он может быть найден  на аукционе. Шкура тени персональная и может выпасть с нескольких боссов, Восставших созданий и Восставших костостражей в "..YELLOW.."Некроситете"..WHITE..".", };
Inst20Quest14_Prequest = "Нет"
Inst20Quest14_Folgequest = "Нет"
--
Inst20Quest14name1 = "Магический камень сосредоточения"

--Quest 15 Alliance
Inst20Quest15 = "15. Манускрипт Защиты"
Inst20Quest15_Level = "60"
Inst20Quest15_Attain = "54"
Inst20Quest15_Aim = "Принесите сказителю Лидросу в Забытом Городе Манускрипт Защиты, 1 безупречный черный алмаз, 2 больших сверкающих осколка и 1 истлевшую шовную нить поганища, чтобы получить магический знак защиты."
Inst20Quest15_Location = "Сказитель Лидрос (Забытый город (Запад); "..YELLOW.."[1'] Библиотека"..WHITE..")"
Inst20Quest15_Note = "Задание Эльфийские легенды должно быть завершено, прежде чем вы сможете получить это."
Inst20Quest15_Page = {2, "Манускрипт случайно добывается в Забытом городе и передается, так что он может быть найден  на аукционе. Истлевшая шовная нить поганища персональная и может выпасть с Рамштайна Ненасытного, Изрыгателя яда, Желчеплюя и Лоскутного ужаса в "..YELLOW.."Стратхольме"..WHITE..".", };
Inst20Quest15_Prequest = "Нет"
Inst20Quest15_Folgequest = "Нет"
--
Inst20Quest15name1 = "Магический камень защиты"

--Quest 16 Alliance
Inst20Quest16 = "16. Манускрипт Скорости"
Inst20Quest16_Level = "60"
Inst20Quest16_Attain = "54"
Inst20Quest16_Aim = "Принесите сказителю Лидросу в Забытом Городе Манускрипт Скорости, 1 безупречный черный алмаз, 2 больших сверкающих осколка и 2 образца крови героев, чтобы получить магический знак стремительности."
Inst20Quest16_Location = "Сказитель Лидрос (Забытый город (Запад); "..YELLOW.."[1'] Библиотека"..WHITE..")"
Inst20Quest16_Note = "Задание Эльфийские легенды должно быть завершено, прежде чем вы сможете получить это."
Inst20Quest16_Page = {2, "Манускрипт случайно добывается в Забытом городе и передается, так что он может быть найден  на аукционе. Кровь героев персональная и может быть найдена на земле в случайных местах Западных и Восточных Чумных землях.", };
Inst20Quest16_Prequest = "Нет"
Inst20Quest16_Folgequest = "Нет"
--
Inst20Quest16name1 = "Магический камень стремительности"

--Quest 17 Alliance
Inst20Quest17 = "17. Справочник Форора (Воин, Паладин)"
Inst20Quest17_Level = "60"
Inst20Quest17_Attain = "60"
Inst20Quest17_Aim = "Верните Справочник Форора по убийству драконов в Читальню."
Inst20Quest17_Location = "Справочник Форора по истреблению драконов (случайная добыча с боссов в "..YELLOW.."Забытом городе"..WHITE..")"
Inst20Quest17_Note = "Задание для воинов или паладинов. Вы относите книгу Сказителю Лидросу в (Забытый город (Запад); "..YELLOW.."[1'] Библиотека"..WHITE.."). Завершение этого позволяет начать задание на Кель'Серрар."
Inst20Quest17_Prequest = "Нет"
Inst20Quest17_Folgequest = "Ковка Кель'Серрара" -- 7508
-- No Rewards for this quest


--Quest 1 Horde
Inst20Quest1_HORDE = "1. Эльфийские легенды"
Inst20Quest1_HORDE_Level = "60"
Inst20Quest1_HORDE_Attain = "54"
Inst20Quest1_HORDE_Aim = "Попытайтесь найти в Забытом Городе Кариэля Винтхалуса. Вернитесь в Лагерь Мохаче к Ведуну Королуску и сообщите ему все, что вам удалось узнать."
Inst20Quest1_HORDE_Location = "Ведун Королуск (Фералас - Лагерь Мохаче; "..YELLOW.."74,43"..WHITE..")"
Inst20Quest1_HORDE_Note = "Вы найдете Кариэля Винтхалуса в "..YELLOW.."Библиотеке (Запад)"..WHITE.."."
Inst20Quest1_HORDE_Prequest = "Нет"
Inst20Quest1_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst20Quest2_HORDE = Inst20Quest2
Inst20Quest2_HORDE_Level = Inst20Quest2_Level
Inst20Quest2_HORDE_Attain = Inst20Quest2_Attain
Inst20Quest2_HORDE_Aim = Inst20Quest2_Aim
Inst20Quest2_HORDE_Location = Inst20Quest2_Location
Inst20Quest2_HORDE_Note = Inst20Quest2_Note
Inst20Quest2_HORDE_Prequest = Inst20Quest2_Prequest
Inst20Quest2_HORDE_Folgequest = Inst20Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst20Quest3_HORDE = Inst20Quest3
Inst20Quest3_HORDE_Level = Inst20Quest3_Level
Inst20Quest3_HORDE_Attain = Inst20Quest3_Attain
Inst20Quest3_HORDE_Aim = Inst20Quest3_Aim
Inst20Quest3_HORDE_Location = Inst20Quest3_Location
Inst20Quest3_HORDE_Note = Inst20Quest3_Note
Inst20Quest3_HORDE_Prequest = Inst20Quest3_Prequest
Inst20Quest3_HORDE_Folgequest = Inst20Quest3_Folgequest
Inst20Quest3FQuest_HORDE = "true"
--
Inst20Quest3name1_HORDE = Inst20Quest3name1
Inst20Quest3name2_HORDE = Inst20Quest3name2
Inst20Quest3name3_HORDE = Inst20Quest3name3

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst20Quest4_HORDE = Inst20Quest4
Inst20Quest4_HORDE_Level = Inst20Quest4_Level
Inst20Quest4_HORDE_Attain = Inst20Quest4_Attain
Inst20Quest4_HORDE_Aim = Inst20Quest4_Aim
Inst20Quest4_HORDE_Location = Inst20Quest4_Location
Inst20Quest4_HORDE_Note = Inst20Quest4_Note
Inst20Quest4_HORDE_Prequest = Inst20Quest4_Prequest
Inst20Quest4_HORDE_Folgequest = Inst20Quest4_Folgequest
Inst20Quest4PreQuest_HORDE = "true"
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst20Quest5_HORDE = Inst20Quest5
Inst20Quest5_HORDE_Level = Inst20Quest5_Level
Inst20Quest5_HORDE_Attain = Inst20Quest5_Attain
Inst20Quest5_HORDE_Aim = Inst20Quest5_Aim
Inst20Quest5_HORDE_Location = Inst20Quest5_Location
Inst20Quest5_HORDE_Note = Inst20Quest5_Note
Inst20Quest5_HORDE_Prequest = Inst20Quest5_Prequest
Inst20Quest5_HORDE_Folgequest = Inst20Quest5_Folgequest
--
Inst20Quest5name1_HORDE = Inst20Quest5name1

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst20Quest6_HORDE = Inst20Quest6
Inst20Quest6_HORDE_Level = Inst20Quest6_Level
Inst20Quest6_HORDE_Attain = Inst20Quest6_Attain
Inst20Quest6_HORDE_Aim = Inst20Quest6_Aim
Inst20Quest6_HORDE_Location = Inst20Quest6_Location
Inst20Quest6_HORDE_Note = Inst20Quest6_Note
Inst20Quest6_HORDE_Prequest = Inst20Quest6_Prequest
Inst20Quest6_HORDE_Folgequest = Inst20Quest6_Folgequest
--
Inst20Quest6name1_HORDE = Inst20Quest6name1

--Quest 7 Horde  (same as Quest 7 Alliance)
Inst20Quest7_HORDE = Inst20Quest7
Inst20Quest7_HORDE_Level = Inst20Quest7_Level
Inst20Quest7_HORDE_Attain = Inst20Quest7_Attain
Inst20Quest7_HORDE_Aim = Inst20Quest7_Aim
Inst20Quest7_HORDE_Location = Inst20Quest7_Location
Inst20Quest7_HORDE_Note = Inst20Quest7_Note
Inst20Quest7_HORDE_Prequest = Inst20Quest7_Prequest
Inst20Quest7_HORDE_Folgequest = Inst20Quest7_Folgequest
--
Inst20Quest7name1_HORDE = Inst20Quest7name1

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst20Quest8_HORDE = Inst20Quest8
Inst20Quest8_HORDE_Level = Inst20Quest8_Level
Inst20Quest8_HORDE_Attain = Inst20Quest8_Attain
Inst20Quest8_HORDE_Aim = Inst20Quest8_Aim
Inst20Quest8_HORDE_Location = Inst20Quest8_Location
Inst20Quest8_HORDE_Note = Inst20Quest8_Note
Inst20Quest8_HORDE_Prequest = Inst20Quest8_Prequest
Inst20Quest8_HORDE_Folgequest = Inst20Quest8_Folgequest
--
Inst20Quest8name1_HORDE = Inst20Quest8name1

--Quest 9 Horde  (same as Quest 9 Alliance)
Inst20Quest9_HORDE = Inst20Quest9
Inst20Quest9_HORDE_Level = Inst20Quest9_Level
Inst20Quest9_HORDE_Attain = Inst20Quest9_Attain
Inst20Quest9_HORDE_Aim = Inst20Quest9_Aim
Inst20Quest9_HORDE_Location = Inst20Quest9_Location
Inst20Quest9_HORDE_Note = Inst20Quest9_Note
Inst20Quest9_HORDE_Prequest = Inst20Quest9_Prequest
Inst20Quest9_HORDE_Folgequest = Inst20Quest9_Folgequest
--
Inst20Quest9name1_HORDE = Inst20Quest9name1

--Quest 10 Horde  (same as Quest 10 Alliance)
Inst20Quest10_HORDE = Inst20Quest10
Inst20Quest10_HORDE_Level = Inst20Quest10_Level
Inst20Quest10_HORDE_Attain = Inst20Quest10_Attain
Inst20Quest10_HORDE_Aim = Inst20Quest10_Aim
Inst20Quest10_HORDE_Location = Inst20Quest10_Location
Inst20Quest10_HORDE_Note = Inst20Quest10_Note
Inst20Quest10_HORDE_Prequest = Inst20Quest10_Prequest
Inst20Quest10_HORDE_Folgequest = Inst20Quest10_Folgequest
--
Inst20Quest10name1_HORDE = Inst20Quest10name1

--Quest 11 Horde  (same as Quest 11 Alliance)
Inst20Quest11_HORDE = Inst20Quest11
Inst20Quest11_HORDE_Level = Inst20Quest11_Level
Inst20Quest11_HORDE_Attain = Inst20Quest11_Attain
Inst20Quest11_HORDE_Aim = Inst20Quest11_Aim
Inst20Quest11_HORDE_Location = Inst20Quest11_Location
Inst20Quest11_HORDE_Note = Inst20Quest11_Note
Inst20Quest11_HORDE_Prequest = Inst20Quest11_Prequest
Inst20Quest11_HORDE_Folgequest = Inst20Quest11_Folgequest
--
Inst20Quest11name1_HORDE = Inst20Quest11name1

--Quest 12 Horde  (same as Quest 12 Alliance)
Inst20Quest12_HORDE = Inst20Quest12
Inst20Quest12_HORDE_Level = Inst20Quest12_Level
Inst20Quest12_HORDE_Attain = Inst20Quest12_Attain
Inst20Quest12_HORDE_Aim = Inst20Quest12_Aim
Inst20Quest12_HORDE_Location = Inst20Quest12_Location
Inst20Quest12_HORDE_Note = Inst20Quest12_Note
Inst20Quest12_HORDE_Prequest = Inst20Quest12_Prequest
Inst20Quest12_HORDE_Folgequest = Inst20Quest12_Folgequest
--
Inst20Quest12name1_HORDE = Inst20Quest12name1

--Quest 13 Horde  (same as Quest 13 Alliance)
Inst20Quest13_HORDE = Inst20Quest13
Inst20Quest13_HORDE_Level = Inst20Quest13_Level
Inst20Quest13_HORDE_Attain = Inst20Quest13_Attain
Inst20Quest13_HORDE_Aim = Inst20Quest13_Aim
Inst20Quest13_HORDE_Location = Inst20Quest13_Location
Inst20Quest13_HORDE_Note = Inst20Quest13_Note
Inst20Quest13_HORDE_Prequest = Inst20Quest13_Prequest
Inst20Quest13_HORDE_Folgequest = Inst20Quest13_Folgequest
--
Inst20Quest13name1_HORDE = Inst20Quest13name1

--Quest 14 Horde  (same as Quest 14 Alliance)
Inst20Quest14_HORDE = Inst20Quest14
Inst20Quest14_HORDE_Level = Inst20Quest14_Level
Inst20Quest14_HORDE_Attain = Inst20Quest14_Attain
Inst20Quest14_HORDE_Aim = Inst20Quest14_Aim
Inst20Quest14_HORDE_Location = Inst20Quest14_Location
Inst20Quest14_HORDE_Note = Inst20Quest14_Note
Inst20Quest14_HORDE_Prequest = Inst20Quest14_Prequest
Inst20Quest14_HORDE_Folgequest = Inst20Quest14_Folgequest
--
Inst20Quest14name1_HORDE = Inst20Quest14name1

--Quest 15 Horde  (same as Quest 15 Alliance)
Inst20Quest15_HORDE = Inst20Quest15
Inst20Quest15_HORDE_Level = Inst20Quest15_Level
Inst20Quest15_HORDE_Attain = Inst20Quest15_Attain
Inst20Quest15_HORDE_Aim = Inst20Quest15_Aim
Inst20Quest15_HORDE_Location = Inst20Quest15_Location
Inst20Quest15_HORDE_Note = Inst20Quest15_Note
Inst20Quest15_HORDE_Prequest = Inst20Quest15_Prequest
Inst20Quest15_HORDE_Folgequest = Inst20Quest15_Folgequest
--
Inst20Quest15name1_HORDE = Inst20Quest15name1

--Quest 16 Horde  (same as Quest 16 Alliance)
Inst20Quest16_HORDE = Inst20Quest16
Inst20Quest16_HORDE_Level = Inst20Quest16_Level
Inst20Quest16_HORDE_Attain = Inst20Quest16_Attain
Inst20Quest16_HORDE_Aim = Inst20Quest16_Aim
Inst20Quest16_HORDE_Location = Inst20Quest16_Location
Inst20Quest16_HORDE_Note = Inst20Quest16_Note
Inst20Quest16_HORDE_Prequest = Inst20Quest16_Prequest
Inst20Quest16_HORDE_Folgequest = Inst20Quest16_Folgequest
--
Inst20Quest16name1_HORDE = Inst20Quest16name1

--Quest 17 Horde  (same as Quest 17 Alliance)
Inst20Quest17_HORDE = Inst20Quest17
Inst20Quest17_HORDE_Level = Inst20Quest17_Level
Inst20Quest17_HORDE_Attain = Inst20Quest17_Attain
Inst20Quest17_HORDE_Aim = Inst20Quest17_Aim
Inst20Quest17_HORDE_Location = Inst20Quest17_Location
Inst20Quest17_HORDE_Note = Inst20Quest17_Note
Inst20Quest17_HORDE_Prequest = Inst20Quest17_Prequest
Inst20Quest17_HORDE_Folgequest = Inst20Quest17_Folgequest
-- No Rewards for this quest



--------------- INST21 - Maraudon ---------------

Inst21Caption = "Мародон"
Inst21QAA = "8 заданий"
Inst21QAH = "8 заданий"

--Quest 1 Alliance
Inst21Quest1 = "1. Фрагменты осколка сумрака"
Inst21Quest1_Level = "42"
Inst21Quest1_Attain = "39"
Inst21Quest1_Aim = "Соберите в Мародоне 10 фрагментов осколков сумрака и отнесите их верховному магу Тервошу в Терамор на побережье Пылевых топей."
Inst21Quest1_Location = "Верховный маг Тервош (Пылевые топи - Остров Терамор; "..YELLOW.."66,49"..WHITE..")"
Inst21Quest1_Note = "Вы получите фрагменты осколка сумрака с 'Темнокаменных грохотунов' или 'Темнокаменных крушителей' снаружи подземелья на Фиолетовой стороне."
Inst21Quest1_Prequest = "Нет"
Inst21Quest1_Folgequest = "Нет"
--
Inst21Quest1name1 = "Могучая подвеска Осколков Сумрака"
Inst21Quest1name2 = "Чудесная подвеска Осколков Сумрака"

--Quest 2 Alliance
Inst21Quest2 = "2. Скверна Злоязыкого"
Inst21Quest2_Level = "47"
Inst21Quest2_Attain = "41"
Inst21Quest2_Aim = "Наполните лазурный фиал с внутренним покрытием в оранжевом пруду Мародона.\nПолейте гнусь-лозу из наполненного фиала, чтобы изгнать ядовитую лозу.\nИсцелите 8 растений, убивая ядовитые лозы, и вернитесь к Талендрии из Высоты Найджела."
Inst21Quest2_Location = "Талендрия (Пустоши - Высота Найджела; "..YELLOW.."68,8"..WHITE..")"
Inst21Quest2_Note = "Вы можете наполнить фиал в любом бассейне снаружи подземелья на Оранжевой стороне. Растения находятся в фиолетовой и оранжевой зонах внутри подземелья."
Inst21Quest2_Prequest = "Нет"
Inst21Quest2_Folgequest = "Нет"
--
Inst21Quest2name1 = "Кольцо Лесных Семян"
Inst21Quest2name2 = "Полынный ремень"
Inst21Quest2name3 = "Рукавицы Когтистой ветви"

--Quest 3 Alliance
Inst21Quest3 = "3. Хрустальные орнаменты"
Inst21Quest3_Level = "47"
Inst21Quest3_Attain = "41"
Inst21Quest3_Aim = "Соберите 15 терадрических хрустальных орнаментов для Ивы из Пустошей."
Inst21Quest3_Location = "Ива (Пустоши; "..YELLOW.."62,39"..WHITE..")"
Inst21Quest3_Note = "С большинства существ в Мародоне падают орнаменты."
Inst21Quest3_Prequest = "Нет"
Inst21Quest3_Folgequest = "Нет"
--
Inst21Quest3name1 = "Проницательные одеяния"
Inst21Quest3name2 = "Шлем Кольца духов"
Inst21Quest3name3 = "Беспощадная кольчуга"
Inst21Quest3name4 = "Наплечье мегакамня"

--Quest 4 Alliance
Inst21Quest4 = "4. Инструкции кентавра-парии"
Inst21Quest4_Level = "48"
Inst21Quest4_Attain = "39"
Inst21Quest4_Aim = "Прочтите инструкции кентавра-парии, добудьте из Мародона амулет Соединения и верните его кентавру-парии из южной части Пустошей."
Inst21Quest4_Location = "Кентавр-пария (Пустоши; "..YELLOW.."45,86"..WHITE..")"
Inst21Quest4_Note = "5 Ханов (Описание для инструкций парии)"
Inst21Quest4_Page = {2, "Вы найдете кентавра-парию в южных Пустошах. Он бродит между "..YELLOW.."44,85"..WHITE.." и "..YELLOW.."50,87"..WHITE..".\nСначала, Вам нужно убить Безымянного пророка. Вы найдете его перед тем, как войти в подземелье, перед точкой, где придется выбрать идти к Оранжевому или Фиолетовому входу. После него нужно убить 5 ханов. Второй - в Фиолетовой части Мародона, но перед входом в подземелье. Третий находится на Оранжевой стороне перед подземельем."};
Inst21Quest4_Prequest = "Нет"
Inst21Quest4_Folgequest = "Нет"
--
Inst21Quest4name1 = "Знак Избранного"

--Quest 5 Alliance
Inst21Quest5 = "5. Легенды Мародона"
Inst21Quest5_Level = "49"
Inst21Quest5_Attain = "41"
Inst21Quest5_Aim = "Добудьте две части скипетра Келебраса – жезл Келебраса и бриллиант Келебраса.\nНайдите способ поговорить с Келебрасом."
Inst21Quest5_Location = "Кавиндра (Пустоши - Мародон; "..YELLOW.."[4] на карте входа"..WHITE..")"
Inst21Quest5_Note = "Вы найдете Кавиндру в начале Оранжевой части перед подземельем.\nВы получите Келебрийский жезл с Ноксиона около "..YELLOW.."[2]"..WHITE..", а Келебрийский бриллиант с Лорда Злоязыкого  "..YELLOW.."[5]"..WHITE..". Келебрас находится около "..YELLOW.."[7]"..WHITE..". Вы должны победить его, чтобы поговорить."
Inst21Quest5_Prequest = "Нет"
Inst21Quest5_Folgequest = "Скипетр Келебраса"
-- No Rewards for this quest

--Quest 6 Alliance
Inst21Quest6 = "6. Скипетр Келебраса"
Inst21Quest6_Level = "49"
Inst21Quest6_Attain = "41"
Inst21Quest6_Aim = "Помогите Келебрасу Освобожденному воссоздать скипетр Келебраса.\nПо завершении ритуала снова обратитесь к нему."
Inst21Quest6_Location = "Келебрас Освобожденный (Мародон; "..YELLOW.."[7]"..WHITE..")"
Inst21Quest6_Note = "Келебрас создает Скипетр. Поговорите с ним, когда он закончит."
Inst21Quest6_Prequest = "Легенды Мародона" -- 7044
Inst21Quest6_Folgequest = "Нет"
Inst21Quest6FQuest = "true"
--
Inst21Quest6name1 = "Скипетр Селебраса"

--Quest 7 Alliance
Inst21Quest7 = "7. Яблочко от яблоньки..."
Inst21Quest7_Level = "51"
Inst21Quest7_Attain = "45"
Inst21Quest7_Aim = "Убейте принцессу Терадрас и вернитесь к хранителю Марандису на Высоту Найджела в Пустоши."
Inst21Quest7_Location = "Хранитель Марандис (Пустоши - Высота Найджела; "..YELLOW.."63,10"..WHITE..")"
Inst21Quest7_Note = "Вы найдете принцессу Терадрас около "..YELLOW.."[11]"..WHITE.."."
Inst21Quest7_Prequest = "Нет"
Inst21Quest7_Folgequest = "Семя Жизни" -- 7066
--
Inst21Quest7name1 = "Молотящий клинок"
Inst21Quest7name2 = "Жезл Возрождения"
Inst21Quest7name3 = "Цель Зеленого хранителя"

--Quest 8 Alliance
Inst21Quest8 = "8. Семя Жизни"
Inst21Quest8_Level = "51"
Inst21Quest8_Attain = "39"
Inst21Quest8_Aim = "Найдите в Лунной поляне Ремула и отдайте ему Семя Жизни."
Inst21Quest8_Location = "Дух Зейтара (Мародон; "..YELLOW.."[11]"..WHITE..")"
Inst21Quest8_Note = "Дух Зейтара появляется после убийства принцессы Терадрас "..YELLOW.."[11]"..WHITE..". Вы найдете хранителя Ремулоса около (Лунная поляна - Святилище Ремулоса; "..YELLOW.."36,41"..WHITE..")."
Inst21Quest8_Prequest = "Яблочко от яблоньки..." -- 7065
Inst21Quest8_Folgequest = "Нет"
Inst21Quest8FQuest = "true"
-- No Rewards for this quest


--Quest 1 Horde
Inst21Quest1_HORDE = "1. Фрагменты осколка сумрака"
Inst21Quest1_HORDE_Level = "42"
Inst21Quest1_HORDE_Attain = "39"
Inst21Quest1_HORDE_Aim = "Соберите в Мародоне 10 фрагментов осколков сумрака и отнесите их Утель'наю в Оргриммар."
Inst21Quest1_HORDE_Location = "Утель'най (Оргриммар - Аллея духов; "..YELLOW.."38,68"..WHITE..")"
Inst21Quest1_HORDE_Note = "Вы получите фрагменты осколка сумрака с 'Темнокаменных грохотунов' или 'Темнокаменных крушителей' снаружи подземелья на Фиолетовой стороне."
Inst21Quest1_HORDE_Prequest = "Нет"
Inst21Quest1_HORDE_Folgequest = "Нет"
--
Inst21Quest1name1_HORDE = "Могучая подвеска Осколков Сумрака"
Inst21Quest1name2_HORDE = "Чудесная подвеска Осколков Сумрака"

--Quest 2 Horde
Inst21Quest2_HORDE = "2. Скверна Злоязыкого"
Inst21Quest2_HORDE_Level = "47"
Inst21Quest2_HORDE_Attain = "41"
Inst21Quest2_HORDE_Aim = "Наполните лазурный фиал с внутренним покрытием в оранжевом пруду Мародона.\nПолейте гнусь-лозу из наполненного фиала, чтобы изгнать ядовитую лозу.\nИсцелите 8 растений, убивая ядовитые лозы, и вернитесь к Варку Боевому Шраму в Деревню Ночных Охотников."
Inst21Quest2_HORDE_Location = "Варк Боевой Шрам (Пустоши - Деревня Ночных охотников; "..YELLOW.."23,70"..WHITE..")"
Inst21Quest2_HORDE_Note = "Вы можете наполнить фиал в любом бассейне снаружи подземелья на Оранжевой стороне. Растения находятся в фиолетовой и оранжевой зонах внутри подземелья."
Inst21Quest2_HORDE_Prequest = "Нет"
Inst21Quest2_HORDE_Folgequest = "Нет"
--
Inst21Quest2name1_HORDE = "Кольцо Лесных Семян"
Inst21Quest2name2_HORDE = "Полынный ремень"
Inst21Quest2name3_HORDE = "Рукавицы Когтистой ветви"

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst21Quest3_HORDE = Inst21Quest3
Inst21Quest3_HORDE_Level = Inst21Quest3_Level
Inst21Quest3_HORDE_Attain = Inst21Quest3_Attain
Inst21Quest3_HORDE_Aim = Inst21Quest3_Aim
Inst21Quest3_HORDE_Location = Inst21Quest3_Location
Inst21Quest3_HORDE_Note = Inst21Quest3_Note
Inst21Quest3_HORDE_Prequest = Inst21Quest3_Prequest
Inst21Quest3_HORDE_Folgequest = Inst21Quest3_Folgequest
--
Inst21Quest3name1_HORDE = Inst21Quest3name1
Inst21Quest3name2_HORDE = Inst21Quest3name2
Inst21Quest3name3_HORDE = Inst21Quest3name3
Inst21Quest3name4_HORDE = Inst21Quest3name4

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst21Quest4_HORDE = Inst21Quest4
Inst21Quest4_HORDE_Level = Inst21Quest4_Level
Inst21Quest4_HORDE_Attain = Inst21Quest4_Attain
Inst21Quest4_HORDE_Aim = Inst21Quest4_Aim
Inst21Quest4_HORDE_Location = Inst21Quest4_Location
Inst21Quest4_HORDE_Note = Inst21Quest4_Note
Inst21Quest4_HORDE_Page = Inst21Quest4_Page
Inst21Quest4_HORDE_Prequest = Inst21Quest4_Prequest
Inst21Quest4_HORDE_Folgequest = Inst21Quest4_Folgequest
--
Inst21Quest4name1_HORDE = Inst21Quest4name1

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst21Quest5_HORDE = Inst21Quest5
Inst21Quest5_HORDE_Level = Inst21Quest5_Level
Inst21Quest5_HORDE_Attain = Inst21Quest5_Attain
Inst21Quest5_HORDE_Aim = Inst21Quest5_Aim
Inst21Quest5_HORDE_Location = Inst21Quest5_Location
Inst21Quest5_HORDE_Note = Inst21Quest5_Note
Inst21Quest5_HORDE_Prequest = Inst21Quest5_Prequest
Inst21Quest5_HORDE_Folgequest = Inst21Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst21Quest6_HORDE = Inst21Quest6
Inst21Quest6_HORDE_Level = Inst21Quest6_Level
Inst21Quest6_HORDE_Attain = Inst21Quest6_Attain
Inst21Quest6_HORDE_Aim = Inst21Quest6_Aim
Inst21Quest6_HORDE_Location = Inst21Quest6_Location
Inst21Quest6_HORDE_Note = Inst21Quest6_Note
Inst21Quest6_HORDE_Prequest = Inst21Quest6_Prequest
Inst21Quest6_HORDE_Folgequest = Inst21Quest6_Folgequest
Inst21Quest6FQuest_HORDE = Inst21Quest6FQuest
--
Inst21Quest6name1_HORDE = Inst21Quest6name1

--Quest 7 Horde
Inst21Quest7_HORDE = "7. Яблочко от яблоньки..."
Inst21Quest7_HORDE_Level = "51"
Inst21Quest7_HORDE_Attain = "45"
Inst21Quest7_HORDE_Aim = "Убейте принцессу Терадрас и вернитесь к Селендре неподалеку от Деревни Ночных Охотников в Пустошах."
Inst21Quest7_HORDE_Location = "Селендра (Пустоши; "..YELLOW.."27,77"..WHITE..")"
Inst21Quest7_HORDE_Note = "Вы найдете принцессу Терадрас около "..YELLOW.."[11]"..WHITE.."."
Inst21Quest7_HORDE_Prequest = "Нет"
Inst21Quest7_HORDE_Folgequest = "Семя Жизни"
--
Inst21Quest7name1_HORDE = "Молотящий клинок"
Inst21Quest7name2_HORDE = "Жезл Возрождения"
Inst21Quest7name3_HORDE = "Цель Зеленого хранителя"

--Quest 8 Horde  (same as Quest 8 Alliance)
Inst21Quest8_HORDE = Inst21Quest8
Inst21Quest8_HORDE_Level = Inst21Quest8_Level
Inst21Quest8_HORDE_Attain = Inst21Quest8_Attain
Inst21Quest8_HORDE_Aim = Inst21Quest8_Aim
Inst21Quest8_HORDE_Location = Inst21Quest8_Location
Inst21Quest8_HORDE_Note = Inst21Quest8_Note
Inst21Quest8_HORDE_Prequest = Inst21Quest8_Prequest
Inst21Quest8_HORDE_Folgequest = Inst21Quest8_Folgequest
Inst21Quest8FQuest_HORDE = Inst21Quest8FQuest
-- No Rewards for this quest



--------------- INST22 - Ragefire Chasm ---------------

Inst22Caption = "Огненная пропасть"
Inst22QAA = "Нет заданий"
Inst22QAH = "5 заданий"

--Quest 1 Horde
Inst22Quest1_HORDE = "1. Испытание силы врага"  -- 5723
Inst22Quest1_HORDE_Level = "15"
Inst22Quest1_HORDE_Attain = "9"
Inst22Quest1_HORDE_Aim = "Найдите в Оргриммаре Огненную пропасть, убейте 8 троггов и 8 шаманов Огненной пропасти и возвращайтесь к Рахауро в Громовой Утес."
Inst22Quest1_HORDE_Location = "Рахауро (Громовой Утес - Вершина Старейшин; "..YELLOW.."70,29"..WHITE..")"
Inst22Quest1_HORDE_Note = "Вы найдете троггов в самом начале подземелья."
Inst22Quest1_HORDE_Prequest = "Нет"
Inst22Quest1_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 2 Horde
Inst22Quest2_HORDE = "2. Силы разрушения..." -- 5725
Inst22Quest2_HORDE_Level = "16"
Inst22Quest2_HORDE_Attain = "9"
Inst22Quest2_HORDE_Aim = "Принесите книги Заклинания Тьмы и Заклятия Пустоты Вариматасу в Подгород."
Inst22Quest2_HORDE_Location = "Вариматас (Подгород - Королевский квартал; "..YELLOW.."56,92"..WHITE..")"
Inst22Quest2_HORDE_Note = "Книги падают с Сектантов и Чернокнижников из клана Пылающего клинка"
Inst22Quest2_HORDE_Prequest = "Нет"
Inst22Quest2_HORDE_Folgequest = "Нет"
--
Inst22Quest2name1_HORDE = "Мертвенные брюки"
Inst22Quest2name2_HORDE = "Поножи болотного черпателя"
Inst22Quest2name3_HORDE = "Поножи горгульи"

--Quest 3 Horde
Inst22Quest3_HORDE = "3. В поисках потерянного ранца" -- 5722
Inst22Quest3_HORDE_Level = "16"
Inst22Quest3_HORDE_Attain = "9"
Inst22Quest3_HORDE_Aim = "Обыщите Огненную пропасть в поисках тела Маура Зловещего Тотема и найдите все необычные предметы."
Inst22Quest3_HORDE_Location = "Рахауро (Громовой Утес - Вершина Старейшин; "..YELLOW.."70,29"..WHITE..")"
Inst22Quest3_HORDE_Note = "Вы найдете Маура Зловещего Тотема около "..YELLOW.."[1]"..WHITE..". После того как найдете рюкзак, вы должны вернуть его Рахауро в Громовой Утес"
Inst22Quest3_HORDE_Prequest = "Нет"
Inst22Quest3_HORDE_Folgequest = "Возвращение Потеряного ранца" -- 5724
--
Inst22Quest3name1_HORDE = "Перобисерные наручи"
Inst22Quest3name2_HORDE = "Наручи Саванны"

--Quest 4 Horde
Inst22Quest4_HORDE = "4. Тайные враги" -- 5728
Inst22Quest4_HORDE_Level = "16"
Inst22Quest4_HORDE_Attain = "9"
Inst22Quest4_HORDE_Aim = "Убейте Баззалана и Жергоша Призывателя Духов и вернитесь в Оргриммар к Траллу."
Inst22Quest4_HORDE_Location = "Тралл (Оргриммар - Аллея Мудрости; "..YELLOW.."31,37"..WHITE..")"
Inst22Quest4_HORDE_Note = "Вы найдете Баззалана около  "..YELLOW.."[4]"..WHITE.." и Джергоша около "..YELLOW.."[3]"..WHITE..". Линейка заданий начинается у Военного вождя Тралла в Оргриммаре."
Inst22Quest4_HORDE_Prequest = "Тайные враги"
Inst22Quest4_HORDE_Folgequest = "Тайные враг"
Inst22Quest4PreQuest_HORDE = "true"
--
Inst22Quest4name1_HORDE = "Крис Оргриммара"
Inst22Quest4name2_HORDE = "Молот Оргриммара"
Inst22Quest4name3_HORDE = "Топор Оргриммара"
Inst22Quest4name4_HORDE = "Посох Оргриммара"

--Quest 5 Horde
Inst22Quest5_HORDE = "5. Убить тварь" -- 5761
Inst22Quest5_HORDE_Level = "16"
Inst22Quest5_HORDE_Attain = "9"
Inst22Quest5_HORDE_Aim = "Спуститесь в Огненную пропасть, убейте Тарагамана Ненасытного и принесите его сердце Ниру Огненному Клинку в Оргриммаре."
Inst22Quest5_HORDE_Location = "Ниру Огненный Клинок (Оргриммар - Расселина Теней; "..YELLOW.."49,50"..WHITE..")"
Inst22Quest5_HORDE_Note = "Вы найдете Тарагамана около "..YELLOW.."[2]"..WHITE.."."
Inst22Quest5_HORDE_Prequest = "Нет"
Inst22Quest5_HORDE_Folgequest = "Нет"
-- No Rewards for this quest



--------------- INST23 - Razorfen Downs ---------------

Inst23Caption = "Курганы Иглошкурых"
Inst23QAA = "3 задания"
Inst23QAH = "4 задания"

--Quest 1 Alliance
Inst23Quest1 = "1. Воинство зла"
Inst23Quest1_Level = "35"
Inst23Quest1_Attain = "28"
Inst23Quest1_Aim = "Убейте 8 боевых стражей и 8 терноплетов из племени Иглошкурых, а также 8 сектанток из племени Мертвой Головы и возвращайтесь к Мириам Лунной Певице на Курганы Иглошкурых."
Inst23Quest1_Location = "Мириам Лунная Певица (Степи; "..YELLOW.."49,94"..WHITE..")"
Inst23Quest1_Note = "Вы сможете найти мобов и Мириам в зоне перед самым входом в подземелье."
Inst23Quest1_Prequest = "Нет"
Inst23Quest1_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 2 Alliance
Inst23Quest2 = "2. Уничтожить идола"
Inst23Quest2_Level = "37"
Inst23Quest2_Attain = "32"
Inst23Quest2_Aim = "Сопроводите Белнистраза к идолу свинобразов в Курганах Иглошкурых. Защищайте Белнистраза, пока он будет проводить ритуал, чтобы разрушить идола."
Inst23Quest2_Location = "Белнистраз (Курганы Иглошкурых; "..YELLOW.."[2]"..WHITE..")"
Inst23Quest2_Note = "Предшествующее задание заключается просто в согласии помочь ему. Несколько мобов появятся и атакуют Белнистраза когда он попытается сломать идол. После выполнения, вы можете сдать задание у жаровни перед идолом."
Inst23Quest2_Prequest = "Плеть в холмах" -- 3523
Inst23Quest2_Folgequest = "Нет"
Inst23Quest2PreQuest = "true"
--
Inst23Quest2name1 = "Кольцо Драконьего когтя"

--Quest 3 Alliance
Inst23Quest3 = "3. Нести свет"
Inst23Quest3_Level = "37"
Inst23Quest3_Attain = "32"
Inst23Quest3_Aim = "Убейте Амненнара Хладовея в Курганах Иглошкурых."
Inst23Quest3_Location = "Архиепископ Бенедикт (Штормград - Собор Света; "..YELLOW.."39,27"..WHITE..")"
Inst23Quest3_Note = "Амненнар Хладовей это последний босс в Курганах Иглошкурых. Вы найдете его около "..YELLOW.."[6]"..WHITE.."."
Inst23Quest3_Prequest = "Нет"
Inst23Quest3_Folgequest = "Нет"
--
Inst23Quest3name1 = "Меч Покорителя"
Inst23Quest3name2 = "Талисман Янтарного света"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst23Quest1_HORDE = Inst23Quest1
Inst23Quest1_HORDE_Level = Inst23Quest1_Level
Inst23Quest1_HORDE_Attain = Inst23Quest1_Attain
Inst23Quest1_HORDE_Aim = Inst23Quest1_Aim
Inst23Quest1_HORDE_Location = Inst23Quest1_Location
Inst23Quest1_HORDE_Note = Inst23Quest1_Note
Inst23Quest1_HORDE_Prequest = Inst23Quest1_Prequest
Inst23Quest1_HORDE_Folgequest = Inst23Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde
Inst23Quest2_HORDE = "2. Нечестивый союз"
Inst23Quest2_HORDE_Level = "36"
Inst23Quest2_HORDE_Attain = "28"
Inst23Quest2_HORDE_Aim = "Принесите голову посла Малкина Вариматасу в Подгород."
Inst23Quest2_HORDE_Location = "Вариматас (Подгород - Королевский квартал; "..YELLOW.."56,92"..WHITE..")"
Inst23Quest2_HORDE_Note = "Предшествующее задание можно подобрать с последнего босса в Лабиринтах Иглошкурых. Вы найдете Малкина снаружи (Степи; "..YELLOW.."48,92"..WHITE..")."
Inst23Quest2_HORDE_Prequest = "Нечестивый союз" -- 6522
Inst23Quest2_HORDE_Folgequest = "Нет"
Inst23Quest2PreQuest_HORDE = "true"
--
Inst23Quest2name1_HORDE = "Пробиватель черепов"
Inst23Quest2name2_HORDE = "Гвоздомет"
Inst23Quest2name3_HORDE = "Одеяние фанатика"

--Quest 3 Horde  (same as Quest 2 Alliance)
Inst23Quest3_HORDE = "3. Уничтожить идола"
Inst23Quest3_HORDE_Level = Inst23Quest2_Level
Inst23Quest3_HORDE_Attain = Inst23Quest2_Attain
Inst23Quest3_HORDE_Aim = Inst23Quest2_Aim
Inst23Quest3_HORDE_Location = Inst23Quest2_Location
Inst23Quest3_HORDE_Note = Inst23Quest2_Note
Inst23Quest3_HORDE_Prequest = Inst23Quest2_Prequest
Inst23Quest3_HORDE_Folgequest = Inst23Quest2_Folgequest
Inst23Quest3PreQuest_HORDE = Inst23Quest2PreQuest
--
Inst23Quest3name1_HORDE = Inst23Quest2name1

--Quest 4 Horde
Inst23Quest4_HORDE = "4. Да сгинет Хладовей"
Inst23Quest4_HORDE_Level = "42"
Inst23Quest4_HORDE_Attain = "37"
Inst23Quest4_HORDE_Aim = "Эндрю Браунелл поручил вам убить Амненнара Хладовея и принести его череп."
Inst23Quest4_HORDE_Location = "Эндрю Браунелл (Подгород - Квартал магов; "..YELLOW.."72,32"..WHITE..")"
Inst23Quest4_HORDE_Note = "Амненнар Хладовей это последний босс в Курганах Иглошкурых. Вы найдете его около "..YELLOW.."[6]"..WHITE.."."
Inst23Quest4_HORDE_Prequest = "Нет"
Inst23Quest4_HORDE_Folgequest = "Нет"
--
Inst23Quest4name1_HORDE = "Меч Покорителя"
Inst23Quest4name2_HORDE = "Талисман Янтарного света"



--------------- INST24 - Razorfen Kraul ---------------

Inst24Caption = "Лабиринты Иглошкурых"
Inst24QAA = "5 заданий"
Inst24QAH = "5 заданий"

--Quest 1 Alliance
Inst24Quest1 = "1. Корни Синелиста"
Inst24Quest1_Level = "26"
Inst24Quest1_Attain = "20"
Inst24Quest1_Aim = "В Лабиринтах Иглошкурых выпустите шмыгуноса и воспользуйтесь палочкой-погонялочкой, чтобы он начал искать корни.\nПринесите 6 корней синелиста, палочку и ящик с отверстиями Мебоку Миззриксу в Кабестан."
Inst24Quest1_Location = "Мебок Миззрикс (Степи - Кабестан; "..YELLOW.."62,37"..WHITE..")"
Inst24Quest1_Note = "Ящик, Стек и инструкцию можно найти рядом с Мебоком Миззриксом."
Inst24Quest1_Prequest = "Нет"
Inst24Quest1_Folgequest = "Нет"
--
Inst24Quest1name1 = "Маленькая шкатулка с самоцветами"

--Quest 2 Alliance
Inst24Quest2 = "2. Последнее желание"
Inst24Quest2_Level = "30"
Inst24Quest2_Attain = "25"
Inst24Quest2_Aim = "Найдите подвеску Трешалы и верните ее Трешале Бурый Ручей в Дарнас."
Inst24Quest2_Location = "Гералат Бурый Ручей (Лабиринты Иглошкурых; "..YELLOW.."[8]"..WHITE..")"
Inst24Quest2_Note = "Подвеска добывается случайно. Вы должны вернуть подвеску Трешале Бурый Ручей в Дарнасс - Терраса торговцев ("..YELLOW.."69,67"..WHITE..")."
Inst24Quest2_Prequest = "Нет"
Inst24Quest2_Folgequest = "Нет"
--
Inst24Quest2name1 = "Траурная шаль"
Inst24Quest2name2 = "Уланские сапоги"

--Quest 3 Alliance
Inst24Quest3 = "3. Импортер Вилликс"
Inst24Quest3_Level = "30"
Inst24Quest3_Attain = "22"
Inst24Quest3_Aim = "Сопроводите Вилликса из Лабиринтов Иглошкурых."
Inst24Quest3_Location = "Импортер Вилликс (Лабиринты Иглошкурых; "..YELLOW.."[8]"..WHITE..")"
Inst24Quest3_Note = "Импортера Вилликса нужно проводить к выходу из подземелья. Задание можно сдать ему после выполнения."
Inst24Quest3_Prequest = "Нет"
Inst24Quest3_Folgequest = "Нет"
--
Inst24Quest3name1 = "Кольцо Обезьяны"
Inst24Quest3name2 = "Кольцо Змеи"
Inst24Quest3name3 = "Кольцо Тигра"

--Quest 4 Alliance
Inst24Quest4 = "4. Хозяйка Лабиринтов"
Inst24Quest4_Level = "27"
Inst24Quest4_Attain = "23"
Inst24Quest4_Aim = "Принесите медальон Чарлги Остробок Фалфиндеру Хранителю Путей в Таланааре."
Inst24Quest4_Location = "Хранитель дорог Фалфиндел (Фералас - Таланаар; "..YELLOW.."89,46"..WHITE..")"
Inst24Quest4_Note = "Медальон, нужный для задания, добывается с Чарлги Остробок  "..YELLOW.."[7]"..WHITE.."."
Inst24Quest4_Prequest = "Дневник Хмурня"
Inst24Quest4_Folgequest = "Нет"
Inst24Quest4PreQuest = "true"
--
Inst24Quest4name1 = "Мушкетон Глаз мага"
Inst24Quest4name2 = "Берилловое оплечье"
Inst24Quest4name3 = "Ремень Каменного Кулакаe"
Inst24Quest4name4 = "Украшенный мрамором кулачный щит"

--Quest 5 Alliance
Inst24Quest5 = "5. Закаленный доспех(Воин)"
Inst24Quest5_Level = "28"
Inst24Quest5_Attain = "20"
Inst24Quest5_Aim = "Соберите все необходимые материалы для Фьюрена Длинноборода и отнесите их в Штормград."
Inst24Quest5_Location = "Фьюрен Длиннобород (Штормград - Квартал дворфов; "..YELLOW.."57,16"..WHITE..")"
Inst24Quest5_Note = "Задание для воинов. Вы заберете Сосуд флогистона у Ругуга около "..YELLOW.."[1]"..WHITE..".\n\nПоследующее задание отличается для каждой расы. Пылающая кровь для людей, Железный Коралл для дворфов и гномов и Высохшая скорлупа для ночных эльфов." -- 1705, 1710, 1708
Inst24Quest5_Prequest = "Щитник" -- 1702
Inst24Quest5_Folgequest = "(См. заметку)"
Inst24Quest5PreQuest = "true"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst24Quest1_HORDE = Inst24Quest1
Inst24Quest1_HORDE_Level = Inst24Quest1_Level
Inst24Quest1_HORDE_Attain = Inst24Quest1_Attain
Inst24Quest1_HORDE_Aim = Inst24Quest1_Aim
Inst24Quest1_HORDE_Location = Inst24Quest1_Location
Inst24Quest1_HORDE_Note = Inst24Quest1_Note
Inst24Quest1_HORDE_Prequest = Inst24Quest1_Prequest
Inst24Quest1_HORDE_Folgequest = Inst24Quest1_Folgequest
--
Inst24Quest1name1_HORDE = Inst24Quest1name1

--Quest 2 Horde  (same as Quest 3 Alliance)
Inst24Quest2_HORDE = "2. Импортер Вилликс"
Inst24Quest2_HORDE_Level = Inst24Quest3_Level
Inst24Quest2_HORDE_Attain = Inst24Quest3_Attain
Inst24Quest2_HORDE_Aim = Inst24Quest3_Aim
Inst24Quest2_HORDE_Location = Inst24Quest3_Location
Inst24Quest2_HORDE_Note = Inst24Quest3_Note
Inst24Quest2_HORDE_Prequest = Inst24Quest3_Prequest
Inst24Quest2_HORDE_Folgequest = Inst24Quest3_Folgequest
--
Inst24Quest2name1_HORDE = Inst24Quest3name1
Inst24Quest2name2_HORDE = Inst24Quest3name2
Inst24Quest2name3_HORDE = Inst24Quest3name3

-- Quest 3 Horde
Inst24Quest3_HORDE = "3. Груды гуано"
Inst24Quest3_HORDE_Level = "26"
Inst24Quest3_HORDE_Attain = "22"
Inst24Quest3_HORDE_Aim = "Принесите 1 кучку гуано летучей мыши Лабиринтов опытному аптекарю Фаранеллу в Подгород."
Inst24Quest3_HORDE_Location = "Опытный аптекарь Фаранелл (Подгород - Район Фармацевтов; "..YELLOW.."48,69 "..WHITE..")"
Inst24Quest3_HORDE_Note = "Гуано добывается с любой летучей мыши внутри подземелья."
Inst24Quest3_HORDE_Prequest = "Нет"
Inst24Quest3_HORDE_Folgequest = "Сердца Доблести ("..YELLOW.."[Монастырь Алого Ордена]"..WHITE..")"
-- No Rewards for this quest

--Quest 4 Horde
Inst24Quest4_HORDE = "4. Отмщение грядет!"
Inst24Quest4_HORDE_Level = "27"
Inst24Quest4_HORDE_Attain = "23"
Inst24Quest4_HORDE_Aim = "Принесите сердце Чарлги Остробок Ольду Каменному Копью в Громовой Утес."
Inst24Quest4_HORDE_Location = "Ольд Каменное Копье (Громовой Утес; "..YELLOW.."36,59"..WHITE..")"
Inst24Quest4_HORDE_Note = "Вы найдете Чарглу Остробок около "..YELLOW.."[7]"..WHITE.."."
Inst24Quest4_HORDE_Prequest = "Нет"
Inst24Quest4_HORDE_Folgequest = "Нет"
--
Inst24Quest4name1_HORDE = "Берилловое оплечье"
Inst24Quest4name2_HORDE = "Ремень Каменного Кулака"
Inst24Quest4name3_HORDE = "Украшенный мрамором кулачный щит"

--Quest 5 Horde
Inst24Quest5_HORDE = "5. Доспехи Жестокости(Воин)"
Inst24Quest5_HORDE_Level = "30"
Inst24Quest5_HORDE_Attain = "20"
Inst24Quest5_HORDE_Aim = "Принесите Тун'гриму Огневзору 15 закопченных железных слитков, 10 мер толченого азурита, 10 железных слитков и сосуд флогистона."
Inst24Quest5_HORDE_Location = "Тун'грим Огневзор (Степи; "..YELLOW.."57,30"..WHITE..")"
Inst24Quest5_HORDE_Note = "Задание для воинов. Вы заберете Сосуд флогистона у Ругуга около "..YELLOW.."[1]"..WHITE..".\n\nВыполнение задания позволит вам начать еще 4 новых задания у того же персонажа."
Inst24Quest5_HORDE_Prequest = "Поговорить с Тун'гримом" -- 1825
Inst24Quest5_HORDE_Folgequest = "(см. заметки)"
Inst24Quest5PreQuest_HORDE = "true"
-- No Rewards for this quest



--------------- INST25 - Wailing Caverns ---------------

Inst25Caption = "Пещеры стенаний"
Inst25QAA = "5 заданий"
Inst25QAH = "7 заданий"

--Quest 1 Alliance
Inst25Quest1 = "1. Шкуры загадочных существ" --1486
Inst25Quest1_Level = "17"
Inst25Quest1_Attain = "13"
Inst25Quest1_Aim = "Принесите 20 искаженных шкур Налпаку в Пещерах Стенаний."
Inst25Quest1_Location = "Наплак (Степи - Пещеры стенаний; "..YELLOW.."47,36 "..WHITE..")"
Inst25Quest1_Note = "Со всех существ внутри и перед подземельем можно подобрать шкуры.\nНаплака можно найти в тайной пещере над входом в Пещеры стенаний. Простейший путь увидеть его - забраться на гору позади входа и спрыгнуть на небольшой выступ слева над входом в пещеру."
Inst25Quest1_Prequest = "Нет"
Inst25Quest1_Folgequest = "Нет"
--
Inst25Quest1name1 = "Поножи из искаженной чешуи"
Inst25Quest1name2 = "Сума из искаженной шкуры"

--Quest 2 Alliance
Inst25Quest2 = "2. Неприятности в порту" -- 959
Inst25Quest2_Level = "18"
Inst25Quest2_Attain = "14"
Inst25Quest2_Aim = "Оператор крана Биггльфузз из Кабестана попросил Вас отнять бутылку портвейна 99-летней выдержки у Безумного Магглиша, который прячется в Пещерах Стенаний."
Inst25Quest2_Location = "Оператор крана Биггльфузз (Степи - Кабестан; "..YELLOW.."63,37 "..WHITE..")"
Inst25Quest2_Note = "Получить бутылку можно прямо перед тем как вы войдете в подземелье, убив Безумного Магглиша. Когда вы только вошли в пещеру идите направо и найдете его в конце прохода. Он скрывается у стены."
Inst25Quest2_Prequest = "Нет"
Inst25Quest2_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 3 Alliance
Inst25Quest3 = "3. Умный напиток" -- 1491
Inst25Quest3_Level = "18"
Inst25Quest3_Attain = "14"
Inst25Quest3_Aim = "Принесите 6 порций воющей субстанции Мебоку Миззриксу в Кабестан."
Inst25Quest3_Location = "Мебок Миззрикс (Степи - Кабестан; "..YELLOW.."62,37 "..WHITE..")"
Inst25Quest3_Note = "Предшествующее задание также можно взять у Мебока Миззрикса.\nИз всех врагов-эктоплазмы внутри и перед подземельем можно достать субстанцию."
Inst25Quest3_Prequest = "Рога ящеров" -- 865
Inst25Quest3_Folgequest = "Нет"
Inst25Quest3PreQuest = "true"
-- No Rewards for this quest

--Quest 4 Alliance
Inst25Quest4 = "4. Искоренение Скверны" -- 1487
Inst25Quest4_Level = "21"
Inst25Quest4_Attain = "15"
Inst25Quest4_Aim = "Убейте для Эбру 7 загадочных опустошителей, 7 загадочных гадюк, 7 загадочных шаркунов и 7 загадочных страхозубов."
Inst25Quest4_Location = "Эбру (Степи; "..YELLOW.."47,36 "..WHITE..")"
Inst25Quest4_Note = "Эбру находится в тайной пещере над входом в Пещеры стенаний. Простейший путь увидеть его - забраться на гору позади входа и спрыгнуть на небольшой выступ слева над входом в пещеру."
Inst25Quest4_Prequest = "Нет"
Inst25Quest4_Folgequest = "Нет"
--
Inst25Quest4name1 = "Выкройка: пояс из отражающей чешуи"
Inst25Quest4name2 = "Шипящее древко"
Inst25Quest4name3 = "Рукавицы Грязнотопи"

--Quest 5 Alliance
Inst25Quest5 = "5. Светящийся осколок" -- 6981
Inst25Quest5_Level = "25"
Inst25Quest5_Attain = "21"
Inst25Quest5_Aim = "Отправляйтесь в Кабестан и найдите там кого-нибудь, кто сможет вам рассказать об этом светящемся осколке. Затем отнесите осколок туда, куда вас направят."
Inst25Quest5_Location = "Светящийся осколок (добывается с Мутануса Пожирателя; (Пещеры стенаний)"
Inst25Quest5_Note = "Мутанус Пожиратель появляется только если вы убили всех 4 повелителей змей и проводили таурена-друда от входа.\nКогда вы возьмете осколок, вам нужно принести его к гоблину-пилоту около банка в Кабестане, а потом на вершину горы над Пещерами стенаний к Фалле Мудрости Ветра."
Inst25Quest5_Prequest = "Нет"
Inst25Quest5_Folgequest = "Кошмары" -- 3370
--
Inst25Quest5name1 = "Оплечье Талбар"
Inst25Quest5name2 = "Трясинные галоши"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst25Quest1_HORDE = Inst25Quest1
Inst25Quest1_HORDE_Level = Inst25Quest1_Level
Inst25Quest1_HORDE_Attain = Inst25Quest1_Attain
Inst25Quest1_HORDE_Aim = Inst25Quest1_Aim
Inst25Quest1_HORDE_Location = Inst25Quest1_Location
Inst25Quest1_HORDE_Note = Inst25Quest1_Note
Inst25Quest1_HORDE_Prequest = Inst25Quest1_Prequest
Inst25Quest1_HORDE_Folgequest = Inst25Quest1_Folgequest
--
Inst25Quest1name1_HORDE = Inst25Quest1name1
Inst25Quest1name2_HORDE = Inst25Quest1name2

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst25Quest2_HORDE = Inst25Quest2
Inst25Quest2_HORDE_Level = Inst25Quest2_Level
Inst25Quest2_HORDE_Attain = Inst25Quest2_Attain
Inst25Quest2_HORDE_Aim = Inst25Quest2_Aim
Inst25Quest2_HORDE_Location = Inst25Quest2_Location
Inst25Quest2_HORDE_Note = Inst25Quest2_Note
Inst25Quest2_HORDE_Prequest = Inst25Quest2_Prequest
Inst25Quest2_HORDE_Folgequest = Inst25Quest2_Folgequest
-- No Rewards for this quest

--Quest 3 Horde
Inst25Quest3_HORDE = "3. Змеецвет" -- 962
Inst25Quest3_HORDE_Level = "18"
Inst25Quest3_HORDE_Attain = "14"
Inst25Quest3_HORDE_Aim = "Аптекарь Зама из Громового Утеса просит Вас принести ей 10 змеецветов."
Inst25Quest3_HORDE_Location = "Аптекарь Зама (Громовой Утес - Вершина Духов; "..YELLOW.."22,20 "..WHITE..")"
Inst25Quest3_HORDE_Note = "Аптекарь Зама находится в пещере под Вершиной Духов.\nСобрать Змеецвет можно внутри пещеры перед подземельем и внутри него. Игроки с навыком травничества могут видеть Змеецвет на миникарте."
Inst25Quest3_HORDE_Prequest = "Споры грибов -> Аптекарь Зама" -- 848 -> 853
Inst25Quest3_HORDE_Folgequest = "Нет"
Inst25Quest3PreQuest_HORDE = "true"
--
Inst25Quest3name1_HORDE = "Перчатки аптекаря"

--Quest 4 Horde  (same as Quest 3 Alliance)
Inst25Quest4_HORDE = "4. Умный напиток"
Inst25Quest4_HORDE_Level = Inst25Quest3_Level
Inst25Quest4_HORDE_Attain = Inst25Quest3_Attain
Inst25Quest4_HORDE_Aim = Inst25Quest3_Aim
Inst25Quest4_HORDE_Location = Inst25Quest3_Location
Inst25Quest4_HORDE_Note = Inst25Quest3_Note
Inst25Quest4_HORDE_Prequest = Inst25Quest3_Prequest
Inst25Quest4_HORDE_Folgequest = Inst25Quest3_Folgequest
Inst25Quest4PreQuest_HORDE = Inst25Quest3PreQuest
-- No Rewards for this quest

--Quest 5 Horde  (same as Quest 4 Alliance)
Inst25Quest5_HORDE = "5. Искоренение Скверны"
Inst25Quest5_HORDE_Level = Inst25Quest4_Level
Inst25Quest5_HORDE_Attain = Inst25Quest4_Attain
Inst25Quest5_HORDE_Aim = Inst25Quest4_Aim
Inst25Quest5_HORDE_Location = Inst25Quest4_Location
Inst25Quest5_HORDE_Note = Inst25Quest4_Note
Inst25Quest5_HORDE_Prequest = Inst25Quest4_Prequest
Inst25Quest5_HORDE_Folgequest = Inst25Quest4_Folgequest
--
Inst25Quest5name1_HORDE = Inst25Quest4name1
Inst25Quest5name2_HORDE = Inst25Quest4name2
Inst25Quest5name3_HORDE = Inst25Quest4name3

--Quest 6 Horde
Inst25Quest6_HORDE = "6. Повелители Змей" -- 914
Inst25Quest6_HORDE_Level = "22"
Inst25Quest6_HORDE_Attain = "18"
Inst25Quest6_HORDE_Aim = "Принесите самоцветы Кобрана, Анакондры, Пифаса и Серпентиса Наре Буйногривой в Громовой Утес."
Inst25Quest6_HORDE_Location = "Нара Буйногривая (Громовой Утес - Вершина старейшин; "..YELLOW.."75,31"..WHITE..")"
Inst25Quest6_HORDE_Note = "Серия заданий начинается у Хамуула Рунного Тотема. (Громовой Утес - Вершина старейшин; "..YELLOW.."78,28"..WHITE..")\nКамни падают с 4 друидов "..YELLOW.."[2]"..WHITE..", "..YELLOW.."[3]"..WHITE..", "..YELLOW.."[5]"..WHITE..", "..YELLOW.."[7]"..WHITE.."."
Inst25Quest6_HORDE_Prequest = "Оазисы Степей -> Нара Буйногривая" -- 886 -> 1490
Inst25Quest6_HORDE_Folgequest = "Нет"
Inst25Quest6PreQuest_HORDE = "true"
--
Inst25Quest6name1_HORDE = "Посох Полумесяца"
Inst25Quest6name2_HORDE = "Крыло-клинок"

--Quest 7 Horde  (same as Quest 5 Alliance)
Inst25Quest7_HORDE = "7. Светяшийся осколок"
Inst25Quest7_HORDE_Level = Inst25Quest5_Level
Inst25Quest7_HORDE_Attain = Inst25Quest5_Attain
Inst25Quest7_HORDE_Aim = Inst25Quest5_Aim
Inst25Quest7_HORDE_Location = Inst25Quest5_Location
Inst25Quest7_HORDE_Note = Inst25Quest5_Note
Inst25Quest7_HORDE_Prequest = Inst25Quest5_Prequest
Inst25Quest7_HORDE_Folgequest = Inst25Quest5_Folgequest
--
Inst25Quest7name1_HORDE = Inst25Quest5name1
Inst25Quest7name2_HORDE = Inst25Quest5name2



--------------- INST27 - Zul'Farrak ---------------

Inst26Caption = "Зул'Фаррак"
Inst26QAA = "7 заданий"
Inst26QAH = "7 заданий"

--Quest 1 Alliance
Inst26Quest1 = "1. Троллье месиво"
Inst26Quest1_Level = "45"
Inst26Quest1_Attain = "40"
Inst26Quest1_Aim = "Принесите 20 фиалов с Тролльим месивом."
Inst26Quest1_Location = "Трентон Молот Света (Танарис - Прибамбасск; "..YELLOW.."51,28"..WHITE..")"
Inst26Quest1_Note = "Месиво падет со всех троллей."
Inst26Quest1_Prequest = "Нет"
Inst26Quest1_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 2 Alliance
Inst26Quest2 = "2. Панцири скарабеев"
Inst26Quest2_Level = "45"
Inst26Quest2_Attain = "40"
Inst26Quest2_Aim = "Принести 5 целых панцирей скарабея Тран'реку в Прибамбасск."
Inst26Quest2_Location = "Тран'рек (Танарис - Прибамбасск; "..YELLOW.."51,26"..WHITE..")"
Inst26Quest2_Note = "Предшествующее задание начинается у Кразека (Тернистая долина - Пиратская бухта; "..YELLOW.."25,77"..WHITE..").\nПанцири могут упасть с любого скарабея. Множество скарабеев находится около "..YELLOW.."[2]"..WHITE.."."
Inst26Quest2_Prequest = "Тран'рек"
Inst26Quest2_Folgequest = "Нет"
Inst26Quest2PreQuest = "true"
-- No Rewards for this quest

--Quest 3 Alliance
Inst26Quest3 = "3. Тиара Глубин"
Inst26Quest3_Level = "46"
Inst26Quest3_Attain = "40"
Inst26Quest3_Aim = "Принесите Тиару Глубин Табете в Пылевых топях."
Inst26Quest3_Location = " Табета (Пылевые топи; "..YELLOW.."46,57"..WHITE..")"
Inst26Quest3_Note = "Возьмите предшествующее задание у Бинк (Стальгорн; "..YELLOW.."25,8"..WHITE..").\nТиара глубин добывается с гидроманта Велраты около "..YELLOW.."[6]"..WHITE.."."
Inst26Quest3_Prequest = "Миссия Табеты" -- 2861
Inst26Quest3_Folgequest = "Нет"
Inst26Quest3PreQuest = "true"
--
Inst26Quest3name1 = "Жезл Смены заклятий"
Inst26Quest3name2 = "Наплечье Драгоценной скорлупы"

--Quest 4 Alliance
Inst26Quest4 = "4. Медальон Некрума"
Inst26Quest4_Level = "47"
Inst26Quest4_Attain = "40"
Inst26Quest4_Aim = "Принесите медальон Некрума Тадиусу Мрачной Тени в Выжженные земли."
Inst26Quest4_Location = "Тадиус Мрачная Тень (Выжженные земли - Крепость Стражей Пустоты; "..YELLOW.."66,19"..WHITE..")"
Inst26Quest4_Note = "Линейка заданий начинается у укротителя грифонов Разящего Когтя (Внутренние земли - Цитадель Громового Молота; "..YELLOW.."9,44"..WHITE..").\nНекрум появляется около "..YELLOW.."[4]"..WHITE.." с последней волной боя Храмового события."
Inst26Quest4_Prequest = "Тролльи клетки -> Тадиус Мрачная Тень" -- 2988 -> 2990
Inst26Quest4_Folgequest = "Прорицание"
Inst26Quest4PreQuest = "true"
-- No Rewards for this quest

--Quest 5 Alliance
Inst26Quest5 = "5. Пророчество Мошару"
Inst26Quest5_Level = "47"
Inst26Quest5_Attain = "40"
Inst26Quest5_Aim = "Принесите первую и вторую таблички Мошару Йе'кинье в Танарис."
Inst26Quest5_Location = "Йе'кинья (Танарис - Порт Картеля; "..YELLOW.."66,22"..WHITE..")"
Inst26Quest5_Note = "Вы возьмете предшествующее задание у того же НИП.\nТаблички падают с Теки Мученика около "..YELLOW.."[2]"..WHITE.." и гидроманта Велраты около "..YELLOW.."[6]"..WHITE.."."
Inst26Quest5_Prequest = "Духи крикунов" -- 3520
Inst26Quest5_Folgequest = "Древнее яйцо"
Inst26Quest5PreQuest = "true"
-- No Rewards for this quest

--Quest 6 Alliance
Inst26Quest6 = "6. Изыскательский стержень"
Inst26Quest6_Level = "47"
Inst26Quest6_Attain = "40"
Inst26Quest6_Aim = "Принесите изыскательский жезл главному инженеру Чепухастеру в Прибамбасск."
Inst26Quest6_Location = "Главный инженер Чепухастер (Танарис - Прибамбасск; "..YELLOW.."52,28"..WHITE..")"
Inst26Quest6_Note = "Вы заберете жезл у сержанта Блая. Вы найдете его около "..YELLOW.."[4]"..WHITE.." после Храмового события."
Inst26Quest6_Prequest = "Нет"
Inst26Quest6_Folgequest = "Нет"
--
Inst26Quest6name1 = "Кольцо Масонского братства"
Inst26Quest6name2 = "Головной убор Гильдий"

--Quest 7 Alliance
Inst26Quest7 = "7. Газ'рилла"
Inst26Quest7_Level = "50"
Inst26Quest7_Attain = "40"
Inst26Quest7_Aim = "Принесите искрящую чешую Газ'риллы Виззлу Медноштифу на Мерцающую равнину."
Inst26Quest7_Location = "Виззл Медноштиф (Тысяча Игл - Миражи на виражах; "..YELLOW.."78,77"..WHITE..")"
Inst26Quest7_Note = "Вы возьмете предшествующее задание у Клацморта Гайкокрута (Стальгорн - Город механиков; "..YELLOW.."68,46"..WHITE.."). Чтобы получить задание Газ'рилла, предшествующее задание выполнять необязательно.\nВы вызовете Газ'риллу около "..YELLOW.."[6]"..WHITE.." с помощью Молота Зул'Фаррака.\nСвященный молот добывается с Квиаги Хранительницы (Внутренние земли - Алтарь Зула; "..YELLOW.."49,70"..WHITE..") и должен быть завершен на алтаре в Джинта'Алоре около "..YELLOW.."59,77"..WHITE.." перед тем как его можно будет использовать в Зул'Фарраке."
Inst26Quest7_Prequest = "Братья Медноштиф"
Inst26Quest7_Folgequest = "Нет"
Inst26Quest7PreQuest = "true"
--
Inst26Quest7name1 = "Морковка на палочке"


--Quest 1 Horde
Inst26Quest1_HORDE = "1. Паучья богиня"
Inst26Quest1_HORDE_Level = "45"
Inst26Quest1_HORDE_Attain = "40"
Inst26Quest1_HORDE_Aim = "Прочитайте надписи на табличке Теки, узнайте имя паучьей богини, которой поклоняются тролли Сухокожих, а потом возвращайтесь к мастеру Гадрину."
Inst26Quest1_HORDE_Location = "Мастер Гадрин (Дуротар - Деревня Сен'джин; "..YELLOW.."55,74"..WHITE..")"
Inst26Quest1_HORDE_Note = "Линейка заданий начинается с Бутылки с ядом, которые стоят на столах в деревнях троллей во Внутренних землях.\nВы найдете табличку около "..YELLOW.."[2]"..WHITE.."."
Inst26Quest1_HORDE_Prequest = "Бутыли с ядом -> Разговор с мастером Гадрином" -- 2933 -> 2935
Inst26Quest1_HORDE_Folgequest = "Призыв Шадры"
Inst26Quest1PreQuest_HORDE = "true"
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 1 Alliance)
Inst26Quest2_HORDE = Inst26Quest1
Inst26Quest2_HORDE_Level = Inst26Quest1_Level
Inst26Quest2_HORDE_Attain = Inst26Quest1_Attain
Inst26Quest2_HORDE_Aim = Inst26Quest1_Aim
Inst26Quest2_HORDE_Location = Inst26Quest1_Location
Inst26Quest2_HORDE_Note = Inst26Quest1_Note
Inst26Quest2_HORDE_Prequest = Inst26Quest1_Prequest
Inst26Quest2_HORDE_Folgequest = Inst26Quest1_Folgequest
-- No Rewards for this quest

--Quest 3 Horde  (same as Quest 2 Alliance)
Inst26Quest3_HORDE = Inst26Quest2
Inst26Quest3_HORDE_Level = Inst26Quest2_Level
Inst26Quest3_HORDE_Attain = Inst26Quest2_Attain
Inst26Quest3_HORDE_Aim = Inst26Quest2_Aim
Inst26Quest3_HORDE_Location = Inst26Quest2_Location
Inst26Quest3_HORDE_Note = Inst26Quest2_Note
Inst26Quest3_HORDE_Prequest = Inst26Quest2_Prequest
Inst26Quest3_HORDE_Folgequest = Inst26Quest2_Folgequest
Inst26Quest3PreQuest_HORDE = Inst26Quest2PreQuest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 3 Alliance - no prequest)
Inst26Quest4_HORDE = Inst26Quest3
Inst26Quest4_HORDE_Level = Inst26Quest3_Level
Inst26Quest4_HORDE_Attain = Inst26Quest3_Attain
Inst26Quest4_HORDE_Aim = Inst26Quest3_Aim
Inst26Quest4_HORDE_Location = Inst26Quest3_Location
Inst26Quest4_HORDE_Note = Inst26Quest3_Note
Inst26Quest4_HORDE_Prequest = "Нет"
Inst26Quest4_HORDE_Folgequest = Inst26Quest3_Folgequest
--
Inst26Quest4name1_HORDE = Inst26Quest3name1
Inst26Quest4name2_HORDE = Inst26Quest3name2

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst26Quest5_HORDE = Inst26Quest5
Inst26Quest5_HORDE_Level = Inst26Quest5_Level
Inst26Quest5_HORDE_Attain = Inst26Quest5_Attain
Inst26Quest5_HORDE_Aim = Inst26Quest5_Aim
Inst26Quest5_HORDE_Location = Inst26Quest5_Location
Inst26Quest5_HORDE_Note = Inst26Quest5_Note
Inst26Quest5_HORDE_Prequest = Inst26Quest5_Prequest
Inst26Quest5_HORDE_Folgequest = Inst26Quest5_Folgequest
Inst26Quest5PreQuest_HORDE = Inst26Quest5Prequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst26Quest6_HORDE = Inst26Quest6
Inst26Quest6_HORDE_Level = Inst26Quest6_Level
Inst26Quest6_HORDE_Attain = Inst26Quest6_Attain
Inst26Quest6_HORDE_Aim = Inst26Quest6_Aim
Inst26Quest6_HORDE_Location = Inst26Quest6_Location
Inst26Quest6_HORDE_Note = Inst26Quest6_Note
Inst26Quest6_HORDE_Prequest = Inst26Quest6_Prequest
Inst26Quest6_HORDE_Folgequest = Inst26Quest6_Folgequest
--
Inst26Quest6name1_HORDE = Inst26Quest6name1
Inst26Quest6name2_HORDE = Inst26Quest6name2

--Quest 7 Horde  (same as Quest 7 Alliance - no prequest)
Inst26Quest7_HORDE = Inst26Quest7
Inst26Quest7_HORDE_Level = Inst26Quest7_Level
Inst26Quest7_HORDE_Attain = Inst26Quest7_Attain
Inst26Quest7_HORDE_Aim = Inst26Quest7_Aim
Inst26Quest7_HORDE_Location = Inst26Quest7_Location
Inst26Quest7_HORDE_Note = "Чтобы получить задание Газ'рилла, предшествующее задание выполнять необязательно.\nВы вызовете Газ'риллу около"..YELLOW.."[6]"..WHITE.." с помощью Молота Зул'Фаррака.\nСвященный молот добывается с Квиаги Хранительницы."
Inst26Quest7_HORDE_Prequest = "Нет"
Inst26Quest7_HORDE_Folgequest = Inst26Quest7_Folgequest
--
Inst26Quest7name1_HORDE = Inst26Quest7name1



--------------- INST27 - Molten Core ---------------

Inst27Caption = "Огненные Недра"
Inst27QAA = "6 заданий"
Inst27QAH = "6 заданий"

--Quest 1 Alliance
Inst27Quest1 = "1. Огненные Недра"
Inst27Quest1_Level = "60"
Inst27Quest1_Attain = "58"
Inst27Quest1_Aim = "Убейте 1 Повелителя огня, 1 лавового великана, 1 древнюю гончую Недр и 1 лавового волноплеска и возвращайтесь к герцогу Гидраксису в Азшару."
Inst27Quest1_Location = "Герцог Гидраксис (Азшара; "..YELLOW.."79,73"..WHITE..")"
Inst27Quest1_Note = "Это не боссы в Огненных Недрах."
Inst27Quest1_Prequest = "Око Углевзора ("..YELLOW.."Вершина Черной горы"..WHITE..")" -- 6821
Inst27Quest1_Folgequest = "Агент Гидраксиса"
Inst27Quest1PreQuest = "true"
-- No Rewards for this quest

--Quest 2 Alliance
Inst27Quest2 = "2. Руки врага"
Inst27Quest2_Level = "60"
Inst27Quest2_Attain = "55"
Inst27Quest2_Aim = "Принесите руки Люцифрона, Сульфурона, Гееннаса и Шаззраха герцогу Гидраксису в Азшару."
Inst27Quest2_Location = "Герцог Гидраксис (Азшара; "..YELLOW.."79,73"..WHITE..")"
Inst27Quest2_Note = "Люцифрон около"..YELLOW.."[1]"..WHITE..", Сульфурон около"..YELLOW.."[8]"..WHITE..", Гееннас около"..YELLOW.."[3]"..WHITE.." и Шаззрах около"..YELLOW.."[5]"..WHITE.."."
Inst27Quest2_Prequest = "Агент Гидраксиса" -- 6823
Inst27Quest2_Folgequest = "Награда для героя"
Inst27Quest2FQuest = "true"
--
Inst27Quest2name1 = "Океанский Ветер"
Inst27Quest2name2 = "Кольцо Приливов"

--Quest 3 Alliance
Inst27Quest3 = "3. Громораан Искатель Ветра"
Inst27Quest3_Level = "60"
Inst27Quest3_Attain = "60"
Inst27Quest3_Aim = "Чтобы освободить Громораана Искателя Ветра из тюрьмы, отнесите правый и левый наручник Ветроносца, 10 слитков элементия и сущность Повелителя огня верховному лорду Демитриану."
Inst27Quest3_Location = "Верховный лорд Демитриан (Силитус; "..YELLOW.."22,9"..WHITE..")"
Inst27Quest3_Note = "Часть цепочки заданий на получение Громовой Ярости, благословенного клинка Искателя Ветра. Оно начинается после получения левого или правого Наручника Искателя Ветра с Гарра около "..YELLOW.."[4]"..WHITE.." или Барона Геддона около "..YELLOW.."[6]"..WHITE..". Затем поговорите с Верховным лордом Демитрианом, чтобы начать цепочку заданий. Сущность повелителя огня добывается с Рагнароса около "..YELLOW.."[10]"..WHITE..". После завершения этого задания призывается Принц Громораан и вы должны убить его. Это босс для 40 игроков."
Inst27Quest3_Prequest = "Сосуд Возрождения" -- 7785
Inst27Quest3_Folgequest = "Громовая ярость"
Inst27Quest3PreQuest = "true"
-- No Rewards for this quest

--Quest 4 Alliance
Inst27Quest4 = "4. Заключение договор"
Inst27Quest4_Level = "60"
Inst27Quest4_Attain = "60"
Inst27Quest4_Aim = "Подпишите договор с представителем братства Тория Локтосом Недобрым Торговцем, если вам нужен чертеж сульфуронского молота."
Inst27Quest4_Location = "Локтос Зловещий Торговец (Глубины Черной горы; "..YELLOW.."[15]"..WHITE..")"
Inst27Quest4_Note = "Вам нужен Сульфуронский слиток, чтобы получить контракт у Локтоса. Слитки падают с Големагга Испепелителя в Огненных Недрах около "..YELLOW.."[7]"..WHITE.."."
Inst27Quest4_Prequest = "Нет"
Inst27Quest4_Folgequest = "Нет"
--
Inst27Quest4name1 = "Чертеж: сульфуронский молот"

--Quest 5 Alliance
Inst27Quest5 = "5. Древний лист"
Inst27Quest5_Level = "60"
Inst27Quest5_Attain = "60"
Inst27Quest5_Aim = "Найдите хозяина древнего окаменелого древесного листа."
Inst27Quest5_Location = "Древний окаменелый древесный лист (содержится в Тайнике повелителя огня; "..YELLOW.."[9]"..WHITE..")"
Inst27Quest5_Note = "Отнесите Вартусу Древнему около (Оскверненный лес - Железнолесье; "..YELLOW.."49,24"..WHITE..")."
Inst27Quest5_Prequest = "Нет"
Inst27Quest5_Folgequest = "Перетянутый жилами лист древня ("..YELLOW.."Азурегос"..WHITE..")"
-- No Rewards for this quest

--Quest 6 Alliance
Inst27Quest6 = "6. Гадальные очки? Без проблем!"
Inst27Quest6_Level = "60"
Inst27Quest6_Attain = "60"
Inst27Quest6_Aim = "Найдите гадальные очки Нарайна и отнесите их Нарайну Причуденю в Танарис."
Inst27Quest6_Location = "Нарайн Причудень (Танарис; "..YELLOW.."65,18"..WHITE..")"
Inst27Quest6_Note = "Добываются с боссов в Огненных Недрах."
Inst27Quest6_Prequest = "Тушеный Лис, БЛД"
Inst27Quest6_Folgequest = "Хорошая новость и плохая новость, Должны быть выполнены цепочки заданий ("..YELLOW.."Тушеный Лис"..WHITE..") и ("..YELLOW.."Никогда не расспрашивай меня о моем бизнесе!"..WHITE..")"
Inst27Quest6PreQuest = "true"
--
Inst27Quest6name1 = "Хорошее зелье омоложения"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst27Quest1_HORDE = Inst27Quest1
Inst27Quest1_HORDE_Level = Inst27Quest1_Level
Inst27Quest1_HORDE_Attain = Inst27Quest1_Attain
Inst27Quest1_HORDE_Aim = Inst27Quest1_Aim
Inst27Quest1_HORDE_Location = Inst27Quest1_Location
Inst27Quest1_HORDE_Note = Inst27Quest1_Note
Inst27Quest1_HORDE_Prequest = Inst27Quest1_Prequest
Inst27Quest1_HORDE_Folgequest = Inst27Quest1_Folgequest
Inst27Quest1PreQuest_HORDE = Inst27Quest1PreQuest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst27Quest2_HORDE = Inst27Quest2
Inst27Quest2_HORDE_Level = Inst27Quest2_Level
Inst27Quest2_HORDE_Attain = Inst27Quest2_Attain
Inst27Quest2_HORDE_Aim = Inst27Quest2_Aim
Inst27Quest2_HORDE_Location = Inst27Quest2_Location
Inst27Quest2_HORDE_Note = Inst27Quest2_Note
Inst27Quest2_HORDE_Prequest = Inst27Quest2_Prequest
Inst27Quest2_HORDE_Folgequest = Inst27Quest2_Folgequest
Inst27Quest2FQuest_HORDE = Inst27Quest2FQuest
--
Inst27Quest2name1_HORDE = Inst27Quest2name1
Inst27Quest2name2_HORDE = Inst27Quest2name2

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst27Quest3_HORDE = Inst27Quest3
Inst27Quest3_HORDE_Level = Inst27Quest3_Level
Inst27Quest3_HORDE_Attain = Inst27Quest3_Attain
Inst27Quest3_HORDE_Aim = Inst27Quest3_Aim
Inst27Quest3_HORDE_Location = Inst27Quest3_Location
Inst27Quest3_HORDE_Note = Inst27Quest3_Note
Inst27Quest3_HORDE_Prequest = Inst27Quest3_Prequest
Inst27Quest3_HORDE_Folgequest = Inst27Quest3_Folgequest
Inst27Quest3PreQuest_HORDE = Inst27Quest3PreQuest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst27Quest4_HORDE = Inst27Quest4
Inst27Quest4_HORDE_Level = Inst27Quest4_Level
Inst27Quest4_HORDE_Attain = Inst27Quest4_Attain
Inst27Quest4_HORDE_Aim = Inst27Quest4_Aim
Inst27Quest4_HORDE_Location = Inst27Quest4_Location
Inst27Quest4_HORDE_Note = Inst27Quest4_Note
Inst27Quest4_HORDE_Prequest = Inst27Quest4_Prequest
Inst27Quest4_HORDE_Folgequest = Inst27Quest4_Folgequest
--
Inst27Quest4name1_HORDE = Inst27Quest4name1

--Quest 5 Horde  (same as Quest 5 Alliance)
Inst27Quest5_HORDE = Inst27Quest5
Inst27Quest5_HORDE_Level = Inst27Quest5_Level
Inst27Quest5_HORDE_Attain = Inst27Quest5_Attain
Inst27Quest5_HORDE_Aim = Inst27Quest5_Aim
Inst27Quest5_HORDE_Location = Inst27Quest5_Location
Inst27Quest5_HORDE_Note = Inst27Quest5_Note
Inst27Quest5_HORDE_Prequest = Inst27Quest5_Prequest
Inst27Quest5_HORDE_Folgequest = Inst27Quest5_Folgequest
-- No Rewards for this quest

--Quest 6 Horde  (same as Quest 6 Alliance)
Inst27Quest6_HORDE = Inst27Quest6
Inst27Quest6_HORDE_Level = Inst27Quest6_Level
Inst27Quest6_HORDE_Attain = Inst27Quest6_Attain
Inst27Quest6_HORDE_Aim = Inst27Quest6_Aim
Inst27Quest6_HORDE_Location = Inst27Quest6_Location
Inst27Quest6_HORDE_Note = Inst27Quest6_Note
Inst27Quest6_HORDE_Prequest = Inst27Quest6_Prequest
Inst27Quest6_HORDE_Folgequest = Inst27Quest6_Folgequest
Inst27Quest6PreQuest_HORDE = Inst27Quest6PreQuest
--
Inst27Quest6name1_HORDE = Inst27Quest6name1



--------------- INST28 - Onyxia's Lair ---------------

Inst28Caption = "Логово Ониксии"
Inst28QAA = "2 задания"
Inst28QAH = "2 задания"

--Quest 1 Alliance
Inst28Quest1 = "1. Ковка Кель'Серрара"
Inst28Quest1_Level = "60"
Inst28Quest1_Attain = "60"
Inst28Quest1_Aim = "Заставьте Ониксию дохнуть своим огненным дыханием на потускневший древний клинок. После этого схватите раскаленный древний клинок. Имейте в виду, что раскаленным он останется ненадолго, так что медлить не следует! Последнее, что нужно сделать – это убить драконицу и вонзить раскаленный древний клинок в ее труп. Сделайте это – и Кель'Серрар навеки станет вашим!"
Inst28Quest1_Location = "Сказитель Лидрос (Забытый город (Запад); "..YELLOW.."[1] Библиотека"..WHITE..")"
Inst28Quest1_Note = "Бросьте меч перед Ониксией, когда у нее останется от 10% до 15% здоровья. Она должна будет дышать и нагревать его. Когда Ониксия умрет, заберите меч, нажмите на ее труп и используйте меч. Тогда вы будете готовы, чтобы завершить задание."
Inst28Quest1_Prequest = "Справочник Форора ("..YELLOW.."Забытый город (Запад)"..WHITE..") -> Ковка Кель'Серрара" -- 7507 -> 7508
Inst28Quest1_Folgequest = "Нет"
Inst28Quest1PreQuest = "true"
--
Inst28Quest1name1 = "Кель'Серрар"
Inst28Quest1name2 = "Древний закаленный клинок"

--Quest 2 Alliance
Inst28Quest2 = "2. Славная победа Альянса"
Inst28Quest2_Level = "60"
Inst28Quest2_Attain = "60"
Inst28Quest2_Aim = "Take the Head of Onyxia to King Varian Wrynn in Stormwind."
Inst28Quest2_Location = "Head of Onyxia (drops from Onyxia; "..YELLOW.."[3]"..WHITE..")"
Inst28Quest2_Note = "King Varian Wrynn is at (Stormwind City - Stormwind Keep; "..YELLOW.."80.0, 38.5"..WHITE.."). Only one person in the raid can loot this item and the quest can be done once per character.\n\nRewards listed are for the followup. As of patch 3.2.2, Onyxia is a level 80 raid and the head for this quest no longer drops."
Inst28Quest2_Prequest = "None"
Inst28Quest2_Folgequest = "Celebrating Good Times"
--
Inst28Quest2name1 = "Кровный талисман Ониксии"
Inst28Quest2name2 = "Перстень драконоборца"
Inst28Quest2name3 = "Подвеска Клыка Ониксии"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst28Quest1_HORDE = Inst28Quest1
Inst28Quest1_HORDE_Attain = Inst28Quest1_Attain
Inst28Quest1_HORDE_Level = Inst28Quest1_Level
Inst28Quest1_HORDE_Aim = Inst28Quest1_Aim
Inst28Quest1_HORDE_Location = Inst28Quest1_Location
Inst28Quest1_HORDE_Note = Inst28Quest1_Note
Inst28Quest1_HORDE_Prequest = Inst28Quest1_Prequest
Inst28Quest1_HORDE_Folgequest = Inst28Quest1_Folgequest
Inst28Quest1PreQuest_HORDE = Inst28Quest1PreQuest
--
Inst28Quest1name1_HORDE = Inst28Quest1name1

--Quest 2 Horde
Inst28Quest2_HORDE = "2. Победа Орды"
Inst28Quest2_HORDE_Level = "60"
Inst28Quest2_HORDE_Attain = "60"
Inst28Quest2_HORDE_Aim = "Отнесите голову Ониксии Траллу в Оргриммар."
Inst28Quest2_HORDE_Location = "Голова Ониксии (добывается с Ониксии; "..YELLOW.."[3]"..WHITE..")"
Inst28Quest2_HORDE_Note = "Тралл (Оргриммар - Аллея Мудрости; "..YELLOW.."31,37"..WHITE.."). Только один человек в рейде может получить этот предмет и задание может быть сделано только один раз.\n\nНаграды перечислены для следующего задания."
Inst28Quest2_HORDE_Prequest = "Нет"
Inst28Quest2_HORDE_Folgequest = "На виду у всех"
--
Inst28Quest2name1_HORDE = "Кровный талисман Ониксии"
Inst28Quest2name2_HORDE = "Перстень драконоборца"
Inst28Quest2name3_HORDE = "Подвеска Клыка Ониксии"



--------------- INST29 - Zul'Gurub ---------------

Inst29Caption = "Зул'Гуруб"
Inst29QAA = "4 задания"
Inst29QAH = "4 задания"

--Quest 1 Alliance
Inst29Quest1 = "1. A Коллекция голов"
Inst29Quest1_Level = "60"
Inst29Quest1_Attain = "58"
Inst29Quest1_Aim = "Соберите ожерелье из голов пятерых жрецов и вернитесь с ним к Экзалу на остров Йоджамба."
Inst29Quest1_Location = "Экзал (Тернистая долина - Остров Йоджамба; "..YELLOW.."15,15"..WHITE..")"
Inst29Quest1_Note = "Убедитесь, что вы осмотрели всех жрецов."
Inst29Quest1_Prequest = "Нет"
Inst29Quest1_Folgequest = "Нет"
--
Inst29Quest1name1 = "Пояс Усохших Голов"
Inst29Quest1name2 = "Пояс Высохших Голов"
Inst29Quest1name3 = "Пояс Сохраненных Голов"
Inst29Quest1name4 = "Пояс Крошечных Голов"

--Quest 2 Alliance
Inst29Quest2 = "2. Сердце Хаккара"
Inst29Quest2_Level = "60"
Inst29Quest2_Attain = "58"
Inst29Quest2_Aim = "Принесите сердце Хаккара Молтору на остров Йоджамба."
Inst29Quest2_Location = "Сердце Хаккара (добывается с Хаккара; "..YELLOW.."[11]"..WHITE..")"
Inst29Quest2_Note = "Молтор (Тернистая долина - Остров Йоджамба; "..YELLOW.."15,15"..WHITE..")"
Inst29Quest2_Prequest = "Нет"
Inst29Quest2_Folgequest = "Нет"
--
Inst29Quest2name1 = "Геройский знак зандаларов"
Inst29Quest2name2 = "Геройский оберег зандаларов"
Inst29Quest2name3 = "Геройский медальон зандаларов"

--Quest 3 Alliance
Inst29Quest3 = "3. Измерительная лента Ната"
Inst29Quest3_Level = "60"
Inst29Quest3_Attain = "59"
Inst29Quest3_Aim = "Верните измерительную ленту Нату Пэглу. Найти Пэгла можно в Пылевых топях."
Inst29Quest3_Location = "Побитый ящик для рыболовной снасти (Зул'Гуруб -  около воды на северо-востоке от острова Хаккара)"
Inst29Quest3_Note = "Нат Пэгл в Пылевых топях ("..YELLOW.."59,60"..WHITE.."). Выполнение задания позволяет купить Наживки на грязнотинника у Ната Пэгла для вызова Газ'ранки в Зул'Гурубе."
Inst29Quest3_Prequest = "Нет"
Inst29Quest3_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 4 Alliance
Inst29Quest4 = "4. Идеальный яд"
Inst29Quest4_Level = "60"
Inst29Quest4_Attain = "60"
Inst29Quest4_Aim = "Дирк Громодрев из Крепости Кенария попросил принести ему ядовитую железу Веноксиса и ядовитую железу Куриннакса."
Inst29Quest4_Location = "Дирк Громодрев (Силитус - Крепость Кенария; "..YELLOW.."52,39"..WHITE..")"
Inst29Quest4_Note = "Ядовитая железа Веноксиса добывается с Верховного жреца Веноксиса в "..YELLOW.."Зул'Гурубе"..WHITE..". Ядовитая железа Куриннакса добывается в "..YELLOW.."Руинах Ан'Киража"..WHITE.." at "..YELLOW.."[1]"..WHITE.."."
Inst29Quest4_Prequest = "Нет"
Inst29Quest4_Folgequest = "Нет"
--
Inst29Quest4name1 = "Тесак Черного Ворона"
Inst29Quest4name2 = "Нож Карманного ножа"
Inst29Quest4name3 = "Укол Громового леса"
Inst29Quest4name4 = "Рокулюс первый"
Inst29Quest4name5 = "Многозарядный перезаряжаемый арбалет Фахрада"
Inst29Quest4name6 = "Культивационный молот Симоны"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst29Quest1_HORDE = Inst29Quest1
Inst29Quest1_HORDE_Level = Inst29Quest1_Level
Inst29Quest1_HORDE_Attain = Inst29Quest1_Attain
Inst29Quest1_HORDE_Aim = Inst29Quest1_Aim
Inst29Quest1_HORDE_Location = Inst29Quest1_Location
Inst29Quest1_HORDE_Note = Inst29Quest1_Note
Inst29Quest1_HORDE_Prequest = Inst29Quest1_Prequest
Inst29Quest1_HORDE_Folgequest = Inst29Quest1_Folgequest
--
Inst29Quest1name1_HORDE = Inst29Quest1name1
Inst29Quest1name2_HORDE = Inst29Quest1name2
Inst29Quest1name3_HORDE = Inst29Quest1name3
Inst29Quest1name4_HORDE = Inst29Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst29Quest2_HORDE = Inst29Quest2
Inst29Quest2_HORDE_Level = Inst29Quest2_Level
Inst29Quest2_HORDE_Attain = Inst29Quest2_Attain
Inst29Quest2_HORDE_Aim = Inst29Quest2_Aim
Inst29Quest2_HORDE_Location = Inst29Quest2_Location
Inst29Quest2_HORDE_Note = Inst29Quest2_Note
Inst29Quest2_HORDE_Prequest = Inst29Quest2_Prequest
Inst29Quest2_HORDE_Folgequest = Inst29Quest2_Folgequest
--
Inst29Quest2name1_HORDE = Inst29Quest2name1
Inst29Quest2name2_HORDE = Inst29Quest2name2
Inst29Quest2name3_HORDE = Inst29Quest2name3

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst29Quest3_HORDE = Inst29Quest3
Inst29Quest3_HORDE_Level = Inst29Quest3_Level
Inst29Quest3_HORDE_Attain = Inst29Quest3_Attain
Inst29Quest3_HORDE_Aim = Inst29Quest3_Aim
Inst29Quest3_HORDE_Location = Inst29Quest3_Location
Inst29Quest3_HORDE_Note = Inst29Quest3_Note
Inst29Quest3_HORDE_Prequest = Inst29Quest3_Prequest
Inst29Quest3_HORDE_Folgequest = Inst29Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst29Quest4_HORDE = Inst29Quest4
Inst29Quest4_HORDE_Level = Inst29Quest4_Level
Inst29Quest4_HORDE_Attain = Inst29Quest4_Attain
Inst29Quest4_HORDE_Aim = Inst29Quest4_Aim
Inst29Quest4_HORDE_Location = Inst29Quest4_Location
Inst29Quest4_HORDE_Note = Inst29Quest4_Note
Inst29Quest4_HORDE_Prequest = Inst29Quest4_Prequest
Inst29Quest4_HORDE_Folgequest = Inst29Quest4_Folgequest
--
Inst29Quest4name1_HORDE = Inst29Quest4name1
Inst29Quest4name2_HORDE = Inst29Quest4name2
Inst29Quest4name3_HORDE = Inst29Quest4name3
Inst29Quest4name4_HORDE = Inst29Quest4name4
Inst29Quest4name5_HORDE = Inst29Quest4name5
Inst29Quest4name6_HORDE = Inst29Quest4name6



--------------- INST30 - The Ruins of Ahn'Qiraj (AQ20) ---------------

Inst30Caption = "Руины Ан'Киража"
Inst30QAA = "2 задания"
Inst30QAH = "2 задания"

--Quest 1 Alliance
Inst30Quest1 = "1. Повергнутый Оссириан"
Inst30Quest1_Level = "60"
Inst30Quest1_Attain = "60"
Inst30Quest1_Aim = "Принесите голову Оссириана Неуязвимого командиру Мар'алиту в Крепость Кенария."
Inst30Quest1_Location = "Голова Оссириана Неуязвимого (добывается с Оссириана Неуязвимого; "..YELLOW.."[6]"..WHITE..")"
Inst30Quest1_Note = "Командир Мар'алит (Силитус - Крепость Кенария; "..YELLOW.."49,34"..WHITE..")"
Inst30Quest1_Prequest = "Нет"
Inst30Quest1_Folgequest = "Нет"
--
Inst30Quest1name1 = "Оберег Зыбучих Песков"
Inst30Quest1name2 = "Амулеи Зыбучих песков"
Inst30Quest1name3 = "Колье Зыбучих песков"
Inst30Quest1name4 = "Подвеска Зыбучих песков"

--Quest 2 Alliance
Inst30Quest2 = "2. Идеальный яд"
Inst30Quest2_Level = "60"
Inst30Quest2_Attain = "60"
Inst30Quest2_Aim = "Дирк Громодрев из Крепости Кенария попросил принести ему ядовитую железу Веноксиса и ядовитую железу Куриннакса."
Inst30Quest2_Location = "Дирк Громодрев (Силитус - Крепость Кенария; "..YELLOW.."52,39"..WHITE..")"
Inst30Quest2_Note = "Ядовитая железа Веноксиса добывается с Верховного жреца Веноксиса в "..YELLOW.."Зул'Гурубе"..WHITE..". Ядовитая железа Куриннакса добывается в "..YELLOW.."Руинах Ан'Киража"..WHITE.." at "..YELLOW.."[1]"..WHITE.."."
Inst30Quest2_Prequest = "Нет"
Inst30Quest2_Folgequest = "Нет"
--
Inst30Quest2name1 = "Тесак Черного Ворона"
Inst30Quest2name2 = "Нож Карманного ножа"
Inst30Quest2name3 = "Укол Громового леса"
Inst30Quest2name4 = "Рокулюс первый"
Inst30Quest2name5 = "Многозарядный перезаряжаемый арбалет Фахрада"
Inst30Quest2name6 = "Культивационный молот Симоны"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst30Quest1_HORDE = Inst30Quest1
Inst30Quest1_HORDE_Level = Inst30Quest1_Level
Inst30Quest1_HORDE_Attain = Inst30Quest1_Attain
Inst30Quest1_HORDE_Aim = Inst30Quest1_Aim
Inst30Quest1_HORDE_Location = Inst30Quest1_Location
Inst30Quest1_HORDE_Note = Inst30Quest1_Note
Inst30Quest1_HORDE_Prequest = Inst30Quest1_Prequest
Inst30Quest1_HORDE_Folgequest = Inst30Quest1_Folgequest
--
Inst30Quest1name1_HORDE = Inst30Quest1name1
Inst30Quest1name2_HORDE = Inst30Quest1name2
Inst30Quest1name3_HORDE = Inst30Quest1name3
Inst30Quest1name4_HORDE = Inst30Quest1name4

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst30Quest2_HORDE = Inst30Quest2
Inst30Quest2_HORDE_Level = Inst30Quest2_Level
Inst30Quest2_HORDE_Attain = Inst30Quest2_Attain
Inst30Quest2_HORDE_Aim = Inst30Quest2_Aim
Inst30Quest2_HORDE_Location = Inst30Quest2_Location
Inst30Quest2_HORDE_Note = Inst30Quest2_Note
Inst30Quest2_HORDE_Prequest = Inst30Quest2_Prequest
Inst30Quest2_HORDE_Folgequest = Inst30Quest2_Folgequest
--
Inst30Quest2name1_HORDE = Inst30Quest2name1
Inst30Quest2name2_HORDE = Inst30Quest2name2
Inst30Quest2name3_HORDE = Inst30Quest2name3
Inst30Quest2name4_HORDE = Inst30Quest2name4
Inst30Quest2name5_HORDE = Inst30Quest2name5
Inst30Quest2name6_HORDE = Inst30Quest2name6



--------------- INST31 - The Temple of Ahn'Qiraj (AQ40) ---------------

Inst31Caption = "Храм Ан'Киража"
Inst31QAA = "4 задания"
Inst31QAH = "4 задания"

--Quest 1 Alliance
Inst31Quest1 = "1. Наследие К'Туна"
Inst31Quest1_Level = "60"
Inst31Quest1_Attain = "60"
Inst31Quest1_Aim = "Принесите Глаз К'Туна Келестрасу в Храм Ан'Кираж."
Inst31Quest1_Location = "Око К'Туна (добывается с К'Туна; "..YELLOW.."[9]"..WHITE..")"
Inst31Quest1_Note = "Калестраз (Храм Ан'Кираж; "..YELLOW.."2'"..WHITE..")\nНаграды перечислены для следующего задания."
Inst31Quest1_Prequest = "Нет"
Inst31Quest1_Folgequest = "Спаситель Калимдора"
-- No Rewards for this quest

--Quest 2 Alliance
Inst31Quest2 = "2. Спаситель Калимдора"
Inst31Quest2_Level = "60"
Inst31Quest2_Attain = "60"
Inst31Quest2_Aim = "Пришла пора вернуться в Пещеры Времени, ("..YELLOW.."Анахронос"..WHITE..") ожидает тебя. Отдай ему глаз К'Туна. "
Inst31Quest2_Location = "Око К'Туна (добывается с  К'Туна; "..YELLOW.."[9]"..WHITE..")"
Inst31Quest2_Note = "Анахронос (Танарис - Пещеры Времени; "..YELLOW.."65,49"..WHITE..")"
Inst31Quest2_Prequest = "Наследие К'Туна"
Inst31Quest2_Folgequest = "Нет"
Inst31Quest2FQuest = "true"
--
Inst31Quest2name1 = "Амулет Падшего бога"
Inst31Quest2name2 = "Плащ Павшего Бога"
Inst31Quest2name3 = "RКольцо Падшего бога"

--Quest 3 Alliance
Inst31Quest3 = "3. Секреты Киражи"
Inst31Quest3_Level = "60"
Inst31Quest3_Attain = "60"
Inst31Quest3_Aim = "Принесите древний киражский артефакт драконам, которые укрылись в храме, недалеко от входа."
Inst31Quest3_Location = "Древний киражский артефакт (случайная добыча в Храме Ан'Кираж)"
Inst31Quest3_Note = "Отнесите его Андоргосу (Храм Ан'Кираж; "..YELLOW.."1'"..WHITE..")."
Inst31Quest3_Prequest = "Нет"
Inst31Quest3_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 4 Alliance
Inst31Quest4 = "4. Поборники правого дела из числа смертных"
Inst31Quest4_Level = "60"
Inst31Quest4_Attain = "60"
Inst31Quest4_Aim = "Отнесите Знаки различия киражского владыки ("..YELLOW.."Кандростразу"..WHITE..") в Храме Ан'Киража."
Inst31Quest4_Location = "Кандростразу (Храме Ан'Киража; "..YELLOW.."[1']"..WHITE..")"
Inst31Quest4_Note = "Это повторяемый квест, за который повышается репутацию Кенарийского Круга. ("..YELLOW.."Знаки различия киражского владыки"..WHITE..") добывается со всех боссов в инстансе. ("..YELLOW.."Кандростраз"..WHITE..") находится в комнатах за первым боссом."
Inst31Quest4_Prequest = "Нет"
Inst31Quest4_Folgequest = "Нет"
-- No Rewards for this quest


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst31Quest1_HORDE = Inst31Quest1
Inst31Quest1_HORDE_Level = Inst31Quest1_Level
Inst31Quest1_HORDE_Attain = Inst31Quest1_Attain
Inst31Quest1_HORDE_Aim = Inst31Quest1_Aim
Inst31Quest1_HORDE_Location = Inst31Quest1_Location
Inst31Quest1_HORDE_Note = Inst31Quest1_Note
Inst31Quest1_HORDE_Prequest = Inst31Quest1_Prequest
Inst31Quest1_HORDE_Folgequest = Inst31Quest1_Folgequest
-- No Rewards for this quest

--Quest 2 Horde  (same as Quest 2 Alliance)
Inst31Quest2_HORDE = Inst31Quest2
Inst31Quest2_HORDE_Level = Inst31Quest2_Level
Inst31Quest2_HORDE_Attain = Inst31Quest2_Attain
Inst31Quest2_HORDE_Aim = Inst31Quest2_Aim
Inst31Quest2_HORDE_Location = Inst31Quest2_Location
Inst31Quest2_HORDE_Note = Inst31Quest2_Note
Inst31Quest2_HORDE_Prequest = Inst31Quest2_Prequest
Inst31Quest2_HORDE_Folgequest = Inst31Quest2_Folgequest
Inst31Quest2FQuest_HORDE = Inst31Quest2FQuest
--
Inst31Quest2name1_HORDE = Inst31Quest2name1
Inst31Quest2name2_HORDE = Inst31Quest2name2
Inst31Quest2name3_HORDE = Inst31Quest2name3

--Quest 3 Horde  (same as Quest 3 Alliance)
Inst31Quest3_HORDE = Inst31Quest3
Inst31Quest3_HORDE_Level = Inst31Quest3_Level
Inst31Quest3_HORDE_Attain = Inst31Quest3_Attain
Inst31Quest3_HORDE_Aim = Inst31Quest3_Aim
Inst31Quest3_HORDE_Location = Inst31Quest3_Location
Inst31Quest3_HORDE_Note = Inst31Quest3_Note
Inst31Quest3_HORDE_Prequest = Inst31Quest3_Prequest
Inst31Quest3_HORDE_Folgequest = Inst31Quest3_Folgequest
-- No Rewards for this quest

--Quest 4 Horde  (same as Quest 4 Alliance)
Inst31Quest4_HORDE = Inst31Quest4
Inst31Quest4_HORDE_Level = Inst31Quest4_Level
Inst31Quest4_HORDE_Attain = Inst31Quest4_Attain
Inst31Quest4_HORDE_Aim = Inst31Quest4_Aim
Inst31Quest4_HORDE_Location = Inst31Quest4_Location
Inst31Quest4_HORDE_Note = Inst31Quest4_Note
Inst31Quest4_HORDE_Prequest = Inst31Quest4_Prequest
Inst31Quest4_HORDE_Folgequest = Inst31Quest4_Folgequest
-- No Rewards for this quest



--------------- INST32 - Naxxramas ---------------

Inst32Caption = "Наксарамас"
Inst32QAA = "Нет заданий"
Inst32QAH = "Нет заданий"




---------------------------------------------------
---------------- BATTLEGROUNDS --------------------
---------------------------------------------------



--------------- INST33 - Alterac Valley ---------------

Inst33Caption = "Альтеракская долина"
Inst33QAA = "17 заданий"
Inst33QAH = "17 заданий"

--Quest 1 Alliance
Inst33Quest1 = "1. Королевское право" -- 7261
Inst33Quest1_Level = "60"
Inst33Quest1_Attain = "51"
Inst33Quest1_Aim = "Отправляйтесь в Альтеракскую долину, к предгорьям Хилсбрада. Найдите лейтенанта Мурпа рядом со входом в туннель и поговорите с ним."
Inst33Quest1_Location = "Лейтенант Ротимер (Стальгорн - Общий зал; "..YELLOW.."30,62"..WHITE..")"
Inst33Quest1_Note = "Лейтенант Мурп (Альтеракские горы; "..YELLOW.."39,81"..WHITE..")."
Inst33Quest1_Prequest = "Нет"
Inst33Quest1_Folgequest = "Испытательные земли" -- 7162
-- No Rewards for this quest

--Quest 2 Alliance
Inst33Quest2 = "2. Испытательные земли" -- 7162
Inst33Quest2_Level = "60"
Inst33Quest2_Attain = "51"
Inst33Quest2_Aim = "Отправляйтесь в пещеру Ледяного Крыла, которая расположена в Альтеракской долине, на юго-западе от Дун Болдара, и добудьте знамя Грозовой Вершины. Отдайте знамя лейтенанту Мурпу в Альтеракских горах."
Inst33Quest2_Location = "Лейтенант Мурп (Альтеракские горы; "..YELLOW.."39,81"..WHITE..")"
Inst33Quest2_Note = "Знамя Грозовой Вершины находится в Пещере Ледяного Крыла около "..YELLOW.."[11]"..WHITE.." на северной карте Альтеракской долины. Говорите с лейтенантом каждый раз, когда вы получаете новый уровень репутации для обновления Знака отличия."
Inst33Quest2_Prequest = "Королевское право" -- 7261
Inst33Quest2_Folgequest = "Награда найдет героя -> Око Командования" -- 7168 -> 7172
--
Inst33Quest2name1 = "Знак различия клана Северного Волка, ранг 1"
Inst33Quest2name2 = "Очищая луковицу"

--Quest 3 Alliance
Inst33Quest3 = "3. Битва за Альтерак" -- 7141
Inst33Quest3_Level = "60"
Inst33Quest3_Attain = "51"
Inst33Quest3_Aim = "Отправляйтесь в Альтеракскую долину, сразитесь с генералом Орды Дрек'Таром и возвращайтесь к геологу Камнетерке в Альтеракские горы."
Inst33Quest3_Location = "Геолог Камнетерка (Альтеракские горы; "..YELLOW.."41,80"..WHITE..") и\n(Альтеракские горы - Север; "..YELLOW.."[B]"..WHITE..")"
Inst33Quest3_Note = "Дрек'Тар (Альтеракские горы - Юг; "..YELLOW.."[B]"..WHITE.."). На самом деле его убивать не нужно, чтобы завершить задание. Достаточно выиграть поле боя каким-либо образом.\nПосле завершения этого задания, поговорите с Дрек'Таром снова для получения вознаграждения."
Inst33Quest3_Prequest = "Нет"
Inst33Quest3_Folgequest = "Герой Грозовой Вершины" -- 8271
--
Inst33Quest3name1 = "Кровоискатель"
Inst33Quest3name2 = "Покрытое изморозью копье"
Inst33Quest3name3 = "Жезл Лютого холода"
Inst33Quest3name4 = "Холоднокованный молот"

--Quest 4 Alliance
Inst33Quest4 = "4. Интендант" -- 7121
Inst33Quest4_Level = "60"
Inst33Quest4_Attain = "51"
Inst33Quest4_Aim = "Поговорите с интендантом клана Грозовой Вершины."
Inst33Quest4_Location = "Горный пехотинец Гулкий Крик (Альтеракские горы - Север; "..YELLOW.."возле [3] перед мостом"..WHITE..")"
Inst33Quest4_Note = "Интендант клана Грозовой Вершины (Альтеракские горы - Север; "..YELLOW.."[7]"..WHITE..") и предоставляет больше заданий."
Inst33Quest4_Prequest = "Нет"
Inst33Quest4_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 5 Alliance
Inst33Quest5 = "5. Припасы Ледяного Зуба" -- 6982
Inst33Quest5_Level = "60"
Inst33Quest5_Attain = "51"
Inst33Quest5_Aim = "Принесите 10 ящиков с припасами Ледяного Зуба интенданту Альянса в Дун Болдар."
Inst33Quest5_Location = "Интендант клана Грозовой Вершины (Альтеракские горы - Север; "..YELLOW.."[7]"..WHITE..")"
Inst33Quest5_Note = "Припасы могут быть найдены в Руднике Ледяного Зуба около (Альтеракские горы - Юг; "..YELLOW.."[6]"..WHITE..")."
Inst33Quest5_Prequest = "Нет"
Inst33Quest5_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 6 Alliance
Inst33Quest6 = "6. Припасы Железного рудника" -- 5892
Inst33Quest6_Level = "60"
Inst33Quest6_Attain = "51"
Inst33Quest6_Aim = "Принесите 10 припасов Железного рудника интенданту Альянса в Дун Болдар."
Inst33Quest6_Location = "Интендант клана Грозовой Вершины (Альтеракские горы - Север; "..YELLOW.."[7]"..WHITE..")"
Inst33Quest6_Note = "Припасы могут быть найдены в Железном руднике около (Альтеракские горы - Север; "..YELLOW.."[1]"..WHITE..")."
Inst33Quest6_Prequest = "Нет"
Inst33Quest6_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 7 Alliance
Inst33Quest7 = "7. Обломки брони" -- 7223
Inst33Quest7_Level = "60"
Inst33Quest7_Attain = "51"
Inst33Quest7_Aim = "Принесите 20 обломков брони Мурготу Подземной Кузне в Дун Болдар."
Inst33Quest7_Location = "Мургот Подземная Кузня (Альтеракские горы - Север; "..YELLOW.."[4]"..WHITE..")"
Inst33Quest7_Note = "Для получения брони осматривайте трупы вражеских игроков. Последующее задание аналогичное, но повторяемое."
Inst33Quest7_Prequest = "Нет"
Inst33Quest7_Folgequest = "Больше обломков брони" -- 6781
-- No Rewards for this quest

--Quest 8 Alliance
Inst33Quest8 = "8. Захват рудника" -- 7122
Inst33Quest8_Level = "60"
Inst33Quest8_Attain = "51"
Inst33Quest8_Aim = "Захватите рудник, который не принадлежит Грозовой Вершине, и возвращайтесь к сержанту Даргену Грозовой Вершине в Альтеракские горы."
Inst33Quest8_Location = "Сержант Дарген Грозовая Вершина (Альтеракские горы; "..YELLOW.."37,77"..WHITE..")"
Inst33Quest8_Note = "Чтобы выполнить задание, вы должны убить либо Морлоха в Железном руднике около (Альтеракские горы - Север; "..YELLOW.."[1]"..WHITE.."), либо Надсмотрщика Хныкса в Руднике Ледяного Зуба около (Альтеракские горы - Юг; "..YELLOW.."[6]"..WHITE.."), пока Орда контролирует."
Inst33Quest8_Prequest = "Нет"
Inst33Quest8_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 9 Alliance
Inst33Quest9 = "9. Башни и бункеры" -- 7102
Inst33Quest9_Level = "60"
Inst33Quest9_Attain = "51"
Inst33Quest9_Aim = "Уничтожьте вымпел на вражеской башне или бункере и возвращайтесь к сержанту Даргену Грозовой Вершине в Альтеракские горы."
Inst33Quest9_Location = "Сержант Дарген Грозовая Вершина (Альтеракские горы; "..YELLOW.."37,77"..WHITE..")"
Inst33Quest9_Note = "Башню или бункер не нужно уничтожать, чтобы завершить задание, достаточно напасть."
Inst33Quest9_Prequest = "Нет"
Inst33Quest9_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 10 Alliance
Inst33Quest10 = "10. Кладбища Альтеракской долины" -- 7081
Inst33Quest10_Level = "60"
Inst33Quest10_Attain = "51"
Inst33Quest10_Aim = "Захватите кладбище, затем возвращайтесь к сержанту Даргену Грозовой Вершине в Альтеракские горы."
Inst33Quest10_Location = "Сержант Дарген Грозовая Вершина (Альтеракские горы; "..YELLOW.."37,77"..WHITE..")"
Inst33Quest10_Note = "Вам не нужно ничего делать, но быть рядом с кладбищем, когда Альянс атакует его. Для этого не нужно захватывать, достаточно напасть."
Inst33Quest10_Prequest = "Нет"
Inst33Quest10_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 11 Alliance
Inst33Quest11 = "11. Пустые стойла" -- 7027
Inst33Quest11_Level = "60"
Inst33Quest11_Attain = "51"
Inst33Quest11_Aim = "Найдите в Альтеракской долине альтеракского барана. Чтобы приручить барана, используйте учебный ошейник Грозовой Вершины. Для этого надо подойти в барану поближе. Пойманный баран проследует за вами к смотрителю стойл. Поговорите со смотрителем стойл, чтобы получить вознаграждение за пойманных баранов."
Inst33Quest11_Location = "Смотритель стойл из клана Грозовой Вершины (Альтеракские горы - Север; "..YELLOW.."[6]"..WHITE..")"
Inst33Quest11_Note = "Вы можете найти баранов вне базы. Задание повторяемое до 25 раз за текущую битву. После того, как 25 баранов было приручено кавалеристы клана грозовой вершины прибудут, чтобы помочь в бою."
Inst33Quest11_Prequest = "Нет"
Inst33Quest11_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 12 Alliance
Inst33Quest12 = "12. Упряжь ездовых баранов" -- 7026
Inst33Quest12_Level = "60"
Inst33Quest12_Attain = "51"
Inst33Quest12_Aim = "Убей волка и принеси его мне его шкуру."
Inst33Quest12_Location = "Командир наездников на баранах клана Грозовой Вершины (Альтеракские горы - Север; "..YELLOW.."[6]"..WHITE..")"
Inst33Quest12_Note = "Северных волков можно найти в южной части Альтеракской долины."
Inst33Quest12_Prequest = "Нет"
Inst33Quest12_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 13 Alliance
Inst33Quest13 = "13. Гроздь кристаллов" -- 7386
Inst33Quest13_Level = "60"
Inst33Quest13_Attain = "51"
Inst33Quest13_Aim = "Есть времена, когда битва может идти день, неделю... В течении этого времени, можно собрать много кристаллов Бури.\nПринеси мне немного кристаллов Бури."
Inst33Quest13_Location = "Верховный друид Дикая Лань (Альтеракские горы - Север; "..YELLOW.."[2]"..WHITE..")"
Inst33Quest13_Note = "После сдачи около 200 кристаллов, друид Дикая Лань начнет идти к (Альтеракские горы - Север; "..YELLOW.."[19]"..WHITE.."). Оказавшись там, она начнет ритуал призыва, для которого потребуется 10 игроков. В случае успеха, Ивус Лесной Властелин будет вызван, чтобы помочь в битве."
Inst33Quest13_Prequest = "Нет"
Inst33Quest13_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 14 Alliance
Inst33Quest14 = "14. Ивус Лесной Властелин" -- 6881
Inst33Quest14_Level = "60"
Inst33Quest14_Attain = "51"
Inst33Quest14_Aim = "Солдаты Северного Волка носят талисманы стихий, которые называются кристаллами бури. Мы можем использовать их, чтобы связаться с Ивусом. Ступай и добудь эти кристаллы!"
Inst33Quest14_Location = "Верховный друид Дикая Лань (Альтеракские горы - Север; "..YELLOW.."[2]"..WHITE..")"
Inst33Quest14_Note = "После сдачи около 200 кристаллов, друид Дикая Лань начнет идти к (Альтеракские горы - Север; "..YELLOW.."[19]"..WHITE.."). Оказавшись там, она начнет ритуал призыва, для которого потребуется 10 игроков. В случае успеха, Ивус Лесной Властелин будет вызван, чтобы помочь в битве."
Inst33Quest14_Prequest = "Нет"
Inst33Quest14_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 15 Alliance
Inst33Quest15 = "15. Небо зовет – флот Макарча" -- 6942
Inst33Quest15_Level = "60"
Inst33Quest15_Attain = "51"
Inst33Quest15_Aim = "Мы готовы нанести удар по линии фронта, но мы не сможем нанести удар, пока их ряды не поредеют. Принеси мне жетон солдата Северного Волка.\nКак только их ряды поредеют, мы вызовем поддержку с воздуха!"
Inst33Quest15_Location = "Командир звена Макарча (Альтеракские горы - Север; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest15_Note = "Убивайте NPC Орды, чтобы получить Жетон солдата Северного Волка."
Inst33Quest15_Prequest = "Нет"
Inst33Quest15_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 16 Alliance
Inst33Quest16 = "16. Небо зовет – флот Сквороца" -- 6941
Inst33Quest16_Level = "60"
Inst33Quest16_Attain = "51"
Inst33Quest16_Aim = "Элитное подразделение Северного Волка, которые охраняют линии, должны быть уничтожены! Принеси мне жетон лейтенанта Северного Волка. Когда я узнаю что было повержено достаточно негодников, я нанесу воздушный удар."
Inst33Quest16_Location = "Командир звена Сквороц (Альтеракские горы - Север; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest16_Note = "Убивайте NPC Орды, чтобы получить Жетон лейтенанта Северного Волка."
Inst33Quest16_Prequest = "Нет"
Inst33Quest16_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 17 Alliance
Inst33Quest17 = "17. Небо зовет – флот Ромеона" -- 6943
Inst33Quest17_Level = "60"
Inst33Quest17_Attain = "51"
Inst33Quest17_Aim = "Возвращайся на поле битвы и лиши клан Северного Волка командования. Сокруши всех стражей и командиров! Все они носят медали. Собери с трупов столько их медалей, сколько сможешь унести, и возвращайся ко мне."
Inst33Quest17_Location = "Командир звена Ромеон (Альтеракские горы - Север; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest17_Note = "Убивайте NPC Орды, чтобы получить Жетон командира Северного Волка. После сдачи 50 раз, Командир звена Ромеон либо отправит грифона, чтобы напасть на базу Орды, либо даст вам маяк, чтобы поставить в кладбище Снегопада. Если маяк защищен достаточно долго грифон придет, чтобы защищать его."
Inst33Quest17_Prequest = "Нет"
Inst33Quest17_Folgequest = "Нет"
-- No Rewards for this quest


--Quest 1 Horde
Inst33Quest1_HORDE = "1. Защита клана Северного Волка" -- 7241
Inst33Quest1_HORDE_Level = "60"
Inst33Quest1_HORDE_Attain = "51"
Inst33Quest1_HORDE_Aim = "Отправляйтесь в Альтеракскую долину, расположенную в Альтеракских горах. Найдите воеводу Лаггронда у входа в тоннель и поговорите с ним, чтобы начать свою военную карьеру в клане Северного Волка. Альтеракская долина находится к северу от деревни Мельница Таррен у подножия Альтеракских гор."
Inst33Quest1_HORDE_Location = "Посол клана Северного Волка Рокстром (Оргриммар - Аллея Силы; "..YELLOW.."50,71"..WHITE..")"
Inst33Quest1_HORDE_Note = "Воевода Лаггронд (Альтеракские горы; "..YELLOW.."62,59"..WHITE..")."
Inst33Quest1_HORDE_Prequest = "Нет"
Inst33Quest1_HORDE_Folgequest = "Испытательные земли" -- 7161
-- No Rewards for this quest

--Quest 2 Horde
Inst33Quest2_HORDE = "2. Испытательные земли" -- 7161
Inst33Quest2_HORDE_Level = "60"
Inst33Quest2_HORDE_Attain = "51"
Inst33Quest2_HORDE_Aim = "Отправляйтесь в пещеру Дикой Лапы, расположенную на юго-востоке от основной базы в Альтеракской долине, и добудьте знамя Северного Волка. Отнесите знамя Северного Волка воеводе Лаггронду."
Inst33Quest2_HORDE_Location = "Воевода Лаггронд (Альтеракские горы; "..YELLOW.."62,59"..WHITE..")"
Inst33Quest2_HORDE_Note = "Знамя Северного Волка находится в пещере Дикой Лапы около (Альтеракские горы - Юг; "..YELLOW.."[9]"..WHITE.."). Говорите с лейтенантом каждый раз, когда вы получаете новый уровень репутации для обновления Знака отличия."
Inst33Quest2_HORDE_Prequest = "Защита клана Северного Волка" -- 7241
Inst33Quest2_HORDE_Folgequest = "Награда найдет героя -> Око Командования" -- 7168 -> 7172
--
Inst33Quest2name1_HORDE = "Знак различия клана Северного Волка, ранг 1"
Inst33Quest2name2_HORDE = "Очищая луковицу"

--Quest 3 Horde
Inst33Quest3_HORDE = "3. Битва за Альтерак" -- 7142
Inst33Quest3_HORDE_Level = "60"
Inst33Quest3_HORDE_Attain = "51"
Inst33Quest3_HORDE_Aim = "Отправляйтесь в Альтеракскую долину и убейте генерала дворфов, Вандара Грозовую Вершину. После этого возвращайтесь к Вогге Смертобою в Альтеракские горы."
Inst33Quest3_HORDE_Location = "Вогга Смертобой (Альтеракские горы; "..YELLOW.."64,60"..WHITE..")"
Inst33Quest3_HORDE_Note = "Вандар Грозовая Вершина (Альтеракские горы - Север; "..YELLOW.."[B]"..WHITE.."). He does not actually need to be killed to complete the quest. The battleground just has to be won by your side in any manner.\nAfter turning this quest in, talk to the NPC again for the reward."
Inst33Quest3_HORDE_Prequest = "Нет"
Inst33Quest3_HORDE_Folgequest = "Герой Северного Волка" -- 8272
-- (same as Quest 3 Alliance)
Inst33Quest3name1_HORDE = Inst33Quest3name1
Inst33Quest3name2_HORDE = Inst33Quest3name1
Inst33Quest3name3_HORDE = Inst33Quest3name1
Inst33Quest3name4_HORDE = Inst33Quest3name1

--Quest 4 Horde
Inst33Quest4_HORDE = "4. Разговор с интендантом" -- 7123
Inst33Quest4_HORDE_Level = "60"
Inst33Quest4_HORDE_Attain = "51"
Inst33Quest4_HORDE_Aim = "Поговорите с интендантом клана Северного Волка."
Inst33Quest4_HORDE_Location = "Джотек (Альтеракские горы - Юг; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest4_HORDE_Note = "Интендант клана Северного Волка "..YELLOW.."[10]"..WHITE.." и предоставляет больше заданий."
Inst33Quest4_HORDE_Prequest = "Нет"
Inst33Quest4_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 5 Horde
Inst33Quest5_HORDE = "5. Припасы Ледяного Зуба" -- 5893
Inst33Quest5_HORDE_Level = "60"
Inst33Quest5_HORDE_Attain = "51"
Inst33Quest5_HORDE_Aim = "Доставьте 10 припасов Ледяного Зуба интенданту Орды в крепость Северного Волка."
Inst33Quest5_HORDE_Location = "Интендант клана Северного Волка (Альтеракские горы - Юг; "..YELLOW.."[10]"..WHITE..")"
Inst33Quest5_HORDE_Note = "Припасы могут быть найдены в Руднике Ледяного Зуба около (Альтеракские горы - Юг; "..YELLOW.."[6]"..WHITE..")."
Inst33Quest5_HORDE_Prequest = "Нет"
Inst33Quest5_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 6 Horde
Inst33Quest6_HORDE = "6. Припасы Железного рудника" -- 6985
Inst33Quest6_HORDE_Level = "60"
Inst33Quest6_HORDE_Attain = "51"
Inst33Quest6_HORDE_Aim = "Доставьте 10 ящиков припасов Железного рудника интенданту Орды в крепость Северного Волка."
Inst33Quest6_HORDE_Location = "Интендант клана Северного Волка (Альтеракские горы - Юг; "..YELLOW.."[10]"..WHITE..")"
Inst33Quest6_HORDE_Note = "Припасы могут быть найдены в Железном руднике около (Альтеракские горы - Север; "..YELLOW.."[1]"..WHITE..")."
Inst33Quest6_HORDE_Prequest = "Нет"
Inst33Quest6_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 7 Horde
Inst33Quest7_HORDE = "7. Вражеский трофей" -- 7224
Inst33Quest7_HORDE_Level = "60"
Inst33Quest7_HORDE_Attain = "51"
Inst33Quest7_HORDE_Aim = "Принесите 20 обломков брони кузнецу Регзару в деревню Северного Волка."
Inst33Quest7_HORDE_Location = "Кузнец Регзар (Альтеракские горы - Юг; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest7_HORDE_Note = "Для получения брони осматривайте трупы вражеских игроков. Последующее задание аналогичное, но повторяемое."
Inst33Quest7_HORDE_Prequest = "Нет"
Inst33Quest7_HORDE_Folgequest = "Больше добычи!" -- 6741
-- No Rewards for this quest

--Quest 8 Horde
Inst33Quest8_HORDE = "8. Захват рудника" -- 7124
Inst33Quest8_HORDE_Level = "60"
Inst33Quest8_HORDE_Attain = "51"
Inst33Quest8_HORDE_Aim = "Захватите рудник и возвращайтесь к капралу Тике Кровавому Рыку в Альтеракские горы."
Inst33Quest8_HORDE_Location = "Капрал Тика Кровавый Рык (Альтеракские горы; "..YELLOW.."66,55"..WHITE..")"
Inst33Quest8_HORDE_Note = "Чтобы выполнить задание, вы должны убить либо Морлоха в Железном руднике около (Альтеракские горы - Север; "..YELLOW.."[1]"..WHITE.."), либо Надсмотрщика Хныкса в Руднике Ледяного Зуба около (Альтеракские горы - Юг; "..YELLOW.."[6]"..WHITE.."), пока Альянс контролирует."
Inst33Quest8_HORDE_Prequest = "Нет"
Inst33Quest8_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 9 Horde
Inst33Quest9_HORDE = "9. Башни и бункеры" -- 7101
Inst33Quest9_HORDE_Level = "60"
Inst33Quest9_HORDE_Attain = "51"
Inst33Quest9_HORDE_Aim = "Захватите башню врага и возвращайтесь к капралу Тике Кровавому Рыку в Альтеракские горы."
Inst33Quest9_HORDE_Location = "Капрал Тика Кровавый Рык (Альтеракские горы; "..YELLOW.."66,55"..WHITE..")"
Inst33Quest9_HORDE_Note = "Башню или бункер не нужно уничтожать, чтобы завершить задание, достаточно напасть."
Inst33Quest9_HORDE_Prequest = "Нет"
Inst33Quest9_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 10 Horde
Inst33Quest10_HORDE = "10. Кладбища долины Альтерака" -- 7082
Inst33Quest10_HORDE_Level = "60"
Inst33Quest10_HORDE_Attain = "51"
Inst33Quest10_HORDE_Aim = "Захватите кладбище, затем возвращайтесь к капралу Тике Кровавому Рыку в Альтеракские горы."
Inst33Quest10_HORDE_Location = "Капрал Тика Кровавый Рык (Альтеракские горы; "..YELLOW.."66,55"..WHITE..")"
Inst33Quest10_HORDE_Note = "Вам не нужно ничего делать, но быть рядом с кладбищем, когда Орда атакует его. Для этого не нужно захватывать, достаточно напасть."
Inst33Quest10_HORDE_Prequest = "Нет"
Inst33Quest10_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 11 Horde
Inst33Quest11_HORDE = "11. Пустые стойла" -- 7001
Inst33Quest11_HORDE_Level = "60"
Inst33Quest11_HORDE_Attain = "51"
Inst33Quest11_HORDE_Aim = "Найдите северного волка в Альтеракской долине. Подойдите к нему на достаточное расстояние, чтобы его 'приручить', и используйте намордник Северного Волка. После приручения северный волк проследует за вами к смотрителю стойл из клана Северного Волка. Поговорите со смотрителем, чтобы получить награду за пойманных волков."
Inst33Quest11_HORDE_Location = "Смотритель стойл из клана Северного Волка (Альтеракские горы - Юг; "..YELLOW.."[9]"..WHITE..")"
Inst33Quest11_HORDE_Note = "Вы можете найти волков вне базы. Задание повторяемое до 25 раз за текущую битву. После того, как 25 волков было приручено кавалеристы клана северного волка прибудут, чтобы помочь в бою."
Inst33Quest11_HORDE_Prequest = "Нет"
Inst33Quest11_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 12 Horde
Inst33Quest12_HORDE = "12. Упряжь из бараньей кожи" -- 7002
Inst33Quest12_HORDE_Level = "60"
Inst33Quest12_HORDE_Attain = "51"
Inst33Quest12_HORDE_Aim = "Тебе нужно нанести удар по местным баранам, которых использует Грозовая кавалерия."
Inst33Quest12_HORDE_Location = "Командир всадников на волках клана Северного Волка (Альтеракские горы - Юг; "..YELLOW.."[9]"..WHITE..")"
Inst33Quest12_HORDE_Note = "Бараны могут быть найдены на севере Альтеракской долины."
Inst33Quest12_HORDE_Prequest = "Нет"
Inst33Quest12_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 13 Horde
Inst33Quest13_HORDE = "13. Галлон крови" -- 7385
Inst33Quest13_HORDE_Level = "60"
Inst33Quest13_HORDE_Attain = "51"
Inst33Quest13_HORDE_Aim = "Вы должны нанести удар по нашим врагам и принести мне их кровь."
Inst33Quest13_HORDE_Location = "Шаманка стихий Турлога (Альтеракские горы - Юг; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest13_HORDE_Note = "После сдачи около 150 крови, Шаманка стихий Турлога начнет идти к (Альтеракские горы - Юг; "..YELLOW.."[14]"..WHITE.."). Оказавшись там, она начнет ритуал призыва, для которого потребуется 10 игроков. В случае успеха, Локолар Владыка Льда будет вызван, чтобы помочь в битве."
Inst33Quest13_HORDE_Prequest = "Нет"
Inst33Quest13_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 14 Horde
Inst33Quest14_HORDE = "14. Локолар Владыка Льда" -- 6801
Inst33Quest14_HORDE_Level = "60"
Inst33Quest14_HORDE_Attain = "51"
Inst33Quest14_HORDE_Aim = "Убивайте наших врагов и несите мне их кровь. Как только наберется достаточно крови, можно будет начать ритуал призыва.\nКогда могучий элементаль обрушится на армию Грозовой Вершины, победа будет наша!"
Inst33Quest14_HORDE_Location = "Шаманка стихий Турлога (Альтеракские горы - Юг; "..YELLOW.."[8]"..WHITE..")"
Inst33Quest14_HORDE_Note = "После сдачи около 150 крови, Шаманка стихий Турлога начнет идти к (Альтеракские горы - Юг; "..YELLOW.."[14]"..WHITE.."). Оказавшись там, она начнет ритуал призыва, для которого потребуется 10 игроков. В случае успеха, Локолар Владыка Льда будет вызван, чтобы помочь в битве."
Inst33Quest14_HORDE_Prequest = "Нет"
Inst33Quest14_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 15 Horde
Inst33Quest15_HORDE = "15. Небо зовет – флот Смуггла" -- 6825
Inst33Quest15_HORDE_Level = "60"
Inst33Quest15_HORDE_Attain = "51"
Inst33Quest15_HORDE_Aim = "Мы должны подготовить новый флот! Мои всадники намерены нанести удар по центру боя. Но в начале нужно утолить их голод.\nМне нужно достаточно мяса, чтобы прокормить солдат, целый флот! Сотни килограмм! Ты же сможешь добыть мяса?"
Inst33Quest15_HORDE_Location = "Командир звена Смуггл (Альтеракские горы - Юг; "..YELLOW.."[13]"..WHITE..")"
Inst33Quest15_HORDE_Note = "Убивайте NPC Альянса, чтобы получить Плоть солдата Грозовой Вершины."
Inst33Quest15_HORDE_Prequest = "Нет"
Inst33Quest15_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 16 Horde
Inst33Quest16_HORDE = "16. Небо зовет – флот Мааши" -- 6826
Inst33Quest16_HORDE_Level = "60"
Inst33Quest16_HORDE_Attain = "51"
Inst33Quest16_HORDE_Aim = "Вы много работали, но мы только начали!\nМой флот второй самый мощьный флот из всех. Мы будем стрелять по самым сильным нашим противникам. Но нам нужна Плоть лейтенанта Грозовой Вершины.$B$BПоспеши солдат!"
Inst33Quest16_HORDE_Location = "Командир звена Мааша (Альтеракские горы - Юг; "..YELLOW.."[13]"..WHITE..")"
Inst33Quest16_HORDE_Note = "Убивайте NPC Альянса, чтобы получить Плоть лейтенанта Грозовой Вершины."
Inst33Quest16_HORDE_Prequest = "Нет"
Inst33Quest16_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 17 Horde
Inst33Quest17_HORDE = "17. Небо зовет – флот Маэстра" -- 6827
Inst33Quest17_HORDE_Level = "60"
Inst33Quest17_HORDE_Attain = "51"
Inst33Quest17_HORDE_Aim = "Я был несколько дней заперт в дворфийской дыре! Тебе лучше поверить, я хочу мести!\nМы должны все тщательно спланировать.\nНам нужна плоть командира Грозовой Вершины, но эти жуки прячутся в тылу нашего врага."
Inst33Quest17_HORDE_Location = "Командир звена Маэстр (Альтеракские горы - Юг; "..YELLOW.."[13]"..WHITE..")"
Inst33Quest17_HORDE_Note = "Убивайте NPC Альянса, чтобы получить Плоть командира Грозовой Вершины."
Inst33Quest17_HORDE_Prequest = "Нет"
Inst33Quest17_HORDE_Folgequest = "Нет"
-- No Rewards for this quest



--------------- INST34 - Arathi Basin ---------------

Inst34Caption = "Низина Арати"
Inst34QAA = "3 задания"
Inst34QAH = "3 задания"

--Quest 1 Alliance
Inst34Quest1 = "1. Битва за Низину Арати" -- 8105
Inst34Quest1_Level = "55"
Inst34Quest1_Attain = "50"
Inst34Quest1_Aim = "Нападите на рудник, лесопилку, кузницу и ферму и возвращайтесь к фельдмаршалу Освету в Опорный пункт."
Inst34Quest1_Location = "Фельдмаршал Освет (Нагорье Арати - Опорный пункт; "..YELLOW.."46,45"..WHITE..")"
Inst34Quest1_Note = "Места для нападения отмечены на карте с 2 по 5."
Inst34Quest1_Prequest = "Нет"
Inst34Quest1_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 2 Alliance
Inst34Quest2 = "2. Контроль над четырьмя базами" -- 8114
Inst34Quest2_Level = "60"
Inst34Quest2_Attain = "60"
Inst34Quest2_Aim = "Отправляйтесь в Низину Арати, захватите и удержите контроль над четырьмя базами одновременно, затем возвращайтесь к фельдмаршалу Освету в Опорный пункт."
Inst34Quest2_Location = "Фельдмаршал Освет (Нагорье Арати - Опорный пункт; "..YELLOW.."46,45"..WHITE..")"
Inst34Quest2_Note = "Вам нужно дружелюбие с Лигой Аратора, чтобы получить это задание"
Inst34Quest2_Prequest = "Нет"
Inst34Quest2_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 3 Alliance
Inst34Quest3 = "3. Контроль над пятью базами" -- 8115
Inst34Quest3_Level = "60"
Inst34Quest3_Attain = "60"
Inst34Quest3_Aim = "Возьмите под контроль одновременно все 5 баз в Низине Арати, а затем возвращайтесь к фельдмаршалу Освету в Опорный пункт."
Inst34Quest3_Location = "Фельдмаршал Освет (Нагорье Арати - Опорный пункт; "..YELLOW.."46,45"..WHITE..")"
Inst34Quest3_Note = "Вам нужно превознесение с Лигой Аратора, чтобы получить это задание"
Inst34Quest3_Prequest = "Нет"
Inst34Quest3_Folgequest = "Нет"
--
Inst34Quest3name1 = "Араторская боевая гербовая накидка"


--Quest 1 Horde
Inst34Quest1_HORDE = "1. Битва за Низину Арати"
Inst34Quest1_HORDE_Level = "25"
Inst34Quest1_HORDE_Attain = "25"
Inst34Quest1_HORDE_Aim = "Нападите на рудник, лесопилку, кузницу и стойла в Низине Арати и возвращайтесь к повелительнице смерти Двайр в Павший Молот."
Inst34Quest1_HORDE_Location = "Повелительница смерти Двайр (Нагорье Арати - Павший Молот; "..YELLOW.."74,35"..WHITE..")"
Inst34Quest1_HORDE_Note = "Места для нападения отмечены на карте с 1 по 4."
Inst34Quest1_HORDE_Prequest = "Нет"
Inst34Quest1_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 2 Horde
Inst34Quest2_HORDE = "2. Захват четырех баз" -- 8121
Inst34Quest2_HORDE_Level = "60"
Inst34Quest2_HORDE_Attain = "60"
Inst34Quest2_HORDE_Aim = "Удерживайте одновременно четыре базы в Низине Арати, а затем возвращайтесь к повелительнице смерти Двайр в Павший Молот."
Inst34Quest2_HORDE_Location = "Повелительница смерти Двайр (Нагорье Арати - Павший Молот; "..YELLOW.."74,35"..WHITE..")"
Inst34Quest3_HORDE_Note = "Вам нужно превознесение с Осквернителями, чтобы получить это задание"
Inst34Quest2_HORDE_Prequest = "Нет"
Inst34Quest2_HORDE_Folgequest = "Нет"
-- No Rewards for this quest

--Quest 3 Horde
Inst34Quest3_HORDE = "3. Занять пять баз" -- 8122
Inst34Quest3_HORDE_Level = "60"
Inst34Quest3_HORDE_Attain = "60"
Inst34Quest3_HORDE_Aim = "Захватите и удерживайте все пять баз в Низине Арати, затем возвращайтесь к повелительнице смерти Двайр в Павший Молот."
Inst34Quest3_HORDE_Location = "Повелительница смерти Двайр (Нагорье Арати - Павший Молот; "..YELLOW.."74,35"..WHITE..")"
Inst34Quest3_HORDE_Note = "Вам нужно превознесение с Осквернителями, чтобы получить это задание"
Inst34Quest3_HORDE_Prequest = "Нет"
Inst34Quest3_HORDE_Folgequest = "Нет"
--
Inst34Quest3name1_HORDE = "Боевая гербовая накидка осквернителей"



--------------- INST35 - Warsong Gulch ---------------

Inst35Caption = "Ущелье Песни Войны"
Inst35QAA = "Нет заданий"
Inst35QAH = "Нет заданий"




---------------------------------------------------
---------------- OUTDOOR RAIDS --------------------
---------------------------------------------------



--------------- INST36 - Dragons of Nightmare ---------------

Inst36Caption = "Драконы Кошмаров"
Inst36QAA = "1 задание"
Inst36QAH = "1 задание"

--Quest 1 Alliance
Inst36Quest1 = "1. Под покровом кошмара"
Inst36Quest1_Level = "60"
Inst36Quest1_Attain = "60"
Inst36Quest1_Aim = "Найдите того, кто сможет осознать значение поглощенного кошмарами предмета.\n\nМожет быть, вам сможет помочь могущественный друид."
Inst36Quest1_Location = "Поглощенный кошмарами предмет (добывается с Эмерисс, Таэрара, Летона или Исондры)"
Inst36Quest1_Note = "Задание завершается Хранителю Ремулу (Лунная поляна - Святилище Ремула; "..YELLOW.."36,41"..WHITE.."). Награда перечислены для следующего задания.."
Inst36Quest1_Prequest = "Нет"
Inst36Quest1_Folgequest = "Пробуждение легенд"
--
Inst36Quest1name1 = "Перстень-печатка Малфуриона"


--Quest 1 Horde  (same as Quest 1 Alliance)
Inst36Quest1_HORDE = Inst36Quest1
Inst36Quest1_HORDE_Level = Inst36Quest1_Level
Inst36Quest1_HORDE_Attain = Inst36Quest1_Attain
Inst36Quest1_HORDE_Aim = Inst36Quest1_Aim
Inst36Quest1_HORDE_Location = Inst36Quest1_Location
Inst36Quest1_HORDE_Note = Inst36Quest1_Note
Inst36Quest1_HORDE_Prequest = Inst36Quest1_Prequest
Inst36Quest1_HORDE_Folgequest = Inst36Quest1_Folgequest
--
Inst36Quest1name1_HORDE = Inst36Quest1name1



--------------- INST37 - Azuregos ---------------

Inst37Caption = "Азурегос"
Inst37QAA = "2 задания"
Inst37QAH = "2 задания"

--Quest 1 Alliance
Inst37Quest1 = "1. Перетянутый жилами лист древня(Охотник)"
Inst37Quest1_Level = "60"
Inst37Quest1_Attain = "60"
Inst37Quest1_Aim = "Хастат Древний просит вас принести ему жилу взрослого синего дракона. По выполнении задания возвращайтесь к Хастату в Оскверненный лес."
Inst37Quest1_Location = "Хастат Древний (Оскверненный лес - Железнолесье; "..YELLOW.."48,24"..WHITE..")"
Inst37Quest1_Note = "Задание для охотников: Убейте Азурегоса, чтобы получить Жилу взрослого синего дракона. Он ходит по середине южного полуострова в Азшаре вблизи "..YELLOW.."[1]"..WHITE.."."
Inst37Quest1_Prequest = "Древний лист ("..YELLOW.."Огненные Недра"..WHITE..")"
Inst37Quest1_Folgequest = "Нет"
Inst37Quest1PreQuest = "true"
--
Inst37Quest1name1 = "Перетянутый жилами лист древня"

--Quest 2 Alliance
Inst37Quest2 = "2. Магическая книга Азурегоса"
Inst37Quest2_Level = "60"
Inst37Quest2_Attain = "60"
Inst37Quest2_Aim = "Принесите магическую книгу Азурегоса Нарайну Причуденю в Танарис."
Inst37Quest2_Location = "Дух Азурегоса (Азшара; "..YELLOW.."56,83"..WHITE..")"
Inst37Quest2_Note = "Вы можете найти Нарайна Причудня в Танарисе около "..YELLOW.."65.17"..WHITE.."."
Inst37Quest2_Prequest = "Создание драконов"
Inst37Quest2_Folgequest = "Перевод книги"
-- No Rewards for this quest


--Quest 1 Horde (same as Quest 1 Alliance)
Inst37Quest1_HORDE = Inst37Quest1
Inst37Quest1_HORDE_Level = Inst37Quest1_Level
Inst37Quest1_HORDE_Attain = Inst37Quest1_Attain
Inst37Quest1_HORDE_Aim = Inst37Quest1_Aim
Inst37Quest1_HORDE_Location = Inst37Quest1_Location
Inst37Quest1_HORDE_Note = Inst37Quest1_Note
Inst37Quest1_HORDE_Prequest = Inst37Quest1_Prequest
Inst37Quest1_HORDE_Folgequest = Inst37Quest1_Folgequest
--
Inst37Quest1name1_HORDE = Inst37Quest1name1


--Quest 2 Horde (same as Quest 2 Alliance)
Inst37Quest2_HORDE = Inst37Quest2
Inst37Quest2_HORDE_Level = Inst37Quest2_Level
Inst37Quest2_HORDE_Attain = Inst37Quest2_Attain
Inst37Quest2_HORDE_Aim = Inst37Quest2_Aim
Inst37Quest2_HORDE_Location = Inst37Quest2_Location
Inst37Quest2_HORDE_Note = Inst37Quest2_Note
Inst37Quest2_HORDE_Prequest = Inst37Quest2_Prequest
Inst37Quest2_HORDE_Folgequest = Inst37Quest2_Folgequest
-- No Rewards for this quest



--------------- INST38 - Highlord Kruul ---------------

Inst38Caption = "Верховный лорд Круул"
Inst38QAA = "Нет заданий"
Inst38QAH = "Нет задание"


end


-- End of File
