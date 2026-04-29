:- encoding(utf8).
:- consult('knowledge_base.pl').

%  Наблюдение симптомов 
clear_observations :-
    retractall(observed(_)).

observe(S) :-
    symptom(S),
    (observed(S) -> true ; assertz(observed(S))).

set_observations(Symptoms) :-
    clear_observations,
    maplist(observe, Symptoms).

observed_list(List) :-
    findall(S, observed(S), List).

%  NAF-признак: отсутствует симптом 
missing(S) :-
    symptom(S),
    \+ observed(S).

%  Сырые баллы диагноза 
diagnosis_score(D, Score) :-
    diagnosis(D),
    findall(W, (observed(S), weight(D, S, W)), Weights),
    sum_list(Weights, Score).

total_weight(D, Total) :-
    findall(W, weight(D, _, W), Weights),
    sum_list(Weights, Total).

% Уверенность (0..100): доля набранного веса
diagnosis_confidence(D, Confidence) :-
    diagnosis_score(D, Score),
    total_weight(D, Total),
    Total > 0,
    Confidence is (Score * 100) // Total.

% Диагноз считается релевантным, если балл >= порога
diagnosis_threshold(4).

diagnosis_result(D, Score, Confidence) :-
    diagnosis_score(D, Score),
    diagnosis_threshold(T),
    Score >= T,
    diagnosis_confidence(D, Confidence).

% Объяснение: какие симптомы "за", какие ожидаемые не наблюдаются
explain(D, explanation(D, matched(Matched), missing(Missing), score(Score), confidence(Confidence))) :-
    diagnosis(D),
    findall(S, (observed(S), weight(D, S, _)), Matched),
    findall(S, (weight(D, S, _), \+ observed(S)), Missing),
    diagnosis_score(D, Score),
    diagnosis_confidence(D, Confidence).

% Лучшая гипотеза по максимальному баллу
best_diagnosis(D, Score, Confidence) :-
    findall(Score1-D1, diagnosis_score(D1, Score1), Pairs),
    keysort(Pairs, Sorted),
    reverse(Sorted, [Score-D|_]),
    diagnosis_confidence(D, Confidence).

%  Валидация БЗ (уровень 2) 
% Полнота: каждый симптом влияет хотя бы на один диагноз
coverage_issues(UncoveredSymptoms) :-
    findall(S, (symptom(S), \+ weight(_, S, _)), UncoveredSymptoms).

is_complete_coverage :-
    coverage_issues([]).

% Непротиворечивость для текущих наблюдений: несовместимые диагнозы не должны одновременно иметь высокую уверенность
inconsistency(DA, DB, CA, CB) :-
    incompatible(DA, DB),
    diagnosis_confidence(DA, CA),
    diagnosis_confidence(DB, CB),
    CA >= 60,
    CB >= 60.

is_consistent :-
    \+ inconsistency(_, _, _, _).

% Утилита для красивого отчета
print_report :-
    observed_list(Obs),
    format('Наблюдаемые симптомы: ~w~n', [Obs]),
    forall(diagnosis_result(D, S, C),
           format('~w -> score=~w, confidence=~w%~n', [D, S, C])),
    ( best_diagnosis(BD, BS, BC) ->
        format('Лучшая гипотеза: ~w (score=~w, confidence=~w%)~n', [BD, BS, BC])
    ;   writeln('Нет подходящего диагноза по текущему порогу.')
    ),
    ( is_consistent ->
        writeln('Проверка непротиворечивости: OK')
    ;   writeln('Проверка непротиворечивости: найдены конфликтующие гипотезы')
    ).

