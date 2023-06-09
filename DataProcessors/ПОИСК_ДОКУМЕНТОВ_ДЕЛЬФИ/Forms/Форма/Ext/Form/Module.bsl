﻿
&НаКлиенте
Процедура Подключить(Команда)
	ПодключитьСервер();
КонецПроцедуры
&НаСервере
Процедура ПодключитьСервер()
	
	//----------------- АСКЛЕПИЙ ----------------------//
	Парам=Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
	//Парам.СтрокаСоединения="DRIVER={SQL Server};SERVER=SRVGLOB;UID=askabc;PWD=!QAZ2wsx;DATABASE=SergeliNew";
	Парам.СтрокаСоединения=Константы.СтрокаСоединения_SRVGLOB.Получить();
	ВнешИСТ=ВнешниеИсточникиДанных.SRVGLOB;
	ВнешИСТ.УстановитьОбщиеПараметрыСоединения(Парам);
	ВнешИСТ.УстановитьСоединение();
    Сообщить("АСК-"+ВнешИСТ.ПолучитьСостояние());		
	//------------------------------------------------//
	
	//----------------- НФС ОПТ ----------------------//
	Парам=Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
	Парам.СтрокаСоединения=Константы.СтрокаСоединения_НФС_ОПТ.Получить();
	ВнешИСТ=ВнешниеИсточникиДанных.NFS_OPT;
	ВнешИСТ.УстановитьОбщиеПараметрыСоединения(Парам);
	ВнешИСТ.УстановитьСоединение();
    Сообщить("НФС(опт)-"+ВнешИСТ.ПолучитьСостояние());		
	//------------------------------------------------//
	//----------------- НФС АПТ ----------------------//
	Парам=Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
	Парам.СтрокаСоединения=Константы.СтрокаСоединения_НФС_АПТ.Получить();
	ВнешИСТ=ВнешниеИсточникиДанных.NFS_APT;
	ВнешИСТ.УстановитьОбщиеПараметрыСоединения(Парам);
	ВнешИСТ.УстановитьСоединение();
    Сообщить("НФС(апт)-"+ВнешИСТ.ПолучитьСостояние());		
	//------------------------------------------------//

КонецПроцедуры


&НаКлиенте
Процедура Отключить(Команда)
	ОтключитьСервер();
КонецПроцедуры

&НаСервере
Процедура ОтключитьСервер()
ВнешниеИсточникиДанных.SRVGLOB.РазорватьСоединение();	
Сообщить("АСК-"+ВнешниеИсточникиДанных.SRVGLOB.ПолучитьСостояние());
ВнешниеИсточникиДанных.NFS_OPT.РазорватьСоединение();
Сообщить("НФС(опт)-"+ВнешниеИсточникиДанных.NFS_OPT.ПолучитьСостояние());
ВнешниеИсточникиДанных.NFS_APT.РазорватьСоединение();
Сообщить("НФС(опт)-"+ВнешниеИсточникиДанных.NFS_APT.ПолучитьСостояние());
КонецПроцедуры

&НаКлиенте
Процедура СостояниеСоединения(Команда)
	СостояниеСервер();
	
КонецПроцедуры
&НаСервере
Процедура СостояниеСервер()
Сообщить("АСК-"+ВнешниеИсточникиДанных.SRVGLOB.ПолучитьСостояние());
Сообщить("НФС(опт)-"+ВнешниеИсточникиДанных.NFS_OPT.ПолучитьСостояние());
Сообщить("НФС(опт)-"+ВнешниеИсточникиДанных.NFS_APT.ПолучитьСостояние());	
КонецПроцедуры


&НаКлиенте
Процедура НайтиСчетФ(Команда)
	
	НайтиСчетФСервер();
КонецПроцедуры
&НаСервере
Процедура  НайтиСчетФСервер()
	
	Если Организация="Асклепий" Тогда
		ВИ="SRVGLOB";
	ИначеЕсли  Организация="НФС(апт)" Тогда
		ВИ="NFS_APT"
	ИначеЕсли  Организация="НФС(опт)" Тогда
		ВИ="NFS_OPT"
	Иначе
		Сообщить("Организация не выбрана.");
		Возврат;
	КонецЕсли;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	dbo_INVOICE.InvoiceId,
		|	dbo_INVOICE.Number,
		|	dbo_INVOICE.BarCode как ШК
		|ИЗ
		|	ВнешнийИсточникДанных."+ВИ+".Таблица.dbo_INVOICE КАК dbo_INVOICE
		|ГДЕ
		|	dbo_INVOICE.Number = &СчетФ";

	Запрос.УстановитьПараметр("СчетФ", СчетФ);
    
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ТК.ДобавитьСтроку("СчетФ-"+СчетФ +"   "+ "ШК-"+ВыборкаДетальныеЗаписи.ШК);
		//Сообщить(ВыборкаДетальныеЗаписи.ШК);
	КонецЦикла;

	
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиШК(Команда)
	НайтиШКСервер();
КонецПроцедуры

&НаСервере
Процедура НайтиШКСервер()
	
	Если Организация="Асклепий" Тогда
		ВИ="SRVGLOB";
	ИначеЕсли  Организация="НФС(апт)" Тогда
		ВИ="NFS_APT"
	ИначеЕсли  Организация="НФС(опт)" Тогда
		ВИ="NFS_OPT"
	Иначе
		Сообщить("Организация не выбрана.");
		Возврат;
	
	КонецЕсли;

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	dbo_INVOICE.Number КАК СчетФ
		|ИЗ
		|	ВнешнийИсточникДанных."+ВИ+".Таблица.dbo_INVOICE КАК dbo_INVOICE
		|ГДЕ
		|	dbo_INVOICE.BarCode = &BarCode";

		//ШК="";
	Запрос.УстановитьПараметр("BarCode", ШК);

	Результат = Запрос.Выполнить();
	//ТЗ=Результат.Выгрузить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ТК.ДобавитьСтроку(ВыборкаДетальныеЗаписи.СчетФ);
	КонецЦикла;



КонецПроцедуры


