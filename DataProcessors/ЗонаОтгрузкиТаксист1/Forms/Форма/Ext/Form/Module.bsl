﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Объект.МестоОтгрузки="";
	Объект.Дата=ТекущаяДата();
	НаСкладе.Параметры.УстановитьЗначениеПараметра("Дата",Объект.Дата);
	ВАптеке.Параметры.УстановитьЗначениеПараметра("Дата",Объект.Дата);
	УВодителя.Параметры.УстановитьЗначениеПараметра("Дата",Объект.Дата);
	ФФ=ФФПроверитьНаЗаполнение();
	ТекущийЭлемент=Элементы.ШК;
КонецПроцедуры
&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	ФФ=ФФЗаписатьДокументRR();
	ТекущийЭлемент=Элементы.ШК;
КонецПроцедуры
&НаКлиенте
Функция ФФЗаписатьДокументRR()
	Если Объект.КолКоробок=0 тогда
		Сообщить ("Укажите количество коробок");
		Возврат 0;
	КонецЕсли;	
	Если не ЗначениеЗаполнено(Объект.МестоОтгрузки) тогда
		Сообщить ("Укажите место отгрузки");
		Возврат 0;
	КонецЕсли;
	Если не ЗначениеЗаполнено(Объект.Док) тогда
		Сообщить ("Не выбран документ");
		Возврат 0;
	КонецЕсли;
	
//-------------------------------------------------------------//	
	Если Объект.Док.Коробки>0 Тогда
		Режим = РежимДиалогаВопрос.ОКОтмена;
		//Ответ=Вопрос("В документе уже есть места отгрузки. Вы хотите добавить или исправить? Если добавить нажмите ОК иначе ОТМЕНА",Режим,0);
		СписокКнопок=Новый СписокЗначений;
		СписокКнопок.Добавить("ИСПРАВИТЬ","ИСПРАВИТЬ");
		СписокКнопок.Добавить("ДОБАВИТЬ","ДОБАВИТЬ");
		СписокКнопок.Добавить("ОТМЕНА","ОТМЕНА");
		Ответ=Вопрос("В документе уже есть места отгрузки. Вы хотите исправить или добавить?", СписокКнопок,,"ОТМЕНА") ;
		Если Ответ = "ОТМЕНА" Тогда
			Возврат 0;
		КонецЕсли;
		
	иначе
		//Сообщить("Коробок не может быть менше 1")
	КонецЕсли;
//-------------------------------------------------------------//	
	
	ФФЗаписатьДокументSS(Ответ);
	ТД.Очистить();
	ФФПроверитьНаЗаполнение();
	ТекущийЭлемент=Элементы.ШК;
КонецФункции // ()
&НаСервере
Функция ФФЗаписатьДокументSS(ТипРедактирования)
	ОбъектДок=Объект.Док.ПолучитьОбъект();
	Если ТипРедактирования="ИСПРАВИТЬ" Тогда
		ОбъектДок.МестаОтгрузки.Очистить();	
	КонецЕсли;
	Стр=ОбъектДок.МестаОтгрузки.Добавить();
	
	Стр.КоличествоКоробок=Объект.КолКоробок;
	Стр.МестоОтгрузки=Объект.МестоОтгрузки;
	ОбъектДок.Коробки=ОбъектДок.МестаОтгрузки.Итог("КоличествоКоробок");
	ОбъектДок.Самовывоз=Объект.Самовывоз;
	ОбъектДок.КолТара=Объект.КолТара;
    ОбъектДок.Записать(РежимЗаписиДокумента.Проведение);
	ТекущийЭлемент=Элементы.ШК;
КонецФункции // ()
&НаКлиенте
Процедура ТДПриАктивизацииОбласти(Элемент)
	ТекЯчейка=Элемент.ТекущаяОбласть;
	Если ЗначениеЗаполнено(Объект.Док) тогда
	Если Объект.Док.Направление.Код="100" или не ЗначениеЗаполнено(Объект.Док.Направление) тогда
		БукваМХ=ТД.ПолучитьОбласть(ТекЯчейка.Верх,1).ТекущаяОбласть.Текст;
		ЦифраМХ=ТД.ПолучитьОбласть(1,ТекЯчейка.Лево).ТекущаяОбласть.Текст;
		Если БукваМХ="Д" тогда
			ЦифраМХ=ТД.ПолучитьОбласть(25,ТекЯчейка.Лево).ТекущаяОбласть.Текст;
			МХ=БукваМХ + ЦифраМХ;
		Иначе	
			МХ=БукваМХ + ЦифраМХ;
		КонецЕсли;
	Иначе
		БукваМХ="ОБЛ"; 
		Если  ТекЯчейка.Верх>11 Тогда
		ЦифраМХ=ТД.ПолучитьОбласть(16,ТекЯчейка.Лево).ТекущаяОбласть.Текст;
		Иначе
		ЦифраМХ=ТД.ПолучитьОбласть(3,ТекЯчейка.Лево).ТекущаяОбласть.Текст;
		КонецЕсли;	
		Если БукваМХ="Д" тогда
			ЦифраМХ=ТД.ПолучитьОбласть(25,ТекЯчейка.Лево).ТекущаяОбласть.Текст;
			МХ=БукваМХ + ЦифраМХ;
		Иначе	
			МХ=БукваМХ + ЦифраМХ;
		КонецЕсли;
	КонецЕсли;
	ФФ=ФФТДПриАктивизацииОбласти(МХ);
	КонецЕсли;
	ТекущийЭлемент=Элементы.ШК;
КонецПроцедуры
&НаКлиенте
Функция ФФТДПриАктивизацииОбласти(МХ)
	Попытка
		Текущая=ТД.Область("Текущая");
		Если МХ<>"" тогда
			ТекОбл=ТД.Область(МХ);
			ТекОбл.ЦветФона=Текущая.ЦветФона;   
		КонецЕсли;
		Объект.МестоОтгрузки=Справочники.МестаХранения.НайтиПоНаименованию(МХ);
	Исключение
	КонецПопытки;
	ТекущийЭлемент=Элементы.ШК;
КонецФункции 
&НаКлиенте
Функция ФФПроверитьНаЗаполнение()
	ТД.Очистить();
	Попытка
		Если Объект.Док.Направление.Код="100" или не ЗначениеЗаполнено(Объект.Док.Направление) тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	ЗонаОтгрузкиОстатки.НомерМестаОтгрузки,
			|	ЗонаОтгрузкиОстатки.ДокументПрихода,
			|	ЗонаОтгрузкиОстатки.КоличествоКоробокОстаток
			|ИЗ
			|	РегистрНакопления.ЗонаОтгрузки.Остатки КАК ЗонаОтгрузкиОстатки
			|ГДЕ
			|	ЗонаОтгрузкиОстатки.КоличествоКоробокОстаток > 0
			|	И ЗонаОтгрузкиОстатки.НомерМестаОтгрузки.Палет = ЛОЖЬ
			|	И ЗонаОтгрузкиОстатки.ДокументПрихода.Направление.Код = ""100""";
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			Макет=Обработки.ЗонаОтгрузкиТаксист.ПолучитьМакет("Макет");
			ОТГРУЗКА=Макет.ПолучитьОбласть("ОТГРУЗКА");
			ТД.Вывести(ОТГРУЗКА);
			НФС=ТД.Область("НФС");
			АСК=ТД.Область("АСК");
			Пока Выборка.Следующий() Цикл 
				МХ=СокрЛП(Выборка.НомерМестаОтгрузки.Наименование);
				Если Лев(МХ,3)="сек" тогда
					МХ=Лев(МХ,3)+Прав(МХ,1);
				КонецЕсли; 
				Если Лев(МХ,1)="Ж" тогда
					НЯ=Число(Прав(МХ,СтрДлина(МХ)-1));
					Если  НЯ < 9 Тогда
						МХ="Возврат";
					Иначе
						МХ="Аптека";
					КонецЕсли;  
				КонецЕсли; 
				ТекОбл=ТД.Область(МХ);
				Коробок=ТД.Область(ТекОбл.Верх,ТекОбл.Лево);
				Если Коробок.Текст <> "" тогда
					ЧКоробок=Число(Коробок.Текст)+Выборка.КоличествоКоробокОстаток;
				Иначе 
					ЧКоробок=Выборка.КоличествоКоробокОстаток;
				КонецЕсли;
				Коробок.Текст=ЧКоробок;
				Коробок.Примечание.Текст=Коробок.Примечание.Текст+Выборка.ДокументПрихода+Символы.ПС+"Счет-фактуры"+Выборка.ДокументПрихода.НомераСФ+" "+Выборка.КоличествоКоробокОстаток+" мест"+Символы.ПС+Символы.ПС;
				Клиентов=ТД.Область(ТекОбл.Верх+1,ТекОбл.Лево);
				
				Если Клиентов.Текст <> "" тогда 
					ЧКоробок=Число(Клиентов.Текст)+1;
				Иначе 
					ЧКоробок=1;
				КонецЕсли;
				Клиентов.Текст=ЧКоробок;
				Клиентов.Примечание.Текст=Клиентов.Примечание.Текст+Выборка.ДокументПрихода.Получатель+" "+Выборка.КоличествоКоробокОстаток+" мест"+Символы.ПС;
				Время=ТД.Область(ТекОбл.Верх+2,ТекОбл.Лево); 
				Начало=Выборка.ДокументПрихода.НачалоОтгрузки;
				Ч=Цел((ТекущаяДата()-Начало)/60/60);
				М=Цел((ТекущаяДата()-Начало)/60)-Ч*60;
				
				Если Время.Текст<>"" тогда
					ТекЧ=Число(Лев(Время.Текст,Найти(Время.Текст," ")-1)); 
					Если Ч>ТекЧ тогда
						
					КонецЕсли;	 
				Иначе
					
				КонецЕсли;	
				
				
				ЧКоробок=Строка(Ч)+" ч. "+М+" м.";
				Время.Текст=ЧКоробок;
				Время.Примечание.Текст=Клиентов.Примечание.Текст+Выборка.ДокументПрихода.НачалоОтгрузки+Символы.ПС;
				
				Если Выборка.ДокументПрихода.Организация = "НФС" тогда
					Если ТекОбл.ЦветФона=АСК.ЦветФона тогда
						ТекОбл.ЦветФона=НФС.ЦветФона ;
						Клиентов.ЦветФона=АСК.ЦветФона ;
					Иначе
						ТекОбл.ЦветФона=НФС.ЦветФона ;
					КонецЕсли;
				Иначе
					Если ТекОбл.ЦветФона=НФС.ЦветФона тогда
						ТекОбл.ЦветФона=АСК.ЦветФона ;
						Клиентов.ЦветФона=НФС.ЦветФона ;
					Иначе
						ТекОбл.ЦветФона=АСК.ЦветФона ;
					КонецЕсли;
					ТекОбл.ЦветФона=АСК.ЦветФона ;
				КонецЕсли;  
			КонецЦикла;
		Иначе
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	ЗонаОтгрузкиОстатки.НомерМестаОтгрузки,
			|	ЗонаОтгрузкиОстатки.ДокументПрихода,
			|	ЗонаОтгрузкиОстатки.КоличествоКоробокОстаток
			|ИЗ
			|	РегистрНакопления.ЗонаОтгрузки.Остатки КАК ЗонаОтгрузкиОстатки
			|ГДЕ
			|	ЗонаОтгрузкиОстатки.КоличествоКоробокОстаток > 0
			|	И ЗонаОтгрузкиОстатки.ДокументПрихода.Направление.Код <> ""100""";
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			Макет=Обработки.ЗонаОтгрузкиТаксист.ПолучитьМакет("МакетОБЛ");
			ОТГРУЗКА=Макет.ПолучитьОбласть("ОТГРУЗКА");
			ТД.Вывести(ОТГРУЗКА);
			НФС=ТД.Область("НФС");
			АСК=ТД.Область("АСК");
			Пока Выборка.Следующий() Цикл 
				МХ=СокрЛП(Выборка.НомерМестаОтгрузки.Наименование);
				Если Лев(МХ,3)="сек" тогда
					МХ=Лев(МХ,3)+Прав(МХ,1);
				КонецЕсли; 
				Если Лев(МХ,1)="Ж" тогда
					НЯ=Число(Прав(МХ,СтрДлина(МХ)-1));
					Если  НЯ < 9 Тогда
						МХ="Возврат";
					Иначе
						МХ="Аптека";
					КонецЕсли;  
				КонецЕсли; 
				ТекОбл=ТД.Область(МХ);
				Коробок=ТД.Область(ТекОбл.Верх,ТекОбл.Лево);
				Если Коробок.Текст <> "" тогда
					ЧКоробок=Число(Коробок.Текст)+Выборка.КоличествоКоробокОстаток;
				Иначе 
					ЧКоробок=Выборка.КоличествоКоробокОстаток;
				КонецЕсли;
				Коробок.Текст=ЧКоробок;
				Коробок.Примечание.Текст=Коробок.Примечание.Текст+Выборка.ДокументПрихода+Символы.ПС+"Счет-фактуры"+Выборка.ДокументПрихода.НомераСФ+" "+Выборка.КоличествоКоробокОстаток+" мест"+Символы.ПС+Символы.ПС;
				Клиентов=ТД.Область(ТекОбл.Верх+1,ТекОбл.Лево);
				
				Если Клиентов.Текст <> "" тогда 
					ЧКоробок=Число(Клиентов.Текст)+1;
				Иначе 
					ЧКоробок=1;
				КонецЕсли;
				Клиентов.Текст=ЧКоробок;
				Клиентов.Примечание.Текст=Клиентов.Примечание.Текст+Выборка.ДокументПрихода.Получатель+" "+Выборка.КоличествоКоробокОстаток+" мест"+Символы.ПС;
				Время=ТД.Область(ТекОбл.Верх+2,ТекОбл.Лево); 
				Начало=Выборка.ДокументПрихода.НачалоОтгрузки;
				Ч=Цел((ТекущаяДата()-Начало)/60/60);
				М=Цел((ТекущаяДата()-Начало)/60)-Ч*60;
				
				Если Время.Текст<>"" тогда
					ТекЧ=Число(Лев(Время.Текст,Найти(Время.Текст," ")-1)); 
					Если Ч>ТекЧ тогда
						
					КонецЕсли;	 
				Иначе
					
				КонецЕсли;	
				
				
				ЧКоробок=Строка(Ч)+" ч. "+М+" м.";
				Время.Текст=ЧКоробок;
				Время.Примечание.Текст=Клиентов.Примечание.Текст+Выборка.ДокументПрихода.НачалоОтгрузки+Символы.ПС;
				
				Если Выборка.ДокументПрихода.Организация = "НФС" тогда
					Если ТекОбл.ЦветФона=АСК.ЦветФона тогда
						ТекОбл.ЦветФона=НФС.ЦветФона ;
						Клиентов.ЦветФона=АСК.ЦветФона ;
					Иначе
						ТекОбл.ЦветФона=НФС.ЦветФона ;
					КонецЕсли;
				Иначе
					Если ТекОбл.ЦветФона=НФС.ЦветФона тогда
						ТекОбл.ЦветФона=АСК.ЦветФона ;
						Клиентов.ЦветФона=НФС.ЦветФона ;
					Иначе
						ТекОбл.ЦветФона=АСК.ЦветФона ;
					КонецЕсли;
					ТекОбл.ЦветФона=АСК.ЦветФона ;
				КонецЕсли;  
			КонецЦикла;
			
		КонецЕсли;
		ТекущийЭлемент=Элементы.ШК;
	Исключение
	КонецПопытки;
КонецФункции 

&НаКлиенте
Процедура Обнавить(Команда)
	ТД.Очистить();
	ФФПроверитьНаЗаполнение();
	 	ТекущийЭлемент=Элементы.ШК;

КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если НЕ ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	Если Источник = "СканерШтрихкода" И Событие = "Barcode" И ЗначениеЗаполнено(Данные) Тогда
		ШК = Лев(Данные, 12);	
		Если ЗначениеЗаполнено(ШК) Тогда
			Если ЗначениеЗаполнено(СокрЛП(ШК)) Тогда
				Если 12 = СтрДлина(ШК) Тогда
					//Если мВозврат Тогда
					//	НайтиДокументыПогрузки(ШК);
					//КонецЕсли;  
					Док = НайденыйДок(ШК,ложь);
					Объект.ШК=ШК ;
					Объект.Док=Док;
					Если НЕ ЗначениеЗаполнено(Док) Тогда
						ОчиститьСообщения();
						Объект.Самовывоз=Ложь;
						Сообщить("Документ не найден!!!");
					Иначе 
						//ОткрытьЗначение(Док);
						ОчиститьСообщения();
						Объект.Самовывоз=Объект.Док.Самовывоз;
						ПроверитьОстаткиПоКлиенту(Док);
					КонецЕсли;
				Иначе
					Сообщить("Не правильно введен штрих код!! Будьте внимательны при сканировании!");
				КонецЕсли;
			Иначе
				Сообщить("Введите Штрих Код!",СтатусСообщения.ОченьВажное);
			КонецЕсли;
		ИначеЕсли Источник <> "СканерШтрихкода" И Событие = "Barcode" И ЗначениеЗаполнено(Данные) Тогда
			Сообщить("Сканер Штрих кода не подключен! Устраните неполадку!");		
		ИначеЕсли Источник = "СканерШтрихкода" И Событие = "Barcode" И НЕ ЗначениеЗаполнено(Данные) Тогда
			Сообщить("Сканер не может считать данные.");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
Процедура ПроверитьОстаткиПоКлиенту(Док)
	 //ФФПроверитьНаЗаполнение();
	Текущая=ТД.Область("Текущая");
	Клиент=Док.Получатель;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗонаОтгрузкиОстатки.НомерМестаОтгрузки,
		|	ЗонаОтгрузкиОстатки.КоличествоКоробокОстаток
		|ИЗ
		|	РегистрНакопления.ЗонаОтгрузки.Остатки(, ) КАК ЗонаОтгрузкиОстатки
		|ГДЕ
		|	ЗонаОтгрузкиОстатки.КоличествоКоробокОстаток > 0
		|	И ЗонаОтгрузкиОстатки.ДокументПрихода.Получатель = &Контрагент";

	Запрос.УстановитьПараметр("Контрагент", Клиент);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	   //Сообщить("ПОДСКАЗКА");
	   Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		  Сообщить("Товар Клиента - "+Клиент+ " Лежит на месте - "+ВыборкаДетальныеЗаписи.НомерМестаОтгрузки+" коробок - "+ВыборкаДетальныеЗаписи.КоличествоКоробокОстаток);	
		   МХ=СокрЛП(ВыборкаДетальныеЗаписи.НомерМестаОтгрузки.Наименование);
		   Если Лев(МХ,3)="сек" тогда
			   МХ=Лев(МХ,3)+Прав(МХ,1);
		   КонецЕсли; 
		   Если Лев(МХ,1)="Ж" тогда
			   НЯ=Число(Прав(МХ,СтрДлина(МХ)-1));
			   Если  НЯ < 9 Тогда
				   МХ="Возврат";
			   Иначе
				   МХ="Аптека";
			   КонецЕсли;  
		   КонецЕсли; 
		   ТекОбл=ТД.Область(МХ);
		   ТекОбл.ЦветФона=Текущая.ЦветФона;
	   КонецЦикла;
   	ТекущийЭлемент=Элементы.ШК;
	   
   КонецПроцедуры

Функция НайденыйДок(Ном, мВозврат)
	//КодДокумента = ОбщийМодуль_Каштан.ПолучитьНомерДокументаПоШК(ШК);
	
	Если Ном = Неопределено тогда
		Сообщить("Документ не найден!!!");
		Возврат Неопределено;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	БольшаяЯчеистаяСборкаДокументыРасхода.Ссылка
		|ИЗ
		|	Документ.БольшаяЯчеистаяСборка.ДокументыРасхода КАК БольшаяЯчеистаяСборкаДокументыРасхода
		|ГДЕ
		|	БольшаяЯчеистаяСборкаДокументыРасхода.ШК = &ШК";
		Запрос.УстановитьПараметр("ШК", Ном);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Возврат Выборка.Ссылка;
		Иначе
	Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВозвратнаяСчетФактура.Ссылка
			|ИЗ
			|	Документ.ВозвратнаяСчетФактура КАК ВозвратнаяСчетФактура
			|ГДЕ
			|	ВозвратнаяСчетФактура.Количество > 0
			|	И ВозвратнаяСчетФактура.ШК = &ШК";
			Запрос.УстановитьПараметр("ШК", Ном);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				БС=Документы.БольшаяЯчеистаяСборка.СоздатьДокумент();
				ЗаполнитьЗначенияСвойств(БС,Выборка.Ссылка);
				БС.Дата=ТекущаяДата();
				БС.Номер="ВОЗ"+Сред(Выборка.Ссылка.Номер,4);
				
				БС.Город=Истина;
				БС.Комментарий=Выборка.Ссылка.Комментарий;
				БС.Направление=Справочники.Направление.НайтиПоКоду("100");
				БС.НомераСФ=Выборка.Ссылка.НомерСчетфактуры;
				БС.ОбщийВес=Выборка.Ссылка.Вес;
				БС.Возврат=Истина;
				БС.ОбщийОбъем=Выборка.Ссылка.Объем;
				БС.Организация=Выборка.Ссылка.Организация;
				БС.Ответственный=Выборка.Ссылка.Ответственный;
				БС.Получатель=Выборка.Ссылка.Контрагент;
				СтрБС=БС.ДокументыРасхода.Добавить();
				СтрБС.Док=Выборка.Ссылка;
				СтрБС.СчетФ=Выборка.Ссылка.НомерСчетфактуры;
				СтрБС.ШК=Выборка.Ссылка.ШК;
				СтрБС.ДокНомер=Выборка.Ссылка.Номер;
				СтрБС.ДатаДокумента=Выборка.Ссылка.Дата;
				СтрБС.Количество=Выборка.Ссылка.Количество;
				СтрБС.Сумма=Выборка.Ссылка.Сумма;
				СтрБС.КолПозиций=Выборка.Ссылка.КолПозиций;
				СтрБС.Объем=Выборка.Ссылка.Объем;
				СтрБС.Вес=Выборка.Ссылка.Вес;
Сообщить("СоздаюДокумент" + БС.Номер);
				БС.Записать(РежимЗаписиДокумента.Проведение);
				Возврат БС.Ссылка;

			Иначе	
				Возврат Неопределено;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ШКПриИзменении(Элемент)
	Если Лев(Объект.ШК,3)="KON" Или Лев(Объект.ШК,3)="kon" Или Лев(Объект.ШК,3)="ЛЩТ"  Или Лев(Объект.ШК,3)="лщт"  тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	Тара.Ссылка
		|ИЗ
		|	Справочник.Тара КАК Тара
		|ГДЕ
		|	Тара.ШК = &ШК";
		
		Запрос.УстановитьПараметр("ШК",Объект.ШК );
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Если Выборка.Количество()>0 Тогда 
			Выборка.Следующий();
			С=0;
			Объект.Тара.Очистить();
			Если ЗначениеЗаполнено(Объект.Док) тогда
				Для каждого Стр Из Объект.Док.Тара Цикл 
					Если Стр.Контейнер=Выборка.Ссылка Тогда
						С=1;
					КонецЕсли;
				КонецЦикла;
				Если С=0 Тогда
					ОбДок=Объект.Док.ПолучитьОбъект();
					СтрТ=ОбДок.Тара.Добавить() ;
					СтрТ.Контейнер=Выборка.Ссылка;
					ОбДок.Записать();
					Объект.Док=ОбДок.Ссылка;
					Объект.Тара.Очистить();
					Для каждого Стр Из Объект.Док.Тара Цикл
						СтрТ=Объект.Тара.Добавить();
						СтрТ.Контейнер=Стр.Контейнер;
					КонецЦикла;
				КонецЕсли;
			Иначе
				Сообщить("Не выбрана фактура");
			КонецЕсли;	 
		КонецЕсли;
	 ИначеЕсли Лев(Объект.ШК,3)="SOT" Или Лев(Объект.ШК,3)="sot" Или Лев(Объект.ШК,3)="ЫЩЕ"  Или Лев(Объект.ШК,3)="ыще"  тогда 
		 
	 Иначе 
		Объект.ШК=Лев(Объект.ШК,12); 
		ТД.Очистить();
		Док = НайденыйДок(Объект.ШК, ложь);
		Объект.Док=Док;
	ФФПроверитьНаЗаполнение();	
	Если ЗначениеЗаполнено(Объект.Док) Тогда
		Объект.Самовывоз=Объект.Док.Самовывоз;
		ПроверитьОстаткиПоКлиенту(Док);
		Объект.МестоОтгрузки="";
		Если Объект.Док.Получатель.ОтгружатьВТаре Тогда 
			Элементы.КолТара.Видимость=Истина;
			Объект.КолТара=Объект.Док.КолТара
		Иначе
			Элементы.КолТара.Видимость=Ложь;
			Объект.КолТара=0;
			
		КонецЕсли;	
		Объект.Тара.Очистить();
		Для каждого Стр Из Объект.Док.Тара Цикл
			СтрТ=Объект.Тара.Добавить();
			СтрТ.Контейнер=Стр.Контейнер;
		КонецЦикла;
	Иначе
		Сообщить("Сборка не нейдена");
	КонецЕсли;
	КонецЕсли;
	ТекущийЭлемент=Элементы.ШК;
КонецПроцедуры

&НаКлиенте
Процедура ДокПриИзменении(Элемент) 
	ТД.Очистить();
	ФФПроверитьНаЗаполнение();	
	ПроверитьОстаткиПоКлиенту(Объект.Док);
	Объект.Тара.Очистить();
			Для каждого Стр Из Объект.Док.Тара Цикл
				СтрТ=Объект.Тара.Добавить();
				СтрТ.Контейнер=Стр.Контейнер;
			КонецЦикла;
			Если Объект.Док.Получатель.ОтгружатьВТаре Тогда 
				Элементы.КолТара.Видимость=Истина;
				Объект.КолТара=Объект.Док.КолТара;
			Иначе
				Элементы.КолТара.Видимость=Ложь;
				Объект.КолТара=Объект.Док.КолТара;
			КонецЕсли;	
		
	ТекущийЭлемент=Элементы.ШК;
КонецПроцедуры



&НаКлиенте
Процедура ПоказатьТоварНаЯчейке(Команда)
	ТекЯчейка=ТД.ТекущаяОбласть;
	БукваМХ=ТД.ПолучитьОбласть(ТекЯчейка.Верх,1).ТекущаяОбласть.Текст;
	ЦифраМХ=ТД.ПолучитьОбласть(1,ТекЯчейка.Лево).ТекущаяОбласть.Текст;
	Если ЦифраМХ="сек-" тогда
		БукваМХ=ТД.ПолучитьОбласть(ТекЯчейка.Верх,16).ТекущаяОбласть.Текст;
		МХ=ЦифраМХ + БукваМХ;
	Иначе	
		МХ=БукваМХ + ЦифраМХ;
	КонецЕсли;
	
	П=Новый Структура;
	П.Вставить("НаименованиеМестаОтгрузки",МХ);
	ОткрытьФорму("Обработка.ЗонаОтгрузки.Форма.ФормаТоварНаЯчейке",П);
	ТекущийЭлемент=Элементы.ШК;
	
  КонецПроцедуры

&НаКлиенте
  Процедура ПоказатьТоварВЗонеОтгрузки(Команда)
	  ОткрытьФорму("Обработка.ЗонаОтгрузкиТаксист.Форма.ФормаТоварВЗонеОтгрузки");
  КонецПроцедуры

&НаКлиенте
  Процедура ВодительПриИзменении(Элемент)
	   НайтиДолгиПоЯщикам();
	   
  КонецПроцедуры
  Функция НайтиДолгиПоЯщикам()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДвижениеТарыВодительОстатки.УКого,
	               |	ДвижениеТарыВодительОстатки.Тара,
	               |	ДвижениеТарыВодительОстатки.Клиент,
	               |	ДвижениеТарыВодительОстатки.КолОстаток
	               |ИЗ
	               |	РегистрНакопления.ДвижениеТарыВодитель.Остатки(&Дата, ) КАК ДвижениеТарыВодительОстатки
	               |ГДЕ
	               |	ДвижениеТарыВодительОстатки.УКого = &УКого";
	
	Запрос.УстановитьПараметр("УКого",Водитель);
	Запрос.УстановитьПараметр("Дата",Объект.Дата);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Объект.ТараПЛ.Очистить();
	Пока Выборка.Следующий() Цикл
		Стр=Объект.ТараПЛ.Добавить();
		Стр.Клиент=Выборка.Клиент;
		Стр.Должен=Выборка.КолОстаток;
		Стр.Вернул=Выборка.КолОстаток;
		Стр.Остаток=0;
	КонецЦикла;
  КонецФункции

&НаКлиенте
  Процедура ТараПЛВернулПриИзменении(Элемент)
	  Стр=Элементы.ТараПЛ.ТекущиеДанные;
	  Стр.Остаток=Стр.Должен-Стр.Вернул;
  КонецПроцедуры

&НаКлиенте
  Процедура АктУтеря(Команда)
	  Стр=Элементы.ТараПЛ.ТекущиеДанные;
	  Док=Документы.АктУтеряТары.СоздатьДокумент();
	  Док.Дата=Объект.Дата;
	  Док.Клиент=Стр.Клиент;
	  Док.Водитель=Водитель;
	  Док.Тара="Ящик пластик";
	  Док.Количество=Стр.Остаток;
	  Док.Записать(РежимЗаписиДокумента.Запись);
	  ОткрытьЗначение(Док.Ссылка);
  КонецПроцедуры

&НаКлиенте
Процедура Обн(Команда)
	НайтиДолгиПоЯщикам();
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВсе(Команда)
	Для каждого Стр Из Объект.ТараПЛ Цикл
		Док=Документы.ВазвратТары.СоздатьДокумент();
		Док.Дата=Объект.Дата;
		Док.Клиент=Стр.Клиент;
		Док.Водитель=Водитель;
		Док.Тара="Ящик пластик";
		Док.Количество=Стр.Вернул;
		Док.Таксист=Таксист;
		Док.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	НаСкладе.Параметры.УстановитьЗначениеПараметра("Дата",Объект.Дата);
	ВАптеке.Параметры.УстановитьЗначениеПараметра("Дата",Объект.Дата);
	УВодителя.Параметры.УстановитьЗначениеПараметра("Дата",Объект.Дата);

КонецПроцедуры
  


