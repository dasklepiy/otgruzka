﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	//Если НЕ ЭтоНовый() Тогда  // Удаляем Движения Если не новый
	//	НаборДвижений=РегистрыНакопления.ЗонаОтгрузки.СоздатьНаборЗаписей();
	//	НаборДвижений.Отбор.Регистратор.Установить(Ссылка);
	//	НаборДвижений.Записать();
	//КонецЕсли;
	
	Движения.ЗонаОтгрузки.Записывать = Истина;
	
	ТЗСборки=СчетФактуры.Выгрузить();
	ТЗСборки.Свернуть("ДокБЯС");
	
	
	Для Каждого стр_ТЗСборки Из ТЗСборки Цикл 
		
		ДокБЯС=стр_ТЗСборки.ДокБЯС;
		
		Если ЗначениеЗаполнено(ДокБЯС) Тогда
					Для Каждого ТекСтрокаМестаОтгрузки Из ДокБЯС.МестаОтгрузки Цикл
						
						Движение = Движения.ЗонаОтгрузки.Добавить();
						Движение.ВидДвижения 		= ВидДвиженияНакопления.Расход;
						Движение.Период 			= ДокБЯС.Дата;
						Движение.ДокументПрихода	= ДокБЯС.Ссылка;
						Движение.НомерМестаОтгрузки	= ТекСтрокаМестаОтгрузки.МестоОтгрузки;
						Движение.КоличествоКоробок	= ТекСтрокаМестаОтгрузки.КоличествоКоробок;
						//Движение.Объем				= ДокБЯС.ОбщийОбъем;
						//Движение.Вес				= ДокБЯС.ОбщийВес;
					
					КонецЦикла;
		//Ставим Дату Отгрузки
				ДокБЯСОбъект=ДокБЯС.ПолучитьОбъект();
				ДокБЯСОбъект.Реестр=ЭтотОбъект.Ссылка;
				ДокБЯСОбъект.КонецОтгрузки =ЭтотОбъект.ДатаОтгрузки;
				ДокБЯСОбъект.Записать(РежимЗаписиДокумента.Запись);
		
		КонецЕсли;
		
		
		
	//----------------------- УСТАРЕЛО -------------------------//	
		
		//Если ПроводитьТолькоСуществующие Тогда	
		//	Если ЗначениеЗаполнено(ДокБЯС.Коробки) Тогда
		//		// регистр ЗонаОтгрузки Расход
		//		// Только если были движения по Приходу по Этому БЯС
		//		
		//		Запрос = Новый Запрос;
		//		Запрос.Текст = 
		//		"ВЫБРАТЬ
		//		|	ЗонаОтгрузкиОбороты.ДокументПрихода,
		//		|	ЗонаОтгрузкиОбороты.КоличествоКоробокПриход
		//		|ИЗ
		//		|	РегистрНакопления.ЗонаОтгрузки.Обороты(, , Регистратор, ) КАК ЗонаОтгрузкиОбороты
		//		|ГДЕ
		//		|	ЗонаОтгрузкиОбороты.Регистратор = &Регистратор
		//		|	И ЗонаОтгрузкиОбороты.КоличествоКоробокПриход > 0";
		//		
		//		Запрос.УстановитьПараметр("Регистратор", ДокБЯС);
		//		
		//		Результат = Запрос.Выполнить();
		//		
		//		Если Не Результат.Пустой() Тогда
		//			
		//			
		//			Для Каждого ТекСтрокаМестаОтгрузки Из ДокБЯС.МестаОтгрузки Цикл
		//				
		//				Движение = Движения.ЗонаОтгрузки.Добавить();
		//				Движение.ВидДвижения 		= ВидДвиженияНакопления.Расход;
		//				Движение.Период 			= ДокБЯС.Дата;
		//				Движение.ДокументПрихода	= ДокБЯС.Ссылка;
		//				Движение.НомерМестаОтгрузки	= ТекСтрокаМестаОтгрузки.МестоОтгрузки;
		//				Движение.КоличествоКоробок	= ТекСтрокаМестаОтгрузки.КоличествоКоробок;
		//				Движение.Объем				= ДокБЯС.ОбщийОбъем;
		//				Движение.Вес				= ДокБЯС.ОбщийВес;
		//				
		//				//Ставим Дату Отгрузки
		//				ДокБЯСОбъект=ДокБЯС.ПолучитьОбъект();
		//				ДокБЯСОбъект.Реестр=ЭтотОбъект.Ссылка;
		//				ДокБЯСОбъект.КонецОтгрузки =ЭтотОбъект.ДатаОтгрузки;
		//				ДокБЯСОбъект.Записать(РежимЗаписиДокумента.Запись);
		//			КонецЦикла;
		//			
		//		КонецЕсли;	
		//		
		//		
		//	КонецЕсли;
		//	
		//Иначе // Списываем только если есть в зоне отгрузки
		//	
		//		Запрос = Новый Запрос;
		//		Запрос.Текст = 
		//		"ВЫБРАТЬ
		//		|	ЗонаОтгрузкиОстатки.ДокументПрихода,
		//		|	ЗонаОтгрузкиОстатки.КоличествоКоробокОстаток
		//		|ИЗ
		//		|	РегистрНакопления.ЗонаОтгрузки.Остатки(, ДокументПрихода = &ДокБЯС) КАК ЗонаОтгрузкиОстатки
		//		|ГДЕ
		//		|	ЗонаОтгрузкиОстатки.КоличествоКоробокОстаток > 0";
		//		
		//		Запрос.УстановитьПараметр("ДокБЯС", ДокБЯС);
		//		
		//		Результат = Запрос.Выполнить();

		//		Если Не Результат.Пустой() Тогда // Есть Остатки (Есть Что Списывать)	
		//					
		//			Для Каждого ТекСтрокаМестаОтгрузки Из ДокБЯС.МестаОтгрузки Цикл
		//				
		//				Движение = Движения.ЗонаОтгрузки.Добавить();
		//				Движение.ВидДвижения 		= ВидДвиженияНакопления.Расход;
		//				Движение.Период 			= ДокБЯС.Дата;
		//				Движение.ДокументПрихода	= ДокБЯС.Ссылка;
		//				Движение.НомерМестаОтгрузки	= ТекСтрокаМестаОтгрузки.МестоОтгрузки;
		//				Движение.КоличествоКоробок	= ТекСтрокаМестаОтгрузки.КоличествоКоробок;
		//				//Движение.Объем				= ДокБЯС.ОбщийОбъем;
		//				//Движение.Вес				= ДокБЯС.ОбщийВес;
		//				
		//				//Ставим Дату Отгрузки
		//				ДокБЯСОбъект=ДокБЯС.ПолучитьОбъект();
		//				ДокБЯСОбъект.Реестр=ЭтотОбъект.Ссылка;
		//				ДокБЯСОбъект.КонецОтгрузки =ЭтотОбъект.ДатаОтгрузки;
		//				ДокБЯСОбъект.Записать(РежимЗаписиДокумента.Запись);
		//			КонецЦикла;
		//		КонецЕсли;
		//		
		//КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если НЕ Сформирован Тогда
		
		//------ Формируем ГруппировкуСчетФактур АСКЛЕПИЙ + Проект 1000 ------------//
		ЭтотОбъект.ГруппировкаСчетФактурАСКЛЕПИЙ.Очистить();
		//------------------------- АСКЛЕПИЙ ---------------------------------//
		Отбор=Новый Структура;
		Отбор.Вставить("Организация",Справочники.РеестрОрганизации.НайтиПоКоду(42));
		//Отбор.Вставить("Организация",Справочники.РеестрОрганизации.НайтиПоКоду(48));

		ТЗсф=СчетФактуры.Выгрузить(Отбор);	
		ТЗ=ТЗсф.Скопировать();
		// ТЗ.Свернуть("Город,Организация,КонтрагентРеестра,ДокБЯС","СуммаДокумента,КоличествоМест,Объем,Поддон");
		ТЗ.Свернуть("Город,Организация,КонтрагентРеестра","СуммаДокумента,КоличествоМест,Объем,Поддон");
		//Номера СчетФ
		ТЗ.Колонки.Добавить("НомераСчетФактур");
		ТЗ.Колонки.Добавить("КодКонтрагента");
		
		Для Каждого стр_ТЗ из ТЗ Цикл
			Отбор=Новый Структура;
			Отбор.Вставить("КонтрагентРеестра",стр_ТЗ.КонтрагентРеестра);
			масСтрок=ТЗсф.НайтиСтроки(Отбор);
			номераСФ="";
			Для Каждого эл_масСтрок Из масСтрок Цикл
				номераСФ=номераСФ+эл_масСтрок.НомерСчетФактуры+", ";	
			КонецЦикла;
			номераСФ=Лев(номераСФ,СтрДлина(номераСФ)-2);
			стр_ТЗ.НомераСчетФактур=номераСФ;
			стр_ТЗ.КодКонтрагента=стр_ТЗ.КонтрагентРеестра.КодКонтрагента;
			
		КонецЦикла;
		ТЗ.Сортировать("Город,КодКонтрагента");
		//ЭтотОбъект.ГруппировкаСчетФактурАСКЛЕПИЙ.Загрузить(ТЗ);
		//------------------------------------------------------------------------------//		
		//------------------------- ПРОЕКТ 1000 ---------------------------------//
		Отбор=Новый Структура;
		//Отбор.Вставить("Организация",Справочники.РеестрОрганизации.НайтиПоКоду(42));
		Отбор.Вставить("Организация",Справочники.РеестрОрганизации.НайтиПоКоду(48));

		ТЗсф1000=СчетФактуры.Выгрузить(Отбор);	
		ТЗ1000=ТЗсф1000.Скопировать();
		// ТЗ.Свернуть("Город,Организация,КонтрагентРеестра,ДокБЯС","СуммаДокумента,КоличествоМест,Объем,Поддон");
		ТЗ1000.Свернуть("Город,Организация,КонтрагентРеестра","СуммаДокумента,КоличествоМест,Объем,Поддон");
		//Номера СчетФ
		ТЗ1000.Колонки.Добавить("НомераСчетФактур");
		ТЗ1000.Колонки.Добавить("КодКонтрагента");
		
		Для Каждого стр_ТЗ из ТЗ1000 Цикл
			Отбор=Новый Структура;
			Отбор.Вставить("КонтрагентРеестра",стр_ТЗ.КонтрагентРеестра);
			масСтрок=ТЗсф1000.НайтиСтроки(Отбор);
			номераСФ="";
			Для Каждого эл_масСтрок Из масСтрок Цикл
				номераСФ=номераСФ+эл_масСтрок.НомерСчетФактуры+", ";	
			КонецЦикла;
			номераСФ=Лев(номераСФ,СтрДлина(номераСФ)-2);
			стр_ТЗ.НомераСчетФактур=номераСФ;
			стр_ТЗ.КодКонтрагента=стр_ТЗ.КонтрагентРеестра.КодКонтрагента;
			
		КонецЦикла;
		//---------------- Добавляем Проект 1000 к Асклепий ----------------------//
		        Для Каждого стр_ТЗ Из ТЗ1000 Цикл
			новаяСтрока=ТЗ.Добавить();
			новаяСтрока.Город=стр_ТЗ.Город;
			новаяСтрока.Организация=стр_ТЗ.Организация;
			новаяСтрока.КонтрагентРеестра=стр_ТЗ.КонтрагентРеестра;
			новаяСтрока.СуммаДокумента=стр_ТЗ.СуммаДокумента;
			новаяСтрока.КоличествоМест=стр_ТЗ.КоличествоМест;
			новаяСтрока.Объем=стр_ТЗ.Объем;
			новаяСтрока.Поддон=стр_ТЗ.Поддон;
			
			новаяСтрока.НомераСчетФактур=стр_ТЗ.НомераСчетФактур;
			новаяСтрока.КодКонтрагента=стр_ТЗ.КодКонтрагента;
			
		КонецЦикла;
        	
		ТЗ.Сортировать("Город,КодКонтрагента");
		ЭтотОбъект.ГруппировкаСчетФактурАСКЛЕПИЙ.Загрузить(ТЗ);
		//------------------------------------------------------------------------------//		
		
		
		//----------- Формируем ГруппировкуСчетФактур НФС + OXYMED ---------------------//
		ЭтотОбъект.ГруппировкаСчетФактурНФС.Очистить();
		
		Отбор=Новый Структура;
		Отбор.Вставить("Организация",Справочники.РеестрОрганизации.НайтиПоКоду(41));
		
		ТЗсф1=СчетФактуры.Выгрузить(Отбор);	
		ТЗ1=ТЗсф1.Скопировать();
		
		//ТЗ1.Свернуть("Город,Организация,КонтрагентРеестра,ДокБЯС","СуммаДокумента,КоличествоМест,Объем,Поддон");
		ТЗ1.Свернуть("Город,Организация,КонтрагентРеестра","СуммаДокумента,КоличествоМест,Объем,Поддон");
		
		//ЭтотОбъект.ГруппировкаСчетФактурНФС.Загрузить(ТЗ);
		//Номера СчетФ
		ТЗ1.Колонки.Добавить("НомераСчетФактур");
		ТЗ1.Колонки.Добавить("КодКонтрагента");
		
		Для Каждого стр_ТЗ1 из ТЗ1 Цикл
			Отбор=Новый Структура;
			Отбор.Вставить("КонтрагентРеестра",стр_ТЗ1.КонтрагентРеестра);
			масСтрок=ТЗсф1.НайтиСтроки(Отбор);
			номераСФ="";
			Для Каждого эл_масСтрок Из масСтрок Цикл
				номераСФ=номераСФ+эл_масСтрок.НомерСчетФактуры+", ";	
			КонецЦикла;
			номераСФ=Лев(номераСФ,СтрДлина(номераСФ)-2);
			стр_ТЗ1.НомераСчетФактур=номераСФ;
			стр_ТЗ1.КодКонтрагента=стр_ТЗ1.КонтрагентРеестра.КодКонтрагента;
			
		КонецЦикла;
		
		
		
		Отбор=Новый Структура;
		Отбор.Вставить("Организация",Справочники.РеестрОрганизации.НайтиПоКоду(40));
		ТЗсф2=СчетФактуры.Выгрузить(Отбор);	
		ТЗ2=ТЗсф2.Скопировать();	
		//ТЗ2.Свернуть("Город,Организация,КонтрагентРеестра,ДокБЯС","СуммаДокумента,КоличествоМест,Объем,Поддон");
		ТЗ2.Свернуть("Город,Организация,КонтрагентРеестра","СуммаДокумента,КоличествоМест,Объем,Поддон");
		
		//Номера СчетФ
		ТЗ2.Колонки.Добавить("НомераСчетФактур");
		ТЗ2.Колонки.Добавить("КодКонтрагента");
		
		Для Каждого стр_ТЗ2 из ТЗ2 Цикл
			Отбор=Новый Структура;
			Отбор.Вставить("КонтрагентРеестра",стр_ТЗ2.КонтрагентРеестра);
			масСтрок=ТЗсф2.НайтиСтроки(Отбор);
			номераСФ="";
			Для Каждого эл_масСтрок Из масСтрок Цикл
				номераСФ=номераСФ+эл_масСтрок.НомерСчетФактуры+", ";	
			КонецЦикла;
			номераСФ=Лев(номераСФ,СтрДлина(номераСФ)-2);
			стр_ТЗ2.НомераСчетФактур=номераСФ;
			стр_ТЗ2.КодКонтрагента=стр_ТЗ2.КонтрагентРеестра.КодКонтрагента;
			
		КонецЦикла;
		
		Для Каждого стр_ТЗ2 Из ТЗ2 Цикл
			новаяСтрока=ТЗ1.Добавить();
			новаяСтрока.Город=стр_ТЗ2.Город;
			новаяСтрока.Организация=стр_ТЗ2.Организация;
			новаяСтрока.КонтрагентРеестра=стр_ТЗ2.КонтрагентРеестра;
			//новаяСтрока.ДокБЯС=стр_ТЗ2.ДокБЯС;
			новаяСтрока.СуммаДокумента=стр_ТЗ2.СуммаДокумента;
			новаяСтрока.КоличествоМест=стр_ТЗ2.КоличествоМест;
			новаяСтрока.Объем=стр_ТЗ2.Объем;
			новаяСтрока.Поддон=стр_ТЗ2.Поддон;
			
			новаяСтрока.НомераСчетФактур=стр_ТЗ2.НомераСчетФактур;
			новаяСтрока.КодКонтрагента=стр_ТЗ2.КодКонтрагента;
			
		КонецЦикла;
		
		ТЗ1.Сортировать("Город,КодКонтрагента");
		ЭтотОбъект.ГруппировкаСчетФактурНФС.Загрузить(ТЗ1);
		
		Сформирован=Истина;
		ДатаФормирования=ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры
