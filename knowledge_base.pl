:- encoding(utf8).
:- dynamic observed/1.

% Сущности (симптомы)
symptom(кашель).
symptom(температура).
symptom(озноб).
symptom(одышка).
symptom(боль_в_горле).
symptom(насморк).
symptom(потеря_вкуса).
symptom(утомляемость).
symptom(боль_в_груди).
symptom(головная_боль).
symptom(хрипы).
symptom(чихание).

% Диагнозы
diagnosis(простуда).
diagnosis(грипп).
diagnosis(covid19).
diagnosis(бронхит).
diagnosis(пневмония).

% Базовые веса симптомов для диагнозов
% weight(Диагноз, Симптом, Вес).
weight(простуда, насморк, 3).
weight(простуда, боль_в_горле, 2).
weight(простуда, кашель, 2).
weight(простуда, чихание, 2).
weight(простуда, температура, 1).

weight(грипп, температура, 3).
weight(грипп, озноб, 3).
weight(грипп, головная_боль, 2).
weight(грипп, утомляемость, 2).
weight(грипп, кашель, 1).

weight(covid19, температура, 2).
weight(covid19, кашель, 2).
weight(covid19, одышка, 3).
weight(covid19, потеря_вкуса, 4).
weight(covid19, утомляемость, 1).

weight(бронхит, кашель, 3).
weight(бронхит, хрипы, 3).
weight(бронхит, боль_в_груди, 2).
weight(бронхит, температура, 1).
weight(бронхит, утомляемость, 1).

weight(пневмония, температура, 3).
weight(пневмония, одышка, 3).
weight(пневмония, боль_в_груди, 2).
weight(пневмония, кашель, 2).
weight(пневмония, озноб, 2).

% Несовместимые диагнозы для валидации
incompatible(простуда, пневмония).
incompatible(пневмония, простуда).
incompatible(простуда, covid19).
incompatible(covid19, простуда).

