﻿
&НаКлиенте
Процедура ШКДокументПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Водитель) Тогда
		//Сообщить("Сначало выберите Водителя");
		Возврат;
	КонецЕсли;
	
	Если ТипСчетФактуры=0 Тогда
		//------------- Ищем Документ БЯС По ШК ---------------//
		Клиент="";
		ДокБЯС=модСерверПолныеПрава.НайтиДокБЯСпоШК(ШКДокумент);
		ПрошлаяФК=ДокБЯС;
		Если ЗначениеЗаполнено(ДокБЯС) Тогда
			//Проверяем на задвоенность
			Отбор=Новый Структура;
			Отбор.Вставить("ДокБЯС",ДокБЯС);
			поискБЯСвТЧ=СписокБЯС.НайтиСтроки(Отбор);
			Если поискБЯСвТЧ.Количество()>0 Тогда
				//Сообщить("Документ уже отмечен - ОТГРУЗОЧНАЯ СФ-"+ДокБЯС.НомераСФ);
				Элементы.СписокБЯС.ТекущаяСтрока=СписокБЯС.Индекс(поискБЯСвТЧ[0]);
				Возврат;	
			КонецЕсли;
			
			новаяСтр=СписокБЯС.Добавить();
			новаяСтр.ДокБЯС=ДокБЯС;
			ПроверитьМТС();
			//Сообщить("Документ найден - ОТГРУЗОЧНАЯ СФ-"+ДокБЯС.НомераСФ);
			Возврат;
			Клиент=ДокБЯС.Получатель;
		КонецЕсли;
		ДокБЯС=модСерверПолныеПрава.НайтиДокБЯСпоКлиенту(Клиент,ДокБЯС);
		Если ЗначениеЗаполнено(ДокБЯС) Тогда
			//Проверяем на задвоенность
			Отбор=Новый Структура;
			Отбор.Вставить("ДокБЯС",ДокБЯС);
			поискБЯСвТЧ=СписокБЯС.НайтиСтроки(Отбор);
			Если поискБЯСвТЧ.Количество()>0 Тогда
				//Сообщить("Документ уже отмечен - ОТГРУЗОЧНАЯ СФ-"+ДокБЯС.НомераСФ);
				Элементы.СписокБЯС.ТекущаяСтрока=СписокБЯС.Индекс(поискБЯСвТЧ[0]);
				Возврат;	
			КонецЕсли;
			
			новаяСтр=СписокБЯС.Добавить();
			новаяСтр.ДокБЯС=ДокБЯС;
			ПроверитьМТС();
			//Сообщить("Документ найден - ОТГРУЗОЧНАЯ СФ-"+ДокБЯС.НомераСФ);
			Возврат;
			
		КонецЕсли;
		
		
	Иначе
		//------------- Док ВОЗВРАТНАЯ СЧЕТ ФАКТУРА ----------------//
		ДокВозвратнаяСФ=модСерверПолныеПрава.НайтиДокВозвратнаяСФпоШК(ШКДокумент);
		Если ЗначениеЗаполнено(ДокВозвратнаяСФ) Тогда
			//Проверяем на задвоенность
			Отбор=Новый Структура;
			Отбор.Вставить("ДокВозвратнаяСФ",ДокВозвратнаяСФ);
			поискВозвратнаяСФвТЧ=СписокВозвратныхСФ.НайтиСтроки(Отбор);
			Если поискВозвратнаяСФвТЧ.Количество()>0 Тогда
				//Сообщить("Документ уже отмечен - ВОЗВРАТНАЯ СФ-"+ДокВозвратнаяСФ.НомерСчетфактуры);
				Элементы.СписокВозвратныхСФ.ТекущаяСтрока=СписокВозвратныхСФ.Индекс(поискВозвратнаяСФвТЧ[0]);
				Возврат;	
			КонецЕсли;
			
			новаяСтр=СписокВозвратныхСФ.Добавить();
			новаяСтр.ДокВозвратнаяСФ=ДокВозвратнаяСФ;
			//Сообщить("Документ найден - ВОЗВРАТНАЯ СФ-"+ДокВозвратнаяСФ.НомерСчетфактуры);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	//----------------------------------------------------------//
	// Ничего не нашли
	Если ТипСчетФактуры=0 Тогда
		//Сообщить("Документ Отгрузочная СФ - Не Найден");
	Иначе
		//Сообщить("Документ Возвратная СФ - Не Найден");
		
	КонецЕсли;
КонецПроцедуры

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
				СохранитьИРаспечатать(Null);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		
		// Ищем Водителя		
		
		Если Не ЗначениеЗаполнено(Водитель) Тогда
			ШКВодитель=СокрЛП(Данные);
			//Ищем ШКВодителя
			Водитель=модСерверПолныеПрава.НайтиФизЛицоПоШк(ШКВодитель,"Водитель");
			Если Не ЗначениеЗаполнено(Водитель) Тогда
				Сообщить("Водитель не найден.");
				Возврат;
			Иначе
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				               |	ДвижениеТарыВодительОстатки.УКого,
				               |	ДвижениеТарыВодительОстатки.КолОстаток
				               |ИЗ
				               |	РегистрНакопления.ДвижениеТарыВодитель.Остатки(&Дата, ) КАК ДвижениеТарыВодительОстатки
				               |ГДЕ
				               |	ДвижениеТарыВодительОстатки.УКого = &УКого";
				
				Запрос.УстановитьПараметр("УКого",Водитель);
				Запрос.УстановитьПараметр("Дата",НачалоДня(ТекущаяДата())+20);
				
				Результат = Запрос.Выполнить();
				Выборка = Результат.Выбрать();
				Если Выборка.Количество()>0 Тогда 
					Выборка.Следующий();
					
					//Сообщить("Водитель "+Водитель+" не сдал тару" + Выборка.КолОстаток+" шт. Сначала сдайте тару");
					//Водитель="";
					
				Иначе	
				КонецЕсли;
				Автомобиль=Водитель.Автомобиль;
			КонецЕсли;
			//ВодительНайден
			// Ищем путевой Лист Для Водителя На текущую Дату
			ПоискПутевойЛист=Неопределено;//модСерверПолныеПрава.НайтиПутевойЛист_2(Водитель,Дата);
			Если ПоискПутевойЛист<>Неопределено Тогда
				ПутевойЛист=ПоискПутевойЛист;
				Если ЗначениеЗаполнено(ПутевойЛист.Автомобиль) Тогда
					Автомобиль=ПутевойЛист.Автомобиль;
				КонецЕсли;
				//Заполняем список сборок
				ТЗбяс=ПутевойЛист.Данные.Выгрузить();
				ТЗбяс.Свернуть("ДокументПрихода");
				Для Каждого стр_ТЗбяс ИЗ ТЗбяс Цикл
					новаяСтр=СписокБЯС.Добавить();
					новаяСтр.ДокБЯС=стр_ТЗбяс.ДокументПрихода;
				КонецЦикла;
				//Заполняем список ВозвратныхСФ
				ТЗвсф=ПутевойЛист.ВозвратныеСФ.Выгрузить();
				ТЗвсф.Свернуть("ВозвратнаяСФ");
				Для Каждого стр_ТЗвсф Из ТЗвсф Цикл
					новаяСтр=СписокВозвратныхСФ.Добавить();
					новаяСтр.ДокВозвратнаяСФ=стр_ТЗвсф.ВозвратнаяСФ;	
				КонецЦикла;
				
			КонецЕсли;
			ОчиститьСообщения();
			Возврат;
		КонецЕсли;
		
		// Ищем Документ
		ШКДокумент = Лев(Данные, 12);
		ШКДокументПриИзменении(Null);
		ПроверитьМТС();
		
		
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ПроверитьМТС()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗонаОтгрузкиОстатки.НомерМестаОтгрузки,
	|	ЗонаОтгрузкиОстатки.ДокументПрихода
	|ИЗ
	|	РегистрНакопления.ЗонаОтгрузки.Остатки КАК ЗонаОтгрузкиОстатки
	|ГДЕ
	|	ЗонаОтгрузкиОстатки.НомерМестаОтгрузки.Код = ""000000008""
	|	И ЗонаОтгрузкиОстатки.ДокументПрихода.Получатель = &Получатель";
	Запрос.УстановитьПараметр("Получатель",ПрошлаяФК.Получатель );
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДокБЯС=Выборка.ДокументПрихода;
		Если ЗначениеЗаполнено(ДокБЯС) Тогда
			//Проверяем на задвоенность
			Отбор=Новый Структура;
			Отбор.Вставить("ДокБЯС",ДокБЯС);
			поискБЯСвТЧ=СписокБЯС.НайтиСтроки(Отбор);
			Если поискБЯСвТЧ.Количество()>0 Тогда
				//Сообщить("Документ уже отмечен - ОТГРУЗОЧНАЯ СФ-"+ДокБЯС.НомераСФ);
				Элементы.СписокБЯС.ТекущаяСтрока=СписокБЯС.Индекс(поискБЯСвТЧ[0]);
				Возврат;	
			КонецЕсли;
			новаяСтр=СписокБЯС.Добавить();
			новаяСтр.ДокБЯС=ДокБЯС;
			//Сообщить("Документ найден - ОТГРУЗОЧНАЯ СФ-"+ДокБЯС.НомераСФ);
			Возврат;
			Клиент=ДокБЯС.Получатель;
		КонецЕсли;
		ДокБЯС=модСерверПолныеПрава.НайтиДокБЯСпоКлиенту(Клиент,ДокБЯС);
		Если ЗначениеЗаполнено(ДокБЯС) Тогда
			//Проверяем на задвоенность
			Отбор=Новый Структура;
			Отбор.Вставить("ДокБЯС",ДокБЯС);
			поискБЯСвТЧ=СписокБЯС.НайтиСтроки(Отбор);
			Если поискБЯСвТЧ.Количество()>0 Тогда
				//Сообщить("Документ уже отмечен - ОТГРУЗОЧНАЯ СФ-"+ДокБЯС.НомераСФ);
				Элементы.СписокБЯС.ТекущаяСтрока=СписокБЯС.Индекс(поискБЯСвТЧ[0]);
				Возврат;	
			КонецЕсли;
			новаяСтр=СписокБЯС.Добавить();
			новаяСтр.ДокБЯС=ДокБЯС;
			//Сообщить("Документ найден - ОТГРУЗОЧНАЯ СФ-"+ДокБЯС.НомераСФ);
			Возврат;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура Сброс(Команда)
	ШКВодитель="";
	Водитель="";
	ШКДокумент="";
	ПутевойЛист="";
	Автомобиль="";
	ТипСчетФактуры=0;
	СписокБЯС.Очистить();
	СписокВозвратныхСФ.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПутевойЛист(Команда)
	
	Если Не ЗначениеЗаполнено(Водитель) Тогда
		//Сообщить("Сначало выберите Водителя");
		Возврат;
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(ПутевойЛист) Тогда
		Если Вопрос("Изменить путевой лист за "+ Дата + " для Водителя - "+Водитель, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат;	
		КонецЕсли;
		
	Иначе
		
		Если Вопрос("Создать путевой лист за "+ Дата + " для Водителя - "+Водитель, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат;	
		КонецЕсли;
		
	КонецЕсли;
	СоздатьПутевойЛистСЕРВЕР();
КонецПроцедуры

&НаСервере
Процедура СоздатьПутевойЛистСЕРВЕР()
	
	Если Не ЗначениеЗаполнено(Водитель) Тогда
		//Сообщить("Сначало выберите Водителя");
		Возврат;
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(ПутевойЛист) Тогда
		НовыйДокумент= ПутевойЛист.ПолучитьОбъект();
		НовыйДокумент.Автомобиль	= Автомобиль;
	Иначе 
		//Создаем новый ПЛ
		НовыйДокумент = Документы.ПутевойЛист_2.СоздатьДокумент();
		НовыйДокумент.Водитель		= Водитель;
		НовыйДокумент.Автомобиль	= Автомобиль;
		НовыйДокумент.Дата 			= ТекущаяДата();
	КонецЕсли;
	
	НовыйДокумент.ГруппироватьКонтрагентов = ГруппироватьПоКлиентам;
	//Заполняем ТЧ БЯС Документа
	НовыйДокумент.Данные.Очистить();
	Для Каждого стр_СписокБЯС Из СписокБЯС  Цикл
		ДокБЯС=стр_СписокБЯС.ДокБЯС;
		НоваяСтрока = НовыйДокумент.Данные.Добавить();
		НоваяСтрока.ДокументПрихода 	= ДокБЯС;
	КонецЦикла;
	//Заполняем ТЧ Возвратные СФ
	НовыйДокумент.ВозвратныеСФ.Очистить();
	Для Каждого стр_СписокВозвратныхСФ Из СписокВозвратныхСФ Цикл
		ДокВозвратнаяСФ=стр_СписокВозвратныхСФ.ДокВозвратнаяСФ;
		НоваяСтрока=НовыйДокумент.ВозвратныеСФ.Добавить();
		НоваяСтрока.ВозвратнаяСФ= ДокВозвратнаяСФ;
	КонецЦикла;
	
	
	НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
	//Сообщить("Создан путевой лист для "+Водитель);
	ПутевойЛист=НовыйДокумент.Ссылка;
	
	// Если Группировка
	Если ГруппироватьПоКлиентам Тогда
		модСерверПолныеПрава.СкомплектоватьПутевойЛист(ПутевойЛист);	
		СписокБЯС.Очистить();
		//Заполняем список сборок
		ТЗбяс=ПутевойЛист.Данные.Выгрузить();
		ТЗбяс.Свернуть("ДокументПрихода");
		Для Каждого стр_ТЗбяс ИЗ ТЗбяс Цикл
			новаяСтр=СписокБЯС.Добавить();
			новаяСтр.ДокБЯС=стр_ТЗбяс.ДокументПрихода;
		КонецЦикла;
 	КонецЕсли;
	
	//Проставляем ПЛ В БЯС
	Для Каждого стр Из ПутевойЛист.Данные Цикл
		стр_ДокБяс=стр.ДокументПрихода.ПолучитьОбъект();
		стр_ДокБяс.ПутевойЛист=ПутевойЛист;
		стр_ДокБяс.Записать(РежимЗаписиДокумента.Запись);
	КонецЦикла;
	//Проставляем ПЛ в Возвратных СФ
	Для Каждого стр Из ПутевойЛист.ВозвратныеСФ Цикл
		стр_ДокВСФ=стр.ВозвратнаяСФ.ПолучитьОбъект();
		стр_ДокВСФ.ПутевойЛист=ПутевойЛист;
		стр_ДокВСФ.Водитель=ПутевойЛист.Водитель;
		стр_ДокВСФ.ДВПриемаВодителем=ТекущаяДата();
		стр_ДокВСФ.Записать(РежимЗаписиДокумента.Запись);
	КонецЦикла;
	ТМС.ОтправитьМЛ(НовыйДокумент.Ссылка);
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Дата=НачалоДня(ТекущаяДата());
	ПечататьСразу=Истина;
	//ГруппироватьПоКлиентам=Истина;
	ПечататьКонтрольныйЛист=Истина;
	ГруппироватьПоКлиентам=Истина;
	Элементы.ГруппироватьПоКлиентам.Доступность=Ложь;
	ТипСчетФактуры=0;
КонецПроцедуры

&НаКлиенте
Процедура ПечататьПутевойЛист(Команда)
	
	Если Не ЗначениеЗаполнено(Водитель) Тогда
		//Сообщить("Сначало выберите Водителя");
		Возврат;
	КонецЕсли;
	
	
	Если Не ЗначениеЗаполнено(ПутевойЛист) Тогда
		//Сообщить("Сначало Создайте Путевой Лист.");
		Возврат;
	КонецЕсли;
	
	// ПутевойЛист
	ТД=Новый ТабличныйДокумент;
	ПутевойЛист.ПолучитьОбъект().ПечатьПутевогоЛиста(ТД);
	ТД.ОриентацияСтраницы=ОриентацияСтраницы.Ландшафт;
	ТД.АвтоМасштаб = Истина;
	Если ПечататьСразу Тогда
		ТД.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);	
	Иначе
		ТД.Показать();
	КонецЕсли;
	
	//Контрольный Лист
	Если ПечататьКонтрольныйЛист Тогда
		ТД=Новый ТабличныйДокумент;
		ПутевойЛист.ПолучитьОбъект().ПечатьКонтрольногоЛиста(ТД);
		ТД.ОриентацияСтраницы=ОриентацияСтраницы.Портрет;
		Если ПечататьСразу Тогда
			ТД.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);	
		Иначе
			ТД.Показать();
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИРаспечатать(Команда)
	
	Если Не ЗначениеЗаполнено(Водитель) Тогда
		//Сообщить("Сначало выберите Водителя");
		Возврат;
	КонецЕсли;
	
	СоздатьПутевойЛистСЕРВЕР();
	
	ПечататьПутевойЛист(Null);
	
КонецПроцедуры

&НаКлиенте
Процедура ШКВодительПриИзменении(Элемент)
	    Данные=ШКВодитель;
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
				СохранитьИРаспечатать(Null);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		
		// Ищем Водителя		
		
		Если Не ЗначениеЗаполнено(Водитель) Тогда
			ШКВодитель=СокрЛП(Данные);
			//Ищем ШКВодителя
			Водитель=модСерверПолныеПрава.НайтиФизЛицоПоШк(ШКВодитель,"Водитель");
			Если Не ЗначениеЗаполнено(Водитель) Тогда
				//Сообщить("Водитель не найден.");
				Возврат;
			Иначе
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				               |	ДвижениеТарыВодительОстатки.УКого,
				               |	ДвижениеТарыВодительОстатки.КолОстаток
				               |ИЗ
				               |	РегистрНакопления.ДвижениеТарыВодитель.Остатки(&Дата, ) КАК ДвижениеТарыВодительОстатки
				               |ГДЕ
				               |	ДвижениеТарыВодительОстатки.УКого = &УКого";
				
				Запрос.УстановитьПараметр("УКого",Водитель);
				Запрос.УстановитьПараметр("Дата",НачалоДня(ТекущаяДата())+20);
				
				Результат = Запрос.Выполнить();
				Выборка = Результат.Выбрать();
				Если Выборка.Количество()>0 Тогда 
					Выборка.Следующий();
					
					//Сообщить("Водитель "+Водитель+" не сдал тару" + Выборка.КолОстаток+" шт. Сначала сдайте тару");
					//Водитель="";
					
				Иначе	
				КонецЕсли;
				Автомобиль=Водитель.Автомобиль;
			КонецЕсли;
			//ВодительНайден
			// Ищем путевой Лист Для Водителя На текущую Дату
			ПоискПутевойЛист=Неопределено;//модСерверПолныеПрава.НайтиПутевойЛист_2(Водитель,Дата);
			Если ПоискПутевойЛист<>Неопределено Тогда
				ПутевойЛист=ПоискПутевойЛист;
				Если ЗначениеЗаполнено(ПутевойЛист.Автомобиль) Тогда
					Автомобиль=ПутевойЛист.Автомобиль;
				КонецЕсли;
				//Заполняем список сборок
				ТЗбяс=ПутевойЛист.Данные.Выгрузить();
				ТЗбяс.Свернуть("ДокументПрихода");
				Для Каждого стр_ТЗбяс ИЗ ТЗбяс Цикл
					новаяСтр=СписокБЯС.Добавить();
					новаяСтр.ДокБЯС=стр_ТЗбяс.ДокументПрихода;
				КонецЦикла;
				//Заполняем список ВозвратныхСФ
				ТЗвсф=ПутевойЛист.ВозвратныеСФ.Выгрузить();
				ТЗвсф.Свернуть("ВозвратнаяСФ");
				Для Каждого стр_ТЗвсф Из ТЗвсф Цикл
					новаяСтр=СписокВозвратныхСФ.Добавить();
					новаяСтр.ДокВозвратнаяСФ=стр_ТЗвсф.ВозвратнаяСФ;	
				КонецЦикла;
				
			КонецЕсли;
			ОчиститьСообщения();
			Возврат;
		КонецЕсли;
		
		// Ищем Документ
		ШКДокумент = Лев(Данные, 12);
		ШКДокументПриИзменении(Null);
		ПроверитьМТС();

КонецПроцедуры

&НаСервере
Процедура ПутевойЛистПриИзмененииНаСервере()
	//Заполняем список сборок
	ТЗбяс=ПутевойЛист.Данные.Выгрузить();
	ТЗбяс.Свернуть("ДокументПрихода");
	Для Каждого стр_ТЗбяс ИЗ ТЗбяс Цикл
		новаяСтр=СписокБЯС.Добавить();
		новаяСтр.ДокБЯС=стр_ТЗбяс.ДокументПрихода;
	КонецЦикла;
	//Заполняем список ВозвратныхСФ
	ТЗвсф=ПутевойЛист.ВозвратныеСФ.Выгрузить();
	ТЗвсф.Свернуть("ВозвратнаяСФ");
	Для Каждого стр_ТЗвсф Из ТЗвсф Цикл
		новаяСтр=СписокВозвратныхСФ.Добавить();
		новаяСтр.ДокВозвратнаяСФ=стр_ТЗвсф.ВозвратнаяСФ;	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПутевойЛистПриИзменении(Элемент)
	ПутевойЛистПриИзмененииНаСервере();
КонецПроцедуры


