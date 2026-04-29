:- encoding(utf8).
:- consult('inference.pl').

run_case(Name, Symptoms) :-
    format('~n=== ~w ===~n', [Name]),
    set_observations(Symptoms),
    print_report.

run_all_cases :-
    run_case('Кейс 1: Простуда', [насморк, боль_в_горле, кашель, чихание]),
    run_case('Кейс 2: Грипп', [температура, озноб, головная_боль, утомляемость]),
    run_case('Кейс 3: COVID-19', [температура, кашель, одышка, потеря_вкуса]),
    run_case('Кейс 4: Бронхит', [кашель, хрипы, боль_в_груди, утомляемость]),
    run_case('Кейс 5: Пневмония', [температура, одышка, боль_в_груди, кашель, озноб]).

% Примеры точечных запросов:
% ?- set_observations([температура,кашель,потеря_вкуса,одышка]), best_diagnosis(D,S,C).
% ?- set_observations([температура,озноб,головная_боль]), explain(грипп, E).
% ?- coverage_issues(U).
% ?- run_all_cases.

