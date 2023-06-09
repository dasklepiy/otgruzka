﻿ 
  Процедура ПослатьСообщениеПользователюСЕРВЕР(РезультатПроверки,Отладка=ЛОЖЬ) Экспорт
	 
	//Проверяем наличие сообщений
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СообщенияПользователям.Ссылка,
	               |	СообщенияПользователям.ДатаНачала,
	               |	СообщенияПользователям.ДатаОкончания,
	               |	СообщенияПользователям.ДатаПоследнейОтправки,
	               |	СообщенияПользователям.ИнтервалОтправки,
	               |	СообщенияПользователям.ИсточникСообщения,
	               |	СообщенияПользователям.КоличествоПовторов,
	               |	СообщенияПользователям.КоличествоПосланныхСообщений,
	               |	СообщенияПользователям.Кому.Наименование,
	               |	СообщенияПользователям.ТекстСообщения
	               |ИЗ
	               |	Справочник.СообщенияПользователям КАК СообщенияПользователям
	               |ГДЕ
	               |	СообщенияПользователям.Кому.Код = &КодПользователя
	               |	И СообщенияПользователям.Активность = &Активность" ;
		
	Запрос.УстановитьПараметр("Активность", Истина);
	Запрос.УстановитьПараметр("КодПользователя", ИмяПользователя());

	Результат = Запрос.Выполнить();

	Если Результат.Пустой() Тогда
		РезультатПроверки=Неопределено;
		//Если Отладка Тогда
		//	//++++++++++ ОТЛАДКА +++++++++++++++++++++//
		//	Комментарий	="Кол. сообщений ПУСТО(ЗАПРОС)- "+ИмяПользователя();
		//	ЗаписьЖурналаРегистрации("ОТЛАДКА-ОТПРАВКА СООБЩЕНИЙ",УровеньЖурналаРегистрации.Информация, , ,Комментарий);
		//	//++++++++++++++++++++++++++++++++++++++++//
		//КонецЕсли;

		Возврат;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	масСообщений=Новый Массив;
	
	Если Отладка Тогда
			//++++++++++ ОТЛАДКА +++++++++++++++++++++//
			Комментарий	="Кол. сообщений В ЗАПРОСЕ - "+ Строка(ВыборкаДетальныеЗаписи.Количество());
			ЗаписьЖурналаРегистрации("ОТЛАДКА-ОТПРАВКА СООБЩЕНИЙ",УровеньЖурналаРегистрации.Информация, , ,Комментарий);
			//++++++++++++++++++++++++++++++++++++++++//
	КонецЕсли;

	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗакрытьСообщение=Ложь;
		//Проверка Сообщения
		
		//Проверка на дату начала
		 Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ДатаНачала) Тогда
				Если ВыборкаДетальныеЗаписи.ДатаНачала>ТекущаяДата() Тогда // Еще Рано для выполнения
					Продолжить;
				КонецЕсли;
				
		 КонецЕсли;
		//------------------------
		
		//Проверка на Дату Окончания
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ДатаОкончания) Тогда
			Если ВыборкаДетальныеЗаписи.ДатаОкончания<=ТекущаяДата() Тогда
				омСообщенияПользователям.ЗакрытьСообщениеПользователюСЕРВЕР(ВыборкаДетальныеЗаписи.Ссылка,"ПоДатеОкончания");
				
				Если Отладка Тогда
					//++++++++++ ОТЛАДКА +++++++++++++++++++++//
					Комментарий	="Закрыто по ПоДатеОкончания";
					ЗаписьЖурналаРегистрации("ОТЛАДКА-ОТПРАВКА СООБЩЕНИЙ",УровеньЖурналаРегистрации.Информация, , ,Комментарий);
					//++++++++++++++++++++++++++++++++++++++++//
				КонецЕсли;
				
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		//Проверка на кол повторов
		Если  ВыборкаДетальныеЗаписи.КоличествоПовторов<>0 Тогда
			Если ВыборкаДетальныеЗаписи.КоличествоПовторов<=ВыборкаДетальныеЗаписи.КоличествоПосланныхСообщений Тогда 
				 омСообщенияПользователям.ЗакрытьСообщениеПользователюСЕРВЕР(ВыборкаДетальныеЗаписи.Ссылка,"ПоКоличествуПовторов");
				 
				 Если Отладка Тогда
					 //++++++++++ ОТЛАДКА +++++++++++++++++++++//
					 Комментарий	="Закрыто по ПоКоличествуПовторов";
					 ЗаписьЖурналаРегистрации("ОТЛАДКА-ОТПРАВКА СООБЩЕНИЙ",УровеньЖурналаРегистрации.Информация, , ,Комментарий);
					 //++++++++++++++++++++++++++++++++++++++++//
				 КонецЕсли;
			 
				 Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		// Проверка на Интервал
		
		Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ДатаПоследнейОтправки) Тогда  //Первая Отправка
		//Формируем Сообщение
		 элСообщения=омСообщенияПользователям.ФормироватьСообщениеПользователюСЕРВЕР(ВыборкаДетальныеЗаписи.Ссылка);
		 масСообщений.Добавить(элСообщения);
		 Продолжить;
		КонецЕсли;
		
		
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ДатаПоследнейОтправки) Тогда
			Если (ВыборкаДетальныеЗаписи.ДатаПоследнейОтправки+ВыборкаДетальныеЗаписи.ИнтервалОтправки)<=ТекущаяДата() Тогда
				//Формируем Сообщение
				элСообщения=омСообщенияПользователям.ФормироватьСообщениеПользователюСЕРВЕР(ВыборкаДетальныеЗаписи.Ссылка);
				масСообщений.Добавить(элСообщения);
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		
		
	КонецЦикла;

	Если Отладка Тогда
		//++++++++++ ОТЛАДКА +++++++++++++++++++++//
		Комментарий	="Кол. сообщений в массиве -"+Строка(масСообщений.Количество());
		ЗаписьЖурналаРегистрации("ОТЛАДКА-ОТПРАВКА СООБЩЕНИЙ",УровеньЖурналаРегистрации.Информация, , ,Комментарий);
		//++++++++++++++++++++++++++++++++++++++++//
	КонецЕсли;

РезультатПроверки=масСообщений;	
		 
	 
КонецПроцедуры

Функция  ФормироватьСообщениеПользователюСЕРВЕР(элСправочника) Экспорт
	//элСправочника=Справочники.СообщенияПользователям.НайтиПоКоду(1);
	элСПР=элСправочника.ПолучитьОбъект();
	элСПР.ДатаПоследнейОтправки=ТекущаяДата();
	элСПР.КоличествоПосланныхСообщений=	элСПР.КоличествоПосланныхСообщений+1;
	элСПР.Записать();
	элСообщения=Новый Структура;
    элСообщения.Вставить("ТекстСообщения",элСПР.ТекстСообщения);
	элСообщения.Вставить("ИсточникСообщения",элСПР.ИсточникСообщения);
	элСообщения.Вставить("КоличествоПосланныхСообщений",элСПР.КоличествоПосланныхСообщений);
    элСообщения.Вставить("ВидСообщения",элСПР.ВидСообщения);

	Возврат элСообщения;
КонецФункции

	


Процедура ЗакрытьСообщениеПользователюСЕРВЕР(элСправочника,ТипЗакрытия) Экспорт
	//элСправочника=Справочники.СообщенияПользователям.НайтиПоКоду(1);
	
	элСПР=элСправочника.ПолучитьОбъект();
	элСПР.Активность=Ложь;
	
	Если ТипЗакрытия="ПоДатеОкончания" Тогда
		элСПР.СистемныйКомментарий="ЗАКРЫТО! По ДатеОкончания";
	ИначеЕсли 	 ТипЗакрытия="ПоКоличествуПовторов" Тогда
		элСПР.СистемныйКомментарий="ЗАКРЫТО! По КоличествуПовторов";
	КонецЕсли;
	
	элСПР.Записать();
	
		
КонецПроцедуры
 