
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СтоимостьЧаса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор,"ВКМ_СтоимостьЧаса");
	СуммаДокумента = ВыполненныеРаботы.Итог("ЧасыКОплате") * СтоимостьЧаса;
	
	ТекстУведомления="";
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
	    ТекстУведомления = СтрШаблон("Создан новый документ обслуживания клиента %1:
		|дата и время %2 %3, сотрудник %4",
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент,"Наименование"),
		Формат(ДатаПроведенияРабот,"ДЛФ=D"), Формат(ВремяНачала,"ДЛФ=T"),
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Специалист,"Наименование"));
	иначе
		ЗначенияДоЗаписи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,"ДатаПроведенияРабот,ВремяНачала,Специалист");
		Если ЗначенияДоЗаписи.ДатаПроведенияРабот<>ДатаПроведенияРабот Тогда
		    ТекстУведомления = СтрШаблон("Изменена дата проведения работ в документе %1: было %2, стало %3",
			Номер, Формат(ЗначенияДоЗаписи.ДатаПроведенияРабот,"ДЛФ=D"), Формат(ДатаПроведенияРабот,"ДЛФ=D"));
		КонецЕсли;
		Если ЗначенияДоЗаписи.ВремяНачала<>ВремяНачала Тогда
		    ТекстУведомления = СтрШаблон("Изменено время начала проведения работ в документе %1: было %2, стало %3",
			Номер, Формат(ЗначенияДоЗаписи.ВремяНачала,"ДЛФ=T"), Формат(ВремяНачала,"ДЛФ=T"));
		КонецЕсли;
		Если ЗначенияДоЗаписи.Специалист<>Специалист Тогда
		    ТекстУведомления = СтрШаблон("Изменен специалист в документе %1: было %2, стало %3",
			Номер, ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначенияДоЗаписи.Специалист,"Наименование"),
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Специалист,"Наименование"));
		КонецЕсли;
	КонецЕсли; 
	Если НЕ ПустаяСтрока(ТекстУведомления) Тогда
	    СпрУвед = Справочники.ВКМ_УведомленияТГБоту.СоздатьЭлемент();
		СпрУвед.ТекстУведомления = ТекстУведомления;
		СпрУвед.Записать();
	КонецЕсли;
	
КонецПроцедуры     

Процедура ОбработкаПроведения(Отказ, Режим) 
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор,"ВидДоговора,ВКМ_ДатаНачала,ВКМ_ДатаОкончания");
	Если РеквизитыДоговора.ВидДоговора<>Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбонентскоеОбслуживание Тогда
	    ТекстПредупреждения = "В документе должен быть выбран договор абонентского обслуживания";
		ОбщегоНазначения.СообщитьПользователю(ТекстПредупреждения);
	    Отказ = Истина;
		возврат;
	КонецЕсли;

	Если РеквизитыДоговора.ВКМ_ДатаНачала>ДатаПроведенияРабот или РеквизитыДоговора.ВКМ_ДатаОкончания<ДатаПроведенияРабот Тогда
	    ТекстПредупреждения = "Дата работ не соответствует периоду действия договора";
		ОбщегоНазначения.СообщитьПользователю(ТекстПредупреждения);
	    Отказ = Истина;
		возврат;
	КонецЕсли;    
	
	ПроцентОплаты = ВКМ_РасчетЗП.ПроцентОтРабот(Специалист, ДатаПроведенияРабот);
	Если ПроцентОплаты=Неопределено тогда
	    ТекстПредупреждения = "Не задан сдельный процент специалиста на дату выполнения работ";
		ОбщегоНазначения.СообщитьПользователю(ТекстПредупреждения);
	    Отказ = Истина;
		возврат;
	КонецЕсли;    
		
	
	Движения.ВКМ_ВыполненныеКлиентуРаботы.Записывать = Истина; 
	Движения.ВКМ_ВыполненныеСотрудникомРаботы.Записывать = Истина; 
	
	Движение = Движения.ВКМ_ВыполненныеКлиентуРаботы.Добавить();
	Движение.Период = ДатаПроведенияРабот;
	Движение.Контрагент = Контрагент;    
	Движение.Договор = Договор;
    Движение.ЧасыКОплате = ВыполненныеРаботы.Итог("ЧасыКОплате");
	Движение.Сумма = СуммаДокумента;   
	
	Движение = Движения.ВКМ_ВыполненныеСотрудникомРаботы.Добавить();
	Движение.Период = ДатаПроведенияРабот;
	Движение.Сотрудник = Специалист;    
    Движение.ЧасыКОплате = ВыполненныеРаботы.Итог("ЧасыКОплате");
	Движение.Сумма = СуммаДокумента*ПроцентОплаты/100;   
	
	
КонецПроцедуры


