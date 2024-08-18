---@class Private
local Private = select(2, ...)

local L = Private.L

L["Difficulty-1"] = "L"
L["Difficulty-3"] = "N"
L["Difficulty-4"] = "H"
L["Difficulty-5"] = "M"
L["AllStars"] = "All Stars"
L["Rank"] = "Rank"
L["Unknown"] = [[Unknown]]
L["UnknownRealm"] = [[[%s] Realm '%s' (id %d) not in database. Please report to the Warcraft Logs team.]]
L["CopyProfileURL"] = [[Copy WCL URL]]
L["Subscriber"] = [[Subscriber]]
L["ShiftToExpand"] = [[<Shift> to Expand]]
L["SubAddonMissing"] = [[[%s] Database for '%s' is missing. Please reinstall the addon or make sure it is up to date.]]
L["DBLoadError"] = [[[%s] Could not load database for '%s'. Reason: %s]]

if Private.IsCata then
    L["Encounter-1035"] = [[Conclave of Wind]]
    L["Encounter-1034"] = [[Al'Akir]]
    L["Encounter-1027"] = [[Omnotron Defense System]]
    L["Encounter-1024"] = [[Magmaw]]
    L["Encounter-1022"] = [[Atramedes]]
    L["Encounter-1023"] = [[Chimaeron]]
    L["Encounter-1025"] = [[Maloriak]]
    L["Encounter-1026"] = [[Nefarian's End]]
    L["Encounter-1030"] = [[Halfus Wyrmbreaker]]
    L["Encounter-1032"] = [[Theralion and Valiona]]
    L["Encounter-1028"] = [[Ascendant Council]]
    L["Encounter-1029"] = [[Cho'gall]]
    L["Encounter-1082"] = [[Sinestra]]
elseif Private.IsWrath then
    L["Encounter-50744"] = [[Flame Leviathan]]
    L["Encounter-50745"] = [[Ignis the Furnace Master]]
    L["Encounter-50746"] = [[Razorscale]]
    L["Encounter-50747"] = [[XT-002 Deconstructor]]
    L["Encounter-50748"] = [[The Iron Council]]
    L["Encounter-50749"] = [[Kologarn]]
    L["Encounter-50750"] = [[Auriaya]]
    L["Encounter-50751"] = [[Hodir]]
    L["Encounter-50752"] = [[Thorim]]
    L["Encounter-50753"] = [[Freya]]
    L["Encounter-50754"] = [[Mimiron]]
    L["Encounter-50755"] = [[General Vezax]]
    L["Encounter-50756"] = [[Yogg-Saron]]
    L["Encounter-50757"] = [[Algalon the Observer]]
elseif Private.IsClassicEra then
    L["Difficulty-3"] = "HL1"
    L["Difficulty-4"] = "HL2"
    L["Difficulty-5"] = "HL3"
    L["Encounter-100663"] = [[Lucifron]]
    L["Encounter-100664"] = [[Magmadar]]
    L["Encounter-100665"] = [[Gehennas]]
    L["Encounter-100666"] = [[Garr]]
    L["Encounter-100667"] = [[Shazzrah]]
    L["Encounter-100668"] = [[Baron Geddon]]
    L["Encounter-100669"] = [[Sulfuron Harbinger]]
    L["Encounter-100670"] = [[Golemagg the Incinerator]]
    L["Encounter-100671"] = [[Majordomo Executus]]
    L["Encounter-100672"] = [[Ragnaros]]
    L["Encounter-3018"] = [[The Molten Core]]
end

local locale = GAME_LOCALE or GetLocale()

if locale == "deDE" then
    L["Difficulty-1"] = "L"
    L["Difficulty-3"] = "N"
    L["Difficulty-4"] = "H"
    L["Difficulty-5"] = "M"
    L["AllStars"] = "Bestplatzierte"
    L["Rank"] = "Rang"
    L["Unknown"] = [[Unbekannt]]
    L["UnknownRealm"] = [[[%s] Realm '%s' (id %d) not in database. Please report to the Warcraft Logs team.]]
    L["CopyProfileURL"] = [[Copy WCL URL]]
    L["Subscriber"] = [[Abonnent]]
    L["ShiftToExpand"] = [[<Shift> to Expand]]
    L["SubAddonMissing"] = [[[%s] Database for '%s' is missing. Please reinstall the addon or make sure it is up to date.]]
    L["DBLoadError"] = [[[%s] Could not load database for '%s'. Reason: %s]]

    if Private.IsCata then
        L["Encounter-1035"] = [[Konklave des Windes]]
        L["Encounter-1034"] = [[Al'Akir]]
        L["Encounter-1027"] = [[Omnotron-Verteidigungssystem]]
        L["Encounter-1024"] = [[Magmaul]]
        L["Encounter-1022"] = [[Atramedes]]
        L["Encounter-1023"] = [[Schimaeron]]
        L["Encounter-1025"] = [[Maloriak]]
        L["Encounter-1026"] = [[Nefarians Ende]]
        L["Encounter-1030"] = [[Halfus Wyrmbrecher]]
        L["Encounter-1032"] = [[Theralion und Valiona]]
        L["Encounter-1028"] = [[Rat der Aszendenten]]
        L["Encounter-1029"] = [[Cho'gall]]
        L["Encounter-1082"] = [[Sinestra]]
    elseif Private.IsWrath then
        L["Encounter-50744"] = [[Flammenleviathan]]
        L["Encounter-50745"] = [[Ignis, Meister des Eisenwerks]]
        L["Encounter-50746"] = [[Klingenschuppe]]
        L["Encounter-50747"] = [[XT-002 Dekonstruktor]]
        L["Encounter-50748"] = [[Der Eiserne Rat]]
        L["Encounter-50749"] = [[Kologarn]]
        L["Encounter-50750"] = [[Auriaya]]
        L["Encounter-50751"] = [[Hodir]]
        L["Encounter-50752"] = [[Thorim]]
        L["Encounter-50753"] = [[Freya]]
        L["Encounter-50754"] = [[Mimiron]]
        L["Encounter-50755"] = [[General Vezax]]
        L["Encounter-50756"] = [[Yogg-Saron]]
        L["Encounter-50757"] = [[Algalon der Beobachter]]
    elseif Private.IsClassicEra then
        L["Difficulty-3"] = "HL1"
        L["Difficulty-4"] = "HL2"
        L["Difficulty-5"] = "HL3"
        L["Encounter-100663"] = [[Lucifron]]
        L["Encounter-100664"] = [[Magmadar]]
        L["Encounter-100665"] = [[Gehennas]]
        L["Encounter-100666"] = [[Garr]]
        L["Encounter-100667"] = [[Shazzrah]]
        L["Encounter-100668"] = [[Baron Geddon]]
        L["Encounter-100669"] = [[Sulfuronherold]]
        L["Encounter-100670"] = [[Golemagg der Verbrenner]]
        L["Encounter-100671"] = [[Majordomus Exekutus]]
        L["Encounter-100672"] = [[Ragnaros]]
        L["Encounter-3018"] = [[Der Geschmolzene Kern]]
    end
elseif locale == "esES" or locale == "esMX" then
    L["Difficulty-1"] = "L"
    L["Difficulty-3"] = "N"
    L["Difficulty-4"] = "H"
    L["Difficulty-5"] = "M"
    L["AllStars"] = "Los Mejores"
    L["Rank"] = "Rango"
    L["Unknown"] = [[Unknown]]
    L["UnknownRealm"] = [[[%s] Realm '%s' (id %d) not in database. Please report to the Warcraft Logs team.]]
    L["CopyProfileURL"] = [[Copy WCL URL]]
    L["Subscriber"] = [[Subscriber]]
    L["ShiftToExpand"] = [[<Shift> to Expand]]
    L["SubAddonMissing"] = [[[%s] Database for '%s' is missing. Please reinstall the addon or make sure it is up to date.]]
    L["DBLoadError"] = [[[%s] Could not load database for '%s'. Reason: %s]]

    if Private.IsCata then
        L["Encounter-1035"] = [[Cónclave del Viento]]
        L["Encounter-1034"] = [[Al'Akir]]
        L["Encounter-1027"] = [[Sistema de Defensa de Omnitron]]
        L["Encounter-1024"] = [[Faucemagma]]
        L["Encounter-1022"] = [[Atramedes]]
        L["Encounter-1023"] = [[Chimaeron]]
        L["Encounter-1025"] = [[Maloriak]]
        L["Encounter-1026"] = [[El Final de Nefarian]]
        L["Encounter-1030"] = [[Halfus Rompevermis]]
        L["Encounter-1032"] = [[Theralion y Valiona]]
        L["Encounter-1028"] = [[Consejo de ascendientes Crepusculares]]
        L["Encounter-1029"] = [[Cho'gall]]
        L["Encounter-1082"] = [[Sinestra]]
    elseif Private.IsWrath then
        L["Encounter-50744"] = [[Leviatán de llamas]]
        L["Encounter-50745"] = [[Ignis el Maestro de la Caldera]]
        L["Encounter-50746"] = [[Tajoescama]]
        L["Encounter-50747"] = [[Desarmador XA-002]]
        L["Encounter-50748"] = [[El Consejo de Hierro]]
        L["Encounter-50749"] = [[Kologarn]]
        L["Encounter-50750"] = [[Auriaya]]
        L["Encounter-50751"] = [[Hodir]]
        L["Encounter-50752"] = [[Thorim]]
        L["Encounter-50753"] = [[Freya]]
        L["Encounter-50754"] = [[Mimiron]]
        L["Encounter-50755"] = [[General Vezax]]
        L["Encounter-50756"] = [[Yogg-Saron]]
        L["Encounter-50757"] = [[Algalon el Observador]]
    elseif Private.IsClassicEra then
        L["Difficulty-3"] = "HL1"
        L["Difficulty-4"] = "HL2"
        L["Difficulty-5"] = "HL3"
        L["Encounter-100663"] = [[Lucifron]]
        L["Encounter-100664"] = [[Magmadar]]
        L["Encounter-100665"] = [[Gehennas]]
        L["Encounter-100666"] = [[Garr]]
        L["Encounter-100667"] = [[Shazzrah]]
        L["Encounter-100668"] = [[Barón Geddon]]
        L["Encounter-100669"] = [[Presagista Sulfuron]]
        L["Encounter-100670"] = [[Golemagg el Incinerador]]
        L["Encounter-100671"] = [[Mayordomo Executus]]
        L["Encounter-100672"] = [[Ragnaros]]
        L["Encounter-3018"] = [[Núcleo de Magma]]
    end
elseif locale == "frFR" then
    L["Difficulty-1"] = "L"
    L["Difficulty-3"] = "N"
    L["Difficulty-4"] = "H"
    L["Difficulty-5"] = "M"
    L["AllStars"] = "All Stars"
    L["Rank"] = "Rang"
    L["Unknown"] = [[Inconnu]]
    L["UnknownRealm"] = [[[%s] Le royaume '%s' (identifiant %d) n'est pas dans la base de données. Merci de contacter l'équipe de Warcraft Logs.]]
    L["CopyProfileURL"] = [[Copier l'URL WarcraftLogs]]
    L["Subscriber"] = [[Abonné]]
    L["ShiftToExpand"] = [[<Maj> pour déplier]]
    L["SubAddonMissing"] = [[[%s]La base de donnée ne contient pas '%s'. Merci de réinstaller l'add-on, ou de vous assurer qu'il est à jour.]]
    L["DBLoadError"] = [[[%s] Impossible de charger la base de données de '%s'. Raison : %s]]

    if Private.IsCata then
        L["Encounter-1035"] = [[Conclave du Vent]]
        L["Encounter-1034"] = [[Al'Akir]]
        L["Encounter-1027"] = [[Système de défense Omnitron]]
        L["Encounter-1024"] = [[Magmagueule]]
        L["Encounter-1022"] = [[Atramédès]]
        L["Encounter-1023"] = [[Chimaeron]]
        L["Encounter-1025"] = [[Maloriak]]
        L["Encounter-1026"] = [[Fin de Nefarian]]
        L["Encounter-1030"] = [[Halfus Brise-Wyrm]]
        L["Encounter-1032"] = [[Theralion et Valiona]]
        L["Encounter-1028"] = [[Conseil d'Ascendance]]
        L["Encounter-1029"] = [[Cho’gall]]
        L["Encounter-1082"] = [[Sinestra]]
    elseif Private.IsWrath then
        L["Encounter-50744"] = [[Léviathan des flammes]]
        L["Encounter-50745"] = [[Ignis le maître de la Fournaise]]
        L["Encounter-50746"] = [[Tranchécaille]]
        L["Encounter-50747"] = [[Déconstructeur XT-002]]
        L["Encounter-50748"] = [[Conseil de fer]]
        L["Encounter-50749"] = [[Kologarn]]
        L["Encounter-50750"] = [[Auriaya]]
        L["Encounter-50751"] = [[Hodir]]
        L["Encounter-50752"] = [[Thorim]]
        L["Encounter-50753"] = [[Freya]]
        L["Encounter-50754"] = [[Mimiron]]
        L["Encounter-50755"] = [[Général Vezax]]
        L["Encounter-50756"] = [[Yogg-Saron]]
        L["Encounter-50757"] = [[Algalon l’Observateur]]
    elseif Private.IsClassicEra then
        L["Difficulty-3"] = "HL1"
        L["Difficulty-4"] = "HL2"
        L["Difficulty-5"] = "HL3"
        L["Encounter-100663"] = [[Lucifron]]
        L["Encounter-100664"] = [[Magmadar]]
        L["Encounter-100665"] = [[Gehennas]]
        L["Encounter-100666"] = [[Garr]]
        L["Encounter-100667"] = [[Shazzrah]]
        L["Encounter-100668"] = [[Baron Geddon]]
        L["Encounter-100669"] = [[Messager de Sulfuron]]
        L["Encounter-100670"] = [[Golemagg l’Incinérateur]]
        L["Encounter-100671"] = [[Chambellan Executus]]
        L["Encounter-100672"] = [[Ragnaros]]
        L["Encounter-3018"] = [[Le Cœur du Magma]]
    end
elseif locale == "itIT" then
    L["Difficulty-1"] = "L"
    L["Difficulty-3"] = "N"
    L["Difficulty-4"] = "H"
    L["Difficulty-5"] = "M"
    L["AllStars"] = "Classificazione All-Stars"
    L["Rank"] = "Rango"
    L["Unknown"] = [[Unknown]]
    L["UnknownRealm"] = [[[%s] Realm '%s' (id %d) not in database. Please report to the Warcraft Logs team.]]
    L["CopyProfileURL"] = [[Copy WCL URL]]
    L["Subscriber"] = [[Subscriber]]
    L["ShiftToExpand"] = [[<Shift> to Expand]]
    L["SubAddonMissing"] = [[[%s] Database for '%s' is missing. Please reinstall the addon or make sure it is up to date.]]
    L["DBLoadError"] = [[[%s] Could not load database for '%s'. Reason: %s]]

    if Private.IsCata then
        L["Encounter-1035"] = [[Conclave del Vento]]
        L["Encounter-1034"] = [[Al'Akir]]
        L["Encounter-1027"] = [[Sistema di Difesa Omnotron]]
        L["Encounter-1024"] = [[Rodimagma]]
        L["Encounter-1022"] = [[Atramedes]]
        L["Encounter-1023"] = [[Chimeron]]
        L["Encounter-1025"] = [[Maloriak]]
        L["Encounter-1026"] = [[Caduta di Nefarian]]
        L["Encounter-1030"] = [[Halfus Spezzadragoni]]
        L["Encounter-1032"] = [[Theralion e Valiona]]
        L["Encounter-1028"] = [[Concilio dell'Ascesa]]
        L["Encounter-1029"] = [[Cho'gall]]
        L["Encounter-1082"] = [[Sinestra]]
    elseif Private.IsWrath then
        L["Encounter-50744"] = [[Flame Leviathan]]
        L["Encounter-50745"] = [[Ignis the Furnace Master]]
        L["Encounter-50746"] = [[Razorscale]]
        L["Encounter-50747"] = [[XT-002 Deconstructor]]
        L["Encounter-50748"] = [[The Iron Council]]
        L["Encounter-50749"] = [[Kologarn]]
        L["Encounter-50750"] = [[Auriaya]]
        L["Encounter-50751"] = [[Hodir]]
        L["Encounter-50752"] = [[Thorim]]
        L["Encounter-50753"] = [[Freya]]
        L["Encounter-50754"] = [[Mimiron]]
        L["Encounter-50755"] = [[General Vezax]]
        L["Encounter-50756"] = [[Yogg-Saron]]
        L["Encounter-50757"] = [[Algalon the Observer]]
    elseif Private.IsClassicEra then
        L["Difficulty-3"] = "HL1"
        L["Difficulty-4"] = "HL2"
        L["Difficulty-5"] = "HL3"
        L["Encounter-100663"] = [[Lucifron]]
        L["Encounter-100664"] = [[Magmadar]]
        L["Encounter-100665"] = [[Gehennas]]
        L["Encounter-100666"] = [[Garr]]
        L["Encounter-100667"] = [[Shazzrah]]
        L["Encounter-100668"] = [[Barone Geddon]]
        L["Encounter-100669"] = [[Sulfuron l'Araldo]]
        L["Encounter-100670"] = [[Golemagg il Crematore]]
        L["Encounter-100671"] = [[Maggiordomo Executus]]
        L["Encounter-100672"] = [[Ragnaros]]
        L["Encounter-3018"] = [[The Molten Core]]
    end
elseif locale == "koKO" then
    L["Difficulty-1"] = "L"
    L["Difficulty-3"] = "일반"
    L["Difficulty-4"] = "영웅"
    L["Difficulty-5"] = "신화"
    L["AllStars"] = "올스타"
    L["Rank"] = "등급"
    L["Unknown"] = [[Unknown]]
    L["UnknownRealm"] = [[[%s] Realm '%s' (id %d) not in database. Please report to the Warcraft Logs team.]]
    L["CopyProfileURL"] = [[Copy WCL URL]]
    L["Subscriber"] = [[Subscriber]]
    L["ShiftToExpand"] = [[<Shift> to Expand]]
    L["SubAddonMissing"] = [[[%s] Database for '%s' is missing. Please reinstall the addon or make sure it is up to date.]]
    L["DBLoadError"] = [[[%s] Could not load database for '%s'. Reason: %s]]

    if Private.IsCata then
        L["Encounter-1035"] = [[바람의 비밀의회]]
        L["Encounter-1034"] = [[알아키르]]
        L["Encounter-1027"] = [[만능골렘 방어 시스템]]
        L["Encounter-1024"] = [[용암아귀]]
        L["Encounter-1022"] = [[아트라메데스]]
        L["Encounter-1023"] = [[키마이론]]
        L["Encounter-1025"] = [[말로리악]]
        L["Encounter-1026"] = [[네파리안의 최후]]
        L["Encounter-1030"] = [[할푸스 웜브레이커]]
        L["Encounter-1032"] = [[발리오나와 테랄리온]]
        L["Encounter-1028"] = [[승천 의회]]
        L["Encounter-1029"] = [[초갈]]
        L["Encounter-1082"] = [[시네스트라]]
    elseif Private.IsWrath then
        L["Encounter-50744"] = [[거대 화염전차]]
        L["Encounter-50745"] = [[용광로 군주 이그니스]]
        L["Encounter-50746"] = [[칼날비늘]]
        L["Encounter-50747"] = [[XT-002 해체자]]
        L["Encounter-50748"] = [[무쇠 평의회]]
        L["Encounter-50749"] = [[콜로간]]
        L["Encounter-50750"] = [[아우리아야]]
        L["Encounter-50751"] = [[호디르]]
        L["Encounter-50752"] = [[토림]]
        L["Encounter-50753"] = [[프레이야]]
        L["Encounter-50754"] = [[미미론]]
        L["Encounter-50755"] = [[장군 베작스]]
        L["Encounter-50756"] = [[요그사론]]
        L["Encounter-50757"] = [[관찰자 알갈론]]
    elseif Private.IsClassicEra then
        L["Difficulty-3"] = "HL1"
        L["Difficulty-4"] = "HL2"
        L["Difficulty-5"] = "HL3"
        L["Encounter-100663"] = [[루시프론]]
        L["Encounter-100664"] = [[마그마다르]]
        L["Encounter-100665"] = [[게헨나스]]
        L["Encounter-100666"] = [[가르]]
        L["Encounter-100667"] = [[샤즈라]]
        L["Encounter-100668"] = [[남작 게돈]]
        L["Encounter-100669"] = [[설퍼론 선구자]]
        L["Encounter-100670"] = [[초열의 골레마그]]
        L["Encounter-100671"] = [[청지기 이그젝큐투스]]
        L["Encounter-100672"] = [[라그나로스]]
        L["Encounter-3018"] = [[화산 심장부]]
    end
elseif locale == "ptBR" then
    L["Difficulty-1"] = "L"
    L["Difficulty-3"] = "N"
    L["Difficulty-4"] = "H"
    L["Difficulty-5"] = "M"
    L["AllStars"] = "All Stars"
    L["Rank"] = "Ranque"
    L["Unknown"] = [[Desconhecido]]
    L["UnknownRealm"] = [[[%s] Reino '%s' (id %d) não está na base de dados. Por favor reporte ao time Warcraft Logs.]]
    L["CopyProfileURL"] = [[Copiar URL do WCL]]
    L["Subscriber"] = [[Assinante]]
    L["ShiftToExpand"] = [[<Shift> para expandir]]
    L["SubAddonMissing"] = [[[%s] Base de dados para '%s' inexistente. Por favor reinstale o addon ou confirme que está atualizado.]]
    L["DBLoadError"] = [[[%s] Não foi possível carregar a base de dados '%s'. Motivo: %s]]

    if Private.IsCata then
        L["Encounter-1035"] = [[Conclave do Vento]]
        L["Encounter-1034"] = [[Al'Akir]]
        L["Encounter-1027"] = [[Sistema de Defesa Omnitron]]
        L["Encounter-1024"] = [[Magorja]]
        L["Encounter-1022"] = [[Atramedes]]
        L["Encounter-1023"] = [[Khímaron]]
        L["Encounter-1025"] = [[Maloriak]]
        L["Encounter-1026"] = [[Fim de Nefarian]]
        L["Encounter-1030"] = [[Halfus Quebra-serpe]]
        L["Encounter-1032"] = [[Theralion e Valiona]]
        L["Encounter-1028"] = [[Conselho Ascendente]]
        L["Encounter-1029"] = [[Cho'gall]]
        L["Encounter-1082"] = [[Sinestra]]
    elseif Private.IsWrath then
        L["Encounter-50744"] = [[Leviatã Flamejante]]
        L["Encounter-50745"] = [[Ignis, o Mestre de Caldeira]]
        L["Encounter-50746"] = [[Navalhada]]
        L["Encounter-50747"] = [[Desconstrutor XT-002]]
        L["Encounter-50748"] = [[Conselho de Ferro]]
        L["Encounter-50749"] = [[Kologarn]]
        L["Encounter-50750"] = [[Auriaya]]
        L["Encounter-50751"] = [[Hodir]]
        L["Encounter-50752"] = [[Thorim]]
        L["Encounter-50753"] = [[Freya]]
        L["Encounter-50754"] = [[Mimiron]]
        L["Encounter-50755"] = [[General Vezax]]
        L["Encounter-50756"] = [[Yogg-Saron]]
        L["Encounter-50757"] = [[Algalon, o Observador]]
    elseif Private.IsClassicEra then
        L["Difficulty-3"] = "HL1"
        L["Difficulty-4"] = "HL2"
        L["Difficulty-5"] = "HL3"
        L["Encounter-100663"] = [[Lúcifron]]
        L["Encounter-100664"] = [[Magmadar]]
        L["Encounter-100665"] = [[Geena]]
        L["Encounter-100666"] = [[Garr]]
        L["Encounter-100667"] = [[Shazzrah]]
        L["Encounter-100668"] = [[Barão Geddon]]
        L["Encounter-100669"] = [[Emissário de Sulfuron]]
        L["Encounter-100670"] = [[Golemagg, o Incinerador]]
        L["Encounter-100671"] = [[Senescal Executus]]
        L["Encounter-100672"] = [[Ragnaros]]
        L["Encounter-3018"] = [[O Núcleo Derretido]]
    end
elseif locale == "ruRU" then
    L["Difficulty-1"] = "ПР"
    L["Difficulty-3"] = "Н"
    L["Difficulty-4"] = "Г"
    L["Difficulty-5"] = "Э"
    L["AllStars"] = "Все звезды"
    L["Rank"] = "Ранг"
    L["Unknown"] = [[Неизвестно]]
    L["UnknownRealm"] = [[[%s] Реалм '%s' (id %d) отсутствует в базе данных. Пожалуйста, сообщите об этом команде Warcraft Logs.]]
    L["CopyProfileURL"] = [[Скопировать WCL URL]]
    L["Subscriber"] = [[Подписчик]]
    L["ShiftToExpand"] = [[<Shift> чтобы расширить]]
    L["SubAddonMissing"] = [[[%s] База данных для '%s' отсутствует. Пожалуйста, переустановите аддон или убедитесь, что он обновлен.]]
    L["DBLoadError"] = [[[%s] Не удалось загрузить базу данных для '%s'. Причина: %s]]

    if Private.IsCata then
        L["Encounter-1035"] = [[Конклав Ветра]]
        L["Encounter-1034"] = [[Ал'акир]]
        L["Encounter-1027"] = [[Защитная система \"Омнитрон\"]]
        L["Encounter-1024"] = [[Магмарь]]
        L["Encounter-1022"] = [[Атрамед]]
        L["Encounter-1023"] = [[Химерон]]
        L["Encounter-1025"] = [[Малориак]]
        L["Encounter-1026"] = [[Гибель Нефариана]]
        L["Encounter-1030"] = [[Халфий Змеерез]]
        L["Encounter-1032"] = [[Тералион и Валиона]]
        L["Encounter-1028"] = [[Совет Перерожденных]]
        L["Encounter-1029"] = [[Чо'Галл]]
        L["Encounter-1082"] = [[Синестра]]
    elseif Private.IsWrath then
        L["Encounter-50744"] = [[\"Огненный Левиафан\"]]
        L["Encounter-50745"] = [[Повелитель горнов Игнис]]
        L["Encounter-50746"] = [[Острокрылая]]
        L["Encounter-50747"] = [[Разрушитель XT-002]]
        L["Encounter-50748"] = [[Железное Собрание]]
        L["Encounter-50749"] = [[Кологарн]]
        L["Encounter-50750"] = [[Ауриайя]]
        L["Encounter-50751"] = [[Ходир]]
        L["Encounter-50752"] = [[Торим]]
        L["Encounter-50753"] = [[Фрейя]]
        L["Encounter-50754"] = [[Мимирон]]
        L["Encounter-50755"] = [[Генерал Везакс]]
        L["Encounter-50756"] = [[Йогг-Сарон]]
        L["Encounter-50757"] = [[Алгалон Наблюдатель]]
    elseif Private.IsClassicEra then
        L["Difficulty-3"] = "HL1"
        L["Difficulty-4"] = "HL2"
        L["Difficulty-5"] = "HL3"
        L["Encounter-100663"] = [[Люцифрон]]
        L["Encounter-100664"] = [[Магмадар]]
        L["Encounter-100665"] = [[Гееннас]]
        L["Encounter-100666"] = [[Гарр]]
        L["Encounter-100667"] = [[Шаззрах]]
        L["Encounter-100668"] = [[Барон Геддон]]
        L["Encounter-100669"] = [[Предвестник Сульфурон]]
        L["Encounter-100670"] = [[Големагг Испепелитель]]
        L["Encounter-100671"] = [[Мажордом Экзекутус]]
        L["Encounter-100672"] = [[Рагнарос]]
        L["Encounter-3018"] = [[Огненные Недра]]
    end
elseif locale == "zhCN" then
    L["Difficulty-1"] = "随机"
    L["Difficulty-3"] = "普通"
    L["Difficulty-4"] = "英雄"
    L["Difficulty-5"] = "史诗"
    L["AllStars"] = "全明星分"
    L["Rank"] = "排名"
    L["Unknown"] = [[未知]]
    L["UnknownRealm"] = [[[%s] 服务器 '%s' (id %d) 不在数据库中。请报告给WCL团队。]]
    L["CopyProfileURL"] = [[复制 WCL 链接]]
    L["Subscriber"] = [[WCL会员]]
    L["ShiftToExpand"] = [[按住 <Shift> 展开]]
    L["SubAddonMissing"] = [[[%s] 缺少 '%s' 的数据库。请重新安装插件或确保其为最新版本。]]
    L["DBLoadError"] = [[[%s] 无法加载 '%s' 的数据库。原因：%s]]

    if Private.IsCata then
        L["Encounter-1035"] = [[风之议会]]
        L["Encounter-1034"] = [[奥拉基尔]]
        L["Encounter-1027"] = [[全能金刚防御系统]]
        L["Encounter-1024"] = [[熔喉]]
        L["Encounter-1022"] = [[艾卓曼德斯]]
        L["Encounter-1023"] = [[奇美隆]]
        L["Encounter-1025"] = [[马洛拉克]]
        L["Encounter-1026"] = [[奈法利安的末日]]
        L["Encounter-1030"] = [[哈尔弗斯·碎龙者]]
        L["Encounter-1032"] = [[瑟纳利昂与瓦里昂娜]]
        L["Encounter-1028"] = [[升腾者议会]]
        L["Encounter-1029"] = [[古加尔]]
        L["Encounter-1082"] = [[希奈丝特拉]]
    elseif Private.IsWrath then
        L["Encounter-50744"] = [[烈焰巨兽]]
        L["Encounter-50745"] = [[掌炉者伊格尼斯]]
        L["Encounter-50746"] = [[锋鳞]]
        L["Encounter-50747"] = [[XT-002拆解者]]
        L["Encounter-50748"] = [[钢铁议会]]
        L["Encounter-50749"] = [[科隆加恩]]
        L["Encounter-50750"] = [[欧尔莉亚]]
        L["Encounter-50751"] = [[霍迪尔]]
        L["Encounter-50752"] = [[托里姆]]
        L["Encounter-50753"] = [[弗蕾亚]]
        L["Encounter-50754"] = [[米米尔隆]]
        L["Encounter-50755"] = [[维扎克斯将军]]
        L["Encounter-50756"] = [[尤格-萨隆]]
        L["Encounter-50757"] = [[观察者奥尔加隆]]
    elseif Private.IsClassicEra then
        L["Difficulty-3"] = "HL1"
        L["Difficulty-4"] = "HL2"
        L["Difficulty-5"] = "HL3"
        L["Encounter-100663"] = [[鲁西弗隆]]
        L["Encounter-100664"] = [[玛格曼达]]
        L["Encounter-100665"] = [[基赫纳斯]]
        L["Encounter-100666"] = [[加尔]]
        L["Encounter-100667"] = [[沙斯拉尔]]
        L["Encounter-100668"] = [[迦顿男爵]]
        L["Encounter-100669"] = [[萨弗隆先驱者]]
        L["Encounter-100670"] = [[焚化者古雷曼格]]
        L["Encounter-100671"] = [[管理者埃克索图斯]]
        L["Encounter-100672"] = [[拉格纳罗斯]]
        L["Encounter-3018"] = [[熔火之心]]
    end
elseif locale == "zhTW" then
    L["Difficulty-1"] = "隨團"
    L["Difficulty-3"] = "普通"
    L["Difficulty-4"] = "英雄"
    L["Difficulty-5"] = "傳奇"
    L["AllStars"] = "全明星"
    L["Rank"] = "階級"
    L["Unknown"] = [[Unknown]]
    L["UnknownRealm"] = [[[%s] Realm '%s' (id %d) not in database. Please report to the Warcraft Logs team.]]
    L["CopyProfileURL"] = [[Copy WCL URL]]
    L["Subscriber"] = [[Subscriber]]
    L["ShiftToExpand"] = [[<Shift> to Expand]]
    L["SubAddonMissing"] = [[[%s] Database for '%s' is missing. Please reinstall the addon or make sure it is up to date.]]
    L["DBLoadError"] = [[[%s] Could not load database for '%s'. Reason: %s]]

    if Private.IsCata then
        L["Encounter-1035"] = [[Conclave of Wind]]
        L["Encounter-1034"] = [[Al'Akir]]
        L["Encounter-1027"] = [[Omnotron Defense System]]
        L["Encounter-1024"] = [[Magmaw]]
        L["Encounter-1022"] = [[Atramedes]]
        L["Encounter-1023"] = [[Chimaeron]]
        L["Encounter-1025"] = [[Maloriak]]
        L["Encounter-1026"] = [[Nefarian's End]]
        L["Encounter-1030"] = [[Halfus Wyrmbreaker]]
        L["Encounter-1032"] = [[Theralion and Valiona]]
        L["Encounter-1028"] = [[Ascendant Council]]
        L["Encounter-1029"] = [[Cho'gall]]
        L["Encounter-1082"] = [[Sinestra]]
    elseif Private.IsWrath then
        L["Encounter-50744"] = [[Flame Leviathan]]
        L["Encounter-50745"] = [[Ignis the Furnace Master]]
        L["Encounter-50746"] = [[Razorscale]]
        L["Encounter-50747"] = [[XT-002 Deconstructor]]
        L["Encounter-50748"] = [[The Iron Council]]
        L["Encounter-50749"] = [[Kologarn]]
        L["Encounter-50750"] = [[Auriaya]]
        L["Encounter-50751"] = [[Hodir]]
        L["Encounter-50752"] = [[Thorim]]
        L["Encounter-50753"] = [[Freya]]
        L["Encounter-50754"] = [[Mimiron]]
        L["Encounter-50755"] = [[General Vezax]]
        L["Encounter-50756"] = [[Yogg-Saron]]
        L["Encounter-50757"] = [[Algalon the Observer]]
    elseif Private.IsClassicEra then
        L["Difficulty-3"] = "HL1"
        L["Difficulty-4"] = "HL2"
        L["Difficulty-5"] = "HL3"
        L["Encounter-100663"] = [[Lucifron]]
        L["Encounter-100664"] = [[Magmadar]]
        L["Encounter-100665"] = [[Gehennas]]
        L["Encounter-100666"] = [[Garr]]
        L["Encounter-100667"] = [[Shazzrah]]
        L["Encounter-100668"] = [[Baron Geddon]]
        L["Encounter-100669"] = [[Sulfuron Harbinger]]
        L["Encounter-100670"] = [[Golemagg the Incinerator]]
        L["Encounter-100671"] = [[Majordomo Executus]]
        L["Encounter-100672"] = [[Ragnaros]]
        L["Encounter-3018"] = [[The Molten Core]]
    end
end
