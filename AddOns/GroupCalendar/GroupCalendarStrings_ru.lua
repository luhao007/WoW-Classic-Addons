if GetLocale() == "ruRU" then
	-- Russian localized variables
	GroupCalendar_cTitle = "Group Calendar v%s";

	GroupCalendar_cSun = "ВС";
	GroupCalendar_cMon = "ПН";
	GroupCalendar_cTue = "ВТ";
	GroupCalendar_cWed = "СР";
	GroupCalendar_cThu = "ЧТ";
	GroupCalendar_cFri = "ПТ";
	GroupCalendar_cSat = "СБ";

	GroupCalendar_cSunday = "Воскресенье";
	GroupCalendar_cMonday = "Понедельник";
	GroupCalendar_cTuesday = "Вторник";
	GroupCalendar_cWednesday = "Среда";
	GroupCalendar_cThursday = "Четверг";
	GroupCalendar_cFriday = "Пятница";
	GroupCalendar_cSaturday = "Суббота";

	GroupCalendar_Settings_ShowDebug = "Показать отладочные сообщения";
	GroupCalendar_Settings_ShowDebugTip = "Показать отладочные сообщения";
	GroupCalendar_Settings_ShowMinimap = "Показать миникарту";
	GroupCalendar_Settings_ShowMinimapTip = "Показать миникарту";
	GroupCalendar_Settings_MondayFirstDay = "Понедельник первый день недели";
	GroupCalendar_Settings_MondayFirstDayTip = "Понедельник первый день недели";
	GroupCalendar_Settings_Use24HrTime = "Используйте 24-часовое время";
	GroupCalendar_Settings_Use24HrTimeTip = "Используйте 24-часовое время";

	GroupCalendar_cSelfWillAttend = "Присутствовавший";
	CalendarEventEditor_cYes = "да";
	CalendarEventEditor_cNo = "нет";

	GroupCalendar_cMonthNames = {"Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"};
	GroupCalendar_cDayOfWeekNames = {GroupCalendar_cSunday, GroupCalendar_cMonday, GroupCalendar_cTuesday, GroupCalendar_cWednesday, GroupCalendar_cThursday, GroupCalendar_cFriday, GroupCalendar_cSaturday};

	GroupCalendar_cLoadMessage = "Group Calendar загружен.  Введите /calendar для просмотра календаря";
	GroupCalendar_cInitializingGuilded = "Group Calendar: Инициализация настроек гильдии игрока";
	GroupCalendar_cInitializingUnguilded = "Group Calendar: Инициализация настроек игрока без гильдии";
	GroupCalendar_cLocalTimeNote = "(%s local)";

	GroupCalendar_cOptions = "Настройка...";

	GroupCalendar_cCalendar = "Календарь";
	GroupCalendar_cChannel = "Канал";
	GroupCalendar_cTrust = "Доступ";
	GroupCalendar_cAbout = "Об аддоне";

	GroupCalendar_cUseServerDateTime = "Использовать время сервера";
	GroupCalendar_cUseServerDateTimeDescription = "Включите, чтобы показать события, используя дату и время сервера, выключите, чтобы использовать местную дату и время";
		
	GroupCalendar_cChannelStatus =
	{
		Starting = {mText = "Статус: запуск", mColor = {r = 1, g = 1, b = 0.3}},
		Synching = {mText = "Статус: синхронизирующий", mColor = {r = 0.3, g = 1, b = 0.3}},
		Connected = {mText = "Статус: Связанный", mColor = {r = 0.3, g = 1, b = 0.3}},
		Disconnected = {mText = "Статус: разъединенный", mColor = {r = 1, g = 0.5, b = 0.2}},
		Initializing = {mText = "Статус: Инициализация", mColor = {r = 1, g = 1, b = 0.3}},
		Error = {mText = "Error: %s", mColor = {r = 1, g = 0.2, b = 0.4}},
	};

	GroupCalendar_cConnected = "Подключение";
	GroupCalendar_cDisconnected = "Отключение";
	GroupCalendar_cTooManyChannels = "Вы уже подключились к максимальному количеству каналов";
	GroupCalendar_cJoinChannelFailed = "Не удалось подключиться к каналу по неизвестной причине";
	GroupCalendar_cWrongPassword = "Неверный пароль";
	GroupCalendar_cAutoConfigNotFound = "Параметры настройки не найдены в списке гильдии";
	GroupCalendar_cErrorAccessingNote = "Не удалось получить настройки";

	GroupCalendar_cTrustConfigTitle = "Настройки доступа";
	GroupCalendar_cTrustConfigDescription = "Настройки доступа определяеют, кто может создавать события. Только глава гильдии может изменять эти настройки.";
	GroupCalendar_cTrustGroupLabel = "Доступ:";
	GroupCalendar_cEvent = "Событие";
	GroupCalendar_cAttendance = "Посещаемость";

	GroupCalendar_cAboutTitle = "О Group Calendar";
	GroupCalendar_cTitleVersion = "Group Calendar v"..gGroupCalendar_VersionString;
	GroupCalendar_cAuthor = "Автор классической версии: Magne - Remulos".."\n".."Автор ванильной версии: Baylord - Thunderlord";
	GroupCalendar_cTestersTitle = "Тестеры:";
	GroupCalendar_cSpecialThanksTitle = "Специальная благодарность:";

	GroupCalendar_cRebuildDatabase = "Восстановить базу данных";
	GroupCalendar_cRebuildDatabaseDescription = "Перестроить базу данных событий для вашего персонажа. Это может решить проблемы людей, не видящих все ваши события, но есть небольшой риск, что некоторые ответы на посещение событий могут быть потеряны.";

	GroupCalendar_cTrustGroups =
	{
		"Все, у кого есть доступ к каналу",
		"Другие члены вашей гильдии",
		"Только те, кто перечислен ниже"
	};

	GroupCalendar_cTrustAnyone = "Доступ для всех, кто имеет доступ к каналу данных";
	GroupCalendar_cTrustGuildies = "Доступ другим членам вашей гильдии";
	GroupCalendar_cTrustMinRank = "Минимальное звание:";
	GroupCalendar_cTrustNobody = "Доступ только тем, кто указан ниже";
	GroupCalendar_cTrustedPlayers = "Добавленные игроки";
	GroupCalendar_cExcludedPlayers = "Исключенные игроки"
	GroupCalendar_cPlayerName = "Имя игрока:";
	GroupCalendar_cAddTrusted = "Добавить";
	GroupCalendar_cRemoveTrusted = "Удалить";
	GroupCalendar_cAddExcluded = "Исключить";

	CalendarEventViewer_cTitle = "Посмотреть событие";
	CalendarEventViewer_cDone = "Готово";

	CalendarEventViewer_cLevelRangeFormat = "Уровни %i до %i";
	CalendarEventViewer_cMinLevelFormat = "Уровни %i и выше";
	CalendarEventViewer_cMaxLevelFormat = "До уровня %i";
	CalendarEventViewer_cAllLevels = "Все уровни";
	CalendarEventViewer_cSingleLevel = "Только уровень %i";

	CalendarEventViewer_cYes = "Да! Я буду присутствовать на этом событии";
	CalendarEventViewer_cNo = "Нет, я не буду присутствовать на этом событии";

	CalendarEventViewer_cResponseMessage =
	{
		"Статус: Ответ не отправлен",
		"Статус: Ожидание подтверждения",
		"Статус: Подтверждено - Принят",
		"Статус: Подтверждено - В режиме ожидания",
		"Статус: Подтверждено - Не присутствует",
		"Статус: Забанен на мероприятии",
	};

	CalendarEventEditorFrame_cTitle = "Добавить/Изменить событие";
	CalendarEventEditor_cDone = "Готово";
	CalendarEventEditor_cDelete = "Удалить";
	CalendarEventEditor_cGroupTabTitle = "Группа";

	CalendarEventEditor_cConfirmDeleteMsg = "Удалить \"%s\"?";

	-- Event names

	GroupCalendar_cGeneralEventGroup = "Общие";
	GroupCalendar_cRaidEventGroup = "Рейды";
	GroupCalendar_cDungeonEventGroup = "Подземелья";
	GroupCalendar_cBattlegroundEventGroup = "PvP";

	GroupCalendar_cMeetingEventName = "Встреча";
	GroupCalendar_cBirthdayEventName = "Квестинг";
	GroupCalendar_cRoleplayEventName = "Ролевая игра";
	GroupCalendar_cActivityEventName = "мероприятие";

	GroupCalendar_cAQREventName = "Руины Ан'Киража";
	GroupCalendar_cAQTEventName = "Храм Ан'Киража";
	GroupCalendar_cBFDEventName = "Непроглядная Пучина";
	GroupCalendar_cBRDEventName = "Глубины Черной горы (ГЧГ / BRD)";
	GroupCalendar_cUBRSEventName = "Вершина Черной горы - Верх (UBRS)";
	GroupCalendar_cLBRSEventName = "Вершина Черной горы - Низ (LBRS)";
	GroupCalendar_cBWLEventName = "Логово Крыла Тьмы (BWL)";
	GroupCalendar_cDeadminesEventName = "Мертвые копи";
	GroupCalendar_cDMEventName = "Забытый Город";
	GroupCalendar_cGnomerEventName = "Гномреган";
	GroupCalendar_cMaraEventName = "Мародон";
	GroupCalendar_cMCEventName = "Огненные Недра";
	GroupCalendar_cOnyxiaEventName = "Логово Ониксии";
	GroupCalendar_cRFCEventName = "Огненная пропасть";
	GroupCalendar_cRFDEventName = "Курганы Иглошкурых";
	GroupCalendar_cRFKEventName = "Лабиринты Иглошкурых";
	GroupCalendar_cSMEventName = "Монастырь Алого ордена";
	GroupCalendar_cScholoEventName = "Некроситет";
	GroupCalendar_cSFKEventName = "Крепость Темного Клыка";
	GroupCalendar_cStockadesEventName = "Тюрьма";
	GroupCalendar_cStrathEventName = "Стратхольм";
	GroupCalendar_cSTEventName = "Затонувший храм";
	GroupCalendar_cUldEventName = "Ульдаман";
	GroupCalendar_cWCEventName = "Пещеры Стенаний";
	GroupCalendar_cZFEventName = "Зул'Фаррак";
	GroupCalendar_cZGEventName = "Зул'Гуруб";
	GroupCalendar_cNaxxEventName = "Наксрамас";

	GroupCalendar_cPvPEventName = "Мировое PvP";
	GroupCalendar_cABEventName = "Низина Арати";
	GroupCalendar_cAVEventName = "Альтеракская долина";
	GroupCalendar_cWSGEventName = "Ущелье Песни Войны";

	GroupCalendar_cZGResetEventName = "Сброс Зул'Гуруб";
	GroupCalendar_cMCResetEventName = "СбросОгненные Недра";
	GroupCalendar_cOnyxiaResetEventName = "Сброс Логово Ониксии";
	GroupCalendar_cBWLResetEventName = "Сброс Логово Крыла Тьмы";
	GroupCalendar_cAQRResetEventName = "Сброс Руины Ан'Киража";
	GroupCalendar_cAQTResetEventName = "Сброс Храм Ан'Киража";
	GroupCalendar_cNaxxResetEventName = "Сброс Наксрамас";

	GroupCalendar_cTransmuteCooldownEventName = "Transmute Available";
	GroupCalendar_cSaltShakerCooldownEventName = "Salt Shaker Available";
	GroupCalendar_cMoonclothCooldownEventName = "Mooncloth Available";
	GroupCalendar_cSnowmasterCooldownEventName = "SnowMaster 9000 Available";

	GroupCalendar_cPersonalEventOwner = "Частный";

	GroupCalendar_cRaidInfoMCName = GroupCalendar_cMCEventName;
	GroupCalendar_cRaidInfoOnyxiaName = GroupCalendar_cOnyxiaEventName;
	GroupCalendar_cRaidInfoZGName = GroupCalendar_cZGEventName;
	GroupCalendar_cRaidInfoBWLName = GroupCalendar_cBWLEventName;
	GroupCalendar_cRaidInfoAQRName = GroupCalendar_cAQREventName;
	GroupCalendar_cRaidInfoAQTName = GroupCalendar_cAQTEventName;
	GroupCalendar_cRaidInfoNaxxName = GroupCalendar_cNaxxEventName;

	-- Race names

	GroupCalendar_cDwarfRaceName = "Дворф";
	GroupCalendar_cGnomeRaceName = "Гном";
	GroupCalendar_cHumanRaceName = "Человек";
	GroupCalendar_cNightElfRaceName = "Ночной эльф";
	GroupCalendar_cOrcRaceName = "Орк";
	GroupCalendar_cTaurenRaceName = "Таурен";
	GroupCalendar_cTrollRaceName = "Тролль";
	GroupCalendar_cUndeadRaceName = "Нежить";
	GroupCalendar_cBloodElfRaceName = "Эльф крови";
	GroupCalendar_cDraeneiRaceName = "Дренеи";

	-- Class names

	GroupCalendar_cDruidClassName = "Друид";
	GroupCalendar_cHunterClassName = "Охотник";
	GroupCalendar_cMageClassName = "Маг";
	GroupCalendar_cPaladinClassName = "Паладин";
	GroupCalendar_cPriestClassName = "Жрец";
	GroupCalendar_cRogueClassName = "Разбойник";
	GroupCalendar_cShamanClassName = "Шаман";
	GroupCalendar_cWarlockClassName = "Чернокнижник";
	GroupCalendar_cWarriorClassName = "Воин";

	-- Plural forms of class names

	GroupCalendar_cDruidsClassName = "Друиды";
	GroupCalendar_cHuntersClassName = "Охотники";
	GroupCalendar_cMagesClassName = "Маги";
	GroupCalendar_cPaladinsClassName = "Паладины";
	GroupCalendar_cPriestsClassName = "Жрецы";
	GroupCalendar_cRoguesClassName = "Разбойники";
	GroupCalendar_cShamansClassName = "Шаманы";
	GroupCalendar_cWarlocksClassName = "Чернокнижники";
	GroupCalendar_cWarriorsClassName = "Воины";

	-- ClassColorNames are the indices for the RAID_CLASS_COLORS array found in FrameXML\Fonts.xml
	-- in the English version of WoW these are simply the class names in caps, I don't know if that's
	-- true of other languages so I'm putting them here in case they need to be localized

	GroupCalendar_cDruidClassColorName = "DRUID";
	GroupCalendar_cHunterClassColorName = "HUNTER";
	GroupCalendar_cMageClassColorName = "MAGE";
	GroupCalendar_cPaladinClassColorName = "PALADIN";
	GroupCalendar_cPriestClassColorName = "PRIEST";
	GroupCalendar_cRogueClassColorName = "ROGUE";
	GroupCalendar_cShamanClassColorName = "SHAMAN";
	GroupCalendar_cWarlockClassColorName = "WARLOCK";
	GroupCalendar_cWarriorClassColorName = "WARRIOR";

	-- Label forms of the class names for the attendance panel.  Usually just the plural
	-- form of the name followed by a colon

	GroupCalendar_cDruidsLabel = GroupCalendar_cDruidsClassName..":";
	GroupCalendar_cHuntersLabel = GroupCalendar_cHuntersClassName..":";
	GroupCalendar_cMagesLabel = GroupCalendar_cMagesClassName..":";
	GroupCalendar_cPaladinsLabel = GroupCalendar_cPaladinsClassName..":";
	GroupCalendar_cPriestsLabel = GroupCalendar_cPriestsClassName..":";
	GroupCalendar_cRoguesLabel = GroupCalendar_cRoguesClassName..":";
	GroupCalendar_cShamansLabel = GroupCalendar_cShamansClassName..":";
	GroupCalendar_cWarlocksLabel = GroupCalendar_cWarlocksClassName..":";
	GroupCalendar_cWarriorsLabel = GroupCalendar_cWarriorsClassName..":";

	GroupCalendar_cTimeLabel = "Время:";
	GroupCalendar_cDurationLabel = "Длительность:";
	GroupCalendar_cEventLabel = "Событие:";
	GroupCalendar_cTitleLabel = "Название:";
	GroupCalendar_cLevelsLabel = "Уровни:";
	GroupCalendar_cLevelRangeSeparator = "по";
	GroupCalendar_cDescriptionLabel = "Описание:";
	GroupCalendar_cCommentLabel = "Комментарий:";

	CalendarEditor_cNewEvent = "Новое событие...";
	CalendarEditor_cEventsTitle = "События";

	CalendarEventEditor_cNotTrustedMsg = "Не удается создать события из-за настроек доверия";
	CalendarEventEditor_cOk = "Хорошо";

	CalendarEventEditor_cNotAttending = "Не посещает";
	CalendarEventEditor_cConfirmed = "Подтверждено";
	CalendarEventEditor_cDeclined = "Отклонено";
	CalendarEventEditor_cStandby = "В листе ожидания";
	CalendarEventEditor_cPending = "Ожидается";
	CalendarEventEditor_cUnknownStatus = "Неизвестно %s";

	GroupCalendar_cChannelNameLabel = "Название канала:";
	GroupCalendar_cPasswordLabel = "Пароль:";

	GroupCalendar_cTimeRangeFormat = "%s до %s";

	GroupCalendar_cPluralMinutesFormat = "%d минут";
	GroupCalendar_cSingularHourFormat = "%d час";
	GroupCalendar_cPluralHourFormat = "%d часа";
	GroupCalendar_cSingularHourPluralMinutes = "%d час %d минут";
	GroupCalendar_cPluralHourPluralMinutes = "%d часа %d минут";

	if string.sub(GetLocale(), -2) == "US" then
		GroupCalendar_cLongDateFormat = "$month $day, $year";
		GroupCalendar_cShortDateFormat = "$monthNum/$day";
		GroupCalendar_cLongDateFormatWithDayOfWeek = "$dow $month $day, $year";
	else
		GroupCalendar_cLongDateFormat = "$day. $month $year";
		GroupCalendar_cShortDateFormat = "$day.$monthNum";
		GroupCalendar_cLongDateFormatWithDayOfWeek = "$dow $day. $month $year";
	end

	GroupCalendar_cNotAttending = "Не посещает";
	GroupCalendar_cAttending = "Посещает";
	GroupCalendar_cPendingApproval = "Ожидающие запросы и изменения";
	GroupCalendar_cStandby = "Ожидание";
	GroupCalendar_Queued = "Обработка";
	GroupCalendar_cWhispers = "Последние сообщения";

	--GroupCalendar_cQuestAttendanceNameFormat = "$name ($role $level $race)";
	--GroupCalendar_cMeetingAttendanceNameFormat = "$name ($role $level $class)";
	--GroupCalendar_cGroupAttendanceNameFormat = "$name - $role ($status)";

	GroupCalendar_cNumAttendeesFormat = "участников: %d ";
	GroupCalendar_cNumPlayersFormat = "игроков: %d";

	BINDING_HEADER_GROUPCALENDAR_TITLE = "Group Calendar";
	BINDING_NAME_GROUPCALENDAR_TOGGLE = "Переключить GroupCalendar";

	-- Tradeskill cooldown items

	GroupCalendar_cHerbalismSkillName = "Травничество";
	GroupCalendar_cAlchemySkillName = "Алхимия";
	GroupCalendar_cEnchantingSkillName = "Зачарование";
	GroupCalendar_cLeatherworkingSkillName = "Кожевничество";
	GroupCalendar_cSkinningSkillName = "Снятие шкур";
	GroupCalendar_cTailoringSkillName = "Портняжное дело";
	GroupCalendar_cMiningSkillName = "Горное дело";
	GroupCalendar_cBlacksmithingSkillName = "Кузнечное дело";
	GroupCalendar_cEngineeringSkillName = "Инженерное дело";

	GroupCalendar_cTransmuteMithrilToTruesilver = "Трансмутация: Мифрила в Истинное серебро";
	GroupCalendar_cTransmuteIronToGold = "Трансмутация: Железа в Золото";
	GroupCalendar_cTransmuteLifeToEarth = "Трансмутация: Жизни в Землю";
	GroupCalendar_cTransmuteWaterToUndeath = "Трансмутация: Воды в Нежить";
	GroupCalendar_cTransmuteWaterToAir = "Трансмутация: Воды в Воздух";
	GroupCalendar_cTransmuteUndeathToWater = "Трансмутация: Нежити в Воду";
	GroupCalendar_cTransmuteFireToEarth = "Трансмутация: Огня в Землю";
	GroupCalendar_cTransmuteEarthToLife = "Трансмутация: Земли в Жизнь";
	GroupCalendar_cTransmuteEarthToWater = "Трансмутация: Земли в Воду";
	GroupCalendar_cTransmuteAirToFire = "Трансмутация: Воздуха в Огонь";
	GroupCalendar_cTransmuteArcanite = "Трансмутация: Арканит";
	GroupCalendar_cMooncloth = "Луноткань";

	GroupCalendar_cCharactersLabel = "Персонаж:";
	GroupCalendar_cRoleLabel = "Роль:";
	GroupCalendar_cTankLabel = "Танк";
	GroupCalendar_cHealerLabel = "Лекарь";
	GroupCalendar_cDpsLabel = "Боец";
	GroupCalendar_cUnknownRoleLabel = "Неизвестно";

	GroupCalendar_cTanksLabel = "Танки:";
	GroupCalendar_cHealersLabel = "Лекари:";
	GroupCalendar_cDpssLabel = "Бойцы:";
	GroupCalendar_cUnknownsRoleLabel = "Неизвестно:";

	GroupCalendar_cConfirmed = "Принято";
	GroupCalendar_cStandby = "Ожидание";
	GroupCalendar_cDeclined = "Отклонено";
	GroupCalendar_cRemove = "Удалить";
	GroupCalendar_cEditPlayer = "Изменить игрока...";
	GroupCalendar_cInviteNow = "Пригласить в группу";
	GroupCalendar_cStatus = "Статус";
	GroupCalendar_cAddPlayerEllipses = "Добавить игрока...";
	GroupCalendar_cAll = "Bce";
	GroupCalendar_cClearSelected = "Очистить выбранное";

	GroupCalendar_cAddPlayer = "Добавить игрока";
	GroupCalendar_cPlayerLevel = "Уровень:";
	GroupCalendar_cPlayerClassLabel = "Класс:";
	GroupCalendar_cPlayerRaceLabel = "Раса:";
	GroupCalendar_cPlayerStatusLabel = "Статус:";
	GroupCalendar_cRankLabel = "Звание гильдии:";
	GroupCalendar_cGuildLabel = "Гильдия:";
	GroupCalendar_cSave = "Сохранить";
	GroupCalendar_cLastWhisper = "Последние сообщения:";
	GroupCalendar_cReplyWhisper = "Ответ на сообщения:";

	GroupCalendar_cUnknown = "Неизвестно";
	GroupCalendar_cAutoConfirmationTitle = "Автоматическое подтверждение";
	GroupCalendar_cEnableAutoConfirm = "Вкл. авто подтверждение";
	GroupCalendar_cMinLabel = "мин";
	GroupCalendar_cMaxLabel = "макс";

	GroupCalendar_cAddPlayerTitle = "Добавить...";
	GroupCalendar_cAutoConfirmButtonTitle = "Настройки...";

	GroupCalendar_cClassLimitDescription = "Используйте поля ниже, чтобы установить минимальное и максимальное количество каждого класса. Классы, которые еще не достигли минимума, будут заполнены первыми, дополнительные места будут заполняться в порядке ответов, пока не будут достигнуты максимумы.";

	GroupCalendar_cViewByDate = "Просмотр по Дате";
	GroupCalendar_cViewByRank = "Просмотр по Званию";
	GroupCalendar_cViewByName = "Просмотр по Имени";
	GroupCalendar_cViewByStatus = "Просмотр по Статусу";
	GroupCalendar_cViewByClass = "Просмотр по Классу";
	GroupCalendar_cViewByClassRank = "Просмотр по Классу и Званию";

	GroupCalendar_cMaxPartySizeLabel = "Максимальный размер группы:";
	GroupCalendar_cMinPartySizeLabel = "Минимальный размер группы:";
	GroupCalendar_cNoMinimum = "Нет минимума";
	GroupCalendar_cNoMaximum = "Нет максимума";
	GroupCalendar_cPartySizeFormat = "%d игроки";

	GroupCalendar_cInviteButtonTitle = "Пригласить выбранных";
	GroupCalendar_cAutoSelectButtonTitle = "Выбрать игроков...";
	GroupCalendar_cAutoSelectWindowTitle = "Выбрать игроков";

	GroupCalendar_cNoSelection = "Нет выбранных игроков";
	GroupCalendar_cSingleSelection = "1 игроков выбрано";
	GroupCalendar_cMultiSelection = "%d игроков выбрано";

	GroupCalendar_cInviteNeedSelectionStatus = "Выберите игроков для приглашения";
	GroupCalendar_cInviteReadyStatus = "Готовность к приглашению";
	GroupCalendar_cInviteInitialInvitesStatus = "Отправка первоначальных приглашений";
	GroupCalendar_cInviteAwaitingAcceptanceStatus = "Ожидание первоначального принятия";
	GroupCalendar_cInviteConvertingToRaidStatus = "Преобразование в рейд";
	GroupCalendar_cInviteInvitingStatus = "Отправка приглашений";
	GroupCalendar_cInviteCompleteStatus = "Приглашения завершены";
	GroupCalendar_cInviteReadyToRefillStatus = "Готовы заполнить свободные места";
	GroupCalendar_cInviteNoMoreAvailableStatus = "Нет игроков, доступных для заполнения группы";
	GroupCalendar_cRaidFull = "Рейд заполнен";

	GroupCalendar_cInviteWhisperFormat = "[Group Calendar] Вас приглашают на мероприятие '%s'.";
	GroupCalendar_cAlreadyGroupedWhisper = "[Group Calendar] Вы уже в группе. Напишите /w когда покинете группу.";
	GroupCalendar_cAlreadyGroupedSysMsg = "(.+) уже в группе";
	GroupCalendar_cInviteDeclinedSysMsg = "(.+) отклоняет приглашение в групу.";
	GroupCalendar_cNoSuchPlayerSysMsg = "Ни один игрок по имени '(.+)' в настоящее время не играет.";

	GroupCalendar_cJoinedGroupStatus = "Присоединился";
	GropuCalendar_cInvitedGroupStatus = "Приглашен";
	GropuCalendar_cReadyGroupStatus = "Готов";
	GroupCalendar_cGroupedGroupStatus = "В другой группе";
	GroupCalendar_cStandbyGroupStatus = "Ожидание";
	GroupCalendar_cDeclinedGroupStatus = "Приглашение отклонено";
	GroupCalendar_cOfflineGroupStatus = "Не в сети";
	GroupCalendar_cLeftGroupStatus = "Покинул группу";

	GroupCalendar_cPriorityLabel = "Приоритет:";
	GroupCalendar_cPriorityDate = "Дата";
	GroupCalendar_cPriorityRank = "Звание";
	GroupCalendar_cPriorityClass = "Класс";

	GroupCalendar_cConfrimDeleteRSVP = "Удалить %s из этого события? Они не смогут присоединиться снова, если вы не добавите их обратно вручную.";

	GroupCalendar_cConfirmSelfUpdateMsg = "%s";
	GroupCalendar_cConfirmSelfUpdateParamFormat = "Более новая копия событий для $mUserName доступна от $mSender.  Хотите обновить свои события до более новой версии? После обновления все события, которые вы добавили или изменили после входа в систему, будут потеряны.";
	GroupCalendar_cConfirmSelfRSVPUpdateParamFormat = "Более новая копия запросов о посещаемости для %mUserName доступна от $mSender.  Хотите обновить ваши запросы посещаемости до более новой версии? После обновления данных, все неподтвержденные изменения, внесенные вами после входа, будут потеряны.";
	GroupCalendar_cUpdate = "Обновить";

	GroupCalendar_cConfirmClearWhispers = "Очистить все недавние сообщения?";
	GroupCalendar_cClear = "Очистить";

	CalendarDatabases_cTitle = "Версии Group Calendar";
	CalendarDatabases_cRefresh = "Обновить";
	CalendarDatabases_cRefreshDescription = "Предлагает игрокам онлайн прислать свои номера версий.  Обновление номеров версий может занять несколько минут.  Обновления, полученные когда это окно закрыто, все равно будут записаны и могут быть просмотрены позже.";

	GroupCalendar_cVersionFormat = "Group Calendar v%s";
	GroupCalendar_cShortVersionFormat = "v%s";
	GroupCalendar_cVersionUpdatedFormat = "по состоянию на %s %s (local time)";
	GroupCalendar_cVersionUpdatedUnknown = "Дата последнего просмотра информации о версии неизвестна";

	GroupCalendar_cToggleVersionsTitle = "Показать версию игрока";
	GroupCalendar_cToggleVersionsDescription = "Показывает, какая версия Group Calendar запущена другими игроками";

	GroupCalendar_cChangesDelayedMessage = "Group Calendar: Изменения, внесенные при синхронизации с сетью, не будут отправлены до завершения синхронизации.";

	GroupCalendar_cConfirmKillMsg = "Вы уверены, что хотите убрать события из %s из сети?"; 
	GroupCalendar_cKill = "Kill";

	GroupCalendar_cNotAnOfficerError = "GroupCalendar: Только офицеры гильдии не могут этого делать";
	GroupCalendar_cUserNameExpected = "GroupCalendar: Ожидание имени пользователя";
	GroupCalendar_cDatabaseNotFoundError = "GroupCalendar: База данных для %s не найдена.";
	GroupCalendar_cCantKillGuildieError = "GroupCalendar: Нельзя удалить пользователя, который находится в вашей гильдии";

end
