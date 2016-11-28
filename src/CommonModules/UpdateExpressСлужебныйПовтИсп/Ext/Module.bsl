﻿// This file is part of Update.Express.
// Copyright © 2016 Petro Bazeliuk.
// 
// Update.Express is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as 
// published by the Free Software Foundation, either version 3 
// of the License, or any later version.
// 
// Update.Express is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public 
// License along with Update.Express. If not, see <http://www.gnu.org/licenses/>.

#Область ПрограммныйИнтерфейс

// Функция определяет, входит ли указанный тип в используемые справочниками типы.
//
// Параметры:
//	ИмяТипа - Строка - строковое представление типа вхождение которого проверяется.
//
// Возвращаемое значение:
//	Булево - Истина - указанный тип входит в используемые типы; Ложь - в противном случае.	
//
Функция ЭтоТипСправочникСсылка(Знач ИмяТипа) Экспорт
	
	Возврат Справочники.ТипВсеСсылки().СодержитТип(Тип(ИмяТипа));	
КонецФункции // ЭтоТипСправочникСсылка()

// Функция определяет, входит ли указанный тип в используемые документами типы.
//
// Параметры:
//	ИмяТипа - Строка - строковое представление типа вхождение которого проверяется.
//
// Возвращаемое значение:
//	Булево - Истина - указанный тип входит в используемые типы; Ложь - в противном случае.	
//
Функция ЭтоТипДокументСсылка(Знач ИмяТипа) Экспорт	
	Возврат Документы.ТипВсеСсылки().СодержитТип(Тип(ИмяТипа));	
КонецФункции // ЭтоТипДокументСсылка()

// Функция определяет, входит ли указанный тип в используемые планами обмена типы.
//
// Параметры:
//	ИмяТипа - Строка - строковое представление типа вхождение которого проверяется.
//
// Возвращаемое значение:
//	Булево - Истина - указанный тип входит в используемые типы; Ложь - в противном случае.	
//
Функция ЭтоТипПланОбменаСсылка(Знач ИмяТипа) Экспорт	
	Возврат ПланыОбмена.ТипВсеСсылки().СодержитТип(Тип(ИмяТипа));	
КонецФункции // ЭтоТипПланОбменаСсылка()

// Функция определяет, входит ли указанный тип в используемые перечислением типы.
//
// Параметры:
//	ИмяТипа - Строка - строковое представление типа вхождение которого проверяется.
//
// Возвращаемое значение:
//	Булево - Истина - указанный тип входит в используемые типы; Ложь - в противном случае.	
//
Функция ЭтоТипПеречислениеСсылка(Знач ИмяТипа) Экспорт
	Возврат Перечисления.ТипВсеСсылки().СодержитТип(Тип(ИмяТипа));	
КонецФункции // ЭтоТипПеречислениеСсылка()

// Функция определяет, входит ли указанный тип в используемые планами видов характеристик типы.
//
// Параметры:
//	ИмяТипа - Строка - строковое представление типа вхождение которого проверяется.
//
// Возвращаемое значение:
//	Булево - Истина - указанный тип входит в используемые типы; Ложь - в противном случае.	
//
Функция ЭтоТипПланВидовХарактеристикСсылка(Знач ИмяТипа) Экспорт
	Возврат ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(Тип(ИмяТипа));	
КонецФункции // ЭтоТипПланВидовХарактеристикСсылка()

// Функция определяет, входит ли указанный тип в используемые планами счетов типы.
//
// Параметры:
//	ИмяТипа - Строка - строковое представление типа вхождение которого проверяется.
//
// Возвращаемое значение:
//	Булево - Истина - указанный тип входит в используемые типы; Ложь - в противном случае.	
//
Функция ЭтоТипПланСчетовСсылка(Знач ИмяТипа) Экспорт
	Возврат ПланыСчетов.ТипВсеСсылки().СодержитТип(Тип(ИмяТипа));	
КонецФункции // ЭтоТипПланСчетовСсылка()

// Функция определяет, входит ли указанный тип в используемые планами видов расчета типы.
//
// Параметры:
//	ИмяТипа - Строка - строковое представление типа вхождение которого проверяется.
//
// Возвращаемое значение:
//	Булево - Истина - указанный тип входит в используемые типы; Ложь - в противном случае.	
//
Функция ЭтоТипПланВидовРасчетаСсылка(Знач ИмяТипа) Экспорт
	Возврат ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(Тип(ИмяТипа));	
КонецФункции // ЭтоТипПланВидовРасчетаСсылка()

// Функция определяет, входит ли указанный тип в используемые бизнес процессами типы.
//
// Параметры:
//	ИмяТипа - Строка - строковое представление типа вхождение которого проверяется.
//
// Возвращаемое значение:
//	Булево - Истина - указанный тип входит в используемые типы; Ложь - в противном случае.	
//
Функция ЭтоТипБизнесПроцессСсылка(Знач ИмяТипа) Экспорт
	Возврат БизнесПроцессы.ТипВсеСсылки().СодержитТип(Тип(ИмяТипа));	
КонецФункции // ЭтоТипБизнесПроцессСсылка()

// Функция определяет, входит ли указанный тип в используемые задачами типы.
//
// Параметры:
//	ИмяТипа - Строка - строковое представление типа вхождение которого проверяется.
//
// Возвращаемое значение:
//	Булево - Истина - указанный тип входит в используемые типы; Ложь - в противном случае.	
//
Функция ЭтоТипЗадачаСсылка(Знач ИмяТипа) Экспорт
	Возврат Задачи.ТипВсеСсылки().СодержитТип(Тип(ИмяТипа));	
КонецФункции // ЭтоТипЗадачаСсылка()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СервисныеПроцедурыИФункции



#КонецОбласти // СервисныеПроцедурыИФункции