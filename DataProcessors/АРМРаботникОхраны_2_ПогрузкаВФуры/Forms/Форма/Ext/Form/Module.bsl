﻿&НаКлиенте
Процедура Сброс(Команда)
	Если Не СбросКромеОхраны Тогда
		РаботникОхраны="";
		ШКОхрана="";
	КонецЕсли;
	//
	ШКРеестра="";
	Реестр="";	
	Организация="";
	ШКсчетфактуры="";
	СчетФактура="";
	Объект.СписокНеПринятыхСФ.Очистить();
	Объект.СписокПринятыхСФ.Очистить();
	
КонецПроцедуры

//**********************************************************//

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если НЕ ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник = "СканерШтрихкода" И Событие = "Barcode" И ЗначениеЗаполнено(Данные) Тогда
		
		Если ЗначениеЗаполнено(СокрЛП(Данные)) Тогда
			//--- Сброс Формы
			//Сообщить(СокрЛП(Данные));
			Если (СокрЛП(Данные))="000000000000" Тогда
				Сброс(Null);
				ОчиститьСообщения();
				//Сообщить("Сброс");
				Возврат;
			КонецЕсли;
			
			Если (СокрЛП(Данные))="111111111111" Тогда
				//Сохранить запись
				 Сохранить(Null);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		//Если охрана не заполнена то Ищем Охранника
		Если Не ЗначениеЗаполнено(ШКОхрана) Тогда
			ШКОхрана = Данные;
			НайденныйОхранник = НайтиФизЛицоПоШк(ШКОхрана,"РаботникОхраны");
			Если Не ЗначениеЗаполнено(НайденныйОхранник) Тогда
				ОчиститьСообщения();
				Сообщить("Охранник не найден!!!");
				ШКОхрана = "";
				РаботникОхраны = "";
			Иначе 
				РаботникОхраны = НайденныйОхранник;
			КонецЕсли;
			Возврат;
		КонецЕсли;	
	
		//Ищем документ 
		
		ШК = Лев(Данные, 12);
		//Определяем тип ШК
	Если Лев(ШК,3) = Справочники.ПрефиксыОбъектовДляШтрихкодов.Реестр.Наименование Тогда //Это РЕЕСТР
		
		ШКРеестра = ШК;
		Реестр=НайтиРеестрПоШКСервер(ШКРеестра);
      	Если ЗначениеЗаполнено(Реестр) Тогда
			// Показать данные документа
			// ОткрытьЗначение(ДокРеестр);
			Организация=ПолучитьОрганизациюИзШК( ШКРеестра);
			//Заполняем списки 
			ЗаполнитьСпискиПоРеестру();
			Возврат;
		 Иначе
			 Сообщить("Реестр с таким ШК не найден.");
			 Реестр="";
			 Возврат;
		КонецЕсли;
		Сообщить("Неверный тип документа(Это не реестр.)");
		Возврат ;	
	Иначе // Не РЕЕСТР
		Если НЕ ЗначениеЗаполнено(Реестр) Тогда
			Сообщить("Сначало введите ШК реестра");
			Возврат;
		КонецЕсли;
		// ШК СчетФ
		ШКсчетфактуры=ШК;
		ШКсчетфактурыПриИзмененииСЕРВЕР();
		ЗаполнитьСпискиПоРеестру();
        Возврат;
	КонецЕсли;

		
		
	КонецЕсли;		
КонецПроцедуры


//**************************************************************//



&НаСервере
Функция НайтиФизЛицоПоШк(ШКФизЛицо,Должность)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Штрихкод = &Штрихкод
	|	И ФизическиеЛица.Должность В(&Должность)";
	
	Запрос.УстановитьПараметр("Штрихкод", ШКФизЛицо);
	
	Должности=Новый Массив;
	Если Должность="Водитель" Тогда
		Должности.Добавить(Справочники.Должности.Водитель);
		Должности.Добавить(Справочники.Должности.Филиал);
	ИначеЕсли Должность="РаботникОхраны" Тогда
		Должности.Добавить(Справочники.Должности.РаботникОхраны);
	КонецЕсли;
	Запрос.УстановитьПараметр("Должность", Должности);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
КонецФункции




&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СбросКромеОхраны=Истина;
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если Вопрос("Сохранить весь реестр для организации "+Организация+"?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		  Возврат;
	КонецЕсли;

		СохранитьСЕРВЕР();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьСЕРВЕР()
	ДокРеестр=Реестр.ПолучитьОбъект();
	ДокРеестр.РаботникОхраны=РаботникОхраны;
	ДокРеестр.ДатаОтгрузки=ТекущаяДата();
	Если КонтрольВсехСФ Тогда
		Если Организация.Код=42 Тогда
			Для Каждого стр_ТЧ Из ДокРеестр.ГруппировкаСчетФактурАСКЛЕПИЙ Цикл
				стр_ТЧ.Проверен=Истина;	  
			КонецЦикла;
		Иначе
			Для Каждого стр_ТЧ Из ДокРеестр.ГруппировкаСчетФактурНФС Цикл
				стр_ТЧ.Проверен=Истина;	  
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
		
	ДокРеестр.Записать(РежимЗаписиДокумента.Проведение);
	ЗаполнитьСпискиПоРеестру();
	
КонецПроцедуры


&НаКлиенте
Процедура НайтиРеестрПоШК(Команда)
	Реестр=НайтиРеестрПоШКСервер(ШКРеестра);
КонецПроцедуры


//--------------- РЕЕСТР ----------------------//

&НаСервере
Функция НайтиРеестрПоШКСервер(ШК)
	
	//Ищем в Базе - Если есть то открываем
	//1. Получаем Номер Реестра С ШК
	
	//Определяем тип
	Если Лев(ШК,3) <> Справочники.ПрефиксыОбъектовДляШтрихкодов.Реестр.Наименование Тогда
		Сообщить("Неверный тип документа(Это не реестр.)");
		Возврат Неопределено;	
	КонецЕсли;
	НомерРеестра=ПолучитьНомерРеестраИзШК(ШК);
	
	//2.Если в 1С нет то ищем в Дельфи и Создаем Новый Реестр
	
	ПоискРеестра=Документы.Реестр.НайтиПоНомеру(НомерРеестра);
	// Есть в 1С
	Если ЗначениеЗаполнено(ПоискРеестра) Тогда
		Сообщить("Найден Реестр-"+ПоискРеестра);
		Возврат ПоискРеестра;	
	КонецЕсли;
	
	// Иначе Создаем новый Реестр
	
	РезультатЗагрузки=модСерверПолныеПрава.ЗагрузитьРеестрИзДельфи(НомерРеестра);	
	
	Если ЗначениеЗаполнено(РезультатЗагрузки.Реестр) Тогда
		Сообщить("Создан Реестр-"+РезультатЗагрузки.Реестр);
		Возврат РезультатЗагрузки.Реестр;
	Иначе
		Сообщить(РезультатЗагрузки.СообщениеОшибки);
		Возврат Неопределено;
	КонецЕсли;
КонецФункции


&НаСервере
Функция  ПолучитьНомерРеестраИзШК(ШК)
		Возврат Сред(ШК,10,3);
	
КонецФункции


&НаСервере
Функция ПолучитьОрганизациюИзШК (ШК)
	
	КодОрганизации=Сред(ШК,4,2);
	   Если КодОрганизации="40" Тогда
		КодОрганизации=41;   
	   КонецЕсли;
	   
	   Возврат Справочники.РеестрОрганизации.НайтиПоКоду(КодОрганизации);
	   
	   
КонецФункции


&НаСервере
Процедура ЗаполнитьСпискиПоРеестру()
	Объект.СписокНеПринятыхСФ.Очистить();
	Объект.СписокПринятыхСФ.Очистить();
	
	Отбор=Новый Структура;
	Отбор.Вставить("Проверен",Ложь);
	Если Организация.Код=42 Тогда
		ТЗ=Реестр.ГруппировкаСчетФактурАСКЛЕПИЙ.Выгрузить(Отбор);
	Иначе
		ТЗ=Реестр.ГруппировкаСчетФактурНФС.Выгрузить(Отбор);
	КонецЕсли;
	Объект.СписокНеПринятыхСФ.Загрузить(ТЗ);
	
	 Отбор=Новый Структура;
	Отбор.Вставить("Проверен",Истина);
	Если Организация.Код=42 Тогда
		ТЗ=Реестр.ГруппировкаСчетФактурАСКЛЕПИЙ.Выгрузить(Отбор);
	Иначе
		ТЗ=Реестр.ГруппировкаСчетФактурНФС.Выгрузить(Отбор);
	КонецЕсли;
	Объект.СписокПринятыхСФ.Загрузить(ТЗ);

	
КонецПроцедуры

&НаКлиенте
Процедура ШКсчетфактурыПриИзменении(Элемент)
	//ШКсчетфактурыПриИзмененииСЕРВЕР();
КонецПроцедуры

&НаСервере
Процедура ШКсчетфактурыПриИзмененииСЕРВЕР()
	//Проверка на реестр
	Если НЕ ЗначениеЗаполнено(Реестр) Тогда
		Сообщить("Сначало выберите РЕЕСТР.");
		Возврат;
	КонецЕсли;
	
	//Ищем БЯС по ШК
	ШКдок=Лев(СокрЛП(ШКсчетфактуры),12);
	ДокБЯС=модСерверПолныеПрава.НайтиДокБЯСпоШК(ШКдок);
	Если НЕ ЗначениеЗаполнено(ДокБЯС) Тогда
	    Сообщить("ОШИБКА! Документ Не Найден.");
		Возврат;
	КонецЕсли;
	
	//Проверяем есть ли такой док в реестре
	Отбор=Новый Структура;
	Отбор.Вставить("ДокБЯС",ДокБЯС);
	масПоиск=Реестр.СчетФактуры.НайтиСтроки(Отбор);
	Если масПоиск.Количество()=0 Тогда
		Сообщить("ОШИБКА!. СчетФ-"+ДокБЯС.НомераСФ+" не в этом реестре");
		Возврат;	
	КонецЕсли;
	
	//Если все Ок -ищем строку и модифицируем ее
	ДокРеестр=Реестр.ПолучитьОбъект();
	НомерСФ=модСерверПолныеПрава.НайтиСчетФактуруПоШК(ШКдок);
	НомерСФ=Лев(СокрЛП(НомерСФ),5);
	Если Организация.Код=42 Тогда //Асклепий
		Для Каждого стр Из ДокРеестр.ГруппировкаСчетФактурАСКЛЕПИЙ Цикл
			Результат=СтрЧислоВхождений(Стр.НомераСчетФактур,НомерСФ);
			Если Результат>0 Тогда // Нашли
				//Запись в реестре
				стр.Проверен=Истина;
				ДокРеестр.Записать();
				Сообщить("СчетФ-"+НомерСФ+" записана в Реестре.");
				Возврат;	
			КонецЕсли;
		КонецЦикла;
		Сообщить("Номер СчетФактуры-"+НомерСФ+" не найден в Реестре.");
		
	Иначе // НФС
		 Для Каждого стр Из ДокРеестр.ГруппировкаСчетФактурНФС Цикл
			Результат=СтрЧислоВхождений(Стр.НомераСчетФактур,НомерСФ);
			Если Результат>0 Тогда // Нашли
				//Запись в реестре
				стр.Проверен=Истина;
				ДокРеестр.Записать();
				Сообщить("СчетФ-"+НомерСФ+" записана в Реестре.");
				Возврат;	
			КонецЕсли;
		КонецЦикла;
		Сообщить("Номер СчетФактуры-"+НомерСФ+" не найден в Реестре.");

	КонецЕсли;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРеестрПовторно(Команда)
	
	Если НЕ ЗначениеЗаполнено(Реестр) Тогда
		Сообщить("Реестр не выбран.");
		Возврат;
	КонецЕсли;
	
	
	Если Вопрос("При повторной загрузке контроль Счет-Фактур необходимо повторить. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;	  
	КонецЕсли;
	
	НомерРеестра=Реестр.Номер;	
	РезультатЗагрузки=модСерверПолныеПрава.ЗагрузитьРеестрИзДельфи(НомерРеестра);	
	
	Если ЗначениеЗаполнено(РезультатЗагрузки.Реестр) Тогда
		Сообщить("Реестр "+НомерРеестра+" обновлен.");
        ЗаполнитьСпискиПоРеестру();

	Иначе
		Сообщить(РезультатЗагрузки.СообщениеОшибки);
	КонецЕсли;


КонецПроцедуры
