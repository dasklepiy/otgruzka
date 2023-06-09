﻿////////// ОБЩИЕ КОМАНДЫ ВСЕХ ОБРАБОТЧИКОВ //////////////

// Функция осуществляет подключение устройства.
//
// Параметры:
//  ОбъектДрайвера   - <*>
//           - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;
	ПараметрыПодключения.Вставить("ИДУстройства", "");

	ВыходныеПараметры = Новый Массив();

	// Проверка параметров устройства
	Порт                       = Неопределено;
	Скорость                   = Неопределено;
	Таймаут                    = Неопределено;
	ПарольККМ                  = Неопределено;
	НомерСекции                = Неопределено;
	КодСимволаЧастичногоОтреза = Неопределено;

	Параметры.Свойство("Порт"                      , Порт);
	Параметры.Свойство("Скорость"                  , Скорость);
	Параметры.Свойство("Таймаут"                   , Таймаут);
	Параметры.Свойство("ПарольККМ"                 , ПарольККМ);
	Параметры.Свойство("НомерСекции"               , НомерСекции);
	Параметры.Свойство("КодСимволаЧастичногоОтреза", КодСимволаЧастичногоОтреза);

	Если Порт                       = Неопределено
	 Или Скорость                   = Неопределено
	 Или Таймаут                    = Неопределено
	 Или ПарольККМ                  = Неопределено
	 Или НомерСекции                = Неопределено
	 Или КодСимволаЧастичногоОтреза = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.
		|Сделать это можно при помощи формы ""Настройка параметров"" модели
		|подключаемого оборудования в форме ""Подключение и настройка оборудования"".'"));

		Результат = Ложь;
	КонецЕсли;

	Если Результат Тогда
		МассивЗначений = Новый Массив;
		МассивЗначений.Добавить(Параметры.Порт);
		МассивЗначений.Добавить(Параметры.Скорость);
		МассивЗначений.Добавить(Параметры.ПарольККМ);
		МассивЗначений.Добавить(Параметры.ПарольККМ);
		МассивЗначений.Добавить(Параметры.Таймаут);

		Если НЕ ОбъектДрайвера.Подключить(МассивЗначений, ПараметрыПодключения.ИДУстройства) Тогда
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - <*>
//         - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Ложь;

	ВыходныеПараметры = Новый Массив();

	Если НЕ ОбъектДрайвера.Отключить(ПараметрыПодключения.ИДУстройства) Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
	Иначе
		Результат = Истина;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Открыть смену
	Если Команда = "OpenDay" Тогда
		Результат = ОткрытьСмену(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Печать чека
	ИначеЕсли Команда = "PrintReceipt" Тогда
		ТаблицаНоменклатуры = ВходныеПараметры[0];
		ТаблицаОплат        = ВходныеПараметры[1];
		ОбщиеПараметры      = ВходныеПараметры[2];

		Результат = ПечатьЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаНоменклатуры,
		                       ТаблицаОплат, ОбщиеПараметры, ВыходныеПараметры);

	// Печать слип чека
	ИначеЕсли Команда = "PrintText" Тогда
		СтрокаТекста   = ВходныеПараметры[0];

		Результат = ПечатьТекста(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                         СтрокаТекста, ВыходныеПараметры);

	// Печать чека внесения/выемки
	ИначеЕсли Команда = "Encash" Тогда
		ТипИнкассации = ВходныеПараметры[0];
		Сумма         = ВходныеПараметры[1];

		Результат = Инкассация(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипИнкассации, Сумма, ВыходныеПараметры);

	// Печать отчета без гашения
	ИначеЕсли Команда = "PrintXReport" Тогда
		Результат = НапечататьОтчетБезГашения(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Печать отчета с гашением
	ИначеЕсли Команда = "PrintZReport" Тогда
		Результат = НапечататьОтчетСГашением(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Тестирование устройства
	ИначеЕсли Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Указанная команда не поддерживается данным драйвером
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		Результат = Ложь;

	КонецЕсли;

	Возврат Результат;

КонецФункции


/////////////////////////////////////
// Функции-исполнители команд

///////// СПЕЦИФИЧНЫЕ ПО ТИПУ ОБОРУДОВАНИЯ КОМАНДЫ ////////////////

// Функция осуществляет открытие смены
Функция ОткрытьСмену(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	// Заполнение выходных параметров
	ВыходныеПараметры.Добавить(0);
	ВыходныеПараметры.Добавить(0);
	ВыходныеПараметры.Добавить(0);
	ВыходныеПараметры.Добавить(ТекущаяДата());

	Возврат Результат;

КонецФункции


// Осуществляет печать фискального чека
Функция ПечатьЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаНоменклатуры,
                       ТаблицаОплат, ОбщиеПараметры, ВыходныеПараметры)

	Результат  = Истина;

	// Открываем чек
	Результат = ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения,
	                       ОбщиеПараметры[0] = 1, ОбщиеПараметры[1], ВыходныеПараметры);

	// Печатаем строки чека
	Если Результат Тогда
		Для ИндексМассива = 0 По ТаблицаНоменклатуры.Количество() - 1 Цикл
			Наименование  = ТаблицаНоменклатуры[ИндексМассива][0].Значение;
			Количество    = ТаблицаНоменклатуры[ИндексМассива][5].Значение;
			Цена          = ТаблицаНоменклатуры[ИндексМассива][4].Значение;
			ПроцентСкидки = ТаблицаНоменклатуры[ИндексМассива][8].Значение;
			Сумма         = ТаблицаНоменклатуры[ИндексМассива][9].Значение;
			НомерСекции   = ТаблицаНоменклатуры[ИндексМассива][3].Значение;
			СтавкаНДС     = ТаблицаНоменклатуры[ИндексМассива][12].Значение;

			Если НЕ НапечататьФискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
			                                   Наименование, Количество, Цена, ПроцентСкидки, Сумма,
			                                   НомерСекции, СтавкаНДС, ВыходныеПараметры) Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	// Закрываем чек
	Если Результат Тогда
		Результат = ЗакрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаОплат, ВыходныеПараметры);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Осуществляет печать слип-чека
Функция ПечатьТекста(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                       СтрокаТекста, ВыходныеПараметры)

	Результат  = Истина;

	// Открываем чек
	Результат = ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, Ложь, Ложь, ВыходныеПараметры);

	// Печатаем строки чека
	Если Результат Тогда
		Для НомерСтроки = 1 По СтрЧислоСтрок(СтрокаТекста) Цикл
			ВыделеннаяСтрока = СтрПолучитьСтроку(СтрокаТекста, НомерСтроки);
			Если Найти(ВыделеннаяСтрока, Символ(Параметры.КодСимволаЧастичногоОтреза)) > 0 Тогда
				ТаблицаОплат = Новый Массив();
				Результат = ЗакрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаОплат, ВыходныеПараметры);
				Результат = ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, Ложь, Ложь, ВыходныеПараметры);
			Иначе
				Если НЕ НапечататьНефискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
				                                     ВыделеннаяСтрока, ВыходныеПараметры) Тогда
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	// Закрываем чек
	Если Результат Тогда
		ТаблицаОплат = Новый Массив();
		Результат = ЗакрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаОплат, ВыходныеПараметры);
	КонецЕсли;

	Возврат Результат;

КонецФункции


// Функция осуществляет открытие нового чека.
//
Функция ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ЧекВозврата, ФискальныйЧек, ВыходныеПараметры)

	Результат  = Истина;
	НомерСмены = 0;
	НомерЧека  = 0;

	// Открываем чек
	Результат = ОбъектДрайвера.ОткрытьЧек(ПараметрыПодключения.ИДУстройства, ФискальныйЧек, ЧекВозврата,
	                                      Истина, НомерЧека, НомерСмены);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
	Иначе
		// Заполнение выходных параметров
		ВыходныеПараметры.Добавить(НомерСмены);
		ВыходныеПараметры.Добавить(НомерЧека);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(ТекущаяДата())
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет печать фискальной строки.
//
Функция НапечататьФискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                                   Наименование, Количество, Цена, ПроцентСкидки, Сумма,
                                   НомерСекции, СтавкаНДС, ВыходныеПараметры)

	Результат = Истина;

	Результат = ОбъектДрайвера.НапечататьФискСтроку(ПараметрыПодключения.ИДУстройства, Наименование, Количество, Цена,
	                                                ПроцентСкидки, НомерСекции, СтавкаНДС);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет печать нефискальной строки.
//
Функция НапечататьНефискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры)

	Результат = Истина;

	Результат = ОбъектДрайвера.НапечататьНефискСтроку(ПараметрыПодключения.ИДУстройства, СтрокаТекста);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет закрытие ранее открытого чека.
//
Функция ЗакрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаОплат, ВыходныеПараметры)

	Результат = Истина;

	СуммаНаличнойОплаты    = 0;
	СуммаБезналичнойОплаты = 0;

	Для ИндексОплаты = 0 По ТаблицаОплат.Количество() - 1 Цикл
		Если ТаблицаОплат[ИндексОплаты][0] = 0 Тогда
			СуммаНаличнойОплаты = СуммаНаличнойОплаты + ТаблицаОплат[ИндексОплаты][1].Значение;
		Иначе
			СуммаБезналичнойОплаты = СуммаБезналичнойОплаты + ТаблицаОплат[ИндексОплаты][1].Значение;
		КонецЕсли;
	КонецЦикла;

	Результат = ОбъектДрайвера.ЗакрытьЧек(ПараметрыПодключения.ИДУстройства,
	                                      СуммаНаличнойОплаты, СуммаБезналичнойОплаты); // Не поддерживает две безналичные оплаты
	Если НЕ Результат Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отмену ранее открытого чека.
//
Функция ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.ОтменитьЧек(ПараметрыПодключения.ИДУстройства);

	Возврат Результат;

КонецФункции


// Функция осуществляет внесение или выемку суммы на ФР.
//
Функция Инкассация(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипИнкассации, Сумма, ВыходныеПараметры)

	Результат = Истина;

	Результат = ОбъектДрайвера.НапечататьЧекВнесенияВыемки(ПараметрыПодключения.ИДУстройства,
	                           ?(ТипИнкассации = 1, Сумма, -Сумма));
	Если НЕ Результат Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	Иначе
		// Заполнение выходных параметров
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(ТекущаяДата());
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет снятие отчёта без гашения.
//
Функция НапечататьОтчетБезГашения(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Результат = ОбъектДрайвера.НапечататьОтчетБезГашения(ПараметрыПодключения.ИДУстройства);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	Иначе
		// Заполнение выходных параметров
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(ТекущаяДата());
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет снятие отчёта с гашением.
//
Функция НапечататьОтчетСГашением(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Результат = ОбъектДрайвера.НапечататьОтчетСГашением(ПараметрыПодключения.ИДУстройства);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	Иначе
		// Заполнение выходных параметров
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(ТекущаяДата());
	КонецЕсли;

	Возврат Результат;

КонецФункции

//////////// ДОПОЛНИТЕЛЬНЫЕ КОМАНДЫ ////////////////////

// Функция осуществляет снятие отчёта без гашения.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	РезультатТеста = "";

	МассивЗначений = Новый Массив;
	МассивЗначений.Добавить(Параметры.Порт);
	МассивЗначений.Добавить(Параметры.Скорость);
	МассивЗначений.Добавить(Параметры.ПарольККМ);
	МассивЗначений.Добавить(Параметры.ПарольККМ);
	МассивЗначений.Добавить(Параметры.Таймаут);

	Результат = ОбъектДрайвера.ТестУстройства(МассивЗначений, РезультатТеста);

	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
	ВыходныеПараметры.Добавить(РезультатТеста);

	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена'"));

	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.ПолучитьНомерВерсии();
	Исключение
	КонецПопытки;

	Возврат Результат;

КонецФункции
