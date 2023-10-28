
Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ВКМ_ДополнительныеНачисления
	Движения.ВКМ_ДополнительныеНачисления.Записывать = Истина;
	Движения.ВКМ_Удержания.Записывать = Истина;  
	Движения.ВКМ_РасчетыССотрудниками.Записывать = Истина;

	Для Каждого ТекСтрокаНачисления Из Начисления Цикл
		Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();  
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.Премия;
		Движение.Сторно = Ложь;
		Движение.ПериодРегистрации = Дата;
		Движение.Сотрудник = ТекСтрокаНачисления.Сотрудник;
		Движение.Сумма = ТекСтрокаНачисления.Сумма;     
		
		СуммаНДФЛ = Окр(ТекСтрокаНачисления.Сумма*0.13,2);
		Движение = Движения.ВКМ_Удержания.Добавить();
		Движение.Сторно = Ложь;
		Движение.ПериодРегистрации = Дата;
		Движение.Сотрудник = ТекСтрокаНачисления.Сотрудник;
		Движение.Сумма = -СуммаНДФЛ; 
		
		Движение = Движения.ВКМ_РасчетыССотрудниками.ДобавитьРасход();
		Движение.Период = Дата;
		Движение.Сотрудник = ТекСтрокаНачисления.Сотрудник; 
		Движение.Сумма = ТекСтрокаНачисления.Сумма - СуммаНДФЛ;  
	КонецЦикла;
	
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры
