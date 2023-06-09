﻿
&НаКлиенте
Процедура ПолучитьИсториюШК(Команда)
	ПолучитьИсториюШКСЕРВЕР();
КонецПроцедуры

&НаСервере
Процедура ПолучитьИсториюШКСЕРВЕР()
	
	ТЗисторияШК=модСерверПолныеПрава.ПолучитьИсториюШК(НомерСФ,ДатаСФ,Организация);
	
	Если  ТЗисторияШК=Неопределено Тогда
		Сообщить("Для "+НомерСФ+" "+ДатаСФ+" "+Организация+" - Нет Данных");
		Возврат;
	КонецЕсли;
	
ТК.ДобавитьСтроку("=== "+НомерСФ+" "+ДатаСФ+" "+Организация+" ===");		
	Для Каждого стр Из ТЗисторияШК Цикл
	ТК.ДобавитьСтроку("Дата-"+стр.Дата+Символы.Таб+" ШК - "+стр.ШК);	
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(Параметры.НомерСФ) Тогда
		НомерСФ=Параметры.НомерСФ;	
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.ДатаСФ) Тогда
		ДатаСФ=Параметры.ДатаСФ;	
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Организация=Параметры.Организация;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НомерСФ) 
		И ЗначениеЗаполнено(Параметры.ДатаСФ)
		И  ЗначениеЗаполнено(Параметры.Организация) Тогда
		
		ПолучитьИсториюШКСЕРВЕР();
	КонецЕсли;
		
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	ТК.Очистить();
КонецПроцедуры
