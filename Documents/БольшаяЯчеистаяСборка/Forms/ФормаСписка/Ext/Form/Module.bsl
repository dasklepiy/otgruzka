﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	масПодразделений= Новый Массив;
	Если РольДоступна("Разработчик") Тогда
		масПодразделений.Добавить("Асклепий");	
		масПодразделений.Добавить("НФС");	
	Иначе
		масПодразделений.Добавить( ПараметрыСеанса.ТекущийПользователь.Организация.Наименование);
	КонецЕсли;
	Список.Параметры.УстановитьЗначениеПараметра("Подразделение", масПодразделений);
	
КонецПроцедуры
