﻿///////////////////////////////////////////////////////////////////////
///////////////////ПРОЦЕДУРЫ ФОРМЫ/////////////////////////////////////
///////////////////////////////////////////////////////////////////////



&НаКлиенте
Процедура НайтиАдрес(Команда)
	НайтиАдресНаКарте(ТекАдрес);
КонецПроцедуры

&НаКлиенте
Процедура ИнициализацияКарты(Команда)
	ИнициализироватьКарту();
КонецПроцедуры

&НаКлиенте
Процедура СправочнаяИнформация(Команда)
	//Элементы.ГруппаСправка.Видимость = Не Элементы.ГруппаСправка.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура Разработчик(Команда)
	ЗапуститьПриложение("http://smaylukk.com.ua/?lang=Ru");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Объект.ТипКарты = 0;
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	Поставщик = ТекОбъект.СтруктураПоставщиковКарт.Получить(Объект.ТипКарты);
	
	//Макет = ТекОбъект.ПолучитьМакет("Справка");
	//ТекстСправки = Макет.ПолучитьОбласть("Справка" + Поставщик).Область().Текст;
	//Справка = ТекстСправки;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПутевыеЛисты.Параметры.УстановитьЗначениеПараметра("Дата",Дата);
	ТоварНаЗоне.Параметры.УстановитьЗначениеПараметра("Дата",Дата);
	Элементы.ГруппаСправка.Видимость = Истина;
	Заголовок = "Работа с картами. Поставщик - " + Поставщик;
	ИнициализироватьКарту();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	//удаление временных файлов
	Для Каждого ТекЭлемент Из МассивВременныхФайлов Цикл
		УдалитьФайлы(ТекЭлемент.Значение);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
//Процедура составляет  имя процедуры поставщика
// и запускает ее на исполнение
//Параметры:
// НачалоИмени - Строка
Процедура ВыполнитьПроцедуруПоставщика(ИмяПроцедуры)
	Выполнить ИмяПроцедуры;
КонецПроцедуры

&НаКлиенте
//процедура инициализирует карту постащика из макета
Процедура ИнициализироватьКарту()
	Текст = ПолучитьТекстМакета("МакетЯндекс");
	
	Эксплорер = Текст;
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстМакета(ИмяМакета)
	Макет = РеквизитФормыВЗначение("Объект").ПолучитьМакет(ИмяМакета);
	Результат = Макет.ПолучитьТекст();
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ОчисткаКарты()
	Элементы.Эксплорер.document.getElementById("WebClientOperation").value = "Reset()";
	Элементы.Эксплорер.document.getElementById("WebClient").click();
КонецПроцедуры

///////////////////////////////////////////////////////////////////////
///////////////////ГЕОКОДИРОВАНИЕ И ПОИСК АДРЕСА///////////////////////
///////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура НайтиАдресНаКарте(Адрес = "")	
	//поиск адреса
	Если Адрес = "" Тогда
		Адрес = "Ташкент";		
	КонецЕсли;
	
	// дальше пробуем с помощью геокодинга вывести данные поиска в таблицу
	ТаблицаАдресов.Очистить();
	
	ПоискАдреса(Адрес);
	Если Поставщик = "Яндекс" Тогда
		ПроизвестиГеокодинг_Яндекс();
	ИначеЕсли Поставщик = "Гугл" Тогда
		ПроизвестиГеокодинг_Гугл();
	ИначеЕсли Поставщик = "Рамблер" Тогда
		ПроизвестиГеокодинг_Рамблер();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоискАдреса(Адрес)
	Элементы.Эксплорер.document.getElementById("WebClientOperation").value = "FindAdres(""" + Адрес + """);";
	Элементы.Эксплорер.document.getElementById("WebClient").click();
КонецПроцедуры

&НаСервере
//Процедура выводит в таблицу данные геокдинга Яндекса
//
//Параметры:
// ТекАдрес - Строка
Процедура ПроизвестиГеокодинг_Яндекс()
	Яндекс = Новый HTTPСоединение("geocode-maps.yandex.ru");
	
	ВременныйФайл = КаталогВременныхФайлов() + "Yandex_geocode_" + СокрЛП(Новый УникальныйИдентификатор);
	Попытка
		Яндекс.Получить("/1.x/?geocode=" + ТекАдрес + "&results=10", ВременныйФайл);
	Исключение
		Сообщить("Ошибка при попытке геокодировать по яндексу адрес: " + ТекАдрес);
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ВременныйФайл);
	
	ПостроительDOM 			= Новый ПостроительDOM;
	ДокументДОМ 			= ПостроительDOM.Прочитать(ЧтениеXML);
	
	СписокText 				= ДокументДОМ.ПолучитьЭлементыПоИмени("text");
	СписокPos 				= ДокументДОМ.ПолучитьЭлементыПоИмени("pos");
		
	Если (СписокText.Количество() = 0) ИЛИ (СписокPos.Количество() = 0) Тогда
		Возврат;	
	КонецЕсли;
	
	Для ъ = 0 по СписокText.Количество()-1 Цикл
		Координаты = СписокPos[Ъ].ТекстовоеСодержимое;
		Разделитель = Найти(Координаты," ");
		Широта = Число(Сред(Координаты, Разделитель + 1));
		Долгота = Число(Лев(Координаты, Разделитель - 1));
		
		Если Широта = 0 ИЛИ Долгота = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		стрАдрес = ТаблицаАдресов.Добавить();
		Если СписокText.Количество() > ъ Тогда
			стрАдрес.Адрес = СписокText[Ъ].ТекстовоеСодержимое;
			стрАдрес.Широта = Широта;
			стрАдрес.Долгота = Долгота;
		КонецЕсли;		
	КонецЦикла;	
	МассивВременныхФайлов.Добавить(ВременныйФайл);
КонецПроцедуры

&НаСервере

//Процедура выводит в таблицу данные геокдинга Гугл
//
//Параметры:
// ТекАдрес - Строка
Процедура ПроизвестиГеокодинг_Гугл()
	Гугл = Новый HTTPСоединение("maps.googleapis.com");
	
	ВременныйФайл = КаталогВременныхФайлов() + "Google_geocode_" + СокрЛП(Новый УникальныйИдентификатор);
	Попытка
		Гугл.Получить("/maps/api/geocode/xml?address=" + ТекАдрес + "&language=ru&sensor=false", ВременныйФайл);
	Исключение
		Сообщить("Ошибка при попытке геокодировать по Google адрес: " + ТекАдрес);
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ВременныйФайл);
	
	ПостроительDOM 			= Новый ПостроительDOM;
	ДокументДОМ 			= ПостроительDOM.Прочитать(ЧтениеXML);
	ТаблицаРезультатов = ДокументДОМ.ПолучитьЭлементыПоИмени("result");
	
	Если ДокументДОМ.ПолучитьЭлементыПоИмени("status")[0].ТекстовоеСодержимое <> "OK" ИЛИ ТаблицаРезультатов.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
		
	Для ТекРезультат = 0 по ТаблицаРезультатов.Количество() -1 Цикл 
		
		СписокText 				= ТаблицаРезультатов[ТекРезультат].ПолучитьЭлементыПоИмени("formatted_address");
		ЭлементыШиротаДолгота = ТаблицаРезультатов[ТекРезультат].ПолучитьЭлементыПоИмени("location");
		Широта = ЭлементыШиротаДолгота[0].ПолучитьЭлементыПоИмени("lat")[0].ТекстовоеСодержимое;
		Долгота = ЭлементыШиротаДолгота[0].ПолучитьЭлементыПоИмени("lng")[0].ТекстовоеСодержимое;
		Если Широта = 0 ИЛИ Долгота = 0 Тогда
			Продолжить;
		КонецЕсли;
			
		стрАдрес = ТаблицаАдресов.Добавить();
		стрАдрес.Широта = Широта;
		стрАдрес.Долгота = Долгота;
		стрАдрес.Адрес = СписокText[0].ТекстовоеСодержимое;  
	КонецЦикла;
	МассивВременныхФайлов.Добавить(ВременныйФайл);
КонецПроцедуры

&НаСервере
//Процедура выводит в таблицу данные геокдинга Рамблер
//
//Параметры:
// ТекАдрес - Строка
Процедура ПроизвестиГеокодинг_Рамблер()
	ТемпАдрес = СтрЗаменить(ТекАдрес, " ", "+");
	
	Рамблер = Новый HTTPСоединение("maps.rambler.ru");	
	ВременныйФайл = КаталогВременныхФайлов() + "Рамблер_geocode_" + СокрЛП(Новый УникальныйИдентификатор);
	Попытка
		Рамблер.Получить("/search/?&a=search&q=" + ТемпАдрес + "&n=10", ВременныйФайл);
	Исключение
		Сообщить("Ошибка при попытке геокодировать по Рамблер адрес: " + ТекАдрес);
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	а = 1;
	Т = Новый ТекстовыйДокумент;
	Т.Прочитать(ВременныйФайл);
	СтрокаОтвет = Т.ПолучитьТекст();
	Результат = РеквизитФормыВЗначение("Объект").UnicodeEncode(СтрокаОтвет);
	Если Результат Тогда
		СтруктураJSON = РеквизитФормыВЗначение("Объект").ЗаполнитьСтруктуруИзОтветаJSON(СтрокаОтвет);
	КонецЕсли;
	
	МассивРезультатов = СтруктураJSON.res;
	//обрабатываем элементы массива - только адреса. POI можно обработать отдельно пожеланию
	Для Каждого Результат Из МассивРезультатов Цикл
		Для Каждого ТекРезультат Из Результат.matches Цикл				
			стрАдрес = ТаблицаАдресов.Добавить();
			стрАдрес.Долгота = Число(ТекРезультат.x);
			стрАдрес.Широта = Число(ТекРезультат.y);
			Если Результат.type = "addr" Тогда  //Результат.type = "poi" - содержит в себе список точек интереса
				стрАдрес.Адрес = ТекРезультат.addr;
			Иначе
				стрАдрес.Адрес = ТекРезультат.name + " - " + ТекРезультат.addr;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	МассивВременныхФайлов.Добавить(ВременныйФайл);
КонецПроцедуры

&НаКлиенте
Процедура ОбратнПоискАдреса(Широта, Долгота, Адрес)
	Элементы.Эксплорер.document.getElementById("WebClientOperation").value = "ReverseSearchAdres(" + Широта + "," + Долгота + ", """ + Адрес + """);";
	Элементы.Эксплорер.document.getElementById("WebClient").click();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаАдресовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(ТаблицаАдресов[ВыбраннаяСтрока].Широта) И ЗначениеЗаполнено(ТаблицаАдресов[ВыбраннаяСтрока].Долгота) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	Широта = Формат(ТаблицаАдресов[ВыбраннаяСтрока].Широта, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
	Долгота = Формат(ТаблицаАдресов[ВыбраннаяСтрока].Долгота, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
	
	ОбратнПоискАдреса(Широта, Долгота, ТаблицаАдресов[ВыбраннаяСтрока].Адрес);
КонецПроцедуры

&НаКлиенте
Процедура ТекАдресПриИзменении(Элемент)
	НайтиАдресНаКарте(ТекАдрес);
КонецПроцедуры


///////////////////////////////////////////////////////////////////////
///////////////////МАРШРУТИЗАЦИЯ, КЛАСТЕРА И ПОЛИГОН///////////////////////////////////////
///////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура ЭксплорерПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	ПолучитьКоординаты();

КонецПроцедуры

&НаКлиенте
Процедура ПостроитьМаршрут(Команда)
	Если ТаблицаТочек.Количество() <= 1 Тогда
		Предупреждение("Недостаточно точек для построение маршрута!");
		Возврат;
	КонецЕсли;
	
	Если Поставщик = "Яндекс" Тогда
		ПостроитьМаршрут_Яндекс();
	ИначеЕсли Поставщик = "Гугл" Тогда
		ПостроитьМаршрут_Гугл();
	ИначеЕсли Поставщик = "Рамблер" Тогда
		ПостроитьМаршрут_Рамблер();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
//Процедура выстраивает маршрут для Яндекса
//
//Параметры:
//
Процедура ПостроитьМаршрут_Яндекс()
	ПараметрыМаршрута = ПолучитьПараметрыМаршрутаЯндекс();
	
	ОчисткаКарты();
	
	Элементы.Эксплорер.document.getElementById("WebClientOperation").value = "calcRoute(" + ПараметрыМаршрута + ")";
	Элементы.Эксплорер.document.getElementById("WebClient").click();
	//МаршрутКМ=Элементы.Эксплорер.document.getElementById("KMInfo").value ;
	//МаршрутВР=Элементы.Эксплорер.document.getElementById("VRInfo").value ;
КонецПроцедуры

&НаКлиенте
//Функция получает массив точек, для передачи параметров в Яндекс
//
//Параметры:
//
//Возвращаемое значение:
// Строка
Функция ПолучитьПараметрыМаршрутаЯндекс()
	Результат = "";
	
	Результат = Результат + "[[" + СтрЗаменить(Строка(ТаблицаТочек[0].Широта), ",", ".") + "," + СтрЗаменить(Строка(ТаблицаТочек[0].Долгота), ",", ".") + "],";
		
	Для Ин = 1 По ТаблицаТочек.Количество() - 2 Цикл
		Результат = Результат + "[" + СтрЗаменить(Строка(ТаблицаТочек[ин].Широта), ",", ".") + "," + СтрЗаменить(Строка(ТаблицаТочек[ин].Долгота), ",", ".") + "],";
	КонецЦикла;
		
	Результат = Результат + "[" + СтрЗаменить(Строка(ТаблицаТочек[ТаблицаТочек.Количество() - 1].Широта), ",", ".") + "," + СтрЗаменить(Строка(ТаблицаТочек[ТаблицаТочек.Количество() - 1].Долгота), ",", ".") + "]]";
		
	Возврат Результат;
КонецФункции

&НаКлиенте
//Процедура выстраивает маршрут для Гугл
//
//Параметры:
//
Процедура ПостроитьМаршрут_Гугл()
	ПараметрыМаршрута = ПолучитьПараметрыМаршрутаГугл();
	
	ОчисткаКарты();
	
	Элементы.Эксплорер.document.getElementById("WebClientOperation").value = "calcRoute(" + ПараметрыМаршрута + ")";
	Элементы.Эксплорер.document.getElementById("WebClient").click();
КонецПроцедуры

&НаКлиенте
//Функция получает массив точек, для передачи параметров в Гугл
//
//Параметры:
//
//Возвращаемое значение:
// Строка
Функция ПолучитьПараметрыМаршрутаГугл()
	Результат = "";
	ВнутрМассив = "";
	
	Результат = Результат + "[[" + СтрЗаменить(Строка(ТаблицаТочек[0].Широта), ",", ".") + "," + СтрЗаменить(Строка(ТаблицаТочек[0].Долгота), ",", ".") + "],";
	
	Если ТаблицаТочек.Количество() = 2 Тогда
		Результат = Результат + "[],"; 
	Иначе
		Для Ин = 1 По ТаблицаТочек.Количество() - 2 Цикл
			ВнутрМассив = ВнутрМассив + "[" + СтрЗаменить(Строка(ТаблицаТочек[ин].Широта), ",", ".") + "," + СтрЗаменить(Строка(ТаблицаТочек[ин].Долгота), ",", ".") + "],";
		КонецЦикла;
		Результат = Результат + "[" + Сред(ВнутрМассив, 1, СтрДлина(ВнутрМассив) - 1) + "],";
	КонецЕсли;
	
	Результат = Результат + "[" + СтрЗаменить(Строка(ТаблицаТочек[ТаблицаТочек.Количество() - 1].Широта), ",", ".") + "," + СтрЗаменить(Строка(ТаблицаТочек[ТаблицаТочек.Количество() - 1].Долгота), ",", ".") + "]]";
		
	Возврат Результат;
КонецФункции

&НаКлиенте
//Процедура выстраивает маршрут для Рамблера
//
//Параметры:
//
Процедура ПостроитьМаршрут_Рамблер()
	ПараметрыМаршрута = ПолучитьПараметрыМаршрутаРамблер();
	
	ОчисткаКарты();
	
	Элементы.Эксплорер.document.getElementById("WebClientOperation").value = "calcRoute(" + ПараметрыМаршрута + ")";
	Элементы.Эксплорер.document.getElementById("WebClient").click();
КонецПроцедуры

&НаКлиенте
//Функция получает массив точек, для передачи параметров в Рамблер
//
//Параметры:
//
//Возвращаемое значение:
// Строка
Функция ПолучитьПараметрыМаршрутаРамблер()
	Результат = "";
	
	Результат = Результат + "[[" + СтрЗаменить(Строка(ТаблицаТочек[0].Широта), ",", ".") + "," + СтрЗаменить(Строка(ТаблицаТочек[0].Долгота), ",", ".") + "],";
		
	Для Ин = 1 По ТаблицаТочек.Количество() - 2 Цикл
		Результат = Результат + "[" + СтрЗаменить(Строка(ТаблицаТочек[ин].Широта), ",", ".") + "," + СтрЗаменить(Строка(ТаблицаТочек[ин].Долгота), ",", ".") + "],";
	КонецЦикла;
		
	Результат = Результат + "[" + СтрЗаменить(Строка(ТаблицаТочек[ТаблицаТочек.Количество() - 1].Широта), ",", ".") + "," + СтрЗаменить(Строка(ТаблицаТочек[ТаблицаТочек.Количество() - 1].Долгота), ",", ".") + "]]";
		
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура СоздатьКластер(Команда)
	Если ТаблицаТочек.Количество() <= 1 Тогда
		Предупреждение("Недостаточно точек для построение кластера!");
		Возврат;
	КонецЕсли;
	
	ОчисткаКарты();
	
	ПостроитьКластера();
КонецПроцедуры

&НаКлиенте
Процедура ПостроитьКластера()
	Кол = ТаблицаТочек.Количество();
	Индекс = 1;
	Для Каждого ТекСтрока Из ТаблицаТочек Цикл
		Широта = формат(ТекСтрока.Широта, "ЧРД=.");
		Долгота = формат(ТекСтрока.Долгота, "ЧРД=.");
		СодержимоеТочки = "Содерижмое точки";  //опять же можно вставить свое название
		Элементы.Эксплорер.document.getElementById("WebClientOperation").value = "addToPointArray(" + Широта + "," + Долгота + ", '" + ТекСтрока.Точка + "', """ + СодержимоеТочки + """);";
		Элементы.Эксплорер.document.getElementById("WebClient").click();
		
		Состояние("Обработан " + Индекс + " из " + кол);
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Элементы.Эксплорер.document.getElementById("WebClientOperation").value = "drawCluster();";
	Элементы.Эксплорер.document.getElementById("WebClient").click();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВсе(Команда)
	ОчисткаКарты();
	ТаблицаТочек.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКарту(Команда)
	ОчисткаКарты();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТаблицу(Команда)
	ТаблицаТочек.Очистить();
КонецПроцедуры

&НаКлиенте
//Процедура получает координаты установленной точки
Процедура ПолучитьКоординаты()
	Попытка
		ЧислоТип = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 12));
		
		КоординатаX = Элементы.Эксплорер.document.getElementById("CoordX").value;
		КоординатаX = ЧислоТип.ПривестиЗначение(КоординатаX);
		
		КоординатаY = Элементы.Эксплорер.document.getElementById("CoordY").value;
		КоординатаY = ЧислоТип.ПривестиЗначение(КоординатаY);
		
		//Кол = ТаблицаТочек.Количество();
		//Если КоординатаX > 0 И КоординатаY > 0 И (Кол = 0 Или КоординатаX <> ТаблицаТочек[Кол - 1].Широта И КоординатаY <> ТаблицаТочек[Кол - 1].Долгота) Тогда
		//	НоваяСтрока = ТаблицаТочек.Добавить();
		//	НоваяСтрока.Точка = "Точка" + ТаблицаТочек.Количество();
		//	НоваяСтрока.Широта = КоординатаX;
		//	НоваяСтрока.Долгота = КоординатаY;
		//КонецЕсли;
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ПострениеПолигона(Команда)
	Если ТаблицаТочек.Количество() <= 1 Тогда
		Предупреждение("Недостаточно точек для построение полигона!");
		Возврат;
	КонецЕсли;
	
	ОчисткаКарты();
	
	ПостроитьПолигон();
КонецПроцедуры

&НаКлиенте
//Процедура выстраивает маршрут для Рамблера
//
//Параметры:
//
Процедура ПостроитьПолигон()
	МассивТочек = "[";
	Для Каждого ТекТочка Из ТаблицаТочек Цикл
		Широта = формат(ТекТочка.Широта, "ЧРД=.");
		Долгота = формат(ТекТочка.Долгота, "ЧРД=.");
		МассивТочек = МассивТочек + "[" + Широта + "," + Долгота + "],"; 
	КонецЦикла;
	МассивТочек = Сред(МассивТочек, 1, СтрДлина(МассивТочек) - 1) + "]";
	
	Цвет16 = Получить16Цвет();
	
	Название = "Полигон";//вставить свое :)
	Элементы.Эксплорер.document.getElementById("WebClientOperation").value = "createPolygon(" + МассивТочек + ", '" + Название + "', '" + Цвет16 + "');";
	Элементы.Эксплорер.document.getElementById("WebClient").click();
КонецПроцедуры

&НаСервере
//Функция возвращает значение случайного цвета в 16-ричном формате
//
//Параметры:
//  нет
//Возвращаемое значение:
//  Строка
Функция Получить16Цвет()
	Результат = "";
	
	Строка16 = "0123456789ABCDEF";
	ГСЧ = Новый ГенераторСлучайныхЧисел;
	Результат = "#";
	Для н = 1 По 6 Цикл
		м = ГСЧ.СлучайноеЧисло(1, 16);
		Результат = Результат + Сред(Строка16, м, 1);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции


&НаКлиенте
Процедура ПутевыеЛистыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПутевойЛист_2Данные.ДокументПрихода.Получатель как Получатель,
	|	ПутевойЛист_2Данные.ДокументПрихода.Получатель.КорX как КорX,
	|	ПутевойЛист_2Данные.ДокументПрихода.Получатель.КорY как КорY
	|ИЗ
	|	Документ.ПутевойЛист_2.Данные КАК ПутевойЛист_2Данные
	|ГДЕ
	|	ПутевойЛист_2Данные.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",Элементы.ПутевыеЛисты.ТекущиеДанные.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	ТаблицаТочек.Очистить();
	     Стр=ТаблицаТочек.Добавить();
		 Стр.Точка="Склад Чукурсай";
		 Стр.Широта=41.354092;
		 Стр.Долгота=69.260926;
	
		 Пока Выборка.Следующий() Цикл
			 Если Выборка.КорY>0 И Выборка.КорX>0 тогда
				 Стр=ТаблицаТочек.Добавить();
				 Стр.Точка=Выборка.Получатель;
				 Стр.Широта=Выборка.КорY;
				 Стр.Долгота=Выборка.КорX;
			 КонецЕсли;
		 КонецЦикла;
	     Стр=ТаблицаТочек.Добавить();
		 Стр.Точка="Склад Чукурсай";
		 Стр.Широта=41.354092;
		 Стр.Долгота=69.260926;
	Команда="";	 
	ПостроитьМаршрут(Команда);	

	// Вставить содержимое обработчика.
КонецПроцедуры


&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ПутевыеЛисты.Параметры.УстановитьЗначениеПараметра("Дата",Дата);
	ТоварНаЗоне.Параметры.УстановитьЗначениеПараметра("Дата",Дата);
КонецПроцедуры


&НаКлиенте
Процедура Маршрут(Команда)
	Объект.Маршрут=Элементы.Эксплорер.document.getElementById("RouteInfo").value ;
	Стр= СтрЗаменить(Объект.Маршрут,"&#160;"," ");
	Стр= СтрЗаменить(Стр,"</br>", Символы.ПС);
	Объект.Маршрут=Стр; 
	// Вставить содержимое обработчика.
КонецПроцедуры


&НаКлиенте
Процедура ПоказатьВсе1(Команда)
	ПоказатьВсе();// Вставить содержимое обработчика.
КонецПроцедуры
&НаКлиенте
Процедура ПоказатьВсе()
	Для каждого Стр Из ТоварНаЗоне Цикл
		Если Стр.КорY>0	и Стр.КорX>0 Тогда
			Адрес="ПП" ;
			ОбратнПоискАдреса(Стр.КорY, Стр.КорX, Адрес) ;
	    КонецЕсли
	КонецЦикла;
КонецПроцедуры

