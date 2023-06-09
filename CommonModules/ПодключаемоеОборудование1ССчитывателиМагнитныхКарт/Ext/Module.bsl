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

	Результат  = Истина;

	// Обязательные выходные
	Если ТипЗнч(ВыходныеПараметры) <> Тип("Массив") Тогда
		ВыходныеПараметры = Новый Массив();
	КонецЕсли;

	// Проверка настроенных параметров
	Порт             = Неопределено;
	Скорость         = Неопределено;
	СтопБит          = Неопределено;
	БитДанных        = Неопределено;
	ПараметрыДорожек = Неопределено;

	Параметры.Свойство("Порт",             Порт);
	Параметры.Свойство("Скорость",         Скорость);
	Параметры.Свойство("СтопБит",          СтопБит);
	Параметры.Свойство("БитДанных",        БитДанных);
	Параметры.Свойство("ПараметрыДорожек", ПараметрыДорожек);

	Если Порт             = Неопределено
	 Или Скорость         = Неопределено
	 Или СтопБит          = Неопределено
	 Или БитДанных        = Неопределено
	 Или ПараметрыДорожек = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.
		|Сделать это можно при помощи формы ""Настройка параметров"" модели
		|подключаемого оборудования в форме ""Подключение и настройка оборудования"".'"));

		Результат = Ложь;
	КонецЕсли;

	Если Результат Тогда
		ВыходныеПараметры.Добавить("СчитывательМагнитныхКарт");
		ВыходныеПараметры.Добавить(Новый Массив());
		ВыходныеПараметры[1].Добавить("ПолученКодКарты");

		Результат = (ОбъектДрайвера.Подсоединить(ВыходныеПараметры[0]) = 0);
		Если НЕ Результат Тогда
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(НСтр("ru='Ошибка при подключении устройства.
			|Проверьте настройки порта.'"));
		КонецЕсли;

		Если Результат = Истина Тогда
			ОбъектДрайвера.БитДанных  = Параметры.БитДанных;
			ОбъектДрайвера.Порт       = Параметры.Порт;
			ОбъектДрайвера.Скорость   = Параметры.Скорость;
			ОбъектДрайвера.СтопБит    = Параметры.СтопБит;
			Для Индекс = 1 По 3 Цикл
				Если Параметры.ПараметрыДорожек[3 - Индекс].Использовать Тогда
					ОбъектДрайвера.СтопСимвол = Параметры.ПараметрыДорожек[3 - Индекс].Суффикс;
					Прервать;
				КонецЕсли;
			КонецЦикла;

			ОбъектДрайвера.ИмяСобытия = ВыходныеПараметры[1][0];

			Результат = (ОбъектДрайвера.Занять(1) = 0);
			Если Результат Тогда
				ОбъектДрайвера.УстройствоВключено = 1;
				ОбъектДрайвера.ПосылкаДанных      = 1;
				ОбъектДрайвера.ОчиститьВход();
				ОбъектДрайвера.ОчиститьВыход();

				Результат = (ОбъектДрайвера.УстройствоВключено = 1);
				Если НЕ Результат Тогда
					ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

					ВыходныеПараметры.Очистить();
					ВыходныеПараметры.Добавить(999);
					ВыходныеПараметры.Добавить(НСтр("ru='Ошибка при подключении устройства.
					|Проверьте настройки порта.'"));
				КонецЕсли;
			Иначе
				ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

				ВыходныеПараметры.Очистить();
				ВыходныеПараметры.Добавить(999);
				ВыходныеПараметры.Добавить(НСтр("ru='Не удалось занять устройство.
				|Проверьте настройки порта.'"));
			КонецЕсли;
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

	Результат = Истина;

	// Обязательные выходные
	Если ТипЗнч(ВыходныеПараметры) <> Тип("Массив") Тогда
		ВыходныеПараметры = Новый Массив();
	КонецЕсли;

	ОбъектДрайвера.УстройствоВключено = 0;
	ОбъектДрайвера.Освободить();
	ОбъектДрайвера.Отсоединить();

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	// Обязательные выходные
	Если ТипЗнч(ВыходныеПараметры) <> Тип("Массив") Тогда
		ВыходныеПараметры = Новый Массив();
	КонецЕсли;

	// Обработка события от устройства
	Если Команда = "ОбработатьСобытие" Тогда
		Событие = ВходныеПараметры[0];
		Данные  = ВходныеПараметры[1];

		Результат = ОбработатьСобытие(ОбъектДрайвера, Параметры, ПараметрыПодключения, Событие, Данные, ВыходныеПараметры);

	// Завершение обработки события от устройства
	ИначеЕсли Команда = "ЗавершитьОбработкуСобытия" Тогда
		Результат = ЗавершитьОбработкуСобытия(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Тестирование устройства
	ИначеЕсли Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Настройка параметров журналирования драйвера
	ИначеЕсли Команда = "ПараметрыЖурналирования" Тогда
		Результат = ПараметрыЖурналирования(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

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

// Функция осуществляет обработку внешних событий торгового оборудования.
//
Функция ОбработатьСобытие(ОбъектДрайвера, Параметры, ПараметрыПодключения, Событие, Данные, ВыходныеПараметры)

	Результат = Истина;
	КодКарты  = Данные;

	ОбъектДрайвера.ПосылкаДанных = 0;

	ПозицияПрефикса = 0;
	ПозицияСуффикса = 0;
	времКодКарты    = "";
	ДанныеКарты = "";
	ПозицияДляЧтения = 1;

	ДанныеДорожек = Новый Массив();
	Для НомерДорожки = 1 По 3 Цикл
		ДанныеДорожек.Добавить("");

		ТекущаяДорожка = Параметры.ПараметрыДорожек[НомерДорожки - 1];
		Если ТекущаяДорожка.Использовать Тогда
			ПрефиксДрайвера = Символ(ТекущаяДорожка.Префикс);
			СуффиксДрайвера = Символ(ТекущаяДорожка.Суффикс);

			Если ПозицияДляЧтения < СтрДлина(КодКарты) Тогда
				ДанныеКарты = Сред(КодКарты, ПозицияДляЧтения);

				ПозицияПрефикса = Найти(ДанныеКарты, ПрефиксДрайвера);
				ПозицияСуффикса = Найти(ДанныеКарты, СуффиксДрайвера);

				времПозицияПрефикса = ?(ПозицияПрефикса = 0, 1, ПозицияПрефикса + СтрДлина(ПрефиксДрайвера));
				времДлинаДоСуффикса = ?(ПозицияСуффикса = 0,
				    СтрДлина(ДанныеКарты) + 1 - времПозицияПрефикса, ПозицияСуффикса - времПозицияПрефикса);
				времКодКарты = времКодКарты + Сред(ДанныеКарты, времПозицияПрефикса, времДлинаДоСуффикса);

				ДанныеДорожек[НомерДорожки - 1] = Сред(ДанныеКарты,
				                                  времПозицияПрефикса,
				                                  времДлинаДоСуффикса);

				ПозицияДляЧтения = ПозицияДляЧтения + ?(ПозицияСуффикса = 0,
				                                        СтрДлина(ДанныеКарты),
				                                        ПозицияСуффикса + СтрДлина(СуффиксДрайвера) - 1);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	КодКарты = времКодКарты;

	ВыходныеПараметры.Добавить("TracksData");
	ВыходныеПараметры.Добавить(Новый Массив());
	ВыходныеПараметры[1].Добавить(КодКарты);
	ВыходныеПараметры[1].Добавить(Новый Массив);
	ВыходныеПараметры[1][1].Добавить(Сред(Данные,2));
	ВыходныеПараметры[1][1].Добавить(ДанныеДорожек);
	ВыходныеПараметры[1][1].Добавить(0);

	Возврат Результат;

КонецФункции

// Процедура вызывается, когда система готова принять следующее событие от устройства.
Функция ЗавершитьОбработкуСобытия(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.ПосылкаДанных = 1;

	Возврат Результат;

КонецФункции

///////////// ДОПОЛНИТЕЛЬНЫЕ КОМАНДЫ ////////////////////

// Осуществляется открытие формы проверки параметров драйвера
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.Скорость  = Параметры.Скорость;
	ОбъектДрайвера.БитДанных = Параметры.БитДанных;
	ОбъектДрайвера.СтопБит   = Параметры.СтопБит;

	ОбъектДрайвера.ТестУстройства();

	Возврат Результат;

КонецФункции

// Осуществляется открытие формы настройки параметров журналирования драйвера
Функция ПараметрыЖурналирования(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.Скорость  = Параметры.Скорость;
	ОбъектДрайвера.БитДанных = Параметры.БитДанных;
	ОбъектДрайвера.СтопБит   = Параметры.СтопБит;

	ОбъектДрайвера.ПараметрыЖурналирования();

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
