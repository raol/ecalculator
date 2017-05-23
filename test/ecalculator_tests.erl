-module(ecalculator_tests).

-include_lib("eunit/include/eunit.hrl").

simple_expressions_test() ->
    ?assertEqual(2, ecalculator:calculate([], "1 + 1")),
    ?assertEqual(7, ecalculator:calculate([], "1 + 2 * 3")),
    ?assertEqual(9, ecalculator:calculate([], "(1 + 2) * 3")).

variable_lookup_test() ->
    ?assertEqual(2, ecalculator:calculate([{a, 2}], "a")).

expression_with_var_test() ->
    ?assertEqual(3, ecalculator:calculate([{a, 2}], "1 + a")).

expression_compiled_test() ->
    ?assertEqual(3, ecalculator:calculate_compiled([{a, 2}], "1 + a")),
    ?assertEqual(7, ecalculator:calculate_compiled([], "1 + 2 * 3")),
    ?assertEqual(9, ecalculator:calculate_compiled([], "(1 + 2) * 3")).

compile_test() ->
    ?assertEqual([{push, 1}], ecalculator:compile({number, 1})),
    ?assertEqual([{fetch, a}], ecalculator:compile({var, a})),
    ?assertEqual([{push, 1}, {push, 2}, {add}], ecalculator:compile({add, {number, 1}, {number, 2}})),
    ?assertEqual([{push, 1}, {fetch, a}, {add}], ecalculator:compile({add, {number, 1}, {var, a}})),
    ?assertEqual([{push, 1}, {fetch, a}, {subtr}], ecalculator:compile({subtr, {number, 1}, {var, a}})).

run_test() -> 
    ?assertEqual(2, ecalculator:run([], [{push, 1}, {push, 1}, {add}])).