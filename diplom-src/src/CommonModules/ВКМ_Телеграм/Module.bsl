
//ironskills
Функция ОтправитьСообщениеВTelegram(ТекстСообщения) Экспорт
	
	Результат = Ложь;
	
	ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL;
	Соединение = Новый HTTPСоединение("api.telegram.org",,,,,30, ЗащищенноеСоединение); 
	
	Токен = Константы.ВКМ_ТелеграмТокенБота.Получить();
	ИдЧата = Константы.ВКМ_ТелеграмИДГруппы.Получить();
	
	АдресРесурса = СтрШаблон("/bot%1/sendMessage?chat_id=%2&text=%3",Токен, ИДЧата, ТекстСообщения);
	Запрос = Новый HTTPЗапрос(АдресРесурса);
	
	Попытка
		Ответ = Соединение.ВызватьHTTPМетод("GET", Запрос);
	Исключение
		Возврат Результат;
	КонецПопытки;
	
	Если Ответ.КодСостояния = 200 Тогда
		Результат = Истина;
	Иначе                                     
		Сообщение = Новый СообщениеПользователю;
		ТекстСообщенияОбОшибке = СтрШаблон("Не удалось отправить сообщение, код состояния: %1, ответ сервера: %2",
									Ответ.КодСостояния, Ответ.ПолучитьТелоКакСтроку());    
		Сообщение.Текст	= ТекстСообщенияОбОшибке;						
		Сообщение.Сообщить(); 
		
		ЗаписьЖурналаРегистрации("HTTPСервисы.Ошибка", УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщенияОбОшибке);
		
	КонецЕсли;    
	
	Возврат Результат;

КонецФункции 

Процедура ВКМ_УведомлениеТГ() Экспорт
	// Вставить содержимое обработчика.  
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_УведомленияТГБоту.Ссылка КАК Ссылка,
		|	ВКМ_УведомленияТГБоту.ТекстУведомления КАК ТекстУведомления
		|ИЗ
		|	Справочник.ВКМ_УведомленияТГБоту КАК ВКМ_УведомленияТГБоту";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи  
		Если ОтправитьСообщениеВTelegram(ВыборкаДетальныеЗаписи.ТекстУведомления) тогда
			ОбъектСпр = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ОбъектСпр.Удалить();
		КонецЕсли;	
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

КонецПроцедуры
